#include "net.h"

#include "defs.h"
#include "file.h"
#include "fs.h"
#include "memlayout.h"
#include "param.h"
#include "proc.h"
#include "riscv.h"
#include "sleeplock.h"
#include "spinlock.h"
#include "types.h"

// xv6's ethernet and IP addresses
static uint8 local_mac[ETHADDR_LEN] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
static uint32 local_ip = MAKE_IP_ADDR(10, 0, 2, 15);

// qemu host's ethernet address.
static uint8 host_mac[ETHADDR_LEN] = {0x52, 0x55, 0x0a, 0x00, 0x02, 0x02};

static struct spinlock netlock;

struct packet_info {
  char *data;
  int len;
  uint32 ip_addr;
  uint16 sport;
};

#define PORT_BUFFER_SIZE 16
struct port_buffer {
  struct packet_info packet_queue[PORT_BUFFER_SIZE];
  uint8 count;
  uint8 ind;
  uint8 init;
  struct spinlock port_buf_lock;
};

#define PORTS_COUNT 2049
static struct port_buffer ports[PORTS_COUNT];

void netinit(void) {
  // initialize network here
  initlock(&netlock, "netlock");
  memset(ports, 0, sizeof(ports));
  for (int i = 0; i < PORTS_COUNT; i++) {
    initlock(&ports[i].port_buf_lock, "port_buf_lock");
  }
}

//
// bind(int port)
// prepare to receive UDP packets address to the port,
// i.e. allocate any queues &c needed.
//
uint64 sys_bind(void) {
  int port;
  argint(0, &port);

  struct port_buffer *buf = &ports[port];

  acquire(&buf->port_buf_lock);

  if (buf->init) {
    release(&buf->port_buf_lock);
    return -1;
  }
  buf->count = 0;
  buf->ind = 0;
  buf->init = 1;

  release(&buf->port_buf_lock);
  return 0;
}

//
// unbind(int port)
// release any resources previously created by bind(port);
// from now on UDP packets addressed to port should be dropped.
//
uint64 sys_unbind(void) {
  int port, i;
  argint(0, &port);

  struct port_buffer *port_buf = &ports[port];

  acquire(&port_buf->port_buf_lock);

  if (!port_buf->init) {
    release(&port_buf->port_buf_lock);
    return -1;
  }

  for (i = 0; i < PORT_BUFFER_SIZE; i++) {
    if (port_buf->packet_queue[i].data) {
      kfree(port_buf->packet_queue[i].data);
      port_buf->packet_queue[i].data = 0;
    }
  }
  port_buf->init = 0;

  wakeup(port_buf);

  release(&port_buf->port_buf_lock);

  return 0;
}

//
// recv(int dport, int *src, short *sport, char *buf, int maxlen)
// if there's a received UDP packet already queued that was
// addressed to dport, then return it.
// otherwise wait for such a packet.
//
// sets *src to the IP source address.
// sets *sport to the UDP source port.
// copies up to maxlen bytes of UDP payload to buf.
// returns the number of bytes copied,
// and -1 if there was an error.
//
// dport, *src, and *sport are host byte order.
// bind(dport) must previously have been called.
//
uint64 sys_recv(void) {
  int dport;
  uint64 srcaddr;
  uint64 sportaddr;
  uint64 bufaddr;
  int maxlen;

  argint(0, &dport);
  argaddr(1, &srcaddr);
  argaddr(2, &sportaddr);
  argaddr(3, &bufaddr);
  argint(4, &maxlen);

  struct port_buffer *port_buf = &ports[dport];
  acquire(&port_buf->port_buf_lock);

  while (port_buf->init && port_buf->count == 0) {
    sleep(port_buf, &port_buf->port_buf_lock);
  }

  if (!port_buf->init) {
    release(&port_buf->port_buf_lock);
    return -1;
  }

  struct packet_info *packet_info = &port_buf->packet_queue[port_buf->ind];

  int copy_len = (maxlen < packet_info->len) ? maxlen : packet_info->len;

  uint32 src_ip = packet_info->ip_addr;
  uint16 src_port = packet_info->sport;

  struct proc *p = myproc();
  if (copyout(p->pagetable, srcaddr, (char *)&src_ip, sizeof(src_ip)) < 0 ||
      copyout(p->pagetable, sportaddr, (char *)&src_port, sizeof(src_port)) <
          0 ||
      copyout(p->pagetable, bufaddr, packet_info->data, copy_len) < 0) {
    release(&port_buf->port_buf_lock);
    return -1;
  }

  kfree(packet_info->data);
  packet_info->data = 0;
  port_buf->ind = (port_buf->ind + 1) % PORT_BUFFER_SIZE;
  port_buf->count--;

  release(&port_buf->port_buf_lock);
  return copy_len;
}

// This code is lifted from FreeBSD's ping.c, and is copyright by the Regents
// of the University of California.
static unsigned short in_cksum(const unsigned char *addr, int len) {
  int nleft = len;
  const unsigned short *w = (const unsigned short *)addr;
  unsigned int sum = 0;
  unsigned short answer = 0;

  /*
   * Our algorithm is simple, using a 32 bit accumulator (sum), we add
   * sequential 16 bit words to it, and at the end, fold back all the
   * carry bits from the top 16 bits into the lower 16 bits.
   */
  while (nleft > 1) {
    sum += *w++;
    nleft -= 2;
  }

  /* mop up an odd byte, if necessary */
  if (nleft == 1) {
    *(unsigned char *)(&answer) = *(const unsigned char *)w;
    sum += answer;
  }

  /* add back carry outs from top 16 bits to low 16 bits */
  sum = (sum & 0xffff) + (sum >> 16);
  sum += (sum >> 16);
  /* guaranteed now that the lower 16 bits of sum are correct */

  answer = ~sum; /* truncate to 16 bits */
  return answer;
}

//
// send(int sport, int dst, int dport, char *buf, int len)
//
uint64 sys_send(void) {
  struct proc *p = myproc();
  int sport;
  int dst;
  int dport;
  uint64 bufaddr;
  int len;

  argint(0, &sport);
  argint(1, &dst);
  argint(2, &dport);
  argaddr(3, &bufaddr);
  argint(4, &len);

  int total = len + sizeof(struct eth) + sizeof(struct ip) + sizeof(struct udp);
  if (total > PGSIZE) return -1;

  char *buf = kalloc();
  if (buf == 0) {
    printf("sys_send: kalloc failed\n");
    return -1;
  }
  memset(buf, 0, PGSIZE);

  struct eth *eth = (struct eth *)buf;
  memmove(eth->dhost, host_mac, ETHADDR_LEN);
  memmove(eth->shost, local_mac, ETHADDR_LEN);
  eth->type = htons(ETHTYPE_IP);

  struct ip *ip = (struct ip *)(eth + 1);
  ip->ip_vhl = 0x45;  // version 4, header length 4*5
  ip->ip_tos = 0;
  ip->ip_len = htons(sizeof(struct ip) + sizeof(struct udp) + len);
  ip->ip_id = 0;
  ip->ip_off = 0;
  ip->ip_ttl = 100;
  ip->ip_p = IPPROTO_UDP;
  ip->ip_src = htonl(local_ip);
  ip->ip_dst = htonl(dst);
  ip->ip_sum = in_cksum((unsigned char *)ip, sizeof(*ip));

  struct udp *udp = (struct udp *)(ip + 1);
  udp->sport = htons(sport);
  udp->dport = htons(dport);
  udp->ulen = htons(len + sizeof(struct udp));

  char *payload = (char *)(udp + 1);
  if (copyin(p->pagetable, payload, bufaddr, len) < 0) {
    kfree(buf);
    printf("send: copyin failed\n");
    return -1;
  }

  e1000_transmit(buf, total);

  return 0;
}

void udp_rx(char *buf, int len) {
  struct ip *ip = (struct ip *)((struct eth *)buf + 1);
  struct udp *udp = (struct udp *)(ip + 1);

  uint16 port = ntohs(udp->dport);
  struct port_buffer *port_buf = &ports[port];

  acquire(&port_buf->port_buf_lock);
  if (!port_buf->init || port_buf->count >= PORT_BUFFER_SIZE) {
    release(&port_buf->port_buf_lock);
    return;
  }

  int payload_len = ntohs(udp->ulen) - sizeof(struct udp);

  if (payload_len <= 0) {
    release(&port_buf->port_buf_lock);
    return;
  }

  char *data = (char *)(udp + 1);
  char *newbuf = kalloc();
  if (!newbuf) {
    release(&port_buf->port_buf_lock);
    return;
  }

  memmove(newbuf, data, payload_len);

  struct packet_info *packet_info =
      &port_buf
           ->packet_queue[(port_buf->ind + port_buf->count) % PORT_BUFFER_SIZE];

  packet_info->data = newbuf;
  packet_info->len = payload_len;
  packet_info->ip_addr = ntohl(ip->ip_src);
  packet_info->sport = ntohs(udp->sport);
  port_buf->count++;

  wakeup(port_buf);

  release(&port_buf->port_buf_lock);
}

void ip_rx(char *buf, int len) {
  // don't delete this printf
  static int seen_ip = 0;
  if (seen_ip == 0) printf("ip_rx: received an IP packet\n");
  seen_ip = 1;

  int headers_size =
      sizeof(struct eth) + sizeof(struct ip) + sizeof(struct udp);

  if (len < headers_size) {
    return;
  }

  struct ip *ip = (struct ip *)((struct eth *)buf + 1);

  // UDP = 17
  if (ip->ip_p == 17) {
    udp_rx(buf, len);
  }
}

//
// send an ARP reply packet to tell qemu to map
// xv6's ip address to its ethernet address.
// this is the bare minimum needed to persuade
// qemu to send IP packets to xv6; the real ARP
// protocol is more complex.
//
void arp_rx(char *inbuf) {
  static int seen_arp = 0;

  if (seen_arp) {
    return;
  }
  printf("arp_rx: received an ARP packet\n");
  seen_arp = 1;

  struct eth *ineth = (struct eth *)inbuf;
  struct arp *inarp = (struct arp *)(ineth + 1);

  char *buf = kalloc();
  if (buf == 0) panic("send_arp_reply");

  struct eth *eth = (struct eth *)buf;
  memmove(eth->dhost, ineth->shost,
          ETHADDR_LEN);  // ethernet destination = query source
  memmove(eth->shost, local_mac,
          ETHADDR_LEN);  // ethernet source = xv6's ethernet address
  eth->type = htons(ETHTYPE_ARP);

  struct arp *arp = (struct arp *)(eth + 1);
  arp->hrd = htons(ARP_HRD_ETHER);
  arp->pro = htons(ETHTYPE_IP);
  arp->hln = ETHADDR_LEN;
  arp->pln = sizeof(uint32);
  arp->op = htons(ARP_OP_REPLY);

  memmove(arp->sha, local_mac, ETHADDR_LEN);
  arp->sip = htonl(local_ip);
  memmove(arp->tha, ineth->shost, ETHADDR_LEN);
  arp->tip = inarp->sip;

  e1000_transmit(buf, sizeof(*eth) + sizeof(*arp));
}

void net_rx(char *buf, int len) {
  struct eth *eth = (struct eth *)buf;

  if (len >= sizeof(struct eth) + sizeof(struct arp) &&
      ntohs(eth->type) == ETHTYPE_ARP) {
    arp_rx(buf);
  } else if (len >= sizeof(struct eth) + sizeof(struct ip) &&
             ntohs(eth->type) == ETHTYPE_IP) {
    ip_rx(buf, len);
  }
  kfree(buf);
}
