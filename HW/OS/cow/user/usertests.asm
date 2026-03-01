
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
    close(fds[1]);
  }
}

// what if you pass ridiculous string pointers to system calls?
void copyinstr1(char *s) {
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = {0x80000000LL, 0xffffffffffffffff};

  for (int ai = 0; ai < 2; ai++) {
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE | O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	c4a080e7          	jalr	-950(ra) # 5c5a <open>
    if (fd >= 0) {
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE | O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	c38080e7          	jalr	-968(ra) # 5c5a <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if (fd >= 0) {
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	10250513          	addi	a0,a0,258 # 6140 <malloc+0xf4>
      46:	00006097          	auipc	ra,0x6
      4a:	f4e080e7          	jalr	-178(ra) # 5f94 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	bca080e7          	jalr	-1078(ra) # 5c1a <exit>

0000000000000058 <bsstest>:
// does uninitialized data start out zero?
char uninit[10000];
void bsstest(char *s) {
  int i;

  for (i = 0; i < sizeof(uninit); i++) {
      58:	0000a797          	auipc	a5,0xa
      5c:	51078793          	addi	a5,a5,1296 # a568 <uninit>
      60:	0000d697          	auipc	a3,0xd
      64:	c1868693          	addi	a3,a3,-1000 # cc78 <buf>
    if (uninit[i] != '\0') {
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for (i = 0; i < sizeof(uninit); i++) {
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
void bsstest(char *s) {
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	0e050513          	addi	a0,a0,224 # 6160 <malloc+0x114>
      88:	00006097          	auipc	ra,0x6
      8c:	f0c080e7          	jalr	-244(ra) # 5f94 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	b88080e7          	jalr	-1144(ra) # 5c1a <exit>

000000000000009a <opentest>:
void opentest(char *s) {
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	0d050513          	addi	a0,a0,208 # 6178 <malloc+0x12c>
      b0:	00006097          	auipc	ra,0x6
      b4:	baa080e7          	jalr	-1110(ra) # 5c5a <open>
  if (fd < 0) {
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	b86080e7          	jalr	-1146(ra) # 5c42 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	0d250513          	addi	a0,a0,210 # 6198 <malloc+0x14c>
      ce:	00006097          	auipc	ra,0x6
      d2:	b8c080e7          	jalr	-1140(ra) # 5c5a <open>
  if (fd >= 0) {
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	09a50513          	addi	a0,a0,154 # 6180 <malloc+0x134>
      ee:	00006097          	auipc	ra,0x6
      f2:	ea6080e7          	jalr	-346(ra) # 5f94 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00006097          	auipc	ra,0x6
      fc:	b22080e7          	jalr	-1246(ra) # 5c1a <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	0a650513          	addi	a0,a0,166 # 61a8 <malloc+0x15c>
     10a:	00006097          	auipc	ra,0x6
     10e:	e8a080e7          	jalr	-374(ra) # 5f94 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00006097          	auipc	ra,0x6
     118:	b06080e7          	jalr	-1274(ra) # 5c1a <exit>

000000000000011c <truncate2>:
void truncate2(char *s) {
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	0a450513          	addi	a0,a0,164 # 61d0 <malloc+0x184>
     134:	00006097          	auipc	ra,0x6
     138:	b36080e7          	jalr	-1226(ra) # 5c6a <unlink>
  int fd1 = open("truncfile", O_CREATE | O_TRUNC | O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	09050513          	addi	a0,a0,144 # 61d0 <malloc+0x184>
     148:	00006097          	auipc	ra,0x6
     14c:	b12080e7          	jalr	-1262(ra) # 5c5a <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	08c58593          	addi	a1,a1,140 # 61e0 <malloc+0x194>
     15c:	00006097          	auipc	ra,0x6
     160:	ade080e7          	jalr	-1314(ra) # 5c3a <write>
  int fd2 = open("truncfile", O_TRUNC | O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	06850513          	addi	a0,a0,104 # 61d0 <malloc+0x184>
     170:	00006097          	auipc	ra,0x6
     174:	aea080e7          	jalr	-1302(ra) # 5c5a <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	06c58593          	addi	a1,a1,108 # 61e8 <malloc+0x19c>
     184:	8526                	mv	a0,s1
     186:	00006097          	auipc	ra,0x6
     18a:	ab4080e7          	jalr	-1356(ra) # 5c3a <write>
  if (n != -1) {
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	03c50513          	addi	a0,a0,60 # 61d0 <malloc+0x184>
     19c:	00006097          	auipc	ra,0x6
     1a0:	ace080e7          	jalr	-1330(ra) # 5c6a <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	a9c080e7          	jalr	-1380(ra) # 5c42 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00006097          	auipc	ra,0x6
     1b4:	a92080e7          	jalr	-1390(ra) # 5c42 <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	02650513          	addi	a0,a0,38 # 61f0 <malloc+0x1a4>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	dc2080e7          	jalr	-574(ra) # 5f94 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00006097          	auipc	ra,0x6
     1e0:	a3e080e7          	jalr	-1474(ra) # 5c1a <exit>

00000000000001e4 <createtest>:
void createtest(char *s) {
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for (i = 0; i < N; i++) {
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE | O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00006097          	auipc	ra,0x6
     214:	a4a080e7          	jalr	-1462(ra) # 5c5a <open>
    close(fd);
     218:	00006097          	auipc	ra,0x6
     21c:	a2a080e7          	jalr	-1494(ra) # 5c42 <close>
  for (i = 0; i < N; i++) {
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	zext.b	s1,s1
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for (i = 0; i < N; i++) {
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00006097          	auipc	ra,0x6
     24a:	a24080e7          	jalr	-1500(ra) # 5c6a <unlink>
  for (i = 0; i < N; i++) {
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	zext.b	s1,s1
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
void bigwrite(char *s) {
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	f9c50513          	addi	a0,a0,-100 # 6218 <malloc+0x1cc>
     284:	00006097          	auipc	ra,0x6
     288:	9e6080e7          	jalr	-1562(ra) # 5c6a <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	f88a8a93          	addi	s5,s5,-120 # 6218 <malloc+0x1cc>
      int cc = write(fd, buf, sz);
     298:	0000da17          	auipc	s4,0xd
     29c:	9e0a0a13          	addi	s4,s4,-1568 # cc78 <buf>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <fourteen+0x1a3>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00006097          	auipc	ra,0x6
     2b0:	9ae080e7          	jalr	-1618(ra) # 5c5a <open>
     2b4:	892a                	mv	s2,a0
    if (fd < 0) {
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00006097          	auipc	ra,0x6
     2c2:	97c080e7          	jalr	-1668(ra) # 5c3a <write>
     2c6:	89aa                	mv	s3,a0
      if (cc != sz) {
     2c8:	06a49263          	bne	s1,a0,32c <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00006097          	auipc	ra,0x6
     2d6:	968080e7          	jalr	-1688(ra) # 5c3a <write>
      if (cc != sz) {
     2da:	04951a63          	bne	a0,s1,32e <bigwrite+0xca>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00006097          	auipc	ra,0x6
     2e4:	962080e7          	jalr	-1694(ra) # 5c42 <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00006097          	auipc	ra,0x6
     2ee:	980080e7          	jalr	-1664(ra) # 5c6a <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	f1650513          	addi	a0,a0,-234 # 6228 <malloc+0x1dc>
     31a:	00006097          	auipc	ra,0x6
     31e:	c7a080e7          	jalr	-902(ra) # 5f94 <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00006097          	auipc	ra,0x6
     328:	8f6080e7          	jalr	-1802(ra) # 5c1a <exit>
      if (cc != sz) {
     32c:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     32e:	86aa                	mv	a3,a0
     330:	864e                	mv	a2,s3
     332:	85de                	mv	a1,s7
     334:	00006517          	auipc	a0,0x6
     338:	f1450513          	addi	a0,a0,-236 # 6248 <malloc+0x1fc>
     33c:	00006097          	auipc	ra,0x6
     340:	c58080e7          	jalr	-936(ra) # 5f94 <printf>
        exit(1);
     344:	4505                	li	a0,1
     346:	00006097          	auipc	ra,0x6
     34a:	8d4080e7          	jalr	-1836(ra) # 5c1a <exit>

000000000000034e <badwrite>:
// regression test. does write() with an invalid buffer pointer cause
// a block to be allocated for a file that is then not freed when the
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void badwrite(char *s) {
     34e:	7179                	addi	sp,sp,-48
     350:	f406                	sd	ra,40(sp)
     352:	f022                	sd	s0,32(sp)
     354:	ec26                	sd	s1,24(sp)
     356:	e84a                	sd	s2,16(sp)
     358:	e44e                	sd	s3,8(sp)
     35a:	e052                	sd	s4,0(sp)
     35c:	1800                	addi	s0,sp,48
  int assumed_free = 600;

  unlink("junk");
     35e:	00006517          	auipc	a0,0x6
     362:	f0250513          	addi	a0,a0,-254 # 6260 <malloc+0x214>
     366:	00006097          	auipc	ra,0x6
     36a:	904080e7          	jalr	-1788(ra) # 5c6a <unlink>
     36e:	25800913          	li	s2,600
  for (int i = 0; i < assumed_free; i++) {
    int fd = open("junk", O_CREATE | O_WRONLY);
     372:	00006997          	auipc	s3,0x6
     376:	eee98993          	addi	s3,s3,-274 # 6260 <malloc+0x214>
    if (fd < 0) {
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char *)0xffffffffffL, 1);
     37a:	5a7d                	li	s4,-1
     37c:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE | O_WRONLY);
     380:	20100593          	li	a1,513
     384:	854e                	mv	a0,s3
     386:	00006097          	auipc	ra,0x6
     38a:	8d4080e7          	jalr	-1836(ra) # 5c5a <open>
     38e:	84aa                	mv	s1,a0
    if (fd < 0) {
     390:	06054b63          	bltz	a0,406 <badwrite+0xb8>
    write(fd, (char *)0xffffffffffL, 1);
     394:	4605                	li	a2,1
     396:	85d2                	mv	a1,s4
     398:	00006097          	auipc	ra,0x6
     39c:	8a2080e7          	jalr	-1886(ra) # 5c3a <write>
    close(fd);
     3a0:	8526                	mv	a0,s1
     3a2:	00006097          	auipc	ra,0x6
     3a6:	8a0080e7          	jalr	-1888(ra) # 5c42 <close>
    unlink("junk");
     3aa:	854e                	mv	a0,s3
     3ac:	00006097          	auipc	ra,0x6
     3b0:	8be080e7          	jalr	-1858(ra) # 5c6a <unlink>
  for (int i = 0; i < assumed_free; i++) {
     3b4:	397d                	addiw	s2,s2,-1
     3b6:	fc0915e3          	bnez	s2,380 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE | O_WRONLY);
     3ba:	20100593          	li	a1,513
     3be:	00006517          	auipc	a0,0x6
     3c2:	ea250513          	addi	a0,a0,-350 # 6260 <malloc+0x214>
     3c6:	00006097          	auipc	ra,0x6
     3ca:	894080e7          	jalr	-1900(ra) # 5c5a <open>
     3ce:	84aa                	mv	s1,a0
  if (fd < 0) {
     3d0:	04054863          	bltz	a0,420 <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if (write(fd, "x", 1) != 1) {
     3d4:	4605                	li	a2,1
     3d6:	00006597          	auipc	a1,0x6
     3da:	e1258593          	addi	a1,a1,-494 # 61e8 <malloc+0x19c>
     3de:	00006097          	auipc	ra,0x6
     3e2:	85c080e7          	jalr	-1956(ra) # 5c3a <write>
     3e6:	4785                	li	a5,1
     3e8:	04f50963          	beq	a0,a5,43a <badwrite+0xec>
    printf("write failed\n");
     3ec:	00006517          	auipc	a0,0x6
     3f0:	e9450513          	addi	a0,a0,-364 # 6280 <malloc+0x234>
     3f4:	00006097          	auipc	ra,0x6
     3f8:	ba0080e7          	jalr	-1120(ra) # 5f94 <printf>
    exit(1);
     3fc:	4505                	li	a0,1
     3fe:	00006097          	auipc	ra,0x6
     402:	81c080e7          	jalr	-2020(ra) # 5c1a <exit>
      printf("open junk failed\n");
     406:	00006517          	auipc	a0,0x6
     40a:	e6250513          	addi	a0,a0,-414 # 6268 <malloc+0x21c>
     40e:	00006097          	auipc	ra,0x6
     412:	b86080e7          	jalr	-1146(ra) # 5f94 <printf>
      exit(1);
     416:	4505                	li	a0,1
     418:	00006097          	auipc	ra,0x6
     41c:	802080e7          	jalr	-2046(ra) # 5c1a <exit>
    printf("open junk failed\n");
     420:	00006517          	auipc	a0,0x6
     424:	e4850513          	addi	a0,a0,-440 # 6268 <malloc+0x21c>
     428:	00006097          	auipc	ra,0x6
     42c:	b6c080e7          	jalr	-1172(ra) # 5f94 <printf>
    exit(1);
     430:	4505                	li	a0,1
     432:	00005097          	auipc	ra,0x5
     436:	7e8080e7          	jalr	2024(ra) # 5c1a <exit>
  }
  close(fd);
     43a:	8526                	mv	a0,s1
     43c:	00006097          	auipc	ra,0x6
     440:	806080e7          	jalr	-2042(ra) # 5c42 <close>
  unlink("junk");
     444:	00006517          	auipc	a0,0x6
     448:	e1c50513          	addi	a0,a0,-484 # 6260 <malloc+0x214>
     44c:	00006097          	auipc	ra,0x6
     450:	81e080e7          	jalr	-2018(ra) # 5c6a <unlink>

  exit(0);
     454:	4501                	li	a0,0
     456:	00005097          	auipc	ra,0x5
     45a:	7c4080e7          	jalr	1988(ra) # 5c1a <exit>

000000000000045e <outofinodes>:
    name[4] = '\0';
    unlink(name);
  }
}

void outofinodes(char *s) {
     45e:	715d                	addi	sp,sp,-80
     460:	e486                	sd	ra,72(sp)
     462:	e0a2                	sd	s0,64(sp)
     464:	fc26                	sd	s1,56(sp)
     466:	f84a                	sd	s2,48(sp)
     468:	f44e                	sd	s3,40(sp)
     46a:	0880                	addi	s0,sp,80
  int nzz = 32 * 32;
  for (int i = 0; i < nzz; i++) {
     46c:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     46e:	07a00913          	li	s2,122
  for (int i = 0; i < nzz; i++) {
     472:	40000993          	li	s3,1024
    name[0] = 'z';
     476:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     47a:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     47e:	41f4d71b          	sraiw	a4,s1,0x1f
     482:	01b7571b          	srliw	a4,a4,0x1b
     486:	009707bb          	addw	a5,a4,s1
     48a:	4057d69b          	sraiw	a3,a5,0x5
     48e:	0306869b          	addiw	a3,a3,48
     492:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     496:	8bfd                	andi	a5,a5,31
     498:	9f99                	subw	a5,a5,a4
     49a:	0307879b          	addiw	a5,a5,48
     49e:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4a2:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     4a6:	fb040513          	addi	a0,s0,-80
     4aa:	00005097          	auipc	ra,0x5
     4ae:	7c0080e7          	jalr	1984(ra) # 5c6a <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
     4b2:	60200593          	li	a1,1538
     4b6:	fb040513          	addi	a0,s0,-80
     4ba:	00005097          	auipc	ra,0x5
     4be:	7a0080e7          	jalr	1952(ra) # 5c5a <open>
    if (fd < 0) {
     4c2:	00054963          	bltz	a0,4d4 <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
     4c6:	00005097          	auipc	ra,0x5
     4ca:	77c080e7          	jalr	1916(ra) # 5c42 <close>
  for (int i = 0; i < nzz; i++) {
     4ce:	2485                	addiw	s1,s1,1
     4d0:	fb3493e3          	bne	s1,s3,476 <outofinodes+0x18>
     4d4:	4481                	li	s1,0
  }

  for (int i = 0; i < nzz; i++) {
    char name[32];
    name[0] = 'z';
     4d6:	07a00913          	li	s2,122
  for (int i = 0; i < nzz; i++) {
     4da:	40000993          	li	s3,1024
    name[0] = 'z';
     4de:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4e2:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4e6:	41f4d71b          	sraiw	a4,s1,0x1f
     4ea:	01b7571b          	srliw	a4,a4,0x1b
     4ee:	009707bb          	addw	a5,a4,s1
     4f2:	4057d69b          	sraiw	a3,a5,0x5
     4f6:	0306869b          	addiw	a3,a3,48
     4fa:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     4fe:	8bfd                	andi	a5,a5,31
     500:	9f99                	subw	a5,a5,a4
     502:	0307879b          	addiw	a5,a5,48
     506:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     50a:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     50e:	fb040513          	addi	a0,s0,-80
     512:	00005097          	auipc	ra,0x5
     516:	758080e7          	jalr	1880(ra) # 5c6a <unlink>
  for (int i = 0; i < nzz; i++) {
     51a:	2485                	addiw	s1,s1,1
     51c:	fd3491e3          	bne	s1,s3,4de <outofinodes+0x80>
  }
}
     520:	60a6                	ld	ra,72(sp)
     522:	6406                	ld	s0,64(sp)
     524:	74e2                	ld	s1,56(sp)
     526:	7942                	ld	s2,48(sp)
     528:	79a2                	ld	s3,40(sp)
     52a:	6161                	addi	sp,sp,80
     52c:	8082                	ret

000000000000052e <copyin>:
void copyin(char *s) {
     52e:	715d                	addi	sp,sp,-80
     530:	e486                	sd	ra,72(sp)
     532:	e0a2                	sd	s0,64(sp)
     534:	fc26                	sd	s1,56(sp)
     536:	f84a                	sd	s2,48(sp)
     538:	f44e                	sd	s3,40(sp)
     53a:	f052                	sd	s4,32(sp)
     53c:	0880                	addi	s0,sp,80
  uint64 addrs[] = {0x80000000LL, 0xffffffffffffffff};
     53e:	4785                	li	a5,1
     540:	07fe                	slli	a5,a5,0x1f
     542:	fcf43023          	sd	a5,-64(s0)
     546:	57fd                	li	a5,-1
     548:	fcf43423          	sd	a5,-56(s0)
  for (int ai = 0; ai < 2; ai++) {
     54c:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     550:	00006a17          	auipc	s4,0x6
     554:	d40a0a13          	addi	s4,s4,-704 # 6290 <malloc+0x244>
    uint64 addr = addrs[ai];
     558:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     55c:	20100593          	li	a1,513
     560:	8552                	mv	a0,s4
     562:	00005097          	auipc	ra,0x5
     566:	6f8080e7          	jalr	1784(ra) # 5c5a <open>
     56a:	84aa                	mv	s1,a0
    if (fd < 0) {
     56c:	08054863          	bltz	a0,5fc <copyin+0xce>
    int n = write(fd, (void *)addr, 8192);
     570:	6609                	lui	a2,0x2
     572:	85ce                	mv	a1,s3
     574:	00005097          	auipc	ra,0x5
     578:	6c6080e7          	jalr	1734(ra) # 5c3a <write>
    if (n >= 0) {
     57c:	08055d63          	bgez	a0,616 <copyin+0xe8>
    close(fd);
     580:	8526                	mv	a0,s1
     582:	00005097          	auipc	ra,0x5
     586:	6c0080e7          	jalr	1728(ra) # 5c42 <close>
    unlink("copyin1");
     58a:	8552                	mv	a0,s4
     58c:	00005097          	auipc	ra,0x5
     590:	6de080e7          	jalr	1758(ra) # 5c6a <unlink>
    n = write(1, (char *)addr, 8192);
     594:	6609                	lui	a2,0x2
     596:	85ce                	mv	a1,s3
     598:	4505                	li	a0,1
     59a:	00005097          	auipc	ra,0x5
     59e:	6a0080e7          	jalr	1696(ra) # 5c3a <write>
    if (n > 0) {
     5a2:	08a04963          	bgtz	a0,634 <copyin+0x106>
    if (pipe(fds) < 0) {
     5a6:	fb840513          	addi	a0,s0,-72
     5aa:	00005097          	auipc	ra,0x5
     5ae:	680080e7          	jalr	1664(ra) # 5c2a <pipe>
     5b2:	0a054063          	bltz	a0,652 <copyin+0x124>
    n = write(fds[1], (char *)addr, 8192);
     5b6:	6609                	lui	a2,0x2
     5b8:	85ce                	mv	a1,s3
     5ba:	fbc42503          	lw	a0,-68(s0)
     5be:	00005097          	auipc	ra,0x5
     5c2:	67c080e7          	jalr	1660(ra) # 5c3a <write>
    if (n > 0) {
     5c6:	0aa04363          	bgtz	a0,66c <copyin+0x13e>
    close(fds[0]);
     5ca:	fb842503          	lw	a0,-72(s0)
     5ce:	00005097          	auipc	ra,0x5
     5d2:	674080e7          	jalr	1652(ra) # 5c42 <close>
    close(fds[1]);
     5d6:	fbc42503          	lw	a0,-68(s0)
     5da:	00005097          	auipc	ra,0x5
     5de:	668080e7          	jalr	1640(ra) # 5c42 <close>
  for (int ai = 0; ai < 2; ai++) {
     5e2:	0921                	addi	s2,s2,8
     5e4:	fd040793          	addi	a5,s0,-48
     5e8:	f6f918e3          	bne	s2,a5,558 <copyin+0x2a>
}
     5ec:	60a6                	ld	ra,72(sp)
     5ee:	6406                	ld	s0,64(sp)
     5f0:	74e2                	ld	s1,56(sp)
     5f2:	7942                	ld	s2,48(sp)
     5f4:	79a2                	ld	s3,40(sp)
     5f6:	7a02                	ld	s4,32(sp)
     5f8:	6161                	addi	sp,sp,80
     5fa:	8082                	ret
      printf("open(copyin1) failed\n");
     5fc:	00006517          	auipc	a0,0x6
     600:	c9c50513          	addi	a0,a0,-868 # 6298 <malloc+0x24c>
     604:	00006097          	auipc	ra,0x6
     608:	990080e7          	jalr	-1648(ra) # 5f94 <printf>
      exit(1);
     60c:	4505                	li	a0,1
     60e:	00005097          	auipc	ra,0x5
     612:	60c080e7          	jalr	1548(ra) # 5c1a <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     616:	862a                	mv	a2,a0
     618:	85ce                	mv	a1,s3
     61a:	00006517          	auipc	a0,0x6
     61e:	c9650513          	addi	a0,a0,-874 # 62b0 <malloc+0x264>
     622:	00006097          	auipc	ra,0x6
     626:	972080e7          	jalr	-1678(ra) # 5f94 <printf>
      exit(1);
     62a:	4505                	li	a0,1
     62c:	00005097          	auipc	ra,0x5
     630:	5ee080e7          	jalr	1518(ra) # 5c1a <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     634:	862a                	mv	a2,a0
     636:	85ce                	mv	a1,s3
     638:	00006517          	auipc	a0,0x6
     63c:	ca850513          	addi	a0,a0,-856 # 62e0 <malloc+0x294>
     640:	00006097          	auipc	ra,0x6
     644:	954080e7          	jalr	-1708(ra) # 5f94 <printf>
      exit(1);
     648:	4505                	li	a0,1
     64a:	00005097          	auipc	ra,0x5
     64e:	5d0080e7          	jalr	1488(ra) # 5c1a <exit>
      printf("pipe() failed\n");
     652:	00006517          	auipc	a0,0x6
     656:	cbe50513          	addi	a0,a0,-834 # 6310 <malloc+0x2c4>
     65a:	00006097          	auipc	ra,0x6
     65e:	93a080e7          	jalr	-1734(ra) # 5f94 <printf>
      exit(1);
     662:	4505                	li	a0,1
     664:	00005097          	auipc	ra,0x5
     668:	5b6080e7          	jalr	1462(ra) # 5c1a <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     66c:	862a                	mv	a2,a0
     66e:	85ce                	mv	a1,s3
     670:	00006517          	auipc	a0,0x6
     674:	cb050513          	addi	a0,a0,-848 # 6320 <malloc+0x2d4>
     678:	00006097          	auipc	ra,0x6
     67c:	91c080e7          	jalr	-1764(ra) # 5f94 <printf>
      exit(1);
     680:	4505                	li	a0,1
     682:	00005097          	auipc	ra,0x5
     686:	598080e7          	jalr	1432(ra) # 5c1a <exit>

000000000000068a <copyout>:
void copyout(char *s) {
     68a:	711d                	addi	sp,sp,-96
     68c:	ec86                	sd	ra,88(sp)
     68e:	e8a2                	sd	s0,80(sp)
     690:	e4a6                	sd	s1,72(sp)
     692:	e0ca                	sd	s2,64(sp)
     694:	fc4e                	sd	s3,56(sp)
     696:	f852                	sd	s4,48(sp)
     698:	f456                	sd	s5,40(sp)
     69a:	f05a                	sd	s6,32(sp)
     69c:	1080                	addi	s0,sp,96
  uint64 addrs[] = {0LL, 0x80000000LL, 0xffffffffffffffff};
     69e:	fa043423          	sd	zero,-88(s0)
     6a2:	4785                	li	a5,1
     6a4:	07fe                	slli	a5,a5,0x1f
     6a6:	faf43823          	sd	a5,-80(s0)
     6aa:	57fd                	li	a5,-1
     6ac:	faf43c23          	sd	a5,-72(s0)
  for (int ai = 0; ai < 2; ai++) {
     6b0:	fa840913          	addi	s2,s0,-88
     6b4:	fb840b13          	addi	s6,s0,-72
    int fd = open("xv6-readme", 0);
     6b8:	00006a17          	auipc	s4,0x6
     6bc:	c98a0a13          	addi	s4,s4,-872 # 6350 <malloc+0x304>
    n = write(fds[1], "x", 1);
     6c0:	00006a97          	auipc	s5,0x6
     6c4:	b28a8a93          	addi	s5,s5,-1240 # 61e8 <malloc+0x19c>
    uint64 addr = addrs[ai];
     6c8:	00093983          	ld	s3,0(s2)
    int fd = open("xv6-readme", 0);
     6cc:	4581                	li	a1,0
     6ce:	8552                	mv	a0,s4
     6d0:	00005097          	auipc	ra,0x5
     6d4:	58a080e7          	jalr	1418(ra) # 5c5a <open>
     6d8:	84aa                	mv	s1,a0
    if (fd < 0) {
     6da:	08054563          	bltz	a0,764 <copyout+0xda>
    int n = read(fd, (void *)addr, 8192);
     6de:	6609                	lui	a2,0x2
     6e0:	85ce                	mv	a1,s3
     6e2:	00005097          	auipc	ra,0x5
     6e6:	550080e7          	jalr	1360(ra) # 5c32 <read>
    if (n > 0) {
     6ea:	08a04a63          	bgtz	a0,77e <copyout+0xf4>
    close(fd);
     6ee:	8526                	mv	a0,s1
     6f0:	00005097          	auipc	ra,0x5
     6f4:	552080e7          	jalr	1362(ra) # 5c42 <close>
    if (pipe(fds) < 0) {
     6f8:	fa040513          	addi	a0,s0,-96
     6fc:	00005097          	auipc	ra,0x5
     700:	52e080e7          	jalr	1326(ra) # 5c2a <pipe>
     704:	08054c63          	bltz	a0,79c <copyout+0x112>
    n = write(fds[1], "x", 1);
     708:	4605                	li	a2,1
     70a:	85d6                	mv	a1,s5
     70c:	fa442503          	lw	a0,-92(s0)
     710:	00005097          	auipc	ra,0x5
     714:	52a080e7          	jalr	1322(ra) # 5c3a <write>
    if (n != 1) {
     718:	4785                	li	a5,1
     71a:	08f51e63          	bne	a0,a5,7b6 <copyout+0x12c>
    n = read(fds[0], (void *)addr, 8192);
     71e:	6609                	lui	a2,0x2
     720:	85ce                	mv	a1,s3
     722:	fa042503          	lw	a0,-96(s0)
     726:	00005097          	auipc	ra,0x5
     72a:	50c080e7          	jalr	1292(ra) # 5c32 <read>
    if (n > 0) {
     72e:	0aa04163          	bgtz	a0,7d0 <copyout+0x146>
    close(fds[0]);
     732:	fa042503          	lw	a0,-96(s0)
     736:	00005097          	auipc	ra,0x5
     73a:	50c080e7          	jalr	1292(ra) # 5c42 <close>
    close(fds[1]);
     73e:	fa442503          	lw	a0,-92(s0)
     742:	00005097          	auipc	ra,0x5
     746:	500080e7          	jalr	1280(ra) # 5c42 <close>
  for (int ai = 0; ai < 2; ai++) {
     74a:	0921                	addi	s2,s2,8
     74c:	f7691ee3          	bne	s2,s6,6c8 <copyout+0x3e>
}
     750:	60e6                	ld	ra,88(sp)
     752:	6446                	ld	s0,80(sp)
     754:	64a6                	ld	s1,72(sp)
     756:	6906                	ld	s2,64(sp)
     758:	79e2                	ld	s3,56(sp)
     75a:	7a42                	ld	s4,48(sp)
     75c:	7aa2                	ld	s5,40(sp)
     75e:	7b02                	ld	s6,32(sp)
     760:	6125                	addi	sp,sp,96
     762:	8082                	ret
      printf("open(xv6-readme) failed\n");
     764:	00006517          	auipc	a0,0x6
     768:	bfc50513          	addi	a0,a0,-1028 # 6360 <malloc+0x314>
     76c:	00006097          	auipc	ra,0x6
     770:	828080e7          	jalr	-2008(ra) # 5f94 <printf>
      exit(1);
     774:	4505                	li	a0,1
     776:	00005097          	auipc	ra,0x5
     77a:	4a4080e7          	jalr	1188(ra) # 5c1a <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     77e:	862a                	mv	a2,a0
     780:	85ce                	mv	a1,s3
     782:	00006517          	auipc	a0,0x6
     786:	bfe50513          	addi	a0,a0,-1026 # 6380 <malloc+0x334>
     78a:	00006097          	auipc	ra,0x6
     78e:	80a080e7          	jalr	-2038(ra) # 5f94 <printf>
      exit(1);
     792:	4505                	li	a0,1
     794:	00005097          	auipc	ra,0x5
     798:	486080e7          	jalr	1158(ra) # 5c1a <exit>
      printf("pipe() failed\n");
     79c:	00006517          	auipc	a0,0x6
     7a0:	b7450513          	addi	a0,a0,-1164 # 6310 <malloc+0x2c4>
     7a4:	00005097          	auipc	ra,0x5
     7a8:	7f0080e7          	jalr	2032(ra) # 5f94 <printf>
      exit(1);
     7ac:	4505                	li	a0,1
     7ae:	00005097          	auipc	ra,0x5
     7b2:	46c080e7          	jalr	1132(ra) # 5c1a <exit>
      printf("pipe write failed\n");
     7b6:	00006517          	auipc	a0,0x6
     7ba:	bfa50513          	addi	a0,a0,-1030 # 63b0 <malloc+0x364>
     7be:	00005097          	auipc	ra,0x5
     7c2:	7d6080e7          	jalr	2006(ra) # 5f94 <printf>
      exit(1);
     7c6:	4505                	li	a0,1
     7c8:	00005097          	auipc	ra,0x5
     7cc:	452080e7          	jalr	1106(ra) # 5c1a <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7d0:	862a                	mv	a2,a0
     7d2:	85ce                	mv	a1,s3
     7d4:	00006517          	auipc	a0,0x6
     7d8:	bf450513          	addi	a0,a0,-1036 # 63c8 <malloc+0x37c>
     7dc:	00005097          	auipc	ra,0x5
     7e0:	7b8080e7          	jalr	1976(ra) # 5f94 <printf>
      exit(1);
     7e4:	4505                	li	a0,1
     7e6:	00005097          	auipc	ra,0x5
     7ea:	434080e7          	jalr	1076(ra) # 5c1a <exit>

00000000000007ee <truncate1>:
void truncate1(char *s) {
     7ee:	711d                	addi	sp,sp,-96
     7f0:	ec86                	sd	ra,88(sp)
     7f2:	e8a2                	sd	s0,80(sp)
     7f4:	e4a6                	sd	s1,72(sp)
     7f6:	e0ca                	sd	s2,64(sp)
     7f8:	fc4e                	sd	s3,56(sp)
     7fa:	f852                	sd	s4,48(sp)
     7fc:	f456                	sd	s5,40(sp)
     7fe:	1080                	addi	s0,sp,96
     800:	8aaa                	mv	s5,a0
  unlink("truncfile");
     802:	00006517          	auipc	a0,0x6
     806:	9ce50513          	addi	a0,a0,-1586 # 61d0 <malloc+0x184>
     80a:	00005097          	auipc	ra,0x5
     80e:	460080e7          	jalr	1120(ra) # 5c6a <unlink>
  int fd1 = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
     812:	60100593          	li	a1,1537
     816:	00006517          	auipc	a0,0x6
     81a:	9ba50513          	addi	a0,a0,-1606 # 61d0 <malloc+0x184>
     81e:	00005097          	auipc	ra,0x5
     822:	43c080e7          	jalr	1084(ra) # 5c5a <open>
     826:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     828:	4611                	li	a2,4
     82a:	00006597          	auipc	a1,0x6
     82e:	9b658593          	addi	a1,a1,-1610 # 61e0 <malloc+0x194>
     832:	00005097          	auipc	ra,0x5
     836:	408080e7          	jalr	1032(ra) # 5c3a <write>
  close(fd1);
     83a:	8526                	mv	a0,s1
     83c:	00005097          	auipc	ra,0x5
     840:	406080e7          	jalr	1030(ra) # 5c42 <close>
  int fd2 = open("truncfile", O_RDONLY);
     844:	4581                	li	a1,0
     846:	00006517          	auipc	a0,0x6
     84a:	98a50513          	addi	a0,a0,-1654 # 61d0 <malloc+0x184>
     84e:	00005097          	auipc	ra,0x5
     852:	40c080e7          	jalr	1036(ra) # 5c5a <open>
     856:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     858:	02000613          	li	a2,32
     85c:	fa040593          	addi	a1,s0,-96
     860:	00005097          	auipc	ra,0x5
     864:	3d2080e7          	jalr	978(ra) # 5c32 <read>
  if (n != 4) {
     868:	4791                	li	a5,4
     86a:	0cf51e63          	bne	a0,a5,946 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY | O_TRUNC);
     86e:	40100593          	li	a1,1025
     872:	00006517          	auipc	a0,0x6
     876:	95e50513          	addi	a0,a0,-1698 # 61d0 <malloc+0x184>
     87a:	00005097          	auipc	ra,0x5
     87e:	3e0080e7          	jalr	992(ra) # 5c5a <open>
     882:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     884:	4581                	li	a1,0
     886:	00006517          	auipc	a0,0x6
     88a:	94a50513          	addi	a0,a0,-1718 # 61d0 <malloc+0x184>
     88e:	00005097          	auipc	ra,0x5
     892:	3cc080e7          	jalr	972(ra) # 5c5a <open>
     896:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     898:	02000613          	li	a2,32
     89c:	fa040593          	addi	a1,s0,-96
     8a0:	00005097          	auipc	ra,0x5
     8a4:	392080e7          	jalr	914(ra) # 5c32 <read>
     8a8:	8a2a                	mv	s4,a0
  if (n != 0) {
     8aa:	ed4d                	bnez	a0,964 <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     8ac:	02000613          	li	a2,32
     8b0:	fa040593          	addi	a1,s0,-96
     8b4:	8526                	mv	a0,s1
     8b6:	00005097          	auipc	ra,0x5
     8ba:	37c080e7          	jalr	892(ra) # 5c32 <read>
     8be:	8a2a                	mv	s4,a0
  if (n != 0) {
     8c0:	e971                	bnez	a0,994 <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     8c2:	4619                	li	a2,6
     8c4:	00006597          	auipc	a1,0x6
     8c8:	b9458593          	addi	a1,a1,-1132 # 6458 <malloc+0x40c>
     8cc:	854e                	mv	a0,s3
     8ce:	00005097          	auipc	ra,0x5
     8d2:	36c080e7          	jalr	876(ra) # 5c3a <write>
  n = read(fd3, buf, sizeof(buf));
     8d6:	02000613          	li	a2,32
     8da:	fa040593          	addi	a1,s0,-96
     8de:	854a                	mv	a0,s2
     8e0:	00005097          	auipc	ra,0x5
     8e4:	352080e7          	jalr	850(ra) # 5c32 <read>
  if (n != 6) {
     8e8:	4799                	li	a5,6
     8ea:	0cf51d63          	bne	a0,a5,9c4 <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     8ee:	02000613          	li	a2,32
     8f2:	fa040593          	addi	a1,s0,-96
     8f6:	8526                	mv	a0,s1
     8f8:	00005097          	auipc	ra,0x5
     8fc:	33a080e7          	jalr	826(ra) # 5c32 <read>
  if (n != 2) {
     900:	4789                	li	a5,2
     902:	0ef51063          	bne	a0,a5,9e2 <truncate1+0x1f4>
  unlink("truncfile");
     906:	00006517          	auipc	a0,0x6
     90a:	8ca50513          	addi	a0,a0,-1846 # 61d0 <malloc+0x184>
     90e:	00005097          	auipc	ra,0x5
     912:	35c080e7          	jalr	860(ra) # 5c6a <unlink>
  close(fd1);
     916:	854e                	mv	a0,s3
     918:	00005097          	auipc	ra,0x5
     91c:	32a080e7          	jalr	810(ra) # 5c42 <close>
  close(fd2);
     920:	8526                	mv	a0,s1
     922:	00005097          	auipc	ra,0x5
     926:	320080e7          	jalr	800(ra) # 5c42 <close>
  close(fd3);
     92a:	854a                	mv	a0,s2
     92c:	00005097          	auipc	ra,0x5
     930:	316080e7          	jalr	790(ra) # 5c42 <close>
}
     934:	60e6                	ld	ra,88(sp)
     936:	6446                	ld	s0,80(sp)
     938:	64a6                	ld	s1,72(sp)
     93a:	6906                	ld	s2,64(sp)
     93c:	79e2                	ld	s3,56(sp)
     93e:	7a42                	ld	s4,48(sp)
     940:	7aa2                	ld	s5,40(sp)
     942:	6125                	addi	sp,sp,96
     944:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     946:	862a                	mv	a2,a0
     948:	85d6                	mv	a1,s5
     94a:	00006517          	auipc	a0,0x6
     94e:	aae50513          	addi	a0,a0,-1362 # 63f8 <malloc+0x3ac>
     952:	00005097          	auipc	ra,0x5
     956:	642080e7          	jalr	1602(ra) # 5f94 <printf>
    exit(1);
     95a:	4505                	li	a0,1
     95c:	00005097          	auipc	ra,0x5
     960:	2be080e7          	jalr	702(ra) # 5c1a <exit>
    printf("aaa fd3=%d\n", fd3);
     964:	85ca                	mv	a1,s2
     966:	00006517          	auipc	a0,0x6
     96a:	ab250513          	addi	a0,a0,-1358 # 6418 <malloc+0x3cc>
     96e:	00005097          	auipc	ra,0x5
     972:	626080e7          	jalr	1574(ra) # 5f94 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     976:	8652                	mv	a2,s4
     978:	85d6                	mv	a1,s5
     97a:	00006517          	auipc	a0,0x6
     97e:	aae50513          	addi	a0,a0,-1362 # 6428 <malloc+0x3dc>
     982:	00005097          	auipc	ra,0x5
     986:	612080e7          	jalr	1554(ra) # 5f94 <printf>
    exit(1);
     98a:	4505                	li	a0,1
     98c:	00005097          	auipc	ra,0x5
     990:	28e080e7          	jalr	654(ra) # 5c1a <exit>
    printf("bbb fd2=%d\n", fd2);
     994:	85a6                	mv	a1,s1
     996:	00006517          	auipc	a0,0x6
     99a:	ab250513          	addi	a0,a0,-1358 # 6448 <malloc+0x3fc>
     99e:	00005097          	auipc	ra,0x5
     9a2:	5f6080e7          	jalr	1526(ra) # 5f94 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     9a6:	8652                	mv	a2,s4
     9a8:	85d6                	mv	a1,s5
     9aa:	00006517          	auipc	a0,0x6
     9ae:	a7e50513          	addi	a0,a0,-1410 # 6428 <malloc+0x3dc>
     9b2:	00005097          	auipc	ra,0x5
     9b6:	5e2080e7          	jalr	1506(ra) # 5f94 <printf>
    exit(1);
     9ba:	4505                	li	a0,1
     9bc:	00005097          	auipc	ra,0x5
     9c0:	25e080e7          	jalr	606(ra) # 5c1a <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     9c4:	862a                	mv	a2,a0
     9c6:	85d6                	mv	a1,s5
     9c8:	00006517          	auipc	a0,0x6
     9cc:	a9850513          	addi	a0,a0,-1384 # 6460 <malloc+0x414>
     9d0:	00005097          	auipc	ra,0x5
     9d4:	5c4080e7          	jalr	1476(ra) # 5f94 <printf>
    exit(1);
     9d8:	4505                	li	a0,1
     9da:	00005097          	auipc	ra,0x5
     9de:	240080e7          	jalr	576(ra) # 5c1a <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     9e2:	862a                	mv	a2,a0
     9e4:	85d6                	mv	a1,s5
     9e6:	00006517          	auipc	a0,0x6
     9ea:	a9a50513          	addi	a0,a0,-1382 # 6480 <malloc+0x434>
     9ee:	00005097          	auipc	ra,0x5
     9f2:	5a6080e7          	jalr	1446(ra) # 5f94 <printf>
    exit(1);
     9f6:	4505                	li	a0,1
     9f8:	00005097          	auipc	ra,0x5
     9fc:	222080e7          	jalr	546(ra) # 5c1a <exit>

0000000000000a00 <writetest>:
void writetest(char *s) {
     a00:	7139                	addi	sp,sp,-64
     a02:	fc06                	sd	ra,56(sp)
     a04:	f822                	sd	s0,48(sp)
     a06:	f426                	sd	s1,40(sp)
     a08:	f04a                	sd	s2,32(sp)
     a0a:	ec4e                	sd	s3,24(sp)
     a0c:	e852                	sd	s4,16(sp)
     a0e:	e456                	sd	s5,8(sp)
     a10:	e05a                	sd	s6,0(sp)
     a12:	0080                	addi	s0,sp,64
     a14:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE | O_RDWR);
     a16:	20200593          	li	a1,514
     a1a:	00006517          	auipc	a0,0x6
     a1e:	a8650513          	addi	a0,a0,-1402 # 64a0 <malloc+0x454>
     a22:	00005097          	auipc	ra,0x5
     a26:	238080e7          	jalr	568(ra) # 5c5a <open>
  if (fd < 0) {
     a2a:	0a054d63          	bltz	a0,ae4 <writetest+0xe4>
     a2e:	892a                	mv	s2,a0
     a30:	4481                	li	s1,0
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     a32:	00006997          	auipc	s3,0x6
     a36:	a9698993          	addi	s3,s3,-1386 # 64c8 <malloc+0x47c>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     a3a:	00006a97          	auipc	s5,0x6
     a3e:	ac6a8a93          	addi	s5,s5,-1338 # 6500 <malloc+0x4b4>
  for (i = 0; i < N; i++) {
     a42:	06400a13          	li	s4,100
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     a46:	4629                	li	a2,10
     a48:	85ce                	mv	a1,s3
     a4a:	854a                	mv	a0,s2
     a4c:	00005097          	auipc	ra,0x5
     a50:	1ee080e7          	jalr	494(ra) # 5c3a <write>
     a54:	47a9                	li	a5,10
     a56:	0af51563          	bne	a0,a5,b00 <writetest+0x100>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     a5a:	4629                	li	a2,10
     a5c:	85d6                	mv	a1,s5
     a5e:	854a                	mv	a0,s2
     a60:	00005097          	auipc	ra,0x5
     a64:	1da080e7          	jalr	474(ra) # 5c3a <write>
     a68:	47a9                	li	a5,10
     a6a:	0af51a63          	bne	a0,a5,b1e <writetest+0x11e>
  for (i = 0; i < N; i++) {
     a6e:	2485                	addiw	s1,s1,1
     a70:	fd449be3          	bne	s1,s4,a46 <writetest+0x46>
  close(fd);
     a74:	854a                	mv	a0,s2
     a76:	00005097          	auipc	ra,0x5
     a7a:	1cc080e7          	jalr	460(ra) # 5c42 <close>
  fd = open("small", O_RDONLY);
     a7e:	4581                	li	a1,0
     a80:	00006517          	auipc	a0,0x6
     a84:	a2050513          	addi	a0,a0,-1504 # 64a0 <malloc+0x454>
     a88:	00005097          	auipc	ra,0x5
     a8c:	1d2080e7          	jalr	466(ra) # 5c5a <open>
     a90:	84aa                	mv	s1,a0
  if (fd < 0) {
     a92:	0a054563          	bltz	a0,b3c <writetest+0x13c>
  i = read(fd, buf, N * SZ * 2);
     a96:	7d000613          	li	a2,2000
     a9a:	0000c597          	auipc	a1,0xc
     a9e:	1de58593          	addi	a1,a1,478 # cc78 <buf>
     aa2:	00005097          	auipc	ra,0x5
     aa6:	190080e7          	jalr	400(ra) # 5c32 <read>
  if (i != N * SZ * 2) {
     aaa:	7d000793          	li	a5,2000
     aae:	0af51563          	bne	a0,a5,b58 <writetest+0x158>
  close(fd);
     ab2:	8526                	mv	a0,s1
     ab4:	00005097          	auipc	ra,0x5
     ab8:	18e080e7          	jalr	398(ra) # 5c42 <close>
  if (unlink("small") < 0) {
     abc:	00006517          	auipc	a0,0x6
     ac0:	9e450513          	addi	a0,a0,-1564 # 64a0 <malloc+0x454>
     ac4:	00005097          	auipc	ra,0x5
     ac8:	1a6080e7          	jalr	422(ra) # 5c6a <unlink>
     acc:	0a054463          	bltz	a0,b74 <writetest+0x174>
}
     ad0:	70e2                	ld	ra,56(sp)
     ad2:	7442                	ld	s0,48(sp)
     ad4:	74a2                	ld	s1,40(sp)
     ad6:	7902                	ld	s2,32(sp)
     ad8:	69e2                	ld	s3,24(sp)
     ada:	6a42                	ld	s4,16(sp)
     adc:	6aa2                	ld	s5,8(sp)
     ade:	6b02                	ld	s6,0(sp)
     ae0:	6121                	addi	sp,sp,64
     ae2:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     ae4:	85da                	mv	a1,s6
     ae6:	00006517          	auipc	a0,0x6
     aea:	9c250513          	addi	a0,a0,-1598 # 64a8 <malloc+0x45c>
     aee:	00005097          	auipc	ra,0x5
     af2:	4a6080e7          	jalr	1190(ra) # 5f94 <printf>
    exit(1);
     af6:	4505                	li	a0,1
     af8:	00005097          	auipc	ra,0x5
     afc:	122080e7          	jalr	290(ra) # 5c1a <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     b00:	8626                	mv	a2,s1
     b02:	85da                	mv	a1,s6
     b04:	00006517          	auipc	a0,0x6
     b08:	9d450513          	addi	a0,a0,-1580 # 64d8 <malloc+0x48c>
     b0c:	00005097          	auipc	ra,0x5
     b10:	488080e7          	jalr	1160(ra) # 5f94 <printf>
      exit(1);
     b14:	4505                	li	a0,1
     b16:	00005097          	auipc	ra,0x5
     b1a:	104080e7          	jalr	260(ra) # 5c1a <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b1e:	8626                	mv	a2,s1
     b20:	85da                	mv	a1,s6
     b22:	00006517          	auipc	a0,0x6
     b26:	9ee50513          	addi	a0,a0,-1554 # 6510 <malloc+0x4c4>
     b2a:	00005097          	auipc	ra,0x5
     b2e:	46a080e7          	jalr	1130(ra) # 5f94 <printf>
      exit(1);
     b32:	4505                	li	a0,1
     b34:	00005097          	auipc	ra,0x5
     b38:	0e6080e7          	jalr	230(ra) # 5c1a <exit>
    printf("%s: error: open small failed!\n", s);
     b3c:	85da                	mv	a1,s6
     b3e:	00006517          	auipc	a0,0x6
     b42:	9fa50513          	addi	a0,a0,-1542 # 6538 <malloc+0x4ec>
     b46:	00005097          	auipc	ra,0x5
     b4a:	44e080e7          	jalr	1102(ra) # 5f94 <printf>
    exit(1);
     b4e:	4505                	li	a0,1
     b50:	00005097          	auipc	ra,0x5
     b54:	0ca080e7          	jalr	202(ra) # 5c1a <exit>
    printf("%s: read failed\n", s);
     b58:	85da                	mv	a1,s6
     b5a:	00006517          	auipc	a0,0x6
     b5e:	9fe50513          	addi	a0,a0,-1538 # 6558 <malloc+0x50c>
     b62:	00005097          	auipc	ra,0x5
     b66:	432080e7          	jalr	1074(ra) # 5f94 <printf>
    exit(1);
     b6a:	4505                	li	a0,1
     b6c:	00005097          	auipc	ra,0x5
     b70:	0ae080e7          	jalr	174(ra) # 5c1a <exit>
    printf("%s: unlink small failed\n", s);
     b74:	85da                	mv	a1,s6
     b76:	00006517          	auipc	a0,0x6
     b7a:	9fa50513          	addi	a0,a0,-1542 # 6570 <malloc+0x524>
     b7e:	00005097          	auipc	ra,0x5
     b82:	416080e7          	jalr	1046(ra) # 5f94 <printf>
    exit(1);
     b86:	4505                	li	a0,1
     b88:	00005097          	auipc	ra,0x5
     b8c:	092080e7          	jalr	146(ra) # 5c1a <exit>

0000000000000b90 <writebig>:
void writebig(char *s) {
     b90:	7139                	addi	sp,sp,-64
     b92:	fc06                	sd	ra,56(sp)
     b94:	f822                	sd	s0,48(sp)
     b96:	f426                	sd	s1,40(sp)
     b98:	f04a                	sd	s2,32(sp)
     b9a:	ec4e                	sd	s3,24(sp)
     b9c:	e852                	sd	s4,16(sp)
     b9e:	e456                	sd	s5,8(sp)
     ba0:	0080                	addi	s0,sp,64
     ba2:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE | O_RDWR);
     ba4:	20200593          	li	a1,514
     ba8:	00006517          	auipc	a0,0x6
     bac:	9e850513          	addi	a0,a0,-1560 # 6590 <malloc+0x544>
     bb0:	00005097          	auipc	ra,0x5
     bb4:	0aa080e7          	jalr	170(ra) # 5c5a <open>
     bb8:	89aa                	mv	s3,a0
  for (i = 0; i < MAXFILE; i++) {
     bba:	4481                	li	s1,0
    ((int *)buf)[0] = i;
     bbc:	0000c917          	auipc	s2,0xc
     bc0:	0bc90913          	addi	s2,s2,188 # cc78 <buf>
  for (i = 0; i < MAXFILE; i++) {
     bc4:	10c00a13          	li	s4,268
  if (fd < 0) {
     bc8:	06054c63          	bltz	a0,c40 <writebig+0xb0>
    ((int *)buf)[0] = i;
     bcc:	00992023          	sw	s1,0(s2)
    if (write(fd, buf, BSIZE) != BSIZE) {
     bd0:	40000613          	li	a2,1024
     bd4:	85ca                	mv	a1,s2
     bd6:	854e                	mv	a0,s3
     bd8:	00005097          	auipc	ra,0x5
     bdc:	062080e7          	jalr	98(ra) # 5c3a <write>
     be0:	40000793          	li	a5,1024
     be4:	06f51c63          	bne	a0,a5,c5c <writebig+0xcc>
  for (i = 0; i < MAXFILE; i++) {
     be8:	2485                	addiw	s1,s1,1
     bea:	ff4491e3          	bne	s1,s4,bcc <writebig+0x3c>
  close(fd);
     bee:	854e                	mv	a0,s3
     bf0:	00005097          	auipc	ra,0x5
     bf4:	052080e7          	jalr	82(ra) # 5c42 <close>
  fd = open("big", O_RDONLY);
     bf8:	4581                	li	a1,0
     bfa:	00006517          	auipc	a0,0x6
     bfe:	99650513          	addi	a0,a0,-1642 # 6590 <malloc+0x544>
     c02:	00005097          	auipc	ra,0x5
     c06:	058080e7          	jalr	88(ra) # 5c5a <open>
     c0a:	89aa                	mv	s3,a0
  n = 0;
     c0c:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c0e:	0000c917          	auipc	s2,0xc
     c12:	06a90913          	addi	s2,s2,106 # cc78 <buf>
  if (fd < 0) {
     c16:	06054263          	bltz	a0,c7a <writebig+0xea>
    i = read(fd, buf, BSIZE);
     c1a:	40000613          	li	a2,1024
     c1e:	85ca                	mv	a1,s2
     c20:	854e                	mv	a0,s3
     c22:	00005097          	auipc	ra,0x5
     c26:	010080e7          	jalr	16(ra) # 5c32 <read>
    if (i == 0) {
     c2a:	c535                	beqz	a0,c96 <writebig+0x106>
    } else if (i != BSIZE) {
     c2c:	40000793          	li	a5,1024
     c30:	0af51f63          	bne	a0,a5,cee <writebig+0x15e>
    if (((int *)buf)[0] != n) {
     c34:	00092683          	lw	a3,0(s2)
     c38:	0c969a63          	bne	a3,s1,d0c <writebig+0x17c>
    n++;
     c3c:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     c3e:	bff1                	j	c1a <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     c40:	85d6                	mv	a1,s5
     c42:	00006517          	auipc	a0,0x6
     c46:	95650513          	addi	a0,a0,-1706 # 6598 <malloc+0x54c>
     c4a:	00005097          	auipc	ra,0x5
     c4e:	34a080e7          	jalr	842(ra) # 5f94 <printf>
    exit(1);
     c52:	4505                	li	a0,1
     c54:	00005097          	auipc	ra,0x5
     c58:	fc6080e7          	jalr	-58(ra) # 5c1a <exit>
      printf("%s: error: write big file failed\n", s, i);
     c5c:	8626                	mv	a2,s1
     c5e:	85d6                	mv	a1,s5
     c60:	00006517          	auipc	a0,0x6
     c64:	95850513          	addi	a0,a0,-1704 # 65b8 <malloc+0x56c>
     c68:	00005097          	auipc	ra,0x5
     c6c:	32c080e7          	jalr	812(ra) # 5f94 <printf>
      exit(1);
     c70:	4505                	li	a0,1
     c72:	00005097          	auipc	ra,0x5
     c76:	fa8080e7          	jalr	-88(ra) # 5c1a <exit>
    printf("%s: error: open big failed!\n", s);
     c7a:	85d6                	mv	a1,s5
     c7c:	00006517          	auipc	a0,0x6
     c80:	96450513          	addi	a0,a0,-1692 # 65e0 <malloc+0x594>
     c84:	00005097          	auipc	ra,0x5
     c88:	310080e7          	jalr	784(ra) # 5f94 <printf>
    exit(1);
     c8c:	4505                	li	a0,1
     c8e:	00005097          	auipc	ra,0x5
     c92:	f8c080e7          	jalr	-116(ra) # 5c1a <exit>
      if (n == MAXFILE - 1) {
     c96:	10b00793          	li	a5,267
     c9a:	02f48a63          	beq	s1,a5,cce <writebig+0x13e>
  close(fd);
     c9e:	854e                	mv	a0,s3
     ca0:	00005097          	auipc	ra,0x5
     ca4:	fa2080e7          	jalr	-94(ra) # 5c42 <close>
  if (unlink("big") < 0) {
     ca8:	00006517          	auipc	a0,0x6
     cac:	8e850513          	addi	a0,a0,-1816 # 6590 <malloc+0x544>
     cb0:	00005097          	auipc	ra,0x5
     cb4:	fba080e7          	jalr	-70(ra) # 5c6a <unlink>
     cb8:	06054963          	bltz	a0,d2a <writebig+0x19a>
}
     cbc:	70e2                	ld	ra,56(sp)
     cbe:	7442                	ld	s0,48(sp)
     cc0:	74a2                	ld	s1,40(sp)
     cc2:	7902                	ld	s2,32(sp)
     cc4:	69e2                	ld	s3,24(sp)
     cc6:	6a42                	ld	s4,16(sp)
     cc8:	6aa2                	ld	s5,8(sp)
     cca:	6121                	addi	sp,sp,64
     ccc:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     cce:	10b00613          	li	a2,267
     cd2:	85d6                	mv	a1,s5
     cd4:	00006517          	auipc	a0,0x6
     cd8:	92c50513          	addi	a0,a0,-1748 # 6600 <malloc+0x5b4>
     cdc:	00005097          	auipc	ra,0x5
     ce0:	2b8080e7          	jalr	696(ra) # 5f94 <printf>
        exit(1);
     ce4:	4505                	li	a0,1
     ce6:	00005097          	auipc	ra,0x5
     cea:	f34080e7          	jalr	-204(ra) # 5c1a <exit>
      printf("%s: read failed %d\n", s, i);
     cee:	862a                	mv	a2,a0
     cf0:	85d6                	mv	a1,s5
     cf2:	00006517          	auipc	a0,0x6
     cf6:	93650513          	addi	a0,a0,-1738 # 6628 <malloc+0x5dc>
     cfa:	00005097          	auipc	ra,0x5
     cfe:	29a080e7          	jalr	666(ra) # 5f94 <printf>
      exit(1);
     d02:	4505                	li	a0,1
     d04:	00005097          	auipc	ra,0x5
     d08:	f16080e7          	jalr	-234(ra) # 5c1a <exit>
      printf("%s: read content of block %d is %d\n", s, n, ((int *)buf)[0]);
     d0c:	8626                	mv	a2,s1
     d0e:	85d6                	mv	a1,s5
     d10:	00006517          	auipc	a0,0x6
     d14:	93050513          	addi	a0,a0,-1744 # 6640 <malloc+0x5f4>
     d18:	00005097          	auipc	ra,0x5
     d1c:	27c080e7          	jalr	636(ra) # 5f94 <printf>
      exit(1);
     d20:	4505                	li	a0,1
     d22:	00005097          	auipc	ra,0x5
     d26:	ef8080e7          	jalr	-264(ra) # 5c1a <exit>
    printf("%s: unlink big failed\n", s);
     d2a:	85d6                	mv	a1,s5
     d2c:	00006517          	auipc	a0,0x6
     d30:	93c50513          	addi	a0,a0,-1732 # 6668 <malloc+0x61c>
     d34:	00005097          	auipc	ra,0x5
     d38:	260080e7          	jalr	608(ra) # 5f94 <printf>
    exit(1);
     d3c:	4505                	li	a0,1
     d3e:	00005097          	auipc	ra,0x5
     d42:	edc080e7          	jalr	-292(ra) # 5c1a <exit>

0000000000000d46 <unlinkread>:
void unlinkread(char *s) {
     d46:	7179                	addi	sp,sp,-48
     d48:	f406                	sd	ra,40(sp)
     d4a:	f022                	sd	s0,32(sp)
     d4c:	ec26                	sd	s1,24(sp)
     d4e:	e84a                	sd	s2,16(sp)
     d50:	e44e                	sd	s3,8(sp)
     d52:	1800                	addi	s0,sp,48
     d54:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     d56:	20200593          	li	a1,514
     d5a:	00006517          	auipc	a0,0x6
     d5e:	92650513          	addi	a0,a0,-1754 # 6680 <malloc+0x634>
     d62:	00005097          	auipc	ra,0x5
     d66:	ef8080e7          	jalr	-264(ra) # 5c5a <open>
  if (fd < 0) {
     d6a:	0e054563          	bltz	a0,e54 <unlinkread+0x10e>
     d6e:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     d70:	4615                	li	a2,5
     d72:	00006597          	auipc	a1,0x6
     d76:	93e58593          	addi	a1,a1,-1730 # 66b0 <malloc+0x664>
     d7a:	00005097          	auipc	ra,0x5
     d7e:	ec0080e7          	jalr	-320(ra) # 5c3a <write>
  close(fd);
     d82:	8526                	mv	a0,s1
     d84:	00005097          	auipc	ra,0x5
     d88:	ebe080e7          	jalr	-322(ra) # 5c42 <close>
  fd = open("unlinkread", O_RDWR);
     d8c:	4589                	li	a1,2
     d8e:	00006517          	auipc	a0,0x6
     d92:	8f250513          	addi	a0,a0,-1806 # 6680 <malloc+0x634>
     d96:	00005097          	auipc	ra,0x5
     d9a:	ec4080e7          	jalr	-316(ra) # 5c5a <open>
     d9e:	84aa                	mv	s1,a0
  if (fd < 0) {
     da0:	0c054863          	bltz	a0,e70 <unlinkread+0x12a>
  if (unlink("unlinkread") != 0) {
     da4:	00006517          	auipc	a0,0x6
     da8:	8dc50513          	addi	a0,a0,-1828 # 6680 <malloc+0x634>
     dac:	00005097          	auipc	ra,0x5
     db0:	ebe080e7          	jalr	-322(ra) # 5c6a <unlink>
     db4:	ed61                	bnez	a0,e8c <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     db6:	20200593          	li	a1,514
     dba:	00006517          	auipc	a0,0x6
     dbe:	8c650513          	addi	a0,a0,-1850 # 6680 <malloc+0x634>
     dc2:	00005097          	auipc	ra,0x5
     dc6:	e98080e7          	jalr	-360(ra) # 5c5a <open>
     dca:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     dcc:	460d                	li	a2,3
     dce:	00006597          	auipc	a1,0x6
     dd2:	92a58593          	addi	a1,a1,-1750 # 66f8 <malloc+0x6ac>
     dd6:	00005097          	auipc	ra,0x5
     dda:	e64080e7          	jalr	-412(ra) # 5c3a <write>
  close(fd1);
     dde:	854a                	mv	a0,s2
     de0:	00005097          	auipc	ra,0x5
     de4:	e62080e7          	jalr	-414(ra) # 5c42 <close>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     de8:	660d                	lui	a2,0x3
     dea:	0000c597          	auipc	a1,0xc
     dee:	e8e58593          	addi	a1,a1,-370 # cc78 <buf>
     df2:	8526                	mv	a0,s1
     df4:	00005097          	auipc	ra,0x5
     df8:	e3e080e7          	jalr	-450(ra) # 5c32 <read>
     dfc:	4795                	li	a5,5
     dfe:	0af51563          	bne	a0,a5,ea8 <unlinkread+0x162>
  if (buf[0] != 'h') {
     e02:	0000c717          	auipc	a4,0xc
     e06:	e7674703          	lbu	a4,-394(a4) # cc78 <buf>
     e0a:	06800793          	li	a5,104
     e0e:	0af71b63          	bne	a4,a5,ec4 <unlinkread+0x17e>
  if (write(fd, buf, 10) != 10) {
     e12:	4629                	li	a2,10
     e14:	0000c597          	auipc	a1,0xc
     e18:	e6458593          	addi	a1,a1,-412 # cc78 <buf>
     e1c:	8526                	mv	a0,s1
     e1e:	00005097          	auipc	ra,0x5
     e22:	e1c080e7          	jalr	-484(ra) # 5c3a <write>
     e26:	47a9                	li	a5,10
     e28:	0af51c63          	bne	a0,a5,ee0 <unlinkread+0x19a>
  close(fd);
     e2c:	8526                	mv	a0,s1
     e2e:	00005097          	auipc	ra,0x5
     e32:	e14080e7          	jalr	-492(ra) # 5c42 <close>
  unlink("unlinkread");
     e36:	00006517          	auipc	a0,0x6
     e3a:	84a50513          	addi	a0,a0,-1974 # 6680 <malloc+0x634>
     e3e:	00005097          	auipc	ra,0x5
     e42:	e2c080e7          	jalr	-468(ra) # 5c6a <unlink>
}
     e46:	70a2                	ld	ra,40(sp)
     e48:	7402                	ld	s0,32(sp)
     e4a:	64e2                	ld	s1,24(sp)
     e4c:	6942                	ld	s2,16(sp)
     e4e:	69a2                	ld	s3,8(sp)
     e50:	6145                	addi	sp,sp,48
     e52:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     e54:	85ce                	mv	a1,s3
     e56:	00006517          	auipc	a0,0x6
     e5a:	83a50513          	addi	a0,a0,-1990 # 6690 <malloc+0x644>
     e5e:	00005097          	auipc	ra,0x5
     e62:	136080e7          	jalr	310(ra) # 5f94 <printf>
    exit(1);
     e66:	4505                	li	a0,1
     e68:	00005097          	auipc	ra,0x5
     e6c:	db2080e7          	jalr	-590(ra) # 5c1a <exit>
    printf("%s: open unlinkread failed\n", s);
     e70:	85ce                	mv	a1,s3
     e72:	00006517          	auipc	a0,0x6
     e76:	84650513          	addi	a0,a0,-1978 # 66b8 <malloc+0x66c>
     e7a:	00005097          	auipc	ra,0x5
     e7e:	11a080e7          	jalr	282(ra) # 5f94 <printf>
    exit(1);
     e82:	4505                	li	a0,1
     e84:	00005097          	auipc	ra,0x5
     e88:	d96080e7          	jalr	-618(ra) # 5c1a <exit>
    printf("%s: unlink unlinkread failed\n", s);
     e8c:	85ce                	mv	a1,s3
     e8e:	00006517          	auipc	a0,0x6
     e92:	84a50513          	addi	a0,a0,-1974 # 66d8 <malloc+0x68c>
     e96:	00005097          	auipc	ra,0x5
     e9a:	0fe080e7          	jalr	254(ra) # 5f94 <printf>
    exit(1);
     e9e:	4505                	li	a0,1
     ea0:	00005097          	auipc	ra,0x5
     ea4:	d7a080e7          	jalr	-646(ra) # 5c1a <exit>
    printf("%s: unlinkread read failed", s);
     ea8:	85ce                	mv	a1,s3
     eaa:	00006517          	auipc	a0,0x6
     eae:	85650513          	addi	a0,a0,-1962 # 6700 <malloc+0x6b4>
     eb2:	00005097          	auipc	ra,0x5
     eb6:	0e2080e7          	jalr	226(ra) # 5f94 <printf>
    exit(1);
     eba:	4505                	li	a0,1
     ebc:	00005097          	auipc	ra,0x5
     ec0:	d5e080e7          	jalr	-674(ra) # 5c1a <exit>
    printf("%s: unlinkread wrong data\n", s);
     ec4:	85ce                	mv	a1,s3
     ec6:	00006517          	auipc	a0,0x6
     eca:	85a50513          	addi	a0,a0,-1958 # 6720 <malloc+0x6d4>
     ece:	00005097          	auipc	ra,0x5
     ed2:	0c6080e7          	jalr	198(ra) # 5f94 <printf>
    exit(1);
     ed6:	4505                	li	a0,1
     ed8:	00005097          	auipc	ra,0x5
     edc:	d42080e7          	jalr	-702(ra) # 5c1a <exit>
    printf("%s: unlinkread write failed\n", s);
     ee0:	85ce                	mv	a1,s3
     ee2:	00006517          	auipc	a0,0x6
     ee6:	85e50513          	addi	a0,a0,-1954 # 6740 <malloc+0x6f4>
     eea:	00005097          	auipc	ra,0x5
     eee:	0aa080e7          	jalr	170(ra) # 5f94 <printf>
    exit(1);
     ef2:	4505                	li	a0,1
     ef4:	00005097          	auipc	ra,0x5
     ef8:	d26080e7          	jalr	-730(ra) # 5c1a <exit>

0000000000000efc <linktest>:
void linktest(char *s) {
     efc:	1101                	addi	sp,sp,-32
     efe:	ec06                	sd	ra,24(sp)
     f00:	e822                	sd	s0,16(sp)
     f02:	e426                	sd	s1,8(sp)
     f04:	e04a                	sd	s2,0(sp)
     f06:	1000                	addi	s0,sp,32
     f08:	892a                	mv	s2,a0
  unlink("lf1");
     f0a:	00006517          	auipc	a0,0x6
     f0e:	85650513          	addi	a0,a0,-1962 # 6760 <malloc+0x714>
     f12:	00005097          	auipc	ra,0x5
     f16:	d58080e7          	jalr	-680(ra) # 5c6a <unlink>
  unlink("lf2");
     f1a:	00006517          	auipc	a0,0x6
     f1e:	84e50513          	addi	a0,a0,-1970 # 6768 <malloc+0x71c>
     f22:	00005097          	auipc	ra,0x5
     f26:	d48080e7          	jalr	-696(ra) # 5c6a <unlink>
  fd = open("lf1", O_CREATE | O_RDWR);
     f2a:	20200593          	li	a1,514
     f2e:	00006517          	auipc	a0,0x6
     f32:	83250513          	addi	a0,a0,-1998 # 6760 <malloc+0x714>
     f36:	00005097          	auipc	ra,0x5
     f3a:	d24080e7          	jalr	-732(ra) # 5c5a <open>
  if (fd < 0) {
     f3e:	10054763          	bltz	a0,104c <linktest+0x150>
     f42:	84aa                	mv	s1,a0
  if (write(fd, "hello", SZ) != SZ) {
     f44:	4615                	li	a2,5
     f46:	00005597          	auipc	a1,0x5
     f4a:	76a58593          	addi	a1,a1,1898 # 66b0 <malloc+0x664>
     f4e:	00005097          	auipc	ra,0x5
     f52:	cec080e7          	jalr	-788(ra) # 5c3a <write>
     f56:	4795                	li	a5,5
     f58:	10f51863          	bne	a0,a5,1068 <linktest+0x16c>
  close(fd);
     f5c:	8526                	mv	a0,s1
     f5e:	00005097          	auipc	ra,0x5
     f62:	ce4080e7          	jalr	-796(ra) # 5c42 <close>
  if (link("lf1", "lf2") < 0) {
     f66:	00006597          	auipc	a1,0x6
     f6a:	80258593          	addi	a1,a1,-2046 # 6768 <malloc+0x71c>
     f6e:	00005517          	auipc	a0,0x5
     f72:	7f250513          	addi	a0,a0,2034 # 6760 <malloc+0x714>
     f76:	00005097          	auipc	ra,0x5
     f7a:	d04080e7          	jalr	-764(ra) # 5c7a <link>
     f7e:	10054363          	bltz	a0,1084 <linktest+0x188>
  unlink("lf1");
     f82:	00005517          	auipc	a0,0x5
     f86:	7de50513          	addi	a0,a0,2014 # 6760 <malloc+0x714>
     f8a:	00005097          	auipc	ra,0x5
     f8e:	ce0080e7          	jalr	-800(ra) # 5c6a <unlink>
  if (open("lf1", 0) >= 0) {
     f92:	4581                	li	a1,0
     f94:	00005517          	auipc	a0,0x5
     f98:	7cc50513          	addi	a0,a0,1996 # 6760 <malloc+0x714>
     f9c:	00005097          	auipc	ra,0x5
     fa0:	cbe080e7          	jalr	-834(ra) # 5c5a <open>
     fa4:	0e055e63          	bgez	a0,10a0 <linktest+0x1a4>
  fd = open("lf2", 0);
     fa8:	4581                	li	a1,0
     faa:	00005517          	auipc	a0,0x5
     fae:	7be50513          	addi	a0,a0,1982 # 6768 <malloc+0x71c>
     fb2:	00005097          	auipc	ra,0x5
     fb6:	ca8080e7          	jalr	-856(ra) # 5c5a <open>
     fba:	84aa                	mv	s1,a0
  if (fd < 0) {
     fbc:	10054063          	bltz	a0,10bc <linktest+0x1c0>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     fc0:	660d                	lui	a2,0x3
     fc2:	0000c597          	auipc	a1,0xc
     fc6:	cb658593          	addi	a1,a1,-842 # cc78 <buf>
     fca:	00005097          	auipc	ra,0x5
     fce:	c68080e7          	jalr	-920(ra) # 5c32 <read>
     fd2:	4795                	li	a5,5
     fd4:	10f51263          	bne	a0,a5,10d8 <linktest+0x1dc>
  close(fd);
     fd8:	8526                	mv	a0,s1
     fda:	00005097          	auipc	ra,0x5
     fde:	c68080e7          	jalr	-920(ra) # 5c42 <close>
  if (link("lf2", "lf2") >= 0) {
     fe2:	00005597          	auipc	a1,0x5
     fe6:	78658593          	addi	a1,a1,1926 # 6768 <malloc+0x71c>
     fea:	852e                	mv	a0,a1
     fec:	00005097          	auipc	ra,0x5
     ff0:	c8e080e7          	jalr	-882(ra) # 5c7a <link>
     ff4:	10055063          	bgez	a0,10f4 <linktest+0x1f8>
  unlink("lf2");
     ff8:	00005517          	auipc	a0,0x5
     ffc:	77050513          	addi	a0,a0,1904 # 6768 <malloc+0x71c>
    1000:	00005097          	auipc	ra,0x5
    1004:	c6a080e7          	jalr	-918(ra) # 5c6a <unlink>
  if (link("lf2", "lf1") >= 0) {
    1008:	00005597          	auipc	a1,0x5
    100c:	75858593          	addi	a1,a1,1880 # 6760 <malloc+0x714>
    1010:	00005517          	auipc	a0,0x5
    1014:	75850513          	addi	a0,a0,1880 # 6768 <malloc+0x71c>
    1018:	00005097          	auipc	ra,0x5
    101c:	c62080e7          	jalr	-926(ra) # 5c7a <link>
    1020:	0e055863          	bgez	a0,1110 <linktest+0x214>
  if (link(".", "lf1") >= 0) {
    1024:	00005597          	auipc	a1,0x5
    1028:	73c58593          	addi	a1,a1,1852 # 6760 <malloc+0x714>
    102c:	00006517          	auipc	a0,0x6
    1030:	84450513          	addi	a0,a0,-1980 # 6870 <malloc+0x824>
    1034:	00005097          	auipc	ra,0x5
    1038:	c46080e7          	jalr	-954(ra) # 5c7a <link>
    103c:	0e055863          	bgez	a0,112c <linktest+0x230>
}
    1040:	60e2                	ld	ra,24(sp)
    1042:	6442                	ld	s0,16(sp)
    1044:	64a2                	ld	s1,8(sp)
    1046:	6902                	ld	s2,0(sp)
    1048:	6105                	addi	sp,sp,32
    104a:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    104c:	85ca                	mv	a1,s2
    104e:	00005517          	auipc	a0,0x5
    1052:	72250513          	addi	a0,a0,1826 # 6770 <malloc+0x724>
    1056:	00005097          	auipc	ra,0x5
    105a:	f3e080e7          	jalr	-194(ra) # 5f94 <printf>
    exit(1);
    105e:	4505                	li	a0,1
    1060:	00005097          	auipc	ra,0x5
    1064:	bba080e7          	jalr	-1094(ra) # 5c1a <exit>
    printf("%s: write lf1 failed\n", s);
    1068:	85ca                	mv	a1,s2
    106a:	00005517          	auipc	a0,0x5
    106e:	71e50513          	addi	a0,a0,1822 # 6788 <malloc+0x73c>
    1072:	00005097          	auipc	ra,0x5
    1076:	f22080e7          	jalr	-222(ra) # 5f94 <printf>
    exit(1);
    107a:	4505                	li	a0,1
    107c:	00005097          	auipc	ra,0x5
    1080:	b9e080e7          	jalr	-1122(ra) # 5c1a <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    1084:	85ca                	mv	a1,s2
    1086:	00005517          	auipc	a0,0x5
    108a:	71a50513          	addi	a0,a0,1818 # 67a0 <malloc+0x754>
    108e:	00005097          	auipc	ra,0x5
    1092:	f06080e7          	jalr	-250(ra) # 5f94 <printf>
    exit(1);
    1096:	4505                	li	a0,1
    1098:	00005097          	auipc	ra,0x5
    109c:	b82080e7          	jalr	-1150(ra) # 5c1a <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    10a0:	85ca                	mv	a1,s2
    10a2:	00005517          	auipc	a0,0x5
    10a6:	71e50513          	addi	a0,a0,1822 # 67c0 <malloc+0x774>
    10aa:	00005097          	auipc	ra,0x5
    10ae:	eea080e7          	jalr	-278(ra) # 5f94 <printf>
    exit(1);
    10b2:	4505                	li	a0,1
    10b4:	00005097          	auipc	ra,0x5
    10b8:	b66080e7          	jalr	-1178(ra) # 5c1a <exit>
    printf("%s: open lf2 failed\n", s);
    10bc:	85ca                	mv	a1,s2
    10be:	00005517          	auipc	a0,0x5
    10c2:	73250513          	addi	a0,a0,1842 # 67f0 <malloc+0x7a4>
    10c6:	00005097          	auipc	ra,0x5
    10ca:	ece080e7          	jalr	-306(ra) # 5f94 <printf>
    exit(1);
    10ce:	4505                	li	a0,1
    10d0:	00005097          	auipc	ra,0x5
    10d4:	b4a080e7          	jalr	-1206(ra) # 5c1a <exit>
    printf("%s: read lf2 failed\n", s);
    10d8:	85ca                	mv	a1,s2
    10da:	00005517          	auipc	a0,0x5
    10de:	72e50513          	addi	a0,a0,1838 # 6808 <malloc+0x7bc>
    10e2:	00005097          	auipc	ra,0x5
    10e6:	eb2080e7          	jalr	-334(ra) # 5f94 <printf>
    exit(1);
    10ea:	4505                	li	a0,1
    10ec:	00005097          	auipc	ra,0x5
    10f0:	b2e080e7          	jalr	-1234(ra) # 5c1a <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    10f4:	85ca                	mv	a1,s2
    10f6:	00005517          	auipc	a0,0x5
    10fa:	72a50513          	addi	a0,a0,1834 # 6820 <malloc+0x7d4>
    10fe:	00005097          	auipc	ra,0x5
    1102:	e96080e7          	jalr	-362(ra) # 5f94 <printf>
    exit(1);
    1106:	4505                	li	a0,1
    1108:	00005097          	auipc	ra,0x5
    110c:	b12080e7          	jalr	-1262(ra) # 5c1a <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    1110:	85ca                	mv	a1,s2
    1112:	00005517          	auipc	a0,0x5
    1116:	73650513          	addi	a0,a0,1846 # 6848 <malloc+0x7fc>
    111a:	00005097          	auipc	ra,0x5
    111e:	e7a080e7          	jalr	-390(ra) # 5f94 <printf>
    exit(1);
    1122:	4505                	li	a0,1
    1124:	00005097          	auipc	ra,0x5
    1128:	af6080e7          	jalr	-1290(ra) # 5c1a <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    112c:	85ca                	mv	a1,s2
    112e:	00005517          	auipc	a0,0x5
    1132:	74a50513          	addi	a0,a0,1866 # 6878 <malloc+0x82c>
    1136:	00005097          	auipc	ra,0x5
    113a:	e5e080e7          	jalr	-418(ra) # 5f94 <printf>
    exit(1);
    113e:	4505                	li	a0,1
    1140:	00005097          	auipc	ra,0x5
    1144:	ada080e7          	jalr	-1318(ra) # 5c1a <exit>

0000000000001148 <validatetest>:
void validatetest(char *s) {
    1148:	7139                	addi	sp,sp,-64
    114a:	fc06                	sd	ra,56(sp)
    114c:	f822                	sd	s0,48(sp)
    114e:	f426                	sd	s1,40(sp)
    1150:	f04a                	sd	s2,32(sp)
    1152:	ec4e                	sd	s3,24(sp)
    1154:	e852                	sd	s4,16(sp)
    1156:	e456                	sd	s5,8(sp)
    1158:	e05a                	sd	s6,0(sp)
    115a:	0080                	addi	s0,sp,64
    115c:	8b2a                	mv	s6,a0
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
    115e:	4481                	li	s1,0
    if (link("nosuchfile", (char *)p) != -1) {
    1160:	00005997          	auipc	s3,0x5
    1164:	73898993          	addi	s3,s3,1848 # 6898 <malloc+0x84c>
    1168:	597d                	li	s2,-1
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
    116a:	6a85                	lui	s5,0x1
    116c:	00114a37          	lui	s4,0x114
    if (link("nosuchfile", (char *)p) != -1) {
    1170:	85a6                	mv	a1,s1
    1172:	854e                	mv	a0,s3
    1174:	00005097          	auipc	ra,0x5
    1178:	b06080e7          	jalr	-1274(ra) # 5c7a <link>
    117c:	01251f63          	bne	a0,s2,119a <validatetest+0x52>
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
    1180:	94d6                	add	s1,s1,s5
    1182:	ff4497e3          	bne	s1,s4,1170 <validatetest+0x28>
}
    1186:	70e2                	ld	ra,56(sp)
    1188:	7442                	ld	s0,48(sp)
    118a:	74a2                	ld	s1,40(sp)
    118c:	7902                	ld	s2,32(sp)
    118e:	69e2                	ld	s3,24(sp)
    1190:	6a42                	ld	s4,16(sp)
    1192:	6aa2                	ld	s5,8(sp)
    1194:	6b02                	ld	s6,0(sp)
    1196:	6121                	addi	sp,sp,64
    1198:	8082                	ret
      printf("%s: link should not succeed\n", s);
    119a:	85da                	mv	a1,s6
    119c:	00005517          	auipc	a0,0x5
    11a0:	70c50513          	addi	a0,a0,1804 # 68a8 <malloc+0x85c>
    11a4:	00005097          	auipc	ra,0x5
    11a8:	df0080e7          	jalr	-528(ra) # 5f94 <printf>
      exit(1);
    11ac:	4505                	li	a0,1
    11ae:	00005097          	auipc	ra,0x5
    11b2:	a6c080e7          	jalr	-1428(ra) # 5c1a <exit>

00000000000011b6 <bigdir>:
void bigdir(char *s) {
    11b6:	715d                	addi	sp,sp,-80
    11b8:	e486                	sd	ra,72(sp)
    11ba:	e0a2                	sd	s0,64(sp)
    11bc:	fc26                	sd	s1,56(sp)
    11be:	f84a                	sd	s2,48(sp)
    11c0:	f44e                	sd	s3,40(sp)
    11c2:	f052                	sd	s4,32(sp)
    11c4:	ec56                	sd	s5,24(sp)
    11c6:	e85a                	sd	s6,16(sp)
    11c8:	0880                	addi	s0,sp,80
    11ca:	89aa                	mv	s3,a0
  unlink("bd");
    11cc:	00005517          	auipc	a0,0x5
    11d0:	6fc50513          	addi	a0,a0,1788 # 68c8 <malloc+0x87c>
    11d4:	00005097          	auipc	ra,0x5
    11d8:	a96080e7          	jalr	-1386(ra) # 5c6a <unlink>
  fd = open("bd", O_CREATE);
    11dc:	20000593          	li	a1,512
    11e0:	00005517          	auipc	a0,0x5
    11e4:	6e850513          	addi	a0,a0,1768 # 68c8 <malloc+0x87c>
    11e8:	00005097          	auipc	ra,0x5
    11ec:	a72080e7          	jalr	-1422(ra) # 5c5a <open>
  if (fd < 0) {
    11f0:	0c054963          	bltz	a0,12c2 <bigdir+0x10c>
  close(fd);
    11f4:	00005097          	auipc	ra,0x5
    11f8:	a4e080e7          	jalr	-1458(ra) # 5c42 <close>
  for (i = 0; i < N; i++) {
    11fc:	4901                	li	s2,0
    name[0] = 'x';
    11fe:	07800a93          	li	s5,120
    if (link("bd", name) != 0) {
    1202:	00005a17          	auipc	s4,0x5
    1206:	6c6a0a13          	addi	s4,s4,1734 # 68c8 <malloc+0x87c>
  for (i = 0; i < N; i++) {
    120a:	1f400b13          	li	s6,500
    name[0] = 'x';
    120e:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    1212:	41f9571b          	sraiw	a4,s2,0x1f
    1216:	01a7571b          	srliw	a4,a4,0x1a
    121a:	012707bb          	addw	a5,a4,s2
    121e:	4067d69b          	sraiw	a3,a5,0x6
    1222:	0306869b          	addiw	a3,a3,48
    1226:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    122a:	03f7f793          	andi	a5,a5,63
    122e:	9f99                	subw	a5,a5,a4
    1230:	0307879b          	addiw	a5,a5,48
    1234:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1238:	fa0409a3          	sb	zero,-77(s0)
    if (link("bd", name) != 0) {
    123c:	fb040593          	addi	a1,s0,-80
    1240:	8552                	mv	a0,s4
    1242:	00005097          	auipc	ra,0x5
    1246:	a38080e7          	jalr	-1480(ra) # 5c7a <link>
    124a:	84aa                	mv	s1,a0
    124c:	e949                	bnez	a0,12de <bigdir+0x128>
  for (i = 0; i < N; i++) {
    124e:	2905                	addiw	s2,s2,1
    1250:	fb691fe3          	bne	s2,s6,120e <bigdir+0x58>
  unlink("bd");
    1254:	00005517          	auipc	a0,0x5
    1258:	67450513          	addi	a0,a0,1652 # 68c8 <malloc+0x87c>
    125c:	00005097          	auipc	ra,0x5
    1260:	a0e080e7          	jalr	-1522(ra) # 5c6a <unlink>
    name[0] = 'x';
    1264:	07800913          	li	s2,120
  for (i = 0; i < N; i++) {
    1268:	1f400a13          	li	s4,500
    name[0] = 'x';
    126c:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1270:	41f4d71b          	sraiw	a4,s1,0x1f
    1274:	01a7571b          	srliw	a4,a4,0x1a
    1278:	009707bb          	addw	a5,a4,s1
    127c:	4067d69b          	sraiw	a3,a5,0x6
    1280:	0306869b          	addiw	a3,a3,48
    1284:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1288:	03f7f793          	andi	a5,a5,63
    128c:	9f99                	subw	a5,a5,a4
    128e:	0307879b          	addiw	a5,a5,48
    1292:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1296:	fa0409a3          	sb	zero,-77(s0)
    if (unlink(name) != 0) {
    129a:	fb040513          	addi	a0,s0,-80
    129e:	00005097          	auipc	ra,0x5
    12a2:	9cc080e7          	jalr	-1588(ra) # 5c6a <unlink>
    12a6:	ed21                	bnez	a0,12fe <bigdir+0x148>
  for (i = 0; i < N; i++) {
    12a8:	2485                	addiw	s1,s1,1
    12aa:	fd4491e3          	bne	s1,s4,126c <bigdir+0xb6>
}
    12ae:	60a6                	ld	ra,72(sp)
    12b0:	6406                	ld	s0,64(sp)
    12b2:	74e2                	ld	s1,56(sp)
    12b4:	7942                	ld	s2,48(sp)
    12b6:	79a2                	ld	s3,40(sp)
    12b8:	7a02                	ld	s4,32(sp)
    12ba:	6ae2                	ld	s5,24(sp)
    12bc:	6b42                	ld	s6,16(sp)
    12be:	6161                	addi	sp,sp,80
    12c0:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    12c2:	85ce                	mv	a1,s3
    12c4:	00005517          	auipc	a0,0x5
    12c8:	60c50513          	addi	a0,a0,1548 # 68d0 <malloc+0x884>
    12cc:	00005097          	auipc	ra,0x5
    12d0:	cc8080e7          	jalr	-824(ra) # 5f94 <printf>
    exit(1);
    12d4:	4505                	li	a0,1
    12d6:	00005097          	auipc	ra,0x5
    12da:	944080e7          	jalr	-1724(ra) # 5c1a <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    12de:	fb040613          	addi	a2,s0,-80
    12e2:	85ce                	mv	a1,s3
    12e4:	00005517          	auipc	a0,0x5
    12e8:	60c50513          	addi	a0,a0,1548 # 68f0 <malloc+0x8a4>
    12ec:	00005097          	auipc	ra,0x5
    12f0:	ca8080e7          	jalr	-856(ra) # 5f94 <printf>
      exit(1);
    12f4:	4505                	li	a0,1
    12f6:	00005097          	auipc	ra,0x5
    12fa:	924080e7          	jalr	-1756(ra) # 5c1a <exit>
      printf("%s: bigdir unlink failed", s);
    12fe:	85ce                	mv	a1,s3
    1300:	00005517          	auipc	a0,0x5
    1304:	61050513          	addi	a0,a0,1552 # 6910 <malloc+0x8c4>
    1308:	00005097          	auipc	ra,0x5
    130c:	c8c080e7          	jalr	-884(ra) # 5f94 <printf>
      exit(1);
    1310:	4505                	li	a0,1
    1312:	00005097          	auipc	ra,0x5
    1316:	908080e7          	jalr	-1784(ra) # 5c1a <exit>

000000000000131a <pgbug>:
void pgbug(char *s) {
    131a:	7179                	addi	sp,sp,-48
    131c:	f406                	sd	ra,40(sp)
    131e:	f022                	sd	s0,32(sp)
    1320:	ec26                	sd	s1,24(sp)
    1322:	1800                	addi	s0,sp,48
  argv[0] = 0;
    1324:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1328:	00008497          	auipc	s1,0x8
    132c:	cd848493          	addi	s1,s1,-808 # 9000 <big>
    1330:	fd840593          	addi	a1,s0,-40
    1334:	6088                	ld	a0,0(s1)
    1336:	00005097          	auipc	ra,0x5
    133a:	91c080e7          	jalr	-1764(ra) # 5c52 <exec>
  pipe(big);
    133e:	6088                	ld	a0,0(s1)
    1340:	00005097          	auipc	ra,0x5
    1344:	8ea080e7          	jalr	-1814(ra) # 5c2a <pipe>
  exit(0);
    1348:	4501                	li	a0,0
    134a:	00005097          	auipc	ra,0x5
    134e:	8d0080e7          	jalr	-1840(ra) # 5c1a <exit>

0000000000001352 <badarg>:
void badarg(char *s) {
    1352:	7139                	addi	sp,sp,-64
    1354:	fc06                	sd	ra,56(sp)
    1356:	f822                	sd	s0,48(sp)
    1358:	f426                	sd	s1,40(sp)
    135a:	f04a                	sd	s2,32(sp)
    135c:	ec4e                	sd	s3,24(sp)
    135e:	0080                	addi	s0,sp,64
    1360:	64b1                	lui	s1,0xc
    1362:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1de8>
    argv[0] = (char *)0xffffffff;
    1366:	597d                	li	s2,-1
    1368:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    136c:	00005997          	auipc	s3,0x5
    1370:	e0c98993          	addi	s3,s3,-500 # 6178 <malloc+0x12c>
    argv[0] = (char *)0xffffffff;
    1374:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1378:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    137c:	fc040593          	addi	a1,s0,-64
    1380:	854e                	mv	a0,s3
    1382:	00005097          	auipc	ra,0x5
    1386:	8d0080e7          	jalr	-1840(ra) # 5c52 <exec>
  for (int i = 0; i < 50000; i++) {
    138a:	34fd                	addiw	s1,s1,-1
    138c:	f4e5                	bnez	s1,1374 <badarg+0x22>
  exit(0);
    138e:	4501                	li	a0,0
    1390:	00005097          	auipc	ra,0x5
    1394:	88a080e7          	jalr	-1910(ra) # 5c1a <exit>

0000000000001398 <copyinstr2>:
void copyinstr2(char *s) {
    1398:	7155                	addi	sp,sp,-208
    139a:	e586                	sd	ra,200(sp)
    139c:	e1a2                	sd	s0,192(sp)
    139e:	0980                	addi	s0,sp,208
  for (int i = 0; i < MAXPATH; i++) b[i] = 'x';
    13a0:	f6840793          	addi	a5,s0,-152
    13a4:	fe840693          	addi	a3,s0,-24
    13a8:	07800713          	li	a4,120
    13ac:	00e78023          	sb	a4,0(a5)
    13b0:	0785                	addi	a5,a5,1
    13b2:	fed79de3          	bne	a5,a3,13ac <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    13b6:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    13ba:	f6840513          	addi	a0,s0,-152
    13be:	00005097          	auipc	ra,0x5
    13c2:	8ac080e7          	jalr	-1876(ra) # 5c6a <unlink>
  if (ret != -1) {
    13c6:	57fd                	li	a5,-1
    13c8:	0ef51063          	bne	a0,a5,14a8 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    13cc:	20100593          	li	a1,513
    13d0:	f6840513          	addi	a0,s0,-152
    13d4:	00005097          	auipc	ra,0x5
    13d8:	886080e7          	jalr	-1914(ra) # 5c5a <open>
  if (fd != -1) {
    13dc:	57fd                	li	a5,-1
    13de:	0ef51563          	bne	a0,a5,14c8 <copyinstr2+0x130>
  ret = link(b, b);
    13e2:	f6840593          	addi	a1,s0,-152
    13e6:	852e                	mv	a0,a1
    13e8:	00005097          	auipc	ra,0x5
    13ec:	892080e7          	jalr	-1902(ra) # 5c7a <link>
  if (ret != -1) {
    13f0:	57fd                	li	a5,-1
    13f2:	0ef51b63          	bne	a0,a5,14e8 <copyinstr2+0x150>
  char *args[] = {"xx", 0};
    13f6:	00006797          	auipc	a5,0x6
    13fa:	77278793          	addi	a5,a5,1906 # 7b68 <malloc+0x1b1c>
    13fe:	f4f43c23          	sd	a5,-168(s0)
    1402:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1406:	f5840593          	addi	a1,s0,-168
    140a:	f6840513          	addi	a0,s0,-152
    140e:	00005097          	auipc	ra,0x5
    1412:	844080e7          	jalr	-1980(ra) # 5c52 <exec>
  if (ret != -1) {
    1416:	57fd                	li	a5,-1
    1418:	0ef51963          	bne	a0,a5,150a <copyinstr2+0x172>
  int pid = fork();
    141c:	00004097          	auipc	ra,0x4
    1420:	7f6080e7          	jalr	2038(ra) # 5c12 <fork>
  if (pid < 0) {
    1424:	10054363          	bltz	a0,152a <copyinstr2+0x192>
  if (pid == 0) {
    1428:	12051463          	bnez	a0,1550 <copyinstr2+0x1b8>
    142c:	00008797          	auipc	a5,0x8
    1430:	13478793          	addi	a5,a5,308 # 9560 <big.0>
    1434:	00009697          	auipc	a3,0x9
    1438:	12c68693          	addi	a3,a3,300 # a560 <big.0+0x1000>
    for (int i = 0; i < PGSIZE; i++) big[i] = 'x';
    143c:	07800713          	li	a4,120
    1440:	00e78023          	sb	a4,0(a5)
    1444:	0785                	addi	a5,a5,1
    1446:	fed79de3          	bne	a5,a3,1440 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    144a:	00009797          	auipc	a5,0x9
    144e:	10078b23          	sb	zero,278(a5) # a560 <big.0+0x1000>
    char *args2[] = {big, big, big, 0};
    1452:	00007797          	auipc	a5,0x7
    1456:	17678793          	addi	a5,a5,374 # 85c8 <malloc+0x257c>
    145a:	6390                	ld	a2,0(a5)
    145c:	6794                	ld	a3,8(a5)
    145e:	6b98                	ld	a4,16(a5)
    1460:	6f9c                	ld	a5,24(a5)
    1462:	f2c43823          	sd	a2,-208(s0)
    1466:	f2d43c23          	sd	a3,-200(s0)
    146a:	f4e43023          	sd	a4,-192(s0)
    146e:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1472:	f3040593          	addi	a1,s0,-208
    1476:	00005517          	auipc	a0,0x5
    147a:	d0250513          	addi	a0,a0,-766 # 6178 <malloc+0x12c>
    147e:	00004097          	auipc	ra,0x4
    1482:	7d4080e7          	jalr	2004(ra) # 5c52 <exec>
    if (ret != -1) {
    1486:	57fd                	li	a5,-1
    1488:	0af50e63          	beq	a0,a5,1544 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    148c:	55fd                	li	a1,-1
    148e:	00005517          	auipc	a0,0x5
    1492:	52a50513          	addi	a0,a0,1322 # 69b8 <malloc+0x96c>
    1496:	00005097          	auipc	ra,0x5
    149a:	afe080e7          	jalr	-1282(ra) # 5f94 <printf>
      exit(1);
    149e:	4505                	li	a0,1
    14a0:	00004097          	auipc	ra,0x4
    14a4:	77a080e7          	jalr	1914(ra) # 5c1a <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    14a8:	862a                	mv	a2,a0
    14aa:	f6840593          	addi	a1,s0,-152
    14ae:	00005517          	auipc	a0,0x5
    14b2:	48250513          	addi	a0,a0,1154 # 6930 <malloc+0x8e4>
    14b6:	00005097          	auipc	ra,0x5
    14ba:	ade080e7          	jalr	-1314(ra) # 5f94 <printf>
    exit(1);
    14be:	4505                	li	a0,1
    14c0:	00004097          	auipc	ra,0x4
    14c4:	75a080e7          	jalr	1882(ra) # 5c1a <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    14c8:	862a                	mv	a2,a0
    14ca:	f6840593          	addi	a1,s0,-152
    14ce:	00005517          	auipc	a0,0x5
    14d2:	48250513          	addi	a0,a0,1154 # 6950 <malloc+0x904>
    14d6:	00005097          	auipc	ra,0x5
    14da:	abe080e7          	jalr	-1346(ra) # 5f94 <printf>
    exit(1);
    14de:	4505                	li	a0,1
    14e0:	00004097          	auipc	ra,0x4
    14e4:	73a080e7          	jalr	1850(ra) # 5c1a <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    14e8:	86aa                	mv	a3,a0
    14ea:	f6840613          	addi	a2,s0,-152
    14ee:	85b2                	mv	a1,a2
    14f0:	00005517          	auipc	a0,0x5
    14f4:	48050513          	addi	a0,a0,1152 # 6970 <malloc+0x924>
    14f8:	00005097          	auipc	ra,0x5
    14fc:	a9c080e7          	jalr	-1380(ra) # 5f94 <printf>
    exit(1);
    1500:	4505                	li	a0,1
    1502:	00004097          	auipc	ra,0x4
    1506:	718080e7          	jalr	1816(ra) # 5c1a <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    150a:	567d                	li	a2,-1
    150c:	f6840593          	addi	a1,s0,-152
    1510:	00005517          	auipc	a0,0x5
    1514:	48850513          	addi	a0,a0,1160 # 6998 <malloc+0x94c>
    1518:	00005097          	auipc	ra,0x5
    151c:	a7c080e7          	jalr	-1412(ra) # 5f94 <printf>
    exit(1);
    1520:	4505                	li	a0,1
    1522:	00004097          	auipc	ra,0x4
    1526:	6f8080e7          	jalr	1784(ra) # 5c1a <exit>
    printf("fork failed\n");
    152a:	00006517          	auipc	a0,0x6
    152e:	8ee50513          	addi	a0,a0,-1810 # 6e18 <malloc+0xdcc>
    1532:	00005097          	auipc	ra,0x5
    1536:	a62080e7          	jalr	-1438(ra) # 5f94 <printf>
    exit(1);
    153a:	4505                	li	a0,1
    153c:	00004097          	auipc	ra,0x4
    1540:	6de080e7          	jalr	1758(ra) # 5c1a <exit>
    exit(747);  // OK
    1544:	2eb00513          	li	a0,747
    1548:	00004097          	auipc	ra,0x4
    154c:	6d2080e7          	jalr	1746(ra) # 5c1a <exit>
  int st = 0;
    1550:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1554:	f5440513          	addi	a0,s0,-172
    1558:	00004097          	auipc	ra,0x4
    155c:	6ca080e7          	jalr	1738(ra) # 5c22 <wait>
  if (st != 747) {
    1560:	f5442703          	lw	a4,-172(s0)
    1564:	2eb00793          	li	a5,747
    1568:	00f71663          	bne	a4,a5,1574 <copyinstr2+0x1dc>
}
    156c:	60ae                	ld	ra,200(sp)
    156e:	640e                	ld	s0,192(sp)
    1570:	6169                	addi	sp,sp,208
    1572:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1574:	00005517          	auipc	a0,0x5
    1578:	46c50513          	addi	a0,a0,1132 # 69e0 <malloc+0x994>
    157c:	00005097          	auipc	ra,0x5
    1580:	a18080e7          	jalr	-1512(ra) # 5f94 <printf>
    exit(1);
    1584:	4505                	li	a0,1
    1586:	00004097          	auipc	ra,0x4
    158a:	694080e7          	jalr	1684(ra) # 5c1a <exit>

000000000000158e <truncate3>:
void truncate3(char *s) {
    158e:	7159                	addi	sp,sp,-112
    1590:	f486                	sd	ra,104(sp)
    1592:	f0a2                	sd	s0,96(sp)
    1594:	eca6                	sd	s1,88(sp)
    1596:	e8ca                	sd	s2,80(sp)
    1598:	e4ce                	sd	s3,72(sp)
    159a:	e0d2                	sd	s4,64(sp)
    159c:	fc56                	sd	s5,56(sp)
    159e:	1880                	addi	s0,sp,112
    15a0:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE | O_TRUNC | O_WRONLY));
    15a2:	60100593          	li	a1,1537
    15a6:	00005517          	auipc	a0,0x5
    15aa:	c2a50513          	addi	a0,a0,-982 # 61d0 <malloc+0x184>
    15ae:	00004097          	auipc	ra,0x4
    15b2:	6ac080e7          	jalr	1708(ra) # 5c5a <open>
    15b6:	00004097          	auipc	ra,0x4
    15ba:	68c080e7          	jalr	1676(ra) # 5c42 <close>
  pid = fork();
    15be:	00004097          	auipc	ra,0x4
    15c2:	654080e7          	jalr	1620(ra) # 5c12 <fork>
  if (pid < 0) {
    15c6:	08054063          	bltz	a0,1646 <truncate3+0xb8>
  if (pid == 0) {
    15ca:	e969                	bnez	a0,169c <truncate3+0x10e>
    15cc:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    15d0:	00005a17          	auipc	s4,0x5
    15d4:	c00a0a13          	addi	s4,s4,-1024 # 61d0 <malloc+0x184>
      int n = write(fd, "1234567890", 10);
    15d8:	00005a97          	auipc	s5,0x5
    15dc:	468a8a93          	addi	s5,s5,1128 # 6a40 <malloc+0x9f4>
      int fd = open("truncfile", O_WRONLY);
    15e0:	4585                	li	a1,1
    15e2:	8552                	mv	a0,s4
    15e4:	00004097          	auipc	ra,0x4
    15e8:	676080e7          	jalr	1654(ra) # 5c5a <open>
    15ec:	84aa                	mv	s1,a0
      if (fd < 0) {
    15ee:	06054a63          	bltz	a0,1662 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    15f2:	4629                	li	a2,10
    15f4:	85d6                	mv	a1,s5
    15f6:	00004097          	auipc	ra,0x4
    15fa:	644080e7          	jalr	1604(ra) # 5c3a <write>
      if (n != 10) {
    15fe:	47a9                	li	a5,10
    1600:	06f51f63          	bne	a0,a5,167e <truncate3+0xf0>
      close(fd);
    1604:	8526                	mv	a0,s1
    1606:	00004097          	auipc	ra,0x4
    160a:	63c080e7          	jalr	1596(ra) # 5c42 <close>
      fd = open("truncfile", O_RDONLY);
    160e:	4581                	li	a1,0
    1610:	8552                	mv	a0,s4
    1612:	00004097          	auipc	ra,0x4
    1616:	648080e7          	jalr	1608(ra) # 5c5a <open>
    161a:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    161c:	02000613          	li	a2,32
    1620:	f9840593          	addi	a1,s0,-104
    1624:	00004097          	auipc	ra,0x4
    1628:	60e080e7          	jalr	1550(ra) # 5c32 <read>
      close(fd);
    162c:	8526                	mv	a0,s1
    162e:	00004097          	auipc	ra,0x4
    1632:	614080e7          	jalr	1556(ra) # 5c42 <close>
    for (int i = 0; i < 100; i++) {
    1636:	39fd                	addiw	s3,s3,-1
    1638:	fa0994e3          	bnez	s3,15e0 <truncate3+0x52>
    exit(0);
    163c:	4501                	li	a0,0
    163e:	00004097          	auipc	ra,0x4
    1642:	5dc080e7          	jalr	1500(ra) # 5c1a <exit>
    printf("%s: fork failed\n", s);
    1646:	85ca                	mv	a1,s2
    1648:	00005517          	auipc	a0,0x5
    164c:	3c850513          	addi	a0,a0,968 # 6a10 <malloc+0x9c4>
    1650:	00005097          	auipc	ra,0x5
    1654:	944080e7          	jalr	-1724(ra) # 5f94 <printf>
    exit(1);
    1658:	4505                	li	a0,1
    165a:	00004097          	auipc	ra,0x4
    165e:	5c0080e7          	jalr	1472(ra) # 5c1a <exit>
        printf("%s: open failed\n", s);
    1662:	85ca                	mv	a1,s2
    1664:	00005517          	auipc	a0,0x5
    1668:	3c450513          	addi	a0,a0,964 # 6a28 <malloc+0x9dc>
    166c:	00005097          	auipc	ra,0x5
    1670:	928080e7          	jalr	-1752(ra) # 5f94 <printf>
        exit(1);
    1674:	4505                	li	a0,1
    1676:	00004097          	auipc	ra,0x4
    167a:	5a4080e7          	jalr	1444(ra) # 5c1a <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    167e:	862a                	mv	a2,a0
    1680:	85ca                	mv	a1,s2
    1682:	00005517          	auipc	a0,0x5
    1686:	3ce50513          	addi	a0,a0,974 # 6a50 <malloc+0xa04>
    168a:	00005097          	auipc	ra,0x5
    168e:	90a080e7          	jalr	-1782(ra) # 5f94 <printf>
        exit(1);
    1692:	4505                	li	a0,1
    1694:	00004097          	auipc	ra,0x4
    1698:	586080e7          	jalr	1414(ra) # 5c1a <exit>
    169c:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    16a0:	00005a17          	auipc	s4,0x5
    16a4:	b30a0a13          	addi	s4,s4,-1232 # 61d0 <malloc+0x184>
    int n = write(fd, "xxx", 3);
    16a8:	00005a97          	auipc	s5,0x5
    16ac:	3c8a8a93          	addi	s5,s5,968 # 6a70 <malloc+0xa24>
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    16b0:	60100593          	li	a1,1537
    16b4:	8552                	mv	a0,s4
    16b6:	00004097          	auipc	ra,0x4
    16ba:	5a4080e7          	jalr	1444(ra) # 5c5a <open>
    16be:	84aa                	mv	s1,a0
    if (fd < 0) {
    16c0:	04054763          	bltz	a0,170e <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    16c4:	460d                	li	a2,3
    16c6:	85d6                	mv	a1,s5
    16c8:	00004097          	auipc	ra,0x4
    16cc:	572080e7          	jalr	1394(ra) # 5c3a <write>
    if (n != 3) {
    16d0:	478d                	li	a5,3
    16d2:	04f51c63          	bne	a0,a5,172a <truncate3+0x19c>
    close(fd);
    16d6:	8526                	mv	a0,s1
    16d8:	00004097          	auipc	ra,0x4
    16dc:	56a080e7          	jalr	1386(ra) # 5c42 <close>
  for (int i = 0; i < 150; i++) {
    16e0:	39fd                	addiw	s3,s3,-1
    16e2:	fc0997e3          	bnez	s3,16b0 <truncate3+0x122>
  wait(&xstatus);
    16e6:	fbc40513          	addi	a0,s0,-68
    16ea:	00004097          	auipc	ra,0x4
    16ee:	538080e7          	jalr	1336(ra) # 5c22 <wait>
  unlink("truncfile");
    16f2:	00005517          	auipc	a0,0x5
    16f6:	ade50513          	addi	a0,a0,-1314 # 61d0 <malloc+0x184>
    16fa:	00004097          	auipc	ra,0x4
    16fe:	570080e7          	jalr	1392(ra) # 5c6a <unlink>
  exit(xstatus);
    1702:	fbc42503          	lw	a0,-68(s0)
    1706:	00004097          	auipc	ra,0x4
    170a:	514080e7          	jalr	1300(ra) # 5c1a <exit>
      printf("%s: open failed\n", s);
    170e:	85ca                	mv	a1,s2
    1710:	00005517          	auipc	a0,0x5
    1714:	31850513          	addi	a0,a0,792 # 6a28 <malloc+0x9dc>
    1718:	00005097          	auipc	ra,0x5
    171c:	87c080e7          	jalr	-1924(ra) # 5f94 <printf>
      exit(1);
    1720:	4505                	li	a0,1
    1722:	00004097          	auipc	ra,0x4
    1726:	4f8080e7          	jalr	1272(ra) # 5c1a <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    172a:	862a                	mv	a2,a0
    172c:	85ca                	mv	a1,s2
    172e:	00005517          	auipc	a0,0x5
    1732:	34a50513          	addi	a0,a0,842 # 6a78 <malloc+0xa2c>
    1736:	00005097          	auipc	ra,0x5
    173a:	85e080e7          	jalr	-1954(ra) # 5f94 <printf>
      exit(1);
    173e:	4505                	li	a0,1
    1740:	00004097          	auipc	ra,0x4
    1744:	4da080e7          	jalr	1242(ra) # 5c1a <exit>

0000000000001748 <exectest>:
void exectest(char *s) {
    1748:	715d                	addi	sp,sp,-80
    174a:	e486                	sd	ra,72(sp)
    174c:	e0a2                	sd	s0,64(sp)
    174e:	fc26                	sd	s1,56(sp)
    1750:	f84a                	sd	s2,48(sp)
    1752:	0880                	addi	s0,sp,80
    1754:	892a                	mv	s2,a0
  char *echoargv[] = {"echo", "OK", 0};
    1756:	00005797          	auipc	a5,0x5
    175a:	a2278793          	addi	a5,a5,-1502 # 6178 <malloc+0x12c>
    175e:	fcf43023          	sd	a5,-64(s0)
    1762:	00005797          	auipc	a5,0x5
    1766:	33678793          	addi	a5,a5,822 # 6a98 <malloc+0xa4c>
    176a:	fcf43423          	sd	a5,-56(s0)
    176e:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1772:	00005517          	auipc	a0,0x5
    1776:	32e50513          	addi	a0,a0,814 # 6aa0 <malloc+0xa54>
    177a:	00004097          	auipc	ra,0x4
    177e:	4f0080e7          	jalr	1264(ra) # 5c6a <unlink>
  pid = fork();
    1782:	00004097          	auipc	ra,0x4
    1786:	490080e7          	jalr	1168(ra) # 5c12 <fork>
  if (pid < 0) {
    178a:	04054663          	bltz	a0,17d6 <exectest+0x8e>
    178e:	84aa                	mv	s1,a0
  if (pid == 0) {
    1790:	e959                	bnez	a0,1826 <exectest+0xde>
    close(1);
    1792:	4505                	li	a0,1
    1794:	00004097          	auipc	ra,0x4
    1798:	4ae080e7          	jalr	1198(ra) # 5c42 <close>
    fd = open("echo-ok", O_CREATE | O_WRONLY);
    179c:	20100593          	li	a1,513
    17a0:	00005517          	auipc	a0,0x5
    17a4:	30050513          	addi	a0,a0,768 # 6aa0 <malloc+0xa54>
    17a8:	00004097          	auipc	ra,0x4
    17ac:	4b2080e7          	jalr	1202(ra) # 5c5a <open>
    if (fd < 0) {
    17b0:	04054163          	bltz	a0,17f2 <exectest+0xaa>
    if (fd != 1) {
    17b4:	4785                	li	a5,1
    17b6:	04f50c63          	beq	a0,a5,180e <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    17ba:	85ca                	mv	a1,s2
    17bc:	00005517          	auipc	a0,0x5
    17c0:	30450513          	addi	a0,a0,772 # 6ac0 <malloc+0xa74>
    17c4:	00004097          	auipc	ra,0x4
    17c8:	7d0080e7          	jalr	2000(ra) # 5f94 <printf>
      exit(1);
    17cc:	4505                	li	a0,1
    17ce:	00004097          	auipc	ra,0x4
    17d2:	44c080e7          	jalr	1100(ra) # 5c1a <exit>
    printf("%s: fork failed\n", s);
    17d6:	85ca                	mv	a1,s2
    17d8:	00005517          	auipc	a0,0x5
    17dc:	23850513          	addi	a0,a0,568 # 6a10 <malloc+0x9c4>
    17e0:	00004097          	auipc	ra,0x4
    17e4:	7b4080e7          	jalr	1972(ra) # 5f94 <printf>
    exit(1);
    17e8:	4505                	li	a0,1
    17ea:	00004097          	auipc	ra,0x4
    17ee:	430080e7          	jalr	1072(ra) # 5c1a <exit>
      printf("%s: create failed\n", s);
    17f2:	85ca                	mv	a1,s2
    17f4:	00005517          	auipc	a0,0x5
    17f8:	2b450513          	addi	a0,a0,692 # 6aa8 <malloc+0xa5c>
    17fc:	00004097          	auipc	ra,0x4
    1800:	798080e7          	jalr	1944(ra) # 5f94 <printf>
      exit(1);
    1804:	4505                	li	a0,1
    1806:	00004097          	auipc	ra,0x4
    180a:	414080e7          	jalr	1044(ra) # 5c1a <exit>
    if (exec("echo", echoargv) < 0) {
    180e:	fc040593          	addi	a1,s0,-64
    1812:	00005517          	auipc	a0,0x5
    1816:	96650513          	addi	a0,a0,-1690 # 6178 <malloc+0x12c>
    181a:	00004097          	auipc	ra,0x4
    181e:	438080e7          	jalr	1080(ra) # 5c52 <exec>
    1822:	02054163          	bltz	a0,1844 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1826:	fdc40513          	addi	a0,s0,-36
    182a:	00004097          	auipc	ra,0x4
    182e:	3f8080e7          	jalr	1016(ra) # 5c22 <wait>
    1832:	02951763          	bne	a0,s1,1860 <exectest+0x118>
  if (xstatus != 0) exit(xstatus);
    1836:	fdc42503          	lw	a0,-36(s0)
    183a:	cd0d                	beqz	a0,1874 <exectest+0x12c>
    183c:	00004097          	auipc	ra,0x4
    1840:	3de080e7          	jalr	990(ra) # 5c1a <exit>
      printf("%s: exec echo failed\n", s);
    1844:	85ca                	mv	a1,s2
    1846:	00005517          	auipc	a0,0x5
    184a:	28a50513          	addi	a0,a0,650 # 6ad0 <malloc+0xa84>
    184e:	00004097          	auipc	ra,0x4
    1852:	746080e7          	jalr	1862(ra) # 5f94 <printf>
      exit(1);
    1856:	4505                	li	a0,1
    1858:	00004097          	auipc	ra,0x4
    185c:	3c2080e7          	jalr	962(ra) # 5c1a <exit>
    printf("%s: wait failed!\n", s);
    1860:	85ca                	mv	a1,s2
    1862:	00005517          	auipc	a0,0x5
    1866:	28650513          	addi	a0,a0,646 # 6ae8 <malloc+0xa9c>
    186a:	00004097          	auipc	ra,0x4
    186e:	72a080e7          	jalr	1834(ra) # 5f94 <printf>
    1872:	b7d1                	j	1836 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    1874:	4581                	li	a1,0
    1876:	00005517          	auipc	a0,0x5
    187a:	22a50513          	addi	a0,a0,554 # 6aa0 <malloc+0xa54>
    187e:	00004097          	auipc	ra,0x4
    1882:	3dc080e7          	jalr	988(ra) # 5c5a <open>
  if (fd < 0) {
    1886:	02054a63          	bltz	a0,18ba <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    188a:	4609                	li	a2,2
    188c:	fb840593          	addi	a1,s0,-72
    1890:	00004097          	auipc	ra,0x4
    1894:	3a2080e7          	jalr	930(ra) # 5c32 <read>
    1898:	4789                	li	a5,2
    189a:	02f50e63          	beq	a0,a5,18d6 <exectest+0x18e>
    printf("%s: read failed\n", s);
    189e:	85ca                	mv	a1,s2
    18a0:	00005517          	auipc	a0,0x5
    18a4:	cb850513          	addi	a0,a0,-840 # 6558 <malloc+0x50c>
    18a8:	00004097          	auipc	ra,0x4
    18ac:	6ec080e7          	jalr	1772(ra) # 5f94 <printf>
    exit(1);
    18b0:	4505                	li	a0,1
    18b2:	00004097          	auipc	ra,0x4
    18b6:	368080e7          	jalr	872(ra) # 5c1a <exit>
    printf("%s: open failed\n", s);
    18ba:	85ca                	mv	a1,s2
    18bc:	00005517          	auipc	a0,0x5
    18c0:	16c50513          	addi	a0,a0,364 # 6a28 <malloc+0x9dc>
    18c4:	00004097          	auipc	ra,0x4
    18c8:	6d0080e7          	jalr	1744(ra) # 5f94 <printf>
    exit(1);
    18cc:	4505                	li	a0,1
    18ce:	00004097          	auipc	ra,0x4
    18d2:	34c080e7          	jalr	844(ra) # 5c1a <exit>
  unlink("echo-ok");
    18d6:	00005517          	auipc	a0,0x5
    18da:	1ca50513          	addi	a0,a0,458 # 6aa0 <malloc+0xa54>
    18de:	00004097          	auipc	ra,0x4
    18e2:	38c080e7          	jalr	908(ra) # 5c6a <unlink>
  if (buf[0] == 'O' && buf[1] == 'K')
    18e6:	fb844703          	lbu	a4,-72(s0)
    18ea:	04f00793          	li	a5,79
    18ee:	00f71863          	bne	a4,a5,18fe <exectest+0x1b6>
    18f2:	fb944703          	lbu	a4,-71(s0)
    18f6:	04b00793          	li	a5,75
    18fa:	02f70063          	beq	a4,a5,191a <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    18fe:	85ca                	mv	a1,s2
    1900:	00005517          	auipc	a0,0x5
    1904:	20050513          	addi	a0,a0,512 # 6b00 <malloc+0xab4>
    1908:	00004097          	auipc	ra,0x4
    190c:	68c080e7          	jalr	1676(ra) # 5f94 <printf>
    exit(1);
    1910:	4505                	li	a0,1
    1912:	00004097          	auipc	ra,0x4
    1916:	308080e7          	jalr	776(ra) # 5c1a <exit>
    exit(0);
    191a:	4501                	li	a0,0
    191c:	00004097          	auipc	ra,0x4
    1920:	2fe080e7          	jalr	766(ra) # 5c1a <exit>

0000000000001924 <pipe1>:
void pipe1(char *s) {
    1924:	711d                	addi	sp,sp,-96
    1926:	ec86                	sd	ra,88(sp)
    1928:	e8a2                	sd	s0,80(sp)
    192a:	e4a6                	sd	s1,72(sp)
    192c:	e0ca                	sd	s2,64(sp)
    192e:	fc4e                	sd	s3,56(sp)
    1930:	f852                	sd	s4,48(sp)
    1932:	f456                	sd	s5,40(sp)
    1934:	f05a                	sd	s6,32(sp)
    1936:	ec5e                	sd	s7,24(sp)
    1938:	1080                	addi	s0,sp,96
    193a:	892a                	mv	s2,a0
  if (pipe(fds) != 0) {
    193c:	fa840513          	addi	a0,s0,-88
    1940:	00004097          	auipc	ra,0x4
    1944:	2ea080e7          	jalr	746(ra) # 5c2a <pipe>
    1948:	e93d                	bnez	a0,19be <pipe1+0x9a>
    194a:	84aa                	mv	s1,a0
  pid = fork();
    194c:	00004097          	auipc	ra,0x4
    1950:	2c6080e7          	jalr	710(ra) # 5c12 <fork>
    1954:	8a2a                	mv	s4,a0
  if (pid == 0) {
    1956:	c151                	beqz	a0,19da <pipe1+0xb6>
  } else if (pid > 0) {
    1958:	16a05d63          	blez	a0,1ad2 <pipe1+0x1ae>
    close(fds[1]);
    195c:	fac42503          	lw	a0,-84(s0)
    1960:	00004097          	auipc	ra,0x4
    1964:	2e2080e7          	jalr	738(ra) # 5c42 <close>
    total = 0;
    1968:	8a26                	mv	s4,s1
    cc = 1;
    196a:	4985                	li	s3,1
    while ((n = read(fds[0], buf, cc)) > 0) {
    196c:	0000ba97          	auipc	s5,0xb
    1970:	30ca8a93          	addi	s5,s5,780 # cc78 <buf>
      if (cc > sizeof(buf)) cc = sizeof(buf);
    1974:	6b0d                	lui	s6,0x3
    while ((n = read(fds[0], buf, cc)) > 0) {
    1976:	864e                	mv	a2,s3
    1978:	85d6                	mv	a1,s5
    197a:	fa842503          	lw	a0,-88(s0)
    197e:	00004097          	auipc	ra,0x4
    1982:	2b4080e7          	jalr	692(ra) # 5c32 <read>
    1986:	10a05163          	blez	a0,1a88 <pipe1+0x164>
      for (i = 0; i < n; i++) {
    198a:	0000b717          	auipc	a4,0xb
    198e:	2ee70713          	addi	a4,a4,750 # cc78 <buf>
    1992:	00a4863b          	addw	a2,s1,a0
        if ((buf[i] & 0xff) != (seq++ & 0xff)) {
    1996:	00074683          	lbu	a3,0(a4)
    199a:	0ff4f793          	zext.b	a5,s1
    199e:	2485                	addiw	s1,s1,1
    19a0:	0cf69063          	bne	a3,a5,1a60 <pipe1+0x13c>
      for (i = 0; i < n; i++) {
    19a4:	0705                	addi	a4,a4,1
    19a6:	fec498e3          	bne	s1,a2,1996 <pipe1+0x72>
      total += n;
    19aa:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    19ae:	0019979b          	slliw	a5,s3,0x1
    19b2:	0007899b          	sext.w	s3,a5
      if (cc > sizeof(buf)) cc = sizeof(buf);
    19b6:	fd3b70e3          	bgeu	s6,s3,1976 <pipe1+0x52>
    19ba:	89da                	mv	s3,s6
    19bc:	bf6d                	j	1976 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    19be:	85ca                	mv	a1,s2
    19c0:	00005517          	auipc	a0,0x5
    19c4:	15850513          	addi	a0,a0,344 # 6b18 <malloc+0xacc>
    19c8:	00004097          	auipc	ra,0x4
    19cc:	5cc080e7          	jalr	1484(ra) # 5f94 <printf>
    exit(1);
    19d0:	4505                	li	a0,1
    19d2:	00004097          	auipc	ra,0x4
    19d6:	248080e7          	jalr	584(ra) # 5c1a <exit>
    close(fds[0]);
    19da:	fa842503          	lw	a0,-88(s0)
    19de:	00004097          	auipc	ra,0x4
    19e2:	264080e7          	jalr	612(ra) # 5c42 <close>
    for (n = 0; n < N; n++) {
    19e6:	0000bb17          	auipc	s6,0xb
    19ea:	292b0b13          	addi	s6,s6,658 # cc78 <buf>
    19ee:	416004bb          	negw	s1,s6
    19f2:	0ff4f493          	zext.b	s1,s1
    19f6:	409b0993          	addi	s3,s6,1033
      if (write(fds[1], buf, SZ) != SZ) {
    19fa:	8bda                	mv	s7,s6
    for (n = 0; n < N; n++) {
    19fc:	6a85                	lui	s5,0x1
    19fe:	42da8a93          	addi	s5,s5,1069 # 142d <copyinstr2+0x95>
void pipe1(char *s) {
    1a02:	87da                	mv	a5,s6
      for (i = 0; i < SZ; i++) buf[i] = seq++;
    1a04:	0097873b          	addw	a4,a5,s1
    1a08:	00e78023          	sb	a4,0(a5)
    1a0c:	0785                	addi	a5,a5,1
    1a0e:	fef99be3          	bne	s3,a5,1a04 <pipe1+0xe0>
    1a12:	409a0a1b          	addiw	s4,s4,1033
      if (write(fds[1], buf, SZ) != SZ) {
    1a16:	40900613          	li	a2,1033
    1a1a:	85de                	mv	a1,s7
    1a1c:	fac42503          	lw	a0,-84(s0)
    1a20:	00004097          	auipc	ra,0x4
    1a24:	21a080e7          	jalr	538(ra) # 5c3a <write>
    1a28:	40900793          	li	a5,1033
    1a2c:	00f51c63          	bne	a0,a5,1a44 <pipe1+0x120>
    for (n = 0; n < N; n++) {
    1a30:	24a5                	addiw	s1,s1,9
    1a32:	0ff4f493          	zext.b	s1,s1
    1a36:	fd5a16e3          	bne	s4,s5,1a02 <pipe1+0xde>
    exit(0);
    1a3a:	4501                	li	a0,0
    1a3c:	00004097          	auipc	ra,0x4
    1a40:	1de080e7          	jalr	478(ra) # 5c1a <exit>
        printf("%s: pipe1 oops 1\n", s);
    1a44:	85ca                	mv	a1,s2
    1a46:	00005517          	auipc	a0,0x5
    1a4a:	0ea50513          	addi	a0,a0,234 # 6b30 <malloc+0xae4>
    1a4e:	00004097          	auipc	ra,0x4
    1a52:	546080e7          	jalr	1350(ra) # 5f94 <printf>
        exit(1);
    1a56:	4505                	li	a0,1
    1a58:	00004097          	auipc	ra,0x4
    1a5c:	1c2080e7          	jalr	450(ra) # 5c1a <exit>
          printf("%s: pipe1 oops 2\n", s);
    1a60:	85ca                	mv	a1,s2
    1a62:	00005517          	auipc	a0,0x5
    1a66:	0e650513          	addi	a0,a0,230 # 6b48 <malloc+0xafc>
    1a6a:	00004097          	auipc	ra,0x4
    1a6e:	52a080e7          	jalr	1322(ra) # 5f94 <printf>
}
    1a72:	60e6                	ld	ra,88(sp)
    1a74:	6446                	ld	s0,80(sp)
    1a76:	64a6                	ld	s1,72(sp)
    1a78:	6906                	ld	s2,64(sp)
    1a7a:	79e2                	ld	s3,56(sp)
    1a7c:	7a42                	ld	s4,48(sp)
    1a7e:	7aa2                	ld	s5,40(sp)
    1a80:	7b02                	ld	s6,32(sp)
    1a82:	6be2                	ld	s7,24(sp)
    1a84:	6125                	addi	sp,sp,96
    1a86:	8082                	ret
    if (total != N * SZ) {
    1a88:	6785                	lui	a5,0x1
    1a8a:	42d78793          	addi	a5,a5,1069 # 142d <copyinstr2+0x95>
    1a8e:	02fa0063          	beq	s4,a5,1aae <pipe1+0x18a>
      printf("%s: pipe1 oops 3 total %d\n", total);
    1a92:	85d2                	mv	a1,s4
    1a94:	00005517          	auipc	a0,0x5
    1a98:	0cc50513          	addi	a0,a0,204 # 6b60 <malloc+0xb14>
    1a9c:	00004097          	auipc	ra,0x4
    1aa0:	4f8080e7          	jalr	1272(ra) # 5f94 <printf>
      exit(1);
    1aa4:	4505                	li	a0,1
    1aa6:	00004097          	auipc	ra,0x4
    1aaa:	174080e7          	jalr	372(ra) # 5c1a <exit>
    close(fds[0]);
    1aae:	fa842503          	lw	a0,-88(s0)
    1ab2:	00004097          	auipc	ra,0x4
    1ab6:	190080e7          	jalr	400(ra) # 5c42 <close>
    wait(&xstatus);
    1aba:	fa440513          	addi	a0,s0,-92
    1abe:	00004097          	auipc	ra,0x4
    1ac2:	164080e7          	jalr	356(ra) # 5c22 <wait>
    exit(xstatus);
    1ac6:	fa442503          	lw	a0,-92(s0)
    1aca:	00004097          	auipc	ra,0x4
    1ace:	150080e7          	jalr	336(ra) # 5c1a <exit>
    printf("%s: fork() failed\n", s);
    1ad2:	85ca                	mv	a1,s2
    1ad4:	00005517          	auipc	a0,0x5
    1ad8:	0ac50513          	addi	a0,a0,172 # 6b80 <malloc+0xb34>
    1adc:	00004097          	auipc	ra,0x4
    1ae0:	4b8080e7          	jalr	1208(ra) # 5f94 <printf>
    exit(1);
    1ae4:	4505                	li	a0,1
    1ae6:	00004097          	auipc	ra,0x4
    1aea:	134080e7          	jalr	308(ra) # 5c1a <exit>

0000000000001aee <exitwait>:
void exitwait(char *s) {
    1aee:	7139                	addi	sp,sp,-64
    1af0:	fc06                	sd	ra,56(sp)
    1af2:	f822                	sd	s0,48(sp)
    1af4:	f426                	sd	s1,40(sp)
    1af6:	f04a                	sd	s2,32(sp)
    1af8:	ec4e                	sd	s3,24(sp)
    1afa:	e852                	sd	s4,16(sp)
    1afc:	0080                	addi	s0,sp,64
    1afe:	8a2a                	mv	s4,a0
  for (i = 0; i < 100; i++) {
    1b00:	4901                	li	s2,0
    1b02:	06400993          	li	s3,100
    pid = fork();
    1b06:	00004097          	auipc	ra,0x4
    1b0a:	10c080e7          	jalr	268(ra) # 5c12 <fork>
    1b0e:	84aa                	mv	s1,a0
    if (pid < 0) {
    1b10:	02054a63          	bltz	a0,1b44 <exitwait+0x56>
    if (pid) {
    1b14:	c151                	beqz	a0,1b98 <exitwait+0xaa>
      if (wait(&xstate) != pid) {
    1b16:	fcc40513          	addi	a0,s0,-52
    1b1a:	00004097          	auipc	ra,0x4
    1b1e:	108080e7          	jalr	264(ra) # 5c22 <wait>
    1b22:	02951f63          	bne	a0,s1,1b60 <exitwait+0x72>
      if (i != xstate) {
    1b26:	fcc42783          	lw	a5,-52(s0)
    1b2a:	05279963          	bne	a5,s2,1b7c <exitwait+0x8e>
  for (i = 0; i < 100; i++) {
    1b2e:	2905                	addiw	s2,s2,1
    1b30:	fd391be3          	bne	s2,s3,1b06 <exitwait+0x18>
}
    1b34:	70e2                	ld	ra,56(sp)
    1b36:	7442                	ld	s0,48(sp)
    1b38:	74a2                	ld	s1,40(sp)
    1b3a:	7902                	ld	s2,32(sp)
    1b3c:	69e2                	ld	s3,24(sp)
    1b3e:	6a42                	ld	s4,16(sp)
    1b40:	6121                	addi	sp,sp,64
    1b42:	8082                	ret
      printf("%s: fork failed\n", s);
    1b44:	85d2                	mv	a1,s4
    1b46:	00005517          	auipc	a0,0x5
    1b4a:	eca50513          	addi	a0,a0,-310 # 6a10 <malloc+0x9c4>
    1b4e:	00004097          	auipc	ra,0x4
    1b52:	446080e7          	jalr	1094(ra) # 5f94 <printf>
      exit(1);
    1b56:	4505                	li	a0,1
    1b58:	00004097          	auipc	ra,0x4
    1b5c:	0c2080e7          	jalr	194(ra) # 5c1a <exit>
        printf("%s: wait wrong pid\n", s);
    1b60:	85d2                	mv	a1,s4
    1b62:	00005517          	auipc	a0,0x5
    1b66:	03650513          	addi	a0,a0,54 # 6b98 <malloc+0xb4c>
    1b6a:	00004097          	auipc	ra,0x4
    1b6e:	42a080e7          	jalr	1066(ra) # 5f94 <printf>
        exit(1);
    1b72:	4505                	li	a0,1
    1b74:	00004097          	auipc	ra,0x4
    1b78:	0a6080e7          	jalr	166(ra) # 5c1a <exit>
        printf("%s: wait wrong exit status\n", s);
    1b7c:	85d2                	mv	a1,s4
    1b7e:	00005517          	auipc	a0,0x5
    1b82:	03250513          	addi	a0,a0,50 # 6bb0 <malloc+0xb64>
    1b86:	00004097          	auipc	ra,0x4
    1b8a:	40e080e7          	jalr	1038(ra) # 5f94 <printf>
        exit(1);
    1b8e:	4505                	li	a0,1
    1b90:	00004097          	auipc	ra,0x4
    1b94:	08a080e7          	jalr	138(ra) # 5c1a <exit>
      exit(i);
    1b98:	854a                	mv	a0,s2
    1b9a:	00004097          	auipc	ra,0x4
    1b9e:	080080e7          	jalr	128(ra) # 5c1a <exit>

0000000000001ba2 <twochildren>:
void twochildren(char *s) {
    1ba2:	1101                	addi	sp,sp,-32
    1ba4:	ec06                	sd	ra,24(sp)
    1ba6:	e822                	sd	s0,16(sp)
    1ba8:	e426                	sd	s1,8(sp)
    1baa:	e04a                	sd	s2,0(sp)
    1bac:	1000                	addi	s0,sp,32
    1bae:	892a                	mv	s2,a0
    1bb0:	3e800493          	li	s1,1000
    int pid1 = fork();
    1bb4:	00004097          	auipc	ra,0x4
    1bb8:	05e080e7          	jalr	94(ra) # 5c12 <fork>
    if (pid1 < 0) {
    1bbc:	02054c63          	bltz	a0,1bf4 <twochildren+0x52>
    if (pid1 == 0) {
    1bc0:	c921                	beqz	a0,1c10 <twochildren+0x6e>
      int pid2 = fork();
    1bc2:	00004097          	auipc	ra,0x4
    1bc6:	050080e7          	jalr	80(ra) # 5c12 <fork>
      if (pid2 < 0) {
    1bca:	04054763          	bltz	a0,1c18 <twochildren+0x76>
      if (pid2 == 0) {
    1bce:	c13d                	beqz	a0,1c34 <twochildren+0x92>
        wait(0);
    1bd0:	4501                	li	a0,0
    1bd2:	00004097          	auipc	ra,0x4
    1bd6:	050080e7          	jalr	80(ra) # 5c22 <wait>
        wait(0);
    1bda:	4501                	li	a0,0
    1bdc:	00004097          	auipc	ra,0x4
    1be0:	046080e7          	jalr	70(ra) # 5c22 <wait>
  for (int i = 0; i < 1000; i++) {
    1be4:	34fd                	addiw	s1,s1,-1
    1be6:	f4f9                	bnez	s1,1bb4 <twochildren+0x12>
}
    1be8:	60e2                	ld	ra,24(sp)
    1bea:	6442                	ld	s0,16(sp)
    1bec:	64a2                	ld	s1,8(sp)
    1bee:	6902                	ld	s2,0(sp)
    1bf0:	6105                	addi	sp,sp,32
    1bf2:	8082                	ret
      printf("%s: fork failed\n", s);
    1bf4:	85ca                	mv	a1,s2
    1bf6:	00005517          	auipc	a0,0x5
    1bfa:	e1a50513          	addi	a0,a0,-486 # 6a10 <malloc+0x9c4>
    1bfe:	00004097          	auipc	ra,0x4
    1c02:	396080e7          	jalr	918(ra) # 5f94 <printf>
      exit(1);
    1c06:	4505                	li	a0,1
    1c08:	00004097          	auipc	ra,0x4
    1c0c:	012080e7          	jalr	18(ra) # 5c1a <exit>
      exit(0);
    1c10:	00004097          	auipc	ra,0x4
    1c14:	00a080e7          	jalr	10(ra) # 5c1a <exit>
        printf("%s: fork failed\n", s);
    1c18:	85ca                	mv	a1,s2
    1c1a:	00005517          	auipc	a0,0x5
    1c1e:	df650513          	addi	a0,a0,-522 # 6a10 <malloc+0x9c4>
    1c22:	00004097          	auipc	ra,0x4
    1c26:	372080e7          	jalr	882(ra) # 5f94 <printf>
        exit(1);
    1c2a:	4505                	li	a0,1
    1c2c:	00004097          	auipc	ra,0x4
    1c30:	fee080e7          	jalr	-18(ra) # 5c1a <exit>
        exit(0);
    1c34:	00004097          	auipc	ra,0x4
    1c38:	fe6080e7          	jalr	-26(ra) # 5c1a <exit>

0000000000001c3c <forkfork>:
void forkfork(char *s) {
    1c3c:	7179                	addi	sp,sp,-48
    1c3e:	f406                	sd	ra,40(sp)
    1c40:	f022                	sd	s0,32(sp)
    1c42:	ec26                	sd	s1,24(sp)
    1c44:	1800                	addi	s0,sp,48
    1c46:	84aa                	mv	s1,a0
    int pid = fork();
    1c48:	00004097          	auipc	ra,0x4
    1c4c:	fca080e7          	jalr	-54(ra) # 5c12 <fork>
    if (pid < 0) {
    1c50:	04054163          	bltz	a0,1c92 <forkfork+0x56>
    if (pid == 0) {
    1c54:	cd29                	beqz	a0,1cae <forkfork+0x72>
    int pid = fork();
    1c56:	00004097          	auipc	ra,0x4
    1c5a:	fbc080e7          	jalr	-68(ra) # 5c12 <fork>
    if (pid < 0) {
    1c5e:	02054a63          	bltz	a0,1c92 <forkfork+0x56>
    if (pid == 0) {
    1c62:	c531                	beqz	a0,1cae <forkfork+0x72>
    wait(&xstatus);
    1c64:	fdc40513          	addi	a0,s0,-36
    1c68:	00004097          	auipc	ra,0x4
    1c6c:	fba080e7          	jalr	-70(ra) # 5c22 <wait>
    if (xstatus != 0) {
    1c70:	fdc42783          	lw	a5,-36(s0)
    1c74:	ebbd                	bnez	a5,1cea <forkfork+0xae>
    wait(&xstatus);
    1c76:	fdc40513          	addi	a0,s0,-36
    1c7a:	00004097          	auipc	ra,0x4
    1c7e:	fa8080e7          	jalr	-88(ra) # 5c22 <wait>
    if (xstatus != 0) {
    1c82:	fdc42783          	lw	a5,-36(s0)
    1c86:	e3b5                	bnez	a5,1cea <forkfork+0xae>
}
    1c88:	70a2                	ld	ra,40(sp)
    1c8a:	7402                	ld	s0,32(sp)
    1c8c:	64e2                	ld	s1,24(sp)
    1c8e:	6145                	addi	sp,sp,48
    1c90:	8082                	ret
      printf("%s: fork failed", s);
    1c92:	85a6                	mv	a1,s1
    1c94:	00005517          	auipc	a0,0x5
    1c98:	f3c50513          	addi	a0,a0,-196 # 6bd0 <malloc+0xb84>
    1c9c:	00004097          	auipc	ra,0x4
    1ca0:	2f8080e7          	jalr	760(ra) # 5f94 <printf>
      exit(1);
    1ca4:	4505                	li	a0,1
    1ca6:	00004097          	auipc	ra,0x4
    1caa:	f74080e7          	jalr	-140(ra) # 5c1a <exit>
void forkfork(char *s) {
    1cae:	0c800493          	li	s1,200
        int pid1 = fork();
    1cb2:	00004097          	auipc	ra,0x4
    1cb6:	f60080e7          	jalr	-160(ra) # 5c12 <fork>
        if (pid1 < 0) {
    1cba:	00054f63          	bltz	a0,1cd8 <forkfork+0x9c>
        if (pid1 == 0) {
    1cbe:	c115                	beqz	a0,1ce2 <forkfork+0xa6>
        wait(0);
    1cc0:	4501                	li	a0,0
    1cc2:	00004097          	auipc	ra,0x4
    1cc6:	f60080e7          	jalr	-160(ra) # 5c22 <wait>
      for (int j = 0; j < 200; j++) {
    1cca:	34fd                	addiw	s1,s1,-1
    1ccc:	f0fd                	bnez	s1,1cb2 <forkfork+0x76>
      exit(0);
    1cce:	4501                	li	a0,0
    1cd0:	00004097          	auipc	ra,0x4
    1cd4:	f4a080e7          	jalr	-182(ra) # 5c1a <exit>
          exit(1);
    1cd8:	4505                	li	a0,1
    1cda:	00004097          	auipc	ra,0x4
    1cde:	f40080e7          	jalr	-192(ra) # 5c1a <exit>
          exit(0);
    1ce2:	00004097          	auipc	ra,0x4
    1ce6:	f38080e7          	jalr	-200(ra) # 5c1a <exit>
      printf("%s: fork in child failed", s);
    1cea:	85a6                	mv	a1,s1
    1cec:	00005517          	auipc	a0,0x5
    1cf0:	ef450513          	addi	a0,a0,-268 # 6be0 <malloc+0xb94>
    1cf4:	00004097          	auipc	ra,0x4
    1cf8:	2a0080e7          	jalr	672(ra) # 5f94 <printf>
      exit(1);
    1cfc:	4505                	li	a0,1
    1cfe:	00004097          	auipc	ra,0x4
    1d02:	f1c080e7          	jalr	-228(ra) # 5c1a <exit>

0000000000001d06 <reparent2>:
void reparent2(char *s) {
    1d06:	1101                	addi	sp,sp,-32
    1d08:	ec06                	sd	ra,24(sp)
    1d0a:	e822                	sd	s0,16(sp)
    1d0c:	e426                	sd	s1,8(sp)
    1d0e:	1000                	addi	s0,sp,32
    1d10:	32000493          	li	s1,800
    int pid1 = fork();
    1d14:	00004097          	auipc	ra,0x4
    1d18:	efe080e7          	jalr	-258(ra) # 5c12 <fork>
    if (pid1 < 0) {
    1d1c:	00054f63          	bltz	a0,1d3a <reparent2+0x34>
    if (pid1 == 0) {
    1d20:	c915                	beqz	a0,1d54 <reparent2+0x4e>
    wait(0);
    1d22:	4501                	li	a0,0
    1d24:	00004097          	auipc	ra,0x4
    1d28:	efe080e7          	jalr	-258(ra) # 5c22 <wait>
  for (int i = 0; i < 800; i++) {
    1d2c:	34fd                	addiw	s1,s1,-1
    1d2e:	f0fd                	bnez	s1,1d14 <reparent2+0xe>
  exit(0);
    1d30:	4501                	li	a0,0
    1d32:	00004097          	auipc	ra,0x4
    1d36:	ee8080e7          	jalr	-280(ra) # 5c1a <exit>
      printf("fork failed\n");
    1d3a:	00005517          	auipc	a0,0x5
    1d3e:	0de50513          	addi	a0,a0,222 # 6e18 <malloc+0xdcc>
    1d42:	00004097          	auipc	ra,0x4
    1d46:	252080e7          	jalr	594(ra) # 5f94 <printf>
      exit(1);
    1d4a:	4505                	li	a0,1
    1d4c:	00004097          	auipc	ra,0x4
    1d50:	ece080e7          	jalr	-306(ra) # 5c1a <exit>
      fork();
    1d54:	00004097          	auipc	ra,0x4
    1d58:	ebe080e7          	jalr	-322(ra) # 5c12 <fork>
      fork();
    1d5c:	00004097          	auipc	ra,0x4
    1d60:	eb6080e7          	jalr	-330(ra) # 5c12 <fork>
      exit(0);
    1d64:	4501                	li	a0,0
    1d66:	00004097          	auipc	ra,0x4
    1d6a:	eb4080e7          	jalr	-332(ra) # 5c1a <exit>

0000000000001d6e <createdelete>:
void createdelete(char *s) {
    1d6e:	7175                	addi	sp,sp,-144
    1d70:	e506                	sd	ra,136(sp)
    1d72:	e122                	sd	s0,128(sp)
    1d74:	fca6                	sd	s1,120(sp)
    1d76:	f8ca                	sd	s2,112(sp)
    1d78:	f4ce                	sd	s3,104(sp)
    1d7a:	f0d2                	sd	s4,96(sp)
    1d7c:	ecd6                	sd	s5,88(sp)
    1d7e:	e8da                	sd	s6,80(sp)
    1d80:	e4de                	sd	s7,72(sp)
    1d82:	e0e2                	sd	s8,64(sp)
    1d84:	fc66                	sd	s9,56(sp)
    1d86:	0900                	addi	s0,sp,144
    1d88:	8caa                	mv	s9,a0
  for (pi = 0; pi < NCHILD; pi++) {
    1d8a:	4901                	li	s2,0
    1d8c:	4991                	li	s3,4
    pid = fork();
    1d8e:	00004097          	auipc	ra,0x4
    1d92:	e84080e7          	jalr	-380(ra) # 5c12 <fork>
    1d96:	84aa                	mv	s1,a0
    if (pid < 0) {
    1d98:	02054f63          	bltz	a0,1dd6 <createdelete+0x68>
    if (pid == 0) {
    1d9c:	c939                	beqz	a0,1df2 <createdelete+0x84>
  for (pi = 0; pi < NCHILD; pi++) {
    1d9e:	2905                	addiw	s2,s2,1
    1da0:	ff3917e3          	bne	s2,s3,1d8e <createdelete+0x20>
    1da4:	4491                	li	s1,4
    wait(&xstatus);
    1da6:	f7c40513          	addi	a0,s0,-132
    1daa:	00004097          	auipc	ra,0x4
    1dae:	e78080e7          	jalr	-392(ra) # 5c22 <wait>
    if (xstatus != 0) exit(1);
    1db2:	f7c42903          	lw	s2,-132(s0)
    1db6:	0e091263          	bnez	s2,1e9a <createdelete+0x12c>
  for (pi = 0; pi < NCHILD; pi++) {
    1dba:	34fd                	addiw	s1,s1,-1
    1dbc:	f4ed                	bnez	s1,1da6 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1dbe:	f8040123          	sb	zero,-126(s0)
    1dc2:	03000993          	li	s3,48
    1dc6:	5a7d                	li	s4,-1
    1dc8:	07000c13          	li	s8,112
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1dcc:	4b21                	li	s6,8
      if ((i == 0 || i >= N / 2) && fd < 0) {
    1dce:	4ba5                	li	s7,9
    for (pi = 0; pi < NCHILD; pi++) {
    1dd0:	07400a93          	li	s5,116
    1dd4:	a29d                	j	1f3a <createdelete+0x1cc>
      printf("fork failed\n", s);
    1dd6:	85e6                	mv	a1,s9
    1dd8:	00005517          	auipc	a0,0x5
    1ddc:	04050513          	addi	a0,a0,64 # 6e18 <malloc+0xdcc>
    1de0:	00004097          	auipc	ra,0x4
    1de4:	1b4080e7          	jalr	436(ra) # 5f94 <printf>
      exit(1);
    1de8:	4505                	li	a0,1
    1dea:	00004097          	auipc	ra,0x4
    1dee:	e30080e7          	jalr	-464(ra) # 5c1a <exit>
      name[0] = 'p' + pi;
    1df2:	0709091b          	addiw	s2,s2,112
    1df6:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1dfa:	f8040123          	sb	zero,-126(s0)
      for (i = 0; i < N; i++) {
    1dfe:	4951                	li	s2,20
    1e00:	a015                	j	1e24 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1e02:	85e6                	mv	a1,s9
    1e04:	00005517          	auipc	a0,0x5
    1e08:	ca450513          	addi	a0,a0,-860 # 6aa8 <malloc+0xa5c>
    1e0c:	00004097          	auipc	ra,0x4
    1e10:	188080e7          	jalr	392(ra) # 5f94 <printf>
          exit(1);
    1e14:	4505                	li	a0,1
    1e16:	00004097          	auipc	ra,0x4
    1e1a:	e04080e7          	jalr	-508(ra) # 5c1a <exit>
      for (i = 0; i < N; i++) {
    1e1e:	2485                	addiw	s1,s1,1
    1e20:	07248863          	beq	s1,s2,1e90 <createdelete+0x122>
        name[1] = '0' + i;
    1e24:	0304879b          	addiw	a5,s1,48
    1e28:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1e2c:	20200593          	li	a1,514
    1e30:	f8040513          	addi	a0,s0,-128
    1e34:	00004097          	auipc	ra,0x4
    1e38:	e26080e7          	jalr	-474(ra) # 5c5a <open>
        if (fd < 0) {
    1e3c:	fc0543e3          	bltz	a0,1e02 <createdelete+0x94>
        close(fd);
    1e40:	00004097          	auipc	ra,0x4
    1e44:	e02080e7          	jalr	-510(ra) # 5c42 <close>
        if (i > 0 && (i % 2) == 0) {
    1e48:	fc905be3          	blez	s1,1e1e <createdelete+0xb0>
    1e4c:	0014f793          	andi	a5,s1,1
    1e50:	f7f9                	bnez	a5,1e1e <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1e52:	01f4d79b          	srliw	a5,s1,0x1f
    1e56:	9fa5                	addw	a5,a5,s1
    1e58:	4017d79b          	sraiw	a5,a5,0x1
    1e5c:	0307879b          	addiw	a5,a5,48
    1e60:	f8f400a3          	sb	a5,-127(s0)
          if (unlink(name) < 0) {
    1e64:	f8040513          	addi	a0,s0,-128
    1e68:	00004097          	auipc	ra,0x4
    1e6c:	e02080e7          	jalr	-510(ra) # 5c6a <unlink>
    1e70:	fa0557e3          	bgez	a0,1e1e <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1e74:	85e6                	mv	a1,s9
    1e76:	00005517          	auipc	a0,0x5
    1e7a:	d8a50513          	addi	a0,a0,-630 # 6c00 <malloc+0xbb4>
    1e7e:	00004097          	auipc	ra,0x4
    1e82:	116080e7          	jalr	278(ra) # 5f94 <printf>
            exit(1);
    1e86:	4505                	li	a0,1
    1e88:	00004097          	auipc	ra,0x4
    1e8c:	d92080e7          	jalr	-622(ra) # 5c1a <exit>
      exit(0);
    1e90:	4501                	li	a0,0
    1e92:	00004097          	auipc	ra,0x4
    1e96:	d88080e7          	jalr	-632(ra) # 5c1a <exit>
    if (xstatus != 0) exit(1);
    1e9a:	4505                	li	a0,1
    1e9c:	00004097          	auipc	ra,0x4
    1ea0:	d7e080e7          	jalr	-642(ra) # 5c1a <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1ea4:	f8040613          	addi	a2,s0,-128
    1ea8:	85e6                	mv	a1,s9
    1eaa:	00005517          	auipc	a0,0x5
    1eae:	d6e50513          	addi	a0,a0,-658 # 6c18 <malloc+0xbcc>
    1eb2:	00004097          	auipc	ra,0x4
    1eb6:	0e2080e7          	jalr	226(ra) # 5f94 <printf>
        exit(1);
    1eba:	4505                	li	a0,1
    1ebc:	00004097          	auipc	ra,0x4
    1ec0:	d5e080e7          	jalr	-674(ra) # 5c1a <exit>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1ec4:	054b7163          	bgeu	s6,s4,1f06 <createdelete+0x198>
      if (fd >= 0) close(fd);
    1ec8:	02055a63          	bgez	a0,1efc <createdelete+0x18e>
    for (pi = 0; pi < NCHILD; pi++) {
    1ecc:	2485                	addiw	s1,s1,1
    1ece:	0ff4f493          	zext.b	s1,s1
    1ed2:	05548c63          	beq	s1,s5,1f2a <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1ed6:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1eda:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1ede:	4581                	li	a1,0
    1ee0:	f8040513          	addi	a0,s0,-128
    1ee4:	00004097          	auipc	ra,0x4
    1ee8:	d76080e7          	jalr	-650(ra) # 5c5a <open>
      if ((i == 0 || i >= N / 2) && fd < 0) {
    1eec:	00090463          	beqz	s2,1ef4 <createdelete+0x186>
    1ef0:	fd2bdae3          	bge	s7,s2,1ec4 <createdelete+0x156>
    1ef4:	fa0548e3          	bltz	a0,1ea4 <createdelete+0x136>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1ef8:	014b7963          	bgeu	s6,s4,1f0a <createdelete+0x19c>
      if (fd >= 0) close(fd);
    1efc:	00004097          	auipc	ra,0x4
    1f00:	d46080e7          	jalr	-698(ra) # 5c42 <close>
    1f04:	b7e1                	j	1ecc <createdelete+0x15e>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1f06:	fc0543e3          	bltz	a0,1ecc <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1f0a:	f8040613          	addi	a2,s0,-128
    1f0e:	85e6                	mv	a1,s9
    1f10:	00005517          	auipc	a0,0x5
    1f14:	d3050513          	addi	a0,a0,-720 # 6c40 <malloc+0xbf4>
    1f18:	00004097          	auipc	ra,0x4
    1f1c:	07c080e7          	jalr	124(ra) # 5f94 <printf>
        exit(1);
    1f20:	4505                	li	a0,1
    1f22:	00004097          	auipc	ra,0x4
    1f26:	cf8080e7          	jalr	-776(ra) # 5c1a <exit>
  for (i = 0; i < N; i++) {
    1f2a:	2905                	addiw	s2,s2,1
    1f2c:	2a05                	addiw	s4,s4,1
    1f2e:	2985                	addiw	s3,s3,1
    1f30:	0ff9f993          	zext.b	s3,s3
    1f34:	47d1                	li	a5,20
    1f36:	02f90a63          	beq	s2,a5,1f6a <createdelete+0x1fc>
    for (pi = 0; pi < NCHILD; pi++) {
    1f3a:	84e2                	mv	s1,s8
    1f3c:	bf69                	j	1ed6 <createdelete+0x168>
  for (i = 0; i < N; i++) {
    1f3e:	2905                	addiw	s2,s2,1
    1f40:	0ff97913          	zext.b	s2,s2
    1f44:	2985                	addiw	s3,s3,1
    1f46:	0ff9f993          	zext.b	s3,s3
    1f4a:	03490863          	beq	s2,s4,1f7a <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1f4e:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1f50:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1f54:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1f58:	f8040513          	addi	a0,s0,-128
    1f5c:	00004097          	auipc	ra,0x4
    1f60:	d0e080e7          	jalr	-754(ra) # 5c6a <unlink>
    for (pi = 0; pi < NCHILD; pi++) {
    1f64:	34fd                	addiw	s1,s1,-1
    1f66:	f4ed                	bnez	s1,1f50 <createdelete+0x1e2>
    1f68:	bfd9                	j	1f3e <createdelete+0x1d0>
    1f6a:	03000993          	li	s3,48
    1f6e:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1f72:	4a91                	li	s5,4
  for (i = 0; i < N; i++) {
    1f74:	08400a13          	li	s4,132
    1f78:	bfd9                	j	1f4e <createdelete+0x1e0>
}
    1f7a:	60aa                	ld	ra,136(sp)
    1f7c:	640a                	ld	s0,128(sp)
    1f7e:	74e6                	ld	s1,120(sp)
    1f80:	7946                	ld	s2,112(sp)
    1f82:	79a6                	ld	s3,104(sp)
    1f84:	7a06                	ld	s4,96(sp)
    1f86:	6ae6                	ld	s5,88(sp)
    1f88:	6b46                	ld	s6,80(sp)
    1f8a:	6ba6                	ld	s7,72(sp)
    1f8c:	6c06                	ld	s8,64(sp)
    1f8e:	7ce2                	ld	s9,56(sp)
    1f90:	6149                	addi	sp,sp,144
    1f92:	8082                	ret

0000000000001f94 <linkunlink>:
void linkunlink(char *s) {
    1f94:	711d                	addi	sp,sp,-96
    1f96:	ec86                	sd	ra,88(sp)
    1f98:	e8a2                	sd	s0,80(sp)
    1f9a:	e4a6                	sd	s1,72(sp)
    1f9c:	e0ca                	sd	s2,64(sp)
    1f9e:	fc4e                	sd	s3,56(sp)
    1fa0:	f852                	sd	s4,48(sp)
    1fa2:	f456                	sd	s5,40(sp)
    1fa4:	f05a                	sd	s6,32(sp)
    1fa6:	ec5e                	sd	s7,24(sp)
    1fa8:	e862                	sd	s8,16(sp)
    1faa:	e466                	sd	s9,8(sp)
    1fac:	1080                	addi	s0,sp,96
    1fae:	84aa                	mv	s1,a0
  unlink("x");
    1fb0:	00004517          	auipc	a0,0x4
    1fb4:	23850513          	addi	a0,a0,568 # 61e8 <malloc+0x19c>
    1fb8:	00004097          	auipc	ra,0x4
    1fbc:	cb2080e7          	jalr	-846(ra) # 5c6a <unlink>
  pid = fork();
    1fc0:	00004097          	auipc	ra,0x4
    1fc4:	c52080e7          	jalr	-942(ra) # 5c12 <fork>
  if (pid < 0) {
    1fc8:	02054b63          	bltz	a0,1ffe <linkunlink+0x6a>
    1fcc:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1fce:	4c85                	li	s9,1
    1fd0:	e119                	bnez	a0,1fd6 <linkunlink+0x42>
    1fd2:	06100c93          	li	s9,97
    1fd6:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1fda:	41c659b7          	lui	s3,0x41c65
    1fde:	e6d9899b          	addiw	s3,s3,-403 # 41c64e6d <base+0x41c551f5>
    1fe2:	690d                	lui	s2,0x3
    1fe4:	0399091b          	addiw	s2,s2,57 # 3039 <fourteen+0x13>
    if ((x % 3) == 0) {
    1fe8:	4a0d                	li	s4,3
    } else if ((x % 3) == 1) {
    1fea:	4b05                	li	s6,1
      unlink("x");
    1fec:	00004a97          	auipc	s5,0x4
    1ff0:	1fca8a93          	addi	s5,s5,508 # 61e8 <malloc+0x19c>
      link("cat", "x");
    1ff4:	00005b97          	auipc	s7,0x5
    1ff8:	c74b8b93          	addi	s7,s7,-908 # 6c68 <malloc+0xc1c>
    1ffc:	a825                	j	2034 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1ffe:	85a6                	mv	a1,s1
    2000:	00005517          	auipc	a0,0x5
    2004:	a1050513          	addi	a0,a0,-1520 # 6a10 <malloc+0x9c4>
    2008:	00004097          	auipc	ra,0x4
    200c:	f8c080e7          	jalr	-116(ra) # 5f94 <printf>
    exit(1);
    2010:	4505                	li	a0,1
    2012:	00004097          	auipc	ra,0x4
    2016:	c08080e7          	jalr	-1016(ra) # 5c1a <exit>
      close(open("x", O_RDWR | O_CREATE));
    201a:	20200593          	li	a1,514
    201e:	8556                	mv	a0,s5
    2020:	00004097          	auipc	ra,0x4
    2024:	c3a080e7          	jalr	-966(ra) # 5c5a <open>
    2028:	00004097          	auipc	ra,0x4
    202c:	c1a080e7          	jalr	-998(ra) # 5c42 <close>
  for (i = 0; i < 100; i++) {
    2030:	34fd                	addiw	s1,s1,-1
    2032:	c88d                	beqz	s1,2064 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    2034:	033c87bb          	mulw	a5,s9,s3
    2038:	012787bb          	addw	a5,a5,s2
    203c:	00078c9b          	sext.w	s9,a5
    if ((x % 3) == 0) {
    2040:	0347f7bb          	remuw	a5,a5,s4
    2044:	dbf9                	beqz	a5,201a <linkunlink+0x86>
    } else if ((x % 3) == 1) {
    2046:	01678863          	beq	a5,s6,2056 <linkunlink+0xc2>
      unlink("x");
    204a:	8556                	mv	a0,s5
    204c:	00004097          	auipc	ra,0x4
    2050:	c1e080e7          	jalr	-994(ra) # 5c6a <unlink>
    2054:	bff1                	j	2030 <linkunlink+0x9c>
      link("cat", "x");
    2056:	85d6                	mv	a1,s5
    2058:	855e                	mv	a0,s7
    205a:	00004097          	auipc	ra,0x4
    205e:	c20080e7          	jalr	-992(ra) # 5c7a <link>
    2062:	b7f9                	j	2030 <linkunlink+0x9c>
  if (pid)
    2064:	020c0463          	beqz	s8,208c <linkunlink+0xf8>
    wait(0);
    2068:	4501                	li	a0,0
    206a:	00004097          	auipc	ra,0x4
    206e:	bb8080e7          	jalr	-1096(ra) # 5c22 <wait>
}
    2072:	60e6                	ld	ra,88(sp)
    2074:	6446                	ld	s0,80(sp)
    2076:	64a6                	ld	s1,72(sp)
    2078:	6906                	ld	s2,64(sp)
    207a:	79e2                	ld	s3,56(sp)
    207c:	7a42                	ld	s4,48(sp)
    207e:	7aa2                	ld	s5,40(sp)
    2080:	7b02                	ld	s6,32(sp)
    2082:	6be2                	ld	s7,24(sp)
    2084:	6c42                	ld	s8,16(sp)
    2086:	6ca2                	ld	s9,8(sp)
    2088:	6125                	addi	sp,sp,96
    208a:	8082                	ret
    exit(0);
    208c:	4501                	li	a0,0
    208e:	00004097          	auipc	ra,0x4
    2092:	b8c080e7          	jalr	-1140(ra) # 5c1a <exit>

0000000000002096 <forktest>:
void forktest(char *s) {
    2096:	7179                	addi	sp,sp,-48
    2098:	f406                	sd	ra,40(sp)
    209a:	f022                	sd	s0,32(sp)
    209c:	ec26                	sd	s1,24(sp)
    209e:	e84a                	sd	s2,16(sp)
    20a0:	e44e                	sd	s3,8(sp)
    20a2:	1800                	addi	s0,sp,48
    20a4:	89aa                	mv	s3,a0
  for (n = 0; n < N; n++) {
    20a6:	4481                	li	s1,0
    20a8:	3e800913          	li	s2,1000
    pid = fork();
    20ac:	00004097          	auipc	ra,0x4
    20b0:	b66080e7          	jalr	-1178(ra) # 5c12 <fork>
    if (pid < 0) break;
    20b4:	02054863          	bltz	a0,20e4 <forktest+0x4e>
    if (pid == 0) exit(0);
    20b8:	c115                	beqz	a0,20dc <forktest+0x46>
  for (n = 0; n < N; n++) {
    20ba:	2485                	addiw	s1,s1,1
    20bc:	ff2498e3          	bne	s1,s2,20ac <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    20c0:	85ce                	mv	a1,s3
    20c2:	00005517          	auipc	a0,0x5
    20c6:	bc650513          	addi	a0,a0,-1082 # 6c88 <malloc+0xc3c>
    20ca:	00004097          	auipc	ra,0x4
    20ce:	eca080e7          	jalr	-310(ra) # 5f94 <printf>
    exit(1);
    20d2:	4505                	li	a0,1
    20d4:	00004097          	auipc	ra,0x4
    20d8:	b46080e7          	jalr	-1210(ra) # 5c1a <exit>
    if (pid == 0) exit(0);
    20dc:	00004097          	auipc	ra,0x4
    20e0:	b3e080e7          	jalr	-1218(ra) # 5c1a <exit>
  if (n == 0) {
    20e4:	cc9d                	beqz	s1,2122 <forktest+0x8c>
  if (n == N) {
    20e6:	3e800793          	li	a5,1000
    20ea:	fcf48be3          	beq	s1,a5,20c0 <forktest+0x2a>
  for (; n > 0; n--) {
    20ee:	00905b63          	blez	s1,2104 <forktest+0x6e>
    if (wait(0) < 0) {
    20f2:	4501                	li	a0,0
    20f4:	00004097          	auipc	ra,0x4
    20f8:	b2e080e7          	jalr	-1234(ra) # 5c22 <wait>
    20fc:	04054163          	bltz	a0,213e <forktest+0xa8>
  for (; n > 0; n--) {
    2100:	34fd                	addiw	s1,s1,-1
    2102:	f8e5                	bnez	s1,20f2 <forktest+0x5c>
  if (wait(0) != -1) {
    2104:	4501                	li	a0,0
    2106:	00004097          	auipc	ra,0x4
    210a:	b1c080e7          	jalr	-1252(ra) # 5c22 <wait>
    210e:	57fd                	li	a5,-1
    2110:	04f51563          	bne	a0,a5,215a <forktest+0xc4>
}
    2114:	70a2                	ld	ra,40(sp)
    2116:	7402                	ld	s0,32(sp)
    2118:	64e2                	ld	s1,24(sp)
    211a:	6942                	ld	s2,16(sp)
    211c:	69a2                	ld	s3,8(sp)
    211e:	6145                	addi	sp,sp,48
    2120:	8082                	ret
    printf("%s: no fork at all!\n", s);
    2122:	85ce                	mv	a1,s3
    2124:	00005517          	auipc	a0,0x5
    2128:	b4c50513          	addi	a0,a0,-1204 # 6c70 <malloc+0xc24>
    212c:	00004097          	auipc	ra,0x4
    2130:	e68080e7          	jalr	-408(ra) # 5f94 <printf>
    exit(1);
    2134:	4505                	li	a0,1
    2136:	00004097          	auipc	ra,0x4
    213a:	ae4080e7          	jalr	-1308(ra) # 5c1a <exit>
      printf("%s: wait stopped early\n", s);
    213e:	85ce                	mv	a1,s3
    2140:	00005517          	auipc	a0,0x5
    2144:	b7050513          	addi	a0,a0,-1168 # 6cb0 <malloc+0xc64>
    2148:	00004097          	auipc	ra,0x4
    214c:	e4c080e7          	jalr	-436(ra) # 5f94 <printf>
      exit(1);
    2150:	4505                	li	a0,1
    2152:	00004097          	auipc	ra,0x4
    2156:	ac8080e7          	jalr	-1336(ra) # 5c1a <exit>
    printf("%s: wait got too many\n", s);
    215a:	85ce                	mv	a1,s3
    215c:	00005517          	auipc	a0,0x5
    2160:	b6c50513          	addi	a0,a0,-1172 # 6cc8 <malloc+0xc7c>
    2164:	00004097          	auipc	ra,0x4
    2168:	e30080e7          	jalr	-464(ra) # 5f94 <printf>
    exit(1);
    216c:	4505                	li	a0,1
    216e:	00004097          	auipc	ra,0x4
    2172:	aac080e7          	jalr	-1364(ra) # 5c1a <exit>

0000000000002176 <kernmem>:
void kernmem(char *s) {
    2176:	715d                	addi	sp,sp,-80
    2178:	e486                	sd	ra,72(sp)
    217a:	e0a2                	sd	s0,64(sp)
    217c:	fc26                	sd	s1,56(sp)
    217e:	f84a                	sd	s2,48(sp)
    2180:	f44e                	sd	s3,40(sp)
    2182:	f052                	sd	s4,32(sp)
    2184:	ec56                	sd	s5,24(sp)
    2186:	0880                	addi	s0,sp,80
    2188:	8a2a                	mv	s4,a0
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    218a:	4485                	li	s1,1
    218c:	04fe                	slli	s1,s1,0x1f
    if (xstatus != -1)  // did kernel kill child?
    218e:	5afd                	li	s5,-1
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    2190:	69b1                	lui	s3,0xc
    2192:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1de8>
    2196:	1003d937          	lui	s2,0x1003d
    219a:	090e                	slli	s2,s2,0x3
    219c:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d808>
    pid = fork();
    21a0:	00004097          	auipc	ra,0x4
    21a4:	a72080e7          	jalr	-1422(ra) # 5c12 <fork>
    if (pid < 0) {
    21a8:	02054963          	bltz	a0,21da <kernmem+0x64>
    if (pid == 0) {
    21ac:	c529                	beqz	a0,21f6 <kernmem+0x80>
    wait(&xstatus);
    21ae:	fbc40513          	addi	a0,s0,-68
    21b2:	00004097          	auipc	ra,0x4
    21b6:	a70080e7          	jalr	-1424(ra) # 5c22 <wait>
    if (xstatus != -1)  // did kernel kill child?
    21ba:	fbc42783          	lw	a5,-68(s0)
    21be:	05579d63          	bne	a5,s5,2218 <kernmem+0xa2>
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    21c2:	94ce                	add	s1,s1,s3
    21c4:	fd249ee3          	bne	s1,s2,21a0 <kernmem+0x2a>
}
    21c8:	60a6                	ld	ra,72(sp)
    21ca:	6406                	ld	s0,64(sp)
    21cc:	74e2                	ld	s1,56(sp)
    21ce:	7942                	ld	s2,48(sp)
    21d0:	79a2                	ld	s3,40(sp)
    21d2:	7a02                	ld	s4,32(sp)
    21d4:	6ae2                	ld	s5,24(sp)
    21d6:	6161                	addi	sp,sp,80
    21d8:	8082                	ret
      printf("%s: fork failed\n", s);
    21da:	85d2                	mv	a1,s4
    21dc:	00005517          	auipc	a0,0x5
    21e0:	83450513          	addi	a0,a0,-1996 # 6a10 <malloc+0x9c4>
    21e4:	00004097          	auipc	ra,0x4
    21e8:	db0080e7          	jalr	-592(ra) # 5f94 <printf>
      exit(1);
    21ec:	4505                	li	a0,1
    21ee:	00004097          	auipc	ra,0x4
    21f2:	a2c080e7          	jalr	-1492(ra) # 5c1a <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    21f6:	0004c683          	lbu	a3,0(s1)
    21fa:	8626                	mv	a2,s1
    21fc:	85d2                	mv	a1,s4
    21fe:	00005517          	auipc	a0,0x5
    2202:	ae250513          	addi	a0,a0,-1310 # 6ce0 <malloc+0xc94>
    2206:	00004097          	auipc	ra,0x4
    220a:	d8e080e7          	jalr	-626(ra) # 5f94 <printf>
      exit(1);
    220e:	4505                	li	a0,1
    2210:	00004097          	auipc	ra,0x4
    2214:	a0a080e7          	jalr	-1526(ra) # 5c1a <exit>
      exit(1);
    2218:	4505                	li	a0,1
    221a:	00004097          	auipc	ra,0x4
    221e:	a00080e7          	jalr	-1536(ra) # 5c1a <exit>

0000000000002222 <MAXVAplus>:
void MAXVAplus(char *s) {
    2222:	7179                	addi	sp,sp,-48
    2224:	f406                	sd	ra,40(sp)
    2226:	f022                	sd	s0,32(sp)
    2228:	ec26                	sd	s1,24(sp)
    222a:	e84a                	sd	s2,16(sp)
    222c:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    222e:	4785                	li	a5,1
    2230:	179a                	slli	a5,a5,0x26
    2232:	fcf43c23          	sd	a5,-40(s0)
  for (; a != 0; a <<= 1) {
    2236:	fd843783          	ld	a5,-40(s0)
    223a:	cf85                	beqz	a5,2272 <MAXVAplus+0x50>
    223c:	892a                	mv	s2,a0
    if (xstatus != -1)  // did kernel kill child?
    223e:	54fd                	li	s1,-1
    pid = fork();
    2240:	00004097          	auipc	ra,0x4
    2244:	9d2080e7          	jalr	-1582(ra) # 5c12 <fork>
    if (pid < 0) {
    2248:	02054b63          	bltz	a0,227e <MAXVAplus+0x5c>
    if (pid == 0) {
    224c:	c539                	beqz	a0,229a <MAXVAplus+0x78>
    wait(&xstatus);
    224e:	fd440513          	addi	a0,s0,-44
    2252:	00004097          	auipc	ra,0x4
    2256:	9d0080e7          	jalr	-1584(ra) # 5c22 <wait>
    if (xstatus != -1)  // did kernel kill child?
    225a:	fd442783          	lw	a5,-44(s0)
    225e:	06979463          	bne	a5,s1,22c6 <MAXVAplus+0xa4>
  for (; a != 0; a <<= 1) {
    2262:	fd843783          	ld	a5,-40(s0)
    2266:	0786                	slli	a5,a5,0x1
    2268:	fcf43c23          	sd	a5,-40(s0)
    226c:	fd843783          	ld	a5,-40(s0)
    2270:	fbe1                	bnez	a5,2240 <MAXVAplus+0x1e>
}
    2272:	70a2                	ld	ra,40(sp)
    2274:	7402                	ld	s0,32(sp)
    2276:	64e2                	ld	s1,24(sp)
    2278:	6942                	ld	s2,16(sp)
    227a:	6145                	addi	sp,sp,48
    227c:	8082                	ret
      printf("%s: fork failed\n", s);
    227e:	85ca                	mv	a1,s2
    2280:	00004517          	auipc	a0,0x4
    2284:	79050513          	addi	a0,a0,1936 # 6a10 <malloc+0x9c4>
    2288:	00004097          	auipc	ra,0x4
    228c:	d0c080e7          	jalr	-756(ra) # 5f94 <printf>
      exit(1);
    2290:	4505                	li	a0,1
    2292:	00004097          	auipc	ra,0x4
    2296:	988080e7          	jalr	-1656(ra) # 5c1a <exit>
      *(char *)a = 99;
    229a:	fd843783          	ld	a5,-40(s0)
    229e:	06300713          	li	a4,99
    22a2:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    22a6:	fd843603          	ld	a2,-40(s0)
    22aa:	85ca                	mv	a1,s2
    22ac:	00005517          	auipc	a0,0x5
    22b0:	a5450513          	addi	a0,a0,-1452 # 6d00 <malloc+0xcb4>
    22b4:	00004097          	auipc	ra,0x4
    22b8:	ce0080e7          	jalr	-800(ra) # 5f94 <printf>
      exit(1);
    22bc:	4505                	li	a0,1
    22be:	00004097          	auipc	ra,0x4
    22c2:	95c080e7          	jalr	-1700(ra) # 5c1a <exit>
      exit(1);
    22c6:	4505                	li	a0,1
    22c8:	00004097          	auipc	ra,0x4
    22cc:	952080e7          	jalr	-1710(ra) # 5c1a <exit>

00000000000022d0 <bigargtest>:
void bigargtest(char *s) {
    22d0:	7179                	addi	sp,sp,-48
    22d2:	f406                	sd	ra,40(sp)
    22d4:	f022                	sd	s0,32(sp)
    22d6:	ec26                	sd	s1,24(sp)
    22d8:	1800                	addi	s0,sp,48
    22da:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    22dc:	00005517          	auipc	a0,0x5
    22e0:	a3c50513          	addi	a0,a0,-1476 # 6d18 <malloc+0xccc>
    22e4:	00004097          	auipc	ra,0x4
    22e8:	986080e7          	jalr	-1658(ra) # 5c6a <unlink>
  pid = fork();
    22ec:	00004097          	auipc	ra,0x4
    22f0:	926080e7          	jalr	-1754(ra) # 5c12 <fork>
  if (pid == 0) {
    22f4:	c121                	beqz	a0,2334 <bigargtest+0x64>
  } else if (pid < 0) {
    22f6:	0a054063          	bltz	a0,2396 <bigargtest+0xc6>
  wait(&xstatus);
    22fa:	fdc40513          	addi	a0,s0,-36
    22fe:	00004097          	auipc	ra,0x4
    2302:	924080e7          	jalr	-1756(ra) # 5c22 <wait>
  if (xstatus != 0) exit(xstatus);
    2306:	fdc42503          	lw	a0,-36(s0)
    230a:	e545                	bnez	a0,23b2 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    230c:	4581                	li	a1,0
    230e:	00005517          	auipc	a0,0x5
    2312:	a0a50513          	addi	a0,a0,-1526 # 6d18 <malloc+0xccc>
    2316:	00004097          	auipc	ra,0x4
    231a:	944080e7          	jalr	-1724(ra) # 5c5a <open>
  if (fd < 0) {
    231e:	08054e63          	bltz	a0,23ba <bigargtest+0xea>
  close(fd);
    2322:	00004097          	auipc	ra,0x4
    2326:	920080e7          	jalr	-1760(ra) # 5c42 <close>
}
    232a:	70a2                	ld	ra,40(sp)
    232c:	7402                	ld	s0,32(sp)
    232e:	64e2                	ld	s1,24(sp)
    2330:	6145                	addi	sp,sp,48
    2332:	8082                	ret
    2334:	00007797          	auipc	a5,0x7
    2338:	12c78793          	addi	a5,a5,300 # 9460 <args.1>
    233c:	00007697          	auipc	a3,0x7
    2340:	21c68693          	addi	a3,a3,540 # 9558 <args.1+0xf8>
      args[i] =
    2344:	00005717          	auipc	a4,0x5
    2348:	9e470713          	addi	a4,a4,-1564 # 6d28 <malloc+0xcdc>
    234c:	e398                	sd	a4,0(a5)
    for (i = 0; i < MAXARG - 1; i++)
    234e:	07a1                	addi	a5,a5,8
    2350:	fed79ee3          	bne	a5,a3,234c <bigargtest+0x7c>
    args[MAXARG - 1] = 0;
    2354:	00007597          	auipc	a1,0x7
    2358:	10c58593          	addi	a1,a1,268 # 9460 <args.1>
    235c:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2360:	00004517          	auipc	a0,0x4
    2364:	e1850513          	addi	a0,a0,-488 # 6178 <malloc+0x12c>
    2368:	00004097          	auipc	ra,0x4
    236c:	8ea080e7          	jalr	-1814(ra) # 5c52 <exec>
    fd = open("bigarg-ok", O_CREATE);
    2370:	20000593          	li	a1,512
    2374:	00005517          	auipc	a0,0x5
    2378:	9a450513          	addi	a0,a0,-1628 # 6d18 <malloc+0xccc>
    237c:	00004097          	auipc	ra,0x4
    2380:	8de080e7          	jalr	-1826(ra) # 5c5a <open>
    close(fd);
    2384:	00004097          	auipc	ra,0x4
    2388:	8be080e7          	jalr	-1858(ra) # 5c42 <close>
    exit(0);
    238c:	4501                	li	a0,0
    238e:	00004097          	auipc	ra,0x4
    2392:	88c080e7          	jalr	-1908(ra) # 5c1a <exit>
    printf("%s: bigargtest: fork failed\n", s);
    2396:	85a6                	mv	a1,s1
    2398:	00005517          	auipc	a0,0x5
    239c:	a7050513          	addi	a0,a0,-1424 # 6e08 <malloc+0xdbc>
    23a0:	00004097          	auipc	ra,0x4
    23a4:	bf4080e7          	jalr	-1036(ra) # 5f94 <printf>
    exit(1);
    23a8:	4505                	li	a0,1
    23aa:	00004097          	auipc	ra,0x4
    23ae:	870080e7          	jalr	-1936(ra) # 5c1a <exit>
  if (xstatus != 0) exit(xstatus);
    23b2:	00004097          	auipc	ra,0x4
    23b6:	868080e7          	jalr	-1944(ra) # 5c1a <exit>
    printf("%s: bigarg test failed!\n", s);
    23ba:	85a6                	mv	a1,s1
    23bc:	00005517          	auipc	a0,0x5
    23c0:	a6c50513          	addi	a0,a0,-1428 # 6e28 <malloc+0xddc>
    23c4:	00004097          	auipc	ra,0x4
    23c8:	bd0080e7          	jalr	-1072(ra) # 5f94 <printf>
    exit(1);
    23cc:	4505                	li	a0,1
    23ce:	00004097          	auipc	ra,0x4
    23d2:	84c080e7          	jalr	-1972(ra) # 5c1a <exit>

00000000000023d6 <stacktest>:
void stacktest(char *s) {
    23d6:	7179                	addi	sp,sp,-48
    23d8:	f406                	sd	ra,40(sp)
    23da:	f022                	sd	s0,32(sp)
    23dc:	ec26                	sd	s1,24(sp)
    23de:	1800                	addi	s0,sp,48
    23e0:	84aa                	mv	s1,a0
  pid = fork();
    23e2:	00004097          	auipc	ra,0x4
    23e6:	830080e7          	jalr	-2000(ra) # 5c12 <fork>
  if (pid == 0) {
    23ea:	c115                	beqz	a0,240e <stacktest+0x38>
  } else if (pid < 0) {
    23ec:	04054463          	bltz	a0,2434 <stacktest+0x5e>
  wait(&xstatus);
    23f0:	fdc40513          	addi	a0,s0,-36
    23f4:	00004097          	auipc	ra,0x4
    23f8:	82e080e7          	jalr	-2002(ra) # 5c22 <wait>
  if (xstatus == -1)  // kernel killed child?
    23fc:	fdc42503          	lw	a0,-36(s0)
    2400:	57fd                	li	a5,-1
    2402:	04f50763          	beq	a0,a5,2450 <stacktest+0x7a>
    exit(xstatus);
    2406:	00004097          	auipc	ra,0x4
    240a:	814080e7          	jalr	-2028(ra) # 5c1a <exit>
  return (x & SSTATUS_SIE) != 0;
}

static inline uint64 r_sp() {
  uint64 x;
  asm volatile("mv %0, sp" : "=r"(x));
    240e:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2410:	77fd                	lui	a5,0xfffff
    2412:	97ba                	add	a5,a5,a4
    2414:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef388>
    2418:	85a6                	mv	a1,s1
    241a:	00005517          	auipc	a0,0x5
    241e:	a2e50513          	addi	a0,a0,-1490 # 6e48 <malloc+0xdfc>
    2422:	00004097          	auipc	ra,0x4
    2426:	b72080e7          	jalr	-1166(ra) # 5f94 <printf>
    exit(1);
    242a:	4505                	li	a0,1
    242c:	00003097          	auipc	ra,0x3
    2430:	7ee080e7          	jalr	2030(ra) # 5c1a <exit>
    printf("%s: fork failed\n", s);
    2434:	85a6                	mv	a1,s1
    2436:	00004517          	auipc	a0,0x4
    243a:	5da50513          	addi	a0,a0,1498 # 6a10 <malloc+0x9c4>
    243e:	00004097          	auipc	ra,0x4
    2442:	b56080e7          	jalr	-1194(ra) # 5f94 <printf>
    exit(1);
    2446:	4505                	li	a0,1
    2448:	00003097          	auipc	ra,0x3
    244c:	7d2080e7          	jalr	2002(ra) # 5c1a <exit>
    exit(0);
    2450:	4501                	li	a0,0
    2452:	00003097          	auipc	ra,0x3
    2456:	7c8080e7          	jalr	1992(ra) # 5c1a <exit>

000000000000245a <textwrite>:
void textwrite(char *s) {
    245a:	7179                	addi	sp,sp,-48
    245c:	f406                	sd	ra,40(sp)
    245e:	f022                	sd	s0,32(sp)
    2460:	ec26                	sd	s1,24(sp)
    2462:	1800                	addi	s0,sp,48
    2464:	84aa                	mv	s1,a0
  pid = fork();
    2466:	00003097          	auipc	ra,0x3
    246a:	7ac080e7          	jalr	1964(ra) # 5c12 <fork>
  if (pid == 0) {
    246e:	c115                	beqz	a0,2492 <textwrite+0x38>
  } else if (pid < 0) {
    2470:	02054963          	bltz	a0,24a2 <textwrite+0x48>
  wait(&xstatus);
    2474:	fdc40513          	addi	a0,s0,-36
    2478:	00003097          	auipc	ra,0x3
    247c:	7aa080e7          	jalr	1962(ra) # 5c22 <wait>
  if (xstatus == -1)  // kernel killed child?
    2480:	fdc42503          	lw	a0,-36(s0)
    2484:	57fd                	li	a5,-1
    2486:	02f50c63          	beq	a0,a5,24be <textwrite+0x64>
    exit(xstatus);
    248a:	00003097          	auipc	ra,0x3
    248e:	790080e7          	jalr	1936(ra) # 5c1a <exit>
    *addr = 10;
    2492:	47a9                	li	a5,10
    2494:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1);
    2498:	4505                	li	a0,1
    249a:	00003097          	auipc	ra,0x3
    249e:	780080e7          	jalr	1920(ra) # 5c1a <exit>
    printf("%s: fork failed\n", s);
    24a2:	85a6                	mv	a1,s1
    24a4:	00004517          	auipc	a0,0x4
    24a8:	56c50513          	addi	a0,a0,1388 # 6a10 <malloc+0x9c4>
    24ac:	00004097          	auipc	ra,0x4
    24b0:	ae8080e7          	jalr	-1304(ra) # 5f94 <printf>
    exit(1);
    24b4:	4505                	li	a0,1
    24b6:	00003097          	auipc	ra,0x3
    24ba:	764080e7          	jalr	1892(ra) # 5c1a <exit>
    exit(0);
    24be:	4501                	li	a0,0
    24c0:	00003097          	auipc	ra,0x3
    24c4:	75a080e7          	jalr	1882(ra) # 5c1a <exit>

00000000000024c8 <manywrites>:
void manywrites(char *s) {
    24c8:	711d                	addi	sp,sp,-96
    24ca:	ec86                	sd	ra,88(sp)
    24cc:	e8a2                	sd	s0,80(sp)
    24ce:	e4a6                	sd	s1,72(sp)
    24d0:	e0ca                	sd	s2,64(sp)
    24d2:	fc4e                	sd	s3,56(sp)
    24d4:	f852                	sd	s4,48(sp)
    24d6:	f456                	sd	s5,40(sp)
    24d8:	f05a                	sd	s6,32(sp)
    24da:	ec5e                	sd	s7,24(sp)
    24dc:	1080                	addi	s0,sp,96
    24de:	8aaa                	mv	s5,a0
  for (int ci = 0; ci < nchildren; ci++) {
    24e0:	4981                	li	s3,0
    24e2:	4911                	li	s2,4
    int pid = fork();
    24e4:	00003097          	auipc	ra,0x3
    24e8:	72e080e7          	jalr	1838(ra) # 5c12 <fork>
    24ec:	84aa                	mv	s1,a0
    if (pid < 0) {
    24ee:	02054963          	bltz	a0,2520 <manywrites+0x58>
    if (pid == 0) {
    24f2:	c521                	beqz	a0,253a <manywrites+0x72>
  for (int ci = 0; ci < nchildren; ci++) {
    24f4:	2985                	addiw	s3,s3,1
    24f6:	ff2997e3          	bne	s3,s2,24e4 <manywrites+0x1c>
    24fa:	4491                	li	s1,4
    int st = 0;
    24fc:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    2500:	fa840513          	addi	a0,s0,-88
    2504:	00003097          	auipc	ra,0x3
    2508:	71e080e7          	jalr	1822(ra) # 5c22 <wait>
    if (st != 0) exit(st);
    250c:	fa842503          	lw	a0,-88(s0)
    2510:	ed6d                	bnez	a0,260a <manywrites+0x142>
  for (int ci = 0; ci < nchildren; ci++) {
    2512:	34fd                	addiw	s1,s1,-1
    2514:	f4e5                	bnez	s1,24fc <manywrites+0x34>
  exit(0);
    2516:	4501                	li	a0,0
    2518:	00003097          	auipc	ra,0x3
    251c:	702080e7          	jalr	1794(ra) # 5c1a <exit>
      printf("fork failed\n");
    2520:	00005517          	auipc	a0,0x5
    2524:	8f850513          	addi	a0,a0,-1800 # 6e18 <malloc+0xdcc>
    2528:	00004097          	auipc	ra,0x4
    252c:	a6c080e7          	jalr	-1428(ra) # 5f94 <printf>
      exit(1);
    2530:	4505                	li	a0,1
    2532:	00003097          	auipc	ra,0x3
    2536:	6e8080e7          	jalr	1768(ra) # 5c1a <exit>
      name[0] = 'b';
    253a:	06200793          	li	a5,98
    253e:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    2542:	0619879b          	addiw	a5,s3,97
    2546:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    254a:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    254e:	fa840513          	addi	a0,s0,-88
    2552:	00003097          	auipc	ra,0x3
    2556:	718080e7          	jalr	1816(ra) # 5c6a <unlink>
    255a:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    255c:	0000ab17          	auipc	s6,0xa
    2560:	71cb0b13          	addi	s6,s6,1820 # cc78 <buf>
        for (int i = 0; i < ci + 1; i++) {
    2564:	8a26                	mv	s4,s1
    2566:	0209ce63          	bltz	s3,25a2 <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    256a:	20200593          	li	a1,514
    256e:	fa840513          	addi	a0,s0,-88
    2572:	00003097          	auipc	ra,0x3
    2576:	6e8080e7          	jalr	1768(ra) # 5c5a <open>
    257a:	892a                	mv	s2,a0
          if (fd < 0) {
    257c:	04054763          	bltz	a0,25ca <manywrites+0x102>
          int cc = write(fd, buf, sz);
    2580:	660d                	lui	a2,0x3
    2582:	85da                	mv	a1,s6
    2584:	00003097          	auipc	ra,0x3
    2588:	6b6080e7          	jalr	1718(ra) # 5c3a <write>
          if (cc != sz) {
    258c:	678d                	lui	a5,0x3
    258e:	04f51e63          	bne	a0,a5,25ea <manywrites+0x122>
          close(fd);
    2592:	854a                	mv	a0,s2
    2594:	00003097          	auipc	ra,0x3
    2598:	6ae080e7          	jalr	1710(ra) # 5c42 <close>
        for (int i = 0; i < ci + 1; i++) {
    259c:	2a05                	addiw	s4,s4,1
    259e:	fd49d6e3          	bge	s3,s4,256a <manywrites+0xa2>
        unlink(name);
    25a2:	fa840513          	addi	a0,s0,-88
    25a6:	00003097          	auipc	ra,0x3
    25aa:	6c4080e7          	jalr	1732(ra) # 5c6a <unlink>
      for (int iters = 0; iters < howmany; iters++) {
    25ae:	3bfd                	addiw	s7,s7,-1
    25b0:	fa0b9ae3          	bnez	s7,2564 <manywrites+0x9c>
      unlink(name);
    25b4:	fa840513          	addi	a0,s0,-88
    25b8:	00003097          	auipc	ra,0x3
    25bc:	6b2080e7          	jalr	1714(ra) # 5c6a <unlink>
      exit(0);
    25c0:	4501                	li	a0,0
    25c2:	00003097          	auipc	ra,0x3
    25c6:	658080e7          	jalr	1624(ra) # 5c1a <exit>
            printf("%s: cannot create %s\n", s, name);
    25ca:	fa840613          	addi	a2,s0,-88
    25ce:	85d6                	mv	a1,s5
    25d0:	00005517          	auipc	a0,0x5
    25d4:	8a050513          	addi	a0,a0,-1888 # 6e70 <malloc+0xe24>
    25d8:	00004097          	auipc	ra,0x4
    25dc:	9bc080e7          	jalr	-1604(ra) # 5f94 <printf>
            exit(1);
    25e0:	4505                	li	a0,1
    25e2:	00003097          	auipc	ra,0x3
    25e6:	638080e7          	jalr	1592(ra) # 5c1a <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    25ea:	86aa                	mv	a3,a0
    25ec:	660d                	lui	a2,0x3
    25ee:	85d6                	mv	a1,s5
    25f0:	00004517          	auipc	a0,0x4
    25f4:	c5850513          	addi	a0,a0,-936 # 6248 <malloc+0x1fc>
    25f8:	00004097          	auipc	ra,0x4
    25fc:	99c080e7          	jalr	-1636(ra) # 5f94 <printf>
            exit(1);
    2600:	4505                	li	a0,1
    2602:	00003097          	auipc	ra,0x3
    2606:	618080e7          	jalr	1560(ra) # 5c1a <exit>
    if (st != 0) exit(st);
    260a:	00003097          	auipc	ra,0x3
    260e:	610080e7          	jalr	1552(ra) # 5c1a <exit>

0000000000002612 <copyinstr3>:
void copyinstr3(char *s) {
    2612:	7179                	addi	sp,sp,-48
    2614:	f406                	sd	ra,40(sp)
    2616:	f022                	sd	s0,32(sp)
    2618:	ec26                	sd	s1,24(sp)
    261a:	1800                	addi	s0,sp,48
  sbrk(8192);
    261c:	6509                	lui	a0,0x2
    261e:	00003097          	auipc	ra,0x3
    2622:	684080e7          	jalr	1668(ra) # 5ca2 <sbrk>
  uint64 top = (uint64)sbrk(0);
    2626:	4501                	li	a0,0
    2628:	00003097          	auipc	ra,0x3
    262c:	67a080e7          	jalr	1658(ra) # 5ca2 <sbrk>
  if ((top % PGSIZE) != 0) {
    2630:	03451793          	slli	a5,a0,0x34
    2634:	e3c9                	bnez	a5,26b6 <copyinstr3+0xa4>
  top = (uint64)sbrk(0);
    2636:	4501                	li	a0,0
    2638:	00003097          	auipc	ra,0x3
    263c:	66a080e7          	jalr	1642(ra) # 5ca2 <sbrk>
  if (top % PGSIZE) {
    2640:	03451793          	slli	a5,a0,0x34
    2644:	e3d9                	bnez	a5,26ca <copyinstr3+0xb8>
  char *b = (char *)(top - 1);
    2646:	fff50493          	addi	s1,a0,-1 # 1fff <linkunlink+0x6b>
  *b = 'x';
    264a:	07800793          	li	a5,120
    264e:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2652:	8526                	mv	a0,s1
    2654:	00003097          	auipc	ra,0x3
    2658:	616080e7          	jalr	1558(ra) # 5c6a <unlink>
  if (ret != -1) {
    265c:	57fd                	li	a5,-1
    265e:	08f51363          	bne	a0,a5,26e4 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2662:	20100593          	li	a1,513
    2666:	8526                	mv	a0,s1
    2668:	00003097          	auipc	ra,0x3
    266c:	5f2080e7          	jalr	1522(ra) # 5c5a <open>
  if (fd != -1) {
    2670:	57fd                	li	a5,-1
    2672:	08f51863          	bne	a0,a5,2702 <copyinstr3+0xf0>
  ret = link(b, b);
    2676:	85a6                	mv	a1,s1
    2678:	8526                	mv	a0,s1
    267a:	00003097          	auipc	ra,0x3
    267e:	600080e7          	jalr	1536(ra) # 5c7a <link>
  if (ret != -1) {
    2682:	57fd                	li	a5,-1
    2684:	08f51e63          	bne	a0,a5,2720 <copyinstr3+0x10e>
  char *args[] = {"xx", 0};
    2688:	00005797          	auipc	a5,0x5
    268c:	4e078793          	addi	a5,a5,1248 # 7b68 <malloc+0x1b1c>
    2690:	fcf43823          	sd	a5,-48(s0)
    2694:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2698:	fd040593          	addi	a1,s0,-48
    269c:	8526                	mv	a0,s1
    269e:	00003097          	auipc	ra,0x3
    26a2:	5b4080e7          	jalr	1460(ra) # 5c52 <exec>
  if (ret != -1) {
    26a6:	57fd                	li	a5,-1
    26a8:	08f51c63          	bne	a0,a5,2740 <copyinstr3+0x12e>
}
    26ac:	70a2                	ld	ra,40(sp)
    26ae:	7402                	ld	s0,32(sp)
    26b0:	64e2                	ld	s1,24(sp)
    26b2:	6145                	addi	sp,sp,48
    26b4:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    26b6:	0347d513          	srli	a0,a5,0x34
    26ba:	6785                	lui	a5,0x1
    26bc:	40a7853b          	subw	a0,a5,a0
    26c0:	00003097          	auipc	ra,0x3
    26c4:	5e2080e7          	jalr	1506(ra) # 5ca2 <sbrk>
    26c8:	b7bd                	j	2636 <copyinstr3+0x24>
    printf("oops\n");
    26ca:	00004517          	auipc	a0,0x4
    26ce:	7be50513          	addi	a0,a0,1982 # 6e88 <malloc+0xe3c>
    26d2:	00004097          	auipc	ra,0x4
    26d6:	8c2080e7          	jalr	-1854(ra) # 5f94 <printf>
    exit(1);
    26da:	4505                	li	a0,1
    26dc:	00003097          	auipc	ra,0x3
    26e0:	53e080e7          	jalr	1342(ra) # 5c1a <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    26e4:	862a                	mv	a2,a0
    26e6:	85a6                	mv	a1,s1
    26e8:	00004517          	auipc	a0,0x4
    26ec:	24850513          	addi	a0,a0,584 # 6930 <malloc+0x8e4>
    26f0:	00004097          	auipc	ra,0x4
    26f4:	8a4080e7          	jalr	-1884(ra) # 5f94 <printf>
    exit(1);
    26f8:	4505                	li	a0,1
    26fa:	00003097          	auipc	ra,0x3
    26fe:	520080e7          	jalr	1312(ra) # 5c1a <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2702:	862a                	mv	a2,a0
    2704:	85a6                	mv	a1,s1
    2706:	00004517          	auipc	a0,0x4
    270a:	24a50513          	addi	a0,a0,586 # 6950 <malloc+0x904>
    270e:	00004097          	auipc	ra,0x4
    2712:	886080e7          	jalr	-1914(ra) # 5f94 <printf>
    exit(1);
    2716:	4505                	li	a0,1
    2718:	00003097          	auipc	ra,0x3
    271c:	502080e7          	jalr	1282(ra) # 5c1a <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2720:	86aa                	mv	a3,a0
    2722:	8626                	mv	a2,s1
    2724:	85a6                	mv	a1,s1
    2726:	00004517          	auipc	a0,0x4
    272a:	24a50513          	addi	a0,a0,586 # 6970 <malloc+0x924>
    272e:	00004097          	auipc	ra,0x4
    2732:	866080e7          	jalr	-1946(ra) # 5f94 <printf>
    exit(1);
    2736:	4505                	li	a0,1
    2738:	00003097          	auipc	ra,0x3
    273c:	4e2080e7          	jalr	1250(ra) # 5c1a <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2740:	567d                	li	a2,-1
    2742:	85a6                	mv	a1,s1
    2744:	00004517          	auipc	a0,0x4
    2748:	25450513          	addi	a0,a0,596 # 6998 <malloc+0x94c>
    274c:	00004097          	auipc	ra,0x4
    2750:	848080e7          	jalr	-1976(ra) # 5f94 <printf>
    exit(1);
    2754:	4505                	li	a0,1
    2756:	00003097          	auipc	ra,0x3
    275a:	4c4080e7          	jalr	1220(ra) # 5c1a <exit>

000000000000275e <rwsbrk>:
void rwsbrk(char *s) {
    275e:	1101                	addi	sp,sp,-32
    2760:	ec06                	sd	ra,24(sp)
    2762:	e822                	sd	s0,16(sp)
    2764:	e426                	sd	s1,8(sp)
    2766:	e04a                	sd	s2,0(sp)
    2768:	1000                	addi	s0,sp,32
  uint64 a = (uint64)sbrk(8192);
    276a:	6509                	lui	a0,0x2
    276c:	00003097          	auipc	ra,0x3
    2770:	536080e7          	jalr	1334(ra) # 5ca2 <sbrk>
  if (a == 0xffffffffffffffffLL) {
    2774:	57fd                	li	a5,-1
    2776:	06f50263          	beq	a0,a5,27da <rwsbrk+0x7c>
    277a:	84aa                	mv	s1,a0
  if ((uint64)sbrk(-8192) == 0xffffffffffffffffLL) {
    277c:	7579                	lui	a0,0xffffe
    277e:	00003097          	auipc	ra,0x3
    2782:	524080e7          	jalr	1316(ra) # 5ca2 <sbrk>
    2786:	57fd                	li	a5,-1
    2788:	06f50663          	beq	a0,a5,27f4 <rwsbrk+0x96>
  fd = open("rwsbrk", O_CREATE | O_WRONLY);
    278c:	20100593          	li	a1,513
    2790:	00004517          	auipc	a0,0x4
    2794:	73850513          	addi	a0,a0,1848 # 6ec8 <malloc+0xe7c>
    2798:	00003097          	auipc	ra,0x3
    279c:	4c2080e7          	jalr	1218(ra) # 5c5a <open>
    27a0:	892a                	mv	s2,a0
  if (fd < 0) {
    27a2:	06054663          	bltz	a0,280e <rwsbrk+0xb0>
  n = write(fd, (void *)(a + 4096), 1024);
    27a6:	6785                	lui	a5,0x1
    27a8:	94be                	add	s1,s1,a5
    27aa:	40000613          	li	a2,1024
    27ae:	85a6                	mv	a1,s1
    27b0:	00003097          	auipc	ra,0x3
    27b4:	48a080e7          	jalr	1162(ra) # 5c3a <write>
    27b8:	862a                	mv	a2,a0
  if (n >= 0) {
    27ba:	06054763          	bltz	a0,2828 <rwsbrk+0xca>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a + 4096, n);
    27be:	85a6                	mv	a1,s1
    27c0:	00004517          	auipc	a0,0x4
    27c4:	72850513          	addi	a0,a0,1832 # 6ee8 <malloc+0xe9c>
    27c8:	00003097          	auipc	ra,0x3
    27cc:	7cc080e7          	jalr	1996(ra) # 5f94 <printf>
    exit(1);
    27d0:	4505                	li	a0,1
    27d2:	00003097          	auipc	ra,0x3
    27d6:	448080e7          	jalr	1096(ra) # 5c1a <exit>
    printf("sbrk(rwsbrk) failed\n");
    27da:	00004517          	auipc	a0,0x4
    27de:	6b650513          	addi	a0,a0,1718 # 6e90 <malloc+0xe44>
    27e2:	00003097          	auipc	ra,0x3
    27e6:	7b2080e7          	jalr	1970(ra) # 5f94 <printf>
    exit(1);
    27ea:	4505                	li	a0,1
    27ec:	00003097          	auipc	ra,0x3
    27f0:	42e080e7          	jalr	1070(ra) # 5c1a <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    27f4:	00004517          	auipc	a0,0x4
    27f8:	6b450513          	addi	a0,a0,1716 # 6ea8 <malloc+0xe5c>
    27fc:	00003097          	auipc	ra,0x3
    2800:	798080e7          	jalr	1944(ra) # 5f94 <printf>
    exit(1);
    2804:	4505                	li	a0,1
    2806:	00003097          	auipc	ra,0x3
    280a:	414080e7          	jalr	1044(ra) # 5c1a <exit>
    printf("open(rwsbrk) failed\n");
    280e:	00004517          	auipc	a0,0x4
    2812:	6c250513          	addi	a0,a0,1730 # 6ed0 <malloc+0xe84>
    2816:	00003097          	auipc	ra,0x3
    281a:	77e080e7          	jalr	1918(ra) # 5f94 <printf>
    exit(1);
    281e:	4505                	li	a0,1
    2820:	00003097          	auipc	ra,0x3
    2824:	3fa080e7          	jalr	1018(ra) # 5c1a <exit>
  close(fd);
    2828:	854a                	mv	a0,s2
    282a:	00003097          	auipc	ra,0x3
    282e:	418080e7          	jalr	1048(ra) # 5c42 <close>
  unlink("rwsbrk");
    2832:	00004517          	auipc	a0,0x4
    2836:	69650513          	addi	a0,a0,1686 # 6ec8 <malloc+0xe7c>
    283a:	00003097          	auipc	ra,0x3
    283e:	430080e7          	jalr	1072(ra) # 5c6a <unlink>
  fd = open("xv6-readme", O_RDONLY);
    2842:	4581                	li	a1,0
    2844:	00004517          	auipc	a0,0x4
    2848:	b0c50513          	addi	a0,a0,-1268 # 6350 <malloc+0x304>
    284c:	00003097          	auipc	ra,0x3
    2850:	40e080e7          	jalr	1038(ra) # 5c5a <open>
    2854:	892a                	mv	s2,a0
  if (fd < 0) {
    2856:	02054963          	bltz	a0,2888 <rwsbrk+0x12a>
  n = read(fd, (void *)(a + 4096), 10);
    285a:	4629                	li	a2,10
    285c:	85a6                	mv	a1,s1
    285e:	00003097          	auipc	ra,0x3
    2862:	3d4080e7          	jalr	980(ra) # 5c32 <read>
    2866:	862a                	mv	a2,a0
  if (n >= 0) {
    2868:	02054d63          	bltz	a0,28a2 <rwsbrk+0x144>
    printf("read(fd, %p, 10) returned %d, not -1\n", a + 4096, n);
    286c:	85a6                	mv	a1,s1
    286e:	00004517          	auipc	a0,0x4
    2872:	6aa50513          	addi	a0,a0,1706 # 6f18 <malloc+0xecc>
    2876:	00003097          	auipc	ra,0x3
    287a:	71e080e7          	jalr	1822(ra) # 5f94 <printf>
    exit(1);
    287e:	4505                	li	a0,1
    2880:	00003097          	auipc	ra,0x3
    2884:	39a080e7          	jalr	922(ra) # 5c1a <exit>
    printf("open(rwsbrk) failed\n");
    2888:	00004517          	auipc	a0,0x4
    288c:	64850513          	addi	a0,a0,1608 # 6ed0 <malloc+0xe84>
    2890:	00003097          	auipc	ra,0x3
    2894:	704080e7          	jalr	1796(ra) # 5f94 <printf>
    exit(1);
    2898:	4505                	li	a0,1
    289a:	00003097          	auipc	ra,0x3
    289e:	380080e7          	jalr	896(ra) # 5c1a <exit>
  close(fd);
    28a2:	854a                	mv	a0,s2
    28a4:	00003097          	auipc	ra,0x3
    28a8:	39e080e7          	jalr	926(ra) # 5c42 <close>
  exit(0);
    28ac:	4501                	li	a0,0
    28ae:	00003097          	auipc	ra,0x3
    28b2:	36c080e7          	jalr	876(ra) # 5c1a <exit>

00000000000028b6 <sbrkbasic>:
void sbrkbasic(char *s) {
    28b6:	7139                	addi	sp,sp,-64
    28b8:	fc06                	sd	ra,56(sp)
    28ba:	f822                	sd	s0,48(sp)
    28bc:	f426                	sd	s1,40(sp)
    28be:	f04a                	sd	s2,32(sp)
    28c0:	ec4e                	sd	s3,24(sp)
    28c2:	e852                	sd	s4,16(sp)
    28c4:	0080                	addi	s0,sp,64
    28c6:	8a2a                	mv	s4,a0
  pid = fork();
    28c8:	00003097          	auipc	ra,0x3
    28cc:	34a080e7          	jalr	842(ra) # 5c12 <fork>
  if (pid < 0) {
    28d0:	02054c63          	bltz	a0,2908 <sbrkbasic+0x52>
  if (pid == 0) {
    28d4:	ed21                	bnez	a0,292c <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    28d6:	40000537          	lui	a0,0x40000
    28da:	00003097          	auipc	ra,0x3
    28de:	3c8080e7          	jalr	968(ra) # 5ca2 <sbrk>
    if (a == (char *)0xffffffffffffffffL) {
    28e2:	57fd                	li	a5,-1
    28e4:	02f50f63          	beq	a0,a5,2922 <sbrkbasic+0x6c>
    for (b = a; b < a + TOOMUCH; b += 4096) {
    28e8:	400007b7          	lui	a5,0x40000
    28ec:	97aa                	add	a5,a5,a0
      *b = 99;
    28ee:	06300693          	li	a3,99
    for (b = a; b < a + TOOMUCH; b += 4096) {
    28f2:	6705                	lui	a4,0x1
      *b = 99;
    28f4:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0388>
    for (b = a; b < a + TOOMUCH; b += 4096) {
    28f8:	953a                	add	a0,a0,a4
    28fa:	fef51de3          	bne	a0,a5,28f4 <sbrkbasic+0x3e>
    exit(1);
    28fe:	4505                	li	a0,1
    2900:	00003097          	auipc	ra,0x3
    2904:	31a080e7          	jalr	794(ra) # 5c1a <exit>
    printf("fork failed in sbrkbasic\n");
    2908:	00004517          	auipc	a0,0x4
    290c:	63850513          	addi	a0,a0,1592 # 6f40 <malloc+0xef4>
    2910:	00003097          	auipc	ra,0x3
    2914:	684080e7          	jalr	1668(ra) # 5f94 <printf>
    exit(1);
    2918:	4505                	li	a0,1
    291a:	00003097          	auipc	ra,0x3
    291e:	300080e7          	jalr	768(ra) # 5c1a <exit>
      exit(0);
    2922:	4501                	li	a0,0
    2924:	00003097          	auipc	ra,0x3
    2928:	2f6080e7          	jalr	758(ra) # 5c1a <exit>
  wait(&xstatus);
    292c:	fcc40513          	addi	a0,s0,-52
    2930:	00003097          	auipc	ra,0x3
    2934:	2f2080e7          	jalr	754(ra) # 5c22 <wait>
  if (xstatus == 1) {
    2938:	fcc42703          	lw	a4,-52(s0)
    293c:	4785                	li	a5,1
    293e:	00f70d63          	beq	a4,a5,2958 <sbrkbasic+0xa2>
  a = sbrk(0);
    2942:	4501                	li	a0,0
    2944:	00003097          	auipc	ra,0x3
    2948:	35e080e7          	jalr	862(ra) # 5ca2 <sbrk>
    294c:	84aa                	mv	s1,a0
  for (i = 0; i < 5000; i++) {
    294e:	4901                	li	s2,0
    2950:	6985                	lui	s3,0x1
    2952:	38898993          	addi	s3,s3,904 # 1388 <badarg+0x36>
    2956:	a005                	j	2976 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    2958:	85d2                	mv	a1,s4
    295a:	00004517          	auipc	a0,0x4
    295e:	60650513          	addi	a0,a0,1542 # 6f60 <malloc+0xf14>
    2962:	00003097          	auipc	ra,0x3
    2966:	632080e7          	jalr	1586(ra) # 5f94 <printf>
    exit(1);
    296a:	4505                	li	a0,1
    296c:	00003097          	auipc	ra,0x3
    2970:	2ae080e7          	jalr	686(ra) # 5c1a <exit>
    a = b + 1;
    2974:	84be                	mv	s1,a5
    b = sbrk(1);
    2976:	4505                	li	a0,1
    2978:	00003097          	auipc	ra,0x3
    297c:	32a080e7          	jalr	810(ra) # 5ca2 <sbrk>
    if (b != a) {
    2980:	04951c63          	bne	a0,s1,29d8 <sbrkbasic+0x122>
    *b = 1;
    2984:	4785                	li	a5,1
    2986:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    298a:	00148793          	addi	a5,s1,1
  for (i = 0; i < 5000; i++) {
    298e:	2905                	addiw	s2,s2,1
    2990:	ff3912e3          	bne	s2,s3,2974 <sbrkbasic+0xbe>
  pid = fork();
    2994:	00003097          	auipc	ra,0x3
    2998:	27e080e7          	jalr	638(ra) # 5c12 <fork>
    299c:	892a                	mv	s2,a0
  if (pid < 0) {
    299e:	04054e63          	bltz	a0,29fa <sbrkbasic+0x144>
  c = sbrk(1);
    29a2:	4505                	li	a0,1
    29a4:	00003097          	auipc	ra,0x3
    29a8:	2fe080e7          	jalr	766(ra) # 5ca2 <sbrk>
  c = sbrk(1);
    29ac:	4505                	li	a0,1
    29ae:	00003097          	auipc	ra,0x3
    29b2:	2f4080e7          	jalr	756(ra) # 5ca2 <sbrk>
  if (c != a + 1) {
    29b6:	0489                	addi	s1,s1,2
    29b8:	04a48f63          	beq	s1,a0,2a16 <sbrkbasic+0x160>
    printf("%s: sbrk test failed post-fork\n", s);
    29bc:	85d2                	mv	a1,s4
    29be:	00004517          	auipc	a0,0x4
    29c2:	60250513          	addi	a0,a0,1538 # 6fc0 <malloc+0xf74>
    29c6:	00003097          	auipc	ra,0x3
    29ca:	5ce080e7          	jalr	1486(ra) # 5f94 <printf>
    exit(1);
    29ce:	4505                	li	a0,1
    29d0:	00003097          	auipc	ra,0x3
    29d4:	24a080e7          	jalr	586(ra) # 5c1a <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    29d8:	872a                	mv	a4,a0
    29da:	86a6                	mv	a3,s1
    29dc:	864a                	mv	a2,s2
    29de:	85d2                	mv	a1,s4
    29e0:	00004517          	auipc	a0,0x4
    29e4:	5a050513          	addi	a0,a0,1440 # 6f80 <malloc+0xf34>
    29e8:	00003097          	auipc	ra,0x3
    29ec:	5ac080e7          	jalr	1452(ra) # 5f94 <printf>
      exit(1);
    29f0:	4505                	li	a0,1
    29f2:	00003097          	auipc	ra,0x3
    29f6:	228080e7          	jalr	552(ra) # 5c1a <exit>
    printf("%s: sbrk test fork failed\n", s);
    29fa:	85d2                	mv	a1,s4
    29fc:	00004517          	auipc	a0,0x4
    2a00:	5a450513          	addi	a0,a0,1444 # 6fa0 <malloc+0xf54>
    2a04:	00003097          	auipc	ra,0x3
    2a08:	590080e7          	jalr	1424(ra) # 5f94 <printf>
    exit(1);
    2a0c:	4505                	li	a0,1
    2a0e:	00003097          	auipc	ra,0x3
    2a12:	20c080e7          	jalr	524(ra) # 5c1a <exit>
  if (pid == 0) exit(0);
    2a16:	00091763          	bnez	s2,2a24 <sbrkbasic+0x16e>
    2a1a:	4501                	li	a0,0
    2a1c:	00003097          	auipc	ra,0x3
    2a20:	1fe080e7          	jalr	510(ra) # 5c1a <exit>
  wait(&xstatus);
    2a24:	fcc40513          	addi	a0,s0,-52
    2a28:	00003097          	auipc	ra,0x3
    2a2c:	1fa080e7          	jalr	506(ra) # 5c22 <wait>
  exit(xstatus);
    2a30:	fcc42503          	lw	a0,-52(s0)
    2a34:	00003097          	auipc	ra,0x3
    2a38:	1e6080e7          	jalr	486(ra) # 5c1a <exit>

0000000000002a3c <sbrkmuch>:
void sbrkmuch(char *s) {
    2a3c:	7179                	addi	sp,sp,-48
    2a3e:	f406                	sd	ra,40(sp)
    2a40:	f022                	sd	s0,32(sp)
    2a42:	ec26                	sd	s1,24(sp)
    2a44:	e84a                	sd	s2,16(sp)
    2a46:	e44e                	sd	s3,8(sp)
    2a48:	e052                	sd	s4,0(sp)
    2a4a:	1800                	addi	s0,sp,48
    2a4c:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2a4e:	4501                	li	a0,0
    2a50:	00003097          	auipc	ra,0x3
    2a54:	252080e7          	jalr	594(ra) # 5ca2 <sbrk>
    2a58:	892a                	mv	s2,a0
  a = sbrk(0);
    2a5a:	4501                	li	a0,0
    2a5c:	00003097          	auipc	ra,0x3
    2a60:	246080e7          	jalr	582(ra) # 5ca2 <sbrk>
    2a64:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2a66:	06400537          	lui	a0,0x6400
    2a6a:	9d05                	subw	a0,a0,s1
    2a6c:	00003097          	auipc	ra,0x3
    2a70:	236080e7          	jalr	566(ra) # 5ca2 <sbrk>
  if (p != a) {
    2a74:	0ca49863          	bne	s1,a0,2b44 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2a78:	4501                	li	a0,0
    2a7a:	00003097          	auipc	ra,0x3
    2a7e:	228080e7          	jalr	552(ra) # 5ca2 <sbrk>
    2a82:	87aa                	mv	a5,a0
  for (char *pp = a; pp < eee; pp += 4096) *pp = 1;
    2a84:	00a4f963          	bgeu	s1,a0,2a96 <sbrkmuch+0x5a>
    2a88:	4685                	li	a3,1
    2a8a:	6705                	lui	a4,0x1
    2a8c:	00d48023          	sb	a3,0(s1)
    2a90:	94ba                	add	s1,s1,a4
    2a92:	fef4ede3          	bltu	s1,a5,2a8c <sbrkmuch+0x50>
  *lastaddr = 99;
    2a96:	064007b7          	lui	a5,0x6400
    2a9a:	06300713          	li	a4,99
    2a9e:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0387>
  a = sbrk(0);
    2aa2:	4501                	li	a0,0
    2aa4:	00003097          	auipc	ra,0x3
    2aa8:	1fe080e7          	jalr	510(ra) # 5ca2 <sbrk>
    2aac:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2aae:	757d                	lui	a0,0xfffff
    2ab0:	00003097          	auipc	ra,0x3
    2ab4:	1f2080e7          	jalr	498(ra) # 5ca2 <sbrk>
  if (c == (char *)0xffffffffffffffffL) {
    2ab8:	57fd                	li	a5,-1
    2aba:	0af50363          	beq	a0,a5,2b60 <sbrkmuch+0x124>
  c = sbrk(0);
    2abe:	4501                	li	a0,0
    2ac0:	00003097          	auipc	ra,0x3
    2ac4:	1e2080e7          	jalr	482(ra) # 5ca2 <sbrk>
  if (c != a - PGSIZE) {
    2ac8:	77fd                	lui	a5,0xfffff
    2aca:	97a6                	add	a5,a5,s1
    2acc:	0af51863          	bne	a0,a5,2b7c <sbrkmuch+0x140>
  a = sbrk(0);
    2ad0:	4501                	li	a0,0
    2ad2:	00003097          	auipc	ra,0x3
    2ad6:	1d0080e7          	jalr	464(ra) # 5ca2 <sbrk>
    2ada:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2adc:	6505                	lui	a0,0x1
    2ade:	00003097          	auipc	ra,0x3
    2ae2:	1c4080e7          	jalr	452(ra) # 5ca2 <sbrk>
    2ae6:	8a2a                	mv	s4,a0
  if (c != a || sbrk(0) != a + PGSIZE) {
    2ae8:	0aa49a63          	bne	s1,a0,2b9c <sbrkmuch+0x160>
    2aec:	4501                	li	a0,0
    2aee:	00003097          	auipc	ra,0x3
    2af2:	1b4080e7          	jalr	436(ra) # 5ca2 <sbrk>
    2af6:	6785                	lui	a5,0x1
    2af8:	97a6                	add	a5,a5,s1
    2afa:	0af51163          	bne	a0,a5,2b9c <sbrkmuch+0x160>
  if (*lastaddr == 99) {
    2afe:	064007b7          	lui	a5,0x6400
    2b02:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0387>
    2b06:	06300793          	li	a5,99
    2b0a:	0af70963          	beq	a4,a5,2bbc <sbrkmuch+0x180>
  a = sbrk(0);
    2b0e:	4501                	li	a0,0
    2b10:	00003097          	auipc	ra,0x3
    2b14:	192080e7          	jalr	402(ra) # 5ca2 <sbrk>
    2b18:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2b1a:	4501                	li	a0,0
    2b1c:	00003097          	auipc	ra,0x3
    2b20:	186080e7          	jalr	390(ra) # 5ca2 <sbrk>
    2b24:	40a9053b          	subw	a0,s2,a0
    2b28:	00003097          	auipc	ra,0x3
    2b2c:	17a080e7          	jalr	378(ra) # 5ca2 <sbrk>
  if (c != a) {
    2b30:	0aa49463          	bne	s1,a0,2bd8 <sbrkmuch+0x19c>
}
    2b34:	70a2                	ld	ra,40(sp)
    2b36:	7402                	ld	s0,32(sp)
    2b38:	64e2                	ld	s1,24(sp)
    2b3a:	6942                	ld	s2,16(sp)
    2b3c:	69a2                	ld	s3,8(sp)
    2b3e:	6a02                	ld	s4,0(sp)
    2b40:	6145                	addi	sp,sp,48
    2b42:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n",
    2b44:	85ce                	mv	a1,s3
    2b46:	00004517          	auipc	a0,0x4
    2b4a:	49a50513          	addi	a0,a0,1178 # 6fe0 <malloc+0xf94>
    2b4e:	00003097          	auipc	ra,0x3
    2b52:	446080e7          	jalr	1094(ra) # 5f94 <printf>
    exit(1);
    2b56:	4505                	li	a0,1
    2b58:	00003097          	auipc	ra,0x3
    2b5c:	0c2080e7          	jalr	194(ra) # 5c1a <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2b60:	85ce                	mv	a1,s3
    2b62:	00004517          	auipc	a0,0x4
    2b66:	4c650513          	addi	a0,a0,1222 # 7028 <malloc+0xfdc>
    2b6a:	00003097          	auipc	ra,0x3
    2b6e:	42a080e7          	jalr	1066(ra) # 5f94 <printf>
    exit(1);
    2b72:	4505                	li	a0,1
    2b74:	00003097          	auipc	ra,0x3
    2b78:	0a6080e7          	jalr	166(ra) # 5c1a <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a,
    2b7c:	86aa                	mv	a3,a0
    2b7e:	8626                	mv	a2,s1
    2b80:	85ce                	mv	a1,s3
    2b82:	00004517          	auipc	a0,0x4
    2b86:	4c650513          	addi	a0,a0,1222 # 7048 <malloc+0xffc>
    2b8a:	00003097          	auipc	ra,0x3
    2b8e:	40a080e7          	jalr	1034(ra) # 5f94 <printf>
    exit(1);
    2b92:	4505                	li	a0,1
    2b94:	00003097          	auipc	ra,0x3
    2b98:	086080e7          	jalr	134(ra) # 5c1a <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2b9c:	86d2                	mv	a3,s4
    2b9e:	8626                	mv	a2,s1
    2ba0:	85ce                	mv	a1,s3
    2ba2:	00004517          	auipc	a0,0x4
    2ba6:	4e650513          	addi	a0,a0,1254 # 7088 <malloc+0x103c>
    2baa:	00003097          	auipc	ra,0x3
    2bae:	3ea080e7          	jalr	1002(ra) # 5f94 <printf>
    exit(1);
    2bb2:	4505                	li	a0,1
    2bb4:	00003097          	auipc	ra,0x3
    2bb8:	066080e7          	jalr	102(ra) # 5c1a <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2bbc:	85ce                	mv	a1,s3
    2bbe:	00004517          	auipc	a0,0x4
    2bc2:	4fa50513          	addi	a0,a0,1274 # 70b8 <malloc+0x106c>
    2bc6:	00003097          	auipc	ra,0x3
    2bca:	3ce080e7          	jalr	974(ra) # 5f94 <printf>
    exit(1);
    2bce:	4505                	li	a0,1
    2bd0:	00003097          	auipc	ra,0x3
    2bd4:	04a080e7          	jalr	74(ra) # 5c1a <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2bd8:	86aa                	mv	a3,a0
    2bda:	8626                	mv	a2,s1
    2bdc:	85ce                	mv	a1,s3
    2bde:	00004517          	auipc	a0,0x4
    2be2:	51250513          	addi	a0,a0,1298 # 70f0 <malloc+0x10a4>
    2be6:	00003097          	auipc	ra,0x3
    2bea:	3ae080e7          	jalr	942(ra) # 5f94 <printf>
    exit(1);
    2bee:	4505                	li	a0,1
    2bf0:	00003097          	auipc	ra,0x3
    2bf4:	02a080e7          	jalr	42(ra) # 5c1a <exit>

0000000000002bf8 <sbrkarg>:
void sbrkarg(char *s) {
    2bf8:	7179                	addi	sp,sp,-48
    2bfa:	f406                	sd	ra,40(sp)
    2bfc:	f022                	sd	s0,32(sp)
    2bfe:	ec26                	sd	s1,24(sp)
    2c00:	e84a                	sd	s2,16(sp)
    2c02:	e44e                	sd	s3,8(sp)
    2c04:	1800                	addi	s0,sp,48
    2c06:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2c08:	6505                	lui	a0,0x1
    2c0a:	00003097          	auipc	ra,0x3
    2c0e:	098080e7          	jalr	152(ra) # 5ca2 <sbrk>
    2c12:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE | O_WRONLY);
    2c14:	20100593          	li	a1,513
    2c18:	00004517          	auipc	a0,0x4
    2c1c:	50050513          	addi	a0,a0,1280 # 7118 <malloc+0x10cc>
    2c20:	00003097          	auipc	ra,0x3
    2c24:	03a080e7          	jalr	58(ra) # 5c5a <open>
    2c28:	84aa                	mv	s1,a0
  unlink("sbrk");
    2c2a:	00004517          	auipc	a0,0x4
    2c2e:	4ee50513          	addi	a0,a0,1262 # 7118 <malloc+0x10cc>
    2c32:	00003097          	auipc	ra,0x3
    2c36:	038080e7          	jalr	56(ra) # 5c6a <unlink>
  if (fd < 0) {
    2c3a:	0404c163          	bltz	s1,2c7c <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2c3e:	6605                	lui	a2,0x1
    2c40:	85ca                	mv	a1,s2
    2c42:	8526                	mv	a0,s1
    2c44:	00003097          	auipc	ra,0x3
    2c48:	ff6080e7          	jalr	-10(ra) # 5c3a <write>
    2c4c:	04054663          	bltz	a0,2c98 <sbrkarg+0xa0>
  close(fd);
    2c50:	8526                	mv	a0,s1
    2c52:	00003097          	auipc	ra,0x3
    2c56:	ff0080e7          	jalr	-16(ra) # 5c42 <close>
  a = sbrk(PGSIZE);
    2c5a:	6505                	lui	a0,0x1
    2c5c:	00003097          	auipc	ra,0x3
    2c60:	046080e7          	jalr	70(ra) # 5ca2 <sbrk>
  if (pipe((int *)a) != 0) {
    2c64:	00003097          	auipc	ra,0x3
    2c68:	fc6080e7          	jalr	-58(ra) # 5c2a <pipe>
    2c6c:	e521                	bnez	a0,2cb4 <sbrkarg+0xbc>
}
    2c6e:	70a2                	ld	ra,40(sp)
    2c70:	7402                	ld	s0,32(sp)
    2c72:	64e2                	ld	s1,24(sp)
    2c74:	6942                	ld	s2,16(sp)
    2c76:	69a2                	ld	s3,8(sp)
    2c78:	6145                	addi	sp,sp,48
    2c7a:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2c7c:	85ce                	mv	a1,s3
    2c7e:	00004517          	auipc	a0,0x4
    2c82:	4a250513          	addi	a0,a0,1186 # 7120 <malloc+0x10d4>
    2c86:	00003097          	auipc	ra,0x3
    2c8a:	30e080e7          	jalr	782(ra) # 5f94 <printf>
    exit(1);
    2c8e:	4505                	li	a0,1
    2c90:	00003097          	auipc	ra,0x3
    2c94:	f8a080e7          	jalr	-118(ra) # 5c1a <exit>
    printf("%s: write sbrk failed\n", s);
    2c98:	85ce                	mv	a1,s3
    2c9a:	00004517          	auipc	a0,0x4
    2c9e:	49e50513          	addi	a0,a0,1182 # 7138 <malloc+0x10ec>
    2ca2:	00003097          	auipc	ra,0x3
    2ca6:	2f2080e7          	jalr	754(ra) # 5f94 <printf>
    exit(1);
    2caa:	4505                	li	a0,1
    2cac:	00003097          	auipc	ra,0x3
    2cb0:	f6e080e7          	jalr	-146(ra) # 5c1a <exit>
    printf("%s: pipe() failed\n", s);
    2cb4:	85ce                	mv	a1,s3
    2cb6:	00004517          	auipc	a0,0x4
    2cba:	e6250513          	addi	a0,a0,-414 # 6b18 <malloc+0xacc>
    2cbe:	00003097          	auipc	ra,0x3
    2cc2:	2d6080e7          	jalr	726(ra) # 5f94 <printf>
    exit(1);
    2cc6:	4505                	li	a0,1
    2cc8:	00003097          	auipc	ra,0x3
    2ccc:	f52080e7          	jalr	-174(ra) # 5c1a <exit>

0000000000002cd0 <argptest>:
void argptest(char *s) {
    2cd0:	1101                	addi	sp,sp,-32
    2cd2:	ec06                	sd	ra,24(sp)
    2cd4:	e822                	sd	s0,16(sp)
    2cd6:	e426                	sd	s1,8(sp)
    2cd8:	e04a                	sd	s2,0(sp)
    2cda:	1000                	addi	s0,sp,32
    2cdc:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2cde:	4581                	li	a1,0
    2ce0:	00004517          	auipc	a0,0x4
    2ce4:	47050513          	addi	a0,a0,1136 # 7150 <malloc+0x1104>
    2ce8:	00003097          	auipc	ra,0x3
    2cec:	f72080e7          	jalr	-142(ra) # 5c5a <open>
  if (fd < 0) {
    2cf0:	02054b63          	bltz	a0,2d26 <argptest+0x56>
    2cf4:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2cf6:	4501                	li	a0,0
    2cf8:	00003097          	auipc	ra,0x3
    2cfc:	faa080e7          	jalr	-86(ra) # 5ca2 <sbrk>
    2d00:	567d                	li	a2,-1
    2d02:	fff50593          	addi	a1,a0,-1
    2d06:	8526                	mv	a0,s1
    2d08:	00003097          	auipc	ra,0x3
    2d0c:	f2a080e7          	jalr	-214(ra) # 5c32 <read>
  close(fd);
    2d10:	8526                	mv	a0,s1
    2d12:	00003097          	auipc	ra,0x3
    2d16:	f30080e7          	jalr	-208(ra) # 5c42 <close>
}
    2d1a:	60e2                	ld	ra,24(sp)
    2d1c:	6442                	ld	s0,16(sp)
    2d1e:	64a2                	ld	s1,8(sp)
    2d20:	6902                	ld	s2,0(sp)
    2d22:	6105                	addi	sp,sp,32
    2d24:	8082                	ret
    printf("%s: open failed\n", s);
    2d26:	85ca                	mv	a1,s2
    2d28:	00004517          	auipc	a0,0x4
    2d2c:	d0050513          	addi	a0,a0,-768 # 6a28 <malloc+0x9dc>
    2d30:	00003097          	auipc	ra,0x3
    2d34:	264080e7          	jalr	612(ra) # 5f94 <printf>
    exit(1);
    2d38:	4505                	li	a0,1
    2d3a:	00003097          	auipc	ra,0x3
    2d3e:	ee0080e7          	jalr	-288(ra) # 5c1a <exit>

0000000000002d42 <sbrkbugs>:
void sbrkbugs(char *s) {
    2d42:	1141                	addi	sp,sp,-16
    2d44:	e406                	sd	ra,8(sp)
    2d46:	e022                	sd	s0,0(sp)
    2d48:	0800                	addi	s0,sp,16
  int pid = fork();
    2d4a:	00003097          	auipc	ra,0x3
    2d4e:	ec8080e7          	jalr	-312(ra) # 5c12 <fork>
  if (pid < 0) {
    2d52:	02054263          	bltz	a0,2d76 <sbrkbugs+0x34>
  if (pid == 0) {
    2d56:	ed0d                	bnez	a0,2d90 <sbrkbugs+0x4e>
    int sz = (uint64)sbrk(0);
    2d58:	00003097          	auipc	ra,0x3
    2d5c:	f4a080e7          	jalr	-182(ra) # 5ca2 <sbrk>
    sbrk(-sz);
    2d60:	40a0053b          	negw	a0,a0
    2d64:	00003097          	auipc	ra,0x3
    2d68:	f3e080e7          	jalr	-194(ra) # 5ca2 <sbrk>
    exit(0);
    2d6c:	4501                	li	a0,0
    2d6e:	00003097          	auipc	ra,0x3
    2d72:	eac080e7          	jalr	-340(ra) # 5c1a <exit>
    printf("fork failed\n");
    2d76:	00004517          	auipc	a0,0x4
    2d7a:	0a250513          	addi	a0,a0,162 # 6e18 <malloc+0xdcc>
    2d7e:	00003097          	auipc	ra,0x3
    2d82:	216080e7          	jalr	534(ra) # 5f94 <printf>
    exit(1);
    2d86:	4505                	li	a0,1
    2d88:	00003097          	auipc	ra,0x3
    2d8c:	e92080e7          	jalr	-366(ra) # 5c1a <exit>
  wait(0);
    2d90:	4501                	li	a0,0
    2d92:	00003097          	auipc	ra,0x3
    2d96:	e90080e7          	jalr	-368(ra) # 5c22 <wait>
  pid = fork();
    2d9a:	00003097          	auipc	ra,0x3
    2d9e:	e78080e7          	jalr	-392(ra) # 5c12 <fork>
  if (pid < 0) {
    2da2:	02054563          	bltz	a0,2dcc <sbrkbugs+0x8a>
  if (pid == 0) {
    2da6:	e121                	bnez	a0,2de6 <sbrkbugs+0xa4>
    int sz = (uint64)sbrk(0);
    2da8:	00003097          	auipc	ra,0x3
    2dac:	efa080e7          	jalr	-262(ra) # 5ca2 <sbrk>
    sbrk(-(sz - 3500));
    2db0:	6785                	lui	a5,0x1
    2db2:	dac7879b          	addiw	a5,a5,-596 # dac <unlinkread+0x66>
    2db6:	40a7853b          	subw	a0,a5,a0
    2dba:	00003097          	auipc	ra,0x3
    2dbe:	ee8080e7          	jalr	-280(ra) # 5ca2 <sbrk>
    exit(0);
    2dc2:	4501                	li	a0,0
    2dc4:	00003097          	auipc	ra,0x3
    2dc8:	e56080e7          	jalr	-426(ra) # 5c1a <exit>
    printf("fork failed\n");
    2dcc:	00004517          	auipc	a0,0x4
    2dd0:	04c50513          	addi	a0,a0,76 # 6e18 <malloc+0xdcc>
    2dd4:	00003097          	auipc	ra,0x3
    2dd8:	1c0080e7          	jalr	448(ra) # 5f94 <printf>
    exit(1);
    2ddc:	4505                	li	a0,1
    2dde:	00003097          	auipc	ra,0x3
    2de2:	e3c080e7          	jalr	-452(ra) # 5c1a <exit>
  wait(0);
    2de6:	4501                	li	a0,0
    2de8:	00003097          	auipc	ra,0x3
    2dec:	e3a080e7          	jalr	-454(ra) # 5c22 <wait>
  pid = fork();
    2df0:	00003097          	auipc	ra,0x3
    2df4:	e22080e7          	jalr	-478(ra) # 5c12 <fork>
  if (pid < 0) {
    2df8:	02054a63          	bltz	a0,2e2c <sbrkbugs+0xea>
  if (pid == 0) {
    2dfc:	e529                	bnez	a0,2e46 <sbrkbugs+0x104>
    sbrk((10 * 4096 + 2048) - (uint64)sbrk(0));
    2dfe:	00003097          	auipc	ra,0x3
    2e02:	ea4080e7          	jalr	-348(ra) # 5ca2 <sbrk>
    2e06:	67ad                	lui	a5,0xb
    2e08:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x298>
    2e0c:	40a7853b          	subw	a0,a5,a0
    2e10:	00003097          	auipc	ra,0x3
    2e14:	e92080e7          	jalr	-366(ra) # 5ca2 <sbrk>
    sbrk(-10);
    2e18:	5559                	li	a0,-10
    2e1a:	00003097          	auipc	ra,0x3
    2e1e:	e88080e7          	jalr	-376(ra) # 5ca2 <sbrk>
    exit(0);
    2e22:	4501                	li	a0,0
    2e24:	00003097          	auipc	ra,0x3
    2e28:	df6080e7          	jalr	-522(ra) # 5c1a <exit>
    printf("fork failed\n");
    2e2c:	00004517          	auipc	a0,0x4
    2e30:	fec50513          	addi	a0,a0,-20 # 6e18 <malloc+0xdcc>
    2e34:	00003097          	auipc	ra,0x3
    2e38:	160080e7          	jalr	352(ra) # 5f94 <printf>
    exit(1);
    2e3c:	4505                	li	a0,1
    2e3e:	00003097          	auipc	ra,0x3
    2e42:	ddc080e7          	jalr	-548(ra) # 5c1a <exit>
  wait(0);
    2e46:	4501                	li	a0,0
    2e48:	00003097          	auipc	ra,0x3
    2e4c:	dda080e7          	jalr	-550(ra) # 5c22 <wait>
  exit(0);
    2e50:	4501                	li	a0,0
    2e52:	00003097          	auipc	ra,0x3
    2e56:	dc8080e7          	jalr	-568(ra) # 5c1a <exit>

0000000000002e5a <sbrklast>:
void sbrklast(char *s) {
    2e5a:	7179                	addi	sp,sp,-48
    2e5c:	f406                	sd	ra,40(sp)
    2e5e:	f022                	sd	s0,32(sp)
    2e60:	ec26                	sd	s1,24(sp)
    2e62:	e84a                	sd	s2,16(sp)
    2e64:	e44e                	sd	s3,8(sp)
    2e66:	e052                	sd	s4,0(sp)
    2e68:	1800                	addi	s0,sp,48
  uint64 top = (uint64)sbrk(0);
    2e6a:	4501                	li	a0,0
    2e6c:	00003097          	auipc	ra,0x3
    2e70:	e36080e7          	jalr	-458(ra) # 5ca2 <sbrk>
  if ((top % 4096) != 0) sbrk(4096 - (top % 4096));
    2e74:	03451793          	slli	a5,a0,0x34
    2e78:	ebd9                	bnez	a5,2f0e <sbrklast+0xb4>
  sbrk(4096);
    2e7a:	6505                	lui	a0,0x1
    2e7c:	00003097          	auipc	ra,0x3
    2e80:	e26080e7          	jalr	-474(ra) # 5ca2 <sbrk>
  sbrk(10);
    2e84:	4529                	li	a0,10
    2e86:	00003097          	auipc	ra,0x3
    2e8a:	e1c080e7          	jalr	-484(ra) # 5ca2 <sbrk>
  sbrk(-20);
    2e8e:	5531                	li	a0,-20
    2e90:	00003097          	auipc	ra,0x3
    2e94:	e12080e7          	jalr	-494(ra) # 5ca2 <sbrk>
  top = (uint64)sbrk(0);
    2e98:	4501                	li	a0,0
    2e9a:	00003097          	auipc	ra,0x3
    2e9e:	e08080e7          	jalr	-504(ra) # 5ca2 <sbrk>
    2ea2:	84aa                	mv	s1,a0
  char *p = (char *)(top - 64);
    2ea4:	fc050913          	addi	s2,a0,-64 # fc0 <linktest+0xc4>
  p[0] = 'x';
    2ea8:	07800a13          	li	s4,120
    2eac:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2eb0:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR | O_CREATE);
    2eb4:	20200593          	li	a1,514
    2eb8:	854a                	mv	a0,s2
    2eba:	00003097          	auipc	ra,0x3
    2ebe:	da0080e7          	jalr	-608(ra) # 5c5a <open>
    2ec2:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2ec4:	4605                	li	a2,1
    2ec6:	85ca                	mv	a1,s2
    2ec8:	00003097          	auipc	ra,0x3
    2ecc:	d72080e7          	jalr	-654(ra) # 5c3a <write>
  close(fd);
    2ed0:	854e                	mv	a0,s3
    2ed2:	00003097          	auipc	ra,0x3
    2ed6:	d70080e7          	jalr	-656(ra) # 5c42 <close>
  fd = open(p, O_RDWR);
    2eda:	4589                	li	a1,2
    2edc:	854a                	mv	a0,s2
    2ede:	00003097          	auipc	ra,0x3
    2ee2:	d7c080e7          	jalr	-644(ra) # 5c5a <open>
  p[0] = '\0';
    2ee6:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2eea:	4605                	li	a2,1
    2eec:	85ca                	mv	a1,s2
    2eee:	00003097          	auipc	ra,0x3
    2ef2:	d44080e7          	jalr	-700(ra) # 5c32 <read>
  if (p[0] != 'x') exit(1);
    2ef6:	fc04c783          	lbu	a5,-64(s1)
    2efa:	03479463          	bne	a5,s4,2f22 <sbrklast+0xc8>
}
    2efe:	70a2                	ld	ra,40(sp)
    2f00:	7402                	ld	s0,32(sp)
    2f02:	64e2                	ld	s1,24(sp)
    2f04:	6942                	ld	s2,16(sp)
    2f06:	69a2                	ld	s3,8(sp)
    2f08:	6a02                	ld	s4,0(sp)
    2f0a:	6145                	addi	sp,sp,48
    2f0c:	8082                	ret
  if ((top % 4096) != 0) sbrk(4096 - (top % 4096));
    2f0e:	0347d513          	srli	a0,a5,0x34
    2f12:	6785                	lui	a5,0x1
    2f14:	40a7853b          	subw	a0,a5,a0
    2f18:	00003097          	auipc	ra,0x3
    2f1c:	d8a080e7          	jalr	-630(ra) # 5ca2 <sbrk>
    2f20:	bfa9                	j	2e7a <sbrklast+0x20>
  if (p[0] != 'x') exit(1);
    2f22:	4505                	li	a0,1
    2f24:	00003097          	auipc	ra,0x3
    2f28:	cf6080e7          	jalr	-778(ra) # 5c1a <exit>

0000000000002f2c <sbrk8000>:
void sbrk8000(char *s) {
    2f2c:	1141                	addi	sp,sp,-16
    2f2e:	e406                	sd	ra,8(sp)
    2f30:	e022                	sd	s0,0(sp)
    2f32:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2f34:	80000537          	lui	a0,0x80000
    2f38:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff038c>
    2f3a:	00003097          	auipc	ra,0x3
    2f3e:	d68080e7          	jalr	-664(ra) # 5ca2 <sbrk>
  volatile char *top = sbrk(0);
    2f42:	4501                	li	a0,0
    2f44:	00003097          	auipc	ra,0x3
    2f48:	d5e080e7          	jalr	-674(ra) # 5ca2 <sbrk>
  *(top - 1) = *(top - 1) + 1;
    2f4c:	fff54783          	lbu	a5,-1(a0)
    2f50:	2785                	addiw	a5,a5,1 # 1001 <linktest+0x105>
    2f52:	0ff7f793          	zext.b	a5,a5
    2f56:	fef50fa3          	sb	a5,-1(a0)
}
    2f5a:	60a2                	ld	ra,8(sp)
    2f5c:	6402                	ld	s0,0(sp)
    2f5e:	0141                	addi	sp,sp,16
    2f60:	8082                	ret

0000000000002f62 <execout>:
void execout(char *s) {
    2f62:	715d                	addi	sp,sp,-80
    2f64:	e486                	sd	ra,72(sp)
    2f66:	e0a2                	sd	s0,64(sp)
    2f68:	fc26                	sd	s1,56(sp)
    2f6a:	f84a                	sd	s2,48(sp)
    2f6c:	f44e                	sd	s3,40(sp)
    2f6e:	f052                	sd	s4,32(sp)
    2f70:	0880                	addi	s0,sp,80
  for (int avail = 0; avail < 15; avail++) {
    2f72:	4901                	li	s2,0
    2f74:	49bd                	li	s3,15
    int pid = fork();
    2f76:	00003097          	auipc	ra,0x3
    2f7a:	c9c080e7          	jalr	-868(ra) # 5c12 <fork>
    2f7e:	84aa                	mv	s1,a0
    if (pid < 0) {
    2f80:	02054063          	bltz	a0,2fa0 <execout+0x3e>
    } else if (pid == 0) {
    2f84:	c91d                	beqz	a0,2fba <execout+0x58>
      wait((int *)0);
    2f86:	4501                	li	a0,0
    2f88:	00003097          	auipc	ra,0x3
    2f8c:	c9a080e7          	jalr	-870(ra) # 5c22 <wait>
  for (int avail = 0; avail < 15; avail++) {
    2f90:	2905                	addiw	s2,s2,1
    2f92:	ff3912e3          	bne	s2,s3,2f76 <execout+0x14>
  exit(0);
    2f96:	4501                	li	a0,0
    2f98:	00003097          	auipc	ra,0x3
    2f9c:	c82080e7          	jalr	-894(ra) # 5c1a <exit>
      printf("fork failed\n");
    2fa0:	00004517          	auipc	a0,0x4
    2fa4:	e7850513          	addi	a0,a0,-392 # 6e18 <malloc+0xdcc>
    2fa8:	00003097          	auipc	ra,0x3
    2fac:	fec080e7          	jalr	-20(ra) # 5f94 <printf>
      exit(1);
    2fb0:	4505                	li	a0,1
    2fb2:	00003097          	auipc	ra,0x3
    2fb6:	c68080e7          	jalr	-920(ra) # 5c1a <exit>
        if (a == 0xffffffffffffffffLL) break;
    2fba:	59fd                	li	s3,-1
        *(char *)(a + 4096 - 1) = 1;
    2fbc:	4a05                	li	s4,1
        uint64 a = (uint64)sbrk(4096);
    2fbe:	6505                	lui	a0,0x1
    2fc0:	00003097          	auipc	ra,0x3
    2fc4:	ce2080e7          	jalr	-798(ra) # 5ca2 <sbrk>
        if (a == 0xffffffffffffffffLL) break;
    2fc8:	01350763          	beq	a0,s3,2fd6 <execout+0x74>
        *(char *)(a + 4096 - 1) = 1;
    2fcc:	6785                	lui	a5,0x1
    2fce:	97aa                	add	a5,a5,a0
    2fd0:	ff478fa3          	sb	s4,-1(a5) # fff <linktest+0x103>
      while (1) {
    2fd4:	b7ed                	j	2fbe <execout+0x5c>
      for (int i = 0; i < avail; i++) sbrk(-4096);
    2fd6:	01205a63          	blez	s2,2fea <execout+0x88>
    2fda:	757d                	lui	a0,0xfffff
    2fdc:	00003097          	auipc	ra,0x3
    2fe0:	cc6080e7          	jalr	-826(ra) # 5ca2 <sbrk>
    2fe4:	2485                	addiw	s1,s1,1
    2fe6:	ff249ae3          	bne	s1,s2,2fda <execout+0x78>
      close(1);
    2fea:	4505                	li	a0,1
    2fec:	00003097          	auipc	ra,0x3
    2ff0:	c56080e7          	jalr	-938(ra) # 5c42 <close>
      char *args[] = {"echo", "x", 0};
    2ff4:	00003517          	auipc	a0,0x3
    2ff8:	18450513          	addi	a0,a0,388 # 6178 <malloc+0x12c>
    2ffc:	faa43c23          	sd	a0,-72(s0)
    3000:	00003797          	auipc	a5,0x3
    3004:	1e878793          	addi	a5,a5,488 # 61e8 <malloc+0x19c>
    3008:	fcf43023          	sd	a5,-64(s0)
    300c:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    3010:	fb840593          	addi	a1,s0,-72
    3014:	00003097          	auipc	ra,0x3
    3018:	c3e080e7          	jalr	-962(ra) # 5c52 <exec>
      exit(0);
    301c:	4501                	li	a0,0
    301e:	00003097          	auipc	ra,0x3
    3022:	bfc080e7          	jalr	-1028(ra) # 5c1a <exit>

0000000000003026 <fourteen>:
void fourteen(char *s) {
    3026:	1101                	addi	sp,sp,-32
    3028:	ec06                	sd	ra,24(sp)
    302a:	e822                	sd	s0,16(sp)
    302c:	e426                	sd	s1,8(sp)
    302e:	1000                	addi	s0,sp,32
    3030:	84aa                	mv	s1,a0
  if (mkdir("12345678901234") != 0) {
    3032:	00004517          	auipc	a0,0x4
    3036:	2f650513          	addi	a0,a0,758 # 7328 <malloc+0x12dc>
    303a:	00003097          	auipc	ra,0x3
    303e:	c48080e7          	jalr	-952(ra) # 5c82 <mkdir>
    3042:	e165                	bnez	a0,3122 <fourteen+0xfc>
  if (mkdir("12345678901234/123456789012345") != 0) {
    3044:	00004517          	auipc	a0,0x4
    3048:	13c50513          	addi	a0,a0,316 # 7180 <malloc+0x1134>
    304c:	00003097          	auipc	ra,0x3
    3050:	c36080e7          	jalr	-970(ra) # 5c82 <mkdir>
    3054:	e56d                	bnez	a0,313e <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    3056:	20000593          	li	a1,512
    305a:	00004517          	auipc	a0,0x4
    305e:	17e50513          	addi	a0,a0,382 # 71d8 <malloc+0x118c>
    3062:	00003097          	auipc	ra,0x3
    3066:	bf8080e7          	jalr	-1032(ra) # 5c5a <open>
  if (fd < 0) {
    306a:	0e054863          	bltz	a0,315a <fourteen+0x134>
  close(fd);
    306e:	00003097          	auipc	ra,0x3
    3072:	bd4080e7          	jalr	-1068(ra) # 5c42 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    3076:	4581                	li	a1,0
    3078:	00004517          	auipc	a0,0x4
    307c:	1d850513          	addi	a0,a0,472 # 7250 <malloc+0x1204>
    3080:	00003097          	auipc	ra,0x3
    3084:	bda080e7          	jalr	-1062(ra) # 5c5a <open>
  if (fd < 0) {
    3088:	0e054763          	bltz	a0,3176 <fourteen+0x150>
  close(fd);
    308c:	00003097          	auipc	ra,0x3
    3090:	bb6080e7          	jalr	-1098(ra) # 5c42 <close>
  if (mkdir("12345678901234/12345678901234") == 0) {
    3094:	00004517          	auipc	a0,0x4
    3098:	22c50513          	addi	a0,a0,556 # 72c0 <malloc+0x1274>
    309c:	00003097          	auipc	ra,0x3
    30a0:	be6080e7          	jalr	-1050(ra) # 5c82 <mkdir>
    30a4:	c57d                	beqz	a0,3192 <fourteen+0x16c>
  if (mkdir("123456789012345/12345678901234") == 0) {
    30a6:	00004517          	auipc	a0,0x4
    30aa:	27250513          	addi	a0,a0,626 # 7318 <malloc+0x12cc>
    30ae:	00003097          	auipc	ra,0x3
    30b2:	bd4080e7          	jalr	-1068(ra) # 5c82 <mkdir>
    30b6:	cd65                	beqz	a0,31ae <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    30b8:	00004517          	auipc	a0,0x4
    30bc:	26050513          	addi	a0,a0,608 # 7318 <malloc+0x12cc>
    30c0:	00003097          	auipc	ra,0x3
    30c4:	baa080e7          	jalr	-1110(ra) # 5c6a <unlink>
  unlink("12345678901234/12345678901234");
    30c8:	00004517          	auipc	a0,0x4
    30cc:	1f850513          	addi	a0,a0,504 # 72c0 <malloc+0x1274>
    30d0:	00003097          	auipc	ra,0x3
    30d4:	b9a080e7          	jalr	-1126(ra) # 5c6a <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    30d8:	00004517          	auipc	a0,0x4
    30dc:	17850513          	addi	a0,a0,376 # 7250 <malloc+0x1204>
    30e0:	00003097          	auipc	ra,0x3
    30e4:	b8a080e7          	jalr	-1142(ra) # 5c6a <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    30e8:	00004517          	auipc	a0,0x4
    30ec:	0f050513          	addi	a0,a0,240 # 71d8 <malloc+0x118c>
    30f0:	00003097          	auipc	ra,0x3
    30f4:	b7a080e7          	jalr	-1158(ra) # 5c6a <unlink>
  unlink("12345678901234/123456789012345");
    30f8:	00004517          	auipc	a0,0x4
    30fc:	08850513          	addi	a0,a0,136 # 7180 <malloc+0x1134>
    3100:	00003097          	auipc	ra,0x3
    3104:	b6a080e7          	jalr	-1174(ra) # 5c6a <unlink>
  unlink("12345678901234");
    3108:	00004517          	auipc	a0,0x4
    310c:	22050513          	addi	a0,a0,544 # 7328 <malloc+0x12dc>
    3110:	00003097          	auipc	ra,0x3
    3114:	b5a080e7          	jalr	-1190(ra) # 5c6a <unlink>
}
    3118:	60e2                	ld	ra,24(sp)
    311a:	6442                	ld	s0,16(sp)
    311c:	64a2                	ld	s1,8(sp)
    311e:	6105                	addi	sp,sp,32
    3120:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    3122:	85a6                	mv	a1,s1
    3124:	00004517          	auipc	a0,0x4
    3128:	03450513          	addi	a0,a0,52 # 7158 <malloc+0x110c>
    312c:	00003097          	auipc	ra,0x3
    3130:	e68080e7          	jalr	-408(ra) # 5f94 <printf>
    exit(1);
    3134:	4505                	li	a0,1
    3136:	00003097          	auipc	ra,0x3
    313a:	ae4080e7          	jalr	-1308(ra) # 5c1a <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    313e:	85a6                	mv	a1,s1
    3140:	00004517          	auipc	a0,0x4
    3144:	06050513          	addi	a0,a0,96 # 71a0 <malloc+0x1154>
    3148:	00003097          	auipc	ra,0x3
    314c:	e4c080e7          	jalr	-436(ra) # 5f94 <printf>
    exit(1);
    3150:	4505                	li	a0,1
    3152:	00003097          	auipc	ra,0x3
    3156:	ac8080e7          	jalr	-1336(ra) # 5c1a <exit>
    printf(
    315a:	85a6                	mv	a1,s1
    315c:	00004517          	auipc	a0,0x4
    3160:	0ac50513          	addi	a0,a0,172 # 7208 <malloc+0x11bc>
    3164:	00003097          	auipc	ra,0x3
    3168:	e30080e7          	jalr	-464(ra) # 5f94 <printf>
    exit(1);
    316c:	4505                	li	a0,1
    316e:	00003097          	auipc	ra,0x3
    3172:	aac080e7          	jalr	-1364(ra) # 5c1a <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    3176:	85a6                	mv	a1,s1
    3178:	00004517          	auipc	a0,0x4
    317c:	10850513          	addi	a0,a0,264 # 7280 <malloc+0x1234>
    3180:	00003097          	auipc	ra,0x3
    3184:	e14080e7          	jalr	-492(ra) # 5f94 <printf>
    exit(1);
    3188:	4505                	li	a0,1
    318a:	00003097          	auipc	ra,0x3
    318e:	a90080e7          	jalr	-1392(ra) # 5c1a <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    3192:	85a6                	mv	a1,s1
    3194:	00004517          	auipc	a0,0x4
    3198:	14c50513          	addi	a0,a0,332 # 72e0 <malloc+0x1294>
    319c:	00003097          	auipc	ra,0x3
    31a0:	df8080e7          	jalr	-520(ra) # 5f94 <printf>
    exit(1);
    31a4:	4505                	li	a0,1
    31a6:	00003097          	auipc	ra,0x3
    31aa:	a74080e7          	jalr	-1420(ra) # 5c1a <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    31ae:	85a6                	mv	a1,s1
    31b0:	00004517          	auipc	a0,0x4
    31b4:	18850513          	addi	a0,a0,392 # 7338 <malloc+0x12ec>
    31b8:	00003097          	auipc	ra,0x3
    31bc:	ddc080e7          	jalr	-548(ra) # 5f94 <printf>
    exit(1);
    31c0:	4505                	li	a0,1
    31c2:	00003097          	auipc	ra,0x3
    31c6:	a58080e7          	jalr	-1448(ra) # 5c1a <exit>

00000000000031ca <diskfull>:
void diskfull(char *s) {
    31ca:	b8010113          	addi	sp,sp,-1152
    31ce:	46113c23          	sd	ra,1144(sp)
    31d2:	46813823          	sd	s0,1136(sp)
    31d6:	46913423          	sd	s1,1128(sp)
    31da:	47213023          	sd	s2,1120(sp)
    31de:	45313c23          	sd	s3,1112(sp)
    31e2:	45413823          	sd	s4,1104(sp)
    31e6:	45513423          	sd	s5,1096(sp)
    31ea:	45613023          	sd	s6,1088(sp)
    31ee:	43713c23          	sd	s7,1080(sp)
    31f2:	43813823          	sd	s8,1072(sp)
    31f6:	43913423          	sd	s9,1064(sp)
    31fa:	48010413          	addi	s0,sp,1152
    31fe:	8caa                	mv	s9,a0
  unlink("diskfulldir");
    3200:	00004517          	auipc	a0,0x4
    3204:	17050513          	addi	a0,a0,368 # 7370 <malloc+0x1324>
    3208:	00003097          	auipc	ra,0x3
    320c:	a62080e7          	jalr	-1438(ra) # 5c6a <unlink>
    3210:	03000993          	li	s3,48
    name[0] = 'b';
    3214:	06200b13          	li	s6,98
    name[1] = 'i';
    3218:	06900a93          	li	s5,105
    name[2] = 'g';
    321c:	06700a13          	li	s4,103
    3220:	10c00b93          	li	s7,268
  for (fi = 0; done == 0 && '0' + fi < 0177; fi++) {
    3224:	07f00c13          	li	s8,127
    3228:	a269                	j	33b2 <diskfull+0x1e8>
      printf("%s: could not create file %s\n", s, name);
    322a:	b8040613          	addi	a2,s0,-1152
    322e:	85e6                	mv	a1,s9
    3230:	00004517          	auipc	a0,0x4
    3234:	15050513          	addi	a0,a0,336 # 7380 <malloc+0x1334>
    3238:	00003097          	auipc	ra,0x3
    323c:	d5c080e7          	jalr	-676(ra) # 5f94 <printf>
      break;
    3240:	a819                	j	3256 <diskfull+0x8c>
        close(fd);
    3242:	854a                	mv	a0,s2
    3244:	00003097          	auipc	ra,0x3
    3248:	9fe080e7          	jalr	-1538(ra) # 5c42 <close>
    close(fd);
    324c:	854a                	mv	a0,s2
    324e:	00003097          	auipc	ra,0x3
    3252:	9f4080e7          	jalr	-1548(ra) # 5c42 <close>
  for (int i = 0; i < nzz; i++) {
    3256:	4481                	li	s1,0
    name[0] = 'z';
    3258:	07a00913          	li	s2,122
  for (int i = 0; i < nzz; i++) {
    325c:	08000993          	li	s3,128
    name[0] = 'z';
    3260:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    3264:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    3268:	41f4d71b          	sraiw	a4,s1,0x1f
    326c:	01b7571b          	srliw	a4,a4,0x1b
    3270:	009707bb          	addw	a5,a4,s1
    3274:	4057d69b          	sraiw	a3,a5,0x5
    3278:	0306869b          	addiw	a3,a3,48
    327c:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    3280:	8bfd                	andi	a5,a5,31
    3282:	9f99                	subw	a5,a5,a4
    3284:	0307879b          	addiw	a5,a5,48
    3288:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    328c:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    3290:	ba040513          	addi	a0,s0,-1120
    3294:	00003097          	auipc	ra,0x3
    3298:	9d6080e7          	jalr	-1578(ra) # 5c6a <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    329c:	60200593          	li	a1,1538
    32a0:	ba040513          	addi	a0,s0,-1120
    32a4:	00003097          	auipc	ra,0x3
    32a8:	9b6080e7          	jalr	-1610(ra) # 5c5a <open>
    if (fd < 0) break;
    32ac:	00054963          	bltz	a0,32be <diskfull+0xf4>
    close(fd);
    32b0:	00003097          	auipc	ra,0x3
    32b4:	992080e7          	jalr	-1646(ra) # 5c42 <close>
  for (int i = 0; i < nzz; i++) {
    32b8:	2485                	addiw	s1,s1,1
    32ba:	fb3493e3          	bne	s1,s3,3260 <diskfull+0x96>
  if (mkdir("diskfulldir") == 0)
    32be:	00004517          	auipc	a0,0x4
    32c2:	0b250513          	addi	a0,a0,178 # 7370 <malloc+0x1324>
    32c6:	00003097          	auipc	ra,0x3
    32ca:	9bc080e7          	jalr	-1604(ra) # 5c82 <mkdir>
    32ce:	12050e63          	beqz	a0,340a <diskfull+0x240>
  unlink("diskfulldir");
    32d2:	00004517          	auipc	a0,0x4
    32d6:	09e50513          	addi	a0,a0,158 # 7370 <malloc+0x1324>
    32da:	00003097          	auipc	ra,0x3
    32de:	990080e7          	jalr	-1648(ra) # 5c6a <unlink>
  for (int i = 0; i < nzz; i++) {
    32e2:	4481                	li	s1,0
    name[0] = 'z';
    32e4:	07a00913          	li	s2,122
  for (int i = 0; i < nzz; i++) {
    32e8:	08000993          	li	s3,128
    name[0] = 'z';
    32ec:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    32f0:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    32f4:	41f4d71b          	sraiw	a4,s1,0x1f
    32f8:	01b7571b          	srliw	a4,a4,0x1b
    32fc:	009707bb          	addw	a5,a4,s1
    3300:	4057d69b          	sraiw	a3,a5,0x5
    3304:	0306869b          	addiw	a3,a3,48
    3308:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    330c:	8bfd                	andi	a5,a5,31
    330e:	9f99                	subw	a5,a5,a4
    3310:	0307879b          	addiw	a5,a5,48
    3314:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    3318:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    331c:	ba040513          	addi	a0,s0,-1120
    3320:	00003097          	auipc	ra,0x3
    3324:	94a080e7          	jalr	-1718(ra) # 5c6a <unlink>
  for (int i = 0; i < nzz; i++) {
    3328:	2485                	addiw	s1,s1,1
    332a:	fd3491e3          	bne	s1,s3,32ec <diskfull+0x122>
    332e:	03000493          	li	s1,48
    name[0] = 'b';
    3332:	06200a93          	li	s5,98
    name[1] = 'i';
    3336:	06900a13          	li	s4,105
    name[2] = 'g';
    333a:	06700993          	li	s3,103
  for (int i = 0; '0' + i < 0177; i++) {
    333e:	07f00913          	li	s2,127
    name[0] = 'b';
    3342:	bb540023          	sb	s5,-1120(s0)
    name[1] = 'i';
    3346:	bb4400a3          	sb	s4,-1119(s0)
    name[2] = 'g';
    334a:	bb340123          	sb	s3,-1118(s0)
    name[3] = '0' + i;
    334e:	ba9401a3          	sb	s1,-1117(s0)
    name[4] = '\0';
    3352:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    3356:	ba040513          	addi	a0,s0,-1120
    335a:	00003097          	auipc	ra,0x3
    335e:	910080e7          	jalr	-1776(ra) # 5c6a <unlink>
  for (int i = 0; '0' + i < 0177; i++) {
    3362:	2485                	addiw	s1,s1,1
    3364:	0ff4f493          	zext.b	s1,s1
    3368:	fd249de3          	bne	s1,s2,3342 <diskfull+0x178>
}
    336c:	47813083          	ld	ra,1144(sp)
    3370:	47013403          	ld	s0,1136(sp)
    3374:	46813483          	ld	s1,1128(sp)
    3378:	46013903          	ld	s2,1120(sp)
    337c:	45813983          	ld	s3,1112(sp)
    3380:	45013a03          	ld	s4,1104(sp)
    3384:	44813a83          	ld	s5,1096(sp)
    3388:	44013b03          	ld	s6,1088(sp)
    338c:	43813b83          	ld	s7,1080(sp)
    3390:	43013c03          	ld	s8,1072(sp)
    3394:	42813c83          	ld	s9,1064(sp)
    3398:	48010113          	addi	sp,sp,1152
    339c:	8082                	ret
    close(fd);
    339e:	854a                	mv	a0,s2
    33a0:	00003097          	auipc	ra,0x3
    33a4:	8a2080e7          	jalr	-1886(ra) # 5c42 <close>
  for (fi = 0; done == 0 && '0' + fi < 0177; fi++) {
    33a8:	2985                	addiw	s3,s3,1
    33aa:	0ff9f993          	zext.b	s3,s3
    33ae:	eb8984e3          	beq	s3,s8,3256 <diskfull+0x8c>
    name[0] = 'b';
    33b2:	b9640023          	sb	s6,-1152(s0)
    name[1] = 'i';
    33b6:	b95400a3          	sb	s5,-1151(s0)
    name[2] = 'g';
    33ba:	b9440123          	sb	s4,-1150(s0)
    name[3] = '0' + fi;
    33be:	b93401a3          	sb	s3,-1149(s0)
    name[4] = '\0';
    33c2:	b8040223          	sb	zero,-1148(s0)
    unlink(name);
    33c6:	b8040513          	addi	a0,s0,-1152
    33ca:	00003097          	auipc	ra,0x3
    33ce:	8a0080e7          	jalr	-1888(ra) # 5c6a <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    33d2:	60200593          	li	a1,1538
    33d6:	b8040513          	addi	a0,s0,-1152
    33da:	00003097          	auipc	ra,0x3
    33de:	880080e7          	jalr	-1920(ra) # 5c5a <open>
    33e2:	892a                	mv	s2,a0
    if (fd < 0) {
    33e4:	e40543e3          	bltz	a0,322a <diskfull+0x60>
    33e8:	84de                	mv	s1,s7
      if (write(fd, buf, BSIZE) != BSIZE) {
    33ea:	40000613          	li	a2,1024
    33ee:	ba040593          	addi	a1,s0,-1120
    33f2:	854a                	mv	a0,s2
    33f4:	00003097          	auipc	ra,0x3
    33f8:	846080e7          	jalr	-1978(ra) # 5c3a <write>
    33fc:	40000793          	li	a5,1024
    3400:	e4f511e3          	bne	a0,a5,3242 <diskfull+0x78>
    for (int i = 0; i < MAXFILE; i++) {
    3404:	34fd                	addiw	s1,s1,-1
    3406:	f0f5                	bnez	s1,33ea <diskfull+0x220>
    3408:	bf59                	j	339e <diskfull+0x1d4>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    340a:	00004517          	auipc	a0,0x4
    340e:	f9650513          	addi	a0,a0,-106 # 73a0 <malloc+0x1354>
    3412:	00003097          	auipc	ra,0x3
    3416:	b82080e7          	jalr	-1150(ra) # 5f94 <printf>
    341a:	bd65                	j	32d2 <diskfull+0x108>

000000000000341c <iputtest>:
void iputtest(char *s) {
    341c:	1101                	addi	sp,sp,-32
    341e:	ec06                	sd	ra,24(sp)
    3420:	e822                	sd	s0,16(sp)
    3422:	e426                	sd	s1,8(sp)
    3424:	1000                	addi	s0,sp,32
    3426:	84aa                	mv	s1,a0
  if (mkdir("iputdir") < 0) {
    3428:	00004517          	auipc	a0,0x4
    342c:	fa850513          	addi	a0,a0,-88 # 73d0 <malloc+0x1384>
    3430:	00003097          	auipc	ra,0x3
    3434:	852080e7          	jalr	-1966(ra) # 5c82 <mkdir>
    3438:	04054563          	bltz	a0,3482 <iputtest+0x66>
  if (chdir("iputdir") < 0) {
    343c:	00004517          	auipc	a0,0x4
    3440:	f9450513          	addi	a0,a0,-108 # 73d0 <malloc+0x1384>
    3444:	00003097          	auipc	ra,0x3
    3448:	846080e7          	jalr	-1978(ra) # 5c8a <chdir>
    344c:	04054963          	bltz	a0,349e <iputtest+0x82>
  if (unlink("../iputdir") < 0) {
    3450:	00004517          	auipc	a0,0x4
    3454:	fc050513          	addi	a0,a0,-64 # 7410 <malloc+0x13c4>
    3458:	00003097          	auipc	ra,0x3
    345c:	812080e7          	jalr	-2030(ra) # 5c6a <unlink>
    3460:	04054d63          	bltz	a0,34ba <iputtest+0x9e>
  if (chdir("/") < 0) {
    3464:	00004517          	auipc	a0,0x4
    3468:	fdc50513          	addi	a0,a0,-36 # 7440 <malloc+0x13f4>
    346c:	00003097          	auipc	ra,0x3
    3470:	81e080e7          	jalr	-2018(ra) # 5c8a <chdir>
    3474:	06054163          	bltz	a0,34d6 <iputtest+0xba>
}
    3478:	60e2                	ld	ra,24(sp)
    347a:	6442                	ld	s0,16(sp)
    347c:	64a2                	ld	s1,8(sp)
    347e:	6105                	addi	sp,sp,32
    3480:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3482:	85a6                	mv	a1,s1
    3484:	00004517          	auipc	a0,0x4
    3488:	f5450513          	addi	a0,a0,-172 # 73d8 <malloc+0x138c>
    348c:	00003097          	auipc	ra,0x3
    3490:	b08080e7          	jalr	-1272(ra) # 5f94 <printf>
    exit(1);
    3494:	4505                	li	a0,1
    3496:	00002097          	auipc	ra,0x2
    349a:	784080e7          	jalr	1924(ra) # 5c1a <exit>
    printf("%s: chdir iputdir failed\n", s);
    349e:	85a6                	mv	a1,s1
    34a0:	00004517          	auipc	a0,0x4
    34a4:	f5050513          	addi	a0,a0,-176 # 73f0 <malloc+0x13a4>
    34a8:	00003097          	auipc	ra,0x3
    34ac:	aec080e7          	jalr	-1300(ra) # 5f94 <printf>
    exit(1);
    34b0:	4505                	li	a0,1
    34b2:	00002097          	auipc	ra,0x2
    34b6:	768080e7          	jalr	1896(ra) # 5c1a <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    34ba:	85a6                	mv	a1,s1
    34bc:	00004517          	auipc	a0,0x4
    34c0:	f6450513          	addi	a0,a0,-156 # 7420 <malloc+0x13d4>
    34c4:	00003097          	auipc	ra,0x3
    34c8:	ad0080e7          	jalr	-1328(ra) # 5f94 <printf>
    exit(1);
    34cc:	4505                	li	a0,1
    34ce:	00002097          	auipc	ra,0x2
    34d2:	74c080e7          	jalr	1868(ra) # 5c1a <exit>
    printf("%s: chdir / failed\n", s);
    34d6:	85a6                	mv	a1,s1
    34d8:	00004517          	auipc	a0,0x4
    34dc:	f7050513          	addi	a0,a0,-144 # 7448 <malloc+0x13fc>
    34e0:	00003097          	auipc	ra,0x3
    34e4:	ab4080e7          	jalr	-1356(ra) # 5f94 <printf>
    exit(1);
    34e8:	4505                	li	a0,1
    34ea:	00002097          	auipc	ra,0x2
    34ee:	730080e7          	jalr	1840(ra) # 5c1a <exit>

00000000000034f2 <exitiputtest>:
void exitiputtest(char *s) {
    34f2:	7179                	addi	sp,sp,-48
    34f4:	f406                	sd	ra,40(sp)
    34f6:	f022                	sd	s0,32(sp)
    34f8:	ec26                	sd	s1,24(sp)
    34fa:	1800                	addi	s0,sp,48
    34fc:	84aa                	mv	s1,a0
  pid = fork();
    34fe:	00002097          	auipc	ra,0x2
    3502:	714080e7          	jalr	1812(ra) # 5c12 <fork>
  if (pid < 0) {
    3506:	04054663          	bltz	a0,3552 <exitiputtest+0x60>
  if (pid == 0) {
    350a:	ed45                	bnez	a0,35c2 <exitiputtest+0xd0>
    if (mkdir("iputdir") < 0) {
    350c:	00004517          	auipc	a0,0x4
    3510:	ec450513          	addi	a0,a0,-316 # 73d0 <malloc+0x1384>
    3514:	00002097          	auipc	ra,0x2
    3518:	76e080e7          	jalr	1902(ra) # 5c82 <mkdir>
    351c:	04054963          	bltz	a0,356e <exitiputtest+0x7c>
    if (chdir("iputdir") < 0) {
    3520:	00004517          	auipc	a0,0x4
    3524:	eb050513          	addi	a0,a0,-336 # 73d0 <malloc+0x1384>
    3528:	00002097          	auipc	ra,0x2
    352c:	762080e7          	jalr	1890(ra) # 5c8a <chdir>
    3530:	04054d63          	bltz	a0,358a <exitiputtest+0x98>
    if (unlink("../iputdir") < 0) {
    3534:	00004517          	auipc	a0,0x4
    3538:	edc50513          	addi	a0,a0,-292 # 7410 <malloc+0x13c4>
    353c:	00002097          	auipc	ra,0x2
    3540:	72e080e7          	jalr	1838(ra) # 5c6a <unlink>
    3544:	06054163          	bltz	a0,35a6 <exitiputtest+0xb4>
    exit(0);
    3548:	4501                	li	a0,0
    354a:	00002097          	auipc	ra,0x2
    354e:	6d0080e7          	jalr	1744(ra) # 5c1a <exit>
    printf("%s: fork failed\n", s);
    3552:	85a6                	mv	a1,s1
    3554:	00003517          	auipc	a0,0x3
    3558:	4bc50513          	addi	a0,a0,1212 # 6a10 <malloc+0x9c4>
    355c:	00003097          	auipc	ra,0x3
    3560:	a38080e7          	jalr	-1480(ra) # 5f94 <printf>
    exit(1);
    3564:	4505                	li	a0,1
    3566:	00002097          	auipc	ra,0x2
    356a:	6b4080e7          	jalr	1716(ra) # 5c1a <exit>
      printf("%s: mkdir failed\n", s);
    356e:	85a6                	mv	a1,s1
    3570:	00004517          	auipc	a0,0x4
    3574:	e6850513          	addi	a0,a0,-408 # 73d8 <malloc+0x138c>
    3578:	00003097          	auipc	ra,0x3
    357c:	a1c080e7          	jalr	-1508(ra) # 5f94 <printf>
      exit(1);
    3580:	4505                	li	a0,1
    3582:	00002097          	auipc	ra,0x2
    3586:	698080e7          	jalr	1688(ra) # 5c1a <exit>
      printf("%s: child chdir failed\n", s);
    358a:	85a6                	mv	a1,s1
    358c:	00004517          	auipc	a0,0x4
    3590:	ed450513          	addi	a0,a0,-300 # 7460 <malloc+0x1414>
    3594:	00003097          	auipc	ra,0x3
    3598:	a00080e7          	jalr	-1536(ra) # 5f94 <printf>
      exit(1);
    359c:	4505                	li	a0,1
    359e:	00002097          	auipc	ra,0x2
    35a2:	67c080e7          	jalr	1660(ra) # 5c1a <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    35a6:	85a6                	mv	a1,s1
    35a8:	00004517          	auipc	a0,0x4
    35ac:	e7850513          	addi	a0,a0,-392 # 7420 <malloc+0x13d4>
    35b0:	00003097          	auipc	ra,0x3
    35b4:	9e4080e7          	jalr	-1564(ra) # 5f94 <printf>
      exit(1);
    35b8:	4505                	li	a0,1
    35ba:	00002097          	auipc	ra,0x2
    35be:	660080e7          	jalr	1632(ra) # 5c1a <exit>
  wait(&xstatus);
    35c2:	fdc40513          	addi	a0,s0,-36
    35c6:	00002097          	auipc	ra,0x2
    35ca:	65c080e7          	jalr	1628(ra) # 5c22 <wait>
  exit(xstatus);
    35ce:	fdc42503          	lw	a0,-36(s0)
    35d2:	00002097          	auipc	ra,0x2
    35d6:	648080e7          	jalr	1608(ra) # 5c1a <exit>

00000000000035da <dirtest>:
void dirtest(char *s) {
    35da:	1101                	addi	sp,sp,-32
    35dc:	ec06                	sd	ra,24(sp)
    35de:	e822                	sd	s0,16(sp)
    35e0:	e426                	sd	s1,8(sp)
    35e2:	1000                	addi	s0,sp,32
    35e4:	84aa                	mv	s1,a0
  if (mkdir("dir0") < 0) {
    35e6:	00004517          	auipc	a0,0x4
    35ea:	e9250513          	addi	a0,a0,-366 # 7478 <malloc+0x142c>
    35ee:	00002097          	auipc	ra,0x2
    35f2:	694080e7          	jalr	1684(ra) # 5c82 <mkdir>
    35f6:	04054563          	bltz	a0,3640 <dirtest+0x66>
  if (chdir("dir0") < 0) {
    35fa:	00004517          	auipc	a0,0x4
    35fe:	e7e50513          	addi	a0,a0,-386 # 7478 <malloc+0x142c>
    3602:	00002097          	auipc	ra,0x2
    3606:	688080e7          	jalr	1672(ra) # 5c8a <chdir>
    360a:	04054963          	bltz	a0,365c <dirtest+0x82>
  if (chdir("..") < 0) {
    360e:	00004517          	auipc	a0,0x4
    3612:	e8a50513          	addi	a0,a0,-374 # 7498 <malloc+0x144c>
    3616:	00002097          	auipc	ra,0x2
    361a:	674080e7          	jalr	1652(ra) # 5c8a <chdir>
    361e:	04054d63          	bltz	a0,3678 <dirtest+0x9e>
  if (unlink("dir0") < 0) {
    3622:	00004517          	auipc	a0,0x4
    3626:	e5650513          	addi	a0,a0,-426 # 7478 <malloc+0x142c>
    362a:	00002097          	auipc	ra,0x2
    362e:	640080e7          	jalr	1600(ra) # 5c6a <unlink>
    3632:	06054163          	bltz	a0,3694 <dirtest+0xba>
}
    3636:	60e2                	ld	ra,24(sp)
    3638:	6442                	ld	s0,16(sp)
    363a:	64a2                	ld	s1,8(sp)
    363c:	6105                	addi	sp,sp,32
    363e:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3640:	85a6                	mv	a1,s1
    3642:	00004517          	auipc	a0,0x4
    3646:	d9650513          	addi	a0,a0,-618 # 73d8 <malloc+0x138c>
    364a:	00003097          	auipc	ra,0x3
    364e:	94a080e7          	jalr	-1718(ra) # 5f94 <printf>
    exit(1);
    3652:	4505                	li	a0,1
    3654:	00002097          	auipc	ra,0x2
    3658:	5c6080e7          	jalr	1478(ra) # 5c1a <exit>
    printf("%s: chdir dir0 failed\n", s);
    365c:	85a6                	mv	a1,s1
    365e:	00004517          	auipc	a0,0x4
    3662:	e2250513          	addi	a0,a0,-478 # 7480 <malloc+0x1434>
    3666:	00003097          	auipc	ra,0x3
    366a:	92e080e7          	jalr	-1746(ra) # 5f94 <printf>
    exit(1);
    366e:	4505                	li	a0,1
    3670:	00002097          	auipc	ra,0x2
    3674:	5aa080e7          	jalr	1450(ra) # 5c1a <exit>
    printf("%s: chdir .. failed\n", s);
    3678:	85a6                	mv	a1,s1
    367a:	00004517          	auipc	a0,0x4
    367e:	e2650513          	addi	a0,a0,-474 # 74a0 <malloc+0x1454>
    3682:	00003097          	auipc	ra,0x3
    3686:	912080e7          	jalr	-1774(ra) # 5f94 <printf>
    exit(1);
    368a:	4505                	li	a0,1
    368c:	00002097          	auipc	ra,0x2
    3690:	58e080e7          	jalr	1422(ra) # 5c1a <exit>
    printf("%s: unlink dir0 failed\n", s);
    3694:	85a6                	mv	a1,s1
    3696:	00004517          	auipc	a0,0x4
    369a:	e2250513          	addi	a0,a0,-478 # 74b8 <malloc+0x146c>
    369e:	00003097          	auipc	ra,0x3
    36a2:	8f6080e7          	jalr	-1802(ra) # 5f94 <printf>
    exit(1);
    36a6:	4505                	li	a0,1
    36a8:	00002097          	auipc	ra,0x2
    36ac:	572080e7          	jalr	1394(ra) # 5c1a <exit>

00000000000036b0 <subdir>:
void subdir(char *s) {
    36b0:	1101                	addi	sp,sp,-32
    36b2:	ec06                	sd	ra,24(sp)
    36b4:	e822                	sd	s0,16(sp)
    36b6:	e426                	sd	s1,8(sp)
    36b8:	e04a                	sd	s2,0(sp)
    36ba:	1000                	addi	s0,sp,32
    36bc:	892a                	mv	s2,a0
  unlink("ff");
    36be:	00004517          	auipc	a0,0x4
    36c2:	f4250513          	addi	a0,a0,-190 # 7600 <malloc+0x15b4>
    36c6:	00002097          	auipc	ra,0x2
    36ca:	5a4080e7          	jalr	1444(ra) # 5c6a <unlink>
  if (mkdir("dd") != 0) {
    36ce:	00004517          	auipc	a0,0x4
    36d2:	e0250513          	addi	a0,a0,-510 # 74d0 <malloc+0x1484>
    36d6:	00002097          	auipc	ra,0x2
    36da:	5ac080e7          	jalr	1452(ra) # 5c82 <mkdir>
    36de:	38051663          	bnez	a0,3a6a <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    36e2:	20200593          	li	a1,514
    36e6:	00004517          	auipc	a0,0x4
    36ea:	e0a50513          	addi	a0,a0,-502 # 74f0 <malloc+0x14a4>
    36ee:	00002097          	auipc	ra,0x2
    36f2:	56c080e7          	jalr	1388(ra) # 5c5a <open>
    36f6:	84aa                	mv	s1,a0
  if (fd < 0) {
    36f8:	38054763          	bltz	a0,3a86 <subdir+0x3d6>
  write(fd, "ff", 2);
    36fc:	4609                	li	a2,2
    36fe:	00004597          	auipc	a1,0x4
    3702:	f0258593          	addi	a1,a1,-254 # 7600 <malloc+0x15b4>
    3706:	00002097          	auipc	ra,0x2
    370a:	534080e7          	jalr	1332(ra) # 5c3a <write>
  close(fd);
    370e:	8526                	mv	a0,s1
    3710:	00002097          	auipc	ra,0x2
    3714:	532080e7          	jalr	1330(ra) # 5c42 <close>
  if (unlink("dd") >= 0) {
    3718:	00004517          	auipc	a0,0x4
    371c:	db850513          	addi	a0,a0,-584 # 74d0 <malloc+0x1484>
    3720:	00002097          	auipc	ra,0x2
    3724:	54a080e7          	jalr	1354(ra) # 5c6a <unlink>
    3728:	36055d63          	bgez	a0,3aa2 <subdir+0x3f2>
  if (mkdir("/dd/dd") != 0) {
    372c:	00004517          	auipc	a0,0x4
    3730:	e1c50513          	addi	a0,a0,-484 # 7548 <malloc+0x14fc>
    3734:	00002097          	auipc	ra,0x2
    3738:	54e080e7          	jalr	1358(ra) # 5c82 <mkdir>
    373c:	38051163          	bnez	a0,3abe <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3740:	20200593          	li	a1,514
    3744:	00004517          	auipc	a0,0x4
    3748:	e2c50513          	addi	a0,a0,-468 # 7570 <malloc+0x1524>
    374c:	00002097          	auipc	ra,0x2
    3750:	50e080e7          	jalr	1294(ra) # 5c5a <open>
    3754:	84aa                	mv	s1,a0
  if (fd < 0) {
    3756:	38054263          	bltz	a0,3ada <subdir+0x42a>
  write(fd, "FF", 2);
    375a:	4609                	li	a2,2
    375c:	00004597          	auipc	a1,0x4
    3760:	e4458593          	addi	a1,a1,-444 # 75a0 <malloc+0x1554>
    3764:	00002097          	auipc	ra,0x2
    3768:	4d6080e7          	jalr	1238(ra) # 5c3a <write>
  close(fd);
    376c:	8526                	mv	a0,s1
    376e:	00002097          	auipc	ra,0x2
    3772:	4d4080e7          	jalr	1236(ra) # 5c42 <close>
  fd = open("dd/dd/../ff", 0);
    3776:	4581                	li	a1,0
    3778:	00004517          	auipc	a0,0x4
    377c:	e3050513          	addi	a0,a0,-464 # 75a8 <malloc+0x155c>
    3780:	00002097          	auipc	ra,0x2
    3784:	4da080e7          	jalr	1242(ra) # 5c5a <open>
    3788:	84aa                	mv	s1,a0
  if (fd < 0) {
    378a:	36054663          	bltz	a0,3af6 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    378e:	660d                	lui	a2,0x3
    3790:	00009597          	auipc	a1,0x9
    3794:	4e858593          	addi	a1,a1,1256 # cc78 <buf>
    3798:	00002097          	auipc	ra,0x2
    379c:	49a080e7          	jalr	1178(ra) # 5c32 <read>
  if (cc != 2 || buf[0] != 'f') {
    37a0:	4789                	li	a5,2
    37a2:	36f51863          	bne	a0,a5,3b12 <subdir+0x462>
    37a6:	00009717          	auipc	a4,0x9
    37aa:	4d274703          	lbu	a4,1234(a4) # cc78 <buf>
    37ae:	06600793          	li	a5,102
    37b2:	36f71063          	bne	a4,a5,3b12 <subdir+0x462>
  close(fd);
    37b6:	8526                	mv	a0,s1
    37b8:	00002097          	auipc	ra,0x2
    37bc:	48a080e7          	jalr	1162(ra) # 5c42 <close>
  if (link("dd/dd/ff", "dd/dd/ffff") != 0) {
    37c0:	00004597          	auipc	a1,0x4
    37c4:	e3858593          	addi	a1,a1,-456 # 75f8 <malloc+0x15ac>
    37c8:	00004517          	auipc	a0,0x4
    37cc:	da850513          	addi	a0,a0,-600 # 7570 <malloc+0x1524>
    37d0:	00002097          	auipc	ra,0x2
    37d4:	4aa080e7          	jalr	1194(ra) # 5c7a <link>
    37d8:	34051b63          	bnez	a0,3b2e <subdir+0x47e>
  if (unlink("dd/dd/ff") != 0) {
    37dc:	00004517          	auipc	a0,0x4
    37e0:	d9450513          	addi	a0,a0,-620 # 7570 <malloc+0x1524>
    37e4:	00002097          	auipc	ra,0x2
    37e8:	486080e7          	jalr	1158(ra) # 5c6a <unlink>
    37ec:	34051f63          	bnez	a0,3b4a <subdir+0x49a>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    37f0:	4581                	li	a1,0
    37f2:	00004517          	auipc	a0,0x4
    37f6:	d7e50513          	addi	a0,a0,-642 # 7570 <malloc+0x1524>
    37fa:	00002097          	auipc	ra,0x2
    37fe:	460080e7          	jalr	1120(ra) # 5c5a <open>
    3802:	36055263          	bgez	a0,3b66 <subdir+0x4b6>
  if (chdir("dd") != 0) {
    3806:	00004517          	auipc	a0,0x4
    380a:	cca50513          	addi	a0,a0,-822 # 74d0 <malloc+0x1484>
    380e:	00002097          	auipc	ra,0x2
    3812:	47c080e7          	jalr	1148(ra) # 5c8a <chdir>
    3816:	36051663          	bnez	a0,3b82 <subdir+0x4d2>
  if (chdir("dd/../../dd") != 0) {
    381a:	00004517          	auipc	a0,0x4
    381e:	e7650513          	addi	a0,a0,-394 # 7690 <malloc+0x1644>
    3822:	00002097          	auipc	ra,0x2
    3826:	468080e7          	jalr	1128(ra) # 5c8a <chdir>
    382a:	36051a63          	bnez	a0,3b9e <subdir+0x4ee>
  if (chdir("dd/../../../dd") != 0) {
    382e:	00004517          	auipc	a0,0x4
    3832:	e9250513          	addi	a0,a0,-366 # 76c0 <malloc+0x1674>
    3836:	00002097          	auipc	ra,0x2
    383a:	454080e7          	jalr	1108(ra) # 5c8a <chdir>
    383e:	36051e63          	bnez	a0,3bba <subdir+0x50a>
  if (chdir("./..") != 0) {
    3842:	00004517          	auipc	a0,0x4
    3846:	eae50513          	addi	a0,a0,-338 # 76f0 <malloc+0x16a4>
    384a:	00002097          	auipc	ra,0x2
    384e:	440080e7          	jalr	1088(ra) # 5c8a <chdir>
    3852:	38051263          	bnez	a0,3bd6 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    3856:	4581                	li	a1,0
    3858:	00004517          	auipc	a0,0x4
    385c:	da050513          	addi	a0,a0,-608 # 75f8 <malloc+0x15ac>
    3860:	00002097          	auipc	ra,0x2
    3864:	3fa080e7          	jalr	1018(ra) # 5c5a <open>
    3868:	84aa                	mv	s1,a0
  if (fd < 0) {
    386a:	38054463          	bltz	a0,3bf2 <subdir+0x542>
  if (read(fd, buf, sizeof(buf)) != 2) {
    386e:	660d                	lui	a2,0x3
    3870:	00009597          	auipc	a1,0x9
    3874:	40858593          	addi	a1,a1,1032 # cc78 <buf>
    3878:	00002097          	auipc	ra,0x2
    387c:	3ba080e7          	jalr	954(ra) # 5c32 <read>
    3880:	4789                	li	a5,2
    3882:	38f51663          	bne	a0,a5,3c0e <subdir+0x55e>
  close(fd);
    3886:	8526                	mv	a0,s1
    3888:	00002097          	auipc	ra,0x2
    388c:	3ba080e7          	jalr	954(ra) # 5c42 <close>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    3890:	4581                	li	a1,0
    3892:	00004517          	auipc	a0,0x4
    3896:	cde50513          	addi	a0,a0,-802 # 7570 <malloc+0x1524>
    389a:	00002097          	auipc	ra,0x2
    389e:	3c0080e7          	jalr	960(ra) # 5c5a <open>
    38a2:	38055463          	bgez	a0,3c2a <subdir+0x57a>
  if (open("dd/ff/ff", O_CREATE | O_RDWR) >= 0) {
    38a6:	20200593          	li	a1,514
    38aa:	00004517          	auipc	a0,0x4
    38ae:	ed650513          	addi	a0,a0,-298 # 7780 <malloc+0x1734>
    38b2:	00002097          	auipc	ra,0x2
    38b6:	3a8080e7          	jalr	936(ra) # 5c5a <open>
    38ba:	38055663          	bgez	a0,3c46 <subdir+0x596>
  if (open("dd/xx/ff", O_CREATE | O_RDWR) >= 0) {
    38be:	20200593          	li	a1,514
    38c2:	00004517          	auipc	a0,0x4
    38c6:	eee50513          	addi	a0,a0,-274 # 77b0 <malloc+0x1764>
    38ca:	00002097          	auipc	ra,0x2
    38ce:	390080e7          	jalr	912(ra) # 5c5a <open>
    38d2:	38055863          	bgez	a0,3c62 <subdir+0x5b2>
  if (open("dd", O_CREATE) >= 0) {
    38d6:	20000593          	li	a1,512
    38da:	00004517          	auipc	a0,0x4
    38de:	bf650513          	addi	a0,a0,-1034 # 74d0 <malloc+0x1484>
    38e2:	00002097          	auipc	ra,0x2
    38e6:	378080e7          	jalr	888(ra) # 5c5a <open>
    38ea:	38055a63          	bgez	a0,3c7e <subdir+0x5ce>
  if (open("dd", O_RDWR) >= 0) {
    38ee:	4589                	li	a1,2
    38f0:	00004517          	auipc	a0,0x4
    38f4:	be050513          	addi	a0,a0,-1056 # 74d0 <malloc+0x1484>
    38f8:	00002097          	auipc	ra,0x2
    38fc:	362080e7          	jalr	866(ra) # 5c5a <open>
    3900:	38055d63          	bgez	a0,3c9a <subdir+0x5ea>
  if (open("dd", O_WRONLY) >= 0) {
    3904:	4585                	li	a1,1
    3906:	00004517          	auipc	a0,0x4
    390a:	bca50513          	addi	a0,a0,-1078 # 74d0 <malloc+0x1484>
    390e:	00002097          	auipc	ra,0x2
    3912:	34c080e7          	jalr	844(ra) # 5c5a <open>
    3916:	3a055063          	bgez	a0,3cb6 <subdir+0x606>
  if (link("dd/ff/ff", "dd/dd/xx") == 0) {
    391a:	00004597          	auipc	a1,0x4
    391e:	f2658593          	addi	a1,a1,-218 # 7840 <malloc+0x17f4>
    3922:	00004517          	auipc	a0,0x4
    3926:	e5e50513          	addi	a0,a0,-418 # 7780 <malloc+0x1734>
    392a:	00002097          	auipc	ra,0x2
    392e:	350080e7          	jalr	848(ra) # 5c7a <link>
    3932:	3a050063          	beqz	a0,3cd2 <subdir+0x622>
  if (link("dd/xx/ff", "dd/dd/xx") == 0) {
    3936:	00004597          	auipc	a1,0x4
    393a:	f0a58593          	addi	a1,a1,-246 # 7840 <malloc+0x17f4>
    393e:	00004517          	auipc	a0,0x4
    3942:	e7250513          	addi	a0,a0,-398 # 77b0 <malloc+0x1764>
    3946:	00002097          	auipc	ra,0x2
    394a:	334080e7          	jalr	820(ra) # 5c7a <link>
    394e:	3a050063          	beqz	a0,3cee <subdir+0x63e>
  if (link("dd/ff", "dd/dd/ffff") == 0) {
    3952:	00004597          	auipc	a1,0x4
    3956:	ca658593          	addi	a1,a1,-858 # 75f8 <malloc+0x15ac>
    395a:	00004517          	auipc	a0,0x4
    395e:	b9650513          	addi	a0,a0,-1130 # 74f0 <malloc+0x14a4>
    3962:	00002097          	auipc	ra,0x2
    3966:	318080e7          	jalr	792(ra) # 5c7a <link>
    396a:	3a050063          	beqz	a0,3d0a <subdir+0x65a>
  if (mkdir("dd/ff/ff") == 0) {
    396e:	00004517          	auipc	a0,0x4
    3972:	e1250513          	addi	a0,a0,-494 # 7780 <malloc+0x1734>
    3976:	00002097          	auipc	ra,0x2
    397a:	30c080e7          	jalr	780(ra) # 5c82 <mkdir>
    397e:	3a050463          	beqz	a0,3d26 <subdir+0x676>
  if (mkdir("dd/xx/ff") == 0) {
    3982:	00004517          	auipc	a0,0x4
    3986:	e2e50513          	addi	a0,a0,-466 # 77b0 <malloc+0x1764>
    398a:	00002097          	auipc	ra,0x2
    398e:	2f8080e7          	jalr	760(ra) # 5c82 <mkdir>
    3992:	3a050863          	beqz	a0,3d42 <subdir+0x692>
  if (mkdir("dd/dd/ffff") == 0) {
    3996:	00004517          	auipc	a0,0x4
    399a:	c6250513          	addi	a0,a0,-926 # 75f8 <malloc+0x15ac>
    399e:	00002097          	auipc	ra,0x2
    39a2:	2e4080e7          	jalr	740(ra) # 5c82 <mkdir>
    39a6:	3a050c63          	beqz	a0,3d5e <subdir+0x6ae>
  if (unlink("dd/xx/ff") == 0) {
    39aa:	00004517          	auipc	a0,0x4
    39ae:	e0650513          	addi	a0,a0,-506 # 77b0 <malloc+0x1764>
    39b2:	00002097          	auipc	ra,0x2
    39b6:	2b8080e7          	jalr	696(ra) # 5c6a <unlink>
    39ba:	3c050063          	beqz	a0,3d7a <subdir+0x6ca>
  if (unlink("dd/ff/ff") == 0) {
    39be:	00004517          	auipc	a0,0x4
    39c2:	dc250513          	addi	a0,a0,-574 # 7780 <malloc+0x1734>
    39c6:	00002097          	auipc	ra,0x2
    39ca:	2a4080e7          	jalr	676(ra) # 5c6a <unlink>
    39ce:	3c050463          	beqz	a0,3d96 <subdir+0x6e6>
  if (chdir("dd/ff") == 0) {
    39d2:	00004517          	auipc	a0,0x4
    39d6:	b1e50513          	addi	a0,a0,-1250 # 74f0 <malloc+0x14a4>
    39da:	00002097          	auipc	ra,0x2
    39de:	2b0080e7          	jalr	688(ra) # 5c8a <chdir>
    39e2:	3c050863          	beqz	a0,3db2 <subdir+0x702>
  if (chdir("dd/xx") == 0) {
    39e6:	00004517          	auipc	a0,0x4
    39ea:	faa50513          	addi	a0,a0,-86 # 7990 <malloc+0x1944>
    39ee:	00002097          	auipc	ra,0x2
    39f2:	29c080e7          	jalr	668(ra) # 5c8a <chdir>
    39f6:	3c050c63          	beqz	a0,3dce <subdir+0x71e>
  if (unlink("dd/dd/ffff") != 0) {
    39fa:	00004517          	auipc	a0,0x4
    39fe:	bfe50513          	addi	a0,a0,-1026 # 75f8 <malloc+0x15ac>
    3a02:	00002097          	auipc	ra,0x2
    3a06:	268080e7          	jalr	616(ra) # 5c6a <unlink>
    3a0a:	3e051063          	bnez	a0,3dea <subdir+0x73a>
  if (unlink("dd/ff") != 0) {
    3a0e:	00004517          	auipc	a0,0x4
    3a12:	ae250513          	addi	a0,a0,-1310 # 74f0 <malloc+0x14a4>
    3a16:	00002097          	auipc	ra,0x2
    3a1a:	254080e7          	jalr	596(ra) # 5c6a <unlink>
    3a1e:	3e051463          	bnez	a0,3e06 <subdir+0x756>
  if (unlink("dd") == 0) {
    3a22:	00004517          	auipc	a0,0x4
    3a26:	aae50513          	addi	a0,a0,-1362 # 74d0 <malloc+0x1484>
    3a2a:	00002097          	auipc	ra,0x2
    3a2e:	240080e7          	jalr	576(ra) # 5c6a <unlink>
    3a32:	3e050863          	beqz	a0,3e22 <subdir+0x772>
  if (unlink("dd/dd") < 0) {
    3a36:	00004517          	auipc	a0,0x4
    3a3a:	fca50513          	addi	a0,a0,-54 # 7a00 <malloc+0x19b4>
    3a3e:	00002097          	auipc	ra,0x2
    3a42:	22c080e7          	jalr	556(ra) # 5c6a <unlink>
    3a46:	3e054c63          	bltz	a0,3e3e <subdir+0x78e>
  if (unlink("dd") < 0) {
    3a4a:	00004517          	auipc	a0,0x4
    3a4e:	a8650513          	addi	a0,a0,-1402 # 74d0 <malloc+0x1484>
    3a52:	00002097          	auipc	ra,0x2
    3a56:	218080e7          	jalr	536(ra) # 5c6a <unlink>
    3a5a:	40054063          	bltz	a0,3e5a <subdir+0x7aa>
}
    3a5e:	60e2                	ld	ra,24(sp)
    3a60:	6442                	ld	s0,16(sp)
    3a62:	64a2                	ld	s1,8(sp)
    3a64:	6902                	ld	s2,0(sp)
    3a66:	6105                	addi	sp,sp,32
    3a68:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3a6a:	85ca                	mv	a1,s2
    3a6c:	00004517          	auipc	a0,0x4
    3a70:	a6c50513          	addi	a0,a0,-1428 # 74d8 <malloc+0x148c>
    3a74:	00002097          	auipc	ra,0x2
    3a78:	520080e7          	jalr	1312(ra) # 5f94 <printf>
    exit(1);
    3a7c:	4505                	li	a0,1
    3a7e:	00002097          	auipc	ra,0x2
    3a82:	19c080e7          	jalr	412(ra) # 5c1a <exit>
    printf("%s: create dd/ff failed\n", s);
    3a86:	85ca                	mv	a1,s2
    3a88:	00004517          	auipc	a0,0x4
    3a8c:	a7050513          	addi	a0,a0,-1424 # 74f8 <malloc+0x14ac>
    3a90:	00002097          	auipc	ra,0x2
    3a94:	504080e7          	jalr	1284(ra) # 5f94 <printf>
    exit(1);
    3a98:	4505                	li	a0,1
    3a9a:	00002097          	auipc	ra,0x2
    3a9e:	180080e7          	jalr	384(ra) # 5c1a <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3aa2:	85ca                	mv	a1,s2
    3aa4:	00004517          	auipc	a0,0x4
    3aa8:	a7450513          	addi	a0,a0,-1420 # 7518 <malloc+0x14cc>
    3aac:	00002097          	auipc	ra,0x2
    3ab0:	4e8080e7          	jalr	1256(ra) # 5f94 <printf>
    exit(1);
    3ab4:	4505                	li	a0,1
    3ab6:	00002097          	auipc	ra,0x2
    3aba:	164080e7          	jalr	356(ra) # 5c1a <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3abe:	85ca                	mv	a1,s2
    3ac0:	00004517          	auipc	a0,0x4
    3ac4:	a9050513          	addi	a0,a0,-1392 # 7550 <malloc+0x1504>
    3ac8:	00002097          	auipc	ra,0x2
    3acc:	4cc080e7          	jalr	1228(ra) # 5f94 <printf>
    exit(1);
    3ad0:	4505                	li	a0,1
    3ad2:	00002097          	auipc	ra,0x2
    3ad6:	148080e7          	jalr	328(ra) # 5c1a <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3ada:	85ca                	mv	a1,s2
    3adc:	00004517          	auipc	a0,0x4
    3ae0:	aa450513          	addi	a0,a0,-1372 # 7580 <malloc+0x1534>
    3ae4:	00002097          	auipc	ra,0x2
    3ae8:	4b0080e7          	jalr	1200(ra) # 5f94 <printf>
    exit(1);
    3aec:	4505                	li	a0,1
    3aee:	00002097          	auipc	ra,0x2
    3af2:	12c080e7          	jalr	300(ra) # 5c1a <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3af6:	85ca                	mv	a1,s2
    3af8:	00004517          	auipc	a0,0x4
    3afc:	ac050513          	addi	a0,a0,-1344 # 75b8 <malloc+0x156c>
    3b00:	00002097          	auipc	ra,0x2
    3b04:	494080e7          	jalr	1172(ra) # 5f94 <printf>
    exit(1);
    3b08:	4505                	li	a0,1
    3b0a:	00002097          	auipc	ra,0x2
    3b0e:	110080e7          	jalr	272(ra) # 5c1a <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3b12:	85ca                	mv	a1,s2
    3b14:	00004517          	auipc	a0,0x4
    3b18:	ac450513          	addi	a0,a0,-1340 # 75d8 <malloc+0x158c>
    3b1c:	00002097          	auipc	ra,0x2
    3b20:	478080e7          	jalr	1144(ra) # 5f94 <printf>
    exit(1);
    3b24:	4505                	li	a0,1
    3b26:	00002097          	auipc	ra,0x2
    3b2a:	0f4080e7          	jalr	244(ra) # 5c1a <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3b2e:	85ca                	mv	a1,s2
    3b30:	00004517          	auipc	a0,0x4
    3b34:	ad850513          	addi	a0,a0,-1320 # 7608 <malloc+0x15bc>
    3b38:	00002097          	auipc	ra,0x2
    3b3c:	45c080e7          	jalr	1116(ra) # 5f94 <printf>
    exit(1);
    3b40:	4505                	li	a0,1
    3b42:	00002097          	auipc	ra,0x2
    3b46:	0d8080e7          	jalr	216(ra) # 5c1a <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3b4a:	85ca                	mv	a1,s2
    3b4c:	00004517          	auipc	a0,0x4
    3b50:	ae450513          	addi	a0,a0,-1308 # 7630 <malloc+0x15e4>
    3b54:	00002097          	auipc	ra,0x2
    3b58:	440080e7          	jalr	1088(ra) # 5f94 <printf>
    exit(1);
    3b5c:	4505                	li	a0,1
    3b5e:	00002097          	auipc	ra,0x2
    3b62:	0bc080e7          	jalr	188(ra) # 5c1a <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3b66:	85ca                	mv	a1,s2
    3b68:	00004517          	auipc	a0,0x4
    3b6c:	ae850513          	addi	a0,a0,-1304 # 7650 <malloc+0x1604>
    3b70:	00002097          	auipc	ra,0x2
    3b74:	424080e7          	jalr	1060(ra) # 5f94 <printf>
    exit(1);
    3b78:	4505                	li	a0,1
    3b7a:	00002097          	auipc	ra,0x2
    3b7e:	0a0080e7          	jalr	160(ra) # 5c1a <exit>
    printf("%s: chdir dd failed\n", s);
    3b82:	85ca                	mv	a1,s2
    3b84:	00004517          	auipc	a0,0x4
    3b88:	af450513          	addi	a0,a0,-1292 # 7678 <malloc+0x162c>
    3b8c:	00002097          	auipc	ra,0x2
    3b90:	408080e7          	jalr	1032(ra) # 5f94 <printf>
    exit(1);
    3b94:	4505                	li	a0,1
    3b96:	00002097          	auipc	ra,0x2
    3b9a:	084080e7          	jalr	132(ra) # 5c1a <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3b9e:	85ca                	mv	a1,s2
    3ba0:	00004517          	auipc	a0,0x4
    3ba4:	b0050513          	addi	a0,a0,-1280 # 76a0 <malloc+0x1654>
    3ba8:	00002097          	auipc	ra,0x2
    3bac:	3ec080e7          	jalr	1004(ra) # 5f94 <printf>
    exit(1);
    3bb0:	4505                	li	a0,1
    3bb2:	00002097          	auipc	ra,0x2
    3bb6:	068080e7          	jalr	104(ra) # 5c1a <exit>
    printf("chdir dd/../../dd failed\n", s);
    3bba:	85ca                	mv	a1,s2
    3bbc:	00004517          	auipc	a0,0x4
    3bc0:	b1450513          	addi	a0,a0,-1260 # 76d0 <malloc+0x1684>
    3bc4:	00002097          	auipc	ra,0x2
    3bc8:	3d0080e7          	jalr	976(ra) # 5f94 <printf>
    exit(1);
    3bcc:	4505                	li	a0,1
    3bce:	00002097          	auipc	ra,0x2
    3bd2:	04c080e7          	jalr	76(ra) # 5c1a <exit>
    printf("%s: chdir ./.. failed\n", s);
    3bd6:	85ca                	mv	a1,s2
    3bd8:	00004517          	auipc	a0,0x4
    3bdc:	b2050513          	addi	a0,a0,-1248 # 76f8 <malloc+0x16ac>
    3be0:	00002097          	auipc	ra,0x2
    3be4:	3b4080e7          	jalr	948(ra) # 5f94 <printf>
    exit(1);
    3be8:	4505                	li	a0,1
    3bea:	00002097          	auipc	ra,0x2
    3bee:	030080e7          	jalr	48(ra) # 5c1a <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3bf2:	85ca                	mv	a1,s2
    3bf4:	00004517          	auipc	a0,0x4
    3bf8:	b1c50513          	addi	a0,a0,-1252 # 7710 <malloc+0x16c4>
    3bfc:	00002097          	auipc	ra,0x2
    3c00:	398080e7          	jalr	920(ra) # 5f94 <printf>
    exit(1);
    3c04:	4505                	li	a0,1
    3c06:	00002097          	auipc	ra,0x2
    3c0a:	014080e7          	jalr	20(ra) # 5c1a <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3c0e:	85ca                	mv	a1,s2
    3c10:	00004517          	auipc	a0,0x4
    3c14:	b2050513          	addi	a0,a0,-1248 # 7730 <malloc+0x16e4>
    3c18:	00002097          	auipc	ra,0x2
    3c1c:	37c080e7          	jalr	892(ra) # 5f94 <printf>
    exit(1);
    3c20:	4505                	li	a0,1
    3c22:	00002097          	auipc	ra,0x2
    3c26:	ff8080e7          	jalr	-8(ra) # 5c1a <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3c2a:	85ca                	mv	a1,s2
    3c2c:	00004517          	auipc	a0,0x4
    3c30:	b2450513          	addi	a0,a0,-1244 # 7750 <malloc+0x1704>
    3c34:	00002097          	auipc	ra,0x2
    3c38:	360080e7          	jalr	864(ra) # 5f94 <printf>
    exit(1);
    3c3c:	4505                	li	a0,1
    3c3e:	00002097          	auipc	ra,0x2
    3c42:	fdc080e7          	jalr	-36(ra) # 5c1a <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3c46:	85ca                	mv	a1,s2
    3c48:	00004517          	auipc	a0,0x4
    3c4c:	b4850513          	addi	a0,a0,-1208 # 7790 <malloc+0x1744>
    3c50:	00002097          	auipc	ra,0x2
    3c54:	344080e7          	jalr	836(ra) # 5f94 <printf>
    exit(1);
    3c58:	4505                	li	a0,1
    3c5a:	00002097          	auipc	ra,0x2
    3c5e:	fc0080e7          	jalr	-64(ra) # 5c1a <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3c62:	85ca                	mv	a1,s2
    3c64:	00004517          	auipc	a0,0x4
    3c68:	b5c50513          	addi	a0,a0,-1188 # 77c0 <malloc+0x1774>
    3c6c:	00002097          	auipc	ra,0x2
    3c70:	328080e7          	jalr	808(ra) # 5f94 <printf>
    exit(1);
    3c74:	4505                	li	a0,1
    3c76:	00002097          	auipc	ra,0x2
    3c7a:	fa4080e7          	jalr	-92(ra) # 5c1a <exit>
    printf("%s: create dd succeeded!\n", s);
    3c7e:	85ca                	mv	a1,s2
    3c80:	00004517          	auipc	a0,0x4
    3c84:	b6050513          	addi	a0,a0,-1184 # 77e0 <malloc+0x1794>
    3c88:	00002097          	auipc	ra,0x2
    3c8c:	30c080e7          	jalr	780(ra) # 5f94 <printf>
    exit(1);
    3c90:	4505                	li	a0,1
    3c92:	00002097          	auipc	ra,0x2
    3c96:	f88080e7          	jalr	-120(ra) # 5c1a <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3c9a:	85ca                	mv	a1,s2
    3c9c:	00004517          	auipc	a0,0x4
    3ca0:	b6450513          	addi	a0,a0,-1180 # 7800 <malloc+0x17b4>
    3ca4:	00002097          	auipc	ra,0x2
    3ca8:	2f0080e7          	jalr	752(ra) # 5f94 <printf>
    exit(1);
    3cac:	4505                	li	a0,1
    3cae:	00002097          	auipc	ra,0x2
    3cb2:	f6c080e7          	jalr	-148(ra) # 5c1a <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3cb6:	85ca                	mv	a1,s2
    3cb8:	00004517          	auipc	a0,0x4
    3cbc:	b6850513          	addi	a0,a0,-1176 # 7820 <malloc+0x17d4>
    3cc0:	00002097          	auipc	ra,0x2
    3cc4:	2d4080e7          	jalr	724(ra) # 5f94 <printf>
    exit(1);
    3cc8:	4505                	li	a0,1
    3cca:	00002097          	auipc	ra,0x2
    3cce:	f50080e7          	jalr	-176(ra) # 5c1a <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3cd2:	85ca                	mv	a1,s2
    3cd4:	00004517          	auipc	a0,0x4
    3cd8:	b7c50513          	addi	a0,a0,-1156 # 7850 <malloc+0x1804>
    3cdc:	00002097          	auipc	ra,0x2
    3ce0:	2b8080e7          	jalr	696(ra) # 5f94 <printf>
    exit(1);
    3ce4:	4505                	li	a0,1
    3ce6:	00002097          	auipc	ra,0x2
    3cea:	f34080e7          	jalr	-204(ra) # 5c1a <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3cee:	85ca                	mv	a1,s2
    3cf0:	00004517          	auipc	a0,0x4
    3cf4:	b8850513          	addi	a0,a0,-1144 # 7878 <malloc+0x182c>
    3cf8:	00002097          	auipc	ra,0x2
    3cfc:	29c080e7          	jalr	668(ra) # 5f94 <printf>
    exit(1);
    3d00:	4505                	li	a0,1
    3d02:	00002097          	auipc	ra,0x2
    3d06:	f18080e7          	jalr	-232(ra) # 5c1a <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3d0a:	85ca                	mv	a1,s2
    3d0c:	00004517          	auipc	a0,0x4
    3d10:	b9450513          	addi	a0,a0,-1132 # 78a0 <malloc+0x1854>
    3d14:	00002097          	auipc	ra,0x2
    3d18:	280080e7          	jalr	640(ra) # 5f94 <printf>
    exit(1);
    3d1c:	4505                	li	a0,1
    3d1e:	00002097          	auipc	ra,0x2
    3d22:	efc080e7          	jalr	-260(ra) # 5c1a <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3d26:	85ca                	mv	a1,s2
    3d28:	00004517          	auipc	a0,0x4
    3d2c:	ba050513          	addi	a0,a0,-1120 # 78c8 <malloc+0x187c>
    3d30:	00002097          	auipc	ra,0x2
    3d34:	264080e7          	jalr	612(ra) # 5f94 <printf>
    exit(1);
    3d38:	4505                	li	a0,1
    3d3a:	00002097          	auipc	ra,0x2
    3d3e:	ee0080e7          	jalr	-288(ra) # 5c1a <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3d42:	85ca                	mv	a1,s2
    3d44:	00004517          	auipc	a0,0x4
    3d48:	ba450513          	addi	a0,a0,-1116 # 78e8 <malloc+0x189c>
    3d4c:	00002097          	auipc	ra,0x2
    3d50:	248080e7          	jalr	584(ra) # 5f94 <printf>
    exit(1);
    3d54:	4505                	li	a0,1
    3d56:	00002097          	auipc	ra,0x2
    3d5a:	ec4080e7          	jalr	-316(ra) # 5c1a <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3d5e:	85ca                	mv	a1,s2
    3d60:	00004517          	auipc	a0,0x4
    3d64:	ba850513          	addi	a0,a0,-1112 # 7908 <malloc+0x18bc>
    3d68:	00002097          	auipc	ra,0x2
    3d6c:	22c080e7          	jalr	556(ra) # 5f94 <printf>
    exit(1);
    3d70:	4505                	li	a0,1
    3d72:	00002097          	auipc	ra,0x2
    3d76:	ea8080e7          	jalr	-344(ra) # 5c1a <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3d7a:	85ca                	mv	a1,s2
    3d7c:	00004517          	auipc	a0,0x4
    3d80:	bb450513          	addi	a0,a0,-1100 # 7930 <malloc+0x18e4>
    3d84:	00002097          	auipc	ra,0x2
    3d88:	210080e7          	jalr	528(ra) # 5f94 <printf>
    exit(1);
    3d8c:	4505                	li	a0,1
    3d8e:	00002097          	auipc	ra,0x2
    3d92:	e8c080e7          	jalr	-372(ra) # 5c1a <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3d96:	85ca                	mv	a1,s2
    3d98:	00004517          	auipc	a0,0x4
    3d9c:	bb850513          	addi	a0,a0,-1096 # 7950 <malloc+0x1904>
    3da0:	00002097          	auipc	ra,0x2
    3da4:	1f4080e7          	jalr	500(ra) # 5f94 <printf>
    exit(1);
    3da8:	4505                	li	a0,1
    3daa:	00002097          	auipc	ra,0x2
    3dae:	e70080e7          	jalr	-400(ra) # 5c1a <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3db2:	85ca                	mv	a1,s2
    3db4:	00004517          	auipc	a0,0x4
    3db8:	bbc50513          	addi	a0,a0,-1092 # 7970 <malloc+0x1924>
    3dbc:	00002097          	auipc	ra,0x2
    3dc0:	1d8080e7          	jalr	472(ra) # 5f94 <printf>
    exit(1);
    3dc4:	4505                	li	a0,1
    3dc6:	00002097          	auipc	ra,0x2
    3dca:	e54080e7          	jalr	-428(ra) # 5c1a <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3dce:	85ca                	mv	a1,s2
    3dd0:	00004517          	auipc	a0,0x4
    3dd4:	bc850513          	addi	a0,a0,-1080 # 7998 <malloc+0x194c>
    3dd8:	00002097          	auipc	ra,0x2
    3ddc:	1bc080e7          	jalr	444(ra) # 5f94 <printf>
    exit(1);
    3de0:	4505                	li	a0,1
    3de2:	00002097          	auipc	ra,0x2
    3de6:	e38080e7          	jalr	-456(ra) # 5c1a <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3dea:	85ca                	mv	a1,s2
    3dec:	00004517          	auipc	a0,0x4
    3df0:	84450513          	addi	a0,a0,-1980 # 7630 <malloc+0x15e4>
    3df4:	00002097          	auipc	ra,0x2
    3df8:	1a0080e7          	jalr	416(ra) # 5f94 <printf>
    exit(1);
    3dfc:	4505                	li	a0,1
    3dfe:	00002097          	auipc	ra,0x2
    3e02:	e1c080e7          	jalr	-484(ra) # 5c1a <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3e06:	85ca                	mv	a1,s2
    3e08:	00004517          	auipc	a0,0x4
    3e0c:	bb050513          	addi	a0,a0,-1104 # 79b8 <malloc+0x196c>
    3e10:	00002097          	auipc	ra,0x2
    3e14:	184080e7          	jalr	388(ra) # 5f94 <printf>
    exit(1);
    3e18:	4505                	li	a0,1
    3e1a:	00002097          	auipc	ra,0x2
    3e1e:	e00080e7          	jalr	-512(ra) # 5c1a <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3e22:	85ca                	mv	a1,s2
    3e24:	00004517          	auipc	a0,0x4
    3e28:	bb450513          	addi	a0,a0,-1100 # 79d8 <malloc+0x198c>
    3e2c:	00002097          	auipc	ra,0x2
    3e30:	168080e7          	jalr	360(ra) # 5f94 <printf>
    exit(1);
    3e34:	4505                	li	a0,1
    3e36:	00002097          	auipc	ra,0x2
    3e3a:	de4080e7          	jalr	-540(ra) # 5c1a <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3e3e:	85ca                	mv	a1,s2
    3e40:	00004517          	auipc	a0,0x4
    3e44:	bc850513          	addi	a0,a0,-1080 # 7a08 <malloc+0x19bc>
    3e48:	00002097          	auipc	ra,0x2
    3e4c:	14c080e7          	jalr	332(ra) # 5f94 <printf>
    exit(1);
    3e50:	4505                	li	a0,1
    3e52:	00002097          	auipc	ra,0x2
    3e56:	dc8080e7          	jalr	-568(ra) # 5c1a <exit>
    printf("%s: unlink dd failed\n", s);
    3e5a:	85ca                	mv	a1,s2
    3e5c:	00004517          	auipc	a0,0x4
    3e60:	bcc50513          	addi	a0,a0,-1076 # 7a28 <malloc+0x19dc>
    3e64:	00002097          	auipc	ra,0x2
    3e68:	130080e7          	jalr	304(ra) # 5f94 <printf>
    exit(1);
    3e6c:	4505                	li	a0,1
    3e6e:	00002097          	auipc	ra,0x2
    3e72:	dac080e7          	jalr	-596(ra) # 5c1a <exit>

0000000000003e76 <rmdot>:
void rmdot(char *s) {
    3e76:	1101                	addi	sp,sp,-32
    3e78:	ec06                	sd	ra,24(sp)
    3e7a:	e822                	sd	s0,16(sp)
    3e7c:	e426                	sd	s1,8(sp)
    3e7e:	1000                	addi	s0,sp,32
    3e80:	84aa                	mv	s1,a0
  if (mkdir("dots") != 0) {
    3e82:	00004517          	auipc	a0,0x4
    3e86:	bbe50513          	addi	a0,a0,-1090 # 7a40 <malloc+0x19f4>
    3e8a:	00002097          	auipc	ra,0x2
    3e8e:	df8080e7          	jalr	-520(ra) # 5c82 <mkdir>
    3e92:	e549                	bnez	a0,3f1c <rmdot+0xa6>
  if (chdir("dots") != 0) {
    3e94:	00004517          	auipc	a0,0x4
    3e98:	bac50513          	addi	a0,a0,-1108 # 7a40 <malloc+0x19f4>
    3e9c:	00002097          	auipc	ra,0x2
    3ea0:	dee080e7          	jalr	-530(ra) # 5c8a <chdir>
    3ea4:	e951                	bnez	a0,3f38 <rmdot+0xc2>
  if (unlink(".") == 0) {
    3ea6:	00003517          	auipc	a0,0x3
    3eaa:	9ca50513          	addi	a0,a0,-1590 # 6870 <malloc+0x824>
    3eae:	00002097          	auipc	ra,0x2
    3eb2:	dbc080e7          	jalr	-580(ra) # 5c6a <unlink>
    3eb6:	cd59                	beqz	a0,3f54 <rmdot+0xde>
  if (unlink("..") == 0) {
    3eb8:	00003517          	auipc	a0,0x3
    3ebc:	5e050513          	addi	a0,a0,1504 # 7498 <malloc+0x144c>
    3ec0:	00002097          	auipc	ra,0x2
    3ec4:	daa080e7          	jalr	-598(ra) # 5c6a <unlink>
    3ec8:	c545                	beqz	a0,3f70 <rmdot+0xfa>
  if (chdir("/") != 0) {
    3eca:	00003517          	auipc	a0,0x3
    3ece:	57650513          	addi	a0,a0,1398 # 7440 <malloc+0x13f4>
    3ed2:	00002097          	auipc	ra,0x2
    3ed6:	db8080e7          	jalr	-584(ra) # 5c8a <chdir>
    3eda:	e94d                	bnez	a0,3f8c <rmdot+0x116>
  if (unlink("dots/.") == 0) {
    3edc:	00004517          	auipc	a0,0x4
    3ee0:	bcc50513          	addi	a0,a0,-1076 # 7aa8 <malloc+0x1a5c>
    3ee4:	00002097          	auipc	ra,0x2
    3ee8:	d86080e7          	jalr	-634(ra) # 5c6a <unlink>
    3eec:	cd55                	beqz	a0,3fa8 <rmdot+0x132>
  if (unlink("dots/..") == 0) {
    3eee:	00004517          	auipc	a0,0x4
    3ef2:	be250513          	addi	a0,a0,-1054 # 7ad0 <malloc+0x1a84>
    3ef6:	00002097          	auipc	ra,0x2
    3efa:	d74080e7          	jalr	-652(ra) # 5c6a <unlink>
    3efe:	c179                	beqz	a0,3fc4 <rmdot+0x14e>
  if (unlink("dots") != 0) {
    3f00:	00004517          	auipc	a0,0x4
    3f04:	b4050513          	addi	a0,a0,-1216 # 7a40 <malloc+0x19f4>
    3f08:	00002097          	auipc	ra,0x2
    3f0c:	d62080e7          	jalr	-670(ra) # 5c6a <unlink>
    3f10:	e961                	bnez	a0,3fe0 <rmdot+0x16a>
}
    3f12:	60e2                	ld	ra,24(sp)
    3f14:	6442                	ld	s0,16(sp)
    3f16:	64a2                	ld	s1,8(sp)
    3f18:	6105                	addi	sp,sp,32
    3f1a:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3f1c:	85a6                	mv	a1,s1
    3f1e:	00004517          	auipc	a0,0x4
    3f22:	b2a50513          	addi	a0,a0,-1238 # 7a48 <malloc+0x19fc>
    3f26:	00002097          	auipc	ra,0x2
    3f2a:	06e080e7          	jalr	110(ra) # 5f94 <printf>
    exit(1);
    3f2e:	4505                	li	a0,1
    3f30:	00002097          	auipc	ra,0x2
    3f34:	cea080e7          	jalr	-790(ra) # 5c1a <exit>
    printf("%s: chdir dots failed\n", s);
    3f38:	85a6                	mv	a1,s1
    3f3a:	00004517          	auipc	a0,0x4
    3f3e:	b2650513          	addi	a0,a0,-1242 # 7a60 <malloc+0x1a14>
    3f42:	00002097          	auipc	ra,0x2
    3f46:	052080e7          	jalr	82(ra) # 5f94 <printf>
    exit(1);
    3f4a:	4505                	li	a0,1
    3f4c:	00002097          	auipc	ra,0x2
    3f50:	cce080e7          	jalr	-818(ra) # 5c1a <exit>
    printf("%s: rm . worked!\n", s);
    3f54:	85a6                	mv	a1,s1
    3f56:	00004517          	auipc	a0,0x4
    3f5a:	b2250513          	addi	a0,a0,-1246 # 7a78 <malloc+0x1a2c>
    3f5e:	00002097          	auipc	ra,0x2
    3f62:	036080e7          	jalr	54(ra) # 5f94 <printf>
    exit(1);
    3f66:	4505                	li	a0,1
    3f68:	00002097          	auipc	ra,0x2
    3f6c:	cb2080e7          	jalr	-846(ra) # 5c1a <exit>
    printf("%s: rm .. worked!\n", s);
    3f70:	85a6                	mv	a1,s1
    3f72:	00004517          	auipc	a0,0x4
    3f76:	b1e50513          	addi	a0,a0,-1250 # 7a90 <malloc+0x1a44>
    3f7a:	00002097          	auipc	ra,0x2
    3f7e:	01a080e7          	jalr	26(ra) # 5f94 <printf>
    exit(1);
    3f82:	4505                	li	a0,1
    3f84:	00002097          	auipc	ra,0x2
    3f88:	c96080e7          	jalr	-874(ra) # 5c1a <exit>
    printf("%s: chdir / failed\n", s);
    3f8c:	85a6                	mv	a1,s1
    3f8e:	00003517          	auipc	a0,0x3
    3f92:	4ba50513          	addi	a0,a0,1210 # 7448 <malloc+0x13fc>
    3f96:	00002097          	auipc	ra,0x2
    3f9a:	ffe080e7          	jalr	-2(ra) # 5f94 <printf>
    exit(1);
    3f9e:	4505                	li	a0,1
    3fa0:	00002097          	auipc	ra,0x2
    3fa4:	c7a080e7          	jalr	-902(ra) # 5c1a <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3fa8:	85a6                	mv	a1,s1
    3faa:	00004517          	auipc	a0,0x4
    3fae:	b0650513          	addi	a0,a0,-1274 # 7ab0 <malloc+0x1a64>
    3fb2:	00002097          	auipc	ra,0x2
    3fb6:	fe2080e7          	jalr	-30(ra) # 5f94 <printf>
    exit(1);
    3fba:	4505                	li	a0,1
    3fbc:	00002097          	auipc	ra,0x2
    3fc0:	c5e080e7          	jalr	-930(ra) # 5c1a <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3fc4:	85a6                	mv	a1,s1
    3fc6:	00004517          	auipc	a0,0x4
    3fca:	b1250513          	addi	a0,a0,-1262 # 7ad8 <malloc+0x1a8c>
    3fce:	00002097          	auipc	ra,0x2
    3fd2:	fc6080e7          	jalr	-58(ra) # 5f94 <printf>
    exit(1);
    3fd6:	4505                	li	a0,1
    3fd8:	00002097          	auipc	ra,0x2
    3fdc:	c42080e7          	jalr	-958(ra) # 5c1a <exit>
    printf("%s: unlink dots failed!\n", s);
    3fe0:	85a6                	mv	a1,s1
    3fe2:	00004517          	auipc	a0,0x4
    3fe6:	b1650513          	addi	a0,a0,-1258 # 7af8 <malloc+0x1aac>
    3fea:	00002097          	auipc	ra,0x2
    3fee:	faa080e7          	jalr	-86(ra) # 5f94 <printf>
    exit(1);
    3ff2:	4505                	li	a0,1
    3ff4:	00002097          	auipc	ra,0x2
    3ff8:	c26080e7          	jalr	-986(ra) # 5c1a <exit>

0000000000003ffc <dirfile>:
void dirfile(char *s) {
    3ffc:	1101                	addi	sp,sp,-32
    3ffe:	ec06                	sd	ra,24(sp)
    4000:	e822                	sd	s0,16(sp)
    4002:	e426                	sd	s1,8(sp)
    4004:	e04a                	sd	s2,0(sp)
    4006:	1000                	addi	s0,sp,32
    4008:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    400a:	20000593          	li	a1,512
    400e:	00004517          	auipc	a0,0x4
    4012:	b0a50513          	addi	a0,a0,-1270 # 7b18 <malloc+0x1acc>
    4016:	00002097          	auipc	ra,0x2
    401a:	c44080e7          	jalr	-956(ra) # 5c5a <open>
  if (fd < 0) {
    401e:	0e054d63          	bltz	a0,4118 <dirfile+0x11c>
  close(fd);
    4022:	00002097          	auipc	ra,0x2
    4026:	c20080e7          	jalr	-992(ra) # 5c42 <close>
  if (chdir("dirfile") == 0) {
    402a:	00004517          	auipc	a0,0x4
    402e:	aee50513          	addi	a0,a0,-1298 # 7b18 <malloc+0x1acc>
    4032:	00002097          	auipc	ra,0x2
    4036:	c58080e7          	jalr	-936(ra) # 5c8a <chdir>
    403a:	cd6d                	beqz	a0,4134 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    403c:	4581                	li	a1,0
    403e:	00004517          	auipc	a0,0x4
    4042:	b2250513          	addi	a0,a0,-1246 # 7b60 <malloc+0x1b14>
    4046:	00002097          	auipc	ra,0x2
    404a:	c14080e7          	jalr	-1004(ra) # 5c5a <open>
  if (fd >= 0) {
    404e:	10055163          	bgez	a0,4150 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    4052:	20000593          	li	a1,512
    4056:	00004517          	auipc	a0,0x4
    405a:	b0a50513          	addi	a0,a0,-1270 # 7b60 <malloc+0x1b14>
    405e:	00002097          	auipc	ra,0x2
    4062:	bfc080e7          	jalr	-1028(ra) # 5c5a <open>
  if (fd >= 0) {
    4066:	10055363          	bgez	a0,416c <dirfile+0x170>
  if (mkdir("dirfile/xx") == 0) {
    406a:	00004517          	auipc	a0,0x4
    406e:	af650513          	addi	a0,a0,-1290 # 7b60 <malloc+0x1b14>
    4072:	00002097          	auipc	ra,0x2
    4076:	c10080e7          	jalr	-1008(ra) # 5c82 <mkdir>
    407a:	10050763          	beqz	a0,4188 <dirfile+0x18c>
  if (unlink("dirfile/xx") == 0) {
    407e:	00004517          	auipc	a0,0x4
    4082:	ae250513          	addi	a0,a0,-1310 # 7b60 <malloc+0x1b14>
    4086:	00002097          	auipc	ra,0x2
    408a:	be4080e7          	jalr	-1052(ra) # 5c6a <unlink>
    408e:	10050b63          	beqz	a0,41a4 <dirfile+0x1a8>
  if (link("xv6-readme", "dirfile/xx") == 0) {
    4092:	00004597          	auipc	a1,0x4
    4096:	ace58593          	addi	a1,a1,-1330 # 7b60 <malloc+0x1b14>
    409a:	00002517          	auipc	a0,0x2
    409e:	2b650513          	addi	a0,a0,694 # 6350 <malloc+0x304>
    40a2:	00002097          	auipc	ra,0x2
    40a6:	bd8080e7          	jalr	-1064(ra) # 5c7a <link>
    40aa:	10050b63          	beqz	a0,41c0 <dirfile+0x1c4>
  if (unlink("dirfile") != 0) {
    40ae:	00004517          	auipc	a0,0x4
    40b2:	a6a50513          	addi	a0,a0,-1430 # 7b18 <malloc+0x1acc>
    40b6:	00002097          	auipc	ra,0x2
    40ba:	bb4080e7          	jalr	-1100(ra) # 5c6a <unlink>
    40be:	10051f63          	bnez	a0,41dc <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    40c2:	4589                	li	a1,2
    40c4:	00002517          	auipc	a0,0x2
    40c8:	7ac50513          	addi	a0,a0,1964 # 6870 <malloc+0x824>
    40cc:	00002097          	auipc	ra,0x2
    40d0:	b8e080e7          	jalr	-1138(ra) # 5c5a <open>
  if (fd >= 0) {
    40d4:	12055263          	bgez	a0,41f8 <dirfile+0x1fc>
  fd = open(".", 0);
    40d8:	4581                	li	a1,0
    40da:	00002517          	auipc	a0,0x2
    40de:	79650513          	addi	a0,a0,1942 # 6870 <malloc+0x824>
    40e2:	00002097          	auipc	ra,0x2
    40e6:	b78080e7          	jalr	-1160(ra) # 5c5a <open>
    40ea:	84aa                	mv	s1,a0
  if (write(fd, "x", 1) > 0) {
    40ec:	4605                	li	a2,1
    40ee:	00002597          	auipc	a1,0x2
    40f2:	0fa58593          	addi	a1,a1,250 # 61e8 <malloc+0x19c>
    40f6:	00002097          	auipc	ra,0x2
    40fa:	b44080e7          	jalr	-1212(ra) # 5c3a <write>
    40fe:	10a04b63          	bgtz	a0,4214 <dirfile+0x218>
  close(fd);
    4102:	8526                	mv	a0,s1
    4104:	00002097          	auipc	ra,0x2
    4108:	b3e080e7          	jalr	-1218(ra) # 5c42 <close>
}
    410c:	60e2                	ld	ra,24(sp)
    410e:	6442                	ld	s0,16(sp)
    4110:	64a2                	ld	s1,8(sp)
    4112:	6902                	ld	s2,0(sp)
    4114:	6105                	addi	sp,sp,32
    4116:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    4118:	85ca                	mv	a1,s2
    411a:	00004517          	auipc	a0,0x4
    411e:	a0650513          	addi	a0,a0,-1530 # 7b20 <malloc+0x1ad4>
    4122:	00002097          	auipc	ra,0x2
    4126:	e72080e7          	jalr	-398(ra) # 5f94 <printf>
    exit(1);
    412a:	4505                	li	a0,1
    412c:	00002097          	auipc	ra,0x2
    4130:	aee080e7          	jalr	-1298(ra) # 5c1a <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    4134:	85ca                	mv	a1,s2
    4136:	00004517          	auipc	a0,0x4
    413a:	a0a50513          	addi	a0,a0,-1526 # 7b40 <malloc+0x1af4>
    413e:	00002097          	auipc	ra,0x2
    4142:	e56080e7          	jalr	-426(ra) # 5f94 <printf>
    exit(1);
    4146:	4505                	li	a0,1
    4148:	00002097          	auipc	ra,0x2
    414c:	ad2080e7          	jalr	-1326(ra) # 5c1a <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4150:	85ca                	mv	a1,s2
    4152:	00004517          	auipc	a0,0x4
    4156:	a1e50513          	addi	a0,a0,-1506 # 7b70 <malloc+0x1b24>
    415a:	00002097          	auipc	ra,0x2
    415e:	e3a080e7          	jalr	-454(ra) # 5f94 <printf>
    exit(1);
    4162:	4505                	li	a0,1
    4164:	00002097          	auipc	ra,0x2
    4168:	ab6080e7          	jalr	-1354(ra) # 5c1a <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    416c:	85ca                	mv	a1,s2
    416e:	00004517          	auipc	a0,0x4
    4172:	a0250513          	addi	a0,a0,-1534 # 7b70 <malloc+0x1b24>
    4176:	00002097          	auipc	ra,0x2
    417a:	e1e080e7          	jalr	-482(ra) # 5f94 <printf>
    exit(1);
    417e:	4505                	li	a0,1
    4180:	00002097          	auipc	ra,0x2
    4184:	a9a080e7          	jalr	-1382(ra) # 5c1a <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4188:	85ca                	mv	a1,s2
    418a:	00004517          	auipc	a0,0x4
    418e:	a0e50513          	addi	a0,a0,-1522 # 7b98 <malloc+0x1b4c>
    4192:	00002097          	auipc	ra,0x2
    4196:	e02080e7          	jalr	-510(ra) # 5f94 <printf>
    exit(1);
    419a:	4505                	li	a0,1
    419c:	00002097          	auipc	ra,0x2
    41a0:	a7e080e7          	jalr	-1410(ra) # 5c1a <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    41a4:	85ca                	mv	a1,s2
    41a6:	00004517          	auipc	a0,0x4
    41aa:	a1a50513          	addi	a0,a0,-1510 # 7bc0 <malloc+0x1b74>
    41ae:	00002097          	auipc	ra,0x2
    41b2:	de6080e7          	jalr	-538(ra) # 5f94 <printf>
    exit(1);
    41b6:	4505                	li	a0,1
    41b8:	00002097          	auipc	ra,0x2
    41bc:	a62080e7          	jalr	-1438(ra) # 5c1a <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    41c0:	85ca                	mv	a1,s2
    41c2:	00004517          	auipc	a0,0x4
    41c6:	a2650513          	addi	a0,a0,-1498 # 7be8 <malloc+0x1b9c>
    41ca:	00002097          	auipc	ra,0x2
    41ce:	dca080e7          	jalr	-566(ra) # 5f94 <printf>
    exit(1);
    41d2:	4505                	li	a0,1
    41d4:	00002097          	auipc	ra,0x2
    41d8:	a46080e7          	jalr	-1466(ra) # 5c1a <exit>
    printf("%s: unlink dirfile failed!\n", s);
    41dc:	85ca                	mv	a1,s2
    41de:	00004517          	auipc	a0,0x4
    41e2:	a3250513          	addi	a0,a0,-1486 # 7c10 <malloc+0x1bc4>
    41e6:	00002097          	auipc	ra,0x2
    41ea:	dae080e7          	jalr	-594(ra) # 5f94 <printf>
    exit(1);
    41ee:	4505                	li	a0,1
    41f0:	00002097          	auipc	ra,0x2
    41f4:	a2a080e7          	jalr	-1494(ra) # 5c1a <exit>
    printf("%s: open . for writing succeeded!\n", s);
    41f8:	85ca                	mv	a1,s2
    41fa:	00004517          	auipc	a0,0x4
    41fe:	a3650513          	addi	a0,a0,-1482 # 7c30 <malloc+0x1be4>
    4202:	00002097          	auipc	ra,0x2
    4206:	d92080e7          	jalr	-622(ra) # 5f94 <printf>
    exit(1);
    420a:	4505                	li	a0,1
    420c:	00002097          	auipc	ra,0x2
    4210:	a0e080e7          	jalr	-1522(ra) # 5c1a <exit>
    printf("%s: write . succeeded!\n", s);
    4214:	85ca                	mv	a1,s2
    4216:	00004517          	auipc	a0,0x4
    421a:	a4250513          	addi	a0,a0,-1470 # 7c58 <malloc+0x1c0c>
    421e:	00002097          	auipc	ra,0x2
    4222:	d76080e7          	jalr	-650(ra) # 5f94 <printf>
    exit(1);
    4226:	4505                	li	a0,1
    4228:	00002097          	auipc	ra,0x2
    422c:	9f2080e7          	jalr	-1550(ra) # 5c1a <exit>

0000000000004230 <iref>:
void iref(char *s) {
    4230:	7139                	addi	sp,sp,-64
    4232:	fc06                	sd	ra,56(sp)
    4234:	f822                	sd	s0,48(sp)
    4236:	f426                	sd	s1,40(sp)
    4238:	f04a                	sd	s2,32(sp)
    423a:	ec4e                	sd	s3,24(sp)
    423c:	e852                	sd	s4,16(sp)
    423e:	e456                	sd	s5,8(sp)
    4240:	e05a                	sd	s6,0(sp)
    4242:	0080                	addi	s0,sp,64
    4244:	8b2a                	mv	s6,a0
    4246:	03300913          	li	s2,51
    if (mkdir("irefd") != 0) {
    424a:	00004a17          	auipc	s4,0x4
    424e:	a26a0a13          	addi	s4,s4,-1498 # 7c70 <malloc+0x1c24>
    mkdir("");
    4252:	00003497          	auipc	s1,0x3
    4256:	52648493          	addi	s1,s1,1318 # 7778 <malloc+0x172c>
    link("xv6-readme", "");
    425a:	00002a97          	auipc	s5,0x2
    425e:	0f6a8a93          	addi	s5,s5,246 # 6350 <malloc+0x304>
    fd = open("xx", O_CREATE);
    4262:	00004997          	auipc	s3,0x4
    4266:	90698993          	addi	s3,s3,-1786 # 7b68 <malloc+0x1b1c>
    426a:	a891                	j	42be <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    426c:	85da                	mv	a1,s6
    426e:	00004517          	auipc	a0,0x4
    4272:	a0a50513          	addi	a0,a0,-1526 # 7c78 <malloc+0x1c2c>
    4276:	00002097          	auipc	ra,0x2
    427a:	d1e080e7          	jalr	-738(ra) # 5f94 <printf>
      exit(1);
    427e:	4505                	li	a0,1
    4280:	00002097          	auipc	ra,0x2
    4284:	99a080e7          	jalr	-1638(ra) # 5c1a <exit>
      printf("%s: chdir irefd failed\n", s);
    4288:	85da                	mv	a1,s6
    428a:	00004517          	auipc	a0,0x4
    428e:	a0650513          	addi	a0,a0,-1530 # 7c90 <malloc+0x1c44>
    4292:	00002097          	auipc	ra,0x2
    4296:	d02080e7          	jalr	-766(ra) # 5f94 <printf>
      exit(1);
    429a:	4505                	li	a0,1
    429c:	00002097          	auipc	ra,0x2
    42a0:	97e080e7          	jalr	-1666(ra) # 5c1a <exit>
    if (fd >= 0) close(fd);
    42a4:	00002097          	auipc	ra,0x2
    42a8:	99e080e7          	jalr	-1634(ra) # 5c42 <close>
    42ac:	a889                	j	42fe <iref+0xce>
    unlink("xx");
    42ae:	854e                	mv	a0,s3
    42b0:	00002097          	auipc	ra,0x2
    42b4:	9ba080e7          	jalr	-1606(ra) # 5c6a <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    42b8:	397d                	addiw	s2,s2,-1
    42ba:	06090063          	beqz	s2,431a <iref+0xea>
    if (mkdir("irefd") != 0) {
    42be:	8552                	mv	a0,s4
    42c0:	00002097          	auipc	ra,0x2
    42c4:	9c2080e7          	jalr	-1598(ra) # 5c82 <mkdir>
    42c8:	f155                	bnez	a0,426c <iref+0x3c>
    if (chdir("irefd") != 0) {
    42ca:	8552                	mv	a0,s4
    42cc:	00002097          	auipc	ra,0x2
    42d0:	9be080e7          	jalr	-1602(ra) # 5c8a <chdir>
    42d4:	f955                	bnez	a0,4288 <iref+0x58>
    mkdir("");
    42d6:	8526                	mv	a0,s1
    42d8:	00002097          	auipc	ra,0x2
    42dc:	9aa080e7          	jalr	-1622(ra) # 5c82 <mkdir>
    link("xv6-readme", "");
    42e0:	85a6                	mv	a1,s1
    42e2:	8556                	mv	a0,s5
    42e4:	00002097          	auipc	ra,0x2
    42e8:	996080e7          	jalr	-1642(ra) # 5c7a <link>
    fd = open("", O_CREATE);
    42ec:	20000593          	li	a1,512
    42f0:	8526                	mv	a0,s1
    42f2:	00002097          	auipc	ra,0x2
    42f6:	968080e7          	jalr	-1688(ra) # 5c5a <open>
    if (fd >= 0) close(fd);
    42fa:	fa0555e3          	bgez	a0,42a4 <iref+0x74>
    fd = open("xx", O_CREATE);
    42fe:	20000593          	li	a1,512
    4302:	854e                	mv	a0,s3
    4304:	00002097          	auipc	ra,0x2
    4308:	956080e7          	jalr	-1706(ra) # 5c5a <open>
    if (fd >= 0) close(fd);
    430c:	fa0541e3          	bltz	a0,42ae <iref+0x7e>
    4310:	00002097          	auipc	ra,0x2
    4314:	932080e7          	jalr	-1742(ra) # 5c42 <close>
    4318:	bf59                	j	42ae <iref+0x7e>
    431a:	03300493          	li	s1,51
    chdir("..");
    431e:	00003997          	auipc	s3,0x3
    4322:	17a98993          	addi	s3,s3,378 # 7498 <malloc+0x144c>
    unlink("irefd");
    4326:	00004917          	auipc	s2,0x4
    432a:	94a90913          	addi	s2,s2,-1718 # 7c70 <malloc+0x1c24>
    chdir("..");
    432e:	854e                	mv	a0,s3
    4330:	00002097          	auipc	ra,0x2
    4334:	95a080e7          	jalr	-1702(ra) # 5c8a <chdir>
    unlink("irefd");
    4338:	854a                	mv	a0,s2
    433a:	00002097          	auipc	ra,0x2
    433e:	930080e7          	jalr	-1744(ra) # 5c6a <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    4342:	34fd                	addiw	s1,s1,-1
    4344:	f4ed                	bnez	s1,432e <iref+0xfe>
  chdir("/");
    4346:	00003517          	auipc	a0,0x3
    434a:	0fa50513          	addi	a0,a0,250 # 7440 <malloc+0x13f4>
    434e:	00002097          	auipc	ra,0x2
    4352:	93c080e7          	jalr	-1732(ra) # 5c8a <chdir>
}
    4356:	70e2                	ld	ra,56(sp)
    4358:	7442                	ld	s0,48(sp)
    435a:	74a2                	ld	s1,40(sp)
    435c:	7902                	ld	s2,32(sp)
    435e:	69e2                	ld	s3,24(sp)
    4360:	6a42                	ld	s4,16(sp)
    4362:	6aa2                	ld	s5,8(sp)
    4364:	6b02                	ld	s6,0(sp)
    4366:	6121                	addi	sp,sp,64
    4368:	8082                	ret

000000000000436a <openiputtest>:
void openiputtest(char *s) {
    436a:	7179                	addi	sp,sp,-48
    436c:	f406                	sd	ra,40(sp)
    436e:	f022                	sd	s0,32(sp)
    4370:	ec26                	sd	s1,24(sp)
    4372:	1800                	addi	s0,sp,48
    4374:	84aa                	mv	s1,a0
  if (mkdir("oidir") < 0) {
    4376:	00004517          	auipc	a0,0x4
    437a:	93250513          	addi	a0,a0,-1742 # 7ca8 <malloc+0x1c5c>
    437e:	00002097          	auipc	ra,0x2
    4382:	904080e7          	jalr	-1788(ra) # 5c82 <mkdir>
    4386:	04054263          	bltz	a0,43ca <openiputtest+0x60>
  pid = fork();
    438a:	00002097          	auipc	ra,0x2
    438e:	888080e7          	jalr	-1912(ra) # 5c12 <fork>
  if (pid < 0) {
    4392:	04054a63          	bltz	a0,43e6 <openiputtest+0x7c>
  if (pid == 0) {
    4396:	e93d                	bnez	a0,440c <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    4398:	4589                	li	a1,2
    439a:	00004517          	auipc	a0,0x4
    439e:	90e50513          	addi	a0,a0,-1778 # 7ca8 <malloc+0x1c5c>
    43a2:	00002097          	auipc	ra,0x2
    43a6:	8b8080e7          	jalr	-1864(ra) # 5c5a <open>
    if (fd >= 0) {
    43aa:	04054c63          	bltz	a0,4402 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    43ae:	85a6                	mv	a1,s1
    43b0:	00004517          	auipc	a0,0x4
    43b4:	91850513          	addi	a0,a0,-1768 # 7cc8 <malloc+0x1c7c>
    43b8:	00002097          	auipc	ra,0x2
    43bc:	bdc080e7          	jalr	-1060(ra) # 5f94 <printf>
      exit(1);
    43c0:	4505                	li	a0,1
    43c2:	00002097          	auipc	ra,0x2
    43c6:	858080e7          	jalr	-1960(ra) # 5c1a <exit>
    printf("%s: mkdir oidir failed\n", s);
    43ca:	85a6                	mv	a1,s1
    43cc:	00004517          	auipc	a0,0x4
    43d0:	8e450513          	addi	a0,a0,-1820 # 7cb0 <malloc+0x1c64>
    43d4:	00002097          	auipc	ra,0x2
    43d8:	bc0080e7          	jalr	-1088(ra) # 5f94 <printf>
    exit(1);
    43dc:	4505                	li	a0,1
    43de:	00002097          	auipc	ra,0x2
    43e2:	83c080e7          	jalr	-1988(ra) # 5c1a <exit>
    printf("%s: fork failed\n", s);
    43e6:	85a6                	mv	a1,s1
    43e8:	00002517          	auipc	a0,0x2
    43ec:	62850513          	addi	a0,a0,1576 # 6a10 <malloc+0x9c4>
    43f0:	00002097          	auipc	ra,0x2
    43f4:	ba4080e7          	jalr	-1116(ra) # 5f94 <printf>
    exit(1);
    43f8:	4505                	li	a0,1
    43fa:	00002097          	auipc	ra,0x2
    43fe:	820080e7          	jalr	-2016(ra) # 5c1a <exit>
    exit(0);
    4402:	4501                	li	a0,0
    4404:	00002097          	auipc	ra,0x2
    4408:	816080e7          	jalr	-2026(ra) # 5c1a <exit>
  sleep(1);
    440c:	4505                	li	a0,1
    440e:	00002097          	auipc	ra,0x2
    4412:	89c080e7          	jalr	-1892(ra) # 5caa <sleep>
  if (unlink("oidir") != 0) {
    4416:	00004517          	auipc	a0,0x4
    441a:	89250513          	addi	a0,a0,-1902 # 7ca8 <malloc+0x1c5c>
    441e:	00002097          	auipc	ra,0x2
    4422:	84c080e7          	jalr	-1972(ra) # 5c6a <unlink>
    4426:	cd19                	beqz	a0,4444 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    4428:	85a6                	mv	a1,s1
    442a:	00002517          	auipc	a0,0x2
    442e:	7d650513          	addi	a0,a0,2006 # 6c00 <malloc+0xbb4>
    4432:	00002097          	auipc	ra,0x2
    4436:	b62080e7          	jalr	-1182(ra) # 5f94 <printf>
    exit(1);
    443a:	4505                	li	a0,1
    443c:	00001097          	auipc	ra,0x1
    4440:	7de080e7          	jalr	2014(ra) # 5c1a <exit>
  wait(&xstatus);
    4444:	fdc40513          	addi	a0,s0,-36
    4448:	00001097          	auipc	ra,0x1
    444c:	7da080e7          	jalr	2010(ra) # 5c22 <wait>
  exit(xstatus);
    4450:	fdc42503          	lw	a0,-36(s0)
    4454:	00001097          	auipc	ra,0x1
    4458:	7c6080e7          	jalr	1990(ra) # 5c1a <exit>

000000000000445c <forkforkfork>:
void forkforkfork(char *s) {
    445c:	1101                	addi	sp,sp,-32
    445e:	ec06                	sd	ra,24(sp)
    4460:	e822                	sd	s0,16(sp)
    4462:	e426                	sd	s1,8(sp)
    4464:	1000                	addi	s0,sp,32
    4466:	84aa                	mv	s1,a0
  unlink("stopforking");
    4468:	00004517          	auipc	a0,0x4
    446c:	88850513          	addi	a0,a0,-1912 # 7cf0 <malloc+0x1ca4>
    4470:	00001097          	auipc	ra,0x1
    4474:	7fa080e7          	jalr	2042(ra) # 5c6a <unlink>
  int pid = fork();
    4478:	00001097          	auipc	ra,0x1
    447c:	79a080e7          	jalr	1946(ra) # 5c12 <fork>
  if (pid < 0) {
    4480:	04054563          	bltz	a0,44ca <forkforkfork+0x6e>
  if (pid == 0) {
    4484:	c12d                	beqz	a0,44e6 <forkforkfork+0x8a>
  sleep(20);  // two seconds
    4486:	4551                	li	a0,20
    4488:	00002097          	auipc	ra,0x2
    448c:	822080e7          	jalr	-2014(ra) # 5caa <sleep>
  close(open("stopforking", O_CREATE | O_RDWR));
    4490:	20200593          	li	a1,514
    4494:	00004517          	auipc	a0,0x4
    4498:	85c50513          	addi	a0,a0,-1956 # 7cf0 <malloc+0x1ca4>
    449c:	00001097          	auipc	ra,0x1
    44a0:	7be080e7          	jalr	1982(ra) # 5c5a <open>
    44a4:	00001097          	auipc	ra,0x1
    44a8:	79e080e7          	jalr	1950(ra) # 5c42 <close>
  wait(0);
    44ac:	4501                	li	a0,0
    44ae:	00001097          	auipc	ra,0x1
    44b2:	774080e7          	jalr	1908(ra) # 5c22 <wait>
  sleep(10);  // one second
    44b6:	4529                	li	a0,10
    44b8:	00001097          	auipc	ra,0x1
    44bc:	7f2080e7          	jalr	2034(ra) # 5caa <sleep>
}
    44c0:	60e2                	ld	ra,24(sp)
    44c2:	6442                	ld	s0,16(sp)
    44c4:	64a2                	ld	s1,8(sp)
    44c6:	6105                	addi	sp,sp,32
    44c8:	8082                	ret
    printf("%s: fork failed", s);
    44ca:	85a6                	mv	a1,s1
    44cc:	00002517          	auipc	a0,0x2
    44d0:	70450513          	addi	a0,a0,1796 # 6bd0 <malloc+0xb84>
    44d4:	00002097          	auipc	ra,0x2
    44d8:	ac0080e7          	jalr	-1344(ra) # 5f94 <printf>
    exit(1);
    44dc:	4505                	li	a0,1
    44de:	00001097          	auipc	ra,0x1
    44e2:	73c080e7          	jalr	1852(ra) # 5c1a <exit>
      int fd = open("stopforking", 0);
    44e6:	00004497          	auipc	s1,0x4
    44ea:	80a48493          	addi	s1,s1,-2038 # 7cf0 <malloc+0x1ca4>
    44ee:	4581                	li	a1,0
    44f0:	8526                	mv	a0,s1
    44f2:	00001097          	auipc	ra,0x1
    44f6:	768080e7          	jalr	1896(ra) # 5c5a <open>
      if (fd >= 0) {
    44fa:	02055463          	bgez	a0,4522 <forkforkfork+0xc6>
      if (fork() < 0) {
    44fe:	00001097          	auipc	ra,0x1
    4502:	714080e7          	jalr	1812(ra) # 5c12 <fork>
    4506:	fe0554e3          	bgez	a0,44ee <forkforkfork+0x92>
        close(open("stopforking", O_CREATE | O_RDWR));
    450a:	20200593          	li	a1,514
    450e:	8526                	mv	a0,s1
    4510:	00001097          	auipc	ra,0x1
    4514:	74a080e7          	jalr	1866(ra) # 5c5a <open>
    4518:	00001097          	auipc	ra,0x1
    451c:	72a080e7          	jalr	1834(ra) # 5c42 <close>
    4520:	b7f9                	j	44ee <forkforkfork+0x92>
        exit(0);
    4522:	4501                	li	a0,0
    4524:	00001097          	auipc	ra,0x1
    4528:	6f6080e7          	jalr	1782(ra) # 5c1a <exit>

000000000000452c <killstatus>:
void killstatus(char *s) {
    452c:	7139                	addi	sp,sp,-64
    452e:	fc06                	sd	ra,56(sp)
    4530:	f822                	sd	s0,48(sp)
    4532:	f426                	sd	s1,40(sp)
    4534:	f04a                	sd	s2,32(sp)
    4536:	ec4e                	sd	s3,24(sp)
    4538:	e852                	sd	s4,16(sp)
    453a:	0080                	addi	s0,sp,64
    453c:	8a2a                	mv	s4,a0
    453e:	06400913          	li	s2,100
    if (xst != -1) {
    4542:	59fd                	li	s3,-1
    int pid1 = fork();
    4544:	00001097          	auipc	ra,0x1
    4548:	6ce080e7          	jalr	1742(ra) # 5c12 <fork>
    454c:	84aa                	mv	s1,a0
    if (pid1 < 0) {
    454e:	02054f63          	bltz	a0,458c <killstatus+0x60>
    if (pid1 == 0) {
    4552:	c939                	beqz	a0,45a8 <killstatus+0x7c>
    sleep(1);
    4554:	4505                	li	a0,1
    4556:	00001097          	auipc	ra,0x1
    455a:	754080e7          	jalr	1876(ra) # 5caa <sleep>
    kill(pid1);
    455e:	8526                	mv	a0,s1
    4560:	00001097          	auipc	ra,0x1
    4564:	6ea080e7          	jalr	1770(ra) # 5c4a <kill>
    wait(&xst);
    4568:	fcc40513          	addi	a0,s0,-52
    456c:	00001097          	auipc	ra,0x1
    4570:	6b6080e7          	jalr	1718(ra) # 5c22 <wait>
    if (xst != -1) {
    4574:	fcc42783          	lw	a5,-52(s0)
    4578:	03379d63          	bne	a5,s3,45b2 <killstatus+0x86>
  for (int i = 0; i < 100; i++) {
    457c:	397d                	addiw	s2,s2,-1
    457e:	fc0913e3          	bnez	s2,4544 <killstatus+0x18>
  exit(0);
    4582:	4501                	li	a0,0
    4584:	00001097          	auipc	ra,0x1
    4588:	696080e7          	jalr	1686(ra) # 5c1a <exit>
      printf("%s: fork failed\n", s);
    458c:	85d2                	mv	a1,s4
    458e:	00002517          	auipc	a0,0x2
    4592:	48250513          	addi	a0,a0,1154 # 6a10 <malloc+0x9c4>
    4596:	00002097          	auipc	ra,0x2
    459a:	9fe080e7          	jalr	-1538(ra) # 5f94 <printf>
      exit(1);
    459e:	4505                	li	a0,1
    45a0:	00001097          	auipc	ra,0x1
    45a4:	67a080e7          	jalr	1658(ra) # 5c1a <exit>
        getpid();
    45a8:	00001097          	auipc	ra,0x1
    45ac:	6f2080e7          	jalr	1778(ra) # 5c9a <getpid>
      while (1) {
    45b0:	bfe5                	j	45a8 <killstatus+0x7c>
      printf("%s: status should be -1\n", s);
    45b2:	85d2                	mv	a1,s4
    45b4:	00003517          	auipc	a0,0x3
    45b8:	74c50513          	addi	a0,a0,1868 # 7d00 <malloc+0x1cb4>
    45bc:	00002097          	auipc	ra,0x2
    45c0:	9d8080e7          	jalr	-1576(ra) # 5f94 <printf>
      exit(1);
    45c4:	4505                	li	a0,1
    45c6:	00001097          	auipc	ra,0x1
    45ca:	654080e7          	jalr	1620(ra) # 5c1a <exit>

00000000000045ce <preempt>:
void preempt(char *s) {
    45ce:	7139                	addi	sp,sp,-64
    45d0:	fc06                	sd	ra,56(sp)
    45d2:	f822                	sd	s0,48(sp)
    45d4:	f426                	sd	s1,40(sp)
    45d6:	f04a                	sd	s2,32(sp)
    45d8:	ec4e                	sd	s3,24(sp)
    45da:	e852                	sd	s4,16(sp)
    45dc:	0080                	addi	s0,sp,64
    45de:	892a                	mv	s2,a0
  pid1 = fork();
    45e0:	00001097          	auipc	ra,0x1
    45e4:	632080e7          	jalr	1586(ra) # 5c12 <fork>
  if (pid1 < 0) {
    45e8:	00054563          	bltz	a0,45f2 <preempt+0x24>
    45ec:	84aa                	mv	s1,a0
  if (pid1 == 0)
    45ee:	e105                	bnez	a0,460e <preempt+0x40>
    for (;;);
    45f0:	a001                	j	45f0 <preempt+0x22>
    printf("%s: fork failed", s);
    45f2:	85ca                	mv	a1,s2
    45f4:	00002517          	auipc	a0,0x2
    45f8:	5dc50513          	addi	a0,a0,1500 # 6bd0 <malloc+0xb84>
    45fc:	00002097          	auipc	ra,0x2
    4600:	998080e7          	jalr	-1640(ra) # 5f94 <printf>
    exit(1);
    4604:	4505                	li	a0,1
    4606:	00001097          	auipc	ra,0x1
    460a:	614080e7          	jalr	1556(ra) # 5c1a <exit>
  pid2 = fork();
    460e:	00001097          	auipc	ra,0x1
    4612:	604080e7          	jalr	1540(ra) # 5c12 <fork>
    4616:	89aa                	mv	s3,a0
  if (pid2 < 0) {
    4618:	00054463          	bltz	a0,4620 <preempt+0x52>
  if (pid2 == 0)
    461c:	e105                	bnez	a0,463c <preempt+0x6e>
    for (;;);
    461e:	a001                	j	461e <preempt+0x50>
    printf("%s: fork failed\n", s);
    4620:	85ca                	mv	a1,s2
    4622:	00002517          	auipc	a0,0x2
    4626:	3ee50513          	addi	a0,a0,1006 # 6a10 <malloc+0x9c4>
    462a:	00002097          	auipc	ra,0x2
    462e:	96a080e7          	jalr	-1686(ra) # 5f94 <printf>
    exit(1);
    4632:	4505                	li	a0,1
    4634:	00001097          	auipc	ra,0x1
    4638:	5e6080e7          	jalr	1510(ra) # 5c1a <exit>
  pipe(pfds);
    463c:	fc840513          	addi	a0,s0,-56
    4640:	00001097          	auipc	ra,0x1
    4644:	5ea080e7          	jalr	1514(ra) # 5c2a <pipe>
  pid3 = fork();
    4648:	00001097          	auipc	ra,0x1
    464c:	5ca080e7          	jalr	1482(ra) # 5c12 <fork>
    4650:	8a2a                	mv	s4,a0
  if (pid3 < 0) {
    4652:	02054e63          	bltz	a0,468e <preempt+0xc0>
  if (pid3 == 0) {
    4656:	e525                	bnez	a0,46be <preempt+0xf0>
    close(pfds[0]);
    4658:	fc842503          	lw	a0,-56(s0)
    465c:	00001097          	auipc	ra,0x1
    4660:	5e6080e7          	jalr	1510(ra) # 5c42 <close>
    if (write(pfds[1], "x", 1) != 1) printf("%s: preempt write error", s);
    4664:	4605                	li	a2,1
    4666:	00002597          	auipc	a1,0x2
    466a:	b8258593          	addi	a1,a1,-1150 # 61e8 <malloc+0x19c>
    466e:	fcc42503          	lw	a0,-52(s0)
    4672:	00001097          	auipc	ra,0x1
    4676:	5c8080e7          	jalr	1480(ra) # 5c3a <write>
    467a:	4785                	li	a5,1
    467c:	02f51763          	bne	a0,a5,46aa <preempt+0xdc>
    close(pfds[1]);
    4680:	fcc42503          	lw	a0,-52(s0)
    4684:	00001097          	auipc	ra,0x1
    4688:	5be080e7          	jalr	1470(ra) # 5c42 <close>
    for (;;);
    468c:	a001                	j	468c <preempt+0xbe>
    printf("%s: fork failed\n", s);
    468e:	85ca                	mv	a1,s2
    4690:	00002517          	auipc	a0,0x2
    4694:	38050513          	addi	a0,a0,896 # 6a10 <malloc+0x9c4>
    4698:	00002097          	auipc	ra,0x2
    469c:	8fc080e7          	jalr	-1796(ra) # 5f94 <printf>
    exit(1);
    46a0:	4505                	li	a0,1
    46a2:	00001097          	auipc	ra,0x1
    46a6:	578080e7          	jalr	1400(ra) # 5c1a <exit>
    if (write(pfds[1], "x", 1) != 1) printf("%s: preempt write error", s);
    46aa:	85ca                	mv	a1,s2
    46ac:	00003517          	auipc	a0,0x3
    46b0:	67450513          	addi	a0,a0,1652 # 7d20 <malloc+0x1cd4>
    46b4:	00002097          	auipc	ra,0x2
    46b8:	8e0080e7          	jalr	-1824(ra) # 5f94 <printf>
    46bc:	b7d1                	j	4680 <preempt+0xb2>
  close(pfds[1]);
    46be:	fcc42503          	lw	a0,-52(s0)
    46c2:	00001097          	auipc	ra,0x1
    46c6:	580080e7          	jalr	1408(ra) # 5c42 <close>
  if (read(pfds[0], buf, sizeof(buf)) != 1) {
    46ca:	660d                	lui	a2,0x3
    46cc:	00008597          	auipc	a1,0x8
    46d0:	5ac58593          	addi	a1,a1,1452 # cc78 <buf>
    46d4:	fc842503          	lw	a0,-56(s0)
    46d8:	00001097          	auipc	ra,0x1
    46dc:	55a080e7          	jalr	1370(ra) # 5c32 <read>
    46e0:	4785                	li	a5,1
    46e2:	02f50363          	beq	a0,a5,4708 <preempt+0x13a>
    printf("%s: preempt read error", s);
    46e6:	85ca                	mv	a1,s2
    46e8:	00003517          	auipc	a0,0x3
    46ec:	65050513          	addi	a0,a0,1616 # 7d38 <malloc+0x1cec>
    46f0:	00002097          	auipc	ra,0x2
    46f4:	8a4080e7          	jalr	-1884(ra) # 5f94 <printf>
}
    46f8:	70e2                	ld	ra,56(sp)
    46fa:	7442                	ld	s0,48(sp)
    46fc:	74a2                	ld	s1,40(sp)
    46fe:	7902                	ld	s2,32(sp)
    4700:	69e2                	ld	s3,24(sp)
    4702:	6a42                	ld	s4,16(sp)
    4704:	6121                	addi	sp,sp,64
    4706:	8082                	ret
  close(pfds[0]);
    4708:	fc842503          	lw	a0,-56(s0)
    470c:	00001097          	auipc	ra,0x1
    4710:	536080e7          	jalr	1334(ra) # 5c42 <close>
  printf("kill... ");
    4714:	00003517          	auipc	a0,0x3
    4718:	63c50513          	addi	a0,a0,1596 # 7d50 <malloc+0x1d04>
    471c:	00002097          	auipc	ra,0x2
    4720:	878080e7          	jalr	-1928(ra) # 5f94 <printf>
  kill(pid1);
    4724:	8526                	mv	a0,s1
    4726:	00001097          	auipc	ra,0x1
    472a:	524080e7          	jalr	1316(ra) # 5c4a <kill>
  kill(pid2);
    472e:	854e                	mv	a0,s3
    4730:	00001097          	auipc	ra,0x1
    4734:	51a080e7          	jalr	1306(ra) # 5c4a <kill>
  kill(pid3);
    4738:	8552                	mv	a0,s4
    473a:	00001097          	auipc	ra,0x1
    473e:	510080e7          	jalr	1296(ra) # 5c4a <kill>
  printf("wait... ");
    4742:	00003517          	auipc	a0,0x3
    4746:	61e50513          	addi	a0,a0,1566 # 7d60 <malloc+0x1d14>
    474a:	00002097          	auipc	ra,0x2
    474e:	84a080e7          	jalr	-1974(ra) # 5f94 <printf>
  wait(0);
    4752:	4501                	li	a0,0
    4754:	00001097          	auipc	ra,0x1
    4758:	4ce080e7          	jalr	1230(ra) # 5c22 <wait>
  wait(0);
    475c:	4501                	li	a0,0
    475e:	00001097          	auipc	ra,0x1
    4762:	4c4080e7          	jalr	1220(ra) # 5c22 <wait>
  wait(0);
    4766:	4501                	li	a0,0
    4768:	00001097          	auipc	ra,0x1
    476c:	4ba080e7          	jalr	1210(ra) # 5c22 <wait>
    4770:	b761                	j	46f8 <preempt+0x12a>

0000000000004772 <reparent>:
void reparent(char *s) {
    4772:	7179                	addi	sp,sp,-48
    4774:	f406                	sd	ra,40(sp)
    4776:	f022                	sd	s0,32(sp)
    4778:	ec26                	sd	s1,24(sp)
    477a:	e84a                	sd	s2,16(sp)
    477c:	e44e                	sd	s3,8(sp)
    477e:	e052                	sd	s4,0(sp)
    4780:	1800                	addi	s0,sp,48
    4782:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4784:	00001097          	auipc	ra,0x1
    4788:	516080e7          	jalr	1302(ra) # 5c9a <getpid>
    478c:	8a2a                	mv	s4,a0
    478e:	0c800913          	li	s2,200
    int pid = fork();
    4792:	00001097          	auipc	ra,0x1
    4796:	480080e7          	jalr	1152(ra) # 5c12 <fork>
    479a:	84aa                	mv	s1,a0
    if (pid < 0) {
    479c:	02054263          	bltz	a0,47c0 <reparent+0x4e>
    if (pid) {
    47a0:	cd21                	beqz	a0,47f8 <reparent+0x86>
      if (wait(0) != pid) {
    47a2:	4501                	li	a0,0
    47a4:	00001097          	auipc	ra,0x1
    47a8:	47e080e7          	jalr	1150(ra) # 5c22 <wait>
    47ac:	02951863          	bne	a0,s1,47dc <reparent+0x6a>
  for (int i = 0; i < 200; i++) {
    47b0:	397d                	addiw	s2,s2,-1
    47b2:	fe0910e3          	bnez	s2,4792 <reparent+0x20>
  exit(0);
    47b6:	4501                	li	a0,0
    47b8:	00001097          	auipc	ra,0x1
    47bc:	462080e7          	jalr	1122(ra) # 5c1a <exit>
      printf("%s: fork failed\n", s);
    47c0:	85ce                	mv	a1,s3
    47c2:	00002517          	auipc	a0,0x2
    47c6:	24e50513          	addi	a0,a0,590 # 6a10 <malloc+0x9c4>
    47ca:	00001097          	auipc	ra,0x1
    47ce:	7ca080e7          	jalr	1994(ra) # 5f94 <printf>
      exit(1);
    47d2:	4505                	li	a0,1
    47d4:	00001097          	auipc	ra,0x1
    47d8:	446080e7          	jalr	1094(ra) # 5c1a <exit>
        printf("%s: wait wrong pid\n", s);
    47dc:	85ce                	mv	a1,s3
    47de:	00002517          	auipc	a0,0x2
    47e2:	3ba50513          	addi	a0,a0,954 # 6b98 <malloc+0xb4c>
    47e6:	00001097          	auipc	ra,0x1
    47ea:	7ae080e7          	jalr	1966(ra) # 5f94 <printf>
        exit(1);
    47ee:	4505                	li	a0,1
    47f0:	00001097          	auipc	ra,0x1
    47f4:	42a080e7          	jalr	1066(ra) # 5c1a <exit>
      int pid2 = fork();
    47f8:	00001097          	auipc	ra,0x1
    47fc:	41a080e7          	jalr	1050(ra) # 5c12 <fork>
      if (pid2 < 0) {
    4800:	00054763          	bltz	a0,480e <reparent+0x9c>
      exit(0);
    4804:	4501                	li	a0,0
    4806:	00001097          	auipc	ra,0x1
    480a:	414080e7          	jalr	1044(ra) # 5c1a <exit>
        kill(master_pid);
    480e:	8552                	mv	a0,s4
    4810:	00001097          	auipc	ra,0x1
    4814:	43a080e7          	jalr	1082(ra) # 5c4a <kill>
        exit(1);
    4818:	4505                	li	a0,1
    481a:	00001097          	auipc	ra,0x1
    481e:	400080e7          	jalr	1024(ra) # 5c1a <exit>

0000000000004822 <sbrkfail>:
void sbrkfail(char *s) {
    4822:	7119                	addi	sp,sp,-128
    4824:	fc86                	sd	ra,120(sp)
    4826:	f8a2                	sd	s0,112(sp)
    4828:	f4a6                	sd	s1,104(sp)
    482a:	f0ca                	sd	s2,96(sp)
    482c:	ecce                	sd	s3,88(sp)
    482e:	e8d2                	sd	s4,80(sp)
    4830:	e4d6                	sd	s5,72(sp)
    4832:	0100                	addi	s0,sp,128
    4834:	8aaa                	mv	s5,a0
  if (pipe(fds) != 0) {
    4836:	fb040513          	addi	a0,s0,-80
    483a:	00001097          	auipc	ra,0x1
    483e:	3f0080e7          	jalr	1008(ra) # 5c2a <pipe>
    4842:	e901                	bnez	a0,4852 <sbrkfail+0x30>
    4844:	f8040493          	addi	s1,s0,-128
    4848:	fa840993          	addi	s3,s0,-88
    484c:	8926                	mv	s2,s1
    if (pids[i] != -1) read(fds[0], &scratch, 1);
    484e:	5a7d                	li	s4,-1
    4850:	a085                	j	48b0 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    4852:	85d6                	mv	a1,s5
    4854:	00002517          	auipc	a0,0x2
    4858:	2c450513          	addi	a0,a0,708 # 6b18 <malloc+0xacc>
    485c:	00001097          	auipc	ra,0x1
    4860:	738080e7          	jalr	1848(ra) # 5f94 <printf>
    exit(1);
    4864:	4505                	li	a0,1
    4866:	00001097          	auipc	ra,0x1
    486a:	3b4080e7          	jalr	948(ra) # 5c1a <exit>
      sbrk(BIG - (uint64)sbrk(0));
    486e:	00001097          	auipc	ra,0x1
    4872:	434080e7          	jalr	1076(ra) # 5ca2 <sbrk>
    4876:	064007b7          	lui	a5,0x6400
    487a:	40a7853b          	subw	a0,a5,a0
    487e:	00001097          	auipc	ra,0x1
    4882:	424080e7          	jalr	1060(ra) # 5ca2 <sbrk>
      write(fds[1], "x", 1);
    4886:	4605                	li	a2,1
    4888:	00002597          	auipc	a1,0x2
    488c:	96058593          	addi	a1,a1,-1696 # 61e8 <malloc+0x19c>
    4890:	fb442503          	lw	a0,-76(s0)
    4894:	00001097          	auipc	ra,0x1
    4898:	3a6080e7          	jalr	934(ra) # 5c3a <write>
      for (;;) sleep(1000);
    489c:	3e800513          	li	a0,1000
    48a0:	00001097          	auipc	ra,0x1
    48a4:	40a080e7          	jalr	1034(ra) # 5caa <sleep>
    48a8:	bfd5                	j	489c <sbrkfail+0x7a>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    48aa:	0911                	addi	s2,s2,4
    48ac:	03390563          	beq	s2,s3,48d6 <sbrkfail+0xb4>
    if ((pids[i] = fork()) == 0) {
    48b0:	00001097          	auipc	ra,0x1
    48b4:	362080e7          	jalr	866(ra) # 5c12 <fork>
    48b8:	00a92023          	sw	a0,0(s2)
    48bc:	d94d                	beqz	a0,486e <sbrkfail+0x4c>
    if (pids[i] != -1) read(fds[0], &scratch, 1);
    48be:	ff4506e3          	beq	a0,s4,48aa <sbrkfail+0x88>
    48c2:	4605                	li	a2,1
    48c4:	faf40593          	addi	a1,s0,-81
    48c8:	fb042503          	lw	a0,-80(s0)
    48cc:	00001097          	auipc	ra,0x1
    48d0:	366080e7          	jalr	870(ra) # 5c32 <read>
    48d4:	bfd9                	j	48aa <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    48d6:	6505                	lui	a0,0x1
    48d8:	00001097          	auipc	ra,0x1
    48dc:	3ca080e7          	jalr	970(ra) # 5ca2 <sbrk>
    48e0:	8a2a                	mv	s4,a0
    if (pids[i] == -1) continue;
    48e2:	597d                	li	s2,-1
    48e4:	a021                	j	48ec <sbrkfail+0xca>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    48e6:	0491                	addi	s1,s1,4
    48e8:	01348f63          	beq	s1,s3,4906 <sbrkfail+0xe4>
    if (pids[i] == -1) continue;
    48ec:	4088                	lw	a0,0(s1)
    48ee:	ff250ce3          	beq	a0,s2,48e6 <sbrkfail+0xc4>
    kill(pids[i]);
    48f2:	00001097          	auipc	ra,0x1
    48f6:	358080e7          	jalr	856(ra) # 5c4a <kill>
    wait(0);
    48fa:	4501                	li	a0,0
    48fc:	00001097          	auipc	ra,0x1
    4900:	326080e7          	jalr	806(ra) # 5c22 <wait>
    4904:	b7cd                	j	48e6 <sbrkfail+0xc4>
  if (c == (char *)0xffffffffffffffffL) {
    4906:	57fd                	li	a5,-1
    4908:	04fa0163          	beq	s4,a5,494a <sbrkfail+0x128>
  pid = fork();
    490c:	00001097          	auipc	ra,0x1
    4910:	306080e7          	jalr	774(ra) # 5c12 <fork>
    4914:	84aa                	mv	s1,a0
  if (pid < 0) {
    4916:	04054863          	bltz	a0,4966 <sbrkfail+0x144>
  if (pid == 0) {
    491a:	c525                	beqz	a0,4982 <sbrkfail+0x160>
  wait(&xstatus);
    491c:	fbc40513          	addi	a0,s0,-68
    4920:	00001097          	auipc	ra,0x1
    4924:	302080e7          	jalr	770(ra) # 5c22 <wait>
  if (xstatus != -1 && xstatus != 2) exit(1);
    4928:	fbc42783          	lw	a5,-68(s0)
    492c:	577d                	li	a4,-1
    492e:	00e78563          	beq	a5,a4,4938 <sbrkfail+0x116>
    4932:	4709                	li	a4,2
    4934:	08e79d63          	bne	a5,a4,49ce <sbrkfail+0x1ac>
}
    4938:	70e6                	ld	ra,120(sp)
    493a:	7446                	ld	s0,112(sp)
    493c:	74a6                	ld	s1,104(sp)
    493e:	7906                	ld	s2,96(sp)
    4940:	69e6                	ld	s3,88(sp)
    4942:	6a46                	ld	s4,80(sp)
    4944:	6aa6                	ld	s5,72(sp)
    4946:	6109                	addi	sp,sp,128
    4948:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    494a:	85d6                	mv	a1,s5
    494c:	00003517          	auipc	a0,0x3
    4950:	42450513          	addi	a0,a0,1060 # 7d70 <malloc+0x1d24>
    4954:	00001097          	auipc	ra,0x1
    4958:	640080e7          	jalr	1600(ra) # 5f94 <printf>
    exit(1);
    495c:	4505                	li	a0,1
    495e:	00001097          	auipc	ra,0x1
    4962:	2bc080e7          	jalr	700(ra) # 5c1a <exit>
    printf("%s: fork failed\n", s);
    4966:	85d6                	mv	a1,s5
    4968:	00002517          	auipc	a0,0x2
    496c:	0a850513          	addi	a0,a0,168 # 6a10 <malloc+0x9c4>
    4970:	00001097          	auipc	ra,0x1
    4974:	624080e7          	jalr	1572(ra) # 5f94 <printf>
    exit(1);
    4978:	4505                	li	a0,1
    497a:	00001097          	auipc	ra,0x1
    497e:	2a0080e7          	jalr	672(ra) # 5c1a <exit>
    a = sbrk(0);
    4982:	4501                	li	a0,0
    4984:	00001097          	auipc	ra,0x1
    4988:	31e080e7          	jalr	798(ra) # 5ca2 <sbrk>
    498c:	892a                	mv	s2,a0
    sbrk(10 * BIG);
    498e:	3e800537          	lui	a0,0x3e800
    4992:	00001097          	auipc	ra,0x1
    4996:	310080e7          	jalr	784(ra) # 5ca2 <sbrk>
    for (i = 0; i < 10 * BIG; i += PGSIZE) {
    499a:	87ca                	mv	a5,s2
    499c:	3e800737          	lui	a4,0x3e800
    49a0:	993a                	add	s2,s2,a4
    49a2:	6705                	lui	a4,0x1
      n += *(a + i);
    49a4:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f0388>
    49a8:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10 * BIG; i += PGSIZE) {
    49aa:	97ba                	add	a5,a5,a4
    49ac:	ff279ce3          	bne	a5,s2,49a4 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    49b0:	8626                	mv	a2,s1
    49b2:	85d6                	mv	a1,s5
    49b4:	00003517          	auipc	a0,0x3
    49b8:	3dc50513          	addi	a0,a0,988 # 7d90 <malloc+0x1d44>
    49bc:	00001097          	auipc	ra,0x1
    49c0:	5d8080e7          	jalr	1496(ra) # 5f94 <printf>
    exit(1);
    49c4:	4505                	li	a0,1
    49c6:	00001097          	auipc	ra,0x1
    49ca:	254080e7          	jalr	596(ra) # 5c1a <exit>
  if (xstatus != -1 && xstatus != 2) exit(1);
    49ce:	4505                	li	a0,1
    49d0:	00001097          	auipc	ra,0x1
    49d4:	24a080e7          	jalr	586(ra) # 5c1a <exit>

00000000000049d8 <mem>:
void mem(char *s) {
    49d8:	7139                	addi	sp,sp,-64
    49da:	fc06                	sd	ra,56(sp)
    49dc:	f822                	sd	s0,48(sp)
    49de:	f426                	sd	s1,40(sp)
    49e0:	f04a                	sd	s2,32(sp)
    49e2:	ec4e                	sd	s3,24(sp)
    49e4:	0080                	addi	s0,sp,64
    49e6:	89aa                	mv	s3,a0
  if ((pid = fork()) == 0) {
    49e8:	00001097          	auipc	ra,0x1
    49ec:	22a080e7          	jalr	554(ra) # 5c12 <fork>
    m1 = 0;
    49f0:	4481                	li	s1,0
    while ((m2 = malloc(10001)) != 0) {
    49f2:	6909                	lui	s2,0x2
    49f4:	71190913          	addi	s2,s2,1809 # 2711 <copyinstr3+0xff>
  if ((pid = fork()) == 0) {
    49f8:	c115                	beqz	a0,4a1c <mem+0x44>
    wait(&xstatus);
    49fa:	fcc40513          	addi	a0,s0,-52
    49fe:	00001097          	auipc	ra,0x1
    4a02:	224080e7          	jalr	548(ra) # 5c22 <wait>
    if (xstatus == -1) {
    4a06:	fcc42503          	lw	a0,-52(s0)
    4a0a:	57fd                	li	a5,-1
    4a0c:	06f50363          	beq	a0,a5,4a72 <mem+0x9a>
    exit(xstatus);
    4a10:	00001097          	auipc	ra,0x1
    4a14:	20a080e7          	jalr	522(ra) # 5c1a <exit>
      *(char **)m2 = m1;
    4a18:	e104                	sd	s1,0(a0)
      m1 = m2;
    4a1a:	84aa                	mv	s1,a0
    while ((m2 = malloc(10001)) != 0) {
    4a1c:	854a                	mv	a0,s2
    4a1e:	00001097          	auipc	ra,0x1
    4a22:	62e080e7          	jalr	1582(ra) # 604c <malloc>
    4a26:	f96d                	bnez	a0,4a18 <mem+0x40>
    while (m1) {
    4a28:	c881                	beqz	s1,4a38 <mem+0x60>
      m2 = *(char **)m1;
    4a2a:	8526                	mv	a0,s1
    4a2c:	6084                	ld	s1,0(s1)
      free(m1);
    4a2e:	00001097          	auipc	ra,0x1
    4a32:	59c080e7          	jalr	1436(ra) # 5fca <free>
    while (m1) {
    4a36:	f8f5                	bnez	s1,4a2a <mem+0x52>
    m1 = malloc(1024 * 20);
    4a38:	6515                	lui	a0,0x5
    4a3a:	00001097          	auipc	ra,0x1
    4a3e:	612080e7          	jalr	1554(ra) # 604c <malloc>
    if (m1 == 0) {
    4a42:	c911                	beqz	a0,4a56 <mem+0x7e>
    free(m1);
    4a44:	00001097          	auipc	ra,0x1
    4a48:	586080e7          	jalr	1414(ra) # 5fca <free>
    exit(0);
    4a4c:	4501                	li	a0,0
    4a4e:	00001097          	auipc	ra,0x1
    4a52:	1cc080e7          	jalr	460(ra) # 5c1a <exit>
      printf("couldn't allocate mem?!!\n", s);
    4a56:	85ce                	mv	a1,s3
    4a58:	00003517          	auipc	a0,0x3
    4a5c:	36850513          	addi	a0,a0,872 # 7dc0 <malloc+0x1d74>
    4a60:	00001097          	auipc	ra,0x1
    4a64:	534080e7          	jalr	1332(ra) # 5f94 <printf>
      exit(1);
    4a68:	4505                	li	a0,1
    4a6a:	00001097          	auipc	ra,0x1
    4a6e:	1b0080e7          	jalr	432(ra) # 5c1a <exit>
      exit(0);
    4a72:	4501                	li	a0,0
    4a74:	00001097          	auipc	ra,0x1
    4a78:	1a6080e7          	jalr	422(ra) # 5c1a <exit>

0000000000004a7c <sharedfd>:
void sharedfd(char *s) {
    4a7c:	7159                	addi	sp,sp,-112
    4a7e:	f486                	sd	ra,104(sp)
    4a80:	f0a2                	sd	s0,96(sp)
    4a82:	eca6                	sd	s1,88(sp)
    4a84:	e8ca                	sd	s2,80(sp)
    4a86:	e4ce                	sd	s3,72(sp)
    4a88:	e0d2                	sd	s4,64(sp)
    4a8a:	fc56                	sd	s5,56(sp)
    4a8c:	f85a                	sd	s6,48(sp)
    4a8e:	f45e                	sd	s7,40(sp)
    4a90:	1880                	addi	s0,sp,112
    4a92:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4a94:	00003517          	auipc	a0,0x3
    4a98:	34c50513          	addi	a0,a0,844 # 7de0 <malloc+0x1d94>
    4a9c:	00001097          	auipc	ra,0x1
    4aa0:	1ce080e7          	jalr	462(ra) # 5c6a <unlink>
  fd = open("sharedfd", O_CREATE | O_RDWR);
    4aa4:	20200593          	li	a1,514
    4aa8:	00003517          	auipc	a0,0x3
    4aac:	33850513          	addi	a0,a0,824 # 7de0 <malloc+0x1d94>
    4ab0:	00001097          	auipc	ra,0x1
    4ab4:	1aa080e7          	jalr	426(ra) # 5c5a <open>
  if (fd < 0) {
    4ab8:	04054a63          	bltz	a0,4b0c <sharedfd+0x90>
    4abc:	892a                	mv	s2,a0
  pid = fork();
    4abe:	00001097          	auipc	ra,0x1
    4ac2:	154080e7          	jalr	340(ra) # 5c12 <fork>
    4ac6:	89aa                	mv	s3,a0
  memset(buf, pid == 0 ? 'c' : 'p', sizeof(buf));
    4ac8:	06300593          	li	a1,99
    4acc:	c119                	beqz	a0,4ad2 <sharedfd+0x56>
    4ace:	07000593          	li	a1,112
    4ad2:	4629                	li	a2,10
    4ad4:	fa040513          	addi	a0,s0,-96
    4ad8:	00001097          	auipc	ra,0x1
    4adc:	f48080e7          	jalr	-184(ra) # 5a20 <memset>
    4ae0:	3e800493          	li	s1,1000
    if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
    4ae4:	4629                	li	a2,10
    4ae6:	fa040593          	addi	a1,s0,-96
    4aea:	854a                	mv	a0,s2
    4aec:	00001097          	auipc	ra,0x1
    4af0:	14e080e7          	jalr	334(ra) # 5c3a <write>
    4af4:	47a9                	li	a5,10
    4af6:	02f51963          	bne	a0,a5,4b28 <sharedfd+0xac>
  for (i = 0; i < N; i++) {
    4afa:	34fd                	addiw	s1,s1,-1
    4afc:	f4e5                	bnez	s1,4ae4 <sharedfd+0x68>
  if (pid == 0) {
    4afe:	04099363          	bnez	s3,4b44 <sharedfd+0xc8>
    exit(0);
    4b02:	4501                	li	a0,0
    4b04:	00001097          	auipc	ra,0x1
    4b08:	116080e7          	jalr	278(ra) # 5c1a <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4b0c:	85d2                	mv	a1,s4
    4b0e:	00003517          	auipc	a0,0x3
    4b12:	2e250513          	addi	a0,a0,738 # 7df0 <malloc+0x1da4>
    4b16:	00001097          	auipc	ra,0x1
    4b1a:	47e080e7          	jalr	1150(ra) # 5f94 <printf>
    exit(1);
    4b1e:	4505                	li	a0,1
    4b20:	00001097          	auipc	ra,0x1
    4b24:	0fa080e7          	jalr	250(ra) # 5c1a <exit>
      printf("%s: write sharedfd failed\n", s);
    4b28:	85d2                	mv	a1,s4
    4b2a:	00003517          	auipc	a0,0x3
    4b2e:	2ee50513          	addi	a0,a0,750 # 7e18 <malloc+0x1dcc>
    4b32:	00001097          	auipc	ra,0x1
    4b36:	462080e7          	jalr	1122(ra) # 5f94 <printf>
      exit(1);
    4b3a:	4505                	li	a0,1
    4b3c:	00001097          	auipc	ra,0x1
    4b40:	0de080e7          	jalr	222(ra) # 5c1a <exit>
    wait(&xstatus);
    4b44:	f9c40513          	addi	a0,s0,-100
    4b48:	00001097          	auipc	ra,0x1
    4b4c:	0da080e7          	jalr	218(ra) # 5c22 <wait>
    if (xstatus != 0) exit(xstatus);
    4b50:	f9c42983          	lw	s3,-100(s0)
    4b54:	00098763          	beqz	s3,4b62 <sharedfd+0xe6>
    4b58:	854e                	mv	a0,s3
    4b5a:	00001097          	auipc	ra,0x1
    4b5e:	0c0080e7          	jalr	192(ra) # 5c1a <exit>
  close(fd);
    4b62:	854a                	mv	a0,s2
    4b64:	00001097          	auipc	ra,0x1
    4b68:	0de080e7          	jalr	222(ra) # 5c42 <close>
  fd = open("sharedfd", 0);
    4b6c:	4581                	li	a1,0
    4b6e:	00003517          	auipc	a0,0x3
    4b72:	27250513          	addi	a0,a0,626 # 7de0 <malloc+0x1d94>
    4b76:	00001097          	auipc	ra,0x1
    4b7a:	0e4080e7          	jalr	228(ra) # 5c5a <open>
    4b7e:	8baa                	mv	s7,a0
  nc = np = 0;
    4b80:	8ace                	mv	s5,s3
  if (fd < 0) {
    4b82:	02054563          	bltz	a0,4bac <sharedfd+0x130>
    4b86:	faa40913          	addi	s2,s0,-86
      if (buf[i] == 'c') nc++;
    4b8a:	06300493          	li	s1,99
      if (buf[i] == 'p') np++;
    4b8e:	07000b13          	li	s6,112
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
    4b92:	4629                	li	a2,10
    4b94:	fa040593          	addi	a1,s0,-96
    4b98:	855e                	mv	a0,s7
    4b9a:	00001097          	auipc	ra,0x1
    4b9e:	098080e7          	jalr	152(ra) # 5c32 <read>
    4ba2:	02a05f63          	blez	a0,4be0 <sharedfd+0x164>
    4ba6:	fa040793          	addi	a5,s0,-96
    4baa:	a01d                	j	4bd0 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4bac:	85d2                	mv	a1,s4
    4bae:	00003517          	auipc	a0,0x3
    4bb2:	28a50513          	addi	a0,a0,650 # 7e38 <malloc+0x1dec>
    4bb6:	00001097          	auipc	ra,0x1
    4bba:	3de080e7          	jalr	990(ra) # 5f94 <printf>
    exit(1);
    4bbe:	4505                	li	a0,1
    4bc0:	00001097          	auipc	ra,0x1
    4bc4:	05a080e7          	jalr	90(ra) # 5c1a <exit>
      if (buf[i] == 'c') nc++;
    4bc8:	2985                	addiw	s3,s3,1
    for (i = 0; i < sizeof(buf); i++) {
    4bca:	0785                	addi	a5,a5,1
    4bcc:	fd2783e3          	beq	a5,s2,4b92 <sharedfd+0x116>
      if (buf[i] == 'c') nc++;
    4bd0:	0007c703          	lbu	a4,0(a5)
    4bd4:	fe970ae3          	beq	a4,s1,4bc8 <sharedfd+0x14c>
      if (buf[i] == 'p') np++;
    4bd8:	ff6719e3          	bne	a4,s6,4bca <sharedfd+0x14e>
    4bdc:	2a85                	addiw	s5,s5,1
    4bde:	b7f5                	j	4bca <sharedfd+0x14e>
  close(fd);
    4be0:	855e                	mv	a0,s7
    4be2:	00001097          	auipc	ra,0x1
    4be6:	060080e7          	jalr	96(ra) # 5c42 <close>
  unlink("sharedfd");
    4bea:	00003517          	auipc	a0,0x3
    4bee:	1f650513          	addi	a0,a0,502 # 7de0 <malloc+0x1d94>
    4bf2:	00001097          	auipc	ra,0x1
    4bf6:	078080e7          	jalr	120(ra) # 5c6a <unlink>
  if (nc == N * SZ && np == N * SZ) {
    4bfa:	6789                	lui	a5,0x2
    4bfc:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0xfe>
    4c00:	00f99763          	bne	s3,a5,4c0e <sharedfd+0x192>
    4c04:	6789                	lui	a5,0x2
    4c06:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0xfe>
    4c0a:	02fa8063          	beq	s5,a5,4c2a <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4c0e:	85d2                	mv	a1,s4
    4c10:	00003517          	auipc	a0,0x3
    4c14:	25050513          	addi	a0,a0,592 # 7e60 <malloc+0x1e14>
    4c18:	00001097          	auipc	ra,0x1
    4c1c:	37c080e7          	jalr	892(ra) # 5f94 <printf>
    exit(1);
    4c20:	4505                	li	a0,1
    4c22:	00001097          	auipc	ra,0x1
    4c26:	ff8080e7          	jalr	-8(ra) # 5c1a <exit>
    exit(0);
    4c2a:	4501                	li	a0,0
    4c2c:	00001097          	auipc	ra,0x1
    4c30:	fee080e7          	jalr	-18(ra) # 5c1a <exit>

0000000000004c34 <fourfiles>:
void fourfiles(char *s) {
    4c34:	7171                	addi	sp,sp,-176
    4c36:	f506                	sd	ra,168(sp)
    4c38:	f122                	sd	s0,160(sp)
    4c3a:	ed26                	sd	s1,152(sp)
    4c3c:	e94a                	sd	s2,144(sp)
    4c3e:	e54e                	sd	s3,136(sp)
    4c40:	e152                	sd	s4,128(sp)
    4c42:	fcd6                	sd	s5,120(sp)
    4c44:	f8da                	sd	s6,112(sp)
    4c46:	f4de                	sd	s7,104(sp)
    4c48:	f0e2                	sd	s8,96(sp)
    4c4a:	ece6                	sd	s9,88(sp)
    4c4c:	e8ea                	sd	s10,80(sp)
    4c4e:	e4ee                	sd	s11,72(sp)
    4c50:	1900                	addi	s0,sp,176
    4c52:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = {"f0", "f1", "f2", "f3"};
    4c56:	00003797          	auipc	a5,0x3
    4c5a:	22278793          	addi	a5,a5,546 # 7e78 <malloc+0x1e2c>
    4c5e:	f6f43823          	sd	a5,-144(s0)
    4c62:	00003797          	auipc	a5,0x3
    4c66:	21e78793          	addi	a5,a5,542 # 7e80 <malloc+0x1e34>
    4c6a:	f6f43c23          	sd	a5,-136(s0)
    4c6e:	00003797          	auipc	a5,0x3
    4c72:	21a78793          	addi	a5,a5,538 # 7e88 <malloc+0x1e3c>
    4c76:	f8f43023          	sd	a5,-128(s0)
    4c7a:	00003797          	auipc	a5,0x3
    4c7e:	21678793          	addi	a5,a5,534 # 7e90 <malloc+0x1e44>
    4c82:	f8f43423          	sd	a5,-120(s0)
  for (pi = 0; pi < NCHILD; pi++) {
    4c86:	f7040c13          	addi	s8,s0,-144
  char *names[] = {"f0", "f1", "f2", "f3"};
    4c8a:	8962                	mv	s2,s8
  for (pi = 0; pi < NCHILD; pi++) {
    4c8c:	4481                	li	s1,0
    4c8e:	4a11                	li	s4,4
    fname = names[pi];
    4c90:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4c94:	854e                	mv	a0,s3
    4c96:	00001097          	auipc	ra,0x1
    4c9a:	fd4080e7          	jalr	-44(ra) # 5c6a <unlink>
    pid = fork();
    4c9e:	00001097          	auipc	ra,0x1
    4ca2:	f74080e7          	jalr	-140(ra) # 5c12 <fork>
    if (pid < 0) {
    4ca6:	04054463          	bltz	a0,4cee <fourfiles+0xba>
    if (pid == 0) {
    4caa:	c12d                	beqz	a0,4d0c <fourfiles+0xd8>
  for (pi = 0; pi < NCHILD; pi++) {
    4cac:	2485                	addiw	s1,s1,1
    4cae:	0921                	addi	s2,s2,8
    4cb0:	ff4490e3          	bne	s1,s4,4c90 <fourfiles+0x5c>
    4cb4:	4491                	li	s1,4
    wait(&xstatus);
    4cb6:	f6c40513          	addi	a0,s0,-148
    4cba:	00001097          	auipc	ra,0x1
    4cbe:	f68080e7          	jalr	-152(ra) # 5c22 <wait>
    if (xstatus != 0) exit(xstatus);
    4cc2:	f6c42b03          	lw	s6,-148(s0)
    4cc6:	0c0b1e63          	bnez	s6,4da2 <fourfiles+0x16e>
  for (pi = 0; pi < NCHILD; pi++) {
    4cca:	34fd                	addiw	s1,s1,-1
    4ccc:	f4ed                	bnez	s1,4cb6 <fourfiles+0x82>
    4cce:	03000b93          	li	s7,48
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    4cd2:	00008a17          	auipc	s4,0x8
    4cd6:	fa6a0a13          	addi	s4,s4,-90 # cc78 <buf>
    4cda:	00008a97          	auipc	s5,0x8
    4cde:	f9fa8a93          	addi	s5,s5,-97 # cc79 <buf+0x1>
    if (total != N * SZ) {
    4ce2:	6d85                	lui	s11,0x1
    4ce4:	770d8d93          	addi	s11,s11,1904 # 1770 <exectest+0x28>
  for (i = 0; i < NCHILD; i++) {
    4ce8:	03400d13          	li	s10,52
    4cec:	aa1d                	j	4e22 <fourfiles+0x1ee>
      printf("fork failed\n", s);
    4cee:	f5843583          	ld	a1,-168(s0)
    4cf2:	00002517          	auipc	a0,0x2
    4cf6:	12650513          	addi	a0,a0,294 # 6e18 <malloc+0xdcc>
    4cfa:	00001097          	auipc	ra,0x1
    4cfe:	29a080e7          	jalr	666(ra) # 5f94 <printf>
      exit(1);
    4d02:	4505                	li	a0,1
    4d04:	00001097          	auipc	ra,0x1
    4d08:	f16080e7          	jalr	-234(ra) # 5c1a <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4d0c:	20200593          	li	a1,514
    4d10:	854e                	mv	a0,s3
    4d12:	00001097          	auipc	ra,0x1
    4d16:	f48080e7          	jalr	-184(ra) # 5c5a <open>
    4d1a:	892a                	mv	s2,a0
      if (fd < 0) {
    4d1c:	04054763          	bltz	a0,4d6a <fourfiles+0x136>
      memset(buf, '0' + pi, SZ);
    4d20:	1f400613          	li	a2,500
    4d24:	0304859b          	addiw	a1,s1,48
    4d28:	00008517          	auipc	a0,0x8
    4d2c:	f5050513          	addi	a0,a0,-176 # cc78 <buf>
    4d30:	00001097          	auipc	ra,0x1
    4d34:	cf0080e7          	jalr	-784(ra) # 5a20 <memset>
    4d38:	44b1                	li	s1,12
        if ((n = write(fd, buf, SZ)) != SZ) {
    4d3a:	00008997          	auipc	s3,0x8
    4d3e:	f3e98993          	addi	s3,s3,-194 # cc78 <buf>
    4d42:	1f400613          	li	a2,500
    4d46:	85ce                	mv	a1,s3
    4d48:	854a                	mv	a0,s2
    4d4a:	00001097          	auipc	ra,0x1
    4d4e:	ef0080e7          	jalr	-272(ra) # 5c3a <write>
    4d52:	85aa                	mv	a1,a0
    4d54:	1f400793          	li	a5,500
    4d58:	02f51863          	bne	a0,a5,4d88 <fourfiles+0x154>
      for (i = 0; i < N; i++) {
    4d5c:	34fd                	addiw	s1,s1,-1
    4d5e:	f0f5                	bnez	s1,4d42 <fourfiles+0x10e>
      exit(0);
    4d60:	4501                	li	a0,0
    4d62:	00001097          	auipc	ra,0x1
    4d66:	eb8080e7          	jalr	-328(ra) # 5c1a <exit>
        printf("create failed\n", s);
    4d6a:	f5843583          	ld	a1,-168(s0)
    4d6e:	00003517          	auipc	a0,0x3
    4d72:	12a50513          	addi	a0,a0,298 # 7e98 <malloc+0x1e4c>
    4d76:	00001097          	auipc	ra,0x1
    4d7a:	21e080e7          	jalr	542(ra) # 5f94 <printf>
        exit(1);
    4d7e:	4505                	li	a0,1
    4d80:	00001097          	auipc	ra,0x1
    4d84:	e9a080e7          	jalr	-358(ra) # 5c1a <exit>
          printf("write failed %d\n", n);
    4d88:	00003517          	auipc	a0,0x3
    4d8c:	12050513          	addi	a0,a0,288 # 7ea8 <malloc+0x1e5c>
    4d90:	00001097          	auipc	ra,0x1
    4d94:	204080e7          	jalr	516(ra) # 5f94 <printf>
          exit(1);
    4d98:	4505                	li	a0,1
    4d9a:	00001097          	auipc	ra,0x1
    4d9e:	e80080e7          	jalr	-384(ra) # 5c1a <exit>
    if (xstatus != 0) exit(xstatus);
    4da2:	855a                	mv	a0,s6
    4da4:	00001097          	auipc	ra,0x1
    4da8:	e76080e7          	jalr	-394(ra) # 5c1a <exit>
          printf("wrong char\n", s);
    4dac:	f5843583          	ld	a1,-168(s0)
    4db0:	00003517          	auipc	a0,0x3
    4db4:	11050513          	addi	a0,a0,272 # 7ec0 <malloc+0x1e74>
    4db8:	00001097          	auipc	ra,0x1
    4dbc:	1dc080e7          	jalr	476(ra) # 5f94 <printf>
          exit(1);
    4dc0:	4505                	li	a0,1
    4dc2:	00001097          	auipc	ra,0x1
    4dc6:	e58080e7          	jalr	-424(ra) # 5c1a <exit>
      total += n;
    4dca:	00a9093b          	addw	s2,s2,a0
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    4dce:	660d                	lui	a2,0x3
    4dd0:	85d2                	mv	a1,s4
    4dd2:	854e                	mv	a0,s3
    4dd4:	00001097          	auipc	ra,0x1
    4dd8:	e5e080e7          	jalr	-418(ra) # 5c32 <read>
    4ddc:	02a05363          	blez	a0,4e02 <fourfiles+0x1ce>
    4de0:	00008797          	auipc	a5,0x8
    4de4:	e9878793          	addi	a5,a5,-360 # cc78 <buf>
    4de8:	fff5069b          	addiw	a3,a0,-1
    4dec:	1682                	slli	a3,a3,0x20
    4dee:	9281                	srli	a3,a3,0x20
    4df0:	96d6                	add	a3,a3,s5
        if (buf[j] != '0' + i) {
    4df2:	0007c703          	lbu	a4,0(a5)
    4df6:	fa971be3          	bne	a4,s1,4dac <fourfiles+0x178>
      for (j = 0; j < n; j++) {
    4dfa:	0785                	addi	a5,a5,1
    4dfc:	fed79be3          	bne	a5,a3,4df2 <fourfiles+0x1be>
    4e00:	b7e9                	j	4dca <fourfiles+0x196>
    close(fd);
    4e02:	854e                	mv	a0,s3
    4e04:	00001097          	auipc	ra,0x1
    4e08:	e3e080e7          	jalr	-450(ra) # 5c42 <close>
    if (total != N * SZ) {
    4e0c:	03b91863          	bne	s2,s11,4e3c <fourfiles+0x208>
    unlink(fname);
    4e10:	8566                	mv	a0,s9
    4e12:	00001097          	auipc	ra,0x1
    4e16:	e58080e7          	jalr	-424(ra) # 5c6a <unlink>
  for (i = 0; i < NCHILD; i++) {
    4e1a:	0c21                	addi	s8,s8,8
    4e1c:	2b85                	addiw	s7,s7,1
    4e1e:	03ab8d63          	beq	s7,s10,4e58 <fourfiles+0x224>
    fname = names[i];
    4e22:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    4e26:	4581                	li	a1,0
    4e28:	8566                	mv	a0,s9
    4e2a:	00001097          	auipc	ra,0x1
    4e2e:	e30080e7          	jalr	-464(ra) # 5c5a <open>
    4e32:	89aa                	mv	s3,a0
    total = 0;
    4e34:	895a                	mv	s2,s6
        if (buf[j] != '0' + i) {
    4e36:	000b849b          	sext.w	s1,s7
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    4e3a:	bf51                	j	4dce <fourfiles+0x19a>
      printf("wrong length %d\n", total);
    4e3c:	85ca                	mv	a1,s2
    4e3e:	00003517          	auipc	a0,0x3
    4e42:	09250513          	addi	a0,a0,146 # 7ed0 <malloc+0x1e84>
    4e46:	00001097          	auipc	ra,0x1
    4e4a:	14e080e7          	jalr	334(ra) # 5f94 <printf>
      exit(1);
    4e4e:	4505                	li	a0,1
    4e50:	00001097          	auipc	ra,0x1
    4e54:	dca080e7          	jalr	-566(ra) # 5c1a <exit>
}
    4e58:	70aa                	ld	ra,168(sp)
    4e5a:	740a                	ld	s0,160(sp)
    4e5c:	64ea                	ld	s1,152(sp)
    4e5e:	694a                	ld	s2,144(sp)
    4e60:	69aa                	ld	s3,136(sp)
    4e62:	6a0a                	ld	s4,128(sp)
    4e64:	7ae6                	ld	s5,120(sp)
    4e66:	7b46                	ld	s6,112(sp)
    4e68:	7ba6                	ld	s7,104(sp)
    4e6a:	7c06                	ld	s8,96(sp)
    4e6c:	6ce6                	ld	s9,88(sp)
    4e6e:	6d46                	ld	s10,80(sp)
    4e70:	6da6                	ld	s11,72(sp)
    4e72:	614d                	addi	sp,sp,176
    4e74:	8082                	ret

0000000000004e76 <concreate>:
void concreate(char *s) {
    4e76:	7135                	addi	sp,sp,-160
    4e78:	ed06                	sd	ra,152(sp)
    4e7a:	e922                	sd	s0,144(sp)
    4e7c:	e526                	sd	s1,136(sp)
    4e7e:	e14a                	sd	s2,128(sp)
    4e80:	fcce                	sd	s3,120(sp)
    4e82:	f8d2                	sd	s4,112(sp)
    4e84:	f4d6                	sd	s5,104(sp)
    4e86:	f0da                	sd	s6,96(sp)
    4e88:	ecde                	sd	s7,88(sp)
    4e8a:	1100                	addi	s0,sp,160
    4e8c:	89aa                	mv	s3,a0
  file[0] = 'C';
    4e8e:	04300793          	li	a5,67
    4e92:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4e96:	fa040523          	sb	zero,-86(s0)
  for (i = 0; i < N; i++) {
    4e9a:	4901                	li	s2,0
    if (pid && (i % 3) == 1) {
    4e9c:	4b0d                	li	s6,3
    4e9e:	4a85                	li	s5,1
      link("C0", file);
    4ea0:	00003b97          	auipc	s7,0x3
    4ea4:	048b8b93          	addi	s7,s7,72 # 7ee8 <malloc+0x1e9c>
  for (i = 0; i < N; i++) {
    4ea8:	02800a13          	li	s4,40
    4eac:	acc9                	j	517e <concreate+0x308>
      link("C0", file);
    4eae:	fa840593          	addi	a1,s0,-88
    4eb2:	855e                	mv	a0,s7
    4eb4:	00001097          	auipc	ra,0x1
    4eb8:	dc6080e7          	jalr	-570(ra) # 5c7a <link>
    if (pid == 0) {
    4ebc:	a465                	j	5164 <concreate+0x2ee>
    } else if (pid == 0 && (i % 5) == 1) {
    4ebe:	4795                	li	a5,5
    4ec0:	02f9693b          	remw	s2,s2,a5
    4ec4:	4785                	li	a5,1
    4ec6:	02f90b63          	beq	s2,a5,4efc <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4eca:	20200593          	li	a1,514
    4ece:	fa840513          	addi	a0,s0,-88
    4ed2:	00001097          	auipc	ra,0x1
    4ed6:	d88080e7          	jalr	-632(ra) # 5c5a <open>
      if (fd < 0) {
    4eda:	26055c63          	bgez	a0,5152 <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    4ede:	fa840593          	addi	a1,s0,-88
    4ee2:	00003517          	auipc	a0,0x3
    4ee6:	00e50513          	addi	a0,a0,14 # 7ef0 <malloc+0x1ea4>
    4eea:	00001097          	auipc	ra,0x1
    4eee:	0aa080e7          	jalr	170(ra) # 5f94 <printf>
        exit(1);
    4ef2:	4505                	li	a0,1
    4ef4:	00001097          	auipc	ra,0x1
    4ef8:	d26080e7          	jalr	-730(ra) # 5c1a <exit>
      link("C0", file);
    4efc:	fa840593          	addi	a1,s0,-88
    4f00:	00003517          	auipc	a0,0x3
    4f04:	fe850513          	addi	a0,a0,-24 # 7ee8 <malloc+0x1e9c>
    4f08:	00001097          	auipc	ra,0x1
    4f0c:	d72080e7          	jalr	-654(ra) # 5c7a <link>
      exit(0);
    4f10:	4501                	li	a0,0
    4f12:	00001097          	auipc	ra,0x1
    4f16:	d08080e7          	jalr	-760(ra) # 5c1a <exit>
      if (xstatus != 0) exit(1);
    4f1a:	4505                	li	a0,1
    4f1c:	00001097          	auipc	ra,0x1
    4f20:	cfe080e7          	jalr	-770(ra) # 5c1a <exit>
  memset(fa, 0, sizeof(fa));
    4f24:	02800613          	li	a2,40
    4f28:	4581                	li	a1,0
    4f2a:	f8040513          	addi	a0,s0,-128
    4f2e:	00001097          	auipc	ra,0x1
    4f32:	af2080e7          	jalr	-1294(ra) # 5a20 <memset>
  fd = open(".", 0);
    4f36:	4581                	li	a1,0
    4f38:	00002517          	auipc	a0,0x2
    4f3c:	93850513          	addi	a0,a0,-1736 # 6870 <malloc+0x824>
    4f40:	00001097          	auipc	ra,0x1
    4f44:	d1a080e7          	jalr	-742(ra) # 5c5a <open>
    4f48:	892a                	mv	s2,a0
  n = 0;
    4f4a:	8aa6                	mv	s5,s1
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    4f4c:	04300a13          	li	s4,67
      if (i < 0 || i >= sizeof(fa)) {
    4f50:	02700b13          	li	s6,39
      fa[i] = 1;
    4f54:	4b85                	li	s7,1
  while (read(fd, &de, sizeof(de)) > 0) {
    4f56:	4641                	li	a2,16
    4f58:	f7040593          	addi	a1,s0,-144
    4f5c:	854a                	mv	a0,s2
    4f5e:	00001097          	auipc	ra,0x1
    4f62:	cd4080e7          	jalr	-812(ra) # 5c32 <read>
    4f66:	08a05263          	blez	a0,4fea <concreate+0x174>
    if (de.inum == 0) continue;
    4f6a:	f7045783          	lhu	a5,-144(s0)
    4f6e:	d7e5                	beqz	a5,4f56 <concreate+0xe0>
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    4f70:	f7244783          	lbu	a5,-142(s0)
    4f74:	ff4791e3          	bne	a5,s4,4f56 <concreate+0xe0>
    4f78:	f7444783          	lbu	a5,-140(s0)
    4f7c:	ffe9                	bnez	a5,4f56 <concreate+0xe0>
      i = de.name[1] - '0';
    4f7e:	f7344783          	lbu	a5,-141(s0)
    4f82:	fd07879b          	addiw	a5,a5,-48
    4f86:	0007871b          	sext.w	a4,a5
      if (i < 0 || i >= sizeof(fa)) {
    4f8a:	02eb6063          	bltu	s6,a4,4faa <concreate+0x134>
      if (fa[i]) {
    4f8e:	fb070793          	addi	a5,a4,-80 # fb0 <linktest+0xb4>
    4f92:	97a2                	add	a5,a5,s0
    4f94:	fd07c783          	lbu	a5,-48(a5)
    4f98:	eb8d                	bnez	a5,4fca <concreate+0x154>
      fa[i] = 1;
    4f9a:	fb070793          	addi	a5,a4,-80
    4f9e:	00878733          	add	a4,a5,s0
    4fa2:	fd770823          	sb	s7,-48(a4)
      n++;
    4fa6:	2a85                	addiw	s5,s5,1
    4fa8:	b77d                	j	4f56 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4faa:	f7240613          	addi	a2,s0,-142
    4fae:	85ce                	mv	a1,s3
    4fb0:	00003517          	auipc	a0,0x3
    4fb4:	f6050513          	addi	a0,a0,-160 # 7f10 <malloc+0x1ec4>
    4fb8:	00001097          	auipc	ra,0x1
    4fbc:	fdc080e7          	jalr	-36(ra) # 5f94 <printf>
        exit(1);
    4fc0:	4505                	li	a0,1
    4fc2:	00001097          	auipc	ra,0x1
    4fc6:	c58080e7          	jalr	-936(ra) # 5c1a <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4fca:	f7240613          	addi	a2,s0,-142
    4fce:	85ce                	mv	a1,s3
    4fd0:	00003517          	auipc	a0,0x3
    4fd4:	f6050513          	addi	a0,a0,-160 # 7f30 <malloc+0x1ee4>
    4fd8:	00001097          	auipc	ra,0x1
    4fdc:	fbc080e7          	jalr	-68(ra) # 5f94 <printf>
        exit(1);
    4fe0:	4505                	li	a0,1
    4fe2:	00001097          	auipc	ra,0x1
    4fe6:	c38080e7          	jalr	-968(ra) # 5c1a <exit>
  close(fd);
    4fea:	854a                	mv	a0,s2
    4fec:	00001097          	auipc	ra,0x1
    4ff0:	c56080e7          	jalr	-938(ra) # 5c42 <close>
  if (n != N) {
    4ff4:	02800793          	li	a5,40
    4ff8:	00fa9763          	bne	s5,a5,5006 <concreate+0x190>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    4ffc:	4a8d                	li	s5,3
    4ffe:	4b05                	li	s6,1
  for (i = 0; i < N; i++) {
    5000:	02800a13          	li	s4,40
    5004:	a8c9                	j	50d6 <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    5006:	85ce                	mv	a1,s3
    5008:	00003517          	auipc	a0,0x3
    500c:	f5050513          	addi	a0,a0,-176 # 7f58 <malloc+0x1f0c>
    5010:	00001097          	auipc	ra,0x1
    5014:	f84080e7          	jalr	-124(ra) # 5f94 <printf>
    exit(1);
    5018:	4505                	li	a0,1
    501a:	00001097          	auipc	ra,0x1
    501e:	c00080e7          	jalr	-1024(ra) # 5c1a <exit>
      printf("%s: fork failed\n", s);
    5022:	85ce                	mv	a1,s3
    5024:	00002517          	auipc	a0,0x2
    5028:	9ec50513          	addi	a0,a0,-1556 # 6a10 <malloc+0x9c4>
    502c:	00001097          	auipc	ra,0x1
    5030:	f68080e7          	jalr	-152(ra) # 5f94 <printf>
      exit(1);
    5034:	4505                	li	a0,1
    5036:	00001097          	auipc	ra,0x1
    503a:	be4080e7          	jalr	-1052(ra) # 5c1a <exit>
      close(open(file, 0));
    503e:	4581                	li	a1,0
    5040:	fa840513          	addi	a0,s0,-88
    5044:	00001097          	auipc	ra,0x1
    5048:	c16080e7          	jalr	-1002(ra) # 5c5a <open>
    504c:	00001097          	auipc	ra,0x1
    5050:	bf6080e7          	jalr	-1034(ra) # 5c42 <close>
      close(open(file, 0));
    5054:	4581                	li	a1,0
    5056:	fa840513          	addi	a0,s0,-88
    505a:	00001097          	auipc	ra,0x1
    505e:	c00080e7          	jalr	-1024(ra) # 5c5a <open>
    5062:	00001097          	auipc	ra,0x1
    5066:	be0080e7          	jalr	-1056(ra) # 5c42 <close>
      close(open(file, 0));
    506a:	4581                	li	a1,0
    506c:	fa840513          	addi	a0,s0,-88
    5070:	00001097          	auipc	ra,0x1
    5074:	bea080e7          	jalr	-1046(ra) # 5c5a <open>
    5078:	00001097          	auipc	ra,0x1
    507c:	bca080e7          	jalr	-1078(ra) # 5c42 <close>
      close(open(file, 0));
    5080:	4581                	li	a1,0
    5082:	fa840513          	addi	a0,s0,-88
    5086:	00001097          	auipc	ra,0x1
    508a:	bd4080e7          	jalr	-1068(ra) # 5c5a <open>
    508e:	00001097          	auipc	ra,0x1
    5092:	bb4080e7          	jalr	-1100(ra) # 5c42 <close>
      close(open(file, 0));
    5096:	4581                	li	a1,0
    5098:	fa840513          	addi	a0,s0,-88
    509c:	00001097          	auipc	ra,0x1
    50a0:	bbe080e7          	jalr	-1090(ra) # 5c5a <open>
    50a4:	00001097          	auipc	ra,0x1
    50a8:	b9e080e7          	jalr	-1122(ra) # 5c42 <close>
      close(open(file, 0));
    50ac:	4581                	li	a1,0
    50ae:	fa840513          	addi	a0,s0,-88
    50b2:	00001097          	auipc	ra,0x1
    50b6:	ba8080e7          	jalr	-1112(ra) # 5c5a <open>
    50ba:	00001097          	auipc	ra,0x1
    50be:	b88080e7          	jalr	-1144(ra) # 5c42 <close>
    if (pid == 0)
    50c2:	08090363          	beqz	s2,5148 <concreate+0x2d2>
      wait(0);
    50c6:	4501                	li	a0,0
    50c8:	00001097          	auipc	ra,0x1
    50cc:	b5a080e7          	jalr	-1190(ra) # 5c22 <wait>
  for (i = 0; i < N; i++) {
    50d0:	2485                	addiw	s1,s1,1
    50d2:	0f448563          	beq	s1,s4,51bc <concreate+0x346>
    file[1] = '0' + i;
    50d6:	0304879b          	addiw	a5,s1,48
    50da:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    50de:	00001097          	auipc	ra,0x1
    50e2:	b34080e7          	jalr	-1228(ra) # 5c12 <fork>
    50e6:	892a                	mv	s2,a0
    if (pid < 0) {
    50e8:	f2054de3          	bltz	a0,5022 <concreate+0x1ac>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    50ec:	0354e73b          	remw	a4,s1,s5
    50f0:	00a767b3          	or	a5,a4,a0
    50f4:	2781                	sext.w	a5,a5
    50f6:	d7a1                	beqz	a5,503e <concreate+0x1c8>
    50f8:	01671363          	bne	a4,s6,50fe <concreate+0x288>
    50fc:	f129                	bnez	a0,503e <concreate+0x1c8>
      unlink(file);
    50fe:	fa840513          	addi	a0,s0,-88
    5102:	00001097          	auipc	ra,0x1
    5106:	b68080e7          	jalr	-1176(ra) # 5c6a <unlink>
      unlink(file);
    510a:	fa840513          	addi	a0,s0,-88
    510e:	00001097          	auipc	ra,0x1
    5112:	b5c080e7          	jalr	-1188(ra) # 5c6a <unlink>
      unlink(file);
    5116:	fa840513          	addi	a0,s0,-88
    511a:	00001097          	auipc	ra,0x1
    511e:	b50080e7          	jalr	-1200(ra) # 5c6a <unlink>
      unlink(file);
    5122:	fa840513          	addi	a0,s0,-88
    5126:	00001097          	auipc	ra,0x1
    512a:	b44080e7          	jalr	-1212(ra) # 5c6a <unlink>
      unlink(file);
    512e:	fa840513          	addi	a0,s0,-88
    5132:	00001097          	auipc	ra,0x1
    5136:	b38080e7          	jalr	-1224(ra) # 5c6a <unlink>
      unlink(file);
    513a:	fa840513          	addi	a0,s0,-88
    513e:	00001097          	auipc	ra,0x1
    5142:	b2c080e7          	jalr	-1236(ra) # 5c6a <unlink>
    5146:	bfb5                	j	50c2 <concreate+0x24c>
      exit(0);
    5148:	4501                	li	a0,0
    514a:	00001097          	auipc	ra,0x1
    514e:	ad0080e7          	jalr	-1328(ra) # 5c1a <exit>
      close(fd);
    5152:	00001097          	auipc	ra,0x1
    5156:	af0080e7          	jalr	-1296(ra) # 5c42 <close>
    if (pid == 0) {
    515a:	bb5d                	j	4f10 <concreate+0x9a>
      close(fd);
    515c:	00001097          	auipc	ra,0x1
    5160:	ae6080e7          	jalr	-1306(ra) # 5c42 <close>
      wait(&xstatus);
    5164:	f6c40513          	addi	a0,s0,-148
    5168:	00001097          	auipc	ra,0x1
    516c:	aba080e7          	jalr	-1350(ra) # 5c22 <wait>
      if (xstatus != 0) exit(1);
    5170:	f6c42483          	lw	s1,-148(s0)
    5174:	da0493e3          	bnez	s1,4f1a <concreate+0xa4>
  for (i = 0; i < N; i++) {
    5178:	2905                	addiw	s2,s2,1
    517a:	db4905e3          	beq	s2,s4,4f24 <concreate+0xae>
    file[1] = '0' + i;
    517e:	0309079b          	addiw	a5,s2,48
    5182:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    5186:	fa840513          	addi	a0,s0,-88
    518a:	00001097          	auipc	ra,0x1
    518e:	ae0080e7          	jalr	-1312(ra) # 5c6a <unlink>
    pid = fork();
    5192:	00001097          	auipc	ra,0x1
    5196:	a80080e7          	jalr	-1408(ra) # 5c12 <fork>
    if (pid && (i % 3) == 1) {
    519a:	d20502e3          	beqz	a0,4ebe <concreate+0x48>
    519e:	036967bb          	remw	a5,s2,s6
    51a2:	d15786e3          	beq	a5,s5,4eae <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    51a6:	20200593          	li	a1,514
    51aa:	fa840513          	addi	a0,s0,-88
    51ae:	00001097          	auipc	ra,0x1
    51b2:	aac080e7          	jalr	-1364(ra) # 5c5a <open>
      if (fd < 0) {
    51b6:	fa0553e3          	bgez	a0,515c <concreate+0x2e6>
    51ba:	b315                	j	4ede <concreate+0x68>
}
    51bc:	60ea                	ld	ra,152(sp)
    51be:	644a                	ld	s0,144(sp)
    51c0:	64aa                	ld	s1,136(sp)
    51c2:	690a                	ld	s2,128(sp)
    51c4:	79e6                	ld	s3,120(sp)
    51c6:	7a46                	ld	s4,112(sp)
    51c8:	7aa6                	ld	s5,104(sp)
    51ca:	7b06                	ld	s6,96(sp)
    51cc:	6be6                	ld	s7,88(sp)
    51ce:	610d                	addi	sp,sp,160
    51d0:	8082                	ret

00000000000051d2 <bigfile>:
void bigfile(char *s) {
    51d2:	7139                	addi	sp,sp,-64
    51d4:	fc06                	sd	ra,56(sp)
    51d6:	f822                	sd	s0,48(sp)
    51d8:	f426                	sd	s1,40(sp)
    51da:	f04a                	sd	s2,32(sp)
    51dc:	ec4e                	sd	s3,24(sp)
    51de:	e852                	sd	s4,16(sp)
    51e0:	e456                	sd	s5,8(sp)
    51e2:	0080                	addi	s0,sp,64
    51e4:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    51e6:	00003517          	auipc	a0,0x3
    51ea:	daa50513          	addi	a0,a0,-598 # 7f90 <malloc+0x1f44>
    51ee:	00001097          	auipc	ra,0x1
    51f2:	a7c080e7          	jalr	-1412(ra) # 5c6a <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    51f6:	20200593          	li	a1,514
    51fa:	00003517          	auipc	a0,0x3
    51fe:	d9650513          	addi	a0,a0,-618 # 7f90 <malloc+0x1f44>
    5202:	00001097          	auipc	ra,0x1
    5206:	a58080e7          	jalr	-1448(ra) # 5c5a <open>
    520a:	89aa                	mv	s3,a0
  for (i = 0; i < N; i++) {
    520c:	4481                	li	s1,0
    memset(buf, i, SZ);
    520e:	00008917          	auipc	s2,0x8
    5212:	a6a90913          	addi	s2,s2,-1430 # cc78 <buf>
  for (i = 0; i < N; i++) {
    5216:	4a51                	li	s4,20
  if (fd < 0) {
    5218:	0a054063          	bltz	a0,52b8 <bigfile+0xe6>
    memset(buf, i, SZ);
    521c:	25800613          	li	a2,600
    5220:	85a6                	mv	a1,s1
    5222:	854a                	mv	a0,s2
    5224:	00000097          	auipc	ra,0x0
    5228:	7fc080e7          	jalr	2044(ra) # 5a20 <memset>
    if (write(fd, buf, SZ) != SZ) {
    522c:	25800613          	li	a2,600
    5230:	85ca                	mv	a1,s2
    5232:	854e                	mv	a0,s3
    5234:	00001097          	auipc	ra,0x1
    5238:	a06080e7          	jalr	-1530(ra) # 5c3a <write>
    523c:	25800793          	li	a5,600
    5240:	08f51a63          	bne	a0,a5,52d4 <bigfile+0x102>
  for (i = 0; i < N; i++) {
    5244:	2485                	addiw	s1,s1,1
    5246:	fd449be3          	bne	s1,s4,521c <bigfile+0x4a>
  close(fd);
    524a:	854e                	mv	a0,s3
    524c:	00001097          	auipc	ra,0x1
    5250:	9f6080e7          	jalr	-1546(ra) # 5c42 <close>
  fd = open("bigfile.dat", 0);
    5254:	4581                	li	a1,0
    5256:	00003517          	auipc	a0,0x3
    525a:	d3a50513          	addi	a0,a0,-710 # 7f90 <malloc+0x1f44>
    525e:	00001097          	auipc	ra,0x1
    5262:	9fc080e7          	jalr	-1540(ra) # 5c5a <open>
    5266:	8a2a                	mv	s4,a0
  total = 0;
    5268:	4981                	li	s3,0
  for (i = 0;; i++) {
    526a:	4481                	li	s1,0
    cc = read(fd, buf, SZ / 2);
    526c:	00008917          	auipc	s2,0x8
    5270:	a0c90913          	addi	s2,s2,-1524 # cc78 <buf>
  if (fd < 0) {
    5274:	06054e63          	bltz	a0,52f0 <bigfile+0x11e>
    cc = read(fd, buf, SZ / 2);
    5278:	12c00613          	li	a2,300
    527c:	85ca                	mv	a1,s2
    527e:	8552                	mv	a0,s4
    5280:	00001097          	auipc	ra,0x1
    5284:	9b2080e7          	jalr	-1614(ra) # 5c32 <read>
    if (cc < 0) {
    5288:	08054263          	bltz	a0,530c <bigfile+0x13a>
    if (cc == 0) break;
    528c:	c971                	beqz	a0,5360 <bigfile+0x18e>
    if (cc != SZ / 2) {
    528e:	12c00793          	li	a5,300
    5292:	08f51b63          	bne	a0,a5,5328 <bigfile+0x156>
    if (buf[0] != i / 2 || buf[SZ / 2 - 1] != i / 2) {
    5296:	01f4d79b          	srliw	a5,s1,0x1f
    529a:	9fa5                	addw	a5,a5,s1
    529c:	4017d79b          	sraiw	a5,a5,0x1
    52a0:	00094703          	lbu	a4,0(s2)
    52a4:	0af71063          	bne	a4,a5,5344 <bigfile+0x172>
    52a8:	12b94703          	lbu	a4,299(s2)
    52ac:	08f71c63          	bne	a4,a5,5344 <bigfile+0x172>
    total += cc;
    52b0:	12c9899b          	addiw	s3,s3,300
  for (i = 0;; i++) {
    52b4:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ / 2);
    52b6:	b7c9                	j	5278 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    52b8:	85d6                	mv	a1,s5
    52ba:	00003517          	auipc	a0,0x3
    52be:	ce650513          	addi	a0,a0,-794 # 7fa0 <malloc+0x1f54>
    52c2:	00001097          	auipc	ra,0x1
    52c6:	cd2080e7          	jalr	-814(ra) # 5f94 <printf>
    exit(1);
    52ca:	4505                	li	a0,1
    52cc:	00001097          	auipc	ra,0x1
    52d0:	94e080e7          	jalr	-1714(ra) # 5c1a <exit>
      printf("%s: write bigfile failed\n", s);
    52d4:	85d6                	mv	a1,s5
    52d6:	00003517          	auipc	a0,0x3
    52da:	cea50513          	addi	a0,a0,-790 # 7fc0 <malloc+0x1f74>
    52de:	00001097          	auipc	ra,0x1
    52e2:	cb6080e7          	jalr	-842(ra) # 5f94 <printf>
      exit(1);
    52e6:	4505                	li	a0,1
    52e8:	00001097          	auipc	ra,0x1
    52ec:	932080e7          	jalr	-1742(ra) # 5c1a <exit>
    printf("%s: cannot open bigfile\n", s);
    52f0:	85d6                	mv	a1,s5
    52f2:	00003517          	auipc	a0,0x3
    52f6:	cee50513          	addi	a0,a0,-786 # 7fe0 <malloc+0x1f94>
    52fa:	00001097          	auipc	ra,0x1
    52fe:	c9a080e7          	jalr	-870(ra) # 5f94 <printf>
    exit(1);
    5302:	4505                	li	a0,1
    5304:	00001097          	auipc	ra,0x1
    5308:	916080e7          	jalr	-1770(ra) # 5c1a <exit>
      printf("%s: read bigfile failed\n", s);
    530c:	85d6                	mv	a1,s5
    530e:	00003517          	auipc	a0,0x3
    5312:	cf250513          	addi	a0,a0,-782 # 8000 <malloc+0x1fb4>
    5316:	00001097          	auipc	ra,0x1
    531a:	c7e080e7          	jalr	-898(ra) # 5f94 <printf>
      exit(1);
    531e:	4505                	li	a0,1
    5320:	00001097          	auipc	ra,0x1
    5324:	8fa080e7          	jalr	-1798(ra) # 5c1a <exit>
      printf("%s: short read bigfile\n", s);
    5328:	85d6                	mv	a1,s5
    532a:	00003517          	auipc	a0,0x3
    532e:	cf650513          	addi	a0,a0,-778 # 8020 <malloc+0x1fd4>
    5332:	00001097          	auipc	ra,0x1
    5336:	c62080e7          	jalr	-926(ra) # 5f94 <printf>
      exit(1);
    533a:	4505                	li	a0,1
    533c:	00001097          	auipc	ra,0x1
    5340:	8de080e7          	jalr	-1826(ra) # 5c1a <exit>
      printf("%s: read bigfile wrong data\n", s);
    5344:	85d6                	mv	a1,s5
    5346:	00003517          	auipc	a0,0x3
    534a:	cf250513          	addi	a0,a0,-782 # 8038 <malloc+0x1fec>
    534e:	00001097          	auipc	ra,0x1
    5352:	c46080e7          	jalr	-954(ra) # 5f94 <printf>
      exit(1);
    5356:	4505                	li	a0,1
    5358:	00001097          	auipc	ra,0x1
    535c:	8c2080e7          	jalr	-1854(ra) # 5c1a <exit>
  close(fd);
    5360:	8552                	mv	a0,s4
    5362:	00001097          	auipc	ra,0x1
    5366:	8e0080e7          	jalr	-1824(ra) # 5c42 <close>
  if (total != N * SZ) {
    536a:	678d                	lui	a5,0x3
    536c:	ee078793          	addi	a5,a5,-288 # 2ee0 <sbrklast+0x86>
    5370:	02f99363          	bne	s3,a5,5396 <bigfile+0x1c4>
  unlink("bigfile.dat");
    5374:	00003517          	auipc	a0,0x3
    5378:	c1c50513          	addi	a0,a0,-996 # 7f90 <malloc+0x1f44>
    537c:	00001097          	auipc	ra,0x1
    5380:	8ee080e7          	jalr	-1810(ra) # 5c6a <unlink>
}
    5384:	70e2                	ld	ra,56(sp)
    5386:	7442                	ld	s0,48(sp)
    5388:	74a2                	ld	s1,40(sp)
    538a:	7902                	ld	s2,32(sp)
    538c:	69e2                	ld	s3,24(sp)
    538e:	6a42                	ld	s4,16(sp)
    5390:	6aa2                	ld	s5,8(sp)
    5392:	6121                	addi	sp,sp,64
    5394:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    5396:	85d6                	mv	a1,s5
    5398:	00003517          	auipc	a0,0x3
    539c:	cc050513          	addi	a0,a0,-832 # 8058 <malloc+0x200c>
    53a0:	00001097          	auipc	ra,0x1
    53a4:	bf4080e7          	jalr	-1036(ra) # 5f94 <printf>
    exit(1);
    53a8:	4505                	li	a0,1
    53aa:	00001097          	auipc	ra,0x1
    53ae:	870080e7          	jalr	-1936(ra) # 5c1a <exit>

00000000000053b2 <fsfull>:
void fsfull() {
    53b2:	7171                	addi	sp,sp,-176
    53b4:	f506                	sd	ra,168(sp)
    53b6:	f122                	sd	s0,160(sp)
    53b8:	ed26                	sd	s1,152(sp)
    53ba:	e94a                	sd	s2,144(sp)
    53bc:	e54e                	sd	s3,136(sp)
    53be:	e152                	sd	s4,128(sp)
    53c0:	fcd6                	sd	s5,120(sp)
    53c2:	f8da                	sd	s6,112(sp)
    53c4:	f4de                	sd	s7,104(sp)
    53c6:	f0e2                	sd	s8,96(sp)
    53c8:	ece6                	sd	s9,88(sp)
    53ca:	e8ea                	sd	s10,80(sp)
    53cc:	e4ee                	sd	s11,72(sp)
    53ce:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    53d0:	00003517          	auipc	a0,0x3
    53d4:	ca850513          	addi	a0,a0,-856 # 8078 <malloc+0x202c>
    53d8:	00001097          	auipc	ra,0x1
    53dc:	bbc080e7          	jalr	-1092(ra) # 5f94 <printf>
  int fsblocks = 0;
    53e0:	4981                	li	s3,0
  for (nfiles = 0;; nfiles++) {
    53e2:	4481                	li	s1,0
    name[0] = 'f';
    53e4:	06600d93          	li	s11,102
    name[1] = '0' + nfiles / 1000;
    53e8:	3e800c93          	li	s9,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    53ec:	06400c13          	li	s8,100
    name[3] = '0' + (nfiles % 100) / 10;
    53f0:	4ba9                	li	s7,10
    printf("writing %s\n", name);
    53f2:	00003d17          	auipc	s10,0x3
    53f6:	c96d0d13          	addi	s10,s10,-874 # 8088 <malloc+0x203c>
      int cc = write(fd, buf, BSIZE);
    53fa:	00008a97          	auipc	s5,0x8
    53fe:	87ea8a93          	addi	s5,s5,-1922 # cc78 <buf>
    name[0] = 'f';
    5402:	f5b40823          	sb	s11,-176(s0)
    name[1] = '0' + nfiles / 1000;
    5406:	0394c7bb          	divw	a5,s1,s9
    540a:	0307879b          	addiw	a5,a5,48
    540e:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5412:	0394e7bb          	remw	a5,s1,s9
    5416:	0387c7bb          	divw	a5,a5,s8
    541a:	0307879b          	addiw	a5,a5,48
    541e:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5422:	0384e7bb          	remw	a5,s1,s8
    5426:	0377c7bb          	divw	a5,a5,s7
    542a:	0307879b          	addiw	a5,a5,48
    542e:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    5432:	0374e7bb          	remw	a5,s1,s7
    5436:	0307879b          	addiw	a5,a5,48
    543a:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    543e:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    5442:	f5040593          	addi	a1,s0,-176
    5446:	856a                	mv	a0,s10
    5448:	00001097          	auipc	ra,0x1
    544c:	b4c080e7          	jalr	-1204(ra) # 5f94 <printf>
    int fd = open(name, O_CREATE | O_RDWR);
    5450:	20200593          	li	a1,514
    5454:	f5040513          	addi	a0,s0,-176
    5458:	00001097          	auipc	ra,0x1
    545c:	802080e7          	jalr	-2046(ra) # 5c5a <open>
    5460:	892a                	mv	s2,a0
    if (fd < 0) {
    5462:	0a055663          	bgez	a0,550e <fsfull+0x15c>
      printf("open %s failed\n", name);
    5466:	f5040593          	addi	a1,s0,-176
    546a:	00003517          	auipc	a0,0x3
    546e:	c2e50513          	addi	a0,a0,-978 # 8098 <malloc+0x204c>
    5472:	00001097          	auipc	ra,0x1
    5476:	b22080e7          	jalr	-1246(ra) # 5f94 <printf>
  while (nfiles >= 0) {
    547a:	0604c363          	bltz	s1,54e0 <fsfull+0x12e>
    name[0] = 'f';
    547e:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    5482:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5486:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    548a:	4929                	li	s2,10
  while (nfiles >= 0) {
    548c:	5afd                	li	s5,-1
    name[0] = 'f';
    548e:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    5492:	0344c7bb          	divw	a5,s1,s4
    5496:	0307879b          	addiw	a5,a5,48
    549a:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    549e:	0344e7bb          	remw	a5,s1,s4
    54a2:	0337c7bb          	divw	a5,a5,s3
    54a6:	0307879b          	addiw	a5,a5,48
    54aa:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    54ae:	0334e7bb          	remw	a5,s1,s3
    54b2:	0327c7bb          	divw	a5,a5,s2
    54b6:	0307879b          	addiw	a5,a5,48
    54ba:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    54be:	0324e7bb          	remw	a5,s1,s2
    54c2:	0307879b          	addiw	a5,a5,48
    54c6:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    54ca:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    54ce:	f5040513          	addi	a0,s0,-176
    54d2:	00000097          	auipc	ra,0x0
    54d6:	798080e7          	jalr	1944(ra) # 5c6a <unlink>
    nfiles--;
    54da:	34fd                	addiw	s1,s1,-1
  while (nfiles >= 0) {
    54dc:	fb5499e3          	bne	s1,s5,548e <fsfull+0xdc>
  printf("fsfull test finished\n");
    54e0:	00003517          	auipc	a0,0x3
    54e4:	be850513          	addi	a0,a0,-1048 # 80c8 <malloc+0x207c>
    54e8:	00001097          	auipc	ra,0x1
    54ec:	aac080e7          	jalr	-1364(ra) # 5f94 <printf>
}
    54f0:	70aa                	ld	ra,168(sp)
    54f2:	740a                	ld	s0,160(sp)
    54f4:	64ea                	ld	s1,152(sp)
    54f6:	694a                	ld	s2,144(sp)
    54f8:	69aa                	ld	s3,136(sp)
    54fa:	6a0a                	ld	s4,128(sp)
    54fc:	7ae6                	ld	s5,120(sp)
    54fe:	7b46                	ld	s6,112(sp)
    5500:	7ba6                	ld	s7,104(sp)
    5502:	7c06                	ld	s8,96(sp)
    5504:	6ce6                	ld	s9,88(sp)
    5506:	6d46                	ld	s10,80(sp)
    5508:	6da6                	ld	s11,72(sp)
    550a:	614d                	addi	sp,sp,176
    550c:	8082                	ret
    int total = 0;
    550e:	4a01                	li	s4,0
      if (cc < BSIZE) break;
    5510:	3ff00b13          	li	s6,1023
      int cc = write(fd, buf, BSIZE);
    5514:	40000613          	li	a2,1024
    5518:	85d6                	mv	a1,s5
    551a:	854a                	mv	a0,s2
    551c:	00000097          	auipc	ra,0x0
    5520:	71e080e7          	jalr	1822(ra) # 5c3a <write>
      if (cc < BSIZE) break;
    5524:	00ab5663          	bge	s6,a0,5530 <fsfull+0x17e>
      total += cc;
    5528:	00aa0a3b          	addw	s4,s4,a0
      fsblocks++;
    552c:	2985                	addiw	s3,s3,1
    while (1) {
    552e:	b7dd                	j	5514 <fsfull+0x162>
    printf("wrote %d bytes, %d blocks\n", total, fsblocks);
    5530:	864e                	mv	a2,s3
    5532:	85d2                	mv	a1,s4
    5534:	00003517          	auipc	a0,0x3
    5538:	b7450513          	addi	a0,a0,-1164 # 80a8 <malloc+0x205c>
    553c:	00001097          	auipc	ra,0x1
    5540:	a58080e7          	jalr	-1448(ra) # 5f94 <printf>
    close(fd);
    5544:	854a                	mv	a0,s2
    5546:	00000097          	auipc	ra,0x0
    554a:	6fc080e7          	jalr	1788(ra) # 5c42 <close>
    if (total == 0) break;
    554e:	f20a06e3          	beqz	s4,547a <fsfull+0xc8>
  for (nfiles = 0;; nfiles++) {
    5552:	2485                	addiw	s1,s1,1
    5554:	b57d                	j	5402 <fsfull+0x50>

0000000000005556 <run>:
// drive tests
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int run(void f(char *), char *s) {
    5556:	7179                	addi	sp,sp,-48
    5558:	f406                	sd	ra,40(sp)
    555a:	f022                	sd	s0,32(sp)
    555c:	ec26                	sd	s1,24(sp)
    555e:	e84a                	sd	s2,16(sp)
    5560:	1800                	addi	s0,sp,48
    5562:	84aa                	mv	s1,a0
    5564:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5566:	00003517          	auipc	a0,0x3
    556a:	b7a50513          	addi	a0,a0,-1158 # 80e0 <malloc+0x2094>
    556e:	00001097          	auipc	ra,0x1
    5572:	a26080e7          	jalr	-1498(ra) # 5f94 <printf>
  if ((pid = fork()) < 0) {
    5576:	00000097          	auipc	ra,0x0
    557a:	69c080e7          	jalr	1692(ra) # 5c12 <fork>
    557e:	02054e63          	bltz	a0,55ba <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if (pid == 0) {
    5582:	c929                	beqz	a0,55d4 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    5584:	fdc40513          	addi	a0,s0,-36
    5588:	00000097          	auipc	ra,0x0
    558c:	69a080e7          	jalr	1690(ra) # 5c22 <wait>
    if (xstatus != 0)
    5590:	fdc42783          	lw	a5,-36(s0)
    5594:	c7b9                	beqz	a5,55e2 <run+0x8c>
      printf("FAILED\n");
    5596:	00003517          	auipc	a0,0x3
    559a:	b7250513          	addi	a0,a0,-1166 # 8108 <malloc+0x20bc>
    559e:	00001097          	auipc	ra,0x1
    55a2:	9f6080e7          	jalr	-1546(ra) # 5f94 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    55a6:	fdc42503          	lw	a0,-36(s0)
  }
}
    55aa:	00153513          	seqz	a0,a0
    55ae:	70a2                	ld	ra,40(sp)
    55b0:	7402                	ld	s0,32(sp)
    55b2:	64e2                	ld	s1,24(sp)
    55b4:	6942                	ld	s2,16(sp)
    55b6:	6145                	addi	sp,sp,48
    55b8:	8082                	ret
    printf("runtest: fork error\n");
    55ba:	00003517          	auipc	a0,0x3
    55be:	b3650513          	addi	a0,a0,-1226 # 80f0 <malloc+0x20a4>
    55c2:	00001097          	auipc	ra,0x1
    55c6:	9d2080e7          	jalr	-1582(ra) # 5f94 <printf>
    exit(1);
    55ca:	4505                	li	a0,1
    55cc:	00000097          	auipc	ra,0x0
    55d0:	64e080e7          	jalr	1614(ra) # 5c1a <exit>
    f(s);
    55d4:	854a                	mv	a0,s2
    55d6:	9482                	jalr	s1
    exit(0);
    55d8:	4501                	li	a0,0
    55da:	00000097          	auipc	ra,0x0
    55de:	640080e7          	jalr	1600(ra) # 5c1a <exit>
      printf("OK\n");
    55e2:	00003517          	auipc	a0,0x3
    55e6:	b2e50513          	addi	a0,a0,-1234 # 8110 <malloc+0x20c4>
    55ea:	00001097          	auipc	ra,0x1
    55ee:	9aa080e7          	jalr	-1622(ra) # 5f94 <printf>
    55f2:	bf55                	j	55a6 <run+0x50>

00000000000055f4 <runtests>:

int runtests(struct test *tests, char *justone, int continuous) {
    55f4:	7179                	addi	sp,sp,-48
    55f6:	f406                	sd	ra,40(sp)
    55f8:	f022                	sd	s0,32(sp)
    55fa:	ec26                	sd	s1,24(sp)
    55fc:	e84a                	sd	s2,16(sp)
    55fe:	e44e                	sd	s3,8(sp)
    5600:	e052                	sd	s4,0(sp)
    5602:	1800                	addi	s0,sp,48
    5604:	84aa                	mv	s1,a0
  for (struct test *t = tests; t->s != 0; t++) {
    5606:	6508                	ld	a0,8(a0)
    5608:	c931                	beqz	a0,565c <runtests+0x68>
    560a:	892e                	mv	s2,a1
    560c:	89b2                	mv	s3,a2
    if ((justone == 0) || strcmp(t->s, justone) == 0) {
      if (!run(t->f, t->s)) {
        if (continuous != 2) {
    560e:	4a09                	li	s4,2
    5610:	a021                	j	5618 <runtests+0x24>
  for (struct test *t = tests; t->s != 0; t++) {
    5612:	04c1                	addi	s1,s1,16
    5614:	6488                	ld	a0,8(s1)
    5616:	c91d                	beqz	a0,564c <runtests+0x58>
    if ((justone == 0) || strcmp(t->s, justone) == 0) {
    5618:	00090863          	beqz	s2,5628 <runtests+0x34>
    561c:	85ca                	mv	a1,s2
    561e:	00000097          	auipc	ra,0x0
    5622:	3ac080e7          	jalr	940(ra) # 59ca <strcmp>
    5626:	f575                	bnez	a0,5612 <runtests+0x1e>
      if (!run(t->f, t->s)) {
    5628:	648c                	ld	a1,8(s1)
    562a:	6088                	ld	a0,0(s1)
    562c:	00000097          	auipc	ra,0x0
    5630:	f2a080e7          	jalr	-214(ra) # 5556 <run>
    5634:	fd79                	bnez	a0,5612 <runtests+0x1e>
        if (continuous != 2) {
    5636:	fd498ee3          	beq	s3,s4,5612 <runtests+0x1e>
          printf("SOME TESTS FAILED\n");
    563a:	00003517          	auipc	a0,0x3
    563e:	ade50513          	addi	a0,a0,-1314 # 8118 <malloc+0x20cc>
    5642:	00001097          	auipc	ra,0x1
    5646:	952080e7          	jalr	-1710(ra) # 5f94 <printf>
          return 1;
    564a:	4505                	li	a0,1
        }
      }
    }
  }
  return 0;
}
    564c:	70a2                	ld	ra,40(sp)
    564e:	7402                	ld	s0,32(sp)
    5650:	64e2                	ld	s1,24(sp)
    5652:	6942                	ld	s2,16(sp)
    5654:	69a2                	ld	s3,8(sp)
    5656:	6a02                	ld	s4,0(sp)
    5658:	6145                	addi	sp,sp,48
    565a:	8082                	ret
  return 0;
    565c:	4501                	li	a0,0
    565e:	b7fd                	j	564c <runtests+0x58>

0000000000005660 <countfree>:
// use sbrk() to count how many free physical memory pages there are.
// touches the pages to force allocation.
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int countfree() {
    5660:	7139                	addi	sp,sp,-64
    5662:	fc06                	sd	ra,56(sp)
    5664:	f822                	sd	s0,48(sp)
    5666:	f426                	sd	s1,40(sp)
    5668:	f04a                	sd	s2,32(sp)
    566a:	ec4e                	sd	s3,24(sp)
    566c:	0080                	addi	s0,sp,64
  int fds[2];

  if (pipe(fds) < 0) {
    566e:	fc840513          	addi	a0,s0,-56
    5672:	00000097          	auipc	ra,0x0
    5676:	5b8080e7          	jalr	1464(ra) # 5c2a <pipe>
    567a:	06054763          	bltz	a0,56e8 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }

  int pid = fork();
    567e:	00000097          	auipc	ra,0x0
    5682:	594080e7          	jalr	1428(ra) # 5c12 <fork>

  if (pid < 0) {
    5686:	06054e63          	bltz	a0,5702 <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if (pid == 0) {
    568a:	ed51                	bnez	a0,5726 <countfree+0xc6>
    close(fds[0]);
    568c:	fc842503          	lw	a0,-56(s0)
    5690:	00000097          	auipc	ra,0x0
    5694:	5b2080e7          	jalr	1458(ra) # 5c42 <close>

    while (1) {
      uint64 a = (uint64)sbrk(4096);
      if (a == 0xffffffffffffffff) {
    5698:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    569a:	4485                	li	s1,1

      // report back one more page.
      if (write(fds[1], "x", 1) != 1) {
    569c:	00001997          	auipc	s3,0x1
    56a0:	b4c98993          	addi	s3,s3,-1204 # 61e8 <malloc+0x19c>
      uint64 a = (uint64)sbrk(4096);
    56a4:	6505                	lui	a0,0x1
    56a6:	00000097          	auipc	ra,0x0
    56aa:	5fc080e7          	jalr	1532(ra) # 5ca2 <sbrk>
      if (a == 0xffffffffffffffff) {
    56ae:	07250763          	beq	a0,s2,571c <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    56b2:	6785                	lui	a5,0x1
    56b4:	97aa                	add	a5,a5,a0
    56b6:	fe978fa3          	sb	s1,-1(a5) # fff <linktest+0x103>
      if (write(fds[1], "x", 1) != 1) {
    56ba:	8626                	mv	a2,s1
    56bc:	85ce                	mv	a1,s3
    56be:	fcc42503          	lw	a0,-52(s0)
    56c2:	00000097          	auipc	ra,0x0
    56c6:	578080e7          	jalr	1400(ra) # 5c3a <write>
    56ca:	fc950de3          	beq	a0,s1,56a4 <countfree+0x44>
        printf("write() failed in countfree()\n");
    56ce:	00003517          	auipc	a0,0x3
    56d2:	aa250513          	addi	a0,a0,-1374 # 8170 <malloc+0x2124>
    56d6:	00001097          	auipc	ra,0x1
    56da:	8be080e7          	jalr	-1858(ra) # 5f94 <printf>
        exit(1);
    56de:	4505                	li	a0,1
    56e0:	00000097          	auipc	ra,0x0
    56e4:	53a080e7          	jalr	1338(ra) # 5c1a <exit>
    printf("pipe() failed in countfree()\n");
    56e8:	00003517          	auipc	a0,0x3
    56ec:	a4850513          	addi	a0,a0,-1464 # 8130 <malloc+0x20e4>
    56f0:	00001097          	auipc	ra,0x1
    56f4:	8a4080e7          	jalr	-1884(ra) # 5f94 <printf>
    exit(1);
    56f8:	4505                	li	a0,1
    56fa:	00000097          	auipc	ra,0x0
    56fe:	520080e7          	jalr	1312(ra) # 5c1a <exit>
    printf("fork failed in countfree()\n");
    5702:	00003517          	auipc	a0,0x3
    5706:	a4e50513          	addi	a0,a0,-1458 # 8150 <malloc+0x2104>
    570a:	00001097          	auipc	ra,0x1
    570e:	88a080e7          	jalr	-1910(ra) # 5f94 <printf>
    exit(1);
    5712:	4505                	li	a0,1
    5714:	00000097          	auipc	ra,0x0
    5718:	506080e7          	jalr	1286(ra) # 5c1a <exit>
      }
    }

    exit(0);
    571c:	4501                	li	a0,0
    571e:	00000097          	auipc	ra,0x0
    5722:	4fc080e7          	jalr	1276(ra) # 5c1a <exit>
  }

  close(fds[1]);
    5726:	fcc42503          	lw	a0,-52(s0)
    572a:	00000097          	auipc	ra,0x0
    572e:	518080e7          	jalr	1304(ra) # 5c42 <close>

  int n = 0;
    5732:	4481                	li	s1,0
  while (1) {
    char c;
    int cc = read(fds[0], &c, 1);
    5734:	4605                	li	a2,1
    5736:	fc740593          	addi	a1,s0,-57
    573a:	fc842503          	lw	a0,-56(s0)
    573e:	00000097          	auipc	ra,0x0
    5742:	4f4080e7          	jalr	1268(ra) # 5c32 <read>
    if (cc < 0) {
    5746:	00054563          	bltz	a0,5750 <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if (cc == 0) break;
    574a:	c105                	beqz	a0,576a <countfree+0x10a>
    n += 1;
    574c:	2485                	addiw	s1,s1,1
  while (1) {
    574e:	b7dd                	j	5734 <countfree+0xd4>
      printf("read() failed in countfree()\n");
    5750:	00003517          	auipc	a0,0x3
    5754:	a4050513          	addi	a0,a0,-1472 # 8190 <malloc+0x2144>
    5758:	00001097          	auipc	ra,0x1
    575c:	83c080e7          	jalr	-1988(ra) # 5f94 <printf>
      exit(1);
    5760:	4505                	li	a0,1
    5762:	00000097          	auipc	ra,0x0
    5766:	4b8080e7          	jalr	1208(ra) # 5c1a <exit>
  }

  close(fds[0]);
    576a:	fc842503          	lw	a0,-56(s0)
    576e:	00000097          	auipc	ra,0x0
    5772:	4d4080e7          	jalr	1236(ra) # 5c42 <close>
  wait((int *)0);
    5776:	4501                	li	a0,0
    5778:	00000097          	auipc	ra,0x0
    577c:	4aa080e7          	jalr	1194(ra) # 5c22 <wait>

  return n;
}
    5780:	8526                	mv	a0,s1
    5782:	70e2                	ld	ra,56(sp)
    5784:	7442                	ld	s0,48(sp)
    5786:	74a2                	ld	s1,40(sp)
    5788:	7902                	ld	s2,32(sp)
    578a:	69e2                	ld	s3,24(sp)
    578c:	6121                	addi	sp,sp,64
    578e:	8082                	ret

0000000000005790 <drivetests>:

int drivetests(int mode, int continuous, char *justone) {
    5790:	711d                	addi	sp,sp,-96
    5792:	ec86                	sd	ra,88(sp)
    5794:	e8a2                	sd	s0,80(sp)
    5796:	e4a6                	sd	s1,72(sp)
    5798:	e0ca                	sd	s2,64(sp)
    579a:	fc4e                	sd	s3,56(sp)
    579c:	f852                	sd	s4,48(sp)
    579e:	f456                	sd	s5,40(sp)
    57a0:	f05a                	sd	s6,32(sp)
    57a2:	ec5e                	sd	s7,24(sp)
    57a4:	e862                	sd	s8,16(sp)
    57a6:	e466                	sd	s9,8(sp)
    57a8:	e06a                	sd	s10,0(sp)
    57aa:	1080                	addi	s0,sp,96
    57ac:	892e                	mv	s2,a1
    57ae:	89b2                	mv	s3,a2
  do {
    printf("usertests starting\n");
    57b0:	00003b17          	auipc	s6,0x3
    57b4:	a00b0b13          	addi	s6,s6,-1536 # 81b0 <malloc+0x2164>
    int free0 = countfree();
    int free1 = 0;
    if ((mode & 1) == 1) {
    57b8:	00157a93          	andi	s5,a0,1
      if (runtests(quicktests, justone, continuous)) {
    57bc:	00004c97          	auipc	s9,0x4
    57c0:	854c8c93          	addi	s9,s9,-1964 # 9010 <quicktests>
        if (continuous != 2) {
    57c4:	4b89                	li	s7,2
          return 1;
        }
      }
    }
    if ((mode & 2) == 2) {
    57c6:	00257a13          	andi	s4,a0,2
          return 1;
        }
      }
    }
    if ((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    57ca:	00003d17          	auipc	s10,0x3
    57ce:	a1ed0d13          	addi	s10,s10,-1506 # 81e8 <malloc+0x219c>
      if (runtests(slowtests, justone, continuous)) {
    57d2:	00004c17          	auipc	s8,0x4
    57d6:	c0ec0c13          	addi	s8,s8,-1010 # 93e0 <slowtests>
    57da:	a835                	j	5816 <drivetests+0x86>
      if (runtests(quicktests, justone, continuous)) {
    57dc:	864a                	mv	a2,s2
    57de:	85ce                	mv	a1,s3
    57e0:	8566                	mv	a0,s9
    57e2:	00000097          	auipc	ra,0x0
    57e6:	e12080e7          	jalr	-494(ra) # 55f4 <runtests>
    57ea:	c131                	beqz	a0,582e <drivetests+0x9e>
        if (continuous != 2) {
    57ec:	05790163          	beq	s2,s7,582e <drivetests+0x9e>
          return 1;
    57f0:	8956                	mv	s2,s5
    57f2:	a071                	j	587e <drivetests+0xee>
      if (justone == 0) printf("usertests slow tests starting\n");
    57f4:	00003517          	auipc	a0,0x3
    57f8:	9d450513          	addi	a0,a0,-1580 # 81c8 <malloc+0x217c>
    57fc:	00000097          	auipc	ra,0x0
    5800:	798080e7          	jalr	1944(ra) # 5f94 <printf>
    5804:	a80d                	j	5836 <drivetests+0xa6>
    if ((free1 = countfree()) < free0) {
    5806:	00000097          	auipc	ra,0x0
    580a:	e5a080e7          	jalr	-422(ra) # 5660 <countfree>
    580e:	04954c63          	blt	a0,s1,5866 <drivetests+0xd6>
      if (continuous != 2) {
        return 1;
      }
    }
  } while (continuous);
    5812:	06090663          	beqz	s2,587e <drivetests+0xee>
    printf("usertests starting\n");
    5816:	855a                	mv	a0,s6
    5818:	00000097          	auipc	ra,0x0
    581c:	77c080e7          	jalr	1916(ra) # 5f94 <printf>
    int free0 = countfree();
    5820:	00000097          	auipc	ra,0x0
    5824:	e40080e7          	jalr	-448(ra) # 5660 <countfree>
    5828:	84aa                	mv	s1,a0
    if ((mode & 1) == 1) {
    582a:	fa0a99e3          	bnez	s5,57dc <drivetests+0x4c>
    if ((mode & 2) == 2) {
    582e:	fc0a0ce3          	beqz	s4,5806 <drivetests+0x76>
      if (justone == 0) printf("usertests slow tests starting\n");
    5832:	fc0981e3          	beqz	s3,57f4 <drivetests+0x64>
      if (runtests(slowtests, justone, continuous)) {
    5836:	864a                	mv	a2,s2
    5838:	85ce                	mv	a1,s3
    583a:	8562                	mv	a0,s8
    583c:	00000097          	auipc	ra,0x0
    5840:	db8080e7          	jalr	-584(ra) # 55f4 <runtests>
    5844:	d169                	beqz	a0,5806 <drivetests+0x76>
        if (continuous != 2) {
    5846:	03791b63          	bne	s2,s7,587c <drivetests+0xec>
    if ((free1 = countfree()) < free0) {
    584a:	00000097          	auipc	ra,0x0
    584e:	e16080e7          	jalr	-490(ra) # 5660 <countfree>
    5852:	fc9550e3          	bge	a0,s1,5812 <drivetests+0x82>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5856:	8626                	mv	a2,s1
    5858:	85aa                	mv	a1,a0
    585a:	856a                	mv	a0,s10
    585c:	00000097          	auipc	ra,0x0
    5860:	738080e7          	jalr	1848(ra) # 5f94 <printf>
      if (continuous != 2) {
    5864:	bf4d                	j	5816 <drivetests+0x86>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5866:	8626                	mv	a2,s1
    5868:	85aa                	mv	a1,a0
    586a:	856a                	mv	a0,s10
    586c:	00000097          	auipc	ra,0x0
    5870:	728080e7          	jalr	1832(ra) # 5f94 <printf>
      if (continuous != 2) {
    5874:	fb7901e3          	beq	s2,s7,5816 <drivetests+0x86>
        return 1;
    5878:	4905                	li	s2,1
    587a:	a011                	j	587e <drivetests+0xee>
          return 1;
    587c:	4905                	li	s2,1
  return 0;
}
    587e:	854a                	mv	a0,s2
    5880:	60e6                	ld	ra,88(sp)
    5882:	6446                	ld	s0,80(sp)
    5884:	64a6                	ld	s1,72(sp)
    5886:	6906                	ld	s2,64(sp)
    5888:	79e2                	ld	s3,56(sp)
    588a:	7a42                	ld	s4,48(sp)
    588c:	7aa2                	ld	s5,40(sp)
    588e:	7b02                	ld	s6,32(sp)
    5890:	6be2                	ld	s7,24(sp)
    5892:	6c42                	ld	s8,16(sp)
    5894:	6ca2                	ld	s9,8(sp)
    5896:	6d02                	ld	s10,0(sp)
    5898:	6125                	addi	sp,sp,96
    589a:	8082                	ret

000000000000589c <main>:

int main(int argc, char *argv[]) {
    589c:	1101                	addi	sp,sp,-32
    589e:	ec06                	sd	ra,24(sp)
    58a0:	e822                	sd	s0,16(sp)
    58a2:	e426                	sd	s1,8(sp)
    58a4:	e04a                	sd	s2,0(sp)
    58a6:	1000                	addi	s0,sp,32
    58a8:	84aa                	mv	s1,a0
  int continuous = 0;
  int mode = 3;
  char *justone = 0;

  if (argc == 2 && strcmp(argv[1], "-q") == 0) {
    58aa:	4789                	li	a5,2
    58ac:	02f50363          	beq	a0,a5,58d2 <main+0x36>
    continuous = 2;
  } else if (argc == 2 && strcmp(argv[1], "-s") == 0) {
    mode = 2;
  } else if (argc == 2 && argv[1][0] != '-') {
    justone = argv[1];
  } else if (argc > 1) {
    58b0:	4785                	li	a5,1
    58b2:	08a7ca63          	blt	a5,a0,5946 <main+0xaa>
  char *justone = 0;
    58b6:	4601                	li	a2,0
  int mode = 3;
    58b8:	448d                	li	s1,3
  int continuous = 0;
    58ba:	4581                	li	a1,0
    printf("Usage: usertests [-c | -C | -q | -s] [testname]\n");
    exit(1);
  }
  if (drivetests(mode, continuous, justone)) {
    58bc:	8526                	mv	a0,s1
    58be:	00000097          	auipc	ra,0x0
    58c2:	ed2080e7          	jalr	-302(ra) # 5790 <drivetests>
    58c6:	c955                	beqz	a0,597a <main+0xde>
    exit(1);
    58c8:	4505                	li	a0,1
    58ca:	00000097          	auipc	ra,0x0
    58ce:	350080e7          	jalr	848(ra) # 5c1a <exit>
    58d2:	892e                	mv	s2,a1
  if (argc == 2 && strcmp(argv[1], "-q") == 0) {
    58d4:	00003597          	auipc	a1,0x3
    58d8:	94458593          	addi	a1,a1,-1724 # 8218 <malloc+0x21cc>
    58dc:	00893503          	ld	a0,8(s2)
    58e0:	00000097          	auipc	ra,0x0
    58e4:	0ea080e7          	jalr	234(ra) # 59ca <strcmp>
    58e8:	85aa                	mv	a1,a0
    58ea:	c93d                	beqz	a0,5960 <main+0xc4>
  } else if (argc == 2 && strcmp(argv[1], "-c") == 0) {
    58ec:	00003597          	auipc	a1,0x3
    58f0:	99458593          	addi	a1,a1,-1644 # 8280 <malloc+0x2234>
    58f4:	00893503          	ld	a0,8(s2)
    58f8:	00000097          	auipc	ra,0x0
    58fc:	0d2080e7          	jalr	210(ra) # 59ca <strcmp>
    5900:	c92d                	beqz	a0,5972 <main+0xd6>
  } else if (argc == 2 && strcmp(argv[1], "-C") == 0) {
    5902:	00003597          	auipc	a1,0x3
    5906:	97658593          	addi	a1,a1,-1674 # 8278 <malloc+0x222c>
    590a:	00893503          	ld	a0,8(s2)
    590e:	00000097          	auipc	ra,0x0
    5912:	0bc080e7          	jalr	188(ra) # 59ca <strcmp>
    5916:	c931                	beqz	a0,596a <main+0xce>
  } else if (argc == 2 && strcmp(argv[1], "-s") == 0) {
    5918:	00003597          	auipc	a1,0x3
    591c:	95858593          	addi	a1,a1,-1704 # 8270 <malloc+0x2224>
    5920:	00893503          	ld	a0,8(s2)
    5924:	00000097          	auipc	ra,0x0
    5928:	0a6080e7          	jalr	166(ra) # 59ca <strcmp>
    592c:	85aa                	mv	a1,a0
    592e:	cd05                	beqz	a0,5966 <main+0xca>
  } else if (argc == 2 && argv[1][0] != '-') {
    5930:	00893603          	ld	a2,8(s2)
    5934:	00064703          	lbu	a4,0(a2) # 3000 <execout+0x9e>
    5938:	02d00793          	li	a5,45
    593c:	00f70563          	beq	a4,a5,5946 <main+0xaa>
  int mode = 3;
    5940:	448d                	li	s1,3
  int continuous = 0;
    5942:	4581                	li	a1,0
    5944:	bfa5                	j	58bc <main+0x20>
    printf("Usage: usertests [-c | -C | -q | -s] [testname]\n");
    5946:	00003517          	auipc	a0,0x3
    594a:	8da50513          	addi	a0,a0,-1830 # 8220 <malloc+0x21d4>
    594e:	00000097          	auipc	ra,0x0
    5952:	646080e7          	jalr	1606(ra) # 5f94 <printf>
    exit(1);
    5956:	4505                	li	a0,1
    5958:	00000097          	auipc	ra,0x0
    595c:	2c2080e7          	jalr	706(ra) # 5c1a <exit>
  char *justone = 0;
    5960:	4601                	li	a2,0
    mode = 1;
    5962:	4485                	li	s1,1
    5964:	bfa1                	j	58bc <main+0x20>
  char *justone = 0;
    5966:	4601                	li	a2,0
    5968:	bf91                	j	58bc <main+0x20>
    continuous = 2;
    596a:	85a6                	mv	a1,s1
  char *justone = 0;
    596c:	4601                	li	a2,0
  int mode = 3;
    596e:	448d                	li	s1,3
    5970:	b7b1                	j	58bc <main+0x20>
  char *justone = 0;
    5972:	4601                	li	a2,0
  int mode = 3;
    5974:	448d                	li	s1,3
    continuous = 1;
    5976:	4585                	li	a1,1
    5978:	b791                	j	58bc <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    597a:	00003517          	auipc	a0,0x3
    597e:	8de50513          	addi	a0,a0,-1826 # 8258 <malloc+0x220c>
    5982:	00000097          	auipc	ra,0x0
    5986:	612080e7          	jalr	1554(ra) # 5f94 <printf>
  exit(0);
    598a:	4501                	li	a0,0
    598c:	00000097          	auipc	ra,0x0
    5990:	28e080e7          	jalr	654(ra) # 5c1a <exit>

0000000000005994 <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
    5994:	1141                	addi	sp,sp,-16
    5996:	e406                	sd	ra,8(sp)
    5998:	e022                	sd	s0,0(sp)
    599a:	0800                	addi	s0,sp,16
  extern int main();
  main();
    599c:	00000097          	auipc	ra,0x0
    59a0:	f00080e7          	jalr	-256(ra) # 589c <main>
  exit(0);
    59a4:	4501                	li	a0,0
    59a6:	00000097          	auipc	ra,0x0
    59aa:	274080e7          	jalr	628(ra) # 5c1a <exit>

00000000000059ae <strcpy>:
}

char *strcpy(char *s, const char *t) {
    59ae:	1141                	addi	sp,sp,-16
    59b0:	e422                	sd	s0,8(sp)
    59b2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0);
    59b4:	87aa                	mv	a5,a0
    59b6:	0585                	addi	a1,a1,1
    59b8:	0785                	addi	a5,a5,1
    59ba:	fff5c703          	lbu	a4,-1(a1)
    59be:	fee78fa3          	sb	a4,-1(a5)
    59c2:	fb75                	bnez	a4,59b6 <strcpy+0x8>
  return os;
}
    59c4:	6422                	ld	s0,8(sp)
    59c6:	0141                	addi	sp,sp,16
    59c8:	8082                	ret

00000000000059ca <strcmp>:

int strcmp(const char *p, const char *q) {
    59ca:	1141                	addi	sp,sp,-16
    59cc:	e422                	sd	s0,8(sp)
    59ce:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
    59d0:	00054783          	lbu	a5,0(a0)
    59d4:	cb91                	beqz	a5,59e8 <strcmp+0x1e>
    59d6:	0005c703          	lbu	a4,0(a1)
    59da:	00f71763          	bne	a4,a5,59e8 <strcmp+0x1e>
    59de:	0505                	addi	a0,a0,1
    59e0:	0585                	addi	a1,a1,1
    59e2:	00054783          	lbu	a5,0(a0)
    59e6:	fbe5                	bnez	a5,59d6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    59e8:	0005c503          	lbu	a0,0(a1)
}
    59ec:	40a7853b          	subw	a0,a5,a0
    59f0:	6422                	ld	s0,8(sp)
    59f2:	0141                	addi	sp,sp,16
    59f4:	8082                	ret

00000000000059f6 <strlen>:

uint strlen(const char *s) {
    59f6:	1141                	addi	sp,sp,-16
    59f8:	e422                	sd	s0,8(sp)
    59fa:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
    59fc:	00054783          	lbu	a5,0(a0)
    5a00:	cf91                	beqz	a5,5a1c <strlen+0x26>
    5a02:	0505                	addi	a0,a0,1
    5a04:	87aa                	mv	a5,a0
    5a06:	4685                	li	a3,1
    5a08:	9e89                	subw	a3,a3,a0
    5a0a:	00f6853b          	addw	a0,a3,a5
    5a0e:	0785                	addi	a5,a5,1
    5a10:	fff7c703          	lbu	a4,-1(a5)
    5a14:	fb7d                	bnez	a4,5a0a <strlen+0x14>
  return n;
}
    5a16:	6422                	ld	s0,8(sp)
    5a18:	0141                	addi	sp,sp,16
    5a1a:	8082                	ret
  for (n = 0; s[n]; n++);
    5a1c:	4501                	li	a0,0
    5a1e:	bfe5                	j	5a16 <strlen+0x20>

0000000000005a20 <memset>:

void *memset(void *dst, int c, uint n) {
    5a20:	1141                	addi	sp,sp,-16
    5a22:	e422                	sd	s0,8(sp)
    5a24:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    5a26:	ca19                	beqz	a2,5a3c <memset+0x1c>
    5a28:	87aa                	mv	a5,a0
    5a2a:	1602                	slli	a2,a2,0x20
    5a2c:	9201                	srli	a2,a2,0x20
    5a2e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    5a32:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    5a36:	0785                	addi	a5,a5,1
    5a38:	fee79de3          	bne	a5,a4,5a32 <memset+0x12>
  }
  return dst;
}
    5a3c:	6422                	ld	s0,8(sp)
    5a3e:	0141                	addi	sp,sp,16
    5a40:	8082                	ret

0000000000005a42 <strchr>:

char *strchr(const char *s, char c) {
    5a42:	1141                	addi	sp,sp,-16
    5a44:	e422                	sd	s0,8(sp)
    5a46:	0800                	addi	s0,sp,16
  for (; *s; s++)
    5a48:	00054783          	lbu	a5,0(a0)
    5a4c:	cb99                	beqz	a5,5a62 <strchr+0x20>
    if (*s == c) return (char *)s;
    5a4e:	00f58763          	beq	a1,a5,5a5c <strchr+0x1a>
  for (; *s; s++)
    5a52:	0505                	addi	a0,a0,1
    5a54:	00054783          	lbu	a5,0(a0)
    5a58:	fbfd                	bnez	a5,5a4e <strchr+0xc>
  return 0;
    5a5a:	4501                	li	a0,0
}
    5a5c:	6422                	ld	s0,8(sp)
    5a5e:	0141                	addi	sp,sp,16
    5a60:	8082                	ret
  return 0;
    5a62:	4501                	li	a0,0
    5a64:	bfe5                	j	5a5c <strchr+0x1a>

0000000000005a66 <gets>:

char *gets(char *buf, int max) {
    5a66:	711d                	addi	sp,sp,-96
    5a68:	ec86                	sd	ra,88(sp)
    5a6a:	e8a2                	sd	s0,80(sp)
    5a6c:	e4a6                	sd	s1,72(sp)
    5a6e:	e0ca                	sd	s2,64(sp)
    5a70:	fc4e                	sd	s3,56(sp)
    5a72:	f852                	sd	s4,48(sp)
    5a74:	f456                	sd	s5,40(sp)
    5a76:	f05a                	sd	s6,32(sp)
    5a78:	ec5e                	sd	s7,24(sp)
    5a7a:	1080                	addi	s0,sp,96
    5a7c:	8baa                	mv	s7,a0
    5a7e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
    5a80:	892a                	mv	s2,a0
    5a82:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
    5a84:	4aa9                	li	s5,10
    5a86:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
    5a88:	89a6                	mv	s3,s1
    5a8a:	2485                	addiw	s1,s1,1
    5a8c:	0344d863          	bge	s1,s4,5abc <gets+0x56>
    cc = read(0, &c, 1);
    5a90:	4605                	li	a2,1
    5a92:	faf40593          	addi	a1,s0,-81
    5a96:	4501                	li	a0,0
    5a98:	00000097          	auipc	ra,0x0
    5a9c:	19a080e7          	jalr	410(ra) # 5c32 <read>
    if (cc < 1) break;
    5aa0:	00a05e63          	blez	a0,5abc <gets+0x56>
    buf[i++] = c;
    5aa4:	faf44783          	lbu	a5,-81(s0)
    5aa8:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
    5aac:	01578763          	beq	a5,s5,5aba <gets+0x54>
    5ab0:	0905                	addi	s2,s2,1
    5ab2:	fd679be3          	bne	a5,s6,5a88 <gets+0x22>
  for (i = 0; i + 1 < max;) {
    5ab6:	89a6                	mv	s3,s1
    5ab8:	a011                	j	5abc <gets+0x56>
    5aba:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
    5abc:	99de                	add	s3,s3,s7
    5abe:	00098023          	sb	zero,0(s3)
  return buf;
}
    5ac2:	855e                	mv	a0,s7
    5ac4:	60e6                	ld	ra,88(sp)
    5ac6:	6446                	ld	s0,80(sp)
    5ac8:	64a6                	ld	s1,72(sp)
    5aca:	6906                	ld	s2,64(sp)
    5acc:	79e2                	ld	s3,56(sp)
    5ace:	7a42                	ld	s4,48(sp)
    5ad0:	7aa2                	ld	s5,40(sp)
    5ad2:	7b02                	ld	s6,32(sp)
    5ad4:	6be2                	ld	s7,24(sp)
    5ad6:	6125                	addi	sp,sp,96
    5ad8:	8082                	ret

0000000000005ada <stat>:

int stat(const char *n, struct stat *st) {
    5ada:	1101                	addi	sp,sp,-32
    5adc:	ec06                	sd	ra,24(sp)
    5ade:	e822                	sd	s0,16(sp)
    5ae0:	e426                	sd	s1,8(sp)
    5ae2:	e04a                	sd	s2,0(sp)
    5ae4:	1000                	addi	s0,sp,32
    5ae6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5ae8:	4581                	li	a1,0
    5aea:	00000097          	auipc	ra,0x0
    5aee:	170080e7          	jalr	368(ra) # 5c5a <open>
  if (fd < 0) return -1;
    5af2:	02054563          	bltz	a0,5b1c <stat+0x42>
    5af6:	84aa                	mv	s1,a0
  r = fstat(fd, st);
    5af8:	85ca                	mv	a1,s2
    5afa:	00000097          	auipc	ra,0x0
    5afe:	178080e7          	jalr	376(ra) # 5c72 <fstat>
    5b02:	892a                	mv	s2,a0
  close(fd);
    5b04:	8526                	mv	a0,s1
    5b06:	00000097          	auipc	ra,0x0
    5b0a:	13c080e7          	jalr	316(ra) # 5c42 <close>
  return r;
}
    5b0e:	854a                	mv	a0,s2
    5b10:	60e2                	ld	ra,24(sp)
    5b12:	6442                	ld	s0,16(sp)
    5b14:	64a2                	ld	s1,8(sp)
    5b16:	6902                	ld	s2,0(sp)
    5b18:	6105                	addi	sp,sp,32
    5b1a:	8082                	ret
  if (fd < 0) return -1;
    5b1c:	597d                	li	s2,-1
    5b1e:	bfc5                	j	5b0e <stat+0x34>

0000000000005b20 <atoi>:

int atoi(const char *s) {
    5b20:	1141                	addi	sp,sp,-16
    5b22:	e422                	sd	s0,8(sp)
    5b24:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
    5b26:	00054683          	lbu	a3,0(a0)
    5b2a:	fd06879b          	addiw	a5,a3,-48
    5b2e:	0ff7f793          	zext.b	a5,a5
    5b32:	4625                	li	a2,9
    5b34:	02f66863          	bltu	a2,a5,5b64 <atoi+0x44>
    5b38:	872a                	mv	a4,a0
  n = 0;
    5b3a:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
    5b3c:	0705                	addi	a4,a4,1
    5b3e:	0025179b          	slliw	a5,a0,0x2
    5b42:	9fa9                	addw	a5,a5,a0
    5b44:	0017979b          	slliw	a5,a5,0x1
    5b48:	9fb5                	addw	a5,a5,a3
    5b4a:	fd07851b          	addiw	a0,a5,-48
    5b4e:	00074683          	lbu	a3,0(a4)
    5b52:	fd06879b          	addiw	a5,a3,-48
    5b56:	0ff7f793          	zext.b	a5,a5
    5b5a:	fef671e3          	bgeu	a2,a5,5b3c <atoi+0x1c>
  return n;
}
    5b5e:	6422                	ld	s0,8(sp)
    5b60:	0141                	addi	sp,sp,16
    5b62:	8082                	ret
  n = 0;
    5b64:	4501                	li	a0,0
    5b66:	bfe5                	j	5b5e <atoi+0x3e>

0000000000005b68 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
    5b68:	1141                	addi	sp,sp,-16
    5b6a:	e422                	sd	s0,8(sp)
    5b6c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5b6e:	02b57463          	bgeu	a0,a1,5b96 <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
    5b72:	00c05f63          	blez	a2,5b90 <memmove+0x28>
    5b76:	1602                	slli	a2,a2,0x20
    5b78:	9201                	srli	a2,a2,0x20
    5b7a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5b7e:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
    5b80:	0585                	addi	a1,a1,1
    5b82:	0705                	addi	a4,a4,1
    5b84:	fff5c683          	lbu	a3,-1(a1)
    5b88:	fed70fa3          	sb	a3,-1(a4)
    5b8c:	fee79ae3          	bne	a5,a4,5b80 <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
    5b90:	6422                	ld	s0,8(sp)
    5b92:	0141                	addi	sp,sp,16
    5b94:	8082                	ret
    dst += n;
    5b96:	00c50733          	add	a4,a0,a2
    src += n;
    5b9a:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
    5b9c:	fec05ae3          	blez	a2,5b90 <memmove+0x28>
    5ba0:	fff6079b          	addiw	a5,a2,-1
    5ba4:	1782                	slli	a5,a5,0x20
    5ba6:	9381                	srli	a5,a5,0x20
    5ba8:	fff7c793          	not	a5,a5
    5bac:	97ba                	add	a5,a5,a4
    5bae:	15fd                	addi	a1,a1,-1
    5bb0:	177d                	addi	a4,a4,-1
    5bb2:	0005c683          	lbu	a3,0(a1)
    5bb6:	00d70023          	sb	a3,0(a4)
    5bba:	fee79ae3          	bne	a5,a4,5bae <memmove+0x46>
    5bbe:	bfc9                	j	5b90 <memmove+0x28>

0000000000005bc0 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
    5bc0:	1141                	addi	sp,sp,-16
    5bc2:	e422                	sd	s0,8(sp)
    5bc4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5bc6:	ca05                	beqz	a2,5bf6 <memcmp+0x36>
    5bc8:	fff6069b          	addiw	a3,a2,-1
    5bcc:	1682                	slli	a3,a3,0x20
    5bce:	9281                	srli	a3,a3,0x20
    5bd0:	0685                	addi	a3,a3,1
    5bd2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5bd4:	00054783          	lbu	a5,0(a0)
    5bd8:	0005c703          	lbu	a4,0(a1)
    5bdc:	00e79863          	bne	a5,a4,5bec <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5be0:	0505                	addi	a0,a0,1
    p2++;
    5be2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5be4:	fed518e3          	bne	a0,a3,5bd4 <memcmp+0x14>
  }
  return 0;
    5be8:	4501                	li	a0,0
    5bea:	a019                	j	5bf0 <memcmp+0x30>
      return *p1 - *p2;
    5bec:	40e7853b          	subw	a0,a5,a4
}
    5bf0:	6422                	ld	s0,8(sp)
    5bf2:	0141                	addi	sp,sp,16
    5bf4:	8082                	ret
  return 0;
    5bf6:	4501                	li	a0,0
    5bf8:	bfe5                	j	5bf0 <memcmp+0x30>

0000000000005bfa <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
    5bfa:	1141                	addi	sp,sp,-16
    5bfc:	e406                	sd	ra,8(sp)
    5bfe:	e022                	sd	s0,0(sp)
    5c00:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5c02:	00000097          	auipc	ra,0x0
    5c06:	f66080e7          	jalr	-154(ra) # 5b68 <memmove>
}
    5c0a:	60a2                	ld	ra,8(sp)
    5c0c:	6402                	ld	s0,0(sp)
    5c0e:	0141                	addi	sp,sp,16
    5c10:	8082                	ret

0000000000005c12 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5c12:	4885                	li	a7,1
 ecall
    5c14:	00000073          	ecall
 ret
    5c18:	8082                	ret

0000000000005c1a <exit>:
.global exit
exit:
 li a7, SYS_exit
    5c1a:	4889                	li	a7,2
 ecall
    5c1c:	00000073          	ecall
 ret
    5c20:	8082                	ret

0000000000005c22 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5c22:	488d                	li	a7,3
 ecall
    5c24:	00000073          	ecall
 ret
    5c28:	8082                	ret

0000000000005c2a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5c2a:	4891                	li	a7,4
 ecall
    5c2c:	00000073          	ecall
 ret
    5c30:	8082                	ret

0000000000005c32 <read>:
.global read
read:
 li a7, SYS_read
    5c32:	4895                	li	a7,5
 ecall
    5c34:	00000073          	ecall
 ret
    5c38:	8082                	ret

0000000000005c3a <write>:
.global write
write:
 li a7, SYS_write
    5c3a:	48c1                	li	a7,16
 ecall
    5c3c:	00000073          	ecall
 ret
    5c40:	8082                	ret

0000000000005c42 <close>:
.global close
close:
 li a7, SYS_close
    5c42:	48d5                	li	a7,21
 ecall
    5c44:	00000073          	ecall
 ret
    5c48:	8082                	ret

0000000000005c4a <kill>:
.global kill
kill:
 li a7, SYS_kill
    5c4a:	4899                	li	a7,6
 ecall
    5c4c:	00000073          	ecall
 ret
    5c50:	8082                	ret

0000000000005c52 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5c52:	489d                	li	a7,7
 ecall
    5c54:	00000073          	ecall
 ret
    5c58:	8082                	ret

0000000000005c5a <open>:
.global open
open:
 li a7, SYS_open
    5c5a:	48bd                	li	a7,15
 ecall
    5c5c:	00000073          	ecall
 ret
    5c60:	8082                	ret

0000000000005c62 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5c62:	48c5                	li	a7,17
 ecall
    5c64:	00000073          	ecall
 ret
    5c68:	8082                	ret

0000000000005c6a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5c6a:	48c9                	li	a7,18
 ecall
    5c6c:	00000073          	ecall
 ret
    5c70:	8082                	ret

0000000000005c72 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5c72:	48a1                	li	a7,8
 ecall
    5c74:	00000073          	ecall
 ret
    5c78:	8082                	ret

0000000000005c7a <link>:
.global link
link:
 li a7, SYS_link
    5c7a:	48cd                	li	a7,19
 ecall
    5c7c:	00000073          	ecall
 ret
    5c80:	8082                	ret

0000000000005c82 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5c82:	48d1                	li	a7,20
 ecall
    5c84:	00000073          	ecall
 ret
    5c88:	8082                	ret

0000000000005c8a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5c8a:	48a5                	li	a7,9
 ecall
    5c8c:	00000073          	ecall
 ret
    5c90:	8082                	ret

0000000000005c92 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5c92:	48a9                	li	a7,10
 ecall
    5c94:	00000073          	ecall
 ret
    5c98:	8082                	ret

0000000000005c9a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5c9a:	48ad                	li	a7,11
 ecall
    5c9c:	00000073          	ecall
 ret
    5ca0:	8082                	ret

0000000000005ca2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5ca2:	48b1                	li	a7,12
 ecall
    5ca4:	00000073          	ecall
 ret
    5ca8:	8082                	ret

0000000000005caa <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5caa:	48b5                	li	a7,13
 ecall
    5cac:	00000073          	ecall
 ret
    5cb0:	8082                	ret

0000000000005cb2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5cb2:	48b9                	li	a7,14
 ecall
    5cb4:	00000073          	ecall
 ret
    5cb8:	8082                	ret

0000000000005cba <putc>:
#include "kernel/types.h"
#include "user/user.h"

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
    5cba:	1101                	addi	sp,sp,-32
    5cbc:	ec06                	sd	ra,24(sp)
    5cbe:	e822                	sd	s0,16(sp)
    5cc0:	1000                	addi	s0,sp,32
    5cc2:	feb407a3          	sb	a1,-17(s0)
    5cc6:	4605                	li	a2,1
    5cc8:	fef40593          	addi	a1,s0,-17
    5ccc:	00000097          	auipc	ra,0x0
    5cd0:	f6e080e7          	jalr	-146(ra) # 5c3a <write>
    5cd4:	60e2                	ld	ra,24(sp)
    5cd6:	6442                	ld	s0,16(sp)
    5cd8:	6105                	addi	sp,sp,32
    5cda:	8082                	ret

0000000000005cdc <printint>:

static void printint(int fd, int xx, int base, int sgn) {
    5cdc:	7139                	addi	sp,sp,-64
    5cde:	fc06                	sd	ra,56(sp)
    5ce0:	f822                	sd	s0,48(sp)
    5ce2:	f426                	sd	s1,40(sp)
    5ce4:	f04a                	sd	s2,32(sp)
    5ce6:	ec4e                	sd	s3,24(sp)
    5ce8:	0080                	addi	s0,sp,64
    5cea:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
    5cec:	c299                	beqz	a3,5cf2 <printint+0x16>
    5cee:	0805c963          	bltz	a1,5d80 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5cf2:	2581                	sext.w	a1,a1
  neg = 0;
    5cf4:	4881                	li	a7,0
    5cf6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5cfa:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    5cfc:	2601                	sext.w	a2,a2
    5cfe:	00003517          	auipc	a0,0x3
    5d02:	94a50513          	addi	a0,a0,-1718 # 8648 <digits>
    5d06:	883a                	mv	a6,a4
    5d08:	2705                	addiw	a4,a4,1
    5d0a:	02c5f7bb          	remuw	a5,a1,a2
    5d0e:	1782                	slli	a5,a5,0x20
    5d10:	9381                	srli	a5,a5,0x20
    5d12:	97aa                	add	a5,a5,a0
    5d14:	0007c783          	lbu	a5,0(a5)
    5d18:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    5d1c:	0005879b          	sext.w	a5,a1
    5d20:	02c5d5bb          	divuw	a1,a1,a2
    5d24:	0685                	addi	a3,a3,1
    5d26:	fec7f0e3          	bgeu	a5,a2,5d06 <printint+0x2a>
  if (neg) buf[i++] = '-';
    5d2a:	00088c63          	beqz	a7,5d42 <printint+0x66>
    5d2e:	fd070793          	addi	a5,a4,-48
    5d32:	00878733          	add	a4,a5,s0
    5d36:	02d00793          	li	a5,45
    5d3a:	fef70823          	sb	a5,-16(a4)
    5d3e:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
    5d42:	02e05863          	blez	a4,5d72 <printint+0x96>
    5d46:	fc040793          	addi	a5,s0,-64
    5d4a:	00e78933          	add	s2,a5,a4
    5d4e:	fff78993          	addi	s3,a5,-1
    5d52:	99ba                	add	s3,s3,a4
    5d54:	377d                	addiw	a4,a4,-1
    5d56:	1702                	slli	a4,a4,0x20
    5d58:	9301                	srli	a4,a4,0x20
    5d5a:	40e989b3          	sub	s3,s3,a4
    5d5e:	fff94583          	lbu	a1,-1(s2)
    5d62:	8526                	mv	a0,s1
    5d64:	00000097          	auipc	ra,0x0
    5d68:	f56080e7          	jalr	-170(ra) # 5cba <putc>
    5d6c:	197d                	addi	s2,s2,-1
    5d6e:	ff3918e3          	bne	s2,s3,5d5e <printint+0x82>
}
    5d72:	70e2                	ld	ra,56(sp)
    5d74:	7442                	ld	s0,48(sp)
    5d76:	74a2                	ld	s1,40(sp)
    5d78:	7902                	ld	s2,32(sp)
    5d7a:	69e2                	ld	s3,24(sp)
    5d7c:	6121                	addi	sp,sp,64
    5d7e:	8082                	ret
    x = -xx;
    5d80:	40b005bb          	negw	a1,a1
    neg = 1;
    5d84:	4885                	li	a7,1
    x = -xx;
    5d86:	bf85                	j	5cf6 <printint+0x1a>

0000000000005d88 <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
    5d88:	7119                	addi	sp,sp,-128
    5d8a:	fc86                	sd	ra,120(sp)
    5d8c:	f8a2                	sd	s0,112(sp)
    5d8e:	f4a6                	sd	s1,104(sp)
    5d90:	f0ca                	sd	s2,96(sp)
    5d92:	ecce                	sd	s3,88(sp)
    5d94:	e8d2                	sd	s4,80(sp)
    5d96:	e4d6                	sd	s5,72(sp)
    5d98:	e0da                	sd	s6,64(sp)
    5d9a:	fc5e                	sd	s7,56(sp)
    5d9c:	f862                	sd	s8,48(sp)
    5d9e:	f466                	sd	s9,40(sp)
    5da0:	f06a                	sd	s10,32(sp)
    5da2:	ec6e                	sd	s11,24(sp)
    5da4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
    5da6:	0005c903          	lbu	s2,0(a1)
    5daa:	18090f63          	beqz	s2,5f48 <vprintf+0x1c0>
    5dae:	8aaa                	mv	s5,a0
    5db0:	8b32                	mv	s6,a2
    5db2:	00158493          	addi	s1,a1,1
  state = 0;
    5db6:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
    5db8:	02500a13          	li	s4,37
    5dbc:	4c55                	li	s8,21
    5dbe:	00003c97          	auipc	s9,0x3
    5dc2:	832c8c93          	addi	s9,s9,-1998 # 85f0 <malloc+0x25a4>
      } else if (c == 'p') {
        printptr(fd, va_arg(ap, uint64));
      } else if (c == 's') {
        s = va_arg(ap, char *);
        if (s == 0) s = "(null)";
        while (*s != 0) {
    5dc6:	02800d93          	li	s11,40
  putc(fd, 'x');
    5dca:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5dcc:	00003b97          	auipc	s7,0x3
    5dd0:	87cb8b93          	addi	s7,s7,-1924 # 8648 <digits>
    5dd4:	a839                	j	5df2 <vprintf+0x6a>
        putc(fd, c);
    5dd6:	85ca                	mv	a1,s2
    5dd8:	8556                	mv	a0,s5
    5dda:	00000097          	auipc	ra,0x0
    5dde:	ee0080e7          	jalr	-288(ra) # 5cba <putc>
    5de2:	a019                	j	5de8 <vprintf+0x60>
    } else if (state == '%') {
    5de4:	01498d63          	beq	s3,s4,5dfe <vprintf+0x76>
  for (i = 0; fmt[i]; i++) {
    5de8:	0485                	addi	s1,s1,1
    5dea:	fff4c903          	lbu	s2,-1(s1)
    5dee:	14090d63          	beqz	s2,5f48 <vprintf+0x1c0>
    if (state == 0) {
    5df2:	fe0999e3          	bnez	s3,5de4 <vprintf+0x5c>
      if (c == '%') {
    5df6:	ff4910e3          	bne	s2,s4,5dd6 <vprintf+0x4e>
        state = '%';
    5dfa:	89d2                	mv	s3,s4
    5dfc:	b7f5                	j	5de8 <vprintf+0x60>
      if (c == 'd') {
    5dfe:	11490c63          	beq	s2,s4,5f16 <vprintf+0x18e>
    5e02:	f9d9079b          	addiw	a5,s2,-99
    5e06:	0ff7f793          	zext.b	a5,a5
    5e0a:	10fc6e63          	bltu	s8,a5,5f26 <vprintf+0x19e>
    5e0e:	f9d9079b          	addiw	a5,s2,-99
    5e12:	0ff7f713          	zext.b	a4,a5
    5e16:	10ec6863          	bltu	s8,a4,5f26 <vprintf+0x19e>
    5e1a:	00271793          	slli	a5,a4,0x2
    5e1e:	97e6                	add	a5,a5,s9
    5e20:	439c                	lw	a5,0(a5)
    5e22:	97e6                	add	a5,a5,s9
    5e24:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    5e26:	008b0913          	addi	s2,s6,8
    5e2a:	4685                	li	a3,1
    5e2c:	4629                	li	a2,10
    5e2e:	000b2583          	lw	a1,0(s6)
    5e32:	8556                	mv	a0,s5
    5e34:	00000097          	auipc	ra,0x0
    5e38:	ea8080e7          	jalr	-344(ra) # 5cdc <printint>
    5e3c:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    5e3e:	4981                	li	s3,0
    5e40:	b765                	j	5de8 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5e42:	008b0913          	addi	s2,s6,8
    5e46:	4681                	li	a3,0
    5e48:	4629                	li	a2,10
    5e4a:	000b2583          	lw	a1,0(s6)
    5e4e:	8556                	mv	a0,s5
    5e50:	00000097          	auipc	ra,0x0
    5e54:	e8c080e7          	jalr	-372(ra) # 5cdc <printint>
    5e58:	8b4a                	mv	s6,s2
      state = 0;
    5e5a:	4981                	li	s3,0
    5e5c:	b771                	j	5de8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5e5e:	008b0913          	addi	s2,s6,8
    5e62:	4681                	li	a3,0
    5e64:	866a                	mv	a2,s10
    5e66:	000b2583          	lw	a1,0(s6)
    5e6a:	8556                	mv	a0,s5
    5e6c:	00000097          	auipc	ra,0x0
    5e70:	e70080e7          	jalr	-400(ra) # 5cdc <printint>
    5e74:	8b4a                	mv	s6,s2
      state = 0;
    5e76:	4981                	li	s3,0
    5e78:	bf85                	j	5de8 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5e7a:	008b0793          	addi	a5,s6,8
    5e7e:	f8f43423          	sd	a5,-120(s0)
    5e82:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5e86:	03000593          	li	a1,48
    5e8a:	8556                	mv	a0,s5
    5e8c:	00000097          	auipc	ra,0x0
    5e90:	e2e080e7          	jalr	-466(ra) # 5cba <putc>
  putc(fd, 'x');
    5e94:	07800593          	li	a1,120
    5e98:	8556                	mv	a0,s5
    5e9a:	00000097          	auipc	ra,0x0
    5e9e:	e20080e7          	jalr	-480(ra) # 5cba <putc>
    5ea2:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5ea4:	03c9d793          	srli	a5,s3,0x3c
    5ea8:	97de                	add	a5,a5,s7
    5eaa:	0007c583          	lbu	a1,0(a5)
    5eae:	8556                	mv	a0,s5
    5eb0:	00000097          	auipc	ra,0x0
    5eb4:	e0a080e7          	jalr	-502(ra) # 5cba <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5eb8:	0992                	slli	s3,s3,0x4
    5eba:	397d                	addiw	s2,s2,-1
    5ebc:	fe0914e3          	bnez	s2,5ea4 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
    5ec0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5ec4:	4981                	li	s3,0
    5ec6:	b70d                	j	5de8 <vprintf+0x60>
        s = va_arg(ap, char *);
    5ec8:	008b0913          	addi	s2,s6,8
    5ecc:	000b3983          	ld	s3,0(s6)
        if (s == 0) s = "(null)";
    5ed0:	02098163          	beqz	s3,5ef2 <vprintf+0x16a>
        while (*s != 0) {
    5ed4:	0009c583          	lbu	a1,0(s3)
    5ed8:	c5ad                	beqz	a1,5f42 <vprintf+0x1ba>
          putc(fd, *s);
    5eda:	8556                	mv	a0,s5
    5edc:	00000097          	auipc	ra,0x0
    5ee0:	dde080e7          	jalr	-546(ra) # 5cba <putc>
          s++;
    5ee4:	0985                	addi	s3,s3,1
        while (*s != 0) {
    5ee6:	0009c583          	lbu	a1,0(s3)
    5eea:	f9e5                	bnez	a1,5eda <vprintf+0x152>
        s = va_arg(ap, char *);
    5eec:	8b4a                	mv	s6,s2
      state = 0;
    5eee:	4981                	li	s3,0
    5ef0:	bde5                	j	5de8 <vprintf+0x60>
        if (s == 0) s = "(null)";
    5ef2:	00002997          	auipc	s3,0x2
    5ef6:	6f698993          	addi	s3,s3,1782 # 85e8 <malloc+0x259c>
        while (*s != 0) {
    5efa:	85ee                	mv	a1,s11
    5efc:	bff9                	j	5eda <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
    5efe:	008b0913          	addi	s2,s6,8
    5f02:	000b4583          	lbu	a1,0(s6)
    5f06:	8556                	mv	a0,s5
    5f08:	00000097          	auipc	ra,0x0
    5f0c:	db2080e7          	jalr	-590(ra) # 5cba <putc>
    5f10:	8b4a                	mv	s6,s2
      state = 0;
    5f12:	4981                	li	s3,0
    5f14:	bdd1                	j	5de8 <vprintf+0x60>
        putc(fd, c);
    5f16:	85d2                	mv	a1,s4
    5f18:	8556                	mv	a0,s5
    5f1a:	00000097          	auipc	ra,0x0
    5f1e:	da0080e7          	jalr	-608(ra) # 5cba <putc>
      state = 0;
    5f22:	4981                	li	s3,0
    5f24:	b5d1                	j	5de8 <vprintf+0x60>
        putc(fd, '%');
    5f26:	85d2                	mv	a1,s4
    5f28:	8556                	mv	a0,s5
    5f2a:	00000097          	auipc	ra,0x0
    5f2e:	d90080e7          	jalr	-624(ra) # 5cba <putc>
        putc(fd, c);
    5f32:	85ca                	mv	a1,s2
    5f34:	8556                	mv	a0,s5
    5f36:	00000097          	auipc	ra,0x0
    5f3a:	d84080e7          	jalr	-636(ra) # 5cba <putc>
      state = 0;
    5f3e:	4981                	li	s3,0
    5f40:	b565                	j	5de8 <vprintf+0x60>
        s = va_arg(ap, char *);
    5f42:	8b4a                	mv	s6,s2
      state = 0;
    5f44:	4981                	li	s3,0
    5f46:	b54d                	j	5de8 <vprintf+0x60>
    }
  }
}
    5f48:	70e6                	ld	ra,120(sp)
    5f4a:	7446                	ld	s0,112(sp)
    5f4c:	74a6                	ld	s1,104(sp)
    5f4e:	7906                	ld	s2,96(sp)
    5f50:	69e6                	ld	s3,88(sp)
    5f52:	6a46                	ld	s4,80(sp)
    5f54:	6aa6                	ld	s5,72(sp)
    5f56:	6b06                	ld	s6,64(sp)
    5f58:	7be2                	ld	s7,56(sp)
    5f5a:	7c42                	ld	s8,48(sp)
    5f5c:	7ca2                	ld	s9,40(sp)
    5f5e:	7d02                	ld	s10,32(sp)
    5f60:	6de2                	ld	s11,24(sp)
    5f62:	6109                	addi	sp,sp,128
    5f64:	8082                	ret

0000000000005f66 <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
    5f66:	715d                	addi	sp,sp,-80
    5f68:	ec06                	sd	ra,24(sp)
    5f6a:	e822                	sd	s0,16(sp)
    5f6c:	1000                	addi	s0,sp,32
    5f6e:	e010                	sd	a2,0(s0)
    5f70:	e414                	sd	a3,8(s0)
    5f72:	e818                	sd	a4,16(s0)
    5f74:	ec1c                	sd	a5,24(s0)
    5f76:	03043023          	sd	a6,32(s0)
    5f7a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5f7e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5f82:	8622                	mv	a2,s0
    5f84:	00000097          	auipc	ra,0x0
    5f88:	e04080e7          	jalr	-508(ra) # 5d88 <vprintf>
}
    5f8c:	60e2                	ld	ra,24(sp)
    5f8e:	6442                	ld	s0,16(sp)
    5f90:	6161                	addi	sp,sp,80
    5f92:	8082                	ret

0000000000005f94 <printf>:

void printf(const char *fmt, ...) {
    5f94:	711d                	addi	sp,sp,-96
    5f96:	ec06                	sd	ra,24(sp)
    5f98:	e822                	sd	s0,16(sp)
    5f9a:	1000                	addi	s0,sp,32
    5f9c:	e40c                	sd	a1,8(s0)
    5f9e:	e810                	sd	a2,16(s0)
    5fa0:	ec14                	sd	a3,24(s0)
    5fa2:	f018                	sd	a4,32(s0)
    5fa4:	f41c                	sd	a5,40(s0)
    5fa6:	03043823          	sd	a6,48(s0)
    5faa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5fae:	00840613          	addi	a2,s0,8
    5fb2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5fb6:	85aa                	mv	a1,a0
    5fb8:	4505                	li	a0,1
    5fba:	00000097          	auipc	ra,0x0
    5fbe:	dce080e7          	jalr	-562(ra) # 5d88 <vprintf>
}
    5fc2:	60e2                	ld	ra,24(sp)
    5fc4:	6442                	ld	s0,16(sp)
    5fc6:	6125                	addi	sp,sp,96
    5fc8:	8082                	ret

0000000000005fca <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
    5fca:	1141                	addi	sp,sp,-16
    5fcc:	e422                	sd	s0,8(sp)
    5fce:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
    5fd0:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5fd4:	00003797          	auipc	a5,0x3
    5fd8:	47c7b783          	ld	a5,1148(a5) # 9450 <freep>
    5fdc:	a02d                	j	6006 <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
    5fde:	4618                	lw	a4,8(a2)
    5fe0:	9f2d                	addw	a4,a4,a1
    5fe2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5fe6:	6398                	ld	a4,0(a5)
    5fe8:	6310                	ld	a2,0(a4)
    5fea:	a83d                	j	6028 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
    5fec:	ff852703          	lw	a4,-8(a0)
    5ff0:	9f31                	addw	a4,a4,a2
    5ff2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5ff4:	ff053683          	ld	a3,-16(a0)
    5ff8:	a091                	j	603c <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
    5ffa:	6398                	ld	a4,0(a5)
    5ffc:	00e7e463          	bltu	a5,a4,6004 <free+0x3a>
    6000:	00e6ea63          	bltu	a3,a4,6014 <free+0x4a>
void free(void *ap) {
    6004:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    6006:	fed7fae3          	bgeu	a5,a3,5ffa <free+0x30>
    600a:	6398                	ld	a4,0(a5)
    600c:	00e6e463          	bltu	a3,a4,6014 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
    6010:	fee7eae3          	bltu	a5,a4,6004 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
    6014:	ff852583          	lw	a1,-8(a0)
    6018:	6390                	ld	a2,0(a5)
    601a:	02059813          	slli	a6,a1,0x20
    601e:	01c85713          	srli	a4,a6,0x1c
    6022:	9736                	add	a4,a4,a3
    6024:	fae60de3          	beq	a2,a4,5fde <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    6028:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
    602c:	4790                	lw	a2,8(a5)
    602e:	02061593          	slli	a1,a2,0x20
    6032:	01c5d713          	srli	a4,a1,0x1c
    6036:	973e                	add	a4,a4,a5
    6038:	fae68ae3          	beq	a3,a4,5fec <free+0x22>
    p->s.ptr = bp->s.ptr;
    603c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    603e:	00003717          	auipc	a4,0x3
    6042:	40f73923          	sd	a5,1042(a4) # 9450 <freep>
}
    6046:	6422                	ld	s0,8(sp)
    6048:	0141                	addi	sp,sp,16
    604a:	8082                	ret

000000000000604c <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
    604c:	7139                	addi	sp,sp,-64
    604e:	fc06                	sd	ra,56(sp)
    6050:	f822                	sd	s0,48(sp)
    6052:	f426                	sd	s1,40(sp)
    6054:	f04a                	sd	s2,32(sp)
    6056:	ec4e                	sd	s3,24(sp)
    6058:	e852                	sd	s4,16(sp)
    605a:	e456                	sd	s5,8(sp)
    605c:	e05a                	sd	s6,0(sp)
    605e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    6060:	02051493          	slli	s1,a0,0x20
    6064:	9081                	srli	s1,s1,0x20
    6066:	04bd                	addi	s1,s1,15
    6068:	8091                	srli	s1,s1,0x4
    606a:	0014899b          	addiw	s3,s1,1
    606e:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
    6070:	00003517          	auipc	a0,0x3
    6074:	3e053503          	ld	a0,992(a0) # 9450 <freep>
    6078:	c515                	beqz	a0,60a4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    607a:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    607c:	4798                	lw	a4,8(a5)
    607e:	02977f63          	bgeu	a4,s1,60bc <malloc+0x70>
    6082:	8a4e                	mv	s4,s3
    6084:	0009871b          	sext.w	a4,s3
    6088:	6685                	lui	a3,0x1
    608a:	00d77363          	bgeu	a4,a3,6090 <malloc+0x44>
    608e:	6a05                	lui	s4,0x1
    6090:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    6094:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
    6098:	00003917          	auipc	s2,0x3
    609c:	3b890913          	addi	s2,s2,952 # 9450 <freep>
  if (p == (char *)-1) return 0;
    60a0:	5afd                	li	s5,-1
    60a2:	a895                	j	6116 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    60a4:	0000a797          	auipc	a5,0xa
    60a8:	bd478793          	addi	a5,a5,-1068 # fc78 <base>
    60ac:	00003717          	auipc	a4,0x3
    60b0:	3af73223          	sd	a5,932(a4) # 9450 <freep>
    60b4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    60b6:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
    60ba:	b7e1                	j	6082 <malloc+0x36>
      if (p->s.size == nunits)
    60bc:	02e48c63          	beq	s1,a4,60f4 <malloc+0xa8>
        p->s.size -= nunits;
    60c0:	4137073b          	subw	a4,a4,s3
    60c4:	c798                	sw	a4,8(a5)
        p += p->s.size;
    60c6:	02071693          	slli	a3,a4,0x20
    60ca:	01c6d713          	srli	a4,a3,0x1c
    60ce:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    60d0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    60d4:	00003717          	auipc	a4,0x3
    60d8:	36a73e23          	sd	a0,892(a4) # 9450 <freep>
      return (void *)(p + 1);
    60dc:	01078513          	addi	a0,a5,16
      if ((p = morecore(nunits)) == 0) return 0;
  }
}
    60e0:	70e2                	ld	ra,56(sp)
    60e2:	7442                	ld	s0,48(sp)
    60e4:	74a2                	ld	s1,40(sp)
    60e6:	7902                	ld	s2,32(sp)
    60e8:	69e2                	ld	s3,24(sp)
    60ea:	6a42                	ld	s4,16(sp)
    60ec:	6aa2                	ld	s5,8(sp)
    60ee:	6b02                	ld	s6,0(sp)
    60f0:	6121                	addi	sp,sp,64
    60f2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    60f4:	6398                	ld	a4,0(a5)
    60f6:	e118                	sd	a4,0(a0)
    60f8:	bff1                	j	60d4 <malloc+0x88>
  hp->s.size = nu;
    60fa:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
    60fe:	0541                	addi	a0,a0,16
    6100:	00000097          	auipc	ra,0x0
    6104:	eca080e7          	jalr	-310(ra) # 5fca <free>
  return freep;
    6108:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
    610c:	d971                	beqz	a0,60e0 <malloc+0x94>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    610e:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    6110:	4798                	lw	a4,8(a5)
    6112:	fa9775e3          	bgeu	a4,s1,60bc <malloc+0x70>
    if (p == freep)
    6116:	00093703          	ld	a4,0(s2)
    611a:	853e                	mv	a0,a5
    611c:	fef719e3          	bne	a4,a5,610e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    6120:	8552                	mv	a0,s4
    6122:	00000097          	auipc	ra,0x0
    6126:	b80080e7          	jalr	-1152(ra) # 5ca2 <sbrk>
  if (p == (char *)-1) return 0;
    612a:	fd5518e3          	bne	a0,s5,60fa <malloc+0xae>
      if ((p = morecore(nunits)) == 0) return 0;
    612e:	4501                	li	a0,0
    6130:	bf45                	j	60e0 <malloc+0x94>
