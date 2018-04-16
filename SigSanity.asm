
_SigSanity:     file format elf32-i386


Disassembly of section .text:

00000000 <gotTen>:





int gotTen(int num){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 08             	sub    $0x8,%esp
    printf(1,"Got signal 10\n");
   6:	83 ec 08             	sub    $0x8,%esp
   9:	68 42 08 00 00       	push   $0x842
   e:	6a 01                	push   $0x1
  10:	e8 77 04 00 00       	call   48c <printf>
  15:	83 c4 10             	add    $0x10,%esp
    exit();
  18:	e8 e0 02 00 00       	call   2fd <exit>

0000001d <infinite>:
}

void infinite(){
  1d:	55                   	push   %ebp
  1e:	89 e5                	mov    %esp,%ebp
  20:	83 ec 18             	sub    $0x18,%esp
    sighandler_t pointer= (sighandler_t)gotTen;
  23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    signal(10,pointer);
  2a:	83 ec 08             	sub    $0x8,%esp
  2d:	ff 75 f4             	pushl  -0xc(%ebp)
  30:	6a 0a                	push   $0xa
  32:	e8 6e 03 00 00       	call   3a5 <signal>
  37:	83 c4 10             	add    $0x10,%esp
    printf(1,"got10 is: %p\n",*pointer);
  3a:	83 ec 04             	sub    $0x4,%esp
  3d:	ff 75 f4             	pushl  -0xc(%ebp)
  40:	68 51 08 00 00       	push   $0x851
  45:	6a 01                	push   $0x1
  47:	e8 40 04 00 00       	call   48c <printf>
  4c:	83 c4 10             	add    $0x10,%esp
    while(1){


    }
  4f:	eb fe                	jmp    4f <infinite+0x32>

00000051 <main>:
}

int main(){
  51:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  55:	83 e4 f0             	and    $0xfffffff0,%esp
  58:	ff 71 fc             	pushl  -0x4(%ecx)
  5b:	55                   	push   %ebp
  5c:	89 e5                	mov    %esp,%ebp
  5e:	51                   	push   %ecx
  5f:	83 ec 14             	sub    $0x14,%esp

    printf(1,"GOTTEN IS: %d\n",infinite);
  62:	83 ec 04             	sub    $0x4,%esp
  65:	68 1d 00 00 00       	push   $0x1d
  6a:	68 5f 08 00 00       	push   $0x85f
  6f:	6a 01                	push   $0x1
  71:	e8 16 04 00 00       	call   48c <printf>
  76:	83 c4 10             	add    $0x10,%esp
    int pid1;
    if((pid1=fork())==0){
  79:	e8 77 02 00 00       	call   2f5 <fork>
  7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  85:	75 05                	jne    8c <main+0x3b>
        infinite();
  87:	e8 91 ff ff ff       	call   1d <infinite>
    }
    printf(1,"Child pid: %d\n",pid1);
  8c:	83 ec 04             	sub    $0x4,%esp
  8f:	ff 75 f4             	pushl  -0xc(%ebp)
  92:	68 6e 08 00 00       	push   $0x86e
  97:	6a 01                	push   $0x1
  99:	e8 ee 03 00 00       	call   48c <printf>
  9e:	83 c4 10             	add    $0x10,%esp




    exit();
  a1:	e8 57 02 00 00       	call   2fd <exit>

000000a6 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  a6:	55                   	push   %ebp
  a7:	89 e5                	mov    %esp,%ebp
  a9:	57                   	push   %edi
  aa:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ae:	8b 55 10             	mov    0x10(%ebp),%edx
  b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  b4:	89 cb                	mov    %ecx,%ebx
  b6:	89 df                	mov    %ebx,%edi
  b8:	89 d1                	mov    %edx,%ecx
  ba:	fc                   	cld    
  bb:	f3 aa                	rep stos %al,%es:(%edi)
  bd:	89 ca                	mov    %ecx,%edx
  bf:	89 fb                	mov    %edi,%ebx
  c1:	89 5d 08             	mov    %ebx,0x8(%ebp)
  c4:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  c7:	90                   	nop
  c8:	5b                   	pop    %ebx
  c9:	5f                   	pop    %edi
  ca:	5d                   	pop    %ebp
  cb:	c3                   	ret    

000000cc <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  cc:	55                   	push   %ebp
  cd:	89 e5                	mov    %esp,%ebp
  cf:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  d8:	90                   	nop
  d9:	8b 45 08             	mov    0x8(%ebp),%eax
  dc:	8d 50 01             	lea    0x1(%eax),%edx
  df:	89 55 08             	mov    %edx,0x8(%ebp)
  e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  e5:	8d 4a 01             	lea    0x1(%edx),%ecx
  e8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  eb:	0f b6 12             	movzbl (%edx),%edx
  ee:	88 10                	mov    %dl,(%eax)
  f0:	0f b6 00             	movzbl (%eax),%eax
  f3:	84 c0                	test   %al,%al
  f5:	75 e2                	jne    d9 <strcpy+0xd>
    ;
  return os;
  f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  fa:	c9                   	leave  
  fb:	c3                   	ret    

000000fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  ff:	eb 08                	jmp    109 <strcmp+0xd>
    p++, q++;
 101:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 105:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 109:	8b 45 08             	mov    0x8(%ebp),%eax
 10c:	0f b6 00             	movzbl (%eax),%eax
 10f:	84 c0                	test   %al,%al
 111:	74 10                	je     123 <strcmp+0x27>
 113:	8b 45 08             	mov    0x8(%ebp),%eax
 116:	0f b6 10             	movzbl (%eax),%edx
 119:	8b 45 0c             	mov    0xc(%ebp),%eax
 11c:	0f b6 00             	movzbl (%eax),%eax
 11f:	38 c2                	cmp    %al,%dl
 121:	74 de                	je     101 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 123:	8b 45 08             	mov    0x8(%ebp),%eax
 126:	0f b6 00             	movzbl (%eax),%eax
 129:	0f b6 d0             	movzbl %al,%edx
 12c:	8b 45 0c             	mov    0xc(%ebp),%eax
 12f:	0f b6 00             	movzbl (%eax),%eax
 132:	0f b6 c0             	movzbl %al,%eax
 135:	29 c2                	sub    %eax,%edx
 137:	89 d0                	mov    %edx,%eax
}
 139:	5d                   	pop    %ebp
 13a:	c3                   	ret    

0000013b <strlen>:

uint
strlen(char *s)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 141:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 148:	eb 04                	jmp    14e <strlen+0x13>
 14a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 14e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 151:	8b 45 08             	mov    0x8(%ebp),%eax
 154:	01 d0                	add    %edx,%eax
 156:	0f b6 00             	movzbl (%eax),%eax
 159:	84 c0                	test   %al,%al
 15b:	75 ed                	jne    14a <strlen+0xf>
    ;
  return n;
 15d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 160:	c9                   	leave  
 161:	c3                   	ret    

00000162 <memset>:

void*
memset(void *dst, int c, uint n)
{
 162:	55                   	push   %ebp
 163:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 165:	8b 45 10             	mov    0x10(%ebp),%eax
 168:	50                   	push   %eax
 169:	ff 75 0c             	pushl  0xc(%ebp)
 16c:	ff 75 08             	pushl  0x8(%ebp)
 16f:	e8 32 ff ff ff       	call   a6 <stosb>
 174:	83 c4 0c             	add    $0xc,%esp
  return dst;
 177:	8b 45 08             	mov    0x8(%ebp),%eax
}
 17a:	c9                   	leave  
 17b:	c3                   	ret    

0000017c <strchr>:

char*
strchr(const char *s, char c)
{
 17c:	55                   	push   %ebp
 17d:	89 e5                	mov    %esp,%ebp
 17f:	83 ec 04             	sub    $0x4,%esp
 182:	8b 45 0c             	mov    0xc(%ebp),%eax
 185:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 188:	eb 14                	jmp    19e <strchr+0x22>
    if(*s == c)
 18a:	8b 45 08             	mov    0x8(%ebp),%eax
 18d:	0f b6 00             	movzbl (%eax),%eax
 190:	3a 45 fc             	cmp    -0x4(%ebp),%al
 193:	75 05                	jne    19a <strchr+0x1e>
      return (char*)s;
 195:	8b 45 08             	mov    0x8(%ebp),%eax
 198:	eb 13                	jmp    1ad <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 19a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	0f b6 00             	movzbl (%eax),%eax
 1a4:	84 c0                	test   %al,%al
 1a6:	75 e2                	jne    18a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1ad:	c9                   	leave  
 1ae:	c3                   	ret    

000001af <gets>:

char*
gets(char *buf, int max)
{
 1af:	55                   	push   %ebp
 1b0:	89 e5                	mov    %esp,%ebp
 1b2:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1bc:	eb 42                	jmp    200 <gets+0x51>
    cc = read(0, &c, 1);
 1be:	83 ec 04             	sub    $0x4,%esp
 1c1:	6a 01                	push   $0x1
 1c3:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1c6:	50                   	push   %eax
 1c7:	6a 00                	push   $0x0
 1c9:	e8 47 01 00 00       	call   315 <read>
 1ce:	83 c4 10             	add    $0x10,%esp
 1d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1d8:	7e 33                	jle    20d <gets+0x5e>
      break;
    buf[i++] = c;
 1da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1dd:	8d 50 01             	lea    0x1(%eax),%edx
 1e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1e3:	89 c2                	mov    %eax,%edx
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	01 c2                	add    %eax,%edx
 1ea:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ee:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1f0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f4:	3c 0a                	cmp    $0xa,%al
 1f6:	74 16                	je     20e <gets+0x5f>
 1f8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1fc:	3c 0d                	cmp    $0xd,%al
 1fe:	74 0e                	je     20e <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 200:	8b 45 f4             	mov    -0xc(%ebp),%eax
 203:	83 c0 01             	add    $0x1,%eax
 206:	3b 45 0c             	cmp    0xc(%ebp),%eax
 209:	7c b3                	jl     1be <gets+0xf>
 20b:	eb 01                	jmp    20e <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 20d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 20e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 211:	8b 45 08             	mov    0x8(%ebp),%eax
 214:	01 d0                	add    %edx,%eax
 216:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 219:	8b 45 08             	mov    0x8(%ebp),%eax
}
 21c:	c9                   	leave  
 21d:	c3                   	ret    

0000021e <stat>:

int
stat(char *n, struct stat *st)
{
 21e:	55                   	push   %ebp
 21f:	89 e5                	mov    %esp,%ebp
 221:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 224:	83 ec 08             	sub    $0x8,%esp
 227:	6a 00                	push   $0x0
 229:	ff 75 08             	pushl  0x8(%ebp)
 22c:	e8 0c 01 00 00       	call   33d <open>
 231:	83 c4 10             	add    $0x10,%esp
 234:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 237:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 23b:	79 07                	jns    244 <stat+0x26>
    return -1;
 23d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 242:	eb 25                	jmp    269 <stat+0x4b>
  r = fstat(fd, st);
 244:	83 ec 08             	sub    $0x8,%esp
 247:	ff 75 0c             	pushl  0xc(%ebp)
 24a:	ff 75 f4             	pushl  -0xc(%ebp)
 24d:	e8 03 01 00 00       	call   355 <fstat>
 252:	83 c4 10             	add    $0x10,%esp
 255:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 258:	83 ec 0c             	sub    $0xc,%esp
 25b:	ff 75 f4             	pushl  -0xc(%ebp)
 25e:	e8 c2 00 00 00       	call   325 <close>
 263:	83 c4 10             	add    $0x10,%esp
  return r;
 266:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 269:	c9                   	leave  
 26a:	c3                   	ret    

0000026b <atoi>:

int
atoi(const char *s)
{
 26b:	55                   	push   %ebp
 26c:	89 e5                	mov    %esp,%ebp
 26e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 271:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 278:	eb 25                	jmp    29f <atoi+0x34>
    n = n*10 + *s++ - '0';
 27a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 27d:	89 d0                	mov    %edx,%eax
 27f:	c1 e0 02             	shl    $0x2,%eax
 282:	01 d0                	add    %edx,%eax
 284:	01 c0                	add    %eax,%eax
 286:	89 c1                	mov    %eax,%ecx
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	8d 50 01             	lea    0x1(%eax),%edx
 28e:	89 55 08             	mov    %edx,0x8(%ebp)
 291:	0f b6 00             	movzbl (%eax),%eax
 294:	0f be c0             	movsbl %al,%eax
 297:	01 c8                	add    %ecx,%eax
 299:	83 e8 30             	sub    $0x30,%eax
 29c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	0f b6 00             	movzbl (%eax),%eax
 2a5:	3c 2f                	cmp    $0x2f,%al
 2a7:	7e 0a                	jle    2b3 <atoi+0x48>
 2a9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ac:	0f b6 00             	movzbl (%eax),%eax
 2af:	3c 39                	cmp    $0x39,%al
 2b1:	7e c7                	jle    27a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2b6:	c9                   	leave  
 2b7:	c3                   	ret    

000002b8 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2b8:	55                   	push   %ebp
 2b9:	89 e5                	mov    %esp,%ebp
 2bb:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
 2c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2ca:	eb 17                	jmp    2e3 <memmove+0x2b>
    *dst++ = *src++;
 2cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2cf:	8d 50 01             	lea    0x1(%eax),%edx
 2d2:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2d5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2d8:	8d 4a 01             	lea    0x1(%edx),%ecx
 2db:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2de:	0f b6 12             	movzbl (%edx),%edx
 2e1:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2e3:	8b 45 10             	mov    0x10(%ebp),%eax
 2e6:	8d 50 ff             	lea    -0x1(%eax),%edx
 2e9:	89 55 10             	mov    %edx,0x10(%ebp)
 2ec:	85 c0                	test   %eax,%eax
 2ee:	7f dc                	jg     2cc <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2f3:	c9                   	leave  
 2f4:	c3                   	ret    

000002f5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2f5:	b8 01 00 00 00       	mov    $0x1,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <exit>:
SYSCALL(exit)
 2fd:	b8 02 00 00 00       	mov    $0x2,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <wait>:
SYSCALL(wait)
 305:	b8 03 00 00 00       	mov    $0x3,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <pipe>:
SYSCALL(pipe)
 30d:	b8 04 00 00 00       	mov    $0x4,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <read>:
SYSCALL(read)
 315:	b8 05 00 00 00       	mov    $0x5,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <write>:
SYSCALL(write)
 31d:	b8 10 00 00 00       	mov    $0x10,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <close>:
SYSCALL(close)
 325:	b8 15 00 00 00       	mov    $0x15,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <kill>:
SYSCALL(kill)
 32d:	b8 06 00 00 00       	mov    $0x6,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <exec>:
SYSCALL(exec)
 335:	b8 07 00 00 00       	mov    $0x7,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <open>:
SYSCALL(open)
 33d:	b8 0f 00 00 00       	mov    $0xf,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <mknod>:
SYSCALL(mknod)
 345:	b8 11 00 00 00       	mov    $0x11,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <unlink>:
SYSCALL(unlink)
 34d:	b8 12 00 00 00       	mov    $0x12,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <fstat>:
SYSCALL(fstat)
 355:	b8 08 00 00 00       	mov    $0x8,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <link>:
SYSCALL(link)
 35d:	b8 13 00 00 00       	mov    $0x13,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <mkdir>:
SYSCALL(mkdir)
 365:	b8 14 00 00 00       	mov    $0x14,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <chdir>:
SYSCALL(chdir)
 36d:	b8 09 00 00 00       	mov    $0x9,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <dup>:
SYSCALL(dup)
 375:	b8 0a 00 00 00       	mov    $0xa,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <getpid>:
SYSCALL(getpid)
 37d:	b8 0b 00 00 00       	mov    $0xb,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <sbrk>:
SYSCALL(sbrk)
 385:	b8 0c 00 00 00       	mov    $0xc,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <sleep>:
SYSCALL(sleep)
 38d:	b8 0d 00 00 00       	mov    $0xd,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <uptime>:
SYSCALL(uptime)
 395:	b8 0e 00 00 00       	mov    $0xe,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <sigprocmask>:
SYSCALL(sigprocmask)
 39d:	b8 16 00 00 00       	mov    $0x16,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <signal>:
SYSCALL(signal)
 3a5:	b8 17 00 00 00       	mov    $0x17,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <sigret>:
SYSCALL(sigret)
 3ad:	b8 18 00 00 00       	mov    $0x18,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3b5:	55                   	push   %ebp
 3b6:	89 e5                	mov    %esp,%ebp
 3b8:	83 ec 18             	sub    $0x18,%esp
 3bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3be:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3c1:	83 ec 04             	sub    $0x4,%esp
 3c4:	6a 01                	push   $0x1
 3c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3c9:	50                   	push   %eax
 3ca:	ff 75 08             	pushl  0x8(%ebp)
 3cd:	e8 4b ff ff ff       	call   31d <write>
 3d2:	83 c4 10             	add    $0x10,%esp
}
 3d5:	90                   	nop
 3d6:	c9                   	leave  
 3d7:	c3                   	ret    

000003d8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d8:	55                   	push   %ebp
 3d9:	89 e5                	mov    %esp,%ebp
 3db:	53                   	push   %ebx
 3dc:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3e6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3ea:	74 17                	je     403 <printint+0x2b>
 3ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3f0:	79 11                	jns    403 <printint+0x2b>
    neg = 1;
 3f2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fc:	f7 d8                	neg    %eax
 3fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
 401:	eb 06                	jmp    409 <printint+0x31>
  } else {
    x = xx;
 403:	8b 45 0c             	mov    0xc(%ebp),%eax
 406:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 409:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 410:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 413:	8d 41 01             	lea    0x1(%ecx),%eax
 416:	89 45 f4             	mov    %eax,-0xc(%ebp)
 419:	8b 5d 10             	mov    0x10(%ebp),%ebx
 41c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 41f:	ba 00 00 00 00       	mov    $0x0,%edx
 424:	f7 f3                	div    %ebx
 426:	89 d0                	mov    %edx,%eax
 428:	0f b6 80 04 0b 00 00 	movzbl 0xb04(%eax),%eax
 42f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 433:	8b 5d 10             	mov    0x10(%ebp),%ebx
 436:	8b 45 ec             	mov    -0x14(%ebp),%eax
 439:	ba 00 00 00 00       	mov    $0x0,%edx
 43e:	f7 f3                	div    %ebx
 440:	89 45 ec             	mov    %eax,-0x14(%ebp)
 443:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 447:	75 c7                	jne    410 <printint+0x38>
  if(neg)
 449:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 44d:	74 2d                	je     47c <printint+0xa4>
    buf[i++] = '-';
 44f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 452:	8d 50 01             	lea    0x1(%eax),%edx
 455:	89 55 f4             	mov    %edx,-0xc(%ebp)
 458:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 45d:	eb 1d                	jmp    47c <printint+0xa4>
    putc(fd, buf[i]);
 45f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 462:	8b 45 f4             	mov    -0xc(%ebp),%eax
 465:	01 d0                	add    %edx,%eax
 467:	0f b6 00             	movzbl (%eax),%eax
 46a:	0f be c0             	movsbl %al,%eax
 46d:	83 ec 08             	sub    $0x8,%esp
 470:	50                   	push   %eax
 471:	ff 75 08             	pushl  0x8(%ebp)
 474:	e8 3c ff ff ff       	call   3b5 <putc>
 479:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 47c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 480:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 484:	79 d9                	jns    45f <printint+0x87>
    putc(fd, buf[i]);
}
 486:	90                   	nop
 487:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 48a:	c9                   	leave  
 48b:	c3                   	ret    

0000048c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 48c:	55                   	push   %ebp
 48d:	89 e5                	mov    %esp,%ebp
 48f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 492:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 499:	8d 45 0c             	lea    0xc(%ebp),%eax
 49c:	83 c0 04             	add    $0x4,%eax
 49f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4a9:	e9 59 01 00 00       	jmp    607 <printf+0x17b>
    c = fmt[i] & 0xff;
 4ae:	8b 55 0c             	mov    0xc(%ebp),%edx
 4b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4b4:	01 d0                	add    %edx,%eax
 4b6:	0f b6 00             	movzbl (%eax),%eax
 4b9:	0f be c0             	movsbl %al,%eax
 4bc:	25 ff 00 00 00       	and    $0xff,%eax
 4c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c8:	75 2c                	jne    4f6 <printf+0x6a>
      if(c == '%'){
 4ca:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4ce:	75 0c                	jne    4dc <printf+0x50>
        state = '%';
 4d0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4d7:	e9 27 01 00 00       	jmp    603 <printf+0x177>
      } else {
        putc(fd, c);
 4dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4df:	0f be c0             	movsbl %al,%eax
 4e2:	83 ec 08             	sub    $0x8,%esp
 4e5:	50                   	push   %eax
 4e6:	ff 75 08             	pushl  0x8(%ebp)
 4e9:	e8 c7 fe ff ff       	call   3b5 <putc>
 4ee:	83 c4 10             	add    $0x10,%esp
 4f1:	e9 0d 01 00 00       	jmp    603 <printf+0x177>
      }
    } else if(state == '%'){
 4f6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4fa:	0f 85 03 01 00 00    	jne    603 <printf+0x177>
      if(c == 'd'){
 500:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 504:	75 1e                	jne    524 <printf+0x98>
        printint(fd, *ap, 10, 1);
 506:	8b 45 e8             	mov    -0x18(%ebp),%eax
 509:	8b 00                	mov    (%eax),%eax
 50b:	6a 01                	push   $0x1
 50d:	6a 0a                	push   $0xa
 50f:	50                   	push   %eax
 510:	ff 75 08             	pushl  0x8(%ebp)
 513:	e8 c0 fe ff ff       	call   3d8 <printint>
 518:	83 c4 10             	add    $0x10,%esp
        ap++;
 51b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 51f:	e9 d8 00 00 00       	jmp    5fc <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 524:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 528:	74 06                	je     530 <printf+0xa4>
 52a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 52e:	75 1e                	jne    54e <printf+0xc2>
        printint(fd, *ap, 16, 0);
 530:	8b 45 e8             	mov    -0x18(%ebp),%eax
 533:	8b 00                	mov    (%eax),%eax
 535:	6a 00                	push   $0x0
 537:	6a 10                	push   $0x10
 539:	50                   	push   %eax
 53a:	ff 75 08             	pushl  0x8(%ebp)
 53d:	e8 96 fe ff ff       	call   3d8 <printint>
 542:	83 c4 10             	add    $0x10,%esp
        ap++;
 545:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 549:	e9 ae 00 00 00       	jmp    5fc <printf+0x170>
      } else if(c == 's'){
 54e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 552:	75 43                	jne    597 <printf+0x10b>
        s = (char*)*ap;
 554:	8b 45 e8             	mov    -0x18(%ebp),%eax
 557:	8b 00                	mov    (%eax),%eax
 559:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 55c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 560:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 564:	75 25                	jne    58b <printf+0xff>
          s = "(null)";
 566:	c7 45 f4 7d 08 00 00 	movl   $0x87d,-0xc(%ebp)
        while(*s != 0){
 56d:	eb 1c                	jmp    58b <printf+0xff>
          putc(fd, *s);
 56f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 572:	0f b6 00             	movzbl (%eax),%eax
 575:	0f be c0             	movsbl %al,%eax
 578:	83 ec 08             	sub    $0x8,%esp
 57b:	50                   	push   %eax
 57c:	ff 75 08             	pushl  0x8(%ebp)
 57f:	e8 31 fe ff ff       	call   3b5 <putc>
 584:	83 c4 10             	add    $0x10,%esp
          s++;
 587:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 58b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58e:	0f b6 00             	movzbl (%eax),%eax
 591:	84 c0                	test   %al,%al
 593:	75 da                	jne    56f <printf+0xe3>
 595:	eb 65                	jmp    5fc <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 597:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 59b:	75 1d                	jne    5ba <printf+0x12e>
        putc(fd, *ap);
 59d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a0:	8b 00                	mov    (%eax),%eax
 5a2:	0f be c0             	movsbl %al,%eax
 5a5:	83 ec 08             	sub    $0x8,%esp
 5a8:	50                   	push   %eax
 5a9:	ff 75 08             	pushl  0x8(%ebp)
 5ac:	e8 04 fe ff ff       	call   3b5 <putc>
 5b1:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b8:	eb 42                	jmp    5fc <printf+0x170>
      } else if(c == '%'){
 5ba:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5be:	75 17                	jne    5d7 <printf+0x14b>
        putc(fd, c);
 5c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c3:	0f be c0             	movsbl %al,%eax
 5c6:	83 ec 08             	sub    $0x8,%esp
 5c9:	50                   	push   %eax
 5ca:	ff 75 08             	pushl  0x8(%ebp)
 5cd:	e8 e3 fd ff ff       	call   3b5 <putc>
 5d2:	83 c4 10             	add    $0x10,%esp
 5d5:	eb 25                	jmp    5fc <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5d7:	83 ec 08             	sub    $0x8,%esp
 5da:	6a 25                	push   $0x25
 5dc:	ff 75 08             	pushl  0x8(%ebp)
 5df:	e8 d1 fd ff ff       	call   3b5 <putc>
 5e4:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ea:	0f be c0             	movsbl %al,%eax
 5ed:	83 ec 08             	sub    $0x8,%esp
 5f0:	50                   	push   %eax
 5f1:	ff 75 08             	pushl  0x8(%ebp)
 5f4:	e8 bc fd ff ff       	call   3b5 <putc>
 5f9:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5fc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 603:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 607:	8b 55 0c             	mov    0xc(%ebp),%edx
 60a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 60d:	01 d0                	add    %edx,%eax
 60f:	0f b6 00             	movzbl (%eax),%eax
 612:	84 c0                	test   %al,%al
 614:	0f 85 94 fe ff ff    	jne    4ae <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 61a:	90                   	nop
 61b:	c9                   	leave  
 61c:	c3                   	ret    

0000061d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 61d:	55                   	push   %ebp
 61e:	89 e5                	mov    %esp,%ebp
 620:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 623:	8b 45 08             	mov    0x8(%ebp),%eax
 626:	83 e8 08             	sub    $0x8,%eax
 629:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62c:	a1 20 0b 00 00       	mov    0xb20,%eax
 631:	89 45 fc             	mov    %eax,-0x4(%ebp)
 634:	eb 24                	jmp    65a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 636:	8b 45 fc             	mov    -0x4(%ebp),%eax
 639:	8b 00                	mov    (%eax),%eax
 63b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63e:	77 12                	ja     652 <free+0x35>
 640:	8b 45 f8             	mov    -0x8(%ebp),%eax
 643:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 646:	77 24                	ja     66c <free+0x4f>
 648:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64b:	8b 00                	mov    (%eax),%eax
 64d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 650:	77 1a                	ja     66c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 652:	8b 45 fc             	mov    -0x4(%ebp),%eax
 655:	8b 00                	mov    (%eax),%eax
 657:	89 45 fc             	mov    %eax,-0x4(%ebp)
 65a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 660:	76 d4                	jbe    636 <free+0x19>
 662:	8b 45 fc             	mov    -0x4(%ebp),%eax
 665:	8b 00                	mov    (%eax),%eax
 667:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66a:	76 ca                	jbe    636 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 66c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66f:	8b 40 04             	mov    0x4(%eax),%eax
 672:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 679:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67c:	01 c2                	add    %eax,%edx
 67e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 681:	8b 00                	mov    (%eax),%eax
 683:	39 c2                	cmp    %eax,%edx
 685:	75 24                	jne    6ab <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 687:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68a:	8b 50 04             	mov    0x4(%eax),%edx
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 690:	8b 00                	mov    (%eax),%eax
 692:	8b 40 04             	mov    0x4(%eax),%eax
 695:	01 c2                	add    %eax,%edx
 697:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 69d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a0:	8b 00                	mov    (%eax),%eax
 6a2:	8b 10                	mov    (%eax),%edx
 6a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a7:	89 10                	mov    %edx,(%eax)
 6a9:	eb 0a                	jmp    6b5 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	8b 10                	mov    (%eax),%edx
 6b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b8:	8b 40 04             	mov    0x4(%eax),%eax
 6bb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c5:	01 d0                	add    %edx,%eax
 6c7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ca:	75 20                	jne    6ec <free+0xcf>
    p->s.size += bp->s.size;
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cf:	8b 50 04             	mov    0x4(%eax),%edx
 6d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d5:	8b 40 04             	mov    0x4(%eax),%eax
 6d8:	01 c2                	add    %eax,%edx
 6da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dd:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e3:	8b 10                	mov    (%eax),%edx
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	89 10                	mov    %edx,(%eax)
 6ea:	eb 08                	jmp    6f4 <free+0xd7>
  } else
    p->s.ptr = bp;
 6ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ef:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6f2:	89 10                	mov    %edx,(%eax)
  freep = p;
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	a3 20 0b 00 00       	mov    %eax,0xb20
}
 6fc:	90                   	nop
 6fd:	c9                   	leave  
 6fe:	c3                   	ret    

000006ff <morecore>:

static Header*
morecore(uint nu)
{
 6ff:	55                   	push   %ebp
 700:	89 e5                	mov    %esp,%ebp
 702:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 705:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 70c:	77 07                	ja     715 <morecore+0x16>
    nu = 4096;
 70e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 715:	8b 45 08             	mov    0x8(%ebp),%eax
 718:	c1 e0 03             	shl    $0x3,%eax
 71b:	83 ec 0c             	sub    $0xc,%esp
 71e:	50                   	push   %eax
 71f:	e8 61 fc ff ff       	call   385 <sbrk>
 724:	83 c4 10             	add    $0x10,%esp
 727:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 72a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 72e:	75 07                	jne    737 <morecore+0x38>
    return 0;
 730:	b8 00 00 00 00       	mov    $0x0,%eax
 735:	eb 26                	jmp    75d <morecore+0x5e>
  hp = (Header*)p;
 737:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 73d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 740:	8b 55 08             	mov    0x8(%ebp),%edx
 743:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 746:	8b 45 f0             	mov    -0x10(%ebp),%eax
 749:	83 c0 08             	add    $0x8,%eax
 74c:	83 ec 0c             	sub    $0xc,%esp
 74f:	50                   	push   %eax
 750:	e8 c8 fe ff ff       	call   61d <free>
 755:	83 c4 10             	add    $0x10,%esp
  return freep;
 758:	a1 20 0b 00 00       	mov    0xb20,%eax
}
 75d:	c9                   	leave  
 75e:	c3                   	ret    

0000075f <malloc>:

void*
malloc(uint nbytes)
{
 75f:	55                   	push   %ebp
 760:	89 e5                	mov    %esp,%ebp
 762:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 765:	8b 45 08             	mov    0x8(%ebp),%eax
 768:	83 c0 07             	add    $0x7,%eax
 76b:	c1 e8 03             	shr    $0x3,%eax
 76e:	83 c0 01             	add    $0x1,%eax
 771:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 774:	a1 20 0b 00 00       	mov    0xb20,%eax
 779:	89 45 f0             	mov    %eax,-0x10(%ebp)
 77c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 780:	75 23                	jne    7a5 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 782:	c7 45 f0 18 0b 00 00 	movl   $0xb18,-0x10(%ebp)
 789:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78c:	a3 20 0b 00 00       	mov    %eax,0xb20
 791:	a1 20 0b 00 00       	mov    0xb20,%eax
 796:	a3 18 0b 00 00       	mov    %eax,0xb18
    base.s.size = 0;
 79b:	c7 05 1c 0b 00 00 00 	movl   $0x0,0xb1c
 7a2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a8:	8b 00                	mov    (%eax),%eax
 7aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b0:	8b 40 04             	mov    0x4(%eax),%eax
 7b3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b6:	72 4d                	jb     805 <malloc+0xa6>
      if(p->s.size == nunits)
 7b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bb:	8b 40 04             	mov    0x4(%eax),%eax
 7be:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c1:	75 0c                	jne    7cf <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c6:	8b 10                	mov    (%eax),%edx
 7c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cb:	89 10                	mov    %edx,(%eax)
 7cd:	eb 26                	jmp    7f5 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d2:	8b 40 04             	mov    0x4(%eax),%eax
 7d5:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7d8:	89 c2                	mov    %eax,%edx
 7da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dd:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e3:	8b 40 04             	mov    0x4(%eax),%eax
 7e6:	c1 e0 03             	shl    $0x3,%eax
 7e9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7f2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f8:	a3 20 0b 00 00       	mov    %eax,0xb20
      return (void*)(p + 1);
 7fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 800:	83 c0 08             	add    $0x8,%eax
 803:	eb 3b                	jmp    840 <malloc+0xe1>
    }
    if(p == freep)
 805:	a1 20 0b 00 00       	mov    0xb20,%eax
 80a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 80d:	75 1e                	jne    82d <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 80f:	83 ec 0c             	sub    $0xc,%esp
 812:	ff 75 ec             	pushl  -0x14(%ebp)
 815:	e8 e5 fe ff ff       	call   6ff <morecore>
 81a:	83 c4 10             	add    $0x10,%esp
 81d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 820:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 824:	75 07                	jne    82d <malloc+0xce>
        return 0;
 826:	b8 00 00 00 00       	mov    $0x0,%eax
 82b:	eb 13                	jmp    840 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 830:	89 45 f0             	mov    %eax,-0x10(%ebp)
 833:	8b 45 f4             	mov    -0xc(%ebp),%eax
 836:	8b 00                	mov    (%eax),%eax
 838:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 83b:	e9 6d ff ff ff       	jmp    7ad <malloc+0x4e>
}
 840:	c9                   	leave  
 841:	c3                   	ret    
