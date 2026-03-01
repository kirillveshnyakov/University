
user/_nettest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <txone>:
// send a single UDP packet (but don't recv() the reply).
// python3 nettest.py txone can be used to wait for
// this packet, and you can also see what
// happened with tcpdump -XXnr packets.pcap
//
int txone() {
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	1000                	addi	s0,sp,32
  printf("txone: sending one packet\n");
       8:	00002517          	auipc	a0,0x2
       c:	61850513          	addi	a0,a0,1560 # 2620 <malloc+0xf2>
      10:	00002097          	auipc	ra,0x2
      14:	466080e7          	jalr	1126(ra) # 2476 <printf>
  uint32 dst = 0x0A000202;  // 10.0.2.2
  int dport = NET_TESTS_PORT;
  char buf[5];
  buf[0] = 't';
      18:	07400793          	li	a5,116
      1c:	fef40423          	sb	a5,-24(s0)
  buf[1] = 'x';
      20:	07800793          	li	a5,120
      24:	fef404a3          	sb	a5,-23(s0)
  buf[2] = 'o';
      28:	06f00793          	li	a5,111
      2c:	fef40523          	sb	a5,-22(s0)
  buf[3] = 'n';
      30:	06e00793          	li	a5,110
      34:	fef405a3          	sb	a5,-21(s0)
  buf[4] = 'e';
      38:	06500793          	li	a5,101
      3c:	fef40623          	sb	a5,-20(s0)
  if (send(2003, dst, dport, buf, 5) < 0) {
      40:	4715                	li	a4,5
      42:	fe840693          	addi	a3,s0,-24
      46:	6619                	lui	a2,0x6
      48:	5f360613          	addi	a2,a2,1523 # 65f3 <base+0x23e3>
      4c:	0a0005b7          	lui	a1,0xa000
      50:	20258593          	addi	a1,a1,514 # a000202 <base+0x9ffbff2>
      54:	7d300513          	li	a0,2003
      58:	00002097          	auipc	ra,0x2
      5c:	134080e7          	jalr	308(ra) # 218c <send>
    printf("FAILED txone: send() failed\n");
    return 0;
  }
  return 1;
      60:	4785                	li	a5,1
  if (send(2003, dst, dport, buf, 5) < 0) {
      62:	00054763          	bltz	a0,70 <txone+0x70>
}
      66:	853e                	mv	a0,a5
      68:	60e2                	ld	ra,24(sp)
      6a:	6442                	ld	s0,16(sp)
      6c:	6105                	addi	sp,sp,32
      6e:	8082                	ret
    printf("FAILED txone: send() failed\n");
      70:	00002517          	auipc	a0,0x2
      74:	5d050513          	addi	a0,a0,1488 # 2640 <malloc+0x112>
      78:	00002097          	auipc	ra,0x2
      7c:	3fe080e7          	jalr	1022(ra) # 2476 <printf>
    return 0;
      80:	4781                	li	a5,0
      82:	b7d5                	j	66 <txone+0x66>

0000000000000084 <rx>:
//
// test just receive.
// outside of qemu, run
//   ./nettest.py rx
//
int rx(char *name) {
      84:	7115                	addi	sp,sp,-224
      86:	ed86                	sd	ra,216(sp)
      88:	e9a2                	sd	s0,208(sp)
      8a:	e5a6                	sd	s1,200(sp)
      8c:	e1ca                	sd	s2,192(sp)
      8e:	fd4e                	sd	s3,184(sp)
      90:	f952                	sd	s4,176(sp)
      92:	f556                	sd	s5,168(sp)
      94:	f15a                	sd	s6,160(sp)
      96:	ed5e                	sd	s7,152(sp)
      98:	e962                	sd	s8,144(sp)
      9a:	1180                	addi	s0,sp,224
      9c:	892a                	mv	s2,a0
  bind(FWDPORT1);
      9e:	7d000513          	li	a0,2000
      a2:	00002097          	auipc	ra,0x2
      a6:	0da080e7          	jalr	218(ra) # 217c <bind>
      aa:	4a91                	li	s5,4

  int lastseq = -1;
      ac:	5a7d                	li	s4,-1
    if (cc < 0) {
      printf("FAILED %s: recv() failed\n", name);
      return 0;
    }

    if (src != 0x0A000202) {  // 10.0.2.2
      ae:	0a0009b7          	lui	s3,0xa000
      b2:	20298993          	addi	s3,s3,514 # a000202 <base+0x9ffbff2>
      printf("FAILED %s: wrong ip src %x\n", name, src);
      return 0;
    }

    if (cc < strlen("packet 1")) {
      b6:	00002b17          	auipc	s6,0x2
      ba:	5eab0b13          	addi	s6,s6,1514 # 26a0 <malloc+0x172>
      printf("FAILED %s: packet doesn't start with packet\n", name);
      return 0;
    }

#define isdigit(x) ((x) >= '0' && (x) <= '9')
    if (!isdigit(ibuf[7])) {
      be:	44a5                	li	s1,9
    int cc = recv(FWDPORT1, &src, &sport, ibuf, sizeof(ibuf) - 1);
      c0:	07f00713          	li	a4,127
      c4:	f3040693          	addi	a3,s0,-208
      c8:	f2a40613          	addi	a2,s0,-214
      cc:	f2c40593          	addi	a1,s0,-212
      d0:	7d000513          	li	a0,2000
      d4:	00002097          	auipc	ra,0x2
      d8:	0c0080e7          	jalr	192(ra) # 2194 <recv>
      dc:	8c2a                	mv	s8,a0
    if (cc < 0) {
      de:	0c054363          	bltz	a0,1a4 <rx+0x120>
    if (src != 0x0A000202) {  // 10.0.2.2
      e2:	f2c42603          	lw	a2,-212(s0)
      e6:	0d361963          	bne	a2,s3,1b8 <rx+0x134>
    if (cc < strlen("packet 1")) {
      ea:	855a                	mv	a0,s6
      ec:	00002097          	auipc	ra,0x2
      f0:	dcc080e7          	jalr	-564(ra) # 1eb8 <strlen>
      f4:	2501                	sext.w	a0,a0
      f6:	000c0b9b          	sext.w	s7,s8
      fa:	0cabe963          	bltu	s7,a0,1cc <rx+0x148>
    if (cc > strlen("packet xxxxxx")) {
      fe:	00002517          	auipc	a0,0x2
     102:	5d250513          	addi	a0,a0,1490 # 26d0 <malloc+0x1a2>
     106:	00002097          	auipc	ra,0x2
     10a:	db2080e7          	jalr	-590(ra) # 1eb8 <strlen>
     10e:	2501                	sext.w	a0,a0
     110:	0d756963          	bltu	a0,s7,1e2 <rx+0x15e>
    if (memcmp(ibuf, "packet ", strlen("packet ")) != 0) {
     114:	00002517          	auipc	a0,0x2
     118:	5ec50513          	addi	a0,a0,1516 # 2700 <malloc+0x1d2>
     11c:	00002097          	auipc	ra,0x2
     120:	d9c080e7          	jalr	-612(ra) # 1eb8 <strlen>
     124:	0005061b          	sext.w	a2,a0
     128:	00002597          	auipc	a1,0x2
     12c:	5d858593          	addi	a1,a1,1496 # 2700 <malloc+0x1d2>
     130:	f3040513          	addi	a0,s0,-208
     134:	00002097          	auipc	ra,0x2
     138:	f4e080e7          	jalr	-178(ra) # 2082 <memcmp>
     13c:	ed55                	bnez	a0,1f8 <rx+0x174>
    if (!isdigit(ibuf[7])) {
     13e:	f3744603          	lbu	a2,-201(s0)
     142:	fd06079b          	addiw	a5,a2,-48
     146:	0ff7f793          	zext.b	a5,a5
     14a:	0cf4e163          	bltu	s1,a5,20c <rx+0x188>
      printf("FAILED %s: packet doesn't contain a number\n", name);
      return 0;
    }
    for (int i = 7; i < cc; i++) {
     14e:	479d                	li	a5,7
     150:	0d87d863          	bge	a5,s8,220 <rx+0x19c>
     154:	f3840713          	addi	a4,s0,-200
     158:	ff8b869b          	addiw	a3,s7,-8
     15c:	1682                	slli	a3,a3,0x20
     15e:	9281                	srli	a3,a3,0x20
     160:	96ba                	add	a3,a3,a4
     162:	0ad70f63          	beq	a4,a3,220 <rx+0x19c>
      if (!isdigit(ibuf[i])) {
     166:	00074783          	lbu	a5,0(a4)
     16a:	fd07879b          	addiw	a5,a5,-48
     16e:	0ff7f793          	zext.b	a5,a5
     172:	0705                	addi	a4,a4,1
     174:	fef4f7e3          	bgeu	s1,a5,162 <rx+0xde>
        printf("FAILED %s: packet contains non-digits in the number\n", name);
     178:	85ca                	mv	a1,s2
     17a:	00002517          	auipc	a0,0x2
     17e:	5ee50513          	addi	a0,a0,1518 # 2768 <malloc+0x23a>
     182:	00002097          	auipc	ra,0x2
     186:	2f4080e7          	jalr	756(ra) # 2476 <printf>
      return 0;
     18a:	4501                	li	a0,0

  unbind(FWDPORT1);
  printf("%s: OK\n", name);

  return 1;
}
     18c:	60ee                	ld	ra,216(sp)
     18e:	644e                	ld	s0,208(sp)
     190:	64ae                	ld	s1,200(sp)
     192:	690e                	ld	s2,192(sp)
     194:	79ea                	ld	s3,184(sp)
     196:	7a4a                	ld	s4,176(sp)
     198:	7aaa                	ld	s5,168(sp)
     19a:	7b0a                	ld	s6,160(sp)
     19c:	6bea                	ld	s7,152(sp)
     19e:	6c4a                	ld	s8,144(sp)
     1a0:	612d                	addi	sp,sp,224
     1a2:	8082                	ret
      printf("FAILED %s: recv() failed\n", name);
     1a4:	85ca                	mv	a1,s2
     1a6:	00002517          	auipc	a0,0x2
     1aa:	4ba50513          	addi	a0,a0,1210 # 2660 <malloc+0x132>
     1ae:	00002097          	auipc	ra,0x2
     1b2:	2c8080e7          	jalr	712(ra) # 2476 <printf>
      return 0;
     1b6:	bfd1                	j	18a <rx+0x106>
      printf("FAILED %s: wrong ip src %x\n", name, src);
     1b8:	85ca                	mv	a1,s2
     1ba:	00002517          	auipc	a0,0x2
     1be:	4c650513          	addi	a0,a0,1222 # 2680 <malloc+0x152>
     1c2:	00002097          	auipc	ra,0x2
     1c6:	2b4080e7          	jalr	692(ra) # 2476 <printf>
      return 0;
     1ca:	b7c1                	j	18a <rx+0x106>
      printf("FAILED %s: len %d too short\n", name, cc);
     1cc:	8662                	mv	a2,s8
     1ce:	85ca                	mv	a1,s2
     1d0:	00002517          	auipc	a0,0x2
     1d4:	4e050513          	addi	a0,a0,1248 # 26b0 <malloc+0x182>
     1d8:	00002097          	auipc	ra,0x2
     1dc:	29e080e7          	jalr	670(ra) # 2476 <printf>
      return 0;
     1e0:	b76d                	j	18a <rx+0x106>
      printf("FAILED %s: len %d too long\n", name, cc);
     1e2:	8662                	mv	a2,s8
     1e4:	85ca                	mv	a1,s2
     1e6:	00002517          	auipc	a0,0x2
     1ea:	4fa50513          	addi	a0,a0,1274 # 26e0 <malloc+0x1b2>
     1ee:	00002097          	auipc	ra,0x2
     1f2:	288080e7          	jalr	648(ra) # 2476 <printf>
      return 0;
     1f6:	bf51                	j	18a <rx+0x106>
      printf("FAILED %s: packet doesn't start with packet\n", name);
     1f8:	85ca                	mv	a1,s2
     1fa:	00002517          	auipc	a0,0x2
     1fe:	50e50513          	addi	a0,a0,1294 # 2708 <malloc+0x1da>
     202:	00002097          	auipc	ra,0x2
     206:	274080e7          	jalr	628(ra) # 2476 <printf>
      return 0;
     20a:	b741                	j	18a <rx+0x106>
      printf("FAILED %s: packet doesn't contain a number\n", name);
     20c:	85ca                	mv	a1,s2
     20e:	00002517          	auipc	a0,0x2
     212:	52a50513          	addi	a0,a0,1322 # 2738 <malloc+0x20a>
     216:	00002097          	auipc	ra,0x2
     21a:	260080e7          	jalr	608(ra) # 2476 <printf>
      return 0;
     21e:	b7b5                	j	18a <rx+0x106>
    int seq = ibuf[7] - '0';
     220:	fd06061b          	addiw	a2,a2,-48
     224:	00060b9b          	sext.w	s7,a2
    if (isdigit(ibuf[8])) {
     228:	f3844783          	lbu	a5,-200(s0)
     22c:	fd07871b          	addiw	a4,a5,-48
     230:	0ff77713          	zext.b	a4,a4
     234:	02e4ee63          	bltu	s1,a4,270 <rx+0x1ec>
      seq *= 10;
     238:	0026171b          	slliw	a4,a2,0x2
     23c:	9f31                	addw	a4,a4,a2
     23e:	0017171b          	slliw	a4,a4,0x1
      seq += ibuf[8] - '0';
     242:	fd07879b          	addiw	a5,a5,-48
     246:	9fb9                	addw	a5,a5,a4
     248:	00078b9b          	sext.w	s7,a5
      if (isdigit(ibuf[9])) {
     24c:	f3944683          	lbu	a3,-199(s0)
     250:	fd06871b          	addiw	a4,a3,-48
     254:	0ff77713          	zext.b	a4,a4
     258:	00e4ec63          	bltu	s1,a4,270 <rx+0x1ec>
        seq *= 10;
     25c:	00279b9b          	slliw	s7,a5,0x2
     260:	00fb8bbb          	addw	s7,s7,a5
     264:	001b9b9b          	slliw	s7,s7,0x1
        seq += ibuf[9] - '0';
     268:	fd06869b          	addiw	a3,a3,-48
     26c:	01768bbb          	addw	s7,a3,s7
    printf("%s: receive one UDP packet %d\n", name, seq);
     270:	865e                	mv	a2,s7
     272:	85ca                	mv	a1,s2
     274:	00002517          	auipc	a0,0x2
     278:	52c50513          	addi	a0,a0,1324 # 27a0 <malloc+0x272>
     27c:	00002097          	auipc	ra,0x2
     280:	1fa080e7          	jalr	506(ra) # 2476 <printf>
    if (lastseq != -1) {
     284:	57fd                	li	a5,-1
     286:	00fa0563          	beq	s4,a5,290 <rx+0x20c>
      if (seq != lastseq + 1) {
     28a:	2a05                	addiw	s4,s4,1
     28c:	017a1763          	bne	s4,s7,29a <rx+0x216>
  while (ok < 4) {
     290:	3afd                	addiw	s5,s5,-1
     292:	020a8063          	beqz	s5,2b2 <rx+0x22e>
     296:	8a5e                	mv	s4,s7
     298:	b525                	j	c0 <rx+0x3c>
        printf("FAILED %s: got seq %d, expecting %d\n", name, seq, lastseq + 1);
     29a:	86d2                	mv	a3,s4
     29c:	865e                	mv	a2,s7
     29e:	85ca                	mv	a1,s2
     2a0:	00002517          	auipc	a0,0x2
     2a4:	52050513          	addi	a0,a0,1312 # 27c0 <malloc+0x292>
     2a8:	00002097          	auipc	ra,0x2
     2ac:	1ce080e7          	jalr	462(ra) # 2476 <printf>
        return 0;
     2b0:	bde9                	j	18a <rx+0x106>
  unbind(FWDPORT1);
     2b2:	7d000513          	li	a0,2000
     2b6:	00002097          	auipc	ra,0x2
     2ba:	ece080e7          	jalr	-306(ra) # 2184 <unbind>
  printf("%s: OK\n", name);
     2be:	85ca                	mv	a1,s2
     2c0:	00002517          	auipc	a0,0x2
     2c4:	52850513          	addi	a0,a0,1320 # 27e8 <malloc+0x2ba>
     2c8:	00002097          	auipc	ra,0x2
     2cc:	1ae080e7          	jalr	430(ra) # 2476 <printf>
  return 1;
     2d0:	4505                	li	a0,1
     2d2:	bd6d                	j	18c <rx+0x108>

00000000000002d4 <rx2>:
//
// test receive on two different ports, interleaved.
// outside of qemu, run
//   ./nettest.py rx2
//
int rx2(int port1, int port2) {
     2d4:	7151                	addi	sp,sp,-240
     2d6:	f586                	sd	ra,232(sp)
     2d8:	f1a2                	sd	s0,224(sp)
     2da:	eda6                	sd	s1,216(sp)
     2dc:	e9ca                	sd	s2,208(sp)
     2de:	e5ce                	sd	s3,200(sp)
     2e0:	e1d2                	sd	s4,192(sp)
     2e2:	fd56                	sd	s5,184(sp)
     2e4:	f95a                	sd	s6,176(sp)
     2e6:	f55e                	sd	s7,168(sp)
     2e8:	f162                	sd	s8,160(sp)
     2ea:	ed66                	sd	s9,152(sp)
     2ec:	e96a                	sd	s10,144(sp)
     2ee:	1980                	addi	s0,sp,240
     2f0:	892a                	mv	s2,a0
     2f2:	8b2e                	mv	s6,a1
  int b1r, b2r;
  b1r = bind(port1);
     2f4:	03051993          	slli	s3,a0,0x30
     2f8:	0309d993          	srli	s3,s3,0x30
     2fc:	854e                	mv	a0,s3
     2fe:	00002097          	auipc	ra,0x2
     302:	e7e080e7          	jalr	-386(ra) # 217c <bind>
     306:	84aa                	mv	s1,a0
  b2r = bind(port2);
     308:	030b1a93          	slli	s5,s6,0x30
     30c:	030ada93          	srli	s5,s5,0x30
     310:	8556                	mv	a0,s5
     312:	00002097          	auipc	ra,0x2
     316:	e6a080e7          	jalr	-406(ra) # 217c <bind>
  if (b1r != 0) {
     31a:	22049763          	bnez	s1,548 <rx2+0x274>
     31e:	8a2a                	mv	s4,a0
    printf("FAILED rx2: bind %d\n", port1);
    return 0;
  } else if (b2r != 0) {
     320:	490d                	li	s2,3
     322:	22051e63          	bnez	a0,55e <rx2+0x28a>
      printf("FAILED rx2: recv() failed\n");
      return 0;
    }
    ibuf[cc] = '\0';

    if (src != 0x0A000202) {  // 10.0.2.2
     326:	0a000bb7          	lui	s7,0xa000
     32a:	202b8b93          	addi	s7,s7,514 # a000202 <base+0x9ffbff2>
      printf("FAILED rx2: wrong ip src %x\n", src);
      return 0;
    }

    if (cc < strlen("one 1")) {
     32e:	00002c17          	auipc	s8,0x2
     332:	51ac0c13          	addi	s8,s8,1306 # 2848 <malloc+0x31a>
      printf("FAILED rx2: len %d too short\n", cc);
      return 0;
    }

    if (cc > strlen("one xxxxxx")) {
     336:	00002c97          	auipc	s9,0x2
     33a:	53ac8c93          	addi	s9,s9,1338 # 2870 <malloc+0x342>
      printf("FAILED rx2: len %d too long\n", cc);
      return 0;
    }

    if (memcmp(ibuf, "one ", strlen("one ")) != 0) {
     33e:	00002b17          	auipc	s6,0x2
     342:	562b0b13          	addi	s6,s6,1378 # 28a0 <malloc+0x372>
    int cc = recv(port1, &src, &sport, ibuf, sizeof(ibuf) - 1);
     346:	07f00713          	li	a4,127
     34a:	f2040693          	addi	a3,s0,-224
     34e:	f1a40613          	addi	a2,s0,-230
     352:	f1c40593          	addi	a1,s0,-228
     356:	854e                	mv	a0,s3
     358:	00002097          	auipc	ra,0x2
     35c:	e3c080e7          	jalr	-452(ra) # 2194 <recv>
     360:	84aa                	mv	s1,a0
    if (cc < 0) {
     362:	20054863          	bltz	a0,572 <rx2+0x29e>
    ibuf[cc] = '\0';
     366:	fa050793          	addi	a5,a0,-96
     36a:	97a2                	add	a5,a5,s0
     36c:	f8078023          	sb	zero,-128(a5)
    if (src != 0x0A000202) {  // 10.0.2.2
     370:	f1c42583          	lw	a1,-228(s0)
     374:	21759963          	bne	a1,s7,586 <rx2+0x2b2>
    if (cc < strlen("one 1")) {
     378:	8562                	mv	a0,s8
     37a:	00002097          	auipc	ra,0x2
     37e:	b3e080e7          	jalr	-1218(ra) # 1eb8 <strlen>
     382:	0005079b          	sext.w	a5,a0
     386:	00048d1b          	sext.w	s10,s1
     38a:	20fd6763          	bltu	s10,a5,598 <rx2+0x2c4>
    if (cc > strlen("one xxxxxx")) {
     38e:	8566                	mv	a0,s9
     390:	00002097          	auipc	ra,0x2
     394:	b28080e7          	jalr	-1240(ra) # 1eb8 <strlen>
     398:	2501                	sext.w	a0,a0
     39a:	21a56963          	bltu	a0,s10,5ac <rx2+0x2d8>
    if (memcmp(ibuf, "one ", strlen("one ")) != 0) {
     39e:	855a                	mv	a0,s6
     3a0:	00002097          	auipc	ra,0x2
     3a4:	b18080e7          	jalr	-1256(ra) # 1eb8 <strlen>
     3a8:	0005061b          	sext.w	a2,a0
     3ac:	85da                	mv	a1,s6
     3ae:	f2040513          	addi	a0,s0,-224
     3b2:	00002097          	auipc	ra,0x2
     3b6:	cd0080e7          	jalr	-816(ra) # 2082 <memcmp>
     3ba:	84aa                	mv	s1,a0
     3bc:	20051263          	bnez	a0,5c0 <rx2+0x2ec>
  for (int i = 0; i < 3; i++) {
     3c0:	397d                	addiw	s2,s2,-1
     3c2:	f80912e3          	bnez	s2,346 <rx2+0x72>
     3c6:	4a0d                	li	s4,3
      printf("FAILED rx2: recv() failed\n");
      return 0;
    }
    ibuf[cc] = '\0';

    if (src != 0x0A000202) {  // 10.0.2.2
     3c8:	0a000bb7          	lui	s7,0xa000
     3cc:	202b8b93          	addi	s7,s7,514 # a000202 <base+0x9ffbff2>
      printf("FAILED rx2: wrong ip src %x\n", src);
      return 0;
    }

    if (cc < strlen("one 1")) {
     3d0:	00002c17          	auipc	s8,0x2
     3d4:	478c0c13          	addi	s8,s8,1144 # 2848 <malloc+0x31a>
      printf("FAILED rx2: len %d too short\n", cc);
      return 0;
    }

    if (cc > strlen("one xxxxxx")) {
     3d8:	00002c97          	auipc	s9,0x2
     3dc:	498c8c93          	addi	s9,s9,1176 # 2870 <malloc+0x342>
      printf("FAILED rx2: len %d too long\n", cc);
      return 0;
    }

    if (memcmp(ibuf, "two ", strlen("two ")) != 0) {
     3e0:	00002b17          	auipc	s6,0x2
     3e4:	4f8b0b13          	addi	s6,s6,1272 # 28d8 <malloc+0x3aa>
    int cc = recv(port2, &src, &sport, ibuf, sizeof(ibuf) - 1);
     3e8:	07f00713          	li	a4,127
     3ec:	f2040693          	addi	a3,s0,-224
     3f0:	f1a40613          	addi	a2,s0,-230
     3f4:	f1c40593          	addi	a1,s0,-228
     3f8:	8556                	mv	a0,s5
     3fa:	00002097          	auipc	ra,0x2
     3fe:	d9a080e7          	jalr	-614(ra) # 2194 <recv>
     402:	892a                	mv	s2,a0
    if (cc < 0) {
     404:	1c054763          	bltz	a0,5d2 <rx2+0x2fe>
    ibuf[cc] = '\0';
     408:	fa050793          	addi	a5,a0,-96
     40c:	97a2                	add	a5,a5,s0
     40e:	f8078023          	sb	zero,-128(a5)
    if (src != 0x0A000202) {  // 10.0.2.2
     412:	f1c42583          	lw	a1,-228(s0)
     416:	1d759763          	bne	a1,s7,5e4 <rx2+0x310>
    if (cc < strlen("one 1")) {
     41a:	8562                	mv	a0,s8
     41c:	00002097          	auipc	ra,0x2
     420:	a9c080e7          	jalr	-1380(ra) # 1eb8 <strlen>
     424:	2501                	sext.w	a0,a0
     426:	00090d1b          	sext.w	s10,s2
     42a:	1cad6663          	bltu	s10,a0,5f6 <rx2+0x322>
    if (cc > strlen("one xxxxxx")) {
     42e:	8566                	mv	a0,s9
     430:	00002097          	auipc	ra,0x2
     434:	a88080e7          	jalr	-1400(ra) # 1eb8 <strlen>
     438:	2501                	sext.w	a0,a0
     43a:	1da56863          	bltu	a0,s10,60a <rx2+0x336>
    if (memcmp(ibuf, "two ", strlen("two ")) != 0) {
     43e:	855a                	mv	a0,s6
     440:	00002097          	auipc	ra,0x2
     444:	a78080e7          	jalr	-1416(ra) # 1eb8 <strlen>
     448:	0005061b          	sext.w	a2,a0
     44c:	85da                	mv	a1,s6
     44e:	f2040513          	addi	a0,s0,-224
     452:	00002097          	auipc	ra,0x2
     456:	c30080e7          	jalr	-976(ra) # 2082 <memcmp>
     45a:	892a                	mv	s2,a0
     45c:	1c051163          	bnez	a0,61e <rx2+0x34a>
  for (int i = 0; i < 3; i++) {
     460:	3a7d                	addiw	s4,s4,-1
     462:	f80a13e3          	bnez	s4,3e8 <rx2+0x114>
     466:	4a0d                	li	s4,3
      printf("FAILED rx2: recv() failed\n");
      return 0;
    }
    ibuf[cc] = '\0';

    if (src != 0x0A000202) {  // 10.0.2.2
     468:	0a000bb7          	lui	s7,0xa000
     46c:	202b8b93          	addi	s7,s7,514 # a000202 <base+0x9ffbff2>
      printf("FAILED rx2: wrong ip src %x\n", src);
      return 0;
    }

    if (cc < strlen("one 1")) {
     470:	00002c17          	auipc	s8,0x2
     474:	3d8c0c13          	addi	s8,s8,984 # 2848 <malloc+0x31a>
      printf("FAILED rx2: len %d too short\n", cc);
      return 0;
    }

    if (cc > strlen("one xxxxxx")) {
     478:	00002c97          	auipc	s9,0x2
     47c:	3f8c8c93          	addi	s9,s9,1016 # 2870 <malloc+0x342>
      printf("FAILED rx2: len %d too long\n", cc);
      return 0;
    }

    if (memcmp(ibuf, "one ", strlen("one ")) != 0) {
     480:	00002b17          	auipc	s6,0x2
     484:	420b0b13          	addi	s6,s6,1056 # 28a0 <malloc+0x372>
    int cc = recv(port1, &src, &sport, ibuf, sizeof(ibuf) - 1);
     488:	07f00713          	li	a4,127
     48c:	f2040693          	addi	a3,s0,-224
     490:	f1a40613          	addi	a2,s0,-230
     494:	f1c40593          	addi	a1,s0,-228
     498:	854e                	mv	a0,s3
     49a:	00002097          	auipc	ra,0x2
     49e:	cfa080e7          	jalr	-774(ra) # 2194 <recv>
     4a2:	84aa                	mv	s1,a0
    if (cc < 0) {
     4a4:	18054663          	bltz	a0,630 <rx2+0x35c>
    ibuf[cc] = '\0';
     4a8:	fa050793          	addi	a5,a0,-96
     4ac:	97a2                	add	a5,a5,s0
     4ae:	f8078023          	sb	zero,-128(a5)
    if (src != 0x0A000202) {  // 10.0.2.2
     4b2:	f1c42583          	lw	a1,-228(s0)
     4b6:	19759763          	bne	a1,s7,644 <rx2+0x370>
    if (cc < strlen("one 1")) {
     4ba:	8562                	mv	a0,s8
     4bc:	00002097          	auipc	ra,0x2
     4c0:	9fc080e7          	jalr	-1540(ra) # 1eb8 <strlen>
     4c4:	2501                	sext.w	a0,a0
     4c6:	00048d1b          	sext.w	s10,s1
     4ca:	18ad6663          	bltu	s10,a0,656 <rx2+0x382>
    if (cc > strlen("one xxxxxx")) {
     4ce:	8566                	mv	a0,s9
     4d0:	00002097          	auipc	ra,0x2
     4d4:	9e8080e7          	jalr	-1560(ra) # 1eb8 <strlen>
     4d8:	2501                	sext.w	a0,a0
     4da:	19a56863          	bltu	a0,s10,66a <rx2+0x396>
    if (memcmp(ibuf, "one ", strlen("one ")) != 0) {
     4de:	855a                	mv	a0,s6
     4e0:	00002097          	auipc	ra,0x2
     4e4:	9d8080e7          	jalr	-1576(ra) # 1eb8 <strlen>
     4e8:	0005061b          	sext.w	a2,a0
     4ec:	85da                	mv	a1,s6
     4ee:	f2040513          	addi	a0,s0,-224
     4f2:	00002097          	auipc	ra,0x2
     4f6:	b90080e7          	jalr	-1136(ra) # 2082 <memcmp>
     4fa:	18051263          	bnez	a0,67e <rx2+0x3aa>
  for (int i = 0; i < 3; i++) {
     4fe:	3a7d                	addiw	s4,s4,-1
     500:	f80a14e3          	bnez	s4,488 <rx2+0x1b4>
      printf("FAILED rx2: packet doesn't start with one\n");
      return 0;
    }
  }

  unbind(port1);
     504:	854e                	mv	a0,s3
     506:	00002097          	auipc	ra,0x2
     50a:	c7e080e7          	jalr	-898(ra) # 2184 <unbind>
  unbind(port2);
     50e:	8556                	mv	a0,s5
     510:	00002097          	auipc	ra,0x2
     514:	c74080e7          	jalr	-908(ra) # 2184 <unbind>
  printf("rx2: OK\n");
     518:	00002517          	auipc	a0,0x2
     51c:	3f850513          	addi	a0,a0,1016 # 2910 <malloc+0x3e2>
     520:	00002097          	auipc	ra,0x2
     524:	f56080e7          	jalr	-170(ra) # 2476 <printf>

  return 1;
     528:	4485                	li	s1,1
}
     52a:	8526                	mv	a0,s1
     52c:	70ae                	ld	ra,232(sp)
     52e:	740e                	ld	s0,224(sp)
     530:	64ee                	ld	s1,216(sp)
     532:	694e                	ld	s2,208(sp)
     534:	69ae                	ld	s3,200(sp)
     536:	6a0e                	ld	s4,192(sp)
     538:	7aea                	ld	s5,184(sp)
     53a:	7b4a                	ld	s6,176(sp)
     53c:	7baa                	ld	s7,168(sp)
     53e:	7c0a                	ld	s8,160(sp)
     540:	6cea                	ld	s9,152(sp)
     542:	6d4a                	ld	s10,144(sp)
     544:	616d                	addi	sp,sp,240
     546:	8082                	ret
    printf("FAILED rx2: bind %d\n", port1);
     548:	85ca                	mv	a1,s2
     54a:	00002517          	auipc	a0,0x2
     54e:	2a650513          	addi	a0,a0,678 # 27f0 <malloc+0x2c2>
     552:	00002097          	auipc	ra,0x2
     556:	f24080e7          	jalr	-220(ra) # 2476 <printf>
    return 0;
     55a:	4481                	li	s1,0
     55c:	b7f9                	j	52a <rx2+0x256>
    printf("FAILED rx2: bind %d\n", port2);
     55e:	85da                	mv	a1,s6
     560:	00002517          	auipc	a0,0x2
     564:	29050513          	addi	a0,a0,656 # 27f0 <malloc+0x2c2>
     568:	00002097          	auipc	ra,0x2
     56c:	f0e080e7          	jalr	-242(ra) # 2476 <printf>
    return 0;
     570:	bf6d                	j	52a <rx2+0x256>
      printf("FAILED rx2: recv() failed\n");
     572:	00002517          	auipc	a0,0x2
     576:	29650513          	addi	a0,a0,662 # 2808 <malloc+0x2da>
     57a:	00002097          	auipc	ra,0x2
     57e:	efc080e7          	jalr	-260(ra) # 2476 <printf>
      return 0;
     582:	84d2                	mv	s1,s4
     584:	b75d                	j	52a <rx2+0x256>
      printf("FAILED rx2: wrong ip src %x\n", src);
     586:	00002517          	auipc	a0,0x2
     58a:	2a250513          	addi	a0,a0,674 # 2828 <malloc+0x2fa>
     58e:	00002097          	auipc	ra,0x2
     592:	ee8080e7          	jalr	-280(ra) # 2476 <printf>
      return 0;
     596:	b7f5                	j	582 <rx2+0x2ae>
      printf("FAILED rx2: len %d too short\n", cc);
     598:	85a6                	mv	a1,s1
     59a:	00002517          	auipc	a0,0x2
     59e:	2b650513          	addi	a0,a0,694 # 2850 <malloc+0x322>
     5a2:	00002097          	auipc	ra,0x2
     5a6:	ed4080e7          	jalr	-300(ra) # 2476 <printf>
      return 0;
     5aa:	bfe1                	j	582 <rx2+0x2ae>
      printf("FAILED rx2: len %d too long\n", cc);
     5ac:	85a6                	mv	a1,s1
     5ae:	00002517          	auipc	a0,0x2
     5b2:	2d250513          	addi	a0,a0,722 # 2880 <malloc+0x352>
     5b6:	00002097          	auipc	ra,0x2
     5ba:	ec0080e7          	jalr	-320(ra) # 2476 <printf>
      return 0;
     5be:	b7d1                	j	582 <rx2+0x2ae>
      printf("FAILED rx2: packet doesn't start with one\n");
     5c0:	00002517          	auipc	a0,0x2
     5c4:	2e850513          	addi	a0,a0,744 # 28a8 <malloc+0x37a>
     5c8:	00002097          	auipc	ra,0x2
     5cc:	eae080e7          	jalr	-338(ra) # 2476 <printf>
      return 0;
     5d0:	bf4d                	j	582 <rx2+0x2ae>
      printf("FAILED rx2: recv() failed\n");
     5d2:	00002517          	auipc	a0,0x2
     5d6:	23650513          	addi	a0,a0,566 # 2808 <malloc+0x2da>
     5da:	00002097          	auipc	ra,0x2
     5de:	e9c080e7          	jalr	-356(ra) # 2476 <printf>
      return 0;
     5e2:	b7a1                	j	52a <rx2+0x256>
      printf("FAILED rx2: wrong ip src %x\n", src);
     5e4:	00002517          	auipc	a0,0x2
     5e8:	24450513          	addi	a0,a0,580 # 2828 <malloc+0x2fa>
     5ec:	00002097          	auipc	ra,0x2
     5f0:	e8a080e7          	jalr	-374(ra) # 2476 <printf>
      return 0;
     5f4:	bf1d                	j	52a <rx2+0x256>
      printf("FAILED rx2: len %d too short\n", cc);
     5f6:	85ca                	mv	a1,s2
     5f8:	00002517          	auipc	a0,0x2
     5fc:	25850513          	addi	a0,a0,600 # 2850 <malloc+0x322>
     600:	00002097          	auipc	ra,0x2
     604:	e76080e7          	jalr	-394(ra) # 2476 <printf>
      return 0;
     608:	b70d                	j	52a <rx2+0x256>
      printf("FAILED rx2: len %d too long\n", cc);
     60a:	85ca                	mv	a1,s2
     60c:	00002517          	auipc	a0,0x2
     610:	27450513          	addi	a0,a0,628 # 2880 <malloc+0x352>
     614:	00002097          	auipc	ra,0x2
     618:	e62080e7          	jalr	-414(ra) # 2476 <printf>
      return 0;
     61c:	b739                	j	52a <rx2+0x256>
      printf("FAILED rx2: packet doesn't start with two\n");
     61e:	00002517          	auipc	a0,0x2
     622:	2c250513          	addi	a0,a0,706 # 28e0 <malloc+0x3b2>
     626:	00002097          	auipc	ra,0x2
     62a:	e50080e7          	jalr	-432(ra) # 2476 <printf>
      return 0;
     62e:	bdf5                	j	52a <rx2+0x256>
      printf("FAILED rx2: recv() failed\n");
     630:	00002517          	auipc	a0,0x2
     634:	1d850513          	addi	a0,a0,472 # 2808 <malloc+0x2da>
     638:	00002097          	auipc	ra,0x2
     63c:	e3e080e7          	jalr	-450(ra) # 2476 <printf>
      return 0;
     640:	84ca                	mv	s1,s2
     642:	b5e5                	j	52a <rx2+0x256>
      printf("FAILED rx2: wrong ip src %x\n", src);
     644:	00002517          	auipc	a0,0x2
     648:	1e450513          	addi	a0,a0,484 # 2828 <malloc+0x2fa>
     64c:	00002097          	auipc	ra,0x2
     650:	e2a080e7          	jalr	-470(ra) # 2476 <printf>
      return 0;
     654:	b7f5                	j	640 <rx2+0x36c>
      printf("FAILED rx2: len %d too short\n", cc);
     656:	85a6                	mv	a1,s1
     658:	00002517          	auipc	a0,0x2
     65c:	1f850513          	addi	a0,a0,504 # 2850 <malloc+0x322>
     660:	00002097          	auipc	ra,0x2
     664:	e16080e7          	jalr	-490(ra) # 2476 <printf>
      return 0;
     668:	bfe1                	j	640 <rx2+0x36c>
      printf("FAILED rx2: len %d too long\n", cc);
     66a:	85a6                	mv	a1,s1
     66c:	00002517          	auipc	a0,0x2
     670:	21450513          	addi	a0,a0,532 # 2880 <malloc+0x352>
     674:	00002097          	auipc	ra,0x2
     678:	e02080e7          	jalr	-510(ra) # 2476 <printf>
      return 0;
     67c:	b7d1                	j	640 <rx2+0x36c>
      printf("FAILED rx2: packet doesn't start with one\n");
     67e:	00002517          	auipc	a0,0x2
     682:	22a50513          	addi	a0,a0,554 # 28a8 <malloc+0x37a>
     686:	00002097          	auipc	ra,0x2
     68a:	df0080e7          	jalr	-528(ra) # 2476 <printf>
      return 0;
     68e:	bf4d                	j	640 <rx2+0x36c>

0000000000000690 <tx>:

//
// send some UDP packets to nettest.py tx.
//
int tx() {
     690:	715d                	addi	sp,sp,-80
     692:	e486                	sd	ra,72(sp)
     694:	e0a2                	sd	s0,64(sp)
     696:	fc26                	sd	s1,56(sp)
     698:	f84a                	sd	s2,48(sp)
     69a:	f44e                	sd	s3,40(sp)
     69c:	f052                	sd	s4,32(sp)
     69e:	ec56                	sd	s5,24(sp)
     6a0:	e85a                	sd	s6,16(sp)
     6a2:	0880                	addi	s0,sp,80
     6a4:	03000493          	li	s1,48
  for (int ii = 0; ii < 5; ii++) {
    uint32 dst = 0x0A000202;  // 10.0.2.2
    int dport = NET_TESTS_PORT;
    char buf[3];
    buf[0] = 't';
     6a8:	07400a93          	li	s5,116
    buf[1] = ' ';
     6ac:	02000a13          	li	s4,32
    buf[2] = '0' + ii;
    if (send(FWDPORT1, dst, dport, buf, 3) < 0) {
     6b0:	6999                	lui	s3,0x6
     6b2:	5f398993          	addi	s3,s3,1523 # 65f3 <base+0x23e3>
     6b6:	0a000937          	lui	s2,0xa000
     6ba:	20290913          	addi	s2,s2,514 # a000202 <base+0x9ffbff2>
  for (int ii = 0; ii < 5; ii++) {
     6be:	03500b13          	li	s6,53
    buf[0] = 't';
     6c2:	fb540c23          	sb	s5,-72(s0)
    buf[1] = ' ';
     6c6:	fb440ca3          	sb	s4,-71(s0)
    buf[2] = '0' + ii;
     6ca:	fa940d23          	sb	s1,-70(s0)
    if (send(FWDPORT1, dst, dport, buf, 3) < 0) {
     6ce:	470d                	li	a4,3
     6d0:	fb840693          	addi	a3,s0,-72
     6d4:	864e                	mv	a2,s3
     6d6:	85ca                	mv	a1,s2
     6d8:	7d000513          	li	a0,2000
     6dc:	00002097          	auipc	ra,0x2
     6e0:	ab0080e7          	jalr	-1360(ra) # 218c <send>
     6e4:	02054763          	bltz	a0,712 <tx+0x82>
      printf("send() failed\n");
      return 0;
    }
    sleep(10);
     6e8:	4529                	li	a0,10
     6ea:	00002097          	auipc	ra,0x2
     6ee:	a82080e7          	jalr	-1406(ra) # 216c <sleep>
  for (int ii = 0; ii < 5; ii++) {
     6f2:	2485                	addiw	s1,s1,1
     6f4:	0ff4f493          	zext.b	s1,s1
     6f8:	fd6495e3          	bne	s1,s6,6c2 <tx+0x32>
  }

  // can't actually tell if the packets arrived.
  return 1;
     6fc:	4505                	li	a0,1
}
     6fe:	60a6                	ld	ra,72(sp)
     700:	6406                	ld	s0,64(sp)
     702:	74e2                	ld	s1,56(sp)
     704:	7942                	ld	s2,48(sp)
     706:	79a2                	ld	s3,40(sp)
     708:	7a02                	ld	s4,32(sp)
     70a:	6ae2                	ld	s5,24(sp)
     70c:	6b42                	ld	s6,16(sp)
     70e:	6161                	addi	sp,sp,80
     710:	8082                	ret
      printf("send() failed\n");
     712:	00002517          	auipc	a0,0x2
     716:	20e50513          	addi	a0,a0,526 # 2920 <malloc+0x3f2>
     71a:	00002097          	auipc	ra,0x2
     71e:	d5c080e7          	jalr	-676(ra) # 2476 <printf>
      return 0;
     722:	4501                	li	a0,0
     724:	bfe9                	j	6fe <tx+0x6e>

0000000000000726 <ping0>:
//
// send just one UDP packets to nettest.py ping,
// expect a reply.
// nettest.py ping must be started first.
//
int ping0() {
     726:	7171                	addi	sp,sp,-176
     728:	f506                	sd	ra,168(sp)
     72a:	f122                	sd	s0,160(sp)
     72c:	ed26                	sd	s1,152(sp)
     72e:	e94a                	sd	s2,144(sp)
     730:	1900                	addi	s0,sp,176
  printf("ping0: starting\n");
     732:	00002517          	auipc	a0,0x2
     736:	1fe50513          	addi	a0,a0,510 # 2930 <malloc+0x402>
     73a:	00002097          	auipc	ra,0x2
     73e:	d3c080e7          	jalr	-708(ra) # 2476 <printf>

  bind(2004);
     742:	7d400513          	li	a0,2004
     746:	00002097          	auipc	ra,0x2
     74a:	a36080e7          	jalr	-1482(ra) # 217c <bind>

  uint32 dst = 0x0A000202;  // 10.0.2.2
  int dport = NET_TESTS_PORT;
  char buf[5];
  memcpy(buf, "ping0", sizeof(buf));
     74e:	4615                	li	a2,5
     750:	00002597          	auipc	a1,0x2
     754:	1f858593          	addi	a1,a1,504 # 2948 <malloc+0x41a>
     758:	fd840513          	addi	a0,s0,-40
     75c:	00002097          	auipc	ra,0x2
     760:	960080e7          	jalr	-1696(ra) # 20bc <memcpy>
  if (send(2004, dst, dport, buf, sizeof(buf)) < 0) {
     764:	4715                	li	a4,5
     766:	fd840693          	addi	a3,s0,-40
     76a:	6619                	lui	a2,0x6
     76c:	5f360613          	addi	a2,a2,1523 # 65f3 <base+0x23e3>
     770:	0a0005b7          	lui	a1,0xa000
     774:	20258593          	addi	a1,a1,514 # a000202 <base+0x9ffbff2>
     778:	7d400513          	li	a0,2004
     77c:	00002097          	auipc	ra,0x2
     780:	a10080e7          	jalr	-1520(ra) # 218c <send>
     784:	06054c63          	bltz	a0,7fc <ping0+0xd6>
    printf("ping0: send() failed\n");
    return 0;
  }

  char ibuf[128];
  uint32 src = 0;
     788:	f4042a23          	sw	zero,-172(s0)
  uint16 sport = 0;
     78c:	f4041923          	sh	zero,-174(s0)
  memset(ibuf, 0, sizeof(ibuf));
     790:	08000613          	li	a2,128
     794:	4581                	li	a1,0
     796:	f5840513          	addi	a0,s0,-168
     79a:	00001097          	auipc	ra,0x1
     79e:	748080e7          	jalr	1864(ra) # 1ee2 <memset>
  int cc = recv(2004, &src, &sport, ibuf, sizeof(ibuf) - 1);
     7a2:	07f00713          	li	a4,127
     7a6:	f5840693          	addi	a3,s0,-168
     7aa:	f5240613          	addi	a2,s0,-174
     7ae:	f5440593          	addi	a1,s0,-172
     7b2:	7d400513          	li	a0,2004
     7b6:	00002097          	auipc	ra,0x2
     7ba:	9de080e7          	jalr	-1570(ra) # 2194 <recv>
     7be:	84aa                	mv	s1,a0
  if (cc < 0) {
     7c0:	04054e63          	bltz	a0,81c <ping0+0xf6>
    printf("ping0: recv() failed\n");
    return 0;
  }

  if (src != 0x0A000202) {  // 10.0.2.2
     7c4:	f5442583          	lw	a1,-172(s0)
     7c8:	0a0007b7          	lui	a5,0xa000
     7cc:	20278793          	addi	a5,a5,514 # a000202 <base+0x9ffbff2>
     7d0:	06f59063          	bne	a1,a5,830 <ping0+0x10a>
    printf("ping0: wrong ip src %x, expecting %x\n", src, 0x0A000202);
    return 0;
  }

  if (sport != NET_TESTS_PORT) {
     7d4:	f5245583          	lhu	a1,-174(s0)
     7d8:	0005871b          	sext.w	a4,a1
     7dc:	6799                	lui	a5,0x6
     7de:	5f378793          	addi	a5,a5,1523 # 65f3 <base+0x23e3>
     7e2:	06f70263          	beq	a4,a5,846 <ping0+0x120>
    printf("ping0: wrong sport %d, expecting %d\n", sport, NET_TESTS_PORT);
     7e6:	863e                	mv	a2,a5
     7e8:	00002517          	auipc	a0,0x2
     7ec:	1c050513          	addi	a0,a0,448 # 29a8 <malloc+0x47a>
     7f0:	00002097          	auipc	ra,0x2
     7f4:	c86080e7          	jalr	-890(ra) # 2476 <printf>
    return 0;
     7f8:	4901                	li	s2,0
     7fa:	a811                	j	80e <ping0+0xe8>
    printf("ping0: send() failed\n");
     7fc:	00002517          	auipc	a0,0x2
     800:	15450513          	addi	a0,a0,340 # 2950 <malloc+0x422>
     804:	00002097          	auipc	ra,0x2
     808:	c72080e7          	jalr	-910(ra) # 2476 <printf>
    return 0;
     80c:	4901                	li	s2,0

  unbind(2004);
  printf("ping0: OK\n");

  return 1;
}
     80e:	854a                	mv	a0,s2
     810:	70aa                	ld	ra,168(sp)
     812:	740a                	ld	s0,160(sp)
     814:	64ea                	ld	s1,152(sp)
     816:	694a                	ld	s2,144(sp)
     818:	614d                	addi	sp,sp,176
     81a:	8082                	ret
    printf("ping0: recv() failed\n");
     81c:	00002517          	auipc	a0,0x2
     820:	14c50513          	addi	a0,a0,332 # 2968 <malloc+0x43a>
     824:	00002097          	auipc	ra,0x2
     828:	c52080e7          	jalr	-942(ra) # 2476 <printf>
    return 0;
     82c:	4901                	li	s2,0
     82e:	b7c5                	j	80e <ping0+0xe8>
    printf("ping0: wrong ip src %x, expecting %x\n", src, 0x0A000202);
     830:	863e                	mv	a2,a5
     832:	00002517          	auipc	a0,0x2
     836:	14e50513          	addi	a0,a0,334 # 2980 <malloc+0x452>
     83a:	00002097          	auipc	ra,0x2
     83e:	c3c080e7          	jalr	-964(ra) # 2476 <printf>
    return 0;
     842:	4901                	li	s2,0
     844:	b7e9                	j	80e <ping0+0xe8>
  if (memcmp(buf, ibuf, sizeof(buf)) != 0) {
     846:	4615                	li	a2,5
     848:	f5840593          	addi	a1,s0,-168
     84c:	fd840513          	addi	a0,s0,-40
     850:	00002097          	auipc	ra,0x2
     854:	832080e7          	jalr	-1998(ra) # 2082 <memcmp>
     858:	892a                	mv	s2,a0
     85a:	ed19                	bnez	a0,878 <ping0+0x152>
  if (cc != sizeof(buf)) {
     85c:	4795                	li	a5,5
     85e:	02f48763          	beq	s1,a5,88c <ping0+0x166>
    printf("ping0: wrong length %d, expecting %ld\n", cc, sizeof(buf));
     862:	4615                	li	a2,5
     864:	85a6                	mv	a1,s1
     866:	00002517          	auipc	a0,0x2
     86a:	18250513          	addi	a0,a0,386 # 29e8 <malloc+0x4ba>
     86e:	00002097          	auipc	ra,0x2
     872:	c08080e7          	jalr	-1016(ra) # 2476 <printf>
    return 0;
     876:	bf61                	j	80e <ping0+0xe8>
    printf("ping0: wrong content\n");
     878:	00002517          	auipc	a0,0x2
     87c:	15850513          	addi	a0,a0,344 # 29d0 <malloc+0x4a2>
     880:	00002097          	auipc	ra,0x2
     884:	bf6080e7          	jalr	-1034(ra) # 2476 <printf>
    return 0;
     888:	4901                	li	s2,0
     88a:	b751                	j	80e <ping0+0xe8>
  unbind(2004);
     88c:	7d400513          	li	a0,2004
     890:	00002097          	auipc	ra,0x2
     894:	8f4080e7          	jalr	-1804(ra) # 2184 <unbind>
  printf("ping0: OK\n");
     898:	00002517          	auipc	a0,0x2
     89c:	17850513          	addi	a0,a0,376 # 2a10 <malloc+0x4e2>
     8a0:	00002097          	auipc	ra,0x2
     8a4:	bd6080e7          	jalr	-1066(ra) # 2476 <printf>
  return 1;
     8a8:	4905                	li	s2,1
     8aa:	b795                	j	80e <ping0+0xe8>

00000000000008ac <ping1>:
//
// send many UDP packets to nettest.py ping,
// expect a reply to each.
// nettest.py ping must be started first.
//
int ping1() {
     8ac:	7155                	addi	sp,sp,-208
     8ae:	e586                	sd	ra,200(sp)
     8b0:	e1a2                	sd	s0,192(sp)
     8b2:	fd26                	sd	s1,184(sp)
     8b4:	f94a                	sd	s2,176(sp)
     8b6:	f54e                	sd	s3,168(sp)
     8b8:	f152                	sd	s4,160(sp)
     8ba:	ed56                	sd	s5,152(sp)
     8bc:	e95a                	sd	s6,144(sp)
     8be:	0980                	addi	s0,sp,208
  printf("ping1: starting\n");
     8c0:	00002517          	auipc	a0,0x2
     8c4:	16050513          	addi	a0,a0,352 # 2a20 <malloc+0x4f2>
     8c8:	00002097          	auipc	ra,0x2
     8cc:	bae080e7          	jalr	-1106(ra) # 2476 <printf>

  bind(2005);
     8d0:	7d500513          	li	a0,2005
     8d4:	00002097          	auipc	ra,0x2
     8d8:	8a8080e7          	jalr	-1880(ra) # 217c <bind>
     8dc:	03000493          	li	s1,48

  for (int ii = 0; ii < 20; ii++) {
    uint32 dst = 0x0A000202;  // 10.0.2.2
    int dport = NET_TESTS_PORT;
    char buf[3];
    buf[0] = 'p';
     8e0:	07000b13          	li	s6,112
    buf[1] = ' ';
     8e4:	02000a93          	li	s5,32
    buf[2] = '0' + ii;
    if (send(2005, dst, dport, buf, 3) < 0) {
     8e8:	6a19                	lui	s4,0x6
     8ea:	5f3a0a13          	addi	s4,s4,1523 # 65f3 <base+0x23e3>
     8ee:	0a0009b7          	lui	s3,0xa000
     8f2:	20298993          	addi	s3,s3,514 # a000202 <base+0x9ffbff2>
    buf[0] = 'p';
     8f6:	f3640c23          	sb	s6,-200(s0)
    buf[1] = ' ';
     8fa:	f3540ca3          	sb	s5,-199(s0)
    buf[2] = '0' + ii;
     8fe:	f2940d23          	sb	s1,-198(s0)
    if (send(2005, dst, dport, buf, 3) < 0) {
     902:	470d                	li	a4,3
     904:	f3840693          	addi	a3,s0,-200
     908:	8652                	mv	a2,s4
     90a:	85ce                	mv	a1,s3
     90c:	7d500513          	li	a0,2005
     910:	00002097          	auipc	ra,0x2
     914:	87c080e7          	jalr	-1924(ra) # 218c <send>
     918:	08054e63          	bltz	a0,9b4 <ping1+0x108>
      printf("FAILED ping1: send() failed\n");
      return 0;
    }

    char ibuf[128];
    uint32 src = 0;
     91c:	f2042e23          	sw	zero,-196(s0)
    uint16 sport = 0;
     920:	f2041b23          	sh	zero,-202(s0)
    memset(ibuf, 0, sizeof(ibuf));
     924:	08000613          	li	a2,128
     928:	4581                	li	a1,0
     92a:	f4040513          	addi	a0,s0,-192
     92e:	00001097          	auipc	ra,0x1
     932:	5b4080e7          	jalr	1460(ra) # 1ee2 <memset>
    int cc = recv(2005, &src, &sport, ibuf, sizeof(ibuf) - 1);
     936:	07f00713          	li	a4,127
     93a:	f4040693          	addi	a3,s0,-192
     93e:	f3640613          	addi	a2,s0,-202
     942:	f3c40593          	addi	a1,s0,-196
     946:	7d500513          	li	a0,2005
     94a:	00002097          	auipc	ra,0x2
     94e:	84a080e7          	jalr	-1974(ra) # 2194 <recv>
     952:	892a                	mv	s2,a0
    if (cc < 0) {
     954:	08054363          	bltz	a0,9da <ping1+0x12e>
      printf("FAILED ping1: recv() failed\n");
      return 0;
    }

    if (src != 0x0A000202) {  // 10.0.2.2
     958:	f3c42583          	lw	a1,-196(s0)
     95c:	09359863          	bne	a1,s3,9ec <ping1+0x140>
      printf("FAILED ping1: wrong ip src %x, expecting %x\n", src, 0x0A000202);
      return 0;
    }

    if (sport != NET_TESTS_PORT) {
     960:	f3645583          	lhu	a1,-202(s0)
     964:	0005879b          	sext.w	a5,a1
     968:	09479f63          	bne	a5,s4,a06 <ping1+0x15a>
      printf("FAILED ping1: wrong sport %d, expecting %d\n", sport,
             NET_TESTS_PORT);
      return 0;
    }

    if (memcmp(buf, ibuf, 3) != 0) {
     96c:	460d                	li	a2,3
     96e:	f4040593          	addi	a1,s0,-192
     972:	f3840513          	addi	a0,s0,-200
     976:	00001097          	auipc	ra,0x1
     97a:	70c080e7          	jalr	1804(ra) # 2082 <memcmp>
     97e:	e145                	bnez	a0,a1e <ping1+0x172>
      printf("FAILED ping1: wrong content\n");
      return 0;
    }

    if (cc != 3) {
     980:	478d                	li	a5,3
     982:	0af91763          	bne	s2,a5,a30 <ping1+0x184>
  for (int ii = 0; ii < 20; ii++) {
     986:	2485                	addiw	s1,s1,1
     988:	0ff4f493          	zext.b	s1,s1
     98c:	04400793          	li	a5,68
     990:	f6f493e3          	bne	s1,a5,8f6 <ping1+0x4a>
      printf("FAILED ping1: wrong length %d, expecting 3\n", cc);
      return 0;
    }
  }

  unbind(2005);
     994:	7d500513          	li	a0,2005
     998:	00001097          	auipc	ra,0x1
     99c:	7ec080e7          	jalr	2028(ra) # 2184 <unbind>
  printf("ping1: OK\n");
     9a0:	00002517          	auipc	a0,0x2
     9a4:	18850513          	addi	a0,a0,392 # 2b28 <malloc+0x5fa>
     9a8:	00002097          	auipc	ra,0x2
     9ac:	ace080e7          	jalr	-1330(ra) # 2476 <printf>

  return 1;
     9b0:	4505                	li	a0,1
     9b2:	a811                	j	9c6 <ping1+0x11a>
      printf("FAILED ping1: send() failed\n");
     9b4:	00002517          	auipc	a0,0x2
     9b8:	08450513          	addi	a0,a0,132 # 2a38 <malloc+0x50a>
     9bc:	00002097          	auipc	ra,0x2
     9c0:	aba080e7          	jalr	-1350(ra) # 2476 <printf>
      return 0;
     9c4:	4501                	li	a0,0
}
     9c6:	60ae                	ld	ra,200(sp)
     9c8:	640e                	ld	s0,192(sp)
     9ca:	74ea                	ld	s1,184(sp)
     9cc:	794a                	ld	s2,176(sp)
     9ce:	79aa                	ld	s3,168(sp)
     9d0:	7a0a                	ld	s4,160(sp)
     9d2:	6aea                	ld	s5,152(sp)
     9d4:	6b4a                	ld	s6,144(sp)
     9d6:	6169                	addi	sp,sp,208
     9d8:	8082                	ret
      printf("FAILED ping1: recv() failed\n");
     9da:	00002517          	auipc	a0,0x2
     9de:	07e50513          	addi	a0,a0,126 # 2a58 <malloc+0x52a>
     9e2:	00002097          	auipc	ra,0x2
     9e6:	a94080e7          	jalr	-1388(ra) # 2476 <printf>
      return 0;
     9ea:	bfe9                	j	9c4 <ping1+0x118>
      printf("FAILED ping1: wrong ip src %x, expecting %x\n", src, 0x0A000202);
     9ec:	0a000637          	lui	a2,0xa000
     9f0:	20260613          	addi	a2,a2,514 # a000202 <base+0x9ffbff2>
     9f4:	00002517          	auipc	a0,0x2
     9f8:	08450513          	addi	a0,a0,132 # 2a78 <malloc+0x54a>
     9fc:	00002097          	auipc	ra,0x2
     a00:	a7a080e7          	jalr	-1414(ra) # 2476 <printf>
      return 0;
     a04:	b7c1                	j	9c4 <ping1+0x118>
      printf("FAILED ping1: wrong sport %d, expecting %d\n", sport,
     a06:	6619                	lui	a2,0x6
     a08:	5f360613          	addi	a2,a2,1523 # 65f3 <base+0x23e3>
     a0c:	00002517          	auipc	a0,0x2
     a10:	09c50513          	addi	a0,a0,156 # 2aa8 <malloc+0x57a>
     a14:	00002097          	auipc	ra,0x2
     a18:	a62080e7          	jalr	-1438(ra) # 2476 <printf>
      return 0;
     a1c:	b765                	j	9c4 <ping1+0x118>
      printf("FAILED ping1: wrong content\n");
     a1e:	00002517          	auipc	a0,0x2
     a22:	0ba50513          	addi	a0,a0,186 # 2ad8 <malloc+0x5aa>
     a26:	00002097          	auipc	ra,0x2
     a2a:	a50080e7          	jalr	-1456(ra) # 2476 <printf>
      return 0;
     a2e:	bf59                	j	9c4 <ping1+0x118>
      printf("FAILED ping1: wrong length %d, expecting 3\n", cc);
     a30:	85ca                	mv	a1,s2
     a32:	00002517          	auipc	a0,0x2
     a36:	0c650513          	addi	a0,a0,198 # 2af8 <malloc+0x5ca>
     a3a:	00002097          	auipc	ra,0x2
     a3e:	a3c080e7          	jalr	-1476(ra) # 2476 <printf>
      return 0;
     a42:	b749                	j	9c4 <ping1+0x118>

0000000000000a44 <ping2>:
//
// send UDP packets from two different ports to nettest.py ping,
// expect a reply to each to appear on the correct port.
// nettest.py ping must be started first.
//
int ping2() {
     a44:	7151                	addi	sp,sp,-240
     a46:	f586                	sd	ra,232(sp)
     a48:	f1a2                	sd	s0,224(sp)
     a4a:	eda6                	sd	s1,216(sp)
     a4c:	e9ca                	sd	s2,208(sp)
     a4e:	e5ce                	sd	s3,200(sp)
     a50:	e1d2                	sd	s4,192(sp)
     a52:	fd56                	sd	s5,184(sp)
     a54:	f95a                	sd	s6,176(sp)
     a56:	f55e                	sd	s7,168(sp)
     a58:	f162                	sd	s8,160(sp)
     a5a:	ed66                	sd	s9,152(sp)
     a5c:	e96a                	sd	s10,144(sp)
     a5e:	1980                	addi	s0,sp,240
  printf("ping2: starting\n");
     a60:	00002517          	auipc	a0,0x2
     a64:	0d850513          	addi	a0,a0,216 # 2b38 <malloc+0x60a>
     a68:	00002097          	auipc	ra,0x2
     a6c:	a0e080e7          	jalr	-1522(ra) # 2476 <printf>

  bind(2006);
     a70:	7d600513          	li	a0,2006
     a74:	00001097          	auipc	ra,0x1
     a78:	708080e7          	jalr	1800(ra) # 217c <bind>
  bind(2007);
     a7c:	7d700513          	li	a0,2007
     a80:	00001097          	auipc	ra,0x1
     a84:	6fc080e7          	jalr	1788(ra) # 217c <bind>
     a88:	04100493          	li	s1,65
int ping2() {
     a8c:	7d700c93          	li	s9,2007
     a90:	7d600a13          	li	s4,2006
      char buf[4];
      buf[0] = 'p';
      buf[1] = ' ';
      buf[2] = (port == 2006 ? 'a' : 'A') + ii;
      buf[3] = '!';
      if (send(port, dst, dport, buf, 4) < 0) {
     a94:	6c19                	lui	s8,0x6
     a96:	5f3c0c13          	addi	s8,s8,1523 # 65f3 <base+0x23e3>
     a9a:	0a000bb7          	lui	s7,0xa000
     a9e:	202b8b93          	addi	s7,s7,514 # a000202 <base+0x9ffbff2>
     aa2:	aadd                	j	c98 <ping2+0x254>
        printf("FAILED ping2: send() failed\n");
     aa4:	00002517          	auipc	a0,0x2
     aa8:	0ac50513          	addi	a0,a0,172 # 2b50 <malloc+0x622>
     aac:	00002097          	auipc	ra,0x2
     ab0:	9ca080e7          	jalr	-1590(ra) # 2476 <printf>
        return 0;
     ab4:	4501                	li	a0,0
     ab6:	a2b9                	j	c04 <ping2+0x1c0>
      uint32 src = 0;
      uint16 sport = 0;
      memset(ibuf, 0, sizeof(ibuf));
      int cc = recv(port, &src, &sport, ibuf, sizeof(ibuf) - 1);
      if (cc < 0) {
        printf("ping2: recv() failed\n");
     ab8:	00002517          	auipc	a0,0x2
     abc:	0b850513          	addi	a0,a0,184 # 2b70 <malloc+0x642>
     ac0:	00002097          	auipc	ra,0x2
     ac4:	9b6080e7          	jalr	-1610(ra) # 2476 <printf>
        return 0;
     ac8:	4501                	li	a0,0
     aca:	aa2d                	j	c04 <ping2+0x1c0>
      }

      if (src != 0x0A000202) {  // 10.0.2.2
        printf("FAILED ping2: wrong ip src %x\n", src);
     acc:	00002517          	auipc	a0,0x2
     ad0:	0bc50513          	addi	a0,a0,188 # 2b88 <malloc+0x65a>
     ad4:	00002097          	auipc	ra,0x2
     ad8:	9a2080e7          	jalr	-1630(ra) # 2476 <printf>
        return 0;
     adc:	b7f5                	j	ac8 <ping2+0x84>
      }

      if (sport != NET_TESTS_PORT) {
        printf("FAILED ping2: wrong sport %d\n", sport);
     ade:	00002517          	auipc	a0,0x2
     ae2:	0ca50513          	addi	a0,a0,202 # 2ba8 <malloc+0x67a>
     ae6:	00002097          	auipc	ra,0x2
     aea:	990080e7          	jalr	-1648(ra) # 2476 <printf>
        return 0;
     aee:	bfe9                	j	ac8 <ping2+0x84>
      }

      if (cc != 4) {
        printf("FAILED ping2: wrong length %d\n", cc);
     af0:	85aa                	mv	a1,a0
     af2:	00002517          	auipc	a0,0x2
     af6:	0d650513          	addi	a0,a0,214 # 2bc8 <malloc+0x69a>
     afa:	00002097          	auipc	ra,0x2
     afe:	97c080e7          	jalr	-1668(ra) # 2476 <printf>
        return 0;
     b02:	b7d9                	j	ac8 <ping2+0x84>
      buf[2] = (port == 2006 ? 'a' : 'A') + ii;
      buf[3] = '!';

      if (memcmp(buf, ibuf, 3) != 0) {
        // possibly recv() sees packets out of order.
        printf("FAILED ping2: wrong content\n");
     b04:	00002517          	auipc	a0,0x2
     b08:	0e450513          	addi	a0,a0,228 # 2be8 <malloc+0x6ba>
     b0c:	00002097          	auipc	ra,0x2
     b10:	96a080e7          	jalr	-1686(ra) # 2476 <printf>
        return 0;
     b14:	bf55                	j	ac8 <ping2+0x84>
  for (int port = 2006; port <= 2007; port++) {
     b16:	7d600a13          	li	s4,2006
      if (src != 0x0A000202) {  // 10.0.2.2
     b1a:	0a000937          	lui	s2,0xa000
     b1e:	20290913          	addi	s2,s2,514 # a000202 <base+0x9ffbff2>
      if (sport != NET_TESTS_PORT) {
     b22:	6999                	lui	s3,0x6
     b24:	5f398993          	addi	s3,s3,1523 # 65f3 <base+0x23e3>
    for (int ii = 0; ii < 5; ii++) {
     b28:	7d600793          	li	a5,2006
     b2c:	04100493          	li	s1,65
     b30:	0efa0863          	beq	s4,a5,c20 <ping2+0x1dc>
     b34:	0ff4f493          	zext.b	s1,s1
     b38:	00548b13          	addi	s6,s1,5
      int cc = recv(port, &src, &sport, ibuf, sizeof(ibuf) - 1);
     b3c:	030a1a93          	slli	s5,s4,0x30
     b40:	030ada93          	srli	s5,s5,0x30
      uint32 src = 0;
     b44:	f0042e23          	sw	zero,-228(s0)
      uint16 sport = 0;
     b48:	f0041b23          	sh	zero,-234(s0)
      memset(ibuf, 0, sizeof(ibuf));
     b4c:	08000613          	li	a2,128
     b50:	4581                	li	a1,0
     b52:	f2040513          	addi	a0,s0,-224
     b56:	00001097          	auipc	ra,0x1
     b5a:	38c080e7          	jalr	908(ra) # 1ee2 <memset>
      int cc = recv(port, &src, &sport, ibuf, sizeof(ibuf) - 1);
     b5e:	07f00713          	li	a4,127
     b62:	f2040693          	addi	a3,s0,-224
     b66:	f1640613          	addi	a2,s0,-234
     b6a:	f1c40593          	addi	a1,s0,-228
     b6e:	8556                	mv	a0,s5
     b70:	00001097          	auipc	ra,0x1
     b74:	624080e7          	jalr	1572(ra) # 2194 <recv>
      if (cc < 0) {
     b78:	f40540e3          	bltz	a0,ab8 <ping2+0x74>
      if (src != 0x0A000202) {  // 10.0.2.2
     b7c:	f1c42583          	lw	a1,-228(s0)
     b80:	f52596e3          	bne	a1,s2,acc <ping2+0x88>
      if (sport != NET_TESTS_PORT) {
     b84:	f1645583          	lhu	a1,-234(s0)
     b88:	0005879b          	sext.w	a5,a1
     b8c:	f53799e3          	bne	a5,s3,ade <ping2+0x9a>
      if (cc != 4) {
     b90:	4791                	li	a5,4
     b92:	f4f51fe3          	bne	a0,a5,af0 <ping2+0xac>
      buf[0] = 'p';
     b96:	07000793          	li	a5,112
     b9a:	f0f40c23          	sb	a5,-232(s0)
      buf[1] = ' ';
     b9e:	02000793          	li	a5,32
     ba2:	f0f40ca3          	sb	a5,-231(s0)
      buf[2] = (port == 2006 ? 'a' : 'A') + ii;
     ba6:	f0940d23          	sb	s1,-230(s0)
      buf[3] = '!';
     baa:	02100793          	li	a5,33
     bae:	f0f40da3          	sb	a5,-229(s0)
      if (memcmp(buf, ibuf, 3) != 0) {
     bb2:	460d                	li	a2,3
     bb4:	f2040593          	addi	a1,s0,-224
     bb8:	f1840513          	addi	a0,s0,-232
     bbc:	00001097          	auipc	ra,0x1
     bc0:	4c6080e7          	jalr	1222(ra) # 2082 <memcmp>
     bc4:	f121                	bnez	a0,b04 <ping2+0xc0>
    for (int ii = 0; ii < 5; ii++) {
     bc6:	2485                	addiw	s1,s1,1
     bc8:	0ff4f493          	zext.b	s1,s1
     bcc:	f7649ce3          	bne	s1,s6,b44 <ping2+0x100>
  for (int port = 2006; port <= 2007; port++) {
     bd0:	2a05                	addiw	s4,s4,1
     bd2:	7d800793          	li	a5,2008
     bd6:	f4fa19e3          	bne	s4,a5,b28 <ping2+0xe4>
      }
    }
  }

  unbind(2006);
     bda:	7d600513          	li	a0,2006
     bde:	00001097          	auipc	ra,0x1
     be2:	5a6080e7          	jalr	1446(ra) # 2184 <unbind>
  unbind(2007);
     be6:	7d700513          	li	a0,2007
     bea:	00001097          	auipc	ra,0x1
     bee:	59a080e7          	jalr	1434(ra) # 2184 <unbind>
  printf("ping2: OK\n");
     bf2:	00002517          	auipc	a0,0x2
     bf6:	01650513          	addi	a0,a0,22 # 2c08 <malloc+0x6da>
     bfa:	00002097          	auipc	ra,0x2
     bfe:	87c080e7          	jalr	-1924(ra) # 2476 <printf>

  return 1;
     c02:	4505                	li	a0,1
}
     c04:	70ae                	ld	ra,232(sp)
     c06:	740e                	ld	s0,224(sp)
     c08:	64ee                	ld	s1,216(sp)
     c0a:	694e                	ld	s2,208(sp)
     c0c:	69ae                	ld	s3,200(sp)
     c0e:	6a0e                	ld	s4,192(sp)
     c10:	7aea                	ld	s5,184(sp)
     c12:	7b4a                	ld	s6,176(sp)
     c14:	7baa                	ld	s7,168(sp)
     c16:	7c0a                	ld	s8,160(sp)
     c18:	6cea                	ld	s9,152(sp)
     c1a:	6d4a                	ld	s10,144(sp)
     c1c:	616d                	addi	sp,sp,240
     c1e:	8082                	ret
     c20:	06100493          	li	s1,97
     c24:	bf01                	j	b34 <ping2+0xf0>
      buf[2] = (port == 2006 ? 'a' : 'A') + ii;
     c26:	f3a40123          	sb	s10,-222(s0)
      buf[3] = '!';
     c2a:	02100793          	li	a5,33
     c2e:	f2f401a3          	sb	a5,-221(s0)
      if (send(port, dst, dport, buf, 4) < 0) {
     c32:	4711                	li	a4,4
     c34:	f2040693          	addi	a3,s0,-224
     c38:	8662                	mv	a2,s8
     c3a:	85de                	mv	a1,s7
     c3c:	8552                	mv	a0,s4
     c3e:	00001097          	auipc	ra,0x1
     c42:	54e080e7          	jalr	1358(ra) # 218c <send>
     c46:	e4054fe3          	bltz	a0,aa4 <ping2+0x60>
     c4a:	2905                	addiw	s2,s2,1
     c4c:	2985                	addiw	s3,s3,1
      buf[0] = 'p';
     c4e:	f3640023          	sb	s6,-224(s0)
      buf[1] = ' ';
     c52:	f35400a3          	sb	s5,-223(s0)
      buf[2] = (port == 2006 ? 'a' : 'A') + ii;
     c56:	fd4908e3          	beq	s2,s4,c26 <ping2+0x1e2>
     c5a:	f2940123          	sb	s1,-222(s0)
      buf[3] = '!';
     c5e:	02100793          	li	a5,33
     c62:	f2f401a3          	sb	a5,-221(s0)
      if (send(port, dst, dport, buf, 4) < 0) {
     c66:	4711                	li	a4,4
     c68:	f2040693          	addi	a3,s0,-224
     c6c:	8662                	mv	a2,s8
     c6e:	85de                	mv	a1,s7
     c70:	03091513          	slli	a0,s2,0x30
     c74:	9141                	srli	a0,a0,0x30
     c76:	00001097          	auipc	ra,0x1
     c7a:	516080e7          	jalr	1302(ra) # 218c <send>
     c7e:	e20543e3          	bltz	a0,aa4 <ping2+0x60>
    for (int port = 2006; port <= 2007; port++) {
     c82:	0009879b          	sext.w	a5,s3
     c86:	fcfcd2e3          	bge	s9,a5,c4a <ping2+0x206>
  for (int ii = 0; ii < 5; ii++) {
     c8a:	2485                	addiw	s1,s1,1
     c8c:	0ff4f493          	zext.b	s1,s1
     c90:	04600793          	li	a5,70
     c94:	e8f481e3          	beq	s1,a5,b16 <ping2+0xd2>
int ping2() {
     c98:	89e6                	mv	s3,s9
     c9a:	8952                	mv	s2,s4
      buf[0] = 'p';
     c9c:	07000b13          	li	s6,112
      buf[1] = ' ';
     ca0:	02000a93          	li	s5,32
      buf[2] = (port == 2006 ? 'a' : 'A') + ii;
     ca4:	02048d1b          	addiw	s10,s1,32
     ca8:	b75d                	j	c4e <ping2+0x20a>

0000000000000caa <ping3>:
// bracketed by two packets from port 2009.
// check that the two packets can be recv()'d on port 2009.
// check that port 2008 had a finite queue length (dropped some).
// nettest.py ping must be started first.
//
int ping3() {
     caa:	7151                	addi	sp,sp,-240
     cac:	f586                	sd	ra,232(sp)
     cae:	f1a2                	sd	s0,224(sp)
     cb0:	eda6                	sd	s1,216(sp)
     cb2:	e9ca                	sd	s2,208(sp)
     cb4:	e5ce                	sd	s3,200(sp)
     cb6:	e1d2                	sd	s4,192(sp)
     cb8:	fd56                	sd	s5,184(sp)
     cba:	f95a                	sd	s6,176(sp)
     cbc:	f55e                	sd	s7,168(sp)
     cbe:	1980                	addi	s0,sp,240
  printf("ping3: starting\n");
     cc0:	00002517          	auipc	a0,0x2
     cc4:	f5850513          	addi	a0,a0,-168 # 2c18 <malloc+0x6ea>
     cc8:	00001097          	auipc	ra,0x1
     ccc:	7ae080e7          	jalr	1966(ra) # 2476 <printf>

  bind(2008);
     cd0:	7d800513          	li	a0,2008
     cd4:	00001097          	auipc	ra,0x1
     cd8:	4a8080e7          	jalr	1192(ra) # 217c <bind>
  bind(2009);
     cdc:	7d900513          	li	a0,2009
     ce0:	00001097          	auipc	ra,0x1
     ce4:	49c080e7          	jalr	1180(ra) # 217c <bind>
  //
  {
    uint32 dst = 0x0A000202;  // 10.0.2.2
    int dport = NET_TESTS_PORT;
    char buf[4];
    buf[0] = 'p';
     ce8:	07000793          	li	a5,112
     cec:	f2f40423          	sb	a5,-216(s0)
    buf[1] = ' ';
     cf0:	02000793          	li	a5,32
     cf4:	f2f404a3          	sb	a5,-215(s0)
    buf[2] = 'A';
     cf8:	04100793          	li	a5,65
     cfc:	f2f40523          	sb	a5,-214(s0)
    buf[3] = '?';
     d00:	03f00793          	li	a5,63
     d04:	f2f405a3          	sb	a5,-213(s0)
    if (send(2009, dst, dport, buf, 4) < 0) {
     d08:	4711                	li	a4,4
     d0a:	f2840693          	addi	a3,s0,-216
     d0e:	6619                	lui	a2,0x6
     d10:	5f360613          	addi	a2,a2,1523 # 65f3 <base+0x23e3>
     d14:	0a0005b7          	lui	a1,0xa000
     d18:	20258593          	addi	a1,a1,514 # a000202 <base+0x9ffbff2>
     d1c:	7d900513          	li	a0,2009
     d20:	00001097          	auipc	ra,0x1
     d24:	46c080e7          	jalr	1132(ra) # 218c <send>
     d28:	20054163          	bltz	a0,f2a <ping3+0x280>
      printf("FAILED ping3: send() failed\n");
      return 0;
    }
  }
  sleep(1);
     d2c:	4505                	li	a0,1
     d2e:	00001097          	auipc	ra,0x1
     d32:	43e080e7          	jalr	1086(ra) # 216c <sleep>
  //
  // send so many packets from 2008 and 2010 that some of the
  // replies must be dropped due to the requirement
  // for finite maximum queueing.
  //
  for (int ii = 0; ii < 257; ii++) {
     d36:	4481                	li	s1,0
    uint32 dst = 0x0A000202;  // 10.0.2.2
    int dport = NET_TESTS_PORT;
    char buf[4];
    buf[0] = 'p';
     d38:	07000b13          	li	s6,112
    buf[1] = ' ';
     d3c:	02000a93          	li	s5,32
    buf[2] = 'a' + ii;
    buf[3] = '!';
     d40:	02100a13          	li	s4,33
    int port = 2008 + (ii % 2) * 2;
    if (send(port, dst, dport, buf, 4) < 0) {
     d44:	6999                	lui	s3,0x6
     d46:	5f398993          	addi	s3,s3,1523 # 65f3 <base+0x23e3>
     d4a:	0a000937          	lui	s2,0xa000
     d4e:	20290913          	addi	s2,s2,514 # a000202 <base+0x9ffbff2>
  for (int ii = 0; ii < 257; ii++) {
     d52:	10100b93          	li	s7,257
    buf[0] = 'p';
     d56:	f3640423          	sb	s6,-216(s0)
    buf[1] = ' ';
     d5a:	f35404a3          	sb	s5,-215(s0)
    buf[2] = 'a' + ii;
     d5e:	0614879b          	addiw	a5,s1,97
     d62:	f2f40523          	sb	a5,-214(s0)
    buf[3] = '!';
     d66:	f34405a3          	sb	s4,-213(s0)
    int port = 2008 + (ii % 2) * 2;
     d6a:	01f4d79b          	srliw	a5,s1,0x1f
     d6e:	0097853b          	addw	a0,a5,s1
     d72:	8905                	andi	a0,a0,1
     d74:	9d1d                	subw	a0,a0,a5
     d76:	3ec5051b          	addiw	a0,a0,1004
     d7a:	0015151b          	slliw	a0,a0,0x1
    if (send(port, dst, dport, buf, 4) < 0) {
     d7e:	1542                	slli	a0,a0,0x30
     d80:	9141                	srli	a0,a0,0x30
     d82:	4711                	li	a4,4
     d84:	f2840693          	addi	a3,s0,-216
     d88:	864e                	mv	a2,s3
     d8a:	85ca                	mv	a1,s2
     d8c:	00001097          	auipc	ra,0x1
     d90:	400080e7          	jalr	1024(ra) # 218c <send>
     d94:	1a054563          	bltz	a0,f3e <ping3+0x294>
  for (int ii = 0; ii < 257; ii++) {
     d98:	2485                	addiw	s1,s1,1
     d9a:	fb749ee3          	bne	s1,s7,d56 <ping3+0xac>
      printf("FAILED ping3: send() failed\n");
      return 0;
    }
  }
  sleep(1);
     d9e:	4505                	li	a0,1
     da0:	00001097          	auipc	ra,0x1
     da4:	3cc080e7          	jalr	972(ra) # 216c <sleep>
  //
  {
    uint32 dst = 0x0A000202;  // 10.0.2.2
    int dport = NET_TESTS_PORT;
    char buf[4];
    buf[0] = 'p';
     da8:	07000793          	li	a5,112
     dac:	f2f40423          	sb	a5,-216(s0)
    buf[1] = ' ';
     db0:	02000793          	li	a5,32
     db4:	f2f404a3          	sb	a5,-215(s0)
    buf[2] = 'B';
     db8:	04200793          	li	a5,66
     dbc:	f2f40523          	sb	a5,-214(s0)
    buf[3] = '?';
     dc0:	03f00793          	li	a5,63
     dc4:	f2f405a3          	sb	a5,-213(s0)
    if (send(2009, dst, dport, buf, 4) < 0) {
     dc8:	4711                	li	a4,4
     dca:	f2840693          	addi	a3,s0,-216
     dce:	6619                	lui	a2,0x6
     dd0:	5f360613          	addi	a2,a2,1523 # 65f3 <base+0x23e3>
     dd4:	0a0005b7          	lui	a1,0xa000
     dd8:	20258593          	addi	a1,a1,514 # a000202 <base+0x9ffbff2>
     ddc:	7d900513          	li	a0,2009
     de0:	00001097          	auipc	ra,0x1
     de4:	3ac080e7          	jalr	940(ra) # 218c <send>
     de8:	04100913          	li	s2,65
     dec:	16054e63          	bltz	a0,f68 <ping3+0x2be>
    if (cc < 0) {
      printf("FAILED ping3: recv() failed\n");
      return 0;
    }

    if (src != 0x0A000202) {  // 10.0.2.2
     df0:	0a0009b7          	lui	s3,0xa000
     df4:	20298993          	addi	s3,s3,514 # a000202 <base+0x9ffbff2>
      printf("FAILED ping3: wrong ip src %x\n", src);
      return 0;
    }

    if (sport != NET_TESTS_PORT) {
     df8:	6a19                	lui	s4,0x6
     dfa:	5f3a0a13          	addi	s4,s4,1523 # 65f3 <base+0x23e3>
    uint32 src = 0;
     dfe:	f2042223          	sw	zero,-220(s0)
    uint16 sport = 0;
     e02:	f0041f23          	sh	zero,-226(s0)
    memset(ibuf, 0, sizeof(ibuf));
     e06:	08000613          	li	a2,128
     e0a:	4581                	li	a1,0
     e0c:	f2840513          	addi	a0,s0,-216
     e10:	00001097          	auipc	ra,0x1
     e14:	0d2080e7          	jalr	210(ra) # 1ee2 <memset>
    int cc = recv(2009, &src, &sport, ibuf, sizeof(ibuf) - 1);
     e18:	07f00713          	li	a4,127
     e1c:	f2840693          	addi	a3,s0,-216
     e20:	f1e40613          	addi	a2,s0,-226
     e24:	f2440593          	addi	a1,s0,-220
     e28:	7d900513          	li	a0,2009
     e2c:	00001097          	auipc	ra,0x1
     e30:	368080e7          	jalr	872(ra) # 2194 <recv>
    if (cc < 0) {
     e34:	14054463          	bltz	a0,f7c <ping3+0x2d2>
    if (src != 0x0A000202) {  // 10.0.2.2
     e38:	f2442583          	lw	a1,-220(s0)
     e3c:	15359a63          	bne	a1,s3,f90 <ping3+0x2e6>
    if (sport != NET_TESTS_PORT) {
     e40:	f1e45583          	lhu	a1,-226(s0)
     e44:	0005879b          	sext.w	a5,a1
     e48:	15479d63          	bne	a5,s4,fa2 <ping3+0x2f8>
      printf("FAILED ping3: wrong sport %d\n", sport);
      return 0;
    }

    if (cc != 4) {
     e4c:	4791                	li	a5,4
     e4e:	16f51363          	bne	a0,a5,fb4 <ping3+0x30a>
    }

    // printf("port=%d ii=%d: %c%c%c\n", port, ii, ibuf[0], ibuf[1], ibuf[2]);

    char buf[4];
    buf[0] = 'p';
     e52:	07000793          	li	a5,112
     e56:	f2f40023          	sb	a5,-224(s0)
    buf[1] = ' ';
     e5a:	02000793          	li	a5,32
     e5e:	f2f400a3          	sb	a5,-223(s0)
    buf[2] = 'A' + ii;
     e62:	f3240123          	sb	s2,-222(s0)
    buf[3] = '?';
     e66:	03f00793          	li	a5,63
     e6a:	f2f401a3          	sb	a5,-221(s0)

    if (memcmp(buf, ibuf, 3) != 0) {
     e6e:	460d                	li	a2,3
     e70:	f2840593          	addi	a1,s0,-216
     e74:	f2040513          	addi	a0,s0,-224
     e78:	00001097          	auipc	ra,0x1
     e7c:	20a080e7          	jalr	522(ra) # 2082 <memcmp>
     e80:	84aa                	mv	s1,a0
     e82:	14051363          	bnez	a0,fc8 <ping3+0x31e>
  for (int ii = 0; ii < 2; ii++) {
     e86:	2905                	addiw	s2,s2,1
     e88:	0ff97913          	zext.b	s2,s2
     e8c:	04300793          	li	a5,67
     e90:	f6f917e3          	bne	s2,a5,dfe <ping3+0x154>

  //
  // now count how many replies were queued for 2008.
  //
  int fds[2];
  pipe(fds);
     e94:	fa840513          	addi	a0,s0,-88
     e98:	00001097          	auipc	ra,0x1
     e9c:	254080e7          	jalr	596(ra) # 20ec <pipe>
  int pid = fork();
     ea0:	00001097          	auipc	ra,0x1
     ea4:	234080e7          	jalr	564(ra) # 20d4 <fork>
     ea8:	89aa                	mv	s3,a0
  if (pid == 0) {
     eaa:	12050863          	beqz	a0,fda <ping3+0x330>
      }
      write(fds[1], "x", 1);
    }
    exit(0);
  }
  close(fds[1]);
     eae:	fac42503          	lw	a0,-84(s0)
     eb2:	00001097          	auipc	ra,0x1
     eb6:	252080e7          	jalr	594(ra) # 2104 <close>

  sleep(5);
     eba:	4515                	li	a0,5
     ebc:	00001097          	auipc	ra,0x1
     ec0:	2b0080e7          	jalr	688(ra) # 216c <sleep>
  static char nbuf[512];
  int n = read(fds[0], nbuf, sizeof(nbuf));
     ec4:	20000613          	li	a2,512
     ec8:	00003597          	auipc	a1,0x3
     ecc:	14858593          	addi	a1,a1,328 # 4010 <nbuf.0>
     ed0:	fa842503          	lw	a0,-88(s0)
     ed4:	00001097          	auipc	ra,0x1
     ed8:	220080e7          	jalr	544(ra) # 20f4 <read>
     edc:	892a                	mv	s2,a0
  close(fds[0]);
     ede:	fa842503          	lw	a0,-88(s0)
     ee2:	00001097          	auipc	ra,0x1
     ee6:	222080e7          	jalr	546(ra) # 2104 <close>
  kill(pid);
     eea:	854e                	mv	a0,s3
     eec:	00001097          	auipc	ra,0x1
     ef0:	220080e7          	jalr	544(ra) # 210c <kill>

  n -= 1;  // the ":"
     ef4:	fff9059b          	addiw	a1,s2,-1
  if (n > 16) {
     ef8:	47c1                	li	a5,16
     efa:	16b7c863          	blt	a5,a1,106a <ping3+0x3c0>
    printf("FAILED ping3: too many packets (%d) were queued on a UDP port\n",
           n);
    return 0;
  }

  unbind(2008);
     efe:	7d800513          	li	a0,2008
     f02:	00001097          	auipc	ra,0x1
     f06:	282080e7          	jalr	642(ra) # 2184 <unbind>
  unbind(2009);
     f0a:	7d900513          	li	a0,2009
     f0e:	00001097          	auipc	ra,0x1
     f12:	276080e7          	jalr	630(ra) # 2184 <unbind>
  printf("ping3: OK\n");
     f16:	00002517          	auipc	a0,0x2
     f1a:	e4a50513          	addi	a0,a0,-438 # 2d60 <malloc+0x832>
     f1e:	00001097          	auipc	ra,0x1
     f22:	558080e7          	jalr	1368(ra) # 2476 <printf>

  return 1;
     f26:	4485                	li	s1,1
     f28:	a025                	j	f50 <ping3+0x2a6>
      printf("FAILED ping3: send() failed\n");
     f2a:	00002517          	auipc	a0,0x2
     f2e:	d0650513          	addi	a0,a0,-762 # 2c30 <malloc+0x702>
     f32:	00001097          	auipc	ra,0x1
     f36:	544080e7          	jalr	1348(ra) # 2476 <printf>
      return 0;
     f3a:	4481                	li	s1,0
     f3c:	a811                	j	f50 <ping3+0x2a6>
      printf("FAILED ping3: send() failed\n");
     f3e:	00002517          	auipc	a0,0x2
     f42:	cf250513          	addi	a0,a0,-782 # 2c30 <malloc+0x702>
     f46:	00001097          	auipc	ra,0x1
     f4a:	530080e7          	jalr	1328(ra) # 2476 <printf>
      return 0;
     f4e:	4481                	li	s1,0
}
     f50:	8526                	mv	a0,s1
     f52:	70ae                	ld	ra,232(sp)
     f54:	740e                	ld	s0,224(sp)
     f56:	64ee                	ld	s1,216(sp)
     f58:	694e                	ld	s2,208(sp)
     f5a:	69ae                	ld	s3,200(sp)
     f5c:	6a0e                	ld	s4,192(sp)
     f5e:	7aea                	ld	s5,184(sp)
     f60:	7b4a                	ld	s6,176(sp)
     f62:	7baa                	ld	s7,168(sp)
     f64:	616d                	addi	sp,sp,240
     f66:	8082                	ret
      printf("FAILED ping3: send() failed\n");
     f68:	00002517          	auipc	a0,0x2
     f6c:	cc850513          	addi	a0,a0,-824 # 2c30 <malloc+0x702>
     f70:	00001097          	auipc	ra,0x1
     f74:	506080e7          	jalr	1286(ra) # 2476 <printf>
      return 0;
     f78:	4481                	li	s1,0
     f7a:	bfd9                	j	f50 <ping3+0x2a6>
      printf("FAILED ping3: recv() failed\n");
     f7c:	00002517          	auipc	a0,0x2
     f80:	cd450513          	addi	a0,a0,-812 # 2c50 <malloc+0x722>
     f84:	00001097          	auipc	ra,0x1
     f88:	4f2080e7          	jalr	1266(ra) # 2476 <printf>
      return 0;
     f8c:	4481                	li	s1,0
     f8e:	b7c9                	j	f50 <ping3+0x2a6>
      printf("FAILED ping3: wrong ip src %x\n", src);
     f90:	00002517          	auipc	a0,0x2
     f94:	ce050513          	addi	a0,a0,-800 # 2c70 <malloc+0x742>
     f98:	00001097          	auipc	ra,0x1
     f9c:	4de080e7          	jalr	1246(ra) # 2476 <printf>
      return 0;
     fa0:	b7f5                	j	f8c <ping3+0x2e2>
      printf("FAILED ping3: wrong sport %d\n", sport);
     fa2:	00002517          	auipc	a0,0x2
     fa6:	cee50513          	addi	a0,a0,-786 # 2c90 <malloc+0x762>
     faa:	00001097          	auipc	ra,0x1
     fae:	4cc080e7          	jalr	1228(ra) # 2476 <printf>
      return 0;
     fb2:	bfe9                	j	f8c <ping3+0x2e2>
      printf("FAILED ping3: wrong length %d\n", cc);
     fb4:	85aa                	mv	a1,a0
     fb6:	00002517          	auipc	a0,0x2
     fba:	cfa50513          	addi	a0,a0,-774 # 2cb0 <malloc+0x782>
     fbe:	00001097          	auipc	ra,0x1
     fc2:	4b8080e7          	jalr	1208(ra) # 2476 <printf>
      return 0;
     fc6:	b7d9                	j	f8c <ping3+0x2e2>
      printf("FAILED ping3: wrong content\n");
     fc8:	00002517          	auipc	a0,0x2
     fcc:	d0850513          	addi	a0,a0,-760 # 2cd0 <malloc+0x7a2>
     fd0:	00001097          	auipc	ra,0x1
     fd4:	4a6080e7          	jalr	1190(ra) # 2476 <printf>
      return 0;
     fd8:	bf55                	j	f8c <ping3+0x2e2>
    close(fds[0]);
     fda:	fa842503          	lw	a0,-88(s0)
     fde:	00001097          	auipc	ra,0x1
     fe2:	126080e7          	jalr	294(ra) # 2104 <close>
    write(fds[1], ":", 1);  // ensure parent's read() doesn't block
     fe6:	4605                	li	a2,1
     fe8:	00002597          	auipc	a1,0x2
     fec:	d0858593          	addi	a1,a1,-760 # 2cf0 <malloc+0x7c2>
     ff0:	fac42503          	lw	a0,-84(s0)
     ff4:	00001097          	auipc	ra,0x1
     ff8:	108080e7          	jalr	264(ra) # 20fc <write>
      write(fds[1], "x", 1);
     ffc:	00002497          	auipc	s1,0x2
    1000:	d1c48493          	addi	s1,s1,-740 # 2d18 <malloc+0x7ea>
    1004:	a809                	j	1016 <ping3+0x36c>
    1006:	4605                	li	a2,1
    1008:	85a6                	mv	a1,s1
    100a:	fac42503          	lw	a0,-84(s0)
    100e:	00001097          	auipc	ra,0x1
    1012:	0ee080e7          	jalr	238(ra) # 20fc <write>
      uint32 src = 0;
    1016:	f2042223          	sw	zero,-220(s0)
      uint16 sport = 0;
    101a:	f2041023          	sh	zero,-224(s0)
      memset(ibuf, 0, sizeof(ibuf));
    101e:	08000613          	li	a2,128
    1022:	4581                	li	a1,0
    1024:	f2840513          	addi	a0,s0,-216
    1028:	00001097          	auipc	ra,0x1
    102c:	eba080e7          	jalr	-326(ra) # 1ee2 <memset>
      int cc = recv(2008, &src, &sport, ibuf, sizeof(ibuf) - 1);
    1030:	07f00713          	li	a4,127
    1034:	f2840693          	addi	a3,s0,-216
    1038:	f2040613          	addi	a2,s0,-224
    103c:	f2440593          	addi	a1,s0,-220
    1040:	7d800513          	li	a0,2008
    1044:	00001097          	auipc	ra,0x1
    1048:	150080e7          	jalr	336(ra) # 2194 <recv>
      if (cc < 0) {
    104c:	fa055de3          	bgez	a0,1006 <ping3+0x35c>
        printf("FAILED ping3: recv failed\n");
    1050:	00002517          	auipc	a0,0x2
    1054:	ca850513          	addi	a0,a0,-856 # 2cf8 <malloc+0x7ca>
    1058:	00001097          	auipc	ra,0x1
    105c:	41e080e7          	jalr	1054(ra) # 2476 <printf>
    exit(0);
    1060:	4501                	li	a0,0
    1062:	00001097          	auipc	ra,0x1
    1066:	07a080e7          	jalr	122(ra) # 20dc <exit>
    printf("FAILED ping3: too many packets (%d) were queued on a UDP port\n",
    106a:	00002517          	auipc	a0,0x2
    106e:	cb650513          	addi	a0,a0,-842 # 2d20 <malloc+0x7f2>
    1072:	00001097          	auipc	ra,0x1
    1076:	404080e7          	jalr	1028(ra) # 2476 <printf>
    return 0;
    107a:	bdd9                	j	f50 <ping3+0x2a6>

000000000000107c <encode_qname>:

// Encode a DNS name
void encode_qname(char *qn, char *host) {
    107c:	7139                	addi	sp,sp,-64
    107e:	fc06                	sd	ra,56(sp)
    1080:	f822                	sd	s0,48(sp)
    1082:	f426                	sd	s1,40(sp)
    1084:	f04a                	sd	s2,32(sp)
    1086:	ec4e                	sd	s3,24(sp)
    1088:	e852                	sd	s4,16(sp)
    108a:	e456                	sd	s5,8(sp)
    108c:	0080                	addi	s0,sp,64
    108e:	8aaa                	mv	s5,a0
    1090:	892e                	mv	s2,a1
  char *l = host;

  for (char *c = host; c < host + strlen(host) + 1; c++) {
    1092:	84ae                	mv	s1,a1
  char *l = host;
    1094:	8a2e                	mv	s4,a1
    if (*c == '.') {
    1096:	02e00993          	li	s3,46
  for (char *c = host; c < host + strlen(host) + 1; c++) {
    109a:	a029                	j	10a4 <encode_qname+0x28>
      *qn++ = (char)(c - l);
    109c:	8ab2                	mv	s5,a2
      for (char *d = l; d < c; d++) {
        *qn++ = *d;
      }
      l = c + 1;  // skip .
    109e:	00148a13          	addi	s4,s1,1
  for (char *c = host; c < host + strlen(host) + 1; c++) {
    10a2:	0485                	addi	s1,s1,1
    10a4:	854a                	mv	a0,s2
    10a6:	00001097          	auipc	ra,0x1
    10aa:	e12080e7          	jalr	-494(ra) # 1eb8 <strlen>
    10ae:	02051793          	slli	a5,a0,0x20
    10b2:	9381                	srli	a5,a5,0x20
    10b4:	0785                	addi	a5,a5,1
    10b6:	97ca                	add	a5,a5,s2
    10b8:	02f4fc63          	bgeu	s1,a5,10f0 <encode_qname+0x74>
    if (*c == '.') {
    10bc:	0004c783          	lbu	a5,0(s1)
    10c0:	ff3791e3          	bne	a5,s3,10a2 <encode_qname+0x26>
      *qn++ = (char)(c - l);
    10c4:	001a8613          	addi	a2,s5,1
    10c8:	414487b3          	sub	a5,s1,s4
    10cc:	00fa8023          	sb	a5,0(s5)
      for (char *d = l; d < c; d++) {
    10d0:	fc9a76e3          	bgeu	s4,s1,109c <encode_qname+0x20>
    10d4:	87d2                	mv	a5,s4
      *qn++ = (char)(c - l);
    10d6:	8732                	mv	a4,a2
        *qn++ = *d;
    10d8:	0705                	addi	a4,a4,1
    10da:	0007c683          	lbu	a3,0(a5)
    10de:	fed70fa3          	sb	a3,-1(a4)
      for (char *d = l; d < c; d++) {
    10e2:	0785                	addi	a5,a5,1
    10e4:	fef49ae3          	bne	s1,a5,10d8 <encode_qname+0x5c>
        *qn++ = *d;
    10e8:	41448ab3          	sub	s5,s1,s4
    10ec:	9ab2                	add	s5,s5,a2
    10ee:	bf45                	j	109e <encode_qname+0x22>
    }
  }
  *qn = '\0';
    10f0:	000a8023          	sb	zero,0(s5)
}
    10f4:	70e2                	ld	ra,56(sp)
    10f6:	7442                	ld	s0,48(sp)
    10f8:	74a2                	ld	s1,40(sp)
    10fa:	7902                	ld	s2,32(sp)
    10fc:	69e2                	ld	s3,24(sp)
    10fe:	6a42                	ld	s4,16(sp)
    1100:	6aa2                	ld	s5,8(sp)
    1102:	6121                	addi	sp,sp,64
    1104:	8082                	ret

0000000000001106 <decode_qname>:

// Decode a DNS name
void decode_qname(char *qn, int max) {
  char *qnMax = qn + max;
    1106:	95aa                	add	a1,a1,a0
    if (l == 0) break;
    for (int i = 0; i < l; i++) {
      *qn = *(qn + 1);
      qn++;
    }
    *qn++ = '.';
    1108:	02e00813          	li	a6,46
    if (qn >= qnMax) {
    110c:	02b56a63          	bltu	a0,a1,1140 <decode_qname+0x3a>
void decode_qname(char *qn, int max) {
    1110:	1141                	addi	sp,sp,-16
    1112:	e406                	sd	ra,8(sp)
    1114:	e022                	sd	s0,0(sp)
    1116:	0800                	addi	s0,sp,16
      printf("FAILED dns: invalid DNS reply\n");
    1118:	00002517          	auipc	a0,0x2
    111c:	c5850513          	addi	a0,a0,-936 # 2d70 <malloc+0x842>
    1120:	00001097          	auipc	ra,0x1
    1124:	356080e7          	jalr	854(ra) # 2476 <printf>
      exit(1);
    1128:	4505                	li	a0,1
    112a:	00001097          	auipc	ra,0x1
    112e:	fb2080e7          	jalr	-78(ra) # 20dc <exit>
    *qn++ = '.';
    1132:	00160793          	addi	a5,a2,1
    1136:	953e                	add	a0,a0,a5
    1138:	01068023          	sb	a6,0(a3)
    if (qn >= qnMax) {
    113c:	fcb57ae3          	bgeu	a0,a1,1110 <decode_qname+0xa>
    int l = *qn;
    1140:	00054683          	lbu	a3,0(a0)
    if (l == 0) break;
    1144:	ce89                	beqz	a3,115e <decode_qname+0x58>
    for (int i = 0; i < l; i++) {
    1146:	0006861b          	sext.w	a2,a3
    114a:	96aa                	add	a3,a3,a0
    if (l == 0) break;
    114c:	87aa                	mv	a5,a0
      *qn = *(qn + 1);
    114e:	0017c703          	lbu	a4,1(a5)
    1152:	00e78023          	sb	a4,0(a5)
      qn++;
    1156:	0785                	addi	a5,a5,1
    for (int i = 0; i < l; i++) {
    1158:	fed79be3          	bne	a5,a3,114e <decode_qname+0x48>
    115c:	bfd9                	j	1132 <decode_qname+0x2c>
    115e:	8082                	ret

0000000000001160 <dns_req>:
  }
}

// Make a DNS request
int dns_req(uint8 *obuf) {
    1160:	7179                	addi	sp,sp,-48
    1162:	f406                	sd	ra,40(sp)
    1164:	f022                	sd	s0,32(sp)
    1166:	ec26                	sd	s1,24(sp)
    1168:	e84a                	sd	s2,16(sp)
    116a:	e44e                	sd	s3,8(sp)
    116c:	1800                	addi	s0,sp,48
  int len = 0;

  struct dns *hdr = (struct dns *)obuf;
  hdr->id = htons(6828);
    116e:	47e9                	li	a5,26
    1170:	00f50023          	sb	a5,0(a0)
    1174:	fac00793          	li	a5,-84
    1178:	00f500a3          	sb	a5,1(a0)
  hdr->rd = 1;
    117c:	00254783          	lbu	a5,2(a0)
    1180:	0017e793          	ori	a5,a5,1
    1184:	00f50123          	sb	a5,2(a0)
  hdr->qdcount = htons(1);
    1188:	00050223          	sb	zero,4(a0)
    118c:	4985                	li	s3,1
    118e:	013502a3          	sb	s3,5(a0)

  len += sizeof(struct dns);

  // qname part of question
  char *qname = (char *)(obuf + sizeof(struct dns));
    1192:	00c50493          	addi	s1,a0,12
  char *s = "nerc.itmo.ru.";
  encode_qname(qname, s);
    1196:	00002597          	auipc	a1,0x2
    119a:	bfa58593          	addi	a1,a1,-1030 # 2d90 <malloc+0x862>
    119e:	8526                	mv	a0,s1
    11a0:	00000097          	auipc	ra,0x0
    11a4:	edc080e7          	jalr	-292(ra) # 107c <encode_qname>
  len += strlen(qname) + 1;
    11a8:	8526                	mv	a0,s1
    11aa:	00001097          	auipc	ra,0x1
    11ae:	d0e080e7          	jalr	-754(ra) # 1eb8 <strlen>
    11b2:	0005091b          	sext.w	s2,a0

  // constants part of question
  struct dns_question *h = (struct dns_question *)(qname + strlen(qname) + 1);
    11b6:	8526                	mv	a0,s1
    11b8:	00001097          	auipc	ra,0x1
    11bc:	d00080e7          	jalr	-768(ra) # 1eb8 <strlen>
    11c0:	02051793          	slli	a5,a0,0x20
    11c4:	9381                	srli	a5,a5,0x20
    11c6:	0785                	addi	a5,a5,1
    11c8:	00f48533          	add	a0,s1,a5
  h->qtype = htons(0x1);
    11cc:	00050023          	sb	zero,0(a0)
    11d0:	013500a3          	sb	s3,1(a0)
  h->qclass = htons(0x1);
    11d4:	00050123          	sb	zero,2(a0)
    11d8:	013501a3          	sb	s3,3(a0)

  len += sizeof(struct dns_question);
  return len;
}
    11dc:	0119051b          	addiw	a0,s2,17
    11e0:	70a2                	ld	ra,40(sp)
    11e2:	7402                	ld	s0,32(sp)
    11e4:	64e2                	ld	s1,24(sp)
    11e6:	6942                	ld	s2,16(sp)
    11e8:	69a2                	ld	s3,8(sp)
    11ea:	6145                	addi	sp,sp,48
    11ec:	8082                	ret

00000000000011ee <dns_rep>:

// Process DNS response
int dns_rep(uint8 *ibuf, int cc) {
    11ee:	7119                	addi	sp,sp,-128
    11f0:	fc86                	sd	ra,120(sp)
    11f2:	f8a2                	sd	s0,112(sp)
    11f4:	f4a6                	sd	s1,104(sp)
    11f6:	f0ca                	sd	s2,96(sp)
    11f8:	ecce                	sd	s3,88(sp)
    11fa:	e8d2                	sd	s4,80(sp)
    11fc:	e4d6                	sd	s5,72(sp)
    11fe:	e0da                	sd	s6,64(sp)
    1200:	fc5e                	sd	s7,56(sp)
    1202:	f862                	sd	s8,48(sp)
    1204:	f466                	sd	s9,40(sp)
    1206:	f06a                	sd	s10,32(sp)
    1208:	ec6e                	sd	s11,24(sp)
    120a:	0100                	addi	s0,sp,128
  struct dns *hdr = (struct dns *)ibuf;
  int len;
  char *qname = 0;
  int record = 0;

  if (cc < sizeof(struct dns)) {
    120c:	47ad                	li	a5,11
    120e:	0cb7fc63          	bgeu	a5,a1,12e6 <dns_rep+0xf8>
    1212:	892a                	mv	s2,a0
    1214:	8aae                	mv	s5,a1
    printf("FAILED dns: reply too short\n");
    return 0;
  }

  if (!hdr->qr) {
    1216:	00250783          	lb	a5,2(a0)
    121a:	0e07d063          	bgez	a5,12fa <dns_rep+0x10c>
    printf("FAILED dns: not a reply for %d\n", ntohs(hdr->id));
    return 0;
  }

  if (hdr->id != htons(6828)) {
    121e:	00054703          	lbu	a4,0(a0)
    1222:	00154783          	lbu	a5,1(a0)
    1226:	07a2                	slli	a5,a5,0x8
    1228:	00e7e6b3          	or	a3,a5,a4
    122c:	672d                	lui	a4,0xb
    122e:	c1a70713          	addi	a4,a4,-998 # ac1a <base+0x6a0a>
    1232:	10e69a63          	bne	a3,a4,1346 <dns_rep+0x158>
    printf("FAILED dns: wrong id %d\n", ntohs(hdr->id));
    return 0;
  }

  if (hdr->rcode != 0) {
    1236:	00354783          	lbu	a5,3(a0)
    123a:	8bbd                	andi	a5,a5,15
    123c:	12079663          	bnez	a5,1368 <dns_rep+0x17a>
  // printf("nscount: %x\n", ntohs(hdr->nscount));
  // printf("arcount: %x\n", ntohs(hdr->arcount));

  len = sizeof(struct dns);

  for (int i = 0; i < ntohs(hdr->qdcount); i++) {
    1240:	00454703          	lbu	a4,4(a0)
    1244:	00554783          	lbu	a5,5(a0)
    1248:	07a2                	slli	a5,a5,0x8
    124a:	8fd9                	or	a5,a5,a4
//

#include "types.h"

static inline uint16 bswaps(uint16 val) {
  return (((val & 0x00ffU) << 8) | ((val & 0xff00U) >> 8));
    124c:	0087971b          	slliw	a4,a5,0x8
    1250:	83a1                	srli	a5,a5,0x8
    1252:	8fd9                	or	a5,a5,a4
    1254:	17c2                	slli	a5,a5,0x30
    1256:	93c1                	srli	a5,a5,0x30
    1258:	4a01                	li	s4,0
  len = sizeof(struct dns);
    125a:	44b1                	li	s1,12
  char *qname = 0;
    125c:	4981                	li	s3,0
  for (int i = 0; i < ntohs(hdr->qdcount); i++) {
    125e:	c3a1                	beqz	a5,129e <dns_rep+0xb0>
    char *qn = (char *)(ibuf + len);
    1260:	009909b3          	add	s3,s2,s1
    qname = qn;
    decode_qname(qn, cc - len);
    1264:	409a85bb          	subw	a1,s5,s1
    1268:	854e                	mv	a0,s3
    126a:	00000097          	auipc	ra,0x0
    126e:	e9c080e7          	jalr	-356(ra) # 1106 <decode_qname>
    len += strlen(qn) + 1;
    1272:	854e                	mv	a0,s3
    1274:	00001097          	auipc	ra,0x1
    1278:	c44080e7          	jalr	-956(ra) # 1eb8 <strlen>
    len += sizeof(struct dns_question);
    127c:	2515                	addiw	a0,a0,5
    127e:	9ca9                	addw	s1,s1,a0
  for (int i = 0; i < ntohs(hdr->qdcount); i++) {
    1280:	2a05                	addiw	s4,s4,1
    1282:	00494703          	lbu	a4,4(s2)
    1286:	00594783          	lbu	a5,5(s2)
    128a:	07a2                	slli	a5,a5,0x8
    128c:	8fd9                	or	a5,a5,a4
    128e:	0087971b          	slliw	a4,a5,0x8
    1292:	83a1                	srli	a5,a5,0x8
    1294:	8fd9                	or	a5,a5,a4
    1296:	17c2                	slli	a5,a5,0x30
    1298:	93c1                	srli	a5,a5,0x30
    129a:	fcfa43e3          	blt	s4,a5,1260 <dns_rep+0x72>
  }

  for (int i = 0; i < ntohs(hdr->ancount); i++) {
    129e:	00694703          	lbu	a4,6(s2)
    12a2:	00794783          	lbu	a5,7(s2)
    12a6:	07a2                	slli	a5,a5,0x8
    12a8:	8fd9                	or	a5,a5,a4
    12aa:	0087971b          	slliw	a4,a5,0x8
    12ae:	83a1                	srli	a5,a5,0x8
    12b0:	8fd9                	or	a5,a5,a4
    12b2:	17c2                	slli	a5,a5,0x30
    12b4:	93c1                	srli	a5,a5,0x30
    12b6:	1e078563          	beqz	a5,14a0 <dns_rep+0x2b2>
    if (len >= cc) {
    12ba:	0d54d463          	bge	s1,s5,1382 <dns_rep+0x194>
    12be:	00002797          	auipc	a5,0x2
    12c2:	00278793          	addi	a5,a5,2 # 32c0 <malloc+0xd92>
    12c6:	00098363          	beqz	s3,12cc <dns_rep+0xde>
    12ca:	87ce                	mv	a5,s3
    12cc:	f8f43423          	sd	a5,-120(s0)
  for (int i = 0; i < ntohs(hdr->ancount); i++) {
    12d0:	4981                	li	s3,0
  int record = 0;
    12d2:	4c01                	li	s8,0
      return 0;
    }

    char *qn = (char *)(ibuf + len);

    if ((int)qn[0] > 63) {  // compression?
    12d4:	03f00b93          	li	s7,63

    struct dns_data *d = (struct dns_data *)(ibuf + len);
    len += sizeof(struct dns_data);
    // printf("type %d ttl %d len %d\n", ntohs(d->type), ntohl(d->ttl),
    // ntohs(d->len));
    if (ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
    12d8:	4b05                	li	s6,1
    12da:	4c91                	li	s9,4
      record = 1;
      printf("dns: arecord for %s is ", qname ? qname : "");
      uint8 *ip = (ibuf + len);
      printf("%d.%d.%d.%d\n", ip[0], ip[1], ip[2], ip[3]);
      if (ip[0] != 77 || ip[1] != 234 || ip[2] != 215 || ip[3] != 132) {
    12dc:	04d00d13          	li	s10,77
    12e0:	0ea00d93          	li	s11,234
    12e4:	a219                	j	13ea <dns_rep+0x1fc>
    printf("FAILED dns: reply too short\n");
    12e6:	00002517          	auipc	a0,0x2
    12ea:	aba50513          	addi	a0,a0,-1350 # 2da0 <malloc+0x872>
    12ee:	00001097          	auipc	ra,0x1
    12f2:	188080e7          	jalr	392(ra) # 2476 <printf>
    return 0;
    12f6:	4c01                	li	s8,0
    12f8:	a03d                	j	1326 <dns_rep+0x138>
    printf("FAILED dns: not a reply for %d\n", ntohs(hdr->id));
    12fa:	00054703          	lbu	a4,0(a0)
    12fe:	00154783          	lbu	a5,1(a0)
    1302:	07a2                	slli	a5,a5,0x8
    1304:	8fd9                	or	a5,a5,a4
    1306:	0087971b          	slliw	a4,a5,0x8
    130a:	83a1                	srli	a5,a5,0x8
    130c:	00e7e5b3          	or	a1,a5,a4
    1310:	15c2                	slli	a1,a1,0x30
    1312:	91c1                	srli	a1,a1,0x30
    1314:	00002517          	auipc	a0,0x2
    1318:	aac50513          	addi	a0,a0,-1364 # 2dc0 <malloc+0x892>
    131c:	00001097          	auipc	ra,0x1
    1320:	15a080e7          	jalr	346(ra) # 2476 <printf>
    return 0;
    1324:	4c01                	li	s8,0
    printf("FAILED dns: didn't receive an arecord\n");
    return 0;
  }

  return 1;
}
    1326:	8562                	mv	a0,s8
    1328:	70e6                	ld	ra,120(sp)
    132a:	7446                	ld	s0,112(sp)
    132c:	74a6                	ld	s1,104(sp)
    132e:	7906                	ld	s2,96(sp)
    1330:	69e6                	ld	s3,88(sp)
    1332:	6a46                	ld	s4,80(sp)
    1334:	6aa6                	ld	s5,72(sp)
    1336:	6b06                	ld	s6,64(sp)
    1338:	7be2                	ld	s7,56(sp)
    133a:	7c42                	ld	s8,48(sp)
    133c:	7ca2                	ld	s9,40(sp)
    133e:	7d02                	ld	s10,32(sp)
    1340:	6de2                	ld	s11,24(sp)
    1342:	6109                	addi	sp,sp,128
    1344:	8082                	ret
    1346:	0086959b          	slliw	a1,a3,0x8
    134a:	0086d69b          	srliw	a3,a3,0x8
    134e:	8dd5                	or	a1,a1,a3
    printf("FAILED dns: wrong id %d\n", ntohs(hdr->id));
    1350:	15c2                	slli	a1,a1,0x30
    1352:	91c1                	srli	a1,a1,0x30
    1354:	00002517          	auipc	a0,0x2
    1358:	a8c50513          	addi	a0,a0,-1396 # 2de0 <malloc+0x8b2>
    135c:	00001097          	auipc	ra,0x1
    1360:	11a080e7          	jalr	282(ra) # 2476 <printf>
    return 0;
    1364:	4c01                	li	s8,0
    1366:	b7c1                	j	1326 <dns_rep+0x138>
    printf("FAILED dns: rcode error: %x\n", hdr->rcode);
    1368:	00354583          	lbu	a1,3(a0)
    136c:	89bd                	andi	a1,a1,15
    136e:	00002517          	auipc	a0,0x2
    1372:	a9250513          	addi	a0,a0,-1390 # 2e00 <malloc+0x8d2>
    1376:	00001097          	auipc	ra,0x1
    137a:	100080e7          	jalr	256(ra) # 2476 <printf>
    return 0;
    137e:	4c01                	li	s8,0
    1380:	b75d                	j	1326 <dns_rep+0x138>
      printf("FAILED dns: invalid DNS reply\n");
    1382:	00002517          	auipc	a0,0x2
    1386:	9ee50513          	addi	a0,a0,-1554 # 2d70 <malloc+0x842>
    138a:	00001097          	auipc	ra,0x1
    138e:	0ec080e7          	jalr	236(ra) # 2476 <printf>
      return 0;
    1392:	4c01                	li	s8,0
    1394:	bf49                	j	1326 <dns_rep+0x138>
      decode_qname(qn, cc - len);
    1396:	409a85bb          	subw	a1,s5,s1
    139a:	8552                	mv	a0,s4
    139c:	00000097          	auipc	ra,0x0
    13a0:	d6a080e7          	jalr	-662(ra) # 1106 <decode_qname>
      len += strlen(qn) + 1;
    13a4:	8552                	mv	a0,s4
    13a6:	00001097          	auipc	ra,0x1
    13aa:	b12080e7          	jalr	-1262(ra) # 1eb8 <strlen>
    13ae:	2485                	addiw	s1,s1,1
    13b0:	9ca9                	addw	s1,s1,a0
    13b2:	a099                	j	13f8 <dns_rep+0x20a>
        printf("FAILED dns: wrong ip address");
    13b4:	00002517          	auipc	a0,0x2
    13b8:	a9450513          	addi	a0,a0,-1388 # 2e48 <malloc+0x91a>
    13bc:	00001097          	auipc	ra,0x1
    13c0:	0ba080e7          	jalr	186(ra) # 2476 <printf>
        return 0;
    13c4:	4c01                	li	s8,0
    13c6:	b785                	j	1326 <dns_rep+0x138>
  for (int i = 0; i < ntohs(hdr->ancount); i++) {
    13c8:	2985                	addiw	s3,s3,1
    13ca:	00694703          	lbu	a4,6(s2)
    13ce:	00794783          	lbu	a5,7(s2)
    13d2:	07a2                	slli	a5,a5,0x8
    13d4:	8fd9                	or	a5,a5,a4
    13d6:	0087971b          	slliw	a4,a5,0x8
    13da:	83a1                	srli	a5,a5,0x8
    13dc:	8fd9                	or	a5,a5,a4
    13de:	17c2                	slli	a5,a5,0x30
    13e0:	93c1                	srli	a5,a5,0x30
    13e2:	0cf9d063          	bge	s3,a5,14a2 <dns_rep+0x2b4>
    if (len >= cc) {
    13e6:	f954dee3          	bge	s1,s5,1382 <dns_rep+0x194>
    char *qn = (char *)(ibuf + len);
    13ea:	00990a33          	add	s4,s2,s1
    if ((int)qn[0] > 63) {  // compression?
    13ee:	000a4783          	lbu	a5,0(s4)
    13f2:	fafbf2e3          	bgeu	s7,a5,1396 <dns_rep+0x1a8>
      len += 2;
    13f6:	2489                	addiw	s1,s1,2
    struct dns_data *d = (struct dns_data *)(ibuf + len);
    13f8:	00990733          	add	a4,s2,s1
    len += sizeof(struct dns_data);
    13fc:	00048a1b          	sext.w	s4,s1
    1400:	24a9                	addiw	s1,s1,10
    if (ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
    1402:	00074683          	lbu	a3,0(a4)
    1406:	00174783          	lbu	a5,1(a4)
    140a:	07a2                	slli	a5,a5,0x8
    140c:	8fd5                	or	a5,a5,a3
    140e:	0087969b          	slliw	a3,a5,0x8
    1412:	83a1                	srli	a5,a5,0x8
    1414:	8fd5                	or	a5,a5,a3
    1416:	17c2                	slli	a5,a5,0x30
    1418:	93c1                	srli	a5,a5,0x30
    141a:	fb6797e3          	bne	a5,s6,13c8 <dns_rep+0x1da>
    141e:	00874683          	lbu	a3,8(a4)
    1422:	00974783          	lbu	a5,9(a4)
    1426:	07a2                	slli	a5,a5,0x8
    1428:	8fd5                	or	a5,a5,a3
    142a:	0087971b          	slliw	a4,a5,0x8
    142e:	83a1                	srli	a5,a5,0x8
    1430:	8fd9                	or	a5,a5,a4
    1432:	17c2                	slli	a5,a5,0x30
    1434:	93c1                	srli	a5,a5,0x30
    1436:	f99799e3          	bne	a5,s9,13c8 <dns_rep+0x1da>
      printf("dns: arecord for %s is ", qname ? qname : "");
    143a:	f8843583          	ld	a1,-120(s0)
    143e:	00002517          	auipc	a0,0x2
    1442:	9e250513          	addi	a0,a0,-1566 # 2e20 <malloc+0x8f2>
    1446:	00001097          	auipc	ra,0x1
    144a:	030080e7          	jalr	48(ra) # 2476 <printf>
      uint8 *ip = (ibuf + len);
    144e:	94ca                	add	s1,s1,s2
      printf("%d.%d.%d.%d\n", ip[0], ip[1], ip[2], ip[3]);
    1450:	0034c703          	lbu	a4,3(s1)
    1454:	0024c683          	lbu	a3,2(s1)
    1458:	0014c603          	lbu	a2,1(s1)
    145c:	0004c583          	lbu	a1,0(s1)
    1460:	00002517          	auipc	a0,0x2
    1464:	9d850513          	addi	a0,a0,-1576 # 2e38 <malloc+0x90a>
    1468:	00001097          	auipc	ra,0x1
    146c:	00e080e7          	jalr	14(ra) # 2476 <printf>
      if (ip[0] != 77 || ip[1] != 234 || ip[2] != 215 || ip[3] != 132) {
    1470:	0004c783          	lbu	a5,0(s1)
    1474:	f5a790e3          	bne	a5,s10,13b4 <dns_rep+0x1c6>
    1478:	0014c783          	lbu	a5,1(s1)
    147c:	f3b79ce3          	bne	a5,s11,13b4 <dns_rep+0x1c6>
    1480:	0024c783          	lbu	a5,2(s1)
    1484:	0d700713          	li	a4,215
    1488:	f2e796e3          	bne	a5,a4,13b4 <dns_rep+0x1c6>
    148c:	0034c703          	lbu	a4,3(s1)
    1490:	08400793          	li	a5,132
    1494:	f2f710e3          	bne	a4,a5,13b4 <dns_rep+0x1c6>
      len += 4;
    1498:	00ea049b          	addiw	s1,s4,14
      record = 1;
    149c:	8c5a                	mv	s8,s6
    149e:	b72d                	j	13c8 <dns_rep+0x1da>
  int record = 0;
    14a0:	4c01                	li	s8,0
  for (int i = 0; i < ntohs(hdr->arcount); i++) {
    14a2:	00a94703          	lbu	a4,10(s2)
    14a6:	00b94783          	lbu	a5,11(s2)
    14aa:	07a2                	slli	a5,a5,0x8
    14ac:	8fd9                	or	a5,a5,a4
    14ae:	0087971b          	slliw	a4,a5,0x8
    14b2:	0087d613          	srli	a2,a5,0x8
    14b6:	8e59                	or	a2,a2,a4
    14b8:	1642                	slli	a2,a2,0x30
    14ba:	9241                	srli	a2,a2,0x30
    14bc:	04c05e63          	blez	a2,1518 <dns_rep+0x32a>
    14c0:	4681                	li	a3,0
    if (ntohs(d->type) != 41) {
    14c2:	02900513          	li	a0,41
    if (*qn != 0) {
    14c6:	009907b3          	add	a5,s2,s1
    14ca:	0007c783          	lbu	a5,0(a5)
    14ce:	e3b5                	bnez	a5,1532 <dns_rep+0x344>
    struct dns_data *d = (struct dns_data *)(ibuf + len);
    14d0:	0014871b          	addiw	a4,s1,1
    14d4:	974a                	add	a4,a4,s2
    len += sizeof(struct dns_data);
    14d6:	24ad                	addiw	s1,s1,11
    if (ntohs(d->type) != 41) {
    14d8:	00074583          	lbu	a1,0(a4)
    14dc:	00174783          	lbu	a5,1(a4)
    14e0:	07a2                	slli	a5,a5,0x8
    14e2:	8fcd                	or	a5,a5,a1
    14e4:	0087959b          	slliw	a1,a5,0x8
    14e8:	83a1                	srli	a5,a5,0x8
    14ea:	8fcd                	or	a5,a5,a1
    14ec:	17c2                	slli	a5,a5,0x30
    14ee:	93c1                	srli	a5,a5,0x30
    14f0:	04a79b63          	bne	a5,a0,1546 <dns_rep+0x358>
    len += ntohs(d->len);
    14f4:	00874583          	lbu	a1,8(a4)
    14f8:	00974783          	lbu	a5,9(a4)
    14fc:	07a2                	slli	a5,a5,0x8
    14fe:	8fcd                	or	a5,a5,a1
    1500:	0087971b          	slliw	a4,a5,0x8
    1504:	83a1                	srli	a5,a5,0x8
    1506:	8fd9                	or	a5,a5,a4
    1508:	0107979b          	slliw	a5,a5,0x10
    150c:	0107d79b          	srliw	a5,a5,0x10
    1510:	9cbd                	addw	s1,s1,a5
  for (int i = 0; i < ntohs(hdr->arcount); i++) {
    1512:	2685                	addiw	a3,a3,1
    1514:	fac699e3          	bne	a3,a2,14c6 <dns_rep+0x2d8>
  if (len != cc) {
    1518:	049a9163          	bne	s5,s1,155a <dns_rep+0x36c>
  if (!record) {
    151c:	e00c15e3          	bnez	s8,1326 <dns_rep+0x138>
    printf("FAILED dns: didn't receive an arecord\n");
    1520:	00002517          	auipc	a0,0x2
    1524:	9d050513          	addi	a0,a0,-1584 # 2ef0 <malloc+0x9c2>
    1528:	00001097          	auipc	ra,0x1
    152c:	f4e080e7          	jalr	-178(ra) # 2476 <printf>
    return 0;
    1530:	bbdd                	j	1326 <dns_rep+0x138>
      printf("FAILED dns: invalid name for EDNS\n");
    1532:	00002517          	auipc	a0,0x2
    1536:	93650513          	addi	a0,a0,-1738 # 2e68 <malloc+0x93a>
    153a:	00001097          	auipc	ra,0x1
    153e:	f3c080e7          	jalr	-196(ra) # 2476 <printf>
      return 0;
    1542:	4c01                	li	s8,0
    1544:	b3cd                	j	1326 <dns_rep+0x138>
      printf("FAILED dns: invalid type for EDNS\n");
    1546:	00002517          	auipc	a0,0x2
    154a:	94a50513          	addi	a0,a0,-1718 # 2e90 <malloc+0x962>
    154e:	00001097          	auipc	ra,0x1
    1552:	f28080e7          	jalr	-216(ra) # 2476 <printf>
      return 0;
    1556:	4c01                	li	s8,0
    1558:	b3f9                	j	1326 <dns_rep+0x138>
    printf("FAILED dns: processed %d data bytes but received %d\n", len, cc);
    155a:	8656                	mv	a2,s5
    155c:	85a6                	mv	a1,s1
    155e:	00002517          	auipc	a0,0x2
    1562:	95a50513          	addi	a0,a0,-1702 # 2eb8 <malloc+0x98a>
    1566:	00001097          	auipc	ra,0x1
    156a:	f10080e7          	jalr	-240(ra) # 2476 <printf>
    return 0;
    156e:	4c01                	li	s8,0
    1570:	bb5d                	j	1326 <dns_rep+0x138>

0000000000001572 <dns>:

int dns() {
    1572:	7179                	addi	sp,sp,-48
    1574:	f406                	sd	ra,40(sp)
    1576:	f022                	sd	s0,32(sp)
    1578:	ec26                	sd	s1,24(sp)
    157a:	1800                	addi	s0,sp,48
    157c:	83010113          	addi	sp,sp,-2000
  uint8 obuf[N];
  uint8 ibuf[N];
  uint32 dst;
  int len;

  printf("dns: starting\n");
    1580:	00002517          	auipc	a0,0x2
    1584:	99850513          	addi	a0,a0,-1640 # 2f18 <malloc+0x9ea>
    1588:	00001097          	auipc	ra,0x1
    158c:	eee080e7          	jalr	-274(ra) # 2476 <printf>

  memset(obuf, 0, N);
    1590:	3e800613          	li	a2,1000
    1594:	4581                	li	a1,0
    1596:	bf840513          	addi	a0,s0,-1032
    159a:	00001097          	auipc	ra,0x1
    159e:	948080e7          	jalr	-1720(ra) # 1ee2 <memset>
  memset(ibuf, 0, N);
    15a2:	3e800613          	li	a2,1000
    15a6:	4581                	li	a1,0
    15a8:	81040513          	addi	a0,s0,-2032
    15ac:	00001097          	auipc	ra,0x1
    15b0:	936080e7          	jalr	-1738(ra) # 1ee2 <memset>

  // 8.8.8.8: google's name server
  dst = (8 << 24) | (8 << 16) | (8 << 8) | (8 << 0);

  len = dns_req(obuf);
    15b4:	bf840513          	addi	a0,s0,-1032
    15b8:	00000097          	auipc	ra,0x0
    15bc:	ba8080e7          	jalr	-1112(ra) # 1160 <dns_req>
    15c0:	84aa                	mv	s1,a0

  bind(2011);
    15c2:	7db00513          	li	a0,2011
    15c6:	00001097          	auipc	ra,0x1
    15ca:	bb6080e7          	jalr	-1098(ra) # 217c <bind>

  if (send(2011, dst, 53, (char *)obuf, len) < 0) {
    15ce:	0004871b          	sext.w	a4,s1
    15d2:	bf840693          	addi	a3,s0,-1032
    15d6:	03500613          	li	a2,53
    15da:	080815b7          	lui	a1,0x8081
    15de:	80858593          	addi	a1,a1,-2040 # 8080808 <base+0x807c5f8>
    15e2:	7db00513          	li	a0,2011
    15e6:	00001097          	auipc	ra,0x1
    15ea:	ba6080e7          	jalr	-1114(ra) # 218c <send>
    15ee:	04054863          	bltz	a0,163e <dns+0xcc>
    return 0;
  }

  uint32 src;
  uint16 sport;
  int cc = recv(2011, &src, &sport, (char *)ibuf, sizeof(ibuf));
    15f2:	3e800713          	li	a4,1000
    15f6:	81040693          	addi	a3,s0,-2032
    15fa:	80a40613          	addi	a2,s0,-2038
    15fe:	80c40593          	addi	a1,s0,-2036
    1602:	7db00513          	li	a0,2011
    1606:	00001097          	auipc	ra,0x1
    160a:	b8e080e7          	jalr	-1138(ra) # 2194 <recv>
    160e:	84aa                	mv	s1,a0
  if (cc < 0) {
    1610:	04054163          	bltz	a0,1652 <dns+0xe0>
    printf("FAILED dns: recv() failed %d\n", cc);
    return 0;
  }

  unbind(2011);
    1614:	7db00513          	li	a0,2011
    1618:	00001097          	auipc	ra,0x1
    161c:	b6c080e7          	jalr	-1172(ra) # 2184 <unbind>

  if (dns_rep(ibuf, cc)) {
    1620:	85a6                	mv	a1,s1
    1622:	81040513          	addi	a0,s0,-2032
    1626:	00000097          	auipc	ra,0x0
    162a:	bc8080e7          	jalr	-1080(ra) # 11ee <dns_rep>
    162e:	ed0d                	bnez	a0,1668 <dns+0xf6>
    printf("dns: OK\n");
    return 1;
  } else {
    return 0;
  }
}
    1630:	7d010113          	addi	sp,sp,2000
    1634:	70a2                	ld	ra,40(sp)
    1636:	7402                	ld	s0,32(sp)
    1638:	64e2                	ld	s1,24(sp)
    163a:	6145                	addi	sp,sp,48
    163c:	8082                	ret
    printf("FAILED dns: send() failed\n");
    163e:	00002517          	auipc	a0,0x2
    1642:	8ea50513          	addi	a0,a0,-1814 # 2f28 <malloc+0x9fa>
    1646:	00001097          	auipc	ra,0x1
    164a:	e30080e7          	jalr	-464(ra) # 2476 <printf>
    return 0;
    164e:	4501                	li	a0,0
    1650:	b7c5                	j	1630 <dns+0xbe>
    printf("FAILED dns: recv() failed %d\n", cc);
    1652:	85aa                	mv	a1,a0
    1654:	00002517          	auipc	a0,0x2
    1658:	8f450513          	addi	a0,a0,-1804 # 2f48 <malloc+0xa1a>
    165c:	00001097          	auipc	ra,0x1
    1660:	e1a080e7          	jalr	-486(ra) # 2476 <printf>
    return 0;
    1664:	4501                	li	a0,0
    1666:	b7e9                	j	1630 <dns+0xbe>
    printf("dns: OK\n");
    1668:	00002517          	auipc	a0,0x2
    166c:	90050513          	addi	a0,a0,-1792 # 2f68 <malloc+0xa3a>
    1670:	00001097          	auipc	ra,0x1
    1674:	e06080e7          	jalr	-506(ra) # 2476 <printf>
    return 1;
    1678:	4505                	li	a0,1
    167a:	bf5d                	j	1630 <dns+0xbe>

000000000000167c <usage>:

void usage() {
    167c:	1141                	addi	sp,sp,-16
    167e:	e406                	sd	ra,8(sp)
    1680:	e022                	sd	s0,0(sp)
    1682:	0800                	addi	s0,sp,16
  printf("Usage: nettest txone\n");
    1684:	00002517          	auipc	a0,0x2
    1688:	8f450513          	addi	a0,a0,-1804 # 2f78 <malloc+0xa4a>
    168c:	00001097          	auipc	ra,0x1
    1690:	dea080e7          	jalr	-534(ra) # 2476 <printf>
  printf("       nettest tx\n");
    1694:	00002517          	auipc	a0,0x2
    1698:	8fc50513          	addi	a0,a0,-1796 # 2f90 <malloc+0xa62>
    169c:	00001097          	auipc	ra,0x1
    16a0:	dda080e7          	jalr	-550(ra) # 2476 <printf>
  printf("       nettest rx\n");
    16a4:	00002517          	auipc	a0,0x2
    16a8:	90450513          	addi	a0,a0,-1788 # 2fa8 <malloc+0xa7a>
    16ac:	00001097          	auipc	ra,0x1
    16b0:	dca080e7          	jalr	-566(ra) # 2476 <printf>
  printf("       nettest rx2\n");
    16b4:	00002517          	auipc	a0,0x2
    16b8:	90c50513          	addi	a0,a0,-1780 # 2fc0 <malloc+0xa92>
    16bc:	00001097          	auipc	ra,0x1
    16c0:	dba080e7          	jalr	-582(ra) # 2476 <printf>
  printf("       nettest rxburst\n");
    16c4:	00002517          	auipc	a0,0x2
    16c8:	91450513          	addi	a0,a0,-1772 # 2fd8 <malloc+0xaaa>
    16cc:	00001097          	auipc	ra,0x1
    16d0:	daa080e7          	jalr	-598(ra) # 2476 <printf>
  printf("       nettest ping1\n");
    16d4:	00002517          	auipc	a0,0x2
    16d8:	91c50513          	addi	a0,a0,-1764 # 2ff0 <malloc+0xac2>
    16dc:	00001097          	auipc	ra,0x1
    16e0:	d9a080e7          	jalr	-614(ra) # 2476 <printf>
  printf("       nettest ping2\n");
    16e4:	00002517          	auipc	a0,0x2
    16e8:	92450513          	addi	a0,a0,-1756 # 3008 <malloc+0xada>
    16ec:	00001097          	auipc	ra,0x1
    16f0:	d8a080e7          	jalr	-630(ra) # 2476 <printf>
  printf("       nettest ping3\n");
    16f4:	00002517          	auipc	a0,0x2
    16f8:	92c50513          	addi	a0,a0,-1748 # 3020 <malloc+0xaf2>
    16fc:	00001097          	auipc	ra,0x1
    1700:	d7a080e7          	jalr	-646(ra) # 2476 <printf>
  printf("       nettest dns\n");
    1704:	00002517          	auipc	a0,0x2
    1708:	93450513          	addi	a0,a0,-1740 # 3038 <malloc+0xb0a>
    170c:	00001097          	auipc	ra,0x1
    1710:	d6a080e7          	jalr	-662(ra) # 2476 <printf>
  printf("       nettest grade\n");
    1714:	00002517          	auipc	a0,0x2
    1718:	93c50513          	addi	a0,a0,-1732 # 3050 <malloc+0xb22>
    171c:	00001097          	auipc	ra,0x1
    1720:	d5a080e7          	jalr	-678(ra) # 2476 <printf>
  printf("       nettest unbind\n");
    1724:	00002517          	auipc	a0,0x2
    1728:	94450513          	addi	a0,a0,-1724 # 3068 <malloc+0xb3a>
    172c:	00001097          	auipc	ra,0x1
    1730:	d4a080e7          	jalr	-694(ra) # 2476 <printf>
  printf("       nettest allports\n");
    1734:	00002517          	auipc	a0,0x2
    1738:	94c50513          	addi	a0,a0,-1716 # 3080 <malloc+0xb52>
    173c:	00001097          	auipc	ra,0x1
    1740:	d3a080e7          	jalr	-710(ra) # 2476 <printf>
  exit(1);
    1744:	4505                	li	a0,1
    1746:	00001097          	auipc	ra,0x1
    174a:	996080e7          	jalr	-1642(ra) # 20dc <exit>

000000000000174e <countfree>:
// use sbrk() to count how many free physical memory pages there are.
// touches the pages to force allocation.
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int countfree() {
    174e:	7139                	addi	sp,sp,-64
    1750:	fc06                	sd	ra,56(sp)
    1752:	f822                	sd	s0,48(sp)
    1754:	f426                	sd	s1,40(sp)
    1756:	f04a                	sd	s2,32(sp)
    1758:	ec4e                	sd	s3,24(sp)
    175a:	0080                	addi	s0,sp,64
  int fds[2];

  if (pipe(fds) < 0) {
    175c:	fc840513          	addi	a0,s0,-56
    1760:	00001097          	auipc	ra,0x1
    1764:	98c080e7          	jalr	-1652(ra) # 20ec <pipe>
    1768:	06054763          	bltz	a0,17d6 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }

  int pid = fork();
    176c:	00001097          	auipc	ra,0x1
    1770:	968080e7          	jalr	-1688(ra) # 20d4 <fork>

  if (pid < 0) {
    1774:	06054e63          	bltz	a0,17f0 <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if (pid == 0) {
    1778:	ed51                	bnez	a0,1814 <countfree+0xc6>
    close(fds[0]);
    177a:	fc842503          	lw	a0,-56(s0)
    177e:	00001097          	auipc	ra,0x1
    1782:	986080e7          	jalr	-1658(ra) # 2104 <close>

    while (1) {
      uint64 a = (uint64)sbrk(4096);
      if (a == 0xffffffffffffffff) {
    1786:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    1788:	4485                	li	s1,1

      // report back one more page.
      if (write(fds[1], "x", 1) != 1) {
    178a:	00001997          	auipc	s3,0x1
    178e:	58e98993          	addi	s3,s3,1422 # 2d18 <malloc+0x7ea>
      uint64 a = (uint64)sbrk(4096);
    1792:	6505                	lui	a0,0x1
    1794:	00001097          	auipc	ra,0x1
    1798:	9d0080e7          	jalr	-1584(ra) # 2164 <sbrk>
      if (a == 0xffffffffffffffff) {
    179c:	07250763          	beq	a0,s2,180a <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    17a0:	6785                	lui	a5,0x1
    17a2:	97aa                	add	a5,a5,a0
    17a4:	fe978fa3          	sb	s1,-1(a5) # fff <ping3+0x355>
      if (write(fds[1], "x", 1) != 1) {
    17a8:	8626                	mv	a2,s1
    17aa:	85ce                	mv	a1,s3
    17ac:	fcc42503          	lw	a0,-52(s0)
    17b0:	00001097          	auipc	ra,0x1
    17b4:	94c080e7          	jalr	-1716(ra) # 20fc <write>
    17b8:	fc950de3          	beq	a0,s1,1792 <countfree+0x44>
        printf("write() failed in countfree()\n");
    17bc:	00002517          	auipc	a0,0x2
    17c0:	92450513          	addi	a0,a0,-1756 # 30e0 <malloc+0xbb2>
    17c4:	00001097          	auipc	ra,0x1
    17c8:	cb2080e7          	jalr	-846(ra) # 2476 <printf>
        exit(1);
    17cc:	4505                	li	a0,1
    17ce:	00001097          	auipc	ra,0x1
    17d2:	90e080e7          	jalr	-1778(ra) # 20dc <exit>
    printf("pipe() failed in countfree()\n");
    17d6:	00002517          	auipc	a0,0x2
    17da:	8ca50513          	addi	a0,a0,-1846 # 30a0 <malloc+0xb72>
    17de:	00001097          	auipc	ra,0x1
    17e2:	c98080e7          	jalr	-872(ra) # 2476 <printf>
    exit(1);
    17e6:	4505                	li	a0,1
    17e8:	00001097          	auipc	ra,0x1
    17ec:	8f4080e7          	jalr	-1804(ra) # 20dc <exit>
    printf("fork failed in countfree()\n");
    17f0:	00002517          	auipc	a0,0x2
    17f4:	8d050513          	addi	a0,a0,-1840 # 30c0 <malloc+0xb92>
    17f8:	00001097          	auipc	ra,0x1
    17fc:	c7e080e7          	jalr	-898(ra) # 2476 <printf>
    exit(1);
    1800:	4505                	li	a0,1
    1802:	00001097          	auipc	ra,0x1
    1806:	8da080e7          	jalr	-1830(ra) # 20dc <exit>
      }
    }

    exit(0);
    180a:	4501                	li	a0,0
    180c:	00001097          	auipc	ra,0x1
    1810:	8d0080e7          	jalr	-1840(ra) # 20dc <exit>
  }

  close(fds[1]);
    1814:	fcc42503          	lw	a0,-52(s0)
    1818:	00001097          	auipc	ra,0x1
    181c:	8ec080e7          	jalr	-1812(ra) # 2104 <close>

  int n = 0;
    1820:	4481                	li	s1,0
  while (1) {
    char c;
    int cc = read(fds[0], &c, 1);
    1822:	4605                	li	a2,1
    1824:	fc740593          	addi	a1,s0,-57
    1828:	fc842503          	lw	a0,-56(s0)
    182c:	00001097          	auipc	ra,0x1
    1830:	8c8080e7          	jalr	-1848(ra) # 20f4 <read>
    if (cc < 0) {
    1834:	00054563          	bltz	a0,183e <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if (cc == 0) break;
    1838:	c105                	beqz	a0,1858 <countfree+0x10a>
    n += 1;
    183a:	2485                	addiw	s1,s1,1
  while (1) {
    183c:	b7dd                	j	1822 <countfree+0xd4>
      printf("read() failed in countfree()\n");
    183e:	00002517          	auipc	a0,0x2
    1842:	8c250513          	addi	a0,a0,-1854 # 3100 <malloc+0xbd2>
    1846:	00001097          	auipc	ra,0x1
    184a:	c30080e7          	jalr	-976(ra) # 2476 <printf>
      exit(1);
    184e:	4505                	li	a0,1
    1850:	00001097          	auipc	ra,0x1
    1854:	88c080e7          	jalr	-1908(ra) # 20dc <exit>
  }

  close(fds[0]);
    1858:	fc842503          	lw	a0,-56(s0)
    185c:	00001097          	auipc	ra,0x1
    1860:	8a8080e7          	jalr	-1880(ra) # 2104 <close>
  wait((int *)0);
    1864:	4501                	li	a0,0
    1866:	00001097          	auipc	ra,0x1
    186a:	87e080e7          	jalr	-1922(ra) # 20e4 <wait>

  return n;
}
    186e:	8526                	mv	a0,s1
    1870:	70e2                	ld	ra,56(sp)
    1872:	7442                	ld	s0,48(sp)
    1874:	74a2                	ld	s1,40(sp)
    1876:	7902                	ld	s2,32(sp)
    1878:	69e2                	ld	s3,24(sp)
    187a:	6121                	addi	sp,sp,64
    187c:	8082                	ret

000000000000187e <manyports>:

int manyports(int free1) {
    187e:	7139                	addi	sp,sp,-64
    1880:	fc06                	sd	ra,56(sp)
    1882:	f822                	sd	s0,48(sp)
    1884:	f426                	sd	s1,40(sp)
    1886:	f04a                	sd	s2,32(sp)
    1888:	ec4e                	sd	s3,24(sp)
    188a:	e852                	sd	s4,16(sp)
    188c:	e456                	sd	s5,8(sp)
    188e:	e05a                	sd	s6,0(sp)
    1890:	0080                	addi	s0,sp,64
    1892:	8aaa                	mv	s5,a0
#define CNT_PORTS 100
#define START_PORT 1001

  int max_port = START_PORT;
    1894:	3e900493          	li	s1,1001
  int ok = 1;

  for (int i = 0; i < CNT_PORTS; ++i) {
    1898:	44d00913          	li	s2,1101
    int br = bind(max_port);
    189c:	03049513          	slli	a0,s1,0x30
    18a0:	9141                	srli	a0,a0,0x30
    18a2:	00001097          	auipc	ra,0x1
    18a6:	8da080e7          	jalr	-1830(ra) # 217c <bind>
    if (br != 0) {
    18aa:	e511                	bnez	a0,18b6 <manyports+0x38>
      printf("FAILED manyports: bind failed for %d : %d\n", max_port, br);
      ok = 0;
      break;
    }
    max_port = START_PORT + i + 1;
    18ac:	2485                	addiw	s1,s1,1
  for (int i = 0; i < CNT_PORTS; ++i) {
    18ae:	ff2497e3          	bne	s1,s2,189c <manyports+0x1e>
  int ok = 1;
    18b2:	4b05                	li	s6,1
    18b4:	a005                	j	18d4 <manyports+0x56>
      printf("FAILED manyports: bind failed for %d : %d\n", max_port, br);
    18b6:	862a                	mv	a2,a0
    18b8:	85a6                	mv	a1,s1
    18ba:	00002517          	auipc	a0,0x2
    18be:	86650513          	addi	a0,a0,-1946 # 3120 <malloc+0xbf2>
    18c2:	00001097          	auipc	ra,0x1
    18c6:	bb4080e7          	jalr	-1100(ra) # 2476 <printf>
  }

  char *buf = "ping";
  for (int i = START_PORT; i < max_port; ++i) {
    18ca:	3e900793          	li	a5,1001
      ok = 0;
    18ce:	4b01                	li	s6,0
  for (int i = START_PORT; i < max_port; ++i) {
    18d0:	0497d763          	bge	a5,s1,191e <manyports+0xa0>
      ok = 0;
    18d4:	3e900913          	li	s2,1001
    if (send(1999, 0x0A000205, i, buf, 5) < 0) {  // 10.0.2.5
    18d8:	00002a17          	auipc	s4,0x2
    18dc:	878a0a13          	addi	s4,s4,-1928 # 3150 <malloc+0xc22>
    18e0:	0a0009b7          	lui	s3,0xa000
    18e4:	20598993          	addi	s3,s3,517 # a000205 <base+0x9ffbff5>
    18e8:	4715                	li	a4,5
    18ea:	86d2                	mv	a3,s4
    18ec:	03091613          	slli	a2,s2,0x30
    18f0:	9241                	srli	a2,a2,0x30
    18f2:	85ce                	mv	a1,s3
    18f4:	7cf00513          	li	a0,1999
    18f8:	00001097          	auipc	ra,0x1
    18fc:	894080e7          	jalr	-1900(ra) # 218c <send>
    1900:	00054663          	bltz	a0,190c <manyports+0x8e>
  for (int i = START_PORT; i < max_port; ++i) {
    1904:	2905                	addiw	s2,s2,1
    1906:	fe9911e3          	bne	s2,s1,18e8 <manyports+0x6a>
    190a:	a811                	j	191e <manyports+0xa0>
      printf("FAILED manyports: send() failed for port %d\n", i);
    190c:	85ca                	mv	a1,s2
    190e:	00002517          	auipc	a0,0x2
    1912:	84a50513          	addi	a0,a0,-1974 # 3158 <malloc+0xc2a>
    1916:	00001097          	auipc	ra,0x1
    191a:	b60080e7          	jalr	-1184(ra) # 2476 <printf>
      break;
    }
  }

  int free2 = countfree();
    191e:	00000097          	auipc	ra,0x0
    1922:	e30080e7          	jalr	-464(ra) # 174e <countfree>
  if (free2 < free1 - CNT_PORTS / 5) {
    1926:	feca879b          	addiw	a5,s5,-20
    192a:	04f55963          	bge	a0,a5,197c <manyports+0xfe>
    printf("FAILED manyports: lost too many free pages %d > %d\n",
    192e:	4651                	li	a2,20
    1930:	40aa85bb          	subw	a1,s5,a0
    1934:	00002517          	auipc	a0,0x2
    1938:	85450513          	addi	a0,a0,-1964 # 3188 <malloc+0xc5a>
    193c:	00001097          	auipc	ra,0x1
    1940:	b3a080e7          	jalr	-1222(ra) # 2476 <printf>
           free1 - free2, CNT_PORTS / 5);
    ok = 0;
    1944:	4b01                	li	s6,0
  } else {
    printf("manyports: OK\n");
  }

  for (int i = START_PORT; i < max_port; ++i) {
    1946:	3e900793          	li	a5,1001
    194a:	0097de63          	bge	a5,s1,1966 <manyports+0xe8>
    194e:	3e900913          	li	s2,1001
    unbind(i);
    1952:	03091513          	slli	a0,s2,0x30
    1956:	9141                	srli	a0,a0,0x30
    1958:	00001097          	auipc	ra,0x1
    195c:	82c080e7          	jalr	-2004(ra) # 2184 <unbind>
  for (int i = START_PORT; i < max_port; ++i) {
    1960:	2905                	addiw	s2,s2,1
    1962:	fe9918e3          	bne	s2,s1,1952 <manyports+0xd4>
  }
  return ok;
}
    1966:	855a                	mv	a0,s6
    1968:	70e2                	ld	ra,56(sp)
    196a:	7442                	ld	s0,48(sp)
    196c:	74a2                	ld	s1,40(sp)
    196e:	7902                	ld	s2,32(sp)
    1970:	69e2                	ld	s3,24(sp)
    1972:	6a42                	ld	s4,16(sp)
    1974:	6aa2                	ld	s5,8(sp)
    1976:	6b02                	ld	s6,0(sp)
    1978:	6121                	addi	sp,sp,64
    197a:	8082                	ret
    printf("manyports: OK\n");
    197c:	00002517          	auipc	a0,0x2
    1980:	84450513          	addi	a0,a0,-1980 # 31c0 <malloc+0xc92>
    1984:	00001097          	auipc	ra,0x1
    1988:	af2080e7          	jalr	-1294(ra) # 2476 <printf>
    198c:	bf6d                	j	1946 <manyports+0xc8>

000000000000198e <main>:

int main(int argc, char *argv[]) {
    198e:	7179                	addi	sp,sp,-48
    1990:	f406                	sd	ra,40(sp)
    1992:	f022                	sd	s0,32(sp)
    1994:	ec26                	sd	s1,24(sp)
    1996:	e84a                	sd	s2,16(sp)
    1998:	e44e                	sd	s3,8(sp)
    199a:	1800                	addi	s0,sp,48
  if (argc != 2) usage();
    199c:	4789                	li	a5,2
    199e:	00f50663          	beq	a0,a5,19aa <main+0x1c>
    19a2:	00000097          	auipc	ra,0x0
    19a6:	cda080e7          	jalr	-806(ra) # 167c <usage>
    19aa:	84ae                	mv	s1,a1

  if (strcmp(argv[1], "txone") == 0) {
    19ac:	00002597          	auipc	a1,0x2
    19b0:	82458593          	addi	a1,a1,-2012 # 31d0 <malloc+0xca2>
    19b4:	6488                	ld	a0,8(s1)
    19b6:	00000097          	auipc	ra,0x0
    19ba:	4d6080e7          	jalr	1238(ra) # 1e8c <strcmp>
    19be:	e911                	bnez	a0,19d2 <main+0x44>
    txone();
    19c0:	ffffe097          	auipc	ra,0xffffe
    19c4:	640080e7          	jalr	1600(ra) # 0 <txone>
    }
  } else {
    usage();
  }

  exit(0);
    19c8:	4501                	li	a0,0
    19ca:	00000097          	auipc	ra,0x0
    19ce:	712080e7          	jalr	1810(ra) # 20dc <exit>
  } else if (strcmp(argv[1], "rx") == 0 || strcmp(argv[1], "rxburst") == 0) {
    19d2:	00002597          	auipc	a1,0x2
    19d6:	80658593          	addi	a1,a1,-2042 # 31d8 <malloc+0xcaa>
    19da:	6488                	ld	a0,8(s1)
    19dc:	00000097          	auipc	ra,0x0
    19e0:	4b0080e7          	jalr	1200(ra) # 1e8c <strcmp>
    19e4:	c919                	beqz	a0,19fa <main+0x6c>
    19e6:	00001597          	auipc	a1,0x1
    19ea:	7fa58593          	addi	a1,a1,2042 # 31e0 <malloc+0xcb2>
    19ee:	6488                	ld	a0,8(s1)
    19f0:	00000097          	auipc	ra,0x0
    19f4:	49c080e7          	jalr	1180(ra) # 1e8c <strcmp>
    19f8:	e519                	bnez	a0,1a06 <main+0x78>
    rx(argv[1]);
    19fa:	6488                	ld	a0,8(s1)
    19fc:	ffffe097          	auipc	ra,0xffffe
    1a00:	688080e7          	jalr	1672(ra) # 84 <rx>
    1a04:	b7d1                	j	19c8 <main+0x3a>
  } else if (strcmp(argv[1], "rx2") == 0) {
    1a06:	00001597          	auipc	a1,0x1
    1a0a:	7e258593          	addi	a1,a1,2018 # 31e8 <malloc+0xcba>
    1a0e:	6488                	ld	a0,8(s1)
    1a10:	00000097          	auipc	ra,0x0
    1a14:	47c080e7          	jalr	1148(ra) # 1e8c <strcmp>
    1a18:	e911                	bnez	a0,1a2c <main+0x9e>
    rx2(FWDPORT1, FWDPORT2);
    1a1a:	7d100593          	li	a1,2001
    1a1e:	7d000513          	li	a0,2000
    1a22:	fffff097          	auipc	ra,0xfffff
    1a26:	8b2080e7          	jalr	-1870(ra) # 2d4 <rx2>
    1a2a:	bf79                	j	19c8 <main+0x3a>
  } else if (strcmp(argv[1], "tx") == 0) {
    1a2c:	00001597          	auipc	a1,0x1
    1a30:	7c458593          	addi	a1,a1,1988 # 31f0 <malloc+0xcc2>
    1a34:	6488                	ld	a0,8(s1)
    1a36:	00000097          	auipc	ra,0x0
    1a3a:	456080e7          	jalr	1110(ra) # 1e8c <strcmp>
    1a3e:	e511                	bnez	a0,1a4a <main+0xbc>
    tx();
    1a40:	fffff097          	auipc	ra,0xfffff
    1a44:	c50080e7          	jalr	-944(ra) # 690 <tx>
    1a48:	b741                	j	19c8 <main+0x3a>
  } else if (strcmp(argv[1], "ping0") == 0) {
    1a4a:	00001597          	auipc	a1,0x1
    1a4e:	efe58593          	addi	a1,a1,-258 # 2948 <malloc+0x41a>
    1a52:	6488                	ld	a0,8(s1)
    1a54:	00000097          	auipc	ra,0x0
    1a58:	438080e7          	jalr	1080(ra) # 1e8c <strcmp>
    1a5c:	e511                	bnez	a0,1a68 <main+0xda>
    ping0();
    1a5e:	fffff097          	auipc	ra,0xfffff
    1a62:	cc8080e7          	jalr	-824(ra) # 726 <ping0>
    1a66:	b78d                	j	19c8 <main+0x3a>
  } else if (strcmp(argv[1], "ping1") == 0) {
    1a68:	00001597          	auipc	a1,0x1
    1a6c:	79058593          	addi	a1,a1,1936 # 31f8 <malloc+0xcca>
    1a70:	6488                	ld	a0,8(s1)
    1a72:	00000097          	auipc	ra,0x0
    1a76:	41a080e7          	jalr	1050(ra) # 1e8c <strcmp>
    1a7a:	e511                	bnez	a0,1a86 <main+0xf8>
    ping1();
    1a7c:	fffff097          	auipc	ra,0xfffff
    1a80:	e30080e7          	jalr	-464(ra) # 8ac <ping1>
    1a84:	b791                	j	19c8 <main+0x3a>
  } else if (strcmp(argv[1], "ping2") == 0) {
    1a86:	00001597          	auipc	a1,0x1
    1a8a:	77a58593          	addi	a1,a1,1914 # 3200 <malloc+0xcd2>
    1a8e:	6488                	ld	a0,8(s1)
    1a90:	00000097          	auipc	ra,0x0
    1a94:	3fc080e7          	jalr	1020(ra) # 1e8c <strcmp>
    1a98:	e511                	bnez	a0,1aa4 <main+0x116>
    ping2();
    1a9a:	fffff097          	auipc	ra,0xfffff
    1a9e:	faa080e7          	jalr	-86(ra) # a44 <ping2>
    1aa2:	b71d                	j	19c8 <main+0x3a>
  } else if (strcmp(argv[1], "ping3") == 0) {
    1aa4:	00001597          	auipc	a1,0x1
    1aa8:	76458593          	addi	a1,a1,1892 # 3208 <malloc+0xcda>
    1aac:	6488                	ld	a0,8(s1)
    1aae:	00000097          	auipc	ra,0x0
    1ab2:	3de080e7          	jalr	990(ra) # 1e8c <strcmp>
    1ab6:	e511                	bnez	a0,1ac2 <main+0x134>
    ping3();
    1ab8:	fffff097          	auipc	ra,0xfffff
    1abc:	1f2080e7          	jalr	498(ra) # caa <ping3>
    1ac0:	b721                	j	19c8 <main+0x3a>
  } else if (strcmp(argv[1], "grade") == 0) {
    1ac2:	00001597          	auipc	a1,0x1
    1ac6:	74e58593          	addi	a1,a1,1870 # 3210 <malloc+0xce2>
    1aca:	6488                	ld	a0,8(s1)
    1acc:	00000097          	auipc	ra,0x0
    1ad0:	3c0080e7          	jalr	960(ra) # 1e8c <strcmp>
    1ad4:	892a                	mv	s2,a0
    1ad6:	14051363          	bnez	a0,1c1c <main+0x28e>
    int free0 = countfree();
    1ada:	00000097          	auipc	ra,0x0
    1ade:	c74080e7          	jalr	-908(ra) # 174e <countfree>
    1ae2:	84aa                	mv	s1,a0
    sleep(0.5);
    1ae4:	4501                	li	a0,0
    1ae6:	00000097          	auipc	ra,0x0
    1aea:	686080e7          	jalr	1670(ra) # 216c <sleep>
    ok = ok && txone();
    1aee:	ffffe097          	auipc	ra,0xffffe
    1af2:	512080e7          	jalr	1298(ra) # 0 <txone>
    1af6:	89aa                	mv	s3,a0
    sleep(0.5);
    1af8:	4501                	li	a0,0
    1afa:	00000097          	auipc	ra,0x0
    1afe:	672080e7          	jalr	1650(ra) # 216c <sleep>
    ok = ok && rx2(FWDPORT1, FWDPORT2);
    1b02:	06099d63          	bnez	s3,1b7c <main+0x1ee>
    sleep(0.5);
    1b06:	4501                	li	a0,0
    1b08:	00000097          	auipc	ra,0x0
    1b0c:	664080e7          	jalr	1636(ra) # 216c <sleep>
    sleep(0.5);
    1b10:	4501                	li	a0,0
    1b12:	00000097          	auipc	ra,0x0
    1b16:	65a080e7          	jalr	1626(ra) # 216c <sleep>
    sleep(0.5);
    1b1a:	4501                	li	a0,0
    1b1c:	00000097          	auipc	ra,0x0
    1b20:	650080e7          	jalr	1616(ra) # 216c <sleep>
    sleep(0.5);
    1b24:	4501                	li	a0,0
    1b26:	00000097          	auipc	ra,0x0
    1b2a:	646080e7          	jalr	1606(ra) # 216c <sleep>
    sleep(0.5);
    1b2e:	4501                	li	a0,0
    1b30:	00000097          	auipc	ra,0x0
    1b34:	63c080e7          	jalr	1596(ra) # 216c <sleep>
    sleep(4);
    1b38:	4511                	li	a0,4
    1b3a:	00000097          	auipc	ra,0x0
    1b3e:	632080e7          	jalr	1586(ra) # 216c <sleep>
    if ((free1 = countfree()) + 16 + 16 + 3 < free0) {
    1b42:	00000097          	auipc	ra,0x0
    1b46:	c0c080e7          	jalr	-1012(ra) # 174e <countfree>
    1b4a:	85aa                	mv	a1,a0
    1b4c:	0235079b          	addiw	a5,a0,35
    1b50:	0a97dd63          	bge	a5,s1,1c0a <main+0x27c>
      printf("lazyport: FAILED -- lost too many free pages %d (out of %d)\n",
    1b54:	8626                	mv	a2,s1
    1b56:	00001517          	auipc	a0,0x1
    1b5a:	6c250513          	addi	a0,a0,1730 # 3218 <malloc+0xcea>
    1b5e:	00001097          	auipc	ra,0x1
    1b62:	918080e7          	jalr	-1768(ra) # 2476 <printf>
    if (ok) {
    1b66:	e60901e3          	beqz	s2,19c8 <main+0x3a>
      printf("Tests OK\n");
    1b6a:	00001517          	auipc	a0,0x1
    1b6e:	6fe50513          	addi	a0,a0,1790 # 3268 <malloc+0xd3a>
    1b72:	00001097          	auipc	ra,0x1
    1b76:	904080e7          	jalr	-1788(ra) # 2476 <printf>
    1b7a:	b5b9                	j	19c8 <main+0x3a>
    ok = ok && rx2(FWDPORT1, FWDPORT2);
    1b7c:	7d100593          	li	a1,2001
    1b80:	7d000513          	li	a0,2000
    1b84:	ffffe097          	auipc	ra,0xffffe
    1b88:	750080e7          	jalr	1872(ra) # 2d4 <rx2>
    1b8c:	89aa                	mv	s3,a0
    sleep(0.5);
    1b8e:	4501                	li	a0,0
    1b90:	00000097          	auipc	ra,0x0
    1b94:	5dc080e7          	jalr	1500(ra) # 216c <sleep>
    ok = ok && ping0();
    1b98:	f6098ce3          	beqz	s3,1b10 <main+0x182>
    1b9c:	fffff097          	auipc	ra,0xfffff
    1ba0:	b8a080e7          	jalr	-1142(ra) # 726 <ping0>
    1ba4:	89aa                	mv	s3,a0
    sleep(0.5);
    1ba6:	4501                	li	a0,0
    1ba8:	00000097          	auipc	ra,0x0
    1bac:	5c4080e7          	jalr	1476(ra) # 216c <sleep>
    ok = ok && ping1();
    1bb0:	f60985e3          	beqz	s3,1b1a <main+0x18c>
    1bb4:	fffff097          	auipc	ra,0xfffff
    1bb8:	cf8080e7          	jalr	-776(ra) # 8ac <ping1>
    1bbc:	89aa                	mv	s3,a0
    sleep(0.5);
    1bbe:	4501                	li	a0,0
    1bc0:	00000097          	auipc	ra,0x0
    1bc4:	5ac080e7          	jalr	1452(ra) # 216c <sleep>
    ok = ok && ping2();
    1bc8:	f4098ee3          	beqz	s3,1b24 <main+0x196>
    1bcc:	fffff097          	auipc	ra,0xfffff
    1bd0:	e78080e7          	jalr	-392(ra) # a44 <ping2>
    1bd4:	89aa                	mv	s3,a0
    sleep(0.5);
    1bd6:	4501                	li	a0,0
    1bd8:	00000097          	auipc	ra,0x0
    1bdc:	594080e7          	jalr	1428(ra) # 216c <sleep>
    ok = ok && ping3();
    1be0:	f40987e3          	beqz	s3,1b2e <main+0x1a0>
    1be4:	fffff097          	auipc	ra,0xfffff
    1be8:	0c6080e7          	jalr	198(ra) # caa <ping3>
    1bec:	892a                	mv	s2,a0
    sleep(0.5);
    1bee:	4501                	li	a0,0
    1bf0:	00000097          	auipc	ra,0x0
    1bf4:	57c080e7          	jalr	1404(ra) # 216c <sleep>
    ok = ok && dns();
    1bf8:	f40900e3          	beqz	s2,1b38 <main+0x1aa>
    1bfc:	00000097          	auipc	ra,0x0
    1c00:	976080e7          	jalr	-1674(ra) # 1572 <dns>
    1c04:	00a03933          	snez	s2,a0
    1c08:	bf05                	j	1b38 <main+0x1aa>
      printf("free: OK\n");
    1c0a:	00001517          	auipc	a0,0x1
    1c0e:	64e50513          	addi	a0,a0,1614 # 3258 <malloc+0xd2a>
    1c12:	00001097          	auipc	ra,0x1
    1c16:	864080e7          	jalr	-1948(ra) # 2476 <printf>
    1c1a:	b7b1                	j	1b66 <main+0x1d8>
  } else if (strcmp(argv[1], "dns") == 0) {
    1c1c:	00001597          	auipc	a1,0x1
    1c20:	65c58593          	addi	a1,a1,1628 # 3278 <malloc+0xd4a>
    1c24:	6488                	ld	a0,8(s1)
    1c26:	00000097          	auipc	ra,0x0
    1c2a:	266080e7          	jalr	614(ra) # 1e8c <strcmp>
    1c2e:	e511                	bnez	a0,1c3a <main+0x2ac>
    dns();
    1c30:	00000097          	auipc	ra,0x0
    1c34:	942080e7          	jalr	-1726(ra) # 1572 <dns>
    1c38:	bb41                	j	19c8 <main+0x3a>
  } else if (strcmp(argv[1], "unbind") == 0) {
    1c3a:	00001597          	auipc	a1,0x1
    1c3e:	64658593          	addi	a1,a1,1606 # 3280 <malloc+0xd52>
    1c42:	6488                	ld	a0,8(s1)
    1c44:	00000097          	auipc	ra,0x0
    1c48:	248080e7          	jalr	584(ra) # 1e8c <strcmp>
    1c4c:	892a                	mv	s2,a0
    1c4e:	e17d                	bnez	a0,1d34 <main+0x3a6>
    int free0 = countfree();
    1c50:	00000097          	auipc	ra,0x0
    1c54:	afe080e7          	jalr	-1282(ra) # 174e <countfree>
    1c58:	84aa                	mv	s1,a0
    sleep(0.5);
    1c5a:	4501                	li	a0,0
    1c5c:	00000097          	auipc	ra,0x0
    1c60:	510080e7          	jalr	1296(ra) # 216c <sleep>
    ok = ok && txone();
    1c64:	ffffe097          	auipc	ra,0xffffe
    1c68:	39c080e7          	jalr	924(ra) # 0 <txone>
    1c6c:	89aa                	mv	s3,a0
    sleep(0.5);
    1c6e:	4501                	li	a0,0
    1c70:	00000097          	auipc	ra,0x0
    1c74:	4fc080e7          	jalr	1276(ra) # 216c <sleep>
    ok = ok && rx2(FWDPORT1, FWDPORT2);
    1c78:	04099e63          	bnez	s3,1cd4 <main+0x346>
    sleep(0.5);
    1c7c:	4501                	li	a0,0
    1c7e:	00000097          	auipc	ra,0x0
    1c82:	4ee080e7          	jalr	1262(ra) # 216c <sleep>
    sleep(0.5);
    1c86:	4501                	li	a0,0
    1c88:	00000097          	auipc	ra,0x0
    1c8c:	4e4080e7          	jalr	1252(ra) # 216c <sleep>
    sleep(1);
    1c90:	4505                	li	a0,1
    1c92:	00000097          	auipc	ra,0x0
    1c96:	4da080e7          	jalr	1242(ra) # 216c <sleep>
    if ((free1 = countfree()) + 16 + 3 + 3 < free0) {
    1c9a:	00000097          	auipc	ra,0x0
    1c9e:	ab4080e7          	jalr	-1356(ra) # 174e <countfree>
    1ca2:	85aa                	mv	a1,a0
    1ca4:	0165079b          	addiw	a5,a0,22
    1ca8:	0697dd63          	bge	a5,s1,1d22 <main+0x394>
      printf("free: FAILED -- lost too many free pages %d (out of %d)\n", free1,
    1cac:	8626                	mv	a2,s1
    1cae:	00001517          	auipc	a0,0x1
    1cb2:	5da50513          	addi	a0,a0,1498 # 3288 <malloc+0xd5a>
    1cb6:	00000097          	auipc	ra,0x0
    1cba:	7c0080e7          	jalr	1984(ra) # 2476 <printf>
    if (ok) {
    1cbe:	d00905e3          	beqz	s2,19c8 <main+0x3a>
      printf("Tests OK\n");
    1cc2:	00001517          	auipc	a0,0x1
    1cc6:	5a650513          	addi	a0,a0,1446 # 3268 <malloc+0xd3a>
    1cca:	00000097          	auipc	ra,0x0
    1cce:	7ac080e7          	jalr	1964(ra) # 2476 <printf>
    1cd2:	b9dd                	j	19c8 <main+0x3a>
    ok = ok && rx2(FWDPORT1, FWDPORT2);
    1cd4:	7d100593          	li	a1,2001
    1cd8:	7d000513          	li	a0,2000
    1cdc:	ffffe097          	auipc	ra,0xffffe
    1ce0:	5f8080e7          	jalr	1528(ra) # 2d4 <rx2>
    1ce4:	89aa                	mv	s3,a0
    sleep(0.5);
    1ce6:	4501                	li	a0,0
    1ce8:	00000097          	auipc	ra,0x0
    1cec:	484080e7          	jalr	1156(ra) # 216c <sleep>
    ok = ok && txone();
    1cf0:	f8098be3          	beqz	s3,1c86 <main+0x2f8>
    1cf4:	ffffe097          	auipc	ra,0xffffe
    1cf8:	30c080e7          	jalr	780(ra) # 0 <txone>
    1cfc:	892a                	mv	s2,a0
    sleep(0.5);
    1cfe:	4501                	li	a0,0
    1d00:	00000097          	auipc	ra,0x0
    1d04:	46c080e7          	jalr	1132(ra) # 216c <sleep>
    ok = ok && rx2(FWDPORT1, FWDPORT2);
    1d08:	f80904e3          	beqz	s2,1c90 <main+0x302>
    1d0c:	7d100593          	li	a1,2001
    1d10:	7d000513          	li	a0,2000
    1d14:	ffffe097          	auipc	ra,0xffffe
    1d18:	5c0080e7          	jalr	1472(ra) # 2d4 <rx2>
    1d1c:	00a03933          	snez	s2,a0
    1d20:	bf85                	j	1c90 <main+0x302>
      printf("free: OK\n");
    1d22:	00001517          	auipc	a0,0x1
    1d26:	53650513          	addi	a0,a0,1334 # 3258 <malloc+0xd2a>
    1d2a:	00000097          	auipc	ra,0x0
    1d2e:	74c080e7          	jalr	1868(ra) # 2476 <printf>
    1d32:	b771                	j	1cbe <main+0x330>
  } else if (strcmp(argv[1], "allports") == 0) {
    1d34:	00001597          	auipc	a1,0x1
    1d38:	59458593          	addi	a1,a1,1428 # 32c8 <malloc+0xd9a>
    1d3c:	6488                	ld	a0,8(s1)
    1d3e:	00000097          	auipc	ra,0x0
    1d42:	14e080e7          	jalr	334(ra) # 1e8c <strcmp>
    1d46:	10051463          	bnez	a0,1e4e <main+0x4c0>
    int free0 = countfree();
    1d4a:	00000097          	auipc	ra,0x0
    1d4e:	a04080e7          	jalr	-1532(ra) # 174e <countfree>
    1d52:	892a                	mv	s2,a0
    if (free0 < EXPECTED_FREE_PAGES) {
    1d54:	679d                	lui	a5,0x7
    1d56:	7ff78793          	addi	a5,a5,2047 # 77ff <base+0x35ef>
    1d5a:	08a7cd63          	blt	a5,a0,1df4 <main+0x466>
      printf(
    1d5e:	6621                	lui	a2,0x8
    1d60:	80060613          	addi	a2,a2,-2048 # 7800 <base+0x35f0>
    1d64:	85aa                	mv	a1,a0
    1d66:	00001517          	auipc	a0,0x1
    1d6a:	57250513          	addi	a0,a0,1394 # 32d8 <malloc+0xdaa>
    1d6e:	00000097          	auipc	ra,0x0
    1d72:	708080e7          	jalr	1800(ra) # 2476 <printf>
    sleep(0.5);
    1d76:	4501                	li	a0,0
    1d78:	00000097          	auipc	ra,0x0
    1d7c:	3f4080e7          	jalr	1012(ra) # 216c <sleep>
    ok = ok && txone();
    1d80:	ffffe097          	auipc	ra,0xffffe
    1d84:	280080e7          	jalr	640(ra) # 0 <txone>
    1d88:	84aa                	mv	s1,a0
    sleep(0.5);
    1d8a:	4501                	li	a0,0
    1d8c:	00000097          	auipc	ra,0x0
    1d90:	3e0080e7          	jalr	992(ra) # 216c <sleep>
    ok = ok && rx2(FWDPORT3, FWDPORT1);
    1d94:	e8ad                	bnez	s1,1e06 <main+0x478>
    sleep(0.5);
    1d96:	4501                	li	a0,0
    1d98:	00000097          	auipc	ra,0x0
    1d9c:	3d4080e7          	jalr	980(ra) # 216c <sleep>
    sleep(0.5);
    1da0:	4501                	li	a0,0
    1da2:	00000097          	auipc	ra,0x0
    1da6:	3ca080e7          	jalr	970(ra) # 216c <sleep>
    if ((free1 = countfree()) + 16 + 3 + 3 < free0) {
    1daa:	00000097          	auipc	ra,0x0
    1dae:	9a4080e7          	jalr	-1628(ra) # 174e <countfree>
    1db2:	89aa                	mv	s3,a0
    1db4:	0165079b          	addiw	a5,a0,22
    1db8:	0927d263          	bge	a5,s2,1e3c <main+0x4ae>
      printf("free: FAILED -- lost too many free pages %d (out of %d)\n", free1,
    1dbc:	864a                	mv	a2,s2
    1dbe:	85aa                	mv	a1,a0
    1dc0:	00001517          	auipc	a0,0x1
    1dc4:	4c850513          	addi	a0,a0,1224 # 3288 <malloc+0xd5a>
    1dc8:	00000097          	auipc	ra,0x0
    1dcc:	6ae080e7          	jalr	1710(ra) # 2476 <printf>
    ok = ok && manyports(free1);
    1dd0:	be048ce3          	beqz	s1,19c8 <main+0x3a>
    1dd4:	854e                	mv	a0,s3
    1dd6:	00000097          	auipc	ra,0x0
    1dda:	aa8080e7          	jalr	-1368(ra) # 187e <manyports>
    1dde:	be0505e3          	beqz	a0,19c8 <main+0x3a>
      printf("Tests OK\n");
    1de2:	00001517          	auipc	a0,0x1
    1de6:	48650513          	addi	a0,a0,1158 # 3268 <malloc+0xd3a>
    1dea:	00000097          	auipc	ra,0x0
    1dee:	68c080e7          	jalr	1676(ra) # 2476 <printf>
    1df2:	bed9                	j	19c8 <main+0x3a>
      printf("lazy alloc ports: OK\n");
    1df4:	00001517          	auipc	a0,0x1
    1df8:	52c50513          	addi	a0,a0,1324 # 3320 <malloc+0xdf2>
    1dfc:	00000097          	auipc	ra,0x0
    1e00:	67a080e7          	jalr	1658(ra) # 2476 <printf>
    1e04:	bf8d                	j	1d76 <main+0x3e8>
    ok = ok && rx2(FWDPORT3, FWDPORT1);
    1e06:	7d000593          	li	a1,2000
    1e0a:	6541                	lui	a0,0x10
    1e0c:	157d                	addi	a0,a0,-1 # ffff <base+0xbdef>
    1e0e:	ffffe097          	auipc	ra,0xffffe
    1e12:	4c6080e7          	jalr	1222(ra) # 2d4 <rx2>
    1e16:	84aa                	mv	s1,a0
    sleep(0.5);
    1e18:	4501                	li	a0,0
    1e1a:	00000097          	auipc	ra,0x0
    1e1e:	352080e7          	jalr	850(ra) # 216c <sleep>
    ok = ok && rx2(FWDPORT4, FWDPORT2);
    1e22:	dcbd                	beqz	s1,1da0 <main+0x412>
    1e24:	7d100593          	li	a1,2001
    1e28:	6521                	lui	a0,0x8
    1e2a:	9ff50513          	addi	a0,a0,-1537 # 79ff <base+0x37ef>
    1e2e:	ffffe097          	auipc	ra,0xffffe
    1e32:	4a6080e7          	jalr	1190(ra) # 2d4 <rx2>
    1e36:	00a034b3          	snez	s1,a0
    1e3a:	b79d                	j	1da0 <main+0x412>
      printf("free: OK\n");
    1e3c:	00001517          	auipc	a0,0x1
    1e40:	41c50513          	addi	a0,a0,1052 # 3258 <malloc+0xd2a>
    1e44:	00000097          	auipc	ra,0x0
    1e48:	632080e7          	jalr	1586(ra) # 2476 <printf>
    1e4c:	b751                	j	1dd0 <main+0x442>
    usage();
    1e4e:	00000097          	auipc	ra,0x0
    1e52:	82e080e7          	jalr	-2002(ra) # 167c <usage>

0000000000001e56 <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
    1e56:	1141                	addi	sp,sp,-16
    1e58:	e406                	sd	ra,8(sp)
    1e5a:	e022                	sd	s0,0(sp)
    1e5c:	0800                	addi	s0,sp,16
  extern int main();
  main();
    1e5e:	00000097          	auipc	ra,0x0
    1e62:	b30080e7          	jalr	-1232(ra) # 198e <main>
  exit(0);
    1e66:	4501                	li	a0,0
    1e68:	00000097          	auipc	ra,0x0
    1e6c:	274080e7          	jalr	628(ra) # 20dc <exit>

0000000000001e70 <strcpy>:
}

char *strcpy(char *s, const char *t) {
    1e70:	1141                	addi	sp,sp,-16
    1e72:	e422                	sd	s0,8(sp)
    1e74:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0);
    1e76:	87aa                	mv	a5,a0
    1e78:	0585                	addi	a1,a1,1
    1e7a:	0785                	addi	a5,a5,1
    1e7c:	fff5c703          	lbu	a4,-1(a1)
    1e80:	fee78fa3          	sb	a4,-1(a5)
    1e84:	fb75                	bnez	a4,1e78 <strcpy+0x8>
  return os;
}
    1e86:	6422                	ld	s0,8(sp)
    1e88:	0141                	addi	sp,sp,16
    1e8a:	8082                	ret

0000000000001e8c <strcmp>:

int strcmp(const char *p, const char *q) {
    1e8c:	1141                	addi	sp,sp,-16
    1e8e:	e422                	sd	s0,8(sp)
    1e90:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
    1e92:	00054783          	lbu	a5,0(a0)
    1e96:	cb91                	beqz	a5,1eaa <strcmp+0x1e>
    1e98:	0005c703          	lbu	a4,0(a1)
    1e9c:	00f71763          	bne	a4,a5,1eaa <strcmp+0x1e>
    1ea0:	0505                	addi	a0,a0,1
    1ea2:	0585                	addi	a1,a1,1
    1ea4:	00054783          	lbu	a5,0(a0)
    1ea8:	fbe5                	bnez	a5,1e98 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    1eaa:	0005c503          	lbu	a0,0(a1)
}
    1eae:	40a7853b          	subw	a0,a5,a0
    1eb2:	6422                	ld	s0,8(sp)
    1eb4:	0141                	addi	sp,sp,16
    1eb6:	8082                	ret

0000000000001eb8 <strlen>:

uint strlen(const char *s) {
    1eb8:	1141                	addi	sp,sp,-16
    1eba:	e422                	sd	s0,8(sp)
    1ebc:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
    1ebe:	00054783          	lbu	a5,0(a0)
    1ec2:	cf91                	beqz	a5,1ede <strlen+0x26>
    1ec4:	0505                	addi	a0,a0,1
    1ec6:	87aa                	mv	a5,a0
    1ec8:	4685                	li	a3,1
    1eca:	9e89                	subw	a3,a3,a0
    1ecc:	00f6853b          	addw	a0,a3,a5
    1ed0:	0785                	addi	a5,a5,1
    1ed2:	fff7c703          	lbu	a4,-1(a5)
    1ed6:	fb7d                	bnez	a4,1ecc <strlen+0x14>
  return n;
}
    1ed8:	6422                	ld	s0,8(sp)
    1eda:	0141                	addi	sp,sp,16
    1edc:	8082                	ret
  for (n = 0; s[n]; n++);
    1ede:	4501                	li	a0,0
    1ee0:	bfe5                	j	1ed8 <strlen+0x20>

0000000000001ee2 <memset>:

void *memset(void *dst, int c, uint n) {
    1ee2:	1141                	addi	sp,sp,-16
    1ee4:	e422                	sd	s0,8(sp)
    1ee6:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    1ee8:	ca19                	beqz	a2,1efe <memset+0x1c>
    1eea:	87aa                	mv	a5,a0
    1eec:	1602                	slli	a2,a2,0x20
    1eee:	9201                	srli	a2,a2,0x20
    1ef0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    1ef4:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    1ef8:	0785                	addi	a5,a5,1
    1efa:	fee79de3          	bne	a5,a4,1ef4 <memset+0x12>
  }
  return dst;
}
    1efe:	6422                	ld	s0,8(sp)
    1f00:	0141                	addi	sp,sp,16
    1f02:	8082                	ret

0000000000001f04 <strchr>:

char *strchr(const char *s, char c) {
    1f04:	1141                	addi	sp,sp,-16
    1f06:	e422                	sd	s0,8(sp)
    1f08:	0800                	addi	s0,sp,16
  for (; *s; s++)
    1f0a:	00054783          	lbu	a5,0(a0)
    1f0e:	cb99                	beqz	a5,1f24 <strchr+0x20>
    if (*s == c) return (char *)s;
    1f10:	00f58763          	beq	a1,a5,1f1e <strchr+0x1a>
  for (; *s; s++)
    1f14:	0505                	addi	a0,a0,1
    1f16:	00054783          	lbu	a5,0(a0)
    1f1a:	fbfd                	bnez	a5,1f10 <strchr+0xc>
  return 0;
    1f1c:	4501                	li	a0,0
}
    1f1e:	6422                	ld	s0,8(sp)
    1f20:	0141                	addi	sp,sp,16
    1f22:	8082                	ret
  return 0;
    1f24:	4501                	li	a0,0
    1f26:	bfe5                	j	1f1e <strchr+0x1a>

0000000000001f28 <gets>:

char *gets(char *buf, int max) {
    1f28:	711d                	addi	sp,sp,-96
    1f2a:	ec86                	sd	ra,88(sp)
    1f2c:	e8a2                	sd	s0,80(sp)
    1f2e:	e4a6                	sd	s1,72(sp)
    1f30:	e0ca                	sd	s2,64(sp)
    1f32:	fc4e                	sd	s3,56(sp)
    1f34:	f852                	sd	s4,48(sp)
    1f36:	f456                	sd	s5,40(sp)
    1f38:	f05a                	sd	s6,32(sp)
    1f3a:	ec5e                	sd	s7,24(sp)
    1f3c:	1080                	addi	s0,sp,96
    1f3e:	8baa                	mv	s7,a0
    1f40:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
    1f42:	892a                	mv	s2,a0
    1f44:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
    1f46:	4aa9                	li	s5,10
    1f48:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
    1f4a:	89a6                	mv	s3,s1
    1f4c:	2485                	addiw	s1,s1,1
    1f4e:	0344d863          	bge	s1,s4,1f7e <gets+0x56>
    cc = read(0, &c, 1);
    1f52:	4605                	li	a2,1
    1f54:	faf40593          	addi	a1,s0,-81
    1f58:	4501                	li	a0,0
    1f5a:	00000097          	auipc	ra,0x0
    1f5e:	19a080e7          	jalr	410(ra) # 20f4 <read>
    if (cc < 1) break;
    1f62:	00a05e63          	blez	a0,1f7e <gets+0x56>
    buf[i++] = c;
    1f66:	faf44783          	lbu	a5,-81(s0)
    1f6a:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
    1f6e:	01578763          	beq	a5,s5,1f7c <gets+0x54>
    1f72:	0905                	addi	s2,s2,1
    1f74:	fd679be3          	bne	a5,s6,1f4a <gets+0x22>
  for (i = 0; i + 1 < max;) {
    1f78:	89a6                	mv	s3,s1
    1f7a:	a011                	j	1f7e <gets+0x56>
    1f7c:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
    1f7e:	99de                	add	s3,s3,s7
    1f80:	00098023          	sb	zero,0(s3)
  return buf;
}
    1f84:	855e                	mv	a0,s7
    1f86:	60e6                	ld	ra,88(sp)
    1f88:	6446                	ld	s0,80(sp)
    1f8a:	64a6                	ld	s1,72(sp)
    1f8c:	6906                	ld	s2,64(sp)
    1f8e:	79e2                	ld	s3,56(sp)
    1f90:	7a42                	ld	s4,48(sp)
    1f92:	7aa2                	ld	s5,40(sp)
    1f94:	7b02                	ld	s6,32(sp)
    1f96:	6be2                	ld	s7,24(sp)
    1f98:	6125                	addi	sp,sp,96
    1f9a:	8082                	ret

0000000000001f9c <stat>:

int stat(const char *n, struct stat *st) {
    1f9c:	1101                	addi	sp,sp,-32
    1f9e:	ec06                	sd	ra,24(sp)
    1fa0:	e822                	sd	s0,16(sp)
    1fa2:	e426                	sd	s1,8(sp)
    1fa4:	e04a                	sd	s2,0(sp)
    1fa6:	1000                	addi	s0,sp,32
    1fa8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1faa:	4581                	li	a1,0
    1fac:	00000097          	auipc	ra,0x0
    1fb0:	170080e7          	jalr	368(ra) # 211c <open>
  if (fd < 0) return -1;
    1fb4:	02054563          	bltz	a0,1fde <stat+0x42>
    1fb8:	84aa                	mv	s1,a0
  r = fstat(fd, st);
    1fba:	85ca                	mv	a1,s2
    1fbc:	00000097          	auipc	ra,0x0
    1fc0:	178080e7          	jalr	376(ra) # 2134 <fstat>
    1fc4:	892a                	mv	s2,a0
  close(fd);
    1fc6:	8526                	mv	a0,s1
    1fc8:	00000097          	auipc	ra,0x0
    1fcc:	13c080e7          	jalr	316(ra) # 2104 <close>
  return r;
}
    1fd0:	854a                	mv	a0,s2
    1fd2:	60e2                	ld	ra,24(sp)
    1fd4:	6442                	ld	s0,16(sp)
    1fd6:	64a2                	ld	s1,8(sp)
    1fd8:	6902                	ld	s2,0(sp)
    1fda:	6105                	addi	sp,sp,32
    1fdc:	8082                	ret
  if (fd < 0) return -1;
    1fde:	597d                	li	s2,-1
    1fe0:	bfc5                	j	1fd0 <stat+0x34>

0000000000001fe2 <atoi>:

int atoi(const char *s) {
    1fe2:	1141                	addi	sp,sp,-16
    1fe4:	e422                	sd	s0,8(sp)
    1fe6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
    1fe8:	00054683          	lbu	a3,0(a0)
    1fec:	fd06879b          	addiw	a5,a3,-48
    1ff0:	0ff7f793          	zext.b	a5,a5
    1ff4:	4625                	li	a2,9
    1ff6:	02f66863          	bltu	a2,a5,2026 <atoi+0x44>
    1ffa:	872a                	mv	a4,a0
  n = 0;
    1ffc:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
    1ffe:	0705                	addi	a4,a4,1
    2000:	0025179b          	slliw	a5,a0,0x2
    2004:	9fa9                	addw	a5,a5,a0
    2006:	0017979b          	slliw	a5,a5,0x1
    200a:	9fb5                	addw	a5,a5,a3
    200c:	fd07851b          	addiw	a0,a5,-48
    2010:	00074683          	lbu	a3,0(a4)
    2014:	fd06879b          	addiw	a5,a3,-48
    2018:	0ff7f793          	zext.b	a5,a5
    201c:	fef671e3          	bgeu	a2,a5,1ffe <atoi+0x1c>
  return n;
}
    2020:	6422                	ld	s0,8(sp)
    2022:	0141                	addi	sp,sp,16
    2024:	8082                	ret
  n = 0;
    2026:	4501                	li	a0,0
    2028:	bfe5                	j	2020 <atoi+0x3e>

000000000000202a <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
    202a:	1141                	addi	sp,sp,-16
    202c:	e422                	sd	s0,8(sp)
    202e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    2030:	02b57463          	bgeu	a0,a1,2058 <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
    2034:	00c05f63          	blez	a2,2052 <memmove+0x28>
    2038:	1602                	slli	a2,a2,0x20
    203a:	9201                	srli	a2,a2,0x20
    203c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    2040:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
    2042:	0585                	addi	a1,a1,1
    2044:	0705                	addi	a4,a4,1
    2046:	fff5c683          	lbu	a3,-1(a1)
    204a:	fed70fa3          	sb	a3,-1(a4)
    204e:	fee79ae3          	bne	a5,a4,2042 <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
    2052:	6422                	ld	s0,8(sp)
    2054:	0141                	addi	sp,sp,16
    2056:	8082                	ret
    dst += n;
    2058:	00c50733          	add	a4,a0,a2
    src += n;
    205c:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
    205e:	fec05ae3          	blez	a2,2052 <memmove+0x28>
    2062:	fff6079b          	addiw	a5,a2,-1
    2066:	1782                	slli	a5,a5,0x20
    2068:	9381                	srli	a5,a5,0x20
    206a:	fff7c793          	not	a5,a5
    206e:	97ba                	add	a5,a5,a4
    2070:	15fd                	addi	a1,a1,-1
    2072:	177d                	addi	a4,a4,-1
    2074:	0005c683          	lbu	a3,0(a1)
    2078:	00d70023          	sb	a3,0(a4)
    207c:	fee79ae3          	bne	a5,a4,2070 <memmove+0x46>
    2080:	bfc9                	j	2052 <memmove+0x28>

0000000000002082 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
    2082:	1141                	addi	sp,sp,-16
    2084:	e422                	sd	s0,8(sp)
    2086:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    2088:	ca05                	beqz	a2,20b8 <memcmp+0x36>
    208a:	fff6069b          	addiw	a3,a2,-1
    208e:	1682                	slli	a3,a3,0x20
    2090:	9281                	srli	a3,a3,0x20
    2092:	0685                	addi	a3,a3,1
    2094:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    2096:	00054783          	lbu	a5,0(a0)
    209a:	0005c703          	lbu	a4,0(a1)
    209e:	00e79863          	bne	a5,a4,20ae <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    20a2:	0505                	addi	a0,a0,1
    p2++;
    20a4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    20a6:	fed518e3          	bne	a0,a3,2096 <memcmp+0x14>
  }
  return 0;
    20aa:	4501                	li	a0,0
    20ac:	a019                	j	20b2 <memcmp+0x30>
      return *p1 - *p2;
    20ae:	40e7853b          	subw	a0,a5,a4
}
    20b2:	6422                	ld	s0,8(sp)
    20b4:	0141                	addi	sp,sp,16
    20b6:	8082                	ret
  return 0;
    20b8:	4501                	li	a0,0
    20ba:	bfe5                	j	20b2 <memcmp+0x30>

00000000000020bc <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
    20bc:	1141                	addi	sp,sp,-16
    20be:	e406                	sd	ra,8(sp)
    20c0:	e022                	sd	s0,0(sp)
    20c2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    20c4:	00000097          	auipc	ra,0x0
    20c8:	f66080e7          	jalr	-154(ra) # 202a <memmove>
}
    20cc:	60a2                	ld	ra,8(sp)
    20ce:	6402                	ld	s0,0(sp)
    20d0:	0141                	addi	sp,sp,16
    20d2:	8082                	ret

00000000000020d4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    20d4:	4885                	li	a7,1
 ecall
    20d6:	00000073          	ecall
 ret
    20da:	8082                	ret

00000000000020dc <exit>:
.global exit
exit:
 li a7, SYS_exit
    20dc:	4889                	li	a7,2
 ecall
    20de:	00000073          	ecall
 ret
    20e2:	8082                	ret

00000000000020e4 <wait>:
.global wait
wait:
 li a7, SYS_wait
    20e4:	488d                	li	a7,3
 ecall
    20e6:	00000073          	ecall
 ret
    20ea:	8082                	ret

00000000000020ec <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    20ec:	4891                	li	a7,4
 ecall
    20ee:	00000073          	ecall
 ret
    20f2:	8082                	ret

00000000000020f4 <read>:
.global read
read:
 li a7, SYS_read
    20f4:	4895                	li	a7,5
 ecall
    20f6:	00000073          	ecall
 ret
    20fa:	8082                	ret

00000000000020fc <write>:
.global write
write:
 li a7, SYS_write
    20fc:	48c1                	li	a7,16
 ecall
    20fe:	00000073          	ecall
 ret
    2102:	8082                	ret

0000000000002104 <close>:
.global close
close:
 li a7, SYS_close
    2104:	48d5                	li	a7,21
 ecall
    2106:	00000073          	ecall
 ret
    210a:	8082                	ret

000000000000210c <kill>:
.global kill
kill:
 li a7, SYS_kill
    210c:	4899                	li	a7,6
 ecall
    210e:	00000073          	ecall
 ret
    2112:	8082                	ret

0000000000002114 <exec>:
.global exec
exec:
 li a7, SYS_exec
    2114:	489d                	li	a7,7
 ecall
    2116:	00000073          	ecall
 ret
    211a:	8082                	ret

000000000000211c <open>:
.global open
open:
 li a7, SYS_open
    211c:	48bd                	li	a7,15
 ecall
    211e:	00000073          	ecall
 ret
    2122:	8082                	ret

0000000000002124 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    2124:	48c5                	li	a7,17
 ecall
    2126:	00000073          	ecall
 ret
    212a:	8082                	ret

000000000000212c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    212c:	48c9                	li	a7,18
 ecall
    212e:	00000073          	ecall
 ret
    2132:	8082                	ret

0000000000002134 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    2134:	48a1                	li	a7,8
 ecall
    2136:	00000073          	ecall
 ret
    213a:	8082                	ret

000000000000213c <link>:
.global link
link:
 li a7, SYS_link
    213c:	48cd                	li	a7,19
 ecall
    213e:	00000073          	ecall
 ret
    2142:	8082                	ret

0000000000002144 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    2144:	48d1                	li	a7,20
 ecall
    2146:	00000073          	ecall
 ret
    214a:	8082                	ret

000000000000214c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    214c:	48a5                	li	a7,9
 ecall
    214e:	00000073          	ecall
 ret
    2152:	8082                	ret

0000000000002154 <dup>:
.global dup
dup:
 li a7, SYS_dup
    2154:	48a9                	li	a7,10
 ecall
    2156:	00000073          	ecall
 ret
    215a:	8082                	ret

000000000000215c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    215c:	48ad                	li	a7,11
 ecall
    215e:	00000073          	ecall
 ret
    2162:	8082                	ret

0000000000002164 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    2164:	48b1                	li	a7,12
 ecall
    2166:	00000073          	ecall
 ret
    216a:	8082                	ret

000000000000216c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    216c:	48b5                	li	a7,13
 ecall
    216e:	00000073          	ecall
 ret
    2172:	8082                	ret

0000000000002174 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    2174:	48b9                	li	a7,14
 ecall
    2176:	00000073          	ecall
 ret
    217a:	8082                	ret

000000000000217c <bind>:
.global bind
bind:
 li a7, SYS_bind
    217c:	48d9                	li	a7,22
 ecall
    217e:	00000073          	ecall
 ret
    2182:	8082                	ret

0000000000002184 <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
    2184:	48dd                	li	a7,23
 ecall
    2186:	00000073          	ecall
 ret
    218a:	8082                	ret

000000000000218c <send>:
.global send
send:
 li a7, SYS_send
    218c:	48e1                	li	a7,24
 ecall
    218e:	00000073          	ecall
 ret
    2192:	8082                	ret

0000000000002194 <recv>:
.global recv
recv:
 li a7, SYS_recv
    2194:	48e5                	li	a7,25
 ecall
    2196:	00000073          	ecall
 ret
    219a:	8082                	ret

000000000000219c <putc>:
#include "kernel/types.h"
#include "user/user.h"

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
    219c:	1101                	addi	sp,sp,-32
    219e:	ec06                	sd	ra,24(sp)
    21a0:	e822                	sd	s0,16(sp)
    21a2:	1000                	addi	s0,sp,32
    21a4:	feb407a3          	sb	a1,-17(s0)
    21a8:	4605                	li	a2,1
    21aa:	fef40593          	addi	a1,s0,-17
    21ae:	00000097          	auipc	ra,0x0
    21b2:	f4e080e7          	jalr	-178(ra) # 20fc <write>
    21b6:	60e2                	ld	ra,24(sp)
    21b8:	6442                	ld	s0,16(sp)
    21ba:	6105                	addi	sp,sp,32
    21bc:	8082                	ret

00000000000021be <printint>:

static void printint(int fd, int xx, int base, int sgn) {
    21be:	7139                	addi	sp,sp,-64
    21c0:	fc06                	sd	ra,56(sp)
    21c2:	f822                	sd	s0,48(sp)
    21c4:	f426                	sd	s1,40(sp)
    21c6:	f04a                	sd	s2,32(sp)
    21c8:	ec4e                	sd	s3,24(sp)
    21ca:	0080                	addi	s0,sp,64
    21cc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
    21ce:	c299                	beqz	a3,21d4 <printint+0x16>
    21d0:	0805c963          	bltz	a1,2262 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    21d4:	2581                	sext.w	a1,a1
  neg = 0;
    21d6:	4881                	li	a7,0
    21d8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    21dc:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    21de:	2601                	sext.w	a2,a2
    21e0:	00001517          	auipc	a0,0x1
    21e4:	1b850513          	addi	a0,a0,440 # 3398 <digits>
    21e8:	883a                	mv	a6,a4
    21ea:	2705                	addiw	a4,a4,1
    21ec:	02c5f7bb          	remuw	a5,a1,a2
    21f0:	1782                	slli	a5,a5,0x20
    21f2:	9381                	srli	a5,a5,0x20
    21f4:	97aa                	add	a5,a5,a0
    21f6:	0007c783          	lbu	a5,0(a5)
    21fa:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    21fe:	0005879b          	sext.w	a5,a1
    2202:	02c5d5bb          	divuw	a1,a1,a2
    2206:	0685                	addi	a3,a3,1
    2208:	fec7f0e3          	bgeu	a5,a2,21e8 <printint+0x2a>
  if (neg) buf[i++] = '-';
    220c:	00088c63          	beqz	a7,2224 <printint+0x66>
    2210:	fd070793          	addi	a5,a4,-48
    2214:	00878733          	add	a4,a5,s0
    2218:	02d00793          	li	a5,45
    221c:	fef70823          	sb	a5,-16(a4)
    2220:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
    2224:	02e05863          	blez	a4,2254 <printint+0x96>
    2228:	fc040793          	addi	a5,s0,-64
    222c:	00e78933          	add	s2,a5,a4
    2230:	fff78993          	addi	s3,a5,-1
    2234:	99ba                	add	s3,s3,a4
    2236:	377d                	addiw	a4,a4,-1
    2238:	1702                	slli	a4,a4,0x20
    223a:	9301                	srli	a4,a4,0x20
    223c:	40e989b3          	sub	s3,s3,a4
    2240:	fff94583          	lbu	a1,-1(s2)
    2244:	8526                	mv	a0,s1
    2246:	00000097          	auipc	ra,0x0
    224a:	f56080e7          	jalr	-170(ra) # 219c <putc>
    224e:	197d                	addi	s2,s2,-1
    2250:	ff3918e3          	bne	s2,s3,2240 <printint+0x82>
}
    2254:	70e2                	ld	ra,56(sp)
    2256:	7442                	ld	s0,48(sp)
    2258:	74a2                	ld	s1,40(sp)
    225a:	7902                	ld	s2,32(sp)
    225c:	69e2                	ld	s3,24(sp)
    225e:	6121                	addi	sp,sp,64
    2260:	8082                	ret
    x = -xx;
    2262:	40b005bb          	negw	a1,a1
    neg = 1;
    2266:	4885                	li	a7,1
    x = -xx;
    2268:	bf85                	j	21d8 <printint+0x1a>

000000000000226a <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
    226a:	7119                	addi	sp,sp,-128
    226c:	fc86                	sd	ra,120(sp)
    226e:	f8a2                	sd	s0,112(sp)
    2270:	f4a6                	sd	s1,104(sp)
    2272:	f0ca                	sd	s2,96(sp)
    2274:	ecce                	sd	s3,88(sp)
    2276:	e8d2                	sd	s4,80(sp)
    2278:	e4d6                	sd	s5,72(sp)
    227a:	e0da                	sd	s6,64(sp)
    227c:	fc5e                	sd	s7,56(sp)
    227e:	f862                	sd	s8,48(sp)
    2280:	f466                	sd	s9,40(sp)
    2282:	f06a                	sd	s10,32(sp)
    2284:	ec6e                	sd	s11,24(sp)
    2286:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
    2288:	0005c903          	lbu	s2,0(a1)
    228c:	18090f63          	beqz	s2,242a <vprintf+0x1c0>
    2290:	8aaa                	mv	s5,a0
    2292:	8b32                	mv	s6,a2
    2294:	00158493          	addi	s1,a1,1
  state = 0;
    2298:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
    229a:	02500a13          	li	s4,37
    229e:	4c55                	li	s8,21
    22a0:	00001c97          	auipc	s9,0x1
    22a4:	0a0c8c93          	addi	s9,s9,160 # 3340 <malloc+0xe12>
      } else if (c == 'p') {
        printptr(fd, va_arg(ap, uint64));
      } else if (c == 's') {
        s = va_arg(ap, char *);
        if (s == 0) s = "(null)";
        while (*s != 0) {
    22a8:	02800d93          	li	s11,40
  putc(fd, 'x');
    22ac:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    22ae:	00001b97          	auipc	s7,0x1
    22b2:	0eab8b93          	addi	s7,s7,234 # 3398 <digits>
    22b6:	a839                	j	22d4 <vprintf+0x6a>
        putc(fd, c);
    22b8:	85ca                	mv	a1,s2
    22ba:	8556                	mv	a0,s5
    22bc:	00000097          	auipc	ra,0x0
    22c0:	ee0080e7          	jalr	-288(ra) # 219c <putc>
    22c4:	a019                	j	22ca <vprintf+0x60>
    } else if (state == '%') {
    22c6:	01498d63          	beq	s3,s4,22e0 <vprintf+0x76>
  for (i = 0; fmt[i]; i++) {
    22ca:	0485                	addi	s1,s1,1
    22cc:	fff4c903          	lbu	s2,-1(s1)
    22d0:	14090d63          	beqz	s2,242a <vprintf+0x1c0>
    if (state == 0) {
    22d4:	fe0999e3          	bnez	s3,22c6 <vprintf+0x5c>
      if (c == '%') {
    22d8:	ff4910e3          	bne	s2,s4,22b8 <vprintf+0x4e>
        state = '%';
    22dc:	89d2                	mv	s3,s4
    22de:	b7f5                	j	22ca <vprintf+0x60>
      if (c == 'd') {
    22e0:	11490c63          	beq	s2,s4,23f8 <vprintf+0x18e>
    22e4:	f9d9079b          	addiw	a5,s2,-99
    22e8:	0ff7f793          	zext.b	a5,a5
    22ec:	10fc6e63          	bltu	s8,a5,2408 <vprintf+0x19e>
    22f0:	f9d9079b          	addiw	a5,s2,-99
    22f4:	0ff7f713          	zext.b	a4,a5
    22f8:	10ec6863          	bltu	s8,a4,2408 <vprintf+0x19e>
    22fc:	00271793          	slli	a5,a4,0x2
    2300:	97e6                	add	a5,a5,s9
    2302:	439c                	lw	a5,0(a5)
    2304:	97e6                	add	a5,a5,s9
    2306:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    2308:	008b0913          	addi	s2,s6,8
    230c:	4685                	li	a3,1
    230e:	4629                	li	a2,10
    2310:	000b2583          	lw	a1,0(s6)
    2314:	8556                	mv	a0,s5
    2316:	00000097          	auipc	ra,0x0
    231a:	ea8080e7          	jalr	-344(ra) # 21be <printint>
    231e:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    2320:	4981                	li	s3,0
    2322:	b765                	j	22ca <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    2324:	008b0913          	addi	s2,s6,8
    2328:	4681                	li	a3,0
    232a:	4629                	li	a2,10
    232c:	000b2583          	lw	a1,0(s6)
    2330:	8556                	mv	a0,s5
    2332:	00000097          	auipc	ra,0x0
    2336:	e8c080e7          	jalr	-372(ra) # 21be <printint>
    233a:	8b4a                	mv	s6,s2
      state = 0;
    233c:	4981                	li	s3,0
    233e:	b771                	j	22ca <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    2340:	008b0913          	addi	s2,s6,8
    2344:	4681                	li	a3,0
    2346:	866a                	mv	a2,s10
    2348:	000b2583          	lw	a1,0(s6)
    234c:	8556                	mv	a0,s5
    234e:	00000097          	auipc	ra,0x0
    2352:	e70080e7          	jalr	-400(ra) # 21be <printint>
    2356:	8b4a                	mv	s6,s2
      state = 0;
    2358:	4981                	li	s3,0
    235a:	bf85                	j	22ca <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    235c:	008b0793          	addi	a5,s6,8
    2360:	f8f43423          	sd	a5,-120(s0)
    2364:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    2368:	03000593          	li	a1,48
    236c:	8556                	mv	a0,s5
    236e:	00000097          	auipc	ra,0x0
    2372:	e2e080e7          	jalr	-466(ra) # 219c <putc>
  putc(fd, 'x');
    2376:	07800593          	li	a1,120
    237a:	8556                	mv	a0,s5
    237c:	00000097          	auipc	ra,0x0
    2380:	e20080e7          	jalr	-480(ra) # 219c <putc>
    2384:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    2386:	03c9d793          	srli	a5,s3,0x3c
    238a:	97de                	add	a5,a5,s7
    238c:	0007c583          	lbu	a1,0(a5)
    2390:	8556                	mv	a0,s5
    2392:	00000097          	auipc	ra,0x0
    2396:	e0a080e7          	jalr	-502(ra) # 219c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    239a:	0992                	slli	s3,s3,0x4
    239c:	397d                	addiw	s2,s2,-1
    239e:	fe0914e3          	bnez	s2,2386 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
    23a2:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    23a6:	4981                	li	s3,0
    23a8:	b70d                	j	22ca <vprintf+0x60>
        s = va_arg(ap, char *);
    23aa:	008b0913          	addi	s2,s6,8
    23ae:	000b3983          	ld	s3,0(s6)
        if (s == 0) s = "(null)";
    23b2:	02098163          	beqz	s3,23d4 <vprintf+0x16a>
        while (*s != 0) {
    23b6:	0009c583          	lbu	a1,0(s3)
    23ba:	c5ad                	beqz	a1,2424 <vprintf+0x1ba>
          putc(fd, *s);
    23bc:	8556                	mv	a0,s5
    23be:	00000097          	auipc	ra,0x0
    23c2:	dde080e7          	jalr	-546(ra) # 219c <putc>
          s++;
    23c6:	0985                	addi	s3,s3,1
        while (*s != 0) {
    23c8:	0009c583          	lbu	a1,0(s3)
    23cc:	f9e5                	bnez	a1,23bc <vprintf+0x152>
        s = va_arg(ap, char *);
    23ce:	8b4a                	mv	s6,s2
      state = 0;
    23d0:	4981                	li	s3,0
    23d2:	bde5                	j	22ca <vprintf+0x60>
        if (s == 0) s = "(null)";
    23d4:	00001997          	auipc	s3,0x1
    23d8:	f6498993          	addi	s3,s3,-156 # 3338 <malloc+0xe0a>
        while (*s != 0) {
    23dc:	85ee                	mv	a1,s11
    23de:	bff9                	j	23bc <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
    23e0:	008b0913          	addi	s2,s6,8
    23e4:	000b4583          	lbu	a1,0(s6)
    23e8:	8556                	mv	a0,s5
    23ea:	00000097          	auipc	ra,0x0
    23ee:	db2080e7          	jalr	-590(ra) # 219c <putc>
    23f2:	8b4a                	mv	s6,s2
      state = 0;
    23f4:	4981                	li	s3,0
    23f6:	bdd1                	j	22ca <vprintf+0x60>
        putc(fd, c);
    23f8:	85d2                	mv	a1,s4
    23fa:	8556                	mv	a0,s5
    23fc:	00000097          	auipc	ra,0x0
    2400:	da0080e7          	jalr	-608(ra) # 219c <putc>
      state = 0;
    2404:	4981                	li	s3,0
    2406:	b5d1                	j	22ca <vprintf+0x60>
        putc(fd, '%');
    2408:	85d2                	mv	a1,s4
    240a:	8556                	mv	a0,s5
    240c:	00000097          	auipc	ra,0x0
    2410:	d90080e7          	jalr	-624(ra) # 219c <putc>
        putc(fd, c);
    2414:	85ca                	mv	a1,s2
    2416:	8556                	mv	a0,s5
    2418:	00000097          	auipc	ra,0x0
    241c:	d84080e7          	jalr	-636(ra) # 219c <putc>
      state = 0;
    2420:	4981                	li	s3,0
    2422:	b565                	j	22ca <vprintf+0x60>
        s = va_arg(ap, char *);
    2424:	8b4a                	mv	s6,s2
      state = 0;
    2426:	4981                	li	s3,0
    2428:	b54d                	j	22ca <vprintf+0x60>
    }
  }
}
    242a:	70e6                	ld	ra,120(sp)
    242c:	7446                	ld	s0,112(sp)
    242e:	74a6                	ld	s1,104(sp)
    2430:	7906                	ld	s2,96(sp)
    2432:	69e6                	ld	s3,88(sp)
    2434:	6a46                	ld	s4,80(sp)
    2436:	6aa6                	ld	s5,72(sp)
    2438:	6b06                	ld	s6,64(sp)
    243a:	7be2                	ld	s7,56(sp)
    243c:	7c42                	ld	s8,48(sp)
    243e:	7ca2                	ld	s9,40(sp)
    2440:	7d02                	ld	s10,32(sp)
    2442:	6de2                	ld	s11,24(sp)
    2444:	6109                	addi	sp,sp,128
    2446:	8082                	ret

0000000000002448 <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
    2448:	715d                	addi	sp,sp,-80
    244a:	ec06                	sd	ra,24(sp)
    244c:	e822                	sd	s0,16(sp)
    244e:	1000                	addi	s0,sp,32
    2450:	e010                	sd	a2,0(s0)
    2452:	e414                	sd	a3,8(s0)
    2454:	e818                	sd	a4,16(s0)
    2456:	ec1c                	sd	a5,24(s0)
    2458:	03043023          	sd	a6,32(s0)
    245c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    2460:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    2464:	8622                	mv	a2,s0
    2466:	00000097          	auipc	ra,0x0
    246a:	e04080e7          	jalr	-508(ra) # 226a <vprintf>
}
    246e:	60e2                	ld	ra,24(sp)
    2470:	6442                	ld	s0,16(sp)
    2472:	6161                	addi	sp,sp,80
    2474:	8082                	ret

0000000000002476 <printf>:

void printf(const char *fmt, ...) {
    2476:	711d                	addi	sp,sp,-96
    2478:	ec06                	sd	ra,24(sp)
    247a:	e822                	sd	s0,16(sp)
    247c:	1000                	addi	s0,sp,32
    247e:	e40c                	sd	a1,8(s0)
    2480:	e810                	sd	a2,16(s0)
    2482:	ec14                	sd	a3,24(s0)
    2484:	f018                	sd	a4,32(s0)
    2486:	f41c                	sd	a5,40(s0)
    2488:	03043823          	sd	a6,48(s0)
    248c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    2490:	00840613          	addi	a2,s0,8
    2494:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    2498:	85aa                	mv	a1,a0
    249a:	4505                	li	a0,1
    249c:	00000097          	auipc	ra,0x0
    24a0:	dce080e7          	jalr	-562(ra) # 226a <vprintf>
}
    24a4:	60e2                	ld	ra,24(sp)
    24a6:	6442                	ld	s0,16(sp)
    24a8:	6125                	addi	sp,sp,96
    24aa:	8082                	ret

00000000000024ac <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
    24ac:	1141                	addi	sp,sp,-16
    24ae:	e422                	sd	s0,8(sp)
    24b0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
    24b2:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    24b6:	00002797          	auipc	a5,0x2
    24ba:	b4a7b783          	ld	a5,-1206(a5) # 4000 <freep>
    24be:	a02d                	j	24e8 <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
    24c0:	4618                	lw	a4,8(a2)
    24c2:	9f2d                	addw	a4,a4,a1
    24c4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    24c8:	6398                	ld	a4,0(a5)
    24ca:	6310                	ld	a2,0(a4)
    24cc:	a83d                	j	250a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
    24ce:	ff852703          	lw	a4,-8(a0)
    24d2:	9f31                	addw	a4,a4,a2
    24d4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    24d6:	ff053683          	ld	a3,-16(a0)
    24da:	a091                	j	251e <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
    24dc:	6398                	ld	a4,0(a5)
    24de:	00e7e463          	bltu	a5,a4,24e6 <free+0x3a>
    24e2:	00e6ea63          	bltu	a3,a4,24f6 <free+0x4a>
void free(void *ap) {
    24e6:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    24e8:	fed7fae3          	bgeu	a5,a3,24dc <free+0x30>
    24ec:	6398                	ld	a4,0(a5)
    24ee:	00e6e463          	bltu	a3,a4,24f6 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
    24f2:	fee7eae3          	bltu	a5,a4,24e6 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
    24f6:	ff852583          	lw	a1,-8(a0)
    24fa:	6390                	ld	a2,0(a5)
    24fc:	02059813          	slli	a6,a1,0x20
    2500:	01c85713          	srli	a4,a6,0x1c
    2504:	9736                	add	a4,a4,a3
    2506:	fae60de3          	beq	a2,a4,24c0 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    250a:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
    250e:	4790                	lw	a2,8(a5)
    2510:	02061593          	slli	a1,a2,0x20
    2514:	01c5d713          	srli	a4,a1,0x1c
    2518:	973e                	add	a4,a4,a5
    251a:	fae68ae3          	beq	a3,a4,24ce <free+0x22>
    p->s.ptr = bp->s.ptr;
    251e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    2520:	00002717          	auipc	a4,0x2
    2524:	aef73023          	sd	a5,-1312(a4) # 4000 <freep>
}
    2528:	6422                	ld	s0,8(sp)
    252a:	0141                	addi	sp,sp,16
    252c:	8082                	ret

000000000000252e <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
    252e:	7139                	addi	sp,sp,-64
    2530:	fc06                	sd	ra,56(sp)
    2532:	f822                	sd	s0,48(sp)
    2534:	f426                	sd	s1,40(sp)
    2536:	f04a                	sd	s2,32(sp)
    2538:	ec4e                	sd	s3,24(sp)
    253a:	e852                	sd	s4,16(sp)
    253c:	e456                	sd	s5,8(sp)
    253e:	e05a                	sd	s6,0(sp)
    2540:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    2542:	02051493          	slli	s1,a0,0x20
    2546:	9081                	srli	s1,s1,0x20
    2548:	04bd                	addi	s1,s1,15
    254a:	8091                	srli	s1,s1,0x4
    254c:	0014899b          	addiw	s3,s1,1
    2550:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
    2552:	00002517          	auipc	a0,0x2
    2556:	aae53503          	ld	a0,-1362(a0) # 4000 <freep>
    255a:	c515                	beqz	a0,2586 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    255c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    255e:	4798                	lw	a4,8(a5)
    2560:	02977f63          	bgeu	a4,s1,259e <malloc+0x70>
    2564:	8a4e                	mv	s4,s3
    2566:	0009871b          	sext.w	a4,s3
    256a:	6685                	lui	a3,0x1
    256c:	00d77363          	bgeu	a4,a3,2572 <malloc+0x44>
    2570:	6a05                	lui	s4,0x1
    2572:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    2576:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
    257a:	00002917          	auipc	s2,0x2
    257e:	a8690913          	addi	s2,s2,-1402 # 4000 <freep>
  if (p == (char *)-1) return 0;
    2582:	5afd                	li	s5,-1
    2584:	a895                	j	25f8 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    2586:	00002797          	auipc	a5,0x2
    258a:	c8a78793          	addi	a5,a5,-886 # 4210 <base>
    258e:	00002717          	auipc	a4,0x2
    2592:	a6f73923          	sd	a5,-1422(a4) # 4000 <freep>
    2596:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    2598:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
    259c:	b7e1                	j	2564 <malloc+0x36>
      if (p->s.size == nunits)
    259e:	02e48c63          	beq	s1,a4,25d6 <malloc+0xa8>
        p->s.size -= nunits;
    25a2:	4137073b          	subw	a4,a4,s3
    25a6:	c798                	sw	a4,8(a5)
        p += p->s.size;
    25a8:	02071693          	slli	a3,a4,0x20
    25ac:	01c6d713          	srli	a4,a3,0x1c
    25b0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    25b2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    25b6:	00002717          	auipc	a4,0x2
    25ba:	a4a73523          	sd	a0,-1462(a4) # 4000 <freep>
      return (void *)(p + 1);
    25be:	01078513          	addi	a0,a5,16
      if ((p = morecore(nunits)) == 0) return 0;
  }
}
    25c2:	70e2                	ld	ra,56(sp)
    25c4:	7442                	ld	s0,48(sp)
    25c6:	74a2                	ld	s1,40(sp)
    25c8:	7902                	ld	s2,32(sp)
    25ca:	69e2                	ld	s3,24(sp)
    25cc:	6a42                	ld	s4,16(sp)
    25ce:	6aa2                	ld	s5,8(sp)
    25d0:	6b02                	ld	s6,0(sp)
    25d2:	6121                	addi	sp,sp,64
    25d4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    25d6:	6398                	ld	a4,0(a5)
    25d8:	e118                	sd	a4,0(a0)
    25da:	bff1                	j	25b6 <malloc+0x88>
  hp->s.size = nu;
    25dc:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
    25e0:	0541                	addi	a0,a0,16
    25e2:	00000097          	auipc	ra,0x0
    25e6:	eca080e7          	jalr	-310(ra) # 24ac <free>
  return freep;
    25ea:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
    25ee:	d971                	beqz	a0,25c2 <malloc+0x94>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    25f0:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    25f2:	4798                	lw	a4,8(a5)
    25f4:	fa9775e3          	bgeu	a4,s1,259e <malloc+0x70>
    if (p == freep)
    25f8:	00093703          	ld	a4,0(s2)
    25fc:	853e                	mv	a0,a5
    25fe:	fef719e3          	bne	a4,a5,25f0 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    2602:	8552                	mv	a0,s4
    2604:	00000097          	auipc	ra,0x0
    2608:	b60080e7          	jalr	-1184(ra) # 2164 <sbrk>
  if (p == (char *)-1) return 0;
    260c:	fd5518e3          	bne	a0,s5,25dc <malloc+0xae>
      if ((p = morecore(nunits)) == 0) return 0;
    2610:	4501                	li	a0,0
    2612:	bf45                	j	25c2 <malloc+0x94>
