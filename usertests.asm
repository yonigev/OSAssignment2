
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "iput test\n");
       6:	a1 ac 64 00 00       	mov    0x64ac,%eax
       b:	83 ec 08             	sub    $0x8,%esp
       e:	68 66 45 00 00       	push   $0x4566
      13:	50                   	push   %eax
      14:	e8 81 41 00 00       	call   419a <printf>
      19:	83 c4 10             	add    $0x10,%esp

  if(mkdir("iputdir") < 0){
      1c:	83 ec 0c             	sub    $0xc,%esp
      1f:	68 71 45 00 00       	push   $0x4571
      24:	e8 4a 40 00 00       	call   4073 <mkdir>
      29:	83 c4 10             	add    $0x10,%esp
      2c:	85 c0                	test   %eax,%eax
      2e:	79 1b                	jns    4b <iputtest+0x4b>
    printf(stdout, "mkdir failed\n");
      30:	a1 ac 64 00 00       	mov    0x64ac,%eax
      35:	83 ec 08             	sub    $0x8,%esp
      38:	68 79 45 00 00       	push   $0x4579
      3d:	50                   	push   %eax
      3e:	e8 57 41 00 00       	call   419a <printf>
      43:	83 c4 10             	add    $0x10,%esp
    exit();
      46:	e8 c0 3f 00 00       	call   400b <exit>
  }
  if(chdir("iputdir") < 0){
      4b:	83 ec 0c             	sub    $0xc,%esp
      4e:	68 71 45 00 00       	push   $0x4571
      53:	e8 23 40 00 00       	call   407b <chdir>
      58:	83 c4 10             	add    $0x10,%esp
      5b:	85 c0                	test   %eax,%eax
      5d:	79 1b                	jns    7a <iputtest+0x7a>
    printf(stdout, "chdir iputdir failed\n");
      5f:	a1 ac 64 00 00       	mov    0x64ac,%eax
      64:	83 ec 08             	sub    $0x8,%esp
      67:	68 87 45 00 00       	push   $0x4587
      6c:	50                   	push   %eax
      6d:	e8 28 41 00 00       	call   419a <printf>
      72:	83 c4 10             	add    $0x10,%esp
    exit();
      75:	e8 91 3f 00 00       	call   400b <exit>
  }
  if(unlink("../iputdir") < 0){
      7a:	83 ec 0c             	sub    $0xc,%esp
      7d:	68 9d 45 00 00       	push   $0x459d
      82:	e8 d4 3f 00 00       	call   405b <unlink>
      87:	83 c4 10             	add    $0x10,%esp
      8a:	85 c0                	test   %eax,%eax
      8c:	79 1b                	jns    a9 <iputtest+0xa9>
    printf(stdout, "unlink ../iputdir failed\n");
      8e:	a1 ac 64 00 00       	mov    0x64ac,%eax
      93:	83 ec 08             	sub    $0x8,%esp
      96:	68 a8 45 00 00       	push   $0x45a8
      9b:	50                   	push   %eax
      9c:	e8 f9 40 00 00       	call   419a <printf>
      a1:	83 c4 10             	add    $0x10,%esp
    exit();
      a4:	e8 62 3f 00 00       	call   400b <exit>
  }
  if(chdir("/") < 0){
      a9:	83 ec 0c             	sub    $0xc,%esp
      ac:	68 c2 45 00 00       	push   $0x45c2
      b1:	e8 c5 3f 00 00       	call   407b <chdir>
      b6:	83 c4 10             	add    $0x10,%esp
      b9:	85 c0                	test   %eax,%eax
      bb:	79 1b                	jns    d8 <iputtest+0xd8>
    printf(stdout, "chdir / failed\n");
      bd:	a1 ac 64 00 00       	mov    0x64ac,%eax
      c2:	83 ec 08             	sub    $0x8,%esp
      c5:	68 c4 45 00 00       	push   $0x45c4
      ca:	50                   	push   %eax
      cb:	e8 ca 40 00 00       	call   419a <printf>
      d0:	83 c4 10             	add    $0x10,%esp
    exit();
      d3:	e8 33 3f 00 00       	call   400b <exit>
  }
  printf(stdout, "iput test ok\n");
      d8:	a1 ac 64 00 00       	mov    0x64ac,%eax
      dd:	83 ec 08             	sub    $0x8,%esp
      e0:	68 d4 45 00 00       	push   $0x45d4
      e5:	50                   	push   %eax
      e6:	e8 af 40 00 00       	call   419a <printf>
      eb:	83 c4 10             	add    $0x10,%esp
}
      ee:	90                   	nop
      ef:	c9                   	leave  
      f0:	c3                   	ret    

000000f1 <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      f1:	55                   	push   %ebp
      f2:	89 e5                	mov    %esp,%ebp
      f4:	83 ec 18             	sub    $0x18,%esp
  int pid;

  printf(stdout, "exitiput test\n");
      f7:	a1 ac 64 00 00       	mov    0x64ac,%eax
      fc:	83 ec 08             	sub    $0x8,%esp
      ff:	68 e2 45 00 00       	push   $0x45e2
     104:	50                   	push   %eax
     105:	e8 90 40 00 00       	call   419a <printf>
     10a:	83 c4 10             	add    $0x10,%esp

  pid = fork();
     10d:	e8 f1 3e 00 00       	call   4003 <fork>
     112:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
     115:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     119:	79 1b                	jns    136 <exitiputtest+0x45>
    printf(stdout, "fork failed\n");
     11b:	a1 ac 64 00 00       	mov    0x64ac,%eax
     120:	83 ec 08             	sub    $0x8,%esp
     123:	68 f1 45 00 00       	push   $0x45f1
     128:	50                   	push   %eax
     129:	e8 6c 40 00 00       	call   419a <printf>
     12e:	83 c4 10             	add    $0x10,%esp
    exit();
     131:	e8 d5 3e 00 00       	call   400b <exit>
  }
  if(pid == 0){
     136:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     13a:	0f 85 92 00 00 00    	jne    1d2 <exitiputtest+0xe1>
    if(mkdir("iputdir") < 0){
     140:	83 ec 0c             	sub    $0xc,%esp
     143:	68 71 45 00 00       	push   $0x4571
     148:	e8 26 3f 00 00       	call   4073 <mkdir>
     14d:	83 c4 10             	add    $0x10,%esp
     150:	85 c0                	test   %eax,%eax
     152:	79 1b                	jns    16f <exitiputtest+0x7e>
      printf(stdout, "mkdir failed\n");
     154:	a1 ac 64 00 00       	mov    0x64ac,%eax
     159:	83 ec 08             	sub    $0x8,%esp
     15c:	68 79 45 00 00       	push   $0x4579
     161:	50                   	push   %eax
     162:	e8 33 40 00 00       	call   419a <printf>
     167:	83 c4 10             	add    $0x10,%esp
      exit();
     16a:	e8 9c 3e 00 00       	call   400b <exit>
    }
    if(chdir("iputdir") < 0){
     16f:	83 ec 0c             	sub    $0xc,%esp
     172:	68 71 45 00 00       	push   $0x4571
     177:	e8 ff 3e 00 00       	call   407b <chdir>
     17c:	83 c4 10             	add    $0x10,%esp
     17f:	85 c0                	test   %eax,%eax
     181:	79 1b                	jns    19e <exitiputtest+0xad>
      printf(stdout, "child chdir failed\n");
     183:	a1 ac 64 00 00       	mov    0x64ac,%eax
     188:	83 ec 08             	sub    $0x8,%esp
     18b:	68 fe 45 00 00       	push   $0x45fe
     190:	50                   	push   %eax
     191:	e8 04 40 00 00       	call   419a <printf>
     196:	83 c4 10             	add    $0x10,%esp
      exit();
     199:	e8 6d 3e 00 00       	call   400b <exit>
    }
    if(unlink("../iputdir") < 0){
     19e:	83 ec 0c             	sub    $0xc,%esp
     1a1:	68 9d 45 00 00       	push   $0x459d
     1a6:	e8 b0 3e 00 00       	call   405b <unlink>
     1ab:	83 c4 10             	add    $0x10,%esp
     1ae:	85 c0                	test   %eax,%eax
     1b0:	79 1b                	jns    1cd <exitiputtest+0xdc>
      printf(stdout, "unlink ../iputdir failed\n");
     1b2:	a1 ac 64 00 00       	mov    0x64ac,%eax
     1b7:	83 ec 08             	sub    $0x8,%esp
     1ba:	68 a8 45 00 00       	push   $0x45a8
     1bf:	50                   	push   %eax
     1c0:	e8 d5 3f 00 00       	call   419a <printf>
     1c5:	83 c4 10             	add    $0x10,%esp
      exit();
     1c8:	e8 3e 3e 00 00       	call   400b <exit>
    }
    exit();
     1cd:	e8 39 3e 00 00       	call   400b <exit>
  }
  wait();
     1d2:	e8 3c 3e 00 00       	call   4013 <wait>
  printf(stdout, "exitiput test ok\n");
     1d7:	a1 ac 64 00 00       	mov    0x64ac,%eax
     1dc:	83 ec 08             	sub    $0x8,%esp
     1df:	68 12 46 00 00       	push   $0x4612
     1e4:	50                   	push   %eax
     1e5:	e8 b0 3f 00 00       	call   419a <printf>
     1ea:	83 c4 10             	add    $0x10,%esp
}
     1ed:	90                   	nop
     1ee:	c9                   	leave  
     1ef:	c3                   	ret    

000001f0 <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1f0:	55                   	push   %ebp
     1f1:	89 e5                	mov    %esp,%ebp
     1f3:	83 ec 18             	sub    $0x18,%esp
  int pid;

  printf(stdout, "openiput test\n");
     1f6:	a1 ac 64 00 00       	mov    0x64ac,%eax
     1fb:	83 ec 08             	sub    $0x8,%esp
     1fe:	68 24 46 00 00       	push   $0x4624
     203:	50                   	push   %eax
     204:	e8 91 3f 00 00       	call   419a <printf>
     209:	83 c4 10             	add    $0x10,%esp
  if(mkdir("oidir") < 0){
     20c:	83 ec 0c             	sub    $0xc,%esp
     20f:	68 33 46 00 00       	push   $0x4633
     214:	e8 5a 3e 00 00       	call   4073 <mkdir>
     219:	83 c4 10             	add    $0x10,%esp
     21c:	85 c0                	test   %eax,%eax
     21e:	79 1b                	jns    23b <openiputtest+0x4b>
    printf(stdout, "mkdir oidir failed\n");
     220:	a1 ac 64 00 00       	mov    0x64ac,%eax
     225:	83 ec 08             	sub    $0x8,%esp
     228:	68 39 46 00 00       	push   $0x4639
     22d:	50                   	push   %eax
     22e:	e8 67 3f 00 00       	call   419a <printf>
     233:	83 c4 10             	add    $0x10,%esp
    exit();
     236:	e8 d0 3d 00 00       	call   400b <exit>
  }
  pid = fork();
     23b:	e8 c3 3d 00 00       	call   4003 <fork>
     240:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
     243:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     247:	79 1b                	jns    264 <openiputtest+0x74>
    printf(stdout, "fork failed\n");
     249:	a1 ac 64 00 00       	mov    0x64ac,%eax
     24e:	83 ec 08             	sub    $0x8,%esp
     251:	68 f1 45 00 00       	push   $0x45f1
     256:	50                   	push   %eax
     257:	e8 3e 3f 00 00       	call   419a <printf>
     25c:	83 c4 10             	add    $0x10,%esp
    exit();
     25f:	e8 a7 3d 00 00       	call   400b <exit>
  }
  if(pid == 0){
     264:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     268:	75 3b                	jne    2a5 <openiputtest+0xb5>
    int fd = open("oidir", O_RDWR);
     26a:	83 ec 08             	sub    $0x8,%esp
     26d:	6a 02                	push   $0x2
     26f:	68 33 46 00 00       	push   $0x4633
     274:	e8 d2 3d 00 00       	call   404b <open>
     279:	83 c4 10             	add    $0x10,%esp
     27c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0){
     27f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     283:	78 1b                	js     2a0 <openiputtest+0xb0>
      printf(stdout, "open directory for write succeeded\n");
     285:	a1 ac 64 00 00       	mov    0x64ac,%eax
     28a:	83 ec 08             	sub    $0x8,%esp
     28d:	68 50 46 00 00       	push   $0x4650
     292:	50                   	push   %eax
     293:	e8 02 3f 00 00       	call   419a <printf>
     298:	83 c4 10             	add    $0x10,%esp
      exit();
     29b:	e8 6b 3d 00 00       	call   400b <exit>
    }
    exit();
     2a0:	e8 66 3d 00 00       	call   400b <exit>
  }
  sleep(1);
     2a5:	83 ec 0c             	sub    $0xc,%esp
     2a8:	6a 01                	push   $0x1
     2aa:	e8 ec 3d 00 00       	call   409b <sleep>
     2af:	83 c4 10             	add    $0x10,%esp
  if(unlink("oidir") != 0){
     2b2:	83 ec 0c             	sub    $0xc,%esp
     2b5:	68 33 46 00 00       	push   $0x4633
     2ba:	e8 9c 3d 00 00       	call   405b <unlink>
     2bf:	83 c4 10             	add    $0x10,%esp
     2c2:	85 c0                	test   %eax,%eax
     2c4:	74 1b                	je     2e1 <openiputtest+0xf1>
    printf(stdout, "unlink failed\n");
     2c6:	a1 ac 64 00 00       	mov    0x64ac,%eax
     2cb:	83 ec 08             	sub    $0x8,%esp
     2ce:	68 74 46 00 00       	push   $0x4674
     2d3:	50                   	push   %eax
     2d4:	e8 c1 3e 00 00       	call   419a <printf>
     2d9:	83 c4 10             	add    $0x10,%esp
    exit();
     2dc:	e8 2a 3d 00 00       	call   400b <exit>
  }
  wait();
     2e1:	e8 2d 3d 00 00       	call   4013 <wait>
  printf(stdout, "openiput test ok\n");
     2e6:	a1 ac 64 00 00       	mov    0x64ac,%eax
     2eb:	83 ec 08             	sub    $0x8,%esp
     2ee:	68 83 46 00 00       	push   $0x4683
     2f3:	50                   	push   %eax
     2f4:	e8 a1 3e 00 00       	call   419a <printf>
     2f9:	83 c4 10             	add    $0x10,%esp
}
     2fc:	90                   	nop
     2fd:	c9                   	leave  
     2fe:	c3                   	ret    

000002ff <opentest>:

// simple file system tests

void
opentest(void)
{
     2ff:	55                   	push   %ebp
     300:	89 e5                	mov    %esp,%ebp
     302:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(stdout, "open test\n");
     305:	a1 ac 64 00 00       	mov    0x64ac,%eax
     30a:	83 ec 08             	sub    $0x8,%esp
     30d:	68 95 46 00 00       	push   $0x4695
     312:	50                   	push   %eax
     313:	e8 82 3e 00 00       	call   419a <printf>
     318:	83 c4 10             	add    $0x10,%esp
  fd = open("echo", 0);
     31b:	83 ec 08             	sub    $0x8,%esp
     31e:	6a 00                	push   $0x0
     320:	68 50 45 00 00       	push   $0x4550
     325:	e8 21 3d 00 00       	call   404b <open>
     32a:	83 c4 10             	add    $0x10,%esp
     32d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
     330:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     334:	79 1b                	jns    351 <opentest+0x52>
    printf(stdout, "open echo failed!\n");
     336:	a1 ac 64 00 00       	mov    0x64ac,%eax
     33b:	83 ec 08             	sub    $0x8,%esp
     33e:	68 a0 46 00 00       	push   $0x46a0
     343:	50                   	push   %eax
     344:	e8 51 3e 00 00       	call   419a <printf>
     349:	83 c4 10             	add    $0x10,%esp
    exit();
     34c:	e8 ba 3c 00 00       	call   400b <exit>
  }
  close(fd);
     351:	83 ec 0c             	sub    $0xc,%esp
     354:	ff 75 f4             	pushl  -0xc(%ebp)
     357:	e8 d7 3c 00 00       	call   4033 <close>
     35c:	83 c4 10             	add    $0x10,%esp
  fd = open("doesnotexist", 0);
     35f:	83 ec 08             	sub    $0x8,%esp
     362:	6a 00                	push   $0x0
     364:	68 b3 46 00 00       	push   $0x46b3
     369:	e8 dd 3c 00 00       	call   404b <open>
     36e:	83 c4 10             	add    $0x10,%esp
     371:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
     374:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     378:	78 1b                	js     395 <opentest+0x96>
    printf(stdout, "open doesnotexist succeeded!\n");
     37a:	a1 ac 64 00 00       	mov    0x64ac,%eax
     37f:	83 ec 08             	sub    $0x8,%esp
     382:	68 c0 46 00 00       	push   $0x46c0
     387:	50                   	push   %eax
     388:	e8 0d 3e 00 00       	call   419a <printf>
     38d:	83 c4 10             	add    $0x10,%esp
    exit();
     390:	e8 76 3c 00 00       	call   400b <exit>
  }
  printf(stdout, "open test ok\n");
     395:	a1 ac 64 00 00       	mov    0x64ac,%eax
     39a:	83 ec 08             	sub    $0x8,%esp
     39d:	68 de 46 00 00       	push   $0x46de
     3a2:	50                   	push   %eax
     3a3:	e8 f2 3d 00 00       	call   419a <printf>
     3a8:	83 c4 10             	add    $0x10,%esp
}
     3ab:	90                   	nop
     3ac:	c9                   	leave  
     3ad:	c3                   	ret    

000003ae <writetest>:

void
writetest(void)
{
     3ae:	55                   	push   %ebp
     3af:	89 e5                	mov    %esp,%ebp
     3b1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
     3b4:	a1 ac 64 00 00       	mov    0x64ac,%eax
     3b9:	83 ec 08             	sub    $0x8,%esp
     3bc:	68 ec 46 00 00       	push   $0x46ec
     3c1:	50                   	push   %eax
     3c2:	e8 d3 3d 00 00       	call   419a <printf>
     3c7:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_CREATE|O_RDWR);
     3ca:	83 ec 08             	sub    $0x8,%esp
     3cd:	68 02 02 00 00       	push   $0x202
     3d2:	68 fd 46 00 00       	push   $0x46fd
     3d7:	e8 6f 3c 00 00       	call   404b <open>
     3dc:	83 c4 10             	add    $0x10,%esp
     3df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     3e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     3e6:	78 22                	js     40a <writetest+0x5c>
    printf(stdout, "creat small succeeded; ok\n");
     3e8:	a1 ac 64 00 00       	mov    0x64ac,%eax
     3ed:	83 ec 08             	sub    $0x8,%esp
     3f0:	68 03 47 00 00       	push   $0x4703
     3f5:	50                   	push   %eax
     3f6:	e8 9f 3d 00 00       	call   419a <printf>
     3fb:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     3fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     405:	e9 8f 00 00 00       	jmp    499 <writetest+0xeb>
  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
  if(fd >= 0){
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
     40a:	a1 ac 64 00 00       	mov    0x64ac,%eax
     40f:	83 ec 08             	sub    $0x8,%esp
     412:	68 1e 47 00 00       	push   $0x471e
     417:	50                   	push   %eax
     418:	e8 7d 3d 00 00       	call   419a <printf>
     41d:	83 c4 10             	add    $0x10,%esp
    exit();
     420:	e8 e6 3b 00 00       	call   400b <exit>
  }
  for(i = 0; i < 100; i++){
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     425:	83 ec 04             	sub    $0x4,%esp
     428:	6a 0a                	push   $0xa
     42a:	68 3a 47 00 00       	push   $0x473a
     42f:	ff 75 f0             	pushl  -0x10(%ebp)
     432:	e8 f4 3b 00 00       	call   402b <write>
     437:	83 c4 10             	add    $0x10,%esp
     43a:	83 f8 0a             	cmp    $0xa,%eax
     43d:	74 1e                	je     45d <writetest+0xaf>
      printf(stdout, "error: write aa %d new file failed\n", i);
     43f:	a1 ac 64 00 00       	mov    0x64ac,%eax
     444:	83 ec 04             	sub    $0x4,%esp
     447:	ff 75 f4             	pushl  -0xc(%ebp)
     44a:	68 48 47 00 00       	push   $0x4748
     44f:	50                   	push   %eax
     450:	e8 45 3d 00 00       	call   419a <printf>
     455:	83 c4 10             	add    $0x10,%esp
      exit();
     458:	e8 ae 3b 00 00       	call   400b <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     45d:	83 ec 04             	sub    $0x4,%esp
     460:	6a 0a                	push   $0xa
     462:	68 6c 47 00 00       	push   $0x476c
     467:	ff 75 f0             	pushl  -0x10(%ebp)
     46a:	e8 bc 3b 00 00       	call   402b <write>
     46f:	83 c4 10             	add    $0x10,%esp
     472:	83 f8 0a             	cmp    $0xa,%eax
     475:	74 1e                	je     495 <writetest+0xe7>
      printf(stdout, "error: write bb %d new file failed\n", i);
     477:	a1 ac 64 00 00       	mov    0x64ac,%eax
     47c:	83 ec 04             	sub    $0x4,%esp
     47f:	ff 75 f4             	pushl  -0xc(%ebp)
     482:	68 78 47 00 00       	push   $0x4778
     487:	50                   	push   %eax
     488:	e8 0d 3d 00 00       	call   419a <printf>
     48d:	83 c4 10             	add    $0x10,%esp
      exit();
     490:	e8 76 3b 00 00       	call   400b <exit>
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     495:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     499:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     49d:	7e 86                	jle    425 <writetest+0x77>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
      printf(stdout, "error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf(stdout, "writes ok\n");
     49f:	a1 ac 64 00 00       	mov    0x64ac,%eax
     4a4:	83 ec 08             	sub    $0x8,%esp
     4a7:	68 9c 47 00 00       	push   $0x479c
     4ac:	50                   	push   %eax
     4ad:	e8 e8 3c 00 00       	call   419a <printf>
     4b2:	83 c4 10             	add    $0x10,%esp
  close(fd);
     4b5:	83 ec 0c             	sub    $0xc,%esp
     4b8:	ff 75 f0             	pushl  -0x10(%ebp)
     4bb:	e8 73 3b 00 00       	call   4033 <close>
     4c0:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_RDONLY);
     4c3:	83 ec 08             	sub    $0x8,%esp
     4c6:	6a 00                	push   $0x0
     4c8:	68 fd 46 00 00       	push   $0x46fd
     4cd:	e8 79 3b 00 00       	call   404b <open>
     4d2:	83 c4 10             	add    $0x10,%esp
     4d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     4d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     4dc:	78 3c                	js     51a <writetest+0x16c>
    printf(stdout, "open small succeeded ok\n");
     4de:	a1 ac 64 00 00       	mov    0x64ac,%eax
     4e3:	83 ec 08             	sub    $0x8,%esp
     4e6:	68 a7 47 00 00       	push   $0x47a7
     4eb:	50                   	push   %eax
     4ec:	e8 a9 3c 00 00       	call   419a <printf>
     4f1:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     4f4:	83 ec 04             	sub    $0x4,%esp
     4f7:	68 d0 07 00 00       	push   $0x7d0
     4fc:	68 a0 8c 00 00       	push   $0x8ca0
     501:	ff 75 f0             	pushl  -0x10(%ebp)
     504:	e8 1a 3b 00 00       	call   4023 <read>
     509:	83 c4 10             	add    $0x10,%esp
     50c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(i == 2000){
     50f:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
     516:	75 57                	jne    56f <writetest+0x1c1>
     518:	eb 1b                	jmp    535 <writetest+0x187>
  close(fd);
  fd = open("small", O_RDONLY);
  if(fd >= 0){
    printf(stdout, "open small succeeded ok\n");
  } else {
    printf(stdout, "error: open small failed!\n");
     51a:	a1 ac 64 00 00       	mov    0x64ac,%eax
     51f:	83 ec 08             	sub    $0x8,%esp
     522:	68 c0 47 00 00       	push   $0x47c0
     527:	50                   	push   %eax
     528:	e8 6d 3c 00 00       	call   419a <printf>
     52d:	83 c4 10             	add    $0x10,%esp
    exit();
     530:	e8 d6 3a 00 00       	call   400b <exit>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
     535:	a1 ac 64 00 00       	mov    0x64ac,%eax
     53a:	83 ec 08             	sub    $0x8,%esp
     53d:	68 db 47 00 00       	push   $0x47db
     542:	50                   	push   %eax
     543:	e8 52 3c 00 00       	call   419a <printf>
     548:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     54b:	83 ec 0c             	sub    $0xc,%esp
     54e:	ff 75 f0             	pushl  -0x10(%ebp)
     551:	e8 dd 3a 00 00       	call   4033 <close>
     556:	83 c4 10             	add    $0x10,%esp

  if(unlink("small") < 0){
     559:	83 ec 0c             	sub    $0xc,%esp
     55c:	68 fd 46 00 00       	push   $0x46fd
     561:	e8 f5 3a 00 00       	call   405b <unlink>
     566:	83 c4 10             	add    $0x10,%esp
     569:	85 c0                	test   %eax,%eax
     56b:	79 38                	jns    5a5 <writetest+0x1f7>
     56d:	eb 1b                	jmp    58a <writetest+0x1dc>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
  } else {
    printf(stdout, "read failed\n");
     56f:	a1 ac 64 00 00       	mov    0x64ac,%eax
     574:	83 ec 08             	sub    $0x8,%esp
     577:	68 ee 47 00 00       	push   $0x47ee
     57c:	50                   	push   %eax
     57d:	e8 18 3c 00 00       	call   419a <printf>
     582:	83 c4 10             	add    $0x10,%esp
    exit();
     585:	e8 81 3a 00 00       	call   400b <exit>
  }
  close(fd);

  if(unlink("small") < 0){
    printf(stdout, "unlink small failed\n");
     58a:	a1 ac 64 00 00       	mov    0x64ac,%eax
     58f:	83 ec 08             	sub    $0x8,%esp
     592:	68 fb 47 00 00       	push   $0x47fb
     597:	50                   	push   %eax
     598:	e8 fd 3b 00 00       	call   419a <printf>
     59d:	83 c4 10             	add    $0x10,%esp
    exit();
     5a0:	e8 66 3a 00 00       	call   400b <exit>
  }
  printf(stdout, "small file test ok\n");
     5a5:	a1 ac 64 00 00       	mov    0x64ac,%eax
     5aa:	83 ec 08             	sub    $0x8,%esp
     5ad:	68 10 48 00 00       	push   $0x4810
     5b2:	50                   	push   %eax
     5b3:	e8 e2 3b 00 00       	call   419a <printf>
     5b8:	83 c4 10             	add    $0x10,%esp
}
     5bb:	90                   	nop
     5bc:	c9                   	leave  
     5bd:	c3                   	ret    

000005be <writetest1>:

void
writetest1(void)
{
     5be:	55                   	push   %ebp
     5bf:	89 e5                	mov    %esp,%ebp
     5c1:	83 ec 18             	sub    $0x18,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
     5c4:	a1 ac 64 00 00       	mov    0x64ac,%eax
     5c9:	83 ec 08             	sub    $0x8,%esp
     5cc:	68 24 48 00 00       	push   $0x4824
     5d1:	50                   	push   %eax
     5d2:	e8 c3 3b 00 00       	call   419a <printf>
     5d7:	83 c4 10             	add    $0x10,%esp

  fd = open("big", O_CREATE|O_RDWR);
     5da:	83 ec 08             	sub    $0x8,%esp
     5dd:	68 02 02 00 00       	push   $0x202
     5e2:	68 34 48 00 00       	push   $0x4834
     5e7:	e8 5f 3a 00 00       	call   404b <open>
     5ec:	83 c4 10             	add    $0x10,%esp
     5ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     5f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     5f6:	79 1b                	jns    613 <writetest1+0x55>
    printf(stdout, "error: creat big failed!\n");
     5f8:	a1 ac 64 00 00       	mov    0x64ac,%eax
     5fd:	83 ec 08             	sub    $0x8,%esp
     600:	68 38 48 00 00       	push   $0x4838
     605:	50                   	push   %eax
     606:	e8 8f 3b 00 00       	call   419a <printf>
     60b:	83 c4 10             	add    $0x10,%esp
    exit();
     60e:	e8 f8 39 00 00       	call   400b <exit>
  }

  for(i = 0; i < MAXFILE; i++){
     613:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     61a:	eb 4b                	jmp    667 <writetest1+0xa9>
    ((int*)buf)[0] = i;
     61c:	ba a0 8c 00 00       	mov    $0x8ca0,%edx
     621:	8b 45 f4             	mov    -0xc(%ebp),%eax
     624:	89 02                	mov    %eax,(%edx)
    if(write(fd, buf, 512) != 512){
     626:	83 ec 04             	sub    $0x4,%esp
     629:	68 00 02 00 00       	push   $0x200
     62e:	68 a0 8c 00 00       	push   $0x8ca0
     633:	ff 75 ec             	pushl  -0x14(%ebp)
     636:	e8 f0 39 00 00       	call   402b <write>
     63b:	83 c4 10             	add    $0x10,%esp
     63e:	3d 00 02 00 00       	cmp    $0x200,%eax
     643:	74 1e                	je     663 <writetest1+0xa5>
      printf(stdout, "error: write big file failed\n", i);
     645:	a1 ac 64 00 00       	mov    0x64ac,%eax
     64a:	83 ec 04             	sub    $0x4,%esp
     64d:	ff 75 f4             	pushl  -0xc(%ebp)
     650:	68 52 48 00 00       	push   $0x4852
     655:	50                   	push   %eax
     656:	e8 3f 3b 00 00       	call   419a <printf>
     65b:	83 c4 10             	add    $0x10,%esp
      exit();
     65e:	e8 a8 39 00 00       	call   400b <exit>
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
     663:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     667:	8b 45 f4             	mov    -0xc(%ebp),%eax
     66a:	3d 8b 00 00 00       	cmp    $0x8b,%eax
     66f:	76 ab                	jbe    61c <writetest1+0x5e>
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
     671:	83 ec 0c             	sub    $0xc,%esp
     674:	ff 75 ec             	pushl  -0x14(%ebp)
     677:	e8 b7 39 00 00       	call   4033 <close>
     67c:	83 c4 10             	add    $0x10,%esp

  fd = open("big", O_RDONLY);
     67f:	83 ec 08             	sub    $0x8,%esp
     682:	6a 00                	push   $0x0
     684:	68 34 48 00 00       	push   $0x4834
     689:	e8 bd 39 00 00       	call   404b <open>
     68e:	83 c4 10             	add    $0x10,%esp
     691:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     694:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     698:	79 1b                	jns    6b5 <writetest1+0xf7>
    printf(stdout, "error: open big failed!\n");
     69a:	a1 ac 64 00 00       	mov    0x64ac,%eax
     69f:	83 ec 08             	sub    $0x8,%esp
     6a2:	68 70 48 00 00       	push   $0x4870
     6a7:	50                   	push   %eax
     6a8:	e8 ed 3a 00 00       	call   419a <printf>
     6ad:	83 c4 10             	add    $0x10,%esp
    exit();
     6b0:	e8 56 39 00 00       	call   400b <exit>
  }

  n = 0;
     6b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    i = read(fd, buf, 512);
     6bc:	83 ec 04             	sub    $0x4,%esp
     6bf:	68 00 02 00 00       	push   $0x200
     6c4:	68 a0 8c 00 00       	push   $0x8ca0
     6c9:	ff 75 ec             	pushl  -0x14(%ebp)
     6cc:	e8 52 39 00 00       	call   4023 <read>
     6d1:	83 c4 10             	add    $0x10,%esp
     6d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(i == 0){
     6d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     6db:	75 27                	jne    704 <writetest1+0x146>
      if(n == MAXFILE - 1){
     6dd:	81 7d f0 8b 00 00 00 	cmpl   $0x8b,-0x10(%ebp)
     6e4:	75 7d                	jne    763 <writetest1+0x1a5>
        printf(stdout, "read only %d blocks from big", n);
     6e6:	a1 ac 64 00 00       	mov    0x64ac,%eax
     6eb:	83 ec 04             	sub    $0x4,%esp
     6ee:	ff 75 f0             	pushl  -0x10(%ebp)
     6f1:	68 89 48 00 00       	push   $0x4889
     6f6:	50                   	push   %eax
     6f7:	e8 9e 3a 00 00       	call   419a <printf>
     6fc:	83 c4 10             	add    $0x10,%esp
        exit();
     6ff:	e8 07 39 00 00       	call   400b <exit>
      }
      break;
    } else if(i != 512){
     704:	81 7d f4 00 02 00 00 	cmpl   $0x200,-0xc(%ebp)
     70b:	74 1e                	je     72b <writetest1+0x16d>
      printf(stdout, "read failed %d\n", i);
     70d:	a1 ac 64 00 00       	mov    0x64ac,%eax
     712:	83 ec 04             	sub    $0x4,%esp
     715:	ff 75 f4             	pushl  -0xc(%ebp)
     718:	68 a6 48 00 00       	push   $0x48a6
     71d:	50                   	push   %eax
     71e:	e8 77 3a 00 00       	call   419a <printf>
     723:	83 c4 10             	add    $0x10,%esp
      exit();
     726:	e8 e0 38 00 00       	call   400b <exit>
    }
    if(((int*)buf)[0] != n){
     72b:	b8 a0 8c 00 00       	mov    $0x8ca0,%eax
     730:	8b 00                	mov    (%eax),%eax
     732:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     735:	74 23                	je     75a <writetest1+0x19c>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
     737:	b8 a0 8c 00 00       	mov    $0x8ca0,%eax
    } else if(i != 512){
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
      printf(stdout, "read content of block %d is %d\n",
     73c:	8b 10                	mov    (%eax),%edx
     73e:	a1 ac 64 00 00       	mov    0x64ac,%eax
     743:	52                   	push   %edx
     744:	ff 75 f0             	pushl  -0x10(%ebp)
     747:	68 b8 48 00 00       	push   $0x48b8
     74c:	50                   	push   %eax
     74d:	e8 48 3a 00 00       	call   419a <printf>
     752:	83 c4 10             	add    $0x10,%esp
             n, ((int*)buf)[0]);
      exit();
     755:	e8 b1 38 00 00       	call   400b <exit>
    }
    n++;
     75a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  }
     75e:	e9 59 ff ff ff       	jmp    6bc <writetest1+0xfe>
    if(i == 0){
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
     763:	90                   	nop
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
  }
  close(fd);
     764:	83 ec 0c             	sub    $0xc,%esp
     767:	ff 75 ec             	pushl  -0x14(%ebp)
     76a:	e8 c4 38 00 00       	call   4033 <close>
     76f:	83 c4 10             	add    $0x10,%esp
  if(unlink("big") < 0){
     772:	83 ec 0c             	sub    $0xc,%esp
     775:	68 34 48 00 00       	push   $0x4834
     77a:	e8 dc 38 00 00       	call   405b <unlink>
     77f:	83 c4 10             	add    $0x10,%esp
     782:	85 c0                	test   %eax,%eax
     784:	79 1b                	jns    7a1 <writetest1+0x1e3>
    printf(stdout, "unlink big failed\n");
     786:	a1 ac 64 00 00       	mov    0x64ac,%eax
     78b:	83 ec 08             	sub    $0x8,%esp
     78e:	68 d8 48 00 00       	push   $0x48d8
     793:	50                   	push   %eax
     794:	e8 01 3a 00 00       	call   419a <printf>
     799:	83 c4 10             	add    $0x10,%esp
    exit();
     79c:	e8 6a 38 00 00       	call   400b <exit>
  }
  printf(stdout, "big files ok\n");
     7a1:	a1 ac 64 00 00       	mov    0x64ac,%eax
     7a6:	83 ec 08             	sub    $0x8,%esp
     7a9:	68 eb 48 00 00       	push   $0x48eb
     7ae:	50                   	push   %eax
     7af:	e8 e6 39 00 00       	call   419a <printf>
     7b4:	83 c4 10             	add    $0x10,%esp
}
     7b7:	90                   	nop
     7b8:	c9                   	leave  
     7b9:	c3                   	ret    

000007ba <createtest>:

void
createtest(void)
{
     7ba:	55                   	push   %ebp
     7bb:	89 e5                	mov    %esp,%ebp
     7bd:	83 ec 18             	sub    $0x18,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     7c0:	a1 ac 64 00 00       	mov    0x64ac,%eax
     7c5:	83 ec 08             	sub    $0x8,%esp
     7c8:	68 fc 48 00 00       	push   $0x48fc
     7cd:	50                   	push   %eax
     7ce:	e8 c7 39 00 00       	call   419a <printf>
     7d3:	83 c4 10             	add    $0x10,%esp

  name[0] = 'a';
     7d6:	c6 05 a0 ac 00 00 61 	movb   $0x61,0xaca0
  name[2] = '\0';
     7dd:	c6 05 a2 ac 00 00 00 	movb   $0x0,0xaca2
  for(i = 0; i < 52; i++){
     7e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     7eb:	eb 35                	jmp    822 <createtest+0x68>
    name[1] = '0' + i;
     7ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7f0:	83 c0 30             	add    $0x30,%eax
     7f3:	a2 a1 ac 00 00       	mov    %al,0xaca1
    fd = open(name, O_CREATE|O_RDWR);
     7f8:	83 ec 08             	sub    $0x8,%esp
     7fb:	68 02 02 00 00       	push   $0x202
     800:	68 a0 ac 00 00       	push   $0xaca0
     805:	e8 41 38 00 00       	call   404b <open>
     80a:	83 c4 10             	add    $0x10,%esp
     80d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(fd);
     810:	83 ec 0c             	sub    $0xc,%esp
     813:	ff 75 f0             	pushl  -0x10(%ebp)
     816:	e8 18 38 00 00       	call   4033 <close>
     81b:	83 c4 10             	add    $0x10,%esp

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     81e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     822:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     826:	7e c5                	jle    7ed <createtest+0x33>
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
     828:	c6 05 a0 ac 00 00 61 	movb   $0x61,0xaca0
  name[2] = '\0';
     82f:	c6 05 a2 ac 00 00 00 	movb   $0x0,0xaca2
  for(i = 0; i < 52; i++){
     836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     83d:	eb 1f                	jmp    85e <createtest+0xa4>
    name[1] = '0' + i;
     83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     842:	83 c0 30             	add    $0x30,%eax
     845:	a2 a1 ac 00 00       	mov    %al,0xaca1
    unlink(name);
     84a:	83 ec 0c             	sub    $0xc,%esp
     84d:	68 a0 ac 00 00       	push   $0xaca0
     852:	e8 04 38 00 00       	call   405b <unlink>
     857:	83 c4 10             	add    $0x10,%esp
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     85a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     85e:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     862:	7e db                	jle    83f <createtest+0x85>
    name[1] = '0' + i;
    unlink(name);
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     864:	a1 ac 64 00 00       	mov    0x64ac,%eax
     869:	83 ec 08             	sub    $0x8,%esp
     86c:	68 24 49 00 00       	push   $0x4924
     871:	50                   	push   %eax
     872:	e8 23 39 00 00       	call   419a <printf>
     877:	83 c4 10             	add    $0x10,%esp
}
     87a:	90                   	nop
     87b:	c9                   	leave  
     87c:	c3                   	ret    

0000087d <dirtest>:

void dirtest(void)
{
     87d:	55                   	push   %ebp
     87e:	89 e5                	mov    %esp,%ebp
     880:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "mkdir test\n");
     883:	a1 ac 64 00 00       	mov    0x64ac,%eax
     888:	83 ec 08             	sub    $0x8,%esp
     88b:	68 4a 49 00 00       	push   $0x494a
     890:	50                   	push   %eax
     891:	e8 04 39 00 00       	call   419a <printf>
     896:	83 c4 10             	add    $0x10,%esp

  if(mkdir("dir0") < 0){
     899:	83 ec 0c             	sub    $0xc,%esp
     89c:	68 56 49 00 00       	push   $0x4956
     8a1:	e8 cd 37 00 00       	call   4073 <mkdir>
     8a6:	83 c4 10             	add    $0x10,%esp
     8a9:	85 c0                	test   %eax,%eax
     8ab:	79 1b                	jns    8c8 <dirtest+0x4b>
    printf(stdout, "mkdir failed\n");
     8ad:	a1 ac 64 00 00       	mov    0x64ac,%eax
     8b2:	83 ec 08             	sub    $0x8,%esp
     8b5:	68 79 45 00 00       	push   $0x4579
     8ba:	50                   	push   %eax
     8bb:	e8 da 38 00 00       	call   419a <printf>
     8c0:	83 c4 10             	add    $0x10,%esp
    exit();
     8c3:	e8 43 37 00 00       	call   400b <exit>
  }

  if(chdir("dir0") < 0){
     8c8:	83 ec 0c             	sub    $0xc,%esp
     8cb:	68 56 49 00 00       	push   $0x4956
     8d0:	e8 a6 37 00 00       	call   407b <chdir>
     8d5:	83 c4 10             	add    $0x10,%esp
     8d8:	85 c0                	test   %eax,%eax
     8da:	79 1b                	jns    8f7 <dirtest+0x7a>
    printf(stdout, "chdir dir0 failed\n");
     8dc:	a1 ac 64 00 00       	mov    0x64ac,%eax
     8e1:	83 ec 08             	sub    $0x8,%esp
     8e4:	68 5b 49 00 00       	push   $0x495b
     8e9:	50                   	push   %eax
     8ea:	e8 ab 38 00 00       	call   419a <printf>
     8ef:	83 c4 10             	add    $0x10,%esp
    exit();
     8f2:	e8 14 37 00 00       	call   400b <exit>
  }

  if(chdir("..") < 0){
     8f7:	83 ec 0c             	sub    $0xc,%esp
     8fa:	68 6e 49 00 00       	push   $0x496e
     8ff:	e8 77 37 00 00       	call   407b <chdir>
     904:	83 c4 10             	add    $0x10,%esp
     907:	85 c0                	test   %eax,%eax
     909:	79 1b                	jns    926 <dirtest+0xa9>
    printf(stdout, "chdir .. failed\n");
     90b:	a1 ac 64 00 00       	mov    0x64ac,%eax
     910:	83 ec 08             	sub    $0x8,%esp
     913:	68 71 49 00 00       	push   $0x4971
     918:	50                   	push   %eax
     919:	e8 7c 38 00 00       	call   419a <printf>
     91e:	83 c4 10             	add    $0x10,%esp
    exit();
     921:	e8 e5 36 00 00       	call   400b <exit>
  }

  if(unlink("dir0") < 0){
     926:	83 ec 0c             	sub    $0xc,%esp
     929:	68 56 49 00 00       	push   $0x4956
     92e:	e8 28 37 00 00       	call   405b <unlink>
     933:	83 c4 10             	add    $0x10,%esp
     936:	85 c0                	test   %eax,%eax
     938:	79 1b                	jns    955 <dirtest+0xd8>
    printf(stdout, "unlink dir0 failed\n");
     93a:	a1 ac 64 00 00       	mov    0x64ac,%eax
     93f:	83 ec 08             	sub    $0x8,%esp
     942:	68 82 49 00 00       	push   $0x4982
     947:	50                   	push   %eax
     948:	e8 4d 38 00 00       	call   419a <printf>
     94d:	83 c4 10             	add    $0x10,%esp
    exit();
     950:	e8 b6 36 00 00       	call   400b <exit>
  }
  printf(stdout, "mkdir test ok\n");
     955:	a1 ac 64 00 00       	mov    0x64ac,%eax
     95a:	83 ec 08             	sub    $0x8,%esp
     95d:	68 96 49 00 00       	push   $0x4996
     962:	50                   	push   %eax
     963:	e8 32 38 00 00       	call   419a <printf>
     968:	83 c4 10             	add    $0x10,%esp
}
     96b:	90                   	nop
     96c:	c9                   	leave  
     96d:	c3                   	ret    

0000096e <exectest>:

void
exectest(void)
{
     96e:	55                   	push   %ebp
     96f:	89 e5                	mov    %esp,%ebp
     971:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "exec test\n");
     974:	a1 ac 64 00 00       	mov    0x64ac,%eax
     979:	83 ec 08             	sub    $0x8,%esp
     97c:	68 a5 49 00 00       	push   $0x49a5
     981:	50                   	push   %eax
     982:	e8 13 38 00 00       	call   419a <printf>
     987:	83 c4 10             	add    $0x10,%esp
  if(exec("echo", echoargv) < 0){
     98a:	83 ec 08             	sub    $0x8,%esp
     98d:	68 98 64 00 00       	push   $0x6498
     992:	68 50 45 00 00       	push   $0x4550
     997:	e8 a7 36 00 00       	call   4043 <exec>
     99c:	83 c4 10             	add    $0x10,%esp
     99f:	85 c0                	test   %eax,%eax
     9a1:	79 1b                	jns    9be <exectest+0x50>
    printf(stdout, "exec echo failed\n");
     9a3:	a1 ac 64 00 00       	mov    0x64ac,%eax
     9a8:	83 ec 08             	sub    $0x8,%esp
     9ab:	68 b0 49 00 00       	push   $0x49b0
     9b0:	50                   	push   %eax
     9b1:	e8 e4 37 00 00       	call   419a <printf>
     9b6:	83 c4 10             	add    $0x10,%esp
    exit();
     9b9:	e8 4d 36 00 00       	call   400b <exit>
  }
}
     9be:	90                   	nop
     9bf:	c9                   	leave  
     9c0:	c3                   	ret    

000009c1 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     9c1:	55                   	push   %ebp
     9c2:	89 e5                	mov    %esp,%ebp
     9c4:	83 ec 28             	sub    $0x28,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     9c7:	83 ec 0c             	sub    $0xc,%esp
     9ca:	8d 45 d8             	lea    -0x28(%ebp),%eax
     9cd:	50                   	push   %eax
     9ce:	e8 48 36 00 00       	call   401b <pipe>
     9d3:	83 c4 10             	add    $0x10,%esp
     9d6:	85 c0                	test   %eax,%eax
     9d8:	74 17                	je     9f1 <pipe1+0x30>
    printf(1, "pipe() failed\n");
     9da:	83 ec 08             	sub    $0x8,%esp
     9dd:	68 c2 49 00 00       	push   $0x49c2
     9e2:	6a 01                	push   $0x1
     9e4:	e8 b1 37 00 00       	call   419a <printf>
     9e9:	83 c4 10             	add    $0x10,%esp
    exit();
     9ec:	e8 1a 36 00 00       	call   400b <exit>
  }
  pid = fork();
     9f1:	e8 0d 36 00 00       	call   4003 <fork>
     9f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  seq = 0;
     9f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(pid == 0){
     a00:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     a04:	0f 85 89 00 00 00    	jne    a93 <pipe1+0xd2>
    close(fds[0]);
     a0a:	8b 45 d8             	mov    -0x28(%ebp),%eax
     a0d:	83 ec 0c             	sub    $0xc,%esp
     a10:	50                   	push   %eax
     a11:	e8 1d 36 00 00       	call   4033 <close>
     a16:	83 c4 10             	add    $0x10,%esp
    for(n = 0; n < 5; n++){
     a19:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     a20:	eb 66                	jmp    a88 <pipe1+0xc7>
      for(i = 0; i < 1033; i++)
     a22:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     a29:	eb 19                	jmp    a44 <pipe1+0x83>
        buf[i] = seq++;
     a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a2e:	8d 50 01             	lea    0x1(%eax),%edx
     a31:	89 55 f4             	mov    %edx,-0xc(%ebp)
     a34:	89 c2                	mov    %eax,%edx
     a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a39:	05 a0 8c 00 00       	add    $0x8ca0,%eax
     a3e:	88 10                	mov    %dl,(%eax)
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
     a40:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     a44:	81 7d f0 08 04 00 00 	cmpl   $0x408,-0x10(%ebp)
     a4b:	7e de                	jle    a2b <pipe1+0x6a>
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
     a4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
     a50:	83 ec 04             	sub    $0x4,%esp
     a53:	68 09 04 00 00       	push   $0x409
     a58:	68 a0 8c 00 00       	push   $0x8ca0
     a5d:	50                   	push   %eax
     a5e:	e8 c8 35 00 00       	call   402b <write>
     a63:	83 c4 10             	add    $0x10,%esp
     a66:	3d 09 04 00 00       	cmp    $0x409,%eax
     a6b:	74 17                	je     a84 <pipe1+0xc3>
        printf(1, "pipe1 oops 1\n");
     a6d:	83 ec 08             	sub    $0x8,%esp
     a70:	68 d1 49 00 00       	push   $0x49d1
     a75:	6a 01                	push   $0x1
     a77:	e8 1e 37 00 00       	call   419a <printf>
     a7c:	83 c4 10             	add    $0x10,%esp
        exit();
     a7f:	e8 87 35 00 00       	call   400b <exit>
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
     a84:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     a88:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
     a8c:	7e 94                	jle    a22 <pipe1+0x61>
      if(write(fds[1], buf, 1033) != 1033){
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
     a8e:	e8 78 35 00 00       	call   400b <exit>
  } else if(pid > 0){
     a93:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     a97:	0f 8e f4 00 00 00    	jle    b91 <pipe1+0x1d0>
    close(fds[1]);
     a9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
     aa0:	83 ec 0c             	sub    $0xc,%esp
     aa3:	50                   	push   %eax
     aa4:	e8 8a 35 00 00       	call   4033 <close>
     aa9:	83 c4 10             	add    $0x10,%esp
    total = 0;
     aac:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    cc = 1;
     ab3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     aba:	eb 66                	jmp    b22 <pipe1+0x161>
      for(i = 0; i < n; i++){
     abc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     ac3:	eb 3b                	jmp    b00 <pipe1+0x13f>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ac8:	05 a0 8c 00 00       	add    $0x8ca0,%eax
     acd:	0f b6 00             	movzbl (%eax),%eax
     ad0:	0f be c8             	movsbl %al,%ecx
     ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ad6:	8d 50 01             	lea    0x1(%eax),%edx
     ad9:	89 55 f4             	mov    %edx,-0xc(%ebp)
     adc:	31 c8                	xor    %ecx,%eax
     ade:	0f b6 c0             	movzbl %al,%eax
     ae1:	85 c0                	test   %eax,%eax
     ae3:	74 17                	je     afc <pipe1+0x13b>
          printf(1, "pipe1 oops 2\n");
     ae5:	83 ec 08             	sub    $0x8,%esp
     ae8:	68 df 49 00 00       	push   $0x49df
     aed:	6a 01                	push   $0x1
     aef:	e8 a6 36 00 00       	call   419a <printf>
     af4:	83 c4 10             	add    $0x10,%esp
     af7:	e9 ac 00 00 00       	jmp    ba8 <pipe1+0x1e7>
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
     afc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b03:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     b06:	7c bd                	jl     ac5 <pipe1+0x104>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
     b08:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b0b:	01 45 e4             	add    %eax,-0x1c(%ebp)
      cc = cc * 2;
     b0e:	d1 65 e8             	shll   -0x18(%ebp)
      if(cc > sizeof(buf))
     b11:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b14:	3d 00 20 00 00       	cmp    $0x2000,%eax
     b19:	76 07                	jbe    b22 <pipe1+0x161>
        cc = sizeof(buf);
     b1b:	c7 45 e8 00 20 00 00 	movl   $0x2000,-0x18(%ebp)
    exit();
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     b22:	8b 45 d8             	mov    -0x28(%ebp),%eax
     b25:	83 ec 04             	sub    $0x4,%esp
     b28:	ff 75 e8             	pushl  -0x18(%ebp)
     b2b:	68 a0 8c 00 00       	push   $0x8ca0
     b30:	50                   	push   %eax
     b31:	e8 ed 34 00 00       	call   4023 <read>
     b36:	83 c4 10             	add    $0x10,%esp
     b39:	89 45 ec             	mov    %eax,-0x14(%ebp)
     b3c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     b40:	0f 8f 76 ff ff ff    	jg     abc <pipe1+0xfb>
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033){
     b46:	81 7d e4 2d 14 00 00 	cmpl   $0x142d,-0x1c(%ebp)
     b4d:	74 1a                	je     b69 <pipe1+0x1a8>
      printf(1, "pipe1 oops 3 total %d\n", total);
     b4f:	83 ec 04             	sub    $0x4,%esp
     b52:	ff 75 e4             	pushl  -0x1c(%ebp)
     b55:	68 ed 49 00 00       	push   $0x49ed
     b5a:	6a 01                	push   $0x1
     b5c:	e8 39 36 00 00       	call   419a <printf>
     b61:	83 c4 10             	add    $0x10,%esp
      exit();
     b64:	e8 a2 34 00 00       	call   400b <exit>
    }
    close(fds[0]);
     b69:	8b 45 d8             	mov    -0x28(%ebp),%eax
     b6c:	83 ec 0c             	sub    $0xc,%esp
     b6f:	50                   	push   %eax
     b70:	e8 be 34 00 00       	call   4033 <close>
     b75:	83 c4 10             	add    $0x10,%esp
    wait();
     b78:	e8 96 34 00 00       	call   4013 <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
     b7d:	83 ec 08             	sub    $0x8,%esp
     b80:	68 13 4a 00 00       	push   $0x4a13
     b85:	6a 01                	push   $0x1
     b87:	e8 0e 36 00 00       	call   419a <printf>
     b8c:	83 c4 10             	add    $0x10,%esp
     b8f:	eb 17                	jmp    ba8 <pipe1+0x1e7>
      exit();
    }
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
     b91:	83 ec 08             	sub    $0x8,%esp
     b94:	68 04 4a 00 00       	push   $0x4a04
     b99:	6a 01                	push   $0x1
     b9b:	e8 fa 35 00 00       	call   419a <printf>
     ba0:	83 c4 10             	add    $0x10,%esp
    exit();
     ba3:	e8 63 34 00 00       	call   400b <exit>
  }
  printf(1, "pipe1 ok\n");
}
     ba8:	c9                   	leave  
     ba9:	c3                   	ret    

00000baa <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     baa:	55                   	push   %ebp
     bab:	89 e5                	mov    %esp,%ebp
     bad:	83 ec 28             	sub    $0x28,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     bb0:	83 ec 08             	sub    $0x8,%esp
     bb3:	68 1d 4a 00 00       	push   $0x4a1d
     bb8:	6a 01                	push   $0x1
     bba:	e8 db 35 00 00       	call   419a <printf>
     bbf:	83 c4 10             	add    $0x10,%esp
  pid1 = fork();
     bc2:	e8 3c 34 00 00       	call   4003 <fork>
     bc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid1 == 0)
     bca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     bce:	75 02                	jne    bd2 <preempt+0x28>
    for(;;)
      ;
     bd0:	eb fe                	jmp    bd0 <preempt+0x26>

  pid2 = fork();
     bd2:	e8 2c 34 00 00       	call   4003 <fork>
     bd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid2 == 0)
     bda:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     bde:	75 02                	jne    be2 <preempt+0x38>
    for(;;)
      ;
     be0:	eb fe                	jmp    be0 <preempt+0x36>

  pipe(pfds);
     be2:	83 ec 0c             	sub    $0xc,%esp
     be5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     be8:	50                   	push   %eax
     be9:	e8 2d 34 00 00       	call   401b <pipe>
     bee:	83 c4 10             	add    $0x10,%esp
  pid3 = fork();
     bf1:	e8 0d 34 00 00       	call   4003 <fork>
     bf6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid3 == 0){
     bf9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     bfd:	75 4d                	jne    c4c <preempt+0xa2>
    close(pfds[0]);
     bff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c02:	83 ec 0c             	sub    $0xc,%esp
     c05:	50                   	push   %eax
     c06:	e8 28 34 00 00       	call   4033 <close>
     c0b:	83 c4 10             	add    $0x10,%esp
    if(write(pfds[1], "x", 1) != 1)
     c0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c11:	83 ec 04             	sub    $0x4,%esp
     c14:	6a 01                	push   $0x1
     c16:	68 27 4a 00 00       	push   $0x4a27
     c1b:	50                   	push   %eax
     c1c:	e8 0a 34 00 00       	call   402b <write>
     c21:	83 c4 10             	add    $0x10,%esp
     c24:	83 f8 01             	cmp    $0x1,%eax
     c27:	74 12                	je     c3b <preempt+0x91>
      printf(1, "preempt write error");
     c29:	83 ec 08             	sub    $0x8,%esp
     c2c:	68 29 4a 00 00       	push   $0x4a29
     c31:	6a 01                	push   $0x1
     c33:	e8 62 35 00 00       	call   419a <printf>
     c38:	83 c4 10             	add    $0x10,%esp
    close(pfds[1]);
     c3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c3e:	83 ec 0c             	sub    $0xc,%esp
     c41:	50                   	push   %eax
     c42:	e8 ec 33 00 00       	call   4033 <close>
     c47:	83 c4 10             	add    $0x10,%esp
    for(;;)
      ;
     c4a:	eb fe                	jmp    c4a <preempt+0xa0>
  }

  close(pfds[1]);
     c4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c4f:	83 ec 0c             	sub    $0xc,%esp
     c52:	50                   	push   %eax
     c53:	e8 db 33 00 00       	call   4033 <close>
     c58:	83 c4 10             	add    $0x10,%esp
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     c5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c5e:	83 ec 04             	sub    $0x4,%esp
     c61:	68 00 20 00 00       	push   $0x2000
     c66:	68 a0 8c 00 00       	push   $0x8ca0
     c6b:	50                   	push   %eax
     c6c:	e8 b2 33 00 00       	call   4023 <read>
     c71:	83 c4 10             	add    $0x10,%esp
     c74:	83 f8 01             	cmp    $0x1,%eax
     c77:	74 17                	je     c90 <preempt+0xe6>
    printf(1, "preempt read error");
     c79:	83 ec 08             	sub    $0x8,%esp
     c7c:	68 3d 4a 00 00       	push   $0x4a3d
     c81:	6a 01                	push   $0x1
     c83:	e8 12 35 00 00       	call   419a <printf>
     c88:	83 c4 10             	add    $0x10,%esp
     c8b:	e9 84 00 00 00       	jmp    d14 <preempt+0x16a>
    return;
  }
  close(pfds[0]);
     c90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c93:	83 ec 0c             	sub    $0xc,%esp
     c96:	50                   	push   %eax
     c97:	e8 97 33 00 00       	call   4033 <close>
     c9c:	83 c4 10             	add    $0x10,%esp
  printf(1, "kill... ");
     c9f:	83 ec 08             	sub    $0x8,%esp
     ca2:	68 50 4a 00 00       	push   $0x4a50
     ca7:	6a 01                	push   $0x1
     ca9:	e8 ec 34 00 00       	call   419a <printf>
     cae:	83 c4 10             	add    $0x10,%esp
  kill(pid1,SIGKILL);
     cb1:	83 ec 08             	sub    $0x8,%esp
     cb4:	6a 09                	push   $0x9
     cb6:	ff 75 f4             	pushl  -0xc(%ebp)
     cb9:	e8 7d 33 00 00       	call   403b <kill>
     cbe:	83 c4 10             	add    $0x10,%esp
  kill(pid2,SIGKILL);
     cc1:	83 ec 08             	sub    $0x8,%esp
     cc4:	6a 09                	push   $0x9
     cc6:	ff 75 f0             	pushl  -0x10(%ebp)
     cc9:	e8 6d 33 00 00       	call   403b <kill>
     cce:	83 c4 10             	add    $0x10,%esp
  kill(pid3,SIGKILL);
     cd1:	83 ec 08             	sub    $0x8,%esp
     cd4:	6a 09                	push   $0x9
     cd6:	ff 75 ec             	pushl  -0x14(%ebp)
     cd9:	e8 5d 33 00 00       	call   403b <kill>
     cde:	83 c4 10             	add    $0x10,%esp
  printf(1, "wait... ");
     ce1:	83 ec 08             	sub    $0x8,%esp
     ce4:	68 59 4a 00 00       	push   $0x4a59
     ce9:	6a 01                	push   $0x1
     ceb:	e8 aa 34 00 00       	call   419a <printf>
     cf0:	83 c4 10             	add    $0x10,%esp
  wait();
     cf3:	e8 1b 33 00 00       	call   4013 <wait>
  wait();
     cf8:	e8 16 33 00 00       	call   4013 <wait>
  wait();
     cfd:	e8 11 33 00 00       	call   4013 <wait>
  printf(1, "preempt ok\n");
     d02:	83 ec 08             	sub    $0x8,%esp
     d05:	68 62 4a 00 00       	push   $0x4a62
     d0a:	6a 01                	push   $0x1
     d0c:	e8 89 34 00 00       	call   419a <printf>
     d11:	83 c4 10             	add    $0x10,%esp
}
     d14:	c9                   	leave  
     d15:	c3                   	ret    

00000d16 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     d16:	55                   	push   %ebp
     d17:	89 e5                	mov    %esp,%ebp
     d19:	83 ec 18             	sub    $0x18,%esp
  int i, pid;

  for(i = 0; i < 100; i++){
     d1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     d23:	eb 4f                	jmp    d74 <exitwait+0x5e>
    pid = fork();
     d25:	e8 d9 32 00 00       	call   4003 <fork>
     d2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0){
     d2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d31:	79 14                	jns    d47 <exitwait+0x31>
      printf(1, "fork failed\n");
     d33:	83 ec 08             	sub    $0x8,%esp
     d36:	68 f1 45 00 00       	push   $0x45f1
     d3b:	6a 01                	push   $0x1
     d3d:	e8 58 34 00 00       	call   419a <printf>
     d42:	83 c4 10             	add    $0x10,%esp
      return;
     d45:	eb 45                	jmp    d8c <exitwait+0x76>
    }
    if(pid){
     d47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d4b:	74 1e                	je     d6b <exitwait+0x55>
      if(wait() != pid){
     d4d:	e8 c1 32 00 00       	call   4013 <wait>
     d52:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     d55:	74 19                	je     d70 <exitwait+0x5a>
        printf(1, "wait wrong pid\n");
     d57:	83 ec 08             	sub    $0x8,%esp
     d5a:	68 6e 4a 00 00       	push   $0x4a6e
     d5f:	6a 01                	push   $0x1
     d61:	e8 34 34 00 00       	call   419a <printf>
     d66:	83 c4 10             	add    $0x10,%esp
        return;
     d69:	eb 21                	jmp    d8c <exitwait+0x76>
      }
    } else {
      exit();
     d6b:	e8 9b 32 00 00       	call   400b <exit>
void
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
     d70:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     d74:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     d78:	7e ab                	jle    d25 <exitwait+0xf>
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
     d7a:	83 ec 08             	sub    $0x8,%esp
     d7d:	68 7e 4a 00 00       	push   $0x4a7e
     d82:	6a 01                	push   $0x1
     d84:	e8 11 34 00 00       	call   419a <printf>
     d89:	83 c4 10             	add    $0x10,%esp
}
     d8c:	c9                   	leave  
     d8d:	c3                   	ret    

00000d8e <mem>:

void
mem(void)
{
     d8e:	55                   	push   %ebp
     d8f:	89 e5                	mov    %esp,%ebp
     d91:	83 ec 18             	sub    $0x18,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     d94:	83 ec 08             	sub    $0x8,%esp
     d97:	68 8b 4a 00 00       	push   $0x4a8b
     d9c:	6a 01                	push   $0x1
     d9e:	e8 f7 33 00 00       	call   419a <printf>
     da3:	83 c4 10             	add    $0x10,%esp
  ppid = getpid();
     da6:	e8 e0 32 00 00       	call   408b <getpid>
     dab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((pid = fork()) == 0){
     dae:	e8 50 32 00 00       	call   4003 <fork>
     db3:	89 45 ec             	mov    %eax,-0x14(%ebp)
     db6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     dba:	0f 85 b9 00 00 00    	jne    e79 <mem+0xeb>
    m1 = 0;
     dc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
     dc7:	eb 0e                	jmp    dd7 <mem+0x49>
      *(char**)m2 = m1;
     dc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
     dcf:	89 10                	mov    %edx,(%eax)
      m1 = m2;
     dd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dd4:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1, "mem test\n");
  ppid = getpid();
  if((pid = fork()) == 0){
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
     dd7:	83 ec 0c             	sub    $0xc,%esp
     dda:	68 11 27 00 00       	push   $0x2711
     ddf:	e8 89 36 00 00       	call   446d <malloc>
     de4:	83 c4 10             	add    $0x10,%esp
     de7:	89 45 e8             	mov    %eax,-0x18(%ebp)
     dea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     dee:	75 d9                	jne    dc9 <mem+0x3b>
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     df0:	eb 1c                	jmp    e0e <mem+0x80>
      m2 = *(char**)m1;
     df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     df5:	8b 00                	mov    (%eax),%eax
     df7:	89 45 e8             	mov    %eax,-0x18(%ebp)
      free(m1);
     dfa:	83 ec 0c             	sub    $0xc,%esp
     dfd:	ff 75 f4             	pushl  -0xc(%ebp)
     e00:	e8 26 35 00 00       	call   432b <free>
     e05:	83 c4 10             	add    $0x10,%esp
      m1 = m2;
     e08:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     e0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e12:	75 de                	jne    df2 <mem+0x64>
      m2 = *(char**)m1;
      free(m1);
      m1 = m2;
    }
    m1 = malloc(1024*20);
     e14:	83 ec 0c             	sub    $0xc,%esp
     e17:	68 00 50 00 00       	push   $0x5000
     e1c:	e8 4c 36 00 00       	call   446d <malloc>
     e21:	83 c4 10             	add    $0x10,%esp
     e24:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(m1 == 0){
     e27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e2b:	75 27                	jne    e54 <mem+0xc6>
      printf(1, "couldn't allocate mem?!!\n");
     e2d:	83 ec 08             	sub    $0x8,%esp
     e30:	68 95 4a 00 00       	push   $0x4a95
     e35:	6a 01                	push   $0x1
     e37:	e8 5e 33 00 00       	call   419a <printf>
     e3c:	83 c4 10             	add    $0x10,%esp
      kill(ppid,SIGKILL);
     e3f:	83 ec 08             	sub    $0x8,%esp
     e42:	6a 09                	push   $0x9
     e44:	ff 75 f0             	pushl  -0x10(%ebp)
     e47:	e8 ef 31 00 00       	call   403b <kill>
     e4c:	83 c4 10             	add    $0x10,%esp
      exit();
     e4f:	e8 b7 31 00 00       	call   400b <exit>
    }
    free(m1);
     e54:	83 ec 0c             	sub    $0xc,%esp
     e57:	ff 75 f4             	pushl  -0xc(%ebp)
     e5a:	e8 cc 34 00 00       	call   432b <free>
     e5f:	83 c4 10             	add    $0x10,%esp
    printf(1, "mem ok\n");
     e62:	83 ec 08             	sub    $0x8,%esp
     e65:	68 af 4a 00 00       	push   $0x4aaf
     e6a:	6a 01                	push   $0x1
     e6c:	e8 29 33 00 00       	call   419a <printf>
     e71:	83 c4 10             	add    $0x10,%esp
    exit();
     e74:	e8 92 31 00 00       	call   400b <exit>
  } else {
    wait();
     e79:	e8 95 31 00 00       	call   4013 <wait>
  }
}
     e7e:	90                   	nop
     e7f:	c9                   	leave  
     e80:	c3                   	ret    

00000e81 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     e81:	55                   	push   %ebp
     e82:	89 e5                	mov    %esp,%ebp
     e84:	83 ec 38             	sub    $0x38,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     e87:	83 ec 08             	sub    $0x8,%esp
     e8a:	68 b7 4a 00 00       	push   $0x4ab7
     e8f:	6a 01                	push   $0x1
     e91:	e8 04 33 00 00       	call   419a <printf>
     e96:	83 c4 10             	add    $0x10,%esp

  unlink("sharedfd");
     e99:	83 ec 0c             	sub    $0xc,%esp
     e9c:	68 c6 4a 00 00       	push   $0x4ac6
     ea1:	e8 b5 31 00 00       	call   405b <unlink>
     ea6:	83 c4 10             	add    $0x10,%esp
  fd = open("sharedfd", O_CREATE|O_RDWR);
     ea9:	83 ec 08             	sub    $0x8,%esp
     eac:	68 02 02 00 00       	push   $0x202
     eb1:	68 c6 4a 00 00       	push   $0x4ac6
     eb6:	e8 90 31 00 00       	call   404b <open>
     ebb:	83 c4 10             	add    $0x10,%esp
     ebe:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     ec1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     ec5:	79 17                	jns    ede <sharedfd+0x5d>
    printf(1, "fstests: cannot open sharedfd for writing");
     ec7:	83 ec 08             	sub    $0x8,%esp
     eca:	68 d0 4a 00 00       	push   $0x4ad0
     ecf:	6a 01                	push   $0x1
     ed1:	e8 c4 32 00 00       	call   419a <printf>
     ed6:	83 c4 10             	add    $0x10,%esp
    return;
     ed9:	e9 84 01 00 00       	jmp    1062 <sharedfd+0x1e1>
  }
  pid = fork();
     ede:	e8 20 31 00 00       	call   4003 <fork>
     ee3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     ee6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     eea:	75 07                	jne    ef3 <sharedfd+0x72>
     eec:	b8 63 00 00 00       	mov    $0x63,%eax
     ef1:	eb 05                	jmp    ef8 <sharedfd+0x77>
     ef3:	b8 70 00 00 00       	mov    $0x70,%eax
     ef8:	83 ec 04             	sub    $0x4,%esp
     efb:	6a 0a                	push   $0xa
     efd:	50                   	push   %eax
     efe:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     f01:	50                   	push   %eax
     f02:	e8 69 2f 00 00       	call   3e70 <memset>
     f07:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 1000; i++){
     f0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     f11:	eb 31                	jmp    f44 <sharedfd+0xc3>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     f13:	83 ec 04             	sub    $0x4,%esp
     f16:	6a 0a                	push   $0xa
     f18:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     f1b:	50                   	push   %eax
     f1c:	ff 75 e8             	pushl  -0x18(%ebp)
     f1f:	e8 07 31 00 00       	call   402b <write>
     f24:	83 c4 10             	add    $0x10,%esp
     f27:	83 f8 0a             	cmp    $0xa,%eax
     f2a:	74 14                	je     f40 <sharedfd+0xbf>
      printf(1, "fstests: write sharedfd failed\n");
     f2c:	83 ec 08             	sub    $0x8,%esp
     f2f:	68 fc 4a 00 00       	push   $0x4afc
     f34:	6a 01                	push   $0x1
     f36:	e8 5f 32 00 00       	call   419a <printf>
     f3b:	83 c4 10             	add    $0x10,%esp
      break;
     f3e:	eb 0d                	jmp    f4d <sharedfd+0xcc>
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
  memset(buf, pid==0?'c':'p', sizeof(buf));
  for(i = 0; i < 1000; i++){
     f40:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     f44:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
     f4b:	7e c6                	jle    f13 <sharedfd+0x92>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
      printf(1, "fstests: write sharedfd failed\n");
      break;
    }
  }
  if(pid == 0)
     f4d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     f51:	75 05                	jne    f58 <sharedfd+0xd7>
    exit();
     f53:	e8 b3 30 00 00       	call   400b <exit>
  else
    wait();
     f58:	e8 b6 30 00 00       	call   4013 <wait>
  close(fd);
     f5d:	83 ec 0c             	sub    $0xc,%esp
     f60:	ff 75 e8             	pushl  -0x18(%ebp)
     f63:	e8 cb 30 00 00       	call   4033 <close>
     f68:	83 c4 10             	add    $0x10,%esp
  fd = open("sharedfd", 0);
     f6b:	83 ec 08             	sub    $0x8,%esp
     f6e:	6a 00                	push   $0x0
     f70:	68 c6 4a 00 00       	push   $0x4ac6
     f75:	e8 d1 30 00 00       	call   404b <open>
     f7a:	83 c4 10             	add    $0x10,%esp
     f7d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     f80:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     f84:	79 17                	jns    f9d <sharedfd+0x11c>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     f86:	83 ec 08             	sub    $0x8,%esp
     f89:	68 1c 4b 00 00       	push   $0x4b1c
     f8e:	6a 01                	push   $0x1
     f90:	e8 05 32 00 00       	call   419a <printf>
     f95:	83 c4 10             	add    $0x10,%esp
    return;
     f98:	e9 c5 00 00 00       	jmp    1062 <sharedfd+0x1e1>
  }
  nc = np = 0;
     f9d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     fa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
     fa7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
     faa:	eb 3b                	jmp    fe7 <sharedfd+0x166>
    for(i = 0; i < sizeof(buf); i++){
     fac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     fb3:	eb 2a                	jmp    fdf <sharedfd+0x15e>
      if(buf[i] == 'c')
     fb5:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fbb:	01 d0                	add    %edx,%eax
     fbd:	0f b6 00             	movzbl (%eax),%eax
     fc0:	3c 63                	cmp    $0x63,%al
     fc2:	75 04                	jne    fc8 <sharedfd+0x147>
        nc++;
     fc4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(buf[i] == 'p')
     fc8:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fce:	01 d0                	add    %edx,%eax
     fd0:	0f b6 00             	movzbl (%eax),%eax
     fd3:	3c 70                	cmp    $0x70,%al
     fd5:	75 04                	jne    fdb <sharedfd+0x15a>
        np++;
     fd7:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
     fdb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fe2:	83 f8 09             	cmp    $0x9,%eax
     fe5:	76 ce                	jbe    fb5 <sharedfd+0x134>
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
     fe7:	83 ec 04             	sub    $0x4,%esp
     fea:	6a 0a                	push   $0xa
     fec:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     fef:	50                   	push   %eax
     ff0:	ff 75 e8             	pushl  -0x18(%ebp)
     ff3:	e8 2b 30 00 00       	call   4023 <read>
     ff8:	83 c4 10             	add    $0x10,%esp
     ffb:	89 45 e0             	mov    %eax,-0x20(%ebp)
     ffe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    1002:	7f a8                	jg     fac <sharedfd+0x12b>
        nc++;
      if(buf[i] == 'p')
        np++;
    }
  }
  close(fd);
    1004:	83 ec 0c             	sub    $0xc,%esp
    1007:	ff 75 e8             	pushl  -0x18(%ebp)
    100a:	e8 24 30 00 00       	call   4033 <close>
    100f:	83 c4 10             	add    $0x10,%esp
  unlink("sharedfd");
    1012:	83 ec 0c             	sub    $0xc,%esp
    1015:	68 c6 4a 00 00       	push   $0x4ac6
    101a:	e8 3c 30 00 00       	call   405b <unlink>
    101f:	83 c4 10             	add    $0x10,%esp
  if(nc == 10000 && np == 10000){
    1022:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
    1029:	75 1d                	jne    1048 <sharedfd+0x1c7>
    102b:	81 7d ec 10 27 00 00 	cmpl   $0x2710,-0x14(%ebp)
    1032:	75 14                	jne    1048 <sharedfd+0x1c7>
    printf(1, "sharedfd ok\n");
    1034:	83 ec 08             	sub    $0x8,%esp
    1037:	68 47 4b 00 00       	push   $0x4b47
    103c:	6a 01                	push   $0x1
    103e:	e8 57 31 00 00       	call   419a <printf>
    1043:	83 c4 10             	add    $0x10,%esp
    1046:	eb 1a                	jmp    1062 <sharedfd+0x1e1>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    1048:	ff 75 ec             	pushl  -0x14(%ebp)
    104b:	ff 75 f0             	pushl  -0x10(%ebp)
    104e:	68 54 4b 00 00       	push   $0x4b54
    1053:	6a 01                	push   $0x1
    1055:	e8 40 31 00 00       	call   419a <printf>
    105a:	83 c4 10             	add    $0x10,%esp
    exit();
    105d:	e8 a9 2f 00 00       	call   400b <exit>
  }
}
    1062:	c9                   	leave  
    1063:	c3                   	ret    

00001064 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    1064:	55                   	push   %ebp
    1065:	89 e5                	mov    %esp,%ebp
    1067:	83 ec 38             	sub    $0x38,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    106a:	c7 45 c8 69 4b 00 00 	movl   $0x4b69,-0x38(%ebp)
    1071:	c7 45 cc 6c 4b 00 00 	movl   $0x4b6c,-0x34(%ebp)
    1078:	c7 45 d0 6f 4b 00 00 	movl   $0x4b6f,-0x30(%ebp)
    107f:	c7 45 d4 72 4b 00 00 	movl   $0x4b72,-0x2c(%ebp)
  char *fname;

  printf(1, "fourfiles test\n");
    1086:	83 ec 08             	sub    $0x8,%esp
    1089:	68 75 4b 00 00       	push   $0x4b75
    108e:	6a 01                	push   $0x1
    1090:	e8 05 31 00 00       	call   419a <printf>
    1095:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    1098:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    109f:	e9 f0 00 00 00       	jmp    1194 <fourfiles+0x130>
    fname = names[pi];
    10a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10a7:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    10ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    unlink(fname);
    10ae:	83 ec 0c             	sub    $0xc,%esp
    10b1:	ff 75 e4             	pushl  -0x1c(%ebp)
    10b4:	e8 a2 2f 00 00       	call   405b <unlink>
    10b9:	83 c4 10             	add    $0x10,%esp

    pid = fork();
    10bc:	e8 42 2f 00 00       	call   4003 <fork>
    10c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if(pid < 0){
    10c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    10c8:	79 17                	jns    10e1 <fourfiles+0x7d>
      printf(1, "fork failed\n");
    10ca:	83 ec 08             	sub    $0x8,%esp
    10cd:	68 f1 45 00 00       	push   $0x45f1
    10d2:	6a 01                	push   $0x1
    10d4:	e8 c1 30 00 00       	call   419a <printf>
    10d9:	83 c4 10             	add    $0x10,%esp
      exit();
    10dc:	e8 2a 2f 00 00       	call   400b <exit>
    }

    if(pid == 0){
    10e1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    10e5:	0f 85 a5 00 00 00    	jne    1190 <fourfiles+0x12c>
      fd = open(fname, O_CREATE | O_RDWR);
    10eb:	83 ec 08             	sub    $0x8,%esp
    10ee:	68 02 02 00 00       	push   $0x202
    10f3:	ff 75 e4             	pushl  -0x1c(%ebp)
    10f6:	e8 50 2f 00 00       	call   404b <open>
    10fb:	83 c4 10             	add    $0x10,%esp
    10fe:	89 45 dc             	mov    %eax,-0x24(%ebp)
      if(fd < 0){
    1101:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
    1105:	79 17                	jns    111e <fourfiles+0xba>
        printf(1, "create failed\n");
    1107:	83 ec 08             	sub    $0x8,%esp
    110a:	68 85 4b 00 00       	push   $0x4b85
    110f:	6a 01                	push   $0x1
    1111:	e8 84 30 00 00       	call   419a <printf>
    1116:	83 c4 10             	add    $0x10,%esp
        exit();
    1119:	e8 ed 2e 00 00       	call   400b <exit>
      }

      memset(buf, '0'+pi, 512);
    111e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1121:	83 c0 30             	add    $0x30,%eax
    1124:	83 ec 04             	sub    $0x4,%esp
    1127:	68 00 02 00 00       	push   $0x200
    112c:	50                   	push   %eax
    112d:	68 a0 8c 00 00       	push   $0x8ca0
    1132:	e8 39 2d 00 00       	call   3e70 <memset>
    1137:	83 c4 10             	add    $0x10,%esp
      for(i = 0; i < 12; i++){
    113a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1141:	eb 42                	jmp    1185 <fourfiles+0x121>
        if((n = write(fd, buf, 500)) != 500){
    1143:	83 ec 04             	sub    $0x4,%esp
    1146:	68 f4 01 00 00       	push   $0x1f4
    114b:	68 a0 8c 00 00       	push   $0x8ca0
    1150:	ff 75 dc             	pushl  -0x24(%ebp)
    1153:	e8 d3 2e 00 00       	call   402b <write>
    1158:	83 c4 10             	add    $0x10,%esp
    115b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    115e:	81 7d d8 f4 01 00 00 	cmpl   $0x1f4,-0x28(%ebp)
    1165:	74 1a                	je     1181 <fourfiles+0x11d>
          printf(1, "write failed %d\n", n);
    1167:	83 ec 04             	sub    $0x4,%esp
    116a:	ff 75 d8             	pushl  -0x28(%ebp)
    116d:	68 94 4b 00 00       	push   $0x4b94
    1172:	6a 01                	push   $0x1
    1174:	e8 21 30 00 00       	call   419a <printf>
    1179:	83 c4 10             	add    $0x10,%esp
          exit();
    117c:	e8 8a 2e 00 00       	call   400b <exit>
        printf(1, "create failed\n");
        exit();
      }

      memset(buf, '0'+pi, 512);
      for(i = 0; i < 12; i++){
    1181:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1185:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
    1189:	7e b8                	jle    1143 <fourfiles+0xdf>
        if((n = write(fd, buf, 500)) != 500){
          printf(1, "write failed %d\n", n);
          exit();
        }
      }
      exit();
    118b:	e8 7b 2e 00 00       	call   400b <exit>
  char *names[] = { "f0", "f1", "f2", "f3" };
  char *fname;

  printf(1, "fourfiles test\n");

  for(pi = 0; pi < 4; pi++){
    1190:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    1194:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    1198:	0f 8e 06 ff ff ff    	jle    10a4 <fourfiles+0x40>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    119e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    11a5:	eb 09                	jmp    11b0 <fourfiles+0x14c>
    wait();
    11a7:	e8 67 2e 00 00       	call   4013 <wait>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    11ac:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    11b0:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    11b4:	7e f1                	jle    11a7 <fourfiles+0x143>
    wait();
  }

  for(i = 0; i < 2; i++){
    11b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11bd:	e9 d4 00 00 00       	jmp    1296 <fourfiles+0x232>
    fname = names[i];
    11c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11c5:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    11c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    fd = open(fname, 0);
    11cc:	83 ec 08             	sub    $0x8,%esp
    11cf:	6a 00                	push   $0x0
    11d1:	ff 75 e4             	pushl  -0x1c(%ebp)
    11d4:	e8 72 2e 00 00       	call   404b <open>
    11d9:	83 c4 10             	add    $0x10,%esp
    11dc:	89 45 dc             	mov    %eax,-0x24(%ebp)
    total = 0;
    11df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    11e6:	eb 4a                	jmp    1232 <fourfiles+0x1ce>
      for(j = 0; j < n; j++){
    11e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    11ef:	eb 33                	jmp    1224 <fourfiles+0x1c0>
        if(buf[j] != '0'+i){
    11f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11f4:	05 a0 8c 00 00       	add    $0x8ca0,%eax
    11f9:	0f b6 00             	movzbl (%eax),%eax
    11fc:	0f be c0             	movsbl %al,%eax
    11ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1202:	83 c2 30             	add    $0x30,%edx
    1205:	39 d0                	cmp    %edx,%eax
    1207:	74 17                	je     1220 <fourfiles+0x1bc>
          printf(1, "wrong char\n");
    1209:	83 ec 08             	sub    $0x8,%esp
    120c:	68 a5 4b 00 00       	push   $0x4ba5
    1211:	6a 01                	push   $0x1
    1213:	e8 82 2f 00 00       	call   419a <printf>
    1218:	83 c4 10             	add    $0x10,%esp
          exit();
    121b:	e8 eb 2d 00 00       	call   400b <exit>
  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
    1220:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1224:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1227:	3b 45 d8             	cmp    -0x28(%ebp),%eax
    122a:	7c c5                	jl     11f1 <fourfiles+0x18d>
        if(buf[j] != '0'+i){
          printf(1, "wrong char\n");
          exit();
        }
      }
      total += n;
    122c:	8b 45 d8             	mov    -0x28(%ebp),%eax
    122f:	01 45 ec             	add    %eax,-0x14(%ebp)

  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1232:	83 ec 04             	sub    $0x4,%esp
    1235:	68 00 20 00 00       	push   $0x2000
    123a:	68 a0 8c 00 00       	push   $0x8ca0
    123f:	ff 75 dc             	pushl  -0x24(%ebp)
    1242:	e8 dc 2d 00 00       	call   4023 <read>
    1247:	83 c4 10             	add    $0x10,%esp
    124a:	89 45 d8             	mov    %eax,-0x28(%ebp)
    124d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
    1251:	7f 95                	jg     11e8 <fourfiles+0x184>
          exit();
        }
      }
      total += n;
    }
    close(fd);
    1253:	83 ec 0c             	sub    $0xc,%esp
    1256:	ff 75 dc             	pushl  -0x24(%ebp)
    1259:	e8 d5 2d 00 00       	call   4033 <close>
    125e:	83 c4 10             	add    $0x10,%esp
    if(total != 12*500){
    1261:	81 7d ec 70 17 00 00 	cmpl   $0x1770,-0x14(%ebp)
    1268:	74 1a                	je     1284 <fourfiles+0x220>
      printf(1, "wrong length %d\n", total);
    126a:	83 ec 04             	sub    $0x4,%esp
    126d:	ff 75 ec             	pushl  -0x14(%ebp)
    1270:	68 b1 4b 00 00       	push   $0x4bb1
    1275:	6a 01                	push   $0x1
    1277:	e8 1e 2f 00 00       	call   419a <printf>
    127c:	83 c4 10             	add    $0x10,%esp
      exit();
    127f:	e8 87 2d 00 00       	call   400b <exit>
    }
    unlink(fname);
    1284:	83 ec 0c             	sub    $0xc,%esp
    1287:	ff 75 e4             	pushl  -0x1c(%ebp)
    128a:	e8 cc 2d 00 00       	call   405b <unlink>
    128f:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    wait();
  }

  for(i = 0; i < 2; i++){
    1292:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1296:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
    129a:	0f 8e 22 ff ff ff    	jle    11c2 <fourfiles+0x15e>
      exit();
    }
    unlink(fname);
  }

  printf(1, "fourfiles ok\n");
    12a0:	83 ec 08             	sub    $0x8,%esp
    12a3:	68 c2 4b 00 00       	push   $0x4bc2
    12a8:	6a 01                	push   $0x1
    12aa:	e8 eb 2e 00 00       	call   419a <printf>
    12af:	83 c4 10             	add    $0x10,%esp
}
    12b2:	90                   	nop
    12b3:	c9                   	leave  
    12b4:	c3                   	ret    

000012b5 <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    12b5:	55                   	push   %ebp
    12b6:	89 e5                	mov    %esp,%ebp
    12b8:	83 ec 38             	sub    $0x38,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    12bb:	83 ec 08             	sub    $0x8,%esp
    12be:	68 d0 4b 00 00       	push   $0x4bd0
    12c3:	6a 01                	push   $0x1
    12c5:	e8 d0 2e 00 00       	call   419a <printf>
    12ca:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    12cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    12d4:	e9 f6 00 00 00       	jmp    13cf <createdelete+0x11a>
    pid = fork();
    12d9:	e8 25 2d 00 00       	call   4003 <fork>
    12de:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    12e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    12e5:	79 17                	jns    12fe <createdelete+0x49>
      printf(1, "fork failed\n");
    12e7:	83 ec 08             	sub    $0x8,%esp
    12ea:	68 f1 45 00 00       	push   $0x45f1
    12ef:	6a 01                	push   $0x1
    12f1:	e8 a4 2e 00 00       	call   419a <printf>
    12f6:	83 c4 10             	add    $0x10,%esp
      exit();
    12f9:	e8 0d 2d 00 00       	call   400b <exit>
    }

    if(pid == 0){
    12fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1302:	0f 85 c3 00 00 00    	jne    13cb <createdelete+0x116>
      name[0] = 'p' + pi;
    1308:	8b 45 f0             	mov    -0x10(%ebp),%eax
    130b:	83 c0 70             	add    $0x70,%eax
    130e:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[2] = '\0';
    1311:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
      for(i = 0; i < N; i++){
    1315:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    131c:	e9 9b 00 00 00       	jmp    13bc <createdelete+0x107>
        name[1] = '0' + i;
    1321:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1324:	83 c0 30             	add    $0x30,%eax
    1327:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    132a:	83 ec 08             	sub    $0x8,%esp
    132d:	68 02 02 00 00       	push   $0x202
    1332:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1335:	50                   	push   %eax
    1336:	e8 10 2d 00 00       	call   404b <open>
    133b:	83 c4 10             	add    $0x10,%esp
    133e:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if(fd < 0){
    1341:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1345:	79 17                	jns    135e <createdelete+0xa9>
          printf(1, "create failed\n");
    1347:	83 ec 08             	sub    $0x8,%esp
    134a:	68 85 4b 00 00       	push   $0x4b85
    134f:	6a 01                	push   $0x1
    1351:	e8 44 2e 00 00       	call   419a <printf>
    1356:	83 c4 10             	add    $0x10,%esp
          exit();
    1359:	e8 ad 2c 00 00       	call   400b <exit>
        }
        close(fd);
    135e:	83 ec 0c             	sub    $0xc,%esp
    1361:	ff 75 e8             	pushl  -0x18(%ebp)
    1364:	e8 ca 2c 00 00       	call   4033 <close>
    1369:	83 c4 10             	add    $0x10,%esp
        if(i > 0 && (i % 2 ) == 0){
    136c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1370:	7e 46                	jle    13b8 <createdelete+0x103>
    1372:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1375:	83 e0 01             	and    $0x1,%eax
    1378:	85 c0                	test   %eax,%eax
    137a:	75 3c                	jne    13b8 <createdelete+0x103>
          name[1] = '0' + (i / 2);
    137c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    137f:	89 c2                	mov    %eax,%edx
    1381:	c1 ea 1f             	shr    $0x1f,%edx
    1384:	01 d0                	add    %edx,%eax
    1386:	d1 f8                	sar    %eax
    1388:	83 c0 30             	add    $0x30,%eax
    138b:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    138e:	83 ec 0c             	sub    $0xc,%esp
    1391:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1394:	50                   	push   %eax
    1395:	e8 c1 2c 00 00       	call   405b <unlink>
    139a:	83 c4 10             	add    $0x10,%esp
    139d:	85 c0                	test   %eax,%eax
    139f:	79 17                	jns    13b8 <createdelete+0x103>
            printf(1, "unlink failed\n");
    13a1:	83 ec 08             	sub    $0x8,%esp
    13a4:	68 74 46 00 00       	push   $0x4674
    13a9:	6a 01                	push   $0x1
    13ab:	e8 ea 2d 00 00       	call   419a <printf>
    13b0:	83 c4 10             	add    $0x10,%esp
            exit();
    13b3:	e8 53 2c 00 00       	call   400b <exit>
    }

    if(pid == 0){
      name[0] = 'p' + pi;
      name[2] = '\0';
      for(i = 0; i < N; i++){
    13b8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    13bc:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    13c0:	0f 8e 5b ff ff ff    	jle    1321 <createdelete+0x6c>
            printf(1, "unlink failed\n");
            exit();
          }
        }
      }
      exit();
    13c6:	e8 40 2c 00 00       	call   400b <exit>
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");

  for(pi = 0; pi < 4; pi++){
    13cb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    13cf:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    13d3:	0f 8e 00 ff ff ff    	jle    12d9 <createdelete+0x24>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    13d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    13e0:	eb 09                	jmp    13eb <createdelete+0x136>
    wait();
    13e2:	e8 2c 2c 00 00       	call   4013 <wait>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    13e7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    13eb:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    13ef:	7e f1                	jle    13e2 <createdelete+0x12d>
    wait();
  }

  name[0] = name[1] = name[2] = 0;
    13f1:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    13f5:	0f b6 45 ca          	movzbl -0x36(%ebp),%eax
    13f9:	88 45 c9             	mov    %al,-0x37(%ebp)
    13fc:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
    1400:	88 45 c8             	mov    %al,-0x38(%ebp)
  for(i = 0; i < N; i++){
    1403:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    140a:	e9 b2 00 00 00       	jmp    14c1 <createdelete+0x20c>
    for(pi = 0; pi < 4; pi++){
    140f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1416:	e9 98 00 00 00       	jmp    14b3 <createdelete+0x1fe>
      name[0] = 'p' + pi;
    141b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    141e:	83 c0 70             	add    $0x70,%eax
    1421:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    1424:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1427:	83 c0 30             	add    $0x30,%eax
    142a:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    142d:	83 ec 08             	sub    $0x8,%esp
    1430:	6a 00                	push   $0x0
    1432:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1435:	50                   	push   %eax
    1436:	e8 10 2c 00 00       	call   404b <open>
    143b:	83 c4 10             	add    $0x10,%esp
    143e:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((i == 0 || i >= N/2) && fd < 0){
    1441:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1445:	74 06                	je     144d <createdelete+0x198>
    1447:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    144b:	7e 21                	jle    146e <createdelete+0x1b9>
    144d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1451:	79 1b                	jns    146e <createdelete+0x1b9>
        printf(1, "oops createdelete %s didn't exist\n", name);
    1453:	83 ec 04             	sub    $0x4,%esp
    1456:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1459:	50                   	push   %eax
    145a:	68 e4 4b 00 00       	push   $0x4be4
    145f:	6a 01                	push   $0x1
    1461:	e8 34 2d 00 00       	call   419a <printf>
    1466:	83 c4 10             	add    $0x10,%esp
        exit();
    1469:	e8 9d 2b 00 00       	call   400b <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    146e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1472:	7e 27                	jle    149b <createdelete+0x1e6>
    1474:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    1478:	7f 21                	jg     149b <createdelete+0x1e6>
    147a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    147e:	78 1b                	js     149b <createdelete+0x1e6>
        printf(1, "oops createdelete %s did exist\n", name);
    1480:	83 ec 04             	sub    $0x4,%esp
    1483:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1486:	50                   	push   %eax
    1487:	68 08 4c 00 00       	push   $0x4c08
    148c:	6a 01                	push   $0x1
    148e:	e8 07 2d 00 00       	call   419a <printf>
    1493:	83 c4 10             	add    $0x10,%esp
        exit();
    1496:	e8 70 2b 00 00       	call   400b <exit>
      }
      if(fd >= 0)
    149b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    149f:	78 0e                	js     14af <createdelete+0x1fa>
        close(fd);
    14a1:	83 ec 0c             	sub    $0xc,%esp
    14a4:	ff 75 e8             	pushl  -0x18(%ebp)
    14a7:	e8 87 2b 00 00       	call   4033 <close>
    14ac:	83 c4 10             	add    $0x10,%esp
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
    14af:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    14b3:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    14b7:	0f 8e 5e ff ff ff    	jle    141b <createdelete+0x166>
  for(pi = 0; pi < 4; pi++){
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    14bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    14c1:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    14c5:	0f 8e 44 ff ff ff    	jle    140f <createdelete+0x15a>
      if(fd >= 0)
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    14cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    14d2:	eb 38                	jmp    150c <createdelete+0x257>
    for(pi = 0; pi < 4; pi++){
    14d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    14db:	eb 25                	jmp    1502 <createdelete+0x24d>
      name[0] = 'p' + i;
    14dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14e0:	83 c0 70             	add    $0x70,%eax
    14e3:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    14e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14e9:	83 c0 30             	add    $0x30,%eax
    14ec:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    14ef:	83 ec 0c             	sub    $0xc,%esp
    14f2:	8d 45 c8             	lea    -0x38(%ebp),%eax
    14f5:	50                   	push   %eax
    14f6:	e8 60 2b 00 00       	call   405b <unlink>
    14fb:	83 c4 10             	add    $0x10,%esp
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
    14fe:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1502:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    1506:	7e d5                	jle    14dd <createdelete+0x228>
      if(fd >= 0)
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    1508:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    150c:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    1510:	7e c2                	jle    14d4 <createdelete+0x21f>
      name[1] = '0' + i;
      unlink(name);
    }
  }

  printf(1, "createdelete ok\n");
    1512:	83 ec 08             	sub    $0x8,%esp
    1515:	68 28 4c 00 00       	push   $0x4c28
    151a:	6a 01                	push   $0x1
    151c:	e8 79 2c 00 00       	call   419a <printf>
    1521:	83 c4 10             	add    $0x10,%esp
}
    1524:	90                   	nop
    1525:	c9                   	leave  
    1526:	c3                   	ret    

00001527 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    1527:	55                   	push   %ebp
    1528:	89 e5                	mov    %esp,%ebp
    152a:	83 ec 18             	sub    $0x18,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    152d:	83 ec 08             	sub    $0x8,%esp
    1530:	68 39 4c 00 00       	push   $0x4c39
    1535:	6a 01                	push   $0x1
    1537:	e8 5e 2c 00 00       	call   419a <printf>
    153c:	83 c4 10             	add    $0x10,%esp
  fd = open("unlinkread", O_CREATE | O_RDWR);
    153f:	83 ec 08             	sub    $0x8,%esp
    1542:	68 02 02 00 00       	push   $0x202
    1547:	68 4a 4c 00 00       	push   $0x4c4a
    154c:	e8 fa 2a 00 00       	call   404b <open>
    1551:	83 c4 10             	add    $0x10,%esp
    1554:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1557:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    155b:	79 17                	jns    1574 <unlinkread+0x4d>
    printf(1, "create unlinkread failed\n");
    155d:	83 ec 08             	sub    $0x8,%esp
    1560:	68 55 4c 00 00       	push   $0x4c55
    1565:	6a 01                	push   $0x1
    1567:	e8 2e 2c 00 00       	call   419a <printf>
    156c:	83 c4 10             	add    $0x10,%esp
    exit();
    156f:	e8 97 2a 00 00       	call   400b <exit>
  }
  write(fd, "hello", 5);
    1574:	83 ec 04             	sub    $0x4,%esp
    1577:	6a 05                	push   $0x5
    1579:	68 6f 4c 00 00       	push   $0x4c6f
    157e:	ff 75 f4             	pushl  -0xc(%ebp)
    1581:	e8 a5 2a 00 00       	call   402b <write>
    1586:	83 c4 10             	add    $0x10,%esp
  close(fd);
    1589:	83 ec 0c             	sub    $0xc,%esp
    158c:	ff 75 f4             	pushl  -0xc(%ebp)
    158f:	e8 9f 2a 00 00       	call   4033 <close>
    1594:	83 c4 10             	add    $0x10,%esp

  fd = open("unlinkread", O_RDWR);
    1597:	83 ec 08             	sub    $0x8,%esp
    159a:	6a 02                	push   $0x2
    159c:	68 4a 4c 00 00       	push   $0x4c4a
    15a1:	e8 a5 2a 00 00       	call   404b <open>
    15a6:	83 c4 10             	add    $0x10,%esp
    15a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    15ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15b0:	79 17                	jns    15c9 <unlinkread+0xa2>
    printf(1, "open unlinkread failed\n");
    15b2:	83 ec 08             	sub    $0x8,%esp
    15b5:	68 75 4c 00 00       	push   $0x4c75
    15ba:	6a 01                	push   $0x1
    15bc:	e8 d9 2b 00 00       	call   419a <printf>
    15c1:	83 c4 10             	add    $0x10,%esp
    exit();
    15c4:	e8 42 2a 00 00       	call   400b <exit>
  }
  if(unlink("unlinkread") != 0){
    15c9:	83 ec 0c             	sub    $0xc,%esp
    15cc:	68 4a 4c 00 00       	push   $0x4c4a
    15d1:	e8 85 2a 00 00       	call   405b <unlink>
    15d6:	83 c4 10             	add    $0x10,%esp
    15d9:	85 c0                	test   %eax,%eax
    15db:	74 17                	je     15f4 <unlinkread+0xcd>
    printf(1, "unlink unlinkread failed\n");
    15dd:	83 ec 08             	sub    $0x8,%esp
    15e0:	68 8d 4c 00 00       	push   $0x4c8d
    15e5:	6a 01                	push   $0x1
    15e7:	e8 ae 2b 00 00       	call   419a <printf>
    15ec:	83 c4 10             	add    $0x10,%esp
    exit();
    15ef:	e8 17 2a 00 00       	call   400b <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    15f4:	83 ec 08             	sub    $0x8,%esp
    15f7:	68 02 02 00 00       	push   $0x202
    15fc:	68 4a 4c 00 00       	push   $0x4c4a
    1601:	e8 45 2a 00 00       	call   404b <open>
    1606:	83 c4 10             	add    $0x10,%esp
    1609:	89 45 f0             	mov    %eax,-0x10(%ebp)
  write(fd1, "yyy", 3);
    160c:	83 ec 04             	sub    $0x4,%esp
    160f:	6a 03                	push   $0x3
    1611:	68 a7 4c 00 00       	push   $0x4ca7
    1616:	ff 75 f0             	pushl  -0x10(%ebp)
    1619:	e8 0d 2a 00 00       	call   402b <write>
    161e:	83 c4 10             	add    $0x10,%esp
  close(fd1);
    1621:	83 ec 0c             	sub    $0xc,%esp
    1624:	ff 75 f0             	pushl  -0x10(%ebp)
    1627:	e8 07 2a 00 00       	call   4033 <close>
    162c:	83 c4 10             	add    $0x10,%esp

  if(read(fd, buf, sizeof(buf)) != 5){
    162f:	83 ec 04             	sub    $0x4,%esp
    1632:	68 00 20 00 00       	push   $0x2000
    1637:	68 a0 8c 00 00       	push   $0x8ca0
    163c:	ff 75 f4             	pushl  -0xc(%ebp)
    163f:	e8 df 29 00 00       	call   4023 <read>
    1644:	83 c4 10             	add    $0x10,%esp
    1647:	83 f8 05             	cmp    $0x5,%eax
    164a:	74 17                	je     1663 <unlinkread+0x13c>
    printf(1, "unlinkread read failed");
    164c:	83 ec 08             	sub    $0x8,%esp
    164f:	68 ab 4c 00 00       	push   $0x4cab
    1654:	6a 01                	push   $0x1
    1656:	e8 3f 2b 00 00       	call   419a <printf>
    165b:	83 c4 10             	add    $0x10,%esp
    exit();
    165e:	e8 a8 29 00 00       	call   400b <exit>
  }
  if(buf[0] != 'h'){
    1663:	0f b6 05 a0 8c 00 00 	movzbl 0x8ca0,%eax
    166a:	3c 68                	cmp    $0x68,%al
    166c:	74 17                	je     1685 <unlinkread+0x15e>
    printf(1, "unlinkread wrong data\n");
    166e:	83 ec 08             	sub    $0x8,%esp
    1671:	68 c2 4c 00 00       	push   $0x4cc2
    1676:	6a 01                	push   $0x1
    1678:	e8 1d 2b 00 00       	call   419a <printf>
    167d:	83 c4 10             	add    $0x10,%esp
    exit();
    1680:	e8 86 29 00 00       	call   400b <exit>
  }
  if(write(fd, buf, 10) != 10){
    1685:	83 ec 04             	sub    $0x4,%esp
    1688:	6a 0a                	push   $0xa
    168a:	68 a0 8c 00 00       	push   $0x8ca0
    168f:	ff 75 f4             	pushl  -0xc(%ebp)
    1692:	e8 94 29 00 00       	call   402b <write>
    1697:	83 c4 10             	add    $0x10,%esp
    169a:	83 f8 0a             	cmp    $0xa,%eax
    169d:	74 17                	je     16b6 <unlinkread+0x18f>
    printf(1, "unlinkread write failed\n");
    169f:	83 ec 08             	sub    $0x8,%esp
    16a2:	68 d9 4c 00 00       	push   $0x4cd9
    16a7:	6a 01                	push   $0x1
    16a9:	e8 ec 2a 00 00       	call   419a <printf>
    16ae:	83 c4 10             	add    $0x10,%esp
    exit();
    16b1:	e8 55 29 00 00       	call   400b <exit>
  }
  close(fd);
    16b6:	83 ec 0c             	sub    $0xc,%esp
    16b9:	ff 75 f4             	pushl  -0xc(%ebp)
    16bc:	e8 72 29 00 00       	call   4033 <close>
    16c1:	83 c4 10             	add    $0x10,%esp
  unlink("unlinkread");
    16c4:	83 ec 0c             	sub    $0xc,%esp
    16c7:	68 4a 4c 00 00       	push   $0x4c4a
    16cc:	e8 8a 29 00 00       	call   405b <unlink>
    16d1:	83 c4 10             	add    $0x10,%esp
  printf(1, "unlinkread ok\n");
    16d4:	83 ec 08             	sub    $0x8,%esp
    16d7:	68 f2 4c 00 00       	push   $0x4cf2
    16dc:	6a 01                	push   $0x1
    16de:	e8 b7 2a 00 00       	call   419a <printf>
    16e3:	83 c4 10             	add    $0x10,%esp
}
    16e6:	90                   	nop
    16e7:	c9                   	leave  
    16e8:	c3                   	ret    

000016e9 <linktest>:

void
linktest(void)
{
    16e9:	55                   	push   %ebp
    16ea:	89 e5                	mov    %esp,%ebp
    16ec:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(1, "linktest\n");
    16ef:	83 ec 08             	sub    $0x8,%esp
    16f2:	68 01 4d 00 00       	push   $0x4d01
    16f7:	6a 01                	push   $0x1
    16f9:	e8 9c 2a 00 00       	call   419a <printf>
    16fe:	83 c4 10             	add    $0x10,%esp

  unlink("lf1");
    1701:	83 ec 0c             	sub    $0xc,%esp
    1704:	68 0b 4d 00 00       	push   $0x4d0b
    1709:	e8 4d 29 00 00       	call   405b <unlink>
    170e:	83 c4 10             	add    $0x10,%esp
  unlink("lf2");
    1711:	83 ec 0c             	sub    $0xc,%esp
    1714:	68 0f 4d 00 00       	push   $0x4d0f
    1719:	e8 3d 29 00 00       	call   405b <unlink>
    171e:	83 c4 10             	add    $0x10,%esp

  fd = open("lf1", O_CREATE|O_RDWR);
    1721:	83 ec 08             	sub    $0x8,%esp
    1724:	68 02 02 00 00       	push   $0x202
    1729:	68 0b 4d 00 00       	push   $0x4d0b
    172e:	e8 18 29 00 00       	call   404b <open>
    1733:	83 c4 10             	add    $0x10,%esp
    1736:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1739:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    173d:	79 17                	jns    1756 <linktest+0x6d>
    printf(1, "create lf1 failed\n");
    173f:	83 ec 08             	sub    $0x8,%esp
    1742:	68 13 4d 00 00       	push   $0x4d13
    1747:	6a 01                	push   $0x1
    1749:	e8 4c 2a 00 00       	call   419a <printf>
    174e:	83 c4 10             	add    $0x10,%esp
    exit();
    1751:	e8 b5 28 00 00       	call   400b <exit>
  }
  if(write(fd, "hello", 5) != 5){
    1756:	83 ec 04             	sub    $0x4,%esp
    1759:	6a 05                	push   $0x5
    175b:	68 6f 4c 00 00       	push   $0x4c6f
    1760:	ff 75 f4             	pushl  -0xc(%ebp)
    1763:	e8 c3 28 00 00       	call   402b <write>
    1768:	83 c4 10             	add    $0x10,%esp
    176b:	83 f8 05             	cmp    $0x5,%eax
    176e:	74 17                	je     1787 <linktest+0x9e>
    printf(1, "write lf1 failed\n");
    1770:	83 ec 08             	sub    $0x8,%esp
    1773:	68 26 4d 00 00       	push   $0x4d26
    1778:	6a 01                	push   $0x1
    177a:	e8 1b 2a 00 00       	call   419a <printf>
    177f:	83 c4 10             	add    $0x10,%esp
    exit();
    1782:	e8 84 28 00 00       	call   400b <exit>
  }
  close(fd);
    1787:	83 ec 0c             	sub    $0xc,%esp
    178a:	ff 75 f4             	pushl  -0xc(%ebp)
    178d:	e8 a1 28 00 00       	call   4033 <close>
    1792:	83 c4 10             	add    $0x10,%esp

  if(link("lf1", "lf2") < 0){
    1795:	83 ec 08             	sub    $0x8,%esp
    1798:	68 0f 4d 00 00       	push   $0x4d0f
    179d:	68 0b 4d 00 00       	push   $0x4d0b
    17a2:	e8 c4 28 00 00       	call   406b <link>
    17a7:	83 c4 10             	add    $0x10,%esp
    17aa:	85 c0                	test   %eax,%eax
    17ac:	79 17                	jns    17c5 <linktest+0xdc>
    printf(1, "link lf1 lf2 failed\n");
    17ae:	83 ec 08             	sub    $0x8,%esp
    17b1:	68 38 4d 00 00       	push   $0x4d38
    17b6:	6a 01                	push   $0x1
    17b8:	e8 dd 29 00 00       	call   419a <printf>
    17bd:	83 c4 10             	add    $0x10,%esp
    exit();
    17c0:	e8 46 28 00 00       	call   400b <exit>
  }
  unlink("lf1");
    17c5:	83 ec 0c             	sub    $0xc,%esp
    17c8:	68 0b 4d 00 00       	push   $0x4d0b
    17cd:	e8 89 28 00 00       	call   405b <unlink>
    17d2:	83 c4 10             	add    $0x10,%esp

  if(open("lf1", 0) >= 0){
    17d5:	83 ec 08             	sub    $0x8,%esp
    17d8:	6a 00                	push   $0x0
    17da:	68 0b 4d 00 00       	push   $0x4d0b
    17df:	e8 67 28 00 00       	call   404b <open>
    17e4:	83 c4 10             	add    $0x10,%esp
    17e7:	85 c0                	test   %eax,%eax
    17e9:	78 17                	js     1802 <linktest+0x119>
    printf(1, "unlinked lf1 but it is still there!\n");
    17eb:	83 ec 08             	sub    $0x8,%esp
    17ee:	68 50 4d 00 00       	push   $0x4d50
    17f3:	6a 01                	push   $0x1
    17f5:	e8 a0 29 00 00       	call   419a <printf>
    17fa:	83 c4 10             	add    $0x10,%esp
    exit();
    17fd:	e8 09 28 00 00       	call   400b <exit>
  }

  fd = open("lf2", 0);
    1802:	83 ec 08             	sub    $0x8,%esp
    1805:	6a 00                	push   $0x0
    1807:	68 0f 4d 00 00       	push   $0x4d0f
    180c:	e8 3a 28 00 00       	call   404b <open>
    1811:	83 c4 10             	add    $0x10,%esp
    1814:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1817:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    181b:	79 17                	jns    1834 <linktest+0x14b>
    printf(1, "open lf2 failed\n");
    181d:	83 ec 08             	sub    $0x8,%esp
    1820:	68 75 4d 00 00       	push   $0x4d75
    1825:	6a 01                	push   $0x1
    1827:	e8 6e 29 00 00       	call   419a <printf>
    182c:	83 c4 10             	add    $0x10,%esp
    exit();
    182f:	e8 d7 27 00 00       	call   400b <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    1834:	83 ec 04             	sub    $0x4,%esp
    1837:	68 00 20 00 00       	push   $0x2000
    183c:	68 a0 8c 00 00       	push   $0x8ca0
    1841:	ff 75 f4             	pushl  -0xc(%ebp)
    1844:	e8 da 27 00 00       	call   4023 <read>
    1849:	83 c4 10             	add    $0x10,%esp
    184c:	83 f8 05             	cmp    $0x5,%eax
    184f:	74 17                	je     1868 <linktest+0x17f>
    printf(1, "read lf2 failed\n");
    1851:	83 ec 08             	sub    $0x8,%esp
    1854:	68 86 4d 00 00       	push   $0x4d86
    1859:	6a 01                	push   $0x1
    185b:	e8 3a 29 00 00       	call   419a <printf>
    1860:	83 c4 10             	add    $0x10,%esp
    exit();
    1863:	e8 a3 27 00 00       	call   400b <exit>
  }
  close(fd);
    1868:	83 ec 0c             	sub    $0xc,%esp
    186b:	ff 75 f4             	pushl  -0xc(%ebp)
    186e:	e8 c0 27 00 00       	call   4033 <close>
    1873:	83 c4 10             	add    $0x10,%esp

  if(link("lf2", "lf2") >= 0){
    1876:	83 ec 08             	sub    $0x8,%esp
    1879:	68 0f 4d 00 00       	push   $0x4d0f
    187e:	68 0f 4d 00 00       	push   $0x4d0f
    1883:	e8 e3 27 00 00       	call   406b <link>
    1888:	83 c4 10             	add    $0x10,%esp
    188b:	85 c0                	test   %eax,%eax
    188d:	78 17                	js     18a6 <linktest+0x1bd>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    188f:	83 ec 08             	sub    $0x8,%esp
    1892:	68 97 4d 00 00       	push   $0x4d97
    1897:	6a 01                	push   $0x1
    1899:	e8 fc 28 00 00       	call   419a <printf>
    189e:	83 c4 10             	add    $0x10,%esp
    exit();
    18a1:	e8 65 27 00 00       	call   400b <exit>
  }

  unlink("lf2");
    18a6:	83 ec 0c             	sub    $0xc,%esp
    18a9:	68 0f 4d 00 00       	push   $0x4d0f
    18ae:	e8 a8 27 00 00       	call   405b <unlink>
    18b3:	83 c4 10             	add    $0x10,%esp
  if(link("lf2", "lf1") >= 0){
    18b6:	83 ec 08             	sub    $0x8,%esp
    18b9:	68 0b 4d 00 00       	push   $0x4d0b
    18be:	68 0f 4d 00 00       	push   $0x4d0f
    18c3:	e8 a3 27 00 00       	call   406b <link>
    18c8:	83 c4 10             	add    $0x10,%esp
    18cb:	85 c0                	test   %eax,%eax
    18cd:	78 17                	js     18e6 <linktest+0x1fd>
    printf(1, "link non-existant succeeded! oops\n");
    18cf:	83 ec 08             	sub    $0x8,%esp
    18d2:	68 b8 4d 00 00       	push   $0x4db8
    18d7:	6a 01                	push   $0x1
    18d9:	e8 bc 28 00 00       	call   419a <printf>
    18de:	83 c4 10             	add    $0x10,%esp
    exit();
    18e1:	e8 25 27 00 00       	call   400b <exit>
  }

  if(link(".", "lf1") >= 0){
    18e6:	83 ec 08             	sub    $0x8,%esp
    18e9:	68 0b 4d 00 00       	push   $0x4d0b
    18ee:	68 db 4d 00 00       	push   $0x4ddb
    18f3:	e8 73 27 00 00       	call   406b <link>
    18f8:	83 c4 10             	add    $0x10,%esp
    18fb:	85 c0                	test   %eax,%eax
    18fd:	78 17                	js     1916 <linktest+0x22d>
    printf(1, "link . lf1 succeeded! oops\n");
    18ff:	83 ec 08             	sub    $0x8,%esp
    1902:	68 dd 4d 00 00       	push   $0x4ddd
    1907:	6a 01                	push   $0x1
    1909:	e8 8c 28 00 00       	call   419a <printf>
    190e:	83 c4 10             	add    $0x10,%esp
    exit();
    1911:	e8 f5 26 00 00       	call   400b <exit>
  }

  printf(1, "linktest ok\n");
    1916:	83 ec 08             	sub    $0x8,%esp
    1919:	68 f9 4d 00 00       	push   $0x4df9
    191e:	6a 01                	push   $0x1
    1920:	e8 75 28 00 00       	call   419a <printf>
    1925:	83 c4 10             	add    $0x10,%esp
}
    1928:	90                   	nop
    1929:	c9                   	leave  
    192a:	c3                   	ret    

0000192b <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    192b:	55                   	push   %ebp
    192c:	89 e5                	mov    %esp,%ebp
    192e:	83 ec 58             	sub    $0x58,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    1931:	83 ec 08             	sub    $0x8,%esp
    1934:	68 06 4e 00 00       	push   $0x4e06
    1939:	6a 01                	push   $0x1
    193b:	e8 5a 28 00 00       	call   419a <printf>
    1940:	83 c4 10             	add    $0x10,%esp
  file[0] = 'C';
    1943:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    1947:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    194b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1952:	e9 fc 00 00 00       	jmp    1a53 <concreate+0x128>
    file[1] = '0' + i;
    1957:	8b 45 f4             	mov    -0xc(%ebp),%eax
    195a:	83 c0 30             	add    $0x30,%eax
    195d:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    1960:	83 ec 0c             	sub    $0xc,%esp
    1963:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1966:	50                   	push   %eax
    1967:	e8 ef 26 00 00       	call   405b <unlink>
    196c:	83 c4 10             	add    $0x10,%esp
    pid = fork();
    196f:	e8 8f 26 00 00       	call   4003 <fork>
    1974:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid && (i % 3) == 1){
    1977:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    197b:	74 3b                	je     19b8 <concreate+0x8d>
    197d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1980:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1985:	89 c8                	mov    %ecx,%eax
    1987:	f7 ea                	imul   %edx
    1989:	89 c8                	mov    %ecx,%eax
    198b:	c1 f8 1f             	sar    $0x1f,%eax
    198e:	29 c2                	sub    %eax,%edx
    1990:	89 d0                	mov    %edx,%eax
    1992:	01 c0                	add    %eax,%eax
    1994:	01 d0                	add    %edx,%eax
    1996:	29 c1                	sub    %eax,%ecx
    1998:	89 ca                	mov    %ecx,%edx
    199a:	83 fa 01             	cmp    $0x1,%edx
    199d:	75 19                	jne    19b8 <concreate+0x8d>
      link("C0", file);
    199f:	83 ec 08             	sub    $0x8,%esp
    19a2:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19a5:	50                   	push   %eax
    19a6:	68 16 4e 00 00       	push   $0x4e16
    19ab:	e8 bb 26 00 00       	call   406b <link>
    19b0:	83 c4 10             	add    $0x10,%esp
    19b3:	e9 87 00 00 00       	jmp    1a3f <concreate+0x114>
    } else if(pid == 0 && (i % 5) == 1){
    19b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    19bc:	75 3b                	jne    19f9 <concreate+0xce>
    19be:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    19c1:	ba 67 66 66 66       	mov    $0x66666667,%edx
    19c6:	89 c8                	mov    %ecx,%eax
    19c8:	f7 ea                	imul   %edx
    19ca:	d1 fa                	sar    %edx
    19cc:	89 c8                	mov    %ecx,%eax
    19ce:	c1 f8 1f             	sar    $0x1f,%eax
    19d1:	29 c2                	sub    %eax,%edx
    19d3:	89 d0                	mov    %edx,%eax
    19d5:	c1 e0 02             	shl    $0x2,%eax
    19d8:	01 d0                	add    %edx,%eax
    19da:	29 c1                	sub    %eax,%ecx
    19dc:	89 ca                	mov    %ecx,%edx
    19de:	83 fa 01             	cmp    $0x1,%edx
    19e1:	75 16                	jne    19f9 <concreate+0xce>
      link("C0", file);
    19e3:	83 ec 08             	sub    $0x8,%esp
    19e6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19e9:	50                   	push   %eax
    19ea:	68 16 4e 00 00       	push   $0x4e16
    19ef:	e8 77 26 00 00       	call   406b <link>
    19f4:	83 c4 10             	add    $0x10,%esp
    19f7:	eb 46                	jmp    1a3f <concreate+0x114>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    19f9:	83 ec 08             	sub    $0x8,%esp
    19fc:	68 02 02 00 00       	push   $0x202
    1a01:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1a04:	50                   	push   %eax
    1a05:	e8 41 26 00 00       	call   404b <open>
    1a0a:	83 c4 10             	add    $0x10,%esp
    1a0d:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(fd < 0){
    1a10:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1a14:	79 1b                	jns    1a31 <concreate+0x106>
        printf(1, "concreate create %s failed\n", file);
    1a16:	83 ec 04             	sub    $0x4,%esp
    1a19:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1a1c:	50                   	push   %eax
    1a1d:	68 19 4e 00 00       	push   $0x4e19
    1a22:	6a 01                	push   $0x1
    1a24:	e8 71 27 00 00       	call   419a <printf>
    1a29:	83 c4 10             	add    $0x10,%esp
        exit();
    1a2c:	e8 da 25 00 00       	call   400b <exit>
      }
      close(fd);
    1a31:	83 ec 0c             	sub    $0xc,%esp
    1a34:	ff 75 e8             	pushl  -0x18(%ebp)
    1a37:	e8 f7 25 00 00       	call   4033 <close>
    1a3c:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    1a3f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a43:	75 05                	jne    1a4a <concreate+0x11f>
      exit();
    1a45:	e8 c1 25 00 00       	call   400b <exit>
    else
      wait();
    1a4a:	e8 c4 25 00 00       	call   4013 <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    1a4f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1a53:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1a57:	0f 8e fa fe ff ff    	jle    1957 <concreate+0x2c>
      exit();
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    1a5d:	83 ec 04             	sub    $0x4,%esp
    1a60:	6a 28                	push   $0x28
    1a62:	6a 00                	push   $0x0
    1a64:	8d 45 bd             	lea    -0x43(%ebp),%eax
    1a67:	50                   	push   %eax
    1a68:	e8 03 24 00 00       	call   3e70 <memset>
    1a6d:	83 c4 10             	add    $0x10,%esp
  fd = open(".", 0);
    1a70:	83 ec 08             	sub    $0x8,%esp
    1a73:	6a 00                	push   $0x0
    1a75:	68 db 4d 00 00       	push   $0x4ddb
    1a7a:	e8 cc 25 00 00       	call   404b <open>
    1a7f:	83 c4 10             	add    $0x10,%esp
    1a82:	89 45 e8             	mov    %eax,-0x18(%ebp)
  n = 0;
    1a85:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    1a8c:	e9 93 00 00 00       	jmp    1b24 <concreate+0x1f9>
    if(de.inum == 0)
    1a91:	0f b7 45 ac          	movzwl -0x54(%ebp),%eax
    1a95:	66 85 c0             	test   %ax,%ax
    1a98:	75 05                	jne    1a9f <concreate+0x174>
      continue;
    1a9a:	e9 85 00 00 00       	jmp    1b24 <concreate+0x1f9>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1a9f:	0f b6 45 ae          	movzbl -0x52(%ebp),%eax
    1aa3:	3c 43                	cmp    $0x43,%al
    1aa5:	75 7d                	jne    1b24 <concreate+0x1f9>
    1aa7:	0f b6 45 b0          	movzbl -0x50(%ebp),%eax
    1aab:	84 c0                	test   %al,%al
    1aad:	75 75                	jne    1b24 <concreate+0x1f9>
      i = de.name[1] - '0';
    1aaf:	0f b6 45 af          	movzbl -0x51(%ebp),%eax
    1ab3:	0f be c0             	movsbl %al,%eax
    1ab6:	83 e8 30             	sub    $0x30,%eax
    1ab9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(i < 0 || i >= sizeof(fa)){
    1abc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1ac0:	78 08                	js     1aca <concreate+0x19f>
    1ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ac5:	83 f8 27             	cmp    $0x27,%eax
    1ac8:	76 1e                	jbe    1ae8 <concreate+0x1bd>
        printf(1, "concreate weird file %s\n", de.name);
    1aca:	83 ec 04             	sub    $0x4,%esp
    1acd:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1ad0:	83 c0 02             	add    $0x2,%eax
    1ad3:	50                   	push   %eax
    1ad4:	68 35 4e 00 00       	push   $0x4e35
    1ad9:	6a 01                	push   $0x1
    1adb:	e8 ba 26 00 00       	call   419a <printf>
    1ae0:	83 c4 10             	add    $0x10,%esp
        exit();
    1ae3:	e8 23 25 00 00       	call   400b <exit>
      }
      if(fa[i]){
    1ae8:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aee:	01 d0                	add    %edx,%eax
    1af0:	0f b6 00             	movzbl (%eax),%eax
    1af3:	84 c0                	test   %al,%al
    1af5:	74 1e                	je     1b15 <concreate+0x1ea>
        printf(1, "concreate duplicate file %s\n", de.name);
    1af7:	83 ec 04             	sub    $0x4,%esp
    1afa:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1afd:	83 c0 02             	add    $0x2,%eax
    1b00:	50                   	push   %eax
    1b01:	68 4e 4e 00 00       	push   $0x4e4e
    1b06:	6a 01                	push   $0x1
    1b08:	e8 8d 26 00 00       	call   419a <printf>
    1b0d:	83 c4 10             	add    $0x10,%esp
        exit();
    1b10:	e8 f6 24 00 00       	call   400b <exit>
      }
      fa[i] = 1;
    1b15:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b1b:	01 d0                	add    %edx,%eax
    1b1d:	c6 00 01             	movb   $0x1,(%eax)
      n++;
    1b20:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  }

  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    1b24:	83 ec 04             	sub    $0x4,%esp
    1b27:	6a 10                	push   $0x10
    1b29:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1b2c:	50                   	push   %eax
    1b2d:	ff 75 e8             	pushl  -0x18(%ebp)
    1b30:	e8 ee 24 00 00       	call   4023 <read>
    1b35:	83 c4 10             	add    $0x10,%esp
    1b38:	85 c0                	test   %eax,%eax
    1b3a:	0f 8f 51 ff ff ff    	jg     1a91 <concreate+0x166>
      }
      fa[i] = 1;
      n++;
    }
  }
  close(fd);
    1b40:	83 ec 0c             	sub    $0xc,%esp
    1b43:	ff 75 e8             	pushl  -0x18(%ebp)
    1b46:	e8 e8 24 00 00       	call   4033 <close>
    1b4b:	83 c4 10             	add    $0x10,%esp

  if(n != 40){
    1b4e:	83 7d f0 28          	cmpl   $0x28,-0x10(%ebp)
    1b52:	74 17                	je     1b6b <concreate+0x240>
    printf(1, "concreate not enough files in directory listing\n");
    1b54:	83 ec 08             	sub    $0x8,%esp
    1b57:	68 6c 4e 00 00       	push   $0x4e6c
    1b5c:	6a 01                	push   $0x1
    1b5e:	e8 37 26 00 00       	call   419a <printf>
    1b63:	83 c4 10             	add    $0x10,%esp
    exit();
    1b66:	e8 a0 24 00 00       	call   400b <exit>
  }

  for(i = 0; i < 40; i++){
    1b6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1b72:	e9 45 01 00 00       	jmp    1cbc <concreate+0x391>
    file[1] = '0' + i;
    1b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b7a:	83 c0 30             	add    $0x30,%eax
    1b7d:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    1b80:	e8 7e 24 00 00       	call   4003 <fork>
    1b85:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    1b88:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b8c:	79 17                	jns    1ba5 <concreate+0x27a>
      printf(1, "fork failed\n");
    1b8e:	83 ec 08             	sub    $0x8,%esp
    1b91:	68 f1 45 00 00       	push   $0x45f1
    1b96:	6a 01                	push   $0x1
    1b98:	e8 fd 25 00 00       	call   419a <printf>
    1b9d:	83 c4 10             	add    $0x10,%esp
      exit();
    1ba0:	e8 66 24 00 00       	call   400b <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    1ba5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1ba8:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1bad:	89 c8                	mov    %ecx,%eax
    1baf:	f7 ea                	imul   %edx
    1bb1:	89 c8                	mov    %ecx,%eax
    1bb3:	c1 f8 1f             	sar    $0x1f,%eax
    1bb6:	29 c2                	sub    %eax,%edx
    1bb8:	89 d0                	mov    %edx,%eax
    1bba:	89 c2                	mov    %eax,%edx
    1bbc:	01 d2                	add    %edx,%edx
    1bbe:	01 c2                	add    %eax,%edx
    1bc0:	89 c8                	mov    %ecx,%eax
    1bc2:	29 d0                	sub    %edx,%eax
    1bc4:	85 c0                	test   %eax,%eax
    1bc6:	75 06                	jne    1bce <concreate+0x2a3>
    1bc8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1bcc:	74 28                	je     1bf6 <concreate+0x2cb>
       ((i % 3) == 1 && pid != 0)){
    1bce:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1bd1:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1bd6:	89 c8                	mov    %ecx,%eax
    1bd8:	f7 ea                	imul   %edx
    1bda:	89 c8                	mov    %ecx,%eax
    1bdc:	c1 f8 1f             	sar    $0x1f,%eax
    1bdf:	29 c2                	sub    %eax,%edx
    1be1:	89 d0                	mov    %edx,%eax
    1be3:	01 c0                	add    %eax,%eax
    1be5:	01 d0                	add    %edx,%eax
    1be7:	29 c1                	sub    %eax,%ecx
    1be9:	89 ca                	mov    %ecx,%edx
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    1beb:	83 fa 01             	cmp    $0x1,%edx
    1bee:	75 7c                	jne    1c6c <concreate+0x341>
       ((i % 3) == 1 && pid != 0)){
    1bf0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1bf4:	74 76                	je     1c6c <concreate+0x341>
      close(open(file, 0));
    1bf6:	83 ec 08             	sub    $0x8,%esp
    1bf9:	6a 00                	push   $0x0
    1bfb:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1bfe:	50                   	push   %eax
    1bff:	e8 47 24 00 00       	call   404b <open>
    1c04:	83 c4 10             	add    $0x10,%esp
    1c07:	83 ec 0c             	sub    $0xc,%esp
    1c0a:	50                   	push   %eax
    1c0b:	e8 23 24 00 00       	call   4033 <close>
    1c10:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1c13:	83 ec 08             	sub    $0x8,%esp
    1c16:	6a 00                	push   $0x0
    1c18:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c1b:	50                   	push   %eax
    1c1c:	e8 2a 24 00 00       	call   404b <open>
    1c21:	83 c4 10             	add    $0x10,%esp
    1c24:	83 ec 0c             	sub    $0xc,%esp
    1c27:	50                   	push   %eax
    1c28:	e8 06 24 00 00       	call   4033 <close>
    1c2d:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1c30:	83 ec 08             	sub    $0x8,%esp
    1c33:	6a 00                	push   $0x0
    1c35:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c38:	50                   	push   %eax
    1c39:	e8 0d 24 00 00       	call   404b <open>
    1c3e:	83 c4 10             	add    $0x10,%esp
    1c41:	83 ec 0c             	sub    $0xc,%esp
    1c44:	50                   	push   %eax
    1c45:	e8 e9 23 00 00       	call   4033 <close>
    1c4a:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1c4d:	83 ec 08             	sub    $0x8,%esp
    1c50:	6a 00                	push   $0x0
    1c52:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c55:	50                   	push   %eax
    1c56:	e8 f0 23 00 00       	call   404b <open>
    1c5b:	83 c4 10             	add    $0x10,%esp
    1c5e:	83 ec 0c             	sub    $0xc,%esp
    1c61:	50                   	push   %eax
    1c62:	e8 cc 23 00 00       	call   4033 <close>
    1c67:	83 c4 10             	add    $0x10,%esp
    1c6a:	eb 3c                	jmp    1ca8 <concreate+0x37d>
    } else {
      unlink(file);
    1c6c:	83 ec 0c             	sub    $0xc,%esp
    1c6f:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c72:	50                   	push   %eax
    1c73:	e8 e3 23 00 00       	call   405b <unlink>
    1c78:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1c7b:	83 ec 0c             	sub    $0xc,%esp
    1c7e:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c81:	50                   	push   %eax
    1c82:	e8 d4 23 00 00       	call   405b <unlink>
    1c87:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1c8a:	83 ec 0c             	sub    $0xc,%esp
    1c8d:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c90:	50                   	push   %eax
    1c91:	e8 c5 23 00 00       	call   405b <unlink>
    1c96:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1c99:	83 ec 0c             	sub    $0xc,%esp
    1c9c:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c9f:	50                   	push   %eax
    1ca0:	e8 b6 23 00 00       	call   405b <unlink>
    1ca5:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    1ca8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1cac:	75 05                	jne    1cb3 <concreate+0x388>
      exit();
    1cae:	e8 58 23 00 00       	call   400b <exit>
    else
      wait();
    1cb3:	e8 5b 23 00 00       	call   4013 <wait>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    1cb8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1cbc:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1cc0:	0f 8e b1 fe ff ff    	jle    1b77 <concreate+0x24c>
      exit();
    else
      wait();
  }

  printf(1, "concreate ok\n");
    1cc6:	83 ec 08             	sub    $0x8,%esp
    1cc9:	68 9d 4e 00 00       	push   $0x4e9d
    1cce:	6a 01                	push   $0x1
    1cd0:	e8 c5 24 00 00       	call   419a <printf>
    1cd5:	83 c4 10             	add    $0x10,%esp
}
    1cd8:	90                   	nop
    1cd9:	c9                   	leave  
    1cda:	c3                   	ret    

00001cdb <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1cdb:	55                   	push   %ebp
    1cdc:	89 e5                	mov    %esp,%ebp
    1cde:	83 ec 18             	sub    $0x18,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1ce1:	83 ec 08             	sub    $0x8,%esp
    1ce4:	68 ab 4e 00 00       	push   $0x4eab
    1ce9:	6a 01                	push   $0x1
    1ceb:	e8 aa 24 00 00       	call   419a <printf>
    1cf0:	83 c4 10             	add    $0x10,%esp

  unlink("x");
    1cf3:	83 ec 0c             	sub    $0xc,%esp
    1cf6:	68 27 4a 00 00       	push   $0x4a27
    1cfb:	e8 5b 23 00 00       	call   405b <unlink>
    1d00:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    1d03:	e8 fb 22 00 00       	call   4003 <fork>
    1d08:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid < 0){
    1d0b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d0f:	79 17                	jns    1d28 <linkunlink+0x4d>
    printf(1, "fork failed\n");
    1d11:	83 ec 08             	sub    $0x8,%esp
    1d14:	68 f1 45 00 00       	push   $0x45f1
    1d19:	6a 01                	push   $0x1
    1d1b:	e8 7a 24 00 00       	call   419a <printf>
    1d20:	83 c4 10             	add    $0x10,%esp
    exit();
    1d23:	e8 e3 22 00 00       	call   400b <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    1d28:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d2c:	74 07                	je     1d35 <linkunlink+0x5a>
    1d2e:	b8 01 00 00 00       	mov    $0x1,%eax
    1d33:	eb 05                	jmp    1d3a <linkunlink+0x5f>
    1d35:	b8 61 00 00 00       	mov    $0x61,%eax
    1d3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 100; i++){
    1d3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1d44:	e9 9a 00 00 00       	jmp    1de3 <linkunlink+0x108>
    x = x * 1103515245 + 12345;
    1d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d4c:	69 c0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%eax
    1d52:	05 39 30 00 00       	add    $0x3039,%eax
    1d57:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((x % 3) == 0){
    1d5a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1d5d:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1d62:	89 c8                	mov    %ecx,%eax
    1d64:	f7 e2                	mul    %edx
    1d66:	89 d0                	mov    %edx,%eax
    1d68:	d1 e8                	shr    %eax
    1d6a:	89 c2                	mov    %eax,%edx
    1d6c:	01 d2                	add    %edx,%edx
    1d6e:	01 c2                	add    %eax,%edx
    1d70:	89 c8                	mov    %ecx,%eax
    1d72:	29 d0                	sub    %edx,%eax
    1d74:	85 c0                	test   %eax,%eax
    1d76:	75 23                	jne    1d9b <linkunlink+0xc0>
      close(open("x", O_RDWR | O_CREATE));
    1d78:	83 ec 08             	sub    $0x8,%esp
    1d7b:	68 02 02 00 00       	push   $0x202
    1d80:	68 27 4a 00 00       	push   $0x4a27
    1d85:	e8 c1 22 00 00       	call   404b <open>
    1d8a:	83 c4 10             	add    $0x10,%esp
    1d8d:	83 ec 0c             	sub    $0xc,%esp
    1d90:	50                   	push   %eax
    1d91:	e8 9d 22 00 00       	call   4033 <close>
    1d96:	83 c4 10             	add    $0x10,%esp
    1d99:	eb 44                	jmp    1ddf <linkunlink+0x104>
    } else if((x % 3) == 1){
    1d9b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1d9e:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1da3:	89 c8                	mov    %ecx,%eax
    1da5:	f7 e2                	mul    %edx
    1da7:	d1 ea                	shr    %edx
    1da9:	89 d0                	mov    %edx,%eax
    1dab:	01 c0                	add    %eax,%eax
    1dad:	01 d0                	add    %edx,%eax
    1daf:	29 c1                	sub    %eax,%ecx
    1db1:	89 ca                	mov    %ecx,%edx
    1db3:	83 fa 01             	cmp    $0x1,%edx
    1db6:	75 17                	jne    1dcf <linkunlink+0xf4>
      link("cat", "x");
    1db8:	83 ec 08             	sub    $0x8,%esp
    1dbb:	68 27 4a 00 00       	push   $0x4a27
    1dc0:	68 bc 4e 00 00       	push   $0x4ebc
    1dc5:	e8 a1 22 00 00       	call   406b <link>
    1dca:	83 c4 10             	add    $0x10,%esp
    1dcd:	eb 10                	jmp    1ddf <linkunlink+0x104>
    } else {
      unlink("x");
    1dcf:	83 ec 0c             	sub    $0xc,%esp
    1dd2:	68 27 4a 00 00       	push   $0x4a27
    1dd7:	e8 7f 22 00 00       	call   405b <unlink>
    1ddc:	83 c4 10             	add    $0x10,%esp
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
  for(i = 0; i < 100; i++){
    1ddf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1de3:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    1de7:	0f 8e 5c ff ff ff    	jle    1d49 <linkunlink+0x6e>
    } else {
      unlink("x");
    }
  }

  if(pid)
    1ded:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1df1:	74 07                	je     1dfa <linkunlink+0x11f>
    wait();
    1df3:	e8 1b 22 00 00       	call   4013 <wait>
    1df8:	eb 05                	jmp    1dff <linkunlink+0x124>
  else
    exit();
    1dfa:	e8 0c 22 00 00       	call   400b <exit>

  printf(1, "linkunlink ok\n");
    1dff:	83 ec 08             	sub    $0x8,%esp
    1e02:	68 c0 4e 00 00       	push   $0x4ec0
    1e07:	6a 01                	push   $0x1
    1e09:	e8 8c 23 00 00       	call   419a <printf>
    1e0e:	83 c4 10             	add    $0x10,%esp
}
    1e11:	90                   	nop
    1e12:	c9                   	leave  
    1e13:	c3                   	ret    

00001e14 <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    1e14:	55                   	push   %ebp
    1e15:	89 e5                	mov    %esp,%ebp
    1e17:	83 ec 28             	sub    $0x28,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1e1a:	83 ec 08             	sub    $0x8,%esp
    1e1d:	68 cf 4e 00 00       	push   $0x4ecf
    1e22:	6a 01                	push   $0x1
    1e24:	e8 71 23 00 00       	call   419a <printf>
    1e29:	83 c4 10             	add    $0x10,%esp
  unlink("bd");
    1e2c:	83 ec 0c             	sub    $0xc,%esp
    1e2f:	68 dc 4e 00 00       	push   $0x4edc
    1e34:	e8 22 22 00 00       	call   405b <unlink>
    1e39:	83 c4 10             	add    $0x10,%esp

  fd = open("bd", O_CREATE);
    1e3c:	83 ec 08             	sub    $0x8,%esp
    1e3f:	68 00 02 00 00       	push   $0x200
    1e44:	68 dc 4e 00 00       	push   $0x4edc
    1e49:	e8 fd 21 00 00       	call   404b <open>
    1e4e:	83 c4 10             	add    $0x10,%esp
    1e51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    1e54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1e58:	79 17                	jns    1e71 <bigdir+0x5d>
    printf(1, "bigdir create failed\n");
    1e5a:	83 ec 08             	sub    $0x8,%esp
    1e5d:	68 df 4e 00 00       	push   $0x4edf
    1e62:	6a 01                	push   $0x1
    1e64:	e8 31 23 00 00       	call   419a <printf>
    1e69:	83 c4 10             	add    $0x10,%esp
    exit();
    1e6c:	e8 9a 21 00 00       	call   400b <exit>
  }
  close(fd);
    1e71:	83 ec 0c             	sub    $0xc,%esp
    1e74:	ff 75 f0             	pushl  -0x10(%ebp)
    1e77:	e8 b7 21 00 00       	call   4033 <close>
    1e7c:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 500; i++){
    1e7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1e86:	eb 63                	jmp    1eeb <bigdir+0xd7>
    name[0] = 'x';
    1e88:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e8f:	8d 50 3f             	lea    0x3f(%eax),%edx
    1e92:	85 c0                	test   %eax,%eax
    1e94:	0f 48 c2             	cmovs  %edx,%eax
    1e97:	c1 f8 06             	sar    $0x6,%eax
    1e9a:	83 c0 30             	add    $0x30,%eax
    1e9d:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ea3:	99                   	cltd   
    1ea4:	c1 ea 1a             	shr    $0x1a,%edx
    1ea7:	01 d0                	add    %edx,%eax
    1ea9:	83 e0 3f             	and    $0x3f,%eax
    1eac:	29 d0                	sub    %edx,%eax
    1eae:	83 c0 30             	add    $0x30,%eax
    1eb1:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1eb4:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(link("bd", name) != 0){
    1eb8:	83 ec 08             	sub    $0x8,%esp
    1ebb:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1ebe:	50                   	push   %eax
    1ebf:	68 dc 4e 00 00       	push   $0x4edc
    1ec4:	e8 a2 21 00 00       	call   406b <link>
    1ec9:	83 c4 10             	add    $0x10,%esp
    1ecc:	85 c0                	test   %eax,%eax
    1ece:	74 17                	je     1ee7 <bigdir+0xd3>
      printf(1, "bigdir link failed\n");
    1ed0:	83 ec 08             	sub    $0x8,%esp
    1ed3:	68 f5 4e 00 00       	push   $0x4ef5
    1ed8:	6a 01                	push   $0x1
    1eda:	e8 bb 22 00 00       	call   419a <printf>
    1edf:	83 c4 10             	add    $0x10,%esp
      exit();
    1ee2:	e8 24 21 00 00       	call   400b <exit>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
    1ee7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1eeb:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1ef2:	7e 94                	jle    1e88 <bigdir+0x74>
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
    1ef4:	83 ec 0c             	sub    $0xc,%esp
    1ef7:	68 dc 4e 00 00       	push   $0x4edc
    1efc:	e8 5a 21 00 00       	call   405b <unlink>
    1f01:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 500; i++){
    1f04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1f0b:	eb 5e                	jmp    1f6b <bigdir+0x157>
    name[0] = 'x';
    1f0d:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f14:	8d 50 3f             	lea    0x3f(%eax),%edx
    1f17:	85 c0                	test   %eax,%eax
    1f19:	0f 48 c2             	cmovs  %edx,%eax
    1f1c:	c1 f8 06             	sar    $0x6,%eax
    1f1f:	83 c0 30             	add    $0x30,%eax
    1f22:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f28:	99                   	cltd   
    1f29:	c1 ea 1a             	shr    $0x1a,%edx
    1f2c:	01 d0                	add    %edx,%eax
    1f2e:	83 e0 3f             	and    $0x3f,%eax
    1f31:	29 d0                	sub    %edx,%eax
    1f33:	83 c0 30             	add    $0x30,%eax
    1f36:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1f39:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(unlink(name) != 0){
    1f3d:	83 ec 0c             	sub    $0xc,%esp
    1f40:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1f43:	50                   	push   %eax
    1f44:	e8 12 21 00 00       	call   405b <unlink>
    1f49:	83 c4 10             	add    $0x10,%esp
    1f4c:	85 c0                	test   %eax,%eax
    1f4e:	74 17                	je     1f67 <bigdir+0x153>
      printf(1, "bigdir unlink failed");
    1f50:	83 ec 08             	sub    $0x8,%esp
    1f53:	68 09 4f 00 00       	push   $0x4f09
    1f58:	6a 01                	push   $0x1
    1f5a:	e8 3b 22 00 00       	call   419a <printf>
    1f5f:	83 c4 10             	add    $0x10,%esp
      exit();
    1f62:	e8 a4 20 00 00       	call   400b <exit>
      exit();
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    1f67:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1f6b:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1f72:	7e 99                	jle    1f0d <bigdir+0xf9>
      printf(1, "bigdir unlink failed");
      exit();
    }
  }

  printf(1, "bigdir ok\n");
    1f74:	83 ec 08             	sub    $0x8,%esp
    1f77:	68 1e 4f 00 00       	push   $0x4f1e
    1f7c:	6a 01                	push   $0x1
    1f7e:	e8 17 22 00 00       	call   419a <printf>
    1f83:	83 c4 10             	add    $0x10,%esp
}
    1f86:	90                   	nop
    1f87:	c9                   	leave  
    1f88:	c3                   	ret    

00001f89 <subdir>:

void
subdir(void)
{
    1f89:	55                   	push   %ebp
    1f8a:	89 e5                	mov    %esp,%ebp
    1f8c:	83 ec 18             	sub    $0x18,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1f8f:	83 ec 08             	sub    $0x8,%esp
    1f92:	68 29 4f 00 00       	push   $0x4f29
    1f97:	6a 01                	push   $0x1
    1f99:	e8 fc 21 00 00       	call   419a <printf>
    1f9e:	83 c4 10             	add    $0x10,%esp

  unlink("ff");
    1fa1:	83 ec 0c             	sub    $0xc,%esp
    1fa4:	68 36 4f 00 00       	push   $0x4f36
    1fa9:	e8 ad 20 00 00       	call   405b <unlink>
    1fae:	83 c4 10             	add    $0x10,%esp
  if(mkdir("dd") != 0){
    1fb1:	83 ec 0c             	sub    $0xc,%esp
    1fb4:	68 39 4f 00 00       	push   $0x4f39
    1fb9:	e8 b5 20 00 00       	call   4073 <mkdir>
    1fbe:	83 c4 10             	add    $0x10,%esp
    1fc1:	85 c0                	test   %eax,%eax
    1fc3:	74 17                	je     1fdc <subdir+0x53>
    printf(1, "subdir mkdir dd failed\n");
    1fc5:	83 ec 08             	sub    $0x8,%esp
    1fc8:	68 3c 4f 00 00       	push   $0x4f3c
    1fcd:	6a 01                	push   $0x1
    1fcf:	e8 c6 21 00 00       	call   419a <printf>
    1fd4:	83 c4 10             	add    $0x10,%esp
    exit();
    1fd7:	e8 2f 20 00 00       	call   400b <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1fdc:	83 ec 08             	sub    $0x8,%esp
    1fdf:	68 02 02 00 00       	push   $0x202
    1fe4:	68 54 4f 00 00       	push   $0x4f54
    1fe9:	e8 5d 20 00 00       	call   404b <open>
    1fee:	83 c4 10             	add    $0x10,%esp
    1ff1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1ff4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1ff8:	79 17                	jns    2011 <subdir+0x88>
    printf(1, "create dd/ff failed\n");
    1ffa:	83 ec 08             	sub    $0x8,%esp
    1ffd:	68 5a 4f 00 00       	push   $0x4f5a
    2002:	6a 01                	push   $0x1
    2004:	e8 91 21 00 00       	call   419a <printf>
    2009:	83 c4 10             	add    $0x10,%esp
    exit();
    200c:	e8 fa 1f 00 00       	call   400b <exit>
  }
  write(fd, "ff", 2);
    2011:	83 ec 04             	sub    $0x4,%esp
    2014:	6a 02                	push   $0x2
    2016:	68 36 4f 00 00       	push   $0x4f36
    201b:	ff 75 f4             	pushl  -0xc(%ebp)
    201e:	e8 08 20 00 00       	call   402b <write>
    2023:	83 c4 10             	add    $0x10,%esp
  close(fd);
    2026:	83 ec 0c             	sub    $0xc,%esp
    2029:	ff 75 f4             	pushl  -0xc(%ebp)
    202c:	e8 02 20 00 00       	call   4033 <close>
    2031:	83 c4 10             	add    $0x10,%esp

  if(unlink("dd") >= 0){
    2034:	83 ec 0c             	sub    $0xc,%esp
    2037:	68 39 4f 00 00       	push   $0x4f39
    203c:	e8 1a 20 00 00       	call   405b <unlink>
    2041:	83 c4 10             	add    $0x10,%esp
    2044:	85 c0                	test   %eax,%eax
    2046:	78 17                	js     205f <subdir+0xd6>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    2048:	83 ec 08             	sub    $0x8,%esp
    204b:	68 70 4f 00 00       	push   $0x4f70
    2050:	6a 01                	push   $0x1
    2052:	e8 43 21 00 00       	call   419a <printf>
    2057:	83 c4 10             	add    $0x10,%esp
    exit();
    205a:	e8 ac 1f 00 00       	call   400b <exit>
  }

  if(mkdir("/dd/dd") != 0){
    205f:	83 ec 0c             	sub    $0xc,%esp
    2062:	68 96 4f 00 00       	push   $0x4f96
    2067:	e8 07 20 00 00       	call   4073 <mkdir>
    206c:	83 c4 10             	add    $0x10,%esp
    206f:	85 c0                	test   %eax,%eax
    2071:	74 17                	je     208a <subdir+0x101>
    printf(1, "subdir mkdir dd/dd failed\n");
    2073:	83 ec 08             	sub    $0x8,%esp
    2076:	68 9d 4f 00 00       	push   $0x4f9d
    207b:	6a 01                	push   $0x1
    207d:	e8 18 21 00 00       	call   419a <printf>
    2082:	83 c4 10             	add    $0x10,%esp
    exit();
    2085:	e8 81 1f 00 00       	call   400b <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    208a:	83 ec 08             	sub    $0x8,%esp
    208d:	68 02 02 00 00       	push   $0x202
    2092:	68 b8 4f 00 00       	push   $0x4fb8
    2097:	e8 af 1f 00 00       	call   404b <open>
    209c:	83 c4 10             	add    $0x10,%esp
    209f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    20a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    20a6:	79 17                	jns    20bf <subdir+0x136>
    printf(1, "create dd/dd/ff failed\n");
    20a8:	83 ec 08             	sub    $0x8,%esp
    20ab:	68 c1 4f 00 00       	push   $0x4fc1
    20b0:	6a 01                	push   $0x1
    20b2:	e8 e3 20 00 00       	call   419a <printf>
    20b7:	83 c4 10             	add    $0x10,%esp
    exit();
    20ba:	e8 4c 1f 00 00       	call   400b <exit>
  }
  write(fd, "FF", 2);
    20bf:	83 ec 04             	sub    $0x4,%esp
    20c2:	6a 02                	push   $0x2
    20c4:	68 d9 4f 00 00       	push   $0x4fd9
    20c9:	ff 75 f4             	pushl  -0xc(%ebp)
    20cc:	e8 5a 1f 00 00       	call   402b <write>
    20d1:	83 c4 10             	add    $0x10,%esp
  close(fd);
    20d4:	83 ec 0c             	sub    $0xc,%esp
    20d7:	ff 75 f4             	pushl  -0xc(%ebp)
    20da:	e8 54 1f 00 00       	call   4033 <close>
    20df:	83 c4 10             	add    $0x10,%esp

  fd = open("dd/dd/../ff", 0);
    20e2:	83 ec 08             	sub    $0x8,%esp
    20e5:	6a 00                	push   $0x0
    20e7:	68 dc 4f 00 00       	push   $0x4fdc
    20ec:	e8 5a 1f 00 00       	call   404b <open>
    20f1:	83 c4 10             	add    $0x10,%esp
    20f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    20f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    20fb:	79 17                	jns    2114 <subdir+0x18b>
    printf(1, "open dd/dd/../ff failed\n");
    20fd:	83 ec 08             	sub    $0x8,%esp
    2100:	68 e8 4f 00 00       	push   $0x4fe8
    2105:	6a 01                	push   $0x1
    2107:	e8 8e 20 00 00       	call   419a <printf>
    210c:	83 c4 10             	add    $0x10,%esp
    exit();
    210f:	e8 f7 1e 00 00       	call   400b <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    2114:	83 ec 04             	sub    $0x4,%esp
    2117:	68 00 20 00 00       	push   $0x2000
    211c:	68 a0 8c 00 00       	push   $0x8ca0
    2121:	ff 75 f4             	pushl  -0xc(%ebp)
    2124:	e8 fa 1e 00 00       	call   4023 <read>
    2129:	83 c4 10             	add    $0x10,%esp
    212c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(cc != 2 || buf[0] != 'f'){
    212f:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
    2133:	75 0b                	jne    2140 <subdir+0x1b7>
    2135:	0f b6 05 a0 8c 00 00 	movzbl 0x8ca0,%eax
    213c:	3c 66                	cmp    $0x66,%al
    213e:	74 17                	je     2157 <subdir+0x1ce>
    printf(1, "dd/dd/../ff wrong content\n");
    2140:	83 ec 08             	sub    $0x8,%esp
    2143:	68 01 50 00 00       	push   $0x5001
    2148:	6a 01                	push   $0x1
    214a:	e8 4b 20 00 00       	call   419a <printf>
    214f:	83 c4 10             	add    $0x10,%esp
    exit();
    2152:	e8 b4 1e 00 00       	call   400b <exit>
  }
  close(fd);
    2157:	83 ec 0c             	sub    $0xc,%esp
    215a:	ff 75 f4             	pushl  -0xc(%ebp)
    215d:	e8 d1 1e 00 00       	call   4033 <close>
    2162:	83 c4 10             	add    $0x10,%esp

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2165:	83 ec 08             	sub    $0x8,%esp
    2168:	68 1c 50 00 00       	push   $0x501c
    216d:	68 b8 4f 00 00       	push   $0x4fb8
    2172:	e8 f4 1e 00 00       	call   406b <link>
    2177:	83 c4 10             	add    $0x10,%esp
    217a:	85 c0                	test   %eax,%eax
    217c:	74 17                	je     2195 <subdir+0x20c>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    217e:	83 ec 08             	sub    $0x8,%esp
    2181:	68 28 50 00 00       	push   $0x5028
    2186:	6a 01                	push   $0x1
    2188:	e8 0d 20 00 00       	call   419a <printf>
    218d:	83 c4 10             	add    $0x10,%esp
    exit();
    2190:	e8 76 1e 00 00       	call   400b <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    2195:	83 ec 0c             	sub    $0xc,%esp
    2198:	68 b8 4f 00 00       	push   $0x4fb8
    219d:	e8 b9 1e 00 00       	call   405b <unlink>
    21a2:	83 c4 10             	add    $0x10,%esp
    21a5:	85 c0                	test   %eax,%eax
    21a7:	74 17                	je     21c0 <subdir+0x237>
    printf(1, "unlink dd/dd/ff failed\n");
    21a9:	83 ec 08             	sub    $0x8,%esp
    21ac:	68 49 50 00 00       	push   $0x5049
    21b1:	6a 01                	push   $0x1
    21b3:	e8 e2 1f 00 00       	call   419a <printf>
    21b8:	83 c4 10             	add    $0x10,%esp
    exit();
    21bb:	e8 4b 1e 00 00       	call   400b <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    21c0:	83 ec 08             	sub    $0x8,%esp
    21c3:	6a 00                	push   $0x0
    21c5:	68 b8 4f 00 00       	push   $0x4fb8
    21ca:	e8 7c 1e 00 00       	call   404b <open>
    21cf:	83 c4 10             	add    $0x10,%esp
    21d2:	85 c0                	test   %eax,%eax
    21d4:	78 17                	js     21ed <subdir+0x264>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    21d6:	83 ec 08             	sub    $0x8,%esp
    21d9:	68 64 50 00 00       	push   $0x5064
    21de:	6a 01                	push   $0x1
    21e0:	e8 b5 1f 00 00       	call   419a <printf>
    21e5:	83 c4 10             	add    $0x10,%esp
    exit();
    21e8:	e8 1e 1e 00 00       	call   400b <exit>
  }

  if(chdir("dd") != 0){
    21ed:	83 ec 0c             	sub    $0xc,%esp
    21f0:	68 39 4f 00 00       	push   $0x4f39
    21f5:	e8 81 1e 00 00       	call   407b <chdir>
    21fa:	83 c4 10             	add    $0x10,%esp
    21fd:	85 c0                	test   %eax,%eax
    21ff:	74 17                	je     2218 <subdir+0x28f>
    printf(1, "chdir dd failed\n");
    2201:	83 ec 08             	sub    $0x8,%esp
    2204:	68 88 50 00 00       	push   $0x5088
    2209:	6a 01                	push   $0x1
    220b:	e8 8a 1f 00 00       	call   419a <printf>
    2210:	83 c4 10             	add    $0x10,%esp
    exit();
    2213:	e8 f3 1d 00 00       	call   400b <exit>
  }
  if(chdir("dd/../../dd") != 0){
    2218:	83 ec 0c             	sub    $0xc,%esp
    221b:	68 99 50 00 00       	push   $0x5099
    2220:	e8 56 1e 00 00       	call   407b <chdir>
    2225:	83 c4 10             	add    $0x10,%esp
    2228:	85 c0                	test   %eax,%eax
    222a:	74 17                	je     2243 <subdir+0x2ba>
    printf(1, "chdir dd/../../dd failed\n");
    222c:	83 ec 08             	sub    $0x8,%esp
    222f:	68 a5 50 00 00       	push   $0x50a5
    2234:	6a 01                	push   $0x1
    2236:	e8 5f 1f 00 00       	call   419a <printf>
    223b:	83 c4 10             	add    $0x10,%esp
    exit();
    223e:	e8 c8 1d 00 00       	call   400b <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    2243:	83 ec 0c             	sub    $0xc,%esp
    2246:	68 bf 50 00 00       	push   $0x50bf
    224b:	e8 2b 1e 00 00       	call   407b <chdir>
    2250:	83 c4 10             	add    $0x10,%esp
    2253:	85 c0                	test   %eax,%eax
    2255:	74 17                	je     226e <subdir+0x2e5>
    printf(1, "chdir dd/../../dd failed\n");
    2257:	83 ec 08             	sub    $0x8,%esp
    225a:	68 a5 50 00 00       	push   $0x50a5
    225f:	6a 01                	push   $0x1
    2261:	e8 34 1f 00 00       	call   419a <printf>
    2266:	83 c4 10             	add    $0x10,%esp
    exit();
    2269:	e8 9d 1d 00 00       	call   400b <exit>
  }
  if(chdir("./..") != 0){
    226e:	83 ec 0c             	sub    $0xc,%esp
    2271:	68 ce 50 00 00       	push   $0x50ce
    2276:	e8 00 1e 00 00       	call   407b <chdir>
    227b:	83 c4 10             	add    $0x10,%esp
    227e:	85 c0                	test   %eax,%eax
    2280:	74 17                	je     2299 <subdir+0x310>
    printf(1, "chdir ./.. failed\n");
    2282:	83 ec 08             	sub    $0x8,%esp
    2285:	68 d3 50 00 00       	push   $0x50d3
    228a:	6a 01                	push   $0x1
    228c:	e8 09 1f 00 00       	call   419a <printf>
    2291:	83 c4 10             	add    $0x10,%esp
    exit();
    2294:	e8 72 1d 00 00       	call   400b <exit>
  }

  fd = open("dd/dd/ffff", 0);
    2299:	83 ec 08             	sub    $0x8,%esp
    229c:	6a 00                	push   $0x0
    229e:	68 1c 50 00 00       	push   $0x501c
    22a3:	e8 a3 1d 00 00       	call   404b <open>
    22a8:	83 c4 10             	add    $0x10,%esp
    22ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    22ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    22b2:	79 17                	jns    22cb <subdir+0x342>
    printf(1, "open dd/dd/ffff failed\n");
    22b4:	83 ec 08             	sub    $0x8,%esp
    22b7:	68 e6 50 00 00       	push   $0x50e6
    22bc:	6a 01                	push   $0x1
    22be:	e8 d7 1e 00 00       	call   419a <printf>
    22c3:	83 c4 10             	add    $0x10,%esp
    exit();
    22c6:	e8 40 1d 00 00       	call   400b <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    22cb:	83 ec 04             	sub    $0x4,%esp
    22ce:	68 00 20 00 00       	push   $0x2000
    22d3:	68 a0 8c 00 00       	push   $0x8ca0
    22d8:	ff 75 f4             	pushl  -0xc(%ebp)
    22db:	e8 43 1d 00 00       	call   4023 <read>
    22e0:	83 c4 10             	add    $0x10,%esp
    22e3:	83 f8 02             	cmp    $0x2,%eax
    22e6:	74 17                	je     22ff <subdir+0x376>
    printf(1, "read dd/dd/ffff wrong len\n");
    22e8:	83 ec 08             	sub    $0x8,%esp
    22eb:	68 fe 50 00 00       	push   $0x50fe
    22f0:	6a 01                	push   $0x1
    22f2:	e8 a3 1e 00 00       	call   419a <printf>
    22f7:	83 c4 10             	add    $0x10,%esp
    exit();
    22fa:	e8 0c 1d 00 00       	call   400b <exit>
  }
  close(fd);
    22ff:	83 ec 0c             	sub    $0xc,%esp
    2302:	ff 75 f4             	pushl  -0xc(%ebp)
    2305:	e8 29 1d 00 00       	call   4033 <close>
    230a:	83 c4 10             	add    $0x10,%esp

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    230d:	83 ec 08             	sub    $0x8,%esp
    2310:	6a 00                	push   $0x0
    2312:	68 b8 4f 00 00       	push   $0x4fb8
    2317:	e8 2f 1d 00 00       	call   404b <open>
    231c:	83 c4 10             	add    $0x10,%esp
    231f:	85 c0                	test   %eax,%eax
    2321:	78 17                	js     233a <subdir+0x3b1>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    2323:	83 ec 08             	sub    $0x8,%esp
    2326:	68 1c 51 00 00       	push   $0x511c
    232b:	6a 01                	push   $0x1
    232d:	e8 68 1e 00 00       	call   419a <printf>
    2332:	83 c4 10             	add    $0x10,%esp
    exit();
    2335:	e8 d1 1c 00 00       	call   400b <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    233a:	83 ec 08             	sub    $0x8,%esp
    233d:	68 02 02 00 00       	push   $0x202
    2342:	68 41 51 00 00       	push   $0x5141
    2347:	e8 ff 1c 00 00       	call   404b <open>
    234c:	83 c4 10             	add    $0x10,%esp
    234f:	85 c0                	test   %eax,%eax
    2351:	78 17                	js     236a <subdir+0x3e1>
    printf(1, "create dd/ff/ff succeeded!\n");
    2353:	83 ec 08             	sub    $0x8,%esp
    2356:	68 4a 51 00 00       	push   $0x514a
    235b:	6a 01                	push   $0x1
    235d:	e8 38 1e 00 00       	call   419a <printf>
    2362:	83 c4 10             	add    $0x10,%esp
    exit();
    2365:	e8 a1 1c 00 00       	call   400b <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    236a:	83 ec 08             	sub    $0x8,%esp
    236d:	68 02 02 00 00       	push   $0x202
    2372:	68 66 51 00 00       	push   $0x5166
    2377:	e8 cf 1c 00 00       	call   404b <open>
    237c:	83 c4 10             	add    $0x10,%esp
    237f:	85 c0                	test   %eax,%eax
    2381:	78 17                	js     239a <subdir+0x411>
    printf(1, "create dd/xx/ff succeeded!\n");
    2383:	83 ec 08             	sub    $0x8,%esp
    2386:	68 6f 51 00 00       	push   $0x516f
    238b:	6a 01                	push   $0x1
    238d:	e8 08 1e 00 00       	call   419a <printf>
    2392:	83 c4 10             	add    $0x10,%esp
    exit();
    2395:	e8 71 1c 00 00       	call   400b <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    239a:	83 ec 08             	sub    $0x8,%esp
    239d:	68 00 02 00 00       	push   $0x200
    23a2:	68 39 4f 00 00       	push   $0x4f39
    23a7:	e8 9f 1c 00 00       	call   404b <open>
    23ac:	83 c4 10             	add    $0x10,%esp
    23af:	85 c0                	test   %eax,%eax
    23b1:	78 17                	js     23ca <subdir+0x441>
    printf(1, "create dd succeeded!\n");
    23b3:	83 ec 08             	sub    $0x8,%esp
    23b6:	68 8b 51 00 00       	push   $0x518b
    23bb:	6a 01                	push   $0x1
    23bd:	e8 d8 1d 00 00       	call   419a <printf>
    23c2:	83 c4 10             	add    $0x10,%esp
    exit();
    23c5:	e8 41 1c 00 00       	call   400b <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    23ca:	83 ec 08             	sub    $0x8,%esp
    23cd:	6a 02                	push   $0x2
    23cf:	68 39 4f 00 00       	push   $0x4f39
    23d4:	e8 72 1c 00 00       	call   404b <open>
    23d9:	83 c4 10             	add    $0x10,%esp
    23dc:	85 c0                	test   %eax,%eax
    23de:	78 17                	js     23f7 <subdir+0x46e>
    printf(1, "open dd rdwr succeeded!\n");
    23e0:	83 ec 08             	sub    $0x8,%esp
    23e3:	68 a1 51 00 00       	push   $0x51a1
    23e8:	6a 01                	push   $0x1
    23ea:	e8 ab 1d 00 00       	call   419a <printf>
    23ef:	83 c4 10             	add    $0x10,%esp
    exit();
    23f2:	e8 14 1c 00 00       	call   400b <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    23f7:	83 ec 08             	sub    $0x8,%esp
    23fa:	6a 01                	push   $0x1
    23fc:	68 39 4f 00 00       	push   $0x4f39
    2401:	e8 45 1c 00 00       	call   404b <open>
    2406:	83 c4 10             	add    $0x10,%esp
    2409:	85 c0                	test   %eax,%eax
    240b:	78 17                	js     2424 <subdir+0x49b>
    printf(1, "open dd wronly succeeded!\n");
    240d:	83 ec 08             	sub    $0x8,%esp
    2410:	68 ba 51 00 00       	push   $0x51ba
    2415:	6a 01                	push   $0x1
    2417:	e8 7e 1d 00 00       	call   419a <printf>
    241c:	83 c4 10             	add    $0x10,%esp
    exit();
    241f:	e8 e7 1b 00 00       	call   400b <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2424:	83 ec 08             	sub    $0x8,%esp
    2427:	68 d5 51 00 00       	push   $0x51d5
    242c:	68 41 51 00 00       	push   $0x5141
    2431:	e8 35 1c 00 00       	call   406b <link>
    2436:	83 c4 10             	add    $0x10,%esp
    2439:	85 c0                	test   %eax,%eax
    243b:	75 17                	jne    2454 <subdir+0x4cb>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    243d:	83 ec 08             	sub    $0x8,%esp
    2440:	68 e0 51 00 00       	push   $0x51e0
    2445:	6a 01                	push   $0x1
    2447:	e8 4e 1d 00 00       	call   419a <printf>
    244c:	83 c4 10             	add    $0x10,%esp
    exit();
    244f:	e8 b7 1b 00 00       	call   400b <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2454:	83 ec 08             	sub    $0x8,%esp
    2457:	68 d5 51 00 00       	push   $0x51d5
    245c:	68 66 51 00 00       	push   $0x5166
    2461:	e8 05 1c 00 00       	call   406b <link>
    2466:	83 c4 10             	add    $0x10,%esp
    2469:	85 c0                	test   %eax,%eax
    246b:	75 17                	jne    2484 <subdir+0x4fb>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    246d:	83 ec 08             	sub    $0x8,%esp
    2470:	68 04 52 00 00       	push   $0x5204
    2475:	6a 01                	push   $0x1
    2477:	e8 1e 1d 00 00       	call   419a <printf>
    247c:	83 c4 10             	add    $0x10,%esp
    exit();
    247f:	e8 87 1b 00 00       	call   400b <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2484:	83 ec 08             	sub    $0x8,%esp
    2487:	68 1c 50 00 00       	push   $0x501c
    248c:	68 54 4f 00 00       	push   $0x4f54
    2491:	e8 d5 1b 00 00       	call   406b <link>
    2496:	83 c4 10             	add    $0x10,%esp
    2499:	85 c0                	test   %eax,%eax
    249b:	75 17                	jne    24b4 <subdir+0x52b>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    249d:	83 ec 08             	sub    $0x8,%esp
    24a0:	68 28 52 00 00       	push   $0x5228
    24a5:	6a 01                	push   $0x1
    24a7:	e8 ee 1c 00 00       	call   419a <printf>
    24ac:	83 c4 10             	add    $0x10,%esp
    exit();
    24af:	e8 57 1b 00 00       	call   400b <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    24b4:	83 ec 0c             	sub    $0xc,%esp
    24b7:	68 41 51 00 00       	push   $0x5141
    24bc:	e8 b2 1b 00 00       	call   4073 <mkdir>
    24c1:	83 c4 10             	add    $0x10,%esp
    24c4:	85 c0                	test   %eax,%eax
    24c6:	75 17                	jne    24df <subdir+0x556>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    24c8:	83 ec 08             	sub    $0x8,%esp
    24cb:	68 4a 52 00 00       	push   $0x524a
    24d0:	6a 01                	push   $0x1
    24d2:	e8 c3 1c 00 00       	call   419a <printf>
    24d7:	83 c4 10             	add    $0x10,%esp
    exit();
    24da:	e8 2c 1b 00 00       	call   400b <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    24df:	83 ec 0c             	sub    $0xc,%esp
    24e2:	68 66 51 00 00       	push   $0x5166
    24e7:	e8 87 1b 00 00       	call   4073 <mkdir>
    24ec:	83 c4 10             	add    $0x10,%esp
    24ef:	85 c0                	test   %eax,%eax
    24f1:	75 17                	jne    250a <subdir+0x581>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    24f3:	83 ec 08             	sub    $0x8,%esp
    24f6:	68 65 52 00 00       	push   $0x5265
    24fb:	6a 01                	push   $0x1
    24fd:	e8 98 1c 00 00       	call   419a <printf>
    2502:	83 c4 10             	add    $0x10,%esp
    exit();
    2505:	e8 01 1b 00 00       	call   400b <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    250a:	83 ec 0c             	sub    $0xc,%esp
    250d:	68 1c 50 00 00       	push   $0x501c
    2512:	e8 5c 1b 00 00       	call   4073 <mkdir>
    2517:	83 c4 10             	add    $0x10,%esp
    251a:	85 c0                	test   %eax,%eax
    251c:	75 17                	jne    2535 <subdir+0x5ac>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    251e:	83 ec 08             	sub    $0x8,%esp
    2521:	68 80 52 00 00       	push   $0x5280
    2526:	6a 01                	push   $0x1
    2528:	e8 6d 1c 00 00       	call   419a <printf>
    252d:	83 c4 10             	add    $0x10,%esp
    exit();
    2530:	e8 d6 1a 00 00       	call   400b <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    2535:	83 ec 0c             	sub    $0xc,%esp
    2538:	68 66 51 00 00       	push   $0x5166
    253d:	e8 19 1b 00 00       	call   405b <unlink>
    2542:	83 c4 10             	add    $0x10,%esp
    2545:	85 c0                	test   %eax,%eax
    2547:	75 17                	jne    2560 <subdir+0x5d7>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    2549:	83 ec 08             	sub    $0x8,%esp
    254c:	68 9d 52 00 00       	push   $0x529d
    2551:	6a 01                	push   $0x1
    2553:	e8 42 1c 00 00       	call   419a <printf>
    2558:	83 c4 10             	add    $0x10,%esp
    exit();
    255b:	e8 ab 1a 00 00       	call   400b <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    2560:	83 ec 0c             	sub    $0xc,%esp
    2563:	68 41 51 00 00       	push   $0x5141
    2568:	e8 ee 1a 00 00       	call   405b <unlink>
    256d:	83 c4 10             	add    $0x10,%esp
    2570:	85 c0                	test   %eax,%eax
    2572:	75 17                	jne    258b <subdir+0x602>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    2574:	83 ec 08             	sub    $0x8,%esp
    2577:	68 b9 52 00 00       	push   $0x52b9
    257c:	6a 01                	push   $0x1
    257e:	e8 17 1c 00 00       	call   419a <printf>
    2583:	83 c4 10             	add    $0x10,%esp
    exit();
    2586:	e8 80 1a 00 00       	call   400b <exit>
  }
  if(chdir("dd/ff") == 0){
    258b:	83 ec 0c             	sub    $0xc,%esp
    258e:	68 54 4f 00 00       	push   $0x4f54
    2593:	e8 e3 1a 00 00       	call   407b <chdir>
    2598:	83 c4 10             	add    $0x10,%esp
    259b:	85 c0                	test   %eax,%eax
    259d:	75 17                	jne    25b6 <subdir+0x62d>
    printf(1, "chdir dd/ff succeeded!\n");
    259f:	83 ec 08             	sub    $0x8,%esp
    25a2:	68 d5 52 00 00       	push   $0x52d5
    25a7:	6a 01                	push   $0x1
    25a9:	e8 ec 1b 00 00       	call   419a <printf>
    25ae:	83 c4 10             	add    $0x10,%esp
    exit();
    25b1:	e8 55 1a 00 00       	call   400b <exit>
  }
  if(chdir("dd/xx") == 0){
    25b6:	83 ec 0c             	sub    $0xc,%esp
    25b9:	68 ed 52 00 00       	push   $0x52ed
    25be:	e8 b8 1a 00 00       	call   407b <chdir>
    25c3:	83 c4 10             	add    $0x10,%esp
    25c6:	85 c0                	test   %eax,%eax
    25c8:	75 17                	jne    25e1 <subdir+0x658>
    printf(1, "chdir dd/xx succeeded!\n");
    25ca:	83 ec 08             	sub    $0x8,%esp
    25cd:	68 f3 52 00 00       	push   $0x52f3
    25d2:	6a 01                	push   $0x1
    25d4:	e8 c1 1b 00 00       	call   419a <printf>
    25d9:	83 c4 10             	add    $0x10,%esp
    exit();
    25dc:	e8 2a 1a 00 00       	call   400b <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    25e1:	83 ec 0c             	sub    $0xc,%esp
    25e4:	68 1c 50 00 00       	push   $0x501c
    25e9:	e8 6d 1a 00 00       	call   405b <unlink>
    25ee:	83 c4 10             	add    $0x10,%esp
    25f1:	85 c0                	test   %eax,%eax
    25f3:	74 17                	je     260c <subdir+0x683>
    printf(1, "unlink dd/dd/ff failed\n");
    25f5:	83 ec 08             	sub    $0x8,%esp
    25f8:	68 49 50 00 00       	push   $0x5049
    25fd:	6a 01                	push   $0x1
    25ff:	e8 96 1b 00 00       	call   419a <printf>
    2604:	83 c4 10             	add    $0x10,%esp
    exit();
    2607:	e8 ff 19 00 00       	call   400b <exit>
  }
  if(unlink("dd/ff") != 0){
    260c:	83 ec 0c             	sub    $0xc,%esp
    260f:	68 54 4f 00 00       	push   $0x4f54
    2614:	e8 42 1a 00 00       	call   405b <unlink>
    2619:	83 c4 10             	add    $0x10,%esp
    261c:	85 c0                	test   %eax,%eax
    261e:	74 17                	je     2637 <subdir+0x6ae>
    printf(1, "unlink dd/ff failed\n");
    2620:	83 ec 08             	sub    $0x8,%esp
    2623:	68 0b 53 00 00       	push   $0x530b
    2628:	6a 01                	push   $0x1
    262a:	e8 6b 1b 00 00       	call   419a <printf>
    262f:	83 c4 10             	add    $0x10,%esp
    exit();
    2632:	e8 d4 19 00 00       	call   400b <exit>
  }
  if(unlink("dd") == 0){
    2637:	83 ec 0c             	sub    $0xc,%esp
    263a:	68 39 4f 00 00       	push   $0x4f39
    263f:	e8 17 1a 00 00       	call   405b <unlink>
    2644:	83 c4 10             	add    $0x10,%esp
    2647:	85 c0                	test   %eax,%eax
    2649:	75 17                	jne    2662 <subdir+0x6d9>
    printf(1, "unlink non-empty dd succeeded!\n");
    264b:	83 ec 08             	sub    $0x8,%esp
    264e:	68 20 53 00 00       	push   $0x5320
    2653:	6a 01                	push   $0x1
    2655:	e8 40 1b 00 00       	call   419a <printf>
    265a:	83 c4 10             	add    $0x10,%esp
    exit();
    265d:	e8 a9 19 00 00       	call   400b <exit>
  }
  if(unlink("dd/dd") < 0){
    2662:	83 ec 0c             	sub    $0xc,%esp
    2665:	68 40 53 00 00       	push   $0x5340
    266a:	e8 ec 19 00 00       	call   405b <unlink>
    266f:	83 c4 10             	add    $0x10,%esp
    2672:	85 c0                	test   %eax,%eax
    2674:	79 17                	jns    268d <subdir+0x704>
    printf(1, "unlink dd/dd failed\n");
    2676:	83 ec 08             	sub    $0x8,%esp
    2679:	68 46 53 00 00       	push   $0x5346
    267e:	6a 01                	push   $0x1
    2680:	e8 15 1b 00 00       	call   419a <printf>
    2685:	83 c4 10             	add    $0x10,%esp
    exit();
    2688:	e8 7e 19 00 00       	call   400b <exit>
  }
  if(unlink("dd") < 0){
    268d:	83 ec 0c             	sub    $0xc,%esp
    2690:	68 39 4f 00 00       	push   $0x4f39
    2695:	e8 c1 19 00 00       	call   405b <unlink>
    269a:	83 c4 10             	add    $0x10,%esp
    269d:	85 c0                	test   %eax,%eax
    269f:	79 17                	jns    26b8 <subdir+0x72f>
    printf(1, "unlink dd failed\n");
    26a1:	83 ec 08             	sub    $0x8,%esp
    26a4:	68 5b 53 00 00       	push   $0x535b
    26a9:	6a 01                	push   $0x1
    26ab:	e8 ea 1a 00 00       	call   419a <printf>
    26b0:	83 c4 10             	add    $0x10,%esp
    exit();
    26b3:	e8 53 19 00 00       	call   400b <exit>
  }

  printf(1, "subdir ok\n");
    26b8:	83 ec 08             	sub    $0x8,%esp
    26bb:	68 6d 53 00 00       	push   $0x536d
    26c0:	6a 01                	push   $0x1
    26c2:	e8 d3 1a 00 00       	call   419a <printf>
    26c7:	83 c4 10             	add    $0x10,%esp
}
    26ca:	90                   	nop
    26cb:	c9                   	leave  
    26cc:	c3                   	ret    

000026cd <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    26cd:	55                   	push   %ebp
    26ce:	89 e5                	mov    %esp,%ebp
    26d0:	83 ec 18             	sub    $0x18,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    26d3:	83 ec 08             	sub    $0x8,%esp
    26d6:	68 78 53 00 00       	push   $0x5378
    26db:	6a 01                	push   $0x1
    26dd:	e8 b8 1a 00 00       	call   419a <printf>
    26e2:	83 c4 10             	add    $0x10,%esp

  unlink("bigwrite");
    26e5:	83 ec 0c             	sub    $0xc,%esp
    26e8:	68 87 53 00 00       	push   $0x5387
    26ed:	e8 69 19 00 00       	call   405b <unlink>
    26f2:	83 c4 10             	add    $0x10,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    26f5:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%ebp)
    26fc:	e9 a8 00 00 00       	jmp    27a9 <bigwrite+0xdc>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    2701:	83 ec 08             	sub    $0x8,%esp
    2704:	68 02 02 00 00       	push   $0x202
    2709:	68 87 53 00 00       	push   $0x5387
    270e:	e8 38 19 00 00       	call   404b <open>
    2713:	83 c4 10             	add    $0x10,%esp
    2716:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    2719:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    271d:	79 17                	jns    2736 <bigwrite+0x69>
      printf(1, "cannot create bigwrite\n");
    271f:	83 ec 08             	sub    $0x8,%esp
    2722:	68 90 53 00 00       	push   $0x5390
    2727:	6a 01                	push   $0x1
    2729:	e8 6c 1a 00 00       	call   419a <printf>
    272e:	83 c4 10             	add    $0x10,%esp
      exit();
    2731:	e8 d5 18 00 00       	call   400b <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    2736:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    273d:	eb 3f                	jmp    277e <bigwrite+0xb1>
      int cc = write(fd, buf, sz);
    273f:	83 ec 04             	sub    $0x4,%esp
    2742:	ff 75 f4             	pushl  -0xc(%ebp)
    2745:	68 a0 8c 00 00       	push   $0x8ca0
    274a:	ff 75 ec             	pushl  -0x14(%ebp)
    274d:	e8 d9 18 00 00       	call   402b <write>
    2752:	83 c4 10             	add    $0x10,%esp
    2755:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(cc != sz){
    2758:	8b 45 e8             	mov    -0x18(%ebp),%eax
    275b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    275e:	74 1a                	je     277a <bigwrite+0xad>
        printf(1, "write(%d) ret %d\n", sz, cc);
    2760:	ff 75 e8             	pushl  -0x18(%ebp)
    2763:	ff 75 f4             	pushl  -0xc(%ebp)
    2766:	68 a8 53 00 00       	push   $0x53a8
    276b:	6a 01                	push   $0x1
    276d:	e8 28 1a 00 00       	call   419a <printf>
    2772:	83 c4 10             	add    $0x10,%esp
        exit();
    2775:	e8 91 18 00 00       	call   400b <exit>
    if(fd < 0){
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
    277a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    277e:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    2782:	7e bb                	jle    273f <bigwrite+0x72>
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
        exit();
      }
    }
    close(fd);
    2784:	83 ec 0c             	sub    $0xc,%esp
    2787:	ff 75 ec             	pushl  -0x14(%ebp)
    278a:	e8 a4 18 00 00       	call   4033 <close>
    278f:	83 c4 10             	add    $0x10,%esp
    unlink("bigwrite");
    2792:	83 ec 0c             	sub    $0xc,%esp
    2795:	68 87 53 00 00       	push   $0x5387
    279a:	e8 bc 18 00 00       	call   405b <unlink>
    279f:	83 c4 10             	add    $0x10,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
    27a2:	81 45 f4 d7 01 00 00 	addl   $0x1d7,-0xc(%ebp)
    27a9:	81 7d f4 ff 17 00 00 	cmpl   $0x17ff,-0xc(%ebp)
    27b0:	0f 8e 4b ff ff ff    	jle    2701 <bigwrite+0x34>
    }
    close(fd);
    unlink("bigwrite");
  }

  printf(1, "bigwrite ok\n");
    27b6:	83 ec 08             	sub    $0x8,%esp
    27b9:	68 ba 53 00 00       	push   $0x53ba
    27be:	6a 01                	push   $0x1
    27c0:	e8 d5 19 00 00       	call   419a <printf>
    27c5:	83 c4 10             	add    $0x10,%esp
}
    27c8:	90                   	nop
    27c9:	c9                   	leave  
    27ca:	c3                   	ret    

000027cb <bigfile>:

void
bigfile(void)
{
    27cb:	55                   	push   %ebp
    27cc:	89 e5                	mov    %esp,%ebp
    27ce:	83 ec 18             	sub    $0x18,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    27d1:	83 ec 08             	sub    $0x8,%esp
    27d4:	68 c7 53 00 00       	push   $0x53c7
    27d9:	6a 01                	push   $0x1
    27db:	e8 ba 19 00 00       	call   419a <printf>
    27e0:	83 c4 10             	add    $0x10,%esp

  unlink("bigfile");
    27e3:	83 ec 0c             	sub    $0xc,%esp
    27e6:	68 d5 53 00 00       	push   $0x53d5
    27eb:	e8 6b 18 00 00       	call   405b <unlink>
    27f0:	83 c4 10             	add    $0x10,%esp
  fd = open("bigfile", O_CREATE | O_RDWR);
    27f3:	83 ec 08             	sub    $0x8,%esp
    27f6:	68 02 02 00 00       	push   $0x202
    27fb:	68 d5 53 00 00       	push   $0x53d5
    2800:	e8 46 18 00 00       	call   404b <open>
    2805:	83 c4 10             	add    $0x10,%esp
    2808:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    280b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    280f:	79 17                	jns    2828 <bigfile+0x5d>
    printf(1, "cannot create bigfile");
    2811:	83 ec 08             	sub    $0x8,%esp
    2814:	68 dd 53 00 00       	push   $0x53dd
    2819:	6a 01                	push   $0x1
    281b:	e8 7a 19 00 00       	call   419a <printf>
    2820:	83 c4 10             	add    $0x10,%esp
    exit();
    2823:	e8 e3 17 00 00       	call   400b <exit>
  }
  for(i = 0; i < 20; i++){
    2828:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    282f:	eb 52                	jmp    2883 <bigfile+0xb8>
    memset(buf, i, 600);
    2831:	83 ec 04             	sub    $0x4,%esp
    2834:	68 58 02 00 00       	push   $0x258
    2839:	ff 75 f4             	pushl  -0xc(%ebp)
    283c:	68 a0 8c 00 00       	push   $0x8ca0
    2841:	e8 2a 16 00 00       	call   3e70 <memset>
    2846:	83 c4 10             	add    $0x10,%esp
    if(write(fd, buf, 600) != 600){
    2849:	83 ec 04             	sub    $0x4,%esp
    284c:	68 58 02 00 00       	push   $0x258
    2851:	68 a0 8c 00 00       	push   $0x8ca0
    2856:	ff 75 ec             	pushl  -0x14(%ebp)
    2859:	e8 cd 17 00 00       	call   402b <write>
    285e:	83 c4 10             	add    $0x10,%esp
    2861:	3d 58 02 00 00       	cmp    $0x258,%eax
    2866:	74 17                	je     287f <bigfile+0xb4>
      printf(1, "write bigfile failed\n");
    2868:	83 ec 08             	sub    $0x8,%esp
    286b:	68 f3 53 00 00       	push   $0x53f3
    2870:	6a 01                	push   $0x1
    2872:	e8 23 19 00 00       	call   419a <printf>
    2877:	83 c4 10             	add    $0x10,%esp
      exit();
    287a:	e8 8c 17 00 00       	call   400b <exit>
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    287f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2883:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    2887:	7e a8                	jle    2831 <bigfile+0x66>
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
    2889:	83 ec 0c             	sub    $0xc,%esp
    288c:	ff 75 ec             	pushl  -0x14(%ebp)
    288f:	e8 9f 17 00 00       	call   4033 <close>
    2894:	83 c4 10             	add    $0x10,%esp

  fd = open("bigfile", 0);
    2897:	83 ec 08             	sub    $0x8,%esp
    289a:	6a 00                	push   $0x0
    289c:	68 d5 53 00 00       	push   $0x53d5
    28a1:	e8 a5 17 00 00       	call   404b <open>
    28a6:	83 c4 10             	add    $0x10,%esp
    28a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    28ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    28b0:	79 17                	jns    28c9 <bigfile+0xfe>
    printf(1, "cannot open bigfile\n");
    28b2:	83 ec 08             	sub    $0x8,%esp
    28b5:	68 09 54 00 00       	push   $0x5409
    28ba:	6a 01                	push   $0x1
    28bc:	e8 d9 18 00 00       	call   419a <printf>
    28c1:	83 c4 10             	add    $0x10,%esp
    exit();
    28c4:	e8 42 17 00 00       	call   400b <exit>
  }
  total = 0;
    28c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i = 0; ; i++){
    28d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    cc = read(fd, buf, 300);
    28d7:	83 ec 04             	sub    $0x4,%esp
    28da:	68 2c 01 00 00       	push   $0x12c
    28df:	68 a0 8c 00 00       	push   $0x8ca0
    28e4:	ff 75 ec             	pushl  -0x14(%ebp)
    28e7:	e8 37 17 00 00       	call   4023 <read>
    28ec:	83 c4 10             	add    $0x10,%esp
    28ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(cc < 0){
    28f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    28f6:	79 17                	jns    290f <bigfile+0x144>
      printf(1, "read bigfile failed\n");
    28f8:	83 ec 08             	sub    $0x8,%esp
    28fb:	68 1e 54 00 00       	push   $0x541e
    2900:	6a 01                	push   $0x1
    2902:	e8 93 18 00 00       	call   419a <printf>
    2907:	83 c4 10             	add    $0x10,%esp
      exit();
    290a:	e8 fc 16 00 00       	call   400b <exit>
    }
    if(cc == 0)
    290f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2913:	74 7a                	je     298f <bigfile+0x1c4>
      break;
    if(cc != 300){
    2915:	81 7d e8 2c 01 00 00 	cmpl   $0x12c,-0x18(%ebp)
    291c:	74 17                	je     2935 <bigfile+0x16a>
      printf(1, "short read bigfile\n");
    291e:	83 ec 08             	sub    $0x8,%esp
    2921:	68 33 54 00 00       	push   $0x5433
    2926:	6a 01                	push   $0x1
    2928:	e8 6d 18 00 00       	call   419a <printf>
    292d:	83 c4 10             	add    $0x10,%esp
      exit();
    2930:	e8 d6 16 00 00       	call   400b <exit>
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    2935:	0f b6 05 a0 8c 00 00 	movzbl 0x8ca0,%eax
    293c:	0f be d0             	movsbl %al,%edx
    293f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2942:	89 c1                	mov    %eax,%ecx
    2944:	c1 e9 1f             	shr    $0x1f,%ecx
    2947:	01 c8                	add    %ecx,%eax
    2949:	d1 f8                	sar    %eax
    294b:	39 c2                	cmp    %eax,%edx
    294d:	75 1a                	jne    2969 <bigfile+0x19e>
    294f:	0f b6 05 cb 8d 00 00 	movzbl 0x8dcb,%eax
    2956:	0f be d0             	movsbl %al,%edx
    2959:	8b 45 f4             	mov    -0xc(%ebp),%eax
    295c:	89 c1                	mov    %eax,%ecx
    295e:	c1 e9 1f             	shr    $0x1f,%ecx
    2961:	01 c8                	add    %ecx,%eax
    2963:	d1 f8                	sar    %eax
    2965:	39 c2                	cmp    %eax,%edx
    2967:	74 17                	je     2980 <bigfile+0x1b5>
      printf(1, "read bigfile wrong data\n");
    2969:	83 ec 08             	sub    $0x8,%esp
    296c:	68 47 54 00 00       	push   $0x5447
    2971:	6a 01                	push   $0x1
    2973:	e8 22 18 00 00       	call   419a <printf>
    2978:	83 c4 10             	add    $0x10,%esp
      exit();
    297b:	e8 8b 16 00 00       	call   400b <exit>
    }
    total += cc;
    2980:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2983:	01 45 f0             	add    %eax,-0x10(%ebp)
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
  for(i = 0; ; i++){
    2986:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(buf[0] != i/2 || buf[299] != i/2){
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
    298a:	e9 48 ff ff ff       	jmp    28d7 <bigfile+0x10c>
    if(cc < 0){
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
      break;
    298f:	90                   	nop
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
  close(fd);
    2990:	83 ec 0c             	sub    $0xc,%esp
    2993:	ff 75 ec             	pushl  -0x14(%ebp)
    2996:	e8 98 16 00 00       	call   4033 <close>
    299b:	83 c4 10             	add    $0x10,%esp
  if(total != 20*600){
    299e:	81 7d f0 e0 2e 00 00 	cmpl   $0x2ee0,-0x10(%ebp)
    29a5:	74 17                	je     29be <bigfile+0x1f3>
    printf(1, "read bigfile wrong total\n");
    29a7:	83 ec 08             	sub    $0x8,%esp
    29aa:	68 60 54 00 00       	push   $0x5460
    29af:	6a 01                	push   $0x1
    29b1:	e8 e4 17 00 00       	call   419a <printf>
    29b6:	83 c4 10             	add    $0x10,%esp
    exit();
    29b9:	e8 4d 16 00 00       	call   400b <exit>
  }
  unlink("bigfile");
    29be:	83 ec 0c             	sub    $0xc,%esp
    29c1:	68 d5 53 00 00       	push   $0x53d5
    29c6:	e8 90 16 00 00       	call   405b <unlink>
    29cb:	83 c4 10             	add    $0x10,%esp

  printf(1, "bigfile test ok\n");
    29ce:	83 ec 08             	sub    $0x8,%esp
    29d1:	68 7a 54 00 00       	push   $0x547a
    29d6:	6a 01                	push   $0x1
    29d8:	e8 bd 17 00 00       	call   419a <printf>
    29dd:	83 c4 10             	add    $0x10,%esp
}
    29e0:	90                   	nop
    29e1:	c9                   	leave  
    29e2:	c3                   	ret    

000029e3 <fourteen>:

void
fourteen(void)
{
    29e3:	55                   	push   %ebp
    29e4:	89 e5                	mov    %esp,%ebp
    29e6:	83 ec 18             	sub    $0x18,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    29e9:	83 ec 08             	sub    $0x8,%esp
    29ec:	68 8b 54 00 00       	push   $0x548b
    29f1:	6a 01                	push   $0x1
    29f3:	e8 a2 17 00 00       	call   419a <printf>
    29f8:	83 c4 10             	add    $0x10,%esp

  if(mkdir("12345678901234") != 0){
    29fb:	83 ec 0c             	sub    $0xc,%esp
    29fe:	68 9a 54 00 00       	push   $0x549a
    2a03:	e8 6b 16 00 00       	call   4073 <mkdir>
    2a08:	83 c4 10             	add    $0x10,%esp
    2a0b:	85 c0                	test   %eax,%eax
    2a0d:	74 17                	je     2a26 <fourteen+0x43>
    printf(1, "mkdir 12345678901234 failed\n");
    2a0f:	83 ec 08             	sub    $0x8,%esp
    2a12:	68 a9 54 00 00       	push   $0x54a9
    2a17:	6a 01                	push   $0x1
    2a19:	e8 7c 17 00 00       	call   419a <printf>
    2a1e:	83 c4 10             	add    $0x10,%esp
    exit();
    2a21:	e8 e5 15 00 00       	call   400b <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    2a26:	83 ec 0c             	sub    $0xc,%esp
    2a29:	68 c8 54 00 00       	push   $0x54c8
    2a2e:	e8 40 16 00 00       	call   4073 <mkdir>
    2a33:	83 c4 10             	add    $0x10,%esp
    2a36:	85 c0                	test   %eax,%eax
    2a38:	74 17                	je     2a51 <fourteen+0x6e>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    2a3a:	83 ec 08             	sub    $0x8,%esp
    2a3d:	68 e8 54 00 00       	push   $0x54e8
    2a42:	6a 01                	push   $0x1
    2a44:	e8 51 17 00 00       	call   419a <printf>
    2a49:	83 c4 10             	add    $0x10,%esp
    exit();
    2a4c:	e8 ba 15 00 00       	call   400b <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2a51:	83 ec 08             	sub    $0x8,%esp
    2a54:	68 00 02 00 00       	push   $0x200
    2a59:	68 18 55 00 00       	push   $0x5518
    2a5e:	e8 e8 15 00 00       	call   404b <open>
    2a63:	83 c4 10             	add    $0x10,%esp
    2a66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2a69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2a6d:	79 17                	jns    2a86 <fourteen+0xa3>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    2a6f:	83 ec 08             	sub    $0x8,%esp
    2a72:	68 48 55 00 00       	push   $0x5548
    2a77:	6a 01                	push   $0x1
    2a79:	e8 1c 17 00 00       	call   419a <printf>
    2a7e:	83 c4 10             	add    $0x10,%esp
    exit();
    2a81:	e8 85 15 00 00       	call   400b <exit>
  }
  close(fd);
    2a86:	83 ec 0c             	sub    $0xc,%esp
    2a89:	ff 75 f4             	pushl  -0xc(%ebp)
    2a8c:	e8 a2 15 00 00       	call   4033 <close>
    2a91:	83 c4 10             	add    $0x10,%esp
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2a94:	83 ec 08             	sub    $0x8,%esp
    2a97:	6a 00                	push   $0x0
    2a99:	68 88 55 00 00       	push   $0x5588
    2a9e:	e8 a8 15 00 00       	call   404b <open>
    2aa3:	83 c4 10             	add    $0x10,%esp
    2aa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2aa9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2aad:	79 17                	jns    2ac6 <fourteen+0xe3>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2aaf:	83 ec 08             	sub    $0x8,%esp
    2ab2:	68 b8 55 00 00       	push   $0x55b8
    2ab7:	6a 01                	push   $0x1
    2ab9:	e8 dc 16 00 00       	call   419a <printf>
    2abe:	83 c4 10             	add    $0x10,%esp
    exit();
    2ac1:	e8 45 15 00 00       	call   400b <exit>
  }
  close(fd);
    2ac6:	83 ec 0c             	sub    $0xc,%esp
    2ac9:	ff 75 f4             	pushl  -0xc(%ebp)
    2acc:	e8 62 15 00 00       	call   4033 <close>
    2ad1:	83 c4 10             	add    $0x10,%esp

  if(mkdir("12345678901234/12345678901234") == 0){
    2ad4:	83 ec 0c             	sub    $0xc,%esp
    2ad7:	68 f2 55 00 00       	push   $0x55f2
    2adc:	e8 92 15 00 00       	call   4073 <mkdir>
    2ae1:	83 c4 10             	add    $0x10,%esp
    2ae4:	85 c0                	test   %eax,%eax
    2ae6:	75 17                	jne    2aff <fourteen+0x11c>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2ae8:	83 ec 08             	sub    $0x8,%esp
    2aeb:	68 10 56 00 00       	push   $0x5610
    2af0:	6a 01                	push   $0x1
    2af2:	e8 a3 16 00 00       	call   419a <printf>
    2af7:	83 c4 10             	add    $0x10,%esp
    exit();
    2afa:	e8 0c 15 00 00       	call   400b <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2aff:	83 ec 0c             	sub    $0xc,%esp
    2b02:	68 40 56 00 00       	push   $0x5640
    2b07:	e8 67 15 00 00       	call   4073 <mkdir>
    2b0c:	83 c4 10             	add    $0x10,%esp
    2b0f:	85 c0                	test   %eax,%eax
    2b11:	75 17                	jne    2b2a <fourteen+0x147>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2b13:	83 ec 08             	sub    $0x8,%esp
    2b16:	68 60 56 00 00       	push   $0x5660
    2b1b:	6a 01                	push   $0x1
    2b1d:	e8 78 16 00 00       	call   419a <printf>
    2b22:	83 c4 10             	add    $0x10,%esp
    exit();
    2b25:	e8 e1 14 00 00       	call   400b <exit>
  }

  printf(1, "fourteen ok\n");
    2b2a:	83 ec 08             	sub    $0x8,%esp
    2b2d:	68 91 56 00 00       	push   $0x5691
    2b32:	6a 01                	push   $0x1
    2b34:	e8 61 16 00 00       	call   419a <printf>
    2b39:	83 c4 10             	add    $0x10,%esp
}
    2b3c:	90                   	nop
    2b3d:	c9                   	leave  
    2b3e:	c3                   	ret    

00002b3f <rmdot>:

void
rmdot(void)
{
    2b3f:	55                   	push   %ebp
    2b40:	89 e5                	mov    %esp,%ebp
    2b42:	83 ec 08             	sub    $0x8,%esp
  printf(1, "rmdot test\n");
    2b45:	83 ec 08             	sub    $0x8,%esp
    2b48:	68 9e 56 00 00       	push   $0x569e
    2b4d:	6a 01                	push   $0x1
    2b4f:	e8 46 16 00 00       	call   419a <printf>
    2b54:	83 c4 10             	add    $0x10,%esp
  if(mkdir("dots") != 0){
    2b57:	83 ec 0c             	sub    $0xc,%esp
    2b5a:	68 aa 56 00 00       	push   $0x56aa
    2b5f:	e8 0f 15 00 00       	call   4073 <mkdir>
    2b64:	83 c4 10             	add    $0x10,%esp
    2b67:	85 c0                	test   %eax,%eax
    2b69:	74 17                	je     2b82 <rmdot+0x43>
    printf(1, "mkdir dots failed\n");
    2b6b:	83 ec 08             	sub    $0x8,%esp
    2b6e:	68 af 56 00 00       	push   $0x56af
    2b73:	6a 01                	push   $0x1
    2b75:	e8 20 16 00 00       	call   419a <printf>
    2b7a:	83 c4 10             	add    $0x10,%esp
    exit();
    2b7d:	e8 89 14 00 00       	call   400b <exit>
  }
  if(chdir("dots") != 0){
    2b82:	83 ec 0c             	sub    $0xc,%esp
    2b85:	68 aa 56 00 00       	push   $0x56aa
    2b8a:	e8 ec 14 00 00       	call   407b <chdir>
    2b8f:	83 c4 10             	add    $0x10,%esp
    2b92:	85 c0                	test   %eax,%eax
    2b94:	74 17                	je     2bad <rmdot+0x6e>
    printf(1, "chdir dots failed\n");
    2b96:	83 ec 08             	sub    $0x8,%esp
    2b99:	68 c2 56 00 00       	push   $0x56c2
    2b9e:	6a 01                	push   $0x1
    2ba0:	e8 f5 15 00 00       	call   419a <printf>
    2ba5:	83 c4 10             	add    $0x10,%esp
    exit();
    2ba8:	e8 5e 14 00 00       	call   400b <exit>
  }
  if(unlink(".") == 0){
    2bad:	83 ec 0c             	sub    $0xc,%esp
    2bb0:	68 db 4d 00 00       	push   $0x4ddb
    2bb5:	e8 a1 14 00 00       	call   405b <unlink>
    2bba:	83 c4 10             	add    $0x10,%esp
    2bbd:	85 c0                	test   %eax,%eax
    2bbf:	75 17                	jne    2bd8 <rmdot+0x99>
    printf(1, "rm . worked!\n");
    2bc1:	83 ec 08             	sub    $0x8,%esp
    2bc4:	68 d5 56 00 00       	push   $0x56d5
    2bc9:	6a 01                	push   $0x1
    2bcb:	e8 ca 15 00 00       	call   419a <printf>
    2bd0:	83 c4 10             	add    $0x10,%esp
    exit();
    2bd3:	e8 33 14 00 00       	call   400b <exit>
  }
  if(unlink("..") == 0){
    2bd8:	83 ec 0c             	sub    $0xc,%esp
    2bdb:	68 6e 49 00 00       	push   $0x496e
    2be0:	e8 76 14 00 00       	call   405b <unlink>
    2be5:	83 c4 10             	add    $0x10,%esp
    2be8:	85 c0                	test   %eax,%eax
    2bea:	75 17                	jne    2c03 <rmdot+0xc4>
    printf(1, "rm .. worked!\n");
    2bec:	83 ec 08             	sub    $0x8,%esp
    2bef:	68 e3 56 00 00       	push   $0x56e3
    2bf4:	6a 01                	push   $0x1
    2bf6:	e8 9f 15 00 00       	call   419a <printf>
    2bfb:	83 c4 10             	add    $0x10,%esp
    exit();
    2bfe:	e8 08 14 00 00       	call   400b <exit>
  }
  if(chdir("/") != 0){
    2c03:	83 ec 0c             	sub    $0xc,%esp
    2c06:	68 c2 45 00 00       	push   $0x45c2
    2c0b:	e8 6b 14 00 00       	call   407b <chdir>
    2c10:	83 c4 10             	add    $0x10,%esp
    2c13:	85 c0                	test   %eax,%eax
    2c15:	74 17                	je     2c2e <rmdot+0xef>
    printf(1, "chdir / failed\n");
    2c17:	83 ec 08             	sub    $0x8,%esp
    2c1a:	68 c4 45 00 00       	push   $0x45c4
    2c1f:	6a 01                	push   $0x1
    2c21:	e8 74 15 00 00       	call   419a <printf>
    2c26:	83 c4 10             	add    $0x10,%esp
    exit();
    2c29:	e8 dd 13 00 00       	call   400b <exit>
  }
  if(unlink("dots/.") == 0){
    2c2e:	83 ec 0c             	sub    $0xc,%esp
    2c31:	68 f2 56 00 00       	push   $0x56f2
    2c36:	e8 20 14 00 00       	call   405b <unlink>
    2c3b:	83 c4 10             	add    $0x10,%esp
    2c3e:	85 c0                	test   %eax,%eax
    2c40:	75 17                	jne    2c59 <rmdot+0x11a>
    printf(1, "unlink dots/. worked!\n");
    2c42:	83 ec 08             	sub    $0x8,%esp
    2c45:	68 f9 56 00 00       	push   $0x56f9
    2c4a:	6a 01                	push   $0x1
    2c4c:	e8 49 15 00 00       	call   419a <printf>
    2c51:	83 c4 10             	add    $0x10,%esp
    exit();
    2c54:	e8 b2 13 00 00       	call   400b <exit>
  }
  if(unlink("dots/..") == 0){
    2c59:	83 ec 0c             	sub    $0xc,%esp
    2c5c:	68 10 57 00 00       	push   $0x5710
    2c61:	e8 f5 13 00 00       	call   405b <unlink>
    2c66:	83 c4 10             	add    $0x10,%esp
    2c69:	85 c0                	test   %eax,%eax
    2c6b:	75 17                	jne    2c84 <rmdot+0x145>
    printf(1, "unlink dots/.. worked!\n");
    2c6d:	83 ec 08             	sub    $0x8,%esp
    2c70:	68 18 57 00 00       	push   $0x5718
    2c75:	6a 01                	push   $0x1
    2c77:	e8 1e 15 00 00       	call   419a <printf>
    2c7c:	83 c4 10             	add    $0x10,%esp
    exit();
    2c7f:	e8 87 13 00 00       	call   400b <exit>
  }
  if(unlink("dots") != 0){
    2c84:	83 ec 0c             	sub    $0xc,%esp
    2c87:	68 aa 56 00 00       	push   $0x56aa
    2c8c:	e8 ca 13 00 00       	call   405b <unlink>
    2c91:	83 c4 10             	add    $0x10,%esp
    2c94:	85 c0                	test   %eax,%eax
    2c96:	74 17                	je     2caf <rmdot+0x170>
    printf(1, "unlink dots failed!\n");
    2c98:	83 ec 08             	sub    $0x8,%esp
    2c9b:	68 30 57 00 00       	push   $0x5730
    2ca0:	6a 01                	push   $0x1
    2ca2:	e8 f3 14 00 00       	call   419a <printf>
    2ca7:	83 c4 10             	add    $0x10,%esp
    exit();
    2caa:	e8 5c 13 00 00       	call   400b <exit>
  }
  printf(1, "rmdot ok\n");
    2caf:	83 ec 08             	sub    $0x8,%esp
    2cb2:	68 45 57 00 00       	push   $0x5745
    2cb7:	6a 01                	push   $0x1
    2cb9:	e8 dc 14 00 00       	call   419a <printf>
    2cbe:	83 c4 10             	add    $0x10,%esp
}
    2cc1:	90                   	nop
    2cc2:	c9                   	leave  
    2cc3:	c3                   	ret    

00002cc4 <dirfile>:

void
dirfile(void)
{
    2cc4:	55                   	push   %ebp
    2cc5:	89 e5                	mov    %esp,%ebp
    2cc7:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(1, "dir vs file\n");
    2cca:	83 ec 08             	sub    $0x8,%esp
    2ccd:	68 4f 57 00 00       	push   $0x574f
    2cd2:	6a 01                	push   $0x1
    2cd4:	e8 c1 14 00 00       	call   419a <printf>
    2cd9:	83 c4 10             	add    $0x10,%esp

  fd = open("dirfile", O_CREATE);
    2cdc:	83 ec 08             	sub    $0x8,%esp
    2cdf:	68 00 02 00 00       	push   $0x200
    2ce4:	68 5c 57 00 00       	push   $0x575c
    2ce9:	e8 5d 13 00 00       	call   404b <open>
    2cee:	83 c4 10             	add    $0x10,%esp
    2cf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2cf4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2cf8:	79 17                	jns    2d11 <dirfile+0x4d>
    printf(1, "create dirfile failed\n");
    2cfa:	83 ec 08             	sub    $0x8,%esp
    2cfd:	68 64 57 00 00       	push   $0x5764
    2d02:	6a 01                	push   $0x1
    2d04:	e8 91 14 00 00       	call   419a <printf>
    2d09:	83 c4 10             	add    $0x10,%esp
    exit();
    2d0c:	e8 fa 12 00 00       	call   400b <exit>
  }
  close(fd);
    2d11:	83 ec 0c             	sub    $0xc,%esp
    2d14:	ff 75 f4             	pushl  -0xc(%ebp)
    2d17:	e8 17 13 00 00       	call   4033 <close>
    2d1c:	83 c4 10             	add    $0x10,%esp
  if(chdir("dirfile") == 0){
    2d1f:	83 ec 0c             	sub    $0xc,%esp
    2d22:	68 5c 57 00 00       	push   $0x575c
    2d27:	e8 4f 13 00 00       	call   407b <chdir>
    2d2c:	83 c4 10             	add    $0x10,%esp
    2d2f:	85 c0                	test   %eax,%eax
    2d31:	75 17                	jne    2d4a <dirfile+0x86>
    printf(1, "chdir dirfile succeeded!\n");
    2d33:	83 ec 08             	sub    $0x8,%esp
    2d36:	68 7b 57 00 00       	push   $0x577b
    2d3b:	6a 01                	push   $0x1
    2d3d:	e8 58 14 00 00       	call   419a <printf>
    2d42:	83 c4 10             	add    $0x10,%esp
    exit();
    2d45:	e8 c1 12 00 00       	call   400b <exit>
  }
  fd = open("dirfile/xx", 0);
    2d4a:	83 ec 08             	sub    $0x8,%esp
    2d4d:	6a 00                	push   $0x0
    2d4f:	68 95 57 00 00       	push   $0x5795
    2d54:	e8 f2 12 00 00       	call   404b <open>
    2d59:	83 c4 10             	add    $0x10,%esp
    2d5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2d5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d63:	78 17                	js     2d7c <dirfile+0xb8>
    printf(1, "create dirfile/xx succeeded!\n");
    2d65:	83 ec 08             	sub    $0x8,%esp
    2d68:	68 a0 57 00 00       	push   $0x57a0
    2d6d:	6a 01                	push   $0x1
    2d6f:	e8 26 14 00 00       	call   419a <printf>
    2d74:	83 c4 10             	add    $0x10,%esp
    exit();
    2d77:	e8 8f 12 00 00       	call   400b <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    2d7c:	83 ec 08             	sub    $0x8,%esp
    2d7f:	68 00 02 00 00       	push   $0x200
    2d84:	68 95 57 00 00       	push   $0x5795
    2d89:	e8 bd 12 00 00       	call   404b <open>
    2d8e:	83 c4 10             	add    $0x10,%esp
    2d91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2d94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d98:	78 17                	js     2db1 <dirfile+0xed>
    printf(1, "create dirfile/xx succeeded!\n");
    2d9a:	83 ec 08             	sub    $0x8,%esp
    2d9d:	68 a0 57 00 00       	push   $0x57a0
    2da2:	6a 01                	push   $0x1
    2da4:	e8 f1 13 00 00       	call   419a <printf>
    2da9:	83 c4 10             	add    $0x10,%esp
    exit();
    2dac:	e8 5a 12 00 00       	call   400b <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    2db1:	83 ec 0c             	sub    $0xc,%esp
    2db4:	68 95 57 00 00       	push   $0x5795
    2db9:	e8 b5 12 00 00       	call   4073 <mkdir>
    2dbe:	83 c4 10             	add    $0x10,%esp
    2dc1:	85 c0                	test   %eax,%eax
    2dc3:	75 17                	jne    2ddc <dirfile+0x118>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2dc5:	83 ec 08             	sub    $0x8,%esp
    2dc8:	68 be 57 00 00       	push   $0x57be
    2dcd:	6a 01                	push   $0x1
    2dcf:	e8 c6 13 00 00       	call   419a <printf>
    2dd4:	83 c4 10             	add    $0x10,%esp
    exit();
    2dd7:	e8 2f 12 00 00       	call   400b <exit>
  }
  if(unlink("dirfile/xx") == 0){
    2ddc:	83 ec 0c             	sub    $0xc,%esp
    2ddf:	68 95 57 00 00       	push   $0x5795
    2de4:	e8 72 12 00 00       	call   405b <unlink>
    2de9:	83 c4 10             	add    $0x10,%esp
    2dec:	85 c0                	test   %eax,%eax
    2dee:	75 17                	jne    2e07 <dirfile+0x143>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2df0:	83 ec 08             	sub    $0x8,%esp
    2df3:	68 db 57 00 00       	push   $0x57db
    2df8:	6a 01                	push   $0x1
    2dfa:	e8 9b 13 00 00       	call   419a <printf>
    2dff:	83 c4 10             	add    $0x10,%esp
    exit();
    2e02:	e8 04 12 00 00       	call   400b <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    2e07:	83 ec 08             	sub    $0x8,%esp
    2e0a:	68 95 57 00 00       	push   $0x5795
    2e0f:	68 f9 57 00 00       	push   $0x57f9
    2e14:	e8 52 12 00 00       	call   406b <link>
    2e19:	83 c4 10             	add    $0x10,%esp
    2e1c:	85 c0                	test   %eax,%eax
    2e1e:	75 17                	jne    2e37 <dirfile+0x173>
    printf(1, "link to dirfile/xx succeeded!\n");
    2e20:	83 ec 08             	sub    $0x8,%esp
    2e23:	68 00 58 00 00       	push   $0x5800
    2e28:	6a 01                	push   $0x1
    2e2a:	e8 6b 13 00 00       	call   419a <printf>
    2e2f:	83 c4 10             	add    $0x10,%esp
    exit();
    2e32:	e8 d4 11 00 00       	call   400b <exit>
  }
  if(unlink("dirfile") != 0){
    2e37:	83 ec 0c             	sub    $0xc,%esp
    2e3a:	68 5c 57 00 00       	push   $0x575c
    2e3f:	e8 17 12 00 00       	call   405b <unlink>
    2e44:	83 c4 10             	add    $0x10,%esp
    2e47:	85 c0                	test   %eax,%eax
    2e49:	74 17                	je     2e62 <dirfile+0x19e>
    printf(1, "unlink dirfile failed!\n");
    2e4b:	83 ec 08             	sub    $0x8,%esp
    2e4e:	68 1f 58 00 00       	push   $0x581f
    2e53:	6a 01                	push   $0x1
    2e55:	e8 40 13 00 00       	call   419a <printf>
    2e5a:	83 c4 10             	add    $0x10,%esp
    exit();
    2e5d:	e8 a9 11 00 00       	call   400b <exit>
  }

  fd = open(".", O_RDWR);
    2e62:	83 ec 08             	sub    $0x8,%esp
    2e65:	6a 02                	push   $0x2
    2e67:	68 db 4d 00 00       	push   $0x4ddb
    2e6c:	e8 da 11 00 00       	call   404b <open>
    2e71:	83 c4 10             	add    $0x10,%esp
    2e74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2e77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2e7b:	78 17                	js     2e94 <dirfile+0x1d0>
    printf(1, "open . for writing succeeded!\n");
    2e7d:	83 ec 08             	sub    $0x8,%esp
    2e80:	68 38 58 00 00       	push   $0x5838
    2e85:	6a 01                	push   $0x1
    2e87:	e8 0e 13 00 00       	call   419a <printf>
    2e8c:	83 c4 10             	add    $0x10,%esp
    exit();
    2e8f:	e8 77 11 00 00       	call   400b <exit>
  }
  fd = open(".", 0);
    2e94:	83 ec 08             	sub    $0x8,%esp
    2e97:	6a 00                	push   $0x0
    2e99:	68 db 4d 00 00       	push   $0x4ddb
    2e9e:	e8 a8 11 00 00       	call   404b <open>
    2ea3:	83 c4 10             	add    $0x10,%esp
    2ea6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(write(fd, "x", 1) > 0){
    2ea9:	83 ec 04             	sub    $0x4,%esp
    2eac:	6a 01                	push   $0x1
    2eae:	68 27 4a 00 00       	push   $0x4a27
    2eb3:	ff 75 f4             	pushl  -0xc(%ebp)
    2eb6:	e8 70 11 00 00       	call   402b <write>
    2ebb:	83 c4 10             	add    $0x10,%esp
    2ebe:	85 c0                	test   %eax,%eax
    2ec0:	7e 17                	jle    2ed9 <dirfile+0x215>
    printf(1, "write . succeeded!\n");
    2ec2:	83 ec 08             	sub    $0x8,%esp
    2ec5:	68 57 58 00 00       	push   $0x5857
    2eca:	6a 01                	push   $0x1
    2ecc:	e8 c9 12 00 00       	call   419a <printf>
    2ed1:	83 c4 10             	add    $0x10,%esp
    exit();
    2ed4:	e8 32 11 00 00       	call   400b <exit>
  }
  close(fd);
    2ed9:	83 ec 0c             	sub    $0xc,%esp
    2edc:	ff 75 f4             	pushl  -0xc(%ebp)
    2edf:	e8 4f 11 00 00       	call   4033 <close>
    2ee4:	83 c4 10             	add    $0x10,%esp

  printf(1, "dir vs file OK\n");
    2ee7:	83 ec 08             	sub    $0x8,%esp
    2eea:	68 6b 58 00 00       	push   $0x586b
    2eef:	6a 01                	push   $0x1
    2ef1:	e8 a4 12 00 00       	call   419a <printf>
    2ef6:	83 c4 10             	add    $0x10,%esp
}
    2ef9:	90                   	nop
    2efa:	c9                   	leave  
    2efb:	c3                   	ret    

00002efc <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2efc:	55                   	push   %ebp
    2efd:	89 e5                	mov    %esp,%ebp
    2eff:	83 ec 18             	sub    $0x18,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2f02:	83 ec 08             	sub    $0x8,%esp
    2f05:	68 7b 58 00 00       	push   $0x587b
    2f0a:	6a 01                	push   $0x1
    2f0c:	e8 89 12 00 00       	call   419a <printf>
    2f11:	83 c4 10             	add    $0x10,%esp

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2f14:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2f1b:	e9 e7 00 00 00       	jmp    3007 <iref+0x10b>
    if(mkdir("irefd") != 0){
    2f20:	83 ec 0c             	sub    $0xc,%esp
    2f23:	68 8c 58 00 00       	push   $0x588c
    2f28:	e8 46 11 00 00       	call   4073 <mkdir>
    2f2d:	83 c4 10             	add    $0x10,%esp
    2f30:	85 c0                	test   %eax,%eax
    2f32:	74 17                	je     2f4b <iref+0x4f>
      printf(1, "mkdir irefd failed\n");
    2f34:	83 ec 08             	sub    $0x8,%esp
    2f37:	68 92 58 00 00       	push   $0x5892
    2f3c:	6a 01                	push   $0x1
    2f3e:	e8 57 12 00 00       	call   419a <printf>
    2f43:	83 c4 10             	add    $0x10,%esp
      exit();
    2f46:	e8 c0 10 00 00       	call   400b <exit>
    }
    if(chdir("irefd") != 0){
    2f4b:	83 ec 0c             	sub    $0xc,%esp
    2f4e:	68 8c 58 00 00       	push   $0x588c
    2f53:	e8 23 11 00 00       	call   407b <chdir>
    2f58:	83 c4 10             	add    $0x10,%esp
    2f5b:	85 c0                	test   %eax,%eax
    2f5d:	74 17                	je     2f76 <iref+0x7a>
      printf(1, "chdir irefd failed\n");
    2f5f:	83 ec 08             	sub    $0x8,%esp
    2f62:	68 a6 58 00 00       	push   $0x58a6
    2f67:	6a 01                	push   $0x1
    2f69:	e8 2c 12 00 00       	call   419a <printf>
    2f6e:	83 c4 10             	add    $0x10,%esp
      exit();
    2f71:	e8 95 10 00 00       	call   400b <exit>
    }

    mkdir("");
    2f76:	83 ec 0c             	sub    $0xc,%esp
    2f79:	68 ba 58 00 00       	push   $0x58ba
    2f7e:	e8 f0 10 00 00       	call   4073 <mkdir>
    2f83:	83 c4 10             	add    $0x10,%esp
    link("README", "");
    2f86:	83 ec 08             	sub    $0x8,%esp
    2f89:	68 ba 58 00 00       	push   $0x58ba
    2f8e:	68 f9 57 00 00       	push   $0x57f9
    2f93:	e8 d3 10 00 00       	call   406b <link>
    2f98:	83 c4 10             	add    $0x10,%esp
    fd = open("", O_CREATE);
    2f9b:	83 ec 08             	sub    $0x8,%esp
    2f9e:	68 00 02 00 00       	push   $0x200
    2fa3:	68 ba 58 00 00       	push   $0x58ba
    2fa8:	e8 9e 10 00 00       	call   404b <open>
    2fad:	83 c4 10             	add    $0x10,%esp
    2fb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2fb3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2fb7:	78 0e                	js     2fc7 <iref+0xcb>
      close(fd);
    2fb9:	83 ec 0c             	sub    $0xc,%esp
    2fbc:	ff 75 f0             	pushl  -0x10(%ebp)
    2fbf:	e8 6f 10 00 00       	call   4033 <close>
    2fc4:	83 c4 10             	add    $0x10,%esp
    fd = open("xx", O_CREATE);
    2fc7:	83 ec 08             	sub    $0x8,%esp
    2fca:	68 00 02 00 00       	push   $0x200
    2fcf:	68 bb 58 00 00       	push   $0x58bb
    2fd4:	e8 72 10 00 00       	call   404b <open>
    2fd9:	83 c4 10             	add    $0x10,%esp
    2fdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2fdf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2fe3:	78 0e                	js     2ff3 <iref+0xf7>
      close(fd);
    2fe5:	83 ec 0c             	sub    $0xc,%esp
    2fe8:	ff 75 f0             	pushl  -0x10(%ebp)
    2feb:	e8 43 10 00 00       	call   4033 <close>
    2ff0:	83 c4 10             	add    $0x10,%esp
    unlink("xx");
    2ff3:	83 ec 0c             	sub    $0xc,%esp
    2ff6:	68 bb 58 00 00       	push   $0x58bb
    2ffb:	e8 5b 10 00 00       	call   405b <unlink>
    3000:	83 c4 10             	add    $0x10,%esp
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    3003:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3007:	83 7d f4 32          	cmpl   $0x32,-0xc(%ebp)
    300b:	0f 8e 0f ff ff ff    	jle    2f20 <iref+0x24>
    if(fd >= 0)
      close(fd);
    unlink("xx");
  }

  chdir("/");
    3011:	83 ec 0c             	sub    $0xc,%esp
    3014:	68 c2 45 00 00       	push   $0x45c2
    3019:	e8 5d 10 00 00       	call   407b <chdir>
    301e:	83 c4 10             	add    $0x10,%esp
  printf(1, "empty file name OK\n");
    3021:	83 ec 08             	sub    $0x8,%esp
    3024:	68 be 58 00 00       	push   $0x58be
    3029:	6a 01                	push   $0x1
    302b:	e8 6a 11 00 00       	call   419a <printf>
    3030:	83 c4 10             	add    $0x10,%esp
}
    3033:	90                   	nop
    3034:	c9                   	leave  
    3035:	c3                   	ret    

00003036 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    3036:	55                   	push   %ebp
    3037:	89 e5                	mov    %esp,%ebp
    3039:	83 ec 18             	sub    $0x18,%esp
  int n, pid;

  printf(1, "fork test\n");
    303c:	83 ec 08             	sub    $0x8,%esp
    303f:	68 d2 58 00 00       	push   $0x58d2
    3044:	6a 01                	push   $0x1
    3046:	e8 4f 11 00 00       	call   419a <printf>
    304b:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<1000; n++){
    304e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3055:	eb 1d                	jmp    3074 <forktest+0x3e>
    pid = fork();
    3057:	e8 a7 0f 00 00       	call   4003 <fork>
    305c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
    305f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3063:	78 1a                	js     307f <forktest+0x49>
      break;
    if(pid == 0)
    3065:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3069:	75 05                	jne    3070 <forktest+0x3a>
      exit();
    306b:	e8 9b 0f 00 00       	call   400b <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
    3070:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3074:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
    307b:	7e da                	jle    3057 <forktest+0x21>
    307d:	eb 01                	jmp    3080 <forktest+0x4a>
    pid = fork();
    if(pid < 0)
      break;
    307f:	90                   	nop
    if(pid == 0)
      exit();
  }

  if(n == 1000){
    3080:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
    3087:	75 3b                	jne    30c4 <forktest+0x8e>
    printf(1, "fork claimed to work 1000 times!\n");
    3089:	83 ec 08             	sub    $0x8,%esp
    308c:	68 e0 58 00 00       	push   $0x58e0
    3091:	6a 01                	push   $0x1
    3093:	e8 02 11 00 00       	call   419a <printf>
    3098:	83 c4 10             	add    $0x10,%esp
    exit();
    309b:	e8 6b 0f 00 00       	call   400b <exit>
  }

  for(; n > 0; n--){
    if(wait() < 0){
    30a0:	e8 6e 0f 00 00       	call   4013 <wait>
    30a5:	85 c0                	test   %eax,%eax
    30a7:	79 17                	jns    30c0 <forktest+0x8a>
      printf(1, "wait stopped early\n");
    30a9:	83 ec 08             	sub    $0x8,%esp
    30ac:	68 02 59 00 00       	push   $0x5902
    30b1:	6a 01                	push   $0x1
    30b3:	e8 e2 10 00 00       	call   419a <printf>
    30b8:	83 c4 10             	add    $0x10,%esp
      exit();
    30bb:	e8 4b 0f 00 00       	call   400b <exit>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }

  for(; n > 0; n--){
    30c0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    30c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    30c8:	7f d6                	jg     30a0 <forktest+0x6a>
      printf(1, "wait stopped early\n");
      exit();
    }
  }

  if(wait() != -1){
    30ca:	e8 44 0f 00 00       	call   4013 <wait>
    30cf:	83 f8 ff             	cmp    $0xffffffff,%eax
    30d2:	74 17                	je     30eb <forktest+0xb5>
    printf(1, "wait got too many\n");
    30d4:	83 ec 08             	sub    $0x8,%esp
    30d7:	68 16 59 00 00       	push   $0x5916
    30dc:	6a 01                	push   $0x1
    30de:	e8 b7 10 00 00       	call   419a <printf>
    30e3:	83 c4 10             	add    $0x10,%esp
    exit();
    30e6:	e8 20 0f 00 00       	call   400b <exit>
  }

  printf(1, "fork test OK\n");
    30eb:	83 ec 08             	sub    $0x8,%esp
    30ee:	68 29 59 00 00       	push   $0x5929
    30f3:	6a 01                	push   $0x1
    30f5:	e8 a0 10 00 00       	call   419a <printf>
    30fa:	83 c4 10             	add    $0x10,%esp
}
    30fd:	90                   	nop
    30fe:	c9                   	leave  
    30ff:	c3                   	ret    

00003100 <sbrktest>:

void
sbrktest(void)
{
    3100:	55                   	push   %ebp
    3101:	89 e5                	mov    %esp,%ebp
    3103:	53                   	push   %ebx
    3104:	83 ec 64             	sub    $0x64,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    3107:	a1 ac 64 00 00       	mov    0x64ac,%eax
    310c:	83 ec 08             	sub    $0x8,%esp
    310f:	68 37 59 00 00       	push   $0x5937
    3114:	50                   	push   %eax
    3115:	e8 80 10 00 00       	call   419a <printf>
    311a:	83 c4 10             	add    $0x10,%esp
  oldbrk = sbrk(0);
    311d:	83 ec 0c             	sub    $0xc,%esp
    3120:	6a 00                	push   $0x0
    3122:	e8 6c 0f 00 00       	call   4093 <sbrk>
    3127:	83 c4 10             	add    $0x10,%esp
    312a:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    312d:	83 ec 0c             	sub    $0xc,%esp
    3130:	6a 00                	push   $0x0
    3132:	e8 5c 0f 00 00       	call   4093 <sbrk>
    3137:	83 c4 10             	add    $0x10,%esp
    313a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int i;
  for(i = 0; i < 5000; i++){
    313d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3144:	eb 4f                	jmp    3195 <sbrktest+0x95>
    b = sbrk(1);
    3146:	83 ec 0c             	sub    $0xc,%esp
    3149:	6a 01                	push   $0x1
    314b:	e8 43 0f 00 00       	call   4093 <sbrk>
    3150:	83 c4 10             	add    $0x10,%esp
    3153:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(b != a){
    3156:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3159:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    315c:	74 24                	je     3182 <sbrktest+0x82>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    315e:	a1 ac 64 00 00       	mov    0x64ac,%eax
    3163:	83 ec 0c             	sub    $0xc,%esp
    3166:	ff 75 e8             	pushl  -0x18(%ebp)
    3169:	ff 75 f4             	pushl  -0xc(%ebp)
    316c:	ff 75 f0             	pushl  -0x10(%ebp)
    316f:	68 42 59 00 00       	push   $0x5942
    3174:	50                   	push   %eax
    3175:	e8 20 10 00 00       	call   419a <printf>
    317a:	83 c4 20             	add    $0x20,%esp
      exit();
    317d:	e8 89 0e 00 00       	call   400b <exit>
    }
    *b = 1;
    3182:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3185:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    3188:	8b 45 e8             	mov    -0x18(%ebp),%eax
    318b:	83 c0 01             	add    $0x1,%eax
    318e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){
    3191:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3195:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
    319c:	7e a8                	jle    3146 <sbrktest+0x46>
      exit();
    }
    *b = 1;
    a = b + 1;
  }
  pid = fork();
    319e:	e8 60 0e 00 00       	call   4003 <fork>
    31a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    31a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    31aa:	79 1b                	jns    31c7 <sbrktest+0xc7>
    printf(stdout, "sbrk test fork failed\n");
    31ac:	a1 ac 64 00 00       	mov    0x64ac,%eax
    31b1:	83 ec 08             	sub    $0x8,%esp
    31b4:	68 5d 59 00 00       	push   $0x595d
    31b9:	50                   	push   %eax
    31ba:	e8 db 0f 00 00       	call   419a <printf>
    31bf:	83 c4 10             	add    $0x10,%esp
    exit();
    31c2:	e8 44 0e 00 00       	call   400b <exit>
  }
  c = sbrk(1);
    31c7:	83 ec 0c             	sub    $0xc,%esp
    31ca:	6a 01                	push   $0x1
    31cc:	e8 c2 0e 00 00       	call   4093 <sbrk>
    31d1:	83 c4 10             	add    $0x10,%esp
    31d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  c = sbrk(1);
    31d7:	83 ec 0c             	sub    $0xc,%esp
    31da:	6a 01                	push   $0x1
    31dc:	e8 b2 0e 00 00       	call   4093 <sbrk>
    31e1:	83 c4 10             	add    $0x10,%esp
    31e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a + 1){
    31e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    31ea:	83 c0 01             	add    $0x1,%eax
    31ed:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    31f0:	74 1b                	je     320d <sbrktest+0x10d>
    printf(stdout, "sbrk test failed post-fork\n");
    31f2:	a1 ac 64 00 00       	mov    0x64ac,%eax
    31f7:	83 ec 08             	sub    $0x8,%esp
    31fa:	68 74 59 00 00       	push   $0x5974
    31ff:	50                   	push   %eax
    3200:	e8 95 0f 00 00       	call   419a <printf>
    3205:	83 c4 10             	add    $0x10,%esp
    exit();
    3208:	e8 fe 0d 00 00       	call   400b <exit>
  }
  if(pid == 0)
    320d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3211:	75 05                	jne    3218 <sbrktest+0x118>
    exit();
    3213:	e8 f3 0d 00 00       	call   400b <exit>
  wait();
    3218:	e8 f6 0d 00 00       	call   4013 <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    321d:	83 ec 0c             	sub    $0xc,%esp
    3220:	6a 00                	push   $0x0
    3222:	e8 6c 0e 00 00       	call   4093 <sbrk>
    3227:	83 c4 10             	add    $0x10,%esp
    322a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  amt = (BIG) - (uint)a;
    322d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3230:	ba 00 00 40 06       	mov    $0x6400000,%edx
    3235:	29 c2                	sub    %eax,%edx
    3237:	89 d0                	mov    %edx,%eax
    3239:	89 45 dc             	mov    %eax,-0x24(%ebp)
  p = sbrk(amt);
    323c:	8b 45 dc             	mov    -0x24(%ebp),%eax
    323f:	83 ec 0c             	sub    $0xc,%esp
    3242:	50                   	push   %eax
    3243:	e8 4b 0e 00 00       	call   4093 <sbrk>
    3248:	83 c4 10             	add    $0x10,%esp
    324b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if (p != a) {
    324e:	8b 45 d8             	mov    -0x28(%ebp),%eax
    3251:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3254:	74 1b                	je     3271 <sbrktest+0x171>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    3256:	a1 ac 64 00 00       	mov    0x64ac,%eax
    325b:	83 ec 08             	sub    $0x8,%esp
    325e:	68 90 59 00 00       	push   $0x5990
    3263:	50                   	push   %eax
    3264:	e8 31 0f 00 00       	call   419a <printf>
    3269:	83 c4 10             	add    $0x10,%esp
    exit();
    326c:	e8 9a 0d 00 00       	call   400b <exit>
  }
  lastaddr = (char*) (BIG-1);
    3271:	c7 45 d4 ff ff 3f 06 	movl   $0x63fffff,-0x2c(%ebp)
  *lastaddr = 99;
    3278:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    327b:	c6 00 63             	movb   $0x63,(%eax)

  // can one de-allocate?
  a = sbrk(0);
    327e:	83 ec 0c             	sub    $0xc,%esp
    3281:	6a 00                	push   $0x0
    3283:	e8 0b 0e 00 00       	call   4093 <sbrk>
    3288:	83 c4 10             	add    $0x10,%esp
    328b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-4096);
    328e:	83 ec 0c             	sub    $0xc,%esp
    3291:	68 00 f0 ff ff       	push   $0xfffff000
    3296:	e8 f8 0d 00 00       	call   4093 <sbrk>
    329b:	83 c4 10             	add    $0x10,%esp
    329e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c == (char*)0xffffffff){
    32a1:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    32a5:	75 1b                	jne    32c2 <sbrktest+0x1c2>
    printf(stdout, "sbrk could not deallocate\n");
    32a7:	a1 ac 64 00 00       	mov    0x64ac,%eax
    32ac:	83 ec 08             	sub    $0x8,%esp
    32af:	68 ce 59 00 00       	push   $0x59ce
    32b4:	50                   	push   %eax
    32b5:	e8 e0 0e 00 00       	call   419a <printf>
    32ba:	83 c4 10             	add    $0x10,%esp
    exit();
    32bd:	e8 49 0d 00 00       	call   400b <exit>
  }
  c = sbrk(0);
    32c2:	83 ec 0c             	sub    $0xc,%esp
    32c5:	6a 00                	push   $0x0
    32c7:	e8 c7 0d 00 00       	call   4093 <sbrk>
    32cc:	83 c4 10             	add    $0x10,%esp
    32cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a - 4096){
    32d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    32d5:	2d 00 10 00 00       	sub    $0x1000,%eax
    32da:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    32dd:	74 1e                	je     32fd <sbrktest+0x1fd>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    32df:	a1 ac 64 00 00       	mov    0x64ac,%eax
    32e4:	ff 75 e0             	pushl  -0x20(%ebp)
    32e7:	ff 75 f4             	pushl  -0xc(%ebp)
    32ea:	68 ec 59 00 00       	push   $0x59ec
    32ef:	50                   	push   %eax
    32f0:	e8 a5 0e 00 00       	call   419a <printf>
    32f5:	83 c4 10             	add    $0x10,%esp
    exit();
    32f8:	e8 0e 0d 00 00       	call   400b <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    32fd:	83 ec 0c             	sub    $0xc,%esp
    3300:	6a 00                	push   $0x0
    3302:	e8 8c 0d 00 00       	call   4093 <sbrk>
    3307:	83 c4 10             	add    $0x10,%esp
    330a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(4096);
    330d:	83 ec 0c             	sub    $0xc,%esp
    3310:	68 00 10 00 00       	push   $0x1000
    3315:	e8 79 0d 00 00       	call   4093 <sbrk>
    331a:	83 c4 10             	add    $0x10,%esp
    331d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a || sbrk(0) != a + 4096){
    3320:	8b 45 e0             	mov    -0x20(%ebp),%eax
    3323:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3326:	75 1b                	jne    3343 <sbrktest+0x243>
    3328:	83 ec 0c             	sub    $0xc,%esp
    332b:	6a 00                	push   $0x0
    332d:	e8 61 0d 00 00       	call   4093 <sbrk>
    3332:	83 c4 10             	add    $0x10,%esp
    3335:	89 c2                	mov    %eax,%edx
    3337:	8b 45 f4             	mov    -0xc(%ebp),%eax
    333a:	05 00 10 00 00       	add    $0x1000,%eax
    333f:	39 c2                	cmp    %eax,%edx
    3341:	74 1e                	je     3361 <sbrktest+0x261>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    3343:	a1 ac 64 00 00       	mov    0x64ac,%eax
    3348:	ff 75 e0             	pushl  -0x20(%ebp)
    334b:	ff 75 f4             	pushl  -0xc(%ebp)
    334e:	68 24 5a 00 00       	push   $0x5a24
    3353:	50                   	push   %eax
    3354:	e8 41 0e 00 00       	call   419a <printf>
    3359:	83 c4 10             	add    $0x10,%esp
    exit();
    335c:	e8 aa 0c 00 00       	call   400b <exit>
  }
  if(*lastaddr == 99){
    3361:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3364:	0f b6 00             	movzbl (%eax),%eax
    3367:	3c 63                	cmp    $0x63,%al
    3369:	75 1b                	jne    3386 <sbrktest+0x286>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    336b:	a1 ac 64 00 00       	mov    0x64ac,%eax
    3370:	83 ec 08             	sub    $0x8,%esp
    3373:	68 4c 5a 00 00       	push   $0x5a4c
    3378:	50                   	push   %eax
    3379:	e8 1c 0e 00 00       	call   419a <printf>
    337e:	83 c4 10             	add    $0x10,%esp
    exit();
    3381:	e8 85 0c 00 00       	call   400b <exit>
  }

  a = sbrk(0);
    3386:	83 ec 0c             	sub    $0xc,%esp
    3389:	6a 00                	push   $0x0
    338b:	e8 03 0d 00 00       	call   4093 <sbrk>
    3390:	83 c4 10             	add    $0x10,%esp
    3393:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-(sbrk(0) - oldbrk));
    3396:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    3399:	83 ec 0c             	sub    $0xc,%esp
    339c:	6a 00                	push   $0x0
    339e:	e8 f0 0c 00 00       	call   4093 <sbrk>
    33a3:	83 c4 10             	add    $0x10,%esp
    33a6:	29 c3                	sub    %eax,%ebx
    33a8:	89 d8                	mov    %ebx,%eax
    33aa:	83 ec 0c             	sub    $0xc,%esp
    33ad:	50                   	push   %eax
    33ae:	e8 e0 0c 00 00       	call   4093 <sbrk>
    33b3:	83 c4 10             	add    $0x10,%esp
    33b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a){
    33b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
    33bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    33bf:	74 1e                	je     33df <sbrktest+0x2df>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    33c1:	a1 ac 64 00 00       	mov    0x64ac,%eax
    33c6:	ff 75 e0             	pushl  -0x20(%ebp)
    33c9:	ff 75 f4             	pushl  -0xc(%ebp)
    33cc:	68 7c 5a 00 00       	push   $0x5a7c
    33d1:	50                   	push   %eax
    33d2:	e8 c3 0d 00 00       	call   419a <printf>
    33d7:	83 c4 10             	add    $0x10,%esp
    exit();
    33da:	e8 2c 0c 00 00       	call   400b <exit>
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    33df:	c7 45 f4 00 00 00 80 	movl   $0x80000000,-0xc(%ebp)
    33e6:	eb 78                	jmp    3460 <sbrktest+0x360>
    ppid = getpid();
    33e8:	e8 9e 0c 00 00       	call   408b <getpid>
    33ed:	89 45 d0             	mov    %eax,-0x30(%ebp)
    pid = fork();
    33f0:	e8 0e 0c 00 00       	call   4003 <fork>
    33f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pid < 0){
    33f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    33fc:	79 1b                	jns    3419 <sbrktest+0x319>
      printf(stdout, "fork failed\n");
    33fe:	a1 ac 64 00 00       	mov    0x64ac,%eax
    3403:	83 ec 08             	sub    $0x8,%esp
    3406:	68 f1 45 00 00       	push   $0x45f1
    340b:	50                   	push   %eax
    340c:	e8 89 0d 00 00       	call   419a <printf>
    3411:	83 c4 10             	add    $0x10,%esp
      exit();
    3414:	e8 f2 0b 00 00       	call   400b <exit>
    }
    if(pid == 0){
    3419:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    341d:	75 35                	jne    3454 <sbrktest+0x354>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    341f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3422:	0f b6 00             	movzbl (%eax),%eax
    3425:	0f be d0             	movsbl %al,%edx
    3428:	a1 ac 64 00 00       	mov    0x64ac,%eax
    342d:	52                   	push   %edx
    342e:	ff 75 f4             	pushl  -0xc(%ebp)
    3431:	68 9d 5a 00 00       	push   $0x5a9d
    3436:	50                   	push   %eax
    3437:	e8 5e 0d 00 00       	call   419a <printf>
    343c:	83 c4 10             	add    $0x10,%esp
      kill(ppid,SIGKILL);
    343f:	83 ec 08             	sub    $0x8,%esp
    3442:	6a 09                	push   $0x9
    3444:	ff 75 d0             	pushl  -0x30(%ebp)
    3447:	e8 ef 0b 00 00       	call   403b <kill>
    344c:	83 c4 10             	add    $0x10,%esp
      exit();
    344f:	e8 b7 0b 00 00       	call   400b <exit>
    }
    wait();
    3454:	e8 ba 0b 00 00       	call   4013 <wait>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    3459:	81 45 f4 50 c3 00 00 	addl   $0xc350,-0xc(%ebp)
    3460:	81 7d f4 7f 84 1e 80 	cmpl   $0x801e847f,-0xc(%ebp)
    3467:	0f 86 7b ff ff ff    	jbe    33e8 <sbrktest+0x2e8>
    wait();
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    346d:	83 ec 0c             	sub    $0xc,%esp
    3470:	8d 45 c8             	lea    -0x38(%ebp),%eax
    3473:	50                   	push   %eax
    3474:	e8 a2 0b 00 00       	call   401b <pipe>
    3479:	83 c4 10             	add    $0x10,%esp
    347c:	85 c0                	test   %eax,%eax
    347e:	74 17                	je     3497 <sbrktest+0x397>
    printf(1, "pipe() failed\n");
    3480:	83 ec 08             	sub    $0x8,%esp
    3483:	68 c2 49 00 00       	push   $0x49c2
    3488:	6a 01                	push   $0x1
    348a:	e8 0b 0d 00 00       	call   419a <printf>
    348f:	83 c4 10             	add    $0x10,%esp
    exit();
    3492:	e8 74 0b 00 00       	call   400b <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3497:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    349e:	e9 88 00 00 00       	jmp    352b <sbrktest+0x42b>
    if((pids[i] = fork()) == 0){
    34a3:	e8 5b 0b 00 00       	call   4003 <fork>
    34a8:	89 c2                	mov    %eax,%edx
    34aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
    34ad:	89 54 85 a0          	mov    %edx,-0x60(%ebp,%eax,4)
    34b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    34b4:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    34b8:	85 c0                	test   %eax,%eax
    34ba:	75 4a                	jne    3506 <sbrktest+0x406>
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    34bc:	83 ec 0c             	sub    $0xc,%esp
    34bf:	6a 00                	push   $0x0
    34c1:	e8 cd 0b 00 00       	call   4093 <sbrk>
    34c6:	83 c4 10             	add    $0x10,%esp
    34c9:	ba 00 00 40 06       	mov    $0x6400000,%edx
    34ce:	29 c2                	sub    %eax,%edx
    34d0:	89 d0                	mov    %edx,%eax
    34d2:	83 ec 0c             	sub    $0xc,%esp
    34d5:	50                   	push   %eax
    34d6:	e8 b8 0b 00 00       	call   4093 <sbrk>
    34db:	83 c4 10             	add    $0x10,%esp
      write(fds[1], "x", 1);
    34de:	8b 45 cc             	mov    -0x34(%ebp),%eax
    34e1:	83 ec 04             	sub    $0x4,%esp
    34e4:	6a 01                	push   $0x1
    34e6:	68 27 4a 00 00       	push   $0x4a27
    34eb:	50                   	push   %eax
    34ec:	e8 3a 0b 00 00       	call   402b <write>
    34f1:	83 c4 10             	add    $0x10,%esp
      // sit around until killed
      for(;;) sleep(1000);
    34f4:	83 ec 0c             	sub    $0xc,%esp
    34f7:	68 e8 03 00 00       	push   $0x3e8
    34fc:	e8 9a 0b 00 00       	call   409b <sleep>
    3501:	83 c4 10             	add    $0x10,%esp
    3504:	eb ee                	jmp    34f4 <sbrktest+0x3f4>
    }
    if(pids[i] != -1)
    3506:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3509:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    350d:	83 f8 ff             	cmp    $0xffffffff,%eax
    3510:	74 15                	je     3527 <sbrktest+0x427>
      read(fds[0], &scratch, 1);
    3512:	8b 45 c8             	mov    -0x38(%ebp),%eax
    3515:	83 ec 04             	sub    $0x4,%esp
    3518:	6a 01                	push   $0x1
    351a:	8d 55 9f             	lea    -0x61(%ebp),%edx
    351d:	52                   	push   %edx
    351e:	50                   	push   %eax
    351f:	e8 ff 0a 00 00       	call   4023 <read>
    3524:	83 c4 10             	add    $0x10,%esp
  // failed allocation?
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3527:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    352b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    352e:	83 f8 09             	cmp    $0x9,%eax
    3531:	0f 86 6c ff ff ff    	jbe    34a3 <sbrktest+0x3a3>
    if(pids[i] != -1)
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    3537:	83 ec 0c             	sub    $0xc,%esp
    353a:	68 00 10 00 00       	push   $0x1000
    353f:	e8 4f 0b 00 00       	call   4093 <sbrk>
    3544:	83 c4 10             	add    $0x10,%esp
    3547:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    354a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3551:	eb 2d                	jmp    3580 <sbrktest+0x480>
    if(pids[i] == -1)
    3553:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3556:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    355a:	83 f8 ff             	cmp    $0xffffffff,%eax
    355d:	74 1c                	je     357b <sbrktest+0x47b>
      continue;
    kill(pids[i],SIGKILL);
    355f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3562:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3566:	83 ec 08             	sub    $0x8,%esp
    3569:	6a 09                	push   $0x9
    356b:	50                   	push   %eax
    356c:	e8 ca 0a 00 00       	call   403b <kill>
    3571:	83 c4 10             	add    $0x10,%esp
    wait();
    3574:	e8 9a 0a 00 00       	call   4013 <wait>
    3579:	eb 01                	jmp    357c <sbrktest+0x47c>
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if(pids[i] == -1)
      continue;
    357b:	90                   	nop
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    357c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3580:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3583:	83 f8 09             	cmp    $0x9,%eax
    3586:	76 cb                	jbe    3553 <sbrktest+0x453>
    if(pids[i] == -1)
      continue;
    kill(pids[i],SIGKILL);
    wait();
  }
  if(c == (char*)0xffffffff){
    3588:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    358c:	75 1b                	jne    35a9 <sbrktest+0x4a9>
    printf(stdout, "failed sbrk leaked memory\n");
    358e:	a1 ac 64 00 00       	mov    0x64ac,%eax
    3593:	83 ec 08             	sub    $0x8,%esp
    3596:	68 b6 5a 00 00       	push   $0x5ab6
    359b:	50                   	push   %eax
    359c:	e8 f9 0b 00 00       	call   419a <printf>
    35a1:	83 c4 10             	add    $0x10,%esp
    exit();
    35a4:	e8 62 0a 00 00       	call   400b <exit>
  }

  if(sbrk(0) > oldbrk)
    35a9:	83 ec 0c             	sub    $0xc,%esp
    35ac:	6a 00                	push   $0x0
    35ae:	e8 e0 0a 00 00       	call   4093 <sbrk>
    35b3:	83 c4 10             	add    $0x10,%esp
    35b6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    35b9:	76 20                	jbe    35db <sbrktest+0x4db>
    sbrk(-(sbrk(0) - oldbrk));
    35bb:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    35be:	83 ec 0c             	sub    $0xc,%esp
    35c1:	6a 00                	push   $0x0
    35c3:	e8 cb 0a 00 00       	call   4093 <sbrk>
    35c8:	83 c4 10             	add    $0x10,%esp
    35cb:	29 c3                	sub    %eax,%ebx
    35cd:	89 d8                	mov    %ebx,%eax
    35cf:	83 ec 0c             	sub    $0xc,%esp
    35d2:	50                   	push   %eax
    35d3:	e8 bb 0a 00 00       	call   4093 <sbrk>
    35d8:	83 c4 10             	add    $0x10,%esp

  printf(stdout, "sbrk test OK\n");
    35db:	a1 ac 64 00 00       	mov    0x64ac,%eax
    35e0:	83 ec 08             	sub    $0x8,%esp
    35e3:	68 d1 5a 00 00       	push   $0x5ad1
    35e8:	50                   	push   %eax
    35e9:	e8 ac 0b 00 00       	call   419a <printf>
    35ee:	83 c4 10             	add    $0x10,%esp
}
    35f1:	90                   	nop
    35f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    35f5:	c9                   	leave  
    35f6:	c3                   	ret    

000035f7 <validateint>:

void
validateint(int *p)
{
    35f7:	55                   	push   %ebp
    35f8:	89 e5                	mov    %esp,%ebp
    35fa:	53                   	push   %ebx
    35fb:	83 ec 10             	sub    $0x10,%esp
  int res;
  asm("mov %%esp, %%ebx\n\t"
    35fe:	b8 0d 00 00 00       	mov    $0xd,%eax
    3603:	8b 55 08             	mov    0x8(%ebp),%edx
    3606:	89 d1                	mov    %edx,%ecx
    3608:	89 e3                	mov    %esp,%ebx
    360a:	89 cc                	mov    %ecx,%esp
    360c:	cd 40                	int    $0x40
    360e:	89 dc                	mov    %ebx,%esp
    3610:	89 45 f8             	mov    %eax,-0x8(%ebp)
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    3613:	90                   	nop
    3614:	83 c4 10             	add    $0x10,%esp
    3617:	5b                   	pop    %ebx
    3618:	5d                   	pop    %ebp
    3619:	c3                   	ret    

0000361a <validatetest>:

void
validatetest(void)
{
    361a:	55                   	push   %ebp
    361b:	89 e5                	mov    %esp,%ebp
    361d:	83 ec 18             	sub    $0x18,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    3620:	a1 ac 64 00 00       	mov    0x64ac,%eax
    3625:	83 ec 08             	sub    $0x8,%esp
    3628:	68 df 5a 00 00       	push   $0x5adf
    362d:	50                   	push   %eax
    362e:	e8 67 0b 00 00       	call   419a <printf>
    3633:	83 c4 10             	add    $0x10,%esp
  hi = 1100*1024;
    3636:	c7 45 f0 00 30 11 00 	movl   $0x113000,-0x10(%ebp)

  for(p = 0; p <= (uint)hi; p += 4096){
    363d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3644:	e9 8c 00 00 00       	jmp    36d5 <validatetest+0xbb>
    if((pid = fork()) == 0){
    3649:	e8 b5 09 00 00       	call   4003 <fork>
    364e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3651:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3655:	75 14                	jne    366b <validatetest+0x51>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
    3657:	8b 45 f4             	mov    -0xc(%ebp),%eax
    365a:	83 ec 0c             	sub    $0xc,%esp
    365d:	50                   	push   %eax
    365e:	e8 94 ff ff ff       	call   35f7 <validateint>
    3663:	83 c4 10             	add    $0x10,%esp
      exit();
    3666:	e8 a0 09 00 00       	call   400b <exit>
    }
    sleep(0);
    366b:	83 ec 0c             	sub    $0xc,%esp
    366e:	6a 00                	push   $0x0
    3670:	e8 26 0a 00 00       	call   409b <sleep>
    3675:	83 c4 10             	add    $0x10,%esp
    sleep(0);
    3678:	83 ec 0c             	sub    $0xc,%esp
    367b:	6a 00                	push   $0x0
    367d:	e8 19 0a 00 00       	call   409b <sleep>
    3682:	83 c4 10             	add    $0x10,%esp
    kill(pid,SIGKILL);
    3685:	83 ec 08             	sub    $0x8,%esp
    3688:	6a 09                	push   $0x9
    368a:	ff 75 ec             	pushl  -0x14(%ebp)
    368d:	e8 a9 09 00 00       	call   403b <kill>
    3692:	83 c4 10             	add    $0x10,%esp
    wait();
    3695:	e8 79 09 00 00       	call   4013 <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    369a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    369d:	83 ec 08             	sub    $0x8,%esp
    36a0:	50                   	push   %eax
    36a1:	68 ee 5a 00 00       	push   $0x5aee
    36a6:	e8 c0 09 00 00       	call   406b <link>
    36ab:	83 c4 10             	add    $0x10,%esp
    36ae:	83 f8 ff             	cmp    $0xffffffff,%eax
    36b1:	74 1b                	je     36ce <validatetest+0xb4>
      printf(stdout, "link should not succeed\n");
    36b3:	a1 ac 64 00 00       	mov    0x64ac,%eax
    36b8:	83 ec 08             	sub    $0x8,%esp
    36bb:	68 f9 5a 00 00       	push   $0x5af9
    36c0:	50                   	push   %eax
    36c1:	e8 d4 0a 00 00       	call   419a <printf>
    36c6:	83 c4 10             	add    $0x10,%esp
      exit();
    36c9:	e8 3d 09 00 00       	call   400b <exit>
  uint p;

  printf(stdout, "validate test\n");
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    36ce:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    36d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    36d8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    36db:	0f 86 68 ff ff ff    	jbe    3649 <validatetest+0x2f>
      printf(stdout, "link should not succeed\n");
      exit();
    }
  }

  printf(stdout, "validate ok\n");
    36e1:	a1 ac 64 00 00       	mov    0x64ac,%eax
    36e6:	83 ec 08             	sub    $0x8,%esp
    36e9:	68 12 5b 00 00       	push   $0x5b12
    36ee:	50                   	push   %eax
    36ef:	e8 a6 0a 00 00       	call   419a <printf>
    36f4:	83 c4 10             	add    $0x10,%esp
}
    36f7:	90                   	nop
    36f8:	c9                   	leave  
    36f9:	c3                   	ret    

000036fa <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    36fa:	55                   	push   %ebp
    36fb:	89 e5                	mov    %esp,%ebp
    36fd:	83 ec 18             	sub    $0x18,%esp
  int i;

  printf(stdout, "bss test\n");
    3700:	a1 ac 64 00 00       	mov    0x64ac,%eax
    3705:	83 ec 08             	sub    $0x8,%esp
    3708:	68 1f 5b 00 00       	push   $0x5b1f
    370d:	50                   	push   %eax
    370e:	e8 87 0a 00 00       	call   419a <printf>
    3713:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(uninit); i++){
    3716:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    371d:	eb 2e                	jmp    374d <bsstest+0x53>
    if(uninit[i] != '\0'){
    371f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3722:	05 80 65 00 00       	add    $0x6580,%eax
    3727:	0f b6 00             	movzbl (%eax),%eax
    372a:	84 c0                	test   %al,%al
    372c:	74 1b                	je     3749 <bsstest+0x4f>
      printf(stdout, "bss test failed\n");
    372e:	a1 ac 64 00 00       	mov    0x64ac,%eax
    3733:	83 ec 08             	sub    $0x8,%esp
    3736:	68 29 5b 00 00       	push   $0x5b29
    373b:	50                   	push   %eax
    373c:	e8 59 0a 00 00       	call   419a <printf>
    3741:	83 c4 10             	add    $0x10,%esp
      exit();
    3744:	e8 c2 08 00 00       	call   400b <exit>
bsstest(void)
{
  int i;

  printf(stdout, "bss test\n");
  for(i = 0; i < sizeof(uninit); i++){
    3749:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    374d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3750:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    3755:	76 c8                	jbe    371f <bsstest+0x25>
    if(uninit[i] != '\0'){
      printf(stdout, "bss test failed\n");
      exit();
    }
  }
  printf(stdout, "bss test ok\n");
    3757:	a1 ac 64 00 00       	mov    0x64ac,%eax
    375c:	83 ec 08             	sub    $0x8,%esp
    375f:	68 3a 5b 00 00       	push   $0x5b3a
    3764:	50                   	push   %eax
    3765:	e8 30 0a 00 00       	call   419a <printf>
    376a:	83 c4 10             	add    $0x10,%esp
}
    376d:	90                   	nop
    376e:	c9                   	leave  
    376f:	c3                   	ret    

00003770 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    3770:	55                   	push   %ebp
    3771:	89 e5                	mov    %esp,%ebp
    3773:	83 ec 18             	sub    $0x18,%esp
  int pid, fd;

  unlink("bigarg-ok");
    3776:	83 ec 0c             	sub    $0xc,%esp
    3779:	68 47 5b 00 00       	push   $0x5b47
    377e:	e8 d8 08 00 00       	call   405b <unlink>
    3783:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    3786:	e8 78 08 00 00       	call   4003 <fork>
    378b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    378e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3792:	0f 85 97 00 00 00    	jne    382f <bigargtest+0xbf>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    3798:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    379f:	eb 12                	jmp    37b3 <bigargtest+0x43>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    37a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    37a4:	c7 04 85 e0 64 00 00 	movl   $0x5b54,0x64e0(,%eax,4)
    37ab:	54 5b 00 00 
  unlink("bigarg-ok");
  pid = fork();
  if(pid == 0){
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    37af:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    37b3:	83 7d f4 1e          	cmpl   $0x1e,-0xc(%ebp)
    37b7:	7e e8                	jle    37a1 <bigargtest+0x31>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    args[MAXARG-1] = 0;
    37b9:	c7 05 5c 65 00 00 00 	movl   $0x0,0x655c
    37c0:	00 00 00 
    printf(stdout, "bigarg test\n");
    37c3:	a1 ac 64 00 00       	mov    0x64ac,%eax
    37c8:	83 ec 08             	sub    $0x8,%esp
    37cb:	68 31 5c 00 00       	push   $0x5c31
    37d0:	50                   	push   %eax
    37d1:	e8 c4 09 00 00       	call   419a <printf>
    37d6:	83 c4 10             	add    $0x10,%esp
    exec("echo", args);
    37d9:	83 ec 08             	sub    $0x8,%esp
    37dc:	68 e0 64 00 00       	push   $0x64e0
    37e1:	68 50 45 00 00       	push   $0x4550
    37e6:	e8 58 08 00 00       	call   4043 <exec>
    37eb:	83 c4 10             	add    $0x10,%esp
    printf(stdout, "bigarg test ok\n");
    37ee:	a1 ac 64 00 00       	mov    0x64ac,%eax
    37f3:	83 ec 08             	sub    $0x8,%esp
    37f6:	68 3e 5c 00 00       	push   $0x5c3e
    37fb:	50                   	push   %eax
    37fc:	e8 99 09 00 00       	call   419a <printf>
    3801:	83 c4 10             	add    $0x10,%esp
    fd = open("bigarg-ok", O_CREATE);
    3804:	83 ec 08             	sub    $0x8,%esp
    3807:	68 00 02 00 00       	push   $0x200
    380c:	68 47 5b 00 00       	push   $0x5b47
    3811:	e8 35 08 00 00       	call   404b <open>
    3816:	83 c4 10             	add    $0x10,%esp
    3819:	89 45 ec             	mov    %eax,-0x14(%ebp)
    close(fd);
    381c:	83 ec 0c             	sub    $0xc,%esp
    381f:	ff 75 ec             	pushl  -0x14(%ebp)
    3822:	e8 0c 08 00 00       	call   4033 <close>
    3827:	83 c4 10             	add    $0x10,%esp
    exit();
    382a:	e8 dc 07 00 00       	call   400b <exit>
  } else if(pid < 0){
    382f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3833:	79 1b                	jns    3850 <bigargtest+0xe0>
    printf(stdout, "bigargtest: fork failed\n");
    3835:	a1 ac 64 00 00       	mov    0x64ac,%eax
    383a:	83 ec 08             	sub    $0x8,%esp
    383d:	68 4e 5c 00 00       	push   $0x5c4e
    3842:	50                   	push   %eax
    3843:	e8 52 09 00 00       	call   419a <printf>
    3848:	83 c4 10             	add    $0x10,%esp
    exit();
    384b:	e8 bb 07 00 00       	call   400b <exit>
  }
  wait();
    3850:	e8 be 07 00 00       	call   4013 <wait>
  fd = open("bigarg-ok", 0);
    3855:	83 ec 08             	sub    $0x8,%esp
    3858:	6a 00                	push   $0x0
    385a:	68 47 5b 00 00       	push   $0x5b47
    385f:	e8 e7 07 00 00       	call   404b <open>
    3864:	83 c4 10             	add    $0x10,%esp
    3867:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    386a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    386e:	79 1b                	jns    388b <bigargtest+0x11b>
    printf(stdout, "bigarg test failed!\n");
    3870:	a1 ac 64 00 00       	mov    0x64ac,%eax
    3875:	83 ec 08             	sub    $0x8,%esp
    3878:	68 67 5c 00 00       	push   $0x5c67
    387d:	50                   	push   %eax
    387e:	e8 17 09 00 00       	call   419a <printf>
    3883:	83 c4 10             	add    $0x10,%esp
    exit();
    3886:	e8 80 07 00 00       	call   400b <exit>
  }
  close(fd);
    388b:	83 ec 0c             	sub    $0xc,%esp
    388e:	ff 75 ec             	pushl  -0x14(%ebp)
    3891:	e8 9d 07 00 00       	call   4033 <close>
    3896:	83 c4 10             	add    $0x10,%esp
  unlink("bigarg-ok");
    3899:	83 ec 0c             	sub    $0xc,%esp
    389c:	68 47 5b 00 00       	push   $0x5b47
    38a1:	e8 b5 07 00 00       	call   405b <unlink>
    38a6:	83 c4 10             	add    $0x10,%esp
}
    38a9:	90                   	nop
    38aa:	c9                   	leave  
    38ab:	c3                   	ret    

000038ac <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    38ac:	55                   	push   %ebp
    38ad:	89 e5                	mov    %esp,%ebp
    38af:	53                   	push   %ebx
    38b0:	83 ec 64             	sub    $0x64,%esp
  int nfiles;
  int fsblocks = 0;
    38b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  printf(1, "fsfull test\n");
    38ba:	83 ec 08             	sub    $0x8,%esp
    38bd:	68 7c 5c 00 00       	push   $0x5c7c
    38c2:	6a 01                	push   $0x1
    38c4:	e8 d1 08 00 00       	call   419a <printf>
    38c9:	83 c4 10             	add    $0x10,%esp

  for(nfiles = 0; ; nfiles++){
    38cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char name[64];
    name[0] = 'f';
    38d3:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    38d7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    38da:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    38df:	89 c8                	mov    %ecx,%eax
    38e1:	f7 ea                	imul   %edx
    38e3:	c1 fa 06             	sar    $0x6,%edx
    38e6:	89 c8                	mov    %ecx,%eax
    38e8:	c1 f8 1f             	sar    $0x1f,%eax
    38eb:	29 c2                	sub    %eax,%edx
    38ed:	89 d0                	mov    %edx,%eax
    38ef:	83 c0 30             	add    $0x30,%eax
    38f2:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    38f5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    38f8:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    38fd:	89 d8                	mov    %ebx,%eax
    38ff:	f7 ea                	imul   %edx
    3901:	c1 fa 06             	sar    $0x6,%edx
    3904:	89 d8                	mov    %ebx,%eax
    3906:	c1 f8 1f             	sar    $0x1f,%eax
    3909:	89 d1                	mov    %edx,%ecx
    390b:	29 c1                	sub    %eax,%ecx
    390d:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    3913:	29 c3                	sub    %eax,%ebx
    3915:	89 d9                	mov    %ebx,%ecx
    3917:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    391c:	89 c8                	mov    %ecx,%eax
    391e:	f7 ea                	imul   %edx
    3920:	c1 fa 05             	sar    $0x5,%edx
    3923:	89 c8                	mov    %ecx,%eax
    3925:	c1 f8 1f             	sar    $0x1f,%eax
    3928:	29 c2                	sub    %eax,%edx
    392a:	89 d0                	mov    %edx,%eax
    392c:	83 c0 30             	add    $0x30,%eax
    392f:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3932:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3935:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    393a:	89 d8                	mov    %ebx,%eax
    393c:	f7 ea                	imul   %edx
    393e:	c1 fa 05             	sar    $0x5,%edx
    3941:	89 d8                	mov    %ebx,%eax
    3943:	c1 f8 1f             	sar    $0x1f,%eax
    3946:	89 d1                	mov    %edx,%ecx
    3948:	29 c1                	sub    %eax,%ecx
    394a:	6b c1 64             	imul   $0x64,%ecx,%eax
    394d:	29 c3                	sub    %eax,%ebx
    394f:	89 d9                	mov    %ebx,%ecx
    3951:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3956:	89 c8                	mov    %ecx,%eax
    3958:	f7 ea                	imul   %edx
    395a:	c1 fa 02             	sar    $0x2,%edx
    395d:	89 c8                	mov    %ecx,%eax
    395f:	c1 f8 1f             	sar    $0x1f,%eax
    3962:	29 c2                	sub    %eax,%edx
    3964:	89 d0                	mov    %edx,%eax
    3966:	83 c0 30             	add    $0x30,%eax
    3969:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    396c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    396f:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3974:	89 c8                	mov    %ecx,%eax
    3976:	f7 ea                	imul   %edx
    3978:	c1 fa 02             	sar    $0x2,%edx
    397b:	89 c8                	mov    %ecx,%eax
    397d:	c1 f8 1f             	sar    $0x1f,%eax
    3980:	29 c2                	sub    %eax,%edx
    3982:	89 d0                	mov    %edx,%eax
    3984:	c1 e0 02             	shl    $0x2,%eax
    3987:	01 d0                	add    %edx,%eax
    3989:	01 c0                	add    %eax,%eax
    398b:	29 c1                	sub    %eax,%ecx
    398d:	89 ca                	mov    %ecx,%edx
    398f:	89 d0                	mov    %edx,%eax
    3991:	83 c0 30             	add    $0x30,%eax
    3994:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3997:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    printf(1, "writing %s\n", name);
    399b:	83 ec 04             	sub    $0x4,%esp
    399e:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    39a1:	50                   	push   %eax
    39a2:	68 89 5c 00 00       	push   $0x5c89
    39a7:	6a 01                	push   $0x1
    39a9:	e8 ec 07 00 00       	call   419a <printf>
    39ae:	83 c4 10             	add    $0x10,%esp
    int fd = open(name, O_CREATE|O_RDWR);
    39b1:	83 ec 08             	sub    $0x8,%esp
    39b4:	68 02 02 00 00       	push   $0x202
    39b9:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    39bc:	50                   	push   %eax
    39bd:	e8 89 06 00 00       	call   404b <open>
    39c2:	83 c4 10             	add    $0x10,%esp
    39c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(fd < 0){
    39c8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    39cc:	79 18                	jns    39e6 <fsfull+0x13a>
      printf(1, "open %s failed\n", name);
    39ce:	83 ec 04             	sub    $0x4,%esp
    39d1:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    39d4:	50                   	push   %eax
    39d5:	68 95 5c 00 00       	push   $0x5c95
    39da:	6a 01                	push   $0x1
    39dc:	e8 b9 07 00 00       	call   419a <printf>
    39e1:	83 c4 10             	add    $0x10,%esp
      break;
    39e4:	eb 6b                	jmp    3a51 <fsfull+0x1a5>
    }
    int total = 0;
    39e6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while(1){
      int cc = write(fd, buf, 512);
    39ed:	83 ec 04             	sub    $0x4,%esp
    39f0:	68 00 02 00 00       	push   $0x200
    39f5:	68 a0 8c 00 00       	push   $0x8ca0
    39fa:	ff 75 e8             	pushl  -0x18(%ebp)
    39fd:	e8 29 06 00 00       	call   402b <write>
    3a02:	83 c4 10             	add    $0x10,%esp
    3a05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(cc < 512)
    3a08:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%ebp)
    3a0f:	7e 0c                	jle    3a1d <fsfull+0x171>
        break;
      total += cc;
    3a11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3a14:	01 45 ec             	add    %eax,-0x14(%ebp)
      fsblocks++;
    3a17:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    }
    3a1b:	eb d0                	jmp    39ed <fsfull+0x141>
    }
    int total = 0;
    while(1){
      int cc = write(fd, buf, 512);
      if(cc < 512)
        break;
    3a1d:	90                   	nop
      total += cc;
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
    3a1e:	83 ec 04             	sub    $0x4,%esp
    3a21:	ff 75 ec             	pushl  -0x14(%ebp)
    3a24:	68 a5 5c 00 00       	push   $0x5ca5
    3a29:	6a 01                	push   $0x1
    3a2b:	e8 6a 07 00 00       	call   419a <printf>
    3a30:	83 c4 10             	add    $0x10,%esp
    close(fd);
    3a33:	83 ec 0c             	sub    $0xc,%esp
    3a36:	ff 75 e8             	pushl  -0x18(%ebp)
    3a39:	e8 f5 05 00 00       	call   4033 <close>
    3a3e:	83 c4 10             	add    $0x10,%esp
    if(total == 0)
    3a41:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3a45:	74 09                	je     3a50 <fsfull+0x1a4>
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    3a47:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
  }
    3a4b:	e9 83 fe ff ff       	jmp    38d3 <fsfull+0x27>
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
    3a50:	90                   	nop
  }

  while(nfiles >= 0){
    3a51:	e9 db 00 00 00       	jmp    3b31 <fsfull+0x285>
    char name[64];
    name[0] = 'f';
    3a56:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    3a5a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3a5d:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3a62:	89 c8                	mov    %ecx,%eax
    3a64:	f7 ea                	imul   %edx
    3a66:	c1 fa 06             	sar    $0x6,%edx
    3a69:	89 c8                	mov    %ecx,%eax
    3a6b:	c1 f8 1f             	sar    $0x1f,%eax
    3a6e:	29 c2                	sub    %eax,%edx
    3a70:	89 d0                	mov    %edx,%eax
    3a72:	83 c0 30             	add    $0x30,%eax
    3a75:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3a78:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3a7b:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3a80:	89 d8                	mov    %ebx,%eax
    3a82:	f7 ea                	imul   %edx
    3a84:	c1 fa 06             	sar    $0x6,%edx
    3a87:	89 d8                	mov    %ebx,%eax
    3a89:	c1 f8 1f             	sar    $0x1f,%eax
    3a8c:	89 d1                	mov    %edx,%ecx
    3a8e:	29 c1                	sub    %eax,%ecx
    3a90:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    3a96:	29 c3                	sub    %eax,%ebx
    3a98:	89 d9                	mov    %ebx,%ecx
    3a9a:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3a9f:	89 c8                	mov    %ecx,%eax
    3aa1:	f7 ea                	imul   %edx
    3aa3:	c1 fa 05             	sar    $0x5,%edx
    3aa6:	89 c8                	mov    %ecx,%eax
    3aa8:	c1 f8 1f             	sar    $0x1f,%eax
    3aab:	29 c2                	sub    %eax,%edx
    3aad:	89 d0                	mov    %edx,%eax
    3aaf:	83 c0 30             	add    $0x30,%eax
    3ab2:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3ab5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3ab8:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3abd:	89 d8                	mov    %ebx,%eax
    3abf:	f7 ea                	imul   %edx
    3ac1:	c1 fa 05             	sar    $0x5,%edx
    3ac4:	89 d8                	mov    %ebx,%eax
    3ac6:	c1 f8 1f             	sar    $0x1f,%eax
    3ac9:	89 d1                	mov    %edx,%ecx
    3acb:	29 c1                	sub    %eax,%ecx
    3acd:	6b c1 64             	imul   $0x64,%ecx,%eax
    3ad0:	29 c3                	sub    %eax,%ebx
    3ad2:	89 d9                	mov    %ebx,%ecx
    3ad4:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3ad9:	89 c8                	mov    %ecx,%eax
    3adb:	f7 ea                	imul   %edx
    3add:	c1 fa 02             	sar    $0x2,%edx
    3ae0:	89 c8                	mov    %ecx,%eax
    3ae2:	c1 f8 1f             	sar    $0x1f,%eax
    3ae5:	29 c2                	sub    %eax,%edx
    3ae7:	89 d0                	mov    %edx,%eax
    3ae9:	83 c0 30             	add    $0x30,%eax
    3aec:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3aef:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3af2:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3af7:	89 c8                	mov    %ecx,%eax
    3af9:	f7 ea                	imul   %edx
    3afb:	c1 fa 02             	sar    $0x2,%edx
    3afe:	89 c8                	mov    %ecx,%eax
    3b00:	c1 f8 1f             	sar    $0x1f,%eax
    3b03:	29 c2                	sub    %eax,%edx
    3b05:	89 d0                	mov    %edx,%eax
    3b07:	c1 e0 02             	shl    $0x2,%eax
    3b0a:	01 d0                	add    %edx,%eax
    3b0c:	01 c0                	add    %eax,%eax
    3b0e:	29 c1                	sub    %eax,%ecx
    3b10:	89 ca                	mov    %ecx,%edx
    3b12:	89 d0                	mov    %edx,%eax
    3b14:	83 c0 30             	add    $0x30,%eax
    3b17:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3b1a:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    unlink(name);
    3b1e:	83 ec 0c             	sub    $0xc,%esp
    3b21:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3b24:	50                   	push   %eax
    3b25:	e8 31 05 00 00       	call   405b <unlink>
    3b2a:	83 c4 10             	add    $0x10,%esp
    nfiles--;
    3b2d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    3b31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3b35:	0f 89 1b ff ff ff    	jns    3a56 <fsfull+0x1aa>
    name[5] = '\0';
    unlink(name);
    nfiles--;
  }

  printf(1, "fsfull test finished\n");
    3b3b:	83 ec 08             	sub    $0x8,%esp
    3b3e:	68 b5 5c 00 00       	push   $0x5cb5
    3b43:	6a 01                	push   $0x1
    3b45:	e8 50 06 00 00       	call   419a <printf>
    3b4a:	83 c4 10             	add    $0x10,%esp
}
    3b4d:	90                   	nop
    3b4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3b51:	c9                   	leave  
    3b52:	c3                   	ret    

00003b53 <uio>:

void
uio()
{
    3b53:	55                   	push   %ebp
    3b54:	89 e5                	mov    %esp,%ebp
    3b56:	83 ec 18             	sub    $0x18,%esp
  #define RTC_ADDR 0x70
  #define RTC_DATA 0x71

  ushort port = 0;
    3b59:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
  uchar val = 0;
    3b5f:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
  int pid;

  printf(1, "uio test\n");
    3b63:	83 ec 08             	sub    $0x8,%esp
    3b66:	68 cb 5c 00 00       	push   $0x5ccb
    3b6b:	6a 01                	push   $0x1
    3b6d:	e8 28 06 00 00       	call   419a <printf>
    3b72:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    3b75:	e8 89 04 00 00       	call   4003 <fork>
    3b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    3b7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3b81:	75 3a                	jne    3bbd <uio+0x6a>
    port = RTC_ADDR;
    3b83:	66 c7 45 f6 70 00    	movw   $0x70,-0xa(%ebp)
    val = 0x09;  /* year */
    3b89:	c6 45 f5 09          	movb   $0x9,-0xb(%ebp)
    /* http://wiki.osdev.org/Inline_Assembly/Examples */
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    3b8d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    3b91:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
    3b95:	ee                   	out    %al,(%dx)
    port = RTC_DATA;
    3b96:	66 c7 45 f6 71 00    	movw   $0x71,-0xa(%ebp)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    3b9c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    3ba0:	89 c2                	mov    %eax,%edx
    3ba2:	ec                   	in     (%dx),%al
    3ba3:	88 45 f5             	mov    %al,-0xb(%ebp)
    printf(1, "uio: uio succeeded; test FAILED\n");
    3ba6:	83 ec 08             	sub    $0x8,%esp
    3ba9:	68 d8 5c 00 00       	push   $0x5cd8
    3bae:	6a 01                	push   $0x1
    3bb0:	e8 e5 05 00 00       	call   419a <printf>
    3bb5:	83 c4 10             	add    $0x10,%esp
    exit();
    3bb8:	e8 4e 04 00 00       	call   400b <exit>
  } else if(pid < 0){
    3bbd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3bc1:	79 17                	jns    3bda <uio+0x87>
    printf (1, "fork failed\n");
    3bc3:	83 ec 08             	sub    $0x8,%esp
    3bc6:	68 f1 45 00 00       	push   $0x45f1
    3bcb:	6a 01                	push   $0x1
    3bcd:	e8 c8 05 00 00       	call   419a <printf>
    3bd2:	83 c4 10             	add    $0x10,%esp
    exit();
    3bd5:	e8 31 04 00 00       	call   400b <exit>
  }
  wait();
    3bda:	e8 34 04 00 00       	call   4013 <wait>
  printf(1, "uio test done\n");
    3bdf:	83 ec 08             	sub    $0x8,%esp
    3be2:	68 f9 5c 00 00       	push   $0x5cf9
    3be7:	6a 01                	push   $0x1
    3be9:	e8 ac 05 00 00       	call   419a <printf>
    3bee:	83 c4 10             	add    $0x10,%esp
}
    3bf1:	90                   	nop
    3bf2:	c9                   	leave  
    3bf3:	c3                   	ret    

00003bf4 <argptest>:

void argptest()
{
    3bf4:	55                   	push   %ebp
    3bf5:	89 e5                	mov    %esp,%ebp
    3bf7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  fd = open("init", O_RDONLY);
    3bfa:	83 ec 08             	sub    $0x8,%esp
    3bfd:	6a 00                	push   $0x0
    3bff:	68 08 5d 00 00       	push   $0x5d08
    3c04:	e8 42 04 00 00       	call   404b <open>
    3c09:	83 c4 10             	add    $0x10,%esp
    3c0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (fd < 0) {
    3c0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3c13:	79 17                	jns    3c2c <argptest+0x38>
    printf(2, "open failed\n");
    3c15:	83 ec 08             	sub    $0x8,%esp
    3c18:	68 0d 5d 00 00       	push   $0x5d0d
    3c1d:	6a 02                	push   $0x2
    3c1f:	e8 76 05 00 00       	call   419a <printf>
    3c24:	83 c4 10             	add    $0x10,%esp
    exit();
    3c27:	e8 df 03 00 00       	call   400b <exit>
  }
  read(fd, sbrk(0) - 1, -1);
    3c2c:	83 ec 0c             	sub    $0xc,%esp
    3c2f:	6a 00                	push   $0x0
    3c31:	e8 5d 04 00 00       	call   4093 <sbrk>
    3c36:	83 c4 10             	add    $0x10,%esp
    3c39:	83 e8 01             	sub    $0x1,%eax
    3c3c:	83 ec 04             	sub    $0x4,%esp
    3c3f:	6a ff                	push   $0xffffffff
    3c41:	50                   	push   %eax
    3c42:	ff 75 f4             	pushl  -0xc(%ebp)
    3c45:	e8 d9 03 00 00       	call   4023 <read>
    3c4a:	83 c4 10             	add    $0x10,%esp
  close(fd);
    3c4d:	83 ec 0c             	sub    $0xc,%esp
    3c50:	ff 75 f4             	pushl  -0xc(%ebp)
    3c53:	e8 db 03 00 00       	call   4033 <close>
    3c58:	83 c4 10             	add    $0x10,%esp
  printf(1, "arg test passed\n");
    3c5b:	83 ec 08             	sub    $0x8,%esp
    3c5e:	68 1a 5d 00 00       	push   $0x5d1a
    3c63:	6a 01                	push   $0x1
    3c65:	e8 30 05 00 00       	call   419a <printf>
    3c6a:	83 c4 10             	add    $0x10,%esp
}
    3c6d:	90                   	nop
    3c6e:	c9                   	leave  
    3c6f:	c3                   	ret    

00003c70 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    3c70:	55                   	push   %ebp
    3c71:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    3c73:	a1 b0 64 00 00       	mov    0x64b0,%eax
    3c78:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    3c7e:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    3c83:	a3 b0 64 00 00       	mov    %eax,0x64b0
  return randstate;
    3c88:	a1 b0 64 00 00       	mov    0x64b0,%eax
}
    3c8d:	5d                   	pop    %ebp
    3c8e:	c3                   	ret    

00003c8f <main>:

int
main(int argc, char *argv[])
{
    3c8f:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    3c93:	83 e4 f0             	and    $0xfffffff0,%esp
    3c96:	ff 71 fc             	pushl  -0x4(%ecx)
    3c99:	55                   	push   %ebp
    3c9a:	89 e5                	mov    %esp,%ebp
    3c9c:	51                   	push   %ecx
    3c9d:	83 ec 04             	sub    $0x4,%esp
  printf(1, "usertests starting\n");
    3ca0:	83 ec 08             	sub    $0x8,%esp
    3ca3:	68 2b 5d 00 00       	push   $0x5d2b
    3ca8:	6a 01                	push   $0x1
    3caa:	e8 eb 04 00 00       	call   419a <printf>
    3caf:	83 c4 10             	add    $0x10,%esp

  if(open("usertests.ran", 0) >= 0){
    3cb2:	83 ec 08             	sub    $0x8,%esp
    3cb5:	6a 00                	push   $0x0
    3cb7:	68 3f 5d 00 00       	push   $0x5d3f
    3cbc:	e8 8a 03 00 00       	call   404b <open>
    3cc1:	83 c4 10             	add    $0x10,%esp
    3cc4:	85 c0                	test   %eax,%eax
    3cc6:	78 17                	js     3cdf <main+0x50>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    3cc8:	83 ec 08             	sub    $0x8,%esp
    3ccb:	68 50 5d 00 00       	push   $0x5d50
    3cd0:	6a 01                	push   $0x1
    3cd2:	e8 c3 04 00 00       	call   419a <printf>
    3cd7:	83 c4 10             	add    $0x10,%esp
    exit();
    3cda:	e8 2c 03 00 00       	call   400b <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3cdf:	83 ec 08             	sub    $0x8,%esp
    3ce2:	68 00 02 00 00       	push   $0x200
    3ce7:	68 3f 5d 00 00       	push   $0x5d3f
    3cec:	e8 5a 03 00 00       	call   404b <open>
    3cf1:	83 c4 10             	add    $0x10,%esp
    3cf4:	83 ec 0c             	sub    $0xc,%esp
    3cf7:	50                   	push   %eax
    3cf8:	e8 36 03 00 00       	call   4033 <close>
    3cfd:	83 c4 10             	add    $0x10,%esp

  argptest();
    3d00:	e8 ef fe ff ff       	call   3bf4 <argptest>
  createdelete();
    3d05:	e8 ab d5 ff ff       	call   12b5 <createdelete>
  linkunlink();
    3d0a:	e8 cc df ff ff       	call   1cdb <linkunlink>
  concreate();
    3d0f:	e8 17 dc ff ff       	call   192b <concreate>
  fourfiles();
    3d14:	e8 4b d3 ff ff       	call   1064 <fourfiles>
  sharedfd();
    3d19:	e8 63 d1 ff ff       	call   e81 <sharedfd>

  bigargtest();
    3d1e:	e8 4d fa ff ff       	call   3770 <bigargtest>
  bigwrite();
    3d23:	e8 a5 e9 ff ff       	call   26cd <bigwrite>
  bigargtest();
    3d28:	e8 43 fa ff ff       	call   3770 <bigargtest>
  bsstest();
    3d2d:	e8 c8 f9 ff ff       	call   36fa <bsstest>
  sbrktest();
    3d32:	e8 c9 f3 ff ff       	call   3100 <sbrktest>
  validatetest();
    3d37:	e8 de f8 ff ff       	call   361a <validatetest>

  opentest();
    3d3c:	e8 be c5 ff ff       	call   2ff <opentest>
  writetest();
    3d41:	e8 68 c6 ff ff       	call   3ae <writetest>
  writetest1();
    3d46:	e8 73 c8 ff ff       	call   5be <writetest1>
  createtest();
    3d4b:	e8 6a ca ff ff       	call   7ba <createtest>

  openiputtest();
    3d50:	e8 9b c4 ff ff       	call   1f0 <openiputtest>
  exitiputtest();
    3d55:	e8 97 c3 ff ff       	call   f1 <exitiputtest>
  iputtest();
    3d5a:	e8 a1 c2 ff ff       	call   0 <iputtest>

  mem();
    3d5f:	e8 2a d0 ff ff       	call   d8e <mem>
  pipe1();
    3d64:	e8 58 cc ff ff       	call   9c1 <pipe1>
  preempt();
    3d69:	e8 3c ce ff ff       	call   baa <preempt>
  exitwait();
    3d6e:	e8 a3 cf ff ff       	call   d16 <exitwait>

  rmdot();
    3d73:	e8 c7 ed ff ff       	call   2b3f <rmdot>
  fourteen();
    3d78:	e8 66 ec ff ff       	call   29e3 <fourteen>
  bigfile();
    3d7d:	e8 49 ea ff ff       	call   27cb <bigfile>
  subdir();
    3d82:	e8 02 e2 ff ff       	call   1f89 <subdir>
  linktest();
    3d87:	e8 5d d9 ff ff       	call   16e9 <linktest>
  unlinkread();
    3d8c:	e8 96 d7 ff ff       	call   1527 <unlinkread>
  dirfile();
    3d91:	e8 2e ef ff ff       	call   2cc4 <dirfile>
  iref();
    3d96:	e8 61 f1 ff ff       	call   2efc <iref>
  forktest();
    3d9b:	e8 96 f2 ff ff       	call   3036 <forktest>
  bigdir(); // slow
    3da0:	e8 6f e0 ff ff       	call   1e14 <bigdir>

  uio();
    3da5:	e8 a9 fd ff ff       	call   3b53 <uio>

  exectest();
    3daa:	e8 bf cb ff ff       	call   96e <exectest>

  exit();
    3daf:	e8 57 02 00 00       	call   400b <exit>

00003db4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    3db4:	55                   	push   %ebp
    3db5:	89 e5                	mov    %esp,%ebp
    3db7:	57                   	push   %edi
    3db8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    3db9:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3dbc:	8b 55 10             	mov    0x10(%ebp),%edx
    3dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
    3dc2:	89 cb                	mov    %ecx,%ebx
    3dc4:	89 df                	mov    %ebx,%edi
    3dc6:	89 d1                	mov    %edx,%ecx
    3dc8:	fc                   	cld    
    3dc9:	f3 aa                	rep stos %al,%es:(%edi)
    3dcb:	89 ca                	mov    %ecx,%edx
    3dcd:	89 fb                	mov    %edi,%ebx
    3dcf:	89 5d 08             	mov    %ebx,0x8(%ebp)
    3dd2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    3dd5:	90                   	nop
    3dd6:	5b                   	pop    %ebx
    3dd7:	5f                   	pop    %edi
    3dd8:	5d                   	pop    %ebp
    3dd9:	c3                   	ret    

00003dda <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    3dda:	55                   	push   %ebp
    3ddb:	89 e5                	mov    %esp,%ebp
    3ddd:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    3de0:	8b 45 08             	mov    0x8(%ebp),%eax
    3de3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    3de6:	90                   	nop
    3de7:	8b 45 08             	mov    0x8(%ebp),%eax
    3dea:	8d 50 01             	lea    0x1(%eax),%edx
    3ded:	89 55 08             	mov    %edx,0x8(%ebp)
    3df0:	8b 55 0c             	mov    0xc(%ebp),%edx
    3df3:	8d 4a 01             	lea    0x1(%edx),%ecx
    3df6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    3df9:	0f b6 12             	movzbl (%edx),%edx
    3dfc:	88 10                	mov    %dl,(%eax)
    3dfe:	0f b6 00             	movzbl (%eax),%eax
    3e01:	84 c0                	test   %al,%al
    3e03:	75 e2                	jne    3de7 <strcpy+0xd>
    ;
  return os;
    3e05:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3e08:	c9                   	leave  
    3e09:	c3                   	ret    

00003e0a <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3e0a:	55                   	push   %ebp
    3e0b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    3e0d:	eb 08                	jmp    3e17 <strcmp+0xd>
    p++, q++;
    3e0f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3e13:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    3e17:	8b 45 08             	mov    0x8(%ebp),%eax
    3e1a:	0f b6 00             	movzbl (%eax),%eax
    3e1d:	84 c0                	test   %al,%al
    3e1f:	74 10                	je     3e31 <strcmp+0x27>
    3e21:	8b 45 08             	mov    0x8(%ebp),%eax
    3e24:	0f b6 10             	movzbl (%eax),%edx
    3e27:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e2a:	0f b6 00             	movzbl (%eax),%eax
    3e2d:	38 c2                	cmp    %al,%dl
    3e2f:	74 de                	je     3e0f <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    3e31:	8b 45 08             	mov    0x8(%ebp),%eax
    3e34:	0f b6 00             	movzbl (%eax),%eax
    3e37:	0f b6 d0             	movzbl %al,%edx
    3e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e3d:	0f b6 00             	movzbl (%eax),%eax
    3e40:	0f b6 c0             	movzbl %al,%eax
    3e43:	29 c2                	sub    %eax,%edx
    3e45:	89 d0                	mov    %edx,%eax
}
    3e47:	5d                   	pop    %ebp
    3e48:	c3                   	ret    

00003e49 <strlen>:

uint
strlen(char *s)
{
    3e49:	55                   	push   %ebp
    3e4a:	89 e5                	mov    %esp,%ebp
    3e4c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    3e4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    3e56:	eb 04                	jmp    3e5c <strlen+0x13>
    3e58:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    3e5c:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3e5f:	8b 45 08             	mov    0x8(%ebp),%eax
    3e62:	01 d0                	add    %edx,%eax
    3e64:	0f b6 00             	movzbl (%eax),%eax
    3e67:	84 c0                	test   %al,%al
    3e69:	75 ed                	jne    3e58 <strlen+0xf>
    ;
  return n;
    3e6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3e6e:	c9                   	leave  
    3e6f:	c3                   	ret    

00003e70 <memset>:

void*
memset(void *dst, int c, uint n)
{
    3e70:	55                   	push   %ebp
    3e71:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    3e73:	8b 45 10             	mov    0x10(%ebp),%eax
    3e76:	50                   	push   %eax
    3e77:	ff 75 0c             	pushl  0xc(%ebp)
    3e7a:	ff 75 08             	pushl  0x8(%ebp)
    3e7d:	e8 32 ff ff ff       	call   3db4 <stosb>
    3e82:	83 c4 0c             	add    $0xc,%esp
  return dst;
    3e85:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3e88:	c9                   	leave  
    3e89:	c3                   	ret    

00003e8a <strchr>:

char*
strchr(const char *s, char c)
{
    3e8a:	55                   	push   %ebp
    3e8b:	89 e5                	mov    %esp,%ebp
    3e8d:	83 ec 04             	sub    $0x4,%esp
    3e90:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e93:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    3e96:	eb 14                	jmp    3eac <strchr+0x22>
    if(*s == c)
    3e98:	8b 45 08             	mov    0x8(%ebp),%eax
    3e9b:	0f b6 00             	movzbl (%eax),%eax
    3e9e:	3a 45 fc             	cmp    -0x4(%ebp),%al
    3ea1:	75 05                	jne    3ea8 <strchr+0x1e>
      return (char*)s;
    3ea3:	8b 45 08             	mov    0x8(%ebp),%eax
    3ea6:	eb 13                	jmp    3ebb <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    3ea8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3eac:	8b 45 08             	mov    0x8(%ebp),%eax
    3eaf:	0f b6 00             	movzbl (%eax),%eax
    3eb2:	84 c0                	test   %al,%al
    3eb4:	75 e2                	jne    3e98 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    3eb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3ebb:	c9                   	leave  
    3ebc:	c3                   	ret    

00003ebd <gets>:

char*
gets(char *buf, int max)
{
    3ebd:	55                   	push   %ebp
    3ebe:	89 e5                	mov    %esp,%ebp
    3ec0:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3ec3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3eca:	eb 42                	jmp    3f0e <gets+0x51>
    cc = read(0, &c, 1);
    3ecc:	83 ec 04             	sub    $0x4,%esp
    3ecf:	6a 01                	push   $0x1
    3ed1:	8d 45 ef             	lea    -0x11(%ebp),%eax
    3ed4:	50                   	push   %eax
    3ed5:	6a 00                	push   $0x0
    3ed7:	e8 47 01 00 00       	call   4023 <read>
    3edc:	83 c4 10             	add    $0x10,%esp
    3edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    3ee2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3ee6:	7e 33                	jle    3f1b <gets+0x5e>
      break;
    buf[i++] = c;
    3ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3eeb:	8d 50 01             	lea    0x1(%eax),%edx
    3eee:	89 55 f4             	mov    %edx,-0xc(%ebp)
    3ef1:	89 c2                	mov    %eax,%edx
    3ef3:	8b 45 08             	mov    0x8(%ebp),%eax
    3ef6:	01 c2                	add    %eax,%edx
    3ef8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3efc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    3efe:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3f02:	3c 0a                	cmp    $0xa,%al
    3f04:	74 16                	je     3f1c <gets+0x5f>
    3f06:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3f0a:	3c 0d                	cmp    $0xd,%al
    3f0c:	74 0e                	je     3f1c <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3f11:	83 c0 01             	add    $0x1,%eax
    3f14:	3b 45 0c             	cmp    0xc(%ebp),%eax
    3f17:	7c b3                	jl     3ecc <gets+0xf>
    3f19:	eb 01                	jmp    3f1c <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    3f1b:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    3f1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3f1f:	8b 45 08             	mov    0x8(%ebp),%eax
    3f22:	01 d0                	add    %edx,%eax
    3f24:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    3f27:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3f2a:	c9                   	leave  
    3f2b:	c3                   	ret    

00003f2c <stat>:

int
stat(char *n, struct stat *st)
{
    3f2c:	55                   	push   %ebp
    3f2d:	89 e5                	mov    %esp,%ebp
    3f2f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3f32:	83 ec 08             	sub    $0x8,%esp
    3f35:	6a 00                	push   $0x0
    3f37:	ff 75 08             	pushl  0x8(%ebp)
    3f3a:	e8 0c 01 00 00       	call   404b <open>
    3f3f:	83 c4 10             	add    $0x10,%esp
    3f42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    3f45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3f49:	79 07                	jns    3f52 <stat+0x26>
    return -1;
    3f4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    3f50:	eb 25                	jmp    3f77 <stat+0x4b>
  r = fstat(fd, st);
    3f52:	83 ec 08             	sub    $0x8,%esp
    3f55:	ff 75 0c             	pushl  0xc(%ebp)
    3f58:	ff 75 f4             	pushl  -0xc(%ebp)
    3f5b:	e8 03 01 00 00       	call   4063 <fstat>
    3f60:	83 c4 10             	add    $0x10,%esp
    3f63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    3f66:	83 ec 0c             	sub    $0xc,%esp
    3f69:	ff 75 f4             	pushl  -0xc(%ebp)
    3f6c:	e8 c2 00 00 00       	call   4033 <close>
    3f71:	83 c4 10             	add    $0x10,%esp
  return r;
    3f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    3f77:	c9                   	leave  
    3f78:	c3                   	ret    

00003f79 <atoi>:

int
atoi(const char *s)
{
    3f79:	55                   	push   %ebp
    3f7a:	89 e5                	mov    %esp,%ebp
    3f7c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    3f7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    3f86:	eb 25                	jmp    3fad <atoi+0x34>
    n = n*10 + *s++ - '0';
    3f88:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3f8b:	89 d0                	mov    %edx,%eax
    3f8d:	c1 e0 02             	shl    $0x2,%eax
    3f90:	01 d0                	add    %edx,%eax
    3f92:	01 c0                	add    %eax,%eax
    3f94:	89 c1                	mov    %eax,%ecx
    3f96:	8b 45 08             	mov    0x8(%ebp),%eax
    3f99:	8d 50 01             	lea    0x1(%eax),%edx
    3f9c:	89 55 08             	mov    %edx,0x8(%ebp)
    3f9f:	0f b6 00             	movzbl (%eax),%eax
    3fa2:	0f be c0             	movsbl %al,%eax
    3fa5:	01 c8                	add    %ecx,%eax
    3fa7:	83 e8 30             	sub    $0x30,%eax
    3faa:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    3fad:	8b 45 08             	mov    0x8(%ebp),%eax
    3fb0:	0f b6 00             	movzbl (%eax),%eax
    3fb3:	3c 2f                	cmp    $0x2f,%al
    3fb5:	7e 0a                	jle    3fc1 <atoi+0x48>
    3fb7:	8b 45 08             	mov    0x8(%ebp),%eax
    3fba:	0f b6 00             	movzbl (%eax),%eax
    3fbd:	3c 39                	cmp    $0x39,%al
    3fbf:	7e c7                	jle    3f88 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    3fc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3fc4:	c9                   	leave  
    3fc5:	c3                   	ret    

00003fc6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    3fc6:	55                   	push   %ebp
    3fc7:	89 e5                	mov    %esp,%ebp
    3fc9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    3fcc:	8b 45 08             	mov    0x8(%ebp),%eax
    3fcf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    3fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
    3fd5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    3fd8:	eb 17                	jmp    3ff1 <memmove+0x2b>
    *dst++ = *src++;
    3fda:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fdd:	8d 50 01             	lea    0x1(%eax),%edx
    3fe0:	89 55 fc             	mov    %edx,-0x4(%ebp)
    3fe3:	8b 55 f8             	mov    -0x8(%ebp),%edx
    3fe6:	8d 4a 01             	lea    0x1(%edx),%ecx
    3fe9:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    3fec:	0f b6 12             	movzbl (%edx),%edx
    3fef:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    3ff1:	8b 45 10             	mov    0x10(%ebp),%eax
    3ff4:	8d 50 ff             	lea    -0x1(%eax),%edx
    3ff7:	89 55 10             	mov    %edx,0x10(%ebp)
    3ffa:	85 c0                	test   %eax,%eax
    3ffc:	7f dc                	jg     3fda <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    3ffe:	8b 45 08             	mov    0x8(%ebp),%eax
}
    4001:	c9                   	leave  
    4002:	c3                   	ret    

00004003 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    4003:	b8 01 00 00 00       	mov    $0x1,%eax
    4008:	cd 40                	int    $0x40
    400a:	c3                   	ret    

0000400b <exit>:
SYSCALL(exit)
    400b:	b8 02 00 00 00       	mov    $0x2,%eax
    4010:	cd 40                	int    $0x40
    4012:	c3                   	ret    

00004013 <wait>:
SYSCALL(wait)
    4013:	b8 03 00 00 00       	mov    $0x3,%eax
    4018:	cd 40                	int    $0x40
    401a:	c3                   	ret    

0000401b <pipe>:
SYSCALL(pipe)
    401b:	b8 04 00 00 00       	mov    $0x4,%eax
    4020:	cd 40                	int    $0x40
    4022:	c3                   	ret    

00004023 <read>:
SYSCALL(read)
    4023:	b8 05 00 00 00       	mov    $0x5,%eax
    4028:	cd 40                	int    $0x40
    402a:	c3                   	ret    

0000402b <write>:
SYSCALL(write)
    402b:	b8 10 00 00 00       	mov    $0x10,%eax
    4030:	cd 40                	int    $0x40
    4032:	c3                   	ret    

00004033 <close>:
SYSCALL(close)
    4033:	b8 15 00 00 00       	mov    $0x15,%eax
    4038:	cd 40                	int    $0x40
    403a:	c3                   	ret    

0000403b <kill>:
SYSCALL(kill)
    403b:	b8 06 00 00 00       	mov    $0x6,%eax
    4040:	cd 40                	int    $0x40
    4042:	c3                   	ret    

00004043 <exec>:
SYSCALL(exec)
    4043:	b8 07 00 00 00       	mov    $0x7,%eax
    4048:	cd 40                	int    $0x40
    404a:	c3                   	ret    

0000404b <open>:
SYSCALL(open)
    404b:	b8 0f 00 00 00       	mov    $0xf,%eax
    4050:	cd 40                	int    $0x40
    4052:	c3                   	ret    

00004053 <mknod>:
SYSCALL(mknod)
    4053:	b8 11 00 00 00       	mov    $0x11,%eax
    4058:	cd 40                	int    $0x40
    405a:	c3                   	ret    

0000405b <unlink>:
SYSCALL(unlink)
    405b:	b8 12 00 00 00       	mov    $0x12,%eax
    4060:	cd 40                	int    $0x40
    4062:	c3                   	ret    

00004063 <fstat>:
SYSCALL(fstat)
    4063:	b8 08 00 00 00       	mov    $0x8,%eax
    4068:	cd 40                	int    $0x40
    406a:	c3                   	ret    

0000406b <link>:
SYSCALL(link)
    406b:	b8 13 00 00 00       	mov    $0x13,%eax
    4070:	cd 40                	int    $0x40
    4072:	c3                   	ret    

00004073 <mkdir>:
SYSCALL(mkdir)
    4073:	b8 14 00 00 00       	mov    $0x14,%eax
    4078:	cd 40                	int    $0x40
    407a:	c3                   	ret    

0000407b <chdir>:
SYSCALL(chdir)
    407b:	b8 09 00 00 00       	mov    $0x9,%eax
    4080:	cd 40                	int    $0x40
    4082:	c3                   	ret    

00004083 <dup>:
SYSCALL(dup)
    4083:	b8 0a 00 00 00       	mov    $0xa,%eax
    4088:	cd 40                	int    $0x40
    408a:	c3                   	ret    

0000408b <getpid>:
SYSCALL(getpid)
    408b:	b8 0b 00 00 00       	mov    $0xb,%eax
    4090:	cd 40                	int    $0x40
    4092:	c3                   	ret    

00004093 <sbrk>:
SYSCALL(sbrk)
    4093:	b8 0c 00 00 00       	mov    $0xc,%eax
    4098:	cd 40                	int    $0x40
    409a:	c3                   	ret    

0000409b <sleep>:
SYSCALL(sleep)
    409b:	b8 0d 00 00 00       	mov    $0xd,%eax
    40a0:	cd 40                	int    $0x40
    40a2:	c3                   	ret    

000040a3 <uptime>:
SYSCALL(uptime)
    40a3:	b8 0e 00 00 00       	mov    $0xe,%eax
    40a8:	cd 40                	int    $0x40
    40aa:	c3                   	ret    

000040ab <sigprocmask>:
SYSCALL(sigprocmask)
    40ab:	b8 16 00 00 00       	mov    $0x16,%eax
    40b0:	cd 40                	int    $0x40
    40b2:	c3                   	ret    

000040b3 <signal>:
SYSCALL(signal)
    40b3:	b8 17 00 00 00       	mov    $0x17,%eax
    40b8:	cd 40                	int    $0x40
    40ba:	c3                   	ret    

000040bb <sigret>:
SYSCALL(sigret)
    40bb:	b8 18 00 00 00       	mov    $0x18,%eax
    40c0:	cd 40                	int    $0x40
    40c2:	c3                   	ret    

000040c3 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    40c3:	55                   	push   %ebp
    40c4:	89 e5                	mov    %esp,%ebp
    40c6:	83 ec 18             	sub    $0x18,%esp
    40c9:	8b 45 0c             	mov    0xc(%ebp),%eax
    40cc:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    40cf:	83 ec 04             	sub    $0x4,%esp
    40d2:	6a 01                	push   $0x1
    40d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
    40d7:	50                   	push   %eax
    40d8:	ff 75 08             	pushl  0x8(%ebp)
    40db:	e8 4b ff ff ff       	call   402b <write>
    40e0:	83 c4 10             	add    $0x10,%esp
}
    40e3:	90                   	nop
    40e4:	c9                   	leave  
    40e5:	c3                   	ret    

000040e6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    40e6:	55                   	push   %ebp
    40e7:	89 e5                	mov    %esp,%ebp
    40e9:	53                   	push   %ebx
    40ea:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    40ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    40f4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    40f8:	74 17                	je     4111 <printint+0x2b>
    40fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    40fe:	79 11                	jns    4111 <printint+0x2b>
    neg = 1;
    4100:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    4107:	8b 45 0c             	mov    0xc(%ebp),%eax
    410a:	f7 d8                	neg    %eax
    410c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    410f:	eb 06                	jmp    4117 <printint+0x31>
  } else {
    x = xx;
    4111:	8b 45 0c             	mov    0xc(%ebp),%eax
    4114:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    4117:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    411e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    4121:	8d 41 01             	lea    0x1(%ecx),%eax
    4124:	89 45 f4             	mov    %eax,-0xc(%ebp)
    4127:	8b 5d 10             	mov    0x10(%ebp),%ebx
    412a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    412d:	ba 00 00 00 00       	mov    $0x0,%edx
    4132:	f7 f3                	div    %ebx
    4134:	89 d0                	mov    %edx,%eax
    4136:	0f b6 80 b4 64 00 00 	movzbl 0x64b4(%eax),%eax
    413d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    4141:	8b 5d 10             	mov    0x10(%ebp),%ebx
    4144:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4147:	ba 00 00 00 00       	mov    $0x0,%edx
    414c:	f7 f3                	div    %ebx
    414e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    4151:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    4155:	75 c7                	jne    411e <printint+0x38>
  if(neg)
    4157:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    415b:	74 2d                	je     418a <printint+0xa4>
    buf[i++] = '-';
    415d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4160:	8d 50 01             	lea    0x1(%eax),%edx
    4163:	89 55 f4             	mov    %edx,-0xc(%ebp)
    4166:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    416b:	eb 1d                	jmp    418a <printint+0xa4>
    putc(fd, buf[i]);
    416d:	8d 55 dc             	lea    -0x24(%ebp),%edx
    4170:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4173:	01 d0                	add    %edx,%eax
    4175:	0f b6 00             	movzbl (%eax),%eax
    4178:	0f be c0             	movsbl %al,%eax
    417b:	83 ec 08             	sub    $0x8,%esp
    417e:	50                   	push   %eax
    417f:	ff 75 08             	pushl  0x8(%ebp)
    4182:	e8 3c ff ff ff       	call   40c3 <putc>
    4187:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    418a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    418e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4192:	79 d9                	jns    416d <printint+0x87>
    putc(fd, buf[i]);
}
    4194:	90                   	nop
    4195:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    4198:	c9                   	leave  
    4199:	c3                   	ret    

0000419a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    419a:	55                   	push   %ebp
    419b:	89 e5                	mov    %esp,%ebp
    419d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    41a0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    41a7:	8d 45 0c             	lea    0xc(%ebp),%eax
    41aa:	83 c0 04             	add    $0x4,%eax
    41ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    41b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    41b7:	e9 59 01 00 00       	jmp    4315 <printf+0x17b>
    c = fmt[i] & 0xff;
    41bc:	8b 55 0c             	mov    0xc(%ebp),%edx
    41bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
    41c2:	01 d0                	add    %edx,%eax
    41c4:	0f b6 00             	movzbl (%eax),%eax
    41c7:	0f be c0             	movsbl %al,%eax
    41ca:	25 ff 00 00 00       	and    $0xff,%eax
    41cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    41d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    41d6:	75 2c                	jne    4204 <printf+0x6a>
      if(c == '%'){
    41d8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    41dc:	75 0c                	jne    41ea <printf+0x50>
        state = '%';
    41de:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    41e5:	e9 27 01 00 00       	jmp    4311 <printf+0x177>
      } else {
        putc(fd, c);
    41ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    41ed:	0f be c0             	movsbl %al,%eax
    41f0:	83 ec 08             	sub    $0x8,%esp
    41f3:	50                   	push   %eax
    41f4:	ff 75 08             	pushl  0x8(%ebp)
    41f7:	e8 c7 fe ff ff       	call   40c3 <putc>
    41fc:	83 c4 10             	add    $0x10,%esp
    41ff:	e9 0d 01 00 00       	jmp    4311 <printf+0x177>
      }
    } else if(state == '%'){
    4204:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    4208:	0f 85 03 01 00 00    	jne    4311 <printf+0x177>
      if(c == 'd'){
    420e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    4212:	75 1e                	jne    4232 <printf+0x98>
        printint(fd, *ap, 10, 1);
    4214:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4217:	8b 00                	mov    (%eax),%eax
    4219:	6a 01                	push   $0x1
    421b:	6a 0a                	push   $0xa
    421d:	50                   	push   %eax
    421e:	ff 75 08             	pushl  0x8(%ebp)
    4221:	e8 c0 fe ff ff       	call   40e6 <printint>
    4226:	83 c4 10             	add    $0x10,%esp
        ap++;
    4229:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    422d:	e9 d8 00 00 00       	jmp    430a <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    4232:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    4236:	74 06                	je     423e <printf+0xa4>
    4238:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    423c:	75 1e                	jne    425c <printf+0xc2>
        printint(fd, *ap, 16, 0);
    423e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4241:	8b 00                	mov    (%eax),%eax
    4243:	6a 00                	push   $0x0
    4245:	6a 10                	push   $0x10
    4247:	50                   	push   %eax
    4248:	ff 75 08             	pushl  0x8(%ebp)
    424b:	e8 96 fe ff ff       	call   40e6 <printint>
    4250:	83 c4 10             	add    $0x10,%esp
        ap++;
    4253:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    4257:	e9 ae 00 00 00       	jmp    430a <printf+0x170>
      } else if(c == 's'){
    425c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    4260:	75 43                	jne    42a5 <printf+0x10b>
        s = (char*)*ap;
    4262:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4265:	8b 00                	mov    (%eax),%eax
    4267:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    426a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    426e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4272:	75 25                	jne    4299 <printf+0xff>
          s = "(null)";
    4274:	c7 45 f4 7a 5d 00 00 	movl   $0x5d7a,-0xc(%ebp)
        while(*s != 0){
    427b:	eb 1c                	jmp    4299 <printf+0xff>
          putc(fd, *s);
    427d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4280:	0f b6 00             	movzbl (%eax),%eax
    4283:	0f be c0             	movsbl %al,%eax
    4286:	83 ec 08             	sub    $0x8,%esp
    4289:	50                   	push   %eax
    428a:	ff 75 08             	pushl  0x8(%ebp)
    428d:	e8 31 fe ff ff       	call   40c3 <putc>
    4292:	83 c4 10             	add    $0x10,%esp
          s++;
    4295:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    4299:	8b 45 f4             	mov    -0xc(%ebp),%eax
    429c:	0f b6 00             	movzbl (%eax),%eax
    429f:	84 c0                	test   %al,%al
    42a1:	75 da                	jne    427d <printf+0xe3>
    42a3:	eb 65                	jmp    430a <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    42a5:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    42a9:	75 1d                	jne    42c8 <printf+0x12e>
        putc(fd, *ap);
    42ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
    42ae:	8b 00                	mov    (%eax),%eax
    42b0:	0f be c0             	movsbl %al,%eax
    42b3:	83 ec 08             	sub    $0x8,%esp
    42b6:	50                   	push   %eax
    42b7:	ff 75 08             	pushl  0x8(%ebp)
    42ba:	e8 04 fe ff ff       	call   40c3 <putc>
    42bf:	83 c4 10             	add    $0x10,%esp
        ap++;
    42c2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    42c6:	eb 42                	jmp    430a <printf+0x170>
      } else if(c == '%'){
    42c8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    42cc:	75 17                	jne    42e5 <printf+0x14b>
        putc(fd, c);
    42ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    42d1:	0f be c0             	movsbl %al,%eax
    42d4:	83 ec 08             	sub    $0x8,%esp
    42d7:	50                   	push   %eax
    42d8:	ff 75 08             	pushl  0x8(%ebp)
    42db:	e8 e3 fd ff ff       	call   40c3 <putc>
    42e0:	83 c4 10             	add    $0x10,%esp
    42e3:	eb 25                	jmp    430a <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    42e5:	83 ec 08             	sub    $0x8,%esp
    42e8:	6a 25                	push   $0x25
    42ea:	ff 75 08             	pushl  0x8(%ebp)
    42ed:	e8 d1 fd ff ff       	call   40c3 <putc>
    42f2:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    42f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    42f8:	0f be c0             	movsbl %al,%eax
    42fb:	83 ec 08             	sub    $0x8,%esp
    42fe:	50                   	push   %eax
    42ff:	ff 75 08             	pushl  0x8(%ebp)
    4302:	e8 bc fd ff ff       	call   40c3 <putc>
    4307:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    430a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    4311:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    4315:	8b 55 0c             	mov    0xc(%ebp),%edx
    4318:	8b 45 f0             	mov    -0x10(%ebp),%eax
    431b:	01 d0                	add    %edx,%eax
    431d:	0f b6 00             	movzbl (%eax),%eax
    4320:	84 c0                	test   %al,%al
    4322:	0f 85 94 fe ff ff    	jne    41bc <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    4328:	90                   	nop
    4329:	c9                   	leave  
    432a:	c3                   	ret    

0000432b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    432b:	55                   	push   %ebp
    432c:	89 e5                	mov    %esp,%ebp
    432e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    4331:	8b 45 08             	mov    0x8(%ebp),%eax
    4334:	83 e8 08             	sub    $0x8,%eax
    4337:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    433a:	a1 68 65 00 00       	mov    0x6568,%eax
    433f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    4342:	eb 24                	jmp    4368 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4344:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4347:	8b 00                	mov    (%eax),%eax
    4349:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    434c:	77 12                	ja     4360 <free+0x35>
    434e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4351:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4354:	77 24                	ja     437a <free+0x4f>
    4356:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4359:	8b 00                	mov    (%eax),%eax
    435b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    435e:	77 1a                	ja     437a <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4360:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4363:	8b 00                	mov    (%eax),%eax
    4365:	89 45 fc             	mov    %eax,-0x4(%ebp)
    4368:	8b 45 f8             	mov    -0x8(%ebp),%eax
    436b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    436e:	76 d4                	jbe    4344 <free+0x19>
    4370:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4373:	8b 00                	mov    (%eax),%eax
    4375:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    4378:	76 ca                	jbe    4344 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    437a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    437d:	8b 40 04             	mov    0x4(%eax),%eax
    4380:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    4387:	8b 45 f8             	mov    -0x8(%ebp),%eax
    438a:	01 c2                	add    %eax,%edx
    438c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    438f:	8b 00                	mov    (%eax),%eax
    4391:	39 c2                	cmp    %eax,%edx
    4393:	75 24                	jne    43b9 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    4395:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4398:	8b 50 04             	mov    0x4(%eax),%edx
    439b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    439e:	8b 00                	mov    (%eax),%eax
    43a0:	8b 40 04             	mov    0x4(%eax),%eax
    43a3:	01 c2                	add    %eax,%edx
    43a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    43a8:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    43ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43ae:	8b 00                	mov    (%eax),%eax
    43b0:	8b 10                	mov    (%eax),%edx
    43b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    43b5:	89 10                	mov    %edx,(%eax)
    43b7:	eb 0a                	jmp    43c3 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    43b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43bc:	8b 10                	mov    (%eax),%edx
    43be:	8b 45 f8             	mov    -0x8(%ebp),%eax
    43c1:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    43c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43c6:	8b 40 04             	mov    0x4(%eax),%eax
    43c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    43d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43d3:	01 d0                	add    %edx,%eax
    43d5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    43d8:	75 20                	jne    43fa <free+0xcf>
    p->s.size += bp->s.size;
    43da:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43dd:	8b 50 04             	mov    0x4(%eax),%edx
    43e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    43e3:	8b 40 04             	mov    0x4(%eax),%eax
    43e6:	01 c2                	add    %eax,%edx
    43e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43eb:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    43ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
    43f1:	8b 10                	mov    (%eax),%edx
    43f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43f6:	89 10                	mov    %edx,(%eax)
    43f8:	eb 08                	jmp    4402 <free+0xd7>
  } else
    p->s.ptr = bp;
    43fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43fd:	8b 55 f8             	mov    -0x8(%ebp),%edx
    4400:	89 10                	mov    %edx,(%eax)
  freep = p;
    4402:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4405:	a3 68 65 00 00       	mov    %eax,0x6568
}
    440a:	90                   	nop
    440b:	c9                   	leave  
    440c:	c3                   	ret    

0000440d <morecore>:

static Header*
morecore(uint nu)
{
    440d:	55                   	push   %ebp
    440e:	89 e5                	mov    %esp,%ebp
    4410:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    4413:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    441a:	77 07                	ja     4423 <morecore+0x16>
    nu = 4096;
    441c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    4423:	8b 45 08             	mov    0x8(%ebp),%eax
    4426:	c1 e0 03             	shl    $0x3,%eax
    4429:	83 ec 0c             	sub    $0xc,%esp
    442c:	50                   	push   %eax
    442d:	e8 61 fc ff ff       	call   4093 <sbrk>
    4432:	83 c4 10             	add    $0x10,%esp
    4435:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    4438:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    443c:	75 07                	jne    4445 <morecore+0x38>
    return 0;
    443e:	b8 00 00 00 00       	mov    $0x0,%eax
    4443:	eb 26                	jmp    446b <morecore+0x5e>
  hp = (Header*)p;
    4445:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4448:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    444b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    444e:	8b 55 08             	mov    0x8(%ebp),%edx
    4451:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    4454:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4457:	83 c0 08             	add    $0x8,%eax
    445a:	83 ec 0c             	sub    $0xc,%esp
    445d:	50                   	push   %eax
    445e:	e8 c8 fe ff ff       	call   432b <free>
    4463:	83 c4 10             	add    $0x10,%esp
  return freep;
    4466:	a1 68 65 00 00       	mov    0x6568,%eax
}
    446b:	c9                   	leave  
    446c:	c3                   	ret    

0000446d <malloc>:

void*
malloc(uint nbytes)
{
    446d:	55                   	push   %ebp
    446e:	89 e5                	mov    %esp,%ebp
    4470:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4473:	8b 45 08             	mov    0x8(%ebp),%eax
    4476:	83 c0 07             	add    $0x7,%eax
    4479:	c1 e8 03             	shr    $0x3,%eax
    447c:	83 c0 01             	add    $0x1,%eax
    447f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    4482:	a1 68 65 00 00       	mov    0x6568,%eax
    4487:	89 45 f0             	mov    %eax,-0x10(%ebp)
    448a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    448e:	75 23                	jne    44b3 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    4490:	c7 45 f0 60 65 00 00 	movl   $0x6560,-0x10(%ebp)
    4497:	8b 45 f0             	mov    -0x10(%ebp),%eax
    449a:	a3 68 65 00 00       	mov    %eax,0x6568
    449f:	a1 68 65 00 00       	mov    0x6568,%eax
    44a4:	a3 60 65 00 00       	mov    %eax,0x6560
    base.s.size = 0;
    44a9:	c7 05 64 65 00 00 00 	movl   $0x0,0x6564
    44b0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    44b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    44b6:	8b 00                	mov    (%eax),%eax
    44b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    44bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44be:	8b 40 04             	mov    0x4(%eax),%eax
    44c1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    44c4:	72 4d                	jb     4513 <malloc+0xa6>
      if(p->s.size == nunits)
    44c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44c9:	8b 40 04             	mov    0x4(%eax),%eax
    44cc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    44cf:	75 0c                	jne    44dd <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    44d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44d4:	8b 10                	mov    (%eax),%edx
    44d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    44d9:	89 10                	mov    %edx,(%eax)
    44db:	eb 26                	jmp    4503 <malloc+0x96>
      else {
        p->s.size -= nunits;
    44dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44e0:	8b 40 04             	mov    0x4(%eax),%eax
    44e3:	2b 45 ec             	sub    -0x14(%ebp),%eax
    44e6:	89 c2                	mov    %eax,%edx
    44e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44eb:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    44ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44f1:	8b 40 04             	mov    0x4(%eax),%eax
    44f4:	c1 e0 03             	shl    $0x3,%eax
    44f7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    44fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
    4500:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    4503:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4506:	a3 68 65 00 00       	mov    %eax,0x6568
      return (void*)(p + 1);
    450b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    450e:	83 c0 08             	add    $0x8,%eax
    4511:	eb 3b                	jmp    454e <malloc+0xe1>
    }
    if(p == freep)
    4513:	a1 68 65 00 00       	mov    0x6568,%eax
    4518:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    451b:	75 1e                	jne    453b <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    451d:	83 ec 0c             	sub    $0xc,%esp
    4520:	ff 75 ec             	pushl  -0x14(%ebp)
    4523:	e8 e5 fe ff ff       	call   440d <morecore>
    4528:	83 c4 10             	add    $0x10,%esp
    452b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    452e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4532:	75 07                	jne    453b <malloc+0xce>
        return 0;
    4534:	b8 00 00 00 00       	mov    $0x0,%eax
    4539:	eb 13                	jmp    454e <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    453b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    453e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    4541:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4544:	8b 00                	mov    (%eax),%eax
    4546:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    4549:	e9 6d ff ff ff       	jmp    44bb <malloc+0x4e>
}
    454e:	c9                   	leave  
    454f:	c3                   	ret    
