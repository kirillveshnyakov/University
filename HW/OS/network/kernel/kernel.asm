
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	9e013103          	ld	sp,-1568(sp) # 800099e0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	514060ef          	jal	ra,8000652a <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa) {
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	000f3797          	auipc	a5,0xf3
    80000034:	38078793          	addi	a5,a5,896 # 800f33b0 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run *)pa;

  acquire(&kmem.lock);
    80000050:	0000a917          	auipc	s2,0xa
    80000054:	a0090913          	addi	s2,s2,-1536 # 80009a50 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00007097          	auipc	ra,0x7
    8000005e:	ebc080e7          	jalr	-324(ra) # 80006f16 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00007097          	auipc	ra,0x7
    80000072:	f5c080e7          	jalr	-164(ra) # 80006fca <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00009517          	auipc	a0,0x9
    80000086:	f8e50513          	addi	a0,a0,-114 # 80009010 <etext+0x10>
    8000008a:	00007097          	auipc	ra,0x7
    8000008e:	954080e7          	jalr	-1708(ra) # 800069de <panic>

0000000080000092 <freerange>:
void freerange(void *pa_start, void *pa_end) {
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE) kfree(p);
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    800000b8:	7a7d                	lui	s4,0xfffff
    800000ba:	6985                	lui	s3,0x1
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
void kinit() {
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00009597          	auipc	a1,0x9
    800000ea:	f3258593          	addi	a1,a1,-206 # 80009018 <etext+0x18>
    800000ee:	0000a517          	auipc	a0,0xa
    800000f2:	96250513          	addi	a0,a0,-1694 # 80009a50 <kmem>
    800000f6:	00007097          	auipc	ra,0x7
    800000fa:	d90080e7          	jalr	-624(ra) # 80006e86 <initlock>
  freerange(end, (void *)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	000f3517          	auipc	a0,0xf3
    80000106:	2ae50513          	addi	a0,a0,686 # 800f33b0 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc(void) {
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	0000a497          	auipc	s1,0xa
    80000128:	92c48493          	addi	s1,s1,-1748 # 80009a50 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00007097          	auipc	ra,0x7
    80000132:	de8080e7          	jalr	-536(ra) # 80006f16 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if (r) kmem.freelist = r->next;
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	0000a517          	auipc	a0,0xa
    80000140:	91450513          	addi	a0,a0,-1772 # 80009a50 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00007097          	auipc	ra,0x7
    8000014a:	e84080e7          	jalr	-380(ra) # 80006fca <release>

  if (r) memset((char *)r, 5, PGSIZE);  // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void *)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	0000a517          	auipc	a0,0xa
    8000016c:	8e850513          	addi	a0,a0,-1816 # 80009a50 <kmem>
    80000170:	00007097          	auipc	ra,0x7
    80000174:	e5a080e7          	jalr	-422(ra) # 80006fca <release>
  if (r) memset((char *)r, 5, PGSIZE);  // fill with junk
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void *memset(void *dst, int c, uint n) {
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int memcmp(const void *v1, const void *v2, uint n) {
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0) {
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if (*s1 != *s2) return *s1 - *s2;
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
    if (*s1 != *s2) return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void *memmove(void *dst, const void *src, uint n) {
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if (n == 0) return dst;
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>

  s = src;
  d = dst;
  if (s < d && s + n > d) {
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while (n-- > 0) *--d = *--s;
  } else
    while (n-- > 0) *d++ = *s++;
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
void *memmove(void *dst, const void *src, uint n) {
    800001ea:	872a                	mv	a4,a0
    while (n-- > 0) *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ff0bc51>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    800001f8:	fef59ae3          	bne	a1,a5,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if (s < d && s + n > d) {
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while (n-- > 0) *--d = *--s;
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    8000022c:	fee79ae3          	bne	a5,a4,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *memcpy(void *dst, const void *src, uint n) {
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int strncmp(const char *p, const char *q, uint n) {
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q) n--, p++, q++;
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if (n == 0) return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a809                	j	8000027c <strncmp+0x32>
    8000026c:	4501                	li	a0,0
    8000026e:	a039                	j	8000027c <strncmp+0x32>
    80000270:	ca09                	beqz	a2,80000282 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000272:	00054503          	lbu	a0,0(a0)
    80000276:	0005c783          	lbu	a5,0(a1)
    8000027a:	9d1d                	subw	a0,a0,a5
}
    8000027c:	6422                	ld	s0,8(sp)
    8000027e:	0141                	addi	sp,sp,16
    80000280:	8082                	ret
  if (n == 0) return 0;
    80000282:	4501                	li	a0,0
    80000284:	bfe5                	j	8000027c <strncmp+0x32>

0000000080000286 <strncpy>:

char *strncpy(char *s, const char *t, int n) {
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0);
    8000028c:	872a                	mv	a4,a0
    8000028e:	8832                	mv	a6,a2
    80000290:	367d                	addiw	a2,a2,-1
    80000292:	01005963          	blez	a6,800002a4 <strncpy+0x1e>
    80000296:	0705                	addi	a4,a4,1
    80000298:	0005c783          	lbu	a5,0(a1)
    8000029c:	fef70fa3          	sb	a5,-1(a4)
    800002a0:	0585                	addi	a1,a1,1
    800002a2:	f7f5                	bnez	a5,8000028e <strncpy+0x8>
  while (n-- > 0) *s++ = 0;
    800002a4:	86ba                	mv	a3,a4
    800002a6:	00c05c63          	blez	a2,800002be <strncpy+0x38>
    800002aa:	0685                	addi	a3,a3,1
    800002ac:	fe068fa3          	sb	zero,-1(a3)
    800002b0:	40d707bb          	subw	a5,a4,a3
    800002b4:	37fd                	addiw	a5,a5,-1
    800002b6:	010787bb          	addw	a5,a5,a6
    800002ba:	fef048e3          	bgtz	a5,800002aa <strncpy+0x24>
  return os;
}
    800002be:	6422                	ld	s0,8(sp)
    800002c0:	0141                	addi	sp,sp,16
    800002c2:	8082                	ret

00000000800002c4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *safestrcpy(char *s, const char *t, int n) {
    800002c4:	1141                	addi	sp,sp,-16
    800002c6:	e422                	sd	s0,8(sp)
    800002c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0) return os;
    800002ca:	02c05363          	blez	a2,800002f0 <safestrcpy+0x2c>
    800002ce:	fff6069b          	addiw	a3,a2,-1
    800002d2:	1682                	slli	a3,a3,0x20
    800002d4:	9281                	srli	a3,a3,0x20
    800002d6:	96ae                	add	a3,a3,a1
    800002d8:	87aa                	mv	a5,a0
  while (--n > 0 && (*s++ = *t++) != 0);
    800002da:	00d58963          	beq	a1,a3,800002ec <safestrcpy+0x28>
    800002de:	0585                	addi	a1,a1,1
    800002e0:	0785                	addi	a5,a5,1
    800002e2:	fff5c703          	lbu	a4,-1(a1)
    800002e6:	fee78fa3          	sb	a4,-1(a5)
    800002ea:	fb65                	bnez	a4,800002da <safestrcpy+0x16>
  *s = 0;
    800002ec:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f0:	6422                	ld	s0,8(sp)
    800002f2:	0141                	addi	sp,sp,16
    800002f4:	8082                	ret

00000000800002f6 <strlen>:

int strlen(const char *s) {
    800002f6:	1141                	addi	sp,sp,-16
    800002f8:	e422                	sd	s0,8(sp)
    800002fa:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
    800002fc:	00054783          	lbu	a5,0(a0)
    80000300:	cf91                	beqz	a5,8000031c <strlen+0x26>
    80000302:	0505                	addi	a0,a0,1
    80000304:	87aa                	mv	a5,a0
    80000306:	4685                	li	a3,1
    80000308:	9e89                	subw	a3,a3,a0
    8000030a:	00f6853b          	addw	a0,a3,a5
    8000030e:	0785                	addi	a5,a5,1
    80000310:	fff7c703          	lbu	a4,-1(a5)
    80000314:	fb7d                	bnez	a4,8000030a <strlen+0x14>
  return n;
}
    80000316:	6422                	ld	s0,8(sp)
    80000318:	0141                	addi	sp,sp,16
    8000031a:	8082                	ret
  for (n = 0; s[n]; n++);
    8000031c:	4501                	li	a0,0
    8000031e:	bfe5                	j	80000316 <strlen+0x20>

0000000080000320 <main>:
#include "defs.h"

volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void main() {
    80000320:	1141                	addi	sp,sp,-16
    80000322:	e406                	sd	ra,8(sp)
    80000324:	e022                	sd	s0,0(sp)
    80000326:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    80000328:	00001097          	auipc	ra,0x1
    8000032c:	b98080e7          	jalr	-1128(ra) # 80000ec0 <cpuid>
    netinit();
    userinit();  // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while (started == 0);
    80000330:	00009717          	auipc	a4,0x9
    80000334:	6d070713          	addi	a4,a4,1744 # 80009a00 <started>
  if (cpuid() == 0) {
    80000338:	c139                	beqz	a0,8000037e <main+0x5e>
    while (started == 0);
    8000033a:	431c                	lw	a5,0(a4)
    8000033c:	2781                	sext.w	a5,a5
    8000033e:	dff5                	beqz	a5,8000033a <main+0x1a>
    __sync_synchronize();
    80000340:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000344:	00001097          	auipc	ra,0x1
    80000348:	b7c080e7          	jalr	-1156(ra) # 80000ec0 <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00009517          	auipc	a0,0x9
    80000352:	cea50513          	addi	a0,a0,-790 # 80009038 <etext+0x38>
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	6d2080e7          	jalr	1746(ra) # 80006a28 <printf>
    kvminithart();   // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0e8080e7          	jalr	232(ra) # 80000446 <kvminithart>
    trapinithart();  // install kernel trap vector
    80000366:	00002097          	auipc	ra,0x2
    8000036a:	828080e7          	jalr	-2008(ra) # 80001b8e <trapinithart>
    plicinithart();  // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	de6080e7          	jalr	-538(ra) # 80005154 <plicinithart>
  }

  scheduler();
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	070080e7          	jalr	112(ra) # 800013e6 <scheduler>
    consoleinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	570080e7          	jalr	1392(ra) # 800068ee <consoleinit>
    printfinit();
    80000386:	00007097          	auipc	ra,0x7
    8000038a:	882080e7          	jalr	-1918(ra) # 80006c08 <printfinit>
    printf("\n");
    8000038e:	00009517          	auipc	a0,0x9
    80000392:	cba50513          	addi	a0,a0,-838 # 80009048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	692080e7          	jalr	1682(ra) # 80006a28 <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00009517          	auipc	a0,0x9
    800003a2:	c8250513          	addi	a0,a0,-894 # 80009020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	682080e7          	jalr	1666(ra) # 80006a28 <printf>
    printf("\n");
    800003ae:	00009517          	auipc	a0,0x9
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80009048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	672080e7          	jalr	1650(ra) # 80006a28 <printf>
    kinit();             // physical page allocator
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	d20080e7          	jalr	-736(ra) # 800000de <kinit>
    kvminit();           // create kernel page table
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	38a080e7          	jalr	906(ra) # 80000750 <kvminit>
    kvminithart();       // turn on paging
    800003ce:	00000097          	auipc	ra,0x0
    800003d2:	078080e7          	jalr	120(ra) # 80000446 <kvminithart>
    procinit();          // process table
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	a36080e7          	jalr	-1482(ra) # 80000e0c <procinit>
    trapinit();          // trap vectors
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	788080e7          	jalr	1928(ra) # 80001b66 <trapinit>
    trapinithart();      // install kernel trap vector
    800003e6:	00001097          	auipc	ra,0x1
    800003ea:	7a8080e7          	jalr	1960(ra) # 80001b8e <trapinithart>
    plicinit();          // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	d3c080e7          	jalr	-708(ra) # 8000512a <plicinit>
    plicinithart();      // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	d5e080e7          	jalr	-674(ra) # 80005154 <plicinithart>
    binit();             // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	eec080e7          	jalr	-276(ra) # 800022ea <binit>
    iinit();             // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	58c080e7          	jalr	1420(ra) # 80002992 <iinit>
    fileinit();          // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	532080e7          	jalr	1330(ra) # 80003940 <fileinit>
    virtio_disk_init();  // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	e4c080e7          	jalr	-436(ra) # 80005262 <virtio_disk_init>
    pci_init();
    8000041e:	00006097          	auipc	ra,0x6
    80000422:	010080e7          	jalr	16(ra) # 8000642e <pci_init>
    netinit();
    80000426:	00005097          	auipc	ra,0x5
    8000042a:	692080e7          	jalr	1682(ra) # 80005ab8 <netinit>
    userinit();  // first user process
    8000042e:	00001097          	auipc	ra,0x1
    80000432:	d9a080e7          	jalr	-614(ra) # 800011c8 <userinit>
    __sync_synchronize();
    80000436:	0ff0000f          	fence
    started = 1;
    8000043a:	4785                	li	a5,1
    8000043c:	00009717          	auipc	a4,0x9
    80000440:	5cf72223          	sw	a5,1476(a4) # 80009a00 <started>
    80000444:	bf0d                	j	80000376 <main+0x56>

0000000080000446 <kvminithart>:
// Initialize the one kernel_pagetable
void kvminit(void) { kernel_pagetable = kvmmake(); }

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart() {
    80000446:	1141                	addi	sp,sp,-16
    80000448:	e422                	sd	s0,8(sp)
    8000044a:	0800                	addi	s0,sp,16
}

// flush the TLB.
static inline void sfence_vma() {
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000044c:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000450:	00009797          	auipc	a5,0x9
    80000454:	5b87b783          	ld	a5,1464(a5) # 80009a08 <kernel_pagetable>
    80000458:	83b1                	srli	a5,a5,0xc
    8000045a:	577d                	li	a4,-1
    8000045c:	177e                	slli	a4,a4,0x3f
    8000045e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    80000460:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000464:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000468:	6422                	ld	s0,8(sp)
    8000046a:	0141                	addi	sp,sp,16
    8000046c:	8082                	ret

000000008000046e <walk>:
//   39..63 -- must be zero.
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
    8000046e:	7139                	addi	sp,sp,-64
    80000470:	fc06                	sd	ra,56(sp)
    80000472:	f822                	sd	s0,48(sp)
    80000474:	f426                	sd	s1,40(sp)
    80000476:	f04a                	sd	s2,32(sp)
    80000478:	ec4e                	sd	s3,24(sp)
    8000047a:	e852                	sd	s4,16(sp)
    8000047c:	e456                	sd	s5,8(sp)
    8000047e:	e05a                	sd	s6,0(sp)
    80000480:	0080                	addi	s0,sp,64
    80000482:	84aa                	mv	s1,a0
    80000484:	89ae                	mv	s3,a1
    80000486:	8ab2                	mv	s5,a2
  if (va >= MAXVA) panic("walk");
    80000488:	57fd                	li	a5,-1
    8000048a:	83e9                	srli	a5,a5,0x1a
    8000048c:	4a79                	li	s4,30

  for (int level = 2; level > 0; level--) {
    8000048e:	4b31                	li	s6,12
  if (va >= MAXVA) panic("walk");
    80000490:	04b7f263          	bgeu	a5,a1,800004d4 <walk+0x66>
    80000494:	00009517          	auipc	a0,0x9
    80000498:	bbc50513          	addi	a0,a0,-1092 # 80009050 <etext+0x50>
    8000049c:	00006097          	auipc	ra,0x6
    800004a0:	542080e7          	jalr	1346(ra) # 800069de <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if (*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0) return 0;
    800004a4:	060a8663          	beqz	s5,80000510 <walk+0xa2>
    800004a8:	00000097          	auipc	ra,0x0
    800004ac:	c72080e7          	jalr	-910(ra) # 8000011a <kalloc>
    800004b0:	84aa                	mv	s1,a0
    800004b2:	c529                	beqz	a0,800004fc <walk+0x8e>
      memset(pagetable, 0, PGSIZE);
    800004b4:	6605                	lui	a2,0x1
    800004b6:	4581                	li	a1,0
    800004b8:	00000097          	auipc	ra,0x0
    800004bc:	cc2080e7          	jalr	-830(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004c0:	00c4d793          	srli	a5,s1,0xc
    800004c4:	07aa                	slli	a5,a5,0xa
    800004c6:	0017e793          	ori	a5,a5,1
    800004ca:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--) {
    800004ce:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ff0bc47>
    800004d0:	036a0063          	beq	s4,s6,800004f0 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004d4:	0149d933          	srl	s2,s3,s4
    800004d8:	1ff97913          	andi	s2,s2,511
    800004dc:	090e                	slli	s2,s2,0x3
    800004de:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    800004e0:	00093483          	ld	s1,0(s2)
    800004e4:	0014f793          	andi	a5,s1,1
    800004e8:	dfd5                	beqz	a5,800004a4 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004ea:	80a9                	srli	s1,s1,0xa
    800004ec:	04b2                	slli	s1,s1,0xc
    800004ee:	b7c5                	j	800004ce <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004f0:	00c9d513          	srli	a0,s3,0xc
    800004f4:	1ff57513          	andi	a0,a0,511
    800004f8:	050e                	slli	a0,a0,0x3
    800004fa:	9526                	add	a0,a0,s1
}
    800004fc:	70e2                	ld	ra,56(sp)
    800004fe:	7442                	ld	s0,48(sp)
    80000500:	74a2                	ld	s1,40(sp)
    80000502:	7902                	ld	s2,32(sp)
    80000504:	69e2                	ld	s3,24(sp)
    80000506:	6a42                	ld	s4,16(sp)
    80000508:	6aa2                	ld	s5,8(sp)
    8000050a:	6b02                	ld	s6,0(sp)
    8000050c:	6121                	addi	sp,sp,64
    8000050e:	8082                	ret
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0) return 0;
    80000510:	4501                	li	a0,0
    80000512:	b7ed                	j	800004fc <walk+0x8e>

0000000080000514 <walkaddr>:
// Can only be used to look up user pages.
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA) return 0;
    80000514:	57fd                	li	a5,-1
    80000516:	83e9                	srli	a5,a5,0x1a
    80000518:	00b7f463          	bgeu	a5,a1,80000520 <walkaddr+0xc>
    8000051c:	4501                	li	a0,0
  if (pte == 0) return 0;
  if ((*pte & PTE_V) == 0) return 0;
  if ((*pte & PTE_U) == 0) return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000051e:	8082                	ret
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
    80000520:	1141                	addi	sp,sp,-16
    80000522:	e406                	sd	ra,8(sp)
    80000524:	e022                	sd	s0,0(sp)
    80000526:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000528:	4601                	li	a2,0
    8000052a:	00000097          	auipc	ra,0x0
    8000052e:	f44080e7          	jalr	-188(ra) # 8000046e <walk>
  if (pte == 0) return 0;
    80000532:	c105                	beqz	a0,80000552 <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0) return 0;
    80000534:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0) return 0;
    80000536:	0117f693          	andi	a3,a5,17
    8000053a:	4745                	li	a4,17
    8000053c:	4501                	li	a0,0
    8000053e:	00e68663          	beq	a3,a4,8000054a <walkaddr+0x36>
}
    80000542:	60a2                	ld	ra,8(sp)
    80000544:	6402                	ld	s0,0(sp)
    80000546:	0141                	addi	sp,sp,16
    80000548:	8082                	ret
  pa = PTE2PA(*pte);
    8000054a:	83a9                	srli	a5,a5,0xa
    8000054c:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000550:	bfcd                	j	80000542 <walkaddr+0x2e>
  if (pte == 0) return 0;
    80000552:	4501                	li	a0,0
    80000554:	b7fd                	j	80000542 <walkaddr+0x2e>

0000000080000556 <mappages>:
// physical addresses starting at pa.
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa,
             int perm) {
    80000556:	715d                	addi	sp,sp,-80
    80000558:	e486                	sd	ra,72(sp)
    8000055a:	e0a2                	sd	s0,64(sp)
    8000055c:	fc26                	sd	s1,56(sp)
    8000055e:	f84a                	sd	s2,48(sp)
    80000560:	f44e                	sd	s3,40(sp)
    80000562:	f052                	sd	s4,32(sp)
    80000564:	ec56                	sd	s5,24(sp)
    80000566:	e85a                	sd	s6,16(sp)
    80000568:	e45e                	sd	s7,8(sp)
    8000056a:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if ((va % PGSIZE) != 0) panic("mappages: va not aligned");
    8000056c:	03459793          	slli	a5,a1,0x34
    80000570:	e7b9                	bnez	a5,800005be <mappages+0x68>
    80000572:	8aaa                	mv	s5,a0
    80000574:	8b3a                	mv	s6,a4

  if ((size % PGSIZE) != 0) panic("mappages: size not aligned");
    80000576:	03461793          	slli	a5,a2,0x34
    8000057a:	ebb1                	bnez	a5,800005ce <mappages+0x78>

  if (size == 0) panic("mappages: size");
    8000057c:	c22d                	beqz	a2,800005de <mappages+0x88>

  a = va;
  last = va + size - PGSIZE;
    8000057e:	77fd                	lui	a5,0xfffff
    80000580:	963e                	add	a2,a2,a5
    80000582:	00b609b3          	add	s3,a2,a1
  a = va;
    80000586:	892e                	mv	s2,a1
    80000588:	40b68a33          	sub	s4,a3,a1
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    if (*pte & PTE_V) panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last) break;
    a += PGSIZE;
    8000058c:	6b85                	lui	s7,0x1
    8000058e:	012a04b3          	add	s1,s4,s2
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    80000592:	4605                	li	a2,1
    80000594:	85ca                	mv	a1,s2
    80000596:	8556                	mv	a0,s5
    80000598:	00000097          	auipc	ra,0x0
    8000059c:	ed6080e7          	jalr	-298(ra) # 8000046e <walk>
    800005a0:	cd39                	beqz	a0,800005fe <mappages+0xa8>
    if (*pte & PTE_V) panic("mappages: remap");
    800005a2:	611c                	ld	a5,0(a0)
    800005a4:	8b85                	andi	a5,a5,1
    800005a6:	e7a1                	bnez	a5,800005ee <mappages+0x98>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005a8:	80b1                	srli	s1,s1,0xc
    800005aa:	04aa                	slli	s1,s1,0xa
    800005ac:	0164e4b3          	or	s1,s1,s6
    800005b0:	0014e493          	ori	s1,s1,1
    800005b4:	e104                	sd	s1,0(a0)
    if (a == last) break;
    800005b6:	07390063          	beq	s2,s3,80000616 <mappages+0xc0>
    a += PGSIZE;
    800005ba:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    800005bc:	bfc9                	j	8000058e <mappages+0x38>
  if ((va % PGSIZE) != 0) panic("mappages: va not aligned");
    800005be:	00009517          	auipc	a0,0x9
    800005c2:	a9a50513          	addi	a0,a0,-1382 # 80009058 <etext+0x58>
    800005c6:	00006097          	auipc	ra,0x6
    800005ca:	418080e7          	jalr	1048(ra) # 800069de <panic>
  if ((size % PGSIZE) != 0) panic("mappages: size not aligned");
    800005ce:	00009517          	auipc	a0,0x9
    800005d2:	aaa50513          	addi	a0,a0,-1366 # 80009078 <etext+0x78>
    800005d6:	00006097          	auipc	ra,0x6
    800005da:	408080e7          	jalr	1032(ra) # 800069de <panic>
  if (size == 0) panic("mappages: size");
    800005de:	00009517          	auipc	a0,0x9
    800005e2:	aba50513          	addi	a0,a0,-1350 # 80009098 <etext+0x98>
    800005e6:	00006097          	auipc	ra,0x6
    800005ea:	3f8080e7          	jalr	1016(ra) # 800069de <panic>
    if (*pte & PTE_V) panic("mappages: remap");
    800005ee:	00009517          	auipc	a0,0x9
    800005f2:	aba50513          	addi	a0,a0,-1350 # 800090a8 <etext+0xa8>
    800005f6:	00006097          	auipc	ra,0x6
    800005fa:	3e8080e7          	jalr	1000(ra) # 800069de <panic>
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    800005fe:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000600:	60a6                	ld	ra,72(sp)
    80000602:	6406                	ld	s0,64(sp)
    80000604:	74e2                	ld	s1,56(sp)
    80000606:	7942                	ld	s2,48(sp)
    80000608:	79a2                	ld	s3,40(sp)
    8000060a:	7a02                	ld	s4,32(sp)
    8000060c:	6ae2                	ld	s5,24(sp)
    8000060e:	6b42                	ld	s6,16(sp)
    80000610:	6ba2                	ld	s7,8(sp)
    80000612:	6161                	addi	sp,sp,80
    80000614:	8082                	ret
  return 0;
    80000616:	4501                	li	a0,0
    80000618:	b7e5                	j	80000600 <mappages+0xaa>

000000008000061a <kvmmap>:
void kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm) {
    8000061a:	1141                	addi	sp,sp,-16
    8000061c:	e406                	sd	ra,8(sp)
    8000061e:	e022                	sd	s0,0(sp)
    80000620:	0800                	addi	s0,sp,16
    80000622:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0) panic("kvmmap");
    80000624:	86b2                	mv	a3,a2
    80000626:	863e                	mv	a2,a5
    80000628:	00000097          	auipc	ra,0x0
    8000062c:	f2e080e7          	jalr	-210(ra) # 80000556 <mappages>
    80000630:	e509                	bnez	a0,8000063a <kvmmap+0x20>
}
    80000632:	60a2                	ld	ra,8(sp)
    80000634:	6402                	ld	s0,0(sp)
    80000636:	0141                	addi	sp,sp,16
    80000638:	8082                	ret
  if (mappages(kpgtbl, va, sz, pa, perm) != 0) panic("kvmmap");
    8000063a:	00009517          	auipc	a0,0x9
    8000063e:	a7e50513          	addi	a0,a0,-1410 # 800090b8 <etext+0xb8>
    80000642:	00006097          	auipc	ra,0x6
    80000646:	39c080e7          	jalr	924(ra) # 800069de <panic>

000000008000064a <kvmmake>:
pagetable_t kvmmake(void) {
    8000064a:	1101                	addi	sp,sp,-32
    8000064c:	ec06                	sd	ra,24(sp)
    8000064e:	e822                	sd	s0,16(sp)
    80000650:	e426                	sd	s1,8(sp)
    80000652:	e04a                	sd	s2,0(sp)
    80000654:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    80000656:	00000097          	auipc	ra,0x0
    8000065a:	ac4080e7          	jalr	-1340(ra) # 8000011a <kalloc>
    8000065e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000660:	6605                	lui	a2,0x1
    80000662:	4581                	li	a1,0
    80000664:	00000097          	auipc	ra,0x0
    80000668:	b16080e7          	jalr	-1258(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000066c:	4719                	li	a4,6
    8000066e:	6685                	lui	a3,0x1
    80000670:	10000637          	lui	a2,0x10000
    80000674:	100005b7          	lui	a1,0x10000
    80000678:	8526                	mv	a0,s1
    8000067a:	00000097          	auipc	ra,0x0
    8000067e:	fa0080e7          	jalr	-96(ra) # 8000061a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000682:	4719                	li	a4,6
    80000684:	6685                	lui	a3,0x1
    80000686:	10001637          	lui	a2,0x10001
    8000068a:	100015b7          	lui	a1,0x10001
    8000068e:	8526                	mv	a0,s1
    80000690:	00000097          	auipc	ra,0x0
    80000694:	f8a080e7          	jalr	-118(ra) # 8000061a <kvmmap>
  kvmmap(kpgtbl, 0x30000000L, 0x30000000L, 0x10000000, PTE_R | PTE_W);
    80000698:	4719                	li	a4,6
    8000069a:	100006b7          	lui	a3,0x10000
    8000069e:	30000637          	lui	a2,0x30000
    800006a2:	300005b7          	lui	a1,0x30000
    800006a6:	8526                	mv	a0,s1
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	f72080e7          	jalr	-142(ra) # 8000061a <kvmmap>
  kvmmap(kpgtbl, 0x40000000L, 0x40000000L, 0x20000, PTE_R | PTE_W);
    800006b0:	4719                	li	a4,6
    800006b2:	000206b7          	lui	a3,0x20
    800006b6:	40000637          	lui	a2,0x40000
    800006ba:	400005b7          	lui	a1,0x40000
    800006be:	8526                	mv	a0,s1
    800006c0:	00000097          	auipc	ra,0x0
    800006c4:	f5a080e7          	jalr	-166(ra) # 8000061a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006c8:	4719                	li	a4,6
    800006ca:	004006b7          	lui	a3,0x400
    800006ce:	0c000637          	lui	a2,0xc000
    800006d2:	0c0005b7          	lui	a1,0xc000
    800006d6:	8526                	mv	a0,s1
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	f42080e7          	jalr	-190(ra) # 8000061a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    800006e0:	00009917          	auipc	s2,0x9
    800006e4:	92090913          	addi	s2,s2,-1760 # 80009000 <etext>
    800006e8:	4729                	li	a4,10
    800006ea:	80009697          	auipc	a3,0x80009
    800006ee:	91668693          	addi	a3,a3,-1770 # 9000 <_entry-0x7fff7000>
    800006f2:	4605                	li	a2,1
    800006f4:	067e                	slli	a2,a2,0x1f
    800006f6:	85b2                	mv	a1,a2
    800006f8:	8526                	mv	a0,s1
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	f20080e7          	jalr	-224(ra) # 8000061a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    80000702:	4719                	li	a4,6
    80000704:	46c5                	li	a3,17
    80000706:	06ee                	slli	a3,a3,0x1b
    80000708:	412686b3          	sub	a3,a3,s2
    8000070c:	864a                	mv	a2,s2
    8000070e:	85ca                	mv	a1,s2
    80000710:	8526                	mv	a0,s1
    80000712:	00000097          	auipc	ra,0x0
    80000716:	f08080e7          	jalr	-248(ra) # 8000061a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000071a:	4729                	li	a4,10
    8000071c:	6685                	lui	a3,0x1
    8000071e:	00008617          	auipc	a2,0x8
    80000722:	8e260613          	addi	a2,a2,-1822 # 80008000 <_trampoline>
    80000726:	040005b7          	lui	a1,0x4000
    8000072a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000072c:	05b2                	slli	a1,a1,0xc
    8000072e:	8526                	mv	a0,s1
    80000730:	00000097          	auipc	ra,0x0
    80000734:	eea080e7          	jalr	-278(ra) # 8000061a <kvmmap>
  proc_mapstacks(kpgtbl);
    80000738:	8526                	mv	a0,s1
    8000073a:	00000097          	auipc	ra,0x0
    8000073e:	63c080e7          	jalr	1596(ra) # 80000d76 <proc_mapstacks>
}
    80000742:	8526                	mv	a0,s1
    80000744:	60e2                	ld	ra,24(sp)
    80000746:	6442                	ld	s0,16(sp)
    80000748:	64a2                	ld	s1,8(sp)
    8000074a:	6902                	ld	s2,0(sp)
    8000074c:	6105                	addi	sp,sp,32
    8000074e:	8082                	ret

0000000080000750 <kvminit>:
void kvminit(void) { kernel_pagetable = kvmmake(); }
    80000750:	1141                	addi	sp,sp,-16
    80000752:	e406                	sd	ra,8(sp)
    80000754:	e022                	sd	s0,0(sp)
    80000756:	0800                	addi	s0,sp,16
    80000758:	00000097          	auipc	ra,0x0
    8000075c:	ef2080e7          	jalr	-270(ra) # 8000064a <kvmmake>
    80000760:	00009797          	auipc	a5,0x9
    80000764:	2aa7b423          	sd	a0,680(a5) # 80009a08 <kernel_pagetable>
    80000768:	60a2                	ld	ra,8(sp)
    8000076a:	6402                	ld	s0,0(sp)
    8000076c:	0141                	addi	sp,sp,16
    8000076e:	8082                	ret

0000000080000770 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free) {
    80000770:	715d                	addi	sp,sp,-80
    80000772:	e486                	sd	ra,72(sp)
    80000774:	e0a2                	sd	s0,64(sp)
    80000776:	fc26                	sd	s1,56(sp)
    80000778:	f84a                	sd	s2,48(sp)
    8000077a:	f44e                	sd	s3,40(sp)
    8000077c:	f052                	sd	s4,32(sp)
    8000077e:	ec56                	sd	s5,24(sp)
    80000780:	e85a                	sd	s6,16(sp)
    80000782:	e45e                	sd	s7,8(sp)
    80000784:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0) panic("uvmunmap: not aligned");
    80000786:	03459793          	slli	a5,a1,0x34
    8000078a:	e795                	bnez	a5,800007b6 <uvmunmap+0x46>
    8000078c:	8a2a                	mv	s4,a0
    8000078e:	892e                	mv	s2,a1
    80000790:	8ab6                	mv	s5,a3

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80000792:	0632                	slli	a2,a2,0xc
    80000794:	00b609b3          	add	s3,a2,a1
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    80000798:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000079a:	6b05                	lui	s6,0x1
    8000079c:	0735e263          	bltu	a1,s3,80000800 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
  }
}
    800007a0:	60a6                	ld	ra,72(sp)
    800007a2:	6406                	ld	s0,64(sp)
    800007a4:	74e2                	ld	s1,56(sp)
    800007a6:	7942                	ld	s2,48(sp)
    800007a8:	79a2                	ld	s3,40(sp)
    800007aa:	7a02                	ld	s4,32(sp)
    800007ac:	6ae2                	ld	s5,24(sp)
    800007ae:	6b42                	ld	s6,16(sp)
    800007b0:	6ba2                	ld	s7,8(sp)
    800007b2:	6161                	addi	sp,sp,80
    800007b4:	8082                	ret
  if ((va % PGSIZE) != 0) panic("uvmunmap: not aligned");
    800007b6:	00009517          	auipc	a0,0x9
    800007ba:	90a50513          	addi	a0,a0,-1782 # 800090c0 <etext+0xc0>
    800007be:	00006097          	auipc	ra,0x6
    800007c2:	220080e7          	jalr	544(ra) # 800069de <panic>
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    800007c6:	00009517          	auipc	a0,0x9
    800007ca:	91250513          	addi	a0,a0,-1774 # 800090d8 <etext+0xd8>
    800007ce:	00006097          	auipc	ra,0x6
    800007d2:	210080e7          	jalr	528(ra) # 800069de <panic>
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    800007d6:	00009517          	auipc	a0,0x9
    800007da:	91250513          	addi	a0,a0,-1774 # 800090e8 <etext+0xe8>
    800007de:	00006097          	auipc	ra,0x6
    800007e2:	200080e7          	jalr	512(ra) # 800069de <panic>
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    800007e6:	00009517          	auipc	a0,0x9
    800007ea:	91a50513          	addi	a0,a0,-1766 # 80009100 <etext+0x100>
    800007ee:	00006097          	auipc	ra,0x6
    800007f2:	1f0080e7          	jalr	496(ra) # 800069de <panic>
    *pte = 0;
    800007f6:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    800007fa:	995a                	add	s2,s2,s6
    800007fc:	fb3972e3          	bgeu	s2,s3,800007a0 <uvmunmap+0x30>
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    80000800:	4601                	li	a2,0
    80000802:	85ca                	mv	a1,s2
    80000804:	8552                	mv	a0,s4
    80000806:	00000097          	auipc	ra,0x0
    8000080a:	c68080e7          	jalr	-920(ra) # 8000046e <walk>
    8000080e:	84aa                	mv	s1,a0
    80000810:	d95d                	beqz	a0,800007c6 <uvmunmap+0x56>
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    80000812:	6108                	ld	a0,0(a0)
    80000814:	00157793          	andi	a5,a0,1
    80000818:	dfdd                	beqz	a5,800007d6 <uvmunmap+0x66>
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    8000081a:	3ff57793          	andi	a5,a0,1023
    8000081e:	fd7784e3          	beq	a5,s7,800007e6 <uvmunmap+0x76>
    if (do_free) {
    80000822:	fc0a8ae3          	beqz	s5,800007f6 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80000826:	8129                	srli	a0,a0,0xa
      kfree((void *)pa);
    80000828:	0532                	slli	a0,a0,0xc
    8000082a:	fffff097          	auipc	ra,0xfffff
    8000082e:	7f2080e7          	jalr	2034(ra) # 8000001c <kfree>
    80000832:	b7d1                	j	800007f6 <uvmunmap+0x86>

0000000080000834 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t uvmcreate() {
    80000834:	1101                	addi	sp,sp,-32
    80000836:	ec06                	sd	ra,24(sp)
    80000838:	e822                	sd	s0,16(sp)
    8000083a:	e426                	sd	s1,8(sp)
    8000083c:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    8000083e:	00000097          	auipc	ra,0x0
    80000842:	8dc080e7          	jalr	-1828(ra) # 8000011a <kalloc>
    80000846:	84aa                	mv	s1,a0
  if (pagetable == 0) return 0;
    80000848:	c519                	beqz	a0,80000856 <uvmcreate+0x22>
  memset(pagetable, 0, PGSIZE);
    8000084a:	6605                	lui	a2,0x1
    8000084c:	4581                	li	a1,0
    8000084e:	00000097          	auipc	ra,0x0
    80000852:	92c080e7          	jalr	-1748(ra) # 8000017a <memset>
  return pagetable;
}
    80000856:	8526                	mv	a0,s1
    80000858:	60e2                	ld	ra,24(sp)
    8000085a:	6442                	ld	s0,16(sp)
    8000085c:	64a2                	ld	s1,8(sp)
    8000085e:	6105                	addi	sp,sp,32
    80000860:	8082                	ret

0000000080000862 <uvmfirst>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvmfirst(pagetable_t pagetable, uchar *src, uint sz) {
    80000862:	7179                	addi	sp,sp,-48
    80000864:	f406                	sd	ra,40(sp)
    80000866:	f022                	sd	s0,32(sp)
    80000868:	ec26                	sd	s1,24(sp)
    8000086a:	e84a                	sd	s2,16(sp)
    8000086c:	e44e                	sd	s3,8(sp)
    8000086e:	e052                	sd	s4,0(sp)
    80000870:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE) panic("uvmfirst: more than a page");
    80000872:	6785                	lui	a5,0x1
    80000874:	04f67863          	bgeu	a2,a5,800008c4 <uvmfirst+0x62>
    80000878:	8a2a                	mv	s4,a0
    8000087a:	89ae                	mv	s3,a1
    8000087c:	84b2                	mv	s1,a2
  mem = kalloc();
    8000087e:	00000097          	auipc	ra,0x0
    80000882:	89c080e7          	jalr	-1892(ra) # 8000011a <kalloc>
    80000886:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000888:	6605                	lui	a2,0x1
    8000088a:	4581                	li	a1,0
    8000088c:	00000097          	auipc	ra,0x0
    80000890:	8ee080e7          	jalr	-1810(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    80000894:	4779                	li	a4,30
    80000896:	86ca                	mv	a3,s2
    80000898:	6605                	lui	a2,0x1
    8000089a:	4581                	li	a1,0
    8000089c:	8552                	mv	a0,s4
    8000089e:	00000097          	auipc	ra,0x0
    800008a2:	cb8080e7          	jalr	-840(ra) # 80000556 <mappages>
  memmove(mem, src, sz);
    800008a6:	8626                	mv	a2,s1
    800008a8:	85ce                	mv	a1,s3
    800008aa:	854a                	mv	a0,s2
    800008ac:	00000097          	auipc	ra,0x0
    800008b0:	92a080e7          	jalr	-1750(ra) # 800001d6 <memmove>
}
    800008b4:	70a2                	ld	ra,40(sp)
    800008b6:	7402                	ld	s0,32(sp)
    800008b8:	64e2                	ld	s1,24(sp)
    800008ba:	6942                	ld	s2,16(sp)
    800008bc:	69a2                	ld	s3,8(sp)
    800008be:	6a02                	ld	s4,0(sp)
    800008c0:	6145                	addi	sp,sp,48
    800008c2:	8082                	ret
  if (sz >= PGSIZE) panic("uvmfirst: more than a page");
    800008c4:	00009517          	auipc	a0,0x9
    800008c8:	85450513          	addi	a0,a0,-1964 # 80009118 <etext+0x118>
    800008cc:	00006097          	auipc	ra,0x6
    800008d0:	112080e7          	jalr	274(ra) # 800069de <panic>

00000000800008d4 <uvmdealloc>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64 uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    800008d4:	1101                	addi	sp,sp,-32
    800008d6:	ec06                	sd	ra,24(sp)
    800008d8:	e822                	sd	s0,16(sp)
    800008da:	e426                	sd	s1,8(sp)
    800008dc:	1000                	addi	s0,sp,32
  if (newsz >= oldsz) return oldsz;
    800008de:	84ae                	mv	s1,a1
    800008e0:	00b67d63          	bgeu	a2,a1,800008fa <uvmdealloc+0x26>
    800008e4:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    800008e6:	6785                	lui	a5,0x1
    800008e8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008ea:	00f60733          	add	a4,a2,a5
    800008ee:	76fd                	lui	a3,0xfffff
    800008f0:	8f75                	and	a4,a4,a3
    800008f2:	97ae                	add	a5,a5,a1
    800008f4:	8ff5                	and	a5,a5,a3
    800008f6:	00f76863          	bltu	a4,a5,80000906 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008fa:	8526                	mv	a0,s1
    800008fc:	60e2                	ld	ra,24(sp)
    800008fe:	6442                	ld	s0,16(sp)
    80000900:	64a2                	ld	s1,8(sp)
    80000902:	6105                	addi	sp,sp,32
    80000904:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000906:	8f99                	sub	a5,a5,a4
    80000908:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000090a:	4685                	li	a3,1
    8000090c:	0007861b          	sext.w	a2,a5
    80000910:	85ba                	mv	a1,a4
    80000912:	00000097          	auipc	ra,0x0
    80000916:	e5e080e7          	jalr	-418(ra) # 80000770 <uvmunmap>
    8000091a:	b7c5                	j	800008fa <uvmdealloc+0x26>

000000008000091c <uvmalloc>:
  if (newsz < oldsz) return oldsz;
    8000091c:	0ab66563          	bltu	a2,a1,800009c6 <uvmalloc+0xaa>
uint64 uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz, int xperm) {
    80000920:	7139                	addi	sp,sp,-64
    80000922:	fc06                	sd	ra,56(sp)
    80000924:	f822                	sd	s0,48(sp)
    80000926:	f426                	sd	s1,40(sp)
    80000928:	f04a                	sd	s2,32(sp)
    8000092a:	ec4e                	sd	s3,24(sp)
    8000092c:	e852                	sd	s4,16(sp)
    8000092e:	e456                	sd	s5,8(sp)
    80000930:	e05a                	sd	s6,0(sp)
    80000932:	0080                	addi	s0,sp,64
    80000934:	8aaa                	mv	s5,a0
    80000936:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000938:	6785                	lui	a5,0x1
    8000093a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000093c:	95be                	add	a1,a1,a5
    8000093e:	77fd                	lui	a5,0xfffff
    80000940:	00f5f9b3          	and	s3,a1,a5
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80000944:	08c9f363          	bgeu	s3,a2,800009ca <uvmalloc+0xae>
    80000948:	894e                	mv	s2,s3
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    8000094a:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    8000094e:	fffff097          	auipc	ra,0xfffff
    80000952:	7cc080e7          	jalr	1996(ra) # 8000011a <kalloc>
    80000956:	84aa                	mv	s1,a0
    if (mem == 0) {
    80000958:	c51d                	beqz	a0,80000986 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    8000095a:	6605                	lui	a2,0x1
    8000095c:	4581                	li	a1,0
    8000095e:	00000097          	auipc	ra,0x0
    80000962:	81c080e7          	jalr	-2020(ra) # 8000017a <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    80000966:	875a                	mv	a4,s6
    80000968:	86a6                	mv	a3,s1
    8000096a:	6605                	lui	a2,0x1
    8000096c:	85ca                	mv	a1,s2
    8000096e:	8556                	mv	a0,s5
    80000970:	00000097          	auipc	ra,0x0
    80000974:	be6080e7          	jalr	-1050(ra) # 80000556 <mappages>
    80000978:	e90d                	bnez	a0,800009aa <uvmalloc+0x8e>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    8000097a:	6785                	lui	a5,0x1
    8000097c:	993e                	add	s2,s2,a5
    8000097e:	fd4968e3          	bltu	s2,s4,8000094e <uvmalloc+0x32>
  return newsz;
    80000982:	8552                	mv	a0,s4
    80000984:	a809                	j	80000996 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000986:	864e                	mv	a2,s3
    80000988:	85ca                	mv	a1,s2
    8000098a:	8556                	mv	a0,s5
    8000098c:	00000097          	auipc	ra,0x0
    80000990:	f48080e7          	jalr	-184(ra) # 800008d4 <uvmdealloc>
      return 0;
    80000994:	4501                	li	a0,0
}
    80000996:	70e2                	ld	ra,56(sp)
    80000998:	7442                	ld	s0,48(sp)
    8000099a:	74a2                	ld	s1,40(sp)
    8000099c:	7902                	ld	s2,32(sp)
    8000099e:	69e2                	ld	s3,24(sp)
    800009a0:	6a42                	ld	s4,16(sp)
    800009a2:	6aa2                	ld	s5,8(sp)
    800009a4:	6b02                	ld	s6,0(sp)
    800009a6:	6121                	addi	sp,sp,64
    800009a8:	8082                	ret
      kfree(mem);
    800009aa:	8526                	mv	a0,s1
    800009ac:	fffff097          	auipc	ra,0xfffff
    800009b0:	670080e7          	jalr	1648(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800009b4:	864e                	mv	a2,s3
    800009b6:	85ca                	mv	a1,s2
    800009b8:	8556                	mv	a0,s5
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	f1a080e7          	jalr	-230(ra) # 800008d4 <uvmdealloc>
      return 0;
    800009c2:	4501                	li	a0,0
    800009c4:	bfc9                	j	80000996 <uvmalloc+0x7a>
  if (newsz < oldsz) return oldsz;
    800009c6:	852e                	mv	a0,a1
}
    800009c8:	8082                	ret
  return newsz;
    800009ca:	8532                	mv	a0,a2
    800009cc:	b7e9                	j	80000996 <uvmalloc+0x7a>

00000000800009ce <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable) {
    800009ce:	7179                	addi	sp,sp,-48
    800009d0:	f406                	sd	ra,40(sp)
    800009d2:	f022                	sd	s0,32(sp)
    800009d4:	ec26                	sd	s1,24(sp)
    800009d6:	e84a                	sd	s2,16(sp)
    800009d8:	e44e                	sd	s3,8(sp)
    800009da:	e052                	sd	s4,0(sp)
    800009dc:	1800                	addi	s0,sp,48
    800009de:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    800009e0:	84aa                	mv	s1,a0
    800009e2:	6905                	lui	s2,0x1
    800009e4:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    800009e6:	4985                	li	s3,1
    800009e8:	a829                	j	80000a02 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009ea:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009ec:	00c79513          	slli	a0,a5,0xc
    800009f0:	00000097          	auipc	ra,0x0
    800009f4:	fde080e7          	jalr	-34(ra) # 800009ce <freewalk>
      pagetable[i] = 0;
    800009f8:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++) {
    800009fc:	04a1                	addi	s1,s1,8
    800009fe:	03248163          	beq	s1,s2,80000a20 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000a02:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000a04:	00f7f713          	andi	a4,a5,15
    80000a08:	ff3701e3          	beq	a4,s3,800009ea <freewalk+0x1c>
    } else if (pte & PTE_V) {
    80000a0c:	8b85                	andi	a5,a5,1
    80000a0e:	d7fd                	beqz	a5,800009fc <freewalk+0x2e>
      panic("freewalk: leaf");
    80000a10:	00008517          	auipc	a0,0x8
    80000a14:	72850513          	addi	a0,a0,1832 # 80009138 <etext+0x138>
    80000a18:	00006097          	auipc	ra,0x6
    80000a1c:	fc6080e7          	jalr	-58(ra) # 800069de <panic>
    }
  }
  kfree((void *)pagetable);
    80000a20:	8552                	mv	a0,s4
    80000a22:	fffff097          	auipc	ra,0xfffff
    80000a26:	5fa080e7          	jalr	1530(ra) # 8000001c <kfree>
}
    80000a2a:	70a2                	ld	ra,40(sp)
    80000a2c:	7402                	ld	s0,32(sp)
    80000a2e:	64e2                	ld	s1,24(sp)
    80000a30:	6942                	ld	s2,16(sp)
    80000a32:	69a2                	ld	s3,8(sp)
    80000a34:	6a02                	ld	s4,0(sp)
    80000a36:	6145                	addi	sp,sp,48
    80000a38:	8082                	ret

0000000080000a3a <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz) {
    80000a3a:	1101                	addi	sp,sp,-32
    80000a3c:	ec06                	sd	ra,24(sp)
    80000a3e:	e822                	sd	s0,16(sp)
    80000a40:	e426                	sd	s1,8(sp)
    80000a42:	1000                	addi	s0,sp,32
    80000a44:	84aa                	mv	s1,a0
  if (sz > 0) uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000a46:	e999                	bnez	a1,80000a5c <uvmfree+0x22>
  freewalk(pagetable);
    80000a48:	8526                	mv	a0,s1
    80000a4a:	00000097          	auipc	ra,0x0
    80000a4e:	f84080e7          	jalr	-124(ra) # 800009ce <freewalk>
}
    80000a52:	60e2                	ld	ra,24(sp)
    80000a54:	6442                	ld	s0,16(sp)
    80000a56:	64a2                	ld	s1,8(sp)
    80000a58:	6105                	addi	sp,sp,32
    80000a5a:	8082                	ret
  if (sz > 0) uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000a5c:	6785                	lui	a5,0x1
    80000a5e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a60:	95be                	add	a1,a1,a5
    80000a62:	4685                	li	a3,1
    80000a64:	00c5d613          	srli	a2,a1,0xc
    80000a68:	4581                	li	a1,0
    80000a6a:	00000097          	auipc	ra,0x0
    80000a6e:	d06080e7          	jalr	-762(ra) # 80000770 <uvmunmap>
    80000a72:	bfd9                	j	80000a48 <uvmfree+0xe>

0000000080000a74 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for (i = 0; i < sz; i += PGSIZE) {
    80000a74:	c679                	beqz	a2,80000b42 <uvmcopy+0xce>
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    80000a76:	715d                	addi	sp,sp,-80
    80000a78:	e486                	sd	ra,72(sp)
    80000a7a:	e0a2                	sd	s0,64(sp)
    80000a7c:	fc26                	sd	s1,56(sp)
    80000a7e:	f84a                	sd	s2,48(sp)
    80000a80:	f44e                	sd	s3,40(sp)
    80000a82:	f052                	sd	s4,32(sp)
    80000a84:	ec56                	sd	s5,24(sp)
    80000a86:	e85a                	sd	s6,16(sp)
    80000a88:	e45e                	sd	s7,8(sp)
    80000a8a:	0880                	addi	s0,sp,80
    80000a8c:	8b2a                	mv	s6,a0
    80000a8e:	8aae                	mv	s5,a1
    80000a90:	8a32                	mv	s4,a2
  for (i = 0; i < sz; i += PGSIZE) {
    80000a92:	4981                	li	s3,0
    if ((pte = walk(old, i, 0)) == 0) panic("uvmcopy: pte should exist");
    80000a94:	4601                	li	a2,0
    80000a96:	85ce                	mv	a1,s3
    80000a98:	855a                	mv	a0,s6
    80000a9a:	00000097          	auipc	ra,0x0
    80000a9e:	9d4080e7          	jalr	-1580(ra) # 8000046e <walk>
    80000aa2:	c531                	beqz	a0,80000aee <uvmcopy+0x7a>
    if ((*pte & PTE_V) == 0) panic("uvmcopy: page not present");
    80000aa4:	6118                	ld	a4,0(a0)
    80000aa6:	00177793          	andi	a5,a4,1
    80000aaa:	cbb1                	beqz	a5,80000afe <uvmcopy+0x8a>
    pa = PTE2PA(*pte);
    80000aac:	00a75593          	srli	a1,a4,0xa
    80000ab0:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000ab4:	3ff77493          	andi	s1,a4,1023
    if ((mem = kalloc()) == 0) goto err;
    80000ab8:	fffff097          	auipc	ra,0xfffff
    80000abc:	662080e7          	jalr	1634(ra) # 8000011a <kalloc>
    80000ac0:	892a                	mv	s2,a0
    80000ac2:	c939                	beqz	a0,80000b18 <uvmcopy+0xa4>
    memmove(mem, (char *)pa, PGSIZE);
    80000ac4:	6605                	lui	a2,0x1
    80000ac6:	85de                	mv	a1,s7
    80000ac8:	fffff097          	auipc	ra,0xfffff
    80000acc:	70e080e7          	jalr	1806(ra) # 800001d6 <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    80000ad0:	8726                	mv	a4,s1
    80000ad2:	86ca                	mv	a3,s2
    80000ad4:	6605                	lui	a2,0x1
    80000ad6:	85ce                	mv	a1,s3
    80000ad8:	8556                	mv	a0,s5
    80000ada:	00000097          	auipc	ra,0x0
    80000ade:	a7c080e7          	jalr	-1412(ra) # 80000556 <mappages>
    80000ae2:	e515                	bnez	a0,80000b0e <uvmcopy+0x9a>
  for (i = 0; i < sz; i += PGSIZE) {
    80000ae4:	6785                	lui	a5,0x1
    80000ae6:	99be                	add	s3,s3,a5
    80000ae8:	fb49e6e3          	bltu	s3,s4,80000a94 <uvmcopy+0x20>
    80000aec:	a081                	j	80000b2c <uvmcopy+0xb8>
    if ((pte = walk(old, i, 0)) == 0) panic("uvmcopy: pte should exist");
    80000aee:	00008517          	auipc	a0,0x8
    80000af2:	65a50513          	addi	a0,a0,1626 # 80009148 <etext+0x148>
    80000af6:	00006097          	auipc	ra,0x6
    80000afa:	ee8080e7          	jalr	-280(ra) # 800069de <panic>
    if ((*pte & PTE_V) == 0) panic("uvmcopy: page not present");
    80000afe:	00008517          	auipc	a0,0x8
    80000b02:	66a50513          	addi	a0,a0,1642 # 80009168 <etext+0x168>
    80000b06:	00006097          	auipc	ra,0x6
    80000b0a:	ed8080e7          	jalr	-296(ra) # 800069de <panic>
      kfree(mem);
    80000b0e:	854a                	mv	a0,s2
    80000b10:	fffff097          	auipc	ra,0xfffff
    80000b14:	50c080e7          	jalr	1292(ra) # 8000001c <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b18:	4685                	li	a3,1
    80000b1a:	00c9d613          	srli	a2,s3,0xc
    80000b1e:	4581                	li	a1,0
    80000b20:	8556                	mv	a0,s5
    80000b22:	00000097          	auipc	ra,0x0
    80000b26:	c4e080e7          	jalr	-946(ra) # 80000770 <uvmunmap>
  return -1;
    80000b2a:	557d                	li	a0,-1
}
    80000b2c:	60a6                	ld	ra,72(sp)
    80000b2e:	6406                	ld	s0,64(sp)
    80000b30:	74e2                	ld	s1,56(sp)
    80000b32:	7942                	ld	s2,48(sp)
    80000b34:	79a2                	ld	s3,40(sp)
    80000b36:	7a02                	ld	s4,32(sp)
    80000b38:	6ae2                	ld	s5,24(sp)
    80000b3a:	6b42                	ld	s6,16(sp)
    80000b3c:	6ba2                	ld	s7,8(sp)
    80000b3e:	6161                	addi	sp,sp,80
    80000b40:	8082                	ret
  return 0;
    80000b42:	4501                	li	a0,0
}
    80000b44:	8082                	ret

0000000080000b46 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va) {
    80000b46:	1141                	addi	sp,sp,-16
    80000b48:	e406                	sd	ra,8(sp)
    80000b4a:	e022                	sd	s0,0(sp)
    80000b4c:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80000b4e:	4601                	li	a2,0
    80000b50:	00000097          	auipc	ra,0x0
    80000b54:	91e080e7          	jalr	-1762(ra) # 8000046e <walk>
  if (pte == 0) panic("uvmclear");
    80000b58:	c901                	beqz	a0,80000b68 <uvmclear+0x22>
  *pte &= ~PTE_U;
    80000b5a:	611c                	ld	a5,0(a0)
    80000b5c:	9bbd                	andi	a5,a5,-17
    80000b5e:	e11c                	sd	a5,0(a0)
}
    80000b60:	60a2                	ld	ra,8(sp)
    80000b62:	6402                	ld	s0,0(sp)
    80000b64:	0141                	addi	sp,sp,16
    80000b66:	8082                	ret
  if (pte == 0) panic("uvmclear");
    80000b68:	00008517          	auipc	a0,0x8
    80000b6c:	62050513          	addi	a0,a0,1568 # 80009188 <etext+0x188>
    80000b70:	00006097          	auipc	ra,0x6
    80000b74:	e6e080e7          	jalr	-402(ra) # 800069de <panic>

0000000080000b78 <copyout>:
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
  uint64 n, va0, pa0;
  pte_t *pte;

  while (len > 0) {
    80000b78:	cac9                	beqz	a3,80000c0a <copyout+0x92>
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
    80000b7a:	711d                	addi	sp,sp,-96
    80000b7c:	ec86                	sd	ra,88(sp)
    80000b7e:	e8a2                	sd	s0,80(sp)
    80000b80:	e4a6                	sd	s1,72(sp)
    80000b82:	e0ca                	sd	s2,64(sp)
    80000b84:	fc4e                	sd	s3,56(sp)
    80000b86:	f852                	sd	s4,48(sp)
    80000b88:	f456                	sd	s5,40(sp)
    80000b8a:	f05a                	sd	s6,32(sp)
    80000b8c:	ec5e                	sd	s7,24(sp)
    80000b8e:	e862                	sd	s8,16(sp)
    80000b90:	e466                	sd	s9,8(sp)
    80000b92:	e06a                	sd	s10,0(sp)
    80000b94:	1080                	addi	s0,sp,96
    80000b96:	8baa                	mv	s7,a0
    80000b98:	8aae                	mv	s5,a1
    80000b9a:	8b32                	mv	s6,a2
    80000b9c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b9e:	74fd                	lui	s1,0xfffff
    80000ba0:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA) return -1;
    80000ba2:	57fd                	li	a5,-1
    80000ba4:	83e9                	srli	a5,a5,0x1a
    80000ba6:	0697e463          	bltu	a5,s1,80000c0e <copyout+0x96>
    pte = walk(pagetable, va0, 0);
    if (pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000baa:	4cd5                	li	s9,21
    80000bac:	6d05                	lui	s10,0x1
    if (va0 >= MAXVA) return -1;
    80000bae:	8c3e                	mv	s8,a5
    80000bb0:	a035                	j	80000bdc <copyout+0x64>
        (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000bb2:	83a9                	srli	a5,a5,0xa
    80000bb4:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if (n > len) n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000bb6:	409a8533          	sub	a0,s5,s1
    80000bba:	0009061b          	sext.w	a2,s2
    80000bbe:	85da                	mv	a1,s6
    80000bc0:	953e                	add	a0,a0,a5
    80000bc2:	fffff097          	auipc	ra,0xfffff
    80000bc6:	614080e7          	jalr	1556(ra) # 800001d6 <memmove>

    len -= n;
    80000bca:	412989b3          	sub	s3,s3,s2
    src += n;
    80000bce:	9b4a                	add	s6,s6,s2
  while (len > 0) {
    80000bd0:	02098b63          	beqz	s3,80000c06 <copyout+0x8e>
    if (va0 >= MAXVA) return -1;
    80000bd4:	034c6f63          	bltu	s8,s4,80000c12 <copyout+0x9a>
    va0 = PGROUNDDOWN(dstva);
    80000bd8:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    80000bda:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000bdc:	4601                	li	a2,0
    80000bde:	85a6                	mv	a1,s1
    80000be0:	855e                	mv	a0,s7
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	88c080e7          	jalr	-1908(ra) # 8000046e <walk>
    if (pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000bea:	c515                	beqz	a0,80000c16 <copyout+0x9e>
    80000bec:	611c                	ld	a5,0(a0)
    80000bee:	0157f713          	andi	a4,a5,21
    80000bf2:	05971163          	bne	a4,s9,80000c34 <copyout+0xbc>
    n = PGSIZE - (dstva - va0);
    80000bf6:	01a48a33          	add	s4,s1,s10
    80000bfa:	415a0933          	sub	s2,s4,s5
    80000bfe:	fb29fae3          	bgeu	s3,s2,80000bb2 <copyout+0x3a>
    80000c02:	894e                	mv	s2,s3
    80000c04:	b77d                	j	80000bb2 <copyout+0x3a>
  }
  return 0;
    80000c06:	4501                	li	a0,0
    80000c08:	a801                	j	80000c18 <copyout+0xa0>
    80000c0a:	4501                	li	a0,0
}
    80000c0c:	8082                	ret
    if (va0 >= MAXVA) return -1;
    80000c0e:	557d                	li	a0,-1
    80000c10:	a021                	j	80000c18 <copyout+0xa0>
    80000c12:	557d                	li	a0,-1
    80000c14:	a011                	j	80000c18 <copyout+0xa0>
      return -1;
    80000c16:	557d                	li	a0,-1
}
    80000c18:	60e6                	ld	ra,88(sp)
    80000c1a:	6446                	ld	s0,80(sp)
    80000c1c:	64a6                	ld	s1,72(sp)
    80000c1e:	6906                	ld	s2,64(sp)
    80000c20:	79e2                	ld	s3,56(sp)
    80000c22:	7a42                	ld	s4,48(sp)
    80000c24:	7aa2                	ld	s5,40(sp)
    80000c26:	7b02                	ld	s6,32(sp)
    80000c28:	6be2                	ld	s7,24(sp)
    80000c2a:	6c42                	ld	s8,16(sp)
    80000c2c:	6ca2                	ld	s9,8(sp)
    80000c2e:	6d02                	ld	s10,0(sp)
    80000c30:	6125                	addi	sp,sp,96
    80000c32:	8082                	ret
      return -1;
    80000c34:	557d                	li	a0,-1
    80000c36:	b7cd                	j	80000c18 <copyout+0xa0>

0000000080000c38 <copyin>:
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
  uint64 n, va0, pa0;

  while (len > 0) {
    80000c38:	caa5                	beqz	a3,80000ca8 <copyin+0x70>
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
    80000c3a:	715d                	addi	sp,sp,-80
    80000c3c:	e486                	sd	ra,72(sp)
    80000c3e:	e0a2                	sd	s0,64(sp)
    80000c40:	fc26                	sd	s1,56(sp)
    80000c42:	f84a                	sd	s2,48(sp)
    80000c44:	f44e                	sd	s3,40(sp)
    80000c46:	f052                	sd	s4,32(sp)
    80000c48:	ec56                	sd	s5,24(sp)
    80000c4a:	e85a                	sd	s6,16(sp)
    80000c4c:	e45e                	sd	s7,8(sp)
    80000c4e:	e062                	sd	s8,0(sp)
    80000c50:	0880                	addi	s0,sp,80
    80000c52:	8b2a                	mv	s6,a0
    80000c54:	8a2e                	mv	s4,a1
    80000c56:	8c32                	mv	s8,a2
    80000c58:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c5a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0) return -1;
    n = PGSIZE - (srcva - va0);
    80000c5c:	6a85                	lui	s5,0x1
    80000c5e:	a01d                	j	80000c84 <copyin+0x4c>
    if (n > len) n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c60:	018505b3          	add	a1,a0,s8
    80000c64:	0004861b          	sext.w	a2,s1
    80000c68:	412585b3          	sub	a1,a1,s2
    80000c6c:	8552                	mv	a0,s4
    80000c6e:	fffff097          	auipc	ra,0xfffff
    80000c72:	568080e7          	jalr	1384(ra) # 800001d6 <memmove>

    len -= n;
    80000c76:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c7a:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c7c:	01590c33          	add	s8,s2,s5
  while (len > 0) {
    80000c80:	02098263          	beqz	s3,80000ca4 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c84:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c88:	85ca                	mv	a1,s2
    80000c8a:	855a                	mv	a0,s6
    80000c8c:	00000097          	auipc	ra,0x0
    80000c90:	888080e7          	jalr	-1912(ra) # 80000514 <walkaddr>
    if (pa0 == 0) return -1;
    80000c94:	cd01                	beqz	a0,80000cac <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c96:	418904b3          	sub	s1,s2,s8
    80000c9a:	94d6                	add	s1,s1,s5
    80000c9c:	fc99f2e3          	bgeu	s3,s1,80000c60 <copyin+0x28>
    80000ca0:	84ce                	mv	s1,s3
    80000ca2:	bf7d                	j	80000c60 <copyin+0x28>
  }
  return 0;
    80000ca4:	4501                	li	a0,0
    80000ca6:	a021                	j	80000cae <copyin+0x76>
    80000ca8:	4501                	li	a0,0
}
    80000caa:	8082                	ret
    if (pa0 == 0) return -1;
    80000cac:	557d                	li	a0,-1
}
    80000cae:	60a6                	ld	ra,72(sp)
    80000cb0:	6406                	ld	s0,64(sp)
    80000cb2:	74e2                	ld	s1,56(sp)
    80000cb4:	7942                	ld	s2,48(sp)
    80000cb6:	79a2                	ld	s3,40(sp)
    80000cb8:	7a02                	ld	s4,32(sp)
    80000cba:	6ae2                	ld	s5,24(sp)
    80000cbc:	6b42                	ld	s6,16(sp)
    80000cbe:	6ba2                	ld	s7,8(sp)
    80000cc0:	6c02                	ld	s8,0(sp)
    80000cc2:	6161                	addi	sp,sp,80
    80000cc4:	8082                	ret

0000000080000cc6 <copyinstr>:
// Return 0 on success, -1 on error.
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0) {
    80000cc6:	c2dd                	beqz	a3,80000d6c <copyinstr+0xa6>
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
    80000cc8:	715d                	addi	sp,sp,-80
    80000cca:	e486                	sd	ra,72(sp)
    80000ccc:	e0a2                	sd	s0,64(sp)
    80000cce:	fc26                	sd	s1,56(sp)
    80000cd0:	f84a                	sd	s2,48(sp)
    80000cd2:	f44e                	sd	s3,40(sp)
    80000cd4:	f052                	sd	s4,32(sp)
    80000cd6:	ec56                	sd	s5,24(sp)
    80000cd8:	e85a                	sd	s6,16(sp)
    80000cda:	e45e                	sd	s7,8(sp)
    80000cdc:	0880                	addi	s0,sp,80
    80000cde:	8a2a                	mv	s4,a0
    80000ce0:	8b2e                	mv	s6,a1
    80000ce2:	8bb2                	mv	s7,a2
    80000ce4:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000ce6:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0) return -1;
    n = PGSIZE - (srcva - va0);
    80000ce8:	6985                	lui	s3,0x1
    80000cea:	a02d                	j	80000d14 <copyinstr+0x4e>
    if (n > max) n = max;

    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0) {
      if (*p == '\0') {
        *dst = '\0';
    80000cec:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000cf0:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null) {
    80000cf2:	37fd                	addiw	a5,a5,-1
    80000cf4:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cf8:	60a6                	ld	ra,72(sp)
    80000cfa:	6406                	ld	s0,64(sp)
    80000cfc:	74e2                	ld	s1,56(sp)
    80000cfe:	7942                	ld	s2,48(sp)
    80000d00:	79a2                	ld	s3,40(sp)
    80000d02:	7a02                	ld	s4,32(sp)
    80000d04:	6ae2                	ld	s5,24(sp)
    80000d06:	6b42                	ld	s6,16(sp)
    80000d08:	6ba2                	ld	s7,8(sp)
    80000d0a:	6161                	addi	sp,sp,80
    80000d0c:	8082                	ret
    srcva = va0 + PGSIZE;
    80000d0e:	01390bb3          	add	s7,s2,s3
  while (got_null == 0 && max > 0) {
    80000d12:	c8a9                	beqz	s1,80000d64 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000d14:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d18:	85ca                	mv	a1,s2
    80000d1a:	8552                	mv	a0,s4
    80000d1c:	fffff097          	auipc	ra,0xfffff
    80000d20:	7f8080e7          	jalr	2040(ra) # 80000514 <walkaddr>
    if (pa0 == 0) return -1;
    80000d24:	c131                	beqz	a0,80000d68 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000d26:	417906b3          	sub	a3,s2,s7
    80000d2a:	96ce                	add	a3,a3,s3
    80000d2c:	00d4f363          	bgeu	s1,a3,80000d32 <copyinstr+0x6c>
    80000d30:	86a6                	mv	a3,s1
    char *p = (char *)(pa0 + (srcva - va0));
    80000d32:	955e                	add	a0,a0,s7
    80000d34:	41250533          	sub	a0,a0,s2
    while (n > 0) {
    80000d38:	daf9                	beqz	a3,80000d0e <copyinstr+0x48>
    80000d3a:	87da                	mv	a5,s6
      if (*p == '\0') {
    80000d3c:	41650633          	sub	a2,a0,s6
    80000d40:	fff48593          	addi	a1,s1,-1 # ffffffffffffefff <end+0xffffffff7ff0bc4f>
    80000d44:	95da                	add	a1,a1,s6
    while (n > 0) {
    80000d46:	96da                	add	a3,a3,s6
      if (*p == '\0') {
    80000d48:	00f60733          	add	a4,a2,a5
    80000d4c:	00074703          	lbu	a4,0(a4)
    80000d50:	df51                	beqz	a4,80000cec <copyinstr+0x26>
        *dst = *p;
    80000d52:	00e78023          	sb	a4,0(a5)
      --max;
    80000d56:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000d5a:	0785                	addi	a5,a5,1
    while (n > 0) {
    80000d5c:	fed796e3          	bne	a5,a3,80000d48 <copyinstr+0x82>
      dst++;
    80000d60:	8b3e                	mv	s6,a5
    80000d62:	b775                	j	80000d0e <copyinstr+0x48>
    80000d64:	4781                	li	a5,0
    80000d66:	b771                	j	80000cf2 <copyinstr+0x2c>
    if (pa0 == 0) return -1;
    80000d68:	557d                	li	a0,-1
    80000d6a:	b779                	j	80000cf8 <copyinstr+0x32>
  int got_null = 0;
    80000d6c:	4781                	li	a5,0
  if (got_null) {
    80000d6e:	37fd                	addiw	a5,a5,-1
    80000d70:	0007851b          	sext.w	a0,a5
}
    80000d74:	8082                	ret

0000000080000d76 <proc_mapstacks>:
struct spinlock wait_lock;

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl) {
    80000d76:	7139                	addi	sp,sp,-64
    80000d78:	fc06                	sd	ra,56(sp)
    80000d7a:	f822                	sd	s0,48(sp)
    80000d7c:	f426                	sd	s1,40(sp)
    80000d7e:	f04a                	sd	s2,32(sp)
    80000d80:	ec4e                	sd	s3,24(sp)
    80000d82:	e852                	sd	s4,16(sp)
    80000d84:	e456                	sd	s5,8(sp)
    80000d86:	e05a                	sd	s6,0(sp)
    80000d88:	0080                	addi	s0,sp,64
    80000d8a:	89aa                	mv	s3,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80000d8c:	00009497          	auipc	s1,0x9
    80000d90:	11448493          	addi	s1,s1,276 # 80009ea0 <proc>
    char *pa = kalloc();
    if (pa == 0) panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80000d94:	8b26                	mv	s6,s1
    80000d96:	00008a97          	auipc	s5,0x8
    80000d9a:	26aa8a93          	addi	s5,s5,618 # 80009000 <etext>
    80000d9e:	04000937          	lui	s2,0x4000
    80000da2:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000da4:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80000da6:	0000fa17          	auipc	s4,0xf
    80000daa:	afaa0a13          	addi	s4,s4,-1286 # 8000f8a0 <tickslock>
    char *pa = kalloc();
    80000dae:	fffff097          	auipc	ra,0xfffff
    80000db2:	36c080e7          	jalr	876(ra) # 8000011a <kalloc>
    80000db6:	862a                	mv	a2,a0
    if (pa == 0) panic("kalloc");
    80000db8:	c131                	beqz	a0,80000dfc <proc_mapstacks+0x86>
    uint64 va = KSTACK((int)(p - proc));
    80000dba:	416485b3          	sub	a1,s1,s6
    80000dbe:	858d                	srai	a1,a1,0x3
    80000dc0:	000ab783          	ld	a5,0(s5)
    80000dc4:	02f585b3          	mul	a1,a1,a5
    80000dc8:	2585                	addiw	a1,a1,1
    80000dca:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000dce:	4719                	li	a4,6
    80000dd0:	6685                	lui	a3,0x1
    80000dd2:	40b905b3          	sub	a1,s2,a1
    80000dd6:	854e                	mv	a0,s3
    80000dd8:	00000097          	auipc	ra,0x0
    80000ddc:	842080e7          	jalr	-1982(ra) # 8000061a <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    80000de0:	16848493          	addi	s1,s1,360
    80000de4:	fd4495e3          	bne	s1,s4,80000dae <proc_mapstacks+0x38>
  }
}
    80000de8:	70e2                	ld	ra,56(sp)
    80000dea:	7442                	ld	s0,48(sp)
    80000dec:	74a2                	ld	s1,40(sp)
    80000dee:	7902                	ld	s2,32(sp)
    80000df0:	69e2                	ld	s3,24(sp)
    80000df2:	6a42                	ld	s4,16(sp)
    80000df4:	6aa2                	ld	s5,8(sp)
    80000df6:	6b02                	ld	s6,0(sp)
    80000df8:	6121                	addi	sp,sp,64
    80000dfa:	8082                	ret
    if (pa == 0) panic("kalloc");
    80000dfc:	00008517          	auipc	a0,0x8
    80000e00:	39c50513          	addi	a0,a0,924 # 80009198 <etext+0x198>
    80000e04:	00006097          	auipc	ra,0x6
    80000e08:	bda080e7          	jalr	-1062(ra) # 800069de <panic>

0000000080000e0c <procinit>:

// initialize the proc table.
void procinit(void) {
    80000e0c:	7139                	addi	sp,sp,-64
    80000e0e:	fc06                	sd	ra,56(sp)
    80000e10:	f822                	sd	s0,48(sp)
    80000e12:	f426                	sd	s1,40(sp)
    80000e14:	f04a                	sd	s2,32(sp)
    80000e16:	ec4e                	sd	s3,24(sp)
    80000e18:	e852                	sd	s4,16(sp)
    80000e1a:	e456                	sd	s5,8(sp)
    80000e1c:	e05a                	sd	s6,0(sp)
    80000e1e:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80000e20:	00008597          	auipc	a1,0x8
    80000e24:	38058593          	addi	a1,a1,896 # 800091a0 <etext+0x1a0>
    80000e28:	00009517          	auipc	a0,0x9
    80000e2c:	c4850513          	addi	a0,a0,-952 # 80009a70 <pid_lock>
    80000e30:	00006097          	auipc	ra,0x6
    80000e34:	056080e7          	jalr	86(ra) # 80006e86 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e38:	00008597          	auipc	a1,0x8
    80000e3c:	37058593          	addi	a1,a1,880 # 800091a8 <etext+0x1a8>
    80000e40:	00009517          	auipc	a0,0x9
    80000e44:	c4850513          	addi	a0,a0,-952 # 80009a88 <wait_lock>
    80000e48:	00006097          	auipc	ra,0x6
    80000e4c:	03e080e7          	jalr	62(ra) # 80006e86 <initlock>
  for (p = proc; p < &proc[NPROC]; p++) {
    80000e50:	00009497          	auipc	s1,0x9
    80000e54:	05048493          	addi	s1,s1,80 # 80009ea0 <proc>
    initlock(&p->lock, "proc");
    80000e58:	00008b17          	auipc	s6,0x8
    80000e5c:	360b0b13          	addi	s6,s6,864 # 800091b8 <etext+0x1b8>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80000e60:	8aa6                	mv	s5,s1
    80000e62:	00008a17          	auipc	s4,0x8
    80000e66:	19ea0a13          	addi	s4,s4,414 # 80009000 <etext>
    80000e6a:	04000937          	lui	s2,0x4000
    80000e6e:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000e70:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80000e72:	0000f997          	auipc	s3,0xf
    80000e76:	a2e98993          	addi	s3,s3,-1490 # 8000f8a0 <tickslock>
    initlock(&p->lock, "proc");
    80000e7a:	85da                	mv	a1,s6
    80000e7c:	8526                	mv	a0,s1
    80000e7e:	00006097          	auipc	ra,0x6
    80000e82:	008080e7          	jalr	8(ra) # 80006e86 <initlock>
    p->state = UNUSED;
    80000e86:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80000e8a:	415487b3          	sub	a5,s1,s5
    80000e8e:	878d                	srai	a5,a5,0x3
    80000e90:	000a3703          	ld	a4,0(s4)
    80000e94:	02e787b3          	mul	a5,a5,a4
    80000e98:	2785                	addiw	a5,a5,1
    80000e9a:	00d7979b          	slliw	a5,a5,0xd
    80000e9e:	40f907b3          	sub	a5,s2,a5
    80000ea2:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    80000ea4:	16848493          	addi	s1,s1,360
    80000ea8:	fd3499e3          	bne	s1,s3,80000e7a <procinit+0x6e>
  }
}
    80000eac:	70e2                	ld	ra,56(sp)
    80000eae:	7442                	ld	s0,48(sp)
    80000eb0:	74a2                	ld	s1,40(sp)
    80000eb2:	7902                	ld	s2,32(sp)
    80000eb4:	69e2                	ld	s3,24(sp)
    80000eb6:	6a42                	ld	s4,16(sp)
    80000eb8:	6aa2                	ld	s5,8(sp)
    80000eba:	6b02                	ld	s6,0(sp)
    80000ebc:	6121                	addi	sp,sp,64
    80000ebe:	8082                	ret

0000000080000ec0 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid() {
    80000ec0:	1141                	addi	sp,sp,-16
    80000ec2:	e422                	sd	s0,8(sp)
    80000ec4:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    80000ec6:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000ec8:	2501                	sext.w	a0,a0
    80000eca:	6422                	ld	s0,8(sp)
    80000ecc:	0141                	addi	sp,sp,16
    80000ece:	8082                	ret

0000000080000ed0 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *mycpu(void) {
    80000ed0:	1141                	addi	sp,sp,-16
    80000ed2:	e422                	sd	s0,8(sp)
    80000ed4:	0800                	addi	s0,sp,16
    80000ed6:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000ed8:	2781                	sext.w	a5,a5
    80000eda:	079e                	slli	a5,a5,0x7
  return c;
}
    80000edc:	00009517          	auipc	a0,0x9
    80000ee0:	bc450513          	addi	a0,a0,-1084 # 80009aa0 <cpus>
    80000ee4:	953e                	add	a0,a0,a5
    80000ee6:	6422                	ld	s0,8(sp)
    80000ee8:	0141                	addi	sp,sp,16
    80000eea:	8082                	ret

0000000080000eec <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *myproc(void) {
    80000eec:	1101                	addi	sp,sp,-32
    80000eee:	ec06                	sd	ra,24(sp)
    80000ef0:	e822                	sd	s0,16(sp)
    80000ef2:	e426                	sd	s1,8(sp)
    80000ef4:	1000                	addi	s0,sp,32
  push_off();
    80000ef6:	00006097          	auipc	ra,0x6
    80000efa:	fd4080e7          	jalr	-44(ra) # 80006eca <push_off>
    80000efe:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f00:	2781                	sext.w	a5,a5
    80000f02:	079e                	slli	a5,a5,0x7
    80000f04:	00009717          	auipc	a4,0x9
    80000f08:	b6c70713          	addi	a4,a4,-1172 # 80009a70 <pid_lock>
    80000f0c:	97ba                	add	a5,a5,a4
    80000f0e:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f10:	00006097          	auipc	ra,0x6
    80000f14:	05a080e7          	jalr	90(ra) # 80006f6a <pop_off>
  return p;
}
    80000f18:	8526                	mv	a0,s1
    80000f1a:	60e2                	ld	ra,24(sp)
    80000f1c:	6442                	ld	s0,16(sp)
    80000f1e:	64a2                	ld	s1,8(sp)
    80000f20:	6105                	addi	sp,sp,32
    80000f22:	8082                	ret

0000000080000f24 <forkret>:
  release(&p->lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void) {
    80000f24:	1141                	addi	sp,sp,-16
    80000f26:	e406                	sd	ra,8(sp)
    80000f28:	e022                	sd	s0,0(sp)
    80000f2a:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f2c:	00000097          	auipc	ra,0x0
    80000f30:	fc0080e7          	jalr	-64(ra) # 80000eec <myproc>
    80000f34:	00006097          	auipc	ra,0x6
    80000f38:	096080e7          	jalr	150(ra) # 80006fca <release>

  if (first) {
    80000f3c:	00009797          	auipc	a5,0x9
    80000f40:	a447a783          	lw	a5,-1468(a5) # 80009980 <first.1>
    80000f44:	eb89                	bnez	a5,80000f56 <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000f46:	00001097          	auipc	ra,0x1
    80000f4a:	c60080e7          	jalr	-928(ra) # 80001ba6 <usertrapret>
}
    80000f4e:	60a2                	ld	ra,8(sp)
    80000f50:	6402                	ld	s0,0(sp)
    80000f52:	0141                	addi	sp,sp,16
    80000f54:	8082                	ret
    fsinit(ROOTDEV);
    80000f56:	4505                	li	a0,1
    80000f58:	00002097          	auipc	ra,0x2
    80000f5c:	9ba080e7          	jalr	-1606(ra) # 80002912 <fsinit>
    first = 0;
    80000f60:	00009797          	auipc	a5,0x9
    80000f64:	a207a023          	sw	zero,-1504(a5) # 80009980 <first.1>
    __sync_synchronize();
    80000f68:	0ff0000f          	fence
    80000f6c:	bfe9                	j	80000f46 <forkret+0x22>

0000000080000f6e <allocpid>:
int allocpid() {
    80000f6e:	1101                	addi	sp,sp,-32
    80000f70:	ec06                	sd	ra,24(sp)
    80000f72:	e822                	sd	s0,16(sp)
    80000f74:	e426                	sd	s1,8(sp)
    80000f76:	e04a                	sd	s2,0(sp)
    80000f78:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f7a:	00009917          	auipc	s2,0x9
    80000f7e:	af690913          	addi	s2,s2,-1290 # 80009a70 <pid_lock>
    80000f82:	854a                	mv	a0,s2
    80000f84:	00006097          	auipc	ra,0x6
    80000f88:	f92080e7          	jalr	-110(ra) # 80006f16 <acquire>
  pid = nextpid;
    80000f8c:	00009797          	auipc	a5,0x9
    80000f90:	9f878793          	addi	a5,a5,-1544 # 80009984 <nextpid>
    80000f94:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f96:	0014871b          	addiw	a4,s1,1
    80000f9a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f9c:	854a                	mv	a0,s2
    80000f9e:	00006097          	auipc	ra,0x6
    80000fa2:	02c080e7          	jalr	44(ra) # 80006fca <release>
}
    80000fa6:	8526                	mv	a0,s1
    80000fa8:	60e2                	ld	ra,24(sp)
    80000faa:	6442                	ld	s0,16(sp)
    80000fac:	64a2                	ld	s1,8(sp)
    80000fae:	6902                	ld	s2,0(sp)
    80000fb0:	6105                	addi	sp,sp,32
    80000fb2:	8082                	ret

0000000080000fb4 <proc_pagetable>:
pagetable_t proc_pagetable(struct proc *p) {
    80000fb4:	1101                	addi	sp,sp,-32
    80000fb6:	ec06                	sd	ra,24(sp)
    80000fb8:	e822                	sd	s0,16(sp)
    80000fba:	e426                	sd	s1,8(sp)
    80000fbc:	e04a                	sd	s2,0(sp)
    80000fbe:	1000                	addi	s0,sp,32
    80000fc0:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000fc2:	00000097          	auipc	ra,0x0
    80000fc6:	872080e7          	jalr	-1934(ra) # 80000834 <uvmcreate>
    80000fca:	84aa                	mv	s1,a0
  if (pagetable == 0) return 0;
    80000fcc:	c121                	beqz	a0,8000100c <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    80000fce:	4729                	li	a4,10
    80000fd0:	00007697          	auipc	a3,0x7
    80000fd4:	03068693          	addi	a3,a3,48 # 80008000 <_trampoline>
    80000fd8:	6605                	lui	a2,0x1
    80000fda:	040005b7          	lui	a1,0x4000
    80000fde:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fe0:	05b2                	slli	a1,a1,0xc
    80000fe2:	fffff097          	auipc	ra,0xfffff
    80000fe6:	574080e7          	jalr	1396(ra) # 80000556 <mappages>
    80000fea:	02054863          	bltz	a0,8000101a <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80000fee:	4719                	li	a4,6
    80000ff0:	05893683          	ld	a3,88(s2)
    80000ff4:	6605                	lui	a2,0x1
    80000ff6:	020005b7          	lui	a1,0x2000
    80000ffa:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000ffc:	05b6                	slli	a1,a1,0xd
    80000ffe:	8526                	mv	a0,s1
    80001000:	fffff097          	auipc	ra,0xfffff
    80001004:	556080e7          	jalr	1366(ra) # 80000556 <mappages>
    80001008:	02054163          	bltz	a0,8000102a <proc_pagetable+0x76>
}
    8000100c:	8526                	mv	a0,s1
    8000100e:	60e2                	ld	ra,24(sp)
    80001010:	6442                	ld	s0,16(sp)
    80001012:	64a2                	ld	s1,8(sp)
    80001014:	6902                	ld	s2,0(sp)
    80001016:	6105                	addi	sp,sp,32
    80001018:	8082                	ret
    uvmfree(pagetable, 0);
    8000101a:	4581                	li	a1,0
    8000101c:	8526                	mv	a0,s1
    8000101e:	00000097          	auipc	ra,0x0
    80001022:	a1c080e7          	jalr	-1508(ra) # 80000a3a <uvmfree>
    return 0;
    80001026:	4481                	li	s1,0
    80001028:	b7d5                	j	8000100c <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000102a:	4681                	li	a3,0
    8000102c:	4605                	li	a2,1
    8000102e:	040005b7          	lui	a1,0x4000
    80001032:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001034:	05b2                	slli	a1,a1,0xc
    80001036:	8526                	mv	a0,s1
    80001038:	fffff097          	auipc	ra,0xfffff
    8000103c:	738080e7          	jalr	1848(ra) # 80000770 <uvmunmap>
    uvmfree(pagetable, 0);
    80001040:	4581                	li	a1,0
    80001042:	8526                	mv	a0,s1
    80001044:	00000097          	auipc	ra,0x0
    80001048:	9f6080e7          	jalr	-1546(ra) # 80000a3a <uvmfree>
    return 0;
    8000104c:	4481                	li	s1,0
    8000104e:	bf7d                	j	8000100c <proc_pagetable+0x58>

0000000080001050 <proc_freepagetable>:
void proc_freepagetable(pagetable_t pagetable, uint64 sz) {
    80001050:	1101                	addi	sp,sp,-32
    80001052:	ec06                	sd	ra,24(sp)
    80001054:	e822                	sd	s0,16(sp)
    80001056:	e426                	sd	s1,8(sp)
    80001058:	e04a                	sd	s2,0(sp)
    8000105a:	1000                	addi	s0,sp,32
    8000105c:	84aa                	mv	s1,a0
    8000105e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001060:	4681                	li	a3,0
    80001062:	4605                	li	a2,1
    80001064:	040005b7          	lui	a1,0x4000
    80001068:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000106a:	05b2                	slli	a1,a1,0xc
    8000106c:	fffff097          	auipc	ra,0xfffff
    80001070:	704080e7          	jalr	1796(ra) # 80000770 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001074:	4681                	li	a3,0
    80001076:	4605                	li	a2,1
    80001078:	020005b7          	lui	a1,0x2000
    8000107c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000107e:	05b6                	slli	a1,a1,0xd
    80001080:	8526                	mv	a0,s1
    80001082:	fffff097          	auipc	ra,0xfffff
    80001086:	6ee080e7          	jalr	1774(ra) # 80000770 <uvmunmap>
  uvmfree(pagetable, sz);
    8000108a:	85ca                	mv	a1,s2
    8000108c:	8526                	mv	a0,s1
    8000108e:	00000097          	auipc	ra,0x0
    80001092:	9ac080e7          	jalr	-1620(ra) # 80000a3a <uvmfree>
}
    80001096:	60e2                	ld	ra,24(sp)
    80001098:	6442                	ld	s0,16(sp)
    8000109a:	64a2                	ld	s1,8(sp)
    8000109c:	6902                	ld	s2,0(sp)
    8000109e:	6105                	addi	sp,sp,32
    800010a0:	8082                	ret

00000000800010a2 <freeproc>:
static void freeproc(struct proc *p) {
    800010a2:	1101                	addi	sp,sp,-32
    800010a4:	ec06                	sd	ra,24(sp)
    800010a6:	e822                	sd	s0,16(sp)
    800010a8:	e426                	sd	s1,8(sp)
    800010aa:	1000                	addi	s0,sp,32
    800010ac:	84aa                	mv	s1,a0
  if (p->trapframe) kfree((void *)p->trapframe);
    800010ae:	6d28                	ld	a0,88(a0)
    800010b0:	c509                	beqz	a0,800010ba <freeproc+0x18>
    800010b2:	fffff097          	auipc	ra,0xfffff
    800010b6:	f6a080e7          	jalr	-150(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800010ba:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable) proc_freepagetable(p->pagetable, p->sz);
    800010be:	68a8                	ld	a0,80(s1)
    800010c0:	c511                	beqz	a0,800010cc <freeproc+0x2a>
    800010c2:	64ac                	ld	a1,72(s1)
    800010c4:	00000097          	auipc	ra,0x0
    800010c8:	f8c080e7          	jalr	-116(ra) # 80001050 <proc_freepagetable>
  p->pagetable = 0;
    800010cc:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800010d0:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800010d4:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800010d8:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800010dc:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800010e0:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800010e4:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800010e8:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800010ec:	0004ac23          	sw	zero,24(s1)
}
    800010f0:	60e2                	ld	ra,24(sp)
    800010f2:	6442                	ld	s0,16(sp)
    800010f4:	64a2                	ld	s1,8(sp)
    800010f6:	6105                	addi	sp,sp,32
    800010f8:	8082                	ret

00000000800010fa <allocproc>:
static struct proc *allocproc(void) {
    800010fa:	1101                	addi	sp,sp,-32
    800010fc:	ec06                	sd	ra,24(sp)
    800010fe:	e822                	sd	s0,16(sp)
    80001100:	e426                	sd	s1,8(sp)
    80001102:	e04a                	sd	s2,0(sp)
    80001104:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    80001106:	00009497          	auipc	s1,0x9
    8000110a:	d9a48493          	addi	s1,s1,-614 # 80009ea0 <proc>
    8000110e:	0000e917          	auipc	s2,0xe
    80001112:	79290913          	addi	s2,s2,1938 # 8000f8a0 <tickslock>
    acquire(&p->lock);
    80001116:	8526                	mv	a0,s1
    80001118:	00006097          	auipc	ra,0x6
    8000111c:	dfe080e7          	jalr	-514(ra) # 80006f16 <acquire>
    if (p->state == UNUSED) {
    80001120:	4c9c                	lw	a5,24(s1)
    80001122:	cf81                	beqz	a5,8000113a <allocproc+0x40>
      release(&p->lock);
    80001124:	8526                	mv	a0,s1
    80001126:	00006097          	auipc	ra,0x6
    8000112a:	ea4080e7          	jalr	-348(ra) # 80006fca <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000112e:	16848493          	addi	s1,s1,360
    80001132:	ff2492e3          	bne	s1,s2,80001116 <allocproc+0x1c>
  return 0;
    80001136:	4481                	li	s1,0
    80001138:	a889                	j	8000118a <allocproc+0x90>
  p->pid = allocpid();
    8000113a:	00000097          	auipc	ra,0x0
    8000113e:	e34080e7          	jalr	-460(ra) # 80000f6e <allocpid>
    80001142:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001144:	4785                	li	a5,1
    80001146:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    80001148:	fffff097          	auipc	ra,0xfffff
    8000114c:	fd2080e7          	jalr	-46(ra) # 8000011a <kalloc>
    80001150:	892a                	mv	s2,a0
    80001152:	eca8                	sd	a0,88(s1)
    80001154:	c131                	beqz	a0,80001198 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001156:	8526                	mv	a0,s1
    80001158:	00000097          	auipc	ra,0x0
    8000115c:	e5c080e7          	jalr	-420(ra) # 80000fb4 <proc_pagetable>
    80001160:	892a                	mv	s2,a0
    80001162:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    80001164:	c531                	beqz	a0,800011b0 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001166:	07000613          	li	a2,112
    8000116a:	4581                	li	a1,0
    8000116c:	06048513          	addi	a0,s1,96
    80001170:	fffff097          	auipc	ra,0xfffff
    80001174:	00a080e7          	jalr	10(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    80001178:	00000797          	auipc	a5,0x0
    8000117c:	dac78793          	addi	a5,a5,-596 # 80000f24 <forkret>
    80001180:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001182:	60bc                	ld	a5,64(s1)
    80001184:	6705                	lui	a4,0x1
    80001186:	97ba                	add	a5,a5,a4
    80001188:	f4bc                	sd	a5,104(s1)
}
    8000118a:	8526                	mv	a0,s1
    8000118c:	60e2                	ld	ra,24(sp)
    8000118e:	6442                	ld	s0,16(sp)
    80001190:	64a2                	ld	s1,8(sp)
    80001192:	6902                	ld	s2,0(sp)
    80001194:	6105                	addi	sp,sp,32
    80001196:	8082                	ret
    freeproc(p);
    80001198:	8526                	mv	a0,s1
    8000119a:	00000097          	auipc	ra,0x0
    8000119e:	f08080e7          	jalr	-248(ra) # 800010a2 <freeproc>
    release(&p->lock);
    800011a2:	8526                	mv	a0,s1
    800011a4:	00006097          	auipc	ra,0x6
    800011a8:	e26080e7          	jalr	-474(ra) # 80006fca <release>
    return 0;
    800011ac:	84ca                	mv	s1,s2
    800011ae:	bff1                	j	8000118a <allocproc+0x90>
    freeproc(p);
    800011b0:	8526                	mv	a0,s1
    800011b2:	00000097          	auipc	ra,0x0
    800011b6:	ef0080e7          	jalr	-272(ra) # 800010a2 <freeproc>
    release(&p->lock);
    800011ba:	8526                	mv	a0,s1
    800011bc:	00006097          	auipc	ra,0x6
    800011c0:	e0e080e7          	jalr	-498(ra) # 80006fca <release>
    return 0;
    800011c4:	84ca                	mv	s1,s2
    800011c6:	b7d1                	j	8000118a <allocproc+0x90>

00000000800011c8 <userinit>:
void userinit(void) {
    800011c8:	1101                	addi	sp,sp,-32
    800011ca:	ec06                	sd	ra,24(sp)
    800011cc:	e822                	sd	s0,16(sp)
    800011ce:	e426                	sd	s1,8(sp)
    800011d0:	1000                	addi	s0,sp,32
  p = allocproc();
    800011d2:	00000097          	auipc	ra,0x0
    800011d6:	f28080e7          	jalr	-216(ra) # 800010fa <allocproc>
    800011da:	84aa                	mv	s1,a0
  initproc = p;
    800011dc:	00009797          	auipc	a5,0x9
    800011e0:	82a7ba23          	sd	a0,-1996(a5) # 80009a10 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800011e4:	03400613          	li	a2,52
    800011e8:	00008597          	auipc	a1,0x8
    800011ec:	7b858593          	addi	a1,a1,1976 # 800099a0 <initcode>
    800011f0:	6928                	ld	a0,80(a0)
    800011f2:	fffff097          	auipc	ra,0xfffff
    800011f6:	670080e7          	jalr	1648(ra) # 80000862 <uvmfirst>
  p->sz = PGSIZE;
    800011fa:	6785                	lui	a5,0x1
    800011fc:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011fe:	6cb8                	ld	a4,88(s1)
    80001200:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001204:	6cb8                	ld	a4,88(s1)
    80001206:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001208:	4641                	li	a2,16
    8000120a:	00008597          	auipc	a1,0x8
    8000120e:	fb658593          	addi	a1,a1,-74 # 800091c0 <etext+0x1c0>
    80001212:	15848513          	addi	a0,s1,344
    80001216:	fffff097          	auipc	ra,0xfffff
    8000121a:	0ae080e7          	jalr	174(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    8000121e:	00008517          	auipc	a0,0x8
    80001222:	fb250513          	addi	a0,a0,-78 # 800091d0 <etext+0x1d0>
    80001226:	00002097          	auipc	ra,0x2
    8000122a:	116080e7          	jalr	278(ra) # 8000333c <namei>
    8000122e:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001232:	478d                	li	a5,3
    80001234:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001236:	8526                	mv	a0,s1
    80001238:	00006097          	auipc	ra,0x6
    8000123c:	d92080e7          	jalr	-622(ra) # 80006fca <release>
}
    80001240:	60e2                	ld	ra,24(sp)
    80001242:	6442                	ld	s0,16(sp)
    80001244:	64a2                	ld	s1,8(sp)
    80001246:	6105                	addi	sp,sp,32
    80001248:	8082                	ret

000000008000124a <growproc>:
int growproc(int n) {
    8000124a:	1101                	addi	sp,sp,-32
    8000124c:	ec06                	sd	ra,24(sp)
    8000124e:	e822                	sd	s0,16(sp)
    80001250:	e426                	sd	s1,8(sp)
    80001252:	e04a                	sd	s2,0(sp)
    80001254:	1000                	addi	s0,sp,32
    80001256:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001258:	00000097          	auipc	ra,0x0
    8000125c:	c94080e7          	jalr	-876(ra) # 80000eec <myproc>
    80001260:	84aa                	mv	s1,a0
  sz = p->sz;
    80001262:	652c                	ld	a1,72(a0)
  if (n > 0) {
    80001264:	01204c63          	bgtz	s2,8000127c <growproc+0x32>
  } else if (n < 0) {
    80001268:	02094663          	bltz	s2,80001294 <growproc+0x4a>
  p->sz = sz;
    8000126c:	e4ac                	sd	a1,72(s1)
  return 0;
    8000126e:	4501                	li	a0,0
}
    80001270:	60e2                	ld	ra,24(sp)
    80001272:	6442                	ld	s0,16(sp)
    80001274:	64a2                	ld	s1,8(sp)
    80001276:	6902                	ld	s2,0(sp)
    80001278:	6105                	addi	sp,sp,32
    8000127a:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000127c:	4691                	li	a3,4
    8000127e:	00b90633          	add	a2,s2,a1
    80001282:	6928                	ld	a0,80(a0)
    80001284:	fffff097          	auipc	ra,0xfffff
    80001288:	698080e7          	jalr	1688(ra) # 8000091c <uvmalloc>
    8000128c:	85aa                	mv	a1,a0
    8000128e:	fd79                	bnez	a0,8000126c <growproc+0x22>
      return -1;
    80001290:	557d                	li	a0,-1
    80001292:	bff9                	j	80001270 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001294:	00b90633          	add	a2,s2,a1
    80001298:	6928                	ld	a0,80(a0)
    8000129a:	fffff097          	auipc	ra,0xfffff
    8000129e:	63a080e7          	jalr	1594(ra) # 800008d4 <uvmdealloc>
    800012a2:	85aa                	mv	a1,a0
    800012a4:	b7e1                	j	8000126c <growproc+0x22>

00000000800012a6 <fork>:
int fork(void) {
    800012a6:	7139                	addi	sp,sp,-64
    800012a8:	fc06                	sd	ra,56(sp)
    800012aa:	f822                	sd	s0,48(sp)
    800012ac:	f426                	sd	s1,40(sp)
    800012ae:	f04a                	sd	s2,32(sp)
    800012b0:	ec4e                	sd	s3,24(sp)
    800012b2:	e852                	sd	s4,16(sp)
    800012b4:	e456                	sd	s5,8(sp)
    800012b6:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800012b8:	00000097          	auipc	ra,0x0
    800012bc:	c34080e7          	jalr	-972(ra) # 80000eec <myproc>
    800012c0:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    800012c2:	00000097          	auipc	ra,0x0
    800012c6:	e38080e7          	jalr	-456(ra) # 800010fa <allocproc>
    800012ca:	10050c63          	beqz	a0,800013e2 <fork+0x13c>
    800012ce:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    800012d0:	048ab603          	ld	a2,72(s5)
    800012d4:	692c                	ld	a1,80(a0)
    800012d6:	050ab503          	ld	a0,80(s5)
    800012da:	fffff097          	auipc	ra,0xfffff
    800012de:	79a080e7          	jalr	1946(ra) # 80000a74 <uvmcopy>
    800012e2:	04054863          	bltz	a0,80001332 <fork+0x8c>
  np->sz = p->sz;
    800012e6:	048ab783          	ld	a5,72(s5)
    800012ea:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800012ee:	058ab683          	ld	a3,88(s5)
    800012f2:	87b6                	mv	a5,a3
    800012f4:	058a3703          	ld	a4,88(s4)
    800012f8:	12068693          	addi	a3,a3,288
    800012fc:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001300:	6788                	ld	a0,8(a5)
    80001302:	6b8c                	ld	a1,16(a5)
    80001304:	6f90                	ld	a2,24(a5)
    80001306:	01073023          	sd	a6,0(a4)
    8000130a:	e708                	sd	a0,8(a4)
    8000130c:	eb0c                	sd	a1,16(a4)
    8000130e:	ef10                	sd	a2,24(a4)
    80001310:	02078793          	addi	a5,a5,32
    80001314:	02070713          	addi	a4,a4,32
    80001318:	fed792e3          	bne	a5,a3,800012fc <fork+0x56>
  np->trapframe->a0 = 0;
    8000131c:	058a3783          	ld	a5,88(s4)
    80001320:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80001324:	0d0a8493          	addi	s1,s5,208
    80001328:	0d0a0913          	addi	s2,s4,208
    8000132c:	150a8993          	addi	s3,s5,336
    80001330:	a00d                	j	80001352 <fork+0xac>
    freeproc(np);
    80001332:	8552                	mv	a0,s4
    80001334:	00000097          	auipc	ra,0x0
    80001338:	d6e080e7          	jalr	-658(ra) # 800010a2 <freeproc>
    release(&np->lock);
    8000133c:	8552                	mv	a0,s4
    8000133e:	00006097          	auipc	ra,0x6
    80001342:	c8c080e7          	jalr	-884(ra) # 80006fca <release>
    return -1;
    80001346:	597d                	li	s2,-1
    80001348:	a059                	j	800013ce <fork+0x128>
  for (i = 0; i < NOFILE; i++)
    8000134a:	04a1                	addi	s1,s1,8
    8000134c:	0921                	addi	s2,s2,8
    8000134e:	01348b63          	beq	s1,s3,80001364 <fork+0xbe>
    if (p->ofile[i]) np->ofile[i] = filedup(p->ofile[i]);
    80001352:	6088                	ld	a0,0(s1)
    80001354:	d97d                	beqz	a0,8000134a <fork+0xa4>
    80001356:	00002097          	auipc	ra,0x2
    8000135a:	67c080e7          	jalr	1660(ra) # 800039d2 <filedup>
    8000135e:	00a93023          	sd	a0,0(s2)
    80001362:	b7e5                	j	8000134a <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001364:	150ab503          	ld	a0,336(s5)
    80001368:	00001097          	auipc	ra,0x1
    8000136c:	7ea080e7          	jalr	2026(ra) # 80002b52 <idup>
    80001370:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001374:	4641                	li	a2,16
    80001376:	158a8593          	addi	a1,s5,344
    8000137a:	158a0513          	addi	a0,s4,344
    8000137e:	fffff097          	auipc	ra,0xfffff
    80001382:	f46080e7          	jalr	-186(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    80001386:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000138a:	8552                	mv	a0,s4
    8000138c:	00006097          	auipc	ra,0x6
    80001390:	c3e080e7          	jalr	-962(ra) # 80006fca <release>
  acquire(&wait_lock);
    80001394:	00008497          	auipc	s1,0x8
    80001398:	6f448493          	addi	s1,s1,1780 # 80009a88 <wait_lock>
    8000139c:	8526                	mv	a0,s1
    8000139e:	00006097          	auipc	ra,0x6
    800013a2:	b78080e7          	jalr	-1160(ra) # 80006f16 <acquire>
  np->parent = p;
    800013a6:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800013aa:	8526                	mv	a0,s1
    800013ac:	00006097          	auipc	ra,0x6
    800013b0:	c1e080e7          	jalr	-994(ra) # 80006fca <release>
  acquire(&np->lock);
    800013b4:	8552                	mv	a0,s4
    800013b6:	00006097          	auipc	ra,0x6
    800013ba:	b60080e7          	jalr	-1184(ra) # 80006f16 <acquire>
  np->state = RUNNABLE;
    800013be:	478d                	li	a5,3
    800013c0:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800013c4:	8552                	mv	a0,s4
    800013c6:	00006097          	auipc	ra,0x6
    800013ca:	c04080e7          	jalr	-1020(ra) # 80006fca <release>
}
    800013ce:	854a                	mv	a0,s2
    800013d0:	70e2                	ld	ra,56(sp)
    800013d2:	7442                	ld	s0,48(sp)
    800013d4:	74a2                	ld	s1,40(sp)
    800013d6:	7902                	ld	s2,32(sp)
    800013d8:	69e2                	ld	s3,24(sp)
    800013da:	6a42                	ld	s4,16(sp)
    800013dc:	6aa2                	ld	s5,8(sp)
    800013de:	6121                	addi	sp,sp,64
    800013e0:	8082                	ret
    return -1;
    800013e2:	597d                	li	s2,-1
    800013e4:	b7ed                	j	800013ce <fork+0x128>

00000000800013e6 <scheduler>:
void scheduler(void) {
    800013e6:	7139                	addi	sp,sp,-64
    800013e8:	fc06                	sd	ra,56(sp)
    800013ea:	f822                	sd	s0,48(sp)
    800013ec:	f426                	sd	s1,40(sp)
    800013ee:	f04a                	sd	s2,32(sp)
    800013f0:	ec4e                	sd	s3,24(sp)
    800013f2:	e852                	sd	s4,16(sp)
    800013f4:	e456                	sd	s5,8(sp)
    800013f6:	e05a                	sd	s6,0(sp)
    800013f8:	0080                	addi	s0,sp,64
    800013fa:	8792                	mv	a5,tp
  int id = r_tp();
    800013fc:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013fe:	00779a93          	slli	s5,a5,0x7
    80001402:	00008717          	auipc	a4,0x8
    80001406:	66e70713          	addi	a4,a4,1646 # 80009a70 <pid_lock>
    8000140a:	9756                	add	a4,a4,s5
    8000140c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001410:	00008717          	auipc	a4,0x8
    80001414:	69870713          	addi	a4,a4,1688 # 80009aa8 <cpus+0x8>
    80001418:	9aba                	add	s5,s5,a4
      if (p->state == RUNNABLE) {
    8000141a:	498d                	li	s3,3
        p->state = RUNNING;
    8000141c:	4b11                	li	s6,4
        c->proc = p;
    8000141e:	079e                	slli	a5,a5,0x7
    80001420:	00008a17          	auipc	s4,0x8
    80001424:	650a0a13          	addi	s4,s4,1616 # 80009a70 <pid_lock>
    80001428:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++) {
    8000142a:	0000e917          	auipc	s2,0xe
    8000142e:	47690913          	addi	s2,s2,1142 # 8000f8a0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001432:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80001436:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000143a:	10079073          	csrw	sstatus,a5
    8000143e:	00009497          	auipc	s1,0x9
    80001442:	a6248493          	addi	s1,s1,-1438 # 80009ea0 <proc>
    80001446:	a811                	j	8000145a <scheduler+0x74>
      release(&p->lock);
    80001448:	8526                	mv	a0,s1
    8000144a:	00006097          	auipc	ra,0x6
    8000144e:	b80080e7          	jalr	-1152(ra) # 80006fca <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001452:	16848493          	addi	s1,s1,360
    80001456:	fd248ee3          	beq	s1,s2,80001432 <scheduler+0x4c>
      acquire(&p->lock);
    8000145a:	8526                	mv	a0,s1
    8000145c:	00006097          	auipc	ra,0x6
    80001460:	aba080e7          	jalr	-1350(ra) # 80006f16 <acquire>
      if (p->state == RUNNABLE) {
    80001464:	4c9c                	lw	a5,24(s1)
    80001466:	ff3791e3          	bne	a5,s3,80001448 <scheduler+0x62>
        p->state = RUNNING;
    8000146a:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000146e:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001472:	06048593          	addi	a1,s1,96
    80001476:	8556                	mv	a0,s5
    80001478:	00000097          	auipc	ra,0x0
    8000147c:	684080e7          	jalr	1668(ra) # 80001afc <swtch>
        c->proc = 0;
    80001480:	020a3823          	sd	zero,48(s4)
    80001484:	b7d1                	j	80001448 <scheduler+0x62>

0000000080001486 <sched>:
void sched(void) {
    80001486:	7179                	addi	sp,sp,-48
    80001488:	f406                	sd	ra,40(sp)
    8000148a:	f022                	sd	s0,32(sp)
    8000148c:	ec26                	sd	s1,24(sp)
    8000148e:	e84a                	sd	s2,16(sp)
    80001490:	e44e                	sd	s3,8(sp)
    80001492:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001494:	00000097          	auipc	ra,0x0
    80001498:	a58080e7          	jalr	-1448(ra) # 80000eec <myproc>
    8000149c:	84aa                	mv	s1,a0
  if (!holding(&p->lock)) panic("sched p->lock");
    8000149e:	00006097          	auipc	ra,0x6
    800014a2:	9fe080e7          	jalr	-1538(ra) # 80006e9c <holding>
    800014a6:	c93d                	beqz	a0,8000151c <sched+0x96>
  asm volatile("mv %0, tp" : "=r"(x));
    800014a8:	8792                	mv	a5,tp
  if (mycpu()->noff != 1) panic("sched locks");
    800014aa:	2781                	sext.w	a5,a5
    800014ac:	079e                	slli	a5,a5,0x7
    800014ae:	00008717          	auipc	a4,0x8
    800014b2:	5c270713          	addi	a4,a4,1474 # 80009a70 <pid_lock>
    800014b6:	97ba                	add	a5,a5,a4
    800014b8:	0a87a703          	lw	a4,168(a5)
    800014bc:	4785                	li	a5,1
    800014be:	06f71763          	bne	a4,a5,8000152c <sched+0xa6>
  if (p->state == RUNNING) panic("sched running");
    800014c2:	4c98                	lw	a4,24(s1)
    800014c4:	4791                	li	a5,4
    800014c6:	06f70b63          	beq	a4,a5,8000153c <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800014ca:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014ce:	8b89                	andi	a5,a5,2
  if (intr_get()) panic("sched interruptible");
    800014d0:	efb5                	bnez	a5,8000154c <sched+0xc6>
  asm volatile("mv %0, tp" : "=r"(x));
    800014d2:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014d4:	00008917          	auipc	s2,0x8
    800014d8:	59c90913          	addi	s2,s2,1436 # 80009a70 <pid_lock>
    800014dc:	2781                	sext.w	a5,a5
    800014de:	079e                	slli	a5,a5,0x7
    800014e0:	97ca                	add	a5,a5,s2
    800014e2:	0ac7a983          	lw	s3,172(a5)
    800014e6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014e8:	2781                	sext.w	a5,a5
    800014ea:	079e                	slli	a5,a5,0x7
    800014ec:	00008597          	auipc	a1,0x8
    800014f0:	5bc58593          	addi	a1,a1,1468 # 80009aa8 <cpus+0x8>
    800014f4:	95be                	add	a1,a1,a5
    800014f6:	06048513          	addi	a0,s1,96
    800014fa:	00000097          	auipc	ra,0x0
    800014fe:	602080e7          	jalr	1538(ra) # 80001afc <swtch>
    80001502:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001504:	2781                	sext.w	a5,a5
    80001506:	079e                	slli	a5,a5,0x7
    80001508:	993e                	add	s2,s2,a5
    8000150a:	0b392623          	sw	s3,172(s2)
}
    8000150e:	70a2                	ld	ra,40(sp)
    80001510:	7402                	ld	s0,32(sp)
    80001512:	64e2                	ld	s1,24(sp)
    80001514:	6942                	ld	s2,16(sp)
    80001516:	69a2                	ld	s3,8(sp)
    80001518:	6145                	addi	sp,sp,48
    8000151a:	8082                	ret
  if (!holding(&p->lock)) panic("sched p->lock");
    8000151c:	00008517          	auipc	a0,0x8
    80001520:	cbc50513          	addi	a0,a0,-836 # 800091d8 <etext+0x1d8>
    80001524:	00005097          	auipc	ra,0x5
    80001528:	4ba080e7          	jalr	1210(ra) # 800069de <panic>
  if (mycpu()->noff != 1) panic("sched locks");
    8000152c:	00008517          	auipc	a0,0x8
    80001530:	cbc50513          	addi	a0,a0,-836 # 800091e8 <etext+0x1e8>
    80001534:	00005097          	auipc	ra,0x5
    80001538:	4aa080e7          	jalr	1194(ra) # 800069de <panic>
  if (p->state == RUNNING) panic("sched running");
    8000153c:	00008517          	auipc	a0,0x8
    80001540:	cbc50513          	addi	a0,a0,-836 # 800091f8 <etext+0x1f8>
    80001544:	00005097          	auipc	ra,0x5
    80001548:	49a080e7          	jalr	1178(ra) # 800069de <panic>
  if (intr_get()) panic("sched interruptible");
    8000154c:	00008517          	auipc	a0,0x8
    80001550:	cbc50513          	addi	a0,a0,-836 # 80009208 <etext+0x208>
    80001554:	00005097          	auipc	ra,0x5
    80001558:	48a080e7          	jalr	1162(ra) # 800069de <panic>

000000008000155c <yield>:
void yield(void) {
    8000155c:	1101                	addi	sp,sp,-32
    8000155e:	ec06                	sd	ra,24(sp)
    80001560:	e822                	sd	s0,16(sp)
    80001562:	e426                	sd	s1,8(sp)
    80001564:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001566:	00000097          	auipc	ra,0x0
    8000156a:	986080e7          	jalr	-1658(ra) # 80000eec <myproc>
    8000156e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001570:	00006097          	auipc	ra,0x6
    80001574:	9a6080e7          	jalr	-1626(ra) # 80006f16 <acquire>
  p->state = RUNNABLE;
    80001578:	478d                	li	a5,3
    8000157a:	cc9c                	sw	a5,24(s1)
  sched();
    8000157c:	00000097          	auipc	ra,0x0
    80001580:	f0a080e7          	jalr	-246(ra) # 80001486 <sched>
  release(&p->lock);
    80001584:	8526                	mv	a0,s1
    80001586:	00006097          	auipc	ra,0x6
    8000158a:	a44080e7          	jalr	-1468(ra) # 80006fca <release>
}
    8000158e:	60e2                	ld	ra,24(sp)
    80001590:	6442                	ld	s0,16(sp)
    80001592:	64a2                	ld	s1,8(sp)
    80001594:	6105                	addi	sp,sp,32
    80001596:	8082                	ret

0000000080001598 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk) {
    80001598:	7179                	addi	sp,sp,-48
    8000159a:	f406                	sd	ra,40(sp)
    8000159c:	f022                	sd	s0,32(sp)
    8000159e:	ec26                	sd	s1,24(sp)
    800015a0:	e84a                	sd	s2,16(sp)
    800015a2:	e44e                	sd	s3,8(sp)
    800015a4:	1800                	addi	s0,sp,48
    800015a6:	89aa                	mv	s3,a0
    800015a8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800015aa:	00000097          	auipc	ra,0x0
    800015ae:	942080e7          	jalr	-1726(ra) # 80000eec <myproc>
    800015b2:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  // DOC: sleeplock1
    800015b4:	00006097          	auipc	ra,0x6
    800015b8:	962080e7          	jalr	-1694(ra) # 80006f16 <acquire>
  release(lk);
    800015bc:	854a                	mv	a0,s2
    800015be:	00006097          	auipc	ra,0x6
    800015c2:	a0c080e7          	jalr	-1524(ra) # 80006fca <release>

  // Go to sleep.
  p->chan = chan;
    800015c6:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015ca:	4789                	li	a5,2
    800015cc:	cc9c                	sw	a5,24(s1)

  sched();
    800015ce:	00000097          	auipc	ra,0x0
    800015d2:	eb8080e7          	jalr	-328(ra) # 80001486 <sched>

  // Tidy up.
  p->chan = 0;
    800015d6:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015da:	8526                	mv	a0,s1
    800015dc:	00006097          	auipc	ra,0x6
    800015e0:	9ee080e7          	jalr	-1554(ra) # 80006fca <release>
  acquire(lk);
    800015e4:	854a                	mv	a0,s2
    800015e6:	00006097          	auipc	ra,0x6
    800015ea:	930080e7          	jalr	-1744(ra) # 80006f16 <acquire>
}
    800015ee:	70a2                	ld	ra,40(sp)
    800015f0:	7402                	ld	s0,32(sp)
    800015f2:	64e2                	ld	s1,24(sp)
    800015f4:	6942                	ld	s2,16(sp)
    800015f6:	69a2                	ld	s3,8(sp)
    800015f8:	6145                	addi	sp,sp,48
    800015fa:	8082                	ret

00000000800015fc <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan) {
    800015fc:	7139                	addi	sp,sp,-64
    800015fe:	fc06                	sd	ra,56(sp)
    80001600:	f822                	sd	s0,48(sp)
    80001602:	f426                	sd	s1,40(sp)
    80001604:	f04a                	sd	s2,32(sp)
    80001606:	ec4e                	sd	s3,24(sp)
    80001608:	e852                	sd	s4,16(sp)
    8000160a:	e456                	sd	s5,8(sp)
    8000160c:	0080                	addi	s0,sp,64
    8000160e:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001610:	00009497          	auipc	s1,0x9
    80001614:	89048493          	addi	s1,s1,-1904 # 80009ea0 <proc>
    if (p != myproc()) {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan) {
    80001618:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000161a:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    8000161c:	0000e917          	auipc	s2,0xe
    80001620:	28490913          	addi	s2,s2,644 # 8000f8a0 <tickslock>
    80001624:	a811                	j	80001638 <wakeup+0x3c>
      }
      release(&p->lock);
    80001626:	8526                	mv	a0,s1
    80001628:	00006097          	auipc	ra,0x6
    8000162c:	9a2080e7          	jalr	-1630(ra) # 80006fca <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001630:	16848493          	addi	s1,s1,360
    80001634:	03248663          	beq	s1,s2,80001660 <wakeup+0x64>
    if (p != myproc()) {
    80001638:	00000097          	auipc	ra,0x0
    8000163c:	8b4080e7          	jalr	-1868(ra) # 80000eec <myproc>
    80001640:	fea488e3          	beq	s1,a0,80001630 <wakeup+0x34>
      acquire(&p->lock);
    80001644:	8526                	mv	a0,s1
    80001646:	00006097          	auipc	ra,0x6
    8000164a:	8d0080e7          	jalr	-1840(ra) # 80006f16 <acquire>
      if (p->state == SLEEPING && p->chan == chan) {
    8000164e:	4c9c                	lw	a5,24(s1)
    80001650:	fd379be3          	bne	a5,s3,80001626 <wakeup+0x2a>
    80001654:	709c                	ld	a5,32(s1)
    80001656:	fd4798e3          	bne	a5,s4,80001626 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000165a:	0154ac23          	sw	s5,24(s1)
    8000165e:	b7e1                	j	80001626 <wakeup+0x2a>
    }
  }
}
    80001660:	70e2                	ld	ra,56(sp)
    80001662:	7442                	ld	s0,48(sp)
    80001664:	74a2                	ld	s1,40(sp)
    80001666:	7902                	ld	s2,32(sp)
    80001668:	69e2                	ld	s3,24(sp)
    8000166a:	6a42                	ld	s4,16(sp)
    8000166c:	6aa2                	ld	s5,8(sp)
    8000166e:	6121                	addi	sp,sp,64
    80001670:	8082                	ret

0000000080001672 <reparent>:
void reparent(struct proc *p) {
    80001672:	7179                	addi	sp,sp,-48
    80001674:	f406                	sd	ra,40(sp)
    80001676:	f022                	sd	s0,32(sp)
    80001678:	ec26                	sd	s1,24(sp)
    8000167a:	e84a                	sd	s2,16(sp)
    8000167c:	e44e                	sd	s3,8(sp)
    8000167e:	e052                	sd	s4,0(sp)
    80001680:	1800                	addi	s0,sp,48
    80001682:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001684:	00009497          	auipc	s1,0x9
    80001688:	81c48493          	addi	s1,s1,-2020 # 80009ea0 <proc>
      pp->parent = initproc;
    8000168c:	00008a17          	auipc	s4,0x8
    80001690:	384a0a13          	addi	s4,s4,900 # 80009a10 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001694:	0000e997          	auipc	s3,0xe
    80001698:	20c98993          	addi	s3,s3,524 # 8000f8a0 <tickslock>
    8000169c:	a029                	j	800016a6 <reparent+0x34>
    8000169e:	16848493          	addi	s1,s1,360
    800016a2:	01348d63          	beq	s1,s3,800016bc <reparent+0x4a>
    if (pp->parent == p) {
    800016a6:	7c9c                	ld	a5,56(s1)
    800016a8:	ff279be3          	bne	a5,s2,8000169e <reparent+0x2c>
      pp->parent = initproc;
    800016ac:	000a3503          	ld	a0,0(s4)
    800016b0:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800016b2:	00000097          	auipc	ra,0x0
    800016b6:	f4a080e7          	jalr	-182(ra) # 800015fc <wakeup>
    800016ba:	b7d5                	j	8000169e <reparent+0x2c>
}
    800016bc:	70a2                	ld	ra,40(sp)
    800016be:	7402                	ld	s0,32(sp)
    800016c0:	64e2                	ld	s1,24(sp)
    800016c2:	6942                	ld	s2,16(sp)
    800016c4:	69a2                	ld	s3,8(sp)
    800016c6:	6a02                	ld	s4,0(sp)
    800016c8:	6145                	addi	sp,sp,48
    800016ca:	8082                	ret

00000000800016cc <exit>:
void exit(int status) {
    800016cc:	7179                	addi	sp,sp,-48
    800016ce:	f406                	sd	ra,40(sp)
    800016d0:	f022                	sd	s0,32(sp)
    800016d2:	ec26                	sd	s1,24(sp)
    800016d4:	e84a                	sd	s2,16(sp)
    800016d6:	e44e                	sd	s3,8(sp)
    800016d8:	e052                	sd	s4,0(sp)
    800016da:	1800                	addi	s0,sp,48
    800016dc:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800016de:	00000097          	auipc	ra,0x0
    800016e2:	80e080e7          	jalr	-2034(ra) # 80000eec <myproc>
    800016e6:	89aa                	mv	s3,a0
  if (p == initproc) panic("init exiting");
    800016e8:	00008797          	auipc	a5,0x8
    800016ec:	3287b783          	ld	a5,808(a5) # 80009a10 <initproc>
    800016f0:	0d050493          	addi	s1,a0,208
    800016f4:	15050913          	addi	s2,a0,336
    800016f8:	02a79363          	bne	a5,a0,8000171e <exit+0x52>
    800016fc:	00008517          	auipc	a0,0x8
    80001700:	b2450513          	addi	a0,a0,-1244 # 80009220 <etext+0x220>
    80001704:	00005097          	auipc	ra,0x5
    80001708:	2da080e7          	jalr	730(ra) # 800069de <panic>
      fileclose(f);
    8000170c:	00002097          	auipc	ra,0x2
    80001710:	318080e7          	jalr	792(ra) # 80003a24 <fileclose>
      p->ofile[fd] = 0;
    80001714:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++) {
    80001718:	04a1                	addi	s1,s1,8
    8000171a:	01248563          	beq	s1,s2,80001724 <exit+0x58>
    if (p->ofile[fd]) {
    8000171e:	6088                	ld	a0,0(s1)
    80001720:	f575                	bnez	a0,8000170c <exit+0x40>
    80001722:	bfdd                	j	80001718 <exit+0x4c>
  begin_op();
    80001724:	00002097          	auipc	ra,0x2
    80001728:	e38080e7          	jalr	-456(ra) # 8000355c <begin_op>
  iput(p->cwd);
    8000172c:	1509b503          	ld	a0,336(s3)
    80001730:	00001097          	auipc	ra,0x1
    80001734:	61a080e7          	jalr	1562(ra) # 80002d4a <iput>
  end_op();
    80001738:	00002097          	auipc	ra,0x2
    8000173c:	ea2080e7          	jalr	-350(ra) # 800035da <end_op>
  p->cwd = 0;
    80001740:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001744:	00008497          	auipc	s1,0x8
    80001748:	34448493          	addi	s1,s1,836 # 80009a88 <wait_lock>
    8000174c:	8526                	mv	a0,s1
    8000174e:	00005097          	auipc	ra,0x5
    80001752:	7c8080e7          	jalr	1992(ra) # 80006f16 <acquire>
  reparent(p);
    80001756:	854e                	mv	a0,s3
    80001758:	00000097          	auipc	ra,0x0
    8000175c:	f1a080e7          	jalr	-230(ra) # 80001672 <reparent>
  wakeup(p->parent);
    80001760:	0389b503          	ld	a0,56(s3)
    80001764:	00000097          	auipc	ra,0x0
    80001768:	e98080e7          	jalr	-360(ra) # 800015fc <wakeup>
  acquire(&p->lock);
    8000176c:	854e                	mv	a0,s3
    8000176e:	00005097          	auipc	ra,0x5
    80001772:	7a8080e7          	jalr	1960(ra) # 80006f16 <acquire>
  p->xstate = status;
    80001776:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000177a:	4795                	li	a5,5
    8000177c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001780:	8526                	mv	a0,s1
    80001782:	00006097          	auipc	ra,0x6
    80001786:	848080e7          	jalr	-1976(ra) # 80006fca <release>
  sched();
    8000178a:	00000097          	auipc	ra,0x0
    8000178e:	cfc080e7          	jalr	-772(ra) # 80001486 <sched>
  panic("zombie exit");
    80001792:	00008517          	auipc	a0,0x8
    80001796:	a9e50513          	addi	a0,a0,-1378 # 80009230 <etext+0x230>
    8000179a:	00005097          	auipc	ra,0x5
    8000179e:	244080e7          	jalr	580(ra) # 800069de <panic>

00000000800017a2 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid) {
    800017a2:	7179                	addi	sp,sp,-48
    800017a4:	f406                	sd	ra,40(sp)
    800017a6:	f022                	sd	s0,32(sp)
    800017a8:	ec26                	sd	s1,24(sp)
    800017aa:	e84a                	sd	s2,16(sp)
    800017ac:	e44e                	sd	s3,8(sp)
    800017ae:	1800                	addi	s0,sp,48
    800017b0:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    800017b2:	00008497          	auipc	s1,0x8
    800017b6:	6ee48493          	addi	s1,s1,1774 # 80009ea0 <proc>
    800017ba:	0000e997          	auipc	s3,0xe
    800017be:	0e698993          	addi	s3,s3,230 # 8000f8a0 <tickslock>
    acquire(&p->lock);
    800017c2:	8526                	mv	a0,s1
    800017c4:	00005097          	auipc	ra,0x5
    800017c8:	752080e7          	jalr	1874(ra) # 80006f16 <acquire>
    if (p->pid == pid) {
    800017cc:	589c                	lw	a5,48(s1)
    800017ce:	01278d63          	beq	a5,s2,800017e8 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800017d2:	8526                	mv	a0,s1
    800017d4:	00005097          	auipc	ra,0x5
    800017d8:	7f6080e7          	jalr	2038(ra) # 80006fca <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800017dc:	16848493          	addi	s1,s1,360
    800017e0:	ff3491e3          	bne	s1,s3,800017c2 <kill+0x20>
  }
  return -1;
    800017e4:	557d                	li	a0,-1
    800017e6:	a829                	j	80001800 <kill+0x5e>
      p->killed = 1;
    800017e8:	4785                	li	a5,1
    800017ea:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    800017ec:	4c98                	lw	a4,24(s1)
    800017ee:	4789                	li	a5,2
    800017f0:	00f70f63          	beq	a4,a5,8000180e <kill+0x6c>
      release(&p->lock);
    800017f4:	8526                	mv	a0,s1
    800017f6:	00005097          	auipc	ra,0x5
    800017fa:	7d4080e7          	jalr	2004(ra) # 80006fca <release>
      return 0;
    800017fe:	4501                	li	a0,0
}
    80001800:	70a2                	ld	ra,40(sp)
    80001802:	7402                	ld	s0,32(sp)
    80001804:	64e2                	ld	s1,24(sp)
    80001806:	6942                	ld	s2,16(sp)
    80001808:	69a2                	ld	s3,8(sp)
    8000180a:	6145                	addi	sp,sp,48
    8000180c:	8082                	ret
        p->state = RUNNABLE;
    8000180e:	478d                	li	a5,3
    80001810:	cc9c                	sw	a5,24(s1)
    80001812:	b7cd                	j	800017f4 <kill+0x52>

0000000080001814 <setkilled>:

void setkilled(struct proc *p) {
    80001814:	1101                	addi	sp,sp,-32
    80001816:	ec06                	sd	ra,24(sp)
    80001818:	e822                	sd	s0,16(sp)
    8000181a:	e426                	sd	s1,8(sp)
    8000181c:	1000                	addi	s0,sp,32
    8000181e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001820:	00005097          	auipc	ra,0x5
    80001824:	6f6080e7          	jalr	1782(ra) # 80006f16 <acquire>
  p->killed = 1;
    80001828:	4785                	li	a5,1
    8000182a:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000182c:	8526                	mv	a0,s1
    8000182e:	00005097          	auipc	ra,0x5
    80001832:	79c080e7          	jalr	1948(ra) # 80006fca <release>
}
    80001836:	60e2                	ld	ra,24(sp)
    80001838:	6442                	ld	s0,16(sp)
    8000183a:	64a2                	ld	s1,8(sp)
    8000183c:	6105                	addi	sp,sp,32
    8000183e:	8082                	ret

0000000080001840 <killed>:

int killed(struct proc *p) {
    80001840:	1101                	addi	sp,sp,-32
    80001842:	ec06                	sd	ra,24(sp)
    80001844:	e822                	sd	s0,16(sp)
    80001846:	e426                	sd	s1,8(sp)
    80001848:	e04a                	sd	s2,0(sp)
    8000184a:	1000                	addi	s0,sp,32
    8000184c:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    8000184e:	00005097          	auipc	ra,0x5
    80001852:	6c8080e7          	jalr	1736(ra) # 80006f16 <acquire>
  k = p->killed;
    80001856:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000185a:	8526                	mv	a0,s1
    8000185c:	00005097          	auipc	ra,0x5
    80001860:	76e080e7          	jalr	1902(ra) # 80006fca <release>
  return k;
}
    80001864:	854a                	mv	a0,s2
    80001866:	60e2                	ld	ra,24(sp)
    80001868:	6442                	ld	s0,16(sp)
    8000186a:	64a2                	ld	s1,8(sp)
    8000186c:	6902                	ld	s2,0(sp)
    8000186e:	6105                	addi	sp,sp,32
    80001870:	8082                	ret

0000000080001872 <wait>:
int wait(uint64 addr) {
    80001872:	715d                	addi	sp,sp,-80
    80001874:	e486                	sd	ra,72(sp)
    80001876:	e0a2                	sd	s0,64(sp)
    80001878:	fc26                	sd	s1,56(sp)
    8000187a:	f84a                	sd	s2,48(sp)
    8000187c:	f44e                	sd	s3,40(sp)
    8000187e:	f052                	sd	s4,32(sp)
    80001880:	ec56                	sd	s5,24(sp)
    80001882:	e85a                	sd	s6,16(sp)
    80001884:	e45e                	sd	s7,8(sp)
    80001886:	e062                	sd	s8,0(sp)
    80001888:	0880                	addi	s0,sp,80
    8000188a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000188c:	fffff097          	auipc	ra,0xfffff
    80001890:	660080e7          	jalr	1632(ra) # 80000eec <myproc>
    80001894:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001896:	00008517          	auipc	a0,0x8
    8000189a:	1f250513          	addi	a0,a0,498 # 80009a88 <wait_lock>
    8000189e:	00005097          	auipc	ra,0x5
    800018a2:	678080e7          	jalr	1656(ra) # 80006f16 <acquire>
    havekids = 0;
    800018a6:	4b81                	li	s7,0
        if (pp->state == ZOMBIE) {
    800018a8:	4a15                	li	s4,5
        havekids = 1;
    800018aa:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    800018ac:	0000e997          	auipc	s3,0xe
    800018b0:	ff498993          	addi	s3,s3,-12 # 8000f8a0 <tickslock>
    sleep(p, &wait_lock);  // DOC: wait-sleep
    800018b4:	00008c17          	auipc	s8,0x8
    800018b8:	1d4c0c13          	addi	s8,s8,468 # 80009a88 <wait_lock>
    havekids = 0;
    800018bc:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    800018be:	00008497          	auipc	s1,0x8
    800018c2:	5e248493          	addi	s1,s1,1506 # 80009ea0 <proc>
    800018c6:	a0bd                	j	80001934 <wait+0xc2>
          pid = pp->pid;
    800018c8:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800018cc:	000b0e63          	beqz	s6,800018e8 <wait+0x76>
    800018d0:	4691                	li	a3,4
    800018d2:	02c48613          	addi	a2,s1,44
    800018d6:	85da                	mv	a1,s6
    800018d8:	05093503          	ld	a0,80(s2)
    800018dc:	fffff097          	auipc	ra,0xfffff
    800018e0:	29c080e7          	jalr	668(ra) # 80000b78 <copyout>
    800018e4:	02054563          	bltz	a0,8000190e <wait+0x9c>
          freeproc(pp);
    800018e8:	8526                	mv	a0,s1
    800018ea:	fffff097          	auipc	ra,0xfffff
    800018ee:	7b8080e7          	jalr	1976(ra) # 800010a2 <freeproc>
          release(&pp->lock);
    800018f2:	8526                	mv	a0,s1
    800018f4:	00005097          	auipc	ra,0x5
    800018f8:	6d6080e7          	jalr	1750(ra) # 80006fca <release>
          release(&wait_lock);
    800018fc:	00008517          	auipc	a0,0x8
    80001900:	18c50513          	addi	a0,a0,396 # 80009a88 <wait_lock>
    80001904:	00005097          	auipc	ra,0x5
    80001908:	6c6080e7          	jalr	1734(ra) # 80006fca <release>
          return pid;
    8000190c:	a0b5                	j	80001978 <wait+0x106>
            release(&pp->lock);
    8000190e:	8526                	mv	a0,s1
    80001910:	00005097          	auipc	ra,0x5
    80001914:	6ba080e7          	jalr	1722(ra) # 80006fca <release>
            release(&wait_lock);
    80001918:	00008517          	auipc	a0,0x8
    8000191c:	17050513          	addi	a0,a0,368 # 80009a88 <wait_lock>
    80001920:	00005097          	auipc	ra,0x5
    80001924:	6aa080e7          	jalr	1706(ra) # 80006fca <release>
            return -1;
    80001928:	59fd                	li	s3,-1
    8000192a:	a0b9                	j	80001978 <wait+0x106>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000192c:	16848493          	addi	s1,s1,360
    80001930:	03348463          	beq	s1,s3,80001958 <wait+0xe6>
      if (pp->parent == p) {
    80001934:	7c9c                	ld	a5,56(s1)
    80001936:	ff279be3          	bne	a5,s2,8000192c <wait+0xba>
        acquire(&pp->lock);
    8000193a:	8526                	mv	a0,s1
    8000193c:	00005097          	auipc	ra,0x5
    80001940:	5da080e7          	jalr	1498(ra) # 80006f16 <acquire>
        if (pp->state == ZOMBIE) {
    80001944:	4c9c                	lw	a5,24(s1)
    80001946:	f94781e3          	beq	a5,s4,800018c8 <wait+0x56>
        release(&pp->lock);
    8000194a:	8526                	mv	a0,s1
    8000194c:	00005097          	auipc	ra,0x5
    80001950:	67e080e7          	jalr	1662(ra) # 80006fca <release>
        havekids = 1;
    80001954:	8756                	mv	a4,s5
    80001956:	bfd9                	j	8000192c <wait+0xba>
    if (!havekids || killed(p)) {
    80001958:	c719                	beqz	a4,80001966 <wait+0xf4>
    8000195a:	854a                	mv	a0,s2
    8000195c:	00000097          	auipc	ra,0x0
    80001960:	ee4080e7          	jalr	-284(ra) # 80001840 <killed>
    80001964:	c51d                	beqz	a0,80001992 <wait+0x120>
      release(&wait_lock);
    80001966:	00008517          	auipc	a0,0x8
    8000196a:	12250513          	addi	a0,a0,290 # 80009a88 <wait_lock>
    8000196e:	00005097          	auipc	ra,0x5
    80001972:	65c080e7          	jalr	1628(ra) # 80006fca <release>
      return -1;
    80001976:	59fd                	li	s3,-1
}
    80001978:	854e                	mv	a0,s3
    8000197a:	60a6                	ld	ra,72(sp)
    8000197c:	6406                	ld	s0,64(sp)
    8000197e:	74e2                	ld	s1,56(sp)
    80001980:	7942                	ld	s2,48(sp)
    80001982:	79a2                	ld	s3,40(sp)
    80001984:	7a02                	ld	s4,32(sp)
    80001986:	6ae2                	ld	s5,24(sp)
    80001988:	6b42                	ld	s6,16(sp)
    8000198a:	6ba2                	ld	s7,8(sp)
    8000198c:	6c02                	ld	s8,0(sp)
    8000198e:	6161                	addi	sp,sp,80
    80001990:	8082                	ret
    sleep(p, &wait_lock);  // DOC: wait-sleep
    80001992:	85e2                	mv	a1,s8
    80001994:	854a                	mv	a0,s2
    80001996:	00000097          	auipc	ra,0x0
    8000199a:	c02080e7          	jalr	-1022(ra) # 80001598 <sleep>
    havekids = 0;
    8000199e:	bf39                	j	800018bc <wait+0x4a>

00000000800019a0 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len) {
    800019a0:	7179                	addi	sp,sp,-48
    800019a2:	f406                	sd	ra,40(sp)
    800019a4:	f022                	sd	s0,32(sp)
    800019a6:	ec26                	sd	s1,24(sp)
    800019a8:	e84a                	sd	s2,16(sp)
    800019aa:	e44e                	sd	s3,8(sp)
    800019ac:	e052                	sd	s4,0(sp)
    800019ae:	1800                	addi	s0,sp,48
    800019b0:	84aa                	mv	s1,a0
    800019b2:	892e                	mv	s2,a1
    800019b4:	89b2                	mv	s3,a2
    800019b6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019b8:	fffff097          	auipc	ra,0xfffff
    800019bc:	534080e7          	jalr	1332(ra) # 80000eec <myproc>
  if (user_dst) {
    800019c0:	c08d                	beqz	s1,800019e2 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800019c2:	86d2                	mv	a3,s4
    800019c4:	864e                	mv	a2,s3
    800019c6:	85ca                	mv	a1,s2
    800019c8:	6928                	ld	a0,80(a0)
    800019ca:	fffff097          	auipc	ra,0xfffff
    800019ce:	1ae080e7          	jalr	430(ra) # 80000b78 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800019d2:	70a2                	ld	ra,40(sp)
    800019d4:	7402                	ld	s0,32(sp)
    800019d6:	64e2                	ld	s1,24(sp)
    800019d8:	6942                	ld	s2,16(sp)
    800019da:	69a2                	ld	s3,8(sp)
    800019dc:	6a02                	ld	s4,0(sp)
    800019de:	6145                	addi	sp,sp,48
    800019e0:	8082                	ret
    memmove((char *)dst, src, len);
    800019e2:	000a061b          	sext.w	a2,s4
    800019e6:	85ce                	mv	a1,s3
    800019e8:	854a                	mv	a0,s2
    800019ea:	ffffe097          	auipc	ra,0xffffe
    800019ee:	7ec080e7          	jalr	2028(ra) # 800001d6 <memmove>
    return 0;
    800019f2:	8526                	mv	a0,s1
    800019f4:	bff9                	j	800019d2 <either_copyout+0x32>

00000000800019f6 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len) {
    800019f6:	7179                	addi	sp,sp,-48
    800019f8:	f406                	sd	ra,40(sp)
    800019fa:	f022                	sd	s0,32(sp)
    800019fc:	ec26                	sd	s1,24(sp)
    800019fe:	e84a                	sd	s2,16(sp)
    80001a00:	e44e                	sd	s3,8(sp)
    80001a02:	e052                	sd	s4,0(sp)
    80001a04:	1800                	addi	s0,sp,48
    80001a06:	892a                	mv	s2,a0
    80001a08:	84ae                	mv	s1,a1
    80001a0a:	89b2                	mv	s3,a2
    80001a0c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a0e:	fffff097          	auipc	ra,0xfffff
    80001a12:	4de080e7          	jalr	1246(ra) # 80000eec <myproc>
  if (user_src) {
    80001a16:	c08d                	beqz	s1,80001a38 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a18:	86d2                	mv	a3,s4
    80001a1a:	864e                	mv	a2,s3
    80001a1c:	85ca                	mv	a1,s2
    80001a1e:	6928                	ld	a0,80(a0)
    80001a20:	fffff097          	auipc	ra,0xfffff
    80001a24:	218080e7          	jalr	536(ra) # 80000c38 <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80001a28:	70a2                	ld	ra,40(sp)
    80001a2a:	7402                	ld	s0,32(sp)
    80001a2c:	64e2                	ld	s1,24(sp)
    80001a2e:	6942                	ld	s2,16(sp)
    80001a30:	69a2                	ld	s3,8(sp)
    80001a32:	6a02                	ld	s4,0(sp)
    80001a34:	6145                	addi	sp,sp,48
    80001a36:	8082                	ret
    memmove(dst, (char *)src, len);
    80001a38:	000a061b          	sext.w	a2,s4
    80001a3c:	85ce                	mv	a1,s3
    80001a3e:	854a                	mv	a0,s2
    80001a40:	ffffe097          	auipc	ra,0xffffe
    80001a44:	796080e7          	jalr	1942(ra) # 800001d6 <memmove>
    return 0;
    80001a48:	8526                	mv	a0,s1
    80001a4a:	bff9                	j	80001a28 <either_copyin+0x32>

0000000080001a4c <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
    80001a4c:	715d                	addi	sp,sp,-80
    80001a4e:	e486                	sd	ra,72(sp)
    80001a50:	e0a2                	sd	s0,64(sp)
    80001a52:	fc26                	sd	s1,56(sp)
    80001a54:	f84a                	sd	s2,48(sp)
    80001a56:	f44e                	sd	s3,40(sp)
    80001a58:	f052                	sd	s4,32(sp)
    80001a5a:	ec56                	sd	s5,24(sp)
    80001a5c:	e85a                	sd	s6,16(sp)
    80001a5e:	e45e                	sd	s7,8(sp)
    80001a60:	0880                	addi	s0,sp,80
      [UNUSED] = "unused",   [USED] = "used",      [SLEEPING] = "sleep ",
      [RUNNABLE] = "runble", [RUNNING] = "run   ", [ZOMBIE] = "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    80001a62:	00007517          	auipc	a0,0x7
    80001a66:	5e650513          	addi	a0,a0,1510 # 80009048 <etext+0x48>
    80001a6a:	00005097          	auipc	ra,0x5
    80001a6e:	fbe080e7          	jalr	-66(ra) # 80006a28 <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001a72:	00008497          	auipc	s1,0x8
    80001a76:	58648493          	addi	s1,s1,1414 # 80009ff8 <proc+0x158>
    80001a7a:	0000e917          	auipc	s2,0xe
    80001a7e:	f7e90913          	addi	s2,s2,-130 # 8000f9f8 <bcache+0x140>
    if (p->state == UNUSED) continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a82:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a84:	00007997          	auipc	s3,0x7
    80001a88:	7bc98993          	addi	s3,s3,1980 # 80009240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001a8c:	00007a97          	auipc	s5,0x7
    80001a90:	7bca8a93          	addi	s5,s5,1980 # 80009248 <etext+0x248>
    printf("\n");
    80001a94:	00007a17          	auipc	s4,0x7
    80001a98:	5b4a0a13          	addi	s4,s4,1460 # 80009048 <etext+0x48>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a9c:	00007b97          	auipc	s7,0x7
    80001aa0:	7ecb8b93          	addi	s7,s7,2028 # 80009288 <states.0>
    80001aa4:	a00d                	j	80001ac6 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001aa6:	ed86a583          	lw	a1,-296(a3)
    80001aaa:	8556                	mv	a0,s5
    80001aac:	00005097          	auipc	ra,0x5
    80001ab0:	f7c080e7          	jalr	-132(ra) # 80006a28 <printf>
    printf("\n");
    80001ab4:	8552                	mv	a0,s4
    80001ab6:	00005097          	auipc	ra,0x5
    80001aba:	f72080e7          	jalr	-142(ra) # 80006a28 <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001abe:	16848493          	addi	s1,s1,360
    80001ac2:	03248263          	beq	s1,s2,80001ae6 <procdump+0x9a>
    if (p->state == UNUSED) continue;
    80001ac6:	86a6                	mv	a3,s1
    80001ac8:	ec04a783          	lw	a5,-320(s1)
    80001acc:	dbed                	beqz	a5,80001abe <procdump+0x72>
      state = "???";
    80001ace:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ad0:	fcfb6be3          	bltu	s6,a5,80001aa6 <procdump+0x5a>
    80001ad4:	02079713          	slli	a4,a5,0x20
    80001ad8:	01d75793          	srli	a5,a4,0x1d
    80001adc:	97de                	add	a5,a5,s7
    80001ade:	6390                	ld	a2,0(a5)
    80001ae0:	f279                	bnez	a2,80001aa6 <procdump+0x5a>
      state = "???";
    80001ae2:	864e                	mv	a2,s3
    80001ae4:	b7c9                	j	80001aa6 <procdump+0x5a>
  }
}
    80001ae6:	60a6                	ld	ra,72(sp)
    80001ae8:	6406                	ld	s0,64(sp)
    80001aea:	74e2                	ld	s1,56(sp)
    80001aec:	7942                	ld	s2,48(sp)
    80001aee:	79a2                	ld	s3,40(sp)
    80001af0:	7a02                	ld	s4,32(sp)
    80001af2:	6ae2                	ld	s5,24(sp)
    80001af4:	6b42                	ld	s6,16(sp)
    80001af6:	6ba2                	ld	s7,8(sp)
    80001af8:	6161                	addi	sp,sp,80
    80001afa:	8082                	ret

0000000080001afc <swtch>:
    80001afc:	00153023          	sd	ra,0(a0)
    80001b00:	00253423          	sd	sp,8(a0)
    80001b04:	e900                	sd	s0,16(a0)
    80001b06:	ed04                	sd	s1,24(a0)
    80001b08:	03253023          	sd	s2,32(a0)
    80001b0c:	03353423          	sd	s3,40(a0)
    80001b10:	03453823          	sd	s4,48(a0)
    80001b14:	03553c23          	sd	s5,56(a0)
    80001b18:	05653023          	sd	s6,64(a0)
    80001b1c:	05753423          	sd	s7,72(a0)
    80001b20:	05853823          	sd	s8,80(a0)
    80001b24:	05953c23          	sd	s9,88(a0)
    80001b28:	07a53023          	sd	s10,96(a0)
    80001b2c:	07b53423          	sd	s11,104(a0)
    80001b30:	0005b083          	ld	ra,0(a1)
    80001b34:	0085b103          	ld	sp,8(a1)
    80001b38:	6980                	ld	s0,16(a1)
    80001b3a:	6d84                	ld	s1,24(a1)
    80001b3c:	0205b903          	ld	s2,32(a1)
    80001b40:	0285b983          	ld	s3,40(a1)
    80001b44:	0305ba03          	ld	s4,48(a1)
    80001b48:	0385ba83          	ld	s5,56(a1)
    80001b4c:	0405bb03          	ld	s6,64(a1)
    80001b50:	0485bb83          	ld	s7,72(a1)
    80001b54:	0505bc03          	ld	s8,80(a1)
    80001b58:	0585bc83          	ld	s9,88(a1)
    80001b5c:	0605bd03          	ld	s10,96(a1)
    80001b60:	0685bd83          	ld	s11,104(a1)
    80001b64:	8082                	ret

0000000080001b66 <trapinit>:
// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();

void trapinit(void) { initlock(&tickslock, "time"); }
    80001b66:	1141                	addi	sp,sp,-16
    80001b68:	e406                	sd	ra,8(sp)
    80001b6a:	e022                	sd	s0,0(sp)
    80001b6c:	0800                	addi	s0,sp,16
    80001b6e:	00007597          	auipc	a1,0x7
    80001b72:	74a58593          	addi	a1,a1,1866 # 800092b8 <states.0+0x30>
    80001b76:	0000e517          	auipc	a0,0xe
    80001b7a:	d2a50513          	addi	a0,a0,-726 # 8000f8a0 <tickslock>
    80001b7e:	00005097          	auipc	ra,0x5
    80001b82:	308080e7          	jalr	776(ra) # 80006e86 <initlock>
    80001b86:	60a2                	ld	ra,8(sp)
    80001b88:	6402                	ld	s0,0(sp)
    80001b8a:	0141                	addi	sp,sp,16
    80001b8c:	8082                	ret

0000000080001b8e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void) { w_stvec((uint64)kernelvec); }
    80001b8e:	1141                	addi	sp,sp,-16
    80001b90:	e422                	sd	s0,8(sp)
    80001b92:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001b94:	00003797          	auipc	a5,0x3
    80001b98:	4dc78793          	addi	a5,a5,1244 # 80005070 <kernelvec>
    80001b9c:	10579073          	csrw	stvec,a5
    80001ba0:	6422                	ld	s0,8(sp)
    80001ba2:	0141                	addi	sp,sp,16
    80001ba4:	8082                	ret

0000000080001ba6 <usertrapret>:
}

//
// return to user space
//
void usertrapret(void) {
    80001ba6:	1141                	addi	sp,sp,-16
    80001ba8:	e406                	sd	ra,8(sp)
    80001baa:	e022                	sd	s0,0(sp)
    80001bac:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001bae:	fffff097          	auipc	ra,0xfffff
    80001bb2:	33e080e7          	jalr	830(ra) # 80000eec <myproc>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001bb6:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80001bba:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001bbc:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001bc0:	00006697          	auipc	a3,0x6
    80001bc4:	44068693          	addi	a3,a3,1088 # 80008000 <_trampoline>
    80001bc8:	00006717          	auipc	a4,0x6
    80001bcc:	43870713          	addi	a4,a4,1080 # 80008000 <_trampoline>
    80001bd0:	8f15                	sub	a4,a4,a3
    80001bd2:	040007b7          	lui	a5,0x4000
    80001bd6:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001bd8:	07b2                	slli	a5,a5,0xc
    80001bda:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001bdc:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();          // kernel page table
    80001be0:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80001be2:	18002673          	csrr	a2,satp
    80001be6:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE;  // process's kernel stack
    80001be8:	6d30                	ld	a2,88(a0)
    80001bea:	6138                	ld	a4,64(a0)
    80001bec:	6585                	lui	a1,0x1
    80001bee:	972e                	add	a4,a4,a1
    80001bf0:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bf2:	6d38                	ld	a4,88(a0)
    80001bf4:	00000617          	auipc	a2,0x0
    80001bf8:	14260613          	addi	a2,a2,322 # 80001d36 <usertrap>
    80001bfc:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();  // hartid for cpuid()
    80001bfe:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80001c00:	8612                	mv	a2,tp
    80001c02:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001c04:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP;  // clear SPP to 0 for user mode
    80001c08:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE;  // enable interrupts in user mode
    80001c0c:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001c10:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c14:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001c16:	6f18                	ld	a4,24(a4)
    80001c18:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c1c:	6928                	ld	a0,80(a0)
    80001c1e:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001c20:	00006717          	auipc	a4,0x6
    80001c24:	47c70713          	addi	a4,a4,1148 # 8000809c <userret>
    80001c28:	8f15                	sub	a4,a4,a3
    80001c2a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001c2c:	577d                	li	a4,-1
    80001c2e:	177e                	slli	a4,a4,0x3f
    80001c30:	8d59                	or	a0,a0,a4
    80001c32:	9782                	jalr	a5
}
    80001c34:	60a2                	ld	ra,8(sp)
    80001c36:	6402                	ld	s0,0(sp)
    80001c38:	0141                	addi	sp,sp,16
    80001c3a:	8082                	ret

0000000080001c3c <clockintr>:
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr() {
    80001c3c:	1101                	addi	sp,sp,-32
    80001c3e:	ec06                	sd	ra,24(sp)
    80001c40:	e822                	sd	s0,16(sp)
    80001c42:	e426                	sd	s1,8(sp)
    80001c44:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c46:	0000e497          	auipc	s1,0xe
    80001c4a:	c5a48493          	addi	s1,s1,-934 # 8000f8a0 <tickslock>
    80001c4e:	8526                	mv	a0,s1
    80001c50:	00005097          	auipc	ra,0x5
    80001c54:	2c6080e7          	jalr	710(ra) # 80006f16 <acquire>
  ticks++;
    80001c58:	00008517          	auipc	a0,0x8
    80001c5c:	dc050513          	addi	a0,a0,-576 # 80009a18 <ticks>
    80001c60:	411c                	lw	a5,0(a0)
    80001c62:	2785                	addiw	a5,a5,1
    80001c64:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c66:	00000097          	auipc	ra,0x0
    80001c6a:	996080e7          	jalr	-1642(ra) # 800015fc <wakeup>
  release(&tickslock);
    80001c6e:	8526                	mv	a0,s1
    80001c70:	00005097          	auipc	ra,0x5
    80001c74:	35a080e7          	jalr	858(ra) # 80006fca <release>
}
    80001c78:	60e2                	ld	ra,24(sp)
    80001c7a:	6442                	ld	s0,16(sp)
    80001c7c:	64a2                	ld	s1,8(sp)
    80001c7e:	6105                	addi	sp,sp,32
    80001c80:	8082                	ret

0000000080001c82 <devintr>:
// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr() {
    80001c82:	1101                	addi	sp,sp,-32
    80001c84:	ec06                	sd	ra,24(sp)
    80001c86:	e822                	sd	s0,16(sp)
    80001c88:	e426                	sd	s1,8(sp)
    80001c8a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80001c8c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001c90:	00074d63          	bltz	a4,80001caa <devintr+0x28>
    // interrupt at a time; tell the PLIC the device is
    // now allowed to interrupt again.
    if (irq) plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000001L) {
    80001c94:	57fd                	li	a5,-1
    80001c96:	17fe                	slli	a5,a5,0x3f
    80001c98:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c9a:	4501                	li	a0,0
  } else if (scause == 0x8000000000000001L) {
    80001c9c:	06f70c63          	beq	a4,a5,80001d14 <devintr+0x92>
  }
}
    80001ca0:	60e2                	ld	ra,24(sp)
    80001ca2:	6442                	ld	s0,16(sp)
    80001ca4:	64a2                	ld	s1,8(sp)
    80001ca6:	6105                	addi	sp,sp,32
    80001ca8:	8082                	ret
  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001caa:	0ff77793          	zext.b	a5,a4
    80001cae:	46a5                	li	a3,9
    80001cb0:	fed792e3          	bne	a5,a3,80001c94 <devintr+0x12>
    int irq = plic_claim();
    80001cb4:	00003097          	auipc	ra,0x3
    80001cb8:	4de080e7          	jalr	1246(ra) # 80005192 <plic_claim>
    80001cbc:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80001cbe:	47a9                	li	a5,10
    80001cc0:	02f50563          	beq	a0,a5,80001cea <devintr+0x68>
    } else if (irq == VIRTIO0_IRQ) {
    80001cc4:	4785                	li	a5,1
    80001cc6:	02f50d63          	beq	a0,a5,80001d00 <devintr+0x7e>
    } else if (irq == E1000_IRQ) {
    80001cca:	02100793          	li	a5,33
    80001cce:	02f50e63          	beq	a0,a5,80001d0a <devintr+0x88>
    return 1;
    80001cd2:	4505                	li	a0,1
    } else if (irq) {
    80001cd4:	d4f1                	beqz	s1,80001ca0 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001cd6:	85a6                	mv	a1,s1
    80001cd8:	00007517          	auipc	a0,0x7
    80001cdc:	5e850513          	addi	a0,a0,1512 # 800092c0 <states.0+0x38>
    80001ce0:	00005097          	auipc	ra,0x5
    80001ce4:	d48080e7          	jalr	-696(ra) # 80006a28 <printf>
    80001ce8:	a029                	j	80001cf2 <devintr+0x70>
      uartintr();
    80001cea:	00005097          	auipc	ra,0x5
    80001cee:	14c080e7          	jalr	332(ra) # 80006e36 <uartintr>
    if (irq) plic_complete(irq);
    80001cf2:	8526                	mv	a0,s1
    80001cf4:	00003097          	auipc	ra,0x3
    80001cf8:	4c2080e7          	jalr	1218(ra) # 800051b6 <plic_complete>
    return 1;
    80001cfc:	4505                	li	a0,1
    80001cfe:	b74d                	j	80001ca0 <devintr+0x1e>
      virtio_disk_intr();
    80001d00:	00004097          	auipc	ra,0x4
    80001d04:	97e080e7          	jalr	-1666(ra) # 8000567e <virtio_disk_intr>
    80001d08:	b7ed                	j	80001cf2 <devintr+0x70>
      e1000_intr();
    80001d0a:	00004097          	auipc	ra,0x4
    80001d0e:	cbc080e7          	jalr	-836(ra) # 800059c6 <e1000_intr>
    80001d12:	b7c5                	j	80001cf2 <devintr+0x70>
    if (cpuid() == 0) {
    80001d14:	fffff097          	auipc	ra,0xfffff
    80001d18:	1ac080e7          	jalr	428(ra) # 80000ec0 <cpuid>
    80001d1c:	c901                	beqz	a0,80001d2c <devintr+0xaa>
  asm volatile("csrr %0, sip" : "=r"(x));
    80001d1e:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d22:	9bf5                	andi	a5,a5,-3
static inline void w_sip(uint64 x) { asm volatile("csrw sip, %0" : : "r"(x)); }
    80001d24:	14479073          	csrw	sip,a5
    return 2;
    80001d28:	4509                	li	a0,2
    80001d2a:	bf9d                	j	80001ca0 <devintr+0x1e>
      clockintr();
    80001d2c:	00000097          	auipc	ra,0x0
    80001d30:	f10080e7          	jalr	-240(ra) # 80001c3c <clockintr>
    80001d34:	b7ed                	j	80001d1e <devintr+0x9c>

0000000080001d36 <usertrap>:
void usertrap(void) {
    80001d36:	1101                	addi	sp,sp,-32
    80001d38:	ec06                	sd	ra,24(sp)
    80001d3a:	e822                	sd	s0,16(sp)
    80001d3c:	e426                	sd	s1,8(sp)
    80001d3e:	e04a                	sd	s2,0(sp)
    80001d40:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001d42:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    80001d46:	1007f793          	andi	a5,a5,256
    80001d4a:	e3b1                	bnez	a5,80001d8e <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001d4c:	00003797          	auipc	a5,0x3
    80001d50:	32478793          	addi	a5,a5,804 # 80005070 <kernelvec>
    80001d54:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d58:	fffff097          	auipc	ra,0xfffff
    80001d5c:	194080e7          	jalr	404(ra) # 80000eec <myproc>
    80001d60:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d62:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001d64:	14102773          	csrr	a4,sepc
    80001d68:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80001d6a:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80001d6e:	47a1                	li	a5,8
    80001d70:	02f70763          	beq	a4,a5,80001d9e <usertrap+0x68>
  } else if ((which_dev = devintr()) != 0) {
    80001d74:	00000097          	auipc	ra,0x0
    80001d78:	f0e080e7          	jalr	-242(ra) # 80001c82 <devintr>
    80001d7c:	892a                	mv	s2,a0
    80001d7e:	c151                	beqz	a0,80001e02 <usertrap+0xcc>
  if (killed(p)) exit(-1);
    80001d80:	8526                	mv	a0,s1
    80001d82:	00000097          	auipc	ra,0x0
    80001d86:	abe080e7          	jalr	-1346(ra) # 80001840 <killed>
    80001d8a:	c929                	beqz	a0,80001ddc <usertrap+0xa6>
    80001d8c:	a099                	j	80001dd2 <usertrap+0x9c>
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    80001d8e:	00007517          	auipc	a0,0x7
    80001d92:	55250513          	addi	a0,a0,1362 # 800092e0 <states.0+0x58>
    80001d96:	00005097          	auipc	ra,0x5
    80001d9a:	c48080e7          	jalr	-952(ra) # 800069de <panic>
    if (killed(p)) exit(-1);
    80001d9e:	00000097          	auipc	ra,0x0
    80001da2:	aa2080e7          	jalr	-1374(ra) # 80001840 <killed>
    80001da6:	e921                	bnez	a0,80001df6 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001da8:	6cb8                	ld	a4,88(s1)
    80001daa:	6f1c                	ld	a5,24(a4)
    80001dac:	0791                	addi	a5,a5,4
    80001dae:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001db0:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80001db4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001db8:	10079073          	csrw	sstatus,a5
    syscall();
    80001dbc:	00000097          	auipc	ra,0x0
    80001dc0:	2d4080e7          	jalr	724(ra) # 80002090 <syscall>
  if (killed(p)) exit(-1);
    80001dc4:	8526                	mv	a0,s1
    80001dc6:	00000097          	auipc	ra,0x0
    80001dca:	a7a080e7          	jalr	-1414(ra) # 80001840 <killed>
    80001dce:	c911                	beqz	a0,80001de2 <usertrap+0xac>
    80001dd0:	4901                	li	s2,0
    80001dd2:	557d                	li	a0,-1
    80001dd4:	00000097          	auipc	ra,0x0
    80001dd8:	8f8080e7          	jalr	-1800(ra) # 800016cc <exit>
  if (which_dev == 2) yield();
    80001ddc:	4789                	li	a5,2
    80001dde:	04f90f63          	beq	s2,a5,80001e3c <usertrap+0x106>
  usertrapret();
    80001de2:	00000097          	auipc	ra,0x0
    80001de6:	dc4080e7          	jalr	-572(ra) # 80001ba6 <usertrapret>
}
    80001dea:	60e2                	ld	ra,24(sp)
    80001dec:	6442                	ld	s0,16(sp)
    80001dee:	64a2                	ld	s1,8(sp)
    80001df0:	6902                	ld	s2,0(sp)
    80001df2:	6105                	addi	sp,sp,32
    80001df4:	8082                	ret
    if (killed(p)) exit(-1);
    80001df6:	557d                	li	a0,-1
    80001df8:	00000097          	auipc	ra,0x0
    80001dfc:	8d4080e7          	jalr	-1836(ra) # 800016cc <exit>
    80001e00:	b765                	j	80001da8 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r"(x));
    80001e02:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e06:	5890                	lw	a2,48(s1)
    80001e08:	00007517          	auipc	a0,0x7
    80001e0c:	4f850513          	addi	a0,a0,1272 # 80009300 <states.0+0x78>
    80001e10:	00005097          	auipc	ra,0x5
    80001e14:	c18080e7          	jalr	-1000(ra) # 80006a28 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001e18:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80001e1c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e20:	00007517          	auipc	a0,0x7
    80001e24:	51050513          	addi	a0,a0,1296 # 80009330 <states.0+0xa8>
    80001e28:	00005097          	auipc	ra,0x5
    80001e2c:	c00080e7          	jalr	-1024(ra) # 80006a28 <printf>
    setkilled(p);
    80001e30:	8526                	mv	a0,s1
    80001e32:	00000097          	auipc	ra,0x0
    80001e36:	9e2080e7          	jalr	-1566(ra) # 80001814 <setkilled>
    80001e3a:	b769                	j	80001dc4 <usertrap+0x8e>
  if (which_dev == 2) yield();
    80001e3c:	fffff097          	auipc	ra,0xfffff
    80001e40:	720080e7          	jalr	1824(ra) # 8000155c <yield>
    80001e44:	bf79                	j	80001de2 <usertrap+0xac>

0000000080001e46 <kerneltrap>:
void kerneltrap() {
    80001e46:	7179                	addi	sp,sp,-48
    80001e48:	f406                	sd	ra,40(sp)
    80001e4a:	f022                	sd	s0,32(sp)
    80001e4c:	ec26                	sd	s1,24(sp)
    80001e4e:	e84a                	sd	s2,16(sp)
    80001e50:	e44e                	sd	s3,8(sp)
    80001e52:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001e54:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e58:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    80001e5c:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80001e60:	1004f793          	andi	a5,s1,256
    80001e64:	cb85                	beqz	a5,80001e94 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e66:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e6a:	8b89                	andi	a5,a5,2
  if (intr_get() != 0) panic("kerneltrap: interrupts enabled");
    80001e6c:	ef85                	bnez	a5,80001ea4 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0) {
    80001e6e:	00000097          	auipc	ra,0x0
    80001e72:	e14080e7          	jalr	-492(ra) # 80001c82 <devintr>
    80001e76:	cd1d                	beqz	a0,80001eb4 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) yield();
    80001e78:	4789                	li	a5,2
    80001e7a:	06f50a63          	beq	a0,a5,80001eee <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001e7e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001e82:	10049073          	csrw	sstatus,s1
}
    80001e86:	70a2                	ld	ra,40(sp)
    80001e88:	7402                	ld	s0,32(sp)
    80001e8a:	64e2                	ld	s1,24(sp)
    80001e8c:	6942                	ld	s2,16(sp)
    80001e8e:	69a2                	ld	s3,8(sp)
    80001e90:	6145                	addi	sp,sp,48
    80001e92:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e94:	00007517          	auipc	a0,0x7
    80001e98:	4bc50513          	addi	a0,a0,1212 # 80009350 <states.0+0xc8>
    80001e9c:	00005097          	auipc	ra,0x5
    80001ea0:	b42080e7          	jalr	-1214(ra) # 800069de <panic>
  if (intr_get() != 0) panic("kerneltrap: interrupts enabled");
    80001ea4:	00007517          	auipc	a0,0x7
    80001ea8:	4d450513          	addi	a0,a0,1236 # 80009378 <states.0+0xf0>
    80001eac:	00005097          	auipc	ra,0x5
    80001eb0:	b32080e7          	jalr	-1230(ra) # 800069de <panic>
    printf("scause %p\n", scause);
    80001eb4:	85ce                	mv	a1,s3
    80001eb6:	00007517          	auipc	a0,0x7
    80001eba:	4e250513          	addi	a0,a0,1250 # 80009398 <states.0+0x110>
    80001ebe:	00005097          	auipc	ra,0x5
    80001ec2:	b6a080e7          	jalr	-1174(ra) # 80006a28 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001ec6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80001eca:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ece:	00007517          	auipc	a0,0x7
    80001ed2:	4da50513          	addi	a0,a0,1242 # 800093a8 <states.0+0x120>
    80001ed6:	00005097          	auipc	ra,0x5
    80001eda:	b52080e7          	jalr	-1198(ra) # 80006a28 <printf>
    panic("kerneltrap");
    80001ede:	00007517          	auipc	a0,0x7
    80001ee2:	4e250513          	addi	a0,a0,1250 # 800093c0 <states.0+0x138>
    80001ee6:	00005097          	auipc	ra,0x5
    80001eea:	af8080e7          	jalr	-1288(ra) # 800069de <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) yield();
    80001eee:	fffff097          	auipc	ra,0xfffff
    80001ef2:	ffe080e7          	jalr	-2(ra) # 80000eec <myproc>
    80001ef6:	d541                	beqz	a0,80001e7e <kerneltrap+0x38>
    80001ef8:	fffff097          	auipc	ra,0xfffff
    80001efc:	ff4080e7          	jalr	-12(ra) # 80000eec <myproc>
    80001f00:	4d18                	lw	a4,24(a0)
    80001f02:	4791                	li	a5,4
    80001f04:	f6f71de3          	bne	a4,a5,80001e7e <kerneltrap+0x38>
    80001f08:	fffff097          	auipc	ra,0xfffff
    80001f0c:	654080e7          	jalr	1620(ra) # 8000155c <yield>
    80001f10:	b7bd                	j	80001e7e <kerneltrap+0x38>

0000000080001f12 <argraw>:
  struct proc *p = myproc();
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
  return strlen(buf);
}

static uint64 argraw(int n) {
    80001f12:	1101                	addi	sp,sp,-32
    80001f14:	ec06                	sd	ra,24(sp)
    80001f16:	e822                	sd	s0,16(sp)
    80001f18:	e426                	sd	s1,8(sp)
    80001f1a:	1000                	addi	s0,sp,32
    80001f1c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f1e:	fffff097          	auipc	ra,0xfffff
    80001f22:	fce080e7          	jalr	-50(ra) # 80000eec <myproc>
  switch (n) {
    80001f26:	4795                	li	a5,5
    80001f28:	0497e163          	bltu	a5,s1,80001f6a <argraw+0x58>
    80001f2c:	048a                	slli	s1,s1,0x2
    80001f2e:	00007717          	auipc	a4,0x7
    80001f32:	4ca70713          	addi	a4,a4,1226 # 800093f8 <states.0+0x170>
    80001f36:	94ba                	add	s1,s1,a4
    80001f38:	409c                	lw	a5,0(s1)
    80001f3a:	97ba                	add	a5,a5,a4
    80001f3c:	8782                	jr	a5
    case 0:
      return p->trapframe->a0;
    80001f3e:	6d3c                	ld	a5,88(a0)
    80001f40:	7ba8                	ld	a0,112(a5)
    case 5:
      return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f42:	60e2                	ld	ra,24(sp)
    80001f44:	6442                	ld	s0,16(sp)
    80001f46:	64a2                	ld	s1,8(sp)
    80001f48:	6105                	addi	sp,sp,32
    80001f4a:	8082                	ret
      return p->trapframe->a1;
    80001f4c:	6d3c                	ld	a5,88(a0)
    80001f4e:	7fa8                	ld	a0,120(a5)
    80001f50:	bfcd                	j	80001f42 <argraw+0x30>
      return p->trapframe->a2;
    80001f52:	6d3c                	ld	a5,88(a0)
    80001f54:	63c8                	ld	a0,128(a5)
    80001f56:	b7f5                	j	80001f42 <argraw+0x30>
      return p->trapframe->a3;
    80001f58:	6d3c                	ld	a5,88(a0)
    80001f5a:	67c8                	ld	a0,136(a5)
    80001f5c:	b7dd                	j	80001f42 <argraw+0x30>
      return p->trapframe->a4;
    80001f5e:	6d3c                	ld	a5,88(a0)
    80001f60:	6bc8                	ld	a0,144(a5)
    80001f62:	b7c5                	j	80001f42 <argraw+0x30>
      return p->trapframe->a5;
    80001f64:	6d3c                	ld	a5,88(a0)
    80001f66:	6fc8                	ld	a0,152(a5)
    80001f68:	bfe9                	j	80001f42 <argraw+0x30>
  panic("argraw");
    80001f6a:	00007517          	auipc	a0,0x7
    80001f6e:	46650513          	addi	a0,a0,1126 # 800093d0 <states.0+0x148>
    80001f72:	00005097          	auipc	ra,0x5
    80001f76:	a6c080e7          	jalr	-1428(ra) # 800069de <panic>

0000000080001f7a <fetchaddr>:
int fetchaddr(uint64 addr, uint64 *ip) {
    80001f7a:	1101                	addi	sp,sp,-32
    80001f7c:	ec06                	sd	ra,24(sp)
    80001f7e:	e822                	sd	s0,16(sp)
    80001f80:	e426                	sd	s1,8(sp)
    80001f82:	e04a                	sd	s2,0(sp)
    80001f84:	1000                	addi	s0,sp,32
    80001f86:	84aa                	mv	s1,a0
    80001f88:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f8a:	fffff097          	auipc	ra,0xfffff
    80001f8e:	f62080e7          	jalr	-158(ra) # 80000eec <myproc>
  if (addr >= p->sz ||
    80001f92:	653c                	ld	a5,72(a0)
    80001f94:	02f4f863          	bgeu	s1,a5,80001fc4 <fetchaddr+0x4a>
      addr + sizeof(uint64) > p->sz)  // both tests needed, in case of overflow
    80001f98:	00848713          	addi	a4,s1,8
  if (addr >= p->sz ||
    80001f9c:	02e7e663          	bltu	a5,a4,80001fc8 <fetchaddr+0x4e>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0) return -1;
    80001fa0:	46a1                	li	a3,8
    80001fa2:	8626                	mv	a2,s1
    80001fa4:	85ca                	mv	a1,s2
    80001fa6:	6928                	ld	a0,80(a0)
    80001fa8:	fffff097          	auipc	ra,0xfffff
    80001fac:	c90080e7          	jalr	-880(ra) # 80000c38 <copyin>
    80001fb0:	00a03533          	snez	a0,a0
    80001fb4:	40a00533          	neg	a0,a0
}
    80001fb8:	60e2                	ld	ra,24(sp)
    80001fba:	6442                	ld	s0,16(sp)
    80001fbc:	64a2                	ld	s1,8(sp)
    80001fbe:	6902                	ld	s2,0(sp)
    80001fc0:	6105                	addi	sp,sp,32
    80001fc2:	8082                	ret
    return -1;
    80001fc4:	557d                	li	a0,-1
    80001fc6:	bfcd                	j	80001fb8 <fetchaddr+0x3e>
    80001fc8:	557d                	li	a0,-1
    80001fca:	b7fd                	j	80001fb8 <fetchaddr+0x3e>

0000000080001fcc <fetchstr>:
int fetchstr(uint64 addr, char *buf, int max) {
    80001fcc:	7179                	addi	sp,sp,-48
    80001fce:	f406                	sd	ra,40(sp)
    80001fd0:	f022                	sd	s0,32(sp)
    80001fd2:	ec26                	sd	s1,24(sp)
    80001fd4:	e84a                	sd	s2,16(sp)
    80001fd6:	e44e                	sd	s3,8(sp)
    80001fd8:	1800                	addi	s0,sp,48
    80001fda:	892a                	mv	s2,a0
    80001fdc:	84ae                	mv	s1,a1
    80001fde:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001fe0:	fffff097          	auipc	ra,0xfffff
    80001fe4:	f0c080e7          	jalr	-244(ra) # 80000eec <myproc>
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
    80001fe8:	86ce                	mv	a3,s3
    80001fea:	864a                	mv	a2,s2
    80001fec:	85a6                	mv	a1,s1
    80001fee:	6928                	ld	a0,80(a0)
    80001ff0:	fffff097          	auipc	ra,0xfffff
    80001ff4:	cd6080e7          	jalr	-810(ra) # 80000cc6 <copyinstr>
    80001ff8:	00054e63          	bltz	a0,80002014 <fetchstr+0x48>
  return strlen(buf);
    80001ffc:	8526                	mv	a0,s1
    80001ffe:	ffffe097          	auipc	ra,0xffffe
    80002002:	2f8080e7          	jalr	760(ra) # 800002f6 <strlen>
}
    80002006:	70a2                	ld	ra,40(sp)
    80002008:	7402                	ld	s0,32(sp)
    8000200a:	64e2                	ld	s1,24(sp)
    8000200c:	6942                	ld	s2,16(sp)
    8000200e:	69a2                	ld	s3,8(sp)
    80002010:	6145                	addi	sp,sp,48
    80002012:	8082                	ret
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
    80002014:	557d                	li	a0,-1
    80002016:	bfc5                	j	80002006 <fetchstr+0x3a>

0000000080002018 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip) { *ip = argraw(n); }
    80002018:	1101                	addi	sp,sp,-32
    8000201a:	ec06                	sd	ra,24(sp)
    8000201c:	e822                	sd	s0,16(sp)
    8000201e:	e426                	sd	s1,8(sp)
    80002020:	1000                	addi	s0,sp,32
    80002022:	84ae                	mv	s1,a1
    80002024:	00000097          	auipc	ra,0x0
    80002028:	eee080e7          	jalr	-274(ra) # 80001f12 <argraw>
    8000202c:	c088                	sw	a0,0(s1)
    8000202e:	60e2                	ld	ra,24(sp)
    80002030:	6442                	ld	s0,16(sp)
    80002032:	64a2                	ld	s1,8(sp)
    80002034:	6105                	addi	sp,sp,32
    80002036:	8082                	ret

0000000080002038 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip) { *ip = argraw(n); }
    80002038:	1101                	addi	sp,sp,-32
    8000203a:	ec06                	sd	ra,24(sp)
    8000203c:	e822                	sd	s0,16(sp)
    8000203e:	e426                	sd	s1,8(sp)
    80002040:	1000                	addi	s0,sp,32
    80002042:	84ae                	mv	s1,a1
    80002044:	00000097          	auipc	ra,0x0
    80002048:	ece080e7          	jalr	-306(ra) # 80001f12 <argraw>
    8000204c:	e088                	sd	a0,0(s1)
    8000204e:	60e2                	ld	ra,24(sp)
    80002050:	6442                	ld	s0,16(sp)
    80002052:	64a2                	ld	s1,8(sp)
    80002054:	6105                	addi	sp,sp,32
    80002056:	8082                	ret

0000000080002058 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max) {
    80002058:	7179                	addi	sp,sp,-48
    8000205a:	f406                	sd	ra,40(sp)
    8000205c:	f022                	sd	s0,32(sp)
    8000205e:	ec26                	sd	s1,24(sp)
    80002060:	e84a                	sd	s2,16(sp)
    80002062:	1800                	addi	s0,sp,48
    80002064:	84ae                	mv	s1,a1
    80002066:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002068:	fd840593          	addi	a1,s0,-40
    8000206c:	00000097          	auipc	ra,0x0
    80002070:	fcc080e7          	jalr	-52(ra) # 80002038 <argaddr>
  return fetchstr(addr, buf, max);
    80002074:	864a                	mv	a2,s2
    80002076:	85a6                	mv	a1,s1
    80002078:	fd843503          	ld	a0,-40(s0)
    8000207c:	00000097          	auipc	ra,0x0
    80002080:	f50080e7          	jalr	-176(ra) # 80001fcc <fetchstr>
}
    80002084:	70a2                	ld	ra,40(sp)
    80002086:	7402                	ld	s0,32(sp)
    80002088:	64e2                	ld	s1,24(sp)
    8000208a:	6942                	ld	s2,16(sp)
    8000208c:	6145                	addi	sp,sp,48
    8000208e:	8082                	ret

0000000080002090 <syscall>:
    [SYS_link] = sys_link,     [SYS_mkdir] = sys_mkdir,
    [SYS_close] = sys_close,   [SYS_bind] = sys_bind,
    [SYS_unbind] = sys_unbind, [SYS_send] = sys_send,
    [SYS_recv] = sys_recv};

void syscall(void) {
    80002090:	1101                	addi	sp,sp,-32
    80002092:	ec06                	sd	ra,24(sp)
    80002094:	e822                	sd	s0,16(sp)
    80002096:	e426                	sd	s1,8(sp)
    80002098:	e04a                	sd	s2,0(sp)
    8000209a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000209c:	fffff097          	auipc	ra,0xfffff
    800020a0:	e50080e7          	jalr	-432(ra) # 80000eec <myproc>
    800020a4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800020a6:	05853903          	ld	s2,88(a0)
    800020aa:	0a893783          	ld	a5,168(s2)
    800020ae:	0007869b          	sext.w	a3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020b2:	37fd                	addiw	a5,a5,-1
    800020b4:	4761                	li	a4,24
    800020b6:	00f76f63          	bltu	a4,a5,800020d4 <syscall+0x44>
    800020ba:	00369713          	slli	a4,a3,0x3
    800020be:	00007797          	auipc	a5,0x7
    800020c2:	35278793          	addi	a5,a5,850 # 80009410 <syscalls>
    800020c6:	97ba                	add	a5,a5,a4
    800020c8:	639c                	ld	a5,0(a5)
    800020ca:	c789                	beqz	a5,800020d4 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800020cc:	9782                	jalr	a5
    800020ce:	06a93823          	sd	a0,112(s2)
    800020d2:	a839                	j	800020f0 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    800020d4:	15848613          	addi	a2,s1,344
    800020d8:	588c                	lw	a1,48(s1)
    800020da:	00007517          	auipc	a0,0x7
    800020de:	2fe50513          	addi	a0,a0,766 # 800093d8 <states.0+0x150>
    800020e2:	00005097          	auipc	ra,0x5
    800020e6:	946080e7          	jalr	-1722(ra) # 80006a28 <printf>
    p->trapframe->a0 = -1;
    800020ea:	6cbc                	ld	a5,88(s1)
    800020ec:	577d                	li	a4,-1
    800020ee:	fbb8                	sd	a4,112(a5)
  }
}
    800020f0:	60e2                	ld	ra,24(sp)
    800020f2:	6442                	ld	s0,16(sp)
    800020f4:	64a2                	ld	s1,8(sp)
    800020f6:	6902                	ld	s2,0(sp)
    800020f8:	6105                	addi	sp,sp,32
    800020fa:	8082                	ret

00000000800020fc <sys_exit>:
#include "defs.h"
#include "proc.h"
#include "types.h"

uint64 sys_exit(void) {
    800020fc:	1101                	addi	sp,sp,-32
    800020fe:	ec06                	sd	ra,24(sp)
    80002100:	e822                	sd	s0,16(sp)
    80002102:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002104:	fec40593          	addi	a1,s0,-20
    80002108:	4501                	li	a0,0
    8000210a:	00000097          	auipc	ra,0x0
    8000210e:	f0e080e7          	jalr	-242(ra) # 80002018 <argint>
  exit(n);
    80002112:	fec42503          	lw	a0,-20(s0)
    80002116:	fffff097          	auipc	ra,0xfffff
    8000211a:	5b6080e7          	jalr	1462(ra) # 800016cc <exit>
  return 0;  // not reached
}
    8000211e:	4501                	li	a0,0
    80002120:	60e2                	ld	ra,24(sp)
    80002122:	6442                	ld	s0,16(sp)
    80002124:	6105                	addi	sp,sp,32
    80002126:	8082                	ret

0000000080002128 <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    80002128:	1141                	addi	sp,sp,-16
    8000212a:	e406                	sd	ra,8(sp)
    8000212c:	e022                	sd	s0,0(sp)
    8000212e:	0800                	addi	s0,sp,16
    80002130:	fffff097          	auipc	ra,0xfffff
    80002134:	dbc080e7          	jalr	-580(ra) # 80000eec <myproc>
    80002138:	5908                	lw	a0,48(a0)
    8000213a:	60a2                	ld	ra,8(sp)
    8000213c:	6402                	ld	s0,0(sp)
    8000213e:	0141                	addi	sp,sp,16
    80002140:	8082                	ret

0000000080002142 <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    80002142:	1141                	addi	sp,sp,-16
    80002144:	e406                	sd	ra,8(sp)
    80002146:	e022                	sd	s0,0(sp)
    80002148:	0800                	addi	s0,sp,16
    8000214a:	fffff097          	auipc	ra,0xfffff
    8000214e:	15c080e7          	jalr	348(ra) # 800012a6 <fork>
    80002152:	60a2                	ld	ra,8(sp)
    80002154:	6402                	ld	s0,0(sp)
    80002156:	0141                	addi	sp,sp,16
    80002158:	8082                	ret

000000008000215a <sys_wait>:

uint64 sys_wait(void) {
    8000215a:	1101                	addi	sp,sp,-32
    8000215c:	ec06                	sd	ra,24(sp)
    8000215e:	e822                	sd	s0,16(sp)
    80002160:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002162:	fe840593          	addi	a1,s0,-24
    80002166:	4501                	li	a0,0
    80002168:	00000097          	auipc	ra,0x0
    8000216c:	ed0080e7          	jalr	-304(ra) # 80002038 <argaddr>
  return wait(p);
    80002170:	fe843503          	ld	a0,-24(s0)
    80002174:	fffff097          	auipc	ra,0xfffff
    80002178:	6fe080e7          	jalr	1790(ra) # 80001872 <wait>
}
    8000217c:	60e2                	ld	ra,24(sp)
    8000217e:	6442                	ld	s0,16(sp)
    80002180:	6105                	addi	sp,sp,32
    80002182:	8082                	ret

0000000080002184 <sys_sbrk>:

uint64 sys_sbrk(void) {
    80002184:	7179                	addi	sp,sp,-48
    80002186:	f406                	sd	ra,40(sp)
    80002188:	f022                	sd	s0,32(sp)
    8000218a:	ec26                	sd	s1,24(sp)
    8000218c:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000218e:	fdc40593          	addi	a1,s0,-36
    80002192:	4501                	li	a0,0
    80002194:	00000097          	auipc	ra,0x0
    80002198:	e84080e7          	jalr	-380(ra) # 80002018 <argint>
  addr = myproc()->sz;
    8000219c:	fffff097          	auipc	ra,0xfffff
    800021a0:	d50080e7          	jalr	-688(ra) # 80000eec <myproc>
    800021a4:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0) return -1;
    800021a6:	fdc42503          	lw	a0,-36(s0)
    800021aa:	fffff097          	auipc	ra,0xfffff
    800021ae:	0a0080e7          	jalr	160(ra) # 8000124a <growproc>
    800021b2:	00054863          	bltz	a0,800021c2 <sys_sbrk+0x3e>
  return addr;
}
    800021b6:	8526                	mv	a0,s1
    800021b8:	70a2                	ld	ra,40(sp)
    800021ba:	7402                	ld	s0,32(sp)
    800021bc:	64e2                	ld	s1,24(sp)
    800021be:	6145                	addi	sp,sp,48
    800021c0:	8082                	ret
  if (growproc(n) < 0) return -1;
    800021c2:	54fd                	li	s1,-1
    800021c4:	bfcd                	j	800021b6 <sys_sbrk+0x32>

00000000800021c6 <sys_sleep>:

uint64 sys_sleep(void) {
    800021c6:	7139                	addi	sp,sp,-64
    800021c8:	fc06                	sd	ra,56(sp)
    800021ca:	f822                	sd	s0,48(sp)
    800021cc:	f426                	sd	s1,40(sp)
    800021ce:	f04a                	sd	s2,32(sp)
    800021d0:	ec4e                	sd	s3,24(sp)
    800021d2:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800021d4:	fcc40593          	addi	a1,s0,-52
    800021d8:	4501                	li	a0,0
    800021da:	00000097          	auipc	ra,0x0
    800021de:	e3e080e7          	jalr	-450(ra) # 80002018 <argint>
  if (n < 0) n = 0;
    800021e2:	fcc42783          	lw	a5,-52(s0)
    800021e6:	0607cf63          	bltz	a5,80002264 <sys_sleep+0x9e>
  acquire(&tickslock);
    800021ea:	0000d517          	auipc	a0,0xd
    800021ee:	6b650513          	addi	a0,a0,1718 # 8000f8a0 <tickslock>
    800021f2:	00005097          	auipc	ra,0x5
    800021f6:	d24080e7          	jalr	-732(ra) # 80006f16 <acquire>
  ticks0 = ticks;
    800021fa:	00008917          	auipc	s2,0x8
    800021fe:	81e92903          	lw	s2,-2018(s2) # 80009a18 <ticks>
  while (ticks - ticks0 < n) {
    80002202:	fcc42783          	lw	a5,-52(s0)
    80002206:	cf9d                	beqz	a5,80002244 <sys_sleep+0x7e>
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002208:	0000d997          	auipc	s3,0xd
    8000220c:	69898993          	addi	s3,s3,1688 # 8000f8a0 <tickslock>
    80002210:	00008497          	auipc	s1,0x8
    80002214:	80848493          	addi	s1,s1,-2040 # 80009a18 <ticks>
    if (killed(myproc())) {
    80002218:	fffff097          	auipc	ra,0xfffff
    8000221c:	cd4080e7          	jalr	-812(ra) # 80000eec <myproc>
    80002220:	fffff097          	auipc	ra,0xfffff
    80002224:	620080e7          	jalr	1568(ra) # 80001840 <killed>
    80002228:	e129                	bnez	a0,8000226a <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    8000222a:	85ce                	mv	a1,s3
    8000222c:	8526                	mv	a0,s1
    8000222e:	fffff097          	auipc	ra,0xfffff
    80002232:	36a080e7          	jalr	874(ra) # 80001598 <sleep>
  while (ticks - ticks0 < n) {
    80002236:	409c                	lw	a5,0(s1)
    80002238:	412787bb          	subw	a5,a5,s2
    8000223c:	fcc42703          	lw	a4,-52(s0)
    80002240:	fce7ece3          	bltu	a5,a4,80002218 <sys_sleep+0x52>
  }
  release(&tickslock);
    80002244:	0000d517          	auipc	a0,0xd
    80002248:	65c50513          	addi	a0,a0,1628 # 8000f8a0 <tickslock>
    8000224c:	00005097          	auipc	ra,0x5
    80002250:	d7e080e7          	jalr	-642(ra) # 80006fca <release>
  return 0;
    80002254:	4501                	li	a0,0
}
    80002256:	70e2                	ld	ra,56(sp)
    80002258:	7442                	ld	s0,48(sp)
    8000225a:	74a2                	ld	s1,40(sp)
    8000225c:	7902                	ld	s2,32(sp)
    8000225e:	69e2                	ld	s3,24(sp)
    80002260:	6121                	addi	sp,sp,64
    80002262:	8082                	ret
  if (n < 0) n = 0;
    80002264:	fc042623          	sw	zero,-52(s0)
    80002268:	b749                	j	800021ea <sys_sleep+0x24>
      release(&tickslock);
    8000226a:	0000d517          	auipc	a0,0xd
    8000226e:	63650513          	addi	a0,a0,1590 # 8000f8a0 <tickslock>
    80002272:	00005097          	auipc	ra,0x5
    80002276:	d58080e7          	jalr	-680(ra) # 80006fca <release>
      return -1;
    8000227a:	557d                	li	a0,-1
    8000227c:	bfe9                	j	80002256 <sys_sleep+0x90>

000000008000227e <sys_kill>:

uint64 sys_kill(void) {
    8000227e:	1101                	addi	sp,sp,-32
    80002280:	ec06                	sd	ra,24(sp)
    80002282:	e822                	sd	s0,16(sp)
    80002284:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002286:	fec40593          	addi	a1,s0,-20
    8000228a:	4501                	li	a0,0
    8000228c:	00000097          	auipc	ra,0x0
    80002290:	d8c080e7          	jalr	-628(ra) # 80002018 <argint>
  return kill(pid);
    80002294:	fec42503          	lw	a0,-20(s0)
    80002298:	fffff097          	auipc	ra,0xfffff
    8000229c:	50a080e7          	jalr	1290(ra) # 800017a2 <kill>
}
    800022a0:	60e2                	ld	ra,24(sp)
    800022a2:	6442                	ld	s0,16(sp)
    800022a4:	6105                	addi	sp,sp,32
    800022a6:	8082                	ret

00000000800022a8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    800022a8:	1101                	addi	sp,sp,-32
    800022aa:	ec06                	sd	ra,24(sp)
    800022ac:	e822                	sd	s0,16(sp)
    800022ae:	e426                	sd	s1,8(sp)
    800022b0:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022b2:	0000d517          	auipc	a0,0xd
    800022b6:	5ee50513          	addi	a0,a0,1518 # 8000f8a0 <tickslock>
    800022ba:	00005097          	auipc	ra,0x5
    800022be:	c5c080e7          	jalr	-932(ra) # 80006f16 <acquire>
  xticks = ticks;
    800022c2:	00007497          	auipc	s1,0x7
    800022c6:	7564a483          	lw	s1,1878(s1) # 80009a18 <ticks>
  release(&tickslock);
    800022ca:	0000d517          	auipc	a0,0xd
    800022ce:	5d650513          	addi	a0,a0,1494 # 8000f8a0 <tickslock>
    800022d2:	00005097          	auipc	ra,0x5
    800022d6:	cf8080e7          	jalr	-776(ra) # 80006fca <release>
  return xticks;
}
    800022da:	02049513          	slli	a0,s1,0x20
    800022de:	9101                	srli	a0,a0,0x20
    800022e0:	60e2                	ld	ra,24(sp)
    800022e2:	6442                	ld	s0,16(sp)
    800022e4:	64a2                	ld	s1,8(sp)
    800022e6:	6105                	addi	sp,sp,32
    800022e8:	8082                	ret

00000000800022ea <binit>:
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  struct buf head;
} bcache;

void binit(void) {
    800022ea:	7179                	addi	sp,sp,-48
    800022ec:	f406                	sd	ra,40(sp)
    800022ee:	f022                	sd	s0,32(sp)
    800022f0:	ec26                	sd	s1,24(sp)
    800022f2:	e84a                	sd	s2,16(sp)
    800022f4:	e44e                	sd	s3,8(sp)
    800022f6:	e052                	sd	s4,0(sp)
    800022f8:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800022fa:	00007597          	auipc	a1,0x7
    800022fe:	1e658593          	addi	a1,a1,486 # 800094e0 <syscalls+0xd0>
    80002302:	0000d517          	auipc	a0,0xd
    80002306:	5b650513          	addi	a0,a0,1462 # 8000f8b8 <bcache>
    8000230a:	00005097          	auipc	ra,0x5
    8000230e:	b7c080e7          	jalr	-1156(ra) # 80006e86 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002312:	00015797          	auipc	a5,0x15
    80002316:	5a678793          	addi	a5,a5,1446 # 800178b8 <bcache+0x8000>
    8000231a:	00016717          	auipc	a4,0x16
    8000231e:	80670713          	addi	a4,a4,-2042 # 80017b20 <bcache+0x8268>
    80002322:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002326:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    8000232a:	0000d497          	auipc	s1,0xd
    8000232e:	5a648493          	addi	s1,s1,1446 # 8000f8d0 <bcache+0x18>
    b->next = bcache.head.next;
    80002332:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002334:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002336:	00007a17          	auipc	s4,0x7
    8000233a:	1b2a0a13          	addi	s4,s4,434 # 800094e8 <syscalls+0xd8>
    b->next = bcache.head.next;
    8000233e:	2b893783          	ld	a5,696(s2)
    80002342:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002344:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002348:	85d2                	mv	a1,s4
    8000234a:	01048513          	addi	a0,s1,16
    8000234e:	00001097          	auipc	ra,0x1
    80002352:	4c8080e7          	jalr	1224(ra) # 80003816 <initsleeplock>
    bcache.head.next->prev = b;
    80002356:	2b893783          	ld	a5,696(s2)
    8000235a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000235c:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002360:	45848493          	addi	s1,s1,1112
    80002364:	fd349de3          	bne	s1,s3,8000233e <binit+0x54>
  }
}
    80002368:	70a2                	ld	ra,40(sp)
    8000236a:	7402                	ld	s0,32(sp)
    8000236c:	64e2                	ld	s1,24(sp)
    8000236e:	6942                	ld	s2,16(sp)
    80002370:	69a2                	ld	s3,8(sp)
    80002372:	6a02                	ld	s4,0(sp)
    80002374:	6145                	addi	sp,sp,48
    80002376:	8082                	ret

0000000080002378 <bread>:
  }
  panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf *bread(uint dev, uint blockno) {
    80002378:	7179                	addi	sp,sp,-48
    8000237a:	f406                	sd	ra,40(sp)
    8000237c:	f022                	sd	s0,32(sp)
    8000237e:	ec26                	sd	s1,24(sp)
    80002380:	e84a                	sd	s2,16(sp)
    80002382:	e44e                	sd	s3,8(sp)
    80002384:	1800                	addi	s0,sp,48
    80002386:	892a                	mv	s2,a0
    80002388:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000238a:	0000d517          	auipc	a0,0xd
    8000238e:	52e50513          	addi	a0,a0,1326 # 8000f8b8 <bcache>
    80002392:	00005097          	auipc	ra,0x5
    80002396:	b84080e7          	jalr	-1148(ra) # 80006f16 <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    8000239a:	00015497          	auipc	s1,0x15
    8000239e:	7d64b483          	ld	s1,2006(s1) # 80017b70 <bcache+0x82b8>
    800023a2:	00015797          	auipc	a5,0x15
    800023a6:	77e78793          	addi	a5,a5,1918 # 80017b20 <bcache+0x8268>
    800023aa:	02f48f63          	beq	s1,a5,800023e8 <bread+0x70>
    800023ae:	873e                	mv	a4,a5
    800023b0:	a021                	j	800023b8 <bread+0x40>
    800023b2:	68a4                	ld	s1,80(s1)
    800023b4:	02e48a63          	beq	s1,a4,800023e8 <bread+0x70>
    if (b->dev == dev && b->blockno == blockno) {
    800023b8:	449c                	lw	a5,8(s1)
    800023ba:	ff279ce3          	bne	a5,s2,800023b2 <bread+0x3a>
    800023be:	44dc                	lw	a5,12(s1)
    800023c0:	ff3799e3          	bne	a5,s3,800023b2 <bread+0x3a>
      b->refcnt++;
    800023c4:	40bc                	lw	a5,64(s1)
    800023c6:	2785                	addiw	a5,a5,1
    800023c8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023ca:	0000d517          	auipc	a0,0xd
    800023ce:	4ee50513          	addi	a0,a0,1262 # 8000f8b8 <bcache>
    800023d2:	00005097          	auipc	ra,0x5
    800023d6:	bf8080e7          	jalr	-1032(ra) # 80006fca <release>
      acquiresleep(&b->lock);
    800023da:	01048513          	addi	a0,s1,16
    800023de:	00001097          	auipc	ra,0x1
    800023e2:	472080e7          	jalr	1138(ra) # 80003850 <acquiresleep>
      return b;
    800023e6:	a8b9                	j	80002444 <bread+0xcc>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    800023e8:	00015497          	auipc	s1,0x15
    800023ec:	7804b483          	ld	s1,1920(s1) # 80017b68 <bcache+0x82b0>
    800023f0:	00015797          	auipc	a5,0x15
    800023f4:	73078793          	addi	a5,a5,1840 # 80017b20 <bcache+0x8268>
    800023f8:	00f48863          	beq	s1,a5,80002408 <bread+0x90>
    800023fc:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    800023fe:	40bc                	lw	a5,64(s1)
    80002400:	cf81                	beqz	a5,80002418 <bread+0xa0>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002402:	64a4                	ld	s1,72(s1)
    80002404:	fee49de3          	bne	s1,a4,800023fe <bread+0x86>
  panic("bget: no buffers");
    80002408:	00007517          	auipc	a0,0x7
    8000240c:	0e850513          	addi	a0,a0,232 # 800094f0 <syscalls+0xe0>
    80002410:	00004097          	auipc	ra,0x4
    80002414:	5ce080e7          	jalr	1486(ra) # 800069de <panic>
      b->dev = dev;
    80002418:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000241c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002420:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002424:	4785                	li	a5,1
    80002426:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002428:	0000d517          	auipc	a0,0xd
    8000242c:	49050513          	addi	a0,a0,1168 # 8000f8b8 <bcache>
    80002430:	00005097          	auipc	ra,0x5
    80002434:	b9a080e7          	jalr	-1126(ra) # 80006fca <release>
      acquiresleep(&b->lock);
    80002438:	01048513          	addi	a0,s1,16
    8000243c:	00001097          	auipc	ra,0x1
    80002440:	414080e7          	jalr	1044(ra) # 80003850 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    80002444:	409c                	lw	a5,0(s1)
    80002446:	cb89                	beqz	a5,80002458 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002448:	8526                	mv	a0,s1
    8000244a:	70a2                	ld	ra,40(sp)
    8000244c:	7402                	ld	s0,32(sp)
    8000244e:	64e2                	ld	s1,24(sp)
    80002450:	6942                	ld	s2,16(sp)
    80002452:	69a2                	ld	s3,8(sp)
    80002454:	6145                	addi	sp,sp,48
    80002456:	8082                	ret
    virtio_disk_rw(b, 0);
    80002458:	4581                	li	a1,0
    8000245a:	8526                	mv	a0,s1
    8000245c:	00003097          	auipc	ra,0x3
    80002460:	ff0080e7          	jalr	-16(ra) # 8000544c <virtio_disk_rw>
    b->valid = 1;
    80002464:	4785                	li	a5,1
    80002466:	c09c                	sw	a5,0(s1)
  return b;
    80002468:	b7c5                	j	80002448 <bread+0xd0>

000000008000246a <bwrite>:

// Write b's contents to disk.  Must be locked.
void bwrite(struct buf *b) {
    8000246a:	1101                	addi	sp,sp,-32
    8000246c:	ec06                	sd	ra,24(sp)
    8000246e:	e822                	sd	s0,16(sp)
    80002470:	e426                	sd	s1,8(sp)
    80002472:	1000                	addi	s0,sp,32
    80002474:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock)) panic("bwrite");
    80002476:	0541                	addi	a0,a0,16
    80002478:	00001097          	auipc	ra,0x1
    8000247c:	472080e7          	jalr	1138(ra) # 800038ea <holdingsleep>
    80002480:	cd01                	beqz	a0,80002498 <bwrite+0x2e>
  virtio_disk_rw(b, 1);
    80002482:	4585                	li	a1,1
    80002484:	8526                	mv	a0,s1
    80002486:	00003097          	auipc	ra,0x3
    8000248a:	fc6080e7          	jalr	-58(ra) # 8000544c <virtio_disk_rw>
}
    8000248e:	60e2                	ld	ra,24(sp)
    80002490:	6442                	ld	s0,16(sp)
    80002492:	64a2                	ld	s1,8(sp)
    80002494:	6105                	addi	sp,sp,32
    80002496:	8082                	ret
  if (!holdingsleep(&b->lock)) panic("bwrite");
    80002498:	00007517          	auipc	a0,0x7
    8000249c:	07050513          	addi	a0,a0,112 # 80009508 <syscalls+0xf8>
    800024a0:	00004097          	auipc	ra,0x4
    800024a4:	53e080e7          	jalr	1342(ra) # 800069de <panic>

00000000800024a8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void brelse(struct buf *b) {
    800024a8:	1101                	addi	sp,sp,-32
    800024aa:	ec06                	sd	ra,24(sp)
    800024ac:	e822                	sd	s0,16(sp)
    800024ae:	e426                	sd	s1,8(sp)
    800024b0:	e04a                	sd	s2,0(sp)
    800024b2:	1000                	addi	s0,sp,32
    800024b4:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock)) panic("brelse");
    800024b6:	01050913          	addi	s2,a0,16
    800024ba:	854a                	mv	a0,s2
    800024bc:	00001097          	auipc	ra,0x1
    800024c0:	42e080e7          	jalr	1070(ra) # 800038ea <holdingsleep>
    800024c4:	c92d                	beqz	a0,80002536 <brelse+0x8e>

  releasesleep(&b->lock);
    800024c6:	854a                	mv	a0,s2
    800024c8:	00001097          	auipc	ra,0x1
    800024cc:	3de080e7          	jalr	990(ra) # 800038a6 <releasesleep>

  acquire(&bcache.lock);
    800024d0:	0000d517          	auipc	a0,0xd
    800024d4:	3e850513          	addi	a0,a0,1000 # 8000f8b8 <bcache>
    800024d8:	00005097          	auipc	ra,0x5
    800024dc:	a3e080e7          	jalr	-1474(ra) # 80006f16 <acquire>
  b->refcnt--;
    800024e0:	40bc                	lw	a5,64(s1)
    800024e2:	37fd                	addiw	a5,a5,-1
    800024e4:	0007871b          	sext.w	a4,a5
    800024e8:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800024ea:	eb05                	bnez	a4,8000251a <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800024ec:	68bc                	ld	a5,80(s1)
    800024ee:	64b8                	ld	a4,72(s1)
    800024f0:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800024f2:	64bc                	ld	a5,72(s1)
    800024f4:	68b8                	ld	a4,80(s1)
    800024f6:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800024f8:	00015797          	auipc	a5,0x15
    800024fc:	3c078793          	addi	a5,a5,960 # 800178b8 <bcache+0x8000>
    80002500:	2b87b703          	ld	a4,696(a5)
    80002504:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002506:	00015717          	auipc	a4,0x15
    8000250a:	61a70713          	addi	a4,a4,1562 # 80017b20 <bcache+0x8268>
    8000250e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002510:	2b87b703          	ld	a4,696(a5)
    80002514:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002516:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    8000251a:	0000d517          	auipc	a0,0xd
    8000251e:	39e50513          	addi	a0,a0,926 # 8000f8b8 <bcache>
    80002522:	00005097          	auipc	ra,0x5
    80002526:	aa8080e7          	jalr	-1368(ra) # 80006fca <release>
}
    8000252a:	60e2                	ld	ra,24(sp)
    8000252c:	6442                	ld	s0,16(sp)
    8000252e:	64a2                	ld	s1,8(sp)
    80002530:	6902                	ld	s2,0(sp)
    80002532:	6105                	addi	sp,sp,32
    80002534:	8082                	ret
  if (!holdingsleep(&b->lock)) panic("brelse");
    80002536:	00007517          	auipc	a0,0x7
    8000253a:	fda50513          	addi	a0,a0,-38 # 80009510 <syscalls+0x100>
    8000253e:	00004097          	auipc	ra,0x4
    80002542:	4a0080e7          	jalr	1184(ra) # 800069de <panic>

0000000080002546 <bpin>:

void bpin(struct buf *b) {
    80002546:	1101                	addi	sp,sp,-32
    80002548:	ec06                	sd	ra,24(sp)
    8000254a:	e822                	sd	s0,16(sp)
    8000254c:	e426                	sd	s1,8(sp)
    8000254e:	1000                	addi	s0,sp,32
    80002550:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002552:	0000d517          	auipc	a0,0xd
    80002556:	36650513          	addi	a0,a0,870 # 8000f8b8 <bcache>
    8000255a:	00005097          	auipc	ra,0x5
    8000255e:	9bc080e7          	jalr	-1604(ra) # 80006f16 <acquire>
  b->refcnt++;
    80002562:	40bc                	lw	a5,64(s1)
    80002564:	2785                	addiw	a5,a5,1
    80002566:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002568:	0000d517          	auipc	a0,0xd
    8000256c:	35050513          	addi	a0,a0,848 # 8000f8b8 <bcache>
    80002570:	00005097          	auipc	ra,0x5
    80002574:	a5a080e7          	jalr	-1446(ra) # 80006fca <release>
}
    80002578:	60e2                	ld	ra,24(sp)
    8000257a:	6442                	ld	s0,16(sp)
    8000257c:	64a2                	ld	s1,8(sp)
    8000257e:	6105                	addi	sp,sp,32
    80002580:	8082                	ret

0000000080002582 <bunpin>:

void bunpin(struct buf *b) {
    80002582:	1101                	addi	sp,sp,-32
    80002584:	ec06                	sd	ra,24(sp)
    80002586:	e822                	sd	s0,16(sp)
    80002588:	e426                	sd	s1,8(sp)
    8000258a:	1000                	addi	s0,sp,32
    8000258c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000258e:	0000d517          	auipc	a0,0xd
    80002592:	32a50513          	addi	a0,a0,810 # 8000f8b8 <bcache>
    80002596:	00005097          	auipc	ra,0x5
    8000259a:	980080e7          	jalr	-1664(ra) # 80006f16 <acquire>
  b->refcnt--;
    8000259e:	40bc                	lw	a5,64(s1)
    800025a0:	37fd                	addiw	a5,a5,-1
    800025a2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025a4:	0000d517          	auipc	a0,0xd
    800025a8:	31450513          	addi	a0,a0,788 # 8000f8b8 <bcache>
    800025ac:	00005097          	auipc	ra,0x5
    800025b0:	a1e080e7          	jalr	-1506(ra) # 80006fca <release>
}
    800025b4:	60e2                	ld	ra,24(sp)
    800025b6:	6442                	ld	s0,16(sp)
    800025b8:	64a2                	ld	s1,8(sp)
    800025ba:	6105                	addi	sp,sp,32
    800025bc:	8082                	ret

00000000800025be <bfree>:
  printf("balloc: out of blocks\n");
  return 0;
}

// Free a disk block.
static void bfree(int dev, uint b) {
    800025be:	1101                	addi	sp,sp,-32
    800025c0:	ec06                	sd	ra,24(sp)
    800025c2:	e822                	sd	s0,16(sp)
    800025c4:	e426                	sd	s1,8(sp)
    800025c6:	e04a                	sd	s2,0(sp)
    800025c8:	1000                	addi	s0,sp,32
    800025ca:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800025cc:	00d5d59b          	srliw	a1,a1,0xd
    800025d0:	00016797          	auipc	a5,0x16
    800025d4:	9c47a783          	lw	a5,-1596(a5) # 80017f94 <sb+0x1c>
    800025d8:	9dbd                	addw	a1,a1,a5
    800025da:	00000097          	auipc	ra,0x0
    800025de:	d9e080e7          	jalr	-610(ra) # 80002378 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800025e2:	0074f713          	andi	a4,s1,7
    800025e6:	4785                	li	a5,1
    800025e8:	00e797bb          	sllw	a5,a5,a4
  if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
    800025ec:	14ce                	slli	s1,s1,0x33
    800025ee:	90d9                	srli	s1,s1,0x36
    800025f0:	00950733          	add	a4,a0,s1
    800025f4:	05874703          	lbu	a4,88(a4)
    800025f8:	00e7f6b3          	and	a3,a5,a4
    800025fc:	c69d                	beqz	a3,8000262a <bfree+0x6c>
    800025fe:	892a                	mv	s2,a0
  bp->data[bi / 8] &= ~m;
    80002600:	94aa                	add	s1,s1,a0
    80002602:	fff7c793          	not	a5,a5
    80002606:	8f7d                	and	a4,a4,a5
    80002608:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000260c:	00001097          	auipc	ra,0x1
    80002610:	126080e7          	jalr	294(ra) # 80003732 <log_write>
  brelse(bp);
    80002614:	854a                	mv	a0,s2
    80002616:	00000097          	auipc	ra,0x0
    8000261a:	e92080e7          	jalr	-366(ra) # 800024a8 <brelse>
}
    8000261e:	60e2                	ld	ra,24(sp)
    80002620:	6442                	ld	s0,16(sp)
    80002622:	64a2                	ld	s1,8(sp)
    80002624:	6902                	ld	s2,0(sp)
    80002626:	6105                	addi	sp,sp,32
    80002628:	8082                	ret
  if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
    8000262a:	00007517          	auipc	a0,0x7
    8000262e:	eee50513          	addi	a0,a0,-274 # 80009518 <syscalls+0x108>
    80002632:	00004097          	auipc	ra,0x4
    80002636:	3ac080e7          	jalr	940(ra) # 800069de <panic>

000000008000263a <balloc>:
static uint balloc(uint dev) {
    8000263a:	711d                	addi	sp,sp,-96
    8000263c:	ec86                	sd	ra,88(sp)
    8000263e:	e8a2                	sd	s0,80(sp)
    80002640:	e4a6                	sd	s1,72(sp)
    80002642:	e0ca                	sd	s2,64(sp)
    80002644:	fc4e                	sd	s3,56(sp)
    80002646:	f852                	sd	s4,48(sp)
    80002648:	f456                	sd	s5,40(sp)
    8000264a:	f05a                	sd	s6,32(sp)
    8000264c:	ec5e                	sd	s7,24(sp)
    8000264e:	e862                	sd	s8,16(sp)
    80002650:	e466                	sd	s9,8(sp)
    80002652:	1080                	addi	s0,sp,96
  for (b = 0; b < sb.size; b += BPB) {
    80002654:	00016797          	auipc	a5,0x16
    80002658:	9287a783          	lw	a5,-1752(a5) # 80017f7c <sb+0x4>
    8000265c:	cff5                	beqz	a5,80002758 <balloc+0x11e>
    8000265e:	8baa                	mv	s7,a0
    80002660:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002662:	00016b17          	auipc	s6,0x16
    80002666:	916b0b13          	addi	s6,s6,-1770 # 80017f78 <sb>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    8000266a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000266c:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    8000266e:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    80002670:	6c89                	lui	s9,0x2
    80002672:	a061                	j	800026fa <balloc+0xc0>
        bp->data[bi / 8] |= m;            // Mark block in use.
    80002674:	97ca                	add	a5,a5,s2
    80002676:	8e55                	or	a2,a2,a3
    80002678:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000267c:	854a                	mv	a0,s2
    8000267e:	00001097          	auipc	ra,0x1
    80002682:	0b4080e7          	jalr	180(ra) # 80003732 <log_write>
        brelse(bp);
    80002686:	854a                	mv	a0,s2
    80002688:	00000097          	auipc	ra,0x0
    8000268c:	e20080e7          	jalr	-480(ra) # 800024a8 <brelse>
  bp = bread(dev, bno);
    80002690:	85a6                	mv	a1,s1
    80002692:	855e                	mv	a0,s7
    80002694:	00000097          	auipc	ra,0x0
    80002698:	ce4080e7          	jalr	-796(ra) # 80002378 <bread>
    8000269c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000269e:	40000613          	li	a2,1024
    800026a2:	4581                	li	a1,0
    800026a4:	05850513          	addi	a0,a0,88
    800026a8:	ffffe097          	auipc	ra,0xffffe
    800026ac:	ad2080e7          	jalr	-1326(ra) # 8000017a <memset>
  log_write(bp);
    800026b0:	854a                	mv	a0,s2
    800026b2:	00001097          	auipc	ra,0x1
    800026b6:	080080e7          	jalr	128(ra) # 80003732 <log_write>
  brelse(bp);
    800026ba:	854a                	mv	a0,s2
    800026bc:	00000097          	auipc	ra,0x0
    800026c0:	dec080e7          	jalr	-532(ra) # 800024a8 <brelse>
}
    800026c4:	8526                	mv	a0,s1
    800026c6:	60e6                	ld	ra,88(sp)
    800026c8:	6446                	ld	s0,80(sp)
    800026ca:	64a6                	ld	s1,72(sp)
    800026cc:	6906                	ld	s2,64(sp)
    800026ce:	79e2                	ld	s3,56(sp)
    800026d0:	7a42                	ld	s4,48(sp)
    800026d2:	7aa2                	ld	s5,40(sp)
    800026d4:	7b02                	ld	s6,32(sp)
    800026d6:	6be2                	ld	s7,24(sp)
    800026d8:	6c42                	ld	s8,16(sp)
    800026da:	6ca2                	ld	s9,8(sp)
    800026dc:	6125                	addi	sp,sp,96
    800026de:	8082                	ret
    brelse(bp);
    800026e0:	854a                	mv	a0,s2
    800026e2:	00000097          	auipc	ra,0x0
    800026e6:	dc6080e7          	jalr	-570(ra) # 800024a8 <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    800026ea:	015c87bb          	addw	a5,s9,s5
    800026ee:	00078a9b          	sext.w	s5,a5
    800026f2:	004b2703          	lw	a4,4(s6)
    800026f6:	06eaf163          	bgeu	s5,a4,80002758 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    800026fa:	41fad79b          	sraiw	a5,s5,0x1f
    800026fe:	0137d79b          	srliw	a5,a5,0x13
    80002702:	015787bb          	addw	a5,a5,s5
    80002706:	40d7d79b          	sraiw	a5,a5,0xd
    8000270a:	01cb2583          	lw	a1,28(s6)
    8000270e:	9dbd                	addw	a1,a1,a5
    80002710:	855e                	mv	a0,s7
    80002712:	00000097          	auipc	ra,0x0
    80002716:	c66080e7          	jalr	-922(ra) # 80002378 <bread>
    8000271a:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    8000271c:	004b2503          	lw	a0,4(s6)
    80002720:	000a849b          	sext.w	s1,s5
    80002724:	8762                	mv	a4,s8
    80002726:	faa4fde3          	bgeu	s1,a0,800026e0 <balloc+0xa6>
      m = 1 << (bi % 8);
    8000272a:	00777693          	andi	a3,a4,7
    8000272e:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) {  // Is block free?
    80002732:	41f7579b          	sraiw	a5,a4,0x1f
    80002736:	01d7d79b          	srliw	a5,a5,0x1d
    8000273a:	9fb9                	addw	a5,a5,a4
    8000273c:	4037d79b          	sraiw	a5,a5,0x3
    80002740:	00f90633          	add	a2,s2,a5
    80002744:	05864603          	lbu	a2,88(a2)
    80002748:	00c6f5b3          	and	a1,a3,a2
    8000274c:	d585                	beqz	a1,80002674 <balloc+0x3a>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    8000274e:	2705                	addiw	a4,a4,1
    80002750:	2485                	addiw	s1,s1,1
    80002752:	fd471ae3          	bne	a4,s4,80002726 <balloc+0xec>
    80002756:	b769                	j	800026e0 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80002758:	00007517          	auipc	a0,0x7
    8000275c:	dd850513          	addi	a0,a0,-552 # 80009530 <syscalls+0x120>
    80002760:	00004097          	auipc	ra,0x4
    80002764:	2c8080e7          	jalr	712(ra) # 80006a28 <printf>
  return 0;
    80002768:	4481                	li	s1,0
    8000276a:	bfa9                	j	800026c4 <balloc+0x8a>

000000008000276c <bmap>:
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint bmap(struct inode *ip, uint bn) {
    8000276c:	7179                	addi	sp,sp,-48
    8000276e:	f406                	sd	ra,40(sp)
    80002770:	f022                	sd	s0,32(sp)
    80002772:	ec26                	sd	s1,24(sp)
    80002774:	e84a                	sd	s2,16(sp)
    80002776:	e44e                	sd	s3,8(sp)
    80002778:	e052                	sd	s4,0(sp)
    8000277a:	1800                	addi	s0,sp,48
    8000277c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    8000277e:	47ad                	li	a5,11
    80002780:	02b7e863          	bltu	a5,a1,800027b0 <bmap+0x44>
    if ((addr = ip->addrs[bn]) == 0) {
    80002784:	02059793          	slli	a5,a1,0x20
    80002788:	01e7d593          	srli	a1,a5,0x1e
    8000278c:	00b504b3          	add	s1,a0,a1
    80002790:	0504a903          	lw	s2,80(s1)
    80002794:	06091e63          	bnez	s2,80002810 <bmap+0xa4>
      addr = balloc(ip->dev);
    80002798:	4108                	lw	a0,0(a0)
    8000279a:	00000097          	auipc	ra,0x0
    8000279e:	ea0080e7          	jalr	-352(ra) # 8000263a <balloc>
    800027a2:	0005091b          	sext.w	s2,a0
      if (addr == 0) return 0;
    800027a6:	06090563          	beqz	s2,80002810 <bmap+0xa4>
      ip->addrs[bn] = addr;
    800027aa:	0524a823          	sw	s2,80(s1)
    800027ae:	a08d                	j	80002810 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800027b0:	ff45849b          	addiw	s1,a1,-12
    800027b4:	0004871b          	sext.w	a4,s1

  if (bn < NINDIRECT) {
    800027b8:	0ff00793          	li	a5,255
    800027bc:	08e7e563          	bltu	a5,a4,80002846 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    800027c0:	08052903          	lw	s2,128(a0)
    800027c4:	00091d63          	bnez	s2,800027de <bmap+0x72>
      addr = balloc(ip->dev);
    800027c8:	4108                	lw	a0,0(a0)
    800027ca:	00000097          	auipc	ra,0x0
    800027ce:	e70080e7          	jalr	-400(ra) # 8000263a <balloc>
    800027d2:	0005091b          	sext.w	s2,a0
      if (addr == 0) return 0;
    800027d6:	02090d63          	beqz	s2,80002810 <bmap+0xa4>
      ip->addrs[NDIRECT] = addr;
    800027da:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800027de:	85ca                	mv	a1,s2
    800027e0:	0009a503          	lw	a0,0(s3)
    800027e4:	00000097          	auipc	ra,0x0
    800027e8:	b94080e7          	jalr	-1132(ra) # 80002378 <bread>
    800027ec:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    800027ee:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    800027f2:	02049713          	slli	a4,s1,0x20
    800027f6:	01e75593          	srli	a1,a4,0x1e
    800027fa:	00b784b3          	add	s1,a5,a1
    800027fe:	0004a903          	lw	s2,0(s1)
    80002802:	02090063          	beqz	s2,80002822 <bmap+0xb6>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002806:	8552                	mv	a0,s4
    80002808:	00000097          	auipc	ra,0x0
    8000280c:	ca0080e7          	jalr	-864(ra) # 800024a8 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002810:	854a                	mv	a0,s2
    80002812:	70a2                	ld	ra,40(sp)
    80002814:	7402                	ld	s0,32(sp)
    80002816:	64e2                	ld	s1,24(sp)
    80002818:	6942                	ld	s2,16(sp)
    8000281a:	69a2                	ld	s3,8(sp)
    8000281c:	6a02                	ld	s4,0(sp)
    8000281e:	6145                	addi	sp,sp,48
    80002820:	8082                	ret
      addr = balloc(ip->dev);
    80002822:	0009a503          	lw	a0,0(s3)
    80002826:	00000097          	auipc	ra,0x0
    8000282a:	e14080e7          	jalr	-492(ra) # 8000263a <balloc>
    8000282e:	0005091b          	sext.w	s2,a0
      if (addr) {
    80002832:	fc090ae3          	beqz	s2,80002806 <bmap+0x9a>
        a[bn] = addr;
    80002836:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000283a:	8552                	mv	a0,s4
    8000283c:	00001097          	auipc	ra,0x1
    80002840:	ef6080e7          	jalr	-266(ra) # 80003732 <log_write>
    80002844:	b7c9                	j	80002806 <bmap+0x9a>
  panic("bmap: out of range");
    80002846:	00007517          	auipc	a0,0x7
    8000284a:	d0250513          	addi	a0,a0,-766 # 80009548 <syscalls+0x138>
    8000284e:	00004097          	auipc	ra,0x4
    80002852:	190080e7          	jalr	400(ra) # 800069de <panic>

0000000080002856 <iget>:
static struct inode *iget(uint dev, uint inum) {
    80002856:	7179                	addi	sp,sp,-48
    80002858:	f406                	sd	ra,40(sp)
    8000285a:	f022                	sd	s0,32(sp)
    8000285c:	ec26                	sd	s1,24(sp)
    8000285e:	e84a                	sd	s2,16(sp)
    80002860:	e44e                	sd	s3,8(sp)
    80002862:	e052                	sd	s4,0(sp)
    80002864:	1800                	addi	s0,sp,48
    80002866:	89aa                	mv	s3,a0
    80002868:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000286a:	00015517          	auipc	a0,0x15
    8000286e:	72e50513          	addi	a0,a0,1838 # 80017f98 <itable>
    80002872:	00004097          	auipc	ra,0x4
    80002876:	6a4080e7          	jalr	1700(ra) # 80006f16 <acquire>
  empty = 0;
    8000287a:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    8000287c:	00015497          	auipc	s1,0x15
    80002880:	73448493          	addi	s1,s1,1844 # 80017fb0 <itable+0x18>
    80002884:	00017697          	auipc	a3,0x17
    80002888:	1bc68693          	addi	a3,a3,444 # 80019a40 <log>
    8000288c:	a039                	j	8000289a <iget+0x44>
    if (empty == 0 && ip->ref == 0)  // Remember empty slot.
    8000288e:	02090b63          	beqz	s2,800028c4 <iget+0x6e>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80002892:	08848493          	addi	s1,s1,136
    80002896:	02d48a63          	beq	s1,a3,800028ca <iget+0x74>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    8000289a:	449c                	lw	a5,8(s1)
    8000289c:	fef059e3          	blez	a5,8000288e <iget+0x38>
    800028a0:	4098                	lw	a4,0(s1)
    800028a2:	ff3716e3          	bne	a4,s3,8000288e <iget+0x38>
    800028a6:	40d8                	lw	a4,4(s1)
    800028a8:	ff4713e3          	bne	a4,s4,8000288e <iget+0x38>
      ip->ref++;
    800028ac:	2785                	addiw	a5,a5,1
    800028ae:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028b0:	00015517          	auipc	a0,0x15
    800028b4:	6e850513          	addi	a0,a0,1768 # 80017f98 <itable>
    800028b8:	00004097          	auipc	ra,0x4
    800028bc:	712080e7          	jalr	1810(ra) # 80006fca <release>
      return ip;
    800028c0:	8926                	mv	s2,s1
    800028c2:	a03d                	j	800028f0 <iget+0x9a>
    if (empty == 0 && ip->ref == 0)  // Remember empty slot.
    800028c4:	f7f9                	bnez	a5,80002892 <iget+0x3c>
    800028c6:	8926                	mv	s2,s1
    800028c8:	b7e9                	j	80002892 <iget+0x3c>
  if (empty == 0) panic("iget: no inodes");
    800028ca:	02090c63          	beqz	s2,80002902 <iget+0xac>
  ip->dev = dev;
    800028ce:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800028d2:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800028d6:	4785                	li	a5,1
    800028d8:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800028dc:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800028e0:	00015517          	auipc	a0,0x15
    800028e4:	6b850513          	addi	a0,a0,1720 # 80017f98 <itable>
    800028e8:	00004097          	auipc	ra,0x4
    800028ec:	6e2080e7          	jalr	1762(ra) # 80006fca <release>
}
    800028f0:	854a                	mv	a0,s2
    800028f2:	70a2                	ld	ra,40(sp)
    800028f4:	7402                	ld	s0,32(sp)
    800028f6:	64e2                	ld	s1,24(sp)
    800028f8:	6942                	ld	s2,16(sp)
    800028fa:	69a2                	ld	s3,8(sp)
    800028fc:	6a02                	ld	s4,0(sp)
    800028fe:	6145                	addi	sp,sp,48
    80002900:	8082                	ret
  if (empty == 0) panic("iget: no inodes");
    80002902:	00007517          	auipc	a0,0x7
    80002906:	c5e50513          	addi	a0,a0,-930 # 80009560 <syscalls+0x150>
    8000290a:	00004097          	auipc	ra,0x4
    8000290e:	0d4080e7          	jalr	212(ra) # 800069de <panic>

0000000080002912 <fsinit>:
void fsinit(int dev) {
    80002912:	7179                	addi	sp,sp,-48
    80002914:	f406                	sd	ra,40(sp)
    80002916:	f022                	sd	s0,32(sp)
    80002918:	ec26                	sd	s1,24(sp)
    8000291a:	e84a                	sd	s2,16(sp)
    8000291c:	e44e                	sd	s3,8(sp)
    8000291e:	1800                	addi	s0,sp,48
    80002920:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002922:	4585                	li	a1,1
    80002924:	00000097          	auipc	ra,0x0
    80002928:	a54080e7          	jalr	-1452(ra) # 80002378 <bread>
    8000292c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000292e:	00015997          	auipc	s3,0x15
    80002932:	64a98993          	addi	s3,s3,1610 # 80017f78 <sb>
    80002936:	02000613          	li	a2,32
    8000293a:	05850593          	addi	a1,a0,88
    8000293e:	854e                	mv	a0,s3
    80002940:	ffffe097          	auipc	ra,0xffffe
    80002944:	896080e7          	jalr	-1898(ra) # 800001d6 <memmove>
  brelse(bp);
    80002948:	8526                	mv	a0,s1
    8000294a:	00000097          	auipc	ra,0x0
    8000294e:	b5e080e7          	jalr	-1186(ra) # 800024a8 <brelse>
  if (sb.magic != FSMAGIC) panic("invalid file system");
    80002952:	0009a703          	lw	a4,0(s3)
    80002956:	102037b7          	lui	a5,0x10203
    8000295a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000295e:	02f71263          	bne	a4,a5,80002982 <fsinit+0x70>
  initlog(dev, &sb);
    80002962:	00015597          	auipc	a1,0x15
    80002966:	61658593          	addi	a1,a1,1558 # 80017f78 <sb>
    8000296a:	854a                	mv	a0,s2
    8000296c:	00001097          	auipc	ra,0x1
    80002970:	b4a080e7          	jalr	-1206(ra) # 800034b6 <initlog>
}
    80002974:	70a2                	ld	ra,40(sp)
    80002976:	7402                	ld	s0,32(sp)
    80002978:	64e2                	ld	s1,24(sp)
    8000297a:	6942                	ld	s2,16(sp)
    8000297c:	69a2                	ld	s3,8(sp)
    8000297e:	6145                	addi	sp,sp,48
    80002980:	8082                	ret
  if (sb.magic != FSMAGIC) panic("invalid file system");
    80002982:	00007517          	auipc	a0,0x7
    80002986:	bee50513          	addi	a0,a0,-1042 # 80009570 <syscalls+0x160>
    8000298a:	00004097          	auipc	ra,0x4
    8000298e:	054080e7          	jalr	84(ra) # 800069de <panic>

0000000080002992 <iinit>:
void iinit() {
    80002992:	7179                	addi	sp,sp,-48
    80002994:	f406                	sd	ra,40(sp)
    80002996:	f022                	sd	s0,32(sp)
    80002998:	ec26                	sd	s1,24(sp)
    8000299a:	e84a                	sd	s2,16(sp)
    8000299c:	e44e                	sd	s3,8(sp)
    8000299e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029a0:	00007597          	auipc	a1,0x7
    800029a4:	be858593          	addi	a1,a1,-1048 # 80009588 <syscalls+0x178>
    800029a8:	00015517          	auipc	a0,0x15
    800029ac:	5f050513          	addi	a0,a0,1520 # 80017f98 <itable>
    800029b0:	00004097          	auipc	ra,0x4
    800029b4:	4d6080e7          	jalr	1238(ra) # 80006e86 <initlock>
  for (i = 0; i < NINODE; i++) {
    800029b8:	00015497          	auipc	s1,0x15
    800029bc:	60848493          	addi	s1,s1,1544 # 80017fc0 <itable+0x28>
    800029c0:	00017997          	auipc	s3,0x17
    800029c4:	09098993          	addi	s3,s3,144 # 80019a50 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029c8:	00007917          	auipc	s2,0x7
    800029cc:	bc890913          	addi	s2,s2,-1080 # 80009590 <syscalls+0x180>
    800029d0:	85ca                	mv	a1,s2
    800029d2:	8526                	mv	a0,s1
    800029d4:	00001097          	auipc	ra,0x1
    800029d8:	e42080e7          	jalr	-446(ra) # 80003816 <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    800029dc:	08848493          	addi	s1,s1,136
    800029e0:	ff3498e3          	bne	s1,s3,800029d0 <iinit+0x3e>
}
    800029e4:	70a2                	ld	ra,40(sp)
    800029e6:	7402                	ld	s0,32(sp)
    800029e8:	64e2                	ld	s1,24(sp)
    800029ea:	6942                	ld	s2,16(sp)
    800029ec:	69a2                	ld	s3,8(sp)
    800029ee:	6145                	addi	sp,sp,48
    800029f0:	8082                	ret

00000000800029f2 <ialloc>:
struct inode *ialloc(uint dev, short type) {
    800029f2:	715d                	addi	sp,sp,-80
    800029f4:	e486                	sd	ra,72(sp)
    800029f6:	e0a2                	sd	s0,64(sp)
    800029f8:	fc26                	sd	s1,56(sp)
    800029fa:	f84a                	sd	s2,48(sp)
    800029fc:	f44e                	sd	s3,40(sp)
    800029fe:	f052                	sd	s4,32(sp)
    80002a00:	ec56                	sd	s5,24(sp)
    80002a02:	e85a                	sd	s6,16(sp)
    80002a04:	e45e                	sd	s7,8(sp)
    80002a06:	0880                	addi	s0,sp,80
  for (inum = 1; inum < sb.ninodes; inum++) {
    80002a08:	00015717          	auipc	a4,0x15
    80002a0c:	57c72703          	lw	a4,1404(a4) # 80017f84 <sb+0xc>
    80002a10:	4785                	li	a5,1
    80002a12:	04e7fa63          	bgeu	a5,a4,80002a66 <ialloc+0x74>
    80002a16:	8aaa                	mv	s5,a0
    80002a18:	8bae                	mv	s7,a1
    80002a1a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a1c:	00015a17          	auipc	s4,0x15
    80002a20:	55ca0a13          	addi	s4,s4,1372 # 80017f78 <sb>
    80002a24:	00048b1b          	sext.w	s6,s1
    80002a28:	0044d593          	srli	a1,s1,0x4
    80002a2c:	018a2783          	lw	a5,24(s4)
    80002a30:	9dbd                	addw	a1,a1,a5
    80002a32:	8556                	mv	a0,s5
    80002a34:	00000097          	auipc	ra,0x0
    80002a38:	944080e7          	jalr	-1724(ra) # 80002378 <bread>
    80002a3c:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    80002a3e:	05850993          	addi	s3,a0,88
    80002a42:	00f4f793          	andi	a5,s1,15
    80002a46:	079a                	slli	a5,a5,0x6
    80002a48:	99be                	add	s3,s3,a5
    if (dip->type == 0) {  // a free inode
    80002a4a:	00099783          	lh	a5,0(s3)
    80002a4e:	c3a1                	beqz	a5,80002a8e <ialloc+0x9c>
    brelse(bp);
    80002a50:	00000097          	auipc	ra,0x0
    80002a54:	a58080e7          	jalr	-1448(ra) # 800024a8 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    80002a58:	0485                	addi	s1,s1,1
    80002a5a:	00ca2703          	lw	a4,12(s4)
    80002a5e:	0004879b          	sext.w	a5,s1
    80002a62:	fce7e1e3          	bltu	a5,a4,80002a24 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002a66:	00007517          	auipc	a0,0x7
    80002a6a:	b3250513          	addi	a0,a0,-1230 # 80009598 <syscalls+0x188>
    80002a6e:	00004097          	auipc	ra,0x4
    80002a72:	fba080e7          	jalr	-70(ra) # 80006a28 <printf>
  return 0;
    80002a76:	4501                	li	a0,0
}
    80002a78:	60a6                	ld	ra,72(sp)
    80002a7a:	6406                	ld	s0,64(sp)
    80002a7c:	74e2                	ld	s1,56(sp)
    80002a7e:	7942                	ld	s2,48(sp)
    80002a80:	79a2                	ld	s3,40(sp)
    80002a82:	7a02                	ld	s4,32(sp)
    80002a84:	6ae2                	ld	s5,24(sp)
    80002a86:	6b42                	ld	s6,16(sp)
    80002a88:	6ba2                	ld	s7,8(sp)
    80002a8a:	6161                	addi	sp,sp,80
    80002a8c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002a8e:	04000613          	li	a2,64
    80002a92:	4581                	li	a1,0
    80002a94:	854e                	mv	a0,s3
    80002a96:	ffffd097          	auipc	ra,0xffffd
    80002a9a:	6e4080e7          	jalr	1764(ra) # 8000017a <memset>
      dip->type = type;
    80002a9e:	01799023          	sh	s7,0(s3)
      log_write(bp);  // mark it allocated on the disk
    80002aa2:	854a                	mv	a0,s2
    80002aa4:	00001097          	auipc	ra,0x1
    80002aa8:	c8e080e7          	jalr	-882(ra) # 80003732 <log_write>
      brelse(bp);
    80002aac:	854a                	mv	a0,s2
    80002aae:	00000097          	auipc	ra,0x0
    80002ab2:	9fa080e7          	jalr	-1542(ra) # 800024a8 <brelse>
      return iget(dev, inum);
    80002ab6:	85da                	mv	a1,s6
    80002ab8:	8556                	mv	a0,s5
    80002aba:	00000097          	auipc	ra,0x0
    80002abe:	d9c080e7          	jalr	-612(ra) # 80002856 <iget>
    80002ac2:	bf5d                	j	80002a78 <ialloc+0x86>

0000000080002ac4 <iupdate>:
void iupdate(struct inode *ip) {
    80002ac4:	1101                	addi	sp,sp,-32
    80002ac6:	ec06                	sd	ra,24(sp)
    80002ac8:	e822                	sd	s0,16(sp)
    80002aca:	e426                	sd	s1,8(sp)
    80002acc:	e04a                	sd	s2,0(sp)
    80002ace:	1000                	addi	s0,sp,32
    80002ad0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ad2:	415c                	lw	a5,4(a0)
    80002ad4:	0047d79b          	srliw	a5,a5,0x4
    80002ad8:	00015597          	auipc	a1,0x15
    80002adc:	4b85a583          	lw	a1,1208(a1) # 80017f90 <sb+0x18>
    80002ae0:	9dbd                	addw	a1,a1,a5
    80002ae2:	4108                	lw	a0,0(a0)
    80002ae4:	00000097          	auipc	ra,0x0
    80002ae8:	894080e7          	jalr	-1900(ra) # 80002378 <bread>
    80002aec:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002aee:	05850793          	addi	a5,a0,88
    80002af2:	40d8                	lw	a4,4(s1)
    80002af4:	8b3d                	andi	a4,a4,15
    80002af6:	071a                	slli	a4,a4,0x6
    80002af8:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002afa:	04449703          	lh	a4,68(s1)
    80002afe:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b02:	04649703          	lh	a4,70(s1)
    80002b06:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b0a:	04849703          	lh	a4,72(s1)
    80002b0e:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b12:	04a49703          	lh	a4,74(s1)
    80002b16:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b1a:	44f8                	lw	a4,76(s1)
    80002b1c:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b1e:	03400613          	li	a2,52
    80002b22:	05048593          	addi	a1,s1,80
    80002b26:	00c78513          	addi	a0,a5,12
    80002b2a:	ffffd097          	auipc	ra,0xffffd
    80002b2e:	6ac080e7          	jalr	1708(ra) # 800001d6 <memmove>
  log_write(bp);
    80002b32:	854a                	mv	a0,s2
    80002b34:	00001097          	auipc	ra,0x1
    80002b38:	bfe080e7          	jalr	-1026(ra) # 80003732 <log_write>
  brelse(bp);
    80002b3c:	854a                	mv	a0,s2
    80002b3e:	00000097          	auipc	ra,0x0
    80002b42:	96a080e7          	jalr	-1686(ra) # 800024a8 <brelse>
}
    80002b46:	60e2                	ld	ra,24(sp)
    80002b48:	6442                	ld	s0,16(sp)
    80002b4a:	64a2                	ld	s1,8(sp)
    80002b4c:	6902                	ld	s2,0(sp)
    80002b4e:	6105                	addi	sp,sp,32
    80002b50:	8082                	ret

0000000080002b52 <idup>:
struct inode *idup(struct inode *ip) {
    80002b52:	1101                	addi	sp,sp,-32
    80002b54:	ec06                	sd	ra,24(sp)
    80002b56:	e822                	sd	s0,16(sp)
    80002b58:	e426                	sd	s1,8(sp)
    80002b5a:	1000                	addi	s0,sp,32
    80002b5c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b5e:	00015517          	auipc	a0,0x15
    80002b62:	43a50513          	addi	a0,a0,1082 # 80017f98 <itable>
    80002b66:	00004097          	auipc	ra,0x4
    80002b6a:	3b0080e7          	jalr	944(ra) # 80006f16 <acquire>
  ip->ref++;
    80002b6e:	449c                	lw	a5,8(s1)
    80002b70:	2785                	addiw	a5,a5,1
    80002b72:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b74:	00015517          	auipc	a0,0x15
    80002b78:	42450513          	addi	a0,a0,1060 # 80017f98 <itable>
    80002b7c:	00004097          	auipc	ra,0x4
    80002b80:	44e080e7          	jalr	1102(ra) # 80006fca <release>
}
    80002b84:	8526                	mv	a0,s1
    80002b86:	60e2                	ld	ra,24(sp)
    80002b88:	6442                	ld	s0,16(sp)
    80002b8a:	64a2                	ld	s1,8(sp)
    80002b8c:	6105                	addi	sp,sp,32
    80002b8e:	8082                	ret

0000000080002b90 <ilock>:
void ilock(struct inode *ip) {
    80002b90:	1101                	addi	sp,sp,-32
    80002b92:	ec06                	sd	ra,24(sp)
    80002b94:	e822                	sd	s0,16(sp)
    80002b96:	e426                	sd	s1,8(sp)
    80002b98:	e04a                	sd	s2,0(sp)
    80002b9a:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1) panic("ilock");
    80002b9c:	c115                	beqz	a0,80002bc0 <ilock+0x30>
    80002b9e:	84aa                	mv	s1,a0
    80002ba0:	451c                	lw	a5,8(a0)
    80002ba2:	00f05f63          	blez	a5,80002bc0 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002ba6:	0541                	addi	a0,a0,16
    80002ba8:	00001097          	auipc	ra,0x1
    80002bac:	ca8080e7          	jalr	-856(ra) # 80003850 <acquiresleep>
  if (ip->valid == 0) {
    80002bb0:	40bc                	lw	a5,64(s1)
    80002bb2:	cf99                	beqz	a5,80002bd0 <ilock+0x40>
}
    80002bb4:	60e2                	ld	ra,24(sp)
    80002bb6:	6442                	ld	s0,16(sp)
    80002bb8:	64a2                	ld	s1,8(sp)
    80002bba:	6902                	ld	s2,0(sp)
    80002bbc:	6105                	addi	sp,sp,32
    80002bbe:	8082                	ret
  if (ip == 0 || ip->ref < 1) panic("ilock");
    80002bc0:	00007517          	auipc	a0,0x7
    80002bc4:	9f050513          	addi	a0,a0,-1552 # 800095b0 <syscalls+0x1a0>
    80002bc8:	00004097          	auipc	ra,0x4
    80002bcc:	e16080e7          	jalr	-490(ra) # 800069de <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bd0:	40dc                	lw	a5,4(s1)
    80002bd2:	0047d79b          	srliw	a5,a5,0x4
    80002bd6:	00015597          	auipc	a1,0x15
    80002bda:	3ba5a583          	lw	a1,954(a1) # 80017f90 <sb+0x18>
    80002bde:	9dbd                	addw	a1,a1,a5
    80002be0:	4088                	lw	a0,0(s1)
    80002be2:	fffff097          	auipc	ra,0xfffff
    80002be6:	796080e7          	jalr	1942(ra) # 80002378 <bread>
    80002bea:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002bec:	05850593          	addi	a1,a0,88
    80002bf0:	40dc                	lw	a5,4(s1)
    80002bf2:	8bbd                	andi	a5,a5,15
    80002bf4:	079a                	slli	a5,a5,0x6
    80002bf6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002bf8:	00059783          	lh	a5,0(a1)
    80002bfc:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c00:	00259783          	lh	a5,2(a1)
    80002c04:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c08:	00459783          	lh	a5,4(a1)
    80002c0c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c10:	00659783          	lh	a5,6(a1)
    80002c14:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c18:	459c                	lw	a5,8(a1)
    80002c1a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c1c:	03400613          	li	a2,52
    80002c20:	05b1                	addi	a1,a1,12
    80002c22:	05048513          	addi	a0,s1,80
    80002c26:	ffffd097          	auipc	ra,0xffffd
    80002c2a:	5b0080e7          	jalr	1456(ra) # 800001d6 <memmove>
    brelse(bp);
    80002c2e:	854a                	mv	a0,s2
    80002c30:	00000097          	auipc	ra,0x0
    80002c34:	878080e7          	jalr	-1928(ra) # 800024a8 <brelse>
    ip->valid = 1;
    80002c38:	4785                	li	a5,1
    80002c3a:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0) panic("ilock: no type");
    80002c3c:	04449783          	lh	a5,68(s1)
    80002c40:	fbb5                	bnez	a5,80002bb4 <ilock+0x24>
    80002c42:	00007517          	auipc	a0,0x7
    80002c46:	97650513          	addi	a0,a0,-1674 # 800095b8 <syscalls+0x1a8>
    80002c4a:	00004097          	auipc	ra,0x4
    80002c4e:	d94080e7          	jalr	-620(ra) # 800069de <panic>

0000000080002c52 <iunlock>:
void iunlock(struct inode *ip) {
    80002c52:	1101                	addi	sp,sp,-32
    80002c54:	ec06                	sd	ra,24(sp)
    80002c56:	e822                	sd	s0,16(sp)
    80002c58:	e426                	sd	s1,8(sp)
    80002c5a:	e04a                	sd	s2,0(sp)
    80002c5c:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
    80002c5e:	c905                	beqz	a0,80002c8e <iunlock+0x3c>
    80002c60:	84aa                	mv	s1,a0
    80002c62:	01050913          	addi	s2,a0,16
    80002c66:	854a                	mv	a0,s2
    80002c68:	00001097          	auipc	ra,0x1
    80002c6c:	c82080e7          	jalr	-894(ra) # 800038ea <holdingsleep>
    80002c70:	cd19                	beqz	a0,80002c8e <iunlock+0x3c>
    80002c72:	449c                	lw	a5,8(s1)
    80002c74:	00f05d63          	blez	a5,80002c8e <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c78:	854a                	mv	a0,s2
    80002c7a:	00001097          	auipc	ra,0x1
    80002c7e:	c2c080e7          	jalr	-980(ra) # 800038a6 <releasesleep>
}
    80002c82:	60e2                	ld	ra,24(sp)
    80002c84:	6442                	ld	s0,16(sp)
    80002c86:	64a2                	ld	s1,8(sp)
    80002c88:	6902                	ld	s2,0(sp)
    80002c8a:	6105                	addi	sp,sp,32
    80002c8c:	8082                	ret
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
    80002c8e:	00007517          	auipc	a0,0x7
    80002c92:	93a50513          	addi	a0,a0,-1734 # 800095c8 <syscalls+0x1b8>
    80002c96:	00004097          	auipc	ra,0x4
    80002c9a:	d48080e7          	jalr	-696(ra) # 800069de <panic>

0000000080002c9e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip) {
    80002c9e:	7179                	addi	sp,sp,-48
    80002ca0:	f406                	sd	ra,40(sp)
    80002ca2:	f022                	sd	s0,32(sp)
    80002ca4:	ec26                	sd	s1,24(sp)
    80002ca6:	e84a                	sd	s2,16(sp)
    80002ca8:	e44e                	sd	s3,8(sp)
    80002caa:	e052                	sd	s4,0(sp)
    80002cac:	1800                	addi	s0,sp,48
    80002cae:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    80002cb0:	05050493          	addi	s1,a0,80
    80002cb4:	08050913          	addi	s2,a0,128
    80002cb8:	a021                	j	80002cc0 <itrunc+0x22>
    80002cba:	0491                	addi	s1,s1,4
    80002cbc:	01248d63          	beq	s1,s2,80002cd6 <itrunc+0x38>
    if (ip->addrs[i]) {
    80002cc0:	408c                	lw	a1,0(s1)
    80002cc2:	dde5                	beqz	a1,80002cba <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002cc4:	0009a503          	lw	a0,0(s3)
    80002cc8:	00000097          	auipc	ra,0x0
    80002ccc:	8f6080e7          	jalr	-1802(ra) # 800025be <bfree>
      ip->addrs[i] = 0;
    80002cd0:	0004a023          	sw	zero,0(s1)
    80002cd4:	b7dd                	j	80002cba <itrunc+0x1c>
    }
  }

  if (ip->addrs[NDIRECT]) {
    80002cd6:	0809a583          	lw	a1,128(s3)
    80002cda:	e185                	bnez	a1,80002cfa <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002cdc:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002ce0:	854e                	mv	a0,s3
    80002ce2:	00000097          	auipc	ra,0x0
    80002ce6:	de2080e7          	jalr	-542(ra) # 80002ac4 <iupdate>
}
    80002cea:	70a2                	ld	ra,40(sp)
    80002cec:	7402                	ld	s0,32(sp)
    80002cee:	64e2                	ld	s1,24(sp)
    80002cf0:	6942                	ld	s2,16(sp)
    80002cf2:	69a2                	ld	s3,8(sp)
    80002cf4:	6a02                	ld	s4,0(sp)
    80002cf6:	6145                	addi	sp,sp,48
    80002cf8:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002cfa:	0009a503          	lw	a0,0(s3)
    80002cfe:	fffff097          	auipc	ra,0xfffff
    80002d02:	67a080e7          	jalr	1658(ra) # 80002378 <bread>
    80002d06:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    80002d08:	05850493          	addi	s1,a0,88
    80002d0c:	45850913          	addi	s2,a0,1112
    80002d10:	a021                	j	80002d18 <itrunc+0x7a>
    80002d12:	0491                	addi	s1,s1,4
    80002d14:	01248b63          	beq	s1,s2,80002d2a <itrunc+0x8c>
      if (a[j]) bfree(ip->dev, a[j]);
    80002d18:	408c                	lw	a1,0(s1)
    80002d1a:	dde5                	beqz	a1,80002d12 <itrunc+0x74>
    80002d1c:	0009a503          	lw	a0,0(s3)
    80002d20:	00000097          	auipc	ra,0x0
    80002d24:	89e080e7          	jalr	-1890(ra) # 800025be <bfree>
    80002d28:	b7ed                	j	80002d12 <itrunc+0x74>
    brelse(bp);
    80002d2a:	8552                	mv	a0,s4
    80002d2c:	fffff097          	auipc	ra,0xfffff
    80002d30:	77c080e7          	jalr	1916(ra) # 800024a8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d34:	0809a583          	lw	a1,128(s3)
    80002d38:	0009a503          	lw	a0,0(s3)
    80002d3c:	00000097          	auipc	ra,0x0
    80002d40:	882080e7          	jalr	-1918(ra) # 800025be <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d44:	0809a023          	sw	zero,128(s3)
    80002d48:	bf51                	j	80002cdc <itrunc+0x3e>

0000000080002d4a <iput>:
void iput(struct inode *ip) {
    80002d4a:	1101                	addi	sp,sp,-32
    80002d4c:	ec06                	sd	ra,24(sp)
    80002d4e:	e822                	sd	s0,16(sp)
    80002d50:	e426                	sd	s1,8(sp)
    80002d52:	e04a                	sd	s2,0(sp)
    80002d54:	1000                	addi	s0,sp,32
    80002d56:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d58:	00015517          	auipc	a0,0x15
    80002d5c:	24050513          	addi	a0,a0,576 # 80017f98 <itable>
    80002d60:	00004097          	auipc	ra,0x4
    80002d64:	1b6080e7          	jalr	438(ra) # 80006f16 <acquire>
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80002d68:	4498                	lw	a4,8(s1)
    80002d6a:	4785                	li	a5,1
    80002d6c:	02f70363          	beq	a4,a5,80002d92 <iput+0x48>
  ip->ref--;
    80002d70:	449c                	lw	a5,8(s1)
    80002d72:	37fd                	addiw	a5,a5,-1
    80002d74:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d76:	00015517          	auipc	a0,0x15
    80002d7a:	22250513          	addi	a0,a0,546 # 80017f98 <itable>
    80002d7e:	00004097          	auipc	ra,0x4
    80002d82:	24c080e7          	jalr	588(ra) # 80006fca <release>
}
    80002d86:	60e2                	ld	ra,24(sp)
    80002d88:	6442                	ld	s0,16(sp)
    80002d8a:	64a2                	ld	s1,8(sp)
    80002d8c:	6902                	ld	s2,0(sp)
    80002d8e:	6105                	addi	sp,sp,32
    80002d90:	8082                	ret
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80002d92:	40bc                	lw	a5,64(s1)
    80002d94:	dff1                	beqz	a5,80002d70 <iput+0x26>
    80002d96:	04a49783          	lh	a5,74(s1)
    80002d9a:	fbf9                	bnez	a5,80002d70 <iput+0x26>
    acquiresleep(&ip->lock);
    80002d9c:	01048913          	addi	s2,s1,16
    80002da0:	854a                	mv	a0,s2
    80002da2:	00001097          	auipc	ra,0x1
    80002da6:	aae080e7          	jalr	-1362(ra) # 80003850 <acquiresleep>
    release(&itable.lock);
    80002daa:	00015517          	auipc	a0,0x15
    80002dae:	1ee50513          	addi	a0,a0,494 # 80017f98 <itable>
    80002db2:	00004097          	auipc	ra,0x4
    80002db6:	218080e7          	jalr	536(ra) # 80006fca <release>
    itrunc(ip);
    80002dba:	8526                	mv	a0,s1
    80002dbc:	00000097          	auipc	ra,0x0
    80002dc0:	ee2080e7          	jalr	-286(ra) # 80002c9e <itrunc>
    ip->type = 0;
    80002dc4:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002dc8:	8526                	mv	a0,s1
    80002dca:	00000097          	auipc	ra,0x0
    80002dce:	cfa080e7          	jalr	-774(ra) # 80002ac4 <iupdate>
    ip->valid = 0;
    80002dd2:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002dd6:	854a                	mv	a0,s2
    80002dd8:	00001097          	auipc	ra,0x1
    80002ddc:	ace080e7          	jalr	-1330(ra) # 800038a6 <releasesleep>
    acquire(&itable.lock);
    80002de0:	00015517          	auipc	a0,0x15
    80002de4:	1b850513          	addi	a0,a0,440 # 80017f98 <itable>
    80002de8:	00004097          	auipc	ra,0x4
    80002dec:	12e080e7          	jalr	302(ra) # 80006f16 <acquire>
    80002df0:	b741                	j	80002d70 <iput+0x26>

0000000080002df2 <iunlockput>:
void iunlockput(struct inode *ip) {
    80002df2:	1101                	addi	sp,sp,-32
    80002df4:	ec06                	sd	ra,24(sp)
    80002df6:	e822                	sd	s0,16(sp)
    80002df8:	e426                	sd	s1,8(sp)
    80002dfa:	1000                	addi	s0,sp,32
    80002dfc:	84aa                	mv	s1,a0
  iunlock(ip);
    80002dfe:	00000097          	auipc	ra,0x0
    80002e02:	e54080e7          	jalr	-428(ra) # 80002c52 <iunlock>
  iput(ip);
    80002e06:	8526                	mv	a0,s1
    80002e08:	00000097          	auipc	ra,0x0
    80002e0c:	f42080e7          	jalr	-190(ra) # 80002d4a <iput>
}
    80002e10:	60e2                	ld	ra,24(sp)
    80002e12:	6442                	ld	s0,16(sp)
    80002e14:	64a2                	ld	s1,8(sp)
    80002e16:	6105                	addi	sp,sp,32
    80002e18:	8082                	ret

0000000080002e1a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st) {
    80002e1a:	1141                	addi	sp,sp,-16
    80002e1c:	e422                	sd	s0,8(sp)
    80002e1e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e20:	411c                	lw	a5,0(a0)
    80002e22:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e24:	415c                	lw	a5,4(a0)
    80002e26:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e28:	04451783          	lh	a5,68(a0)
    80002e2c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e30:	04a51783          	lh	a5,74(a0)
    80002e34:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e38:	04c56783          	lwu	a5,76(a0)
    80002e3c:	e99c                	sd	a5,16(a1)
}
    80002e3e:	6422                	ld	s0,8(sp)
    80002e40:	0141                	addi	sp,sp,16
    80002e42:	8082                	ret

0000000080002e44 <readi>:
// otherwise, dst is a kernel address.
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off) return 0;
    80002e44:	457c                	lw	a5,76(a0)
    80002e46:	0ed7e963          	bltu	a5,a3,80002f38 <readi+0xf4>
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
    80002e4a:	7159                	addi	sp,sp,-112
    80002e4c:	f486                	sd	ra,104(sp)
    80002e4e:	f0a2                	sd	s0,96(sp)
    80002e50:	eca6                	sd	s1,88(sp)
    80002e52:	e8ca                	sd	s2,80(sp)
    80002e54:	e4ce                	sd	s3,72(sp)
    80002e56:	e0d2                	sd	s4,64(sp)
    80002e58:	fc56                	sd	s5,56(sp)
    80002e5a:	f85a                	sd	s6,48(sp)
    80002e5c:	f45e                	sd	s7,40(sp)
    80002e5e:	f062                	sd	s8,32(sp)
    80002e60:	ec66                	sd	s9,24(sp)
    80002e62:	e86a                	sd	s10,16(sp)
    80002e64:	e46e                	sd	s11,8(sp)
    80002e66:	1880                	addi	s0,sp,112
    80002e68:	8b2a                	mv	s6,a0
    80002e6a:	8bae                	mv	s7,a1
    80002e6c:	8a32                	mv	s4,a2
    80002e6e:	84b6                	mv	s1,a3
    80002e70:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off) return 0;
    80002e72:	9f35                	addw	a4,a4,a3
    80002e74:	4501                	li	a0,0
    80002e76:	0ad76063          	bltu	a4,a3,80002f16 <readi+0xd2>
  if (off + n > ip->size) n = ip->size - off;
    80002e7a:	00e7f463          	bgeu	a5,a4,80002e82 <readi+0x3e>
    80002e7e:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80002e82:	0a0a8963          	beqz	s5,80002f34 <readi+0xf0>
    80002e86:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0) break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80002e88:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e8c:	5c7d                	li	s8,-1
    80002e8e:	a82d                	j	80002ec8 <readi+0x84>
    80002e90:	020d1d93          	slli	s11,s10,0x20
    80002e94:	020ddd93          	srli	s11,s11,0x20
    80002e98:	05890613          	addi	a2,s2,88
    80002e9c:	86ee                	mv	a3,s11
    80002e9e:	963a                	add	a2,a2,a4
    80002ea0:	85d2                	mv	a1,s4
    80002ea2:	855e                	mv	a0,s7
    80002ea4:	fffff097          	auipc	ra,0xfffff
    80002ea8:	afc080e7          	jalr	-1284(ra) # 800019a0 <either_copyout>
    80002eac:	05850d63          	beq	a0,s8,80002f06 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002eb0:	854a                	mv	a0,s2
    80002eb2:	fffff097          	auipc	ra,0xfffff
    80002eb6:	5f6080e7          	jalr	1526(ra) # 800024a8 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80002eba:	013d09bb          	addw	s3,s10,s3
    80002ebe:	009d04bb          	addw	s1,s10,s1
    80002ec2:	9a6e                	add	s4,s4,s11
    80002ec4:	0559f763          	bgeu	s3,s5,80002f12 <readi+0xce>
    uint addr = bmap(ip, off / BSIZE);
    80002ec8:	00a4d59b          	srliw	a1,s1,0xa
    80002ecc:	855a                	mv	a0,s6
    80002ece:	00000097          	auipc	ra,0x0
    80002ed2:	89e080e7          	jalr	-1890(ra) # 8000276c <bmap>
    80002ed6:	0005059b          	sext.w	a1,a0
    if (addr == 0) break;
    80002eda:	cd85                	beqz	a1,80002f12 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002edc:	000b2503          	lw	a0,0(s6)
    80002ee0:	fffff097          	auipc	ra,0xfffff
    80002ee4:	498080e7          	jalr	1176(ra) # 80002378 <bread>
    80002ee8:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80002eea:	3ff4f713          	andi	a4,s1,1023
    80002eee:	40ec87bb          	subw	a5,s9,a4
    80002ef2:	413a86bb          	subw	a3,s5,s3
    80002ef6:	8d3e                	mv	s10,a5
    80002ef8:	2781                	sext.w	a5,a5
    80002efa:	0006861b          	sext.w	a2,a3
    80002efe:	f8f679e3          	bgeu	a2,a5,80002e90 <readi+0x4c>
    80002f02:	8d36                	mv	s10,a3
    80002f04:	b771                	j	80002e90 <readi+0x4c>
      brelse(bp);
    80002f06:	854a                	mv	a0,s2
    80002f08:	fffff097          	auipc	ra,0xfffff
    80002f0c:	5a0080e7          	jalr	1440(ra) # 800024a8 <brelse>
      tot = -1;
    80002f10:	59fd                	li	s3,-1
  }
  return tot;
    80002f12:	0009851b          	sext.w	a0,s3
}
    80002f16:	70a6                	ld	ra,104(sp)
    80002f18:	7406                	ld	s0,96(sp)
    80002f1a:	64e6                	ld	s1,88(sp)
    80002f1c:	6946                	ld	s2,80(sp)
    80002f1e:	69a6                	ld	s3,72(sp)
    80002f20:	6a06                	ld	s4,64(sp)
    80002f22:	7ae2                	ld	s5,56(sp)
    80002f24:	7b42                	ld	s6,48(sp)
    80002f26:	7ba2                	ld	s7,40(sp)
    80002f28:	7c02                	ld	s8,32(sp)
    80002f2a:	6ce2                	ld	s9,24(sp)
    80002f2c:	6d42                	ld	s10,16(sp)
    80002f2e:	6da2                	ld	s11,8(sp)
    80002f30:	6165                	addi	sp,sp,112
    80002f32:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80002f34:	89d6                	mv	s3,s5
    80002f36:	bff1                	j	80002f12 <readi+0xce>
  if (off > ip->size || off + n < off) return 0;
    80002f38:	4501                	li	a0,0
}
    80002f3a:	8082                	ret

0000000080002f3c <writei>:
// there was an error of some kind.
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off) return -1;
    80002f3c:	457c                	lw	a5,76(a0)
    80002f3e:	10d7e863          	bltu	a5,a3,8000304e <writei+0x112>
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
    80002f42:	7159                	addi	sp,sp,-112
    80002f44:	f486                	sd	ra,104(sp)
    80002f46:	f0a2                	sd	s0,96(sp)
    80002f48:	eca6                	sd	s1,88(sp)
    80002f4a:	e8ca                	sd	s2,80(sp)
    80002f4c:	e4ce                	sd	s3,72(sp)
    80002f4e:	e0d2                	sd	s4,64(sp)
    80002f50:	fc56                	sd	s5,56(sp)
    80002f52:	f85a                	sd	s6,48(sp)
    80002f54:	f45e                	sd	s7,40(sp)
    80002f56:	f062                	sd	s8,32(sp)
    80002f58:	ec66                	sd	s9,24(sp)
    80002f5a:	e86a                	sd	s10,16(sp)
    80002f5c:	e46e                	sd	s11,8(sp)
    80002f5e:	1880                	addi	s0,sp,112
    80002f60:	8aaa                	mv	s5,a0
    80002f62:	8bae                	mv	s7,a1
    80002f64:	8a32                	mv	s4,a2
    80002f66:	8936                	mv	s2,a3
    80002f68:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off) return -1;
    80002f6a:	00e687bb          	addw	a5,a3,a4
    80002f6e:	0ed7e263          	bltu	a5,a3,80003052 <writei+0x116>
  if (off + n > MAXFILE * BSIZE) return -1;
    80002f72:	00043737          	lui	a4,0x43
    80002f76:	0ef76063          	bltu	a4,a5,80003056 <writei+0x11a>

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80002f7a:	0c0b0863          	beqz	s6,8000304a <writei+0x10e>
    80002f7e:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0) break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80002f80:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f84:	5c7d                	li	s8,-1
    80002f86:	a091                	j	80002fca <writei+0x8e>
    80002f88:	020d1d93          	slli	s11,s10,0x20
    80002f8c:	020ddd93          	srli	s11,s11,0x20
    80002f90:	05848513          	addi	a0,s1,88
    80002f94:	86ee                	mv	a3,s11
    80002f96:	8652                	mv	a2,s4
    80002f98:	85de                	mv	a1,s7
    80002f9a:	953a                	add	a0,a0,a4
    80002f9c:	fffff097          	auipc	ra,0xfffff
    80002fa0:	a5a080e7          	jalr	-1446(ra) # 800019f6 <either_copyin>
    80002fa4:	07850263          	beq	a0,s8,80003008 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fa8:	8526                	mv	a0,s1
    80002faa:	00000097          	auipc	ra,0x0
    80002fae:	788080e7          	jalr	1928(ra) # 80003732 <log_write>
    brelse(bp);
    80002fb2:	8526                	mv	a0,s1
    80002fb4:	fffff097          	auipc	ra,0xfffff
    80002fb8:	4f4080e7          	jalr	1268(ra) # 800024a8 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80002fbc:	013d09bb          	addw	s3,s10,s3
    80002fc0:	012d093b          	addw	s2,s10,s2
    80002fc4:	9a6e                	add	s4,s4,s11
    80002fc6:	0569f663          	bgeu	s3,s6,80003012 <writei+0xd6>
    uint addr = bmap(ip, off / BSIZE);
    80002fca:	00a9559b          	srliw	a1,s2,0xa
    80002fce:	8556                	mv	a0,s5
    80002fd0:	fffff097          	auipc	ra,0xfffff
    80002fd4:	79c080e7          	jalr	1948(ra) # 8000276c <bmap>
    80002fd8:	0005059b          	sext.w	a1,a0
    if (addr == 0) break;
    80002fdc:	c99d                	beqz	a1,80003012 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002fde:	000aa503          	lw	a0,0(s5)
    80002fe2:	fffff097          	auipc	ra,0xfffff
    80002fe6:	396080e7          	jalr	918(ra) # 80002378 <bread>
    80002fea:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80002fec:	3ff97713          	andi	a4,s2,1023
    80002ff0:	40ec87bb          	subw	a5,s9,a4
    80002ff4:	413b06bb          	subw	a3,s6,s3
    80002ff8:	8d3e                	mv	s10,a5
    80002ffa:	2781                	sext.w	a5,a5
    80002ffc:	0006861b          	sext.w	a2,a3
    80003000:	f8f674e3          	bgeu	a2,a5,80002f88 <writei+0x4c>
    80003004:	8d36                	mv	s10,a3
    80003006:	b749                	j	80002f88 <writei+0x4c>
      brelse(bp);
    80003008:	8526                	mv	a0,s1
    8000300a:	fffff097          	auipc	ra,0xfffff
    8000300e:	49e080e7          	jalr	1182(ra) # 800024a8 <brelse>
  }

  if (off > ip->size) ip->size = off;
    80003012:	04caa783          	lw	a5,76(s5)
    80003016:	0127f463          	bgeu	a5,s2,8000301e <writei+0xe2>
    8000301a:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000301e:	8556                	mv	a0,s5
    80003020:	00000097          	auipc	ra,0x0
    80003024:	aa4080e7          	jalr	-1372(ra) # 80002ac4 <iupdate>

  return tot;
    80003028:	0009851b          	sext.w	a0,s3
}
    8000302c:	70a6                	ld	ra,104(sp)
    8000302e:	7406                	ld	s0,96(sp)
    80003030:	64e6                	ld	s1,88(sp)
    80003032:	6946                	ld	s2,80(sp)
    80003034:	69a6                	ld	s3,72(sp)
    80003036:	6a06                	ld	s4,64(sp)
    80003038:	7ae2                	ld	s5,56(sp)
    8000303a:	7b42                	ld	s6,48(sp)
    8000303c:	7ba2                	ld	s7,40(sp)
    8000303e:	7c02                	ld	s8,32(sp)
    80003040:	6ce2                	ld	s9,24(sp)
    80003042:	6d42                	ld	s10,16(sp)
    80003044:	6da2                	ld	s11,8(sp)
    80003046:	6165                	addi	sp,sp,112
    80003048:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    8000304a:	89da                	mv	s3,s6
    8000304c:	bfc9                	j	8000301e <writei+0xe2>
  if (off > ip->size || off + n < off) return -1;
    8000304e:	557d                	li	a0,-1
}
    80003050:	8082                	ret
  if (off > ip->size || off + n < off) return -1;
    80003052:	557d                	li	a0,-1
    80003054:	bfe1                	j	8000302c <writei+0xf0>
  if (off + n > MAXFILE * BSIZE) return -1;
    80003056:	557d                	li	a0,-1
    80003058:	bfd1                	j	8000302c <writei+0xf0>

000000008000305a <namecmp>:

// Directories

int namecmp(const char *s, const char *t) { return strncmp(s, t, DIRSIZ); }
    8000305a:	1141                	addi	sp,sp,-16
    8000305c:	e406                	sd	ra,8(sp)
    8000305e:	e022                	sd	s0,0(sp)
    80003060:	0800                	addi	s0,sp,16
    80003062:	4639                	li	a2,14
    80003064:	ffffd097          	auipc	ra,0xffffd
    80003068:	1e6080e7          	jalr	486(ra) # 8000024a <strncmp>
    8000306c:	60a2                	ld	ra,8(sp)
    8000306e:	6402                	ld	s0,0(sp)
    80003070:	0141                	addi	sp,sp,16
    80003072:	8082                	ret

0000000080003074 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *dirlookup(struct inode *dp, char *name, uint *poff) {
    80003074:	7139                	addi	sp,sp,-64
    80003076:	fc06                	sd	ra,56(sp)
    80003078:	f822                	sd	s0,48(sp)
    8000307a:	f426                	sd	s1,40(sp)
    8000307c:	f04a                	sd	s2,32(sp)
    8000307e:	ec4e                	sd	s3,24(sp)
    80003080:	e852                	sd	s4,16(sp)
    80003082:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR) panic("dirlookup not DIR");
    80003084:	04451703          	lh	a4,68(a0)
    80003088:	4785                	li	a5,1
    8000308a:	00f71a63          	bne	a4,a5,8000309e <dirlookup+0x2a>
    8000308e:	892a                	mv	s2,a0
    80003090:	89ae                	mv	s3,a1
    80003092:	8a32                	mv	s4,a2

  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003094:	457c                	lw	a5,76(a0)
    80003096:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003098:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000309a:	e79d                	bnez	a5,800030c8 <dirlookup+0x54>
    8000309c:	a8a5                	j	80003114 <dirlookup+0xa0>
  if (dp->type != T_DIR) panic("dirlookup not DIR");
    8000309e:	00006517          	auipc	a0,0x6
    800030a2:	53250513          	addi	a0,a0,1330 # 800095d0 <syscalls+0x1c0>
    800030a6:	00004097          	auipc	ra,0x4
    800030aa:	938080e7          	jalr	-1736(ra) # 800069de <panic>
      panic("dirlookup read");
    800030ae:	00006517          	auipc	a0,0x6
    800030b2:	53a50513          	addi	a0,a0,1338 # 800095e8 <syscalls+0x1d8>
    800030b6:	00004097          	auipc	ra,0x4
    800030ba:	928080e7          	jalr	-1752(ra) # 800069de <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    800030be:	24c1                	addiw	s1,s1,16
    800030c0:	04c92783          	lw	a5,76(s2)
    800030c4:	04f4f763          	bgeu	s1,a5,80003112 <dirlookup+0x9e>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030c8:	4741                	li	a4,16
    800030ca:	86a6                	mv	a3,s1
    800030cc:	fc040613          	addi	a2,s0,-64
    800030d0:	4581                	li	a1,0
    800030d2:	854a                	mv	a0,s2
    800030d4:	00000097          	auipc	ra,0x0
    800030d8:	d70080e7          	jalr	-656(ra) # 80002e44 <readi>
    800030dc:	47c1                	li	a5,16
    800030de:	fcf518e3          	bne	a0,a5,800030ae <dirlookup+0x3a>
    if (de.inum == 0) continue;
    800030e2:	fc045783          	lhu	a5,-64(s0)
    800030e6:	dfe1                	beqz	a5,800030be <dirlookup+0x4a>
    if (namecmp(name, de.name) == 0) {
    800030e8:	fc240593          	addi	a1,s0,-62
    800030ec:	854e                	mv	a0,s3
    800030ee:	00000097          	auipc	ra,0x0
    800030f2:	f6c080e7          	jalr	-148(ra) # 8000305a <namecmp>
    800030f6:	f561                	bnez	a0,800030be <dirlookup+0x4a>
      if (poff) *poff = off;
    800030f8:	000a0463          	beqz	s4,80003100 <dirlookup+0x8c>
    800030fc:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003100:	fc045583          	lhu	a1,-64(s0)
    80003104:	00092503          	lw	a0,0(s2)
    80003108:	fffff097          	auipc	ra,0xfffff
    8000310c:	74e080e7          	jalr	1870(ra) # 80002856 <iget>
    80003110:	a011                	j	80003114 <dirlookup+0xa0>
  return 0;
    80003112:	4501                	li	a0,0
}
    80003114:	70e2                	ld	ra,56(sp)
    80003116:	7442                	ld	s0,48(sp)
    80003118:	74a2                	ld	s1,40(sp)
    8000311a:	7902                	ld	s2,32(sp)
    8000311c:	69e2                	ld	s3,24(sp)
    8000311e:	6a42                	ld	s4,16(sp)
    80003120:	6121                	addi	sp,sp,64
    80003122:	8082                	ret

0000000080003124 <namex>:

// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *namex(char *path, int nameiparent, char *name) {
    80003124:	711d                	addi	sp,sp,-96
    80003126:	ec86                	sd	ra,88(sp)
    80003128:	e8a2                	sd	s0,80(sp)
    8000312a:	e4a6                	sd	s1,72(sp)
    8000312c:	e0ca                	sd	s2,64(sp)
    8000312e:	fc4e                	sd	s3,56(sp)
    80003130:	f852                	sd	s4,48(sp)
    80003132:	f456                	sd	s5,40(sp)
    80003134:	f05a                	sd	s6,32(sp)
    80003136:	ec5e                	sd	s7,24(sp)
    80003138:	e862                	sd	s8,16(sp)
    8000313a:	e466                	sd	s9,8(sp)
    8000313c:	e06a                	sd	s10,0(sp)
    8000313e:	1080                	addi	s0,sp,96
    80003140:	84aa                	mv	s1,a0
    80003142:	8b2e                	mv	s6,a1
    80003144:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    80003146:	00054703          	lbu	a4,0(a0)
    8000314a:	02f00793          	li	a5,47
    8000314e:	02f70363          	beq	a4,a5,80003174 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003152:	ffffe097          	auipc	ra,0xffffe
    80003156:	d9a080e7          	jalr	-614(ra) # 80000eec <myproc>
    8000315a:	15053503          	ld	a0,336(a0)
    8000315e:	00000097          	auipc	ra,0x0
    80003162:	9f4080e7          	jalr	-1548(ra) # 80002b52 <idup>
    80003166:	8a2a                	mv	s4,a0
  while (*path == '/') path++;
    80003168:	02f00913          	li	s2,47
  if (len >= DIRSIZ)
    8000316c:	4cb5                	li	s9,13
  len = path - s;
    8000316e:	4b81                	li	s7,0

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    80003170:	4c05                	li	s8,1
    80003172:	a87d                	j	80003230 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003174:	4585                	li	a1,1
    80003176:	4505                	li	a0,1
    80003178:	fffff097          	auipc	ra,0xfffff
    8000317c:	6de080e7          	jalr	1758(ra) # 80002856 <iget>
    80003180:	8a2a                	mv	s4,a0
    80003182:	b7dd                	j	80003168 <namex+0x44>
      iunlockput(ip);
    80003184:	8552                	mv	a0,s4
    80003186:	00000097          	auipc	ra,0x0
    8000318a:	c6c080e7          	jalr	-916(ra) # 80002df2 <iunlockput>
      return 0;
    8000318e:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    80003190:	8552                	mv	a0,s4
    80003192:	60e6                	ld	ra,88(sp)
    80003194:	6446                	ld	s0,80(sp)
    80003196:	64a6                	ld	s1,72(sp)
    80003198:	6906                	ld	s2,64(sp)
    8000319a:	79e2                	ld	s3,56(sp)
    8000319c:	7a42                	ld	s4,48(sp)
    8000319e:	7aa2                	ld	s5,40(sp)
    800031a0:	7b02                	ld	s6,32(sp)
    800031a2:	6be2                	ld	s7,24(sp)
    800031a4:	6c42                	ld	s8,16(sp)
    800031a6:	6ca2                	ld	s9,8(sp)
    800031a8:	6d02                	ld	s10,0(sp)
    800031aa:	6125                	addi	sp,sp,96
    800031ac:	8082                	ret
      iunlock(ip);
    800031ae:	8552                	mv	a0,s4
    800031b0:	00000097          	auipc	ra,0x0
    800031b4:	aa2080e7          	jalr	-1374(ra) # 80002c52 <iunlock>
      return ip;
    800031b8:	bfe1                	j	80003190 <namex+0x6c>
      iunlockput(ip);
    800031ba:	8552                	mv	a0,s4
    800031bc:	00000097          	auipc	ra,0x0
    800031c0:	c36080e7          	jalr	-970(ra) # 80002df2 <iunlockput>
      return 0;
    800031c4:	8a4e                	mv	s4,s3
    800031c6:	b7e9                	j	80003190 <namex+0x6c>
  len = path - s;
    800031c8:	40998633          	sub	a2,s3,s1
    800031cc:	00060d1b          	sext.w	s10,a2
  if (len >= DIRSIZ)
    800031d0:	09acd863          	bge	s9,s10,80003260 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800031d4:	4639                	li	a2,14
    800031d6:	85a6                	mv	a1,s1
    800031d8:	8556                	mv	a0,s5
    800031da:	ffffd097          	auipc	ra,0xffffd
    800031de:	ffc080e7          	jalr	-4(ra) # 800001d6 <memmove>
    800031e2:	84ce                	mv	s1,s3
  while (*path == '/') path++;
    800031e4:	0004c783          	lbu	a5,0(s1)
    800031e8:	01279763          	bne	a5,s2,800031f6 <namex+0xd2>
    800031ec:	0485                	addi	s1,s1,1
    800031ee:	0004c783          	lbu	a5,0(s1)
    800031f2:	ff278de3          	beq	a5,s2,800031ec <namex+0xc8>
    ilock(ip);
    800031f6:	8552                	mv	a0,s4
    800031f8:	00000097          	auipc	ra,0x0
    800031fc:	998080e7          	jalr	-1640(ra) # 80002b90 <ilock>
    if (ip->type != T_DIR) {
    80003200:	044a1783          	lh	a5,68(s4)
    80003204:	f98790e3          	bne	a5,s8,80003184 <namex+0x60>
    if (nameiparent && *path == '\0') {
    80003208:	000b0563          	beqz	s6,80003212 <namex+0xee>
    8000320c:	0004c783          	lbu	a5,0(s1)
    80003210:	dfd9                	beqz	a5,800031ae <namex+0x8a>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    80003212:	865e                	mv	a2,s7
    80003214:	85d6                	mv	a1,s5
    80003216:	8552                	mv	a0,s4
    80003218:	00000097          	auipc	ra,0x0
    8000321c:	e5c080e7          	jalr	-420(ra) # 80003074 <dirlookup>
    80003220:	89aa                	mv	s3,a0
    80003222:	dd41                	beqz	a0,800031ba <namex+0x96>
    iunlockput(ip);
    80003224:	8552                	mv	a0,s4
    80003226:	00000097          	auipc	ra,0x0
    8000322a:	bcc080e7          	jalr	-1076(ra) # 80002df2 <iunlockput>
    ip = next;
    8000322e:	8a4e                	mv	s4,s3
  while (*path == '/') path++;
    80003230:	0004c783          	lbu	a5,0(s1)
    80003234:	01279763          	bne	a5,s2,80003242 <namex+0x11e>
    80003238:	0485                	addi	s1,s1,1
    8000323a:	0004c783          	lbu	a5,0(s1)
    8000323e:	ff278de3          	beq	a5,s2,80003238 <namex+0x114>
  if (*path == 0) return 0;
    80003242:	cb9d                	beqz	a5,80003278 <namex+0x154>
  while (*path != '/' && *path != 0) path++;
    80003244:	0004c783          	lbu	a5,0(s1)
    80003248:	89a6                	mv	s3,s1
  len = path - s;
    8000324a:	8d5e                	mv	s10,s7
    8000324c:	865e                	mv	a2,s7
  while (*path != '/' && *path != 0) path++;
    8000324e:	01278963          	beq	a5,s2,80003260 <namex+0x13c>
    80003252:	dbbd                	beqz	a5,800031c8 <namex+0xa4>
    80003254:	0985                	addi	s3,s3,1
    80003256:	0009c783          	lbu	a5,0(s3)
    8000325a:	ff279ce3          	bne	a5,s2,80003252 <namex+0x12e>
    8000325e:	b7ad                	j	800031c8 <namex+0xa4>
    memmove(name, s, len);
    80003260:	2601                	sext.w	a2,a2
    80003262:	85a6                	mv	a1,s1
    80003264:	8556                	mv	a0,s5
    80003266:	ffffd097          	auipc	ra,0xffffd
    8000326a:	f70080e7          	jalr	-144(ra) # 800001d6 <memmove>
    name[len] = 0;
    8000326e:	9d56                	add	s10,s10,s5
    80003270:	000d0023          	sb	zero,0(s10) # 1000 <_entry-0x7ffff000>
    80003274:	84ce                	mv	s1,s3
    80003276:	b7bd                	j	800031e4 <namex+0xc0>
  if (nameiparent) {
    80003278:	f00b0ce3          	beqz	s6,80003190 <namex+0x6c>
    iput(ip);
    8000327c:	8552                	mv	a0,s4
    8000327e:	00000097          	auipc	ra,0x0
    80003282:	acc080e7          	jalr	-1332(ra) # 80002d4a <iput>
    return 0;
    80003286:	4a01                	li	s4,0
    80003288:	b721                	j	80003190 <namex+0x6c>

000000008000328a <dirlink>:
int dirlink(struct inode *dp, char *name, uint inum) {
    8000328a:	7139                	addi	sp,sp,-64
    8000328c:	fc06                	sd	ra,56(sp)
    8000328e:	f822                	sd	s0,48(sp)
    80003290:	f426                	sd	s1,40(sp)
    80003292:	f04a                	sd	s2,32(sp)
    80003294:	ec4e                	sd	s3,24(sp)
    80003296:	e852                	sd	s4,16(sp)
    80003298:	0080                	addi	s0,sp,64
    8000329a:	892a                	mv	s2,a0
    8000329c:	8a2e                	mv	s4,a1
    8000329e:	89b2                	mv	s3,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    800032a0:	4601                	li	a2,0
    800032a2:	00000097          	auipc	ra,0x0
    800032a6:	dd2080e7          	jalr	-558(ra) # 80003074 <dirlookup>
    800032aa:	e93d                	bnez	a0,80003320 <dirlink+0x96>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    800032ac:	04c92483          	lw	s1,76(s2)
    800032b0:	c49d                	beqz	s1,800032de <dirlink+0x54>
    800032b2:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032b4:	4741                	li	a4,16
    800032b6:	86a6                	mv	a3,s1
    800032b8:	fc040613          	addi	a2,s0,-64
    800032bc:	4581                	li	a1,0
    800032be:	854a                	mv	a0,s2
    800032c0:	00000097          	auipc	ra,0x0
    800032c4:	b84080e7          	jalr	-1148(ra) # 80002e44 <readi>
    800032c8:	47c1                	li	a5,16
    800032ca:	06f51163          	bne	a0,a5,8000332c <dirlink+0xa2>
    if (de.inum == 0) break;
    800032ce:	fc045783          	lhu	a5,-64(s0)
    800032d2:	c791                	beqz	a5,800032de <dirlink+0x54>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    800032d4:	24c1                	addiw	s1,s1,16
    800032d6:	04c92783          	lw	a5,76(s2)
    800032da:	fcf4ede3          	bltu	s1,a5,800032b4 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800032de:	4639                	li	a2,14
    800032e0:	85d2                	mv	a1,s4
    800032e2:	fc240513          	addi	a0,s0,-62
    800032e6:	ffffd097          	auipc	ra,0xffffd
    800032ea:	fa0080e7          	jalr	-96(ra) # 80000286 <strncpy>
  de.inum = inum;
    800032ee:	fd341023          	sh	s3,-64(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de)) return -1;
    800032f2:	4741                	li	a4,16
    800032f4:	86a6                	mv	a3,s1
    800032f6:	fc040613          	addi	a2,s0,-64
    800032fa:	4581                	li	a1,0
    800032fc:	854a                	mv	a0,s2
    800032fe:	00000097          	auipc	ra,0x0
    80003302:	c3e080e7          	jalr	-962(ra) # 80002f3c <writei>
    80003306:	1541                	addi	a0,a0,-16
    80003308:	00a03533          	snez	a0,a0
    8000330c:	40a00533          	neg	a0,a0
}
    80003310:	70e2                	ld	ra,56(sp)
    80003312:	7442                	ld	s0,48(sp)
    80003314:	74a2                	ld	s1,40(sp)
    80003316:	7902                	ld	s2,32(sp)
    80003318:	69e2                	ld	s3,24(sp)
    8000331a:	6a42                	ld	s4,16(sp)
    8000331c:	6121                	addi	sp,sp,64
    8000331e:	8082                	ret
    iput(ip);
    80003320:	00000097          	auipc	ra,0x0
    80003324:	a2a080e7          	jalr	-1494(ra) # 80002d4a <iput>
    return -1;
    80003328:	557d                	li	a0,-1
    8000332a:	b7dd                	j	80003310 <dirlink+0x86>
      panic("dirlink read");
    8000332c:	00006517          	auipc	a0,0x6
    80003330:	2cc50513          	addi	a0,a0,716 # 800095f8 <syscalls+0x1e8>
    80003334:	00003097          	auipc	ra,0x3
    80003338:	6aa080e7          	jalr	1706(ra) # 800069de <panic>

000000008000333c <namei>:

struct inode *namei(char *path) {
    8000333c:	1101                	addi	sp,sp,-32
    8000333e:	ec06                	sd	ra,24(sp)
    80003340:	e822                	sd	s0,16(sp)
    80003342:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003344:	fe040613          	addi	a2,s0,-32
    80003348:	4581                	li	a1,0
    8000334a:	00000097          	auipc	ra,0x0
    8000334e:	dda080e7          	jalr	-550(ra) # 80003124 <namex>
}
    80003352:	60e2                	ld	ra,24(sp)
    80003354:	6442                	ld	s0,16(sp)
    80003356:	6105                	addi	sp,sp,32
    80003358:	8082                	ret

000000008000335a <nameiparent>:

struct inode *nameiparent(char *path, char *name) {
    8000335a:	1141                	addi	sp,sp,-16
    8000335c:	e406                	sd	ra,8(sp)
    8000335e:	e022                	sd	s0,0(sp)
    80003360:	0800                	addi	s0,sp,16
    80003362:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003364:	4585                	li	a1,1
    80003366:	00000097          	auipc	ra,0x0
    8000336a:	dbe080e7          	jalr	-578(ra) # 80003124 <namex>
}
    8000336e:	60a2                	ld	ra,8(sp)
    80003370:	6402                	ld	s0,0(sp)
    80003372:	0141                	addi	sp,sp,16
    80003374:	8082                	ret

0000000080003376 <write_head>:
}

// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void write_head(void) {
    80003376:	1101                	addi	sp,sp,-32
    80003378:	ec06                	sd	ra,24(sp)
    8000337a:	e822                	sd	s0,16(sp)
    8000337c:	e426                	sd	s1,8(sp)
    8000337e:	e04a                	sd	s2,0(sp)
    80003380:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003382:	00016917          	auipc	s2,0x16
    80003386:	6be90913          	addi	s2,s2,1726 # 80019a40 <log>
    8000338a:	01892583          	lw	a1,24(s2)
    8000338e:	02892503          	lw	a0,40(s2)
    80003392:	fffff097          	auipc	ra,0xfffff
    80003396:	fe6080e7          	jalr	-26(ra) # 80002378 <bread>
    8000339a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    8000339c:	02c92683          	lw	a3,44(s2)
    800033a0:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033a2:	02d05863          	blez	a3,800033d2 <write_head+0x5c>
    800033a6:	00016797          	auipc	a5,0x16
    800033aa:	6ca78793          	addi	a5,a5,1738 # 80019a70 <log+0x30>
    800033ae:	05c50713          	addi	a4,a0,92
    800033b2:	36fd                	addiw	a3,a3,-1
    800033b4:	02069613          	slli	a2,a3,0x20
    800033b8:	01e65693          	srli	a3,a2,0x1e
    800033bc:	00016617          	auipc	a2,0x16
    800033c0:	6b860613          	addi	a2,a2,1720 # 80019a74 <log+0x34>
    800033c4:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800033c6:	4390                	lw	a2,0(a5)
    800033c8:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800033ca:	0791                	addi	a5,a5,4
    800033cc:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    800033ce:	fed79ce3          	bne	a5,a3,800033c6 <write_head+0x50>
  }
  bwrite(buf);
    800033d2:	8526                	mv	a0,s1
    800033d4:	fffff097          	auipc	ra,0xfffff
    800033d8:	096080e7          	jalr	150(ra) # 8000246a <bwrite>
  brelse(buf);
    800033dc:	8526                	mv	a0,s1
    800033de:	fffff097          	auipc	ra,0xfffff
    800033e2:	0ca080e7          	jalr	202(ra) # 800024a8 <brelse>
}
    800033e6:	60e2                	ld	ra,24(sp)
    800033e8:	6442                	ld	s0,16(sp)
    800033ea:	64a2                	ld	s1,8(sp)
    800033ec:	6902                	ld	s2,0(sp)
    800033ee:	6105                	addi	sp,sp,32
    800033f0:	8082                	ret

00000000800033f2 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800033f2:	00016797          	auipc	a5,0x16
    800033f6:	67a7a783          	lw	a5,1658(a5) # 80019a6c <log+0x2c>
    800033fa:	0af05d63          	blez	a5,800034b4 <install_trans+0xc2>
static void install_trans(int recovering) {
    800033fe:	7139                	addi	sp,sp,-64
    80003400:	fc06                	sd	ra,56(sp)
    80003402:	f822                	sd	s0,48(sp)
    80003404:	f426                	sd	s1,40(sp)
    80003406:	f04a                	sd	s2,32(sp)
    80003408:	ec4e                	sd	s3,24(sp)
    8000340a:	e852                	sd	s4,16(sp)
    8000340c:	e456                	sd	s5,8(sp)
    8000340e:	e05a                	sd	s6,0(sp)
    80003410:	0080                	addi	s0,sp,64
    80003412:	8b2a                	mv	s6,a0
    80003414:	00016a97          	auipc	s5,0x16
    80003418:	65ca8a93          	addi	s5,s5,1628 # 80019a70 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000341c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start + tail + 1);  // read log block
    8000341e:	00016997          	auipc	s3,0x16
    80003422:	62298993          	addi	s3,s3,1570 # 80019a40 <log>
    80003426:	a00d                	j	80003448 <install_trans+0x56>
    brelse(lbuf);
    80003428:	854a                	mv	a0,s2
    8000342a:	fffff097          	auipc	ra,0xfffff
    8000342e:	07e080e7          	jalr	126(ra) # 800024a8 <brelse>
    brelse(dbuf);
    80003432:	8526                	mv	a0,s1
    80003434:	fffff097          	auipc	ra,0xfffff
    80003438:	074080e7          	jalr	116(ra) # 800024a8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000343c:	2a05                	addiw	s4,s4,1
    8000343e:	0a91                	addi	s5,s5,4
    80003440:	02c9a783          	lw	a5,44(s3)
    80003444:	04fa5e63          	bge	s4,a5,800034a0 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1);  // read log block
    80003448:	0189a583          	lw	a1,24(s3)
    8000344c:	014585bb          	addw	a1,a1,s4
    80003450:	2585                	addiw	a1,a1,1
    80003452:	0289a503          	lw	a0,40(s3)
    80003456:	fffff097          	auipc	ra,0xfffff
    8000345a:	f22080e7          	jalr	-222(ra) # 80002378 <bread>
    8000345e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);    // read dst
    80003460:	000aa583          	lw	a1,0(s5)
    80003464:	0289a503          	lw	a0,40(s3)
    80003468:	fffff097          	auipc	ra,0xfffff
    8000346c:	f10080e7          	jalr	-240(ra) # 80002378 <bread>
    80003470:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003472:	40000613          	li	a2,1024
    80003476:	05890593          	addi	a1,s2,88
    8000347a:	05850513          	addi	a0,a0,88
    8000347e:	ffffd097          	auipc	ra,0xffffd
    80003482:	d58080e7          	jalr	-680(ra) # 800001d6 <memmove>
    bwrite(dbuf);                            // write dst to disk
    80003486:	8526                	mv	a0,s1
    80003488:	fffff097          	auipc	ra,0xfffff
    8000348c:	fe2080e7          	jalr	-30(ra) # 8000246a <bwrite>
    if (recovering == 0) bunpin(dbuf);
    80003490:	f80b1ce3          	bnez	s6,80003428 <install_trans+0x36>
    80003494:	8526                	mv	a0,s1
    80003496:	fffff097          	auipc	ra,0xfffff
    8000349a:	0ec080e7          	jalr	236(ra) # 80002582 <bunpin>
    8000349e:	b769                	j	80003428 <install_trans+0x36>
}
    800034a0:	70e2                	ld	ra,56(sp)
    800034a2:	7442                	ld	s0,48(sp)
    800034a4:	74a2                	ld	s1,40(sp)
    800034a6:	7902                	ld	s2,32(sp)
    800034a8:	69e2                	ld	s3,24(sp)
    800034aa:	6a42                	ld	s4,16(sp)
    800034ac:	6aa2                	ld	s5,8(sp)
    800034ae:	6b02                	ld	s6,0(sp)
    800034b0:	6121                	addi	sp,sp,64
    800034b2:	8082                	ret
    800034b4:	8082                	ret

00000000800034b6 <initlog>:
void initlog(int dev, struct superblock *sb) {
    800034b6:	7179                	addi	sp,sp,-48
    800034b8:	f406                	sd	ra,40(sp)
    800034ba:	f022                	sd	s0,32(sp)
    800034bc:	ec26                	sd	s1,24(sp)
    800034be:	e84a                	sd	s2,16(sp)
    800034c0:	e44e                	sd	s3,8(sp)
    800034c2:	1800                	addi	s0,sp,48
    800034c4:	892a                	mv	s2,a0
    800034c6:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800034c8:	00016497          	auipc	s1,0x16
    800034cc:	57848493          	addi	s1,s1,1400 # 80019a40 <log>
    800034d0:	00006597          	auipc	a1,0x6
    800034d4:	13858593          	addi	a1,a1,312 # 80009608 <syscalls+0x1f8>
    800034d8:	8526                	mv	a0,s1
    800034da:	00004097          	auipc	ra,0x4
    800034de:	9ac080e7          	jalr	-1620(ra) # 80006e86 <initlock>
  log.start = sb->logstart;
    800034e2:	0149a583          	lw	a1,20(s3)
    800034e6:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800034e8:	0109a783          	lw	a5,16(s3)
    800034ec:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800034ee:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800034f2:	854a                	mv	a0,s2
    800034f4:	fffff097          	auipc	ra,0xfffff
    800034f8:	e84080e7          	jalr	-380(ra) # 80002378 <bread>
  log.lh.n = lh->n;
    800034fc:	4d34                	lw	a3,88(a0)
    800034fe:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003500:	02d05663          	blez	a3,8000352c <initlog+0x76>
    80003504:	05c50793          	addi	a5,a0,92
    80003508:	00016717          	auipc	a4,0x16
    8000350c:	56870713          	addi	a4,a4,1384 # 80019a70 <log+0x30>
    80003510:	36fd                	addiw	a3,a3,-1
    80003512:	02069613          	slli	a2,a3,0x20
    80003516:	01e65693          	srli	a3,a2,0x1e
    8000351a:	06050613          	addi	a2,a0,96
    8000351e:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003520:	4390                	lw	a2,0(a5)
    80003522:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003524:	0791                	addi	a5,a5,4
    80003526:	0711                	addi	a4,a4,4
    80003528:	fed79ce3          	bne	a5,a3,80003520 <initlog+0x6a>
  brelse(buf);
    8000352c:	fffff097          	auipc	ra,0xfffff
    80003530:	f7c080e7          	jalr	-132(ra) # 800024a8 <brelse>

static void recover_from_log(void) {
  read_head();
  install_trans(1);  // if committed, copy from log to disk
    80003534:	4505                	li	a0,1
    80003536:	00000097          	auipc	ra,0x0
    8000353a:	ebc080e7          	jalr	-324(ra) # 800033f2 <install_trans>
  log.lh.n = 0;
    8000353e:	00016797          	auipc	a5,0x16
    80003542:	5207a723          	sw	zero,1326(a5) # 80019a6c <log+0x2c>
  write_head();  // clear the log
    80003546:	00000097          	auipc	ra,0x0
    8000354a:	e30080e7          	jalr	-464(ra) # 80003376 <write_head>
}
    8000354e:	70a2                	ld	ra,40(sp)
    80003550:	7402                	ld	s0,32(sp)
    80003552:	64e2                	ld	s1,24(sp)
    80003554:	6942                	ld	s2,16(sp)
    80003556:	69a2                	ld	s3,8(sp)
    80003558:	6145                	addi	sp,sp,48
    8000355a:	8082                	ret

000000008000355c <begin_op>:
}

// called at the start of each FS system call.
void begin_op(void) {
    8000355c:	1101                	addi	sp,sp,-32
    8000355e:	ec06                	sd	ra,24(sp)
    80003560:	e822                	sd	s0,16(sp)
    80003562:	e426                	sd	s1,8(sp)
    80003564:	e04a                	sd	s2,0(sp)
    80003566:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003568:	00016517          	auipc	a0,0x16
    8000356c:	4d850513          	addi	a0,a0,1240 # 80019a40 <log>
    80003570:	00004097          	auipc	ra,0x4
    80003574:	9a6080e7          	jalr	-1626(ra) # 80006f16 <acquire>
  while (1) {
    if (log.committing) {
    80003578:	00016497          	auipc	s1,0x16
    8000357c:	4c848493          	addi	s1,s1,1224 # 80019a40 <log>
      sleep(&log, &log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    80003580:	4979                	li	s2,30
    80003582:	a039                	j	80003590 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003584:	85a6                	mv	a1,s1
    80003586:	8526                	mv	a0,s1
    80003588:	ffffe097          	auipc	ra,0xffffe
    8000358c:	010080e7          	jalr	16(ra) # 80001598 <sleep>
    if (log.committing) {
    80003590:	50dc                	lw	a5,36(s1)
    80003592:	fbed                	bnez	a5,80003584 <begin_op+0x28>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    80003594:	5098                	lw	a4,32(s1)
    80003596:	2705                	addiw	a4,a4,1
    80003598:	0007069b          	sext.w	a3,a4
    8000359c:	0027179b          	slliw	a5,a4,0x2
    800035a0:	9fb9                	addw	a5,a5,a4
    800035a2:	0017979b          	slliw	a5,a5,0x1
    800035a6:	54d8                	lw	a4,44(s1)
    800035a8:	9fb9                	addw	a5,a5,a4
    800035aa:	00f95963          	bge	s2,a5,800035bc <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035ae:	85a6                	mv	a1,s1
    800035b0:	8526                	mv	a0,s1
    800035b2:	ffffe097          	auipc	ra,0xffffe
    800035b6:	fe6080e7          	jalr	-26(ra) # 80001598 <sleep>
    800035ba:	bfd9                	j	80003590 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035bc:	00016517          	auipc	a0,0x16
    800035c0:	48450513          	addi	a0,a0,1156 # 80019a40 <log>
    800035c4:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800035c6:	00004097          	auipc	ra,0x4
    800035ca:	a04080e7          	jalr	-1532(ra) # 80006fca <release>
      break;
    }
  }
}
    800035ce:	60e2                	ld	ra,24(sp)
    800035d0:	6442                	ld	s0,16(sp)
    800035d2:	64a2                	ld	s1,8(sp)
    800035d4:	6902                	ld	s2,0(sp)
    800035d6:	6105                	addi	sp,sp,32
    800035d8:	8082                	ret

00000000800035da <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void end_op(void) {
    800035da:	7139                	addi	sp,sp,-64
    800035dc:	fc06                	sd	ra,56(sp)
    800035de:	f822                	sd	s0,48(sp)
    800035e0:	f426                	sd	s1,40(sp)
    800035e2:	f04a                	sd	s2,32(sp)
    800035e4:	ec4e                	sd	s3,24(sp)
    800035e6:	e852                	sd	s4,16(sp)
    800035e8:	e456                	sd	s5,8(sp)
    800035ea:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800035ec:	00016497          	auipc	s1,0x16
    800035f0:	45448493          	addi	s1,s1,1108 # 80019a40 <log>
    800035f4:	8526                	mv	a0,s1
    800035f6:	00004097          	auipc	ra,0x4
    800035fa:	920080e7          	jalr	-1760(ra) # 80006f16 <acquire>
  log.outstanding -= 1;
    800035fe:	509c                	lw	a5,32(s1)
    80003600:	37fd                	addiw	a5,a5,-1
    80003602:	0007891b          	sext.w	s2,a5
    80003606:	d09c                	sw	a5,32(s1)
  if (log.committing) panic("log.committing");
    80003608:	50dc                	lw	a5,36(s1)
    8000360a:	e7b9                	bnez	a5,80003658 <end_op+0x7e>
  if (log.outstanding == 0) {
    8000360c:	04091e63          	bnez	s2,80003668 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003610:	00016497          	auipc	s1,0x16
    80003614:	43048493          	addi	s1,s1,1072 # 80019a40 <log>
    80003618:	4785                	li	a5,1
    8000361a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000361c:	8526                	mv	a0,s1
    8000361e:	00004097          	auipc	ra,0x4
    80003622:	9ac080e7          	jalr	-1620(ra) # 80006fca <release>
    brelse(to);
  }
}

static void commit() {
  if (log.lh.n > 0) {
    80003626:	54dc                	lw	a5,44(s1)
    80003628:	06f04763          	bgtz	a5,80003696 <end_op+0xbc>
    acquire(&log.lock);
    8000362c:	00016497          	auipc	s1,0x16
    80003630:	41448493          	addi	s1,s1,1044 # 80019a40 <log>
    80003634:	8526                	mv	a0,s1
    80003636:	00004097          	auipc	ra,0x4
    8000363a:	8e0080e7          	jalr	-1824(ra) # 80006f16 <acquire>
    log.committing = 0;
    8000363e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003642:	8526                	mv	a0,s1
    80003644:	ffffe097          	auipc	ra,0xffffe
    80003648:	fb8080e7          	jalr	-72(ra) # 800015fc <wakeup>
    release(&log.lock);
    8000364c:	8526                	mv	a0,s1
    8000364e:	00004097          	auipc	ra,0x4
    80003652:	97c080e7          	jalr	-1668(ra) # 80006fca <release>
}
    80003656:	a03d                	j	80003684 <end_op+0xaa>
  if (log.committing) panic("log.committing");
    80003658:	00006517          	auipc	a0,0x6
    8000365c:	fb850513          	addi	a0,a0,-72 # 80009610 <syscalls+0x200>
    80003660:	00003097          	auipc	ra,0x3
    80003664:	37e080e7          	jalr	894(ra) # 800069de <panic>
    wakeup(&log);
    80003668:	00016497          	auipc	s1,0x16
    8000366c:	3d848493          	addi	s1,s1,984 # 80019a40 <log>
    80003670:	8526                	mv	a0,s1
    80003672:	ffffe097          	auipc	ra,0xffffe
    80003676:	f8a080e7          	jalr	-118(ra) # 800015fc <wakeup>
  release(&log.lock);
    8000367a:	8526                	mv	a0,s1
    8000367c:	00004097          	auipc	ra,0x4
    80003680:	94e080e7          	jalr	-1714(ra) # 80006fca <release>
}
    80003684:	70e2                	ld	ra,56(sp)
    80003686:	7442                	ld	s0,48(sp)
    80003688:	74a2                	ld	s1,40(sp)
    8000368a:	7902                	ld	s2,32(sp)
    8000368c:	69e2                	ld	s3,24(sp)
    8000368e:	6a42                	ld	s4,16(sp)
    80003690:	6aa2                	ld	s5,8(sp)
    80003692:	6121                	addi	sp,sp,64
    80003694:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003696:	00016a97          	auipc	s5,0x16
    8000369a:	3daa8a93          	addi	s5,s5,986 # 80019a70 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1);  // log block
    8000369e:	00016a17          	auipc	s4,0x16
    800036a2:	3a2a0a13          	addi	s4,s4,930 # 80019a40 <log>
    800036a6:	018a2583          	lw	a1,24(s4)
    800036aa:	012585bb          	addw	a1,a1,s2
    800036ae:	2585                	addiw	a1,a1,1
    800036b0:	028a2503          	lw	a0,40(s4)
    800036b4:	fffff097          	auipc	ra,0xfffff
    800036b8:	cc4080e7          	jalr	-828(ra) # 80002378 <bread>
    800036bc:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]);  // cache block
    800036be:	000aa583          	lw	a1,0(s5)
    800036c2:	028a2503          	lw	a0,40(s4)
    800036c6:	fffff097          	auipc	ra,0xfffff
    800036ca:	cb2080e7          	jalr	-846(ra) # 80002378 <bread>
    800036ce:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800036d0:	40000613          	li	a2,1024
    800036d4:	05850593          	addi	a1,a0,88
    800036d8:	05848513          	addi	a0,s1,88
    800036dc:	ffffd097          	auipc	ra,0xffffd
    800036e0:	afa080e7          	jalr	-1286(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    800036e4:	8526                	mv	a0,s1
    800036e6:	fffff097          	auipc	ra,0xfffff
    800036ea:	d84080e7          	jalr	-636(ra) # 8000246a <bwrite>
    brelse(from);
    800036ee:	854e                	mv	a0,s3
    800036f0:	fffff097          	auipc	ra,0xfffff
    800036f4:	db8080e7          	jalr	-584(ra) # 800024a8 <brelse>
    brelse(to);
    800036f8:	8526                	mv	a0,s1
    800036fa:	fffff097          	auipc	ra,0xfffff
    800036fe:	dae080e7          	jalr	-594(ra) # 800024a8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003702:	2905                	addiw	s2,s2,1
    80003704:	0a91                	addi	s5,s5,4
    80003706:	02ca2783          	lw	a5,44(s4)
    8000370a:	f8f94ee3          	blt	s2,a5,800036a6 <end_op+0xcc>
    write_log();       // Write modified blocks from cache to log
    write_head();      // Write header to disk -- the real commit
    8000370e:	00000097          	auipc	ra,0x0
    80003712:	c68080e7          	jalr	-920(ra) # 80003376 <write_head>
    install_trans(0);  // Now install writes to home locations
    80003716:	4501                	li	a0,0
    80003718:	00000097          	auipc	ra,0x0
    8000371c:	cda080e7          	jalr	-806(ra) # 800033f2 <install_trans>
    log.lh.n = 0;
    80003720:	00016797          	auipc	a5,0x16
    80003724:	3407a623          	sw	zero,844(a5) # 80019a6c <log+0x2c>
    write_head();  // Erase the transaction from the log
    80003728:	00000097          	auipc	ra,0x0
    8000372c:	c4e080e7          	jalr	-946(ra) # 80003376 <write_head>
    80003730:	bdf5                	j	8000362c <end_op+0x52>

0000000080003732 <log_write>:
// log_write() replaces bwrite(); a typical use is:
//   bp = bread(...)
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void log_write(struct buf *b) {
    80003732:	1101                	addi	sp,sp,-32
    80003734:	ec06                	sd	ra,24(sp)
    80003736:	e822                	sd	s0,16(sp)
    80003738:	e426                	sd	s1,8(sp)
    8000373a:	e04a                	sd	s2,0(sp)
    8000373c:	1000                	addi	s0,sp,32
    8000373e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003740:	00016917          	auipc	s2,0x16
    80003744:	30090913          	addi	s2,s2,768 # 80019a40 <log>
    80003748:	854a                	mv	a0,s2
    8000374a:	00003097          	auipc	ra,0x3
    8000374e:	7cc080e7          	jalr	1996(ra) # 80006f16 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003752:	02c92603          	lw	a2,44(s2)
    80003756:	47f5                	li	a5,29
    80003758:	06c7c563          	blt	a5,a2,800037c2 <log_write+0x90>
    8000375c:	00016797          	auipc	a5,0x16
    80003760:	3007a783          	lw	a5,768(a5) # 80019a5c <log+0x1c>
    80003764:	37fd                	addiw	a5,a5,-1
    80003766:	04f65e63          	bge	a2,a5,800037c2 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1) panic("log_write outside of trans");
    8000376a:	00016797          	auipc	a5,0x16
    8000376e:	2f67a783          	lw	a5,758(a5) # 80019a60 <log+0x20>
    80003772:	06f05063          	blez	a5,800037d2 <log_write+0xa0>

  for (i = 0; i < log.lh.n; i++) {
    80003776:	4781                	li	a5,0
    80003778:	06c05563          	blez	a2,800037e2 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)  // log absorption
    8000377c:	44cc                	lw	a1,12(s1)
    8000377e:	00016717          	auipc	a4,0x16
    80003782:	2f270713          	addi	a4,a4,754 # 80019a70 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003786:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)  // log absorption
    80003788:	4314                	lw	a3,0(a4)
    8000378a:	04b68c63          	beq	a3,a1,800037e2 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000378e:	2785                	addiw	a5,a5,1
    80003790:	0711                	addi	a4,a4,4
    80003792:	fef61be3          	bne	a2,a5,80003788 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003796:	0621                	addi	a2,a2,8
    80003798:	060a                	slli	a2,a2,0x2
    8000379a:	00016797          	auipc	a5,0x16
    8000379e:	2a678793          	addi	a5,a5,678 # 80019a40 <log>
    800037a2:	97b2                	add	a5,a5,a2
    800037a4:	44d8                	lw	a4,12(s1)
    800037a6:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037a8:	8526                	mv	a0,s1
    800037aa:	fffff097          	auipc	ra,0xfffff
    800037ae:	d9c080e7          	jalr	-612(ra) # 80002546 <bpin>
    log.lh.n++;
    800037b2:	00016717          	auipc	a4,0x16
    800037b6:	28e70713          	addi	a4,a4,654 # 80019a40 <log>
    800037ba:	575c                	lw	a5,44(a4)
    800037bc:	2785                	addiw	a5,a5,1
    800037be:	d75c                	sw	a5,44(a4)
    800037c0:	a82d                	j	800037fa <log_write+0xc8>
    panic("too big a transaction");
    800037c2:	00006517          	auipc	a0,0x6
    800037c6:	e5e50513          	addi	a0,a0,-418 # 80009620 <syscalls+0x210>
    800037ca:	00003097          	auipc	ra,0x3
    800037ce:	214080e7          	jalr	532(ra) # 800069de <panic>
  if (log.outstanding < 1) panic("log_write outside of trans");
    800037d2:	00006517          	auipc	a0,0x6
    800037d6:	e6650513          	addi	a0,a0,-410 # 80009638 <syscalls+0x228>
    800037da:	00003097          	auipc	ra,0x3
    800037de:	204080e7          	jalr	516(ra) # 800069de <panic>
  log.lh.block[i] = b->blockno;
    800037e2:	00878693          	addi	a3,a5,8
    800037e6:	068a                	slli	a3,a3,0x2
    800037e8:	00016717          	auipc	a4,0x16
    800037ec:	25870713          	addi	a4,a4,600 # 80019a40 <log>
    800037f0:	9736                	add	a4,a4,a3
    800037f2:	44d4                	lw	a3,12(s1)
    800037f4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800037f6:	faf609e3          	beq	a2,a5,800037a8 <log_write+0x76>
  }
  release(&log.lock);
    800037fa:	00016517          	auipc	a0,0x16
    800037fe:	24650513          	addi	a0,a0,582 # 80019a40 <log>
    80003802:	00003097          	auipc	ra,0x3
    80003806:	7c8080e7          	jalr	1992(ra) # 80006fca <release>
}
    8000380a:	60e2                	ld	ra,24(sp)
    8000380c:	6442                	ld	s0,16(sp)
    8000380e:	64a2                	ld	s1,8(sp)
    80003810:	6902                	ld	s2,0(sp)
    80003812:	6105                	addi	sp,sp,32
    80003814:	8082                	ret

0000000080003816 <initsleeplock>:
#include "sleeplock.h"

#include "defs.h"
#include "proc.h"

void initsleeplock(struct sleeplock *lk, char *name) {
    80003816:	1101                	addi	sp,sp,-32
    80003818:	ec06                	sd	ra,24(sp)
    8000381a:	e822                	sd	s0,16(sp)
    8000381c:	e426                	sd	s1,8(sp)
    8000381e:	e04a                	sd	s2,0(sp)
    80003820:	1000                	addi	s0,sp,32
    80003822:	84aa                	mv	s1,a0
    80003824:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003826:	00006597          	auipc	a1,0x6
    8000382a:	e3258593          	addi	a1,a1,-462 # 80009658 <syscalls+0x248>
    8000382e:	0521                	addi	a0,a0,8
    80003830:	00003097          	auipc	ra,0x3
    80003834:	656080e7          	jalr	1622(ra) # 80006e86 <initlock>
  lk->name = name;
    80003838:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000383c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003840:	0204a423          	sw	zero,40(s1)
}
    80003844:	60e2                	ld	ra,24(sp)
    80003846:	6442                	ld	s0,16(sp)
    80003848:	64a2                	ld	s1,8(sp)
    8000384a:	6902                	ld	s2,0(sp)
    8000384c:	6105                	addi	sp,sp,32
    8000384e:	8082                	ret

0000000080003850 <acquiresleep>:

void acquiresleep(struct sleeplock *lk) {
    80003850:	1101                	addi	sp,sp,-32
    80003852:	ec06                	sd	ra,24(sp)
    80003854:	e822                	sd	s0,16(sp)
    80003856:	e426                	sd	s1,8(sp)
    80003858:	e04a                	sd	s2,0(sp)
    8000385a:	1000                	addi	s0,sp,32
    8000385c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000385e:	00850913          	addi	s2,a0,8
    80003862:	854a                	mv	a0,s2
    80003864:	00003097          	auipc	ra,0x3
    80003868:	6b2080e7          	jalr	1714(ra) # 80006f16 <acquire>
  while (lk->locked) {
    8000386c:	409c                	lw	a5,0(s1)
    8000386e:	cb89                	beqz	a5,80003880 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003870:	85ca                	mv	a1,s2
    80003872:	8526                	mv	a0,s1
    80003874:	ffffe097          	auipc	ra,0xffffe
    80003878:	d24080e7          	jalr	-732(ra) # 80001598 <sleep>
  while (lk->locked) {
    8000387c:	409c                	lw	a5,0(s1)
    8000387e:	fbed                	bnez	a5,80003870 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003880:	4785                	li	a5,1
    80003882:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003884:	ffffd097          	auipc	ra,0xffffd
    80003888:	668080e7          	jalr	1640(ra) # 80000eec <myproc>
    8000388c:	591c                	lw	a5,48(a0)
    8000388e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003890:	854a                	mv	a0,s2
    80003892:	00003097          	auipc	ra,0x3
    80003896:	738080e7          	jalr	1848(ra) # 80006fca <release>
}
    8000389a:	60e2                	ld	ra,24(sp)
    8000389c:	6442                	ld	s0,16(sp)
    8000389e:	64a2                	ld	s1,8(sp)
    800038a0:	6902                	ld	s2,0(sp)
    800038a2:	6105                	addi	sp,sp,32
    800038a4:	8082                	ret

00000000800038a6 <releasesleep>:

void releasesleep(struct sleeplock *lk) {
    800038a6:	1101                	addi	sp,sp,-32
    800038a8:	ec06                	sd	ra,24(sp)
    800038aa:	e822                	sd	s0,16(sp)
    800038ac:	e426                	sd	s1,8(sp)
    800038ae:	e04a                	sd	s2,0(sp)
    800038b0:	1000                	addi	s0,sp,32
    800038b2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038b4:	00850913          	addi	s2,a0,8
    800038b8:	854a                	mv	a0,s2
    800038ba:	00003097          	auipc	ra,0x3
    800038be:	65c080e7          	jalr	1628(ra) # 80006f16 <acquire>
  lk->locked = 0;
    800038c2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038c6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800038ca:	8526                	mv	a0,s1
    800038cc:	ffffe097          	auipc	ra,0xffffe
    800038d0:	d30080e7          	jalr	-720(ra) # 800015fc <wakeup>
  release(&lk->lk);
    800038d4:	854a                	mv	a0,s2
    800038d6:	00003097          	auipc	ra,0x3
    800038da:	6f4080e7          	jalr	1780(ra) # 80006fca <release>
}
    800038de:	60e2                	ld	ra,24(sp)
    800038e0:	6442                	ld	s0,16(sp)
    800038e2:	64a2                	ld	s1,8(sp)
    800038e4:	6902                	ld	s2,0(sp)
    800038e6:	6105                	addi	sp,sp,32
    800038e8:	8082                	ret

00000000800038ea <holdingsleep>:

int holdingsleep(struct sleeplock *lk) {
    800038ea:	7179                	addi	sp,sp,-48
    800038ec:	f406                	sd	ra,40(sp)
    800038ee:	f022                	sd	s0,32(sp)
    800038f0:	ec26                	sd	s1,24(sp)
    800038f2:	e84a                	sd	s2,16(sp)
    800038f4:	e44e                	sd	s3,8(sp)
    800038f6:	1800                	addi	s0,sp,48
    800038f8:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    800038fa:	00850913          	addi	s2,a0,8
    800038fe:	854a                	mv	a0,s2
    80003900:	00003097          	auipc	ra,0x3
    80003904:	616080e7          	jalr	1558(ra) # 80006f16 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003908:	409c                	lw	a5,0(s1)
    8000390a:	ef99                	bnez	a5,80003928 <holdingsleep+0x3e>
    8000390c:	4481                	li	s1,0
  release(&lk->lk);
    8000390e:	854a                	mv	a0,s2
    80003910:	00003097          	auipc	ra,0x3
    80003914:	6ba080e7          	jalr	1722(ra) # 80006fca <release>
  return r;
}
    80003918:	8526                	mv	a0,s1
    8000391a:	70a2                	ld	ra,40(sp)
    8000391c:	7402                	ld	s0,32(sp)
    8000391e:	64e2                	ld	s1,24(sp)
    80003920:	6942                	ld	s2,16(sp)
    80003922:	69a2                	ld	s3,8(sp)
    80003924:	6145                	addi	sp,sp,48
    80003926:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003928:	0284a983          	lw	s3,40(s1)
    8000392c:	ffffd097          	auipc	ra,0xffffd
    80003930:	5c0080e7          	jalr	1472(ra) # 80000eec <myproc>
    80003934:	5904                	lw	s1,48(a0)
    80003936:	413484b3          	sub	s1,s1,s3
    8000393a:	0014b493          	seqz	s1,s1
    8000393e:	bfc1                	j	8000390e <holdingsleep+0x24>

0000000080003940 <fileinit>:
struct {
  struct spinlock lock;
  struct file file[NFILE];
} ftable;

void fileinit(void) { initlock(&ftable.lock, "ftable"); }
    80003940:	1141                	addi	sp,sp,-16
    80003942:	e406                	sd	ra,8(sp)
    80003944:	e022                	sd	s0,0(sp)
    80003946:	0800                	addi	s0,sp,16
    80003948:	00006597          	auipc	a1,0x6
    8000394c:	d2058593          	addi	a1,a1,-736 # 80009668 <syscalls+0x258>
    80003950:	00016517          	auipc	a0,0x16
    80003954:	23850513          	addi	a0,a0,568 # 80019b88 <ftable>
    80003958:	00003097          	auipc	ra,0x3
    8000395c:	52e080e7          	jalr	1326(ra) # 80006e86 <initlock>
    80003960:	60a2                	ld	ra,8(sp)
    80003962:	6402                	ld	s0,0(sp)
    80003964:	0141                	addi	sp,sp,16
    80003966:	8082                	ret

0000000080003968 <filealloc>:

// Allocate a file structure.
struct file *filealloc(void) {
    80003968:	1101                	addi	sp,sp,-32
    8000396a:	ec06                	sd	ra,24(sp)
    8000396c:	e822                	sd	s0,16(sp)
    8000396e:	e426                	sd	s1,8(sp)
    80003970:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003972:	00016517          	auipc	a0,0x16
    80003976:	21650513          	addi	a0,a0,534 # 80019b88 <ftable>
    8000397a:	00003097          	auipc	ra,0x3
    8000397e:	59c080e7          	jalr	1436(ra) # 80006f16 <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80003982:	00016497          	auipc	s1,0x16
    80003986:	21e48493          	addi	s1,s1,542 # 80019ba0 <ftable+0x18>
    8000398a:	00017717          	auipc	a4,0x17
    8000398e:	1b670713          	addi	a4,a4,438 # 8001ab40 <disk>
    if (f->ref == 0) {
    80003992:	40dc                	lw	a5,4(s1)
    80003994:	cf99                	beqz	a5,800039b2 <filealloc+0x4a>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80003996:	02848493          	addi	s1,s1,40
    8000399a:	fee49ce3          	bne	s1,a4,80003992 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000399e:	00016517          	auipc	a0,0x16
    800039a2:	1ea50513          	addi	a0,a0,490 # 80019b88 <ftable>
    800039a6:	00003097          	auipc	ra,0x3
    800039aa:	624080e7          	jalr	1572(ra) # 80006fca <release>
  return 0;
    800039ae:	4481                	li	s1,0
    800039b0:	a819                	j	800039c6 <filealloc+0x5e>
      f->ref = 1;
    800039b2:	4785                	li	a5,1
    800039b4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039b6:	00016517          	auipc	a0,0x16
    800039ba:	1d250513          	addi	a0,a0,466 # 80019b88 <ftable>
    800039be:	00003097          	auipc	ra,0x3
    800039c2:	60c080e7          	jalr	1548(ra) # 80006fca <release>
}
    800039c6:	8526                	mv	a0,s1
    800039c8:	60e2                	ld	ra,24(sp)
    800039ca:	6442                	ld	s0,16(sp)
    800039cc:	64a2                	ld	s1,8(sp)
    800039ce:	6105                	addi	sp,sp,32
    800039d0:	8082                	ret

00000000800039d2 <filedup>:

// Increment ref count for file f.
struct file *filedup(struct file *f) {
    800039d2:	1101                	addi	sp,sp,-32
    800039d4:	ec06                	sd	ra,24(sp)
    800039d6:	e822                	sd	s0,16(sp)
    800039d8:	e426                	sd	s1,8(sp)
    800039da:	1000                	addi	s0,sp,32
    800039dc:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800039de:	00016517          	auipc	a0,0x16
    800039e2:	1aa50513          	addi	a0,a0,426 # 80019b88 <ftable>
    800039e6:	00003097          	auipc	ra,0x3
    800039ea:	530080e7          	jalr	1328(ra) # 80006f16 <acquire>
  if (f->ref < 1) panic("filedup");
    800039ee:	40dc                	lw	a5,4(s1)
    800039f0:	02f05263          	blez	a5,80003a14 <filedup+0x42>
  f->ref++;
    800039f4:	2785                	addiw	a5,a5,1
    800039f6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800039f8:	00016517          	auipc	a0,0x16
    800039fc:	19050513          	addi	a0,a0,400 # 80019b88 <ftable>
    80003a00:	00003097          	auipc	ra,0x3
    80003a04:	5ca080e7          	jalr	1482(ra) # 80006fca <release>
  return f;
}
    80003a08:	8526                	mv	a0,s1
    80003a0a:	60e2                	ld	ra,24(sp)
    80003a0c:	6442                	ld	s0,16(sp)
    80003a0e:	64a2                	ld	s1,8(sp)
    80003a10:	6105                	addi	sp,sp,32
    80003a12:	8082                	ret
  if (f->ref < 1) panic("filedup");
    80003a14:	00006517          	auipc	a0,0x6
    80003a18:	c5c50513          	addi	a0,a0,-932 # 80009670 <syscalls+0x260>
    80003a1c:	00003097          	auipc	ra,0x3
    80003a20:	fc2080e7          	jalr	-62(ra) # 800069de <panic>

0000000080003a24 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f) {
    80003a24:	7139                	addi	sp,sp,-64
    80003a26:	fc06                	sd	ra,56(sp)
    80003a28:	f822                	sd	s0,48(sp)
    80003a2a:	f426                	sd	s1,40(sp)
    80003a2c:	f04a                	sd	s2,32(sp)
    80003a2e:	ec4e                	sd	s3,24(sp)
    80003a30:	e852                	sd	s4,16(sp)
    80003a32:	e456                	sd	s5,8(sp)
    80003a34:	0080                	addi	s0,sp,64
    80003a36:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a38:	00016517          	auipc	a0,0x16
    80003a3c:	15050513          	addi	a0,a0,336 # 80019b88 <ftable>
    80003a40:	00003097          	auipc	ra,0x3
    80003a44:	4d6080e7          	jalr	1238(ra) # 80006f16 <acquire>
  if (f->ref < 1) panic("fileclose");
    80003a48:	40dc                	lw	a5,4(s1)
    80003a4a:	06f05163          	blez	a5,80003aac <fileclose+0x88>
  if (--f->ref > 0) {
    80003a4e:	37fd                	addiw	a5,a5,-1
    80003a50:	0007871b          	sext.w	a4,a5
    80003a54:	c0dc                	sw	a5,4(s1)
    80003a56:	06e04363          	bgtz	a4,80003abc <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a5a:	0004a903          	lw	s2,0(s1)
    80003a5e:	0094ca83          	lbu	s5,9(s1)
    80003a62:	0104ba03          	ld	s4,16(s1)
    80003a66:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a6a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a6e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a72:	00016517          	auipc	a0,0x16
    80003a76:	11650513          	addi	a0,a0,278 # 80019b88 <ftable>
    80003a7a:	00003097          	auipc	ra,0x3
    80003a7e:	550080e7          	jalr	1360(ra) # 80006fca <release>

  if (ff.type == FD_PIPE) {
    80003a82:	4785                	li	a5,1
    80003a84:	04f90d63          	beq	s2,a5,80003ade <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    80003a88:	3979                	addiw	s2,s2,-2
    80003a8a:	4785                	li	a5,1
    80003a8c:	0527e063          	bltu	a5,s2,80003acc <fileclose+0xa8>
    begin_op();
    80003a90:	00000097          	auipc	ra,0x0
    80003a94:	acc080e7          	jalr	-1332(ra) # 8000355c <begin_op>
    iput(ff.ip);
    80003a98:	854e                	mv	a0,s3
    80003a9a:	fffff097          	auipc	ra,0xfffff
    80003a9e:	2b0080e7          	jalr	688(ra) # 80002d4a <iput>
    end_op();
    80003aa2:	00000097          	auipc	ra,0x0
    80003aa6:	b38080e7          	jalr	-1224(ra) # 800035da <end_op>
    80003aaa:	a00d                	j	80003acc <fileclose+0xa8>
  if (f->ref < 1) panic("fileclose");
    80003aac:	00006517          	auipc	a0,0x6
    80003ab0:	bcc50513          	addi	a0,a0,-1076 # 80009678 <syscalls+0x268>
    80003ab4:	00003097          	auipc	ra,0x3
    80003ab8:	f2a080e7          	jalr	-214(ra) # 800069de <panic>
    release(&ftable.lock);
    80003abc:	00016517          	auipc	a0,0x16
    80003ac0:	0cc50513          	addi	a0,a0,204 # 80019b88 <ftable>
    80003ac4:	00003097          	auipc	ra,0x3
    80003ac8:	506080e7          	jalr	1286(ra) # 80006fca <release>
  }
}
    80003acc:	70e2                	ld	ra,56(sp)
    80003ace:	7442                	ld	s0,48(sp)
    80003ad0:	74a2                	ld	s1,40(sp)
    80003ad2:	7902                	ld	s2,32(sp)
    80003ad4:	69e2                	ld	s3,24(sp)
    80003ad6:	6a42                	ld	s4,16(sp)
    80003ad8:	6aa2                	ld	s5,8(sp)
    80003ada:	6121                	addi	sp,sp,64
    80003adc:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003ade:	85d6                	mv	a1,s5
    80003ae0:	8552                	mv	a0,s4
    80003ae2:	00000097          	auipc	ra,0x0
    80003ae6:	34c080e7          	jalr	844(ra) # 80003e2e <pipeclose>
    80003aea:	b7cd                	j	80003acc <fileclose+0xa8>

0000000080003aec <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int filestat(struct file *f, uint64 addr) {
    80003aec:	715d                	addi	sp,sp,-80
    80003aee:	e486                	sd	ra,72(sp)
    80003af0:	e0a2                	sd	s0,64(sp)
    80003af2:	fc26                	sd	s1,56(sp)
    80003af4:	f84a                	sd	s2,48(sp)
    80003af6:	f44e                	sd	s3,40(sp)
    80003af8:	0880                	addi	s0,sp,80
    80003afa:	84aa                	mv	s1,a0
    80003afc:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003afe:	ffffd097          	auipc	ra,0xffffd
    80003b02:	3ee080e7          	jalr	1006(ra) # 80000eec <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    80003b06:	409c                	lw	a5,0(s1)
    80003b08:	37f9                	addiw	a5,a5,-2
    80003b0a:	4705                	li	a4,1
    80003b0c:	04f76763          	bltu	a4,a5,80003b5a <filestat+0x6e>
    80003b10:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b12:	6c88                	ld	a0,24(s1)
    80003b14:	fffff097          	auipc	ra,0xfffff
    80003b18:	07c080e7          	jalr	124(ra) # 80002b90 <ilock>
    stati(f->ip, &st);
    80003b1c:	fb840593          	addi	a1,s0,-72
    80003b20:	6c88                	ld	a0,24(s1)
    80003b22:	fffff097          	auipc	ra,0xfffff
    80003b26:	2f8080e7          	jalr	760(ra) # 80002e1a <stati>
    iunlock(f->ip);
    80003b2a:	6c88                	ld	a0,24(s1)
    80003b2c:	fffff097          	auipc	ra,0xfffff
    80003b30:	126080e7          	jalr	294(ra) # 80002c52 <iunlock>
    if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0) return -1;
    80003b34:	46e1                	li	a3,24
    80003b36:	fb840613          	addi	a2,s0,-72
    80003b3a:	85ce                	mv	a1,s3
    80003b3c:	05093503          	ld	a0,80(s2)
    80003b40:	ffffd097          	auipc	ra,0xffffd
    80003b44:	038080e7          	jalr	56(ra) # 80000b78 <copyout>
    80003b48:	41f5551b          	sraiw	a0,a0,0x1f
    return 0;
  }
  return -1;
}
    80003b4c:	60a6                	ld	ra,72(sp)
    80003b4e:	6406                	ld	s0,64(sp)
    80003b50:	74e2                	ld	s1,56(sp)
    80003b52:	7942                	ld	s2,48(sp)
    80003b54:	79a2                	ld	s3,40(sp)
    80003b56:	6161                	addi	sp,sp,80
    80003b58:	8082                	ret
  return -1;
    80003b5a:	557d                	li	a0,-1
    80003b5c:	bfc5                	j	80003b4c <filestat+0x60>

0000000080003b5e <fileread>:

// Read from file f.
// addr is a user virtual address.
int fileread(struct file *f, uint64 addr, int n) {
    80003b5e:	7179                	addi	sp,sp,-48
    80003b60:	f406                	sd	ra,40(sp)
    80003b62:	f022                	sd	s0,32(sp)
    80003b64:	ec26                	sd	s1,24(sp)
    80003b66:	e84a                	sd	s2,16(sp)
    80003b68:	e44e                	sd	s3,8(sp)
    80003b6a:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0) return -1;
    80003b6c:	00854783          	lbu	a5,8(a0)
    80003b70:	c3d5                	beqz	a5,80003c14 <fileread+0xb6>
    80003b72:	84aa                	mv	s1,a0
    80003b74:	89ae                	mv	s3,a1
    80003b76:	8932                	mv	s2,a2

  if (f->type == FD_PIPE) {
    80003b78:	411c                	lw	a5,0(a0)
    80003b7a:	4705                	li	a4,1
    80003b7c:	04e78963          	beq	a5,a4,80003bce <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80003b80:	470d                	li	a4,3
    80003b82:	04e78d63          	beq	a5,a4,80003bdc <fileread+0x7e>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    80003b86:	4709                	li	a4,2
    80003b88:	06e79e63          	bne	a5,a4,80003c04 <fileread+0xa6>
    ilock(f->ip);
    80003b8c:	6d08                	ld	a0,24(a0)
    80003b8e:	fffff097          	auipc	ra,0xfffff
    80003b92:	002080e7          	jalr	2(ra) # 80002b90 <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0) f->off += r;
    80003b96:	874a                	mv	a4,s2
    80003b98:	5094                	lw	a3,32(s1)
    80003b9a:	864e                	mv	a2,s3
    80003b9c:	4585                	li	a1,1
    80003b9e:	6c88                	ld	a0,24(s1)
    80003ba0:	fffff097          	auipc	ra,0xfffff
    80003ba4:	2a4080e7          	jalr	676(ra) # 80002e44 <readi>
    80003ba8:	892a                	mv	s2,a0
    80003baa:	00a05563          	blez	a0,80003bb4 <fileread+0x56>
    80003bae:	509c                	lw	a5,32(s1)
    80003bb0:	9fa9                	addw	a5,a5,a0
    80003bb2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003bb4:	6c88                	ld	a0,24(s1)
    80003bb6:	fffff097          	auipc	ra,0xfffff
    80003bba:	09c080e7          	jalr	156(ra) # 80002c52 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003bbe:	854a                	mv	a0,s2
    80003bc0:	70a2                	ld	ra,40(sp)
    80003bc2:	7402                	ld	s0,32(sp)
    80003bc4:	64e2                	ld	s1,24(sp)
    80003bc6:	6942                	ld	s2,16(sp)
    80003bc8:	69a2                	ld	s3,8(sp)
    80003bca:	6145                	addi	sp,sp,48
    80003bcc:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003bce:	6908                	ld	a0,16(a0)
    80003bd0:	00000097          	auipc	ra,0x0
    80003bd4:	3c6080e7          	jalr	966(ra) # 80003f96 <piperead>
    80003bd8:	892a                	mv	s2,a0
    80003bda:	b7d5                	j	80003bbe <fileread+0x60>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    80003bdc:	02451783          	lh	a5,36(a0)
    80003be0:	03079693          	slli	a3,a5,0x30
    80003be4:	92c1                	srli	a3,a3,0x30
    80003be6:	4725                	li	a4,9
    80003be8:	02d76863          	bltu	a4,a3,80003c18 <fileread+0xba>
    80003bec:	0792                	slli	a5,a5,0x4
    80003bee:	00016717          	auipc	a4,0x16
    80003bf2:	efa70713          	addi	a4,a4,-262 # 80019ae8 <devsw>
    80003bf6:	97ba                	add	a5,a5,a4
    80003bf8:	639c                	ld	a5,0(a5)
    80003bfa:	c38d                	beqz	a5,80003c1c <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003bfc:	4505                	li	a0,1
    80003bfe:	9782                	jalr	a5
    80003c00:	892a                	mv	s2,a0
    80003c02:	bf75                	j	80003bbe <fileread+0x60>
    panic("fileread");
    80003c04:	00006517          	auipc	a0,0x6
    80003c08:	a8450513          	addi	a0,a0,-1404 # 80009688 <syscalls+0x278>
    80003c0c:	00003097          	auipc	ra,0x3
    80003c10:	dd2080e7          	jalr	-558(ra) # 800069de <panic>
  if (f->readable == 0) return -1;
    80003c14:	597d                	li	s2,-1
    80003c16:	b765                	j	80003bbe <fileread+0x60>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    80003c18:	597d                	li	s2,-1
    80003c1a:	b755                	j	80003bbe <fileread+0x60>
    80003c1c:	597d                	li	s2,-1
    80003c1e:	b745                	j	80003bbe <fileread+0x60>

0000000080003c20 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int filewrite(struct file *f, uint64 addr, int n) {
    80003c20:	715d                	addi	sp,sp,-80
    80003c22:	e486                	sd	ra,72(sp)
    80003c24:	e0a2                	sd	s0,64(sp)
    80003c26:	fc26                	sd	s1,56(sp)
    80003c28:	f84a                	sd	s2,48(sp)
    80003c2a:	f44e                	sd	s3,40(sp)
    80003c2c:	f052                	sd	s4,32(sp)
    80003c2e:	ec56                	sd	s5,24(sp)
    80003c30:	e85a                	sd	s6,16(sp)
    80003c32:	e45e                	sd	s7,8(sp)
    80003c34:	e062                	sd	s8,0(sp)
    80003c36:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if (f->writable == 0) return -1;
    80003c38:	00954783          	lbu	a5,9(a0)
    80003c3c:	10078663          	beqz	a5,80003d48 <filewrite+0x128>
    80003c40:	892a                	mv	s2,a0
    80003c42:	8b2e                	mv	s6,a1
    80003c44:	8a32                	mv	s4,a2

  if (f->type == FD_PIPE) {
    80003c46:	411c                	lw	a5,0(a0)
    80003c48:	4705                	li	a4,1
    80003c4a:	02e78263          	beq	a5,a4,80003c6e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80003c4e:	470d                	li	a4,3
    80003c50:	02e78663          	beq	a5,a4,80003c7c <filewrite+0x5c>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    80003c54:	4709                	li	a4,2
    80003c56:	0ee79163          	bne	a5,a4,80003d38 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    80003c5a:	0ac05d63          	blez	a2,80003d14 <filewrite+0xf4>
    int i = 0;
    80003c5e:	4981                	li	s3,0
    80003c60:	6b85                	lui	s7,0x1
    80003c62:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003c66:	6c05                	lui	s8,0x1
    80003c68:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003c6c:	a861                	j	80003d04 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003c6e:	6908                	ld	a0,16(a0)
    80003c70:	00000097          	auipc	ra,0x0
    80003c74:	22e080e7          	jalr	558(ra) # 80003e9e <pipewrite>
    80003c78:	8a2a                	mv	s4,a0
    80003c7a:	a045                	j	80003d1a <filewrite+0xfa>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    80003c7c:	02451783          	lh	a5,36(a0)
    80003c80:	03079693          	slli	a3,a5,0x30
    80003c84:	92c1                	srli	a3,a3,0x30
    80003c86:	4725                	li	a4,9
    80003c88:	0cd76263          	bltu	a4,a3,80003d4c <filewrite+0x12c>
    80003c8c:	0792                	slli	a5,a5,0x4
    80003c8e:	00016717          	auipc	a4,0x16
    80003c92:	e5a70713          	addi	a4,a4,-422 # 80019ae8 <devsw>
    80003c96:	97ba                	add	a5,a5,a4
    80003c98:	679c                	ld	a5,8(a5)
    80003c9a:	cbdd                	beqz	a5,80003d50 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003c9c:	4505                	li	a0,1
    80003c9e:	9782                	jalr	a5
    80003ca0:	8a2a                	mv	s4,a0
    80003ca2:	a8a5                	j	80003d1a <filewrite+0xfa>
    80003ca4:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if (n1 > max) n1 = max;

      begin_op();
    80003ca8:	00000097          	auipc	ra,0x0
    80003cac:	8b4080e7          	jalr	-1868(ra) # 8000355c <begin_op>
      ilock(f->ip);
    80003cb0:	01893503          	ld	a0,24(s2)
    80003cb4:	fffff097          	auipc	ra,0xfffff
    80003cb8:	edc080e7          	jalr	-292(ra) # 80002b90 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0) f->off += r;
    80003cbc:	8756                	mv	a4,s5
    80003cbe:	02092683          	lw	a3,32(s2)
    80003cc2:	01698633          	add	a2,s3,s6
    80003cc6:	4585                	li	a1,1
    80003cc8:	01893503          	ld	a0,24(s2)
    80003ccc:	fffff097          	auipc	ra,0xfffff
    80003cd0:	270080e7          	jalr	624(ra) # 80002f3c <writei>
    80003cd4:	84aa                	mv	s1,a0
    80003cd6:	00a05763          	blez	a0,80003ce4 <filewrite+0xc4>
    80003cda:	02092783          	lw	a5,32(s2)
    80003cde:	9fa9                	addw	a5,a5,a0
    80003ce0:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003ce4:	01893503          	ld	a0,24(s2)
    80003ce8:	fffff097          	auipc	ra,0xfffff
    80003cec:	f6a080e7          	jalr	-150(ra) # 80002c52 <iunlock>
      end_op();
    80003cf0:	00000097          	auipc	ra,0x0
    80003cf4:	8ea080e7          	jalr	-1814(ra) # 800035da <end_op>

      if (r != n1) {
    80003cf8:	009a9f63          	bne	s5,s1,80003d16 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003cfc:	013489bb          	addw	s3,s1,s3
    while (i < n) {
    80003d00:	0149db63          	bge	s3,s4,80003d16 <filewrite+0xf6>
      int n1 = n - i;
    80003d04:	413a04bb          	subw	s1,s4,s3
    80003d08:	0004879b          	sext.w	a5,s1
    80003d0c:	f8fbdce3          	bge	s7,a5,80003ca4 <filewrite+0x84>
    80003d10:	84e2                	mv	s1,s8
    80003d12:	bf49                	j	80003ca4 <filewrite+0x84>
    int i = 0;
    80003d14:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d16:	013a1f63          	bne	s4,s3,80003d34 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d1a:	8552                	mv	a0,s4
    80003d1c:	60a6                	ld	ra,72(sp)
    80003d1e:	6406                	ld	s0,64(sp)
    80003d20:	74e2                	ld	s1,56(sp)
    80003d22:	7942                	ld	s2,48(sp)
    80003d24:	79a2                	ld	s3,40(sp)
    80003d26:	7a02                	ld	s4,32(sp)
    80003d28:	6ae2                	ld	s5,24(sp)
    80003d2a:	6b42                	ld	s6,16(sp)
    80003d2c:	6ba2                	ld	s7,8(sp)
    80003d2e:	6c02                	ld	s8,0(sp)
    80003d30:	6161                	addi	sp,sp,80
    80003d32:	8082                	ret
    ret = (i == n ? n : -1);
    80003d34:	5a7d                	li	s4,-1
    80003d36:	b7d5                	j	80003d1a <filewrite+0xfa>
    panic("filewrite");
    80003d38:	00006517          	auipc	a0,0x6
    80003d3c:	96050513          	addi	a0,a0,-1696 # 80009698 <syscalls+0x288>
    80003d40:	00003097          	auipc	ra,0x3
    80003d44:	c9e080e7          	jalr	-866(ra) # 800069de <panic>
  if (f->writable == 0) return -1;
    80003d48:	5a7d                	li	s4,-1
    80003d4a:	bfc1                	j	80003d1a <filewrite+0xfa>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    80003d4c:	5a7d                	li	s4,-1
    80003d4e:	b7f1                	j	80003d1a <filewrite+0xfa>
    80003d50:	5a7d                	li	s4,-1
    80003d52:	b7e1                	j	80003d1a <filewrite+0xfa>

0000000080003d54 <pipealloc>:
  uint nwrite;    // number of bytes written
  int readopen;   // read fd is still open
  int writeopen;  // write fd is still open
};

int pipealloc(struct file **f0, struct file **f1) {
    80003d54:	7179                	addi	sp,sp,-48
    80003d56:	f406                	sd	ra,40(sp)
    80003d58:	f022                	sd	s0,32(sp)
    80003d5a:	ec26                	sd	s1,24(sp)
    80003d5c:	e84a                	sd	s2,16(sp)
    80003d5e:	e44e                	sd	s3,8(sp)
    80003d60:	e052                	sd	s4,0(sp)
    80003d62:	1800                	addi	s0,sp,48
    80003d64:	84aa                	mv	s1,a0
    80003d66:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d68:	0005b023          	sd	zero,0(a1)
    80003d6c:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0) goto bad;
    80003d70:	00000097          	auipc	ra,0x0
    80003d74:	bf8080e7          	jalr	-1032(ra) # 80003968 <filealloc>
    80003d78:	e088                	sd	a0,0(s1)
    80003d7a:	c551                	beqz	a0,80003e06 <pipealloc+0xb2>
    80003d7c:	00000097          	auipc	ra,0x0
    80003d80:	bec080e7          	jalr	-1044(ra) # 80003968 <filealloc>
    80003d84:	00aa3023          	sd	a0,0(s4)
    80003d88:	c92d                	beqz	a0,80003dfa <pipealloc+0xa6>
  if ((pi = (struct pipe *)kalloc()) == 0) goto bad;
    80003d8a:	ffffc097          	auipc	ra,0xffffc
    80003d8e:	390080e7          	jalr	912(ra) # 8000011a <kalloc>
    80003d92:	892a                	mv	s2,a0
    80003d94:	c125                	beqz	a0,80003df4 <pipealloc+0xa0>
  pi->readopen = 1;
    80003d96:	4985                	li	s3,1
    80003d98:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d9c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003da0:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003da4:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003da8:	00006597          	auipc	a1,0x6
    80003dac:	90058593          	addi	a1,a1,-1792 # 800096a8 <syscalls+0x298>
    80003db0:	00003097          	auipc	ra,0x3
    80003db4:	0d6080e7          	jalr	214(ra) # 80006e86 <initlock>
  (*f0)->type = FD_PIPE;
    80003db8:	609c                	ld	a5,0(s1)
    80003dba:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003dbe:	609c                	ld	a5,0(s1)
    80003dc0:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003dc4:	609c                	ld	a5,0(s1)
    80003dc6:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003dca:	609c                	ld	a5,0(s1)
    80003dcc:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003dd0:	000a3783          	ld	a5,0(s4)
    80003dd4:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003dd8:	000a3783          	ld	a5,0(s4)
    80003ddc:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003de0:	000a3783          	ld	a5,0(s4)
    80003de4:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003de8:	000a3783          	ld	a5,0(s4)
    80003dec:	0127b823          	sd	s2,16(a5)
  return 0;
    80003df0:	4501                	li	a0,0
    80003df2:	a025                	j	80003e1a <pipealloc+0xc6>

bad:
  if (pi) kfree((char *)pi);
  if (*f0) fileclose(*f0);
    80003df4:	6088                	ld	a0,0(s1)
    80003df6:	e501                	bnez	a0,80003dfe <pipealloc+0xaa>
    80003df8:	a039                	j	80003e06 <pipealloc+0xb2>
    80003dfa:	6088                	ld	a0,0(s1)
    80003dfc:	c51d                	beqz	a0,80003e2a <pipealloc+0xd6>
    80003dfe:	00000097          	auipc	ra,0x0
    80003e02:	c26080e7          	jalr	-986(ra) # 80003a24 <fileclose>
  if (*f1) fileclose(*f1);
    80003e06:	000a3783          	ld	a5,0(s4)
  return -1;
    80003e0a:	557d                	li	a0,-1
  if (*f1) fileclose(*f1);
    80003e0c:	c799                	beqz	a5,80003e1a <pipealloc+0xc6>
    80003e0e:	853e                	mv	a0,a5
    80003e10:	00000097          	auipc	ra,0x0
    80003e14:	c14080e7          	jalr	-1004(ra) # 80003a24 <fileclose>
  return -1;
    80003e18:	557d                	li	a0,-1
}
    80003e1a:	70a2                	ld	ra,40(sp)
    80003e1c:	7402                	ld	s0,32(sp)
    80003e1e:	64e2                	ld	s1,24(sp)
    80003e20:	6942                	ld	s2,16(sp)
    80003e22:	69a2                	ld	s3,8(sp)
    80003e24:	6a02                	ld	s4,0(sp)
    80003e26:	6145                	addi	sp,sp,48
    80003e28:	8082                	ret
  return -1;
    80003e2a:	557d                	li	a0,-1
    80003e2c:	b7fd                	j	80003e1a <pipealloc+0xc6>

0000000080003e2e <pipeclose>:

void pipeclose(struct pipe *pi, int writable) {
    80003e2e:	1101                	addi	sp,sp,-32
    80003e30:	ec06                	sd	ra,24(sp)
    80003e32:	e822                	sd	s0,16(sp)
    80003e34:	e426                	sd	s1,8(sp)
    80003e36:	e04a                	sd	s2,0(sp)
    80003e38:	1000                	addi	s0,sp,32
    80003e3a:	84aa                	mv	s1,a0
    80003e3c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e3e:	00003097          	auipc	ra,0x3
    80003e42:	0d8080e7          	jalr	216(ra) # 80006f16 <acquire>
  if (writable) {
    80003e46:	02090d63          	beqz	s2,80003e80 <pipeclose+0x52>
    pi->writeopen = 0;
    80003e4a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e4e:	21848513          	addi	a0,s1,536
    80003e52:	ffffd097          	auipc	ra,0xffffd
    80003e56:	7aa080e7          	jalr	1962(ra) # 800015fc <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    80003e5a:	2204b783          	ld	a5,544(s1)
    80003e5e:	eb95                	bnez	a5,80003e92 <pipeclose+0x64>
    release(&pi->lock);
    80003e60:	8526                	mv	a0,s1
    80003e62:	00003097          	auipc	ra,0x3
    80003e66:	168080e7          	jalr	360(ra) # 80006fca <release>
    kfree((char *)pi);
    80003e6a:	8526                	mv	a0,s1
    80003e6c:	ffffc097          	auipc	ra,0xffffc
    80003e70:	1b0080e7          	jalr	432(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e74:	60e2                	ld	ra,24(sp)
    80003e76:	6442                	ld	s0,16(sp)
    80003e78:	64a2                	ld	s1,8(sp)
    80003e7a:	6902                	ld	s2,0(sp)
    80003e7c:	6105                	addi	sp,sp,32
    80003e7e:	8082                	ret
    pi->readopen = 0;
    80003e80:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e84:	21c48513          	addi	a0,s1,540
    80003e88:	ffffd097          	auipc	ra,0xffffd
    80003e8c:	774080e7          	jalr	1908(ra) # 800015fc <wakeup>
    80003e90:	b7e9                	j	80003e5a <pipeclose+0x2c>
    release(&pi->lock);
    80003e92:	8526                	mv	a0,s1
    80003e94:	00003097          	auipc	ra,0x3
    80003e98:	136080e7          	jalr	310(ra) # 80006fca <release>
}
    80003e9c:	bfe1                	j	80003e74 <pipeclose+0x46>

0000000080003e9e <pipewrite>:

int pipewrite(struct pipe *pi, uint64 addr, int n) {
    80003e9e:	711d                	addi	sp,sp,-96
    80003ea0:	ec86                	sd	ra,88(sp)
    80003ea2:	e8a2                	sd	s0,80(sp)
    80003ea4:	e4a6                	sd	s1,72(sp)
    80003ea6:	e0ca                	sd	s2,64(sp)
    80003ea8:	fc4e                	sd	s3,56(sp)
    80003eaa:	f852                	sd	s4,48(sp)
    80003eac:	f456                	sd	s5,40(sp)
    80003eae:	f05a                	sd	s6,32(sp)
    80003eb0:	ec5e                	sd	s7,24(sp)
    80003eb2:	e862                	sd	s8,16(sp)
    80003eb4:	1080                	addi	s0,sp,96
    80003eb6:	84aa                	mv	s1,a0
    80003eb8:	8aae                	mv	s5,a1
    80003eba:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ebc:	ffffd097          	auipc	ra,0xffffd
    80003ec0:	030080e7          	jalr	48(ra) # 80000eec <myproc>
    80003ec4:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003ec6:	8526                	mv	a0,s1
    80003ec8:	00003097          	auipc	ra,0x3
    80003ecc:	04e080e7          	jalr	78(ra) # 80006f16 <acquire>
  while (i < n) {
    80003ed0:	0b405663          	blez	s4,80003f7c <pipewrite+0xde>
  int i = 0;
    80003ed4:	4901                	li	s2,0
    if (pi->nwrite == pi->nread + PIPESIZE) {  // DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1) break;
    80003ed6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003ed8:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003edc:	21c48b93          	addi	s7,s1,540
    80003ee0:	a089                	j	80003f22 <pipewrite+0x84>
      release(&pi->lock);
    80003ee2:	8526                	mv	a0,s1
    80003ee4:	00003097          	auipc	ra,0x3
    80003ee8:	0e6080e7          	jalr	230(ra) # 80006fca <release>
      return -1;
    80003eec:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003eee:	854a                	mv	a0,s2
    80003ef0:	60e6                	ld	ra,88(sp)
    80003ef2:	6446                	ld	s0,80(sp)
    80003ef4:	64a6                	ld	s1,72(sp)
    80003ef6:	6906                	ld	s2,64(sp)
    80003ef8:	79e2                	ld	s3,56(sp)
    80003efa:	7a42                	ld	s4,48(sp)
    80003efc:	7aa2                	ld	s5,40(sp)
    80003efe:	7b02                	ld	s6,32(sp)
    80003f00:	6be2                	ld	s7,24(sp)
    80003f02:	6c42                	ld	s8,16(sp)
    80003f04:	6125                	addi	sp,sp,96
    80003f06:	8082                	ret
      wakeup(&pi->nread);
    80003f08:	8562                	mv	a0,s8
    80003f0a:	ffffd097          	auipc	ra,0xffffd
    80003f0e:	6f2080e7          	jalr	1778(ra) # 800015fc <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f12:	85a6                	mv	a1,s1
    80003f14:	855e                	mv	a0,s7
    80003f16:	ffffd097          	auipc	ra,0xffffd
    80003f1a:	682080e7          	jalr	1666(ra) # 80001598 <sleep>
  while (i < n) {
    80003f1e:	07495063          	bge	s2,s4,80003f7e <pipewrite+0xe0>
    if (pi->readopen == 0 || killed(pr)) {
    80003f22:	2204a783          	lw	a5,544(s1)
    80003f26:	dfd5                	beqz	a5,80003ee2 <pipewrite+0x44>
    80003f28:	854e                	mv	a0,s3
    80003f2a:	ffffe097          	auipc	ra,0xffffe
    80003f2e:	916080e7          	jalr	-1770(ra) # 80001840 <killed>
    80003f32:	f945                	bnez	a0,80003ee2 <pipewrite+0x44>
    if (pi->nwrite == pi->nread + PIPESIZE) {  // DOC: pipewrite-full
    80003f34:	2184a783          	lw	a5,536(s1)
    80003f38:	21c4a703          	lw	a4,540(s1)
    80003f3c:	2007879b          	addiw	a5,a5,512
    80003f40:	fcf704e3          	beq	a4,a5,80003f08 <pipewrite+0x6a>
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1) break;
    80003f44:	4685                	li	a3,1
    80003f46:	01590633          	add	a2,s2,s5
    80003f4a:	faf40593          	addi	a1,s0,-81
    80003f4e:	0509b503          	ld	a0,80(s3)
    80003f52:	ffffd097          	auipc	ra,0xffffd
    80003f56:	ce6080e7          	jalr	-794(ra) # 80000c38 <copyin>
    80003f5a:	03650263          	beq	a0,s6,80003f7e <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f5e:	21c4a783          	lw	a5,540(s1)
    80003f62:	0017871b          	addiw	a4,a5,1
    80003f66:	20e4ae23          	sw	a4,540(s1)
    80003f6a:	1ff7f793          	andi	a5,a5,511
    80003f6e:	97a6                	add	a5,a5,s1
    80003f70:	faf44703          	lbu	a4,-81(s0)
    80003f74:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f78:	2905                	addiw	s2,s2,1
    80003f7a:	b755                	j	80003f1e <pipewrite+0x80>
  int i = 0;
    80003f7c:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003f7e:	21848513          	addi	a0,s1,536
    80003f82:	ffffd097          	auipc	ra,0xffffd
    80003f86:	67a080e7          	jalr	1658(ra) # 800015fc <wakeup>
  release(&pi->lock);
    80003f8a:	8526                	mv	a0,s1
    80003f8c:	00003097          	auipc	ra,0x3
    80003f90:	03e080e7          	jalr	62(ra) # 80006fca <release>
  return i;
    80003f94:	bfa9                	j	80003eee <pipewrite+0x50>

0000000080003f96 <piperead>:

int piperead(struct pipe *pi, uint64 addr, int n) {
    80003f96:	715d                	addi	sp,sp,-80
    80003f98:	e486                	sd	ra,72(sp)
    80003f9a:	e0a2                	sd	s0,64(sp)
    80003f9c:	fc26                	sd	s1,56(sp)
    80003f9e:	f84a                	sd	s2,48(sp)
    80003fa0:	f44e                	sd	s3,40(sp)
    80003fa2:	f052                	sd	s4,32(sp)
    80003fa4:	ec56                	sd	s5,24(sp)
    80003fa6:	e85a                	sd	s6,16(sp)
    80003fa8:	0880                	addi	s0,sp,80
    80003faa:	84aa                	mv	s1,a0
    80003fac:	892e                	mv	s2,a1
    80003fae:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fb0:	ffffd097          	auipc	ra,0xffffd
    80003fb4:	f3c080e7          	jalr	-196(ra) # 80000eec <myproc>
    80003fb8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003fba:	8526                	mv	a0,s1
    80003fbc:	00003097          	auipc	ra,0x3
    80003fc0:	f5a080e7          	jalr	-166(ra) # 80006f16 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    80003fc4:	2184a703          	lw	a4,536(s1)
    80003fc8:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock);  // DOC: piperead-sleep
    80003fcc:	21848993          	addi	s3,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    80003fd0:	02f71763          	bne	a4,a5,80003ffe <piperead+0x68>
    80003fd4:	2244a783          	lw	a5,548(s1)
    80003fd8:	c39d                	beqz	a5,80003ffe <piperead+0x68>
    if (killed(pr)) {
    80003fda:	8552                	mv	a0,s4
    80003fdc:	ffffe097          	auipc	ra,0xffffe
    80003fe0:	864080e7          	jalr	-1948(ra) # 80001840 <killed>
    80003fe4:	e949                	bnez	a0,80004076 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock);  // DOC: piperead-sleep
    80003fe6:	85a6                	mv	a1,s1
    80003fe8:	854e                	mv	a0,s3
    80003fea:	ffffd097          	auipc	ra,0xffffd
    80003fee:	5ae080e7          	jalr	1454(ra) # 80001598 <sleep>
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    80003ff2:	2184a703          	lw	a4,536(s1)
    80003ff6:	21c4a783          	lw	a5,540(s1)
    80003ffa:	fcf70de3          	beq	a4,a5,80003fd4 <piperead+0x3e>
  }
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    80003ffe:	4981                	li	s3,0
    if (pi->nread == pi->nwrite) break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) break;
    80004000:	5b7d                	li	s6,-1
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    80004002:	05505463          	blez	s5,8000404a <piperead+0xb4>
    if (pi->nread == pi->nwrite) break;
    80004006:	2184a783          	lw	a5,536(s1)
    8000400a:	21c4a703          	lw	a4,540(s1)
    8000400e:	02f70e63          	beq	a4,a5,8000404a <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004012:	0017871b          	addiw	a4,a5,1
    80004016:	20e4ac23          	sw	a4,536(s1)
    8000401a:	1ff7f793          	andi	a5,a5,511
    8000401e:	97a6                	add	a5,a5,s1
    80004020:	0187c783          	lbu	a5,24(a5)
    80004024:	faf40fa3          	sb	a5,-65(s0)
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) break;
    80004028:	4685                	li	a3,1
    8000402a:	fbf40613          	addi	a2,s0,-65
    8000402e:	85ca                	mv	a1,s2
    80004030:	050a3503          	ld	a0,80(s4)
    80004034:	ffffd097          	auipc	ra,0xffffd
    80004038:	b44080e7          	jalr	-1212(ra) # 80000b78 <copyout>
    8000403c:	01650763          	beq	a0,s6,8000404a <piperead+0xb4>
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    80004040:	2985                	addiw	s3,s3,1
    80004042:	0905                	addi	s2,s2,1
    80004044:	fd3a91e3          	bne	s5,s3,80004006 <piperead+0x70>
    80004048:	89d6                	mv	s3,s5
  }
  wakeup(&pi->nwrite);  // DOC: piperead-wakeup
    8000404a:	21c48513          	addi	a0,s1,540
    8000404e:	ffffd097          	auipc	ra,0xffffd
    80004052:	5ae080e7          	jalr	1454(ra) # 800015fc <wakeup>
  release(&pi->lock);
    80004056:	8526                	mv	a0,s1
    80004058:	00003097          	auipc	ra,0x3
    8000405c:	f72080e7          	jalr	-142(ra) # 80006fca <release>
  return i;
}
    80004060:	854e                	mv	a0,s3
    80004062:	60a6                	ld	ra,72(sp)
    80004064:	6406                	ld	s0,64(sp)
    80004066:	74e2                	ld	s1,56(sp)
    80004068:	7942                	ld	s2,48(sp)
    8000406a:	79a2                	ld	s3,40(sp)
    8000406c:	7a02                	ld	s4,32(sp)
    8000406e:	6ae2                	ld	s5,24(sp)
    80004070:	6b42                	ld	s6,16(sp)
    80004072:	6161                	addi	sp,sp,80
    80004074:	8082                	ret
      release(&pi->lock);
    80004076:	8526                	mv	a0,s1
    80004078:	00003097          	auipc	ra,0x3
    8000407c:	f52080e7          	jalr	-174(ra) # 80006fca <release>
      return -1;
    80004080:	59fd                	li	s3,-1
    80004082:	bff9                	j	80004060 <piperead+0xca>

0000000080004084 <flags2perm>:
#include "riscv.h"
#include "types.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags) {
    80004084:	1141                	addi	sp,sp,-16
    80004086:	e422                	sd	s0,8(sp)
    80004088:	0800                	addi	s0,sp,16
    8000408a:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1) perm = PTE_X;
    8000408c:	8905                	andi	a0,a0,1
    8000408e:	050e                	slli	a0,a0,0x3
  if (flags & 0x2) perm |= PTE_W;
    80004090:	8b89                	andi	a5,a5,2
    80004092:	c399                	beqz	a5,80004098 <flags2perm+0x14>
    80004094:	00456513          	ori	a0,a0,4
  return perm;
}
    80004098:	6422                	ld	s0,8(sp)
    8000409a:	0141                	addi	sp,sp,16
    8000409c:	8082                	ret

000000008000409e <exec>:

int exec(char *path, char **argv) {
    8000409e:	de010113          	addi	sp,sp,-544
    800040a2:	20113c23          	sd	ra,536(sp)
    800040a6:	20813823          	sd	s0,528(sp)
    800040aa:	20913423          	sd	s1,520(sp)
    800040ae:	21213023          	sd	s2,512(sp)
    800040b2:	ffce                	sd	s3,504(sp)
    800040b4:	fbd2                	sd	s4,496(sp)
    800040b6:	f7d6                	sd	s5,488(sp)
    800040b8:	f3da                	sd	s6,480(sp)
    800040ba:	efde                	sd	s7,472(sp)
    800040bc:	ebe2                	sd	s8,464(sp)
    800040be:	e7e6                	sd	s9,456(sp)
    800040c0:	e3ea                	sd	s10,448(sp)
    800040c2:	ff6e                	sd	s11,440(sp)
    800040c4:	1400                	addi	s0,sp,544
    800040c6:	892a                	mv	s2,a0
    800040c8:	dea43423          	sd	a0,-536(s0)
    800040cc:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040d0:	ffffd097          	auipc	ra,0xffffd
    800040d4:	e1c080e7          	jalr	-484(ra) # 80000eec <myproc>
    800040d8:	84aa                	mv	s1,a0

  begin_op();
    800040da:	fffff097          	auipc	ra,0xfffff
    800040de:	482080e7          	jalr	1154(ra) # 8000355c <begin_op>

  if ((ip = namei(path)) == 0) {
    800040e2:	854a                	mv	a0,s2
    800040e4:	fffff097          	auipc	ra,0xfffff
    800040e8:	258080e7          	jalr	600(ra) # 8000333c <namei>
    800040ec:	c93d                	beqz	a0,80004162 <exec+0xc4>
    800040ee:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800040f0:	fffff097          	auipc	ra,0xfffff
    800040f4:	aa0080e7          	jalr	-1376(ra) # 80002b90 <ilock>

  // Check ELF header
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf)) goto bad;
    800040f8:	04000713          	li	a4,64
    800040fc:	4681                	li	a3,0
    800040fe:	e5040613          	addi	a2,s0,-432
    80004102:	4581                	li	a1,0
    80004104:	8556                	mv	a0,s5
    80004106:	fffff097          	auipc	ra,0xfffff
    8000410a:	d3e080e7          	jalr	-706(ra) # 80002e44 <readi>
    8000410e:	04000793          	li	a5,64
    80004112:	00f51a63          	bne	a0,a5,80004126 <exec+0x88>

  if (elf.magic != ELF_MAGIC) goto bad;
    80004116:	e5042703          	lw	a4,-432(s0)
    8000411a:	464c47b7          	lui	a5,0x464c4
    8000411e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004122:	04f70663          	beq	a4,a5,8000416e <exec+0xd0>
  return argc;  // this ends up in a0, the first argument to main(argc, argv)

bad:
  if (pagetable) proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    80004126:	8556                	mv	a0,s5
    80004128:	fffff097          	auipc	ra,0xfffff
    8000412c:	cca080e7          	jalr	-822(ra) # 80002df2 <iunlockput>
    end_op();
    80004130:	fffff097          	auipc	ra,0xfffff
    80004134:	4aa080e7          	jalr	1194(ra) # 800035da <end_op>
  }
  return -1;
    80004138:	557d                	li	a0,-1
}
    8000413a:	21813083          	ld	ra,536(sp)
    8000413e:	21013403          	ld	s0,528(sp)
    80004142:	20813483          	ld	s1,520(sp)
    80004146:	20013903          	ld	s2,512(sp)
    8000414a:	79fe                	ld	s3,504(sp)
    8000414c:	7a5e                	ld	s4,496(sp)
    8000414e:	7abe                	ld	s5,488(sp)
    80004150:	7b1e                	ld	s6,480(sp)
    80004152:	6bfe                	ld	s7,472(sp)
    80004154:	6c5e                	ld	s8,464(sp)
    80004156:	6cbe                	ld	s9,456(sp)
    80004158:	6d1e                	ld	s10,448(sp)
    8000415a:	7dfa                	ld	s11,440(sp)
    8000415c:	22010113          	addi	sp,sp,544
    80004160:	8082                	ret
    end_op();
    80004162:	fffff097          	auipc	ra,0xfffff
    80004166:	478080e7          	jalr	1144(ra) # 800035da <end_op>
    return -1;
    8000416a:	557d                	li	a0,-1
    8000416c:	b7f9                	j	8000413a <exec+0x9c>
  if ((pagetable = proc_pagetable(p)) == 0) goto bad;
    8000416e:	8526                	mv	a0,s1
    80004170:	ffffd097          	auipc	ra,0xffffd
    80004174:	e44080e7          	jalr	-444(ra) # 80000fb4 <proc_pagetable>
    80004178:	8b2a                	mv	s6,a0
    8000417a:	d555                	beqz	a0,80004126 <exec+0x88>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    8000417c:	e7042783          	lw	a5,-400(s0)
    80004180:	e8845703          	lhu	a4,-376(s0)
    80004184:	c735                	beqz	a4,800041f0 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004186:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004188:	e0043423          	sd	zero,-504(s0)
    if (ph.vaddr % PGSIZE != 0) goto bad;
    8000418c:	6a05                	lui	s4,0x1
    8000418e:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004192:	dee43023          	sd	a4,-544(s0)
static int loadseg(pagetable_t pagetable, uint64 va, struct inode *ip,
                   uint offset, uint sz) {
  uint i, n;
  uint64 pa;

  for (i = 0; i < sz; i += PGSIZE) {
    80004196:	6d85                	lui	s11,0x1
    80004198:	7d7d                	lui	s10,0xfffff
    8000419a:	ac3d                	j	800043d8 <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if (pa == 0) panic("loadseg: address should exist");
    8000419c:	00005517          	auipc	a0,0x5
    800041a0:	51450513          	addi	a0,a0,1300 # 800096b0 <syscalls+0x2a0>
    800041a4:	00003097          	auipc	ra,0x3
    800041a8:	83a080e7          	jalr	-1990(ra) # 800069de <panic>
    if (sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n) return -1;
    800041ac:	874a                	mv	a4,s2
    800041ae:	009c86bb          	addw	a3,s9,s1
    800041b2:	4581                	li	a1,0
    800041b4:	8556                	mv	a0,s5
    800041b6:	fffff097          	auipc	ra,0xfffff
    800041ba:	c8e080e7          	jalr	-882(ra) # 80002e44 <readi>
    800041be:	2501                	sext.w	a0,a0
    800041c0:	1aa91963          	bne	s2,a0,80004372 <exec+0x2d4>
  for (i = 0; i < sz; i += PGSIZE) {
    800041c4:	009d84bb          	addw	s1,s11,s1
    800041c8:	013d09bb          	addw	s3,s10,s3
    800041cc:	1f74f663          	bgeu	s1,s7,800043b8 <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    800041d0:	02049593          	slli	a1,s1,0x20
    800041d4:	9181                	srli	a1,a1,0x20
    800041d6:	95e2                	add	a1,a1,s8
    800041d8:	855a                	mv	a0,s6
    800041da:	ffffc097          	auipc	ra,0xffffc
    800041de:	33a080e7          	jalr	826(ra) # 80000514 <walkaddr>
    800041e2:	862a                	mv	a2,a0
    if (pa == 0) panic("loadseg: address should exist");
    800041e4:	dd45                	beqz	a0,8000419c <exec+0xfe>
      n = PGSIZE;
    800041e6:	8952                	mv	s2,s4
    if (sz - i < PGSIZE)
    800041e8:	fd49f2e3          	bgeu	s3,s4,800041ac <exec+0x10e>
      n = sz - i;
    800041ec:	894e                	mv	s2,s3
    800041ee:	bf7d                	j	800041ac <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041f0:	4901                	li	s2,0
  iunlockput(ip);
    800041f2:	8556                	mv	a0,s5
    800041f4:	fffff097          	auipc	ra,0xfffff
    800041f8:	bfe080e7          	jalr	-1026(ra) # 80002df2 <iunlockput>
  end_op();
    800041fc:	fffff097          	auipc	ra,0xfffff
    80004200:	3de080e7          	jalr	990(ra) # 800035da <end_op>
  p = myproc();
    80004204:	ffffd097          	auipc	ra,0xffffd
    80004208:	ce8080e7          	jalr	-792(ra) # 80000eec <myproc>
    8000420c:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    8000420e:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004212:	6785                	lui	a5,0x1
    80004214:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004216:	97ca                	add	a5,a5,s2
    80004218:	777d                	lui	a4,0xfffff
    8000421a:	8ff9                	and	a5,a5,a4
    8000421c:	def43c23          	sd	a5,-520(s0)
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE, PTE_W)) == 0) goto bad;
    80004220:	4691                	li	a3,4
    80004222:	6609                	lui	a2,0x2
    80004224:	963e                	add	a2,a2,a5
    80004226:	85be                	mv	a1,a5
    80004228:	855a                	mv	a0,s6
    8000422a:	ffffc097          	auipc	ra,0xffffc
    8000422e:	6f2080e7          	jalr	1778(ra) # 8000091c <uvmalloc>
    80004232:	8c2a                	mv	s8,a0
  ip = 0;
    80004234:	4a81                	li	s5,0
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE, PTE_W)) == 0) goto bad;
    80004236:	12050e63          	beqz	a0,80004372 <exec+0x2d4>
  uvmclear(pagetable, sz - 2 * PGSIZE);
    8000423a:	75f9                	lui	a1,0xffffe
    8000423c:	95aa                	add	a1,a1,a0
    8000423e:	855a                	mv	a0,s6
    80004240:	ffffd097          	auipc	ra,0xffffd
    80004244:	906080e7          	jalr	-1786(ra) # 80000b46 <uvmclear>
  stackbase = sp - PGSIZE;
    80004248:	7afd                	lui	s5,0xfffff
    8000424a:	9ae2                	add	s5,s5,s8
  for (argc = 0; argv[argc]; argc++) {
    8000424c:	df043783          	ld	a5,-528(s0)
    80004250:	6388                	ld	a0,0(a5)
    80004252:	c925                	beqz	a0,800042c2 <exec+0x224>
    80004254:	e9040993          	addi	s3,s0,-368
    80004258:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000425c:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++) {
    8000425e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004260:	ffffc097          	auipc	ra,0xffffc
    80004264:	096080e7          	jalr	150(ra) # 800002f6 <strlen>
    80004268:	0015079b          	addiw	a5,a0,1
    8000426c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16;  // riscv sp must be 16-byte aligned
    80004270:	ff07f913          	andi	s2,a5,-16
    if (sp < stackbase) goto bad;
    80004274:	13596663          	bltu	s2,s5,800043a0 <exec+0x302>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004278:	df043d83          	ld	s11,-528(s0)
    8000427c:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004280:	8552                	mv	a0,s4
    80004282:	ffffc097          	auipc	ra,0xffffc
    80004286:	074080e7          	jalr	116(ra) # 800002f6 <strlen>
    8000428a:	0015069b          	addiw	a3,a0,1
    8000428e:	8652                	mv	a2,s4
    80004290:	85ca                	mv	a1,s2
    80004292:	855a                	mv	a0,s6
    80004294:	ffffd097          	auipc	ra,0xffffd
    80004298:	8e4080e7          	jalr	-1820(ra) # 80000b78 <copyout>
    8000429c:	10054663          	bltz	a0,800043a8 <exec+0x30a>
    ustack[argc] = sp;
    800042a0:	0129b023          	sd	s2,0(s3)
  for (argc = 0; argv[argc]; argc++) {
    800042a4:	0485                	addi	s1,s1,1
    800042a6:	008d8793          	addi	a5,s11,8
    800042aa:	def43823          	sd	a5,-528(s0)
    800042ae:	008db503          	ld	a0,8(s11)
    800042b2:	c911                	beqz	a0,800042c6 <exec+0x228>
    if (argc >= MAXARG) goto bad;
    800042b4:	09a1                	addi	s3,s3,8
    800042b6:	fb3c95e3          	bne	s9,s3,80004260 <exec+0x1c2>
  sz = sz1;
    800042ba:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042be:	4a81                	li	s5,0
    800042c0:	a84d                	j	80004372 <exec+0x2d4>
  sp = sz;
    800042c2:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++) {
    800042c4:	4481                	li	s1,0
  ustack[argc] = 0;
    800042c6:	00349793          	slli	a5,s1,0x3
    800042ca:	f9078793          	addi	a5,a5,-112
    800042ce:	97a2                	add	a5,a5,s0
    800042d0:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    800042d4:	00148693          	addi	a3,s1,1
    800042d8:	068e                	slli	a3,a3,0x3
    800042da:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800042de:	ff097913          	andi	s2,s2,-16
  if (sp < stackbase) goto bad;
    800042e2:	01597663          	bgeu	s2,s5,800042ee <exec+0x250>
  sz = sz1;
    800042e6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042ea:	4a81                	li	s5,0
    800042ec:	a059                	j	80004372 <exec+0x2d4>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    800042ee:	e9040613          	addi	a2,s0,-368
    800042f2:	85ca                	mv	a1,s2
    800042f4:	855a                	mv	a0,s6
    800042f6:	ffffd097          	auipc	ra,0xffffd
    800042fa:	882080e7          	jalr	-1918(ra) # 80000b78 <copyout>
    800042fe:	0a054963          	bltz	a0,800043b0 <exec+0x312>
  p->trapframe->a1 = sp;
    80004302:	058bb783          	ld	a5,88(s7)
    80004306:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    8000430a:	de843783          	ld	a5,-536(s0)
    8000430e:	0007c703          	lbu	a4,0(a5)
    80004312:	cf11                	beqz	a4,8000432e <exec+0x290>
    80004314:	0785                	addi	a5,a5,1
    if (*s == '/') last = s + 1;
    80004316:	02f00693          	li	a3,47
    8000431a:	a039                	j	80004328 <exec+0x28a>
    8000431c:	def43423          	sd	a5,-536(s0)
  for (last = s = path; *s; s++)
    80004320:	0785                	addi	a5,a5,1
    80004322:	fff7c703          	lbu	a4,-1(a5)
    80004326:	c701                	beqz	a4,8000432e <exec+0x290>
    if (*s == '/') last = s + 1;
    80004328:	fed71ce3          	bne	a4,a3,80004320 <exec+0x282>
    8000432c:	bfc5                	j	8000431c <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    8000432e:	4641                	li	a2,16
    80004330:	de843583          	ld	a1,-536(s0)
    80004334:	158b8513          	addi	a0,s7,344
    80004338:	ffffc097          	auipc	ra,0xffffc
    8000433c:	f8c080e7          	jalr	-116(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    80004340:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004344:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004348:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000434c:	058bb783          	ld	a5,88(s7)
    80004350:	e6843703          	ld	a4,-408(s0)
    80004354:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;          // initial stack pointer
    80004356:	058bb783          	ld	a5,88(s7)
    8000435a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000435e:	85ea                	mv	a1,s10
    80004360:	ffffd097          	auipc	ra,0xffffd
    80004364:	cf0080e7          	jalr	-784(ra) # 80001050 <proc_freepagetable>
  return argc;  // this ends up in a0, the first argument to main(argc, argv)
    80004368:	0004851b          	sext.w	a0,s1
    8000436c:	b3f9                	j	8000413a <exec+0x9c>
    8000436e:	df243c23          	sd	s2,-520(s0)
  if (pagetable) proc_freepagetable(pagetable, sz);
    80004372:	df843583          	ld	a1,-520(s0)
    80004376:	855a                	mv	a0,s6
    80004378:	ffffd097          	auipc	ra,0xffffd
    8000437c:	cd8080e7          	jalr	-808(ra) # 80001050 <proc_freepagetable>
  if (ip) {
    80004380:	da0a93e3          	bnez	s5,80004126 <exec+0x88>
  return -1;
    80004384:	557d                	li	a0,-1
    80004386:	bb55                	j	8000413a <exec+0x9c>
    80004388:	df243c23          	sd	s2,-520(s0)
    8000438c:	b7dd                	j	80004372 <exec+0x2d4>
    8000438e:	df243c23          	sd	s2,-520(s0)
    80004392:	b7c5                	j	80004372 <exec+0x2d4>
    80004394:	df243c23          	sd	s2,-520(s0)
    80004398:	bfe9                	j	80004372 <exec+0x2d4>
    8000439a:	df243c23          	sd	s2,-520(s0)
    8000439e:	bfd1                	j	80004372 <exec+0x2d4>
  sz = sz1;
    800043a0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043a4:	4a81                	li	s5,0
    800043a6:	b7f1                	j	80004372 <exec+0x2d4>
  sz = sz1;
    800043a8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043ac:	4a81                	li	s5,0
    800043ae:	b7d1                	j	80004372 <exec+0x2d4>
  sz = sz1;
    800043b0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043b4:	4a81                	li	s5,0
    800043b6:	bf75                	j	80004372 <exec+0x2d4>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    800043b8:	df843903          	ld	s2,-520(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800043bc:	e0843783          	ld	a5,-504(s0)
    800043c0:	0017869b          	addiw	a3,a5,1
    800043c4:	e0d43423          	sd	a3,-504(s0)
    800043c8:	e0043783          	ld	a5,-512(s0)
    800043cc:	0387879b          	addiw	a5,a5,56
    800043d0:	e8845703          	lhu	a4,-376(s0)
    800043d4:	e0e6dfe3          	bge	a3,a4,800041f2 <exec+0x154>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph)) goto bad;
    800043d8:	2781                	sext.w	a5,a5
    800043da:	e0f43023          	sd	a5,-512(s0)
    800043de:	03800713          	li	a4,56
    800043e2:	86be                	mv	a3,a5
    800043e4:	e1840613          	addi	a2,s0,-488
    800043e8:	4581                	li	a1,0
    800043ea:	8556                	mv	a0,s5
    800043ec:	fffff097          	auipc	ra,0xfffff
    800043f0:	a58080e7          	jalr	-1448(ra) # 80002e44 <readi>
    800043f4:	03800793          	li	a5,56
    800043f8:	f6f51be3          	bne	a0,a5,8000436e <exec+0x2d0>
    if (ph.type != ELF_PROG_LOAD) continue;
    800043fc:	e1842783          	lw	a5,-488(s0)
    80004400:	4705                	li	a4,1
    80004402:	fae79de3          	bne	a5,a4,800043bc <exec+0x31e>
    if (ph.memsz < ph.filesz) goto bad;
    80004406:	e4043483          	ld	s1,-448(s0)
    8000440a:	e3843783          	ld	a5,-456(s0)
    8000440e:	f6f4ede3          	bltu	s1,a5,80004388 <exec+0x2ea>
    if (ph.vaddr + ph.memsz < ph.vaddr) goto bad;
    80004412:	e2843783          	ld	a5,-472(s0)
    80004416:	94be                	add	s1,s1,a5
    80004418:	f6f4ebe3          	bltu	s1,a5,8000438e <exec+0x2f0>
    if (ph.vaddr % PGSIZE != 0) goto bad;
    8000441c:	de043703          	ld	a4,-544(s0)
    80004420:	8ff9                	and	a5,a5,a4
    80004422:	fbad                	bnez	a5,80004394 <exec+0x2f6>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    80004424:	e1c42503          	lw	a0,-484(s0)
    80004428:	00000097          	auipc	ra,0x0
    8000442c:	c5c080e7          	jalr	-932(ra) # 80004084 <flags2perm>
    80004430:	86aa                	mv	a3,a0
    80004432:	8626                	mv	a2,s1
    80004434:	85ca                	mv	a1,s2
    80004436:	855a                	mv	a0,s6
    80004438:	ffffc097          	auipc	ra,0xffffc
    8000443c:	4e4080e7          	jalr	1252(ra) # 8000091c <uvmalloc>
    80004440:	dea43c23          	sd	a0,-520(s0)
    80004444:	d939                	beqz	a0,8000439a <exec+0x2fc>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0) goto bad;
    80004446:	e2843c03          	ld	s8,-472(s0)
    8000444a:	e2042c83          	lw	s9,-480(s0)
    8000444e:	e3842b83          	lw	s7,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80004452:	f60b83e3          	beqz	s7,800043b8 <exec+0x31a>
    80004456:	89de                	mv	s3,s7
    80004458:	4481                	li	s1,0
    8000445a:	bb9d                	j	800041d0 <exec+0x132>

000000008000445c <argfd>:
#include "stat.h"
#include "types.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int argfd(int n, int *pfd, struct file **pf) {
    8000445c:	7179                	addi	sp,sp,-48
    8000445e:	f406                	sd	ra,40(sp)
    80004460:	f022                	sd	s0,32(sp)
    80004462:	ec26                	sd	s1,24(sp)
    80004464:	e84a                	sd	s2,16(sp)
    80004466:	1800                	addi	s0,sp,48
    80004468:	892e                	mv	s2,a1
    8000446a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000446c:	fdc40593          	addi	a1,s0,-36
    80004470:	ffffe097          	auipc	ra,0xffffe
    80004474:	ba8080e7          	jalr	-1112(ra) # 80002018 <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) return -1;
    80004478:	fdc42703          	lw	a4,-36(s0)
    8000447c:	47bd                	li	a5,15
    8000447e:	02e7eb63          	bltu	a5,a4,800044b4 <argfd+0x58>
    80004482:	ffffd097          	auipc	ra,0xffffd
    80004486:	a6a080e7          	jalr	-1430(ra) # 80000eec <myproc>
    8000448a:	fdc42703          	lw	a4,-36(s0)
    8000448e:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ff0bc6a>
    80004492:	078e                	slli	a5,a5,0x3
    80004494:	953e                	add	a0,a0,a5
    80004496:	611c                	ld	a5,0(a0)
    80004498:	c385                	beqz	a5,800044b8 <argfd+0x5c>
  if (pfd) *pfd = fd;
    8000449a:	00090463          	beqz	s2,800044a2 <argfd+0x46>
    8000449e:	00e92023          	sw	a4,0(s2)
  if (pf) *pf = f;
  return 0;
    800044a2:	4501                	li	a0,0
  if (pf) *pf = f;
    800044a4:	c091                	beqz	s1,800044a8 <argfd+0x4c>
    800044a6:	e09c                	sd	a5,0(s1)
}
    800044a8:	70a2                	ld	ra,40(sp)
    800044aa:	7402                	ld	s0,32(sp)
    800044ac:	64e2                	ld	s1,24(sp)
    800044ae:	6942                	ld	s2,16(sp)
    800044b0:	6145                	addi	sp,sp,48
    800044b2:	8082                	ret
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) return -1;
    800044b4:	557d                	li	a0,-1
    800044b6:	bfcd                	j	800044a8 <argfd+0x4c>
    800044b8:	557d                	li	a0,-1
    800044ba:	b7fd                	j	800044a8 <argfd+0x4c>

00000000800044bc <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int fdalloc(struct file *f) {
    800044bc:	1101                	addi	sp,sp,-32
    800044be:	ec06                	sd	ra,24(sp)
    800044c0:	e822                	sd	s0,16(sp)
    800044c2:	e426                	sd	s1,8(sp)
    800044c4:	1000                	addi	s0,sp,32
    800044c6:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044c8:	ffffd097          	auipc	ra,0xffffd
    800044cc:	a24080e7          	jalr	-1500(ra) # 80000eec <myproc>
    800044d0:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    800044d2:	0d050793          	addi	a5,a0,208
    800044d6:	4501                	li	a0,0
    800044d8:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    800044da:	6398                	ld	a4,0(a5)
    800044dc:	cb19                	beqz	a4,800044f2 <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++) {
    800044de:	2505                	addiw	a0,a0,1
    800044e0:	07a1                	addi	a5,a5,8
    800044e2:	fed51ce3          	bne	a0,a3,800044da <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044e6:	557d                	li	a0,-1
}
    800044e8:	60e2                	ld	ra,24(sp)
    800044ea:	6442                	ld	s0,16(sp)
    800044ec:	64a2                	ld	s1,8(sp)
    800044ee:	6105                	addi	sp,sp,32
    800044f0:	8082                	ret
      p->ofile[fd] = f;
    800044f2:	01a50793          	addi	a5,a0,26
    800044f6:	078e                	slli	a5,a5,0x3
    800044f8:	963e                	add	a2,a2,a5
    800044fa:	e204                	sd	s1,0(a2)
      return fd;
    800044fc:	b7f5                	j	800044e8 <fdalloc+0x2c>

00000000800044fe <create>:
  iunlockput(dp);
  end_op();
  return -1;
}

static struct inode *create(char *path, short type, short major, short minor) {
    800044fe:	715d                	addi	sp,sp,-80
    80004500:	e486                	sd	ra,72(sp)
    80004502:	e0a2                	sd	s0,64(sp)
    80004504:	fc26                	sd	s1,56(sp)
    80004506:	f84a                	sd	s2,48(sp)
    80004508:	f44e                	sd	s3,40(sp)
    8000450a:	f052                	sd	s4,32(sp)
    8000450c:	ec56                	sd	s5,24(sp)
    8000450e:	e85a                	sd	s6,16(sp)
    80004510:	0880                	addi	s0,sp,80
    80004512:	8b2e                	mv	s6,a1
    80004514:	89b2                	mv	s3,a2
    80004516:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0) return 0;
    80004518:	fb040593          	addi	a1,s0,-80
    8000451c:	fffff097          	auipc	ra,0xfffff
    80004520:	e3e080e7          	jalr	-450(ra) # 8000335a <nameiparent>
    80004524:	84aa                	mv	s1,a0
    80004526:	14050f63          	beqz	a0,80004684 <create+0x186>

  ilock(dp);
    8000452a:	ffffe097          	auipc	ra,0xffffe
    8000452e:	666080e7          	jalr	1638(ra) # 80002b90 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80004532:	4601                	li	a2,0
    80004534:	fb040593          	addi	a1,s0,-80
    80004538:	8526                	mv	a0,s1
    8000453a:	fffff097          	auipc	ra,0xfffff
    8000453e:	b3a080e7          	jalr	-1222(ra) # 80003074 <dirlookup>
    80004542:	8aaa                	mv	s5,a0
    80004544:	c931                	beqz	a0,80004598 <create+0x9a>
    iunlockput(dp);
    80004546:	8526                	mv	a0,s1
    80004548:	fffff097          	auipc	ra,0xfffff
    8000454c:	8aa080e7          	jalr	-1878(ra) # 80002df2 <iunlockput>
    ilock(ip);
    80004550:	8556                	mv	a0,s5
    80004552:	ffffe097          	auipc	ra,0xffffe
    80004556:	63e080e7          	jalr	1598(ra) # 80002b90 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000455a:	000b059b          	sext.w	a1,s6
    8000455e:	4789                	li	a5,2
    80004560:	02f59563          	bne	a1,a5,8000458a <create+0x8c>
    80004564:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ff0bc94>
    80004568:	37f9                	addiw	a5,a5,-2
    8000456a:	17c2                	slli	a5,a5,0x30
    8000456c:	93c1                	srli	a5,a5,0x30
    8000456e:	4705                	li	a4,1
    80004570:	00f76d63          	bltu	a4,a5,8000458a <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004574:	8556                	mv	a0,s5
    80004576:	60a6                	ld	ra,72(sp)
    80004578:	6406                	ld	s0,64(sp)
    8000457a:	74e2                	ld	s1,56(sp)
    8000457c:	7942                	ld	s2,48(sp)
    8000457e:	79a2                	ld	s3,40(sp)
    80004580:	7a02                	ld	s4,32(sp)
    80004582:	6ae2                	ld	s5,24(sp)
    80004584:	6b42                	ld	s6,16(sp)
    80004586:	6161                	addi	sp,sp,80
    80004588:	8082                	ret
    iunlockput(ip);
    8000458a:	8556                	mv	a0,s5
    8000458c:	fffff097          	auipc	ra,0xfffff
    80004590:	866080e7          	jalr	-1946(ra) # 80002df2 <iunlockput>
    return 0;
    80004594:	4a81                	li	s5,0
    80004596:	bff9                	j	80004574 <create+0x76>
  if ((ip = ialloc(dp->dev, type)) == 0) {
    80004598:	85da                	mv	a1,s6
    8000459a:	4088                	lw	a0,0(s1)
    8000459c:	ffffe097          	auipc	ra,0xffffe
    800045a0:	456080e7          	jalr	1110(ra) # 800029f2 <ialloc>
    800045a4:	8a2a                	mv	s4,a0
    800045a6:	c539                	beqz	a0,800045f4 <create+0xf6>
  ilock(ip);
    800045a8:	ffffe097          	auipc	ra,0xffffe
    800045ac:	5e8080e7          	jalr	1512(ra) # 80002b90 <ilock>
  ip->major = major;
    800045b0:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800045b4:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800045b8:	4905                	li	s2,1
    800045ba:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800045be:	8552                	mv	a0,s4
    800045c0:	ffffe097          	auipc	ra,0xffffe
    800045c4:	504080e7          	jalr	1284(ra) # 80002ac4 <iupdate>
  if (type == T_DIR) {  // Create . and .. entries.
    800045c8:	000b059b          	sext.w	a1,s6
    800045cc:	03258b63          	beq	a1,s2,80004602 <create+0x104>
  if (dirlink(dp, name, ip->inum) < 0) goto fail;
    800045d0:	004a2603          	lw	a2,4(s4)
    800045d4:	fb040593          	addi	a1,s0,-80
    800045d8:	8526                	mv	a0,s1
    800045da:	fffff097          	auipc	ra,0xfffff
    800045de:	cb0080e7          	jalr	-848(ra) # 8000328a <dirlink>
    800045e2:	06054f63          	bltz	a0,80004660 <create+0x162>
  iunlockput(dp);
    800045e6:	8526                	mv	a0,s1
    800045e8:	fffff097          	auipc	ra,0xfffff
    800045ec:	80a080e7          	jalr	-2038(ra) # 80002df2 <iunlockput>
  return ip;
    800045f0:	8ad2                	mv	s5,s4
    800045f2:	b749                	j	80004574 <create+0x76>
    iunlockput(dp);
    800045f4:	8526                	mv	a0,s1
    800045f6:	ffffe097          	auipc	ra,0xffffe
    800045fa:	7fc080e7          	jalr	2044(ra) # 80002df2 <iunlockput>
    return 0;
    800045fe:	8ad2                	mv	s5,s4
    80004600:	bf95                	j	80004574 <create+0x76>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004602:	004a2603          	lw	a2,4(s4)
    80004606:	00005597          	auipc	a1,0x5
    8000460a:	0ca58593          	addi	a1,a1,202 # 800096d0 <syscalls+0x2c0>
    8000460e:	8552                	mv	a0,s4
    80004610:	fffff097          	auipc	ra,0xfffff
    80004614:	c7a080e7          	jalr	-902(ra) # 8000328a <dirlink>
    80004618:	04054463          	bltz	a0,80004660 <create+0x162>
    8000461c:	40d0                	lw	a2,4(s1)
    8000461e:	00005597          	auipc	a1,0x5
    80004622:	0ba58593          	addi	a1,a1,186 # 800096d8 <syscalls+0x2c8>
    80004626:	8552                	mv	a0,s4
    80004628:	fffff097          	auipc	ra,0xfffff
    8000462c:	c62080e7          	jalr	-926(ra) # 8000328a <dirlink>
    80004630:	02054863          	bltz	a0,80004660 <create+0x162>
  if (dirlink(dp, name, ip->inum) < 0) goto fail;
    80004634:	004a2603          	lw	a2,4(s4)
    80004638:	fb040593          	addi	a1,s0,-80
    8000463c:	8526                	mv	a0,s1
    8000463e:	fffff097          	auipc	ra,0xfffff
    80004642:	c4c080e7          	jalr	-948(ra) # 8000328a <dirlink>
    80004646:	00054d63          	bltz	a0,80004660 <create+0x162>
    dp->nlink++;  // for ".."
    8000464a:	04a4d783          	lhu	a5,74(s1)
    8000464e:	2785                	addiw	a5,a5,1
    80004650:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004654:	8526                	mv	a0,s1
    80004656:	ffffe097          	auipc	ra,0xffffe
    8000465a:	46e080e7          	jalr	1134(ra) # 80002ac4 <iupdate>
    8000465e:	b761                	j	800045e6 <create+0xe8>
  ip->nlink = 0;
    80004660:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004664:	8552                	mv	a0,s4
    80004666:	ffffe097          	auipc	ra,0xffffe
    8000466a:	45e080e7          	jalr	1118(ra) # 80002ac4 <iupdate>
  iunlockput(ip);
    8000466e:	8552                	mv	a0,s4
    80004670:	ffffe097          	auipc	ra,0xffffe
    80004674:	782080e7          	jalr	1922(ra) # 80002df2 <iunlockput>
  iunlockput(dp);
    80004678:	8526                	mv	a0,s1
    8000467a:	ffffe097          	auipc	ra,0xffffe
    8000467e:	778080e7          	jalr	1912(ra) # 80002df2 <iunlockput>
  return 0;
    80004682:	bdcd                	j	80004574 <create+0x76>
  if ((dp = nameiparent(path, name)) == 0) return 0;
    80004684:	8aaa                	mv	s5,a0
    80004686:	b5fd                	j	80004574 <create+0x76>

0000000080004688 <sys_dup>:
uint64 sys_dup(void) {
    80004688:	7179                	addi	sp,sp,-48
    8000468a:	f406                	sd	ra,40(sp)
    8000468c:	f022                	sd	s0,32(sp)
    8000468e:	ec26                	sd	s1,24(sp)
    80004690:	e84a                	sd	s2,16(sp)
    80004692:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0) return -1;
    80004694:	fd840613          	addi	a2,s0,-40
    80004698:	4581                	li	a1,0
    8000469a:	4501                	li	a0,0
    8000469c:	00000097          	auipc	ra,0x0
    800046a0:	dc0080e7          	jalr	-576(ra) # 8000445c <argfd>
    800046a4:	57fd                	li	a5,-1
    800046a6:	02054363          	bltz	a0,800046cc <sys_dup+0x44>
  if ((fd = fdalloc(f)) < 0) return -1;
    800046aa:	fd843903          	ld	s2,-40(s0)
    800046ae:	854a                	mv	a0,s2
    800046b0:	00000097          	auipc	ra,0x0
    800046b4:	e0c080e7          	jalr	-500(ra) # 800044bc <fdalloc>
    800046b8:	84aa                	mv	s1,a0
    800046ba:	57fd                	li	a5,-1
    800046bc:	00054863          	bltz	a0,800046cc <sys_dup+0x44>
  filedup(f);
    800046c0:	854a                	mv	a0,s2
    800046c2:	fffff097          	auipc	ra,0xfffff
    800046c6:	310080e7          	jalr	784(ra) # 800039d2 <filedup>
  return fd;
    800046ca:	87a6                	mv	a5,s1
}
    800046cc:	853e                	mv	a0,a5
    800046ce:	70a2                	ld	ra,40(sp)
    800046d0:	7402                	ld	s0,32(sp)
    800046d2:	64e2                	ld	s1,24(sp)
    800046d4:	6942                	ld	s2,16(sp)
    800046d6:	6145                	addi	sp,sp,48
    800046d8:	8082                	ret

00000000800046da <sys_read>:
uint64 sys_read(void) {
    800046da:	7179                	addi	sp,sp,-48
    800046dc:	f406                	sd	ra,40(sp)
    800046de:	f022                	sd	s0,32(sp)
    800046e0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800046e2:	fd840593          	addi	a1,s0,-40
    800046e6:	4505                	li	a0,1
    800046e8:	ffffe097          	auipc	ra,0xffffe
    800046ec:	950080e7          	jalr	-1712(ra) # 80002038 <argaddr>
  argint(2, &n);
    800046f0:	fe440593          	addi	a1,s0,-28
    800046f4:	4509                	li	a0,2
    800046f6:	ffffe097          	auipc	ra,0xffffe
    800046fa:	922080e7          	jalr	-1758(ra) # 80002018 <argint>
  if (argfd(0, 0, &f) < 0) return -1;
    800046fe:	fe840613          	addi	a2,s0,-24
    80004702:	4581                	li	a1,0
    80004704:	4501                	li	a0,0
    80004706:	00000097          	auipc	ra,0x0
    8000470a:	d56080e7          	jalr	-682(ra) # 8000445c <argfd>
    8000470e:	87aa                	mv	a5,a0
    80004710:	557d                	li	a0,-1
    80004712:	0007cc63          	bltz	a5,8000472a <sys_read+0x50>
  return fileread(f, p, n);
    80004716:	fe442603          	lw	a2,-28(s0)
    8000471a:	fd843583          	ld	a1,-40(s0)
    8000471e:	fe843503          	ld	a0,-24(s0)
    80004722:	fffff097          	auipc	ra,0xfffff
    80004726:	43c080e7          	jalr	1084(ra) # 80003b5e <fileread>
}
    8000472a:	70a2                	ld	ra,40(sp)
    8000472c:	7402                	ld	s0,32(sp)
    8000472e:	6145                	addi	sp,sp,48
    80004730:	8082                	ret

0000000080004732 <sys_write>:
uint64 sys_write(void) {
    80004732:	7179                	addi	sp,sp,-48
    80004734:	f406                	sd	ra,40(sp)
    80004736:	f022                	sd	s0,32(sp)
    80004738:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000473a:	fd840593          	addi	a1,s0,-40
    8000473e:	4505                	li	a0,1
    80004740:	ffffe097          	auipc	ra,0xffffe
    80004744:	8f8080e7          	jalr	-1800(ra) # 80002038 <argaddr>
  argint(2, &n);
    80004748:	fe440593          	addi	a1,s0,-28
    8000474c:	4509                	li	a0,2
    8000474e:	ffffe097          	auipc	ra,0xffffe
    80004752:	8ca080e7          	jalr	-1846(ra) # 80002018 <argint>
  if (argfd(0, 0, &f) < 0) return -1;
    80004756:	fe840613          	addi	a2,s0,-24
    8000475a:	4581                	li	a1,0
    8000475c:	4501                	li	a0,0
    8000475e:	00000097          	auipc	ra,0x0
    80004762:	cfe080e7          	jalr	-770(ra) # 8000445c <argfd>
    80004766:	87aa                	mv	a5,a0
    80004768:	557d                	li	a0,-1
    8000476a:	0007cc63          	bltz	a5,80004782 <sys_write+0x50>
  return filewrite(f, p, n);
    8000476e:	fe442603          	lw	a2,-28(s0)
    80004772:	fd843583          	ld	a1,-40(s0)
    80004776:	fe843503          	ld	a0,-24(s0)
    8000477a:	fffff097          	auipc	ra,0xfffff
    8000477e:	4a6080e7          	jalr	1190(ra) # 80003c20 <filewrite>
}
    80004782:	70a2                	ld	ra,40(sp)
    80004784:	7402                	ld	s0,32(sp)
    80004786:	6145                	addi	sp,sp,48
    80004788:	8082                	ret

000000008000478a <sys_close>:
uint64 sys_close(void) {
    8000478a:	1101                	addi	sp,sp,-32
    8000478c:	ec06                	sd	ra,24(sp)
    8000478e:	e822                	sd	s0,16(sp)
    80004790:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0) return -1;
    80004792:	fe040613          	addi	a2,s0,-32
    80004796:	fec40593          	addi	a1,s0,-20
    8000479a:	4501                	li	a0,0
    8000479c:	00000097          	auipc	ra,0x0
    800047a0:	cc0080e7          	jalr	-832(ra) # 8000445c <argfd>
    800047a4:	57fd                	li	a5,-1
    800047a6:	02054463          	bltz	a0,800047ce <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047aa:	ffffc097          	auipc	ra,0xffffc
    800047ae:	742080e7          	jalr	1858(ra) # 80000eec <myproc>
    800047b2:	fec42783          	lw	a5,-20(s0)
    800047b6:	07e9                	addi	a5,a5,26
    800047b8:	078e                	slli	a5,a5,0x3
    800047ba:	953e                	add	a0,a0,a5
    800047bc:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800047c0:	fe043503          	ld	a0,-32(s0)
    800047c4:	fffff097          	auipc	ra,0xfffff
    800047c8:	260080e7          	jalr	608(ra) # 80003a24 <fileclose>
  return 0;
    800047cc:	4781                	li	a5,0
}
    800047ce:	853e                	mv	a0,a5
    800047d0:	60e2                	ld	ra,24(sp)
    800047d2:	6442                	ld	s0,16(sp)
    800047d4:	6105                	addi	sp,sp,32
    800047d6:	8082                	ret

00000000800047d8 <sys_fstat>:
uint64 sys_fstat(void) {
    800047d8:	1101                	addi	sp,sp,-32
    800047da:	ec06                	sd	ra,24(sp)
    800047dc:	e822                	sd	s0,16(sp)
    800047de:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800047e0:	fe040593          	addi	a1,s0,-32
    800047e4:	4505                	li	a0,1
    800047e6:	ffffe097          	auipc	ra,0xffffe
    800047ea:	852080e7          	jalr	-1966(ra) # 80002038 <argaddr>
  if (argfd(0, 0, &f) < 0) return -1;
    800047ee:	fe840613          	addi	a2,s0,-24
    800047f2:	4581                	li	a1,0
    800047f4:	4501                	li	a0,0
    800047f6:	00000097          	auipc	ra,0x0
    800047fa:	c66080e7          	jalr	-922(ra) # 8000445c <argfd>
    800047fe:	87aa                	mv	a5,a0
    80004800:	557d                	li	a0,-1
    80004802:	0007ca63          	bltz	a5,80004816 <sys_fstat+0x3e>
  return filestat(f, st);
    80004806:	fe043583          	ld	a1,-32(s0)
    8000480a:	fe843503          	ld	a0,-24(s0)
    8000480e:	fffff097          	auipc	ra,0xfffff
    80004812:	2de080e7          	jalr	734(ra) # 80003aec <filestat>
}
    80004816:	60e2                	ld	ra,24(sp)
    80004818:	6442                	ld	s0,16(sp)
    8000481a:	6105                	addi	sp,sp,32
    8000481c:	8082                	ret

000000008000481e <sys_link>:
uint64 sys_link(void) {
    8000481e:	7169                	addi	sp,sp,-304
    80004820:	f606                	sd	ra,296(sp)
    80004822:	f222                	sd	s0,288(sp)
    80004824:	ee26                	sd	s1,280(sp)
    80004826:	ea4a                	sd	s2,272(sp)
    80004828:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0) return -1;
    8000482a:	08000613          	li	a2,128
    8000482e:	ed040593          	addi	a1,s0,-304
    80004832:	4501                	li	a0,0
    80004834:	ffffe097          	auipc	ra,0xffffe
    80004838:	824080e7          	jalr	-2012(ra) # 80002058 <argstr>
    8000483c:	57fd                	li	a5,-1
    8000483e:	10054e63          	bltz	a0,8000495a <sys_link+0x13c>
    80004842:	08000613          	li	a2,128
    80004846:	f5040593          	addi	a1,s0,-176
    8000484a:	4505                	li	a0,1
    8000484c:	ffffe097          	auipc	ra,0xffffe
    80004850:	80c080e7          	jalr	-2036(ra) # 80002058 <argstr>
    80004854:	57fd                	li	a5,-1
    80004856:	10054263          	bltz	a0,8000495a <sys_link+0x13c>
  begin_op();
    8000485a:	fffff097          	auipc	ra,0xfffff
    8000485e:	d02080e7          	jalr	-766(ra) # 8000355c <begin_op>
  if ((ip = namei(old)) == 0) {
    80004862:	ed040513          	addi	a0,s0,-304
    80004866:	fffff097          	auipc	ra,0xfffff
    8000486a:	ad6080e7          	jalr	-1322(ra) # 8000333c <namei>
    8000486e:	84aa                	mv	s1,a0
    80004870:	c551                	beqz	a0,800048fc <sys_link+0xde>
  ilock(ip);
    80004872:	ffffe097          	auipc	ra,0xffffe
    80004876:	31e080e7          	jalr	798(ra) # 80002b90 <ilock>
  if (ip->type == T_DIR) {
    8000487a:	04449703          	lh	a4,68(s1)
    8000487e:	4785                	li	a5,1
    80004880:	08f70463          	beq	a4,a5,80004908 <sys_link+0xea>
  ip->nlink++;
    80004884:	04a4d783          	lhu	a5,74(s1)
    80004888:	2785                	addiw	a5,a5,1
    8000488a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000488e:	8526                	mv	a0,s1
    80004890:	ffffe097          	auipc	ra,0xffffe
    80004894:	234080e7          	jalr	564(ra) # 80002ac4 <iupdate>
  iunlock(ip);
    80004898:	8526                	mv	a0,s1
    8000489a:	ffffe097          	auipc	ra,0xffffe
    8000489e:	3b8080e7          	jalr	952(ra) # 80002c52 <iunlock>
  if ((dp = nameiparent(new, name)) == 0) goto bad;
    800048a2:	fd040593          	addi	a1,s0,-48
    800048a6:	f5040513          	addi	a0,s0,-176
    800048aa:	fffff097          	auipc	ra,0xfffff
    800048ae:	ab0080e7          	jalr	-1360(ra) # 8000335a <nameiparent>
    800048b2:	892a                	mv	s2,a0
    800048b4:	c935                	beqz	a0,80004928 <sys_link+0x10a>
  ilock(dp);
    800048b6:	ffffe097          	auipc	ra,0xffffe
    800048ba:	2da080e7          	jalr	730(ra) # 80002b90 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    800048be:	00092703          	lw	a4,0(s2)
    800048c2:	409c                	lw	a5,0(s1)
    800048c4:	04f71d63          	bne	a4,a5,8000491e <sys_link+0x100>
    800048c8:	40d0                	lw	a2,4(s1)
    800048ca:	fd040593          	addi	a1,s0,-48
    800048ce:	854a                	mv	a0,s2
    800048d0:	fffff097          	auipc	ra,0xfffff
    800048d4:	9ba080e7          	jalr	-1606(ra) # 8000328a <dirlink>
    800048d8:	04054363          	bltz	a0,8000491e <sys_link+0x100>
  iunlockput(dp);
    800048dc:	854a                	mv	a0,s2
    800048de:	ffffe097          	auipc	ra,0xffffe
    800048e2:	514080e7          	jalr	1300(ra) # 80002df2 <iunlockput>
  iput(ip);
    800048e6:	8526                	mv	a0,s1
    800048e8:	ffffe097          	auipc	ra,0xffffe
    800048ec:	462080e7          	jalr	1122(ra) # 80002d4a <iput>
  end_op();
    800048f0:	fffff097          	auipc	ra,0xfffff
    800048f4:	cea080e7          	jalr	-790(ra) # 800035da <end_op>
  return 0;
    800048f8:	4781                	li	a5,0
    800048fa:	a085                	j	8000495a <sys_link+0x13c>
    end_op();
    800048fc:	fffff097          	auipc	ra,0xfffff
    80004900:	cde080e7          	jalr	-802(ra) # 800035da <end_op>
    return -1;
    80004904:	57fd                	li	a5,-1
    80004906:	a891                	j	8000495a <sys_link+0x13c>
    iunlockput(ip);
    80004908:	8526                	mv	a0,s1
    8000490a:	ffffe097          	auipc	ra,0xffffe
    8000490e:	4e8080e7          	jalr	1256(ra) # 80002df2 <iunlockput>
    end_op();
    80004912:	fffff097          	auipc	ra,0xfffff
    80004916:	cc8080e7          	jalr	-824(ra) # 800035da <end_op>
    return -1;
    8000491a:	57fd                	li	a5,-1
    8000491c:	a83d                	j	8000495a <sys_link+0x13c>
    iunlockput(dp);
    8000491e:	854a                	mv	a0,s2
    80004920:	ffffe097          	auipc	ra,0xffffe
    80004924:	4d2080e7          	jalr	1234(ra) # 80002df2 <iunlockput>
  ilock(ip);
    80004928:	8526                	mv	a0,s1
    8000492a:	ffffe097          	auipc	ra,0xffffe
    8000492e:	266080e7          	jalr	614(ra) # 80002b90 <ilock>
  ip->nlink--;
    80004932:	04a4d783          	lhu	a5,74(s1)
    80004936:	37fd                	addiw	a5,a5,-1
    80004938:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000493c:	8526                	mv	a0,s1
    8000493e:	ffffe097          	auipc	ra,0xffffe
    80004942:	186080e7          	jalr	390(ra) # 80002ac4 <iupdate>
  iunlockput(ip);
    80004946:	8526                	mv	a0,s1
    80004948:	ffffe097          	auipc	ra,0xffffe
    8000494c:	4aa080e7          	jalr	1194(ra) # 80002df2 <iunlockput>
  end_op();
    80004950:	fffff097          	auipc	ra,0xfffff
    80004954:	c8a080e7          	jalr	-886(ra) # 800035da <end_op>
  return -1;
    80004958:	57fd                	li	a5,-1
}
    8000495a:	853e                	mv	a0,a5
    8000495c:	70b2                	ld	ra,296(sp)
    8000495e:	7412                	ld	s0,288(sp)
    80004960:	64f2                	ld	s1,280(sp)
    80004962:	6952                	ld	s2,272(sp)
    80004964:	6155                	addi	sp,sp,304
    80004966:	8082                	ret

0000000080004968 <sys_unlink>:
uint64 sys_unlink(void) {
    80004968:	7151                	addi	sp,sp,-240
    8000496a:	f586                	sd	ra,232(sp)
    8000496c:	f1a2                	sd	s0,224(sp)
    8000496e:	eda6                	sd	s1,216(sp)
    80004970:	e9ca                	sd	s2,208(sp)
    80004972:	e5ce                	sd	s3,200(sp)
    80004974:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0) return -1;
    80004976:	08000613          	li	a2,128
    8000497a:	f3040593          	addi	a1,s0,-208
    8000497e:	4501                	li	a0,0
    80004980:	ffffd097          	auipc	ra,0xffffd
    80004984:	6d8080e7          	jalr	1752(ra) # 80002058 <argstr>
    80004988:	18054163          	bltz	a0,80004b0a <sys_unlink+0x1a2>
  begin_op();
    8000498c:	fffff097          	auipc	ra,0xfffff
    80004990:	bd0080e7          	jalr	-1072(ra) # 8000355c <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    80004994:	fb040593          	addi	a1,s0,-80
    80004998:	f3040513          	addi	a0,s0,-208
    8000499c:	fffff097          	auipc	ra,0xfffff
    800049a0:	9be080e7          	jalr	-1602(ra) # 8000335a <nameiparent>
    800049a4:	84aa                	mv	s1,a0
    800049a6:	c979                	beqz	a0,80004a7c <sys_unlink+0x114>
  ilock(dp);
    800049a8:	ffffe097          	auipc	ra,0xffffe
    800049ac:	1e8080e7          	jalr	488(ra) # 80002b90 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0) goto bad;
    800049b0:	00005597          	auipc	a1,0x5
    800049b4:	d2058593          	addi	a1,a1,-736 # 800096d0 <syscalls+0x2c0>
    800049b8:	fb040513          	addi	a0,s0,-80
    800049bc:	ffffe097          	auipc	ra,0xffffe
    800049c0:	69e080e7          	jalr	1694(ra) # 8000305a <namecmp>
    800049c4:	14050a63          	beqz	a0,80004b18 <sys_unlink+0x1b0>
    800049c8:	00005597          	auipc	a1,0x5
    800049cc:	d1058593          	addi	a1,a1,-752 # 800096d8 <syscalls+0x2c8>
    800049d0:	fb040513          	addi	a0,s0,-80
    800049d4:	ffffe097          	auipc	ra,0xffffe
    800049d8:	686080e7          	jalr	1670(ra) # 8000305a <namecmp>
    800049dc:	12050e63          	beqz	a0,80004b18 <sys_unlink+0x1b0>
  if ((ip = dirlookup(dp, name, &off)) == 0) goto bad;
    800049e0:	f2c40613          	addi	a2,s0,-212
    800049e4:	fb040593          	addi	a1,s0,-80
    800049e8:	8526                	mv	a0,s1
    800049ea:	ffffe097          	auipc	ra,0xffffe
    800049ee:	68a080e7          	jalr	1674(ra) # 80003074 <dirlookup>
    800049f2:	892a                	mv	s2,a0
    800049f4:	12050263          	beqz	a0,80004b18 <sys_unlink+0x1b0>
  ilock(ip);
    800049f8:	ffffe097          	auipc	ra,0xffffe
    800049fc:	198080e7          	jalr	408(ra) # 80002b90 <ilock>
  if (ip->nlink < 1) panic("unlink: nlink < 1");
    80004a00:	04a91783          	lh	a5,74(s2)
    80004a04:	08f05263          	blez	a5,80004a88 <sys_unlink+0x120>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    80004a08:	04491703          	lh	a4,68(s2)
    80004a0c:	4785                	li	a5,1
    80004a0e:	08f70563          	beq	a4,a5,80004a98 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a12:	4641                	li	a2,16
    80004a14:	4581                	li	a1,0
    80004a16:	fc040513          	addi	a0,s0,-64
    80004a1a:	ffffb097          	auipc	ra,0xffffb
    80004a1e:	760080e7          	jalr	1888(ra) # 8000017a <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a22:	4741                	li	a4,16
    80004a24:	f2c42683          	lw	a3,-212(s0)
    80004a28:	fc040613          	addi	a2,s0,-64
    80004a2c:	4581                	li	a1,0
    80004a2e:	8526                	mv	a0,s1
    80004a30:	ffffe097          	auipc	ra,0xffffe
    80004a34:	50c080e7          	jalr	1292(ra) # 80002f3c <writei>
    80004a38:	47c1                	li	a5,16
    80004a3a:	0af51563          	bne	a0,a5,80004ae4 <sys_unlink+0x17c>
  if (ip->type == T_DIR) {
    80004a3e:	04491703          	lh	a4,68(s2)
    80004a42:	4785                	li	a5,1
    80004a44:	0af70863          	beq	a4,a5,80004af4 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a48:	8526                	mv	a0,s1
    80004a4a:	ffffe097          	auipc	ra,0xffffe
    80004a4e:	3a8080e7          	jalr	936(ra) # 80002df2 <iunlockput>
  ip->nlink--;
    80004a52:	04a95783          	lhu	a5,74(s2)
    80004a56:	37fd                	addiw	a5,a5,-1
    80004a58:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a5c:	854a                	mv	a0,s2
    80004a5e:	ffffe097          	auipc	ra,0xffffe
    80004a62:	066080e7          	jalr	102(ra) # 80002ac4 <iupdate>
  iunlockput(ip);
    80004a66:	854a                	mv	a0,s2
    80004a68:	ffffe097          	auipc	ra,0xffffe
    80004a6c:	38a080e7          	jalr	906(ra) # 80002df2 <iunlockput>
  end_op();
    80004a70:	fffff097          	auipc	ra,0xfffff
    80004a74:	b6a080e7          	jalr	-1174(ra) # 800035da <end_op>
  return 0;
    80004a78:	4501                	li	a0,0
    80004a7a:	a84d                	j	80004b2c <sys_unlink+0x1c4>
    end_op();
    80004a7c:	fffff097          	auipc	ra,0xfffff
    80004a80:	b5e080e7          	jalr	-1186(ra) # 800035da <end_op>
    return -1;
    80004a84:	557d                	li	a0,-1
    80004a86:	a05d                	j	80004b2c <sys_unlink+0x1c4>
  if (ip->nlink < 1) panic("unlink: nlink < 1");
    80004a88:	00005517          	auipc	a0,0x5
    80004a8c:	c5850513          	addi	a0,a0,-936 # 800096e0 <syscalls+0x2d0>
    80004a90:	00002097          	auipc	ra,0x2
    80004a94:	f4e080e7          	jalr	-178(ra) # 800069de <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004a98:	04c92703          	lw	a4,76(s2)
    80004a9c:	02000793          	li	a5,32
    80004aa0:	f6e7f9e3          	bgeu	a5,a4,80004a12 <sys_unlink+0xaa>
    80004aa4:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004aa8:	4741                	li	a4,16
    80004aaa:	86ce                	mv	a3,s3
    80004aac:	f1840613          	addi	a2,s0,-232
    80004ab0:	4581                	li	a1,0
    80004ab2:	854a                	mv	a0,s2
    80004ab4:	ffffe097          	auipc	ra,0xffffe
    80004ab8:	390080e7          	jalr	912(ra) # 80002e44 <readi>
    80004abc:	47c1                	li	a5,16
    80004abe:	00f51b63          	bne	a0,a5,80004ad4 <sys_unlink+0x16c>
    if (de.inum != 0) return 0;
    80004ac2:	f1845783          	lhu	a5,-232(s0)
    80004ac6:	e7a1                	bnez	a5,80004b0e <sys_unlink+0x1a6>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004ac8:	29c1                	addiw	s3,s3,16
    80004aca:	04c92783          	lw	a5,76(s2)
    80004ace:	fcf9ede3          	bltu	s3,a5,80004aa8 <sys_unlink+0x140>
    80004ad2:	b781                	j	80004a12 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ad4:	00005517          	auipc	a0,0x5
    80004ad8:	c2450513          	addi	a0,a0,-988 # 800096f8 <syscalls+0x2e8>
    80004adc:	00002097          	auipc	ra,0x2
    80004ae0:	f02080e7          	jalr	-254(ra) # 800069de <panic>
    panic("unlink: writei");
    80004ae4:	00005517          	auipc	a0,0x5
    80004ae8:	c2c50513          	addi	a0,a0,-980 # 80009710 <syscalls+0x300>
    80004aec:	00002097          	auipc	ra,0x2
    80004af0:	ef2080e7          	jalr	-270(ra) # 800069de <panic>
    dp->nlink--;
    80004af4:	04a4d783          	lhu	a5,74(s1)
    80004af8:	37fd                	addiw	a5,a5,-1
    80004afa:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004afe:	8526                	mv	a0,s1
    80004b00:	ffffe097          	auipc	ra,0xffffe
    80004b04:	fc4080e7          	jalr	-60(ra) # 80002ac4 <iupdate>
    80004b08:	b781                	j	80004a48 <sys_unlink+0xe0>
  if (argstr(0, path, MAXPATH) < 0) return -1;
    80004b0a:	557d                	li	a0,-1
    80004b0c:	a005                	j	80004b2c <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b0e:	854a                	mv	a0,s2
    80004b10:	ffffe097          	auipc	ra,0xffffe
    80004b14:	2e2080e7          	jalr	738(ra) # 80002df2 <iunlockput>
  iunlockput(dp);
    80004b18:	8526                	mv	a0,s1
    80004b1a:	ffffe097          	auipc	ra,0xffffe
    80004b1e:	2d8080e7          	jalr	728(ra) # 80002df2 <iunlockput>
  end_op();
    80004b22:	fffff097          	auipc	ra,0xfffff
    80004b26:	ab8080e7          	jalr	-1352(ra) # 800035da <end_op>
  return -1;
    80004b2a:	557d                	li	a0,-1
}
    80004b2c:	70ae                	ld	ra,232(sp)
    80004b2e:	740e                	ld	s0,224(sp)
    80004b30:	64ee                	ld	s1,216(sp)
    80004b32:	694e                	ld	s2,208(sp)
    80004b34:	69ae                	ld	s3,200(sp)
    80004b36:	616d                	addi	sp,sp,240
    80004b38:	8082                	ret

0000000080004b3a <sys_open>:

uint64 sys_open(void) {
    80004b3a:	7131                	addi	sp,sp,-192
    80004b3c:	fd06                	sd	ra,184(sp)
    80004b3e:	f922                	sd	s0,176(sp)
    80004b40:	f526                	sd	s1,168(sp)
    80004b42:	f14a                	sd	s2,160(sp)
    80004b44:	ed4e                	sd	s3,152(sp)
    80004b46:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004b48:	f4c40593          	addi	a1,s0,-180
    80004b4c:	4505                	li	a0,1
    80004b4e:	ffffd097          	auipc	ra,0xffffd
    80004b52:	4ca080e7          	jalr	1226(ra) # 80002018 <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0) return -1;
    80004b56:	08000613          	li	a2,128
    80004b5a:	f5040593          	addi	a1,s0,-176
    80004b5e:	4501                	li	a0,0
    80004b60:	ffffd097          	auipc	ra,0xffffd
    80004b64:	4f8080e7          	jalr	1272(ra) # 80002058 <argstr>
    80004b68:	87aa                	mv	a5,a0
    80004b6a:	557d                	li	a0,-1
    80004b6c:	0a07c963          	bltz	a5,80004c1e <sys_open+0xe4>

  begin_op();
    80004b70:	fffff097          	auipc	ra,0xfffff
    80004b74:	9ec080e7          	jalr	-1556(ra) # 8000355c <begin_op>

  if (omode & O_CREATE) {
    80004b78:	f4c42783          	lw	a5,-180(s0)
    80004b7c:	2007f793          	andi	a5,a5,512
    80004b80:	cfc5                	beqz	a5,80004c38 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b82:	4681                	li	a3,0
    80004b84:	4601                	li	a2,0
    80004b86:	4589                	li	a1,2
    80004b88:	f5040513          	addi	a0,s0,-176
    80004b8c:	00000097          	auipc	ra,0x0
    80004b90:	972080e7          	jalr	-1678(ra) # 800044fe <create>
    80004b94:	84aa                	mv	s1,a0
    if (ip == 0) {
    80004b96:	c959                	beqz	a0,80004c2c <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    80004b98:	04449703          	lh	a4,68(s1)
    80004b9c:	478d                	li	a5,3
    80004b9e:	00f71763          	bne	a4,a5,80004bac <sys_open+0x72>
    80004ba2:	0464d703          	lhu	a4,70(s1)
    80004ba6:	47a5                	li	a5,9
    80004ba8:	0ce7ed63          	bltu	a5,a4,80004c82 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80004bac:	fffff097          	auipc	ra,0xfffff
    80004bb0:	dbc080e7          	jalr	-580(ra) # 80003968 <filealloc>
    80004bb4:	89aa                	mv	s3,a0
    80004bb6:	10050363          	beqz	a0,80004cbc <sys_open+0x182>
    80004bba:	00000097          	auipc	ra,0x0
    80004bbe:	902080e7          	jalr	-1790(ra) # 800044bc <fdalloc>
    80004bc2:	892a                	mv	s2,a0
    80004bc4:	0e054763          	bltz	a0,80004cb2 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    80004bc8:	04449703          	lh	a4,68(s1)
    80004bcc:	478d                	li	a5,3
    80004bce:	0cf70563          	beq	a4,a5,80004c98 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bd2:	4789                	li	a5,2
    80004bd4:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bd8:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004bdc:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004be0:	f4c42783          	lw	a5,-180(s0)
    80004be4:	0017c713          	xori	a4,a5,1
    80004be8:	8b05                	andi	a4,a4,1
    80004bea:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004bee:	0037f713          	andi	a4,a5,3
    80004bf2:	00e03733          	snez	a4,a4
    80004bf6:	00e984a3          	sb	a4,9(s3)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    80004bfa:	4007f793          	andi	a5,a5,1024
    80004bfe:	c791                	beqz	a5,80004c0a <sys_open+0xd0>
    80004c00:	04449703          	lh	a4,68(s1)
    80004c04:	4789                	li	a5,2
    80004c06:	0af70063          	beq	a4,a5,80004ca6 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c0a:	8526                	mv	a0,s1
    80004c0c:	ffffe097          	auipc	ra,0xffffe
    80004c10:	046080e7          	jalr	70(ra) # 80002c52 <iunlock>
  end_op();
    80004c14:	fffff097          	auipc	ra,0xfffff
    80004c18:	9c6080e7          	jalr	-1594(ra) # 800035da <end_op>

  return fd;
    80004c1c:	854a                	mv	a0,s2
}
    80004c1e:	70ea                	ld	ra,184(sp)
    80004c20:	744a                	ld	s0,176(sp)
    80004c22:	74aa                	ld	s1,168(sp)
    80004c24:	790a                	ld	s2,160(sp)
    80004c26:	69ea                	ld	s3,152(sp)
    80004c28:	6129                	addi	sp,sp,192
    80004c2a:	8082                	ret
      end_op();
    80004c2c:	fffff097          	auipc	ra,0xfffff
    80004c30:	9ae080e7          	jalr	-1618(ra) # 800035da <end_op>
      return -1;
    80004c34:	557d                	li	a0,-1
    80004c36:	b7e5                	j	80004c1e <sys_open+0xe4>
    if ((ip = namei(path)) == 0) {
    80004c38:	f5040513          	addi	a0,s0,-176
    80004c3c:	ffffe097          	auipc	ra,0xffffe
    80004c40:	700080e7          	jalr	1792(ra) # 8000333c <namei>
    80004c44:	84aa                	mv	s1,a0
    80004c46:	c905                	beqz	a0,80004c76 <sys_open+0x13c>
    ilock(ip);
    80004c48:	ffffe097          	auipc	ra,0xffffe
    80004c4c:	f48080e7          	jalr	-184(ra) # 80002b90 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    80004c50:	04449703          	lh	a4,68(s1)
    80004c54:	4785                	li	a5,1
    80004c56:	f4f711e3          	bne	a4,a5,80004b98 <sys_open+0x5e>
    80004c5a:	f4c42783          	lw	a5,-180(s0)
    80004c5e:	d7b9                	beqz	a5,80004bac <sys_open+0x72>
      iunlockput(ip);
    80004c60:	8526                	mv	a0,s1
    80004c62:	ffffe097          	auipc	ra,0xffffe
    80004c66:	190080e7          	jalr	400(ra) # 80002df2 <iunlockput>
      end_op();
    80004c6a:	fffff097          	auipc	ra,0xfffff
    80004c6e:	970080e7          	jalr	-1680(ra) # 800035da <end_op>
      return -1;
    80004c72:	557d                	li	a0,-1
    80004c74:	b76d                	j	80004c1e <sys_open+0xe4>
      end_op();
    80004c76:	fffff097          	auipc	ra,0xfffff
    80004c7a:	964080e7          	jalr	-1692(ra) # 800035da <end_op>
      return -1;
    80004c7e:	557d                	li	a0,-1
    80004c80:	bf79                	j	80004c1e <sys_open+0xe4>
    iunlockput(ip);
    80004c82:	8526                	mv	a0,s1
    80004c84:	ffffe097          	auipc	ra,0xffffe
    80004c88:	16e080e7          	jalr	366(ra) # 80002df2 <iunlockput>
    end_op();
    80004c8c:	fffff097          	auipc	ra,0xfffff
    80004c90:	94e080e7          	jalr	-1714(ra) # 800035da <end_op>
    return -1;
    80004c94:	557d                	li	a0,-1
    80004c96:	b761                	j	80004c1e <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c98:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c9c:	04649783          	lh	a5,70(s1)
    80004ca0:	02f99223          	sh	a5,36(s3)
    80004ca4:	bf25                	j	80004bdc <sys_open+0xa2>
    itrunc(ip);
    80004ca6:	8526                	mv	a0,s1
    80004ca8:	ffffe097          	auipc	ra,0xffffe
    80004cac:	ff6080e7          	jalr	-10(ra) # 80002c9e <itrunc>
    80004cb0:	bfa9                	j	80004c0a <sys_open+0xd0>
    if (f) fileclose(f);
    80004cb2:	854e                	mv	a0,s3
    80004cb4:	fffff097          	auipc	ra,0xfffff
    80004cb8:	d70080e7          	jalr	-656(ra) # 80003a24 <fileclose>
    iunlockput(ip);
    80004cbc:	8526                	mv	a0,s1
    80004cbe:	ffffe097          	auipc	ra,0xffffe
    80004cc2:	134080e7          	jalr	308(ra) # 80002df2 <iunlockput>
    end_op();
    80004cc6:	fffff097          	auipc	ra,0xfffff
    80004cca:	914080e7          	jalr	-1772(ra) # 800035da <end_op>
    return -1;
    80004cce:	557d                	li	a0,-1
    80004cd0:	b7b9                	j	80004c1e <sys_open+0xe4>

0000000080004cd2 <sys_mkdir>:

uint64 sys_mkdir(void) {
    80004cd2:	7175                	addi	sp,sp,-144
    80004cd4:	e506                	sd	ra,136(sp)
    80004cd6:	e122                	sd	s0,128(sp)
    80004cd8:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cda:	fffff097          	auipc	ra,0xfffff
    80004cde:	882080e7          	jalr	-1918(ra) # 8000355c <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80004ce2:	08000613          	li	a2,128
    80004ce6:	f7040593          	addi	a1,s0,-144
    80004cea:	4501                	li	a0,0
    80004cec:	ffffd097          	auipc	ra,0xffffd
    80004cf0:	36c080e7          	jalr	876(ra) # 80002058 <argstr>
    80004cf4:	02054963          	bltz	a0,80004d26 <sys_mkdir+0x54>
    80004cf8:	4681                	li	a3,0
    80004cfa:	4601                	li	a2,0
    80004cfc:	4585                	li	a1,1
    80004cfe:	f7040513          	addi	a0,s0,-144
    80004d02:	fffff097          	auipc	ra,0xfffff
    80004d06:	7fc080e7          	jalr	2044(ra) # 800044fe <create>
    80004d0a:	cd11                	beqz	a0,80004d26 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d0c:	ffffe097          	auipc	ra,0xffffe
    80004d10:	0e6080e7          	jalr	230(ra) # 80002df2 <iunlockput>
  end_op();
    80004d14:	fffff097          	auipc	ra,0xfffff
    80004d18:	8c6080e7          	jalr	-1850(ra) # 800035da <end_op>
  return 0;
    80004d1c:	4501                	li	a0,0
}
    80004d1e:	60aa                	ld	ra,136(sp)
    80004d20:	640a                	ld	s0,128(sp)
    80004d22:	6149                	addi	sp,sp,144
    80004d24:	8082                	ret
    end_op();
    80004d26:	fffff097          	auipc	ra,0xfffff
    80004d2a:	8b4080e7          	jalr	-1868(ra) # 800035da <end_op>
    return -1;
    80004d2e:	557d                	li	a0,-1
    80004d30:	b7fd                	j	80004d1e <sys_mkdir+0x4c>

0000000080004d32 <sys_mknod>:

uint64 sys_mknod(void) {
    80004d32:	7135                	addi	sp,sp,-160
    80004d34:	ed06                	sd	ra,152(sp)
    80004d36:	e922                	sd	s0,144(sp)
    80004d38:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d3a:	fffff097          	auipc	ra,0xfffff
    80004d3e:	822080e7          	jalr	-2014(ra) # 8000355c <begin_op>
  argint(1, &major);
    80004d42:	f6c40593          	addi	a1,s0,-148
    80004d46:	4505                	li	a0,1
    80004d48:	ffffd097          	auipc	ra,0xffffd
    80004d4c:	2d0080e7          	jalr	720(ra) # 80002018 <argint>
  argint(2, &minor);
    80004d50:	f6840593          	addi	a1,s0,-152
    80004d54:	4509                	li	a0,2
    80004d56:	ffffd097          	auipc	ra,0xffffd
    80004d5a:	2c2080e7          	jalr	706(ra) # 80002018 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004d5e:	08000613          	li	a2,128
    80004d62:	f7040593          	addi	a1,s0,-144
    80004d66:	4501                	li	a0,0
    80004d68:	ffffd097          	auipc	ra,0xffffd
    80004d6c:	2f0080e7          	jalr	752(ra) # 80002058 <argstr>
    80004d70:	02054b63          	bltz	a0,80004da6 <sys_mknod+0x74>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    80004d74:	f6841683          	lh	a3,-152(s0)
    80004d78:	f6c41603          	lh	a2,-148(s0)
    80004d7c:	458d                	li	a1,3
    80004d7e:	f7040513          	addi	a0,s0,-144
    80004d82:	fffff097          	auipc	ra,0xfffff
    80004d86:	77c080e7          	jalr	1916(ra) # 800044fe <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004d8a:	cd11                	beqz	a0,80004da6 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d8c:	ffffe097          	auipc	ra,0xffffe
    80004d90:	066080e7          	jalr	102(ra) # 80002df2 <iunlockput>
  end_op();
    80004d94:	fffff097          	auipc	ra,0xfffff
    80004d98:	846080e7          	jalr	-1978(ra) # 800035da <end_op>
  return 0;
    80004d9c:	4501                	li	a0,0
}
    80004d9e:	60ea                	ld	ra,152(sp)
    80004da0:	644a                	ld	s0,144(sp)
    80004da2:	610d                	addi	sp,sp,160
    80004da4:	8082                	ret
    end_op();
    80004da6:	fffff097          	auipc	ra,0xfffff
    80004daa:	834080e7          	jalr	-1996(ra) # 800035da <end_op>
    return -1;
    80004dae:	557d                	li	a0,-1
    80004db0:	b7fd                	j	80004d9e <sys_mknod+0x6c>

0000000080004db2 <sys_chdir>:

uint64 sys_chdir(void) {
    80004db2:	7135                	addi	sp,sp,-160
    80004db4:	ed06                	sd	ra,152(sp)
    80004db6:	e922                	sd	s0,144(sp)
    80004db8:	e526                	sd	s1,136(sp)
    80004dba:	e14a                	sd	s2,128(sp)
    80004dbc:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004dbe:	ffffc097          	auipc	ra,0xffffc
    80004dc2:	12e080e7          	jalr	302(ra) # 80000eec <myproc>
    80004dc6:	892a                	mv	s2,a0

  begin_op();
    80004dc8:	ffffe097          	auipc	ra,0xffffe
    80004dcc:	794080e7          	jalr	1940(ra) # 8000355c <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    80004dd0:	08000613          	li	a2,128
    80004dd4:	f6040593          	addi	a1,s0,-160
    80004dd8:	4501                	li	a0,0
    80004dda:	ffffd097          	auipc	ra,0xffffd
    80004dde:	27e080e7          	jalr	638(ra) # 80002058 <argstr>
    80004de2:	04054b63          	bltz	a0,80004e38 <sys_chdir+0x86>
    80004de6:	f6040513          	addi	a0,s0,-160
    80004dea:	ffffe097          	auipc	ra,0xffffe
    80004dee:	552080e7          	jalr	1362(ra) # 8000333c <namei>
    80004df2:	84aa                	mv	s1,a0
    80004df4:	c131                	beqz	a0,80004e38 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004df6:	ffffe097          	auipc	ra,0xffffe
    80004dfa:	d9a080e7          	jalr	-614(ra) # 80002b90 <ilock>
  if (ip->type != T_DIR) {
    80004dfe:	04449703          	lh	a4,68(s1)
    80004e02:	4785                	li	a5,1
    80004e04:	04f71063          	bne	a4,a5,80004e44 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e08:	8526                	mv	a0,s1
    80004e0a:	ffffe097          	auipc	ra,0xffffe
    80004e0e:	e48080e7          	jalr	-440(ra) # 80002c52 <iunlock>
  iput(p->cwd);
    80004e12:	15093503          	ld	a0,336(s2)
    80004e16:	ffffe097          	auipc	ra,0xffffe
    80004e1a:	f34080e7          	jalr	-204(ra) # 80002d4a <iput>
  end_op();
    80004e1e:	ffffe097          	auipc	ra,0xffffe
    80004e22:	7bc080e7          	jalr	1980(ra) # 800035da <end_op>
  p->cwd = ip;
    80004e26:	14993823          	sd	s1,336(s2)
  return 0;
    80004e2a:	4501                	li	a0,0
}
    80004e2c:	60ea                	ld	ra,152(sp)
    80004e2e:	644a                	ld	s0,144(sp)
    80004e30:	64aa                	ld	s1,136(sp)
    80004e32:	690a                	ld	s2,128(sp)
    80004e34:	610d                	addi	sp,sp,160
    80004e36:	8082                	ret
    end_op();
    80004e38:	ffffe097          	auipc	ra,0xffffe
    80004e3c:	7a2080e7          	jalr	1954(ra) # 800035da <end_op>
    return -1;
    80004e40:	557d                	li	a0,-1
    80004e42:	b7ed                	j	80004e2c <sys_chdir+0x7a>
    iunlockput(ip);
    80004e44:	8526                	mv	a0,s1
    80004e46:	ffffe097          	auipc	ra,0xffffe
    80004e4a:	fac080e7          	jalr	-84(ra) # 80002df2 <iunlockput>
    end_op();
    80004e4e:	ffffe097          	auipc	ra,0xffffe
    80004e52:	78c080e7          	jalr	1932(ra) # 800035da <end_op>
    return -1;
    80004e56:	557d                	li	a0,-1
    80004e58:	bfd1                	j	80004e2c <sys_chdir+0x7a>

0000000080004e5a <sys_exec>:

uint64 sys_exec(void) {
    80004e5a:	7145                	addi	sp,sp,-464
    80004e5c:	e786                	sd	ra,456(sp)
    80004e5e:	e3a2                	sd	s0,448(sp)
    80004e60:	ff26                	sd	s1,440(sp)
    80004e62:	fb4a                	sd	s2,432(sp)
    80004e64:	f74e                	sd	s3,424(sp)
    80004e66:	f352                	sd	s4,416(sp)
    80004e68:	ef56                	sd	s5,408(sp)
    80004e6a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004e6c:	e3840593          	addi	a1,s0,-456
    80004e70:	4505                	li	a0,1
    80004e72:	ffffd097          	auipc	ra,0xffffd
    80004e76:	1c6080e7          	jalr	454(ra) # 80002038 <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    80004e7a:	08000613          	li	a2,128
    80004e7e:	f4040593          	addi	a1,s0,-192
    80004e82:	4501                	li	a0,0
    80004e84:	ffffd097          	auipc	ra,0xffffd
    80004e88:	1d4080e7          	jalr	468(ra) # 80002058 <argstr>
    80004e8c:	87aa                	mv	a5,a0
    return -1;
    80004e8e:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0) {
    80004e90:	0c07c363          	bltz	a5,80004f56 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004e94:	10000613          	li	a2,256
    80004e98:	4581                	li	a1,0
    80004e9a:	e4040513          	addi	a0,s0,-448
    80004e9e:	ffffb097          	auipc	ra,0xffffb
    80004ea2:	2dc080e7          	jalr	732(ra) # 8000017a <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    80004ea6:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004eaa:	89a6                	mv	s3,s1
    80004eac:	4901                	li	s2,0
    if (i >= NELEM(argv)) {
    80004eae:	02000a13          	li	s4,32
    80004eb2:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80004eb6:	00391513          	slli	a0,s2,0x3
    80004eba:	e3040593          	addi	a1,s0,-464
    80004ebe:	e3843783          	ld	a5,-456(s0)
    80004ec2:	953e                	add	a0,a0,a5
    80004ec4:	ffffd097          	auipc	ra,0xffffd
    80004ec8:	0b6080e7          	jalr	182(ra) # 80001f7a <fetchaddr>
    80004ecc:	02054a63          	bltz	a0,80004f00 <sys_exec+0xa6>
      goto bad;
    }
    if (uarg == 0) {
    80004ed0:	e3043783          	ld	a5,-464(s0)
    80004ed4:	c3b9                	beqz	a5,80004f1a <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ed6:	ffffb097          	auipc	ra,0xffffb
    80004eda:	244080e7          	jalr	580(ra) # 8000011a <kalloc>
    80004ede:	85aa                	mv	a1,a0
    80004ee0:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0) goto bad;
    80004ee4:	cd11                	beqz	a0,80004f00 <sys_exec+0xa6>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0) goto bad;
    80004ee6:	6605                	lui	a2,0x1
    80004ee8:	e3043503          	ld	a0,-464(s0)
    80004eec:	ffffd097          	auipc	ra,0xffffd
    80004ef0:	0e0080e7          	jalr	224(ra) # 80001fcc <fetchstr>
    80004ef4:	00054663          	bltz	a0,80004f00 <sys_exec+0xa6>
    if (i >= NELEM(argv)) {
    80004ef8:	0905                	addi	s2,s2,1
    80004efa:	09a1                	addi	s3,s3,8
    80004efc:	fb491be3          	bne	s2,s4,80004eb2 <sys_exec+0x58>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);
    80004f00:	f4040913          	addi	s2,s0,-192
    80004f04:	6088                	ld	a0,0(s1)
    80004f06:	c539                	beqz	a0,80004f54 <sys_exec+0xfa>
    80004f08:	ffffb097          	auipc	ra,0xffffb
    80004f0c:	114080e7          	jalr	276(ra) # 8000001c <kfree>
    80004f10:	04a1                	addi	s1,s1,8
    80004f12:	ff2499e3          	bne	s1,s2,80004f04 <sys_exec+0xaa>
  return -1;
    80004f16:	557d                	li	a0,-1
    80004f18:	a83d                	j	80004f56 <sys_exec+0xfc>
      argv[i] = 0;
    80004f1a:	0a8e                	slli	s5,s5,0x3
    80004f1c:	fc0a8793          	addi	a5,s5,-64
    80004f20:	00878ab3          	add	s5,a5,s0
    80004f24:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f28:	e4040593          	addi	a1,s0,-448
    80004f2c:	f4040513          	addi	a0,s0,-192
    80004f30:	fffff097          	auipc	ra,0xfffff
    80004f34:	16e080e7          	jalr	366(ra) # 8000409e <exec>
    80004f38:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);
    80004f3a:	f4040993          	addi	s3,s0,-192
    80004f3e:	6088                	ld	a0,0(s1)
    80004f40:	c901                	beqz	a0,80004f50 <sys_exec+0xf6>
    80004f42:	ffffb097          	auipc	ra,0xffffb
    80004f46:	0da080e7          	jalr	218(ra) # 8000001c <kfree>
    80004f4a:	04a1                	addi	s1,s1,8
    80004f4c:	ff3499e3          	bne	s1,s3,80004f3e <sys_exec+0xe4>
  return ret;
    80004f50:	854a                	mv	a0,s2
    80004f52:	a011                	j	80004f56 <sys_exec+0xfc>
  return -1;
    80004f54:	557d                	li	a0,-1
}
    80004f56:	60be                	ld	ra,456(sp)
    80004f58:	641e                	ld	s0,448(sp)
    80004f5a:	74fa                	ld	s1,440(sp)
    80004f5c:	795a                	ld	s2,432(sp)
    80004f5e:	79ba                	ld	s3,424(sp)
    80004f60:	7a1a                	ld	s4,416(sp)
    80004f62:	6afa                	ld	s5,408(sp)
    80004f64:	6179                	addi	sp,sp,464
    80004f66:	8082                	ret

0000000080004f68 <sys_pipe>:

uint64 sys_pipe(void) {
    80004f68:	7139                	addi	sp,sp,-64
    80004f6a:	fc06                	sd	ra,56(sp)
    80004f6c:	f822                	sd	s0,48(sp)
    80004f6e:	f426                	sd	s1,40(sp)
    80004f70:	0080                	addi	s0,sp,64
  uint64 fdarray;  // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f72:	ffffc097          	auipc	ra,0xffffc
    80004f76:	f7a080e7          	jalr	-134(ra) # 80000eec <myproc>
    80004f7a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004f7c:	fd840593          	addi	a1,s0,-40
    80004f80:	4501                	li	a0,0
    80004f82:	ffffd097          	auipc	ra,0xffffd
    80004f86:	0b6080e7          	jalr	182(ra) # 80002038 <argaddr>
  if (pipealloc(&rf, &wf) < 0) return -1;
    80004f8a:	fc840593          	addi	a1,s0,-56
    80004f8e:	fd040513          	addi	a0,s0,-48
    80004f92:	fffff097          	auipc	ra,0xfffff
    80004f96:	dc2080e7          	jalr	-574(ra) # 80003d54 <pipealloc>
    80004f9a:	57fd                	li	a5,-1
    80004f9c:	0c054463          	bltz	a0,80005064 <sys_pipe+0xfc>
  fd0 = -1;
    80004fa0:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    80004fa4:	fd043503          	ld	a0,-48(s0)
    80004fa8:	fffff097          	auipc	ra,0xfffff
    80004fac:	514080e7          	jalr	1300(ra) # 800044bc <fdalloc>
    80004fb0:	fca42223          	sw	a0,-60(s0)
    80004fb4:	08054b63          	bltz	a0,8000504a <sys_pipe+0xe2>
    80004fb8:	fc843503          	ld	a0,-56(s0)
    80004fbc:	fffff097          	auipc	ra,0xfffff
    80004fc0:	500080e7          	jalr	1280(ra) # 800044bc <fdalloc>
    80004fc4:	fca42023          	sw	a0,-64(s0)
    80004fc8:	06054863          	bltz	a0,80005038 <sys_pipe+0xd0>
    if (fd0 >= 0) p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80004fcc:	4691                	li	a3,4
    80004fce:	fc440613          	addi	a2,s0,-60
    80004fd2:	fd843583          	ld	a1,-40(s0)
    80004fd6:	68a8                	ld	a0,80(s1)
    80004fd8:	ffffc097          	auipc	ra,0xffffc
    80004fdc:	ba0080e7          	jalr	-1120(ra) # 80000b78 <copyout>
    80004fe0:	02054063          	bltz	a0,80005000 <sys_pipe+0x98>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) <
    80004fe4:	4691                	li	a3,4
    80004fe6:	fc040613          	addi	a2,s0,-64
    80004fea:	fd843583          	ld	a1,-40(s0)
    80004fee:	0591                	addi	a1,a1,4
    80004ff0:	68a8                	ld	a0,80(s1)
    80004ff2:	ffffc097          	auipc	ra,0xffffc
    80004ff6:	b86080e7          	jalr	-1146(ra) # 80000b78 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004ffa:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80004ffc:	06055463          	bgez	a0,80005064 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005000:	fc442783          	lw	a5,-60(s0)
    80005004:	07e9                	addi	a5,a5,26
    80005006:	078e                	slli	a5,a5,0x3
    80005008:	97a6                	add	a5,a5,s1
    8000500a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000500e:	fc042783          	lw	a5,-64(s0)
    80005012:	07e9                	addi	a5,a5,26
    80005014:	078e                	slli	a5,a5,0x3
    80005016:	94be                	add	s1,s1,a5
    80005018:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000501c:	fd043503          	ld	a0,-48(s0)
    80005020:	fffff097          	auipc	ra,0xfffff
    80005024:	a04080e7          	jalr	-1532(ra) # 80003a24 <fileclose>
    fileclose(wf);
    80005028:	fc843503          	ld	a0,-56(s0)
    8000502c:	fffff097          	auipc	ra,0xfffff
    80005030:	9f8080e7          	jalr	-1544(ra) # 80003a24 <fileclose>
    return -1;
    80005034:	57fd                	li	a5,-1
    80005036:	a03d                	j	80005064 <sys_pipe+0xfc>
    if (fd0 >= 0) p->ofile[fd0] = 0;
    80005038:	fc442783          	lw	a5,-60(s0)
    8000503c:	0007c763          	bltz	a5,8000504a <sys_pipe+0xe2>
    80005040:	07e9                	addi	a5,a5,26
    80005042:	078e                	slli	a5,a5,0x3
    80005044:	97a6                	add	a5,a5,s1
    80005046:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000504a:	fd043503          	ld	a0,-48(s0)
    8000504e:	fffff097          	auipc	ra,0xfffff
    80005052:	9d6080e7          	jalr	-1578(ra) # 80003a24 <fileclose>
    fileclose(wf);
    80005056:	fc843503          	ld	a0,-56(s0)
    8000505a:	fffff097          	auipc	ra,0xfffff
    8000505e:	9ca080e7          	jalr	-1590(ra) # 80003a24 <fileclose>
    return -1;
    80005062:	57fd                	li	a5,-1
}
    80005064:	853e                	mv	a0,a5
    80005066:	70e2                	ld	ra,56(sp)
    80005068:	7442                	ld	s0,48(sp)
    8000506a:	74a2                	ld	s1,40(sp)
    8000506c:	6121                	addi	sp,sp,64
    8000506e:	8082                	ret

0000000080005070 <kernelvec>:
    80005070:	7111                	addi	sp,sp,-256
    80005072:	e006                	sd	ra,0(sp)
    80005074:	e40a                	sd	sp,8(sp)
    80005076:	e80e                	sd	gp,16(sp)
    80005078:	ec12                	sd	tp,24(sp)
    8000507a:	f016                	sd	t0,32(sp)
    8000507c:	f41a                	sd	t1,40(sp)
    8000507e:	f81e                	sd	t2,48(sp)
    80005080:	fc22                	sd	s0,56(sp)
    80005082:	e0a6                	sd	s1,64(sp)
    80005084:	e4aa                	sd	a0,72(sp)
    80005086:	e8ae                	sd	a1,80(sp)
    80005088:	ecb2                	sd	a2,88(sp)
    8000508a:	f0b6                	sd	a3,96(sp)
    8000508c:	f4ba                	sd	a4,104(sp)
    8000508e:	f8be                	sd	a5,112(sp)
    80005090:	fcc2                	sd	a6,120(sp)
    80005092:	e146                	sd	a7,128(sp)
    80005094:	e54a                	sd	s2,136(sp)
    80005096:	e94e                	sd	s3,144(sp)
    80005098:	ed52                	sd	s4,152(sp)
    8000509a:	f156                	sd	s5,160(sp)
    8000509c:	f55a                	sd	s6,168(sp)
    8000509e:	f95e                	sd	s7,176(sp)
    800050a0:	fd62                	sd	s8,184(sp)
    800050a2:	e1e6                	sd	s9,192(sp)
    800050a4:	e5ea                	sd	s10,200(sp)
    800050a6:	e9ee                	sd	s11,208(sp)
    800050a8:	edf2                	sd	t3,216(sp)
    800050aa:	f1f6                	sd	t4,224(sp)
    800050ac:	f5fa                	sd	t5,232(sp)
    800050ae:	f9fe                	sd	t6,240(sp)
    800050b0:	d97fc0ef          	jal	ra,80001e46 <kerneltrap>
    800050b4:	6082                	ld	ra,0(sp)
    800050b6:	6122                	ld	sp,8(sp)
    800050b8:	61c2                	ld	gp,16(sp)
    800050ba:	7282                	ld	t0,32(sp)
    800050bc:	7322                	ld	t1,40(sp)
    800050be:	73c2                	ld	t2,48(sp)
    800050c0:	7462                	ld	s0,56(sp)
    800050c2:	6486                	ld	s1,64(sp)
    800050c4:	6526                	ld	a0,72(sp)
    800050c6:	65c6                	ld	a1,80(sp)
    800050c8:	6666                	ld	a2,88(sp)
    800050ca:	7686                	ld	a3,96(sp)
    800050cc:	7726                	ld	a4,104(sp)
    800050ce:	77c6                	ld	a5,112(sp)
    800050d0:	7866                	ld	a6,120(sp)
    800050d2:	688a                	ld	a7,128(sp)
    800050d4:	692a                	ld	s2,136(sp)
    800050d6:	69ca                	ld	s3,144(sp)
    800050d8:	6a6a                	ld	s4,152(sp)
    800050da:	7a8a                	ld	s5,160(sp)
    800050dc:	7b2a                	ld	s6,168(sp)
    800050de:	7bca                	ld	s7,176(sp)
    800050e0:	7c6a                	ld	s8,184(sp)
    800050e2:	6c8e                	ld	s9,192(sp)
    800050e4:	6d2e                	ld	s10,200(sp)
    800050e6:	6dce                	ld	s11,208(sp)
    800050e8:	6e6e                	ld	t3,216(sp)
    800050ea:	7e8e                	ld	t4,224(sp)
    800050ec:	7f2e                	ld	t5,232(sp)
    800050ee:	7fce                	ld	t6,240(sp)
    800050f0:	6111                	addi	sp,sp,256
    800050f2:	10200073          	sret
    800050f6:	00000013          	nop
    800050fa:	00000013          	nop
    800050fe:	0001                	nop

0000000080005100 <timervec>:
    80005100:	34051573          	csrrw	a0,mscratch,a0
    80005104:	e10c                	sd	a1,0(a0)
    80005106:	e510                	sd	a2,8(a0)
    80005108:	e914                	sd	a3,16(a0)
    8000510a:	6d0c                	ld	a1,24(a0)
    8000510c:	7110                	ld	a2,32(a0)
    8000510e:	6194                	ld	a3,0(a1)
    80005110:	96b2                	add	a3,a3,a2
    80005112:	e194                	sd	a3,0(a1)
    80005114:	4589                	li	a1,2
    80005116:	14459073          	csrw	sip,a1
    8000511a:	6914                	ld	a3,16(a0)
    8000511c:	6510                	ld	a2,8(a0)
    8000511e:	610c                	ld	a1,0(a0)
    80005120:	34051573          	csrrw	a0,mscratch,a0
    80005124:	30200073          	mret
	...

000000008000512a <plicinit>:

//
// the riscv Platform Level Interrupt Controller (PLIC).
//

void plicinit(void) {
    8000512a:	1141                	addi	sp,sp,-16
    8000512c:	e422                	sd	s0,8(sp)
    8000512e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ * 4) = 1;
    80005130:	0c0007b7          	lui	a5,0xc000
    80005134:	4705                	li	a4,1
    80005136:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ * 4) = 1;
    80005138:	c3d8                	sw	a4,4(a5)
    8000513a:	0791                	addi	a5,a5,4 # c000004 <_entry-0x73fffffc>

  for (int irq = 1; irq < 0x35; irq++) {
    *(uint32*)(PLIC + irq * 4) = 1;
    8000513c:	4685                	li	a3,1
  for (int irq = 1; irq < 0x35; irq++) {
    8000513e:	0c000737          	lui	a4,0xc000
    80005142:	0d470713          	addi	a4,a4,212 # c0000d4 <_entry-0x73ffff2c>
    *(uint32*)(PLIC + irq * 4) = 1;
    80005146:	c394                	sw	a3,0(a5)
  for (int irq = 1; irq < 0x35; irq++) {
    80005148:	0791                	addi	a5,a5,4
    8000514a:	fee79ee3          	bne	a5,a4,80005146 <plicinit+0x1c>
  }
}
    8000514e:	6422                	ld	s0,8(sp)
    80005150:	0141                	addi	sp,sp,16
    80005152:	8082                	ret

0000000080005154 <plicinithart>:

void plicinithart(void) {
    80005154:	1141                	addi	sp,sp,-16
    80005156:	e406                	sd	ra,8(sp)
    80005158:	e022                	sd	s0,0(sp)
    8000515a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000515c:	ffffc097          	auipc	ra,0xffffc
    80005160:	d64080e7          	jalr	-668(ra) # 80000ec0 <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005164:	0085171b          	slliw	a4,a0,0x8
    80005168:	0c0027b7          	lui	a5,0xc002
    8000516c:	97ba                	add	a5,a5,a4
    8000516e:	40200713          	li	a4,1026
    80005172:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  *(uint32*)(PLIC_SENABLE(hart) + 4) = 0xffffffff;
    80005176:	577d                	li	a4,-1
    80005178:	08e7a223          	sw	a4,132(a5)

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    8000517c:	00d5151b          	slliw	a0,a0,0xd
    80005180:	0c2017b7          	lui	a5,0xc201
    80005184:	97aa                	add	a5,a5,a0
    80005186:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    8000518a:	60a2                	ld	ra,8(sp)
    8000518c:	6402                	ld	s0,0(sp)
    8000518e:	0141                	addi	sp,sp,16
    80005190:	8082                	ret

0000000080005192 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int plic_claim(void) {
    80005192:	1141                	addi	sp,sp,-16
    80005194:	e406                	sd	ra,8(sp)
    80005196:	e022                	sd	s0,0(sp)
    80005198:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000519a:	ffffc097          	auipc	ra,0xffffc
    8000519e:	d26080e7          	jalr	-730(ra) # 80000ec0 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051a2:	00d5151b          	slliw	a0,a0,0xd
    800051a6:	0c2017b7          	lui	a5,0xc201
    800051aa:	97aa                	add	a5,a5,a0
  return irq;
}
    800051ac:	43c8                	lw	a0,4(a5)
    800051ae:	60a2                	ld	ra,8(sp)
    800051b0:	6402                	ld	s0,0(sp)
    800051b2:	0141                	addi	sp,sp,16
    800051b4:	8082                	ret

00000000800051b6 <plic_complete>:

// tell the PLIC we've served this IRQ.
void plic_complete(int irq) {
    800051b6:	1101                	addi	sp,sp,-32
    800051b8:	ec06                	sd	ra,24(sp)
    800051ba:	e822                	sd	s0,16(sp)
    800051bc:	e426                	sd	s1,8(sp)
    800051be:	1000                	addi	s0,sp,32
    800051c0:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051c2:	ffffc097          	auipc	ra,0xffffc
    800051c6:	cfe080e7          	jalr	-770(ra) # 80000ec0 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051ca:	00d5151b          	slliw	a0,a0,0xd
    800051ce:	0c2017b7          	lui	a5,0xc201
    800051d2:	97aa                	add	a5,a5,a0
    800051d4:	c3c4                	sw	s1,4(a5)
}
    800051d6:	60e2                	ld	ra,24(sp)
    800051d8:	6442                	ld	s0,16(sp)
    800051da:	64a2                	ld	s1,8(sp)
    800051dc:	6105                	addi	sp,sp,32
    800051de:	8082                	ret

00000000800051e0 <free_desc>:
  }
  return -1;
}

// mark a descriptor as free.
static void free_desc(int i) {
    800051e0:	1141                	addi	sp,sp,-16
    800051e2:	e406                	sd	ra,8(sp)
    800051e4:	e022                	sd	s0,0(sp)
    800051e6:	0800                	addi	s0,sp,16
  if (i >= NUM) panic("free_desc 1");
    800051e8:	479d                	li	a5,7
    800051ea:	04a7cc63          	blt	a5,a0,80005242 <free_desc+0x62>
  if (disk.free[i]) panic("free_desc 2");
    800051ee:	00016797          	auipc	a5,0x16
    800051f2:	95278793          	addi	a5,a5,-1710 # 8001ab40 <disk>
    800051f6:	97aa                	add	a5,a5,a0
    800051f8:	0187c783          	lbu	a5,24(a5)
    800051fc:	ebb9                	bnez	a5,80005252 <free_desc+0x72>
  disk.desc[i].addr = 0;
    800051fe:	00451693          	slli	a3,a0,0x4
    80005202:	00016797          	auipc	a5,0x16
    80005206:	93e78793          	addi	a5,a5,-1730 # 8001ab40 <disk>
    8000520a:	6398                	ld	a4,0(a5)
    8000520c:	9736                	add	a4,a4,a3
    8000520e:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005212:	6398                	ld	a4,0(a5)
    80005214:	9736                	add	a4,a4,a3
    80005216:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000521a:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    8000521e:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005222:	97aa                	add	a5,a5,a0
    80005224:	4705                	li	a4,1
    80005226:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000522a:	00016517          	auipc	a0,0x16
    8000522e:	92e50513          	addi	a0,a0,-1746 # 8001ab58 <disk+0x18>
    80005232:	ffffc097          	auipc	ra,0xffffc
    80005236:	3ca080e7          	jalr	970(ra) # 800015fc <wakeup>
}
    8000523a:	60a2                	ld	ra,8(sp)
    8000523c:	6402                	ld	s0,0(sp)
    8000523e:	0141                	addi	sp,sp,16
    80005240:	8082                	ret
  if (i >= NUM) panic("free_desc 1");
    80005242:	00004517          	auipc	a0,0x4
    80005246:	4de50513          	addi	a0,a0,1246 # 80009720 <syscalls+0x310>
    8000524a:	00001097          	auipc	ra,0x1
    8000524e:	794080e7          	jalr	1940(ra) # 800069de <panic>
  if (disk.free[i]) panic("free_desc 2");
    80005252:	00004517          	auipc	a0,0x4
    80005256:	4de50513          	addi	a0,a0,1246 # 80009730 <syscalls+0x320>
    8000525a:	00001097          	auipc	ra,0x1
    8000525e:	784080e7          	jalr	1924(ra) # 800069de <panic>

0000000080005262 <virtio_disk_init>:
void virtio_disk_init(void) {
    80005262:	1101                	addi	sp,sp,-32
    80005264:	ec06                	sd	ra,24(sp)
    80005266:	e822                	sd	s0,16(sp)
    80005268:	e426                	sd	s1,8(sp)
    8000526a:	e04a                	sd	s2,0(sp)
    8000526c:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000526e:	00004597          	auipc	a1,0x4
    80005272:	4d258593          	addi	a1,a1,1234 # 80009740 <syscalls+0x330>
    80005276:	00016517          	auipc	a0,0x16
    8000527a:	9f250513          	addi	a0,a0,-1550 # 8001ac68 <disk+0x128>
    8000527e:	00002097          	auipc	ra,0x2
    80005282:	c08080e7          	jalr	-1016(ra) # 80006e86 <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005286:	100017b7          	lui	a5,0x10001
    8000528a:	4398                	lw	a4,0(a5)
    8000528c:	2701                	sext.w	a4,a4
    8000528e:	747277b7          	lui	a5,0x74727
    80005292:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005296:	14f71b63          	bne	a4,a5,800053ec <virtio_disk_init+0x18a>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000529a:	100017b7          	lui	a5,0x10001
    8000529e:	43dc                	lw	a5,4(a5)
    800052a0:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052a2:	4709                	li	a4,2
    800052a4:	14e79463          	bne	a5,a4,800053ec <virtio_disk_init+0x18a>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052a8:	100017b7          	lui	a5,0x10001
    800052ac:	479c                	lw	a5,8(a5)
    800052ae:	2781                	sext.w	a5,a5
    800052b0:	12e79e63          	bne	a5,a4,800053ec <virtio_disk_init+0x18a>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    800052b4:	100017b7          	lui	a5,0x10001
    800052b8:	47d8                	lw	a4,12(a5)
    800052ba:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052bc:	554d47b7          	lui	a5,0x554d4
    800052c0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052c4:	12f71463          	bne	a4,a5,800053ec <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052c8:	100017b7          	lui	a5,0x10001
    800052cc:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052d0:	4705                	li	a4,1
    800052d2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052d4:	470d                	li	a4,3
    800052d6:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052d8:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052da:	c7ffe6b7          	lui	a3,0xc7ffe
    800052de:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47f0b3af>
    800052e2:	8f75                	and	a4,a4,a3
    800052e4:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052e6:	472d                	li	a4,11
    800052e8:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800052ea:	5bbc                	lw	a5,112(a5)
    800052ec:	0007891b          	sext.w	s2,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800052f0:	8ba1                	andi	a5,a5,8
    800052f2:	10078563          	beqz	a5,800053fc <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052f6:	100017b7          	lui	a5,0x10001
    800052fa:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY)) panic("virtio disk should not be ready");
    800052fe:	43fc                	lw	a5,68(a5)
    80005300:	2781                	sext.w	a5,a5
    80005302:	10079563          	bnez	a5,8000540c <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005306:	100017b7          	lui	a5,0x10001
    8000530a:	5bdc                	lw	a5,52(a5)
    8000530c:	2781                	sext.w	a5,a5
  if (max == 0) panic("virtio disk has no queue 0");
    8000530e:	10078763          	beqz	a5,8000541c <virtio_disk_init+0x1ba>
  if (max < NUM) panic("virtio disk max queue too short");
    80005312:	471d                	li	a4,7
    80005314:	10f77c63          	bgeu	a4,a5,8000542c <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    80005318:	ffffb097          	auipc	ra,0xffffb
    8000531c:	e02080e7          	jalr	-510(ra) # 8000011a <kalloc>
    80005320:	00016497          	auipc	s1,0x16
    80005324:	82048493          	addi	s1,s1,-2016 # 8001ab40 <disk>
    80005328:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    8000532a:	ffffb097          	auipc	ra,0xffffb
    8000532e:	df0080e7          	jalr	-528(ra) # 8000011a <kalloc>
    80005332:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005334:	ffffb097          	auipc	ra,0xffffb
    80005338:	de6080e7          	jalr	-538(ra) # 8000011a <kalloc>
    8000533c:	87aa                	mv	a5,a0
    8000533e:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used) panic("virtio disk kalloc");
    80005340:	6088                	ld	a0,0(s1)
    80005342:	cd6d                	beqz	a0,8000543c <virtio_disk_init+0x1da>
    80005344:	00016717          	auipc	a4,0x16
    80005348:	80473703          	ld	a4,-2044(a4) # 8001ab48 <disk+0x8>
    8000534c:	cb65                	beqz	a4,8000543c <virtio_disk_init+0x1da>
    8000534e:	c7fd                	beqz	a5,8000543c <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005350:	6605                	lui	a2,0x1
    80005352:	4581                	li	a1,0
    80005354:	ffffb097          	auipc	ra,0xffffb
    80005358:	e26080e7          	jalr	-474(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    8000535c:	00015497          	auipc	s1,0x15
    80005360:	7e448493          	addi	s1,s1,2020 # 8001ab40 <disk>
    80005364:	6605                	lui	a2,0x1
    80005366:	4581                	li	a1,0
    80005368:	6488                	ld	a0,8(s1)
    8000536a:	ffffb097          	auipc	ra,0xffffb
    8000536e:	e10080e7          	jalr	-496(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    80005372:	6605                	lui	a2,0x1
    80005374:	4581                	li	a1,0
    80005376:	6888                	ld	a0,16(s1)
    80005378:	ffffb097          	auipc	ra,0xffffb
    8000537c:	e02080e7          	jalr	-510(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005380:	100017b7          	lui	a5,0x10001
    80005384:	4721                	li	a4,8
    80005386:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005388:	4098                	lw	a4,0(s1)
    8000538a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000538e:	40d8                	lw	a4,4(s1)
    80005390:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005394:	6498                	ld	a4,8(s1)
    80005396:	0007069b          	sext.w	a3,a4
    8000539a:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8000539e:	9701                	srai	a4,a4,0x20
    800053a0:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800053a4:	6898                	ld	a4,16(s1)
    800053a6:	0007069b          	sext.w	a3,a4
    800053aa:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800053ae:	9701                	srai	a4,a4,0x20
    800053b0:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800053b4:	4705                	li	a4,1
    800053b6:	c3f8                	sw	a4,68(a5)
  for (int i = 0; i < NUM; i++) disk.free[i] = 1;
    800053b8:	00e48c23          	sb	a4,24(s1)
    800053bc:	00e48ca3          	sb	a4,25(s1)
    800053c0:	00e48d23          	sb	a4,26(s1)
    800053c4:	00e48da3          	sb	a4,27(s1)
    800053c8:	00e48e23          	sb	a4,28(s1)
    800053cc:	00e48ea3          	sb	a4,29(s1)
    800053d0:	00e48f23          	sb	a4,30(s1)
    800053d4:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800053d8:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800053dc:	0727a823          	sw	s2,112(a5)
}
    800053e0:	60e2                	ld	ra,24(sp)
    800053e2:	6442                	ld	s0,16(sp)
    800053e4:	64a2                	ld	s1,8(sp)
    800053e6:	6902                	ld	s2,0(sp)
    800053e8:	6105                	addi	sp,sp,32
    800053ea:	8082                	ret
    panic("could not find virtio disk");
    800053ec:	00004517          	auipc	a0,0x4
    800053f0:	36450513          	addi	a0,a0,868 # 80009750 <syscalls+0x340>
    800053f4:	00001097          	auipc	ra,0x1
    800053f8:	5ea080e7          	jalr	1514(ra) # 800069de <panic>
    panic("virtio disk FEATURES_OK unset");
    800053fc:	00004517          	auipc	a0,0x4
    80005400:	37450513          	addi	a0,a0,884 # 80009770 <syscalls+0x360>
    80005404:	00001097          	auipc	ra,0x1
    80005408:	5da080e7          	jalr	1498(ra) # 800069de <panic>
  if (*R(VIRTIO_MMIO_QUEUE_READY)) panic("virtio disk should not be ready");
    8000540c:	00004517          	auipc	a0,0x4
    80005410:	38450513          	addi	a0,a0,900 # 80009790 <syscalls+0x380>
    80005414:	00001097          	auipc	ra,0x1
    80005418:	5ca080e7          	jalr	1482(ra) # 800069de <panic>
  if (max == 0) panic("virtio disk has no queue 0");
    8000541c:	00004517          	auipc	a0,0x4
    80005420:	39450513          	addi	a0,a0,916 # 800097b0 <syscalls+0x3a0>
    80005424:	00001097          	auipc	ra,0x1
    80005428:	5ba080e7          	jalr	1466(ra) # 800069de <panic>
  if (max < NUM) panic("virtio disk max queue too short");
    8000542c:	00004517          	auipc	a0,0x4
    80005430:	3a450513          	addi	a0,a0,932 # 800097d0 <syscalls+0x3c0>
    80005434:	00001097          	auipc	ra,0x1
    80005438:	5aa080e7          	jalr	1450(ra) # 800069de <panic>
  if (!disk.desc || !disk.avail || !disk.used) panic("virtio disk kalloc");
    8000543c:	00004517          	auipc	a0,0x4
    80005440:	3b450513          	addi	a0,a0,948 # 800097f0 <syscalls+0x3e0>
    80005444:	00001097          	auipc	ra,0x1
    80005448:	59a080e7          	jalr	1434(ra) # 800069de <panic>

000000008000544c <virtio_disk_rw>:
    }
  }
  return 0;
}

void virtio_disk_rw(struct buf *b, int write) {
    8000544c:	7119                	addi	sp,sp,-128
    8000544e:	fc86                	sd	ra,120(sp)
    80005450:	f8a2                	sd	s0,112(sp)
    80005452:	f4a6                	sd	s1,104(sp)
    80005454:	f0ca                	sd	s2,96(sp)
    80005456:	ecce                	sd	s3,88(sp)
    80005458:	e8d2                	sd	s4,80(sp)
    8000545a:	e4d6                	sd	s5,72(sp)
    8000545c:	e0da                	sd	s6,64(sp)
    8000545e:	fc5e                	sd	s7,56(sp)
    80005460:	f862                	sd	s8,48(sp)
    80005462:	f466                	sd	s9,40(sp)
    80005464:	f06a                	sd	s10,32(sp)
    80005466:	ec6e                	sd	s11,24(sp)
    80005468:	0100                	addi	s0,sp,128
    8000546a:	8aaa                	mv	s5,a0
    8000546c:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000546e:	00c52d03          	lw	s10,12(a0)
    80005472:	001d1d1b          	slliw	s10,s10,0x1
    80005476:	1d02                	slli	s10,s10,0x20
    80005478:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    8000547c:	00015517          	auipc	a0,0x15
    80005480:	7ec50513          	addi	a0,a0,2028 # 8001ac68 <disk+0x128>
    80005484:	00002097          	auipc	ra,0x2
    80005488:	a92080e7          	jalr	-1390(ra) # 80006f16 <acquire>
  for (int i = 0; i < 3; i++) {
    8000548c:	4981                	li	s3,0
  for (int i = 0; i < NUM; i++) {
    8000548e:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005490:	00015b97          	auipc	s7,0x15
    80005494:	6b0b8b93          	addi	s7,s7,1712 # 8001ab40 <disk>
  for (int i = 0; i < 3; i++) {
    80005498:	4b0d                	li	s6,3
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000549a:	00015c97          	auipc	s9,0x15
    8000549e:	7cec8c93          	addi	s9,s9,1998 # 8001ac68 <disk+0x128>
    800054a2:	a08d                	j	80005504 <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800054a4:	00fb8733          	add	a4,s7,a5
    800054a8:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800054ac:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    800054ae:	0207c563          	bltz	a5,800054d8 <virtio_disk_rw+0x8c>
  for (int i = 0; i < 3; i++) {
    800054b2:	2905                	addiw	s2,s2,1
    800054b4:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800054b6:	05690c63          	beq	s2,s6,8000550e <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800054ba:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    800054bc:	00015717          	auipc	a4,0x15
    800054c0:	68470713          	addi	a4,a4,1668 # 8001ab40 <disk>
    800054c4:	87ce                	mv	a5,s3
    if (disk.free[i]) {
    800054c6:	01874683          	lbu	a3,24(a4)
    800054ca:	fee9                	bnez	a3,800054a4 <virtio_disk_rw+0x58>
  for (int i = 0; i < NUM; i++) {
    800054cc:	2785                	addiw	a5,a5,1
    800054ce:	0705                	addi	a4,a4,1
    800054d0:	fe979be3          	bne	a5,s1,800054c6 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800054d4:	57fd                	li	a5,-1
    800054d6:	c19c                	sw	a5,0(a1)
      for (int j = 0; j < i; j++) free_desc(idx[j]);
    800054d8:	01205d63          	blez	s2,800054f2 <virtio_disk_rw+0xa6>
    800054dc:	8dce                	mv	s11,s3
    800054de:	000a2503          	lw	a0,0(s4)
    800054e2:	00000097          	auipc	ra,0x0
    800054e6:	cfe080e7          	jalr	-770(ra) # 800051e0 <free_desc>
    800054ea:	2d85                	addiw	s11,s11,1
    800054ec:	0a11                	addi	s4,s4,4
    800054ee:	ff2d98e3          	bne	s11,s2,800054de <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054f2:	85e6                	mv	a1,s9
    800054f4:	00015517          	auipc	a0,0x15
    800054f8:	66450513          	addi	a0,a0,1636 # 8001ab58 <disk+0x18>
    800054fc:	ffffc097          	auipc	ra,0xffffc
    80005500:	09c080e7          	jalr	156(ra) # 80001598 <sleep>
  for (int i = 0; i < 3; i++) {
    80005504:	f8040a13          	addi	s4,s0,-128
void virtio_disk_rw(struct buf *b, int write) {
    80005508:	8652                	mv	a2,s4
  for (int i = 0; i < 3; i++) {
    8000550a:	894e                	mv	s2,s3
    8000550c:	b77d                	j	800054ba <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000550e:	f8042503          	lw	a0,-128(s0)
    80005512:	00a50713          	addi	a4,a0,10
    80005516:	0712                	slli	a4,a4,0x4

  if (write)
    80005518:	00015797          	auipc	a5,0x15
    8000551c:	62878793          	addi	a5,a5,1576 # 8001ab40 <disk>
    80005520:	00e786b3          	add	a3,a5,a4
    80005524:	01803633          	snez	a2,s8
    80005528:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT;  // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN;  // read the disk
  buf0->reserved = 0;
    8000552a:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    8000552e:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64)buf0;
    80005532:	f6070613          	addi	a2,a4,-160
    80005536:	6394                	ld	a3,0(a5)
    80005538:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000553a:	00870593          	addi	a1,a4,8
    8000553e:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    80005540:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005542:	0007b803          	ld	a6,0(a5)
    80005546:	9642                	add	a2,a2,a6
    80005548:	46c1                	li	a3,16
    8000554a:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000554c:	4585                	li	a1,1
    8000554e:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005552:	f8442683          	lw	a3,-124(s0)
    80005556:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64)b->data;
    8000555a:	0692                	slli	a3,a3,0x4
    8000555c:	9836                	add	a6,a6,a3
    8000555e:	058a8613          	addi	a2,s5,88
    80005562:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    80005566:	0007b803          	ld	a6,0(a5)
    8000556a:	96c2                	add	a3,a3,a6
    8000556c:	40000613          	li	a2,1024
    80005570:	c690                	sw	a2,8(a3)
  if (write)
    80005572:	001c3613          	seqz	a2,s8
    80005576:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0;  // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE;  // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000557a:	00166613          	ori	a2,a2,1
    8000557e:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005582:	f8842603          	lw	a2,-120(s0)
    80005586:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff;  // device writes 0 on success
    8000558a:	00250693          	addi	a3,a0,2
    8000558e:	0692                	slli	a3,a3,0x4
    80005590:	96be                	add	a3,a3,a5
    80005592:	58fd                	li	a7,-1
    80005594:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    80005598:	0612                	slli	a2,a2,0x4
    8000559a:	9832                	add	a6,a6,a2
    8000559c:	f9070713          	addi	a4,a4,-112
    800055a0:	973e                	add	a4,a4,a5
    800055a2:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800055a6:	6398                	ld	a4,0(a5)
    800055a8:	9732                	add	a4,a4,a2
    800055aa:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE;  // device writes the status
    800055ac:	4609                	li	a2,2
    800055ae:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800055b2:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800055b6:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    800055ba:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800055be:	6794                	ld	a3,8(a5)
    800055c0:	0026d703          	lhu	a4,2(a3)
    800055c4:	8b1d                	andi	a4,a4,7
    800055c6:	0706                	slli	a4,a4,0x1
    800055c8:	96ba                	add	a3,a3,a4
    800055ca:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800055ce:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1;  // not % NUM ...
    800055d2:	6798                	ld	a4,8(a5)
    800055d4:	00275783          	lhu	a5,2(a4)
    800055d8:	2785                	addiw	a5,a5,1
    800055da:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800055de:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0;  // value is queue number
    800055e2:	100017b7          	lui	a5,0x10001
    800055e6:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    800055ea:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    800055ee:	00015917          	auipc	s2,0x15
    800055f2:	67a90913          	addi	s2,s2,1658 # 8001ac68 <disk+0x128>
  while (b->disk == 1) {
    800055f6:	4485                	li	s1,1
    800055f8:	00b79c63          	bne	a5,a1,80005610 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800055fc:	85ca                	mv	a1,s2
    800055fe:	8556                	mv	a0,s5
    80005600:	ffffc097          	auipc	ra,0xffffc
    80005604:	f98080e7          	jalr	-104(ra) # 80001598 <sleep>
  while (b->disk == 1) {
    80005608:	004aa783          	lw	a5,4(s5)
    8000560c:	fe9788e3          	beq	a5,s1,800055fc <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005610:	f8042903          	lw	s2,-128(s0)
    80005614:	00290713          	addi	a4,s2,2
    80005618:	0712                	slli	a4,a4,0x4
    8000561a:	00015797          	auipc	a5,0x15
    8000561e:	52678793          	addi	a5,a5,1318 # 8001ab40 <disk>
    80005622:	97ba                	add	a5,a5,a4
    80005624:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005628:	00015997          	auipc	s3,0x15
    8000562c:	51898993          	addi	s3,s3,1304 # 8001ab40 <disk>
    80005630:	00491713          	slli	a4,s2,0x4
    80005634:	0009b783          	ld	a5,0(s3)
    80005638:	97ba                	add	a5,a5,a4
    8000563a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000563e:	854a                	mv	a0,s2
    80005640:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005644:	00000097          	auipc	ra,0x0
    80005648:	b9c080e7          	jalr	-1124(ra) # 800051e0 <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    8000564c:	8885                	andi	s1,s1,1
    8000564e:	f0ed                	bnez	s1,80005630 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005650:	00015517          	auipc	a0,0x15
    80005654:	61850513          	addi	a0,a0,1560 # 8001ac68 <disk+0x128>
    80005658:	00002097          	auipc	ra,0x2
    8000565c:	972080e7          	jalr	-1678(ra) # 80006fca <release>
}
    80005660:	70e6                	ld	ra,120(sp)
    80005662:	7446                	ld	s0,112(sp)
    80005664:	74a6                	ld	s1,104(sp)
    80005666:	7906                	ld	s2,96(sp)
    80005668:	69e6                	ld	s3,88(sp)
    8000566a:	6a46                	ld	s4,80(sp)
    8000566c:	6aa6                	ld	s5,72(sp)
    8000566e:	6b06                	ld	s6,64(sp)
    80005670:	7be2                	ld	s7,56(sp)
    80005672:	7c42                	ld	s8,48(sp)
    80005674:	7ca2                	ld	s9,40(sp)
    80005676:	7d02                	ld	s10,32(sp)
    80005678:	6de2                	ld	s11,24(sp)
    8000567a:	6109                	addi	sp,sp,128
    8000567c:	8082                	ret

000000008000567e <virtio_disk_intr>:

void virtio_disk_intr() {
    8000567e:	1101                	addi	sp,sp,-32
    80005680:	ec06                	sd	ra,24(sp)
    80005682:	e822                	sd	s0,16(sp)
    80005684:	e426                	sd	s1,8(sp)
    80005686:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005688:	00015497          	auipc	s1,0x15
    8000568c:	4b848493          	addi	s1,s1,1208 # 8001ab40 <disk>
    80005690:	00015517          	auipc	a0,0x15
    80005694:	5d850513          	addi	a0,a0,1496 # 8001ac68 <disk+0x128>
    80005698:	00002097          	auipc	ra,0x2
    8000569c:	87e080e7          	jalr	-1922(ra) # 80006f16 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056a0:	10001737          	lui	a4,0x10001
    800056a4:	533c                	lw	a5,96(a4)
    800056a6:	8b8d                	andi	a5,a5,3
    800056a8:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056aa:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    800056ae:	689c                	ld	a5,16(s1)
    800056b0:	0204d703          	lhu	a4,32(s1)
    800056b4:	0027d783          	lhu	a5,2(a5)
    800056b8:	04f70863          	beq	a4,a5,80005708 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800056bc:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056c0:	6898                	ld	a4,16(s1)
    800056c2:	0204d783          	lhu	a5,32(s1)
    800056c6:	8b9d                	andi	a5,a5,7
    800056c8:	078e                	slli	a5,a5,0x3
    800056ca:	97ba                	add	a5,a5,a4
    800056cc:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0) panic("virtio_disk_intr status");
    800056ce:	00278713          	addi	a4,a5,2
    800056d2:	0712                	slli	a4,a4,0x4
    800056d4:	9726                	add	a4,a4,s1
    800056d6:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800056da:	e721                	bnez	a4,80005722 <virtio_disk_intr+0xa4>

    struct buf *b = disk.info[id].b;
    800056dc:	0789                	addi	a5,a5,2
    800056de:	0792                	slli	a5,a5,0x4
    800056e0:	97a6                	add	a5,a5,s1
    800056e2:	6788                	ld	a0,8(a5)
    b->disk = 0;  // disk is done with buf
    800056e4:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056e8:	ffffc097          	auipc	ra,0xffffc
    800056ec:	f14080e7          	jalr	-236(ra) # 800015fc <wakeup>

    disk.used_idx += 1;
    800056f0:	0204d783          	lhu	a5,32(s1)
    800056f4:	2785                	addiw	a5,a5,1
    800056f6:	17c2                	slli	a5,a5,0x30
    800056f8:	93c1                	srli	a5,a5,0x30
    800056fa:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    800056fe:	6898                	ld	a4,16(s1)
    80005700:	00275703          	lhu	a4,2(a4)
    80005704:	faf71ce3          	bne	a4,a5,800056bc <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005708:	00015517          	auipc	a0,0x15
    8000570c:	56050513          	addi	a0,a0,1376 # 8001ac68 <disk+0x128>
    80005710:	00002097          	auipc	ra,0x2
    80005714:	8ba080e7          	jalr	-1862(ra) # 80006fca <release>
}
    80005718:	60e2                	ld	ra,24(sp)
    8000571a:	6442                	ld	s0,16(sp)
    8000571c:	64a2                	ld	s1,8(sp)
    8000571e:	6105                	addi	sp,sp,32
    80005720:	8082                	ret
    if (disk.info[id].status != 0) panic("virtio_disk_intr status");
    80005722:	00004517          	auipc	a0,0x4
    80005726:	0e650513          	addi	a0,a0,230 # 80009808 <syscalls+0x3f8>
    8000572a:	00001097          	auipc	ra,0x1
    8000572e:	2b4080e7          	jalr	692(ra) # 800069de <panic>

0000000080005732 <e1000_init>:
void net_rx(char *buf, int len);

// called by pci_init().
// xregs is the memory address at which the
// e1000's registers are mapped.
void e1000_init(uint32 *xregs) {
    80005732:	7179                	addi	sp,sp,-48
    80005734:	f406                	sd	ra,40(sp)
    80005736:	f022                	sd	s0,32(sp)
    80005738:	ec26                	sd	s1,24(sp)
    8000573a:	e84a                	sd	s2,16(sp)
    8000573c:	e44e                	sd	s3,8(sp)
    8000573e:	1800                	addi	s0,sp,48
    80005740:	84aa                	mv	s1,a0
  int i;

  initlock(&e1000_tx_lock, "e1000_tx");
    80005742:	00004597          	auipc	a1,0x4
    80005746:	0de58593          	addi	a1,a1,222 # 80009820 <syscalls+0x410>
    8000574a:	00015517          	auipc	a0,0x15
    8000574e:	53650513          	addi	a0,a0,1334 # 8001ac80 <e1000_tx_lock>
    80005752:	00001097          	auipc	ra,0x1
    80005756:	734080e7          	jalr	1844(ra) # 80006e86 <initlock>
  initlock(&e1000_rx_lock, "e1000_rx");
    8000575a:	00004597          	auipc	a1,0x4
    8000575e:	0d658593          	addi	a1,a1,214 # 80009830 <syscalls+0x420>
    80005762:	00015517          	auipc	a0,0x15
    80005766:	53650513          	addi	a0,a0,1334 # 8001ac98 <e1000_rx_lock>
    8000576a:	00001097          	auipc	ra,0x1
    8000576e:	71c080e7          	jalr	1820(ra) # 80006e86 <initlock>

  regs = xregs;
    80005772:	00004797          	auipc	a5,0x4
    80005776:	2a97b723          	sd	s1,686(a5) # 80009a20 <regs>

  // Reset the device
  regs[E1000_IMS] = 0;  // disable interrupts
    8000577a:	0c04a823          	sw	zero,208(s1)
  regs[E1000_CTL] |= E1000_CTL_RST;
    8000577e:	409c                	lw	a5,0(s1)
    80005780:	04000737          	lui	a4,0x4000
    80005784:	8fd9                	or	a5,a5,a4
    80005786:	c09c                	sw	a5,0(s1)
  regs[E1000_IMS] = 0;  // redisable interrupts
    80005788:	0c04a823          	sw	zero,208(s1)
  __sync_synchronize();
    8000578c:	0ff0000f          	fence

  // [E1000 14.5] Transmit initialization
  memset(tx_ring, 0, sizeof(tx_ring));
    80005790:	10000613          	li	a2,256
    80005794:	4581                	li	a1,0
    80005796:	00015517          	auipc	a0,0x15
    8000579a:	51a50513          	addi	a0,a0,1306 # 8001acb0 <tx_ring>
    8000579e:	ffffb097          	auipc	ra,0xffffb
    800057a2:	9dc080e7          	jalr	-1572(ra) # 8000017a <memset>
  for (i = 0; i < TX_RING_SIZE; i++) {
    800057a6:	00015717          	auipc	a4,0x15
    800057aa:	51670713          	addi	a4,a4,1302 # 8001acbc <tx_ring+0xc>
    800057ae:	00015797          	auipc	a5,0x15
    800057b2:	60278793          	addi	a5,a5,1538 # 8001adb0 <tx_bufs>
    800057b6:	00015617          	auipc	a2,0x15
    800057ba:	67a60613          	addi	a2,a2,1658 # 8001ae30 <rx_ring>
    tx_ring[i].status = E1000_TXD_STAT_DD;
    800057be:	4685                	li	a3,1
    800057c0:	00d70023          	sb	a3,0(a4)
    tx_bufs[i] = 0;
    800057c4:	0007b023          	sd	zero,0(a5)
  for (i = 0; i < TX_RING_SIZE; i++) {
    800057c8:	0741                	addi	a4,a4,16
    800057ca:	07a1                	addi	a5,a5,8
    800057cc:	fec79ae3          	bne	a5,a2,800057c0 <e1000_init+0x8e>
  }
  regs[E1000_TDBAL] = (uint64)tx_ring;
    800057d0:	00015717          	auipc	a4,0x15
    800057d4:	4e070713          	addi	a4,a4,1248 # 8001acb0 <tx_ring>
    800057d8:	00004797          	auipc	a5,0x4
    800057dc:	2487b783          	ld	a5,584(a5) # 80009a20 <regs>
    800057e0:	6691                	lui	a3,0x4
    800057e2:	97b6                	add	a5,a5,a3
    800057e4:	80e7a023          	sw	a4,-2048(a5)
  if (sizeof(tx_ring) % 128 != 0) panic("e1000");
  regs[E1000_TDLEN] = sizeof(tx_ring);
    800057e8:	10000713          	li	a4,256
    800057ec:	80e7a423          	sw	a4,-2040(a5)
  regs[E1000_TDH] = regs[E1000_TDT] = 0;
    800057f0:	8007ac23          	sw	zero,-2024(a5)
    800057f4:	8007a823          	sw	zero,-2032(a5)

  // [E1000 14.4] Receive initialization
  memset(rx_ring, 0, sizeof(rx_ring));
    800057f8:	00015917          	auipc	s2,0x15
    800057fc:	63890913          	addi	s2,s2,1592 # 8001ae30 <rx_ring>
    80005800:	10000613          	li	a2,256
    80005804:	4581                	li	a1,0
    80005806:	854a                	mv	a0,s2
    80005808:	ffffb097          	auipc	ra,0xffffb
    8000580c:	972080e7          	jalr	-1678(ra) # 8000017a <memset>
  for (i = 0; i < RX_RING_SIZE; i++) {
    80005810:	00015497          	auipc	s1,0x15
    80005814:	72048493          	addi	s1,s1,1824 # 8001af30 <rx_bufs>
    80005818:	00015997          	auipc	s3,0x15
    8000581c:	79898993          	addi	s3,s3,1944 # 8001afb0 <netlock>
    rx_bufs[i] = kalloc();
    80005820:	ffffb097          	auipc	ra,0xffffb
    80005824:	8fa080e7          	jalr	-1798(ra) # 8000011a <kalloc>
    80005828:	e088                	sd	a0,0(s1)
    if (!rx_bufs[i]) panic("e1000");
    8000582a:	c55d                	beqz	a0,800058d8 <e1000_init+0x1a6>
    rx_ring[i].addr = (uint64)rx_bufs[i];
    8000582c:	00a93023          	sd	a0,0(s2)
  for (i = 0; i < RX_RING_SIZE; i++) {
    80005830:	04a1                	addi	s1,s1,8
    80005832:	0941                	addi	s2,s2,16
    80005834:	ff3496e3          	bne	s1,s3,80005820 <e1000_init+0xee>
  }
  regs[E1000_RDBAL] = (uint64)rx_ring;
    80005838:	00004697          	auipc	a3,0x4
    8000583c:	1e86b683          	ld	a3,488(a3) # 80009a20 <regs>
    80005840:	00015717          	auipc	a4,0x15
    80005844:	5f070713          	addi	a4,a4,1520 # 8001ae30 <rx_ring>
    80005848:	678d                	lui	a5,0x3
    8000584a:	97b6                	add	a5,a5,a3
    8000584c:	80e7a023          	sw	a4,-2048(a5) # 2800 <_entry-0x7fffd800>
  if (sizeof(rx_ring) % 128 != 0) panic("e1000");
  regs[E1000_RDH] = 0;
    80005850:	8007a823          	sw	zero,-2032(a5)
  regs[E1000_RDT] = RX_RING_SIZE - 1;
    80005854:	473d                	li	a4,15
    80005856:	80e7ac23          	sw	a4,-2024(a5)
  regs[E1000_RDLEN] = sizeof(rx_ring);
    8000585a:	10000713          	li	a4,256
    8000585e:	80e7a423          	sw	a4,-2040(a5)

  // filter by qemu's MAC address, 52:54:00:12:34:56
  regs[E1000_RA] = 0x12005452;
    80005862:	6715                	lui	a4,0x5
    80005864:	00e68633          	add	a2,a3,a4
    80005868:	120057b7          	lui	a5,0x12005
    8000586c:	45278793          	addi	a5,a5,1106 # 12005452 <_entry-0x6dffabae>
    80005870:	40f62023          	sw	a5,1024(a2)
  regs[E1000_RA + 1] = 0x5634 | (1 << 31);
    80005874:	800057b7          	lui	a5,0x80005
    80005878:	63478793          	addi	a5,a5,1588 # ffffffff80005634 <end+0xfffffffefff12284>
    8000587c:	40f62223          	sw	a5,1028(a2)
  // multicast table
  for (int i = 0; i < 4096 / 32; i++) regs[E1000_MTA + i] = 0;
    80005880:	20070793          	addi	a5,a4,512 # 5200 <_entry-0x7fffae00>
    80005884:	97b6                	add	a5,a5,a3
    80005886:	40070713          	addi	a4,a4,1024
    8000588a:	9736                	add	a4,a4,a3
    8000588c:	0007a023          	sw	zero,0(a5)
    80005890:	0791                	addi	a5,a5,4
    80005892:	fee79de3          	bne	a5,a4,8000588c <e1000_init+0x15a>

  // transmitter control bits.
  regs[E1000_TCTL] = E1000_TCTL_EN |                  // enable
    80005896:	000407b7          	lui	a5,0x40
    8000589a:	10a78793          	addi	a5,a5,266 # 4010a <_entry-0x7ffbfef6>
    8000589e:	40f6a023          	sw	a5,1024(a3)
                     E1000_TCTL_PSP |                 // pad short packets
                     (0x10 << E1000_TCTL_CT_SHIFT) |  // collision stuff
                     (0x40 << E1000_TCTL_COLD_SHIFT);
  regs[E1000_TIPG] = 10 | (8 << 10) | (6 << 20);  // inter-pkt gap
    800058a2:	006027b7          	lui	a5,0x602
    800058a6:	07a9                	addi	a5,a5,10 # 60200a <_entry-0x7f9fdff6>
    800058a8:	40f6a823          	sw	a5,1040(a3)

  // receiver control bits.
  regs[E1000_RCTL] = E1000_RCTL_EN |       // enable receiver
    800058ac:	040087b7          	lui	a5,0x4008
    800058b0:	0789                	addi	a5,a5,2 # 4008002 <_entry-0x7bff7ffe>
    800058b2:	10f6a023          	sw	a5,256(a3)
                     E1000_RCTL_BAM |      // enable broadcast
                     E1000_RCTL_SZ_2048 |  // 2048-byte rx buffers
                     E1000_RCTL_SECRC;     // strip CRC

  // ask e1000 for receive interrupts.
  regs[E1000_RDTR] = 0;  // interrupt after every received packet (no timer)
    800058b6:	678d                	lui	a5,0x3
    800058b8:	97b6                	add	a5,a5,a3
    800058ba:	8207a023          	sw	zero,-2016(a5) # 2820 <_entry-0x7fffd7e0>
  regs[E1000_RADV] = 0;  // interrupt after every packet (no timer)
    800058be:	8207a623          	sw	zero,-2004(a5)
  regs[E1000_IMS] = (1 << 7);  // RXDW -- Receiver Descriptor Write Back
    800058c2:	08000793          	li	a5,128
    800058c6:	0cf6a823          	sw	a5,208(a3)
}
    800058ca:	70a2                	ld	ra,40(sp)
    800058cc:	7402                	ld	s0,32(sp)
    800058ce:	64e2                	ld	s1,24(sp)
    800058d0:	6942                	ld	s2,16(sp)
    800058d2:	69a2                	ld	s3,8(sp)
    800058d4:	6145                	addi	sp,sp,48
    800058d6:	8082                	ret
    if (!rx_bufs[i]) panic("e1000");
    800058d8:	00004517          	auipc	a0,0x4
    800058dc:	f6850513          	addi	a0,a0,-152 # 80009840 <syscalls+0x430>
    800058e0:	00001097          	auipc	ra,0x1
    800058e4:	0fe080e7          	jalr	254(ra) # 800069de <panic>

00000000800058e8 <e1000_transmit>:

int e1000_transmit(char *buf, int len) {
    800058e8:	7179                	addi	sp,sp,-48
    800058ea:	f406                	sd	ra,40(sp)
    800058ec:	f022                	sd	s0,32(sp)
    800058ee:	ec26                	sd	s1,24(sp)
    800058f0:	e84a                	sd	s2,16(sp)
    800058f2:	e44e                	sd	s3,8(sp)
    800058f4:	e052                	sd	s4,0(sp)
    800058f6:	1800                	addi	s0,sp,48
    800058f8:	89aa                	mv	s3,a0
    800058fa:	8a2e                	mv	s4,a1
  acquire(&e1000_tx_lock);
    800058fc:	00015917          	auipc	s2,0x15
    80005900:	38490913          	addi	s2,s2,900 # 8001ac80 <e1000_tx_lock>
    80005904:	854a                	mv	a0,s2
    80005906:	00001097          	auipc	ra,0x1
    8000590a:	610080e7          	jalr	1552(ra) # 80006f16 <acquire>

  uint32 ind = regs[E1000_TDT];
    8000590e:	00004797          	auipc	a5,0x4
    80005912:	1127b783          	ld	a5,274(a5) # 80009a20 <regs>
    80005916:	6711                	lui	a4,0x4
    80005918:	97ba                	add	a5,a5,a4
    8000591a:	8187a783          	lw	a5,-2024(a5)
    8000591e:	0007849b          	sext.w	s1,a5

  if ((tx_ring[ind].status & E1000_TXD_STAT_DD) == 0) {
    80005922:	02079713          	slli	a4,a5,0x20
    80005926:	01c75793          	srli	a5,a4,0x1c
    8000592a:	993e                	add	s2,s2,a5
    8000592c:	03c94783          	lbu	a5,60(s2)
    80005930:	8b85                	andi	a5,a5,1
    80005932:	c3c1                	beqz	a5,800059b2 <e1000_transmit+0xca>
    release(&e1000_tx_lock);
    return -1;
  }
  // на случай добавления новый битов статуса проверяем конкретный бит

  if (tx_bufs[ind]) {
    80005934:	02049793          	slli	a5,s1,0x20
    80005938:	01d7d713          	srli	a4,a5,0x1d
    8000593c:	00015797          	auipc	a5,0x15
    80005940:	34478793          	addi	a5,a5,836 # 8001ac80 <e1000_tx_lock>
    80005944:	97ba                	add	a5,a5,a4
    80005946:	1307b503          	ld	a0,304(a5)
    8000594a:	c509                	beqz	a0,80005954 <e1000_transmit+0x6c>
    kfree(tx_bufs[ind]);
    8000594c:	ffffa097          	auipc	ra,0xffffa
    80005950:	6d0080e7          	jalr	1744(ra) # 8000001c <kfree>
  }

  // на случай наличия битов в статусе, которые не стоит изменять
  tx_ring[ind].cmd |= E1000_TXD_CMD_RS | E1000_TXD_CMD_EOP;
    80005954:	00015517          	auipc	a0,0x15
    80005958:	32c50513          	addi	a0,a0,812 # 8001ac80 <e1000_tx_lock>
    8000595c:	02049793          	slli	a5,s1,0x20
    80005960:	9381                	srli	a5,a5,0x20
    80005962:	00479713          	slli	a4,a5,0x4
    80005966:	972a                	add	a4,a4,a0
    80005968:	03b74683          	lbu	a3,59(a4) # 403b <_entry-0x7fffbfc5>
    8000596c:	0096e693          	ori	a3,a3,9
    80005970:	02d70da3          	sb	a3,59(a4)
  tx_ring[ind].addr = (uint64)buf;
    80005974:	03373823          	sd	s3,48(a4)
  tx_ring[ind].length = (uint16)len;
    80005978:	03471c23          	sh	s4,56(a4)
  tx_bufs[ind] = buf;
    8000597c:	078e                	slli	a5,a5,0x3
    8000597e:	97aa                	add	a5,a5,a0
    80005980:	1337b823          	sd	s3,304(a5)

  regs[E1000_TDT] = (ind + 1) % TX_RING_SIZE;
    80005984:	2485                	addiw	s1,s1,1
    80005986:	88bd                	andi	s1,s1,15
    80005988:	00004797          	auipc	a5,0x4
    8000598c:	0987b783          	ld	a5,152(a5) # 80009a20 <regs>
    80005990:	6711                	lui	a4,0x4
    80005992:	97ba                	add	a5,a5,a4
    80005994:	8097ac23          	sw	s1,-2024(a5)

  release(&e1000_tx_lock);
    80005998:	00001097          	auipc	ra,0x1
    8000599c:	632080e7          	jalr	1586(ra) # 80006fca <release>
  return 0;
    800059a0:	4501                	li	a0,0
}
    800059a2:	70a2                	ld	ra,40(sp)
    800059a4:	7402                	ld	s0,32(sp)
    800059a6:	64e2                	ld	s1,24(sp)
    800059a8:	6942                	ld	s2,16(sp)
    800059aa:	69a2                	ld	s3,8(sp)
    800059ac:	6a02                	ld	s4,0(sp)
    800059ae:	6145                	addi	sp,sp,48
    800059b0:	8082                	ret
    release(&e1000_tx_lock);
    800059b2:	00015517          	auipc	a0,0x15
    800059b6:	2ce50513          	addi	a0,a0,718 # 8001ac80 <e1000_tx_lock>
    800059ba:	00001097          	auipc	ra,0x1
    800059be:	610080e7          	jalr	1552(ra) # 80006fca <release>
    return -1;
    800059c2:	557d                	li	a0,-1
    800059c4:	bff9                	j	800059a2 <e1000_transmit+0xba>

00000000800059c6 <e1000_intr>:
  }

  release(&e1000_rx_lock);
}

void e1000_intr(void) {
    800059c6:	7139                	addi	sp,sp,-64
    800059c8:	fc06                	sd	ra,56(sp)
    800059ca:	f822                	sd	s0,48(sp)
    800059cc:	f426                	sd	s1,40(sp)
    800059ce:	f04a                	sd	s2,32(sp)
    800059d0:	ec4e                	sd	s3,24(sp)
    800059d2:	e852                	sd	s4,16(sp)
    800059d4:	e456                	sd	s5,8(sp)
    800059d6:	0080                	addi	s0,sp,64
  // tell the e1000 we've seen this interrupt;
  // without this the e1000 won't raise any
  // further interrupts.
  regs[E1000_ICR] = 0xffffffff;
    800059d8:	00004497          	auipc	s1,0x4
    800059dc:	04848493          	addi	s1,s1,72 # 80009a20 <regs>
    800059e0:	609c                	ld	a5,0(s1)
    800059e2:	577d                	li	a4,-1
    800059e4:	0ce7a023          	sw	a4,192(a5)
  acquire(&e1000_rx_lock);
    800059e8:	00015517          	auipc	a0,0x15
    800059ec:	2b050513          	addi	a0,a0,688 # 8001ac98 <e1000_rx_lock>
    800059f0:	00001097          	auipc	ra,0x1
    800059f4:	526080e7          	jalr	1318(ra) # 80006f16 <acquire>
  uint32 ind = (regs[E1000_RDT] + 1) % RX_RING_SIZE;
    800059f8:	609c                	ld	a5,0(s1)
    800059fa:	670d                	lui	a4,0x3
    800059fc:	97ba                	add	a5,a5,a4
    800059fe:	8187a783          	lw	a5,-2024(a5)
    80005a02:	2785                	addiw	a5,a5,1
    80005a04:	00f7f493          	andi	s1,a5,15
  while ((rx_ring[ind].status & E1000_RXD_STAT_DD) != 0) {
    80005a08:	00449793          	slli	a5,s1,0x4
    80005a0c:	00015717          	auipc	a4,0x15
    80005a10:	27470713          	addi	a4,a4,628 # 8001ac80 <e1000_tx_lock>
    80005a14:	97ba                	add	a5,a5,a4
    80005a16:	1bc7c783          	lbu	a5,444(a5)
    80005a1a:	8b85                	andi	a5,a5,1
    80005a1c:	c7ad                	beqz	a5,80005a86 <e1000_intr+0xc0>
    net_rx(rx_bufs[ind], rx_ring[ind].length);
    80005a1e:	893a                	mv	s2,a4
    regs[E1000_RDT] = ind;
    80005a20:	00004a17          	auipc	s4,0x4
    80005a24:	000a0a13          	mv	s4,s4
    80005a28:	698d                	lui	s3,0x3
    net_rx(rx_bufs[ind], rx_ring[ind].length);
    80005a2a:	00449793          	slli	a5,s1,0x4
    80005a2e:	97ca                	add	a5,a5,s2
    80005a30:	00349a93          	slli	s5,s1,0x3
    80005a34:	9aca                	add	s5,s5,s2
    80005a36:	1b87d583          	lhu	a1,440(a5)
    80005a3a:	2b0ab503          	ld	a0,688(s5)
    80005a3e:	00001097          	auipc	ra,0x1
    80005a42:	962080e7          	jalr	-1694(ra) # 800063a0 <net_rx>
    rx_bufs[ind] = kalloc();
    80005a46:	ffffa097          	auipc	ra,0xffffa
    80005a4a:	6d4080e7          	jalr	1748(ra) # 8000011a <kalloc>
    80005a4e:	2aaab823          	sd	a0,688(s5)
    if (!rx_bufs[ind]) panic("e1000_recv");
    80005a52:	c939                	beqz	a0,80005aa8 <e1000_intr+0xe2>
    rx_ring[ind].addr = (uint64)rx_bufs[ind];
    80005a54:	00449793          	slli	a5,s1,0x4
    80005a58:	97ca                	add	a5,a5,s2
    80005a5a:	1aa7b823          	sd	a0,432(a5)
    rx_ring[ind].length = 0;
    80005a5e:	1a079c23          	sh	zero,440(a5)
    rx_ring[ind].status = 0;
    80005a62:	1a078e23          	sb	zero,444(a5)
    regs[E1000_RDT] = ind;
    80005a66:	000a3783          	ld	a5,0(s4) # 80009a20 <regs>
    80005a6a:	97ce                	add	a5,a5,s3
    80005a6c:	8097ac23          	sw	s1,-2024(a5)
    ind = (ind + 1) % RX_RING_SIZE;
    80005a70:	0014879b          	addiw	a5,s1,1
    80005a74:	00f7f493          	andi	s1,a5,15
  while ((rx_ring[ind].status & E1000_RXD_STAT_DD) != 0) {
    80005a78:	00449793          	slli	a5,s1,0x4
    80005a7c:	97ca                	add	a5,a5,s2
    80005a7e:	1bc7c783          	lbu	a5,444(a5)
    80005a82:	8b85                	andi	a5,a5,1
    80005a84:	f3dd                	bnez	a5,80005a2a <e1000_intr+0x64>
  release(&e1000_rx_lock);
    80005a86:	00015517          	auipc	a0,0x15
    80005a8a:	21250513          	addi	a0,a0,530 # 8001ac98 <e1000_rx_lock>
    80005a8e:	00001097          	auipc	ra,0x1
    80005a92:	53c080e7          	jalr	1340(ra) # 80006fca <release>

  e1000_recv();
}
    80005a96:	70e2                	ld	ra,56(sp)
    80005a98:	7442                	ld	s0,48(sp)
    80005a9a:	74a2                	ld	s1,40(sp)
    80005a9c:	7902                	ld	s2,32(sp)
    80005a9e:	69e2                	ld	s3,24(sp)
    80005aa0:	6a42                	ld	s4,16(sp)
    80005aa2:	6aa2                	ld	s5,8(sp)
    80005aa4:	6121                	addi	sp,sp,64
    80005aa6:	8082                	ret
    if (!rx_bufs[ind]) panic("e1000_recv");
    80005aa8:	00004517          	auipc	a0,0x4
    80005aac:	da050513          	addi	a0,a0,-608 # 80009848 <syscalls+0x438>
    80005ab0:	00001097          	auipc	ra,0x1
    80005ab4:	f2e080e7          	jalr	-210(ra) # 800069de <panic>

0000000080005ab8 <netinit>:
};

#define PORTS_COUNT 2049
static struct port_buffer ports[PORTS_COUNT];

void netinit(void) {
    80005ab8:	7179                	addi	sp,sp,-48
    80005aba:	f406                	sd	ra,40(sp)
    80005abc:	f022                	sd	s0,32(sp)
    80005abe:	ec26                	sd	s1,24(sp)
    80005ac0:	e84a                	sd	s2,16(sp)
    80005ac2:	e44e                	sd	s3,8(sp)
    80005ac4:	1800                	addi	s0,sp,48
  // initialize network here
  initlock(&netlock, "netlock");
    80005ac6:	00004597          	auipc	a1,0x4
    80005aca:	d9258593          	addi	a1,a1,-622 # 80009858 <syscalls+0x448>
    80005ace:	00015517          	auipc	a0,0x15
    80005ad2:	4e250513          	addi	a0,a0,1250 # 8001afb0 <netlock>
    80005ad6:	00001097          	auipc	ra,0x1
    80005ada:	3b0080e7          	jalr	944(ra) # 80006e86 <initlock>
  memset(ports, 0, sizeof(ports));
    80005ade:	000d0637          	lui	a2,0xd0
    80005ae2:	1a060613          	addi	a2,a2,416 # d01a0 <_entry-0x7ff2fe60>
    80005ae6:	4581                	li	a1,0
    80005ae8:	00015517          	auipc	a0,0x15
    80005aec:	4e050513          	addi	a0,a0,1248 # 8001afc8 <ports>
    80005af0:	ffffa097          	auipc	ra,0xffffa
    80005af4:	68a080e7          	jalr	1674(ra) # 8000017a <memset>
  for (int i = 0; i < PORTS_COUNT; i++) {
    80005af8:	00015497          	auipc	s1,0x15
    80005afc:	65848493          	addi	s1,s1,1624 # 8001b150 <ports+0x188>
    80005b00:	000e5997          	auipc	s3,0xe5
    80005b04:	7f098993          	addi	s3,s3,2032 # 800eb2f0 <stack0+0x40>
    initlock(&ports[i].port_buf_lock, "port_buf_lock");
    80005b08:	00004917          	auipc	s2,0x4
    80005b0c:	d5890913          	addi	s2,s2,-680 # 80009860 <syscalls+0x450>
    80005b10:	85ca                	mv	a1,s2
    80005b12:	8526                	mv	a0,s1
    80005b14:	00001097          	auipc	ra,0x1
    80005b18:	372080e7          	jalr	882(ra) # 80006e86 <initlock>
  for (int i = 0; i < PORTS_COUNT; i++) {
    80005b1c:	1a048493          	addi	s1,s1,416
    80005b20:	ff3498e3          	bne	s1,s3,80005b10 <netinit+0x58>
  }
}
    80005b24:	70a2                	ld	ra,40(sp)
    80005b26:	7402                	ld	s0,32(sp)
    80005b28:	64e2                	ld	s1,24(sp)
    80005b2a:	6942                	ld	s2,16(sp)
    80005b2c:	69a2                	ld	s3,8(sp)
    80005b2e:	6145                	addi	sp,sp,48
    80005b30:	8082                	ret

0000000080005b32 <sys_bind>:
//
// bind(int port)
// prepare to receive UDP packets address to the port,
// i.e. allocate any queues &c needed.
//
uint64 sys_bind(void) {
    80005b32:	7139                	addi	sp,sp,-64
    80005b34:	fc06                	sd	ra,56(sp)
    80005b36:	f822                	sd	s0,48(sp)
    80005b38:	f426                	sd	s1,40(sp)
    80005b3a:	f04a                	sd	s2,32(sp)
    80005b3c:	ec4e                	sd	s3,24(sp)
    80005b3e:	e852                	sd	s4,16(sp)
    80005b40:	0080                	addi	s0,sp,64
  int port;
  argint(0, &port);
    80005b42:	fcc40593          	addi	a1,s0,-52
    80005b46:	4501                	li	a0,0
    80005b48:	ffffc097          	auipc	ra,0xffffc
    80005b4c:	4d0080e7          	jalr	1232(ra) # 80002018 <argint>

  struct port_buffer *buf = &ports[port];
    80005b50:	fcc42a03          	lw	s4,-52(s0)

  acquire(&buf->port_buf_lock);
    80005b54:	1a000913          	li	s2,416
    80005b58:	032a0933          	mul	s2,s4,s2
    80005b5c:	18890993          	addi	s3,s2,392
    80005b60:	00015497          	auipc	s1,0x15
    80005b64:	46848493          	addi	s1,s1,1128 # 8001afc8 <ports>
    80005b68:	99a6                	add	s3,s3,s1
    80005b6a:	854e                	mv	a0,s3
    80005b6c:	00001097          	auipc	ra,0x1
    80005b70:	3aa080e7          	jalr	938(ra) # 80006f16 <acquire>

  if (buf->init) {
    80005b74:	94ca                	add	s1,s1,s2
    80005b76:	1824c783          	lbu	a5,386(s1)
    80005b7a:	ef9d                	bnez	a5,80005bb8 <sys_bind+0x86>
    release(&buf->port_buf_lock);
    return -1;
  }
  buf->count = 0;
    80005b7c:	1a000793          	li	a5,416
    80005b80:	02fa0a33          	mul	s4,s4,a5
    80005b84:	00015797          	auipc	a5,0x15
    80005b88:	44478793          	addi	a5,a5,1092 # 8001afc8 <ports>
    80005b8c:	97d2                	add	a5,a5,s4
    80005b8e:	18078023          	sb	zero,384(a5)
  buf->ind = 0;
    80005b92:	180780a3          	sb	zero,385(a5)
  buf->init = 1;
    80005b96:	4705                	li	a4,1
    80005b98:	18e78123          	sb	a4,386(a5)

  release(&buf->port_buf_lock);
    80005b9c:	854e                	mv	a0,s3
    80005b9e:	00001097          	auipc	ra,0x1
    80005ba2:	42c080e7          	jalr	1068(ra) # 80006fca <release>
  return 0;
    80005ba6:	4501                	li	a0,0
}
    80005ba8:	70e2                	ld	ra,56(sp)
    80005baa:	7442                	ld	s0,48(sp)
    80005bac:	74a2                	ld	s1,40(sp)
    80005bae:	7902                	ld	s2,32(sp)
    80005bb0:	69e2                	ld	s3,24(sp)
    80005bb2:	6a42                	ld	s4,16(sp)
    80005bb4:	6121                	addi	sp,sp,64
    80005bb6:	8082                	ret
    release(&buf->port_buf_lock);
    80005bb8:	854e                	mv	a0,s3
    80005bba:	00001097          	auipc	ra,0x1
    80005bbe:	410080e7          	jalr	1040(ra) # 80006fca <release>
    return -1;
    80005bc2:	557d                	li	a0,-1
    80005bc4:	b7d5                	j	80005ba8 <sys_bind+0x76>

0000000080005bc6 <sys_unbind>:
//
// unbind(int port)
// release any resources previously created by bind(port);
// from now on UDP packets addressed to port should be dropped.
//
uint64 sys_unbind(void) {
    80005bc6:	715d                	addi	sp,sp,-80
    80005bc8:	e486                	sd	ra,72(sp)
    80005bca:	e0a2                	sd	s0,64(sp)
    80005bcc:	fc26                	sd	s1,56(sp)
    80005bce:	f84a                	sd	s2,48(sp)
    80005bd0:	f44e                	sd	s3,40(sp)
    80005bd2:	f052                	sd	s4,32(sp)
    80005bd4:	ec56                	sd	s5,24(sp)
    80005bd6:	e85a                	sd	s6,16(sp)
    80005bd8:	0880                	addi	s0,sp,80
  int port, i;
  argint(0, &port);
    80005bda:	fbc40593          	addi	a1,s0,-68
    80005bde:	4501                	li	a0,0
    80005be0:	ffffc097          	auipc	ra,0xffffc
    80005be4:	438080e7          	jalr	1080(ra) # 80002018 <argint>

  struct port_buffer *port_buf = &ports[port];
    80005be8:	fbc42a83          	lw	s5,-68(s0)
    80005bec:	1a000993          	li	s3,416
    80005bf0:	033a89b3          	mul	s3,s5,s3
    80005bf4:	00015797          	auipc	a5,0x15
    80005bf8:	3d478793          	addi	a5,a5,980 # 8001afc8 <ports>
    80005bfc:	00f98b33          	add	s6,s3,a5

  acquire(&port_buf->port_buf_lock);
    80005c00:	18898a13          	addi	s4,s3,392
    80005c04:	9a3e                	add	s4,s4,a5
    80005c06:	8552                	mv	a0,s4
    80005c08:	00001097          	auipc	ra,0x1
    80005c0c:	30e080e7          	jalr	782(ra) # 80006f16 <acquire>

  if (!port_buf->init) {
    80005c10:	182b4783          	lbu	a5,386(s6)
    80005c14:	84da                	mv	s1,s6
    80005c16:	00015917          	auipc	s2,0x15
    80005c1a:	53290913          	addi	s2,s2,1330 # 8001b148 <ports+0x180>
    80005c1e:	994e                	add	s2,s2,s3
    80005c20:	eb99                	bnez	a5,80005c36 <sys_unbind+0x70>
    release(&port_buf->port_buf_lock);
    80005c22:	8552                	mv	a0,s4
    80005c24:	00001097          	auipc	ra,0x1
    80005c28:	3a6080e7          	jalr	934(ra) # 80006fca <release>
    return -1;
    80005c2c:	557d                	li	a0,-1
    80005c2e:	a099                	j	80005c74 <sys_unbind+0xae>
  }

  for (i = 0; i < PORT_BUFFER_SIZE; i++) {
    80005c30:	04e1                	addi	s1,s1,24
    80005c32:	01248b63          	beq	s1,s2,80005c48 <sys_unbind+0x82>
    if (port_buf->packet_queue[i].data) {
    80005c36:	6088                	ld	a0,0(s1)
    80005c38:	dd65                	beqz	a0,80005c30 <sys_unbind+0x6a>
      kfree(port_buf->packet_queue[i].data);
    80005c3a:	ffffa097          	auipc	ra,0xffffa
    80005c3e:	3e2080e7          	jalr	994(ra) # 8000001c <kfree>
      port_buf->packet_queue[i].data = 0;
    80005c42:	0004b023          	sd	zero,0(s1)
    80005c46:	b7ed                	j	80005c30 <sys_unbind+0x6a>
    }
  }
  port_buf->init = 0;
    80005c48:	1a000793          	li	a5,416
    80005c4c:	02fa8ab3          	mul	s5,s5,a5
    80005c50:	00015797          	auipc	a5,0x15
    80005c54:	37878793          	addi	a5,a5,888 # 8001afc8 <ports>
    80005c58:	97d6                	add	a5,a5,s5
    80005c5a:	18078123          	sb	zero,386(a5)

  wakeup(port_buf);
    80005c5e:	855a                	mv	a0,s6
    80005c60:	ffffc097          	auipc	ra,0xffffc
    80005c64:	99c080e7          	jalr	-1636(ra) # 800015fc <wakeup>

  release(&port_buf->port_buf_lock);
    80005c68:	8552                	mv	a0,s4
    80005c6a:	00001097          	auipc	ra,0x1
    80005c6e:	360080e7          	jalr	864(ra) # 80006fca <release>

  return 0;
    80005c72:	4501                	li	a0,0
}
    80005c74:	60a6                	ld	ra,72(sp)
    80005c76:	6406                	ld	s0,64(sp)
    80005c78:	74e2                	ld	s1,56(sp)
    80005c7a:	7942                	ld	s2,48(sp)
    80005c7c:	79a2                	ld	s3,40(sp)
    80005c7e:	7a02                	ld	s4,32(sp)
    80005c80:	6ae2                	ld	s5,24(sp)
    80005c82:	6b42                	ld	s6,16(sp)
    80005c84:	6161                	addi	sp,sp,80
    80005c86:	8082                	ret

0000000080005c88 <sys_recv>:
// and -1 if there was an error.
//
// dport, *src, and *sport are host byte order.
// bind(dport) must previously have been called.
//
uint64 sys_recv(void) {
    80005c88:	7119                	addi	sp,sp,-128
    80005c8a:	fc86                	sd	ra,120(sp)
    80005c8c:	f8a2                	sd	s0,112(sp)
    80005c8e:	f4a6                	sd	s1,104(sp)
    80005c90:	f0ca                	sd	s2,96(sp)
    80005c92:	ecce                	sd	s3,88(sp)
    80005c94:	e8d2                	sd	s4,80(sp)
    80005c96:	e4d6                	sd	s5,72(sp)
    80005c98:	e0da                	sd	s6,64(sp)
    80005c9a:	fc5e                	sd	s7,56(sp)
    80005c9c:	0100                	addi	s0,sp,128
  uint64 srcaddr;
  uint64 sportaddr;
  uint64 bufaddr;
  int maxlen;

  argint(0, &dport);
    80005c9e:	fac40593          	addi	a1,s0,-84
    80005ca2:	4501                	li	a0,0
    80005ca4:	ffffc097          	auipc	ra,0xffffc
    80005ca8:	374080e7          	jalr	884(ra) # 80002018 <argint>
  argaddr(1, &srcaddr);
    80005cac:	fa040593          	addi	a1,s0,-96
    80005cb0:	4505                	li	a0,1
    80005cb2:	ffffc097          	auipc	ra,0xffffc
    80005cb6:	386080e7          	jalr	902(ra) # 80002038 <argaddr>
  argaddr(2, &sportaddr);
    80005cba:	f9840593          	addi	a1,s0,-104
    80005cbe:	4509                	li	a0,2
    80005cc0:	ffffc097          	auipc	ra,0xffffc
    80005cc4:	378080e7          	jalr	888(ra) # 80002038 <argaddr>
  argaddr(3, &bufaddr);
    80005cc8:	f9040593          	addi	a1,s0,-112
    80005ccc:	450d                	li	a0,3
    80005cce:	ffffc097          	auipc	ra,0xffffc
    80005cd2:	36a080e7          	jalr	874(ra) # 80002038 <argaddr>
  argint(4, &maxlen);
    80005cd6:	f8c40593          	addi	a1,s0,-116
    80005cda:	4511                	li	a0,4
    80005cdc:	ffffc097          	auipc	ra,0xffffc
    80005ce0:	33c080e7          	jalr	828(ra) # 80002018 <argint>

  struct port_buffer *port_buf = &ports[dport];
    80005ce4:	fac42a03          	lw	s4,-84(s0)
    80005ce8:	1a000913          	li	s2,416
    80005cec:	032a0933          	mul	s2,s4,s2
    80005cf0:	00015797          	auipc	a5,0x15
    80005cf4:	2d878793          	addi	a5,a5,728 # 8001afc8 <ports>
    80005cf8:	00f909b3          	add	s3,s2,a5
  acquire(&port_buf->port_buf_lock);
    80005cfc:	18890913          	addi	s2,s2,392
    80005d00:	993e                	add	s2,s2,a5
    80005d02:	854a                	mv	a0,s2
    80005d04:	00001097          	auipc	ra,0x1
    80005d08:	212080e7          	jalr	530(ra) # 80006f16 <acquire>

  while (port_buf->init && port_buf->count == 0) {
    80005d0c:	1829c783          	lbu	a5,386(s3)
    80005d10:	cf91                	beqz	a5,80005d2c <sys_recv+0xa4>
    80005d12:	84ce                	mv	s1,s3
    80005d14:	1804c703          	lbu	a4,384(s1)
    80005d18:	e30d                	bnez	a4,80005d3a <sys_recv+0xb2>
    sleep(port_buf, &port_buf->port_buf_lock);
    80005d1a:	85ca                	mv	a1,s2
    80005d1c:	854e                	mv	a0,s3
    80005d1e:	ffffc097          	auipc	ra,0xffffc
    80005d22:	87a080e7          	jalr	-1926(ra) # 80001598 <sleep>
  while (port_buf->init && port_buf->count == 0) {
    80005d26:	1824c783          	lbu	a5,386(s1)
    80005d2a:	f7ed                	bnez	a5,80005d14 <sys_recv+0x8c>
  }

  if (!port_buf->init) {
    release(&port_buf->port_buf_lock);
    80005d2c:	854a                	mv	a0,s2
    80005d2e:	00001097          	auipc	ra,0x1
    80005d32:	29c080e7          	jalr	668(ra) # 80006fca <release>
    return -1;
    80005d36:	5afd                	li	s5,-1
    80005d38:	a205                	j	80005e58 <sys_recv+0x1d0>
  if (!port_buf->init) {
    80005d3a:	dbed                	beqz	a5,80005d2c <sys_recv+0xa4>
  }

  struct packet_info *packet_info = &port_buf->packet_queue[port_buf->ind];
    80005d3c:	00015717          	auipc	a4,0x15
    80005d40:	28c70713          	addi	a4,a4,652 # 8001afc8 <ports>
    80005d44:	1a000693          	li	a3,416
    80005d48:	02da06b3          	mul	a3,s4,a3
    80005d4c:	00d707b3          	add	a5,a4,a3
    80005d50:	1817c483          	lbu	s1,385(a5)

  int copy_len = (maxlen < packet_info->len) ? maxlen : packet_info->len;
    80005d54:	00149793          	slli	a5,s1,0x1
    80005d58:	97a6                	add	a5,a5,s1
    80005d5a:	078e                	slli	a5,a5,0x3
    80005d5c:	97b6                	add	a5,a5,a3
    80005d5e:	97ba                	add	a5,a5,a4
    80005d60:	0087ab03          	lw	s6,8(a5)
    80005d64:	f8c42b83          	lw	s7,-116(s0)

  uint32 src_ip = packet_info->ip_addr;
    80005d68:	47d8                	lw	a4,12(a5)
    80005d6a:	f8e42423          	sw	a4,-120(s0)
  uint16 src_port = packet_info->sport;
    80005d6e:	0107d783          	lhu	a5,16(a5)
    80005d72:	f8f41323          	sh	a5,-122(s0)

  struct proc *p = myproc();
    80005d76:	ffffb097          	auipc	ra,0xffffb
    80005d7a:	176080e7          	jalr	374(ra) # 80000eec <myproc>
    80005d7e:	89aa                	mv	s3,a0
  if (copyout(p->pagetable, srcaddr, (char *)&src_ip, sizeof(src_ip)) < 0 ||
    80005d80:	4691                	li	a3,4
    80005d82:	f8840613          	addi	a2,s0,-120
    80005d86:	fa043583          	ld	a1,-96(s0)
    80005d8a:	6928                	ld	a0,80(a0)
    80005d8c:	ffffb097          	auipc	ra,0xffffb
    80005d90:	dec080e7          	jalr	-532(ra) # 80000b78 <copyout>
    80005d94:	0a054c63          	bltz	a0,80005e4c <sys_recv+0x1c4>
      copyout(p->pagetable, sportaddr, (char *)&src_port, sizeof(src_port)) <
    80005d98:	4689                	li	a3,2
    80005d9a:	f8640613          	addi	a2,s0,-122
    80005d9e:	f9843583          	ld	a1,-104(s0)
    80005da2:	0509b503          	ld	a0,80(s3)
    80005da6:	ffffb097          	auipc	ra,0xffffb
    80005daa:	dd2080e7          	jalr	-558(ra) # 80000b78 <copyout>
  if (copyout(p->pagetable, srcaddr, (char *)&src_ip, sizeof(src_ip)) < 0 ||
    80005dae:	08054f63          	bltz	a0,80005e4c <sys_recv+0x1c4>
  int copy_len = (maxlen < packet_info->len) ? maxlen : packet_info->len;
    80005db2:	8ada                	mv	s5,s6
    80005db4:	016bd363          	bge	s7,s6,80005dba <sys_recv+0x132>
    80005db8:	8ade                	mv	s5,s7
          0 ||
      copyout(p->pagetable, bufaddr, packet_info->data, copy_len) < 0) {
    80005dba:	2a81                	sext.w	s5,s5
    80005dbc:	00149793          	slli	a5,s1,0x1
    80005dc0:	97a6                	add	a5,a5,s1
    80005dc2:	078e                	slli	a5,a5,0x3
    80005dc4:	1a000713          	li	a4,416
    80005dc8:	02ea0733          	mul	a4,s4,a4
    80005dcc:	97ba                	add	a5,a5,a4
    80005dce:	00015717          	auipc	a4,0x15
    80005dd2:	1fa70713          	addi	a4,a4,506 # 8001afc8 <ports>
    80005dd6:	97ba                	add	a5,a5,a4
    80005dd8:	86d6                	mv	a3,s5
    80005dda:	6390                	ld	a2,0(a5)
    80005ddc:	f9043583          	ld	a1,-112(s0)
    80005de0:	0509b503          	ld	a0,80(s3)
    80005de4:	ffffb097          	auipc	ra,0xffffb
    80005de8:	d94080e7          	jalr	-620(ra) # 80000b78 <copyout>
          0 ||
    80005dec:	06054063          	bltz	a0,80005e4c <sys_recv+0x1c4>
    release(&port_buf->port_buf_lock);
    return -1;
  }

  kfree(packet_info->data);
    80005df0:	00015b17          	auipc	s6,0x15
    80005df4:	1d8b0b13          	addi	s6,s6,472 # 8001afc8 <ports>
    80005df8:	00149993          	slli	s3,s1,0x1
    80005dfc:	009987b3          	add	a5,s3,s1
    80005e00:	078e                	slli	a5,a5,0x3
    80005e02:	1a000713          	li	a4,416
    80005e06:	02ea0a33          	mul	s4,s4,a4
    80005e0a:	97d2                	add	a5,a5,s4
    80005e0c:	97da                	add	a5,a5,s6
    80005e0e:	6388                	ld	a0,0(a5)
    80005e10:	ffffa097          	auipc	ra,0xffffa
    80005e14:	20c080e7          	jalr	524(ra) # 8000001c <kfree>
  packet_info->data = 0;
    80005e18:	009987b3          	add	a5,s3,s1
    80005e1c:	078e                	slli	a5,a5,0x3
    80005e1e:	97d2                	add	a5,a5,s4
    80005e20:	97da                	add	a5,a5,s6
    80005e22:	0007b023          	sd	zero,0(a5)
  port_buf->ind = (port_buf->ind + 1) % PORT_BUFFER_SIZE;
    80005e26:	014b07b3          	add	a5,s6,s4
    80005e2a:	1817c703          	lbu	a4,385(a5)
    80005e2e:	2705                	addiw	a4,a4,1
    80005e30:	8b3d                	andi	a4,a4,15
    80005e32:	18e780a3          	sb	a4,385(a5)
  port_buf->count--;
    80005e36:	1807c703          	lbu	a4,384(a5)
    80005e3a:	377d                	addiw	a4,a4,-1
    80005e3c:	18e78023          	sb	a4,384(a5)

  release(&port_buf->port_buf_lock);
    80005e40:	854a                	mv	a0,s2
    80005e42:	00001097          	auipc	ra,0x1
    80005e46:	188080e7          	jalr	392(ra) # 80006fca <release>
  return copy_len;
    80005e4a:	a039                	j	80005e58 <sys_recv+0x1d0>
    release(&port_buf->port_buf_lock);
    80005e4c:	854a                	mv	a0,s2
    80005e4e:	00001097          	auipc	ra,0x1
    80005e52:	17c080e7          	jalr	380(ra) # 80006fca <release>
    return -1;
    80005e56:	5afd                	li	s5,-1
}
    80005e58:	8556                	mv	a0,s5
    80005e5a:	70e6                	ld	ra,120(sp)
    80005e5c:	7446                	ld	s0,112(sp)
    80005e5e:	74a6                	ld	s1,104(sp)
    80005e60:	7906                	ld	s2,96(sp)
    80005e62:	69e6                	ld	s3,88(sp)
    80005e64:	6a46                	ld	s4,80(sp)
    80005e66:	6aa6                	ld	s5,72(sp)
    80005e68:	6b06                	ld	s6,64(sp)
    80005e6a:	7be2                	ld	s7,56(sp)
    80005e6c:	6109                	addi	sp,sp,128
    80005e6e:	8082                	ret

0000000080005e70 <sys_send>:
}

//
// send(int sport, int dst, int dport, char *buf, int len)
//
uint64 sys_send(void) {
    80005e70:	715d                	addi	sp,sp,-80
    80005e72:	e486                	sd	ra,72(sp)
    80005e74:	e0a2                	sd	s0,64(sp)
    80005e76:	fc26                	sd	s1,56(sp)
    80005e78:	f84a                	sd	s2,48(sp)
    80005e7a:	f44e                	sd	s3,40(sp)
    80005e7c:	0880                	addi	s0,sp,80
  struct proc *p = myproc();
    80005e7e:	ffffb097          	auipc	ra,0xffffb
    80005e82:	06e080e7          	jalr	110(ra) # 80000eec <myproc>
    80005e86:	89aa                	mv	s3,a0
  int dst;
  int dport;
  uint64 bufaddr;
  int len;

  argint(0, &sport);
    80005e88:	fcc40593          	addi	a1,s0,-52
    80005e8c:	4501                	li	a0,0
    80005e8e:	ffffc097          	auipc	ra,0xffffc
    80005e92:	18a080e7          	jalr	394(ra) # 80002018 <argint>
  argint(1, &dst);
    80005e96:	fc840593          	addi	a1,s0,-56
    80005e9a:	4505                	li	a0,1
    80005e9c:	ffffc097          	auipc	ra,0xffffc
    80005ea0:	17c080e7          	jalr	380(ra) # 80002018 <argint>
  argint(2, &dport);
    80005ea4:	fc440593          	addi	a1,s0,-60
    80005ea8:	4509                	li	a0,2
    80005eaa:	ffffc097          	auipc	ra,0xffffc
    80005eae:	16e080e7          	jalr	366(ra) # 80002018 <argint>
  argaddr(3, &bufaddr);
    80005eb2:	fb840593          	addi	a1,s0,-72
    80005eb6:	450d                	li	a0,3
    80005eb8:	ffffc097          	auipc	ra,0xffffc
    80005ebc:	180080e7          	jalr	384(ra) # 80002038 <argaddr>
  argint(4, &len);
    80005ec0:	fb440593          	addi	a1,s0,-76
    80005ec4:	4511                	li	a0,4
    80005ec6:	ffffc097          	auipc	ra,0xffffc
    80005eca:	152080e7          	jalr	338(ra) # 80002018 <argint>

  int total = len + sizeof(struct eth) + sizeof(struct ip) + sizeof(struct udp);
    80005ece:	fb442903          	lw	s2,-76(s0)
    80005ed2:	02a9091b          	addiw	s2,s2,42
  if (total > PGSIZE) return -1;
    80005ed6:	6785                	lui	a5,0x1
    80005ed8:	557d                	li	a0,-1
    80005eda:	1727ca63          	blt	a5,s2,8000604e <sys_send+0x1de>

  char *buf = kalloc();
    80005ede:	ffffa097          	auipc	ra,0xffffa
    80005ee2:	23c080e7          	jalr	572(ra) # 8000011a <kalloc>
    80005ee6:	84aa                	mv	s1,a0
  if (buf == 0) {
    80005ee8:	16050a63          	beqz	a0,8000605c <sys_send+0x1ec>
    printf("sys_send: kalloc failed\n");
    return -1;
  }
  memset(buf, 0, PGSIZE);
    80005eec:	6605                	lui	a2,0x1
    80005eee:	4581                	li	a1,0
    80005ef0:	ffffa097          	auipc	ra,0xffffa
    80005ef4:	28a080e7          	jalr	650(ra) # 8000017a <memset>

  struct eth *eth = (struct eth *)buf;
  memmove(eth->dhost, host_mac, ETHADDR_LEN);
    80005ef8:	4619                	li	a2,6
    80005efa:	00004597          	auipc	a1,0x4
    80005efe:	a8e58593          	addi	a1,a1,-1394 # 80009988 <host_mac>
    80005f02:	8526                	mv	a0,s1
    80005f04:	ffffa097          	auipc	ra,0xffffa
    80005f08:	2d2080e7          	jalr	722(ra) # 800001d6 <memmove>
  memmove(eth->shost, local_mac, ETHADDR_LEN);
    80005f0c:	4619                	li	a2,6
    80005f0e:	00004597          	auipc	a1,0x4
    80005f12:	a8258593          	addi	a1,a1,-1406 # 80009990 <local_mac>
    80005f16:	00648513          	addi	a0,s1,6
    80005f1a:	ffffa097          	auipc	ra,0xffffa
    80005f1e:	2bc080e7          	jalr	700(ra) # 800001d6 <memmove>
  eth->type = htons(ETHTYPE_IP);
    80005f22:	47a1                	li	a5,8
    80005f24:	00f48623          	sb	a5,12(s1)
    80005f28:	000486a3          	sb	zero,13(s1)

  struct ip *ip = (struct ip *)(eth + 1);
    80005f2c:	00e48793          	addi	a5,s1,14
  ip->ip_vhl = 0x45;  // version 4, header length 4*5
    80005f30:	04500713          	li	a4,69
    80005f34:	00e48723          	sb	a4,14(s1)
  ip->ip_tos = 0;
    80005f38:	000487a3          	sb	zero,15(s1)
  ip->ip_len = htons(sizeof(struct ip) + sizeof(struct udp) + len);
    80005f3c:	fb442683          	lw	a3,-76(s0)
    80005f40:	03069813          	slli	a6,a3,0x30
    80005f44:	03085813          	srli	a6,a6,0x30
    80005f48:	01c8071b          	addiw	a4,a6,28
//

#include "types.h"

static inline uint16 bswaps(uint16 val) {
  return (((val & 0x00ffU) << 8) | ((val & 0xff00U) >> 8));
    80005f4c:	0087161b          	slliw	a2,a4,0x8
    80005f50:	0107171b          	slliw	a4,a4,0x10
    80005f54:	0107571b          	srliw	a4,a4,0x10
    80005f58:	0087571b          	srliw	a4,a4,0x8
    80005f5c:	8f51                	or	a4,a4,a2
    80005f5e:	00e49823          	sh	a4,16(s1)
  ip->ip_id = 0;
    80005f62:	00049923          	sh	zero,18(s1)
  ip->ip_off = 0;
    80005f66:	00049a23          	sh	zero,20(s1)
  ip->ip_ttl = 100;
    80005f6a:	06400713          	li	a4,100
    80005f6e:	00e48b23          	sb	a4,22(s1)
  ip->ip_p = IPPROTO_UDP;
    80005f72:	4745                	li	a4,17
    80005f74:	00e48ba3          	sb	a4,23(s1)
  ip->ip_src = htonl(local_ip);
    80005f78:	0f020737          	lui	a4,0xf020
    80005f7c:	0729                	addi	a4,a4,10 # f02000a <_entry-0x70fdfff6>
    80005f7e:	00e4ad23          	sw	a4,26(s1)
  ip->ip_dst = htonl(dst);
    80005f82:	fc842703          	lw	a4,-56(s0)
}

static inline uint32 bswapl(uint32 val) {
  return (((val & 0x000000ffUL) << 24) | ((val & 0x0000ff00UL) << 8) |
    80005f86:	0187161b          	slliw	a2,a4,0x18
          ((val & 0x00ff0000UL) >> 8) | ((val & 0xff000000UL) >> 24));
    80005f8a:	0187559b          	srliw	a1,a4,0x18
    80005f8e:	8e4d                	or	a2,a2,a1
  return (((val & 0x000000ffUL) << 24) | ((val & 0x0000ff00UL) << 8) |
    80005f90:	0087159b          	slliw	a1,a4,0x8
    80005f94:	00ff0537          	lui	a0,0xff0
    80005f98:	8de9                	and	a1,a1,a0
          ((val & 0x00ff0000UL) >> 8) | ((val & 0xff000000UL) >> 24));
    80005f9a:	8e4d                	or	a2,a2,a1
    80005f9c:	0087571b          	srliw	a4,a4,0x8
    80005fa0:	65c1                	lui	a1,0x10
    80005fa2:	f0058593          	addi	a1,a1,-256 # ff00 <_entry-0x7fff0100>
    80005fa6:	8f6d                	and	a4,a4,a1
    80005fa8:	8f51                	or	a4,a4,a2
    80005faa:	00e4af23          	sw	a4,30(s1)
  while (nleft > 1) {
    80005fae:	02248593          	addi	a1,s1,34
  unsigned int sum = 0;
    80005fb2:	4701                	li	a4,0
    sum += *w++;
    80005fb4:	0789                	addi	a5,a5,2 # 1002 <_entry-0x7fffeffe>
    80005fb6:	ffe7d603          	lhu	a2,-2(a5)
    80005fba:	9f31                	addw	a4,a4,a2
  while (nleft > 1) {
    80005fbc:	feb79ce3          	bne	a5,a1,80005fb4 <sys_send+0x144>
  sum = (sum & 0xffff) + (sum >> 16);
    80005fc0:	03071793          	slli	a5,a4,0x30
    80005fc4:	93c1                	srli	a5,a5,0x30
    80005fc6:	0107571b          	srliw	a4,a4,0x10
    80005fca:	9fb9                	addw	a5,a5,a4
  sum += (sum >> 16);
    80005fcc:	0107d71b          	srliw	a4,a5,0x10
    80005fd0:	9fb9                	addw	a5,a5,a4
  answer = ~sum; /* truncate to 16 bits */
    80005fd2:	fff7c793          	not	a5,a5
  ip->ip_sum = in_cksum((unsigned char *)ip, sizeof(*ip));
    80005fd6:	00f49c23          	sh	a5,24(s1)

  struct udp *udp = (struct udp *)(ip + 1);
  udp->sport = htons(sport);
    80005fda:	fcc42783          	lw	a5,-52(s0)
  return (((val & 0x00ffU) << 8) | ((val & 0xff00U) >> 8));
    80005fde:	0087971b          	slliw	a4,a5,0x8
    80005fe2:	0107979b          	slliw	a5,a5,0x10
    80005fe6:	0107d79b          	srliw	a5,a5,0x10
    80005fea:	0087d79b          	srliw	a5,a5,0x8
    80005fee:	8fd9                	or	a5,a5,a4
    80005ff0:	02f49123          	sh	a5,34(s1)
  udp->dport = htons(dport);
    80005ff4:	fc442783          	lw	a5,-60(s0)
    80005ff8:	0087971b          	slliw	a4,a5,0x8
    80005ffc:	0107979b          	slliw	a5,a5,0x10
    80006000:	0107d79b          	srliw	a5,a5,0x10
    80006004:	0087d79b          	srliw	a5,a5,0x8
    80006008:	8fd9                	or	a5,a5,a4
    8000600a:	02f49223          	sh	a5,36(s1)
  udp->ulen = htons(len + sizeof(struct udp));
    8000600e:	0088079b          	addiw	a5,a6,8
    80006012:	0087971b          	slliw	a4,a5,0x8
    80006016:	0107979b          	slliw	a5,a5,0x10
    8000601a:	0107d79b          	srliw	a5,a5,0x10
    8000601e:	0087d79b          	srliw	a5,a5,0x8
    80006022:	8fd9                	or	a5,a5,a4
    80006024:	02f49323          	sh	a5,38(s1)

  char *payload = (char *)(udp + 1);
  if (copyin(p->pagetable, payload, bufaddr, len) < 0) {
    80006028:	fb843603          	ld	a2,-72(s0)
    8000602c:	02a48593          	addi	a1,s1,42
    80006030:	0509b503          	ld	a0,80(s3)
    80006034:	ffffb097          	auipc	ra,0xffffb
    80006038:	c04080e7          	jalr	-1020(ra) # 80000c38 <copyin>
    8000603c:	02054a63          	bltz	a0,80006070 <sys_send+0x200>
    kfree(buf);
    printf("send: copyin failed\n");
    return -1;
  }

  e1000_transmit(buf, total);
    80006040:	85ca                	mv	a1,s2
    80006042:	8526                	mv	a0,s1
    80006044:	00000097          	auipc	ra,0x0
    80006048:	8a4080e7          	jalr	-1884(ra) # 800058e8 <e1000_transmit>

  return 0;
    8000604c:	4501                	li	a0,0
}
    8000604e:	60a6                	ld	ra,72(sp)
    80006050:	6406                	ld	s0,64(sp)
    80006052:	74e2                	ld	s1,56(sp)
    80006054:	7942                	ld	s2,48(sp)
    80006056:	79a2                	ld	s3,40(sp)
    80006058:	6161                	addi	sp,sp,80
    8000605a:	8082                	ret
    printf("sys_send: kalloc failed\n");
    8000605c:	00004517          	auipc	a0,0x4
    80006060:	81450513          	addi	a0,a0,-2028 # 80009870 <syscalls+0x460>
    80006064:	00001097          	auipc	ra,0x1
    80006068:	9c4080e7          	jalr	-1596(ra) # 80006a28 <printf>
    return -1;
    8000606c:	557d                	li	a0,-1
    8000606e:	b7c5                	j	8000604e <sys_send+0x1de>
    kfree(buf);
    80006070:	8526                	mv	a0,s1
    80006072:	ffffa097          	auipc	ra,0xffffa
    80006076:	faa080e7          	jalr	-86(ra) # 8000001c <kfree>
    printf("send: copyin failed\n");
    8000607a:	00004517          	auipc	a0,0x4
    8000607e:	81650513          	addi	a0,a0,-2026 # 80009890 <syscalls+0x480>
    80006082:	00001097          	auipc	ra,0x1
    80006086:	9a6080e7          	jalr	-1626(ra) # 80006a28 <printf>
    return -1;
    8000608a:	557d                	li	a0,-1
    8000608c:	b7c9                	j	8000604e <sys_send+0x1de>

000000008000608e <udp_rx>:

void udp_rx(char *buf, int len) {
    8000608e:	715d                	addi	sp,sp,-80
    80006090:	e486                	sd	ra,72(sp)
    80006092:	e0a2                	sd	s0,64(sp)
    80006094:	fc26                	sd	s1,56(sp)
    80006096:	f84a                	sd	s2,48(sp)
    80006098:	f44e                	sd	s3,40(sp)
    8000609a:	f052                	sd	s4,32(sp)
    8000609c:	ec56                	sd	s5,24(sp)
    8000609e:	e85a                	sd	s6,16(sp)
    800060a0:	e45e                	sd	s7,8(sp)
    800060a2:	e062                	sd	s8,0(sp)
    800060a4:	0880                	addi	s0,sp,80
    800060a6:	89aa                	mv	s3,a0
    800060a8:	02455783          	lhu	a5,36(a0)
    800060ac:	0087971b          	slliw	a4,a5,0x8
    800060b0:	83a1                	srli	a5,a5,0x8
    800060b2:	8fd9                	or	a5,a5,a4
    800060b4:	17c2                	slli	a5,a5,0x30
    800060b6:	93c1                	srli	a5,a5,0x30
  struct ip *ip = (struct ip *)((struct eth *)buf + 1);
  struct udp *udp = (struct udp *)(ip + 1);

  uint16 port = ntohs(udp->dport);
  struct port_buffer *port_buf = &ports[port];
    800060b8:	00078a9b          	sext.w	s5,a5

  acquire(&port_buf->port_buf_lock);
    800060bc:	1a000a13          	li	s4,416
    800060c0:	034784b3          	mul	s1,a5,s4
    800060c4:	18848b13          	addi	s6,s1,392
    800060c8:	00015917          	auipc	s2,0x15
    800060cc:	f0090913          	addi	s2,s2,-256 # 8001afc8 <ports>
    800060d0:	9b4a                	add	s6,s6,s2
    800060d2:	855a                	mv	a0,s6
    800060d4:	00001097          	auipc	ra,0x1
    800060d8:	e42080e7          	jalr	-446(ra) # 80006f16 <acquire>
  if (!port_buf->init || port_buf->count >= PORT_BUFFER_SIZE) {
    800060dc:	034a8a33          	mul	s4,s5,s4
    800060e0:	9952                	add	s2,s2,s4
    800060e2:	18294783          	lbu	a5,386(s2)
    800060e6:	c3ed                	beqz	a5,800061c8 <udp_rx+0x13a>
    800060e8:	18094703          	lbu	a4,384(s2)
    800060ec:	47bd                	li	a5,15
    800060ee:	0ce7ed63          	bltu	a5,a4,800061c8 <udp_rx+0x13a>
    800060f2:	0269d903          	lhu	s2,38(s3)
    800060f6:	0089179b          	slliw	a5,s2,0x8
    800060fa:	00895913          	srli	s2,s2,0x8
    800060fe:	00f96933          	or	s2,s2,a5
    release(&port_buf->port_buf_lock);
    return;
  }

  int payload_len = ntohs(udp->ulen) - sizeof(struct udp);
    80006102:	0109191b          	slliw	s2,s2,0x10
    80006106:	0109591b          	srliw	s2,s2,0x10
    8000610a:	3961                	addiw	s2,s2,-8
    8000610c:	00090b9b          	sext.w	s7,s2

  if (payload_len <= 0) {
    80006110:	0d705d63          	blez	s7,800061ea <udp_rx+0x15c>
    release(&port_buf->port_buf_lock);
    return;
  }

  char *data = (char *)(udp + 1);
    80006114:	02a98c13          	addi	s8,s3,42
  char *newbuf = kalloc();
    80006118:	ffffa097          	auipc	ra,0xffffa
    8000611c:	002080e7          	jalr	2(ra) # 8000011a <kalloc>
    80006120:	8a2a                	mv	s4,a0
  if (!newbuf) {
    80006122:	c971                	beqz	a0,800061f6 <udp_rx+0x168>
    release(&port_buf->port_buf_lock);
    return;
  }

  memmove(newbuf, data, payload_len);
    80006124:	865e                	mv	a2,s7
    80006126:	85e2                	mv	a1,s8
    80006128:	ffffa097          	auipc	ra,0xffffa
    8000612c:	0ae080e7          	jalr	174(ra) # 800001d6 <memmove>

  struct packet_info *packet_info =
      &port_buf
           ->packet_queue[(port_buf->ind + port_buf->count) % PORT_BUFFER_SIZE];
    80006130:	00015517          	auipc	a0,0x15
    80006134:	e9850513          	addi	a0,a0,-360 # 8001afc8 <ports>
    80006138:	1a000313          	li	t1,416
    8000613c:	026a8333          	mul	t1,s5,t1
    80006140:	006508b3          	add	a7,a0,t1
    80006144:	1808c803          	lbu	a6,384(a7)
    80006148:	1818c603          	lbu	a2,385(a7)
    8000614c:	0106063b          	addw	a2,a2,a6
    80006150:	8a3d                	andi	a2,a2,15

  packet_info->data = newbuf;
    80006152:	00161793          	slli	a5,a2,0x1
    80006156:	00c78733          	add	a4,a5,a2
    8000615a:	070e                	slli	a4,a4,0x3
    8000615c:	971a                	add	a4,a4,t1
    8000615e:	972a                	add	a4,a4,a0
    80006160:	01473023          	sd	s4,0(a4)
  packet_info->len = payload_len;
    80006164:	01272423          	sw	s2,8(a4)
  packet_info->ip_addr = ntohl(ip->ip_src);
    80006168:	01a9a683          	lw	a3,26(s3)
  return (((val & 0x000000ffUL) << 24) | ((val & 0x0000ff00UL) << 8) |
    8000616c:	0186959b          	slliw	a1,a3,0x18
          ((val & 0x00ff0000UL) >> 8) | ((val & 0xff000000UL) >> 24));
    80006170:	0186de1b          	srliw	t3,a3,0x18
    80006174:	01c5e5b3          	or	a1,a1,t3
  return (((val & 0x000000ffUL) << 24) | ((val & 0x0000ff00UL) << 8) |
    80006178:	00869e1b          	slliw	t3,a3,0x8
    8000617c:	00ff0eb7          	lui	t4,0xff0
    80006180:	01de7e33          	and	t3,t3,t4
          ((val & 0x00ff0000UL) >> 8) | ((val & 0xff000000UL) >> 24));
    80006184:	01c5e5b3          	or	a1,a1,t3
    80006188:	0086d69b          	srliw	a3,a3,0x8
    8000618c:	6e41                	lui	t3,0x10
    8000618e:	f00e0e13          	addi	t3,t3,-256 # ff00 <_entry-0x7fff0100>
    80006192:	01c6f6b3          	and	a3,a3,t3
    80006196:	8ecd                	or	a3,a3,a1
    80006198:	c754                	sw	a3,12(a4)
  packet_info->sport = ntohs(udp->sport);
    8000619a:	87ba                	mv	a5,a4
  return (((val & 0x00ffU) << 8) | ((val & 0xff00U) >> 8));
    8000619c:	0229d703          	lhu	a4,34(s3)
    800061a0:	0087169b          	slliw	a3,a4,0x8
    800061a4:	8321                	srli	a4,a4,0x8
    800061a6:	8f55                	or	a4,a4,a3
    800061a8:	00e79823          	sh	a4,16(a5)
  port_buf->count++;
    800061ac:	2805                	addiw	a6,a6,1
    800061ae:	19088023          	sb	a6,384(a7)

  wakeup(port_buf);
    800061b2:	9526                	add	a0,a0,s1
    800061b4:	ffffb097          	auipc	ra,0xffffb
    800061b8:	448080e7          	jalr	1096(ra) # 800015fc <wakeup>

  release(&port_buf->port_buf_lock);
    800061bc:	855a                	mv	a0,s6
    800061be:	00001097          	auipc	ra,0x1
    800061c2:	e0c080e7          	jalr	-500(ra) # 80006fca <release>
    800061c6:	a031                	j	800061d2 <udp_rx+0x144>
    release(&port_buf->port_buf_lock);
    800061c8:	855a                	mv	a0,s6
    800061ca:	00001097          	auipc	ra,0x1
    800061ce:	e00080e7          	jalr	-512(ra) # 80006fca <release>
}
    800061d2:	60a6                	ld	ra,72(sp)
    800061d4:	6406                	ld	s0,64(sp)
    800061d6:	74e2                	ld	s1,56(sp)
    800061d8:	7942                	ld	s2,48(sp)
    800061da:	79a2                	ld	s3,40(sp)
    800061dc:	7a02                	ld	s4,32(sp)
    800061de:	6ae2                	ld	s5,24(sp)
    800061e0:	6b42                	ld	s6,16(sp)
    800061e2:	6ba2                	ld	s7,8(sp)
    800061e4:	6c02                	ld	s8,0(sp)
    800061e6:	6161                	addi	sp,sp,80
    800061e8:	8082                	ret
    release(&port_buf->port_buf_lock);
    800061ea:	855a                	mv	a0,s6
    800061ec:	00001097          	auipc	ra,0x1
    800061f0:	dde080e7          	jalr	-546(ra) # 80006fca <release>
    return;
    800061f4:	bff9                	j	800061d2 <udp_rx+0x144>
    release(&port_buf->port_buf_lock);
    800061f6:	855a                	mv	a0,s6
    800061f8:	00001097          	auipc	ra,0x1
    800061fc:	dd2080e7          	jalr	-558(ra) # 80006fca <release>
    return;
    80006200:	bfc9                	j	800061d2 <udp_rx+0x144>

0000000080006202 <ip_rx>:

void ip_rx(char *buf, int len) {
    80006202:	1101                	addi	sp,sp,-32
    80006204:	ec06                	sd	ra,24(sp)
    80006206:	e822                	sd	s0,16(sp)
    80006208:	e426                	sd	s1,8(sp)
    8000620a:	e04a                	sd	s2,0(sp)
    8000620c:	1000                	addi	s0,sp,32
    8000620e:	892a                	mv	s2,a0
    80006210:	84ae                	mv	s1,a1
  // don't delete this printf
  static int seen_ip = 0;
  if (seen_ip == 0) printf("ip_rx: received an IP packet\n");
    80006212:	00004797          	auipc	a5,0x4
    80006216:	81a7a783          	lw	a5,-2022(a5) # 80009a2c <seen_ip.1>
    8000621a:	c78d                	beqz	a5,80006244 <ip_rx+0x42>
  seen_ip = 1;
    8000621c:	4785                	li	a5,1
    8000621e:	00004717          	auipc	a4,0x4
    80006222:	80f72723          	sw	a5,-2034(a4) # 80009a2c <seen_ip.1>

  int headers_size =
      sizeof(struct eth) + sizeof(struct ip) + sizeof(struct udp);

  if (len < headers_size) {
    80006226:	02900793          	li	a5,41
    8000622a:	0097d763          	bge	a5,s1,80006238 <ip_rx+0x36>
  }

  struct ip *ip = (struct ip *)((struct eth *)buf + 1);

  // UDP = 17
  if (ip->ip_p == 17) {
    8000622e:	01794703          	lbu	a4,23(s2)
    80006232:	47c5                	li	a5,17
    80006234:	02f70163          	beq	a4,a5,80006256 <ip_rx+0x54>
    udp_rx(buf, len);
  }
}
    80006238:	60e2                	ld	ra,24(sp)
    8000623a:	6442                	ld	s0,16(sp)
    8000623c:	64a2                	ld	s1,8(sp)
    8000623e:	6902                	ld	s2,0(sp)
    80006240:	6105                	addi	sp,sp,32
    80006242:	8082                	ret
  if (seen_ip == 0) printf("ip_rx: received an IP packet\n");
    80006244:	00003517          	auipc	a0,0x3
    80006248:	66450513          	addi	a0,a0,1636 # 800098a8 <syscalls+0x498>
    8000624c:	00000097          	auipc	ra,0x0
    80006250:	7dc080e7          	jalr	2012(ra) # 80006a28 <printf>
    80006254:	b7e1                	j	8000621c <ip_rx+0x1a>
    udp_rx(buf, len);
    80006256:	85a6                	mv	a1,s1
    80006258:	854a                	mv	a0,s2
    8000625a:	00000097          	auipc	ra,0x0
    8000625e:	e34080e7          	jalr	-460(ra) # 8000608e <udp_rx>
    80006262:	bfd9                	j	80006238 <ip_rx+0x36>

0000000080006264 <arp_rx>:
// protocol is more complex.
//
void arp_rx(char *inbuf) {
  static int seen_arp = 0;

  if (seen_arp) {
    80006264:	00003797          	auipc	a5,0x3
    80006268:	7c47a783          	lw	a5,1988(a5) # 80009a28 <seen_arp.0>
    8000626c:	c391                	beqz	a5,80006270 <arp_rx+0xc>
    8000626e:	8082                	ret
void arp_rx(char *inbuf) {
    80006270:	7179                	addi	sp,sp,-48
    80006272:	f406                	sd	ra,40(sp)
    80006274:	f022                	sd	s0,32(sp)
    80006276:	ec26                	sd	s1,24(sp)
    80006278:	e84a                	sd	s2,16(sp)
    8000627a:	e44e                	sd	s3,8(sp)
    8000627c:	e052                	sd	s4,0(sp)
    8000627e:	1800                	addi	s0,sp,48
    80006280:	892a                	mv	s2,a0
    return;
  }
  printf("arp_rx: received an ARP packet\n");
    80006282:	00003517          	auipc	a0,0x3
    80006286:	64650513          	addi	a0,a0,1606 # 800098c8 <syscalls+0x4b8>
    8000628a:	00000097          	auipc	ra,0x0
    8000628e:	79e080e7          	jalr	1950(ra) # 80006a28 <printf>
  seen_arp = 1;
    80006292:	4785                	li	a5,1
    80006294:	00003717          	auipc	a4,0x3
    80006298:	78f72a23          	sw	a5,1940(a4) # 80009a28 <seen_arp.0>

  struct eth *ineth = (struct eth *)inbuf;
  struct arp *inarp = (struct arp *)(ineth + 1);

  char *buf = kalloc();
    8000629c:	ffffa097          	auipc	ra,0xffffa
    800062a0:	e7e080e7          	jalr	-386(ra) # 8000011a <kalloc>
    800062a4:	84aa                	mv	s1,a0
  if (buf == 0) panic("send_arp_reply");
    800062a6:	c56d                	beqz	a0,80006390 <arp_rx+0x12c>

  struct eth *eth = (struct eth *)buf;
  memmove(eth->dhost, ineth->shost,
    800062a8:	00690993          	addi	s3,s2,6
    800062ac:	4619                	li	a2,6
    800062ae:	85ce                	mv	a1,s3
    800062b0:	ffffa097          	auipc	ra,0xffffa
    800062b4:	f26080e7          	jalr	-218(ra) # 800001d6 <memmove>
          ETHADDR_LEN);  // ethernet destination = query source
  memmove(eth->shost, local_mac,
    800062b8:	4619                	li	a2,6
    800062ba:	00003597          	auipc	a1,0x3
    800062be:	6d658593          	addi	a1,a1,1750 # 80009990 <local_mac>
    800062c2:	00648513          	addi	a0,s1,6
    800062c6:	ffffa097          	auipc	ra,0xffffa
    800062ca:	f10080e7          	jalr	-240(ra) # 800001d6 <memmove>
          ETHADDR_LEN);  // ethernet source = xv6's ethernet address
  eth->type = htons(ETHTYPE_ARP);
    800062ce:	47a1                	li	a5,8
    800062d0:	00f48623          	sb	a5,12(s1)
    800062d4:	4719                	li	a4,6
    800062d6:	00e486a3          	sb	a4,13(s1)

  struct arp *arp = (struct arp *)(eth + 1);
  arp->hrd = htons(ARP_HRD_ETHER);
    800062da:	00048723          	sb	zero,14(s1)
    800062de:	4705                	li	a4,1
    800062e0:	00e487a3          	sb	a4,15(s1)
  arp->pro = htons(ETHTYPE_IP);
    800062e4:	00f48823          	sb	a5,16(s1)
    800062e8:	000488a3          	sb	zero,17(s1)
  arp->hln = ETHADDR_LEN;
    800062ec:	4799                	li	a5,6
    800062ee:	00f48923          	sb	a5,18(s1)
  arp->pln = sizeof(uint32);
    800062f2:	4791                	li	a5,4
    800062f4:	00f489a3          	sb	a5,19(s1)
  arp->op = htons(ARP_OP_REPLY);
    800062f8:	00048a23          	sb	zero,20(s1)
    800062fc:	4a09                	li	s4,2
    800062fe:	01448aa3          	sb	s4,21(s1)

  memmove(arp->sha, local_mac, ETHADDR_LEN);
    80006302:	4619                	li	a2,6
    80006304:	00003597          	auipc	a1,0x3
    80006308:	68c58593          	addi	a1,a1,1676 # 80009990 <local_mac>
    8000630c:	01648513          	addi	a0,s1,22
    80006310:	ffffa097          	auipc	ra,0xffffa
    80006314:	ec6080e7          	jalr	-314(ra) # 800001d6 <memmove>
  arp->sip = htonl(local_ip);
    80006318:	47a9                	li	a5,10
    8000631a:	00f48e23          	sb	a5,28(s1)
    8000631e:	00048ea3          	sb	zero,29(s1)
    80006322:	01448f23          	sb	s4,30(s1)
    80006326:	47bd                	li	a5,15
    80006328:	00f48fa3          	sb	a5,31(s1)
  memmove(arp->tha, ineth->shost, ETHADDR_LEN);
    8000632c:	4619                	li	a2,6
    8000632e:	85ce                	mv	a1,s3
    80006330:	02048513          	addi	a0,s1,32
    80006334:	ffffa097          	auipc	ra,0xffffa
    80006338:	ea2080e7          	jalr	-350(ra) # 800001d6 <memmove>
  arp->tip = inarp->sip;
    8000633c:	01c94703          	lbu	a4,28(s2)
    80006340:	01d94783          	lbu	a5,29(s2)
    80006344:	07a2                	slli	a5,a5,0x8
    80006346:	8fd9                	or	a5,a5,a4
    80006348:	01e94703          	lbu	a4,30(s2)
    8000634c:	0742                	slli	a4,a4,0x10
    8000634e:	8f5d                	or	a4,a4,a5
    80006350:	01f94783          	lbu	a5,31(s2)
    80006354:	07e2                	slli	a5,a5,0x18
    80006356:	8fd9                	or	a5,a5,a4
    80006358:	02f48323          	sb	a5,38(s1)
    8000635c:	0087d713          	srli	a4,a5,0x8
    80006360:	02e483a3          	sb	a4,39(s1)
    80006364:	0107d713          	srli	a4,a5,0x10
    80006368:	02e48423          	sb	a4,40(s1)
    8000636c:	83e1                	srli	a5,a5,0x18
    8000636e:	02f484a3          	sb	a5,41(s1)

  e1000_transmit(buf, sizeof(*eth) + sizeof(*arp));
    80006372:	02a00593          	li	a1,42
    80006376:	8526                	mv	a0,s1
    80006378:	fffff097          	auipc	ra,0xfffff
    8000637c:	570080e7          	jalr	1392(ra) # 800058e8 <e1000_transmit>
}
    80006380:	70a2                	ld	ra,40(sp)
    80006382:	7402                	ld	s0,32(sp)
    80006384:	64e2                	ld	s1,24(sp)
    80006386:	6942                	ld	s2,16(sp)
    80006388:	69a2                	ld	s3,8(sp)
    8000638a:	6a02                	ld	s4,0(sp)
    8000638c:	6145                	addi	sp,sp,48
    8000638e:	8082                	ret
  if (buf == 0) panic("send_arp_reply");
    80006390:	00003517          	auipc	a0,0x3
    80006394:	55850513          	addi	a0,a0,1368 # 800098e8 <syscalls+0x4d8>
    80006398:	00000097          	auipc	ra,0x0
    8000639c:	646080e7          	jalr	1606(ra) # 800069de <panic>

00000000800063a0 <net_rx>:

void net_rx(char *buf, int len) {
    800063a0:	1101                	addi	sp,sp,-32
    800063a2:	ec06                	sd	ra,24(sp)
    800063a4:	e822                	sd	s0,16(sp)
    800063a6:	e426                	sd	s1,8(sp)
    800063a8:	1000                	addi	s0,sp,32
    800063aa:	84aa                	mv	s1,a0
  struct eth *eth = (struct eth *)buf;

  if (len >= sizeof(struct eth) + sizeof(struct arp) &&
    800063ac:	0005879b          	sext.w	a5,a1
    800063b0:	02900713          	li	a4,41
    800063b4:	04f77f63          	bgeu	a4,a5,80006412 <net_rx+0x72>
      ntohs(eth->type) == ETHTYPE_ARP) {
    800063b8:	00c54703          	lbu	a4,12(a0)
    800063bc:	00d54783          	lbu	a5,13(a0)
    800063c0:	07a2                	slli	a5,a5,0x8
    800063c2:	8fd9                	or	a5,a5,a4
    800063c4:	0087971b          	slliw	a4,a5,0x8
    800063c8:	83a1                	srli	a5,a5,0x8
    800063ca:	8fd9                	or	a5,a5,a4
  if (len >= sizeof(struct eth) + sizeof(struct arp) &&
    800063cc:	17c2                	slli	a5,a5,0x30
    800063ce:	93c1                	srli	a5,a5,0x30
    800063d0:	6705                	lui	a4,0x1
    800063d2:	80670713          	addi	a4,a4,-2042 # 806 <_entry-0x7ffff7fa>
    800063d6:	02e78963          	beq	a5,a4,80006408 <net_rx+0x68>
    arp_rx(buf);
  } else if (len >= sizeof(struct eth) + sizeof(struct ip) &&
             ntohs(eth->type) == ETHTYPE_IP) {
    800063da:	00c4c703          	lbu	a4,12(s1)
    800063de:	00d4c783          	lbu	a5,13(s1)
    800063e2:	07a2                	slli	a5,a5,0x8
    800063e4:	8fd9                	or	a5,a5,a4
    800063e6:	0087971b          	slliw	a4,a5,0x8
    800063ea:	83a1                	srli	a5,a5,0x8
    800063ec:	8fd9                	or	a5,a5,a4
  } else if (len >= sizeof(struct eth) + sizeof(struct ip) &&
    800063ee:	0107979b          	slliw	a5,a5,0x10
    800063f2:	0107d79b          	srliw	a5,a5,0x10
    800063f6:	8007879b          	addiw	a5,a5,-2048
    800063fa:	e385                	bnez	a5,8000641a <net_rx+0x7a>
    ip_rx(buf, len);
    800063fc:	8526                	mv	a0,s1
    800063fe:	00000097          	auipc	ra,0x0
    80006402:	e04080e7          	jalr	-508(ra) # 80006202 <ip_rx>
    80006406:	a811                	j	8000641a <net_rx+0x7a>
    arp_rx(buf);
    80006408:	00000097          	auipc	ra,0x0
    8000640c:	e5c080e7          	jalr	-420(ra) # 80006264 <arp_rx>
    80006410:	a029                	j	8000641a <net_rx+0x7a>
  } else if (len >= sizeof(struct eth) + sizeof(struct ip) &&
    80006412:	02100713          	li	a4,33
    80006416:	fcf762e3          	bltu	a4,a5,800063da <net_rx+0x3a>
  }
  kfree(buf);
    8000641a:	8526                	mv	a0,s1
    8000641c:	ffffa097          	auipc	ra,0xffffa
    80006420:	c00080e7          	jalr	-1024(ra) # 8000001c <kfree>
}
    80006424:	60e2                	ld	ra,24(sp)
    80006426:	6442                	ld	s0,16(sp)
    80006428:	64a2                	ld	s1,8(sp)
    8000642a:	6105                	addi	sp,sp,32
    8000642c:	8082                	ret

000000008000642e <pci_init>:
#include "proc.h"
#include "riscv.h"
#include "spinlock.h"
#include "types.h"

void pci_init() {
    8000642e:	715d                	addi	sp,sp,-80
    80006430:	e486                	sd	ra,72(sp)
    80006432:	e0a2                	sd	s0,64(sp)
    80006434:	fc26                	sd	s1,56(sp)
    80006436:	f84a                	sd	s2,48(sp)
    80006438:	f44e                	sd	s3,40(sp)
    8000643a:	f052                	sd	s4,32(sp)
    8000643c:	ec56                	sd	s5,24(sp)
    8000643e:	e85a                	sd	s6,16(sp)
    80006440:	e45e                	sd	s7,8(sp)
    80006442:	0880                	addi	s0,sp,80
    80006444:	300004b7          	lui	s1,0x30000
    uint32 off = (bus << 16) | (dev << 11) | (func << 8) | (offset);
    volatile uint32 *base = ecam + off;
    uint32 id = base[0];

    // 100e:8086 is an e1000
    if (id == 0x100e8086) {
    80006448:	100e8937          	lui	s2,0x100e8
    8000644c:	08690913          	addi	s2,s2,134 # 100e8086 <_entry-0x6ff17f7a>
      // command and status register.
      // bit 0 : I/O access enable
      // bit 1 : memory access enable
      // bit 2 : enable mastering
      base[1] = 7;
    80006450:	4b9d                	li	s7,7
      for (int i = 0; i < 6; i++) {
        uint32 old = base[4 + i];

        // writing all 1's to the BAR causes it to be
        // replaced with its size.
        base[4 + i] = 0xffffffff;
    80006452:	5afd                	li	s5,-1
        base[4 + i] = old;
      }

      // tell the e1000 to reveal its registers at
      // physical address 0x40000000.
      base[4 + 0] = e1000_regs;
    80006454:	40000b37          	lui	s6,0x40000
  for (int dev = 0; dev < 32; dev++) {
    80006458:	6a09                	lui	s4,0x2
    8000645a:	300409b7          	lui	s3,0x30040
    8000645e:	a819                	j	80006474 <pci_init+0x46>
      base[4 + 0] = e1000_regs;
    80006460:	0166a823          	sw	s6,16(a3)

      e1000_init((uint32 *)e1000_regs);
    80006464:	855a                	mv	a0,s6
    80006466:	fffff097          	auipc	ra,0xfffff
    8000646a:	2cc080e7          	jalr	716(ra) # 80005732 <e1000_init>
  for (int dev = 0; dev < 32; dev++) {
    8000646e:	94d2                	add	s1,s1,s4
    80006470:	03348a63          	beq	s1,s3,800064a4 <pci_init+0x76>
    volatile uint32 *base = ecam + off;
    80006474:	86a6                	mv	a3,s1
    uint32 id = base[0];
    80006476:	409c                	lw	a5,0(s1)
    80006478:	2781                	sext.w	a5,a5
    if (id == 0x100e8086) {
    8000647a:	ff279ae3          	bne	a5,s2,8000646e <pci_init+0x40>
      base[1] = 7;
    8000647e:	0174a223          	sw	s7,4(s1) # 30000004 <_entry-0x4ffffffc>
      __sync_synchronize();
    80006482:	0ff0000f          	fence
      for (int i = 0; i < 6; i++) {
    80006486:	01048793          	addi	a5,s1,16
    8000648a:	02848613          	addi	a2,s1,40
        uint32 old = base[4 + i];
    8000648e:	4398                	lw	a4,0(a5)
    80006490:	2701                	sext.w	a4,a4
        base[4 + i] = 0xffffffff;
    80006492:	0157a023          	sw	s5,0(a5)
        __sync_synchronize();
    80006496:	0ff0000f          	fence
        base[4 + i] = old;
    8000649a:	c398                	sw	a4,0(a5)
      for (int i = 0; i < 6; i++) {
    8000649c:	0791                	addi	a5,a5,4
    8000649e:	fec798e3          	bne	a5,a2,8000648e <pci_init+0x60>
    800064a2:	bf7d                	j	80006460 <pci_init+0x32>
    }
  }
}
    800064a4:	60a6                	ld	ra,72(sp)
    800064a6:	6406                	ld	s0,64(sp)
    800064a8:	74e2                	ld	s1,56(sp)
    800064aa:	7942                	ld	s2,48(sp)
    800064ac:	79a2                	ld	s3,40(sp)
    800064ae:	7a02                	ld	s4,32(sp)
    800064b0:	6ae2                	ld	s5,24(sp)
    800064b2:	6b42                	ld	s6,16(sp)
    800064b4:	6ba2                	ld	s7,8(sp)
    800064b6:	6161                	addi	sp,sp,80
    800064b8:	8082                	ret

00000000800064ba <timerinit>:
// arrange to receive timer interrupts.
// they will arrive in machine mode at
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void timerinit() {
    800064ba:	1141                	addi	sp,sp,-16
    800064bc:	e422                	sd	s0,8(sp)
    800064be:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r"(x));
    800064c0:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800064c4:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000;  // cycles; about 1/10th second in qemu.
  *(uint64 *)CLINT_MTIMECMP(id) = *(uint64 *)CLINT_MTIME + interval;
    800064c8:	0037979b          	slliw	a5,a5,0x3
    800064cc:	02004737          	lui	a4,0x2004
    800064d0:	97ba                	add	a5,a5,a4
    800064d2:	0200c737          	lui	a4,0x200c
    800064d6:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800064da:	000f4637          	lui	a2,0xf4
    800064de:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800064e2:	9732                	add	a4,a4,a2
    800064e4:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800064e6:	00259693          	slli	a3,a1,0x2
    800064ea:	96ae                	add	a3,a3,a1
    800064ec:	068e                	slli	a3,a3,0x3
    800064ee:	000e5717          	auipc	a4,0xe5
    800064f2:	c8270713          	addi	a4,a4,-894 # 800eb170 <timer_scratch>
    800064f6:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800064f8:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800064fa:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r"(x));
    800064fc:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r"(x));
    80006500:	fffff797          	auipc	a5,0xfffff
    80006504:	c0078793          	addi	a5,a5,-1024 # 80005100 <timervec>
    80006508:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r"(x));
    8000650c:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80006510:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80006514:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r"(x));
    80006518:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000651c:	0807e793          	ori	a5,a5,128
static inline void w_mie(uint64 x) { asm volatile("csrw mie, %0" : : "r"(x)); }
    80006520:	30479073          	csrw	mie,a5
}
    80006524:	6422                	ld	s0,8(sp)
    80006526:	0141                	addi	sp,sp,16
    80006528:	8082                	ret

000000008000652a <start>:
void start() {
    8000652a:	1141                	addi	sp,sp,-16
    8000652c:	e406                	sd	ra,8(sp)
    8000652e:	e022                	sd	s0,0(sp)
    80006530:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80006532:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80006536:	7779                	lui	a4,0xffffe
    80006538:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ff0b44f>
    8000653c:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000653e:	6705                	lui	a4,0x1
    80006540:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80006544:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80006546:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    8000654a:	ffffa797          	auipc	a5,0xffffa
    8000654e:	dd678793          	addi	a5,a5,-554 # 80000320 <main>
    80006552:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    80006556:	4781                	li	a5,0
    80006558:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    8000655c:	67c1                	lui	a5,0x10
    8000655e:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80006560:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    80006564:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    80006568:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000656c:	2227e793          	ori	a5,a5,546
static inline void w_sie(uint64 x) { asm volatile("csrw sie, %0" : : "r"(x)); }
    80006570:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    80006574:	57fd                	li	a5,-1
    80006576:	83a9                	srli	a5,a5,0xa
    80006578:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    8000657c:	47bd                	li	a5,15
    8000657e:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80006582:	00000097          	auipc	ra,0x0
    80006586:	f38080e7          	jalr	-200(ra) # 800064ba <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    8000658a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000658e:	2781                	sext.w	a5,a5
static inline void w_tp(uint64 x) { asm volatile("mv tp, %0" : : "r"(x)); }
    80006590:	823e                	mv	tp,a5
  asm volatile("mret");
    80006592:	30200073          	mret
}
    80006596:	60a2                	ld	ra,8(sp)
    80006598:	6402                	ld	s0,0(sp)
    8000659a:	0141                	addi	sp,sp,16
    8000659c:	8082                	ret

000000008000659e <consolewrite>:
} cons;

//
// user write()s to the console go here.
//
int consolewrite(int user_src, uint64 src, int n) {
    8000659e:	715d                	addi	sp,sp,-80
    800065a0:	e486                	sd	ra,72(sp)
    800065a2:	e0a2                	sd	s0,64(sp)
    800065a4:	fc26                	sd	s1,56(sp)
    800065a6:	f84a                	sd	s2,48(sp)
    800065a8:	f44e                	sd	s3,40(sp)
    800065aa:	f052                	sd	s4,32(sp)
    800065ac:	ec56                	sd	s5,24(sp)
    800065ae:	0880                	addi	s0,sp,80
  int i;

  for (i = 0; i < n; i++) {
    800065b0:	04c05763          	blez	a2,800065fe <consolewrite+0x60>
    800065b4:	8a2a                	mv	s4,a0
    800065b6:	84ae                	mv	s1,a1
    800065b8:	89b2                	mv	s3,a2
    800065ba:	4901                	li	s2,0
    char c;
    if (either_copyin(&c, user_src, src + i, 1) == -1) break;
    800065bc:	5afd                	li	s5,-1
    800065be:	4685                	li	a3,1
    800065c0:	8626                	mv	a2,s1
    800065c2:	85d2                	mv	a1,s4
    800065c4:	fbf40513          	addi	a0,s0,-65
    800065c8:	ffffb097          	auipc	ra,0xffffb
    800065cc:	42e080e7          	jalr	1070(ra) # 800019f6 <either_copyin>
    800065d0:	01550d63          	beq	a0,s5,800065ea <consolewrite+0x4c>
    uartputc(c);
    800065d4:	fbf44503          	lbu	a0,-65(s0)
    800065d8:	00000097          	auipc	ra,0x0
    800065dc:	784080e7          	jalr	1924(ra) # 80006d5c <uartputc>
  for (i = 0; i < n; i++) {
    800065e0:	2905                	addiw	s2,s2,1
    800065e2:	0485                	addi	s1,s1,1
    800065e4:	fd299de3          	bne	s3,s2,800065be <consolewrite+0x20>
    800065e8:	894e                	mv	s2,s3
  }

  return i;
}
    800065ea:	854a                	mv	a0,s2
    800065ec:	60a6                	ld	ra,72(sp)
    800065ee:	6406                	ld	s0,64(sp)
    800065f0:	74e2                	ld	s1,56(sp)
    800065f2:	7942                	ld	s2,48(sp)
    800065f4:	79a2                	ld	s3,40(sp)
    800065f6:	7a02                	ld	s4,32(sp)
    800065f8:	6ae2                	ld	s5,24(sp)
    800065fa:	6161                	addi	sp,sp,80
    800065fc:	8082                	ret
  for (i = 0; i < n; i++) {
    800065fe:	4901                	li	s2,0
    80006600:	b7ed                	j	800065ea <consolewrite+0x4c>

0000000080006602 <consoleread>:
// user read()s from the console go here.
// copy (up to) a whole input line to dst.
// user_dist indicates whether dst is a user
// or kernel address.
//
int consoleread(int user_dst, uint64 dst, int n) {
    80006602:	7159                	addi	sp,sp,-112
    80006604:	f486                	sd	ra,104(sp)
    80006606:	f0a2                	sd	s0,96(sp)
    80006608:	eca6                	sd	s1,88(sp)
    8000660a:	e8ca                	sd	s2,80(sp)
    8000660c:	e4ce                	sd	s3,72(sp)
    8000660e:	e0d2                	sd	s4,64(sp)
    80006610:	fc56                	sd	s5,56(sp)
    80006612:	f85a                	sd	s6,48(sp)
    80006614:	f45e                	sd	s7,40(sp)
    80006616:	f062                	sd	s8,32(sp)
    80006618:	ec66                	sd	s9,24(sp)
    8000661a:	e86a                	sd	s10,16(sp)
    8000661c:	1880                	addi	s0,sp,112
    8000661e:	8aaa                	mv	s5,a0
    80006620:	8a2e                	mv	s4,a1
    80006622:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80006624:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80006628:	000ed517          	auipc	a0,0xed
    8000662c:	c8850513          	addi	a0,a0,-888 # 800f32b0 <cons>
    80006630:	00001097          	auipc	ra,0x1
    80006634:	8e6080e7          	jalr	-1818(ra) # 80006f16 <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    80006638:	000ed497          	auipc	s1,0xed
    8000663c:	c7848493          	addi	s1,s1,-904 # 800f32b0 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80006640:	000ed917          	auipc	s2,0xed
    80006644:	d0890913          	addi	s2,s2,-760 # 800f3348 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if (c == C('D')) {  // end-of-file
    80006648:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1) break;
    8000664a:	5c7d                	li	s8,-1

    dst++;
    --n;

    if (c == '\n') {
    8000664c:	4ca9                	li	s9,10
  while (n > 0) {
    8000664e:	07305b63          	blez	s3,800066c4 <consoleread+0xc2>
    while (cons.r == cons.w) {
    80006652:	0984a783          	lw	a5,152(s1)
    80006656:	09c4a703          	lw	a4,156(s1)
    8000665a:	02f71763          	bne	a4,a5,80006688 <consoleread+0x86>
      if (killed(myproc())) {
    8000665e:	ffffb097          	auipc	ra,0xffffb
    80006662:	88e080e7          	jalr	-1906(ra) # 80000eec <myproc>
    80006666:	ffffb097          	auipc	ra,0xffffb
    8000666a:	1da080e7          	jalr	474(ra) # 80001840 <killed>
    8000666e:	e535                	bnez	a0,800066da <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    80006670:	85a6                	mv	a1,s1
    80006672:	854a                	mv	a0,s2
    80006674:	ffffb097          	auipc	ra,0xffffb
    80006678:	f24080e7          	jalr	-220(ra) # 80001598 <sleep>
    while (cons.r == cons.w) {
    8000667c:	0984a783          	lw	a5,152(s1)
    80006680:	09c4a703          	lw	a4,156(s1)
    80006684:	fcf70de3          	beq	a4,a5,8000665e <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80006688:	0017871b          	addiw	a4,a5,1
    8000668c:	08e4ac23          	sw	a4,152(s1)
    80006690:	07f7f713          	andi	a4,a5,127
    80006694:	9726                	add	a4,a4,s1
    80006696:	01874703          	lbu	a4,24(a4)
    8000669a:	00070d1b          	sext.w	s10,a4
    if (c == C('D')) {  // end-of-file
    8000669e:	077d0563          	beq	s10,s7,80006708 <consoleread+0x106>
    cbuf = c;
    800066a2:	f8e40fa3          	sb	a4,-97(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1) break;
    800066a6:	4685                	li	a3,1
    800066a8:	f9f40613          	addi	a2,s0,-97
    800066ac:	85d2                	mv	a1,s4
    800066ae:	8556                	mv	a0,s5
    800066b0:	ffffb097          	auipc	ra,0xffffb
    800066b4:	2f0080e7          	jalr	752(ra) # 800019a0 <either_copyout>
    800066b8:	01850663          	beq	a0,s8,800066c4 <consoleread+0xc2>
    dst++;
    800066bc:	0a05                	addi	s4,s4,1 # 2001 <_entry-0x7fffdfff>
    --n;
    800066be:	39fd                	addiw	s3,s3,-1 # 3003ffff <_entry-0x4ffc0001>
    if (c == '\n') {
    800066c0:	f99d17e3          	bne	s10,s9,8000664e <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800066c4:	000ed517          	auipc	a0,0xed
    800066c8:	bec50513          	addi	a0,a0,-1044 # 800f32b0 <cons>
    800066cc:	00001097          	auipc	ra,0x1
    800066d0:	8fe080e7          	jalr	-1794(ra) # 80006fca <release>

  return target - n;
    800066d4:	413b053b          	subw	a0,s6,s3
    800066d8:	a811                	j	800066ec <consoleread+0xea>
        release(&cons.lock);
    800066da:	000ed517          	auipc	a0,0xed
    800066de:	bd650513          	addi	a0,a0,-1066 # 800f32b0 <cons>
    800066e2:	00001097          	auipc	ra,0x1
    800066e6:	8e8080e7          	jalr	-1816(ra) # 80006fca <release>
        return -1;
    800066ea:	557d                	li	a0,-1
}
    800066ec:	70a6                	ld	ra,104(sp)
    800066ee:	7406                	ld	s0,96(sp)
    800066f0:	64e6                	ld	s1,88(sp)
    800066f2:	6946                	ld	s2,80(sp)
    800066f4:	69a6                	ld	s3,72(sp)
    800066f6:	6a06                	ld	s4,64(sp)
    800066f8:	7ae2                	ld	s5,56(sp)
    800066fa:	7b42                	ld	s6,48(sp)
    800066fc:	7ba2                	ld	s7,40(sp)
    800066fe:	7c02                	ld	s8,32(sp)
    80006700:	6ce2                	ld	s9,24(sp)
    80006702:	6d42                	ld	s10,16(sp)
    80006704:	6165                	addi	sp,sp,112
    80006706:	8082                	ret
      if (n < target) {
    80006708:	0009871b          	sext.w	a4,s3
    8000670c:	fb677ce3          	bgeu	a4,s6,800066c4 <consoleread+0xc2>
        cons.r--;
    80006710:	000ed717          	auipc	a4,0xed
    80006714:	c2f72c23          	sw	a5,-968(a4) # 800f3348 <cons+0x98>
    80006718:	b775                	j	800066c4 <consoleread+0xc2>

000000008000671a <consputc>:
void consputc(int c) {
    8000671a:	1141                	addi	sp,sp,-16
    8000671c:	e406                	sd	ra,8(sp)
    8000671e:	e022                	sd	s0,0(sp)
    80006720:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    80006722:	10000793          	li	a5,256
    80006726:	00f50a63          	beq	a0,a5,8000673a <consputc+0x20>
    uartputc_sync(c);
    8000672a:	00000097          	auipc	ra,0x0
    8000672e:	560080e7          	jalr	1376(ra) # 80006c8a <uartputc_sync>
}
    80006732:	60a2                	ld	ra,8(sp)
    80006734:	6402                	ld	s0,0(sp)
    80006736:	0141                	addi	sp,sp,16
    80006738:	8082                	ret
    uartputc_sync('\b');
    8000673a:	4521                	li	a0,8
    8000673c:	00000097          	auipc	ra,0x0
    80006740:	54e080e7          	jalr	1358(ra) # 80006c8a <uartputc_sync>
    uartputc_sync(' ');
    80006744:	02000513          	li	a0,32
    80006748:	00000097          	auipc	ra,0x0
    8000674c:	542080e7          	jalr	1346(ra) # 80006c8a <uartputc_sync>
    uartputc_sync('\b');
    80006750:	4521                	li	a0,8
    80006752:	00000097          	auipc	ra,0x0
    80006756:	538080e7          	jalr	1336(ra) # 80006c8a <uartputc_sync>
    8000675a:	bfe1                	j	80006732 <consputc+0x18>

000000008000675c <consoleintr>:
// the console input interrupt handler.
// uartintr() calls this for input character.
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void consoleintr(int c) {
    8000675c:	1101                	addi	sp,sp,-32
    8000675e:	ec06                	sd	ra,24(sp)
    80006760:	e822                	sd	s0,16(sp)
    80006762:	e426                	sd	s1,8(sp)
    80006764:	e04a                	sd	s2,0(sp)
    80006766:	1000                	addi	s0,sp,32
    80006768:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000676a:	000ed517          	auipc	a0,0xed
    8000676e:	b4650513          	addi	a0,a0,-1210 # 800f32b0 <cons>
    80006772:	00000097          	auipc	ra,0x0
    80006776:	7a4080e7          	jalr	1956(ra) # 80006f16 <acquire>

  switch (c) {
    8000677a:	47d5                	li	a5,21
    8000677c:	0af48663          	beq	s1,a5,80006828 <consoleintr+0xcc>
    80006780:	0297ca63          	blt	a5,s1,800067b4 <consoleintr+0x58>
    80006784:	47a1                	li	a5,8
    80006786:	0ef48763          	beq	s1,a5,80006874 <consoleintr+0x118>
    8000678a:	47c1                	li	a5,16
    8000678c:	10f49a63          	bne	s1,a5,800068a0 <consoleintr+0x144>
    case C('P'):  // Print process list.
      procdump();
    80006790:	ffffb097          	auipc	ra,0xffffb
    80006794:	2bc080e7          	jalr	700(ra) # 80001a4c <procdump>
        }
      }
      break;
  }

  release(&cons.lock);
    80006798:	000ed517          	auipc	a0,0xed
    8000679c:	b1850513          	addi	a0,a0,-1256 # 800f32b0 <cons>
    800067a0:	00001097          	auipc	ra,0x1
    800067a4:	82a080e7          	jalr	-2006(ra) # 80006fca <release>
}
    800067a8:	60e2                	ld	ra,24(sp)
    800067aa:	6442                	ld	s0,16(sp)
    800067ac:	64a2                	ld	s1,8(sp)
    800067ae:	6902                	ld	s2,0(sp)
    800067b0:	6105                	addi	sp,sp,32
    800067b2:	8082                	ret
  switch (c) {
    800067b4:	07f00793          	li	a5,127
    800067b8:	0af48e63          	beq	s1,a5,80006874 <consoleintr+0x118>
      if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    800067bc:	000ed717          	auipc	a4,0xed
    800067c0:	af470713          	addi	a4,a4,-1292 # 800f32b0 <cons>
    800067c4:	0a072783          	lw	a5,160(a4)
    800067c8:	09872703          	lw	a4,152(a4)
    800067cc:	9f99                	subw	a5,a5,a4
    800067ce:	07f00713          	li	a4,127
    800067d2:	fcf763e3          	bltu	a4,a5,80006798 <consoleintr+0x3c>
        c = (c == '\r') ? '\n' : c;
    800067d6:	47b5                	li	a5,13
    800067d8:	0cf48763          	beq	s1,a5,800068a6 <consoleintr+0x14a>
        consputc(c);
    800067dc:	8526                	mv	a0,s1
    800067de:	00000097          	auipc	ra,0x0
    800067e2:	f3c080e7          	jalr	-196(ra) # 8000671a <consputc>
        cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800067e6:	000ed797          	auipc	a5,0xed
    800067ea:	aca78793          	addi	a5,a5,-1334 # 800f32b0 <cons>
    800067ee:	0a07a683          	lw	a3,160(a5)
    800067f2:	0016871b          	addiw	a4,a3,1
    800067f6:	0007061b          	sext.w	a2,a4
    800067fa:	0ae7a023          	sw	a4,160(a5)
    800067fe:	07f6f693          	andi	a3,a3,127
    80006802:	97b6                	add	a5,a5,a3
    80006804:	00978c23          	sb	s1,24(a5)
        if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    80006808:	47a9                	li	a5,10
    8000680a:	0cf48563          	beq	s1,a5,800068d4 <consoleintr+0x178>
    8000680e:	4791                	li	a5,4
    80006810:	0cf48263          	beq	s1,a5,800068d4 <consoleintr+0x178>
    80006814:	000ed797          	auipc	a5,0xed
    80006818:	b347a783          	lw	a5,-1228(a5) # 800f3348 <cons+0x98>
    8000681c:	9f1d                	subw	a4,a4,a5
    8000681e:	08000793          	li	a5,128
    80006822:	f6f71be3          	bne	a4,a5,80006798 <consoleintr+0x3c>
    80006826:	a07d                	j	800068d4 <consoleintr+0x178>
      while (cons.e != cons.w &&
    80006828:	000ed717          	auipc	a4,0xed
    8000682c:	a8870713          	addi	a4,a4,-1400 # 800f32b0 <cons>
    80006830:	0a072783          	lw	a5,160(a4)
    80006834:	09c72703          	lw	a4,156(a4)
             cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80006838:	000ed497          	auipc	s1,0xed
    8000683c:	a7848493          	addi	s1,s1,-1416 # 800f32b0 <cons>
      while (cons.e != cons.w &&
    80006840:	4929                	li	s2,10
    80006842:	f4f70be3          	beq	a4,a5,80006798 <consoleintr+0x3c>
             cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80006846:	37fd                	addiw	a5,a5,-1
    80006848:	07f7f713          	andi	a4,a5,127
    8000684c:	9726                	add	a4,a4,s1
      while (cons.e != cons.w &&
    8000684e:	01874703          	lbu	a4,24(a4)
    80006852:	f52703e3          	beq	a4,s2,80006798 <consoleintr+0x3c>
        cons.e--;
    80006856:	0af4a023          	sw	a5,160(s1)
        consputc(BACKSPACE);
    8000685a:	10000513          	li	a0,256
    8000685e:	00000097          	auipc	ra,0x0
    80006862:	ebc080e7          	jalr	-324(ra) # 8000671a <consputc>
      while (cons.e != cons.w &&
    80006866:	0a04a783          	lw	a5,160(s1)
    8000686a:	09c4a703          	lw	a4,156(s1)
    8000686e:	fcf71ce3          	bne	a4,a5,80006846 <consoleintr+0xea>
    80006872:	b71d                	j	80006798 <consoleintr+0x3c>
      if (cons.e != cons.w) {
    80006874:	000ed717          	auipc	a4,0xed
    80006878:	a3c70713          	addi	a4,a4,-1476 # 800f32b0 <cons>
    8000687c:	0a072783          	lw	a5,160(a4)
    80006880:	09c72703          	lw	a4,156(a4)
    80006884:	f0f70ae3          	beq	a4,a5,80006798 <consoleintr+0x3c>
        cons.e--;
    80006888:	37fd                	addiw	a5,a5,-1
    8000688a:	000ed717          	auipc	a4,0xed
    8000688e:	acf72323          	sw	a5,-1338(a4) # 800f3350 <cons+0xa0>
        consputc(BACKSPACE);
    80006892:	10000513          	li	a0,256
    80006896:	00000097          	auipc	ra,0x0
    8000689a:	e84080e7          	jalr	-380(ra) # 8000671a <consputc>
    8000689e:	bded                	j	80006798 <consoleintr+0x3c>
      if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    800068a0:	ee048ce3          	beqz	s1,80006798 <consoleintr+0x3c>
    800068a4:	bf21                	j	800067bc <consoleintr+0x60>
        consputc(c);
    800068a6:	4529                	li	a0,10
    800068a8:	00000097          	auipc	ra,0x0
    800068ac:	e72080e7          	jalr	-398(ra) # 8000671a <consputc>
        cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800068b0:	000ed797          	auipc	a5,0xed
    800068b4:	a0078793          	addi	a5,a5,-1536 # 800f32b0 <cons>
    800068b8:	0a07a703          	lw	a4,160(a5)
    800068bc:	0017069b          	addiw	a3,a4,1
    800068c0:	0006861b          	sext.w	a2,a3
    800068c4:	0ad7a023          	sw	a3,160(a5)
    800068c8:	07f77713          	andi	a4,a4,127
    800068cc:	97ba                	add	a5,a5,a4
    800068ce:	4729                	li	a4,10
    800068d0:	00e78c23          	sb	a4,24(a5)
          cons.w = cons.e;
    800068d4:	000ed797          	auipc	a5,0xed
    800068d8:	a6c7ac23          	sw	a2,-1416(a5) # 800f334c <cons+0x9c>
          wakeup(&cons.r);
    800068dc:	000ed517          	auipc	a0,0xed
    800068e0:	a6c50513          	addi	a0,a0,-1428 # 800f3348 <cons+0x98>
    800068e4:	ffffb097          	auipc	ra,0xffffb
    800068e8:	d18080e7          	jalr	-744(ra) # 800015fc <wakeup>
    800068ec:	b575                	j	80006798 <consoleintr+0x3c>

00000000800068ee <consoleinit>:

void consoleinit(void) {
    800068ee:	1141                	addi	sp,sp,-16
    800068f0:	e406                	sd	ra,8(sp)
    800068f2:	e022                	sd	s0,0(sp)
    800068f4:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800068f6:	00003597          	auipc	a1,0x3
    800068fa:	00258593          	addi	a1,a1,2 # 800098f8 <syscalls+0x4e8>
    800068fe:	000ed517          	auipc	a0,0xed
    80006902:	9b250513          	addi	a0,a0,-1614 # 800f32b0 <cons>
    80006906:	00000097          	auipc	ra,0x0
    8000690a:	580080e7          	jalr	1408(ra) # 80006e86 <initlock>

  uartinit();
    8000690e:	00000097          	auipc	ra,0x0
    80006912:	32c080e7          	jalr	812(ra) # 80006c3a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80006916:	00013797          	auipc	a5,0x13
    8000691a:	1d278793          	addi	a5,a5,466 # 80019ae8 <devsw>
    8000691e:	00000717          	auipc	a4,0x0
    80006922:	ce470713          	addi	a4,a4,-796 # 80006602 <consoleread>
    80006926:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80006928:	00000717          	auipc	a4,0x0
    8000692c:	c7670713          	addi	a4,a4,-906 # 8000659e <consolewrite>
    80006930:	ef98                	sd	a4,24(a5)
}
    80006932:	60a2                	ld	ra,8(sp)
    80006934:	6402                	ld	s0,0(sp)
    80006936:	0141                	addi	sp,sp,16
    80006938:	8082                	ret

000000008000693a <printint>:
  int locking;
} pr;

static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign) {
    8000693a:	7179                	addi	sp,sp,-48
    8000693c:	f406                	sd	ra,40(sp)
    8000693e:	f022                	sd	s0,32(sp)
    80006940:	ec26                	sd	s1,24(sp)
    80006942:	e84a                	sd	s2,16(sp)
    80006944:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if (sign && (sign = xx < 0))
    80006946:	c219                	beqz	a2,8000694c <printint+0x12>
    80006948:	08054763          	bltz	a0,800069d6 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    8000694c:	2501                	sext.w	a0,a0
    8000694e:	4881                	li	a7,0
    80006950:	fd040693          	addi	a3,s0,-48

  i = 0;
    80006954:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80006956:	2581                	sext.w	a1,a1
    80006958:	00003617          	auipc	a2,0x3
    8000695c:	fd060613          	addi	a2,a2,-48 # 80009928 <digits>
    80006960:	883a                	mv	a6,a4
    80006962:	2705                	addiw	a4,a4,1
    80006964:	02b577bb          	remuw	a5,a0,a1
    80006968:	1782                	slli	a5,a5,0x20
    8000696a:	9381                	srli	a5,a5,0x20
    8000696c:	97b2                	add	a5,a5,a2
    8000696e:	0007c783          	lbu	a5,0(a5)
    80006972:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    80006976:	0005079b          	sext.w	a5,a0
    8000697a:	02b5553b          	divuw	a0,a0,a1
    8000697e:	0685                	addi	a3,a3,1
    80006980:	feb7f0e3          	bgeu	a5,a1,80006960 <printint+0x26>

  if (sign) buf[i++] = '-';
    80006984:	00088c63          	beqz	a7,8000699c <printint+0x62>
    80006988:	fe070793          	addi	a5,a4,-32
    8000698c:	00878733          	add	a4,a5,s0
    80006990:	02d00793          	li	a5,45
    80006994:	fef70823          	sb	a5,-16(a4)
    80006998:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) consputc(buf[i]);
    8000699c:	02e05763          	blez	a4,800069ca <printint+0x90>
    800069a0:	fd040793          	addi	a5,s0,-48
    800069a4:	00e784b3          	add	s1,a5,a4
    800069a8:	fff78913          	addi	s2,a5,-1
    800069ac:	993a                	add	s2,s2,a4
    800069ae:	377d                	addiw	a4,a4,-1
    800069b0:	1702                	slli	a4,a4,0x20
    800069b2:	9301                	srli	a4,a4,0x20
    800069b4:	40e90933          	sub	s2,s2,a4
    800069b8:	fff4c503          	lbu	a0,-1(s1)
    800069bc:	00000097          	auipc	ra,0x0
    800069c0:	d5e080e7          	jalr	-674(ra) # 8000671a <consputc>
    800069c4:	14fd                	addi	s1,s1,-1
    800069c6:	ff2499e3          	bne	s1,s2,800069b8 <printint+0x7e>
}
    800069ca:	70a2                	ld	ra,40(sp)
    800069cc:	7402                	ld	s0,32(sp)
    800069ce:	64e2                	ld	s1,24(sp)
    800069d0:	6942                	ld	s2,16(sp)
    800069d2:	6145                	addi	sp,sp,48
    800069d4:	8082                	ret
    x = -xx;
    800069d6:	40a0053b          	negw	a0,a0
  if (sign && (sign = xx < 0))
    800069da:	4885                	li	a7,1
    x = -xx;
    800069dc:	bf95                	j	80006950 <printint+0x16>

00000000800069de <panic>:
  va_end(ap);

  if (locking) release(&pr.lock);
}

void panic(char *s) {
    800069de:	1101                	addi	sp,sp,-32
    800069e0:	ec06                	sd	ra,24(sp)
    800069e2:	e822                	sd	s0,16(sp)
    800069e4:	e426                	sd	s1,8(sp)
    800069e6:	1000                	addi	s0,sp,32
    800069e8:	84aa                	mv	s1,a0
  pr.locking = 0;
    800069ea:	000ed797          	auipc	a5,0xed
    800069ee:	9807a323          	sw	zero,-1658(a5) # 800f3370 <pr+0x18>
  printf("panic: ");
    800069f2:	00003517          	auipc	a0,0x3
    800069f6:	f0e50513          	addi	a0,a0,-242 # 80009900 <syscalls+0x4f0>
    800069fa:	00000097          	auipc	ra,0x0
    800069fe:	02e080e7          	jalr	46(ra) # 80006a28 <printf>
  printf(s);
    80006a02:	8526                	mv	a0,s1
    80006a04:	00000097          	auipc	ra,0x0
    80006a08:	024080e7          	jalr	36(ra) # 80006a28 <printf>
  printf("\n");
    80006a0c:	00002517          	auipc	a0,0x2
    80006a10:	63c50513          	addi	a0,a0,1596 # 80009048 <etext+0x48>
    80006a14:	00000097          	auipc	ra,0x0
    80006a18:	014080e7          	jalr	20(ra) # 80006a28 <printf>
  panicked = 1;  // freeze uart output from other CPUs
    80006a1c:	4785                	li	a5,1
    80006a1e:	00003717          	auipc	a4,0x3
    80006a22:	00f72923          	sw	a5,18(a4) # 80009a30 <panicked>
  for (;;);
    80006a26:	a001                	j	80006a26 <panic+0x48>

0000000080006a28 <printf>:
void printf(char *fmt, ...) {
    80006a28:	7131                	addi	sp,sp,-192
    80006a2a:	fc86                	sd	ra,120(sp)
    80006a2c:	f8a2                	sd	s0,112(sp)
    80006a2e:	f4a6                	sd	s1,104(sp)
    80006a30:	f0ca                	sd	s2,96(sp)
    80006a32:	ecce                	sd	s3,88(sp)
    80006a34:	e8d2                	sd	s4,80(sp)
    80006a36:	e4d6                	sd	s5,72(sp)
    80006a38:	e0da                	sd	s6,64(sp)
    80006a3a:	fc5e                	sd	s7,56(sp)
    80006a3c:	f862                	sd	s8,48(sp)
    80006a3e:	f466                	sd	s9,40(sp)
    80006a40:	f06a                	sd	s10,32(sp)
    80006a42:	ec6e                	sd	s11,24(sp)
    80006a44:	0100                	addi	s0,sp,128
    80006a46:	8a2a                	mv	s4,a0
    80006a48:	e40c                	sd	a1,8(s0)
    80006a4a:	e810                	sd	a2,16(s0)
    80006a4c:	ec14                	sd	a3,24(s0)
    80006a4e:	f018                	sd	a4,32(s0)
    80006a50:	f41c                	sd	a5,40(s0)
    80006a52:	03043823          	sd	a6,48(s0)
    80006a56:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006a5a:	000edd97          	auipc	s11,0xed
    80006a5e:	916dad83          	lw	s11,-1770(s11) # 800f3370 <pr+0x18>
  if (locking) acquire(&pr.lock);
    80006a62:	020d9b63          	bnez	s11,80006a98 <printf+0x70>
  if (fmt == 0) panic("null fmt");
    80006a66:	040a0263          	beqz	s4,80006aaa <printf+0x82>
  va_start(ap, fmt);
    80006a6a:	00840793          	addi	a5,s0,8
    80006a6e:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80006a72:	000a4503          	lbu	a0,0(s4)
    80006a76:	14050f63          	beqz	a0,80006bd4 <printf+0x1ac>
    80006a7a:	4981                	li	s3,0
    if (c != '%') {
    80006a7c:	02500a93          	li	s5,37
    switch (c) {
    80006a80:	07000b93          	li	s7,112
  consputc('x');
    80006a84:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006a86:	00003b17          	auipc	s6,0x3
    80006a8a:	ea2b0b13          	addi	s6,s6,-350 # 80009928 <digits>
    switch (c) {
    80006a8e:	07300c93          	li	s9,115
    80006a92:	06400c13          	li	s8,100
    80006a96:	a82d                	j	80006ad0 <printf+0xa8>
  if (locking) acquire(&pr.lock);
    80006a98:	000ed517          	auipc	a0,0xed
    80006a9c:	8c050513          	addi	a0,a0,-1856 # 800f3358 <pr>
    80006aa0:	00000097          	auipc	ra,0x0
    80006aa4:	476080e7          	jalr	1142(ra) # 80006f16 <acquire>
    80006aa8:	bf7d                	j	80006a66 <printf+0x3e>
  if (fmt == 0) panic("null fmt");
    80006aaa:	00003517          	auipc	a0,0x3
    80006aae:	e6650513          	addi	a0,a0,-410 # 80009910 <syscalls+0x500>
    80006ab2:	00000097          	auipc	ra,0x0
    80006ab6:	f2c080e7          	jalr	-212(ra) # 800069de <panic>
      consputc(c);
    80006aba:	00000097          	auipc	ra,0x0
    80006abe:	c60080e7          	jalr	-928(ra) # 8000671a <consputc>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80006ac2:	2985                	addiw	s3,s3,1
    80006ac4:	013a07b3          	add	a5,s4,s3
    80006ac8:	0007c503          	lbu	a0,0(a5)
    80006acc:	10050463          	beqz	a0,80006bd4 <printf+0x1ac>
    if (c != '%') {
    80006ad0:	ff5515e3          	bne	a0,s5,80006aba <printf+0x92>
    c = fmt[++i] & 0xff;
    80006ad4:	2985                	addiw	s3,s3,1
    80006ad6:	013a07b3          	add	a5,s4,s3
    80006ada:	0007c783          	lbu	a5,0(a5)
    80006ade:	0007849b          	sext.w	s1,a5
    if (c == 0) break;
    80006ae2:	cbed                	beqz	a5,80006bd4 <printf+0x1ac>
    switch (c) {
    80006ae4:	05778a63          	beq	a5,s7,80006b38 <printf+0x110>
    80006ae8:	02fbf663          	bgeu	s7,a5,80006b14 <printf+0xec>
    80006aec:	09978863          	beq	a5,s9,80006b7c <printf+0x154>
    80006af0:	07800713          	li	a4,120
    80006af4:	0ce79563          	bne	a5,a4,80006bbe <printf+0x196>
        printint(va_arg(ap, int), 16, 1);
    80006af8:	f8843783          	ld	a5,-120(s0)
    80006afc:	00878713          	addi	a4,a5,8
    80006b00:	f8e43423          	sd	a4,-120(s0)
    80006b04:	4605                	li	a2,1
    80006b06:	85ea                	mv	a1,s10
    80006b08:	4388                	lw	a0,0(a5)
    80006b0a:	00000097          	auipc	ra,0x0
    80006b0e:	e30080e7          	jalr	-464(ra) # 8000693a <printint>
        break;
    80006b12:	bf45                	j	80006ac2 <printf+0x9a>
    switch (c) {
    80006b14:	09578f63          	beq	a5,s5,80006bb2 <printf+0x18a>
    80006b18:	0b879363          	bne	a5,s8,80006bbe <printf+0x196>
        printint(va_arg(ap, int), 10, 1);
    80006b1c:	f8843783          	ld	a5,-120(s0)
    80006b20:	00878713          	addi	a4,a5,8
    80006b24:	f8e43423          	sd	a4,-120(s0)
    80006b28:	4605                	li	a2,1
    80006b2a:	45a9                	li	a1,10
    80006b2c:	4388                	lw	a0,0(a5)
    80006b2e:	00000097          	auipc	ra,0x0
    80006b32:	e0c080e7          	jalr	-500(ra) # 8000693a <printint>
        break;
    80006b36:	b771                	j	80006ac2 <printf+0x9a>
        printptr(va_arg(ap, uint64));
    80006b38:	f8843783          	ld	a5,-120(s0)
    80006b3c:	00878713          	addi	a4,a5,8
    80006b40:	f8e43423          	sd	a4,-120(s0)
    80006b44:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80006b48:	03000513          	li	a0,48
    80006b4c:	00000097          	auipc	ra,0x0
    80006b50:	bce080e7          	jalr	-1074(ra) # 8000671a <consputc>
  consputc('x');
    80006b54:	07800513          	li	a0,120
    80006b58:	00000097          	auipc	ra,0x0
    80006b5c:	bc2080e7          	jalr	-1086(ra) # 8000671a <consputc>
    80006b60:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006b62:	03c95793          	srli	a5,s2,0x3c
    80006b66:	97da                	add	a5,a5,s6
    80006b68:	0007c503          	lbu	a0,0(a5)
    80006b6c:	00000097          	auipc	ra,0x0
    80006b70:	bae080e7          	jalr	-1106(ra) # 8000671a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006b74:	0912                	slli	s2,s2,0x4
    80006b76:	34fd                	addiw	s1,s1,-1
    80006b78:	f4ed                	bnez	s1,80006b62 <printf+0x13a>
    80006b7a:	b7a1                	j	80006ac2 <printf+0x9a>
        if ((s = va_arg(ap, char *)) == 0) s = "(null)";
    80006b7c:	f8843783          	ld	a5,-120(s0)
    80006b80:	00878713          	addi	a4,a5,8
    80006b84:	f8e43423          	sd	a4,-120(s0)
    80006b88:	6384                	ld	s1,0(a5)
    80006b8a:	cc89                	beqz	s1,80006ba4 <printf+0x17c>
        for (; *s; s++) consputc(*s);
    80006b8c:	0004c503          	lbu	a0,0(s1)
    80006b90:	d90d                	beqz	a0,80006ac2 <printf+0x9a>
    80006b92:	00000097          	auipc	ra,0x0
    80006b96:	b88080e7          	jalr	-1144(ra) # 8000671a <consputc>
    80006b9a:	0485                	addi	s1,s1,1
    80006b9c:	0004c503          	lbu	a0,0(s1)
    80006ba0:	f96d                	bnez	a0,80006b92 <printf+0x16a>
    80006ba2:	b705                	j	80006ac2 <printf+0x9a>
        if ((s = va_arg(ap, char *)) == 0) s = "(null)";
    80006ba4:	00003497          	auipc	s1,0x3
    80006ba8:	d6448493          	addi	s1,s1,-668 # 80009908 <syscalls+0x4f8>
        for (; *s; s++) consputc(*s);
    80006bac:	02800513          	li	a0,40
    80006bb0:	b7cd                	j	80006b92 <printf+0x16a>
        consputc('%');
    80006bb2:	8556                	mv	a0,s5
    80006bb4:	00000097          	auipc	ra,0x0
    80006bb8:	b66080e7          	jalr	-1178(ra) # 8000671a <consputc>
        break;
    80006bbc:	b719                	j	80006ac2 <printf+0x9a>
        consputc('%');
    80006bbe:	8556                	mv	a0,s5
    80006bc0:	00000097          	auipc	ra,0x0
    80006bc4:	b5a080e7          	jalr	-1190(ra) # 8000671a <consputc>
        consputc(c);
    80006bc8:	8526                	mv	a0,s1
    80006bca:	00000097          	auipc	ra,0x0
    80006bce:	b50080e7          	jalr	-1200(ra) # 8000671a <consputc>
        break;
    80006bd2:	bdc5                	j	80006ac2 <printf+0x9a>
  if (locking) release(&pr.lock);
    80006bd4:	020d9163          	bnez	s11,80006bf6 <printf+0x1ce>
}
    80006bd8:	70e6                	ld	ra,120(sp)
    80006bda:	7446                	ld	s0,112(sp)
    80006bdc:	74a6                	ld	s1,104(sp)
    80006bde:	7906                	ld	s2,96(sp)
    80006be0:	69e6                	ld	s3,88(sp)
    80006be2:	6a46                	ld	s4,80(sp)
    80006be4:	6aa6                	ld	s5,72(sp)
    80006be6:	6b06                	ld	s6,64(sp)
    80006be8:	7be2                	ld	s7,56(sp)
    80006bea:	7c42                	ld	s8,48(sp)
    80006bec:	7ca2                	ld	s9,40(sp)
    80006bee:	7d02                	ld	s10,32(sp)
    80006bf0:	6de2                	ld	s11,24(sp)
    80006bf2:	6129                	addi	sp,sp,192
    80006bf4:	8082                	ret
  if (locking) release(&pr.lock);
    80006bf6:	000ec517          	auipc	a0,0xec
    80006bfa:	76250513          	addi	a0,a0,1890 # 800f3358 <pr>
    80006bfe:	00000097          	auipc	ra,0x0
    80006c02:	3cc080e7          	jalr	972(ra) # 80006fca <release>
}
    80006c06:	bfc9                	j	80006bd8 <printf+0x1b0>

0000000080006c08 <printfinit>:
}

void printfinit(void) {
    80006c08:	1101                	addi	sp,sp,-32
    80006c0a:	ec06                	sd	ra,24(sp)
    80006c0c:	e822                	sd	s0,16(sp)
    80006c0e:	e426                	sd	s1,8(sp)
    80006c10:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006c12:	000ec497          	auipc	s1,0xec
    80006c16:	74648493          	addi	s1,s1,1862 # 800f3358 <pr>
    80006c1a:	00003597          	auipc	a1,0x3
    80006c1e:	d0658593          	addi	a1,a1,-762 # 80009920 <syscalls+0x510>
    80006c22:	8526                	mv	a0,s1
    80006c24:	00000097          	auipc	ra,0x0
    80006c28:	262080e7          	jalr	610(ra) # 80006e86 <initlock>
  pr.locking = 1;
    80006c2c:	4785                	li	a5,1
    80006c2e:	cc9c                	sw	a5,24(s1)
}
    80006c30:	60e2                	ld	ra,24(sp)
    80006c32:	6442                	ld	s0,16(sp)
    80006c34:	64a2                	ld	s1,8(sp)
    80006c36:	6105                	addi	sp,sp,32
    80006c38:	8082                	ret

0000000080006c3a <uartinit>:

extern volatile int panicked;  // from printf.c

void uartstart();

void uartinit(void) {
    80006c3a:	1141                	addi	sp,sp,-16
    80006c3c:	e406                	sd	ra,8(sp)
    80006c3e:	e022                	sd	s0,0(sp)
    80006c40:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006c42:	100007b7          	lui	a5,0x10000
    80006c46:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006c4a:	f8000713          	li	a4,-128
    80006c4e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006c52:	470d                	li	a4,3
    80006c54:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006c58:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006c5c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006c60:	469d                	li	a3,7
    80006c62:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006c66:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006c6a:	00003597          	auipc	a1,0x3
    80006c6e:	cd658593          	addi	a1,a1,-810 # 80009940 <digits+0x18>
    80006c72:	000ec517          	auipc	a0,0xec
    80006c76:	70650513          	addi	a0,a0,1798 # 800f3378 <uart_tx_lock>
    80006c7a:	00000097          	auipc	ra,0x0
    80006c7e:	20c080e7          	jalr	524(ra) # 80006e86 <initlock>
}
    80006c82:	60a2                	ld	ra,8(sp)
    80006c84:	6402                	ld	s0,0(sp)
    80006c86:	0141                	addi	sp,sp,16
    80006c88:	8082                	ret

0000000080006c8a <uartputc_sync>:

// alternate version of uartputc() that doesn't
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void uartputc_sync(int c) {
    80006c8a:	1101                	addi	sp,sp,-32
    80006c8c:	ec06                	sd	ra,24(sp)
    80006c8e:	e822                	sd	s0,16(sp)
    80006c90:	e426                	sd	s1,8(sp)
    80006c92:	1000                	addi	s0,sp,32
    80006c94:	84aa                	mv	s1,a0
  push_off();
    80006c96:	00000097          	auipc	ra,0x0
    80006c9a:	234080e7          	jalr	564(ra) # 80006eca <push_off>

  if (panicked) {
    80006c9e:	00003797          	auipc	a5,0x3
    80006ca2:	d927a783          	lw	a5,-622(a5) # 80009a30 <panicked>
    for (;;);
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    80006ca6:	10000737          	lui	a4,0x10000
  if (panicked) {
    80006caa:	c391                	beqz	a5,80006cae <uartputc_sync+0x24>
    for (;;);
    80006cac:	a001                	j	80006cac <uartputc_sync+0x22>
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    80006cae:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006cb2:	0207f793          	andi	a5,a5,32
    80006cb6:	dfe5                	beqz	a5,80006cae <uartputc_sync+0x24>
  WriteReg(THR, c);
    80006cb8:	0ff4f513          	zext.b	a0,s1
    80006cbc:	100007b7          	lui	a5,0x10000
    80006cc0:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006cc4:	00000097          	auipc	ra,0x0
    80006cc8:	2a6080e7          	jalr	678(ra) # 80006f6a <pop_off>
}
    80006ccc:	60e2                	ld	ra,24(sp)
    80006cce:	6442                	ld	s0,16(sp)
    80006cd0:	64a2                	ld	s1,8(sp)
    80006cd2:	6105                	addi	sp,sp,32
    80006cd4:	8082                	ret

0000000080006cd6 <uartstart>:
// in the transmit buffer, send it.
// caller must hold uart_tx_lock.
// called from both the top- and bottom-half.
void uartstart() {
  while (1) {
    if (uart_tx_w == uart_tx_r) {
    80006cd6:	00003797          	auipc	a5,0x3
    80006cda:	d627b783          	ld	a5,-670(a5) # 80009a38 <uart_tx_r>
    80006cde:	00003717          	auipc	a4,0x3
    80006ce2:	d6273703          	ld	a4,-670(a4) # 80009a40 <uart_tx_w>
    80006ce6:	06f70a63          	beq	a4,a5,80006d5a <uartstart+0x84>
void uartstart() {
    80006cea:	7139                	addi	sp,sp,-64
    80006cec:	fc06                	sd	ra,56(sp)
    80006cee:	f822                	sd	s0,48(sp)
    80006cf0:	f426                	sd	s1,40(sp)
    80006cf2:	f04a                	sd	s2,32(sp)
    80006cf4:	ec4e                	sd	s3,24(sp)
    80006cf6:	e852                	sd	s4,16(sp)
    80006cf8:	e456                	sd	s5,8(sp)
    80006cfa:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }

    if ((ReadReg(LSR) & LSR_TX_IDLE) == 0) {
    80006cfc:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }

    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006d00:	000eca17          	auipc	s4,0xec
    80006d04:	678a0a13          	addi	s4,s4,1656 # 800f3378 <uart_tx_lock>
    uart_tx_r += 1;
    80006d08:	00003497          	auipc	s1,0x3
    80006d0c:	d3048493          	addi	s1,s1,-720 # 80009a38 <uart_tx_r>
    if (uart_tx_w == uart_tx_r) {
    80006d10:	00003997          	auipc	s3,0x3
    80006d14:	d3098993          	addi	s3,s3,-720 # 80009a40 <uart_tx_w>
    if ((ReadReg(LSR) & LSR_TX_IDLE) == 0) {
    80006d18:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006d1c:	02077713          	andi	a4,a4,32
    80006d20:	c705                	beqz	a4,80006d48 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006d22:	01f7f713          	andi	a4,a5,31
    80006d26:	9752                	add	a4,a4,s4
    80006d28:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80006d2c:	0785                	addi	a5,a5,1
    80006d2e:	e09c                	sd	a5,0(s1)

    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006d30:	8526                	mv	a0,s1
    80006d32:	ffffb097          	auipc	ra,0xffffb
    80006d36:	8ca080e7          	jalr	-1846(ra) # 800015fc <wakeup>

    WriteReg(THR, c);
    80006d3a:	01590023          	sb	s5,0(s2)
    if (uart_tx_w == uart_tx_r) {
    80006d3e:	609c                	ld	a5,0(s1)
    80006d40:	0009b703          	ld	a4,0(s3)
    80006d44:	fcf71ae3          	bne	a4,a5,80006d18 <uartstart+0x42>
  }
}
    80006d48:	70e2                	ld	ra,56(sp)
    80006d4a:	7442                	ld	s0,48(sp)
    80006d4c:	74a2                	ld	s1,40(sp)
    80006d4e:	7902                	ld	s2,32(sp)
    80006d50:	69e2                	ld	s3,24(sp)
    80006d52:	6a42                	ld	s4,16(sp)
    80006d54:	6aa2                	ld	s5,8(sp)
    80006d56:	6121                	addi	sp,sp,64
    80006d58:	8082                	ret
    80006d5a:	8082                	ret

0000000080006d5c <uartputc>:
void uartputc(int c) {
    80006d5c:	7179                	addi	sp,sp,-48
    80006d5e:	f406                	sd	ra,40(sp)
    80006d60:	f022                	sd	s0,32(sp)
    80006d62:	ec26                	sd	s1,24(sp)
    80006d64:	e84a                	sd	s2,16(sp)
    80006d66:	e44e                	sd	s3,8(sp)
    80006d68:	e052                	sd	s4,0(sp)
    80006d6a:	1800                	addi	s0,sp,48
    80006d6c:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006d6e:	000ec517          	auipc	a0,0xec
    80006d72:	60a50513          	addi	a0,a0,1546 # 800f3378 <uart_tx_lock>
    80006d76:	00000097          	auipc	ra,0x0
    80006d7a:	1a0080e7          	jalr	416(ra) # 80006f16 <acquire>
  if (panicked) {
    80006d7e:	00003797          	auipc	a5,0x3
    80006d82:	cb27a783          	lw	a5,-846(a5) # 80009a30 <panicked>
    80006d86:	e7c9                	bnez	a5,80006e10 <uartputc+0xb4>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    80006d88:	00003717          	auipc	a4,0x3
    80006d8c:	cb873703          	ld	a4,-840(a4) # 80009a40 <uart_tx_w>
    80006d90:	00003797          	auipc	a5,0x3
    80006d94:	ca87b783          	ld	a5,-856(a5) # 80009a38 <uart_tx_r>
    80006d98:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006d9c:	000ec997          	auipc	s3,0xec
    80006da0:	5dc98993          	addi	s3,s3,1500 # 800f3378 <uart_tx_lock>
    80006da4:	00003497          	auipc	s1,0x3
    80006da8:	c9448493          	addi	s1,s1,-876 # 80009a38 <uart_tx_r>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    80006dac:	00003917          	auipc	s2,0x3
    80006db0:	c9490913          	addi	s2,s2,-876 # 80009a40 <uart_tx_w>
    80006db4:	00e79f63          	bne	a5,a4,80006dd2 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006db8:	85ce                	mv	a1,s3
    80006dba:	8526                	mv	a0,s1
    80006dbc:	ffffa097          	auipc	ra,0xffffa
    80006dc0:	7dc080e7          	jalr	2012(ra) # 80001598 <sleep>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    80006dc4:	00093703          	ld	a4,0(s2)
    80006dc8:	609c                	ld	a5,0(s1)
    80006dca:	02078793          	addi	a5,a5,32
    80006dce:	fee785e3          	beq	a5,a4,80006db8 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006dd2:	000ec497          	auipc	s1,0xec
    80006dd6:	5a648493          	addi	s1,s1,1446 # 800f3378 <uart_tx_lock>
    80006dda:	01f77793          	andi	a5,a4,31
    80006dde:	97a6                	add	a5,a5,s1
    80006de0:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006de4:	0705                	addi	a4,a4,1
    80006de6:	00003797          	auipc	a5,0x3
    80006dea:	c4e7bd23          	sd	a4,-934(a5) # 80009a40 <uart_tx_w>
  uartstart();
    80006dee:	00000097          	auipc	ra,0x0
    80006df2:	ee8080e7          	jalr	-280(ra) # 80006cd6 <uartstart>
  release(&uart_tx_lock);
    80006df6:	8526                	mv	a0,s1
    80006df8:	00000097          	auipc	ra,0x0
    80006dfc:	1d2080e7          	jalr	466(ra) # 80006fca <release>
}
    80006e00:	70a2                	ld	ra,40(sp)
    80006e02:	7402                	ld	s0,32(sp)
    80006e04:	64e2                	ld	s1,24(sp)
    80006e06:	6942                	ld	s2,16(sp)
    80006e08:	69a2                	ld	s3,8(sp)
    80006e0a:	6a02                	ld	s4,0(sp)
    80006e0c:	6145                	addi	sp,sp,48
    80006e0e:	8082                	ret
    for (;;);
    80006e10:	a001                	j	80006e10 <uartputc+0xb4>

0000000080006e12 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int uartgetc(void) {
    80006e12:	1141                	addi	sp,sp,-16
    80006e14:	e422                	sd	s0,8(sp)
    80006e16:	0800                	addi	s0,sp,16
  if (ReadReg(LSR) & 0x01) {
    80006e18:	100007b7          	lui	a5,0x10000
    80006e1c:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006e20:	8b85                	andi	a5,a5,1
    80006e22:	cb81                	beqz	a5,80006e32 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006e24:	100007b7          	lui	a5,0x10000
    80006e28:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006e2c:	6422                	ld	s0,8(sp)
    80006e2e:	0141                	addi	sp,sp,16
    80006e30:	8082                	ret
    return -1;
    80006e32:	557d                	li	a0,-1
    80006e34:	bfe5                	j	80006e2c <uartgetc+0x1a>

0000000080006e36 <uartintr>:

// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void uartintr(void) {
    80006e36:	1101                	addi	sp,sp,-32
    80006e38:	ec06                	sd	ra,24(sp)
    80006e3a:	e822                	sd	s0,16(sp)
    80006e3c:	e426                	sd	s1,8(sp)
    80006e3e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while (1) {
    int c = uartgetc();
    if (c == -1) break;
    80006e40:	54fd                	li	s1,-1
    80006e42:	a029                	j	80006e4c <uartintr+0x16>
    consoleintr(c);
    80006e44:	00000097          	auipc	ra,0x0
    80006e48:	918080e7          	jalr	-1768(ra) # 8000675c <consoleintr>
    int c = uartgetc();
    80006e4c:	00000097          	auipc	ra,0x0
    80006e50:	fc6080e7          	jalr	-58(ra) # 80006e12 <uartgetc>
    if (c == -1) break;
    80006e54:	fe9518e3          	bne	a0,s1,80006e44 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006e58:	000ec497          	auipc	s1,0xec
    80006e5c:	52048493          	addi	s1,s1,1312 # 800f3378 <uart_tx_lock>
    80006e60:	8526                	mv	a0,s1
    80006e62:	00000097          	auipc	ra,0x0
    80006e66:	0b4080e7          	jalr	180(ra) # 80006f16 <acquire>
  uartstart();
    80006e6a:	00000097          	auipc	ra,0x0
    80006e6e:	e6c080e7          	jalr	-404(ra) # 80006cd6 <uartstart>
  release(&uart_tx_lock);
    80006e72:	8526                	mv	a0,s1
    80006e74:	00000097          	auipc	ra,0x0
    80006e78:	156080e7          	jalr	342(ra) # 80006fca <release>
}
    80006e7c:	60e2                	ld	ra,24(sp)
    80006e7e:	6442                	ld	s0,16(sp)
    80006e80:	64a2                	ld	s1,8(sp)
    80006e82:	6105                	addi	sp,sp,32
    80006e84:	8082                	ret

0000000080006e86 <initlock>:

#include "defs.h"
#include "proc.h"
#include "riscv.h"

void initlock(struct spinlock *lk, char *name) {
    80006e86:	1141                	addi	sp,sp,-16
    80006e88:	e422                	sd	s0,8(sp)
    80006e8a:	0800                	addi	s0,sp,16
  lk->name = name;
    80006e8c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006e8e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006e92:	00053823          	sd	zero,16(a0)
}
    80006e96:	6422                	ld	s0,8(sp)
    80006e98:	0141                	addi	sp,sp,16
    80006e9a:	8082                	ret

0000000080006e9c <holding>:

// Check whether this cpu is holding the lock.
// Interrupts must be off.
int holding(struct spinlock *lk) {
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006e9c:	411c                	lw	a5,0(a0)
    80006e9e:	e399                	bnez	a5,80006ea4 <holding+0x8>
    80006ea0:	4501                	li	a0,0
  return r;
}
    80006ea2:	8082                	ret
int holding(struct spinlock *lk) {
    80006ea4:	1101                	addi	sp,sp,-32
    80006ea6:	ec06                	sd	ra,24(sp)
    80006ea8:	e822                	sd	s0,16(sp)
    80006eaa:	e426                	sd	s1,8(sp)
    80006eac:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006eae:	6904                	ld	s1,16(a0)
    80006eb0:	ffffa097          	auipc	ra,0xffffa
    80006eb4:	020080e7          	jalr	32(ra) # 80000ed0 <mycpu>
    80006eb8:	40a48533          	sub	a0,s1,a0
    80006ebc:	00153513          	seqz	a0,a0
}
    80006ec0:	60e2                	ld	ra,24(sp)
    80006ec2:	6442                	ld	s0,16(sp)
    80006ec4:	64a2                	ld	s1,8(sp)
    80006ec6:	6105                	addi	sp,sp,32
    80006ec8:	8082                	ret

0000000080006eca <push_off>:

// push_off/pop_off are like intr_off()/intr_on() except that they are matched:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void push_off(void) {
    80006eca:	1101                	addi	sp,sp,-32
    80006ecc:	ec06                	sd	ra,24(sp)
    80006ece:	e822                	sd	s0,16(sp)
    80006ed0:	e426                	sd	s1,8(sp)
    80006ed2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80006ed4:	100024f3          	csrr	s1,sstatus
    80006ed8:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80006edc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80006ede:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if (mycpu()->noff == 0) mycpu()->intena = old;
    80006ee2:	ffffa097          	auipc	ra,0xffffa
    80006ee6:	fee080e7          	jalr	-18(ra) # 80000ed0 <mycpu>
    80006eea:	5d3c                	lw	a5,120(a0)
    80006eec:	cf89                	beqz	a5,80006f06 <push_off+0x3c>
  mycpu()->noff += 1;
    80006eee:	ffffa097          	auipc	ra,0xffffa
    80006ef2:	fe2080e7          	jalr	-30(ra) # 80000ed0 <mycpu>
    80006ef6:	5d3c                	lw	a5,120(a0)
    80006ef8:	2785                	addiw	a5,a5,1
    80006efa:	dd3c                	sw	a5,120(a0)
}
    80006efc:	60e2                	ld	ra,24(sp)
    80006efe:	6442                	ld	s0,16(sp)
    80006f00:	64a2                	ld	s1,8(sp)
    80006f02:	6105                	addi	sp,sp,32
    80006f04:	8082                	ret
  if (mycpu()->noff == 0) mycpu()->intena = old;
    80006f06:	ffffa097          	auipc	ra,0xffffa
    80006f0a:	fca080e7          	jalr	-54(ra) # 80000ed0 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006f0e:	8085                	srli	s1,s1,0x1
    80006f10:	8885                	andi	s1,s1,1
    80006f12:	dd64                	sw	s1,124(a0)
    80006f14:	bfe9                	j	80006eee <push_off+0x24>

0000000080006f16 <acquire>:
void acquire(struct spinlock *lk) {
    80006f16:	1101                	addi	sp,sp,-32
    80006f18:	ec06                	sd	ra,24(sp)
    80006f1a:	e822                	sd	s0,16(sp)
    80006f1c:	e426                	sd	s1,8(sp)
    80006f1e:	1000                	addi	s0,sp,32
    80006f20:	84aa                	mv	s1,a0
  push_off();  // disable interrupts to avoid deadlock.
    80006f22:	00000097          	auipc	ra,0x0
    80006f26:	fa8080e7          	jalr	-88(ra) # 80006eca <push_off>
  if (holding(lk)) panic("acquire");
    80006f2a:	8526                	mv	a0,s1
    80006f2c:	00000097          	auipc	ra,0x0
    80006f30:	f70080e7          	jalr	-144(ra) # 80006e9c <holding>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0);
    80006f34:	4705                	li	a4,1
  if (holding(lk)) panic("acquire");
    80006f36:	e115                	bnez	a0,80006f5a <acquire+0x44>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0);
    80006f38:	87ba                	mv	a5,a4
    80006f3a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006f3e:	2781                	sext.w	a5,a5
    80006f40:	ffe5                	bnez	a5,80006f38 <acquire+0x22>
  __sync_synchronize();
    80006f42:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006f46:	ffffa097          	auipc	ra,0xffffa
    80006f4a:	f8a080e7          	jalr	-118(ra) # 80000ed0 <mycpu>
    80006f4e:	e888                	sd	a0,16(s1)
}
    80006f50:	60e2                	ld	ra,24(sp)
    80006f52:	6442                	ld	s0,16(sp)
    80006f54:	64a2                	ld	s1,8(sp)
    80006f56:	6105                	addi	sp,sp,32
    80006f58:	8082                	ret
  if (holding(lk)) panic("acquire");
    80006f5a:	00003517          	auipc	a0,0x3
    80006f5e:	9ee50513          	addi	a0,a0,-1554 # 80009948 <digits+0x20>
    80006f62:	00000097          	auipc	ra,0x0
    80006f66:	a7c080e7          	jalr	-1412(ra) # 800069de <panic>

0000000080006f6a <pop_off>:

void pop_off(void) {
    80006f6a:	1141                	addi	sp,sp,-16
    80006f6c:	e406                	sd	ra,8(sp)
    80006f6e:	e022                	sd	s0,0(sp)
    80006f70:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006f72:	ffffa097          	auipc	ra,0xffffa
    80006f76:	f5e080e7          	jalr	-162(ra) # 80000ed0 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80006f7a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006f7e:	8b89                	andi	a5,a5,2
  if (intr_get()) panic("pop_off - interruptible");
    80006f80:	e78d                	bnez	a5,80006faa <pop_off+0x40>
  if (c->noff < 1) panic("pop_off");
    80006f82:	5d3c                	lw	a5,120(a0)
    80006f84:	02f05b63          	blez	a5,80006fba <pop_off+0x50>
  c->noff -= 1;
    80006f88:	37fd                	addiw	a5,a5,-1
    80006f8a:	0007871b          	sext.w	a4,a5
    80006f8e:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena) intr_on();
    80006f90:	eb09                	bnez	a4,80006fa2 <pop_off+0x38>
    80006f92:	5d7c                	lw	a5,124(a0)
    80006f94:	c799                	beqz	a5,80006fa2 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80006f96:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80006f9a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80006f9e:	10079073          	csrw	sstatus,a5
}
    80006fa2:	60a2                	ld	ra,8(sp)
    80006fa4:	6402                	ld	s0,0(sp)
    80006fa6:	0141                	addi	sp,sp,16
    80006fa8:	8082                	ret
  if (intr_get()) panic("pop_off - interruptible");
    80006faa:	00003517          	auipc	a0,0x3
    80006fae:	9a650513          	addi	a0,a0,-1626 # 80009950 <digits+0x28>
    80006fb2:	00000097          	auipc	ra,0x0
    80006fb6:	a2c080e7          	jalr	-1492(ra) # 800069de <panic>
  if (c->noff < 1) panic("pop_off");
    80006fba:	00003517          	auipc	a0,0x3
    80006fbe:	9ae50513          	addi	a0,a0,-1618 # 80009968 <digits+0x40>
    80006fc2:	00000097          	auipc	ra,0x0
    80006fc6:	a1c080e7          	jalr	-1508(ra) # 800069de <panic>

0000000080006fca <release>:
void release(struct spinlock *lk) {
    80006fca:	1101                	addi	sp,sp,-32
    80006fcc:	ec06                	sd	ra,24(sp)
    80006fce:	e822                	sd	s0,16(sp)
    80006fd0:	e426                	sd	s1,8(sp)
    80006fd2:	1000                	addi	s0,sp,32
    80006fd4:	84aa                	mv	s1,a0
  if (!holding(lk)) panic("release");
    80006fd6:	00000097          	auipc	ra,0x0
    80006fda:	ec6080e7          	jalr	-314(ra) # 80006e9c <holding>
    80006fde:	c115                	beqz	a0,80007002 <release+0x38>
  lk->cpu = 0;
    80006fe0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006fe4:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006fe8:	0f50000f          	fence	iorw,ow
    80006fec:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006ff0:	00000097          	auipc	ra,0x0
    80006ff4:	f7a080e7          	jalr	-134(ra) # 80006f6a <pop_off>
}
    80006ff8:	60e2                	ld	ra,24(sp)
    80006ffa:	6442                	ld	s0,16(sp)
    80006ffc:	64a2                	ld	s1,8(sp)
    80006ffe:	6105                	addi	sp,sp,32
    80007000:	8082                	ret
  if (!holding(lk)) panic("release");
    80007002:	00003517          	auipc	a0,0x3
    80007006:	96e50513          	addi	a0,a0,-1682 # 80009970 <digits+0x48>
    8000700a:	00000097          	auipc	ra,0x0
    8000700e:	9d4080e7          	jalr	-1580(ra) # 800069de <panic>
	...

0000000080008000 <_trampoline>:
    80008000:	14051073          	csrw	sscratch,a0
    80008004:	02000537          	lui	a0,0x2000
    80008008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000800a:	0536                	slli	a0,a0,0xd
    8000800c:	02153423          	sd	ra,40(a0)
    80008010:	02253823          	sd	sp,48(a0)
    80008014:	02353c23          	sd	gp,56(a0)
    80008018:	04453023          	sd	tp,64(a0)
    8000801c:	04553423          	sd	t0,72(a0)
    80008020:	04653823          	sd	t1,80(a0)
    80008024:	04753c23          	sd	t2,88(a0)
    80008028:	f120                	sd	s0,96(a0)
    8000802a:	f524                	sd	s1,104(a0)
    8000802c:	fd2c                	sd	a1,120(a0)
    8000802e:	e150                	sd	a2,128(a0)
    80008030:	e554                	sd	a3,136(a0)
    80008032:	e958                	sd	a4,144(a0)
    80008034:	ed5c                	sd	a5,152(a0)
    80008036:	0b053023          	sd	a6,160(a0)
    8000803a:	0b153423          	sd	a7,168(a0)
    8000803e:	0b253823          	sd	s2,176(a0)
    80008042:	0b353c23          	sd	s3,184(a0)
    80008046:	0d453023          	sd	s4,192(a0)
    8000804a:	0d553423          	sd	s5,200(a0)
    8000804e:	0d653823          	sd	s6,208(a0)
    80008052:	0d753c23          	sd	s7,216(a0)
    80008056:	0f853023          	sd	s8,224(a0)
    8000805a:	0f953423          	sd	s9,232(a0)
    8000805e:	0fa53823          	sd	s10,240(a0)
    80008062:	0fb53c23          	sd	s11,248(a0)
    80008066:	11c53023          	sd	t3,256(a0)
    8000806a:	11d53423          	sd	t4,264(a0)
    8000806e:	11e53823          	sd	t5,272(a0)
    80008072:	11f53c23          	sd	t6,280(a0)
    80008076:	140022f3          	csrr	t0,sscratch
    8000807a:	06553823          	sd	t0,112(a0)
    8000807e:	00853103          	ld	sp,8(a0)
    80008082:	02053203          	ld	tp,32(a0)
    80008086:	01053283          	ld	t0,16(a0)
    8000808a:	00053303          	ld	t1,0(a0)
    8000808e:	12000073          	sfence.vma
    80008092:	18031073          	csrw	satp,t1
    80008096:	12000073          	sfence.vma
    8000809a:	8282                	jr	t0

000000008000809c <userret>:
    8000809c:	12000073          	sfence.vma
    800080a0:	18051073          	csrw	satp,a0
    800080a4:	12000073          	sfence.vma
    800080a8:	02000537          	lui	a0,0x2000
    800080ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800080ae:	0536                	slli	a0,a0,0xd
    800080b0:	02853083          	ld	ra,40(a0)
    800080b4:	03053103          	ld	sp,48(a0)
    800080b8:	03853183          	ld	gp,56(a0)
    800080bc:	04053203          	ld	tp,64(a0)
    800080c0:	04853283          	ld	t0,72(a0)
    800080c4:	05053303          	ld	t1,80(a0)
    800080c8:	05853383          	ld	t2,88(a0)
    800080cc:	7120                	ld	s0,96(a0)
    800080ce:	7524                	ld	s1,104(a0)
    800080d0:	7d2c                	ld	a1,120(a0)
    800080d2:	6150                	ld	a2,128(a0)
    800080d4:	6554                	ld	a3,136(a0)
    800080d6:	6958                	ld	a4,144(a0)
    800080d8:	6d5c                	ld	a5,152(a0)
    800080da:	0a053803          	ld	a6,160(a0)
    800080de:	0a853883          	ld	a7,168(a0)
    800080e2:	0b053903          	ld	s2,176(a0)
    800080e6:	0b853983          	ld	s3,184(a0)
    800080ea:	0c053a03          	ld	s4,192(a0)
    800080ee:	0c853a83          	ld	s5,200(a0)
    800080f2:	0d053b03          	ld	s6,208(a0)
    800080f6:	0d853b83          	ld	s7,216(a0)
    800080fa:	0e053c03          	ld	s8,224(a0)
    800080fe:	0e853c83          	ld	s9,232(a0)
    80008102:	0f053d03          	ld	s10,240(a0)
    80008106:	0f853d83          	ld	s11,248(a0)
    8000810a:	10053e03          	ld	t3,256(a0)
    8000810e:	10853e83          	ld	t4,264(a0)
    80008112:	11053f03          	ld	t5,272(a0)
    80008116:	11853f83          	ld	t6,280(a0)
    8000811a:	7928                	ld	a0,112(a0)
    8000811c:	10200073          	sret
	...
