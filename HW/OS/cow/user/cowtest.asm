
user/_cowtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <rotest_victim>:
    0x13, 0x05, 0xb0, 0x07,  // li a0, 123
    0x89, 0x48,              // li a7, 2
    0x73, 0x00, 0x00, 0x00   // ecall
};

void rotest_victim() { sleep(5); }
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
   8:	4515                	li	a0,5
   a:	00001097          	auipc	ra,0x1
   e:	98c080e7          	jalr	-1652(ra) # 996 <sleep>
  12:	60a2                	ld	ra,8(sp)
  14:	6402                	ld	s0,0(sp)
  16:	0141                	addi	sp,sp,16
  18:	8082                	ret

000000000000001a <simpletest>:
void simpletest() {
  1a:	7179                	addi	sp,sp,-48
  1c:	f406                	sd	ra,40(sp)
  1e:	f022                	sd	s0,32(sp)
  20:	ec26                	sd	s1,24(sp)
  22:	e84a                	sd	s2,16(sp)
  24:	e44e                	sd	s3,8(sp)
  26:	1800                	addi	s0,sp,48
  printf("simple: ");
  28:	00001517          	auipc	a0,0x1
  2c:	df850513          	addi	a0,a0,-520 # e20 <malloc+0xe8>
  30:	00001097          	auipc	ra,0x1
  34:	c50080e7          	jalr	-944(ra) # c80 <printf>
  char *p = sbrk(sz);
  38:	05555537          	lui	a0,0x5555
  3c:	55450513          	addi	a0,a0,1364 # 5555554 <base+0x554f544>
  40:	00001097          	auipc	ra,0x1
  44:	94e080e7          	jalr	-1714(ra) # 98e <sbrk>
  if (p == (char *)0xffffffffffffffffL) {
  48:	57fd                	li	a5,-1
  4a:	06f50563          	beq	a0,a5,b4 <simpletest+0x9a>
  4e:	84aa                	mv	s1,a0
  for (char *q = p; q < p + sz; q += 4096) {
  50:	05556937          	lui	s2,0x5556
  54:	992a                	add	s2,s2,a0
  56:	6985                	lui	s3,0x1
    *(int *)q = getpid();
  58:	00001097          	auipc	ra,0x1
  5c:	92e080e7          	jalr	-1746(ra) # 986 <getpid>
  60:	c088                	sw	a0,0(s1)
  for (char *q = p; q < p + sz; q += 4096) {
  62:	94ce                	add	s1,s1,s3
  64:	fe991ae3          	bne	s2,s1,58 <simpletest+0x3e>
  int pid = fork();
  68:	00001097          	auipc	ra,0x1
  6c:	896080e7          	jalr	-1898(ra) # 8fe <fork>
  if (pid < 0) {
  70:	06054363          	bltz	a0,d6 <simpletest+0xbc>
  if (pid == 0) exit(0);
  74:	cd35                	beqz	a0,f0 <simpletest+0xd6>
  wait(0);
  76:	4501                	li	a0,0
  78:	00001097          	auipc	ra,0x1
  7c:	896080e7          	jalr	-1898(ra) # 90e <wait>
  if (sbrk(-sz) == (char *)0xffffffffffffffffL) {
  80:	faaab537          	lui	a0,0xfaaab
  84:	aac50513          	addi	a0,a0,-1364 # fffffffffaaaaaac <base+0xfffffffffaaa4a9c>
  88:	00001097          	auipc	ra,0x1
  8c:	906080e7          	jalr	-1786(ra) # 98e <sbrk>
  90:	57fd                	li	a5,-1
  92:	06f50363          	beq	a0,a5,f8 <simpletest+0xde>
  printf("ok\n");
  96:	00001517          	auipc	a0,0x1
  9a:	dda50513          	addi	a0,a0,-550 # e70 <malloc+0x138>
  9e:	00001097          	auipc	ra,0x1
  a2:	be2080e7          	jalr	-1054(ra) # c80 <printf>
}
  a6:	70a2                	ld	ra,40(sp)
  a8:	7402                	ld	s0,32(sp)
  aa:	64e2                	ld	s1,24(sp)
  ac:	6942                	ld	s2,16(sp)
  ae:	69a2                	ld	s3,8(sp)
  b0:	6145                	addi	sp,sp,48
  b2:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
  b4:	055555b7          	lui	a1,0x5555
  b8:	55458593          	addi	a1,a1,1364 # 5555554 <base+0x554f544>
  bc:	00001517          	auipc	a0,0x1
  c0:	d7450513          	addi	a0,a0,-652 # e30 <malloc+0xf8>
  c4:	00001097          	auipc	ra,0x1
  c8:	bbc080e7          	jalr	-1092(ra) # c80 <printf>
    exit(-1);
  cc:	557d                	li	a0,-1
  ce:	00001097          	auipc	ra,0x1
  d2:	838080e7          	jalr	-1992(ra) # 906 <exit>
    printf("fork() failed\n");
  d6:	00001517          	auipc	a0,0x1
  da:	d7250513          	addi	a0,a0,-654 # e48 <malloc+0x110>
  de:	00001097          	auipc	ra,0x1
  e2:	ba2080e7          	jalr	-1118(ra) # c80 <printf>
    exit(-1);
  e6:	557d                	li	a0,-1
  e8:	00001097          	auipc	ra,0x1
  ec:	81e080e7          	jalr	-2018(ra) # 906 <exit>
  if (pid == 0) exit(0);
  f0:	00001097          	auipc	ra,0x1
  f4:	816080e7          	jalr	-2026(ra) # 906 <exit>
    printf("sbrk(-%d) failed\n", sz);
  f8:	055555b7          	lui	a1,0x5555
  fc:	55458593          	addi	a1,a1,1364 # 5555554 <base+0x554f544>
 100:	00001517          	auipc	a0,0x1
 104:	d5850513          	addi	a0,a0,-680 # e58 <malloc+0x120>
 108:	00001097          	auipc	ra,0x1
 10c:	b78080e7          	jalr	-1160(ra) # c80 <printf>
    exit(-1);
 110:	557d                	li	a0,-1
 112:	00000097          	auipc	ra,0x0
 116:	7f4080e7          	jalr	2036(ra) # 906 <exit>

000000000000011a <threetest>:
void threetest() {
 11a:	7179                	addi	sp,sp,-48
 11c:	f406                	sd	ra,40(sp)
 11e:	f022                	sd	s0,32(sp)
 120:	ec26                	sd	s1,24(sp)
 122:	e84a                	sd	s2,16(sp)
 124:	e44e                	sd	s3,8(sp)
 126:	e052                	sd	s4,0(sp)
 128:	1800                	addi	s0,sp,48
  printf("three: ");
 12a:	00001517          	auipc	a0,0x1
 12e:	d4e50513          	addi	a0,a0,-690 # e78 <malloc+0x140>
 132:	00001097          	auipc	ra,0x1
 136:	b4e080e7          	jalr	-1202(ra) # c80 <printf>
  char *p = sbrk(sz);
 13a:	02000537          	lui	a0,0x2000
 13e:	00001097          	auipc	ra,0x1
 142:	850080e7          	jalr	-1968(ra) # 98e <sbrk>
  if (p == (char *)0xffffffffffffffffL) {
 146:	57fd                	li	a5,-1
 148:	08f50763          	beq	a0,a5,1d6 <threetest+0xbc>
 14c:	84aa                	mv	s1,a0
  pid1 = fork();
 14e:	00000097          	auipc	ra,0x0
 152:	7b0080e7          	jalr	1968(ra) # 8fe <fork>
  if (pid1 < 0) {
 156:	08054f63          	bltz	a0,1f4 <threetest+0xda>
  if (pid1 == 0) {
 15a:	c955                	beqz	a0,20e <threetest+0xf4>
  for (char *q = p; q < p + sz; q += 4096) {
 15c:	020009b7          	lui	s3,0x2000
 160:	99a6                	add	s3,s3,s1
 162:	8926                	mv	s2,s1
 164:	6a05                	lui	s4,0x1
    *(int *)q = getpid();
 166:	00001097          	auipc	ra,0x1
 16a:	820080e7          	jalr	-2016(ra) # 986 <getpid>
 16e:	00a92023          	sw	a0,0(s2) # 5556000 <base+0x554fff0>
  for (char *q = p; q < p + sz; q += 4096) {
 172:	9952                	add	s2,s2,s4
 174:	ff3919e3          	bne	s2,s3,166 <threetest+0x4c>
  wait(0);
 178:	4501                	li	a0,0
 17a:	00000097          	auipc	ra,0x0
 17e:	794080e7          	jalr	1940(ra) # 90e <wait>
  sleep(1);
 182:	4505                	li	a0,1
 184:	00001097          	auipc	ra,0x1
 188:	812080e7          	jalr	-2030(ra) # 996 <sleep>
  for (char *q = p; q < p + sz; q += 4096) {
 18c:	6a05                	lui	s4,0x1
    if (*(int *)q != getpid()) {
 18e:	0004a903          	lw	s2,0(s1)
 192:	00000097          	auipc	ra,0x0
 196:	7f4080e7          	jalr	2036(ra) # 986 <getpid>
 19a:	10a91a63          	bne	s2,a0,2ae <threetest+0x194>
  for (char *q = p; q < p + sz; q += 4096) {
 19e:	94d2                	add	s1,s1,s4
 1a0:	ff3497e3          	bne	s1,s3,18e <threetest+0x74>
  if (sbrk(-sz) == (char *)0xffffffffffffffffL) {
 1a4:	fe000537          	lui	a0,0xfe000
 1a8:	00000097          	auipc	ra,0x0
 1ac:	7e6080e7          	jalr	2022(ra) # 98e <sbrk>
 1b0:	57fd                	li	a5,-1
 1b2:	10f50b63          	beq	a0,a5,2c8 <threetest+0x1ae>
  printf("ok\n");
 1b6:	00001517          	auipc	a0,0x1
 1ba:	cba50513          	addi	a0,a0,-838 # e70 <malloc+0x138>
 1be:	00001097          	auipc	ra,0x1
 1c2:	ac2080e7          	jalr	-1342(ra) # c80 <printf>
}
 1c6:	70a2                	ld	ra,40(sp)
 1c8:	7402                	ld	s0,32(sp)
 1ca:	64e2                	ld	s1,24(sp)
 1cc:	6942                	ld	s2,16(sp)
 1ce:	69a2                	ld	s3,8(sp)
 1d0:	6a02                	ld	s4,0(sp)
 1d2:	6145                	addi	sp,sp,48
 1d4:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
 1d6:	020005b7          	lui	a1,0x2000
 1da:	00001517          	auipc	a0,0x1
 1de:	c5650513          	addi	a0,a0,-938 # e30 <malloc+0xf8>
 1e2:	00001097          	auipc	ra,0x1
 1e6:	a9e080e7          	jalr	-1378(ra) # c80 <printf>
    exit(-1);
 1ea:	557d                	li	a0,-1
 1ec:	00000097          	auipc	ra,0x0
 1f0:	71a080e7          	jalr	1818(ra) # 906 <exit>
    printf("fork failed\n");
 1f4:	00001517          	auipc	a0,0x1
 1f8:	c8c50513          	addi	a0,a0,-884 # e80 <malloc+0x148>
 1fc:	00001097          	auipc	ra,0x1
 200:	a84080e7          	jalr	-1404(ra) # c80 <printf>
    exit(-1);
 204:	557d                	li	a0,-1
 206:	00000097          	auipc	ra,0x0
 20a:	700080e7          	jalr	1792(ra) # 906 <exit>
    pid2 = fork();
 20e:	00000097          	auipc	ra,0x0
 212:	6f0080e7          	jalr	1776(ra) # 8fe <fork>
    if (pid2 < 0) {
 216:	04054263          	bltz	a0,25a <threetest+0x140>
    if (pid2 == 0) {
 21a:	ed29                	bnez	a0,274 <threetest+0x15a>
      for (char *q = p; q < p + (sz / 5) * 4; q += 4096) {
 21c:	0199a9b7          	lui	s3,0x199a
 220:	99a6                	add	s3,s3,s1
 222:	8926                	mv	s2,s1
 224:	6a05                	lui	s4,0x1
        *(int *)q = getpid();
 226:	00000097          	auipc	ra,0x0
 22a:	760080e7          	jalr	1888(ra) # 986 <getpid>
 22e:	00a92023          	sw	a0,0(s2)
      for (char *q = p; q < p + (sz / 5) * 4; q += 4096) {
 232:	9952                	add	s2,s2,s4
 234:	ff2999e3          	bne	s3,s2,226 <threetest+0x10c>
      for (char *q = p; q < p + (sz / 5) * 4; q += 4096) {
 238:	6a05                	lui	s4,0x1
        if (*(int *)q != getpid()) {
 23a:	0004a903          	lw	s2,0(s1)
 23e:	00000097          	auipc	ra,0x0
 242:	748080e7          	jalr	1864(ra) # 986 <getpid>
 246:	04a91763          	bne	s2,a0,294 <threetest+0x17a>
      for (char *q = p; q < p + (sz / 5) * 4; q += 4096) {
 24a:	94d2                	add	s1,s1,s4
 24c:	fe9997e3          	bne	s3,s1,23a <threetest+0x120>
      exit(-1);
 250:	557d                	li	a0,-1
 252:	00000097          	auipc	ra,0x0
 256:	6b4080e7          	jalr	1716(ra) # 906 <exit>
      printf("fork failed");
 25a:	00001517          	auipc	a0,0x1
 25e:	c3650513          	addi	a0,a0,-970 # e90 <malloc+0x158>
 262:	00001097          	auipc	ra,0x1
 266:	a1e080e7          	jalr	-1506(ra) # c80 <printf>
      exit(-1);
 26a:	557d                	li	a0,-1
 26c:	00000097          	auipc	ra,0x0
 270:	69a080e7          	jalr	1690(ra) # 906 <exit>
    for (char *q = p; q < p + (sz / 2); q += 4096) {
 274:	01000737          	lui	a4,0x1000
 278:	9726                	add	a4,a4,s1
      *(int *)q = 9999;
 27a:	6789                	lui	a5,0x2
 27c:	70f78793          	addi	a5,a5,1807 # 270f <junk3+0x6ff>
    for (char *q = p; q < p + (sz / 2); q += 4096) {
 280:	6685                	lui	a3,0x1
      *(int *)q = 9999;
 282:	c09c                	sw	a5,0(s1)
    for (char *q = p; q < p + (sz / 2); q += 4096) {
 284:	94b6                	add	s1,s1,a3
 286:	fee49ee3          	bne	s1,a4,282 <threetest+0x168>
    exit(0);
 28a:	4501                	li	a0,0
 28c:	00000097          	auipc	ra,0x0
 290:	67a080e7          	jalr	1658(ra) # 906 <exit>
          printf("wrong content\n");
 294:	00001517          	auipc	a0,0x1
 298:	c0c50513          	addi	a0,a0,-1012 # ea0 <malloc+0x168>
 29c:	00001097          	auipc	ra,0x1
 2a0:	9e4080e7          	jalr	-1564(ra) # c80 <printf>
          exit(-1);
 2a4:	557d                	li	a0,-1
 2a6:	00000097          	auipc	ra,0x0
 2aa:	660080e7          	jalr	1632(ra) # 906 <exit>
      printf("wrong content\n");
 2ae:	00001517          	auipc	a0,0x1
 2b2:	bf250513          	addi	a0,a0,-1038 # ea0 <malloc+0x168>
 2b6:	00001097          	auipc	ra,0x1
 2ba:	9ca080e7          	jalr	-1590(ra) # c80 <printf>
      exit(-1);
 2be:	557d                	li	a0,-1
 2c0:	00000097          	auipc	ra,0x0
 2c4:	646080e7          	jalr	1606(ra) # 906 <exit>
    printf("sbrk(-%d) failed\n", sz);
 2c8:	020005b7          	lui	a1,0x2000
 2cc:	00001517          	auipc	a0,0x1
 2d0:	b8c50513          	addi	a0,a0,-1140 # e58 <malloc+0x120>
 2d4:	00001097          	auipc	ra,0x1
 2d8:	9ac080e7          	jalr	-1620(ra) # c80 <printf>
    exit(-1);
 2dc:	557d                	li	a0,-1
 2de:	00000097          	auipc	ra,0x0
 2e2:	628080e7          	jalr	1576(ra) # 906 <exit>

00000000000002e6 <filetest>:
void filetest() {
 2e6:	7179                	addi	sp,sp,-48
 2e8:	f406                	sd	ra,40(sp)
 2ea:	f022                	sd	s0,32(sp)
 2ec:	ec26                	sd	s1,24(sp)
 2ee:	e84a                	sd	s2,16(sp)
 2f0:	1800                	addi	s0,sp,48
  printf("file: ");
 2f2:	00001517          	auipc	a0,0x1
 2f6:	bbe50513          	addi	a0,a0,-1090 # eb0 <malloc+0x178>
 2fa:	00001097          	auipc	ra,0x1
 2fe:	986080e7          	jalr	-1658(ra) # c80 <printf>
  buf[0] = 99;
 302:	06300793          	li	a5,99
 306:	00003717          	auipc	a4,0x3
 30a:	d0f70523          	sb	a5,-758(a4) # 3010 <buf>
  for (int i = 0; i < 4; i++) {
 30e:	fc042c23          	sw	zero,-40(s0)
    if (pipe(fds) != 0) {
 312:	00002497          	auipc	s1,0x2
 316:	cee48493          	addi	s1,s1,-786 # 2000 <fds>
  for (int i = 0; i < 4; i++) {
 31a:	490d                	li	s2,3
    if (pipe(fds) != 0) {
 31c:	8526                	mv	a0,s1
 31e:	00000097          	auipc	ra,0x0
 322:	5f8080e7          	jalr	1528(ra) # 916 <pipe>
 326:	e149                	bnez	a0,3a8 <filetest+0xc2>
    int pid = fork();
 328:	00000097          	auipc	ra,0x0
 32c:	5d6080e7          	jalr	1494(ra) # 8fe <fork>
    if (pid < 0) {
 330:	08054963          	bltz	a0,3c2 <filetest+0xdc>
    if (pid == 0) {
 334:	c545                	beqz	a0,3dc <filetest+0xf6>
    if (write(fds[1], &i, sizeof(i)) != sizeof(i)) {
 336:	4611                	li	a2,4
 338:	fd840593          	addi	a1,s0,-40
 33c:	40c8                	lw	a0,4(s1)
 33e:	00000097          	auipc	ra,0x0
 342:	5e8080e7          	jalr	1512(ra) # 926 <write>
 346:	4791                	li	a5,4
 348:	10f51b63          	bne	a0,a5,45e <filetest+0x178>
  for (int i = 0; i < 4; i++) {
 34c:	fd842783          	lw	a5,-40(s0)
 350:	2785                	addiw	a5,a5,1
 352:	0007871b          	sext.w	a4,a5
 356:	fcf42c23          	sw	a5,-40(s0)
 35a:	fce951e3          	bge	s2,a4,31c <filetest+0x36>
  int xstatus = 0;
 35e:	fc042e23          	sw	zero,-36(s0)
 362:	4491                	li	s1,4
    wait(&xstatus);
 364:	fdc40513          	addi	a0,s0,-36
 368:	00000097          	auipc	ra,0x0
 36c:	5a6080e7          	jalr	1446(ra) # 90e <wait>
    if (xstatus != 0) {
 370:	fdc42783          	lw	a5,-36(s0)
 374:	10079263          	bnez	a5,478 <filetest+0x192>
  for (int i = 0; i < 4; i++) {
 378:	34fd                	addiw	s1,s1,-1
 37a:	f4ed                	bnez	s1,364 <filetest+0x7e>
  if (buf[0] != 99) {
 37c:	00003717          	auipc	a4,0x3
 380:	c9474703          	lbu	a4,-876(a4) # 3010 <buf>
 384:	06300793          	li	a5,99
 388:	0ef71d63          	bne	a4,a5,482 <filetest+0x19c>
  printf("ok\n");
 38c:	00001517          	auipc	a0,0x1
 390:	ae450513          	addi	a0,a0,-1308 # e70 <malloc+0x138>
 394:	00001097          	auipc	ra,0x1
 398:	8ec080e7          	jalr	-1812(ra) # c80 <printf>
}
 39c:	70a2                	ld	ra,40(sp)
 39e:	7402                	ld	s0,32(sp)
 3a0:	64e2                	ld	s1,24(sp)
 3a2:	6942                	ld	s2,16(sp)
 3a4:	6145                	addi	sp,sp,48
 3a6:	8082                	ret
      printf("pipe() failed\n");
 3a8:	00001517          	auipc	a0,0x1
 3ac:	b1050513          	addi	a0,a0,-1264 # eb8 <malloc+0x180>
 3b0:	00001097          	auipc	ra,0x1
 3b4:	8d0080e7          	jalr	-1840(ra) # c80 <printf>
      exit(-1);
 3b8:	557d                	li	a0,-1
 3ba:	00000097          	auipc	ra,0x0
 3be:	54c080e7          	jalr	1356(ra) # 906 <exit>
      printf("fork failed\n");
 3c2:	00001517          	auipc	a0,0x1
 3c6:	abe50513          	addi	a0,a0,-1346 # e80 <malloc+0x148>
 3ca:	00001097          	auipc	ra,0x1
 3ce:	8b6080e7          	jalr	-1866(ra) # c80 <printf>
      exit(-1);
 3d2:	557d                	li	a0,-1
 3d4:	00000097          	auipc	ra,0x0
 3d8:	532080e7          	jalr	1330(ra) # 906 <exit>
      sleep(1);
 3dc:	4505                	li	a0,1
 3de:	00000097          	auipc	ra,0x0
 3e2:	5b8080e7          	jalr	1464(ra) # 996 <sleep>
      if (read(fds[0], buf, sizeof(i)) != sizeof(i)) {
 3e6:	4611                	li	a2,4
 3e8:	00003597          	auipc	a1,0x3
 3ec:	c2858593          	addi	a1,a1,-984 # 3010 <buf>
 3f0:	00002517          	auipc	a0,0x2
 3f4:	c1052503          	lw	a0,-1008(a0) # 2000 <fds>
 3f8:	00000097          	auipc	ra,0x0
 3fc:	526080e7          	jalr	1318(ra) # 91e <read>
 400:	4791                	li	a5,4
 402:	02f51c63          	bne	a0,a5,43a <filetest+0x154>
      sleep(1);
 406:	4505                	li	a0,1
 408:	00000097          	auipc	ra,0x0
 40c:	58e080e7          	jalr	1422(ra) # 996 <sleep>
      if (j != i) {
 410:	fd842703          	lw	a4,-40(s0)
 414:	00003797          	auipc	a5,0x3
 418:	bfc7a783          	lw	a5,-1028(a5) # 3010 <buf>
 41c:	02f70c63          	beq	a4,a5,454 <filetest+0x16e>
        printf("error: read the wrong value\n");
 420:	00001517          	auipc	a0,0x1
 424:	ac050513          	addi	a0,a0,-1344 # ee0 <malloc+0x1a8>
 428:	00001097          	auipc	ra,0x1
 42c:	858080e7          	jalr	-1960(ra) # c80 <printf>
        exit(1);
 430:	4505                	li	a0,1
 432:	00000097          	auipc	ra,0x0
 436:	4d4080e7          	jalr	1236(ra) # 906 <exit>
        printf("error: read failed\n");
 43a:	00001517          	auipc	a0,0x1
 43e:	a8e50513          	addi	a0,a0,-1394 # ec8 <malloc+0x190>
 442:	00001097          	auipc	ra,0x1
 446:	83e080e7          	jalr	-1986(ra) # c80 <printf>
        exit(1);
 44a:	4505                	li	a0,1
 44c:	00000097          	auipc	ra,0x0
 450:	4ba080e7          	jalr	1210(ra) # 906 <exit>
      exit(0);
 454:	4501                	li	a0,0
 456:	00000097          	auipc	ra,0x0
 45a:	4b0080e7          	jalr	1200(ra) # 906 <exit>
      printf("error: write failed\n");
 45e:	00001517          	auipc	a0,0x1
 462:	aa250513          	addi	a0,a0,-1374 # f00 <malloc+0x1c8>
 466:	00001097          	auipc	ra,0x1
 46a:	81a080e7          	jalr	-2022(ra) # c80 <printf>
      exit(-1);
 46e:	557d                	li	a0,-1
 470:	00000097          	auipc	ra,0x0
 474:	496080e7          	jalr	1174(ra) # 906 <exit>
      exit(1);
 478:	4505                	li	a0,1
 47a:	00000097          	auipc	ra,0x0
 47e:	48c080e7          	jalr	1164(ra) # 906 <exit>
    printf("error: child overwrote parent\n");
 482:	00001517          	auipc	a0,0x1
 486:	a9650513          	addi	a0,a0,-1386 # f18 <malloc+0x1e0>
 48a:	00000097          	auipc	ra,0x0
 48e:	7f6080e7          	jalr	2038(ra) # c80 <printf>
    exit(1);
 492:	4505                	li	a0,1
 494:	00000097          	auipc	ra,0x0
 498:	472080e7          	jalr	1138(ra) # 906 <exit>

000000000000049c <rotest>:

typedef void (*func)();

// Checks that PTE access flags are not overwritten with incorrect values.
void rotest() {
 49c:	7179                	addi	sp,sp,-48
 49e:	f406                	sd	ra,40(sp)
 4a0:	f022                	sd	s0,32(sp)
 4a2:	ec26                	sd	s1,24(sp)
 4a4:	1800                	addi	s0,sp,48
  printf("ro: ");
 4a6:	00001517          	auipc	a0,0x1
 4aa:	a9250513          	addi	a0,a0,-1390 # f38 <malloc+0x200>
 4ae:	00000097          	auipc	ra,0x0
 4b2:	7d2080e7          	jalr	2002(ra) # c80 <printf>

  int pid1 = fork();
 4b6:	00000097          	auipc	ra,0x0
 4ba:	448080e7          	jalr	1096(ra) # 8fe <fork>

  if (pid1 > 0) {
 4be:	0aa05663          	blez	a0,56a <rotest+0xce>
 4c2:	84aa                	mv	s1,a0
    int xstatus;
    if (wait(&xstatus) != pid1) {
 4c4:	fdc40513          	addi	a0,s0,-36
 4c8:	00000097          	auipc	ra,0x0
 4cc:	446080e7          	jalr	1094(ra) # 90e <wait>
 4d0:	02951963          	bne	a0,s1,502 <rotest+0x66>
      printf("error: first child not found\n");
      exit(1);
    }

    if (xstatus == 123) {
 4d4:	fdc42783          	lw	a5,-36(s0)
 4d8:	07b00713          	li	a4,123
 4dc:	04e78063          	beq	a5,a4,51c <rotest+0x80>
      printf("error: parent memory corrupted\n");
      exit(1);
    } else if (xstatus == 1) {
 4e0:	4705                	li	a4,1
 4e2:	04e78a63          	beq	a5,a4,536 <rotest+0x9a>
      printf("failed\n");
      exit(1);
    } else if (xstatus != 0) {
 4e6:	e7ad                	bnez	a5,550 <rotest+0xb4>
      printf("error: unexpected first child exit code %d\n");
      exit(1);
    }

    printf("ok\n");
 4e8:	00001517          	auipc	a0,0x1
 4ec:	98850513          	addi	a0,a0,-1656 # e70 <malloc+0x138>
 4f0:	00000097          	auipc	ra,0x0
 4f4:	790080e7          	jalr	1936(ra) # c80 <printf>

  memmove(rotest_victim, HACK, sizeof(HACK));
  rotest_victim();

  exit(0);
}
 4f8:	70a2                	ld	ra,40(sp)
 4fa:	7402                	ld	s0,32(sp)
 4fc:	64e2                	ld	s1,24(sp)
 4fe:	6145                	addi	sp,sp,48
 500:	8082                	ret
      printf("error: first child not found\n");
 502:	00001517          	auipc	a0,0x1
 506:	a3e50513          	addi	a0,a0,-1474 # f40 <malloc+0x208>
 50a:	00000097          	auipc	ra,0x0
 50e:	776080e7          	jalr	1910(ra) # c80 <printf>
      exit(1);
 512:	4505                	li	a0,1
 514:	00000097          	auipc	ra,0x0
 518:	3f2080e7          	jalr	1010(ra) # 906 <exit>
      printf("error: parent memory corrupted\n");
 51c:	00001517          	auipc	a0,0x1
 520:	a4450513          	addi	a0,a0,-1468 # f60 <malloc+0x228>
 524:	00000097          	auipc	ra,0x0
 528:	75c080e7          	jalr	1884(ra) # c80 <printf>
      exit(1);
 52c:	4505                	li	a0,1
 52e:	00000097          	auipc	ra,0x0
 532:	3d8080e7          	jalr	984(ra) # 906 <exit>
      printf("failed\n");
 536:	00001517          	auipc	a0,0x1
 53a:	a4a50513          	addi	a0,a0,-1462 # f80 <malloc+0x248>
 53e:	00000097          	auipc	ra,0x0
 542:	742080e7          	jalr	1858(ra) # c80 <printf>
      exit(1);
 546:	4505                	li	a0,1
 548:	00000097          	auipc	ra,0x0
 54c:	3be080e7          	jalr	958(ra) # 906 <exit>
      printf("error: unexpected first child exit code %d\n");
 550:	00001517          	auipc	a0,0x1
 554:	a3850513          	addi	a0,a0,-1480 # f88 <malloc+0x250>
 558:	00000097          	auipc	ra,0x0
 55c:	728080e7          	jalr	1832(ra) # c80 <printf>
      exit(1);
 560:	4505                	li	a0,1
 562:	00000097          	auipc	ra,0x0
 566:	3a4080e7          	jalr	932(ra) # 906 <exit>
  int pid2 = fork();
 56a:	00000097          	auipc	ra,0x0
 56e:	394080e7          	jalr	916(ra) # 8fe <fork>
 572:	84aa                	mv	s1,a0
  if (pid2 > 0) {
 574:	08a05363          	blez	a0,5fa <rotest+0x15e>
    if (wait(&xstatus) != pid2) {
 578:	fdc40513          	addi	a0,s0,-36
 57c:	00000097          	auipc	ra,0x0
 580:	392080e7          	jalr	914(ra) # 90e <wait>
 584:	02951c63          	bne	a0,s1,5bc <rotest+0x120>
    rotest_victim();
 588:	00000097          	auipc	ra,0x0
 58c:	a78080e7          	jalr	-1416(ra) # 0 <rotest_victim>
    if (xstatus == 123) {
 590:	fdc42583          	lw	a1,-36(s0)
 594:	07b00793          	li	a5,123
 598:	02f58f63          	beq	a1,a5,5d6 <rotest+0x13a>
    } else if (xstatus != -1) {
 59c:	57fd                	li	a5,-1
 59e:	04f58963          	beq	a1,a5,5f0 <rotest+0x154>
      printf("error: unexpected second child exit code %d\n", xstatus);
 5a2:	00001517          	auipc	a0,0x1
 5a6:	a5650513          	addi	a0,a0,-1450 # ff8 <malloc+0x2c0>
 5aa:	00000097          	auipc	ra,0x0
 5ae:	6d6080e7          	jalr	1750(ra) # c80 <printf>
      exit(1);
 5b2:	4505                	li	a0,1
 5b4:	00000097          	auipc	ra,0x0
 5b8:	352080e7          	jalr	850(ra) # 906 <exit>
      printf("error: second child not found\n");
 5bc:	00001517          	auipc	a0,0x1
 5c0:	9fc50513          	addi	a0,a0,-1540 # fb8 <malloc+0x280>
 5c4:	00000097          	auipc	ra,0x0
 5c8:	6bc080e7          	jalr	1724(ra) # c80 <printf>
      exit(1);
 5cc:	4505                	li	a0,1
 5ce:	00000097          	auipc	ra,0x0
 5d2:	338080e7          	jalr	824(ra) # 906 <exit>
      printf("error: self memory corrupted\n");
 5d6:	00001517          	auipc	a0,0x1
 5da:	a0250513          	addi	a0,a0,-1534 # fd8 <malloc+0x2a0>
 5de:	00000097          	auipc	ra,0x0
 5e2:	6a2080e7          	jalr	1698(ra) # c80 <printf>
      exit(1);
 5e6:	4505                	li	a0,1
 5e8:	00000097          	auipc	ra,0x0
 5ec:	31e080e7          	jalr	798(ra) # 906 <exit>
    exit(0);
 5f0:	4501                	li	a0,0
 5f2:	00000097          	auipc	ra,0x0
 5f6:	314080e7          	jalr	788(ra) # 906 <exit>
  memmove(rotest_victim, HACK, sizeof(HACK));
 5fa:	4629                	li	a2,10
 5fc:	00001597          	auipc	a1,0x1
 600:	a4458593          	addi	a1,a1,-1468 # 1040 <HACK>
 604:	00000517          	auipc	a0,0x0
 608:	9fc50513          	addi	a0,a0,-1540 # 0 <rotest_victim>
 60c:	00000097          	auipc	ra,0x0
 610:	248080e7          	jalr	584(ra) # 854 <memmove>
  rotest_victim();
 614:	00000097          	auipc	ra,0x0
 618:	9ec080e7          	jalr	-1556(ra) # 0 <rotest_victim>
  exit(0);
 61c:	4501                	li	a0,0
 61e:	00000097          	auipc	ra,0x0
 622:	2e8080e7          	jalr	744(ra) # 906 <exit>

0000000000000626 <main>:

int main(int argc, char *argv[]) {
 626:	1141                	addi	sp,sp,-16
 628:	e406                	sd	ra,8(sp)
 62a:	e022                	sd	s0,0(sp)
 62c:	0800                	addi	s0,sp,16
  simpletest();
 62e:	00000097          	auipc	ra,0x0
 632:	9ec080e7          	jalr	-1556(ra) # 1a <simpletest>

  // check that the first simpletest() freed the physical memory.
  simpletest();
 636:	00000097          	auipc	ra,0x0
 63a:	9e4080e7          	jalr	-1564(ra) # 1a <simpletest>

  threetest();
 63e:	00000097          	auipc	ra,0x0
 642:	adc080e7          	jalr	-1316(ra) # 11a <threetest>
  threetest();
 646:	00000097          	auipc	ra,0x0
 64a:	ad4080e7          	jalr	-1324(ra) # 11a <threetest>
  threetest();
 64e:	00000097          	auipc	ra,0x0
 652:	acc080e7          	jalr	-1332(ra) # 11a <threetest>

  filetest();
 656:	00000097          	auipc	ra,0x0
 65a:	c90080e7          	jalr	-880(ra) # 2e6 <filetest>

  rotest();
 65e:	00000097          	auipc	ra,0x0
 662:	e3e080e7          	jalr	-450(ra) # 49c <rotest>

  printf("ALL COW TESTS PASSED\n");
 666:	00001517          	auipc	a0,0x1
 66a:	9c250513          	addi	a0,a0,-1598 # 1028 <malloc+0x2f0>
 66e:	00000097          	auipc	ra,0x0
 672:	612080e7          	jalr	1554(ra) # c80 <printf>

  exit(0);
 676:	4501                	li	a0,0
 678:	00000097          	auipc	ra,0x0
 67c:	28e080e7          	jalr	654(ra) # 906 <exit>

0000000000000680 <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
 680:	1141                	addi	sp,sp,-16
 682:	e406                	sd	ra,8(sp)
 684:	e022                	sd	s0,0(sp)
 686:	0800                	addi	s0,sp,16
  extern int main();
  main();
 688:	00000097          	auipc	ra,0x0
 68c:	f9e080e7          	jalr	-98(ra) # 626 <main>
  exit(0);
 690:	4501                	li	a0,0
 692:	00000097          	auipc	ra,0x0
 696:	274080e7          	jalr	628(ra) # 906 <exit>

000000000000069a <strcpy>:
}

char *strcpy(char *s, const char *t) {
 69a:	1141                	addi	sp,sp,-16
 69c:	e422                	sd	s0,8(sp)
 69e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0);
 6a0:	87aa                	mv	a5,a0
 6a2:	0585                	addi	a1,a1,1
 6a4:	0785                	addi	a5,a5,1
 6a6:	fff5c703          	lbu	a4,-1(a1)
 6aa:	fee78fa3          	sb	a4,-1(a5)
 6ae:	fb75                	bnez	a4,6a2 <strcpy+0x8>
  return os;
}
 6b0:	6422                	ld	s0,8(sp)
 6b2:	0141                	addi	sp,sp,16
 6b4:	8082                	ret

00000000000006b6 <strcmp>:

int strcmp(const char *p, const char *q) {
 6b6:	1141                	addi	sp,sp,-16
 6b8:	e422                	sd	s0,8(sp)
 6ba:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
 6bc:	00054783          	lbu	a5,0(a0)
 6c0:	cb91                	beqz	a5,6d4 <strcmp+0x1e>
 6c2:	0005c703          	lbu	a4,0(a1)
 6c6:	00f71763          	bne	a4,a5,6d4 <strcmp+0x1e>
 6ca:	0505                	addi	a0,a0,1
 6cc:	0585                	addi	a1,a1,1
 6ce:	00054783          	lbu	a5,0(a0)
 6d2:	fbe5                	bnez	a5,6c2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 6d4:	0005c503          	lbu	a0,0(a1)
}
 6d8:	40a7853b          	subw	a0,a5,a0
 6dc:	6422                	ld	s0,8(sp)
 6de:	0141                	addi	sp,sp,16
 6e0:	8082                	ret

00000000000006e2 <strlen>:

uint strlen(const char *s) {
 6e2:	1141                	addi	sp,sp,-16
 6e4:	e422                	sd	s0,8(sp)
 6e6:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
 6e8:	00054783          	lbu	a5,0(a0)
 6ec:	cf91                	beqz	a5,708 <strlen+0x26>
 6ee:	0505                	addi	a0,a0,1
 6f0:	87aa                	mv	a5,a0
 6f2:	4685                	li	a3,1
 6f4:	9e89                	subw	a3,a3,a0
 6f6:	00f6853b          	addw	a0,a3,a5
 6fa:	0785                	addi	a5,a5,1
 6fc:	fff7c703          	lbu	a4,-1(a5)
 700:	fb7d                	bnez	a4,6f6 <strlen+0x14>
  return n;
}
 702:	6422                	ld	s0,8(sp)
 704:	0141                	addi	sp,sp,16
 706:	8082                	ret
  for (n = 0; s[n]; n++);
 708:	4501                	li	a0,0
 70a:	bfe5                	j	702 <strlen+0x20>

000000000000070c <memset>:

void *memset(void *dst, int c, uint n) {
 70c:	1141                	addi	sp,sp,-16
 70e:	e422                	sd	s0,8(sp)
 710:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 712:	ca19                	beqz	a2,728 <memset+0x1c>
 714:	87aa                	mv	a5,a0
 716:	1602                	slli	a2,a2,0x20
 718:	9201                	srli	a2,a2,0x20
 71a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 71e:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 722:	0785                	addi	a5,a5,1
 724:	fee79de3          	bne	a5,a4,71e <memset+0x12>
  }
  return dst;
}
 728:	6422                	ld	s0,8(sp)
 72a:	0141                	addi	sp,sp,16
 72c:	8082                	ret

000000000000072e <strchr>:

char *strchr(const char *s, char c) {
 72e:	1141                	addi	sp,sp,-16
 730:	e422                	sd	s0,8(sp)
 732:	0800                	addi	s0,sp,16
  for (; *s; s++)
 734:	00054783          	lbu	a5,0(a0)
 738:	cb99                	beqz	a5,74e <strchr+0x20>
    if (*s == c) return (char *)s;
 73a:	00f58763          	beq	a1,a5,748 <strchr+0x1a>
  for (; *s; s++)
 73e:	0505                	addi	a0,a0,1
 740:	00054783          	lbu	a5,0(a0)
 744:	fbfd                	bnez	a5,73a <strchr+0xc>
  return 0;
 746:	4501                	li	a0,0
}
 748:	6422                	ld	s0,8(sp)
 74a:	0141                	addi	sp,sp,16
 74c:	8082                	ret
  return 0;
 74e:	4501                	li	a0,0
 750:	bfe5                	j	748 <strchr+0x1a>

0000000000000752 <gets>:

char *gets(char *buf, int max) {
 752:	711d                	addi	sp,sp,-96
 754:	ec86                	sd	ra,88(sp)
 756:	e8a2                	sd	s0,80(sp)
 758:	e4a6                	sd	s1,72(sp)
 75a:	e0ca                	sd	s2,64(sp)
 75c:	fc4e                	sd	s3,56(sp)
 75e:	f852                	sd	s4,48(sp)
 760:	f456                	sd	s5,40(sp)
 762:	f05a                	sd	s6,32(sp)
 764:	ec5e                	sd	s7,24(sp)
 766:	1080                	addi	s0,sp,96
 768:	8baa                	mv	s7,a0
 76a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 76c:	892a                	mv	s2,a0
 76e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
 770:	4aa9                	li	s5,10
 772:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 774:	89a6                	mv	s3,s1
 776:	2485                	addiw	s1,s1,1
 778:	0344d863          	bge	s1,s4,7a8 <gets+0x56>
    cc = read(0, &c, 1);
 77c:	4605                	li	a2,1
 77e:	faf40593          	addi	a1,s0,-81
 782:	4501                	li	a0,0
 784:	00000097          	auipc	ra,0x0
 788:	19a080e7          	jalr	410(ra) # 91e <read>
    if (cc < 1) break;
 78c:	00a05e63          	blez	a0,7a8 <gets+0x56>
    buf[i++] = c;
 790:	faf44783          	lbu	a5,-81(s0)
 794:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
 798:	01578763          	beq	a5,s5,7a6 <gets+0x54>
 79c:	0905                	addi	s2,s2,1
 79e:	fd679be3          	bne	a5,s6,774 <gets+0x22>
  for (i = 0; i + 1 < max;) {
 7a2:	89a6                	mv	s3,s1
 7a4:	a011                	j	7a8 <gets+0x56>
 7a6:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
 7a8:	99de                	add	s3,s3,s7
 7aa:	00098023          	sb	zero,0(s3) # 199a000 <base+0x1993ff0>
  return buf;
}
 7ae:	855e                	mv	a0,s7
 7b0:	60e6                	ld	ra,88(sp)
 7b2:	6446                	ld	s0,80(sp)
 7b4:	64a6                	ld	s1,72(sp)
 7b6:	6906                	ld	s2,64(sp)
 7b8:	79e2                	ld	s3,56(sp)
 7ba:	7a42                	ld	s4,48(sp)
 7bc:	7aa2                	ld	s5,40(sp)
 7be:	7b02                	ld	s6,32(sp)
 7c0:	6be2                	ld	s7,24(sp)
 7c2:	6125                	addi	sp,sp,96
 7c4:	8082                	ret

00000000000007c6 <stat>:

int stat(const char *n, struct stat *st) {
 7c6:	1101                	addi	sp,sp,-32
 7c8:	ec06                	sd	ra,24(sp)
 7ca:	e822                	sd	s0,16(sp)
 7cc:	e426                	sd	s1,8(sp)
 7ce:	e04a                	sd	s2,0(sp)
 7d0:	1000                	addi	s0,sp,32
 7d2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 7d4:	4581                	li	a1,0
 7d6:	00000097          	auipc	ra,0x0
 7da:	170080e7          	jalr	368(ra) # 946 <open>
  if (fd < 0) return -1;
 7de:	02054563          	bltz	a0,808 <stat+0x42>
 7e2:	84aa                	mv	s1,a0
  r = fstat(fd, st);
 7e4:	85ca                	mv	a1,s2
 7e6:	00000097          	auipc	ra,0x0
 7ea:	178080e7          	jalr	376(ra) # 95e <fstat>
 7ee:	892a                	mv	s2,a0
  close(fd);
 7f0:	8526                	mv	a0,s1
 7f2:	00000097          	auipc	ra,0x0
 7f6:	13c080e7          	jalr	316(ra) # 92e <close>
  return r;
}
 7fa:	854a                	mv	a0,s2
 7fc:	60e2                	ld	ra,24(sp)
 7fe:	6442                	ld	s0,16(sp)
 800:	64a2                	ld	s1,8(sp)
 802:	6902                	ld	s2,0(sp)
 804:	6105                	addi	sp,sp,32
 806:	8082                	ret
  if (fd < 0) return -1;
 808:	597d                	li	s2,-1
 80a:	bfc5                	j	7fa <stat+0x34>

000000000000080c <atoi>:

int atoi(const char *s) {
 80c:	1141                	addi	sp,sp,-16
 80e:	e422                	sd	s0,8(sp)
 810:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 812:	00054683          	lbu	a3,0(a0)
 816:	fd06879b          	addiw	a5,a3,-48 # fd0 <malloc+0x298>
 81a:	0ff7f793          	zext.b	a5,a5
 81e:	4625                	li	a2,9
 820:	02f66863          	bltu	a2,a5,850 <atoi+0x44>
 824:	872a                	mv	a4,a0
  n = 0;
 826:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 828:	0705                	addi	a4,a4,1
 82a:	0025179b          	slliw	a5,a0,0x2
 82e:	9fa9                	addw	a5,a5,a0
 830:	0017979b          	slliw	a5,a5,0x1
 834:	9fb5                	addw	a5,a5,a3
 836:	fd07851b          	addiw	a0,a5,-48
 83a:	00074683          	lbu	a3,0(a4)
 83e:	fd06879b          	addiw	a5,a3,-48
 842:	0ff7f793          	zext.b	a5,a5
 846:	fef671e3          	bgeu	a2,a5,828 <atoi+0x1c>
  return n;
}
 84a:	6422                	ld	s0,8(sp)
 84c:	0141                	addi	sp,sp,16
 84e:	8082                	ret
  n = 0;
 850:	4501                	li	a0,0
 852:	bfe5                	j	84a <atoi+0x3e>

0000000000000854 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
 854:	1141                	addi	sp,sp,-16
 856:	e422                	sd	s0,8(sp)
 858:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 85a:	02b57463          	bgeu	a0,a1,882 <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
 85e:	00c05f63          	blez	a2,87c <memmove+0x28>
 862:	1602                	slli	a2,a2,0x20
 864:	9201                	srli	a2,a2,0x20
 866:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 86a:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
 86c:	0585                	addi	a1,a1,1
 86e:	0705                	addi	a4,a4,1
 870:	fff5c683          	lbu	a3,-1(a1)
 874:	fed70fa3          	sb	a3,-1(a4)
 878:	fee79ae3          	bne	a5,a4,86c <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
 87c:	6422                	ld	s0,8(sp)
 87e:	0141                	addi	sp,sp,16
 880:	8082                	ret
    dst += n;
 882:	00c50733          	add	a4,a0,a2
    src += n;
 886:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
 888:	fec05ae3          	blez	a2,87c <memmove+0x28>
 88c:	fff6079b          	addiw	a5,a2,-1
 890:	1782                	slli	a5,a5,0x20
 892:	9381                	srli	a5,a5,0x20
 894:	fff7c793          	not	a5,a5
 898:	97ba                	add	a5,a5,a4
 89a:	15fd                	addi	a1,a1,-1
 89c:	177d                	addi	a4,a4,-1
 89e:	0005c683          	lbu	a3,0(a1)
 8a2:	00d70023          	sb	a3,0(a4)
 8a6:	fee79ae3          	bne	a5,a4,89a <memmove+0x46>
 8aa:	bfc9                	j	87c <memmove+0x28>

00000000000008ac <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
 8ac:	1141                	addi	sp,sp,-16
 8ae:	e422                	sd	s0,8(sp)
 8b0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 8b2:	ca05                	beqz	a2,8e2 <memcmp+0x36>
 8b4:	fff6069b          	addiw	a3,a2,-1
 8b8:	1682                	slli	a3,a3,0x20
 8ba:	9281                	srli	a3,a3,0x20
 8bc:	0685                	addi	a3,a3,1
 8be:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 8c0:	00054783          	lbu	a5,0(a0)
 8c4:	0005c703          	lbu	a4,0(a1)
 8c8:	00e79863          	bne	a5,a4,8d8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 8cc:	0505                	addi	a0,a0,1
    p2++;
 8ce:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 8d0:	fed518e3          	bne	a0,a3,8c0 <memcmp+0x14>
  }
  return 0;
 8d4:	4501                	li	a0,0
 8d6:	a019                	j	8dc <memcmp+0x30>
      return *p1 - *p2;
 8d8:	40e7853b          	subw	a0,a5,a4
}
 8dc:	6422                	ld	s0,8(sp)
 8de:	0141                	addi	sp,sp,16
 8e0:	8082                	ret
  return 0;
 8e2:	4501                	li	a0,0
 8e4:	bfe5                	j	8dc <memcmp+0x30>

00000000000008e6 <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
 8e6:	1141                	addi	sp,sp,-16
 8e8:	e406                	sd	ra,8(sp)
 8ea:	e022                	sd	s0,0(sp)
 8ec:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 8ee:	00000097          	auipc	ra,0x0
 8f2:	f66080e7          	jalr	-154(ra) # 854 <memmove>
}
 8f6:	60a2                	ld	ra,8(sp)
 8f8:	6402                	ld	s0,0(sp)
 8fa:	0141                	addi	sp,sp,16
 8fc:	8082                	ret

00000000000008fe <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 8fe:	4885                	li	a7,1
 ecall
 900:	00000073          	ecall
 ret
 904:	8082                	ret

0000000000000906 <exit>:
.global exit
exit:
 li a7, SYS_exit
 906:	4889                	li	a7,2
 ecall
 908:	00000073          	ecall
 ret
 90c:	8082                	ret

000000000000090e <wait>:
.global wait
wait:
 li a7, SYS_wait
 90e:	488d                	li	a7,3
 ecall
 910:	00000073          	ecall
 ret
 914:	8082                	ret

0000000000000916 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 916:	4891                	li	a7,4
 ecall
 918:	00000073          	ecall
 ret
 91c:	8082                	ret

000000000000091e <read>:
.global read
read:
 li a7, SYS_read
 91e:	4895                	li	a7,5
 ecall
 920:	00000073          	ecall
 ret
 924:	8082                	ret

0000000000000926 <write>:
.global write
write:
 li a7, SYS_write
 926:	48c1                	li	a7,16
 ecall
 928:	00000073          	ecall
 ret
 92c:	8082                	ret

000000000000092e <close>:
.global close
close:
 li a7, SYS_close
 92e:	48d5                	li	a7,21
 ecall
 930:	00000073          	ecall
 ret
 934:	8082                	ret

0000000000000936 <kill>:
.global kill
kill:
 li a7, SYS_kill
 936:	4899                	li	a7,6
 ecall
 938:	00000073          	ecall
 ret
 93c:	8082                	ret

000000000000093e <exec>:
.global exec
exec:
 li a7, SYS_exec
 93e:	489d                	li	a7,7
 ecall
 940:	00000073          	ecall
 ret
 944:	8082                	ret

0000000000000946 <open>:
.global open
open:
 li a7, SYS_open
 946:	48bd                	li	a7,15
 ecall
 948:	00000073          	ecall
 ret
 94c:	8082                	ret

000000000000094e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 94e:	48c5                	li	a7,17
 ecall
 950:	00000073          	ecall
 ret
 954:	8082                	ret

0000000000000956 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 956:	48c9                	li	a7,18
 ecall
 958:	00000073          	ecall
 ret
 95c:	8082                	ret

000000000000095e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 95e:	48a1                	li	a7,8
 ecall
 960:	00000073          	ecall
 ret
 964:	8082                	ret

0000000000000966 <link>:
.global link
link:
 li a7, SYS_link
 966:	48cd                	li	a7,19
 ecall
 968:	00000073          	ecall
 ret
 96c:	8082                	ret

000000000000096e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 96e:	48d1                	li	a7,20
 ecall
 970:	00000073          	ecall
 ret
 974:	8082                	ret

0000000000000976 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 976:	48a5                	li	a7,9
 ecall
 978:	00000073          	ecall
 ret
 97c:	8082                	ret

000000000000097e <dup>:
.global dup
dup:
 li a7, SYS_dup
 97e:	48a9                	li	a7,10
 ecall
 980:	00000073          	ecall
 ret
 984:	8082                	ret

0000000000000986 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 986:	48ad                	li	a7,11
 ecall
 988:	00000073          	ecall
 ret
 98c:	8082                	ret

000000000000098e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 98e:	48b1                	li	a7,12
 ecall
 990:	00000073          	ecall
 ret
 994:	8082                	ret

0000000000000996 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 996:	48b5                	li	a7,13
 ecall
 998:	00000073          	ecall
 ret
 99c:	8082                	ret

000000000000099e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 99e:	48b9                	li	a7,14
 ecall
 9a0:	00000073          	ecall
 ret
 9a4:	8082                	ret

00000000000009a6 <putc>:
#include "kernel/types.h"
#include "user/user.h"

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 9a6:	1101                	addi	sp,sp,-32
 9a8:	ec06                	sd	ra,24(sp)
 9aa:	e822                	sd	s0,16(sp)
 9ac:	1000                	addi	s0,sp,32
 9ae:	feb407a3          	sb	a1,-17(s0)
 9b2:	4605                	li	a2,1
 9b4:	fef40593          	addi	a1,s0,-17
 9b8:	00000097          	auipc	ra,0x0
 9bc:	f6e080e7          	jalr	-146(ra) # 926 <write>
 9c0:	60e2                	ld	ra,24(sp)
 9c2:	6442                	ld	s0,16(sp)
 9c4:	6105                	addi	sp,sp,32
 9c6:	8082                	ret

00000000000009c8 <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 9c8:	7139                	addi	sp,sp,-64
 9ca:	fc06                	sd	ra,56(sp)
 9cc:	f822                	sd	s0,48(sp)
 9ce:	f426                	sd	s1,40(sp)
 9d0:	f04a                	sd	s2,32(sp)
 9d2:	ec4e                	sd	s3,24(sp)
 9d4:	0080                	addi	s0,sp,64
 9d6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
 9d8:	c299                	beqz	a3,9de <printint+0x16>
 9da:	0805c963          	bltz	a1,a6c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 9de:	2581                	sext.w	a1,a1
  neg = 0;
 9e0:	4881                	li	a7,0
 9e2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 9e6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 9e8:	2601                	sext.w	a2,a2
 9ea:	00000517          	auipc	a0,0x0
 9ee:	6c650513          	addi	a0,a0,1734 # 10b0 <digits>
 9f2:	883a                	mv	a6,a4
 9f4:	2705                	addiw	a4,a4,1
 9f6:	02c5f7bb          	remuw	a5,a1,a2
 9fa:	1782                	slli	a5,a5,0x20
 9fc:	9381                	srli	a5,a5,0x20
 9fe:	97aa                	add	a5,a5,a0
 a00:	0007c783          	lbu	a5,0(a5)
 a04:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 a08:	0005879b          	sext.w	a5,a1
 a0c:	02c5d5bb          	divuw	a1,a1,a2
 a10:	0685                	addi	a3,a3,1
 a12:	fec7f0e3          	bgeu	a5,a2,9f2 <printint+0x2a>
  if (neg) buf[i++] = '-';
 a16:	00088c63          	beqz	a7,a2e <printint+0x66>
 a1a:	fd070793          	addi	a5,a4,-48
 a1e:	00878733          	add	a4,a5,s0
 a22:	02d00793          	li	a5,45
 a26:	fef70823          	sb	a5,-16(a4)
 a2a:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
 a2e:	02e05863          	blez	a4,a5e <printint+0x96>
 a32:	fc040793          	addi	a5,s0,-64
 a36:	00e78933          	add	s2,a5,a4
 a3a:	fff78993          	addi	s3,a5,-1
 a3e:	99ba                	add	s3,s3,a4
 a40:	377d                	addiw	a4,a4,-1
 a42:	1702                	slli	a4,a4,0x20
 a44:	9301                	srli	a4,a4,0x20
 a46:	40e989b3          	sub	s3,s3,a4
 a4a:	fff94583          	lbu	a1,-1(s2)
 a4e:	8526                	mv	a0,s1
 a50:	00000097          	auipc	ra,0x0
 a54:	f56080e7          	jalr	-170(ra) # 9a6 <putc>
 a58:	197d                	addi	s2,s2,-1
 a5a:	ff3918e3          	bne	s2,s3,a4a <printint+0x82>
}
 a5e:	70e2                	ld	ra,56(sp)
 a60:	7442                	ld	s0,48(sp)
 a62:	74a2                	ld	s1,40(sp)
 a64:	7902                	ld	s2,32(sp)
 a66:	69e2                	ld	s3,24(sp)
 a68:	6121                	addi	sp,sp,64
 a6a:	8082                	ret
    x = -xx;
 a6c:	40b005bb          	negw	a1,a1
    neg = 1;
 a70:	4885                	li	a7,1
    x = -xx;
 a72:	bf85                	j	9e2 <printint+0x1a>

0000000000000a74 <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
 a74:	7119                	addi	sp,sp,-128
 a76:	fc86                	sd	ra,120(sp)
 a78:	f8a2                	sd	s0,112(sp)
 a7a:	f4a6                	sd	s1,104(sp)
 a7c:	f0ca                	sd	s2,96(sp)
 a7e:	ecce                	sd	s3,88(sp)
 a80:	e8d2                	sd	s4,80(sp)
 a82:	e4d6                	sd	s5,72(sp)
 a84:	e0da                	sd	s6,64(sp)
 a86:	fc5e                	sd	s7,56(sp)
 a88:	f862                	sd	s8,48(sp)
 a8a:	f466                	sd	s9,40(sp)
 a8c:	f06a                	sd	s10,32(sp)
 a8e:	ec6e                	sd	s11,24(sp)
 a90:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 a92:	0005c903          	lbu	s2,0(a1)
 a96:	18090f63          	beqz	s2,c34 <vprintf+0x1c0>
 a9a:	8aaa                	mv	s5,a0
 a9c:	8b32                	mv	s6,a2
 a9e:	00158493          	addi	s1,a1,1
  state = 0;
 aa2:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
 aa4:	02500a13          	li	s4,37
 aa8:	4c55                	li	s8,21
 aaa:	00000c97          	auipc	s9,0x0
 aae:	5aec8c93          	addi	s9,s9,1454 # 1058 <HACK+0x18>
      } else if (c == 'p') {
        printptr(fd, va_arg(ap, uint64));
      } else if (c == 's') {
        s = va_arg(ap, char *);
        if (s == 0) s = "(null)";
        while (*s != 0) {
 ab2:	02800d93          	li	s11,40
  putc(fd, 'x');
 ab6:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 ab8:	00000b97          	auipc	s7,0x0
 abc:	5f8b8b93          	addi	s7,s7,1528 # 10b0 <digits>
 ac0:	a839                	j	ade <vprintf+0x6a>
        putc(fd, c);
 ac2:	85ca                	mv	a1,s2
 ac4:	8556                	mv	a0,s5
 ac6:	00000097          	auipc	ra,0x0
 aca:	ee0080e7          	jalr	-288(ra) # 9a6 <putc>
 ace:	a019                	j	ad4 <vprintf+0x60>
    } else if (state == '%') {
 ad0:	01498d63          	beq	s3,s4,aea <vprintf+0x76>
  for (i = 0; fmt[i]; i++) {
 ad4:	0485                	addi	s1,s1,1
 ad6:	fff4c903          	lbu	s2,-1(s1)
 ada:	14090d63          	beqz	s2,c34 <vprintf+0x1c0>
    if (state == 0) {
 ade:	fe0999e3          	bnez	s3,ad0 <vprintf+0x5c>
      if (c == '%') {
 ae2:	ff4910e3          	bne	s2,s4,ac2 <vprintf+0x4e>
        state = '%';
 ae6:	89d2                	mv	s3,s4
 ae8:	b7f5                	j	ad4 <vprintf+0x60>
      if (c == 'd') {
 aea:	11490c63          	beq	s2,s4,c02 <vprintf+0x18e>
 aee:	f9d9079b          	addiw	a5,s2,-99
 af2:	0ff7f793          	zext.b	a5,a5
 af6:	10fc6e63          	bltu	s8,a5,c12 <vprintf+0x19e>
 afa:	f9d9079b          	addiw	a5,s2,-99
 afe:	0ff7f713          	zext.b	a4,a5
 b02:	10ec6863          	bltu	s8,a4,c12 <vprintf+0x19e>
 b06:	00271793          	slli	a5,a4,0x2
 b0a:	97e6                	add	a5,a5,s9
 b0c:	439c                	lw	a5,0(a5)
 b0e:	97e6                	add	a5,a5,s9
 b10:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 b12:	008b0913          	addi	s2,s6,8
 b16:	4685                	li	a3,1
 b18:	4629                	li	a2,10
 b1a:	000b2583          	lw	a1,0(s6)
 b1e:	8556                	mv	a0,s5
 b20:	00000097          	auipc	ra,0x0
 b24:	ea8080e7          	jalr	-344(ra) # 9c8 <printint>
 b28:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 b2a:	4981                	li	s3,0
 b2c:	b765                	j	ad4 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b2e:	008b0913          	addi	s2,s6,8
 b32:	4681                	li	a3,0
 b34:	4629                	li	a2,10
 b36:	000b2583          	lw	a1,0(s6)
 b3a:	8556                	mv	a0,s5
 b3c:	00000097          	auipc	ra,0x0
 b40:	e8c080e7          	jalr	-372(ra) # 9c8 <printint>
 b44:	8b4a                	mv	s6,s2
      state = 0;
 b46:	4981                	li	s3,0
 b48:	b771                	j	ad4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 b4a:	008b0913          	addi	s2,s6,8
 b4e:	4681                	li	a3,0
 b50:	866a                	mv	a2,s10
 b52:	000b2583          	lw	a1,0(s6)
 b56:	8556                	mv	a0,s5
 b58:	00000097          	auipc	ra,0x0
 b5c:	e70080e7          	jalr	-400(ra) # 9c8 <printint>
 b60:	8b4a                	mv	s6,s2
      state = 0;
 b62:	4981                	li	s3,0
 b64:	bf85                	j	ad4 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 b66:	008b0793          	addi	a5,s6,8
 b6a:	f8f43423          	sd	a5,-120(s0)
 b6e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 b72:	03000593          	li	a1,48
 b76:	8556                	mv	a0,s5
 b78:	00000097          	auipc	ra,0x0
 b7c:	e2e080e7          	jalr	-466(ra) # 9a6 <putc>
  putc(fd, 'x');
 b80:	07800593          	li	a1,120
 b84:	8556                	mv	a0,s5
 b86:	00000097          	auipc	ra,0x0
 b8a:	e20080e7          	jalr	-480(ra) # 9a6 <putc>
 b8e:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 b90:	03c9d793          	srli	a5,s3,0x3c
 b94:	97de                	add	a5,a5,s7
 b96:	0007c583          	lbu	a1,0(a5)
 b9a:	8556                	mv	a0,s5
 b9c:	00000097          	auipc	ra,0x0
 ba0:	e0a080e7          	jalr	-502(ra) # 9a6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 ba4:	0992                	slli	s3,s3,0x4
 ba6:	397d                	addiw	s2,s2,-1
 ba8:	fe0914e3          	bnez	s2,b90 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 bac:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 bb0:	4981                	li	s3,0
 bb2:	b70d                	j	ad4 <vprintf+0x60>
        s = va_arg(ap, char *);
 bb4:	008b0913          	addi	s2,s6,8
 bb8:	000b3983          	ld	s3,0(s6)
        if (s == 0) s = "(null)";
 bbc:	02098163          	beqz	s3,bde <vprintf+0x16a>
        while (*s != 0) {
 bc0:	0009c583          	lbu	a1,0(s3)
 bc4:	c5ad                	beqz	a1,c2e <vprintf+0x1ba>
          putc(fd, *s);
 bc6:	8556                	mv	a0,s5
 bc8:	00000097          	auipc	ra,0x0
 bcc:	dde080e7          	jalr	-546(ra) # 9a6 <putc>
          s++;
 bd0:	0985                	addi	s3,s3,1
        while (*s != 0) {
 bd2:	0009c583          	lbu	a1,0(s3)
 bd6:	f9e5                	bnez	a1,bc6 <vprintf+0x152>
        s = va_arg(ap, char *);
 bd8:	8b4a                	mv	s6,s2
      state = 0;
 bda:	4981                	li	s3,0
 bdc:	bde5                	j	ad4 <vprintf+0x60>
        if (s == 0) s = "(null)";
 bde:	00000997          	auipc	s3,0x0
 be2:	47298993          	addi	s3,s3,1138 # 1050 <HACK+0x10>
        while (*s != 0) {
 be6:	85ee                	mv	a1,s11
 be8:	bff9                	j	bc6 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 bea:	008b0913          	addi	s2,s6,8
 bee:	000b4583          	lbu	a1,0(s6)
 bf2:	8556                	mv	a0,s5
 bf4:	00000097          	auipc	ra,0x0
 bf8:	db2080e7          	jalr	-590(ra) # 9a6 <putc>
 bfc:	8b4a                	mv	s6,s2
      state = 0;
 bfe:	4981                	li	s3,0
 c00:	bdd1                	j	ad4 <vprintf+0x60>
        putc(fd, c);
 c02:	85d2                	mv	a1,s4
 c04:	8556                	mv	a0,s5
 c06:	00000097          	auipc	ra,0x0
 c0a:	da0080e7          	jalr	-608(ra) # 9a6 <putc>
      state = 0;
 c0e:	4981                	li	s3,0
 c10:	b5d1                	j	ad4 <vprintf+0x60>
        putc(fd, '%');
 c12:	85d2                	mv	a1,s4
 c14:	8556                	mv	a0,s5
 c16:	00000097          	auipc	ra,0x0
 c1a:	d90080e7          	jalr	-624(ra) # 9a6 <putc>
        putc(fd, c);
 c1e:	85ca                	mv	a1,s2
 c20:	8556                	mv	a0,s5
 c22:	00000097          	auipc	ra,0x0
 c26:	d84080e7          	jalr	-636(ra) # 9a6 <putc>
      state = 0;
 c2a:	4981                	li	s3,0
 c2c:	b565                	j	ad4 <vprintf+0x60>
        s = va_arg(ap, char *);
 c2e:	8b4a                	mv	s6,s2
      state = 0;
 c30:	4981                	li	s3,0
 c32:	b54d                	j	ad4 <vprintf+0x60>
    }
  }
}
 c34:	70e6                	ld	ra,120(sp)
 c36:	7446                	ld	s0,112(sp)
 c38:	74a6                	ld	s1,104(sp)
 c3a:	7906                	ld	s2,96(sp)
 c3c:	69e6                	ld	s3,88(sp)
 c3e:	6a46                	ld	s4,80(sp)
 c40:	6aa6                	ld	s5,72(sp)
 c42:	6b06                	ld	s6,64(sp)
 c44:	7be2                	ld	s7,56(sp)
 c46:	7c42                	ld	s8,48(sp)
 c48:	7ca2                	ld	s9,40(sp)
 c4a:	7d02                	ld	s10,32(sp)
 c4c:	6de2                	ld	s11,24(sp)
 c4e:	6109                	addi	sp,sp,128
 c50:	8082                	ret

0000000000000c52 <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
 c52:	715d                	addi	sp,sp,-80
 c54:	ec06                	sd	ra,24(sp)
 c56:	e822                	sd	s0,16(sp)
 c58:	1000                	addi	s0,sp,32
 c5a:	e010                	sd	a2,0(s0)
 c5c:	e414                	sd	a3,8(s0)
 c5e:	e818                	sd	a4,16(s0)
 c60:	ec1c                	sd	a5,24(s0)
 c62:	03043023          	sd	a6,32(s0)
 c66:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 c6a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 c6e:	8622                	mv	a2,s0
 c70:	00000097          	auipc	ra,0x0
 c74:	e04080e7          	jalr	-508(ra) # a74 <vprintf>
}
 c78:	60e2                	ld	ra,24(sp)
 c7a:	6442                	ld	s0,16(sp)
 c7c:	6161                	addi	sp,sp,80
 c7e:	8082                	ret

0000000000000c80 <printf>:

void printf(const char *fmt, ...) {
 c80:	711d                	addi	sp,sp,-96
 c82:	ec06                	sd	ra,24(sp)
 c84:	e822                	sd	s0,16(sp)
 c86:	1000                	addi	s0,sp,32
 c88:	e40c                	sd	a1,8(s0)
 c8a:	e810                	sd	a2,16(s0)
 c8c:	ec14                	sd	a3,24(s0)
 c8e:	f018                	sd	a4,32(s0)
 c90:	f41c                	sd	a5,40(s0)
 c92:	03043823          	sd	a6,48(s0)
 c96:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 c9a:	00840613          	addi	a2,s0,8
 c9e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ca2:	85aa                	mv	a1,a0
 ca4:	4505                	li	a0,1
 ca6:	00000097          	auipc	ra,0x0
 caa:	dce080e7          	jalr	-562(ra) # a74 <vprintf>
}
 cae:	60e2                	ld	ra,24(sp)
 cb0:	6442                	ld	s0,16(sp)
 cb2:	6125                	addi	sp,sp,96
 cb4:	8082                	ret

0000000000000cb6 <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 cb6:	1141                	addi	sp,sp,-16
 cb8:	e422                	sd	s0,8(sp)
 cba:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 cbc:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cc0:	00001797          	auipc	a5,0x1
 cc4:	3487b783          	ld	a5,840(a5) # 2008 <freep>
 cc8:	a02d                	j	cf2 <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 cca:	4618                	lw	a4,8(a2)
 ccc:	9f2d                	addw	a4,a4,a1
 cce:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 cd2:	6398                	ld	a4,0(a5)
 cd4:	6310                	ld	a2,0(a4)
 cd6:	a83d                	j	d14 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 cd8:	ff852703          	lw	a4,-8(a0)
 cdc:	9f31                	addw	a4,a4,a2
 cde:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 ce0:	ff053683          	ld	a3,-16(a0)
 ce4:	a091                	j	d28 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 ce6:	6398                	ld	a4,0(a5)
 ce8:	00e7e463          	bltu	a5,a4,cf0 <free+0x3a>
 cec:	00e6ea63          	bltu	a3,a4,d00 <free+0x4a>
void free(void *ap) {
 cf0:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cf2:	fed7fae3          	bgeu	a5,a3,ce6 <free+0x30>
 cf6:	6398                	ld	a4,0(a5)
 cf8:	00e6e463          	bltu	a3,a4,d00 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 cfc:	fee7eae3          	bltu	a5,a4,cf0 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 d00:	ff852583          	lw	a1,-8(a0)
 d04:	6390                	ld	a2,0(a5)
 d06:	02059813          	slli	a6,a1,0x20
 d0a:	01c85713          	srli	a4,a6,0x1c
 d0e:	9736                	add	a4,a4,a3
 d10:	fae60de3          	beq	a2,a4,cca <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 d14:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 d18:	4790                	lw	a2,8(a5)
 d1a:	02061593          	slli	a1,a2,0x20
 d1e:	01c5d713          	srli	a4,a1,0x1c
 d22:	973e                	add	a4,a4,a5
 d24:	fae68ae3          	beq	a3,a4,cd8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 d28:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 d2a:	00001717          	auipc	a4,0x1
 d2e:	2cf73f23          	sd	a5,734(a4) # 2008 <freep>
}
 d32:	6422                	ld	s0,8(sp)
 d34:	0141                	addi	sp,sp,16
 d36:	8082                	ret

0000000000000d38 <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
 d38:	7139                	addi	sp,sp,-64
 d3a:	fc06                	sd	ra,56(sp)
 d3c:	f822                	sd	s0,48(sp)
 d3e:	f426                	sd	s1,40(sp)
 d40:	f04a                	sd	s2,32(sp)
 d42:	ec4e                	sd	s3,24(sp)
 d44:	e852                	sd	s4,16(sp)
 d46:	e456                	sd	s5,8(sp)
 d48:	e05a                	sd	s6,0(sp)
 d4a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 d4c:	02051493          	slli	s1,a0,0x20
 d50:	9081                	srli	s1,s1,0x20
 d52:	04bd                	addi	s1,s1,15
 d54:	8091                	srli	s1,s1,0x4
 d56:	0014899b          	addiw	s3,s1,1
 d5a:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 d5c:	00001517          	auipc	a0,0x1
 d60:	2ac53503          	ld	a0,684(a0) # 2008 <freep>
 d64:	c515                	beqz	a0,d90 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 d66:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 d68:	4798                	lw	a4,8(a5)
 d6a:	02977f63          	bgeu	a4,s1,da8 <malloc+0x70>
 d6e:	8a4e                	mv	s4,s3
 d70:	0009871b          	sext.w	a4,s3
 d74:	6685                	lui	a3,0x1
 d76:	00d77363          	bgeu	a4,a3,d7c <malloc+0x44>
 d7a:	6a05                	lui	s4,0x1
 d7c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 d80:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 d84:	00001917          	auipc	s2,0x1
 d88:	28490913          	addi	s2,s2,644 # 2008 <freep>
  if (p == (char *)-1) return 0;
 d8c:	5afd                	li	s5,-1
 d8e:	a895                	j	e02 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 d90:	00005797          	auipc	a5,0x5
 d94:	28078793          	addi	a5,a5,640 # 6010 <base>
 d98:	00001717          	auipc	a4,0x1
 d9c:	26f73823          	sd	a5,624(a4) # 2008 <freep>
 da0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 da2:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 da6:	b7e1                	j	d6e <malloc+0x36>
      if (p->s.size == nunits)
 da8:	02e48c63          	beq	s1,a4,de0 <malloc+0xa8>
        p->s.size -= nunits;
 dac:	4137073b          	subw	a4,a4,s3
 db0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 db2:	02071693          	slli	a3,a4,0x20
 db6:	01c6d713          	srli	a4,a3,0x1c
 dba:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 dbc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 dc0:	00001717          	auipc	a4,0x1
 dc4:	24a73423          	sd	a0,584(a4) # 2008 <freep>
      return (void *)(p + 1);
 dc8:	01078513          	addi	a0,a5,16
      if ((p = morecore(nunits)) == 0) return 0;
  }
}
 dcc:	70e2                	ld	ra,56(sp)
 dce:	7442                	ld	s0,48(sp)
 dd0:	74a2                	ld	s1,40(sp)
 dd2:	7902                	ld	s2,32(sp)
 dd4:	69e2                	ld	s3,24(sp)
 dd6:	6a42                	ld	s4,16(sp)
 dd8:	6aa2                	ld	s5,8(sp)
 dda:	6b02                	ld	s6,0(sp)
 ddc:	6121                	addi	sp,sp,64
 dde:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 de0:	6398                	ld	a4,0(a5)
 de2:	e118                	sd	a4,0(a0)
 de4:	bff1                	j	dc0 <malloc+0x88>
  hp->s.size = nu;
 de6:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 dea:	0541                	addi	a0,a0,16
 dec:	00000097          	auipc	ra,0x0
 df0:	eca080e7          	jalr	-310(ra) # cb6 <free>
  return freep;
 df4:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
 df8:	d971                	beqz	a0,dcc <malloc+0x94>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 dfa:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 dfc:	4798                	lw	a4,8(a5)
 dfe:	fa9775e3          	bgeu	a4,s1,da8 <malloc+0x70>
    if (p == freep)
 e02:	00093703          	ld	a4,0(s2)
 e06:	853e                	mv	a0,a5
 e08:	fef719e3          	bne	a4,a5,dfa <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 e0c:	8552                	mv	a0,s4
 e0e:	00000097          	auipc	ra,0x0
 e12:	b80080e7          	jalr	-1152(ra) # 98e <sbrk>
  if (p == (char *)-1) return 0;
 e16:	fd5518e3          	bne	a0,s5,de6 <malloc+0xae>
      if ((p = morecore(nunits)) == 0) return 0;
 e1a:	4501                	li	a0,0
 e1c:	bf45                	j	dcc <malloc+0x94>
