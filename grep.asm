
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n, m;
  char *p, *q;

  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
   d:	e9 b6 00 00 00       	jmp    c8 <grep+0xc8>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    buf[m] = '\0';
  18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1b:	05 20 0e 00 00       	add    $0xe20,%eax
  20:	c6 00 00             	movb   $0x0,(%eax)
    p = buf;
  23:	c7 45 f0 20 0e 00 00 	movl   $0xe20,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  2a:	eb 4a                	jmp    76 <grep+0x76>
      *q = 0;
  2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  2f:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  32:	83 ec 08             	sub    $0x8,%esp
  35:	ff 75 f0             	pushl  -0x10(%ebp)
  38:	ff 75 08             	pushl  0x8(%ebp)
  3b:	e8 9a 01 00 00       	call   1da <match>
  40:	83 c4 10             	add    $0x10,%esp
  43:	85 c0                	test   %eax,%eax
  45:	74 26                	je     6d <grep+0x6d>
        *q = '\n';
  47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  4a:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  50:	83 c0 01             	add    $0x1,%eax
  53:	89 c2                	mov    %eax,%edx
  55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  58:	29 c2                	sub    %eax,%edx
  5a:	89 d0                	mov    %edx,%eax
  5c:	83 ec 04             	sub    $0x4,%esp
  5f:	50                   	push   %eax
  60:	ff 75 f0             	pushl  -0x10(%ebp)
  63:	6a 01                	push   $0x1
  65:	e8 43 05 00 00       	call   5ad <write>
  6a:	83 c4 10             	add    $0x10,%esp
      }
      p = q+1;
  6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  70:	83 c0 01             	add    $0x1,%eax
  73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    m += n;
    buf[m] = '\0';
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  76:	83 ec 08             	sub    $0x8,%esp
  79:	6a 0a                	push   $0xa
  7b:	ff 75 f0             	pushl  -0x10(%ebp)
  7e:	e8 89 03 00 00       	call   40c <strchr>
  83:	83 c4 10             	add    $0x10,%esp
  86:	89 45 e8             	mov    %eax,-0x18(%ebp)
  89:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8d:	75 9d                	jne    2c <grep+0x2c>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  8f:	81 7d f0 20 0e 00 00 	cmpl   $0xe20,-0x10(%ebp)
  96:	75 07                	jne    9f <grep+0x9f>
      m = 0;
  98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a3:	7e 23                	jle    c8 <grep+0xc8>
      m -= p - buf;
  a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  a8:	ba 20 0e 00 00       	mov    $0xe20,%edx
  ad:	29 d0                	sub    %edx,%eax
  af:	29 45 f4             	sub    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  b2:	83 ec 04             	sub    $0x4,%esp
  b5:	ff 75 f4             	pushl  -0xc(%ebp)
  b8:	ff 75 f0             	pushl  -0x10(%ebp)
  bb:	68 20 0e 00 00       	push   $0xe20
  c0:	e8 83 04 00 00       	call   548 <memmove>
  c5:	83 c4 10             	add    $0x10,%esp
{
  int n, m;
  char *p, *q;

  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  cb:	ba ff 03 00 00       	mov    $0x3ff,%edx
  d0:	29 c2                	sub    %eax,%edx
  d2:	89 d0                	mov    %edx,%eax
  d4:	89 c2                	mov    %eax,%edx
  d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d9:	05 20 0e 00 00       	add    $0xe20,%eax
  de:	83 ec 04             	sub    $0x4,%esp
  e1:	52                   	push   %edx
  e2:	50                   	push   %eax
  e3:	ff 75 0c             	pushl  0xc(%ebp)
  e6:	e8 ba 04 00 00       	call   5a5 <read>
  eb:	83 c4 10             	add    $0x10,%esp
  ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  f5:	0f 8f 17 ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
  fb:	90                   	nop
  fc:	c9                   	leave  
  fd:	c3                   	ret    

000000fe <main>:

int
main(int argc, char *argv[])
{
  fe:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 102:	83 e4 f0             	and    $0xfffffff0,%esp
 105:	ff 71 fc             	pushl  -0x4(%ecx)
 108:	55                   	push   %ebp
 109:	89 e5                	mov    %esp,%ebp
 10b:	53                   	push   %ebx
 10c:	51                   	push   %ecx
 10d:	83 ec 10             	sub    $0x10,%esp
 110:	89 cb                	mov    %ecx,%ebx
  int fd, i;
  char *pattern;

  if(argc <= 1){
 112:	83 3b 01             	cmpl   $0x1,(%ebx)
 115:	7f 17                	jg     12e <main+0x30>
    printf(2, "usage: grep pattern [file ...]\n");
 117:	83 ec 08             	sub    $0x8,%esp
 11a:	68 d4 0a 00 00       	push   $0xad4
 11f:	6a 02                	push   $0x2
 121:	e8 f6 05 00 00       	call   71c <printf>
 126:	83 c4 10             	add    $0x10,%esp
    exit();
 129:	e8 5f 04 00 00       	call   58d <exit>
  }
  pattern = argv[1];
 12e:	8b 43 04             	mov    0x4(%ebx),%eax
 131:	8b 40 04             	mov    0x4(%eax),%eax
 134:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(argc <= 2){
 137:	83 3b 02             	cmpl   $0x2,(%ebx)
 13a:	7f 15                	jg     151 <main+0x53>
    grep(pattern, 0);
 13c:	83 ec 08             	sub    $0x8,%esp
 13f:	6a 00                	push   $0x0
 141:	ff 75 f0             	pushl  -0x10(%ebp)
 144:	e8 b7 fe ff ff       	call   0 <grep>
 149:	83 c4 10             	add    $0x10,%esp
    exit();
 14c:	e8 3c 04 00 00       	call   58d <exit>
  }

  for(i = 2; i < argc; i++){
 151:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
 158:	eb 74                	jmp    1ce <main+0xd0>
    if((fd = open(argv[i], 0)) < 0){
 15a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 164:	8b 43 04             	mov    0x4(%ebx),%eax
 167:	01 d0                	add    %edx,%eax
 169:	8b 00                	mov    (%eax),%eax
 16b:	83 ec 08             	sub    $0x8,%esp
 16e:	6a 00                	push   $0x0
 170:	50                   	push   %eax
 171:	e8 57 04 00 00       	call   5cd <open>
 176:	83 c4 10             	add    $0x10,%esp
 179:	89 45 ec             	mov    %eax,-0x14(%ebp)
 17c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 180:	79 29                	jns    1ab <main+0xad>
      printf(1, "grep: cannot open %s\n", argv[i]);
 182:	8b 45 f4             	mov    -0xc(%ebp),%eax
 185:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 18c:	8b 43 04             	mov    0x4(%ebx),%eax
 18f:	01 d0                	add    %edx,%eax
 191:	8b 00                	mov    (%eax),%eax
 193:	83 ec 04             	sub    $0x4,%esp
 196:	50                   	push   %eax
 197:	68 f4 0a 00 00       	push   $0xaf4
 19c:	6a 01                	push   $0x1
 19e:	e8 79 05 00 00       	call   71c <printf>
 1a3:	83 c4 10             	add    $0x10,%esp
      exit();
 1a6:	e8 e2 03 00 00       	call   58d <exit>
    }
    grep(pattern, fd);
 1ab:	83 ec 08             	sub    $0x8,%esp
 1ae:	ff 75 ec             	pushl  -0x14(%ebp)
 1b1:	ff 75 f0             	pushl  -0x10(%ebp)
 1b4:	e8 47 fe ff ff       	call   0 <grep>
 1b9:	83 c4 10             	add    $0x10,%esp
    close(fd);
 1bc:	83 ec 0c             	sub    $0xc,%esp
 1bf:	ff 75 ec             	pushl  -0x14(%ebp)
 1c2:	e8 ee 03 00 00       	call   5b5 <close>
 1c7:	83 c4 10             	add    $0x10,%esp
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 1ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d1:	3b 03                	cmp    (%ebx),%eax
 1d3:	7c 85                	jl     15a <main+0x5c>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 1d5:	e8 b3 03 00 00       	call   58d <exit>

000001da <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1da:	55                   	push   %ebp
 1db:	89 e5                	mov    %esp,%ebp
 1dd:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '^')
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	0f b6 00             	movzbl (%eax),%eax
 1e6:	3c 5e                	cmp    $0x5e,%al
 1e8:	75 17                	jne    201 <match+0x27>
    return matchhere(re+1, text);
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	83 c0 01             	add    $0x1,%eax
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	ff 75 0c             	pushl  0xc(%ebp)
 1f6:	50                   	push   %eax
 1f7:	e8 38 00 00 00       	call   234 <matchhere>
 1fc:	83 c4 10             	add    $0x10,%esp
 1ff:	eb 31                	jmp    232 <match+0x58>
  do{  // must look at empty string
    if(matchhere(re, text))
 201:	83 ec 08             	sub    $0x8,%esp
 204:	ff 75 0c             	pushl  0xc(%ebp)
 207:	ff 75 08             	pushl  0x8(%ebp)
 20a:	e8 25 00 00 00       	call   234 <matchhere>
 20f:	83 c4 10             	add    $0x10,%esp
 212:	85 c0                	test   %eax,%eax
 214:	74 07                	je     21d <match+0x43>
      return 1;
 216:	b8 01 00 00 00       	mov    $0x1,%eax
 21b:	eb 15                	jmp    232 <match+0x58>
  }while(*text++ != '\0');
 21d:	8b 45 0c             	mov    0xc(%ebp),%eax
 220:	8d 50 01             	lea    0x1(%eax),%edx
 223:	89 55 0c             	mov    %edx,0xc(%ebp)
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	84 c0                	test   %al,%al
 22b:	75 d4                	jne    201 <match+0x27>
  return 0;
 22d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 232:	c9                   	leave  
 233:	c3                   	ret    

00000234 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
 237:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '\0')
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	0f b6 00             	movzbl (%eax),%eax
 240:	84 c0                	test   %al,%al
 242:	75 0a                	jne    24e <matchhere+0x1a>
    return 1;
 244:	b8 01 00 00 00       	mov    $0x1,%eax
 249:	e9 99 00 00 00       	jmp    2e7 <matchhere+0xb3>
  if(re[1] == '*')
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	83 c0 01             	add    $0x1,%eax
 254:	0f b6 00             	movzbl (%eax),%eax
 257:	3c 2a                	cmp    $0x2a,%al
 259:	75 21                	jne    27c <matchhere+0x48>
    return matchstar(re[0], re+2, text);
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	8d 50 02             	lea    0x2(%eax),%edx
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	0f b6 00             	movzbl (%eax),%eax
 267:	0f be c0             	movsbl %al,%eax
 26a:	83 ec 04             	sub    $0x4,%esp
 26d:	ff 75 0c             	pushl  0xc(%ebp)
 270:	52                   	push   %edx
 271:	50                   	push   %eax
 272:	e8 72 00 00 00       	call   2e9 <matchstar>
 277:	83 c4 10             	add    $0x10,%esp
 27a:	eb 6b                	jmp    2e7 <matchhere+0xb3>
  if(re[0] == '$' && re[1] == '\0')
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	0f b6 00             	movzbl (%eax),%eax
 282:	3c 24                	cmp    $0x24,%al
 284:	75 1d                	jne    2a3 <matchhere+0x6f>
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	83 c0 01             	add    $0x1,%eax
 28c:	0f b6 00             	movzbl (%eax),%eax
 28f:	84 c0                	test   %al,%al
 291:	75 10                	jne    2a3 <matchhere+0x6f>
    return *text == '\0';
 293:	8b 45 0c             	mov    0xc(%ebp),%eax
 296:	0f b6 00             	movzbl (%eax),%eax
 299:	84 c0                	test   %al,%al
 29b:	0f 94 c0             	sete   %al
 29e:	0f b6 c0             	movzbl %al,%eax
 2a1:	eb 44                	jmp    2e7 <matchhere+0xb3>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a6:	0f b6 00             	movzbl (%eax),%eax
 2a9:	84 c0                	test   %al,%al
 2ab:	74 35                	je     2e2 <matchhere+0xae>
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	0f b6 00             	movzbl (%eax),%eax
 2b3:	3c 2e                	cmp    $0x2e,%al
 2b5:	74 10                	je     2c7 <matchhere+0x93>
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	0f b6 10             	movzbl (%eax),%edx
 2bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c0:	0f b6 00             	movzbl (%eax),%eax
 2c3:	38 c2                	cmp    %al,%dl
 2c5:	75 1b                	jne    2e2 <matchhere+0xae>
    return matchhere(re+1, text+1);
 2c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ca:	8d 50 01             	lea    0x1(%eax),%edx
 2cd:	8b 45 08             	mov    0x8(%ebp),%eax
 2d0:	83 c0 01             	add    $0x1,%eax
 2d3:	83 ec 08             	sub    $0x8,%esp
 2d6:	52                   	push   %edx
 2d7:	50                   	push   %eax
 2d8:	e8 57 ff ff ff       	call   234 <matchhere>
 2dd:	83 c4 10             	add    $0x10,%esp
 2e0:	eb 05                	jmp    2e7 <matchhere+0xb3>
  return 0;
 2e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2e7:	c9                   	leave  
 2e8:	c3                   	ret    

000002e9 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 2e9:	55                   	push   %ebp
 2ea:	89 e5                	mov    %esp,%ebp
 2ec:	83 ec 08             	sub    $0x8,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 2ef:	83 ec 08             	sub    $0x8,%esp
 2f2:	ff 75 10             	pushl  0x10(%ebp)
 2f5:	ff 75 0c             	pushl  0xc(%ebp)
 2f8:	e8 37 ff ff ff       	call   234 <matchhere>
 2fd:	83 c4 10             	add    $0x10,%esp
 300:	85 c0                	test   %eax,%eax
 302:	74 07                	je     30b <matchstar+0x22>
      return 1;
 304:	b8 01 00 00 00       	mov    $0x1,%eax
 309:	eb 29                	jmp    334 <matchstar+0x4b>
  }while(*text!='\0' && (*text++==c || c=='.'));
 30b:	8b 45 10             	mov    0x10(%ebp),%eax
 30e:	0f b6 00             	movzbl (%eax),%eax
 311:	84 c0                	test   %al,%al
 313:	74 1a                	je     32f <matchstar+0x46>
 315:	8b 45 10             	mov    0x10(%ebp),%eax
 318:	8d 50 01             	lea    0x1(%eax),%edx
 31b:	89 55 10             	mov    %edx,0x10(%ebp)
 31e:	0f b6 00             	movzbl (%eax),%eax
 321:	0f be c0             	movsbl %al,%eax
 324:	3b 45 08             	cmp    0x8(%ebp),%eax
 327:	74 c6                	je     2ef <matchstar+0x6>
 329:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 32d:	74 c0                	je     2ef <matchstar+0x6>
  return 0;
 32f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 334:	c9                   	leave  
 335:	c3                   	ret    

00000336 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 336:	55                   	push   %ebp
 337:	89 e5                	mov    %esp,%ebp
 339:	57                   	push   %edi
 33a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 33b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 33e:	8b 55 10             	mov    0x10(%ebp),%edx
 341:	8b 45 0c             	mov    0xc(%ebp),%eax
 344:	89 cb                	mov    %ecx,%ebx
 346:	89 df                	mov    %ebx,%edi
 348:	89 d1                	mov    %edx,%ecx
 34a:	fc                   	cld    
 34b:	f3 aa                	rep stos %al,%es:(%edi)
 34d:	89 ca                	mov    %ecx,%edx
 34f:	89 fb                	mov    %edi,%ebx
 351:	89 5d 08             	mov    %ebx,0x8(%ebp)
 354:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 357:	90                   	nop
 358:	5b                   	pop    %ebx
 359:	5f                   	pop    %edi
 35a:	5d                   	pop    %ebp
 35b:	c3                   	ret    

0000035c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 362:	8b 45 08             	mov    0x8(%ebp),%eax
 365:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 368:	90                   	nop
 369:	8b 45 08             	mov    0x8(%ebp),%eax
 36c:	8d 50 01             	lea    0x1(%eax),%edx
 36f:	89 55 08             	mov    %edx,0x8(%ebp)
 372:	8b 55 0c             	mov    0xc(%ebp),%edx
 375:	8d 4a 01             	lea    0x1(%edx),%ecx
 378:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 37b:	0f b6 12             	movzbl (%edx),%edx
 37e:	88 10                	mov    %dl,(%eax)
 380:	0f b6 00             	movzbl (%eax),%eax
 383:	84 c0                	test   %al,%al
 385:	75 e2                	jne    369 <strcpy+0xd>
    ;
  return os;
 387:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 38a:	c9                   	leave  
 38b:	c3                   	ret    

0000038c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 38c:	55                   	push   %ebp
 38d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 38f:	eb 08                	jmp    399 <strcmp+0xd>
    p++, q++;
 391:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 395:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 399:	8b 45 08             	mov    0x8(%ebp),%eax
 39c:	0f b6 00             	movzbl (%eax),%eax
 39f:	84 c0                	test   %al,%al
 3a1:	74 10                	je     3b3 <strcmp+0x27>
 3a3:	8b 45 08             	mov    0x8(%ebp),%eax
 3a6:	0f b6 10             	movzbl (%eax),%edx
 3a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ac:	0f b6 00             	movzbl (%eax),%eax
 3af:	38 c2                	cmp    %al,%dl
 3b1:	74 de                	je     391 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	0f b6 00             	movzbl (%eax),%eax
 3b9:	0f b6 d0             	movzbl %al,%edx
 3bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bf:	0f b6 00             	movzbl (%eax),%eax
 3c2:	0f b6 c0             	movzbl %al,%eax
 3c5:	29 c2                	sub    %eax,%edx
 3c7:	89 d0                	mov    %edx,%eax
}
 3c9:	5d                   	pop    %ebp
 3ca:	c3                   	ret    

000003cb <strlen>:

uint
strlen(char *s)
{
 3cb:	55                   	push   %ebp
 3cc:	89 e5                	mov    %esp,%ebp
 3ce:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3d8:	eb 04                	jmp    3de <strlen+0x13>
 3da:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3de:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3e1:	8b 45 08             	mov    0x8(%ebp),%eax
 3e4:	01 d0                	add    %edx,%eax
 3e6:	0f b6 00             	movzbl (%eax),%eax
 3e9:	84 c0                	test   %al,%al
 3eb:	75 ed                	jne    3da <strlen+0xf>
    ;
  return n;
 3ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3f0:	c9                   	leave  
 3f1:	c3                   	ret    

000003f2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3f2:	55                   	push   %ebp
 3f3:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3f5:	8b 45 10             	mov    0x10(%ebp),%eax
 3f8:	50                   	push   %eax
 3f9:	ff 75 0c             	pushl  0xc(%ebp)
 3fc:	ff 75 08             	pushl  0x8(%ebp)
 3ff:	e8 32 ff ff ff       	call   336 <stosb>
 404:	83 c4 0c             	add    $0xc,%esp
  return dst;
 407:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40a:	c9                   	leave  
 40b:	c3                   	ret    

0000040c <strchr>:

char*
strchr(const char *s, char c)
{
 40c:	55                   	push   %ebp
 40d:	89 e5                	mov    %esp,%ebp
 40f:	83 ec 04             	sub    $0x4,%esp
 412:	8b 45 0c             	mov    0xc(%ebp),%eax
 415:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 418:	eb 14                	jmp    42e <strchr+0x22>
    if(*s == c)
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
 41d:	0f b6 00             	movzbl (%eax),%eax
 420:	3a 45 fc             	cmp    -0x4(%ebp),%al
 423:	75 05                	jne    42a <strchr+0x1e>
      return (char*)s;
 425:	8b 45 08             	mov    0x8(%ebp),%eax
 428:	eb 13                	jmp    43d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 42a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 42e:	8b 45 08             	mov    0x8(%ebp),%eax
 431:	0f b6 00             	movzbl (%eax),%eax
 434:	84 c0                	test   %al,%al
 436:	75 e2                	jne    41a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 438:	b8 00 00 00 00       	mov    $0x0,%eax
}
 43d:	c9                   	leave  
 43e:	c3                   	ret    

0000043f <gets>:

char*
gets(char *buf, int max)
{
 43f:	55                   	push   %ebp
 440:	89 e5                	mov    %esp,%ebp
 442:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 445:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 44c:	eb 42                	jmp    490 <gets+0x51>
    cc = read(0, &c, 1);
 44e:	83 ec 04             	sub    $0x4,%esp
 451:	6a 01                	push   $0x1
 453:	8d 45 ef             	lea    -0x11(%ebp),%eax
 456:	50                   	push   %eax
 457:	6a 00                	push   $0x0
 459:	e8 47 01 00 00       	call   5a5 <read>
 45e:	83 c4 10             	add    $0x10,%esp
 461:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 464:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 468:	7e 33                	jle    49d <gets+0x5e>
      break;
    buf[i++] = c;
 46a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46d:	8d 50 01             	lea    0x1(%eax),%edx
 470:	89 55 f4             	mov    %edx,-0xc(%ebp)
 473:	89 c2                	mov    %eax,%edx
 475:	8b 45 08             	mov    0x8(%ebp),%eax
 478:	01 c2                	add    %eax,%edx
 47a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 47e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 480:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 484:	3c 0a                	cmp    $0xa,%al
 486:	74 16                	je     49e <gets+0x5f>
 488:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 48c:	3c 0d                	cmp    $0xd,%al
 48e:	74 0e                	je     49e <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 490:	8b 45 f4             	mov    -0xc(%ebp),%eax
 493:	83 c0 01             	add    $0x1,%eax
 496:	3b 45 0c             	cmp    0xc(%ebp),%eax
 499:	7c b3                	jl     44e <gets+0xf>
 49b:	eb 01                	jmp    49e <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 49d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 49e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4a1:	8b 45 08             	mov    0x8(%ebp),%eax
 4a4:	01 d0                	add    %edx,%eax
 4a6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4ac:	c9                   	leave  
 4ad:	c3                   	ret    

000004ae <stat>:

int
stat(char *n, struct stat *st)
{
 4ae:	55                   	push   %ebp
 4af:	89 e5                	mov    %esp,%ebp
 4b1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4b4:	83 ec 08             	sub    $0x8,%esp
 4b7:	6a 00                	push   $0x0
 4b9:	ff 75 08             	pushl  0x8(%ebp)
 4bc:	e8 0c 01 00 00       	call   5cd <open>
 4c1:	83 c4 10             	add    $0x10,%esp
 4c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4cb:	79 07                	jns    4d4 <stat+0x26>
    return -1;
 4cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4d2:	eb 25                	jmp    4f9 <stat+0x4b>
  r = fstat(fd, st);
 4d4:	83 ec 08             	sub    $0x8,%esp
 4d7:	ff 75 0c             	pushl  0xc(%ebp)
 4da:	ff 75 f4             	pushl  -0xc(%ebp)
 4dd:	e8 03 01 00 00       	call   5e5 <fstat>
 4e2:	83 c4 10             	add    $0x10,%esp
 4e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4e8:	83 ec 0c             	sub    $0xc,%esp
 4eb:	ff 75 f4             	pushl  -0xc(%ebp)
 4ee:	e8 c2 00 00 00       	call   5b5 <close>
 4f3:	83 c4 10             	add    $0x10,%esp
  return r;
 4f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4f9:	c9                   	leave  
 4fa:	c3                   	ret    

000004fb <atoi>:

int
atoi(const char *s)
{
 4fb:	55                   	push   %ebp
 4fc:	89 e5                	mov    %esp,%ebp
 4fe:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 501:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 508:	eb 25                	jmp    52f <atoi+0x34>
    n = n*10 + *s++ - '0';
 50a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 50d:	89 d0                	mov    %edx,%eax
 50f:	c1 e0 02             	shl    $0x2,%eax
 512:	01 d0                	add    %edx,%eax
 514:	01 c0                	add    %eax,%eax
 516:	89 c1                	mov    %eax,%ecx
 518:	8b 45 08             	mov    0x8(%ebp),%eax
 51b:	8d 50 01             	lea    0x1(%eax),%edx
 51e:	89 55 08             	mov    %edx,0x8(%ebp)
 521:	0f b6 00             	movzbl (%eax),%eax
 524:	0f be c0             	movsbl %al,%eax
 527:	01 c8                	add    %ecx,%eax
 529:	83 e8 30             	sub    $0x30,%eax
 52c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 52f:	8b 45 08             	mov    0x8(%ebp),%eax
 532:	0f b6 00             	movzbl (%eax),%eax
 535:	3c 2f                	cmp    $0x2f,%al
 537:	7e 0a                	jle    543 <atoi+0x48>
 539:	8b 45 08             	mov    0x8(%ebp),%eax
 53c:	0f b6 00             	movzbl (%eax),%eax
 53f:	3c 39                	cmp    $0x39,%al
 541:	7e c7                	jle    50a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 543:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 546:	c9                   	leave  
 547:	c3                   	ret    

00000548 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 548:	55                   	push   %ebp
 549:	89 e5                	mov    %esp,%ebp
 54b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 54e:	8b 45 08             	mov    0x8(%ebp),%eax
 551:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 554:	8b 45 0c             	mov    0xc(%ebp),%eax
 557:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 55a:	eb 17                	jmp    573 <memmove+0x2b>
    *dst++ = *src++;
 55c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 55f:	8d 50 01             	lea    0x1(%eax),%edx
 562:	89 55 fc             	mov    %edx,-0x4(%ebp)
 565:	8b 55 f8             	mov    -0x8(%ebp),%edx
 568:	8d 4a 01             	lea    0x1(%edx),%ecx
 56b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 56e:	0f b6 12             	movzbl (%edx),%edx
 571:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 573:	8b 45 10             	mov    0x10(%ebp),%eax
 576:	8d 50 ff             	lea    -0x1(%eax),%edx
 579:	89 55 10             	mov    %edx,0x10(%ebp)
 57c:	85 c0                	test   %eax,%eax
 57e:	7f dc                	jg     55c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 580:	8b 45 08             	mov    0x8(%ebp),%eax
}
 583:	c9                   	leave  
 584:	c3                   	ret    

00000585 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 585:	b8 01 00 00 00       	mov    $0x1,%eax
 58a:	cd 40                	int    $0x40
 58c:	c3                   	ret    

0000058d <exit>:
SYSCALL(exit)
 58d:	b8 02 00 00 00       	mov    $0x2,%eax
 592:	cd 40                	int    $0x40
 594:	c3                   	ret    

00000595 <wait>:
SYSCALL(wait)
 595:	b8 03 00 00 00       	mov    $0x3,%eax
 59a:	cd 40                	int    $0x40
 59c:	c3                   	ret    

0000059d <pipe>:
SYSCALL(pipe)
 59d:	b8 04 00 00 00       	mov    $0x4,%eax
 5a2:	cd 40                	int    $0x40
 5a4:	c3                   	ret    

000005a5 <read>:
SYSCALL(read)
 5a5:	b8 05 00 00 00       	mov    $0x5,%eax
 5aa:	cd 40                	int    $0x40
 5ac:	c3                   	ret    

000005ad <write>:
SYSCALL(write)
 5ad:	b8 10 00 00 00       	mov    $0x10,%eax
 5b2:	cd 40                	int    $0x40
 5b4:	c3                   	ret    

000005b5 <close>:
SYSCALL(close)
 5b5:	b8 15 00 00 00       	mov    $0x15,%eax
 5ba:	cd 40                	int    $0x40
 5bc:	c3                   	ret    

000005bd <kill>:
SYSCALL(kill)
 5bd:	b8 06 00 00 00       	mov    $0x6,%eax
 5c2:	cd 40                	int    $0x40
 5c4:	c3                   	ret    

000005c5 <exec>:
SYSCALL(exec)
 5c5:	b8 07 00 00 00       	mov    $0x7,%eax
 5ca:	cd 40                	int    $0x40
 5cc:	c3                   	ret    

000005cd <open>:
SYSCALL(open)
 5cd:	b8 0f 00 00 00       	mov    $0xf,%eax
 5d2:	cd 40                	int    $0x40
 5d4:	c3                   	ret    

000005d5 <mknod>:
SYSCALL(mknod)
 5d5:	b8 11 00 00 00       	mov    $0x11,%eax
 5da:	cd 40                	int    $0x40
 5dc:	c3                   	ret    

000005dd <unlink>:
SYSCALL(unlink)
 5dd:	b8 12 00 00 00       	mov    $0x12,%eax
 5e2:	cd 40                	int    $0x40
 5e4:	c3                   	ret    

000005e5 <fstat>:
SYSCALL(fstat)
 5e5:	b8 08 00 00 00       	mov    $0x8,%eax
 5ea:	cd 40                	int    $0x40
 5ec:	c3                   	ret    

000005ed <link>:
SYSCALL(link)
 5ed:	b8 13 00 00 00       	mov    $0x13,%eax
 5f2:	cd 40                	int    $0x40
 5f4:	c3                   	ret    

000005f5 <mkdir>:
SYSCALL(mkdir)
 5f5:	b8 14 00 00 00       	mov    $0x14,%eax
 5fa:	cd 40                	int    $0x40
 5fc:	c3                   	ret    

000005fd <chdir>:
SYSCALL(chdir)
 5fd:	b8 09 00 00 00       	mov    $0x9,%eax
 602:	cd 40                	int    $0x40
 604:	c3                   	ret    

00000605 <dup>:
SYSCALL(dup)
 605:	b8 0a 00 00 00       	mov    $0xa,%eax
 60a:	cd 40                	int    $0x40
 60c:	c3                   	ret    

0000060d <getpid>:
SYSCALL(getpid)
 60d:	b8 0b 00 00 00       	mov    $0xb,%eax
 612:	cd 40                	int    $0x40
 614:	c3                   	ret    

00000615 <sbrk>:
SYSCALL(sbrk)
 615:	b8 0c 00 00 00       	mov    $0xc,%eax
 61a:	cd 40                	int    $0x40
 61c:	c3                   	ret    

0000061d <sleep>:
SYSCALL(sleep)
 61d:	b8 0d 00 00 00       	mov    $0xd,%eax
 622:	cd 40                	int    $0x40
 624:	c3                   	ret    

00000625 <uptime>:
SYSCALL(uptime)
 625:	b8 0e 00 00 00       	mov    $0xe,%eax
 62a:	cd 40                	int    $0x40
 62c:	c3                   	ret    

0000062d <sigprocmask>:
SYSCALL(sigprocmask)
 62d:	b8 16 00 00 00       	mov    $0x16,%eax
 632:	cd 40                	int    $0x40
 634:	c3                   	ret    

00000635 <signal>:
SYSCALL(signal)
 635:	b8 17 00 00 00       	mov    $0x17,%eax
 63a:	cd 40                	int    $0x40
 63c:	c3                   	ret    

0000063d <sigret>:
SYSCALL(sigret)
 63d:	b8 18 00 00 00       	mov    $0x18,%eax
 642:	cd 40                	int    $0x40
 644:	c3                   	ret    

00000645 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 645:	55                   	push   %ebp
 646:	89 e5                	mov    %esp,%ebp
 648:	83 ec 18             	sub    $0x18,%esp
 64b:	8b 45 0c             	mov    0xc(%ebp),%eax
 64e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 651:	83 ec 04             	sub    $0x4,%esp
 654:	6a 01                	push   $0x1
 656:	8d 45 f4             	lea    -0xc(%ebp),%eax
 659:	50                   	push   %eax
 65a:	ff 75 08             	pushl  0x8(%ebp)
 65d:	e8 4b ff ff ff       	call   5ad <write>
 662:	83 c4 10             	add    $0x10,%esp
}
 665:	90                   	nop
 666:	c9                   	leave  
 667:	c3                   	ret    

00000668 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 668:	55                   	push   %ebp
 669:	89 e5                	mov    %esp,%ebp
 66b:	53                   	push   %ebx
 66c:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 66f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 676:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 67a:	74 17                	je     693 <printint+0x2b>
 67c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 680:	79 11                	jns    693 <printint+0x2b>
    neg = 1;
 682:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 689:	8b 45 0c             	mov    0xc(%ebp),%eax
 68c:	f7 d8                	neg    %eax
 68e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 691:	eb 06                	jmp    699 <printint+0x31>
  } else {
    x = xx;
 693:	8b 45 0c             	mov    0xc(%ebp),%eax
 696:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 699:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6a0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 6a3:	8d 41 01             	lea    0x1(%ecx),%eax
 6a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6af:	ba 00 00 00 00       	mov    $0x0,%edx
 6b4:	f7 f3                	div    %ebx
 6b6:	89 d0                	mov    %edx,%eax
 6b8:	0f b6 80 e0 0d 00 00 	movzbl 0xde0(%eax),%eax
 6bf:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6c9:	ba 00 00 00 00       	mov    $0x0,%edx
 6ce:	f7 f3                	div    %ebx
 6d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6d7:	75 c7                	jne    6a0 <printint+0x38>
  if(neg)
 6d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6dd:	74 2d                	je     70c <printint+0xa4>
    buf[i++] = '-';
 6df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e2:	8d 50 01             	lea    0x1(%eax),%edx
 6e5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6e8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6ed:	eb 1d                	jmp    70c <printint+0xa4>
    putc(fd, buf[i]);
 6ef:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f5:	01 d0                	add    %edx,%eax
 6f7:	0f b6 00             	movzbl (%eax),%eax
 6fa:	0f be c0             	movsbl %al,%eax
 6fd:	83 ec 08             	sub    $0x8,%esp
 700:	50                   	push   %eax
 701:	ff 75 08             	pushl  0x8(%ebp)
 704:	e8 3c ff ff ff       	call   645 <putc>
 709:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 70c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 710:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 714:	79 d9                	jns    6ef <printint+0x87>
    putc(fd, buf[i]);
}
 716:	90                   	nop
 717:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 71a:	c9                   	leave  
 71b:	c3                   	ret    

0000071c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 71c:	55                   	push   %ebp
 71d:	89 e5                	mov    %esp,%ebp
 71f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 722:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 729:	8d 45 0c             	lea    0xc(%ebp),%eax
 72c:	83 c0 04             	add    $0x4,%eax
 72f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 732:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 739:	e9 59 01 00 00       	jmp    897 <printf+0x17b>
    c = fmt[i] & 0xff;
 73e:	8b 55 0c             	mov    0xc(%ebp),%edx
 741:	8b 45 f0             	mov    -0x10(%ebp),%eax
 744:	01 d0                	add    %edx,%eax
 746:	0f b6 00             	movzbl (%eax),%eax
 749:	0f be c0             	movsbl %al,%eax
 74c:	25 ff 00 00 00       	and    $0xff,%eax
 751:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 754:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 758:	75 2c                	jne    786 <printf+0x6a>
      if(c == '%'){
 75a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 75e:	75 0c                	jne    76c <printf+0x50>
        state = '%';
 760:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 767:	e9 27 01 00 00       	jmp    893 <printf+0x177>
      } else {
        putc(fd, c);
 76c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 76f:	0f be c0             	movsbl %al,%eax
 772:	83 ec 08             	sub    $0x8,%esp
 775:	50                   	push   %eax
 776:	ff 75 08             	pushl  0x8(%ebp)
 779:	e8 c7 fe ff ff       	call   645 <putc>
 77e:	83 c4 10             	add    $0x10,%esp
 781:	e9 0d 01 00 00       	jmp    893 <printf+0x177>
      }
    } else if(state == '%'){
 786:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 78a:	0f 85 03 01 00 00    	jne    893 <printf+0x177>
      if(c == 'd'){
 790:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 794:	75 1e                	jne    7b4 <printf+0x98>
        printint(fd, *ap, 10, 1);
 796:	8b 45 e8             	mov    -0x18(%ebp),%eax
 799:	8b 00                	mov    (%eax),%eax
 79b:	6a 01                	push   $0x1
 79d:	6a 0a                	push   $0xa
 79f:	50                   	push   %eax
 7a0:	ff 75 08             	pushl  0x8(%ebp)
 7a3:	e8 c0 fe ff ff       	call   668 <printint>
 7a8:	83 c4 10             	add    $0x10,%esp
        ap++;
 7ab:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7af:	e9 d8 00 00 00       	jmp    88c <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7b4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7b8:	74 06                	je     7c0 <printf+0xa4>
 7ba:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7be:	75 1e                	jne    7de <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c3:	8b 00                	mov    (%eax),%eax
 7c5:	6a 00                	push   $0x0
 7c7:	6a 10                	push   $0x10
 7c9:	50                   	push   %eax
 7ca:	ff 75 08             	pushl  0x8(%ebp)
 7cd:	e8 96 fe ff ff       	call   668 <printint>
 7d2:	83 c4 10             	add    $0x10,%esp
        ap++;
 7d5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7d9:	e9 ae 00 00 00       	jmp    88c <printf+0x170>
      } else if(c == 's'){
 7de:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7e2:	75 43                	jne    827 <printf+0x10b>
        s = (char*)*ap;
 7e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7e7:	8b 00                	mov    (%eax),%eax
 7e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7ec:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f4:	75 25                	jne    81b <printf+0xff>
          s = "(null)";
 7f6:	c7 45 f4 0a 0b 00 00 	movl   $0xb0a,-0xc(%ebp)
        while(*s != 0){
 7fd:	eb 1c                	jmp    81b <printf+0xff>
          putc(fd, *s);
 7ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 802:	0f b6 00             	movzbl (%eax),%eax
 805:	0f be c0             	movsbl %al,%eax
 808:	83 ec 08             	sub    $0x8,%esp
 80b:	50                   	push   %eax
 80c:	ff 75 08             	pushl  0x8(%ebp)
 80f:	e8 31 fe ff ff       	call   645 <putc>
 814:	83 c4 10             	add    $0x10,%esp
          s++;
 817:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 81b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81e:	0f b6 00             	movzbl (%eax),%eax
 821:	84 c0                	test   %al,%al
 823:	75 da                	jne    7ff <printf+0xe3>
 825:	eb 65                	jmp    88c <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 827:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 82b:	75 1d                	jne    84a <printf+0x12e>
        putc(fd, *ap);
 82d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 830:	8b 00                	mov    (%eax),%eax
 832:	0f be c0             	movsbl %al,%eax
 835:	83 ec 08             	sub    $0x8,%esp
 838:	50                   	push   %eax
 839:	ff 75 08             	pushl  0x8(%ebp)
 83c:	e8 04 fe ff ff       	call   645 <putc>
 841:	83 c4 10             	add    $0x10,%esp
        ap++;
 844:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 848:	eb 42                	jmp    88c <printf+0x170>
      } else if(c == '%'){
 84a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 84e:	75 17                	jne    867 <printf+0x14b>
        putc(fd, c);
 850:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 853:	0f be c0             	movsbl %al,%eax
 856:	83 ec 08             	sub    $0x8,%esp
 859:	50                   	push   %eax
 85a:	ff 75 08             	pushl  0x8(%ebp)
 85d:	e8 e3 fd ff ff       	call   645 <putc>
 862:	83 c4 10             	add    $0x10,%esp
 865:	eb 25                	jmp    88c <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 867:	83 ec 08             	sub    $0x8,%esp
 86a:	6a 25                	push   $0x25
 86c:	ff 75 08             	pushl  0x8(%ebp)
 86f:	e8 d1 fd ff ff       	call   645 <putc>
 874:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 877:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 87a:	0f be c0             	movsbl %al,%eax
 87d:	83 ec 08             	sub    $0x8,%esp
 880:	50                   	push   %eax
 881:	ff 75 08             	pushl  0x8(%ebp)
 884:	e8 bc fd ff ff       	call   645 <putc>
 889:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 88c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 893:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 897:	8b 55 0c             	mov    0xc(%ebp),%edx
 89a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89d:	01 d0                	add    %edx,%eax
 89f:	0f b6 00             	movzbl (%eax),%eax
 8a2:	84 c0                	test   %al,%al
 8a4:	0f 85 94 fe ff ff    	jne    73e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8aa:	90                   	nop
 8ab:	c9                   	leave  
 8ac:	c3                   	ret    

000008ad <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8ad:	55                   	push   %ebp
 8ae:	89 e5                	mov    %esp,%ebp
 8b0:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8b3:	8b 45 08             	mov    0x8(%ebp),%eax
 8b6:	83 e8 08             	sub    $0x8,%eax
 8b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8bc:	a1 08 0e 00 00       	mov    0xe08,%eax
 8c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8c4:	eb 24                	jmp    8ea <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c9:	8b 00                	mov    (%eax),%eax
 8cb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ce:	77 12                	ja     8e2 <free+0x35>
 8d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8d6:	77 24                	ja     8fc <free+0x4f>
 8d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8db:	8b 00                	mov    (%eax),%eax
 8dd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8e0:	77 1a                	ja     8fc <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e5:	8b 00                	mov    (%eax),%eax
 8e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ed:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8f0:	76 d4                	jbe    8c6 <free+0x19>
 8f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f5:	8b 00                	mov    (%eax),%eax
 8f7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8fa:	76 ca                	jbe    8c6 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ff:	8b 40 04             	mov    0x4(%eax),%eax
 902:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 909:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90c:	01 c2                	add    %eax,%edx
 90e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 911:	8b 00                	mov    (%eax),%eax
 913:	39 c2                	cmp    %eax,%edx
 915:	75 24                	jne    93b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 917:	8b 45 f8             	mov    -0x8(%ebp),%eax
 91a:	8b 50 04             	mov    0x4(%eax),%edx
 91d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 920:	8b 00                	mov    (%eax),%eax
 922:	8b 40 04             	mov    0x4(%eax),%eax
 925:	01 c2                	add    %eax,%edx
 927:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 92d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 930:	8b 00                	mov    (%eax),%eax
 932:	8b 10                	mov    (%eax),%edx
 934:	8b 45 f8             	mov    -0x8(%ebp),%eax
 937:	89 10                	mov    %edx,(%eax)
 939:	eb 0a                	jmp    945 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 93b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93e:	8b 10                	mov    (%eax),%edx
 940:	8b 45 f8             	mov    -0x8(%ebp),%eax
 943:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 945:	8b 45 fc             	mov    -0x4(%ebp),%eax
 948:	8b 40 04             	mov    0x4(%eax),%eax
 94b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 952:	8b 45 fc             	mov    -0x4(%ebp),%eax
 955:	01 d0                	add    %edx,%eax
 957:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 95a:	75 20                	jne    97c <free+0xcf>
    p->s.size += bp->s.size;
 95c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95f:	8b 50 04             	mov    0x4(%eax),%edx
 962:	8b 45 f8             	mov    -0x8(%ebp),%eax
 965:	8b 40 04             	mov    0x4(%eax),%eax
 968:	01 c2                	add    %eax,%edx
 96a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 970:	8b 45 f8             	mov    -0x8(%ebp),%eax
 973:	8b 10                	mov    (%eax),%edx
 975:	8b 45 fc             	mov    -0x4(%ebp),%eax
 978:	89 10                	mov    %edx,(%eax)
 97a:	eb 08                	jmp    984 <free+0xd7>
  } else
    p->s.ptr = bp;
 97c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 982:	89 10                	mov    %edx,(%eax)
  freep = p;
 984:	8b 45 fc             	mov    -0x4(%ebp),%eax
 987:	a3 08 0e 00 00       	mov    %eax,0xe08
}
 98c:	90                   	nop
 98d:	c9                   	leave  
 98e:	c3                   	ret    

0000098f <morecore>:

static Header*
morecore(uint nu)
{
 98f:	55                   	push   %ebp
 990:	89 e5                	mov    %esp,%ebp
 992:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 995:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 99c:	77 07                	ja     9a5 <morecore+0x16>
    nu = 4096;
 99e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9a5:	8b 45 08             	mov    0x8(%ebp),%eax
 9a8:	c1 e0 03             	shl    $0x3,%eax
 9ab:	83 ec 0c             	sub    $0xc,%esp
 9ae:	50                   	push   %eax
 9af:	e8 61 fc ff ff       	call   615 <sbrk>
 9b4:	83 c4 10             	add    $0x10,%esp
 9b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9ba:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9be:	75 07                	jne    9c7 <morecore+0x38>
    return 0;
 9c0:	b8 00 00 00 00       	mov    $0x0,%eax
 9c5:	eb 26                	jmp    9ed <morecore+0x5e>
  hp = (Header*)p;
 9c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d0:	8b 55 08             	mov    0x8(%ebp),%edx
 9d3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d9:	83 c0 08             	add    $0x8,%eax
 9dc:	83 ec 0c             	sub    $0xc,%esp
 9df:	50                   	push   %eax
 9e0:	e8 c8 fe ff ff       	call   8ad <free>
 9e5:	83 c4 10             	add    $0x10,%esp
  return freep;
 9e8:	a1 08 0e 00 00       	mov    0xe08,%eax
}
 9ed:	c9                   	leave  
 9ee:	c3                   	ret    

000009ef <malloc>:

void*
malloc(uint nbytes)
{
 9ef:	55                   	push   %ebp
 9f0:	89 e5                	mov    %esp,%ebp
 9f2:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9f5:	8b 45 08             	mov    0x8(%ebp),%eax
 9f8:	83 c0 07             	add    $0x7,%eax
 9fb:	c1 e8 03             	shr    $0x3,%eax
 9fe:	83 c0 01             	add    $0x1,%eax
 a01:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a04:	a1 08 0e 00 00       	mov    0xe08,%eax
 a09:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a10:	75 23                	jne    a35 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a12:	c7 45 f0 00 0e 00 00 	movl   $0xe00,-0x10(%ebp)
 a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a1c:	a3 08 0e 00 00       	mov    %eax,0xe08
 a21:	a1 08 0e 00 00       	mov    0xe08,%eax
 a26:	a3 00 0e 00 00       	mov    %eax,0xe00
    base.s.size = 0;
 a2b:	c7 05 04 0e 00 00 00 	movl   $0x0,0xe04
 a32:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a38:	8b 00                	mov    (%eax),%eax
 a3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a40:	8b 40 04             	mov    0x4(%eax),%eax
 a43:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a46:	72 4d                	jb     a95 <malloc+0xa6>
      if(p->s.size == nunits)
 a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4b:	8b 40 04             	mov    0x4(%eax),%eax
 a4e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a51:	75 0c                	jne    a5f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a56:	8b 10                	mov    (%eax),%edx
 a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a5b:	89 10                	mov    %edx,(%eax)
 a5d:	eb 26                	jmp    a85 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a62:	8b 40 04             	mov    0x4(%eax),%eax
 a65:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a68:	89 c2                	mov    %eax,%edx
 a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a73:	8b 40 04             	mov    0x4(%eax),%eax
 a76:	c1 e0 03             	shl    $0x3,%eax
 a79:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a82:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a88:	a3 08 0e 00 00       	mov    %eax,0xe08
      return (void*)(p + 1);
 a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a90:	83 c0 08             	add    $0x8,%eax
 a93:	eb 3b                	jmp    ad0 <malloc+0xe1>
    }
    if(p == freep)
 a95:	a1 08 0e 00 00       	mov    0xe08,%eax
 a9a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a9d:	75 1e                	jne    abd <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a9f:	83 ec 0c             	sub    $0xc,%esp
 aa2:	ff 75 ec             	pushl  -0x14(%ebp)
 aa5:	e8 e5 fe ff ff       	call   98f <morecore>
 aaa:	83 c4 10             	add    $0x10,%esp
 aad:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ab0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ab4:	75 07                	jne    abd <malloc+0xce>
        return 0;
 ab6:	b8 00 00 00 00       	mov    $0x0,%eax
 abb:	eb 13                	jmp    ad0 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac6:	8b 00                	mov    (%eax),%eax
 ac8:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 acb:	e9 6d ff ff ff       	jmp    a3d <malloc+0x4e>
}
 ad0:	c9                   	leave  
 ad1:	c3                   	ret    
