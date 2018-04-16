
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 0c             	sub    $0xc,%esp
  13:	89 cb                	mov    %ecx,%ebx
  //int i;

  if(argc < 2){
  15:	83 3b 01             	cmpl   $0x1,(%ebx)
  18:	7f 17                	jg     31 <main+0x31>
    printf(2, "usage: kill pid...\n");
  1a:	83 ec 08             	sub    $0x8,%esp
  1d:	68 09 08 00 00       	push   $0x809
  22:	6a 02                	push   $0x2
  24:	e8 2a 04 00 00       	call   453 <printf>
  29:	83 c4 10             	add    $0x10,%esp
    exit();
  2c:	e8 93 02 00 00       	call   2c4 <exit>
  }
  //for(i=1; i<argc; i++)
    kill(atoi(argv[1]),atoi(argv[2]));
  31:	8b 43 04             	mov    0x4(%ebx),%eax
  34:	83 c0 08             	add    $0x8,%eax
  37:	8b 00                	mov    (%eax),%eax
  39:	83 ec 0c             	sub    $0xc,%esp
  3c:	50                   	push   %eax
  3d:	e8 f0 01 00 00       	call   232 <atoi>
  42:	83 c4 10             	add    $0x10,%esp
  45:	89 c6                	mov    %eax,%esi
  47:	8b 43 04             	mov    0x4(%ebx),%eax
  4a:	83 c0 04             	add    $0x4,%eax
  4d:	8b 00                	mov    (%eax),%eax
  4f:	83 ec 0c             	sub    $0xc,%esp
  52:	50                   	push   %eax
  53:	e8 da 01 00 00       	call   232 <atoi>
  58:	83 c4 10             	add    $0x10,%esp
  5b:	83 ec 08             	sub    $0x8,%esp
  5e:	56                   	push   %esi
  5f:	50                   	push   %eax
  60:	e8 8f 02 00 00       	call   2f4 <kill>
  65:	83 c4 10             	add    $0x10,%esp
  exit();
  68:	e8 57 02 00 00       	call   2c4 <exit>

0000006d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  6d:	55                   	push   %ebp
  6e:	89 e5                	mov    %esp,%ebp
  70:	57                   	push   %edi
  71:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  72:	8b 4d 08             	mov    0x8(%ebp),%ecx
  75:	8b 55 10             	mov    0x10(%ebp),%edx
  78:	8b 45 0c             	mov    0xc(%ebp),%eax
  7b:	89 cb                	mov    %ecx,%ebx
  7d:	89 df                	mov    %ebx,%edi
  7f:	89 d1                	mov    %edx,%ecx
  81:	fc                   	cld    
  82:	f3 aa                	rep stos %al,%es:(%edi)
  84:	89 ca                	mov    %ecx,%edx
  86:	89 fb                	mov    %edi,%ebx
  88:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  8e:	90                   	nop
  8f:	5b                   	pop    %ebx
  90:	5f                   	pop    %edi
  91:	5d                   	pop    %ebp
  92:	c3                   	ret    

00000093 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  93:	55                   	push   %ebp
  94:	89 e5                	mov    %esp,%ebp
  96:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  9f:	90                   	nop
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	8d 50 01             	lea    0x1(%eax),%edx
  a6:	89 55 08             	mov    %edx,0x8(%ebp)
  a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  ac:	8d 4a 01             	lea    0x1(%edx),%ecx
  af:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b2:	0f b6 12             	movzbl (%edx),%edx
  b5:	88 10                	mov    %dl,(%eax)
  b7:	0f b6 00             	movzbl (%eax),%eax
  ba:	84 c0                	test   %al,%al
  bc:	75 e2                	jne    a0 <strcpy+0xd>
    ;
  return os;
  be:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c1:	c9                   	leave  
  c2:	c3                   	ret    

000000c3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c3:	55                   	push   %ebp
  c4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c6:	eb 08                	jmp    d0 <strcmp+0xd>
    p++, q++;
  c8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  cc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d0:	8b 45 08             	mov    0x8(%ebp),%eax
  d3:	0f b6 00             	movzbl (%eax),%eax
  d6:	84 c0                	test   %al,%al
  d8:	74 10                	je     ea <strcmp+0x27>
  da:	8b 45 08             	mov    0x8(%ebp),%eax
  dd:	0f b6 10             	movzbl (%eax),%edx
  e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  e3:	0f b6 00             	movzbl (%eax),%eax
  e6:	38 c2                	cmp    %al,%dl
  e8:	74 de                	je     c8 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  ea:	8b 45 08             	mov    0x8(%ebp),%eax
  ed:	0f b6 00             	movzbl (%eax),%eax
  f0:	0f b6 d0             	movzbl %al,%edx
  f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  f6:	0f b6 00             	movzbl (%eax),%eax
  f9:	0f b6 c0             	movzbl %al,%eax
  fc:	29 c2                	sub    %eax,%edx
  fe:	89 d0                	mov    %edx,%eax
}
 100:	5d                   	pop    %ebp
 101:	c3                   	ret    

00000102 <strlen>:

uint
strlen(char *s)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 108:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 10f:	eb 04                	jmp    115 <strlen+0x13>
 111:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 115:	8b 55 fc             	mov    -0x4(%ebp),%edx
 118:	8b 45 08             	mov    0x8(%ebp),%eax
 11b:	01 d0                	add    %edx,%eax
 11d:	0f b6 00             	movzbl (%eax),%eax
 120:	84 c0                	test   %al,%al
 122:	75 ed                	jne    111 <strlen+0xf>
    ;
  return n;
 124:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 127:	c9                   	leave  
 128:	c3                   	ret    

00000129 <memset>:

void*
memset(void *dst, int c, uint n)
{
 129:	55                   	push   %ebp
 12a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 12c:	8b 45 10             	mov    0x10(%ebp),%eax
 12f:	50                   	push   %eax
 130:	ff 75 0c             	pushl  0xc(%ebp)
 133:	ff 75 08             	pushl  0x8(%ebp)
 136:	e8 32 ff ff ff       	call   6d <stosb>
 13b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 13e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 141:	c9                   	leave  
 142:	c3                   	ret    

00000143 <strchr>:

char*
strchr(const char *s, char c)
{
 143:	55                   	push   %ebp
 144:	89 e5                	mov    %esp,%ebp
 146:	83 ec 04             	sub    $0x4,%esp
 149:	8b 45 0c             	mov    0xc(%ebp),%eax
 14c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 14f:	eb 14                	jmp    165 <strchr+0x22>
    if(*s == c)
 151:	8b 45 08             	mov    0x8(%ebp),%eax
 154:	0f b6 00             	movzbl (%eax),%eax
 157:	3a 45 fc             	cmp    -0x4(%ebp),%al
 15a:	75 05                	jne    161 <strchr+0x1e>
      return (char*)s;
 15c:	8b 45 08             	mov    0x8(%ebp),%eax
 15f:	eb 13                	jmp    174 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 161:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 165:	8b 45 08             	mov    0x8(%ebp),%eax
 168:	0f b6 00             	movzbl (%eax),%eax
 16b:	84 c0                	test   %al,%al
 16d:	75 e2                	jne    151 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 16f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 174:	c9                   	leave  
 175:	c3                   	ret    

00000176 <gets>:

char*
gets(char *buf, int max)
{
 176:	55                   	push   %ebp
 177:	89 e5                	mov    %esp,%ebp
 179:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 183:	eb 42                	jmp    1c7 <gets+0x51>
    cc = read(0, &c, 1);
 185:	83 ec 04             	sub    $0x4,%esp
 188:	6a 01                	push   $0x1
 18a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 18d:	50                   	push   %eax
 18e:	6a 00                	push   $0x0
 190:	e8 47 01 00 00       	call   2dc <read>
 195:	83 c4 10             	add    $0x10,%esp
 198:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 19b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 19f:	7e 33                	jle    1d4 <gets+0x5e>
      break;
    buf[i++] = c;
 1a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a4:	8d 50 01             	lea    0x1(%eax),%edx
 1a7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1aa:	89 c2                	mov    %eax,%edx
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
 1af:	01 c2                	add    %eax,%edx
 1b1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b5:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bb:	3c 0a                	cmp    $0xa,%al
 1bd:	74 16                	je     1d5 <gets+0x5f>
 1bf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c3:	3c 0d                	cmp    $0xd,%al
 1c5:	74 0e                	je     1d5 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ca:	83 c0 01             	add    $0x1,%eax
 1cd:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d0:	7c b3                	jl     185 <gets+0xf>
 1d2:	eb 01                	jmp    1d5 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1d4:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
 1db:	01 d0                	add    %edx,%eax
 1dd:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e3:	c9                   	leave  
 1e4:	c3                   	ret    

000001e5 <stat>:

int
stat(char *n, struct stat *st)
{
 1e5:	55                   	push   %ebp
 1e6:	89 e5                	mov    %esp,%ebp
 1e8:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1eb:	83 ec 08             	sub    $0x8,%esp
 1ee:	6a 00                	push   $0x0
 1f0:	ff 75 08             	pushl  0x8(%ebp)
 1f3:	e8 0c 01 00 00       	call   304 <open>
 1f8:	83 c4 10             	add    $0x10,%esp
 1fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 202:	79 07                	jns    20b <stat+0x26>
    return -1;
 204:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 209:	eb 25                	jmp    230 <stat+0x4b>
  r = fstat(fd, st);
 20b:	83 ec 08             	sub    $0x8,%esp
 20e:	ff 75 0c             	pushl  0xc(%ebp)
 211:	ff 75 f4             	pushl  -0xc(%ebp)
 214:	e8 03 01 00 00       	call   31c <fstat>
 219:	83 c4 10             	add    $0x10,%esp
 21c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 21f:	83 ec 0c             	sub    $0xc,%esp
 222:	ff 75 f4             	pushl  -0xc(%ebp)
 225:	e8 c2 00 00 00       	call   2ec <close>
 22a:	83 c4 10             	add    $0x10,%esp
  return r;
 22d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 230:	c9                   	leave  
 231:	c3                   	ret    

00000232 <atoi>:

int
atoi(const char *s)
{
 232:	55                   	push   %ebp
 233:	89 e5                	mov    %esp,%ebp
 235:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 238:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 23f:	eb 25                	jmp    266 <atoi+0x34>
    n = n*10 + *s++ - '0';
 241:	8b 55 fc             	mov    -0x4(%ebp),%edx
 244:	89 d0                	mov    %edx,%eax
 246:	c1 e0 02             	shl    $0x2,%eax
 249:	01 d0                	add    %edx,%eax
 24b:	01 c0                	add    %eax,%eax
 24d:	89 c1                	mov    %eax,%ecx
 24f:	8b 45 08             	mov    0x8(%ebp),%eax
 252:	8d 50 01             	lea    0x1(%eax),%edx
 255:	89 55 08             	mov    %edx,0x8(%ebp)
 258:	0f b6 00             	movzbl (%eax),%eax
 25b:	0f be c0             	movsbl %al,%eax
 25e:	01 c8                	add    %ecx,%eax
 260:	83 e8 30             	sub    $0x30,%eax
 263:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 266:	8b 45 08             	mov    0x8(%ebp),%eax
 269:	0f b6 00             	movzbl (%eax),%eax
 26c:	3c 2f                	cmp    $0x2f,%al
 26e:	7e 0a                	jle    27a <atoi+0x48>
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	0f b6 00             	movzbl (%eax),%eax
 276:	3c 39                	cmp    $0x39,%al
 278:	7e c7                	jle    241 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 27a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 27d:	c9                   	leave  
 27e:	c3                   	ret    

0000027f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 27f:	55                   	push   %ebp
 280:	89 e5                	mov    %esp,%ebp
 282:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 285:	8b 45 08             	mov    0x8(%ebp),%eax
 288:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 28b:	8b 45 0c             	mov    0xc(%ebp),%eax
 28e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 291:	eb 17                	jmp    2aa <memmove+0x2b>
    *dst++ = *src++;
 293:	8b 45 fc             	mov    -0x4(%ebp),%eax
 296:	8d 50 01             	lea    0x1(%eax),%edx
 299:	89 55 fc             	mov    %edx,-0x4(%ebp)
 29c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 29f:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2a5:	0f b6 12             	movzbl (%edx),%edx
 2a8:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2aa:	8b 45 10             	mov    0x10(%ebp),%eax
 2ad:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b0:	89 55 10             	mov    %edx,0x10(%ebp)
 2b3:	85 c0                	test   %eax,%eax
 2b5:	7f dc                	jg     293 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ba:	c9                   	leave  
 2bb:	c3                   	ret    

000002bc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2bc:	b8 01 00 00 00       	mov    $0x1,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <exit>:
SYSCALL(exit)
 2c4:	b8 02 00 00 00       	mov    $0x2,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <wait>:
SYSCALL(wait)
 2cc:	b8 03 00 00 00       	mov    $0x3,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <pipe>:
SYSCALL(pipe)
 2d4:	b8 04 00 00 00       	mov    $0x4,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <read>:
SYSCALL(read)
 2dc:	b8 05 00 00 00       	mov    $0x5,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <write>:
SYSCALL(write)
 2e4:	b8 10 00 00 00       	mov    $0x10,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <close>:
SYSCALL(close)
 2ec:	b8 15 00 00 00       	mov    $0x15,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <kill>:
SYSCALL(kill)
 2f4:	b8 06 00 00 00       	mov    $0x6,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <exec>:
SYSCALL(exec)
 2fc:	b8 07 00 00 00       	mov    $0x7,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <open>:
SYSCALL(open)
 304:	b8 0f 00 00 00       	mov    $0xf,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <mknod>:
SYSCALL(mknod)
 30c:	b8 11 00 00 00       	mov    $0x11,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <unlink>:
SYSCALL(unlink)
 314:	b8 12 00 00 00       	mov    $0x12,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <fstat>:
SYSCALL(fstat)
 31c:	b8 08 00 00 00       	mov    $0x8,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <link>:
SYSCALL(link)
 324:	b8 13 00 00 00       	mov    $0x13,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <mkdir>:
SYSCALL(mkdir)
 32c:	b8 14 00 00 00       	mov    $0x14,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <chdir>:
SYSCALL(chdir)
 334:	b8 09 00 00 00       	mov    $0x9,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <dup>:
SYSCALL(dup)
 33c:	b8 0a 00 00 00       	mov    $0xa,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <getpid>:
SYSCALL(getpid)
 344:	b8 0b 00 00 00       	mov    $0xb,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <sbrk>:
SYSCALL(sbrk)
 34c:	b8 0c 00 00 00       	mov    $0xc,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <sleep>:
SYSCALL(sleep)
 354:	b8 0d 00 00 00       	mov    $0xd,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <uptime>:
SYSCALL(uptime)
 35c:	b8 0e 00 00 00       	mov    $0xe,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <sigprocmask>:
SYSCALL(sigprocmask)
 364:	b8 16 00 00 00       	mov    $0x16,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <signal>:
SYSCALL(signal)
 36c:	b8 17 00 00 00       	mov    $0x17,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <sigret>:
SYSCALL(sigret)
 374:	b8 18 00 00 00       	mov    $0x18,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 37c:	55                   	push   %ebp
 37d:	89 e5                	mov    %esp,%ebp
 37f:	83 ec 18             	sub    $0x18,%esp
 382:	8b 45 0c             	mov    0xc(%ebp),%eax
 385:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 388:	83 ec 04             	sub    $0x4,%esp
 38b:	6a 01                	push   $0x1
 38d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 390:	50                   	push   %eax
 391:	ff 75 08             	pushl  0x8(%ebp)
 394:	e8 4b ff ff ff       	call   2e4 <write>
 399:	83 c4 10             	add    $0x10,%esp
}
 39c:	90                   	nop
 39d:	c9                   	leave  
 39e:	c3                   	ret    

0000039f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 39f:	55                   	push   %ebp
 3a0:	89 e5                	mov    %esp,%ebp
 3a2:	53                   	push   %ebx
 3a3:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3ad:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3b1:	74 17                	je     3ca <printint+0x2b>
 3b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3b7:	79 11                	jns    3ca <printint+0x2b>
    neg = 1;
 3b9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c3:	f7 d8                	neg    %eax
 3c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c8:	eb 06                	jmp    3d0 <printint+0x31>
  } else {
    x = xx;
 3ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3d7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3da:	8d 41 01             	lea    0x1(%ecx),%eax
 3dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e6:	ba 00 00 00 00       	mov    $0x0,%edx
 3eb:	f7 f3                	div    %ebx
 3ed:	89 d0                	mov    %edx,%eax
 3ef:	0f b6 80 74 0a 00 00 	movzbl 0xa74(%eax),%eax
 3f6:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 400:	ba 00 00 00 00       	mov    $0x0,%edx
 405:	f7 f3                	div    %ebx
 407:	89 45 ec             	mov    %eax,-0x14(%ebp)
 40a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 40e:	75 c7                	jne    3d7 <printint+0x38>
  if(neg)
 410:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 414:	74 2d                	je     443 <printint+0xa4>
    buf[i++] = '-';
 416:	8b 45 f4             	mov    -0xc(%ebp),%eax
 419:	8d 50 01             	lea    0x1(%eax),%edx
 41c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 41f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 424:	eb 1d                	jmp    443 <printint+0xa4>
    putc(fd, buf[i]);
 426:	8d 55 dc             	lea    -0x24(%ebp),%edx
 429:	8b 45 f4             	mov    -0xc(%ebp),%eax
 42c:	01 d0                	add    %edx,%eax
 42e:	0f b6 00             	movzbl (%eax),%eax
 431:	0f be c0             	movsbl %al,%eax
 434:	83 ec 08             	sub    $0x8,%esp
 437:	50                   	push   %eax
 438:	ff 75 08             	pushl  0x8(%ebp)
 43b:	e8 3c ff ff ff       	call   37c <putc>
 440:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 443:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 447:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 44b:	79 d9                	jns    426 <printint+0x87>
    putc(fd, buf[i]);
}
 44d:	90                   	nop
 44e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 451:	c9                   	leave  
 452:	c3                   	ret    

00000453 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 453:	55                   	push   %ebp
 454:	89 e5                	mov    %esp,%ebp
 456:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 459:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 460:	8d 45 0c             	lea    0xc(%ebp),%eax
 463:	83 c0 04             	add    $0x4,%eax
 466:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 469:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 470:	e9 59 01 00 00       	jmp    5ce <printf+0x17b>
    c = fmt[i] & 0xff;
 475:	8b 55 0c             	mov    0xc(%ebp),%edx
 478:	8b 45 f0             	mov    -0x10(%ebp),%eax
 47b:	01 d0                	add    %edx,%eax
 47d:	0f b6 00             	movzbl (%eax),%eax
 480:	0f be c0             	movsbl %al,%eax
 483:	25 ff 00 00 00       	and    $0xff,%eax
 488:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 48b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 48f:	75 2c                	jne    4bd <printf+0x6a>
      if(c == '%'){
 491:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 495:	75 0c                	jne    4a3 <printf+0x50>
        state = '%';
 497:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 49e:	e9 27 01 00 00       	jmp    5ca <printf+0x177>
      } else {
        putc(fd, c);
 4a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4a6:	0f be c0             	movsbl %al,%eax
 4a9:	83 ec 08             	sub    $0x8,%esp
 4ac:	50                   	push   %eax
 4ad:	ff 75 08             	pushl  0x8(%ebp)
 4b0:	e8 c7 fe ff ff       	call   37c <putc>
 4b5:	83 c4 10             	add    $0x10,%esp
 4b8:	e9 0d 01 00 00       	jmp    5ca <printf+0x177>
      }
    } else if(state == '%'){
 4bd:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4c1:	0f 85 03 01 00 00    	jne    5ca <printf+0x177>
      if(c == 'd'){
 4c7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4cb:	75 1e                	jne    4eb <printf+0x98>
        printint(fd, *ap, 10, 1);
 4cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d0:	8b 00                	mov    (%eax),%eax
 4d2:	6a 01                	push   $0x1
 4d4:	6a 0a                	push   $0xa
 4d6:	50                   	push   %eax
 4d7:	ff 75 08             	pushl  0x8(%ebp)
 4da:	e8 c0 fe ff ff       	call   39f <printint>
 4df:	83 c4 10             	add    $0x10,%esp
        ap++;
 4e2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4e6:	e9 d8 00 00 00       	jmp    5c3 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4eb:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4ef:	74 06                	je     4f7 <printf+0xa4>
 4f1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4f5:	75 1e                	jne    515 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4fa:	8b 00                	mov    (%eax),%eax
 4fc:	6a 00                	push   $0x0
 4fe:	6a 10                	push   $0x10
 500:	50                   	push   %eax
 501:	ff 75 08             	pushl  0x8(%ebp)
 504:	e8 96 fe ff ff       	call   39f <printint>
 509:	83 c4 10             	add    $0x10,%esp
        ap++;
 50c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 510:	e9 ae 00 00 00       	jmp    5c3 <printf+0x170>
      } else if(c == 's'){
 515:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 519:	75 43                	jne    55e <printf+0x10b>
        s = (char*)*ap;
 51b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 51e:	8b 00                	mov    (%eax),%eax
 520:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 523:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 527:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 52b:	75 25                	jne    552 <printf+0xff>
          s = "(null)";
 52d:	c7 45 f4 1d 08 00 00 	movl   $0x81d,-0xc(%ebp)
        while(*s != 0){
 534:	eb 1c                	jmp    552 <printf+0xff>
          putc(fd, *s);
 536:	8b 45 f4             	mov    -0xc(%ebp),%eax
 539:	0f b6 00             	movzbl (%eax),%eax
 53c:	0f be c0             	movsbl %al,%eax
 53f:	83 ec 08             	sub    $0x8,%esp
 542:	50                   	push   %eax
 543:	ff 75 08             	pushl  0x8(%ebp)
 546:	e8 31 fe ff ff       	call   37c <putc>
 54b:	83 c4 10             	add    $0x10,%esp
          s++;
 54e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 552:	8b 45 f4             	mov    -0xc(%ebp),%eax
 555:	0f b6 00             	movzbl (%eax),%eax
 558:	84 c0                	test   %al,%al
 55a:	75 da                	jne    536 <printf+0xe3>
 55c:	eb 65                	jmp    5c3 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 55e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 562:	75 1d                	jne    581 <printf+0x12e>
        putc(fd, *ap);
 564:	8b 45 e8             	mov    -0x18(%ebp),%eax
 567:	8b 00                	mov    (%eax),%eax
 569:	0f be c0             	movsbl %al,%eax
 56c:	83 ec 08             	sub    $0x8,%esp
 56f:	50                   	push   %eax
 570:	ff 75 08             	pushl  0x8(%ebp)
 573:	e8 04 fe ff ff       	call   37c <putc>
 578:	83 c4 10             	add    $0x10,%esp
        ap++;
 57b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 57f:	eb 42                	jmp    5c3 <printf+0x170>
      } else if(c == '%'){
 581:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 585:	75 17                	jne    59e <printf+0x14b>
        putc(fd, c);
 587:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58a:	0f be c0             	movsbl %al,%eax
 58d:	83 ec 08             	sub    $0x8,%esp
 590:	50                   	push   %eax
 591:	ff 75 08             	pushl  0x8(%ebp)
 594:	e8 e3 fd ff ff       	call   37c <putc>
 599:	83 c4 10             	add    $0x10,%esp
 59c:	eb 25                	jmp    5c3 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 59e:	83 ec 08             	sub    $0x8,%esp
 5a1:	6a 25                	push   $0x25
 5a3:	ff 75 08             	pushl  0x8(%ebp)
 5a6:	e8 d1 fd ff ff       	call   37c <putc>
 5ab:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b1:	0f be c0             	movsbl %al,%eax
 5b4:	83 ec 08             	sub    $0x8,%esp
 5b7:	50                   	push   %eax
 5b8:	ff 75 08             	pushl  0x8(%ebp)
 5bb:	e8 bc fd ff ff       	call   37c <putc>
 5c0:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5c3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ca:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5ce:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d4:	01 d0                	add    %edx,%eax
 5d6:	0f b6 00             	movzbl (%eax),%eax
 5d9:	84 c0                	test   %al,%al
 5db:	0f 85 94 fe ff ff    	jne    475 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5e1:	90                   	nop
 5e2:	c9                   	leave  
 5e3:	c3                   	ret    

000005e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e4:	55                   	push   %ebp
 5e5:	89 e5                	mov    %esp,%ebp
 5e7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ea:	8b 45 08             	mov    0x8(%ebp),%eax
 5ed:	83 e8 08             	sub    $0x8,%eax
 5f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f3:	a1 90 0a 00 00       	mov    0xa90,%eax
 5f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5fb:	eb 24                	jmp    621 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 600:	8b 00                	mov    (%eax),%eax
 602:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 605:	77 12                	ja     619 <free+0x35>
 607:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 60d:	77 24                	ja     633 <free+0x4f>
 60f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 612:	8b 00                	mov    (%eax),%eax
 614:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 617:	77 1a                	ja     633 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 619:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61c:	8b 00                	mov    (%eax),%eax
 61e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 621:	8b 45 f8             	mov    -0x8(%ebp),%eax
 624:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 627:	76 d4                	jbe    5fd <free+0x19>
 629:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62c:	8b 00                	mov    (%eax),%eax
 62e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 631:	76 ca                	jbe    5fd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 633:	8b 45 f8             	mov    -0x8(%ebp),%eax
 636:	8b 40 04             	mov    0x4(%eax),%eax
 639:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 640:	8b 45 f8             	mov    -0x8(%ebp),%eax
 643:	01 c2                	add    %eax,%edx
 645:	8b 45 fc             	mov    -0x4(%ebp),%eax
 648:	8b 00                	mov    (%eax),%eax
 64a:	39 c2                	cmp    %eax,%edx
 64c:	75 24                	jne    672 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 64e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 651:	8b 50 04             	mov    0x4(%eax),%edx
 654:	8b 45 fc             	mov    -0x4(%ebp),%eax
 657:	8b 00                	mov    (%eax),%eax
 659:	8b 40 04             	mov    0x4(%eax),%eax
 65c:	01 c2                	add    %eax,%edx
 65e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 661:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 664:	8b 45 fc             	mov    -0x4(%ebp),%eax
 667:	8b 00                	mov    (%eax),%eax
 669:	8b 10                	mov    (%eax),%edx
 66b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66e:	89 10                	mov    %edx,(%eax)
 670:	eb 0a                	jmp    67c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 672:	8b 45 fc             	mov    -0x4(%ebp),%eax
 675:	8b 10                	mov    (%eax),%edx
 677:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 67c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67f:	8b 40 04             	mov    0x4(%eax),%eax
 682:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 689:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68c:	01 d0                	add    %edx,%eax
 68e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 691:	75 20                	jne    6b3 <free+0xcf>
    p->s.size += bp->s.size;
 693:	8b 45 fc             	mov    -0x4(%ebp),%eax
 696:	8b 50 04             	mov    0x4(%eax),%edx
 699:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69c:	8b 40 04             	mov    0x4(%eax),%eax
 69f:	01 c2                	add    %eax,%edx
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6aa:	8b 10                	mov    (%eax),%edx
 6ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6af:	89 10                	mov    %edx,(%eax)
 6b1:	eb 08                	jmp    6bb <free+0xd7>
  } else
    p->s.ptr = bp;
 6b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6b9:	89 10                	mov    %edx,(%eax)
  freep = p;
 6bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6be:	a3 90 0a 00 00       	mov    %eax,0xa90
}
 6c3:	90                   	nop
 6c4:	c9                   	leave  
 6c5:	c3                   	ret    

000006c6 <morecore>:

static Header*
morecore(uint nu)
{
 6c6:	55                   	push   %ebp
 6c7:	89 e5                	mov    %esp,%ebp
 6c9:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6cc:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6d3:	77 07                	ja     6dc <morecore+0x16>
    nu = 4096;
 6d5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6dc:	8b 45 08             	mov    0x8(%ebp),%eax
 6df:	c1 e0 03             	shl    $0x3,%eax
 6e2:	83 ec 0c             	sub    $0xc,%esp
 6e5:	50                   	push   %eax
 6e6:	e8 61 fc ff ff       	call   34c <sbrk>
 6eb:	83 c4 10             	add    $0x10,%esp
 6ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6f1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6f5:	75 07                	jne    6fe <morecore+0x38>
    return 0;
 6f7:	b8 00 00 00 00       	mov    $0x0,%eax
 6fc:	eb 26                	jmp    724 <morecore+0x5e>
  hp = (Header*)p;
 6fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 701:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 704:	8b 45 f0             	mov    -0x10(%ebp),%eax
 707:	8b 55 08             	mov    0x8(%ebp),%edx
 70a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 70d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 710:	83 c0 08             	add    $0x8,%eax
 713:	83 ec 0c             	sub    $0xc,%esp
 716:	50                   	push   %eax
 717:	e8 c8 fe ff ff       	call   5e4 <free>
 71c:	83 c4 10             	add    $0x10,%esp
  return freep;
 71f:	a1 90 0a 00 00       	mov    0xa90,%eax
}
 724:	c9                   	leave  
 725:	c3                   	ret    

00000726 <malloc>:

void*
malloc(uint nbytes)
{
 726:	55                   	push   %ebp
 727:	89 e5                	mov    %esp,%ebp
 729:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 72c:	8b 45 08             	mov    0x8(%ebp),%eax
 72f:	83 c0 07             	add    $0x7,%eax
 732:	c1 e8 03             	shr    $0x3,%eax
 735:	83 c0 01             	add    $0x1,%eax
 738:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 73b:	a1 90 0a 00 00       	mov    0xa90,%eax
 740:	89 45 f0             	mov    %eax,-0x10(%ebp)
 743:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 747:	75 23                	jne    76c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 749:	c7 45 f0 88 0a 00 00 	movl   $0xa88,-0x10(%ebp)
 750:	8b 45 f0             	mov    -0x10(%ebp),%eax
 753:	a3 90 0a 00 00       	mov    %eax,0xa90
 758:	a1 90 0a 00 00       	mov    0xa90,%eax
 75d:	a3 88 0a 00 00       	mov    %eax,0xa88
    base.s.size = 0;
 762:	c7 05 8c 0a 00 00 00 	movl   $0x0,0xa8c
 769:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 76c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76f:	8b 00                	mov    (%eax),%eax
 771:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 774:	8b 45 f4             	mov    -0xc(%ebp),%eax
 777:	8b 40 04             	mov    0x4(%eax),%eax
 77a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 77d:	72 4d                	jb     7cc <malloc+0xa6>
      if(p->s.size == nunits)
 77f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 782:	8b 40 04             	mov    0x4(%eax),%eax
 785:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 788:	75 0c                	jne    796 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 78a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78d:	8b 10                	mov    (%eax),%edx
 78f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 792:	89 10                	mov    %edx,(%eax)
 794:	eb 26                	jmp    7bc <malloc+0x96>
      else {
        p->s.size -= nunits;
 796:	8b 45 f4             	mov    -0xc(%ebp),%eax
 799:	8b 40 04             	mov    0x4(%eax),%eax
 79c:	2b 45 ec             	sub    -0x14(%ebp),%eax
 79f:	89 c2                	mov    %eax,%edx
 7a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7aa:	8b 40 04             	mov    0x4(%eax),%eax
 7ad:	c1 e0 03             	shl    $0x3,%eax
 7b0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7b9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bf:	a3 90 0a 00 00       	mov    %eax,0xa90
      return (void*)(p + 1);
 7c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c7:	83 c0 08             	add    $0x8,%eax
 7ca:	eb 3b                	jmp    807 <malloc+0xe1>
    }
    if(p == freep)
 7cc:	a1 90 0a 00 00       	mov    0xa90,%eax
 7d1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7d4:	75 1e                	jne    7f4 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7d6:	83 ec 0c             	sub    $0xc,%esp
 7d9:	ff 75 ec             	pushl  -0x14(%ebp)
 7dc:	e8 e5 fe ff ff       	call   6c6 <morecore>
 7e1:	83 c4 10             	add    $0x10,%esp
 7e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7eb:	75 07                	jne    7f4 <malloc+0xce>
        return 0;
 7ed:	b8 00 00 00 00       	mov    $0x0,%eax
 7f2:	eb 13                	jmp    807 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fd:	8b 00                	mov    (%eax),%eax
 7ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 802:	e9 6d ff ff ff       	jmp    774 <malloc+0x4e>
}
 807:	c9                   	leave  
 808:	c3                   	ret    
