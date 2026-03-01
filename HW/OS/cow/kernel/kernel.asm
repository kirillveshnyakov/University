
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	91013103          	ld	sp,-1776(sp) # 80008910 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	1e3050ef          	jal	ra,800059f8 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <ref_change>:
struct {
  struct spinlock lock;
  int ref[PAGESCOUNT];
} references;

int ref_change(uint64 pa, int value) {
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
    80000028:	84aa                	mv	s1,a0
    8000002a:	892e                	mv	s2,a1
  acquire(&references.lock);
    8000002c:	00009517          	auipc	a0,0x9
    80000030:	95450513          	addi	a0,a0,-1708 # 80008980 <references>
    80000034:	00006097          	auipc	ra,0x6
    80000038:	3b0080e7          	jalr	944(ra) # 800063e4 <acquire>
  references.ref[pa] += value;
    8000003c:	00009517          	auipc	a0,0x9
    80000040:	94450513          	addi	a0,a0,-1724 # 80008980 <references>
    80000044:	00448793          	addi	a5,s1,4
    80000048:	078a                	slli	a5,a5,0x2
    8000004a:	97aa                	add	a5,a5,a0
    8000004c:	4798                	lw	a4,8(a5)
    8000004e:	012705bb          	addw	a1,a4,s2
    80000052:	0005849b          	sext.w	s1,a1
    80000056:	c78c                	sw	a1,8(a5)
  int refs = references.ref[pa];
  release(&references.lock);
    80000058:	00006097          	auipc	ra,0x6
    8000005c:	440080e7          	jalr	1088(ra) # 80006498 <release>
  return refs;
}
    80000060:	8526                	mv	a0,s1
    80000062:	60e2                	ld	ra,24(sp)
    80000064:	6442                	ld	s0,16(sp)
    80000066:	64a2                	ld	s1,8(sp)
    80000068:	6902                	ld	s2,0(sp)
    8000006a:	6105                	addi	sp,sp,32
    8000006c:	8082                	ret

000000008000006e <kfree>:

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa) {
    8000006e:	1101                	addi	sp,sp,-32
    80000070:	ec06                	sd	ra,24(sp)
    80000072:	e822                	sd	s0,16(sp)
    80000074:	e426                	sd	s1,8(sp)
    80000076:	e04a                	sd	s2,0(sp)
    80000078:	1000                	addi	s0,sp,32
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    8000007a:	03451793          	slli	a5,a0,0x34
    8000007e:	ef9d                	bnez	a5,800000bc <kfree+0x4e>
    80000080:	84aa                	mv	s1,a0
    80000082:	00042797          	auipc	a5,0x42
    80000086:	d6e78793          	addi	a5,a5,-658 # 80041df0 <end>
    8000008a:	02f56963          	bltu	a0,a5,800000bc <kfree+0x4e>
    8000008e:	47c5                	li	a5,17
    80000090:	07ee                	slli	a5,a5,0x1b
    80000092:	02f57563          	bgeu	a0,a5,800000bc <kfree+0x4e>
    panic("kfree");

  if (ref_change(GETPAGENUM((uint64)pa), -1) > 0) {
    80000096:	757d                	lui	a0,0xfffff
    80000098:	8d65                	and	a0,a0,s1
    8000009a:	800007b7          	lui	a5,0x80000
    8000009e:	953e                	add	a0,a0,a5
    800000a0:	55fd                	li	a1,-1
    800000a2:	8131                	srli	a0,a0,0xc
    800000a4:	00000097          	auipc	ra,0x0
    800000a8:	f78080e7          	jalr	-136(ra) # 8000001c <ref_change>
    800000ac:	02a05063          	blez	a0,800000cc <kfree+0x5e>

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}
    800000b0:	60e2                	ld	ra,24(sp)
    800000b2:	6442                	ld	s0,16(sp)
    800000b4:	64a2                	ld	s1,8(sp)
    800000b6:	6902                	ld	s2,0(sp)
    800000b8:	6105                	addi	sp,sp,32
    800000ba:	8082                	ret
    panic("kfree");
    800000bc:	00008517          	auipc	a0,0x8
    800000c0:	f5450513          	addi	a0,a0,-172 # 80008010 <etext+0x10>
    800000c4:	00006097          	auipc	ra,0x6
    800000c8:	de8080e7          	jalr	-536(ra) # 80005eac <panic>
  memset(pa, 1, PGSIZE);
    800000cc:	6605                	lui	a2,0x1
    800000ce:	4585                	li	a1,1
    800000d0:	8526                	mv	a0,s1
    800000d2:	00000097          	auipc	ra,0x0
    800000d6:	14a080e7          	jalr	330(ra) # 8000021c <memset>
  acquire(&kmem.lock);
    800000da:	00009917          	auipc	s2,0x9
    800000de:	88690913          	addi	s2,s2,-1914 # 80008960 <kmem>
    800000e2:	854a                	mv	a0,s2
    800000e4:	00006097          	auipc	ra,0x6
    800000e8:	300080e7          	jalr	768(ra) # 800063e4 <acquire>
  r->next = kmem.freelist;
    800000ec:	01893783          	ld	a5,24(s2)
    800000f0:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800000f2:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    800000f6:	854a                	mv	a0,s2
    800000f8:	00006097          	auipc	ra,0x6
    800000fc:	3a0080e7          	jalr	928(ra) # 80006498 <release>
    80000100:	bf45                	j	800000b0 <kfree+0x42>

0000000080000102 <freerange>:
void freerange(void *pa_start, void *pa_end) {
    80000102:	7179                	addi	sp,sp,-48
    80000104:	f406                	sd	ra,40(sp)
    80000106:	f022                	sd	s0,32(sp)
    80000108:	ec26                	sd	s1,24(sp)
    8000010a:	e84a                	sd	s2,16(sp)
    8000010c:	e44e                	sd	s3,8(sp)
    8000010e:	e052                	sd	s4,0(sp)
    80000110:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    80000112:	6785                	lui	a5,0x1
    80000114:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000118:	00e504b3          	add	s1,a0,a4
    8000011c:	777d                	lui	a4,0xfffff
    8000011e:	8cf9                	and	s1,s1,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE) kfree(p);
    80000120:	94be                	add	s1,s1,a5
    80000122:	0095ee63          	bltu	a1,s1,8000013e <freerange+0x3c>
    80000126:	892e                	mv	s2,a1
    80000128:	7a7d                	lui	s4,0xfffff
    8000012a:	6985                	lui	s3,0x1
    8000012c:	01448533          	add	a0,s1,s4
    80000130:	00000097          	auipc	ra,0x0
    80000134:	f3e080e7          	jalr	-194(ra) # 8000006e <kfree>
    80000138:	94ce                	add	s1,s1,s3
    8000013a:	fe9979e3          	bgeu	s2,s1,8000012c <freerange+0x2a>
}
    8000013e:	70a2                	ld	ra,40(sp)
    80000140:	7402                	ld	s0,32(sp)
    80000142:	64e2                	ld	s1,24(sp)
    80000144:	6942                	ld	s2,16(sp)
    80000146:	69a2                	ld	s3,8(sp)
    80000148:	6a02                	ld	s4,0(sp)
    8000014a:	6145                	addi	sp,sp,48
    8000014c:	8082                	ret

000000008000014e <kinit>:
void kinit() {
    8000014e:	1141                	addi	sp,sp,-16
    80000150:	e406                	sd	ra,8(sp)
    80000152:	e022                	sd	s0,0(sp)
    80000154:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000156:	00008597          	auipc	a1,0x8
    8000015a:	ec258593          	addi	a1,a1,-318 # 80008018 <etext+0x18>
    8000015e:	00009517          	auipc	a0,0x9
    80000162:	80250513          	addi	a0,a0,-2046 # 80008960 <kmem>
    80000166:	00006097          	auipc	ra,0x6
    8000016a:	1ee080e7          	jalr	494(ra) # 80006354 <initlock>
  initlock(&references.lock, "references");
    8000016e:	00008597          	auipc	a1,0x8
    80000172:	eb258593          	addi	a1,a1,-334 # 80008020 <etext+0x20>
    80000176:	00009517          	auipc	a0,0x9
    8000017a:	80a50513          	addi	a0,a0,-2038 # 80008980 <references>
    8000017e:	00006097          	auipc	ra,0x6
    80000182:	1d6080e7          	jalr	470(ra) # 80006354 <initlock>
  freerange(end, (void *)PHYSTOP);
    80000186:	45c5                	li	a1,17
    80000188:	05ee                	slli	a1,a1,0x1b
    8000018a:	00042517          	auipc	a0,0x42
    8000018e:	c6650513          	addi	a0,a0,-922 # 80041df0 <end>
    80000192:	00000097          	auipc	ra,0x0
    80000196:	f70080e7          	jalr	-144(ra) # 80000102 <freerange>
}
    8000019a:	60a2                	ld	ra,8(sp)
    8000019c:	6402                	ld	s0,0(sp)
    8000019e:	0141                	addi	sp,sp,16
    800001a0:	8082                	ret

00000000800001a2 <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc(void) {
    800001a2:	1101                	addi	sp,sp,-32
    800001a4:	ec06                	sd	ra,24(sp)
    800001a6:	e822                	sd	s0,16(sp)
    800001a8:	e426                	sd	s1,8(sp)
    800001aa:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    800001ac:	00008497          	auipc	s1,0x8
    800001b0:	7b448493          	addi	s1,s1,1972 # 80008960 <kmem>
    800001b4:	8526                	mv	a0,s1
    800001b6:	00006097          	auipc	ra,0x6
    800001ba:	22e080e7          	jalr	558(ra) # 800063e4 <acquire>
  r = kmem.freelist;
    800001be:	6c84                	ld	s1,24(s1)
  if (r) kmem.freelist = r->next;
    800001c0:	c4a9                	beqz	s1,8000020a <kalloc+0x68>
    800001c2:	609c                	ld	a5,0(s1)
    800001c4:	00008517          	auipc	a0,0x8
    800001c8:	79c50513          	addi	a0,a0,1948 # 80008960 <kmem>
    800001cc:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    800001ce:	00006097          	auipc	ra,0x6
    800001d2:	2ca080e7          	jalr	714(ra) # 80006498 <release>

  if (r){
    memset((char *)r, 5, PGSIZE);  // fill with junk
    800001d6:	6605                	lui	a2,0x1
    800001d8:	4595                	li	a1,5
    800001da:	8526                	mv	a0,s1
    800001dc:	00000097          	auipc	ra,0x0
    800001e0:	040080e7          	jalr	64(ra) # 8000021c <memset>
    references.ref[GETPAGENUM((uint64)r)] = 1;
    800001e4:	77fd                	lui	a5,0xfffff
    800001e6:	8fe5                	and	a5,a5,s1
    800001e8:	80000737          	lui	a4,0x80000
    800001ec:	97ba                	add	a5,a5,a4
    800001ee:	83a9                	srli	a5,a5,0xa
    800001f0:	00008717          	auipc	a4,0x8
    800001f4:	7a070713          	addi	a4,a4,1952 # 80008990 <references+0x10>
    800001f8:	97ba                	add	a5,a5,a4
    800001fa:	4705                	li	a4,1
    800001fc:	c798                	sw	a4,8(a5)
  } 
  // references.ref[GETPAGENUM((uint64)r)] = 1;
  return (void *)r;
}
    800001fe:	8526                	mv	a0,s1
    80000200:	60e2                	ld	ra,24(sp)
    80000202:	6442                	ld	s0,16(sp)
    80000204:	64a2                	ld	s1,8(sp)
    80000206:	6105                	addi	sp,sp,32
    80000208:	8082                	ret
  release(&kmem.lock);
    8000020a:	00008517          	auipc	a0,0x8
    8000020e:	75650513          	addi	a0,a0,1878 # 80008960 <kmem>
    80000212:	00006097          	auipc	ra,0x6
    80000216:	286080e7          	jalr	646(ra) # 80006498 <release>
  if (r){
    8000021a:	b7d5                	j	800001fe <kalloc+0x5c>

000000008000021c <memset>:
#include "types.h"

void *memset(void *dst, int c, uint n) {
    8000021c:	1141                	addi	sp,sp,-16
    8000021e:	e422                	sd	s0,8(sp)
    80000220:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    80000222:	ca19                	beqz	a2,80000238 <memset+0x1c>
    80000224:	87aa                	mv	a5,a0
    80000226:	1602                	slli	a2,a2,0x20
    80000228:	9201                	srli	a2,a2,0x20
    8000022a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000022e:	00b78023          	sb	a1,0(a5) # fffffffffffff000 <end+0xffffffff7ffbd210>
  for (i = 0; i < n; i++) {
    80000232:	0785                	addi	a5,a5,1
    80000234:	fee79de3          	bne	a5,a4,8000022e <memset+0x12>
  }
  return dst;
}
    80000238:	6422                	ld	s0,8(sp)
    8000023a:	0141                	addi	sp,sp,16
    8000023c:	8082                	ret

000000008000023e <memcmp>:

int memcmp(const void *v1, const void *v2, uint n) {
    8000023e:	1141                	addi	sp,sp,-16
    80000240:	e422                	sd	s0,8(sp)
    80000242:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0) {
    80000244:	ca05                	beqz	a2,80000274 <memcmp+0x36>
    80000246:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    8000024a:	1682                	slli	a3,a3,0x20
    8000024c:	9281                	srli	a3,a3,0x20
    8000024e:	0685                	addi	a3,a3,1
    80000250:	96aa                	add	a3,a3,a0
    if (*s1 != *s2) return *s1 - *s2;
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	0005c703          	lbu	a4,0(a1)
    8000025a:	00e79863          	bne	a5,a4,8000026a <memcmp+0x2c>
    s1++, s2++;
    8000025e:	0505                	addi	a0,a0,1
    80000260:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    80000262:	fed518e3          	bne	a0,a3,80000252 <memcmp+0x14>
  }

  return 0;
    80000266:	4501                	li	a0,0
    80000268:	a019                	j	8000026e <memcmp+0x30>
    if (*s1 != *s2) return *s1 - *s2;
    8000026a:	40e7853b          	subw	a0,a5,a4
}
    8000026e:	6422                	ld	s0,8(sp)
    80000270:	0141                	addi	sp,sp,16
    80000272:	8082                	ret
  return 0;
    80000274:	4501                	li	a0,0
    80000276:	bfe5                	j	8000026e <memcmp+0x30>

0000000080000278 <memmove>:

void *memmove(void *dst, const void *src, uint n) {
    80000278:	1141                	addi	sp,sp,-16
    8000027a:	e422                	sd	s0,8(sp)
    8000027c:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if (n == 0) return dst;
    8000027e:	c205                	beqz	a2,8000029e <memmove+0x26>

  s = src;
  d = dst;
  if (s < d && s + n > d) {
    80000280:	02a5e263          	bltu	a1,a0,800002a4 <memmove+0x2c>
    s += n;
    d += n;
    while (n-- > 0) *--d = *--s;
  } else
    while (n-- > 0) *d++ = *s++;
    80000284:	1602                	slli	a2,a2,0x20
    80000286:	9201                	srli	a2,a2,0x20
    80000288:	00c587b3          	add	a5,a1,a2
void *memmove(void *dst, const void *src, uint n) {
    8000028c:	872a                	mv	a4,a0
    while (n-- > 0) *d++ = *s++;
    8000028e:	0585                	addi	a1,a1,1
    80000290:	0705                	addi	a4,a4,1
    80000292:	fff5c683          	lbu	a3,-1(a1)
    80000296:	fed70fa3          	sb	a3,-1(a4)
    8000029a:	fef59ae3          	bne	a1,a5,8000028e <memmove+0x16>

  return dst;
}
    8000029e:	6422                	ld	s0,8(sp)
    800002a0:	0141                	addi	sp,sp,16
    800002a2:	8082                	ret
  if (s < d && s + n > d) {
    800002a4:	02061693          	slli	a3,a2,0x20
    800002a8:	9281                	srli	a3,a3,0x20
    800002aa:	00d58733          	add	a4,a1,a3
    800002ae:	fce57be3          	bgeu	a0,a4,80000284 <memmove+0xc>
    d += n;
    800002b2:	96aa                	add	a3,a3,a0
    while (n-- > 0) *--d = *--s;
    800002b4:	fff6079b          	addiw	a5,a2,-1
    800002b8:	1782                	slli	a5,a5,0x20
    800002ba:	9381                	srli	a5,a5,0x20
    800002bc:	fff7c793          	not	a5,a5
    800002c0:	97ba                	add	a5,a5,a4
    800002c2:	177d                	addi	a4,a4,-1
    800002c4:	16fd                	addi	a3,a3,-1
    800002c6:	00074603          	lbu	a2,0(a4)
    800002ca:	00c68023          	sb	a2,0(a3)
    800002ce:	fee79ae3          	bne	a5,a4,800002c2 <memmove+0x4a>
    800002d2:	b7f1                	j	8000029e <memmove+0x26>

00000000800002d4 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *memcpy(void *dst, const void *src, uint n) {
    800002d4:	1141                	addi	sp,sp,-16
    800002d6:	e406                	sd	ra,8(sp)
    800002d8:	e022                	sd	s0,0(sp)
    800002da:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    800002dc:	00000097          	auipc	ra,0x0
    800002e0:	f9c080e7          	jalr	-100(ra) # 80000278 <memmove>
}
    800002e4:	60a2                	ld	ra,8(sp)
    800002e6:	6402                	ld	s0,0(sp)
    800002e8:	0141                	addi	sp,sp,16
    800002ea:	8082                	ret

00000000800002ec <strncmp>:

int strncmp(const char *p, const char *q, uint n) {
    800002ec:	1141                	addi	sp,sp,-16
    800002ee:	e422                	sd	s0,8(sp)
    800002f0:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q) n--, p++, q++;
    800002f2:	ce11                	beqz	a2,8000030e <strncmp+0x22>
    800002f4:	00054783          	lbu	a5,0(a0)
    800002f8:	cf89                	beqz	a5,80000312 <strncmp+0x26>
    800002fa:	0005c703          	lbu	a4,0(a1)
    800002fe:	00f71a63          	bne	a4,a5,80000312 <strncmp+0x26>
    80000302:	367d                	addiw	a2,a2,-1
    80000304:	0505                	addi	a0,a0,1
    80000306:	0585                	addi	a1,a1,1
    80000308:	f675                	bnez	a2,800002f4 <strncmp+0x8>
  if (n == 0) return 0;
    8000030a:	4501                	li	a0,0
    8000030c:	a809                	j	8000031e <strncmp+0x32>
    8000030e:	4501                	li	a0,0
    80000310:	a039                	j	8000031e <strncmp+0x32>
    80000312:	ca09                	beqz	a2,80000324 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000314:	00054503          	lbu	a0,0(a0)
    80000318:	0005c783          	lbu	a5,0(a1)
    8000031c:	9d1d                	subw	a0,a0,a5
}
    8000031e:	6422                	ld	s0,8(sp)
    80000320:	0141                	addi	sp,sp,16
    80000322:	8082                	ret
  if (n == 0) return 0;
    80000324:	4501                	li	a0,0
    80000326:	bfe5                	j	8000031e <strncmp+0x32>

0000000080000328 <strncpy>:

char *strncpy(char *s, const char *t, int n) {
    80000328:	1141                	addi	sp,sp,-16
    8000032a:	e422                	sd	s0,8(sp)
    8000032c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0);
    8000032e:	872a                	mv	a4,a0
    80000330:	8832                	mv	a6,a2
    80000332:	367d                	addiw	a2,a2,-1
    80000334:	01005963          	blez	a6,80000346 <strncpy+0x1e>
    80000338:	0705                	addi	a4,a4,1
    8000033a:	0005c783          	lbu	a5,0(a1)
    8000033e:	fef70fa3          	sb	a5,-1(a4)
    80000342:	0585                	addi	a1,a1,1
    80000344:	f7f5                	bnez	a5,80000330 <strncpy+0x8>
  while (n-- > 0) *s++ = 0;
    80000346:	86ba                	mv	a3,a4
    80000348:	00c05c63          	blez	a2,80000360 <strncpy+0x38>
    8000034c:	0685                	addi	a3,a3,1
    8000034e:	fe068fa3          	sb	zero,-1(a3)
    80000352:	40d707bb          	subw	a5,a4,a3
    80000356:	37fd                	addiw	a5,a5,-1
    80000358:	010787bb          	addw	a5,a5,a6
    8000035c:	fef048e3          	bgtz	a5,8000034c <strncpy+0x24>
  return os;
}
    80000360:	6422                	ld	s0,8(sp)
    80000362:	0141                	addi	sp,sp,16
    80000364:	8082                	ret

0000000080000366 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *safestrcpy(char *s, const char *t, int n) {
    80000366:	1141                	addi	sp,sp,-16
    80000368:	e422                	sd	s0,8(sp)
    8000036a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0) return os;
    8000036c:	02c05363          	blez	a2,80000392 <safestrcpy+0x2c>
    80000370:	fff6069b          	addiw	a3,a2,-1
    80000374:	1682                	slli	a3,a3,0x20
    80000376:	9281                	srli	a3,a3,0x20
    80000378:	96ae                	add	a3,a3,a1
    8000037a:	87aa                	mv	a5,a0
  while (--n > 0 && (*s++ = *t++) != 0);
    8000037c:	00d58963          	beq	a1,a3,8000038e <safestrcpy+0x28>
    80000380:	0585                	addi	a1,a1,1
    80000382:	0785                	addi	a5,a5,1
    80000384:	fff5c703          	lbu	a4,-1(a1)
    80000388:	fee78fa3          	sb	a4,-1(a5)
    8000038c:	fb65                	bnez	a4,8000037c <safestrcpy+0x16>
  *s = 0;
    8000038e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000392:	6422                	ld	s0,8(sp)
    80000394:	0141                	addi	sp,sp,16
    80000396:	8082                	ret

0000000080000398 <strlen>:

int strlen(const char *s) {
    80000398:	1141                	addi	sp,sp,-16
    8000039a:	e422                	sd	s0,8(sp)
    8000039c:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
    8000039e:	00054783          	lbu	a5,0(a0)
    800003a2:	cf91                	beqz	a5,800003be <strlen+0x26>
    800003a4:	0505                	addi	a0,a0,1
    800003a6:	87aa                	mv	a5,a0
    800003a8:	4685                	li	a3,1
    800003aa:	9e89                	subw	a3,a3,a0
    800003ac:	00f6853b          	addw	a0,a3,a5
    800003b0:	0785                	addi	a5,a5,1
    800003b2:	fff7c703          	lbu	a4,-1(a5)
    800003b6:	fb7d                	bnez	a4,800003ac <strlen+0x14>
  return n;
}
    800003b8:	6422                	ld	s0,8(sp)
    800003ba:	0141                	addi	sp,sp,16
    800003bc:	8082                	ret
  for (n = 0; s[n]; n++);
    800003be:	4501                	li	a0,0
    800003c0:	bfe5                	j	800003b8 <strlen+0x20>

00000000800003c2 <main>:
#include "defs.h"

volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void main() {
    800003c2:	1141                	addi	sp,sp,-16
    800003c4:	e406                	sd	ra,8(sp)
    800003c6:	e022                	sd	s0,0(sp)
    800003c8:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    800003ca:	00001097          	auipc	ra,0x1
    800003ce:	d32080e7          	jalr	-718(ra) # 800010fc <cpuid>
    virtio_disk_init();  // emulated hard disk
    userinit();          // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while (started == 0);
    800003d2:	00008717          	auipc	a4,0x8
    800003d6:	55e70713          	addi	a4,a4,1374 # 80008930 <started>
  if (cpuid() == 0) {
    800003da:	c139                	beqz	a0,80000420 <main+0x5e>
    while (started == 0);
    800003dc:	431c                	lw	a5,0(a4)
    800003de:	2781                	sext.w	a5,a5
    800003e0:	dff5                	beqz	a5,800003dc <main+0x1a>
    __sync_synchronize();
    800003e2:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    800003e6:	00001097          	auipc	ra,0x1
    800003ea:	d16080e7          	jalr	-746(ra) # 800010fc <cpuid>
    800003ee:	85aa                	mv	a1,a0
    800003f0:	00008517          	auipc	a0,0x8
    800003f4:	c5850513          	addi	a0,a0,-936 # 80008048 <etext+0x48>
    800003f8:	00006097          	auipc	ra,0x6
    800003fc:	afe080e7          	jalr	-1282(ra) # 80005ef6 <printf>
    kvminithart();   // turn on paging
    80000400:	00000097          	auipc	ra,0x0
    80000404:	0d8080e7          	jalr	216(ra) # 800004d8 <kvminithart>
    trapinithart();  // install kernel trap vector
    80000408:	00002097          	auipc	ra,0x2
    8000040c:	9c2080e7          	jalr	-1598(ra) # 80001dca <trapinithart>
    plicinithart();  // ask PLIC for device interrupts
    80000410:	00005097          	auipc	ra,0x5
    80000414:	fa0080e7          	jalr	-96(ra) # 800053b0 <plicinithart>
  }

  scheduler();
    80000418:	00001097          	auipc	ra,0x1
    8000041c:	20a080e7          	jalr	522(ra) # 80001622 <scheduler>
    consoleinit();
    80000420:	00006097          	auipc	ra,0x6
    80000424:	99c080e7          	jalr	-1636(ra) # 80005dbc <consoleinit>
    printfinit();
    80000428:	00006097          	auipc	ra,0x6
    8000042c:	cae080e7          	jalr	-850(ra) # 800060d6 <printfinit>
    printf("\n");
    80000430:	00008517          	auipc	a0,0x8
    80000434:	c2850513          	addi	a0,a0,-984 # 80008058 <etext+0x58>
    80000438:	00006097          	auipc	ra,0x6
    8000043c:	abe080e7          	jalr	-1346(ra) # 80005ef6 <printf>
    printf("xv6 kernel is booting\n");
    80000440:	00008517          	auipc	a0,0x8
    80000444:	bf050513          	addi	a0,a0,-1040 # 80008030 <etext+0x30>
    80000448:	00006097          	auipc	ra,0x6
    8000044c:	aae080e7          	jalr	-1362(ra) # 80005ef6 <printf>
    printf("\n");
    80000450:	00008517          	auipc	a0,0x8
    80000454:	c0850513          	addi	a0,a0,-1016 # 80008058 <etext+0x58>
    80000458:	00006097          	auipc	ra,0x6
    8000045c:	a9e080e7          	jalr	-1378(ra) # 80005ef6 <printf>
    kinit();             // physical page allocator
    80000460:	00000097          	auipc	ra,0x0
    80000464:	cee080e7          	jalr	-786(ra) # 8000014e <kinit>
    kvminit();           // create kernel page table
    80000468:	00000097          	auipc	ra,0x0
    8000046c:	34a080e7          	jalr	842(ra) # 800007b2 <kvminit>
    kvminithart();       // turn on paging
    80000470:	00000097          	auipc	ra,0x0
    80000474:	068080e7          	jalr	104(ra) # 800004d8 <kvminithart>
    procinit();          // process table
    80000478:	00001097          	auipc	ra,0x1
    8000047c:	bd0080e7          	jalr	-1072(ra) # 80001048 <procinit>
    trapinit();          // trap vectors
    80000480:	00002097          	auipc	ra,0x2
    80000484:	922080e7          	jalr	-1758(ra) # 80001da2 <trapinit>
    trapinithart();      // install kernel trap vector
    80000488:	00002097          	auipc	ra,0x2
    8000048c:	942080e7          	jalr	-1726(ra) # 80001dca <trapinithart>
    plicinit();          // set up interrupt controller
    80000490:	00005097          	auipc	ra,0x5
    80000494:	f0a080e7          	jalr	-246(ra) # 8000539a <plicinit>
    plicinithart();      // ask PLIC for device interrupts
    80000498:	00005097          	auipc	ra,0x5
    8000049c:	f18080e7          	jalr	-232(ra) # 800053b0 <plicinithart>
    binit();             // buffer cache
    800004a0:	00002097          	auipc	ra,0x2
    800004a4:	0a0080e7          	jalr	160(ra) # 80002540 <binit>
    iinit();             // inode table
    800004a8:	00002097          	auipc	ra,0x2
    800004ac:	740080e7          	jalr	1856(ra) # 80002be8 <iinit>
    fileinit();          // file table
    800004b0:	00003097          	auipc	ra,0x3
    800004b4:	6e6080e7          	jalr	1766(ra) # 80003b96 <fileinit>
    virtio_disk_init();  // emulated hard disk
    800004b8:	00005097          	auipc	ra,0x5
    800004bc:	000080e7          	jalr	ra # 800054b8 <virtio_disk_init>
    userinit();          // first user process
    800004c0:	00001097          	auipc	ra,0x1
    800004c4:	f44080e7          	jalr	-188(ra) # 80001404 <userinit>
    __sync_synchronize();
    800004c8:	0ff0000f          	fence
    started = 1;
    800004cc:	4785                	li	a5,1
    800004ce:	00008717          	auipc	a4,0x8
    800004d2:	46f72123          	sw	a5,1122(a4) # 80008930 <started>
    800004d6:	b789                	j	80000418 <main+0x56>

00000000800004d8 <kvminithart>:
// Initialize the one kernel_pagetable
void kvminit(void) { kernel_pagetable = kvmmake(); }

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart() {
    800004d8:	1141                	addi	sp,sp,-16
    800004da:	e422                	sd	s0,8(sp)
    800004dc:	0800                	addi	s0,sp,16
}

// flush the TLB.
static inline void sfence_vma() {
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800004de:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800004e2:	00008797          	auipc	a5,0x8
    800004e6:	4567b783          	ld	a5,1110(a5) # 80008938 <kernel_pagetable>
    800004ea:	83b1                	srli	a5,a5,0xc
    800004ec:	577d                	li	a4,-1
    800004ee:	177e                	slli	a4,a4,0x3f
    800004f0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    800004f2:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800004f6:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800004fa:	6422                	ld	s0,8(sp)
    800004fc:	0141                	addi	sp,sp,16
    800004fe:	8082                	ret

0000000080000500 <walk>:
//   39..63 -- must be zero.
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
    80000500:	7139                	addi	sp,sp,-64
    80000502:	fc06                	sd	ra,56(sp)
    80000504:	f822                	sd	s0,48(sp)
    80000506:	f426                	sd	s1,40(sp)
    80000508:	f04a                	sd	s2,32(sp)
    8000050a:	ec4e                	sd	s3,24(sp)
    8000050c:	e852                	sd	s4,16(sp)
    8000050e:	e456                	sd	s5,8(sp)
    80000510:	e05a                	sd	s6,0(sp)
    80000512:	0080                	addi	s0,sp,64
    80000514:	84aa                	mv	s1,a0
    80000516:	89ae                	mv	s3,a1
    80000518:	8ab2                	mv	s5,a2
  if (va >= MAXVA) panic("walk");
    8000051a:	57fd                	li	a5,-1
    8000051c:	83e9                	srli	a5,a5,0x1a
    8000051e:	4a79                	li	s4,30

  for (int level = 2; level > 0; level--) {
    80000520:	4b31                	li	s6,12
  if (va >= MAXVA) panic("walk");
    80000522:	04b7f263          	bgeu	a5,a1,80000566 <walk+0x66>
    80000526:	00008517          	auipc	a0,0x8
    8000052a:	b3a50513          	addi	a0,a0,-1222 # 80008060 <etext+0x60>
    8000052e:	00006097          	auipc	ra,0x6
    80000532:	97e080e7          	jalr	-1666(ra) # 80005eac <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if (*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0) return 0;
    80000536:	060a8663          	beqz	s5,800005a2 <walk+0xa2>
    8000053a:	00000097          	auipc	ra,0x0
    8000053e:	c68080e7          	jalr	-920(ra) # 800001a2 <kalloc>
    80000542:	84aa                	mv	s1,a0
    80000544:	c529                	beqz	a0,8000058e <walk+0x8e>
      memset(pagetable, 0, PGSIZE);
    80000546:	6605                	lui	a2,0x1
    80000548:	4581                	li	a1,0
    8000054a:	00000097          	auipc	ra,0x0
    8000054e:	cd2080e7          	jalr	-814(ra) # 8000021c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000552:	00c4d793          	srli	a5,s1,0xc
    80000556:	07aa                	slli	a5,a5,0xa
    80000558:	0017e793          	ori	a5,a5,1
    8000055c:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--) {
    80000560:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffbd207>
    80000562:	036a0063          	beq	s4,s6,80000582 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000566:	0149d933          	srl	s2,s3,s4
    8000056a:	1ff97913          	andi	s2,s2,511
    8000056e:	090e                	slli	s2,s2,0x3
    80000570:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    80000572:	00093483          	ld	s1,0(s2)
    80000576:	0014f793          	andi	a5,s1,1
    8000057a:	dfd5                	beqz	a5,80000536 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000057c:	80a9                	srli	s1,s1,0xa
    8000057e:	04b2                	slli	s1,s1,0xc
    80000580:	b7c5                	j	80000560 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000582:	00c9d513          	srli	a0,s3,0xc
    80000586:	1ff57513          	andi	a0,a0,511
    8000058a:	050e                	slli	a0,a0,0x3
    8000058c:	9526                	add	a0,a0,s1
}
    8000058e:	70e2                	ld	ra,56(sp)
    80000590:	7442                	ld	s0,48(sp)
    80000592:	74a2                	ld	s1,40(sp)
    80000594:	7902                	ld	s2,32(sp)
    80000596:	69e2                	ld	s3,24(sp)
    80000598:	6a42                	ld	s4,16(sp)
    8000059a:	6aa2                	ld	s5,8(sp)
    8000059c:	6b02                	ld	s6,0(sp)
    8000059e:	6121                	addi	sp,sp,64
    800005a0:	8082                	ret
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0) return 0;
    800005a2:	4501                	li	a0,0
    800005a4:	b7ed                	j	8000058e <walk+0x8e>

00000000800005a6 <walkaddr>:
// Can only be used to look up user pages.
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA) return 0;
    800005a6:	57fd                	li	a5,-1
    800005a8:	83e9                	srli	a5,a5,0x1a
    800005aa:	00b7f463          	bgeu	a5,a1,800005b2 <walkaddr+0xc>
    800005ae:	4501                	li	a0,0
  if (pte == 0) return 0;
  if ((*pte & PTE_V) == 0) return 0;
  if ((*pte & PTE_U) == 0) return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800005b0:	8082                	ret
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
    800005b2:	1141                	addi	sp,sp,-16
    800005b4:	e406                	sd	ra,8(sp)
    800005b6:	e022                	sd	s0,0(sp)
    800005b8:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800005ba:	4601                	li	a2,0
    800005bc:	00000097          	auipc	ra,0x0
    800005c0:	f44080e7          	jalr	-188(ra) # 80000500 <walk>
  if (pte == 0) return 0;
    800005c4:	c105                	beqz	a0,800005e4 <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0) return 0;
    800005c6:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0) return 0;
    800005c8:	0117f693          	andi	a3,a5,17
    800005cc:	4745                	li	a4,17
    800005ce:	4501                	li	a0,0
    800005d0:	00e68663          	beq	a3,a4,800005dc <walkaddr+0x36>
}
    800005d4:	60a2                	ld	ra,8(sp)
    800005d6:	6402                	ld	s0,0(sp)
    800005d8:	0141                	addi	sp,sp,16
    800005da:	8082                	ret
  pa = PTE2PA(*pte);
    800005dc:	83a9                	srli	a5,a5,0xa
    800005de:	00c79513          	slli	a0,a5,0xc
  return pa;
    800005e2:	bfcd                	j	800005d4 <walkaddr+0x2e>
  if (pte == 0) return 0;
    800005e4:	4501                	li	a0,0
    800005e6:	b7fd                	j	800005d4 <walkaddr+0x2e>

00000000800005e8 <mappages>:
// physical addresses starting at pa.
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa,
             int perm) {
    800005e8:	715d                	addi	sp,sp,-80
    800005ea:	e486                	sd	ra,72(sp)
    800005ec:	e0a2                	sd	s0,64(sp)
    800005ee:	fc26                	sd	s1,56(sp)
    800005f0:	f84a                	sd	s2,48(sp)
    800005f2:	f44e                	sd	s3,40(sp)
    800005f4:	f052                	sd	s4,32(sp)
    800005f6:	ec56                	sd	s5,24(sp)
    800005f8:	e85a                	sd	s6,16(sp)
    800005fa:	e45e                	sd	s7,8(sp)
    800005fc:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if ((va % PGSIZE) != 0) panic("mappages: va not aligned");
    800005fe:	03459793          	slli	a5,a1,0x34
    80000602:	e7b9                	bnez	a5,80000650 <mappages+0x68>
    80000604:	8aaa                	mv	s5,a0
    80000606:	8b3a                	mv	s6,a4

  if ((size % PGSIZE) != 0) panic("mappages: size not aligned");
    80000608:	03461793          	slli	a5,a2,0x34
    8000060c:	ebb1                	bnez	a5,80000660 <mappages+0x78>

  if (size == 0) panic("mappages: size");
    8000060e:	c22d                	beqz	a2,80000670 <mappages+0x88>

  a = va;
  last = va + size - PGSIZE;
    80000610:	77fd                	lui	a5,0xfffff
    80000612:	963e                	add	a2,a2,a5
    80000614:	00b609b3          	add	s3,a2,a1
  a = va;
    80000618:	892e                	mv	s2,a1
    8000061a:	40b68a33          	sub	s4,a3,a1
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    if (*pte & PTE_V) panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last) break;
    a += PGSIZE;
    8000061e:	6b85                	lui	s7,0x1
    80000620:	012a04b3          	add	s1,s4,s2
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    80000624:	4605                	li	a2,1
    80000626:	85ca                	mv	a1,s2
    80000628:	8556                	mv	a0,s5
    8000062a:	00000097          	auipc	ra,0x0
    8000062e:	ed6080e7          	jalr	-298(ra) # 80000500 <walk>
    80000632:	cd39                	beqz	a0,80000690 <mappages+0xa8>
    if (*pte & PTE_V) panic("mappages: remap");
    80000634:	611c                	ld	a5,0(a0)
    80000636:	8b85                	andi	a5,a5,1
    80000638:	e7a1                	bnez	a5,80000680 <mappages+0x98>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000063a:	80b1                	srli	s1,s1,0xc
    8000063c:	04aa                	slli	s1,s1,0xa
    8000063e:	0164e4b3          	or	s1,s1,s6
    80000642:	0014e493          	ori	s1,s1,1
    80000646:	e104                	sd	s1,0(a0)
    if (a == last) break;
    80000648:	07390063          	beq	s2,s3,800006a8 <mappages+0xc0>
    a += PGSIZE;
    8000064c:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    8000064e:	bfc9                	j	80000620 <mappages+0x38>
  if ((va % PGSIZE) != 0) panic("mappages: va not aligned");
    80000650:	00008517          	auipc	a0,0x8
    80000654:	a1850513          	addi	a0,a0,-1512 # 80008068 <etext+0x68>
    80000658:	00006097          	auipc	ra,0x6
    8000065c:	854080e7          	jalr	-1964(ra) # 80005eac <panic>
  if ((size % PGSIZE) != 0) panic("mappages: size not aligned");
    80000660:	00008517          	auipc	a0,0x8
    80000664:	a2850513          	addi	a0,a0,-1496 # 80008088 <etext+0x88>
    80000668:	00006097          	auipc	ra,0x6
    8000066c:	844080e7          	jalr	-1980(ra) # 80005eac <panic>
  if (size == 0) panic("mappages: size");
    80000670:	00008517          	auipc	a0,0x8
    80000674:	a3850513          	addi	a0,a0,-1480 # 800080a8 <etext+0xa8>
    80000678:	00006097          	auipc	ra,0x6
    8000067c:	834080e7          	jalr	-1996(ra) # 80005eac <panic>
    if (*pte & PTE_V) panic("mappages: remap");
    80000680:	00008517          	auipc	a0,0x8
    80000684:	a3850513          	addi	a0,a0,-1480 # 800080b8 <etext+0xb8>
    80000688:	00006097          	auipc	ra,0x6
    8000068c:	824080e7          	jalr	-2012(ra) # 80005eac <panic>
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    80000690:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000692:	60a6                	ld	ra,72(sp)
    80000694:	6406                	ld	s0,64(sp)
    80000696:	74e2                	ld	s1,56(sp)
    80000698:	7942                	ld	s2,48(sp)
    8000069a:	79a2                	ld	s3,40(sp)
    8000069c:	7a02                	ld	s4,32(sp)
    8000069e:	6ae2                	ld	s5,24(sp)
    800006a0:	6b42                	ld	s6,16(sp)
    800006a2:	6ba2                	ld	s7,8(sp)
    800006a4:	6161                	addi	sp,sp,80
    800006a6:	8082                	ret
  return 0;
    800006a8:	4501                	li	a0,0
    800006aa:	b7e5                	j	80000692 <mappages+0xaa>

00000000800006ac <kvmmap>:
void kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm) {
    800006ac:	1141                	addi	sp,sp,-16
    800006ae:	e406                	sd	ra,8(sp)
    800006b0:	e022                	sd	s0,0(sp)
    800006b2:	0800                	addi	s0,sp,16
    800006b4:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0) panic("kvmmap");
    800006b6:	86b2                	mv	a3,a2
    800006b8:	863e                	mv	a2,a5
    800006ba:	00000097          	auipc	ra,0x0
    800006be:	f2e080e7          	jalr	-210(ra) # 800005e8 <mappages>
    800006c2:	e509                	bnez	a0,800006cc <kvmmap+0x20>
}
    800006c4:	60a2                	ld	ra,8(sp)
    800006c6:	6402                	ld	s0,0(sp)
    800006c8:	0141                	addi	sp,sp,16
    800006ca:	8082                	ret
  if (mappages(kpgtbl, va, sz, pa, perm) != 0) panic("kvmmap");
    800006cc:	00008517          	auipc	a0,0x8
    800006d0:	9fc50513          	addi	a0,a0,-1540 # 800080c8 <etext+0xc8>
    800006d4:	00005097          	auipc	ra,0x5
    800006d8:	7d8080e7          	jalr	2008(ra) # 80005eac <panic>

00000000800006dc <kvmmake>:
pagetable_t kvmmake(void) {
    800006dc:	1101                	addi	sp,sp,-32
    800006de:	ec06                	sd	ra,24(sp)
    800006e0:	e822                	sd	s0,16(sp)
    800006e2:	e426                	sd	s1,8(sp)
    800006e4:	e04a                	sd	s2,0(sp)
    800006e6:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    800006e8:	00000097          	auipc	ra,0x0
    800006ec:	aba080e7          	jalr	-1350(ra) # 800001a2 <kalloc>
    800006f0:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800006f2:	6605                	lui	a2,0x1
    800006f4:	4581                	li	a1,0
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	b26080e7          	jalr	-1242(ra) # 8000021c <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800006fe:	4719                	li	a4,6
    80000700:	6685                	lui	a3,0x1
    80000702:	10000637          	lui	a2,0x10000
    80000706:	100005b7          	lui	a1,0x10000
    8000070a:	8526                	mv	a0,s1
    8000070c:	00000097          	auipc	ra,0x0
    80000710:	fa0080e7          	jalr	-96(ra) # 800006ac <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000714:	4719                	li	a4,6
    80000716:	6685                	lui	a3,0x1
    80000718:	10001637          	lui	a2,0x10001
    8000071c:	100015b7          	lui	a1,0x10001
    80000720:	8526                	mv	a0,s1
    80000722:	00000097          	auipc	ra,0x0
    80000726:	f8a080e7          	jalr	-118(ra) # 800006ac <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000072a:	4719                	li	a4,6
    8000072c:	004006b7          	lui	a3,0x400
    80000730:	0c000637          	lui	a2,0xc000
    80000734:	0c0005b7          	lui	a1,0xc000
    80000738:	8526                	mv	a0,s1
    8000073a:	00000097          	auipc	ra,0x0
    8000073e:	f72080e7          	jalr	-142(ra) # 800006ac <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    80000742:	00008917          	auipc	s2,0x8
    80000746:	8be90913          	addi	s2,s2,-1858 # 80008000 <etext>
    8000074a:	4729                	li	a4,10
    8000074c:	80008697          	auipc	a3,0x80008
    80000750:	8b468693          	addi	a3,a3,-1868 # 8000 <_entry-0x7fff8000>
    80000754:	4605                	li	a2,1
    80000756:	067e                	slli	a2,a2,0x1f
    80000758:	85b2                	mv	a1,a2
    8000075a:	8526                	mv	a0,s1
    8000075c:	00000097          	auipc	ra,0x0
    80000760:	f50080e7          	jalr	-176(ra) # 800006ac <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    80000764:	4719                	li	a4,6
    80000766:	46c5                	li	a3,17
    80000768:	06ee                	slli	a3,a3,0x1b
    8000076a:	412686b3          	sub	a3,a3,s2
    8000076e:	864a                	mv	a2,s2
    80000770:	85ca                	mv	a1,s2
    80000772:	8526                	mv	a0,s1
    80000774:	00000097          	auipc	ra,0x0
    80000778:	f38080e7          	jalr	-200(ra) # 800006ac <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000077c:	4729                	li	a4,10
    8000077e:	6685                	lui	a3,0x1
    80000780:	00007617          	auipc	a2,0x7
    80000784:	88060613          	addi	a2,a2,-1920 # 80007000 <_trampoline>
    80000788:	040005b7          	lui	a1,0x4000
    8000078c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000078e:	05b2                	slli	a1,a1,0xc
    80000790:	8526                	mv	a0,s1
    80000792:	00000097          	auipc	ra,0x0
    80000796:	f1a080e7          	jalr	-230(ra) # 800006ac <kvmmap>
  proc_mapstacks(kpgtbl);
    8000079a:	8526                	mv	a0,s1
    8000079c:	00001097          	auipc	ra,0x1
    800007a0:	816080e7          	jalr	-2026(ra) # 80000fb2 <proc_mapstacks>
}
    800007a4:	8526                	mv	a0,s1
    800007a6:	60e2                	ld	ra,24(sp)
    800007a8:	6442                	ld	s0,16(sp)
    800007aa:	64a2                	ld	s1,8(sp)
    800007ac:	6902                	ld	s2,0(sp)
    800007ae:	6105                	addi	sp,sp,32
    800007b0:	8082                	ret

00000000800007b2 <kvminit>:
void kvminit(void) { kernel_pagetable = kvmmake(); }
    800007b2:	1141                	addi	sp,sp,-16
    800007b4:	e406                	sd	ra,8(sp)
    800007b6:	e022                	sd	s0,0(sp)
    800007b8:	0800                	addi	s0,sp,16
    800007ba:	00000097          	auipc	ra,0x0
    800007be:	f22080e7          	jalr	-222(ra) # 800006dc <kvmmake>
    800007c2:	00008797          	auipc	a5,0x8
    800007c6:	16a7bb23          	sd	a0,374(a5) # 80008938 <kernel_pagetable>
    800007ca:	60a2                	ld	ra,8(sp)
    800007cc:	6402                	ld	s0,0(sp)
    800007ce:	0141                	addi	sp,sp,16
    800007d0:	8082                	ret

00000000800007d2 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free) {
    800007d2:	715d                	addi	sp,sp,-80
    800007d4:	e486                	sd	ra,72(sp)
    800007d6:	e0a2                	sd	s0,64(sp)
    800007d8:	fc26                	sd	s1,56(sp)
    800007da:	f84a                	sd	s2,48(sp)
    800007dc:	f44e                	sd	s3,40(sp)
    800007de:	f052                	sd	s4,32(sp)
    800007e0:	ec56                	sd	s5,24(sp)
    800007e2:	e85a                	sd	s6,16(sp)
    800007e4:	e45e                	sd	s7,8(sp)
    800007e6:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0) panic("uvmunmap: not aligned");
    800007e8:	03459793          	slli	a5,a1,0x34
    800007ec:	e795                	bnez	a5,80000818 <uvmunmap+0x46>
    800007ee:	8a2a                	mv	s4,a0
    800007f0:	892e                	mv	s2,a1
    800007f2:	8ab6                	mv	s5,a3

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    800007f4:	0632                	slli	a2,a2,0xc
    800007f6:	00b609b3          	add	s3,a2,a1
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    800007fa:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    800007fc:	6b05                	lui	s6,0x1
    800007fe:	0735e263          	bltu	a1,s3,80000862 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
  }
}
    80000802:	60a6                	ld	ra,72(sp)
    80000804:	6406                	ld	s0,64(sp)
    80000806:	74e2                	ld	s1,56(sp)
    80000808:	7942                	ld	s2,48(sp)
    8000080a:	79a2                	ld	s3,40(sp)
    8000080c:	7a02                	ld	s4,32(sp)
    8000080e:	6ae2                	ld	s5,24(sp)
    80000810:	6b42                	ld	s6,16(sp)
    80000812:	6ba2                	ld	s7,8(sp)
    80000814:	6161                	addi	sp,sp,80
    80000816:	8082                	ret
  if ((va % PGSIZE) != 0) panic("uvmunmap: not aligned");
    80000818:	00008517          	auipc	a0,0x8
    8000081c:	8b850513          	addi	a0,a0,-1864 # 800080d0 <etext+0xd0>
    80000820:	00005097          	auipc	ra,0x5
    80000824:	68c080e7          	jalr	1676(ra) # 80005eac <panic>
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    80000828:	00008517          	auipc	a0,0x8
    8000082c:	8c050513          	addi	a0,a0,-1856 # 800080e8 <etext+0xe8>
    80000830:	00005097          	auipc	ra,0x5
    80000834:	67c080e7          	jalr	1660(ra) # 80005eac <panic>
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    80000838:	00008517          	auipc	a0,0x8
    8000083c:	8c050513          	addi	a0,a0,-1856 # 800080f8 <etext+0xf8>
    80000840:	00005097          	auipc	ra,0x5
    80000844:	66c080e7          	jalr	1644(ra) # 80005eac <panic>
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    80000848:	00008517          	auipc	a0,0x8
    8000084c:	8c850513          	addi	a0,a0,-1848 # 80008110 <etext+0x110>
    80000850:	00005097          	auipc	ra,0x5
    80000854:	65c080e7          	jalr	1628(ra) # 80005eac <panic>
    *pte = 0;
    80000858:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000085c:	995a                	add	s2,s2,s6
    8000085e:	fb3972e3          	bgeu	s2,s3,80000802 <uvmunmap+0x30>
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    80000862:	4601                	li	a2,0
    80000864:	85ca                	mv	a1,s2
    80000866:	8552                	mv	a0,s4
    80000868:	00000097          	auipc	ra,0x0
    8000086c:	c98080e7          	jalr	-872(ra) # 80000500 <walk>
    80000870:	84aa                	mv	s1,a0
    80000872:	d95d                	beqz	a0,80000828 <uvmunmap+0x56>
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    80000874:	6108                	ld	a0,0(a0)
    80000876:	00157793          	andi	a5,a0,1
    8000087a:	dfdd                	beqz	a5,80000838 <uvmunmap+0x66>
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    8000087c:	3ff57793          	andi	a5,a0,1023
    80000880:	fd7784e3          	beq	a5,s7,80000848 <uvmunmap+0x76>
    if (do_free) {
    80000884:	fc0a8ae3          	beqz	s5,80000858 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80000888:	8129                	srli	a0,a0,0xa
      kfree((void *)pa);
    8000088a:	0532                	slli	a0,a0,0xc
    8000088c:	fffff097          	auipc	ra,0xfffff
    80000890:	7e2080e7          	jalr	2018(ra) # 8000006e <kfree>
    80000894:	b7d1                	j	80000858 <uvmunmap+0x86>

0000000080000896 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t uvmcreate() {
    80000896:	1101                	addi	sp,sp,-32
    80000898:	ec06                	sd	ra,24(sp)
    8000089a:	e822                	sd	s0,16(sp)
    8000089c:	e426                	sd	s1,8(sp)
    8000089e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    800008a0:	00000097          	auipc	ra,0x0
    800008a4:	902080e7          	jalr	-1790(ra) # 800001a2 <kalloc>
    800008a8:	84aa                	mv	s1,a0
  if (pagetable == 0) return 0;
    800008aa:	c519                	beqz	a0,800008b8 <uvmcreate+0x22>
  memset(pagetable, 0, PGSIZE);
    800008ac:	6605                	lui	a2,0x1
    800008ae:	4581                	li	a1,0
    800008b0:	00000097          	auipc	ra,0x0
    800008b4:	96c080e7          	jalr	-1684(ra) # 8000021c <memset>
  return pagetable;
}
    800008b8:	8526                	mv	a0,s1
    800008ba:	60e2                	ld	ra,24(sp)
    800008bc:	6442                	ld	s0,16(sp)
    800008be:	64a2                	ld	s1,8(sp)
    800008c0:	6105                	addi	sp,sp,32
    800008c2:	8082                	ret

00000000800008c4 <uvmfirst>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvmfirst(pagetable_t pagetable, uchar *src, uint sz) {
    800008c4:	7179                	addi	sp,sp,-48
    800008c6:	f406                	sd	ra,40(sp)
    800008c8:	f022                	sd	s0,32(sp)
    800008ca:	ec26                	sd	s1,24(sp)
    800008cc:	e84a                	sd	s2,16(sp)
    800008ce:	e44e                	sd	s3,8(sp)
    800008d0:	e052                	sd	s4,0(sp)
    800008d2:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE) panic("uvmfirst: more than a page");
    800008d4:	6785                	lui	a5,0x1
    800008d6:	04f67863          	bgeu	a2,a5,80000926 <uvmfirst+0x62>
    800008da:	8a2a                	mv	s4,a0
    800008dc:	89ae                	mv	s3,a1
    800008de:	84b2                	mv	s1,a2
  mem = kalloc();
    800008e0:	00000097          	auipc	ra,0x0
    800008e4:	8c2080e7          	jalr	-1854(ra) # 800001a2 <kalloc>
    800008e8:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800008ea:	6605                	lui	a2,0x1
    800008ec:	4581                	li	a1,0
    800008ee:	00000097          	auipc	ra,0x0
    800008f2:	92e080e7          	jalr	-1746(ra) # 8000021c <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    800008f6:	4779                	li	a4,30
    800008f8:	86ca                	mv	a3,s2
    800008fa:	6605                	lui	a2,0x1
    800008fc:	4581                	li	a1,0
    800008fe:	8552                	mv	a0,s4
    80000900:	00000097          	auipc	ra,0x0
    80000904:	ce8080e7          	jalr	-792(ra) # 800005e8 <mappages>
  memmove(mem, src, sz);
    80000908:	8626                	mv	a2,s1
    8000090a:	85ce                	mv	a1,s3
    8000090c:	854a                	mv	a0,s2
    8000090e:	00000097          	auipc	ra,0x0
    80000912:	96a080e7          	jalr	-1686(ra) # 80000278 <memmove>
}
    80000916:	70a2                	ld	ra,40(sp)
    80000918:	7402                	ld	s0,32(sp)
    8000091a:	64e2                	ld	s1,24(sp)
    8000091c:	6942                	ld	s2,16(sp)
    8000091e:	69a2                	ld	s3,8(sp)
    80000920:	6a02                	ld	s4,0(sp)
    80000922:	6145                	addi	sp,sp,48
    80000924:	8082                	ret
  if (sz >= PGSIZE) panic("uvmfirst: more than a page");
    80000926:	00008517          	auipc	a0,0x8
    8000092a:	80250513          	addi	a0,a0,-2046 # 80008128 <etext+0x128>
    8000092e:	00005097          	auipc	ra,0x5
    80000932:	57e080e7          	jalr	1406(ra) # 80005eac <panic>

0000000080000936 <uvmdealloc>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64 uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    80000936:	1101                	addi	sp,sp,-32
    80000938:	ec06                	sd	ra,24(sp)
    8000093a:	e822                	sd	s0,16(sp)
    8000093c:	e426                	sd	s1,8(sp)
    8000093e:	1000                	addi	s0,sp,32
  if (newsz >= oldsz) return oldsz;
    80000940:	84ae                	mv	s1,a1
    80000942:	00b67d63          	bgeu	a2,a1,8000095c <uvmdealloc+0x26>
    80000946:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    80000948:	6785                	lui	a5,0x1
    8000094a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000094c:	00f60733          	add	a4,a2,a5
    80000950:	76fd                	lui	a3,0xfffff
    80000952:	8f75                	and	a4,a4,a3
    80000954:	97ae                	add	a5,a5,a1
    80000956:	8ff5                	and	a5,a5,a3
    80000958:	00f76863          	bltu	a4,a5,80000968 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000095c:	8526                	mv	a0,s1
    8000095e:	60e2                	ld	ra,24(sp)
    80000960:	6442                	ld	s0,16(sp)
    80000962:	64a2                	ld	s1,8(sp)
    80000964:	6105                	addi	sp,sp,32
    80000966:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000968:	8f99                	sub	a5,a5,a4
    8000096a:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000096c:	4685                	li	a3,1
    8000096e:	0007861b          	sext.w	a2,a5
    80000972:	85ba                	mv	a1,a4
    80000974:	00000097          	auipc	ra,0x0
    80000978:	e5e080e7          	jalr	-418(ra) # 800007d2 <uvmunmap>
    8000097c:	b7c5                	j	8000095c <uvmdealloc+0x26>

000000008000097e <uvmalloc>:
  if (newsz < oldsz) return oldsz;
    8000097e:	0ab66563          	bltu	a2,a1,80000a28 <uvmalloc+0xaa>
uint64 uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz, int xperm) {
    80000982:	7139                	addi	sp,sp,-64
    80000984:	fc06                	sd	ra,56(sp)
    80000986:	f822                	sd	s0,48(sp)
    80000988:	f426                	sd	s1,40(sp)
    8000098a:	f04a                	sd	s2,32(sp)
    8000098c:	ec4e                	sd	s3,24(sp)
    8000098e:	e852                	sd	s4,16(sp)
    80000990:	e456                	sd	s5,8(sp)
    80000992:	e05a                	sd	s6,0(sp)
    80000994:	0080                	addi	s0,sp,64
    80000996:	8aaa                	mv	s5,a0
    80000998:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000099a:	6785                	lui	a5,0x1
    8000099c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000099e:	95be                	add	a1,a1,a5
    800009a0:	77fd                	lui	a5,0xfffff
    800009a2:	00f5f9b3          	and	s3,a1,a5
  for (a = oldsz; a < newsz; a += PGSIZE) {
    800009a6:	08c9f363          	bgeu	s3,a2,80000a2c <uvmalloc+0xae>
    800009aa:	894e                	mv	s2,s3
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800009ac:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800009b0:	fffff097          	auipc	ra,0xfffff
    800009b4:	7f2080e7          	jalr	2034(ra) # 800001a2 <kalloc>
    800009b8:	84aa                	mv	s1,a0
    if (mem == 0) {
    800009ba:	c51d                	beqz	a0,800009e8 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800009bc:	6605                	lui	a2,0x1
    800009be:	4581                	li	a1,0
    800009c0:	00000097          	auipc	ra,0x0
    800009c4:	85c080e7          	jalr	-1956(ra) # 8000021c <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800009c8:	875a                	mv	a4,s6
    800009ca:	86a6                	mv	a3,s1
    800009cc:	6605                	lui	a2,0x1
    800009ce:	85ca                	mv	a1,s2
    800009d0:	8556                	mv	a0,s5
    800009d2:	00000097          	auipc	ra,0x0
    800009d6:	c16080e7          	jalr	-1002(ra) # 800005e8 <mappages>
    800009da:	e90d                	bnez	a0,80000a0c <uvmalloc+0x8e>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    800009dc:	6785                	lui	a5,0x1
    800009de:	993e                	add	s2,s2,a5
    800009e0:	fd4968e3          	bltu	s2,s4,800009b0 <uvmalloc+0x32>
  return newsz;
    800009e4:	8552                	mv	a0,s4
    800009e6:	a809                	j	800009f8 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    800009e8:	864e                	mv	a2,s3
    800009ea:	85ca                	mv	a1,s2
    800009ec:	8556                	mv	a0,s5
    800009ee:	00000097          	auipc	ra,0x0
    800009f2:	f48080e7          	jalr	-184(ra) # 80000936 <uvmdealloc>
      return 0;
    800009f6:	4501                	li	a0,0
}
    800009f8:	70e2                	ld	ra,56(sp)
    800009fa:	7442                	ld	s0,48(sp)
    800009fc:	74a2                	ld	s1,40(sp)
    800009fe:	7902                	ld	s2,32(sp)
    80000a00:	69e2                	ld	s3,24(sp)
    80000a02:	6a42                	ld	s4,16(sp)
    80000a04:	6aa2                	ld	s5,8(sp)
    80000a06:	6b02                	ld	s6,0(sp)
    80000a08:	6121                	addi	sp,sp,64
    80000a0a:	8082                	ret
      kfree(mem);
    80000a0c:	8526                	mv	a0,s1
    80000a0e:	fffff097          	auipc	ra,0xfffff
    80000a12:	660080e7          	jalr	1632(ra) # 8000006e <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a16:	864e                	mv	a2,s3
    80000a18:	85ca                	mv	a1,s2
    80000a1a:	8556                	mv	a0,s5
    80000a1c:	00000097          	auipc	ra,0x0
    80000a20:	f1a080e7          	jalr	-230(ra) # 80000936 <uvmdealloc>
      return 0;
    80000a24:	4501                	li	a0,0
    80000a26:	bfc9                	j	800009f8 <uvmalloc+0x7a>
  if (newsz < oldsz) return oldsz;
    80000a28:	852e                	mv	a0,a1
}
    80000a2a:	8082                	ret
  return newsz;
    80000a2c:	8532                	mv	a0,a2
    80000a2e:	b7e9                	j	800009f8 <uvmalloc+0x7a>

0000000080000a30 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable) {
    80000a30:	7179                	addi	sp,sp,-48
    80000a32:	f406                	sd	ra,40(sp)
    80000a34:	f022                	sd	s0,32(sp)
    80000a36:	ec26                	sd	s1,24(sp)
    80000a38:	e84a                	sd	s2,16(sp)
    80000a3a:	e44e                	sd	s3,8(sp)
    80000a3c:	e052                	sd	s4,0(sp)
    80000a3e:	1800                	addi	s0,sp,48
    80000a40:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    80000a42:	84aa                	mv	s1,a0
    80000a44:	6905                	lui	s2,0x1
    80000a46:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000a48:	4985                	li	s3,1
    80000a4a:	a829                	j	80000a64 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a4c:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000a4e:	00c79513          	slli	a0,a5,0xc
    80000a52:	00000097          	auipc	ra,0x0
    80000a56:	fde080e7          	jalr	-34(ra) # 80000a30 <freewalk>
      pagetable[i] = 0;
    80000a5a:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++) {
    80000a5e:	04a1                	addi	s1,s1,8
    80000a60:	03248163          	beq	s1,s2,80000a82 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000a64:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000a66:	00f7f713          	andi	a4,a5,15
    80000a6a:	ff3701e3          	beq	a4,s3,80000a4c <freewalk+0x1c>
    } else if (pte & PTE_V) {
    80000a6e:	8b85                	andi	a5,a5,1
    80000a70:	d7fd                	beqz	a5,80000a5e <freewalk+0x2e>
      panic("freewalk: leaf");
    80000a72:	00007517          	auipc	a0,0x7
    80000a76:	6d650513          	addi	a0,a0,1750 # 80008148 <etext+0x148>
    80000a7a:	00005097          	auipc	ra,0x5
    80000a7e:	432080e7          	jalr	1074(ra) # 80005eac <panic>
    }
  }
  kfree((void *)pagetable);
    80000a82:	8552                	mv	a0,s4
    80000a84:	fffff097          	auipc	ra,0xfffff
    80000a88:	5ea080e7          	jalr	1514(ra) # 8000006e <kfree>
}
    80000a8c:	70a2                	ld	ra,40(sp)
    80000a8e:	7402                	ld	s0,32(sp)
    80000a90:	64e2                	ld	s1,24(sp)
    80000a92:	6942                	ld	s2,16(sp)
    80000a94:	69a2                	ld	s3,8(sp)
    80000a96:	6a02                	ld	s4,0(sp)
    80000a98:	6145                	addi	sp,sp,48
    80000a9a:	8082                	ret

0000000080000a9c <printtable>:

void printtable(int level, pagetable_t pagetable) {
    80000a9c:	711d                	addi	sp,sp,-96
    80000a9e:	ec86                	sd	ra,88(sp)
    80000aa0:	e8a2                	sd	s0,80(sp)
    80000aa2:	e4a6                	sd	s1,72(sp)
    80000aa4:	e0ca                	sd	s2,64(sp)
    80000aa6:	fc4e                	sd	s3,56(sp)
    80000aa8:	f852                	sd	s4,48(sp)
    80000aaa:	f456                	sd	s5,40(sp)
    80000aac:	f05a                	sd	s6,32(sp)
    80000aae:	ec5e                	sd	s7,24(sp)
    80000ab0:	e862                	sd	s8,16(sp)
    80000ab2:	e466                	sd	s9,8(sp)
    80000ab4:	e06a                	sd	s10,0(sp)
    80000ab6:	1080                	addi	s0,sp,96
    80000ab8:	8aaa                	mv	s5,a0
    80000aba:	8a2e                	mv	s4,a1
  for (int i = 0; i < 512; i++) {
    80000abc:	4981                	li	s3,0
    pte_t pte = pagetable[i];
    if (pte & PTE_V) {
      for (int j = 0; j < level; j++) {
        printf(" ..");
      }
      printf("%d: pte %p pa %p\n", i, pte, PTE2PA(pte));
    80000abe:	00007c17          	auipc	s8,0x7
    80000ac2:	6a2c0c13          	addi	s8,s8,1698 # 80008160 <etext+0x160>
      if ((pte & (PTE_R | PTE_W | PTE_X)) == 0) {
        uint64 child = PTE2PA(pte);
        printtable(level + 1, (pagetable_t)child);
    80000ac6:	00150d1b          	addiw	s10,a0,1
      for (int j = 0; j < level; j++) {
    80000aca:	4c81                	li	s9,0
        printf(" ..");
    80000acc:	00007b17          	auipc	s6,0x7
    80000ad0:	68cb0b13          	addi	s6,s6,1676 # 80008158 <etext+0x158>
  for (int i = 0; i < 512; i++) {
    80000ad4:	20000b93          	li	s7,512
    80000ad8:	a029                	j	80000ae2 <printtable+0x46>
    80000ada:	2985                	addiw	s3,s3,1 # 1001 <_entry-0x7fffefff>
    80000adc:	0a21                	addi	s4,s4,8
    80000ade:	05798863          	beq	s3,s7,80000b2e <printtable+0x92>
    pte_t pte = pagetable[i];
    80000ae2:	000a3903          	ld	s2,0(s4)
    if (pte & PTE_V) {
    80000ae6:	00197793          	andi	a5,s2,1
    80000aea:	dbe5                	beqz	a5,80000ada <printtable+0x3e>
      for (int j = 0; j < level; j++) {
    80000aec:	01505b63          	blez	s5,80000b02 <printtable+0x66>
    80000af0:	84e6                	mv	s1,s9
        printf(" ..");
    80000af2:	855a                	mv	a0,s6
    80000af4:	00005097          	auipc	ra,0x5
    80000af8:	402080e7          	jalr	1026(ra) # 80005ef6 <printf>
      for (int j = 0; j < level; j++) {
    80000afc:	2485                	addiw	s1,s1,1
    80000afe:	fe9a9ae3          	bne	s5,s1,80000af2 <printtable+0x56>
      printf("%d: pte %p pa %p\n", i, pte, PTE2PA(pte));
    80000b02:	00a95493          	srli	s1,s2,0xa
    80000b06:	04b2                	slli	s1,s1,0xc
    80000b08:	86a6                	mv	a3,s1
    80000b0a:	864a                	mv	a2,s2
    80000b0c:	85ce                	mv	a1,s3
    80000b0e:	8562                	mv	a0,s8
    80000b10:	00005097          	auipc	ra,0x5
    80000b14:	3e6080e7          	jalr	998(ra) # 80005ef6 <printf>
      if ((pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000b18:	00e97913          	andi	s2,s2,14
    80000b1c:	fa091fe3          	bnez	s2,80000ada <printtable+0x3e>
        printtable(level + 1, (pagetable_t)child);
    80000b20:	85a6                	mv	a1,s1
    80000b22:	856a                	mv	a0,s10
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	f78080e7          	jalr	-136(ra) # 80000a9c <printtable>
    80000b2c:	b77d                	j	80000ada <printtable+0x3e>
      }
    }
  }
}
    80000b2e:	60e6                	ld	ra,88(sp)
    80000b30:	6446                	ld	s0,80(sp)
    80000b32:	64a6                	ld	s1,72(sp)
    80000b34:	6906                	ld	s2,64(sp)
    80000b36:	79e2                	ld	s3,56(sp)
    80000b38:	7a42                	ld	s4,48(sp)
    80000b3a:	7aa2                	ld	s5,40(sp)
    80000b3c:	7b02                	ld	s6,32(sp)
    80000b3e:	6be2                	ld	s7,24(sp)
    80000b40:	6c42                	ld	s8,16(sp)
    80000b42:	6ca2                	ld	s9,8(sp)
    80000b44:	6d02                	ld	s10,0(sp)
    80000b46:	6125                	addi	sp,sp,96
    80000b48:	8082                	ret

0000000080000b4a <vmprint>:

// print pagetable
void vmprint(pagetable_t pagetable) {
    80000b4a:	1101                	addi	sp,sp,-32
    80000b4c:	ec06                	sd	ra,24(sp)
    80000b4e:	e822                	sd	s0,16(sp)
    80000b50:	e426                	sd	s1,8(sp)
    80000b52:	1000                	addi	s0,sp,32
    80000b54:	84aa                	mv	s1,a0
  printf("page table %p\n", pagetable);
    80000b56:	85aa                	mv	a1,a0
    80000b58:	00007517          	auipc	a0,0x7
    80000b5c:	62050513          	addi	a0,a0,1568 # 80008178 <etext+0x178>
    80000b60:	00005097          	auipc	ra,0x5
    80000b64:	396080e7          	jalr	918(ra) # 80005ef6 <printf>
  printtable(1, pagetable);
    80000b68:	85a6                	mv	a1,s1
    80000b6a:	4505                	li	a0,1
    80000b6c:	00000097          	auipc	ra,0x0
    80000b70:	f30080e7          	jalr	-208(ra) # 80000a9c <printtable>
}
    80000b74:	60e2                	ld	ra,24(sp)
    80000b76:	6442                	ld	s0,16(sp)
    80000b78:	64a2                	ld	s1,8(sp)
    80000b7a:	6105                	addi	sp,sp,32
    80000b7c:	8082                	ret

0000000080000b7e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz) {
    80000b7e:	1101                	addi	sp,sp,-32
    80000b80:	ec06                	sd	ra,24(sp)
    80000b82:	e822                	sd	s0,16(sp)
    80000b84:	e426                	sd	s1,8(sp)
    80000b86:	1000                	addi	s0,sp,32
    80000b88:	84aa                	mv	s1,a0
  if (sz > 0) uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000b8a:	e999                	bnez	a1,80000ba0 <uvmfree+0x22>
  freewalk(pagetable);
    80000b8c:	8526                	mv	a0,s1
    80000b8e:	00000097          	auipc	ra,0x0
    80000b92:	ea2080e7          	jalr	-350(ra) # 80000a30 <freewalk>
}
    80000b96:	60e2                	ld	ra,24(sp)
    80000b98:	6442                	ld	s0,16(sp)
    80000b9a:	64a2                	ld	s1,8(sp)
    80000b9c:	6105                	addi	sp,sp,32
    80000b9e:	8082                	ret
  if (sz > 0) uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000ba0:	6785                	lui	a5,0x1
    80000ba2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000ba4:	95be                	add	a1,a1,a5
    80000ba6:	4685                	li	a3,1
    80000ba8:	00c5d613          	srli	a2,a1,0xc
    80000bac:	4581                	li	a1,0
    80000bae:	00000097          	auipc	ra,0x0
    80000bb2:	c24080e7          	jalr	-988(ra) # 800007d2 <uvmunmap>
    80000bb6:	bfd9                	j	80000b8c <uvmfree+0xe>

0000000080000bb8 <uvmcopy>:
// its memory into a child's page table.
// Copies both the page table and the
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    80000bb8:	715d                	addi	sp,sp,-80
    80000bba:	e486                	sd	ra,72(sp)
    80000bbc:	e0a2                	sd	s0,64(sp)
    80000bbe:	fc26                	sd	s1,56(sp)
    80000bc0:	f84a                	sd	s2,48(sp)
    80000bc2:	f44e                	sd	s3,40(sp)
    80000bc4:	f052                	sd	s4,32(sp)
    80000bc6:	ec56                	sd	s5,24(sp)
    80000bc8:	e85a                	sd	s6,16(sp)
    80000bca:	e45e                	sd	s7,8(sp)
    80000bcc:	0880                	addi	s0,sp,80
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for (i = 0; i < sz; i += PGSIZE) {
    80000bce:	ce55                	beqz	a2,80000c8a <uvmcopy+0xd2>
    80000bd0:	8aaa                	mv	s5,a0
    80000bd2:	8a2e                	mv	s4,a1
    80000bd4:	89b2                	mv	s3,a2
    80000bd6:	4901                	li	s2,0
    }
    flags = PTE_FLAGS(*pte);
    if (mappages(new, i, PGSIZE, pa, flags) != 0) {
      goto err;
    }
    ref_change(GETPAGENUM(pa), 1);
    80000bd8:	80000b37          	lui	s6,0x80000
    80000bdc:	a891                	j	80000c30 <uvmcopy+0x78>
    if ((pte = walk(old, i, 0)) == 0) panic("uvmcopy: pte should exist");
    80000bde:	00007517          	auipc	a0,0x7
    80000be2:	5aa50513          	addi	a0,a0,1450 # 80008188 <etext+0x188>
    80000be6:	00005097          	auipc	ra,0x5
    80000bea:	2c6080e7          	jalr	710(ra) # 80005eac <panic>
    if ((*pte & PTE_V) == 0) panic("uvmcopy: page not present");
    80000bee:	00007517          	auipc	a0,0x7
    80000bf2:	5ba50513          	addi	a0,a0,1466 # 800081a8 <etext+0x1a8>
    80000bf6:	00005097          	auipc	ra,0x5
    80000bfa:	2b6080e7          	jalr	694(ra) # 80005eac <panic>
    flags = PTE_FLAGS(*pte);
    80000bfe:	6118                	ld	a4,0(a0)
    if (mappages(new, i, PGSIZE, pa, flags) != 0) {
    80000c00:	3ff77713          	andi	a4,a4,1023
    80000c04:	86a6                	mv	a3,s1
    80000c06:	6605                	lui	a2,0x1
    80000c08:	85ca                	mv	a1,s2
    80000c0a:	8552                	mv	a0,s4
    80000c0c:	00000097          	auipc	ra,0x0
    80000c10:	9dc080e7          	jalr	-1572(ra) # 800005e8 <mappages>
    80000c14:	8baa                	mv	s7,a0
    80000c16:	e521                	bnez	a0,80000c5e <uvmcopy+0xa6>
    ref_change(GETPAGENUM(pa), 1);
    80000c18:	94da                	add	s1,s1,s6
    80000c1a:	4585                	li	a1,1
    80000c1c:	00c4d513          	srli	a0,s1,0xc
    80000c20:	fffff097          	auipc	ra,0xfffff
    80000c24:	3fc080e7          	jalr	1020(ra) # 8000001c <ref_change>
  for (i = 0; i < sz; i += PGSIZE) {
    80000c28:	6785                	lui	a5,0x1
    80000c2a:	993e                	add	s2,s2,a5
    80000c2c:	05397363          	bgeu	s2,s3,80000c72 <uvmcopy+0xba>
    if ((pte = walk(old, i, 0)) == 0) panic("uvmcopy: pte should exist");
    80000c30:	4601                	li	a2,0
    80000c32:	85ca                	mv	a1,s2
    80000c34:	8556                	mv	a0,s5
    80000c36:	00000097          	auipc	ra,0x0
    80000c3a:	8ca080e7          	jalr	-1846(ra) # 80000500 <walk>
    80000c3e:	d145                	beqz	a0,80000bde <uvmcopy+0x26>
    if ((*pte & PTE_V) == 0) panic("uvmcopy: page not present");
    80000c40:	611c                	ld	a5,0(a0)
    80000c42:	0017f713          	andi	a4,a5,1
    80000c46:	d745                	beqz	a4,80000bee <uvmcopy+0x36>
    pa = PTE2PA(*pte);
    80000c48:	00a7d493          	srli	s1,a5,0xa
    80000c4c:	04b2                	slli	s1,s1,0xc
    if (*pte & PTE_W) {
    80000c4e:	0047f713          	andi	a4,a5,4
    80000c52:	d755                	beqz	a4,80000bfe <uvmcopy+0x46>
      *pte &= (~PTE_W);
    80000c54:	9bed                	andi	a5,a5,-5
      *pte |= PTE_L;
    80000c56:	1007e793          	ori	a5,a5,256
    80000c5a:	e11c                	sd	a5,0(a0)
    80000c5c:	b74d                	j	80000bfe <uvmcopy+0x46>
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000c5e:	4685                	li	a3,1
    80000c60:	00c95613          	srli	a2,s2,0xc
    80000c64:	4581                	li	a1,0
    80000c66:	8552                	mv	a0,s4
    80000c68:	00000097          	auipc	ra,0x0
    80000c6c:	b6a080e7          	jalr	-1174(ra) # 800007d2 <uvmunmap>
  return -1;
    80000c70:	5bfd                	li	s7,-1
}
    80000c72:	855e                	mv	a0,s7
    80000c74:	60a6                	ld	ra,72(sp)
    80000c76:	6406                	ld	s0,64(sp)
    80000c78:	74e2                	ld	s1,56(sp)
    80000c7a:	7942                	ld	s2,48(sp)
    80000c7c:	79a2                	ld	s3,40(sp)
    80000c7e:	7a02                	ld	s4,32(sp)
    80000c80:	6ae2                	ld	s5,24(sp)
    80000c82:	6b42                	ld	s6,16(sp)
    80000c84:	6ba2                	ld	s7,8(sp)
    80000c86:	6161                	addi	sp,sp,80
    80000c88:	8082                	ret
  return 0;
    80000c8a:	4b81                	li	s7,0
    80000c8c:	b7dd                	j	80000c72 <uvmcopy+0xba>

0000000080000c8e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va) {
    80000c8e:	1141                	addi	sp,sp,-16
    80000c90:	e406                	sd	ra,8(sp)
    80000c92:	e022                	sd	s0,0(sp)
    80000c94:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80000c96:	4601                	li	a2,0
    80000c98:	00000097          	auipc	ra,0x0
    80000c9c:	868080e7          	jalr	-1944(ra) # 80000500 <walk>
  if (pte == 0) panic("uvmclear");
    80000ca0:	c901                	beqz	a0,80000cb0 <uvmclear+0x22>
  *pte &= ~PTE_U;
    80000ca2:	611c                	ld	a5,0(a0)
    80000ca4:	9bbd                	andi	a5,a5,-17
    80000ca6:	e11c                	sd	a5,0(a0)
}
    80000ca8:	60a2                	ld	ra,8(sp)
    80000caa:	6402                	ld	s0,0(sp)
    80000cac:	0141                	addi	sp,sp,16
    80000cae:	8082                	ret
  if (pte == 0) panic("uvmclear");
    80000cb0:	00007517          	auipc	a0,0x7
    80000cb4:	51850513          	addi	a0,a0,1304 # 800081c8 <etext+0x1c8>
    80000cb8:	00005097          	auipc	ra,0x5
    80000cbc:	1f4080e7          	jalr	500(ra) # 80005eac <panic>

0000000080000cc0 <copyin>:
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
  uint64 n, va0, pa0;

  while (len > 0) {
    80000cc0:	caa5                	beqz	a3,80000d30 <copyin+0x70>
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
    80000cc2:	715d                	addi	sp,sp,-80
    80000cc4:	e486                	sd	ra,72(sp)
    80000cc6:	e0a2                	sd	s0,64(sp)
    80000cc8:	fc26                	sd	s1,56(sp)
    80000cca:	f84a                	sd	s2,48(sp)
    80000ccc:	f44e                	sd	s3,40(sp)
    80000cce:	f052                	sd	s4,32(sp)
    80000cd0:	ec56                	sd	s5,24(sp)
    80000cd2:	e85a                	sd	s6,16(sp)
    80000cd4:	e45e                	sd	s7,8(sp)
    80000cd6:	e062                	sd	s8,0(sp)
    80000cd8:	0880                	addi	s0,sp,80
    80000cda:	8b2a                	mv	s6,a0
    80000cdc:	8a2e                	mv	s4,a1
    80000cde:	8c32                	mv	s8,a2
    80000ce0:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000ce2:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0) return -1;
    n = PGSIZE - (srcva - va0);
    80000ce4:	6a85                	lui	s5,0x1
    80000ce6:	a01d                	j	80000d0c <copyin+0x4c>
    if (n > len) n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ce8:	018505b3          	add	a1,a0,s8
    80000cec:	0004861b          	sext.w	a2,s1
    80000cf0:	412585b3          	sub	a1,a1,s2
    80000cf4:	8552                	mv	a0,s4
    80000cf6:	fffff097          	auipc	ra,0xfffff
    80000cfa:	582080e7          	jalr	1410(ra) # 80000278 <memmove>

    len -= n;
    80000cfe:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000d02:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000d04:	01590c33          	add	s8,s2,s5
  while (len > 0) {
    80000d08:	02098263          	beqz	s3,80000d2c <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000d0c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d10:	85ca                	mv	a1,s2
    80000d12:	855a                	mv	a0,s6
    80000d14:	00000097          	auipc	ra,0x0
    80000d18:	892080e7          	jalr	-1902(ra) # 800005a6 <walkaddr>
    if (pa0 == 0) return -1;
    80000d1c:	cd01                	beqz	a0,80000d34 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000d1e:	418904b3          	sub	s1,s2,s8
    80000d22:	94d6                	add	s1,s1,s5
    80000d24:	fc99f2e3          	bgeu	s3,s1,80000ce8 <copyin+0x28>
    80000d28:	84ce                	mv	s1,s3
    80000d2a:	bf7d                	j	80000ce8 <copyin+0x28>
  }
  return 0;
    80000d2c:	4501                	li	a0,0
    80000d2e:	a021                	j	80000d36 <copyin+0x76>
    80000d30:	4501                	li	a0,0
}
    80000d32:	8082                	ret
    if (pa0 == 0) return -1;
    80000d34:	557d                	li	a0,-1
}
    80000d36:	60a6                	ld	ra,72(sp)
    80000d38:	6406                	ld	s0,64(sp)
    80000d3a:	74e2                	ld	s1,56(sp)
    80000d3c:	7942                	ld	s2,48(sp)
    80000d3e:	79a2                	ld	s3,40(sp)
    80000d40:	7a02                	ld	s4,32(sp)
    80000d42:	6ae2                	ld	s5,24(sp)
    80000d44:	6b42                	ld	s6,16(sp)
    80000d46:	6ba2                	ld	s7,8(sp)
    80000d48:	6c02                	ld	s8,0(sp)
    80000d4a:	6161                	addi	sp,sp,80
    80000d4c:	8082                	ret

0000000080000d4e <copyinstr>:
// Return 0 on success, -1 on error.
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0) {
    80000d4e:	c2dd                	beqz	a3,80000df4 <copyinstr+0xa6>
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
    80000d50:	715d                	addi	sp,sp,-80
    80000d52:	e486                	sd	ra,72(sp)
    80000d54:	e0a2                	sd	s0,64(sp)
    80000d56:	fc26                	sd	s1,56(sp)
    80000d58:	f84a                	sd	s2,48(sp)
    80000d5a:	f44e                	sd	s3,40(sp)
    80000d5c:	f052                	sd	s4,32(sp)
    80000d5e:	ec56                	sd	s5,24(sp)
    80000d60:	e85a                	sd	s6,16(sp)
    80000d62:	e45e                	sd	s7,8(sp)
    80000d64:	0880                	addi	s0,sp,80
    80000d66:	8a2a                	mv	s4,a0
    80000d68:	8b2e                	mv	s6,a1
    80000d6a:	8bb2                	mv	s7,a2
    80000d6c:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000d6e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0) return -1;
    n = PGSIZE - (srcva - va0);
    80000d70:	6985                	lui	s3,0x1
    80000d72:	a02d                	j	80000d9c <copyinstr+0x4e>
    if (n > max) n = max;

    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0) {
      if (*p == '\0') {
        *dst = '\0';
    80000d74:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000d78:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null) {
    80000d7a:	37fd                	addiw	a5,a5,-1
    80000d7c:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000d80:	60a6                	ld	ra,72(sp)
    80000d82:	6406                	ld	s0,64(sp)
    80000d84:	74e2                	ld	s1,56(sp)
    80000d86:	7942                	ld	s2,48(sp)
    80000d88:	79a2                	ld	s3,40(sp)
    80000d8a:	7a02                	ld	s4,32(sp)
    80000d8c:	6ae2                	ld	s5,24(sp)
    80000d8e:	6b42                	ld	s6,16(sp)
    80000d90:	6ba2                	ld	s7,8(sp)
    80000d92:	6161                	addi	sp,sp,80
    80000d94:	8082                	ret
    srcva = va0 + PGSIZE;
    80000d96:	01390bb3          	add	s7,s2,s3
  while (got_null == 0 && max > 0) {
    80000d9a:	c8a9                	beqz	s1,80000dec <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000d9c:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000da0:	85ca                	mv	a1,s2
    80000da2:	8552                	mv	a0,s4
    80000da4:	00000097          	auipc	ra,0x0
    80000da8:	802080e7          	jalr	-2046(ra) # 800005a6 <walkaddr>
    if (pa0 == 0) return -1;
    80000dac:	c131                	beqz	a0,80000df0 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000dae:	417906b3          	sub	a3,s2,s7
    80000db2:	96ce                	add	a3,a3,s3
    80000db4:	00d4f363          	bgeu	s1,a3,80000dba <copyinstr+0x6c>
    80000db8:	86a6                	mv	a3,s1
    char *p = (char *)(pa0 + (srcva - va0));
    80000dba:	955e                	add	a0,a0,s7
    80000dbc:	41250533          	sub	a0,a0,s2
    while (n > 0) {
    80000dc0:	daf9                	beqz	a3,80000d96 <copyinstr+0x48>
    80000dc2:	87da                	mv	a5,s6
      if (*p == '\0') {
    80000dc4:	41650633          	sub	a2,a0,s6
    80000dc8:	fff48593          	addi	a1,s1,-1
    80000dcc:	95da                	add	a1,a1,s6
    while (n > 0) {
    80000dce:	96da                	add	a3,a3,s6
      if (*p == '\0') {
    80000dd0:	00f60733          	add	a4,a2,a5
    80000dd4:	00074703          	lbu	a4,0(a4)
    80000dd8:	df51                	beqz	a4,80000d74 <copyinstr+0x26>
        *dst = *p;
    80000dda:	00e78023          	sb	a4,0(a5)
      --max;
    80000dde:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000de2:	0785                	addi	a5,a5,1
    while (n > 0) {
    80000de4:	fed796e3          	bne	a5,a3,80000dd0 <copyinstr+0x82>
      dst++;
    80000de8:	8b3e                	mv	s6,a5
    80000dea:	b775                	j	80000d96 <copyinstr+0x48>
    80000dec:	4781                	li	a5,0
    80000dee:	b771                	j	80000d7a <copyinstr+0x2c>
    if (pa0 == 0) return -1;
    80000df0:	557d                	li	a0,-1
    80000df2:	b779                	j	80000d80 <copyinstr+0x32>
  int got_null = 0;
    80000df4:	4781                	li	a5,0
  if (got_null) {
    80000df6:	37fd                	addiw	a5,a5,-1
    80000df8:	0007851b          	sext.w	a0,a5
}
    80000dfc:	8082                	ret

0000000080000dfe <unsharepage>:

int unsharepage(pagetable_t pagetable, uint64 va) {
    80000dfe:	7139                	addi	sp,sp,-64
    80000e00:	fc06                	sd	ra,56(sp)
    80000e02:	f822                	sd	s0,48(sp)
    80000e04:	f426                	sd	s1,40(sp)
    80000e06:	f04a                	sd	s2,32(sp)
    80000e08:	ec4e                	sd	s3,24(sp)
    80000e0a:	e852                	sd	s4,16(sp)
    80000e0c:	e456                	sd	s5,8(sp)
    80000e0e:	0080                	addi	s0,sp,64
  va = PGROUNDDOWN(va);
    80000e10:	77fd                	lui	a5,0xfffff
    80000e12:	00f5f4b3          	and	s1,a1,a5
  pte_t *pte;

  if (va >= MAXVA || (pte = walk(pagetable, va, 0)) == 0) {
    80000e16:	57fd                	li	a5,-1
    80000e18:	83e9                	srli	a5,a5,0x1a
    80000e1a:	0c97e463          	bltu	a5,s1,80000ee2 <unsharepage+0xe4>
    80000e1e:	8a2a                	mv	s4,a0
    80000e20:	4601                	li	a2,0
    80000e22:	85a6                	mv	a1,s1
    80000e24:	fffff097          	auipc	ra,0xfffff
    80000e28:	6dc080e7          	jalr	1756(ra) # 80000500 <walk>
    80000e2c:	89aa                	mv	s3,a0
    80000e2e:	cd45                	beqz	a0,80000ee6 <unsharepage+0xe8>
    return -1;
  }

  uint flags = PTE_FLAGS(*pte);
    80000e30:	610c                	ld	a1,0(a0)
    80000e32:	00058a9b          	sext.w	s5,a1

  if (!(flags & PTE_V) || !(flags & PTE_U) ||
    80000e36:	0115f713          	andi	a4,a1,17
    80000e3a:	47c5                	li	a5,17
    80000e3c:	0af71763          	bne	a4,a5,80000eea <unsharepage+0xec>
    80000e40:	104af793          	andi	a5,s5,260
    80000e44:	c7cd                	beqz	a5,80000eee <unsharepage+0xf0>
      (!(flags & PTE_L) && !(flags & PTE_W))) {
    return -1;
  }
  if (!(flags & PTE_L)) {
    80000e46:	100af793          	andi	a5,s5,256
    return 0;
    80000e4a:	4501                	li	a0,0
  if (!(flags & PTE_L)) {
    80000e4c:	eb91                	bnez	a5,80000e60 <unsharepage+0x62>
  if (mappages(pagetable, va, PGSIZE, (uint64)mem, flags) != 0) {
    kfree(mem);
    return -1;
  }
  return 0;
    80000e4e:	70e2                	ld	ra,56(sp)
    80000e50:	7442                	ld	s0,48(sp)
    80000e52:	74a2                	ld	s1,40(sp)
    80000e54:	7902                	ld	s2,32(sp)
    80000e56:	69e2                	ld	s3,24(sp)
    80000e58:	6a42                	ld	s4,16(sp)
    80000e5a:	6aa2                	ld	s5,8(sp)
    80000e5c:	6121                	addi	sp,sp,64
    80000e5e:	8082                	ret
  uint64 pa = PTE2PA(*pte);
    80000e60:	81a9                	srli	a1,a1,0xa
    80000e62:	00c59913          	slli	s2,a1,0xc
  if (ref_change(GETPAGENUM(PTE2PA(*pte)), 0) == 1) {
    80000e66:	80000537          	lui	a0,0x80000
    80000e6a:	954a                	add	a0,a0,s2
    80000e6c:	4581                	li	a1,0
    80000e6e:	8131                	srli	a0,a0,0xc
    80000e70:	fffff097          	auipc	ra,0xfffff
    80000e74:	1ac080e7          	jalr	428(ra) # 8000001c <ref_change>
    80000e78:	4785                	li	a5,1
    80000e7a:	04f50a63          	beq	a0,a5,80000ece <unsharepage+0xd0>
  if ((mem = kalloc()) == 0) {
    80000e7e:	fffff097          	auipc	ra,0xfffff
    80000e82:	324080e7          	jalr	804(ra) # 800001a2 <kalloc>
    80000e86:	89aa                	mv	s3,a0
    80000e88:	c52d                	beqz	a0,80000ef2 <unsharepage+0xf4>
  memmove(mem, (char *)pa, PGSIZE);
    80000e8a:	6605                	lui	a2,0x1
    80000e8c:	85ca                	mv	a1,s2
    80000e8e:	fffff097          	auipc	ra,0xfffff
    80000e92:	3ea080e7          	jalr	1002(ra) # 80000278 <memmove>
  uvmunmap(pagetable, va, 1, 1);
    80000e96:	4685                	li	a3,1
    80000e98:	4605                	li	a2,1
    80000e9a:	85a6                	mv	a1,s1
    80000e9c:	8552                	mv	a0,s4
    80000e9e:	00000097          	auipc	ra,0x0
    80000ea2:	934080e7          	jalr	-1740(ra) # 800007d2 <uvmunmap>
  flags &= ~PTE_L;
    80000ea6:	2ffaf713          	andi	a4,s5,767
  if (mappages(pagetable, va, PGSIZE, (uint64)mem, flags) != 0) {
    80000eaa:	00476713          	ori	a4,a4,4
    80000eae:	86ce                	mv	a3,s3
    80000eb0:	6605                	lui	a2,0x1
    80000eb2:	85a6                	mv	a1,s1
    80000eb4:	8552                	mv	a0,s4
    80000eb6:	fffff097          	auipc	ra,0xfffff
    80000eba:	732080e7          	jalr	1842(ra) # 800005e8 <mappages>
    80000ebe:	d941                	beqz	a0,80000e4e <unsharepage+0x50>
    kfree(mem);
    80000ec0:	854e                	mv	a0,s3
    80000ec2:	fffff097          	auipc	ra,0xfffff
    80000ec6:	1ac080e7          	jalr	428(ra) # 8000006e <kfree>
    return -1;
    80000eca:	557d                	li	a0,-1
    80000ecc:	b749                	j	80000e4e <unsharepage+0x50>
    *pte &= ~(PTE_L);
    80000ece:	0009b783          	ld	a5,0(s3) # 1000 <_entry-0x7ffff000>
    80000ed2:	eff7f793          	andi	a5,a5,-257
    *pte |= PTE_W;
    80000ed6:	0047e793          	ori	a5,a5,4
    80000eda:	00f9b023          	sd	a5,0(s3)
    return 0;
    80000ede:	4501                	li	a0,0
    80000ee0:	b7bd                	j	80000e4e <unsharepage+0x50>
    return -1;
    80000ee2:	557d                	li	a0,-1
    80000ee4:	b7ad                	j	80000e4e <unsharepage+0x50>
    80000ee6:	557d                	li	a0,-1
    80000ee8:	b79d                	j	80000e4e <unsharepage+0x50>
    return -1;
    80000eea:	557d                	li	a0,-1
    80000eec:	b78d                	j	80000e4e <unsharepage+0x50>
    80000eee:	557d                	li	a0,-1
    80000ef0:	bfb9                	j	80000e4e <unsharepage+0x50>
    return -1;
    80000ef2:	557d                	li	a0,-1
    80000ef4:	bfa9                	j	80000e4e <unsharepage+0x50>

0000000080000ef6 <copyout>:
  while (len > 0) {
    80000ef6:	cac9                	beqz	a3,80000f88 <copyout+0x92>
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
    80000ef8:	711d                	addi	sp,sp,-96
    80000efa:	ec86                	sd	ra,88(sp)
    80000efc:	e8a2                	sd	s0,80(sp)
    80000efe:	e4a6                	sd	s1,72(sp)
    80000f00:	e0ca                	sd	s2,64(sp)
    80000f02:	fc4e                	sd	s3,56(sp)
    80000f04:	f852                	sd	s4,48(sp)
    80000f06:	f456                	sd	s5,40(sp)
    80000f08:	f05a                	sd	s6,32(sp)
    80000f0a:	ec5e                	sd	s7,24(sp)
    80000f0c:	e862                	sd	s8,16(sp)
    80000f0e:	e466                	sd	s9,8(sp)
    80000f10:	e06a                	sd	s10,0(sp)
    80000f12:	1080                	addi	s0,sp,96
    80000f14:	8b2a                	mv	s6,a0
    80000f16:	8a2e                	mv	s4,a1
    80000f18:	8ab2                	mv	s5,a2
    80000f1a:	89b6                	mv	s3,a3
    if (dstva >= MAXVA) return -1;
    80000f1c:	57fd                	li	a5,-1
    80000f1e:	83e9                	srli	a5,a5,0x1a
    80000f20:	06b7e663          	bltu	a5,a1,80000f8c <copyout+0x96>
    va0 = PGROUNDDOWN(dstva);
    80000f24:	74fd                	lui	s1,0xfffff
    80000f26:	8ced                	and	s1,s1,a1
    if (unsharepage(pagetable, dstva) == -1) {
    80000f28:	5bfd                	li	s7,-1
    80000f2a:	6c05                	lui	s8,0x1
    if (dstva >= MAXVA) return -1;
    80000f2c:	8cbe                	mv	s9,a5
    80000f2e:	a025                	j	80000f56 <copyout+0x60>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000f30:	409a04b3          	sub	s1,s4,s1
    80000f34:	0009061b          	sext.w	a2,s2
    80000f38:	85d6                	mv	a1,s5
    80000f3a:	9526                	add	a0,a0,s1
    80000f3c:	fffff097          	auipc	ra,0xfffff
    80000f40:	33c080e7          	jalr	828(ra) # 80000278 <memmove>
    len -= n;
    80000f44:	412989b3          	sub	s3,s3,s2
    src += n;
    80000f48:	9aca                	add	s5,s5,s2
  while (len > 0) {
    80000f4a:	02098d63          	beqz	s3,80000f84 <copyout+0x8e>
    if (dstva >= MAXVA) return -1;
    80000f4e:	05ace163          	bltu	s9,s10,80000f90 <copyout+0x9a>
    va0 = PGROUNDDOWN(dstva);
    80000f52:	84ea                	mv	s1,s10
    dstva = va0 + PGSIZE;
    80000f54:	8a6a                	mv	s4,s10
    if (unsharepage(pagetable, dstva) == -1) {
    80000f56:	85d2                	mv	a1,s4
    80000f58:	855a                	mv	a0,s6
    80000f5a:	00000097          	auipc	ra,0x0
    80000f5e:	ea4080e7          	jalr	-348(ra) # 80000dfe <unsharepage>
    80000f62:	03750a63          	beq	a0,s7,80000f96 <copyout+0xa0>
    if ((pa0 = walkaddr(pagetable, va0)) == 0) {
    80000f66:	85a6                	mv	a1,s1
    80000f68:	855a                	mv	a0,s6
    80000f6a:	fffff097          	auipc	ra,0xfffff
    80000f6e:	63c080e7          	jalr	1596(ra) # 800005a6 <walkaddr>
    80000f72:	c10d                	beqz	a0,80000f94 <copyout+0x9e>
    n = PGSIZE - (dstva - va0);
    80000f74:	01848d33          	add	s10,s1,s8
    80000f78:	414d0933          	sub	s2,s10,s4
    80000f7c:	fb29fae3          	bgeu	s3,s2,80000f30 <copyout+0x3a>
    80000f80:	894e                	mv	s2,s3
    80000f82:	b77d                	j	80000f30 <copyout+0x3a>
  return 0;
    80000f84:	4501                	li	a0,0
    80000f86:	a801                	j	80000f96 <copyout+0xa0>
    80000f88:	4501                	li	a0,0
}
    80000f8a:	8082                	ret
    if (dstva >= MAXVA) return -1;
    80000f8c:	557d                	li	a0,-1
    80000f8e:	a021                	j	80000f96 <copyout+0xa0>
    80000f90:	557d                	li	a0,-1
    80000f92:	a011                	j	80000f96 <copyout+0xa0>
      return -1;
    80000f94:	557d                	li	a0,-1
}
    80000f96:	60e6                	ld	ra,88(sp)
    80000f98:	6446                	ld	s0,80(sp)
    80000f9a:	64a6                	ld	s1,72(sp)
    80000f9c:	6906                	ld	s2,64(sp)
    80000f9e:	79e2                	ld	s3,56(sp)
    80000fa0:	7a42                	ld	s4,48(sp)
    80000fa2:	7aa2                	ld	s5,40(sp)
    80000fa4:	7b02                	ld	s6,32(sp)
    80000fa6:	6be2                	ld	s7,24(sp)
    80000fa8:	6c42                	ld	s8,16(sp)
    80000faa:	6ca2                	ld	s9,8(sp)
    80000fac:	6d02                	ld	s10,0(sp)
    80000fae:	6125                	addi	sp,sp,96
    80000fb0:	8082                	ret

0000000080000fb2 <proc_mapstacks>:
struct spinlock wait_lock;

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl) {
    80000fb2:	7139                	addi	sp,sp,-64
    80000fb4:	fc06                	sd	ra,56(sp)
    80000fb6:	f822                	sd	s0,48(sp)
    80000fb8:	f426                	sd	s1,40(sp)
    80000fba:	f04a                	sd	s2,32(sp)
    80000fbc:	ec4e                	sd	s3,24(sp)
    80000fbe:	e852                	sd	s4,16(sp)
    80000fc0:	e456                	sd	s5,8(sp)
    80000fc2:	e05a                	sd	s6,0(sp)
    80000fc4:	0080                	addi	s0,sp,64
    80000fc6:	89aa                	mv	s3,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80000fc8:	00028497          	auipc	s1,0x28
    80000fcc:	e0048493          	addi	s1,s1,-512 # 80028dc8 <proc>
    char *pa = kalloc();
    if (pa == 0) panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80000fd0:	8b26                	mv	s6,s1
    80000fd2:	00007a97          	auipc	s5,0x7
    80000fd6:	02ea8a93          	addi	s5,s5,46 # 80008000 <etext>
    80000fda:	04000937          	lui	s2,0x4000
    80000fde:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000fe0:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80000fe2:	0002da17          	auipc	s4,0x2d
    80000fe6:	7e6a0a13          	addi	s4,s4,2022 # 8002e7c8 <tickslock>
    char *pa = kalloc();
    80000fea:	fffff097          	auipc	ra,0xfffff
    80000fee:	1b8080e7          	jalr	440(ra) # 800001a2 <kalloc>
    80000ff2:	862a                	mv	a2,a0
    if (pa == 0) panic("kalloc");
    80000ff4:	c131                	beqz	a0,80001038 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int)(p - proc));
    80000ff6:	416485b3          	sub	a1,s1,s6
    80000ffa:	858d                	srai	a1,a1,0x3
    80000ffc:	000ab783          	ld	a5,0(s5)
    80001000:	02f585b3          	mul	a1,a1,a5
    80001004:	2585                	addiw	a1,a1,1
    80001006:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000100a:	4719                	li	a4,6
    8000100c:	6685                	lui	a3,0x1
    8000100e:	40b905b3          	sub	a1,s2,a1
    80001012:	854e                	mv	a0,s3
    80001014:	fffff097          	auipc	ra,0xfffff
    80001018:	698080e7          	jalr	1688(ra) # 800006ac <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000101c:	16848493          	addi	s1,s1,360
    80001020:	fd4495e3          	bne	s1,s4,80000fea <proc_mapstacks+0x38>
  }
}
    80001024:	70e2                	ld	ra,56(sp)
    80001026:	7442                	ld	s0,48(sp)
    80001028:	74a2                	ld	s1,40(sp)
    8000102a:	7902                	ld	s2,32(sp)
    8000102c:	69e2                	ld	s3,24(sp)
    8000102e:	6a42                	ld	s4,16(sp)
    80001030:	6aa2                	ld	s5,8(sp)
    80001032:	6b02                	ld	s6,0(sp)
    80001034:	6121                	addi	sp,sp,64
    80001036:	8082                	ret
    if (pa == 0) panic("kalloc");
    80001038:	00007517          	auipc	a0,0x7
    8000103c:	1a050513          	addi	a0,a0,416 # 800081d8 <etext+0x1d8>
    80001040:	00005097          	auipc	ra,0x5
    80001044:	e6c080e7          	jalr	-404(ra) # 80005eac <panic>

0000000080001048 <procinit>:

// initialize the proc table.
void procinit(void) {
    80001048:	7139                	addi	sp,sp,-64
    8000104a:	fc06                	sd	ra,56(sp)
    8000104c:	f822                	sd	s0,48(sp)
    8000104e:	f426                	sd	s1,40(sp)
    80001050:	f04a                	sd	s2,32(sp)
    80001052:	ec4e                	sd	s3,24(sp)
    80001054:	e852                	sd	s4,16(sp)
    80001056:	e456                	sd	s5,8(sp)
    80001058:	e05a                	sd	s6,0(sp)
    8000105a:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    8000105c:	00007597          	auipc	a1,0x7
    80001060:	18458593          	addi	a1,a1,388 # 800081e0 <etext+0x1e0>
    80001064:	00028517          	auipc	a0,0x28
    80001068:	93450513          	addi	a0,a0,-1740 # 80028998 <pid_lock>
    8000106c:	00005097          	auipc	ra,0x5
    80001070:	2e8080e7          	jalr	744(ra) # 80006354 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001074:	00007597          	auipc	a1,0x7
    80001078:	17458593          	addi	a1,a1,372 # 800081e8 <etext+0x1e8>
    8000107c:	00028517          	auipc	a0,0x28
    80001080:	93450513          	addi	a0,a0,-1740 # 800289b0 <wait_lock>
    80001084:	00005097          	auipc	ra,0x5
    80001088:	2d0080e7          	jalr	720(ra) # 80006354 <initlock>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000108c:	00028497          	auipc	s1,0x28
    80001090:	d3c48493          	addi	s1,s1,-708 # 80028dc8 <proc>
    initlock(&p->lock, "proc");
    80001094:	00007b17          	auipc	s6,0x7
    80001098:	164b0b13          	addi	s6,s6,356 # 800081f8 <etext+0x1f8>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    8000109c:	8aa6                	mv	s5,s1
    8000109e:	00007a17          	auipc	s4,0x7
    800010a2:	f62a0a13          	addi	s4,s4,-158 # 80008000 <etext>
    800010a6:	04000937          	lui	s2,0x4000
    800010aa:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    800010ac:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    800010ae:	0002d997          	auipc	s3,0x2d
    800010b2:	71a98993          	addi	s3,s3,1818 # 8002e7c8 <tickslock>
    initlock(&p->lock, "proc");
    800010b6:	85da                	mv	a1,s6
    800010b8:	8526                	mv	a0,s1
    800010ba:	00005097          	auipc	ra,0x5
    800010be:	29a080e7          	jalr	666(ra) # 80006354 <initlock>
    p->state = UNUSED;
    800010c2:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    800010c6:	415487b3          	sub	a5,s1,s5
    800010ca:	878d                	srai	a5,a5,0x3
    800010cc:	000a3703          	ld	a4,0(s4)
    800010d0:	02e787b3          	mul	a5,a5,a4
    800010d4:	2785                	addiw	a5,a5,1 # fffffffffffff001 <end+0xffffffff7ffbd211>
    800010d6:	00d7979b          	slliw	a5,a5,0xd
    800010da:	40f907b3          	sub	a5,s2,a5
    800010de:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    800010e0:	16848493          	addi	s1,s1,360
    800010e4:	fd3499e3          	bne	s1,s3,800010b6 <procinit+0x6e>
  }
}
    800010e8:	70e2                	ld	ra,56(sp)
    800010ea:	7442                	ld	s0,48(sp)
    800010ec:	74a2                	ld	s1,40(sp)
    800010ee:	7902                	ld	s2,32(sp)
    800010f0:	69e2                	ld	s3,24(sp)
    800010f2:	6a42                	ld	s4,16(sp)
    800010f4:	6aa2                	ld	s5,8(sp)
    800010f6:	6b02                	ld	s6,0(sp)
    800010f8:	6121                	addi	sp,sp,64
    800010fa:	8082                	ret

00000000800010fc <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid() {
    800010fc:	1141                	addi	sp,sp,-16
    800010fe:	e422                	sd	s0,8(sp)
    80001100:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    80001102:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001104:	2501                	sext.w	a0,a0
    80001106:	6422                	ld	s0,8(sp)
    80001108:	0141                	addi	sp,sp,16
    8000110a:	8082                	ret

000000008000110c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *mycpu(void) {
    8000110c:	1141                	addi	sp,sp,-16
    8000110e:	e422                	sd	s0,8(sp)
    80001110:	0800                	addi	s0,sp,16
    80001112:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001114:	2781                	sext.w	a5,a5
    80001116:	079e                	slli	a5,a5,0x7
  return c;
}
    80001118:	00028517          	auipc	a0,0x28
    8000111c:	8b050513          	addi	a0,a0,-1872 # 800289c8 <cpus>
    80001120:	953e                	add	a0,a0,a5
    80001122:	6422                	ld	s0,8(sp)
    80001124:	0141                	addi	sp,sp,16
    80001126:	8082                	ret

0000000080001128 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *myproc(void) {
    80001128:	1101                	addi	sp,sp,-32
    8000112a:	ec06                	sd	ra,24(sp)
    8000112c:	e822                	sd	s0,16(sp)
    8000112e:	e426                	sd	s1,8(sp)
    80001130:	1000                	addi	s0,sp,32
  push_off();
    80001132:	00005097          	auipc	ra,0x5
    80001136:	266080e7          	jalr	614(ra) # 80006398 <push_off>
    8000113a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000113c:	2781                	sext.w	a5,a5
    8000113e:	079e                	slli	a5,a5,0x7
    80001140:	00028717          	auipc	a4,0x28
    80001144:	85870713          	addi	a4,a4,-1960 # 80028998 <pid_lock>
    80001148:	97ba                	add	a5,a5,a4
    8000114a:	7b84                	ld	s1,48(a5)
  pop_off();
    8000114c:	00005097          	auipc	ra,0x5
    80001150:	2ec080e7          	jalr	748(ra) # 80006438 <pop_off>
  return p;
}
    80001154:	8526                	mv	a0,s1
    80001156:	60e2                	ld	ra,24(sp)
    80001158:	6442                	ld	s0,16(sp)
    8000115a:	64a2                	ld	s1,8(sp)
    8000115c:	6105                	addi	sp,sp,32
    8000115e:	8082                	ret

0000000080001160 <forkret>:
  release(&p->lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void) {
    80001160:	1141                	addi	sp,sp,-16
    80001162:	e406                	sd	ra,8(sp)
    80001164:	e022                	sd	s0,0(sp)
    80001166:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001168:	00000097          	auipc	ra,0x0
    8000116c:	fc0080e7          	jalr	-64(ra) # 80001128 <myproc>
    80001170:	00005097          	auipc	ra,0x5
    80001174:	328080e7          	jalr	808(ra) # 80006498 <release>

  if (first) {
    80001178:	00007797          	auipc	a5,0x7
    8000117c:	7487a783          	lw	a5,1864(a5) # 800088c0 <first.1>
    80001180:	eb89                	bnez	a5,80001192 <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001182:	00001097          	auipc	ra,0x1
    80001186:	c60080e7          	jalr	-928(ra) # 80001de2 <usertrapret>
}
    8000118a:	60a2                	ld	ra,8(sp)
    8000118c:	6402                	ld	s0,0(sp)
    8000118e:	0141                	addi	sp,sp,16
    80001190:	8082                	ret
    fsinit(ROOTDEV);
    80001192:	4505                	li	a0,1
    80001194:	00002097          	auipc	ra,0x2
    80001198:	9d4080e7          	jalr	-1580(ra) # 80002b68 <fsinit>
    first = 0;
    8000119c:	00007797          	auipc	a5,0x7
    800011a0:	7207a223          	sw	zero,1828(a5) # 800088c0 <first.1>
    __sync_synchronize();
    800011a4:	0ff0000f          	fence
    800011a8:	bfe9                	j	80001182 <forkret+0x22>

00000000800011aa <allocpid>:
int allocpid() {
    800011aa:	1101                	addi	sp,sp,-32
    800011ac:	ec06                	sd	ra,24(sp)
    800011ae:	e822                	sd	s0,16(sp)
    800011b0:	e426                	sd	s1,8(sp)
    800011b2:	e04a                	sd	s2,0(sp)
    800011b4:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800011b6:	00027917          	auipc	s2,0x27
    800011ba:	7e290913          	addi	s2,s2,2018 # 80028998 <pid_lock>
    800011be:	854a                	mv	a0,s2
    800011c0:	00005097          	auipc	ra,0x5
    800011c4:	224080e7          	jalr	548(ra) # 800063e4 <acquire>
  pid = nextpid;
    800011c8:	00007797          	auipc	a5,0x7
    800011cc:	6fc78793          	addi	a5,a5,1788 # 800088c4 <nextpid>
    800011d0:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800011d2:	0014871b          	addiw	a4,s1,1
    800011d6:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800011d8:	854a                	mv	a0,s2
    800011da:	00005097          	auipc	ra,0x5
    800011de:	2be080e7          	jalr	702(ra) # 80006498 <release>
}
    800011e2:	8526                	mv	a0,s1
    800011e4:	60e2                	ld	ra,24(sp)
    800011e6:	6442                	ld	s0,16(sp)
    800011e8:	64a2                	ld	s1,8(sp)
    800011ea:	6902                	ld	s2,0(sp)
    800011ec:	6105                	addi	sp,sp,32
    800011ee:	8082                	ret

00000000800011f0 <proc_pagetable>:
pagetable_t proc_pagetable(struct proc *p) {
    800011f0:	1101                	addi	sp,sp,-32
    800011f2:	ec06                	sd	ra,24(sp)
    800011f4:	e822                	sd	s0,16(sp)
    800011f6:	e426                	sd	s1,8(sp)
    800011f8:	e04a                	sd	s2,0(sp)
    800011fa:	1000                	addi	s0,sp,32
    800011fc:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800011fe:	fffff097          	auipc	ra,0xfffff
    80001202:	698080e7          	jalr	1688(ra) # 80000896 <uvmcreate>
    80001206:	84aa                	mv	s1,a0
  if (pagetable == 0) return 0;
    80001208:	c121                	beqz	a0,80001248 <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    8000120a:	4729                	li	a4,10
    8000120c:	00006697          	auipc	a3,0x6
    80001210:	df468693          	addi	a3,a3,-524 # 80007000 <_trampoline>
    80001214:	6605                	lui	a2,0x1
    80001216:	040005b7          	lui	a1,0x4000
    8000121a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000121c:	05b2                	slli	a1,a1,0xc
    8000121e:	fffff097          	auipc	ra,0xfffff
    80001222:	3ca080e7          	jalr	970(ra) # 800005e8 <mappages>
    80001226:	02054863          	bltz	a0,80001256 <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    8000122a:	4719                	li	a4,6
    8000122c:	05893683          	ld	a3,88(s2)
    80001230:	6605                	lui	a2,0x1
    80001232:	020005b7          	lui	a1,0x2000
    80001236:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001238:	05b6                	slli	a1,a1,0xd
    8000123a:	8526                	mv	a0,s1
    8000123c:	fffff097          	auipc	ra,0xfffff
    80001240:	3ac080e7          	jalr	940(ra) # 800005e8 <mappages>
    80001244:	02054163          	bltz	a0,80001266 <proc_pagetable+0x76>
}
    80001248:	8526                	mv	a0,s1
    8000124a:	60e2                	ld	ra,24(sp)
    8000124c:	6442                	ld	s0,16(sp)
    8000124e:	64a2                	ld	s1,8(sp)
    80001250:	6902                	ld	s2,0(sp)
    80001252:	6105                	addi	sp,sp,32
    80001254:	8082                	ret
    uvmfree(pagetable, 0);
    80001256:	4581                	li	a1,0
    80001258:	8526                	mv	a0,s1
    8000125a:	00000097          	auipc	ra,0x0
    8000125e:	924080e7          	jalr	-1756(ra) # 80000b7e <uvmfree>
    return 0;
    80001262:	4481                	li	s1,0
    80001264:	b7d5                	j	80001248 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001266:	4681                	li	a3,0
    80001268:	4605                	li	a2,1
    8000126a:	040005b7          	lui	a1,0x4000
    8000126e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001270:	05b2                	slli	a1,a1,0xc
    80001272:	8526                	mv	a0,s1
    80001274:	fffff097          	auipc	ra,0xfffff
    80001278:	55e080e7          	jalr	1374(ra) # 800007d2 <uvmunmap>
    uvmfree(pagetable, 0);
    8000127c:	4581                	li	a1,0
    8000127e:	8526                	mv	a0,s1
    80001280:	00000097          	auipc	ra,0x0
    80001284:	8fe080e7          	jalr	-1794(ra) # 80000b7e <uvmfree>
    return 0;
    80001288:	4481                	li	s1,0
    8000128a:	bf7d                	j	80001248 <proc_pagetable+0x58>

000000008000128c <proc_freepagetable>:
void proc_freepagetable(pagetable_t pagetable, uint64 sz) {
    8000128c:	1101                	addi	sp,sp,-32
    8000128e:	ec06                	sd	ra,24(sp)
    80001290:	e822                	sd	s0,16(sp)
    80001292:	e426                	sd	s1,8(sp)
    80001294:	e04a                	sd	s2,0(sp)
    80001296:	1000                	addi	s0,sp,32
    80001298:	84aa                	mv	s1,a0
    8000129a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000129c:	4681                	li	a3,0
    8000129e:	4605                	li	a2,1
    800012a0:	040005b7          	lui	a1,0x4000
    800012a4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800012a6:	05b2                	slli	a1,a1,0xc
    800012a8:	fffff097          	auipc	ra,0xfffff
    800012ac:	52a080e7          	jalr	1322(ra) # 800007d2 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800012b0:	4681                	li	a3,0
    800012b2:	4605                	li	a2,1
    800012b4:	020005b7          	lui	a1,0x2000
    800012b8:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800012ba:	05b6                	slli	a1,a1,0xd
    800012bc:	8526                	mv	a0,s1
    800012be:	fffff097          	auipc	ra,0xfffff
    800012c2:	514080e7          	jalr	1300(ra) # 800007d2 <uvmunmap>
  uvmfree(pagetable, sz);
    800012c6:	85ca                	mv	a1,s2
    800012c8:	8526                	mv	a0,s1
    800012ca:	00000097          	auipc	ra,0x0
    800012ce:	8b4080e7          	jalr	-1868(ra) # 80000b7e <uvmfree>
}
    800012d2:	60e2                	ld	ra,24(sp)
    800012d4:	6442                	ld	s0,16(sp)
    800012d6:	64a2                	ld	s1,8(sp)
    800012d8:	6902                	ld	s2,0(sp)
    800012da:	6105                	addi	sp,sp,32
    800012dc:	8082                	ret

00000000800012de <freeproc>:
static void freeproc(struct proc *p) {
    800012de:	1101                	addi	sp,sp,-32
    800012e0:	ec06                	sd	ra,24(sp)
    800012e2:	e822                	sd	s0,16(sp)
    800012e4:	e426                	sd	s1,8(sp)
    800012e6:	1000                	addi	s0,sp,32
    800012e8:	84aa                	mv	s1,a0
  if (p->trapframe) kfree((void *)p->trapframe);
    800012ea:	6d28                	ld	a0,88(a0)
    800012ec:	c509                	beqz	a0,800012f6 <freeproc+0x18>
    800012ee:	fffff097          	auipc	ra,0xfffff
    800012f2:	d80080e7          	jalr	-640(ra) # 8000006e <kfree>
  p->trapframe = 0;
    800012f6:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable) proc_freepagetable(p->pagetable, p->sz);
    800012fa:	68a8                	ld	a0,80(s1)
    800012fc:	c511                	beqz	a0,80001308 <freeproc+0x2a>
    800012fe:	64ac                	ld	a1,72(s1)
    80001300:	00000097          	auipc	ra,0x0
    80001304:	f8c080e7          	jalr	-116(ra) # 8000128c <proc_freepagetable>
  p->pagetable = 0;
    80001308:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000130c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001310:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001314:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001318:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000131c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001320:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001324:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001328:	0004ac23          	sw	zero,24(s1)
}
    8000132c:	60e2                	ld	ra,24(sp)
    8000132e:	6442                	ld	s0,16(sp)
    80001330:	64a2                	ld	s1,8(sp)
    80001332:	6105                	addi	sp,sp,32
    80001334:	8082                	ret

0000000080001336 <allocproc>:
static struct proc *allocproc(void) {
    80001336:	1101                	addi	sp,sp,-32
    80001338:	ec06                	sd	ra,24(sp)
    8000133a:	e822                	sd	s0,16(sp)
    8000133c:	e426                	sd	s1,8(sp)
    8000133e:	e04a                	sd	s2,0(sp)
    80001340:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    80001342:	00028497          	auipc	s1,0x28
    80001346:	a8648493          	addi	s1,s1,-1402 # 80028dc8 <proc>
    8000134a:	0002d917          	auipc	s2,0x2d
    8000134e:	47e90913          	addi	s2,s2,1150 # 8002e7c8 <tickslock>
    acquire(&p->lock);
    80001352:	8526                	mv	a0,s1
    80001354:	00005097          	auipc	ra,0x5
    80001358:	090080e7          	jalr	144(ra) # 800063e4 <acquire>
    if (p->state == UNUSED) {
    8000135c:	4c9c                	lw	a5,24(s1)
    8000135e:	cf81                	beqz	a5,80001376 <allocproc+0x40>
      release(&p->lock);
    80001360:	8526                	mv	a0,s1
    80001362:	00005097          	auipc	ra,0x5
    80001366:	136080e7          	jalr	310(ra) # 80006498 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000136a:	16848493          	addi	s1,s1,360
    8000136e:	ff2492e3          	bne	s1,s2,80001352 <allocproc+0x1c>
  return 0;
    80001372:	4481                	li	s1,0
    80001374:	a889                	j	800013c6 <allocproc+0x90>
  p->pid = allocpid();
    80001376:	00000097          	auipc	ra,0x0
    8000137a:	e34080e7          	jalr	-460(ra) # 800011aa <allocpid>
    8000137e:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001380:	4785                	li	a5,1
    80001382:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    80001384:	fffff097          	auipc	ra,0xfffff
    80001388:	e1e080e7          	jalr	-482(ra) # 800001a2 <kalloc>
    8000138c:	892a                	mv	s2,a0
    8000138e:	eca8                	sd	a0,88(s1)
    80001390:	c131                	beqz	a0,800013d4 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001392:	8526                	mv	a0,s1
    80001394:	00000097          	auipc	ra,0x0
    80001398:	e5c080e7          	jalr	-420(ra) # 800011f0 <proc_pagetable>
    8000139c:	892a                	mv	s2,a0
    8000139e:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    800013a0:	c531                	beqz	a0,800013ec <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800013a2:	07000613          	li	a2,112
    800013a6:	4581                	li	a1,0
    800013a8:	06048513          	addi	a0,s1,96
    800013ac:	fffff097          	auipc	ra,0xfffff
    800013b0:	e70080e7          	jalr	-400(ra) # 8000021c <memset>
  p->context.ra = (uint64)forkret;
    800013b4:	00000797          	auipc	a5,0x0
    800013b8:	dac78793          	addi	a5,a5,-596 # 80001160 <forkret>
    800013bc:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800013be:	60bc                	ld	a5,64(s1)
    800013c0:	6705                	lui	a4,0x1
    800013c2:	97ba                	add	a5,a5,a4
    800013c4:	f4bc                	sd	a5,104(s1)
}
    800013c6:	8526                	mv	a0,s1
    800013c8:	60e2                	ld	ra,24(sp)
    800013ca:	6442                	ld	s0,16(sp)
    800013cc:	64a2                	ld	s1,8(sp)
    800013ce:	6902                	ld	s2,0(sp)
    800013d0:	6105                	addi	sp,sp,32
    800013d2:	8082                	ret
    freeproc(p);
    800013d4:	8526                	mv	a0,s1
    800013d6:	00000097          	auipc	ra,0x0
    800013da:	f08080e7          	jalr	-248(ra) # 800012de <freeproc>
    release(&p->lock);
    800013de:	8526                	mv	a0,s1
    800013e0:	00005097          	auipc	ra,0x5
    800013e4:	0b8080e7          	jalr	184(ra) # 80006498 <release>
    return 0;
    800013e8:	84ca                	mv	s1,s2
    800013ea:	bff1                	j	800013c6 <allocproc+0x90>
    freeproc(p);
    800013ec:	8526                	mv	a0,s1
    800013ee:	00000097          	auipc	ra,0x0
    800013f2:	ef0080e7          	jalr	-272(ra) # 800012de <freeproc>
    release(&p->lock);
    800013f6:	8526                	mv	a0,s1
    800013f8:	00005097          	auipc	ra,0x5
    800013fc:	0a0080e7          	jalr	160(ra) # 80006498 <release>
    return 0;
    80001400:	84ca                	mv	s1,s2
    80001402:	b7d1                	j	800013c6 <allocproc+0x90>

0000000080001404 <userinit>:
void userinit(void) {
    80001404:	1101                	addi	sp,sp,-32
    80001406:	ec06                	sd	ra,24(sp)
    80001408:	e822                	sd	s0,16(sp)
    8000140a:	e426                	sd	s1,8(sp)
    8000140c:	1000                	addi	s0,sp,32
  p = allocproc();
    8000140e:	00000097          	auipc	ra,0x0
    80001412:	f28080e7          	jalr	-216(ra) # 80001336 <allocproc>
    80001416:	84aa                	mv	s1,a0
  initproc = p;
    80001418:	00007797          	auipc	a5,0x7
    8000141c:	52a7b423          	sd	a0,1320(a5) # 80008940 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001420:	03400613          	li	a2,52
    80001424:	00007597          	auipc	a1,0x7
    80001428:	4ac58593          	addi	a1,a1,1196 # 800088d0 <initcode>
    8000142c:	6928                	ld	a0,80(a0)
    8000142e:	fffff097          	auipc	ra,0xfffff
    80001432:	496080e7          	jalr	1174(ra) # 800008c4 <uvmfirst>
  p->sz = PGSIZE;
    80001436:	6785                	lui	a5,0x1
    80001438:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000143a:	6cb8                	ld	a4,88(s1)
    8000143c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001440:	6cb8                	ld	a4,88(s1)
    80001442:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001444:	4641                	li	a2,16
    80001446:	00007597          	auipc	a1,0x7
    8000144a:	dba58593          	addi	a1,a1,-582 # 80008200 <etext+0x200>
    8000144e:	15848513          	addi	a0,s1,344
    80001452:	fffff097          	auipc	ra,0xfffff
    80001456:	f14080e7          	jalr	-236(ra) # 80000366 <safestrcpy>
  p->cwd = namei("/");
    8000145a:	00007517          	auipc	a0,0x7
    8000145e:	db650513          	addi	a0,a0,-586 # 80008210 <etext+0x210>
    80001462:	00002097          	auipc	ra,0x2
    80001466:	130080e7          	jalr	304(ra) # 80003592 <namei>
    8000146a:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000146e:	478d                	li	a5,3
    80001470:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001472:	8526                	mv	a0,s1
    80001474:	00005097          	auipc	ra,0x5
    80001478:	024080e7          	jalr	36(ra) # 80006498 <release>
}
    8000147c:	60e2                	ld	ra,24(sp)
    8000147e:	6442                	ld	s0,16(sp)
    80001480:	64a2                	ld	s1,8(sp)
    80001482:	6105                	addi	sp,sp,32
    80001484:	8082                	ret

0000000080001486 <growproc>:
int growproc(int n) {
    80001486:	1101                	addi	sp,sp,-32
    80001488:	ec06                	sd	ra,24(sp)
    8000148a:	e822                	sd	s0,16(sp)
    8000148c:	e426                	sd	s1,8(sp)
    8000148e:	e04a                	sd	s2,0(sp)
    80001490:	1000                	addi	s0,sp,32
    80001492:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001494:	00000097          	auipc	ra,0x0
    80001498:	c94080e7          	jalr	-876(ra) # 80001128 <myproc>
    8000149c:	84aa                	mv	s1,a0
  sz = p->sz;
    8000149e:	652c                	ld	a1,72(a0)
  if (n > 0) {
    800014a0:	01204c63          	bgtz	s2,800014b8 <growproc+0x32>
  } else if (n < 0) {
    800014a4:	02094663          	bltz	s2,800014d0 <growproc+0x4a>
  p->sz = sz;
    800014a8:	e4ac                	sd	a1,72(s1)
  return 0;
    800014aa:	4501                	li	a0,0
}
    800014ac:	60e2                	ld	ra,24(sp)
    800014ae:	6442                	ld	s0,16(sp)
    800014b0:	64a2                	ld	s1,8(sp)
    800014b2:	6902                	ld	s2,0(sp)
    800014b4:	6105                	addi	sp,sp,32
    800014b6:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800014b8:	4691                	li	a3,4
    800014ba:	00b90633          	add	a2,s2,a1
    800014be:	6928                	ld	a0,80(a0)
    800014c0:	fffff097          	auipc	ra,0xfffff
    800014c4:	4be080e7          	jalr	1214(ra) # 8000097e <uvmalloc>
    800014c8:	85aa                	mv	a1,a0
    800014ca:	fd79                	bnez	a0,800014a8 <growproc+0x22>
      return -1;
    800014cc:	557d                	li	a0,-1
    800014ce:	bff9                	j	800014ac <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800014d0:	00b90633          	add	a2,s2,a1
    800014d4:	6928                	ld	a0,80(a0)
    800014d6:	fffff097          	auipc	ra,0xfffff
    800014da:	460080e7          	jalr	1120(ra) # 80000936 <uvmdealloc>
    800014de:	85aa                	mv	a1,a0
    800014e0:	b7e1                	j	800014a8 <growproc+0x22>

00000000800014e2 <fork>:
int fork(void) {
    800014e2:	7139                	addi	sp,sp,-64
    800014e4:	fc06                	sd	ra,56(sp)
    800014e6:	f822                	sd	s0,48(sp)
    800014e8:	f426                	sd	s1,40(sp)
    800014ea:	f04a                	sd	s2,32(sp)
    800014ec:	ec4e                	sd	s3,24(sp)
    800014ee:	e852                	sd	s4,16(sp)
    800014f0:	e456                	sd	s5,8(sp)
    800014f2:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800014f4:	00000097          	auipc	ra,0x0
    800014f8:	c34080e7          	jalr	-972(ra) # 80001128 <myproc>
    800014fc:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    800014fe:	00000097          	auipc	ra,0x0
    80001502:	e38080e7          	jalr	-456(ra) # 80001336 <allocproc>
    80001506:	10050c63          	beqz	a0,8000161e <fork+0x13c>
    8000150a:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    8000150c:	048ab603          	ld	a2,72(s5)
    80001510:	692c                	ld	a1,80(a0)
    80001512:	050ab503          	ld	a0,80(s5)
    80001516:	fffff097          	auipc	ra,0xfffff
    8000151a:	6a2080e7          	jalr	1698(ra) # 80000bb8 <uvmcopy>
    8000151e:	04054863          	bltz	a0,8000156e <fork+0x8c>
  np->sz = p->sz;
    80001522:	048ab783          	ld	a5,72(s5)
    80001526:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    8000152a:	058ab683          	ld	a3,88(s5)
    8000152e:	87b6                	mv	a5,a3
    80001530:	058a3703          	ld	a4,88(s4)
    80001534:	12068693          	addi	a3,a3,288
    80001538:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000153c:	6788                	ld	a0,8(a5)
    8000153e:	6b8c                	ld	a1,16(a5)
    80001540:	6f90                	ld	a2,24(a5)
    80001542:	01073023          	sd	a6,0(a4)
    80001546:	e708                	sd	a0,8(a4)
    80001548:	eb0c                	sd	a1,16(a4)
    8000154a:	ef10                	sd	a2,24(a4)
    8000154c:	02078793          	addi	a5,a5,32
    80001550:	02070713          	addi	a4,a4,32
    80001554:	fed792e3          	bne	a5,a3,80001538 <fork+0x56>
  np->trapframe->a0 = 0;
    80001558:	058a3783          	ld	a5,88(s4)
    8000155c:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80001560:	0d0a8493          	addi	s1,s5,208
    80001564:	0d0a0913          	addi	s2,s4,208
    80001568:	150a8993          	addi	s3,s5,336
    8000156c:	a00d                	j	8000158e <fork+0xac>
    freeproc(np);
    8000156e:	8552                	mv	a0,s4
    80001570:	00000097          	auipc	ra,0x0
    80001574:	d6e080e7          	jalr	-658(ra) # 800012de <freeproc>
    release(&np->lock);
    80001578:	8552                	mv	a0,s4
    8000157a:	00005097          	auipc	ra,0x5
    8000157e:	f1e080e7          	jalr	-226(ra) # 80006498 <release>
    return -1;
    80001582:	597d                	li	s2,-1
    80001584:	a059                	j	8000160a <fork+0x128>
  for (i = 0; i < NOFILE; i++)
    80001586:	04a1                	addi	s1,s1,8
    80001588:	0921                	addi	s2,s2,8
    8000158a:	01348b63          	beq	s1,s3,800015a0 <fork+0xbe>
    if (p->ofile[i]) np->ofile[i] = filedup(p->ofile[i]);
    8000158e:	6088                	ld	a0,0(s1)
    80001590:	d97d                	beqz	a0,80001586 <fork+0xa4>
    80001592:	00002097          	auipc	ra,0x2
    80001596:	696080e7          	jalr	1686(ra) # 80003c28 <filedup>
    8000159a:	00a93023          	sd	a0,0(s2)
    8000159e:	b7e5                	j	80001586 <fork+0xa4>
  np->cwd = idup(p->cwd);
    800015a0:	150ab503          	ld	a0,336(s5)
    800015a4:	00002097          	auipc	ra,0x2
    800015a8:	804080e7          	jalr	-2044(ra) # 80002da8 <idup>
    800015ac:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800015b0:	4641                	li	a2,16
    800015b2:	158a8593          	addi	a1,s5,344
    800015b6:	158a0513          	addi	a0,s4,344
    800015ba:	fffff097          	auipc	ra,0xfffff
    800015be:	dac080e7          	jalr	-596(ra) # 80000366 <safestrcpy>
  pid = np->pid;
    800015c2:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800015c6:	8552                	mv	a0,s4
    800015c8:	00005097          	auipc	ra,0x5
    800015cc:	ed0080e7          	jalr	-304(ra) # 80006498 <release>
  acquire(&wait_lock);
    800015d0:	00027497          	auipc	s1,0x27
    800015d4:	3e048493          	addi	s1,s1,992 # 800289b0 <wait_lock>
    800015d8:	8526                	mv	a0,s1
    800015da:	00005097          	auipc	ra,0x5
    800015de:	e0a080e7          	jalr	-502(ra) # 800063e4 <acquire>
  np->parent = p;
    800015e2:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800015e6:	8526                	mv	a0,s1
    800015e8:	00005097          	auipc	ra,0x5
    800015ec:	eb0080e7          	jalr	-336(ra) # 80006498 <release>
  acquire(&np->lock);
    800015f0:	8552                	mv	a0,s4
    800015f2:	00005097          	auipc	ra,0x5
    800015f6:	df2080e7          	jalr	-526(ra) # 800063e4 <acquire>
  np->state = RUNNABLE;
    800015fa:	478d                	li	a5,3
    800015fc:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001600:	8552                	mv	a0,s4
    80001602:	00005097          	auipc	ra,0x5
    80001606:	e96080e7          	jalr	-362(ra) # 80006498 <release>
}
    8000160a:	854a                	mv	a0,s2
    8000160c:	70e2                	ld	ra,56(sp)
    8000160e:	7442                	ld	s0,48(sp)
    80001610:	74a2                	ld	s1,40(sp)
    80001612:	7902                	ld	s2,32(sp)
    80001614:	69e2                	ld	s3,24(sp)
    80001616:	6a42                	ld	s4,16(sp)
    80001618:	6aa2                	ld	s5,8(sp)
    8000161a:	6121                	addi	sp,sp,64
    8000161c:	8082                	ret
    return -1;
    8000161e:	597d                	li	s2,-1
    80001620:	b7ed                	j	8000160a <fork+0x128>

0000000080001622 <scheduler>:
void scheduler(void) {
    80001622:	7139                	addi	sp,sp,-64
    80001624:	fc06                	sd	ra,56(sp)
    80001626:	f822                	sd	s0,48(sp)
    80001628:	f426                	sd	s1,40(sp)
    8000162a:	f04a                	sd	s2,32(sp)
    8000162c:	ec4e                	sd	s3,24(sp)
    8000162e:	e852                	sd	s4,16(sp)
    80001630:	e456                	sd	s5,8(sp)
    80001632:	e05a                	sd	s6,0(sp)
    80001634:	0080                	addi	s0,sp,64
    80001636:	8792                	mv	a5,tp
  int id = r_tp();
    80001638:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000163a:	00779a93          	slli	s5,a5,0x7
    8000163e:	00027717          	auipc	a4,0x27
    80001642:	35a70713          	addi	a4,a4,858 # 80028998 <pid_lock>
    80001646:	9756                	add	a4,a4,s5
    80001648:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000164c:	00027717          	auipc	a4,0x27
    80001650:	38470713          	addi	a4,a4,900 # 800289d0 <cpus+0x8>
    80001654:	9aba                	add	s5,s5,a4
      if (p->state == RUNNABLE) {
    80001656:	498d                	li	s3,3
        p->state = RUNNING;
    80001658:	4b11                	li	s6,4
        c->proc = p;
    8000165a:	079e                	slli	a5,a5,0x7
    8000165c:	00027a17          	auipc	s4,0x27
    80001660:	33ca0a13          	addi	s4,s4,828 # 80028998 <pid_lock>
    80001664:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++) {
    80001666:	0002d917          	auipc	s2,0x2d
    8000166a:	16290913          	addi	s2,s2,354 # 8002e7c8 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000166e:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80001672:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001676:	10079073          	csrw	sstatus,a5
    8000167a:	00027497          	auipc	s1,0x27
    8000167e:	74e48493          	addi	s1,s1,1870 # 80028dc8 <proc>
    80001682:	a811                	j	80001696 <scheduler+0x74>
      release(&p->lock);
    80001684:	8526                	mv	a0,s1
    80001686:	00005097          	auipc	ra,0x5
    8000168a:	e12080e7          	jalr	-494(ra) # 80006498 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    8000168e:	16848493          	addi	s1,s1,360
    80001692:	fd248ee3          	beq	s1,s2,8000166e <scheduler+0x4c>
      acquire(&p->lock);
    80001696:	8526                	mv	a0,s1
    80001698:	00005097          	auipc	ra,0x5
    8000169c:	d4c080e7          	jalr	-692(ra) # 800063e4 <acquire>
      if (p->state == RUNNABLE) {
    800016a0:	4c9c                	lw	a5,24(s1)
    800016a2:	ff3791e3          	bne	a5,s3,80001684 <scheduler+0x62>
        p->state = RUNNING;
    800016a6:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800016aa:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800016ae:	06048593          	addi	a1,s1,96
    800016b2:	8556                	mv	a0,s5
    800016b4:	00000097          	auipc	ra,0x0
    800016b8:	684080e7          	jalr	1668(ra) # 80001d38 <swtch>
        c->proc = 0;
    800016bc:	020a3823          	sd	zero,48(s4)
    800016c0:	b7d1                	j	80001684 <scheduler+0x62>

00000000800016c2 <sched>:
void sched(void) {
    800016c2:	7179                	addi	sp,sp,-48
    800016c4:	f406                	sd	ra,40(sp)
    800016c6:	f022                	sd	s0,32(sp)
    800016c8:	ec26                	sd	s1,24(sp)
    800016ca:	e84a                	sd	s2,16(sp)
    800016cc:	e44e                	sd	s3,8(sp)
    800016ce:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800016d0:	00000097          	auipc	ra,0x0
    800016d4:	a58080e7          	jalr	-1448(ra) # 80001128 <myproc>
    800016d8:	84aa                	mv	s1,a0
  if (!holding(&p->lock)) panic("sched p->lock");
    800016da:	00005097          	auipc	ra,0x5
    800016de:	c90080e7          	jalr	-880(ra) # 8000636a <holding>
    800016e2:	c93d                	beqz	a0,80001758 <sched+0x96>
  asm volatile("mv %0, tp" : "=r"(x));
    800016e4:	8792                	mv	a5,tp
  if (mycpu()->noff != 1) panic("sched locks");
    800016e6:	2781                	sext.w	a5,a5
    800016e8:	079e                	slli	a5,a5,0x7
    800016ea:	00027717          	auipc	a4,0x27
    800016ee:	2ae70713          	addi	a4,a4,686 # 80028998 <pid_lock>
    800016f2:	97ba                	add	a5,a5,a4
    800016f4:	0a87a703          	lw	a4,168(a5)
    800016f8:	4785                	li	a5,1
    800016fa:	06f71763          	bne	a4,a5,80001768 <sched+0xa6>
  if (p->state == RUNNING) panic("sched running");
    800016fe:	4c98                	lw	a4,24(s1)
    80001700:	4791                	li	a5,4
    80001702:	06f70b63          	beq	a4,a5,80001778 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001706:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000170a:	8b89                	andi	a5,a5,2
  if (intr_get()) panic("sched interruptible");
    8000170c:	efb5                	bnez	a5,80001788 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r"(x));
    8000170e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001710:	00027917          	auipc	s2,0x27
    80001714:	28890913          	addi	s2,s2,648 # 80028998 <pid_lock>
    80001718:	2781                	sext.w	a5,a5
    8000171a:	079e                	slli	a5,a5,0x7
    8000171c:	97ca                	add	a5,a5,s2
    8000171e:	0ac7a983          	lw	s3,172(a5)
    80001722:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001724:	2781                	sext.w	a5,a5
    80001726:	079e                	slli	a5,a5,0x7
    80001728:	00027597          	auipc	a1,0x27
    8000172c:	2a858593          	addi	a1,a1,680 # 800289d0 <cpus+0x8>
    80001730:	95be                	add	a1,a1,a5
    80001732:	06048513          	addi	a0,s1,96
    80001736:	00000097          	auipc	ra,0x0
    8000173a:	602080e7          	jalr	1538(ra) # 80001d38 <swtch>
    8000173e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001740:	2781                	sext.w	a5,a5
    80001742:	079e                	slli	a5,a5,0x7
    80001744:	993e                	add	s2,s2,a5
    80001746:	0b392623          	sw	s3,172(s2)
}
    8000174a:	70a2                	ld	ra,40(sp)
    8000174c:	7402                	ld	s0,32(sp)
    8000174e:	64e2                	ld	s1,24(sp)
    80001750:	6942                	ld	s2,16(sp)
    80001752:	69a2                	ld	s3,8(sp)
    80001754:	6145                	addi	sp,sp,48
    80001756:	8082                	ret
  if (!holding(&p->lock)) panic("sched p->lock");
    80001758:	00007517          	auipc	a0,0x7
    8000175c:	ac050513          	addi	a0,a0,-1344 # 80008218 <etext+0x218>
    80001760:	00004097          	auipc	ra,0x4
    80001764:	74c080e7          	jalr	1868(ra) # 80005eac <panic>
  if (mycpu()->noff != 1) panic("sched locks");
    80001768:	00007517          	auipc	a0,0x7
    8000176c:	ac050513          	addi	a0,a0,-1344 # 80008228 <etext+0x228>
    80001770:	00004097          	auipc	ra,0x4
    80001774:	73c080e7          	jalr	1852(ra) # 80005eac <panic>
  if (p->state == RUNNING) panic("sched running");
    80001778:	00007517          	auipc	a0,0x7
    8000177c:	ac050513          	addi	a0,a0,-1344 # 80008238 <etext+0x238>
    80001780:	00004097          	auipc	ra,0x4
    80001784:	72c080e7          	jalr	1836(ra) # 80005eac <panic>
  if (intr_get()) panic("sched interruptible");
    80001788:	00007517          	auipc	a0,0x7
    8000178c:	ac050513          	addi	a0,a0,-1344 # 80008248 <etext+0x248>
    80001790:	00004097          	auipc	ra,0x4
    80001794:	71c080e7          	jalr	1820(ra) # 80005eac <panic>

0000000080001798 <yield>:
void yield(void) {
    80001798:	1101                	addi	sp,sp,-32
    8000179a:	ec06                	sd	ra,24(sp)
    8000179c:	e822                	sd	s0,16(sp)
    8000179e:	e426                	sd	s1,8(sp)
    800017a0:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800017a2:	00000097          	auipc	ra,0x0
    800017a6:	986080e7          	jalr	-1658(ra) # 80001128 <myproc>
    800017aa:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800017ac:	00005097          	auipc	ra,0x5
    800017b0:	c38080e7          	jalr	-968(ra) # 800063e4 <acquire>
  p->state = RUNNABLE;
    800017b4:	478d                	li	a5,3
    800017b6:	cc9c                	sw	a5,24(s1)
  sched();
    800017b8:	00000097          	auipc	ra,0x0
    800017bc:	f0a080e7          	jalr	-246(ra) # 800016c2 <sched>
  release(&p->lock);
    800017c0:	8526                	mv	a0,s1
    800017c2:	00005097          	auipc	ra,0x5
    800017c6:	cd6080e7          	jalr	-810(ra) # 80006498 <release>
}
    800017ca:	60e2                	ld	ra,24(sp)
    800017cc:	6442                	ld	s0,16(sp)
    800017ce:	64a2                	ld	s1,8(sp)
    800017d0:	6105                	addi	sp,sp,32
    800017d2:	8082                	ret

00000000800017d4 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk) {
    800017d4:	7179                	addi	sp,sp,-48
    800017d6:	f406                	sd	ra,40(sp)
    800017d8:	f022                	sd	s0,32(sp)
    800017da:	ec26                	sd	s1,24(sp)
    800017dc:	e84a                	sd	s2,16(sp)
    800017de:	e44e                	sd	s3,8(sp)
    800017e0:	1800                	addi	s0,sp,48
    800017e2:	89aa                	mv	s3,a0
    800017e4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800017e6:	00000097          	auipc	ra,0x0
    800017ea:	942080e7          	jalr	-1726(ra) # 80001128 <myproc>
    800017ee:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  // DOC: sleeplock1
    800017f0:	00005097          	auipc	ra,0x5
    800017f4:	bf4080e7          	jalr	-1036(ra) # 800063e4 <acquire>
  release(lk);
    800017f8:	854a                	mv	a0,s2
    800017fa:	00005097          	auipc	ra,0x5
    800017fe:	c9e080e7          	jalr	-866(ra) # 80006498 <release>

  // Go to sleep.
  p->chan = chan;
    80001802:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001806:	4789                	li	a5,2
    80001808:	cc9c                	sw	a5,24(s1)

  sched();
    8000180a:	00000097          	auipc	ra,0x0
    8000180e:	eb8080e7          	jalr	-328(ra) # 800016c2 <sched>

  // Tidy up.
  p->chan = 0;
    80001812:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001816:	8526                	mv	a0,s1
    80001818:	00005097          	auipc	ra,0x5
    8000181c:	c80080e7          	jalr	-896(ra) # 80006498 <release>
  acquire(lk);
    80001820:	854a                	mv	a0,s2
    80001822:	00005097          	auipc	ra,0x5
    80001826:	bc2080e7          	jalr	-1086(ra) # 800063e4 <acquire>
}
    8000182a:	70a2                	ld	ra,40(sp)
    8000182c:	7402                	ld	s0,32(sp)
    8000182e:	64e2                	ld	s1,24(sp)
    80001830:	6942                	ld	s2,16(sp)
    80001832:	69a2                	ld	s3,8(sp)
    80001834:	6145                	addi	sp,sp,48
    80001836:	8082                	ret

0000000080001838 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan) {
    80001838:	7139                	addi	sp,sp,-64
    8000183a:	fc06                	sd	ra,56(sp)
    8000183c:	f822                	sd	s0,48(sp)
    8000183e:	f426                	sd	s1,40(sp)
    80001840:	f04a                	sd	s2,32(sp)
    80001842:	ec4e                	sd	s3,24(sp)
    80001844:	e852                	sd	s4,16(sp)
    80001846:	e456                	sd	s5,8(sp)
    80001848:	0080                	addi	s0,sp,64
    8000184a:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    8000184c:	00027497          	auipc	s1,0x27
    80001850:	57c48493          	addi	s1,s1,1404 # 80028dc8 <proc>
    if (p != myproc()) {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan) {
    80001854:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001856:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    80001858:	0002d917          	auipc	s2,0x2d
    8000185c:	f7090913          	addi	s2,s2,-144 # 8002e7c8 <tickslock>
    80001860:	a811                	j	80001874 <wakeup+0x3c>
      }
      release(&p->lock);
    80001862:	8526                	mv	a0,s1
    80001864:	00005097          	auipc	ra,0x5
    80001868:	c34080e7          	jalr	-972(ra) # 80006498 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000186c:	16848493          	addi	s1,s1,360
    80001870:	03248663          	beq	s1,s2,8000189c <wakeup+0x64>
    if (p != myproc()) {
    80001874:	00000097          	auipc	ra,0x0
    80001878:	8b4080e7          	jalr	-1868(ra) # 80001128 <myproc>
    8000187c:	fea488e3          	beq	s1,a0,8000186c <wakeup+0x34>
      acquire(&p->lock);
    80001880:	8526                	mv	a0,s1
    80001882:	00005097          	auipc	ra,0x5
    80001886:	b62080e7          	jalr	-1182(ra) # 800063e4 <acquire>
      if (p->state == SLEEPING && p->chan == chan) {
    8000188a:	4c9c                	lw	a5,24(s1)
    8000188c:	fd379be3          	bne	a5,s3,80001862 <wakeup+0x2a>
    80001890:	709c                	ld	a5,32(s1)
    80001892:	fd4798e3          	bne	a5,s4,80001862 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001896:	0154ac23          	sw	s5,24(s1)
    8000189a:	b7e1                	j	80001862 <wakeup+0x2a>
    }
  }
}
    8000189c:	70e2                	ld	ra,56(sp)
    8000189e:	7442                	ld	s0,48(sp)
    800018a0:	74a2                	ld	s1,40(sp)
    800018a2:	7902                	ld	s2,32(sp)
    800018a4:	69e2                	ld	s3,24(sp)
    800018a6:	6a42                	ld	s4,16(sp)
    800018a8:	6aa2                	ld	s5,8(sp)
    800018aa:	6121                	addi	sp,sp,64
    800018ac:	8082                	ret

00000000800018ae <reparent>:
void reparent(struct proc *p) {
    800018ae:	7179                	addi	sp,sp,-48
    800018b0:	f406                	sd	ra,40(sp)
    800018b2:	f022                	sd	s0,32(sp)
    800018b4:	ec26                	sd	s1,24(sp)
    800018b6:	e84a                	sd	s2,16(sp)
    800018b8:	e44e                	sd	s3,8(sp)
    800018ba:	e052                	sd	s4,0(sp)
    800018bc:	1800                	addi	s0,sp,48
    800018be:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    800018c0:	00027497          	auipc	s1,0x27
    800018c4:	50848493          	addi	s1,s1,1288 # 80028dc8 <proc>
      pp->parent = initproc;
    800018c8:	00007a17          	auipc	s4,0x7
    800018cc:	078a0a13          	addi	s4,s4,120 # 80008940 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    800018d0:	0002d997          	auipc	s3,0x2d
    800018d4:	ef898993          	addi	s3,s3,-264 # 8002e7c8 <tickslock>
    800018d8:	a029                	j	800018e2 <reparent+0x34>
    800018da:	16848493          	addi	s1,s1,360
    800018de:	01348d63          	beq	s1,s3,800018f8 <reparent+0x4a>
    if (pp->parent == p) {
    800018e2:	7c9c                	ld	a5,56(s1)
    800018e4:	ff279be3          	bne	a5,s2,800018da <reparent+0x2c>
      pp->parent = initproc;
    800018e8:	000a3503          	ld	a0,0(s4)
    800018ec:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800018ee:	00000097          	auipc	ra,0x0
    800018f2:	f4a080e7          	jalr	-182(ra) # 80001838 <wakeup>
    800018f6:	b7d5                	j	800018da <reparent+0x2c>
}
    800018f8:	70a2                	ld	ra,40(sp)
    800018fa:	7402                	ld	s0,32(sp)
    800018fc:	64e2                	ld	s1,24(sp)
    800018fe:	6942                	ld	s2,16(sp)
    80001900:	69a2                	ld	s3,8(sp)
    80001902:	6a02                	ld	s4,0(sp)
    80001904:	6145                	addi	sp,sp,48
    80001906:	8082                	ret

0000000080001908 <exit>:
void exit(int status) {
    80001908:	7179                	addi	sp,sp,-48
    8000190a:	f406                	sd	ra,40(sp)
    8000190c:	f022                	sd	s0,32(sp)
    8000190e:	ec26                	sd	s1,24(sp)
    80001910:	e84a                	sd	s2,16(sp)
    80001912:	e44e                	sd	s3,8(sp)
    80001914:	e052                	sd	s4,0(sp)
    80001916:	1800                	addi	s0,sp,48
    80001918:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000191a:	00000097          	auipc	ra,0x0
    8000191e:	80e080e7          	jalr	-2034(ra) # 80001128 <myproc>
    80001922:	89aa                	mv	s3,a0
  if (p == initproc) panic("init exiting");
    80001924:	00007797          	auipc	a5,0x7
    80001928:	01c7b783          	ld	a5,28(a5) # 80008940 <initproc>
    8000192c:	0d050493          	addi	s1,a0,208
    80001930:	15050913          	addi	s2,a0,336
    80001934:	02a79363          	bne	a5,a0,8000195a <exit+0x52>
    80001938:	00007517          	auipc	a0,0x7
    8000193c:	92850513          	addi	a0,a0,-1752 # 80008260 <etext+0x260>
    80001940:	00004097          	auipc	ra,0x4
    80001944:	56c080e7          	jalr	1388(ra) # 80005eac <panic>
      fileclose(f);
    80001948:	00002097          	auipc	ra,0x2
    8000194c:	332080e7          	jalr	818(ra) # 80003c7a <fileclose>
      p->ofile[fd] = 0;
    80001950:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++) {
    80001954:	04a1                	addi	s1,s1,8
    80001956:	01248563          	beq	s1,s2,80001960 <exit+0x58>
    if (p->ofile[fd]) {
    8000195a:	6088                	ld	a0,0(s1)
    8000195c:	f575                	bnez	a0,80001948 <exit+0x40>
    8000195e:	bfdd                	j	80001954 <exit+0x4c>
  begin_op();
    80001960:	00002097          	auipc	ra,0x2
    80001964:	e52080e7          	jalr	-430(ra) # 800037b2 <begin_op>
  iput(p->cwd);
    80001968:	1509b503          	ld	a0,336(s3)
    8000196c:	00001097          	auipc	ra,0x1
    80001970:	634080e7          	jalr	1588(ra) # 80002fa0 <iput>
  end_op();
    80001974:	00002097          	auipc	ra,0x2
    80001978:	ebc080e7          	jalr	-324(ra) # 80003830 <end_op>
  p->cwd = 0;
    8000197c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001980:	00027497          	auipc	s1,0x27
    80001984:	03048493          	addi	s1,s1,48 # 800289b0 <wait_lock>
    80001988:	8526                	mv	a0,s1
    8000198a:	00005097          	auipc	ra,0x5
    8000198e:	a5a080e7          	jalr	-1446(ra) # 800063e4 <acquire>
  reparent(p);
    80001992:	854e                	mv	a0,s3
    80001994:	00000097          	auipc	ra,0x0
    80001998:	f1a080e7          	jalr	-230(ra) # 800018ae <reparent>
  wakeup(p->parent);
    8000199c:	0389b503          	ld	a0,56(s3)
    800019a0:	00000097          	auipc	ra,0x0
    800019a4:	e98080e7          	jalr	-360(ra) # 80001838 <wakeup>
  acquire(&p->lock);
    800019a8:	854e                	mv	a0,s3
    800019aa:	00005097          	auipc	ra,0x5
    800019ae:	a3a080e7          	jalr	-1478(ra) # 800063e4 <acquire>
  p->xstate = status;
    800019b2:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800019b6:	4795                	li	a5,5
    800019b8:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800019bc:	8526                	mv	a0,s1
    800019be:	00005097          	auipc	ra,0x5
    800019c2:	ada080e7          	jalr	-1318(ra) # 80006498 <release>
  sched();
    800019c6:	00000097          	auipc	ra,0x0
    800019ca:	cfc080e7          	jalr	-772(ra) # 800016c2 <sched>
  panic("zombie exit");
    800019ce:	00007517          	auipc	a0,0x7
    800019d2:	8a250513          	addi	a0,a0,-1886 # 80008270 <etext+0x270>
    800019d6:	00004097          	auipc	ra,0x4
    800019da:	4d6080e7          	jalr	1238(ra) # 80005eac <panic>

00000000800019de <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid) {
    800019de:	7179                	addi	sp,sp,-48
    800019e0:	f406                	sd	ra,40(sp)
    800019e2:	f022                	sd	s0,32(sp)
    800019e4:	ec26                	sd	s1,24(sp)
    800019e6:	e84a                	sd	s2,16(sp)
    800019e8:	e44e                	sd	s3,8(sp)
    800019ea:	1800                	addi	s0,sp,48
    800019ec:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    800019ee:	00027497          	auipc	s1,0x27
    800019f2:	3da48493          	addi	s1,s1,986 # 80028dc8 <proc>
    800019f6:	0002d997          	auipc	s3,0x2d
    800019fa:	dd298993          	addi	s3,s3,-558 # 8002e7c8 <tickslock>
    acquire(&p->lock);
    800019fe:	8526                	mv	a0,s1
    80001a00:	00005097          	auipc	ra,0x5
    80001a04:	9e4080e7          	jalr	-1564(ra) # 800063e4 <acquire>
    if (p->pid == pid) {
    80001a08:	589c                	lw	a5,48(s1)
    80001a0a:	01278d63          	beq	a5,s2,80001a24 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a0e:	8526                	mv	a0,s1
    80001a10:	00005097          	auipc	ra,0x5
    80001a14:	a88080e7          	jalr	-1400(ra) # 80006498 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001a18:	16848493          	addi	s1,s1,360
    80001a1c:	ff3491e3          	bne	s1,s3,800019fe <kill+0x20>
  }
  return -1;
    80001a20:	557d                	li	a0,-1
    80001a22:	a829                	j	80001a3c <kill+0x5e>
      p->killed = 1;
    80001a24:	4785                	li	a5,1
    80001a26:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    80001a28:	4c98                	lw	a4,24(s1)
    80001a2a:	4789                	li	a5,2
    80001a2c:	00f70f63          	beq	a4,a5,80001a4a <kill+0x6c>
      release(&p->lock);
    80001a30:	8526                	mv	a0,s1
    80001a32:	00005097          	auipc	ra,0x5
    80001a36:	a66080e7          	jalr	-1434(ra) # 80006498 <release>
      return 0;
    80001a3a:	4501                	li	a0,0
}
    80001a3c:	70a2                	ld	ra,40(sp)
    80001a3e:	7402                	ld	s0,32(sp)
    80001a40:	64e2                	ld	s1,24(sp)
    80001a42:	6942                	ld	s2,16(sp)
    80001a44:	69a2                	ld	s3,8(sp)
    80001a46:	6145                	addi	sp,sp,48
    80001a48:	8082                	ret
        p->state = RUNNABLE;
    80001a4a:	478d                	li	a5,3
    80001a4c:	cc9c                	sw	a5,24(s1)
    80001a4e:	b7cd                	j	80001a30 <kill+0x52>

0000000080001a50 <setkilled>:

void setkilled(struct proc *p) {
    80001a50:	1101                	addi	sp,sp,-32
    80001a52:	ec06                	sd	ra,24(sp)
    80001a54:	e822                	sd	s0,16(sp)
    80001a56:	e426                	sd	s1,8(sp)
    80001a58:	1000                	addi	s0,sp,32
    80001a5a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001a5c:	00005097          	auipc	ra,0x5
    80001a60:	988080e7          	jalr	-1656(ra) # 800063e4 <acquire>
  p->killed = 1;
    80001a64:	4785                	li	a5,1
    80001a66:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001a68:	8526                	mv	a0,s1
    80001a6a:	00005097          	auipc	ra,0x5
    80001a6e:	a2e080e7          	jalr	-1490(ra) # 80006498 <release>
}
    80001a72:	60e2                	ld	ra,24(sp)
    80001a74:	6442                	ld	s0,16(sp)
    80001a76:	64a2                	ld	s1,8(sp)
    80001a78:	6105                	addi	sp,sp,32
    80001a7a:	8082                	ret

0000000080001a7c <killed>:

int killed(struct proc *p) {
    80001a7c:	1101                	addi	sp,sp,-32
    80001a7e:	ec06                	sd	ra,24(sp)
    80001a80:	e822                	sd	s0,16(sp)
    80001a82:	e426                	sd	s1,8(sp)
    80001a84:	e04a                	sd	s2,0(sp)
    80001a86:	1000                	addi	s0,sp,32
    80001a88:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    80001a8a:	00005097          	auipc	ra,0x5
    80001a8e:	95a080e7          	jalr	-1702(ra) # 800063e4 <acquire>
  k = p->killed;
    80001a92:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001a96:	8526                	mv	a0,s1
    80001a98:	00005097          	auipc	ra,0x5
    80001a9c:	a00080e7          	jalr	-1536(ra) # 80006498 <release>
  return k;
}
    80001aa0:	854a                	mv	a0,s2
    80001aa2:	60e2                	ld	ra,24(sp)
    80001aa4:	6442                	ld	s0,16(sp)
    80001aa6:	64a2                	ld	s1,8(sp)
    80001aa8:	6902                	ld	s2,0(sp)
    80001aaa:	6105                	addi	sp,sp,32
    80001aac:	8082                	ret

0000000080001aae <wait>:
int wait(uint64 addr) {
    80001aae:	715d                	addi	sp,sp,-80
    80001ab0:	e486                	sd	ra,72(sp)
    80001ab2:	e0a2                	sd	s0,64(sp)
    80001ab4:	fc26                	sd	s1,56(sp)
    80001ab6:	f84a                	sd	s2,48(sp)
    80001ab8:	f44e                	sd	s3,40(sp)
    80001aba:	f052                	sd	s4,32(sp)
    80001abc:	ec56                	sd	s5,24(sp)
    80001abe:	e85a                	sd	s6,16(sp)
    80001ac0:	e45e                	sd	s7,8(sp)
    80001ac2:	e062                	sd	s8,0(sp)
    80001ac4:	0880                	addi	s0,sp,80
    80001ac6:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001ac8:	fffff097          	auipc	ra,0xfffff
    80001acc:	660080e7          	jalr	1632(ra) # 80001128 <myproc>
    80001ad0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001ad2:	00027517          	auipc	a0,0x27
    80001ad6:	ede50513          	addi	a0,a0,-290 # 800289b0 <wait_lock>
    80001ada:	00005097          	auipc	ra,0x5
    80001ade:	90a080e7          	jalr	-1782(ra) # 800063e4 <acquire>
    havekids = 0;
    80001ae2:	4b81                	li	s7,0
        if (pp->state == ZOMBIE) {
    80001ae4:	4a15                	li	s4,5
        havekids = 1;
    80001ae6:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001ae8:	0002d997          	auipc	s3,0x2d
    80001aec:	ce098993          	addi	s3,s3,-800 # 8002e7c8 <tickslock>
    sleep(p, &wait_lock);  // DOC: wait-sleep
    80001af0:	00027c17          	auipc	s8,0x27
    80001af4:	ec0c0c13          	addi	s8,s8,-320 # 800289b0 <wait_lock>
    havekids = 0;
    80001af8:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001afa:	00027497          	auipc	s1,0x27
    80001afe:	2ce48493          	addi	s1,s1,718 # 80028dc8 <proc>
    80001b02:	a0bd                	j	80001b70 <wait+0xc2>
          pid = pp->pid;
    80001b04:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001b08:	000b0e63          	beqz	s6,80001b24 <wait+0x76>
    80001b0c:	4691                	li	a3,4
    80001b0e:	02c48613          	addi	a2,s1,44
    80001b12:	85da                	mv	a1,s6
    80001b14:	05093503          	ld	a0,80(s2)
    80001b18:	fffff097          	auipc	ra,0xfffff
    80001b1c:	3de080e7          	jalr	990(ra) # 80000ef6 <copyout>
    80001b20:	02054563          	bltz	a0,80001b4a <wait+0x9c>
          freeproc(pp);
    80001b24:	8526                	mv	a0,s1
    80001b26:	fffff097          	auipc	ra,0xfffff
    80001b2a:	7b8080e7          	jalr	1976(ra) # 800012de <freeproc>
          release(&pp->lock);
    80001b2e:	8526                	mv	a0,s1
    80001b30:	00005097          	auipc	ra,0x5
    80001b34:	968080e7          	jalr	-1688(ra) # 80006498 <release>
          release(&wait_lock);
    80001b38:	00027517          	auipc	a0,0x27
    80001b3c:	e7850513          	addi	a0,a0,-392 # 800289b0 <wait_lock>
    80001b40:	00005097          	auipc	ra,0x5
    80001b44:	958080e7          	jalr	-1704(ra) # 80006498 <release>
          return pid;
    80001b48:	a0b5                	j	80001bb4 <wait+0x106>
            release(&pp->lock);
    80001b4a:	8526                	mv	a0,s1
    80001b4c:	00005097          	auipc	ra,0x5
    80001b50:	94c080e7          	jalr	-1716(ra) # 80006498 <release>
            release(&wait_lock);
    80001b54:	00027517          	auipc	a0,0x27
    80001b58:	e5c50513          	addi	a0,a0,-420 # 800289b0 <wait_lock>
    80001b5c:	00005097          	auipc	ra,0x5
    80001b60:	93c080e7          	jalr	-1732(ra) # 80006498 <release>
            return -1;
    80001b64:	59fd                	li	s3,-1
    80001b66:	a0b9                	j	80001bb4 <wait+0x106>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001b68:	16848493          	addi	s1,s1,360
    80001b6c:	03348463          	beq	s1,s3,80001b94 <wait+0xe6>
      if (pp->parent == p) {
    80001b70:	7c9c                	ld	a5,56(s1)
    80001b72:	ff279be3          	bne	a5,s2,80001b68 <wait+0xba>
        acquire(&pp->lock);
    80001b76:	8526                	mv	a0,s1
    80001b78:	00005097          	auipc	ra,0x5
    80001b7c:	86c080e7          	jalr	-1940(ra) # 800063e4 <acquire>
        if (pp->state == ZOMBIE) {
    80001b80:	4c9c                	lw	a5,24(s1)
    80001b82:	f94781e3          	beq	a5,s4,80001b04 <wait+0x56>
        release(&pp->lock);
    80001b86:	8526                	mv	a0,s1
    80001b88:	00005097          	auipc	ra,0x5
    80001b8c:	910080e7          	jalr	-1776(ra) # 80006498 <release>
        havekids = 1;
    80001b90:	8756                	mv	a4,s5
    80001b92:	bfd9                	j	80001b68 <wait+0xba>
    if (!havekids || killed(p)) {
    80001b94:	c719                	beqz	a4,80001ba2 <wait+0xf4>
    80001b96:	854a                	mv	a0,s2
    80001b98:	00000097          	auipc	ra,0x0
    80001b9c:	ee4080e7          	jalr	-284(ra) # 80001a7c <killed>
    80001ba0:	c51d                	beqz	a0,80001bce <wait+0x120>
      release(&wait_lock);
    80001ba2:	00027517          	auipc	a0,0x27
    80001ba6:	e0e50513          	addi	a0,a0,-498 # 800289b0 <wait_lock>
    80001baa:	00005097          	auipc	ra,0x5
    80001bae:	8ee080e7          	jalr	-1810(ra) # 80006498 <release>
      return -1;
    80001bb2:	59fd                	li	s3,-1
}
    80001bb4:	854e                	mv	a0,s3
    80001bb6:	60a6                	ld	ra,72(sp)
    80001bb8:	6406                	ld	s0,64(sp)
    80001bba:	74e2                	ld	s1,56(sp)
    80001bbc:	7942                	ld	s2,48(sp)
    80001bbe:	79a2                	ld	s3,40(sp)
    80001bc0:	7a02                	ld	s4,32(sp)
    80001bc2:	6ae2                	ld	s5,24(sp)
    80001bc4:	6b42                	ld	s6,16(sp)
    80001bc6:	6ba2                	ld	s7,8(sp)
    80001bc8:	6c02                	ld	s8,0(sp)
    80001bca:	6161                	addi	sp,sp,80
    80001bcc:	8082                	ret
    sleep(p, &wait_lock);  // DOC: wait-sleep
    80001bce:	85e2                	mv	a1,s8
    80001bd0:	854a                	mv	a0,s2
    80001bd2:	00000097          	auipc	ra,0x0
    80001bd6:	c02080e7          	jalr	-1022(ra) # 800017d4 <sleep>
    havekids = 0;
    80001bda:	bf39                	j	80001af8 <wait+0x4a>

0000000080001bdc <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len) {
    80001bdc:	7179                	addi	sp,sp,-48
    80001bde:	f406                	sd	ra,40(sp)
    80001be0:	f022                	sd	s0,32(sp)
    80001be2:	ec26                	sd	s1,24(sp)
    80001be4:	e84a                	sd	s2,16(sp)
    80001be6:	e44e                	sd	s3,8(sp)
    80001be8:	e052                	sd	s4,0(sp)
    80001bea:	1800                	addi	s0,sp,48
    80001bec:	84aa                	mv	s1,a0
    80001bee:	892e                	mv	s2,a1
    80001bf0:	89b2                	mv	s3,a2
    80001bf2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001bf4:	fffff097          	auipc	ra,0xfffff
    80001bf8:	534080e7          	jalr	1332(ra) # 80001128 <myproc>
  if (user_dst) {
    80001bfc:	c08d                	beqz	s1,80001c1e <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001bfe:	86d2                	mv	a3,s4
    80001c00:	864e                	mv	a2,s3
    80001c02:	85ca                	mv	a1,s2
    80001c04:	6928                	ld	a0,80(a0)
    80001c06:	fffff097          	auipc	ra,0xfffff
    80001c0a:	2f0080e7          	jalr	752(ra) # 80000ef6 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001c0e:	70a2                	ld	ra,40(sp)
    80001c10:	7402                	ld	s0,32(sp)
    80001c12:	64e2                	ld	s1,24(sp)
    80001c14:	6942                	ld	s2,16(sp)
    80001c16:	69a2                	ld	s3,8(sp)
    80001c18:	6a02                	ld	s4,0(sp)
    80001c1a:	6145                	addi	sp,sp,48
    80001c1c:	8082                	ret
    memmove((char *)dst, src, len);
    80001c1e:	000a061b          	sext.w	a2,s4
    80001c22:	85ce                	mv	a1,s3
    80001c24:	854a                	mv	a0,s2
    80001c26:	ffffe097          	auipc	ra,0xffffe
    80001c2a:	652080e7          	jalr	1618(ra) # 80000278 <memmove>
    return 0;
    80001c2e:	8526                	mv	a0,s1
    80001c30:	bff9                	j	80001c0e <either_copyout+0x32>

0000000080001c32 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len) {
    80001c32:	7179                	addi	sp,sp,-48
    80001c34:	f406                	sd	ra,40(sp)
    80001c36:	f022                	sd	s0,32(sp)
    80001c38:	ec26                	sd	s1,24(sp)
    80001c3a:	e84a                	sd	s2,16(sp)
    80001c3c:	e44e                	sd	s3,8(sp)
    80001c3e:	e052                	sd	s4,0(sp)
    80001c40:	1800                	addi	s0,sp,48
    80001c42:	892a                	mv	s2,a0
    80001c44:	84ae                	mv	s1,a1
    80001c46:	89b2                	mv	s3,a2
    80001c48:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001c4a:	fffff097          	auipc	ra,0xfffff
    80001c4e:	4de080e7          	jalr	1246(ra) # 80001128 <myproc>
  if (user_src) {
    80001c52:	c08d                	beqz	s1,80001c74 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001c54:	86d2                	mv	a3,s4
    80001c56:	864e                	mv	a2,s3
    80001c58:	85ca                	mv	a1,s2
    80001c5a:	6928                	ld	a0,80(a0)
    80001c5c:	fffff097          	auipc	ra,0xfffff
    80001c60:	064080e7          	jalr	100(ra) # 80000cc0 <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80001c64:	70a2                	ld	ra,40(sp)
    80001c66:	7402                	ld	s0,32(sp)
    80001c68:	64e2                	ld	s1,24(sp)
    80001c6a:	6942                	ld	s2,16(sp)
    80001c6c:	69a2                	ld	s3,8(sp)
    80001c6e:	6a02                	ld	s4,0(sp)
    80001c70:	6145                	addi	sp,sp,48
    80001c72:	8082                	ret
    memmove(dst, (char *)src, len);
    80001c74:	000a061b          	sext.w	a2,s4
    80001c78:	85ce                	mv	a1,s3
    80001c7a:	854a                	mv	a0,s2
    80001c7c:	ffffe097          	auipc	ra,0xffffe
    80001c80:	5fc080e7          	jalr	1532(ra) # 80000278 <memmove>
    return 0;
    80001c84:	8526                	mv	a0,s1
    80001c86:	bff9                	j	80001c64 <either_copyin+0x32>

0000000080001c88 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
    80001c88:	715d                	addi	sp,sp,-80
    80001c8a:	e486                	sd	ra,72(sp)
    80001c8c:	e0a2                	sd	s0,64(sp)
    80001c8e:	fc26                	sd	s1,56(sp)
    80001c90:	f84a                	sd	s2,48(sp)
    80001c92:	f44e                	sd	s3,40(sp)
    80001c94:	f052                	sd	s4,32(sp)
    80001c96:	ec56                	sd	s5,24(sp)
    80001c98:	e85a                	sd	s6,16(sp)
    80001c9a:	e45e                	sd	s7,8(sp)
    80001c9c:	0880                	addi	s0,sp,80
      [UNUSED] = "unused",   [USED] = "used",      [SLEEPING] = "sleep ",
      [RUNNABLE] = "runble", [RUNNING] = "run   ", [ZOMBIE] = "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    80001c9e:	00006517          	auipc	a0,0x6
    80001ca2:	3ba50513          	addi	a0,a0,954 # 80008058 <etext+0x58>
    80001ca6:	00004097          	auipc	ra,0x4
    80001caa:	250080e7          	jalr	592(ra) # 80005ef6 <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001cae:	00027497          	auipc	s1,0x27
    80001cb2:	27248493          	addi	s1,s1,626 # 80028f20 <proc+0x158>
    80001cb6:	0002d917          	auipc	s2,0x2d
    80001cba:	c6a90913          	addi	s2,s2,-918 # 8002e920 <bcache+0x140>
    if (p->state == UNUSED) continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001cbe:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001cc0:	00006997          	auipc	s3,0x6
    80001cc4:	5c098993          	addi	s3,s3,1472 # 80008280 <etext+0x280>
    printf("%d %s %s", p->pid, state, p->name);
    80001cc8:	00006a97          	auipc	s5,0x6
    80001ccc:	5c0a8a93          	addi	s5,s5,1472 # 80008288 <etext+0x288>
    printf("\n");
    80001cd0:	00006a17          	auipc	s4,0x6
    80001cd4:	388a0a13          	addi	s4,s4,904 # 80008058 <etext+0x58>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001cd8:	00006b97          	auipc	s7,0x6
    80001cdc:	5f0b8b93          	addi	s7,s7,1520 # 800082c8 <states.0>
    80001ce0:	a00d                	j	80001d02 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001ce2:	ed86a583          	lw	a1,-296(a3)
    80001ce6:	8556                	mv	a0,s5
    80001ce8:	00004097          	auipc	ra,0x4
    80001cec:	20e080e7          	jalr	526(ra) # 80005ef6 <printf>
    printf("\n");
    80001cf0:	8552                	mv	a0,s4
    80001cf2:	00004097          	auipc	ra,0x4
    80001cf6:	204080e7          	jalr	516(ra) # 80005ef6 <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001cfa:	16848493          	addi	s1,s1,360
    80001cfe:	03248263          	beq	s1,s2,80001d22 <procdump+0x9a>
    if (p->state == UNUSED) continue;
    80001d02:	86a6                	mv	a3,s1
    80001d04:	ec04a783          	lw	a5,-320(s1)
    80001d08:	dbed                	beqz	a5,80001cfa <procdump+0x72>
      state = "???";
    80001d0a:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001d0c:	fcfb6be3          	bltu	s6,a5,80001ce2 <procdump+0x5a>
    80001d10:	02079713          	slli	a4,a5,0x20
    80001d14:	01d75793          	srli	a5,a4,0x1d
    80001d18:	97de                	add	a5,a5,s7
    80001d1a:	6390                	ld	a2,0(a5)
    80001d1c:	f279                	bnez	a2,80001ce2 <procdump+0x5a>
      state = "???";
    80001d1e:	864e                	mv	a2,s3
    80001d20:	b7c9                	j	80001ce2 <procdump+0x5a>
  }
}
    80001d22:	60a6                	ld	ra,72(sp)
    80001d24:	6406                	ld	s0,64(sp)
    80001d26:	74e2                	ld	s1,56(sp)
    80001d28:	7942                	ld	s2,48(sp)
    80001d2a:	79a2                	ld	s3,40(sp)
    80001d2c:	7a02                	ld	s4,32(sp)
    80001d2e:	6ae2                	ld	s5,24(sp)
    80001d30:	6b42                	ld	s6,16(sp)
    80001d32:	6ba2                	ld	s7,8(sp)
    80001d34:	6161                	addi	sp,sp,80
    80001d36:	8082                	ret

0000000080001d38 <swtch>:
    80001d38:	00153023          	sd	ra,0(a0)
    80001d3c:	00253423          	sd	sp,8(a0)
    80001d40:	e900                	sd	s0,16(a0)
    80001d42:	ed04                	sd	s1,24(a0)
    80001d44:	03253023          	sd	s2,32(a0)
    80001d48:	03353423          	sd	s3,40(a0)
    80001d4c:	03453823          	sd	s4,48(a0)
    80001d50:	03553c23          	sd	s5,56(a0)
    80001d54:	05653023          	sd	s6,64(a0)
    80001d58:	05753423          	sd	s7,72(a0)
    80001d5c:	05853823          	sd	s8,80(a0)
    80001d60:	05953c23          	sd	s9,88(a0)
    80001d64:	07a53023          	sd	s10,96(a0)
    80001d68:	07b53423          	sd	s11,104(a0)
    80001d6c:	0005b083          	ld	ra,0(a1)
    80001d70:	0085b103          	ld	sp,8(a1)
    80001d74:	6980                	ld	s0,16(a1)
    80001d76:	6d84                	ld	s1,24(a1)
    80001d78:	0205b903          	ld	s2,32(a1)
    80001d7c:	0285b983          	ld	s3,40(a1)
    80001d80:	0305ba03          	ld	s4,48(a1)
    80001d84:	0385ba83          	ld	s5,56(a1)
    80001d88:	0405bb03          	ld	s6,64(a1)
    80001d8c:	0485bb83          	ld	s7,72(a1)
    80001d90:	0505bc03          	ld	s8,80(a1)
    80001d94:	0585bc83          	ld	s9,88(a1)
    80001d98:	0605bd03          	ld	s10,96(a1)
    80001d9c:	0685bd83          	ld	s11,104(a1)
    80001da0:	8082                	ret

0000000080001da2 <trapinit>:
// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();

void trapinit(void) { initlock(&tickslock, "time"); }
    80001da2:	1141                	addi	sp,sp,-16
    80001da4:	e406                	sd	ra,8(sp)
    80001da6:	e022                	sd	s0,0(sp)
    80001da8:	0800                	addi	s0,sp,16
    80001daa:	00006597          	auipc	a1,0x6
    80001dae:	54e58593          	addi	a1,a1,1358 # 800082f8 <states.0+0x30>
    80001db2:	0002d517          	auipc	a0,0x2d
    80001db6:	a1650513          	addi	a0,a0,-1514 # 8002e7c8 <tickslock>
    80001dba:	00004097          	auipc	ra,0x4
    80001dbe:	59a080e7          	jalr	1434(ra) # 80006354 <initlock>
    80001dc2:	60a2                	ld	ra,8(sp)
    80001dc4:	6402                	ld	s0,0(sp)
    80001dc6:	0141                	addi	sp,sp,16
    80001dc8:	8082                	ret

0000000080001dca <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void) { w_stvec((uint64)kernelvec); }
    80001dca:	1141                	addi	sp,sp,-16
    80001dcc:	e422                	sd	s0,8(sp)
    80001dce:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001dd0:	00003797          	auipc	a5,0x3
    80001dd4:	51078793          	addi	a5,a5,1296 # 800052e0 <kernelvec>
    80001dd8:	10579073          	csrw	stvec,a5
    80001ddc:	6422                	ld	s0,8(sp)
    80001dde:	0141                	addi	sp,sp,16
    80001de0:	8082                	ret

0000000080001de2 <usertrapret>:
}

//
// return to user space
//
void usertrapret(void) {
    80001de2:	1141                	addi	sp,sp,-16
    80001de4:	e406                	sd	ra,8(sp)
    80001de6:	e022                	sd	s0,0(sp)
    80001de8:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001dea:	fffff097          	auipc	ra,0xfffff
    80001dee:	33e080e7          	jalr	830(ra) # 80001128 <myproc>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001df2:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80001df6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001df8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001dfc:	00005697          	auipc	a3,0x5
    80001e00:	20468693          	addi	a3,a3,516 # 80007000 <_trampoline>
    80001e04:	00005717          	auipc	a4,0x5
    80001e08:	1fc70713          	addi	a4,a4,508 # 80007000 <_trampoline>
    80001e0c:	8f15                	sub	a4,a4,a3
    80001e0e:	040007b7          	lui	a5,0x4000
    80001e12:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001e14:	07b2                	slli	a5,a5,0xc
    80001e16:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001e18:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();          // kernel page table
    80001e1c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80001e1e:	18002673          	csrr	a2,satp
    80001e22:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE;  // process's kernel stack
    80001e24:	6d30                	ld	a2,88(a0)
    80001e26:	6138                	ld	a4,64(a0)
    80001e28:	6585                	lui	a1,0x1
    80001e2a:	972e                	add	a4,a4,a1
    80001e2c:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001e2e:	6d38                	ld	a4,88(a0)
    80001e30:	00000617          	auipc	a2,0x0
    80001e34:	13060613          	addi	a2,a2,304 # 80001f60 <usertrap>
    80001e38:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();  // hartid for cpuid()
    80001e3a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80001e3c:	8612                	mv	a2,tp
    80001e3e:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e40:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP;  // clear SPP to 0 for user mode
    80001e44:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE;  // enable interrupts in user mode
    80001e48:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001e4c:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001e50:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001e52:	6f18                	ld	a4,24(a4)
    80001e54:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001e58:	6928                	ld	a0,80(a0)
    80001e5a:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001e5c:	00005717          	auipc	a4,0x5
    80001e60:	24070713          	addi	a4,a4,576 # 8000709c <userret>
    80001e64:	8f15                	sub	a4,a4,a3
    80001e66:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001e68:	577d                	li	a4,-1
    80001e6a:	177e                	slli	a4,a4,0x3f
    80001e6c:	8d59                	or	a0,a0,a4
    80001e6e:	9782                	jalr	a5
}
    80001e70:	60a2                	ld	ra,8(sp)
    80001e72:	6402                	ld	s0,0(sp)
    80001e74:	0141                	addi	sp,sp,16
    80001e76:	8082                	ret

0000000080001e78 <clockintr>:
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr() {
    80001e78:	1101                	addi	sp,sp,-32
    80001e7a:	ec06                	sd	ra,24(sp)
    80001e7c:	e822                	sd	s0,16(sp)
    80001e7e:	e426                	sd	s1,8(sp)
    80001e80:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001e82:	0002d497          	auipc	s1,0x2d
    80001e86:	94648493          	addi	s1,s1,-1722 # 8002e7c8 <tickslock>
    80001e8a:	8526                	mv	a0,s1
    80001e8c:	00004097          	auipc	ra,0x4
    80001e90:	558080e7          	jalr	1368(ra) # 800063e4 <acquire>
  ticks++;
    80001e94:	00007517          	auipc	a0,0x7
    80001e98:	ab450513          	addi	a0,a0,-1356 # 80008948 <ticks>
    80001e9c:	411c                	lw	a5,0(a0)
    80001e9e:	2785                	addiw	a5,a5,1
    80001ea0:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001ea2:	00000097          	auipc	ra,0x0
    80001ea6:	996080e7          	jalr	-1642(ra) # 80001838 <wakeup>
  release(&tickslock);
    80001eaa:	8526                	mv	a0,s1
    80001eac:	00004097          	auipc	ra,0x4
    80001eb0:	5ec080e7          	jalr	1516(ra) # 80006498 <release>
}
    80001eb4:	60e2                	ld	ra,24(sp)
    80001eb6:	6442                	ld	s0,16(sp)
    80001eb8:	64a2                	ld	s1,8(sp)
    80001eba:	6105                	addi	sp,sp,32
    80001ebc:	8082                	ret

0000000080001ebe <devintr>:
// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr() {
    80001ebe:	1101                	addi	sp,sp,-32
    80001ec0:	ec06                	sd	ra,24(sp)
    80001ec2:	e822                	sd	s0,16(sp)
    80001ec4:	e426                	sd	s1,8(sp)
    80001ec6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80001ec8:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001ecc:	00074d63          	bltz	a4,80001ee6 <devintr+0x28>
    // interrupt at a time; tell the PLIC the device is
    // now allowed to interrupt again.
    if (irq) plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000001L) {
    80001ed0:	57fd                	li	a5,-1
    80001ed2:	17fe                	slli	a5,a5,0x3f
    80001ed4:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001ed6:	4501                	li	a0,0
  } else if (scause == 0x8000000000000001L) {
    80001ed8:	06f70363          	beq	a4,a5,80001f3e <devintr+0x80>
  }
}
    80001edc:	60e2                	ld	ra,24(sp)
    80001ede:	6442                	ld	s0,16(sp)
    80001ee0:	64a2                	ld	s1,8(sp)
    80001ee2:	6105                	addi	sp,sp,32
    80001ee4:	8082                	ret
  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001ee6:	0ff77793          	zext.b	a5,a4
    80001eea:	46a5                	li	a3,9
    80001eec:	fed792e3          	bne	a5,a3,80001ed0 <devintr+0x12>
    int irq = plic_claim();
    80001ef0:	00003097          	auipc	ra,0x3
    80001ef4:	4f8080e7          	jalr	1272(ra) # 800053e8 <plic_claim>
    80001ef8:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80001efa:	47a9                	li	a5,10
    80001efc:	02f50763          	beq	a0,a5,80001f2a <devintr+0x6c>
    } else if (irq == VIRTIO0_IRQ) {
    80001f00:	4785                	li	a5,1
    80001f02:	02f50963          	beq	a0,a5,80001f34 <devintr+0x76>
    return 1;
    80001f06:	4505                	li	a0,1
    } else if (irq) {
    80001f08:	d8f1                	beqz	s1,80001edc <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001f0a:	85a6                	mv	a1,s1
    80001f0c:	00006517          	auipc	a0,0x6
    80001f10:	3f450513          	addi	a0,a0,1012 # 80008300 <states.0+0x38>
    80001f14:	00004097          	auipc	ra,0x4
    80001f18:	fe2080e7          	jalr	-30(ra) # 80005ef6 <printf>
    if (irq) plic_complete(irq);
    80001f1c:	8526                	mv	a0,s1
    80001f1e:	00003097          	auipc	ra,0x3
    80001f22:	4ee080e7          	jalr	1262(ra) # 8000540c <plic_complete>
    return 1;
    80001f26:	4505                	li	a0,1
    80001f28:	bf55                	j	80001edc <devintr+0x1e>
      uartintr();
    80001f2a:	00004097          	auipc	ra,0x4
    80001f2e:	3da080e7          	jalr	986(ra) # 80006304 <uartintr>
    80001f32:	b7ed                	j	80001f1c <devintr+0x5e>
      virtio_disk_intr();
    80001f34:	00004097          	auipc	ra,0x4
    80001f38:	9a0080e7          	jalr	-1632(ra) # 800058d4 <virtio_disk_intr>
    80001f3c:	b7c5                	j	80001f1c <devintr+0x5e>
    if (cpuid() == 0) {
    80001f3e:	fffff097          	auipc	ra,0xfffff
    80001f42:	1be080e7          	jalr	446(ra) # 800010fc <cpuid>
    80001f46:	c901                	beqz	a0,80001f56 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r"(x));
    80001f48:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001f4c:	9bf5                	andi	a5,a5,-3
static inline void w_sip(uint64 x) { asm volatile("csrw sip, %0" : : "r"(x)); }
    80001f4e:	14479073          	csrw	sip,a5
    return 2;
    80001f52:	4509                	li	a0,2
    80001f54:	b761                	j	80001edc <devintr+0x1e>
      clockintr();
    80001f56:	00000097          	auipc	ra,0x0
    80001f5a:	f22080e7          	jalr	-222(ra) # 80001e78 <clockintr>
    80001f5e:	b7ed                	j	80001f48 <devintr+0x8a>

0000000080001f60 <usertrap>:
void usertrap(void) {
    80001f60:	1101                	addi	sp,sp,-32
    80001f62:	ec06                	sd	ra,24(sp)
    80001f64:	e822                	sd	s0,16(sp)
    80001f66:	e426                	sd	s1,8(sp)
    80001f68:	e04a                	sd	s2,0(sp)
    80001f6a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001f6c:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    80001f70:	1007f793          	andi	a5,a5,256
    80001f74:	e7b9                	bnez	a5,80001fc2 <usertrap+0x62>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001f76:	00003797          	auipc	a5,0x3
    80001f7a:	36a78793          	addi	a5,a5,874 # 800052e0 <kernelvec>
    80001f7e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001f82:	fffff097          	auipc	ra,0xfffff
    80001f86:	1a6080e7          	jalr	422(ra) # 80001128 <myproc>
    80001f8a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001f8c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001f8e:	14102773          	csrr	a4,sepc
    80001f92:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80001f94:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80001f98:	47a1                	li	a5,8
    80001f9a:	02f70c63          	beq	a4,a5,80001fd2 <usertrap+0x72>
    80001f9e:	14202773          	csrr	a4,scause
  } else if (r_scause() == 15) {
    80001fa2:	47bd                	li	a5,15
    80001fa4:	06f70163          	beq	a4,a5,80002006 <usertrap+0xa6>
  } else if ((which_dev = devintr()) != 0) {
    80001fa8:	00000097          	auipc	ra,0x0
    80001fac:	f16080e7          	jalr	-234(ra) # 80001ebe <devintr>
    80001fb0:	892a                	mv	s2,a0
    80001fb2:	c951                	beqz	a0,80002046 <usertrap+0xe6>
  if (killed(p)) exit(-1);
    80001fb4:	8526                	mv	a0,s1
    80001fb6:	00000097          	auipc	ra,0x0
    80001fba:	ac6080e7          	jalr	-1338(ra) # 80001a7c <killed>
    80001fbe:	c579                	beqz	a0,8000208c <usertrap+0x12c>
    80001fc0:	a0c9                	j	80002082 <usertrap+0x122>
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    80001fc2:	00006517          	auipc	a0,0x6
    80001fc6:	35e50513          	addi	a0,a0,862 # 80008320 <states.0+0x58>
    80001fca:	00004097          	auipc	ra,0x4
    80001fce:	ee2080e7          	jalr	-286(ra) # 80005eac <panic>
    if (killed(p)) exit(-1);
    80001fd2:	00000097          	auipc	ra,0x0
    80001fd6:	aaa080e7          	jalr	-1366(ra) # 80001a7c <killed>
    80001fda:	e105                	bnez	a0,80001ffa <usertrap+0x9a>
    p->trapframe->epc += 4;
    80001fdc:	6cb8                	ld	a4,88(s1)
    80001fde:	6f1c                	ld	a5,24(a4)
    80001fe0:	0791                	addi	a5,a5,4
    80001fe2:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001fe4:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80001fe8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001fec:	10079073          	csrw	sstatus,a5
    syscall();
    80001ff0:	00000097          	auipc	ra,0x0
    80001ff4:	2f6080e7          	jalr	758(ra) # 800022e6 <syscall>
    80001ff8:	a00d                	j	8000201a <usertrap+0xba>
    if (killed(p)) exit(-1);
    80001ffa:	557d                	li	a0,-1
    80001ffc:	00000097          	auipc	ra,0x0
    80002000:	90c080e7          	jalr	-1780(ra) # 80001908 <exit>
    80002004:	bfe1                	j	80001fdc <usertrap+0x7c>
  asm volatile("csrr %0, stval" : "=r"(x));
    80002006:	143025f3          	csrr	a1,stval
    if (unsharepage(p->pagetable, r_stval()) == -1) {
    8000200a:	6928                	ld	a0,80(a0)
    8000200c:	fffff097          	auipc	ra,0xfffff
    80002010:	df2080e7          	jalr	-526(ra) # 80000dfe <unsharepage>
    80002014:	57fd                	li	a5,-1
    80002016:	02f50263          	beq	a0,a5,8000203a <usertrap+0xda>
  if (killed(p)) exit(-1);
    8000201a:	8526                	mv	a0,s1
    8000201c:	00000097          	auipc	ra,0x0
    80002020:	a60080e7          	jalr	-1440(ra) # 80001a7c <killed>
    80002024:	ed31                	bnez	a0,80002080 <usertrap+0x120>
  usertrapret();
    80002026:	00000097          	auipc	ra,0x0
    8000202a:	dbc080e7          	jalr	-580(ra) # 80001de2 <usertrapret>
}
    8000202e:	60e2                	ld	ra,24(sp)
    80002030:	6442                	ld	s0,16(sp)
    80002032:	64a2                	ld	s1,8(sp)
    80002034:	6902                	ld	s2,0(sp)
    80002036:	6105                	addi	sp,sp,32
    80002038:	8082                	ret
      setkilled(p);
    8000203a:	8526                	mv	a0,s1
    8000203c:	00000097          	auipc	ra,0x0
    80002040:	a14080e7          	jalr	-1516(ra) # 80001a50 <setkilled>
    80002044:	bfd9                	j	8000201a <usertrap+0xba>
  asm volatile("csrr %0, scause" : "=r"(x));
    80002046:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000204a:	5890                	lw	a2,48(s1)
    8000204c:	00006517          	auipc	a0,0x6
    80002050:	2f450513          	addi	a0,a0,756 # 80008340 <states.0+0x78>
    80002054:	00004097          	auipc	ra,0x4
    80002058:	ea2080e7          	jalr	-350(ra) # 80005ef6 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    8000205c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80002060:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002064:	00006517          	auipc	a0,0x6
    80002068:	30c50513          	addi	a0,a0,780 # 80008370 <states.0+0xa8>
    8000206c:	00004097          	auipc	ra,0x4
    80002070:	e8a080e7          	jalr	-374(ra) # 80005ef6 <printf>
    setkilled(p);
    80002074:	8526                	mv	a0,s1
    80002076:	00000097          	auipc	ra,0x0
    8000207a:	9da080e7          	jalr	-1574(ra) # 80001a50 <setkilled>
    8000207e:	bf71                	j	8000201a <usertrap+0xba>
  if (killed(p)) exit(-1);
    80002080:	4901                	li	s2,0
    80002082:	557d                	li	a0,-1
    80002084:	00000097          	auipc	ra,0x0
    80002088:	884080e7          	jalr	-1916(ra) # 80001908 <exit>
  if (which_dev == 2) yield();
    8000208c:	4789                	li	a5,2
    8000208e:	f8f91ce3          	bne	s2,a5,80002026 <usertrap+0xc6>
    80002092:	fffff097          	auipc	ra,0xfffff
    80002096:	706080e7          	jalr	1798(ra) # 80001798 <yield>
    8000209a:	b771                	j	80002026 <usertrap+0xc6>

000000008000209c <kerneltrap>:
void kerneltrap() {
    8000209c:	7179                	addi	sp,sp,-48
    8000209e:	f406                	sd	ra,40(sp)
    800020a0:	f022                	sd	s0,32(sp)
    800020a2:	ec26                	sd	s1,24(sp)
    800020a4:	e84a                	sd	s2,16(sp)
    800020a6:	e44e                	sd	s3,8(sp)
    800020a8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    800020aa:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800020ae:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    800020b2:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    800020b6:	1004f793          	andi	a5,s1,256
    800020ba:	cb85                	beqz	a5,800020ea <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800020bc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800020c0:	8b89                	andi	a5,a5,2
  if (intr_get() != 0) panic("kerneltrap: interrupts enabled");
    800020c2:	ef85                	bnez	a5,800020fa <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0) {
    800020c4:	00000097          	auipc	ra,0x0
    800020c8:	dfa080e7          	jalr	-518(ra) # 80001ebe <devintr>
    800020cc:	cd1d                	beqz	a0,8000210a <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) yield();
    800020ce:	4789                	li	a5,2
    800020d0:	06f50a63          	beq	a0,a5,80002144 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r"(x));
    800020d4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800020d8:	10049073          	csrw	sstatus,s1
}
    800020dc:	70a2                	ld	ra,40(sp)
    800020de:	7402                	ld	s0,32(sp)
    800020e0:	64e2                	ld	s1,24(sp)
    800020e2:	6942                	ld	s2,16(sp)
    800020e4:	69a2                	ld	s3,8(sp)
    800020e6:	6145                	addi	sp,sp,48
    800020e8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800020ea:	00006517          	auipc	a0,0x6
    800020ee:	2a650513          	addi	a0,a0,678 # 80008390 <states.0+0xc8>
    800020f2:	00004097          	auipc	ra,0x4
    800020f6:	dba080e7          	jalr	-582(ra) # 80005eac <panic>
  if (intr_get() != 0) panic("kerneltrap: interrupts enabled");
    800020fa:	00006517          	auipc	a0,0x6
    800020fe:	2be50513          	addi	a0,a0,702 # 800083b8 <states.0+0xf0>
    80002102:	00004097          	auipc	ra,0x4
    80002106:	daa080e7          	jalr	-598(ra) # 80005eac <panic>
    printf("scause %p\n", scause);
    8000210a:	85ce                	mv	a1,s3
    8000210c:	00006517          	auipc	a0,0x6
    80002110:	2cc50513          	addi	a0,a0,716 # 800083d8 <states.0+0x110>
    80002114:	00004097          	auipc	ra,0x4
    80002118:	de2080e7          	jalr	-542(ra) # 80005ef6 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    8000211c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80002120:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002124:	00006517          	auipc	a0,0x6
    80002128:	2c450513          	addi	a0,a0,708 # 800083e8 <states.0+0x120>
    8000212c:	00004097          	auipc	ra,0x4
    80002130:	dca080e7          	jalr	-566(ra) # 80005ef6 <printf>
    panic("kerneltrap");
    80002134:	00006517          	auipc	a0,0x6
    80002138:	2cc50513          	addi	a0,a0,716 # 80008400 <states.0+0x138>
    8000213c:	00004097          	auipc	ra,0x4
    80002140:	d70080e7          	jalr	-656(ra) # 80005eac <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) yield();
    80002144:	fffff097          	auipc	ra,0xfffff
    80002148:	fe4080e7          	jalr	-28(ra) # 80001128 <myproc>
    8000214c:	d541                	beqz	a0,800020d4 <kerneltrap+0x38>
    8000214e:	fffff097          	auipc	ra,0xfffff
    80002152:	fda080e7          	jalr	-38(ra) # 80001128 <myproc>
    80002156:	4d18                	lw	a4,24(a0)
    80002158:	4791                	li	a5,4
    8000215a:	f6f71de3          	bne	a4,a5,800020d4 <kerneltrap+0x38>
    8000215e:	fffff097          	auipc	ra,0xfffff
    80002162:	63a080e7          	jalr	1594(ra) # 80001798 <yield>
    80002166:	b7bd                	j	800020d4 <kerneltrap+0x38>

0000000080002168 <argraw>:
  struct proc *p = myproc();
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
  return strlen(buf);
}

static uint64 argraw(int n) {
    80002168:	1101                	addi	sp,sp,-32
    8000216a:	ec06                	sd	ra,24(sp)
    8000216c:	e822                	sd	s0,16(sp)
    8000216e:	e426                	sd	s1,8(sp)
    80002170:	1000                	addi	s0,sp,32
    80002172:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002174:	fffff097          	auipc	ra,0xfffff
    80002178:	fb4080e7          	jalr	-76(ra) # 80001128 <myproc>
  switch (n) {
    8000217c:	4795                	li	a5,5
    8000217e:	0497e163          	bltu	a5,s1,800021c0 <argraw+0x58>
    80002182:	048a                	slli	s1,s1,0x2
    80002184:	00006717          	auipc	a4,0x6
    80002188:	2b470713          	addi	a4,a4,692 # 80008438 <states.0+0x170>
    8000218c:	94ba                	add	s1,s1,a4
    8000218e:	409c                	lw	a5,0(s1)
    80002190:	97ba                	add	a5,a5,a4
    80002192:	8782                	jr	a5
    case 0:
      return p->trapframe->a0;
    80002194:	6d3c                	ld	a5,88(a0)
    80002196:	7ba8                	ld	a0,112(a5)
    case 5:
      return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002198:	60e2                	ld	ra,24(sp)
    8000219a:	6442                	ld	s0,16(sp)
    8000219c:	64a2                	ld	s1,8(sp)
    8000219e:	6105                	addi	sp,sp,32
    800021a0:	8082                	ret
      return p->trapframe->a1;
    800021a2:	6d3c                	ld	a5,88(a0)
    800021a4:	7fa8                	ld	a0,120(a5)
    800021a6:	bfcd                	j	80002198 <argraw+0x30>
      return p->trapframe->a2;
    800021a8:	6d3c                	ld	a5,88(a0)
    800021aa:	63c8                	ld	a0,128(a5)
    800021ac:	b7f5                	j	80002198 <argraw+0x30>
      return p->trapframe->a3;
    800021ae:	6d3c                	ld	a5,88(a0)
    800021b0:	67c8                	ld	a0,136(a5)
    800021b2:	b7dd                	j	80002198 <argraw+0x30>
      return p->trapframe->a4;
    800021b4:	6d3c                	ld	a5,88(a0)
    800021b6:	6bc8                	ld	a0,144(a5)
    800021b8:	b7c5                	j	80002198 <argraw+0x30>
      return p->trapframe->a5;
    800021ba:	6d3c                	ld	a5,88(a0)
    800021bc:	6fc8                	ld	a0,152(a5)
    800021be:	bfe9                	j	80002198 <argraw+0x30>
  panic("argraw");
    800021c0:	00006517          	auipc	a0,0x6
    800021c4:	25050513          	addi	a0,a0,592 # 80008410 <states.0+0x148>
    800021c8:	00004097          	auipc	ra,0x4
    800021cc:	ce4080e7          	jalr	-796(ra) # 80005eac <panic>

00000000800021d0 <fetchaddr>:
int fetchaddr(uint64 addr, uint64 *ip) {
    800021d0:	1101                	addi	sp,sp,-32
    800021d2:	ec06                	sd	ra,24(sp)
    800021d4:	e822                	sd	s0,16(sp)
    800021d6:	e426                	sd	s1,8(sp)
    800021d8:	e04a                	sd	s2,0(sp)
    800021da:	1000                	addi	s0,sp,32
    800021dc:	84aa                	mv	s1,a0
    800021de:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800021e0:	fffff097          	auipc	ra,0xfffff
    800021e4:	f48080e7          	jalr	-184(ra) # 80001128 <myproc>
  if (addr >= p->sz ||
    800021e8:	653c                	ld	a5,72(a0)
    800021ea:	02f4f863          	bgeu	s1,a5,8000221a <fetchaddr+0x4a>
      addr + sizeof(uint64) > p->sz)  // both tests needed, in case of overflow
    800021ee:	00848713          	addi	a4,s1,8
  if (addr >= p->sz ||
    800021f2:	02e7e663          	bltu	a5,a4,8000221e <fetchaddr+0x4e>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0) return -1;
    800021f6:	46a1                	li	a3,8
    800021f8:	8626                	mv	a2,s1
    800021fa:	85ca                	mv	a1,s2
    800021fc:	6928                	ld	a0,80(a0)
    800021fe:	fffff097          	auipc	ra,0xfffff
    80002202:	ac2080e7          	jalr	-1342(ra) # 80000cc0 <copyin>
    80002206:	00a03533          	snez	a0,a0
    8000220a:	40a00533          	neg	a0,a0
}
    8000220e:	60e2                	ld	ra,24(sp)
    80002210:	6442                	ld	s0,16(sp)
    80002212:	64a2                	ld	s1,8(sp)
    80002214:	6902                	ld	s2,0(sp)
    80002216:	6105                	addi	sp,sp,32
    80002218:	8082                	ret
    return -1;
    8000221a:	557d                	li	a0,-1
    8000221c:	bfcd                	j	8000220e <fetchaddr+0x3e>
    8000221e:	557d                	li	a0,-1
    80002220:	b7fd                	j	8000220e <fetchaddr+0x3e>

0000000080002222 <fetchstr>:
int fetchstr(uint64 addr, char *buf, int max) {
    80002222:	7179                	addi	sp,sp,-48
    80002224:	f406                	sd	ra,40(sp)
    80002226:	f022                	sd	s0,32(sp)
    80002228:	ec26                	sd	s1,24(sp)
    8000222a:	e84a                	sd	s2,16(sp)
    8000222c:	e44e                	sd	s3,8(sp)
    8000222e:	1800                	addi	s0,sp,48
    80002230:	892a                	mv	s2,a0
    80002232:	84ae                	mv	s1,a1
    80002234:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002236:	fffff097          	auipc	ra,0xfffff
    8000223a:	ef2080e7          	jalr	-270(ra) # 80001128 <myproc>
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
    8000223e:	86ce                	mv	a3,s3
    80002240:	864a                	mv	a2,s2
    80002242:	85a6                	mv	a1,s1
    80002244:	6928                	ld	a0,80(a0)
    80002246:	fffff097          	auipc	ra,0xfffff
    8000224a:	b08080e7          	jalr	-1272(ra) # 80000d4e <copyinstr>
    8000224e:	00054e63          	bltz	a0,8000226a <fetchstr+0x48>
  return strlen(buf);
    80002252:	8526                	mv	a0,s1
    80002254:	ffffe097          	auipc	ra,0xffffe
    80002258:	144080e7          	jalr	324(ra) # 80000398 <strlen>
}
    8000225c:	70a2                	ld	ra,40(sp)
    8000225e:	7402                	ld	s0,32(sp)
    80002260:	64e2                	ld	s1,24(sp)
    80002262:	6942                	ld	s2,16(sp)
    80002264:	69a2                	ld	s3,8(sp)
    80002266:	6145                	addi	sp,sp,48
    80002268:	8082                	ret
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
    8000226a:	557d                	li	a0,-1
    8000226c:	bfc5                	j	8000225c <fetchstr+0x3a>

000000008000226e <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip) { *ip = argraw(n); }
    8000226e:	1101                	addi	sp,sp,-32
    80002270:	ec06                	sd	ra,24(sp)
    80002272:	e822                	sd	s0,16(sp)
    80002274:	e426                	sd	s1,8(sp)
    80002276:	1000                	addi	s0,sp,32
    80002278:	84ae                	mv	s1,a1
    8000227a:	00000097          	auipc	ra,0x0
    8000227e:	eee080e7          	jalr	-274(ra) # 80002168 <argraw>
    80002282:	c088                	sw	a0,0(s1)
    80002284:	60e2                	ld	ra,24(sp)
    80002286:	6442                	ld	s0,16(sp)
    80002288:	64a2                	ld	s1,8(sp)
    8000228a:	6105                	addi	sp,sp,32
    8000228c:	8082                	ret

000000008000228e <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip) { *ip = argraw(n); }
    8000228e:	1101                	addi	sp,sp,-32
    80002290:	ec06                	sd	ra,24(sp)
    80002292:	e822                	sd	s0,16(sp)
    80002294:	e426                	sd	s1,8(sp)
    80002296:	1000                	addi	s0,sp,32
    80002298:	84ae                	mv	s1,a1
    8000229a:	00000097          	auipc	ra,0x0
    8000229e:	ece080e7          	jalr	-306(ra) # 80002168 <argraw>
    800022a2:	e088                	sd	a0,0(s1)
    800022a4:	60e2                	ld	ra,24(sp)
    800022a6:	6442                	ld	s0,16(sp)
    800022a8:	64a2                	ld	s1,8(sp)
    800022aa:	6105                	addi	sp,sp,32
    800022ac:	8082                	ret

00000000800022ae <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max) {
    800022ae:	7179                	addi	sp,sp,-48
    800022b0:	f406                	sd	ra,40(sp)
    800022b2:	f022                	sd	s0,32(sp)
    800022b4:	ec26                	sd	s1,24(sp)
    800022b6:	e84a                	sd	s2,16(sp)
    800022b8:	1800                	addi	s0,sp,48
    800022ba:	84ae                	mv	s1,a1
    800022bc:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800022be:	fd840593          	addi	a1,s0,-40
    800022c2:	00000097          	auipc	ra,0x0
    800022c6:	fcc080e7          	jalr	-52(ra) # 8000228e <argaddr>
  return fetchstr(addr, buf, max);
    800022ca:	864a                	mv	a2,s2
    800022cc:	85a6                	mv	a1,s1
    800022ce:	fd843503          	ld	a0,-40(s0)
    800022d2:	00000097          	auipc	ra,0x0
    800022d6:	f50080e7          	jalr	-176(ra) # 80002222 <fetchstr>
}
    800022da:	70a2                	ld	ra,40(sp)
    800022dc:	7402                	ld	s0,32(sp)
    800022de:	64e2                	ld	s1,24(sp)
    800022e0:	6942                	ld	s2,16(sp)
    800022e2:	6145                	addi	sp,sp,48
    800022e4:	8082                	ret

00000000800022e6 <syscall>:
    [SYS_mknod] = sys_mknod,   [SYS_unlink] = sys_unlink,
    [SYS_link] = sys_link,     [SYS_mkdir] = sys_mkdir,
    [SYS_close] = sys_close,
};

void syscall(void) {
    800022e6:	1101                	addi	sp,sp,-32
    800022e8:	ec06                	sd	ra,24(sp)
    800022ea:	e822                	sd	s0,16(sp)
    800022ec:	e426                	sd	s1,8(sp)
    800022ee:	e04a                	sd	s2,0(sp)
    800022f0:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800022f2:	fffff097          	auipc	ra,0xfffff
    800022f6:	e36080e7          	jalr	-458(ra) # 80001128 <myproc>
    800022fa:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800022fc:	05853903          	ld	s2,88(a0)
    80002300:	0a893783          	ld	a5,168(s2)
    80002304:	0007869b          	sext.w	a3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002308:	37fd                	addiw	a5,a5,-1
    8000230a:	4751                	li	a4,20
    8000230c:	00f76f63          	bltu	a4,a5,8000232a <syscall+0x44>
    80002310:	00369713          	slli	a4,a3,0x3
    80002314:	00006797          	auipc	a5,0x6
    80002318:	13c78793          	addi	a5,a5,316 # 80008450 <syscalls>
    8000231c:	97ba                	add	a5,a5,a4
    8000231e:	639c                	ld	a5,0(a5)
    80002320:	c789                	beqz	a5,8000232a <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002322:	9782                	jalr	a5
    80002324:	06a93823          	sd	a0,112(s2)
    80002328:	a839                	j	80002346 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    8000232a:	15848613          	addi	a2,s1,344
    8000232e:	588c                	lw	a1,48(s1)
    80002330:	00006517          	auipc	a0,0x6
    80002334:	0e850513          	addi	a0,a0,232 # 80008418 <states.0+0x150>
    80002338:	00004097          	auipc	ra,0x4
    8000233c:	bbe080e7          	jalr	-1090(ra) # 80005ef6 <printf>
    p->trapframe->a0 = -1;
    80002340:	6cbc                	ld	a5,88(s1)
    80002342:	577d                	li	a4,-1
    80002344:	fbb8                	sd	a4,112(a5)
  }
}
    80002346:	60e2                	ld	ra,24(sp)
    80002348:	6442                	ld	s0,16(sp)
    8000234a:	64a2                	ld	s1,8(sp)
    8000234c:	6902                	ld	s2,0(sp)
    8000234e:	6105                	addi	sp,sp,32
    80002350:	8082                	ret

0000000080002352 <sys_exit>:
#include "defs.h"
#include "proc.h"
#include "types.h"

uint64 sys_exit(void) {
    80002352:	1101                	addi	sp,sp,-32
    80002354:	ec06                	sd	ra,24(sp)
    80002356:	e822                	sd	s0,16(sp)
    80002358:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000235a:	fec40593          	addi	a1,s0,-20
    8000235e:	4501                	li	a0,0
    80002360:	00000097          	auipc	ra,0x0
    80002364:	f0e080e7          	jalr	-242(ra) # 8000226e <argint>
  exit(n);
    80002368:	fec42503          	lw	a0,-20(s0)
    8000236c:	fffff097          	auipc	ra,0xfffff
    80002370:	59c080e7          	jalr	1436(ra) # 80001908 <exit>
  return 0;  // not reached
}
    80002374:	4501                	li	a0,0
    80002376:	60e2                	ld	ra,24(sp)
    80002378:	6442                	ld	s0,16(sp)
    8000237a:	6105                	addi	sp,sp,32
    8000237c:	8082                	ret

000000008000237e <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    8000237e:	1141                	addi	sp,sp,-16
    80002380:	e406                	sd	ra,8(sp)
    80002382:	e022                	sd	s0,0(sp)
    80002384:	0800                	addi	s0,sp,16
    80002386:	fffff097          	auipc	ra,0xfffff
    8000238a:	da2080e7          	jalr	-606(ra) # 80001128 <myproc>
    8000238e:	5908                	lw	a0,48(a0)
    80002390:	60a2                	ld	ra,8(sp)
    80002392:	6402                	ld	s0,0(sp)
    80002394:	0141                	addi	sp,sp,16
    80002396:	8082                	ret

0000000080002398 <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    80002398:	1141                	addi	sp,sp,-16
    8000239a:	e406                	sd	ra,8(sp)
    8000239c:	e022                	sd	s0,0(sp)
    8000239e:	0800                	addi	s0,sp,16
    800023a0:	fffff097          	auipc	ra,0xfffff
    800023a4:	142080e7          	jalr	322(ra) # 800014e2 <fork>
    800023a8:	60a2                	ld	ra,8(sp)
    800023aa:	6402                	ld	s0,0(sp)
    800023ac:	0141                	addi	sp,sp,16
    800023ae:	8082                	ret

00000000800023b0 <sys_wait>:

uint64 sys_wait(void) {
    800023b0:	1101                	addi	sp,sp,-32
    800023b2:	ec06                	sd	ra,24(sp)
    800023b4:	e822                	sd	s0,16(sp)
    800023b6:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800023b8:	fe840593          	addi	a1,s0,-24
    800023bc:	4501                	li	a0,0
    800023be:	00000097          	auipc	ra,0x0
    800023c2:	ed0080e7          	jalr	-304(ra) # 8000228e <argaddr>
  return wait(p);
    800023c6:	fe843503          	ld	a0,-24(s0)
    800023ca:	fffff097          	auipc	ra,0xfffff
    800023ce:	6e4080e7          	jalr	1764(ra) # 80001aae <wait>
}
    800023d2:	60e2                	ld	ra,24(sp)
    800023d4:	6442                	ld	s0,16(sp)
    800023d6:	6105                	addi	sp,sp,32
    800023d8:	8082                	ret

00000000800023da <sys_sbrk>:

uint64 sys_sbrk(void) {
    800023da:	7179                	addi	sp,sp,-48
    800023dc:	f406                	sd	ra,40(sp)
    800023de:	f022                	sd	s0,32(sp)
    800023e0:	ec26                	sd	s1,24(sp)
    800023e2:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800023e4:	fdc40593          	addi	a1,s0,-36
    800023e8:	4501                	li	a0,0
    800023ea:	00000097          	auipc	ra,0x0
    800023ee:	e84080e7          	jalr	-380(ra) # 8000226e <argint>
  addr = myproc()->sz;
    800023f2:	fffff097          	auipc	ra,0xfffff
    800023f6:	d36080e7          	jalr	-714(ra) # 80001128 <myproc>
    800023fa:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0) return -1;
    800023fc:	fdc42503          	lw	a0,-36(s0)
    80002400:	fffff097          	auipc	ra,0xfffff
    80002404:	086080e7          	jalr	134(ra) # 80001486 <growproc>
    80002408:	00054863          	bltz	a0,80002418 <sys_sbrk+0x3e>
  return addr;
}
    8000240c:	8526                	mv	a0,s1
    8000240e:	70a2                	ld	ra,40(sp)
    80002410:	7402                	ld	s0,32(sp)
    80002412:	64e2                	ld	s1,24(sp)
    80002414:	6145                	addi	sp,sp,48
    80002416:	8082                	ret
  if (growproc(n) < 0) return -1;
    80002418:	54fd                	li	s1,-1
    8000241a:	bfcd                	j	8000240c <sys_sbrk+0x32>

000000008000241c <sys_sleep>:

uint64 sys_sleep(void) {
    8000241c:	7139                	addi	sp,sp,-64
    8000241e:	fc06                	sd	ra,56(sp)
    80002420:	f822                	sd	s0,48(sp)
    80002422:	f426                	sd	s1,40(sp)
    80002424:	f04a                	sd	s2,32(sp)
    80002426:	ec4e                	sd	s3,24(sp)
    80002428:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000242a:	fcc40593          	addi	a1,s0,-52
    8000242e:	4501                	li	a0,0
    80002430:	00000097          	auipc	ra,0x0
    80002434:	e3e080e7          	jalr	-450(ra) # 8000226e <argint>
  if (n < 0) n = 0;
    80002438:	fcc42783          	lw	a5,-52(s0)
    8000243c:	0607cf63          	bltz	a5,800024ba <sys_sleep+0x9e>
  acquire(&tickslock);
    80002440:	0002c517          	auipc	a0,0x2c
    80002444:	38850513          	addi	a0,a0,904 # 8002e7c8 <tickslock>
    80002448:	00004097          	auipc	ra,0x4
    8000244c:	f9c080e7          	jalr	-100(ra) # 800063e4 <acquire>
  ticks0 = ticks;
    80002450:	00006917          	auipc	s2,0x6
    80002454:	4f892903          	lw	s2,1272(s2) # 80008948 <ticks>
  while (ticks - ticks0 < n) {
    80002458:	fcc42783          	lw	a5,-52(s0)
    8000245c:	cf9d                	beqz	a5,8000249a <sys_sleep+0x7e>
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000245e:	0002c997          	auipc	s3,0x2c
    80002462:	36a98993          	addi	s3,s3,874 # 8002e7c8 <tickslock>
    80002466:	00006497          	auipc	s1,0x6
    8000246a:	4e248493          	addi	s1,s1,1250 # 80008948 <ticks>
    if (killed(myproc())) {
    8000246e:	fffff097          	auipc	ra,0xfffff
    80002472:	cba080e7          	jalr	-838(ra) # 80001128 <myproc>
    80002476:	fffff097          	auipc	ra,0xfffff
    8000247a:	606080e7          	jalr	1542(ra) # 80001a7c <killed>
    8000247e:	e129                	bnez	a0,800024c0 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002480:	85ce                	mv	a1,s3
    80002482:	8526                	mv	a0,s1
    80002484:	fffff097          	auipc	ra,0xfffff
    80002488:	350080e7          	jalr	848(ra) # 800017d4 <sleep>
  while (ticks - ticks0 < n) {
    8000248c:	409c                	lw	a5,0(s1)
    8000248e:	412787bb          	subw	a5,a5,s2
    80002492:	fcc42703          	lw	a4,-52(s0)
    80002496:	fce7ece3          	bltu	a5,a4,8000246e <sys_sleep+0x52>
  }
  release(&tickslock);
    8000249a:	0002c517          	auipc	a0,0x2c
    8000249e:	32e50513          	addi	a0,a0,814 # 8002e7c8 <tickslock>
    800024a2:	00004097          	auipc	ra,0x4
    800024a6:	ff6080e7          	jalr	-10(ra) # 80006498 <release>
  return 0;
    800024aa:	4501                	li	a0,0
}
    800024ac:	70e2                	ld	ra,56(sp)
    800024ae:	7442                	ld	s0,48(sp)
    800024b0:	74a2                	ld	s1,40(sp)
    800024b2:	7902                	ld	s2,32(sp)
    800024b4:	69e2                	ld	s3,24(sp)
    800024b6:	6121                	addi	sp,sp,64
    800024b8:	8082                	ret
  if (n < 0) n = 0;
    800024ba:	fc042623          	sw	zero,-52(s0)
    800024be:	b749                	j	80002440 <sys_sleep+0x24>
      release(&tickslock);
    800024c0:	0002c517          	auipc	a0,0x2c
    800024c4:	30850513          	addi	a0,a0,776 # 8002e7c8 <tickslock>
    800024c8:	00004097          	auipc	ra,0x4
    800024cc:	fd0080e7          	jalr	-48(ra) # 80006498 <release>
      return -1;
    800024d0:	557d                	li	a0,-1
    800024d2:	bfe9                	j	800024ac <sys_sleep+0x90>

00000000800024d4 <sys_kill>:

uint64 sys_kill(void) {
    800024d4:	1101                	addi	sp,sp,-32
    800024d6:	ec06                	sd	ra,24(sp)
    800024d8:	e822                	sd	s0,16(sp)
    800024da:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800024dc:	fec40593          	addi	a1,s0,-20
    800024e0:	4501                	li	a0,0
    800024e2:	00000097          	auipc	ra,0x0
    800024e6:	d8c080e7          	jalr	-628(ra) # 8000226e <argint>
  return kill(pid);
    800024ea:	fec42503          	lw	a0,-20(s0)
    800024ee:	fffff097          	auipc	ra,0xfffff
    800024f2:	4f0080e7          	jalr	1264(ra) # 800019de <kill>
}
    800024f6:	60e2                	ld	ra,24(sp)
    800024f8:	6442                	ld	s0,16(sp)
    800024fa:	6105                	addi	sp,sp,32
    800024fc:	8082                	ret

00000000800024fe <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    800024fe:	1101                	addi	sp,sp,-32
    80002500:	ec06                	sd	ra,24(sp)
    80002502:	e822                	sd	s0,16(sp)
    80002504:	e426                	sd	s1,8(sp)
    80002506:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002508:	0002c517          	auipc	a0,0x2c
    8000250c:	2c050513          	addi	a0,a0,704 # 8002e7c8 <tickslock>
    80002510:	00004097          	auipc	ra,0x4
    80002514:	ed4080e7          	jalr	-300(ra) # 800063e4 <acquire>
  xticks = ticks;
    80002518:	00006497          	auipc	s1,0x6
    8000251c:	4304a483          	lw	s1,1072(s1) # 80008948 <ticks>
  release(&tickslock);
    80002520:	0002c517          	auipc	a0,0x2c
    80002524:	2a850513          	addi	a0,a0,680 # 8002e7c8 <tickslock>
    80002528:	00004097          	auipc	ra,0x4
    8000252c:	f70080e7          	jalr	-144(ra) # 80006498 <release>
  return xticks;
}
    80002530:	02049513          	slli	a0,s1,0x20
    80002534:	9101                	srli	a0,a0,0x20
    80002536:	60e2                	ld	ra,24(sp)
    80002538:	6442                	ld	s0,16(sp)
    8000253a:	64a2                	ld	s1,8(sp)
    8000253c:	6105                	addi	sp,sp,32
    8000253e:	8082                	ret

0000000080002540 <binit>:
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  struct buf head;
} bcache;

void binit(void) {
    80002540:	7179                	addi	sp,sp,-48
    80002542:	f406                	sd	ra,40(sp)
    80002544:	f022                	sd	s0,32(sp)
    80002546:	ec26                	sd	s1,24(sp)
    80002548:	e84a                	sd	s2,16(sp)
    8000254a:	e44e                	sd	s3,8(sp)
    8000254c:	e052                	sd	s4,0(sp)
    8000254e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002550:	00006597          	auipc	a1,0x6
    80002554:	fb058593          	addi	a1,a1,-80 # 80008500 <syscalls+0xb0>
    80002558:	0002c517          	auipc	a0,0x2c
    8000255c:	28850513          	addi	a0,a0,648 # 8002e7e0 <bcache>
    80002560:	00004097          	auipc	ra,0x4
    80002564:	df4080e7          	jalr	-524(ra) # 80006354 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002568:	00034797          	auipc	a5,0x34
    8000256c:	27878793          	addi	a5,a5,632 # 800367e0 <bcache+0x8000>
    80002570:	00034717          	auipc	a4,0x34
    80002574:	4d870713          	addi	a4,a4,1240 # 80036a48 <bcache+0x8268>
    80002578:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000257c:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002580:	0002c497          	auipc	s1,0x2c
    80002584:	27848493          	addi	s1,s1,632 # 8002e7f8 <bcache+0x18>
    b->next = bcache.head.next;
    80002588:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000258a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000258c:	00006a17          	auipc	s4,0x6
    80002590:	f7ca0a13          	addi	s4,s4,-132 # 80008508 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002594:	2b893783          	ld	a5,696(s2)
    80002598:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000259a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000259e:	85d2                	mv	a1,s4
    800025a0:	01048513          	addi	a0,s1,16
    800025a4:	00001097          	auipc	ra,0x1
    800025a8:	4c8080e7          	jalr	1224(ra) # 80003a6c <initsleeplock>
    bcache.head.next->prev = b;
    800025ac:	2b893783          	ld	a5,696(s2)
    800025b0:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800025b2:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    800025b6:	45848493          	addi	s1,s1,1112
    800025ba:	fd349de3          	bne	s1,s3,80002594 <binit+0x54>
  }
}
    800025be:	70a2                	ld	ra,40(sp)
    800025c0:	7402                	ld	s0,32(sp)
    800025c2:	64e2                	ld	s1,24(sp)
    800025c4:	6942                	ld	s2,16(sp)
    800025c6:	69a2                	ld	s3,8(sp)
    800025c8:	6a02                	ld	s4,0(sp)
    800025ca:	6145                	addi	sp,sp,48
    800025cc:	8082                	ret

00000000800025ce <bread>:
  }
  panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf *bread(uint dev, uint blockno) {
    800025ce:	7179                	addi	sp,sp,-48
    800025d0:	f406                	sd	ra,40(sp)
    800025d2:	f022                	sd	s0,32(sp)
    800025d4:	ec26                	sd	s1,24(sp)
    800025d6:	e84a                	sd	s2,16(sp)
    800025d8:	e44e                	sd	s3,8(sp)
    800025da:	1800                	addi	s0,sp,48
    800025dc:	892a                	mv	s2,a0
    800025de:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800025e0:	0002c517          	auipc	a0,0x2c
    800025e4:	20050513          	addi	a0,a0,512 # 8002e7e0 <bcache>
    800025e8:	00004097          	auipc	ra,0x4
    800025ec:	dfc080e7          	jalr	-516(ra) # 800063e4 <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    800025f0:	00034497          	auipc	s1,0x34
    800025f4:	4a84b483          	ld	s1,1192(s1) # 80036a98 <bcache+0x82b8>
    800025f8:	00034797          	auipc	a5,0x34
    800025fc:	45078793          	addi	a5,a5,1104 # 80036a48 <bcache+0x8268>
    80002600:	02f48f63          	beq	s1,a5,8000263e <bread+0x70>
    80002604:	873e                	mv	a4,a5
    80002606:	a021                	j	8000260e <bread+0x40>
    80002608:	68a4                	ld	s1,80(s1)
    8000260a:	02e48a63          	beq	s1,a4,8000263e <bread+0x70>
    if (b->dev == dev && b->blockno == blockno) {
    8000260e:	449c                	lw	a5,8(s1)
    80002610:	ff279ce3          	bne	a5,s2,80002608 <bread+0x3a>
    80002614:	44dc                	lw	a5,12(s1)
    80002616:	ff3799e3          	bne	a5,s3,80002608 <bread+0x3a>
      b->refcnt++;
    8000261a:	40bc                	lw	a5,64(s1)
    8000261c:	2785                	addiw	a5,a5,1
    8000261e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002620:	0002c517          	auipc	a0,0x2c
    80002624:	1c050513          	addi	a0,a0,448 # 8002e7e0 <bcache>
    80002628:	00004097          	auipc	ra,0x4
    8000262c:	e70080e7          	jalr	-400(ra) # 80006498 <release>
      acquiresleep(&b->lock);
    80002630:	01048513          	addi	a0,s1,16
    80002634:	00001097          	auipc	ra,0x1
    80002638:	472080e7          	jalr	1138(ra) # 80003aa6 <acquiresleep>
      return b;
    8000263c:	a8b9                	j	8000269a <bread+0xcc>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    8000263e:	00034497          	auipc	s1,0x34
    80002642:	4524b483          	ld	s1,1106(s1) # 80036a90 <bcache+0x82b0>
    80002646:	00034797          	auipc	a5,0x34
    8000264a:	40278793          	addi	a5,a5,1026 # 80036a48 <bcache+0x8268>
    8000264e:	00f48863          	beq	s1,a5,8000265e <bread+0x90>
    80002652:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    80002654:	40bc                	lw	a5,64(s1)
    80002656:	cf81                	beqz	a5,8000266e <bread+0xa0>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002658:	64a4                	ld	s1,72(s1)
    8000265a:	fee49de3          	bne	s1,a4,80002654 <bread+0x86>
  panic("bget: no buffers");
    8000265e:	00006517          	auipc	a0,0x6
    80002662:	eb250513          	addi	a0,a0,-334 # 80008510 <syscalls+0xc0>
    80002666:	00004097          	auipc	ra,0x4
    8000266a:	846080e7          	jalr	-1978(ra) # 80005eac <panic>
      b->dev = dev;
    8000266e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002672:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002676:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000267a:	4785                	li	a5,1
    8000267c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000267e:	0002c517          	auipc	a0,0x2c
    80002682:	16250513          	addi	a0,a0,354 # 8002e7e0 <bcache>
    80002686:	00004097          	auipc	ra,0x4
    8000268a:	e12080e7          	jalr	-494(ra) # 80006498 <release>
      acquiresleep(&b->lock);
    8000268e:	01048513          	addi	a0,s1,16
    80002692:	00001097          	auipc	ra,0x1
    80002696:	414080e7          	jalr	1044(ra) # 80003aa6 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    8000269a:	409c                	lw	a5,0(s1)
    8000269c:	cb89                	beqz	a5,800026ae <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000269e:	8526                	mv	a0,s1
    800026a0:	70a2                	ld	ra,40(sp)
    800026a2:	7402                	ld	s0,32(sp)
    800026a4:	64e2                	ld	s1,24(sp)
    800026a6:	6942                	ld	s2,16(sp)
    800026a8:	69a2                	ld	s3,8(sp)
    800026aa:	6145                	addi	sp,sp,48
    800026ac:	8082                	ret
    virtio_disk_rw(b, 0);
    800026ae:	4581                	li	a1,0
    800026b0:	8526                	mv	a0,s1
    800026b2:	00003097          	auipc	ra,0x3
    800026b6:	ff0080e7          	jalr	-16(ra) # 800056a2 <virtio_disk_rw>
    b->valid = 1;
    800026ba:	4785                	li	a5,1
    800026bc:	c09c                	sw	a5,0(s1)
  return b;
    800026be:	b7c5                	j	8000269e <bread+0xd0>

00000000800026c0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void bwrite(struct buf *b) {
    800026c0:	1101                	addi	sp,sp,-32
    800026c2:	ec06                	sd	ra,24(sp)
    800026c4:	e822                	sd	s0,16(sp)
    800026c6:	e426                	sd	s1,8(sp)
    800026c8:	1000                	addi	s0,sp,32
    800026ca:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock)) panic("bwrite");
    800026cc:	0541                	addi	a0,a0,16
    800026ce:	00001097          	auipc	ra,0x1
    800026d2:	472080e7          	jalr	1138(ra) # 80003b40 <holdingsleep>
    800026d6:	cd01                	beqz	a0,800026ee <bwrite+0x2e>
  virtio_disk_rw(b, 1);
    800026d8:	4585                	li	a1,1
    800026da:	8526                	mv	a0,s1
    800026dc:	00003097          	auipc	ra,0x3
    800026e0:	fc6080e7          	jalr	-58(ra) # 800056a2 <virtio_disk_rw>
}
    800026e4:	60e2                	ld	ra,24(sp)
    800026e6:	6442                	ld	s0,16(sp)
    800026e8:	64a2                	ld	s1,8(sp)
    800026ea:	6105                	addi	sp,sp,32
    800026ec:	8082                	ret
  if (!holdingsleep(&b->lock)) panic("bwrite");
    800026ee:	00006517          	auipc	a0,0x6
    800026f2:	e3a50513          	addi	a0,a0,-454 # 80008528 <syscalls+0xd8>
    800026f6:	00003097          	auipc	ra,0x3
    800026fa:	7b6080e7          	jalr	1974(ra) # 80005eac <panic>

00000000800026fe <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void brelse(struct buf *b) {
    800026fe:	1101                	addi	sp,sp,-32
    80002700:	ec06                	sd	ra,24(sp)
    80002702:	e822                	sd	s0,16(sp)
    80002704:	e426                	sd	s1,8(sp)
    80002706:	e04a                	sd	s2,0(sp)
    80002708:	1000                	addi	s0,sp,32
    8000270a:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock)) panic("brelse");
    8000270c:	01050913          	addi	s2,a0,16
    80002710:	854a                	mv	a0,s2
    80002712:	00001097          	auipc	ra,0x1
    80002716:	42e080e7          	jalr	1070(ra) # 80003b40 <holdingsleep>
    8000271a:	c92d                	beqz	a0,8000278c <brelse+0x8e>

  releasesleep(&b->lock);
    8000271c:	854a                	mv	a0,s2
    8000271e:	00001097          	auipc	ra,0x1
    80002722:	3de080e7          	jalr	990(ra) # 80003afc <releasesleep>

  acquire(&bcache.lock);
    80002726:	0002c517          	auipc	a0,0x2c
    8000272a:	0ba50513          	addi	a0,a0,186 # 8002e7e0 <bcache>
    8000272e:	00004097          	auipc	ra,0x4
    80002732:	cb6080e7          	jalr	-842(ra) # 800063e4 <acquire>
  b->refcnt--;
    80002736:	40bc                	lw	a5,64(s1)
    80002738:	37fd                	addiw	a5,a5,-1
    8000273a:	0007871b          	sext.w	a4,a5
    8000273e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002740:	eb05                	bnez	a4,80002770 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002742:	68bc                	ld	a5,80(s1)
    80002744:	64b8                	ld	a4,72(s1)
    80002746:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002748:	64bc                	ld	a5,72(s1)
    8000274a:	68b8                	ld	a4,80(s1)
    8000274c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000274e:	00034797          	auipc	a5,0x34
    80002752:	09278793          	addi	a5,a5,146 # 800367e0 <bcache+0x8000>
    80002756:	2b87b703          	ld	a4,696(a5)
    8000275a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000275c:	00034717          	auipc	a4,0x34
    80002760:	2ec70713          	addi	a4,a4,748 # 80036a48 <bcache+0x8268>
    80002764:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002766:	2b87b703          	ld	a4,696(a5)
    8000276a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000276c:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    80002770:	0002c517          	auipc	a0,0x2c
    80002774:	07050513          	addi	a0,a0,112 # 8002e7e0 <bcache>
    80002778:	00004097          	auipc	ra,0x4
    8000277c:	d20080e7          	jalr	-736(ra) # 80006498 <release>
}
    80002780:	60e2                	ld	ra,24(sp)
    80002782:	6442                	ld	s0,16(sp)
    80002784:	64a2                	ld	s1,8(sp)
    80002786:	6902                	ld	s2,0(sp)
    80002788:	6105                	addi	sp,sp,32
    8000278a:	8082                	ret
  if (!holdingsleep(&b->lock)) panic("brelse");
    8000278c:	00006517          	auipc	a0,0x6
    80002790:	da450513          	addi	a0,a0,-604 # 80008530 <syscalls+0xe0>
    80002794:	00003097          	auipc	ra,0x3
    80002798:	718080e7          	jalr	1816(ra) # 80005eac <panic>

000000008000279c <bpin>:

void bpin(struct buf *b) {
    8000279c:	1101                	addi	sp,sp,-32
    8000279e:	ec06                	sd	ra,24(sp)
    800027a0:	e822                	sd	s0,16(sp)
    800027a2:	e426                	sd	s1,8(sp)
    800027a4:	1000                	addi	s0,sp,32
    800027a6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800027a8:	0002c517          	auipc	a0,0x2c
    800027ac:	03850513          	addi	a0,a0,56 # 8002e7e0 <bcache>
    800027b0:	00004097          	auipc	ra,0x4
    800027b4:	c34080e7          	jalr	-972(ra) # 800063e4 <acquire>
  b->refcnt++;
    800027b8:	40bc                	lw	a5,64(s1)
    800027ba:	2785                	addiw	a5,a5,1
    800027bc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800027be:	0002c517          	auipc	a0,0x2c
    800027c2:	02250513          	addi	a0,a0,34 # 8002e7e0 <bcache>
    800027c6:	00004097          	auipc	ra,0x4
    800027ca:	cd2080e7          	jalr	-814(ra) # 80006498 <release>
}
    800027ce:	60e2                	ld	ra,24(sp)
    800027d0:	6442                	ld	s0,16(sp)
    800027d2:	64a2                	ld	s1,8(sp)
    800027d4:	6105                	addi	sp,sp,32
    800027d6:	8082                	ret

00000000800027d8 <bunpin>:

void bunpin(struct buf *b) {
    800027d8:	1101                	addi	sp,sp,-32
    800027da:	ec06                	sd	ra,24(sp)
    800027dc:	e822                	sd	s0,16(sp)
    800027de:	e426                	sd	s1,8(sp)
    800027e0:	1000                	addi	s0,sp,32
    800027e2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800027e4:	0002c517          	auipc	a0,0x2c
    800027e8:	ffc50513          	addi	a0,a0,-4 # 8002e7e0 <bcache>
    800027ec:	00004097          	auipc	ra,0x4
    800027f0:	bf8080e7          	jalr	-1032(ra) # 800063e4 <acquire>
  b->refcnt--;
    800027f4:	40bc                	lw	a5,64(s1)
    800027f6:	37fd                	addiw	a5,a5,-1
    800027f8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800027fa:	0002c517          	auipc	a0,0x2c
    800027fe:	fe650513          	addi	a0,a0,-26 # 8002e7e0 <bcache>
    80002802:	00004097          	auipc	ra,0x4
    80002806:	c96080e7          	jalr	-874(ra) # 80006498 <release>
}
    8000280a:	60e2                	ld	ra,24(sp)
    8000280c:	6442                	ld	s0,16(sp)
    8000280e:	64a2                	ld	s1,8(sp)
    80002810:	6105                	addi	sp,sp,32
    80002812:	8082                	ret

0000000080002814 <bfree>:
  printf("balloc: out of blocks\n");
  return 0;
}

// Free a disk block.
static void bfree(int dev, uint b) {
    80002814:	1101                	addi	sp,sp,-32
    80002816:	ec06                	sd	ra,24(sp)
    80002818:	e822                	sd	s0,16(sp)
    8000281a:	e426                	sd	s1,8(sp)
    8000281c:	e04a                	sd	s2,0(sp)
    8000281e:	1000                	addi	s0,sp,32
    80002820:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002822:	00d5d59b          	srliw	a1,a1,0xd
    80002826:	00034797          	auipc	a5,0x34
    8000282a:	6967a783          	lw	a5,1686(a5) # 80036ebc <sb+0x1c>
    8000282e:	9dbd                	addw	a1,a1,a5
    80002830:	00000097          	auipc	ra,0x0
    80002834:	d9e080e7          	jalr	-610(ra) # 800025ce <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002838:	0074f713          	andi	a4,s1,7
    8000283c:	4785                	li	a5,1
    8000283e:	00e797bb          	sllw	a5,a5,a4
  if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
    80002842:	14ce                	slli	s1,s1,0x33
    80002844:	90d9                	srli	s1,s1,0x36
    80002846:	00950733          	add	a4,a0,s1
    8000284a:	05874703          	lbu	a4,88(a4)
    8000284e:	00e7f6b3          	and	a3,a5,a4
    80002852:	c69d                	beqz	a3,80002880 <bfree+0x6c>
    80002854:	892a                	mv	s2,a0
  bp->data[bi / 8] &= ~m;
    80002856:	94aa                	add	s1,s1,a0
    80002858:	fff7c793          	not	a5,a5
    8000285c:	8f7d                	and	a4,a4,a5
    8000285e:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002862:	00001097          	auipc	ra,0x1
    80002866:	126080e7          	jalr	294(ra) # 80003988 <log_write>
  brelse(bp);
    8000286a:	854a                	mv	a0,s2
    8000286c:	00000097          	auipc	ra,0x0
    80002870:	e92080e7          	jalr	-366(ra) # 800026fe <brelse>
}
    80002874:	60e2                	ld	ra,24(sp)
    80002876:	6442                	ld	s0,16(sp)
    80002878:	64a2                	ld	s1,8(sp)
    8000287a:	6902                	ld	s2,0(sp)
    8000287c:	6105                	addi	sp,sp,32
    8000287e:	8082                	ret
  if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
    80002880:	00006517          	auipc	a0,0x6
    80002884:	cb850513          	addi	a0,a0,-840 # 80008538 <syscalls+0xe8>
    80002888:	00003097          	auipc	ra,0x3
    8000288c:	624080e7          	jalr	1572(ra) # 80005eac <panic>

0000000080002890 <balloc>:
static uint balloc(uint dev) {
    80002890:	711d                	addi	sp,sp,-96
    80002892:	ec86                	sd	ra,88(sp)
    80002894:	e8a2                	sd	s0,80(sp)
    80002896:	e4a6                	sd	s1,72(sp)
    80002898:	e0ca                	sd	s2,64(sp)
    8000289a:	fc4e                	sd	s3,56(sp)
    8000289c:	f852                	sd	s4,48(sp)
    8000289e:	f456                	sd	s5,40(sp)
    800028a0:	f05a                	sd	s6,32(sp)
    800028a2:	ec5e                	sd	s7,24(sp)
    800028a4:	e862                	sd	s8,16(sp)
    800028a6:	e466                	sd	s9,8(sp)
    800028a8:	1080                	addi	s0,sp,96
  for (b = 0; b < sb.size; b += BPB) {
    800028aa:	00034797          	auipc	a5,0x34
    800028ae:	5fa7a783          	lw	a5,1530(a5) # 80036ea4 <sb+0x4>
    800028b2:	cff5                	beqz	a5,800029ae <balloc+0x11e>
    800028b4:	8baa                	mv	s7,a0
    800028b6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800028b8:	00034b17          	auipc	s6,0x34
    800028bc:	5e8b0b13          	addi	s6,s6,1512 # 80036ea0 <sb>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800028c0:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800028c2:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800028c4:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    800028c6:	6c89                	lui	s9,0x2
    800028c8:	a061                	j	80002950 <balloc+0xc0>
        bp->data[bi / 8] |= m;            // Mark block in use.
    800028ca:	97ca                	add	a5,a5,s2
    800028cc:	8e55                	or	a2,a2,a3
    800028ce:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800028d2:	854a                	mv	a0,s2
    800028d4:	00001097          	auipc	ra,0x1
    800028d8:	0b4080e7          	jalr	180(ra) # 80003988 <log_write>
        brelse(bp);
    800028dc:	854a                	mv	a0,s2
    800028de:	00000097          	auipc	ra,0x0
    800028e2:	e20080e7          	jalr	-480(ra) # 800026fe <brelse>
  bp = bread(dev, bno);
    800028e6:	85a6                	mv	a1,s1
    800028e8:	855e                	mv	a0,s7
    800028ea:	00000097          	auipc	ra,0x0
    800028ee:	ce4080e7          	jalr	-796(ra) # 800025ce <bread>
    800028f2:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028f4:	40000613          	li	a2,1024
    800028f8:	4581                	li	a1,0
    800028fa:	05850513          	addi	a0,a0,88
    800028fe:	ffffe097          	auipc	ra,0xffffe
    80002902:	91e080e7          	jalr	-1762(ra) # 8000021c <memset>
  log_write(bp);
    80002906:	854a                	mv	a0,s2
    80002908:	00001097          	auipc	ra,0x1
    8000290c:	080080e7          	jalr	128(ra) # 80003988 <log_write>
  brelse(bp);
    80002910:	854a                	mv	a0,s2
    80002912:	00000097          	auipc	ra,0x0
    80002916:	dec080e7          	jalr	-532(ra) # 800026fe <brelse>
}
    8000291a:	8526                	mv	a0,s1
    8000291c:	60e6                	ld	ra,88(sp)
    8000291e:	6446                	ld	s0,80(sp)
    80002920:	64a6                	ld	s1,72(sp)
    80002922:	6906                	ld	s2,64(sp)
    80002924:	79e2                	ld	s3,56(sp)
    80002926:	7a42                	ld	s4,48(sp)
    80002928:	7aa2                	ld	s5,40(sp)
    8000292a:	7b02                	ld	s6,32(sp)
    8000292c:	6be2                	ld	s7,24(sp)
    8000292e:	6c42                	ld	s8,16(sp)
    80002930:	6ca2                	ld	s9,8(sp)
    80002932:	6125                	addi	sp,sp,96
    80002934:	8082                	ret
    brelse(bp);
    80002936:	854a                	mv	a0,s2
    80002938:	00000097          	auipc	ra,0x0
    8000293c:	dc6080e7          	jalr	-570(ra) # 800026fe <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    80002940:	015c87bb          	addw	a5,s9,s5
    80002944:	00078a9b          	sext.w	s5,a5
    80002948:	004b2703          	lw	a4,4(s6)
    8000294c:	06eaf163          	bgeu	s5,a4,800029ae <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80002950:	41fad79b          	sraiw	a5,s5,0x1f
    80002954:	0137d79b          	srliw	a5,a5,0x13
    80002958:	015787bb          	addw	a5,a5,s5
    8000295c:	40d7d79b          	sraiw	a5,a5,0xd
    80002960:	01cb2583          	lw	a1,28(s6)
    80002964:	9dbd                	addw	a1,a1,a5
    80002966:	855e                	mv	a0,s7
    80002968:	00000097          	auipc	ra,0x0
    8000296c:	c66080e7          	jalr	-922(ra) # 800025ce <bread>
    80002970:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002972:	004b2503          	lw	a0,4(s6)
    80002976:	000a849b          	sext.w	s1,s5
    8000297a:	8762                	mv	a4,s8
    8000297c:	faa4fde3          	bgeu	s1,a0,80002936 <balloc+0xa6>
      m = 1 << (bi % 8);
    80002980:	00777693          	andi	a3,a4,7
    80002984:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) {  // Is block free?
    80002988:	41f7579b          	sraiw	a5,a4,0x1f
    8000298c:	01d7d79b          	srliw	a5,a5,0x1d
    80002990:	9fb9                	addw	a5,a5,a4
    80002992:	4037d79b          	sraiw	a5,a5,0x3
    80002996:	00f90633          	add	a2,s2,a5
    8000299a:	05864603          	lbu	a2,88(a2)
    8000299e:	00c6f5b3          	and	a1,a3,a2
    800029a2:	d585                	beqz	a1,800028ca <balloc+0x3a>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800029a4:	2705                	addiw	a4,a4,1
    800029a6:	2485                	addiw	s1,s1,1
    800029a8:	fd471ae3          	bne	a4,s4,8000297c <balloc+0xec>
    800029ac:	b769                	j	80002936 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    800029ae:	00006517          	auipc	a0,0x6
    800029b2:	ba250513          	addi	a0,a0,-1118 # 80008550 <syscalls+0x100>
    800029b6:	00003097          	auipc	ra,0x3
    800029ba:	540080e7          	jalr	1344(ra) # 80005ef6 <printf>
  return 0;
    800029be:	4481                	li	s1,0
    800029c0:	bfa9                	j	8000291a <balloc+0x8a>

00000000800029c2 <bmap>:
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint bmap(struct inode *ip, uint bn) {
    800029c2:	7179                	addi	sp,sp,-48
    800029c4:	f406                	sd	ra,40(sp)
    800029c6:	f022                	sd	s0,32(sp)
    800029c8:	ec26                	sd	s1,24(sp)
    800029ca:	e84a                	sd	s2,16(sp)
    800029cc:	e44e                	sd	s3,8(sp)
    800029ce:	e052                	sd	s4,0(sp)
    800029d0:	1800                	addi	s0,sp,48
    800029d2:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    800029d4:	47ad                	li	a5,11
    800029d6:	02b7e863          	bltu	a5,a1,80002a06 <bmap+0x44>
    if ((addr = ip->addrs[bn]) == 0) {
    800029da:	02059793          	slli	a5,a1,0x20
    800029de:	01e7d593          	srli	a1,a5,0x1e
    800029e2:	00b504b3          	add	s1,a0,a1
    800029e6:	0504a903          	lw	s2,80(s1)
    800029ea:	06091e63          	bnez	s2,80002a66 <bmap+0xa4>
      addr = balloc(ip->dev);
    800029ee:	4108                	lw	a0,0(a0)
    800029f0:	00000097          	auipc	ra,0x0
    800029f4:	ea0080e7          	jalr	-352(ra) # 80002890 <balloc>
    800029f8:	0005091b          	sext.w	s2,a0
      if (addr == 0) return 0;
    800029fc:	06090563          	beqz	s2,80002a66 <bmap+0xa4>
      ip->addrs[bn] = addr;
    80002a00:	0524a823          	sw	s2,80(s1)
    80002a04:	a08d                	j	80002a66 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002a06:	ff45849b          	addiw	s1,a1,-12
    80002a0a:	0004871b          	sext.w	a4,s1

  if (bn < NINDIRECT) {
    80002a0e:	0ff00793          	li	a5,255
    80002a12:	08e7e563          	bltu	a5,a4,80002a9c <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    80002a16:	08052903          	lw	s2,128(a0)
    80002a1a:	00091d63          	bnez	s2,80002a34 <bmap+0x72>
      addr = balloc(ip->dev);
    80002a1e:	4108                	lw	a0,0(a0)
    80002a20:	00000097          	auipc	ra,0x0
    80002a24:	e70080e7          	jalr	-400(ra) # 80002890 <balloc>
    80002a28:	0005091b          	sext.w	s2,a0
      if (addr == 0) return 0;
    80002a2c:	02090d63          	beqz	s2,80002a66 <bmap+0xa4>
      ip->addrs[NDIRECT] = addr;
    80002a30:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002a34:	85ca                	mv	a1,s2
    80002a36:	0009a503          	lw	a0,0(s3)
    80002a3a:	00000097          	auipc	ra,0x0
    80002a3e:	b94080e7          	jalr	-1132(ra) # 800025ce <bread>
    80002a42:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    80002a44:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    80002a48:	02049713          	slli	a4,s1,0x20
    80002a4c:	01e75593          	srli	a1,a4,0x1e
    80002a50:	00b784b3          	add	s1,a5,a1
    80002a54:	0004a903          	lw	s2,0(s1)
    80002a58:	02090063          	beqz	s2,80002a78 <bmap+0xb6>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002a5c:	8552                	mv	a0,s4
    80002a5e:	00000097          	auipc	ra,0x0
    80002a62:	ca0080e7          	jalr	-864(ra) # 800026fe <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002a66:	854a                	mv	a0,s2
    80002a68:	70a2                	ld	ra,40(sp)
    80002a6a:	7402                	ld	s0,32(sp)
    80002a6c:	64e2                	ld	s1,24(sp)
    80002a6e:	6942                	ld	s2,16(sp)
    80002a70:	69a2                	ld	s3,8(sp)
    80002a72:	6a02                	ld	s4,0(sp)
    80002a74:	6145                	addi	sp,sp,48
    80002a76:	8082                	ret
      addr = balloc(ip->dev);
    80002a78:	0009a503          	lw	a0,0(s3)
    80002a7c:	00000097          	auipc	ra,0x0
    80002a80:	e14080e7          	jalr	-492(ra) # 80002890 <balloc>
    80002a84:	0005091b          	sext.w	s2,a0
      if (addr) {
    80002a88:	fc090ae3          	beqz	s2,80002a5c <bmap+0x9a>
        a[bn] = addr;
    80002a8c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002a90:	8552                	mv	a0,s4
    80002a92:	00001097          	auipc	ra,0x1
    80002a96:	ef6080e7          	jalr	-266(ra) # 80003988 <log_write>
    80002a9a:	b7c9                	j	80002a5c <bmap+0x9a>
  panic("bmap: out of range");
    80002a9c:	00006517          	auipc	a0,0x6
    80002aa0:	acc50513          	addi	a0,a0,-1332 # 80008568 <syscalls+0x118>
    80002aa4:	00003097          	auipc	ra,0x3
    80002aa8:	408080e7          	jalr	1032(ra) # 80005eac <panic>

0000000080002aac <iget>:
static struct inode *iget(uint dev, uint inum) {
    80002aac:	7179                	addi	sp,sp,-48
    80002aae:	f406                	sd	ra,40(sp)
    80002ab0:	f022                	sd	s0,32(sp)
    80002ab2:	ec26                	sd	s1,24(sp)
    80002ab4:	e84a                	sd	s2,16(sp)
    80002ab6:	e44e                	sd	s3,8(sp)
    80002ab8:	e052                	sd	s4,0(sp)
    80002aba:	1800                	addi	s0,sp,48
    80002abc:	89aa                	mv	s3,a0
    80002abe:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002ac0:	00034517          	auipc	a0,0x34
    80002ac4:	40050513          	addi	a0,a0,1024 # 80036ec0 <itable>
    80002ac8:	00004097          	auipc	ra,0x4
    80002acc:	91c080e7          	jalr	-1764(ra) # 800063e4 <acquire>
  empty = 0;
    80002ad0:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80002ad2:	00034497          	auipc	s1,0x34
    80002ad6:	40648493          	addi	s1,s1,1030 # 80036ed8 <itable+0x18>
    80002ada:	00036697          	auipc	a3,0x36
    80002ade:	e8e68693          	addi	a3,a3,-370 # 80038968 <log>
    80002ae2:	a039                	j	80002af0 <iget+0x44>
    if (empty == 0 && ip->ref == 0)  // Remember empty slot.
    80002ae4:	02090b63          	beqz	s2,80002b1a <iget+0x6e>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80002ae8:	08848493          	addi	s1,s1,136
    80002aec:	02d48a63          	beq	s1,a3,80002b20 <iget+0x74>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    80002af0:	449c                	lw	a5,8(s1)
    80002af2:	fef059e3          	blez	a5,80002ae4 <iget+0x38>
    80002af6:	4098                	lw	a4,0(s1)
    80002af8:	ff3716e3          	bne	a4,s3,80002ae4 <iget+0x38>
    80002afc:	40d8                	lw	a4,4(s1)
    80002afe:	ff4713e3          	bne	a4,s4,80002ae4 <iget+0x38>
      ip->ref++;
    80002b02:	2785                	addiw	a5,a5,1
    80002b04:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002b06:	00034517          	auipc	a0,0x34
    80002b0a:	3ba50513          	addi	a0,a0,954 # 80036ec0 <itable>
    80002b0e:	00004097          	auipc	ra,0x4
    80002b12:	98a080e7          	jalr	-1654(ra) # 80006498 <release>
      return ip;
    80002b16:	8926                	mv	s2,s1
    80002b18:	a03d                	j	80002b46 <iget+0x9a>
    if (empty == 0 && ip->ref == 0)  // Remember empty slot.
    80002b1a:	f7f9                	bnez	a5,80002ae8 <iget+0x3c>
    80002b1c:	8926                	mv	s2,s1
    80002b1e:	b7e9                	j	80002ae8 <iget+0x3c>
  if (empty == 0) panic("iget: no inodes");
    80002b20:	02090c63          	beqz	s2,80002b58 <iget+0xac>
  ip->dev = dev;
    80002b24:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002b28:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002b2c:	4785                	li	a5,1
    80002b2e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002b32:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002b36:	00034517          	auipc	a0,0x34
    80002b3a:	38a50513          	addi	a0,a0,906 # 80036ec0 <itable>
    80002b3e:	00004097          	auipc	ra,0x4
    80002b42:	95a080e7          	jalr	-1702(ra) # 80006498 <release>
}
    80002b46:	854a                	mv	a0,s2
    80002b48:	70a2                	ld	ra,40(sp)
    80002b4a:	7402                	ld	s0,32(sp)
    80002b4c:	64e2                	ld	s1,24(sp)
    80002b4e:	6942                	ld	s2,16(sp)
    80002b50:	69a2                	ld	s3,8(sp)
    80002b52:	6a02                	ld	s4,0(sp)
    80002b54:	6145                	addi	sp,sp,48
    80002b56:	8082                	ret
  if (empty == 0) panic("iget: no inodes");
    80002b58:	00006517          	auipc	a0,0x6
    80002b5c:	a2850513          	addi	a0,a0,-1496 # 80008580 <syscalls+0x130>
    80002b60:	00003097          	auipc	ra,0x3
    80002b64:	34c080e7          	jalr	844(ra) # 80005eac <panic>

0000000080002b68 <fsinit>:
void fsinit(int dev) {
    80002b68:	7179                	addi	sp,sp,-48
    80002b6a:	f406                	sd	ra,40(sp)
    80002b6c:	f022                	sd	s0,32(sp)
    80002b6e:	ec26                	sd	s1,24(sp)
    80002b70:	e84a                	sd	s2,16(sp)
    80002b72:	e44e                	sd	s3,8(sp)
    80002b74:	1800                	addi	s0,sp,48
    80002b76:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b78:	4585                	li	a1,1
    80002b7a:	00000097          	auipc	ra,0x0
    80002b7e:	a54080e7          	jalr	-1452(ra) # 800025ce <bread>
    80002b82:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b84:	00034997          	auipc	s3,0x34
    80002b88:	31c98993          	addi	s3,s3,796 # 80036ea0 <sb>
    80002b8c:	02000613          	li	a2,32
    80002b90:	05850593          	addi	a1,a0,88
    80002b94:	854e                	mv	a0,s3
    80002b96:	ffffd097          	auipc	ra,0xffffd
    80002b9a:	6e2080e7          	jalr	1762(ra) # 80000278 <memmove>
  brelse(bp);
    80002b9e:	8526                	mv	a0,s1
    80002ba0:	00000097          	auipc	ra,0x0
    80002ba4:	b5e080e7          	jalr	-1186(ra) # 800026fe <brelse>
  if (sb.magic != FSMAGIC) panic("invalid file system");
    80002ba8:	0009a703          	lw	a4,0(s3)
    80002bac:	102037b7          	lui	a5,0x10203
    80002bb0:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002bb4:	02f71263          	bne	a4,a5,80002bd8 <fsinit+0x70>
  initlog(dev, &sb);
    80002bb8:	00034597          	auipc	a1,0x34
    80002bbc:	2e858593          	addi	a1,a1,744 # 80036ea0 <sb>
    80002bc0:	854a                	mv	a0,s2
    80002bc2:	00001097          	auipc	ra,0x1
    80002bc6:	b4a080e7          	jalr	-1206(ra) # 8000370c <initlog>
}
    80002bca:	70a2                	ld	ra,40(sp)
    80002bcc:	7402                	ld	s0,32(sp)
    80002bce:	64e2                	ld	s1,24(sp)
    80002bd0:	6942                	ld	s2,16(sp)
    80002bd2:	69a2                	ld	s3,8(sp)
    80002bd4:	6145                	addi	sp,sp,48
    80002bd6:	8082                	ret
  if (sb.magic != FSMAGIC) panic("invalid file system");
    80002bd8:	00006517          	auipc	a0,0x6
    80002bdc:	9b850513          	addi	a0,a0,-1608 # 80008590 <syscalls+0x140>
    80002be0:	00003097          	auipc	ra,0x3
    80002be4:	2cc080e7          	jalr	716(ra) # 80005eac <panic>

0000000080002be8 <iinit>:
void iinit() {
    80002be8:	7179                	addi	sp,sp,-48
    80002bea:	f406                	sd	ra,40(sp)
    80002bec:	f022                	sd	s0,32(sp)
    80002bee:	ec26                	sd	s1,24(sp)
    80002bf0:	e84a                	sd	s2,16(sp)
    80002bf2:	e44e                	sd	s3,8(sp)
    80002bf4:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002bf6:	00006597          	auipc	a1,0x6
    80002bfa:	9b258593          	addi	a1,a1,-1614 # 800085a8 <syscalls+0x158>
    80002bfe:	00034517          	auipc	a0,0x34
    80002c02:	2c250513          	addi	a0,a0,706 # 80036ec0 <itable>
    80002c06:	00003097          	auipc	ra,0x3
    80002c0a:	74e080e7          	jalr	1870(ra) # 80006354 <initlock>
  for (i = 0; i < NINODE; i++) {
    80002c0e:	00034497          	auipc	s1,0x34
    80002c12:	2da48493          	addi	s1,s1,730 # 80036ee8 <itable+0x28>
    80002c16:	00036997          	auipc	s3,0x36
    80002c1a:	d6298993          	addi	s3,s3,-670 # 80038978 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002c1e:	00006917          	auipc	s2,0x6
    80002c22:	99290913          	addi	s2,s2,-1646 # 800085b0 <syscalls+0x160>
    80002c26:	85ca                	mv	a1,s2
    80002c28:	8526                	mv	a0,s1
    80002c2a:	00001097          	auipc	ra,0x1
    80002c2e:	e42080e7          	jalr	-446(ra) # 80003a6c <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    80002c32:	08848493          	addi	s1,s1,136
    80002c36:	ff3498e3          	bne	s1,s3,80002c26 <iinit+0x3e>
}
    80002c3a:	70a2                	ld	ra,40(sp)
    80002c3c:	7402                	ld	s0,32(sp)
    80002c3e:	64e2                	ld	s1,24(sp)
    80002c40:	6942                	ld	s2,16(sp)
    80002c42:	69a2                	ld	s3,8(sp)
    80002c44:	6145                	addi	sp,sp,48
    80002c46:	8082                	ret

0000000080002c48 <ialloc>:
struct inode *ialloc(uint dev, short type) {
    80002c48:	715d                	addi	sp,sp,-80
    80002c4a:	e486                	sd	ra,72(sp)
    80002c4c:	e0a2                	sd	s0,64(sp)
    80002c4e:	fc26                	sd	s1,56(sp)
    80002c50:	f84a                	sd	s2,48(sp)
    80002c52:	f44e                	sd	s3,40(sp)
    80002c54:	f052                	sd	s4,32(sp)
    80002c56:	ec56                	sd	s5,24(sp)
    80002c58:	e85a                	sd	s6,16(sp)
    80002c5a:	e45e                	sd	s7,8(sp)
    80002c5c:	0880                	addi	s0,sp,80
  for (inum = 1; inum < sb.ninodes; inum++) {
    80002c5e:	00034717          	auipc	a4,0x34
    80002c62:	24e72703          	lw	a4,590(a4) # 80036eac <sb+0xc>
    80002c66:	4785                	li	a5,1
    80002c68:	04e7fa63          	bgeu	a5,a4,80002cbc <ialloc+0x74>
    80002c6c:	8aaa                	mv	s5,a0
    80002c6e:	8bae                	mv	s7,a1
    80002c70:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002c72:	00034a17          	auipc	s4,0x34
    80002c76:	22ea0a13          	addi	s4,s4,558 # 80036ea0 <sb>
    80002c7a:	00048b1b          	sext.w	s6,s1
    80002c7e:	0044d593          	srli	a1,s1,0x4
    80002c82:	018a2783          	lw	a5,24(s4)
    80002c86:	9dbd                	addw	a1,a1,a5
    80002c88:	8556                	mv	a0,s5
    80002c8a:	00000097          	auipc	ra,0x0
    80002c8e:	944080e7          	jalr	-1724(ra) # 800025ce <bread>
    80002c92:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    80002c94:	05850993          	addi	s3,a0,88
    80002c98:	00f4f793          	andi	a5,s1,15
    80002c9c:	079a                	slli	a5,a5,0x6
    80002c9e:	99be                	add	s3,s3,a5
    if (dip->type == 0) {  // a free inode
    80002ca0:	00099783          	lh	a5,0(s3)
    80002ca4:	c3a1                	beqz	a5,80002ce4 <ialloc+0x9c>
    brelse(bp);
    80002ca6:	00000097          	auipc	ra,0x0
    80002caa:	a58080e7          	jalr	-1448(ra) # 800026fe <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    80002cae:	0485                	addi	s1,s1,1
    80002cb0:	00ca2703          	lw	a4,12(s4)
    80002cb4:	0004879b          	sext.w	a5,s1
    80002cb8:	fce7e1e3          	bltu	a5,a4,80002c7a <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002cbc:	00006517          	auipc	a0,0x6
    80002cc0:	8fc50513          	addi	a0,a0,-1796 # 800085b8 <syscalls+0x168>
    80002cc4:	00003097          	auipc	ra,0x3
    80002cc8:	232080e7          	jalr	562(ra) # 80005ef6 <printf>
  return 0;
    80002ccc:	4501                	li	a0,0
}
    80002cce:	60a6                	ld	ra,72(sp)
    80002cd0:	6406                	ld	s0,64(sp)
    80002cd2:	74e2                	ld	s1,56(sp)
    80002cd4:	7942                	ld	s2,48(sp)
    80002cd6:	79a2                	ld	s3,40(sp)
    80002cd8:	7a02                	ld	s4,32(sp)
    80002cda:	6ae2                	ld	s5,24(sp)
    80002cdc:	6b42                	ld	s6,16(sp)
    80002cde:	6ba2                	ld	s7,8(sp)
    80002ce0:	6161                	addi	sp,sp,80
    80002ce2:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002ce4:	04000613          	li	a2,64
    80002ce8:	4581                	li	a1,0
    80002cea:	854e                	mv	a0,s3
    80002cec:	ffffd097          	auipc	ra,0xffffd
    80002cf0:	530080e7          	jalr	1328(ra) # 8000021c <memset>
      dip->type = type;
    80002cf4:	01799023          	sh	s7,0(s3)
      log_write(bp);  // mark it allocated on the disk
    80002cf8:	854a                	mv	a0,s2
    80002cfa:	00001097          	auipc	ra,0x1
    80002cfe:	c8e080e7          	jalr	-882(ra) # 80003988 <log_write>
      brelse(bp);
    80002d02:	854a                	mv	a0,s2
    80002d04:	00000097          	auipc	ra,0x0
    80002d08:	9fa080e7          	jalr	-1542(ra) # 800026fe <brelse>
      return iget(dev, inum);
    80002d0c:	85da                	mv	a1,s6
    80002d0e:	8556                	mv	a0,s5
    80002d10:	00000097          	auipc	ra,0x0
    80002d14:	d9c080e7          	jalr	-612(ra) # 80002aac <iget>
    80002d18:	bf5d                	j	80002cce <ialloc+0x86>

0000000080002d1a <iupdate>:
void iupdate(struct inode *ip) {
    80002d1a:	1101                	addi	sp,sp,-32
    80002d1c:	ec06                	sd	ra,24(sp)
    80002d1e:	e822                	sd	s0,16(sp)
    80002d20:	e426                	sd	s1,8(sp)
    80002d22:	e04a                	sd	s2,0(sp)
    80002d24:	1000                	addi	s0,sp,32
    80002d26:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d28:	415c                	lw	a5,4(a0)
    80002d2a:	0047d79b          	srliw	a5,a5,0x4
    80002d2e:	00034597          	auipc	a1,0x34
    80002d32:	18a5a583          	lw	a1,394(a1) # 80036eb8 <sb+0x18>
    80002d36:	9dbd                	addw	a1,a1,a5
    80002d38:	4108                	lw	a0,0(a0)
    80002d3a:	00000097          	auipc	ra,0x0
    80002d3e:	894080e7          	jalr	-1900(ra) # 800025ce <bread>
    80002d42:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002d44:	05850793          	addi	a5,a0,88
    80002d48:	40d8                	lw	a4,4(s1)
    80002d4a:	8b3d                	andi	a4,a4,15
    80002d4c:	071a                	slli	a4,a4,0x6
    80002d4e:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002d50:	04449703          	lh	a4,68(s1)
    80002d54:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002d58:	04649703          	lh	a4,70(s1)
    80002d5c:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002d60:	04849703          	lh	a4,72(s1)
    80002d64:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002d68:	04a49703          	lh	a4,74(s1)
    80002d6c:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002d70:	44f8                	lw	a4,76(s1)
    80002d72:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002d74:	03400613          	li	a2,52
    80002d78:	05048593          	addi	a1,s1,80
    80002d7c:	00c78513          	addi	a0,a5,12
    80002d80:	ffffd097          	auipc	ra,0xffffd
    80002d84:	4f8080e7          	jalr	1272(ra) # 80000278 <memmove>
  log_write(bp);
    80002d88:	854a                	mv	a0,s2
    80002d8a:	00001097          	auipc	ra,0x1
    80002d8e:	bfe080e7          	jalr	-1026(ra) # 80003988 <log_write>
  brelse(bp);
    80002d92:	854a                	mv	a0,s2
    80002d94:	00000097          	auipc	ra,0x0
    80002d98:	96a080e7          	jalr	-1686(ra) # 800026fe <brelse>
}
    80002d9c:	60e2                	ld	ra,24(sp)
    80002d9e:	6442                	ld	s0,16(sp)
    80002da0:	64a2                	ld	s1,8(sp)
    80002da2:	6902                	ld	s2,0(sp)
    80002da4:	6105                	addi	sp,sp,32
    80002da6:	8082                	ret

0000000080002da8 <idup>:
struct inode *idup(struct inode *ip) {
    80002da8:	1101                	addi	sp,sp,-32
    80002daa:	ec06                	sd	ra,24(sp)
    80002dac:	e822                	sd	s0,16(sp)
    80002dae:	e426                	sd	s1,8(sp)
    80002db0:	1000                	addi	s0,sp,32
    80002db2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002db4:	00034517          	auipc	a0,0x34
    80002db8:	10c50513          	addi	a0,a0,268 # 80036ec0 <itable>
    80002dbc:	00003097          	auipc	ra,0x3
    80002dc0:	628080e7          	jalr	1576(ra) # 800063e4 <acquire>
  ip->ref++;
    80002dc4:	449c                	lw	a5,8(s1)
    80002dc6:	2785                	addiw	a5,a5,1
    80002dc8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dca:	00034517          	auipc	a0,0x34
    80002dce:	0f650513          	addi	a0,a0,246 # 80036ec0 <itable>
    80002dd2:	00003097          	auipc	ra,0x3
    80002dd6:	6c6080e7          	jalr	1734(ra) # 80006498 <release>
}
    80002dda:	8526                	mv	a0,s1
    80002ddc:	60e2                	ld	ra,24(sp)
    80002dde:	6442                	ld	s0,16(sp)
    80002de0:	64a2                	ld	s1,8(sp)
    80002de2:	6105                	addi	sp,sp,32
    80002de4:	8082                	ret

0000000080002de6 <ilock>:
void ilock(struct inode *ip) {
    80002de6:	1101                	addi	sp,sp,-32
    80002de8:	ec06                	sd	ra,24(sp)
    80002dea:	e822                	sd	s0,16(sp)
    80002dec:	e426                	sd	s1,8(sp)
    80002dee:	e04a                	sd	s2,0(sp)
    80002df0:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1) panic("ilock");
    80002df2:	c115                	beqz	a0,80002e16 <ilock+0x30>
    80002df4:	84aa                	mv	s1,a0
    80002df6:	451c                	lw	a5,8(a0)
    80002df8:	00f05f63          	blez	a5,80002e16 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002dfc:	0541                	addi	a0,a0,16
    80002dfe:	00001097          	auipc	ra,0x1
    80002e02:	ca8080e7          	jalr	-856(ra) # 80003aa6 <acquiresleep>
  if (ip->valid == 0) {
    80002e06:	40bc                	lw	a5,64(s1)
    80002e08:	cf99                	beqz	a5,80002e26 <ilock+0x40>
}
    80002e0a:	60e2                	ld	ra,24(sp)
    80002e0c:	6442                	ld	s0,16(sp)
    80002e0e:	64a2                	ld	s1,8(sp)
    80002e10:	6902                	ld	s2,0(sp)
    80002e12:	6105                	addi	sp,sp,32
    80002e14:	8082                	ret
  if (ip == 0 || ip->ref < 1) panic("ilock");
    80002e16:	00005517          	auipc	a0,0x5
    80002e1a:	7ba50513          	addi	a0,a0,1978 # 800085d0 <syscalls+0x180>
    80002e1e:	00003097          	auipc	ra,0x3
    80002e22:	08e080e7          	jalr	142(ra) # 80005eac <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e26:	40dc                	lw	a5,4(s1)
    80002e28:	0047d79b          	srliw	a5,a5,0x4
    80002e2c:	00034597          	auipc	a1,0x34
    80002e30:	08c5a583          	lw	a1,140(a1) # 80036eb8 <sb+0x18>
    80002e34:	9dbd                	addw	a1,a1,a5
    80002e36:	4088                	lw	a0,0(s1)
    80002e38:	fffff097          	auipc	ra,0xfffff
    80002e3c:	796080e7          	jalr	1942(ra) # 800025ce <bread>
    80002e40:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002e42:	05850593          	addi	a1,a0,88
    80002e46:	40dc                	lw	a5,4(s1)
    80002e48:	8bbd                	andi	a5,a5,15
    80002e4a:	079a                	slli	a5,a5,0x6
    80002e4c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002e4e:	00059783          	lh	a5,0(a1)
    80002e52:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002e56:	00259783          	lh	a5,2(a1)
    80002e5a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002e5e:	00459783          	lh	a5,4(a1)
    80002e62:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002e66:	00659783          	lh	a5,6(a1)
    80002e6a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002e6e:	459c                	lw	a5,8(a1)
    80002e70:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002e72:	03400613          	li	a2,52
    80002e76:	05b1                	addi	a1,a1,12
    80002e78:	05048513          	addi	a0,s1,80
    80002e7c:	ffffd097          	auipc	ra,0xffffd
    80002e80:	3fc080e7          	jalr	1020(ra) # 80000278 <memmove>
    brelse(bp);
    80002e84:	854a                	mv	a0,s2
    80002e86:	00000097          	auipc	ra,0x0
    80002e8a:	878080e7          	jalr	-1928(ra) # 800026fe <brelse>
    ip->valid = 1;
    80002e8e:	4785                	li	a5,1
    80002e90:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0) panic("ilock: no type");
    80002e92:	04449783          	lh	a5,68(s1)
    80002e96:	fbb5                	bnez	a5,80002e0a <ilock+0x24>
    80002e98:	00005517          	auipc	a0,0x5
    80002e9c:	74050513          	addi	a0,a0,1856 # 800085d8 <syscalls+0x188>
    80002ea0:	00003097          	auipc	ra,0x3
    80002ea4:	00c080e7          	jalr	12(ra) # 80005eac <panic>

0000000080002ea8 <iunlock>:
void iunlock(struct inode *ip) {
    80002ea8:	1101                	addi	sp,sp,-32
    80002eaa:	ec06                	sd	ra,24(sp)
    80002eac:	e822                	sd	s0,16(sp)
    80002eae:	e426                	sd	s1,8(sp)
    80002eb0:	e04a                	sd	s2,0(sp)
    80002eb2:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
    80002eb4:	c905                	beqz	a0,80002ee4 <iunlock+0x3c>
    80002eb6:	84aa                	mv	s1,a0
    80002eb8:	01050913          	addi	s2,a0,16
    80002ebc:	854a                	mv	a0,s2
    80002ebe:	00001097          	auipc	ra,0x1
    80002ec2:	c82080e7          	jalr	-894(ra) # 80003b40 <holdingsleep>
    80002ec6:	cd19                	beqz	a0,80002ee4 <iunlock+0x3c>
    80002ec8:	449c                	lw	a5,8(s1)
    80002eca:	00f05d63          	blez	a5,80002ee4 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002ece:	854a                	mv	a0,s2
    80002ed0:	00001097          	auipc	ra,0x1
    80002ed4:	c2c080e7          	jalr	-980(ra) # 80003afc <releasesleep>
}
    80002ed8:	60e2                	ld	ra,24(sp)
    80002eda:	6442                	ld	s0,16(sp)
    80002edc:	64a2                	ld	s1,8(sp)
    80002ede:	6902                	ld	s2,0(sp)
    80002ee0:	6105                	addi	sp,sp,32
    80002ee2:	8082                	ret
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
    80002ee4:	00005517          	auipc	a0,0x5
    80002ee8:	70450513          	addi	a0,a0,1796 # 800085e8 <syscalls+0x198>
    80002eec:	00003097          	auipc	ra,0x3
    80002ef0:	fc0080e7          	jalr	-64(ra) # 80005eac <panic>

0000000080002ef4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip) {
    80002ef4:	7179                	addi	sp,sp,-48
    80002ef6:	f406                	sd	ra,40(sp)
    80002ef8:	f022                	sd	s0,32(sp)
    80002efa:	ec26                	sd	s1,24(sp)
    80002efc:	e84a                	sd	s2,16(sp)
    80002efe:	e44e                	sd	s3,8(sp)
    80002f00:	e052                	sd	s4,0(sp)
    80002f02:	1800                	addi	s0,sp,48
    80002f04:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    80002f06:	05050493          	addi	s1,a0,80
    80002f0a:	08050913          	addi	s2,a0,128
    80002f0e:	a021                	j	80002f16 <itrunc+0x22>
    80002f10:	0491                	addi	s1,s1,4
    80002f12:	01248d63          	beq	s1,s2,80002f2c <itrunc+0x38>
    if (ip->addrs[i]) {
    80002f16:	408c                	lw	a1,0(s1)
    80002f18:	dde5                	beqz	a1,80002f10 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002f1a:	0009a503          	lw	a0,0(s3)
    80002f1e:	00000097          	auipc	ra,0x0
    80002f22:	8f6080e7          	jalr	-1802(ra) # 80002814 <bfree>
      ip->addrs[i] = 0;
    80002f26:	0004a023          	sw	zero,0(s1)
    80002f2a:	b7dd                	j	80002f10 <itrunc+0x1c>
    }
  }

  if (ip->addrs[NDIRECT]) {
    80002f2c:	0809a583          	lw	a1,128(s3)
    80002f30:	e185                	bnez	a1,80002f50 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002f32:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002f36:	854e                	mv	a0,s3
    80002f38:	00000097          	auipc	ra,0x0
    80002f3c:	de2080e7          	jalr	-542(ra) # 80002d1a <iupdate>
}
    80002f40:	70a2                	ld	ra,40(sp)
    80002f42:	7402                	ld	s0,32(sp)
    80002f44:	64e2                	ld	s1,24(sp)
    80002f46:	6942                	ld	s2,16(sp)
    80002f48:	69a2                	ld	s3,8(sp)
    80002f4a:	6a02                	ld	s4,0(sp)
    80002f4c:	6145                	addi	sp,sp,48
    80002f4e:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002f50:	0009a503          	lw	a0,0(s3)
    80002f54:	fffff097          	auipc	ra,0xfffff
    80002f58:	67a080e7          	jalr	1658(ra) # 800025ce <bread>
    80002f5c:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    80002f5e:	05850493          	addi	s1,a0,88
    80002f62:	45850913          	addi	s2,a0,1112
    80002f66:	a021                	j	80002f6e <itrunc+0x7a>
    80002f68:	0491                	addi	s1,s1,4
    80002f6a:	01248b63          	beq	s1,s2,80002f80 <itrunc+0x8c>
      if (a[j]) bfree(ip->dev, a[j]);
    80002f6e:	408c                	lw	a1,0(s1)
    80002f70:	dde5                	beqz	a1,80002f68 <itrunc+0x74>
    80002f72:	0009a503          	lw	a0,0(s3)
    80002f76:	00000097          	auipc	ra,0x0
    80002f7a:	89e080e7          	jalr	-1890(ra) # 80002814 <bfree>
    80002f7e:	b7ed                	j	80002f68 <itrunc+0x74>
    brelse(bp);
    80002f80:	8552                	mv	a0,s4
    80002f82:	fffff097          	auipc	ra,0xfffff
    80002f86:	77c080e7          	jalr	1916(ra) # 800026fe <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f8a:	0809a583          	lw	a1,128(s3)
    80002f8e:	0009a503          	lw	a0,0(s3)
    80002f92:	00000097          	auipc	ra,0x0
    80002f96:	882080e7          	jalr	-1918(ra) # 80002814 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f9a:	0809a023          	sw	zero,128(s3)
    80002f9e:	bf51                	j	80002f32 <itrunc+0x3e>

0000000080002fa0 <iput>:
void iput(struct inode *ip) {
    80002fa0:	1101                	addi	sp,sp,-32
    80002fa2:	ec06                	sd	ra,24(sp)
    80002fa4:	e822                	sd	s0,16(sp)
    80002fa6:	e426                	sd	s1,8(sp)
    80002fa8:	e04a                	sd	s2,0(sp)
    80002faa:	1000                	addi	s0,sp,32
    80002fac:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002fae:	00034517          	auipc	a0,0x34
    80002fb2:	f1250513          	addi	a0,a0,-238 # 80036ec0 <itable>
    80002fb6:	00003097          	auipc	ra,0x3
    80002fba:	42e080e7          	jalr	1070(ra) # 800063e4 <acquire>
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80002fbe:	4498                	lw	a4,8(s1)
    80002fc0:	4785                	li	a5,1
    80002fc2:	02f70363          	beq	a4,a5,80002fe8 <iput+0x48>
  ip->ref--;
    80002fc6:	449c                	lw	a5,8(s1)
    80002fc8:	37fd                	addiw	a5,a5,-1
    80002fca:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002fcc:	00034517          	auipc	a0,0x34
    80002fd0:	ef450513          	addi	a0,a0,-268 # 80036ec0 <itable>
    80002fd4:	00003097          	auipc	ra,0x3
    80002fd8:	4c4080e7          	jalr	1220(ra) # 80006498 <release>
}
    80002fdc:	60e2                	ld	ra,24(sp)
    80002fde:	6442                	ld	s0,16(sp)
    80002fe0:	64a2                	ld	s1,8(sp)
    80002fe2:	6902                	ld	s2,0(sp)
    80002fe4:	6105                	addi	sp,sp,32
    80002fe6:	8082                	ret
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80002fe8:	40bc                	lw	a5,64(s1)
    80002fea:	dff1                	beqz	a5,80002fc6 <iput+0x26>
    80002fec:	04a49783          	lh	a5,74(s1)
    80002ff0:	fbf9                	bnez	a5,80002fc6 <iput+0x26>
    acquiresleep(&ip->lock);
    80002ff2:	01048913          	addi	s2,s1,16
    80002ff6:	854a                	mv	a0,s2
    80002ff8:	00001097          	auipc	ra,0x1
    80002ffc:	aae080e7          	jalr	-1362(ra) # 80003aa6 <acquiresleep>
    release(&itable.lock);
    80003000:	00034517          	auipc	a0,0x34
    80003004:	ec050513          	addi	a0,a0,-320 # 80036ec0 <itable>
    80003008:	00003097          	auipc	ra,0x3
    8000300c:	490080e7          	jalr	1168(ra) # 80006498 <release>
    itrunc(ip);
    80003010:	8526                	mv	a0,s1
    80003012:	00000097          	auipc	ra,0x0
    80003016:	ee2080e7          	jalr	-286(ra) # 80002ef4 <itrunc>
    ip->type = 0;
    8000301a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000301e:	8526                	mv	a0,s1
    80003020:	00000097          	auipc	ra,0x0
    80003024:	cfa080e7          	jalr	-774(ra) # 80002d1a <iupdate>
    ip->valid = 0;
    80003028:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000302c:	854a                	mv	a0,s2
    8000302e:	00001097          	auipc	ra,0x1
    80003032:	ace080e7          	jalr	-1330(ra) # 80003afc <releasesleep>
    acquire(&itable.lock);
    80003036:	00034517          	auipc	a0,0x34
    8000303a:	e8a50513          	addi	a0,a0,-374 # 80036ec0 <itable>
    8000303e:	00003097          	auipc	ra,0x3
    80003042:	3a6080e7          	jalr	934(ra) # 800063e4 <acquire>
    80003046:	b741                	j	80002fc6 <iput+0x26>

0000000080003048 <iunlockput>:
void iunlockput(struct inode *ip) {
    80003048:	1101                	addi	sp,sp,-32
    8000304a:	ec06                	sd	ra,24(sp)
    8000304c:	e822                	sd	s0,16(sp)
    8000304e:	e426                	sd	s1,8(sp)
    80003050:	1000                	addi	s0,sp,32
    80003052:	84aa                	mv	s1,a0
  iunlock(ip);
    80003054:	00000097          	auipc	ra,0x0
    80003058:	e54080e7          	jalr	-428(ra) # 80002ea8 <iunlock>
  iput(ip);
    8000305c:	8526                	mv	a0,s1
    8000305e:	00000097          	auipc	ra,0x0
    80003062:	f42080e7          	jalr	-190(ra) # 80002fa0 <iput>
}
    80003066:	60e2                	ld	ra,24(sp)
    80003068:	6442                	ld	s0,16(sp)
    8000306a:	64a2                	ld	s1,8(sp)
    8000306c:	6105                	addi	sp,sp,32
    8000306e:	8082                	ret

0000000080003070 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st) {
    80003070:	1141                	addi	sp,sp,-16
    80003072:	e422                	sd	s0,8(sp)
    80003074:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003076:	411c                	lw	a5,0(a0)
    80003078:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000307a:	415c                	lw	a5,4(a0)
    8000307c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000307e:	04451783          	lh	a5,68(a0)
    80003082:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003086:	04a51783          	lh	a5,74(a0)
    8000308a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000308e:	04c56783          	lwu	a5,76(a0)
    80003092:	e99c                	sd	a5,16(a1)
}
    80003094:	6422                	ld	s0,8(sp)
    80003096:	0141                	addi	sp,sp,16
    80003098:	8082                	ret

000000008000309a <readi>:
// otherwise, dst is a kernel address.
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off) return 0;
    8000309a:	457c                	lw	a5,76(a0)
    8000309c:	0ed7e963          	bltu	a5,a3,8000318e <readi+0xf4>
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
    800030a0:	7159                	addi	sp,sp,-112
    800030a2:	f486                	sd	ra,104(sp)
    800030a4:	f0a2                	sd	s0,96(sp)
    800030a6:	eca6                	sd	s1,88(sp)
    800030a8:	e8ca                	sd	s2,80(sp)
    800030aa:	e4ce                	sd	s3,72(sp)
    800030ac:	e0d2                	sd	s4,64(sp)
    800030ae:	fc56                	sd	s5,56(sp)
    800030b0:	f85a                	sd	s6,48(sp)
    800030b2:	f45e                	sd	s7,40(sp)
    800030b4:	f062                	sd	s8,32(sp)
    800030b6:	ec66                	sd	s9,24(sp)
    800030b8:	e86a                	sd	s10,16(sp)
    800030ba:	e46e                	sd	s11,8(sp)
    800030bc:	1880                	addi	s0,sp,112
    800030be:	8b2a                	mv	s6,a0
    800030c0:	8bae                	mv	s7,a1
    800030c2:	8a32                	mv	s4,a2
    800030c4:	84b6                	mv	s1,a3
    800030c6:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off) return 0;
    800030c8:	9f35                	addw	a4,a4,a3
    800030ca:	4501                	li	a0,0
    800030cc:	0ad76063          	bltu	a4,a3,8000316c <readi+0xd2>
  if (off + n > ip->size) n = ip->size - off;
    800030d0:	00e7f463          	bgeu	a5,a4,800030d8 <readi+0x3e>
    800030d4:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    800030d8:	0a0a8963          	beqz	s5,8000318a <readi+0xf0>
    800030dc:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0) break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    800030de:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800030e2:	5c7d                	li	s8,-1
    800030e4:	a82d                	j	8000311e <readi+0x84>
    800030e6:	020d1d93          	slli	s11,s10,0x20
    800030ea:	020ddd93          	srli	s11,s11,0x20
    800030ee:	05890613          	addi	a2,s2,88
    800030f2:	86ee                	mv	a3,s11
    800030f4:	963a                	add	a2,a2,a4
    800030f6:	85d2                	mv	a1,s4
    800030f8:	855e                	mv	a0,s7
    800030fa:	fffff097          	auipc	ra,0xfffff
    800030fe:	ae2080e7          	jalr	-1310(ra) # 80001bdc <either_copyout>
    80003102:	05850d63          	beq	a0,s8,8000315c <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003106:	854a                	mv	a0,s2
    80003108:	fffff097          	auipc	ra,0xfffff
    8000310c:	5f6080e7          	jalr	1526(ra) # 800026fe <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003110:	013d09bb          	addw	s3,s10,s3
    80003114:	009d04bb          	addw	s1,s10,s1
    80003118:	9a6e                	add	s4,s4,s11
    8000311a:	0559f763          	bgeu	s3,s5,80003168 <readi+0xce>
    uint addr = bmap(ip, off / BSIZE);
    8000311e:	00a4d59b          	srliw	a1,s1,0xa
    80003122:	855a                	mv	a0,s6
    80003124:	00000097          	auipc	ra,0x0
    80003128:	89e080e7          	jalr	-1890(ra) # 800029c2 <bmap>
    8000312c:	0005059b          	sext.w	a1,a0
    if (addr == 0) break;
    80003130:	cd85                	beqz	a1,80003168 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003132:	000b2503          	lw	a0,0(s6)
    80003136:	fffff097          	auipc	ra,0xfffff
    8000313a:	498080e7          	jalr	1176(ra) # 800025ce <bread>
    8000313e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80003140:	3ff4f713          	andi	a4,s1,1023
    80003144:	40ec87bb          	subw	a5,s9,a4
    80003148:	413a86bb          	subw	a3,s5,s3
    8000314c:	8d3e                	mv	s10,a5
    8000314e:	2781                	sext.w	a5,a5
    80003150:	0006861b          	sext.w	a2,a3
    80003154:	f8f679e3          	bgeu	a2,a5,800030e6 <readi+0x4c>
    80003158:	8d36                	mv	s10,a3
    8000315a:	b771                	j	800030e6 <readi+0x4c>
      brelse(bp);
    8000315c:	854a                	mv	a0,s2
    8000315e:	fffff097          	auipc	ra,0xfffff
    80003162:	5a0080e7          	jalr	1440(ra) # 800026fe <brelse>
      tot = -1;
    80003166:	59fd                	li	s3,-1
  }
  return tot;
    80003168:	0009851b          	sext.w	a0,s3
}
    8000316c:	70a6                	ld	ra,104(sp)
    8000316e:	7406                	ld	s0,96(sp)
    80003170:	64e6                	ld	s1,88(sp)
    80003172:	6946                	ld	s2,80(sp)
    80003174:	69a6                	ld	s3,72(sp)
    80003176:	6a06                	ld	s4,64(sp)
    80003178:	7ae2                	ld	s5,56(sp)
    8000317a:	7b42                	ld	s6,48(sp)
    8000317c:	7ba2                	ld	s7,40(sp)
    8000317e:	7c02                	ld	s8,32(sp)
    80003180:	6ce2                	ld	s9,24(sp)
    80003182:	6d42                	ld	s10,16(sp)
    80003184:	6da2                	ld	s11,8(sp)
    80003186:	6165                	addi	sp,sp,112
    80003188:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    8000318a:	89d6                	mv	s3,s5
    8000318c:	bff1                	j	80003168 <readi+0xce>
  if (off > ip->size || off + n < off) return 0;
    8000318e:	4501                	li	a0,0
}
    80003190:	8082                	ret

0000000080003192 <writei>:
// there was an error of some kind.
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off) return -1;
    80003192:	457c                	lw	a5,76(a0)
    80003194:	10d7e863          	bltu	a5,a3,800032a4 <writei+0x112>
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
    80003198:	7159                	addi	sp,sp,-112
    8000319a:	f486                	sd	ra,104(sp)
    8000319c:	f0a2                	sd	s0,96(sp)
    8000319e:	eca6                	sd	s1,88(sp)
    800031a0:	e8ca                	sd	s2,80(sp)
    800031a2:	e4ce                	sd	s3,72(sp)
    800031a4:	e0d2                	sd	s4,64(sp)
    800031a6:	fc56                	sd	s5,56(sp)
    800031a8:	f85a                	sd	s6,48(sp)
    800031aa:	f45e                	sd	s7,40(sp)
    800031ac:	f062                	sd	s8,32(sp)
    800031ae:	ec66                	sd	s9,24(sp)
    800031b0:	e86a                	sd	s10,16(sp)
    800031b2:	e46e                	sd	s11,8(sp)
    800031b4:	1880                	addi	s0,sp,112
    800031b6:	8aaa                	mv	s5,a0
    800031b8:	8bae                	mv	s7,a1
    800031ba:	8a32                	mv	s4,a2
    800031bc:	8936                	mv	s2,a3
    800031be:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off) return -1;
    800031c0:	00e687bb          	addw	a5,a3,a4
    800031c4:	0ed7e263          	bltu	a5,a3,800032a8 <writei+0x116>
  if (off + n > MAXFILE * BSIZE) return -1;
    800031c8:	00043737          	lui	a4,0x43
    800031cc:	0ef76063          	bltu	a4,a5,800032ac <writei+0x11a>

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800031d0:	0c0b0863          	beqz	s6,800032a0 <writei+0x10e>
    800031d4:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0) break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    800031d6:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800031da:	5c7d                	li	s8,-1
    800031dc:	a091                	j	80003220 <writei+0x8e>
    800031de:	020d1d93          	slli	s11,s10,0x20
    800031e2:	020ddd93          	srli	s11,s11,0x20
    800031e6:	05848513          	addi	a0,s1,88
    800031ea:	86ee                	mv	a3,s11
    800031ec:	8652                	mv	a2,s4
    800031ee:	85de                	mv	a1,s7
    800031f0:	953a                	add	a0,a0,a4
    800031f2:	fffff097          	auipc	ra,0xfffff
    800031f6:	a40080e7          	jalr	-1472(ra) # 80001c32 <either_copyin>
    800031fa:	07850263          	beq	a0,s8,8000325e <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800031fe:	8526                	mv	a0,s1
    80003200:	00000097          	auipc	ra,0x0
    80003204:	788080e7          	jalr	1928(ra) # 80003988 <log_write>
    brelse(bp);
    80003208:	8526                	mv	a0,s1
    8000320a:	fffff097          	auipc	ra,0xfffff
    8000320e:	4f4080e7          	jalr	1268(ra) # 800026fe <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003212:	013d09bb          	addw	s3,s10,s3
    80003216:	012d093b          	addw	s2,s10,s2
    8000321a:	9a6e                	add	s4,s4,s11
    8000321c:	0569f663          	bgeu	s3,s6,80003268 <writei+0xd6>
    uint addr = bmap(ip, off / BSIZE);
    80003220:	00a9559b          	srliw	a1,s2,0xa
    80003224:	8556                	mv	a0,s5
    80003226:	fffff097          	auipc	ra,0xfffff
    8000322a:	79c080e7          	jalr	1948(ra) # 800029c2 <bmap>
    8000322e:	0005059b          	sext.w	a1,a0
    if (addr == 0) break;
    80003232:	c99d                	beqz	a1,80003268 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003234:	000aa503          	lw	a0,0(s5)
    80003238:	fffff097          	auipc	ra,0xfffff
    8000323c:	396080e7          	jalr	918(ra) # 800025ce <bread>
    80003240:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80003242:	3ff97713          	andi	a4,s2,1023
    80003246:	40ec87bb          	subw	a5,s9,a4
    8000324a:	413b06bb          	subw	a3,s6,s3
    8000324e:	8d3e                	mv	s10,a5
    80003250:	2781                	sext.w	a5,a5
    80003252:	0006861b          	sext.w	a2,a3
    80003256:	f8f674e3          	bgeu	a2,a5,800031de <writei+0x4c>
    8000325a:	8d36                	mv	s10,a3
    8000325c:	b749                	j	800031de <writei+0x4c>
      brelse(bp);
    8000325e:	8526                	mv	a0,s1
    80003260:	fffff097          	auipc	ra,0xfffff
    80003264:	49e080e7          	jalr	1182(ra) # 800026fe <brelse>
  }

  if (off > ip->size) ip->size = off;
    80003268:	04caa783          	lw	a5,76(s5)
    8000326c:	0127f463          	bgeu	a5,s2,80003274 <writei+0xe2>
    80003270:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003274:	8556                	mv	a0,s5
    80003276:	00000097          	auipc	ra,0x0
    8000327a:	aa4080e7          	jalr	-1372(ra) # 80002d1a <iupdate>

  return tot;
    8000327e:	0009851b          	sext.w	a0,s3
}
    80003282:	70a6                	ld	ra,104(sp)
    80003284:	7406                	ld	s0,96(sp)
    80003286:	64e6                	ld	s1,88(sp)
    80003288:	6946                	ld	s2,80(sp)
    8000328a:	69a6                	ld	s3,72(sp)
    8000328c:	6a06                	ld	s4,64(sp)
    8000328e:	7ae2                	ld	s5,56(sp)
    80003290:	7b42                	ld	s6,48(sp)
    80003292:	7ba2                	ld	s7,40(sp)
    80003294:	7c02                	ld	s8,32(sp)
    80003296:	6ce2                	ld	s9,24(sp)
    80003298:	6d42                	ld	s10,16(sp)
    8000329a:	6da2                	ld	s11,8(sp)
    8000329c:	6165                	addi	sp,sp,112
    8000329e:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800032a0:	89da                	mv	s3,s6
    800032a2:	bfc9                	j	80003274 <writei+0xe2>
  if (off > ip->size || off + n < off) return -1;
    800032a4:	557d                	li	a0,-1
}
    800032a6:	8082                	ret
  if (off > ip->size || off + n < off) return -1;
    800032a8:	557d                	li	a0,-1
    800032aa:	bfe1                	j	80003282 <writei+0xf0>
  if (off + n > MAXFILE * BSIZE) return -1;
    800032ac:	557d                	li	a0,-1
    800032ae:	bfd1                	j	80003282 <writei+0xf0>

00000000800032b0 <namecmp>:

// Directories

int namecmp(const char *s, const char *t) { return strncmp(s, t, DIRSIZ); }
    800032b0:	1141                	addi	sp,sp,-16
    800032b2:	e406                	sd	ra,8(sp)
    800032b4:	e022                	sd	s0,0(sp)
    800032b6:	0800                	addi	s0,sp,16
    800032b8:	4639                	li	a2,14
    800032ba:	ffffd097          	auipc	ra,0xffffd
    800032be:	032080e7          	jalr	50(ra) # 800002ec <strncmp>
    800032c2:	60a2                	ld	ra,8(sp)
    800032c4:	6402                	ld	s0,0(sp)
    800032c6:	0141                	addi	sp,sp,16
    800032c8:	8082                	ret

00000000800032ca <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *dirlookup(struct inode *dp, char *name, uint *poff) {
    800032ca:	7139                	addi	sp,sp,-64
    800032cc:	fc06                	sd	ra,56(sp)
    800032ce:	f822                	sd	s0,48(sp)
    800032d0:	f426                	sd	s1,40(sp)
    800032d2:	f04a                	sd	s2,32(sp)
    800032d4:	ec4e                	sd	s3,24(sp)
    800032d6:	e852                	sd	s4,16(sp)
    800032d8:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR) panic("dirlookup not DIR");
    800032da:	04451703          	lh	a4,68(a0)
    800032de:	4785                	li	a5,1
    800032e0:	00f71a63          	bne	a4,a5,800032f4 <dirlookup+0x2a>
    800032e4:	892a                	mv	s2,a0
    800032e6:	89ae                	mv	s3,a1
    800032e8:	8a32                	mv	s4,a2

  for (off = 0; off < dp->size; off += sizeof(de)) {
    800032ea:	457c                	lw	a5,76(a0)
    800032ec:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800032ee:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de)) {
    800032f0:	e79d                	bnez	a5,8000331e <dirlookup+0x54>
    800032f2:	a8a5                	j	8000336a <dirlookup+0xa0>
  if (dp->type != T_DIR) panic("dirlookup not DIR");
    800032f4:	00005517          	auipc	a0,0x5
    800032f8:	2fc50513          	addi	a0,a0,764 # 800085f0 <syscalls+0x1a0>
    800032fc:	00003097          	auipc	ra,0x3
    80003300:	bb0080e7          	jalr	-1104(ra) # 80005eac <panic>
      panic("dirlookup read");
    80003304:	00005517          	auipc	a0,0x5
    80003308:	30450513          	addi	a0,a0,772 # 80008608 <syscalls+0x1b8>
    8000330c:	00003097          	auipc	ra,0x3
    80003310:	ba0080e7          	jalr	-1120(ra) # 80005eac <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003314:	24c1                	addiw	s1,s1,16
    80003316:	04c92783          	lw	a5,76(s2)
    8000331a:	04f4f763          	bgeu	s1,a5,80003368 <dirlookup+0x9e>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000331e:	4741                	li	a4,16
    80003320:	86a6                	mv	a3,s1
    80003322:	fc040613          	addi	a2,s0,-64
    80003326:	4581                	li	a1,0
    80003328:	854a                	mv	a0,s2
    8000332a:	00000097          	auipc	ra,0x0
    8000332e:	d70080e7          	jalr	-656(ra) # 8000309a <readi>
    80003332:	47c1                	li	a5,16
    80003334:	fcf518e3          	bne	a0,a5,80003304 <dirlookup+0x3a>
    if (de.inum == 0) continue;
    80003338:	fc045783          	lhu	a5,-64(s0)
    8000333c:	dfe1                	beqz	a5,80003314 <dirlookup+0x4a>
    if (namecmp(name, de.name) == 0) {
    8000333e:	fc240593          	addi	a1,s0,-62
    80003342:	854e                	mv	a0,s3
    80003344:	00000097          	auipc	ra,0x0
    80003348:	f6c080e7          	jalr	-148(ra) # 800032b0 <namecmp>
    8000334c:	f561                	bnez	a0,80003314 <dirlookup+0x4a>
      if (poff) *poff = off;
    8000334e:	000a0463          	beqz	s4,80003356 <dirlookup+0x8c>
    80003352:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003356:	fc045583          	lhu	a1,-64(s0)
    8000335a:	00092503          	lw	a0,0(s2)
    8000335e:	fffff097          	auipc	ra,0xfffff
    80003362:	74e080e7          	jalr	1870(ra) # 80002aac <iget>
    80003366:	a011                	j	8000336a <dirlookup+0xa0>
  return 0;
    80003368:	4501                	li	a0,0
}
    8000336a:	70e2                	ld	ra,56(sp)
    8000336c:	7442                	ld	s0,48(sp)
    8000336e:	74a2                	ld	s1,40(sp)
    80003370:	7902                	ld	s2,32(sp)
    80003372:	69e2                	ld	s3,24(sp)
    80003374:	6a42                	ld	s4,16(sp)
    80003376:	6121                	addi	sp,sp,64
    80003378:	8082                	ret

000000008000337a <namex>:

// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *namex(char *path, int nameiparent, char *name) {
    8000337a:	711d                	addi	sp,sp,-96
    8000337c:	ec86                	sd	ra,88(sp)
    8000337e:	e8a2                	sd	s0,80(sp)
    80003380:	e4a6                	sd	s1,72(sp)
    80003382:	e0ca                	sd	s2,64(sp)
    80003384:	fc4e                	sd	s3,56(sp)
    80003386:	f852                	sd	s4,48(sp)
    80003388:	f456                	sd	s5,40(sp)
    8000338a:	f05a                	sd	s6,32(sp)
    8000338c:	ec5e                	sd	s7,24(sp)
    8000338e:	e862                	sd	s8,16(sp)
    80003390:	e466                	sd	s9,8(sp)
    80003392:	e06a                	sd	s10,0(sp)
    80003394:	1080                	addi	s0,sp,96
    80003396:	84aa                	mv	s1,a0
    80003398:	8b2e                	mv	s6,a1
    8000339a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    8000339c:	00054703          	lbu	a4,0(a0)
    800033a0:	02f00793          	li	a5,47
    800033a4:	02f70363          	beq	a4,a5,800033ca <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800033a8:	ffffe097          	auipc	ra,0xffffe
    800033ac:	d80080e7          	jalr	-640(ra) # 80001128 <myproc>
    800033b0:	15053503          	ld	a0,336(a0)
    800033b4:	00000097          	auipc	ra,0x0
    800033b8:	9f4080e7          	jalr	-1548(ra) # 80002da8 <idup>
    800033bc:	8a2a                	mv	s4,a0
  while (*path == '/') path++;
    800033be:	02f00913          	li	s2,47
  if (len >= DIRSIZ)
    800033c2:	4cb5                	li	s9,13
  len = path - s;
    800033c4:	4b81                	li	s7,0

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    800033c6:	4c05                	li	s8,1
    800033c8:	a87d                	j	80003486 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800033ca:	4585                	li	a1,1
    800033cc:	4505                	li	a0,1
    800033ce:	fffff097          	auipc	ra,0xfffff
    800033d2:	6de080e7          	jalr	1758(ra) # 80002aac <iget>
    800033d6:	8a2a                	mv	s4,a0
    800033d8:	b7dd                	j	800033be <namex+0x44>
      iunlockput(ip);
    800033da:	8552                	mv	a0,s4
    800033dc:	00000097          	auipc	ra,0x0
    800033e0:	c6c080e7          	jalr	-916(ra) # 80003048 <iunlockput>
      return 0;
    800033e4:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    800033e6:	8552                	mv	a0,s4
    800033e8:	60e6                	ld	ra,88(sp)
    800033ea:	6446                	ld	s0,80(sp)
    800033ec:	64a6                	ld	s1,72(sp)
    800033ee:	6906                	ld	s2,64(sp)
    800033f0:	79e2                	ld	s3,56(sp)
    800033f2:	7a42                	ld	s4,48(sp)
    800033f4:	7aa2                	ld	s5,40(sp)
    800033f6:	7b02                	ld	s6,32(sp)
    800033f8:	6be2                	ld	s7,24(sp)
    800033fa:	6c42                	ld	s8,16(sp)
    800033fc:	6ca2                	ld	s9,8(sp)
    800033fe:	6d02                	ld	s10,0(sp)
    80003400:	6125                	addi	sp,sp,96
    80003402:	8082                	ret
      iunlock(ip);
    80003404:	8552                	mv	a0,s4
    80003406:	00000097          	auipc	ra,0x0
    8000340a:	aa2080e7          	jalr	-1374(ra) # 80002ea8 <iunlock>
      return ip;
    8000340e:	bfe1                	j	800033e6 <namex+0x6c>
      iunlockput(ip);
    80003410:	8552                	mv	a0,s4
    80003412:	00000097          	auipc	ra,0x0
    80003416:	c36080e7          	jalr	-970(ra) # 80003048 <iunlockput>
      return 0;
    8000341a:	8a4e                	mv	s4,s3
    8000341c:	b7e9                	j	800033e6 <namex+0x6c>
  len = path - s;
    8000341e:	40998633          	sub	a2,s3,s1
    80003422:	00060d1b          	sext.w	s10,a2
  if (len >= DIRSIZ)
    80003426:	09acd863          	bge	s9,s10,800034b6 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    8000342a:	4639                	li	a2,14
    8000342c:	85a6                	mv	a1,s1
    8000342e:	8556                	mv	a0,s5
    80003430:	ffffd097          	auipc	ra,0xffffd
    80003434:	e48080e7          	jalr	-440(ra) # 80000278 <memmove>
    80003438:	84ce                	mv	s1,s3
  while (*path == '/') path++;
    8000343a:	0004c783          	lbu	a5,0(s1)
    8000343e:	01279763          	bne	a5,s2,8000344c <namex+0xd2>
    80003442:	0485                	addi	s1,s1,1
    80003444:	0004c783          	lbu	a5,0(s1)
    80003448:	ff278de3          	beq	a5,s2,80003442 <namex+0xc8>
    ilock(ip);
    8000344c:	8552                	mv	a0,s4
    8000344e:	00000097          	auipc	ra,0x0
    80003452:	998080e7          	jalr	-1640(ra) # 80002de6 <ilock>
    if (ip->type != T_DIR) {
    80003456:	044a1783          	lh	a5,68(s4)
    8000345a:	f98790e3          	bne	a5,s8,800033da <namex+0x60>
    if (nameiparent && *path == '\0') {
    8000345e:	000b0563          	beqz	s6,80003468 <namex+0xee>
    80003462:	0004c783          	lbu	a5,0(s1)
    80003466:	dfd9                	beqz	a5,80003404 <namex+0x8a>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    80003468:	865e                	mv	a2,s7
    8000346a:	85d6                	mv	a1,s5
    8000346c:	8552                	mv	a0,s4
    8000346e:	00000097          	auipc	ra,0x0
    80003472:	e5c080e7          	jalr	-420(ra) # 800032ca <dirlookup>
    80003476:	89aa                	mv	s3,a0
    80003478:	dd41                	beqz	a0,80003410 <namex+0x96>
    iunlockput(ip);
    8000347a:	8552                	mv	a0,s4
    8000347c:	00000097          	auipc	ra,0x0
    80003480:	bcc080e7          	jalr	-1076(ra) # 80003048 <iunlockput>
    ip = next;
    80003484:	8a4e                	mv	s4,s3
  while (*path == '/') path++;
    80003486:	0004c783          	lbu	a5,0(s1)
    8000348a:	01279763          	bne	a5,s2,80003498 <namex+0x11e>
    8000348e:	0485                	addi	s1,s1,1
    80003490:	0004c783          	lbu	a5,0(s1)
    80003494:	ff278de3          	beq	a5,s2,8000348e <namex+0x114>
  if (*path == 0) return 0;
    80003498:	cb9d                	beqz	a5,800034ce <namex+0x154>
  while (*path != '/' && *path != 0) path++;
    8000349a:	0004c783          	lbu	a5,0(s1)
    8000349e:	89a6                	mv	s3,s1
  len = path - s;
    800034a0:	8d5e                	mv	s10,s7
    800034a2:	865e                	mv	a2,s7
  while (*path != '/' && *path != 0) path++;
    800034a4:	01278963          	beq	a5,s2,800034b6 <namex+0x13c>
    800034a8:	dbbd                	beqz	a5,8000341e <namex+0xa4>
    800034aa:	0985                	addi	s3,s3,1
    800034ac:	0009c783          	lbu	a5,0(s3)
    800034b0:	ff279ce3          	bne	a5,s2,800034a8 <namex+0x12e>
    800034b4:	b7ad                	j	8000341e <namex+0xa4>
    memmove(name, s, len);
    800034b6:	2601                	sext.w	a2,a2
    800034b8:	85a6                	mv	a1,s1
    800034ba:	8556                	mv	a0,s5
    800034bc:	ffffd097          	auipc	ra,0xffffd
    800034c0:	dbc080e7          	jalr	-580(ra) # 80000278 <memmove>
    name[len] = 0;
    800034c4:	9d56                	add	s10,s10,s5
    800034c6:	000d0023          	sb	zero,0(s10)
    800034ca:	84ce                	mv	s1,s3
    800034cc:	b7bd                	j	8000343a <namex+0xc0>
  if (nameiparent) {
    800034ce:	f00b0ce3          	beqz	s6,800033e6 <namex+0x6c>
    iput(ip);
    800034d2:	8552                	mv	a0,s4
    800034d4:	00000097          	auipc	ra,0x0
    800034d8:	acc080e7          	jalr	-1332(ra) # 80002fa0 <iput>
    return 0;
    800034dc:	4a01                	li	s4,0
    800034de:	b721                	j	800033e6 <namex+0x6c>

00000000800034e0 <dirlink>:
int dirlink(struct inode *dp, char *name, uint inum) {
    800034e0:	7139                	addi	sp,sp,-64
    800034e2:	fc06                	sd	ra,56(sp)
    800034e4:	f822                	sd	s0,48(sp)
    800034e6:	f426                	sd	s1,40(sp)
    800034e8:	f04a                	sd	s2,32(sp)
    800034ea:	ec4e                	sd	s3,24(sp)
    800034ec:	e852                	sd	s4,16(sp)
    800034ee:	0080                	addi	s0,sp,64
    800034f0:	892a                	mv	s2,a0
    800034f2:	8a2e                	mv	s4,a1
    800034f4:	89b2                	mv	s3,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    800034f6:	4601                	li	a2,0
    800034f8:	00000097          	auipc	ra,0x0
    800034fc:	dd2080e7          	jalr	-558(ra) # 800032ca <dirlookup>
    80003500:	e93d                	bnez	a0,80003576 <dirlink+0x96>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003502:	04c92483          	lw	s1,76(s2)
    80003506:	c49d                	beqz	s1,80003534 <dirlink+0x54>
    80003508:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000350a:	4741                	li	a4,16
    8000350c:	86a6                	mv	a3,s1
    8000350e:	fc040613          	addi	a2,s0,-64
    80003512:	4581                	li	a1,0
    80003514:	854a                	mv	a0,s2
    80003516:	00000097          	auipc	ra,0x0
    8000351a:	b84080e7          	jalr	-1148(ra) # 8000309a <readi>
    8000351e:	47c1                	li	a5,16
    80003520:	06f51163          	bne	a0,a5,80003582 <dirlink+0xa2>
    if (de.inum == 0) break;
    80003524:	fc045783          	lhu	a5,-64(s0)
    80003528:	c791                	beqz	a5,80003534 <dirlink+0x54>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000352a:	24c1                	addiw	s1,s1,16
    8000352c:	04c92783          	lw	a5,76(s2)
    80003530:	fcf4ede3          	bltu	s1,a5,8000350a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003534:	4639                	li	a2,14
    80003536:	85d2                	mv	a1,s4
    80003538:	fc240513          	addi	a0,s0,-62
    8000353c:	ffffd097          	auipc	ra,0xffffd
    80003540:	dec080e7          	jalr	-532(ra) # 80000328 <strncpy>
  de.inum = inum;
    80003544:	fd341023          	sh	s3,-64(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de)) return -1;
    80003548:	4741                	li	a4,16
    8000354a:	86a6                	mv	a3,s1
    8000354c:	fc040613          	addi	a2,s0,-64
    80003550:	4581                	li	a1,0
    80003552:	854a                	mv	a0,s2
    80003554:	00000097          	auipc	ra,0x0
    80003558:	c3e080e7          	jalr	-962(ra) # 80003192 <writei>
    8000355c:	1541                	addi	a0,a0,-16
    8000355e:	00a03533          	snez	a0,a0
    80003562:	40a00533          	neg	a0,a0
}
    80003566:	70e2                	ld	ra,56(sp)
    80003568:	7442                	ld	s0,48(sp)
    8000356a:	74a2                	ld	s1,40(sp)
    8000356c:	7902                	ld	s2,32(sp)
    8000356e:	69e2                	ld	s3,24(sp)
    80003570:	6a42                	ld	s4,16(sp)
    80003572:	6121                	addi	sp,sp,64
    80003574:	8082                	ret
    iput(ip);
    80003576:	00000097          	auipc	ra,0x0
    8000357a:	a2a080e7          	jalr	-1494(ra) # 80002fa0 <iput>
    return -1;
    8000357e:	557d                	li	a0,-1
    80003580:	b7dd                	j	80003566 <dirlink+0x86>
      panic("dirlink read");
    80003582:	00005517          	auipc	a0,0x5
    80003586:	09650513          	addi	a0,a0,150 # 80008618 <syscalls+0x1c8>
    8000358a:	00003097          	auipc	ra,0x3
    8000358e:	922080e7          	jalr	-1758(ra) # 80005eac <panic>

0000000080003592 <namei>:

struct inode *namei(char *path) {
    80003592:	1101                	addi	sp,sp,-32
    80003594:	ec06                	sd	ra,24(sp)
    80003596:	e822                	sd	s0,16(sp)
    80003598:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000359a:	fe040613          	addi	a2,s0,-32
    8000359e:	4581                	li	a1,0
    800035a0:	00000097          	auipc	ra,0x0
    800035a4:	dda080e7          	jalr	-550(ra) # 8000337a <namex>
}
    800035a8:	60e2                	ld	ra,24(sp)
    800035aa:	6442                	ld	s0,16(sp)
    800035ac:	6105                	addi	sp,sp,32
    800035ae:	8082                	ret

00000000800035b0 <nameiparent>:

struct inode *nameiparent(char *path, char *name) {
    800035b0:	1141                	addi	sp,sp,-16
    800035b2:	e406                	sd	ra,8(sp)
    800035b4:	e022                	sd	s0,0(sp)
    800035b6:	0800                	addi	s0,sp,16
    800035b8:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800035ba:	4585                	li	a1,1
    800035bc:	00000097          	auipc	ra,0x0
    800035c0:	dbe080e7          	jalr	-578(ra) # 8000337a <namex>
}
    800035c4:	60a2                	ld	ra,8(sp)
    800035c6:	6402                	ld	s0,0(sp)
    800035c8:	0141                	addi	sp,sp,16
    800035ca:	8082                	ret

00000000800035cc <write_head>:
}

// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void write_head(void) {
    800035cc:	1101                	addi	sp,sp,-32
    800035ce:	ec06                	sd	ra,24(sp)
    800035d0:	e822                	sd	s0,16(sp)
    800035d2:	e426                	sd	s1,8(sp)
    800035d4:	e04a                	sd	s2,0(sp)
    800035d6:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800035d8:	00035917          	auipc	s2,0x35
    800035dc:	39090913          	addi	s2,s2,912 # 80038968 <log>
    800035e0:	01892583          	lw	a1,24(s2)
    800035e4:	02892503          	lw	a0,40(s2)
    800035e8:	fffff097          	auipc	ra,0xfffff
    800035ec:	fe6080e7          	jalr	-26(ra) # 800025ce <bread>
    800035f0:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    800035f2:	02c92683          	lw	a3,44(s2)
    800035f6:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800035f8:	02d05863          	blez	a3,80003628 <write_head+0x5c>
    800035fc:	00035797          	auipc	a5,0x35
    80003600:	39c78793          	addi	a5,a5,924 # 80038998 <log+0x30>
    80003604:	05c50713          	addi	a4,a0,92
    80003608:	36fd                	addiw	a3,a3,-1
    8000360a:	02069613          	slli	a2,a3,0x20
    8000360e:	01e65693          	srli	a3,a2,0x1e
    80003612:	00035617          	auipc	a2,0x35
    80003616:	38a60613          	addi	a2,a2,906 # 8003899c <log+0x34>
    8000361a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000361c:	4390                	lw	a2,0(a5)
    8000361e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003620:	0791                	addi	a5,a5,4
    80003622:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80003624:	fed79ce3          	bne	a5,a3,8000361c <write_head+0x50>
  }
  bwrite(buf);
    80003628:	8526                	mv	a0,s1
    8000362a:	fffff097          	auipc	ra,0xfffff
    8000362e:	096080e7          	jalr	150(ra) # 800026c0 <bwrite>
  brelse(buf);
    80003632:	8526                	mv	a0,s1
    80003634:	fffff097          	auipc	ra,0xfffff
    80003638:	0ca080e7          	jalr	202(ra) # 800026fe <brelse>
}
    8000363c:	60e2                	ld	ra,24(sp)
    8000363e:	6442                	ld	s0,16(sp)
    80003640:	64a2                	ld	s1,8(sp)
    80003642:	6902                	ld	s2,0(sp)
    80003644:	6105                	addi	sp,sp,32
    80003646:	8082                	ret

0000000080003648 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003648:	00035797          	auipc	a5,0x35
    8000364c:	34c7a783          	lw	a5,844(a5) # 80038994 <log+0x2c>
    80003650:	0af05d63          	blez	a5,8000370a <install_trans+0xc2>
static void install_trans(int recovering) {
    80003654:	7139                	addi	sp,sp,-64
    80003656:	fc06                	sd	ra,56(sp)
    80003658:	f822                	sd	s0,48(sp)
    8000365a:	f426                	sd	s1,40(sp)
    8000365c:	f04a                	sd	s2,32(sp)
    8000365e:	ec4e                	sd	s3,24(sp)
    80003660:	e852                	sd	s4,16(sp)
    80003662:	e456                	sd	s5,8(sp)
    80003664:	e05a                	sd	s6,0(sp)
    80003666:	0080                	addi	s0,sp,64
    80003668:	8b2a                	mv	s6,a0
    8000366a:	00035a97          	auipc	s5,0x35
    8000366e:	32ea8a93          	addi	s5,s5,814 # 80038998 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003672:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start + tail + 1);  // read log block
    80003674:	00035997          	auipc	s3,0x35
    80003678:	2f498993          	addi	s3,s3,756 # 80038968 <log>
    8000367c:	a00d                	j	8000369e <install_trans+0x56>
    brelse(lbuf);
    8000367e:	854a                	mv	a0,s2
    80003680:	fffff097          	auipc	ra,0xfffff
    80003684:	07e080e7          	jalr	126(ra) # 800026fe <brelse>
    brelse(dbuf);
    80003688:	8526                	mv	a0,s1
    8000368a:	fffff097          	auipc	ra,0xfffff
    8000368e:	074080e7          	jalr	116(ra) # 800026fe <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003692:	2a05                	addiw	s4,s4,1
    80003694:	0a91                	addi	s5,s5,4
    80003696:	02c9a783          	lw	a5,44(s3)
    8000369a:	04fa5e63          	bge	s4,a5,800036f6 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1);  // read log block
    8000369e:	0189a583          	lw	a1,24(s3)
    800036a2:	014585bb          	addw	a1,a1,s4
    800036a6:	2585                	addiw	a1,a1,1
    800036a8:	0289a503          	lw	a0,40(s3)
    800036ac:	fffff097          	auipc	ra,0xfffff
    800036b0:	f22080e7          	jalr	-222(ra) # 800025ce <bread>
    800036b4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);    // read dst
    800036b6:	000aa583          	lw	a1,0(s5)
    800036ba:	0289a503          	lw	a0,40(s3)
    800036be:	fffff097          	auipc	ra,0xfffff
    800036c2:	f10080e7          	jalr	-240(ra) # 800025ce <bread>
    800036c6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800036c8:	40000613          	li	a2,1024
    800036cc:	05890593          	addi	a1,s2,88
    800036d0:	05850513          	addi	a0,a0,88
    800036d4:	ffffd097          	auipc	ra,0xffffd
    800036d8:	ba4080e7          	jalr	-1116(ra) # 80000278 <memmove>
    bwrite(dbuf);                            // write dst to disk
    800036dc:	8526                	mv	a0,s1
    800036de:	fffff097          	auipc	ra,0xfffff
    800036e2:	fe2080e7          	jalr	-30(ra) # 800026c0 <bwrite>
    if (recovering == 0) bunpin(dbuf);
    800036e6:	f80b1ce3          	bnez	s6,8000367e <install_trans+0x36>
    800036ea:	8526                	mv	a0,s1
    800036ec:	fffff097          	auipc	ra,0xfffff
    800036f0:	0ec080e7          	jalr	236(ra) # 800027d8 <bunpin>
    800036f4:	b769                	j	8000367e <install_trans+0x36>
}
    800036f6:	70e2                	ld	ra,56(sp)
    800036f8:	7442                	ld	s0,48(sp)
    800036fa:	74a2                	ld	s1,40(sp)
    800036fc:	7902                	ld	s2,32(sp)
    800036fe:	69e2                	ld	s3,24(sp)
    80003700:	6a42                	ld	s4,16(sp)
    80003702:	6aa2                	ld	s5,8(sp)
    80003704:	6b02                	ld	s6,0(sp)
    80003706:	6121                	addi	sp,sp,64
    80003708:	8082                	ret
    8000370a:	8082                	ret

000000008000370c <initlog>:
void initlog(int dev, struct superblock *sb) {
    8000370c:	7179                	addi	sp,sp,-48
    8000370e:	f406                	sd	ra,40(sp)
    80003710:	f022                	sd	s0,32(sp)
    80003712:	ec26                	sd	s1,24(sp)
    80003714:	e84a                	sd	s2,16(sp)
    80003716:	e44e                	sd	s3,8(sp)
    80003718:	1800                	addi	s0,sp,48
    8000371a:	892a                	mv	s2,a0
    8000371c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000371e:	00035497          	auipc	s1,0x35
    80003722:	24a48493          	addi	s1,s1,586 # 80038968 <log>
    80003726:	00005597          	auipc	a1,0x5
    8000372a:	f0258593          	addi	a1,a1,-254 # 80008628 <syscalls+0x1d8>
    8000372e:	8526                	mv	a0,s1
    80003730:	00003097          	auipc	ra,0x3
    80003734:	c24080e7          	jalr	-988(ra) # 80006354 <initlock>
  log.start = sb->logstart;
    80003738:	0149a583          	lw	a1,20(s3)
    8000373c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000373e:	0109a783          	lw	a5,16(s3)
    80003742:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003744:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003748:	854a                	mv	a0,s2
    8000374a:	fffff097          	auipc	ra,0xfffff
    8000374e:	e84080e7          	jalr	-380(ra) # 800025ce <bread>
  log.lh.n = lh->n;
    80003752:	4d34                	lw	a3,88(a0)
    80003754:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003756:	02d05663          	blez	a3,80003782 <initlog+0x76>
    8000375a:	05c50793          	addi	a5,a0,92
    8000375e:	00035717          	auipc	a4,0x35
    80003762:	23a70713          	addi	a4,a4,570 # 80038998 <log+0x30>
    80003766:	36fd                	addiw	a3,a3,-1
    80003768:	02069613          	slli	a2,a3,0x20
    8000376c:	01e65693          	srli	a3,a2,0x1e
    80003770:	06050613          	addi	a2,a0,96
    80003774:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003776:	4390                	lw	a2,0(a5)
    80003778:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000377a:	0791                	addi	a5,a5,4
    8000377c:	0711                	addi	a4,a4,4
    8000377e:	fed79ce3          	bne	a5,a3,80003776 <initlog+0x6a>
  brelse(buf);
    80003782:	fffff097          	auipc	ra,0xfffff
    80003786:	f7c080e7          	jalr	-132(ra) # 800026fe <brelse>

static void recover_from_log(void) {
  read_head();
  install_trans(1);  // if committed, copy from log to disk
    8000378a:	4505                	li	a0,1
    8000378c:	00000097          	auipc	ra,0x0
    80003790:	ebc080e7          	jalr	-324(ra) # 80003648 <install_trans>
  log.lh.n = 0;
    80003794:	00035797          	auipc	a5,0x35
    80003798:	2007a023          	sw	zero,512(a5) # 80038994 <log+0x2c>
  write_head();  // clear the log
    8000379c:	00000097          	auipc	ra,0x0
    800037a0:	e30080e7          	jalr	-464(ra) # 800035cc <write_head>
}
    800037a4:	70a2                	ld	ra,40(sp)
    800037a6:	7402                	ld	s0,32(sp)
    800037a8:	64e2                	ld	s1,24(sp)
    800037aa:	6942                	ld	s2,16(sp)
    800037ac:	69a2                	ld	s3,8(sp)
    800037ae:	6145                	addi	sp,sp,48
    800037b0:	8082                	ret

00000000800037b2 <begin_op>:
}

// called at the start of each FS system call.
void begin_op(void) {
    800037b2:	1101                	addi	sp,sp,-32
    800037b4:	ec06                	sd	ra,24(sp)
    800037b6:	e822                	sd	s0,16(sp)
    800037b8:	e426                	sd	s1,8(sp)
    800037ba:	e04a                	sd	s2,0(sp)
    800037bc:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800037be:	00035517          	auipc	a0,0x35
    800037c2:	1aa50513          	addi	a0,a0,426 # 80038968 <log>
    800037c6:	00003097          	auipc	ra,0x3
    800037ca:	c1e080e7          	jalr	-994(ra) # 800063e4 <acquire>
  while (1) {
    if (log.committing) {
    800037ce:	00035497          	auipc	s1,0x35
    800037d2:	19a48493          	addi	s1,s1,410 # 80038968 <log>
      sleep(&log, &log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    800037d6:	4979                	li	s2,30
    800037d8:	a039                	j	800037e6 <begin_op+0x34>
      sleep(&log, &log.lock);
    800037da:	85a6                	mv	a1,s1
    800037dc:	8526                	mv	a0,s1
    800037de:	ffffe097          	auipc	ra,0xffffe
    800037e2:	ff6080e7          	jalr	-10(ra) # 800017d4 <sleep>
    if (log.committing) {
    800037e6:	50dc                	lw	a5,36(s1)
    800037e8:	fbed                	bnez	a5,800037da <begin_op+0x28>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    800037ea:	5098                	lw	a4,32(s1)
    800037ec:	2705                	addiw	a4,a4,1
    800037ee:	0007069b          	sext.w	a3,a4
    800037f2:	0027179b          	slliw	a5,a4,0x2
    800037f6:	9fb9                	addw	a5,a5,a4
    800037f8:	0017979b          	slliw	a5,a5,0x1
    800037fc:	54d8                	lw	a4,44(s1)
    800037fe:	9fb9                	addw	a5,a5,a4
    80003800:	00f95963          	bge	s2,a5,80003812 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003804:	85a6                	mv	a1,s1
    80003806:	8526                	mv	a0,s1
    80003808:	ffffe097          	auipc	ra,0xffffe
    8000380c:	fcc080e7          	jalr	-52(ra) # 800017d4 <sleep>
    80003810:	bfd9                	j	800037e6 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003812:	00035517          	auipc	a0,0x35
    80003816:	15650513          	addi	a0,a0,342 # 80038968 <log>
    8000381a:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000381c:	00003097          	auipc	ra,0x3
    80003820:	c7c080e7          	jalr	-900(ra) # 80006498 <release>
      break;
    }
  }
}
    80003824:	60e2                	ld	ra,24(sp)
    80003826:	6442                	ld	s0,16(sp)
    80003828:	64a2                	ld	s1,8(sp)
    8000382a:	6902                	ld	s2,0(sp)
    8000382c:	6105                	addi	sp,sp,32
    8000382e:	8082                	ret

0000000080003830 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void end_op(void) {
    80003830:	7139                	addi	sp,sp,-64
    80003832:	fc06                	sd	ra,56(sp)
    80003834:	f822                	sd	s0,48(sp)
    80003836:	f426                	sd	s1,40(sp)
    80003838:	f04a                	sd	s2,32(sp)
    8000383a:	ec4e                	sd	s3,24(sp)
    8000383c:	e852                	sd	s4,16(sp)
    8000383e:	e456                	sd	s5,8(sp)
    80003840:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003842:	00035497          	auipc	s1,0x35
    80003846:	12648493          	addi	s1,s1,294 # 80038968 <log>
    8000384a:	8526                	mv	a0,s1
    8000384c:	00003097          	auipc	ra,0x3
    80003850:	b98080e7          	jalr	-1128(ra) # 800063e4 <acquire>
  log.outstanding -= 1;
    80003854:	509c                	lw	a5,32(s1)
    80003856:	37fd                	addiw	a5,a5,-1
    80003858:	0007891b          	sext.w	s2,a5
    8000385c:	d09c                	sw	a5,32(s1)
  if (log.committing) panic("log.committing");
    8000385e:	50dc                	lw	a5,36(s1)
    80003860:	e7b9                	bnez	a5,800038ae <end_op+0x7e>
  if (log.outstanding == 0) {
    80003862:	04091e63          	bnez	s2,800038be <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003866:	00035497          	auipc	s1,0x35
    8000386a:	10248493          	addi	s1,s1,258 # 80038968 <log>
    8000386e:	4785                	li	a5,1
    80003870:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003872:	8526                	mv	a0,s1
    80003874:	00003097          	auipc	ra,0x3
    80003878:	c24080e7          	jalr	-988(ra) # 80006498 <release>
    brelse(to);
  }
}

static void commit() {
  if (log.lh.n > 0) {
    8000387c:	54dc                	lw	a5,44(s1)
    8000387e:	06f04763          	bgtz	a5,800038ec <end_op+0xbc>
    acquire(&log.lock);
    80003882:	00035497          	auipc	s1,0x35
    80003886:	0e648493          	addi	s1,s1,230 # 80038968 <log>
    8000388a:	8526                	mv	a0,s1
    8000388c:	00003097          	auipc	ra,0x3
    80003890:	b58080e7          	jalr	-1192(ra) # 800063e4 <acquire>
    log.committing = 0;
    80003894:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003898:	8526                	mv	a0,s1
    8000389a:	ffffe097          	auipc	ra,0xffffe
    8000389e:	f9e080e7          	jalr	-98(ra) # 80001838 <wakeup>
    release(&log.lock);
    800038a2:	8526                	mv	a0,s1
    800038a4:	00003097          	auipc	ra,0x3
    800038a8:	bf4080e7          	jalr	-1036(ra) # 80006498 <release>
}
    800038ac:	a03d                	j	800038da <end_op+0xaa>
  if (log.committing) panic("log.committing");
    800038ae:	00005517          	auipc	a0,0x5
    800038b2:	d8250513          	addi	a0,a0,-638 # 80008630 <syscalls+0x1e0>
    800038b6:	00002097          	auipc	ra,0x2
    800038ba:	5f6080e7          	jalr	1526(ra) # 80005eac <panic>
    wakeup(&log);
    800038be:	00035497          	auipc	s1,0x35
    800038c2:	0aa48493          	addi	s1,s1,170 # 80038968 <log>
    800038c6:	8526                	mv	a0,s1
    800038c8:	ffffe097          	auipc	ra,0xffffe
    800038cc:	f70080e7          	jalr	-144(ra) # 80001838 <wakeup>
  release(&log.lock);
    800038d0:	8526                	mv	a0,s1
    800038d2:	00003097          	auipc	ra,0x3
    800038d6:	bc6080e7          	jalr	-1082(ra) # 80006498 <release>
}
    800038da:	70e2                	ld	ra,56(sp)
    800038dc:	7442                	ld	s0,48(sp)
    800038de:	74a2                	ld	s1,40(sp)
    800038e0:	7902                	ld	s2,32(sp)
    800038e2:	69e2                	ld	s3,24(sp)
    800038e4:	6a42                	ld	s4,16(sp)
    800038e6:	6aa2                	ld	s5,8(sp)
    800038e8:	6121                	addi	sp,sp,64
    800038ea:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800038ec:	00035a97          	auipc	s5,0x35
    800038f0:	0aca8a93          	addi	s5,s5,172 # 80038998 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1);  // log block
    800038f4:	00035a17          	auipc	s4,0x35
    800038f8:	074a0a13          	addi	s4,s4,116 # 80038968 <log>
    800038fc:	018a2583          	lw	a1,24(s4)
    80003900:	012585bb          	addw	a1,a1,s2
    80003904:	2585                	addiw	a1,a1,1
    80003906:	028a2503          	lw	a0,40(s4)
    8000390a:	fffff097          	auipc	ra,0xfffff
    8000390e:	cc4080e7          	jalr	-828(ra) # 800025ce <bread>
    80003912:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]);  // cache block
    80003914:	000aa583          	lw	a1,0(s5)
    80003918:	028a2503          	lw	a0,40(s4)
    8000391c:	fffff097          	auipc	ra,0xfffff
    80003920:	cb2080e7          	jalr	-846(ra) # 800025ce <bread>
    80003924:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003926:	40000613          	li	a2,1024
    8000392a:	05850593          	addi	a1,a0,88
    8000392e:	05848513          	addi	a0,s1,88
    80003932:	ffffd097          	auipc	ra,0xffffd
    80003936:	946080e7          	jalr	-1722(ra) # 80000278 <memmove>
    bwrite(to);  // write the log
    8000393a:	8526                	mv	a0,s1
    8000393c:	fffff097          	auipc	ra,0xfffff
    80003940:	d84080e7          	jalr	-636(ra) # 800026c0 <bwrite>
    brelse(from);
    80003944:	854e                	mv	a0,s3
    80003946:	fffff097          	auipc	ra,0xfffff
    8000394a:	db8080e7          	jalr	-584(ra) # 800026fe <brelse>
    brelse(to);
    8000394e:	8526                	mv	a0,s1
    80003950:	fffff097          	auipc	ra,0xfffff
    80003954:	dae080e7          	jalr	-594(ra) # 800026fe <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003958:	2905                	addiw	s2,s2,1
    8000395a:	0a91                	addi	s5,s5,4
    8000395c:	02ca2783          	lw	a5,44(s4)
    80003960:	f8f94ee3          	blt	s2,a5,800038fc <end_op+0xcc>
    write_log();       // Write modified blocks from cache to log
    write_head();      // Write header to disk -- the real commit
    80003964:	00000097          	auipc	ra,0x0
    80003968:	c68080e7          	jalr	-920(ra) # 800035cc <write_head>
    install_trans(0);  // Now install writes to home locations
    8000396c:	4501                	li	a0,0
    8000396e:	00000097          	auipc	ra,0x0
    80003972:	cda080e7          	jalr	-806(ra) # 80003648 <install_trans>
    log.lh.n = 0;
    80003976:	00035797          	auipc	a5,0x35
    8000397a:	0007af23          	sw	zero,30(a5) # 80038994 <log+0x2c>
    write_head();  // Erase the transaction from the log
    8000397e:	00000097          	auipc	ra,0x0
    80003982:	c4e080e7          	jalr	-946(ra) # 800035cc <write_head>
    80003986:	bdf5                	j	80003882 <end_op+0x52>

0000000080003988 <log_write>:
// log_write() replaces bwrite(); a typical use is:
//   bp = bread(...)
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void log_write(struct buf *b) {
    80003988:	1101                	addi	sp,sp,-32
    8000398a:	ec06                	sd	ra,24(sp)
    8000398c:	e822                	sd	s0,16(sp)
    8000398e:	e426                	sd	s1,8(sp)
    80003990:	e04a                	sd	s2,0(sp)
    80003992:	1000                	addi	s0,sp,32
    80003994:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003996:	00035917          	auipc	s2,0x35
    8000399a:	fd290913          	addi	s2,s2,-46 # 80038968 <log>
    8000399e:	854a                	mv	a0,s2
    800039a0:	00003097          	auipc	ra,0x3
    800039a4:	a44080e7          	jalr	-1468(ra) # 800063e4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800039a8:	02c92603          	lw	a2,44(s2)
    800039ac:	47f5                	li	a5,29
    800039ae:	06c7c563          	blt	a5,a2,80003a18 <log_write+0x90>
    800039b2:	00035797          	auipc	a5,0x35
    800039b6:	fd27a783          	lw	a5,-46(a5) # 80038984 <log+0x1c>
    800039ba:	37fd                	addiw	a5,a5,-1
    800039bc:	04f65e63          	bge	a2,a5,80003a18 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1) panic("log_write outside of trans");
    800039c0:	00035797          	auipc	a5,0x35
    800039c4:	fc87a783          	lw	a5,-56(a5) # 80038988 <log+0x20>
    800039c8:	06f05063          	blez	a5,80003a28 <log_write+0xa0>

  for (i = 0; i < log.lh.n; i++) {
    800039cc:	4781                	li	a5,0
    800039ce:	06c05563          	blez	a2,80003a38 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)  // log absorption
    800039d2:	44cc                	lw	a1,12(s1)
    800039d4:	00035717          	auipc	a4,0x35
    800039d8:	fc470713          	addi	a4,a4,-60 # 80038998 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800039dc:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)  // log absorption
    800039de:	4314                	lw	a3,0(a4)
    800039e0:	04b68c63          	beq	a3,a1,80003a38 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800039e4:	2785                	addiw	a5,a5,1
    800039e6:	0711                	addi	a4,a4,4
    800039e8:	fef61be3          	bne	a2,a5,800039de <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800039ec:	0621                	addi	a2,a2,8
    800039ee:	060a                	slli	a2,a2,0x2
    800039f0:	00035797          	auipc	a5,0x35
    800039f4:	f7878793          	addi	a5,a5,-136 # 80038968 <log>
    800039f8:	97b2                	add	a5,a5,a2
    800039fa:	44d8                	lw	a4,12(s1)
    800039fc:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800039fe:	8526                	mv	a0,s1
    80003a00:	fffff097          	auipc	ra,0xfffff
    80003a04:	d9c080e7          	jalr	-612(ra) # 8000279c <bpin>
    log.lh.n++;
    80003a08:	00035717          	auipc	a4,0x35
    80003a0c:	f6070713          	addi	a4,a4,-160 # 80038968 <log>
    80003a10:	575c                	lw	a5,44(a4)
    80003a12:	2785                	addiw	a5,a5,1
    80003a14:	d75c                	sw	a5,44(a4)
    80003a16:	a82d                	j	80003a50 <log_write+0xc8>
    panic("too big a transaction");
    80003a18:	00005517          	auipc	a0,0x5
    80003a1c:	c2850513          	addi	a0,a0,-984 # 80008640 <syscalls+0x1f0>
    80003a20:	00002097          	auipc	ra,0x2
    80003a24:	48c080e7          	jalr	1164(ra) # 80005eac <panic>
  if (log.outstanding < 1) panic("log_write outside of trans");
    80003a28:	00005517          	auipc	a0,0x5
    80003a2c:	c3050513          	addi	a0,a0,-976 # 80008658 <syscalls+0x208>
    80003a30:	00002097          	auipc	ra,0x2
    80003a34:	47c080e7          	jalr	1148(ra) # 80005eac <panic>
  log.lh.block[i] = b->blockno;
    80003a38:	00878693          	addi	a3,a5,8
    80003a3c:	068a                	slli	a3,a3,0x2
    80003a3e:	00035717          	auipc	a4,0x35
    80003a42:	f2a70713          	addi	a4,a4,-214 # 80038968 <log>
    80003a46:	9736                	add	a4,a4,a3
    80003a48:	44d4                	lw	a3,12(s1)
    80003a4a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003a4c:	faf609e3          	beq	a2,a5,800039fe <log_write+0x76>
  }
  release(&log.lock);
    80003a50:	00035517          	auipc	a0,0x35
    80003a54:	f1850513          	addi	a0,a0,-232 # 80038968 <log>
    80003a58:	00003097          	auipc	ra,0x3
    80003a5c:	a40080e7          	jalr	-1472(ra) # 80006498 <release>
}
    80003a60:	60e2                	ld	ra,24(sp)
    80003a62:	6442                	ld	s0,16(sp)
    80003a64:	64a2                	ld	s1,8(sp)
    80003a66:	6902                	ld	s2,0(sp)
    80003a68:	6105                	addi	sp,sp,32
    80003a6a:	8082                	ret

0000000080003a6c <initsleeplock>:
#include "sleeplock.h"

#include "defs.h"
#include "proc.h"

void initsleeplock(struct sleeplock *lk, char *name) {
    80003a6c:	1101                	addi	sp,sp,-32
    80003a6e:	ec06                	sd	ra,24(sp)
    80003a70:	e822                	sd	s0,16(sp)
    80003a72:	e426                	sd	s1,8(sp)
    80003a74:	e04a                	sd	s2,0(sp)
    80003a76:	1000                	addi	s0,sp,32
    80003a78:	84aa                	mv	s1,a0
    80003a7a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a7c:	00005597          	auipc	a1,0x5
    80003a80:	bfc58593          	addi	a1,a1,-1028 # 80008678 <syscalls+0x228>
    80003a84:	0521                	addi	a0,a0,8
    80003a86:	00003097          	auipc	ra,0x3
    80003a8a:	8ce080e7          	jalr	-1842(ra) # 80006354 <initlock>
  lk->name = name;
    80003a8e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003a92:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a96:	0204a423          	sw	zero,40(s1)
}
    80003a9a:	60e2                	ld	ra,24(sp)
    80003a9c:	6442                	ld	s0,16(sp)
    80003a9e:	64a2                	ld	s1,8(sp)
    80003aa0:	6902                	ld	s2,0(sp)
    80003aa2:	6105                	addi	sp,sp,32
    80003aa4:	8082                	ret

0000000080003aa6 <acquiresleep>:

void acquiresleep(struct sleeplock *lk) {
    80003aa6:	1101                	addi	sp,sp,-32
    80003aa8:	ec06                	sd	ra,24(sp)
    80003aaa:	e822                	sd	s0,16(sp)
    80003aac:	e426                	sd	s1,8(sp)
    80003aae:	e04a                	sd	s2,0(sp)
    80003ab0:	1000                	addi	s0,sp,32
    80003ab2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003ab4:	00850913          	addi	s2,a0,8
    80003ab8:	854a                	mv	a0,s2
    80003aba:	00003097          	auipc	ra,0x3
    80003abe:	92a080e7          	jalr	-1750(ra) # 800063e4 <acquire>
  while (lk->locked) {
    80003ac2:	409c                	lw	a5,0(s1)
    80003ac4:	cb89                	beqz	a5,80003ad6 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003ac6:	85ca                	mv	a1,s2
    80003ac8:	8526                	mv	a0,s1
    80003aca:	ffffe097          	auipc	ra,0xffffe
    80003ace:	d0a080e7          	jalr	-758(ra) # 800017d4 <sleep>
  while (lk->locked) {
    80003ad2:	409c                	lw	a5,0(s1)
    80003ad4:	fbed                	bnez	a5,80003ac6 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003ad6:	4785                	li	a5,1
    80003ad8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003ada:	ffffd097          	auipc	ra,0xffffd
    80003ade:	64e080e7          	jalr	1614(ra) # 80001128 <myproc>
    80003ae2:	591c                	lw	a5,48(a0)
    80003ae4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003ae6:	854a                	mv	a0,s2
    80003ae8:	00003097          	auipc	ra,0x3
    80003aec:	9b0080e7          	jalr	-1616(ra) # 80006498 <release>
}
    80003af0:	60e2                	ld	ra,24(sp)
    80003af2:	6442                	ld	s0,16(sp)
    80003af4:	64a2                	ld	s1,8(sp)
    80003af6:	6902                	ld	s2,0(sp)
    80003af8:	6105                	addi	sp,sp,32
    80003afa:	8082                	ret

0000000080003afc <releasesleep>:

void releasesleep(struct sleeplock *lk) {
    80003afc:	1101                	addi	sp,sp,-32
    80003afe:	ec06                	sd	ra,24(sp)
    80003b00:	e822                	sd	s0,16(sp)
    80003b02:	e426                	sd	s1,8(sp)
    80003b04:	e04a                	sd	s2,0(sp)
    80003b06:	1000                	addi	s0,sp,32
    80003b08:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b0a:	00850913          	addi	s2,a0,8
    80003b0e:	854a                	mv	a0,s2
    80003b10:	00003097          	auipc	ra,0x3
    80003b14:	8d4080e7          	jalr	-1836(ra) # 800063e4 <acquire>
  lk->locked = 0;
    80003b18:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b1c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003b20:	8526                	mv	a0,s1
    80003b22:	ffffe097          	auipc	ra,0xffffe
    80003b26:	d16080e7          	jalr	-746(ra) # 80001838 <wakeup>
  release(&lk->lk);
    80003b2a:	854a                	mv	a0,s2
    80003b2c:	00003097          	auipc	ra,0x3
    80003b30:	96c080e7          	jalr	-1684(ra) # 80006498 <release>
}
    80003b34:	60e2                	ld	ra,24(sp)
    80003b36:	6442                	ld	s0,16(sp)
    80003b38:	64a2                	ld	s1,8(sp)
    80003b3a:	6902                	ld	s2,0(sp)
    80003b3c:	6105                	addi	sp,sp,32
    80003b3e:	8082                	ret

0000000080003b40 <holdingsleep>:

int holdingsleep(struct sleeplock *lk) {
    80003b40:	7179                	addi	sp,sp,-48
    80003b42:	f406                	sd	ra,40(sp)
    80003b44:	f022                	sd	s0,32(sp)
    80003b46:	ec26                	sd	s1,24(sp)
    80003b48:	e84a                	sd	s2,16(sp)
    80003b4a:	e44e                	sd	s3,8(sp)
    80003b4c:	1800                	addi	s0,sp,48
    80003b4e:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    80003b50:	00850913          	addi	s2,a0,8
    80003b54:	854a                	mv	a0,s2
    80003b56:	00003097          	auipc	ra,0x3
    80003b5a:	88e080e7          	jalr	-1906(ra) # 800063e4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b5e:	409c                	lw	a5,0(s1)
    80003b60:	ef99                	bnez	a5,80003b7e <holdingsleep+0x3e>
    80003b62:	4481                	li	s1,0
  release(&lk->lk);
    80003b64:	854a                	mv	a0,s2
    80003b66:	00003097          	auipc	ra,0x3
    80003b6a:	932080e7          	jalr	-1742(ra) # 80006498 <release>
  return r;
}
    80003b6e:	8526                	mv	a0,s1
    80003b70:	70a2                	ld	ra,40(sp)
    80003b72:	7402                	ld	s0,32(sp)
    80003b74:	64e2                	ld	s1,24(sp)
    80003b76:	6942                	ld	s2,16(sp)
    80003b78:	69a2                	ld	s3,8(sp)
    80003b7a:	6145                	addi	sp,sp,48
    80003b7c:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b7e:	0284a983          	lw	s3,40(s1)
    80003b82:	ffffd097          	auipc	ra,0xffffd
    80003b86:	5a6080e7          	jalr	1446(ra) # 80001128 <myproc>
    80003b8a:	5904                	lw	s1,48(a0)
    80003b8c:	413484b3          	sub	s1,s1,s3
    80003b90:	0014b493          	seqz	s1,s1
    80003b94:	bfc1                	j	80003b64 <holdingsleep+0x24>

0000000080003b96 <fileinit>:
struct {
  struct spinlock lock;
  struct file file[NFILE];
} ftable;

void fileinit(void) { initlock(&ftable.lock, "ftable"); }
    80003b96:	1141                	addi	sp,sp,-16
    80003b98:	e406                	sd	ra,8(sp)
    80003b9a:	e022                	sd	s0,0(sp)
    80003b9c:	0800                	addi	s0,sp,16
    80003b9e:	00005597          	auipc	a1,0x5
    80003ba2:	aea58593          	addi	a1,a1,-1302 # 80008688 <syscalls+0x238>
    80003ba6:	00035517          	auipc	a0,0x35
    80003baa:	f0a50513          	addi	a0,a0,-246 # 80038ab0 <ftable>
    80003bae:	00002097          	auipc	ra,0x2
    80003bb2:	7a6080e7          	jalr	1958(ra) # 80006354 <initlock>
    80003bb6:	60a2                	ld	ra,8(sp)
    80003bb8:	6402                	ld	s0,0(sp)
    80003bba:	0141                	addi	sp,sp,16
    80003bbc:	8082                	ret

0000000080003bbe <filealloc>:

// Allocate a file structure.
struct file *filealloc(void) {
    80003bbe:	1101                	addi	sp,sp,-32
    80003bc0:	ec06                	sd	ra,24(sp)
    80003bc2:	e822                	sd	s0,16(sp)
    80003bc4:	e426                	sd	s1,8(sp)
    80003bc6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003bc8:	00035517          	auipc	a0,0x35
    80003bcc:	ee850513          	addi	a0,a0,-280 # 80038ab0 <ftable>
    80003bd0:	00003097          	auipc	ra,0x3
    80003bd4:	814080e7          	jalr	-2028(ra) # 800063e4 <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80003bd8:	00035497          	auipc	s1,0x35
    80003bdc:	ef048493          	addi	s1,s1,-272 # 80038ac8 <ftable+0x18>
    80003be0:	00036717          	auipc	a4,0x36
    80003be4:	e8870713          	addi	a4,a4,-376 # 80039a68 <disk>
    if (f->ref == 0) {
    80003be8:	40dc                	lw	a5,4(s1)
    80003bea:	cf99                	beqz	a5,80003c08 <filealloc+0x4a>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80003bec:	02848493          	addi	s1,s1,40
    80003bf0:	fee49ce3          	bne	s1,a4,80003be8 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003bf4:	00035517          	auipc	a0,0x35
    80003bf8:	ebc50513          	addi	a0,a0,-324 # 80038ab0 <ftable>
    80003bfc:	00003097          	auipc	ra,0x3
    80003c00:	89c080e7          	jalr	-1892(ra) # 80006498 <release>
  return 0;
    80003c04:	4481                	li	s1,0
    80003c06:	a819                	j	80003c1c <filealloc+0x5e>
      f->ref = 1;
    80003c08:	4785                	li	a5,1
    80003c0a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003c0c:	00035517          	auipc	a0,0x35
    80003c10:	ea450513          	addi	a0,a0,-348 # 80038ab0 <ftable>
    80003c14:	00003097          	auipc	ra,0x3
    80003c18:	884080e7          	jalr	-1916(ra) # 80006498 <release>
}
    80003c1c:	8526                	mv	a0,s1
    80003c1e:	60e2                	ld	ra,24(sp)
    80003c20:	6442                	ld	s0,16(sp)
    80003c22:	64a2                	ld	s1,8(sp)
    80003c24:	6105                	addi	sp,sp,32
    80003c26:	8082                	ret

0000000080003c28 <filedup>:

// Increment ref count for file f.
struct file *filedup(struct file *f) {
    80003c28:	1101                	addi	sp,sp,-32
    80003c2a:	ec06                	sd	ra,24(sp)
    80003c2c:	e822                	sd	s0,16(sp)
    80003c2e:	e426                	sd	s1,8(sp)
    80003c30:	1000                	addi	s0,sp,32
    80003c32:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003c34:	00035517          	auipc	a0,0x35
    80003c38:	e7c50513          	addi	a0,a0,-388 # 80038ab0 <ftable>
    80003c3c:	00002097          	auipc	ra,0x2
    80003c40:	7a8080e7          	jalr	1960(ra) # 800063e4 <acquire>
  if (f->ref < 1) panic("filedup");
    80003c44:	40dc                	lw	a5,4(s1)
    80003c46:	02f05263          	blez	a5,80003c6a <filedup+0x42>
  f->ref++;
    80003c4a:	2785                	addiw	a5,a5,1
    80003c4c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003c4e:	00035517          	auipc	a0,0x35
    80003c52:	e6250513          	addi	a0,a0,-414 # 80038ab0 <ftable>
    80003c56:	00003097          	auipc	ra,0x3
    80003c5a:	842080e7          	jalr	-1982(ra) # 80006498 <release>
  return f;
}
    80003c5e:	8526                	mv	a0,s1
    80003c60:	60e2                	ld	ra,24(sp)
    80003c62:	6442                	ld	s0,16(sp)
    80003c64:	64a2                	ld	s1,8(sp)
    80003c66:	6105                	addi	sp,sp,32
    80003c68:	8082                	ret
  if (f->ref < 1) panic("filedup");
    80003c6a:	00005517          	auipc	a0,0x5
    80003c6e:	a2650513          	addi	a0,a0,-1498 # 80008690 <syscalls+0x240>
    80003c72:	00002097          	auipc	ra,0x2
    80003c76:	23a080e7          	jalr	570(ra) # 80005eac <panic>

0000000080003c7a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f) {
    80003c7a:	7139                	addi	sp,sp,-64
    80003c7c:	fc06                	sd	ra,56(sp)
    80003c7e:	f822                	sd	s0,48(sp)
    80003c80:	f426                	sd	s1,40(sp)
    80003c82:	f04a                	sd	s2,32(sp)
    80003c84:	ec4e                	sd	s3,24(sp)
    80003c86:	e852                	sd	s4,16(sp)
    80003c88:	e456                	sd	s5,8(sp)
    80003c8a:	0080                	addi	s0,sp,64
    80003c8c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c8e:	00035517          	auipc	a0,0x35
    80003c92:	e2250513          	addi	a0,a0,-478 # 80038ab0 <ftable>
    80003c96:	00002097          	auipc	ra,0x2
    80003c9a:	74e080e7          	jalr	1870(ra) # 800063e4 <acquire>
  if (f->ref < 1) panic("fileclose");
    80003c9e:	40dc                	lw	a5,4(s1)
    80003ca0:	06f05163          	blez	a5,80003d02 <fileclose+0x88>
  if (--f->ref > 0) {
    80003ca4:	37fd                	addiw	a5,a5,-1
    80003ca6:	0007871b          	sext.w	a4,a5
    80003caa:	c0dc                	sw	a5,4(s1)
    80003cac:	06e04363          	bgtz	a4,80003d12 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003cb0:	0004a903          	lw	s2,0(s1)
    80003cb4:	0094ca83          	lbu	s5,9(s1)
    80003cb8:	0104ba03          	ld	s4,16(s1)
    80003cbc:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003cc0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003cc4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003cc8:	00035517          	auipc	a0,0x35
    80003ccc:	de850513          	addi	a0,a0,-536 # 80038ab0 <ftable>
    80003cd0:	00002097          	auipc	ra,0x2
    80003cd4:	7c8080e7          	jalr	1992(ra) # 80006498 <release>

  if (ff.type == FD_PIPE) {
    80003cd8:	4785                	li	a5,1
    80003cda:	04f90d63          	beq	s2,a5,80003d34 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    80003cde:	3979                	addiw	s2,s2,-2
    80003ce0:	4785                	li	a5,1
    80003ce2:	0527e063          	bltu	a5,s2,80003d22 <fileclose+0xa8>
    begin_op();
    80003ce6:	00000097          	auipc	ra,0x0
    80003cea:	acc080e7          	jalr	-1332(ra) # 800037b2 <begin_op>
    iput(ff.ip);
    80003cee:	854e                	mv	a0,s3
    80003cf0:	fffff097          	auipc	ra,0xfffff
    80003cf4:	2b0080e7          	jalr	688(ra) # 80002fa0 <iput>
    end_op();
    80003cf8:	00000097          	auipc	ra,0x0
    80003cfc:	b38080e7          	jalr	-1224(ra) # 80003830 <end_op>
    80003d00:	a00d                	j	80003d22 <fileclose+0xa8>
  if (f->ref < 1) panic("fileclose");
    80003d02:	00005517          	auipc	a0,0x5
    80003d06:	99650513          	addi	a0,a0,-1642 # 80008698 <syscalls+0x248>
    80003d0a:	00002097          	auipc	ra,0x2
    80003d0e:	1a2080e7          	jalr	418(ra) # 80005eac <panic>
    release(&ftable.lock);
    80003d12:	00035517          	auipc	a0,0x35
    80003d16:	d9e50513          	addi	a0,a0,-610 # 80038ab0 <ftable>
    80003d1a:	00002097          	auipc	ra,0x2
    80003d1e:	77e080e7          	jalr	1918(ra) # 80006498 <release>
  }
}
    80003d22:	70e2                	ld	ra,56(sp)
    80003d24:	7442                	ld	s0,48(sp)
    80003d26:	74a2                	ld	s1,40(sp)
    80003d28:	7902                	ld	s2,32(sp)
    80003d2a:	69e2                	ld	s3,24(sp)
    80003d2c:	6a42                	ld	s4,16(sp)
    80003d2e:	6aa2                	ld	s5,8(sp)
    80003d30:	6121                	addi	sp,sp,64
    80003d32:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003d34:	85d6                	mv	a1,s5
    80003d36:	8552                	mv	a0,s4
    80003d38:	00000097          	auipc	ra,0x0
    80003d3c:	34c080e7          	jalr	844(ra) # 80004084 <pipeclose>
    80003d40:	b7cd                	j	80003d22 <fileclose+0xa8>

0000000080003d42 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int filestat(struct file *f, uint64 addr) {
    80003d42:	715d                	addi	sp,sp,-80
    80003d44:	e486                	sd	ra,72(sp)
    80003d46:	e0a2                	sd	s0,64(sp)
    80003d48:	fc26                	sd	s1,56(sp)
    80003d4a:	f84a                	sd	s2,48(sp)
    80003d4c:	f44e                	sd	s3,40(sp)
    80003d4e:	0880                	addi	s0,sp,80
    80003d50:	84aa                	mv	s1,a0
    80003d52:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003d54:	ffffd097          	auipc	ra,0xffffd
    80003d58:	3d4080e7          	jalr	980(ra) # 80001128 <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    80003d5c:	409c                	lw	a5,0(s1)
    80003d5e:	37f9                	addiw	a5,a5,-2
    80003d60:	4705                	li	a4,1
    80003d62:	04f76763          	bltu	a4,a5,80003db0 <filestat+0x6e>
    80003d66:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d68:	6c88                	ld	a0,24(s1)
    80003d6a:	fffff097          	auipc	ra,0xfffff
    80003d6e:	07c080e7          	jalr	124(ra) # 80002de6 <ilock>
    stati(f->ip, &st);
    80003d72:	fb840593          	addi	a1,s0,-72
    80003d76:	6c88                	ld	a0,24(s1)
    80003d78:	fffff097          	auipc	ra,0xfffff
    80003d7c:	2f8080e7          	jalr	760(ra) # 80003070 <stati>
    iunlock(f->ip);
    80003d80:	6c88                	ld	a0,24(s1)
    80003d82:	fffff097          	auipc	ra,0xfffff
    80003d86:	126080e7          	jalr	294(ra) # 80002ea8 <iunlock>
    if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0) return -1;
    80003d8a:	46e1                	li	a3,24
    80003d8c:	fb840613          	addi	a2,s0,-72
    80003d90:	85ce                	mv	a1,s3
    80003d92:	05093503          	ld	a0,80(s2)
    80003d96:	ffffd097          	auipc	ra,0xffffd
    80003d9a:	160080e7          	jalr	352(ra) # 80000ef6 <copyout>
    80003d9e:	41f5551b          	sraiw	a0,a0,0x1f
    return 0;
  }
  return -1;
}
    80003da2:	60a6                	ld	ra,72(sp)
    80003da4:	6406                	ld	s0,64(sp)
    80003da6:	74e2                	ld	s1,56(sp)
    80003da8:	7942                	ld	s2,48(sp)
    80003daa:	79a2                	ld	s3,40(sp)
    80003dac:	6161                	addi	sp,sp,80
    80003dae:	8082                	ret
  return -1;
    80003db0:	557d                	li	a0,-1
    80003db2:	bfc5                	j	80003da2 <filestat+0x60>

0000000080003db4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int fileread(struct file *f, uint64 addr, int n) {
    80003db4:	7179                	addi	sp,sp,-48
    80003db6:	f406                	sd	ra,40(sp)
    80003db8:	f022                	sd	s0,32(sp)
    80003dba:	ec26                	sd	s1,24(sp)
    80003dbc:	e84a                	sd	s2,16(sp)
    80003dbe:	e44e                	sd	s3,8(sp)
    80003dc0:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0) return -1;
    80003dc2:	00854783          	lbu	a5,8(a0)
    80003dc6:	c3d5                	beqz	a5,80003e6a <fileread+0xb6>
    80003dc8:	84aa                	mv	s1,a0
    80003dca:	89ae                	mv	s3,a1
    80003dcc:	8932                	mv	s2,a2

  if (f->type == FD_PIPE) {
    80003dce:	411c                	lw	a5,0(a0)
    80003dd0:	4705                	li	a4,1
    80003dd2:	04e78963          	beq	a5,a4,80003e24 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80003dd6:	470d                	li	a4,3
    80003dd8:	04e78d63          	beq	a5,a4,80003e32 <fileread+0x7e>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    80003ddc:	4709                	li	a4,2
    80003dde:	06e79e63          	bne	a5,a4,80003e5a <fileread+0xa6>
    ilock(f->ip);
    80003de2:	6d08                	ld	a0,24(a0)
    80003de4:	fffff097          	auipc	ra,0xfffff
    80003de8:	002080e7          	jalr	2(ra) # 80002de6 <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0) f->off += r;
    80003dec:	874a                	mv	a4,s2
    80003dee:	5094                	lw	a3,32(s1)
    80003df0:	864e                	mv	a2,s3
    80003df2:	4585                	li	a1,1
    80003df4:	6c88                	ld	a0,24(s1)
    80003df6:	fffff097          	auipc	ra,0xfffff
    80003dfa:	2a4080e7          	jalr	676(ra) # 8000309a <readi>
    80003dfe:	892a                	mv	s2,a0
    80003e00:	00a05563          	blez	a0,80003e0a <fileread+0x56>
    80003e04:	509c                	lw	a5,32(s1)
    80003e06:	9fa9                	addw	a5,a5,a0
    80003e08:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003e0a:	6c88                	ld	a0,24(s1)
    80003e0c:	fffff097          	auipc	ra,0xfffff
    80003e10:	09c080e7          	jalr	156(ra) # 80002ea8 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003e14:	854a                	mv	a0,s2
    80003e16:	70a2                	ld	ra,40(sp)
    80003e18:	7402                	ld	s0,32(sp)
    80003e1a:	64e2                	ld	s1,24(sp)
    80003e1c:	6942                	ld	s2,16(sp)
    80003e1e:	69a2                	ld	s3,8(sp)
    80003e20:	6145                	addi	sp,sp,48
    80003e22:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003e24:	6908                	ld	a0,16(a0)
    80003e26:	00000097          	auipc	ra,0x0
    80003e2a:	3c6080e7          	jalr	966(ra) # 800041ec <piperead>
    80003e2e:	892a                	mv	s2,a0
    80003e30:	b7d5                	j	80003e14 <fileread+0x60>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    80003e32:	02451783          	lh	a5,36(a0)
    80003e36:	03079693          	slli	a3,a5,0x30
    80003e3a:	92c1                	srli	a3,a3,0x30
    80003e3c:	4725                	li	a4,9
    80003e3e:	02d76863          	bltu	a4,a3,80003e6e <fileread+0xba>
    80003e42:	0792                	slli	a5,a5,0x4
    80003e44:	00035717          	auipc	a4,0x35
    80003e48:	bcc70713          	addi	a4,a4,-1076 # 80038a10 <devsw>
    80003e4c:	97ba                	add	a5,a5,a4
    80003e4e:	639c                	ld	a5,0(a5)
    80003e50:	c38d                	beqz	a5,80003e72 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003e52:	4505                	li	a0,1
    80003e54:	9782                	jalr	a5
    80003e56:	892a                	mv	s2,a0
    80003e58:	bf75                	j	80003e14 <fileread+0x60>
    panic("fileread");
    80003e5a:	00005517          	auipc	a0,0x5
    80003e5e:	84e50513          	addi	a0,a0,-1970 # 800086a8 <syscalls+0x258>
    80003e62:	00002097          	auipc	ra,0x2
    80003e66:	04a080e7          	jalr	74(ra) # 80005eac <panic>
  if (f->readable == 0) return -1;
    80003e6a:	597d                	li	s2,-1
    80003e6c:	b765                	j	80003e14 <fileread+0x60>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    80003e6e:	597d                	li	s2,-1
    80003e70:	b755                	j	80003e14 <fileread+0x60>
    80003e72:	597d                	li	s2,-1
    80003e74:	b745                	j	80003e14 <fileread+0x60>

0000000080003e76 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int filewrite(struct file *f, uint64 addr, int n) {
    80003e76:	715d                	addi	sp,sp,-80
    80003e78:	e486                	sd	ra,72(sp)
    80003e7a:	e0a2                	sd	s0,64(sp)
    80003e7c:	fc26                	sd	s1,56(sp)
    80003e7e:	f84a                	sd	s2,48(sp)
    80003e80:	f44e                	sd	s3,40(sp)
    80003e82:	f052                	sd	s4,32(sp)
    80003e84:	ec56                	sd	s5,24(sp)
    80003e86:	e85a                	sd	s6,16(sp)
    80003e88:	e45e                	sd	s7,8(sp)
    80003e8a:	e062                	sd	s8,0(sp)
    80003e8c:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if (f->writable == 0) return -1;
    80003e8e:	00954783          	lbu	a5,9(a0)
    80003e92:	10078663          	beqz	a5,80003f9e <filewrite+0x128>
    80003e96:	892a                	mv	s2,a0
    80003e98:	8b2e                	mv	s6,a1
    80003e9a:	8a32                	mv	s4,a2

  if (f->type == FD_PIPE) {
    80003e9c:	411c                	lw	a5,0(a0)
    80003e9e:	4705                	li	a4,1
    80003ea0:	02e78263          	beq	a5,a4,80003ec4 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80003ea4:	470d                	li	a4,3
    80003ea6:	02e78663          	beq	a5,a4,80003ed2 <filewrite+0x5c>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    80003eaa:	4709                	li	a4,2
    80003eac:	0ee79163          	bne	a5,a4,80003f8e <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    80003eb0:	0ac05d63          	blez	a2,80003f6a <filewrite+0xf4>
    int i = 0;
    80003eb4:	4981                	li	s3,0
    80003eb6:	6b85                	lui	s7,0x1
    80003eb8:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003ebc:	6c05                	lui	s8,0x1
    80003ebe:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003ec2:	a861                	j	80003f5a <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003ec4:	6908                	ld	a0,16(a0)
    80003ec6:	00000097          	auipc	ra,0x0
    80003eca:	22e080e7          	jalr	558(ra) # 800040f4 <pipewrite>
    80003ece:	8a2a                	mv	s4,a0
    80003ed0:	a045                	j	80003f70 <filewrite+0xfa>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    80003ed2:	02451783          	lh	a5,36(a0)
    80003ed6:	03079693          	slli	a3,a5,0x30
    80003eda:	92c1                	srli	a3,a3,0x30
    80003edc:	4725                	li	a4,9
    80003ede:	0cd76263          	bltu	a4,a3,80003fa2 <filewrite+0x12c>
    80003ee2:	0792                	slli	a5,a5,0x4
    80003ee4:	00035717          	auipc	a4,0x35
    80003ee8:	b2c70713          	addi	a4,a4,-1236 # 80038a10 <devsw>
    80003eec:	97ba                	add	a5,a5,a4
    80003eee:	679c                	ld	a5,8(a5)
    80003ef0:	cbdd                	beqz	a5,80003fa6 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003ef2:	4505                	li	a0,1
    80003ef4:	9782                	jalr	a5
    80003ef6:	8a2a                	mv	s4,a0
    80003ef8:	a8a5                	j	80003f70 <filewrite+0xfa>
    80003efa:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if (n1 > max) n1 = max;

      begin_op();
    80003efe:	00000097          	auipc	ra,0x0
    80003f02:	8b4080e7          	jalr	-1868(ra) # 800037b2 <begin_op>
      ilock(f->ip);
    80003f06:	01893503          	ld	a0,24(s2)
    80003f0a:	fffff097          	auipc	ra,0xfffff
    80003f0e:	edc080e7          	jalr	-292(ra) # 80002de6 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0) f->off += r;
    80003f12:	8756                	mv	a4,s5
    80003f14:	02092683          	lw	a3,32(s2)
    80003f18:	01698633          	add	a2,s3,s6
    80003f1c:	4585                	li	a1,1
    80003f1e:	01893503          	ld	a0,24(s2)
    80003f22:	fffff097          	auipc	ra,0xfffff
    80003f26:	270080e7          	jalr	624(ra) # 80003192 <writei>
    80003f2a:	84aa                	mv	s1,a0
    80003f2c:	00a05763          	blez	a0,80003f3a <filewrite+0xc4>
    80003f30:	02092783          	lw	a5,32(s2)
    80003f34:	9fa9                	addw	a5,a5,a0
    80003f36:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003f3a:	01893503          	ld	a0,24(s2)
    80003f3e:	fffff097          	auipc	ra,0xfffff
    80003f42:	f6a080e7          	jalr	-150(ra) # 80002ea8 <iunlock>
      end_op();
    80003f46:	00000097          	auipc	ra,0x0
    80003f4a:	8ea080e7          	jalr	-1814(ra) # 80003830 <end_op>

      if (r != n1) {
    80003f4e:	009a9f63          	bne	s5,s1,80003f6c <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003f52:	013489bb          	addw	s3,s1,s3
    while (i < n) {
    80003f56:	0149db63          	bge	s3,s4,80003f6c <filewrite+0xf6>
      int n1 = n - i;
    80003f5a:	413a04bb          	subw	s1,s4,s3
    80003f5e:	0004879b          	sext.w	a5,s1
    80003f62:	f8fbdce3          	bge	s7,a5,80003efa <filewrite+0x84>
    80003f66:	84e2                	mv	s1,s8
    80003f68:	bf49                	j	80003efa <filewrite+0x84>
    int i = 0;
    80003f6a:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003f6c:	013a1f63          	bne	s4,s3,80003f8a <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f70:	8552                	mv	a0,s4
    80003f72:	60a6                	ld	ra,72(sp)
    80003f74:	6406                	ld	s0,64(sp)
    80003f76:	74e2                	ld	s1,56(sp)
    80003f78:	7942                	ld	s2,48(sp)
    80003f7a:	79a2                	ld	s3,40(sp)
    80003f7c:	7a02                	ld	s4,32(sp)
    80003f7e:	6ae2                	ld	s5,24(sp)
    80003f80:	6b42                	ld	s6,16(sp)
    80003f82:	6ba2                	ld	s7,8(sp)
    80003f84:	6c02                	ld	s8,0(sp)
    80003f86:	6161                	addi	sp,sp,80
    80003f88:	8082                	ret
    ret = (i == n ? n : -1);
    80003f8a:	5a7d                	li	s4,-1
    80003f8c:	b7d5                	j	80003f70 <filewrite+0xfa>
    panic("filewrite");
    80003f8e:	00004517          	auipc	a0,0x4
    80003f92:	72a50513          	addi	a0,a0,1834 # 800086b8 <syscalls+0x268>
    80003f96:	00002097          	auipc	ra,0x2
    80003f9a:	f16080e7          	jalr	-234(ra) # 80005eac <panic>
  if (f->writable == 0) return -1;
    80003f9e:	5a7d                	li	s4,-1
    80003fa0:	bfc1                	j	80003f70 <filewrite+0xfa>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    80003fa2:	5a7d                	li	s4,-1
    80003fa4:	b7f1                	j	80003f70 <filewrite+0xfa>
    80003fa6:	5a7d                	li	s4,-1
    80003fa8:	b7e1                	j	80003f70 <filewrite+0xfa>

0000000080003faa <pipealloc>:
  uint nwrite;    // number of bytes written
  int readopen;   // read fd is still open
  int writeopen;  // write fd is still open
};

int pipealloc(struct file **f0, struct file **f1) {
    80003faa:	7179                	addi	sp,sp,-48
    80003fac:	f406                	sd	ra,40(sp)
    80003fae:	f022                	sd	s0,32(sp)
    80003fb0:	ec26                	sd	s1,24(sp)
    80003fb2:	e84a                	sd	s2,16(sp)
    80003fb4:	e44e                	sd	s3,8(sp)
    80003fb6:	e052                	sd	s4,0(sp)
    80003fb8:	1800                	addi	s0,sp,48
    80003fba:	84aa                	mv	s1,a0
    80003fbc:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003fbe:	0005b023          	sd	zero,0(a1)
    80003fc2:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0) goto bad;
    80003fc6:	00000097          	auipc	ra,0x0
    80003fca:	bf8080e7          	jalr	-1032(ra) # 80003bbe <filealloc>
    80003fce:	e088                	sd	a0,0(s1)
    80003fd0:	c551                	beqz	a0,8000405c <pipealloc+0xb2>
    80003fd2:	00000097          	auipc	ra,0x0
    80003fd6:	bec080e7          	jalr	-1044(ra) # 80003bbe <filealloc>
    80003fda:	00aa3023          	sd	a0,0(s4)
    80003fde:	c92d                	beqz	a0,80004050 <pipealloc+0xa6>
  if ((pi = (struct pipe *)kalloc()) == 0) goto bad;
    80003fe0:	ffffc097          	auipc	ra,0xffffc
    80003fe4:	1c2080e7          	jalr	450(ra) # 800001a2 <kalloc>
    80003fe8:	892a                	mv	s2,a0
    80003fea:	c125                	beqz	a0,8000404a <pipealloc+0xa0>
  pi->readopen = 1;
    80003fec:	4985                	li	s3,1
    80003fee:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003ff2:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003ff6:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003ffa:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003ffe:	00004597          	auipc	a1,0x4
    80004002:	6ca58593          	addi	a1,a1,1738 # 800086c8 <syscalls+0x278>
    80004006:	00002097          	auipc	ra,0x2
    8000400a:	34e080e7          	jalr	846(ra) # 80006354 <initlock>
  (*f0)->type = FD_PIPE;
    8000400e:	609c                	ld	a5,0(s1)
    80004010:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004014:	609c                	ld	a5,0(s1)
    80004016:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000401a:	609c                	ld	a5,0(s1)
    8000401c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004020:	609c                	ld	a5,0(s1)
    80004022:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004026:	000a3783          	ld	a5,0(s4)
    8000402a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000402e:	000a3783          	ld	a5,0(s4)
    80004032:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004036:	000a3783          	ld	a5,0(s4)
    8000403a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000403e:	000a3783          	ld	a5,0(s4)
    80004042:	0127b823          	sd	s2,16(a5)
  return 0;
    80004046:	4501                	li	a0,0
    80004048:	a025                	j	80004070 <pipealloc+0xc6>

bad:
  if (pi) kfree((char *)pi);
  if (*f0) fileclose(*f0);
    8000404a:	6088                	ld	a0,0(s1)
    8000404c:	e501                	bnez	a0,80004054 <pipealloc+0xaa>
    8000404e:	a039                	j	8000405c <pipealloc+0xb2>
    80004050:	6088                	ld	a0,0(s1)
    80004052:	c51d                	beqz	a0,80004080 <pipealloc+0xd6>
    80004054:	00000097          	auipc	ra,0x0
    80004058:	c26080e7          	jalr	-986(ra) # 80003c7a <fileclose>
  if (*f1) fileclose(*f1);
    8000405c:	000a3783          	ld	a5,0(s4)
  return -1;
    80004060:	557d                	li	a0,-1
  if (*f1) fileclose(*f1);
    80004062:	c799                	beqz	a5,80004070 <pipealloc+0xc6>
    80004064:	853e                	mv	a0,a5
    80004066:	00000097          	auipc	ra,0x0
    8000406a:	c14080e7          	jalr	-1004(ra) # 80003c7a <fileclose>
  return -1;
    8000406e:	557d                	li	a0,-1
}
    80004070:	70a2                	ld	ra,40(sp)
    80004072:	7402                	ld	s0,32(sp)
    80004074:	64e2                	ld	s1,24(sp)
    80004076:	6942                	ld	s2,16(sp)
    80004078:	69a2                	ld	s3,8(sp)
    8000407a:	6a02                	ld	s4,0(sp)
    8000407c:	6145                	addi	sp,sp,48
    8000407e:	8082                	ret
  return -1;
    80004080:	557d                	li	a0,-1
    80004082:	b7fd                	j	80004070 <pipealloc+0xc6>

0000000080004084 <pipeclose>:

void pipeclose(struct pipe *pi, int writable) {
    80004084:	1101                	addi	sp,sp,-32
    80004086:	ec06                	sd	ra,24(sp)
    80004088:	e822                	sd	s0,16(sp)
    8000408a:	e426                	sd	s1,8(sp)
    8000408c:	e04a                	sd	s2,0(sp)
    8000408e:	1000                	addi	s0,sp,32
    80004090:	84aa                	mv	s1,a0
    80004092:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004094:	00002097          	auipc	ra,0x2
    80004098:	350080e7          	jalr	848(ra) # 800063e4 <acquire>
  if (writable) {
    8000409c:	02090d63          	beqz	s2,800040d6 <pipeclose+0x52>
    pi->writeopen = 0;
    800040a0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800040a4:	21848513          	addi	a0,s1,536
    800040a8:	ffffd097          	auipc	ra,0xffffd
    800040ac:	790080e7          	jalr	1936(ra) # 80001838 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    800040b0:	2204b783          	ld	a5,544(s1)
    800040b4:	eb95                	bnez	a5,800040e8 <pipeclose+0x64>
    release(&pi->lock);
    800040b6:	8526                	mv	a0,s1
    800040b8:	00002097          	auipc	ra,0x2
    800040bc:	3e0080e7          	jalr	992(ra) # 80006498 <release>
    kfree((char *)pi);
    800040c0:	8526                	mv	a0,s1
    800040c2:	ffffc097          	auipc	ra,0xffffc
    800040c6:	fac080e7          	jalr	-84(ra) # 8000006e <kfree>
  } else
    release(&pi->lock);
}
    800040ca:	60e2                	ld	ra,24(sp)
    800040cc:	6442                	ld	s0,16(sp)
    800040ce:	64a2                	ld	s1,8(sp)
    800040d0:	6902                	ld	s2,0(sp)
    800040d2:	6105                	addi	sp,sp,32
    800040d4:	8082                	ret
    pi->readopen = 0;
    800040d6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800040da:	21c48513          	addi	a0,s1,540
    800040de:	ffffd097          	auipc	ra,0xffffd
    800040e2:	75a080e7          	jalr	1882(ra) # 80001838 <wakeup>
    800040e6:	b7e9                	j	800040b0 <pipeclose+0x2c>
    release(&pi->lock);
    800040e8:	8526                	mv	a0,s1
    800040ea:	00002097          	auipc	ra,0x2
    800040ee:	3ae080e7          	jalr	942(ra) # 80006498 <release>
}
    800040f2:	bfe1                	j	800040ca <pipeclose+0x46>

00000000800040f4 <pipewrite>:

int pipewrite(struct pipe *pi, uint64 addr, int n) {
    800040f4:	711d                	addi	sp,sp,-96
    800040f6:	ec86                	sd	ra,88(sp)
    800040f8:	e8a2                	sd	s0,80(sp)
    800040fa:	e4a6                	sd	s1,72(sp)
    800040fc:	e0ca                	sd	s2,64(sp)
    800040fe:	fc4e                	sd	s3,56(sp)
    80004100:	f852                	sd	s4,48(sp)
    80004102:	f456                	sd	s5,40(sp)
    80004104:	f05a                	sd	s6,32(sp)
    80004106:	ec5e                	sd	s7,24(sp)
    80004108:	e862                	sd	s8,16(sp)
    8000410a:	1080                	addi	s0,sp,96
    8000410c:	84aa                	mv	s1,a0
    8000410e:	8aae                	mv	s5,a1
    80004110:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004112:	ffffd097          	auipc	ra,0xffffd
    80004116:	016080e7          	jalr	22(ra) # 80001128 <myproc>
    8000411a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000411c:	8526                	mv	a0,s1
    8000411e:	00002097          	auipc	ra,0x2
    80004122:	2c6080e7          	jalr	710(ra) # 800063e4 <acquire>
  while (i < n) {
    80004126:	0b405663          	blez	s4,800041d2 <pipewrite+0xde>
  int i = 0;
    8000412a:	4901                	li	s2,0
    if (pi->nwrite == pi->nread + PIPESIZE) {  // DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1) break;
    8000412c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000412e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004132:	21c48b93          	addi	s7,s1,540
    80004136:	a089                	j	80004178 <pipewrite+0x84>
      release(&pi->lock);
    80004138:	8526                	mv	a0,s1
    8000413a:	00002097          	auipc	ra,0x2
    8000413e:	35e080e7          	jalr	862(ra) # 80006498 <release>
      return -1;
    80004142:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004144:	854a                	mv	a0,s2
    80004146:	60e6                	ld	ra,88(sp)
    80004148:	6446                	ld	s0,80(sp)
    8000414a:	64a6                	ld	s1,72(sp)
    8000414c:	6906                	ld	s2,64(sp)
    8000414e:	79e2                	ld	s3,56(sp)
    80004150:	7a42                	ld	s4,48(sp)
    80004152:	7aa2                	ld	s5,40(sp)
    80004154:	7b02                	ld	s6,32(sp)
    80004156:	6be2                	ld	s7,24(sp)
    80004158:	6c42                	ld	s8,16(sp)
    8000415a:	6125                	addi	sp,sp,96
    8000415c:	8082                	ret
      wakeup(&pi->nread);
    8000415e:	8562                	mv	a0,s8
    80004160:	ffffd097          	auipc	ra,0xffffd
    80004164:	6d8080e7          	jalr	1752(ra) # 80001838 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004168:	85a6                	mv	a1,s1
    8000416a:	855e                	mv	a0,s7
    8000416c:	ffffd097          	auipc	ra,0xffffd
    80004170:	668080e7          	jalr	1640(ra) # 800017d4 <sleep>
  while (i < n) {
    80004174:	07495063          	bge	s2,s4,800041d4 <pipewrite+0xe0>
    if (pi->readopen == 0 || killed(pr)) {
    80004178:	2204a783          	lw	a5,544(s1)
    8000417c:	dfd5                	beqz	a5,80004138 <pipewrite+0x44>
    8000417e:	854e                	mv	a0,s3
    80004180:	ffffe097          	auipc	ra,0xffffe
    80004184:	8fc080e7          	jalr	-1796(ra) # 80001a7c <killed>
    80004188:	f945                	bnez	a0,80004138 <pipewrite+0x44>
    if (pi->nwrite == pi->nread + PIPESIZE) {  // DOC: pipewrite-full
    8000418a:	2184a783          	lw	a5,536(s1)
    8000418e:	21c4a703          	lw	a4,540(s1)
    80004192:	2007879b          	addiw	a5,a5,512
    80004196:	fcf704e3          	beq	a4,a5,8000415e <pipewrite+0x6a>
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1) break;
    8000419a:	4685                	li	a3,1
    8000419c:	01590633          	add	a2,s2,s5
    800041a0:	faf40593          	addi	a1,s0,-81
    800041a4:	0509b503          	ld	a0,80(s3)
    800041a8:	ffffd097          	auipc	ra,0xffffd
    800041ac:	b18080e7          	jalr	-1256(ra) # 80000cc0 <copyin>
    800041b0:	03650263          	beq	a0,s6,800041d4 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800041b4:	21c4a783          	lw	a5,540(s1)
    800041b8:	0017871b          	addiw	a4,a5,1
    800041bc:	20e4ae23          	sw	a4,540(s1)
    800041c0:	1ff7f793          	andi	a5,a5,511
    800041c4:	97a6                	add	a5,a5,s1
    800041c6:	faf44703          	lbu	a4,-81(s0)
    800041ca:	00e78c23          	sb	a4,24(a5)
      i++;
    800041ce:	2905                	addiw	s2,s2,1
    800041d0:	b755                	j	80004174 <pipewrite+0x80>
  int i = 0;
    800041d2:	4901                	li	s2,0
  wakeup(&pi->nread);
    800041d4:	21848513          	addi	a0,s1,536
    800041d8:	ffffd097          	auipc	ra,0xffffd
    800041dc:	660080e7          	jalr	1632(ra) # 80001838 <wakeup>
  release(&pi->lock);
    800041e0:	8526                	mv	a0,s1
    800041e2:	00002097          	auipc	ra,0x2
    800041e6:	2b6080e7          	jalr	694(ra) # 80006498 <release>
  return i;
    800041ea:	bfa9                	j	80004144 <pipewrite+0x50>

00000000800041ec <piperead>:

int piperead(struct pipe *pi, uint64 addr, int n) {
    800041ec:	715d                	addi	sp,sp,-80
    800041ee:	e486                	sd	ra,72(sp)
    800041f0:	e0a2                	sd	s0,64(sp)
    800041f2:	fc26                	sd	s1,56(sp)
    800041f4:	f84a                	sd	s2,48(sp)
    800041f6:	f44e                	sd	s3,40(sp)
    800041f8:	f052                	sd	s4,32(sp)
    800041fa:	ec56                	sd	s5,24(sp)
    800041fc:	e85a                	sd	s6,16(sp)
    800041fe:	0880                	addi	s0,sp,80
    80004200:	84aa                	mv	s1,a0
    80004202:	892e                	mv	s2,a1
    80004204:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004206:	ffffd097          	auipc	ra,0xffffd
    8000420a:	f22080e7          	jalr	-222(ra) # 80001128 <myproc>
    8000420e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004210:	8526                	mv	a0,s1
    80004212:	00002097          	auipc	ra,0x2
    80004216:	1d2080e7          	jalr	466(ra) # 800063e4 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    8000421a:	2184a703          	lw	a4,536(s1)
    8000421e:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock);  // DOC: piperead-sleep
    80004222:	21848993          	addi	s3,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    80004226:	02f71763          	bne	a4,a5,80004254 <piperead+0x68>
    8000422a:	2244a783          	lw	a5,548(s1)
    8000422e:	c39d                	beqz	a5,80004254 <piperead+0x68>
    if (killed(pr)) {
    80004230:	8552                	mv	a0,s4
    80004232:	ffffe097          	auipc	ra,0xffffe
    80004236:	84a080e7          	jalr	-1974(ra) # 80001a7c <killed>
    8000423a:	e949                	bnez	a0,800042cc <piperead+0xe0>
    sleep(&pi->nread, &pi->lock);  // DOC: piperead-sleep
    8000423c:	85a6                	mv	a1,s1
    8000423e:	854e                	mv	a0,s3
    80004240:	ffffd097          	auipc	ra,0xffffd
    80004244:	594080e7          	jalr	1428(ra) # 800017d4 <sleep>
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    80004248:	2184a703          	lw	a4,536(s1)
    8000424c:	21c4a783          	lw	a5,540(s1)
    80004250:	fcf70de3          	beq	a4,a5,8000422a <piperead+0x3e>
  }
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    80004254:	4981                	li	s3,0
    if (pi->nread == pi->nwrite) break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) break;
    80004256:	5b7d                	li	s6,-1
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    80004258:	05505463          	blez	s5,800042a0 <piperead+0xb4>
    if (pi->nread == pi->nwrite) break;
    8000425c:	2184a783          	lw	a5,536(s1)
    80004260:	21c4a703          	lw	a4,540(s1)
    80004264:	02f70e63          	beq	a4,a5,800042a0 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004268:	0017871b          	addiw	a4,a5,1
    8000426c:	20e4ac23          	sw	a4,536(s1)
    80004270:	1ff7f793          	andi	a5,a5,511
    80004274:	97a6                	add	a5,a5,s1
    80004276:	0187c783          	lbu	a5,24(a5)
    8000427a:	faf40fa3          	sb	a5,-65(s0)
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) break;
    8000427e:	4685                	li	a3,1
    80004280:	fbf40613          	addi	a2,s0,-65
    80004284:	85ca                	mv	a1,s2
    80004286:	050a3503          	ld	a0,80(s4)
    8000428a:	ffffd097          	auipc	ra,0xffffd
    8000428e:	c6c080e7          	jalr	-916(ra) # 80000ef6 <copyout>
    80004292:	01650763          	beq	a0,s6,800042a0 <piperead+0xb4>
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    80004296:	2985                	addiw	s3,s3,1
    80004298:	0905                	addi	s2,s2,1
    8000429a:	fd3a91e3          	bne	s5,s3,8000425c <piperead+0x70>
    8000429e:	89d6                	mv	s3,s5
  }
  wakeup(&pi->nwrite);  // DOC: piperead-wakeup
    800042a0:	21c48513          	addi	a0,s1,540
    800042a4:	ffffd097          	auipc	ra,0xffffd
    800042a8:	594080e7          	jalr	1428(ra) # 80001838 <wakeup>
  release(&pi->lock);
    800042ac:	8526                	mv	a0,s1
    800042ae:	00002097          	auipc	ra,0x2
    800042b2:	1ea080e7          	jalr	490(ra) # 80006498 <release>
  return i;
}
    800042b6:	854e                	mv	a0,s3
    800042b8:	60a6                	ld	ra,72(sp)
    800042ba:	6406                	ld	s0,64(sp)
    800042bc:	74e2                	ld	s1,56(sp)
    800042be:	7942                	ld	s2,48(sp)
    800042c0:	79a2                	ld	s3,40(sp)
    800042c2:	7a02                	ld	s4,32(sp)
    800042c4:	6ae2                	ld	s5,24(sp)
    800042c6:	6b42                	ld	s6,16(sp)
    800042c8:	6161                	addi	sp,sp,80
    800042ca:	8082                	ret
      release(&pi->lock);
    800042cc:	8526                	mv	a0,s1
    800042ce:	00002097          	auipc	ra,0x2
    800042d2:	1ca080e7          	jalr	458(ra) # 80006498 <release>
      return -1;
    800042d6:	59fd                	li	s3,-1
    800042d8:	bff9                	j	800042b6 <piperead+0xca>

00000000800042da <flags2perm>:
#include "riscv.h"
#include "types.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags) {
    800042da:	1141                	addi	sp,sp,-16
    800042dc:	e422                	sd	s0,8(sp)
    800042de:	0800                	addi	s0,sp,16
    800042e0:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1) perm = PTE_X;
    800042e2:	8905                	andi	a0,a0,1
    800042e4:	050e                	slli	a0,a0,0x3
  if (flags & 0x2) perm |= PTE_W;
    800042e6:	8b89                	andi	a5,a5,2
    800042e8:	c399                	beqz	a5,800042ee <flags2perm+0x14>
    800042ea:	00456513          	ori	a0,a0,4
  return perm;
}
    800042ee:	6422                	ld	s0,8(sp)
    800042f0:	0141                	addi	sp,sp,16
    800042f2:	8082                	ret

00000000800042f4 <exec>:

int exec(char *path, char **argv) {
    800042f4:	de010113          	addi	sp,sp,-544
    800042f8:	20113c23          	sd	ra,536(sp)
    800042fc:	20813823          	sd	s0,528(sp)
    80004300:	20913423          	sd	s1,520(sp)
    80004304:	21213023          	sd	s2,512(sp)
    80004308:	ffce                	sd	s3,504(sp)
    8000430a:	fbd2                	sd	s4,496(sp)
    8000430c:	f7d6                	sd	s5,488(sp)
    8000430e:	f3da                	sd	s6,480(sp)
    80004310:	efde                	sd	s7,472(sp)
    80004312:	ebe2                	sd	s8,464(sp)
    80004314:	e7e6                	sd	s9,456(sp)
    80004316:	e3ea                	sd	s10,448(sp)
    80004318:	ff6e                	sd	s11,440(sp)
    8000431a:	1400                	addi	s0,sp,544
    8000431c:	892a                	mv	s2,a0
    8000431e:	dea43423          	sd	a0,-536(s0)
    80004322:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004326:	ffffd097          	auipc	ra,0xffffd
    8000432a:	e02080e7          	jalr	-510(ra) # 80001128 <myproc>
    8000432e:	84aa                	mv	s1,a0

  begin_op();
    80004330:	fffff097          	auipc	ra,0xfffff
    80004334:	482080e7          	jalr	1154(ra) # 800037b2 <begin_op>

  if ((ip = namei(path)) == 0) {
    80004338:	854a                	mv	a0,s2
    8000433a:	fffff097          	auipc	ra,0xfffff
    8000433e:	258080e7          	jalr	600(ra) # 80003592 <namei>
    80004342:	c93d                	beqz	a0,800043b8 <exec+0xc4>
    80004344:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004346:	fffff097          	auipc	ra,0xfffff
    8000434a:	aa0080e7          	jalr	-1376(ra) # 80002de6 <ilock>

  // Check ELF header
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf)) goto bad;
    8000434e:	04000713          	li	a4,64
    80004352:	4681                	li	a3,0
    80004354:	e5040613          	addi	a2,s0,-432
    80004358:	4581                	li	a1,0
    8000435a:	8556                	mv	a0,s5
    8000435c:	fffff097          	auipc	ra,0xfffff
    80004360:	d3e080e7          	jalr	-706(ra) # 8000309a <readi>
    80004364:	04000793          	li	a5,64
    80004368:	00f51a63          	bne	a0,a5,8000437c <exec+0x88>

  if (elf.magic != ELF_MAGIC) goto bad;
    8000436c:	e5042703          	lw	a4,-432(s0)
    80004370:	464c47b7          	lui	a5,0x464c4
    80004374:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004378:	04f70663          	beq	a4,a5,800043c4 <exec+0xd0>
  return argc;  // this ends up in a0, the first argument to main(argc, argv)

bad:
  if (pagetable) proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    8000437c:	8556                	mv	a0,s5
    8000437e:	fffff097          	auipc	ra,0xfffff
    80004382:	cca080e7          	jalr	-822(ra) # 80003048 <iunlockput>
    end_op();
    80004386:	fffff097          	auipc	ra,0xfffff
    8000438a:	4aa080e7          	jalr	1194(ra) # 80003830 <end_op>
  }
  return -1;
    8000438e:	557d                	li	a0,-1
}
    80004390:	21813083          	ld	ra,536(sp)
    80004394:	21013403          	ld	s0,528(sp)
    80004398:	20813483          	ld	s1,520(sp)
    8000439c:	20013903          	ld	s2,512(sp)
    800043a0:	79fe                	ld	s3,504(sp)
    800043a2:	7a5e                	ld	s4,496(sp)
    800043a4:	7abe                	ld	s5,488(sp)
    800043a6:	7b1e                	ld	s6,480(sp)
    800043a8:	6bfe                	ld	s7,472(sp)
    800043aa:	6c5e                	ld	s8,464(sp)
    800043ac:	6cbe                	ld	s9,456(sp)
    800043ae:	6d1e                	ld	s10,448(sp)
    800043b0:	7dfa                	ld	s11,440(sp)
    800043b2:	22010113          	addi	sp,sp,544
    800043b6:	8082                	ret
    end_op();
    800043b8:	fffff097          	auipc	ra,0xfffff
    800043bc:	478080e7          	jalr	1144(ra) # 80003830 <end_op>
    return -1;
    800043c0:	557d                	li	a0,-1
    800043c2:	b7f9                	j	80004390 <exec+0x9c>
  if ((pagetable = proc_pagetable(p)) == 0) goto bad;
    800043c4:	8526                	mv	a0,s1
    800043c6:	ffffd097          	auipc	ra,0xffffd
    800043ca:	e2a080e7          	jalr	-470(ra) # 800011f0 <proc_pagetable>
    800043ce:	8b2a                	mv	s6,a0
    800043d0:	d555                	beqz	a0,8000437c <exec+0x88>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800043d2:	e7042783          	lw	a5,-400(s0)
    800043d6:	e8845703          	lhu	a4,-376(s0)
    800043da:	c735                	beqz	a4,80004446 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043dc:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800043de:	e0043423          	sd	zero,-504(s0)
    if (ph.vaddr % PGSIZE != 0) goto bad;
    800043e2:	6a05                	lui	s4,0x1
    800043e4:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800043e8:	dee43023          	sd	a4,-544(s0)
static int loadseg(pagetable_t pagetable, uint64 va, struct inode *ip,
                   uint offset, uint sz) {
  uint i, n;
  uint64 pa;

  for (i = 0; i < sz; i += PGSIZE) {
    800043ec:	6d85                	lui	s11,0x1
    800043ee:	7d7d                	lui	s10,0xfffff
    800043f0:	ac91                	j	80004644 <exec+0x350>
    pa = walkaddr(pagetable, va + i);
    if (pa == 0) panic("loadseg: address should exist");
    800043f2:	00004517          	auipc	a0,0x4
    800043f6:	2de50513          	addi	a0,a0,734 # 800086d0 <syscalls+0x280>
    800043fa:	00002097          	auipc	ra,0x2
    800043fe:	ab2080e7          	jalr	-1358(ra) # 80005eac <panic>
    if (sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n) return -1;
    80004402:	874a                	mv	a4,s2
    80004404:	009c86bb          	addw	a3,s9,s1
    80004408:	4581                	li	a1,0
    8000440a:	8556                	mv	a0,s5
    8000440c:	fffff097          	auipc	ra,0xfffff
    80004410:	c8e080e7          	jalr	-882(ra) # 8000309a <readi>
    80004414:	2501                	sext.w	a0,a0
    80004416:	1ca91463          	bne	s2,a0,800045de <exec+0x2ea>
  for (i = 0; i < sz; i += PGSIZE) {
    8000441a:	009d84bb          	addw	s1,s11,s1
    8000441e:	013d09bb          	addw	s3,s10,s3
    80004422:	2174f163          	bgeu	s1,s7,80004624 <exec+0x330>
    pa = walkaddr(pagetable, va + i);
    80004426:	02049593          	slli	a1,s1,0x20
    8000442a:	9181                	srli	a1,a1,0x20
    8000442c:	95e2                	add	a1,a1,s8
    8000442e:	855a                	mv	a0,s6
    80004430:	ffffc097          	auipc	ra,0xffffc
    80004434:	176080e7          	jalr	374(ra) # 800005a6 <walkaddr>
    80004438:	862a                	mv	a2,a0
    if (pa == 0) panic("loadseg: address should exist");
    8000443a:	dd45                	beqz	a0,800043f2 <exec+0xfe>
      n = PGSIZE;
    8000443c:	8952                	mv	s2,s4
    if (sz - i < PGSIZE)
    8000443e:	fd49f2e3          	bgeu	s3,s4,80004402 <exec+0x10e>
      n = sz - i;
    80004442:	894e                	mv	s2,s3
    80004444:	bf7d                	j	80004402 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004446:	4901                	li	s2,0
  iunlockput(ip);
    80004448:	8556                	mv	a0,s5
    8000444a:	fffff097          	auipc	ra,0xfffff
    8000444e:	bfe080e7          	jalr	-1026(ra) # 80003048 <iunlockput>
  end_op();
    80004452:	fffff097          	auipc	ra,0xfffff
    80004456:	3de080e7          	jalr	990(ra) # 80003830 <end_op>
  p = myproc();
    8000445a:	ffffd097          	auipc	ra,0xffffd
    8000445e:	cce080e7          	jalr	-818(ra) # 80001128 <myproc>
    80004462:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004464:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004468:	6785                	lui	a5,0x1
    8000446a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000446c:	97ca                	add	a5,a5,s2
    8000446e:	777d                	lui	a4,0xfffff
    80004470:	8ff9                	and	a5,a5,a4
    80004472:	def43c23          	sd	a5,-520(s0)
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE, PTE_W)) == 0) goto bad;
    80004476:	4691                	li	a3,4
    80004478:	6609                	lui	a2,0x2
    8000447a:	963e                	add	a2,a2,a5
    8000447c:	85be                	mv	a1,a5
    8000447e:	855a                	mv	a0,s6
    80004480:	ffffc097          	auipc	ra,0xffffc
    80004484:	4fe080e7          	jalr	1278(ra) # 8000097e <uvmalloc>
    80004488:	8c2a                	mv	s8,a0
  ip = 0;
    8000448a:	4a81                	li	s5,0
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE, PTE_W)) == 0) goto bad;
    8000448c:	14050963          	beqz	a0,800045de <exec+0x2ea>
  uvmclear(pagetable, sz - 2 * PGSIZE);
    80004490:	75f9                	lui	a1,0xffffe
    80004492:	95aa                	add	a1,a1,a0
    80004494:	855a                	mv	a0,s6
    80004496:	ffffc097          	auipc	ra,0xffffc
    8000449a:	7f8080e7          	jalr	2040(ra) # 80000c8e <uvmclear>
  stackbase = sp - PGSIZE;
    8000449e:	7afd                	lui	s5,0xfffff
    800044a0:	9ae2                	add	s5,s5,s8
  for (argc = 0; argv[argc]; argc++) {
    800044a2:	df043783          	ld	a5,-528(s0)
    800044a6:	6388                	ld	a0,0(a5)
    800044a8:	c925                	beqz	a0,80004518 <exec+0x224>
    800044aa:	e9040993          	addi	s3,s0,-368
    800044ae:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800044b2:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++) {
    800044b4:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800044b6:	ffffc097          	auipc	ra,0xffffc
    800044ba:	ee2080e7          	jalr	-286(ra) # 80000398 <strlen>
    800044be:	0015079b          	addiw	a5,a0,1
    800044c2:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16;  // riscv sp must be 16-byte aligned
    800044c6:	ff07f913          	andi	s2,a5,-16
    if (sp < stackbase) goto bad;
    800044ca:	15596163          	bltu	s2,s5,8000460c <exec+0x318>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800044ce:	df043d83          	ld	s11,-528(s0)
    800044d2:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800044d6:	8552                	mv	a0,s4
    800044d8:	ffffc097          	auipc	ra,0xffffc
    800044dc:	ec0080e7          	jalr	-320(ra) # 80000398 <strlen>
    800044e0:	0015069b          	addiw	a3,a0,1
    800044e4:	8652                	mv	a2,s4
    800044e6:	85ca                	mv	a1,s2
    800044e8:	855a                	mv	a0,s6
    800044ea:	ffffd097          	auipc	ra,0xffffd
    800044ee:	a0c080e7          	jalr	-1524(ra) # 80000ef6 <copyout>
    800044f2:	12054163          	bltz	a0,80004614 <exec+0x320>
    ustack[argc] = sp;
    800044f6:	0129b023          	sd	s2,0(s3)
  for (argc = 0; argv[argc]; argc++) {
    800044fa:	0485                	addi	s1,s1,1
    800044fc:	008d8793          	addi	a5,s11,8
    80004500:	def43823          	sd	a5,-528(s0)
    80004504:	008db503          	ld	a0,8(s11)
    80004508:	c911                	beqz	a0,8000451c <exec+0x228>
    if (argc >= MAXARG) goto bad;
    8000450a:	09a1                	addi	s3,s3,8
    8000450c:	fb3c95e3          	bne	s9,s3,800044b6 <exec+0x1c2>
  sz = sz1;
    80004510:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004514:	4a81                	li	s5,0
    80004516:	a0e1                	j	800045de <exec+0x2ea>
  sp = sz;
    80004518:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++) {
    8000451a:	4481                	li	s1,0
  ustack[argc] = 0;
    8000451c:	00349793          	slli	a5,s1,0x3
    80004520:	f9078793          	addi	a5,a5,-112
    80004524:	97a2                	add	a5,a5,s0
    80004526:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    8000452a:	00148693          	addi	a3,s1,1
    8000452e:	068e                	slli	a3,a3,0x3
    80004530:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004534:	ff097913          	andi	s2,s2,-16
  if (sp < stackbase) goto bad;
    80004538:	01597663          	bgeu	s2,s5,80004544 <exec+0x250>
  sz = sz1;
    8000453c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004540:	4a81                	li	s5,0
    80004542:	a871                	j	800045de <exec+0x2ea>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    80004544:	e9040613          	addi	a2,s0,-368
    80004548:	85ca                	mv	a1,s2
    8000454a:	855a                	mv	a0,s6
    8000454c:	ffffd097          	auipc	ra,0xffffd
    80004550:	9aa080e7          	jalr	-1622(ra) # 80000ef6 <copyout>
    80004554:	0c054463          	bltz	a0,8000461c <exec+0x328>
  p->trapframe->a1 = sp;
    80004558:	058bb783          	ld	a5,88(s7)
    8000455c:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    80004560:	de843783          	ld	a5,-536(s0)
    80004564:	0007c703          	lbu	a4,0(a5)
    80004568:	cf11                	beqz	a4,80004584 <exec+0x290>
    8000456a:	0785                	addi	a5,a5,1
    if (*s == '/') last = s + 1;
    8000456c:	02f00693          	li	a3,47
    80004570:	a039                	j	8000457e <exec+0x28a>
    80004572:	def43423          	sd	a5,-536(s0)
  for (last = s = path; *s; s++)
    80004576:	0785                	addi	a5,a5,1
    80004578:	fff7c703          	lbu	a4,-1(a5)
    8000457c:	c701                	beqz	a4,80004584 <exec+0x290>
    if (*s == '/') last = s + 1;
    8000457e:	fed71ce3          	bne	a4,a3,80004576 <exec+0x282>
    80004582:	bfc5                	j	80004572 <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    80004584:	4641                	li	a2,16
    80004586:	de843583          	ld	a1,-536(s0)
    8000458a:	158b8513          	addi	a0,s7,344
    8000458e:	ffffc097          	auipc	ra,0xffffc
    80004592:	dd8080e7          	jalr	-552(ra) # 80000366 <safestrcpy>
  oldpagetable = p->pagetable;
    80004596:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    8000459a:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000459e:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800045a2:	058bb783          	ld	a5,88(s7)
    800045a6:	e6843703          	ld	a4,-408(s0)
    800045aa:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;          // initial stack pointer
    800045ac:	058bb783          	ld	a5,88(s7)
    800045b0:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800045b4:	85ea                	mv	a1,s10
    800045b6:	ffffd097          	auipc	ra,0xffffd
    800045ba:	cd6080e7          	jalr	-810(ra) # 8000128c <proc_freepagetable>
  if (p->pid == 1) {
    800045be:	030ba703          	lw	a4,48(s7)
    800045c2:	4785                	li	a5,1
    800045c4:	00f70563          	beq	a4,a5,800045ce <exec+0x2da>
  return argc;  // this ends up in a0, the first argument to main(argc, argv)
    800045c8:	0004851b          	sext.w	a0,s1
    800045cc:	b3d1                	j	80004390 <exec+0x9c>
    vmprint(pagetable);
    800045ce:	855a                	mv	a0,s6
    800045d0:	ffffc097          	auipc	ra,0xffffc
    800045d4:	57a080e7          	jalr	1402(ra) # 80000b4a <vmprint>
    800045d8:	bfc5                	j	800045c8 <exec+0x2d4>
    800045da:	df243c23          	sd	s2,-520(s0)
  if (pagetable) proc_freepagetable(pagetable, sz);
    800045de:	df843583          	ld	a1,-520(s0)
    800045e2:	855a                	mv	a0,s6
    800045e4:	ffffd097          	auipc	ra,0xffffd
    800045e8:	ca8080e7          	jalr	-856(ra) # 8000128c <proc_freepagetable>
  if (ip) {
    800045ec:	d80a98e3          	bnez	s5,8000437c <exec+0x88>
  return -1;
    800045f0:	557d                	li	a0,-1
    800045f2:	bb79                	j	80004390 <exec+0x9c>
    800045f4:	df243c23          	sd	s2,-520(s0)
    800045f8:	b7dd                	j	800045de <exec+0x2ea>
    800045fa:	df243c23          	sd	s2,-520(s0)
    800045fe:	b7c5                	j	800045de <exec+0x2ea>
    80004600:	df243c23          	sd	s2,-520(s0)
    80004604:	bfe9                	j	800045de <exec+0x2ea>
    80004606:	df243c23          	sd	s2,-520(s0)
    8000460a:	bfd1                	j	800045de <exec+0x2ea>
  sz = sz1;
    8000460c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004610:	4a81                	li	s5,0
    80004612:	b7f1                	j	800045de <exec+0x2ea>
  sz = sz1;
    80004614:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004618:	4a81                	li	s5,0
    8000461a:	b7d1                	j	800045de <exec+0x2ea>
  sz = sz1;
    8000461c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004620:	4a81                	li	s5,0
    80004622:	bf75                	j	800045de <exec+0x2ea>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    80004624:	df843903          	ld	s2,-520(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004628:	e0843783          	ld	a5,-504(s0)
    8000462c:	0017869b          	addiw	a3,a5,1
    80004630:	e0d43423          	sd	a3,-504(s0)
    80004634:	e0043783          	ld	a5,-512(s0)
    80004638:	0387879b          	addiw	a5,a5,56
    8000463c:	e8845703          	lhu	a4,-376(s0)
    80004640:	e0e6d4e3          	bge	a3,a4,80004448 <exec+0x154>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph)) goto bad;
    80004644:	2781                	sext.w	a5,a5
    80004646:	e0f43023          	sd	a5,-512(s0)
    8000464a:	03800713          	li	a4,56
    8000464e:	86be                	mv	a3,a5
    80004650:	e1840613          	addi	a2,s0,-488
    80004654:	4581                	li	a1,0
    80004656:	8556                	mv	a0,s5
    80004658:	fffff097          	auipc	ra,0xfffff
    8000465c:	a42080e7          	jalr	-1470(ra) # 8000309a <readi>
    80004660:	03800793          	li	a5,56
    80004664:	f6f51be3          	bne	a0,a5,800045da <exec+0x2e6>
    if (ph.type != ELF_PROG_LOAD) continue;
    80004668:	e1842783          	lw	a5,-488(s0)
    8000466c:	4705                	li	a4,1
    8000466e:	fae79de3          	bne	a5,a4,80004628 <exec+0x334>
    if (ph.memsz < ph.filesz) goto bad;
    80004672:	e4043483          	ld	s1,-448(s0)
    80004676:	e3843783          	ld	a5,-456(s0)
    8000467a:	f6f4ede3          	bltu	s1,a5,800045f4 <exec+0x300>
    if (ph.vaddr + ph.memsz < ph.vaddr) goto bad;
    8000467e:	e2843783          	ld	a5,-472(s0)
    80004682:	94be                	add	s1,s1,a5
    80004684:	f6f4ebe3          	bltu	s1,a5,800045fa <exec+0x306>
    if (ph.vaddr % PGSIZE != 0) goto bad;
    80004688:	de043703          	ld	a4,-544(s0)
    8000468c:	8ff9                	and	a5,a5,a4
    8000468e:	fbad                	bnez	a5,80004600 <exec+0x30c>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    80004690:	e1c42503          	lw	a0,-484(s0)
    80004694:	00000097          	auipc	ra,0x0
    80004698:	c46080e7          	jalr	-954(ra) # 800042da <flags2perm>
    8000469c:	86aa                	mv	a3,a0
    8000469e:	8626                	mv	a2,s1
    800046a0:	85ca                	mv	a1,s2
    800046a2:	855a                	mv	a0,s6
    800046a4:	ffffc097          	auipc	ra,0xffffc
    800046a8:	2da080e7          	jalr	730(ra) # 8000097e <uvmalloc>
    800046ac:	dea43c23          	sd	a0,-520(s0)
    800046b0:	d939                	beqz	a0,80004606 <exec+0x312>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0) goto bad;
    800046b2:	e2843c03          	ld	s8,-472(s0)
    800046b6:	e2042c83          	lw	s9,-480(s0)
    800046ba:	e3842b83          	lw	s7,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    800046be:	f60b83e3          	beqz	s7,80004624 <exec+0x330>
    800046c2:	89de                	mv	s3,s7
    800046c4:	4481                	li	s1,0
    800046c6:	b385                	j	80004426 <exec+0x132>

00000000800046c8 <argfd>:
#include "stat.h"
#include "types.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int argfd(int n, int *pfd, struct file **pf) {
    800046c8:	7179                	addi	sp,sp,-48
    800046ca:	f406                	sd	ra,40(sp)
    800046cc:	f022                	sd	s0,32(sp)
    800046ce:	ec26                	sd	s1,24(sp)
    800046d0:	e84a                	sd	s2,16(sp)
    800046d2:	1800                	addi	s0,sp,48
    800046d4:	892e                	mv	s2,a1
    800046d6:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800046d8:	fdc40593          	addi	a1,s0,-36
    800046dc:	ffffe097          	auipc	ra,0xffffe
    800046e0:	b92080e7          	jalr	-1134(ra) # 8000226e <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) return -1;
    800046e4:	fdc42703          	lw	a4,-36(s0)
    800046e8:	47bd                	li	a5,15
    800046ea:	02e7eb63          	bltu	a5,a4,80004720 <argfd+0x58>
    800046ee:	ffffd097          	auipc	ra,0xffffd
    800046f2:	a3a080e7          	jalr	-1478(ra) # 80001128 <myproc>
    800046f6:	fdc42703          	lw	a4,-36(s0)
    800046fa:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffbd22a>
    800046fe:	078e                	slli	a5,a5,0x3
    80004700:	953e                	add	a0,a0,a5
    80004702:	611c                	ld	a5,0(a0)
    80004704:	c385                	beqz	a5,80004724 <argfd+0x5c>
  if (pfd) *pfd = fd;
    80004706:	00090463          	beqz	s2,8000470e <argfd+0x46>
    8000470a:	00e92023          	sw	a4,0(s2)
  if (pf) *pf = f;
  return 0;
    8000470e:	4501                	li	a0,0
  if (pf) *pf = f;
    80004710:	c091                	beqz	s1,80004714 <argfd+0x4c>
    80004712:	e09c                	sd	a5,0(s1)
}
    80004714:	70a2                	ld	ra,40(sp)
    80004716:	7402                	ld	s0,32(sp)
    80004718:	64e2                	ld	s1,24(sp)
    8000471a:	6942                	ld	s2,16(sp)
    8000471c:	6145                	addi	sp,sp,48
    8000471e:	8082                	ret
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) return -1;
    80004720:	557d                	li	a0,-1
    80004722:	bfcd                	j	80004714 <argfd+0x4c>
    80004724:	557d                	li	a0,-1
    80004726:	b7fd                	j	80004714 <argfd+0x4c>

0000000080004728 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int fdalloc(struct file *f) {
    80004728:	1101                	addi	sp,sp,-32
    8000472a:	ec06                	sd	ra,24(sp)
    8000472c:	e822                	sd	s0,16(sp)
    8000472e:	e426                	sd	s1,8(sp)
    80004730:	1000                	addi	s0,sp,32
    80004732:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004734:	ffffd097          	auipc	ra,0xffffd
    80004738:	9f4080e7          	jalr	-1548(ra) # 80001128 <myproc>
    8000473c:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    8000473e:	0d050793          	addi	a5,a0,208
    80004742:	4501                	li	a0,0
    80004744:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    80004746:	6398                	ld	a4,0(a5)
    80004748:	cb19                	beqz	a4,8000475e <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++) {
    8000474a:	2505                	addiw	a0,a0,1
    8000474c:	07a1                	addi	a5,a5,8
    8000474e:	fed51ce3          	bne	a0,a3,80004746 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004752:	557d                	li	a0,-1
}
    80004754:	60e2                	ld	ra,24(sp)
    80004756:	6442                	ld	s0,16(sp)
    80004758:	64a2                	ld	s1,8(sp)
    8000475a:	6105                	addi	sp,sp,32
    8000475c:	8082                	ret
      p->ofile[fd] = f;
    8000475e:	01a50793          	addi	a5,a0,26
    80004762:	078e                	slli	a5,a5,0x3
    80004764:	963e                	add	a2,a2,a5
    80004766:	e204                	sd	s1,0(a2)
      return fd;
    80004768:	b7f5                	j	80004754 <fdalloc+0x2c>

000000008000476a <create>:
  iunlockput(dp);
  end_op();
  return -1;
}

static struct inode *create(char *path, short type, short major, short minor) {
    8000476a:	715d                	addi	sp,sp,-80
    8000476c:	e486                	sd	ra,72(sp)
    8000476e:	e0a2                	sd	s0,64(sp)
    80004770:	fc26                	sd	s1,56(sp)
    80004772:	f84a                	sd	s2,48(sp)
    80004774:	f44e                	sd	s3,40(sp)
    80004776:	f052                	sd	s4,32(sp)
    80004778:	ec56                	sd	s5,24(sp)
    8000477a:	e85a                	sd	s6,16(sp)
    8000477c:	0880                	addi	s0,sp,80
    8000477e:	8b2e                	mv	s6,a1
    80004780:	89b2                	mv	s3,a2
    80004782:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0) return 0;
    80004784:	fb040593          	addi	a1,s0,-80
    80004788:	fffff097          	auipc	ra,0xfffff
    8000478c:	e28080e7          	jalr	-472(ra) # 800035b0 <nameiparent>
    80004790:	84aa                	mv	s1,a0
    80004792:	14050f63          	beqz	a0,800048f0 <create+0x186>

  ilock(dp);
    80004796:	ffffe097          	auipc	ra,0xffffe
    8000479a:	650080e7          	jalr	1616(ra) # 80002de6 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    8000479e:	4601                	li	a2,0
    800047a0:	fb040593          	addi	a1,s0,-80
    800047a4:	8526                	mv	a0,s1
    800047a6:	fffff097          	auipc	ra,0xfffff
    800047aa:	b24080e7          	jalr	-1244(ra) # 800032ca <dirlookup>
    800047ae:	8aaa                	mv	s5,a0
    800047b0:	c931                	beqz	a0,80004804 <create+0x9a>
    iunlockput(dp);
    800047b2:	8526                	mv	a0,s1
    800047b4:	fffff097          	auipc	ra,0xfffff
    800047b8:	894080e7          	jalr	-1900(ra) # 80003048 <iunlockput>
    ilock(ip);
    800047bc:	8556                	mv	a0,s5
    800047be:	ffffe097          	auipc	ra,0xffffe
    800047c2:	628080e7          	jalr	1576(ra) # 80002de6 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800047c6:	000b059b          	sext.w	a1,s6
    800047ca:	4789                	li	a5,2
    800047cc:	02f59563          	bne	a1,a5,800047f6 <create+0x8c>
    800047d0:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffbd254>
    800047d4:	37f9                	addiw	a5,a5,-2
    800047d6:	17c2                	slli	a5,a5,0x30
    800047d8:	93c1                	srli	a5,a5,0x30
    800047da:	4705                	li	a4,1
    800047dc:	00f76d63          	bltu	a4,a5,800047f6 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800047e0:	8556                	mv	a0,s5
    800047e2:	60a6                	ld	ra,72(sp)
    800047e4:	6406                	ld	s0,64(sp)
    800047e6:	74e2                	ld	s1,56(sp)
    800047e8:	7942                	ld	s2,48(sp)
    800047ea:	79a2                	ld	s3,40(sp)
    800047ec:	7a02                	ld	s4,32(sp)
    800047ee:	6ae2                	ld	s5,24(sp)
    800047f0:	6b42                	ld	s6,16(sp)
    800047f2:	6161                	addi	sp,sp,80
    800047f4:	8082                	ret
    iunlockput(ip);
    800047f6:	8556                	mv	a0,s5
    800047f8:	fffff097          	auipc	ra,0xfffff
    800047fc:	850080e7          	jalr	-1968(ra) # 80003048 <iunlockput>
    return 0;
    80004800:	4a81                	li	s5,0
    80004802:	bff9                	j	800047e0 <create+0x76>
  if ((ip = ialloc(dp->dev, type)) == 0) {
    80004804:	85da                	mv	a1,s6
    80004806:	4088                	lw	a0,0(s1)
    80004808:	ffffe097          	auipc	ra,0xffffe
    8000480c:	440080e7          	jalr	1088(ra) # 80002c48 <ialloc>
    80004810:	8a2a                	mv	s4,a0
    80004812:	c539                	beqz	a0,80004860 <create+0xf6>
  ilock(ip);
    80004814:	ffffe097          	auipc	ra,0xffffe
    80004818:	5d2080e7          	jalr	1490(ra) # 80002de6 <ilock>
  ip->major = major;
    8000481c:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004820:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004824:	4905                	li	s2,1
    80004826:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000482a:	8552                	mv	a0,s4
    8000482c:	ffffe097          	auipc	ra,0xffffe
    80004830:	4ee080e7          	jalr	1262(ra) # 80002d1a <iupdate>
  if (type == T_DIR) {  // Create . and .. entries.
    80004834:	000b059b          	sext.w	a1,s6
    80004838:	03258b63          	beq	a1,s2,8000486e <create+0x104>
  if (dirlink(dp, name, ip->inum) < 0) goto fail;
    8000483c:	004a2603          	lw	a2,4(s4)
    80004840:	fb040593          	addi	a1,s0,-80
    80004844:	8526                	mv	a0,s1
    80004846:	fffff097          	auipc	ra,0xfffff
    8000484a:	c9a080e7          	jalr	-870(ra) # 800034e0 <dirlink>
    8000484e:	06054f63          	bltz	a0,800048cc <create+0x162>
  iunlockput(dp);
    80004852:	8526                	mv	a0,s1
    80004854:	ffffe097          	auipc	ra,0xffffe
    80004858:	7f4080e7          	jalr	2036(ra) # 80003048 <iunlockput>
  return ip;
    8000485c:	8ad2                	mv	s5,s4
    8000485e:	b749                	j	800047e0 <create+0x76>
    iunlockput(dp);
    80004860:	8526                	mv	a0,s1
    80004862:	ffffe097          	auipc	ra,0xffffe
    80004866:	7e6080e7          	jalr	2022(ra) # 80003048 <iunlockput>
    return 0;
    8000486a:	8ad2                	mv	s5,s4
    8000486c:	bf95                	j	800047e0 <create+0x76>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000486e:	004a2603          	lw	a2,4(s4)
    80004872:	00004597          	auipc	a1,0x4
    80004876:	e7e58593          	addi	a1,a1,-386 # 800086f0 <syscalls+0x2a0>
    8000487a:	8552                	mv	a0,s4
    8000487c:	fffff097          	auipc	ra,0xfffff
    80004880:	c64080e7          	jalr	-924(ra) # 800034e0 <dirlink>
    80004884:	04054463          	bltz	a0,800048cc <create+0x162>
    80004888:	40d0                	lw	a2,4(s1)
    8000488a:	00004597          	auipc	a1,0x4
    8000488e:	e6e58593          	addi	a1,a1,-402 # 800086f8 <syscalls+0x2a8>
    80004892:	8552                	mv	a0,s4
    80004894:	fffff097          	auipc	ra,0xfffff
    80004898:	c4c080e7          	jalr	-948(ra) # 800034e0 <dirlink>
    8000489c:	02054863          	bltz	a0,800048cc <create+0x162>
  if (dirlink(dp, name, ip->inum) < 0) goto fail;
    800048a0:	004a2603          	lw	a2,4(s4)
    800048a4:	fb040593          	addi	a1,s0,-80
    800048a8:	8526                	mv	a0,s1
    800048aa:	fffff097          	auipc	ra,0xfffff
    800048ae:	c36080e7          	jalr	-970(ra) # 800034e0 <dirlink>
    800048b2:	00054d63          	bltz	a0,800048cc <create+0x162>
    dp->nlink++;  // for ".."
    800048b6:	04a4d783          	lhu	a5,74(s1)
    800048ba:	2785                	addiw	a5,a5,1
    800048bc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800048c0:	8526                	mv	a0,s1
    800048c2:	ffffe097          	auipc	ra,0xffffe
    800048c6:	458080e7          	jalr	1112(ra) # 80002d1a <iupdate>
    800048ca:	b761                	j	80004852 <create+0xe8>
  ip->nlink = 0;
    800048cc:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800048d0:	8552                	mv	a0,s4
    800048d2:	ffffe097          	auipc	ra,0xffffe
    800048d6:	448080e7          	jalr	1096(ra) # 80002d1a <iupdate>
  iunlockput(ip);
    800048da:	8552                	mv	a0,s4
    800048dc:	ffffe097          	auipc	ra,0xffffe
    800048e0:	76c080e7          	jalr	1900(ra) # 80003048 <iunlockput>
  iunlockput(dp);
    800048e4:	8526                	mv	a0,s1
    800048e6:	ffffe097          	auipc	ra,0xffffe
    800048ea:	762080e7          	jalr	1890(ra) # 80003048 <iunlockput>
  return 0;
    800048ee:	bdcd                	j	800047e0 <create+0x76>
  if ((dp = nameiparent(path, name)) == 0) return 0;
    800048f0:	8aaa                	mv	s5,a0
    800048f2:	b5fd                	j	800047e0 <create+0x76>

00000000800048f4 <sys_dup>:
uint64 sys_dup(void) {
    800048f4:	7179                	addi	sp,sp,-48
    800048f6:	f406                	sd	ra,40(sp)
    800048f8:	f022                	sd	s0,32(sp)
    800048fa:	ec26                	sd	s1,24(sp)
    800048fc:	e84a                	sd	s2,16(sp)
    800048fe:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0) return -1;
    80004900:	fd840613          	addi	a2,s0,-40
    80004904:	4581                	li	a1,0
    80004906:	4501                	li	a0,0
    80004908:	00000097          	auipc	ra,0x0
    8000490c:	dc0080e7          	jalr	-576(ra) # 800046c8 <argfd>
    80004910:	57fd                	li	a5,-1
    80004912:	02054363          	bltz	a0,80004938 <sys_dup+0x44>
  if ((fd = fdalloc(f)) < 0) return -1;
    80004916:	fd843903          	ld	s2,-40(s0)
    8000491a:	854a                	mv	a0,s2
    8000491c:	00000097          	auipc	ra,0x0
    80004920:	e0c080e7          	jalr	-500(ra) # 80004728 <fdalloc>
    80004924:	84aa                	mv	s1,a0
    80004926:	57fd                	li	a5,-1
    80004928:	00054863          	bltz	a0,80004938 <sys_dup+0x44>
  filedup(f);
    8000492c:	854a                	mv	a0,s2
    8000492e:	fffff097          	auipc	ra,0xfffff
    80004932:	2fa080e7          	jalr	762(ra) # 80003c28 <filedup>
  return fd;
    80004936:	87a6                	mv	a5,s1
}
    80004938:	853e                	mv	a0,a5
    8000493a:	70a2                	ld	ra,40(sp)
    8000493c:	7402                	ld	s0,32(sp)
    8000493e:	64e2                	ld	s1,24(sp)
    80004940:	6942                	ld	s2,16(sp)
    80004942:	6145                	addi	sp,sp,48
    80004944:	8082                	ret

0000000080004946 <sys_read>:
uint64 sys_read(void) {
    80004946:	7179                	addi	sp,sp,-48
    80004948:	f406                	sd	ra,40(sp)
    8000494a:	f022                	sd	s0,32(sp)
    8000494c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000494e:	fd840593          	addi	a1,s0,-40
    80004952:	4505                	li	a0,1
    80004954:	ffffe097          	auipc	ra,0xffffe
    80004958:	93a080e7          	jalr	-1734(ra) # 8000228e <argaddr>
  argint(2, &n);
    8000495c:	fe440593          	addi	a1,s0,-28
    80004960:	4509                	li	a0,2
    80004962:	ffffe097          	auipc	ra,0xffffe
    80004966:	90c080e7          	jalr	-1780(ra) # 8000226e <argint>
  if (argfd(0, 0, &f) < 0) return -1;
    8000496a:	fe840613          	addi	a2,s0,-24
    8000496e:	4581                	li	a1,0
    80004970:	4501                	li	a0,0
    80004972:	00000097          	auipc	ra,0x0
    80004976:	d56080e7          	jalr	-682(ra) # 800046c8 <argfd>
    8000497a:	87aa                	mv	a5,a0
    8000497c:	557d                	li	a0,-1
    8000497e:	0007cc63          	bltz	a5,80004996 <sys_read+0x50>
  return fileread(f, p, n);
    80004982:	fe442603          	lw	a2,-28(s0)
    80004986:	fd843583          	ld	a1,-40(s0)
    8000498a:	fe843503          	ld	a0,-24(s0)
    8000498e:	fffff097          	auipc	ra,0xfffff
    80004992:	426080e7          	jalr	1062(ra) # 80003db4 <fileread>
}
    80004996:	70a2                	ld	ra,40(sp)
    80004998:	7402                	ld	s0,32(sp)
    8000499a:	6145                	addi	sp,sp,48
    8000499c:	8082                	ret

000000008000499e <sys_write>:
uint64 sys_write(void) {
    8000499e:	7179                	addi	sp,sp,-48
    800049a0:	f406                	sd	ra,40(sp)
    800049a2:	f022                	sd	s0,32(sp)
    800049a4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800049a6:	fd840593          	addi	a1,s0,-40
    800049aa:	4505                	li	a0,1
    800049ac:	ffffe097          	auipc	ra,0xffffe
    800049b0:	8e2080e7          	jalr	-1822(ra) # 8000228e <argaddr>
  argint(2, &n);
    800049b4:	fe440593          	addi	a1,s0,-28
    800049b8:	4509                	li	a0,2
    800049ba:	ffffe097          	auipc	ra,0xffffe
    800049be:	8b4080e7          	jalr	-1868(ra) # 8000226e <argint>
  if (argfd(0, 0, &f) < 0) return -1;
    800049c2:	fe840613          	addi	a2,s0,-24
    800049c6:	4581                	li	a1,0
    800049c8:	4501                	li	a0,0
    800049ca:	00000097          	auipc	ra,0x0
    800049ce:	cfe080e7          	jalr	-770(ra) # 800046c8 <argfd>
    800049d2:	87aa                	mv	a5,a0
    800049d4:	557d                	li	a0,-1
    800049d6:	0007cc63          	bltz	a5,800049ee <sys_write+0x50>
  return filewrite(f, p, n);
    800049da:	fe442603          	lw	a2,-28(s0)
    800049de:	fd843583          	ld	a1,-40(s0)
    800049e2:	fe843503          	ld	a0,-24(s0)
    800049e6:	fffff097          	auipc	ra,0xfffff
    800049ea:	490080e7          	jalr	1168(ra) # 80003e76 <filewrite>
}
    800049ee:	70a2                	ld	ra,40(sp)
    800049f0:	7402                	ld	s0,32(sp)
    800049f2:	6145                	addi	sp,sp,48
    800049f4:	8082                	ret

00000000800049f6 <sys_close>:
uint64 sys_close(void) {
    800049f6:	1101                	addi	sp,sp,-32
    800049f8:	ec06                	sd	ra,24(sp)
    800049fa:	e822                	sd	s0,16(sp)
    800049fc:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0) return -1;
    800049fe:	fe040613          	addi	a2,s0,-32
    80004a02:	fec40593          	addi	a1,s0,-20
    80004a06:	4501                	li	a0,0
    80004a08:	00000097          	auipc	ra,0x0
    80004a0c:	cc0080e7          	jalr	-832(ra) # 800046c8 <argfd>
    80004a10:	57fd                	li	a5,-1
    80004a12:	02054463          	bltz	a0,80004a3a <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004a16:	ffffc097          	auipc	ra,0xffffc
    80004a1a:	712080e7          	jalr	1810(ra) # 80001128 <myproc>
    80004a1e:	fec42783          	lw	a5,-20(s0)
    80004a22:	07e9                	addi	a5,a5,26
    80004a24:	078e                	slli	a5,a5,0x3
    80004a26:	953e                	add	a0,a0,a5
    80004a28:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004a2c:	fe043503          	ld	a0,-32(s0)
    80004a30:	fffff097          	auipc	ra,0xfffff
    80004a34:	24a080e7          	jalr	586(ra) # 80003c7a <fileclose>
  return 0;
    80004a38:	4781                	li	a5,0
}
    80004a3a:	853e                	mv	a0,a5
    80004a3c:	60e2                	ld	ra,24(sp)
    80004a3e:	6442                	ld	s0,16(sp)
    80004a40:	6105                	addi	sp,sp,32
    80004a42:	8082                	ret

0000000080004a44 <sys_fstat>:
uint64 sys_fstat(void) {
    80004a44:	1101                	addi	sp,sp,-32
    80004a46:	ec06                	sd	ra,24(sp)
    80004a48:	e822                	sd	s0,16(sp)
    80004a4a:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004a4c:	fe040593          	addi	a1,s0,-32
    80004a50:	4505                	li	a0,1
    80004a52:	ffffe097          	auipc	ra,0xffffe
    80004a56:	83c080e7          	jalr	-1988(ra) # 8000228e <argaddr>
  if (argfd(0, 0, &f) < 0) return -1;
    80004a5a:	fe840613          	addi	a2,s0,-24
    80004a5e:	4581                	li	a1,0
    80004a60:	4501                	li	a0,0
    80004a62:	00000097          	auipc	ra,0x0
    80004a66:	c66080e7          	jalr	-922(ra) # 800046c8 <argfd>
    80004a6a:	87aa                	mv	a5,a0
    80004a6c:	557d                	li	a0,-1
    80004a6e:	0007ca63          	bltz	a5,80004a82 <sys_fstat+0x3e>
  return filestat(f, st);
    80004a72:	fe043583          	ld	a1,-32(s0)
    80004a76:	fe843503          	ld	a0,-24(s0)
    80004a7a:	fffff097          	auipc	ra,0xfffff
    80004a7e:	2c8080e7          	jalr	712(ra) # 80003d42 <filestat>
}
    80004a82:	60e2                	ld	ra,24(sp)
    80004a84:	6442                	ld	s0,16(sp)
    80004a86:	6105                	addi	sp,sp,32
    80004a88:	8082                	ret

0000000080004a8a <sys_link>:
uint64 sys_link(void) {
    80004a8a:	7169                	addi	sp,sp,-304
    80004a8c:	f606                	sd	ra,296(sp)
    80004a8e:	f222                	sd	s0,288(sp)
    80004a90:	ee26                	sd	s1,280(sp)
    80004a92:	ea4a                	sd	s2,272(sp)
    80004a94:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0) return -1;
    80004a96:	08000613          	li	a2,128
    80004a9a:	ed040593          	addi	a1,s0,-304
    80004a9e:	4501                	li	a0,0
    80004aa0:	ffffe097          	auipc	ra,0xffffe
    80004aa4:	80e080e7          	jalr	-2034(ra) # 800022ae <argstr>
    80004aa8:	57fd                	li	a5,-1
    80004aaa:	10054e63          	bltz	a0,80004bc6 <sys_link+0x13c>
    80004aae:	08000613          	li	a2,128
    80004ab2:	f5040593          	addi	a1,s0,-176
    80004ab6:	4505                	li	a0,1
    80004ab8:	ffffd097          	auipc	ra,0xffffd
    80004abc:	7f6080e7          	jalr	2038(ra) # 800022ae <argstr>
    80004ac0:	57fd                	li	a5,-1
    80004ac2:	10054263          	bltz	a0,80004bc6 <sys_link+0x13c>
  begin_op();
    80004ac6:	fffff097          	auipc	ra,0xfffff
    80004aca:	cec080e7          	jalr	-788(ra) # 800037b2 <begin_op>
  if ((ip = namei(old)) == 0) {
    80004ace:	ed040513          	addi	a0,s0,-304
    80004ad2:	fffff097          	auipc	ra,0xfffff
    80004ad6:	ac0080e7          	jalr	-1344(ra) # 80003592 <namei>
    80004ada:	84aa                	mv	s1,a0
    80004adc:	c551                	beqz	a0,80004b68 <sys_link+0xde>
  ilock(ip);
    80004ade:	ffffe097          	auipc	ra,0xffffe
    80004ae2:	308080e7          	jalr	776(ra) # 80002de6 <ilock>
  if (ip->type == T_DIR) {
    80004ae6:	04449703          	lh	a4,68(s1)
    80004aea:	4785                	li	a5,1
    80004aec:	08f70463          	beq	a4,a5,80004b74 <sys_link+0xea>
  ip->nlink++;
    80004af0:	04a4d783          	lhu	a5,74(s1)
    80004af4:	2785                	addiw	a5,a5,1
    80004af6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004afa:	8526                	mv	a0,s1
    80004afc:	ffffe097          	auipc	ra,0xffffe
    80004b00:	21e080e7          	jalr	542(ra) # 80002d1a <iupdate>
  iunlock(ip);
    80004b04:	8526                	mv	a0,s1
    80004b06:	ffffe097          	auipc	ra,0xffffe
    80004b0a:	3a2080e7          	jalr	930(ra) # 80002ea8 <iunlock>
  if ((dp = nameiparent(new, name)) == 0) goto bad;
    80004b0e:	fd040593          	addi	a1,s0,-48
    80004b12:	f5040513          	addi	a0,s0,-176
    80004b16:	fffff097          	auipc	ra,0xfffff
    80004b1a:	a9a080e7          	jalr	-1382(ra) # 800035b0 <nameiparent>
    80004b1e:	892a                	mv	s2,a0
    80004b20:	c935                	beqz	a0,80004b94 <sys_link+0x10a>
  ilock(dp);
    80004b22:	ffffe097          	auipc	ra,0xffffe
    80004b26:	2c4080e7          	jalr	708(ra) # 80002de6 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    80004b2a:	00092703          	lw	a4,0(s2)
    80004b2e:	409c                	lw	a5,0(s1)
    80004b30:	04f71d63          	bne	a4,a5,80004b8a <sys_link+0x100>
    80004b34:	40d0                	lw	a2,4(s1)
    80004b36:	fd040593          	addi	a1,s0,-48
    80004b3a:	854a                	mv	a0,s2
    80004b3c:	fffff097          	auipc	ra,0xfffff
    80004b40:	9a4080e7          	jalr	-1628(ra) # 800034e0 <dirlink>
    80004b44:	04054363          	bltz	a0,80004b8a <sys_link+0x100>
  iunlockput(dp);
    80004b48:	854a                	mv	a0,s2
    80004b4a:	ffffe097          	auipc	ra,0xffffe
    80004b4e:	4fe080e7          	jalr	1278(ra) # 80003048 <iunlockput>
  iput(ip);
    80004b52:	8526                	mv	a0,s1
    80004b54:	ffffe097          	auipc	ra,0xffffe
    80004b58:	44c080e7          	jalr	1100(ra) # 80002fa0 <iput>
  end_op();
    80004b5c:	fffff097          	auipc	ra,0xfffff
    80004b60:	cd4080e7          	jalr	-812(ra) # 80003830 <end_op>
  return 0;
    80004b64:	4781                	li	a5,0
    80004b66:	a085                	j	80004bc6 <sys_link+0x13c>
    end_op();
    80004b68:	fffff097          	auipc	ra,0xfffff
    80004b6c:	cc8080e7          	jalr	-824(ra) # 80003830 <end_op>
    return -1;
    80004b70:	57fd                	li	a5,-1
    80004b72:	a891                	j	80004bc6 <sys_link+0x13c>
    iunlockput(ip);
    80004b74:	8526                	mv	a0,s1
    80004b76:	ffffe097          	auipc	ra,0xffffe
    80004b7a:	4d2080e7          	jalr	1234(ra) # 80003048 <iunlockput>
    end_op();
    80004b7e:	fffff097          	auipc	ra,0xfffff
    80004b82:	cb2080e7          	jalr	-846(ra) # 80003830 <end_op>
    return -1;
    80004b86:	57fd                	li	a5,-1
    80004b88:	a83d                	j	80004bc6 <sys_link+0x13c>
    iunlockput(dp);
    80004b8a:	854a                	mv	a0,s2
    80004b8c:	ffffe097          	auipc	ra,0xffffe
    80004b90:	4bc080e7          	jalr	1212(ra) # 80003048 <iunlockput>
  ilock(ip);
    80004b94:	8526                	mv	a0,s1
    80004b96:	ffffe097          	auipc	ra,0xffffe
    80004b9a:	250080e7          	jalr	592(ra) # 80002de6 <ilock>
  ip->nlink--;
    80004b9e:	04a4d783          	lhu	a5,74(s1)
    80004ba2:	37fd                	addiw	a5,a5,-1
    80004ba4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004ba8:	8526                	mv	a0,s1
    80004baa:	ffffe097          	auipc	ra,0xffffe
    80004bae:	170080e7          	jalr	368(ra) # 80002d1a <iupdate>
  iunlockput(ip);
    80004bb2:	8526                	mv	a0,s1
    80004bb4:	ffffe097          	auipc	ra,0xffffe
    80004bb8:	494080e7          	jalr	1172(ra) # 80003048 <iunlockput>
  end_op();
    80004bbc:	fffff097          	auipc	ra,0xfffff
    80004bc0:	c74080e7          	jalr	-908(ra) # 80003830 <end_op>
  return -1;
    80004bc4:	57fd                	li	a5,-1
}
    80004bc6:	853e                	mv	a0,a5
    80004bc8:	70b2                	ld	ra,296(sp)
    80004bca:	7412                	ld	s0,288(sp)
    80004bcc:	64f2                	ld	s1,280(sp)
    80004bce:	6952                	ld	s2,272(sp)
    80004bd0:	6155                	addi	sp,sp,304
    80004bd2:	8082                	ret

0000000080004bd4 <sys_unlink>:
uint64 sys_unlink(void) {
    80004bd4:	7151                	addi	sp,sp,-240
    80004bd6:	f586                	sd	ra,232(sp)
    80004bd8:	f1a2                	sd	s0,224(sp)
    80004bda:	eda6                	sd	s1,216(sp)
    80004bdc:	e9ca                	sd	s2,208(sp)
    80004bde:	e5ce                	sd	s3,200(sp)
    80004be0:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0) return -1;
    80004be2:	08000613          	li	a2,128
    80004be6:	f3040593          	addi	a1,s0,-208
    80004bea:	4501                	li	a0,0
    80004bec:	ffffd097          	auipc	ra,0xffffd
    80004bf0:	6c2080e7          	jalr	1730(ra) # 800022ae <argstr>
    80004bf4:	18054163          	bltz	a0,80004d76 <sys_unlink+0x1a2>
  begin_op();
    80004bf8:	fffff097          	auipc	ra,0xfffff
    80004bfc:	bba080e7          	jalr	-1094(ra) # 800037b2 <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    80004c00:	fb040593          	addi	a1,s0,-80
    80004c04:	f3040513          	addi	a0,s0,-208
    80004c08:	fffff097          	auipc	ra,0xfffff
    80004c0c:	9a8080e7          	jalr	-1624(ra) # 800035b0 <nameiparent>
    80004c10:	84aa                	mv	s1,a0
    80004c12:	c979                	beqz	a0,80004ce8 <sys_unlink+0x114>
  ilock(dp);
    80004c14:	ffffe097          	auipc	ra,0xffffe
    80004c18:	1d2080e7          	jalr	466(ra) # 80002de6 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0) goto bad;
    80004c1c:	00004597          	auipc	a1,0x4
    80004c20:	ad458593          	addi	a1,a1,-1324 # 800086f0 <syscalls+0x2a0>
    80004c24:	fb040513          	addi	a0,s0,-80
    80004c28:	ffffe097          	auipc	ra,0xffffe
    80004c2c:	688080e7          	jalr	1672(ra) # 800032b0 <namecmp>
    80004c30:	14050a63          	beqz	a0,80004d84 <sys_unlink+0x1b0>
    80004c34:	00004597          	auipc	a1,0x4
    80004c38:	ac458593          	addi	a1,a1,-1340 # 800086f8 <syscalls+0x2a8>
    80004c3c:	fb040513          	addi	a0,s0,-80
    80004c40:	ffffe097          	auipc	ra,0xffffe
    80004c44:	670080e7          	jalr	1648(ra) # 800032b0 <namecmp>
    80004c48:	12050e63          	beqz	a0,80004d84 <sys_unlink+0x1b0>
  if ((ip = dirlookup(dp, name, &off)) == 0) goto bad;
    80004c4c:	f2c40613          	addi	a2,s0,-212
    80004c50:	fb040593          	addi	a1,s0,-80
    80004c54:	8526                	mv	a0,s1
    80004c56:	ffffe097          	auipc	ra,0xffffe
    80004c5a:	674080e7          	jalr	1652(ra) # 800032ca <dirlookup>
    80004c5e:	892a                	mv	s2,a0
    80004c60:	12050263          	beqz	a0,80004d84 <sys_unlink+0x1b0>
  ilock(ip);
    80004c64:	ffffe097          	auipc	ra,0xffffe
    80004c68:	182080e7          	jalr	386(ra) # 80002de6 <ilock>
  if (ip->nlink < 1) panic("unlink: nlink < 1");
    80004c6c:	04a91783          	lh	a5,74(s2)
    80004c70:	08f05263          	blez	a5,80004cf4 <sys_unlink+0x120>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    80004c74:	04491703          	lh	a4,68(s2)
    80004c78:	4785                	li	a5,1
    80004c7a:	08f70563          	beq	a4,a5,80004d04 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004c7e:	4641                	li	a2,16
    80004c80:	4581                	li	a1,0
    80004c82:	fc040513          	addi	a0,s0,-64
    80004c86:	ffffb097          	auipc	ra,0xffffb
    80004c8a:	596080e7          	jalr	1430(ra) # 8000021c <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c8e:	4741                	li	a4,16
    80004c90:	f2c42683          	lw	a3,-212(s0)
    80004c94:	fc040613          	addi	a2,s0,-64
    80004c98:	4581                	li	a1,0
    80004c9a:	8526                	mv	a0,s1
    80004c9c:	ffffe097          	auipc	ra,0xffffe
    80004ca0:	4f6080e7          	jalr	1270(ra) # 80003192 <writei>
    80004ca4:	47c1                	li	a5,16
    80004ca6:	0af51563          	bne	a0,a5,80004d50 <sys_unlink+0x17c>
  if (ip->type == T_DIR) {
    80004caa:	04491703          	lh	a4,68(s2)
    80004cae:	4785                	li	a5,1
    80004cb0:	0af70863          	beq	a4,a5,80004d60 <sys_unlink+0x18c>
  iunlockput(dp);
    80004cb4:	8526                	mv	a0,s1
    80004cb6:	ffffe097          	auipc	ra,0xffffe
    80004cba:	392080e7          	jalr	914(ra) # 80003048 <iunlockput>
  ip->nlink--;
    80004cbe:	04a95783          	lhu	a5,74(s2)
    80004cc2:	37fd                	addiw	a5,a5,-1
    80004cc4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004cc8:	854a                	mv	a0,s2
    80004cca:	ffffe097          	auipc	ra,0xffffe
    80004cce:	050080e7          	jalr	80(ra) # 80002d1a <iupdate>
  iunlockput(ip);
    80004cd2:	854a                	mv	a0,s2
    80004cd4:	ffffe097          	auipc	ra,0xffffe
    80004cd8:	374080e7          	jalr	884(ra) # 80003048 <iunlockput>
  end_op();
    80004cdc:	fffff097          	auipc	ra,0xfffff
    80004ce0:	b54080e7          	jalr	-1196(ra) # 80003830 <end_op>
  return 0;
    80004ce4:	4501                	li	a0,0
    80004ce6:	a84d                	j	80004d98 <sys_unlink+0x1c4>
    end_op();
    80004ce8:	fffff097          	auipc	ra,0xfffff
    80004cec:	b48080e7          	jalr	-1208(ra) # 80003830 <end_op>
    return -1;
    80004cf0:	557d                	li	a0,-1
    80004cf2:	a05d                	j	80004d98 <sys_unlink+0x1c4>
  if (ip->nlink < 1) panic("unlink: nlink < 1");
    80004cf4:	00004517          	auipc	a0,0x4
    80004cf8:	a0c50513          	addi	a0,a0,-1524 # 80008700 <syscalls+0x2b0>
    80004cfc:	00001097          	auipc	ra,0x1
    80004d00:	1b0080e7          	jalr	432(ra) # 80005eac <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004d04:	04c92703          	lw	a4,76(s2)
    80004d08:	02000793          	li	a5,32
    80004d0c:	f6e7f9e3          	bgeu	a5,a4,80004c7e <sys_unlink+0xaa>
    80004d10:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d14:	4741                	li	a4,16
    80004d16:	86ce                	mv	a3,s3
    80004d18:	f1840613          	addi	a2,s0,-232
    80004d1c:	4581                	li	a1,0
    80004d1e:	854a                	mv	a0,s2
    80004d20:	ffffe097          	auipc	ra,0xffffe
    80004d24:	37a080e7          	jalr	890(ra) # 8000309a <readi>
    80004d28:	47c1                	li	a5,16
    80004d2a:	00f51b63          	bne	a0,a5,80004d40 <sys_unlink+0x16c>
    if (de.inum != 0) return 0;
    80004d2e:	f1845783          	lhu	a5,-232(s0)
    80004d32:	e7a1                	bnez	a5,80004d7a <sys_unlink+0x1a6>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004d34:	29c1                	addiw	s3,s3,16
    80004d36:	04c92783          	lw	a5,76(s2)
    80004d3a:	fcf9ede3          	bltu	s3,a5,80004d14 <sys_unlink+0x140>
    80004d3e:	b781                	j	80004c7e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004d40:	00004517          	auipc	a0,0x4
    80004d44:	9d850513          	addi	a0,a0,-1576 # 80008718 <syscalls+0x2c8>
    80004d48:	00001097          	auipc	ra,0x1
    80004d4c:	164080e7          	jalr	356(ra) # 80005eac <panic>
    panic("unlink: writei");
    80004d50:	00004517          	auipc	a0,0x4
    80004d54:	9e050513          	addi	a0,a0,-1568 # 80008730 <syscalls+0x2e0>
    80004d58:	00001097          	auipc	ra,0x1
    80004d5c:	154080e7          	jalr	340(ra) # 80005eac <panic>
    dp->nlink--;
    80004d60:	04a4d783          	lhu	a5,74(s1)
    80004d64:	37fd                	addiw	a5,a5,-1
    80004d66:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d6a:	8526                	mv	a0,s1
    80004d6c:	ffffe097          	auipc	ra,0xffffe
    80004d70:	fae080e7          	jalr	-82(ra) # 80002d1a <iupdate>
    80004d74:	b781                	j	80004cb4 <sys_unlink+0xe0>
  if (argstr(0, path, MAXPATH) < 0) return -1;
    80004d76:	557d                	li	a0,-1
    80004d78:	a005                	j	80004d98 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004d7a:	854a                	mv	a0,s2
    80004d7c:	ffffe097          	auipc	ra,0xffffe
    80004d80:	2cc080e7          	jalr	716(ra) # 80003048 <iunlockput>
  iunlockput(dp);
    80004d84:	8526                	mv	a0,s1
    80004d86:	ffffe097          	auipc	ra,0xffffe
    80004d8a:	2c2080e7          	jalr	706(ra) # 80003048 <iunlockput>
  end_op();
    80004d8e:	fffff097          	auipc	ra,0xfffff
    80004d92:	aa2080e7          	jalr	-1374(ra) # 80003830 <end_op>
  return -1;
    80004d96:	557d                	li	a0,-1
}
    80004d98:	70ae                	ld	ra,232(sp)
    80004d9a:	740e                	ld	s0,224(sp)
    80004d9c:	64ee                	ld	s1,216(sp)
    80004d9e:	694e                	ld	s2,208(sp)
    80004da0:	69ae                	ld	s3,200(sp)
    80004da2:	616d                	addi	sp,sp,240
    80004da4:	8082                	ret

0000000080004da6 <sys_open>:

uint64 sys_open(void) {
    80004da6:	7131                	addi	sp,sp,-192
    80004da8:	fd06                	sd	ra,184(sp)
    80004daa:	f922                	sd	s0,176(sp)
    80004dac:	f526                	sd	s1,168(sp)
    80004dae:	f14a                	sd	s2,160(sp)
    80004db0:	ed4e                	sd	s3,152(sp)
    80004db2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004db4:	f4c40593          	addi	a1,s0,-180
    80004db8:	4505                	li	a0,1
    80004dba:	ffffd097          	auipc	ra,0xffffd
    80004dbe:	4b4080e7          	jalr	1204(ra) # 8000226e <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0) return -1;
    80004dc2:	08000613          	li	a2,128
    80004dc6:	f5040593          	addi	a1,s0,-176
    80004dca:	4501                	li	a0,0
    80004dcc:	ffffd097          	auipc	ra,0xffffd
    80004dd0:	4e2080e7          	jalr	1250(ra) # 800022ae <argstr>
    80004dd4:	87aa                	mv	a5,a0
    80004dd6:	557d                	li	a0,-1
    80004dd8:	0a07c963          	bltz	a5,80004e8a <sys_open+0xe4>

  begin_op();
    80004ddc:	fffff097          	auipc	ra,0xfffff
    80004de0:	9d6080e7          	jalr	-1578(ra) # 800037b2 <begin_op>

  if (omode & O_CREATE) {
    80004de4:	f4c42783          	lw	a5,-180(s0)
    80004de8:	2007f793          	andi	a5,a5,512
    80004dec:	cfc5                	beqz	a5,80004ea4 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004dee:	4681                	li	a3,0
    80004df0:	4601                	li	a2,0
    80004df2:	4589                	li	a1,2
    80004df4:	f5040513          	addi	a0,s0,-176
    80004df8:	00000097          	auipc	ra,0x0
    80004dfc:	972080e7          	jalr	-1678(ra) # 8000476a <create>
    80004e00:	84aa                	mv	s1,a0
    if (ip == 0) {
    80004e02:	c959                	beqz	a0,80004e98 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    80004e04:	04449703          	lh	a4,68(s1)
    80004e08:	478d                	li	a5,3
    80004e0a:	00f71763          	bne	a4,a5,80004e18 <sys_open+0x72>
    80004e0e:	0464d703          	lhu	a4,70(s1)
    80004e12:	47a5                	li	a5,9
    80004e14:	0ce7ed63          	bltu	a5,a4,80004eee <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80004e18:	fffff097          	auipc	ra,0xfffff
    80004e1c:	da6080e7          	jalr	-602(ra) # 80003bbe <filealloc>
    80004e20:	89aa                	mv	s3,a0
    80004e22:	10050363          	beqz	a0,80004f28 <sys_open+0x182>
    80004e26:	00000097          	auipc	ra,0x0
    80004e2a:	902080e7          	jalr	-1790(ra) # 80004728 <fdalloc>
    80004e2e:	892a                	mv	s2,a0
    80004e30:	0e054763          	bltz	a0,80004f1e <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    80004e34:	04449703          	lh	a4,68(s1)
    80004e38:	478d                	li	a5,3
    80004e3a:	0cf70563          	beq	a4,a5,80004f04 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004e3e:	4789                	li	a5,2
    80004e40:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004e44:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004e48:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004e4c:	f4c42783          	lw	a5,-180(s0)
    80004e50:	0017c713          	xori	a4,a5,1
    80004e54:	8b05                	andi	a4,a4,1
    80004e56:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e5a:	0037f713          	andi	a4,a5,3
    80004e5e:	00e03733          	snez	a4,a4
    80004e62:	00e984a3          	sb	a4,9(s3)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    80004e66:	4007f793          	andi	a5,a5,1024
    80004e6a:	c791                	beqz	a5,80004e76 <sys_open+0xd0>
    80004e6c:	04449703          	lh	a4,68(s1)
    80004e70:	4789                	li	a5,2
    80004e72:	0af70063          	beq	a4,a5,80004f12 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004e76:	8526                	mv	a0,s1
    80004e78:	ffffe097          	auipc	ra,0xffffe
    80004e7c:	030080e7          	jalr	48(ra) # 80002ea8 <iunlock>
  end_op();
    80004e80:	fffff097          	auipc	ra,0xfffff
    80004e84:	9b0080e7          	jalr	-1616(ra) # 80003830 <end_op>

  return fd;
    80004e88:	854a                	mv	a0,s2
}
    80004e8a:	70ea                	ld	ra,184(sp)
    80004e8c:	744a                	ld	s0,176(sp)
    80004e8e:	74aa                	ld	s1,168(sp)
    80004e90:	790a                	ld	s2,160(sp)
    80004e92:	69ea                	ld	s3,152(sp)
    80004e94:	6129                	addi	sp,sp,192
    80004e96:	8082                	ret
      end_op();
    80004e98:	fffff097          	auipc	ra,0xfffff
    80004e9c:	998080e7          	jalr	-1640(ra) # 80003830 <end_op>
      return -1;
    80004ea0:	557d                	li	a0,-1
    80004ea2:	b7e5                	j	80004e8a <sys_open+0xe4>
    if ((ip = namei(path)) == 0) {
    80004ea4:	f5040513          	addi	a0,s0,-176
    80004ea8:	ffffe097          	auipc	ra,0xffffe
    80004eac:	6ea080e7          	jalr	1770(ra) # 80003592 <namei>
    80004eb0:	84aa                	mv	s1,a0
    80004eb2:	c905                	beqz	a0,80004ee2 <sys_open+0x13c>
    ilock(ip);
    80004eb4:	ffffe097          	auipc	ra,0xffffe
    80004eb8:	f32080e7          	jalr	-206(ra) # 80002de6 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    80004ebc:	04449703          	lh	a4,68(s1)
    80004ec0:	4785                	li	a5,1
    80004ec2:	f4f711e3          	bne	a4,a5,80004e04 <sys_open+0x5e>
    80004ec6:	f4c42783          	lw	a5,-180(s0)
    80004eca:	d7b9                	beqz	a5,80004e18 <sys_open+0x72>
      iunlockput(ip);
    80004ecc:	8526                	mv	a0,s1
    80004ece:	ffffe097          	auipc	ra,0xffffe
    80004ed2:	17a080e7          	jalr	378(ra) # 80003048 <iunlockput>
      end_op();
    80004ed6:	fffff097          	auipc	ra,0xfffff
    80004eda:	95a080e7          	jalr	-1702(ra) # 80003830 <end_op>
      return -1;
    80004ede:	557d                	li	a0,-1
    80004ee0:	b76d                	j	80004e8a <sys_open+0xe4>
      end_op();
    80004ee2:	fffff097          	auipc	ra,0xfffff
    80004ee6:	94e080e7          	jalr	-1714(ra) # 80003830 <end_op>
      return -1;
    80004eea:	557d                	li	a0,-1
    80004eec:	bf79                	j	80004e8a <sys_open+0xe4>
    iunlockput(ip);
    80004eee:	8526                	mv	a0,s1
    80004ef0:	ffffe097          	auipc	ra,0xffffe
    80004ef4:	158080e7          	jalr	344(ra) # 80003048 <iunlockput>
    end_op();
    80004ef8:	fffff097          	auipc	ra,0xfffff
    80004efc:	938080e7          	jalr	-1736(ra) # 80003830 <end_op>
    return -1;
    80004f00:	557d                	li	a0,-1
    80004f02:	b761                	j	80004e8a <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004f04:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004f08:	04649783          	lh	a5,70(s1)
    80004f0c:	02f99223          	sh	a5,36(s3)
    80004f10:	bf25                	j	80004e48 <sys_open+0xa2>
    itrunc(ip);
    80004f12:	8526                	mv	a0,s1
    80004f14:	ffffe097          	auipc	ra,0xffffe
    80004f18:	fe0080e7          	jalr	-32(ra) # 80002ef4 <itrunc>
    80004f1c:	bfa9                	j	80004e76 <sys_open+0xd0>
    if (f) fileclose(f);
    80004f1e:	854e                	mv	a0,s3
    80004f20:	fffff097          	auipc	ra,0xfffff
    80004f24:	d5a080e7          	jalr	-678(ra) # 80003c7a <fileclose>
    iunlockput(ip);
    80004f28:	8526                	mv	a0,s1
    80004f2a:	ffffe097          	auipc	ra,0xffffe
    80004f2e:	11e080e7          	jalr	286(ra) # 80003048 <iunlockput>
    end_op();
    80004f32:	fffff097          	auipc	ra,0xfffff
    80004f36:	8fe080e7          	jalr	-1794(ra) # 80003830 <end_op>
    return -1;
    80004f3a:	557d                	li	a0,-1
    80004f3c:	b7b9                	j	80004e8a <sys_open+0xe4>

0000000080004f3e <sys_mkdir>:

uint64 sys_mkdir(void) {
    80004f3e:	7175                	addi	sp,sp,-144
    80004f40:	e506                	sd	ra,136(sp)
    80004f42:	e122                	sd	s0,128(sp)
    80004f44:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004f46:	fffff097          	auipc	ra,0xfffff
    80004f4a:	86c080e7          	jalr	-1940(ra) # 800037b2 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80004f4e:	08000613          	li	a2,128
    80004f52:	f7040593          	addi	a1,s0,-144
    80004f56:	4501                	li	a0,0
    80004f58:	ffffd097          	auipc	ra,0xffffd
    80004f5c:	356080e7          	jalr	854(ra) # 800022ae <argstr>
    80004f60:	02054963          	bltz	a0,80004f92 <sys_mkdir+0x54>
    80004f64:	4681                	li	a3,0
    80004f66:	4601                	li	a2,0
    80004f68:	4585                	li	a1,1
    80004f6a:	f7040513          	addi	a0,s0,-144
    80004f6e:	fffff097          	auipc	ra,0xfffff
    80004f72:	7fc080e7          	jalr	2044(ra) # 8000476a <create>
    80004f76:	cd11                	beqz	a0,80004f92 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f78:	ffffe097          	auipc	ra,0xffffe
    80004f7c:	0d0080e7          	jalr	208(ra) # 80003048 <iunlockput>
  end_op();
    80004f80:	fffff097          	auipc	ra,0xfffff
    80004f84:	8b0080e7          	jalr	-1872(ra) # 80003830 <end_op>
  return 0;
    80004f88:	4501                	li	a0,0
}
    80004f8a:	60aa                	ld	ra,136(sp)
    80004f8c:	640a                	ld	s0,128(sp)
    80004f8e:	6149                	addi	sp,sp,144
    80004f90:	8082                	ret
    end_op();
    80004f92:	fffff097          	auipc	ra,0xfffff
    80004f96:	89e080e7          	jalr	-1890(ra) # 80003830 <end_op>
    return -1;
    80004f9a:	557d                	li	a0,-1
    80004f9c:	b7fd                	j	80004f8a <sys_mkdir+0x4c>

0000000080004f9e <sys_mknod>:

uint64 sys_mknod(void) {
    80004f9e:	7135                	addi	sp,sp,-160
    80004fa0:	ed06                	sd	ra,152(sp)
    80004fa2:	e922                	sd	s0,144(sp)
    80004fa4:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004fa6:	fffff097          	auipc	ra,0xfffff
    80004faa:	80c080e7          	jalr	-2036(ra) # 800037b2 <begin_op>
  argint(1, &major);
    80004fae:	f6c40593          	addi	a1,s0,-148
    80004fb2:	4505                	li	a0,1
    80004fb4:	ffffd097          	auipc	ra,0xffffd
    80004fb8:	2ba080e7          	jalr	698(ra) # 8000226e <argint>
  argint(2, &minor);
    80004fbc:	f6840593          	addi	a1,s0,-152
    80004fc0:	4509                	li	a0,2
    80004fc2:	ffffd097          	auipc	ra,0xffffd
    80004fc6:	2ac080e7          	jalr	684(ra) # 8000226e <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004fca:	08000613          	li	a2,128
    80004fce:	f7040593          	addi	a1,s0,-144
    80004fd2:	4501                	li	a0,0
    80004fd4:	ffffd097          	auipc	ra,0xffffd
    80004fd8:	2da080e7          	jalr	730(ra) # 800022ae <argstr>
    80004fdc:	02054b63          	bltz	a0,80005012 <sys_mknod+0x74>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    80004fe0:	f6841683          	lh	a3,-152(s0)
    80004fe4:	f6c41603          	lh	a2,-148(s0)
    80004fe8:	458d                	li	a1,3
    80004fea:	f7040513          	addi	a0,s0,-144
    80004fee:	fffff097          	auipc	ra,0xfffff
    80004ff2:	77c080e7          	jalr	1916(ra) # 8000476a <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004ff6:	cd11                	beqz	a0,80005012 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ff8:	ffffe097          	auipc	ra,0xffffe
    80004ffc:	050080e7          	jalr	80(ra) # 80003048 <iunlockput>
  end_op();
    80005000:	fffff097          	auipc	ra,0xfffff
    80005004:	830080e7          	jalr	-2000(ra) # 80003830 <end_op>
  return 0;
    80005008:	4501                	li	a0,0
}
    8000500a:	60ea                	ld	ra,152(sp)
    8000500c:	644a                	ld	s0,144(sp)
    8000500e:	610d                	addi	sp,sp,160
    80005010:	8082                	ret
    end_op();
    80005012:	fffff097          	auipc	ra,0xfffff
    80005016:	81e080e7          	jalr	-2018(ra) # 80003830 <end_op>
    return -1;
    8000501a:	557d                	li	a0,-1
    8000501c:	b7fd                	j	8000500a <sys_mknod+0x6c>

000000008000501e <sys_chdir>:

uint64 sys_chdir(void) {
    8000501e:	7135                	addi	sp,sp,-160
    80005020:	ed06                	sd	ra,152(sp)
    80005022:	e922                	sd	s0,144(sp)
    80005024:	e526                	sd	s1,136(sp)
    80005026:	e14a                	sd	s2,128(sp)
    80005028:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000502a:	ffffc097          	auipc	ra,0xffffc
    8000502e:	0fe080e7          	jalr	254(ra) # 80001128 <myproc>
    80005032:	892a                	mv	s2,a0

  begin_op();
    80005034:	ffffe097          	auipc	ra,0xffffe
    80005038:	77e080e7          	jalr	1918(ra) # 800037b2 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    8000503c:	08000613          	li	a2,128
    80005040:	f6040593          	addi	a1,s0,-160
    80005044:	4501                	li	a0,0
    80005046:	ffffd097          	auipc	ra,0xffffd
    8000504a:	268080e7          	jalr	616(ra) # 800022ae <argstr>
    8000504e:	04054b63          	bltz	a0,800050a4 <sys_chdir+0x86>
    80005052:	f6040513          	addi	a0,s0,-160
    80005056:	ffffe097          	auipc	ra,0xffffe
    8000505a:	53c080e7          	jalr	1340(ra) # 80003592 <namei>
    8000505e:	84aa                	mv	s1,a0
    80005060:	c131                	beqz	a0,800050a4 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005062:	ffffe097          	auipc	ra,0xffffe
    80005066:	d84080e7          	jalr	-636(ra) # 80002de6 <ilock>
  if (ip->type != T_DIR) {
    8000506a:	04449703          	lh	a4,68(s1)
    8000506e:	4785                	li	a5,1
    80005070:	04f71063          	bne	a4,a5,800050b0 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005074:	8526                	mv	a0,s1
    80005076:	ffffe097          	auipc	ra,0xffffe
    8000507a:	e32080e7          	jalr	-462(ra) # 80002ea8 <iunlock>
  iput(p->cwd);
    8000507e:	15093503          	ld	a0,336(s2)
    80005082:	ffffe097          	auipc	ra,0xffffe
    80005086:	f1e080e7          	jalr	-226(ra) # 80002fa0 <iput>
  end_op();
    8000508a:	ffffe097          	auipc	ra,0xffffe
    8000508e:	7a6080e7          	jalr	1958(ra) # 80003830 <end_op>
  p->cwd = ip;
    80005092:	14993823          	sd	s1,336(s2)
  return 0;
    80005096:	4501                	li	a0,0
}
    80005098:	60ea                	ld	ra,152(sp)
    8000509a:	644a                	ld	s0,144(sp)
    8000509c:	64aa                	ld	s1,136(sp)
    8000509e:	690a                	ld	s2,128(sp)
    800050a0:	610d                	addi	sp,sp,160
    800050a2:	8082                	ret
    end_op();
    800050a4:	ffffe097          	auipc	ra,0xffffe
    800050a8:	78c080e7          	jalr	1932(ra) # 80003830 <end_op>
    return -1;
    800050ac:	557d                	li	a0,-1
    800050ae:	b7ed                	j	80005098 <sys_chdir+0x7a>
    iunlockput(ip);
    800050b0:	8526                	mv	a0,s1
    800050b2:	ffffe097          	auipc	ra,0xffffe
    800050b6:	f96080e7          	jalr	-106(ra) # 80003048 <iunlockput>
    end_op();
    800050ba:	ffffe097          	auipc	ra,0xffffe
    800050be:	776080e7          	jalr	1910(ra) # 80003830 <end_op>
    return -1;
    800050c2:	557d                	li	a0,-1
    800050c4:	bfd1                	j	80005098 <sys_chdir+0x7a>

00000000800050c6 <sys_exec>:

uint64 sys_exec(void) {
    800050c6:	7145                	addi	sp,sp,-464
    800050c8:	e786                	sd	ra,456(sp)
    800050ca:	e3a2                	sd	s0,448(sp)
    800050cc:	ff26                	sd	s1,440(sp)
    800050ce:	fb4a                	sd	s2,432(sp)
    800050d0:	f74e                	sd	s3,424(sp)
    800050d2:	f352                	sd	s4,416(sp)
    800050d4:	ef56                	sd	s5,408(sp)
    800050d6:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800050d8:	e3840593          	addi	a1,s0,-456
    800050dc:	4505                	li	a0,1
    800050de:	ffffd097          	auipc	ra,0xffffd
    800050e2:	1b0080e7          	jalr	432(ra) # 8000228e <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    800050e6:	08000613          	li	a2,128
    800050ea:	f4040593          	addi	a1,s0,-192
    800050ee:	4501                	li	a0,0
    800050f0:	ffffd097          	auipc	ra,0xffffd
    800050f4:	1be080e7          	jalr	446(ra) # 800022ae <argstr>
    800050f8:	87aa                	mv	a5,a0
    return -1;
    800050fa:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0) {
    800050fc:	0c07c363          	bltz	a5,800051c2 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80005100:	10000613          	li	a2,256
    80005104:	4581                	li	a1,0
    80005106:	e4040513          	addi	a0,s0,-448
    8000510a:	ffffb097          	auipc	ra,0xffffb
    8000510e:	112080e7          	jalr	274(ra) # 8000021c <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    80005112:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005116:	89a6                	mv	s3,s1
    80005118:	4901                	li	s2,0
    if (i >= NELEM(argv)) {
    8000511a:	02000a13          	li	s4,32
    8000511e:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80005122:	00391513          	slli	a0,s2,0x3
    80005126:	e3040593          	addi	a1,s0,-464
    8000512a:	e3843783          	ld	a5,-456(s0)
    8000512e:	953e                	add	a0,a0,a5
    80005130:	ffffd097          	auipc	ra,0xffffd
    80005134:	0a0080e7          	jalr	160(ra) # 800021d0 <fetchaddr>
    80005138:	02054a63          	bltz	a0,8000516c <sys_exec+0xa6>
      goto bad;
    }
    if (uarg == 0) {
    8000513c:	e3043783          	ld	a5,-464(s0)
    80005140:	c3b9                	beqz	a5,80005186 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005142:	ffffb097          	auipc	ra,0xffffb
    80005146:	060080e7          	jalr	96(ra) # 800001a2 <kalloc>
    8000514a:	85aa                	mv	a1,a0
    8000514c:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0) goto bad;
    80005150:	cd11                	beqz	a0,8000516c <sys_exec+0xa6>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0) goto bad;
    80005152:	6605                	lui	a2,0x1
    80005154:	e3043503          	ld	a0,-464(s0)
    80005158:	ffffd097          	auipc	ra,0xffffd
    8000515c:	0ca080e7          	jalr	202(ra) # 80002222 <fetchstr>
    80005160:	00054663          	bltz	a0,8000516c <sys_exec+0xa6>
    if (i >= NELEM(argv)) {
    80005164:	0905                	addi	s2,s2,1
    80005166:	09a1                	addi	s3,s3,8
    80005168:	fb491be3          	bne	s2,s4,8000511e <sys_exec+0x58>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);
    8000516c:	f4040913          	addi	s2,s0,-192
    80005170:	6088                	ld	a0,0(s1)
    80005172:	c539                	beqz	a0,800051c0 <sys_exec+0xfa>
    80005174:	ffffb097          	auipc	ra,0xffffb
    80005178:	efa080e7          	jalr	-262(ra) # 8000006e <kfree>
    8000517c:	04a1                	addi	s1,s1,8
    8000517e:	ff2499e3          	bne	s1,s2,80005170 <sys_exec+0xaa>
  return -1;
    80005182:	557d                	li	a0,-1
    80005184:	a83d                	j	800051c2 <sys_exec+0xfc>
      argv[i] = 0;
    80005186:	0a8e                	slli	s5,s5,0x3
    80005188:	fc0a8793          	addi	a5,s5,-64
    8000518c:	00878ab3          	add	s5,a5,s0
    80005190:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005194:	e4040593          	addi	a1,s0,-448
    80005198:	f4040513          	addi	a0,s0,-192
    8000519c:	fffff097          	auipc	ra,0xfffff
    800051a0:	158080e7          	jalr	344(ra) # 800042f4 <exec>
    800051a4:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);
    800051a6:	f4040993          	addi	s3,s0,-192
    800051aa:	6088                	ld	a0,0(s1)
    800051ac:	c901                	beqz	a0,800051bc <sys_exec+0xf6>
    800051ae:	ffffb097          	auipc	ra,0xffffb
    800051b2:	ec0080e7          	jalr	-320(ra) # 8000006e <kfree>
    800051b6:	04a1                	addi	s1,s1,8
    800051b8:	ff3499e3          	bne	s1,s3,800051aa <sys_exec+0xe4>
  return ret;
    800051bc:	854a                	mv	a0,s2
    800051be:	a011                	j	800051c2 <sys_exec+0xfc>
  return -1;
    800051c0:	557d                	li	a0,-1
}
    800051c2:	60be                	ld	ra,456(sp)
    800051c4:	641e                	ld	s0,448(sp)
    800051c6:	74fa                	ld	s1,440(sp)
    800051c8:	795a                	ld	s2,432(sp)
    800051ca:	79ba                	ld	s3,424(sp)
    800051cc:	7a1a                	ld	s4,416(sp)
    800051ce:	6afa                	ld	s5,408(sp)
    800051d0:	6179                	addi	sp,sp,464
    800051d2:	8082                	ret

00000000800051d4 <sys_pipe>:

uint64 sys_pipe(void) {
    800051d4:	7139                	addi	sp,sp,-64
    800051d6:	fc06                	sd	ra,56(sp)
    800051d8:	f822                	sd	s0,48(sp)
    800051da:	f426                	sd	s1,40(sp)
    800051dc:	0080                	addi	s0,sp,64
  uint64 fdarray;  // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800051de:	ffffc097          	auipc	ra,0xffffc
    800051e2:	f4a080e7          	jalr	-182(ra) # 80001128 <myproc>
    800051e6:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800051e8:	fd840593          	addi	a1,s0,-40
    800051ec:	4501                	li	a0,0
    800051ee:	ffffd097          	auipc	ra,0xffffd
    800051f2:	0a0080e7          	jalr	160(ra) # 8000228e <argaddr>
  if (pipealloc(&rf, &wf) < 0) return -1;
    800051f6:	fc840593          	addi	a1,s0,-56
    800051fa:	fd040513          	addi	a0,s0,-48
    800051fe:	fffff097          	auipc	ra,0xfffff
    80005202:	dac080e7          	jalr	-596(ra) # 80003faa <pipealloc>
    80005206:	57fd                	li	a5,-1
    80005208:	0c054463          	bltz	a0,800052d0 <sys_pipe+0xfc>
  fd0 = -1;
    8000520c:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    80005210:	fd043503          	ld	a0,-48(s0)
    80005214:	fffff097          	auipc	ra,0xfffff
    80005218:	514080e7          	jalr	1300(ra) # 80004728 <fdalloc>
    8000521c:	fca42223          	sw	a0,-60(s0)
    80005220:	08054b63          	bltz	a0,800052b6 <sys_pipe+0xe2>
    80005224:	fc843503          	ld	a0,-56(s0)
    80005228:	fffff097          	auipc	ra,0xfffff
    8000522c:	500080e7          	jalr	1280(ra) # 80004728 <fdalloc>
    80005230:	fca42023          	sw	a0,-64(s0)
    80005234:	06054863          	bltz	a0,800052a4 <sys_pipe+0xd0>
    if (fd0 >= 0) p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005238:	4691                	li	a3,4
    8000523a:	fc440613          	addi	a2,s0,-60
    8000523e:	fd843583          	ld	a1,-40(s0)
    80005242:	68a8                	ld	a0,80(s1)
    80005244:	ffffc097          	auipc	ra,0xffffc
    80005248:	cb2080e7          	jalr	-846(ra) # 80000ef6 <copyout>
    8000524c:	02054063          	bltz	a0,8000526c <sys_pipe+0x98>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) <
    80005250:	4691                	li	a3,4
    80005252:	fc040613          	addi	a2,s0,-64
    80005256:	fd843583          	ld	a1,-40(s0)
    8000525a:	0591                	addi	a1,a1,4
    8000525c:	68a8                	ld	a0,80(s1)
    8000525e:	ffffc097          	auipc	ra,0xffffc
    80005262:	c98080e7          	jalr	-872(ra) # 80000ef6 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005266:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005268:	06055463          	bgez	a0,800052d0 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    8000526c:	fc442783          	lw	a5,-60(s0)
    80005270:	07e9                	addi	a5,a5,26
    80005272:	078e                	slli	a5,a5,0x3
    80005274:	97a6                	add	a5,a5,s1
    80005276:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000527a:	fc042783          	lw	a5,-64(s0)
    8000527e:	07e9                	addi	a5,a5,26
    80005280:	078e                	slli	a5,a5,0x3
    80005282:	94be                	add	s1,s1,a5
    80005284:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005288:	fd043503          	ld	a0,-48(s0)
    8000528c:	fffff097          	auipc	ra,0xfffff
    80005290:	9ee080e7          	jalr	-1554(ra) # 80003c7a <fileclose>
    fileclose(wf);
    80005294:	fc843503          	ld	a0,-56(s0)
    80005298:	fffff097          	auipc	ra,0xfffff
    8000529c:	9e2080e7          	jalr	-1566(ra) # 80003c7a <fileclose>
    return -1;
    800052a0:	57fd                	li	a5,-1
    800052a2:	a03d                	j	800052d0 <sys_pipe+0xfc>
    if (fd0 >= 0) p->ofile[fd0] = 0;
    800052a4:	fc442783          	lw	a5,-60(s0)
    800052a8:	0007c763          	bltz	a5,800052b6 <sys_pipe+0xe2>
    800052ac:	07e9                	addi	a5,a5,26
    800052ae:	078e                	slli	a5,a5,0x3
    800052b0:	97a6                	add	a5,a5,s1
    800052b2:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800052b6:	fd043503          	ld	a0,-48(s0)
    800052ba:	fffff097          	auipc	ra,0xfffff
    800052be:	9c0080e7          	jalr	-1600(ra) # 80003c7a <fileclose>
    fileclose(wf);
    800052c2:	fc843503          	ld	a0,-56(s0)
    800052c6:	fffff097          	auipc	ra,0xfffff
    800052ca:	9b4080e7          	jalr	-1612(ra) # 80003c7a <fileclose>
    return -1;
    800052ce:	57fd                	li	a5,-1
}
    800052d0:	853e                	mv	a0,a5
    800052d2:	70e2                	ld	ra,56(sp)
    800052d4:	7442                	ld	s0,48(sp)
    800052d6:	74a2                	ld	s1,40(sp)
    800052d8:	6121                	addi	sp,sp,64
    800052da:	8082                	ret
    800052dc:	0000                	unimp
	...

00000000800052e0 <kernelvec>:
    800052e0:	7111                	addi	sp,sp,-256
    800052e2:	e006                	sd	ra,0(sp)
    800052e4:	e40a                	sd	sp,8(sp)
    800052e6:	e80e                	sd	gp,16(sp)
    800052e8:	ec12                	sd	tp,24(sp)
    800052ea:	f016                	sd	t0,32(sp)
    800052ec:	f41a                	sd	t1,40(sp)
    800052ee:	f81e                	sd	t2,48(sp)
    800052f0:	fc22                	sd	s0,56(sp)
    800052f2:	e0a6                	sd	s1,64(sp)
    800052f4:	e4aa                	sd	a0,72(sp)
    800052f6:	e8ae                	sd	a1,80(sp)
    800052f8:	ecb2                	sd	a2,88(sp)
    800052fa:	f0b6                	sd	a3,96(sp)
    800052fc:	f4ba                	sd	a4,104(sp)
    800052fe:	f8be                	sd	a5,112(sp)
    80005300:	fcc2                	sd	a6,120(sp)
    80005302:	e146                	sd	a7,128(sp)
    80005304:	e54a                	sd	s2,136(sp)
    80005306:	e94e                	sd	s3,144(sp)
    80005308:	ed52                	sd	s4,152(sp)
    8000530a:	f156                	sd	s5,160(sp)
    8000530c:	f55a                	sd	s6,168(sp)
    8000530e:	f95e                	sd	s7,176(sp)
    80005310:	fd62                	sd	s8,184(sp)
    80005312:	e1e6                	sd	s9,192(sp)
    80005314:	e5ea                	sd	s10,200(sp)
    80005316:	e9ee                	sd	s11,208(sp)
    80005318:	edf2                	sd	t3,216(sp)
    8000531a:	f1f6                	sd	t4,224(sp)
    8000531c:	f5fa                	sd	t5,232(sp)
    8000531e:	f9fe                	sd	t6,240(sp)
    80005320:	d7dfc0ef          	jal	ra,8000209c <kerneltrap>
    80005324:	6082                	ld	ra,0(sp)
    80005326:	6122                	ld	sp,8(sp)
    80005328:	61c2                	ld	gp,16(sp)
    8000532a:	7282                	ld	t0,32(sp)
    8000532c:	7322                	ld	t1,40(sp)
    8000532e:	73c2                	ld	t2,48(sp)
    80005330:	7462                	ld	s0,56(sp)
    80005332:	6486                	ld	s1,64(sp)
    80005334:	6526                	ld	a0,72(sp)
    80005336:	65c6                	ld	a1,80(sp)
    80005338:	6666                	ld	a2,88(sp)
    8000533a:	7686                	ld	a3,96(sp)
    8000533c:	7726                	ld	a4,104(sp)
    8000533e:	77c6                	ld	a5,112(sp)
    80005340:	7866                	ld	a6,120(sp)
    80005342:	688a                	ld	a7,128(sp)
    80005344:	692a                	ld	s2,136(sp)
    80005346:	69ca                	ld	s3,144(sp)
    80005348:	6a6a                	ld	s4,152(sp)
    8000534a:	7a8a                	ld	s5,160(sp)
    8000534c:	7b2a                	ld	s6,168(sp)
    8000534e:	7bca                	ld	s7,176(sp)
    80005350:	7c6a                	ld	s8,184(sp)
    80005352:	6c8e                	ld	s9,192(sp)
    80005354:	6d2e                	ld	s10,200(sp)
    80005356:	6dce                	ld	s11,208(sp)
    80005358:	6e6e                	ld	t3,216(sp)
    8000535a:	7e8e                	ld	t4,224(sp)
    8000535c:	7f2e                	ld	t5,232(sp)
    8000535e:	7fce                	ld	t6,240(sp)
    80005360:	6111                	addi	sp,sp,256
    80005362:	10200073          	sret
    80005366:	00000013          	nop
    8000536a:	00000013          	nop
    8000536e:	0001                	nop

0000000080005370 <timervec>:
    80005370:	34051573          	csrrw	a0,mscratch,a0
    80005374:	e10c                	sd	a1,0(a0)
    80005376:	e510                	sd	a2,8(a0)
    80005378:	e914                	sd	a3,16(a0)
    8000537a:	6d0c                	ld	a1,24(a0)
    8000537c:	7110                	ld	a2,32(a0)
    8000537e:	6194                	ld	a3,0(a1)
    80005380:	96b2                	add	a3,a3,a2
    80005382:	e194                	sd	a3,0(a1)
    80005384:	4589                	li	a1,2
    80005386:	14459073          	csrw	sip,a1
    8000538a:	6914                	ld	a3,16(a0)
    8000538c:	6510                	ld	a2,8(a0)
    8000538e:	610c                	ld	a1,0(a0)
    80005390:	34051573          	csrrw	a0,mscratch,a0
    80005394:	30200073          	mret
	...

000000008000539a <plicinit>:

//
// the riscv Platform Level Interrupt Controller (PLIC).
//

void plicinit(void) {
    8000539a:	1141                	addi	sp,sp,-16
    8000539c:	e422                	sd	s0,8(sp)
    8000539e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ * 4) = 1;
    800053a0:	0c0007b7          	lui	a5,0xc000
    800053a4:	4705                	li	a4,1
    800053a6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ * 4) = 1;
    800053a8:	c3d8                	sw	a4,4(a5)
}
    800053aa:	6422                	ld	s0,8(sp)
    800053ac:	0141                	addi	sp,sp,16
    800053ae:	8082                	ret

00000000800053b0 <plicinithart>:

void plicinithart(void) {
    800053b0:	1141                	addi	sp,sp,-16
    800053b2:	e406                	sd	ra,8(sp)
    800053b4:	e022                	sd	s0,0(sp)
    800053b6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053b8:	ffffc097          	auipc	ra,0xffffc
    800053bc:	d44080e7          	jalr	-700(ra) # 800010fc <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800053c0:	0085171b          	slliw	a4,a0,0x8
    800053c4:	0c0027b7          	lui	a5,0xc002
    800053c8:	97ba                	add	a5,a5,a4
    800053ca:	40200713          	li	a4,1026
    800053ce:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800053d2:	00d5151b          	slliw	a0,a0,0xd
    800053d6:	0c2017b7          	lui	a5,0xc201
    800053da:	97aa                	add	a5,a5,a0
    800053dc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800053e0:	60a2                	ld	ra,8(sp)
    800053e2:	6402                	ld	s0,0(sp)
    800053e4:	0141                	addi	sp,sp,16
    800053e6:	8082                	ret

00000000800053e8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int plic_claim(void) {
    800053e8:	1141                	addi	sp,sp,-16
    800053ea:	e406                	sd	ra,8(sp)
    800053ec:	e022                	sd	s0,0(sp)
    800053ee:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053f0:	ffffc097          	auipc	ra,0xffffc
    800053f4:	d0c080e7          	jalr	-756(ra) # 800010fc <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800053f8:	00d5151b          	slliw	a0,a0,0xd
    800053fc:	0c2017b7          	lui	a5,0xc201
    80005400:	97aa                	add	a5,a5,a0
  return irq;
}
    80005402:	43c8                	lw	a0,4(a5)
    80005404:	60a2                	ld	ra,8(sp)
    80005406:	6402                	ld	s0,0(sp)
    80005408:	0141                	addi	sp,sp,16
    8000540a:	8082                	ret

000000008000540c <plic_complete>:

// tell the PLIC we've served this IRQ.
void plic_complete(int irq) {
    8000540c:	1101                	addi	sp,sp,-32
    8000540e:	ec06                	sd	ra,24(sp)
    80005410:	e822                	sd	s0,16(sp)
    80005412:	e426                	sd	s1,8(sp)
    80005414:	1000                	addi	s0,sp,32
    80005416:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005418:	ffffc097          	auipc	ra,0xffffc
    8000541c:	ce4080e7          	jalr	-796(ra) # 800010fc <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005420:	00d5151b          	slliw	a0,a0,0xd
    80005424:	0c2017b7          	lui	a5,0xc201
    80005428:	97aa                	add	a5,a5,a0
    8000542a:	c3c4                	sw	s1,4(a5)
}
    8000542c:	60e2                	ld	ra,24(sp)
    8000542e:	6442                	ld	s0,16(sp)
    80005430:	64a2                	ld	s1,8(sp)
    80005432:	6105                	addi	sp,sp,32
    80005434:	8082                	ret

0000000080005436 <free_desc>:
  }
  return -1;
}

// mark a descriptor as free.
static void free_desc(int i) {
    80005436:	1141                	addi	sp,sp,-16
    80005438:	e406                	sd	ra,8(sp)
    8000543a:	e022                	sd	s0,0(sp)
    8000543c:	0800                	addi	s0,sp,16
  if (i >= NUM) panic("free_desc 1");
    8000543e:	479d                	li	a5,7
    80005440:	04a7cc63          	blt	a5,a0,80005498 <free_desc+0x62>
  if (disk.free[i]) panic("free_desc 2");
    80005444:	00034797          	auipc	a5,0x34
    80005448:	62478793          	addi	a5,a5,1572 # 80039a68 <disk>
    8000544c:	97aa                	add	a5,a5,a0
    8000544e:	0187c783          	lbu	a5,24(a5)
    80005452:	ebb9                	bnez	a5,800054a8 <free_desc+0x72>
  disk.desc[i].addr = 0;
    80005454:	00451693          	slli	a3,a0,0x4
    80005458:	00034797          	auipc	a5,0x34
    8000545c:	61078793          	addi	a5,a5,1552 # 80039a68 <disk>
    80005460:	6398                	ld	a4,0(a5)
    80005462:	9736                	add	a4,a4,a3
    80005464:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005468:	6398                	ld	a4,0(a5)
    8000546a:	9736                	add	a4,a4,a3
    8000546c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005470:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005474:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005478:	97aa                	add	a5,a5,a0
    8000547a:	4705                	li	a4,1
    8000547c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005480:	00034517          	auipc	a0,0x34
    80005484:	60050513          	addi	a0,a0,1536 # 80039a80 <disk+0x18>
    80005488:	ffffc097          	auipc	ra,0xffffc
    8000548c:	3b0080e7          	jalr	944(ra) # 80001838 <wakeup>
}
    80005490:	60a2                	ld	ra,8(sp)
    80005492:	6402                	ld	s0,0(sp)
    80005494:	0141                	addi	sp,sp,16
    80005496:	8082                	ret
  if (i >= NUM) panic("free_desc 1");
    80005498:	00003517          	auipc	a0,0x3
    8000549c:	2a850513          	addi	a0,a0,680 # 80008740 <syscalls+0x2f0>
    800054a0:	00001097          	auipc	ra,0x1
    800054a4:	a0c080e7          	jalr	-1524(ra) # 80005eac <panic>
  if (disk.free[i]) panic("free_desc 2");
    800054a8:	00003517          	auipc	a0,0x3
    800054ac:	2a850513          	addi	a0,a0,680 # 80008750 <syscalls+0x300>
    800054b0:	00001097          	auipc	ra,0x1
    800054b4:	9fc080e7          	jalr	-1540(ra) # 80005eac <panic>

00000000800054b8 <virtio_disk_init>:
void virtio_disk_init(void) {
    800054b8:	1101                	addi	sp,sp,-32
    800054ba:	ec06                	sd	ra,24(sp)
    800054bc:	e822                	sd	s0,16(sp)
    800054be:	e426                	sd	s1,8(sp)
    800054c0:	e04a                	sd	s2,0(sp)
    800054c2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800054c4:	00003597          	auipc	a1,0x3
    800054c8:	29c58593          	addi	a1,a1,668 # 80008760 <syscalls+0x310>
    800054cc:	00034517          	auipc	a0,0x34
    800054d0:	6c450513          	addi	a0,a0,1732 # 80039b90 <disk+0x128>
    800054d4:	00001097          	auipc	ra,0x1
    800054d8:	e80080e7          	jalr	-384(ra) # 80006354 <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054dc:	100017b7          	lui	a5,0x10001
    800054e0:	4398                	lw	a4,0(a5)
    800054e2:	2701                	sext.w	a4,a4
    800054e4:	747277b7          	lui	a5,0x74727
    800054e8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800054ec:	14f71b63          	bne	a4,a5,80005642 <virtio_disk_init+0x18a>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054f0:	100017b7          	lui	a5,0x10001
    800054f4:	43dc                	lw	a5,4(a5)
    800054f6:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054f8:	4709                	li	a4,2
    800054fa:	14e79463          	bne	a5,a4,80005642 <virtio_disk_init+0x18a>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054fe:	100017b7          	lui	a5,0x10001
    80005502:	479c                	lw	a5,8(a5)
    80005504:	2781                	sext.w	a5,a5
    80005506:	12e79e63          	bne	a5,a4,80005642 <virtio_disk_init+0x18a>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    8000550a:	100017b7          	lui	a5,0x10001
    8000550e:	47d8                	lw	a4,12(a5)
    80005510:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005512:	554d47b7          	lui	a5,0x554d4
    80005516:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000551a:	12f71463          	bne	a4,a5,80005642 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000551e:	100017b7          	lui	a5,0x10001
    80005522:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005526:	4705                	li	a4,1
    80005528:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000552a:	470d                	li	a4,3
    8000552c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000552e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005530:	c7ffe6b7          	lui	a3,0xc7ffe
    80005534:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fbc96f>
    80005538:	8f75                	and	a4,a4,a3
    8000553a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000553c:	472d                	li	a4,11
    8000553e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005540:	5bbc                	lw	a5,112(a5)
    80005542:	0007891b          	sext.w	s2,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005546:	8ba1                	andi	a5,a5,8
    80005548:	10078563          	beqz	a5,80005652 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000554c:	100017b7          	lui	a5,0x10001
    80005550:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY)) panic("virtio disk should not be ready");
    80005554:	43fc                	lw	a5,68(a5)
    80005556:	2781                	sext.w	a5,a5
    80005558:	10079563          	bnez	a5,80005662 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000555c:	100017b7          	lui	a5,0x10001
    80005560:	5bdc                	lw	a5,52(a5)
    80005562:	2781                	sext.w	a5,a5
  if (max == 0) panic("virtio disk has no queue 0");
    80005564:	10078763          	beqz	a5,80005672 <virtio_disk_init+0x1ba>
  if (max < NUM) panic("virtio disk max queue too short");
    80005568:	471d                	li	a4,7
    8000556a:	10f77c63          	bgeu	a4,a5,80005682 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000556e:	ffffb097          	auipc	ra,0xffffb
    80005572:	c34080e7          	jalr	-972(ra) # 800001a2 <kalloc>
    80005576:	00034497          	auipc	s1,0x34
    8000557a:	4f248493          	addi	s1,s1,1266 # 80039a68 <disk>
    8000557e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005580:	ffffb097          	auipc	ra,0xffffb
    80005584:	c22080e7          	jalr	-990(ra) # 800001a2 <kalloc>
    80005588:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000558a:	ffffb097          	auipc	ra,0xffffb
    8000558e:	c18080e7          	jalr	-1000(ra) # 800001a2 <kalloc>
    80005592:	87aa                	mv	a5,a0
    80005594:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used) panic("virtio disk kalloc");
    80005596:	6088                	ld	a0,0(s1)
    80005598:	cd6d                	beqz	a0,80005692 <virtio_disk_init+0x1da>
    8000559a:	00034717          	auipc	a4,0x34
    8000559e:	4d673703          	ld	a4,1238(a4) # 80039a70 <disk+0x8>
    800055a2:	cb65                	beqz	a4,80005692 <virtio_disk_init+0x1da>
    800055a4:	c7fd                	beqz	a5,80005692 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    800055a6:	6605                	lui	a2,0x1
    800055a8:	4581                	li	a1,0
    800055aa:	ffffb097          	auipc	ra,0xffffb
    800055ae:	c72080e7          	jalr	-910(ra) # 8000021c <memset>
  memset(disk.avail, 0, PGSIZE);
    800055b2:	00034497          	auipc	s1,0x34
    800055b6:	4b648493          	addi	s1,s1,1206 # 80039a68 <disk>
    800055ba:	6605                	lui	a2,0x1
    800055bc:	4581                	li	a1,0
    800055be:	6488                	ld	a0,8(s1)
    800055c0:	ffffb097          	auipc	ra,0xffffb
    800055c4:	c5c080e7          	jalr	-932(ra) # 8000021c <memset>
  memset(disk.used, 0, PGSIZE);
    800055c8:	6605                	lui	a2,0x1
    800055ca:	4581                	li	a1,0
    800055cc:	6888                	ld	a0,16(s1)
    800055ce:	ffffb097          	auipc	ra,0xffffb
    800055d2:	c4e080e7          	jalr	-946(ra) # 8000021c <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800055d6:	100017b7          	lui	a5,0x10001
    800055da:	4721                	li	a4,8
    800055dc:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800055de:	4098                	lw	a4,0(s1)
    800055e0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800055e4:	40d8                	lw	a4,4(s1)
    800055e6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800055ea:	6498                	ld	a4,8(s1)
    800055ec:	0007069b          	sext.w	a3,a4
    800055f0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800055f4:	9701                	srai	a4,a4,0x20
    800055f6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800055fa:	6898                	ld	a4,16(s1)
    800055fc:	0007069b          	sext.w	a3,a4
    80005600:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005604:	9701                	srai	a4,a4,0x20
    80005606:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000560a:	4705                	li	a4,1
    8000560c:	c3f8                	sw	a4,68(a5)
  for (int i = 0; i < NUM; i++) disk.free[i] = 1;
    8000560e:	00e48c23          	sb	a4,24(s1)
    80005612:	00e48ca3          	sb	a4,25(s1)
    80005616:	00e48d23          	sb	a4,26(s1)
    8000561a:	00e48da3          	sb	a4,27(s1)
    8000561e:	00e48e23          	sb	a4,28(s1)
    80005622:	00e48ea3          	sb	a4,29(s1)
    80005626:	00e48f23          	sb	a4,30(s1)
    8000562a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000562e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005632:	0727a823          	sw	s2,112(a5)
}
    80005636:	60e2                	ld	ra,24(sp)
    80005638:	6442                	ld	s0,16(sp)
    8000563a:	64a2                	ld	s1,8(sp)
    8000563c:	6902                	ld	s2,0(sp)
    8000563e:	6105                	addi	sp,sp,32
    80005640:	8082                	ret
    panic("could not find virtio disk");
    80005642:	00003517          	auipc	a0,0x3
    80005646:	12e50513          	addi	a0,a0,302 # 80008770 <syscalls+0x320>
    8000564a:	00001097          	auipc	ra,0x1
    8000564e:	862080e7          	jalr	-1950(ra) # 80005eac <panic>
    panic("virtio disk FEATURES_OK unset");
    80005652:	00003517          	auipc	a0,0x3
    80005656:	13e50513          	addi	a0,a0,318 # 80008790 <syscalls+0x340>
    8000565a:	00001097          	auipc	ra,0x1
    8000565e:	852080e7          	jalr	-1966(ra) # 80005eac <panic>
  if (*R(VIRTIO_MMIO_QUEUE_READY)) panic("virtio disk should not be ready");
    80005662:	00003517          	auipc	a0,0x3
    80005666:	14e50513          	addi	a0,a0,334 # 800087b0 <syscalls+0x360>
    8000566a:	00001097          	auipc	ra,0x1
    8000566e:	842080e7          	jalr	-1982(ra) # 80005eac <panic>
  if (max == 0) panic("virtio disk has no queue 0");
    80005672:	00003517          	auipc	a0,0x3
    80005676:	15e50513          	addi	a0,a0,350 # 800087d0 <syscalls+0x380>
    8000567a:	00001097          	auipc	ra,0x1
    8000567e:	832080e7          	jalr	-1998(ra) # 80005eac <panic>
  if (max < NUM) panic("virtio disk max queue too short");
    80005682:	00003517          	auipc	a0,0x3
    80005686:	16e50513          	addi	a0,a0,366 # 800087f0 <syscalls+0x3a0>
    8000568a:	00001097          	auipc	ra,0x1
    8000568e:	822080e7          	jalr	-2014(ra) # 80005eac <panic>
  if (!disk.desc || !disk.avail || !disk.used) panic("virtio disk kalloc");
    80005692:	00003517          	auipc	a0,0x3
    80005696:	17e50513          	addi	a0,a0,382 # 80008810 <syscalls+0x3c0>
    8000569a:	00001097          	auipc	ra,0x1
    8000569e:	812080e7          	jalr	-2030(ra) # 80005eac <panic>

00000000800056a2 <virtio_disk_rw>:
    }
  }
  return 0;
}

void virtio_disk_rw(struct buf *b, int write) {
    800056a2:	7119                	addi	sp,sp,-128
    800056a4:	fc86                	sd	ra,120(sp)
    800056a6:	f8a2                	sd	s0,112(sp)
    800056a8:	f4a6                	sd	s1,104(sp)
    800056aa:	f0ca                	sd	s2,96(sp)
    800056ac:	ecce                	sd	s3,88(sp)
    800056ae:	e8d2                	sd	s4,80(sp)
    800056b0:	e4d6                	sd	s5,72(sp)
    800056b2:	e0da                	sd	s6,64(sp)
    800056b4:	fc5e                	sd	s7,56(sp)
    800056b6:	f862                	sd	s8,48(sp)
    800056b8:	f466                	sd	s9,40(sp)
    800056ba:	f06a                	sd	s10,32(sp)
    800056bc:	ec6e                	sd	s11,24(sp)
    800056be:	0100                	addi	s0,sp,128
    800056c0:	8aaa                	mv	s5,a0
    800056c2:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800056c4:	00c52d03          	lw	s10,12(a0)
    800056c8:	001d1d1b          	slliw	s10,s10,0x1
    800056cc:	1d02                	slli	s10,s10,0x20
    800056ce:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    800056d2:	00034517          	auipc	a0,0x34
    800056d6:	4be50513          	addi	a0,a0,1214 # 80039b90 <disk+0x128>
    800056da:	00001097          	auipc	ra,0x1
    800056de:	d0a080e7          	jalr	-758(ra) # 800063e4 <acquire>
  for (int i = 0; i < 3; i++) {
    800056e2:	4981                	li	s3,0
  for (int i = 0; i < NUM; i++) {
    800056e4:	44a1                	li	s1,8
      disk.free[i] = 0;
    800056e6:	00034b97          	auipc	s7,0x34
    800056ea:	382b8b93          	addi	s7,s7,898 # 80039a68 <disk>
  for (int i = 0; i < 3; i++) {
    800056ee:	4b0d                	li	s6,3
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056f0:	00034c97          	auipc	s9,0x34
    800056f4:	4a0c8c93          	addi	s9,s9,1184 # 80039b90 <disk+0x128>
    800056f8:	a08d                	j	8000575a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800056fa:	00fb8733          	add	a4,s7,a5
    800056fe:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005702:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    80005704:	0207c563          	bltz	a5,8000572e <virtio_disk_rw+0x8c>
  for (int i = 0; i < 3; i++) {
    80005708:	2905                	addiw	s2,s2,1
    8000570a:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000570c:	05690c63          	beq	s2,s6,80005764 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80005710:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    80005712:	00034717          	auipc	a4,0x34
    80005716:	35670713          	addi	a4,a4,854 # 80039a68 <disk>
    8000571a:	87ce                	mv	a5,s3
    if (disk.free[i]) {
    8000571c:	01874683          	lbu	a3,24(a4)
    80005720:	fee9                	bnez	a3,800056fa <virtio_disk_rw+0x58>
  for (int i = 0; i < NUM; i++) {
    80005722:	2785                	addiw	a5,a5,1
    80005724:	0705                	addi	a4,a4,1
    80005726:	fe979be3          	bne	a5,s1,8000571c <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000572a:	57fd                	li	a5,-1
    8000572c:	c19c                	sw	a5,0(a1)
      for (int j = 0; j < i; j++) free_desc(idx[j]);
    8000572e:	01205d63          	blez	s2,80005748 <virtio_disk_rw+0xa6>
    80005732:	8dce                	mv	s11,s3
    80005734:	000a2503          	lw	a0,0(s4)
    80005738:	00000097          	auipc	ra,0x0
    8000573c:	cfe080e7          	jalr	-770(ra) # 80005436 <free_desc>
    80005740:	2d85                	addiw	s11,s11,1
    80005742:	0a11                	addi	s4,s4,4
    80005744:	ff2d98e3          	bne	s11,s2,80005734 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005748:	85e6                	mv	a1,s9
    8000574a:	00034517          	auipc	a0,0x34
    8000574e:	33650513          	addi	a0,a0,822 # 80039a80 <disk+0x18>
    80005752:	ffffc097          	auipc	ra,0xffffc
    80005756:	082080e7          	jalr	130(ra) # 800017d4 <sleep>
  for (int i = 0; i < 3; i++) {
    8000575a:	f8040a13          	addi	s4,s0,-128
void virtio_disk_rw(struct buf *b, int write) {
    8000575e:	8652                	mv	a2,s4
  for (int i = 0; i < 3; i++) {
    80005760:	894e                	mv	s2,s3
    80005762:	b77d                	j	80005710 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005764:	f8042503          	lw	a0,-128(s0)
    80005768:	00a50713          	addi	a4,a0,10
    8000576c:	0712                	slli	a4,a4,0x4

  if (write)
    8000576e:	00034797          	auipc	a5,0x34
    80005772:	2fa78793          	addi	a5,a5,762 # 80039a68 <disk>
    80005776:	00e786b3          	add	a3,a5,a4
    8000577a:	01803633          	snez	a2,s8
    8000577e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT;  // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN;  // read the disk
  buf0->reserved = 0;
    80005780:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005784:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64)buf0;
    80005788:	f6070613          	addi	a2,a4,-160
    8000578c:	6394                	ld	a3,0(a5)
    8000578e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005790:	00870593          	addi	a1,a4,8
    80005794:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    80005796:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005798:	0007b803          	ld	a6,0(a5)
    8000579c:	9642                	add	a2,a2,a6
    8000579e:	46c1                	li	a3,16
    800057a0:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800057a2:	4585                	li	a1,1
    800057a4:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    800057a8:	f8442683          	lw	a3,-124(s0)
    800057ac:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64)b->data;
    800057b0:	0692                	slli	a3,a3,0x4
    800057b2:	9836                	add	a6,a6,a3
    800057b4:	058a8613          	addi	a2,s5,88
    800057b8:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    800057bc:	0007b803          	ld	a6,0(a5)
    800057c0:	96c2                	add	a3,a3,a6
    800057c2:	40000613          	li	a2,1024
    800057c6:	c690                	sw	a2,8(a3)
  if (write)
    800057c8:	001c3613          	seqz	a2,s8
    800057cc:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0;  // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE;  // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800057d0:	00166613          	ori	a2,a2,1
    800057d4:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800057d8:	f8842603          	lw	a2,-120(s0)
    800057dc:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff;  // device writes 0 on success
    800057e0:	00250693          	addi	a3,a0,2
    800057e4:	0692                	slli	a3,a3,0x4
    800057e6:	96be                	add	a3,a3,a5
    800057e8:	58fd                	li	a7,-1
    800057ea:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    800057ee:	0612                	slli	a2,a2,0x4
    800057f0:	9832                	add	a6,a6,a2
    800057f2:	f9070713          	addi	a4,a4,-112
    800057f6:	973e                	add	a4,a4,a5
    800057f8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800057fc:	6398                	ld	a4,0(a5)
    800057fe:	9732                	add	a4,a4,a2
    80005800:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE;  // device writes the status
    80005802:	4609                	li	a2,2
    80005804:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005808:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000580c:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80005810:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005814:	6794                	ld	a3,8(a5)
    80005816:	0026d703          	lhu	a4,2(a3)
    8000581a:	8b1d                	andi	a4,a4,7
    8000581c:	0706                	slli	a4,a4,0x1
    8000581e:	96ba                	add	a3,a3,a4
    80005820:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005824:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1;  // not % NUM ...
    80005828:	6798                	ld	a4,8(a5)
    8000582a:	00275783          	lhu	a5,2(a4)
    8000582e:	2785                	addiw	a5,a5,1
    80005830:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005834:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0;  // value is queue number
    80005838:	100017b7          	lui	a5,0x10001
    8000583c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    80005840:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    80005844:	00034917          	auipc	s2,0x34
    80005848:	34c90913          	addi	s2,s2,844 # 80039b90 <disk+0x128>
  while (b->disk == 1) {
    8000584c:	4485                	li	s1,1
    8000584e:	00b79c63          	bne	a5,a1,80005866 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005852:	85ca                	mv	a1,s2
    80005854:	8556                	mv	a0,s5
    80005856:	ffffc097          	auipc	ra,0xffffc
    8000585a:	f7e080e7          	jalr	-130(ra) # 800017d4 <sleep>
  while (b->disk == 1) {
    8000585e:	004aa783          	lw	a5,4(s5)
    80005862:	fe9788e3          	beq	a5,s1,80005852 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005866:	f8042903          	lw	s2,-128(s0)
    8000586a:	00290713          	addi	a4,s2,2
    8000586e:	0712                	slli	a4,a4,0x4
    80005870:	00034797          	auipc	a5,0x34
    80005874:	1f878793          	addi	a5,a5,504 # 80039a68 <disk>
    80005878:	97ba                	add	a5,a5,a4
    8000587a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000587e:	00034997          	auipc	s3,0x34
    80005882:	1ea98993          	addi	s3,s3,490 # 80039a68 <disk>
    80005886:	00491713          	slli	a4,s2,0x4
    8000588a:	0009b783          	ld	a5,0(s3)
    8000588e:	97ba                	add	a5,a5,a4
    80005890:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005894:	854a                	mv	a0,s2
    80005896:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000589a:	00000097          	auipc	ra,0x0
    8000589e:	b9c080e7          	jalr	-1124(ra) # 80005436 <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    800058a2:	8885                	andi	s1,s1,1
    800058a4:	f0ed                	bnez	s1,80005886 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800058a6:	00034517          	auipc	a0,0x34
    800058aa:	2ea50513          	addi	a0,a0,746 # 80039b90 <disk+0x128>
    800058ae:	00001097          	auipc	ra,0x1
    800058b2:	bea080e7          	jalr	-1046(ra) # 80006498 <release>
}
    800058b6:	70e6                	ld	ra,120(sp)
    800058b8:	7446                	ld	s0,112(sp)
    800058ba:	74a6                	ld	s1,104(sp)
    800058bc:	7906                	ld	s2,96(sp)
    800058be:	69e6                	ld	s3,88(sp)
    800058c0:	6a46                	ld	s4,80(sp)
    800058c2:	6aa6                	ld	s5,72(sp)
    800058c4:	6b06                	ld	s6,64(sp)
    800058c6:	7be2                	ld	s7,56(sp)
    800058c8:	7c42                	ld	s8,48(sp)
    800058ca:	7ca2                	ld	s9,40(sp)
    800058cc:	7d02                	ld	s10,32(sp)
    800058ce:	6de2                	ld	s11,24(sp)
    800058d0:	6109                	addi	sp,sp,128
    800058d2:	8082                	ret

00000000800058d4 <virtio_disk_intr>:

void virtio_disk_intr() {
    800058d4:	1101                	addi	sp,sp,-32
    800058d6:	ec06                	sd	ra,24(sp)
    800058d8:	e822                	sd	s0,16(sp)
    800058da:	e426                	sd	s1,8(sp)
    800058dc:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800058de:	00034497          	auipc	s1,0x34
    800058e2:	18a48493          	addi	s1,s1,394 # 80039a68 <disk>
    800058e6:	00034517          	auipc	a0,0x34
    800058ea:	2aa50513          	addi	a0,a0,682 # 80039b90 <disk+0x128>
    800058ee:	00001097          	auipc	ra,0x1
    800058f2:	af6080e7          	jalr	-1290(ra) # 800063e4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800058f6:	10001737          	lui	a4,0x10001
    800058fa:	533c                	lw	a5,96(a4)
    800058fc:	8b8d                	andi	a5,a5,3
    800058fe:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005900:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    80005904:	689c                	ld	a5,16(s1)
    80005906:	0204d703          	lhu	a4,32(s1)
    8000590a:	0027d783          	lhu	a5,2(a5)
    8000590e:	04f70863          	beq	a4,a5,8000595e <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005912:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005916:	6898                	ld	a4,16(s1)
    80005918:	0204d783          	lhu	a5,32(s1)
    8000591c:	8b9d                	andi	a5,a5,7
    8000591e:	078e                	slli	a5,a5,0x3
    80005920:	97ba                	add	a5,a5,a4
    80005922:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0) panic("virtio_disk_intr status");
    80005924:	00278713          	addi	a4,a5,2
    80005928:	0712                	slli	a4,a4,0x4
    8000592a:	9726                	add	a4,a4,s1
    8000592c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005930:	e721                	bnez	a4,80005978 <virtio_disk_intr+0xa4>

    struct buf *b = disk.info[id].b;
    80005932:	0789                	addi	a5,a5,2
    80005934:	0792                	slli	a5,a5,0x4
    80005936:	97a6                	add	a5,a5,s1
    80005938:	6788                	ld	a0,8(a5)
    b->disk = 0;  // disk is done with buf
    8000593a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000593e:	ffffc097          	auipc	ra,0xffffc
    80005942:	efa080e7          	jalr	-262(ra) # 80001838 <wakeup>

    disk.used_idx += 1;
    80005946:	0204d783          	lhu	a5,32(s1)
    8000594a:	2785                	addiw	a5,a5,1
    8000594c:	17c2                	slli	a5,a5,0x30
    8000594e:	93c1                	srli	a5,a5,0x30
    80005950:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    80005954:	6898                	ld	a4,16(s1)
    80005956:	00275703          	lhu	a4,2(a4)
    8000595a:	faf71ce3          	bne	a4,a5,80005912 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000595e:	00034517          	auipc	a0,0x34
    80005962:	23250513          	addi	a0,a0,562 # 80039b90 <disk+0x128>
    80005966:	00001097          	auipc	ra,0x1
    8000596a:	b32080e7          	jalr	-1230(ra) # 80006498 <release>
}
    8000596e:	60e2                	ld	ra,24(sp)
    80005970:	6442                	ld	s0,16(sp)
    80005972:	64a2                	ld	s1,8(sp)
    80005974:	6105                	addi	sp,sp,32
    80005976:	8082                	ret
    if (disk.info[id].status != 0) panic("virtio_disk_intr status");
    80005978:	00003517          	auipc	a0,0x3
    8000597c:	eb050513          	addi	a0,a0,-336 # 80008828 <syscalls+0x3d8>
    80005980:	00000097          	auipc	ra,0x0
    80005984:	52c080e7          	jalr	1324(ra) # 80005eac <panic>

0000000080005988 <timerinit>:
// arrange to receive timer interrupts.
// they will arrive in machine mode at
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void timerinit() {
    80005988:	1141                	addi	sp,sp,-16
    8000598a:	e422                	sd	s0,8(sp)
    8000598c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r"(x));
    8000598e:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005992:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000;  // cycles; about 1/10th second in qemu.
  *(uint64 *)CLINT_MTIMECMP(id) = *(uint64 *)CLINT_MTIME + interval;
    80005996:	0037979b          	slliw	a5,a5,0x3
    8000599a:	02004737          	lui	a4,0x2004
    8000599e:	97ba                	add	a5,a5,a4
    800059a0:	0200c737          	lui	a4,0x200c
    800059a4:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800059a8:	000f4637          	lui	a2,0xf4
    800059ac:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800059b0:	9732                	add	a4,a4,a2
    800059b2:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800059b4:	00259693          	slli	a3,a1,0x2
    800059b8:	96ae                	add	a3,a3,a1
    800059ba:	068e                	slli	a3,a3,0x3
    800059bc:	00034717          	auipc	a4,0x34
    800059c0:	1f470713          	addi	a4,a4,500 # 80039bb0 <timer_scratch>
    800059c4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800059c6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800059c8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r"(x));
    800059ca:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r"(x));
    800059ce:	00000797          	auipc	a5,0x0
    800059d2:	9a278793          	addi	a5,a5,-1630 # 80005370 <timervec>
    800059d6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r"(x));
    800059da:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800059de:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r"(x));
    800059e2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r"(x));
    800059e6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800059ea:	0807e793          	ori	a5,a5,128
static inline void w_mie(uint64 x) { asm volatile("csrw mie, %0" : : "r"(x)); }
    800059ee:	30479073          	csrw	mie,a5
}
    800059f2:	6422                	ld	s0,8(sp)
    800059f4:	0141                	addi	sp,sp,16
    800059f6:	8082                	ret

00000000800059f8 <start>:
void start() {
    800059f8:	1141                	addi	sp,sp,-16
    800059fa:	e406                	sd	ra,8(sp)
    800059fc:	e022                	sd	s0,0(sp)
    800059fe:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80005a00:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005a04:	7779                	lui	a4,0xffffe
    80005a06:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffbca0f>
    80005a0a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005a0c:	6705                	lui	a4,0x1
    80005a0e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005a12:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80005a14:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    80005a18:	ffffb797          	auipc	a5,0xffffb
    80005a1c:	9aa78793          	addi	a5,a5,-1622 # 800003c2 <main>
    80005a20:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    80005a24:	4781                	li	a5,0
    80005a26:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    80005a2a:	67c1                	lui	a5,0x10
    80005a2c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005a2e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    80005a32:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    80005a36:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005a3a:	2227e793          	ori	a5,a5,546
static inline void w_sie(uint64 x) { asm volatile("csrw sie, %0" : : "r"(x)); }
    80005a3e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    80005a42:	57fd                	li	a5,-1
    80005a44:	83a9                	srli	a5,a5,0xa
    80005a46:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    80005a4a:	47bd                	li	a5,15
    80005a4c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005a50:	00000097          	auipc	ra,0x0
    80005a54:	f38080e7          	jalr	-200(ra) # 80005988 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    80005a58:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005a5c:	2781                	sext.w	a5,a5
static inline void w_tp(uint64 x) { asm volatile("mv tp, %0" : : "r"(x)); }
    80005a5e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005a60:	30200073          	mret
}
    80005a64:	60a2                	ld	ra,8(sp)
    80005a66:	6402                	ld	s0,0(sp)
    80005a68:	0141                	addi	sp,sp,16
    80005a6a:	8082                	ret

0000000080005a6c <consolewrite>:
} cons;

//
// user write()s to the console go here.
//
int consolewrite(int user_src, uint64 src, int n) {
    80005a6c:	715d                	addi	sp,sp,-80
    80005a6e:	e486                	sd	ra,72(sp)
    80005a70:	e0a2                	sd	s0,64(sp)
    80005a72:	fc26                	sd	s1,56(sp)
    80005a74:	f84a                	sd	s2,48(sp)
    80005a76:	f44e                	sd	s3,40(sp)
    80005a78:	f052                	sd	s4,32(sp)
    80005a7a:	ec56                	sd	s5,24(sp)
    80005a7c:	0880                	addi	s0,sp,80
  int i;

  for (i = 0; i < n; i++) {
    80005a7e:	04c05763          	blez	a2,80005acc <consolewrite+0x60>
    80005a82:	8a2a                	mv	s4,a0
    80005a84:	84ae                	mv	s1,a1
    80005a86:	89b2                	mv	s3,a2
    80005a88:	4901                	li	s2,0
    char c;
    if (either_copyin(&c, user_src, src + i, 1) == -1) break;
    80005a8a:	5afd                	li	s5,-1
    80005a8c:	4685                	li	a3,1
    80005a8e:	8626                	mv	a2,s1
    80005a90:	85d2                	mv	a1,s4
    80005a92:	fbf40513          	addi	a0,s0,-65
    80005a96:	ffffc097          	auipc	ra,0xffffc
    80005a9a:	19c080e7          	jalr	412(ra) # 80001c32 <either_copyin>
    80005a9e:	01550d63          	beq	a0,s5,80005ab8 <consolewrite+0x4c>
    uartputc(c);
    80005aa2:	fbf44503          	lbu	a0,-65(s0)
    80005aa6:	00000097          	auipc	ra,0x0
    80005aaa:	784080e7          	jalr	1924(ra) # 8000622a <uartputc>
  for (i = 0; i < n; i++) {
    80005aae:	2905                	addiw	s2,s2,1
    80005ab0:	0485                	addi	s1,s1,1
    80005ab2:	fd299de3          	bne	s3,s2,80005a8c <consolewrite+0x20>
    80005ab6:	894e                	mv	s2,s3
  }

  return i;
}
    80005ab8:	854a                	mv	a0,s2
    80005aba:	60a6                	ld	ra,72(sp)
    80005abc:	6406                	ld	s0,64(sp)
    80005abe:	74e2                	ld	s1,56(sp)
    80005ac0:	7942                	ld	s2,48(sp)
    80005ac2:	79a2                	ld	s3,40(sp)
    80005ac4:	7a02                	ld	s4,32(sp)
    80005ac6:	6ae2                	ld	s5,24(sp)
    80005ac8:	6161                	addi	sp,sp,80
    80005aca:	8082                	ret
  for (i = 0; i < n; i++) {
    80005acc:	4901                	li	s2,0
    80005ace:	b7ed                	j	80005ab8 <consolewrite+0x4c>

0000000080005ad0 <consoleread>:
// user read()s from the console go here.
// copy (up to) a whole input line to dst.
// user_dist indicates whether dst is a user
// or kernel address.
//
int consoleread(int user_dst, uint64 dst, int n) {
    80005ad0:	7159                	addi	sp,sp,-112
    80005ad2:	f486                	sd	ra,104(sp)
    80005ad4:	f0a2                	sd	s0,96(sp)
    80005ad6:	eca6                	sd	s1,88(sp)
    80005ad8:	e8ca                	sd	s2,80(sp)
    80005ada:	e4ce                	sd	s3,72(sp)
    80005adc:	e0d2                	sd	s4,64(sp)
    80005ade:	fc56                	sd	s5,56(sp)
    80005ae0:	f85a                	sd	s6,48(sp)
    80005ae2:	f45e                	sd	s7,40(sp)
    80005ae4:	f062                	sd	s8,32(sp)
    80005ae6:	ec66                	sd	s9,24(sp)
    80005ae8:	e86a                	sd	s10,16(sp)
    80005aea:	1880                	addi	s0,sp,112
    80005aec:	8aaa                	mv	s5,a0
    80005aee:	8a2e                	mv	s4,a1
    80005af0:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005af2:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005af6:	0003c517          	auipc	a0,0x3c
    80005afa:	1fa50513          	addi	a0,a0,506 # 80041cf0 <cons>
    80005afe:	00001097          	auipc	ra,0x1
    80005b02:	8e6080e7          	jalr	-1818(ra) # 800063e4 <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    80005b06:	0003c497          	auipc	s1,0x3c
    80005b0a:	1ea48493          	addi	s1,s1,490 # 80041cf0 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005b0e:	0003c917          	auipc	s2,0x3c
    80005b12:	27a90913          	addi	s2,s2,634 # 80041d88 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if (c == C('D')) {  // end-of-file
    80005b16:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1) break;
    80005b18:	5c7d                	li	s8,-1

    dst++;
    --n;

    if (c == '\n') {
    80005b1a:	4ca9                	li	s9,10
  while (n > 0) {
    80005b1c:	07305b63          	blez	s3,80005b92 <consoleread+0xc2>
    while (cons.r == cons.w) {
    80005b20:	0984a783          	lw	a5,152(s1)
    80005b24:	09c4a703          	lw	a4,156(s1)
    80005b28:	02f71763          	bne	a4,a5,80005b56 <consoleread+0x86>
      if (killed(myproc())) {
    80005b2c:	ffffb097          	auipc	ra,0xffffb
    80005b30:	5fc080e7          	jalr	1532(ra) # 80001128 <myproc>
    80005b34:	ffffc097          	auipc	ra,0xffffc
    80005b38:	f48080e7          	jalr	-184(ra) # 80001a7c <killed>
    80005b3c:	e535                	bnez	a0,80005ba8 <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    80005b3e:	85a6                	mv	a1,s1
    80005b40:	854a                	mv	a0,s2
    80005b42:	ffffc097          	auipc	ra,0xffffc
    80005b46:	c92080e7          	jalr	-878(ra) # 800017d4 <sleep>
    while (cons.r == cons.w) {
    80005b4a:	0984a783          	lw	a5,152(s1)
    80005b4e:	09c4a703          	lw	a4,156(s1)
    80005b52:	fcf70de3          	beq	a4,a5,80005b2c <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005b56:	0017871b          	addiw	a4,a5,1
    80005b5a:	08e4ac23          	sw	a4,152(s1)
    80005b5e:	07f7f713          	andi	a4,a5,127
    80005b62:	9726                	add	a4,a4,s1
    80005b64:	01874703          	lbu	a4,24(a4)
    80005b68:	00070d1b          	sext.w	s10,a4
    if (c == C('D')) {  // end-of-file
    80005b6c:	077d0563          	beq	s10,s7,80005bd6 <consoleread+0x106>
    cbuf = c;
    80005b70:	f8e40fa3          	sb	a4,-97(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1) break;
    80005b74:	4685                	li	a3,1
    80005b76:	f9f40613          	addi	a2,s0,-97
    80005b7a:	85d2                	mv	a1,s4
    80005b7c:	8556                	mv	a0,s5
    80005b7e:	ffffc097          	auipc	ra,0xffffc
    80005b82:	05e080e7          	jalr	94(ra) # 80001bdc <either_copyout>
    80005b86:	01850663          	beq	a0,s8,80005b92 <consoleread+0xc2>
    dst++;
    80005b8a:	0a05                	addi	s4,s4,1
    --n;
    80005b8c:	39fd                	addiw	s3,s3,-1
    if (c == '\n') {
    80005b8e:	f99d17e3          	bne	s10,s9,80005b1c <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005b92:	0003c517          	auipc	a0,0x3c
    80005b96:	15e50513          	addi	a0,a0,350 # 80041cf0 <cons>
    80005b9a:	00001097          	auipc	ra,0x1
    80005b9e:	8fe080e7          	jalr	-1794(ra) # 80006498 <release>

  return target - n;
    80005ba2:	413b053b          	subw	a0,s6,s3
    80005ba6:	a811                	j	80005bba <consoleread+0xea>
        release(&cons.lock);
    80005ba8:	0003c517          	auipc	a0,0x3c
    80005bac:	14850513          	addi	a0,a0,328 # 80041cf0 <cons>
    80005bb0:	00001097          	auipc	ra,0x1
    80005bb4:	8e8080e7          	jalr	-1816(ra) # 80006498 <release>
        return -1;
    80005bb8:	557d                	li	a0,-1
}
    80005bba:	70a6                	ld	ra,104(sp)
    80005bbc:	7406                	ld	s0,96(sp)
    80005bbe:	64e6                	ld	s1,88(sp)
    80005bc0:	6946                	ld	s2,80(sp)
    80005bc2:	69a6                	ld	s3,72(sp)
    80005bc4:	6a06                	ld	s4,64(sp)
    80005bc6:	7ae2                	ld	s5,56(sp)
    80005bc8:	7b42                	ld	s6,48(sp)
    80005bca:	7ba2                	ld	s7,40(sp)
    80005bcc:	7c02                	ld	s8,32(sp)
    80005bce:	6ce2                	ld	s9,24(sp)
    80005bd0:	6d42                	ld	s10,16(sp)
    80005bd2:	6165                	addi	sp,sp,112
    80005bd4:	8082                	ret
      if (n < target) {
    80005bd6:	0009871b          	sext.w	a4,s3
    80005bda:	fb677ce3          	bgeu	a4,s6,80005b92 <consoleread+0xc2>
        cons.r--;
    80005bde:	0003c717          	auipc	a4,0x3c
    80005be2:	1af72523          	sw	a5,426(a4) # 80041d88 <cons+0x98>
    80005be6:	b775                	j	80005b92 <consoleread+0xc2>

0000000080005be8 <consputc>:
void consputc(int c) {
    80005be8:	1141                	addi	sp,sp,-16
    80005bea:	e406                	sd	ra,8(sp)
    80005bec:	e022                	sd	s0,0(sp)
    80005bee:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    80005bf0:	10000793          	li	a5,256
    80005bf4:	00f50a63          	beq	a0,a5,80005c08 <consputc+0x20>
    uartputc_sync(c);
    80005bf8:	00000097          	auipc	ra,0x0
    80005bfc:	560080e7          	jalr	1376(ra) # 80006158 <uartputc_sync>
}
    80005c00:	60a2                	ld	ra,8(sp)
    80005c02:	6402                	ld	s0,0(sp)
    80005c04:	0141                	addi	sp,sp,16
    80005c06:	8082                	ret
    uartputc_sync('\b');
    80005c08:	4521                	li	a0,8
    80005c0a:	00000097          	auipc	ra,0x0
    80005c0e:	54e080e7          	jalr	1358(ra) # 80006158 <uartputc_sync>
    uartputc_sync(' ');
    80005c12:	02000513          	li	a0,32
    80005c16:	00000097          	auipc	ra,0x0
    80005c1a:	542080e7          	jalr	1346(ra) # 80006158 <uartputc_sync>
    uartputc_sync('\b');
    80005c1e:	4521                	li	a0,8
    80005c20:	00000097          	auipc	ra,0x0
    80005c24:	538080e7          	jalr	1336(ra) # 80006158 <uartputc_sync>
    80005c28:	bfe1                	j	80005c00 <consputc+0x18>

0000000080005c2a <consoleintr>:
// the console input interrupt handler.
// uartintr() calls this for input character.
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void consoleintr(int c) {
    80005c2a:	1101                	addi	sp,sp,-32
    80005c2c:	ec06                	sd	ra,24(sp)
    80005c2e:	e822                	sd	s0,16(sp)
    80005c30:	e426                	sd	s1,8(sp)
    80005c32:	e04a                	sd	s2,0(sp)
    80005c34:	1000                	addi	s0,sp,32
    80005c36:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005c38:	0003c517          	auipc	a0,0x3c
    80005c3c:	0b850513          	addi	a0,a0,184 # 80041cf0 <cons>
    80005c40:	00000097          	auipc	ra,0x0
    80005c44:	7a4080e7          	jalr	1956(ra) # 800063e4 <acquire>

  switch (c) {
    80005c48:	47d5                	li	a5,21
    80005c4a:	0af48663          	beq	s1,a5,80005cf6 <consoleintr+0xcc>
    80005c4e:	0297ca63          	blt	a5,s1,80005c82 <consoleintr+0x58>
    80005c52:	47a1                	li	a5,8
    80005c54:	0ef48763          	beq	s1,a5,80005d42 <consoleintr+0x118>
    80005c58:	47c1                	li	a5,16
    80005c5a:	10f49a63          	bne	s1,a5,80005d6e <consoleintr+0x144>
    case C('P'):  // Print process list.
      procdump();
    80005c5e:	ffffc097          	auipc	ra,0xffffc
    80005c62:	02a080e7          	jalr	42(ra) # 80001c88 <procdump>
        }
      }
      break;
  }

  release(&cons.lock);
    80005c66:	0003c517          	auipc	a0,0x3c
    80005c6a:	08a50513          	addi	a0,a0,138 # 80041cf0 <cons>
    80005c6e:	00001097          	auipc	ra,0x1
    80005c72:	82a080e7          	jalr	-2006(ra) # 80006498 <release>
}
    80005c76:	60e2                	ld	ra,24(sp)
    80005c78:	6442                	ld	s0,16(sp)
    80005c7a:	64a2                	ld	s1,8(sp)
    80005c7c:	6902                	ld	s2,0(sp)
    80005c7e:	6105                	addi	sp,sp,32
    80005c80:	8082                	ret
  switch (c) {
    80005c82:	07f00793          	li	a5,127
    80005c86:	0af48e63          	beq	s1,a5,80005d42 <consoleintr+0x118>
      if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    80005c8a:	0003c717          	auipc	a4,0x3c
    80005c8e:	06670713          	addi	a4,a4,102 # 80041cf0 <cons>
    80005c92:	0a072783          	lw	a5,160(a4)
    80005c96:	09872703          	lw	a4,152(a4)
    80005c9a:	9f99                	subw	a5,a5,a4
    80005c9c:	07f00713          	li	a4,127
    80005ca0:	fcf763e3          	bltu	a4,a5,80005c66 <consoleintr+0x3c>
        c = (c == '\r') ? '\n' : c;
    80005ca4:	47b5                	li	a5,13
    80005ca6:	0cf48763          	beq	s1,a5,80005d74 <consoleintr+0x14a>
        consputc(c);
    80005caa:	8526                	mv	a0,s1
    80005cac:	00000097          	auipc	ra,0x0
    80005cb0:	f3c080e7          	jalr	-196(ra) # 80005be8 <consputc>
        cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005cb4:	0003c797          	auipc	a5,0x3c
    80005cb8:	03c78793          	addi	a5,a5,60 # 80041cf0 <cons>
    80005cbc:	0a07a683          	lw	a3,160(a5)
    80005cc0:	0016871b          	addiw	a4,a3,1
    80005cc4:	0007061b          	sext.w	a2,a4
    80005cc8:	0ae7a023          	sw	a4,160(a5)
    80005ccc:	07f6f693          	andi	a3,a3,127
    80005cd0:	97b6                	add	a5,a5,a3
    80005cd2:	00978c23          	sb	s1,24(a5)
        if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    80005cd6:	47a9                	li	a5,10
    80005cd8:	0cf48563          	beq	s1,a5,80005da2 <consoleintr+0x178>
    80005cdc:	4791                	li	a5,4
    80005cde:	0cf48263          	beq	s1,a5,80005da2 <consoleintr+0x178>
    80005ce2:	0003c797          	auipc	a5,0x3c
    80005ce6:	0a67a783          	lw	a5,166(a5) # 80041d88 <cons+0x98>
    80005cea:	9f1d                	subw	a4,a4,a5
    80005cec:	08000793          	li	a5,128
    80005cf0:	f6f71be3          	bne	a4,a5,80005c66 <consoleintr+0x3c>
    80005cf4:	a07d                	j	80005da2 <consoleintr+0x178>
      while (cons.e != cons.w &&
    80005cf6:	0003c717          	auipc	a4,0x3c
    80005cfa:	ffa70713          	addi	a4,a4,-6 # 80041cf0 <cons>
    80005cfe:	0a072783          	lw	a5,160(a4)
    80005d02:	09c72703          	lw	a4,156(a4)
             cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80005d06:	0003c497          	auipc	s1,0x3c
    80005d0a:	fea48493          	addi	s1,s1,-22 # 80041cf0 <cons>
      while (cons.e != cons.w &&
    80005d0e:	4929                	li	s2,10
    80005d10:	f4f70be3          	beq	a4,a5,80005c66 <consoleintr+0x3c>
             cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80005d14:	37fd                	addiw	a5,a5,-1
    80005d16:	07f7f713          	andi	a4,a5,127
    80005d1a:	9726                	add	a4,a4,s1
      while (cons.e != cons.w &&
    80005d1c:	01874703          	lbu	a4,24(a4)
    80005d20:	f52703e3          	beq	a4,s2,80005c66 <consoleintr+0x3c>
        cons.e--;
    80005d24:	0af4a023          	sw	a5,160(s1)
        consputc(BACKSPACE);
    80005d28:	10000513          	li	a0,256
    80005d2c:	00000097          	auipc	ra,0x0
    80005d30:	ebc080e7          	jalr	-324(ra) # 80005be8 <consputc>
      while (cons.e != cons.w &&
    80005d34:	0a04a783          	lw	a5,160(s1)
    80005d38:	09c4a703          	lw	a4,156(s1)
    80005d3c:	fcf71ce3          	bne	a4,a5,80005d14 <consoleintr+0xea>
    80005d40:	b71d                	j	80005c66 <consoleintr+0x3c>
      if (cons.e != cons.w) {
    80005d42:	0003c717          	auipc	a4,0x3c
    80005d46:	fae70713          	addi	a4,a4,-82 # 80041cf0 <cons>
    80005d4a:	0a072783          	lw	a5,160(a4)
    80005d4e:	09c72703          	lw	a4,156(a4)
    80005d52:	f0f70ae3          	beq	a4,a5,80005c66 <consoleintr+0x3c>
        cons.e--;
    80005d56:	37fd                	addiw	a5,a5,-1
    80005d58:	0003c717          	auipc	a4,0x3c
    80005d5c:	02f72c23          	sw	a5,56(a4) # 80041d90 <cons+0xa0>
        consputc(BACKSPACE);
    80005d60:	10000513          	li	a0,256
    80005d64:	00000097          	auipc	ra,0x0
    80005d68:	e84080e7          	jalr	-380(ra) # 80005be8 <consputc>
    80005d6c:	bded                	j	80005c66 <consoleintr+0x3c>
      if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    80005d6e:	ee048ce3          	beqz	s1,80005c66 <consoleintr+0x3c>
    80005d72:	bf21                	j	80005c8a <consoleintr+0x60>
        consputc(c);
    80005d74:	4529                	li	a0,10
    80005d76:	00000097          	auipc	ra,0x0
    80005d7a:	e72080e7          	jalr	-398(ra) # 80005be8 <consputc>
        cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005d7e:	0003c797          	auipc	a5,0x3c
    80005d82:	f7278793          	addi	a5,a5,-142 # 80041cf0 <cons>
    80005d86:	0a07a703          	lw	a4,160(a5)
    80005d8a:	0017069b          	addiw	a3,a4,1
    80005d8e:	0006861b          	sext.w	a2,a3
    80005d92:	0ad7a023          	sw	a3,160(a5)
    80005d96:	07f77713          	andi	a4,a4,127
    80005d9a:	97ba                	add	a5,a5,a4
    80005d9c:	4729                	li	a4,10
    80005d9e:	00e78c23          	sb	a4,24(a5)
          cons.w = cons.e;
    80005da2:	0003c797          	auipc	a5,0x3c
    80005da6:	fec7a523          	sw	a2,-22(a5) # 80041d8c <cons+0x9c>
          wakeup(&cons.r);
    80005daa:	0003c517          	auipc	a0,0x3c
    80005dae:	fde50513          	addi	a0,a0,-34 # 80041d88 <cons+0x98>
    80005db2:	ffffc097          	auipc	ra,0xffffc
    80005db6:	a86080e7          	jalr	-1402(ra) # 80001838 <wakeup>
    80005dba:	b575                	j	80005c66 <consoleintr+0x3c>

0000000080005dbc <consoleinit>:

void consoleinit(void) {
    80005dbc:	1141                	addi	sp,sp,-16
    80005dbe:	e406                	sd	ra,8(sp)
    80005dc0:	e022                	sd	s0,0(sp)
    80005dc2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005dc4:	00003597          	auipc	a1,0x3
    80005dc8:	a7c58593          	addi	a1,a1,-1412 # 80008840 <syscalls+0x3f0>
    80005dcc:	0003c517          	auipc	a0,0x3c
    80005dd0:	f2450513          	addi	a0,a0,-220 # 80041cf0 <cons>
    80005dd4:	00000097          	auipc	ra,0x0
    80005dd8:	580080e7          	jalr	1408(ra) # 80006354 <initlock>

  uartinit();
    80005ddc:	00000097          	auipc	ra,0x0
    80005de0:	32c080e7          	jalr	812(ra) # 80006108 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005de4:	00033797          	auipc	a5,0x33
    80005de8:	c2c78793          	addi	a5,a5,-980 # 80038a10 <devsw>
    80005dec:	00000717          	auipc	a4,0x0
    80005df0:	ce470713          	addi	a4,a4,-796 # 80005ad0 <consoleread>
    80005df4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005df6:	00000717          	auipc	a4,0x0
    80005dfa:	c7670713          	addi	a4,a4,-906 # 80005a6c <consolewrite>
    80005dfe:	ef98                	sd	a4,24(a5)
}
    80005e00:	60a2                	ld	ra,8(sp)
    80005e02:	6402                	ld	s0,0(sp)
    80005e04:	0141                	addi	sp,sp,16
    80005e06:	8082                	ret

0000000080005e08 <printint>:
  int locking;
} pr;

static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign) {
    80005e08:	7179                	addi	sp,sp,-48
    80005e0a:	f406                	sd	ra,40(sp)
    80005e0c:	f022                	sd	s0,32(sp)
    80005e0e:	ec26                	sd	s1,24(sp)
    80005e10:	e84a                	sd	s2,16(sp)
    80005e12:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if (sign && (sign = xx < 0))
    80005e14:	c219                	beqz	a2,80005e1a <printint+0x12>
    80005e16:	08054763          	bltz	a0,80005ea4 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005e1a:	2501                	sext.w	a0,a0
    80005e1c:	4881                	li	a7,0
    80005e1e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005e22:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005e24:	2581                	sext.w	a1,a1
    80005e26:	00003617          	auipc	a2,0x3
    80005e2a:	a4a60613          	addi	a2,a2,-1462 # 80008870 <digits>
    80005e2e:	883a                	mv	a6,a4
    80005e30:	2705                	addiw	a4,a4,1
    80005e32:	02b577bb          	remuw	a5,a0,a1
    80005e36:	1782                	slli	a5,a5,0x20
    80005e38:	9381                	srli	a5,a5,0x20
    80005e3a:	97b2                	add	a5,a5,a2
    80005e3c:	0007c783          	lbu	a5,0(a5)
    80005e40:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    80005e44:	0005079b          	sext.w	a5,a0
    80005e48:	02b5553b          	divuw	a0,a0,a1
    80005e4c:	0685                	addi	a3,a3,1
    80005e4e:	feb7f0e3          	bgeu	a5,a1,80005e2e <printint+0x26>

  if (sign) buf[i++] = '-';
    80005e52:	00088c63          	beqz	a7,80005e6a <printint+0x62>
    80005e56:	fe070793          	addi	a5,a4,-32
    80005e5a:	00878733          	add	a4,a5,s0
    80005e5e:	02d00793          	li	a5,45
    80005e62:	fef70823          	sb	a5,-16(a4)
    80005e66:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) consputc(buf[i]);
    80005e6a:	02e05763          	blez	a4,80005e98 <printint+0x90>
    80005e6e:	fd040793          	addi	a5,s0,-48
    80005e72:	00e784b3          	add	s1,a5,a4
    80005e76:	fff78913          	addi	s2,a5,-1
    80005e7a:	993a                	add	s2,s2,a4
    80005e7c:	377d                	addiw	a4,a4,-1
    80005e7e:	1702                	slli	a4,a4,0x20
    80005e80:	9301                	srli	a4,a4,0x20
    80005e82:	40e90933          	sub	s2,s2,a4
    80005e86:	fff4c503          	lbu	a0,-1(s1)
    80005e8a:	00000097          	auipc	ra,0x0
    80005e8e:	d5e080e7          	jalr	-674(ra) # 80005be8 <consputc>
    80005e92:	14fd                	addi	s1,s1,-1
    80005e94:	ff2499e3          	bne	s1,s2,80005e86 <printint+0x7e>
}
    80005e98:	70a2                	ld	ra,40(sp)
    80005e9a:	7402                	ld	s0,32(sp)
    80005e9c:	64e2                	ld	s1,24(sp)
    80005e9e:	6942                	ld	s2,16(sp)
    80005ea0:	6145                	addi	sp,sp,48
    80005ea2:	8082                	ret
    x = -xx;
    80005ea4:	40a0053b          	negw	a0,a0
  if (sign && (sign = xx < 0))
    80005ea8:	4885                	li	a7,1
    x = -xx;
    80005eaa:	bf95                	j	80005e1e <printint+0x16>

0000000080005eac <panic>:
  va_end(ap);

  if (locking) release(&pr.lock);
}

void panic(char *s) {
    80005eac:	1101                	addi	sp,sp,-32
    80005eae:	ec06                	sd	ra,24(sp)
    80005eb0:	e822                	sd	s0,16(sp)
    80005eb2:	e426                	sd	s1,8(sp)
    80005eb4:	1000                	addi	s0,sp,32
    80005eb6:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005eb8:	0003c797          	auipc	a5,0x3c
    80005ebc:	ee07ac23          	sw	zero,-264(a5) # 80041db0 <pr+0x18>
  printf("panic: ");
    80005ec0:	00003517          	auipc	a0,0x3
    80005ec4:	98850513          	addi	a0,a0,-1656 # 80008848 <syscalls+0x3f8>
    80005ec8:	00000097          	auipc	ra,0x0
    80005ecc:	02e080e7          	jalr	46(ra) # 80005ef6 <printf>
  printf(s);
    80005ed0:	8526                	mv	a0,s1
    80005ed2:	00000097          	auipc	ra,0x0
    80005ed6:	024080e7          	jalr	36(ra) # 80005ef6 <printf>
  printf("\n");
    80005eda:	00002517          	auipc	a0,0x2
    80005ede:	17e50513          	addi	a0,a0,382 # 80008058 <etext+0x58>
    80005ee2:	00000097          	auipc	ra,0x0
    80005ee6:	014080e7          	jalr	20(ra) # 80005ef6 <printf>
  panicked = 1;  // freeze uart output from other CPUs
    80005eea:	4785                	li	a5,1
    80005eec:	00003717          	auipc	a4,0x3
    80005ef0:	a6f72023          	sw	a5,-1440(a4) # 8000894c <panicked>
  for (;;);
    80005ef4:	a001                	j	80005ef4 <panic+0x48>

0000000080005ef6 <printf>:
void printf(char *fmt, ...) {
    80005ef6:	7131                	addi	sp,sp,-192
    80005ef8:	fc86                	sd	ra,120(sp)
    80005efa:	f8a2                	sd	s0,112(sp)
    80005efc:	f4a6                	sd	s1,104(sp)
    80005efe:	f0ca                	sd	s2,96(sp)
    80005f00:	ecce                	sd	s3,88(sp)
    80005f02:	e8d2                	sd	s4,80(sp)
    80005f04:	e4d6                	sd	s5,72(sp)
    80005f06:	e0da                	sd	s6,64(sp)
    80005f08:	fc5e                	sd	s7,56(sp)
    80005f0a:	f862                	sd	s8,48(sp)
    80005f0c:	f466                	sd	s9,40(sp)
    80005f0e:	f06a                	sd	s10,32(sp)
    80005f10:	ec6e                	sd	s11,24(sp)
    80005f12:	0100                	addi	s0,sp,128
    80005f14:	8a2a                	mv	s4,a0
    80005f16:	e40c                	sd	a1,8(s0)
    80005f18:	e810                	sd	a2,16(s0)
    80005f1a:	ec14                	sd	a3,24(s0)
    80005f1c:	f018                	sd	a4,32(s0)
    80005f1e:	f41c                	sd	a5,40(s0)
    80005f20:	03043823          	sd	a6,48(s0)
    80005f24:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005f28:	0003cd97          	auipc	s11,0x3c
    80005f2c:	e88dad83          	lw	s11,-376(s11) # 80041db0 <pr+0x18>
  if (locking) acquire(&pr.lock);
    80005f30:	020d9b63          	bnez	s11,80005f66 <printf+0x70>
  if (fmt == 0) panic("null fmt");
    80005f34:	040a0263          	beqz	s4,80005f78 <printf+0x82>
  va_start(ap, fmt);
    80005f38:	00840793          	addi	a5,s0,8
    80005f3c:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80005f40:	000a4503          	lbu	a0,0(s4)
    80005f44:	14050f63          	beqz	a0,800060a2 <printf+0x1ac>
    80005f48:	4981                	li	s3,0
    if (c != '%') {
    80005f4a:	02500a93          	li	s5,37
    switch (c) {
    80005f4e:	07000b93          	li	s7,112
  consputc('x');
    80005f52:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f54:	00003b17          	auipc	s6,0x3
    80005f58:	91cb0b13          	addi	s6,s6,-1764 # 80008870 <digits>
    switch (c) {
    80005f5c:	07300c93          	li	s9,115
    80005f60:	06400c13          	li	s8,100
    80005f64:	a82d                	j	80005f9e <printf+0xa8>
  if (locking) acquire(&pr.lock);
    80005f66:	0003c517          	auipc	a0,0x3c
    80005f6a:	e3250513          	addi	a0,a0,-462 # 80041d98 <pr>
    80005f6e:	00000097          	auipc	ra,0x0
    80005f72:	476080e7          	jalr	1142(ra) # 800063e4 <acquire>
    80005f76:	bf7d                	j	80005f34 <printf+0x3e>
  if (fmt == 0) panic("null fmt");
    80005f78:	00003517          	auipc	a0,0x3
    80005f7c:	8e050513          	addi	a0,a0,-1824 # 80008858 <syscalls+0x408>
    80005f80:	00000097          	auipc	ra,0x0
    80005f84:	f2c080e7          	jalr	-212(ra) # 80005eac <panic>
      consputc(c);
    80005f88:	00000097          	auipc	ra,0x0
    80005f8c:	c60080e7          	jalr	-928(ra) # 80005be8 <consputc>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80005f90:	2985                	addiw	s3,s3,1
    80005f92:	013a07b3          	add	a5,s4,s3
    80005f96:	0007c503          	lbu	a0,0(a5)
    80005f9a:	10050463          	beqz	a0,800060a2 <printf+0x1ac>
    if (c != '%') {
    80005f9e:	ff5515e3          	bne	a0,s5,80005f88 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005fa2:	2985                	addiw	s3,s3,1
    80005fa4:	013a07b3          	add	a5,s4,s3
    80005fa8:	0007c783          	lbu	a5,0(a5)
    80005fac:	0007849b          	sext.w	s1,a5
    if (c == 0) break;
    80005fb0:	cbed                	beqz	a5,800060a2 <printf+0x1ac>
    switch (c) {
    80005fb2:	05778a63          	beq	a5,s7,80006006 <printf+0x110>
    80005fb6:	02fbf663          	bgeu	s7,a5,80005fe2 <printf+0xec>
    80005fba:	09978863          	beq	a5,s9,8000604a <printf+0x154>
    80005fbe:	07800713          	li	a4,120
    80005fc2:	0ce79563          	bne	a5,a4,8000608c <printf+0x196>
        printint(va_arg(ap, int), 16, 1);
    80005fc6:	f8843783          	ld	a5,-120(s0)
    80005fca:	00878713          	addi	a4,a5,8
    80005fce:	f8e43423          	sd	a4,-120(s0)
    80005fd2:	4605                	li	a2,1
    80005fd4:	85ea                	mv	a1,s10
    80005fd6:	4388                	lw	a0,0(a5)
    80005fd8:	00000097          	auipc	ra,0x0
    80005fdc:	e30080e7          	jalr	-464(ra) # 80005e08 <printint>
        break;
    80005fe0:	bf45                	j	80005f90 <printf+0x9a>
    switch (c) {
    80005fe2:	09578f63          	beq	a5,s5,80006080 <printf+0x18a>
    80005fe6:	0b879363          	bne	a5,s8,8000608c <printf+0x196>
        printint(va_arg(ap, int), 10, 1);
    80005fea:	f8843783          	ld	a5,-120(s0)
    80005fee:	00878713          	addi	a4,a5,8
    80005ff2:	f8e43423          	sd	a4,-120(s0)
    80005ff6:	4605                	li	a2,1
    80005ff8:	45a9                	li	a1,10
    80005ffa:	4388                	lw	a0,0(a5)
    80005ffc:	00000097          	auipc	ra,0x0
    80006000:	e0c080e7          	jalr	-500(ra) # 80005e08 <printint>
        break;
    80006004:	b771                	j	80005f90 <printf+0x9a>
        printptr(va_arg(ap, uint64));
    80006006:	f8843783          	ld	a5,-120(s0)
    8000600a:	00878713          	addi	a4,a5,8
    8000600e:	f8e43423          	sd	a4,-120(s0)
    80006012:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80006016:	03000513          	li	a0,48
    8000601a:	00000097          	auipc	ra,0x0
    8000601e:	bce080e7          	jalr	-1074(ra) # 80005be8 <consputc>
  consputc('x');
    80006022:	07800513          	li	a0,120
    80006026:	00000097          	auipc	ra,0x0
    8000602a:	bc2080e7          	jalr	-1086(ra) # 80005be8 <consputc>
    8000602e:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006030:	03c95793          	srli	a5,s2,0x3c
    80006034:	97da                	add	a5,a5,s6
    80006036:	0007c503          	lbu	a0,0(a5)
    8000603a:	00000097          	auipc	ra,0x0
    8000603e:	bae080e7          	jalr	-1106(ra) # 80005be8 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006042:	0912                	slli	s2,s2,0x4
    80006044:	34fd                	addiw	s1,s1,-1
    80006046:	f4ed                	bnez	s1,80006030 <printf+0x13a>
    80006048:	b7a1                	j	80005f90 <printf+0x9a>
        if ((s = va_arg(ap, char *)) == 0) s = "(null)";
    8000604a:	f8843783          	ld	a5,-120(s0)
    8000604e:	00878713          	addi	a4,a5,8
    80006052:	f8e43423          	sd	a4,-120(s0)
    80006056:	6384                	ld	s1,0(a5)
    80006058:	cc89                	beqz	s1,80006072 <printf+0x17c>
        for (; *s; s++) consputc(*s);
    8000605a:	0004c503          	lbu	a0,0(s1)
    8000605e:	d90d                	beqz	a0,80005f90 <printf+0x9a>
    80006060:	00000097          	auipc	ra,0x0
    80006064:	b88080e7          	jalr	-1144(ra) # 80005be8 <consputc>
    80006068:	0485                	addi	s1,s1,1
    8000606a:	0004c503          	lbu	a0,0(s1)
    8000606e:	f96d                	bnez	a0,80006060 <printf+0x16a>
    80006070:	b705                	j	80005f90 <printf+0x9a>
        if ((s = va_arg(ap, char *)) == 0) s = "(null)";
    80006072:	00002497          	auipc	s1,0x2
    80006076:	7de48493          	addi	s1,s1,2014 # 80008850 <syscalls+0x400>
        for (; *s; s++) consputc(*s);
    8000607a:	02800513          	li	a0,40
    8000607e:	b7cd                	j	80006060 <printf+0x16a>
        consputc('%');
    80006080:	8556                	mv	a0,s5
    80006082:	00000097          	auipc	ra,0x0
    80006086:	b66080e7          	jalr	-1178(ra) # 80005be8 <consputc>
        break;
    8000608a:	b719                	j	80005f90 <printf+0x9a>
        consputc('%');
    8000608c:	8556                	mv	a0,s5
    8000608e:	00000097          	auipc	ra,0x0
    80006092:	b5a080e7          	jalr	-1190(ra) # 80005be8 <consputc>
        consputc(c);
    80006096:	8526                	mv	a0,s1
    80006098:	00000097          	auipc	ra,0x0
    8000609c:	b50080e7          	jalr	-1200(ra) # 80005be8 <consputc>
        break;
    800060a0:	bdc5                	j	80005f90 <printf+0x9a>
  if (locking) release(&pr.lock);
    800060a2:	020d9163          	bnez	s11,800060c4 <printf+0x1ce>
}
    800060a6:	70e6                	ld	ra,120(sp)
    800060a8:	7446                	ld	s0,112(sp)
    800060aa:	74a6                	ld	s1,104(sp)
    800060ac:	7906                	ld	s2,96(sp)
    800060ae:	69e6                	ld	s3,88(sp)
    800060b0:	6a46                	ld	s4,80(sp)
    800060b2:	6aa6                	ld	s5,72(sp)
    800060b4:	6b06                	ld	s6,64(sp)
    800060b6:	7be2                	ld	s7,56(sp)
    800060b8:	7c42                	ld	s8,48(sp)
    800060ba:	7ca2                	ld	s9,40(sp)
    800060bc:	7d02                	ld	s10,32(sp)
    800060be:	6de2                	ld	s11,24(sp)
    800060c0:	6129                	addi	sp,sp,192
    800060c2:	8082                	ret
  if (locking) release(&pr.lock);
    800060c4:	0003c517          	auipc	a0,0x3c
    800060c8:	cd450513          	addi	a0,a0,-812 # 80041d98 <pr>
    800060cc:	00000097          	auipc	ra,0x0
    800060d0:	3cc080e7          	jalr	972(ra) # 80006498 <release>
}
    800060d4:	bfc9                	j	800060a6 <printf+0x1b0>

00000000800060d6 <printfinit>:
}

void printfinit(void) {
    800060d6:	1101                	addi	sp,sp,-32
    800060d8:	ec06                	sd	ra,24(sp)
    800060da:	e822                	sd	s0,16(sp)
    800060dc:	e426                	sd	s1,8(sp)
    800060de:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800060e0:	0003c497          	auipc	s1,0x3c
    800060e4:	cb848493          	addi	s1,s1,-840 # 80041d98 <pr>
    800060e8:	00002597          	auipc	a1,0x2
    800060ec:	78058593          	addi	a1,a1,1920 # 80008868 <syscalls+0x418>
    800060f0:	8526                	mv	a0,s1
    800060f2:	00000097          	auipc	ra,0x0
    800060f6:	262080e7          	jalr	610(ra) # 80006354 <initlock>
  pr.locking = 1;
    800060fa:	4785                	li	a5,1
    800060fc:	cc9c                	sw	a5,24(s1)
}
    800060fe:	60e2                	ld	ra,24(sp)
    80006100:	6442                	ld	s0,16(sp)
    80006102:	64a2                	ld	s1,8(sp)
    80006104:	6105                	addi	sp,sp,32
    80006106:	8082                	ret

0000000080006108 <uartinit>:

extern volatile int panicked;  // from printf.c

void uartstart();

void uartinit(void) {
    80006108:	1141                	addi	sp,sp,-16
    8000610a:	e406                	sd	ra,8(sp)
    8000610c:	e022                	sd	s0,0(sp)
    8000610e:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006110:	100007b7          	lui	a5,0x10000
    80006114:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006118:	f8000713          	li	a4,-128
    8000611c:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006120:	470d                	li	a4,3
    80006122:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006126:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000612a:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000612e:	469d                	li	a3,7
    80006130:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006134:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006138:	00002597          	auipc	a1,0x2
    8000613c:	75058593          	addi	a1,a1,1872 # 80008888 <digits+0x18>
    80006140:	0003c517          	auipc	a0,0x3c
    80006144:	c7850513          	addi	a0,a0,-904 # 80041db8 <uart_tx_lock>
    80006148:	00000097          	auipc	ra,0x0
    8000614c:	20c080e7          	jalr	524(ra) # 80006354 <initlock>
}
    80006150:	60a2                	ld	ra,8(sp)
    80006152:	6402                	ld	s0,0(sp)
    80006154:	0141                	addi	sp,sp,16
    80006156:	8082                	ret

0000000080006158 <uartputc_sync>:

// alternate version of uartputc() that doesn't
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void uartputc_sync(int c) {
    80006158:	1101                	addi	sp,sp,-32
    8000615a:	ec06                	sd	ra,24(sp)
    8000615c:	e822                	sd	s0,16(sp)
    8000615e:	e426                	sd	s1,8(sp)
    80006160:	1000                	addi	s0,sp,32
    80006162:	84aa                	mv	s1,a0
  push_off();
    80006164:	00000097          	auipc	ra,0x0
    80006168:	234080e7          	jalr	564(ra) # 80006398 <push_off>

  if (panicked) {
    8000616c:	00002797          	auipc	a5,0x2
    80006170:	7e07a783          	lw	a5,2016(a5) # 8000894c <panicked>
    for (;;);
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    80006174:	10000737          	lui	a4,0x10000
  if (panicked) {
    80006178:	c391                	beqz	a5,8000617c <uartputc_sync+0x24>
    for (;;);
    8000617a:	a001                	j	8000617a <uartputc_sync+0x22>
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    8000617c:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006180:	0207f793          	andi	a5,a5,32
    80006184:	dfe5                	beqz	a5,8000617c <uartputc_sync+0x24>
  WriteReg(THR, c);
    80006186:	0ff4f513          	zext.b	a0,s1
    8000618a:	100007b7          	lui	a5,0x10000
    8000618e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006192:	00000097          	auipc	ra,0x0
    80006196:	2a6080e7          	jalr	678(ra) # 80006438 <pop_off>
}
    8000619a:	60e2                	ld	ra,24(sp)
    8000619c:	6442                	ld	s0,16(sp)
    8000619e:	64a2                	ld	s1,8(sp)
    800061a0:	6105                	addi	sp,sp,32
    800061a2:	8082                	ret

00000000800061a4 <uartstart>:
// in the transmit buffer, send it.
// caller must hold uart_tx_lock.
// called from both the top- and bottom-half.
void uartstart() {
  while (1) {
    if (uart_tx_w == uart_tx_r) {
    800061a4:	00002797          	auipc	a5,0x2
    800061a8:	7ac7b783          	ld	a5,1964(a5) # 80008950 <uart_tx_r>
    800061ac:	00002717          	auipc	a4,0x2
    800061b0:	7ac73703          	ld	a4,1964(a4) # 80008958 <uart_tx_w>
    800061b4:	06f70a63          	beq	a4,a5,80006228 <uartstart+0x84>
void uartstart() {
    800061b8:	7139                	addi	sp,sp,-64
    800061ba:	fc06                	sd	ra,56(sp)
    800061bc:	f822                	sd	s0,48(sp)
    800061be:	f426                	sd	s1,40(sp)
    800061c0:	f04a                	sd	s2,32(sp)
    800061c2:	ec4e                	sd	s3,24(sp)
    800061c4:	e852                	sd	s4,16(sp)
    800061c6:	e456                	sd	s5,8(sp)
    800061c8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }

    if ((ReadReg(LSR) & LSR_TX_IDLE) == 0) {
    800061ca:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }

    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061ce:	0003ca17          	auipc	s4,0x3c
    800061d2:	beaa0a13          	addi	s4,s4,-1046 # 80041db8 <uart_tx_lock>
    uart_tx_r += 1;
    800061d6:	00002497          	auipc	s1,0x2
    800061da:	77a48493          	addi	s1,s1,1914 # 80008950 <uart_tx_r>
    if (uart_tx_w == uart_tx_r) {
    800061de:	00002997          	auipc	s3,0x2
    800061e2:	77a98993          	addi	s3,s3,1914 # 80008958 <uart_tx_w>
    if ((ReadReg(LSR) & LSR_TX_IDLE) == 0) {
    800061e6:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800061ea:	02077713          	andi	a4,a4,32
    800061ee:	c705                	beqz	a4,80006216 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061f0:	01f7f713          	andi	a4,a5,31
    800061f4:	9752                	add	a4,a4,s4
    800061f6:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800061fa:	0785                	addi	a5,a5,1
    800061fc:	e09c                	sd	a5,0(s1)

    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800061fe:	8526                	mv	a0,s1
    80006200:	ffffb097          	auipc	ra,0xffffb
    80006204:	638080e7          	jalr	1592(ra) # 80001838 <wakeup>

    WriteReg(THR, c);
    80006208:	01590023          	sb	s5,0(s2)
    if (uart_tx_w == uart_tx_r) {
    8000620c:	609c                	ld	a5,0(s1)
    8000620e:	0009b703          	ld	a4,0(s3)
    80006212:	fcf71ae3          	bne	a4,a5,800061e6 <uartstart+0x42>
  }
}
    80006216:	70e2                	ld	ra,56(sp)
    80006218:	7442                	ld	s0,48(sp)
    8000621a:	74a2                	ld	s1,40(sp)
    8000621c:	7902                	ld	s2,32(sp)
    8000621e:	69e2                	ld	s3,24(sp)
    80006220:	6a42                	ld	s4,16(sp)
    80006222:	6aa2                	ld	s5,8(sp)
    80006224:	6121                	addi	sp,sp,64
    80006226:	8082                	ret
    80006228:	8082                	ret

000000008000622a <uartputc>:
void uartputc(int c) {
    8000622a:	7179                	addi	sp,sp,-48
    8000622c:	f406                	sd	ra,40(sp)
    8000622e:	f022                	sd	s0,32(sp)
    80006230:	ec26                	sd	s1,24(sp)
    80006232:	e84a                	sd	s2,16(sp)
    80006234:	e44e                	sd	s3,8(sp)
    80006236:	e052                	sd	s4,0(sp)
    80006238:	1800                	addi	s0,sp,48
    8000623a:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000623c:	0003c517          	auipc	a0,0x3c
    80006240:	b7c50513          	addi	a0,a0,-1156 # 80041db8 <uart_tx_lock>
    80006244:	00000097          	auipc	ra,0x0
    80006248:	1a0080e7          	jalr	416(ra) # 800063e4 <acquire>
  if (panicked) {
    8000624c:	00002797          	auipc	a5,0x2
    80006250:	7007a783          	lw	a5,1792(a5) # 8000894c <panicked>
    80006254:	e7c9                	bnez	a5,800062de <uartputc+0xb4>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    80006256:	00002717          	auipc	a4,0x2
    8000625a:	70273703          	ld	a4,1794(a4) # 80008958 <uart_tx_w>
    8000625e:	00002797          	auipc	a5,0x2
    80006262:	6f27b783          	ld	a5,1778(a5) # 80008950 <uart_tx_r>
    80006266:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000626a:	0003c997          	auipc	s3,0x3c
    8000626e:	b4e98993          	addi	s3,s3,-1202 # 80041db8 <uart_tx_lock>
    80006272:	00002497          	auipc	s1,0x2
    80006276:	6de48493          	addi	s1,s1,1758 # 80008950 <uart_tx_r>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    8000627a:	00002917          	auipc	s2,0x2
    8000627e:	6de90913          	addi	s2,s2,1758 # 80008958 <uart_tx_w>
    80006282:	00e79f63          	bne	a5,a4,800062a0 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006286:	85ce                	mv	a1,s3
    80006288:	8526                	mv	a0,s1
    8000628a:	ffffb097          	auipc	ra,0xffffb
    8000628e:	54a080e7          	jalr	1354(ra) # 800017d4 <sleep>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    80006292:	00093703          	ld	a4,0(s2)
    80006296:	609c                	ld	a5,0(s1)
    80006298:	02078793          	addi	a5,a5,32
    8000629c:	fee785e3          	beq	a5,a4,80006286 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800062a0:	0003c497          	auipc	s1,0x3c
    800062a4:	b1848493          	addi	s1,s1,-1256 # 80041db8 <uart_tx_lock>
    800062a8:	01f77793          	andi	a5,a4,31
    800062ac:	97a6                	add	a5,a5,s1
    800062ae:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800062b2:	0705                	addi	a4,a4,1
    800062b4:	00002797          	auipc	a5,0x2
    800062b8:	6ae7b223          	sd	a4,1700(a5) # 80008958 <uart_tx_w>
  uartstart();
    800062bc:	00000097          	auipc	ra,0x0
    800062c0:	ee8080e7          	jalr	-280(ra) # 800061a4 <uartstart>
  release(&uart_tx_lock);
    800062c4:	8526                	mv	a0,s1
    800062c6:	00000097          	auipc	ra,0x0
    800062ca:	1d2080e7          	jalr	466(ra) # 80006498 <release>
}
    800062ce:	70a2                	ld	ra,40(sp)
    800062d0:	7402                	ld	s0,32(sp)
    800062d2:	64e2                	ld	s1,24(sp)
    800062d4:	6942                	ld	s2,16(sp)
    800062d6:	69a2                	ld	s3,8(sp)
    800062d8:	6a02                	ld	s4,0(sp)
    800062da:	6145                	addi	sp,sp,48
    800062dc:	8082                	ret
    for (;;);
    800062de:	a001                	j	800062de <uartputc+0xb4>

00000000800062e0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int uartgetc(void) {
    800062e0:	1141                	addi	sp,sp,-16
    800062e2:	e422                	sd	s0,8(sp)
    800062e4:	0800                	addi	s0,sp,16
  if (ReadReg(LSR) & 0x01) {
    800062e6:	100007b7          	lui	a5,0x10000
    800062ea:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800062ee:	8b85                	andi	a5,a5,1
    800062f0:	cb81                	beqz	a5,80006300 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800062f2:	100007b7          	lui	a5,0x10000
    800062f6:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800062fa:	6422                	ld	s0,8(sp)
    800062fc:	0141                	addi	sp,sp,16
    800062fe:	8082                	ret
    return -1;
    80006300:	557d                	li	a0,-1
    80006302:	bfe5                	j	800062fa <uartgetc+0x1a>

0000000080006304 <uartintr>:

// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void uartintr(void) {
    80006304:	1101                	addi	sp,sp,-32
    80006306:	ec06                	sd	ra,24(sp)
    80006308:	e822                	sd	s0,16(sp)
    8000630a:	e426                	sd	s1,8(sp)
    8000630c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while (1) {
    int c = uartgetc();
    if (c == -1) break;
    8000630e:	54fd                	li	s1,-1
    80006310:	a029                	j	8000631a <uartintr+0x16>
    consoleintr(c);
    80006312:	00000097          	auipc	ra,0x0
    80006316:	918080e7          	jalr	-1768(ra) # 80005c2a <consoleintr>
    int c = uartgetc();
    8000631a:	00000097          	auipc	ra,0x0
    8000631e:	fc6080e7          	jalr	-58(ra) # 800062e0 <uartgetc>
    if (c == -1) break;
    80006322:	fe9518e3          	bne	a0,s1,80006312 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006326:	0003c497          	auipc	s1,0x3c
    8000632a:	a9248493          	addi	s1,s1,-1390 # 80041db8 <uart_tx_lock>
    8000632e:	8526                	mv	a0,s1
    80006330:	00000097          	auipc	ra,0x0
    80006334:	0b4080e7          	jalr	180(ra) # 800063e4 <acquire>
  uartstart();
    80006338:	00000097          	auipc	ra,0x0
    8000633c:	e6c080e7          	jalr	-404(ra) # 800061a4 <uartstart>
  release(&uart_tx_lock);
    80006340:	8526                	mv	a0,s1
    80006342:	00000097          	auipc	ra,0x0
    80006346:	156080e7          	jalr	342(ra) # 80006498 <release>
}
    8000634a:	60e2                	ld	ra,24(sp)
    8000634c:	6442                	ld	s0,16(sp)
    8000634e:	64a2                	ld	s1,8(sp)
    80006350:	6105                	addi	sp,sp,32
    80006352:	8082                	ret

0000000080006354 <initlock>:

#include "defs.h"
#include "proc.h"
#include "riscv.h"

void initlock(struct spinlock *lk, char *name) {
    80006354:	1141                	addi	sp,sp,-16
    80006356:	e422                	sd	s0,8(sp)
    80006358:	0800                	addi	s0,sp,16
  lk->name = name;
    8000635a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000635c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006360:	00053823          	sd	zero,16(a0)
}
    80006364:	6422                	ld	s0,8(sp)
    80006366:	0141                	addi	sp,sp,16
    80006368:	8082                	ret

000000008000636a <holding>:

// Check whether this cpu is holding the lock.
// Interrupts must be off.
int holding(struct spinlock *lk) {
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000636a:	411c                	lw	a5,0(a0)
    8000636c:	e399                	bnez	a5,80006372 <holding+0x8>
    8000636e:	4501                	li	a0,0
  return r;
}
    80006370:	8082                	ret
int holding(struct spinlock *lk) {
    80006372:	1101                	addi	sp,sp,-32
    80006374:	ec06                	sd	ra,24(sp)
    80006376:	e822                	sd	s0,16(sp)
    80006378:	e426                	sd	s1,8(sp)
    8000637a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000637c:	6904                	ld	s1,16(a0)
    8000637e:	ffffb097          	auipc	ra,0xffffb
    80006382:	d8e080e7          	jalr	-626(ra) # 8000110c <mycpu>
    80006386:	40a48533          	sub	a0,s1,a0
    8000638a:	00153513          	seqz	a0,a0
}
    8000638e:	60e2                	ld	ra,24(sp)
    80006390:	6442                	ld	s0,16(sp)
    80006392:	64a2                	ld	s1,8(sp)
    80006394:	6105                	addi	sp,sp,32
    80006396:	8082                	ret

0000000080006398 <push_off>:

// push_off/pop_off are like intr_off()/intr_on() except that they are matched:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void push_off(void) {
    80006398:	1101                	addi	sp,sp,-32
    8000639a:	ec06                	sd	ra,24(sp)
    8000639c:	e822                	sd	s0,16(sp)
    8000639e:	e426                	sd	s1,8(sp)
    800063a0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800063a2:	100024f3          	csrr	s1,sstatus
    800063a6:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    800063aa:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800063ac:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if (mycpu()->noff == 0) mycpu()->intena = old;
    800063b0:	ffffb097          	auipc	ra,0xffffb
    800063b4:	d5c080e7          	jalr	-676(ra) # 8000110c <mycpu>
    800063b8:	5d3c                	lw	a5,120(a0)
    800063ba:	cf89                	beqz	a5,800063d4 <push_off+0x3c>
  mycpu()->noff += 1;
    800063bc:	ffffb097          	auipc	ra,0xffffb
    800063c0:	d50080e7          	jalr	-688(ra) # 8000110c <mycpu>
    800063c4:	5d3c                	lw	a5,120(a0)
    800063c6:	2785                	addiw	a5,a5,1
    800063c8:	dd3c                	sw	a5,120(a0)
}
    800063ca:	60e2                	ld	ra,24(sp)
    800063cc:	6442                	ld	s0,16(sp)
    800063ce:	64a2                	ld	s1,8(sp)
    800063d0:	6105                	addi	sp,sp,32
    800063d2:	8082                	ret
  if (mycpu()->noff == 0) mycpu()->intena = old;
    800063d4:	ffffb097          	auipc	ra,0xffffb
    800063d8:	d38080e7          	jalr	-712(ra) # 8000110c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800063dc:	8085                	srli	s1,s1,0x1
    800063de:	8885                	andi	s1,s1,1
    800063e0:	dd64                	sw	s1,124(a0)
    800063e2:	bfe9                	j	800063bc <push_off+0x24>

00000000800063e4 <acquire>:
void acquire(struct spinlock *lk) {
    800063e4:	1101                	addi	sp,sp,-32
    800063e6:	ec06                	sd	ra,24(sp)
    800063e8:	e822                	sd	s0,16(sp)
    800063ea:	e426                	sd	s1,8(sp)
    800063ec:	1000                	addi	s0,sp,32
    800063ee:	84aa                	mv	s1,a0
  push_off();  // disable interrupts to avoid deadlock.
    800063f0:	00000097          	auipc	ra,0x0
    800063f4:	fa8080e7          	jalr	-88(ra) # 80006398 <push_off>
  if (holding(lk)) panic("acquire");
    800063f8:	8526                	mv	a0,s1
    800063fa:	00000097          	auipc	ra,0x0
    800063fe:	f70080e7          	jalr	-144(ra) # 8000636a <holding>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0);
    80006402:	4705                	li	a4,1
  if (holding(lk)) panic("acquire");
    80006404:	e115                	bnez	a0,80006428 <acquire+0x44>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0);
    80006406:	87ba                	mv	a5,a4
    80006408:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000640c:	2781                	sext.w	a5,a5
    8000640e:	ffe5                	bnez	a5,80006406 <acquire+0x22>
  __sync_synchronize();
    80006410:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006414:	ffffb097          	auipc	ra,0xffffb
    80006418:	cf8080e7          	jalr	-776(ra) # 8000110c <mycpu>
    8000641c:	e888                	sd	a0,16(s1)
}
    8000641e:	60e2                	ld	ra,24(sp)
    80006420:	6442                	ld	s0,16(sp)
    80006422:	64a2                	ld	s1,8(sp)
    80006424:	6105                	addi	sp,sp,32
    80006426:	8082                	ret
  if (holding(lk)) panic("acquire");
    80006428:	00002517          	auipc	a0,0x2
    8000642c:	46850513          	addi	a0,a0,1128 # 80008890 <digits+0x20>
    80006430:	00000097          	auipc	ra,0x0
    80006434:	a7c080e7          	jalr	-1412(ra) # 80005eac <panic>

0000000080006438 <pop_off>:

void pop_off(void) {
    80006438:	1141                	addi	sp,sp,-16
    8000643a:	e406                	sd	ra,8(sp)
    8000643c:	e022                	sd	s0,0(sp)
    8000643e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006440:	ffffb097          	auipc	ra,0xffffb
    80006444:	ccc080e7          	jalr	-820(ra) # 8000110c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80006448:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000644c:	8b89                	andi	a5,a5,2
  if (intr_get()) panic("pop_off - interruptible");
    8000644e:	e78d                	bnez	a5,80006478 <pop_off+0x40>
  if (c->noff < 1) panic("pop_off");
    80006450:	5d3c                	lw	a5,120(a0)
    80006452:	02f05b63          	blez	a5,80006488 <pop_off+0x50>
  c->noff -= 1;
    80006456:	37fd                	addiw	a5,a5,-1
    80006458:	0007871b          	sext.w	a4,a5
    8000645c:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena) intr_on();
    8000645e:	eb09                	bnez	a4,80006470 <pop_off+0x38>
    80006460:	5d7c                	lw	a5,124(a0)
    80006462:	c799                	beqz	a5,80006470 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80006464:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80006468:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000646c:	10079073          	csrw	sstatus,a5
}
    80006470:	60a2                	ld	ra,8(sp)
    80006472:	6402                	ld	s0,0(sp)
    80006474:	0141                	addi	sp,sp,16
    80006476:	8082                	ret
  if (intr_get()) panic("pop_off - interruptible");
    80006478:	00002517          	auipc	a0,0x2
    8000647c:	42050513          	addi	a0,a0,1056 # 80008898 <digits+0x28>
    80006480:	00000097          	auipc	ra,0x0
    80006484:	a2c080e7          	jalr	-1492(ra) # 80005eac <panic>
  if (c->noff < 1) panic("pop_off");
    80006488:	00002517          	auipc	a0,0x2
    8000648c:	42850513          	addi	a0,a0,1064 # 800088b0 <digits+0x40>
    80006490:	00000097          	auipc	ra,0x0
    80006494:	a1c080e7          	jalr	-1508(ra) # 80005eac <panic>

0000000080006498 <release>:
void release(struct spinlock *lk) {
    80006498:	1101                	addi	sp,sp,-32
    8000649a:	ec06                	sd	ra,24(sp)
    8000649c:	e822                	sd	s0,16(sp)
    8000649e:	e426                	sd	s1,8(sp)
    800064a0:	1000                	addi	s0,sp,32
    800064a2:	84aa                	mv	s1,a0
  if (!holding(lk)) panic("release");
    800064a4:	00000097          	auipc	ra,0x0
    800064a8:	ec6080e7          	jalr	-314(ra) # 8000636a <holding>
    800064ac:	c115                	beqz	a0,800064d0 <release+0x38>
  lk->cpu = 0;
    800064ae:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800064b2:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800064b6:	0f50000f          	fence	iorw,ow
    800064ba:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800064be:	00000097          	auipc	ra,0x0
    800064c2:	f7a080e7          	jalr	-134(ra) # 80006438 <pop_off>
}
    800064c6:	60e2                	ld	ra,24(sp)
    800064c8:	6442                	ld	s0,16(sp)
    800064ca:	64a2                	ld	s1,8(sp)
    800064cc:	6105                	addi	sp,sp,32
    800064ce:	8082                	ret
  if (!holding(lk)) panic("release");
    800064d0:	00002517          	auipc	a0,0x2
    800064d4:	3e850513          	addi	a0,a0,1000 # 800088b8 <digits+0x48>
    800064d8:	00000097          	auipc	ra,0x0
    800064dc:	9d4080e7          	jalr	-1580(ra) # 80005eac <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
