
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	2e013103          	ld	sp,736(sp) # 8000b2e0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	2d9050ef          	jal	80005aee <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00025797          	auipc	a5,0x25
    80000034:	97078793          	addi	a5,a5,-1680 # 800249a0 <end>
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

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	0000b917          	auipc	s2,0xb
    80000054:	2e090913          	addi	s2,s2,736 # 8000b330 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	4e2080e7          	jalr	1250(ra) # 8000653c <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	582080e7          	jalr	1410(ra) # 800065f0 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f7e50513          	addi	a0,a0,-130 # 80008000 <etext>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	f38080e7          	jalr	-200(ra) # 80005fc2 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000009c:	6785                	lui	a5,0x1
    8000009e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a2:	00e504b3          	add	s1,a0,a4
    800000a6:	777d                	lui	a4,0xfffff
    800000a8:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	94be                	add	s1,s1,a5
    800000ac:	0295e463          	bltu	a1,s1,800000d4 <freerange+0x42>
    800000b0:	e84a                	sd	s2,16(sp)
    800000b2:	e44e                	sd	s3,8(sp)
    800000b4:	e052                	sd	s4,0(sp)
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
    800000ce:	6942                	ld	s2,16(sp)
    800000d0:	69a2                	ld	s3,8(sp)
    800000d2:	6a02                	ld	s4,0(sp)
}
    800000d4:	70a2                	ld	ra,40(sp)
    800000d6:	7402                	ld	s0,32(sp)
    800000d8:	64e2                	ld	s1,24(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f2a58593          	addi	a1,a1,-214 # 80008010 <etext+0x10>
    800000ee:	0000b517          	auipc	a0,0xb
    800000f2:	24250513          	addi	a0,a0,578 # 8000b330 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	3b6080e7          	jalr	950(ra) # 800064ac <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00025517          	auipc	a0,0x25
    80000106:	89e50513          	addi	a0,a0,-1890 # 800249a0 <end>
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
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	0000b497          	auipc	s1,0xb
    80000128:	20c48493          	addi	s1,s1,524 # 8000b330 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	40e080e7          	jalr	1038(ra) # 8000653c <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	0000b517          	auipc	a0,0xb
    80000140:	1f450513          	addi	a0,a0,500 # 8000b330 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	4aa080e7          	jalr	1194(ra) # 800065f0 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	0000b517          	auipc	a0,0xb
    8000016c:	1c850513          	addi	a0,a0,456 # 8000b330 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	480080e7          	jalr	1152(ra) # 800065f0 <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffda661>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	feb79ae3          	bne	a5,a1,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fef71ae3          	bne	a4,a5,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
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

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a801                	j	8000027a <strncmp+0x30>
    8000026c:	4501                	li	a0,0
    8000026e:	a031                	j	8000027a <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000270:	00054503          	lbu	a0,0(a0)
    80000274:	0005c783          	lbu	a5,0(a1)
    80000278:	9d1d                	subw	a0,a0,a5
}
    8000027a:	6422                	ld	s0,8(sp)
    8000027c:	0141                	addi	sp,sp,16
    8000027e:	8082                	ret

0000000080000280 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000280:	1141                	addi	sp,sp,-16
    80000282:	e422                	sd	s0,8(sp)
    80000284:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000286:	87aa                	mv	a5,a0
    80000288:	86b2                	mv	a3,a2
    8000028a:	367d                	addiw	a2,a2,-1
    8000028c:	02d05563          	blez	a3,800002b6 <strncpy+0x36>
    80000290:	0785                	addi	a5,a5,1
    80000292:	0005c703          	lbu	a4,0(a1)
    80000296:	fee78fa3          	sb	a4,-1(a5)
    8000029a:	0585                	addi	a1,a1,1
    8000029c:	f775                	bnez	a4,80000288 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000029e:	873e                	mv	a4,a5
    800002a0:	9fb5                	addw	a5,a5,a3
    800002a2:	37fd                	addiw	a5,a5,-1
    800002a4:	00c05963          	blez	a2,800002b6 <strncpy+0x36>
    *s++ = 0;
    800002a8:	0705                	addi	a4,a4,1
    800002aa:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002ae:	40e786bb          	subw	a3,a5,a4
    800002b2:	fed04be3          	bgtz	a3,800002a8 <strncpy+0x28>
  return os;
}
    800002b6:	6422                	ld	s0,8(sp)
    800002b8:	0141                	addi	sp,sp,16
    800002ba:	8082                	ret

00000000800002bc <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002bc:	1141                	addi	sp,sp,-16
    800002be:	e422                	sd	s0,8(sp)
    800002c0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c2:	02c05363          	blez	a2,800002e8 <safestrcpy+0x2c>
    800002c6:	fff6069b          	addiw	a3,a2,-1
    800002ca:	1682                	slli	a3,a3,0x20
    800002cc:	9281                	srli	a3,a3,0x20
    800002ce:	96ae                	add	a3,a3,a1
    800002d0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d2:	00d58963          	beq	a1,a3,800002e4 <safestrcpy+0x28>
    800002d6:	0585                	addi	a1,a1,1
    800002d8:	0785                	addi	a5,a5,1
    800002da:	fff5c703          	lbu	a4,-1(a1)
    800002de:	fee78fa3          	sb	a4,-1(a5)
    800002e2:	fb65                	bnez	a4,800002d2 <safestrcpy+0x16>
    ;
  *s = 0;
    800002e4:	00078023          	sb	zero,0(a5)
  return os;
}
    800002e8:	6422                	ld	s0,8(sp)
    800002ea:	0141                	addi	sp,sp,16
    800002ec:	8082                	ret

00000000800002ee <strlen>:

int
strlen(const char *s)
{
    800002ee:	1141                	addi	sp,sp,-16
    800002f0:	e422                	sd	s0,8(sp)
    800002f2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002f4:	00054783          	lbu	a5,0(a0)
    800002f8:	cf91                	beqz	a5,80000314 <strlen+0x26>
    800002fa:	0505                	addi	a0,a0,1
    800002fc:	87aa                	mv	a5,a0
    800002fe:	86be                	mv	a3,a5
    80000300:	0785                	addi	a5,a5,1
    80000302:	fff7c703          	lbu	a4,-1(a5)
    80000306:	ff65                	bnez	a4,800002fe <strlen+0x10>
    80000308:	40a6853b          	subw	a0,a3,a0
    8000030c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    8000030e:	6422                	ld	s0,8(sp)
    80000310:	0141                	addi	sp,sp,16
    80000312:	8082                	ret
  for(n = 0; s[n]; n++)
    80000314:	4501                	li	a0,0
    80000316:	bfe5                	j	8000030e <strlen+0x20>

0000000080000318 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000318:	1141                	addi	sp,sp,-16
    8000031a:	e406                	sd	ra,8(sp)
    8000031c:	e022                	sd	s0,0(sp)
    8000031e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000320:	00001097          	auipc	ra,0x1
    80000324:	c9e080e7          	jalr	-866(ra) # 80000fbe <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000328:	0000b717          	auipc	a4,0xb
    8000032c:	fd870713          	addi	a4,a4,-40 # 8000b300 <started>
  if(cpuid() == 0){
    80000330:	c139                	beqz	a0,80000376 <main+0x5e>
    while(started == 0)
    80000332:	431c                	lw	a5,0(a4)
    80000334:	2781                	sext.w	a5,a5
    80000336:	dff5                	beqz	a5,80000332 <main+0x1a>
      ;
    __sync_synchronize();
    80000338:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    8000033c:	00001097          	auipc	ra,0x1
    80000340:	c82080e7          	jalr	-894(ra) # 80000fbe <cpuid>
    80000344:	85aa                	mv	a1,a0
    80000346:	00008517          	auipc	a0,0x8
    8000034a:	cf250513          	addi	a0,a0,-782 # 80008038 <etext+0x38>
    8000034e:	00006097          	auipc	ra,0x6
    80000352:	cbe080e7          	jalr	-834(ra) # 8000600c <printf>
    kvminithart();    // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0d8080e7          	jalr	216(ra) # 8000042e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000035e:	00002097          	auipc	ra,0x2
    80000362:	9b6080e7          	jalr	-1610(ra) # 80001d14 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	0fe080e7          	jalr	254(ra) # 80005464 <plicinithart>
  }

  scheduler();        
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	1fe080e7          	jalr	510(ra) # 8000156c <scheduler>
    consoleinit();
    80000376:	00006097          	auipc	ra,0x6
    8000037a:	b5c080e7          	jalr	-1188(ra) # 80005ed2 <consoleinit>
    printfinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	e96080e7          	jalr	-362(ra) # 80006214 <printfinit>
    printf("\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	addi	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	c7e080e7          	jalr	-898(ra) # 8000600c <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	c8a50513          	addi	a0,a0,-886 # 80008020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	c6e080e7          	jalr	-914(ra) # 8000600c <printf>
    printf("\n");
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c7250513          	addi	a0,a0,-910 # 80008018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	c5e080e7          	jalr	-930(ra) # 8000600c <printf>
    kinit();         // physical page allocator
    800003b6:	00000097          	auipc	ra,0x0
    800003ba:	d28080e7          	jalr	-728(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	34a080e7          	jalr	842(ra) # 80000708 <kvminit>
    kvminithart();   // turn on paging
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	068080e7          	jalr	104(ra) # 8000042e <kvminithart>
    procinit();      // process table
    800003ce:	00001097          	auipc	ra,0x1
    800003d2:	b30080e7          	jalr	-1232(ra) # 80000efe <procinit>
    trapinit();      // trap vectors
    800003d6:	00002097          	auipc	ra,0x2
    800003da:	916080e7          	jalr	-1770(ra) # 80001cec <trapinit>
    trapinithart();  // install kernel trap vector
    800003de:	00002097          	auipc	ra,0x2
    800003e2:	936080e7          	jalr	-1738(ra) # 80001d14 <trapinithart>
    plicinit();      // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	064080e7          	jalr	100(ra) # 8000544a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	076080e7          	jalr	118(ra) # 80005464 <plicinithart>
    binit();         // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	126080e7          	jalr	294(ra) # 8000251c <binit>
    iinit();         // inode table
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	7dc080e7          	jalr	2012(ra) # 80002bda <iinit>
    fileinit();      // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	78c080e7          	jalr	1932(ra) # 80003b92 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	15e080e7          	jalr	350(ra) # 8000556c <virtio_disk_init>
    userinit();      // first user process
    80000416:	00001097          	auipc	ra,0x1
    8000041a:	f36080e7          	jalr	-202(ra) # 8000134c <userinit>
    __sync_synchronize();
    8000041e:	0330000f          	fence	rw,rw
    started = 1;
    80000422:	4785                	li	a5,1
    80000424:	0000b717          	auipc	a4,0xb
    80000428:	ecf72e23          	sw	a5,-292(a4) # 8000b300 <started>
    8000042c:	b789                	j	8000036e <main+0x56>

000000008000042e <kvminithart>:
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart()
{
    8000042e:	1141                	addi	sp,sp,-16
    80000430:	e422                	sd	s0,8(sp)
    80000432:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000434:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000438:	0000b797          	auipc	a5,0xb
    8000043c:	ed07b783          	ld	a5,-304(a5) # 8000b308 <kernel_pagetable>
    80000440:	83b1                	srli	a5,a5,0xc
    80000442:	577d                	li	a4,-1
    80000444:	177e                	slli	a4,a4,0x3f
    80000446:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000448:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000044c:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000450:	6422                	ld	s0,8(sp)
    80000452:	0141                	addi	sp,sp,16
    80000454:	8082                	ret

0000000080000456 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000456:	7139                	addi	sp,sp,-64
    80000458:	fc06                	sd	ra,56(sp)
    8000045a:	f822                	sd	s0,48(sp)
    8000045c:	f426                	sd	s1,40(sp)
    8000045e:	f04a                	sd	s2,32(sp)
    80000460:	ec4e                	sd	s3,24(sp)
    80000462:	e852                	sd	s4,16(sp)
    80000464:	e456                	sd	s5,8(sp)
    80000466:	e05a                	sd	s6,0(sp)
    80000468:	0080                	addi	s0,sp,64
    8000046a:	84aa                	mv	s1,a0
    8000046c:	89ae                	mv	s3,a1
    8000046e:	8ab2                	mv	s5,a2
  if (va >= MAXVA)
    80000470:	57fd                	li	a5,-1
    80000472:	83e9                	srli	a5,a5,0x1a
    80000474:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--)
    80000476:	4b31                	li	s6,12
  if (va >= MAXVA)
    80000478:	04b7f263          	bgeu	a5,a1,800004bc <walk+0x66>
    panic("walk");
    8000047c:	00008517          	auipc	a0,0x8
    80000480:	bd450513          	addi	a0,a0,-1068 # 80008050 <etext+0x50>
    80000484:	00006097          	auipc	ra,0x6
    80000488:	b3e080e7          	jalr	-1218(ra) # 80005fc2 <panic>
    {
      pagetable = (pagetable_t)PTE2PA(*pte);
    }
    else
    {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    8000048c:	060a8663          	beqz	s5,800004f8 <walk+0xa2>
    80000490:	00000097          	auipc	ra,0x0
    80000494:	c8a080e7          	jalr	-886(ra) # 8000011a <kalloc>
    80000498:	84aa                	mv	s1,a0
    8000049a:	c529                	beqz	a0,800004e4 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000049c:	6605                	lui	a2,0x1
    8000049e:	4581                	li	a1,0
    800004a0:	00000097          	auipc	ra,0x0
    800004a4:	cda080e7          	jalr	-806(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004a8:	00c4d793          	srli	a5,s1,0xc
    800004ac:	07aa                	slli	a5,a5,0xa
    800004ae:	0017e793          	ori	a5,a5,1
    800004b2:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--)
    800004b6:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffda657>
    800004b8:	036a0063          	beq	s4,s6,800004d8 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004bc:	0149d933          	srl	s2,s3,s4
    800004c0:	1ff97913          	andi	s2,s2,511
    800004c4:	090e                	slli	s2,s2,0x3
    800004c6:	9926                	add	s2,s2,s1
    if (*pte & PTE_V)
    800004c8:	00093483          	ld	s1,0(s2)
    800004cc:	0014f793          	andi	a5,s1,1
    800004d0:	dfd5                	beqz	a5,8000048c <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d2:	80a9                	srli	s1,s1,0xa
    800004d4:	04b2                	slli	s1,s1,0xc
    800004d6:	b7c5                	j	800004b6 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004d8:	00c9d513          	srli	a0,s3,0xc
    800004dc:	1ff57513          	andi	a0,a0,511
    800004e0:	050e                	slli	a0,a0,0x3
    800004e2:	9526                	add	a0,a0,s1
}
    800004e4:	70e2                	ld	ra,56(sp)
    800004e6:	7442                	ld	s0,48(sp)
    800004e8:	74a2                	ld	s1,40(sp)
    800004ea:	7902                	ld	s2,32(sp)
    800004ec:	69e2                	ld	s3,24(sp)
    800004ee:	6a42                	ld	s4,16(sp)
    800004f0:	6aa2                	ld	s5,8(sp)
    800004f2:	6b02                	ld	s6,0(sp)
    800004f4:	6121                	addi	sp,sp,64
    800004f6:	8082                	ret
        return 0;
    800004f8:	4501                	li	a0,0
    800004fa:	b7ed                	j	800004e4 <walk+0x8e>

00000000800004fc <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    800004fc:	57fd                	li	a5,-1
    800004fe:	83e9                	srli	a5,a5,0x1a
    80000500:	00b7f463          	bgeu	a5,a1,80000508 <walkaddr+0xc>
    return 0;
    80000504:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000506:	8082                	ret
{
    80000508:	1141                	addi	sp,sp,-16
    8000050a:	e406                	sd	ra,8(sp)
    8000050c:	e022                	sd	s0,0(sp)
    8000050e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000510:	4601                	li	a2,0
    80000512:	00000097          	auipc	ra,0x0
    80000516:	f44080e7          	jalr	-188(ra) # 80000456 <walk>
  if (pte == 0)
    8000051a:	c105                	beqz	a0,8000053a <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0)
    8000051c:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    8000051e:	0117f693          	andi	a3,a5,17
    80000522:	4745                	li	a4,17
    return 0;
    80000524:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    80000526:	00e68663          	beq	a3,a4,80000532 <walkaddr+0x36>
}
    8000052a:	60a2                	ld	ra,8(sp)
    8000052c:	6402                	ld	s0,0(sp)
    8000052e:	0141                	addi	sp,sp,16
    80000530:	8082                	ret
  pa = PTE2PA(*pte);
    80000532:	83a9                	srli	a5,a5,0xa
    80000534:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000538:	bfcd                	j	8000052a <walkaddr+0x2e>
    return 0;
    8000053a:	4501                	li	a0,0
    8000053c:	b7fd                	j	8000052a <walkaddr+0x2e>

000000008000053e <mappages>:
// physical addresses starting at pa.
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000053e:	715d                	addi	sp,sp,-80
    80000540:	e486                	sd	ra,72(sp)
    80000542:	e0a2                	sd	s0,64(sp)
    80000544:	fc26                	sd	s1,56(sp)
    80000546:	f84a                	sd	s2,48(sp)
    80000548:	f44e                	sd	s3,40(sp)
    8000054a:	f052                	sd	s4,32(sp)
    8000054c:	ec56                	sd	s5,24(sp)
    8000054e:	e85a                	sd	s6,16(sp)
    80000550:	e45e                	sd	s7,8(sp)
    80000552:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    80000554:	03459793          	slli	a5,a1,0x34
    80000558:	e7b9                	bnez	a5,800005a6 <mappages+0x68>
    8000055a:	8aaa                	mv	s5,a0
    8000055c:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if ((size % PGSIZE) != 0)
    8000055e:	03461793          	slli	a5,a2,0x34
    80000562:	ebb1                	bnez	a5,800005b6 <mappages+0x78>
    panic("mappages: size not aligned");

  if (size == 0)
    80000564:	c22d                	beqz	a2,800005c6 <mappages+0x88>
    panic("mappages: size");

  a = va;
  last = va + size - PGSIZE;
    80000566:	77fd                	lui	a5,0xfffff
    80000568:	963e                	add	a2,a2,a5
    8000056a:	00b609b3          	add	s3,a2,a1
  a = va;
    8000056e:	892e                	mv	s2,a1
    80000570:	40b68a33          	sub	s4,a3,a1
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    80000574:	6b85                	lui	s7,0x1
    80000576:	014904b3          	add	s1,s2,s4
    if ((pte = walk(pagetable, a, 1)) == 0)
    8000057a:	4605                	li	a2,1
    8000057c:	85ca                	mv	a1,s2
    8000057e:	8556                	mv	a0,s5
    80000580:	00000097          	auipc	ra,0x0
    80000584:	ed6080e7          	jalr	-298(ra) # 80000456 <walk>
    80000588:	cd39                	beqz	a0,800005e6 <mappages+0xa8>
    if (*pte & PTE_V)
    8000058a:	611c                	ld	a5,0(a0)
    8000058c:	8b85                	andi	a5,a5,1
    8000058e:	e7a1                	bnez	a5,800005d6 <mappages+0x98>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000590:	80b1                	srli	s1,s1,0xc
    80000592:	04aa                	slli	s1,s1,0xa
    80000594:	0164e4b3          	or	s1,s1,s6
    80000598:	0014e493          	ori	s1,s1,1
    8000059c:	e104                	sd	s1,0(a0)
    if (a == last)
    8000059e:	07390063          	beq	s2,s3,800005fe <mappages+0xc0>
    a += PGSIZE;
    800005a2:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	bfc9                	j	80000576 <mappages+0x38>
    panic("mappages: va not aligned");
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	ab250513          	addi	a0,a0,-1358 # 80008058 <etext+0x58>
    800005ae:	00006097          	auipc	ra,0x6
    800005b2:	a14080e7          	jalr	-1516(ra) # 80005fc2 <panic>
    panic("mappages: size not aligned");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ac250513          	addi	a0,a0,-1342 # 80008078 <etext+0x78>
    800005be:	00006097          	auipc	ra,0x6
    800005c2:	a04080e7          	jalr	-1532(ra) # 80005fc2 <panic>
    panic("mappages: size");
    800005c6:	00008517          	auipc	a0,0x8
    800005ca:	ad250513          	addi	a0,a0,-1326 # 80008098 <etext+0x98>
    800005ce:	00006097          	auipc	ra,0x6
    800005d2:	9f4080e7          	jalr	-1548(ra) # 80005fc2 <panic>
      panic("mappages: remap");
    800005d6:	00008517          	auipc	a0,0x8
    800005da:	ad250513          	addi	a0,a0,-1326 # 800080a8 <etext+0xa8>
    800005de:	00006097          	auipc	ra,0x6
    800005e2:	9e4080e7          	jalr	-1564(ra) # 80005fc2 <panic>
      return -1;
    800005e6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005e8:	60a6                	ld	ra,72(sp)
    800005ea:	6406                	ld	s0,64(sp)
    800005ec:	74e2                	ld	s1,56(sp)
    800005ee:	7942                	ld	s2,48(sp)
    800005f0:	79a2                	ld	s3,40(sp)
    800005f2:	7a02                	ld	s4,32(sp)
    800005f4:	6ae2                	ld	s5,24(sp)
    800005f6:	6b42                	ld	s6,16(sp)
    800005f8:	6ba2                	ld	s7,8(sp)
    800005fa:	6161                	addi	sp,sp,80
    800005fc:	8082                	ret
  return 0;
    800005fe:	4501                	li	a0,0
    80000600:	b7e5                	j	800005e8 <mappages+0xaa>

0000000080000602 <kvmmap>:
{
    80000602:	1141                	addi	sp,sp,-16
    80000604:	e406                	sd	ra,8(sp)
    80000606:	e022                	sd	s0,0(sp)
    80000608:	0800                	addi	s0,sp,16
    8000060a:	87b6                	mv	a5,a3
  if (mappages(kpagetable, va, sz, pa, perm) != 0)
    8000060c:	86b2                	mv	a3,a2
    8000060e:	863e                	mv	a2,a5
    80000610:	00000097          	auipc	ra,0x0
    80000614:	f2e080e7          	jalr	-210(ra) # 8000053e <mappages>
    80000618:	e509                	bnez	a0,80000622 <kvmmap+0x20>
}
    8000061a:	60a2                	ld	ra,8(sp)
    8000061c:	6402                	ld	s0,0(sp)
    8000061e:	0141                	addi	sp,sp,16
    80000620:	8082                	ret
    panic("kvmmap");
    80000622:	00008517          	auipc	a0,0x8
    80000626:	a9650513          	addi	a0,a0,-1386 # 800080b8 <etext+0xb8>
    8000062a:	00006097          	auipc	ra,0x6
    8000062e:	998080e7          	jalr	-1640(ra) # 80005fc2 <panic>

0000000080000632 <kvmmake>:
{
    80000632:	1101                	addi	sp,sp,-32
    80000634:	ec06                	sd	ra,24(sp)
    80000636:	e822                	sd	s0,16(sp)
    80000638:	e426                	sd	s1,8(sp)
    8000063a:	e04a                	sd	s2,0(sp)
    8000063c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    8000063e:	00000097          	auipc	ra,0x0
    80000642:	adc080e7          	jalr	-1316(ra) # 8000011a <kalloc>
    80000646:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000648:	6605                	lui	a2,0x1
    8000064a:	4581                	li	a1,0
    8000064c:	00000097          	auipc	ra,0x0
    80000650:	b2e080e7          	jalr	-1234(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000654:	4719                	li	a4,6
    80000656:	6685                	lui	a3,0x1
    80000658:	10000637          	lui	a2,0x10000
    8000065c:	100005b7          	lui	a1,0x10000
    80000660:	8526                	mv	a0,s1
    80000662:	00000097          	auipc	ra,0x0
    80000666:	fa0080e7          	jalr	-96(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000066a:	4719                	li	a4,6
    8000066c:	6685                	lui	a3,0x1
    8000066e:	10001637          	lui	a2,0x10001
    80000672:	100015b7          	lui	a1,0x10001
    80000676:	8526                	mv	a0,s1
    80000678:	00000097          	auipc	ra,0x0
    8000067c:	f8a080e7          	jalr	-118(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000680:	4719                	li	a4,6
    80000682:	004006b7          	lui	a3,0x400
    80000686:	0c000637          	lui	a2,0xc000
    8000068a:	0c0005b7          	lui	a1,0xc000
    8000068e:	8526                	mv	a0,s1
    80000690:	00000097          	auipc	ra,0x0
    80000694:	f72080e7          	jalr	-142(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    80000698:	00008917          	auipc	s2,0x8
    8000069c:	96890913          	addi	s2,s2,-1688 # 80008000 <etext>
    800006a0:	4729                	li	a4,10
    800006a2:	80008697          	auipc	a3,0x80008
    800006a6:	95e68693          	addi	a3,a3,-1698 # 8000 <_entry-0x7fff8000>
    800006aa:	4605                	li	a2,1
    800006ac:	067e                	slli	a2,a2,0x1f
    800006ae:	85b2                	mv	a1,a2
    800006b0:	8526                	mv	a0,s1
    800006b2:	00000097          	auipc	ra,0x0
    800006b6:	f50080e7          	jalr	-176(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);
    800006ba:	46c5                	li	a3,17
    800006bc:	06ee                	slli	a3,a3,0x1b
    800006be:	4719                	li	a4,6
    800006c0:	412686b3          	sub	a3,a3,s2
    800006c4:	864a                	mv	a2,s2
    800006c6:	85ca                	mv	a1,s2
    800006c8:	8526                	mv	a0,s1
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	f38080e7          	jalr	-200(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006d2:	4729                	li	a4,10
    800006d4:	6685                	lui	a3,0x1
    800006d6:	00007617          	auipc	a2,0x7
    800006da:	92a60613          	addi	a2,a2,-1750 # 80007000 <_trampoline>
    800006de:	040005b7          	lui	a1,0x4000
    800006e2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006e4:	05b2                	slli	a1,a1,0xc
    800006e6:	8526                	mv	a0,s1
    800006e8:	00000097          	auipc	ra,0x0
    800006ec:	f1a080e7          	jalr	-230(ra) # 80000602 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006f0:	8526                	mv	a0,s1
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	76a080e7          	jalr	1898(ra) # 80000e5c <proc_mapstacks>
}
    800006fa:	8526                	mv	a0,s1
    800006fc:	60e2                	ld	ra,24(sp)
    800006fe:	6442                	ld	s0,16(sp)
    80000700:	64a2                	ld	s1,8(sp)
    80000702:	6902                	ld	s2,0(sp)
    80000704:	6105                	addi	sp,sp,32
    80000706:	8082                	ret

0000000080000708 <kvminit>:
{
    80000708:	1141                	addi	sp,sp,-16
    8000070a:	e406                	sd	ra,8(sp)
    8000070c:	e022                	sd	s0,0(sp)
    8000070e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000710:	00000097          	auipc	ra,0x0
    80000714:	f22080e7          	jalr	-222(ra) # 80000632 <kvmmake>
    80000718:	0000b797          	auipc	a5,0xb
    8000071c:	bea7b823          	sd	a0,-1040(a5) # 8000b308 <kernel_pagetable>
}
    80000720:	60a2                	ld	ra,8(sp)
    80000722:	6402                	ld	s0,0(sp)
    80000724:	0141                	addi	sp,sp,16
    80000726:	8082                	ret

0000000080000728 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000728:	715d                	addi	sp,sp,-80
    8000072a:	e486                	sd	ra,72(sp)
    8000072c:	e0a2                	sd	s0,64(sp)
    8000072e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    80000730:	03459793          	slli	a5,a1,0x34
    80000734:	e39d                	bnez	a5,8000075a <uvmunmap+0x32>
    80000736:	f84a                	sd	s2,48(sp)
    80000738:	f44e                	sd	s3,40(sp)
    8000073a:	f052                	sd	s4,32(sp)
    8000073c:	ec56                	sd	s5,24(sp)
    8000073e:	e85a                	sd	s6,16(sp)
    80000740:	e45e                	sd	s7,8(sp)
    80000742:	8a2a                	mv	s4,a0
    80000744:	892e                	mv	s2,a1
    80000746:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80000748:	0632                	slli	a2,a2,0xc
    8000074a:	00b609b3          	add	s3,a2,a1
  {
    if ((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V)
    8000074e:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80000750:	6b05                	lui	s6,0x1
    80000752:	0935fb63          	bgeu	a1,s3,800007e8 <uvmunmap+0xc0>
    80000756:	fc26                	sd	s1,56(sp)
    80000758:	a8a9                	j	800007b2 <uvmunmap+0x8a>
    8000075a:	fc26                	sd	s1,56(sp)
    8000075c:	f84a                	sd	s2,48(sp)
    8000075e:	f44e                	sd	s3,40(sp)
    80000760:	f052                	sd	s4,32(sp)
    80000762:	ec56                	sd	s5,24(sp)
    80000764:	e85a                	sd	s6,16(sp)
    80000766:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000768:	00008517          	auipc	a0,0x8
    8000076c:	95850513          	addi	a0,a0,-1704 # 800080c0 <etext+0xc0>
    80000770:	00006097          	auipc	ra,0x6
    80000774:	852080e7          	jalr	-1966(ra) # 80005fc2 <panic>
      panic("uvmunmap: walk");
    80000778:	00008517          	auipc	a0,0x8
    8000077c:	96050513          	addi	a0,a0,-1696 # 800080d8 <etext+0xd8>
    80000780:	00006097          	auipc	ra,0x6
    80000784:	842080e7          	jalr	-1982(ra) # 80005fc2 <panic>
      panic("uvmunmap: not mapped");
    80000788:	00008517          	auipc	a0,0x8
    8000078c:	96050513          	addi	a0,a0,-1696 # 800080e8 <etext+0xe8>
    80000790:	00006097          	auipc	ra,0x6
    80000794:	832080e7          	jalr	-1998(ra) # 80005fc2 <panic>
      panic("uvmunmap: not a leaf");
    80000798:	00008517          	auipc	a0,0x8
    8000079c:	96850513          	addi	a0,a0,-1688 # 80008100 <etext+0x100>
    800007a0:	00006097          	auipc	ra,0x6
    800007a4:	822080e7          	jalr	-2014(ra) # 80005fc2 <panic>
    if (do_free)
    {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
    800007a8:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    800007ac:	995a                	add	s2,s2,s6
    800007ae:	03397c63          	bgeu	s2,s3,800007e6 <uvmunmap+0xbe>
    if ((pte = walk(pagetable, a, 0)) == 0)
    800007b2:	4601                	li	a2,0
    800007b4:	85ca                	mv	a1,s2
    800007b6:	8552                	mv	a0,s4
    800007b8:	00000097          	auipc	ra,0x0
    800007bc:	c9e080e7          	jalr	-866(ra) # 80000456 <walk>
    800007c0:	84aa                	mv	s1,a0
    800007c2:	d95d                	beqz	a0,80000778 <uvmunmap+0x50>
    if ((*pte & PTE_V) == 0)
    800007c4:	6108                	ld	a0,0(a0)
    800007c6:	00157793          	andi	a5,a0,1
    800007ca:	dfdd                	beqz	a5,80000788 <uvmunmap+0x60>
    if (PTE_FLAGS(*pte) == PTE_V)
    800007cc:	3ff57793          	andi	a5,a0,1023
    800007d0:	fd7784e3          	beq	a5,s7,80000798 <uvmunmap+0x70>
    if (do_free)
    800007d4:	fc0a8ae3          	beqz	s5,800007a8 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800007d8:	8129                	srli	a0,a0,0xa
      kfree((void *)pa);
    800007da:	0532                	slli	a0,a0,0xc
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	840080e7          	jalr	-1984(ra) # 8000001c <kfree>
    800007e4:	b7d1                	j	800007a8 <uvmunmap+0x80>
    800007e6:	74e2                	ld	s1,56(sp)
    800007e8:	7942                	ld	s2,48(sp)
    800007ea:	79a2                	ld	s3,40(sp)
    800007ec:	7a02                	ld	s4,32(sp)
    800007ee:	6ae2                	ld	s5,24(sp)
    800007f0:	6b42                	ld	s6,16(sp)
    800007f2:	6ba2                	ld	s7,8(sp)
  }
}
    800007f4:	60a6                	ld	ra,72(sp)
    800007f6:	6406                	ld	s0,64(sp)
    800007f8:	6161                	addi	sp,sp,80
    800007fa:	8082                	ret

00000000800007fc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007fc:	1101                	addi	sp,sp,-32
    800007fe:	ec06                	sd	ra,24(sp)
    80000800:	e822                	sd	s0,16(sp)
    80000802:	e426                	sd	s1,8(sp)
    80000804:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    80000806:	00000097          	auipc	ra,0x0
    8000080a:	914080e7          	jalr	-1772(ra) # 8000011a <kalloc>
    8000080e:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80000810:	c519                	beqz	a0,8000081e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000812:	6605                	lui	a2,0x1
    80000814:	4581                	li	a1,0
    80000816:	00000097          	auipc	ra,0x0
    8000081a:	964080e7          	jalr	-1692(ra) # 8000017a <memset>
  return pagetable;
}
    8000081e:	8526                	mv	a0,s1
    80000820:	60e2                	ld	ra,24(sp)
    80000822:	6442                	ld	s0,16(sp)
    80000824:	64a2                	ld	s1,8(sp)
    80000826:	6105                	addi	sp,sp,32
    80000828:	8082                	ret

000000008000082a <uvmfirst>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000082a:	7179                	addi	sp,sp,-48
    8000082c:	f406                	sd	ra,40(sp)
    8000082e:	f022                	sd	s0,32(sp)
    80000830:	ec26                	sd	s1,24(sp)
    80000832:	e84a                	sd	s2,16(sp)
    80000834:	e44e                	sd	s3,8(sp)
    80000836:	e052                	sd	s4,0(sp)
    80000838:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE)
    8000083a:	6785                	lui	a5,0x1
    8000083c:	04f67863          	bgeu	a2,a5,8000088c <uvmfirst+0x62>
    80000840:	8a2a                	mv	s4,a0
    80000842:	89ae                	mv	s3,a1
    80000844:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000846:	00000097          	auipc	ra,0x0
    8000084a:	8d4080e7          	jalr	-1836(ra) # 8000011a <kalloc>
    8000084e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000850:	6605                	lui	a2,0x1
    80000852:	4581                	li	a1,0
    80000854:	00000097          	auipc	ra,0x0
    80000858:	926080e7          	jalr	-1754(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    8000085c:	4779                	li	a4,30
    8000085e:	86ca                	mv	a3,s2
    80000860:	6605                	lui	a2,0x1
    80000862:	4581                	li	a1,0
    80000864:	8552                	mv	a0,s4
    80000866:	00000097          	auipc	ra,0x0
    8000086a:	cd8080e7          	jalr	-808(ra) # 8000053e <mappages>
  memmove(mem, src, sz);
    8000086e:	8626                	mv	a2,s1
    80000870:	85ce                	mv	a1,s3
    80000872:	854a                	mv	a0,s2
    80000874:	00000097          	auipc	ra,0x0
    80000878:	962080e7          	jalr	-1694(ra) # 800001d6 <memmove>
}
    8000087c:	70a2                	ld	ra,40(sp)
    8000087e:	7402                	ld	s0,32(sp)
    80000880:	64e2                	ld	s1,24(sp)
    80000882:	6942                	ld	s2,16(sp)
    80000884:	69a2                	ld	s3,8(sp)
    80000886:	6a02                	ld	s4,0(sp)
    80000888:	6145                	addi	sp,sp,48
    8000088a:	8082                	ret
    panic("uvmfirst: more than a page");
    8000088c:	00008517          	auipc	a0,0x8
    80000890:	88c50513          	addi	a0,a0,-1908 # 80008118 <etext+0x118>
    80000894:	00005097          	auipc	ra,0x5
    80000898:	72e080e7          	jalr	1838(ra) # 80005fc2 <panic>

000000008000089c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000089c:	1101                	addi	sp,sp,-32
    8000089e:	ec06                	sd	ra,24(sp)
    800008a0:	e822                	sd	s0,16(sp)
    800008a2:	e426                	sd	s1,8(sp)
    800008a4:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    800008a6:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    800008a8:	00b67d63          	bgeu	a2,a1,800008c2 <uvmdealloc+0x26>
    800008ac:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz))
    800008ae:	6785                	lui	a5,0x1
    800008b0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008b2:	00f60733          	add	a4,a2,a5
    800008b6:	76fd                	lui	a3,0xfffff
    800008b8:	8f75                	and	a4,a4,a3
    800008ba:	97ae                	add	a5,a5,a1
    800008bc:	8ff5                	and	a5,a5,a3
    800008be:	00f76863          	bltu	a4,a5,800008ce <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008c2:	8526                	mv	a0,s1
    800008c4:	60e2                	ld	ra,24(sp)
    800008c6:	6442                	ld	s0,16(sp)
    800008c8:	64a2                	ld	s1,8(sp)
    800008ca:	6105                	addi	sp,sp,32
    800008cc:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008ce:	8f99                	sub	a5,a5,a4
    800008d0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008d2:	4685                	li	a3,1
    800008d4:	0007861b          	sext.w	a2,a5
    800008d8:	85ba                	mv	a1,a4
    800008da:	00000097          	auipc	ra,0x0
    800008de:	e4e080e7          	jalr	-434(ra) # 80000728 <uvmunmap>
    800008e2:	b7c5                	j	800008c2 <uvmdealloc+0x26>

00000000800008e4 <uvmalloc>:
  if (newsz < oldsz)
    800008e4:	0ab66b63          	bltu	a2,a1,8000099a <uvmalloc+0xb6>
{
    800008e8:	7139                	addi	sp,sp,-64
    800008ea:	fc06                	sd	ra,56(sp)
    800008ec:	f822                	sd	s0,48(sp)
    800008ee:	ec4e                	sd	s3,24(sp)
    800008f0:	e852                	sd	s4,16(sp)
    800008f2:	e456                	sd	s5,8(sp)
    800008f4:	0080                	addi	s0,sp,64
    800008f6:	8aaa                	mv	s5,a0
    800008f8:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008fa:	6785                	lui	a5,0x1
    800008fc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008fe:	95be                	add	a1,a1,a5
    80000900:	77fd                	lui	a5,0xfffff
    80000902:	00f5f9b3          	and	s3,a1,a5
  for (a = oldsz; a < newsz; a += PGSIZE)
    80000906:	08c9fc63          	bgeu	s3,a2,8000099e <uvmalloc+0xba>
    8000090a:	f426                	sd	s1,40(sp)
    8000090c:	f04a                	sd	s2,32(sp)
    8000090e:	e05a                	sd	s6,0(sp)
    80000910:	894e                	mv	s2,s3
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) != 0)
    80000912:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000916:	00000097          	auipc	ra,0x0
    8000091a:	804080e7          	jalr	-2044(ra) # 8000011a <kalloc>
    8000091e:	84aa                	mv	s1,a0
    if (mem == 0)
    80000920:	c915                	beqz	a0,80000954 <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    80000922:	6605                	lui	a2,0x1
    80000924:	4581                	li	a1,0
    80000926:	00000097          	auipc	ra,0x0
    8000092a:	854080e7          	jalr	-1964(ra) # 8000017a <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) != 0)
    8000092e:	875a                	mv	a4,s6
    80000930:	86a6                	mv	a3,s1
    80000932:	6605                	lui	a2,0x1
    80000934:	85ca                	mv	a1,s2
    80000936:	8556                	mv	a0,s5
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	c06080e7          	jalr	-1018(ra) # 8000053e <mappages>
    80000940:	ed05                	bnez	a0,80000978 <uvmalloc+0x94>
  for (a = oldsz; a < newsz; a += PGSIZE)
    80000942:	6785                	lui	a5,0x1
    80000944:	993e                	add	s2,s2,a5
    80000946:	fd4968e3          	bltu	s2,s4,80000916 <uvmalloc+0x32>
  return newsz;
    8000094a:	8552                	mv	a0,s4
    8000094c:	74a2                	ld	s1,40(sp)
    8000094e:	7902                	ld	s2,32(sp)
    80000950:	6b02                	ld	s6,0(sp)
    80000952:	a821                	j	8000096a <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    80000954:	864e                	mv	a2,s3
    80000956:	85ca                	mv	a1,s2
    80000958:	8556                	mv	a0,s5
    8000095a:	00000097          	auipc	ra,0x0
    8000095e:	f42080e7          	jalr	-190(ra) # 8000089c <uvmdealloc>
      return 0;
    80000962:	4501                	li	a0,0
    80000964:	74a2                	ld	s1,40(sp)
    80000966:	7902                	ld	s2,32(sp)
    80000968:	6b02                	ld	s6,0(sp)
}
    8000096a:	70e2                	ld	ra,56(sp)
    8000096c:	7442                	ld	s0,48(sp)
    8000096e:	69e2                	ld	s3,24(sp)
    80000970:	6a42                	ld	s4,16(sp)
    80000972:	6aa2                	ld	s5,8(sp)
    80000974:	6121                	addi	sp,sp,64
    80000976:	8082                	ret
      kfree(mem);
    80000978:	8526                	mv	a0,s1
    8000097a:	fffff097          	auipc	ra,0xfffff
    8000097e:	6a2080e7          	jalr	1698(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000982:	864e                	mv	a2,s3
    80000984:	85ca                	mv	a1,s2
    80000986:	8556                	mv	a0,s5
    80000988:	00000097          	auipc	ra,0x0
    8000098c:	f14080e7          	jalr	-236(ra) # 8000089c <uvmdealloc>
      return 0;
    80000990:	4501                	li	a0,0
    80000992:	74a2                	ld	s1,40(sp)
    80000994:	7902                	ld	s2,32(sp)
    80000996:	6b02                	ld	s6,0(sp)
    80000998:	bfc9                	j	8000096a <uvmalloc+0x86>
    return oldsz;
    8000099a:	852e                	mv	a0,a1
}
    8000099c:	8082                	ret
  return newsz;
    8000099e:	8532                	mv	a0,a2
    800009a0:	b7e9                	j	8000096a <uvmalloc+0x86>

00000000800009a2 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    800009a2:	7179                	addi	sp,sp,-48
    800009a4:	f406                	sd	ra,40(sp)
    800009a6:	f022                	sd	s0,32(sp)
    800009a8:	ec26                	sd	s1,24(sp)
    800009aa:	e84a                	sd	s2,16(sp)
    800009ac:	e44e                	sd	s3,8(sp)
    800009ae:	e052                	sd	s4,0(sp)
    800009b0:	1800                	addi	s0,sp,48
    800009b2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++)
    800009b4:	84aa                	mv	s1,a0
    800009b6:	6905                	lui	s2,0x1
    800009b8:	992a                	add	s2,s2,a0
  {
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    800009ba:	4985                	li	s3,1
    800009bc:	a829                	j	800009d6 <freewalk+0x34>
    {
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009be:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009c0:	00c79513          	slli	a0,a5,0xc
    800009c4:	00000097          	auipc	ra,0x0
    800009c8:	fde080e7          	jalr	-34(ra) # 800009a2 <freewalk>
      pagetable[i] = 0;
    800009cc:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++)
    800009d0:	04a1                	addi	s1,s1,8
    800009d2:	03248163          	beq	s1,s2,800009f4 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009d6:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    800009d8:	00f7f713          	andi	a4,a5,15
    800009dc:	ff3701e3          	beq	a4,s3,800009be <freewalk+0x1c>
    }
    else if (pte & PTE_V)
    800009e0:	8b85                	andi	a5,a5,1
    800009e2:	d7fd                	beqz	a5,800009d0 <freewalk+0x2e>
    {
      panic("freewalk: leaf");
    800009e4:	00007517          	auipc	a0,0x7
    800009e8:	75450513          	addi	a0,a0,1876 # 80008138 <etext+0x138>
    800009ec:	00005097          	auipc	ra,0x5
    800009f0:	5d6080e7          	jalr	1494(ra) # 80005fc2 <panic>
    }
  }
  kfree((void *)pagetable);
    800009f4:	8552                	mv	a0,s4
    800009f6:	fffff097          	auipc	ra,0xfffff
    800009fa:	626080e7          	jalr	1574(ra) # 8000001c <kfree>
}
    800009fe:	70a2                	ld	ra,40(sp)
    80000a00:	7402                	ld	s0,32(sp)
    80000a02:	64e2                	ld	s1,24(sp)
    80000a04:	6942                	ld	s2,16(sp)
    80000a06:	69a2                	ld	s3,8(sp)
    80000a08:	6a02                	ld	s4,0(sp)
    80000a0a:	6145                	addi	sp,sp,48
    80000a0c:	8082                	ret

0000000080000a0e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a0e:	1101                	addi	sp,sp,-32
    80000a10:	ec06                	sd	ra,24(sp)
    80000a12:	e822                	sd	s0,16(sp)
    80000a14:	e426                	sd	s1,8(sp)
    80000a16:	1000                	addi	s0,sp,32
    80000a18:	84aa                	mv	s1,a0
  if (sz > 0)
    80000a1a:	e999                	bnez	a1,80000a30 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    80000a1c:	8526                	mv	a0,s1
    80000a1e:	00000097          	auipc	ra,0x0
    80000a22:	f84080e7          	jalr	-124(ra) # 800009a2 <freewalk>
}
    80000a26:	60e2                	ld	ra,24(sp)
    80000a28:	6442                	ld	s0,16(sp)
    80000a2a:	64a2                	ld	s1,8(sp)
    80000a2c:	6105                	addi	sp,sp,32
    80000a2e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000a30:	6785                	lui	a5,0x1
    80000a32:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a34:	95be                	add	a1,a1,a5
    80000a36:	4685                	li	a3,1
    80000a38:	00c5d613          	srli	a2,a1,0xc
    80000a3c:	4581                	li	a1,0
    80000a3e:	00000097          	auipc	ra,0x0
    80000a42:	cea080e7          	jalr	-790(ra) # 80000728 <uvmunmap>
    80000a46:	bfd9                	j	80000a1c <uvmfree+0xe>

0000000080000a48 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for (i = 0; i < sz; i += PGSIZE)
    80000a48:	c679                	beqz	a2,80000b16 <uvmcopy+0xce>
{
    80000a4a:	715d                	addi	sp,sp,-80
    80000a4c:	e486                	sd	ra,72(sp)
    80000a4e:	e0a2                	sd	s0,64(sp)
    80000a50:	fc26                	sd	s1,56(sp)
    80000a52:	f84a                	sd	s2,48(sp)
    80000a54:	f44e                	sd	s3,40(sp)
    80000a56:	f052                	sd	s4,32(sp)
    80000a58:	ec56                	sd	s5,24(sp)
    80000a5a:	e85a                	sd	s6,16(sp)
    80000a5c:	e45e                	sd	s7,8(sp)
    80000a5e:	0880                	addi	s0,sp,80
    80000a60:	8b2a                	mv	s6,a0
    80000a62:	8aae                	mv	s5,a1
    80000a64:	8a32                	mv	s4,a2
  for (i = 0; i < sz; i += PGSIZE)
    80000a66:	4981                	li	s3,0
  {
    if ((pte = walk(old, i, 0)) == 0)
    80000a68:	4601                	li	a2,0
    80000a6a:	85ce                	mv	a1,s3
    80000a6c:	855a                	mv	a0,s6
    80000a6e:	00000097          	auipc	ra,0x0
    80000a72:	9e8080e7          	jalr	-1560(ra) # 80000456 <walk>
    80000a76:	c531                	beqz	a0,80000ac2 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if ((*pte & PTE_V) == 0)
    80000a78:	6118                	ld	a4,0(a0)
    80000a7a:	00177793          	andi	a5,a4,1
    80000a7e:	cbb1                	beqz	a5,80000ad2 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a80:	00a75593          	srli	a1,a4,0xa
    80000a84:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a88:	3ff77493          	andi	s1,a4,1023
    if ((mem = kalloc()) == 0)
    80000a8c:	fffff097          	auipc	ra,0xfffff
    80000a90:	68e080e7          	jalr	1678(ra) # 8000011a <kalloc>
    80000a94:	892a                	mv	s2,a0
    80000a96:	c939                	beqz	a0,80000aec <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char *)pa, PGSIZE);
    80000a98:	6605                	lui	a2,0x1
    80000a9a:	85de                	mv	a1,s7
    80000a9c:	fffff097          	auipc	ra,0xfffff
    80000aa0:	73a080e7          	jalr	1850(ra) # 800001d6 <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0)
    80000aa4:	8726                	mv	a4,s1
    80000aa6:	86ca                	mv	a3,s2
    80000aa8:	6605                	lui	a2,0x1
    80000aaa:	85ce                	mv	a1,s3
    80000aac:	8556                	mv	a0,s5
    80000aae:	00000097          	auipc	ra,0x0
    80000ab2:	a90080e7          	jalr	-1392(ra) # 8000053e <mappages>
    80000ab6:	e515                	bnez	a0,80000ae2 <uvmcopy+0x9a>
  for (i = 0; i < sz; i += PGSIZE)
    80000ab8:	6785                	lui	a5,0x1
    80000aba:	99be                	add	s3,s3,a5
    80000abc:	fb49e6e3          	bltu	s3,s4,80000a68 <uvmcopy+0x20>
    80000ac0:	a081                	j	80000b00 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ac2:	00007517          	auipc	a0,0x7
    80000ac6:	68650513          	addi	a0,a0,1670 # 80008148 <etext+0x148>
    80000aca:	00005097          	auipc	ra,0x5
    80000ace:	4f8080e7          	jalr	1272(ra) # 80005fc2 <panic>
      panic("uvmcopy: page not present");
    80000ad2:	00007517          	auipc	a0,0x7
    80000ad6:	69650513          	addi	a0,a0,1686 # 80008168 <etext+0x168>
    80000ada:	00005097          	auipc	ra,0x5
    80000ade:	4e8080e7          	jalr	1256(ra) # 80005fc2 <panic>
    {
      kfree(mem);
    80000ae2:	854a                	mv	a0,s2
    80000ae4:	fffff097          	auipc	ra,0xfffff
    80000ae8:	538080e7          	jalr	1336(ra) # 8000001c <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aec:	4685                	li	a3,1
    80000aee:	00c9d613          	srli	a2,s3,0xc
    80000af2:	4581                	li	a1,0
    80000af4:	8556                	mv	a0,s5
    80000af6:	00000097          	auipc	ra,0x0
    80000afa:	c32080e7          	jalr	-974(ra) # 80000728 <uvmunmap>
  return -1;
    80000afe:	557d                	li	a0,-1
}
    80000b00:	60a6                	ld	ra,72(sp)
    80000b02:	6406                	ld	s0,64(sp)
    80000b04:	74e2                	ld	s1,56(sp)
    80000b06:	7942                	ld	s2,48(sp)
    80000b08:	79a2                	ld	s3,40(sp)
    80000b0a:	7a02                	ld	s4,32(sp)
    80000b0c:	6ae2                	ld	s5,24(sp)
    80000b0e:	6b42                	ld	s6,16(sp)
    80000b10:	6ba2                	ld	s7,8(sp)
    80000b12:	6161                	addi	sp,sp,80
    80000b14:	8082                	ret
  return 0;
    80000b16:	4501                	li	a0,0
}
    80000b18:	8082                	ret

0000000080000b1a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b1a:	1141                	addi	sp,sp,-16
    80000b1c:	e406                	sd	ra,8(sp)
    80000b1e:	e022                	sd	s0,0(sp)
    80000b20:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80000b22:	4601                	li	a2,0
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	932080e7          	jalr	-1742(ra) # 80000456 <walk>
  if (pte == 0)
    80000b2c:	c901                	beqz	a0,80000b3c <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b2e:	611c                	ld	a5,0(a0)
    80000b30:	9bbd                	andi	a5,a5,-17
    80000b32:	e11c                	sd	a5,0(a0)
}
    80000b34:	60a2                	ld	ra,8(sp)
    80000b36:	6402                	ld	s0,0(sp)
    80000b38:	0141                	addi	sp,sp,16
    80000b3a:	8082                	ret
    panic("uvmclear");
    80000b3c:	00007517          	auipc	a0,0x7
    80000b40:	64c50513          	addi	a0,a0,1612 # 80008188 <etext+0x188>
    80000b44:	00005097          	auipc	ra,0x5
    80000b48:	47e080e7          	jalr	1150(ra) # 80005fc2 <panic>

0000000080000b4c <copyout>:
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while (len > 0)
    80000b4c:	ced1                	beqz	a3,80000be8 <copyout+0x9c>
{
    80000b4e:	711d                	addi	sp,sp,-96
    80000b50:	ec86                	sd	ra,88(sp)
    80000b52:	e8a2                	sd	s0,80(sp)
    80000b54:	e4a6                	sd	s1,72(sp)
    80000b56:	fc4e                	sd	s3,56(sp)
    80000b58:	f456                	sd	s5,40(sp)
    80000b5a:	f05a                	sd	s6,32(sp)
    80000b5c:	ec5e                	sd	s7,24(sp)
    80000b5e:	1080                	addi	s0,sp,96
    80000b60:	8baa                	mv	s7,a0
    80000b62:	8aae                	mv	s5,a1
    80000b64:	8b32                	mv	s6,a2
    80000b66:	89b6                	mv	s3,a3
  {
    va0 = PGROUNDDOWN(dstva);
    80000b68:	74fd                	lui	s1,0xfffff
    80000b6a:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA)
    80000b6c:	57fd                	li	a5,-1
    80000b6e:	83e9                	srli	a5,a5,0x1a
    80000b70:	0697ee63          	bltu	a5,s1,80000bec <copyout+0xa0>
    80000b74:	e0ca                	sd	s2,64(sp)
    80000b76:	f852                	sd	s4,48(sp)
    80000b78:	e862                	sd	s8,16(sp)
    80000b7a:	e466                	sd	s9,8(sp)
    80000b7c:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if (pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000b7e:	4cd5                	li	s9,21
    80000b80:	6d05                	lui	s10,0x1
    if (va0 >= MAXVA)
    80000b82:	8c3e                	mv	s8,a5
    80000b84:	a035                	j	80000bb0 <copyout+0x64>
        (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000b86:	83a9                	srli	a5,a5,0xa
    80000b88:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if (n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b8a:	409a8533          	sub	a0,s5,s1
    80000b8e:	0009061b          	sext.w	a2,s2
    80000b92:	85da                	mv	a1,s6
    80000b94:	953e                	add	a0,a0,a5
    80000b96:	fffff097          	auipc	ra,0xfffff
    80000b9a:	640080e7          	jalr	1600(ra) # 800001d6 <memmove>

    len -= n;
    80000b9e:	412989b3          	sub	s3,s3,s2
    src += n;
    80000ba2:	9b4a                	add	s6,s6,s2
  while (len > 0)
    80000ba4:	02098b63          	beqz	s3,80000bda <copyout+0x8e>
    if (va0 >= MAXVA)
    80000ba8:	054c6463          	bltu	s8,s4,80000bf0 <copyout+0xa4>
    80000bac:	84d2                	mv	s1,s4
    80000bae:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000bb0:	4601                	li	a2,0
    80000bb2:	85a6                	mv	a1,s1
    80000bb4:	855e                	mv	a0,s7
    80000bb6:	00000097          	auipc	ra,0x0
    80000bba:	8a0080e7          	jalr	-1888(ra) # 80000456 <walk>
    if (pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000bbe:	c121                	beqz	a0,80000bfe <copyout+0xb2>
    80000bc0:	611c                	ld	a5,0(a0)
    80000bc2:	0157f713          	andi	a4,a5,21
    80000bc6:	05971b63          	bne	a4,s9,80000c1c <copyout+0xd0>
    n = PGSIZE - (dstva - va0);
    80000bca:	01a48a33          	add	s4,s1,s10
    80000bce:	415a0933          	sub	s2,s4,s5
    if (n > len)
    80000bd2:	fb29fae3          	bgeu	s3,s2,80000b86 <copyout+0x3a>
    80000bd6:	894e                	mv	s2,s3
    80000bd8:	b77d                	j	80000b86 <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000bda:	4501                	li	a0,0
    80000bdc:	6906                	ld	s2,64(sp)
    80000bde:	7a42                	ld	s4,48(sp)
    80000be0:	6c42                	ld	s8,16(sp)
    80000be2:	6ca2                	ld	s9,8(sp)
    80000be4:	6d02                	ld	s10,0(sp)
    80000be6:	a015                	j	80000c0a <copyout+0xbe>
    80000be8:	4501                	li	a0,0
}
    80000bea:	8082                	ret
      return -1;
    80000bec:	557d                	li	a0,-1
    80000bee:	a831                	j	80000c0a <copyout+0xbe>
    80000bf0:	557d                	li	a0,-1
    80000bf2:	6906                	ld	s2,64(sp)
    80000bf4:	7a42                	ld	s4,48(sp)
    80000bf6:	6c42                	ld	s8,16(sp)
    80000bf8:	6ca2                	ld	s9,8(sp)
    80000bfa:	6d02                	ld	s10,0(sp)
    80000bfc:	a039                	j	80000c0a <copyout+0xbe>
      return -1;
    80000bfe:	557d                	li	a0,-1
    80000c00:	6906                	ld	s2,64(sp)
    80000c02:	7a42                	ld	s4,48(sp)
    80000c04:	6c42                	ld	s8,16(sp)
    80000c06:	6ca2                	ld	s9,8(sp)
    80000c08:	6d02                	ld	s10,0(sp)
}
    80000c0a:	60e6                	ld	ra,88(sp)
    80000c0c:	6446                	ld	s0,80(sp)
    80000c0e:	64a6                	ld	s1,72(sp)
    80000c10:	79e2                	ld	s3,56(sp)
    80000c12:	7aa2                	ld	s5,40(sp)
    80000c14:	7b02                	ld	s6,32(sp)
    80000c16:	6be2                	ld	s7,24(sp)
    80000c18:	6125                	addi	sp,sp,96
    80000c1a:	8082                	ret
      return -1;
    80000c1c:	557d                	li	a0,-1
    80000c1e:	6906                	ld	s2,64(sp)
    80000c20:	7a42                	ld	s4,48(sp)
    80000c22:	6c42                	ld	s8,16(sp)
    80000c24:	6ca2                	ld	s9,8(sp)
    80000c26:	6d02                	ld	s10,0(sp)
    80000c28:	b7cd                	j	80000c0a <copyout+0xbe>

0000000080000c2a <copyin>:
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while (len > 0)
    80000c2a:	caa5                	beqz	a3,80000c9a <copyin+0x70>
{
    80000c2c:	715d                	addi	sp,sp,-80
    80000c2e:	e486                	sd	ra,72(sp)
    80000c30:	e0a2                	sd	s0,64(sp)
    80000c32:	fc26                	sd	s1,56(sp)
    80000c34:	f84a                	sd	s2,48(sp)
    80000c36:	f44e                	sd	s3,40(sp)
    80000c38:	f052                	sd	s4,32(sp)
    80000c3a:	ec56                	sd	s5,24(sp)
    80000c3c:	e85a                	sd	s6,16(sp)
    80000c3e:	e45e                	sd	s7,8(sp)
    80000c40:	e062                	sd	s8,0(sp)
    80000c42:	0880                	addi	s0,sp,80
    80000c44:	8b2a                	mv	s6,a0
    80000c46:	8a2e                	mv	s4,a1
    80000c48:	8c32                	mv	s8,a2
    80000c4a:	89b6                	mv	s3,a3
  {
    va0 = PGROUNDDOWN(srcva);
    80000c4c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c4e:	6a85                	lui	s5,0x1
    80000c50:	a01d                	j	80000c76 <copyin+0x4c>
    if (n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c52:	018505b3          	add	a1,a0,s8
    80000c56:	0004861b          	sext.w	a2,s1
    80000c5a:	412585b3          	sub	a1,a1,s2
    80000c5e:	8552                	mv	a0,s4
    80000c60:	fffff097          	auipc	ra,0xfffff
    80000c64:	576080e7          	jalr	1398(ra) # 800001d6 <memmove>

    len -= n;
    80000c68:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c6c:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c6e:	01590c33          	add	s8,s2,s5
  while (len > 0)
    80000c72:	02098263          	beqz	s3,80000c96 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c76:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c7a:	85ca                	mv	a1,s2
    80000c7c:	855a                	mv	a0,s6
    80000c7e:	00000097          	auipc	ra,0x0
    80000c82:	87e080e7          	jalr	-1922(ra) # 800004fc <walkaddr>
    if (pa0 == 0)
    80000c86:	cd01                	beqz	a0,80000c9e <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c88:	418904b3          	sub	s1,s2,s8
    80000c8c:	94d6                	add	s1,s1,s5
    if (n > len)
    80000c8e:	fc99f2e3          	bgeu	s3,s1,80000c52 <copyin+0x28>
    80000c92:	84ce                	mv	s1,s3
    80000c94:	bf7d                	j	80000c52 <copyin+0x28>
  }
  return 0;
    80000c96:	4501                	li	a0,0
    80000c98:	a021                	j	80000ca0 <copyin+0x76>
    80000c9a:	4501                	li	a0,0
}
    80000c9c:	8082                	ret
      return -1;
    80000c9e:	557d                	li	a0,-1
}
    80000ca0:	60a6                	ld	ra,72(sp)
    80000ca2:	6406                	ld	s0,64(sp)
    80000ca4:	74e2                	ld	s1,56(sp)
    80000ca6:	7942                	ld	s2,48(sp)
    80000ca8:	79a2                	ld	s3,40(sp)
    80000caa:	7a02                	ld	s4,32(sp)
    80000cac:	6ae2                	ld	s5,24(sp)
    80000cae:	6b42                	ld	s6,16(sp)
    80000cb0:	6ba2                	ld	s7,8(sp)
    80000cb2:	6c02                	ld	s8,0(sp)
    80000cb4:	6161                	addi	sp,sp,80
    80000cb6:	8082                	ret

0000000080000cb8 <copyinstr>:
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0)
    80000cb8:	cacd                	beqz	a3,80000d6a <copyinstr+0xb2>
{
    80000cba:	715d                	addi	sp,sp,-80
    80000cbc:	e486                	sd	ra,72(sp)
    80000cbe:	e0a2                	sd	s0,64(sp)
    80000cc0:	fc26                	sd	s1,56(sp)
    80000cc2:	f84a                	sd	s2,48(sp)
    80000cc4:	f44e                	sd	s3,40(sp)
    80000cc6:	f052                	sd	s4,32(sp)
    80000cc8:	ec56                	sd	s5,24(sp)
    80000cca:	e85a                	sd	s6,16(sp)
    80000ccc:	e45e                	sd	s7,8(sp)
    80000cce:	0880                	addi	s0,sp,80
    80000cd0:	8a2a                	mv	s4,a0
    80000cd2:	8b2e                	mv	s6,a1
    80000cd4:	8bb2                	mv	s7,a2
    80000cd6:	8936                	mv	s2,a3
  {
    va0 = PGROUNDDOWN(srcva);
    80000cd8:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000cda:	6985                	lui	s3,0x1
    80000cdc:	a825                	j	80000d14 <copyinstr+0x5c>
    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0)
    {
      if (*p == '\0')
      {
        *dst = '\0';
    80000cde:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000ce2:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null)
    80000ce4:	37fd                	addiw	a5,a5,-1
    80000ce6:	0007851b          	sext.w	a0,a5
  }
  else
  {
    return -1;
  }
}
    80000cea:	60a6                	ld	ra,72(sp)
    80000cec:	6406                	ld	s0,64(sp)
    80000cee:	74e2                	ld	s1,56(sp)
    80000cf0:	7942                	ld	s2,48(sp)
    80000cf2:	79a2                	ld	s3,40(sp)
    80000cf4:	7a02                	ld	s4,32(sp)
    80000cf6:	6ae2                	ld	s5,24(sp)
    80000cf8:	6b42                	ld	s6,16(sp)
    80000cfa:	6ba2                	ld	s7,8(sp)
    80000cfc:	6161                	addi	sp,sp,80
    80000cfe:	8082                	ret
    80000d00:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000d04:	9742                	add	a4,a4,a6
      --max;
    80000d06:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000d0a:	01348bb3          	add	s7,s1,s3
  while (got_null == 0 && max > 0)
    80000d0e:	04e58663          	beq	a1,a4,80000d5a <copyinstr+0xa2>
{
    80000d12:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000d14:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d18:	85a6                	mv	a1,s1
    80000d1a:	8552                	mv	a0,s4
    80000d1c:	fffff097          	auipc	ra,0xfffff
    80000d20:	7e0080e7          	jalr	2016(ra) # 800004fc <walkaddr>
    if (pa0 == 0)
    80000d24:	cd0d                	beqz	a0,80000d5e <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000d26:	417486b3          	sub	a3,s1,s7
    80000d2a:	96ce                	add	a3,a3,s3
    if (n > max)
    80000d2c:	00d97363          	bgeu	s2,a3,80000d32 <copyinstr+0x7a>
    80000d30:	86ca                	mv	a3,s2
    char *p = (char *)(pa0 + (srcva - va0));
    80000d32:	955e                	add	a0,a0,s7
    80000d34:	8d05                	sub	a0,a0,s1
    while (n > 0)
    80000d36:	c695                	beqz	a3,80000d62 <copyinstr+0xaa>
    80000d38:	87da                	mv	a5,s6
    80000d3a:	885a                	mv	a6,s6
      if (*p == '\0')
    80000d3c:	41650633          	sub	a2,a0,s6
    while (n > 0)
    80000d40:	96da                	add	a3,a3,s6
    80000d42:	85be                	mv	a1,a5
      if (*p == '\0')
    80000d44:	00f60733          	add	a4,a2,a5
    80000d48:	00074703          	lbu	a4,0(a4)
    80000d4c:	db49                	beqz	a4,80000cde <copyinstr+0x26>
        *dst = *p;
    80000d4e:	00e78023          	sb	a4,0(a5)
      dst++;
    80000d52:	0785                	addi	a5,a5,1
    while (n > 0)
    80000d54:	fed797e3          	bne	a5,a3,80000d42 <copyinstr+0x8a>
    80000d58:	b765                	j	80000d00 <copyinstr+0x48>
    80000d5a:	4781                	li	a5,0
    80000d5c:	b761                	j	80000ce4 <copyinstr+0x2c>
      return -1;
    80000d5e:	557d                	li	a0,-1
    80000d60:	b769                	j	80000cea <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000d62:	6b85                	lui	s7,0x1
    80000d64:	9ba6                	add	s7,s7,s1
    80000d66:	87da                	mv	a5,s6
    80000d68:	b76d                	j	80000d12 <copyinstr+0x5a>
  int got_null = 0;
    80000d6a:	4781                	li	a5,0
  if (got_null)
    80000d6c:	37fd                	addiw	a5,a5,-1
    80000d6e:	0007851b          	sext.w	a0,a5
}
    80000d72:	8082                	ret

0000000080000d74 <_pteprint>:

void _pteprint(pagetable_t pagetable, int level)
{
    80000d74:	711d                	addi	sp,sp,-96
    80000d76:	ec86                	sd	ra,88(sp)
    80000d78:	e8a2                	sd	s0,80(sp)
    80000d7a:	e4a6                	sd	s1,72(sp)
    80000d7c:	e0ca                	sd	s2,64(sp)
    80000d7e:	fc4e                	sd	s3,56(sp)
    80000d80:	f852                	sd	s4,48(sp)
    80000d82:	f456                	sd	s5,40(sp)
    80000d84:	f05a                	sd	s6,32(sp)
    80000d86:	ec5e                	sd	s7,24(sp)
    80000d88:	e862                	sd	s8,16(sp)
    80000d8a:	e466                	sd	s9,8(sp)
    80000d8c:	e06a                	sd	s10,0(sp)
    80000d8e:	1080                	addi	s0,sp,96
    80000d90:	8aae                	mv	s5,a1
  for (int i = 0; i < 512; i++)
    80000d92:	8a2a                	mv	s4,a0
    80000d94:	4981                	li	s3,0

    if (pte & PTE_V)
    {
      for (int j = 0; j <= level; j++)
        printf(".. ");
      printf("%d: pte %p pa %p\n", i, pte, PTE2PA(pte));
    80000d96:	00007c97          	auipc	s9,0x7
    80000d9a:	40ac8c93          	addi	s9,s9,1034 # 800081a0 <etext+0x1a0>
      for (int j = 0; j <= level; j++)
    80000d9e:	4d01                	li	s10,0
        printf(".. ");
    80000da0:	00007b17          	auipc	s6,0x7
    80000da4:	3f8b0b13          	addi	s6,s6,1016 # 80008198 <etext+0x198>
    }
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_W)) == 0)
    80000da8:	4c05                	li	s8,1
  for (int i = 0; i < 512; i++)
    80000daa:	20000b93          	li	s7,512
    80000dae:	a01d                	j	80000dd4 <_pteprint+0x60>
      printf("%d: pte %p pa %p\n", i, pte, PTE2PA(pte));
    80000db0:	00a95693          	srli	a3,s2,0xa
    80000db4:	06b2                	slli	a3,a3,0xc
    80000db6:	864a                	mv	a2,s2
    80000db8:	85ce                	mv	a1,s3
    80000dba:	8566                	mv	a0,s9
    80000dbc:	00005097          	auipc	ra,0x5
    80000dc0:	250080e7          	jalr	592(ra) # 8000600c <printf>
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_W)) == 0)
    80000dc4:	00797793          	andi	a5,s2,7
    80000dc8:	03878763          	beq	a5,s8,80000df6 <_pteprint+0x82>
  for (int i = 0; i < 512; i++)
    80000dcc:	2985                	addiw	s3,s3,1 # 1001 <_entry-0x7fffefff>
    80000dce:	0a21                	addi	s4,s4,8
    80000dd0:	03798e63          	beq	s3,s7,80000e0c <_pteprint+0x98>
    pte_t pte = pagetable[i];
    80000dd4:	000a3903          	ld	s2,0(s4)
    if (pte & PTE_V)
    80000dd8:	00197793          	andi	a5,s2,1
    80000ddc:	d7e5                	beqz	a5,80000dc4 <_pteprint+0x50>
      for (int j = 0; j <= level; j++)
    80000dde:	fc0ac9e3          	bltz	s5,80000db0 <_pteprint+0x3c>
    80000de2:	84ea                	mv	s1,s10
        printf(".. ");
    80000de4:	855a                	mv	a0,s6
    80000de6:	00005097          	auipc	ra,0x5
    80000dea:	226080e7          	jalr	550(ra) # 8000600c <printf>
      for (int j = 0; j <= level; j++)
    80000dee:	2485                	addiw	s1,s1,1 # fffffffffffff001 <end+0xffffffff7ffda661>
    80000df0:	fe9adae3          	bge	s5,s1,80000de4 <_pteprint+0x70>
    80000df4:	bf75                	j	80000db0 <_pteprint+0x3c>
    {
      uint64 child = PTE2PA(pte);
    80000df6:	00a95913          	srli	s2,s2,0xa
      _pteprint((pagetable_t)child, level + 1);
    80000dfa:	001a859b          	addiw	a1,s5,1 # fffffffffffff001 <end+0xffffffff7ffda661>
    80000dfe:	00c91513          	slli	a0,s2,0xc
    80000e02:	00000097          	auipc	ra,0x0
    80000e06:	f72080e7          	jalr	-142(ra) # 80000d74 <_pteprint>
    80000e0a:	b7c9                	j	80000dcc <_pteprint+0x58>
    }
  }
}
    80000e0c:	60e6                	ld	ra,88(sp)
    80000e0e:	6446                	ld	s0,80(sp)
    80000e10:	64a6                	ld	s1,72(sp)
    80000e12:	6906                	ld	s2,64(sp)
    80000e14:	79e2                	ld	s3,56(sp)
    80000e16:	7a42                	ld	s4,48(sp)
    80000e18:	7aa2                	ld	s5,40(sp)
    80000e1a:	7b02                	ld	s6,32(sp)
    80000e1c:	6be2                	ld	s7,24(sp)
    80000e1e:	6c42                	ld	s8,16(sp)
    80000e20:	6ca2                	ld	s9,8(sp)
    80000e22:	6d02                	ld	s10,0(sp)
    80000e24:	6125                	addi	sp,sp,96
    80000e26:	8082                	ret

0000000080000e28 <vmprint>:

void vmprint(pagetable_t pagetable)
{
    80000e28:	1101                	addi	sp,sp,-32
    80000e2a:	ec06                	sd	ra,24(sp)
    80000e2c:	e822                	sd	s0,16(sp)
    80000e2e:	e426                	sd	s1,8(sp)
    80000e30:	1000                	addi	s0,sp,32
    80000e32:	84aa                	mv	s1,a0
  printf("page table %p\n", pagetable);
    80000e34:	85aa                	mv	a1,a0
    80000e36:	00007517          	auipc	a0,0x7
    80000e3a:	38250513          	addi	a0,a0,898 # 800081b8 <etext+0x1b8>
    80000e3e:	00005097          	auipc	ra,0x5
    80000e42:	1ce080e7          	jalr	462(ra) # 8000600c <printf>
  _pteprint(pagetable, 0);
    80000e46:	4581                	li	a1,0
    80000e48:	8526                	mv	a0,s1
    80000e4a:	00000097          	auipc	ra,0x0
    80000e4e:	f2a080e7          	jalr	-214(ra) # 80000d74 <_pteprint>
}
    80000e52:	60e2                	ld	ra,24(sp)
    80000e54:	6442                	ld	s0,16(sp)
    80000e56:	64a2                	ld	s1,8(sp)
    80000e58:	6105                	addi	sp,sp,32
    80000e5a:	8082                	ret

0000000080000e5c <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    80000e5c:	7139                	addi	sp,sp,-64
    80000e5e:	fc06                	sd	ra,56(sp)
    80000e60:	f822                	sd	s0,48(sp)
    80000e62:	f426                	sd	s1,40(sp)
    80000e64:	f04a                	sd	s2,32(sp)
    80000e66:	ec4e                	sd	s3,24(sp)
    80000e68:	e852                	sd	s4,16(sp)
    80000e6a:	e456                	sd	s5,8(sp)
    80000e6c:	e05a                	sd	s6,0(sp)
    80000e6e:	0080                	addi	s0,sp,64
    80000e70:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80000e72:	0000b497          	auipc	s1,0xb
    80000e76:	90e48493          	addi	s1,s1,-1778 # 8000b780 <proc>
  {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80000e7a:	8b26                	mv	s6,s1
    80000e7c:	ff4df937          	lui	s2,0xff4df
    80000e80:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4ba01d>
    80000e84:	0936                	slli	s2,s2,0xd
    80000e86:	6f590913          	addi	s2,s2,1781
    80000e8a:	0936                	slli	s2,s2,0xd
    80000e8c:	bd390913          	addi	s2,s2,-1069
    80000e90:	0932                	slli	s2,s2,0xc
    80000e92:	7a790913          	addi	s2,s2,1959
    80000e96:	010009b7          	lui	s3,0x1000
    80000e9a:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000e9c:	09ba                	slli	s3,s3,0xe
  for (p = proc; p < &proc[NPROC]; p++)
    80000e9e:	00010a97          	auipc	s5,0x10
    80000ea2:	4e2a8a93          	addi	s5,s5,1250 # 80011380 <tickslock>
    char *pa = kalloc();
    80000ea6:	fffff097          	auipc	ra,0xfffff
    80000eaa:	274080e7          	jalr	628(ra) # 8000011a <kalloc>
    80000eae:	862a                	mv	a2,a0
    if (pa == 0)
    80000eb0:	cd1d                	beqz	a0,80000eee <proc_mapstacks+0x92>
    uint64 va = KSTACK((int)(p - proc));
    80000eb2:	416485b3          	sub	a1,s1,s6
    80000eb6:	8591                	srai	a1,a1,0x4
    80000eb8:	032585b3          	mul	a1,a1,s2
    80000ebc:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000ec0:	4719                	li	a4,6
    80000ec2:	6685                	lui	a3,0x1
    80000ec4:	40b985b3          	sub	a1,s3,a1
    80000ec8:	8552                	mv	a0,s4
    80000eca:	fffff097          	auipc	ra,0xfffff
    80000ece:	738080e7          	jalr	1848(ra) # 80000602 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++)
    80000ed2:	17048493          	addi	s1,s1,368
    80000ed6:	fd5498e3          	bne	s1,s5,80000ea6 <proc_mapstacks+0x4a>
  }
}
    80000eda:	70e2                	ld	ra,56(sp)
    80000edc:	7442                	ld	s0,48(sp)
    80000ede:	74a2                	ld	s1,40(sp)
    80000ee0:	7902                	ld	s2,32(sp)
    80000ee2:	69e2                	ld	s3,24(sp)
    80000ee4:	6a42                	ld	s4,16(sp)
    80000ee6:	6aa2                	ld	s5,8(sp)
    80000ee8:	6b02                	ld	s6,0(sp)
    80000eea:	6121                	addi	sp,sp,64
    80000eec:	8082                	ret
      panic("kalloc");
    80000eee:	00007517          	auipc	a0,0x7
    80000ef2:	2da50513          	addi	a0,a0,730 # 800081c8 <etext+0x1c8>
    80000ef6:	00005097          	auipc	ra,0x5
    80000efa:	0cc080e7          	jalr	204(ra) # 80005fc2 <panic>

0000000080000efe <procinit>:

// initialize the proc table.
void procinit(void)
{
    80000efe:	7139                	addi	sp,sp,-64
    80000f00:	fc06                	sd	ra,56(sp)
    80000f02:	f822                	sd	s0,48(sp)
    80000f04:	f426                	sd	s1,40(sp)
    80000f06:	f04a                	sd	s2,32(sp)
    80000f08:	ec4e                	sd	s3,24(sp)
    80000f0a:	e852                	sd	s4,16(sp)
    80000f0c:	e456                	sd	s5,8(sp)
    80000f0e:	e05a                	sd	s6,0(sp)
    80000f10:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80000f12:	00007597          	auipc	a1,0x7
    80000f16:	2be58593          	addi	a1,a1,702 # 800081d0 <etext+0x1d0>
    80000f1a:	0000a517          	auipc	a0,0xa
    80000f1e:	43650513          	addi	a0,a0,1078 # 8000b350 <pid_lock>
    80000f22:	00005097          	auipc	ra,0x5
    80000f26:	58a080e7          	jalr	1418(ra) # 800064ac <initlock>
  initlock(&wait_lock, "wait_lock");
    80000f2a:	00007597          	auipc	a1,0x7
    80000f2e:	2ae58593          	addi	a1,a1,686 # 800081d8 <etext+0x1d8>
    80000f32:	0000a517          	auipc	a0,0xa
    80000f36:	43650513          	addi	a0,a0,1078 # 8000b368 <wait_lock>
    80000f3a:	00005097          	auipc	ra,0x5
    80000f3e:	572080e7          	jalr	1394(ra) # 800064ac <initlock>
  for (p = proc; p < &proc[NPROC]; p++)
    80000f42:	0000b497          	auipc	s1,0xb
    80000f46:	83e48493          	addi	s1,s1,-1986 # 8000b780 <proc>
  {
    initlock(&p->lock, "proc");
    80000f4a:	00007b17          	auipc	s6,0x7
    80000f4e:	29eb0b13          	addi	s6,s6,670 # 800081e8 <etext+0x1e8>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80000f52:	8aa6                	mv	s5,s1
    80000f54:	ff4df937          	lui	s2,0xff4df
    80000f58:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4ba01d>
    80000f5c:	0936                	slli	s2,s2,0xd
    80000f5e:	6f590913          	addi	s2,s2,1781
    80000f62:	0936                	slli	s2,s2,0xd
    80000f64:	bd390913          	addi	s2,s2,-1069
    80000f68:	0932                	slli	s2,s2,0xc
    80000f6a:	7a790913          	addi	s2,s2,1959
    80000f6e:	010009b7          	lui	s3,0x1000
    80000f72:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000f74:	09ba                	slli	s3,s3,0xe
  for (p = proc; p < &proc[NPROC]; p++)
    80000f76:	00010a17          	auipc	s4,0x10
    80000f7a:	40aa0a13          	addi	s4,s4,1034 # 80011380 <tickslock>
    initlock(&p->lock, "proc");
    80000f7e:	85da                	mv	a1,s6
    80000f80:	8526                	mv	a0,s1
    80000f82:	00005097          	auipc	ra,0x5
    80000f86:	52a080e7          	jalr	1322(ra) # 800064ac <initlock>
    p->state = UNUSED;
    80000f8a:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80000f8e:	415487b3          	sub	a5,s1,s5
    80000f92:	8791                	srai	a5,a5,0x4
    80000f94:	032787b3          	mul	a5,a5,s2
    80000f98:	00d7979b          	slliw	a5,a5,0xd
    80000f9c:	40f987b3          	sub	a5,s3,a5
    80000fa0:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++)
    80000fa2:	17048493          	addi	s1,s1,368
    80000fa6:	fd449ce3          	bne	s1,s4,80000f7e <procinit+0x80>
  }
}
    80000faa:	70e2                	ld	ra,56(sp)
    80000fac:	7442                	ld	s0,48(sp)
    80000fae:	74a2                	ld	s1,40(sp)
    80000fb0:	7902                	ld	s2,32(sp)
    80000fb2:	69e2                	ld	s3,24(sp)
    80000fb4:	6a42                	ld	s4,16(sp)
    80000fb6:	6aa2                	ld	s5,8(sp)
    80000fb8:	6b02                	ld	s6,0(sp)
    80000fba:	6121                	addi	sp,sp,64
    80000fbc:	8082                	ret

0000000080000fbe <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80000fbe:	1141                	addi	sp,sp,-16
    80000fc0:	e422                	sd	s0,8(sp)
    80000fc2:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000fc4:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000fc6:	2501                	sext.w	a0,a0
    80000fc8:	6422                	ld	s0,8(sp)
    80000fca:	0141                	addi	sp,sp,16
    80000fcc:	8082                	ret

0000000080000fce <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80000fce:	1141                	addi	sp,sp,-16
    80000fd0:	e422                	sd	s0,8(sp)
    80000fd2:	0800                	addi	s0,sp,16
    80000fd4:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000fd6:	2781                	sext.w	a5,a5
    80000fd8:	079e                	slli	a5,a5,0x7
  return c;
}
    80000fda:	0000a517          	auipc	a0,0xa
    80000fde:	3a650513          	addi	a0,a0,934 # 8000b380 <cpus>
    80000fe2:	953e                	add	a0,a0,a5
    80000fe4:	6422                	ld	s0,8(sp)
    80000fe6:	0141                	addi	sp,sp,16
    80000fe8:	8082                	ret

0000000080000fea <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80000fea:	1101                	addi	sp,sp,-32
    80000fec:	ec06                	sd	ra,24(sp)
    80000fee:	e822                	sd	s0,16(sp)
    80000ff0:	e426                	sd	s1,8(sp)
    80000ff2:	1000                	addi	s0,sp,32
  push_off();
    80000ff4:	00005097          	auipc	ra,0x5
    80000ff8:	4fc080e7          	jalr	1276(ra) # 800064f0 <push_off>
    80000ffc:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ffe:	2781                	sext.w	a5,a5
    80001000:	079e                	slli	a5,a5,0x7
    80001002:	0000a717          	auipc	a4,0xa
    80001006:	34e70713          	addi	a4,a4,846 # 8000b350 <pid_lock>
    8000100a:	97ba                	add	a5,a5,a4
    8000100c:	7b84                	ld	s1,48(a5)
  pop_off();
    8000100e:	00005097          	auipc	ra,0x5
    80001012:	582080e7          	jalr	1410(ra) # 80006590 <pop_off>
  return p;
}
    80001016:	8526                	mv	a0,s1
    80001018:	60e2                	ld	ra,24(sp)
    8000101a:	6442                	ld	s0,16(sp)
    8000101c:	64a2                	ld	s1,8(sp)
    8000101e:	6105                	addi	sp,sp,32
    80001020:	8082                	ret

0000000080001022 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001022:	1141                	addi	sp,sp,-16
    80001024:	e406                	sd	ra,8(sp)
    80001026:	e022                	sd	s0,0(sp)
    80001028:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    8000102a:	00000097          	auipc	ra,0x0
    8000102e:	fc0080e7          	jalr	-64(ra) # 80000fea <myproc>
    80001032:	00005097          	auipc	ra,0x5
    80001036:	5be080e7          	jalr	1470(ra) # 800065f0 <release>

  if (first)
    8000103a:	0000a797          	auipc	a5,0xa
    8000103e:	2567a783          	lw	a5,598(a5) # 8000b290 <first.1>
    80001042:	eb89                	bnez	a5,80001054 <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001044:	00001097          	auipc	ra,0x1
    80001048:	ce8080e7          	jalr	-792(ra) # 80001d2c <usertrapret>
}
    8000104c:	60a2                	ld	ra,8(sp)
    8000104e:	6402                	ld	s0,0(sp)
    80001050:	0141                	addi	sp,sp,16
    80001052:	8082                	ret
    fsinit(ROOTDEV);
    80001054:	4505                	li	a0,1
    80001056:	00002097          	auipc	ra,0x2
    8000105a:	b04080e7          	jalr	-1276(ra) # 80002b5a <fsinit>
    first = 0;
    8000105e:	0000a797          	auipc	a5,0xa
    80001062:	2207a923          	sw	zero,562(a5) # 8000b290 <first.1>
    __sync_synchronize();
    80001066:	0330000f          	fence	rw,rw
    8000106a:	bfe9                	j	80001044 <forkret+0x22>

000000008000106c <allocpid>:
{
    8000106c:	1101                	addi	sp,sp,-32
    8000106e:	ec06                	sd	ra,24(sp)
    80001070:	e822                	sd	s0,16(sp)
    80001072:	e426                	sd	s1,8(sp)
    80001074:	e04a                	sd	s2,0(sp)
    80001076:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001078:	0000a917          	auipc	s2,0xa
    8000107c:	2d890913          	addi	s2,s2,728 # 8000b350 <pid_lock>
    80001080:	854a                	mv	a0,s2
    80001082:	00005097          	auipc	ra,0x5
    80001086:	4ba080e7          	jalr	1210(ra) # 8000653c <acquire>
  pid = nextpid;
    8000108a:	0000a797          	auipc	a5,0xa
    8000108e:	20a78793          	addi	a5,a5,522 # 8000b294 <nextpid>
    80001092:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001094:	0014871b          	addiw	a4,s1,1
    80001098:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000109a:	854a                	mv	a0,s2
    8000109c:	00005097          	auipc	ra,0x5
    800010a0:	554080e7          	jalr	1364(ra) # 800065f0 <release>
}
    800010a4:	8526                	mv	a0,s1
    800010a6:	60e2                	ld	ra,24(sp)
    800010a8:	6442                	ld	s0,16(sp)
    800010aa:	64a2                	ld	s1,8(sp)
    800010ac:	6902                	ld	s2,0(sp)
    800010ae:	6105                	addi	sp,sp,32
    800010b0:	8082                	ret

00000000800010b2 <proc_pagetable>:
{
    800010b2:	1101                	addi	sp,sp,-32
    800010b4:	ec06                	sd	ra,24(sp)
    800010b6:	e822                	sd	s0,16(sp)
    800010b8:	e426                	sd	s1,8(sp)
    800010ba:	e04a                	sd	s2,0(sp)
    800010bc:	1000                	addi	s0,sp,32
    800010be:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800010c0:	fffff097          	auipc	ra,0xfffff
    800010c4:	73c080e7          	jalr	1852(ra) # 800007fc <uvmcreate>
    800010c8:	84aa                	mv	s1,a0
  if (pagetable == 0)
    800010ca:	cd39                	beqz	a0,80001128 <proc_pagetable+0x76>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    800010cc:	4729                	li	a4,10
    800010ce:	00006697          	auipc	a3,0x6
    800010d2:	f3268693          	addi	a3,a3,-206 # 80007000 <_trampoline>
    800010d6:	6605                	lui	a2,0x1
    800010d8:	040005b7          	lui	a1,0x4000
    800010dc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010de:	05b2                	slli	a1,a1,0xc
    800010e0:	fffff097          	auipc	ra,0xfffff
    800010e4:	45e080e7          	jalr	1118(ra) # 8000053e <mappages>
    800010e8:	04054763          	bltz	a0,80001136 <proc_pagetable+0x84>
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
    800010ec:	4719                	li	a4,6
    800010ee:	05893683          	ld	a3,88(s2)
    800010f2:	6605                	lui	a2,0x1
    800010f4:	020005b7          	lui	a1,0x2000
    800010f8:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010fa:	05b6                	slli	a1,a1,0xd
    800010fc:	8526                	mv	a0,s1
    800010fe:	fffff097          	auipc	ra,0xfffff
    80001102:	440080e7          	jalr	1088(ra) # 8000053e <mappages>
    80001106:	04054063          	bltz	a0,80001146 <proc_pagetable+0x94>
  if (mappages(pagetable, USYSCALL, PGSIZE,
    8000110a:	4749                	li	a4,18
    8000110c:	16893683          	ld	a3,360(s2)
    80001110:	6605                	lui	a2,0x1
    80001112:	040005b7          	lui	a1,0x4000
    80001116:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80001118:	05b2                	slli	a1,a1,0xc
    8000111a:	8526                	mv	a0,s1
    8000111c:	fffff097          	auipc	ra,0xfffff
    80001120:	422080e7          	jalr	1058(ra) # 8000053e <mappages>
    80001124:	04054463          	bltz	a0,8000116c <proc_pagetable+0xba>
}
    80001128:	8526                	mv	a0,s1
    8000112a:	60e2                	ld	ra,24(sp)
    8000112c:	6442                	ld	s0,16(sp)
    8000112e:	64a2                	ld	s1,8(sp)
    80001130:	6902                	ld	s2,0(sp)
    80001132:	6105                	addi	sp,sp,32
    80001134:	8082                	ret
    uvmfree(pagetable, 0);
    80001136:	4581                	li	a1,0
    80001138:	8526                	mv	a0,s1
    8000113a:	00000097          	auipc	ra,0x0
    8000113e:	8d4080e7          	jalr	-1836(ra) # 80000a0e <uvmfree>
    return 0;
    80001142:	4481                	li	s1,0
    80001144:	b7d5                	j	80001128 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001146:	4681                	li	a3,0
    80001148:	4605                	li	a2,1
    8000114a:	040005b7          	lui	a1,0x4000
    8000114e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001150:	05b2                	slli	a1,a1,0xc
    80001152:	8526                	mv	a0,s1
    80001154:	fffff097          	auipc	ra,0xfffff
    80001158:	5d4080e7          	jalr	1492(ra) # 80000728 <uvmunmap>
    uvmfree(pagetable, 0);
    8000115c:	4581                	li	a1,0
    8000115e:	8526                	mv	a0,s1
    80001160:	00000097          	auipc	ra,0x0
    80001164:	8ae080e7          	jalr	-1874(ra) # 80000a0e <uvmfree>
    return 0;
    80001168:	4481                	li	s1,0
    8000116a:	bf7d                	j	80001128 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000116c:	4681                	li	a3,0
    8000116e:	4605                	li	a2,1
    80001170:	040005b7          	lui	a1,0x4000
    80001174:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001176:	05b2                	slli	a1,a1,0xc
    80001178:	8526                	mv	a0,s1
    8000117a:	fffff097          	auipc	ra,0xfffff
    8000117e:	5ae080e7          	jalr	1454(ra) # 80000728 <uvmunmap>
    uvmfree(pagetable, 0);
    80001182:	4581                	li	a1,0
    80001184:	8526                	mv	a0,s1
    80001186:	00000097          	auipc	ra,0x0
    8000118a:	888080e7          	jalr	-1912(ra) # 80000a0e <uvmfree>
    return 0;
    8000118e:	4481                	li	s1,0
    80001190:	bf61                	j	80001128 <proc_pagetable+0x76>

0000000080001192 <proc_freepagetable>:
{
    80001192:	1101                	addi	sp,sp,-32
    80001194:	ec06                	sd	ra,24(sp)
    80001196:	e822                	sd	s0,16(sp)
    80001198:	e426                	sd	s1,8(sp)
    8000119a:	e04a                	sd	s2,0(sp)
    8000119c:	1000                	addi	s0,sp,32
    8000119e:	84aa                	mv	s1,a0
    800011a0:	892e                	mv	s2,a1
  uvmunmap(pagetable, USYSCALL, 1, 0);
    800011a2:	4681                	li	a3,0
    800011a4:	4605                	li	a2,1
    800011a6:	040005b7          	lui	a1,0x4000
    800011aa:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    800011ac:	05b2                	slli	a1,a1,0xc
    800011ae:	fffff097          	auipc	ra,0xfffff
    800011b2:	57a080e7          	jalr	1402(ra) # 80000728 <uvmunmap>
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800011b6:	4681                	li	a3,0
    800011b8:	4605                	li	a2,1
    800011ba:	040005b7          	lui	a1,0x4000
    800011be:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011c0:	05b2                	slli	a1,a1,0xc
    800011c2:	8526                	mv	a0,s1
    800011c4:	fffff097          	auipc	ra,0xfffff
    800011c8:	564080e7          	jalr	1380(ra) # 80000728 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800011cc:	4681                	li	a3,0
    800011ce:	4605                	li	a2,1
    800011d0:	020005b7          	lui	a1,0x2000
    800011d4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800011d6:	05b6                	slli	a1,a1,0xd
    800011d8:	8526                	mv	a0,s1
    800011da:	fffff097          	auipc	ra,0xfffff
    800011de:	54e080e7          	jalr	1358(ra) # 80000728 <uvmunmap>
  uvmfree(pagetable, sz);
    800011e2:	85ca                	mv	a1,s2
    800011e4:	8526                	mv	a0,s1
    800011e6:	00000097          	auipc	ra,0x0
    800011ea:	828080e7          	jalr	-2008(ra) # 80000a0e <uvmfree>
}
    800011ee:	60e2                	ld	ra,24(sp)
    800011f0:	6442                	ld	s0,16(sp)
    800011f2:	64a2                	ld	s1,8(sp)
    800011f4:	6902                	ld	s2,0(sp)
    800011f6:	6105                	addi	sp,sp,32
    800011f8:	8082                	ret

00000000800011fa <freeproc>:
{
    800011fa:	1101                	addi	sp,sp,-32
    800011fc:	ec06                	sd	ra,24(sp)
    800011fe:	e822                	sd	s0,16(sp)
    80001200:	e426                	sd	s1,8(sp)
    80001202:	1000                	addi	s0,sp,32
    80001204:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001206:	6d28                	ld	a0,88(a0)
    80001208:	c509                	beqz	a0,80001212 <freeproc+0x18>
    kfree((void *)p->trapframe);
    8000120a:	fffff097          	auipc	ra,0xfffff
    8000120e:	e12080e7          	jalr	-494(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001212:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    80001216:	68a8                	ld	a0,80(s1)
    80001218:	c511                	beqz	a0,80001224 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000121a:	64ac                	ld	a1,72(s1)
    8000121c:	00000097          	auipc	ra,0x0
    80001220:	f76080e7          	jalr	-138(ra) # 80001192 <proc_freepagetable>
  p->pagetable = 0;
    80001224:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001228:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000122c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001230:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001234:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001238:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000123c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001240:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001244:	0004ac23          	sw	zero,24(s1)
}
    80001248:	60e2                	ld	ra,24(sp)
    8000124a:	6442                	ld	s0,16(sp)
    8000124c:	64a2                	ld	s1,8(sp)
    8000124e:	6105                	addi	sp,sp,32
    80001250:	8082                	ret

0000000080001252 <allocproc>:
{
    80001252:	1101                	addi	sp,sp,-32
    80001254:	ec06                	sd	ra,24(sp)
    80001256:	e822                	sd	s0,16(sp)
    80001258:	e426                	sd	s1,8(sp)
    8000125a:	e04a                	sd	s2,0(sp)
    8000125c:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++)
    8000125e:	0000a497          	auipc	s1,0xa
    80001262:	52248493          	addi	s1,s1,1314 # 8000b780 <proc>
    80001266:	00010917          	auipc	s2,0x10
    8000126a:	11a90913          	addi	s2,s2,282 # 80011380 <tickslock>
    acquire(&p->lock);
    8000126e:	8526                	mv	a0,s1
    80001270:	00005097          	auipc	ra,0x5
    80001274:	2cc080e7          	jalr	716(ra) # 8000653c <acquire>
    if (p->state == UNUSED)
    80001278:	4c9c                	lw	a5,24(s1)
    8000127a:	cf81                	beqz	a5,80001292 <allocproc+0x40>
      release(&p->lock);
    8000127c:	8526                	mv	a0,s1
    8000127e:	00005097          	auipc	ra,0x5
    80001282:	372080e7          	jalr	882(ra) # 800065f0 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001286:	17048493          	addi	s1,s1,368
    8000128a:	ff2492e3          	bne	s1,s2,8000126e <allocproc+0x1c>
  return 0;
    8000128e:	4481                	li	s1,0
    80001290:	a09d                	j	800012f6 <allocproc+0xa4>
  p->pid = allocpid();
    80001292:	00000097          	auipc	ra,0x0
    80001296:	dda080e7          	jalr	-550(ra) # 8000106c <allocpid>
    8000129a:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000129c:	4785                	li	a5,1
    8000129e:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    800012a0:	fffff097          	auipc	ra,0xfffff
    800012a4:	e7a080e7          	jalr	-390(ra) # 8000011a <kalloc>
    800012a8:	892a                	mv	s2,a0
    800012aa:	eca8                	sd	a0,88(s1)
    800012ac:	cd21                	beqz	a0,80001304 <allocproc+0xb2>
  if ((p->usyscall = (struct usyscall *)kalloc()) == 0)
    800012ae:	fffff097          	auipc	ra,0xfffff
    800012b2:	e6c080e7          	jalr	-404(ra) # 8000011a <kalloc>
    800012b6:	892a                	mv	s2,a0
    800012b8:	16a4b423          	sd	a0,360(s1)
    800012bc:	c125                	beqz	a0,8000131c <allocproc+0xca>
  p->usyscall->pid = p->pid;
    800012be:	589c                	lw	a5,48(s1)
    800012c0:	c11c                	sw	a5,0(a0)
  p->pagetable = proc_pagetable(p);
    800012c2:	8526                	mv	a0,s1
    800012c4:	00000097          	auipc	ra,0x0
    800012c8:	dee080e7          	jalr	-530(ra) # 800010b2 <proc_pagetable>
    800012cc:	892a                	mv	s2,a0
    800012ce:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0)
    800012d0:	c135                	beqz	a0,80001334 <allocproc+0xe2>
  memset(&p->context, 0, sizeof(p->context));
    800012d2:	07000613          	li	a2,112
    800012d6:	4581                	li	a1,0
    800012d8:	06048513          	addi	a0,s1,96
    800012dc:	fffff097          	auipc	ra,0xfffff
    800012e0:	e9e080e7          	jalr	-354(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800012e4:	00000797          	auipc	a5,0x0
    800012e8:	d3e78793          	addi	a5,a5,-706 # 80001022 <forkret>
    800012ec:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800012ee:	60bc                	ld	a5,64(s1)
    800012f0:	6705                	lui	a4,0x1
    800012f2:	97ba                	add	a5,a5,a4
    800012f4:	f4bc                	sd	a5,104(s1)
}
    800012f6:	8526                	mv	a0,s1
    800012f8:	60e2                	ld	ra,24(sp)
    800012fa:	6442                	ld	s0,16(sp)
    800012fc:	64a2                	ld	s1,8(sp)
    800012fe:	6902                	ld	s2,0(sp)
    80001300:	6105                	addi	sp,sp,32
    80001302:	8082                	ret
    freeproc(p);
    80001304:	8526                	mv	a0,s1
    80001306:	00000097          	auipc	ra,0x0
    8000130a:	ef4080e7          	jalr	-268(ra) # 800011fa <freeproc>
    release(&p->lock);
    8000130e:	8526                	mv	a0,s1
    80001310:	00005097          	auipc	ra,0x5
    80001314:	2e0080e7          	jalr	736(ra) # 800065f0 <release>
    return 0;
    80001318:	84ca                	mv	s1,s2
    8000131a:	bff1                	j	800012f6 <allocproc+0xa4>
    freeproc(p);
    8000131c:	8526                	mv	a0,s1
    8000131e:	00000097          	auipc	ra,0x0
    80001322:	edc080e7          	jalr	-292(ra) # 800011fa <freeproc>
    release(&p->lock);
    80001326:	8526                	mv	a0,s1
    80001328:	00005097          	auipc	ra,0x5
    8000132c:	2c8080e7          	jalr	712(ra) # 800065f0 <release>
    return 0;
    80001330:	84ca                	mv	s1,s2
    80001332:	b7d1                	j	800012f6 <allocproc+0xa4>
    freeproc(p);
    80001334:	8526                	mv	a0,s1
    80001336:	00000097          	auipc	ra,0x0
    8000133a:	ec4080e7          	jalr	-316(ra) # 800011fa <freeproc>
    release(&p->lock);
    8000133e:	8526                	mv	a0,s1
    80001340:	00005097          	auipc	ra,0x5
    80001344:	2b0080e7          	jalr	688(ra) # 800065f0 <release>
    return 0;
    80001348:	84ca                	mv	s1,s2
    8000134a:	b775                	j	800012f6 <allocproc+0xa4>

000000008000134c <userinit>:
{
    8000134c:	1101                	addi	sp,sp,-32
    8000134e:	ec06                	sd	ra,24(sp)
    80001350:	e822                	sd	s0,16(sp)
    80001352:	e426                	sd	s1,8(sp)
    80001354:	1000                	addi	s0,sp,32
  p = allocproc();
    80001356:	00000097          	auipc	ra,0x0
    8000135a:	efc080e7          	jalr	-260(ra) # 80001252 <allocproc>
    8000135e:	84aa                	mv	s1,a0
  initproc = p;
    80001360:	0000a797          	auipc	a5,0xa
    80001364:	faa7b823          	sd	a0,-80(a5) # 8000b310 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001368:	03400613          	li	a2,52
    8000136c:	0000a597          	auipc	a1,0xa
    80001370:	f3458593          	addi	a1,a1,-204 # 8000b2a0 <initcode>
    80001374:	6928                	ld	a0,80(a0)
    80001376:	fffff097          	auipc	ra,0xfffff
    8000137a:	4b4080e7          	jalr	1204(ra) # 8000082a <uvmfirst>
  p->sz = PGSIZE;
    8000137e:	6785                	lui	a5,0x1
    80001380:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;     // user program counter
    80001382:	6cb8                	ld	a4,88(s1)
    80001384:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    80001388:	6cb8                	ld	a4,88(s1)
    8000138a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000138c:	4641                	li	a2,16
    8000138e:	00007597          	auipc	a1,0x7
    80001392:	e6258593          	addi	a1,a1,-414 # 800081f0 <etext+0x1f0>
    80001396:	15848513          	addi	a0,s1,344
    8000139a:	fffff097          	auipc	ra,0xfffff
    8000139e:	f22080e7          	jalr	-222(ra) # 800002bc <safestrcpy>
  p->cwd = namei("/");
    800013a2:	00007517          	auipc	a0,0x7
    800013a6:	e5e50513          	addi	a0,a0,-418 # 80008200 <etext+0x200>
    800013aa:	00002097          	auipc	ra,0x2
    800013ae:	202080e7          	jalr	514(ra) # 800035ac <namei>
    800013b2:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800013b6:	478d                	li	a5,3
    800013b8:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800013ba:	8526                	mv	a0,s1
    800013bc:	00005097          	auipc	ra,0x5
    800013c0:	234080e7          	jalr	564(ra) # 800065f0 <release>
}
    800013c4:	60e2                	ld	ra,24(sp)
    800013c6:	6442                	ld	s0,16(sp)
    800013c8:	64a2                	ld	s1,8(sp)
    800013ca:	6105                	addi	sp,sp,32
    800013cc:	8082                	ret

00000000800013ce <growproc>:
{
    800013ce:	1101                	addi	sp,sp,-32
    800013d0:	ec06                	sd	ra,24(sp)
    800013d2:	e822                	sd	s0,16(sp)
    800013d4:	e426                	sd	s1,8(sp)
    800013d6:	e04a                	sd	s2,0(sp)
    800013d8:	1000                	addi	s0,sp,32
    800013da:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800013dc:	00000097          	auipc	ra,0x0
    800013e0:	c0e080e7          	jalr	-1010(ra) # 80000fea <myproc>
    800013e4:	84aa                	mv	s1,a0
  sz = p->sz;
    800013e6:	652c                	ld	a1,72(a0)
  if (n > 0)
    800013e8:	01204c63          	bgtz	s2,80001400 <growproc+0x32>
  else if (n < 0)
    800013ec:	02094663          	bltz	s2,80001418 <growproc+0x4a>
  p->sz = sz;
    800013f0:	e4ac                	sd	a1,72(s1)
  return 0;
    800013f2:	4501                	li	a0,0
}
    800013f4:	60e2                	ld	ra,24(sp)
    800013f6:	6442                	ld	s0,16(sp)
    800013f8:	64a2                	ld	s1,8(sp)
    800013fa:	6902                	ld	s2,0(sp)
    800013fc:	6105                	addi	sp,sp,32
    800013fe:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80001400:	4691                	li	a3,4
    80001402:	00b90633          	add	a2,s2,a1
    80001406:	6928                	ld	a0,80(a0)
    80001408:	fffff097          	auipc	ra,0xfffff
    8000140c:	4dc080e7          	jalr	1244(ra) # 800008e4 <uvmalloc>
    80001410:	85aa                	mv	a1,a0
    80001412:	fd79                	bnez	a0,800013f0 <growproc+0x22>
      return -1;
    80001414:	557d                	li	a0,-1
    80001416:	bff9                	j	800013f4 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001418:	00b90633          	add	a2,s2,a1
    8000141c:	6928                	ld	a0,80(a0)
    8000141e:	fffff097          	auipc	ra,0xfffff
    80001422:	47e080e7          	jalr	1150(ra) # 8000089c <uvmdealloc>
    80001426:	85aa                	mv	a1,a0
    80001428:	b7e1                	j	800013f0 <growproc+0x22>

000000008000142a <fork>:
{
    8000142a:	7139                	addi	sp,sp,-64
    8000142c:	fc06                	sd	ra,56(sp)
    8000142e:	f822                	sd	s0,48(sp)
    80001430:	f04a                	sd	s2,32(sp)
    80001432:	e456                	sd	s5,8(sp)
    80001434:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001436:	00000097          	auipc	ra,0x0
    8000143a:	bb4080e7          	jalr	-1100(ra) # 80000fea <myproc>
    8000143e:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0)
    80001440:	00000097          	auipc	ra,0x0
    80001444:	e12080e7          	jalr	-494(ra) # 80001252 <allocproc>
    80001448:	12050063          	beqz	a0,80001568 <fork+0x13e>
    8000144c:	e852                	sd	s4,16(sp)
    8000144e:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80001450:	048ab603          	ld	a2,72(s5)
    80001454:	692c                	ld	a1,80(a0)
    80001456:	050ab503          	ld	a0,80(s5)
    8000145a:	fffff097          	auipc	ra,0xfffff
    8000145e:	5ee080e7          	jalr	1518(ra) # 80000a48 <uvmcopy>
    80001462:	04054a63          	bltz	a0,800014b6 <fork+0x8c>
    80001466:	f426                	sd	s1,40(sp)
    80001468:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    8000146a:	048ab783          	ld	a5,72(s5)
    8000146e:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001472:	058ab683          	ld	a3,88(s5)
    80001476:	87b6                	mv	a5,a3
    80001478:	058a3703          	ld	a4,88(s4)
    8000147c:	12068693          	addi	a3,a3,288
    80001480:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001484:	6788                	ld	a0,8(a5)
    80001486:	6b8c                	ld	a1,16(a5)
    80001488:	6f90                	ld	a2,24(a5)
    8000148a:	01073023          	sd	a6,0(a4)
    8000148e:	e708                	sd	a0,8(a4)
    80001490:	eb0c                	sd	a1,16(a4)
    80001492:	ef10                	sd	a2,24(a4)
    80001494:	02078793          	addi	a5,a5,32
    80001498:	02070713          	addi	a4,a4,32
    8000149c:	fed792e3          	bne	a5,a3,80001480 <fork+0x56>
  np->trapframe->a0 = 0;
    800014a0:	058a3783          	ld	a5,88(s4)
    800014a4:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    800014a8:	0d0a8493          	addi	s1,s5,208
    800014ac:	0d0a0913          	addi	s2,s4,208
    800014b0:	150a8993          	addi	s3,s5,336
    800014b4:	a015                	j	800014d8 <fork+0xae>
    freeproc(np);
    800014b6:	8552                	mv	a0,s4
    800014b8:	00000097          	auipc	ra,0x0
    800014bc:	d42080e7          	jalr	-702(ra) # 800011fa <freeproc>
    release(&np->lock);
    800014c0:	8552                	mv	a0,s4
    800014c2:	00005097          	auipc	ra,0x5
    800014c6:	12e080e7          	jalr	302(ra) # 800065f0 <release>
    return -1;
    800014ca:	597d                	li	s2,-1
    800014cc:	6a42                	ld	s4,16(sp)
    800014ce:	a071                	j	8000155a <fork+0x130>
  for (i = 0; i < NOFILE; i++)
    800014d0:	04a1                	addi	s1,s1,8
    800014d2:	0921                	addi	s2,s2,8
    800014d4:	01348b63          	beq	s1,s3,800014ea <fork+0xc0>
    if (p->ofile[i])
    800014d8:	6088                	ld	a0,0(s1)
    800014da:	d97d                	beqz	a0,800014d0 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    800014dc:	00002097          	auipc	ra,0x2
    800014e0:	748080e7          	jalr	1864(ra) # 80003c24 <filedup>
    800014e4:	00a93023          	sd	a0,0(s2)
    800014e8:	b7e5                	j	800014d0 <fork+0xa6>
  np->cwd = idup(p->cwd);
    800014ea:	150ab503          	ld	a0,336(s5)
    800014ee:	00002097          	auipc	ra,0x2
    800014f2:	8b2080e7          	jalr	-1870(ra) # 80002da0 <idup>
    800014f6:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800014fa:	4641                	li	a2,16
    800014fc:	158a8593          	addi	a1,s5,344
    80001500:	158a0513          	addi	a0,s4,344
    80001504:	fffff097          	auipc	ra,0xfffff
    80001508:	db8080e7          	jalr	-584(ra) # 800002bc <safestrcpy>
  pid = np->pid;
    8000150c:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001510:	8552                	mv	a0,s4
    80001512:	00005097          	auipc	ra,0x5
    80001516:	0de080e7          	jalr	222(ra) # 800065f0 <release>
  acquire(&wait_lock);
    8000151a:	0000a497          	auipc	s1,0xa
    8000151e:	e4e48493          	addi	s1,s1,-434 # 8000b368 <wait_lock>
    80001522:	8526                	mv	a0,s1
    80001524:	00005097          	auipc	ra,0x5
    80001528:	018080e7          	jalr	24(ra) # 8000653c <acquire>
  np->parent = p;
    8000152c:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001530:	8526                	mv	a0,s1
    80001532:	00005097          	auipc	ra,0x5
    80001536:	0be080e7          	jalr	190(ra) # 800065f0 <release>
  acquire(&np->lock);
    8000153a:	8552                	mv	a0,s4
    8000153c:	00005097          	auipc	ra,0x5
    80001540:	000080e7          	jalr	ra # 8000653c <acquire>
  np->state = RUNNABLE;
    80001544:	478d                	li	a5,3
    80001546:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000154a:	8552                	mv	a0,s4
    8000154c:	00005097          	auipc	ra,0x5
    80001550:	0a4080e7          	jalr	164(ra) # 800065f0 <release>
  return pid;
    80001554:	74a2                	ld	s1,40(sp)
    80001556:	69e2                	ld	s3,24(sp)
    80001558:	6a42                	ld	s4,16(sp)
}
    8000155a:	854a                	mv	a0,s2
    8000155c:	70e2                	ld	ra,56(sp)
    8000155e:	7442                	ld	s0,48(sp)
    80001560:	7902                	ld	s2,32(sp)
    80001562:	6aa2                	ld	s5,8(sp)
    80001564:	6121                	addi	sp,sp,64
    80001566:	8082                	ret
    return -1;
    80001568:	597d                	li	s2,-1
    8000156a:	bfc5                	j	8000155a <fork+0x130>

000000008000156c <scheduler>:
{
    8000156c:	7139                	addi	sp,sp,-64
    8000156e:	fc06                	sd	ra,56(sp)
    80001570:	f822                	sd	s0,48(sp)
    80001572:	f426                	sd	s1,40(sp)
    80001574:	f04a                	sd	s2,32(sp)
    80001576:	ec4e                	sd	s3,24(sp)
    80001578:	e852                	sd	s4,16(sp)
    8000157a:	e456                	sd	s5,8(sp)
    8000157c:	e05a                	sd	s6,0(sp)
    8000157e:	0080                	addi	s0,sp,64
    80001580:	8792                	mv	a5,tp
  int id = r_tp();
    80001582:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001584:	00779a93          	slli	s5,a5,0x7
    80001588:	0000a717          	auipc	a4,0xa
    8000158c:	dc870713          	addi	a4,a4,-568 # 8000b350 <pid_lock>
    80001590:	9756                	add	a4,a4,s5
    80001592:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001596:	0000a717          	auipc	a4,0xa
    8000159a:	df270713          	addi	a4,a4,-526 # 8000b388 <cpus+0x8>
    8000159e:	9aba                	add	s5,s5,a4
      if (p->state == RUNNABLE)
    800015a0:	498d                	li	s3,3
        p->state = RUNNING;
    800015a2:	4b11                	li	s6,4
        c->proc = p;
    800015a4:	079e                	slli	a5,a5,0x7
    800015a6:	0000aa17          	auipc	s4,0xa
    800015aa:	daaa0a13          	addi	s4,s4,-598 # 8000b350 <pid_lock>
    800015ae:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++)
    800015b0:	00010917          	auipc	s2,0x10
    800015b4:	dd090913          	addi	s2,s2,-560 # 80011380 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015b8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800015bc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800015c0:	10079073          	csrw	sstatus,a5
    800015c4:	0000a497          	auipc	s1,0xa
    800015c8:	1bc48493          	addi	s1,s1,444 # 8000b780 <proc>
    800015cc:	a811                	j	800015e0 <scheduler+0x74>
      release(&p->lock);
    800015ce:	8526                	mv	a0,s1
    800015d0:	00005097          	auipc	ra,0x5
    800015d4:	020080e7          	jalr	32(ra) # 800065f0 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800015d8:	17048493          	addi	s1,s1,368
    800015dc:	fd248ee3          	beq	s1,s2,800015b8 <scheduler+0x4c>
      acquire(&p->lock);
    800015e0:	8526                	mv	a0,s1
    800015e2:	00005097          	auipc	ra,0x5
    800015e6:	f5a080e7          	jalr	-166(ra) # 8000653c <acquire>
      if (p->state == RUNNABLE)
    800015ea:	4c9c                	lw	a5,24(s1)
    800015ec:	ff3791e3          	bne	a5,s3,800015ce <scheduler+0x62>
        p->state = RUNNING;
    800015f0:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800015f4:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800015f8:	06048593          	addi	a1,s1,96
    800015fc:	8556                	mv	a0,s5
    800015fe:	00000097          	auipc	ra,0x0
    80001602:	684080e7          	jalr	1668(ra) # 80001c82 <swtch>
        c->proc = 0;
    80001606:	020a3823          	sd	zero,48(s4)
    8000160a:	b7d1                	j	800015ce <scheduler+0x62>

000000008000160c <sched>:
{
    8000160c:	7179                	addi	sp,sp,-48
    8000160e:	f406                	sd	ra,40(sp)
    80001610:	f022                	sd	s0,32(sp)
    80001612:	ec26                	sd	s1,24(sp)
    80001614:	e84a                	sd	s2,16(sp)
    80001616:	e44e                	sd	s3,8(sp)
    80001618:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000161a:	00000097          	auipc	ra,0x0
    8000161e:	9d0080e7          	jalr	-1584(ra) # 80000fea <myproc>
    80001622:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80001624:	00005097          	auipc	ra,0x5
    80001628:	e9e080e7          	jalr	-354(ra) # 800064c2 <holding>
    8000162c:	c93d                	beqz	a0,800016a2 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000162e:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80001630:	2781                	sext.w	a5,a5
    80001632:	079e                	slli	a5,a5,0x7
    80001634:	0000a717          	auipc	a4,0xa
    80001638:	d1c70713          	addi	a4,a4,-740 # 8000b350 <pid_lock>
    8000163c:	97ba                	add	a5,a5,a4
    8000163e:	0a87a703          	lw	a4,168(a5)
    80001642:	4785                	li	a5,1
    80001644:	06f71763          	bne	a4,a5,800016b2 <sched+0xa6>
  if (p->state == RUNNING)
    80001648:	4c98                	lw	a4,24(s1)
    8000164a:	4791                	li	a5,4
    8000164c:	06f70b63          	beq	a4,a5,800016c2 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001650:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001654:	8b89                	andi	a5,a5,2
  if (intr_get())
    80001656:	efb5                	bnez	a5,800016d2 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001658:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000165a:	0000a917          	auipc	s2,0xa
    8000165e:	cf690913          	addi	s2,s2,-778 # 8000b350 <pid_lock>
    80001662:	2781                	sext.w	a5,a5
    80001664:	079e                	slli	a5,a5,0x7
    80001666:	97ca                	add	a5,a5,s2
    80001668:	0ac7a983          	lw	s3,172(a5)
    8000166c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000166e:	2781                	sext.w	a5,a5
    80001670:	079e                	slli	a5,a5,0x7
    80001672:	0000a597          	auipc	a1,0xa
    80001676:	d1658593          	addi	a1,a1,-746 # 8000b388 <cpus+0x8>
    8000167a:	95be                	add	a1,a1,a5
    8000167c:	06048513          	addi	a0,s1,96
    80001680:	00000097          	auipc	ra,0x0
    80001684:	602080e7          	jalr	1538(ra) # 80001c82 <swtch>
    80001688:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000168a:	2781                	sext.w	a5,a5
    8000168c:	079e                	slli	a5,a5,0x7
    8000168e:	993e                	add	s2,s2,a5
    80001690:	0b392623          	sw	s3,172(s2)
}
    80001694:	70a2                	ld	ra,40(sp)
    80001696:	7402                	ld	s0,32(sp)
    80001698:	64e2                	ld	s1,24(sp)
    8000169a:	6942                	ld	s2,16(sp)
    8000169c:	69a2                	ld	s3,8(sp)
    8000169e:	6145                	addi	sp,sp,48
    800016a0:	8082                	ret
    panic("sched p->lock");
    800016a2:	00007517          	auipc	a0,0x7
    800016a6:	b6650513          	addi	a0,a0,-1178 # 80008208 <etext+0x208>
    800016aa:	00005097          	auipc	ra,0x5
    800016ae:	918080e7          	jalr	-1768(ra) # 80005fc2 <panic>
    panic("sched locks");
    800016b2:	00007517          	auipc	a0,0x7
    800016b6:	b6650513          	addi	a0,a0,-1178 # 80008218 <etext+0x218>
    800016ba:	00005097          	auipc	ra,0x5
    800016be:	908080e7          	jalr	-1784(ra) # 80005fc2 <panic>
    panic("sched running");
    800016c2:	00007517          	auipc	a0,0x7
    800016c6:	b6650513          	addi	a0,a0,-1178 # 80008228 <etext+0x228>
    800016ca:	00005097          	auipc	ra,0x5
    800016ce:	8f8080e7          	jalr	-1800(ra) # 80005fc2 <panic>
    panic("sched interruptible");
    800016d2:	00007517          	auipc	a0,0x7
    800016d6:	b6650513          	addi	a0,a0,-1178 # 80008238 <etext+0x238>
    800016da:	00005097          	auipc	ra,0x5
    800016de:	8e8080e7          	jalr	-1816(ra) # 80005fc2 <panic>

00000000800016e2 <yield>:
{
    800016e2:	1101                	addi	sp,sp,-32
    800016e4:	ec06                	sd	ra,24(sp)
    800016e6:	e822                	sd	s0,16(sp)
    800016e8:	e426                	sd	s1,8(sp)
    800016ea:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800016ec:	00000097          	auipc	ra,0x0
    800016f0:	8fe080e7          	jalr	-1794(ra) # 80000fea <myproc>
    800016f4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800016f6:	00005097          	auipc	ra,0x5
    800016fa:	e46080e7          	jalr	-442(ra) # 8000653c <acquire>
  p->state = RUNNABLE;
    800016fe:	478d                	li	a5,3
    80001700:	cc9c                	sw	a5,24(s1)
  sched();
    80001702:	00000097          	auipc	ra,0x0
    80001706:	f0a080e7          	jalr	-246(ra) # 8000160c <sched>
  release(&p->lock);
    8000170a:	8526                	mv	a0,s1
    8000170c:	00005097          	auipc	ra,0x5
    80001710:	ee4080e7          	jalr	-284(ra) # 800065f0 <release>
}
    80001714:	60e2                	ld	ra,24(sp)
    80001716:	6442                	ld	s0,16(sp)
    80001718:	64a2                	ld	s1,8(sp)
    8000171a:	6105                	addi	sp,sp,32
    8000171c:	8082                	ret

000000008000171e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    8000171e:	7179                	addi	sp,sp,-48
    80001720:	f406                	sd	ra,40(sp)
    80001722:	f022                	sd	s0,32(sp)
    80001724:	ec26                	sd	s1,24(sp)
    80001726:	e84a                	sd	s2,16(sp)
    80001728:	e44e                	sd	s3,8(sp)
    8000172a:	1800                	addi	s0,sp,48
    8000172c:	89aa                	mv	s3,a0
    8000172e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001730:	00000097          	auipc	ra,0x0
    80001734:	8ba080e7          	jalr	-1862(ra) # 80000fea <myproc>
    80001738:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    8000173a:	00005097          	auipc	ra,0x5
    8000173e:	e02080e7          	jalr	-510(ra) # 8000653c <acquire>
  release(lk);
    80001742:	854a                	mv	a0,s2
    80001744:	00005097          	auipc	ra,0x5
    80001748:	eac080e7          	jalr	-340(ra) # 800065f0 <release>

  // Go to sleep.
  p->chan = chan;
    8000174c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001750:	4789                	li	a5,2
    80001752:	cc9c                	sw	a5,24(s1)

  sched();
    80001754:	00000097          	auipc	ra,0x0
    80001758:	eb8080e7          	jalr	-328(ra) # 8000160c <sched>

  // Tidy up.
  p->chan = 0;
    8000175c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001760:	8526                	mv	a0,s1
    80001762:	00005097          	auipc	ra,0x5
    80001766:	e8e080e7          	jalr	-370(ra) # 800065f0 <release>
  acquire(lk);
    8000176a:	854a                	mv	a0,s2
    8000176c:	00005097          	auipc	ra,0x5
    80001770:	dd0080e7          	jalr	-560(ra) # 8000653c <acquire>
}
    80001774:	70a2                	ld	ra,40(sp)
    80001776:	7402                	ld	s0,32(sp)
    80001778:	64e2                	ld	s1,24(sp)
    8000177a:	6942                	ld	s2,16(sp)
    8000177c:	69a2                	ld	s3,8(sp)
    8000177e:	6145                	addi	sp,sp,48
    80001780:	8082                	ret

0000000080001782 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    80001782:	7139                	addi	sp,sp,-64
    80001784:	fc06                	sd	ra,56(sp)
    80001786:	f822                	sd	s0,48(sp)
    80001788:	f426                	sd	s1,40(sp)
    8000178a:	f04a                	sd	s2,32(sp)
    8000178c:	ec4e                	sd	s3,24(sp)
    8000178e:	e852                	sd	s4,16(sp)
    80001790:	e456                	sd	s5,8(sp)
    80001792:	0080                	addi	s0,sp,64
    80001794:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80001796:	0000a497          	auipc	s1,0xa
    8000179a:	fea48493          	addi	s1,s1,-22 # 8000b780 <proc>
  {
    if (p != myproc())
    {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan)
    8000179e:	4989                	li	s3,2
      {
        p->state = RUNNABLE;
    800017a0:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++)
    800017a2:	00010917          	auipc	s2,0x10
    800017a6:	bde90913          	addi	s2,s2,-1058 # 80011380 <tickslock>
    800017aa:	a811                	j	800017be <wakeup+0x3c>
      }
      release(&p->lock);
    800017ac:	8526                	mv	a0,s1
    800017ae:	00005097          	auipc	ra,0x5
    800017b2:	e42080e7          	jalr	-446(ra) # 800065f0 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    800017b6:	17048493          	addi	s1,s1,368
    800017ba:	03248663          	beq	s1,s2,800017e6 <wakeup+0x64>
    if (p != myproc())
    800017be:	00000097          	auipc	ra,0x0
    800017c2:	82c080e7          	jalr	-2004(ra) # 80000fea <myproc>
    800017c6:	fea488e3          	beq	s1,a0,800017b6 <wakeup+0x34>
      acquire(&p->lock);
    800017ca:	8526                	mv	a0,s1
    800017cc:	00005097          	auipc	ra,0x5
    800017d0:	d70080e7          	jalr	-656(ra) # 8000653c <acquire>
      if (p->state == SLEEPING && p->chan == chan)
    800017d4:	4c9c                	lw	a5,24(s1)
    800017d6:	fd379be3          	bne	a5,s3,800017ac <wakeup+0x2a>
    800017da:	709c                	ld	a5,32(s1)
    800017dc:	fd4798e3          	bne	a5,s4,800017ac <wakeup+0x2a>
        p->state = RUNNABLE;
    800017e0:	0154ac23          	sw	s5,24(s1)
    800017e4:	b7e1                	j	800017ac <wakeup+0x2a>
    }
  }
}
    800017e6:	70e2                	ld	ra,56(sp)
    800017e8:	7442                	ld	s0,48(sp)
    800017ea:	74a2                	ld	s1,40(sp)
    800017ec:	7902                	ld	s2,32(sp)
    800017ee:	69e2                	ld	s3,24(sp)
    800017f0:	6a42                	ld	s4,16(sp)
    800017f2:	6aa2                	ld	s5,8(sp)
    800017f4:	6121                	addi	sp,sp,64
    800017f6:	8082                	ret

00000000800017f8 <reparent>:
{
    800017f8:	7179                	addi	sp,sp,-48
    800017fa:	f406                	sd	ra,40(sp)
    800017fc:	f022                	sd	s0,32(sp)
    800017fe:	ec26                	sd	s1,24(sp)
    80001800:	e84a                	sd	s2,16(sp)
    80001802:	e44e                	sd	s3,8(sp)
    80001804:	e052                	sd	s4,0(sp)
    80001806:	1800                	addi	s0,sp,48
    80001808:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++)
    8000180a:	0000a497          	auipc	s1,0xa
    8000180e:	f7648493          	addi	s1,s1,-138 # 8000b780 <proc>
      pp->parent = initproc;
    80001812:	0000aa17          	auipc	s4,0xa
    80001816:	afea0a13          	addi	s4,s4,-1282 # 8000b310 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++)
    8000181a:	00010997          	auipc	s3,0x10
    8000181e:	b6698993          	addi	s3,s3,-1178 # 80011380 <tickslock>
    80001822:	a029                	j	8000182c <reparent+0x34>
    80001824:	17048493          	addi	s1,s1,368
    80001828:	01348d63          	beq	s1,s3,80001842 <reparent+0x4a>
    if (pp->parent == p)
    8000182c:	7c9c                	ld	a5,56(s1)
    8000182e:	ff279be3          	bne	a5,s2,80001824 <reparent+0x2c>
      pp->parent = initproc;
    80001832:	000a3503          	ld	a0,0(s4)
    80001836:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001838:	00000097          	auipc	ra,0x0
    8000183c:	f4a080e7          	jalr	-182(ra) # 80001782 <wakeup>
    80001840:	b7d5                	j	80001824 <reparent+0x2c>
}
    80001842:	70a2                	ld	ra,40(sp)
    80001844:	7402                	ld	s0,32(sp)
    80001846:	64e2                	ld	s1,24(sp)
    80001848:	6942                	ld	s2,16(sp)
    8000184a:	69a2                	ld	s3,8(sp)
    8000184c:	6a02                	ld	s4,0(sp)
    8000184e:	6145                	addi	sp,sp,48
    80001850:	8082                	ret

0000000080001852 <exit>:
{
    80001852:	7179                	addi	sp,sp,-48
    80001854:	f406                	sd	ra,40(sp)
    80001856:	f022                	sd	s0,32(sp)
    80001858:	ec26                	sd	s1,24(sp)
    8000185a:	e84a                	sd	s2,16(sp)
    8000185c:	e44e                	sd	s3,8(sp)
    8000185e:	e052                	sd	s4,0(sp)
    80001860:	1800                	addi	s0,sp,48
    80001862:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001864:	fffff097          	auipc	ra,0xfffff
    80001868:	786080e7          	jalr	1926(ra) # 80000fea <myproc>
    8000186c:	89aa                	mv	s3,a0
  if (p == initproc)
    8000186e:	0000a797          	auipc	a5,0xa
    80001872:	aa27b783          	ld	a5,-1374(a5) # 8000b310 <initproc>
    80001876:	0d050493          	addi	s1,a0,208
    8000187a:	15050913          	addi	s2,a0,336
    8000187e:	02a79363          	bne	a5,a0,800018a4 <exit+0x52>
    panic("init exiting");
    80001882:	00007517          	auipc	a0,0x7
    80001886:	9ce50513          	addi	a0,a0,-1586 # 80008250 <etext+0x250>
    8000188a:	00004097          	auipc	ra,0x4
    8000188e:	738080e7          	jalr	1848(ra) # 80005fc2 <panic>
      fileclose(f);
    80001892:	00002097          	auipc	ra,0x2
    80001896:	3e4080e7          	jalr	996(ra) # 80003c76 <fileclose>
      p->ofile[fd] = 0;
    8000189a:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++)
    8000189e:	04a1                	addi	s1,s1,8
    800018a0:	01248563          	beq	s1,s2,800018aa <exit+0x58>
    if (p->ofile[fd])
    800018a4:	6088                	ld	a0,0(s1)
    800018a6:	f575                	bnez	a0,80001892 <exit+0x40>
    800018a8:	bfdd                	j	8000189e <exit+0x4c>
  begin_op();
    800018aa:	00002097          	auipc	ra,0x2
    800018ae:	f02080e7          	jalr	-254(ra) # 800037ac <begin_op>
  iput(p->cwd);
    800018b2:	1509b503          	ld	a0,336(s3)
    800018b6:	00001097          	auipc	ra,0x1
    800018ba:	6e6080e7          	jalr	1766(ra) # 80002f9c <iput>
  end_op();
    800018be:	00002097          	auipc	ra,0x2
    800018c2:	f68080e7          	jalr	-152(ra) # 80003826 <end_op>
  p->cwd = 0;
    800018c6:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800018ca:	0000a497          	auipc	s1,0xa
    800018ce:	a9e48493          	addi	s1,s1,-1378 # 8000b368 <wait_lock>
    800018d2:	8526                	mv	a0,s1
    800018d4:	00005097          	auipc	ra,0x5
    800018d8:	c68080e7          	jalr	-920(ra) # 8000653c <acquire>
  reparent(p);
    800018dc:	854e                	mv	a0,s3
    800018de:	00000097          	auipc	ra,0x0
    800018e2:	f1a080e7          	jalr	-230(ra) # 800017f8 <reparent>
  wakeup(p->parent);
    800018e6:	0389b503          	ld	a0,56(s3)
    800018ea:	00000097          	auipc	ra,0x0
    800018ee:	e98080e7          	jalr	-360(ra) # 80001782 <wakeup>
  acquire(&p->lock);
    800018f2:	854e                	mv	a0,s3
    800018f4:	00005097          	auipc	ra,0x5
    800018f8:	c48080e7          	jalr	-952(ra) # 8000653c <acquire>
  p->xstate = status;
    800018fc:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001900:	4795                	li	a5,5
    80001902:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001906:	8526                	mv	a0,s1
    80001908:	00005097          	auipc	ra,0x5
    8000190c:	ce8080e7          	jalr	-792(ra) # 800065f0 <release>
  sched();
    80001910:	00000097          	auipc	ra,0x0
    80001914:	cfc080e7          	jalr	-772(ra) # 8000160c <sched>
  panic("zombie exit");
    80001918:	00007517          	auipc	a0,0x7
    8000191c:	94850513          	addi	a0,a0,-1720 # 80008260 <etext+0x260>
    80001920:	00004097          	auipc	ra,0x4
    80001924:	6a2080e7          	jalr	1698(ra) # 80005fc2 <panic>

0000000080001928 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80001928:	7179                	addi	sp,sp,-48
    8000192a:	f406                	sd	ra,40(sp)
    8000192c:	f022                	sd	s0,32(sp)
    8000192e:	ec26                	sd	s1,24(sp)
    80001930:	e84a                	sd	s2,16(sp)
    80001932:	e44e                	sd	s3,8(sp)
    80001934:	1800                	addi	s0,sp,48
    80001936:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80001938:	0000a497          	auipc	s1,0xa
    8000193c:	e4848493          	addi	s1,s1,-440 # 8000b780 <proc>
    80001940:	00010997          	auipc	s3,0x10
    80001944:	a4098993          	addi	s3,s3,-1472 # 80011380 <tickslock>
  {
    acquire(&p->lock);
    80001948:	8526                	mv	a0,s1
    8000194a:	00005097          	auipc	ra,0x5
    8000194e:	bf2080e7          	jalr	-1038(ra) # 8000653c <acquire>
    if (p->pid == pid)
    80001952:	589c                	lw	a5,48(s1)
    80001954:	01278d63          	beq	a5,s2,8000196e <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001958:	8526                	mv	a0,s1
    8000195a:	00005097          	auipc	ra,0x5
    8000195e:	c96080e7          	jalr	-874(ra) # 800065f0 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001962:	17048493          	addi	s1,s1,368
    80001966:	ff3491e3          	bne	s1,s3,80001948 <kill+0x20>
  }
  return -1;
    8000196a:	557d                	li	a0,-1
    8000196c:	a829                	j	80001986 <kill+0x5e>
      p->killed = 1;
    8000196e:	4785                	li	a5,1
    80001970:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING)
    80001972:	4c98                	lw	a4,24(s1)
    80001974:	4789                	li	a5,2
    80001976:	00f70f63          	beq	a4,a5,80001994 <kill+0x6c>
      release(&p->lock);
    8000197a:	8526                	mv	a0,s1
    8000197c:	00005097          	auipc	ra,0x5
    80001980:	c74080e7          	jalr	-908(ra) # 800065f0 <release>
      return 0;
    80001984:	4501                	li	a0,0
}
    80001986:	70a2                	ld	ra,40(sp)
    80001988:	7402                	ld	s0,32(sp)
    8000198a:	64e2                	ld	s1,24(sp)
    8000198c:	6942                	ld	s2,16(sp)
    8000198e:	69a2                	ld	s3,8(sp)
    80001990:	6145                	addi	sp,sp,48
    80001992:	8082                	ret
        p->state = RUNNABLE;
    80001994:	478d                	li	a5,3
    80001996:	cc9c                	sw	a5,24(s1)
    80001998:	b7cd                	j	8000197a <kill+0x52>

000000008000199a <setkilled>:

void setkilled(struct proc *p)
{
    8000199a:	1101                	addi	sp,sp,-32
    8000199c:	ec06                	sd	ra,24(sp)
    8000199e:	e822                	sd	s0,16(sp)
    800019a0:	e426                	sd	s1,8(sp)
    800019a2:	1000                	addi	s0,sp,32
    800019a4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800019a6:	00005097          	auipc	ra,0x5
    800019aa:	b96080e7          	jalr	-1130(ra) # 8000653c <acquire>
  p->killed = 1;
    800019ae:	4785                	li	a5,1
    800019b0:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800019b2:	8526                	mv	a0,s1
    800019b4:	00005097          	auipc	ra,0x5
    800019b8:	c3c080e7          	jalr	-964(ra) # 800065f0 <release>
}
    800019bc:	60e2                	ld	ra,24(sp)
    800019be:	6442                	ld	s0,16(sp)
    800019c0:	64a2                	ld	s1,8(sp)
    800019c2:	6105                	addi	sp,sp,32
    800019c4:	8082                	ret

00000000800019c6 <killed>:

int killed(struct proc *p)
{
    800019c6:	1101                	addi	sp,sp,-32
    800019c8:	ec06                	sd	ra,24(sp)
    800019ca:	e822                	sd	s0,16(sp)
    800019cc:	e426                	sd	s1,8(sp)
    800019ce:	e04a                	sd	s2,0(sp)
    800019d0:	1000                	addi	s0,sp,32
    800019d2:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    800019d4:	00005097          	auipc	ra,0x5
    800019d8:	b68080e7          	jalr	-1176(ra) # 8000653c <acquire>
  k = p->killed;
    800019dc:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800019e0:	8526                	mv	a0,s1
    800019e2:	00005097          	auipc	ra,0x5
    800019e6:	c0e080e7          	jalr	-1010(ra) # 800065f0 <release>
  return k;
}
    800019ea:	854a                	mv	a0,s2
    800019ec:	60e2                	ld	ra,24(sp)
    800019ee:	6442                	ld	s0,16(sp)
    800019f0:	64a2                	ld	s1,8(sp)
    800019f2:	6902                	ld	s2,0(sp)
    800019f4:	6105                	addi	sp,sp,32
    800019f6:	8082                	ret

00000000800019f8 <wait>:
{
    800019f8:	715d                	addi	sp,sp,-80
    800019fa:	e486                	sd	ra,72(sp)
    800019fc:	e0a2                	sd	s0,64(sp)
    800019fe:	fc26                	sd	s1,56(sp)
    80001a00:	f84a                	sd	s2,48(sp)
    80001a02:	f44e                	sd	s3,40(sp)
    80001a04:	f052                	sd	s4,32(sp)
    80001a06:	ec56                	sd	s5,24(sp)
    80001a08:	e85a                	sd	s6,16(sp)
    80001a0a:	e45e                	sd	s7,8(sp)
    80001a0c:	e062                	sd	s8,0(sp)
    80001a0e:	0880                	addi	s0,sp,80
    80001a10:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001a12:	fffff097          	auipc	ra,0xfffff
    80001a16:	5d8080e7          	jalr	1496(ra) # 80000fea <myproc>
    80001a1a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001a1c:	0000a517          	auipc	a0,0xa
    80001a20:	94c50513          	addi	a0,a0,-1716 # 8000b368 <wait_lock>
    80001a24:	00005097          	auipc	ra,0x5
    80001a28:	b18080e7          	jalr	-1256(ra) # 8000653c <acquire>
    havekids = 0;
    80001a2c:	4b81                	li	s7,0
        if (pp->state == ZOMBIE)
    80001a2e:	4a15                	li	s4,5
        havekids = 1;
    80001a30:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80001a32:	00010997          	auipc	s3,0x10
    80001a36:	94e98993          	addi	s3,s3,-1714 # 80011380 <tickslock>
    sleep(p, &wait_lock); // DOC: wait-sleep
    80001a3a:	0000ac17          	auipc	s8,0xa
    80001a3e:	92ec0c13          	addi	s8,s8,-1746 # 8000b368 <wait_lock>
    80001a42:	a0d1                	j	80001b06 <wait+0x10e>
          pid = pp->pid;
    80001a44:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001a48:	000b0e63          	beqz	s6,80001a64 <wait+0x6c>
    80001a4c:	4691                	li	a3,4
    80001a4e:	02c48613          	addi	a2,s1,44
    80001a52:	85da                	mv	a1,s6
    80001a54:	05093503          	ld	a0,80(s2)
    80001a58:	fffff097          	auipc	ra,0xfffff
    80001a5c:	0f4080e7          	jalr	244(ra) # 80000b4c <copyout>
    80001a60:	04054163          	bltz	a0,80001aa2 <wait+0xaa>
          freeproc(pp);
    80001a64:	8526                	mv	a0,s1
    80001a66:	fffff097          	auipc	ra,0xfffff
    80001a6a:	794080e7          	jalr	1940(ra) # 800011fa <freeproc>
          release(&pp->lock);
    80001a6e:	8526                	mv	a0,s1
    80001a70:	00005097          	auipc	ra,0x5
    80001a74:	b80080e7          	jalr	-1152(ra) # 800065f0 <release>
          release(&wait_lock);
    80001a78:	0000a517          	auipc	a0,0xa
    80001a7c:	8f050513          	addi	a0,a0,-1808 # 8000b368 <wait_lock>
    80001a80:	00005097          	auipc	ra,0x5
    80001a84:	b70080e7          	jalr	-1168(ra) # 800065f0 <release>
}
    80001a88:	854e                	mv	a0,s3
    80001a8a:	60a6                	ld	ra,72(sp)
    80001a8c:	6406                	ld	s0,64(sp)
    80001a8e:	74e2                	ld	s1,56(sp)
    80001a90:	7942                	ld	s2,48(sp)
    80001a92:	79a2                	ld	s3,40(sp)
    80001a94:	7a02                	ld	s4,32(sp)
    80001a96:	6ae2                	ld	s5,24(sp)
    80001a98:	6b42                	ld	s6,16(sp)
    80001a9a:	6ba2                	ld	s7,8(sp)
    80001a9c:	6c02                	ld	s8,0(sp)
    80001a9e:	6161                	addi	sp,sp,80
    80001aa0:	8082                	ret
            release(&pp->lock);
    80001aa2:	8526                	mv	a0,s1
    80001aa4:	00005097          	auipc	ra,0x5
    80001aa8:	b4c080e7          	jalr	-1204(ra) # 800065f0 <release>
            release(&wait_lock);
    80001aac:	0000a517          	auipc	a0,0xa
    80001ab0:	8bc50513          	addi	a0,a0,-1860 # 8000b368 <wait_lock>
    80001ab4:	00005097          	auipc	ra,0x5
    80001ab8:	b3c080e7          	jalr	-1220(ra) # 800065f0 <release>
            return -1;
    80001abc:	59fd                	li	s3,-1
    80001abe:	b7e9                	j	80001a88 <wait+0x90>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80001ac0:	17048493          	addi	s1,s1,368
    80001ac4:	03348463          	beq	s1,s3,80001aec <wait+0xf4>
      if (pp->parent == p)
    80001ac8:	7c9c                	ld	a5,56(s1)
    80001aca:	ff279be3          	bne	a5,s2,80001ac0 <wait+0xc8>
        acquire(&pp->lock);
    80001ace:	8526                	mv	a0,s1
    80001ad0:	00005097          	auipc	ra,0x5
    80001ad4:	a6c080e7          	jalr	-1428(ra) # 8000653c <acquire>
        if (pp->state == ZOMBIE)
    80001ad8:	4c9c                	lw	a5,24(s1)
    80001ada:	f74785e3          	beq	a5,s4,80001a44 <wait+0x4c>
        release(&pp->lock);
    80001ade:	8526                	mv	a0,s1
    80001ae0:	00005097          	auipc	ra,0x5
    80001ae4:	b10080e7          	jalr	-1264(ra) # 800065f0 <release>
        havekids = 1;
    80001ae8:	8756                	mv	a4,s5
    80001aea:	bfd9                	j	80001ac0 <wait+0xc8>
    if (!havekids || killed(p))
    80001aec:	c31d                	beqz	a4,80001b12 <wait+0x11a>
    80001aee:	854a                	mv	a0,s2
    80001af0:	00000097          	auipc	ra,0x0
    80001af4:	ed6080e7          	jalr	-298(ra) # 800019c6 <killed>
    80001af8:	ed09                	bnez	a0,80001b12 <wait+0x11a>
    sleep(p, &wait_lock); // DOC: wait-sleep
    80001afa:	85e2                	mv	a1,s8
    80001afc:	854a                	mv	a0,s2
    80001afe:	00000097          	auipc	ra,0x0
    80001b02:	c20080e7          	jalr	-992(ra) # 8000171e <sleep>
    havekids = 0;
    80001b06:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80001b08:	0000a497          	auipc	s1,0xa
    80001b0c:	c7848493          	addi	s1,s1,-904 # 8000b780 <proc>
    80001b10:	bf65                	j	80001ac8 <wait+0xd0>
      release(&wait_lock);
    80001b12:	0000a517          	auipc	a0,0xa
    80001b16:	85650513          	addi	a0,a0,-1962 # 8000b368 <wait_lock>
    80001b1a:	00005097          	auipc	ra,0x5
    80001b1e:	ad6080e7          	jalr	-1322(ra) # 800065f0 <release>
      return -1;
    80001b22:	59fd                	li	s3,-1
    80001b24:	b795                	j	80001a88 <wait+0x90>

0000000080001b26 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001b26:	7179                	addi	sp,sp,-48
    80001b28:	f406                	sd	ra,40(sp)
    80001b2a:	f022                	sd	s0,32(sp)
    80001b2c:	ec26                	sd	s1,24(sp)
    80001b2e:	e84a                	sd	s2,16(sp)
    80001b30:	e44e                	sd	s3,8(sp)
    80001b32:	e052                	sd	s4,0(sp)
    80001b34:	1800                	addi	s0,sp,48
    80001b36:	84aa                	mv	s1,a0
    80001b38:	892e                	mv	s2,a1
    80001b3a:	89b2                	mv	s3,a2
    80001b3c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b3e:	fffff097          	auipc	ra,0xfffff
    80001b42:	4ac080e7          	jalr	1196(ra) # 80000fea <myproc>
  if (user_dst)
    80001b46:	c08d                	beqz	s1,80001b68 <either_copyout+0x42>
  {
    return copyout(p->pagetable, dst, src, len);
    80001b48:	86d2                	mv	a3,s4
    80001b4a:	864e                	mv	a2,s3
    80001b4c:	85ca                	mv	a1,s2
    80001b4e:	6928                	ld	a0,80(a0)
    80001b50:	fffff097          	auipc	ra,0xfffff
    80001b54:	ffc080e7          	jalr	-4(ra) # 80000b4c <copyout>
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001b58:	70a2                	ld	ra,40(sp)
    80001b5a:	7402                	ld	s0,32(sp)
    80001b5c:	64e2                	ld	s1,24(sp)
    80001b5e:	6942                	ld	s2,16(sp)
    80001b60:	69a2                	ld	s3,8(sp)
    80001b62:	6a02                	ld	s4,0(sp)
    80001b64:	6145                	addi	sp,sp,48
    80001b66:	8082                	ret
    memmove((char *)dst, src, len);
    80001b68:	000a061b          	sext.w	a2,s4
    80001b6c:	85ce                	mv	a1,s3
    80001b6e:	854a                	mv	a0,s2
    80001b70:	ffffe097          	auipc	ra,0xffffe
    80001b74:	666080e7          	jalr	1638(ra) # 800001d6 <memmove>
    return 0;
    80001b78:	8526                	mv	a0,s1
    80001b7a:	bff9                	j	80001b58 <either_copyout+0x32>

0000000080001b7c <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b7c:	7179                	addi	sp,sp,-48
    80001b7e:	f406                	sd	ra,40(sp)
    80001b80:	f022                	sd	s0,32(sp)
    80001b82:	ec26                	sd	s1,24(sp)
    80001b84:	e84a                	sd	s2,16(sp)
    80001b86:	e44e                	sd	s3,8(sp)
    80001b88:	e052                	sd	s4,0(sp)
    80001b8a:	1800                	addi	s0,sp,48
    80001b8c:	892a                	mv	s2,a0
    80001b8e:	84ae                	mv	s1,a1
    80001b90:	89b2                	mv	s3,a2
    80001b92:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b94:	fffff097          	auipc	ra,0xfffff
    80001b98:	456080e7          	jalr	1110(ra) # 80000fea <myproc>
  if (user_src)
    80001b9c:	c08d                	beqz	s1,80001bbe <either_copyin+0x42>
  {
    return copyin(p->pagetable, dst, src, len);
    80001b9e:	86d2                	mv	a3,s4
    80001ba0:	864e                	mv	a2,s3
    80001ba2:	85ca                	mv	a1,s2
    80001ba4:	6928                	ld	a0,80(a0)
    80001ba6:	fffff097          	auipc	ra,0xfffff
    80001baa:	084080e7          	jalr	132(ra) # 80000c2a <copyin>
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80001bae:	70a2                	ld	ra,40(sp)
    80001bb0:	7402                	ld	s0,32(sp)
    80001bb2:	64e2                	ld	s1,24(sp)
    80001bb4:	6942                	ld	s2,16(sp)
    80001bb6:	69a2                	ld	s3,8(sp)
    80001bb8:	6a02                	ld	s4,0(sp)
    80001bba:	6145                	addi	sp,sp,48
    80001bbc:	8082                	ret
    memmove(dst, (char *)src, len);
    80001bbe:	000a061b          	sext.w	a2,s4
    80001bc2:	85ce                	mv	a1,s3
    80001bc4:	854a                	mv	a0,s2
    80001bc6:	ffffe097          	auipc	ra,0xffffe
    80001bca:	610080e7          	jalr	1552(ra) # 800001d6 <memmove>
    return 0;
    80001bce:	8526                	mv	a0,s1
    80001bd0:	bff9                	j	80001bae <either_copyin+0x32>

0000000080001bd2 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80001bd2:	715d                	addi	sp,sp,-80
    80001bd4:	e486                	sd	ra,72(sp)
    80001bd6:	e0a2                	sd	s0,64(sp)
    80001bd8:	fc26                	sd	s1,56(sp)
    80001bda:	f84a                	sd	s2,48(sp)
    80001bdc:	f44e                	sd	s3,40(sp)
    80001bde:	f052                	sd	s4,32(sp)
    80001be0:	ec56                	sd	s5,24(sp)
    80001be2:	e85a                	sd	s6,16(sp)
    80001be4:	e45e                	sd	s7,8(sp)
    80001be6:	0880                	addi	s0,sp,80
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    80001be8:	00006517          	auipc	a0,0x6
    80001bec:	43050513          	addi	a0,a0,1072 # 80008018 <etext+0x18>
    80001bf0:	00004097          	auipc	ra,0x4
    80001bf4:	41c080e7          	jalr	1052(ra) # 8000600c <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80001bf8:	0000a497          	auipc	s1,0xa
    80001bfc:	ce048493          	addi	s1,s1,-800 # 8000b8d8 <proc+0x158>
    80001c00:	00010917          	auipc	s2,0x10
    80001c04:	8d890913          	addi	s2,s2,-1832 # 800114d8 <bcache+0x140>
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c08:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001c0a:	00006997          	auipc	s3,0x6
    80001c0e:	66698993          	addi	s3,s3,1638 # 80008270 <etext+0x270>
    printf("%d %s %s", p->pid, state, p->name);
    80001c12:	00006a97          	auipc	s5,0x6
    80001c16:	666a8a93          	addi	s5,s5,1638 # 80008278 <etext+0x278>
    printf("\n");
    80001c1a:	00006a17          	auipc	s4,0x6
    80001c1e:	3fea0a13          	addi	s4,s4,1022 # 80008018 <etext+0x18>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c22:	00007b97          	auipc	s7,0x7
    80001c26:	b7eb8b93          	addi	s7,s7,-1154 # 800087a0 <states.0>
    80001c2a:	a00d                	j	80001c4c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001c2c:	ed86a583          	lw	a1,-296(a3)
    80001c30:	8556                	mv	a0,s5
    80001c32:	00004097          	auipc	ra,0x4
    80001c36:	3da080e7          	jalr	986(ra) # 8000600c <printf>
    printf("\n");
    80001c3a:	8552                	mv	a0,s4
    80001c3c:	00004097          	auipc	ra,0x4
    80001c40:	3d0080e7          	jalr	976(ra) # 8000600c <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80001c44:	17048493          	addi	s1,s1,368
    80001c48:	03248263          	beq	s1,s2,80001c6c <procdump+0x9a>
    if (p->state == UNUSED)
    80001c4c:	86a6                	mv	a3,s1
    80001c4e:	ec04a783          	lw	a5,-320(s1)
    80001c52:	dbed                	beqz	a5,80001c44 <procdump+0x72>
      state = "???";
    80001c54:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c56:	fcfb6be3          	bltu	s6,a5,80001c2c <procdump+0x5a>
    80001c5a:	02079713          	slli	a4,a5,0x20
    80001c5e:	01d75793          	srli	a5,a4,0x1d
    80001c62:	97de                	add	a5,a5,s7
    80001c64:	6390                	ld	a2,0(a5)
    80001c66:	f279                	bnez	a2,80001c2c <procdump+0x5a>
      state = "???";
    80001c68:	864e                	mv	a2,s3
    80001c6a:	b7c9                	j	80001c2c <procdump+0x5a>
  }
}
    80001c6c:	60a6                	ld	ra,72(sp)
    80001c6e:	6406                	ld	s0,64(sp)
    80001c70:	74e2                	ld	s1,56(sp)
    80001c72:	7942                	ld	s2,48(sp)
    80001c74:	79a2                	ld	s3,40(sp)
    80001c76:	7a02                	ld	s4,32(sp)
    80001c78:	6ae2                	ld	s5,24(sp)
    80001c7a:	6b42                	ld	s6,16(sp)
    80001c7c:	6ba2                	ld	s7,8(sp)
    80001c7e:	6161                	addi	sp,sp,80
    80001c80:	8082                	ret

0000000080001c82 <swtch>:
    80001c82:	00153023          	sd	ra,0(a0)
    80001c86:	00253423          	sd	sp,8(a0)
    80001c8a:	e900                	sd	s0,16(a0)
    80001c8c:	ed04                	sd	s1,24(a0)
    80001c8e:	03253023          	sd	s2,32(a0)
    80001c92:	03353423          	sd	s3,40(a0)
    80001c96:	03453823          	sd	s4,48(a0)
    80001c9a:	03553c23          	sd	s5,56(a0)
    80001c9e:	05653023          	sd	s6,64(a0)
    80001ca2:	05753423          	sd	s7,72(a0)
    80001ca6:	05853823          	sd	s8,80(a0)
    80001caa:	05953c23          	sd	s9,88(a0)
    80001cae:	07a53023          	sd	s10,96(a0)
    80001cb2:	07b53423          	sd	s11,104(a0)
    80001cb6:	0005b083          	ld	ra,0(a1)
    80001cba:	0085b103          	ld	sp,8(a1)
    80001cbe:	6980                	ld	s0,16(a1)
    80001cc0:	6d84                	ld	s1,24(a1)
    80001cc2:	0205b903          	ld	s2,32(a1)
    80001cc6:	0285b983          	ld	s3,40(a1)
    80001cca:	0305ba03          	ld	s4,48(a1)
    80001cce:	0385ba83          	ld	s5,56(a1)
    80001cd2:	0405bb03          	ld	s6,64(a1)
    80001cd6:	0485bb83          	ld	s7,72(a1)
    80001cda:	0505bc03          	ld	s8,80(a1)
    80001cde:	0585bc83          	ld	s9,88(a1)
    80001ce2:	0605bd03          	ld	s10,96(a1)
    80001ce6:	0685bd83          	ld	s11,104(a1)
    80001cea:	8082                	ret

0000000080001cec <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001cec:	1141                	addi	sp,sp,-16
    80001cee:	e406                	sd	ra,8(sp)
    80001cf0:	e022                	sd	s0,0(sp)
    80001cf2:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001cf4:	00006597          	auipc	a1,0x6
    80001cf8:	5c458593          	addi	a1,a1,1476 # 800082b8 <etext+0x2b8>
    80001cfc:	0000f517          	auipc	a0,0xf
    80001d00:	68450513          	addi	a0,a0,1668 # 80011380 <tickslock>
    80001d04:	00004097          	auipc	ra,0x4
    80001d08:	7a8080e7          	jalr	1960(ra) # 800064ac <initlock>
}
    80001d0c:	60a2                	ld	ra,8(sp)
    80001d0e:	6402                	ld	s0,0(sp)
    80001d10:	0141                	addi	sp,sp,16
    80001d12:	8082                	ret

0000000080001d14 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001d14:	1141                	addi	sp,sp,-16
    80001d16:	e422                	sd	s0,8(sp)
    80001d18:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d1a:	00003797          	auipc	a5,0x3
    80001d1e:	67678793          	addi	a5,a5,1654 # 80005390 <kernelvec>
    80001d22:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001d26:	6422                	ld	s0,8(sp)
    80001d28:	0141                	addi	sp,sp,16
    80001d2a:	8082                	ret

0000000080001d2c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001d2c:	1141                	addi	sp,sp,-16
    80001d2e:	e406                	sd	ra,8(sp)
    80001d30:	e022                	sd	s0,0(sp)
    80001d32:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001d34:	fffff097          	auipc	ra,0xfffff
    80001d38:	2b6080e7          	jalr	694(ra) # 80000fea <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d3c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001d40:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d42:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001d46:	00005697          	auipc	a3,0x5
    80001d4a:	2ba68693          	addi	a3,a3,698 # 80007000 <_trampoline>
    80001d4e:	00005717          	auipc	a4,0x5
    80001d52:	2b270713          	addi	a4,a4,690 # 80007000 <_trampoline>
    80001d56:	8f15                	sub	a4,a4,a3
    80001d58:	040007b7          	lui	a5,0x4000
    80001d5c:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001d5e:	07b2                	slli	a5,a5,0xc
    80001d60:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d62:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d66:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d68:	18002673          	csrr	a2,satp
    80001d6c:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d6e:	6d30                	ld	a2,88(a0)
    80001d70:	6138                	ld	a4,64(a0)
    80001d72:	6585                	lui	a1,0x1
    80001d74:	972e                	add	a4,a4,a1
    80001d76:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d78:	6d38                	ld	a4,88(a0)
    80001d7a:	00000617          	auipc	a2,0x0
    80001d7e:	13860613          	addi	a2,a2,312 # 80001eb2 <usertrap>
    80001d82:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d84:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d86:	8612                	mv	a2,tp
    80001d88:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d8a:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d8e:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d92:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d96:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d9a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d9c:	6f18                	ld	a4,24(a4)
    80001d9e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001da2:	6928                	ld	a0,80(a0)
    80001da4:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001da6:	00005717          	auipc	a4,0x5
    80001daa:	2f670713          	addi	a4,a4,758 # 8000709c <userret>
    80001dae:	8f15                	sub	a4,a4,a3
    80001db0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001db2:	577d                	li	a4,-1
    80001db4:	177e                	slli	a4,a4,0x3f
    80001db6:	8d59                	or	a0,a0,a4
    80001db8:	9782                	jalr	a5
}
    80001dba:	60a2                	ld	ra,8(sp)
    80001dbc:	6402                	ld	s0,0(sp)
    80001dbe:	0141                	addi	sp,sp,16
    80001dc0:	8082                	ret

0000000080001dc2 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001dc2:	1101                	addi	sp,sp,-32
    80001dc4:	ec06                	sd	ra,24(sp)
    80001dc6:	e822                	sd	s0,16(sp)
    80001dc8:	e426                	sd	s1,8(sp)
    80001dca:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001dcc:	0000f497          	auipc	s1,0xf
    80001dd0:	5b448493          	addi	s1,s1,1460 # 80011380 <tickslock>
    80001dd4:	8526                	mv	a0,s1
    80001dd6:	00004097          	auipc	ra,0x4
    80001dda:	766080e7          	jalr	1894(ra) # 8000653c <acquire>
  ticks++;
    80001dde:	00009517          	auipc	a0,0x9
    80001de2:	53a50513          	addi	a0,a0,1338 # 8000b318 <ticks>
    80001de6:	411c                	lw	a5,0(a0)
    80001de8:	2785                	addiw	a5,a5,1
    80001dea:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001dec:	00000097          	auipc	ra,0x0
    80001df0:	996080e7          	jalr	-1642(ra) # 80001782 <wakeup>
  release(&tickslock);
    80001df4:	8526                	mv	a0,s1
    80001df6:	00004097          	auipc	ra,0x4
    80001dfa:	7fa080e7          	jalr	2042(ra) # 800065f0 <release>
}
    80001dfe:	60e2                	ld	ra,24(sp)
    80001e00:	6442                	ld	s0,16(sp)
    80001e02:	64a2                	ld	s1,8(sp)
    80001e04:	6105                	addi	sp,sp,32
    80001e06:	8082                	ret

0000000080001e08 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e08:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001e0c:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001e0e:	0a07d163          	bgez	a5,80001eb0 <devintr+0xa8>
{
    80001e12:	1101                	addi	sp,sp,-32
    80001e14:	ec06                	sd	ra,24(sp)
    80001e16:	e822                	sd	s0,16(sp)
    80001e18:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001e1a:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001e1e:	46a5                	li	a3,9
    80001e20:	00d70c63          	beq	a4,a3,80001e38 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001e24:	577d                	li	a4,-1
    80001e26:	177e                	slli	a4,a4,0x3f
    80001e28:	0705                	addi	a4,a4,1
    return 0;
    80001e2a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001e2c:	06e78163          	beq	a5,a4,80001e8e <devintr+0x86>
  }
}
    80001e30:	60e2                	ld	ra,24(sp)
    80001e32:	6442                	ld	s0,16(sp)
    80001e34:	6105                	addi	sp,sp,32
    80001e36:	8082                	ret
    80001e38:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001e3a:	00003097          	auipc	ra,0x3
    80001e3e:	662080e7          	jalr	1634(ra) # 8000549c <plic_claim>
    80001e42:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001e44:	47a9                	li	a5,10
    80001e46:	00f50963          	beq	a0,a5,80001e58 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001e4a:	4785                	li	a5,1
    80001e4c:	00f50b63          	beq	a0,a5,80001e62 <devintr+0x5a>
    return 1;
    80001e50:	4505                	li	a0,1
    } else if(irq){
    80001e52:	ec89                	bnez	s1,80001e6c <devintr+0x64>
    80001e54:	64a2                	ld	s1,8(sp)
    80001e56:	bfe9                	j	80001e30 <devintr+0x28>
      uartintr();
    80001e58:	00004097          	auipc	ra,0x4
    80001e5c:	604080e7          	jalr	1540(ra) # 8000645c <uartintr>
    if(irq)
    80001e60:	a839                	j	80001e7e <devintr+0x76>
      virtio_disk_intr();
    80001e62:	00004097          	auipc	ra,0x4
    80001e66:	b64080e7          	jalr	-1180(ra) # 800059c6 <virtio_disk_intr>
    if(irq)
    80001e6a:	a811                	j	80001e7e <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001e6c:	85a6                	mv	a1,s1
    80001e6e:	00006517          	auipc	a0,0x6
    80001e72:	45250513          	addi	a0,a0,1106 # 800082c0 <etext+0x2c0>
    80001e76:	00004097          	auipc	ra,0x4
    80001e7a:	196080e7          	jalr	406(ra) # 8000600c <printf>
      plic_complete(irq);
    80001e7e:	8526                	mv	a0,s1
    80001e80:	00003097          	auipc	ra,0x3
    80001e84:	640080e7          	jalr	1600(ra) # 800054c0 <plic_complete>
    return 1;
    80001e88:	4505                	li	a0,1
    80001e8a:	64a2                	ld	s1,8(sp)
    80001e8c:	b755                	j	80001e30 <devintr+0x28>
    if(cpuid() == 0){
    80001e8e:	fffff097          	auipc	ra,0xfffff
    80001e92:	130080e7          	jalr	304(ra) # 80000fbe <cpuid>
    80001e96:	c901                	beqz	a0,80001ea6 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e98:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e9c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e9e:	14479073          	csrw	sip,a5
    return 2;
    80001ea2:	4509                	li	a0,2
    80001ea4:	b771                	j	80001e30 <devintr+0x28>
      clockintr();
    80001ea6:	00000097          	auipc	ra,0x0
    80001eaa:	f1c080e7          	jalr	-228(ra) # 80001dc2 <clockintr>
    80001eae:	b7ed                	j	80001e98 <devintr+0x90>
}
    80001eb0:	8082                	ret

0000000080001eb2 <usertrap>:
{
    80001eb2:	1101                	addi	sp,sp,-32
    80001eb4:	ec06                	sd	ra,24(sp)
    80001eb6:	e822                	sd	s0,16(sp)
    80001eb8:	e426                	sd	s1,8(sp)
    80001eba:	e04a                	sd	s2,0(sp)
    80001ebc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ebe:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001ec2:	1007f793          	andi	a5,a5,256
    80001ec6:	e3b1                	bnez	a5,80001f0a <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ec8:	00003797          	auipc	a5,0x3
    80001ecc:	4c878793          	addi	a5,a5,1224 # 80005390 <kernelvec>
    80001ed0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ed4:	fffff097          	auipc	ra,0xfffff
    80001ed8:	116080e7          	jalr	278(ra) # 80000fea <myproc>
    80001edc:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001ede:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ee0:	14102773          	csrr	a4,sepc
    80001ee4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ee6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001eea:	47a1                	li	a5,8
    80001eec:	02f70763          	beq	a4,a5,80001f1a <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001ef0:	00000097          	auipc	ra,0x0
    80001ef4:	f18080e7          	jalr	-232(ra) # 80001e08 <devintr>
    80001ef8:	892a                	mv	s2,a0
    80001efa:	c151                	beqz	a0,80001f7e <usertrap+0xcc>
  if(killed(p))
    80001efc:	8526                	mv	a0,s1
    80001efe:	00000097          	auipc	ra,0x0
    80001f02:	ac8080e7          	jalr	-1336(ra) # 800019c6 <killed>
    80001f06:	c929                	beqz	a0,80001f58 <usertrap+0xa6>
    80001f08:	a099                	j	80001f4e <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001f0a:	00006517          	auipc	a0,0x6
    80001f0e:	3d650513          	addi	a0,a0,982 # 800082e0 <etext+0x2e0>
    80001f12:	00004097          	auipc	ra,0x4
    80001f16:	0b0080e7          	jalr	176(ra) # 80005fc2 <panic>
    if(killed(p))
    80001f1a:	00000097          	auipc	ra,0x0
    80001f1e:	aac080e7          	jalr	-1364(ra) # 800019c6 <killed>
    80001f22:	e921                	bnez	a0,80001f72 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001f24:	6cb8                	ld	a4,88(s1)
    80001f26:	6f1c                	ld	a5,24(a4)
    80001f28:	0791                	addi	a5,a5,4
    80001f2a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f2c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f30:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f34:	10079073          	csrw	sstatus,a5
    syscall();
    80001f38:	00000097          	auipc	ra,0x0
    80001f3c:	2d4080e7          	jalr	724(ra) # 8000220c <syscall>
  if(killed(p))
    80001f40:	8526                	mv	a0,s1
    80001f42:	00000097          	auipc	ra,0x0
    80001f46:	a84080e7          	jalr	-1404(ra) # 800019c6 <killed>
    80001f4a:	c911                	beqz	a0,80001f5e <usertrap+0xac>
    80001f4c:	4901                	li	s2,0
    exit(-1);
    80001f4e:	557d                	li	a0,-1
    80001f50:	00000097          	auipc	ra,0x0
    80001f54:	902080e7          	jalr	-1790(ra) # 80001852 <exit>
  if(which_dev == 2)
    80001f58:	4789                	li	a5,2
    80001f5a:	04f90f63          	beq	s2,a5,80001fb8 <usertrap+0x106>
  usertrapret();
    80001f5e:	00000097          	auipc	ra,0x0
    80001f62:	dce080e7          	jalr	-562(ra) # 80001d2c <usertrapret>
}
    80001f66:	60e2                	ld	ra,24(sp)
    80001f68:	6442                	ld	s0,16(sp)
    80001f6a:	64a2                	ld	s1,8(sp)
    80001f6c:	6902                	ld	s2,0(sp)
    80001f6e:	6105                	addi	sp,sp,32
    80001f70:	8082                	ret
      exit(-1);
    80001f72:	557d                	li	a0,-1
    80001f74:	00000097          	auipc	ra,0x0
    80001f78:	8de080e7          	jalr	-1826(ra) # 80001852 <exit>
    80001f7c:	b765                	j	80001f24 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f7e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f82:	5890                	lw	a2,48(s1)
    80001f84:	00006517          	auipc	a0,0x6
    80001f88:	37c50513          	addi	a0,a0,892 # 80008300 <etext+0x300>
    80001f8c:	00004097          	auipc	ra,0x4
    80001f90:	080080e7          	jalr	128(ra) # 8000600c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f94:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f98:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f9c:	00006517          	auipc	a0,0x6
    80001fa0:	39450513          	addi	a0,a0,916 # 80008330 <etext+0x330>
    80001fa4:	00004097          	auipc	ra,0x4
    80001fa8:	068080e7          	jalr	104(ra) # 8000600c <printf>
    setkilled(p);
    80001fac:	8526                	mv	a0,s1
    80001fae:	00000097          	auipc	ra,0x0
    80001fb2:	9ec080e7          	jalr	-1556(ra) # 8000199a <setkilled>
    80001fb6:	b769                	j	80001f40 <usertrap+0x8e>
    yield();
    80001fb8:	fffff097          	auipc	ra,0xfffff
    80001fbc:	72a080e7          	jalr	1834(ra) # 800016e2 <yield>
    80001fc0:	bf79                	j	80001f5e <usertrap+0xac>

0000000080001fc2 <kerneltrap>:
{
    80001fc2:	7179                	addi	sp,sp,-48
    80001fc4:	f406                	sd	ra,40(sp)
    80001fc6:	f022                	sd	s0,32(sp)
    80001fc8:	ec26                	sd	s1,24(sp)
    80001fca:	e84a                	sd	s2,16(sp)
    80001fcc:	e44e                	sd	s3,8(sp)
    80001fce:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fd0:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fd4:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001fd8:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001fdc:	1004f793          	andi	a5,s1,256
    80001fe0:	cb85                	beqz	a5,80002010 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fe2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001fe6:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001fe8:	ef85                	bnez	a5,80002020 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001fea:	00000097          	auipc	ra,0x0
    80001fee:	e1e080e7          	jalr	-482(ra) # 80001e08 <devintr>
    80001ff2:	cd1d                	beqz	a0,80002030 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ff4:	4789                	li	a5,2
    80001ff6:	06f50a63          	beq	a0,a5,8000206a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ffa:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ffe:	10049073          	csrw	sstatus,s1
}
    80002002:	70a2                	ld	ra,40(sp)
    80002004:	7402                	ld	s0,32(sp)
    80002006:	64e2                	ld	s1,24(sp)
    80002008:	6942                	ld	s2,16(sp)
    8000200a:	69a2                	ld	s3,8(sp)
    8000200c:	6145                	addi	sp,sp,48
    8000200e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002010:	00006517          	auipc	a0,0x6
    80002014:	34050513          	addi	a0,a0,832 # 80008350 <etext+0x350>
    80002018:	00004097          	auipc	ra,0x4
    8000201c:	faa080e7          	jalr	-86(ra) # 80005fc2 <panic>
    panic("kerneltrap: interrupts enabled");
    80002020:	00006517          	auipc	a0,0x6
    80002024:	35850513          	addi	a0,a0,856 # 80008378 <etext+0x378>
    80002028:	00004097          	auipc	ra,0x4
    8000202c:	f9a080e7          	jalr	-102(ra) # 80005fc2 <panic>
    printf("scause %p\n", scause);
    80002030:	85ce                	mv	a1,s3
    80002032:	00006517          	auipc	a0,0x6
    80002036:	36650513          	addi	a0,a0,870 # 80008398 <etext+0x398>
    8000203a:	00004097          	auipc	ra,0x4
    8000203e:	fd2080e7          	jalr	-46(ra) # 8000600c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002042:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002046:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000204a:	00006517          	auipc	a0,0x6
    8000204e:	35e50513          	addi	a0,a0,862 # 800083a8 <etext+0x3a8>
    80002052:	00004097          	auipc	ra,0x4
    80002056:	fba080e7          	jalr	-70(ra) # 8000600c <printf>
    panic("kerneltrap");
    8000205a:	00006517          	auipc	a0,0x6
    8000205e:	36650513          	addi	a0,a0,870 # 800083c0 <etext+0x3c0>
    80002062:	00004097          	auipc	ra,0x4
    80002066:	f60080e7          	jalr	-160(ra) # 80005fc2 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000206a:	fffff097          	auipc	ra,0xfffff
    8000206e:	f80080e7          	jalr	-128(ra) # 80000fea <myproc>
    80002072:	d541                	beqz	a0,80001ffa <kerneltrap+0x38>
    80002074:	fffff097          	auipc	ra,0xfffff
    80002078:	f76080e7          	jalr	-138(ra) # 80000fea <myproc>
    8000207c:	4d18                	lw	a4,24(a0)
    8000207e:	4791                	li	a5,4
    80002080:	f6f71de3          	bne	a4,a5,80001ffa <kerneltrap+0x38>
    yield();
    80002084:	fffff097          	auipc	ra,0xfffff
    80002088:	65e080e7          	jalr	1630(ra) # 800016e2 <yield>
    8000208c:	b7bd                	j	80001ffa <kerneltrap+0x38>

000000008000208e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000208e:	1101                	addi	sp,sp,-32
    80002090:	ec06                	sd	ra,24(sp)
    80002092:	e822                	sd	s0,16(sp)
    80002094:	e426                	sd	s1,8(sp)
    80002096:	1000                	addi	s0,sp,32
    80002098:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000209a:	fffff097          	auipc	ra,0xfffff
    8000209e:	f50080e7          	jalr	-176(ra) # 80000fea <myproc>
  switch (n) {
    800020a2:	4795                	li	a5,5
    800020a4:	0497e163          	bltu	a5,s1,800020e6 <argraw+0x58>
    800020a8:	048a                	slli	s1,s1,0x2
    800020aa:	00006717          	auipc	a4,0x6
    800020ae:	72670713          	addi	a4,a4,1830 # 800087d0 <states.0+0x30>
    800020b2:	94ba                	add	s1,s1,a4
    800020b4:	409c                	lw	a5,0(s1)
    800020b6:	97ba                	add	a5,a5,a4
    800020b8:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800020ba:	6d3c                	ld	a5,88(a0)
    800020bc:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800020be:	60e2                	ld	ra,24(sp)
    800020c0:	6442                	ld	s0,16(sp)
    800020c2:	64a2                	ld	s1,8(sp)
    800020c4:	6105                	addi	sp,sp,32
    800020c6:	8082                	ret
    return p->trapframe->a1;
    800020c8:	6d3c                	ld	a5,88(a0)
    800020ca:	7fa8                	ld	a0,120(a5)
    800020cc:	bfcd                	j	800020be <argraw+0x30>
    return p->trapframe->a2;
    800020ce:	6d3c                	ld	a5,88(a0)
    800020d0:	63c8                	ld	a0,128(a5)
    800020d2:	b7f5                	j	800020be <argraw+0x30>
    return p->trapframe->a3;
    800020d4:	6d3c                	ld	a5,88(a0)
    800020d6:	67c8                	ld	a0,136(a5)
    800020d8:	b7dd                	j	800020be <argraw+0x30>
    return p->trapframe->a4;
    800020da:	6d3c                	ld	a5,88(a0)
    800020dc:	6bc8                	ld	a0,144(a5)
    800020de:	b7c5                	j	800020be <argraw+0x30>
    return p->trapframe->a5;
    800020e0:	6d3c                	ld	a5,88(a0)
    800020e2:	6fc8                	ld	a0,152(a5)
    800020e4:	bfe9                	j	800020be <argraw+0x30>
  panic("argraw");
    800020e6:	00006517          	auipc	a0,0x6
    800020ea:	2ea50513          	addi	a0,a0,746 # 800083d0 <etext+0x3d0>
    800020ee:	00004097          	auipc	ra,0x4
    800020f2:	ed4080e7          	jalr	-300(ra) # 80005fc2 <panic>

00000000800020f6 <fetchaddr>:
{
    800020f6:	1101                	addi	sp,sp,-32
    800020f8:	ec06                	sd	ra,24(sp)
    800020fa:	e822                	sd	s0,16(sp)
    800020fc:	e426                	sd	s1,8(sp)
    800020fe:	e04a                	sd	s2,0(sp)
    80002100:	1000                	addi	s0,sp,32
    80002102:	84aa                	mv	s1,a0
    80002104:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002106:	fffff097          	auipc	ra,0xfffff
    8000210a:	ee4080e7          	jalr	-284(ra) # 80000fea <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000210e:	653c                	ld	a5,72(a0)
    80002110:	02f4f863          	bgeu	s1,a5,80002140 <fetchaddr+0x4a>
    80002114:	00848713          	addi	a4,s1,8
    80002118:	02e7e663          	bltu	a5,a4,80002144 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000211c:	46a1                	li	a3,8
    8000211e:	8626                	mv	a2,s1
    80002120:	85ca                	mv	a1,s2
    80002122:	6928                	ld	a0,80(a0)
    80002124:	fffff097          	auipc	ra,0xfffff
    80002128:	b06080e7          	jalr	-1274(ra) # 80000c2a <copyin>
    8000212c:	00a03533          	snez	a0,a0
    80002130:	40a00533          	neg	a0,a0
}
    80002134:	60e2                	ld	ra,24(sp)
    80002136:	6442                	ld	s0,16(sp)
    80002138:	64a2                	ld	s1,8(sp)
    8000213a:	6902                	ld	s2,0(sp)
    8000213c:	6105                	addi	sp,sp,32
    8000213e:	8082                	ret
    return -1;
    80002140:	557d                	li	a0,-1
    80002142:	bfcd                	j	80002134 <fetchaddr+0x3e>
    80002144:	557d                	li	a0,-1
    80002146:	b7fd                	j	80002134 <fetchaddr+0x3e>

0000000080002148 <fetchstr>:
{
    80002148:	7179                	addi	sp,sp,-48
    8000214a:	f406                	sd	ra,40(sp)
    8000214c:	f022                	sd	s0,32(sp)
    8000214e:	ec26                	sd	s1,24(sp)
    80002150:	e84a                	sd	s2,16(sp)
    80002152:	e44e                	sd	s3,8(sp)
    80002154:	1800                	addi	s0,sp,48
    80002156:	892a                	mv	s2,a0
    80002158:	84ae                	mv	s1,a1
    8000215a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000215c:	fffff097          	auipc	ra,0xfffff
    80002160:	e8e080e7          	jalr	-370(ra) # 80000fea <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002164:	86ce                	mv	a3,s3
    80002166:	864a                	mv	a2,s2
    80002168:	85a6                	mv	a1,s1
    8000216a:	6928                	ld	a0,80(a0)
    8000216c:	fffff097          	auipc	ra,0xfffff
    80002170:	b4c080e7          	jalr	-1204(ra) # 80000cb8 <copyinstr>
    80002174:	00054e63          	bltz	a0,80002190 <fetchstr+0x48>
  return strlen(buf);
    80002178:	8526                	mv	a0,s1
    8000217a:	ffffe097          	auipc	ra,0xffffe
    8000217e:	174080e7          	jalr	372(ra) # 800002ee <strlen>
}
    80002182:	70a2                	ld	ra,40(sp)
    80002184:	7402                	ld	s0,32(sp)
    80002186:	64e2                	ld	s1,24(sp)
    80002188:	6942                	ld	s2,16(sp)
    8000218a:	69a2                	ld	s3,8(sp)
    8000218c:	6145                	addi	sp,sp,48
    8000218e:	8082                	ret
    return -1;
    80002190:	557d                	li	a0,-1
    80002192:	bfc5                	j	80002182 <fetchstr+0x3a>

0000000080002194 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002194:	1101                	addi	sp,sp,-32
    80002196:	ec06                	sd	ra,24(sp)
    80002198:	e822                	sd	s0,16(sp)
    8000219a:	e426                	sd	s1,8(sp)
    8000219c:	1000                	addi	s0,sp,32
    8000219e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021a0:	00000097          	auipc	ra,0x0
    800021a4:	eee080e7          	jalr	-274(ra) # 8000208e <argraw>
    800021a8:	c088                	sw	a0,0(s1)
}
    800021aa:	60e2                	ld	ra,24(sp)
    800021ac:	6442                	ld	s0,16(sp)
    800021ae:	64a2                	ld	s1,8(sp)
    800021b0:	6105                	addi	sp,sp,32
    800021b2:	8082                	ret

00000000800021b4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800021b4:	1101                	addi	sp,sp,-32
    800021b6:	ec06                	sd	ra,24(sp)
    800021b8:	e822                	sd	s0,16(sp)
    800021ba:	e426                	sd	s1,8(sp)
    800021bc:	1000                	addi	s0,sp,32
    800021be:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021c0:	00000097          	auipc	ra,0x0
    800021c4:	ece080e7          	jalr	-306(ra) # 8000208e <argraw>
    800021c8:	e088                	sd	a0,0(s1)
}
    800021ca:	60e2                	ld	ra,24(sp)
    800021cc:	6442                	ld	s0,16(sp)
    800021ce:	64a2                	ld	s1,8(sp)
    800021d0:	6105                	addi	sp,sp,32
    800021d2:	8082                	ret

00000000800021d4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800021d4:	7179                	addi	sp,sp,-48
    800021d6:	f406                	sd	ra,40(sp)
    800021d8:	f022                	sd	s0,32(sp)
    800021da:	ec26                	sd	s1,24(sp)
    800021dc:	e84a                	sd	s2,16(sp)
    800021de:	1800                	addi	s0,sp,48
    800021e0:	84ae                	mv	s1,a1
    800021e2:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800021e4:	fd840593          	addi	a1,s0,-40
    800021e8:	00000097          	auipc	ra,0x0
    800021ec:	fcc080e7          	jalr	-52(ra) # 800021b4 <argaddr>
  return fetchstr(addr, buf, max);
    800021f0:	864a                	mv	a2,s2
    800021f2:	85a6                	mv	a1,s1
    800021f4:	fd843503          	ld	a0,-40(s0)
    800021f8:	00000097          	auipc	ra,0x0
    800021fc:	f50080e7          	jalr	-176(ra) # 80002148 <fetchstr>
}
    80002200:	70a2                	ld	ra,40(sp)
    80002202:	7402                	ld	s0,32(sp)
    80002204:	64e2                	ld	s1,24(sp)
    80002206:	6942                	ld	s2,16(sp)
    80002208:	6145                	addi	sp,sp,48
    8000220a:	8082                	ret

000000008000220c <syscall>:



void
syscall(void)
{
    8000220c:	1101                	addi	sp,sp,-32
    8000220e:	ec06                	sd	ra,24(sp)
    80002210:	e822                	sd	s0,16(sp)
    80002212:	e426                	sd	s1,8(sp)
    80002214:	e04a                	sd	s2,0(sp)
    80002216:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002218:	fffff097          	auipc	ra,0xfffff
    8000221c:	dd2080e7          	jalr	-558(ra) # 80000fea <myproc>
    80002220:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002222:	05853903          	ld	s2,88(a0)
    80002226:	0a893783          	ld	a5,168(s2)
    8000222a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000222e:	37fd                	addiw	a5,a5,-1
    80002230:	4775                	li	a4,29
    80002232:	00f76f63          	bltu	a4,a5,80002250 <syscall+0x44>
    80002236:	00369713          	slli	a4,a3,0x3
    8000223a:	00006797          	auipc	a5,0x6
    8000223e:	5ae78793          	addi	a5,a5,1454 # 800087e8 <syscalls>
    80002242:	97ba                	add	a5,a5,a4
    80002244:	639c                	ld	a5,0(a5)
    80002246:	c789                	beqz	a5,80002250 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002248:	9782                	jalr	a5
    8000224a:	06a93823          	sd	a0,112(s2)
    8000224e:	a839                	j	8000226c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002250:	15848613          	addi	a2,s1,344
    80002254:	588c                	lw	a1,48(s1)
    80002256:	00006517          	auipc	a0,0x6
    8000225a:	18250513          	addi	a0,a0,386 # 800083d8 <etext+0x3d8>
    8000225e:	00004097          	auipc	ra,0x4
    80002262:	dae080e7          	jalr	-594(ra) # 8000600c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002266:	6cbc                	ld	a5,88(s1)
    80002268:	577d                	li	a4,-1
    8000226a:	fbb8                	sd	a4,112(a5)
  }
}
    8000226c:	60e2                	ld	ra,24(sp)
    8000226e:	6442                	ld	s0,16(sp)
    80002270:	64a2                	ld	s1,8(sp)
    80002272:	6902                	ld	s2,0(sp)
    80002274:	6105                	addi	sp,sp,32
    80002276:	8082                	ret

0000000080002278 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002278:	1101                	addi	sp,sp,-32
    8000227a:	ec06                	sd	ra,24(sp)
    8000227c:	e822                	sd	s0,16(sp)
    8000227e:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002280:	fec40593          	addi	a1,s0,-20
    80002284:	4501                	li	a0,0
    80002286:	00000097          	auipc	ra,0x0
    8000228a:	f0e080e7          	jalr	-242(ra) # 80002194 <argint>
  exit(n);
    8000228e:	fec42503          	lw	a0,-20(s0)
    80002292:	fffff097          	auipc	ra,0xfffff
    80002296:	5c0080e7          	jalr	1472(ra) # 80001852 <exit>
  return 0; // not reached
}
    8000229a:	4501                	li	a0,0
    8000229c:	60e2                	ld	ra,24(sp)
    8000229e:	6442                	ld	s0,16(sp)
    800022a0:	6105                	addi	sp,sp,32
    800022a2:	8082                	ret

00000000800022a4 <sys_getpid>:

uint64
sys_getpid(void)
{
    800022a4:	1141                	addi	sp,sp,-16
    800022a6:	e406                	sd	ra,8(sp)
    800022a8:	e022                	sd	s0,0(sp)
    800022aa:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800022ac:	fffff097          	auipc	ra,0xfffff
    800022b0:	d3e080e7          	jalr	-706(ra) # 80000fea <myproc>
}
    800022b4:	5908                	lw	a0,48(a0)
    800022b6:	60a2                	ld	ra,8(sp)
    800022b8:	6402                	ld	s0,0(sp)
    800022ba:	0141                	addi	sp,sp,16
    800022bc:	8082                	ret

00000000800022be <sys_fork>:

uint64
sys_fork(void)
{
    800022be:	1141                	addi	sp,sp,-16
    800022c0:	e406                	sd	ra,8(sp)
    800022c2:	e022                	sd	s0,0(sp)
    800022c4:	0800                	addi	s0,sp,16
  return fork();
    800022c6:	fffff097          	auipc	ra,0xfffff
    800022ca:	164080e7          	jalr	356(ra) # 8000142a <fork>
}
    800022ce:	60a2                	ld	ra,8(sp)
    800022d0:	6402                	ld	s0,0(sp)
    800022d2:	0141                	addi	sp,sp,16
    800022d4:	8082                	ret

00000000800022d6 <sys_wait>:

uint64
sys_wait(void)
{
    800022d6:	1101                	addi	sp,sp,-32
    800022d8:	ec06                	sd	ra,24(sp)
    800022da:	e822                	sd	s0,16(sp)
    800022dc:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800022de:	fe840593          	addi	a1,s0,-24
    800022e2:	4501                	li	a0,0
    800022e4:	00000097          	auipc	ra,0x0
    800022e8:	ed0080e7          	jalr	-304(ra) # 800021b4 <argaddr>
  return wait(p);
    800022ec:	fe843503          	ld	a0,-24(s0)
    800022f0:	fffff097          	auipc	ra,0xfffff
    800022f4:	708080e7          	jalr	1800(ra) # 800019f8 <wait>
}
    800022f8:	60e2                	ld	ra,24(sp)
    800022fa:	6442                	ld	s0,16(sp)
    800022fc:	6105                	addi	sp,sp,32
    800022fe:	8082                	ret

0000000080002300 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002300:	7179                	addi	sp,sp,-48
    80002302:	f406                	sd	ra,40(sp)
    80002304:	f022                	sd	s0,32(sp)
    80002306:	ec26                	sd	s1,24(sp)
    80002308:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000230a:	fdc40593          	addi	a1,s0,-36
    8000230e:	4501                	li	a0,0
    80002310:	00000097          	auipc	ra,0x0
    80002314:	e84080e7          	jalr	-380(ra) # 80002194 <argint>
  addr = myproc()->sz;
    80002318:	fffff097          	auipc	ra,0xfffff
    8000231c:	cd2080e7          	jalr	-814(ra) # 80000fea <myproc>
    80002320:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0)
    80002322:	fdc42503          	lw	a0,-36(s0)
    80002326:	fffff097          	auipc	ra,0xfffff
    8000232a:	0a8080e7          	jalr	168(ra) # 800013ce <growproc>
    8000232e:	00054863          	bltz	a0,8000233e <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002332:	8526                	mv	a0,s1
    80002334:	70a2                	ld	ra,40(sp)
    80002336:	7402                	ld	s0,32(sp)
    80002338:	64e2                	ld	s1,24(sp)
    8000233a:	6145                	addi	sp,sp,48
    8000233c:	8082                	ret
    return -1;
    8000233e:	54fd                	li	s1,-1
    80002340:	bfcd                	j	80002332 <sys_sbrk+0x32>

0000000080002342 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002342:	7139                	addi	sp,sp,-64
    80002344:	fc06                	sd	ra,56(sp)
    80002346:	f822                	sd	s0,48(sp)
    80002348:	f04a                	sd	s2,32(sp)
    8000234a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000234c:	fcc40593          	addi	a1,s0,-52
    80002350:	4501                	li	a0,0
    80002352:	00000097          	auipc	ra,0x0
    80002356:	e42080e7          	jalr	-446(ra) # 80002194 <argint>
  acquire(&tickslock);
    8000235a:	0000f517          	auipc	a0,0xf
    8000235e:	02650513          	addi	a0,a0,38 # 80011380 <tickslock>
    80002362:	00004097          	auipc	ra,0x4
    80002366:	1da080e7          	jalr	474(ra) # 8000653c <acquire>
  ticks0 = ticks;
    8000236a:	00009917          	auipc	s2,0x9
    8000236e:	fae92903          	lw	s2,-82(s2) # 8000b318 <ticks>
  while (ticks - ticks0 < n)
    80002372:	fcc42783          	lw	a5,-52(s0)
    80002376:	c3b9                	beqz	a5,800023bc <sys_sleep+0x7a>
    80002378:	f426                	sd	s1,40(sp)
    8000237a:	ec4e                	sd	s3,24(sp)
    if (killed(myproc()))
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000237c:	0000f997          	auipc	s3,0xf
    80002380:	00498993          	addi	s3,s3,4 # 80011380 <tickslock>
    80002384:	00009497          	auipc	s1,0x9
    80002388:	f9448493          	addi	s1,s1,-108 # 8000b318 <ticks>
    if (killed(myproc()))
    8000238c:	fffff097          	auipc	ra,0xfffff
    80002390:	c5e080e7          	jalr	-930(ra) # 80000fea <myproc>
    80002394:	fffff097          	auipc	ra,0xfffff
    80002398:	632080e7          	jalr	1586(ra) # 800019c6 <killed>
    8000239c:	ed15                	bnez	a0,800023d8 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    8000239e:	85ce                	mv	a1,s3
    800023a0:	8526                	mv	a0,s1
    800023a2:	fffff097          	auipc	ra,0xfffff
    800023a6:	37c080e7          	jalr	892(ra) # 8000171e <sleep>
  while (ticks - ticks0 < n)
    800023aa:	409c                	lw	a5,0(s1)
    800023ac:	412787bb          	subw	a5,a5,s2
    800023b0:	fcc42703          	lw	a4,-52(s0)
    800023b4:	fce7ece3          	bltu	a5,a4,8000238c <sys_sleep+0x4a>
    800023b8:	74a2                	ld	s1,40(sp)
    800023ba:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800023bc:	0000f517          	auipc	a0,0xf
    800023c0:	fc450513          	addi	a0,a0,-60 # 80011380 <tickslock>
    800023c4:	00004097          	auipc	ra,0x4
    800023c8:	22c080e7          	jalr	556(ra) # 800065f0 <release>
  return 0;
    800023cc:	4501                	li	a0,0
}
    800023ce:	70e2                	ld	ra,56(sp)
    800023d0:	7442                	ld	s0,48(sp)
    800023d2:	7902                	ld	s2,32(sp)
    800023d4:	6121                	addi	sp,sp,64
    800023d6:	8082                	ret
      release(&tickslock);
    800023d8:	0000f517          	auipc	a0,0xf
    800023dc:	fa850513          	addi	a0,a0,-88 # 80011380 <tickslock>
    800023e0:	00004097          	auipc	ra,0x4
    800023e4:	210080e7          	jalr	528(ra) # 800065f0 <release>
      return -1;
    800023e8:	557d                	li	a0,-1
    800023ea:	74a2                	ld	s1,40(sp)
    800023ec:	69e2                	ld	s3,24(sp)
    800023ee:	b7c5                	j	800023ce <sys_sleep+0x8c>

00000000800023f0 <sys_pgaccess>:

#define PTE_A (1 << 6)
#ifdef LAB_PGTBL
int sys_pgaccess(void)
{
    800023f0:	715d                	addi	sp,sp,-80
    800023f2:	e486                	sd	ra,72(sp)
    800023f4:	e0a2                	sd	s0,64(sp)
    800023f6:	f84a                	sd	s2,48(sp)
    800023f8:	0880                	addi	s0,sp,80
  struct proc *p = myproc();
    800023fa:	fffff097          	auipc	ra,0xfffff
    800023fe:	bf0080e7          	jalr	-1040(ra) # 80000fea <myproc>
    80002402:	892a                	mv	s2,a0
  unsigned int abits = 0;
    80002404:	fc042623          	sw	zero,-52(s0)

  uint64 addr;
  argaddr(0, &addr);
    80002408:	fc040593          	addi	a1,s0,-64
    8000240c:	4501                	li	a0,0
    8000240e:	00000097          	auipc	ra,0x0
    80002412:	da6080e7          	jalr	-602(ra) # 800021b4 <argaddr>

  int num;
  argint(1, &num);
    80002416:	fbc40593          	addi	a1,s0,-68
    8000241a:	4505                	li	a0,1
    8000241c:	00000097          	auipc	ra,0x0
    80002420:	d78080e7          	jalr	-648(ra) # 80002194 <argint>

  uint64 dest;
  argaddr(2, &dest);
    80002424:	fb040593          	addi	a1,s0,-80
    80002428:	4509                	li	a0,2
    8000242a:	00000097          	auipc	ra,0x0
    8000242e:	d8a080e7          	jalr	-630(ra) # 800021b4 <argaddr>

  for (int i = 0; i < num; i++)
    80002432:	fbc42783          	lw	a5,-68(s0)
    80002436:	04f05b63          	blez	a5,8000248c <sys_pgaccess+0x9c>
    8000243a:	fc26                	sd	s1,56(sp)
    8000243c:	f44e                	sd	s3,40(sp)
    8000243e:	4481                	li	s1,0
    uint64 query_addr = addr + i * PGSIZE;

    pte_t *pte = walk(p->pagetable, query_addr, 0);
    if (*pte & PTE_A)
    {
      abits = abits | (1 << i);
    80002440:	4985                	li	s3,1
    80002442:	a801                	j	80002452 <sys_pgaccess+0x62>
  for (int i = 0; i < num; i++)
    80002444:	0485                	addi	s1,s1,1
    80002446:	fbc42703          	lw	a4,-68(s0)
    8000244a:	0004879b          	sext.w	a5,s1
    8000244e:	02e7dd63          	bge	a5,a4,80002488 <sys_pgaccess+0x98>
    uint64 query_addr = addr + i * PGSIZE;
    80002452:	00c49593          	slli	a1,s1,0xc
    pte_t *pte = walk(p->pagetable, query_addr, 0);
    80002456:	4601                	li	a2,0
    80002458:	fc043783          	ld	a5,-64(s0)
    8000245c:	95be                	add	a1,a1,a5
    8000245e:	05093503          	ld	a0,80(s2)
    80002462:	ffffe097          	auipc	ra,0xffffe
    80002466:	ff4080e7          	jalr	-12(ra) # 80000456 <walk>
    if (*pte & PTE_A)
    8000246a:	611c                	ld	a5,0(a0)
    8000246c:	0407f713          	andi	a4,a5,64
    80002470:	db71                	beqz	a4,80002444 <sys_pgaccess+0x54>
      abits = abits | (1 << i);
    80002472:	009996bb          	sllw	a3,s3,s1
    80002476:	fcc42703          	lw	a4,-52(s0)
    8000247a:	8f55                	or	a4,a4,a3
    8000247c:	fce42623          	sw	a4,-52(s0)
      *pte = (*pte) & (~PTE_A);
    80002480:	fbf7f793          	andi	a5,a5,-65
    80002484:	e11c                	sd	a5,0(a0)
    80002486:	bf7d                	j	80002444 <sys_pgaccess+0x54>
    80002488:	74e2                	ld	s1,56(sp)
    8000248a:	79a2                	ld	s3,40(sp)
    }
  }

  if (copyout(p->pagetable, dest, (char *)&abits, sizeof(abits)) < 0)
    8000248c:	4691                	li	a3,4
    8000248e:	fcc40613          	addi	a2,s0,-52
    80002492:	fb043583          	ld	a1,-80(s0)
    80002496:	05093503          	ld	a0,80(s2)
    8000249a:	ffffe097          	auipc	ra,0xffffe
    8000249e:	6b2080e7          	jalr	1714(ra) # 80000b4c <copyout>
    return -1;

  return 0;
}
    800024a2:	41f5551b          	sraiw	a0,a0,0x1f
    800024a6:	60a6                	ld	ra,72(sp)
    800024a8:	6406                	ld	s0,64(sp)
    800024aa:	7942                	ld	s2,48(sp)
    800024ac:	6161                	addi	sp,sp,80
    800024ae:	8082                	ret

00000000800024b0 <sys_kill>:
#endif

uint64
sys_kill(void)
{
    800024b0:	1101                	addi	sp,sp,-32
    800024b2:	ec06                	sd	ra,24(sp)
    800024b4:	e822                	sd	s0,16(sp)
    800024b6:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800024b8:	fec40593          	addi	a1,s0,-20
    800024bc:	4501                	li	a0,0
    800024be:	00000097          	auipc	ra,0x0
    800024c2:	cd6080e7          	jalr	-810(ra) # 80002194 <argint>
  return kill(pid);
    800024c6:	fec42503          	lw	a0,-20(s0)
    800024ca:	fffff097          	auipc	ra,0xfffff
    800024ce:	45e080e7          	jalr	1118(ra) # 80001928 <kill>
}
    800024d2:	60e2                	ld	ra,24(sp)
    800024d4:	6442                	ld	s0,16(sp)
    800024d6:	6105                	addi	sp,sp,32
    800024d8:	8082                	ret

00000000800024da <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800024da:	1101                	addi	sp,sp,-32
    800024dc:	ec06                	sd	ra,24(sp)
    800024de:	e822                	sd	s0,16(sp)
    800024e0:	e426                	sd	s1,8(sp)
    800024e2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800024e4:	0000f517          	auipc	a0,0xf
    800024e8:	e9c50513          	addi	a0,a0,-356 # 80011380 <tickslock>
    800024ec:	00004097          	auipc	ra,0x4
    800024f0:	050080e7          	jalr	80(ra) # 8000653c <acquire>
  xticks = ticks;
    800024f4:	00009497          	auipc	s1,0x9
    800024f8:	e244a483          	lw	s1,-476(s1) # 8000b318 <ticks>
  release(&tickslock);
    800024fc:	0000f517          	auipc	a0,0xf
    80002500:	e8450513          	addi	a0,a0,-380 # 80011380 <tickslock>
    80002504:	00004097          	auipc	ra,0x4
    80002508:	0ec080e7          	jalr	236(ra) # 800065f0 <release>
  return xticks;
}
    8000250c:	02049513          	slli	a0,s1,0x20
    80002510:	9101                	srli	a0,a0,0x20
    80002512:	60e2                	ld	ra,24(sp)
    80002514:	6442                	ld	s0,16(sp)
    80002516:	64a2                	ld	s1,8(sp)
    80002518:	6105                	addi	sp,sp,32
    8000251a:	8082                	ret

000000008000251c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000251c:	7179                	addi	sp,sp,-48
    8000251e:	f406                	sd	ra,40(sp)
    80002520:	f022                	sd	s0,32(sp)
    80002522:	ec26                	sd	s1,24(sp)
    80002524:	e84a                	sd	s2,16(sp)
    80002526:	e44e                	sd	s3,8(sp)
    80002528:	e052                	sd	s4,0(sp)
    8000252a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000252c:	00006597          	auipc	a1,0x6
    80002530:	ecc58593          	addi	a1,a1,-308 # 800083f8 <etext+0x3f8>
    80002534:	0000f517          	auipc	a0,0xf
    80002538:	e6450513          	addi	a0,a0,-412 # 80011398 <bcache>
    8000253c:	00004097          	auipc	ra,0x4
    80002540:	f70080e7          	jalr	-144(ra) # 800064ac <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002544:	00017797          	auipc	a5,0x17
    80002548:	e5478793          	addi	a5,a5,-428 # 80019398 <bcache+0x8000>
    8000254c:	00017717          	auipc	a4,0x17
    80002550:	0b470713          	addi	a4,a4,180 # 80019600 <bcache+0x8268>
    80002554:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002558:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000255c:	0000f497          	auipc	s1,0xf
    80002560:	e5448493          	addi	s1,s1,-428 # 800113b0 <bcache+0x18>
    b->next = bcache.head.next;
    80002564:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002566:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002568:	00006a17          	auipc	s4,0x6
    8000256c:	e98a0a13          	addi	s4,s4,-360 # 80008400 <etext+0x400>
    b->next = bcache.head.next;
    80002570:	2b893783          	ld	a5,696(s2)
    80002574:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002576:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000257a:	85d2                	mv	a1,s4
    8000257c:	01048513          	addi	a0,s1,16
    80002580:	00001097          	auipc	ra,0x1
    80002584:	4e8080e7          	jalr	1256(ra) # 80003a68 <initsleeplock>
    bcache.head.next->prev = b;
    80002588:	2b893783          	ld	a5,696(s2)
    8000258c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000258e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002592:	45848493          	addi	s1,s1,1112
    80002596:	fd349de3          	bne	s1,s3,80002570 <binit+0x54>
  }
}
    8000259a:	70a2                	ld	ra,40(sp)
    8000259c:	7402                	ld	s0,32(sp)
    8000259e:	64e2                	ld	s1,24(sp)
    800025a0:	6942                	ld	s2,16(sp)
    800025a2:	69a2                	ld	s3,8(sp)
    800025a4:	6a02                	ld	s4,0(sp)
    800025a6:	6145                	addi	sp,sp,48
    800025a8:	8082                	ret

00000000800025aa <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800025aa:	7179                	addi	sp,sp,-48
    800025ac:	f406                	sd	ra,40(sp)
    800025ae:	f022                	sd	s0,32(sp)
    800025b0:	ec26                	sd	s1,24(sp)
    800025b2:	e84a                	sd	s2,16(sp)
    800025b4:	e44e                	sd	s3,8(sp)
    800025b6:	1800                	addi	s0,sp,48
    800025b8:	892a                	mv	s2,a0
    800025ba:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800025bc:	0000f517          	auipc	a0,0xf
    800025c0:	ddc50513          	addi	a0,a0,-548 # 80011398 <bcache>
    800025c4:	00004097          	auipc	ra,0x4
    800025c8:	f78080e7          	jalr	-136(ra) # 8000653c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800025cc:	00017497          	auipc	s1,0x17
    800025d0:	0844b483          	ld	s1,132(s1) # 80019650 <bcache+0x82b8>
    800025d4:	00017797          	auipc	a5,0x17
    800025d8:	02c78793          	addi	a5,a5,44 # 80019600 <bcache+0x8268>
    800025dc:	02f48f63          	beq	s1,a5,8000261a <bread+0x70>
    800025e0:	873e                	mv	a4,a5
    800025e2:	a021                	j	800025ea <bread+0x40>
    800025e4:	68a4                	ld	s1,80(s1)
    800025e6:	02e48a63          	beq	s1,a4,8000261a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800025ea:	449c                	lw	a5,8(s1)
    800025ec:	ff279ce3          	bne	a5,s2,800025e4 <bread+0x3a>
    800025f0:	44dc                	lw	a5,12(s1)
    800025f2:	ff3799e3          	bne	a5,s3,800025e4 <bread+0x3a>
      b->refcnt++;
    800025f6:	40bc                	lw	a5,64(s1)
    800025f8:	2785                	addiw	a5,a5,1
    800025fa:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025fc:	0000f517          	auipc	a0,0xf
    80002600:	d9c50513          	addi	a0,a0,-612 # 80011398 <bcache>
    80002604:	00004097          	auipc	ra,0x4
    80002608:	fec080e7          	jalr	-20(ra) # 800065f0 <release>
      acquiresleep(&b->lock);
    8000260c:	01048513          	addi	a0,s1,16
    80002610:	00001097          	auipc	ra,0x1
    80002614:	492080e7          	jalr	1170(ra) # 80003aa2 <acquiresleep>
      return b;
    80002618:	a8b9                	j	80002676 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000261a:	00017497          	auipc	s1,0x17
    8000261e:	02e4b483          	ld	s1,46(s1) # 80019648 <bcache+0x82b0>
    80002622:	00017797          	auipc	a5,0x17
    80002626:	fde78793          	addi	a5,a5,-34 # 80019600 <bcache+0x8268>
    8000262a:	00f48863          	beq	s1,a5,8000263a <bread+0x90>
    8000262e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002630:	40bc                	lw	a5,64(s1)
    80002632:	cf81                	beqz	a5,8000264a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002634:	64a4                	ld	s1,72(s1)
    80002636:	fee49de3          	bne	s1,a4,80002630 <bread+0x86>
  panic("bget: no buffers");
    8000263a:	00006517          	auipc	a0,0x6
    8000263e:	dce50513          	addi	a0,a0,-562 # 80008408 <etext+0x408>
    80002642:	00004097          	auipc	ra,0x4
    80002646:	980080e7          	jalr	-1664(ra) # 80005fc2 <panic>
      b->dev = dev;
    8000264a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000264e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002652:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002656:	4785                	li	a5,1
    80002658:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000265a:	0000f517          	auipc	a0,0xf
    8000265e:	d3e50513          	addi	a0,a0,-706 # 80011398 <bcache>
    80002662:	00004097          	auipc	ra,0x4
    80002666:	f8e080e7          	jalr	-114(ra) # 800065f0 <release>
      acquiresleep(&b->lock);
    8000266a:	01048513          	addi	a0,s1,16
    8000266e:	00001097          	auipc	ra,0x1
    80002672:	434080e7          	jalr	1076(ra) # 80003aa2 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002676:	409c                	lw	a5,0(s1)
    80002678:	cb89                	beqz	a5,8000268a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000267a:	8526                	mv	a0,s1
    8000267c:	70a2                	ld	ra,40(sp)
    8000267e:	7402                	ld	s0,32(sp)
    80002680:	64e2                	ld	s1,24(sp)
    80002682:	6942                	ld	s2,16(sp)
    80002684:	69a2                	ld	s3,8(sp)
    80002686:	6145                	addi	sp,sp,48
    80002688:	8082                	ret
    virtio_disk_rw(b, 0);
    8000268a:	4581                	li	a1,0
    8000268c:	8526                	mv	a0,s1
    8000268e:	00003097          	auipc	ra,0x3
    80002692:	10a080e7          	jalr	266(ra) # 80005798 <virtio_disk_rw>
    b->valid = 1;
    80002696:	4785                	li	a5,1
    80002698:	c09c                	sw	a5,0(s1)
  return b;
    8000269a:	b7c5                	j	8000267a <bread+0xd0>

000000008000269c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000269c:	1101                	addi	sp,sp,-32
    8000269e:	ec06                	sd	ra,24(sp)
    800026a0:	e822                	sd	s0,16(sp)
    800026a2:	e426                	sd	s1,8(sp)
    800026a4:	1000                	addi	s0,sp,32
    800026a6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026a8:	0541                	addi	a0,a0,16
    800026aa:	00001097          	auipc	ra,0x1
    800026ae:	492080e7          	jalr	1170(ra) # 80003b3c <holdingsleep>
    800026b2:	cd01                	beqz	a0,800026ca <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800026b4:	4585                	li	a1,1
    800026b6:	8526                	mv	a0,s1
    800026b8:	00003097          	auipc	ra,0x3
    800026bc:	0e0080e7          	jalr	224(ra) # 80005798 <virtio_disk_rw>
}
    800026c0:	60e2                	ld	ra,24(sp)
    800026c2:	6442                	ld	s0,16(sp)
    800026c4:	64a2                	ld	s1,8(sp)
    800026c6:	6105                	addi	sp,sp,32
    800026c8:	8082                	ret
    panic("bwrite");
    800026ca:	00006517          	auipc	a0,0x6
    800026ce:	d5650513          	addi	a0,a0,-682 # 80008420 <etext+0x420>
    800026d2:	00004097          	auipc	ra,0x4
    800026d6:	8f0080e7          	jalr	-1808(ra) # 80005fc2 <panic>

00000000800026da <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800026da:	1101                	addi	sp,sp,-32
    800026dc:	ec06                	sd	ra,24(sp)
    800026de:	e822                	sd	s0,16(sp)
    800026e0:	e426                	sd	s1,8(sp)
    800026e2:	e04a                	sd	s2,0(sp)
    800026e4:	1000                	addi	s0,sp,32
    800026e6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026e8:	01050913          	addi	s2,a0,16
    800026ec:	854a                	mv	a0,s2
    800026ee:	00001097          	auipc	ra,0x1
    800026f2:	44e080e7          	jalr	1102(ra) # 80003b3c <holdingsleep>
    800026f6:	c925                	beqz	a0,80002766 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800026f8:	854a                	mv	a0,s2
    800026fa:	00001097          	auipc	ra,0x1
    800026fe:	3fe080e7          	jalr	1022(ra) # 80003af8 <releasesleep>

  acquire(&bcache.lock);
    80002702:	0000f517          	auipc	a0,0xf
    80002706:	c9650513          	addi	a0,a0,-874 # 80011398 <bcache>
    8000270a:	00004097          	auipc	ra,0x4
    8000270e:	e32080e7          	jalr	-462(ra) # 8000653c <acquire>
  b->refcnt--;
    80002712:	40bc                	lw	a5,64(s1)
    80002714:	37fd                	addiw	a5,a5,-1
    80002716:	0007871b          	sext.w	a4,a5
    8000271a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000271c:	e71d                	bnez	a4,8000274a <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000271e:	68b8                	ld	a4,80(s1)
    80002720:	64bc                	ld	a5,72(s1)
    80002722:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002724:	68b8                	ld	a4,80(s1)
    80002726:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002728:	00017797          	auipc	a5,0x17
    8000272c:	c7078793          	addi	a5,a5,-912 # 80019398 <bcache+0x8000>
    80002730:	2b87b703          	ld	a4,696(a5)
    80002734:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002736:	00017717          	auipc	a4,0x17
    8000273a:	eca70713          	addi	a4,a4,-310 # 80019600 <bcache+0x8268>
    8000273e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002740:	2b87b703          	ld	a4,696(a5)
    80002744:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002746:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000274a:	0000f517          	auipc	a0,0xf
    8000274e:	c4e50513          	addi	a0,a0,-946 # 80011398 <bcache>
    80002752:	00004097          	auipc	ra,0x4
    80002756:	e9e080e7          	jalr	-354(ra) # 800065f0 <release>
}
    8000275a:	60e2                	ld	ra,24(sp)
    8000275c:	6442                	ld	s0,16(sp)
    8000275e:	64a2                	ld	s1,8(sp)
    80002760:	6902                	ld	s2,0(sp)
    80002762:	6105                	addi	sp,sp,32
    80002764:	8082                	ret
    panic("brelse");
    80002766:	00006517          	auipc	a0,0x6
    8000276a:	cc250513          	addi	a0,a0,-830 # 80008428 <etext+0x428>
    8000276e:	00004097          	auipc	ra,0x4
    80002772:	854080e7          	jalr	-1964(ra) # 80005fc2 <panic>

0000000080002776 <bpin>:

void
bpin(struct buf *b) {
    80002776:	1101                	addi	sp,sp,-32
    80002778:	ec06                	sd	ra,24(sp)
    8000277a:	e822                	sd	s0,16(sp)
    8000277c:	e426                	sd	s1,8(sp)
    8000277e:	1000                	addi	s0,sp,32
    80002780:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002782:	0000f517          	auipc	a0,0xf
    80002786:	c1650513          	addi	a0,a0,-1002 # 80011398 <bcache>
    8000278a:	00004097          	auipc	ra,0x4
    8000278e:	db2080e7          	jalr	-590(ra) # 8000653c <acquire>
  b->refcnt++;
    80002792:	40bc                	lw	a5,64(s1)
    80002794:	2785                	addiw	a5,a5,1
    80002796:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002798:	0000f517          	auipc	a0,0xf
    8000279c:	c0050513          	addi	a0,a0,-1024 # 80011398 <bcache>
    800027a0:	00004097          	auipc	ra,0x4
    800027a4:	e50080e7          	jalr	-432(ra) # 800065f0 <release>
}
    800027a8:	60e2                	ld	ra,24(sp)
    800027aa:	6442                	ld	s0,16(sp)
    800027ac:	64a2                	ld	s1,8(sp)
    800027ae:	6105                	addi	sp,sp,32
    800027b0:	8082                	ret

00000000800027b2 <bunpin>:

void
bunpin(struct buf *b) {
    800027b2:	1101                	addi	sp,sp,-32
    800027b4:	ec06                	sd	ra,24(sp)
    800027b6:	e822                	sd	s0,16(sp)
    800027b8:	e426                	sd	s1,8(sp)
    800027ba:	1000                	addi	s0,sp,32
    800027bc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800027be:	0000f517          	auipc	a0,0xf
    800027c2:	bda50513          	addi	a0,a0,-1062 # 80011398 <bcache>
    800027c6:	00004097          	auipc	ra,0x4
    800027ca:	d76080e7          	jalr	-650(ra) # 8000653c <acquire>
  b->refcnt--;
    800027ce:	40bc                	lw	a5,64(s1)
    800027d0:	37fd                	addiw	a5,a5,-1
    800027d2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800027d4:	0000f517          	auipc	a0,0xf
    800027d8:	bc450513          	addi	a0,a0,-1084 # 80011398 <bcache>
    800027dc:	00004097          	auipc	ra,0x4
    800027e0:	e14080e7          	jalr	-492(ra) # 800065f0 <release>
}
    800027e4:	60e2                	ld	ra,24(sp)
    800027e6:	6442                	ld	s0,16(sp)
    800027e8:	64a2                	ld	s1,8(sp)
    800027ea:	6105                	addi	sp,sp,32
    800027ec:	8082                	ret

00000000800027ee <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800027ee:	1101                	addi	sp,sp,-32
    800027f0:	ec06                	sd	ra,24(sp)
    800027f2:	e822                	sd	s0,16(sp)
    800027f4:	e426                	sd	s1,8(sp)
    800027f6:	e04a                	sd	s2,0(sp)
    800027f8:	1000                	addi	s0,sp,32
    800027fa:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027fc:	00d5d59b          	srliw	a1,a1,0xd
    80002800:	00017797          	auipc	a5,0x17
    80002804:	2747a783          	lw	a5,628(a5) # 80019a74 <sb+0x1c>
    80002808:	9dbd                	addw	a1,a1,a5
    8000280a:	00000097          	auipc	ra,0x0
    8000280e:	da0080e7          	jalr	-608(ra) # 800025aa <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002812:	0074f713          	andi	a4,s1,7
    80002816:	4785                	li	a5,1
    80002818:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000281c:	14ce                	slli	s1,s1,0x33
    8000281e:	90d9                	srli	s1,s1,0x36
    80002820:	00950733          	add	a4,a0,s1
    80002824:	05874703          	lbu	a4,88(a4)
    80002828:	00e7f6b3          	and	a3,a5,a4
    8000282c:	c69d                	beqz	a3,8000285a <bfree+0x6c>
    8000282e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002830:	94aa                	add	s1,s1,a0
    80002832:	fff7c793          	not	a5,a5
    80002836:	8f7d                	and	a4,a4,a5
    80002838:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000283c:	00001097          	auipc	ra,0x1
    80002840:	148080e7          	jalr	328(ra) # 80003984 <log_write>
  brelse(bp);
    80002844:	854a                	mv	a0,s2
    80002846:	00000097          	auipc	ra,0x0
    8000284a:	e94080e7          	jalr	-364(ra) # 800026da <brelse>
}
    8000284e:	60e2                	ld	ra,24(sp)
    80002850:	6442                	ld	s0,16(sp)
    80002852:	64a2                	ld	s1,8(sp)
    80002854:	6902                	ld	s2,0(sp)
    80002856:	6105                	addi	sp,sp,32
    80002858:	8082                	ret
    panic("freeing free block");
    8000285a:	00006517          	auipc	a0,0x6
    8000285e:	bd650513          	addi	a0,a0,-1066 # 80008430 <etext+0x430>
    80002862:	00003097          	auipc	ra,0x3
    80002866:	760080e7          	jalr	1888(ra) # 80005fc2 <panic>

000000008000286a <balloc>:
{
    8000286a:	711d                	addi	sp,sp,-96
    8000286c:	ec86                	sd	ra,88(sp)
    8000286e:	e8a2                	sd	s0,80(sp)
    80002870:	e4a6                	sd	s1,72(sp)
    80002872:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002874:	00017797          	auipc	a5,0x17
    80002878:	1e87a783          	lw	a5,488(a5) # 80019a5c <sb+0x4>
    8000287c:	10078f63          	beqz	a5,8000299a <balloc+0x130>
    80002880:	e0ca                	sd	s2,64(sp)
    80002882:	fc4e                	sd	s3,56(sp)
    80002884:	f852                	sd	s4,48(sp)
    80002886:	f456                	sd	s5,40(sp)
    80002888:	f05a                	sd	s6,32(sp)
    8000288a:	ec5e                	sd	s7,24(sp)
    8000288c:	e862                	sd	s8,16(sp)
    8000288e:	e466                	sd	s9,8(sp)
    80002890:	8baa                	mv	s7,a0
    80002892:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002894:	00017b17          	auipc	s6,0x17
    80002898:	1c4b0b13          	addi	s6,s6,452 # 80019a58 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000289c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000289e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028a0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800028a2:	6c89                	lui	s9,0x2
    800028a4:	a061                	j	8000292c <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800028a6:	97ca                	add	a5,a5,s2
    800028a8:	8e55                	or	a2,a2,a3
    800028aa:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800028ae:	854a                	mv	a0,s2
    800028b0:	00001097          	auipc	ra,0x1
    800028b4:	0d4080e7          	jalr	212(ra) # 80003984 <log_write>
        brelse(bp);
    800028b8:	854a                	mv	a0,s2
    800028ba:	00000097          	auipc	ra,0x0
    800028be:	e20080e7          	jalr	-480(ra) # 800026da <brelse>
  bp = bread(dev, bno);
    800028c2:	85a6                	mv	a1,s1
    800028c4:	855e                	mv	a0,s7
    800028c6:	00000097          	auipc	ra,0x0
    800028ca:	ce4080e7          	jalr	-796(ra) # 800025aa <bread>
    800028ce:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028d0:	40000613          	li	a2,1024
    800028d4:	4581                	li	a1,0
    800028d6:	05850513          	addi	a0,a0,88
    800028da:	ffffe097          	auipc	ra,0xffffe
    800028de:	8a0080e7          	jalr	-1888(ra) # 8000017a <memset>
  log_write(bp);
    800028e2:	854a                	mv	a0,s2
    800028e4:	00001097          	auipc	ra,0x1
    800028e8:	0a0080e7          	jalr	160(ra) # 80003984 <log_write>
  brelse(bp);
    800028ec:	854a                	mv	a0,s2
    800028ee:	00000097          	auipc	ra,0x0
    800028f2:	dec080e7          	jalr	-532(ra) # 800026da <brelse>
}
    800028f6:	6906                	ld	s2,64(sp)
    800028f8:	79e2                	ld	s3,56(sp)
    800028fa:	7a42                	ld	s4,48(sp)
    800028fc:	7aa2                	ld	s5,40(sp)
    800028fe:	7b02                	ld	s6,32(sp)
    80002900:	6be2                	ld	s7,24(sp)
    80002902:	6c42                	ld	s8,16(sp)
    80002904:	6ca2                	ld	s9,8(sp)
}
    80002906:	8526                	mv	a0,s1
    80002908:	60e6                	ld	ra,88(sp)
    8000290a:	6446                	ld	s0,80(sp)
    8000290c:	64a6                	ld	s1,72(sp)
    8000290e:	6125                	addi	sp,sp,96
    80002910:	8082                	ret
    brelse(bp);
    80002912:	854a                	mv	a0,s2
    80002914:	00000097          	auipc	ra,0x0
    80002918:	dc6080e7          	jalr	-570(ra) # 800026da <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000291c:	015c87bb          	addw	a5,s9,s5
    80002920:	00078a9b          	sext.w	s5,a5
    80002924:	004b2703          	lw	a4,4(s6)
    80002928:	06eaf163          	bgeu	s5,a4,8000298a <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    8000292c:	41fad79b          	sraiw	a5,s5,0x1f
    80002930:	0137d79b          	srliw	a5,a5,0x13
    80002934:	015787bb          	addw	a5,a5,s5
    80002938:	40d7d79b          	sraiw	a5,a5,0xd
    8000293c:	01cb2583          	lw	a1,28(s6)
    80002940:	9dbd                	addw	a1,a1,a5
    80002942:	855e                	mv	a0,s7
    80002944:	00000097          	auipc	ra,0x0
    80002948:	c66080e7          	jalr	-922(ra) # 800025aa <bread>
    8000294c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000294e:	004b2503          	lw	a0,4(s6)
    80002952:	000a849b          	sext.w	s1,s5
    80002956:	8762                	mv	a4,s8
    80002958:	faa4fde3          	bgeu	s1,a0,80002912 <balloc+0xa8>
      m = 1 << (bi % 8);
    8000295c:	00777693          	andi	a3,a4,7
    80002960:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002964:	41f7579b          	sraiw	a5,a4,0x1f
    80002968:	01d7d79b          	srliw	a5,a5,0x1d
    8000296c:	9fb9                	addw	a5,a5,a4
    8000296e:	4037d79b          	sraiw	a5,a5,0x3
    80002972:	00f90633          	add	a2,s2,a5
    80002976:	05864603          	lbu	a2,88(a2)
    8000297a:	00c6f5b3          	and	a1,a3,a2
    8000297e:	d585                	beqz	a1,800028a6 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002980:	2705                	addiw	a4,a4,1
    80002982:	2485                	addiw	s1,s1,1
    80002984:	fd471ae3          	bne	a4,s4,80002958 <balloc+0xee>
    80002988:	b769                	j	80002912 <balloc+0xa8>
    8000298a:	6906                	ld	s2,64(sp)
    8000298c:	79e2                	ld	s3,56(sp)
    8000298e:	7a42                	ld	s4,48(sp)
    80002990:	7aa2                	ld	s5,40(sp)
    80002992:	7b02                	ld	s6,32(sp)
    80002994:	6be2                	ld	s7,24(sp)
    80002996:	6c42                	ld	s8,16(sp)
    80002998:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    8000299a:	00006517          	auipc	a0,0x6
    8000299e:	aae50513          	addi	a0,a0,-1362 # 80008448 <etext+0x448>
    800029a2:	00003097          	auipc	ra,0x3
    800029a6:	66a080e7          	jalr	1642(ra) # 8000600c <printf>
  return 0;
    800029aa:	4481                	li	s1,0
    800029ac:	bfa9                	j	80002906 <balloc+0x9c>

00000000800029ae <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800029ae:	7179                	addi	sp,sp,-48
    800029b0:	f406                	sd	ra,40(sp)
    800029b2:	f022                	sd	s0,32(sp)
    800029b4:	ec26                	sd	s1,24(sp)
    800029b6:	e84a                	sd	s2,16(sp)
    800029b8:	e44e                	sd	s3,8(sp)
    800029ba:	1800                	addi	s0,sp,48
    800029bc:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800029be:	47ad                	li	a5,11
    800029c0:	02b7e863          	bltu	a5,a1,800029f0 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    800029c4:	02059793          	slli	a5,a1,0x20
    800029c8:	01e7d593          	srli	a1,a5,0x1e
    800029cc:	00b504b3          	add	s1,a0,a1
    800029d0:	0504a903          	lw	s2,80(s1)
    800029d4:	08091263          	bnez	s2,80002a58 <bmap+0xaa>
      addr = balloc(ip->dev);
    800029d8:	4108                	lw	a0,0(a0)
    800029da:	00000097          	auipc	ra,0x0
    800029de:	e90080e7          	jalr	-368(ra) # 8000286a <balloc>
    800029e2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800029e6:	06090963          	beqz	s2,80002a58 <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    800029ea:	0524a823          	sw	s2,80(s1)
    800029ee:	a0ad                	j	80002a58 <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    800029f0:	ff45849b          	addiw	s1,a1,-12
    800029f4:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800029f8:	0ff00793          	li	a5,255
    800029fc:	08e7e863          	bltu	a5,a4,80002a8c <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002a00:	08052903          	lw	s2,128(a0)
    80002a04:	00091f63          	bnez	s2,80002a22 <bmap+0x74>
      addr = balloc(ip->dev);
    80002a08:	4108                	lw	a0,0(a0)
    80002a0a:	00000097          	auipc	ra,0x0
    80002a0e:	e60080e7          	jalr	-416(ra) # 8000286a <balloc>
    80002a12:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002a16:	04090163          	beqz	s2,80002a58 <bmap+0xaa>
    80002a1a:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002a1c:	0929a023          	sw	s2,128(s3)
    80002a20:	a011                	j	80002a24 <bmap+0x76>
    80002a22:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002a24:	85ca                	mv	a1,s2
    80002a26:	0009a503          	lw	a0,0(s3)
    80002a2a:	00000097          	auipc	ra,0x0
    80002a2e:	b80080e7          	jalr	-1152(ra) # 800025aa <bread>
    80002a32:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002a34:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002a38:	02049713          	slli	a4,s1,0x20
    80002a3c:	01e75593          	srli	a1,a4,0x1e
    80002a40:	00b784b3          	add	s1,a5,a1
    80002a44:	0004a903          	lw	s2,0(s1)
    80002a48:	02090063          	beqz	s2,80002a68 <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002a4c:	8552                	mv	a0,s4
    80002a4e:	00000097          	auipc	ra,0x0
    80002a52:	c8c080e7          	jalr	-884(ra) # 800026da <brelse>
    return addr;
    80002a56:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002a58:	854a                	mv	a0,s2
    80002a5a:	70a2                	ld	ra,40(sp)
    80002a5c:	7402                	ld	s0,32(sp)
    80002a5e:	64e2                	ld	s1,24(sp)
    80002a60:	6942                	ld	s2,16(sp)
    80002a62:	69a2                	ld	s3,8(sp)
    80002a64:	6145                	addi	sp,sp,48
    80002a66:	8082                	ret
      addr = balloc(ip->dev);
    80002a68:	0009a503          	lw	a0,0(s3)
    80002a6c:	00000097          	auipc	ra,0x0
    80002a70:	dfe080e7          	jalr	-514(ra) # 8000286a <balloc>
    80002a74:	0005091b          	sext.w	s2,a0
      if(addr){
    80002a78:	fc090ae3          	beqz	s2,80002a4c <bmap+0x9e>
        a[bn] = addr;
    80002a7c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002a80:	8552                	mv	a0,s4
    80002a82:	00001097          	auipc	ra,0x1
    80002a86:	f02080e7          	jalr	-254(ra) # 80003984 <log_write>
    80002a8a:	b7c9                	j	80002a4c <bmap+0x9e>
    80002a8c:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002a8e:	00006517          	auipc	a0,0x6
    80002a92:	9d250513          	addi	a0,a0,-1582 # 80008460 <etext+0x460>
    80002a96:	00003097          	auipc	ra,0x3
    80002a9a:	52c080e7          	jalr	1324(ra) # 80005fc2 <panic>

0000000080002a9e <iget>:
{
    80002a9e:	7179                	addi	sp,sp,-48
    80002aa0:	f406                	sd	ra,40(sp)
    80002aa2:	f022                	sd	s0,32(sp)
    80002aa4:	ec26                	sd	s1,24(sp)
    80002aa6:	e84a                	sd	s2,16(sp)
    80002aa8:	e44e                	sd	s3,8(sp)
    80002aaa:	e052                	sd	s4,0(sp)
    80002aac:	1800                	addi	s0,sp,48
    80002aae:	89aa                	mv	s3,a0
    80002ab0:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002ab2:	00017517          	auipc	a0,0x17
    80002ab6:	fc650513          	addi	a0,a0,-58 # 80019a78 <itable>
    80002aba:	00004097          	auipc	ra,0x4
    80002abe:	a82080e7          	jalr	-1406(ra) # 8000653c <acquire>
  empty = 0;
    80002ac2:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002ac4:	00017497          	auipc	s1,0x17
    80002ac8:	fcc48493          	addi	s1,s1,-52 # 80019a90 <itable+0x18>
    80002acc:	00019697          	auipc	a3,0x19
    80002ad0:	a5468693          	addi	a3,a3,-1452 # 8001b520 <log>
    80002ad4:	a039                	j	80002ae2 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002ad6:	02090b63          	beqz	s2,80002b0c <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002ada:	08848493          	addi	s1,s1,136
    80002ade:	02d48a63          	beq	s1,a3,80002b12 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002ae2:	449c                	lw	a5,8(s1)
    80002ae4:	fef059e3          	blez	a5,80002ad6 <iget+0x38>
    80002ae8:	4098                	lw	a4,0(s1)
    80002aea:	ff3716e3          	bne	a4,s3,80002ad6 <iget+0x38>
    80002aee:	40d8                	lw	a4,4(s1)
    80002af0:	ff4713e3          	bne	a4,s4,80002ad6 <iget+0x38>
      ip->ref++;
    80002af4:	2785                	addiw	a5,a5,1
    80002af6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002af8:	00017517          	auipc	a0,0x17
    80002afc:	f8050513          	addi	a0,a0,-128 # 80019a78 <itable>
    80002b00:	00004097          	auipc	ra,0x4
    80002b04:	af0080e7          	jalr	-1296(ra) # 800065f0 <release>
      return ip;
    80002b08:	8926                	mv	s2,s1
    80002b0a:	a03d                	j	80002b38 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b0c:	f7f9                	bnez	a5,80002ada <iget+0x3c>
      empty = ip;
    80002b0e:	8926                	mv	s2,s1
    80002b10:	b7e9                	j	80002ada <iget+0x3c>
  if(empty == 0)
    80002b12:	02090c63          	beqz	s2,80002b4a <iget+0xac>
  ip->dev = dev;
    80002b16:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002b1a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002b1e:	4785                	li	a5,1
    80002b20:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002b24:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002b28:	00017517          	auipc	a0,0x17
    80002b2c:	f5050513          	addi	a0,a0,-176 # 80019a78 <itable>
    80002b30:	00004097          	auipc	ra,0x4
    80002b34:	ac0080e7          	jalr	-1344(ra) # 800065f0 <release>
}
    80002b38:	854a                	mv	a0,s2
    80002b3a:	70a2                	ld	ra,40(sp)
    80002b3c:	7402                	ld	s0,32(sp)
    80002b3e:	64e2                	ld	s1,24(sp)
    80002b40:	6942                	ld	s2,16(sp)
    80002b42:	69a2                	ld	s3,8(sp)
    80002b44:	6a02                	ld	s4,0(sp)
    80002b46:	6145                	addi	sp,sp,48
    80002b48:	8082                	ret
    panic("iget: no inodes");
    80002b4a:	00006517          	auipc	a0,0x6
    80002b4e:	92e50513          	addi	a0,a0,-1746 # 80008478 <etext+0x478>
    80002b52:	00003097          	auipc	ra,0x3
    80002b56:	470080e7          	jalr	1136(ra) # 80005fc2 <panic>

0000000080002b5a <fsinit>:
fsinit(int dev) {
    80002b5a:	7179                	addi	sp,sp,-48
    80002b5c:	f406                	sd	ra,40(sp)
    80002b5e:	f022                	sd	s0,32(sp)
    80002b60:	ec26                	sd	s1,24(sp)
    80002b62:	e84a                	sd	s2,16(sp)
    80002b64:	e44e                	sd	s3,8(sp)
    80002b66:	1800                	addi	s0,sp,48
    80002b68:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b6a:	4585                	li	a1,1
    80002b6c:	00000097          	auipc	ra,0x0
    80002b70:	a3e080e7          	jalr	-1474(ra) # 800025aa <bread>
    80002b74:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b76:	00017997          	auipc	s3,0x17
    80002b7a:	ee298993          	addi	s3,s3,-286 # 80019a58 <sb>
    80002b7e:	02000613          	li	a2,32
    80002b82:	05850593          	addi	a1,a0,88
    80002b86:	854e                	mv	a0,s3
    80002b88:	ffffd097          	auipc	ra,0xffffd
    80002b8c:	64e080e7          	jalr	1614(ra) # 800001d6 <memmove>
  brelse(bp);
    80002b90:	8526                	mv	a0,s1
    80002b92:	00000097          	auipc	ra,0x0
    80002b96:	b48080e7          	jalr	-1208(ra) # 800026da <brelse>
  if(sb.magic != FSMAGIC)
    80002b9a:	0009a703          	lw	a4,0(s3)
    80002b9e:	102037b7          	lui	a5,0x10203
    80002ba2:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002ba6:	02f71263          	bne	a4,a5,80002bca <fsinit+0x70>
  initlog(dev, &sb);
    80002baa:	00017597          	auipc	a1,0x17
    80002bae:	eae58593          	addi	a1,a1,-338 # 80019a58 <sb>
    80002bb2:	854a                	mv	a0,s2
    80002bb4:	00001097          	auipc	ra,0x1
    80002bb8:	b60080e7          	jalr	-1184(ra) # 80003714 <initlog>
}
    80002bbc:	70a2                	ld	ra,40(sp)
    80002bbe:	7402                	ld	s0,32(sp)
    80002bc0:	64e2                	ld	s1,24(sp)
    80002bc2:	6942                	ld	s2,16(sp)
    80002bc4:	69a2                	ld	s3,8(sp)
    80002bc6:	6145                	addi	sp,sp,48
    80002bc8:	8082                	ret
    panic("invalid file system");
    80002bca:	00006517          	auipc	a0,0x6
    80002bce:	8be50513          	addi	a0,a0,-1858 # 80008488 <etext+0x488>
    80002bd2:	00003097          	auipc	ra,0x3
    80002bd6:	3f0080e7          	jalr	1008(ra) # 80005fc2 <panic>

0000000080002bda <iinit>:
{
    80002bda:	7179                	addi	sp,sp,-48
    80002bdc:	f406                	sd	ra,40(sp)
    80002bde:	f022                	sd	s0,32(sp)
    80002be0:	ec26                	sd	s1,24(sp)
    80002be2:	e84a                	sd	s2,16(sp)
    80002be4:	e44e                	sd	s3,8(sp)
    80002be6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002be8:	00006597          	auipc	a1,0x6
    80002bec:	8b858593          	addi	a1,a1,-1864 # 800084a0 <etext+0x4a0>
    80002bf0:	00017517          	auipc	a0,0x17
    80002bf4:	e8850513          	addi	a0,a0,-376 # 80019a78 <itable>
    80002bf8:	00004097          	auipc	ra,0x4
    80002bfc:	8b4080e7          	jalr	-1868(ra) # 800064ac <initlock>
  for(i = 0; i < NINODE; i++) {
    80002c00:	00017497          	auipc	s1,0x17
    80002c04:	ea048493          	addi	s1,s1,-352 # 80019aa0 <itable+0x28>
    80002c08:	00019997          	auipc	s3,0x19
    80002c0c:	92898993          	addi	s3,s3,-1752 # 8001b530 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002c10:	00006917          	auipc	s2,0x6
    80002c14:	89890913          	addi	s2,s2,-1896 # 800084a8 <etext+0x4a8>
    80002c18:	85ca                	mv	a1,s2
    80002c1a:	8526                	mv	a0,s1
    80002c1c:	00001097          	auipc	ra,0x1
    80002c20:	e4c080e7          	jalr	-436(ra) # 80003a68 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002c24:	08848493          	addi	s1,s1,136
    80002c28:	ff3498e3          	bne	s1,s3,80002c18 <iinit+0x3e>
}
    80002c2c:	70a2                	ld	ra,40(sp)
    80002c2e:	7402                	ld	s0,32(sp)
    80002c30:	64e2                	ld	s1,24(sp)
    80002c32:	6942                	ld	s2,16(sp)
    80002c34:	69a2                	ld	s3,8(sp)
    80002c36:	6145                	addi	sp,sp,48
    80002c38:	8082                	ret

0000000080002c3a <ialloc>:
{
    80002c3a:	7139                	addi	sp,sp,-64
    80002c3c:	fc06                	sd	ra,56(sp)
    80002c3e:	f822                	sd	s0,48(sp)
    80002c40:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c42:	00017717          	auipc	a4,0x17
    80002c46:	e2272703          	lw	a4,-478(a4) # 80019a64 <sb+0xc>
    80002c4a:	4785                	li	a5,1
    80002c4c:	06e7f463          	bgeu	a5,a4,80002cb4 <ialloc+0x7a>
    80002c50:	f426                	sd	s1,40(sp)
    80002c52:	f04a                	sd	s2,32(sp)
    80002c54:	ec4e                	sd	s3,24(sp)
    80002c56:	e852                	sd	s4,16(sp)
    80002c58:	e456                	sd	s5,8(sp)
    80002c5a:	e05a                	sd	s6,0(sp)
    80002c5c:	8aaa                	mv	s5,a0
    80002c5e:	8b2e                	mv	s6,a1
    80002c60:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002c62:	00017a17          	auipc	s4,0x17
    80002c66:	df6a0a13          	addi	s4,s4,-522 # 80019a58 <sb>
    80002c6a:	00495593          	srli	a1,s2,0x4
    80002c6e:	018a2783          	lw	a5,24(s4)
    80002c72:	9dbd                	addw	a1,a1,a5
    80002c74:	8556                	mv	a0,s5
    80002c76:	00000097          	auipc	ra,0x0
    80002c7a:	934080e7          	jalr	-1740(ra) # 800025aa <bread>
    80002c7e:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c80:	05850993          	addi	s3,a0,88
    80002c84:	00f97793          	andi	a5,s2,15
    80002c88:	079a                	slli	a5,a5,0x6
    80002c8a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c8c:	00099783          	lh	a5,0(s3)
    80002c90:	cf9d                	beqz	a5,80002cce <ialloc+0x94>
    brelse(bp);
    80002c92:	00000097          	auipc	ra,0x0
    80002c96:	a48080e7          	jalr	-1464(ra) # 800026da <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c9a:	0905                	addi	s2,s2,1
    80002c9c:	00ca2703          	lw	a4,12(s4)
    80002ca0:	0009079b          	sext.w	a5,s2
    80002ca4:	fce7e3e3          	bltu	a5,a4,80002c6a <ialloc+0x30>
    80002ca8:	74a2                	ld	s1,40(sp)
    80002caa:	7902                	ld	s2,32(sp)
    80002cac:	69e2                	ld	s3,24(sp)
    80002cae:	6a42                	ld	s4,16(sp)
    80002cb0:	6aa2                	ld	s5,8(sp)
    80002cb2:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002cb4:	00005517          	auipc	a0,0x5
    80002cb8:	7fc50513          	addi	a0,a0,2044 # 800084b0 <etext+0x4b0>
    80002cbc:	00003097          	auipc	ra,0x3
    80002cc0:	350080e7          	jalr	848(ra) # 8000600c <printf>
  return 0;
    80002cc4:	4501                	li	a0,0
}
    80002cc6:	70e2                	ld	ra,56(sp)
    80002cc8:	7442                	ld	s0,48(sp)
    80002cca:	6121                	addi	sp,sp,64
    80002ccc:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002cce:	04000613          	li	a2,64
    80002cd2:	4581                	li	a1,0
    80002cd4:	854e                	mv	a0,s3
    80002cd6:	ffffd097          	auipc	ra,0xffffd
    80002cda:	4a4080e7          	jalr	1188(ra) # 8000017a <memset>
      dip->type = type;
    80002cde:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ce2:	8526                	mv	a0,s1
    80002ce4:	00001097          	auipc	ra,0x1
    80002ce8:	ca0080e7          	jalr	-864(ra) # 80003984 <log_write>
      brelse(bp);
    80002cec:	8526                	mv	a0,s1
    80002cee:	00000097          	auipc	ra,0x0
    80002cf2:	9ec080e7          	jalr	-1556(ra) # 800026da <brelse>
      return iget(dev, inum);
    80002cf6:	0009059b          	sext.w	a1,s2
    80002cfa:	8556                	mv	a0,s5
    80002cfc:	00000097          	auipc	ra,0x0
    80002d00:	da2080e7          	jalr	-606(ra) # 80002a9e <iget>
    80002d04:	74a2                	ld	s1,40(sp)
    80002d06:	7902                	ld	s2,32(sp)
    80002d08:	69e2                	ld	s3,24(sp)
    80002d0a:	6a42                	ld	s4,16(sp)
    80002d0c:	6aa2                	ld	s5,8(sp)
    80002d0e:	6b02                	ld	s6,0(sp)
    80002d10:	bf5d                	j	80002cc6 <ialloc+0x8c>

0000000080002d12 <iupdate>:
{
    80002d12:	1101                	addi	sp,sp,-32
    80002d14:	ec06                	sd	ra,24(sp)
    80002d16:	e822                	sd	s0,16(sp)
    80002d18:	e426                	sd	s1,8(sp)
    80002d1a:	e04a                	sd	s2,0(sp)
    80002d1c:	1000                	addi	s0,sp,32
    80002d1e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d20:	415c                	lw	a5,4(a0)
    80002d22:	0047d79b          	srliw	a5,a5,0x4
    80002d26:	00017597          	auipc	a1,0x17
    80002d2a:	d4a5a583          	lw	a1,-694(a1) # 80019a70 <sb+0x18>
    80002d2e:	9dbd                	addw	a1,a1,a5
    80002d30:	4108                	lw	a0,0(a0)
    80002d32:	00000097          	auipc	ra,0x0
    80002d36:	878080e7          	jalr	-1928(ra) # 800025aa <bread>
    80002d3a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d3c:	05850793          	addi	a5,a0,88
    80002d40:	40d8                	lw	a4,4(s1)
    80002d42:	8b3d                	andi	a4,a4,15
    80002d44:	071a                	slli	a4,a4,0x6
    80002d46:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002d48:	04449703          	lh	a4,68(s1)
    80002d4c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002d50:	04649703          	lh	a4,70(s1)
    80002d54:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002d58:	04849703          	lh	a4,72(s1)
    80002d5c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002d60:	04a49703          	lh	a4,74(s1)
    80002d64:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002d68:	44f8                	lw	a4,76(s1)
    80002d6a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002d6c:	03400613          	li	a2,52
    80002d70:	05048593          	addi	a1,s1,80
    80002d74:	00c78513          	addi	a0,a5,12
    80002d78:	ffffd097          	auipc	ra,0xffffd
    80002d7c:	45e080e7          	jalr	1118(ra) # 800001d6 <memmove>
  log_write(bp);
    80002d80:	854a                	mv	a0,s2
    80002d82:	00001097          	auipc	ra,0x1
    80002d86:	c02080e7          	jalr	-1022(ra) # 80003984 <log_write>
  brelse(bp);
    80002d8a:	854a                	mv	a0,s2
    80002d8c:	00000097          	auipc	ra,0x0
    80002d90:	94e080e7          	jalr	-1714(ra) # 800026da <brelse>
}
    80002d94:	60e2                	ld	ra,24(sp)
    80002d96:	6442                	ld	s0,16(sp)
    80002d98:	64a2                	ld	s1,8(sp)
    80002d9a:	6902                	ld	s2,0(sp)
    80002d9c:	6105                	addi	sp,sp,32
    80002d9e:	8082                	ret

0000000080002da0 <idup>:
{
    80002da0:	1101                	addi	sp,sp,-32
    80002da2:	ec06                	sd	ra,24(sp)
    80002da4:	e822                	sd	s0,16(sp)
    80002da6:	e426                	sd	s1,8(sp)
    80002da8:	1000                	addi	s0,sp,32
    80002daa:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dac:	00017517          	auipc	a0,0x17
    80002db0:	ccc50513          	addi	a0,a0,-820 # 80019a78 <itable>
    80002db4:	00003097          	auipc	ra,0x3
    80002db8:	788080e7          	jalr	1928(ra) # 8000653c <acquire>
  ip->ref++;
    80002dbc:	449c                	lw	a5,8(s1)
    80002dbe:	2785                	addiw	a5,a5,1
    80002dc0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dc2:	00017517          	auipc	a0,0x17
    80002dc6:	cb650513          	addi	a0,a0,-842 # 80019a78 <itable>
    80002dca:	00004097          	auipc	ra,0x4
    80002dce:	826080e7          	jalr	-2010(ra) # 800065f0 <release>
}
    80002dd2:	8526                	mv	a0,s1
    80002dd4:	60e2                	ld	ra,24(sp)
    80002dd6:	6442                	ld	s0,16(sp)
    80002dd8:	64a2                	ld	s1,8(sp)
    80002dda:	6105                	addi	sp,sp,32
    80002ddc:	8082                	ret

0000000080002dde <ilock>:
{
    80002dde:	1101                	addi	sp,sp,-32
    80002de0:	ec06                	sd	ra,24(sp)
    80002de2:	e822                	sd	s0,16(sp)
    80002de4:	e426                	sd	s1,8(sp)
    80002de6:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002de8:	c10d                	beqz	a0,80002e0a <ilock+0x2c>
    80002dea:	84aa                	mv	s1,a0
    80002dec:	451c                	lw	a5,8(a0)
    80002dee:	00f05e63          	blez	a5,80002e0a <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002df2:	0541                	addi	a0,a0,16
    80002df4:	00001097          	auipc	ra,0x1
    80002df8:	cae080e7          	jalr	-850(ra) # 80003aa2 <acquiresleep>
  if(ip->valid == 0){
    80002dfc:	40bc                	lw	a5,64(s1)
    80002dfe:	cf99                	beqz	a5,80002e1c <ilock+0x3e>
}
    80002e00:	60e2                	ld	ra,24(sp)
    80002e02:	6442                	ld	s0,16(sp)
    80002e04:	64a2                	ld	s1,8(sp)
    80002e06:	6105                	addi	sp,sp,32
    80002e08:	8082                	ret
    80002e0a:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002e0c:	00005517          	auipc	a0,0x5
    80002e10:	6bc50513          	addi	a0,a0,1724 # 800084c8 <etext+0x4c8>
    80002e14:	00003097          	auipc	ra,0x3
    80002e18:	1ae080e7          	jalr	430(ra) # 80005fc2 <panic>
    80002e1c:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e1e:	40dc                	lw	a5,4(s1)
    80002e20:	0047d79b          	srliw	a5,a5,0x4
    80002e24:	00017597          	auipc	a1,0x17
    80002e28:	c4c5a583          	lw	a1,-948(a1) # 80019a70 <sb+0x18>
    80002e2c:	9dbd                	addw	a1,a1,a5
    80002e2e:	4088                	lw	a0,0(s1)
    80002e30:	fffff097          	auipc	ra,0xfffff
    80002e34:	77a080e7          	jalr	1914(ra) # 800025aa <bread>
    80002e38:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002e3a:	05850593          	addi	a1,a0,88
    80002e3e:	40dc                	lw	a5,4(s1)
    80002e40:	8bbd                	andi	a5,a5,15
    80002e42:	079a                	slli	a5,a5,0x6
    80002e44:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002e46:	00059783          	lh	a5,0(a1)
    80002e4a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002e4e:	00259783          	lh	a5,2(a1)
    80002e52:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002e56:	00459783          	lh	a5,4(a1)
    80002e5a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002e5e:	00659783          	lh	a5,6(a1)
    80002e62:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002e66:	459c                	lw	a5,8(a1)
    80002e68:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002e6a:	03400613          	li	a2,52
    80002e6e:	05b1                	addi	a1,a1,12
    80002e70:	05048513          	addi	a0,s1,80
    80002e74:	ffffd097          	auipc	ra,0xffffd
    80002e78:	362080e7          	jalr	866(ra) # 800001d6 <memmove>
    brelse(bp);
    80002e7c:	854a                	mv	a0,s2
    80002e7e:	00000097          	auipc	ra,0x0
    80002e82:	85c080e7          	jalr	-1956(ra) # 800026da <brelse>
    ip->valid = 1;
    80002e86:	4785                	li	a5,1
    80002e88:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e8a:	04449783          	lh	a5,68(s1)
    80002e8e:	c399                	beqz	a5,80002e94 <ilock+0xb6>
    80002e90:	6902                	ld	s2,0(sp)
    80002e92:	b7bd                	j	80002e00 <ilock+0x22>
      panic("ilock: no type");
    80002e94:	00005517          	auipc	a0,0x5
    80002e98:	63c50513          	addi	a0,a0,1596 # 800084d0 <etext+0x4d0>
    80002e9c:	00003097          	auipc	ra,0x3
    80002ea0:	126080e7          	jalr	294(ra) # 80005fc2 <panic>

0000000080002ea4 <iunlock>:
{
    80002ea4:	1101                	addi	sp,sp,-32
    80002ea6:	ec06                	sd	ra,24(sp)
    80002ea8:	e822                	sd	s0,16(sp)
    80002eaa:	e426                	sd	s1,8(sp)
    80002eac:	e04a                	sd	s2,0(sp)
    80002eae:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002eb0:	c905                	beqz	a0,80002ee0 <iunlock+0x3c>
    80002eb2:	84aa                	mv	s1,a0
    80002eb4:	01050913          	addi	s2,a0,16
    80002eb8:	854a                	mv	a0,s2
    80002eba:	00001097          	auipc	ra,0x1
    80002ebe:	c82080e7          	jalr	-894(ra) # 80003b3c <holdingsleep>
    80002ec2:	cd19                	beqz	a0,80002ee0 <iunlock+0x3c>
    80002ec4:	449c                	lw	a5,8(s1)
    80002ec6:	00f05d63          	blez	a5,80002ee0 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002eca:	854a                	mv	a0,s2
    80002ecc:	00001097          	auipc	ra,0x1
    80002ed0:	c2c080e7          	jalr	-980(ra) # 80003af8 <releasesleep>
}
    80002ed4:	60e2                	ld	ra,24(sp)
    80002ed6:	6442                	ld	s0,16(sp)
    80002ed8:	64a2                	ld	s1,8(sp)
    80002eda:	6902                	ld	s2,0(sp)
    80002edc:	6105                	addi	sp,sp,32
    80002ede:	8082                	ret
    panic("iunlock");
    80002ee0:	00005517          	auipc	a0,0x5
    80002ee4:	60050513          	addi	a0,a0,1536 # 800084e0 <etext+0x4e0>
    80002ee8:	00003097          	auipc	ra,0x3
    80002eec:	0da080e7          	jalr	218(ra) # 80005fc2 <panic>

0000000080002ef0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002ef0:	7179                	addi	sp,sp,-48
    80002ef2:	f406                	sd	ra,40(sp)
    80002ef4:	f022                	sd	s0,32(sp)
    80002ef6:	ec26                	sd	s1,24(sp)
    80002ef8:	e84a                	sd	s2,16(sp)
    80002efa:	e44e                	sd	s3,8(sp)
    80002efc:	1800                	addi	s0,sp,48
    80002efe:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002f00:	05050493          	addi	s1,a0,80
    80002f04:	08050913          	addi	s2,a0,128
    80002f08:	a021                	j	80002f10 <itrunc+0x20>
    80002f0a:	0491                	addi	s1,s1,4
    80002f0c:	01248d63          	beq	s1,s2,80002f26 <itrunc+0x36>
    if(ip->addrs[i]){
    80002f10:	408c                	lw	a1,0(s1)
    80002f12:	dde5                	beqz	a1,80002f0a <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002f14:	0009a503          	lw	a0,0(s3)
    80002f18:	00000097          	auipc	ra,0x0
    80002f1c:	8d6080e7          	jalr	-1834(ra) # 800027ee <bfree>
      ip->addrs[i] = 0;
    80002f20:	0004a023          	sw	zero,0(s1)
    80002f24:	b7dd                	j	80002f0a <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002f26:	0809a583          	lw	a1,128(s3)
    80002f2a:	ed99                	bnez	a1,80002f48 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002f2c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002f30:	854e                	mv	a0,s3
    80002f32:	00000097          	auipc	ra,0x0
    80002f36:	de0080e7          	jalr	-544(ra) # 80002d12 <iupdate>
}
    80002f3a:	70a2                	ld	ra,40(sp)
    80002f3c:	7402                	ld	s0,32(sp)
    80002f3e:	64e2                	ld	s1,24(sp)
    80002f40:	6942                	ld	s2,16(sp)
    80002f42:	69a2                	ld	s3,8(sp)
    80002f44:	6145                	addi	sp,sp,48
    80002f46:	8082                	ret
    80002f48:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002f4a:	0009a503          	lw	a0,0(s3)
    80002f4e:	fffff097          	auipc	ra,0xfffff
    80002f52:	65c080e7          	jalr	1628(ra) # 800025aa <bread>
    80002f56:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002f58:	05850493          	addi	s1,a0,88
    80002f5c:	45850913          	addi	s2,a0,1112
    80002f60:	a021                	j	80002f68 <itrunc+0x78>
    80002f62:	0491                	addi	s1,s1,4
    80002f64:	01248b63          	beq	s1,s2,80002f7a <itrunc+0x8a>
      if(a[j])
    80002f68:	408c                	lw	a1,0(s1)
    80002f6a:	dde5                	beqz	a1,80002f62 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002f6c:	0009a503          	lw	a0,0(s3)
    80002f70:	00000097          	auipc	ra,0x0
    80002f74:	87e080e7          	jalr	-1922(ra) # 800027ee <bfree>
    80002f78:	b7ed                	j	80002f62 <itrunc+0x72>
    brelse(bp);
    80002f7a:	8552                	mv	a0,s4
    80002f7c:	fffff097          	auipc	ra,0xfffff
    80002f80:	75e080e7          	jalr	1886(ra) # 800026da <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f84:	0809a583          	lw	a1,128(s3)
    80002f88:	0009a503          	lw	a0,0(s3)
    80002f8c:	00000097          	auipc	ra,0x0
    80002f90:	862080e7          	jalr	-1950(ra) # 800027ee <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f94:	0809a023          	sw	zero,128(s3)
    80002f98:	6a02                	ld	s4,0(sp)
    80002f9a:	bf49                	j	80002f2c <itrunc+0x3c>

0000000080002f9c <iput>:
{
    80002f9c:	1101                	addi	sp,sp,-32
    80002f9e:	ec06                	sd	ra,24(sp)
    80002fa0:	e822                	sd	s0,16(sp)
    80002fa2:	e426                	sd	s1,8(sp)
    80002fa4:	1000                	addi	s0,sp,32
    80002fa6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002fa8:	00017517          	auipc	a0,0x17
    80002fac:	ad050513          	addi	a0,a0,-1328 # 80019a78 <itable>
    80002fb0:	00003097          	auipc	ra,0x3
    80002fb4:	58c080e7          	jalr	1420(ra) # 8000653c <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002fb8:	4498                	lw	a4,8(s1)
    80002fba:	4785                	li	a5,1
    80002fbc:	02f70263          	beq	a4,a5,80002fe0 <iput+0x44>
  ip->ref--;
    80002fc0:	449c                	lw	a5,8(s1)
    80002fc2:	37fd                	addiw	a5,a5,-1
    80002fc4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002fc6:	00017517          	auipc	a0,0x17
    80002fca:	ab250513          	addi	a0,a0,-1358 # 80019a78 <itable>
    80002fce:	00003097          	auipc	ra,0x3
    80002fd2:	622080e7          	jalr	1570(ra) # 800065f0 <release>
}
    80002fd6:	60e2                	ld	ra,24(sp)
    80002fd8:	6442                	ld	s0,16(sp)
    80002fda:	64a2                	ld	s1,8(sp)
    80002fdc:	6105                	addi	sp,sp,32
    80002fde:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002fe0:	40bc                	lw	a5,64(s1)
    80002fe2:	dff9                	beqz	a5,80002fc0 <iput+0x24>
    80002fe4:	04a49783          	lh	a5,74(s1)
    80002fe8:	ffe1                	bnez	a5,80002fc0 <iput+0x24>
    80002fea:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002fec:	01048913          	addi	s2,s1,16
    80002ff0:	854a                	mv	a0,s2
    80002ff2:	00001097          	auipc	ra,0x1
    80002ff6:	ab0080e7          	jalr	-1360(ra) # 80003aa2 <acquiresleep>
    release(&itable.lock);
    80002ffa:	00017517          	auipc	a0,0x17
    80002ffe:	a7e50513          	addi	a0,a0,-1410 # 80019a78 <itable>
    80003002:	00003097          	auipc	ra,0x3
    80003006:	5ee080e7          	jalr	1518(ra) # 800065f0 <release>
    itrunc(ip);
    8000300a:	8526                	mv	a0,s1
    8000300c:	00000097          	auipc	ra,0x0
    80003010:	ee4080e7          	jalr	-284(ra) # 80002ef0 <itrunc>
    ip->type = 0;
    80003014:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003018:	8526                	mv	a0,s1
    8000301a:	00000097          	auipc	ra,0x0
    8000301e:	cf8080e7          	jalr	-776(ra) # 80002d12 <iupdate>
    ip->valid = 0;
    80003022:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003026:	854a                	mv	a0,s2
    80003028:	00001097          	auipc	ra,0x1
    8000302c:	ad0080e7          	jalr	-1328(ra) # 80003af8 <releasesleep>
    acquire(&itable.lock);
    80003030:	00017517          	auipc	a0,0x17
    80003034:	a4850513          	addi	a0,a0,-1464 # 80019a78 <itable>
    80003038:	00003097          	auipc	ra,0x3
    8000303c:	504080e7          	jalr	1284(ra) # 8000653c <acquire>
    80003040:	6902                	ld	s2,0(sp)
    80003042:	bfbd                	j	80002fc0 <iput+0x24>

0000000080003044 <iunlockput>:
{
    80003044:	1101                	addi	sp,sp,-32
    80003046:	ec06                	sd	ra,24(sp)
    80003048:	e822                	sd	s0,16(sp)
    8000304a:	e426                	sd	s1,8(sp)
    8000304c:	1000                	addi	s0,sp,32
    8000304e:	84aa                	mv	s1,a0
  iunlock(ip);
    80003050:	00000097          	auipc	ra,0x0
    80003054:	e54080e7          	jalr	-428(ra) # 80002ea4 <iunlock>
  iput(ip);
    80003058:	8526                	mv	a0,s1
    8000305a:	00000097          	auipc	ra,0x0
    8000305e:	f42080e7          	jalr	-190(ra) # 80002f9c <iput>
}
    80003062:	60e2                	ld	ra,24(sp)
    80003064:	6442                	ld	s0,16(sp)
    80003066:	64a2                	ld	s1,8(sp)
    80003068:	6105                	addi	sp,sp,32
    8000306a:	8082                	ret

000000008000306c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000306c:	1141                	addi	sp,sp,-16
    8000306e:	e422                	sd	s0,8(sp)
    80003070:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003072:	411c                	lw	a5,0(a0)
    80003074:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003076:	415c                	lw	a5,4(a0)
    80003078:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000307a:	04451783          	lh	a5,68(a0)
    8000307e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003082:	04a51783          	lh	a5,74(a0)
    80003086:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000308a:	04c56783          	lwu	a5,76(a0)
    8000308e:	e99c                	sd	a5,16(a1)
}
    80003090:	6422                	ld	s0,8(sp)
    80003092:	0141                	addi	sp,sp,16
    80003094:	8082                	ret

0000000080003096 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003096:	457c                	lw	a5,76(a0)
    80003098:	10d7e563          	bltu	a5,a3,800031a2 <readi+0x10c>
{
    8000309c:	7159                	addi	sp,sp,-112
    8000309e:	f486                	sd	ra,104(sp)
    800030a0:	f0a2                	sd	s0,96(sp)
    800030a2:	eca6                	sd	s1,88(sp)
    800030a4:	e0d2                	sd	s4,64(sp)
    800030a6:	fc56                	sd	s5,56(sp)
    800030a8:	f85a                	sd	s6,48(sp)
    800030aa:	f45e                	sd	s7,40(sp)
    800030ac:	1880                	addi	s0,sp,112
    800030ae:	8b2a                	mv	s6,a0
    800030b0:	8bae                	mv	s7,a1
    800030b2:	8a32                	mv	s4,a2
    800030b4:	84b6                	mv	s1,a3
    800030b6:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800030b8:	9f35                	addw	a4,a4,a3
    return 0;
    800030ba:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800030bc:	0cd76a63          	bltu	a4,a3,80003190 <readi+0xfa>
    800030c0:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800030c2:	00e7f463          	bgeu	a5,a4,800030ca <readi+0x34>
    n = ip->size - off;
    800030c6:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030ca:	0a0a8963          	beqz	s5,8000317c <readi+0xe6>
    800030ce:	e8ca                	sd	s2,80(sp)
    800030d0:	f062                	sd	s8,32(sp)
    800030d2:	ec66                	sd	s9,24(sp)
    800030d4:	e86a                	sd	s10,16(sp)
    800030d6:	e46e                	sd	s11,8(sp)
    800030d8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800030da:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800030de:	5c7d                	li	s8,-1
    800030e0:	a82d                	j	8000311a <readi+0x84>
    800030e2:	020d1d93          	slli	s11,s10,0x20
    800030e6:	020ddd93          	srli	s11,s11,0x20
    800030ea:	05890613          	addi	a2,s2,88
    800030ee:	86ee                	mv	a3,s11
    800030f0:	963a                	add	a2,a2,a4
    800030f2:	85d2                	mv	a1,s4
    800030f4:	855e                	mv	a0,s7
    800030f6:	fffff097          	auipc	ra,0xfffff
    800030fa:	a30080e7          	jalr	-1488(ra) # 80001b26 <either_copyout>
    800030fe:	05850d63          	beq	a0,s8,80003158 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003102:	854a                	mv	a0,s2
    80003104:	fffff097          	auipc	ra,0xfffff
    80003108:	5d6080e7          	jalr	1494(ra) # 800026da <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000310c:	013d09bb          	addw	s3,s10,s3
    80003110:	009d04bb          	addw	s1,s10,s1
    80003114:	9a6e                	add	s4,s4,s11
    80003116:	0559fd63          	bgeu	s3,s5,80003170 <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    8000311a:	00a4d59b          	srliw	a1,s1,0xa
    8000311e:	855a                	mv	a0,s6
    80003120:	00000097          	auipc	ra,0x0
    80003124:	88e080e7          	jalr	-1906(ra) # 800029ae <bmap>
    80003128:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000312c:	c9b1                	beqz	a1,80003180 <readi+0xea>
    bp = bread(ip->dev, addr);
    8000312e:	000b2503          	lw	a0,0(s6)
    80003132:	fffff097          	auipc	ra,0xfffff
    80003136:	478080e7          	jalr	1144(ra) # 800025aa <bread>
    8000313a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000313c:	3ff4f713          	andi	a4,s1,1023
    80003140:	40ec87bb          	subw	a5,s9,a4
    80003144:	413a86bb          	subw	a3,s5,s3
    80003148:	8d3e                	mv	s10,a5
    8000314a:	2781                	sext.w	a5,a5
    8000314c:	0006861b          	sext.w	a2,a3
    80003150:	f8f679e3          	bgeu	a2,a5,800030e2 <readi+0x4c>
    80003154:	8d36                	mv	s10,a3
    80003156:	b771                	j	800030e2 <readi+0x4c>
      brelse(bp);
    80003158:	854a                	mv	a0,s2
    8000315a:	fffff097          	auipc	ra,0xfffff
    8000315e:	580080e7          	jalr	1408(ra) # 800026da <brelse>
      tot = -1;
    80003162:	59fd                	li	s3,-1
      break;
    80003164:	6946                	ld	s2,80(sp)
    80003166:	7c02                	ld	s8,32(sp)
    80003168:	6ce2                	ld	s9,24(sp)
    8000316a:	6d42                	ld	s10,16(sp)
    8000316c:	6da2                	ld	s11,8(sp)
    8000316e:	a831                	j	8000318a <readi+0xf4>
    80003170:	6946                	ld	s2,80(sp)
    80003172:	7c02                	ld	s8,32(sp)
    80003174:	6ce2                	ld	s9,24(sp)
    80003176:	6d42                	ld	s10,16(sp)
    80003178:	6da2                	ld	s11,8(sp)
    8000317a:	a801                	j	8000318a <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000317c:	89d6                	mv	s3,s5
    8000317e:	a031                	j	8000318a <readi+0xf4>
    80003180:	6946                	ld	s2,80(sp)
    80003182:	7c02                	ld	s8,32(sp)
    80003184:	6ce2                	ld	s9,24(sp)
    80003186:	6d42                	ld	s10,16(sp)
    80003188:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000318a:	0009851b          	sext.w	a0,s3
    8000318e:	69a6                	ld	s3,72(sp)
}
    80003190:	70a6                	ld	ra,104(sp)
    80003192:	7406                	ld	s0,96(sp)
    80003194:	64e6                	ld	s1,88(sp)
    80003196:	6a06                	ld	s4,64(sp)
    80003198:	7ae2                	ld	s5,56(sp)
    8000319a:	7b42                	ld	s6,48(sp)
    8000319c:	7ba2                	ld	s7,40(sp)
    8000319e:	6165                	addi	sp,sp,112
    800031a0:	8082                	ret
    return 0;
    800031a2:	4501                	li	a0,0
}
    800031a4:	8082                	ret

00000000800031a6 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800031a6:	457c                	lw	a5,76(a0)
    800031a8:	10d7ee63          	bltu	a5,a3,800032c4 <writei+0x11e>
{
    800031ac:	7159                	addi	sp,sp,-112
    800031ae:	f486                	sd	ra,104(sp)
    800031b0:	f0a2                	sd	s0,96(sp)
    800031b2:	e8ca                	sd	s2,80(sp)
    800031b4:	e0d2                	sd	s4,64(sp)
    800031b6:	fc56                	sd	s5,56(sp)
    800031b8:	f85a                	sd	s6,48(sp)
    800031ba:	f45e                	sd	s7,40(sp)
    800031bc:	1880                	addi	s0,sp,112
    800031be:	8aaa                	mv	s5,a0
    800031c0:	8bae                	mv	s7,a1
    800031c2:	8a32                	mv	s4,a2
    800031c4:	8936                	mv	s2,a3
    800031c6:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800031c8:	00e687bb          	addw	a5,a3,a4
    800031cc:	0ed7ee63          	bltu	a5,a3,800032c8 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800031d0:	00043737          	lui	a4,0x43
    800031d4:	0ef76c63          	bltu	a4,a5,800032cc <writei+0x126>
    800031d8:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031da:	0c0b0d63          	beqz	s6,800032b4 <writei+0x10e>
    800031de:	eca6                	sd	s1,88(sp)
    800031e0:	f062                	sd	s8,32(sp)
    800031e2:	ec66                	sd	s9,24(sp)
    800031e4:	e86a                	sd	s10,16(sp)
    800031e6:	e46e                	sd	s11,8(sp)
    800031e8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800031ea:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800031ee:	5c7d                	li	s8,-1
    800031f0:	a091                	j	80003234 <writei+0x8e>
    800031f2:	020d1d93          	slli	s11,s10,0x20
    800031f6:	020ddd93          	srli	s11,s11,0x20
    800031fa:	05848513          	addi	a0,s1,88
    800031fe:	86ee                	mv	a3,s11
    80003200:	8652                	mv	a2,s4
    80003202:	85de                	mv	a1,s7
    80003204:	953a                	add	a0,a0,a4
    80003206:	fffff097          	auipc	ra,0xfffff
    8000320a:	976080e7          	jalr	-1674(ra) # 80001b7c <either_copyin>
    8000320e:	07850263          	beq	a0,s8,80003272 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003212:	8526                	mv	a0,s1
    80003214:	00000097          	auipc	ra,0x0
    80003218:	770080e7          	jalr	1904(ra) # 80003984 <log_write>
    brelse(bp);
    8000321c:	8526                	mv	a0,s1
    8000321e:	fffff097          	auipc	ra,0xfffff
    80003222:	4bc080e7          	jalr	1212(ra) # 800026da <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003226:	013d09bb          	addw	s3,s10,s3
    8000322a:	012d093b          	addw	s2,s10,s2
    8000322e:	9a6e                	add	s4,s4,s11
    80003230:	0569f663          	bgeu	s3,s6,8000327c <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003234:	00a9559b          	srliw	a1,s2,0xa
    80003238:	8556                	mv	a0,s5
    8000323a:	fffff097          	auipc	ra,0xfffff
    8000323e:	774080e7          	jalr	1908(ra) # 800029ae <bmap>
    80003242:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003246:	c99d                	beqz	a1,8000327c <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003248:	000aa503          	lw	a0,0(s5)
    8000324c:	fffff097          	auipc	ra,0xfffff
    80003250:	35e080e7          	jalr	862(ra) # 800025aa <bread>
    80003254:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003256:	3ff97713          	andi	a4,s2,1023
    8000325a:	40ec87bb          	subw	a5,s9,a4
    8000325e:	413b06bb          	subw	a3,s6,s3
    80003262:	8d3e                	mv	s10,a5
    80003264:	2781                	sext.w	a5,a5
    80003266:	0006861b          	sext.w	a2,a3
    8000326a:	f8f674e3          	bgeu	a2,a5,800031f2 <writei+0x4c>
    8000326e:	8d36                	mv	s10,a3
    80003270:	b749                	j	800031f2 <writei+0x4c>
      brelse(bp);
    80003272:	8526                	mv	a0,s1
    80003274:	fffff097          	auipc	ra,0xfffff
    80003278:	466080e7          	jalr	1126(ra) # 800026da <brelse>
  }

  if(off > ip->size)
    8000327c:	04caa783          	lw	a5,76(s5)
    80003280:	0327fc63          	bgeu	a5,s2,800032b8 <writei+0x112>
    ip->size = off;
    80003284:	052aa623          	sw	s2,76(s5)
    80003288:	64e6                	ld	s1,88(sp)
    8000328a:	7c02                	ld	s8,32(sp)
    8000328c:	6ce2                	ld	s9,24(sp)
    8000328e:	6d42                	ld	s10,16(sp)
    80003290:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003292:	8556                	mv	a0,s5
    80003294:	00000097          	auipc	ra,0x0
    80003298:	a7e080e7          	jalr	-1410(ra) # 80002d12 <iupdate>

  return tot;
    8000329c:	0009851b          	sext.w	a0,s3
    800032a0:	69a6                	ld	s3,72(sp)
}
    800032a2:	70a6                	ld	ra,104(sp)
    800032a4:	7406                	ld	s0,96(sp)
    800032a6:	6946                	ld	s2,80(sp)
    800032a8:	6a06                	ld	s4,64(sp)
    800032aa:	7ae2                	ld	s5,56(sp)
    800032ac:	7b42                	ld	s6,48(sp)
    800032ae:	7ba2                	ld	s7,40(sp)
    800032b0:	6165                	addi	sp,sp,112
    800032b2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800032b4:	89da                	mv	s3,s6
    800032b6:	bff1                	j	80003292 <writei+0xec>
    800032b8:	64e6                	ld	s1,88(sp)
    800032ba:	7c02                	ld	s8,32(sp)
    800032bc:	6ce2                	ld	s9,24(sp)
    800032be:	6d42                	ld	s10,16(sp)
    800032c0:	6da2                	ld	s11,8(sp)
    800032c2:	bfc1                	j	80003292 <writei+0xec>
    return -1;
    800032c4:	557d                	li	a0,-1
}
    800032c6:	8082                	ret
    return -1;
    800032c8:	557d                	li	a0,-1
    800032ca:	bfe1                	j	800032a2 <writei+0xfc>
    return -1;
    800032cc:	557d                	li	a0,-1
    800032ce:	bfd1                	j	800032a2 <writei+0xfc>

00000000800032d0 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800032d0:	1141                	addi	sp,sp,-16
    800032d2:	e406                	sd	ra,8(sp)
    800032d4:	e022                	sd	s0,0(sp)
    800032d6:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800032d8:	4639                	li	a2,14
    800032da:	ffffd097          	auipc	ra,0xffffd
    800032de:	f70080e7          	jalr	-144(ra) # 8000024a <strncmp>
}
    800032e2:	60a2                	ld	ra,8(sp)
    800032e4:	6402                	ld	s0,0(sp)
    800032e6:	0141                	addi	sp,sp,16
    800032e8:	8082                	ret

00000000800032ea <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800032ea:	7139                	addi	sp,sp,-64
    800032ec:	fc06                	sd	ra,56(sp)
    800032ee:	f822                	sd	s0,48(sp)
    800032f0:	f426                	sd	s1,40(sp)
    800032f2:	f04a                	sd	s2,32(sp)
    800032f4:	ec4e                	sd	s3,24(sp)
    800032f6:	e852                	sd	s4,16(sp)
    800032f8:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800032fa:	04451703          	lh	a4,68(a0)
    800032fe:	4785                	li	a5,1
    80003300:	00f71a63          	bne	a4,a5,80003314 <dirlookup+0x2a>
    80003304:	892a                	mv	s2,a0
    80003306:	89ae                	mv	s3,a1
    80003308:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000330a:	457c                	lw	a5,76(a0)
    8000330c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000330e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003310:	e79d                	bnez	a5,8000333e <dirlookup+0x54>
    80003312:	a8a5                	j	8000338a <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003314:	00005517          	auipc	a0,0x5
    80003318:	1d450513          	addi	a0,a0,468 # 800084e8 <etext+0x4e8>
    8000331c:	00003097          	auipc	ra,0x3
    80003320:	ca6080e7          	jalr	-858(ra) # 80005fc2 <panic>
      panic("dirlookup read");
    80003324:	00005517          	auipc	a0,0x5
    80003328:	1dc50513          	addi	a0,a0,476 # 80008500 <etext+0x500>
    8000332c:	00003097          	auipc	ra,0x3
    80003330:	c96080e7          	jalr	-874(ra) # 80005fc2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003334:	24c1                	addiw	s1,s1,16
    80003336:	04c92783          	lw	a5,76(s2)
    8000333a:	04f4f763          	bgeu	s1,a5,80003388 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000333e:	4741                	li	a4,16
    80003340:	86a6                	mv	a3,s1
    80003342:	fc040613          	addi	a2,s0,-64
    80003346:	4581                	li	a1,0
    80003348:	854a                	mv	a0,s2
    8000334a:	00000097          	auipc	ra,0x0
    8000334e:	d4c080e7          	jalr	-692(ra) # 80003096 <readi>
    80003352:	47c1                	li	a5,16
    80003354:	fcf518e3          	bne	a0,a5,80003324 <dirlookup+0x3a>
    if(de.inum == 0)
    80003358:	fc045783          	lhu	a5,-64(s0)
    8000335c:	dfe1                	beqz	a5,80003334 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000335e:	fc240593          	addi	a1,s0,-62
    80003362:	854e                	mv	a0,s3
    80003364:	00000097          	auipc	ra,0x0
    80003368:	f6c080e7          	jalr	-148(ra) # 800032d0 <namecmp>
    8000336c:	f561                	bnez	a0,80003334 <dirlookup+0x4a>
      if(poff)
    8000336e:	000a0463          	beqz	s4,80003376 <dirlookup+0x8c>
        *poff = off;
    80003372:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003376:	fc045583          	lhu	a1,-64(s0)
    8000337a:	00092503          	lw	a0,0(s2)
    8000337e:	fffff097          	auipc	ra,0xfffff
    80003382:	720080e7          	jalr	1824(ra) # 80002a9e <iget>
    80003386:	a011                	j	8000338a <dirlookup+0xa0>
  return 0;
    80003388:	4501                	li	a0,0
}
    8000338a:	70e2                	ld	ra,56(sp)
    8000338c:	7442                	ld	s0,48(sp)
    8000338e:	74a2                	ld	s1,40(sp)
    80003390:	7902                	ld	s2,32(sp)
    80003392:	69e2                	ld	s3,24(sp)
    80003394:	6a42                	ld	s4,16(sp)
    80003396:	6121                	addi	sp,sp,64
    80003398:	8082                	ret

000000008000339a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000339a:	711d                	addi	sp,sp,-96
    8000339c:	ec86                	sd	ra,88(sp)
    8000339e:	e8a2                	sd	s0,80(sp)
    800033a0:	e4a6                	sd	s1,72(sp)
    800033a2:	e0ca                	sd	s2,64(sp)
    800033a4:	fc4e                	sd	s3,56(sp)
    800033a6:	f852                	sd	s4,48(sp)
    800033a8:	f456                	sd	s5,40(sp)
    800033aa:	f05a                	sd	s6,32(sp)
    800033ac:	ec5e                	sd	s7,24(sp)
    800033ae:	e862                	sd	s8,16(sp)
    800033b0:	e466                	sd	s9,8(sp)
    800033b2:	1080                	addi	s0,sp,96
    800033b4:	84aa                	mv	s1,a0
    800033b6:	8b2e                	mv	s6,a1
    800033b8:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800033ba:	00054703          	lbu	a4,0(a0)
    800033be:	02f00793          	li	a5,47
    800033c2:	02f70263          	beq	a4,a5,800033e6 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800033c6:	ffffe097          	auipc	ra,0xffffe
    800033ca:	c24080e7          	jalr	-988(ra) # 80000fea <myproc>
    800033ce:	15053503          	ld	a0,336(a0)
    800033d2:	00000097          	auipc	ra,0x0
    800033d6:	9ce080e7          	jalr	-1586(ra) # 80002da0 <idup>
    800033da:	8a2a                	mv	s4,a0
  while(*path == '/')
    800033dc:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800033e0:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800033e2:	4b85                	li	s7,1
    800033e4:	a875                	j	800034a0 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800033e6:	4585                	li	a1,1
    800033e8:	4505                	li	a0,1
    800033ea:	fffff097          	auipc	ra,0xfffff
    800033ee:	6b4080e7          	jalr	1716(ra) # 80002a9e <iget>
    800033f2:	8a2a                	mv	s4,a0
    800033f4:	b7e5                	j	800033dc <namex+0x42>
      iunlockput(ip);
    800033f6:	8552                	mv	a0,s4
    800033f8:	00000097          	auipc	ra,0x0
    800033fc:	c4c080e7          	jalr	-948(ra) # 80003044 <iunlockput>
      return 0;
    80003400:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003402:	8552                	mv	a0,s4
    80003404:	60e6                	ld	ra,88(sp)
    80003406:	6446                	ld	s0,80(sp)
    80003408:	64a6                	ld	s1,72(sp)
    8000340a:	6906                	ld	s2,64(sp)
    8000340c:	79e2                	ld	s3,56(sp)
    8000340e:	7a42                	ld	s4,48(sp)
    80003410:	7aa2                	ld	s5,40(sp)
    80003412:	7b02                	ld	s6,32(sp)
    80003414:	6be2                	ld	s7,24(sp)
    80003416:	6c42                	ld	s8,16(sp)
    80003418:	6ca2                	ld	s9,8(sp)
    8000341a:	6125                	addi	sp,sp,96
    8000341c:	8082                	ret
      iunlock(ip);
    8000341e:	8552                	mv	a0,s4
    80003420:	00000097          	auipc	ra,0x0
    80003424:	a84080e7          	jalr	-1404(ra) # 80002ea4 <iunlock>
      return ip;
    80003428:	bfe9                	j	80003402 <namex+0x68>
      iunlockput(ip);
    8000342a:	8552                	mv	a0,s4
    8000342c:	00000097          	auipc	ra,0x0
    80003430:	c18080e7          	jalr	-1000(ra) # 80003044 <iunlockput>
      return 0;
    80003434:	8a4e                	mv	s4,s3
    80003436:	b7f1                	j	80003402 <namex+0x68>
  len = path - s;
    80003438:	40998633          	sub	a2,s3,s1
    8000343c:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003440:	099c5863          	bge	s8,s9,800034d0 <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003444:	4639                	li	a2,14
    80003446:	85a6                	mv	a1,s1
    80003448:	8556                	mv	a0,s5
    8000344a:	ffffd097          	auipc	ra,0xffffd
    8000344e:	d8c080e7          	jalr	-628(ra) # 800001d6 <memmove>
    80003452:	84ce                	mv	s1,s3
  while(*path == '/')
    80003454:	0004c783          	lbu	a5,0(s1)
    80003458:	01279763          	bne	a5,s2,80003466 <namex+0xcc>
    path++;
    8000345c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000345e:	0004c783          	lbu	a5,0(s1)
    80003462:	ff278de3          	beq	a5,s2,8000345c <namex+0xc2>
    ilock(ip);
    80003466:	8552                	mv	a0,s4
    80003468:	00000097          	auipc	ra,0x0
    8000346c:	976080e7          	jalr	-1674(ra) # 80002dde <ilock>
    if(ip->type != T_DIR){
    80003470:	044a1783          	lh	a5,68(s4)
    80003474:	f97791e3          	bne	a5,s7,800033f6 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003478:	000b0563          	beqz	s6,80003482 <namex+0xe8>
    8000347c:	0004c783          	lbu	a5,0(s1)
    80003480:	dfd9                	beqz	a5,8000341e <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003482:	4601                	li	a2,0
    80003484:	85d6                	mv	a1,s5
    80003486:	8552                	mv	a0,s4
    80003488:	00000097          	auipc	ra,0x0
    8000348c:	e62080e7          	jalr	-414(ra) # 800032ea <dirlookup>
    80003490:	89aa                	mv	s3,a0
    80003492:	dd41                	beqz	a0,8000342a <namex+0x90>
    iunlockput(ip);
    80003494:	8552                	mv	a0,s4
    80003496:	00000097          	auipc	ra,0x0
    8000349a:	bae080e7          	jalr	-1106(ra) # 80003044 <iunlockput>
    ip = next;
    8000349e:	8a4e                	mv	s4,s3
  while(*path == '/')
    800034a0:	0004c783          	lbu	a5,0(s1)
    800034a4:	01279763          	bne	a5,s2,800034b2 <namex+0x118>
    path++;
    800034a8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800034aa:	0004c783          	lbu	a5,0(s1)
    800034ae:	ff278de3          	beq	a5,s2,800034a8 <namex+0x10e>
  if(*path == 0)
    800034b2:	cb9d                	beqz	a5,800034e8 <namex+0x14e>
  while(*path != '/' && *path != 0)
    800034b4:	0004c783          	lbu	a5,0(s1)
    800034b8:	89a6                	mv	s3,s1
  len = path - s;
    800034ba:	4c81                	li	s9,0
    800034bc:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800034be:	01278963          	beq	a5,s2,800034d0 <namex+0x136>
    800034c2:	dbbd                	beqz	a5,80003438 <namex+0x9e>
    path++;
    800034c4:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800034c6:	0009c783          	lbu	a5,0(s3)
    800034ca:	ff279ce3          	bne	a5,s2,800034c2 <namex+0x128>
    800034ce:	b7ad                	j	80003438 <namex+0x9e>
    memmove(name, s, len);
    800034d0:	2601                	sext.w	a2,a2
    800034d2:	85a6                	mv	a1,s1
    800034d4:	8556                	mv	a0,s5
    800034d6:	ffffd097          	auipc	ra,0xffffd
    800034da:	d00080e7          	jalr	-768(ra) # 800001d6 <memmove>
    name[len] = 0;
    800034de:	9cd6                	add	s9,s9,s5
    800034e0:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800034e4:	84ce                	mv	s1,s3
    800034e6:	b7bd                	j	80003454 <namex+0xba>
  if(nameiparent){
    800034e8:	f00b0de3          	beqz	s6,80003402 <namex+0x68>
    iput(ip);
    800034ec:	8552                	mv	a0,s4
    800034ee:	00000097          	auipc	ra,0x0
    800034f2:	aae080e7          	jalr	-1362(ra) # 80002f9c <iput>
    return 0;
    800034f6:	4a01                	li	s4,0
    800034f8:	b729                	j	80003402 <namex+0x68>

00000000800034fa <dirlink>:
{
    800034fa:	7139                	addi	sp,sp,-64
    800034fc:	fc06                	sd	ra,56(sp)
    800034fe:	f822                	sd	s0,48(sp)
    80003500:	f04a                	sd	s2,32(sp)
    80003502:	ec4e                	sd	s3,24(sp)
    80003504:	e852                	sd	s4,16(sp)
    80003506:	0080                	addi	s0,sp,64
    80003508:	892a                	mv	s2,a0
    8000350a:	8a2e                	mv	s4,a1
    8000350c:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000350e:	4601                	li	a2,0
    80003510:	00000097          	auipc	ra,0x0
    80003514:	dda080e7          	jalr	-550(ra) # 800032ea <dirlookup>
    80003518:	ed25                	bnez	a0,80003590 <dirlink+0x96>
    8000351a:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000351c:	04c92483          	lw	s1,76(s2)
    80003520:	c49d                	beqz	s1,8000354e <dirlink+0x54>
    80003522:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003524:	4741                	li	a4,16
    80003526:	86a6                	mv	a3,s1
    80003528:	fc040613          	addi	a2,s0,-64
    8000352c:	4581                	li	a1,0
    8000352e:	854a                	mv	a0,s2
    80003530:	00000097          	auipc	ra,0x0
    80003534:	b66080e7          	jalr	-1178(ra) # 80003096 <readi>
    80003538:	47c1                	li	a5,16
    8000353a:	06f51163          	bne	a0,a5,8000359c <dirlink+0xa2>
    if(de.inum == 0)
    8000353e:	fc045783          	lhu	a5,-64(s0)
    80003542:	c791                	beqz	a5,8000354e <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003544:	24c1                	addiw	s1,s1,16
    80003546:	04c92783          	lw	a5,76(s2)
    8000354a:	fcf4ede3          	bltu	s1,a5,80003524 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000354e:	4639                	li	a2,14
    80003550:	85d2                	mv	a1,s4
    80003552:	fc240513          	addi	a0,s0,-62
    80003556:	ffffd097          	auipc	ra,0xffffd
    8000355a:	d2a080e7          	jalr	-726(ra) # 80000280 <strncpy>
  de.inum = inum;
    8000355e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003562:	4741                	li	a4,16
    80003564:	86a6                	mv	a3,s1
    80003566:	fc040613          	addi	a2,s0,-64
    8000356a:	4581                	li	a1,0
    8000356c:	854a                	mv	a0,s2
    8000356e:	00000097          	auipc	ra,0x0
    80003572:	c38080e7          	jalr	-968(ra) # 800031a6 <writei>
    80003576:	1541                	addi	a0,a0,-16
    80003578:	00a03533          	snez	a0,a0
    8000357c:	40a00533          	neg	a0,a0
    80003580:	74a2                	ld	s1,40(sp)
}
    80003582:	70e2                	ld	ra,56(sp)
    80003584:	7442                	ld	s0,48(sp)
    80003586:	7902                	ld	s2,32(sp)
    80003588:	69e2                	ld	s3,24(sp)
    8000358a:	6a42                	ld	s4,16(sp)
    8000358c:	6121                	addi	sp,sp,64
    8000358e:	8082                	ret
    iput(ip);
    80003590:	00000097          	auipc	ra,0x0
    80003594:	a0c080e7          	jalr	-1524(ra) # 80002f9c <iput>
    return -1;
    80003598:	557d                	li	a0,-1
    8000359a:	b7e5                	j	80003582 <dirlink+0x88>
      panic("dirlink read");
    8000359c:	00005517          	auipc	a0,0x5
    800035a0:	f7450513          	addi	a0,a0,-140 # 80008510 <etext+0x510>
    800035a4:	00003097          	auipc	ra,0x3
    800035a8:	a1e080e7          	jalr	-1506(ra) # 80005fc2 <panic>

00000000800035ac <namei>:

struct inode*
namei(char *path)
{
    800035ac:	1101                	addi	sp,sp,-32
    800035ae:	ec06                	sd	ra,24(sp)
    800035b0:	e822                	sd	s0,16(sp)
    800035b2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800035b4:	fe040613          	addi	a2,s0,-32
    800035b8:	4581                	li	a1,0
    800035ba:	00000097          	auipc	ra,0x0
    800035be:	de0080e7          	jalr	-544(ra) # 8000339a <namex>
}
    800035c2:	60e2                	ld	ra,24(sp)
    800035c4:	6442                	ld	s0,16(sp)
    800035c6:	6105                	addi	sp,sp,32
    800035c8:	8082                	ret

00000000800035ca <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800035ca:	1141                	addi	sp,sp,-16
    800035cc:	e406                	sd	ra,8(sp)
    800035ce:	e022                	sd	s0,0(sp)
    800035d0:	0800                	addi	s0,sp,16
    800035d2:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800035d4:	4585                	li	a1,1
    800035d6:	00000097          	auipc	ra,0x0
    800035da:	dc4080e7          	jalr	-572(ra) # 8000339a <namex>
}
    800035de:	60a2                	ld	ra,8(sp)
    800035e0:	6402                	ld	s0,0(sp)
    800035e2:	0141                	addi	sp,sp,16
    800035e4:	8082                	ret

00000000800035e6 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800035e6:	1101                	addi	sp,sp,-32
    800035e8:	ec06                	sd	ra,24(sp)
    800035ea:	e822                	sd	s0,16(sp)
    800035ec:	e426                	sd	s1,8(sp)
    800035ee:	e04a                	sd	s2,0(sp)
    800035f0:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800035f2:	00018917          	auipc	s2,0x18
    800035f6:	f2e90913          	addi	s2,s2,-210 # 8001b520 <log>
    800035fa:	01892583          	lw	a1,24(s2)
    800035fe:	02892503          	lw	a0,40(s2)
    80003602:	fffff097          	auipc	ra,0xfffff
    80003606:	fa8080e7          	jalr	-88(ra) # 800025aa <bread>
    8000360a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000360c:	02c92603          	lw	a2,44(s2)
    80003610:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003612:	00c05f63          	blez	a2,80003630 <write_head+0x4a>
    80003616:	00018717          	auipc	a4,0x18
    8000361a:	f3a70713          	addi	a4,a4,-198 # 8001b550 <log+0x30>
    8000361e:	87aa                	mv	a5,a0
    80003620:	060a                	slli	a2,a2,0x2
    80003622:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003624:	4314                	lw	a3,0(a4)
    80003626:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003628:	0711                	addi	a4,a4,4
    8000362a:	0791                	addi	a5,a5,4
    8000362c:	fec79ce3          	bne	a5,a2,80003624 <write_head+0x3e>
  }
  bwrite(buf);
    80003630:	8526                	mv	a0,s1
    80003632:	fffff097          	auipc	ra,0xfffff
    80003636:	06a080e7          	jalr	106(ra) # 8000269c <bwrite>
  brelse(buf);
    8000363a:	8526                	mv	a0,s1
    8000363c:	fffff097          	auipc	ra,0xfffff
    80003640:	09e080e7          	jalr	158(ra) # 800026da <brelse>
}
    80003644:	60e2                	ld	ra,24(sp)
    80003646:	6442                	ld	s0,16(sp)
    80003648:	64a2                	ld	s1,8(sp)
    8000364a:	6902                	ld	s2,0(sp)
    8000364c:	6105                	addi	sp,sp,32
    8000364e:	8082                	ret

0000000080003650 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003650:	00018797          	auipc	a5,0x18
    80003654:	efc7a783          	lw	a5,-260(a5) # 8001b54c <log+0x2c>
    80003658:	0af05d63          	blez	a5,80003712 <install_trans+0xc2>
{
    8000365c:	7139                	addi	sp,sp,-64
    8000365e:	fc06                	sd	ra,56(sp)
    80003660:	f822                	sd	s0,48(sp)
    80003662:	f426                	sd	s1,40(sp)
    80003664:	f04a                	sd	s2,32(sp)
    80003666:	ec4e                	sd	s3,24(sp)
    80003668:	e852                	sd	s4,16(sp)
    8000366a:	e456                	sd	s5,8(sp)
    8000366c:	e05a                	sd	s6,0(sp)
    8000366e:	0080                	addi	s0,sp,64
    80003670:	8b2a                	mv	s6,a0
    80003672:	00018a97          	auipc	s5,0x18
    80003676:	edea8a93          	addi	s5,s5,-290 # 8001b550 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000367a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000367c:	00018997          	auipc	s3,0x18
    80003680:	ea498993          	addi	s3,s3,-348 # 8001b520 <log>
    80003684:	a00d                	j	800036a6 <install_trans+0x56>
    brelse(lbuf);
    80003686:	854a                	mv	a0,s2
    80003688:	fffff097          	auipc	ra,0xfffff
    8000368c:	052080e7          	jalr	82(ra) # 800026da <brelse>
    brelse(dbuf);
    80003690:	8526                	mv	a0,s1
    80003692:	fffff097          	auipc	ra,0xfffff
    80003696:	048080e7          	jalr	72(ra) # 800026da <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000369a:	2a05                	addiw	s4,s4,1
    8000369c:	0a91                	addi	s5,s5,4
    8000369e:	02c9a783          	lw	a5,44(s3)
    800036a2:	04fa5e63          	bge	s4,a5,800036fe <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800036a6:	0189a583          	lw	a1,24(s3)
    800036aa:	014585bb          	addw	a1,a1,s4
    800036ae:	2585                	addiw	a1,a1,1
    800036b0:	0289a503          	lw	a0,40(s3)
    800036b4:	fffff097          	auipc	ra,0xfffff
    800036b8:	ef6080e7          	jalr	-266(ra) # 800025aa <bread>
    800036bc:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800036be:	000aa583          	lw	a1,0(s5)
    800036c2:	0289a503          	lw	a0,40(s3)
    800036c6:	fffff097          	auipc	ra,0xfffff
    800036ca:	ee4080e7          	jalr	-284(ra) # 800025aa <bread>
    800036ce:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800036d0:	40000613          	li	a2,1024
    800036d4:	05890593          	addi	a1,s2,88
    800036d8:	05850513          	addi	a0,a0,88
    800036dc:	ffffd097          	auipc	ra,0xffffd
    800036e0:	afa080e7          	jalr	-1286(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800036e4:	8526                	mv	a0,s1
    800036e6:	fffff097          	auipc	ra,0xfffff
    800036ea:	fb6080e7          	jalr	-74(ra) # 8000269c <bwrite>
    if(recovering == 0)
    800036ee:	f80b1ce3          	bnez	s6,80003686 <install_trans+0x36>
      bunpin(dbuf);
    800036f2:	8526                	mv	a0,s1
    800036f4:	fffff097          	auipc	ra,0xfffff
    800036f8:	0be080e7          	jalr	190(ra) # 800027b2 <bunpin>
    800036fc:	b769                	j	80003686 <install_trans+0x36>
}
    800036fe:	70e2                	ld	ra,56(sp)
    80003700:	7442                	ld	s0,48(sp)
    80003702:	74a2                	ld	s1,40(sp)
    80003704:	7902                	ld	s2,32(sp)
    80003706:	69e2                	ld	s3,24(sp)
    80003708:	6a42                	ld	s4,16(sp)
    8000370a:	6aa2                	ld	s5,8(sp)
    8000370c:	6b02                	ld	s6,0(sp)
    8000370e:	6121                	addi	sp,sp,64
    80003710:	8082                	ret
    80003712:	8082                	ret

0000000080003714 <initlog>:
{
    80003714:	7179                	addi	sp,sp,-48
    80003716:	f406                	sd	ra,40(sp)
    80003718:	f022                	sd	s0,32(sp)
    8000371a:	ec26                	sd	s1,24(sp)
    8000371c:	e84a                	sd	s2,16(sp)
    8000371e:	e44e                	sd	s3,8(sp)
    80003720:	1800                	addi	s0,sp,48
    80003722:	892a                	mv	s2,a0
    80003724:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003726:	00018497          	auipc	s1,0x18
    8000372a:	dfa48493          	addi	s1,s1,-518 # 8001b520 <log>
    8000372e:	00005597          	auipc	a1,0x5
    80003732:	df258593          	addi	a1,a1,-526 # 80008520 <etext+0x520>
    80003736:	8526                	mv	a0,s1
    80003738:	00003097          	auipc	ra,0x3
    8000373c:	d74080e7          	jalr	-652(ra) # 800064ac <initlock>
  log.start = sb->logstart;
    80003740:	0149a583          	lw	a1,20(s3)
    80003744:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003746:	0109a783          	lw	a5,16(s3)
    8000374a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000374c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003750:	854a                	mv	a0,s2
    80003752:	fffff097          	auipc	ra,0xfffff
    80003756:	e58080e7          	jalr	-424(ra) # 800025aa <bread>
  log.lh.n = lh->n;
    8000375a:	4d30                	lw	a2,88(a0)
    8000375c:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000375e:	00c05f63          	blez	a2,8000377c <initlog+0x68>
    80003762:	87aa                	mv	a5,a0
    80003764:	00018717          	auipc	a4,0x18
    80003768:	dec70713          	addi	a4,a4,-532 # 8001b550 <log+0x30>
    8000376c:	060a                	slli	a2,a2,0x2
    8000376e:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003770:	4ff4                	lw	a3,92(a5)
    80003772:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003774:	0791                	addi	a5,a5,4
    80003776:	0711                	addi	a4,a4,4
    80003778:	fec79ce3          	bne	a5,a2,80003770 <initlog+0x5c>
  brelse(buf);
    8000377c:	fffff097          	auipc	ra,0xfffff
    80003780:	f5e080e7          	jalr	-162(ra) # 800026da <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003784:	4505                	li	a0,1
    80003786:	00000097          	auipc	ra,0x0
    8000378a:	eca080e7          	jalr	-310(ra) # 80003650 <install_trans>
  log.lh.n = 0;
    8000378e:	00018797          	auipc	a5,0x18
    80003792:	da07af23          	sw	zero,-578(a5) # 8001b54c <log+0x2c>
  write_head(); // clear the log
    80003796:	00000097          	auipc	ra,0x0
    8000379a:	e50080e7          	jalr	-432(ra) # 800035e6 <write_head>
}
    8000379e:	70a2                	ld	ra,40(sp)
    800037a0:	7402                	ld	s0,32(sp)
    800037a2:	64e2                	ld	s1,24(sp)
    800037a4:	6942                	ld	s2,16(sp)
    800037a6:	69a2                	ld	s3,8(sp)
    800037a8:	6145                	addi	sp,sp,48
    800037aa:	8082                	ret

00000000800037ac <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800037ac:	1101                	addi	sp,sp,-32
    800037ae:	ec06                	sd	ra,24(sp)
    800037b0:	e822                	sd	s0,16(sp)
    800037b2:	e426                	sd	s1,8(sp)
    800037b4:	e04a                	sd	s2,0(sp)
    800037b6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800037b8:	00018517          	auipc	a0,0x18
    800037bc:	d6850513          	addi	a0,a0,-664 # 8001b520 <log>
    800037c0:	00003097          	auipc	ra,0x3
    800037c4:	d7c080e7          	jalr	-644(ra) # 8000653c <acquire>
  while(1){
    if(log.committing){
    800037c8:	00018497          	auipc	s1,0x18
    800037cc:	d5848493          	addi	s1,s1,-680 # 8001b520 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037d0:	4979                	li	s2,30
    800037d2:	a039                	j	800037e0 <begin_op+0x34>
      sleep(&log, &log.lock);
    800037d4:	85a6                	mv	a1,s1
    800037d6:	8526                	mv	a0,s1
    800037d8:	ffffe097          	auipc	ra,0xffffe
    800037dc:	f46080e7          	jalr	-186(ra) # 8000171e <sleep>
    if(log.committing){
    800037e0:	50dc                	lw	a5,36(s1)
    800037e2:	fbed                	bnez	a5,800037d4 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037e4:	5098                	lw	a4,32(s1)
    800037e6:	2705                	addiw	a4,a4,1
    800037e8:	0027179b          	slliw	a5,a4,0x2
    800037ec:	9fb9                	addw	a5,a5,a4
    800037ee:	0017979b          	slliw	a5,a5,0x1
    800037f2:	54d4                	lw	a3,44(s1)
    800037f4:	9fb5                	addw	a5,a5,a3
    800037f6:	00f95963          	bge	s2,a5,80003808 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800037fa:	85a6                	mv	a1,s1
    800037fc:	8526                	mv	a0,s1
    800037fe:	ffffe097          	auipc	ra,0xffffe
    80003802:	f20080e7          	jalr	-224(ra) # 8000171e <sleep>
    80003806:	bfe9                	j	800037e0 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003808:	00018517          	auipc	a0,0x18
    8000380c:	d1850513          	addi	a0,a0,-744 # 8001b520 <log>
    80003810:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003812:	00003097          	auipc	ra,0x3
    80003816:	dde080e7          	jalr	-546(ra) # 800065f0 <release>
      break;
    }
  }
}
    8000381a:	60e2                	ld	ra,24(sp)
    8000381c:	6442                	ld	s0,16(sp)
    8000381e:	64a2                	ld	s1,8(sp)
    80003820:	6902                	ld	s2,0(sp)
    80003822:	6105                	addi	sp,sp,32
    80003824:	8082                	ret

0000000080003826 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003826:	7139                	addi	sp,sp,-64
    80003828:	fc06                	sd	ra,56(sp)
    8000382a:	f822                	sd	s0,48(sp)
    8000382c:	f426                	sd	s1,40(sp)
    8000382e:	f04a                	sd	s2,32(sp)
    80003830:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003832:	00018497          	auipc	s1,0x18
    80003836:	cee48493          	addi	s1,s1,-786 # 8001b520 <log>
    8000383a:	8526                	mv	a0,s1
    8000383c:	00003097          	auipc	ra,0x3
    80003840:	d00080e7          	jalr	-768(ra) # 8000653c <acquire>
  log.outstanding -= 1;
    80003844:	509c                	lw	a5,32(s1)
    80003846:	37fd                	addiw	a5,a5,-1
    80003848:	0007891b          	sext.w	s2,a5
    8000384c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000384e:	50dc                	lw	a5,36(s1)
    80003850:	e7b9                	bnez	a5,8000389e <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    80003852:	06091163          	bnez	s2,800038b4 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003856:	00018497          	auipc	s1,0x18
    8000385a:	cca48493          	addi	s1,s1,-822 # 8001b520 <log>
    8000385e:	4785                	li	a5,1
    80003860:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003862:	8526                	mv	a0,s1
    80003864:	00003097          	auipc	ra,0x3
    80003868:	d8c080e7          	jalr	-628(ra) # 800065f0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000386c:	54dc                	lw	a5,44(s1)
    8000386e:	06f04763          	bgtz	a5,800038dc <end_op+0xb6>
    acquire(&log.lock);
    80003872:	00018497          	auipc	s1,0x18
    80003876:	cae48493          	addi	s1,s1,-850 # 8001b520 <log>
    8000387a:	8526                	mv	a0,s1
    8000387c:	00003097          	auipc	ra,0x3
    80003880:	cc0080e7          	jalr	-832(ra) # 8000653c <acquire>
    log.committing = 0;
    80003884:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003888:	8526                	mv	a0,s1
    8000388a:	ffffe097          	auipc	ra,0xffffe
    8000388e:	ef8080e7          	jalr	-264(ra) # 80001782 <wakeup>
    release(&log.lock);
    80003892:	8526                	mv	a0,s1
    80003894:	00003097          	auipc	ra,0x3
    80003898:	d5c080e7          	jalr	-676(ra) # 800065f0 <release>
}
    8000389c:	a815                	j	800038d0 <end_op+0xaa>
    8000389e:	ec4e                	sd	s3,24(sp)
    800038a0:	e852                	sd	s4,16(sp)
    800038a2:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800038a4:	00005517          	auipc	a0,0x5
    800038a8:	c8450513          	addi	a0,a0,-892 # 80008528 <etext+0x528>
    800038ac:	00002097          	auipc	ra,0x2
    800038b0:	716080e7          	jalr	1814(ra) # 80005fc2 <panic>
    wakeup(&log);
    800038b4:	00018497          	auipc	s1,0x18
    800038b8:	c6c48493          	addi	s1,s1,-916 # 8001b520 <log>
    800038bc:	8526                	mv	a0,s1
    800038be:	ffffe097          	auipc	ra,0xffffe
    800038c2:	ec4080e7          	jalr	-316(ra) # 80001782 <wakeup>
  release(&log.lock);
    800038c6:	8526                	mv	a0,s1
    800038c8:	00003097          	auipc	ra,0x3
    800038cc:	d28080e7          	jalr	-728(ra) # 800065f0 <release>
}
    800038d0:	70e2                	ld	ra,56(sp)
    800038d2:	7442                	ld	s0,48(sp)
    800038d4:	74a2                	ld	s1,40(sp)
    800038d6:	7902                	ld	s2,32(sp)
    800038d8:	6121                	addi	sp,sp,64
    800038da:	8082                	ret
    800038dc:	ec4e                	sd	s3,24(sp)
    800038de:	e852                	sd	s4,16(sp)
    800038e0:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800038e2:	00018a97          	auipc	s5,0x18
    800038e6:	c6ea8a93          	addi	s5,s5,-914 # 8001b550 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800038ea:	00018a17          	auipc	s4,0x18
    800038ee:	c36a0a13          	addi	s4,s4,-970 # 8001b520 <log>
    800038f2:	018a2583          	lw	a1,24(s4)
    800038f6:	012585bb          	addw	a1,a1,s2
    800038fa:	2585                	addiw	a1,a1,1
    800038fc:	028a2503          	lw	a0,40(s4)
    80003900:	fffff097          	auipc	ra,0xfffff
    80003904:	caa080e7          	jalr	-854(ra) # 800025aa <bread>
    80003908:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000390a:	000aa583          	lw	a1,0(s5)
    8000390e:	028a2503          	lw	a0,40(s4)
    80003912:	fffff097          	auipc	ra,0xfffff
    80003916:	c98080e7          	jalr	-872(ra) # 800025aa <bread>
    8000391a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000391c:	40000613          	li	a2,1024
    80003920:	05850593          	addi	a1,a0,88
    80003924:	05848513          	addi	a0,s1,88
    80003928:	ffffd097          	auipc	ra,0xffffd
    8000392c:	8ae080e7          	jalr	-1874(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003930:	8526                	mv	a0,s1
    80003932:	fffff097          	auipc	ra,0xfffff
    80003936:	d6a080e7          	jalr	-662(ra) # 8000269c <bwrite>
    brelse(from);
    8000393a:	854e                	mv	a0,s3
    8000393c:	fffff097          	auipc	ra,0xfffff
    80003940:	d9e080e7          	jalr	-610(ra) # 800026da <brelse>
    brelse(to);
    80003944:	8526                	mv	a0,s1
    80003946:	fffff097          	auipc	ra,0xfffff
    8000394a:	d94080e7          	jalr	-620(ra) # 800026da <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000394e:	2905                	addiw	s2,s2,1
    80003950:	0a91                	addi	s5,s5,4
    80003952:	02ca2783          	lw	a5,44(s4)
    80003956:	f8f94ee3          	blt	s2,a5,800038f2 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000395a:	00000097          	auipc	ra,0x0
    8000395e:	c8c080e7          	jalr	-884(ra) # 800035e6 <write_head>
    install_trans(0); // Now install writes to home locations
    80003962:	4501                	li	a0,0
    80003964:	00000097          	auipc	ra,0x0
    80003968:	cec080e7          	jalr	-788(ra) # 80003650 <install_trans>
    log.lh.n = 0;
    8000396c:	00018797          	auipc	a5,0x18
    80003970:	be07a023          	sw	zero,-1056(a5) # 8001b54c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003974:	00000097          	auipc	ra,0x0
    80003978:	c72080e7          	jalr	-910(ra) # 800035e6 <write_head>
    8000397c:	69e2                	ld	s3,24(sp)
    8000397e:	6a42                	ld	s4,16(sp)
    80003980:	6aa2                	ld	s5,8(sp)
    80003982:	bdc5                	j	80003872 <end_op+0x4c>

0000000080003984 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003984:	1101                	addi	sp,sp,-32
    80003986:	ec06                	sd	ra,24(sp)
    80003988:	e822                	sd	s0,16(sp)
    8000398a:	e426                	sd	s1,8(sp)
    8000398c:	e04a                	sd	s2,0(sp)
    8000398e:	1000                	addi	s0,sp,32
    80003990:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003992:	00018917          	auipc	s2,0x18
    80003996:	b8e90913          	addi	s2,s2,-1138 # 8001b520 <log>
    8000399a:	854a                	mv	a0,s2
    8000399c:	00003097          	auipc	ra,0x3
    800039a0:	ba0080e7          	jalr	-1120(ra) # 8000653c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800039a4:	02c92603          	lw	a2,44(s2)
    800039a8:	47f5                	li	a5,29
    800039aa:	06c7c563          	blt	a5,a2,80003a14 <log_write+0x90>
    800039ae:	00018797          	auipc	a5,0x18
    800039b2:	b8e7a783          	lw	a5,-1138(a5) # 8001b53c <log+0x1c>
    800039b6:	37fd                	addiw	a5,a5,-1
    800039b8:	04f65e63          	bge	a2,a5,80003a14 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800039bc:	00018797          	auipc	a5,0x18
    800039c0:	b847a783          	lw	a5,-1148(a5) # 8001b540 <log+0x20>
    800039c4:	06f05063          	blez	a5,80003a24 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800039c8:	4781                	li	a5,0
    800039ca:	06c05563          	blez	a2,80003a34 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800039ce:	44cc                	lw	a1,12(s1)
    800039d0:	00018717          	auipc	a4,0x18
    800039d4:	b8070713          	addi	a4,a4,-1152 # 8001b550 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800039d8:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800039da:	4314                	lw	a3,0(a4)
    800039dc:	04b68c63          	beq	a3,a1,80003a34 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800039e0:	2785                	addiw	a5,a5,1
    800039e2:	0711                	addi	a4,a4,4
    800039e4:	fef61be3          	bne	a2,a5,800039da <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800039e8:	0621                	addi	a2,a2,8
    800039ea:	060a                	slli	a2,a2,0x2
    800039ec:	00018797          	auipc	a5,0x18
    800039f0:	b3478793          	addi	a5,a5,-1228 # 8001b520 <log>
    800039f4:	97b2                	add	a5,a5,a2
    800039f6:	44d8                	lw	a4,12(s1)
    800039f8:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800039fa:	8526                	mv	a0,s1
    800039fc:	fffff097          	auipc	ra,0xfffff
    80003a00:	d7a080e7          	jalr	-646(ra) # 80002776 <bpin>
    log.lh.n++;
    80003a04:	00018717          	auipc	a4,0x18
    80003a08:	b1c70713          	addi	a4,a4,-1252 # 8001b520 <log>
    80003a0c:	575c                	lw	a5,44(a4)
    80003a0e:	2785                	addiw	a5,a5,1
    80003a10:	d75c                	sw	a5,44(a4)
    80003a12:	a82d                	j	80003a4c <log_write+0xc8>
    panic("too big a transaction");
    80003a14:	00005517          	auipc	a0,0x5
    80003a18:	b2450513          	addi	a0,a0,-1244 # 80008538 <etext+0x538>
    80003a1c:	00002097          	auipc	ra,0x2
    80003a20:	5a6080e7          	jalr	1446(ra) # 80005fc2 <panic>
    panic("log_write outside of trans");
    80003a24:	00005517          	auipc	a0,0x5
    80003a28:	b2c50513          	addi	a0,a0,-1236 # 80008550 <etext+0x550>
    80003a2c:	00002097          	auipc	ra,0x2
    80003a30:	596080e7          	jalr	1430(ra) # 80005fc2 <panic>
  log.lh.block[i] = b->blockno;
    80003a34:	00878693          	addi	a3,a5,8
    80003a38:	068a                	slli	a3,a3,0x2
    80003a3a:	00018717          	auipc	a4,0x18
    80003a3e:	ae670713          	addi	a4,a4,-1306 # 8001b520 <log>
    80003a42:	9736                	add	a4,a4,a3
    80003a44:	44d4                	lw	a3,12(s1)
    80003a46:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003a48:	faf609e3          	beq	a2,a5,800039fa <log_write+0x76>
  }
  release(&log.lock);
    80003a4c:	00018517          	auipc	a0,0x18
    80003a50:	ad450513          	addi	a0,a0,-1324 # 8001b520 <log>
    80003a54:	00003097          	auipc	ra,0x3
    80003a58:	b9c080e7          	jalr	-1124(ra) # 800065f0 <release>
}
    80003a5c:	60e2                	ld	ra,24(sp)
    80003a5e:	6442                	ld	s0,16(sp)
    80003a60:	64a2                	ld	s1,8(sp)
    80003a62:	6902                	ld	s2,0(sp)
    80003a64:	6105                	addi	sp,sp,32
    80003a66:	8082                	ret

0000000080003a68 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003a68:	1101                	addi	sp,sp,-32
    80003a6a:	ec06                	sd	ra,24(sp)
    80003a6c:	e822                	sd	s0,16(sp)
    80003a6e:	e426                	sd	s1,8(sp)
    80003a70:	e04a                	sd	s2,0(sp)
    80003a72:	1000                	addi	s0,sp,32
    80003a74:	84aa                	mv	s1,a0
    80003a76:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a78:	00005597          	auipc	a1,0x5
    80003a7c:	af858593          	addi	a1,a1,-1288 # 80008570 <etext+0x570>
    80003a80:	0521                	addi	a0,a0,8
    80003a82:	00003097          	auipc	ra,0x3
    80003a86:	a2a080e7          	jalr	-1494(ra) # 800064ac <initlock>
  lk->name = name;
    80003a8a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003a8e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a92:	0204a423          	sw	zero,40(s1)
}
    80003a96:	60e2                	ld	ra,24(sp)
    80003a98:	6442                	ld	s0,16(sp)
    80003a9a:	64a2                	ld	s1,8(sp)
    80003a9c:	6902                	ld	s2,0(sp)
    80003a9e:	6105                	addi	sp,sp,32
    80003aa0:	8082                	ret

0000000080003aa2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003aa2:	1101                	addi	sp,sp,-32
    80003aa4:	ec06                	sd	ra,24(sp)
    80003aa6:	e822                	sd	s0,16(sp)
    80003aa8:	e426                	sd	s1,8(sp)
    80003aaa:	e04a                	sd	s2,0(sp)
    80003aac:	1000                	addi	s0,sp,32
    80003aae:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003ab0:	00850913          	addi	s2,a0,8
    80003ab4:	854a                	mv	a0,s2
    80003ab6:	00003097          	auipc	ra,0x3
    80003aba:	a86080e7          	jalr	-1402(ra) # 8000653c <acquire>
  while (lk->locked) {
    80003abe:	409c                	lw	a5,0(s1)
    80003ac0:	cb89                	beqz	a5,80003ad2 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003ac2:	85ca                	mv	a1,s2
    80003ac4:	8526                	mv	a0,s1
    80003ac6:	ffffe097          	auipc	ra,0xffffe
    80003aca:	c58080e7          	jalr	-936(ra) # 8000171e <sleep>
  while (lk->locked) {
    80003ace:	409c                	lw	a5,0(s1)
    80003ad0:	fbed                	bnez	a5,80003ac2 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003ad2:	4785                	li	a5,1
    80003ad4:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003ad6:	ffffd097          	auipc	ra,0xffffd
    80003ada:	514080e7          	jalr	1300(ra) # 80000fea <myproc>
    80003ade:	591c                	lw	a5,48(a0)
    80003ae0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003ae2:	854a                	mv	a0,s2
    80003ae4:	00003097          	auipc	ra,0x3
    80003ae8:	b0c080e7          	jalr	-1268(ra) # 800065f0 <release>
}
    80003aec:	60e2                	ld	ra,24(sp)
    80003aee:	6442                	ld	s0,16(sp)
    80003af0:	64a2                	ld	s1,8(sp)
    80003af2:	6902                	ld	s2,0(sp)
    80003af4:	6105                	addi	sp,sp,32
    80003af6:	8082                	ret

0000000080003af8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003af8:	1101                	addi	sp,sp,-32
    80003afa:	ec06                	sd	ra,24(sp)
    80003afc:	e822                	sd	s0,16(sp)
    80003afe:	e426                	sd	s1,8(sp)
    80003b00:	e04a                	sd	s2,0(sp)
    80003b02:	1000                	addi	s0,sp,32
    80003b04:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b06:	00850913          	addi	s2,a0,8
    80003b0a:	854a                	mv	a0,s2
    80003b0c:	00003097          	auipc	ra,0x3
    80003b10:	a30080e7          	jalr	-1488(ra) # 8000653c <acquire>
  lk->locked = 0;
    80003b14:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b18:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003b1c:	8526                	mv	a0,s1
    80003b1e:	ffffe097          	auipc	ra,0xffffe
    80003b22:	c64080e7          	jalr	-924(ra) # 80001782 <wakeup>
  release(&lk->lk);
    80003b26:	854a                	mv	a0,s2
    80003b28:	00003097          	auipc	ra,0x3
    80003b2c:	ac8080e7          	jalr	-1336(ra) # 800065f0 <release>
}
    80003b30:	60e2                	ld	ra,24(sp)
    80003b32:	6442                	ld	s0,16(sp)
    80003b34:	64a2                	ld	s1,8(sp)
    80003b36:	6902                	ld	s2,0(sp)
    80003b38:	6105                	addi	sp,sp,32
    80003b3a:	8082                	ret

0000000080003b3c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003b3c:	7179                	addi	sp,sp,-48
    80003b3e:	f406                	sd	ra,40(sp)
    80003b40:	f022                	sd	s0,32(sp)
    80003b42:	ec26                	sd	s1,24(sp)
    80003b44:	e84a                	sd	s2,16(sp)
    80003b46:	1800                	addi	s0,sp,48
    80003b48:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003b4a:	00850913          	addi	s2,a0,8
    80003b4e:	854a                	mv	a0,s2
    80003b50:	00003097          	auipc	ra,0x3
    80003b54:	9ec080e7          	jalr	-1556(ra) # 8000653c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b58:	409c                	lw	a5,0(s1)
    80003b5a:	ef91                	bnez	a5,80003b76 <holdingsleep+0x3a>
    80003b5c:	4481                	li	s1,0
  release(&lk->lk);
    80003b5e:	854a                	mv	a0,s2
    80003b60:	00003097          	auipc	ra,0x3
    80003b64:	a90080e7          	jalr	-1392(ra) # 800065f0 <release>
  return r;
}
    80003b68:	8526                	mv	a0,s1
    80003b6a:	70a2                	ld	ra,40(sp)
    80003b6c:	7402                	ld	s0,32(sp)
    80003b6e:	64e2                	ld	s1,24(sp)
    80003b70:	6942                	ld	s2,16(sp)
    80003b72:	6145                	addi	sp,sp,48
    80003b74:	8082                	ret
    80003b76:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b78:	0284a983          	lw	s3,40(s1)
    80003b7c:	ffffd097          	auipc	ra,0xffffd
    80003b80:	46e080e7          	jalr	1134(ra) # 80000fea <myproc>
    80003b84:	5904                	lw	s1,48(a0)
    80003b86:	413484b3          	sub	s1,s1,s3
    80003b8a:	0014b493          	seqz	s1,s1
    80003b8e:	69a2                	ld	s3,8(sp)
    80003b90:	b7f9                	j	80003b5e <holdingsleep+0x22>

0000000080003b92 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b92:	1141                	addi	sp,sp,-16
    80003b94:	e406                	sd	ra,8(sp)
    80003b96:	e022                	sd	s0,0(sp)
    80003b98:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b9a:	00005597          	auipc	a1,0x5
    80003b9e:	9e658593          	addi	a1,a1,-1562 # 80008580 <etext+0x580>
    80003ba2:	00018517          	auipc	a0,0x18
    80003ba6:	ac650513          	addi	a0,a0,-1338 # 8001b668 <ftable>
    80003baa:	00003097          	auipc	ra,0x3
    80003bae:	902080e7          	jalr	-1790(ra) # 800064ac <initlock>
}
    80003bb2:	60a2                	ld	ra,8(sp)
    80003bb4:	6402                	ld	s0,0(sp)
    80003bb6:	0141                	addi	sp,sp,16
    80003bb8:	8082                	ret

0000000080003bba <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003bba:	1101                	addi	sp,sp,-32
    80003bbc:	ec06                	sd	ra,24(sp)
    80003bbe:	e822                	sd	s0,16(sp)
    80003bc0:	e426                	sd	s1,8(sp)
    80003bc2:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003bc4:	00018517          	auipc	a0,0x18
    80003bc8:	aa450513          	addi	a0,a0,-1372 # 8001b668 <ftable>
    80003bcc:	00003097          	auipc	ra,0x3
    80003bd0:	970080e7          	jalr	-1680(ra) # 8000653c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003bd4:	00018497          	auipc	s1,0x18
    80003bd8:	aac48493          	addi	s1,s1,-1364 # 8001b680 <ftable+0x18>
    80003bdc:	00019717          	auipc	a4,0x19
    80003be0:	a4470713          	addi	a4,a4,-1468 # 8001c620 <disk>
    if(f->ref == 0){
    80003be4:	40dc                	lw	a5,4(s1)
    80003be6:	cf99                	beqz	a5,80003c04 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003be8:	02848493          	addi	s1,s1,40
    80003bec:	fee49ce3          	bne	s1,a4,80003be4 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003bf0:	00018517          	auipc	a0,0x18
    80003bf4:	a7850513          	addi	a0,a0,-1416 # 8001b668 <ftable>
    80003bf8:	00003097          	auipc	ra,0x3
    80003bfc:	9f8080e7          	jalr	-1544(ra) # 800065f0 <release>
  return 0;
    80003c00:	4481                	li	s1,0
    80003c02:	a819                	j	80003c18 <filealloc+0x5e>
      f->ref = 1;
    80003c04:	4785                	li	a5,1
    80003c06:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003c08:	00018517          	auipc	a0,0x18
    80003c0c:	a6050513          	addi	a0,a0,-1440 # 8001b668 <ftable>
    80003c10:	00003097          	auipc	ra,0x3
    80003c14:	9e0080e7          	jalr	-1568(ra) # 800065f0 <release>
}
    80003c18:	8526                	mv	a0,s1
    80003c1a:	60e2                	ld	ra,24(sp)
    80003c1c:	6442                	ld	s0,16(sp)
    80003c1e:	64a2                	ld	s1,8(sp)
    80003c20:	6105                	addi	sp,sp,32
    80003c22:	8082                	ret

0000000080003c24 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003c24:	1101                	addi	sp,sp,-32
    80003c26:	ec06                	sd	ra,24(sp)
    80003c28:	e822                	sd	s0,16(sp)
    80003c2a:	e426                	sd	s1,8(sp)
    80003c2c:	1000                	addi	s0,sp,32
    80003c2e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003c30:	00018517          	auipc	a0,0x18
    80003c34:	a3850513          	addi	a0,a0,-1480 # 8001b668 <ftable>
    80003c38:	00003097          	auipc	ra,0x3
    80003c3c:	904080e7          	jalr	-1788(ra) # 8000653c <acquire>
  if(f->ref < 1)
    80003c40:	40dc                	lw	a5,4(s1)
    80003c42:	02f05263          	blez	a5,80003c66 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003c46:	2785                	addiw	a5,a5,1
    80003c48:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003c4a:	00018517          	auipc	a0,0x18
    80003c4e:	a1e50513          	addi	a0,a0,-1506 # 8001b668 <ftable>
    80003c52:	00003097          	auipc	ra,0x3
    80003c56:	99e080e7          	jalr	-1634(ra) # 800065f0 <release>
  return f;
}
    80003c5a:	8526                	mv	a0,s1
    80003c5c:	60e2                	ld	ra,24(sp)
    80003c5e:	6442                	ld	s0,16(sp)
    80003c60:	64a2                	ld	s1,8(sp)
    80003c62:	6105                	addi	sp,sp,32
    80003c64:	8082                	ret
    panic("filedup");
    80003c66:	00005517          	auipc	a0,0x5
    80003c6a:	92250513          	addi	a0,a0,-1758 # 80008588 <etext+0x588>
    80003c6e:	00002097          	auipc	ra,0x2
    80003c72:	354080e7          	jalr	852(ra) # 80005fc2 <panic>

0000000080003c76 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003c76:	7139                	addi	sp,sp,-64
    80003c78:	fc06                	sd	ra,56(sp)
    80003c7a:	f822                	sd	s0,48(sp)
    80003c7c:	f426                	sd	s1,40(sp)
    80003c7e:	0080                	addi	s0,sp,64
    80003c80:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c82:	00018517          	auipc	a0,0x18
    80003c86:	9e650513          	addi	a0,a0,-1562 # 8001b668 <ftable>
    80003c8a:	00003097          	auipc	ra,0x3
    80003c8e:	8b2080e7          	jalr	-1870(ra) # 8000653c <acquire>
  if(f->ref < 1)
    80003c92:	40dc                	lw	a5,4(s1)
    80003c94:	04f05c63          	blez	a5,80003cec <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003c98:	37fd                	addiw	a5,a5,-1
    80003c9a:	0007871b          	sext.w	a4,a5
    80003c9e:	c0dc                	sw	a5,4(s1)
    80003ca0:	06e04263          	bgtz	a4,80003d04 <fileclose+0x8e>
    80003ca4:	f04a                	sd	s2,32(sp)
    80003ca6:	ec4e                	sd	s3,24(sp)
    80003ca8:	e852                	sd	s4,16(sp)
    80003caa:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003cac:	0004a903          	lw	s2,0(s1)
    80003cb0:	0094ca83          	lbu	s5,9(s1)
    80003cb4:	0104ba03          	ld	s4,16(s1)
    80003cb8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003cbc:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003cc0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003cc4:	00018517          	auipc	a0,0x18
    80003cc8:	9a450513          	addi	a0,a0,-1628 # 8001b668 <ftable>
    80003ccc:	00003097          	auipc	ra,0x3
    80003cd0:	924080e7          	jalr	-1756(ra) # 800065f0 <release>

  if(ff.type == FD_PIPE){
    80003cd4:	4785                	li	a5,1
    80003cd6:	04f90463          	beq	s2,a5,80003d1e <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003cda:	3979                	addiw	s2,s2,-2
    80003cdc:	4785                	li	a5,1
    80003cde:	0527fb63          	bgeu	a5,s2,80003d34 <fileclose+0xbe>
    80003ce2:	7902                	ld	s2,32(sp)
    80003ce4:	69e2                	ld	s3,24(sp)
    80003ce6:	6a42                	ld	s4,16(sp)
    80003ce8:	6aa2                	ld	s5,8(sp)
    80003cea:	a02d                	j	80003d14 <fileclose+0x9e>
    80003cec:	f04a                	sd	s2,32(sp)
    80003cee:	ec4e                	sd	s3,24(sp)
    80003cf0:	e852                	sd	s4,16(sp)
    80003cf2:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003cf4:	00005517          	auipc	a0,0x5
    80003cf8:	89c50513          	addi	a0,a0,-1892 # 80008590 <etext+0x590>
    80003cfc:	00002097          	auipc	ra,0x2
    80003d00:	2c6080e7          	jalr	710(ra) # 80005fc2 <panic>
    release(&ftable.lock);
    80003d04:	00018517          	auipc	a0,0x18
    80003d08:	96450513          	addi	a0,a0,-1692 # 8001b668 <ftable>
    80003d0c:	00003097          	auipc	ra,0x3
    80003d10:	8e4080e7          	jalr	-1820(ra) # 800065f0 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003d14:	70e2                	ld	ra,56(sp)
    80003d16:	7442                	ld	s0,48(sp)
    80003d18:	74a2                	ld	s1,40(sp)
    80003d1a:	6121                	addi	sp,sp,64
    80003d1c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003d1e:	85d6                	mv	a1,s5
    80003d20:	8552                	mv	a0,s4
    80003d22:	00000097          	auipc	ra,0x0
    80003d26:	3a2080e7          	jalr	930(ra) # 800040c4 <pipeclose>
    80003d2a:	7902                	ld	s2,32(sp)
    80003d2c:	69e2                	ld	s3,24(sp)
    80003d2e:	6a42                	ld	s4,16(sp)
    80003d30:	6aa2                	ld	s5,8(sp)
    80003d32:	b7cd                	j	80003d14 <fileclose+0x9e>
    begin_op();
    80003d34:	00000097          	auipc	ra,0x0
    80003d38:	a78080e7          	jalr	-1416(ra) # 800037ac <begin_op>
    iput(ff.ip);
    80003d3c:	854e                	mv	a0,s3
    80003d3e:	fffff097          	auipc	ra,0xfffff
    80003d42:	25e080e7          	jalr	606(ra) # 80002f9c <iput>
    end_op();
    80003d46:	00000097          	auipc	ra,0x0
    80003d4a:	ae0080e7          	jalr	-1312(ra) # 80003826 <end_op>
    80003d4e:	7902                	ld	s2,32(sp)
    80003d50:	69e2                	ld	s3,24(sp)
    80003d52:	6a42                	ld	s4,16(sp)
    80003d54:	6aa2                	ld	s5,8(sp)
    80003d56:	bf7d                	j	80003d14 <fileclose+0x9e>

0000000080003d58 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003d58:	715d                	addi	sp,sp,-80
    80003d5a:	e486                	sd	ra,72(sp)
    80003d5c:	e0a2                	sd	s0,64(sp)
    80003d5e:	fc26                	sd	s1,56(sp)
    80003d60:	f44e                	sd	s3,40(sp)
    80003d62:	0880                	addi	s0,sp,80
    80003d64:	84aa                	mv	s1,a0
    80003d66:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003d68:	ffffd097          	auipc	ra,0xffffd
    80003d6c:	282080e7          	jalr	642(ra) # 80000fea <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003d70:	409c                	lw	a5,0(s1)
    80003d72:	37f9                	addiw	a5,a5,-2
    80003d74:	4705                	li	a4,1
    80003d76:	04f76863          	bltu	a4,a5,80003dc6 <filestat+0x6e>
    80003d7a:	f84a                	sd	s2,48(sp)
    80003d7c:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d7e:	6c88                	ld	a0,24(s1)
    80003d80:	fffff097          	auipc	ra,0xfffff
    80003d84:	05e080e7          	jalr	94(ra) # 80002dde <ilock>
    stati(f->ip, &st);
    80003d88:	fb840593          	addi	a1,s0,-72
    80003d8c:	6c88                	ld	a0,24(s1)
    80003d8e:	fffff097          	auipc	ra,0xfffff
    80003d92:	2de080e7          	jalr	734(ra) # 8000306c <stati>
    iunlock(f->ip);
    80003d96:	6c88                	ld	a0,24(s1)
    80003d98:	fffff097          	auipc	ra,0xfffff
    80003d9c:	10c080e7          	jalr	268(ra) # 80002ea4 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003da0:	46e1                	li	a3,24
    80003da2:	fb840613          	addi	a2,s0,-72
    80003da6:	85ce                	mv	a1,s3
    80003da8:	05093503          	ld	a0,80(s2)
    80003dac:	ffffd097          	auipc	ra,0xffffd
    80003db0:	da0080e7          	jalr	-608(ra) # 80000b4c <copyout>
    80003db4:	41f5551b          	sraiw	a0,a0,0x1f
    80003db8:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003dba:	60a6                	ld	ra,72(sp)
    80003dbc:	6406                	ld	s0,64(sp)
    80003dbe:	74e2                	ld	s1,56(sp)
    80003dc0:	79a2                	ld	s3,40(sp)
    80003dc2:	6161                	addi	sp,sp,80
    80003dc4:	8082                	ret
  return -1;
    80003dc6:	557d                	li	a0,-1
    80003dc8:	bfcd                	j	80003dba <filestat+0x62>

0000000080003dca <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003dca:	7179                	addi	sp,sp,-48
    80003dcc:	f406                	sd	ra,40(sp)
    80003dce:	f022                	sd	s0,32(sp)
    80003dd0:	e84a                	sd	s2,16(sp)
    80003dd2:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003dd4:	00854783          	lbu	a5,8(a0)
    80003dd8:	cbc5                	beqz	a5,80003e88 <fileread+0xbe>
    80003dda:	ec26                	sd	s1,24(sp)
    80003ddc:	e44e                	sd	s3,8(sp)
    80003dde:	84aa                	mv	s1,a0
    80003de0:	89ae                	mv	s3,a1
    80003de2:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003de4:	411c                	lw	a5,0(a0)
    80003de6:	4705                	li	a4,1
    80003de8:	04e78963          	beq	a5,a4,80003e3a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003dec:	470d                	li	a4,3
    80003dee:	04e78f63          	beq	a5,a4,80003e4c <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003df2:	4709                	li	a4,2
    80003df4:	08e79263          	bne	a5,a4,80003e78 <fileread+0xae>
    ilock(f->ip);
    80003df8:	6d08                	ld	a0,24(a0)
    80003dfa:	fffff097          	auipc	ra,0xfffff
    80003dfe:	fe4080e7          	jalr	-28(ra) # 80002dde <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003e02:	874a                	mv	a4,s2
    80003e04:	5094                	lw	a3,32(s1)
    80003e06:	864e                	mv	a2,s3
    80003e08:	4585                	li	a1,1
    80003e0a:	6c88                	ld	a0,24(s1)
    80003e0c:	fffff097          	auipc	ra,0xfffff
    80003e10:	28a080e7          	jalr	650(ra) # 80003096 <readi>
    80003e14:	892a                	mv	s2,a0
    80003e16:	00a05563          	blez	a0,80003e20 <fileread+0x56>
      f->off += r;
    80003e1a:	509c                	lw	a5,32(s1)
    80003e1c:	9fa9                	addw	a5,a5,a0
    80003e1e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003e20:	6c88                	ld	a0,24(s1)
    80003e22:	fffff097          	auipc	ra,0xfffff
    80003e26:	082080e7          	jalr	130(ra) # 80002ea4 <iunlock>
    80003e2a:	64e2                	ld	s1,24(sp)
    80003e2c:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003e2e:	854a                	mv	a0,s2
    80003e30:	70a2                	ld	ra,40(sp)
    80003e32:	7402                	ld	s0,32(sp)
    80003e34:	6942                	ld	s2,16(sp)
    80003e36:	6145                	addi	sp,sp,48
    80003e38:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003e3a:	6908                	ld	a0,16(a0)
    80003e3c:	00000097          	auipc	ra,0x0
    80003e40:	400080e7          	jalr	1024(ra) # 8000423c <piperead>
    80003e44:	892a                	mv	s2,a0
    80003e46:	64e2                	ld	s1,24(sp)
    80003e48:	69a2                	ld	s3,8(sp)
    80003e4a:	b7d5                	j	80003e2e <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003e4c:	02451783          	lh	a5,36(a0)
    80003e50:	03079693          	slli	a3,a5,0x30
    80003e54:	92c1                	srli	a3,a3,0x30
    80003e56:	4725                	li	a4,9
    80003e58:	02d76a63          	bltu	a4,a3,80003e8c <fileread+0xc2>
    80003e5c:	0792                	slli	a5,a5,0x4
    80003e5e:	00017717          	auipc	a4,0x17
    80003e62:	76a70713          	addi	a4,a4,1898 # 8001b5c8 <devsw>
    80003e66:	97ba                	add	a5,a5,a4
    80003e68:	639c                	ld	a5,0(a5)
    80003e6a:	c78d                	beqz	a5,80003e94 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003e6c:	4505                	li	a0,1
    80003e6e:	9782                	jalr	a5
    80003e70:	892a                	mv	s2,a0
    80003e72:	64e2                	ld	s1,24(sp)
    80003e74:	69a2                	ld	s3,8(sp)
    80003e76:	bf65                	j	80003e2e <fileread+0x64>
    panic("fileread");
    80003e78:	00004517          	auipc	a0,0x4
    80003e7c:	72850513          	addi	a0,a0,1832 # 800085a0 <etext+0x5a0>
    80003e80:	00002097          	auipc	ra,0x2
    80003e84:	142080e7          	jalr	322(ra) # 80005fc2 <panic>
    return -1;
    80003e88:	597d                	li	s2,-1
    80003e8a:	b755                	j	80003e2e <fileread+0x64>
      return -1;
    80003e8c:	597d                	li	s2,-1
    80003e8e:	64e2                	ld	s1,24(sp)
    80003e90:	69a2                	ld	s3,8(sp)
    80003e92:	bf71                	j	80003e2e <fileread+0x64>
    80003e94:	597d                	li	s2,-1
    80003e96:	64e2                	ld	s1,24(sp)
    80003e98:	69a2                	ld	s3,8(sp)
    80003e9a:	bf51                	j	80003e2e <fileread+0x64>

0000000080003e9c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003e9c:	00954783          	lbu	a5,9(a0)
    80003ea0:	12078963          	beqz	a5,80003fd2 <filewrite+0x136>
{
    80003ea4:	715d                	addi	sp,sp,-80
    80003ea6:	e486                	sd	ra,72(sp)
    80003ea8:	e0a2                	sd	s0,64(sp)
    80003eaa:	f84a                	sd	s2,48(sp)
    80003eac:	f052                	sd	s4,32(sp)
    80003eae:	e85a                	sd	s6,16(sp)
    80003eb0:	0880                	addi	s0,sp,80
    80003eb2:	892a                	mv	s2,a0
    80003eb4:	8b2e                	mv	s6,a1
    80003eb6:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003eb8:	411c                	lw	a5,0(a0)
    80003eba:	4705                	li	a4,1
    80003ebc:	02e78763          	beq	a5,a4,80003eea <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ec0:	470d                	li	a4,3
    80003ec2:	02e78a63          	beq	a5,a4,80003ef6 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ec6:	4709                	li	a4,2
    80003ec8:	0ee79863          	bne	a5,a4,80003fb8 <filewrite+0x11c>
    80003ecc:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003ece:	0cc05463          	blez	a2,80003f96 <filewrite+0xfa>
    80003ed2:	fc26                	sd	s1,56(sp)
    80003ed4:	ec56                	sd	s5,24(sp)
    80003ed6:	e45e                	sd	s7,8(sp)
    80003ed8:	e062                	sd	s8,0(sp)
    int i = 0;
    80003eda:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003edc:	6b85                	lui	s7,0x1
    80003ede:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003ee2:	6c05                	lui	s8,0x1
    80003ee4:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003ee8:	a851                	j	80003f7c <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003eea:	6908                	ld	a0,16(a0)
    80003eec:	00000097          	auipc	ra,0x0
    80003ef0:	248080e7          	jalr	584(ra) # 80004134 <pipewrite>
    80003ef4:	a85d                	j	80003faa <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003ef6:	02451783          	lh	a5,36(a0)
    80003efa:	03079693          	slli	a3,a5,0x30
    80003efe:	92c1                	srli	a3,a3,0x30
    80003f00:	4725                	li	a4,9
    80003f02:	0cd76a63          	bltu	a4,a3,80003fd6 <filewrite+0x13a>
    80003f06:	0792                	slli	a5,a5,0x4
    80003f08:	00017717          	auipc	a4,0x17
    80003f0c:	6c070713          	addi	a4,a4,1728 # 8001b5c8 <devsw>
    80003f10:	97ba                	add	a5,a5,a4
    80003f12:	679c                	ld	a5,8(a5)
    80003f14:	c3f9                	beqz	a5,80003fda <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003f16:	4505                	li	a0,1
    80003f18:	9782                	jalr	a5
    80003f1a:	a841                	j	80003faa <filewrite+0x10e>
      if(n1 > max)
    80003f1c:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003f20:	00000097          	auipc	ra,0x0
    80003f24:	88c080e7          	jalr	-1908(ra) # 800037ac <begin_op>
      ilock(f->ip);
    80003f28:	01893503          	ld	a0,24(s2)
    80003f2c:	fffff097          	auipc	ra,0xfffff
    80003f30:	eb2080e7          	jalr	-334(ra) # 80002dde <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003f34:	8756                	mv	a4,s5
    80003f36:	02092683          	lw	a3,32(s2)
    80003f3a:	01698633          	add	a2,s3,s6
    80003f3e:	4585                	li	a1,1
    80003f40:	01893503          	ld	a0,24(s2)
    80003f44:	fffff097          	auipc	ra,0xfffff
    80003f48:	262080e7          	jalr	610(ra) # 800031a6 <writei>
    80003f4c:	84aa                	mv	s1,a0
    80003f4e:	00a05763          	blez	a0,80003f5c <filewrite+0xc0>
        f->off += r;
    80003f52:	02092783          	lw	a5,32(s2)
    80003f56:	9fa9                	addw	a5,a5,a0
    80003f58:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003f5c:	01893503          	ld	a0,24(s2)
    80003f60:	fffff097          	auipc	ra,0xfffff
    80003f64:	f44080e7          	jalr	-188(ra) # 80002ea4 <iunlock>
      end_op();
    80003f68:	00000097          	auipc	ra,0x0
    80003f6c:	8be080e7          	jalr	-1858(ra) # 80003826 <end_op>

      if(r != n1){
    80003f70:	029a9563          	bne	s5,s1,80003f9a <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003f74:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003f78:	0149da63          	bge	s3,s4,80003f8c <filewrite+0xf0>
      int n1 = n - i;
    80003f7c:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003f80:	0004879b          	sext.w	a5,s1
    80003f84:	f8fbdce3          	bge	s7,a5,80003f1c <filewrite+0x80>
    80003f88:	84e2                	mv	s1,s8
    80003f8a:	bf49                	j	80003f1c <filewrite+0x80>
    80003f8c:	74e2                	ld	s1,56(sp)
    80003f8e:	6ae2                	ld	s5,24(sp)
    80003f90:	6ba2                	ld	s7,8(sp)
    80003f92:	6c02                	ld	s8,0(sp)
    80003f94:	a039                	j	80003fa2 <filewrite+0x106>
    int i = 0;
    80003f96:	4981                	li	s3,0
    80003f98:	a029                	j	80003fa2 <filewrite+0x106>
    80003f9a:	74e2                	ld	s1,56(sp)
    80003f9c:	6ae2                	ld	s5,24(sp)
    80003f9e:	6ba2                	ld	s7,8(sp)
    80003fa0:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003fa2:	033a1e63          	bne	s4,s3,80003fde <filewrite+0x142>
    80003fa6:	8552                	mv	a0,s4
    80003fa8:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003faa:	60a6                	ld	ra,72(sp)
    80003fac:	6406                	ld	s0,64(sp)
    80003fae:	7942                	ld	s2,48(sp)
    80003fb0:	7a02                	ld	s4,32(sp)
    80003fb2:	6b42                	ld	s6,16(sp)
    80003fb4:	6161                	addi	sp,sp,80
    80003fb6:	8082                	ret
    80003fb8:	fc26                	sd	s1,56(sp)
    80003fba:	f44e                	sd	s3,40(sp)
    80003fbc:	ec56                	sd	s5,24(sp)
    80003fbe:	e45e                	sd	s7,8(sp)
    80003fc0:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003fc2:	00004517          	auipc	a0,0x4
    80003fc6:	5ee50513          	addi	a0,a0,1518 # 800085b0 <etext+0x5b0>
    80003fca:	00002097          	auipc	ra,0x2
    80003fce:	ff8080e7          	jalr	-8(ra) # 80005fc2 <panic>
    return -1;
    80003fd2:	557d                	li	a0,-1
}
    80003fd4:	8082                	ret
      return -1;
    80003fd6:	557d                	li	a0,-1
    80003fd8:	bfc9                	j	80003faa <filewrite+0x10e>
    80003fda:	557d                	li	a0,-1
    80003fdc:	b7f9                	j	80003faa <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003fde:	557d                	li	a0,-1
    80003fe0:	79a2                	ld	s3,40(sp)
    80003fe2:	b7e1                	j	80003faa <filewrite+0x10e>

0000000080003fe4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003fe4:	7179                	addi	sp,sp,-48
    80003fe6:	f406                	sd	ra,40(sp)
    80003fe8:	f022                	sd	s0,32(sp)
    80003fea:	ec26                	sd	s1,24(sp)
    80003fec:	e052                	sd	s4,0(sp)
    80003fee:	1800                	addi	s0,sp,48
    80003ff0:	84aa                	mv	s1,a0
    80003ff2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003ff4:	0005b023          	sd	zero,0(a1)
    80003ff8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003ffc:	00000097          	auipc	ra,0x0
    80004000:	bbe080e7          	jalr	-1090(ra) # 80003bba <filealloc>
    80004004:	e088                	sd	a0,0(s1)
    80004006:	cd49                	beqz	a0,800040a0 <pipealloc+0xbc>
    80004008:	00000097          	auipc	ra,0x0
    8000400c:	bb2080e7          	jalr	-1102(ra) # 80003bba <filealloc>
    80004010:	00aa3023          	sd	a0,0(s4)
    80004014:	c141                	beqz	a0,80004094 <pipealloc+0xb0>
    80004016:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004018:	ffffc097          	auipc	ra,0xffffc
    8000401c:	102080e7          	jalr	258(ra) # 8000011a <kalloc>
    80004020:	892a                	mv	s2,a0
    80004022:	c13d                	beqz	a0,80004088 <pipealloc+0xa4>
    80004024:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004026:	4985                	li	s3,1
    80004028:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000402c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004030:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004034:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004038:	00004597          	auipc	a1,0x4
    8000403c:	58858593          	addi	a1,a1,1416 # 800085c0 <etext+0x5c0>
    80004040:	00002097          	auipc	ra,0x2
    80004044:	46c080e7          	jalr	1132(ra) # 800064ac <initlock>
  (*f0)->type = FD_PIPE;
    80004048:	609c                	ld	a5,0(s1)
    8000404a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000404e:	609c                	ld	a5,0(s1)
    80004050:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004054:	609c                	ld	a5,0(s1)
    80004056:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000405a:	609c                	ld	a5,0(s1)
    8000405c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004060:	000a3783          	ld	a5,0(s4)
    80004064:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004068:	000a3783          	ld	a5,0(s4)
    8000406c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004070:	000a3783          	ld	a5,0(s4)
    80004074:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004078:	000a3783          	ld	a5,0(s4)
    8000407c:	0127b823          	sd	s2,16(a5)
  return 0;
    80004080:	4501                	li	a0,0
    80004082:	6942                	ld	s2,16(sp)
    80004084:	69a2                	ld	s3,8(sp)
    80004086:	a03d                	j	800040b4 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004088:	6088                	ld	a0,0(s1)
    8000408a:	c119                	beqz	a0,80004090 <pipealloc+0xac>
    8000408c:	6942                	ld	s2,16(sp)
    8000408e:	a029                	j	80004098 <pipealloc+0xb4>
    80004090:	6942                	ld	s2,16(sp)
    80004092:	a039                	j	800040a0 <pipealloc+0xbc>
    80004094:	6088                	ld	a0,0(s1)
    80004096:	c50d                	beqz	a0,800040c0 <pipealloc+0xdc>
    fileclose(*f0);
    80004098:	00000097          	auipc	ra,0x0
    8000409c:	bde080e7          	jalr	-1058(ra) # 80003c76 <fileclose>
  if(*f1)
    800040a0:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800040a4:	557d                	li	a0,-1
  if(*f1)
    800040a6:	c799                	beqz	a5,800040b4 <pipealloc+0xd0>
    fileclose(*f1);
    800040a8:	853e                	mv	a0,a5
    800040aa:	00000097          	auipc	ra,0x0
    800040ae:	bcc080e7          	jalr	-1076(ra) # 80003c76 <fileclose>
  return -1;
    800040b2:	557d                	li	a0,-1
}
    800040b4:	70a2                	ld	ra,40(sp)
    800040b6:	7402                	ld	s0,32(sp)
    800040b8:	64e2                	ld	s1,24(sp)
    800040ba:	6a02                	ld	s4,0(sp)
    800040bc:	6145                	addi	sp,sp,48
    800040be:	8082                	ret
  return -1;
    800040c0:	557d                	li	a0,-1
    800040c2:	bfcd                	j	800040b4 <pipealloc+0xd0>

00000000800040c4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800040c4:	1101                	addi	sp,sp,-32
    800040c6:	ec06                	sd	ra,24(sp)
    800040c8:	e822                	sd	s0,16(sp)
    800040ca:	e426                	sd	s1,8(sp)
    800040cc:	e04a                	sd	s2,0(sp)
    800040ce:	1000                	addi	s0,sp,32
    800040d0:	84aa                	mv	s1,a0
    800040d2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800040d4:	00002097          	auipc	ra,0x2
    800040d8:	468080e7          	jalr	1128(ra) # 8000653c <acquire>
  if(writable){
    800040dc:	02090d63          	beqz	s2,80004116 <pipeclose+0x52>
    pi->writeopen = 0;
    800040e0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800040e4:	21848513          	addi	a0,s1,536
    800040e8:	ffffd097          	auipc	ra,0xffffd
    800040ec:	69a080e7          	jalr	1690(ra) # 80001782 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800040f0:	2204b783          	ld	a5,544(s1)
    800040f4:	eb95                	bnez	a5,80004128 <pipeclose+0x64>
    release(&pi->lock);
    800040f6:	8526                	mv	a0,s1
    800040f8:	00002097          	auipc	ra,0x2
    800040fc:	4f8080e7          	jalr	1272(ra) # 800065f0 <release>
    kfree((char*)pi);
    80004100:	8526                	mv	a0,s1
    80004102:	ffffc097          	auipc	ra,0xffffc
    80004106:	f1a080e7          	jalr	-230(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    8000410a:	60e2                	ld	ra,24(sp)
    8000410c:	6442                	ld	s0,16(sp)
    8000410e:	64a2                	ld	s1,8(sp)
    80004110:	6902                	ld	s2,0(sp)
    80004112:	6105                	addi	sp,sp,32
    80004114:	8082                	ret
    pi->readopen = 0;
    80004116:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000411a:	21c48513          	addi	a0,s1,540
    8000411e:	ffffd097          	auipc	ra,0xffffd
    80004122:	664080e7          	jalr	1636(ra) # 80001782 <wakeup>
    80004126:	b7e9                	j	800040f0 <pipeclose+0x2c>
    release(&pi->lock);
    80004128:	8526                	mv	a0,s1
    8000412a:	00002097          	auipc	ra,0x2
    8000412e:	4c6080e7          	jalr	1222(ra) # 800065f0 <release>
}
    80004132:	bfe1                	j	8000410a <pipeclose+0x46>

0000000080004134 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004134:	711d                	addi	sp,sp,-96
    80004136:	ec86                	sd	ra,88(sp)
    80004138:	e8a2                	sd	s0,80(sp)
    8000413a:	e4a6                	sd	s1,72(sp)
    8000413c:	e0ca                	sd	s2,64(sp)
    8000413e:	fc4e                	sd	s3,56(sp)
    80004140:	f852                	sd	s4,48(sp)
    80004142:	f456                	sd	s5,40(sp)
    80004144:	1080                	addi	s0,sp,96
    80004146:	84aa                	mv	s1,a0
    80004148:	8aae                	mv	s5,a1
    8000414a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000414c:	ffffd097          	auipc	ra,0xffffd
    80004150:	e9e080e7          	jalr	-354(ra) # 80000fea <myproc>
    80004154:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004156:	8526                	mv	a0,s1
    80004158:	00002097          	auipc	ra,0x2
    8000415c:	3e4080e7          	jalr	996(ra) # 8000653c <acquire>
  while(i < n){
    80004160:	0d405863          	blez	s4,80004230 <pipewrite+0xfc>
    80004164:	f05a                	sd	s6,32(sp)
    80004166:	ec5e                	sd	s7,24(sp)
    80004168:	e862                	sd	s8,16(sp)
  int i = 0;
    8000416a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000416c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000416e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004172:	21c48b93          	addi	s7,s1,540
    80004176:	a089                	j	800041b8 <pipewrite+0x84>
      release(&pi->lock);
    80004178:	8526                	mv	a0,s1
    8000417a:	00002097          	auipc	ra,0x2
    8000417e:	476080e7          	jalr	1142(ra) # 800065f0 <release>
      return -1;
    80004182:	597d                	li	s2,-1
    80004184:	7b02                	ld	s6,32(sp)
    80004186:	6be2                	ld	s7,24(sp)
    80004188:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000418a:	854a                	mv	a0,s2
    8000418c:	60e6                	ld	ra,88(sp)
    8000418e:	6446                	ld	s0,80(sp)
    80004190:	64a6                	ld	s1,72(sp)
    80004192:	6906                	ld	s2,64(sp)
    80004194:	79e2                	ld	s3,56(sp)
    80004196:	7a42                	ld	s4,48(sp)
    80004198:	7aa2                	ld	s5,40(sp)
    8000419a:	6125                	addi	sp,sp,96
    8000419c:	8082                	ret
      wakeup(&pi->nread);
    8000419e:	8562                	mv	a0,s8
    800041a0:	ffffd097          	auipc	ra,0xffffd
    800041a4:	5e2080e7          	jalr	1506(ra) # 80001782 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800041a8:	85a6                	mv	a1,s1
    800041aa:	855e                	mv	a0,s7
    800041ac:	ffffd097          	auipc	ra,0xffffd
    800041b0:	572080e7          	jalr	1394(ra) # 8000171e <sleep>
  while(i < n){
    800041b4:	05495f63          	bge	s2,s4,80004212 <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    800041b8:	2204a783          	lw	a5,544(s1)
    800041bc:	dfd5                	beqz	a5,80004178 <pipewrite+0x44>
    800041be:	854e                	mv	a0,s3
    800041c0:	ffffe097          	auipc	ra,0xffffe
    800041c4:	806080e7          	jalr	-2042(ra) # 800019c6 <killed>
    800041c8:	f945                	bnez	a0,80004178 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800041ca:	2184a783          	lw	a5,536(s1)
    800041ce:	21c4a703          	lw	a4,540(s1)
    800041d2:	2007879b          	addiw	a5,a5,512
    800041d6:	fcf704e3          	beq	a4,a5,8000419e <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041da:	4685                	li	a3,1
    800041dc:	01590633          	add	a2,s2,s5
    800041e0:	faf40593          	addi	a1,s0,-81
    800041e4:	0509b503          	ld	a0,80(s3)
    800041e8:	ffffd097          	auipc	ra,0xffffd
    800041ec:	a42080e7          	jalr	-1470(ra) # 80000c2a <copyin>
    800041f0:	05650263          	beq	a0,s6,80004234 <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800041f4:	21c4a783          	lw	a5,540(s1)
    800041f8:	0017871b          	addiw	a4,a5,1
    800041fc:	20e4ae23          	sw	a4,540(s1)
    80004200:	1ff7f793          	andi	a5,a5,511
    80004204:	97a6                	add	a5,a5,s1
    80004206:	faf44703          	lbu	a4,-81(s0)
    8000420a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000420e:	2905                	addiw	s2,s2,1
    80004210:	b755                	j	800041b4 <pipewrite+0x80>
    80004212:	7b02                	ld	s6,32(sp)
    80004214:	6be2                	ld	s7,24(sp)
    80004216:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004218:	21848513          	addi	a0,s1,536
    8000421c:	ffffd097          	auipc	ra,0xffffd
    80004220:	566080e7          	jalr	1382(ra) # 80001782 <wakeup>
  release(&pi->lock);
    80004224:	8526                	mv	a0,s1
    80004226:	00002097          	auipc	ra,0x2
    8000422a:	3ca080e7          	jalr	970(ra) # 800065f0 <release>
  return i;
    8000422e:	bfb1                	j	8000418a <pipewrite+0x56>
  int i = 0;
    80004230:	4901                	li	s2,0
    80004232:	b7dd                	j	80004218 <pipewrite+0xe4>
    80004234:	7b02                	ld	s6,32(sp)
    80004236:	6be2                	ld	s7,24(sp)
    80004238:	6c42                	ld	s8,16(sp)
    8000423a:	bff9                	j	80004218 <pipewrite+0xe4>

000000008000423c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000423c:	715d                	addi	sp,sp,-80
    8000423e:	e486                	sd	ra,72(sp)
    80004240:	e0a2                	sd	s0,64(sp)
    80004242:	fc26                	sd	s1,56(sp)
    80004244:	f84a                	sd	s2,48(sp)
    80004246:	f44e                	sd	s3,40(sp)
    80004248:	f052                	sd	s4,32(sp)
    8000424a:	ec56                	sd	s5,24(sp)
    8000424c:	0880                	addi	s0,sp,80
    8000424e:	84aa                	mv	s1,a0
    80004250:	892e                	mv	s2,a1
    80004252:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004254:	ffffd097          	auipc	ra,0xffffd
    80004258:	d96080e7          	jalr	-618(ra) # 80000fea <myproc>
    8000425c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000425e:	8526                	mv	a0,s1
    80004260:	00002097          	auipc	ra,0x2
    80004264:	2dc080e7          	jalr	732(ra) # 8000653c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004268:	2184a703          	lw	a4,536(s1)
    8000426c:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004270:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004274:	02f71963          	bne	a4,a5,800042a6 <piperead+0x6a>
    80004278:	2244a783          	lw	a5,548(s1)
    8000427c:	cf95                	beqz	a5,800042b8 <piperead+0x7c>
    if(killed(pr)){
    8000427e:	8552                	mv	a0,s4
    80004280:	ffffd097          	auipc	ra,0xffffd
    80004284:	746080e7          	jalr	1862(ra) # 800019c6 <killed>
    80004288:	e10d                	bnez	a0,800042aa <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000428a:	85a6                	mv	a1,s1
    8000428c:	854e                	mv	a0,s3
    8000428e:	ffffd097          	auipc	ra,0xffffd
    80004292:	490080e7          	jalr	1168(ra) # 8000171e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004296:	2184a703          	lw	a4,536(s1)
    8000429a:	21c4a783          	lw	a5,540(s1)
    8000429e:	fcf70de3          	beq	a4,a5,80004278 <piperead+0x3c>
    800042a2:	e85a                	sd	s6,16(sp)
    800042a4:	a819                	j	800042ba <piperead+0x7e>
    800042a6:	e85a                	sd	s6,16(sp)
    800042a8:	a809                	j	800042ba <piperead+0x7e>
      release(&pi->lock);
    800042aa:	8526                	mv	a0,s1
    800042ac:	00002097          	auipc	ra,0x2
    800042b0:	344080e7          	jalr	836(ra) # 800065f0 <release>
      return -1;
    800042b4:	59fd                	li	s3,-1
    800042b6:	a0a5                	j	8000431e <piperead+0xe2>
    800042b8:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042ba:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800042bc:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042be:	05505463          	blez	s5,80004306 <piperead+0xca>
    if(pi->nread == pi->nwrite)
    800042c2:	2184a783          	lw	a5,536(s1)
    800042c6:	21c4a703          	lw	a4,540(s1)
    800042ca:	02f70e63          	beq	a4,a5,80004306 <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800042ce:	0017871b          	addiw	a4,a5,1
    800042d2:	20e4ac23          	sw	a4,536(s1)
    800042d6:	1ff7f793          	andi	a5,a5,511
    800042da:	97a6                	add	a5,a5,s1
    800042dc:	0187c783          	lbu	a5,24(a5)
    800042e0:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800042e4:	4685                	li	a3,1
    800042e6:	fbf40613          	addi	a2,s0,-65
    800042ea:	85ca                	mv	a1,s2
    800042ec:	050a3503          	ld	a0,80(s4)
    800042f0:	ffffd097          	auipc	ra,0xffffd
    800042f4:	85c080e7          	jalr	-1956(ra) # 80000b4c <copyout>
    800042f8:	01650763          	beq	a0,s6,80004306 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042fc:	2985                	addiw	s3,s3,1
    800042fe:	0905                	addi	s2,s2,1
    80004300:	fd3a91e3          	bne	s5,s3,800042c2 <piperead+0x86>
    80004304:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004306:	21c48513          	addi	a0,s1,540
    8000430a:	ffffd097          	auipc	ra,0xffffd
    8000430e:	478080e7          	jalr	1144(ra) # 80001782 <wakeup>
  release(&pi->lock);
    80004312:	8526                	mv	a0,s1
    80004314:	00002097          	auipc	ra,0x2
    80004318:	2dc080e7          	jalr	732(ra) # 800065f0 <release>
    8000431c:	6b42                	ld	s6,16(sp)
  return i;
}
    8000431e:	854e                	mv	a0,s3
    80004320:	60a6                	ld	ra,72(sp)
    80004322:	6406                	ld	s0,64(sp)
    80004324:	74e2                	ld	s1,56(sp)
    80004326:	7942                	ld	s2,48(sp)
    80004328:	79a2                	ld	s3,40(sp)
    8000432a:	7a02                	ld	s4,32(sp)
    8000432c:	6ae2                	ld	s5,24(sp)
    8000432e:	6161                	addi	sp,sp,80
    80004330:	8082                	ret

0000000080004332 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004332:	1141                	addi	sp,sp,-16
    80004334:	e422                	sd	s0,8(sp)
    80004336:	0800                	addi	s0,sp,16
    80004338:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1)
    8000433a:	8905                	andi	a0,a0,1
    8000433c:	050e                	slli	a0,a0,0x3
    perm = PTE_X;
  if (flags & 0x2)
    8000433e:	8b89                	andi	a5,a5,2
    80004340:	c399                	beqz	a5,80004346 <flags2perm+0x14>
    perm |= PTE_W;
    80004342:	00456513          	ori	a0,a0,4
  return perm;
}
    80004346:	6422                	ld	s0,8(sp)
    80004348:	0141                	addi	sp,sp,16
    8000434a:	8082                	ret

000000008000434c <exec>:

int exec(char *path, char **argv)
{
    8000434c:	df010113          	addi	sp,sp,-528
    80004350:	20113423          	sd	ra,520(sp)
    80004354:	20813023          	sd	s0,512(sp)
    80004358:	ffa6                	sd	s1,504(sp)
    8000435a:	fbca                	sd	s2,496(sp)
    8000435c:	0c00                	addi	s0,sp,528
    8000435e:	892a                	mv	s2,a0
    80004360:	dea43c23          	sd	a0,-520(s0)
    80004364:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004368:	ffffd097          	auipc	ra,0xffffd
    8000436c:	c82080e7          	jalr	-894(ra) # 80000fea <myproc>
    80004370:	84aa                	mv	s1,a0

  begin_op();
    80004372:	fffff097          	auipc	ra,0xfffff
    80004376:	43a080e7          	jalr	1082(ra) # 800037ac <begin_op>

  if ((ip = namei(path)) == 0)
    8000437a:	854a                	mv	a0,s2
    8000437c:	fffff097          	auipc	ra,0xfffff
    80004380:	230080e7          	jalr	560(ra) # 800035ac <namei>
    80004384:	c135                	beqz	a0,800043e8 <exec+0x9c>
    80004386:	f3d2                	sd	s4,480(sp)
    80004388:	8a2a                	mv	s4,a0
  {
    end_op();
    return -1;
  }
  ilock(ip);
    8000438a:	fffff097          	auipc	ra,0xfffff
    8000438e:	a54080e7          	jalr	-1452(ra) # 80002dde <ilock>

  // Check ELF header
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004392:	04000713          	li	a4,64
    80004396:	4681                	li	a3,0
    80004398:	e5040613          	addi	a2,s0,-432
    8000439c:	4581                	li	a1,0
    8000439e:	8552                	mv	a0,s4
    800043a0:	fffff097          	auipc	ra,0xfffff
    800043a4:	cf6080e7          	jalr	-778(ra) # 80003096 <readi>
    800043a8:	04000793          	li	a5,64
    800043ac:	00f51a63          	bne	a0,a5,800043c0 <exec+0x74>
    goto bad;

  if (elf.magic != ELF_MAGIC)
    800043b0:	e5042703          	lw	a4,-432(s0)
    800043b4:	464c47b7          	lui	a5,0x464c4
    800043b8:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800043bc:	02f70c63          	beq	a4,a5,800043f4 <exec+0xa8>
bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip)
  {
    iunlockput(ip);
    800043c0:	8552                	mv	a0,s4
    800043c2:	fffff097          	auipc	ra,0xfffff
    800043c6:	c82080e7          	jalr	-894(ra) # 80003044 <iunlockput>
    end_op();
    800043ca:	fffff097          	auipc	ra,0xfffff
    800043ce:	45c080e7          	jalr	1116(ra) # 80003826 <end_op>
  }
  return -1;
    800043d2:	557d                	li	a0,-1
    800043d4:	7a1e                	ld	s4,480(sp)
}
    800043d6:	20813083          	ld	ra,520(sp)
    800043da:	20013403          	ld	s0,512(sp)
    800043de:	74fe                	ld	s1,504(sp)
    800043e0:	795e                	ld	s2,496(sp)
    800043e2:	21010113          	addi	sp,sp,528
    800043e6:	8082                	ret
    end_op();
    800043e8:	fffff097          	auipc	ra,0xfffff
    800043ec:	43e080e7          	jalr	1086(ra) # 80003826 <end_op>
    return -1;
    800043f0:	557d                	li	a0,-1
    800043f2:	b7d5                	j	800043d6 <exec+0x8a>
    800043f4:	ebda                	sd	s6,464(sp)
  if ((pagetable = proc_pagetable(p)) == 0)
    800043f6:	8526                	mv	a0,s1
    800043f8:	ffffd097          	auipc	ra,0xffffd
    800043fc:	cba080e7          	jalr	-838(ra) # 800010b2 <proc_pagetable>
    80004400:	8b2a                	mv	s6,a0
    80004402:	32050b63          	beqz	a0,80004738 <exec+0x3ec>
    80004406:	f7ce                	sd	s3,488(sp)
    80004408:	efd6                	sd	s5,472(sp)
    8000440a:	e7de                	sd	s7,456(sp)
    8000440c:	e3e2                	sd	s8,448(sp)
    8000440e:	ff66                	sd	s9,440(sp)
    80004410:	fb6a                	sd	s10,432(sp)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
    80004412:	e7042d03          	lw	s10,-400(s0)
    80004416:	e8845783          	lhu	a5,-376(s0)
    8000441a:	14078d63          	beqz	a5,80004574 <exec+0x228>
    8000441e:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004420:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
    80004422:	4d81                	li	s11,0
    if (ph.vaddr % PGSIZE != 0)
    80004424:	6c85                	lui	s9,0x1
    80004426:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000442a:	def43823          	sd	a5,-528(s0)
  for (i = 0; i < sz; i += PGSIZE)
  {
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    if (sz - i < PGSIZE)
    8000442e:	6a85                	lui	s5,0x1
    80004430:	a0b5                	j	8000449c <exec+0x150>
      panic("loadseg: address should exist");
    80004432:	00004517          	auipc	a0,0x4
    80004436:	19650513          	addi	a0,a0,406 # 800085c8 <etext+0x5c8>
    8000443a:	00002097          	auipc	ra,0x2
    8000443e:	b88080e7          	jalr	-1144(ra) # 80005fc2 <panic>
    if (sz - i < PGSIZE)
    80004442:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    80004444:	8726                	mv	a4,s1
    80004446:	012c06bb          	addw	a3,s8,s2
    8000444a:	4581                	li	a1,0
    8000444c:	8552                	mv	a0,s4
    8000444e:	fffff097          	auipc	ra,0xfffff
    80004452:	c48080e7          	jalr	-952(ra) # 80003096 <readi>
    80004456:	2501                	sext.w	a0,a0
    80004458:	2aa49463          	bne	s1,a0,80004700 <exec+0x3b4>
  for (i = 0; i < sz; i += PGSIZE)
    8000445c:	012a893b          	addw	s2,s5,s2
    80004460:	03397563          	bgeu	s2,s3,8000448a <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80004464:	02091593          	slli	a1,s2,0x20
    80004468:	9181                	srli	a1,a1,0x20
    8000446a:	95de                	add	a1,a1,s7
    8000446c:	855a                	mv	a0,s6
    8000446e:	ffffc097          	auipc	ra,0xffffc
    80004472:	08e080e7          	jalr	142(ra) # 800004fc <walkaddr>
    80004476:	862a                	mv	a2,a0
    if (pa == 0)
    80004478:	dd4d                	beqz	a0,80004432 <exec+0xe6>
    if (sz - i < PGSIZE)
    8000447a:	412984bb          	subw	s1,s3,s2
    8000447e:	0004879b          	sext.w	a5,s1
    80004482:	fcfcf0e3          	bgeu	s9,a5,80004442 <exec+0xf6>
    80004486:	84d6                	mv	s1,s5
    80004488:	bf6d                	j	80004442 <exec+0xf6>
    sz = sz1;
    8000448a:	e0843903          	ld	s2,-504(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
    8000448e:	2d85                	addiw	s11,s11,1
    80004490:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80004494:	e8845783          	lhu	a5,-376(s0)
    80004498:	08fdd663          	bge	s11,a5,80004524 <exec+0x1d8>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000449c:	2d01                	sext.w	s10,s10
    8000449e:	03800713          	li	a4,56
    800044a2:	86ea                	mv	a3,s10
    800044a4:	e1840613          	addi	a2,s0,-488
    800044a8:	4581                	li	a1,0
    800044aa:	8552                	mv	a0,s4
    800044ac:	fffff097          	auipc	ra,0xfffff
    800044b0:	bea080e7          	jalr	-1046(ra) # 80003096 <readi>
    800044b4:	03800793          	li	a5,56
    800044b8:	20f51c63          	bne	a0,a5,800046d0 <exec+0x384>
    if (ph.type != ELF_PROG_LOAD)
    800044bc:	e1842783          	lw	a5,-488(s0)
    800044c0:	4705                	li	a4,1
    800044c2:	fce796e3          	bne	a5,a4,8000448e <exec+0x142>
    if (ph.memsz < ph.filesz)
    800044c6:	e4043483          	ld	s1,-448(s0)
    800044ca:	e3843783          	ld	a5,-456(s0)
    800044ce:	20f4e563          	bltu	s1,a5,800046d8 <exec+0x38c>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    800044d2:	e2843783          	ld	a5,-472(s0)
    800044d6:	94be                	add	s1,s1,a5
    800044d8:	20f4e463          	bltu	s1,a5,800046e0 <exec+0x394>
    if (ph.vaddr % PGSIZE != 0)
    800044dc:	df043703          	ld	a4,-528(s0)
    800044e0:	8ff9                	and	a5,a5,a4
    800044e2:	20079363          	bnez	a5,800046e8 <exec+0x39c>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044e6:	e1c42503          	lw	a0,-484(s0)
    800044ea:	00000097          	auipc	ra,0x0
    800044ee:	e48080e7          	jalr	-440(ra) # 80004332 <flags2perm>
    800044f2:	86aa                	mv	a3,a0
    800044f4:	8626                	mv	a2,s1
    800044f6:	85ca                	mv	a1,s2
    800044f8:	855a                	mv	a0,s6
    800044fa:	ffffc097          	auipc	ra,0xffffc
    800044fe:	3ea080e7          	jalr	1002(ra) # 800008e4 <uvmalloc>
    80004502:	e0a43423          	sd	a0,-504(s0)
    80004506:	1e050563          	beqz	a0,800046f0 <exec+0x3a4>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000450a:	e2843b83          	ld	s7,-472(s0)
    8000450e:	e2042c03          	lw	s8,-480(s0)
    80004512:	e3842983          	lw	s3,-456(s0)
  for (i = 0; i < sz; i += PGSIZE)
    80004516:	00098463          	beqz	s3,8000451e <exec+0x1d2>
    8000451a:	4901                	li	s2,0
    8000451c:	b7a1                	j	80004464 <exec+0x118>
    sz = sz1;
    8000451e:	e0843903          	ld	s2,-504(s0)
    80004522:	b7b5                	j	8000448e <exec+0x142>
    80004524:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004526:	8552                	mv	a0,s4
    80004528:	fffff097          	auipc	ra,0xfffff
    8000452c:	b1c080e7          	jalr	-1252(ra) # 80003044 <iunlockput>
  end_op();
    80004530:	fffff097          	auipc	ra,0xfffff
    80004534:	2f6080e7          	jalr	758(ra) # 80003826 <end_op>
  p = myproc();
    80004538:	ffffd097          	auipc	ra,0xffffd
    8000453c:	ab2080e7          	jalr	-1358(ra) # 80000fea <myproc>
    80004540:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004542:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004546:	6985                	lui	s3,0x1
    80004548:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000454a:	99ca                	add	s3,s3,s2
    8000454c:	77fd                	lui	a5,0xfffff
    8000454e:	00f9f9b3          	and	s3,s3,a5
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE, PTE_W)) == 0)
    80004552:	4691                	li	a3,4
    80004554:	6609                	lui	a2,0x2
    80004556:	964e                	add	a2,a2,s3
    80004558:	85ce                	mv	a1,s3
    8000455a:	855a                	mv	a0,s6
    8000455c:	ffffc097          	auipc	ra,0xffffc
    80004560:	388080e7          	jalr	904(ra) # 800008e4 <uvmalloc>
    80004564:	892a                	mv	s2,a0
    80004566:	e0a43423          	sd	a0,-504(s0)
    8000456a:	e519                	bnez	a0,80004578 <exec+0x22c>
  if (pagetable)
    8000456c:	e1343423          	sd	s3,-504(s0)
    80004570:	4a01                	li	s4,0
    80004572:	aa41                	j	80004702 <exec+0x3b6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004574:	4901                	li	s2,0
    80004576:	bf45                	j	80004526 <exec+0x1da>
  uvmclear(pagetable, sz - 2 * PGSIZE);
    80004578:	75f9                	lui	a1,0xffffe
    8000457a:	95aa                	add	a1,a1,a0
    8000457c:	855a                	mv	a0,s6
    8000457e:	ffffc097          	auipc	ra,0xffffc
    80004582:	59c080e7          	jalr	1436(ra) # 80000b1a <uvmclear>
  stackbase = sp - PGSIZE;
    80004586:	7bfd                	lui	s7,0xfffff
    80004588:	9bca                	add	s7,s7,s2
  for (argc = 0; argv[argc]; argc++)
    8000458a:	e0043783          	ld	a5,-512(s0)
    8000458e:	6388                	ld	a0,0(a5)
    80004590:	c52d                	beqz	a0,800045fa <exec+0x2ae>
    80004592:	e9040993          	addi	s3,s0,-368
    80004596:	f9040c13          	addi	s8,s0,-112
    8000459a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000459c:	ffffc097          	auipc	ra,0xffffc
    800045a0:	d52080e7          	jalr	-686(ra) # 800002ee <strlen>
    800045a4:	0015079b          	addiw	a5,a0,1
    800045a8:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800045ac:	ff07f913          	andi	s2,a5,-16
    if (sp < stackbase)
    800045b0:	15796463          	bltu	s2,s7,800046f8 <exec+0x3ac>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800045b4:	e0043d03          	ld	s10,-512(s0)
    800045b8:	000d3a03          	ld	s4,0(s10)
    800045bc:	8552                	mv	a0,s4
    800045be:	ffffc097          	auipc	ra,0xffffc
    800045c2:	d30080e7          	jalr	-720(ra) # 800002ee <strlen>
    800045c6:	0015069b          	addiw	a3,a0,1
    800045ca:	8652                	mv	a2,s4
    800045cc:	85ca                	mv	a1,s2
    800045ce:	855a                	mv	a0,s6
    800045d0:	ffffc097          	auipc	ra,0xffffc
    800045d4:	57c080e7          	jalr	1404(ra) # 80000b4c <copyout>
    800045d8:	12054263          	bltz	a0,800046fc <exec+0x3b0>
    ustack[argc] = sp;
    800045dc:	0129b023          	sd	s2,0(s3)
  for (argc = 0; argv[argc]; argc++)
    800045e0:	0485                	addi	s1,s1,1
    800045e2:	008d0793          	addi	a5,s10,8
    800045e6:	e0f43023          	sd	a5,-512(s0)
    800045ea:	008d3503          	ld	a0,8(s10)
    800045ee:	c909                	beqz	a0,80004600 <exec+0x2b4>
    if (argc >= MAXARG)
    800045f0:	09a1                	addi	s3,s3,8
    800045f2:	fb8995e3          	bne	s3,s8,8000459c <exec+0x250>
  ip = 0;
    800045f6:	4a01                	li	s4,0
    800045f8:	a229                	j	80004702 <exec+0x3b6>
  sp = sz;
    800045fa:	e0843903          	ld	s2,-504(s0)
  for (argc = 0; argv[argc]; argc++)
    800045fe:	4481                	li	s1,0
  ustack[argc] = 0;
    80004600:	00349793          	slli	a5,s1,0x3
    80004604:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffda5f0>
    80004608:	97a2                	add	a5,a5,s0
    8000460a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    8000460e:	00148693          	addi	a3,s1,1
    80004612:	068e                	slli	a3,a3,0x3
    80004614:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004618:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000461c:	e0843983          	ld	s3,-504(s0)
  if (sp < stackbase)
    80004620:	f57966e3          	bltu	s2,s7,8000456c <exec+0x220>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    80004624:	e9040613          	addi	a2,s0,-368
    80004628:	85ca                	mv	a1,s2
    8000462a:	855a                	mv	a0,s6
    8000462c:	ffffc097          	auipc	ra,0xffffc
    80004630:	520080e7          	jalr	1312(ra) # 80000b4c <copyout>
    80004634:	10054463          	bltz	a0,8000473c <exec+0x3f0>
  p->trapframe->a1 = sp;
    80004638:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000463c:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    80004640:	df843783          	ld	a5,-520(s0)
    80004644:	0007c703          	lbu	a4,0(a5)
    80004648:	cf11                	beqz	a4,80004664 <exec+0x318>
    8000464a:	0785                	addi	a5,a5,1
    if (*s == '/')
    8000464c:	02f00693          	li	a3,47
    80004650:	a039                	j	8000465e <exec+0x312>
      last = s + 1;
    80004652:	def43c23          	sd	a5,-520(s0)
  for (last = s = path; *s; s++)
    80004656:	0785                	addi	a5,a5,1
    80004658:	fff7c703          	lbu	a4,-1(a5)
    8000465c:	c701                	beqz	a4,80004664 <exec+0x318>
    if (*s == '/')
    8000465e:	fed71ce3          	bne	a4,a3,80004656 <exec+0x30a>
    80004662:	bfc5                	j	80004652 <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    80004664:	4641                	li	a2,16
    80004666:	df843583          	ld	a1,-520(s0)
    8000466a:	158a8513          	addi	a0,s5,344
    8000466e:	ffffc097          	auipc	ra,0xffffc
    80004672:	c4e080e7          	jalr	-946(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    80004676:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000467a:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000467e:	e0843783          	ld	a5,-504(s0)
    80004682:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry; // initial program counter = main
    80004686:	058ab783          	ld	a5,88(s5)
    8000468a:	e6843703          	ld	a4,-408(s0)
    8000468e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    80004690:	058ab783          	ld	a5,88(s5)
    80004694:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004698:	85e6                	mv	a1,s9
    8000469a:	ffffd097          	auipc	ra,0xffffd
    8000469e:	af8080e7          	jalr	-1288(ra) # 80001192 <proc_freepagetable>
  if (p->pid == 1)
    800046a2:	030aa703          	lw	a4,48(s5)
    800046a6:	4785                	li	a5,1
    800046a8:	00f70d63          	beq	a4,a5,800046c2 <exec+0x376>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800046ac:	0004851b          	sext.w	a0,s1
    800046b0:	79be                	ld	s3,488(sp)
    800046b2:	7a1e                	ld	s4,480(sp)
    800046b4:	6afe                	ld	s5,472(sp)
    800046b6:	6b5e                	ld	s6,464(sp)
    800046b8:	6bbe                	ld	s7,456(sp)
    800046ba:	6c1e                	ld	s8,448(sp)
    800046bc:	7cfa                	ld	s9,440(sp)
    800046be:	7d5a                	ld	s10,432(sp)
    800046c0:	bb19                	j	800043d6 <exec+0x8a>
    vmprint(p->pagetable);
    800046c2:	050ab503          	ld	a0,80(s5)
    800046c6:	ffffc097          	auipc	ra,0xffffc
    800046ca:	762080e7          	jalr	1890(ra) # 80000e28 <vmprint>
    800046ce:	bff9                	j	800046ac <exec+0x360>
    800046d0:	e1243423          	sd	s2,-504(s0)
    800046d4:	7dba                	ld	s11,424(sp)
    800046d6:	a035                	j	80004702 <exec+0x3b6>
    800046d8:	e1243423          	sd	s2,-504(s0)
    800046dc:	7dba                	ld	s11,424(sp)
    800046de:	a015                	j	80004702 <exec+0x3b6>
    800046e0:	e1243423          	sd	s2,-504(s0)
    800046e4:	7dba                	ld	s11,424(sp)
    800046e6:	a831                	j	80004702 <exec+0x3b6>
    800046e8:	e1243423          	sd	s2,-504(s0)
    800046ec:	7dba                	ld	s11,424(sp)
    800046ee:	a811                	j	80004702 <exec+0x3b6>
    800046f0:	e1243423          	sd	s2,-504(s0)
    800046f4:	7dba                	ld	s11,424(sp)
    800046f6:	a031                	j	80004702 <exec+0x3b6>
  ip = 0;
    800046f8:	4a01                	li	s4,0
    800046fa:	a021                	j	80004702 <exec+0x3b6>
    800046fc:	4a01                	li	s4,0
  if (pagetable)
    800046fe:	a011                	j	80004702 <exec+0x3b6>
    80004700:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004702:	e0843583          	ld	a1,-504(s0)
    80004706:	855a                	mv	a0,s6
    80004708:	ffffd097          	auipc	ra,0xffffd
    8000470c:	a8a080e7          	jalr	-1398(ra) # 80001192 <proc_freepagetable>
  return -1;
    80004710:	557d                	li	a0,-1
  if (ip)
    80004712:	000a1b63          	bnez	s4,80004728 <exec+0x3dc>
    80004716:	79be                	ld	s3,488(sp)
    80004718:	7a1e                	ld	s4,480(sp)
    8000471a:	6afe                	ld	s5,472(sp)
    8000471c:	6b5e                	ld	s6,464(sp)
    8000471e:	6bbe                	ld	s7,456(sp)
    80004720:	6c1e                	ld	s8,448(sp)
    80004722:	7cfa                	ld	s9,440(sp)
    80004724:	7d5a                	ld	s10,432(sp)
    80004726:	b945                	j	800043d6 <exec+0x8a>
    80004728:	79be                	ld	s3,488(sp)
    8000472a:	6afe                	ld	s5,472(sp)
    8000472c:	6b5e                	ld	s6,464(sp)
    8000472e:	6bbe                	ld	s7,456(sp)
    80004730:	6c1e                	ld	s8,448(sp)
    80004732:	7cfa                	ld	s9,440(sp)
    80004734:	7d5a                	ld	s10,432(sp)
    80004736:	b169                	j	800043c0 <exec+0x74>
    80004738:	6b5e                	ld	s6,464(sp)
    8000473a:	b159                	j	800043c0 <exec+0x74>
  sz = sz1;
    8000473c:	e0843983          	ld	s3,-504(s0)
    80004740:	b535                	j	8000456c <exec+0x220>

0000000080004742 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004742:	7179                	addi	sp,sp,-48
    80004744:	f406                	sd	ra,40(sp)
    80004746:	f022                	sd	s0,32(sp)
    80004748:	ec26                	sd	s1,24(sp)
    8000474a:	e84a                	sd	s2,16(sp)
    8000474c:	1800                	addi	s0,sp,48
    8000474e:	892e                	mv	s2,a1
    80004750:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004752:	fdc40593          	addi	a1,s0,-36
    80004756:	ffffe097          	auipc	ra,0xffffe
    8000475a:	a3e080e7          	jalr	-1474(ra) # 80002194 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000475e:	fdc42703          	lw	a4,-36(s0)
    80004762:	47bd                	li	a5,15
    80004764:	02e7eb63          	bltu	a5,a4,8000479a <argfd+0x58>
    80004768:	ffffd097          	auipc	ra,0xffffd
    8000476c:	882080e7          	jalr	-1918(ra) # 80000fea <myproc>
    80004770:	fdc42703          	lw	a4,-36(s0)
    80004774:	01a70793          	addi	a5,a4,26
    80004778:	078e                	slli	a5,a5,0x3
    8000477a:	953e                	add	a0,a0,a5
    8000477c:	611c                	ld	a5,0(a0)
    8000477e:	c385                	beqz	a5,8000479e <argfd+0x5c>
    return -1;
  if(pfd)
    80004780:	00090463          	beqz	s2,80004788 <argfd+0x46>
    *pfd = fd;
    80004784:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004788:	4501                	li	a0,0
  if(pf)
    8000478a:	c091                	beqz	s1,8000478e <argfd+0x4c>
    *pf = f;
    8000478c:	e09c                	sd	a5,0(s1)
}
    8000478e:	70a2                	ld	ra,40(sp)
    80004790:	7402                	ld	s0,32(sp)
    80004792:	64e2                	ld	s1,24(sp)
    80004794:	6942                	ld	s2,16(sp)
    80004796:	6145                	addi	sp,sp,48
    80004798:	8082                	ret
    return -1;
    8000479a:	557d                	li	a0,-1
    8000479c:	bfcd                	j	8000478e <argfd+0x4c>
    8000479e:	557d                	li	a0,-1
    800047a0:	b7fd                	j	8000478e <argfd+0x4c>

00000000800047a2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800047a2:	1101                	addi	sp,sp,-32
    800047a4:	ec06                	sd	ra,24(sp)
    800047a6:	e822                	sd	s0,16(sp)
    800047a8:	e426                	sd	s1,8(sp)
    800047aa:	1000                	addi	s0,sp,32
    800047ac:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800047ae:	ffffd097          	auipc	ra,0xffffd
    800047b2:	83c080e7          	jalr	-1988(ra) # 80000fea <myproc>
    800047b6:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800047b8:	0d050793          	addi	a5,a0,208
    800047bc:	4501                	li	a0,0
    800047be:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800047c0:	6398                	ld	a4,0(a5)
    800047c2:	cb19                	beqz	a4,800047d8 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800047c4:	2505                	addiw	a0,a0,1
    800047c6:	07a1                	addi	a5,a5,8
    800047c8:	fed51ce3          	bne	a0,a3,800047c0 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800047cc:	557d                	li	a0,-1
}
    800047ce:	60e2                	ld	ra,24(sp)
    800047d0:	6442                	ld	s0,16(sp)
    800047d2:	64a2                	ld	s1,8(sp)
    800047d4:	6105                	addi	sp,sp,32
    800047d6:	8082                	ret
      p->ofile[fd] = f;
    800047d8:	01a50793          	addi	a5,a0,26
    800047dc:	078e                	slli	a5,a5,0x3
    800047de:	963e                	add	a2,a2,a5
    800047e0:	e204                	sd	s1,0(a2)
      return fd;
    800047e2:	b7f5                	j	800047ce <fdalloc+0x2c>

00000000800047e4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800047e4:	715d                	addi	sp,sp,-80
    800047e6:	e486                	sd	ra,72(sp)
    800047e8:	e0a2                	sd	s0,64(sp)
    800047ea:	fc26                	sd	s1,56(sp)
    800047ec:	f84a                	sd	s2,48(sp)
    800047ee:	f44e                	sd	s3,40(sp)
    800047f0:	ec56                	sd	s5,24(sp)
    800047f2:	e85a                	sd	s6,16(sp)
    800047f4:	0880                	addi	s0,sp,80
    800047f6:	8b2e                	mv	s6,a1
    800047f8:	89b2                	mv	s3,a2
    800047fa:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800047fc:	fb040593          	addi	a1,s0,-80
    80004800:	fffff097          	auipc	ra,0xfffff
    80004804:	dca080e7          	jalr	-566(ra) # 800035ca <nameiparent>
    80004808:	84aa                	mv	s1,a0
    8000480a:	14050e63          	beqz	a0,80004966 <create+0x182>
    return 0;

  ilock(dp);
    8000480e:	ffffe097          	auipc	ra,0xffffe
    80004812:	5d0080e7          	jalr	1488(ra) # 80002dde <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004816:	4601                	li	a2,0
    80004818:	fb040593          	addi	a1,s0,-80
    8000481c:	8526                	mv	a0,s1
    8000481e:	fffff097          	auipc	ra,0xfffff
    80004822:	acc080e7          	jalr	-1332(ra) # 800032ea <dirlookup>
    80004826:	8aaa                	mv	s5,a0
    80004828:	c539                	beqz	a0,80004876 <create+0x92>
    iunlockput(dp);
    8000482a:	8526                	mv	a0,s1
    8000482c:	fffff097          	auipc	ra,0xfffff
    80004830:	818080e7          	jalr	-2024(ra) # 80003044 <iunlockput>
    ilock(ip);
    80004834:	8556                	mv	a0,s5
    80004836:	ffffe097          	auipc	ra,0xffffe
    8000483a:	5a8080e7          	jalr	1448(ra) # 80002dde <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000483e:	4789                	li	a5,2
    80004840:	02fb1463          	bne	s6,a5,80004868 <create+0x84>
    80004844:	044ad783          	lhu	a5,68(s5)
    80004848:	37f9                	addiw	a5,a5,-2
    8000484a:	17c2                	slli	a5,a5,0x30
    8000484c:	93c1                	srli	a5,a5,0x30
    8000484e:	4705                	li	a4,1
    80004850:	00f76c63          	bltu	a4,a5,80004868 <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004854:	8556                	mv	a0,s5
    80004856:	60a6                	ld	ra,72(sp)
    80004858:	6406                	ld	s0,64(sp)
    8000485a:	74e2                	ld	s1,56(sp)
    8000485c:	7942                	ld	s2,48(sp)
    8000485e:	79a2                	ld	s3,40(sp)
    80004860:	6ae2                	ld	s5,24(sp)
    80004862:	6b42                	ld	s6,16(sp)
    80004864:	6161                	addi	sp,sp,80
    80004866:	8082                	ret
    iunlockput(ip);
    80004868:	8556                	mv	a0,s5
    8000486a:	ffffe097          	auipc	ra,0xffffe
    8000486e:	7da080e7          	jalr	2010(ra) # 80003044 <iunlockput>
    return 0;
    80004872:	4a81                	li	s5,0
    80004874:	b7c5                	j	80004854 <create+0x70>
    80004876:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004878:	85da                	mv	a1,s6
    8000487a:	4088                	lw	a0,0(s1)
    8000487c:	ffffe097          	auipc	ra,0xffffe
    80004880:	3be080e7          	jalr	958(ra) # 80002c3a <ialloc>
    80004884:	8a2a                	mv	s4,a0
    80004886:	c531                	beqz	a0,800048d2 <create+0xee>
  ilock(ip);
    80004888:	ffffe097          	auipc	ra,0xffffe
    8000488c:	556080e7          	jalr	1366(ra) # 80002dde <ilock>
  ip->major = major;
    80004890:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004894:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004898:	4905                	li	s2,1
    8000489a:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000489e:	8552                	mv	a0,s4
    800048a0:	ffffe097          	auipc	ra,0xffffe
    800048a4:	472080e7          	jalr	1138(ra) # 80002d12 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800048a8:	032b0d63          	beq	s6,s2,800048e2 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800048ac:	004a2603          	lw	a2,4(s4)
    800048b0:	fb040593          	addi	a1,s0,-80
    800048b4:	8526                	mv	a0,s1
    800048b6:	fffff097          	auipc	ra,0xfffff
    800048ba:	c44080e7          	jalr	-956(ra) # 800034fa <dirlink>
    800048be:	08054163          	bltz	a0,80004940 <create+0x15c>
  iunlockput(dp);
    800048c2:	8526                	mv	a0,s1
    800048c4:	ffffe097          	auipc	ra,0xffffe
    800048c8:	780080e7          	jalr	1920(ra) # 80003044 <iunlockput>
  return ip;
    800048cc:	8ad2                	mv	s5,s4
    800048ce:	7a02                	ld	s4,32(sp)
    800048d0:	b751                	j	80004854 <create+0x70>
    iunlockput(dp);
    800048d2:	8526                	mv	a0,s1
    800048d4:	ffffe097          	auipc	ra,0xffffe
    800048d8:	770080e7          	jalr	1904(ra) # 80003044 <iunlockput>
    return 0;
    800048dc:	8ad2                	mv	s5,s4
    800048de:	7a02                	ld	s4,32(sp)
    800048e0:	bf95                	j	80004854 <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800048e2:	004a2603          	lw	a2,4(s4)
    800048e6:	00004597          	auipc	a1,0x4
    800048ea:	d0258593          	addi	a1,a1,-766 # 800085e8 <etext+0x5e8>
    800048ee:	8552                	mv	a0,s4
    800048f0:	fffff097          	auipc	ra,0xfffff
    800048f4:	c0a080e7          	jalr	-1014(ra) # 800034fa <dirlink>
    800048f8:	04054463          	bltz	a0,80004940 <create+0x15c>
    800048fc:	40d0                	lw	a2,4(s1)
    800048fe:	00004597          	auipc	a1,0x4
    80004902:	cf258593          	addi	a1,a1,-782 # 800085f0 <etext+0x5f0>
    80004906:	8552                	mv	a0,s4
    80004908:	fffff097          	auipc	ra,0xfffff
    8000490c:	bf2080e7          	jalr	-1038(ra) # 800034fa <dirlink>
    80004910:	02054863          	bltz	a0,80004940 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004914:	004a2603          	lw	a2,4(s4)
    80004918:	fb040593          	addi	a1,s0,-80
    8000491c:	8526                	mv	a0,s1
    8000491e:	fffff097          	auipc	ra,0xfffff
    80004922:	bdc080e7          	jalr	-1060(ra) # 800034fa <dirlink>
    80004926:	00054d63          	bltz	a0,80004940 <create+0x15c>
    dp->nlink++;  // for ".."
    8000492a:	04a4d783          	lhu	a5,74(s1)
    8000492e:	2785                	addiw	a5,a5,1
    80004930:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004934:	8526                	mv	a0,s1
    80004936:	ffffe097          	auipc	ra,0xffffe
    8000493a:	3dc080e7          	jalr	988(ra) # 80002d12 <iupdate>
    8000493e:	b751                	j	800048c2 <create+0xde>
  ip->nlink = 0;
    80004940:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004944:	8552                	mv	a0,s4
    80004946:	ffffe097          	auipc	ra,0xffffe
    8000494a:	3cc080e7          	jalr	972(ra) # 80002d12 <iupdate>
  iunlockput(ip);
    8000494e:	8552                	mv	a0,s4
    80004950:	ffffe097          	auipc	ra,0xffffe
    80004954:	6f4080e7          	jalr	1780(ra) # 80003044 <iunlockput>
  iunlockput(dp);
    80004958:	8526                	mv	a0,s1
    8000495a:	ffffe097          	auipc	ra,0xffffe
    8000495e:	6ea080e7          	jalr	1770(ra) # 80003044 <iunlockput>
  return 0;
    80004962:	7a02                	ld	s4,32(sp)
    80004964:	bdc5                	j	80004854 <create+0x70>
    return 0;
    80004966:	8aaa                	mv	s5,a0
    80004968:	b5f5                	j	80004854 <create+0x70>

000000008000496a <sys_dup>:
{
    8000496a:	7179                	addi	sp,sp,-48
    8000496c:	f406                	sd	ra,40(sp)
    8000496e:	f022                	sd	s0,32(sp)
    80004970:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004972:	fd840613          	addi	a2,s0,-40
    80004976:	4581                	li	a1,0
    80004978:	4501                	li	a0,0
    8000497a:	00000097          	auipc	ra,0x0
    8000497e:	dc8080e7          	jalr	-568(ra) # 80004742 <argfd>
    return -1;
    80004982:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004984:	02054763          	bltz	a0,800049b2 <sys_dup+0x48>
    80004988:	ec26                	sd	s1,24(sp)
    8000498a:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    8000498c:	fd843903          	ld	s2,-40(s0)
    80004990:	854a                	mv	a0,s2
    80004992:	00000097          	auipc	ra,0x0
    80004996:	e10080e7          	jalr	-496(ra) # 800047a2 <fdalloc>
    8000499a:	84aa                	mv	s1,a0
    return -1;
    8000499c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000499e:	00054f63          	bltz	a0,800049bc <sys_dup+0x52>
  filedup(f);
    800049a2:	854a                	mv	a0,s2
    800049a4:	fffff097          	auipc	ra,0xfffff
    800049a8:	280080e7          	jalr	640(ra) # 80003c24 <filedup>
  return fd;
    800049ac:	87a6                	mv	a5,s1
    800049ae:	64e2                	ld	s1,24(sp)
    800049b0:	6942                	ld	s2,16(sp)
}
    800049b2:	853e                	mv	a0,a5
    800049b4:	70a2                	ld	ra,40(sp)
    800049b6:	7402                	ld	s0,32(sp)
    800049b8:	6145                	addi	sp,sp,48
    800049ba:	8082                	ret
    800049bc:	64e2                	ld	s1,24(sp)
    800049be:	6942                	ld	s2,16(sp)
    800049c0:	bfcd                	j	800049b2 <sys_dup+0x48>

00000000800049c2 <sys_read>:
{
    800049c2:	7179                	addi	sp,sp,-48
    800049c4:	f406                	sd	ra,40(sp)
    800049c6:	f022                	sd	s0,32(sp)
    800049c8:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800049ca:	fd840593          	addi	a1,s0,-40
    800049ce:	4505                	li	a0,1
    800049d0:	ffffd097          	auipc	ra,0xffffd
    800049d4:	7e4080e7          	jalr	2020(ra) # 800021b4 <argaddr>
  argint(2, &n);
    800049d8:	fe440593          	addi	a1,s0,-28
    800049dc:	4509                	li	a0,2
    800049de:	ffffd097          	auipc	ra,0xffffd
    800049e2:	7b6080e7          	jalr	1974(ra) # 80002194 <argint>
  if(argfd(0, 0, &f) < 0)
    800049e6:	fe840613          	addi	a2,s0,-24
    800049ea:	4581                	li	a1,0
    800049ec:	4501                	li	a0,0
    800049ee:	00000097          	auipc	ra,0x0
    800049f2:	d54080e7          	jalr	-684(ra) # 80004742 <argfd>
    800049f6:	87aa                	mv	a5,a0
    return -1;
    800049f8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800049fa:	0007cc63          	bltz	a5,80004a12 <sys_read+0x50>
  return fileread(f, p, n);
    800049fe:	fe442603          	lw	a2,-28(s0)
    80004a02:	fd843583          	ld	a1,-40(s0)
    80004a06:	fe843503          	ld	a0,-24(s0)
    80004a0a:	fffff097          	auipc	ra,0xfffff
    80004a0e:	3c0080e7          	jalr	960(ra) # 80003dca <fileread>
}
    80004a12:	70a2                	ld	ra,40(sp)
    80004a14:	7402                	ld	s0,32(sp)
    80004a16:	6145                	addi	sp,sp,48
    80004a18:	8082                	ret

0000000080004a1a <sys_write>:
{
    80004a1a:	7179                	addi	sp,sp,-48
    80004a1c:	f406                	sd	ra,40(sp)
    80004a1e:	f022                	sd	s0,32(sp)
    80004a20:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004a22:	fd840593          	addi	a1,s0,-40
    80004a26:	4505                	li	a0,1
    80004a28:	ffffd097          	auipc	ra,0xffffd
    80004a2c:	78c080e7          	jalr	1932(ra) # 800021b4 <argaddr>
  argint(2, &n);
    80004a30:	fe440593          	addi	a1,s0,-28
    80004a34:	4509                	li	a0,2
    80004a36:	ffffd097          	auipc	ra,0xffffd
    80004a3a:	75e080e7          	jalr	1886(ra) # 80002194 <argint>
  if(argfd(0, 0, &f) < 0)
    80004a3e:	fe840613          	addi	a2,s0,-24
    80004a42:	4581                	li	a1,0
    80004a44:	4501                	li	a0,0
    80004a46:	00000097          	auipc	ra,0x0
    80004a4a:	cfc080e7          	jalr	-772(ra) # 80004742 <argfd>
    80004a4e:	87aa                	mv	a5,a0
    return -1;
    80004a50:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a52:	0007cc63          	bltz	a5,80004a6a <sys_write+0x50>
  return filewrite(f, p, n);
    80004a56:	fe442603          	lw	a2,-28(s0)
    80004a5a:	fd843583          	ld	a1,-40(s0)
    80004a5e:	fe843503          	ld	a0,-24(s0)
    80004a62:	fffff097          	auipc	ra,0xfffff
    80004a66:	43a080e7          	jalr	1082(ra) # 80003e9c <filewrite>
}
    80004a6a:	70a2                	ld	ra,40(sp)
    80004a6c:	7402                	ld	s0,32(sp)
    80004a6e:	6145                	addi	sp,sp,48
    80004a70:	8082                	ret

0000000080004a72 <sys_close>:
{
    80004a72:	1101                	addi	sp,sp,-32
    80004a74:	ec06                	sd	ra,24(sp)
    80004a76:	e822                	sd	s0,16(sp)
    80004a78:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004a7a:	fe040613          	addi	a2,s0,-32
    80004a7e:	fec40593          	addi	a1,s0,-20
    80004a82:	4501                	li	a0,0
    80004a84:	00000097          	auipc	ra,0x0
    80004a88:	cbe080e7          	jalr	-834(ra) # 80004742 <argfd>
    return -1;
    80004a8c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004a8e:	02054463          	bltz	a0,80004ab6 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004a92:	ffffc097          	auipc	ra,0xffffc
    80004a96:	558080e7          	jalr	1368(ra) # 80000fea <myproc>
    80004a9a:	fec42783          	lw	a5,-20(s0)
    80004a9e:	07e9                	addi	a5,a5,26
    80004aa0:	078e                	slli	a5,a5,0x3
    80004aa2:	953e                	add	a0,a0,a5
    80004aa4:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004aa8:	fe043503          	ld	a0,-32(s0)
    80004aac:	fffff097          	auipc	ra,0xfffff
    80004ab0:	1ca080e7          	jalr	458(ra) # 80003c76 <fileclose>
  return 0;
    80004ab4:	4781                	li	a5,0
}
    80004ab6:	853e                	mv	a0,a5
    80004ab8:	60e2                	ld	ra,24(sp)
    80004aba:	6442                	ld	s0,16(sp)
    80004abc:	6105                	addi	sp,sp,32
    80004abe:	8082                	ret

0000000080004ac0 <sys_fstat>:
{
    80004ac0:	1101                	addi	sp,sp,-32
    80004ac2:	ec06                	sd	ra,24(sp)
    80004ac4:	e822                	sd	s0,16(sp)
    80004ac6:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004ac8:	fe040593          	addi	a1,s0,-32
    80004acc:	4505                	li	a0,1
    80004ace:	ffffd097          	auipc	ra,0xffffd
    80004ad2:	6e6080e7          	jalr	1766(ra) # 800021b4 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004ad6:	fe840613          	addi	a2,s0,-24
    80004ada:	4581                	li	a1,0
    80004adc:	4501                	li	a0,0
    80004ade:	00000097          	auipc	ra,0x0
    80004ae2:	c64080e7          	jalr	-924(ra) # 80004742 <argfd>
    80004ae6:	87aa                	mv	a5,a0
    return -1;
    80004ae8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004aea:	0007ca63          	bltz	a5,80004afe <sys_fstat+0x3e>
  return filestat(f, st);
    80004aee:	fe043583          	ld	a1,-32(s0)
    80004af2:	fe843503          	ld	a0,-24(s0)
    80004af6:	fffff097          	auipc	ra,0xfffff
    80004afa:	262080e7          	jalr	610(ra) # 80003d58 <filestat>
}
    80004afe:	60e2                	ld	ra,24(sp)
    80004b00:	6442                	ld	s0,16(sp)
    80004b02:	6105                	addi	sp,sp,32
    80004b04:	8082                	ret

0000000080004b06 <sys_link>:
{
    80004b06:	7169                	addi	sp,sp,-304
    80004b08:	f606                	sd	ra,296(sp)
    80004b0a:	f222                	sd	s0,288(sp)
    80004b0c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b0e:	08000613          	li	a2,128
    80004b12:	ed040593          	addi	a1,s0,-304
    80004b16:	4501                	li	a0,0
    80004b18:	ffffd097          	auipc	ra,0xffffd
    80004b1c:	6bc080e7          	jalr	1724(ra) # 800021d4 <argstr>
    return -1;
    80004b20:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b22:	12054663          	bltz	a0,80004c4e <sys_link+0x148>
    80004b26:	08000613          	li	a2,128
    80004b2a:	f5040593          	addi	a1,s0,-176
    80004b2e:	4505                	li	a0,1
    80004b30:	ffffd097          	auipc	ra,0xffffd
    80004b34:	6a4080e7          	jalr	1700(ra) # 800021d4 <argstr>
    return -1;
    80004b38:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b3a:	10054a63          	bltz	a0,80004c4e <sys_link+0x148>
    80004b3e:	ee26                	sd	s1,280(sp)
  begin_op();
    80004b40:	fffff097          	auipc	ra,0xfffff
    80004b44:	c6c080e7          	jalr	-916(ra) # 800037ac <begin_op>
  if((ip = namei(old)) == 0){
    80004b48:	ed040513          	addi	a0,s0,-304
    80004b4c:	fffff097          	auipc	ra,0xfffff
    80004b50:	a60080e7          	jalr	-1440(ra) # 800035ac <namei>
    80004b54:	84aa                	mv	s1,a0
    80004b56:	c949                	beqz	a0,80004be8 <sys_link+0xe2>
  ilock(ip);
    80004b58:	ffffe097          	auipc	ra,0xffffe
    80004b5c:	286080e7          	jalr	646(ra) # 80002dde <ilock>
  if(ip->type == T_DIR){
    80004b60:	04449703          	lh	a4,68(s1)
    80004b64:	4785                	li	a5,1
    80004b66:	08f70863          	beq	a4,a5,80004bf6 <sys_link+0xf0>
    80004b6a:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004b6c:	04a4d783          	lhu	a5,74(s1)
    80004b70:	2785                	addiw	a5,a5,1
    80004b72:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b76:	8526                	mv	a0,s1
    80004b78:	ffffe097          	auipc	ra,0xffffe
    80004b7c:	19a080e7          	jalr	410(ra) # 80002d12 <iupdate>
  iunlock(ip);
    80004b80:	8526                	mv	a0,s1
    80004b82:	ffffe097          	auipc	ra,0xffffe
    80004b86:	322080e7          	jalr	802(ra) # 80002ea4 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004b8a:	fd040593          	addi	a1,s0,-48
    80004b8e:	f5040513          	addi	a0,s0,-176
    80004b92:	fffff097          	auipc	ra,0xfffff
    80004b96:	a38080e7          	jalr	-1480(ra) # 800035ca <nameiparent>
    80004b9a:	892a                	mv	s2,a0
    80004b9c:	cd35                	beqz	a0,80004c18 <sys_link+0x112>
  ilock(dp);
    80004b9e:	ffffe097          	auipc	ra,0xffffe
    80004ba2:	240080e7          	jalr	576(ra) # 80002dde <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004ba6:	00092703          	lw	a4,0(s2)
    80004baa:	409c                	lw	a5,0(s1)
    80004bac:	06f71163          	bne	a4,a5,80004c0e <sys_link+0x108>
    80004bb0:	40d0                	lw	a2,4(s1)
    80004bb2:	fd040593          	addi	a1,s0,-48
    80004bb6:	854a                	mv	a0,s2
    80004bb8:	fffff097          	auipc	ra,0xfffff
    80004bbc:	942080e7          	jalr	-1726(ra) # 800034fa <dirlink>
    80004bc0:	04054763          	bltz	a0,80004c0e <sys_link+0x108>
  iunlockput(dp);
    80004bc4:	854a                	mv	a0,s2
    80004bc6:	ffffe097          	auipc	ra,0xffffe
    80004bca:	47e080e7          	jalr	1150(ra) # 80003044 <iunlockput>
  iput(ip);
    80004bce:	8526                	mv	a0,s1
    80004bd0:	ffffe097          	auipc	ra,0xffffe
    80004bd4:	3cc080e7          	jalr	972(ra) # 80002f9c <iput>
  end_op();
    80004bd8:	fffff097          	auipc	ra,0xfffff
    80004bdc:	c4e080e7          	jalr	-946(ra) # 80003826 <end_op>
  return 0;
    80004be0:	4781                	li	a5,0
    80004be2:	64f2                	ld	s1,280(sp)
    80004be4:	6952                	ld	s2,272(sp)
    80004be6:	a0a5                	j	80004c4e <sys_link+0x148>
    end_op();
    80004be8:	fffff097          	auipc	ra,0xfffff
    80004bec:	c3e080e7          	jalr	-962(ra) # 80003826 <end_op>
    return -1;
    80004bf0:	57fd                	li	a5,-1
    80004bf2:	64f2                	ld	s1,280(sp)
    80004bf4:	a8a9                	j	80004c4e <sys_link+0x148>
    iunlockput(ip);
    80004bf6:	8526                	mv	a0,s1
    80004bf8:	ffffe097          	auipc	ra,0xffffe
    80004bfc:	44c080e7          	jalr	1100(ra) # 80003044 <iunlockput>
    end_op();
    80004c00:	fffff097          	auipc	ra,0xfffff
    80004c04:	c26080e7          	jalr	-986(ra) # 80003826 <end_op>
    return -1;
    80004c08:	57fd                	li	a5,-1
    80004c0a:	64f2                	ld	s1,280(sp)
    80004c0c:	a089                	j	80004c4e <sys_link+0x148>
    iunlockput(dp);
    80004c0e:	854a                	mv	a0,s2
    80004c10:	ffffe097          	auipc	ra,0xffffe
    80004c14:	434080e7          	jalr	1076(ra) # 80003044 <iunlockput>
  ilock(ip);
    80004c18:	8526                	mv	a0,s1
    80004c1a:	ffffe097          	auipc	ra,0xffffe
    80004c1e:	1c4080e7          	jalr	452(ra) # 80002dde <ilock>
  ip->nlink--;
    80004c22:	04a4d783          	lhu	a5,74(s1)
    80004c26:	37fd                	addiw	a5,a5,-1
    80004c28:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004c2c:	8526                	mv	a0,s1
    80004c2e:	ffffe097          	auipc	ra,0xffffe
    80004c32:	0e4080e7          	jalr	228(ra) # 80002d12 <iupdate>
  iunlockput(ip);
    80004c36:	8526                	mv	a0,s1
    80004c38:	ffffe097          	auipc	ra,0xffffe
    80004c3c:	40c080e7          	jalr	1036(ra) # 80003044 <iunlockput>
  end_op();
    80004c40:	fffff097          	auipc	ra,0xfffff
    80004c44:	be6080e7          	jalr	-1050(ra) # 80003826 <end_op>
  return -1;
    80004c48:	57fd                	li	a5,-1
    80004c4a:	64f2                	ld	s1,280(sp)
    80004c4c:	6952                	ld	s2,272(sp)
}
    80004c4e:	853e                	mv	a0,a5
    80004c50:	70b2                	ld	ra,296(sp)
    80004c52:	7412                	ld	s0,288(sp)
    80004c54:	6155                	addi	sp,sp,304
    80004c56:	8082                	ret

0000000080004c58 <sys_unlink>:
{
    80004c58:	7151                	addi	sp,sp,-240
    80004c5a:	f586                	sd	ra,232(sp)
    80004c5c:	f1a2                	sd	s0,224(sp)
    80004c5e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004c60:	08000613          	li	a2,128
    80004c64:	f3040593          	addi	a1,s0,-208
    80004c68:	4501                	li	a0,0
    80004c6a:	ffffd097          	auipc	ra,0xffffd
    80004c6e:	56a080e7          	jalr	1386(ra) # 800021d4 <argstr>
    80004c72:	1a054a63          	bltz	a0,80004e26 <sys_unlink+0x1ce>
    80004c76:	eda6                	sd	s1,216(sp)
  begin_op();
    80004c78:	fffff097          	auipc	ra,0xfffff
    80004c7c:	b34080e7          	jalr	-1228(ra) # 800037ac <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004c80:	fb040593          	addi	a1,s0,-80
    80004c84:	f3040513          	addi	a0,s0,-208
    80004c88:	fffff097          	auipc	ra,0xfffff
    80004c8c:	942080e7          	jalr	-1726(ra) # 800035ca <nameiparent>
    80004c90:	84aa                	mv	s1,a0
    80004c92:	cd71                	beqz	a0,80004d6e <sys_unlink+0x116>
  ilock(dp);
    80004c94:	ffffe097          	auipc	ra,0xffffe
    80004c98:	14a080e7          	jalr	330(ra) # 80002dde <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004c9c:	00004597          	auipc	a1,0x4
    80004ca0:	94c58593          	addi	a1,a1,-1716 # 800085e8 <etext+0x5e8>
    80004ca4:	fb040513          	addi	a0,s0,-80
    80004ca8:	ffffe097          	auipc	ra,0xffffe
    80004cac:	628080e7          	jalr	1576(ra) # 800032d0 <namecmp>
    80004cb0:	14050c63          	beqz	a0,80004e08 <sys_unlink+0x1b0>
    80004cb4:	00004597          	auipc	a1,0x4
    80004cb8:	93c58593          	addi	a1,a1,-1732 # 800085f0 <etext+0x5f0>
    80004cbc:	fb040513          	addi	a0,s0,-80
    80004cc0:	ffffe097          	auipc	ra,0xffffe
    80004cc4:	610080e7          	jalr	1552(ra) # 800032d0 <namecmp>
    80004cc8:	14050063          	beqz	a0,80004e08 <sys_unlink+0x1b0>
    80004ccc:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004cce:	f2c40613          	addi	a2,s0,-212
    80004cd2:	fb040593          	addi	a1,s0,-80
    80004cd6:	8526                	mv	a0,s1
    80004cd8:	ffffe097          	auipc	ra,0xffffe
    80004cdc:	612080e7          	jalr	1554(ra) # 800032ea <dirlookup>
    80004ce0:	892a                	mv	s2,a0
    80004ce2:	12050263          	beqz	a0,80004e06 <sys_unlink+0x1ae>
  ilock(ip);
    80004ce6:	ffffe097          	auipc	ra,0xffffe
    80004cea:	0f8080e7          	jalr	248(ra) # 80002dde <ilock>
  if(ip->nlink < 1)
    80004cee:	04a91783          	lh	a5,74(s2)
    80004cf2:	08f05563          	blez	a5,80004d7c <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004cf6:	04491703          	lh	a4,68(s2)
    80004cfa:	4785                	li	a5,1
    80004cfc:	08f70963          	beq	a4,a5,80004d8e <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004d00:	4641                	li	a2,16
    80004d02:	4581                	li	a1,0
    80004d04:	fc040513          	addi	a0,s0,-64
    80004d08:	ffffb097          	auipc	ra,0xffffb
    80004d0c:	472080e7          	jalr	1138(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d10:	4741                	li	a4,16
    80004d12:	f2c42683          	lw	a3,-212(s0)
    80004d16:	fc040613          	addi	a2,s0,-64
    80004d1a:	4581                	li	a1,0
    80004d1c:	8526                	mv	a0,s1
    80004d1e:	ffffe097          	auipc	ra,0xffffe
    80004d22:	488080e7          	jalr	1160(ra) # 800031a6 <writei>
    80004d26:	47c1                	li	a5,16
    80004d28:	0af51b63          	bne	a0,a5,80004dde <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004d2c:	04491703          	lh	a4,68(s2)
    80004d30:	4785                	li	a5,1
    80004d32:	0af70f63          	beq	a4,a5,80004df0 <sys_unlink+0x198>
  iunlockput(dp);
    80004d36:	8526                	mv	a0,s1
    80004d38:	ffffe097          	auipc	ra,0xffffe
    80004d3c:	30c080e7          	jalr	780(ra) # 80003044 <iunlockput>
  ip->nlink--;
    80004d40:	04a95783          	lhu	a5,74(s2)
    80004d44:	37fd                	addiw	a5,a5,-1
    80004d46:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004d4a:	854a                	mv	a0,s2
    80004d4c:	ffffe097          	auipc	ra,0xffffe
    80004d50:	fc6080e7          	jalr	-58(ra) # 80002d12 <iupdate>
  iunlockput(ip);
    80004d54:	854a                	mv	a0,s2
    80004d56:	ffffe097          	auipc	ra,0xffffe
    80004d5a:	2ee080e7          	jalr	750(ra) # 80003044 <iunlockput>
  end_op();
    80004d5e:	fffff097          	auipc	ra,0xfffff
    80004d62:	ac8080e7          	jalr	-1336(ra) # 80003826 <end_op>
  return 0;
    80004d66:	4501                	li	a0,0
    80004d68:	64ee                	ld	s1,216(sp)
    80004d6a:	694e                	ld	s2,208(sp)
    80004d6c:	a84d                	j	80004e1e <sys_unlink+0x1c6>
    end_op();
    80004d6e:	fffff097          	auipc	ra,0xfffff
    80004d72:	ab8080e7          	jalr	-1352(ra) # 80003826 <end_op>
    return -1;
    80004d76:	557d                	li	a0,-1
    80004d78:	64ee                	ld	s1,216(sp)
    80004d7a:	a055                	j	80004e1e <sys_unlink+0x1c6>
    80004d7c:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004d7e:	00004517          	auipc	a0,0x4
    80004d82:	87a50513          	addi	a0,a0,-1926 # 800085f8 <etext+0x5f8>
    80004d86:	00001097          	auipc	ra,0x1
    80004d8a:	23c080e7          	jalr	572(ra) # 80005fc2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d8e:	04c92703          	lw	a4,76(s2)
    80004d92:	02000793          	li	a5,32
    80004d96:	f6e7f5e3          	bgeu	a5,a4,80004d00 <sys_unlink+0xa8>
    80004d9a:	e5ce                	sd	s3,200(sp)
    80004d9c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004da0:	4741                	li	a4,16
    80004da2:	86ce                	mv	a3,s3
    80004da4:	f1840613          	addi	a2,s0,-232
    80004da8:	4581                	li	a1,0
    80004daa:	854a                	mv	a0,s2
    80004dac:	ffffe097          	auipc	ra,0xffffe
    80004db0:	2ea080e7          	jalr	746(ra) # 80003096 <readi>
    80004db4:	47c1                	li	a5,16
    80004db6:	00f51c63          	bne	a0,a5,80004dce <sys_unlink+0x176>
    if(de.inum != 0)
    80004dba:	f1845783          	lhu	a5,-232(s0)
    80004dbe:	e7b5                	bnez	a5,80004e2a <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004dc0:	29c1                	addiw	s3,s3,16
    80004dc2:	04c92783          	lw	a5,76(s2)
    80004dc6:	fcf9ede3          	bltu	s3,a5,80004da0 <sys_unlink+0x148>
    80004dca:	69ae                	ld	s3,200(sp)
    80004dcc:	bf15                	j	80004d00 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004dce:	00004517          	auipc	a0,0x4
    80004dd2:	84250513          	addi	a0,a0,-1982 # 80008610 <etext+0x610>
    80004dd6:	00001097          	auipc	ra,0x1
    80004dda:	1ec080e7          	jalr	492(ra) # 80005fc2 <panic>
    80004dde:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004de0:	00004517          	auipc	a0,0x4
    80004de4:	84850513          	addi	a0,a0,-1976 # 80008628 <etext+0x628>
    80004de8:	00001097          	auipc	ra,0x1
    80004dec:	1da080e7          	jalr	474(ra) # 80005fc2 <panic>
    dp->nlink--;
    80004df0:	04a4d783          	lhu	a5,74(s1)
    80004df4:	37fd                	addiw	a5,a5,-1
    80004df6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004dfa:	8526                	mv	a0,s1
    80004dfc:	ffffe097          	auipc	ra,0xffffe
    80004e00:	f16080e7          	jalr	-234(ra) # 80002d12 <iupdate>
    80004e04:	bf0d                	j	80004d36 <sys_unlink+0xde>
    80004e06:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004e08:	8526                	mv	a0,s1
    80004e0a:	ffffe097          	auipc	ra,0xffffe
    80004e0e:	23a080e7          	jalr	570(ra) # 80003044 <iunlockput>
  end_op();
    80004e12:	fffff097          	auipc	ra,0xfffff
    80004e16:	a14080e7          	jalr	-1516(ra) # 80003826 <end_op>
  return -1;
    80004e1a:	557d                	li	a0,-1
    80004e1c:	64ee                	ld	s1,216(sp)
}
    80004e1e:	70ae                	ld	ra,232(sp)
    80004e20:	740e                	ld	s0,224(sp)
    80004e22:	616d                	addi	sp,sp,240
    80004e24:	8082                	ret
    return -1;
    80004e26:	557d                	li	a0,-1
    80004e28:	bfdd                	j	80004e1e <sys_unlink+0x1c6>
    iunlockput(ip);
    80004e2a:	854a                	mv	a0,s2
    80004e2c:	ffffe097          	auipc	ra,0xffffe
    80004e30:	218080e7          	jalr	536(ra) # 80003044 <iunlockput>
    goto bad;
    80004e34:	694e                	ld	s2,208(sp)
    80004e36:	69ae                	ld	s3,200(sp)
    80004e38:	bfc1                	j	80004e08 <sys_unlink+0x1b0>

0000000080004e3a <sys_open>:

uint64
sys_open(void)
{
    80004e3a:	7131                	addi	sp,sp,-192
    80004e3c:	fd06                	sd	ra,184(sp)
    80004e3e:	f922                	sd	s0,176(sp)
    80004e40:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004e42:	f4c40593          	addi	a1,s0,-180
    80004e46:	4505                	li	a0,1
    80004e48:	ffffd097          	auipc	ra,0xffffd
    80004e4c:	34c080e7          	jalr	844(ra) # 80002194 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004e50:	08000613          	li	a2,128
    80004e54:	f5040593          	addi	a1,s0,-176
    80004e58:	4501                	li	a0,0
    80004e5a:	ffffd097          	auipc	ra,0xffffd
    80004e5e:	37a080e7          	jalr	890(ra) # 800021d4 <argstr>
    80004e62:	87aa                	mv	a5,a0
    return -1;
    80004e64:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004e66:	0a07ce63          	bltz	a5,80004f22 <sys_open+0xe8>
    80004e6a:	f526                	sd	s1,168(sp)

  begin_op();
    80004e6c:	fffff097          	auipc	ra,0xfffff
    80004e70:	940080e7          	jalr	-1728(ra) # 800037ac <begin_op>

  if(omode & O_CREATE){
    80004e74:	f4c42783          	lw	a5,-180(s0)
    80004e78:	2007f793          	andi	a5,a5,512
    80004e7c:	cfd5                	beqz	a5,80004f38 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004e7e:	4681                	li	a3,0
    80004e80:	4601                	li	a2,0
    80004e82:	4589                	li	a1,2
    80004e84:	f5040513          	addi	a0,s0,-176
    80004e88:	00000097          	auipc	ra,0x0
    80004e8c:	95c080e7          	jalr	-1700(ra) # 800047e4 <create>
    80004e90:	84aa                	mv	s1,a0
    if(ip == 0){
    80004e92:	cd41                	beqz	a0,80004f2a <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004e94:	04449703          	lh	a4,68(s1)
    80004e98:	478d                	li	a5,3
    80004e9a:	00f71763          	bne	a4,a5,80004ea8 <sys_open+0x6e>
    80004e9e:	0464d703          	lhu	a4,70(s1)
    80004ea2:	47a5                	li	a5,9
    80004ea4:	0ee7e163          	bltu	a5,a4,80004f86 <sys_open+0x14c>
    80004ea8:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004eaa:	fffff097          	auipc	ra,0xfffff
    80004eae:	d10080e7          	jalr	-752(ra) # 80003bba <filealloc>
    80004eb2:	892a                	mv	s2,a0
    80004eb4:	c97d                	beqz	a0,80004faa <sys_open+0x170>
    80004eb6:	ed4e                	sd	s3,152(sp)
    80004eb8:	00000097          	auipc	ra,0x0
    80004ebc:	8ea080e7          	jalr	-1814(ra) # 800047a2 <fdalloc>
    80004ec0:	89aa                	mv	s3,a0
    80004ec2:	0c054e63          	bltz	a0,80004f9e <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ec6:	04449703          	lh	a4,68(s1)
    80004eca:	478d                	li	a5,3
    80004ecc:	0ef70c63          	beq	a4,a5,80004fc4 <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004ed0:	4789                	li	a5,2
    80004ed2:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004ed6:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004eda:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004ede:	f4c42783          	lw	a5,-180(s0)
    80004ee2:	0017c713          	xori	a4,a5,1
    80004ee6:	8b05                	andi	a4,a4,1
    80004ee8:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004eec:	0037f713          	andi	a4,a5,3
    80004ef0:	00e03733          	snez	a4,a4
    80004ef4:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004ef8:	4007f793          	andi	a5,a5,1024
    80004efc:	c791                	beqz	a5,80004f08 <sys_open+0xce>
    80004efe:	04449703          	lh	a4,68(s1)
    80004f02:	4789                	li	a5,2
    80004f04:	0cf70763          	beq	a4,a5,80004fd2 <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80004f08:	8526                	mv	a0,s1
    80004f0a:	ffffe097          	auipc	ra,0xffffe
    80004f0e:	f9a080e7          	jalr	-102(ra) # 80002ea4 <iunlock>
  end_op();
    80004f12:	fffff097          	auipc	ra,0xfffff
    80004f16:	914080e7          	jalr	-1772(ra) # 80003826 <end_op>

  return fd;
    80004f1a:	854e                	mv	a0,s3
    80004f1c:	74aa                	ld	s1,168(sp)
    80004f1e:	790a                	ld	s2,160(sp)
    80004f20:	69ea                	ld	s3,152(sp)
}
    80004f22:	70ea                	ld	ra,184(sp)
    80004f24:	744a                	ld	s0,176(sp)
    80004f26:	6129                	addi	sp,sp,192
    80004f28:	8082                	ret
      end_op();
    80004f2a:	fffff097          	auipc	ra,0xfffff
    80004f2e:	8fc080e7          	jalr	-1796(ra) # 80003826 <end_op>
      return -1;
    80004f32:	557d                	li	a0,-1
    80004f34:	74aa                	ld	s1,168(sp)
    80004f36:	b7f5                	j	80004f22 <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80004f38:	f5040513          	addi	a0,s0,-176
    80004f3c:	ffffe097          	auipc	ra,0xffffe
    80004f40:	670080e7          	jalr	1648(ra) # 800035ac <namei>
    80004f44:	84aa                	mv	s1,a0
    80004f46:	c90d                	beqz	a0,80004f78 <sys_open+0x13e>
    ilock(ip);
    80004f48:	ffffe097          	auipc	ra,0xffffe
    80004f4c:	e96080e7          	jalr	-362(ra) # 80002dde <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004f50:	04449703          	lh	a4,68(s1)
    80004f54:	4785                	li	a5,1
    80004f56:	f2f71fe3          	bne	a4,a5,80004e94 <sys_open+0x5a>
    80004f5a:	f4c42783          	lw	a5,-180(s0)
    80004f5e:	d7a9                	beqz	a5,80004ea8 <sys_open+0x6e>
      iunlockput(ip);
    80004f60:	8526                	mv	a0,s1
    80004f62:	ffffe097          	auipc	ra,0xffffe
    80004f66:	0e2080e7          	jalr	226(ra) # 80003044 <iunlockput>
      end_op();
    80004f6a:	fffff097          	auipc	ra,0xfffff
    80004f6e:	8bc080e7          	jalr	-1860(ra) # 80003826 <end_op>
      return -1;
    80004f72:	557d                	li	a0,-1
    80004f74:	74aa                	ld	s1,168(sp)
    80004f76:	b775                	j	80004f22 <sys_open+0xe8>
      end_op();
    80004f78:	fffff097          	auipc	ra,0xfffff
    80004f7c:	8ae080e7          	jalr	-1874(ra) # 80003826 <end_op>
      return -1;
    80004f80:	557d                	li	a0,-1
    80004f82:	74aa                	ld	s1,168(sp)
    80004f84:	bf79                	j	80004f22 <sys_open+0xe8>
    iunlockput(ip);
    80004f86:	8526                	mv	a0,s1
    80004f88:	ffffe097          	auipc	ra,0xffffe
    80004f8c:	0bc080e7          	jalr	188(ra) # 80003044 <iunlockput>
    end_op();
    80004f90:	fffff097          	auipc	ra,0xfffff
    80004f94:	896080e7          	jalr	-1898(ra) # 80003826 <end_op>
    return -1;
    80004f98:	557d                	li	a0,-1
    80004f9a:	74aa                	ld	s1,168(sp)
    80004f9c:	b759                	j	80004f22 <sys_open+0xe8>
      fileclose(f);
    80004f9e:	854a                	mv	a0,s2
    80004fa0:	fffff097          	auipc	ra,0xfffff
    80004fa4:	cd6080e7          	jalr	-810(ra) # 80003c76 <fileclose>
    80004fa8:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004faa:	8526                	mv	a0,s1
    80004fac:	ffffe097          	auipc	ra,0xffffe
    80004fb0:	098080e7          	jalr	152(ra) # 80003044 <iunlockput>
    end_op();
    80004fb4:	fffff097          	auipc	ra,0xfffff
    80004fb8:	872080e7          	jalr	-1934(ra) # 80003826 <end_op>
    return -1;
    80004fbc:	557d                	li	a0,-1
    80004fbe:	74aa                	ld	s1,168(sp)
    80004fc0:	790a                	ld	s2,160(sp)
    80004fc2:	b785                	j	80004f22 <sys_open+0xe8>
    f->type = FD_DEVICE;
    80004fc4:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004fc8:	04649783          	lh	a5,70(s1)
    80004fcc:	02f91223          	sh	a5,36(s2)
    80004fd0:	b729                	j	80004eda <sys_open+0xa0>
    itrunc(ip);
    80004fd2:	8526                	mv	a0,s1
    80004fd4:	ffffe097          	auipc	ra,0xffffe
    80004fd8:	f1c080e7          	jalr	-228(ra) # 80002ef0 <itrunc>
    80004fdc:	b735                	j	80004f08 <sys_open+0xce>

0000000080004fde <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004fde:	7175                	addi	sp,sp,-144
    80004fe0:	e506                	sd	ra,136(sp)
    80004fe2:	e122                	sd	s0,128(sp)
    80004fe4:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004fe6:	ffffe097          	auipc	ra,0xffffe
    80004fea:	7c6080e7          	jalr	1990(ra) # 800037ac <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004fee:	08000613          	li	a2,128
    80004ff2:	f7040593          	addi	a1,s0,-144
    80004ff6:	4501                	li	a0,0
    80004ff8:	ffffd097          	auipc	ra,0xffffd
    80004ffc:	1dc080e7          	jalr	476(ra) # 800021d4 <argstr>
    80005000:	02054963          	bltz	a0,80005032 <sys_mkdir+0x54>
    80005004:	4681                	li	a3,0
    80005006:	4601                	li	a2,0
    80005008:	4585                	li	a1,1
    8000500a:	f7040513          	addi	a0,s0,-144
    8000500e:	fffff097          	auipc	ra,0xfffff
    80005012:	7d6080e7          	jalr	2006(ra) # 800047e4 <create>
    80005016:	cd11                	beqz	a0,80005032 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005018:	ffffe097          	auipc	ra,0xffffe
    8000501c:	02c080e7          	jalr	44(ra) # 80003044 <iunlockput>
  end_op();
    80005020:	fffff097          	auipc	ra,0xfffff
    80005024:	806080e7          	jalr	-2042(ra) # 80003826 <end_op>
  return 0;
    80005028:	4501                	li	a0,0
}
    8000502a:	60aa                	ld	ra,136(sp)
    8000502c:	640a                	ld	s0,128(sp)
    8000502e:	6149                	addi	sp,sp,144
    80005030:	8082                	ret
    end_op();
    80005032:	ffffe097          	auipc	ra,0xffffe
    80005036:	7f4080e7          	jalr	2036(ra) # 80003826 <end_op>
    return -1;
    8000503a:	557d                	li	a0,-1
    8000503c:	b7fd                	j	8000502a <sys_mkdir+0x4c>

000000008000503e <sys_mknod>:

uint64
sys_mknod(void)
{
    8000503e:	7135                	addi	sp,sp,-160
    80005040:	ed06                	sd	ra,152(sp)
    80005042:	e922                	sd	s0,144(sp)
    80005044:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005046:	ffffe097          	auipc	ra,0xffffe
    8000504a:	766080e7          	jalr	1894(ra) # 800037ac <begin_op>
  argint(1, &major);
    8000504e:	f6c40593          	addi	a1,s0,-148
    80005052:	4505                	li	a0,1
    80005054:	ffffd097          	auipc	ra,0xffffd
    80005058:	140080e7          	jalr	320(ra) # 80002194 <argint>
  argint(2, &minor);
    8000505c:	f6840593          	addi	a1,s0,-152
    80005060:	4509                	li	a0,2
    80005062:	ffffd097          	auipc	ra,0xffffd
    80005066:	132080e7          	jalr	306(ra) # 80002194 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000506a:	08000613          	li	a2,128
    8000506e:	f7040593          	addi	a1,s0,-144
    80005072:	4501                	li	a0,0
    80005074:	ffffd097          	auipc	ra,0xffffd
    80005078:	160080e7          	jalr	352(ra) # 800021d4 <argstr>
    8000507c:	02054b63          	bltz	a0,800050b2 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005080:	f6841683          	lh	a3,-152(s0)
    80005084:	f6c41603          	lh	a2,-148(s0)
    80005088:	458d                	li	a1,3
    8000508a:	f7040513          	addi	a0,s0,-144
    8000508e:	fffff097          	auipc	ra,0xfffff
    80005092:	756080e7          	jalr	1878(ra) # 800047e4 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005096:	cd11                	beqz	a0,800050b2 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005098:	ffffe097          	auipc	ra,0xffffe
    8000509c:	fac080e7          	jalr	-84(ra) # 80003044 <iunlockput>
  end_op();
    800050a0:	ffffe097          	auipc	ra,0xffffe
    800050a4:	786080e7          	jalr	1926(ra) # 80003826 <end_op>
  return 0;
    800050a8:	4501                	li	a0,0
}
    800050aa:	60ea                	ld	ra,152(sp)
    800050ac:	644a                	ld	s0,144(sp)
    800050ae:	610d                	addi	sp,sp,160
    800050b0:	8082                	ret
    end_op();
    800050b2:	ffffe097          	auipc	ra,0xffffe
    800050b6:	774080e7          	jalr	1908(ra) # 80003826 <end_op>
    return -1;
    800050ba:	557d                	li	a0,-1
    800050bc:	b7fd                	j	800050aa <sys_mknod+0x6c>

00000000800050be <sys_chdir>:

uint64
sys_chdir(void)
{
    800050be:	7135                	addi	sp,sp,-160
    800050c0:	ed06                	sd	ra,152(sp)
    800050c2:	e922                	sd	s0,144(sp)
    800050c4:	e14a                	sd	s2,128(sp)
    800050c6:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800050c8:	ffffc097          	auipc	ra,0xffffc
    800050cc:	f22080e7          	jalr	-222(ra) # 80000fea <myproc>
    800050d0:	892a                	mv	s2,a0
  
  begin_op();
    800050d2:	ffffe097          	auipc	ra,0xffffe
    800050d6:	6da080e7          	jalr	1754(ra) # 800037ac <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800050da:	08000613          	li	a2,128
    800050de:	f6040593          	addi	a1,s0,-160
    800050e2:	4501                	li	a0,0
    800050e4:	ffffd097          	auipc	ra,0xffffd
    800050e8:	0f0080e7          	jalr	240(ra) # 800021d4 <argstr>
    800050ec:	04054d63          	bltz	a0,80005146 <sys_chdir+0x88>
    800050f0:	e526                	sd	s1,136(sp)
    800050f2:	f6040513          	addi	a0,s0,-160
    800050f6:	ffffe097          	auipc	ra,0xffffe
    800050fa:	4b6080e7          	jalr	1206(ra) # 800035ac <namei>
    800050fe:	84aa                	mv	s1,a0
    80005100:	c131                	beqz	a0,80005144 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005102:	ffffe097          	auipc	ra,0xffffe
    80005106:	cdc080e7          	jalr	-804(ra) # 80002dde <ilock>
  if(ip->type != T_DIR){
    8000510a:	04449703          	lh	a4,68(s1)
    8000510e:	4785                	li	a5,1
    80005110:	04f71163          	bne	a4,a5,80005152 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005114:	8526                	mv	a0,s1
    80005116:	ffffe097          	auipc	ra,0xffffe
    8000511a:	d8e080e7          	jalr	-626(ra) # 80002ea4 <iunlock>
  iput(p->cwd);
    8000511e:	15093503          	ld	a0,336(s2)
    80005122:	ffffe097          	auipc	ra,0xffffe
    80005126:	e7a080e7          	jalr	-390(ra) # 80002f9c <iput>
  end_op();
    8000512a:	ffffe097          	auipc	ra,0xffffe
    8000512e:	6fc080e7          	jalr	1788(ra) # 80003826 <end_op>
  p->cwd = ip;
    80005132:	14993823          	sd	s1,336(s2)
  return 0;
    80005136:	4501                	li	a0,0
    80005138:	64aa                	ld	s1,136(sp)
}
    8000513a:	60ea                	ld	ra,152(sp)
    8000513c:	644a                	ld	s0,144(sp)
    8000513e:	690a                	ld	s2,128(sp)
    80005140:	610d                	addi	sp,sp,160
    80005142:	8082                	ret
    80005144:	64aa                	ld	s1,136(sp)
    end_op();
    80005146:	ffffe097          	auipc	ra,0xffffe
    8000514a:	6e0080e7          	jalr	1760(ra) # 80003826 <end_op>
    return -1;
    8000514e:	557d                	li	a0,-1
    80005150:	b7ed                	j	8000513a <sys_chdir+0x7c>
    iunlockput(ip);
    80005152:	8526                	mv	a0,s1
    80005154:	ffffe097          	auipc	ra,0xffffe
    80005158:	ef0080e7          	jalr	-272(ra) # 80003044 <iunlockput>
    end_op();
    8000515c:	ffffe097          	auipc	ra,0xffffe
    80005160:	6ca080e7          	jalr	1738(ra) # 80003826 <end_op>
    return -1;
    80005164:	557d                	li	a0,-1
    80005166:	64aa                	ld	s1,136(sp)
    80005168:	bfc9                	j	8000513a <sys_chdir+0x7c>

000000008000516a <sys_exec>:

uint64
sys_exec(void)
{
    8000516a:	7121                	addi	sp,sp,-448
    8000516c:	ff06                	sd	ra,440(sp)
    8000516e:	fb22                	sd	s0,432(sp)
    80005170:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005172:	e4840593          	addi	a1,s0,-440
    80005176:	4505                	li	a0,1
    80005178:	ffffd097          	auipc	ra,0xffffd
    8000517c:	03c080e7          	jalr	60(ra) # 800021b4 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005180:	08000613          	li	a2,128
    80005184:	f5040593          	addi	a1,s0,-176
    80005188:	4501                	li	a0,0
    8000518a:	ffffd097          	auipc	ra,0xffffd
    8000518e:	04a080e7          	jalr	74(ra) # 800021d4 <argstr>
    80005192:	87aa                	mv	a5,a0
    return -1;
    80005194:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005196:	0e07c263          	bltz	a5,8000527a <sys_exec+0x110>
    8000519a:	f726                	sd	s1,424(sp)
    8000519c:	f34a                	sd	s2,416(sp)
    8000519e:	ef4e                	sd	s3,408(sp)
    800051a0:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800051a2:	10000613          	li	a2,256
    800051a6:	4581                	li	a1,0
    800051a8:	e5040513          	addi	a0,s0,-432
    800051ac:	ffffb097          	auipc	ra,0xffffb
    800051b0:	fce080e7          	jalr	-50(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800051b4:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800051b8:	89a6                	mv	s3,s1
    800051ba:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800051bc:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800051c0:	00391513          	slli	a0,s2,0x3
    800051c4:	e4040593          	addi	a1,s0,-448
    800051c8:	e4843783          	ld	a5,-440(s0)
    800051cc:	953e                	add	a0,a0,a5
    800051ce:	ffffd097          	auipc	ra,0xffffd
    800051d2:	f28080e7          	jalr	-216(ra) # 800020f6 <fetchaddr>
    800051d6:	02054a63          	bltz	a0,8000520a <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    800051da:	e4043783          	ld	a5,-448(s0)
    800051de:	c7b9                	beqz	a5,8000522c <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800051e0:	ffffb097          	auipc	ra,0xffffb
    800051e4:	f3a080e7          	jalr	-198(ra) # 8000011a <kalloc>
    800051e8:	85aa                	mv	a1,a0
    800051ea:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800051ee:	cd11                	beqz	a0,8000520a <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800051f0:	6605                	lui	a2,0x1
    800051f2:	e4043503          	ld	a0,-448(s0)
    800051f6:	ffffd097          	auipc	ra,0xffffd
    800051fa:	f52080e7          	jalr	-174(ra) # 80002148 <fetchstr>
    800051fe:	00054663          	bltz	a0,8000520a <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80005202:	0905                	addi	s2,s2,1
    80005204:	09a1                	addi	s3,s3,8
    80005206:	fb491de3          	bne	s2,s4,800051c0 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000520a:	f5040913          	addi	s2,s0,-176
    8000520e:	6088                	ld	a0,0(s1)
    80005210:	c125                	beqz	a0,80005270 <sys_exec+0x106>
    kfree(argv[i]);
    80005212:	ffffb097          	auipc	ra,0xffffb
    80005216:	e0a080e7          	jalr	-502(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000521a:	04a1                	addi	s1,s1,8
    8000521c:	ff2499e3          	bne	s1,s2,8000520e <sys_exec+0xa4>
  return -1;
    80005220:	557d                	li	a0,-1
    80005222:	74ba                	ld	s1,424(sp)
    80005224:	791a                	ld	s2,416(sp)
    80005226:	69fa                	ld	s3,408(sp)
    80005228:	6a5a                	ld	s4,400(sp)
    8000522a:	a881                	j	8000527a <sys_exec+0x110>
      argv[i] = 0;
    8000522c:	0009079b          	sext.w	a5,s2
    80005230:	078e                	slli	a5,a5,0x3
    80005232:	fd078793          	addi	a5,a5,-48
    80005236:	97a2                	add	a5,a5,s0
    80005238:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000523c:	e5040593          	addi	a1,s0,-432
    80005240:	f5040513          	addi	a0,s0,-176
    80005244:	fffff097          	auipc	ra,0xfffff
    80005248:	108080e7          	jalr	264(ra) # 8000434c <exec>
    8000524c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000524e:	f5040993          	addi	s3,s0,-176
    80005252:	6088                	ld	a0,0(s1)
    80005254:	c901                	beqz	a0,80005264 <sys_exec+0xfa>
    kfree(argv[i]);
    80005256:	ffffb097          	auipc	ra,0xffffb
    8000525a:	dc6080e7          	jalr	-570(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000525e:	04a1                	addi	s1,s1,8
    80005260:	ff3499e3          	bne	s1,s3,80005252 <sys_exec+0xe8>
  return ret;
    80005264:	854a                	mv	a0,s2
    80005266:	74ba                	ld	s1,424(sp)
    80005268:	791a                	ld	s2,416(sp)
    8000526a:	69fa                	ld	s3,408(sp)
    8000526c:	6a5a                	ld	s4,400(sp)
    8000526e:	a031                	j	8000527a <sys_exec+0x110>
  return -1;
    80005270:	557d                	li	a0,-1
    80005272:	74ba                	ld	s1,424(sp)
    80005274:	791a                	ld	s2,416(sp)
    80005276:	69fa                	ld	s3,408(sp)
    80005278:	6a5a                	ld	s4,400(sp)
}
    8000527a:	70fa                	ld	ra,440(sp)
    8000527c:	745a                	ld	s0,432(sp)
    8000527e:	6139                	addi	sp,sp,448
    80005280:	8082                	ret

0000000080005282 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005282:	7139                	addi	sp,sp,-64
    80005284:	fc06                	sd	ra,56(sp)
    80005286:	f822                	sd	s0,48(sp)
    80005288:	f426                	sd	s1,40(sp)
    8000528a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000528c:	ffffc097          	auipc	ra,0xffffc
    80005290:	d5e080e7          	jalr	-674(ra) # 80000fea <myproc>
    80005294:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005296:	fd840593          	addi	a1,s0,-40
    8000529a:	4501                	li	a0,0
    8000529c:	ffffd097          	auipc	ra,0xffffd
    800052a0:	f18080e7          	jalr	-232(ra) # 800021b4 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800052a4:	fc840593          	addi	a1,s0,-56
    800052a8:	fd040513          	addi	a0,s0,-48
    800052ac:	fffff097          	auipc	ra,0xfffff
    800052b0:	d38080e7          	jalr	-712(ra) # 80003fe4 <pipealloc>
    return -1;
    800052b4:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800052b6:	0c054463          	bltz	a0,8000537e <sys_pipe+0xfc>
  fd0 = -1;
    800052ba:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800052be:	fd043503          	ld	a0,-48(s0)
    800052c2:	fffff097          	auipc	ra,0xfffff
    800052c6:	4e0080e7          	jalr	1248(ra) # 800047a2 <fdalloc>
    800052ca:	fca42223          	sw	a0,-60(s0)
    800052ce:	08054b63          	bltz	a0,80005364 <sys_pipe+0xe2>
    800052d2:	fc843503          	ld	a0,-56(s0)
    800052d6:	fffff097          	auipc	ra,0xfffff
    800052da:	4cc080e7          	jalr	1228(ra) # 800047a2 <fdalloc>
    800052de:	fca42023          	sw	a0,-64(s0)
    800052e2:	06054863          	bltz	a0,80005352 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800052e6:	4691                	li	a3,4
    800052e8:	fc440613          	addi	a2,s0,-60
    800052ec:	fd843583          	ld	a1,-40(s0)
    800052f0:	68a8                	ld	a0,80(s1)
    800052f2:	ffffc097          	auipc	ra,0xffffc
    800052f6:	85a080e7          	jalr	-1958(ra) # 80000b4c <copyout>
    800052fa:	02054063          	bltz	a0,8000531a <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800052fe:	4691                	li	a3,4
    80005300:	fc040613          	addi	a2,s0,-64
    80005304:	fd843583          	ld	a1,-40(s0)
    80005308:	0591                	addi	a1,a1,4
    8000530a:	68a8                	ld	a0,80(s1)
    8000530c:	ffffc097          	auipc	ra,0xffffc
    80005310:	840080e7          	jalr	-1984(ra) # 80000b4c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005314:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005316:	06055463          	bgez	a0,8000537e <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    8000531a:	fc442783          	lw	a5,-60(s0)
    8000531e:	07e9                	addi	a5,a5,26
    80005320:	078e                	slli	a5,a5,0x3
    80005322:	97a6                	add	a5,a5,s1
    80005324:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005328:	fc042783          	lw	a5,-64(s0)
    8000532c:	07e9                	addi	a5,a5,26
    8000532e:	078e                	slli	a5,a5,0x3
    80005330:	94be                	add	s1,s1,a5
    80005332:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005336:	fd043503          	ld	a0,-48(s0)
    8000533a:	fffff097          	auipc	ra,0xfffff
    8000533e:	93c080e7          	jalr	-1732(ra) # 80003c76 <fileclose>
    fileclose(wf);
    80005342:	fc843503          	ld	a0,-56(s0)
    80005346:	fffff097          	auipc	ra,0xfffff
    8000534a:	930080e7          	jalr	-1744(ra) # 80003c76 <fileclose>
    return -1;
    8000534e:	57fd                	li	a5,-1
    80005350:	a03d                	j	8000537e <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005352:	fc442783          	lw	a5,-60(s0)
    80005356:	0007c763          	bltz	a5,80005364 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    8000535a:	07e9                	addi	a5,a5,26
    8000535c:	078e                	slli	a5,a5,0x3
    8000535e:	97a6                	add	a5,a5,s1
    80005360:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005364:	fd043503          	ld	a0,-48(s0)
    80005368:	fffff097          	auipc	ra,0xfffff
    8000536c:	90e080e7          	jalr	-1778(ra) # 80003c76 <fileclose>
    fileclose(wf);
    80005370:	fc843503          	ld	a0,-56(s0)
    80005374:	fffff097          	auipc	ra,0xfffff
    80005378:	902080e7          	jalr	-1790(ra) # 80003c76 <fileclose>
    return -1;
    8000537c:	57fd                	li	a5,-1
}
    8000537e:	853e                	mv	a0,a5
    80005380:	70e2                	ld	ra,56(sp)
    80005382:	7442                	ld	s0,48(sp)
    80005384:	74a2                	ld	s1,40(sp)
    80005386:	6121                	addi	sp,sp,64
    80005388:	8082                	ret
    8000538a:	0000                	unimp
    8000538c:	0000                	unimp
	...

0000000080005390 <kernelvec>:
    80005390:	7111                	addi	sp,sp,-256
    80005392:	e006                	sd	ra,0(sp)
    80005394:	e40a                	sd	sp,8(sp)
    80005396:	e80e                	sd	gp,16(sp)
    80005398:	ec12                	sd	tp,24(sp)
    8000539a:	f016                	sd	t0,32(sp)
    8000539c:	f41a                	sd	t1,40(sp)
    8000539e:	f81e                	sd	t2,48(sp)
    800053a0:	fc22                	sd	s0,56(sp)
    800053a2:	e0a6                	sd	s1,64(sp)
    800053a4:	e4aa                	sd	a0,72(sp)
    800053a6:	e8ae                	sd	a1,80(sp)
    800053a8:	ecb2                	sd	a2,88(sp)
    800053aa:	f0b6                	sd	a3,96(sp)
    800053ac:	f4ba                	sd	a4,104(sp)
    800053ae:	f8be                	sd	a5,112(sp)
    800053b0:	fcc2                	sd	a6,120(sp)
    800053b2:	e146                	sd	a7,128(sp)
    800053b4:	e54a                	sd	s2,136(sp)
    800053b6:	e94e                	sd	s3,144(sp)
    800053b8:	ed52                	sd	s4,152(sp)
    800053ba:	f156                	sd	s5,160(sp)
    800053bc:	f55a                	sd	s6,168(sp)
    800053be:	f95e                	sd	s7,176(sp)
    800053c0:	fd62                	sd	s8,184(sp)
    800053c2:	e1e6                	sd	s9,192(sp)
    800053c4:	e5ea                	sd	s10,200(sp)
    800053c6:	e9ee                	sd	s11,208(sp)
    800053c8:	edf2                	sd	t3,216(sp)
    800053ca:	f1f6                	sd	t4,224(sp)
    800053cc:	f5fa                	sd	t5,232(sp)
    800053ce:	f9fe                	sd	t6,240(sp)
    800053d0:	bf3fc0ef          	jal	80001fc2 <kerneltrap>
    800053d4:	6082                	ld	ra,0(sp)
    800053d6:	6122                	ld	sp,8(sp)
    800053d8:	61c2                	ld	gp,16(sp)
    800053da:	7282                	ld	t0,32(sp)
    800053dc:	7322                	ld	t1,40(sp)
    800053de:	73c2                	ld	t2,48(sp)
    800053e0:	7462                	ld	s0,56(sp)
    800053e2:	6486                	ld	s1,64(sp)
    800053e4:	6526                	ld	a0,72(sp)
    800053e6:	65c6                	ld	a1,80(sp)
    800053e8:	6666                	ld	a2,88(sp)
    800053ea:	7686                	ld	a3,96(sp)
    800053ec:	7726                	ld	a4,104(sp)
    800053ee:	77c6                	ld	a5,112(sp)
    800053f0:	7866                	ld	a6,120(sp)
    800053f2:	688a                	ld	a7,128(sp)
    800053f4:	692a                	ld	s2,136(sp)
    800053f6:	69ca                	ld	s3,144(sp)
    800053f8:	6a6a                	ld	s4,152(sp)
    800053fa:	7a8a                	ld	s5,160(sp)
    800053fc:	7b2a                	ld	s6,168(sp)
    800053fe:	7bca                	ld	s7,176(sp)
    80005400:	7c6a                	ld	s8,184(sp)
    80005402:	6c8e                	ld	s9,192(sp)
    80005404:	6d2e                	ld	s10,200(sp)
    80005406:	6dce                	ld	s11,208(sp)
    80005408:	6e6e                	ld	t3,216(sp)
    8000540a:	7e8e                	ld	t4,224(sp)
    8000540c:	7f2e                	ld	t5,232(sp)
    8000540e:	7fce                	ld	t6,240(sp)
    80005410:	6111                	addi	sp,sp,256
    80005412:	10200073          	sret
    80005416:	00000013          	nop
    8000541a:	00000013          	nop
    8000541e:	0001                	nop

0000000080005420 <timervec>:
    80005420:	34051573          	csrrw	a0,mscratch,a0
    80005424:	e10c                	sd	a1,0(a0)
    80005426:	e510                	sd	a2,8(a0)
    80005428:	e914                	sd	a3,16(a0)
    8000542a:	6d0c                	ld	a1,24(a0)
    8000542c:	7110                	ld	a2,32(a0)
    8000542e:	6194                	ld	a3,0(a1)
    80005430:	96b2                	add	a3,a3,a2
    80005432:	e194                	sd	a3,0(a1)
    80005434:	4589                	li	a1,2
    80005436:	14459073          	csrw	sip,a1
    8000543a:	6914                	ld	a3,16(a0)
    8000543c:	6510                	ld	a2,8(a0)
    8000543e:	610c                	ld	a1,0(a0)
    80005440:	34051573          	csrrw	a0,mscratch,a0
    80005444:	30200073          	mret
	...

000000008000544a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000544a:	1141                	addi	sp,sp,-16
    8000544c:	e422                	sd	s0,8(sp)
    8000544e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005450:	0c0007b7          	lui	a5,0xc000
    80005454:	4705                	li	a4,1
    80005456:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005458:	0c0007b7          	lui	a5,0xc000
    8000545c:	c3d8                	sw	a4,4(a5)
}
    8000545e:	6422                	ld	s0,8(sp)
    80005460:	0141                	addi	sp,sp,16
    80005462:	8082                	ret

0000000080005464 <plicinithart>:

void
plicinithart(void)
{
    80005464:	1141                	addi	sp,sp,-16
    80005466:	e406                	sd	ra,8(sp)
    80005468:	e022                	sd	s0,0(sp)
    8000546a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000546c:	ffffc097          	auipc	ra,0xffffc
    80005470:	b52080e7          	jalr	-1198(ra) # 80000fbe <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005474:	0085171b          	slliw	a4,a0,0x8
    80005478:	0c0027b7          	lui	a5,0xc002
    8000547c:	97ba                	add	a5,a5,a4
    8000547e:	40200713          	li	a4,1026
    80005482:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005486:	00d5151b          	slliw	a0,a0,0xd
    8000548a:	0c2017b7          	lui	a5,0xc201
    8000548e:	97aa                	add	a5,a5,a0
    80005490:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005494:	60a2                	ld	ra,8(sp)
    80005496:	6402                	ld	s0,0(sp)
    80005498:	0141                	addi	sp,sp,16
    8000549a:	8082                	ret

000000008000549c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000549c:	1141                	addi	sp,sp,-16
    8000549e:	e406                	sd	ra,8(sp)
    800054a0:	e022                	sd	s0,0(sp)
    800054a2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054a4:	ffffc097          	auipc	ra,0xffffc
    800054a8:	b1a080e7          	jalr	-1254(ra) # 80000fbe <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800054ac:	00d5151b          	slliw	a0,a0,0xd
    800054b0:	0c2017b7          	lui	a5,0xc201
    800054b4:	97aa                	add	a5,a5,a0
  return irq;
}
    800054b6:	43c8                	lw	a0,4(a5)
    800054b8:	60a2                	ld	ra,8(sp)
    800054ba:	6402                	ld	s0,0(sp)
    800054bc:	0141                	addi	sp,sp,16
    800054be:	8082                	ret

00000000800054c0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800054c0:	1101                	addi	sp,sp,-32
    800054c2:	ec06                	sd	ra,24(sp)
    800054c4:	e822                	sd	s0,16(sp)
    800054c6:	e426                	sd	s1,8(sp)
    800054c8:	1000                	addi	s0,sp,32
    800054ca:	84aa                	mv	s1,a0
  int hart = cpuid();
    800054cc:	ffffc097          	auipc	ra,0xffffc
    800054d0:	af2080e7          	jalr	-1294(ra) # 80000fbe <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800054d4:	00d5151b          	slliw	a0,a0,0xd
    800054d8:	0c2017b7          	lui	a5,0xc201
    800054dc:	97aa                	add	a5,a5,a0
    800054de:	c3c4                	sw	s1,4(a5)
}
    800054e0:	60e2                	ld	ra,24(sp)
    800054e2:	6442                	ld	s0,16(sp)
    800054e4:	64a2                	ld	s1,8(sp)
    800054e6:	6105                	addi	sp,sp,32
    800054e8:	8082                	ret

00000000800054ea <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800054ea:	1141                	addi	sp,sp,-16
    800054ec:	e406                	sd	ra,8(sp)
    800054ee:	e022                	sd	s0,0(sp)
    800054f0:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800054f2:	479d                	li	a5,7
    800054f4:	04a7cc63          	blt	a5,a0,8000554c <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800054f8:	00017797          	auipc	a5,0x17
    800054fc:	12878793          	addi	a5,a5,296 # 8001c620 <disk>
    80005500:	97aa                	add	a5,a5,a0
    80005502:	0187c783          	lbu	a5,24(a5)
    80005506:	ebb9                	bnez	a5,8000555c <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005508:	00451693          	slli	a3,a0,0x4
    8000550c:	00017797          	auipc	a5,0x17
    80005510:	11478793          	addi	a5,a5,276 # 8001c620 <disk>
    80005514:	6398                	ld	a4,0(a5)
    80005516:	9736                	add	a4,a4,a3
    80005518:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    8000551c:	6398                	ld	a4,0(a5)
    8000551e:	9736                	add	a4,a4,a3
    80005520:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005524:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005528:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000552c:	97aa                	add	a5,a5,a0
    8000552e:	4705                	li	a4,1
    80005530:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005534:	00017517          	auipc	a0,0x17
    80005538:	10450513          	addi	a0,a0,260 # 8001c638 <disk+0x18>
    8000553c:	ffffc097          	auipc	ra,0xffffc
    80005540:	246080e7          	jalr	582(ra) # 80001782 <wakeup>
}
    80005544:	60a2                	ld	ra,8(sp)
    80005546:	6402                	ld	s0,0(sp)
    80005548:	0141                	addi	sp,sp,16
    8000554a:	8082                	ret
    panic("free_desc 1");
    8000554c:	00003517          	auipc	a0,0x3
    80005550:	0ec50513          	addi	a0,a0,236 # 80008638 <etext+0x638>
    80005554:	00001097          	auipc	ra,0x1
    80005558:	a6e080e7          	jalr	-1426(ra) # 80005fc2 <panic>
    panic("free_desc 2");
    8000555c:	00003517          	auipc	a0,0x3
    80005560:	0ec50513          	addi	a0,a0,236 # 80008648 <etext+0x648>
    80005564:	00001097          	auipc	ra,0x1
    80005568:	a5e080e7          	jalr	-1442(ra) # 80005fc2 <panic>

000000008000556c <virtio_disk_init>:
{
    8000556c:	1101                	addi	sp,sp,-32
    8000556e:	ec06                	sd	ra,24(sp)
    80005570:	e822                	sd	s0,16(sp)
    80005572:	e426                	sd	s1,8(sp)
    80005574:	e04a                	sd	s2,0(sp)
    80005576:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005578:	00003597          	auipc	a1,0x3
    8000557c:	0e058593          	addi	a1,a1,224 # 80008658 <etext+0x658>
    80005580:	00017517          	auipc	a0,0x17
    80005584:	1c850513          	addi	a0,a0,456 # 8001c748 <disk+0x128>
    80005588:	00001097          	auipc	ra,0x1
    8000558c:	f24080e7          	jalr	-220(ra) # 800064ac <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005590:	100017b7          	lui	a5,0x10001
    80005594:	4398                	lw	a4,0(a5)
    80005596:	2701                	sext.w	a4,a4
    80005598:	747277b7          	lui	a5,0x74727
    8000559c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800055a0:	18f71c63          	bne	a4,a5,80005738 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800055a4:	100017b7          	lui	a5,0x10001
    800055a8:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800055aa:	439c                	lw	a5,0(a5)
    800055ac:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055ae:	4709                	li	a4,2
    800055b0:	18e79463          	bne	a5,a4,80005738 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800055b4:	100017b7          	lui	a5,0x10001
    800055b8:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800055ba:	439c                	lw	a5,0(a5)
    800055bc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800055be:	16e79d63          	bne	a5,a4,80005738 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800055c2:	100017b7          	lui	a5,0x10001
    800055c6:	47d8                	lw	a4,12(a5)
    800055c8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800055ca:	554d47b7          	lui	a5,0x554d4
    800055ce:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800055d2:	16f71363          	bne	a4,a5,80005738 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    800055d6:	100017b7          	lui	a5,0x10001
    800055da:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800055de:	4705                	li	a4,1
    800055e0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055e2:	470d                	li	a4,3
    800055e4:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800055e6:	10001737          	lui	a4,0x10001
    800055ea:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800055ec:	c7ffe737          	lui	a4,0xc7ffe
    800055f0:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd9dbf>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800055f4:	8ef9                	and	a3,a3,a4
    800055f6:	10001737          	lui	a4,0x10001
    800055fa:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055fc:	472d                	li	a4,11
    800055fe:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005600:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005604:	439c                	lw	a5,0(a5)
    80005606:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000560a:	8ba1                	andi	a5,a5,8
    8000560c:	12078e63          	beqz	a5,80005748 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005610:	100017b7          	lui	a5,0x10001
    80005614:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005618:	100017b7          	lui	a5,0x10001
    8000561c:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005620:	439c                	lw	a5,0(a5)
    80005622:	2781                	sext.w	a5,a5
    80005624:	12079a63          	bnez	a5,80005758 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005628:	100017b7          	lui	a5,0x10001
    8000562c:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005630:	439c                	lw	a5,0(a5)
    80005632:	2781                	sext.w	a5,a5
  if(max == 0)
    80005634:	12078a63          	beqz	a5,80005768 <virtio_disk_init+0x1fc>
  if(max < NUM)
    80005638:	471d                	li	a4,7
    8000563a:	12f77f63          	bgeu	a4,a5,80005778 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    8000563e:	ffffb097          	auipc	ra,0xffffb
    80005642:	adc080e7          	jalr	-1316(ra) # 8000011a <kalloc>
    80005646:	00017497          	auipc	s1,0x17
    8000564a:	fda48493          	addi	s1,s1,-38 # 8001c620 <disk>
    8000564e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005650:	ffffb097          	auipc	ra,0xffffb
    80005654:	aca080e7          	jalr	-1334(ra) # 8000011a <kalloc>
    80005658:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000565a:	ffffb097          	auipc	ra,0xffffb
    8000565e:	ac0080e7          	jalr	-1344(ra) # 8000011a <kalloc>
    80005662:	87aa                	mv	a5,a0
    80005664:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005666:	6088                	ld	a0,0(s1)
    80005668:	12050063          	beqz	a0,80005788 <virtio_disk_init+0x21c>
    8000566c:	00017717          	auipc	a4,0x17
    80005670:	fbc73703          	ld	a4,-68(a4) # 8001c628 <disk+0x8>
    80005674:	10070a63          	beqz	a4,80005788 <virtio_disk_init+0x21c>
    80005678:	10078863          	beqz	a5,80005788 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    8000567c:	6605                	lui	a2,0x1
    8000567e:	4581                	li	a1,0
    80005680:	ffffb097          	auipc	ra,0xffffb
    80005684:	afa080e7          	jalr	-1286(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    80005688:	00017497          	auipc	s1,0x17
    8000568c:	f9848493          	addi	s1,s1,-104 # 8001c620 <disk>
    80005690:	6605                	lui	a2,0x1
    80005692:	4581                	li	a1,0
    80005694:	6488                	ld	a0,8(s1)
    80005696:	ffffb097          	auipc	ra,0xffffb
    8000569a:	ae4080e7          	jalr	-1308(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    8000569e:	6605                	lui	a2,0x1
    800056a0:	4581                	li	a1,0
    800056a2:	6888                	ld	a0,16(s1)
    800056a4:	ffffb097          	auipc	ra,0xffffb
    800056a8:	ad6080e7          	jalr	-1322(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800056ac:	100017b7          	lui	a5,0x10001
    800056b0:	4721                	li	a4,8
    800056b2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800056b4:	4098                	lw	a4,0(s1)
    800056b6:	100017b7          	lui	a5,0x10001
    800056ba:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800056be:	40d8                	lw	a4,4(s1)
    800056c0:	100017b7          	lui	a5,0x10001
    800056c4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800056c8:	649c                	ld	a5,8(s1)
    800056ca:	0007869b          	sext.w	a3,a5
    800056ce:	10001737          	lui	a4,0x10001
    800056d2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800056d6:	9781                	srai	a5,a5,0x20
    800056d8:	10001737          	lui	a4,0x10001
    800056dc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800056e0:	689c                	ld	a5,16(s1)
    800056e2:	0007869b          	sext.w	a3,a5
    800056e6:	10001737          	lui	a4,0x10001
    800056ea:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800056ee:	9781                	srai	a5,a5,0x20
    800056f0:	10001737          	lui	a4,0x10001
    800056f4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800056f8:	10001737          	lui	a4,0x10001
    800056fc:	4785                	li	a5,1
    800056fe:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005700:	00f48c23          	sb	a5,24(s1)
    80005704:	00f48ca3          	sb	a5,25(s1)
    80005708:	00f48d23          	sb	a5,26(s1)
    8000570c:	00f48da3          	sb	a5,27(s1)
    80005710:	00f48e23          	sb	a5,28(s1)
    80005714:	00f48ea3          	sb	a5,29(s1)
    80005718:	00f48f23          	sb	a5,30(s1)
    8000571c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005720:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005724:	100017b7          	lui	a5,0x10001
    80005728:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000572c:	60e2                	ld	ra,24(sp)
    8000572e:	6442                	ld	s0,16(sp)
    80005730:	64a2                	ld	s1,8(sp)
    80005732:	6902                	ld	s2,0(sp)
    80005734:	6105                	addi	sp,sp,32
    80005736:	8082                	ret
    panic("could not find virtio disk");
    80005738:	00003517          	auipc	a0,0x3
    8000573c:	f3050513          	addi	a0,a0,-208 # 80008668 <etext+0x668>
    80005740:	00001097          	auipc	ra,0x1
    80005744:	882080e7          	jalr	-1918(ra) # 80005fc2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005748:	00003517          	auipc	a0,0x3
    8000574c:	f4050513          	addi	a0,a0,-192 # 80008688 <etext+0x688>
    80005750:	00001097          	auipc	ra,0x1
    80005754:	872080e7          	jalr	-1934(ra) # 80005fc2 <panic>
    panic("virtio disk should not be ready");
    80005758:	00003517          	auipc	a0,0x3
    8000575c:	f5050513          	addi	a0,a0,-176 # 800086a8 <etext+0x6a8>
    80005760:	00001097          	auipc	ra,0x1
    80005764:	862080e7          	jalr	-1950(ra) # 80005fc2 <panic>
    panic("virtio disk has no queue 0");
    80005768:	00003517          	auipc	a0,0x3
    8000576c:	f6050513          	addi	a0,a0,-160 # 800086c8 <etext+0x6c8>
    80005770:	00001097          	auipc	ra,0x1
    80005774:	852080e7          	jalr	-1966(ra) # 80005fc2 <panic>
    panic("virtio disk max queue too short");
    80005778:	00003517          	auipc	a0,0x3
    8000577c:	f7050513          	addi	a0,a0,-144 # 800086e8 <etext+0x6e8>
    80005780:	00001097          	auipc	ra,0x1
    80005784:	842080e7          	jalr	-1982(ra) # 80005fc2 <panic>
    panic("virtio disk kalloc");
    80005788:	00003517          	auipc	a0,0x3
    8000578c:	f8050513          	addi	a0,a0,-128 # 80008708 <etext+0x708>
    80005790:	00001097          	auipc	ra,0x1
    80005794:	832080e7          	jalr	-1998(ra) # 80005fc2 <panic>

0000000080005798 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005798:	7159                	addi	sp,sp,-112
    8000579a:	f486                	sd	ra,104(sp)
    8000579c:	f0a2                	sd	s0,96(sp)
    8000579e:	eca6                	sd	s1,88(sp)
    800057a0:	e8ca                	sd	s2,80(sp)
    800057a2:	e4ce                	sd	s3,72(sp)
    800057a4:	e0d2                	sd	s4,64(sp)
    800057a6:	fc56                	sd	s5,56(sp)
    800057a8:	f85a                	sd	s6,48(sp)
    800057aa:	f45e                	sd	s7,40(sp)
    800057ac:	f062                	sd	s8,32(sp)
    800057ae:	ec66                	sd	s9,24(sp)
    800057b0:	1880                	addi	s0,sp,112
    800057b2:	8a2a                	mv	s4,a0
    800057b4:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800057b6:	00c52c83          	lw	s9,12(a0)
    800057ba:	001c9c9b          	slliw	s9,s9,0x1
    800057be:	1c82                	slli	s9,s9,0x20
    800057c0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800057c4:	00017517          	auipc	a0,0x17
    800057c8:	f8450513          	addi	a0,a0,-124 # 8001c748 <disk+0x128>
    800057cc:	00001097          	auipc	ra,0x1
    800057d0:	d70080e7          	jalr	-656(ra) # 8000653c <acquire>
  for(int i = 0; i < 3; i++){
    800057d4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800057d6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800057d8:	00017b17          	auipc	s6,0x17
    800057dc:	e48b0b13          	addi	s6,s6,-440 # 8001c620 <disk>
  for(int i = 0; i < 3; i++){
    800057e0:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800057e2:	00017c17          	auipc	s8,0x17
    800057e6:	f66c0c13          	addi	s8,s8,-154 # 8001c748 <disk+0x128>
    800057ea:	a0ad                	j	80005854 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    800057ec:	00fb0733          	add	a4,s6,a5
    800057f0:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    800057f4:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800057f6:	0207c563          	bltz	a5,80005820 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800057fa:	2905                	addiw	s2,s2,1
    800057fc:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800057fe:	05590f63          	beq	s2,s5,8000585c <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80005802:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005804:	00017717          	auipc	a4,0x17
    80005808:	e1c70713          	addi	a4,a4,-484 # 8001c620 <disk>
    8000580c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000580e:	01874683          	lbu	a3,24(a4)
    80005812:	fee9                	bnez	a3,800057ec <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80005814:	2785                	addiw	a5,a5,1
    80005816:	0705                	addi	a4,a4,1
    80005818:	fe979be3          	bne	a5,s1,8000580e <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000581c:	57fd                	li	a5,-1
    8000581e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005820:	03205163          	blez	s2,80005842 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80005824:	f9042503          	lw	a0,-112(s0)
    80005828:	00000097          	auipc	ra,0x0
    8000582c:	cc2080e7          	jalr	-830(ra) # 800054ea <free_desc>
      for(int j = 0; j < i; j++)
    80005830:	4785                	li	a5,1
    80005832:	0127d863          	bge	a5,s2,80005842 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80005836:	f9442503          	lw	a0,-108(s0)
    8000583a:	00000097          	auipc	ra,0x0
    8000583e:	cb0080e7          	jalr	-848(ra) # 800054ea <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005842:	85e2                	mv	a1,s8
    80005844:	00017517          	auipc	a0,0x17
    80005848:	df450513          	addi	a0,a0,-524 # 8001c638 <disk+0x18>
    8000584c:	ffffc097          	auipc	ra,0xffffc
    80005850:	ed2080e7          	jalr	-302(ra) # 8000171e <sleep>
  for(int i = 0; i < 3; i++){
    80005854:	f9040613          	addi	a2,s0,-112
    80005858:	894e                	mv	s2,s3
    8000585a:	b765                	j	80005802 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000585c:	f9042503          	lw	a0,-112(s0)
    80005860:	00451693          	slli	a3,a0,0x4

  if(write)
    80005864:	00017797          	auipc	a5,0x17
    80005868:	dbc78793          	addi	a5,a5,-580 # 8001c620 <disk>
    8000586c:	00a50713          	addi	a4,a0,10
    80005870:	0712                	slli	a4,a4,0x4
    80005872:	973e                	add	a4,a4,a5
    80005874:	01703633          	snez	a2,s7
    80005878:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000587a:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    8000587e:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005882:	6398                	ld	a4,0(a5)
    80005884:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005886:	0a868613          	addi	a2,a3,168
    8000588a:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000588c:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000588e:	6390                	ld	a2,0(a5)
    80005890:	00d605b3          	add	a1,a2,a3
    80005894:	4741                	li	a4,16
    80005896:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005898:	4805                	li	a6,1
    8000589a:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    8000589e:	f9442703          	lw	a4,-108(s0)
    800058a2:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800058a6:	0712                	slli	a4,a4,0x4
    800058a8:	963a                	add	a2,a2,a4
    800058aa:	058a0593          	addi	a1,s4,88
    800058ae:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800058b0:	0007b883          	ld	a7,0(a5)
    800058b4:	9746                	add	a4,a4,a7
    800058b6:	40000613          	li	a2,1024
    800058ba:	c710                	sw	a2,8(a4)
  if(write)
    800058bc:	001bb613          	seqz	a2,s7
    800058c0:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800058c4:	00166613          	ori	a2,a2,1
    800058c8:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800058cc:	f9842583          	lw	a1,-104(s0)
    800058d0:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800058d4:	00250613          	addi	a2,a0,2
    800058d8:	0612                	slli	a2,a2,0x4
    800058da:	963e                	add	a2,a2,a5
    800058dc:	577d                	li	a4,-1
    800058de:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800058e2:	0592                	slli	a1,a1,0x4
    800058e4:	98ae                	add	a7,a7,a1
    800058e6:	03068713          	addi	a4,a3,48
    800058ea:	973e                	add	a4,a4,a5
    800058ec:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800058f0:	6398                	ld	a4,0(a5)
    800058f2:	972e                	add	a4,a4,a1
    800058f4:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800058f8:	4689                	li	a3,2
    800058fa:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800058fe:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005902:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80005906:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000590a:	6794                	ld	a3,8(a5)
    8000590c:	0026d703          	lhu	a4,2(a3)
    80005910:	8b1d                	andi	a4,a4,7
    80005912:	0706                	slli	a4,a4,0x1
    80005914:	96ba                	add	a3,a3,a4
    80005916:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000591a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000591e:	6798                	ld	a4,8(a5)
    80005920:	00275783          	lhu	a5,2(a4)
    80005924:	2785                	addiw	a5,a5,1
    80005926:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000592a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000592e:	100017b7          	lui	a5,0x10001
    80005932:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005936:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    8000593a:	00017917          	auipc	s2,0x17
    8000593e:	e0e90913          	addi	s2,s2,-498 # 8001c748 <disk+0x128>
  while(b->disk == 1) {
    80005942:	4485                	li	s1,1
    80005944:	01079c63          	bne	a5,a6,8000595c <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005948:	85ca                	mv	a1,s2
    8000594a:	8552                	mv	a0,s4
    8000594c:	ffffc097          	auipc	ra,0xffffc
    80005950:	dd2080e7          	jalr	-558(ra) # 8000171e <sleep>
  while(b->disk == 1) {
    80005954:	004a2783          	lw	a5,4(s4)
    80005958:	fe9788e3          	beq	a5,s1,80005948 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    8000595c:	f9042903          	lw	s2,-112(s0)
    80005960:	00290713          	addi	a4,s2,2
    80005964:	0712                	slli	a4,a4,0x4
    80005966:	00017797          	auipc	a5,0x17
    8000596a:	cba78793          	addi	a5,a5,-838 # 8001c620 <disk>
    8000596e:	97ba                	add	a5,a5,a4
    80005970:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005974:	00017997          	auipc	s3,0x17
    80005978:	cac98993          	addi	s3,s3,-852 # 8001c620 <disk>
    8000597c:	00491713          	slli	a4,s2,0x4
    80005980:	0009b783          	ld	a5,0(s3)
    80005984:	97ba                	add	a5,a5,a4
    80005986:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000598a:	854a                	mv	a0,s2
    8000598c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005990:	00000097          	auipc	ra,0x0
    80005994:	b5a080e7          	jalr	-1190(ra) # 800054ea <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005998:	8885                	andi	s1,s1,1
    8000599a:	f0ed                	bnez	s1,8000597c <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000599c:	00017517          	auipc	a0,0x17
    800059a0:	dac50513          	addi	a0,a0,-596 # 8001c748 <disk+0x128>
    800059a4:	00001097          	auipc	ra,0x1
    800059a8:	c4c080e7          	jalr	-948(ra) # 800065f0 <release>
}
    800059ac:	70a6                	ld	ra,104(sp)
    800059ae:	7406                	ld	s0,96(sp)
    800059b0:	64e6                	ld	s1,88(sp)
    800059b2:	6946                	ld	s2,80(sp)
    800059b4:	69a6                	ld	s3,72(sp)
    800059b6:	6a06                	ld	s4,64(sp)
    800059b8:	7ae2                	ld	s5,56(sp)
    800059ba:	7b42                	ld	s6,48(sp)
    800059bc:	7ba2                	ld	s7,40(sp)
    800059be:	7c02                	ld	s8,32(sp)
    800059c0:	6ce2                	ld	s9,24(sp)
    800059c2:	6165                	addi	sp,sp,112
    800059c4:	8082                	ret

00000000800059c6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800059c6:	1101                	addi	sp,sp,-32
    800059c8:	ec06                	sd	ra,24(sp)
    800059ca:	e822                	sd	s0,16(sp)
    800059cc:	e426                	sd	s1,8(sp)
    800059ce:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800059d0:	00017497          	auipc	s1,0x17
    800059d4:	c5048493          	addi	s1,s1,-944 # 8001c620 <disk>
    800059d8:	00017517          	auipc	a0,0x17
    800059dc:	d7050513          	addi	a0,a0,-656 # 8001c748 <disk+0x128>
    800059e0:	00001097          	auipc	ra,0x1
    800059e4:	b5c080e7          	jalr	-1188(ra) # 8000653c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800059e8:	100017b7          	lui	a5,0x10001
    800059ec:	53b8                	lw	a4,96(a5)
    800059ee:	8b0d                	andi	a4,a4,3
    800059f0:	100017b7          	lui	a5,0x10001
    800059f4:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800059f6:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800059fa:	689c                	ld	a5,16(s1)
    800059fc:	0204d703          	lhu	a4,32(s1)
    80005a00:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005a04:	04f70863          	beq	a4,a5,80005a54 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80005a08:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005a0c:	6898                	ld	a4,16(s1)
    80005a0e:	0204d783          	lhu	a5,32(s1)
    80005a12:	8b9d                	andi	a5,a5,7
    80005a14:	078e                	slli	a5,a5,0x3
    80005a16:	97ba                	add	a5,a5,a4
    80005a18:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005a1a:	00278713          	addi	a4,a5,2
    80005a1e:	0712                	slli	a4,a4,0x4
    80005a20:	9726                	add	a4,a4,s1
    80005a22:	01074703          	lbu	a4,16(a4)
    80005a26:	e721                	bnez	a4,80005a6e <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005a28:	0789                	addi	a5,a5,2
    80005a2a:	0792                	slli	a5,a5,0x4
    80005a2c:	97a6                	add	a5,a5,s1
    80005a2e:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005a30:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005a34:	ffffc097          	auipc	ra,0xffffc
    80005a38:	d4e080e7          	jalr	-690(ra) # 80001782 <wakeup>

    disk.used_idx += 1;
    80005a3c:	0204d783          	lhu	a5,32(s1)
    80005a40:	2785                	addiw	a5,a5,1
    80005a42:	17c2                	slli	a5,a5,0x30
    80005a44:	93c1                	srli	a5,a5,0x30
    80005a46:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005a4a:	6898                	ld	a4,16(s1)
    80005a4c:	00275703          	lhu	a4,2(a4)
    80005a50:	faf71ce3          	bne	a4,a5,80005a08 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80005a54:	00017517          	auipc	a0,0x17
    80005a58:	cf450513          	addi	a0,a0,-780 # 8001c748 <disk+0x128>
    80005a5c:	00001097          	auipc	ra,0x1
    80005a60:	b94080e7          	jalr	-1132(ra) # 800065f0 <release>
}
    80005a64:	60e2                	ld	ra,24(sp)
    80005a66:	6442                	ld	s0,16(sp)
    80005a68:	64a2                	ld	s1,8(sp)
    80005a6a:	6105                	addi	sp,sp,32
    80005a6c:	8082                	ret
      panic("virtio_disk_intr status");
    80005a6e:	00003517          	auipc	a0,0x3
    80005a72:	cb250513          	addi	a0,a0,-846 # 80008720 <etext+0x720>
    80005a76:	00000097          	auipc	ra,0x0
    80005a7a:	54c080e7          	jalr	1356(ra) # 80005fc2 <panic>

0000000080005a7e <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005a7e:	1141                	addi	sp,sp,-16
    80005a80:	e422                	sd	s0,8(sp)
    80005a82:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a84:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005a88:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005a8c:	0037979b          	slliw	a5,a5,0x3
    80005a90:	02004737          	lui	a4,0x2004
    80005a94:	97ba                	add	a5,a5,a4
    80005a96:	0200c737          	lui	a4,0x200c
    80005a9a:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    80005a9c:	6318                	ld	a4,0(a4)
    80005a9e:	000f4637          	lui	a2,0xf4
    80005aa2:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005aa6:	9732                	add	a4,a4,a2
    80005aa8:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005aaa:	00259693          	slli	a3,a1,0x2
    80005aae:	96ae                	add	a3,a3,a1
    80005ab0:	068e                	slli	a3,a3,0x3
    80005ab2:	00017717          	auipc	a4,0x17
    80005ab6:	cae70713          	addi	a4,a4,-850 # 8001c760 <timer_scratch>
    80005aba:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005abc:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005abe:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005ac0:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005ac4:	00000797          	auipc	a5,0x0
    80005ac8:	95c78793          	addi	a5,a5,-1700 # 80005420 <timervec>
    80005acc:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005ad0:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005ad4:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005ad8:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005adc:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005ae0:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005ae4:	30479073          	csrw	mie,a5
}
    80005ae8:	6422                	ld	s0,8(sp)
    80005aea:	0141                	addi	sp,sp,16
    80005aec:	8082                	ret

0000000080005aee <start>:
{
    80005aee:	1141                	addi	sp,sp,-16
    80005af0:	e406                	sd	ra,8(sp)
    80005af2:	e022                	sd	s0,0(sp)
    80005af4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005af6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005afa:	7779                	lui	a4,0xffffe
    80005afc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd9e5f>
    80005b00:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005b02:	6705                	lui	a4,0x1
    80005b04:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005b08:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b0a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005b0e:	ffffb797          	auipc	a5,0xffffb
    80005b12:	80a78793          	addi	a5,a5,-2038 # 80000318 <main>
    80005b16:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005b1a:	4781                	li	a5,0
    80005b1c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005b20:	67c1                	lui	a5,0x10
    80005b22:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005b24:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005b28:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005b2c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005b30:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005b34:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005b38:	57fd                	li	a5,-1
    80005b3a:	83a9                	srli	a5,a5,0xa
    80005b3c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005b40:	47bd                	li	a5,15
    80005b42:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005b46:	00000097          	auipc	ra,0x0
    80005b4a:	f38080e7          	jalr	-200(ra) # 80005a7e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005b4e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005b52:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005b54:	823e                	mv	tp,a5
  asm volatile("mret");
    80005b56:	30200073          	mret
}
    80005b5a:	60a2                	ld	ra,8(sp)
    80005b5c:	6402                	ld	s0,0(sp)
    80005b5e:	0141                	addi	sp,sp,16
    80005b60:	8082                	ret

0000000080005b62 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005b62:	715d                	addi	sp,sp,-80
    80005b64:	e486                	sd	ra,72(sp)
    80005b66:	e0a2                	sd	s0,64(sp)
    80005b68:	f84a                	sd	s2,48(sp)
    80005b6a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005b6c:	04c05663          	blez	a2,80005bb8 <consolewrite+0x56>
    80005b70:	fc26                	sd	s1,56(sp)
    80005b72:	f44e                	sd	s3,40(sp)
    80005b74:	f052                	sd	s4,32(sp)
    80005b76:	ec56                	sd	s5,24(sp)
    80005b78:	8a2a                	mv	s4,a0
    80005b7a:	84ae                	mv	s1,a1
    80005b7c:	89b2                	mv	s3,a2
    80005b7e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005b80:	5afd                	li	s5,-1
    80005b82:	4685                	li	a3,1
    80005b84:	8626                	mv	a2,s1
    80005b86:	85d2                	mv	a1,s4
    80005b88:	fbf40513          	addi	a0,s0,-65
    80005b8c:	ffffc097          	auipc	ra,0xffffc
    80005b90:	ff0080e7          	jalr	-16(ra) # 80001b7c <either_copyin>
    80005b94:	03550463          	beq	a0,s5,80005bbc <consolewrite+0x5a>
      break;
    uartputc(c);
    80005b98:	fbf44503          	lbu	a0,-65(s0)
    80005b9c:	00000097          	auipc	ra,0x0
    80005ba0:	7e4080e7          	jalr	2020(ra) # 80006380 <uartputc>
  for(i = 0; i < n; i++){
    80005ba4:	2905                	addiw	s2,s2,1
    80005ba6:	0485                	addi	s1,s1,1
    80005ba8:	fd299de3          	bne	s3,s2,80005b82 <consolewrite+0x20>
    80005bac:	894e                	mv	s2,s3
    80005bae:	74e2                	ld	s1,56(sp)
    80005bb0:	79a2                	ld	s3,40(sp)
    80005bb2:	7a02                	ld	s4,32(sp)
    80005bb4:	6ae2                	ld	s5,24(sp)
    80005bb6:	a039                	j	80005bc4 <consolewrite+0x62>
    80005bb8:	4901                	li	s2,0
    80005bba:	a029                	j	80005bc4 <consolewrite+0x62>
    80005bbc:	74e2                	ld	s1,56(sp)
    80005bbe:	79a2                	ld	s3,40(sp)
    80005bc0:	7a02                	ld	s4,32(sp)
    80005bc2:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005bc4:	854a                	mv	a0,s2
    80005bc6:	60a6                	ld	ra,72(sp)
    80005bc8:	6406                	ld	s0,64(sp)
    80005bca:	7942                	ld	s2,48(sp)
    80005bcc:	6161                	addi	sp,sp,80
    80005bce:	8082                	ret

0000000080005bd0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005bd0:	711d                	addi	sp,sp,-96
    80005bd2:	ec86                	sd	ra,88(sp)
    80005bd4:	e8a2                	sd	s0,80(sp)
    80005bd6:	e4a6                	sd	s1,72(sp)
    80005bd8:	e0ca                	sd	s2,64(sp)
    80005bda:	fc4e                	sd	s3,56(sp)
    80005bdc:	f852                	sd	s4,48(sp)
    80005bde:	f456                	sd	s5,40(sp)
    80005be0:	f05a                	sd	s6,32(sp)
    80005be2:	1080                	addi	s0,sp,96
    80005be4:	8aaa                	mv	s5,a0
    80005be6:	8a2e                	mv	s4,a1
    80005be8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005bea:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005bee:	0001f517          	auipc	a0,0x1f
    80005bf2:	cb250513          	addi	a0,a0,-846 # 800248a0 <cons>
    80005bf6:	00001097          	auipc	ra,0x1
    80005bfa:	946080e7          	jalr	-1722(ra) # 8000653c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005bfe:	0001f497          	auipc	s1,0x1f
    80005c02:	ca248493          	addi	s1,s1,-862 # 800248a0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005c06:	0001f917          	auipc	s2,0x1f
    80005c0a:	d3290913          	addi	s2,s2,-718 # 80024938 <cons+0x98>
  while(n > 0){
    80005c0e:	0d305763          	blez	s3,80005cdc <consoleread+0x10c>
    while(cons.r == cons.w){
    80005c12:	0984a783          	lw	a5,152(s1)
    80005c16:	09c4a703          	lw	a4,156(s1)
    80005c1a:	0af71c63          	bne	a4,a5,80005cd2 <consoleread+0x102>
      if(killed(myproc())){
    80005c1e:	ffffb097          	auipc	ra,0xffffb
    80005c22:	3cc080e7          	jalr	972(ra) # 80000fea <myproc>
    80005c26:	ffffc097          	auipc	ra,0xffffc
    80005c2a:	da0080e7          	jalr	-608(ra) # 800019c6 <killed>
    80005c2e:	e52d                	bnez	a0,80005c98 <consoleread+0xc8>
      sleep(&cons.r, &cons.lock);
    80005c30:	85a6                	mv	a1,s1
    80005c32:	854a                	mv	a0,s2
    80005c34:	ffffc097          	auipc	ra,0xffffc
    80005c38:	aea080e7          	jalr	-1302(ra) # 8000171e <sleep>
    while(cons.r == cons.w){
    80005c3c:	0984a783          	lw	a5,152(s1)
    80005c40:	09c4a703          	lw	a4,156(s1)
    80005c44:	fcf70de3          	beq	a4,a5,80005c1e <consoleread+0x4e>
    80005c48:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005c4a:	0001f717          	auipc	a4,0x1f
    80005c4e:	c5670713          	addi	a4,a4,-938 # 800248a0 <cons>
    80005c52:	0017869b          	addiw	a3,a5,1
    80005c56:	08d72c23          	sw	a3,152(a4)
    80005c5a:	07f7f693          	andi	a3,a5,127
    80005c5e:	9736                	add	a4,a4,a3
    80005c60:	01874703          	lbu	a4,24(a4)
    80005c64:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005c68:	4691                	li	a3,4
    80005c6a:	04db8a63          	beq	s7,a3,80005cbe <consoleread+0xee>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005c6e:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005c72:	4685                	li	a3,1
    80005c74:	faf40613          	addi	a2,s0,-81
    80005c78:	85d2                	mv	a1,s4
    80005c7a:	8556                	mv	a0,s5
    80005c7c:	ffffc097          	auipc	ra,0xffffc
    80005c80:	eaa080e7          	jalr	-342(ra) # 80001b26 <either_copyout>
    80005c84:	57fd                	li	a5,-1
    80005c86:	04f50a63          	beq	a0,a5,80005cda <consoleread+0x10a>
      break;

    dst++;
    80005c8a:	0a05                	addi	s4,s4,1
    --n;
    80005c8c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005c8e:	47a9                	li	a5,10
    80005c90:	06fb8163          	beq	s7,a5,80005cf2 <consoleread+0x122>
    80005c94:	6be2                	ld	s7,24(sp)
    80005c96:	bfa5                	j	80005c0e <consoleread+0x3e>
        release(&cons.lock);
    80005c98:	0001f517          	auipc	a0,0x1f
    80005c9c:	c0850513          	addi	a0,a0,-1016 # 800248a0 <cons>
    80005ca0:	00001097          	auipc	ra,0x1
    80005ca4:	950080e7          	jalr	-1712(ra) # 800065f0 <release>
        return -1;
    80005ca8:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005caa:	60e6                	ld	ra,88(sp)
    80005cac:	6446                	ld	s0,80(sp)
    80005cae:	64a6                	ld	s1,72(sp)
    80005cb0:	6906                	ld	s2,64(sp)
    80005cb2:	79e2                	ld	s3,56(sp)
    80005cb4:	7a42                	ld	s4,48(sp)
    80005cb6:	7aa2                	ld	s5,40(sp)
    80005cb8:	7b02                	ld	s6,32(sp)
    80005cba:	6125                	addi	sp,sp,96
    80005cbc:	8082                	ret
      if(n < target){
    80005cbe:	0009871b          	sext.w	a4,s3
    80005cc2:	01677a63          	bgeu	a4,s6,80005cd6 <consoleread+0x106>
        cons.r--;
    80005cc6:	0001f717          	auipc	a4,0x1f
    80005cca:	c6f72923          	sw	a5,-910(a4) # 80024938 <cons+0x98>
    80005cce:	6be2                	ld	s7,24(sp)
    80005cd0:	a031                	j	80005cdc <consoleread+0x10c>
    80005cd2:	ec5e                	sd	s7,24(sp)
    80005cd4:	bf9d                	j	80005c4a <consoleread+0x7a>
    80005cd6:	6be2                	ld	s7,24(sp)
    80005cd8:	a011                	j	80005cdc <consoleread+0x10c>
    80005cda:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005cdc:	0001f517          	auipc	a0,0x1f
    80005ce0:	bc450513          	addi	a0,a0,-1084 # 800248a0 <cons>
    80005ce4:	00001097          	auipc	ra,0x1
    80005ce8:	90c080e7          	jalr	-1780(ra) # 800065f0 <release>
  return target - n;
    80005cec:	413b053b          	subw	a0,s6,s3
    80005cf0:	bf6d                	j	80005caa <consoleread+0xda>
    80005cf2:	6be2                	ld	s7,24(sp)
    80005cf4:	b7e5                	j	80005cdc <consoleread+0x10c>

0000000080005cf6 <consputc>:
{
    80005cf6:	1141                	addi	sp,sp,-16
    80005cf8:	e406                	sd	ra,8(sp)
    80005cfa:	e022                	sd	s0,0(sp)
    80005cfc:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005cfe:	10000793          	li	a5,256
    80005d02:	00f50a63          	beq	a0,a5,80005d16 <consputc+0x20>
    uartputc_sync(c);
    80005d06:	00000097          	auipc	ra,0x0
    80005d0a:	59c080e7          	jalr	1436(ra) # 800062a2 <uartputc_sync>
}
    80005d0e:	60a2                	ld	ra,8(sp)
    80005d10:	6402                	ld	s0,0(sp)
    80005d12:	0141                	addi	sp,sp,16
    80005d14:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005d16:	4521                	li	a0,8
    80005d18:	00000097          	auipc	ra,0x0
    80005d1c:	58a080e7          	jalr	1418(ra) # 800062a2 <uartputc_sync>
    80005d20:	02000513          	li	a0,32
    80005d24:	00000097          	auipc	ra,0x0
    80005d28:	57e080e7          	jalr	1406(ra) # 800062a2 <uartputc_sync>
    80005d2c:	4521                	li	a0,8
    80005d2e:	00000097          	auipc	ra,0x0
    80005d32:	574080e7          	jalr	1396(ra) # 800062a2 <uartputc_sync>
    80005d36:	bfe1                	j	80005d0e <consputc+0x18>

0000000080005d38 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005d38:	1101                	addi	sp,sp,-32
    80005d3a:	ec06                	sd	ra,24(sp)
    80005d3c:	e822                	sd	s0,16(sp)
    80005d3e:	e426                	sd	s1,8(sp)
    80005d40:	1000                	addi	s0,sp,32
    80005d42:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005d44:	0001f517          	auipc	a0,0x1f
    80005d48:	b5c50513          	addi	a0,a0,-1188 # 800248a0 <cons>
    80005d4c:	00000097          	auipc	ra,0x0
    80005d50:	7f0080e7          	jalr	2032(ra) # 8000653c <acquire>

  switch(c){
    80005d54:	47d5                	li	a5,21
    80005d56:	0af48563          	beq	s1,a5,80005e00 <consoleintr+0xc8>
    80005d5a:	0297c963          	blt	a5,s1,80005d8c <consoleintr+0x54>
    80005d5e:	47a1                	li	a5,8
    80005d60:	0ef48c63          	beq	s1,a5,80005e58 <consoleintr+0x120>
    80005d64:	47c1                	li	a5,16
    80005d66:	10f49f63          	bne	s1,a5,80005e84 <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005d6a:	ffffc097          	auipc	ra,0xffffc
    80005d6e:	e68080e7          	jalr	-408(ra) # 80001bd2 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005d72:	0001f517          	auipc	a0,0x1f
    80005d76:	b2e50513          	addi	a0,a0,-1234 # 800248a0 <cons>
    80005d7a:	00001097          	auipc	ra,0x1
    80005d7e:	876080e7          	jalr	-1930(ra) # 800065f0 <release>
}
    80005d82:	60e2                	ld	ra,24(sp)
    80005d84:	6442                	ld	s0,16(sp)
    80005d86:	64a2                	ld	s1,8(sp)
    80005d88:	6105                	addi	sp,sp,32
    80005d8a:	8082                	ret
  switch(c){
    80005d8c:	07f00793          	li	a5,127
    80005d90:	0cf48463          	beq	s1,a5,80005e58 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005d94:	0001f717          	auipc	a4,0x1f
    80005d98:	b0c70713          	addi	a4,a4,-1268 # 800248a0 <cons>
    80005d9c:	0a072783          	lw	a5,160(a4)
    80005da0:	09872703          	lw	a4,152(a4)
    80005da4:	9f99                	subw	a5,a5,a4
    80005da6:	07f00713          	li	a4,127
    80005daa:	fcf764e3          	bltu	a4,a5,80005d72 <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005dae:	47b5                	li	a5,13
    80005db0:	0cf48d63          	beq	s1,a5,80005e8a <consoleintr+0x152>
      consputc(c);
    80005db4:	8526                	mv	a0,s1
    80005db6:	00000097          	auipc	ra,0x0
    80005dba:	f40080e7          	jalr	-192(ra) # 80005cf6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005dbe:	0001f797          	auipc	a5,0x1f
    80005dc2:	ae278793          	addi	a5,a5,-1310 # 800248a0 <cons>
    80005dc6:	0a07a683          	lw	a3,160(a5)
    80005dca:	0016871b          	addiw	a4,a3,1
    80005dce:	0007061b          	sext.w	a2,a4
    80005dd2:	0ae7a023          	sw	a4,160(a5)
    80005dd6:	07f6f693          	andi	a3,a3,127
    80005dda:	97b6                	add	a5,a5,a3
    80005ddc:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005de0:	47a9                	li	a5,10
    80005de2:	0cf48b63          	beq	s1,a5,80005eb8 <consoleintr+0x180>
    80005de6:	4791                	li	a5,4
    80005de8:	0cf48863          	beq	s1,a5,80005eb8 <consoleintr+0x180>
    80005dec:	0001f797          	auipc	a5,0x1f
    80005df0:	b4c7a783          	lw	a5,-1204(a5) # 80024938 <cons+0x98>
    80005df4:	9f1d                	subw	a4,a4,a5
    80005df6:	08000793          	li	a5,128
    80005dfa:	f6f71ce3          	bne	a4,a5,80005d72 <consoleintr+0x3a>
    80005dfe:	a86d                	j	80005eb8 <consoleintr+0x180>
    80005e00:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005e02:	0001f717          	auipc	a4,0x1f
    80005e06:	a9e70713          	addi	a4,a4,-1378 # 800248a0 <cons>
    80005e0a:	0a072783          	lw	a5,160(a4)
    80005e0e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005e12:	0001f497          	auipc	s1,0x1f
    80005e16:	a8e48493          	addi	s1,s1,-1394 # 800248a0 <cons>
    while(cons.e != cons.w &&
    80005e1a:	4929                	li	s2,10
    80005e1c:	02f70a63          	beq	a4,a5,80005e50 <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005e20:	37fd                	addiw	a5,a5,-1
    80005e22:	07f7f713          	andi	a4,a5,127
    80005e26:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005e28:	01874703          	lbu	a4,24(a4)
    80005e2c:	03270463          	beq	a4,s2,80005e54 <consoleintr+0x11c>
      cons.e--;
    80005e30:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005e34:	10000513          	li	a0,256
    80005e38:	00000097          	auipc	ra,0x0
    80005e3c:	ebe080e7          	jalr	-322(ra) # 80005cf6 <consputc>
    while(cons.e != cons.w &&
    80005e40:	0a04a783          	lw	a5,160(s1)
    80005e44:	09c4a703          	lw	a4,156(s1)
    80005e48:	fcf71ce3          	bne	a4,a5,80005e20 <consoleintr+0xe8>
    80005e4c:	6902                	ld	s2,0(sp)
    80005e4e:	b715                	j	80005d72 <consoleintr+0x3a>
    80005e50:	6902                	ld	s2,0(sp)
    80005e52:	b705                	j	80005d72 <consoleintr+0x3a>
    80005e54:	6902                	ld	s2,0(sp)
    80005e56:	bf31                	j	80005d72 <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005e58:	0001f717          	auipc	a4,0x1f
    80005e5c:	a4870713          	addi	a4,a4,-1464 # 800248a0 <cons>
    80005e60:	0a072783          	lw	a5,160(a4)
    80005e64:	09c72703          	lw	a4,156(a4)
    80005e68:	f0f705e3          	beq	a4,a5,80005d72 <consoleintr+0x3a>
      cons.e--;
    80005e6c:	37fd                	addiw	a5,a5,-1
    80005e6e:	0001f717          	auipc	a4,0x1f
    80005e72:	acf72923          	sw	a5,-1326(a4) # 80024940 <cons+0xa0>
      consputc(BACKSPACE);
    80005e76:	10000513          	li	a0,256
    80005e7a:	00000097          	auipc	ra,0x0
    80005e7e:	e7c080e7          	jalr	-388(ra) # 80005cf6 <consputc>
    80005e82:	bdc5                	j	80005d72 <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005e84:	ee0487e3          	beqz	s1,80005d72 <consoleintr+0x3a>
    80005e88:	b731                	j	80005d94 <consoleintr+0x5c>
      consputc(c);
    80005e8a:	4529                	li	a0,10
    80005e8c:	00000097          	auipc	ra,0x0
    80005e90:	e6a080e7          	jalr	-406(ra) # 80005cf6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005e94:	0001f797          	auipc	a5,0x1f
    80005e98:	a0c78793          	addi	a5,a5,-1524 # 800248a0 <cons>
    80005e9c:	0a07a703          	lw	a4,160(a5)
    80005ea0:	0017069b          	addiw	a3,a4,1
    80005ea4:	0006861b          	sext.w	a2,a3
    80005ea8:	0ad7a023          	sw	a3,160(a5)
    80005eac:	07f77713          	andi	a4,a4,127
    80005eb0:	97ba                	add	a5,a5,a4
    80005eb2:	4729                	li	a4,10
    80005eb4:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005eb8:	0001f797          	auipc	a5,0x1f
    80005ebc:	a8c7a223          	sw	a2,-1404(a5) # 8002493c <cons+0x9c>
        wakeup(&cons.r);
    80005ec0:	0001f517          	auipc	a0,0x1f
    80005ec4:	a7850513          	addi	a0,a0,-1416 # 80024938 <cons+0x98>
    80005ec8:	ffffc097          	auipc	ra,0xffffc
    80005ecc:	8ba080e7          	jalr	-1862(ra) # 80001782 <wakeup>
    80005ed0:	b54d                	j	80005d72 <consoleintr+0x3a>

0000000080005ed2 <consoleinit>:

void
consoleinit(void)
{
    80005ed2:	1141                	addi	sp,sp,-16
    80005ed4:	e406                	sd	ra,8(sp)
    80005ed6:	e022                	sd	s0,0(sp)
    80005ed8:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005eda:	00003597          	auipc	a1,0x3
    80005ede:	85e58593          	addi	a1,a1,-1954 # 80008738 <etext+0x738>
    80005ee2:	0001f517          	auipc	a0,0x1f
    80005ee6:	9be50513          	addi	a0,a0,-1602 # 800248a0 <cons>
    80005eea:	00000097          	auipc	ra,0x0
    80005eee:	5c2080e7          	jalr	1474(ra) # 800064ac <initlock>

  uartinit();
    80005ef2:	00000097          	auipc	ra,0x0
    80005ef6:	354080e7          	jalr	852(ra) # 80006246 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005efa:	00015797          	auipc	a5,0x15
    80005efe:	6ce78793          	addi	a5,a5,1742 # 8001b5c8 <devsw>
    80005f02:	00000717          	auipc	a4,0x0
    80005f06:	cce70713          	addi	a4,a4,-818 # 80005bd0 <consoleread>
    80005f0a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005f0c:	00000717          	auipc	a4,0x0
    80005f10:	c5670713          	addi	a4,a4,-938 # 80005b62 <consolewrite>
    80005f14:	ef98                	sd	a4,24(a5)
}
    80005f16:	60a2                	ld	ra,8(sp)
    80005f18:	6402                	ld	s0,0(sp)
    80005f1a:	0141                	addi	sp,sp,16
    80005f1c:	8082                	ret

0000000080005f1e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005f1e:	7179                	addi	sp,sp,-48
    80005f20:	f406                	sd	ra,40(sp)
    80005f22:	f022                	sd	s0,32(sp)
    80005f24:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005f26:	c219                	beqz	a2,80005f2c <printint+0xe>
    80005f28:	08054963          	bltz	a0,80005fba <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005f2c:	2501                	sext.w	a0,a0
    80005f2e:	4881                	li	a7,0
    80005f30:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005f34:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005f36:	2581                	sext.w	a1,a1
    80005f38:	00003617          	auipc	a2,0x3
    80005f3c:	9a860613          	addi	a2,a2,-1624 # 800088e0 <digits>
    80005f40:	883a                	mv	a6,a4
    80005f42:	2705                	addiw	a4,a4,1
    80005f44:	02b577bb          	remuw	a5,a0,a1
    80005f48:	1782                	slli	a5,a5,0x20
    80005f4a:	9381                	srli	a5,a5,0x20
    80005f4c:	97b2                	add	a5,a5,a2
    80005f4e:	0007c783          	lbu	a5,0(a5)
    80005f52:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005f56:	0005079b          	sext.w	a5,a0
    80005f5a:	02b5553b          	divuw	a0,a0,a1
    80005f5e:	0685                	addi	a3,a3,1
    80005f60:	feb7f0e3          	bgeu	a5,a1,80005f40 <printint+0x22>

  if(sign)
    80005f64:	00088c63          	beqz	a7,80005f7c <printint+0x5e>
    buf[i++] = '-';
    80005f68:	fe070793          	addi	a5,a4,-32
    80005f6c:	00878733          	add	a4,a5,s0
    80005f70:	02d00793          	li	a5,45
    80005f74:	fef70823          	sb	a5,-16(a4)
    80005f78:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005f7c:	02e05b63          	blez	a4,80005fb2 <printint+0x94>
    80005f80:	ec26                	sd	s1,24(sp)
    80005f82:	e84a                	sd	s2,16(sp)
    80005f84:	fd040793          	addi	a5,s0,-48
    80005f88:	00e784b3          	add	s1,a5,a4
    80005f8c:	fff78913          	addi	s2,a5,-1
    80005f90:	993a                	add	s2,s2,a4
    80005f92:	377d                	addiw	a4,a4,-1
    80005f94:	1702                	slli	a4,a4,0x20
    80005f96:	9301                	srli	a4,a4,0x20
    80005f98:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005f9c:	fff4c503          	lbu	a0,-1(s1)
    80005fa0:	00000097          	auipc	ra,0x0
    80005fa4:	d56080e7          	jalr	-682(ra) # 80005cf6 <consputc>
  while(--i >= 0)
    80005fa8:	14fd                	addi	s1,s1,-1
    80005faa:	ff2499e3          	bne	s1,s2,80005f9c <printint+0x7e>
    80005fae:	64e2                	ld	s1,24(sp)
    80005fb0:	6942                	ld	s2,16(sp)
}
    80005fb2:	70a2                	ld	ra,40(sp)
    80005fb4:	7402                	ld	s0,32(sp)
    80005fb6:	6145                	addi	sp,sp,48
    80005fb8:	8082                	ret
    x = -xx;
    80005fba:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005fbe:	4885                	li	a7,1
    x = -xx;
    80005fc0:	bf85                	j	80005f30 <printint+0x12>

0000000080005fc2 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005fc2:	1101                	addi	sp,sp,-32
    80005fc4:	ec06                	sd	ra,24(sp)
    80005fc6:	e822                	sd	s0,16(sp)
    80005fc8:	e426                	sd	s1,8(sp)
    80005fca:	1000                	addi	s0,sp,32
    80005fcc:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005fce:	0001f797          	auipc	a5,0x1f
    80005fd2:	9807a923          	sw	zero,-1646(a5) # 80024960 <pr+0x18>
  printf("panic: ");
    80005fd6:	00002517          	auipc	a0,0x2
    80005fda:	76a50513          	addi	a0,a0,1898 # 80008740 <etext+0x740>
    80005fde:	00000097          	auipc	ra,0x0
    80005fe2:	02e080e7          	jalr	46(ra) # 8000600c <printf>
  printf(s);
    80005fe6:	8526                	mv	a0,s1
    80005fe8:	00000097          	auipc	ra,0x0
    80005fec:	024080e7          	jalr	36(ra) # 8000600c <printf>
  printf("\n");
    80005ff0:	00002517          	auipc	a0,0x2
    80005ff4:	02850513          	addi	a0,a0,40 # 80008018 <etext+0x18>
    80005ff8:	00000097          	auipc	ra,0x0
    80005ffc:	014080e7          	jalr	20(ra) # 8000600c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006000:	4785                	li	a5,1
    80006002:	00005717          	auipc	a4,0x5
    80006006:	30f72d23          	sw	a5,794(a4) # 8000b31c <panicked>
  for(;;)
    8000600a:	a001                	j	8000600a <panic+0x48>

000000008000600c <printf>:
{
    8000600c:	7131                	addi	sp,sp,-192
    8000600e:	fc86                	sd	ra,120(sp)
    80006010:	f8a2                	sd	s0,112(sp)
    80006012:	e8d2                	sd	s4,80(sp)
    80006014:	f06a                	sd	s10,32(sp)
    80006016:	0100                	addi	s0,sp,128
    80006018:	8a2a                	mv	s4,a0
    8000601a:	e40c                	sd	a1,8(s0)
    8000601c:	e810                	sd	a2,16(s0)
    8000601e:	ec14                	sd	a3,24(s0)
    80006020:	f018                	sd	a4,32(s0)
    80006022:	f41c                	sd	a5,40(s0)
    80006024:	03043823          	sd	a6,48(s0)
    80006028:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    8000602c:	0001fd17          	auipc	s10,0x1f
    80006030:	934d2d03          	lw	s10,-1740(s10) # 80024960 <pr+0x18>
  if(locking)
    80006034:	040d1463          	bnez	s10,8000607c <printf+0x70>
  if (fmt == 0)
    80006038:	040a0b63          	beqz	s4,8000608e <printf+0x82>
  va_start(ap, fmt);
    8000603c:	00840793          	addi	a5,s0,8
    80006040:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006044:	000a4503          	lbu	a0,0(s4)
    80006048:	18050b63          	beqz	a0,800061de <printf+0x1d2>
    8000604c:	f4a6                	sd	s1,104(sp)
    8000604e:	f0ca                	sd	s2,96(sp)
    80006050:	ecce                	sd	s3,88(sp)
    80006052:	e4d6                	sd	s5,72(sp)
    80006054:	e0da                	sd	s6,64(sp)
    80006056:	fc5e                	sd	s7,56(sp)
    80006058:	f862                	sd	s8,48(sp)
    8000605a:	f466                	sd	s9,40(sp)
    8000605c:	ec6e                	sd	s11,24(sp)
    8000605e:	4981                	li	s3,0
    if(c != '%'){
    80006060:	02500b13          	li	s6,37
    switch(c){
    80006064:	07000b93          	li	s7,112
  consputc('x');
    80006068:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000606a:	00003a97          	auipc	s5,0x3
    8000606e:	876a8a93          	addi	s5,s5,-1930 # 800088e0 <digits>
    switch(c){
    80006072:	07300c13          	li	s8,115
    80006076:	06400d93          	li	s11,100
    8000607a:	a0b1                	j	800060c6 <printf+0xba>
    acquire(&pr.lock);
    8000607c:	0001f517          	auipc	a0,0x1f
    80006080:	8cc50513          	addi	a0,a0,-1844 # 80024948 <pr>
    80006084:	00000097          	auipc	ra,0x0
    80006088:	4b8080e7          	jalr	1208(ra) # 8000653c <acquire>
    8000608c:	b775                	j	80006038 <printf+0x2c>
    8000608e:	f4a6                	sd	s1,104(sp)
    80006090:	f0ca                	sd	s2,96(sp)
    80006092:	ecce                	sd	s3,88(sp)
    80006094:	e4d6                	sd	s5,72(sp)
    80006096:	e0da                	sd	s6,64(sp)
    80006098:	fc5e                	sd	s7,56(sp)
    8000609a:	f862                	sd	s8,48(sp)
    8000609c:	f466                	sd	s9,40(sp)
    8000609e:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    800060a0:	00002517          	auipc	a0,0x2
    800060a4:	6b050513          	addi	a0,a0,1712 # 80008750 <etext+0x750>
    800060a8:	00000097          	auipc	ra,0x0
    800060ac:	f1a080e7          	jalr	-230(ra) # 80005fc2 <panic>
      consputc(c);
    800060b0:	00000097          	auipc	ra,0x0
    800060b4:	c46080e7          	jalr	-954(ra) # 80005cf6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800060b8:	2985                	addiw	s3,s3,1
    800060ba:	013a07b3          	add	a5,s4,s3
    800060be:	0007c503          	lbu	a0,0(a5)
    800060c2:	10050563          	beqz	a0,800061cc <printf+0x1c0>
    if(c != '%'){
    800060c6:	ff6515e3          	bne	a0,s6,800060b0 <printf+0xa4>
    c = fmt[++i] & 0xff;
    800060ca:	2985                	addiw	s3,s3,1
    800060cc:	013a07b3          	add	a5,s4,s3
    800060d0:	0007c783          	lbu	a5,0(a5)
    800060d4:	0007849b          	sext.w	s1,a5
    if(c == 0)
    800060d8:	10078b63          	beqz	a5,800061ee <printf+0x1e2>
    switch(c){
    800060dc:	05778a63          	beq	a5,s7,80006130 <printf+0x124>
    800060e0:	02fbf663          	bgeu	s7,a5,8000610c <printf+0x100>
    800060e4:	09878863          	beq	a5,s8,80006174 <printf+0x168>
    800060e8:	07800713          	li	a4,120
    800060ec:	0ce79563          	bne	a5,a4,800061b6 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    800060f0:	f8843783          	ld	a5,-120(s0)
    800060f4:	00878713          	addi	a4,a5,8
    800060f8:	f8e43423          	sd	a4,-120(s0)
    800060fc:	4605                	li	a2,1
    800060fe:	85e6                	mv	a1,s9
    80006100:	4388                	lw	a0,0(a5)
    80006102:	00000097          	auipc	ra,0x0
    80006106:	e1c080e7          	jalr	-484(ra) # 80005f1e <printint>
      break;
    8000610a:	b77d                	j	800060b8 <printf+0xac>
    switch(c){
    8000610c:	09678f63          	beq	a5,s6,800061aa <printf+0x19e>
    80006110:	0bb79363          	bne	a5,s11,800061b6 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    80006114:	f8843783          	ld	a5,-120(s0)
    80006118:	00878713          	addi	a4,a5,8
    8000611c:	f8e43423          	sd	a4,-120(s0)
    80006120:	4605                	li	a2,1
    80006122:	45a9                	li	a1,10
    80006124:	4388                	lw	a0,0(a5)
    80006126:	00000097          	auipc	ra,0x0
    8000612a:	df8080e7          	jalr	-520(ra) # 80005f1e <printint>
      break;
    8000612e:	b769                	j	800060b8 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80006130:	f8843783          	ld	a5,-120(s0)
    80006134:	00878713          	addi	a4,a5,8
    80006138:	f8e43423          	sd	a4,-120(s0)
    8000613c:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80006140:	03000513          	li	a0,48
    80006144:	00000097          	auipc	ra,0x0
    80006148:	bb2080e7          	jalr	-1102(ra) # 80005cf6 <consputc>
  consputc('x');
    8000614c:	07800513          	li	a0,120
    80006150:	00000097          	auipc	ra,0x0
    80006154:	ba6080e7          	jalr	-1114(ra) # 80005cf6 <consputc>
    80006158:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000615a:	03c95793          	srli	a5,s2,0x3c
    8000615e:	97d6                	add	a5,a5,s5
    80006160:	0007c503          	lbu	a0,0(a5)
    80006164:	00000097          	auipc	ra,0x0
    80006168:	b92080e7          	jalr	-1134(ra) # 80005cf6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000616c:	0912                	slli	s2,s2,0x4
    8000616e:	34fd                	addiw	s1,s1,-1
    80006170:	f4ed                	bnez	s1,8000615a <printf+0x14e>
    80006172:	b799                	j	800060b8 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80006174:	f8843783          	ld	a5,-120(s0)
    80006178:	00878713          	addi	a4,a5,8
    8000617c:	f8e43423          	sd	a4,-120(s0)
    80006180:	6384                	ld	s1,0(a5)
    80006182:	cc89                	beqz	s1,8000619c <printf+0x190>
      for(; *s; s++)
    80006184:	0004c503          	lbu	a0,0(s1)
    80006188:	d905                	beqz	a0,800060b8 <printf+0xac>
        consputc(*s);
    8000618a:	00000097          	auipc	ra,0x0
    8000618e:	b6c080e7          	jalr	-1172(ra) # 80005cf6 <consputc>
      for(; *s; s++)
    80006192:	0485                	addi	s1,s1,1
    80006194:	0004c503          	lbu	a0,0(s1)
    80006198:	f96d                	bnez	a0,8000618a <printf+0x17e>
    8000619a:	bf39                	j	800060b8 <printf+0xac>
        s = "(null)";
    8000619c:	00002497          	auipc	s1,0x2
    800061a0:	5ac48493          	addi	s1,s1,1452 # 80008748 <etext+0x748>
      for(; *s; s++)
    800061a4:	02800513          	li	a0,40
    800061a8:	b7cd                	j	8000618a <printf+0x17e>
      consputc('%');
    800061aa:	855a                	mv	a0,s6
    800061ac:	00000097          	auipc	ra,0x0
    800061b0:	b4a080e7          	jalr	-1206(ra) # 80005cf6 <consputc>
      break;
    800061b4:	b711                	j	800060b8 <printf+0xac>
      consputc('%');
    800061b6:	855a                	mv	a0,s6
    800061b8:	00000097          	auipc	ra,0x0
    800061bc:	b3e080e7          	jalr	-1218(ra) # 80005cf6 <consputc>
      consputc(c);
    800061c0:	8526                	mv	a0,s1
    800061c2:	00000097          	auipc	ra,0x0
    800061c6:	b34080e7          	jalr	-1228(ra) # 80005cf6 <consputc>
      break;
    800061ca:	b5fd                	j	800060b8 <printf+0xac>
    800061cc:	74a6                	ld	s1,104(sp)
    800061ce:	7906                	ld	s2,96(sp)
    800061d0:	69e6                	ld	s3,88(sp)
    800061d2:	6aa6                	ld	s5,72(sp)
    800061d4:	6b06                	ld	s6,64(sp)
    800061d6:	7be2                	ld	s7,56(sp)
    800061d8:	7c42                	ld	s8,48(sp)
    800061da:	7ca2                	ld	s9,40(sp)
    800061dc:	6de2                	ld	s11,24(sp)
  if(locking)
    800061de:	020d1263          	bnez	s10,80006202 <printf+0x1f6>
}
    800061e2:	70e6                	ld	ra,120(sp)
    800061e4:	7446                	ld	s0,112(sp)
    800061e6:	6a46                	ld	s4,80(sp)
    800061e8:	7d02                	ld	s10,32(sp)
    800061ea:	6129                	addi	sp,sp,192
    800061ec:	8082                	ret
    800061ee:	74a6                	ld	s1,104(sp)
    800061f0:	7906                	ld	s2,96(sp)
    800061f2:	69e6                	ld	s3,88(sp)
    800061f4:	6aa6                	ld	s5,72(sp)
    800061f6:	6b06                	ld	s6,64(sp)
    800061f8:	7be2                	ld	s7,56(sp)
    800061fa:	7c42                	ld	s8,48(sp)
    800061fc:	7ca2                	ld	s9,40(sp)
    800061fe:	6de2                	ld	s11,24(sp)
    80006200:	bff9                	j	800061de <printf+0x1d2>
    release(&pr.lock);
    80006202:	0001e517          	auipc	a0,0x1e
    80006206:	74650513          	addi	a0,a0,1862 # 80024948 <pr>
    8000620a:	00000097          	auipc	ra,0x0
    8000620e:	3e6080e7          	jalr	998(ra) # 800065f0 <release>
}
    80006212:	bfc1                	j	800061e2 <printf+0x1d6>

0000000080006214 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006214:	1101                	addi	sp,sp,-32
    80006216:	ec06                	sd	ra,24(sp)
    80006218:	e822                	sd	s0,16(sp)
    8000621a:	e426                	sd	s1,8(sp)
    8000621c:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000621e:	0001e497          	auipc	s1,0x1e
    80006222:	72a48493          	addi	s1,s1,1834 # 80024948 <pr>
    80006226:	00002597          	auipc	a1,0x2
    8000622a:	53a58593          	addi	a1,a1,1338 # 80008760 <etext+0x760>
    8000622e:	8526                	mv	a0,s1
    80006230:	00000097          	auipc	ra,0x0
    80006234:	27c080e7          	jalr	636(ra) # 800064ac <initlock>
  pr.locking = 1;
    80006238:	4785                	li	a5,1
    8000623a:	cc9c                	sw	a5,24(s1)
}
    8000623c:	60e2                	ld	ra,24(sp)
    8000623e:	6442                	ld	s0,16(sp)
    80006240:	64a2                	ld	s1,8(sp)
    80006242:	6105                	addi	sp,sp,32
    80006244:	8082                	ret

0000000080006246 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006246:	1141                	addi	sp,sp,-16
    80006248:	e406                	sd	ra,8(sp)
    8000624a:	e022                	sd	s0,0(sp)
    8000624c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000624e:	100007b7          	lui	a5,0x10000
    80006252:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006256:	10000737          	lui	a4,0x10000
    8000625a:	f8000693          	li	a3,-128
    8000625e:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006262:	468d                	li	a3,3
    80006264:	10000637          	lui	a2,0x10000
    80006268:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000626c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006270:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006274:	10000737          	lui	a4,0x10000
    80006278:	461d                	li	a2,7
    8000627a:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000627e:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006282:	00002597          	auipc	a1,0x2
    80006286:	4e658593          	addi	a1,a1,1254 # 80008768 <etext+0x768>
    8000628a:	0001e517          	auipc	a0,0x1e
    8000628e:	6de50513          	addi	a0,a0,1758 # 80024968 <uart_tx_lock>
    80006292:	00000097          	auipc	ra,0x0
    80006296:	21a080e7          	jalr	538(ra) # 800064ac <initlock>
}
    8000629a:	60a2                	ld	ra,8(sp)
    8000629c:	6402                	ld	s0,0(sp)
    8000629e:	0141                	addi	sp,sp,16
    800062a0:	8082                	ret

00000000800062a2 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800062a2:	1101                	addi	sp,sp,-32
    800062a4:	ec06                	sd	ra,24(sp)
    800062a6:	e822                	sd	s0,16(sp)
    800062a8:	e426                	sd	s1,8(sp)
    800062aa:	1000                	addi	s0,sp,32
    800062ac:	84aa                	mv	s1,a0
  push_off();
    800062ae:	00000097          	auipc	ra,0x0
    800062b2:	242080e7          	jalr	578(ra) # 800064f0 <push_off>

  if(panicked){
    800062b6:	00005797          	auipc	a5,0x5
    800062ba:	0667a783          	lw	a5,102(a5) # 8000b31c <panicked>
    800062be:	eb85                	bnez	a5,800062ee <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800062c0:	10000737          	lui	a4,0x10000
    800062c4:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800062c6:	00074783          	lbu	a5,0(a4)
    800062ca:	0207f793          	andi	a5,a5,32
    800062ce:	dfe5                	beqz	a5,800062c6 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800062d0:	0ff4f513          	zext.b	a0,s1
    800062d4:	100007b7          	lui	a5,0x10000
    800062d8:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800062dc:	00000097          	auipc	ra,0x0
    800062e0:	2b4080e7          	jalr	692(ra) # 80006590 <pop_off>
}
    800062e4:	60e2                	ld	ra,24(sp)
    800062e6:	6442                	ld	s0,16(sp)
    800062e8:	64a2                	ld	s1,8(sp)
    800062ea:	6105                	addi	sp,sp,32
    800062ec:	8082                	ret
    for(;;)
    800062ee:	a001                	j	800062ee <uartputc_sync+0x4c>

00000000800062f0 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800062f0:	00005797          	auipc	a5,0x5
    800062f4:	0307b783          	ld	a5,48(a5) # 8000b320 <uart_tx_r>
    800062f8:	00005717          	auipc	a4,0x5
    800062fc:	03073703          	ld	a4,48(a4) # 8000b328 <uart_tx_w>
    80006300:	06f70f63          	beq	a4,a5,8000637e <uartstart+0x8e>
{
    80006304:	7139                	addi	sp,sp,-64
    80006306:	fc06                	sd	ra,56(sp)
    80006308:	f822                	sd	s0,48(sp)
    8000630a:	f426                	sd	s1,40(sp)
    8000630c:	f04a                	sd	s2,32(sp)
    8000630e:	ec4e                	sd	s3,24(sp)
    80006310:	e852                	sd	s4,16(sp)
    80006312:	e456                	sd	s5,8(sp)
    80006314:	e05a                	sd	s6,0(sp)
    80006316:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006318:	10000937          	lui	s2,0x10000
    8000631c:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000631e:	0001ea97          	auipc	s5,0x1e
    80006322:	64aa8a93          	addi	s5,s5,1610 # 80024968 <uart_tx_lock>
    uart_tx_r += 1;
    80006326:	00005497          	auipc	s1,0x5
    8000632a:	ffa48493          	addi	s1,s1,-6 # 8000b320 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    8000632e:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80006332:	00005997          	auipc	s3,0x5
    80006336:	ff698993          	addi	s3,s3,-10 # 8000b328 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000633a:	00094703          	lbu	a4,0(s2)
    8000633e:	02077713          	andi	a4,a4,32
    80006342:	c705                	beqz	a4,8000636a <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006344:	01f7f713          	andi	a4,a5,31
    80006348:	9756                	add	a4,a4,s5
    8000634a:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    8000634e:	0785                	addi	a5,a5,1
    80006350:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80006352:	8526                	mv	a0,s1
    80006354:	ffffb097          	auipc	ra,0xffffb
    80006358:	42e080e7          	jalr	1070(ra) # 80001782 <wakeup>
    WriteReg(THR, c);
    8000635c:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80006360:	609c                	ld	a5,0(s1)
    80006362:	0009b703          	ld	a4,0(s3)
    80006366:	fcf71ae3          	bne	a4,a5,8000633a <uartstart+0x4a>
  }
}
    8000636a:	70e2                	ld	ra,56(sp)
    8000636c:	7442                	ld	s0,48(sp)
    8000636e:	74a2                	ld	s1,40(sp)
    80006370:	7902                	ld	s2,32(sp)
    80006372:	69e2                	ld	s3,24(sp)
    80006374:	6a42                	ld	s4,16(sp)
    80006376:	6aa2                	ld	s5,8(sp)
    80006378:	6b02                	ld	s6,0(sp)
    8000637a:	6121                	addi	sp,sp,64
    8000637c:	8082                	ret
    8000637e:	8082                	ret

0000000080006380 <uartputc>:
{
    80006380:	7179                	addi	sp,sp,-48
    80006382:	f406                	sd	ra,40(sp)
    80006384:	f022                	sd	s0,32(sp)
    80006386:	ec26                	sd	s1,24(sp)
    80006388:	e84a                	sd	s2,16(sp)
    8000638a:	e44e                	sd	s3,8(sp)
    8000638c:	e052                	sd	s4,0(sp)
    8000638e:	1800                	addi	s0,sp,48
    80006390:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006392:	0001e517          	auipc	a0,0x1e
    80006396:	5d650513          	addi	a0,a0,1494 # 80024968 <uart_tx_lock>
    8000639a:	00000097          	auipc	ra,0x0
    8000639e:	1a2080e7          	jalr	418(ra) # 8000653c <acquire>
  if(panicked){
    800063a2:	00005797          	auipc	a5,0x5
    800063a6:	f7a7a783          	lw	a5,-134(a5) # 8000b31c <panicked>
    800063aa:	e7c9                	bnez	a5,80006434 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063ac:	00005717          	auipc	a4,0x5
    800063b0:	f7c73703          	ld	a4,-132(a4) # 8000b328 <uart_tx_w>
    800063b4:	00005797          	auipc	a5,0x5
    800063b8:	f6c7b783          	ld	a5,-148(a5) # 8000b320 <uart_tx_r>
    800063bc:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800063c0:	0001e997          	auipc	s3,0x1e
    800063c4:	5a898993          	addi	s3,s3,1448 # 80024968 <uart_tx_lock>
    800063c8:	00005497          	auipc	s1,0x5
    800063cc:	f5848493          	addi	s1,s1,-168 # 8000b320 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063d0:	00005917          	auipc	s2,0x5
    800063d4:	f5890913          	addi	s2,s2,-168 # 8000b328 <uart_tx_w>
    800063d8:	00e79f63          	bne	a5,a4,800063f6 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800063dc:	85ce                	mv	a1,s3
    800063de:	8526                	mv	a0,s1
    800063e0:	ffffb097          	auipc	ra,0xffffb
    800063e4:	33e080e7          	jalr	830(ra) # 8000171e <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063e8:	00093703          	ld	a4,0(s2)
    800063ec:	609c                	ld	a5,0(s1)
    800063ee:	02078793          	addi	a5,a5,32
    800063f2:	fee785e3          	beq	a5,a4,800063dc <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800063f6:	0001e497          	auipc	s1,0x1e
    800063fa:	57248493          	addi	s1,s1,1394 # 80024968 <uart_tx_lock>
    800063fe:	01f77793          	andi	a5,a4,31
    80006402:	97a6                	add	a5,a5,s1
    80006404:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006408:	0705                	addi	a4,a4,1
    8000640a:	00005797          	auipc	a5,0x5
    8000640e:	f0e7bf23          	sd	a4,-226(a5) # 8000b328 <uart_tx_w>
  uartstart();
    80006412:	00000097          	auipc	ra,0x0
    80006416:	ede080e7          	jalr	-290(ra) # 800062f0 <uartstart>
  release(&uart_tx_lock);
    8000641a:	8526                	mv	a0,s1
    8000641c:	00000097          	auipc	ra,0x0
    80006420:	1d4080e7          	jalr	468(ra) # 800065f0 <release>
}
    80006424:	70a2                	ld	ra,40(sp)
    80006426:	7402                	ld	s0,32(sp)
    80006428:	64e2                	ld	s1,24(sp)
    8000642a:	6942                	ld	s2,16(sp)
    8000642c:	69a2                	ld	s3,8(sp)
    8000642e:	6a02                	ld	s4,0(sp)
    80006430:	6145                	addi	sp,sp,48
    80006432:	8082                	ret
    for(;;)
    80006434:	a001                	j	80006434 <uartputc+0xb4>

0000000080006436 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006436:	1141                	addi	sp,sp,-16
    80006438:	e422                	sd	s0,8(sp)
    8000643a:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000643c:	100007b7          	lui	a5,0x10000
    80006440:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80006442:	0007c783          	lbu	a5,0(a5)
    80006446:	8b85                	andi	a5,a5,1
    80006448:	cb81                	beqz	a5,80006458 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    8000644a:	100007b7          	lui	a5,0x10000
    8000644e:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006452:	6422                	ld	s0,8(sp)
    80006454:	0141                	addi	sp,sp,16
    80006456:	8082                	ret
    return -1;
    80006458:	557d                	li	a0,-1
    8000645a:	bfe5                	j	80006452 <uartgetc+0x1c>

000000008000645c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000645c:	1101                	addi	sp,sp,-32
    8000645e:	ec06                	sd	ra,24(sp)
    80006460:	e822                	sd	s0,16(sp)
    80006462:	e426                	sd	s1,8(sp)
    80006464:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006466:	54fd                	li	s1,-1
    80006468:	a029                	j	80006472 <uartintr+0x16>
      break;
    consoleintr(c);
    8000646a:	00000097          	auipc	ra,0x0
    8000646e:	8ce080e7          	jalr	-1842(ra) # 80005d38 <consoleintr>
    int c = uartgetc();
    80006472:	00000097          	auipc	ra,0x0
    80006476:	fc4080e7          	jalr	-60(ra) # 80006436 <uartgetc>
    if(c == -1)
    8000647a:	fe9518e3          	bne	a0,s1,8000646a <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000647e:	0001e497          	auipc	s1,0x1e
    80006482:	4ea48493          	addi	s1,s1,1258 # 80024968 <uart_tx_lock>
    80006486:	8526                	mv	a0,s1
    80006488:	00000097          	auipc	ra,0x0
    8000648c:	0b4080e7          	jalr	180(ra) # 8000653c <acquire>
  uartstart();
    80006490:	00000097          	auipc	ra,0x0
    80006494:	e60080e7          	jalr	-416(ra) # 800062f0 <uartstart>
  release(&uart_tx_lock);
    80006498:	8526                	mv	a0,s1
    8000649a:	00000097          	auipc	ra,0x0
    8000649e:	156080e7          	jalr	342(ra) # 800065f0 <release>
}
    800064a2:	60e2                	ld	ra,24(sp)
    800064a4:	6442                	ld	s0,16(sp)
    800064a6:	64a2                	ld	s1,8(sp)
    800064a8:	6105                	addi	sp,sp,32
    800064aa:	8082                	ret

00000000800064ac <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800064ac:	1141                	addi	sp,sp,-16
    800064ae:	e422                	sd	s0,8(sp)
    800064b0:	0800                	addi	s0,sp,16
  lk->name = name;
    800064b2:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800064b4:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800064b8:	00053823          	sd	zero,16(a0)
}
    800064bc:	6422                	ld	s0,8(sp)
    800064be:	0141                	addi	sp,sp,16
    800064c0:	8082                	ret

00000000800064c2 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800064c2:	411c                	lw	a5,0(a0)
    800064c4:	e399                	bnez	a5,800064ca <holding+0x8>
    800064c6:	4501                	li	a0,0
  return r;
}
    800064c8:	8082                	ret
{
    800064ca:	1101                	addi	sp,sp,-32
    800064cc:	ec06                	sd	ra,24(sp)
    800064ce:	e822                	sd	s0,16(sp)
    800064d0:	e426                	sd	s1,8(sp)
    800064d2:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800064d4:	6904                	ld	s1,16(a0)
    800064d6:	ffffb097          	auipc	ra,0xffffb
    800064da:	af8080e7          	jalr	-1288(ra) # 80000fce <mycpu>
    800064de:	40a48533          	sub	a0,s1,a0
    800064e2:	00153513          	seqz	a0,a0
}
    800064e6:	60e2                	ld	ra,24(sp)
    800064e8:	6442                	ld	s0,16(sp)
    800064ea:	64a2                	ld	s1,8(sp)
    800064ec:	6105                	addi	sp,sp,32
    800064ee:	8082                	ret

00000000800064f0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800064f0:	1101                	addi	sp,sp,-32
    800064f2:	ec06                	sd	ra,24(sp)
    800064f4:	e822                	sd	s0,16(sp)
    800064f6:	e426                	sd	s1,8(sp)
    800064f8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800064fa:	100024f3          	csrr	s1,sstatus
    800064fe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006502:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006504:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006508:	ffffb097          	auipc	ra,0xffffb
    8000650c:	ac6080e7          	jalr	-1338(ra) # 80000fce <mycpu>
    80006510:	5d3c                	lw	a5,120(a0)
    80006512:	cf89                	beqz	a5,8000652c <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006514:	ffffb097          	auipc	ra,0xffffb
    80006518:	aba080e7          	jalr	-1350(ra) # 80000fce <mycpu>
    8000651c:	5d3c                	lw	a5,120(a0)
    8000651e:	2785                	addiw	a5,a5,1
    80006520:	dd3c                	sw	a5,120(a0)
}
    80006522:	60e2                	ld	ra,24(sp)
    80006524:	6442                	ld	s0,16(sp)
    80006526:	64a2                	ld	s1,8(sp)
    80006528:	6105                	addi	sp,sp,32
    8000652a:	8082                	ret
    mycpu()->intena = old;
    8000652c:	ffffb097          	auipc	ra,0xffffb
    80006530:	aa2080e7          	jalr	-1374(ra) # 80000fce <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006534:	8085                	srli	s1,s1,0x1
    80006536:	8885                	andi	s1,s1,1
    80006538:	dd64                	sw	s1,124(a0)
    8000653a:	bfe9                	j	80006514 <push_off+0x24>

000000008000653c <acquire>:
{
    8000653c:	1101                	addi	sp,sp,-32
    8000653e:	ec06                	sd	ra,24(sp)
    80006540:	e822                	sd	s0,16(sp)
    80006542:	e426                	sd	s1,8(sp)
    80006544:	1000                	addi	s0,sp,32
    80006546:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006548:	00000097          	auipc	ra,0x0
    8000654c:	fa8080e7          	jalr	-88(ra) # 800064f0 <push_off>
  if(holding(lk))
    80006550:	8526                	mv	a0,s1
    80006552:	00000097          	auipc	ra,0x0
    80006556:	f70080e7          	jalr	-144(ra) # 800064c2 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000655a:	4705                	li	a4,1
  if(holding(lk))
    8000655c:	e115                	bnez	a0,80006580 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000655e:	87ba                	mv	a5,a4
    80006560:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006564:	2781                	sext.w	a5,a5
    80006566:	ffe5                	bnez	a5,8000655e <acquire+0x22>
  __sync_synchronize();
    80006568:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    8000656c:	ffffb097          	auipc	ra,0xffffb
    80006570:	a62080e7          	jalr	-1438(ra) # 80000fce <mycpu>
    80006574:	e888                	sd	a0,16(s1)
}
    80006576:	60e2                	ld	ra,24(sp)
    80006578:	6442                	ld	s0,16(sp)
    8000657a:	64a2                	ld	s1,8(sp)
    8000657c:	6105                	addi	sp,sp,32
    8000657e:	8082                	ret
    panic("acquire");
    80006580:	00002517          	auipc	a0,0x2
    80006584:	1f050513          	addi	a0,a0,496 # 80008770 <etext+0x770>
    80006588:	00000097          	auipc	ra,0x0
    8000658c:	a3a080e7          	jalr	-1478(ra) # 80005fc2 <panic>

0000000080006590 <pop_off>:

void
pop_off(void)
{
    80006590:	1141                	addi	sp,sp,-16
    80006592:	e406                	sd	ra,8(sp)
    80006594:	e022                	sd	s0,0(sp)
    80006596:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006598:	ffffb097          	auipc	ra,0xffffb
    8000659c:	a36080e7          	jalr	-1482(ra) # 80000fce <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800065a0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800065a4:	8b89                	andi	a5,a5,2
  if(intr_get())
    800065a6:	e78d                	bnez	a5,800065d0 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800065a8:	5d3c                	lw	a5,120(a0)
    800065aa:	02f05b63          	blez	a5,800065e0 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800065ae:	37fd                	addiw	a5,a5,-1
    800065b0:	0007871b          	sext.w	a4,a5
    800065b4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800065b6:	eb09                	bnez	a4,800065c8 <pop_off+0x38>
    800065b8:	5d7c                	lw	a5,124(a0)
    800065ba:	c799                	beqz	a5,800065c8 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800065bc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800065c0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800065c4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800065c8:	60a2                	ld	ra,8(sp)
    800065ca:	6402                	ld	s0,0(sp)
    800065cc:	0141                	addi	sp,sp,16
    800065ce:	8082                	ret
    panic("pop_off - interruptible");
    800065d0:	00002517          	auipc	a0,0x2
    800065d4:	1a850513          	addi	a0,a0,424 # 80008778 <etext+0x778>
    800065d8:	00000097          	auipc	ra,0x0
    800065dc:	9ea080e7          	jalr	-1558(ra) # 80005fc2 <panic>
    panic("pop_off");
    800065e0:	00002517          	auipc	a0,0x2
    800065e4:	1b050513          	addi	a0,a0,432 # 80008790 <etext+0x790>
    800065e8:	00000097          	auipc	ra,0x0
    800065ec:	9da080e7          	jalr	-1574(ra) # 80005fc2 <panic>

00000000800065f0 <release>:
{
    800065f0:	1101                	addi	sp,sp,-32
    800065f2:	ec06                	sd	ra,24(sp)
    800065f4:	e822                	sd	s0,16(sp)
    800065f6:	e426                	sd	s1,8(sp)
    800065f8:	1000                	addi	s0,sp,32
    800065fa:	84aa                	mv	s1,a0
  if(!holding(lk))
    800065fc:	00000097          	auipc	ra,0x0
    80006600:	ec6080e7          	jalr	-314(ra) # 800064c2 <holding>
    80006604:	c115                	beqz	a0,80006628 <release+0x38>
  lk->cpu = 0;
    80006606:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000660a:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    8000660e:	0310000f          	fence	rw,w
    80006612:	0004a023          	sw	zero,0(s1)
  pop_off();
    80006616:	00000097          	auipc	ra,0x0
    8000661a:	f7a080e7          	jalr	-134(ra) # 80006590 <pop_off>
}
    8000661e:	60e2                	ld	ra,24(sp)
    80006620:	6442                	ld	s0,16(sp)
    80006622:	64a2                	ld	s1,8(sp)
    80006624:	6105                	addi	sp,sp,32
    80006626:	8082                	ret
    panic("release");
    80006628:	00002517          	auipc	a0,0x2
    8000662c:	17050513          	addi	a0,a0,368 # 80008798 <etext+0x798>
    80006630:	00000097          	auipc	ra,0x0
    80006634:	992080e7          	jalr	-1646(ra) # 80005fc2 <panic>
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
