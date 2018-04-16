
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 69                	jmp    8b <wc+0x8b>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 58                	jmp    83 <wc+0x83>
      c++;
  2b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  32:	05 40 0c 00 00       	add    $0xc40,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 40 0c 00 00       	add    $0xc40,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	83 ec 08             	sub    $0x8,%esp
  53:	50                   	push   %eax
  54:	68 59 09 00 00       	push   $0x959
  59:	e8 35 02 00 00       	call   293 <strchr>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	85 c0                	test   %eax,%eax
  63:	74 09                	je     6e <wc+0x6e>
        inword = 0;
  65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6c:	eb 11                	jmp    7f <wc+0x7f>
      else if(!inword){
  6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  72:	75 0b                	jne    7f <wc+0x7f>
        w++;
  74:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  78:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  7f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  86:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  89:	7c a0                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  8b:	83 ec 04             	sub    $0x4,%esp
  8e:	68 00 02 00 00       	push   $0x200
  93:	68 40 0c 00 00       	push   $0xc40
  98:	ff 75 08             	pushl  0x8(%ebp)
  9b:	e8 8c 03 00 00       	call   42c <read>
  a0:	83 c4 10             	add    $0x10,%esp
  a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  aa:	0f 8f 72 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b4:	79 17                	jns    cd <wc+0xcd>
    printf(1, "wc: read error\n");
  b6:	83 ec 08             	sub    $0x8,%esp
  b9:	68 5f 09 00 00       	push   $0x95f
  be:	6a 01                	push   $0x1
  c0:	e8 de 04 00 00       	call   5a3 <printf>
  c5:	83 c4 10             	add    $0x10,%esp
    exit();
  c8:	e8 47 03 00 00       	call   414 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  cd:	83 ec 08             	sub    $0x8,%esp
  d0:	ff 75 0c             	pushl  0xc(%ebp)
  d3:	ff 75 e8             	pushl  -0x18(%ebp)
  d6:	ff 75 ec             	pushl  -0x14(%ebp)
  d9:	ff 75 f0             	pushl  -0x10(%ebp)
  dc:	68 6f 09 00 00       	push   $0x96f
  e1:	6a 01                	push   $0x1
  e3:	e8 bb 04 00 00       	call   5a3 <printf>
  e8:	83 c4 20             	add    $0x20,%esp
}
  eb:	90                   	nop
  ec:	c9                   	leave  
  ed:	c3                   	ret    

000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f2:	83 e4 f0             	and    $0xfffffff0,%esp
  f5:	ff 71 fc             	pushl  -0x4(%ecx)
  f8:	55                   	push   %ebp
  f9:	89 e5                	mov    %esp,%ebp
  fb:	53                   	push   %ebx
  fc:	51                   	push   %ecx
  fd:	83 ec 10             	sub    $0x10,%esp
 100:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
 102:	83 3b 01             	cmpl   $0x1,(%ebx)
 105:	7f 17                	jg     11e <main+0x30>
    wc(0, "");
 107:	83 ec 08             	sub    $0x8,%esp
 10a:	68 7c 09 00 00       	push   $0x97c
 10f:	6a 00                	push   $0x0
 111:	e8 ea fe ff ff       	call   0 <wc>
 116:	83 c4 10             	add    $0x10,%esp
    exit();
 119:	e8 f6 02 00 00       	call   414 <exit>
  }

  for(i = 1; i < argc; i++){
 11e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 125:	e9 83 00 00 00       	jmp    1ad <main+0xbf>
    if((fd = open(argv[i], 0)) < 0){
 12a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 12d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 134:	8b 43 04             	mov    0x4(%ebx),%eax
 137:	01 d0                	add    %edx,%eax
 139:	8b 00                	mov    (%eax),%eax
 13b:	83 ec 08             	sub    $0x8,%esp
 13e:	6a 00                	push   $0x0
 140:	50                   	push   %eax
 141:	e8 0e 03 00 00       	call   454 <open>
 146:	83 c4 10             	add    $0x10,%esp
 149:	89 45 f0             	mov    %eax,-0x10(%ebp)
 14c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 150:	79 29                	jns    17b <main+0x8d>
      printf(1, "wc: cannot open %s\n", argv[i]);
 152:	8b 45 f4             	mov    -0xc(%ebp),%eax
 155:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 15c:	8b 43 04             	mov    0x4(%ebx),%eax
 15f:	01 d0                	add    %edx,%eax
 161:	8b 00                	mov    (%eax),%eax
 163:	83 ec 04             	sub    $0x4,%esp
 166:	50                   	push   %eax
 167:	68 7d 09 00 00       	push   $0x97d
 16c:	6a 01                	push   $0x1
 16e:	e8 30 04 00 00       	call   5a3 <printf>
 173:	83 c4 10             	add    $0x10,%esp
      exit();
 176:	e8 99 02 00 00       	call   414 <exit>
    }
    wc(fd, argv[i]);
 17b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 185:	8b 43 04             	mov    0x4(%ebx),%eax
 188:	01 d0                	add    %edx,%eax
 18a:	8b 00                	mov    (%eax),%eax
 18c:	83 ec 08             	sub    $0x8,%esp
 18f:	50                   	push   %eax
 190:	ff 75 f0             	pushl  -0x10(%ebp)
 193:	e8 68 fe ff ff       	call   0 <wc>
 198:	83 c4 10             	add    $0x10,%esp
    close(fd);
 19b:	83 ec 0c             	sub    $0xc,%esp
 19e:	ff 75 f0             	pushl  -0x10(%ebp)
 1a1:	e8 96 02 00 00       	call   43c <close>
 1a6:	83 c4 10             	add    $0x10,%esp
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 1a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b0:	3b 03                	cmp    (%ebx),%eax
 1b2:	0f 8c 72 ff ff ff    	jl     12a <main+0x3c>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 1b8:	e8 57 02 00 00       	call   414 <exit>

000001bd <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
 1c0:	57                   	push   %edi
 1c1:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c5:	8b 55 10             	mov    0x10(%ebp),%edx
 1c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cb:	89 cb                	mov    %ecx,%ebx
 1cd:	89 df                	mov    %ebx,%edi
 1cf:	89 d1                	mov    %edx,%ecx
 1d1:	fc                   	cld    
 1d2:	f3 aa                	rep stos %al,%es:(%edi)
 1d4:	89 ca                	mov    %ecx,%edx
 1d6:	89 fb                	mov    %edi,%ebx
 1d8:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1db:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1de:	90                   	nop
 1df:	5b                   	pop    %ebx
 1e0:	5f                   	pop    %edi
 1e1:	5d                   	pop    %ebp
 1e2:	c3                   	ret    

000001e3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1e3:	55                   	push   %ebp
 1e4:	89 e5                	mov    %esp,%ebp
 1e6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1ef:	90                   	nop
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	8d 50 01             	lea    0x1(%eax),%edx
 1f6:	89 55 08             	mov    %edx,0x8(%ebp)
 1f9:	8b 55 0c             	mov    0xc(%ebp),%edx
 1fc:	8d 4a 01             	lea    0x1(%edx),%ecx
 1ff:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 202:	0f b6 12             	movzbl (%edx),%edx
 205:	88 10                	mov    %dl,(%eax)
 207:	0f b6 00             	movzbl (%eax),%eax
 20a:	84 c0                	test   %al,%al
 20c:	75 e2                	jne    1f0 <strcpy+0xd>
    ;
  return os;
 20e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 211:	c9                   	leave  
 212:	c3                   	ret    

00000213 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 213:	55                   	push   %ebp
 214:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 216:	eb 08                	jmp    220 <strcmp+0xd>
    p++, q++;
 218:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	0f b6 00             	movzbl (%eax),%eax
 226:	84 c0                	test   %al,%al
 228:	74 10                	je     23a <strcmp+0x27>
 22a:	8b 45 08             	mov    0x8(%ebp),%eax
 22d:	0f b6 10             	movzbl (%eax),%edx
 230:	8b 45 0c             	mov    0xc(%ebp),%eax
 233:	0f b6 00             	movzbl (%eax),%eax
 236:	38 c2                	cmp    %al,%dl
 238:	74 de                	je     218 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	0f b6 00             	movzbl (%eax),%eax
 240:	0f b6 d0             	movzbl %al,%edx
 243:	8b 45 0c             	mov    0xc(%ebp),%eax
 246:	0f b6 00             	movzbl (%eax),%eax
 249:	0f b6 c0             	movzbl %al,%eax
 24c:	29 c2                	sub    %eax,%edx
 24e:	89 d0                	mov    %edx,%eax
}
 250:	5d                   	pop    %ebp
 251:	c3                   	ret    

00000252 <strlen>:

uint
strlen(char *s)
{
 252:	55                   	push   %ebp
 253:	89 e5                	mov    %esp,%ebp
 255:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 258:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 25f:	eb 04                	jmp    265 <strlen+0x13>
 261:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 265:	8b 55 fc             	mov    -0x4(%ebp),%edx
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	01 d0                	add    %edx,%eax
 26d:	0f b6 00             	movzbl (%eax),%eax
 270:	84 c0                	test   %al,%al
 272:	75 ed                	jne    261 <strlen+0xf>
    ;
  return n;
 274:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 277:	c9                   	leave  
 278:	c3                   	ret    

00000279 <memset>:

void*
memset(void *dst, int c, uint n)
{
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 27c:	8b 45 10             	mov    0x10(%ebp),%eax
 27f:	50                   	push   %eax
 280:	ff 75 0c             	pushl  0xc(%ebp)
 283:	ff 75 08             	pushl  0x8(%ebp)
 286:	e8 32 ff ff ff       	call   1bd <stosb>
 28b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 291:	c9                   	leave  
 292:	c3                   	ret    

00000293 <strchr>:

char*
strchr(const char *s, char c)
{
 293:	55                   	push   %ebp
 294:	89 e5                	mov    %esp,%ebp
 296:	83 ec 04             	sub    $0x4,%esp
 299:	8b 45 0c             	mov    0xc(%ebp),%eax
 29c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 29f:	eb 14                	jmp    2b5 <strchr+0x22>
    if(*s == c)
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
 2a4:	0f b6 00             	movzbl (%eax),%eax
 2a7:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2aa:	75 05                	jne    2b1 <strchr+0x1e>
      return (char*)s;
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	eb 13                	jmp    2c4 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	0f b6 00             	movzbl (%eax),%eax
 2bb:	84 c0                	test   %al,%al
 2bd:	75 e2                	jne    2a1 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <gets>:

char*
gets(char *buf, int max)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2d3:	eb 42                	jmp    317 <gets+0x51>
    cc = read(0, &c, 1);
 2d5:	83 ec 04             	sub    $0x4,%esp
 2d8:	6a 01                	push   $0x1
 2da:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2dd:	50                   	push   %eax
 2de:	6a 00                	push   $0x0
 2e0:	e8 47 01 00 00       	call   42c <read>
 2e5:	83 c4 10             	add    $0x10,%esp
 2e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2ef:	7e 33                	jle    324 <gets+0x5e>
      break;
    buf[i++] = c;
 2f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f4:	8d 50 01             	lea    0x1(%eax),%edx
 2f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2fa:	89 c2                	mov    %eax,%edx
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	01 c2                	add    %eax,%edx
 301:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 305:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 307:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 30b:	3c 0a                	cmp    $0xa,%al
 30d:	74 16                	je     325 <gets+0x5f>
 30f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 313:	3c 0d                	cmp    $0xd,%al
 315:	74 0e                	je     325 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 317:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31a:	83 c0 01             	add    $0x1,%eax
 31d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 320:	7c b3                	jl     2d5 <gets+0xf>
 322:	eb 01                	jmp    325 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 324:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 325:	8b 55 f4             	mov    -0xc(%ebp),%edx
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	01 d0                	add    %edx,%eax
 32d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 330:	8b 45 08             	mov    0x8(%ebp),%eax
}
 333:	c9                   	leave  
 334:	c3                   	ret    

00000335 <stat>:

int
stat(char *n, struct stat *st)
{
 335:	55                   	push   %ebp
 336:	89 e5                	mov    %esp,%ebp
 338:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 33b:	83 ec 08             	sub    $0x8,%esp
 33e:	6a 00                	push   $0x0
 340:	ff 75 08             	pushl  0x8(%ebp)
 343:	e8 0c 01 00 00       	call   454 <open>
 348:	83 c4 10             	add    $0x10,%esp
 34b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 34e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 352:	79 07                	jns    35b <stat+0x26>
    return -1;
 354:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 359:	eb 25                	jmp    380 <stat+0x4b>
  r = fstat(fd, st);
 35b:	83 ec 08             	sub    $0x8,%esp
 35e:	ff 75 0c             	pushl  0xc(%ebp)
 361:	ff 75 f4             	pushl  -0xc(%ebp)
 364:	e8 03 01 00 00       	call   46c <fstat>
 369:	83 c4 10             	add    $0x10,%esp
 36c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 36f:	83 ec 0c             	sub    $0xc,%esp
 372:	ff 75 f4             	pushl  -0xc(%ebp)
 375:	e8 c2 00 00 00       	call   43c <close>
 37a:	83 c4 10             	add    $0x10,%esp
  return r;
 37d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 380:	c9                   	leave  
 381:	c3                   	ret    

00000382 <atoi>:

int
atoi(const char *s)
{
 382:	55                   	push   %ebp
 383:	89 e5                	mov    %esp,%ebp
 385:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 388:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 38f:	eb 25                	jmp    3b6 <atoi+0x34>
    n = n*10 + *s++ - '0';
 391:	8b 55 fc             	mov    -0x4(%ebp),%edx
 394:	89 d0                	mov    %edx,%eax
 396:	c1 e0 02             	shl    $0x2,%eax
 399:	01 d0                	add    %edx,%eax
 39b:	01 c0                	add    %eax,%eax
 39d:	89 c1                	mov    %eax,%ecx
 39f:	8b 45 08             	mov    0x8(%ebp),%eax
 3a2:	8d 50 01             	lea    0x1(%eax),%edx
 3a5:	89 55 08             	mov    %edx,0x8(%ebp)
 3a8:	0f b6 00             	movzbl (%eax),%eax
 3ab:	0f be c0             	movsbl %al,%eax
 3ae:	01 c8                	add    %ecx,%eax
 3b0:	83 e8 30             	sub    $0x30,%eax
 3b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3b6:	8b 45 08             	mov    0x8(%ebp),%eax
 3b9:	0f b6 00             	movzbl (%eax),%eax
 3bc:	3c 2f                	cmp    $0x2f,%al
 3be:	7e 0a                	jle    3ca <atoi+0x48>
 3c0:	8b 45 08             	mov    0x8(%ebp),%eax
 3c3:	0f b6 00             	movzbl (%eax),%eax
 3c6:	3c 39                	cmp    $0x39,%al
 3c8:	7e c7                	jle    391 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3cd:	c9                   	leave  
 3ce:	c3                   	ret    

000003cf <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3cf:	55                   	push   %ebp
 3d0:	89 e5                	mov    %esp,%ebp
 3d2:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 3d5:	8b 45 08             	mov    0x8(%ebp),%eax
 3d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3db:	8b 45 0c             	mov    0xc(%ebp),%eax
 3de:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3e1:	eb 17                	jmp    3fa <memmove+0x2b>
    *dst++ = *src++;
 3e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3e6:	8d 50 01             	lea    0x1(%eax),%edx
 3e9:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3ef:	8d 4a 01             	lea    0x1(%edx),%ecx
 3f2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3f5:	0f b6 12             	movzbl (%edx),%edx
 3f8:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3fa:	8b 45 10             	mov    0x10(%ebp),%eax
 3fd:	8d 50 ff             	lea    -0x1(%eax),%edx
 400:	89 55 10             	mov    %edx,0x10(%ebp)
 403:	85 c0                	test   %eax,%eax
 405:	7f dc                	jg     3e3 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 407:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40a:	c9                   	leave  
 40b:	c3                   	ret    

0000040c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 40c:	b8 01 00 00 00       	mov    $0x1,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <exit>:
SYSCALL(exit)
 414:	b8 02 00 00 00       	mov    $0x2,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <wait>:
SYSCALL(wait)
 41c:	b8 03 00 00 00       	mov    $0x3,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <pipe>:
SYSCALL(pipe)
 424:	b8 04 00 00 00       	mov    $0x4,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <read>:
SYSCALL(read)
 42c:	b8 05 00 00 00       	mov    $0x5,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <write>:
SYSCALL(write)
 434:	b8 10 00 00 00       	mov    $0x10,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <close>:
SYSCALL(close)
 43c:	b8 15 00 00 00       	mov    $0x15,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <kill>:
SYSCALL(kill)
 444:	b8 06 00 00 00       	mov    $0x6,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <exec>:
SYSCALL(exec)
 44c:	b8 07 00 00 00       	mov    $0x7,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <open>:
SYSCALL(open)
 454:	b8 0f 00 00 00       	mov    $0xf,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <mknod>:
SYSCALL(mknod)
 45c:	b8 11 00 00 00       	mov    $0x11,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <unlink>:
SYSCALL(unlink)
 464:	b8 12 00 00 00       	mov    $0x12,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <fstat>:
SYSCALL(fstat)
 46c:	b8 08 00 00 00       	mov    $0x8,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <link>:
SYSCALL(link)
 474:	b8 13 00 00 00       	mov    $0x13,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <mkdir>:
SYSCALL(mkdir)
 47c:	b8 14 00 00 00       	mov    $0x14,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <chdir>:
SYSCALL(chdir)
 484:	b8 09 00 00 00       	mov    $0x9,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <dup>:
SYSCALL(dup)
 48c:	b8 0a 00 00 00       	mov    $0xa,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <getpid>:
SYSCALL(getpid)
 494:	b8 0b 00 00 00       	mov    $0xb,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <sbrk>:
SYSCALL(sbrk)
 49c:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <sleep>:
SYSCALL(sleep)
 4a4:	b8 0d 00 00 00       	mov    $0xd,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <uptime>:
SYSCALL(uptime)
 4ac:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <sigprocmask>:
SYSCALL(sigprocmask)
 4b4:	b8 16 00 00 00       	mov    $0x16,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <signal>:
SYSCALL(signal)
 4bc:	b8 17 00 00 00       	mov    $0x17,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <sigret>:
SYSCALL(sigret)
 4c4:	b8 18 00 00 00       	mov    $0x18,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4cc:	55                   	push   %ebp
 4cd:	89 e5                	mov    %esp,%ebp
 4cf:	83 ec 18             	sub    $0x18,%esp
 4d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4d8:	83 ec 04             	sub    $0x4,%esp
 4db:	6a 01                	push   $0x1
 4dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4e0:	50                   	push   %eax
 4e1:	ff 75 08             	pushl  0x8(%ebp)
 4e4:	e8 4b ff ff ff       	call   434 <write>
 4e9:	83 c4 10             	add    $0x10,%esp
}
 4ec:	90                   	nop
 4ed:	c9                   	leave  
 4ee:	c3                   	ret    

000004ef <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ef:	55                   	push   %ebp
 4f0:	89 e5                	mov    %esp,%ebp
 4f2:	53                   	push   %ebx
 4f3:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4fd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 501:	74 17                	je     51a <printint+0x2b>
 503:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 507:	79 11                	jns    51a <printint+0x2b>
    neg = 1;
 509:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 510:	8b 45 0c             	mov    0xc(%ebp),%eax
 513:	f7 d8                	neg    %eax
 515:	89 45 ec             	mov    %eax,-0x14(%ebp)
 518:	eb 06                	jmp    520 <printint+0x31>
  } else {
    x = xx;
 51a:	8b 45 0c             	mov    0xc(%ebp),%eax
 51d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 520:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 527:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 52a:	8d 41 01             	lea    0x1(%ecx),%eax
 52d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 530:	8b 5d 10             	mov    0x10(%ebp),%ebx
 533:	8b 45 ec             	mov    -0x14(%ebp),%eax
 536:	ba 00 00 00 00       	mov    $0x0,%edx
 53b:	f7 f3                	div    %ebx
 53d:	89 d0                	mov    %edx,%eax
 53f:	0f b6 80 04 0c 00 00 	movzbl 0xc04(%eax),%eax
 546:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 54a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 54d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 550:	ba 00 00 00 00       	mov    $0x0,%edx
 555:	f7 f3                	div    %ebx
 557:	89 45 ec             	mov    %eax,-0x14(%ebp)
 55a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 55e:	75 c7                	jne    527 <printint+0x38>
  if(neg)
 560:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 564:	74 2d                	je     593 <printint+0xa4>
    buf[i++] = '-';
 566:	8b 45 f4             	mov    -0xc(%ebp),%eax
 569:	8d 50 01             	lea    0x1(%eax),%edx
 56c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 56f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 574:	eb 1d                	jmp    593 <printint+0xa4>
    putc(fd, buf[i]);
 576:	8d 55 dc             	lea    -0x24(%ebp),%edx
 579:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57c:	01 d0                	add    %edx,%eax
 57e:	0f b6 00             	movzbl (%eax),%eax
 581:	0f be c0             	movsbl %al,%eax
 584:	83 ec 08             	sub    $0x8,%esp
 587:	50                   	push   %eax
 588:	ff 75 08             	pushl  0x8(%ebp)
 58b:	e8 3c ff ff ff       	call   4cc <putc>
 590:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 593:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 597:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 59b:	79 d9                	jns    576 <printint+0x87>
    putc(fd, buf[i]);
}
 59d:	90                   	nop
 59e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5a1:	c9                   	leave  
 5a2:	c3                   	ret    

000005a3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5a3:	55                   	push   %ebp
 5a4:	89 e5                	mov    %esp,%ebp
 5a6:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5b0:	8d 45 0c             	lea    0xc(%ebp),%eax
 5b3:	83 c0 04             	add    $0x4,%eax
 5b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5c0:	e9 59 01 00 00       	jmp    71e <printf+0x17b>
    c = fmt[i] & 0xff;
 5c5:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5cb:	01 d0                	add    %edx,%eax
 5cd:	0f b6 00             	movzbl (%eax),%eax
 5d0:	0f be c0             	movsbl %al,%eax
 5d3:	25 ff 00 00 00       	and    $0xff,%eax
 5d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5df:	75 2c                	jne    60d <printf+0x6a>
      if(c == '%'){
 5e1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5e5:	75 0c                	jne    5f3 <printf+0x50>
        state = '%';
 5e7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5ee:	e9 27 01 00 00       	jmp    71a <printf+0x177>
      } else {
        putc(fd, c);
 5f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f6:	0f be c0             	movsbl %al,%eax
 5f9:	83 ec 08             	sub    $0x8,%esp
 5fc:	50                   	push   %eax
 5fd:	ff 75 08             	pushl  0x8(%ebp)
 600:	e8 c7 fe ff ff       	call   4cc <putc>
 605:	83 c4 10             	add    $0x10,%esp
 608:	e9 0d 01 00 00       	jmp    71a <printf+0x177>
      }
    } else if(state == '%'){
 60d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 611:	0f 85 03 01 00 00    	jne    71a <printf+0x177>
      if(c == 'd'){
 617:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 61b:	75 1e                	jne    63b <printf+0x98>
        printint(fd, *ap, 10, 1);
 61d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 620:	8b 00                	mov    (%eax),%eax
 622:	6a 01                	push   $0x1
 624:	6a 0a                	push   $0xa
 626:	50                   	push   %eax
 627:	ff 75 08             	pushl  0x8(%ebp)
 62a:	e8 c0 fe ff ff       	call   4ef <printint>
 62f:	83 c4 10             	add    $0x10,%esp
        ap++;
 632:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 636:	e9 d8 00 00 00       	jmp    713 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 63b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 63f:	74 06                	je     647 <printf+0xa4>
 641:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 645:	75 1e                	jne    665 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 647:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64a:	8b 00                	mov    (%eax),%eax
 64c:	6a 00                	push   $0x0
 64e:	6a 10                	push   $0x10
 650:	50                   	push   %eax
 651:	ff 75 08             	pushl  0x8(%ebp)
 654:	e8 96 fe ff ff       	call   4ef <printint>
 659:	83 c4 10             	add    $0x10,%esp
        ap++;
 65c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 660:	e9 ae 00 00 00       	jmp    713 <printf+0x170>
      } else if(c == 's'){
 665:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 669:	75 43                	jne    6ae <printf+0x10b>
        s = (char*)*ap;
 66b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 66e:	8b 00                	mov    (%eax),%eax
 670:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 673:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 677:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 67b:	75 25                	jne    6a2 <printf+0xff>
          s = "(null)";
 67d:	c7 45 f4 91 09 00 00 	movl   $0x991,-0xc(%ebp)
        while(*s != 0){
 684:	eb 1c                	jmp    6a2 <printf+0xff>
          putc(fd, *s);
 686:	8b 45 f4             	mov    -0xc(%ebp),%eax
 689:	0f b6 00             	movzbl (%eax),%eax
 68c:	0f be c0             	movsbl %al,%eax
 68f:	83 ec 08             	sub    $0x8,%esp
 692:	50                   	push   %eax
 693:	ff 75 08             	pushl  0x8(%ebp)
 696:	e8 31 fe ff ff       	call   4cc <putc>
 69b:	83 c4 10             	add    $0x10,%esp
          s++;
 69e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a5:	0f b6 00             	movzbl (%eax),%eax
 6a8:	84 c0                	test   %al,%al
 6aa:	75 da                	jne    686 <printf+0xe3>
 6ac:	eb 65                	jmp    713 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6ae:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6b2:	75 1d                	jne    6d1 <printf+0x12e>
        putc(fd, *ap);
 6b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b7:	8b 00                	mov    (%eax),%eax
 6b9:	0f be c0             	movsbl %al,%eax
 6bc:	83 ec 08             	sub    $0x8,%esp
 6bf:	50                   	push   %eax
 6c0:	ff 75 08             	pushl  0x8(%ebp)
 6c3:	e8 04 fe ff ff       	call   4cc <putc>
 6c8:	83 c4 10             	add    $0x10,%esp
        ap++;
 6cb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6cf:	eb 42                	jmp    713 <printf+0x170>
      } else if(c == '%'){
 6d1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6d5:	75 17                	jne    6ee <printf+0x14b>
        putc(fd, c);
 6d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6da:	0f be c0             	movsbl %al,%eax
 6dd:	83 ec 08             	sub    $0x8,%esp
 6e0:	50                   	push   %eax
 6e1:	ff 75 08             	pushl  0x8(%ebp)
 6e4:	e8 e3 fd ff ff       	call   4cc <putc>
 6e9:	83 c4 10             	add    $0x10,%esp
 6ec:	eb 25                	jmp    713 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6ee:	83 ec 08             	sub    $0x8,%esp
 6f1:	6a 25                	push   $0x25
 6f3:	ff 75 08             	pushl  0x8(%ebp)
 6f6:	e8 d1 fd ff ff       	call   4cc <putc>
 6fb:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 701:	0f be c0             	movsbl %al,%eax
 704:	83 ec 08             	sub    $0x8,%esp
 707:	50                   	push   %eax
 708:	ff 75 08             	pushl  0x8(%ebp)
 70b:	e8 bc fd ff ff       	call   4cc <putc>
 710:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 713:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 71a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 71e:	8b 55 0c             	mov    0xc(%ebp),%edx
 721:	8b 45 f0             	mov    -0x10(%ebp),%eax
 724:	01 d0                	add    %edx,%eax
 726:	0f b6 00             	movzbl (%eax),%eax
 729:	84 c0                	test   %al,%al
 72b:	0f 85 94 fe ff ff    	jne    5c5 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 731:	90                   	nop
 732:	c9                   	leave  
 733:	c3                   	ret    

00000734 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 734:	55                   	push   %ebp
 735:	89 e5                	mov    %esp,%ebp
 737:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 73a:	8b 45 08             	mov    0x8(%ebp),%eax
 73d:	83 e8 08             	sub    $0x8,%eax
 740:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 743:	a1 28 0c 00 00       	mov    0xc28,%eax
 748:	89 45 fc             	mov    %eax,-0x4(%ebp)
 74b:	eb 24                	jmp    771 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 74d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 750:	8b 00                	mov    (%eax),%eax
 752:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 755:	77 12                	ja     769 <free+0x35>
 757:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 75d:	77 24                	ja     783 <free+0x4f>
 75f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 762:	8b 00                	mov    (%eax),%eax
 764:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 767:	77 1a                	ja     783 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 769:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76c:	8b 00                	mov    (%eax),%eax
 76e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 771:	8b 45 f8             	mov    -0x8(%ebp),%eax
 774:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 777:	76 d4                	jbe    74d <free+0x19>
 779:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77c:	8b 00                	mov    (%eax),%eax
 77e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 781:	76 ca                	jbe    74d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 783:	8b 45 f8             	mov    -0x8(%ebp),%eax
 786:	8b 40 04             	mov    0x4(%eax),%eax
 789:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 790:	8b 45 f8             	mov    -0x8(%ebp),%eax
 793:	01 c2                	add    %eax,%edx
 795:	8b 45 fc             	mov    -0x4(%ebp),%eax
 798:	8b 00                	mov    (%eax),%eax
 79a:	39 c2                	cmp    %eax,%edx
 79c:	75 24                	jne    7c2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 79e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a1:	8b 50 04             	mov    0x4(%eax),%edx
 7a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a7:	8b 00                	mov    (%eax),%eax
 7a9:	8b 40 04             	mov    0x4(%eax),%eax
 7ac:	01 c2                	add    %eax,%edx
 7ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b7:	8b 00                	mov    (%eax),%eax
 7b9:	8b 10                	mov    (%eax),%edx
 7bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7be:	89 10                	mov    %edx,(%eax)
 7c0:	eb 0a                	jmp    7cc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c5:	8b 10                	mov    (%eax),%edx
 7c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ca:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cf:	8b 40 04             	mov    0x4(%eax),%eax
 7d2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dc:	01 d0                	add    %edx,%eax
 7de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7e1:	75 20                	jne    803 <free+0xcf>
    p->s.size += bp->s.size;
 7e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e6:	8b 50 04             	mov    0x4(%eax),%edx
 7e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ec:	8b 40 04             	mov    0x4(%eax),%eax
 7ef:	01 c2                	add    %eax,%edx
 7f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fa:	8b 10                	mov    (%eax),%edx
 7fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ff:	89 10                	mov    %edx,(%eax)
 801:	eb 08                	jmp    80b <free+0xd7>
  } else
    p->s.ptr = bp;
 803:	8b 45 fc             	mov    -0x4(%ebp),%eax
 806:	8b 55 f8             	mov    -0x8(%ebp),%edx
 809:	89 10                	mov    %edx,(%eax)
  freep = p;
 80b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80e:	a3 28 0c 00 00       	mov    %eax,0xc28
}
 813:	90                   	nop
 814:	c9                   	leave  
 815:	c3                   	ret    

00000816 <morecore>:

static Header*
morecore(uint nu)
{
 816:	55                   	push   %ebp
 817:	89 e5                	mov    %esp,%ebp
 819:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 81c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 823:	77 07                	ja     82c <morecore+0x16>
    nu = 4096;
 825:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 82c:	8b 45 08             	mov    0x8(%ebp),%eax
 82f:	c1 e0 03             	shl    $0x3,%eax
 832:	83 ec 0c             	sub    $0xc,%esp
 835:	50                   	push   %eax
 836:	e8 61 fc ff ff       	call   49c <sbrk>
 83b:	83 c4 10             	add    $0x10,%esp
 83e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 841:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 845:	75 07                	jne    84e <morecore+0x38>
    return 0;
 847:	b8 00 00 00 00       	mov    $0x0,%eax
 84c:	eb 26                	jmp    874 <morecore+0x5e>
  hp = (Header*)p;
 84e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 851:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 854:	8b 45 f0             	mov    -0x10(%ebp),%eax
 857:	8b 55 08             	mov    0x8(%ebp),%edx
 85a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 85d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 860:	83 c0 08             	add    $0x8,%eax
 863:	83 ec 0c             	sub    $0xc,%esp
 866:	50                   	push   %eax
 867:	e8 c8 fe ff ff       	call   734 <free>
 86c:	83 c4 10             	add    $0x10,%esp
  return freep;
 86f:	a1 28 0c 00 00       	mov    0xc28,%eax
}
 874:	c9                   	leave  
 875:	c3                   	ret    

00000876 <malloc>:

void*
malloc(uint nbytes)
{
 876:	55                   	push   %ebp
 877:	89 e5                	mov    %esp,%ebp
 879:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 87c:	8b 45 08             	mov    0x8(%ebp),%eax
 87f:	83 c0 07             	add    $0x7,%eax
 882:	c1 e8 03             	shr    $0x3,%eax
 885:	83 c0 01             	add    $0x1,%eax
 888:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 88b:	a1 28 0c 00 00       	mov    0xc28,%eax
 890:	89 45 f0             	mov    %eax,-0x10(%ebp)
 893:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 897:	75 23                	jne    8bc <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 899:	c7 45 f0 20 0c 00 00 	movl   $0xc20,-0x10(%ebp)
 8a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a3:	a3 28 0c 00 00       	mov    %eax,0xc28
 8a8:	a1 28 0c 00 00       	mov    0xc28,%eax
 8ad:	a3 20 0c 00 00       	mov    %eax,0xc20
    base.s.size = 0;
 8b2:	c7 05 24 0c 00 00 00 	movl   $0x0,0xc24
 8b9:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bf:	8b 00                	mov    (%eax),%eax
 8c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c7:	8b 40 04             	mov    0x4(%eax),%eax
 8ca:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8cd:	72 4d                	jb     91c <malloc+0xa6>
      if(p->s.size == nunits)
 8cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d2:	8b 40 04             	mov    0x4(%eax),%eax
 8d5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8d8:	75 0c                	jne    8e6 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8dd:	8b 10                	mov    (%eax),%edx
 8df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e2:	89 10                	mov    %edx,(%eax)
 8e4:	eb 26                	jmp    90c <malloc+0x96>
      else {
        p->s.size -= nunits;
 8e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e9:	8b 40 04             	mov    0x4(%eax),%eax
 8ec:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8ef:	89 c2                	mov    %eax,%edx
 8f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fa:	8b 40 04             	mov    0x4(%eax),%eax
 8fd:	c1 e0 03             	shl    $0x3,%eax
 900:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 903:	8b 45 f4             	mov    -0xc(%ebp),%eax
 906:	8b 55 ec             	mov    -0x14(%ebp),%edx
 909:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 90c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90f:	a3 28 0c 00 00       	mov    %eax,0xc28
      return (void*)(p + 1);
 914:	8b 45 f4             	mov    -0xc(%ebp),%eax
 917:	83 c0 08             	add    $0x8,%eax
 91a:	eb 3b                	jmp    957 <malloc+0xe1>
    }
    if(p == freep)
 91c:	a1 28 0c 00 00       	mov    0xc28,%eax
 921:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 924:	75 1e                	jne    944 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 926:	83 ec 0c             	sub    $0xc,%esp
 929:	ff 75 ec             	pushl  -0x14(%ebp)
 92c:	e8 e5 fe ff ff       	call   816 <morecore>
 931:	83 c4 10             	add    $0x10,%esp
 934:	89 45 f4             	mov    %eax,-0xc(%ebp)
 937:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 93b:	75 07                	jne    944 <malloc+0xce>
        return 0;
 93d:	b8 00 00 00 00       	mov    $0x0,%eax
 942:	eb 13                	jmp    957 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 944:	8b 45 f4             	mov    -0xc(%ebp),%eax
 947:	89 45 f0             	mov    %eax,-0x10(%ebp)
 94a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94d:	8b 00                	mov    (%eax),%eax
 94f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 952:	e9 6d ff ff ff       	jmp    8c4 <malloc+0x4e>
}
 957:	c9                   	leave  
 958:	c3                   	ret    
