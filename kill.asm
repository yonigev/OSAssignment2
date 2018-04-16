
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
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "usage: kill pid...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 10 08 00 00       	push   $0x810
  21:	6a 02                	push   $0x2
  23:	e8 32 04 00 00       	call   45a <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 9b 02 00 00       	call   2cb <exit>
  }
  for(i=1; i<argc; i++)
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 2f                	jmp    68 <main+0x68>
    kill(atoi(argv[i]),SIGKILL);
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 e6 01 00 00       	call   239 <atoi>
  53:	83 c4 10             	add    $0x10,%esp
  56:	83 ec 08             	sub    $0x8,%esp
  59:	6a 09                	push   $0x9
  5b:	50                   	push   %eax
  5c:	e8 9a 02 00 00       	call   2fb <kill>
  61:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  64:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  6b:	3b 03                	cmp    (%ebx),%eax
  6d:	7c ca                	jl     39 <main+0x39>
    kill(atoi(argv[i]),SIGKILL);
  exit();
  6f:	e8 57 02 00 00       	call   2cb <exit>

00000074 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	57                   	push   %edi
  78:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7c:	8b 55 10             	mov    0x10(%ebp),%edx
  7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  82:	89 cb                	mov    %ecx,%ebx
  84:	89 df                	mov    %ebx,%edi
  86:	89 d1                	mov    %edx,%ecx
  88:	fc                   	cld    
  89:	f3 aa                	rep stos %al,%es:(%edi)
  8b:	89 ca                	mov    %ecx,%edx
  8d:	89 fb                	mov    %edi,%ebx
  8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  92:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  95:	90                   	nop
  96:	5b                   	pop    %ebx
  97:	5f                   	pop    %edi
  98:	5d                   	pop    %ebp
  99:	c3                   	ret    

0000009a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9a:	55                   	push   %ebp
  9b:	89 e5                	mov    %esp,%ebp
  9d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a6:	90                   	nop
  a7:	8b 45 08             	mov    0x8(%ebp),%eax
  aa:	8d 50 01             	lea    0x1(%eax),%edx
  ad:	89 55 08             	mov    %edx,0x8(%ebp)
  b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  b3:	8d 4a 01             	lea    0x1(%edx),%ecx
  b6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b9:	0f b6 12             	movzbl (%edx),%edx
  bc:	88 10                	mov    %dl,(%eax)
  be:	0f b6 00             	movzbl (%eax),%eax
  c1:	84 c0                	test   %al,%al
  c3:	75 e2                	jne    a7 <strcpy+0xd>
    ;
  return os;
  c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c8:	c9                   	leave  
  c9:	c3                   	ret    

000000ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ca:	55                   	push   %ebp
  cb:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cd:	eb 08                	jmp    d7 <strcmp+0xd>
    p++, q++;
  cf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	0f b6 00             	movzbl (%eax),%eax
  dd:	84 c0                	test   %al,%al
  df:	74 10                	je     f1 <strcmp+0x27>
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	0f b6 10             	movzbl (%eax),%edx
  e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ea:	0f b6 00             	movzbl (%eax),%eax
  ed:	38 c2                	cmp    %al,%dl
  ef:	74 de                	je     cf <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	0f b6 d0             	movzbl %al,%edx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	0f b6 00             	movzbl (%eax),%eax
 100:	0f b6 c0             	movzbl %al,%eax
 103:	29 c2                	sub    %eax,%edx
 105:	89 d0                	mov    %edx,%eax
}
 107:	5d                   	pop    %ebp
 108:	c3                   	ret    

00000109 <strlen>:

uint
strlen(char *s)
{
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 116:	eb 04                	jmp    11c <strlen+0x13>
 118:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11f:	8b 45 08             	mov    0x8(%ebp),%eax
 122:	01 d0                	add    %edx,%eax
 124:	0f b6 00             	movzbl (%eax),%eax
 127:	84 c0                	test   %al,%al
 129:	75 ed                	jne    118 <strlen+0xf>
    ;
  return n;
 12b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12e:	c9                   	leave  
 12f:	c3                   	ret    

00000130 <memset>:

void*
memset(void *dst, int c, uint n)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 133:	8b 45 10             	mov    0x10(%ebp),%eax
 136:	50                   	push   %eax
 137:	ff 75 0c             	pushl  0xc(%ebp)
 13a:	ff 75 08             	pushl  0x8(%ebp)
 13d:	e8 32 ff ff ff       	call   74 <stosb>
 142:	83 c4 0c             	add    $0xc,%esp
  return dst;
 145:	8b 45 08             	mov    0x8(%ebp),%eax
}
 148:	c9                   	leave  
 149:	c3                   	ret    

0000014a <strchr>:

char*
strchr(const char *s, char c)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	83 ec 04             	sub    $0x4,%esp
 150:	8b 45 0c             	mov    0xc(%ebp),%eax
 153:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 156:	eb 14                	jmp    16c <strchr+0x22>
    if(*s == c)
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	0f b6 00             	movzbl (%eax),%eax
 15e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 161:	75 05                	jne    168 <strchr+0x1e>
      return (char*)s;
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	eb 13                	jmp    17b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 168:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	84 c0                	test   %al,%al
 174:	75 e2                	jne    158 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 176:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17b:	c9                   	leave  
 17c:	c3                   	ret    

0000017d <gets>:

char*
gets(char *buf, int max)
{
 17d:	55                   	push   %ebp
 17e:	89 e5                	mov    %esp,%ebp
 180:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 183:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18a:	eb 42                	jmp    1ce <gets+0x51>
    cc = read(0, &c, 1);
 18c:	83 ec 04             	sub    $0x4,%esp
 18f:	6a 01                	push   $0x1
 191:	8d 45 ef             	lea    -0x11(%ebp),%eax
 194:	50                   	push   %eax
 195:	6a 00                	push   $0x0
 197:	e8 47 01 00 00       	call   2e3 <read>
 19c:	83 c4 10             	add    $0x10,%esp
 19f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a6:	7e 33                	jle    1db <gets+0x5e>
      break;
    buf[i++] = c;
 1a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ab:	8d 50 01             	lea    0x1(%eax),%edx
 1ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b1:	89 c2                	mov    %eax,%edx
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	01 c2                	add    %eax,%edx
 1b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c2:	3c 0a                	cmp    $0xa,%al
 1c4:	74 16                	je     1dc <gets+0x5f>
 1c6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ca:	3c 0d                	cmp    $0xd,%al
 1cc:	74 0e                	je     1dc <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d1:	83 c0 01             	add    $0x1,%eax
 1d4:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d7:	7c b3                	jl     18c <gets+0xf>
 1d9:	eb 01                	jmp    1dc <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1db:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	01 d0                	add    %edx,%eax
 1e4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ea:	c9                   	leave  
 1eb:	c3                   	ret    

000001ec <stat>:

int
stat(char *n, struct stat *st)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f2:	83 ec 08             	sub    $0x8,%esp
 1f5:	6a 00                	push   $0x0
 1f7:	ff 75 08             	pushl  0x8(%ebp)
 1fa:	e8 0c 01 00 00       	call   30b <open>
 1ff:	83 c4 10             	add    $0x10,%esp
 202:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 209:	79 07                	jns    212 <stat+0x26>
    return -1;
 20b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 210:	eb 25                	jmp    237 <stat+0x4b>
  r = fstat(fd, st);
 212:	83 ec 08             	sub    $0x8,%esp
 215:	ff 75 0c             	pushl  0xc(%ebp)
 218:	ff 75 f4             	pushl  -0xc(%ebp)
 21b:	e8 03 01 00 00       	call   323 <fstat>
 220:	83 c4 10             	add    $0x10,%esp
 223:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 226:	83 ec 0c             	sub    $0xc,%esp
 229:	ff 75 f4             	pushl  -0xc(%ebp)
 22c:	e8 c2 00 00 00       	call   2f3 <close>
 231:	83 c4 10             	add    $0x10,%esp
  return r;
 234:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 237:	c9                   	leave  
 238:	c3                   	ret    

00000239 <atoi>:

int
atoi(const char *s)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
 23c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 246:	eb 25                	jmp    26d <atoi+0x34>
    n = n*10 + *s++ - '0';
 248:	8b 55 fc             	mov    -0x4(%ebp),%edx
 24b:	89 d0                	mov    %edx,%eax
 24d:	c1 e0 02             	shl    $0x2,%eax
 250:	01 d0                	add    %edx,%eax
 252:	01 c0                	add    %eax,%eax
 254:	89 c1                	mov    %eax,%ecx
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	8d 50 01             	lea    0x1(%eax),%edx
 25c:	89 55 08             	mov    %edx,0x8(%ebp)
 25f:	0f b6 00             	movzbl (%eax),%eax
 262:	0f be c0             	movsbl %al,%eax
 265:	01 c8                	add    %ecx,%eax
 267:	83 e8 30             	sub    $0x30,%eax
 26a:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	3c 2f                	cmp    $0x2f,%al
 275:	7e 0a                	jle    281 <atoi+0x48>
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	3c 39                	cmp    $0x39,%al
 27f:	7e c7                	jle    248 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 281:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 284:	c9                   	leave  
 285:	c3                   	ret    

00000286 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 286:	55                   	push   %ebp
 287:	89 e5                	mov    %esp,%ebp
 289:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 292:	8b 45 0c             	mov    0xc(%ebp),%eax
 295:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 298:	eb 17                	jmp    2b1 <memmove+0x2b>
    *dst++ = *src++;
 29a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29d:	8d 50 01             	lea    0x1(%eax),%edx
 2a0:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2a3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2a6:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a9:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2ac:	0f b6 12             	movzbl (%edx),%edx
 2af:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b1:	8b 45 10             	mov    0x10(%ebp),%eax
 2b4:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b7:	89 55 10             	mov    %edx,0x10(%ebp)
 2ba:	85 c0                	test   %eax,%eax
 2bc:	7f dc                	jg     29a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c1:	c9                   	leave  
 2c2:	c3                   	ret    

000002c3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c3:	b8 01 00 00 00       	mov    $0x1,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <exit>:
SYSCALL(exit)
 2cb:	b8 02 00 00 00       	mov    $0x2,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <wait>:
SYSCALL(wait)
 2d3:	b8 03 00 00 00       	mov    $0x3,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <pipe>:
SYSCALL(pipe)
 2db:	b8 04 00 00 00       	mov    $0x4,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <read>:
SYSCALL(read)
 2e3:	b8 05 00 00 00       	mov    $0x5,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <write>:
SYSCALL(write)
 2eb:	b8 10 00 00 00       	mov    $0x10,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <close>:
SYSCALL(close)
 2f3:	b8 15 00 00 00       	mov    $0x15,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <kill>:
SYSCALL(kill)
 2fb:	b8 06 00 00 00       	mov    $0x6,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <exec>:
SYSCALL(exec)
 303:	b8 07 00 00 00       	mov    $0x7,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <open>:
SYSCALL(open)
 30b:	b8 0f 00 00 00       	mov    $0xf,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <mknod>:
SYSCALL(mknod)
 313:	b8 11 00 00 00       	mov    $0x11,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <unlink>:
SYSCALL(unlink)
 31b:	b8 12 00 00 00       	mov    $0x12,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <fstat>:
SYSCALL(fstat)
 323:	b8 08 00 00 00       	mov    $0x8,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <link>:
SYSCALL(link)
 32b:	b8 13 00 00 00       	mov    $0x13,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <mkdir>:
SYSCALL(mkdir)
 333:	b8 14 00 00 00       	mov    $0x14,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <chdir>:
SYSCALL(chdir)
 33b:	b8 09 00 00 00       	mov    $0x9,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <dup>:
SYSCALL(dup)
 343:	b8 0a 00 00 00       	mov    $0xa,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <getpid>:
SYSCALL(getpid)
 34b:	b8 0b 00 00 00       	mov    $0xb,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <sbrk>:
SYSCALL(sbrk)
 353:	b8 0c 00 00 00       	mov    $0xc,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <sleep>:
SYSCALL(sleep)
 35b:	b8 0d 00 00 00       	mov    $0xd,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <uptime>:
SYSCALL(uptime)
 363:	b8 0e 00 00 00       	mov    $0xe,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <sigprocmask>:
SYSCALL(sigprocmask)
 36b:	b8 16 00 00 00       	mov    $0x16,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <signal>:
SYSCALL(signal)
 373:	b8 17 00 00 00       	mov    $0x17,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <sigret>:
SYSCALL(sigret)
 37b:	b8 18 00 00 00       	mov    $0x18,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 383:	55                   	push   %ebp
 384:	89 e5                	mov    %esp,%ebp
 386:	83 ec 18             	sub    $0x18,%esp
 389:	8b 45 0c             	mov    0xc(%ebp),%eax
 38c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 38f:	83 ec 04             	sub    $0x4,%esp
 392:	6a 01                	push   $0x1
 394:	8d 45 f4             	lea    -0xc(%ebp),%eax
 397:	50                   	push   %eax
 398:	ff 75 08             	pushl  0x8(%ebp)
 39b:	e8 4b ff ff ff       	call   2eb <write>
 3a0:	83 c4 10             	add    $0x10,%esp
}
 3a3:	90                   	nop
 3a4:	c9                   	leave  
 3a5:	c3                   	ret    

000003a6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a6:	55                   	push   %ebp
 3a7:	89 e5                	mov    %esp,%ebp
 3a9:	53                   	push   %ebx
 3aa:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3b4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3b8:	74 17                	je     3d1 <printint+0x2b>
 3ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3be:	79 11                	jns    3d1 <printint+0x2b>
    neg = 1;
 3c0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ca:	f7 d8                	neg    %eax
 3cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3cf:	eb 06                	jmp    3d7 <printint+0x31>
  } else {
    x = xx;
 3d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3de:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3e1:	8d 41 01             	lea    0x1(%ecx),%eax
 3e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ed:	ba 00 00 00 00       	mov    $0x0,%edx
 3f2:	f7 f3                	div    %ebx
 3f4:	89 d0                	mov    %edx,%eax
 3f6:	0f b6 80 78 0a 00 00 	movzbl 0xa78(%eax),%eax
 3fd:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 401:	8b 5d 10             	mov    0x10(%ebp),%ebx
 404:	8b 45 ec             	mov    -0x14(%ebp),%eax
 407:	ba 00 00 00 00       	mov    $0x0,%edx
 40c:	f7 f3                	div    %ebx
 40e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 411:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 415:	75 c7                	jne    3de <printint+0x38>
  if(neg)
 417:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 41b:	74 2d                	je     44a <printint+0xa4>
    buf[i++] = '-';
 41d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 420:	8d 50 01             	lea    0x1(%eax),%edx
 423:	89 55 f4             	mov    %edx,-0xc(%ebp)
 426:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 42b:	eb 1d                	jmp    44a <printint+0xa4>
    putc(fd, buf[i]);
 42d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 430:	8b 45 f4             	mov    -0xc(%ebp),%eax
 433:	01 d0                	add    %edx,%eax
 435:	0f b6 00             	movzbl (%eax),%eax
 438:	0f be c0             	movsbl %al,%eax
 43b:	83 ec 08             	sub    $0x8,%esp
 43e:	50                   	push   %eax
 43f:	ff 75 08             	pushl  0x8(%ebp)
 442:	e8 3c ff ff ff       	call   383 <putc>
 447:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 44a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 44e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 452:	79 d9                	jns    42d <printint+0x87>
    putc(fd, buf[i]);
}
 454:	90                   	nop
 455:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 458:	c9                   	leave  
 459:	c3                   	ret    

0000045a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 45a:	55                   	push   %ebp
 45b:	89 e5                	mov    %esp,%ebp
 45d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 460:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 467:	8d 45 0c             	lea    0xc(%ebp),%eax
 46a:	83 c0 04             	add    $0x4,%eax
 46d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 470:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 477:	e9 59 01 00 00       	jmp    5d5 <printf+0x17b>
    c = fmt[i] & 0xff;
 47c:	8b 55 0c             	mov    0xc(%ebp),%edx
 47f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 482:	01 d0                	add    %edx,%eax
 484:	0f b6 00             	movzbl (%eax),%eax
 487:	0f be c0             	movsbl %al,%eax
 48a:	25 ff 00 00 00       	and    $0xff,%eax
 48f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 492:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 496:	75 2c                	jne    4c4 <printf+0x6a>
      if(c == '%'){
 498:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 49c:	75 0c                	jne    4aa <printf+0x50>
        state = '%';
 49e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4a5:	e9 27 01 00 00       	jmp    5d1 <printf+0x177>
      } else {
        putc(fd, c);
 4aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4ad:	0f be c0             	movsbl %al,%eax
 4b0:	83 ec 08             	sub    $0x8,%esp
 4b3:	50                   	push   %eax
 4b4:	ff 75 08             	pushl  0x8(%ebp)
 4b7:	e8 c7 fe ff ff       	call   383 <putc>
 4bc:	83 c4 10             	add    $0x10,%esp
 4bf:	e9 0d 01 00 00       	jmp    5d1 <printf+0x177>
      }
    } else if(state == '%'){
 4c4:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4c8:	0f 85 03 01 00 00    	jne    5d1 <printf+0x177>
      if(c == 'd'){
 4ce:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4d2:	75 1e                	jne    4f2 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d7:	8b 00                	mov    (%eax),%eax
 4d9:	6a 01                	push   $0x1
 4db:	6a 0a                	push   $0xa
 4dd:	50                   	push   %eax
 4de:	ff 75 08             	pushl  0x8(%ebp)
 4e1:	e8 c0 fe ff ff       	call   3a6 <printint>
 4e6:	83 c4 10             	add    $0x10,%esp
        ap++;
 4e9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ed:	e9 d8 00 00 00       	jmp    5ca <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4f2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4f6:	74 06                	je     4fe <printf+0xa4>
 4f8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4fc:	75 1e                	jne    51c <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
 501:	8b 00                	mov    (%eax),%eax
 503:	6a 00                	push   $0x0
 505:	6a 10                	push   $0x10
 507:	50                   	push   %eax
 508:	ff 75 08             	pushl  0x8(%ebp)
 50b:	e8 96 fe ff ff       	call   3a6 <printint>
 510:	83 c4 10             	add    $0x10,%esp
        ap++;
 513:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 517:	e9 ae 00 00 00       	jmp    5ca <printf+0x170>
      } else if(c == 's'){
 51c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 520:	75 43                	jne    565 <printf+0x10b>
        s = (char*)*ap;
 522:	8b 45 e8             	mov    -0x18(%ebp),%eax
 525:	8b 00                	mov    (%eax),%eax
 527:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 52a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 52e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 532:	75 25                	jne    559 <printf+0xff>
          s = "(null)";
 534:	c7 45 f4 24 08 00 00 	movl   $0x824,-0xc(%ebp)
        while(*s != 0){
 53b:	eb 1c                	jmp    559 <printf+0xff>
          putc(fd, *s);
 53d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 540:	0f b6 00             	movzbl (%eax),%eax
 543:	0f be c0             	movsbl %al,%eax
 546:	83 ec 08             	sub    $0x8,%esp
 549:	50                   	push   %eax
 54a:	ff 75 08             	pushl  0x8(%ebp)
 54d:	e8 31 fe ff ff       	call   383 <putc>
 552:	83 c4 10             	add    $0x10,%esp
          s++;
 555:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 559:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55c:	0f b6 00             	movzbl (%eax),%eax
 55f:	84 c0                	test   %al,%al
 561:	75 da                	jne    53d <printf+0xe3>
 563:	eb 65                	jmp    5ca <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 565:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 569:	75 1d                	jne    588 <printf+0x12e>
        putc(fd, *ap);
 56b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56e:	8b 00                	mov    (%eax),%eax
 570:	0f be c0             	movsbl %al,%eax
 573:	83 ec 08             	sub    $0x8,%esp
 576:	50                   	push   %eax
 577:	ff 75 08             	pushl  0x8(%ebp)
 57a:	e8 04 fe ff ff       	call   383 <putc>
 57f:	83 c4 10             	add    $0x10,%esp
        ap++;
 582:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 586:	eb 42                	jmp    5ca <printf+0x170>
      } else if(c == '%'){
 588:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 58c:	75 17                	jne    5a5 <printf+0x14b>
        putc(fd, c);
 58e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 591:	0f be c0             	movsbl %al,%eax
 594:	83 ec 08             	sub    $0x8,%esp
 597:	50                   	push   %eax
 598:	ff 75 08             	pushl  0x8(%ebp)
 59b:	e8 e3 fd ff ff       	call   383 <putc>
 5a0:	83 c4 10             	add    $0x10,%esp
 5a3:	eb 25                	jmp    5ca <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5a5:	83 ec 08             	sub    $0x8,%esp
 5a8:	6a 25                	push   $0x25
 5aa:	ff 75 08             	pushl  0x8(%ebp)
 5ad:	e8 d1 fd ff ff       	call   383 <putc>
 5b2:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b8:	0f be c0             	movsbl %al,%eax
 5bb:	83 ec 08             	sub    $0x8,%esp
 5be:	50                   	push   %eax
 5bf:	ff 75 08             	pushl  0x8(%ebp)
 5c2:	e8 bc fd ff ff       	call   383 <putc>
 5c7:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5ca:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5d1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5d5:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5db:	01 d0                	add    %edx,%eax
 5dd:	0f b6 00             	movzbl (%eax),%eax
 5e0:	84 c0                	test   %al,%al
 5e2:	0f 85 94 fe ff ff    	jne    47c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5e8:	90                   	nop
 5e9:	c9                   	leave  
 5ea:	c3                   	ret    

000005eb <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5eb:	55                   	push   %ebp
 5ec:	89 e5                	mov    %esp,%ebp
 5ee:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5f1:	8b 45 08             	mov    0x8(%ebp),%eax
 5f4:	83 e8 08             	sub    $0x8,%eax
 5f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fa:	a1 94 0a 00 00       	mov    0xa94,%eax
 5ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
 602:	eb 24                	jmp    628 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 604:	8b 45 fc             	mov    -0x4(%ebp),%eax
 607:	8b 00                	mov    (%eax),%eax
 609:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 60c:	77 12                	ja     620 <free+0x35>
 60e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 611:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 614:	77 24                	ja     63a <free+0x4f>
 616:	8b 45 fc             	mov    -0x4(%ebp),%eax
 619:	8b 00                	mov    (%eax),%eax
 61b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 61e:	77 1a                	ja     63a <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 620:	8b 45 fc             	mov    -0x4(%ebp),%eax
 623:	8b 00                	mov    (%eax),%eax
 625:	89 45 fc             	mov    %eax,-0x4(%ebp)
 628:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62e:	76 d4                	jbe    604 <free+0x19>
 630:	8b 45 fc             	mov    -0x4(%ebp),%eax
 633:	8b 00                	mov    (%eax),%eax
 635:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 638:	76 ca                	jbe    604 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 63a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63d:	8b 40 04             	mov    0x4(%eax),%eax
 640:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 647:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64a:	01 c2                	add    %eax,%edx
 64c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64f:	8b 00                	mov    (%eax),%eax
 651:	39 c2                	cmp    %eax,%edx
 653:	75 24                	jne    679 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 655:	8b 45 f8             	mov    -0x8(%ebp),%eax
 658:	8b 50 04             	mov    0x4(%eax),%edx
 65b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65e:	8b 00                	mov    (%eax),%eax
 660:	8b 40 04             	mov    0x4(%eax),%eax
 663:	01 c2                	add    %eax,%edx
 665:	8b 45 f8             	mov    -0x8(%ebp),%eax
 668:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 66b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66e:	8b 00                	mov    (%eax),%eax
 670:	8b 10                	mov    (%eax),%edx
 672:	8b 45 f8             	mov    -0x8(%ebp),%eax
 675:	89 10                	mov    %edx,(%eax)
 677:	eb 0a                	jmp    683 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 679:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67c:	8b 10                	mov    (%eax),%edx
 67e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 681:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 683:	8b 45 fc             	mov    -0x4(%ebp),%eax
 686:	8b 40 04             	mov    0x4(%eax),%eax
 689:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 690:	8b 45 fc             	mov    -0x4(%ebp),%eax
 693:	01 d0                	add    %edx,%eax
 695:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 698:	75 20                	jne    6ba <free+0xcf>
    p->s.size += bp->s.size;
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	8b 50 04             	mov    0x4(%eax),%edx
 6a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a3:	8b 40 04             	mov    0x4(%eax),%eax
 6a6:	01 c2                	add    %eax,%edx
 6a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ab:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b1:	8b 10                	mov    (%eax),%edx
 6b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b6:	89 10                	mov    %edx,(%eax)
 6b8:	eb 08                	jmp    6c2 <free+0xd7>
  } else
    p->s.ptr = bp;
 6ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bd:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6c0:	89 10                	mov    %edx,(%eax)
  freep = p;
 6c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c5:	a3 94 0a 00 00       	mov    %eax,0xa94
}
 6ca:	90                   	nop
 6cb:	c9                   	leave  
 6cc:	c3                   	ret    

000006cd <morecore>:

static Header*
morecore(uint nu)
{
 6cd:	55                   	push   %ebp
 6ce:	89 e5                	mov    %esp,%ebp
 6d0:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6d3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6da:	77 07                	ja     6e3 <morecore+0x16>
    nu = 4096;
 6dc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6e3:	8b 45 08             	mov    0x8(%ebp),%eax
 6e6:	c1 e0 03             	shl    $0x3,%eax
 6e9:	83 ec 0c             	sub    $0xc,%esp
 6ec:	50                   	push   %eax
 6ed:	e8 61 fc ff ff       	call   353 <sbrk>
 6f2:	83 c4 10             	add    $0x10,%esp
 6f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6f8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6fc:	75 07                	jne    705 <morecore+0x38>
    return 0;
 6fe:	b8 00 00 00 00       	mov    $0x0,%eax
 703:	eb 26                	jmp    72b <morecore+0x5e>
  hp = (Header*)p;
 705:	8b 45 f4             	mov    -0xc(%ebp),%eax
 708:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 70b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70e:	8b 55 08             	mov    0x8(%ebp),%edx
 711:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 714:	8b 45 f0             	mov    -0x10(%ebp),%eax
 717:	83 c0 08             	add    $0x8,%eax
 71a:	83 ec 0c             	sub    $0xc,%esp
 71d:	50                   	push   %eax
 71e:	e8 c8 fe ff ff       	call   5eb <free>
 723:	83 c4 10             	add    $0x10,%esp
  return freep;
 726:	a1 94 0a 00 00       	mov    0xa94,%eax
}
 72b:	c9                   	leave  
 72c:	c3                   	ret    

0000072d <malloc>:

void*
malloc(uint nbytes)
{
 72d:	55                   	push   %ebp
 72e:	89 e5                	mov    %esp,%ebp
 730:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 733:	8b 45 08             	mov    0x8(%ebp),%eax
 736:	83 c0 07             	add    $0x7,%eax
 739:	c1 e8 03             	shr    $0x3,%eax
 73c:	83 c0 01             	add    $0x1,%eax
 73f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 742:	a1 94 0a 00 00       	mov    0xa94,%eax
 747:	89 45 f0             	mov    %eax,-0x10(%ebp)
 74a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 74e:	75 23                	jne    773 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 750:	c7 45 f0 8c 0a 00 00 	movl   $0xa8c,-0x10(%ebp)
 757:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75a:	a3 94 0a 00 00       	mov    %eax,0xa94
 75f:	a1 94 0a 00 00       	mov    0xa94,%eax
 764:	a3 8c 0a 00 00       	mov    %eax,0xa8c
    base.s.size = 0;
 769:	c7 05 90 0a 00 00 00 	movl   $0x0,0xa90
 770:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 773:	8b 45 f0             	mov    -0x10(%ebp),%eax
 776:	8b 00                	mov    (%eax),%eax
 778:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 77b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77e:	8b 40 04             	mov    0x4(%eax),%eax
 781:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 784:	72 4d                	jb     7d3 <malloc+0xa6>
      if(p->s.size == nunits)
 786:	8b 45 f4             	mov    -0xc(%ebp),%eax
 789:	8b 40 04             	mov    0x4(%eax),%eax
 78c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 78f:	75 0c                	jne    79d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 791:	8b 45 f4             	mov    -0xc(%ebp),%eax
 794:	8b 10                	mov    (%eax),%edx
 796:	8b 45 f0             	mov    -0x10(%ebp),%eax
 799:	89 10                	mov    %edx,(%eax)
 79b:	eb 26                	jmp    7c3 <malloc+0x96>
      else {
        p->s.size -= nunits;
 79d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a0:	8b 40 04             	mov    0x4(%eax),%eax
 7a3:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7a6:	89 c2                	mov    %eax,%edx
 7a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ab:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b1:	8b 40 04             	mov    0x4(%eax),%eax
 7b4:	c1 e0 03             	shl    $0x3,%eax
 7b7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7c0:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c6:	a3 94 0a 00 00       	mov    %eax,0xa94
      return (void*)(p + 1);
 7cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ce:	83 c0 08             	add    $0x8,%eax
 7d1:	eb 3b                	jmp    80e <malloc+0xe1>
    }
    if(p == freep)
 7d3:	a1 94 0a 00 00       	mov    0xa94,%eax
 7d8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7db:	75 1e                	jne    7fb <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7dd:	83 ec 0c             	sub    $0xc,%esp
 7e0:	ff 75 ec             	pushl  -0x14(%ebp)
 7e3:	e8 e5 fe ff ff       	call   6cd <morecore>
 7e8:	83 c4 10             	add    $0x10,%esp
 7eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f2:	75 07                	jne    7fb <malloc+0xce>
        return 0;
 7f4:	b8 00 00 00 00       	mov    $0x0,%eax
 7f9:	eb 13                	jmp    80e <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
 801:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804:	8b 00                	mov    (%eax),%eax
 806:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 809:	e9 6d ff ff ff       	jmp    77b <malloc+0x4e>
}
 80e:	c9                   	leave  
 80f:	c3                   	ret    
