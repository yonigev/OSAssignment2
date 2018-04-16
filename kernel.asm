
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 d6 10 80       	mov    $0x8010d650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 aa 38 10 80       	mov    $0x801038aa,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 e0 89 10 80       	push   $0x801089e0
80100042:	68 60 d6 10 80       	push   $0x8010d660
80100047:	e8 13 51 00 00       	call   8010515f <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 ac 1d 11 80 5c 	movl   $0x80111d5c,0x80111dac
80100056:	1d 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 b0 1d 11 80 5c 	movl   $0x80111d5c,0x80111db0
80100060:	1d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 94 d6 10 80 	movl   $0x8010d694,-0xc(%ebp)
8010006a:	eb 47                	jmp    801000b3 <binit+0x7f>
    b->next = bcache.head.next;
8010006c:	8b 15 b0 1d 11 80    	mov    0x80111db0,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 50 5c 1d 11 80 	movl   $0x80111d5c,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	83 c0 0c             	add    $0xc,%eax
80100088:	83 ec 08             	sub    $0x8,%esp
8010008b:	68 e7 89 10 80       	push   $0x801089e7
80100090:	50                   	push   %eax
80100091:	e8 6c 4f 00 00       	call   80105002 <initsleeplock>
80100096:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
80100099:	a1 b0 1d 11 80       	mov    0x80111db0,%eax
8010009e:	8b 55 f4             	mov    -0xc(%ebp),%edx
801000a1:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000a7:	a3 b0 1d 11 80       	mov    %eax,0x80111db0

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ac:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000b3:	b8 5c 1d 11 80       	mov    $0x80111d5c,%eax
801000b8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000bb:	72 af                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	90                   	nop
801000be:	c9                   	leave  
801000bf:	c3                   	ret    

801000c0 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000c0:	55                   	push   %ebp
801000c1:	89 e5                	mov    %esp,%ebp
801000c3:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000c6:	83 ec 0c             	sub    $0xc,%esp
801000c9:	68 60 d6 10 80       	push   $0x8010d660
801000ce:	e8 ae 50 00 00       	call   80105181 <acquire>
801000d3:	83 c4 10             	add    $0x10,%esp

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000d6:	a1 b0 1d 11 80       	mov    0x80111db0,%eax
801000db:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000de:	eb 58                	jmp    80100138 <bget+0x78>
    if(b->dev == dev && b->blockno == blockno){
801000e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e3:	8b 40 04             	mov    0x4(%eax),%eax
801000e6:	3b 45 08             	cmp    0x8(%ebp),%eax
801000e9:	75 44                	jne    8010012f <bget+0x6f>
801000eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ee:	8b 40 08             	mov    0x8(%eax),%eax
801000f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000f4:	75 39                	jne    8010012f <bget+0x6f>
      b->refcnt++;
801000f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f9:	8b 40 4c             	mov    0x4c(%eax),%eax
801000fc:	8d 50 01             	lea    0x1(%eax),%edx
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	89 50 4c             	mov    %edx,0x4c(%eax)
      release(&bcache.lock);
80100105:	83 ec 0c             	sub    $0xc,%esp
80100108:	68 60 d6 10 80       	push   $0x8010d660
8010010d:	e8 dd 50 00 00       	call   801051ef <release>
80100112:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100118:	83 c0 0c             	add    $0xc,%eax
8010011b:	83 ec 0c             	sub    $0xc,%esp
8010011e:	50                   	push   %eax
8010011f:	e8 1a 4f 00 00       	call   8010503e <acquiresleep>
80100124:	83 c4 10             	add    $0x10,%esp
      return b;
80100127:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010012a:	e9 9d 00 00 00       	jmp    801001cc <bget+0x10c>
  struct buf *b;

  acquire(&bcache.lock);

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010012f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100132:	8b 40 54             	mov    0x54(%eax),%eax
80100135:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100138:	81 7d f4 5c 1d 11 80 	cmpl   $0x80111d5c,-0xc(%ebp)
8010013f:	75 9f                	jne    801000e0 <bget+0x20>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100141:	a1 ac 1d 11 80       	mov    0x80111dac,%eax
80100146:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100149:	eb 6b                	jmp    801001b6 <bget+0xf6>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010014b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014e:	8b 40 4c             	mov    0x4c(%eax),%eax
80100151:	85 c0                	test   %eax,%eax
80100153:	75 58                	jne    801001ad <bget+0xed>
80100155:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100158:	8b 00                	mov    (%eax),%eax
8010015a:	83 e0 04             	and    $0x4,%eax
8010015d:	85 c0                	test   %eax,%eax
8010015f:	75 4c                	jne    801001ad <bget+0xed>
      b->dev = dev;
80100161:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100164:	8b 55 08             	mov    0x8(%ebp),%edx
80100167:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016d:	8b 55 0c             	mov    0xc(%ebp),%edx
80100170:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
80100173:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100176:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
8010017c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017f:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      release(&bcache.lock);
80100186:	83 ec 0c             	sub    $0xc,%esp
80100189:	68 60 d6 10 80       	push   $0x8010d660
8010018e:	e8 5c 50 00 00       	call   801051ef <release>
80100193:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100196:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100199:	83 c0 0c             	add    $0xc,%eax
8010019c:	83 ec 0c             	sub    $0xc,%esp
8010019f:	50                   	push   %eax
801001a0:	e8 99 4e 00 00       	call   8010503e <acquiresleep>
801001a5:	83 c4 10             	add    $0x10,%esp
      return b;
801001a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001ab:	eb 1f                	jmp    801001cc <bget+0x10c>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801001ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001b0:	8b 40 50             	mov    0x50(%eax),%eax
801001b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801001b6:	81 7d f4 5c 1d 11 80 	cmpl   $0x80111d5c,-0xc(%ebp)
801001bd:	75 8c                	jne    8010014b <bget+0x8b>
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001bf:	83 ec 0c             	sub    $0xc,%esp
801001c2:	68 ee 89 10 80       	push   $0x801089ee
801001c7:	e8 d4 03 00 00       	call   801005a0 <panic>
}
801001cc:	c9                   	leave  
801001cd:	c3                   	ret    

801001ce <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001ce:	55                   	push   %ebp
801001cf:	89 e5                	mov    %esp,%ebp
801001d1:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001d4:	83 ec 08             	sub    $0x8,%esp
801001d7:	ff 75 0c             	pushl  0xc(%ebp)
801001da:	ff 75 08             	pushl  0x8(%ebp)
801001dd:	e8 de fe ff ff       	call   801000c0 <bget>
801001e2:	83 c4 10             	add    $0x10,%esp
801001e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
801001e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001eb:	8b 00                	mov    (%eax),%eax
801001ed:	83 e0 02             	and    $0x2,%eax
801001f0:	85 c0                	test   %eax,%eax
801001f2:	75 0e                	jne    80100202 <bread+0x34>
    iderw(b);
801001f4:	83 ec 0c             	sub    $0xc,%esp
801001f7:	ff 75 f4             	pushl  -0xc(%ebp)
801001fa:	e8 aa 27 00 00       	call   801029a9 <iderw>
801001ff:	83 c4 10             	add    $0x10,%esp
  }
  return b;
80100202:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80100205:	c9                   	leave  
80100206:	c3                   	ret    

80100207 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100207:	55                   	push   %ebp
80100208:	89 e5                	mov    %esp,%ebp
8010020a:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
8010020d:	8b 45 08             	mov    0x8(%ebp),%eax
80100210:	83 c0 0c             	add    $0xc,%eax
80100213:	83 ec 0c             	sub    $0xc,%esp
80100216:	50                   	push   %eax
80100217:	e8 d4 4e 00 00       	call   801050f0 <holdingsleep>
8010021c:	83 c4 10             	add    $0x10,%esp
8010021f:	85 c0                	test   %eax,%eax
80100221:	75 0d                	jne    80100230 <bwrite+0x29>
    panic("bwrite");
80100223:	83 ec 0c             	sub    $0xc,%esp
80100226:	68 ff 89 10 80       	push   $0x801089ff
8010022b:	e8 70 03 00 00       	call   801005a0 <panic>
  b->flags |= B_DIRTY;
80100230:	8b 45 08             	mov    0x8(%ebp),%eax
80100233:	8b 00                	mov    (%eax),%eax
80100235:	83 c8 04             	or     $0x4,%eax
80100238:	89 c2                	mov    %eax,%edx
8010023a:	8b 45 08             	mov    0x8(%ebp),%eax
8010023d:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010023f:	83 ec 0c             	sub    $0xc,%esp
80100242:	ff 75 08             	pushl  0x8(%ebp)
80100245:	e8 5f 27 00 00       	call   801029a9 <iderw>
8010024a:	83 c4 10             	add    $0x10,%esp
}
8010024d:	90                   	nop
8010024e:	c9                   	leave  
8010024f:	c3                   	ret    

80100250 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100250:	55                   	push   %ebp
80100251:	89 e5                	mov    %esp,%ebp
80100253:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
80100256:	8b 45 08             	mov    0x8(%ebp),%eax
80100259:	83 c0 0c             	add    $0xc,%eax
8010025c:	83 ec 0c             	sub    $0xc,%esp
8010025f:	50                   	push   %eax
80100260:	e8 8b 4e 00 00       	call   801050f0 <holdingsleep>
80100265:	83 c4 10             	add    $0x10,%esp
80100268:	85 c0                	test   %eax,%eax
8010026a:	75 0d                	jne    80100279 <brelse+0x29>
    panic("brelse");
8010026c:	83 ec 0c             	sub    $0xc,%esp
8010026f:	68 06 8a 10 80       	push   $0x80108a06
80100274:	e8 27 03 00 00       	call   801005a0 <panic>

  releasesleep(&b->lock);
80100279:	8b 45 08             	mov    0x8(%ebp),%eax
8010027c:	83 c0 0c             	add    $0xc,%eax
8010027f:	83 ec 0c             	sub    $0xc,%esp
80100282:	50                   	push   %eax
80100283:	e8 1a 4e 00 00       	call   801050a2 <releasesleep>
80100288:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
8010028b:	83 ec 0c             	sub    $0xc,%esp
8010028e:	68 60 d6 10 80       	push   $0x8010d660
80100293:	e8 e9 4e 00 00       	call   80105181 <acquire>
80100298:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010029b:	8b 45 08             	mov    0x8(%ebp),%eax
8010029e:	8b 40 4c             	mov    0x4c(%eax),%eax
801002a1:	8d 50 ff             	lea    -0x1(%eax),%edx
801002a4:	8b 45 08             	mov    0x8(%ebp),%eax
801002a7:	89 50 4c             	mov    %edx,0x4c(%eax)
  if (b->refcnt == 0) {
801002aa:	8b 45 08             	mov    0x8(%ebp),%eax
801002ad:	8b 40 4c             	mov    0x4c(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 47                	jne    801002fb <brelse+0xab>
    // no one is waiting for it.
    b->next->prev = b->prev;
801002b4:	8b 45 08             	mov    0x8(%ebp),%eax
801002b7:	8b 40 54             	mov    0x54(%eax),%eax
801002ba:	8b 55 08             	mov    0x8(%ebp),%edx
801002bd:	8b 52 50             	mov    0x50(%edx),%edx
801002c0:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
801002c3:	8b 45 08             	mov    0x8(%ebp),%eax
801002c6:	8b 40 50             	mov    0x50(%eax),%eax
801002c9:	8b 55 08             	mov    0x8(%ebp),%edx
801002cc:	8b 52 54             	mov    0x54(%edx),%edx
801002cf:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
801002d2:	8b 15 b0 1d 11 80    	mov    0x80111db0,%edx
801002d8:	8b 45 08             	mov    0x8(%ebp),%eax
801002db:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801002de:	8b 45 08             	mov    0x8(%ebp),%eax
801002e1:	c7 40 50 5c 1d 11 80 	movl   $0x80111d5c,0x50(%eax)
    bcache.head.next->prev = b;
801002e8:	a1 b0 1d 11 80       	mov    0x80111db0,%eax
801002ed:	8b 55 08             	mov    0x8(%ebp),%edx
801002f0:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801002f3:	8b 45 08             	mov    0x8(%ebp),%eax
801002f6:	a3 b0 1d 11 80       	mov    %eax,0x80111db0
  }
  
  release(&bcache.lock);
801002fb:	83 ec 0c             	sub    $0xc,%esp
801002fe:	68 60 d6 10 80       	push   $0x8010d660
80100303:	e8 e7 4e 00 00       	call   801051ef <release>
80100308:	83 c4 10             	add    $0x10,%esp
}
8010030b:	90                   	nop
8010030c:	c9                   	leave  
8010030d:	c3                   	ret    

8010030e <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010030e:	55                   	push   %ebp
8010030f:	89 e5                	mov    %esp,%ebp
80100311:	83 ec 14             	sub    $0x14,%esp
80100314:	8b 45 08             	mov    0x8(%ebp),%eax
80100317:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010031b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010031f:	89 c2                	mov    %eax,%edx
80100321:	ec                   	in     (%dx),%al
80100322:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80100325:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80100329:	c9                   	leave  
8010032a:	c3                   	ret    

8010032b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010032b:	55                   	push   %ebp
8010032c:	89 e5                	mov    %esp,%ebp
8010032e:	83 ec 08             	sub    $0x8,%esp
80100331:	8b 55 08             	mov    0x8(%ebp),%edx
80100334:	8b 45 0c             	mov    0xc(%ebp),%eax
80100337:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010033b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010033e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100342:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80100346:	ee                   	out    %al,(%dx)
}
80100347:	90                   	nop
80100348:	c9                   	leave  
80100349:	c3                   	ret    

8010034a <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010034a:	55                   	push   %ebp
8010034b:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010034d:	fa                   	cli    
}
8010034e:	90                   	nop
8010034f:	5d                   	pop    %ebp
80100350:	c3                   	ret    

80100351 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100351:	55                   	push   %ebp
80100352:	89 e5                	mov    %esp,%ebp
80100354:	53                   	push   %ebx
80100355:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100358:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010035c:	74 1c                	je     8010037a <printint+0x29>
8010035e:	8b 45 08             	mov    0x8(%ebp),%eax
80100361:	c1 e8 1f             	shr    $0x1f,%eax
80100364:	0f b6 c0             	movzbl %al,%eax
80100367:	89 45 10             	mov    %eax,0x10(%ebp)
8010036a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010036e:	74 0a                	je     8010037a <printint+0x29>
    x = -xx;
80100370:	8b 45 08             	mov    0x8(%ebp),%eax
80100373:	f7 d8                	neg    %eax
80100375:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100378:	eb 06                	jmp    80100380 <printint+0x2f>
  else
    x = xx;
8010037a:	8b 45 08             	mov    0x8(%ebp),%eax
8010037d:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100380:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100387:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010038a:	8d 41 01             	lea    0x1(%ecx),%eax
8010038d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100390:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100393:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100396:	ba 00 00 00 00       	mov    $0x0,%edx
8010039b:	f7 f3                	div    %ebx
8010039d:	89 d0                	mov    %edx,%eax
8010039f:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
801003a6:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
801003aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801003ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801003b0:	ba 00 00 00 00       	mov    $0x0,%edx
801003b5:	f7 f3                	div    %ebx
801003b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801003ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801003be:	75 c7                	jne    80100387 <printint+0x36>

  if(sign)
801003c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801003c4:	74 2a                	je     801003f0 <printint+0x9f>
    buf[i++] = '-';
801003c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003c9:	8d 50 01             	lea    0x1(%eax),%edx
801003cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
801003cf:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
801003d4:	eb 1a                	jmp    801003f0 <printint+0x9f>
    consputc(buf[i]);
801003d6:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003dc:	01 d0                	add    %edx,%eax
801003de:	0f b6 00             	movzbl (%eax),%eax
801003e1:	0f be c0             	movsbl %al,%eax
801003e4:	83 ec 0c             	sub    $0xc,%esp
801003e7:	50                   	push   %eax
801003e8:	e8 d8 03 00 00       	call   801007c5 <consputc>
801003ed:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003f0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003f8:	79 dc                	jns    801003d6 <printint+0x85>
    consputc(buf[i]);
}
801003fa:	90                   	nop
801003fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003fe:	c9                   	leave  
801003ff:	c3                   	ret    

80100400 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100406:	a1 f4 c5 10 80       	mov    0x8010c5f4,%eax
8010040b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
8010040e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100412:	74 10                	je     80100424 <cprintf+0x24>
    acquire(&cons.lock);
80100414:	83 ec 0c             	sub    $0xc,%esp
80100417:	68 c0 c5 10 80       	push   $0x8010c5c0
8010041c:	e8 60 4d 00 00       	call   80105181 <acquire>
80100421:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100424:	8b 45 08             	mov    0x8(%ebp),%eax
80100427:	85 c0                	test   %eax,%eax
80100429:	75 0d                	jne    80100438 <cprintf+0x38>
    panic("null fmt");
8010042b:	83 ec 0c             	sub    $0xc,%esp
8010042e:	68 0d 8a 10 80       	push   $0x80108a0d
80100433:	e8 68 01 00 00       	call   801005a0 <panic>

  argp = (uint*)(void*)(&fmt + 1);
80100438:	8d 45 0c             	lea    0xc(%ebp),%eax
8010043b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010043e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100445:	e9 1a 01 00 00       	jmp    80100564 <cprintf+0x164>
    if(c != '%'){
8010044a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
8010044e:	74 13                	je     80100463 <cprintf+0x63>
      consputc(c);
80100450:	83 ec 0c             	sub    $0xc,%esp
80100453:	ff 75 e4             	pushl  -0x1c(%ebp)
80100456:	e8 6a 03 00 00       	call   801007c5 <consputc>
8010045b:	83 c4 10             	add    $0x10,%esp
      continue;
8010045e:	e9 fd 00 00 00       	jmp    80100560 <cprintf+0x160>
    }
    c = fmt[++i] & 0xff;
80100463:	8b 55 08             	mov    0x8(%ebp),%edx
80100466:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010046a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010046d:	01 d0                	add    %edx,%eax
8010046f:	0f b6 00             	movzbl (%eax),%eax
80100472:	0f be c0             	movsbl %al,%eax
80100475:	25 ff 00 00 00       	and    $0xff,%eax
8010047a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
8010047d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100481:	0f 84 ff 00 00 00    	je     80100586 <cprintf+0x186>
      break;
    switch(c){
80100487:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010048a:	83 f8 70             	cmp    $0x70,%eax
8010048d:	74 47                	je     801004d6 <cprintf+0xd6>
8010048f:	83 f8 70             	cmp    $0x70,%eax
80100492:	7f 13                	jg     801004a7 <cprintf+0xa7>
80100494:	83 f8 25             	cmp    $0x25,%eax
80100497:	0f 84 98 00 00 00    	je     80100535 <cprintf+0x135>
8010049d:	83 f8 64             	cmp    $0x64,%eax
801004a0:	74 14                	je     801004b6 <cprintf+0xb6>
801004a2:	e9 9d 00 00 00       	jmp    80100544 <cprintf+0x144>
801004a7:	83 f8 73             	cmp    $0x73,%eax
801004aa:	74 47                	je     801004f3 <cprintf+0xf3>
801004ac:	83 f8 78             	cmp    $0x78,%eax
801004af:	74 25                	je     801004d6 <cprintf+0xd6>
801004b1:	e9 8e 00 00 00       	jmp    80100544 <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
801004b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004b9:	8d 50 04             	lea    0x4(%eax),%edx
801004bc:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004bf:	8b 00                	mov    (%eax),%eax
801004c1:	83 ec 04             	sub    $0x4,%esp
801004c4:	6a 01                	push   $0x1
801004c6:	6a 0a                	push   $0xa
801004c8:	50                   	push   %eax
801004c9:	e8 83 fe ff ff       	call   80100351 <printint>
801004ce:	83 c4 10             	add    $0x10,%esp
      break;
801004d1:	e9 8a 00 00 00       	jmp    80100560 <cprintf+0x160>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
801004d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004d9:	8d 50 04             	lea    0x4(%eax),%edx
801004dc:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004df:	8b 00                	mov    (%eax),%eax
801004e1:	83 ec 04             	sub    $0x4,%esp
801004e4:	6a 00                	push   $0x0
801004e6:	6a 10                	push   $0x10
801004e8:	50                   	push   %eax
801004e9:	e8 63 fe ff ff       	call   80100351 <printint>
801004ee:	83 c4 10             	add    $0x10,%esp
      break;
801004f1:	eb 6d                	jmp    80100560 <cprintf+0x160>
    case 's':
      if((s = (char*)*argp++) == 0)
801004f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004f6:	8d 50 04             	lea    0x4(%eax),%edx
801004f9:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004fc:	8b 00                	mov    (%eax),%eax
801004fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100501:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100505:	75 22                	jne    80100529 <cprintf+0x129>
        s = "(null)";
80100507:	c7 45 ec 16 8a 10 80 	movl   $0x80108a16,-0x14(%ebp)
      for(; *s; s++)
8010050e:	eb 19                	jmp    80100529 <cprintf+0x129>
        consputc(*s);
80100510:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100513:	0f b6 00             	movzbl (%eax),%eax
80100516:	0f be c0             	movsbl %al,%eax
80100519:	83 ec 0c             	sub    $0xc,%esp
8010051c:	50                   	push   %eax
8010051d:	e8 a3 02 00 00       	call   801007c5 <consputc>
80100522:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100525:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100529:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010052c:	0f b6 00             	movzbl (%eax),%eax
8010052f:	84 c0                	test   %al,%al
80100531:	75 dd                	jne    80100510 <cprintf+0x110>
        consputc(*s);
      break;
80100533:	eb 2b                	jmp    80100560 <cprintf+0x160>
    case '%':
      consputc('%');
80100535:	83 ec 0c             	sub    $0xc,%esp
80100538:	6a 25                	push   $0x25
8010053a:	e8 86 02 00 00       	call   801007c5 <consputc>
8010053f:	83 c4 10             	add    $0x10,%esp
      break;
80100542:	eb 1c                	jmp    80100560 <cprintf+0x160>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100544:	83 ec 0c             	sub    $0xc,%esp
80100547:	6a 25                	push   $0x25
80100549:	e8 77 02 00 00       	call   801007c5 <consputc>
8010054e:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100551:	83 ec 0c             	sub    $0xc,%esp
80100554:	ff 75 e4             	pushl  -0x1c(%ebp)
80100557:	e8 69 02 00 00       	call   801007c5 <consputc>
8010055c:	83 c4 10             	add    $0x10,%esp
      break;
8010055f:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100560:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100564:	8b 55 08             	mov    0x8(%ebp),%edx
80100567:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010056a:	01 d0                	add    %edx,%eax
8010056c:	0f b6 00             	movzbl (%eax),%eax
8010056f:	0f be c0             	movsbl %al,%eax
80100572:	25 ff 00 00 00       	and    $0xff,%eax
80100577:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010057a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010057e:	0f 85 c6 fe ff ff    	jne    8010044a <cprintf+0x4a>
80100584:	eb 01                	jmp    80100587 <cprintf+0x187>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
80100586:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
80100587:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010058b:	74 10                	je     8010059d <cprintf+0x19d>
    release(&cons.lock);
8010058d:	83 ec 0c             	sub    $0xc,%esp
80100590:	68 c0 c5 10 80       	push   $0x8010c5c0
80100595:	e8 55 4c 00 00       	call   801051ef <release>
8010059a:	83 c4 10             	add    $0x10,%esp
}
8010059d:	90                   	nop
8010059e:	c9                   	leave  
8010059f:	c3                   	ret    

801005a0 <panic>:

void
panic(char *s)
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];

  cli();
801005a6:	e8 9f fd ff ff       	call   8010034a <cli>
  cons.locking = 0;
801005ab:	c7 05 f4 c5 10 80 00 	movl   $0x0,0x8010c5f4
801005b2:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
801005b5:	e8 7e 2a 00 00       	call   80103038 <lapicid>
801005ba:	83 ec 08             	sub    $0x8,%esp
801005bd:	50                   	push   %eax
801005be:	68 1d 8a 10 80       	push   $0x80108a1d
801005c3:	e8 38 fe ff ff       	call   80100400 <cprintf>
801005c8:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
801005cb:	8b 45 08             	mov    0x8(%ebp),%eax
801005ce:	83 ec 0c             	sub    $0xc,%esp
801005d1:	50                   	push   %eax
801005d2:	e8 29 fe ff ff       	call   80100400 <cprintf>
801005d7:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005da:	83 ec 0c             	sub    $0xc,%esp
801005dd:	68 31 8a 10 80       	push   $0x80108a31
801005e2:	e8 19 fe ff ff       	call   80100400 <cprintf>
801005e7:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005ea:	83 ec 08             	sub    $0x8,%esp
801005ed:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005f0:	50                   	push   %eax
801005f1:	8d 45 08             	lea    0x8(%ebp),%eax
801005f4:	50                   	push   %eax
801005f5:	e8 47 4c 00 00       	call   80105241 <getcallerpcs>
801005fa:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100604:	eb 1c                	jmp    80100622 <panic+0x82>
    cprintf(" %p", pcs[i]);
80100606:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100609:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
8010060d:	83 ec 08             	sub    $0x8,%esp
80100610:	50                   	push   %eax
80100611:	68 33 8a 10 80       	push   $0x80108a33
80100616:	e8 e5 fd ff ff       	call   80100400 <cprintf>
8010061b:	83 c4 10             	add    $0x10,%esp
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
8010061e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100622:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80100626:	7e de                	jle    80100606 <panic+0x66>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
80100628:	c7 05 a0 c5 10 80 01 	movl   $0x1,0x8010c5a0
8010062f:	00 00 00 
  for(;;)
    ;
80100632:	eb fe                	jmp    80100632 <panic+0x92>

80100634 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100634:	55                   	push   %ebp
80100635:	89 e5                	mov    %esp,%ebp
80100637:	83 ec 18             	sub    $0x18,%esp
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
8010063a:	6a 0e                	push   $0xe
8010063c:	68 d4 03 00 00       	push   $0x3d4
80100641:	e8 e5 fc ff ff       	call   8010032b <outb>
80100646:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100649:	68 d5 03 00 00       	push   $0x3d5
8010064e:	e8 bb fc ff ff       	call   8010030e <inb>
80100653:	83 c4 04             	add    $0x4,%esp
80100656:	0f b6 c0             	movzbl %al,%eax
80100659:	c1 e0 08             	shl    $0x8,%eax
8010065c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010065f:	6a 0f                	push   $0xf
80100661:	68 d4 03 00 00       	push   $0x3d4
80100666:	e8 c0 fc ff ff       	call   8010032b <outb>
8010066b:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
8010066e:	68 d5 03 00 00       	push   $0x3d5
80100673:	e8 96 fc ff ff       	call   8010030e <inb>
80100678:	83 c4 04             	add    $0x4,%esp
8010067b:	0f b6 c0             	movzbl %al,%eax
8010067e:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100681:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100685:	75 30                	jne    801006b7 <cgaputc+0x83>
    pos += 80 - pos%80;
80100687:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010068a:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010068f:	89 c8                	mov    %ecx,%eax
80100691:	f7 ea                	imul   %edx
80100693:	c1 fa 05             	sar    $0x5,%edx
80100696:	89 c8                	mov    %ecx,%eax
80100698:	c1 f8 1f             	sar    $0x1f,%eax
8010069b:	29 c2                	sub    %eax,%edx
8010069d:	89 d0                	mov    %edx,%eax
8010069f:	c1 e0 02             	shl    $0x2,%eax
801006a2:	01 d0                	add    %edx,%eax
801006a4:	c1 e0 04             	shl    $0x4,%eax
801006a7:	29 c1                	sub    %eax,%ecx
801006a9:	89 ca                	mov    %ecx,%edx
801006ab:	b8 50 00 00 00       	mov    $0x50,%eax
801006b0:	29 d0                	sub    %edx,%eax
801006b2:	01 45 f4             	add    %eax,-0xc(%ebp)
801006b5:	eb 34                	jmp    801006eb <cgaputc+0xb7>
  else if(c == BACKSPACE){
801006b7:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801006be:	75 0c                	jne    801006cc <cgaputc+0x98>
    if(pos > 0) --pos;
801006c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006c4:	7e 25                	jle    801006eb <cgaputc+0xb7>
801006c6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801006ca:	eb 1f                	jmp    801006eb <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801006cc:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
801006d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006d5:	8d 50 01             	lea    0x1(%eax),%edx
801006d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006db:	01 c0                	add    %eax,%eax
801006dd:	01 c8                	add    %ecx,%eax
801006df:	8b 55 08             	mov    0x8(%ebp),%edx
801006e2:	0f b6 d2             	movzbl %dl,%edx
801006e5:	80 ce 07             	or     $0x7,%dh
801006e8:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
801006eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006ef:	78 09                	js     801006fa <cgaputc+0xc6>
801006f1:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006f8:	7e 0d                	jle    80100707 <cgaputc+0xd3>
    panic("pos under/overflow");
801006fa:	83 ec 0c             	sub    $0xc,%esp
801006fd:	68 37 8a 10 80       	push   $0x80108a37
80100702:	e8 99 fe ff ff       	call   801005a0 <panic>

  if((pos/80) >= 24){  // Scroll up.
80100707:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
8010070e:	7e 4c                	jle    8010075c <cgaputc+0x128>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100710:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100715:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010071b:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100720:	83 ec 04             	sub    $0x4,%esp
80100723:	68 60 0e 00 00       	push   $0xe60
80100728:	52                   	push   %edx
80100729:	50                   	push   %eax
8010072a:	e8 88 4d 00 00       	call   801054b7 <memmove>
8010072f:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
80100732:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100736:	b8 80 07 00 00       	mov    $0x780,%eax
8010073b:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010073e:	8d 14 00             	lea    (%eax,%eax,1),%edx
80100741:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100746:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100749:	01 c9                	add    %ecx,%ecx
8010074b:	01 c8                	add    %ecx,%eax
8010074d:	83 ec 04             	sub    $0x4,%esp
80100750:	52                   	push   %edx
80100751:	6a 00                	push   $0x0
80100753:	50                   	push   %eax
80100754:	e8 9f 4c 00 00       	call   801053f8 <memset>
80100759:	83 c4 10             	add    $0x10,%esp
  }

  outb(CRTPORT, 14);
8010075c:	83 ec 08             	sub    $0x8,%esp
8010075f:	6a 0e                	push   $0xe
80100761:	68 d4 03 00 00       	push   $0x3d4
80100766:	e8 c0 fb ff ff       	call   8010032b <outb>
8010076b:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
8010076e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100771:	c1 f8 08             	sar    $0x8,%eax
80100774:	0f b6 c0             	movzbl %al,%eax
80100777:	83 ec 08             	sub    $0x8,%esp
8010077a:	50                   	push   %eax
8010077b:	68 d5 03 00 00       	push   $0x3d5
80100780:	e8 a6 fb ff ff       	call   8010032b <outb>
80100785:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100788:	83 ec 08             	sub    $0x8,%esp
8010078b:	6a 0f                	push   $0xf
8010078d:	68 d4 03 00 00       	push   $0x3d4
80100792:	e8 94 fb ff ff       	call   8010032b <outb>
80100797:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
8010079a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010079d:	0f b6 c0             	movzbl %al,%eax
801007a0:	83 ec 08             	sub    $0x8,%esp
801007a3:	50                   	push   %eax
801007a4:	68 d5 03 00 00       	push   $0x3d5
801007a9:	e8 7d fb ff ff       	call   8010032b <outb>
801007ae:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
801007b1:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801007b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801007b9:	01 d2                	add    %edx,%edx
801007bb:	01 d0                	add    %edx,%eax
801007bd:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
801007c2:	90                   	nop
801007c3:	c9                   	leave  
801007c4:	c3                   	ret    

801007c5 <consputc>:

void
consputc(int c)
{
801007c5:	55                   	push   %ebp
801007c6:	89 e5                	mov    %esp,%ebp
801007c8:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
801007cb:	a1 a0 c5 10 80       	mov    0x8010c5a0,%eax
801007d0:	85 c0                	test   %eax,%eax
801007d2:	74 07                	je     801007db <consputc+0x16>
    cli();
801007d4:	e8 71 fb ff ff       	call   8010034a <cli>
    for(;;)
      ;
801007d9:	eb fe                	jmp    801007d9 <consputc+0x14>
  }

  if(c == BACKSPACE){
801007db:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007e2:	75 29                	jne    8010080d <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007e4:	83 ec 0c             	sub    $0xc,%esp
801007e7:	6a 08                	push   $0x8
801007e9:	e8 b2 69 00 00       	call   801071a0 <uartputc>
801007ee:	83 c4 10             	add    $0x10,%esp
801007f1:	83 ec 0c             	sub    $0xc,%esp
801007f4:	6a 20                	push   $0x20
801007f6:	e8 a5 69 00 00       	call   801071a0 <uartputc>
801007fb:	83 c4 10             	add    $0x10,%esp
801007fe:	83 ec 0c             	sub    $0xc,%esp
80100801:	6a 08                	push   $0x8
80100803:	e8 98 69 00 00       	call   801071a0 <uartputc>
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	eb 0e                	jmp    8010081b <consputc+0x56>
  } else
    uartputc(c);
8010080d:	83 ec 0c             	sub    $0xc,%esp
80100810:	ff 75 08             	pushl  0x8(%ebp)
80100813:	e8 88 69 00 00       	call   801071a0 <uartputc>
80100818:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
8010081b:	83 ec 0c             	sub    $0xc,%esp
8010081e:	ff 75 08             	pushl  0x8(%ebp)
80100821:	e8 0e fe ff ff       	call   80100634 <cgaputc>
80100826:	83 c4 10             	add    $0x10,%esp
}
80100829:	90                   	nop
8010082a:	c9                   	leave  
8010082b:	c3                   	ret    

8010082c <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
8010082c:	55                   	push   %ebp
8010082d:	89 e5                	mov    %esp,%ebp
8010082f:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
80100832:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
80100839:	83 ec 0c             	sub    $0xc,%esp
8010083c:	68 c0 c5 10 80       	push   $0x8010c5c0
80100841:	e8 3b 49 00 00       	call   80105181 <acquire>
80100846:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100849:	e9 44 01 00 00       	jmp    80100992 <consoleintr+0x166>
    switch(c){
8010084e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100851:	83 f8 10             	cmp    $0x10,%eax
80100854:	74 1e                	je     80100874 <consoleintr+0x48>
80100856:	83 f8 10             	cmp    $0x10,%eax
80100859:	7f 0a                	jg     80100865 <consoleintr+0x39>
8010085b:	83 f8 08             	cmp    $0x8,%eax
8010085e:	74 6b                	je     801008cb <consoleintr+0x9f>
80100860:	e9 9b 00 00 00       	jmp    80100900 <consoleintr+0xd4>
80100865:	83 f8 15             	cmp    $0x15,%eax
80100868:	74 33                	je     8010089d <consoleintr+0x71>
8010086a:	83 f8 7f             	cmp    $0x7f,%eax
8010086d:	74 5c                	je     801008cb <consoleintr+0x9f>
8010086f:	e9 8c 00 00 00       	jmp    80100900 <consoleintr+0xd4>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100874:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
8010087b:	e9 12 01 00 00       	jmp    80100992 <consoleintr+0x166>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100880:	a1 48 20 11 80       	mov    0x80112048,%eax
80100885:	83 e8 01             	sub    $0x1,%eax
80100888:	a3 48 20 11 80       	mov    %eax,0x80112048
        consputc(BACKSPACE);
8010088d:	83 ec 0c             	sub    $0xc,%esp
80100890:	68 00 01 00 00       	push   $0x100
80100895:	e8 2b ff ff ff       	call   801007c5 <consputc>
8010089a:	83 c4 10             	add    $0x10,%esp
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010089d:	8b 15 48 20 11 80    	mov    0x80112048,%edx
801008a3:	a1 44 20 11 80       	mov    0x80112044,%eax
801008a8:	39 c2                	cmp    %eax,%edx
801008aa:	0f 84 e2 00 00 00    	je     80100992 <consoleintr+0x166>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008b0:	a1 48 20 11 80       	mov    0x80112048,%eax
801008b5:	83 e8 01             	sub    $0x1,%eax
801008b8:	83 e0 7f             	and    $0x7f,%eax
801008bb:	0f b6 80 c0 1f 11 80 	movzbl -0x7feee040(%eax),%eax
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008c2:	3c 0a                	cmp    $0xa,%al
801008c4:	75 ba                	jne    80100880 <consoleintr+0x54>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008c6:	e9 c7 00 00 00       	jmp    80100992 <consoleintr+0x166>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801008cb:	8b 15 48 20 11 80    	mov    0x80112048,%edx
801008d1:	a1 44 20 11 80       	mov    0x80112044,%eax
801008d6:	39 c2                	cmp    %eax,%edx
801008d8:	0f 84 b4 00 00 00    	je     80100992 <consoleintr+0x166>
        input.e--;
801008de:	a1 48 20 11 80       	mov    0x80112048,%eax
801008e3:	83 e8 01             	sub    $0x1,%eax
801008e6:	a3 48 20 11 80       	mov    %eax,0x80112048
        consputc(BACKSPACE);
801008eb:	83 ec 0c             	sub    $0xc,%esp
801008ee:	68 00 01 00 00       	push   $0x100
801008f3:	e8 cd fe ff ff       	call   801007c5 <consputc>
801008f8:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008fb:	e9 92 00 00 00       	jmp    80100992 <consoleintr+0x166>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100900:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100904:	0f 84 87 00 00 00    	je     80100991 <consoleintr+0x165>
8010090a:	8b 15 48 20 11 80    	mov    0x80112048,%edx
80100910:	a1 40 20 11 80       	mov    0x80112040,%eax
80100915:	29 c2                	sub    %eax,%edx
80100917:	89 d0                	mov    %edx,%eax
80100919:	83 f8 7f             	cmp    $0x7f,%eax
8010091c:	77 73                	ja     80100991 <consoleintr+0x165>
        c = (c == '\r') ? '\n' : c;
8010091e:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80100922:	74 05                	je     80100929 <consoleintr+0xfd>
80100924:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100927:	eb 05                	jmp    8010092e <consoleintr+0x102>
80100929:	b8 0a 00 00 00       	mov    $0xa,%eax
8010092e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100931:	a1 48 20 11 80       	mov    0x80112048,%eax
80100936:	8d 50 01             	lea    0x1(%eax),%edx
80100939:	89 15 48 20 11 80    	mov    %edx,0x80112048
8010093f:	83 e0 7f             	and    $0x7f,%eax
80100942:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100945:	88 90 c0 1f 11 80    	mov    %dl,-0x7feee040(%eax)
        consputc(c);
8010094b:	83 ec 0c             	sub    $0xc,%esp
8010094e:	ff 75 f0             	pushl  -0x10(%ebp)
80100951:	e8 6f fe ff ff       	call   801007c5 <consputc>
80100956:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100959:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
8010095d:	74 18                	je     80100977 <consoleintr+0x14b>
8010095f:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100963:	74 12                	je     80100977 <consoleintr+0x14b>
80100965:	a1 48 20 11 80       	mov    0x80112048,%eax
8010096a:	8b 15 40 20 11 80    	mov    0x80112040,%edx
80100970:	83 ea 80             	sub    $0xffffff80,%edx
80100973:	39 d0                	cmp    %edx,%eax
80100975:	75 1a                	jne    80100991 <consoleintr+0x165>
          input.w = input.e;
80100977:	a1 48 20 11 80       	mov    0x80112048,%eax
8010097c:	a3 44 20 11 80       	mov    %eax,0x80112044
          wakeup(&input.r);
80100981:	83 ec 0c             	sub    $0xc,%esp
80100984:	68 40 20 11 80       	push   $0x80112040
80100989:	e8 a7 43 00 00       	call   80104d35 <wakeup>
8010098e:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100991:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100992:	8b 45 08             	mov    0x8(%ebp),%eax
80100995:	ff d0                	call   *%eax
80100997:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010099a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010099e:	0f 89 aa fe ff ff    	jns    8010084e <consoleintr+0x22>
        }
      }
      break;
    }
  }
  release(&cons.lock);
801009a4:	83 ec 0c             	sub    $0xc,%esp
801009a7:	68 c0 c5 10 80       	push   $0x8010c5c0
801009ac:	e8 3e 48 00 00       	call   801051ef <release>
801009b1:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009b8:	74 05                	je     801009bf <consoleintr+0x193>
    procdump();  // now call procdump() wo. cons.lock held
801009ba:	e8 41 44 00 00       	call   80104e00 <procdump>
  }
}
801009bf:	90                   	nop
801009c0:	c9                   	leave  
801009c1:	c3                   	ret    

801009c2 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
801009c2:	55                   	push   %ebp
801009c3:	89 e5                	mov    %esp,%ebp
801009c5:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	ff 75 08             	pushl  0x8(%ebp)
801009ce:	e8 9d 11 00 00       	call   80101b70 <iunlock>
801009d3:	83 c4 10             	add    $0x10,%esp
  target = n;
801009d6:	8b 45 10             	mov    0x10(%ebp),%eax
801009d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
801009dc:	83 ec 0c             	sub    $0xc,%esp
801009df:	68 c0 c5 10 80       	push   $0x8010c5c0
801009e4:	e8 98 47 00 00       	call   80105181 <acquire>
801009e9:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009ec:	e9 ab 00 00 00       	jmp    80100a9c <consoleread+0xda>
    while(input.r == input.w){
      if(myproc()->killed){
801009f1:	e8 df 38 00 00       	call   801042d5 <myproc>
801009f6:	8b 40 24             	mov    0x24(%eax),%eax
801009f9:	85 c0                	test   %eax,%eax
801009fb:	74 28                	je     80100a25 <consoleread+0x63>
        release(&cons.lock);
801009fd:	83 ec 0c             	sub    $0xc,%esp
80100a00:	68 c0 c5 10 80       	push   $0x8010c5c0
80100a05:	e8 e5 47 00 00       	call   801051ef <release>
80100a0a:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a0d:	83 ec 0c             	sub    $0xc,%esp
80100a10:	ff 75 08             	pushl  0x8(%ebp)
80100a13:	e8 45 10 00 00       	call   80101a5d <ilock>
80100a18:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a20:	e9 ab 00 00 00       	jmp    80100ad0 <consoleread+0x10e>
      }
      sleep(&input.r, &cons.lock);
80100a25:	83 ec 08             	sub    $0x8,%esp
80100a28:	68 c0 c5 10 80       	push   $0x8010c5c0
80100a2d:	68 40 20 11 80       	push   $0x80112040
80100a32:	e8 15 42 00 00       	call   80104c4c <sleep>
80100a37:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100a3a:	8b 15 40 20 11 80    	mov    0x80112040,%edx
80100a40:	a1 44 20 11 80       	mov    0x80112044,%eax
80100a45:	39 c2                	cmp    %eax,%edx
80100a47:	74 a8                	je     801009f1 <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a49:	a1 40 20 11 80       	mov    0x80112040,%eax
80100a4e:	8d 50 01             	lea    0x1(%eax),%edx
80100a51:	89 15 40 20 11 80    	mov    %edx,0x80112040
80100a57:	83 e0 7f             	and    $0x7f,%eax
80100a5a:	0f b6 80 c0 1f 11 80 	movzbl -0x7feee040(%eax),%eax
80100a61:	0f be c0             	movsbl %al,%eax
80100a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a67:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a6b:	75 17                	jne    80100a84 <consoleread+0xc2>
      if(n < target){
80100a6d:	8b 45 10             	mov    0x10(%ebp),%eax
80100a70:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a73:	73 2f                	jae    80100aa4 <consoleread+0xe2>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a75:	a1 40 20 11 80       	mov    0x80112040,%eax
80100a7a:	83 e8 01             	sub    $0x1,%eax
80100a7d:	a3 40 20 11 80       	mov    %eax,0x80112040
      }
      break;
80100a82:	eb 20                	jmp    80100aa4 <consoleread+0xe2>
    }
    *dst++ = c;
80100a84:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a87:	8d 50 01             	lea    0x1(%eax),%edx
80100a8a:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a8d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a90:	88 10                	mov    %dl,(%eax)
    --n;
80100a92:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a96:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a9a:	74 0b                	je     80100aa7 <consoleread+0xe5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100a9c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100aa0:	7f 98                	jg     80100a3a <consoleread+0x78>
80100aa2:	eb 04                	jmp    80100aa8 <consoleread+0xe6>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100aa4:	90                   	nop
80100aa5:	eb 01                	jmp    80100aa8 <consoleread+0xe6>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100aa7:	90                   	nop
  }
  release(&cons.lock);
80100aa8:	83 ec 0c             	sub    $0xc,%esp
80100aab:	68 c0 c5 10 80       	push   $0x8010c5c0
80100ab0:	e8 3a 47 00 00       	call   801051ef <release>
80100ab5:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100ab8:	83 ec 0c             	sub    $0xc,%esp
80100abb:	ff 75 08             	pushl  0x8(%ebp)
80100abe:	e8 9a 0f 00 00       	call   80101a5d <ilock>
80100ac3:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100ac6:	8b 45 10             	mov    0x10(%ebp),%eax
80100ac9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100acc:	29 c2                	sub    %eax,%edx
80100ace:	89 d0                	mov    %edx,%eax
}
80100ad0:	c9                   	leave  
80100ad1:	c3                   	ret    

80100ad2 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100ad2:	55                   	push   %ebp
80100ad3:	89 e5                	mov    %esp,%ebp
80100ad5:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100ad8:	83 ec 0c             	sub    $0xc,%esp
80100adb:	ff 75 08             	pushl  0x8(%ebp)
80100ade:	e8 8d 10 00 00       	call   80101b70 <iunlock>
80100ae3:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100ae6:	83 ec 0c             	sub    $0xc,%esp
80100ae9:	68 c0 c5 10 80       	push   $0x8010c5c0
80100aee:	e8 8e 46 00 00       	call   80105181 <acquire>
80100af3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100af6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100afd:	eb 21                	jmp    80100b20 <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100aff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b02:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b05:	01 d0                	add    %edx,%eax
80100b07:	0f b6 00             	movzbl (%eax),%eax
80100b0a:	0f be c0             	movsbl %al,%eax
80100b0d:	0f b6 c0             	movzbl %al,%eax
80100b10:	83 ec 0c             	sub    $0xc,%esp
80100b13:	50                   	push   %eax
80100b14:	e8 ac fc ff ff       	call   801007c5 <consputc>
80100b19:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100b1c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b23:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b26:	7c d7                	jl     80100aff <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100b28:	83 ec 0c             	sub    $0xc,%esp
80100b2b:	68 c0 c5 10 80       	push   $0x8010c5c0
80100b30:	e8 ba 46 00 00       	call   801051ef <release>
80100b35:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b38:	83 ec 0c             	sub    $0xc,%esp
80100b3b:	ff 75 08             	pushl  0x8(%ebp)
80100b3e:	e8 1a 0f 00 00       	call   80101a5d <ilock>
80100b43:	83 c4 10             	add    $0x10,%esp

  return n;
80100b46:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b49:	c9                   	leave  
80100b4a:	c3                   	ret    

80100b4b <consoleinit>:

void
consoleinit(void)
{
80100b4b:	55                   	push   %ebp
80100b4c:	89 e5                	mov    %esp,%ebp
80100b4e:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100b51:	83 ec 08             	sub    $0x8,%esp
80100b54:	68 4a 8a 10 80       	push   $0x80108a4a
80100b59:	68 c0 c5 10 80       	push   $0x8010c5c0
80100b5e:	e8 fc 45 00 00       	call   8010515f <initlock>
80100b63:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b66:	c7 05 0c 2a 11 80 d2 	movl   $0x80100ad2,0x80112a0c
80100b6d:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b70:	c7 05 08 2a 11 80 c2 	movl   $0x801009c2,0x80112a08
80100b77:	09 10 80 
  cons.locking = 1;
80100b7a:	c7 05 f4 c5 10 80 01 	movl   $0x1,0x8010c5f4
80100b81:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100b84:	83 ec 08             	sub    $0x8,%esp
80100b87:	6a 00                	push   $0x0
80100b89:	6a 01                	push   $0x1
80100b8b:	e8 e1 1f 00 00       	call   80102b71 <ioapicenable>
80100b90:	83 c4 10             	add    $0x10,%esp
}
80100b93:	90                   	nop
80100b94:	c9                   	leave  
80100b95:	c3                   	ret    

80100b96 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b96:	55                   	push   %ebp
80100b97:	89 e5                	mov    %esp,%ebp
80100b99:	81 ec 18 01 00 00    	sub    $0x118,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b9f:	e8 31 37 00 00       	call   801042d5 <myproc>
80100ba4:	89 45 d0             	mov    %eax,-0x30(%ebp)

  //reset signal handlers
  if(curproc!=0){
80100ba7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
80100bab:	74 47                	je     80100bf4 <exec+0x5e>
    for(i=0; i<32; i++){
80100bad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100bb4:	eb 38                	jmp    80100bee <exec+0x58>
      if(curproc->handlers[i] != SIG_DFL && curproc->handlers[i] != (void*)SIG_IGN )
80100bb6:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100bb9:	8b 55 ec             	mov    -0x14(%ebp),%edx
80100bbc:	83 c2 20             	add    $0x20,%edx
80100bbf:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80100bc3:	85 c0                	test   %eax,%eax
80100bc5:	74 23                	je     80100bea <exec+0x54>
80100bc7:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100bca:	8b 55 ec             	mov    -0x14(%ebp),%edx
80100bcd:	83 c2 20             	add    $0x20,%edx
80100bd0:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80100bd4:	83 f8 01             	cmp    $0x1,%eax
80100bd7:	74 11                	je     80100bea <exec+0x54>
        curproc->handlers[i]=SIG_DFL;
80100bd9:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100bdc:	8b 55 ec             	mov    -0x14(%ebp),%edx
80100bdf:	83 c2 20             	add    $0x20,%edx
80100be2:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80100be9:	00 
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();

  //reset signal handlers
  if(curproc!=0){
    for(i=0; i<32; i++){
80100bea:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100bee:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
80100bf2:	7e c2                	jle    80100bb6 <exec+0x20>
      if(curproc->handlers[i] != SIG_DFL && curproc->handlers[i] != (void*)SIG_IGN )
        curproc->handlers[i]=SIG_DFL;
    }
  }
  begin_op();
80100bf4:	e8 89 29 00 00       	call   80103582 <begin_op>

  if((ip = namei(path)) == 0){
80100bf9:	83 ec 0c             	sub    $0xc,%esp
80100bfc:	ff 75 08             	pushl  0x8(%ebp)
80100bff:	e8 99 19 00 00       	call   8010259d <namei>
80100c04:	83 c4 10             	add    $0x10,%esp
80100c07:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100c0a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100c0e:	75 1f                	jne    80100c2f <exec+0x99>
    end_op();
80100c10:	e8 f9 29 00 00       	call   8010360e <end_op>
    cprintf("exec: fail\n");
80100c15:	83 ec 0c             	sub    $0xc,%esp
80100c18:	68 52 8a 10 80       	push   $0x80108a52
80100c1d:	e8 de f7 ff ff       	call   80100400 <cprintf>
80100c22:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c2a:	e9 f1 03 00 00       	jmp    80101020 <exec+0x48a>
  }
  ilock(ip);
80100c2f:	83 ec 0c             	sub    $0xc,%esp
80100c32:	ff 75 d8             	pushl  -0x28(%ebp)
80100c35:	e8 23 0e 00 00       	call   80101a5d <ilock>
80100c3a:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100c3d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100c44:	6a 34                	push   $0x34
80100c46:	6a 00                	push   $0x0
80100c48:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100c4e:	50                   	push   %eax
80100c4f:	ff 75 d8             	pushl  -0x28(%ebp)
80100c52:	e8 f7 12 00 00       	call   80101f4e <readi>
80100c57:	83 c4 10             	add    $0x10,%esp
80100c5a:	83 f8 34             	cmp    $0x34,%eax
80100c5d:	0f 85 66 03 00 00    	jne    80100fc9 <exec+0x433>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c63:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100c69:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c6e:	0f 85 58 03 00 00    	jne    80100fcc <exec+0x436>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c74:	e8 23 75 00 00       	call   8010819c <setupkvm>
80100c79:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c7c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c80:	0f 84 49 03 00 00    	je     80100fcf <exec+0x439>
    goto bad;

  // Load program into memory.
  sz = 0;
80100c86:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c8d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c94:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100c9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c9d:	e9 de 00 00 00       	jmp    80100d80 <exec+0x1ea>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ca2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100ca5:	6a 20                	push   $0x20
80100ca7:	50                   	push   %eax
80100ca8:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100cae:	50                   	push   %eax
80100caf:	ff 75 d8             	pushl  -0x28(%ebp)
80100cb2:	e8 97 12 00 00       	call   80101f4e <readi>
80100cb7:	83 c4 10             	add    $0x10,%esp
80100cba:	83 f8 20             	cmp    $0x20,%eax
80100cbd:	0f 85 0f 03 00 00    	jne    80100fd2 <exec+0x43c>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100cc3:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100cc9:	83 f8 01             	cmp    $0x1,%eax
80100ccc:	0f 85 a0 00 00 00    	jne    80100d72 <exec+0x1dc>
      continue;
    if(ph.memsz < ph.filesz)
80100cd2:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100cd8:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100cde:	39 c2                	cmp    %eax,%edx
80100ce0:	0f 82 ef 02 00 00    	jb     80100fd5 <exec+0x43f>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ce6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100cec:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100cf2:	01 c2                	add    %eax,%edx
80100cf4:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cfa:	39 c2                	cmp    %eax,%edx
80100cfc:	0f 82 d6 02 00 00    	jb     80100fd8 <exec+0x442>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100d02:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100d08:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100d0e:	01 d0                	add    %edx,%eax
80100d10:	83 ec 04             	sub    $0x4,%esp
80100d13:	50                   	push   %eax
80100d14:	ff 75 e0             	pushl  -0x20(%ebp)
80100d17:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d1a:	e8 22 78 00 00       	call   80108541 <allocuvm>
80100d1f:	83 c4 10             	add    $0x10,%esp
80100d22:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d25:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d29:	0f 84 ac 02 00 00    	je     80100fdb <exec+0x445>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100d2f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d35:	25 ff 0f 00 00       	and    $0xfff,%eax
80100d3a:	85 c0                	test   %eax,%eax
80100d3c:	0f 85 9c 02 00 00    	jne    80100fde <exec+0x448>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d42:	8b 95 f8 fe ff ff    	mov    -0x108(%ebp),%edx
80100d48:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100d4e:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100d54:	83 ec 0c             	sub    $0xc,%esp
80100d57:	52                   	push   %edx
80100d58:	50                   	push   %eax
80100d59:	ff 75 d8             	pushl  -0x28(%ebp)
80100d5c:	51                   	push   %ecx
80100d5d:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d60:	e8 0f 77 00 00       	call   80108474 <loaduvm>
80100d65:	83 c4 20             	add    $0x20,%esp
80100d68:	85 c0                	test   %eax,%eax
80100d6a:	0f 88 71 02 00 00    	js     80100fe1 <exec+0x44b>
80100d70:	eb 01                	jmp    80100d73 <exec+0x1dd>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100d72:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d73:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100d77:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d7a:	83 c0 20             	add    $0x20,%eax
80100d7d:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d80:	0f b7 85 34 ff ff ff 	movzwl -0xcc(%ebp),%eax
80100d87:	0f b7 c0             	movzwl %ax,%eax
80100d8a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100d8d:	0f 8f 0f ff ff ff    	jg     80100ca2 <exec+0x10c>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100d93:	83 ec 0c             	sub    $0xc,%esp
80100d96:	ff 75 d8             	pushl  -0x28(%ebp)
80100d99:	e8 f0 0e 00 00       	call   80101c8e <iunlockput>
80100d9e:	83 c4 10             	add    $0x10,%esp
  end_op();
80100da1:	e8 68 28 00 00       	call   8010360e <end_op>
  ip = 0;
80100da6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100dad:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100db0:	05 ff 0f 00 00       	add    $0xfff,%eax
80100db5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100dba:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100dbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dc0:	05 00 20 00 00       	add    $0x2000,%eax
80100dc5:	83 ec 04             	sub    $0x4,%esp
80100dc8:	50                   	push   %eax
80100dc9:	ff 75 e0             	pushl  -0x20(%ebp)
80100dcc:	ff 75 d4             	pushl  -0x2c(%ebp)
80100dcf:	e8 6d 77 00 00       	call   80108541 <allocuvm>
80100dd4:	83 c4 10             	add    $0x10,%esp
80100dd7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100dda:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100dde:	0f 84 00 02 00 00    	je     80100fe4 <exec+0x44e>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100de4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100de7:	2d 00 20 00 00       	sub    $0x2000,%eax
80100dec:	83 ec 08             	sub    $0x8,%esp
80100def:	50                   	push   %eax
80100df0:	ff 75 d4             	pushl  -0x2c(%ebp)
80100df3:	e8 ab 79 00 00       	call   801087a3 <clearpteu>
80100df8:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100dfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dfe:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e01:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100e08:	e9 96 00 00 00       	jmp    80100ea3 <exec+0x30d>
    if(argc >= MAXARG)
80100e0d:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100e11:	0f 87 d0 01 00 00    	ja     80100fe7 <exec+0x451>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e1a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e21:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e24:	01 d0                	add    %edx,%eax
80100e26:	8b 00                	mov    (%eax),%eax
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	50                   	push   %eax
80100e2c:	e8 14 48 00 00       	call   80105645 <strlen>
80100e31:	83 c4 10             	add    $0x10,%esp
80100e34:	89 c2                	mov    %eax,%edx
80100e36:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e39:	29 d0                	sub    %edx,%eax
80100e3b:	83 e8 01             	sub    $0x1,%eax
80100e3e:	83 e0 fc             	and    $0xfffffffc,%eax
80100e41:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e47:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e51:	01 d0                	add    %edx,%eax
80100e53:	8b 00                	mov    (%eax),%eax
80100e55:	83 ec 0c             	sub    $0xc,%esp
80100e58:	50                   	push   %eax
80100e59:	e8 e7 47 00 00       	call   80105645 <strlen>
80100e5e:	83 c4 10             	add    $0x10,%esp
80100e61:	83 c0 01             	add    $0x1,%eax
80100e64:	89 c1                	mov    %eax,%ecx
80100e66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e69:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e70:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e73:	01 d0                	add    %edx,%eax
80100e75:	8b 00                	mov    (%eax),%eax
80100e77:	51                   	push   %ecx
80100e78:	50                   	push   %eax
80100e79:	ff 75 dc             	pushl  -0x24(%ebp)
80100e7c:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e7f:	e8 be 7a 00 00       	call   80108942 <copyout>
80100e84:	83 c4 10             	add    $0x10,%esp
80100e87:	85 c0                	test   %eax,%eax
80100e89:	0f 88 5b 01 00 00    	js     80100fea <exec+0x454>
      goto bad;
    ustack[3+argc] = sp;
80100e8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e92:	8d 50 03             	lea    0x3(%eax),%edx
80100e95:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e98:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e9f:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100ea3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ea6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ead:	8b 45 0c             	mov    0xc(%ebp),%eax
80100eb0:	01 d0                	add    %edx,%eax
80100eb2:	8b 00                	mov    (%eax),%eax
80100eb4:	85 c0                	test   %eax,%eax
80100eb6:	0f 85 51 ff ff ff    	jne    80100e0d <exec+0x277>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100ebc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ebf:	83 c0 03             	add    $0x3,%eax
80100ec2:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100ec9:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100ecd:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100ed4:	ff ff ff 
  ustack[1] = argc;
80100ed7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eda:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ee0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ee3:	83 c0 01             	add    $0x1,%eax
80100ee6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100eed:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ef0:	29 d0                	sub    %edx,%eax
80100ef2:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100ef8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100efb:	83 c0 04             	add    $0x4,%eax
80100efe:	c1 e0 02             	shl    $0x2,%eax
80100f01:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100f04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f07:	83 c0 04             	add    $0x4,%eax
80100f0a:	c1 e0 02             	shl    $0x2,%eax
80100f0d:	50                   	push   %eax
80100f0e:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100f14:	50                   	push   %eax
80100f15:	ff 75 dc             	pushl  -0x24(%ebp)
80100f18:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f1b:	e8 22 7a 00 00       	call   80108942 <copyout>
80100f20:	83 c4 10             	add    $0x10,%esp
80100f23:	85 c0                	test   %eax,%eax
80100f25:	0f 88 c2 00 00 00    	js     80100fed <exec+0x457>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f2b:	8b 45 08             	mov    0x8(%ebp),%eax
80100f2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f34:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100f37:	eb 17                	jmp    80100f50 <exec+0x3ba>
    if(*s == '/')
80100f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f3c:	0f b6 00             	movzbl (%eax),%eax
80100f3f:	3c 2f                	cmp    $0x2f,%al
80100f41:	75 09                	jne    80100f4c <exec+0x3b6>
      last = s+1;
80100f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f46:	83 c0 01             	add    $0x1,%eax
80100f49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f4c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f53:	0f b6 00             	movzbl (%eax),%eax
80100f56:	84 c0                	test   %al,%al
80100f58:	75 df                	jne    80100f39 <exec+0x3a3>
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100f5a:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f5d:	83 c0 6c             	add    $0x6c,%eax
80100f60:	83 ec 04             	sub    $0x4,%esp
80100f63:	6a 10                	push   $0x10
80100f65:	ff 75 f0             	pushl  -0x10(%ebp)
80100f68:	50                   	push   %eax
80100f69:	e8 8d 46 00 00       	call   801055fb <safestrcpy>
80100f6e:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100f71:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f74:	8b 40 04             	mov    0x4(%eax),%eax
80100f77:	89 45 cc             	mov    %eax,-0x34(%ebp)
  curproc->pgdir = pgdir;
80100f7a:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f7d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f80:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100f83:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f86:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f89:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100f8b:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f8e:	8b 40 18             	mov    0x18(%eax),%eax
80100f91:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100f97:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100f9a:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f9d:	8b 40 18             	mov    0x18(%eax),%eax
80100fa0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100fa3:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
80100fa6:	83 ec 0c             	sub    $0xc,%esp
80100fa9:	ff 75 d0             	pushl  -0x30(%ebp)
80100fac:	e8 b5 72 00 00       	call   80108266 <switchuvm>
80100fb1:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100fb4:	83 ec 0c             	sub    $0xc,%esp
80100fb7:	ff 75 cc             	pushl  -0x34(%ebp)
80100fba:	e8 4b 77 00 00       	call   8010870a <freevm>
80100fbf:	83 c4 10             	add    $0x10,%esp
  return 0;
80100fc2:	b8 00 00 00 00       	mov    $0x0,%eax
80100fc7:	eb 57                	jmp    80101020 <exec+0x48a>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
80100fc9:	90                   	nop
80100fca:	eb 22                	jmp    80100fee <exec+0x458>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100fcc:	90                   	nop
80100fcd:	eb 1f                	jmp    80100fee <exec+0x458>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100fcf:	90                   	nop
80100fd0:	eb 1c                	jmp    80100fee <exec+0x458>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100fd2:	90                   	nop
80100fd3:	eb 19                	jmp    80100fee <exec+0x458>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100fd5:	90                   	nop
80100fd6:	eb 16                	jmp    80100fee <exec+0x458>
    if(ph.vaddr + ph.memsz < ph.vaddr)
      goto bad;
80100fd8:	90                   	nop
80100fd9:	eb 13                	jmp    80100fee <exec+0x458>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100fdb:	90                   	nop
80100fdc:	eb 10                	jmp    80100fee <exec+0x458>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
80100fde:	90                   	nop
80100fdf:	eb 0d                	jmp    80100fee <exec+0x458>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100fe1:	90                   	nop
80100fe2:	eb 0a                	jmp    80100fee <exec+0x458>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100fe4:	90                   	nop
80100fe5:	eb 07                	jmp    80100fee <exec+0x458>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100fe7:	90                   	nop
80100fe8:	eb 04                	jmp    80100fee <exec+0x458>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100fea:	90                   	nop
80100feb:	eb 01                	jmp    80100fee <exec+0x458>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100fed:	90                   	nop
  switchuvm(curproc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100fee:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100ff2:	74 0e                	je     80101002 <exec+0x46c>
    freevm(pgdir);
80100ff4:	83 ec 0c             	sub    $0xc,%esp
80100ff7:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ffa:	e8 0b 77 00 00       	call   8010870a <freevm>
80100fff:	83 c4 10             	add    $0x10,%esp
  if(ip){
80101002:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80101006:	74 13                	je     8010101b <exec+0x485>
    iunlockput(ip);
80101008:	83 ec 0c             	sub    $0xc,%esp
8010100b:	ff 75 d8             	pushl  -0x28(%ebp)
8010100e:	e8 7b 0c 00 00       	call   80101c8e <iunlockput>
80101013:	83 c4 10             	add    $0x10,%esp
    end_op();
80101016:	e8 f3 25 00 00       	call   8010360e <end_op>
  }
  return -1;
8010101b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101020:	c9                   	leave  
80101021:	c3                   	ret    

80101022 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101022:	55                   	push   %ebp
80101023:	89 e5                	mov    %esp,%ebp
80101025:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80101028:	83 ec 08             	sub    $0x8,%esp
8010102b:	68 5e 8a 10 80       	push   $0x80108a5e
80101030:	68 60 20 11 80       	push   $0x80112060
80101035:	e8 25 41 00 00       	call   8010515f <initlock>
8010103a:	83 c4 10             	add    $0x10,%esp
}
8010103d:	90                   	nop
8010103e:	c9                   	leave  
8010103f:	c3                   	ret    

80101040 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80101046:	83 ec 0c             	sub    $0xc,%esp
80101049:	68 60 20 11 80       	push   $0x80112060
8010104e:	e8 2e 41 00 00       	call   80105181 <acquire>
80101053:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101056:	c7 45 f4 94 20 11 80 	movl   $0x80112094,-0xc(%ebp)
8010105d:	eb 2d                	jmp    8010108c <filealloc+0x4c>
    if(f->ref == 0){
8010105f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101062:	8b 40 04             	mov    0x4(%eax),%eax
80101065:	85 c0                	test   %eax,%eax
80101067:	75 1f                	jne    80101088 <filealloc+0x48>
      f->ref = 1;
80101069:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010106c:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101073:	83 ec 0c             	sub    $0xc,%esp
80101076:	68 60 20 11 80       	push   $0x80112060
8010107b:	e8 6f 41 00 00       	call   801051ef <release>
80101080:	83 c4 10             	add    $0x10,%esp
      return f;
80101083:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101086:	eb 23                	jmp    801010ab <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101088:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
8010108c:	b8 f4 29 11 80       	mov    $0x801129f4,%eax
80101091:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101094:	72 c9                	jb     8010105f <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80101096:	83 ec 0c             	sub    $0xc,%esp
80101099:	68 60 20 11 80       	push   $0x80112060
8010109e:	e8 4c 41 00 00       	call   801051ef <release>
801010a3:	83 c4 10             	add    $0x10,%esp
  return 0;
801010a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801010ab:	c9                   	leave  
801010ac:	c3                   	ret    

801010ad <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801010ad:	55                   	push   %ebp
801010ae:	89 e5                	mov    %esp,%ebp
801010b0:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
801010b3:	83 ec 0c             	sub    $0xc,%esp
801010b6:	68 60 20 11 80       	push   $0x80112060
801010bb:	e8 c1 40 00 00       	call   80105181 <acquire>
801010c0:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010c3:	8b 45 08             	mov    0x8(%ebp),%eax
801010c6:	8b 40 04             	mov    0x4(%eax),%eax
801010c9:	85 c0                	test   %eax,%eax
801010cb:	7f 0d                	jg     801010da <filedup+0x2d>
    panic("filedup");
801010cd:	83 ec 0c             	sub    $0xc,%esp
801010d0:	68 65 8a 10 80       	push   $0x80108a65
801010d5:	e8 c6 f4 ff ff       	call   801005a0 <panic>
  f->ref++;
801010da:	8b 45 08             	mov    0x8(%ebp),%eax
801010dd:	8b 40 04             	mov    0x4(%eax),%eax
801010e0:	8d 50 01             	lea    0x1(%eax),%edx
801010e3:	8b 45 08             	mov    0x8(%ebp),%eax
801010e6:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801010e9:	83 ec 0c             	sub    $0xc,%esp
801010ec:	68 60 20 11 80       	push   $0x80112060
801010f1:	e8 f9 40 00 00       	call   801051ef <release>
801010f6:	83 c4 10             	add    $0x10,%esp
  return f;
801010f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
801010fc:	c9                   	leave  
801010fd:	c3                   	ret    

801010fe <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801010fe:	55                   	push   %ebp
801010ff:	89 e5                	mov    %esp,%ebp
80101101:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
80101104:	83 ec 0c             	sub    $0xc,%esp
80101107:	68 60 20 11 80       	push   $0x80112060
8010110c:	e8 70 40 00 00       	call   80105181 <acquire>
80101111:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101114:	8b 45 08             	mov    0x8(%ebp),%eax
80101117:	8b 40 04             	mov    0x4(%eax),%eax
8010111a:	85 c0                	test   %eax,%eax
8010111c:	7f 0d                	jg     8010112b <fileclose+0x2d>
    panic("fileclose");
8010111e:	83 ec 0c             	sub    $0xc,%esp
80101121:	68 6d 8a 10 80       	push   $0x80108a6d
80101126:	e8 75 f4 ff ff       	call   801005a0 <panic>
  if(--f->ref > 0){
8010112b:	8b 45 08             	mov    0x8(%ebp),%eax
8010112e:	8b 40 04             	mov    0x4(%eax),%eax
80101131:	8d 50 ff             	lea    -0x1(%eax),%edx
80101134:	8b 45 08             	mov    0x8(%ebp),%eax
80101137:	89 50 04             	mov    %edx,0x4(%eax)
8010113a:	8b 45 08             	mov    0x8(%ebp),%eax
8010113d:	8b 40 04             	mov    0x4(%eax),%eax
80101140:	85 c0                	test   %eax,%eax
80101142:	7e 15                	jle    80101159 <fileclose+0x5b>
    release(&ftable.lock);
80101144:	83 ec 0c             	sub    $0xc,%esp
80101147:	68 60 20 11 80       	push   $0x80112060
8010114c:	e8 9e 40 00 00       	call   801051ef <release>
80101151:	83 c4 10             	add    $0x10,%esp
80101154:	e9 8b 00 00 00       	jmp    801011e4 <fileclose+0xe6>
    return;
  }
  ff = *f;
80101159:	8b 45 08             	mov    0x8(%ebp),%eax
8010115c:	8b 10                	mov    (%eax),%edx
8010115e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101161:	8b 50 04             	mov    0x4(%eax),%edx
80101164:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101167:	8b 50 08             	mov    0x8(%eax),%edx
8010116a:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010116d:	8b 50 0c             	mov    0xc(%eax),%edx
80101170:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101173:	8b 50 10             	mov    0x10(%eax),%edx
80101176:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101179:	8b 40 14             	mov    0x14(%eax),%eax
8010117c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
8010117f:	8b 45 08             	mov    0x8(%ebp),%eax
80101182:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101189:	8b 45 08             	mov    0x8(%ebp),%eax
8010118c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101192:	83 ec 0c             	sub    $0xc,%esp
80101195:	68 60 20 11 80       	push   $0x80112060
8010119a:	e8 50 40 00 00       	call   801051ef <release>
8010119f:	83 c4 10             	add    $0x10,%esp

  if(ff.type == FD_PIPE)
801011a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011a5:	83 f8 01             	cmp    $0x1,%eax
801011a8:	75 19                	jne    801011c3 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
801011aa:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801011ae:	0f be d0             	movsbl %al,%edx
801011b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801011b4:	83 ec 08             	sub    $0x8,%esp
801011b7:	52                   	push   %edx
801011b8:	50                   	push   %eax
801011b9:	e8 a1 2d 00 00       	call   80103f5f <pipeclose>
801011be:	83 c4 10             	add    $0x10,%esp
801011c1:	eb 21                	jmp    801011e4 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
801011c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011c6:	83 f8 02             	cmp    $0x2,%eax
801011c9:	75 19                	jne    801011e4 <fileclose+0xe6>
    begin_op();
801011cb:	e8 b2 23 00 00       	call   80103582 <begin_op>
    iput(ff.ip);
801011d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801011d3:	83 ec 0c             	sub    $0xc,%esp
801011d6:	50                   	push   %eax
801011d7:	e8 e2 09 00 00       	call   80101bbe <iput>
801011dc:	83 c4 10             	add    $0x10,%esp
    end_op();
801011df:	e8 2a 24 00 00       	call   8010360e <end_op>
  }
}
801011e4:	c9                   	leave  
801011e5:	c3                   	ret    

801011e6 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801011e6:	55                   	push   %ebp
801011e7:	89 e5                	mov    %esp,%ebp
801011e9:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
801011ec:	8b 45 08             	mov    0x8(%ebp),%eax
801011ef:	8b 00                	mov    (%eax),%eax
801011f1:	83 f8 02             	cmp    $0x2,%eax
801011f4:	75 40                	jne    80101236 <filestat+0x50>
    ilock(f->ip);
801011f6:	8b 45 08             	mov    0x8(%ebp),%eax
801011f9:	8b 40 10             	mov    0x10(%eax),%eax
801011fc:	83 ec 0c             	sub    $0xc,%esp
801011ff:	50                   	push   %eax
80101200:	e8 58 08 00 00       	call   80101a5d <ilock>
80101205:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
80101208:	8b 45 08             	mov    0x8(%ebp),%eax
8010120b:	8b 40 10             	mov    0x10(%eax),%eax
8010120e:	83 ec 08             	sub    $0x8,%esp
80101211:	ff 75 0c             	pushl  0xc(%ebp)
80101214:	50                   	push   %eax
80101215:	e8 ee 0c 00 00       	call   80101f08 <stati>
8010121a:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
8010121d:	8b 45 08             	mov    0x8(%ebp),%eax
80101220:	8b 40 10             	mov    0x10(%eax),%eax
80101223:	83 ec 0c             	sub    $0xc,%esp
80101226:	50                   	push   %eax
80101227:	e8 44 09 00 00       	call   80101b70 <iunlock>
8010122c:	83 c4 10             	add    $0x10,%esp
    return 0;
8010122f:	b8 00 00 00 00       	mov    $0x0,%eax
80101234:	eb 05                	jmp    8010123b <filestat+0x55>
  }
  return -1;
80101236:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010123b:	c9                   	leave  
8010123c:	c3                   	ret    

8010123d <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
8010123d:	55                   	push   %ebp
8010123e:	89 e5                	mov    %esp,%ebp
80101240:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
80101243:	8b 45 08             	mov    0x8(%ebp),%eax
80101246:	0f b6 40 08          	movzbl 0x8(%eax),%eax
8010124a:	84 c0                	test   %al,%al
8010124c:	75 0a                	jne    80101258 <fileread+0x1b>
    return -1;
8010124e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101253:	e9 9b 00 00 00       	jmp    801012f3 <fileread+0xb6>
  if(f->type == FD_PIPE)
80101258:	8b 45 08             	mov    0x8(%ebp),%eax
8010125b:	8b 00                	mov    (%eax),%eax
8010125d:	83 f8 01             	cmp    $0x1,%eax
80101260:	75 1a                	jne    8010127c <fileread+0x3f>
    return piperead(f->pipe, addr, n);
80101262:	8b 45 08             	mov    0x8(%ebp),%eax
80101265:	8b 40 0c             	mov    0xc(%eax),%eax
80101268:	83 ec 04             	sub    $0x4,%esp
8010126b:	ff 75 10             	pushl  0x10(%ebp)
8010126e:	ff 75 0c             	pushl  0xc(%ebp)
80101271:	50                   	push   %eax
80101272:	e8 8f 2e 00 00       	call   80104106 <piperead>
80101277:	83 c4 10             	add    $0x10,%esp
8010127a:	eb 77                	jmp    801012f3 <fileread+0xb6>
  if(f->type == FD_INODE){
8010127c:	8b 45 08             	mov    0x8(%ebp),%eax
8010127f:	8b 00                	mov    (%eax),%eax
80101281:	83 f8 02             	cmp    $0x2,%eax
80101284:	75 60                	jne    801012e6 <fileread+0xa9>
    ilock(f->ip);
80101286:	8b 45 08             	mov    0x8(%ebp),%eax
80101289:	8b 40 10             	mov    0x10(%eax),%eax
8010128c:	83 ec 0c             	sub    $0xc,%esp
8010128f:	50                   	push   %eax
80101290:	e8 c8 07 00 00       	call   80101a5d <ilock>
80101295:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101298:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010129b:	8b 45 08             	mov    0x8(%ebp),%eax
8010129e:	8b 50 14             	mov    0x14(%eax),%edx
801012a1:	8b 45 08             	mov    0x8(%ebp),%eax
801012a4:	8b 40 10             	mov    0x10(%eax),%eax
801012a7:	51                   	push   %ecx
801012a8:	52                   	push   %edx
801012a9:	ff 75 0c             	pushl  0xc(%ebp)
801012ac:	50                   	push   %eax
801012ad:	e8 9c 0c 00 00       	call   80101f4e <readi>
801012b2:	83 c4 10             	add    $0x10,%esp
801012b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801012b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801012bc:	7e 11                	jle    801012cf <fileread+0x92>
      f->off += r;
801012be:	8b 45 08             	mov    0x8(%ebp),%eax
801012c1:	8b 50 14             	mov    0x14(%eax),%edx
801012c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012c7:	01 c2                	add    %eax,%edx
801012c9:	8b 45 08             	mov    0x8(%ebp),%eax
801012cc:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801012cf:	8b 45 08             	mov    0x8(%ebp),%eax
801012d2:	8b 40 10             	mov    0x10(%eax),%eax
801012d5:	83 ec 0c             	sub    $0xc,%esp
801012d8:	50                   	push   %eax
801012d9:	e8 92 08 00 00       	call   80101b70 <iunlock>
801012de:	83 c4 10             	add    $0x10,%esp
    return r;
801012e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012e4:	eb 0d                	jmp    801012f3 <fileread+0xb6>
  }
  panic("fileread");
801012e6:	83 ec 0c             	sub    $0xc,%esp
801012e9:	68 77 8a 10 80       	push   $0x80108a77
801012ee:	e8 ad f2 ff ff       	call   801005a0 <panic>
}
801012f3:	c9                   	leave  
801012f4:	c3                   	ret    

801012f5 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801012f5:	55                   	push   %ebp
801012f6:	89 e5                	mov    %esp,%ebp
801012f8:	53                   	push   %ebx
801012f9:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
801012fc:	8b 45 08             	mov    0x8(%ebp),%eax
801012ff:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80101303:	84 c0                	test   %al,%al
80101305:	75 0a                	jne    80101311 <filewrite+0x1c>
    return -1;
80101307:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010130c:	e9 1b 01 00 00       	jmp    8010142c <filewrite+0x137>
  if(f->type == FD_PIPE)
80101311:	8b 45 08             	mov    0x8(%ebp),%eax
80101314:	8b 00                	mov    (%eax),%eax
80101316:	83 f8 01             	cmp    $0x1,%eax
80101319:	75 1d                	jne    80101338 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
8010131b:	8b 45 08             	mov    0x8(%ebp),%eax
8010131e:	8b 40 0c             	mov    0xc(%eax),%eax
80101321:	83 ec 04             	sub    $0x4,%esp
80101324:	ff 75 10             	pushl  0x10(%ebp)
80101327:	ff 75 0c             	pushl  0xc(%ebp)
8010132a:	50                   	push   %eax
8010132b:	e8 d9 2c 00 00       	call   80104009 <pipewrite>
80101330:	83 c4 10             	add    $0x10,%esp
80101333:	e9 f4 00 00 00       	jmp    8010142c <filewrite+0x137>
  if(f->type == FD_INODE){
80101338:	8b 45 08             	mov    0x8(%ebp),%eax
8010133b:	8b 00                	mov    (%eax),%eax
8010133d:	83 f8 02             	cmp    $0x2,%eax
80101340:	0f 85 d9 00 00 00    	jne    8010141f <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
80101346:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
8010134d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101354:	e9 a3 00 00 00       	jmp    801013fc <filewrite+0x107>
      int n1 = n - i;
80101359:	8b 45 10             	mov    0x10(%ebp),%eax
8010135c:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010135f:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101362:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101365:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101368:	7e 06                	jle    80101370 <filewrite+0x7b>
        n1 = max;
8010136a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010136d:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101370:	e8 0d 22 00 00       	call   80103582 <begin_op>
      ilock(f->ip);
80101375:	8b 45 08             	mov    0x8(%ebp),%eax
80101378:	8b 40 10             	mov    0x10(%eax),%eax
8010137b:	83 ec 0c             	sub    $0xc,%esp
8010137e:	50                   	push   %eax
8010137f:	e8 d9 06 00 00       	call   80101a5d <ilock>
80101384:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101387:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010138a:	8b 45 08             	mov    0x8(%ebp),%eax
8010138d:	8b 50 14             	mov    0x14(%eax),%edx
80101390:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101393:	8b 45 0c             	mov    0xc(%ebp),%eax
80101396:	01 c3                	add    %eax,%ebx
80101398:	8b 45 08             	mov    0x8(%ebp),%eax
8010139b:	8b 40 10             	mov    0x10(%eax),%eax
8010139e:	51                   	push   %ecx
8010139f:	52                   	push   %edx
801013a0:	53                   	push   %ebx
801013a1:	50                   	push   %eax
801013a2:	e8 fe 0c 00 00       	call   801020a5 <writei>
801013a7:	83 c4 10             	add    $0x10,%esp
801013aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
801013ad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013b1:	7e 11                	jle    801013c4 <filewrite+0xcf>
        f->off += r;
801013b3:	8b 45 08             	mov    0x8(%ebp),%eax
801013b6:	8b 50 14             	mov    0x14(%eax),%edx
801013b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013bc:	01 c2                	add    %eax,%edx
801013be:	8b 45 08             	mov    0x8(%ebp),%eax
801013c1:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801013c4:	8b 45 08             	mov    0x8(%ebp),%eax
801013c7:	8b 40 10             	mov    0x10(%eax),%eax
801013ca:	83 ec 0c             	sub    $0xc,%esp
801013cd:	50                   	push   %eax
801013ce:	e8 9d 07 00 00       	call   80101b70 <iunlock>
801013d3:	83 c4 10             	add    $0x10,%esp
      end_op();
801013d6:	e8 33 22 00 00       	call   8010360e <end_op>

      if(r < 0)
801013db:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013df:	78 29                	js     8010140a <filewrite+0x115>
        break;
      if(r != n1)
801013e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013e4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801013e7:	74 0d                	je     801013f6 <filewrite+0x101>
        panic("short filewrite");
801013e9:	83 ec 0c             	sub    $0xc,%esp
801013ec:	68 80 8a 10 80       	push   $0x80108a80
801013f1:	e8 aa f1 ff ff       	call   801005a0 <panic>
      i += r;
801013f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013f9:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801013fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013ff:	3b 45 10             	cmp    0x10(%ebp),%eax
80101402:	0f 8c 51 ff ff ff    	jl     80101359 <filewrite+0x64>
80101408:	eb 01                	jmp    8010140b <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
8010140a:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010140b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010140e:	3b 45 10             	cmp    0x10(%ebp),%eax
80101411:	75 05                	jne    80101418 <filewrite+0x123>
80101413:	8b 45 10             	mov    0x10(%ebp),%eax
80101416:	eb 14                	jmp    8010142c <filewrite+0x137>
80101418:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010141d:	eb 0d                	jmp    8010142c <filewrite+0x137>
  }
  panic("filewrite");
8010141f:	83 ec 0c             	sub    $0xc,%esp
80101422:	68 90 8a 10 80       	push   $0x80108a90
80101427:	e8 74 f1 ff ff       	call   801005a0 <panic>
}
8010142c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010142f:	c9                   	leave  
80101430:	c3                   	ret    

80101431 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101431:	55                   	push   %ebp
80101432:	89 e5                	mov    %esp,%ebp
80101434:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, 1);
80101437:	8b 45 08             	mov    0x8(%ebp),%eax
8010143a:	83 ec 08             	sub    $0x8,%esp
8010143d:	6a 01                	push   $0x1
8010143f:	50                   	push   %eax
80101440:	e8 89 ed ff ff       	call   801001ce <bread>
80101445:	83 c4 10             	add    $0x10,%esp
80101448:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010144b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010144e:	83 c0 5c             	add    $0x5c,%eax
80101451:	83 ec 04             	sub    $0x4,%esp
80101454:	6a 1c                	push   $0x1c
80101456:	50                   	push   %eax
80101457:	ff 75 0c             	pushl  0xc(%ebp)
8010145a:	e8 58 40 00 00       	call   801054b7 <memmove>
8010145f:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101462:	83 ec 0c             	sub    $0xc,%esp
80101465:	ff 75 f4             	pushl  -0xc(%ebp)
80101468:	e8 e3 ed ff ff       	call   80100250 <brelse>
8010146d:	83 c4 10             	add    $0x10,%esp
}
80101470:	90                   	nop
80101471:	c9                   	leave  
80101472:	c3                   	ret    

80101473 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101473:	55                   	push   %ebp
80101474:	89 e5                	mov    %esp,%ebp
80101476:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, bno);
80101479:	8b 55 0c             	mov    0xc(%ebp),%edx
8010147c:	8b 45 08             	mov    0x8(%ebp),%eax
8010147f:	83 ec 08             	sub    $0x8,%esp
80101482:	52                   	push   %edx
80101483:	50                   	push   %eax
80101484:	e8 45 ed ff ff       	call   801001ce <bread>
80101489:	83 c4 10             	add    $0x10,%esp
8010148c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
8010148f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101492:	83 c0 5c             	add    $0x5c,%eax
80101495:	83 ec 04             	sub    $0x4,%esp
80101498:	68 00 02 00 00       	push   $0x200
8010149d:	6a 00                	push   $0x0
8010149f:	50                   	push   %eax
801014a0:	e8 53 3f 00 00       	call   801053f8 <memset>
801014a5:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801014a8:	83 ec 0c             	sub    $0xc,%esp
801014ab:	ff 75 f4             	pushl  -0xc(%ebp)
801014ae:	e8 07 23 00 00       	call   801037ba <log_write>
801014b3:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801014b6:	83 ec 0c             	sub    $0xc,%esp
801014b9:	ff 75 f4             	pushl  -0xc(%ebp)
801014bc:	e8 8f ed ff ff       	call   80100250 <brelse>
801014c1:	83 c4 10             	add    $0x10,%esp
}
801014c4:	90                   	nop
801014c5:	c9                   	leave  
801014c6:	c3                   	ret    

801014c7 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801014c7:	55                   	push   %ebp
801014c8:	89 e5                	mov    %esp,%ebp
801014ca:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801014cd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801014d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801014db:	e9 13 01 00 00       	jmp    801015f3 <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
801014e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014e3:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801014e9:	85 c0                	test   %eax,%eax
801014eb:	0f 48 c2             	cmovs  %edx,%eax
801014ee:	c1 f8 0c             	sar    $0xc,%eax
801014f1:	89 c2                	mov    %eax,%edx
801014f3:	a1 78 2a 11 80       	mov    0x80112a78,%eax
801014f8:	01 d0                	add    %edx,%eax
801014fa:	83 ec 08             	sub    $0x8,%esp
801014fd:	50                   	push   %eax
801014fe:	ff 75 08             	pushl  0x8(%ebp)
80101501:	e8 c8 ec ff ff       	call   801001ce <bread>
80101506:	83 c4 10             	add    $0x10,%esp
80101509:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010150c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101513:	e9 a6 00 00 00       	jmp    801015be <balloc+0xf7>
      m = 1 << (bi % 8);
80101518:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010151b:	99                   	cltd   
8010151c:	c1 ea 1d             	shr    $0x1d,%edx
8010151f:	01 d0                	add    %edx,%eax
80101521:	83 e0 07             	and    $0x7,%eax
80101524:	29 d0                	sub    %edx,%eax
80101526:	ba 01 00 00 00       	mov    $0x1,%edx
8010152b:	89 c1                	mov    %eax,%ecx
8010152d:	d3 e2                	shl    %cl,%edx
8010152f:	89 d0                	mov    %edx,%eax
80101531:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101534:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101537:	8d 50 07             	lea    0x7(%eax),%edx
8010153a:	85 c0                	test   %eax,%eax
8010153c:	0f 48 c2             	cmovs  %edx,%eax
8010153f:	c1 f8 03             	sar    $0x3,%eax
80101542:	89 c2                	mov    %eax,%edx
80101544:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101547:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
8010154c:	0f b6 c0             	movzbl %al,%eax
8010154f:	23 45 e8             	and    -0x18(%ebp),%eax
80101552:	85 c0                	test   %eax,%eax
80101554:	75 64                	jne    801015ba <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
80101556:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101559:	8d 50 07             	lea    0x7(%eax),%edx
8010155c:	85 c0                	test   %eax,%eax
8010155e:	0f 48 c2             	cmovs  %edx,%eax
80101561:	c1 f8 03             	sar    $0x3,%eax
80101564:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101567:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
8010156c:	89 d1                	mov    %edx,%ecx
8010156e:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101571:	09 ca                	or     %ecx,%edx
80101573:	89 d1                	mov    %edx,%ecx
80101575:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101578:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
8010157c:	83 ec 0c             	sub    $0xc,%esp
8010157f:	ff 75 ec             	pushl  -0x14(%ebp)
80101582:	e8 33 22 00 00       	call   801037ba <log_write>
80101587:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
8010158a:	83 ec 0c             	sub    $0xc,%esp
8010158d:	ff 75 ec             	pushl  -0x14(%ebp)
80101590:	e8 bb ec ff ff       	call   80100250 <brelse>
80101595:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101598:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010159b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010159e:	01 c2                	add    %eax,%edx
801015a0:	8b 45 08             	mov    0x8(%ebp),%eax
801015a3:	83 ec 08             	sub    $0x8,%esp
801015a6:	52                   	push   %edx
801015a7:	50                   	push   %eax
801015a8:	e8 c6 fe ff ff       	call   80101473 <bzero>
801015ad:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801015b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015b6:	01 d0                	add    %edx,%eax
801015b8:	eb 57                	jmp    80101611 <balloc+0x14a>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015ba:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801015be:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801015c5:	7f 17                	jg     801015de <balloc+0x117>
801015c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015cd:	01 d0                	add    %edx,%eax
801015cf:	89 c2                	mov    %eax,%edx
801015d1:	a1 60 2a 11 80       	mov    0x80112a60,%eax
801015d6:	39 c2                	cmp    %eax,%edx
801015d8:	0f 82 3a ff ff ff    	jb     80101518 <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801015de:	83 ec 0c             	sub    $0xc,%esp
801015e1:	ff 75 ec             	pushl  -0x14(%ebp)
801015e4:	e8 67 ec ff ff       	call   80100250 <brelse>
801015e9:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801015ec:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801015f3:	8b 15 60 2a 11 80    	mov    0x80112a60,%edx
801015f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015fc:	39 c2                	cmp    %eax,%edx
801015fe:	0f 87 dc fe ff ff    	ja     801014e0 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101604:	83 ec 0c             	sub    $0xc,%esp
80101607:	68 9c 8a 10 80       	push   $0x80108a9c
8010160c:	e8 8f ef ff ff       	call   801005a0 <panic>
}
80101611:	c9                   	leave  
80101612:	c3                   	ret    

80101613 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101613:	55                   	push   %ebp
80101614:	89 e5                	mov    %esp,%ebp
80101616:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101619:	83 ec 08             	sub    $0x8,%esp
8010161c:	68 60 2a 11 80       	push   $0x80112a60
80101621:	ff 75 08             	pushl  0x8(%ebp)
80101624:	e8 08 fe ff ff       	call   80101431 <readsb>
80101629:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
8010162c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010162f:	c1 e8 0c             	shr    $0xc,%eax
80101632:	89 c2                	mov    %eax,%edx
80101634:	a1 78 2a 11 80       	mov    0x80112a78,%eax
80101639:	01 c2                	add    %eax,%edx
8010163b:	8b 45 08             	mov    0x8(%ebp),%eax
8010163e:	83 ec 08             	sub    $0x8,%esp
80101641:	52                   	push   %edx
80101642:	50                   	push   %eax
80101643:	e8 86 eb ff ff       	call   801001ce <bread>
80101648:	83 c4 10             	add    $0x10,%esp
8010164b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
8010164e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101651:	25 ff 0f 00 00       	and    $0xfff,%eax
80101656:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101659:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010165c:	99                   	cltd   
8010165d:	c1 ea 1d             	shr    $0x1d,%edx
80101660:	01 d0                	add    %edx,%eax
80101662:	83 e0 07             	and    $0x7,%eax
80101665:	29 d0                	sub    %edx,%eax
80101667:	ba 01 00 00 00       	mov    $0x1,%edx
8010166c:	89 c1                	mov    %eax,%ecx
8010166e:	d3 e2                	shl    %cl,%edx
80101670:	89 d0                	mov    %edx,%eax
80101672:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101675:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101678:	8d 50 07             	lea    0x7(%eax),%edx
8010167b:	85 c0                	test   %eax,%eax
8010167d:	0f 48 c2             	cmovs  %edx,%eax
80101680:	c1 f8 03             	sar    $0x3,%eax
80101683:	89 c2                	mov    %eax,%edx
80101685:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101688:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
8010168d:	0f b6 c0             	movzbl %al,%eax
80101690:	23 45 ec             	and    -0x14(%ebp),%eax
80101693:	85 c0                	test   %eax,%eax
80101695:	75 0d                	jne    801016a4 <bfree+0x91>
    panic("freeing free block");
80101697:	83 ec 0c             	sub    $0xc,%esp
8010169a:	68 b2 8a 10 80       	push   $0x80108ab2
8010169f:	e8 fc ee ff ff       	call   801005a0 <panic>
  bp->data[bi/8] &= ~m;
801016a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016a7:	8d 50 07             	lea    0x7(%eax),%edx
801016aa:	85 c0                	test   %eax,%eax
801016ac:	0f 48 c2             	cmovs  %edx,%eax
801016af:	c1 f8 03             	sar    $0x3,%eax
801016b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016b5:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
801016ba:	89 d1                	mov    %edx,%ecx
801016bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
801016bf:	f7 d2                	not    %edx
801016c1:	21 ca                	and    %ecx,%edx
801016c3:	89 d1                	mov    %edx,%ecx
801016c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016c8:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
801016cc:	83 ec 0c             	sub    $0xc,%esp
801016cf:	ff 75 f4             	pushl  -0xc(%ebp)
801016d2:	e8 e3 20 00 00       	call   801037ba <log_write>
801016d7:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801016da:	83 ec 0c             	sub    $0xc,%esp
801016dd:	ff 75 f4             	pushl  -0xc(%ebp)
801016e0:	e8 6b eb ff ff       	call   80100250 <brelse>
801016e5:	83 c4 10             	add    $0x10,%esp
}
801016e8:	90                   	nop
801016e9:	c9                   	leave  
801016ea:	c3                   	ret    

801016eb <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801016eb:	55                   	push   %ebp
801016ec:	89 e5                	mov    %esp,%ebp
801016ee:	57                   	push   %edi
801016ef:	56                   	push   %esi
801016f0:	53                   	push   %ebx
801016f1:	83 ec 2c             	sub    $0x2c,%esp
  int i = 0;
801016f4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
801016fb:	83 ec 08             	sub    $0x8,%esp
801016fe:	68 c5 8a 10 80       	push   $0x80108ac5
80101703:	68 80 2a 11 80       	push   $0x80112a80
80101708:	e8 52 3a 00 00       	call   8010515f <initlock>
8010170d:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
80101710:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101717:	eb 2d                	jmp    80101746 <iinit+0x5b>
    initsleeplock(&icache.inode[i].lock, "inode");
80101719:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010171c:	89 d0                	mov    %edx,%eax
8010171e:	c1 e0 03             	shl    $0x3,%eax
80101721:	01 d0                	add    %edx,%eax
80101723:	c1 e0 04             	shl    $0x4,%eax
80101726:	83 c0 30             	add    $0x30,%eax
80101729:	05 80 2a 11 80       	add    $0x80112a80,%eax
8010172e:	83 c0 10             	add    $0x10,%eax
80101731:	83 ec 08             	sub    $0x8,%esp
80101734:	68 cc 8a 10 80       	push   $0x80108acc
80101739:	50                   	push   %eax
8010173a:	e8 c3 38 00 00       	call   80105002 <initsleeplock>
8010173f:	83 c4 10             	add    $0x10,%esp
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101742:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80101746:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
8010174a:	7e cd                	jle    80101719 <iinit+0x2e>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
8010174c:	83 ec 08             	sub    $0x8,%esp
8010174f:	68 60 2a 11 80       	push   $0x80112a60
80101754:	ff 75 08             	pushl  0x8(%ebp)
80101757:	e8 d5 fc ff ff       	call   80101431 <readsb>
8010175c:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010175f:	a1 78 2a 11 80       	mov    0x80112a78,%eax
80101764:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80101767:	8b 3d 74 2a 11 80    	mov    0x80112a74,%edi
8010176d:	8b 35 70 2a 11 80    	mov    0x80112a70,%esi
80101773:	8b 1d 6c 2a 11 80    	mov    0x80112a6c,%ebx
80101779:	8b 0d 68 2a 11 80    	mov    0x80112a68,%ecx
8010177f:	8b 15 64 2a 11 80    	mov    0x80112a64,%edx
80101785:	a1 60 2a 11 80       	mov    0x80112a60,%eax
8010178a:	ff 75 d4             	pushl  -0x2c(%ebp)
8010178d:	57                   	push   %edi
8010178e:	56                   	push   %esi
8010178f:	53                   	push   %ebx
80101790:	51                   	push   %ecx
80101791:	52                   	push   %edx
80101792:	50                   	push   %eax
80101793:	68 d4 8a 10 80       	push   $0x80108ad4
80101798:	e8 63 ec ff ff       	call   80100400 <cprintf>
8010179d:	83 c4 20             	add    $0x20,%esp
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801017a0:	90                   	nop
801017a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017a4:	5b                   	pop    %ebx
801017a5:	5e                   	pop    %esi
801017a6:	5f                   	pop    %edi
801017a7:	5d                   	pop    %ebp
801017a8:	c3                   	ret    

801017a9 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801017a9:	55                   	push   %ebp
801017aa:	89 e5                	mov    %esp,%ebp
801017ac:	83 ec 28             	sub    $0x28,%esp
801017af:	8b 45 0c             	mov    0xc(%ebp),%eax
801017b2:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801017b6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801017bd:	e9 9e 00 00 00       	jmp    80101860 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
801017c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c5:	c1 e8 03             	shr    $0x3,%eax
801017c8:	89 c2                	mov    %eax,%edx
801017ca:	a1 74 2a 11 80       	mov    0x80112a74,%eax
801017cf:	01 d0                	add    %edx,%eax
801017d1:	83 ec 08             	sub    $0x8,%esp
801017d4:	50                   	push   %eax
801017d5:	ff 75 08             	pushl  0x8(%ebp)
801017d8:	e8 f1 e9 ff ff       	call   801001ce <bread>
801017dd:	83 c4 10             	add    $0x10,%esp
801017e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801017e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017e6:	8d 50 5c             	lea    0x5c(%eax),%edx
801017e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ec:	83 e0 07             	and    $0x7,%eax
801017ef:	c1 e0 06             	shl    $0x6,%eax
801017f2:	01 d0                	add    %edx,%eax
801017f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801017f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017fa:	0f b7 00             	movzwl (%eax),%eax
801017fd:	66 85 c0             	test   %ax,%ax
80101800:	75 4c                	jne    8010184e <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
80101802:	83 ec 04             	sub    $0x4,%esp
80101805:	6a 40                	push   $0x40
80101807:	6a 00                	push   $0x0
80101809:	ff 75 ec             	pushl  -0x14(%ebp)
8010180c:	e8 e7 3b 00 00       	call   801053f8 <memset>
80101811:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
80101814:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101817:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
8010181b:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
8010181e:	83 ec 0c             	sub    $0xc,%esp
80101821:	ff 75 f0             	pushl  -0x10(%ebp)
80101824:	e8 91 1f 00 00       	call   801037ba <log_write>
80101829:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
8010182c:	83 ec 0c             	sub    $0xc,%esp
8010182f:	ff 75 f0             	pushl  -0x10(%ebp)
80101832:	e8 19 ea ff ff       	call   80100250 <brelse>
80101837:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
8010183a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010183d:	83 ec 08             	sub    $0x8,%esp
80101840:	50                   	push   %eax
80101841:	ff 75 08             	pushl  0x8(%ebp)
80101844:	e8 f8 00 00 00       	call   80101941 <iget>
80101849:	83 c4 10             	add    $0x10,%esp
8010184c:	eb 30                	jmp    8010187e <ialloc+0xd5>
    }
    brelse(bp);
8010184e:	83 ec 0c             	sub    $0xc,%esp
80101851:	ff 75 f0             	pushl  -0x10(%ebp)
80101854:	e8 f7 e9 ff ff       	call   80100250 <brelse>
80101859:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010185c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101860:	8b 15 68 2a 11 80    	mov    0x80112a68,%edx
80101866:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101869:	39 c2                	cmp    %eax,%edx
8010186b:	0f 87 51 ff ff ff    	ja     801017c2 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101871:	83 ec 0c             	sub    $0xc,%esp
80101874:	68 27 8b 10 80       	push   $0x80108b27
80101879:	e8 22 ed ff ff       	call   801005a0 <panic>
}
8010187e:	c9                   	leave  
8010187f:	c3                   	ret    

80101880 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101886:	8b 45 08             	mov    0x8(%ebp),%eax
80101889:	8b 40 04             	mov    0x4(%eax),%eax
8010188c:	c1 e8 03             	shr    $0x3,%eax
8010188f:	89 c2                	mov    %eax,%edx
80101891:	a1 74 2a 11 80       	mov    0x80112a74,%eax
80101896:	01 c2                	add    %eax,%edx
80101898:	8b 45 08             	mov    0x8(%ebp),%eax
8010189b:	8b 00                	mov    (%eax),%eax
8010189d:	83 ec 08             	sub    $0x8,%esp
801018a0:	52                   	push   %edx
801018a1:	50                   	push   %eax
801018a2:	e8 27 e9 ff ff       	call   801001ce <bread>
801018a7:	83 c4 10             	add    $0x10,%esp
801018aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801018ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b0:	8d 50 5c             	lea    0x5c(%eax),%edx
801018b3:	8b 45 08             	mov    0x8(%ebp),%eax
801018b6:	8b 40 04             	mov    0x4(%eax),%eax
801018b9:	83 e0 07             	and    $0x7,%eax
801018bc:	c1 e0 06             	shl    $0x6,%eax
801018bf:	01 d0                	add    %edx,%eax
801018c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801018c4:	8b 45 08             	mov    0x8(%ebp),%eax
801018c7:	0f b7 50 50          	movzwl 0x50(%eax),%edx
801018cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018ce:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801018d1:	8b 45 08             	mov    0x8(%ebp),%eax
801018d4:	0f b7 50 52          	movzwl 0x52(%eax),%edx
801018d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018db:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801018df:	8b 45 08             	mov    0x8(%ebp),%eax
801018e2:	0f b7 50 54          	movzwl 0x54(%eax),%edx
801018e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018e9:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801018ed:	8b 45 08             	mov    0x8(%ebp),%eax
801018f0:	0f b7 50 56          	movzwl 0x56(%eax),%edx
801018f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018f7:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801018fb:	8b 45 08             	mov    0x8(%ebp),%eax
801018fe:	8b 50 58             	mov    0x58(%eax),%edx
80101901:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101904:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101907:	8b 45 08             	mov    0x8(%ebp),%eax
8010190a:	8d 50 5c             	lea    0x5c(%eax),%edx
8010190d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101910:	83 c0 0c             	add    $0xc,%eax
80101913:	83 ec 04             	sub    $0x4,%esp
80101916:	6a 34                	push   $0x34
80101918:	52                   	push   %edx
80101919:	50                   	push   %eax
8010191a:	e8 98 3b 00 00       	call   801054b7 <memmove>
8010191f:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101922:	83 ec 0c             	sub    $0xc,%esp
80101925:	ff 75 f4             	pushl  -0xc(%ebp)
80101928:	e8 8d 1e 00 00       	call   801037ba <log_write>
8010192d:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101930:	83 ec 0c             	sub    $0xc,%esp
80101933:	ff 75 f4             	pushl  -0xc(%ebp)
80101936:	e8 15 e9 ff ff       	call   80100250 <brelse>
8010193b:	83 c4 10             	add    $0x10,%esp
}
8010193e:	90                   	nop
8010193f:	c9                   	leave  
80101940:	c3                   	ret    

80101941 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101941:	55                   	push   %ebp
80101942:	89 e5                	mov    %esp,%ebp
80101944:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101947:	83 ec 0c             	sub    $0xc,%esp
8010194a:	68 80 2a 11 80       	push   $0x80112a80
8010194f:	e8 2d 38 00 00       	call   80105181 <acquire>
80101954:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101957:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010195e:	c7 45 f4 b4 2a 11 80 	movl   $0x80112ab4,-0xc(%ebp)
80101965:	eb 60                	jmp    801019c7 <iget+0x86>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101967:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010196a:	8b 40 08             	mov    0x8(%eax),%eax
8010196d:	85 c0                	test   %eax,%eax
8010196f:	7e 39                	jle    801019aa <iget+0x69>
80101971:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101974:	8b 00                	mov    (%eax),%eax
80101976:	3b 45 08             	cmp    0x8(%ebp),%eax
80101979:	75 2f                	jne    801019aa <iget+0x69>
8010197b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010197e:	8b 40 04             	mov    0x4(%eax),%eax
80101981:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101984:	75 24                	jne    801019aa <iget+0x69>
      ip->ref++;
80101986:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101989:	8b 40 08             	mov    0x8(%eax),%eax
8010198c:	8d 50 01             	lea    0x1(%eax),%edx
8010198f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101992:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101995:	83 ec 0c             	sub    $0xc,%esp
80101998:	68 80 2a 11 80       	push   $0x80112a80
8010199d:	e8 4d 38 00 00       	call   801051ef <release>
801019a2:	83 c4 10             	add    $0x10,%esp
      return ip;
801019a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019a8:	eb 77                	jmp    80101a21 <iget+0xe0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801019aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801019ae:	75 10                	jne    801019c0 <iget+0x7f>
801019b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019b3:	8b 40 08             	mov    0x8(%eax),%eax
801019b6:	85 c0                	test   %eax,%eax
801019b8:	75 06                	jne    801019c0 <iget+0x7f>
      empty = ip;
801019ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019bd:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801019c0:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
801019c7:	81 7d f4 d4 46 11 80 	cmpl   $0x801146d4,-0xc(%ebp)
801019ce:	72 97                	jb     80101967 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801019d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801019d4:	75 0d                	jne    801019e3 <iget+0xa2>
    panic("iget: no inodes");
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	68 39 8b 10 80       	push   $0x80108b39
801019de:	e8 bd eb ff ff       	call   801005a0 <panic>

  ip = empty;
801019e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801019e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019ec:	8b 55 08             	mov    0x8(%ebp),%edx
801019ef:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801019f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019f4:	8b 55 0c             	mov    0xc(%ebp),%edx
801019f7:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801019fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019fd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
80101a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a07:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
80101a0e:	83 ec 0c             	sub    $0xc,%esp
80101a11:	68 80 2a 11 80       	push   $0x80112a80
80101a16:	e8 d4 37 00 00       	call   801051ef <release>
80101a1b:	83 c4 10             	add    $0x10,%esp

  return ip;
80101a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101a21:	c9                   	leave  
80101a22:	c3                   	ret    

80101a23 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101a23:	55                   	push   %ebp
80101a24:	89 e5                	mov    %esp,%ebp
80101a26:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101a29:	83 ec 0c             	sub    $0xc,%esp
80101a2c:	68 80 2a 11 80       	push   $0x80112a80
80101a31:	e8 4b 37 00 00       	call   80105181 <acquire>
80101a36:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101a39:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3c:	8b 40 08             	mov    0x8(%eax),%eax
80101a3f:	8d 50 01             	lea    0x1(%eax),%edx
80101a42:	8b 45 08             	mov    0x8(%ebp),%eax
80101a45:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101a48:	83 ec 0c             	sub    $0xc,%esp
80101a4b:	68 80 2a 11 80       	push   $0x80112a80
80101a50:	e8 9a 37 00 00       	call   801051ef <release>
80101a55:	83 c4 10             	add    $0x10,%esp
  return ip;
80101a58:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101a5b:	c9                   	leave  
80101a5c:	c3                   	ret    

80101a5d <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101a5d:	55                   	push   %ebp
80101a5e:	89 e5                	mov    %esp,%ebp
80101a60:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101a63:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a67:	74 0a                	je     80101a73 <ilock+0x16>
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 40 08             	mov    0x8(%eax),%eax
80101a6f:	85 c0                	test   %eax,%eax
80101a71:	7f 0d                	jg     80101a80 <ilock+0x23>
    panic("ilock");
80101a73:	83 ec 0c             	sub    $0xc,%esp
80101a76:	68 49 8b 10 80       	push   $0x80108b49
80101a7b:	e8 20 eb ff ff       	call   801005a0 <panic>

  acquiresleep(&ip->lock);
80101a80:	8b 45 08             	mov    0x8(%ebp),%eax
80101a83:	83 c0 0c             	add    $0xc,%eax
80101a86:	83 ec 0c             	sub    $0xc,%esp
80101a89:	50                   	push   %eax
80101a8a:	e8 af 35 00 00       	call   8010503e <acquiresleep>
80101a8f:	83 c4 10             	add    $0x10,%esp

  if(ip->valid == 0){
80101a92:	8b 45 08             	mov    0x8(%ebp),%eax
80101a95:	8b 40 4c             	mov    0x4c(%eax),%eax
80101a98:	85 c0                	test   %eax,%eax
80101a9a:	0f 85 cd 00 00 00    	jne    80101b6d <ilock+0x110>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101aa0:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa3:	8b 40 04             	mov    0x4(%eax),%eax
80101aa6:	c1 e8 03             	shr    $0x3,%eax
80101aa9:	89 c2                	mov    %eax,%edx
80101aab:	a1 74 2a 11 80       	mov    0x80112a74,%eax
80101ab0:	01 c2                	add    %eax,%edx
80101ab2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab5:	8b 00                	mov    (%eax),%eax
80101ab7:	83 ec 08             	sub    $0x8,%esp
80101aba:	52                   	push   %edx
80101abb:	50                   	push   %eax
80101abc:	e8 0d e7 ff ff       	call   801001ce <bread>
80101ac1:	83 c4 10             	add    $0x10,%esp
80101ac4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101aca:	8d 50 5c             	lea    0x5c(%eax),%edx
80101acd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad0:	8b 40 04             	mov    0x4(%eax),%eax
80101ad3:	83 e0 07             	and    $0x7,%eax
80101ad6:	c1 e0 06             	shl    $0x6,%eax
80101ad9:	01 d0                	add    %edx,%eax
80101adb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ae1:	0f b7 10             	movzwl (%eax),%edx
80101ae4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae7:	66 89 50 50          	mov    %dx,0x50(%eax)
    ip->major = dip->major;
80101aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aee:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101af2:	8b 45 08             	mov    0x8(%ebp),%eax
80101af5:	66 89 50 52          	mov    %dx,0x52(%eax)
    ip->minor = dip->minor;
80101af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101afc:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101b00:	8b 45 08             	mov    0x8(%ebp),%eax
80101b03:	66 89 50 54          	mov    %dx,0x54(%eax)
    ip->nlink = dip->nlink;
80101b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b0a:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101b0e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b11:	66 89 50 56          	mov    %dx,0x56(%eax)
    ip->size = dip->size;
80101b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b18:	8b 50 08             	mov    0x8(%eax),%edx
80101b1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1e:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b24:	8d 50 0c             	lea    0xc(%eax),%edx
80101b27:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2a:	83 c0 5c             	add    $0x5c,%eax
80101b2d:	83 ec 04             	sub    $0x4,%esp
80101b30:	6a 34                	push   $0x34
80101b32:	52                   	push   %edx
80101b33:	50                   	push   %eax
80101b34:	e8 7e 39 00 00       	call   801054b7 <memmove>
80101b39:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101b3c:	83 ec 0c             	sub    $0xc,%esp
80101b3f:	ff 75 f4             	pushl  -0xc(%ebp)
80101b42:	e8 09 e7 ff ff       	call   80100250 <brelse>
80101b47:	83 c4 10             	add    $0x10,%esp
    ip->valid = 1;
80101b4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4d:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101b54:	8b 45 08             	mov    0x8(%ebp),%eax
80101b57:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101b5b:	66 85 c0             	test   %ax,%ax
80101b5e:	75 0d                	jne    80101b6d <ilock+0x110>
      panic("ilock: no type");
80101b60:	83 ec 0c             	sub    $0xc,%esp
80101b63:	68 4f 8b 10 80       	push   $0x80108b4f
80101b68:	e8 33 ea ff ff       	call   801005a0 <panic>
  }
}
80101b6d:	90                   	nop
80101b6e:	c9                   	leave  
80101b6f:	c3                   	ret    

80101b70 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b7a:	74 20                	je     80101b9c <iunlock+0x2c>
80101b7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7f:	83 c0 0c             	add    $0xc,%eax
80101b82:	83 ec 0c             	sub    $0xc,%esp
80101b85:	50                   	push   %eax
80101b86:	e8 65 35 00 00       	call   801050f0 <holdingsleep>
80101b8b:	83 c4 10             	add    $0x10,%esp
80101b8e:	85 c0                	test   %eax,%eax
80101b90:	74 0a                	je     80101b9c <iunlock+0x2c>
80101b92:	8b 45 08             	mov    0x8(%ebp),%eax
80101b95:	8b 40 08             	mov    0x8(%eax),%eax
80101b98:	85 c0                	test   %eax,%eax
80101b9a:	7f 0d                	jg     80101ba9 <iunlock+0x39>
    panic("iunlock");
80101b9c:	83 ec 0c             	sub    $0xc,%esp
80101b9f:	68 5e 8b 10 80       	push   $0x80108b5e
80101ba4:	e8 f7 e9 ff ff       	call   801005a0 <panic>

  releasesleep(&ip->lock);
80101ba9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bac:	83 c0 0c             	add    $0xc,%eax
80101baf:	83 ec 0c             	sub    $0xc,%esp
80101bb2:	50                   	push   %eax
80101bb3:	e8 ea 34 00 00       	call   801050a2 <releasesleep>
80101bb8:	83 c4 10             	add    $0x10,%esp
}
80101bbb:	90                   	nop
80101bbc:	c9                   	leave  
80101bbd:	c3                   	ret    

80101bbe <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101bbe:	55                   	push   %ebp
80101bbf:	89 e5                	mov    %esp,%ebp
80101bc1:	83 ec 18             	sub    $0x18,%esp
  acquiresleep(&ip->lock);
80101bc4:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc7:	83 c0 0c             	add    $0xc,%eax
80101bca:	83 ec 0c             	sub    $0xc,%esp
80101bcd:	50                   	push   %eax
80101bce:	e8 6b 34 00 00       	call   8010503e <acquiresleep>
80101bd3:	83 c4 10             	add    $0x10,%esp
  if(ip->valid && ip->nlink == 0){
80101bd6:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd9:	8b 40 4c             	mov    0x4c(%eax),%eax
80101bdc:	85 c0                	test   %eax,%eax
80101bde:	74 6a                	je     80101c4a <iput+0x8c>
80101be0:	8b 45 08             	mov    0x8(%ebp),%eax
80101be3:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80101be7:	66 85 c0             	test   %ax,%ax
80101bea:	75 5e                	jne    80101c4a <iput+0x8c>
    acquire(&icache.lock);
80101bec:	83 ec 0c             	sub    $0xc,%esp
80101bef:	68 80 2a 11 80       	push   $0x80112a80
80101bf4:	e8 88 35 00 00       	call   80105181 <acquire>
80101bf9:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101bfc:	8b 45 08             	mov    0x8(%ebp),%eax
80101bff:	8b 40 08             	mov    0x8(%eax),%eax
80101c02:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101c05:	83 ec 0c             	sub    $0xc,%esp
80101c08:	68 80 2a 11 80       	push   $0x80112a80
80101c0d:	e8 dd 35 00 00       	call   801051ef <release>
80101c12:	83 c4 10             	add    $0x10,%esp
    if(r == 1){
80101c15:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101c19:	75 2f                	jne    80101c4a <iput+0x8c>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101c1b:	83 ec 0c             	sub    $0xc,%esp
80101c1e:	ff 75 08             	pushl  0x8(%ebp)
80101c21:	e8 b2 01 00 00       	call   80101dd8 <itrunc>
80101c26:	83 c4 10             	add    $0x10,%esp
      ip->type = 0;
80101c29:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2c:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101c32:	83 ec 0c             	sub    $0xc,%esp
80101c35:	ff 75 08             	pushl  0x8(%ebp)
80101c38:	e8 43 fc ff ff       	call   80101880 <iupdate>
80101c3d:	83 c4 10             	add    $0x10,%esp
      ip->valid = 0;
80101c40:	8b 45 08             	mov    0x8(%ebp),%eax
80101c43:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101c4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4d:	83 c0 0c             	add    $0xc,%eax
80101c50:	83 ec 0c             	sub    $0xc,%esp
80101c53:	50                   	push   %eax
80101c54:	e8 49 34 00 00       	call   801050a2 <releasesleep>
80101c59:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101c5c:	83 ec 0c             	sub    $0xc,%esp
80101c5f:	68 80 2a 11 80       	push   $0x80112a80
80101c64:	e8 18 35 00 00       	call   80105181 <acquire>
80101c69:	83 c4 10             	add    $0x10,%esp
  ip->ref--;
80101c6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6f:	8b 40 08             	mov    0x8(%eax),%eax
80101c72:	8d 50 ff             	lea    -0x1(%eax),%edx
80101c75:	8b 45 08             	mov    0x8(%ebp),%eax
80101c78:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101c7b:	83 ec 0c             	sub    $0xc,%esp
80101c7e:	68 80 2a 11 80       	push   $0x80112a80
80101c83:	e8 67 35 00 00       	call   801051ef <release>
80101c88:	83 c4 10             	add    $0x10,%esp
}
80101c8b:	90                   	nop
80101c8c:	c9                   	leave  
80101c8d:	c3                   	ret    

80101c8e <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101c8e:	55                   	push   %ebp
80101c8f:	89 e5                	mov    %esp,%ebp
80101c91:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101c94:	83 ec 0c             	sub    $0xc,%esp
80101c97:	ff 75 08             	pushl  0x8(%ebp)
80101c9a:	e8 d1 fe ff ff       	call   80101b70 <iunlock>
80101c9f:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101ca2:	83 ec 0c             	sub    $0xc,%esp
80101ca5:	ff 75 08             	pushl  0x8(%ebp)
80101ca8:	e8 11 ff ff ff       	call   80101bbe <iput>
80101cad:	83 c4 10             	add    $0x10,%esp
}
80101cb0:	90                   	nop
80101cb1:	c9                   	leave  
80101cb2:	c3                   	ret    

80101cb3 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101cb3:	55                   	push   %ebp
80101cb4:	89 e5                	mov    %esp,%ebp
80101cb6:	53                   	push   %ebx
80101cb7:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101cba:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101cbe:	77 42                	ja     80101d02 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101cc0:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
80101cc6:	83 c2 14             	add    $0x14,%edx
80101cc9:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101ccd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cd4:	75 24                	jne    80101cfa <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101cd6:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd9:	8b 00                	mov    (%eax),%eax
80101cdb:	83 ec 0c             	sub    $0xc,%esp
80101cde:	50                   	push   %eax
80101cdf:	e8 e3 f7 ff ff       	call   801014c7 <balloc>
80101ce4:	83 c4 10             	add    $0x10,%esp
80101ce7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cea:	8b 45 08             	mov    0x8(%ebp),%eax
80101ced:	8b 55 0c             	mov    0xc(%ebp),%edx
80101cf0:	8d 4a 14             	lea    0x14(%edx),%ecx
80101cf3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cf6:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cfd:	e9 d1 00 00 00       	jmp    80101dd3 <bmap+0x120>
  }
  bn -= NDIRECT;
80101d02:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101d06:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101d0a:	0f 87 b6 00 00 00    	ja     80101dc6 <bmap+0x113>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101d10:	8b 45 08             	mov    0x8(%ebp),%eax
80101d13:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101d19:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d20:	75 20                	jne    80101d42 <bmap+0x8f>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101d22:	8b 45 08             	mov    0x8(%ebp),%eax
80101d25:	8b 00                	mov    (%eax),%eax
80101d27:	83 ec 0c             	sub    $0xc,%esp
80101d2a:	50                   	push   %eax
80101d2b:	e8 97 f7 ff ff       	call   801014c7 <balloc>
80101d30:	83 c4 10             	add    $0x10,%esp
80101d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d36:	8b 45 08             	mov    0x8(%ebp),%eax
80101d39:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d3c:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101d42:	8b 45 08             	mov    0x8(%ebp),%eax
80101d45:	8b 00                	mov    (%eax),%eax
80101d47:	83 ec 08             	sub    $0x8,%esp
80101d4a:	ff 75 f4             	pushl  -0xc(%ebp)
80101d4d:	50                   	push   %eax
80101d4e:	e8 7b e4 ff ff       	call   801001ce <bread>
80101d53:	83 c4 10             	add    $0x10,%esp
80101d56:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d5c:	83 c0 5c             	add    $0x5c,%eax
80101d5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101d62:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d65:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d6f:	01 d0                	add    %edx,%eax
80101d71:	8b 00                	mov    (%eax),%eax
80101d73:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d7a:	75 37                	jne    80101db3 <bmap+0x100>
      a[bn] = addr = balloc(ip->dev);
80101d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d7f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d86:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d89:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101d8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8f:	8b 00                	mov    (%eax),%eax
80101d91:	83 ec 0c             	sub    $0xc,%esp
80101d94:	50                   	push   %eax
80101d95:	e8 2d f7 ff ff       	call   801014c7 <balloc>
80101d9a:	83 c4 10             	add    $0x10,%esp
80101d9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101da3:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101da5:	83 ec 0c             	sub    $0xc,%esp
80101da8:	ff 75 f0             	pushl  -0x10(%ebp)
80101dab:	e8 0a 1a 00 00       	call   801037ba <log_write>
80101db0:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101db3:	83 ec 0c             	sub    $0xc,%esp
80101db6:	ff 75 f0             	pushl  -0x10(%ebp)
80101db9:	e8 92 e4 ff ff       	call   80100250 <brelse>
80101dbe:	83 c4 10             	add    $0x10,%esp
    return addr;
80101dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101dc4:	eb 0d                	jmp    80101dd3 <bmap+0x120>
  }

  panic("bmap: out of range");
80101dc6:	83 ec 0c             	sub    $0xc,%esp
80101dc9:	68 66 8b 10 80       	push   $0x80108b66
80101dce:	e8 cd e7 ff ff       	call   801005a0 <panic>
}
80101dd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101dd6:	c9                   	leave  
80101dd7:	c3                   	ret    

80101dd8 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101dd8:	55                   	push   %ebp
80101dd9:	89 e5                	mov    %esp,%ebp
80101ddb:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101dde:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101de5:	eb 45                	jmp    80101e2c <itrunc+0x54>
    if(ip->addrs[i]){
80101de7:	8b 45 08             	mov    0x8(%ebp),%eax
80101dea:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ded:	83 c2 14             	add    $0x14,%edx
80101df0:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101df4:	85 c0                	test   %eax,%eax
80101df6:	74 30                	je     80101e28 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101df8:	8b 45 08             	mov    0x8(%ebp),%eax
80101dfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dfe:	83 c2 14             	add    $0x14,%edx
80101e01:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e05:	8b 55 08             	mov    0x8(%ebp),%edx
80101e08:	8b 12                	mov    (%edx),%edx
80101e0a:	83 ec 08             	sub    $0x8,%esp
80101e0d:	50                   	push   %eax
80101e0e:	52                   	push   %edx
80101e0f:	e8 ff f7 ff ff       	call   80101613 <bfree>
80101e14:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101e17:	8b 45 08             	mov    0x8(%ebp),%eax
80101e1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e1d:	83 c2 14             	add    $0x14,%edx
80101e20:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101e27:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e28:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101e2c:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101e30:	7e b5                	jle    80101de7 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
80101e32:	8b 45 08             	mov    0x8(%ebp),%eax
80101e35:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101e3b:	85 c0                	test   %eax,%eax
80101e3d:	0f 84 aa 00 00 00    	je     80101eed <itrunc+0x115>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101e43:	8b 45 08             	mov    0x8(%ebp),%eax
80101e46:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101e4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e4f:	8b 00                	mov    (%eax),%eax
80101e51:	83 ec 08             	sub    $0x8,%esp
80101e54:	52                   	push   %edx
80101e55:	50                   	push   %eax
80101e56:	e8 73 e3 ff ff       	call   801001ce <bread>
80101e5b:	83 c4 10             	add    $0x10,%esp
80101e5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101e61:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e64:	83 c0 5c             	add    $0x5c,%eax
80101e67:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e6a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101e71:	eb 3c                	jmp    80101eaf <itrunc+0xd7>
      if(a[j])
80101e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e76:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e80:	01 d0                	add    %edx,%eax
80101e82:	8b 00                	mov    (%eax),%eax
80101e84:	85 c0                	test   %eax,%eax
80101e86:	74 23                	je     80101eab <itrunc+0xd3>
        bfree(ip->dev, a[j]);
80101e88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e8b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e92:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e95:	01 d0                	add    %edx,%eax
80101e97:	8b 00                	mov    (%eax),%eax
80101e99:	8b 55 08             	mov    0x8(%ebp),%edx
80101e9c:	8b 12                	mov    (%edx),%edx
80101e9e:	83 ec 08             	sub    $0x8,%esp
80101ea1:	50                   	push   %eax
80101ea2:	52                   	push   %edx
80101ea3:	e8 6b f7 ff ff       	call   80101613 <bfree>
80101ea8:	83 c4 10             	add    $0x10,%esp
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101eab:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101eb2:	83 f8 7f             	cmp    $0x7f,%eax
80101eb5:	76 bc                	jbe    80101e73 <itrunc+0x9b>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101eb7:	83 ec 0c             	sub    $0xc,%esp
80101eba:	ff 75 ec             	pushl  -0x14(%ebp)
80101ebd:	e8 8e e3 ff ff       	call   80100250 <brelse>
80101ec2:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ec5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec8:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101ece:	8b 55 08             	mov    0x8(%ebp),%edx
80101ed1:	8b 12                	mov    (%edx),%edx
80101ed3:	83 ec 08             	sub    $0x8,%esp
80101ed6:	50                   	push   %eax
80101ed7:	52                   	push   %edx
80101ed8:	e8 36 f7 ff ff       	call   80101613 <bfree>
80101edd:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101ee0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee3:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101eea:	00 00 00 
  }

  ip->size = 0;
80101eed:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef0:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101ef7:	83 ec 0c             	sub    $0xc,%esp
80101efa:	ff 75 08             	pushl  0x8(%ebp)
80101efd:	e8 7e f9 ff ff       	call   80101880 <iupdate>
80101f02:	83 c4 10             	add    $0x10,%esp
}
80101f05:	90                   	nop
80101f06:	c9                   	leave  
80101f07:	c3                   	ret    

80101f08 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101f08:	55                   	push   %ebp
80101f09:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0e:	8b 00                	mov    (%eax),%eax
80101f10:	89 c2                	mov    %eax,%edx
80101f12:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f15:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101f18:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1b:	8b 50 04             	mov    0x4(%eax),%edx
80101f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f21:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101f24:	8b 45 08             	mov    0x8(%ebp),%eax
80101f27:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f2e:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101f31:	8b 45 08             	mov    0x8(%ebp),%eax
80101f34:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101f38:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f3b:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101f3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f42:	8b 50 58             	mov    0x58(%eax),%edx
80101f45:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f48:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f4b:	90                   	nop
80101f4c:	5d                   	pop    %ebp
80101f4d:	c3                   	ret    

80101f4e <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f4e:	55                   	push   %ebp
80101f4f:	89 e5                	mov    %esp,%ebp
80101f51:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f54:	8b 45 08             	mov    0x8(%ebp),%eax
80101f57:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101f5b:	66 83 f8 03          	cmp    $0x3,%ax
80101f5f:	75 5c                	jne    80101fbd <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f61:	8b 45 08             	mov    0x8(%ebp),%eax
80101f64:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f68:	66 85 c0             	test   %ax,%ax
80101f6b:	78 20                	js     80101f8d <readi+0x3f>
80101f6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f70:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f74:	66 83 f8 09          	cmp    $0x9,%ax
80101f78:	7f 13                	jg     80101f8d <readi+0x3f>
80101f7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7d:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f81:	98                   	cwtl   
80101f82:	8b 04 c5 00 2a 11 80 	mov    -0x7feed600(,%eax,8),%eax
80101f89:	85 c0                	test   %eax,%eax
80101f8b:	75 0a                	jne    80101f97 <readi+0x49>
      return -1;
80101f8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f92:	e9 0c 01 00 00       	jmp    801020a3 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101f97:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9a:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f9e:	98                   	cwtl   
80101f9f:	8b 04 c5 00 2a 11 80 	mov    -0x7feed600(,%eax,8),%eax
80101fa6:	8b 55 14             	mov    0x14(%ebp),%edx
80101fa9:	83 ec 04             	sub    $0x4,%esp
80101fac:	52                   	push   %edx
80101fad:	ff 75 0c             	pushl  0xc(%ebp)
80101fb0:	ff 75 08             	pushl  0x8(%ebp)
80101fb3:	ff d0                	call   *%eax
80101fb5:	83 c4 10             	add    $0x10,%esp
80101fb8:	e9 e6 00 00 00       	jmp    801020a3 <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80101fbd:	8b 45 08             	mov    0x8(%ebp),%eax
80101fc0:	8b 40 58             	mov    0x58(%eax),%eax
80101fc3:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fc6:	72 0d                	jb     80101fd5 <readi+0x87>
80101fc8:	8b 55 10             	mov    0x10(%ebp),%edx
80101fcb:	8b 45 14             	mov    0x14(%ebp),%eax
80101fce:	01 d0                	add    %edx,%eax
80101fd0:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fd3:	73 0a                	jae    80101fdf <readi+0x91>
    return -1;
80101fd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fda:	e9 c4 00 00 00       	jmp    801020a3 <readi+0x155>
  if(off + n > ip->size)
80101fdf:	8b 55 10             	mov    0x10(%ebp),%edx
80101fe2:	8b 45 14             	mov    0x14(%ebp),%eax
80101fe5:	01 c2                	add    %eax,%edx
80101fe7:	8b 45 08             	mov    0x8(%ebp),%eax
80101fea:	8b 40 58             	mov    0x58(%eax),%eax
80101fed:	39 c2                	cmp    %eax,%edx
80101fef:	76 0c                	jbe    80101ffd <readi+0xaf>
    n = ip->size - off;
80101ff1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff4:	8b 40 58             	mov    0x58(%eax),%eax
80101ff7:	2b 45 10             	sub    0x10(%ebp),%eax
80101ffa:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ffd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102004:	e9 8b 00 00 00       	jmp    80102094 <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102009:	8b 45 10             	mov    0x10(%ebp),%eax
8010200c:	c1 e8 09             	shr    $0x9,%eax
8010200f:	83 ec 08             	sub    $0x8,%esp
80102012:	50                   	push   %eax
80102013:	ff 75 08             	pushl  0x8(%ebp)
80102016:	e8 98 fc ff ff       	call   80101cb3 <bmap>
8010201b:	83 c4 10             	add    $0x10,%esp
8010201e:	89 c2                	mov    %eax,%edx
80102020:	8b 45 08             	mov    0x8(%ebp),%eax
80102023:	8b 00                	mov    (%eax),%eax
80102025:	83 ec 08             	sub    $0x8,%esp
80102028:	52                   	push   %edx
80102029:	50                   	push   %eax
8010202a:	e8 9f e1 ff ff       	call   801001ce <bread>
8010202f:	83 c4 10             	add    $0x10,%esp
80102032:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102035:	8b 45 10             	mov    0x10(%ebp),%eax
80102038:	25 ff 01 00 00       	and    $0x1ff,%eax
8010203d:	ba 00 02 00 00       	mov    $0x200,%edx
80102042:	29 c2                	sub    %eax,%edx
80102044:	8b 45 14             	mov    0x14(%ebp),%eax
80102047:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010204a:	39 c2                	cmp    %eax,%edx
8010204c:	0f 46 c2             	cmovbe %edx,%eax
8010204f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80102052:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102055:	8d 50 5c             	lea    0x5c(%eax),%edx
80102058:	8b 45 10             	mov    0x10(%ebp),%eax
8010205b:	25 ff 01 00 00       	and    $0x1ff,%eax
80102060:	01 d0                	add    %edx,%eax
80102062:	83 ec 04             	sub    $0x4,%esp
80102065:	ff 75 ec             	pushl  -0x14(%ebp)
80102068:	50                   	push   %eax
80102069:	ff 75 0c             	pushl  0xc(%ebp)
8010206c:	e8 46 34 00 00       	call   801054b7 <memmove>
80102071:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102074:	83 ec 0c             	sub    $0xc,%esp
80102077:	ff 75 f0             	pushl  -0x10(%ebp)
8010207a:	e8 d1 e1 ff ff       	call   80100250 <brelse>
8010207f:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102082:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102085:	01 45 f4             	add    %eax,-0xc(%ebp)
80102088:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010208b:	01 45 10             	add    %eax,0x10(%ebp)
8010208e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102091:	01 45 0c             	add    %eax,0xc(%ebp)
80102094:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102097:	3b 45 14             	cmp    0x14(%ebp),%eax
8010209a:	0f 82 69 ff ff ff    	jb     80102009 <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
801020a0:	8b 45 14             	mov    0x14(%ebp),%eax
}
801020a3:	c9                   	leave  
801020a4:	c3                   	ret    

801020a5 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801020a5:	55                   	push   %ebp
801020a6:	89 e5                	mov    %esp,%ebp
801020a8:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801020ab:	8b 45 08             	mov    0x8(%ebp),%eax
801020ae:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801020b2:	66 83 f8 03          	cmp    $0x3,%ax
801020b6:	75 5c                	jne    80102114 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801020b8:	8b 45 08             	mov    0x8(%ebp),%eax
801020bb:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801020bf:	66 85 c0             	test   %ax,%ax
801020c2:	78 20                	js     801020e4 <writei+0x3f>
801020c4:	8b 45 08             	mov    0x8(%ebp),%eax
801020c7:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801020cb:	66 83 f8 09          	cmp    $0x9,%ax
801020cf:	7f 13                	jg     801020e4 <writei+0x3f>
801020d1:	8b 45 08             	mov    0x8(%ebp),%eax
801020d4:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801020d8:	98                   	cwtl   
801020d9:	8b 04 c5 04 2a 11 80 	mov    -0x7feed5fc(,%eax,8),%eax
801020e0:	85 c0                	test   %eax,%eax
801020e2:	75 0a                	jne    801020ee <writei+0x49>
      return -1;
801020e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020e9:	e9 3d 01 00 00       	jmp    8010222b <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
801020ee:	8b 45 08             	mov    0x8(%ebp),%eax
801020f1:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801020f5:	98                   	cwtl   
801020f6:	8b 04 c5 04 2a 11 80 	mov    -0x7feed5fc(,%eax,8),%eax
801020fd:	8b 55 14             	mov    0x14(%ebp),%edx
80102100:	83 ec 04             	sub    $0x4,%esp
80102103:	52                   	push   %edx
80102104:	ff 75 0c             	pushl  0xc(%ebp)
80102107:	ff 75 08             	pushl  0x8(%ebp)
8010210a:	ff d0                	call   *%eax
8010210c:	83 c4 10             	add    $0x10,%esp
8010210f:	e9 17 01 00 00       	jmp    8010222b <writei+0x186>
  }

  if(off > ip->size || off + n < off)
80102114:	8b 45 08             	mov    0x8(%ebp),%eax
80102117:	8b 40 58             	mov    0x58(%eax),%eax
8010211a:	3b 45 10             	cmp    0x10(%ebp),%eax
8010211d:	72 0d                	jb     8010212c <writei+0x87>
8010211f:	8b 55 10             	mov    0x10(%ebp),%edx
80102122:	8b 45 14             	mov    0x14(%ebp),%eax
80102125:	01 d0                	add    %edx,%eax
80102127:	3b 45 10             	cmp    0x10(%ebp),%eax
8010212a:	73 0a                	jae    80102136 <writei+0x91>
    return -1;
8010212c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102131:	e9 f5 00 00 00       	jmp    8010222b <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
80102136:	8b 55 10             	mov    0x10(%ebp),%edx
80102139:	8b 45 14             	mov    0x14(%ebp),%eax
8010213c:	01 d0                	add    %edx,%eax
8010213e:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102143:	76 0a                	jbe    8010214f <writei+0xaa>
    return -1;
80102145:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010214a:	e9 dc 00 00 00       	jmp    8010222b <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010214f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102156:	e9 99 00 00 00       	jmp    801021f4 <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010215b:	8b 45 10             	mov    0x10(%ebp),%eax
8010215e:	c1 e8 09             	shr    $0x9,%eax
80102161:	83 ec 08             	sub    $0x8,%esp
80102164:	50                   	push   %eax
80102165:	ff 75 08             	pushl  0x8(%ebp)
80102168:	e8 46 fb ff ff       	call   80101cb3 <bmap>
8010216d:	83 c4 10             	add    $0x10,%esp
80102170:	89 c2                	mov    %eax,%edx
80102172:	8b 45 08             	mov    0x8(%ebp),%eax
80102175:	8b 00                	mov    (%eax),%eax
80102177:	83 ec 08             	sub    $0x8,%esp
8010217a:	52                   	push   %edx
8010217b:	50                   	push   %eax
8010217c:	e8 4d e0 ff ff       	call   801001ce <bread>
80102181:	83 c4 10             	add    $0x10,%esp
80102184:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102187:	8b 45 10             	mov    0x10(%ebp),%eax
8010218a:	25 ff 01 00 00       	and    $0x1ff,%eax
8010218f:	ba 00 02 00 00       	mov    $0x200,%edx
80102194:	29 c2                	sub    %eax,%edx
80102196:	8b 45 14             	mov    0x14(%ebp),%eax
80102199:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010219c:	39 c2                	cmp    %eax,%edx
8010219e:	0f 46 c2             	cmovbe %edx,%eax
801021a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801021a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021a7:	8d 50 5c             	lea    0x5c(%eax),%edx
801021aa:	8b 45 10             	mov    0x10(%ebp),%eax
801021ad:	25 ff 01 00 00       	and    $0x1ff,%eax
801021b2:	01 d0                	add    %edx,%eax
801021b4:	83 ec 04             	sub    $0x4,%esp
801021b7:	ff 75 ec             	pushl  -0x14(%ebp)
801021ba:	ff 75 0c             	pushl  0xc(%ebp)
801021bd:	50                   	push   %eax
801021be:	e8 f4 32 00 00       	call   801054b7 <memmove>
801021c3:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
801021c6:	83 ec 0c             	sub    $0xc,%esp
801021c9:	ff 75 f0             	pushl  -0x10(%ebp)
801021cc:	e8 e9 15 00 00       	call   801037ba <log_write>
801021d1:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801021d4:	83 ec 0c             	sub    $0xc,%esp
801021d7:	ff 75 f0             	pushl  -0x10(%ebp)
801021da:	e8 71 e0 ff ff       	call   80100250 <brelse>
801021df:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801021e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021e5:	01 45 f4             	add    %eax,-0xc(%ebp)
801021e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021eb:	01 45 10             	add    %eax,0x10(%ebp)
801021ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021f1:	01 45 0c             	add    %eax,0xc(%ebp)
801021f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021f7:	3b 45 14             	cmp    0x14(%ebp),%eax
801021fa:	0f 82 5b ff ff ff    	jb     8010215b <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102200:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102204:	74 22                	je     80102228 <writei+0x183>
80102206:	8b 45 08             	mov    0x8(%ebp),%eax
80102209:	8b 40 58             	mov    0x58(%eax),%eax
8010220c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010220f:	73 17                	jae    80102228 <writei+0x183>
    ip->size = off;
80102211:	8b 45 08             	mov    0x8(%ebp),%eax
80102214:	8b 55 10             	mov    0x10(%ebp),%edx
80102217:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
8010221a:	83 ec 0c             	sub    $0xc,%esp
8010221d:	ff 75 08             	pushl  0x8(%ebp)
80102220:	e8 5b f6 ff ff       	call   80101880 <iupdate>
80102225:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80102228:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010222b:	c9                   	leave  
8010222c:	c3                   	ret    

8010222d <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
8010222d:	55                   	push   %ebp
8010222e:	89 e5                	mov    %esp,%ebp
80102230:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
80102233:	83 ec 04             	sub    $0x4,%esp
80102236:	6a 0e                	push   $0xe
80102238:	ff 75 0c             	pushl  0xc(%ebp)
8010223b:	ff 75 08             	pushl  0x8(%ebp)
8010223e:	e8 0a 33 00 00       	call   8010554d <strncmp>
80102243:	83 c4 10             	add    $0x10,%esp
}
80102246:	c9                   	leave  
80102247:	c3                   	ret    

80102248 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102248:	55                   	push   %ebp
80102249:	89 e5                	mov    %esp,%ebp
8010224b:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010224e:	8b 45 08             	mov    0x8(%ebp),%eax
80102251:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102255:	66 83 f8 01          	cmp    $0x1,%ax
80102259:	74 0d                	je     80102268 <dirlookup+0x20>
    panic("dirlookup not DIR");
8010225b:	83 ec 0c             	sub    $0xc,%esp
8010225e:	68 79 8b 10 80       	push   $0x80108b79
80102263:	e8 38 e3 ff ff       	call   801005a0 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102268:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010226f:	eb 7b                	jmp    801022ec <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102271:	6a 10                	push   $0x10
80102273:	ff 75 f4             	pushl  -0xc(%ebp)
80102276:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102279:	50                   	push   %eax
8010227a:	ff 75 08             	pushl  0x8(%ebp)
8010227d:	e8 cc fc ff ff       	call   80101f4e <readi>
80102282:	83 c4 10             	add    $0x10,%esp
80102285:	83 f8 10             	cmp    $0x10,%eax
80102288:	74 0d                	je     80102297 <dirlookup+0x4f>
      panic("dirlookup read");
8010228a:	83 ec 0c             	sub    $0xc,%esp
8010228d:	68 8b 8b 10 80       	push   $0x80108b8b
80102292:	e8 09 e3 ff ff       	call   801005a0 <panic>
    if(de.inum == 0)
80102297:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010229b:	66 85 c0             	test   %ax,%ax
8010229e:	74 47                	je     801022e7 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
801022a0:	83 ec 08             	sub    $0x8,%esp
801022a3:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022a6:	83 c0 02             	add    $0x2,%eax
801022a9:	50                   	push   %eax
801022aa:	ff 75 0c             	pushl  0xc(%ebp)
801022ad:	e8 7b ff ff ff       	call   8010222d <namecmp>
801022b2:	83 c4 10             	add    $0x10,%esp
801022b5:	85 c0                	test   %eax,%eax
801022b7:	75 2f                	jne    801022e8 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
801022b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801022bd:	74 08                	je     801022c7 <dirlookup+0x7f>
        *poff = off;
801022bf:	8b 45 10             	mov    0x10(%ebp),%eax
801022c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801022c5:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801022c7:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022cb:	0f b7 c0             	movzwl %ax,%eax
801022ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801022d1:	8b 45 08             	mov    0x8(%ebp),%eax
801022d4:	8b 00                	mov    (%eax),%eax
801022d6:	83 ec 08             	sub    $0x8,%esp
801022d9:	ff 75 f0             	pushl  -0x10(%ebp)
801022dc:	50                   	push   %eax
801022dd:	e8 5f f6 ff ff       	call   80101941 <iget>
801022e2:	83 c4 10             	add    $0x10,%esp
801022e5:	eb 19                	jmp    80102300 <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
801022e7:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801022e8:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801022ec:	8b 45 08             	mov    0x8(%ebp),%eax
801022ef:	8b 40 58             	mov    0x58(%eax),%eax
801022f2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801022f5:	0f 87 76 ff ff ff    	ja     80102271 <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801022fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102300:	c9                   	leave  
80102301:	c3                   	ret    

80102302 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102302:	55                   	push   %ebp
80102303:	89 e5                	mov    %esp,%ebp
80102305:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102308:	83 ec 04             	sub    $0x4,%esp
8010230b:	6a 00                	push   $0x0
8010230d:	ff 75 0c             	pushl  0xc(%ebp)
80102310:	ff 75 08             	pushl  0x8(%ebp)
80102313:	e8 30 ff ff ff       	call   80102248 <dirlookup>
80102318:	83 c4 10             	add    $0x10,%esp
8010231b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010231e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102322:	74 18                	je     8010233c <dirlink+0x3a>
    iput(ip);
80102324:	83 ec 0c             	sub    $0xc,%esp
80102327:	ff 75 f0             	pushl  -0x10(%ebp)
8010232a:	e8 8f f8 ff ff       	call   80101bbe <iput>
8010232f:	83 c4 10             	add    $0x10,%esp
    return -1;
80102332:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102337:	e9 9c 00 00 00       	jmp    801023d8 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010233c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102343:	eb 39                	jmp    8010237e <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102345:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102348:	6a 10                	push   $0x10
8010234a:	50                   	push   %eax
8010234b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010234e:	50                   	push   %eax
8010234f:	ff 75 08             	pushl  0x8(%ebp)
80102352:	e8 f7 fb ff ff       	call   80101f4e <readi>
80102357:	83 c4 10             	add    $0x10,%esp
8010235a:	83 f8 10             	cmp    $0x10,%eax
8010235d:	74 0d                	je     8010236c <dirlink+0x6a>
      panic("dirlink read");
8010235f:	83 ec 0c             	sub    $0xc,%esp
80102362:	68 9a 8b 10 80       	push   $0x80108b9a
80102367:	e8 34 e2 ff ff       	call   801005a0 <panic>
    if(de.inum == 0)
8010236c:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102370:	66 85 c0             	test   %ax,%ax
80102373:	74 18                	je     8010238d <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102375:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102378:	83 c0 10             	add    $0x10,%eax
8010237b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010237e:	8b 45 08             	mov    0x8(%ebp),%eax
80102381:	8b 50 58             	mov    0x58(%eax),%edx
80102384:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102387:	39 c2                	cmp    %eax,%edx
80102389:	77 ba                	ja     80102345 <dirlink+0x43>
8010238b:	eb 01                	jmp    8010238e <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
8010238d:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
8010238e:	83 ec 04             	sub    $0x4,%esp
80102391:	6a 0e                	push   $0xe
80102393:	ff 75 0c             	pushl  0xc(%ebp)
80102396:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102399:	83 c0 02             	add    $0x2,%eax
8010239c:	50                   	push   %eax
8010239d:	e8 01 32 00 00       	call   801055a3 <strncpy>
801023a2:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801023a5:	8b 45 10             	mov    0x10(%ebp),%eax
801023a8:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023af:	6a 10                	push   $0x10
801023b1:	50                   	push   %eax
801023b2:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023b5:	50                   	push   %eax
801023b6:	ff 75 08             	pushl  0x8(%ebp)
801023b9:	e8 e7 fc ff ff       	call   801020a5 <writei>
801023be:	83 c4 10             	add    $0x10,%esp
801023c1:	83 f8 10             	cmp    $0x10,%eax
801023c4:	74 0d                	je     801023d3 <dirlink+0xd1>
    panic("dirlink");
801023c6:	83 ec 0c             	sub    $0xc,%esp
801023c9:	68 a7 8b 10 80       	push   $0x80108ba7
801023ce:	e8 cd e1 ff ff       	call   801005a0 <panic>

  return 0;
801023d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801023d8:	c9                   	leave  
801023d9:	c3                   	ret    

801023da <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801023da:	55                   	push   %ebp
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
801023e0:	eb 04                	jmp    801023e6 <skipelem+0xc>
    path++;
801023e2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
801023e6:	8b 45 08             	mov    0x8(%ebp),%eax
801023e9:	0f b6 00             	movzbl (%eax),%eax
801023ec:	3c 2f                	cmp    $0x2f,%al
801023ee:	74 f2                	je     801023e2 <skipelem+0x8>
    path++;
  if(*path == 0)
801023f0:	8b 45 08             	mov    0x8(%ebp),%eax
801023f3:	0f b6 00             	movzbl (%eax),%eax
801023f6:	84 c0                	test   %al,%al
801023f8:	75 07                	jne    80102401 <skipelem+0x27>
    return 0;
801023fa:	b8 00 00 00 00       	mov    $0x0,%eax
801023ff:	eb 7b                	jmp    8010247c <skipelem+0xa2>
  s = path;
80102401:	8b 45 08             	mov    0x8(%ebp),%eax
80102404:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102407:	eb 04                	jmp    8010240d <skipelem+0x33>
    path++;
80102409:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
8010240d:	8b 45 08             	mov    0x8(%ebp),%eax
80102410:	0f b6 00             	movzbl (%eax),%eax
80102413:	3c 2f                	cmp    $0x2f,%al
80102415:	74 0a                	je     80102421 <skipelem+0x47>
80102417:	8b 45 08             	mov    0x8(%ebp),%eax
8010241a:	0f b6 00             	movzbl (%eax),%eax
8010241d:	84 c0                	test   %al,%al
8010241f:	75 e8                	jne    80102409 <skipelem+0x2f>
    path++;
  len = path - s;
80102421:	8b 55 08             	mov    0x8(%ebp),%edx
80102424:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102427:	29 c2                	sub    %eax,%edx
80102429:	89 d0                	mov    %edx,%eax
8010242b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
8010242e:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102432:	7e 15                	jle    80102449 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
80102434:	83 ec 04             	sub    $0x4,%esp
80102437:	6a 0e                	push   $0xe
80102439:	ff 75 f4             	pushl  -0xc(%ebp)
8010243c:	ff 75 0c             	pushl  0xc(%ebp)
8010243f:	e8 73 30 00 00       	call   801054b7 <memmove>
80102444:	83 c4 10             	add    $0x10,%esp
80102447:	eb 26                	jmp    8010246f <skipelem+0x95>
  else {
    memmove(name, s, len);
80102449:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010244c:	83 ec 04             	sub    $0x4,%esp
8010244f:	50                   	push   %eax
80102450:	ff 75 f4             	pushl  -0xc(%ebp)
80102453:	ff 75 0c             	pushl  0xc(%ebp)
80102456:	e8 5c 30 00 00       	call   801054b7 <memmove>
8010245b:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
8010245e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102461:	8b 45 0c             	mov    0xc(%ebp),%eax
80102464:	01 d0                	add    %edx,%eax
80102466:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102469:	eb 04                	jmp    8010246f <skipelem+0x95>
    path++;
8010246b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
8010246f:	8b 45 08             	mov    0x8(%ebp),%eax
80102472:	0f b6 00             	movzbl (%eax),%eax
80102475:	3c 2f                	cmp    $0x2f,%al
80102477:	74 f2                	je     8010246b <skipelem+0x91>
    path++;
  return path;
80102479:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010247c:	c9                   	leave  
8010247d:	c3                   	ret    

8010247e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
8010247e:	55                   	push   %ebp
8010247f:	89 e5                	mov    %esp,%ebp
80102481:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102484:	8b 45 08             	mov    0x8(%ebp),%eax
80102487:	0f b6 00             	movzbl (%eax),%eax
8010248a:	3c 2f                	cmp    $0x2f,%al
8010248c:	75 17                	jne    801024a5 <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
8010248e:	83 ec 08             	sub    $0x8,%esp
80102491:	6a 01                	push   $0x1
80102493:	6a 01                	push   $0x1
80102495:	e8 a7 f4 ff ff       	call   80101941 <iget>
8010249a:	83 c4 10             	add    $0x10,%esp
8010249d:	89 45 f4             	mov    %eax,-0xc(%ebp)
801024a0:	e9 ba 00 00 00       	jmp    8010255f <namex+0xe1>
  else
    ip = idup(myproc()->cwd);
801024a5:	e8 2b 1e 00 00       	call   801042d5 <myproc>
801024aa:	8b 40 68             	mov    0x68(%eax),%eax
801024ad:	83 ec 0c             	sub    $0xc,%esp
801024b0:	50                   	push   %eax
801024b1:	e8 6d f5 ff ff       	call   80101a23 <idup>
801024b6:	83 c4 10             	add    $0x10,%esp
801024b9:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801024bc:	e9 9e 00 00 00       	jmp    8010255f <namex+0xe1>
    ilock(ip);
801024c1:	83 ec 0c             	sub    $0xc,%esp
801024c4:	ff 75 f4             	pushl  -0xc(%ebp)
801024c7:	e8 91 f5 ff ff       	call   80101a5d <ilock>
801024cc:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
801024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024d2:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801024d6:	66 83 f8 01          	cmp    $0x1,%ax
801024da:	74 18                	je     801024f4 <namex+0x76>
      iunlockput(ip);
801024dc:	83 ec 0c             	sub    $0xc,%esp
801024df:	ff 75 f4             	pushl  -0xc(%ebp)
801024e2:	e8 a7 f7 ff ff       	call   80101c8e <iunlockput>
801024e7:	83 c4 10             	add    $0x10,%esp
      return 0;
801024ea:	b8 00 00 00 00       	mov    $0x0,%eax
801024ef:	e9 a7 00 00 00       	jmp    8010259b <namex+0x11d>
    }
    if(nameiparent && *path == '\0'){
801024f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024f8:	74 20                	je     8010251a <namex+0x9c>
801024fa:	8b 45 08             	mov    0x8(%ebp),%eax
801024fd:	0f b6 00             	movzbl (%eax),%eax
80102500:	84 c0                	test   %al,%al
80102502:	75 16                	jne    8010251a <namex+0x9c>
      // Stop one level early.
      iunlock(ip);
80102504:	83 ec 0c             	sub    $0xc,%esp
80102507:	ff 75 f4             	pushl  -0xc(%ebp)
8010250a:	e8 61 f6 ff ff       	call   80101b70 <iunlock>
8010250f:	83 c4 10             	add    $0x10,%esp
      return ip;
80102512:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102515:	e9 81 00 00 00       	jmp    8010259b <namex+0x11d>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010251a:	83 ec 04             	sub    $0x4,%esp
8010251d:	6a 00                	push   $0x0
8010251f:	ff 75 10             	pushl  0x10(%ebp)
80102522:	ff 75 f4             	pushl  -0xc(%ebp)
80102525:	e8 1e fd ff ff       	call   80102248 <dirlookup>
8010252a:	83 c4 10             	add    $0x10,%esp
8010252d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102530:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102534:	75 15                	jne    8010254b <namex+0xcd>
      iunlockput(ip);
80102536:	83 ec 0c             	sub    $0xc,%esp
80102539:	ff 75 f4             	pushl  -0xc(%ebp)
8010253c:	e8 4d f7 ff ff       	call   80101c8e <iunlockput>
80102541:	83 c4 10             	add    $0x10,%esp
      return 0;
80102544:	b8 00 00 00 00       	mov    $0x0,%eax
80102549:	eb 50                	jmp    8010259b <namex+0x11d>
    }
    iunlockput(ip);
8010254b:	83 ec 0c             	sub    $0xc,%esp
8010254e:	ff 75 f4             	pushl  -0xc(%ebp)
80102551:	e8 38 f7 ff ff       	call   80101c8e <iunlockput>
80102556:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102559:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010255c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
8010255f:	83 ec 08             	sub    $0x8,%esp
80102562:	ff 75 10             	pushl  0x10(%ebp)
80102565:	ff 75 08             	pushl  0x8(%ebp)
80102568:	e8 6d fe ff ff       	call   801023da <skipelem>
8010256d:	83 c4 10             	add    $0x10,%esp
80102570:	89 45 08             	mov    %eax,0x8(%ebp)
80102573:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102577:	0f 85 44 ff ff ff    	jne    801024c1 <namex+0x43>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
8010257d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102581:	74 15                	je     80102598 <namex+0x11a>
    iput(ip);
80102583:	83 ec 0c             	sub    $0xc,%esp
80102586:	ff 75 f4             	pushl  -0xc(%ebp)
80102589:	e8 30 f6 ff ff       	call   80101bbe <iput>
8010258e:	83 c4 10             	add    $0x10,%esp
    return 0;
80102591:	b8 00 00 00 00       	mov    $0x0,%eax
80102596:	eb 03                	jmp    8010259b <namex+0x11d>
  }
  return ip;
80102598:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010259b:	c9                   	leave  
8010259c:	c3                   	ret    

8010259d <namei>:

struct inode*
namei(char *path)
{
8010259d:	55                   	push   %ebp
8010259e:	89 e5                	mov    %esp,%ebp
801025a0:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801025a3:	83 ec 04             	sub    $0x4,%esp
801025a6:	8d 45 ea             	lea    -0x16(%ebp),%eax
801025a9:	50                   	push   %eax
801025aa:	6a 00                	push   $0x0
801025ac:	ff 75 08             	pushl  0x8(%ebp)
801025af:	e8 ca fe ff ff       	call   8010247e <namex>
801025b4:	83 c4 10             	add    $0x10,%esp
}
801025b7:	c9                   	leave  
801025b8:	c3                   	ret    

801025b9 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801025b9:	55                   	push   %ebp
801025ba:	89 e5                	mov    %esp,%ebp
801025bc:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801025bf:	83 ec 04             	sub    $0x4,%esp
801025c2:	ff 75 0c             	pushl  0xc(%ebp)
801025c5:	6a 01                	push   $0x1
801025c7:	ff 75 08             	pushl  0x8(%ebp)
801025ca:	e8 af fe ff ff       	call   8010247e <namex>
801025cf:	83 c4 10             	add    $0x10,%esp
}
801025d2:	c9                   	leave  
801025d3:	c3                   	ret    

801025d4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801025d4:	55                   	push   %ebp
801025d5:	89 e5                	mov    %esp,%ebp
801025d7:	83 ec 14             	sub    $0x14,%esp
801025da:	8b 45 08             	mov    0x8(%ebp),%eax
801025dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801025e5:	89 c2                	mov    %eax,%edx
801025e7:	ec                   	in     (%dx),%al
801025e8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801025eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801025ef:	c9                   	leave  
801025f0:	c3                   	ret    

801025f1 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801025f1:	55                   	push   %ebp
801025f2:	89 e5                	mov    %esp,%ebp
801025f4:	57                   	push   %edi
801025f5:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801025f6:	8b 55 08             	mov    0x8(%ebp),%edx
801025f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025fc:	8b 45 10             	mov    0x10(%ebp),%eax
801025ff:	89 cb                	mov    %ecx,%ebx
80102601:	89 df                	mov    %ebx,%edi
80102603:	89 c1                	mov    %eax,%ecx
80102605:	fc                   	cld    
80102606:	f3 6d                	rep insl (%dx),%es:(%edi)
80102608:	89 c8                	mov    %ecx,%eax
8010260a:	89 fb                	mov    %edi,%ebx
8010260c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010260f:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102612:	90                   	nop
80102613:	5b                   	pop    %ebx
80102614:	5f                   	pop    %edi
80102615:	5d                   	pop    %ebp
80102616:	c3                   	ret    

80102617 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102617:	55                   	push   %ebp
80102618:	89 e5                	mov    %esp,%ebp
8010261a:	83 ec 08             	sub    $0x8,%esp
8010261d:	8b 55 08             	mov    0x8(%ebp),%edx
80102620:	8b 45 0c             	mov    0xc(%ebp),%eax
80102623:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102627:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010262a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010262e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102632:	ee                   	out    %al,(%dx)
}
80102633:	90                   	nop
80102634:	c9                   	leave  
80102635:	c3                   	ret    

80102636 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102636:	55                   	push   %ebp
80102637:	89 e5                	mov    %esp,%ebp
80102639:	56                   	push   %esi
8010263a:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
8010263b:	8b 55 08             	mov    0x8(%ebp),%edx
8010263e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102641:	8b 45 10             	mov    0x10(%ebp),%eax
80102644:	89 cb                	mov    %ecx,%ebx
80102646:	89 de                	mov    %ebx,%esi
80102648:	89 c1                	mov    %eax,%ecx
8010264a:	fc                   	cld    
8010264b:	f3 6f                	rep outsl %ds:(%esi),(%dx)
8010264d:	89 c8                	mov    %ecx,%eax
8010264f:	89 f3                	mov    %esi,%ebx
80102651:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102654:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102657:	90                   	nop
80102658:	5b                   	pop    %ebx
80102659:	5e                   	pop    %esi
8010265a:	5d                   	pop    %ebp
8010265b:	c3                   	ret    

8010265c <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
8010265c:	55                   	push   %ebp
8010265d:	89 e5                	mov    %esp,%ebp
8010265f:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102662:	90                   	nop
80102663:	68 f7 01 00 00       	push   $0x1f7
80102668:	e8 67 ff ff ff       	call   801025d4 <inb>
8010266d:	83 c4 04             	add    $0x4,%esp
80102670:	0f b6 c0             	movzbl %al,%eax
80102673:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102676:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102679:	25 c0 00 00 00       	and    $0xc0,%eax
8010267e:	83 f8 40             	cmp    $0x40,%eax
80102681:	75 e0                	jne    80102663 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102683:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102687:	74 11                	je     8010269a <idewait+0x3e>
80102689:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010268c:	83 e0 21             	and    $0x21,%eax
8010268f:	85 c0                	test   %eax,%eax
80102691:	74 07                	je     8010269a <idewait+0x3e>
    return -1;
80102693:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102698:	eb 05                	jmp    8010269f <idewait+0x43>
  return 0;
8010269a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010269f:	c9                   	leave  
801026a0:	c3                   	ret    

801026a1 <ideinit>:

void
ideinit(void)
{
801026a1:	55                   	push   %ebp
801026a2:	89 e5                	mov    %esp,%ebp
801026a4:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
801026a7:	83 ec 08             	sub    $0x8,%esp
801026aa:	68 af 8b 10 80       	push   $0x80108baf
801026af:	68 00 c6 10 80       	push   $0x8010c600
801026b4:	e8 a6 2a 00 00       	call   8010515f <initlock>
801026b9:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801026bc:	a1 a0 4d 11 80       	mov    0x80114da0,%eax
801026c1:	83 e8 01             	sub    $0x1,%eax
801026c4:	83 ec 08             	sub    $0x8,%esp
801026c7:	50                   	push   %eax
801026c8:	6a 0e                	push   $0xe
801026ca:	e8 a2 04 00 00       	call   80102b71 <ioapicenable>
801026cf:	83 c4 10             	add    $0x10,%esp
  idewait(0);
801026d2:	83 ec 0c             	sub    $0xc,%esp
801026d5:	6a 00                	push   $0x0
801026d7:	e8 80 ff ff ff       	call   8010265c <idewait>
801026dc:	83 c4 10             	add    $0x10,%esp

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801026df:	83 ec 08             	sub    $0x8,%esp
801026e2:	68 f0 00 00 00       	push   $0xf0
801026e7:	68 f6 01 00 00       	push   $0x1f6
801026ec:	e8 26 ff ff ff       	call   80102617 <outb>
801026f1:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
801026f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801026fb:	eb 24                	jmp    80102721 <ideinit+0x80>
    if(inb(0x1f7) != 0){
801026fd:	83 ec 0c             	sub    $0xc,%esp
80102700:	68 f7 01 00 00       	push   $0x1f7
80102705:	e8 ca fe ff ff       	call   801025d4 <inb>
8010270a:	83 c4 10             	add    $0x10,%esp
8010270d:	84 c0                	test   %al,%al
8010270f:	74 0c                	je     8010271d <ideinit+0x7c>
      havedisk1 = 1;
80102711:	c7 05 38 c6 10 80 01 	movl   $0x1,0x8010c638
80102718:	00 00 00 
      break;
8010271b:	eb 0d                	jmp    8010272a <ideinit+0x89>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
8010271d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102721:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102728:	7e d3                	jle    801026fd <ideinit+0x5c>
      break;
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
8010272a:	83 ec 08             	sub    $0x8,%esp
8010272d:	68 e0 00 00 00       	push   $0xe0
80102732:	68 f6 01 00 00       	push   $0x1f6
80102737:	e8 db fe ff ff       	call   80102617 <outb>
8010273c:	83 c4 10             	add    $0x10,%esp
}
8010273f:	90                   	nop
80102740:	c9                   	leave  
80102741:	c3                   	ret    

80102742 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102742:	55                   	push   %ebp
80102743:	89 e5                	mov    %esp,%ebp
80102745:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102748:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010274c:	75 0d                	jne    8010275b <idestart+0x19>
    panic("idestart");
8010274e:	83 ec 0c             	sub    $0xc,%esp
80102751:	68 b3 8b 10 80       	push   $0x80108bb3
80102756:	e8 45 de ff ff       	call   801005a0 <panic>
  if(b->blockno >= FSSIZE)
8010275b:	8b 45 08             	mov    0x8(%ebp),%eax
8010275e:	8b 40 08             	mov    0x8(%eax),%eax
80102761:	3d e7 03 00 00       	cmp    $0x3e7,%eax
80102766:	76 0d                	jbe    80102775 <idestart+0x33>
    panic("incorrect blockno");
80102768:	83 ec 0c             	sub    $0xc,%esp
8010276b:	68 bc 8b 10 80       	push   $0x80108bbc
80102770:	e8 2b de ff ff       	call   801005a0 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102775:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
8010277c:	8b 45 08             	mov    0x8(%ebp),%eax
8010277f:	8b 50 08             	mov    0x8(%eax),%edx
80102782:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102785:	0f af c2             	imul   %edx,%eax
80102788:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
8010278b:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
8010278f:	75 07                	jne    80102798 <idestart+0x56>
80102791:	b8 20 00 00 00       	mov    $0x20,%eax
80102796:	eb 05                	jmp    8010279d <idestart+0x5b>
80102798:	b8 c4 00 00 00       	mov    $0xc4,%eax
8010279d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
801027a0:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
801027a4:	75 07                	jne    801027ad <idestart+0x6b>
801027a6:	b8 30 00 00 00       	mov    $0x30,%eax
801027ab:	eb 05                	jmp    801027b2 <idestart+0x70>
801027ad:	b8 c5 00 00 00       	mov    $0xc5,%eax
801027b2:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
801027b5:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801027b9:	7e 0d                	jle    801027c8 <idestart+0x86>
801027bb:	83 ec 0c             	sub    $0xc,%esp
801027be:	68 b3 8b 10 80       	push   $0x80108bb3
801027c3:	e8 d8 dd ff ff       	call   801005a0 <panic>

  idewait(0);
801027c8:	83 ec 0c             	sub    $0xc,%esp
801027cb:	6a 00                	push   $0x0
801027cd:	e8 8a fe ff ff       	call   8010265c <idewait>
801027d2:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
801027d5:	83 ec 08             	sub    $0x8,%esp
801027d8:	6a 00                	push   $0x0
801027da:	68 f6 03 00 00       	push   $0x3f6
801027df:	e8 33 fe ff ff       	call   80102617 <outb>
801027e4:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
801027e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027ea:	0f b6 c0             	movzbl %al,%eax
801027ed:	83 ec 08             	sub    $0x8,%esp
801027f0:	50                   	push   %eax
801027f1:	68 f2 01 00 00       	push   $0x1f2
801027f6:	e8 1c fe ff ff       	call   80102617 <outb>
801027fb:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
801027fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102801:	0f b6 c0             	movzbl %al,%eax
80102804:	83 ec 08             	sub    $0x8,%esp
80102807:	50                   	push   %eax
80102808:	68 f3 01 00 00       	push   $0x1f3
8010280d:	e8 05 fe ff ff       	call   80102617 <outb>
80102812:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102815:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102818:	c1 f8 08             	sar    $0x8,%eax
8010281b:	0f b6 c0             	movzbl %al,%eax
8010281e:	83 ec 08             	sub    $0x8,%esp
80102821:	50                   	push   %eax
80102822:	68 f4 01 00 00       	push   $0x1f4
80102827:	e8 eb fd ff ff       	call   80102617 <outb>
8010282c:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
8010282f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102832:	c1 f8 10             	sar    $0x10,%eax
80102835:	0f b6 c0             	movzbl %al,%eax
80102838:	83 ec 08             	sub    $0x8,%esp
8010283b:	50                   	push   %eax
8010283c:	68 f5 01 00 00       	push   $0x1f5
80102841:	e8 d1 fd ff ff       	call   80102617 <outb>
80102846:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102849:	8b 45 08             	mov    0x8(%ebp),%eax
8010284c:	8b 40 04             	mov    0x4(%eax),%eax
8010284f:	83 e0 01             	and    $0x1,%eax
80102852:	c1 e0 04             	shl    $0x4,%eax
80102855:	89 c2                	mov    %eax,%edx
80102857:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010285a:	c1 f8 18             	sar    $0x18,%eax
8010285d:	83 e0 0f             	and    $0xf,%eax
80102860:	09 d0                	or     %edx,%eax
80102862:	83 c8 e0             	or     $0xffffffe0,%eax
80102865:	0f b6 c0             	movzbl %al,%eax
80102868:	83 ec 08             	sub    $0x8,%esp
8010286b:	50                   	push   %eax
8010286c:	68 f6 01 00 00       	push   $0x1f6
80102871:	e8 a1 fd ff ff       	call   80102617 <outb>
80102876:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102879:	8b 45 08             	mov    0x8(%ebp),%eax
8010287c:	8b 00                	mov    (%eax),%eax
8010287e:	83 e0 04             	and    $0x4,%eax
80102881:	85 c0                	test   %eax,%eax
80102883:	74 35                	je     801028ba <idestart+0x178>
    outb(0x1f7, write_cmd);
80102885:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102888:	0f b6 c0             	movzbl %al,%eax
8010288b:	83 ec 08             	sub    $0x8,%esp
8010288e:	50                   	push   %eax
8010288f:	68 f7 01 00 00       	push   $0x1f7
80102894:	e8 7e fd ff ff       	call   80102617 <outb>
80102899:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
8010289c:	8b 45 08             	mov    0x8(%ebp),%eax
8010289f:	83 c0 5c             	add    $0x5c,%eax
801028a2:	83 ec 04             	sub    $0x4,%esp
801028a5:	68 80 00 00 00       	push   $0x80
801028aa:	50                   	push   %eax
801028ab:	68 f0 01 00 00       	push   $0x1f0
801028b0:	e8 81 fd ff ff       	call   80102636 <outsl>
801028b5:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, read_cmd);
  }
}
801028b8:	eb 17                	jmp    801028d1 <idestart+0x18f>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
801028ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801028bd:	0f b6 c0             	movzbl %al,%eax
801028c0:	83 ec 08             	sub    $0x8,%esp
801028c3:	50                   	push   %eax
801028c4:	68 f7 01 00 00       	push   $0x1f7
801028c9:	e8 49 fd ff ff       	call   80102617 <outb>
801028ce:	83 c4 10             	add    $0x10,%esp
  }
}
801028d1:	90                   	nop
801028d2:	c9                   	leave  
801028d3:	c3                   	ret    

801028d4 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801028d4:	55                   	push   %ebp
801028d5:	89 e5                	mov    %esp,%ebp
801028d7:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801028da:	83 ec 0c             	sub    $0xc,%esp
801028dd:	68 00 c6 10 80       	push   $0x8010c600
801028e2:	e8 9a 28 00 00       	call   80105181 <acquire>
801028e7:	83 c4 10             	add    $0x10,%esp

  if((b = idequeue) == 0){
801028ea:	a1 34 c6 10 80       	mov    0x8010c634,%eax
801028ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801028f6:	75 15                	jne    8010290d <ideintr+0x39>
    release(&idelock);
801028f8:	83 ec 0c             	sub    $0xc,%esp
801028fb:	68 00 c6 10 80       	push   $0x8010c600
80102900:	e8 ea 28 00 00       	call   801051ef <release>
80102905:	83 c4 10             	add    $0x10,%esp
    return;
80102908:	e9 9a 00 00 00       	jmp    801029a7 <ideintr+0xd3>
  }
  idequeue = b->qnext;
8010290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102910:	8b 40 58             	mov    0x58(%eax),%eax
80102913:	a3 34 c6 10 80       	mov    %eax,0x8010c634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102918:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010291b:	8b 00                	mov    (%eax),%eax
8010291d:	83 e0 04             	and    $0x4,%eax
80102920:	85 c0                	test   %eax,%eax
80102922:	75 2d                	jne    80102951 <ideintr+0x7d>
80102924:	83 ec 0c             	sub    $0xc,%esp
80102927:	6a 01                	push   $0x1
80102929:	e8 2e fd ff ff       	call   8010265c <idewait>
8010292e:	83 c4 10             	add    $0x10,%esp
80102931:	85 c0                	test   %eax,%eax
80102933:	78 1c                	js     80102951 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
80102935:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102938:	83 c0 5c             	add    $0x5c,%eax
8010293b:	83 ec 04             	sub    $0x4,%esp
8010293e:	68 80 00 00 00       	push   $0x80
80102943:	50                   	push   %eax
80102944:	68 f0 01 00 00       	push   $0x1f0
80102949:	e8 a3 fc ff ff       	call   801025f1 <insl>
8010294e:	83 c4 10             	add    $0x10,%esp

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102951:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102954:	8b 00                	mov    (%eax),%eax
80102956:	83 c8 02             	or     $0x2,%eax
80102959:	89 c2                	mov    %eax,%edx
8010295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010295e:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102960:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102963:	8b 00                	mov    (%eax),%eax
80102965:	83 e0 fb             	and    $0xfffffffb,%eax
80102968:	89 c2                	mov    %eax,%edx
8010296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010296d:	89 10                	mov    %edx,(%eax)
  wakeup(b);
8010296f:	83 ec 0c             	sub    $0xc,%esp
80102972:	ff 75 f4             	pushl  -0xc(%ebp)
80102975:	e8 bb 23 00 00       	call   80104d35 <wakeup>
8010297a:	83 c4 10             	add    $0x10,%esp

  // Start disk on next buf in queue.
  if(idequeue != 0)
8010297d:	a1 34 c6 10 80       	mov    0x8010c634,%eax
80102982:	85 c0                	test   %eax,%eax
80102984:	74 11                	je     80102997 <ideintr+0xc3>
    idestart(idequeue);
80102986:	a1 34 c6 10 80       	mov    0x8010c634,%eax
8010298b:	83 ec 0c             	sub    $0xc,%esp
8010298e:	50                   	push   %eax
8010298f:	e8 ae fd ff ff       	call   80102742 <idestart>
80102994:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102997:	83 ec 0c             	sub    $0xc,%esp
8010299a:	68 00 c6 10 80       	push   $0x8010c600
8010299f:	e8 4b 28 00 00       	call   801051ef <release>
801029a4:	83 c4 10             	add    $0x10,%esp
}
801029a7:	c9                   	leave  
801029a8:	c3                   	ret    

801029a9 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801029a9:	55                   	push   %ebp
801029aa:	89 e5                	mov    %esp,%ebp
801029ac:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801029af:	8b 45 08             	mov    0x8(%ebp),%eax
801029b2:	83 c0 0c             	add    $0xc,%eax
801029b5:	83 ec 0c             	sub    $0xc,%esp
801029b8:	50                   	push   %eax
801029b9:	e8 32 27 00 00       	call   801050f0 <holdingsleep>
801029be:	83 c4 10             	add    $0x10,%esp
801029c1:	85 c0                	test   %eax,%eax
801029c3:	75 0d                	jne    801029d2 <iderw+0x29>
    panic("iderw: buf not locked");
801029c5:	83 ec 0c             	sub    $0xc,%esp
801029c8:	68 ce 8b 10 80       	push   $0x80108bce
801029cd:	e8 ce db ff ff       	call   801005a0 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801029d2:	8b 45 08             	mov    0x8(%ebp),%eax
801029d5:	8b 00                	mov    (%eax),%eax
801029d7:	83 e0 06             	and    $0x6,%eax
801029da:	83 f8 02             	cmp    $0x2,%eax
801029dd:	75 0d                	jne    801029ec <iderw+0x43>
    panic("iderw: nothing to do");
801029df:	83 ec 0c             	sub    $0xc,%esp
801029e2:	68 e4 8b 10 80       	push   $0x80108be4
801029e7:	e8 b4 db ff ff       	call   801005a0 <panic>
  if(b->dev != 0 && !havedisk1)
801029ec:	8b 45 08             	mov    0x8(%ebp),%eax
801029ef:	8b 40 04             	mov    0x4(%eax),%eax
801029f2:	85 c0                	test   %eax,%eax
801029f4:	74 16                	je     80102a0c <iderw+0x63>
801029f6:	a1 38 c6 10 80       	mov    0x8010c638,%eax
801029fb:	85 c0                	test   %eax,%eax
801029fd:	75 0d                	jne    80102a0c <iderw+0x63>
    panic("iderw: ide disk 1 not present");
801029ff:	83 ec 0c             	sub    $0xc,%esp
80102a02:	68 f9 8b 10 80       	push   $0x80108bf9
80102a07:	e8 94 db ff ff       	call   801005a0 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102a0c:	83 ec 0c             	sub    $0xc,%esp
80102a0f:	68 00 c6 10 80       	push   $0x8010c600
80102a14:	e8 68 27 00 00       	call   80105181 <acquire>
80102a19:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102a1c:	8b 45 08             	mov    0x8(%ebp),%eax
80102a1f:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a26:	c7 45 f4 34 c6 10 80 	movl   $0x8010c634,-0xc(%ebp)
80102a2d:	eb 0b                	jmp    80102a3a <iderw+0x91>
80102a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a32:	8b 00                	mov    (%eax),%eax
80102a34:	83 c0 58             	add    $0x58,%eax
80102a37:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a3d:	8b 00                	mov    (%eax),%eax
80102a3f:	85 c0                	test   %eax,%eax
80102a41:	75 ec                	jne    80102a2f <iderw+0x86>
    ;
  *pp = b;
80102a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a46:	8b 55 08             	mov    0x8(%ebp),%edx
80102a49:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
80102a4b:	a1 34 c6 10 80       	mov    0x8010c634,%eax
80102a50:	3b 45 08             	cmp    0x8(%ebp),%eax
80102a53:	75 23                	jne    80102a78 <iderw+0xcf>
    idestart(b);
80102a55:	83 ec 0c             	sub    $0xc,%esp
80102a58:	ff 75 08             	pushl  0x8(%ebp)
80102a5b:	e8 e2 fc ff ff       	call   80102742 <idestart>
80102a60:	83 c4 10             	add    $0x10,%esp

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a63:	eb 13                	jmp    80102a78 <iderw+0xcf>
    sleep(b, &idelock);
80102a65:	83 ec 08             	sub    $0x8,%esp
80102a68:	68 00 c6 10 80       	push   $0x8010c600
80102a6d:	ff 75 08             	pushl  0x8(%ebp)
80102a70:	e8 d7 21 00 00       	call   80104c4c <sleep>
80102a75:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a78:	8b 45 08             	mov    0x8(%ebp),%eax
80102a7b:	8b 00                	mov    (%eax),%eax
80102a7d:	83 e0 06             	and    $0x6,%eax
80102a80:	83 f8 02             	cmp    $0x2,%eax
80102a83:	75 e0                	jne    80102a65 <iderw+0xbc>
    sleep(b, &idelock);
  }


  release(&idelock);
80102a85:	83 ec 0c             	sub    $0xc,%esp
80102a88:	68 00 c6 10 80       	push   $0x8010c600
80102a8d:	e8 5d 27 00 00       	call   801051ef <release>
80102a92:	83 c4 10             	add    $0x10,%esp
}
80102a95:	90                   	nop
80102a96:	c9                   	leave  
80102a97:	c3                   	ret    

80102a98 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102a98:	55                   	push   %ebp
80102a99:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a9b:	a1 d4 46 11 80       	mov    0x801146d4,%eax
80102aa0:	8b 55 08             	mov    0x8(%ebp),%edx
80102aa3:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102aa5:	a1 d4 46 11 80       	mov    0x801146d4,%eax
80102aaa:	8b 40 10             	mov    0x10(%eax),%eax
}
80102aad:	5d                   	pop    %ebp
80102aae:	c3                   	ret    

80102aaf <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102aaf:	55                   	push   %ebp
80102ab0:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102ab2:	a1 d4 46 11 80       	mov    0x801146d4,%eax
80102ab7:	8b 55 08             	mov    0x8(%ebp),%edx
80102aba:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102abc:	a1 d4 46 11 80       	mov    0x801146d4,%eax
80102ac1:	8b 55 0c             	mov    0xc(%ebp),%edx
80102ac4:	89 50 10             	mov    %edx,0x10(%eax)
}
80102ac7:	90                   	nop
80102ac8:	5d                   	pop    %ebp
80102ac9:	c3                   	ret    

80102aca <ioapicinit>:

void
ioapicinit(void)
{
80102aca:	55                   	push   %ebp
80102acb:	89 e5                	mov    %esp,%ebp
80102acd:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102ad0:	c7 05 d4 46 11 80 00 	movl   $0xfec00000,0x801146d4
80102ad7:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102ada:	6a 01                	push   $0x1
80102adc:	e8 b7 ff ff ff       	call   80102a98 <ioapicread>
80102ae1:	83 c4 04             	add    $0x4,%esp
80102ae4:	c1 e8 10             	shr    $0x10,%eax
80102ae7:	25 ff 00 00 00       	and    $0xff,%eax
80102aec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102aef:	6a 00                	push   $0x0
80102af1:	e8 a2 ff ff ff       	call   80102a98 <ioapicread>
80102af6:	83 c4 04             	add    $0x4,%esp
80102af9:	c1 e8 18             	shr    $0x18,%eax
80102afc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102aff:	0f b6 05 00 48 11 80 	movzbl 0x80114800,%eax
80102b06:	0f b6 c0             	movzbl %al,%eax
80102b09:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102b0c:	74 10                	je     80102b1e <ioapicinit+0x54>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102b0e:	83 ec 0c             	sub    $0xc,%esp
80102b11:	68 18 8c 10 80       	push   $0x80108c18
80102b16:	e8 e5 d8 ff ff       	call   80100400 <cprintf>
80102b1b:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102b1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102b25:	eb 3f                	jmp    80102b66 <ioapicinit+0x9c>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b2a:	83 c0 20             	add    $0x20,%eax
80102b2d:	0d 00 00 01 00       	or     $0x10000,%eax
80102b32:	89 c2                	mov    %eax,%edx
80102b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b37:	83 c0 08             	add    $0x8,%eax
80102b3a:	01 c0                	add    %eax,%eax
80102b3c:	83 ec 08             	sub    $0x8,%esp
80102b3f:	52                   	push   %edx
80102b40:	50                   	push   %eax
80102b41:	e8 69 ff ff ff       	call   80102aaf <ioapicwrite>
80102b46:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b4c:	83 c0 08             	add    $0x8,%eax
80102b4f:	01 c0                	add    %eax,%eax
80102b51:	83 c0 01             	add    $0x1,%eax
80102b54:	83 ec 08             	sub    $0x8,%esp
80102b57:	6a 00                	push   $0x0
80102b59:	50                   	push   %eax
80102b5a:	e8 50 ff ff ff       	call   80102aaf <ioapicwrite>
80102b5f:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102b62:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b69:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102b6c:	7e b9                	jle    80102b27 <ioapicinit+0x5d>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102b6e:	90                   	nop
80102b6f:	c9                   	leave  
80102b70:	c3                   	ret    

80102b71 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102b71:	55                   	push   %ebp
80102b72:	89 e5                	mov    %esp,%ebp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b74:	8b 45 08             	mov    0x8(%ebp),%eax
80102b77:	83 c0 20             	add    $0x20,%eax
80102b7a:	89 c2                	mov    %eax,%edx
80102b7c:	8b 45 08             	mov    0x8(%ebp),%eax
80102b7f:	83 c0 08             	add    $0x8,%eax
80102b82:	01 c0                	add    %eax,%eax
80102b84:	52                   	push   %edx
80102b85:	50                   	push   %eax
80102b86:	e8 24 ff ff ff       	call   80102aaf <ioapicwrite>
80102b8b:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b91:	c1 e0 18             	shl    $0x18,%eax
80102b94:	89 c2                	mov    %eax,%edx
80102b96:	8b 45 08             	mov    0x8(%ebp),%eax
80102b99:	83 c0 08             	add    $0x8,%eax
80102b9c:	01 c0                	add    %eax,%eax
80102b9e:	83 c0 01             	add    $0x1,%eax
80102ba1:	52                   	push   %edx
80102ba2:	50                   	push   %eax
80102ba3:	e8 07 ff ff ff       	call   80102aaf <ioapicwrite>
80102ba8:	83 c4 08             	add    $0x8,%esp
}
80102bab:	90                   	nop
80102bac:	c9                   	leave  
80102bad:	c3                   	ret    

80102bae <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102bae:	55                   	push   %ebp
80102baf:	89 e5                	mov    %esp,%ebp
80102bb1:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102bb4:	83 ec 08             	sub    $0x8,%esp
80102bb7:	68 4a 8c 10 80       	push   $0x80108c4a
80102bbc:	68 e0 46 11 80       	push   $0x801146e0
80102bc1:	e8 99 25 00 00       	call   8010515f <initlock>
80102bc6:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102bc9:	c7 05 14 47 11 80 00 	movl   $0x0,0x80114714
80102bd0:	00 00 00 
  freerange(vstart, vend);
80102bd3:	83 ec 08             	sub    $0x8,%esp
80102bd6:	ff 75 0c             	pushl  0xc(%ebp)
80102bd9:	ff 75 08             	pushl  0x8(%ebp)
80102bdc:	e8 2a 00 00 00       	call   80102c0b <freerange>
80102be1:	83 c4 10             	add    $0x10,%esp
}
80102be4:	90                   	nop
80102be5:	c9                   	leave  
80102be6:	c3                   	ret    

80102be7 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102be7:	55                   	push   %ebp
80102be8:	89 e5                	mov    %esp,%ebp
80102bea:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102bed:	83 ec 08             	sub    $0x8,%esp
80102bf0:	ff 75 0c             	pushl  0xc(%ebp)
80102bf3:	ff 75 08             	pushl  0x8(%ebp)
80102bf6:	e8 10 00 00 00       	call   80102c0b <freerange>
80102bfb:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102bfe:	c7 05 14 47 11 80 01 	movl   $0x1,0x80114714
80102c05:	00 00 00 
}
80102c08:	90                   	nop
80102c09:	c9                   	leave  
80102c0a:	c3                   	ret    

80102c0b <freerange>:

void
freerange(void *vstart, void *vend)
{
80102c0b:	55                   	push   %ebp
80102c0c:	89 e5                	mov    %esp,%ebp
80102c0e:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102c11:	8b 45 08             	mov    0x8(%ebp),%eax
80102c14:	05 ff 0f 00 00       	add    $0xfff,%eax
80102c19:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102c1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c21:	eb 15                	jmp    80102c38 <freerange+0x2d>
    kfree(p);
80102c23:	83 ec 0c             	sub    $0xc,%esp
80102c26:	ff 75 f4             	pushl  -0xc(%ebp)
80102c29:	e8 1a 00 00 00       	call   80102c48 <kfree>
80102c2e:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c31:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c3b:	05 00 10 00 00       	add    $0x1000,%eax
80102c40:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102c43:	76 de                	jbe    80102c23 <freerange+0x18>
    kfree(p);
}
80102c45:	90                   	nop
80102c46:	c9                   	leave  
80102c47:	c3                   	ret    

80102c48 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102c48:	55                   	push   %ebp
80102c49:	89 e5                	mov    %esp,%ebp
80102c4b:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102c4e:	8b 45 08             	mov    0x8(%ebp),%eax
80102c51:	25 ff 0f 00 00       	and    $0xfff,%eax
80102c56:	85 c0                	test   %eax,%eax
80102c58:	75 18                	jne    80102c72 <kfree+0x2a>
80102c5a:	81 7d 08 48 99 11 80 	cmpl   $0x80119948,0x8(%ebp)
80102c61:	72 0f                	jb     80102c72 <kfree+0x2a>
80102c63:	8b 45 08             	mov    0x8(%ebp),%eax
80102c66:	05 00 00 00 80       	add    $0x80000000,%eax
80102c6b:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102c70:	76 0d                	jbe    80102c7f <kfree+0x37>
    panic("kfree");
80102c72:	83 ec 0c             	sub    $0xc,%esp
80102c75:	68 4f 8c 10 80       	push   $0x80108c4f
80102c7a:	e8 21 d9 ff ff       	call   801005a0 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102c7f:	83 ec 04             	sub    $0x4,%esp
80102c82:	68 00 10 00 00       	push   $0x1000
80102c87:	6a 01                	push   $0x1
80102c89:	ff 75 08             	pushl  0x8(%ebp)
80102c8c:	e8 67 27 00 00       	call   801053f8 <memset>
80102c91:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102c94:	a1 14 47 11 80       	mov    0x80114714,%eax
80102c99:	85 c0                	test   %eax,%eax
80102c9b:	74 10                	je     80102cad <kfree+0x65>
    acquire(&kmem.lock);
80102c9d:	83 ec 0c             	sub    $0xc,%esp
80102ca0:	68 e0 46 11 80       	push   $0x801146e0
80102ca5:	e8 d7 24 00 00       	call   80105181 <acquire>
80102caa:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102cad:	8b 45 08             	mov    0x8(%ebp),%eax
80102cb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102cb3:	8b 15 18 47 11 80    	mov    0x80114718,%edx
80102cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cbc:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cc1:	a3 18 47 11 80       	mov    %eax,0x80114718
  if(kmem.use_lock)
80102cc6:	a1 14 47 11 80       	mov    0x80114714,%eax
80102ccb:	85 c0                	test   %eax,%eax
80102ccd:	74 10                	je     80102cdf <kfree+0x97>
    release(&kmem.lock);
80102ccf:	83 ec 0c             	sub    $0xc,%esp
80102cd2:	68 e0 46 11 80       	push   $0x801146e0
80102cd7:	e8 13 25 00 00       	call   801051ef <release>
80102cdc:	83 c4 10             	add    $0x10,%esp
}
80102cdf:	90                   	nop
80102ce0:	c9                   	leave  
80102ce1:	c3                   	ret    

80102ce2 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102ce2:	55                   	push   %ebp
80102ce3:	89 e5                	mov    %esp,%ebp
80102ce5:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102ce8:	a1 14 47 11 80       	mov    0x80114714,%eax
80102ced:	85 c0                	test   %eax,%eax
80102cef:	74 10                	je     80102d01 <kalloc+0x1f>
    acquire(&kmem.lock);
80102cf1:	83 ec 0c             	sub    $0xc,%esp
80102cf4:	68 e0 46 11 80       	push   $0x801146e0
80102cf9:	e8 83 24 00 00       	call   80105181 <acquire>
80102cfe:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102d01:	a1 18 47 11 80       	mov    0x80114718,%eax
80102d06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102d09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102d0d:	74 0a                	je     80102d19 <kalloc+0x37>
    kmem.freelist = r->next;
80102d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d12:	8b 00                	mov    (%eax),%eax
80102d14:	a3 18 47 11 80       	mov    %eax,0x80114718
  if(kmem.use_lock)
80102d19:	a1 14 47 11 80       	mov    0x80114714,%eax
80102d1e:	85 c0                	test   %eax,%eax
80102d20:	74 10                	je     80102d32 <kalloc+0x50>
    release(&kmem.lock);
80102d22:	83 ec 0c             	sub    $0xc,%esp
80102d25:	68 e0 46 11 80       	push   $0x801146e0
80102d2a:	e8 c0 24 00 00       	call   801051ef <release>
80102d2f:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102d35:	c9                   	leave  
80102d36:	c3                   	ret    

80102d37 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102d37:	55                   	push   %ebp
80102d38:	89 e5                	mov    %esp,%ebp
80102d3a:	83 ec 14             	sub    $0x14,%esp
80102d3d:	8b 45 08             	mov    0x8(%ebp),%eax
80102d40:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d44:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102d48:	89 c2                	mov    %eax,%edx
80102d4a:	ec                   	in     (%dx),%al
80102d4b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102d4e:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102d52:	c9                   	leave  
80102d53:	c3                   	ret    

80102d54 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102d54:	55                   	push   %ebp
80102d55:	89 e5                	mov    %esp,%ebp
80102d57:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102d5a:	6a 64                	push   $0x64
80102d5c:	e8 d6 ff ff ff       	call   80102d37 <inb>
80102d61:	83 c4 04             	add    $0x4,%esp
80102d64:	0f b6 c0             	movzbl %al,%eax
80102d67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d6d:	83 e0 01             	and    $0x1,%eax
80102d70:	85 c0                	test   %eax,%eax
80102d72:	75 0a                	jne    80102d7e <kbdgetc+0x2a>
    return -1;
80102d74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d79:	e9 23 01 00 00       	jmp    80102ea1 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102d7e:	6a 60                	push   $0x60
80102d80:	e8 b2 ff ff ff       	call   80102d37 <inb>
80102d85:	83 c4 04             	add    $0x4,%esp
80102d88:	0f b6 c0             	movzbl %al,%eax
80102d8b:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102d8e:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102d95:	75 17                	jne    80102dae <kbdgetc+0x5a>
    shift |= E0ESC;
80102d97:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102d9c:	83 c8 40             	or     $0x40,%eax
80102d9f:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
    return 0;
80102da4:	b8 00 00 00 00       	mov    $0x0,%eax
80102da9:	e9 f3 00 00 00       	jmp    80102ea1 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102dae:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102db1:	25 80 00 00 00       	and    $0x80,%eax
80102db6:	85 c0                	test   %eax,%eax
80102db8:	74 45                	je     80102dff <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102dba:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102dbf:	83 e0 40             	and    $0x40,%eax
80102dc2:	85 c0                	test   %eax,%eax
80102dc4:	75 08                	jne    80102dce <kbdgetc+0x7a>
80102dc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dc9:	83 e0 7f             	and    $0x7f,%eax
80102dcc:	eb 03                	jmp    80102dd1 <kbdgetc+0x7d>
80102dce:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dd1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102dd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dd7:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102ddc:	0f b6 00             	movzbl (%eax),%eax
80102ddf:	83 c8 40             	or     $0x40,%eax
80102de2:	0f b6 c0             	movzbl %al,%eax
80102de5:	f7 d0                	not    %eax
80102de7:	89 c2                	mov    %eax,%edx
80102de9:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102dee:	21 d0                	and    %edx,%eax
80102df0:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
    return 0;
80102df5:	b8 00 00 00 00       	mov    $0x0,%eax
80102dfa:	e9 a2 00 00 00       	jmp    80102ea1 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102dff:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102e04:	83 e0 40             	and    $0x40,%eax
80102e07:	85 c0                	test   %eax,%eax
80102e09:	74 14                	je     80102e1f <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102e0b:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102e12:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102e17:	83 e0 bf             	and    $0xffffffbf,%eax
80102e1a:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
  }

  shift |= shiftcode[data];
80102e1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e22:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102e27:	0f b6 00             	movzbl (%eax),%eax
80102e2a:	0f b6 d0             	movzbl %al,%edx
80102e2d:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102e32:	09 d0                	or     %edx,%eax
80102e34:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
  shift ^= togglecode[data];
80102e39:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e3c:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102e41:	0f b6 00             	movzbl (%eax),%eax
80102e44:	0f b6 d0             	movzbl %al,%edx
80102e47:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102e4c:	31 d0                	xor    %edx,%eax
80102e4e:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102e53:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102e58:	83 e0 03             	and    $0x3,%eax
80102e5b:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102e62:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e65:	01 d0                	add    %edx,%eax
80102e67:	0f b6 00             	movzbl (%eax),%eax
80102e6a:	0f b6 c0             	movzbl %al,%eax
80102e6d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102e70:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102e75:	83 e0 08             	and    $0x8,%eax
80102e78:	85 c0                	test   %eax,%eax
80102e7a:	74 22                	je     80102e9e <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102e7c:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102e80:	76 0c                	jbe    80102e8e <kbdgetc+0x13a>
80102e82:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102e86:	77 06                	ja     80102e8e <kbdgetc+0x13a>
      c += 'A' - 'a';
80102e88:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102e8c:	eb 10                	jmp    80102e9e <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102e8e:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102e92:	76 0a                	jbe    80102e9e <kbdgetc+0x14a>
80102e94:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102e98:	77 04                	ja     80102e9e <kbdgetc+0x14a>
      c += 'a' - 'A';
80102e9a:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102e9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102ea1:	c9                   	leave  
80102ea2:	c3                   	ret    

80102ea3 <kbdintr>:

void
kbdintr(void)
{
80102ea3:	55                   	push   %ebp
80102ea4:	89 e5                	mov    %esp,%ebp
80102ea6:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102ea9:	83 ec 0c             	sub    $0xc,%esp
80102eac:	68 54 2d 10 80       	push   $0x80102d54
80102eb1:	e8 76 d9 ff ff       	call   8010082c <consoleintr>
80102eb6:	83 c4 10             	add    $0x10,%esp
}
80102eb9:	90                   	nop
80102eba:	c9                   	leave  
80102ebb:	c3                   	ret    

80102ebc <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102ebc:	55                   	push   %ebp
80102ebd:	89 e5                	mov    %esp,%ebp
80102ebf:	83 ec 14             	sub    $0x14,%esp
80102ec2:	8b 45 08             	mov    0x8(%ebp),%eax
80102ec5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ec9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102ecd:	89 c2                	mov    %eax,%edx
80102ecf:	ec                   	in     (%dx),%al
80102ed0:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102ed3:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102ed7:	c9                   	leave  
80102ed8:	c3                   	ret    

80102ed9 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102ed9:	55                   	push   %ebp
80102eda:	89 e5                	mov    %esp,%ebp
80102edc:	83 ec 08             	sub    $0x8,%esp
80102edf:	8b 55 08             	mov    0x8(%ebp),%edx
80102ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ee5:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102ee9:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102eec:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102ef0:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102ef4:	ee                   	out    %al,(%dx)
}
80102ef5:	90                   	nop
80102ef6:	c9                   	leave  
80102ef7:	c3                   	ret    

80102ef8 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80102ef8:	55                   	push   %ebp
80102ef9:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102efb:	a1 1c 47 11 80       	mov    0x8011471c,%eax
80102f00:	8b 55 08             	mov    0x8(%ebp),%edx
80102f03:	c1 e2 02             	shl    $0x2,%edx
80102f06:	01 c2                	add    %eax,%edx
80102f08:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f0b:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102f0d:	a1 1c 47 11 80       	mov    0x8011471c,%eax
80102f12:	83 c0 20             	add    $0x20,%eax
80102f15:	8b 00                	mov    (%eax),%eax
}
80102f17:	90                   	nop
80102f18:	5d                   	pop    %ebp
80102f19:	c3                   	ret    

80102f1a <lapicinit>:

void
lapicinit(void)
{
80102f1a:	55                   	push   %ebp
80102f1b:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102f1d:	a1 1c 47 11 80       	mov    0x8011471c,%eax
80102f22:	85 c0                	test   %eax,%eax
80102f24:	0f 84 0b 01 00 00    	je     80103035 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102f2a:	68 3f 01 00 00       	push   $0x13f
80102f2f:	6a 3c                	push   $0x3c
80102f31:	e8 c2 ff ff ff       	call   80102ef8 <lapicw>
80102f36:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102f39:	6a 0b                	push   $0xb
80102f3b:	68 f8 00 00 00       	push   $0xf8
80102f40:	e8 b3 ff ff ff       	call   80102ef8 <lapicw>
80102f45:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102f48:	68 20 00 02 00       	push   $0x20020
80102f4d:	68 c8 00 00 00       	push   $0xc8
80102f52:	e8 a1 ff ff ff       	call   80102ef8 <lapicw>
80102f57:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000);
80102f5a:	68 80 96 98 00       	push   $0x989680
80102f5f:	68 e0 00 00 00       	push   $0xe0
80102f64:	e8 8f ff ff ff       	call   80102ef8 <lapicw>
80102f69:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102f6c:	68 00 00 01 00       	push   $0x10000
80102f71:	68 d4 00 00 00       	push   $0xd4
80102f76:	e8 7d ff ff ff       	call   80102ef8 <lapicw>
80102f7b:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102f7e:	68 00 00 01 00       	push   $0x10000
80102f83:	68 d8 00 00 00       	push   $0xd8
80102f88:	e8 6b ff ff ff       	call   80102ef8 <lapicw>
80102f8d:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102f90:	a1 1c 47 11 80       	mov    0x8011471c,%eax
80102f95:	83 c0 30             	add    $0x30,%eax
80102f98:	8b 00                	mov    (%eax),%eax
80102f9a:	c1 e8 10             	shr    $0x10,%eax
80102f9d:	0f b6 c0             	movzbl %al,%eax
80102fa0:	83 f8 03             	cmp    $0x3,%eax
80102fa3:	76 12                	jbe    80102fb7 <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80102fa5:	68 00 00 01 00       	push   $0x10000
80102faa:	68 d0 00 00 00       	push   $0xd0
80102faf:	e8 44 ff ff ff       	call   80102ef8 <lapicw>
80102fb4:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102fb7:	6a 33                	push   $0x33
80102fb9:	68 dc 00 00 00       	push   $0xdc
80102fbe:	e8 35 ff ff ff       	call   80102ef8 <lapicw>
80102fc3:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102fc6:	6a 00                	push   $0x0
80102fc8:	68 a0 00 00 00       	push   $0xa0
80102fcd:	e8 26 ff ff ff       	call   80102ef8 <lapicw>
80102fd2:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102fd5:	6a 00                	push   $0x0
80102fd7:	68 a0 00 00 00       	push   $0xa0
80102fdc:	e8 17 ff ff ff       	call   80102ef8 <lapicw>
80102fe1:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102fe4:	6a 00                	push   $0x0
80102fe6:	6a 2c                	push   $0x2c
80102fe8:	e8 0b ff ff ff       	call   80102ef8 <lapicw>
80102fed:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102ff0:	6a 00                	push   $0x0
80102ff2:	68 c4 00 00 00       	push   $0xc4
80102ff7:	e8 fc fe ff ff       	call   80102ef8 <lapicw>
80102ffc:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102fff:	68 00 85 08 00       	push   $0x88500
80103004:	68 c0 00 00 00       	push   $0xc0
80103009:	e8 ea fe ff ff       	call   80102ef8 <lapicw>
8010300e:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80103011:	90                   	nop
80103012:	a1 1c 47 11 80       	mov    0x8011471c,%eax
80103017:	05 00 03 00 00       	add    $0x300,%eax
8010301c:	8b 00                	mov    (%eax),%eax
8010301e:	25 00 10 00 00       	and    $0x1000,%eax
80103023:	85 c0                	test   %eax,%eax
80103025:	75 eb                	jne    80103012 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80103027:	6a 00                	push   $0x0
80103029:	6a 20                	push   $0x20
8010302b:	e8 c8 fe ff ff       	call   80102ef8 <lapicw>
80103030:	83 c4 08             	add    $0x8,%esp
80103033:	eb 01                	jmp    80103036 <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic)
    return;
80103035:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103036:	c9                   	leave  
80103037:	c3                   	ret    

80103038 <lapicid>:

int
lapicid(void)
{
80103038:	55                   	push   %ebp
80103039:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010303b:	a1 1c 47 11 80       	mov    0x8011471c,%eax
80103040:	85 c0                	test   %eax,%eax
80103042:	75 07                	jne    8010304b <lapicid+0x13>
    return 0;
80103044:	b8 00 00 00 00       	mov    $0x0,%eax
80103049:	eb 0d                	jmp    80103058 <lapicid+0x20>
  return lapic[ID] >> 24;
8010304b:	a1 1c 47 11 80       	mov    0x8011471c,%eax
80103050:	83 c0 20             	add    $0x20,%eax
80103053:	8b 00                	mov    (%eax),%eax
80103055:	c1 e8 18             	shr    $0x18,%eax
}
80103058:	5d                   	pop    %ebp
80103059:	c3                   	ret    

8010305a <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
8010305a:	55                   	push   %ebp
8010305b:	89 e5                	mov    %esp,%ebp
  if(lapic)
8010305d:	a1 1c 47 11 80       	mov    0x8011471c,%eax
80103062:	85 c0                	test   %eax,%eax
80103064:	74 0c                	je     80103072 <lapiceoi+0x18>
    lapicw(EOI, 0);
80103066:	6a 00                	push   $0x0
80103068:	6a 2c                	push   $0x2c
8010306a:	e8 89 fe ff ff       	call   80102ef8 <lapicw>
8010306f:	83 c4 08             	add    $0x8,%esp
}
80103072:	90                   	nop
80103073:	c9                   	leave  
80103074:	c3                   	ret    

80103075 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103075:	55                   	push   %ebp
80103076:	89 e5                	mov    %esp,%ebp
}
80103078:	90                   	nop
80103079:	5d                   	pop    %ebp
8010307a:	c3                   	ret    

8010307b <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
8010307b:	55                   	push   %ebp
8010307c:	89 e5                	mov    %esp,%ebp
8010307e:	83 ec 14             	sub    $0x14,%esp
80103081:	8b 45 08             	mov    0x8(%ebp),%eax
80103084:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80103087:	6a 0f                	push   $0xf
80103089:	6a 70                	push   $0x70
8010308b:	e8 49 fe ff ff       	call   80102ed9 <outb>
80103090:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80103093:	6a 0a                	push   $0xa
80103095:	6a 71                	push   $0x71
80103097:	e8 3d fe ff ff       	call   80102ed9 <outb>
8010309c:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
8010309f:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
801030a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
801030a9:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
801030ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
801030b1:	83 c0 02             	add    $0x2,%eax
801030b4:	8b 55 0c             	mov    0xc(%ebp),%edx
801030b7:	c1 ea 04             	shr    $0x4,%edx
801030ba:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801030bd:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801030c1:	c1 e0 18             	shl    $0x18,%eax
801030c4:	50                   	push   %eax
801030c5:	68 c4 00 00 00       	push   $0xc4
801030ca:	e8 29 fe ff ff       	call   80102ef8 <lapicw>
801030cf:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801030d2:	68 00 c5 00 00       	push   $0xc500
801030d7:	68 c0 00 00 00       	push   $0xc0
801030dc:	e8 17 fe ff ff       	call   80102ef8 <lapicw>
801030e1:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801030e4:	68 c8 00 00 00       	push   $0xc8
801030e9:	e8 87 ff ff ff       	call   80103075 <microdelay>
801030ee:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
801030f1:	68 00 85 00 00       	push   $0x8500
801030f6:	68 c0 00 00 00       	push   $0xc0
801030fb:	e8 f8 fd ff ff       	call   80102ef8 <lapicw>
80103100:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103103:	6a 64                	push   $0x64
80103105:	e8 6b ff ff ff       	call   80103075 <microdelay>
8010310a:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010310d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103114:	eb 3d                	jmp    80103153 <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
80103116:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010311a:	c1 e0 18             	shl    $0x18,%eax
8010311d:	50                   	push   %eax
8010311e:	68 c4 00 00 00       	push   $0xc4
80103123:	e8 d0 fd ff ff       	call   80102ef8 <lapicw>
80103128:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
8010312b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010312e:	c1 e8 0c             	shr    $0xc,%eax
80103131:	80 cc 06             	or     $0x6,%ah
80103134:	50                   	push   %eax
80103135:	68 c0 00 00 00       	push   $0xc0
8010313a:	e8 b9 fd ff ff       	call   80102ef8 <lapicw>
8010313f:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80103142:	68 c8 00 00 00       	push   $0xc8
80103147:	e8 29 ff ff ff       	call   80103075 <microdelay>
8010314c:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010314f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103153:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103157:	7e bd                	jle    80103116 <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103159:	90                   	nop
8010315a:	c9                   	leave  
8010315b:	c3                   	ret    

8010315c <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
8010315c:	55                   	push   %ebp
8010315d:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
8010315f:	8b 45 08             	mov    0x8(%ebp),%eax
80103162:	0f b6 c0             	movzbl %al,%eax
80103165:	50                   	push   %eax
80103166:	6a 70                	push   $0x70
80103168:	e8 6c fd ff ff       	call   80102ed9 <outb>
8010316d:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103170:	68 c8 00 00 00       	push   $0xc8
80103175:	e8 fb fe ff ff       	call   80103075 <microdelay>
8010317a:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
8010317d:	6a 71                	push   $0x71
8010317f:	e8 38 fd ff ff       	call   80102ebc <inb>
80103184:	83 c4 04             	add    $0x4,%esp
80103187:	0f b6 c0             	movzbl %al,%eax
}
8010318a:	c9                   	leave  
8010318b:	c3                   	ret    

8010318c <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
8010318c:	55                   	push   %ebp
8010318d:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
8010318f:	6a 00                	push   $0x0
80103191:	e8 c6 ff ff ff       	call   8010315c <cmos_read>
80103196:	83 c4 04             	add    $0x4,%esp
80103199:	89 c2                	mov    %eax,%edx
8010319b:	8b 45 08             	mov    0x8(%ebp),%eax
8010319e:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
801031a0:	6a 02                	push   $0x2
801031a2:	e8 b5 ff ff ff       	call   8010315c <cmos_read>
801031a7:	83 c4 04             	add    $0x4,%esp
801031aa:	89 c2                	mov    %eax,%edx
801031ac:	8b 45 08             	mov    0x8(%ebp),%eax
801031af:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
801031b2:	6a 04                	push   $0x4
801031b4:	e8 a3 ff ff ff       	call   8010315c <cmos_read>
801031b9:	83 c4 04             	add    $0x4,%esp
801031bc:	89 c2                	mov    %eax,%edx
801031be:	8b 45 08             	mov    0x8(%ebp),%eax
801031c1:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
801031c4:	6a 07                	push   $0x7
801031c6:	e8 91 ff ff ff       	call   8010315c <cmos_read>
801031cb:	83 c4 04             	add    $0x4,%esp
801031ce:	89 c2                	mov    %eax,%edx
801031d0:	8b 45 08             	mov    0x8(%ebp),%eax
801031d3:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
801031d6:	6a 08                	push   $0x8
801031d8:	e8 7f ff ff ff       	call   8010315c <cmos_read>
801031dd:	83 c4 04             	add    $0x4,%esp
801031e0:	89 c2                	mov    %eax,%edx
801031e2:	8b 45 08             	mov    0x8(%ebp),%eax
801031e5:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
801031e8:	6a 09                	push   $0x9
801031ea:	e8 6d ff ff ff       	call   8010315c <cmos_read>
801031ef:	83 c4 04             	add    $0x4,%esp
801031f2:	89 c2                	mov    %eax,%edx
801031f4:	8b 45 08             	mov    0x8(%ebp),%eax
801031f7:	89 50 14             	mov    %edx,0x14(%eax)
}
801031fa:	90                   	nop
801031fb:	c9                   	leave  
801031fc:	c3                   	ret    

801031fd <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801031fd:	55                   	push   %ebp
801031fe:	89 e5                	mov    %esp,%ebp
80103200:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103203:	6a 0b                	push   $0xb
80103205:	e8 52 ff ff ff       	call   8010315c <cmos_read>
8010320a:	83 c4 04             	add    $0x4,%esp
8010320d:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103210:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103213:	83 e0 04             	and    $0x4,%eax
80103216:	85 c0                	test   %eax,%eax
80103218:	0f 94 c0             	sete   %al
8010321b:	0f b6 c0             	movzbl %al,%eax
8010321e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80103221:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103224:	50                   	push   %eax
80103225:	e8 62 ff ff ff       	call   8010318c <fill_rtcdate>
8010322a:	83 c4 04             	add    $0x4,%esp
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010322d:	6a 0a                	push   $0xa
8010322f:	e8 28 ff ff ff       	call   8010315c <cmos_read>
80103234:	83 c4 04             	add    $0x4,%esp
80103237:	25 80 00 00 00       	and    $0x80,%eax
8010323c:	85 c0                	test   %eax,%eax
8010323e:	75 27                	jne    80103267 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
80103240:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103243:	50                   	push   %eax
80103244:	e8 43 ff ff ff       	call   8010318c <fill_rtcdate>
80103249:	83 c4 04             	add    $0x4,%esp
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010324c:	83 ec 04             	sub    $0x4,%esp
8010324f:	6a 18                	push   $0x18
80103251:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103254:	50                   	push   %eax
80103255:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103258:	50                   	push   %eax
80103259:	e8 01 22 00 00       	call   8010545f <memcmp>
8010325e:	83 c4 10             	add    $0x10,%esp
80103261:	85 c0                	test   %eax,%eax
80103263:	74 05                	je     8010326a <cmostime+0x6d>
80103265:	eb ba                	jmp    80103221 <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
80103267:	90                   	nop
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103268:	eb b7                	jmp    80103221 <cmostime+0x24>
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
8010326a:	90                   	nop
  }

  // convert
  if(bcd) {
8010326b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010326f:	0f 84 b4 00 00 00    	je     80103329 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103275:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103278:	c1 e8 04             	shr    $0x4,%eax
8010327b:	89 c2                	mov    %eax,%edx
8010327d:	89 d0                	mov    %edx,%eax
8010327f:	c1 e0 02             	shl    $0x2,%eax
80103282:	01 d0                	add    %edx,%eax
80103284:	01 c0                	add    %eax,%eax
80103286:	89 c2                	mov    %eax,%edx
80103288:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010328b:	83 e0 0f             	and    $0xf,%eax
8010328e:	01 d0                	add    %edx,%eax
80103290:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103293:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103296:	c1 e8 04             	shr    $0x4,%eax
80103299:	89 c2                	mov    %eax,%edx
8010329b:	89 d0                	mov    %edx,%eax
8010329d:	c1 e0 02             	shl    $0x2,%eax
801032a0:	01 d0                	add    %edx,%eax
801032a2:	01 c0                	add    %eax,%eax
801032a4:	89 c2                	mov    %eax,%edx
801032a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801032a9:	83 e0 0f             	and    $0xf,%eax
801032ac:	01 d0                	add    %edx,%eax
801032ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801032b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801032b4:	c1 e8 04             	shr    $0x4,%eax
801032b7:	89 c2                	mov    %eax,%edx
801032b9:	89 d0                	mov    %edx,%eax
801032bb:	c1 e0 02             	shl    $0x2,%eax
801032be:	01 d0                	add    %edx,%eax
801032c0:	01 c0                	add    %eax,%eax
801032c2:	89 c2                	mov    %eax,%edx
801032c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801032c7:	83 e0 0f             	and    $0xf,%eax
801032ca:	01 d0                	add    %edx,%eax
801032cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801032cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801032d2:	c1 e8 04             	shr    $0x4,%eax
801032d5:	89 c2                	mov    %eax,%edx
801032d7:	89 d0                	mov    %edx,%eax
801032d9:	c1 e0 02             	shl    $0x2,%eax
801032dc:	01 d0                	add    %edx,%eax
801032de:	01 c0                	add    %eax,%eax
801032e0:	89 c2                	mov    %eax,%edx
801032e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801032e5:	83 e0 0f             	and    $0xf,%eax
801032e8:	01 d0                	add    %edx,%eax
801032ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801032ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
801032f0:	c1 e8 04             	shr    $0x4,%eax
801032f3:	89 c2                	mov    %eax,%edx
801032f5:	89 d0                	mov    %edx,%eax
801032f7:	c1 e0 02             	shl    $0x2,%eax
801032fa:	01 d0                	add    %edx,%eax
801032fc:	01 c0                	add    %eax,%eax
801032fe:	89 c2                	mov    %eax,%edx
80103300:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103303:	83 e0 0f             	and    $0xf,%eax
80103306:	01 d0                	add    %edx,%eax
80103308:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
8010330b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010330e:	c1 e8 04             	shr    $0x4,%eax
80103311:	89 c2                	mov    %eax,%edx
80103313:	89 d0                	mov    %edx,%eax
80103315:	c1 e0 02             	shl    $0x2,%eax
80103318:	01 d0                	add    %edx,%eax
8010331a:	01 c0                	add    %eax,%eax
8010331c:	89 c2                	mov    %eax,%edx
8010331e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103321:	83 e0 0f             	and    $0xf,%eax
80103324:	01 d0                	add    %edx,%eax
80103326:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103329:	8b 45 08             	mov    0x8(%ebp),%eax
8010332c:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010332f:	89 10                	mov    %edx,(%eax)
80103331:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103334:	89 50 04             	mov    %edx,0x4(%eax)
80103337:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010333a:	89 50 08             	mov    %edx,0x8(%eax)
8010333d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103340:	89 50 0c             	mov    %edx,0xc(%eax)
80103343:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103346:	89 50 10             	mov    %edx,0x10(%eax)
80103349:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010334c:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
8010334f:	8b 45 08             	mov    0x8(%ebp),%eax
80103352:	8b 40 14             	mov    0x14(%eax),%eax
80103355:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
8010335b:	8b 45 08             	mov    0x8(%ebp),%eax
8010335e:	89 50 14             	mov    %edx,0x14(%eax)
}
80103361:	90                   	nop
80103362:	c9                   	leave  
80103363:	c3                   	ret    

80103364 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103364:	55                   	push   %ebp
80103365:	89 e5                	mov    %esp,%ebp
80103367:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010336a:	83 ec 08             	sub    $0x8,%esp
8010336d:	68 55 8c 10 80       	push   $0x80108c55
80103372:	68 20 47 11 80       	push   $0x80114720
80103377:	e8 e3 1d 00 00       	call   8010515f <initlock>
8010337c:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
8010337f:	83 ec 08             	sub    $0x8,%esp
80103382:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103385:	50                   	push   %eax
80103386:	ff 75 08             	pushl  0x8(%ebp)
80103389:	e8 a3 e0 ff ff       	call   80101431 <readsb>
8010338e:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80103391:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103394:	a3 54 47 11 80       	mov    %eax,0x80114754
  log.size = sb.nlog;
80103399:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010339c:	a3 58 47 11 80       	mov    %eax,0x80114758
  log.dev = dev;
801033a1:	8b 45 08             	mov    0x8(%ebp),%eax
801033a4:	a3 64 47 11 80       	mov    %eax,0x80114764
  recover_from_log();
801033a9:	e8 b2 01 00 00       	call   80103560 <recover_from_log>
}
801033ae:	90                   	nop
801033af:	c9                   	leave  
801033b0:	c3                   	ret    

801033b1 <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801033b1:	55                   	push   %ebp
801033b2:	89 e5                	mov    %esp,%ebp
801033b4:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801033b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033be:	e9 95 00 00 00       	jmp    80103458 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801033c3:	8b 15 54 47 11 80    	mov    0x80114754,%edx
801033c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033cc:	01 d0                	add    %edx,%eax
801033ce:	83 c0 01             	add    $0x1,%eax
801033d1:	89 c2                	mov    %eax,%edx
801033d3:	a1 64 47 11 80       	mov    0x80114764,%eax
801033d8:	83 ec 08             	sub    $0x8,%esp
801033db:	52                   	push   %edx
801033dc:	50                   	push   %eax
801033dd:	e8 ec cd ff ff       	call   801001ce <bread>
801033e2:	83 c4 10             	add    $0x10,%esp
801033e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801033e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033eb:	83 c0 10             	add    $0x10,%eax
801033ee:	8b 04 85 2c 47 11 80 	mov    -0x7feeb8d4(,%eax,4),%eax
801033f5:	89 c2                	mov    %eax,%edx
801033f7:	a1 64 47 11 80       	mov    0x80114764,%eax
801033fc:	83 ec 08             	sub    $0x8,%esp
801033ff:	52                   	push   %edx
80103400:	50                   	push   %eax
80103401:	e8 c8 cd ff ff       	call   801001ce <bread>
80103406:	83 c4 10             	add    $0x10,%esp
80103409:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010340c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010340f:	8d 50 5c             	lea    0x5c(%eax),%edx
80103412:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103415:	83 c0 5c             	add    $0x5c,%eax
80103418:	83 ec 04             	sub    $0x4,%esp
8010341b:	68 00 02 00 00       	push   $0x200
80103420:	52                   	push   %edx
80103421:	50                   	push   %eax
80103422:	e8 90 20 00 00       	call   801054b7 <memmove>
80103427:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
8010342a:	83 ec 0c             	sub    $0xc,%esp
8010342d:	ff 75 ec             	pushl  -0x14(%ebp)
80103430:	e8 d2 cd ff ff       	call   80100207 <bwrite>
80103435:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf);
80103438:	83 ec 0c             	sub    $0xc,%esp
8010343b:	ff 75 f0             	pushl  -0x10(%ebp)
8010343e:	e8 0d ce ff ff       	call   80100250 <brelse>
80103443:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
80103446:	83 ec 0c             	sub    $0xc,%esp
80103449:	ff 75 ec             	pushl  -0x14(%ebp)
8010344c:	e8 ff cd ff ff       	call   80100250 <brelse>
80103451:	83 c4 10             	add    $0x10,%esp
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103454:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103458:	a1 68 47 11 80       	mov    0x80114768,%eax
8010345d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103460:	0f 8f 5d ff ff ff    	jg     801033c3 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80103466:	90                   	nop
80103467:	c9                   	leave  
80103468:	c3                   	ret    

80103469 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103469:	55                   	push   %ebp
8010346a:	89 e5                	mov    %esp,%ebp
8010346c:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010346f:	a1 54 47 11 80       	mov    0x80114754,%eax
80103474:	89 c2                	mov    %eax,%edx
80103476:	a1 64 47 11 80       	mov    0x80114764,%eax
8010347b:	83 ec 08             	sub    $0x8,%esp
8010347e:	52                   	push   %edx
8010347f:	50                   	push   %eax
80103480:	e8 49 cd ff ff       	call   801001ce <bread>
80103485:	83 c4 10             	add    $0x10,%esp
80103488:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
8010348b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010348e:	83 c0 5c             	add    $0x5c,%eax
80103491:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103494:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103497:	8b 00                	mov    (%eax),%eax
80103499:	a3 68 47 11 80       	mov    %eax,0x80114768
  for (i = 0; i < log.lh.n; i++) {
8010349e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801034a5:	eb 1b                	jmp    801034c2 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
801034a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801034ad:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801034b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801034b4:	83 c2 10             	add    $0x10,%edx
801034b7:	89 04 95 2c 47 11 80 	mov    %eax,-0x7feeb8d4(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801034be:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801034c2:	a1 68 47 11 80       	mov    0x80114768,%eax
801034c7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034ca:	7f db                	jg     801034a7 <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
801034cc:	83 ec 0c             	sub    $0xc,%esp
801034cf:	ff 75 f0             	pushl  -0x10(%ebp)
801034d2:	e8 79 cd ff ff       	call   80100250 <brelse>
801034d7:	83 c4 10             	add    $0x10,%esp
}
801034da:	90                   	nop
801034db:	c9                   	leave  
801034dc:	c3                   	ret    

801034dd <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801034dd:	55                   	push   %ebp
801034de:	89 e5                	mov    %esp,%ebp
801034e0:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801034e3:	a1 54 47 11 80       	mov    0x80114754,%eax
801034e8:	89 c2                	mov    %eax,%edx
801034ea:	a1 64 47 11 80       	mov    0x80114764,%eax
801034ef:	83 ec 08             	sub    $0x8,%esp
801034f2:	52                   	push   %edx
801034f3:	50                   	push   %eax
801034f4:	e8 d5 cc ff ff       	call   801001ce <bread>
801034f9:	83 c4 10             	add    $0x10,%esp
801034fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801034ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103502:	83 c0 5c             	add    $0x5c,%eax
80103505:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103508:	8b 15 68 47 11 80    	mov    0x80114768,%edx
8010350e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103511:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103513:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010351a:	eb 1b                	jmp    80103537 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
8010351c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010351f:	83 c0 10             	add    $0x10,%eax
80103522:	8b 0c 85 2c 47 11 80 	mov    -0x7feeb8d4(,%eax,4),%ecx
80103529:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010352c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010352f:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103533:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103537:	a1 68 47 11 80       	mov    0x80114768,%eax
8010353c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010353f:	7f db                	jg     8010351c <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80103541:	83 ec 0c             	sub    $0xc,%esp
80103544:	ff 75 f0             	pushl  -0x10(%ebp)
80103547:	e8 bb cc ff ff       	call   80100207 <bwrite>
8010354c:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
8010354f:	83 ec 0c             	sub    $0xc,%esp
80103552:	ff 75 f0             	pushl  -0x10(%ebp)
80103555:	e8 f6 cc ff ff       	call   80100250 <brelse>
8010355a:	83 c4 10             	add    $0x10,%esp
}
8010355d:	90                   	nop
8010355e:	c9                   	leave  
8010355f:	c3                   	ret    

80103560 <recover_from_log>:

static void
recover_from_log(void)
{
80103560:	55                   	push   %ebp
80103561:	89 e5                	mov    %esp,%ebp
80103563:	83 ec 08             	sub    $0x8,%esp
  read_head();
80103566:	e8 fe fe ff ff       	call   80103469 <read_head>
  install_trans(); // if committed, copy from log to disk
8010356b:	e8 41 fe ff ff       	call   801033b1 <install_trans>
  log.lh.n = 0;
80103570:	c7 05 68 47 11 80 00 	movl   $0x0,0x80114768
80103577:	00 00 00 
  write_head(); // clear the log
8010357a:	e8 5e ff ff ff       	call   801034dd <write_head>
}
8010357f:	90                   	nop
80103580:	c9                   	leave  
80103581:	c3                   	ret    

80103582 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103582:	55                   	push   %ebp
80103583:	89 e5                	mov    %esp,%ebp
80103585:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103588:	83 ec 0c             	sub    $0xc,%esp
8010358b:	68 20 47 11 80       	push   $0x80114720
80103590:	e8 ec 1b 00 00       	call   80105181 <acquire>
80103595:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103598:	a1 60 47 11 80       	mov    0x80114760,%eax
8010359d:	85 c0                	test   %eax,%eax
8010359f:	74 17                	je     801035b8 <begin_op+0x36>
      sleep(&log, &log.lock);
801035a1:	83 ec 08             	sub    $0x8,%esp
801035a4:	68 20 47 11 80       	push   $0x80114720
801035a9:	68 20 47 11 80       	push   $0x80114720
801035ae:	e8 99 16 00 00       	call   80104c4c <sleep>
801035b3:	83 c4 10             	add    $0x10,%esp
801035b6:	eb e0                	jmp    80103598 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801035b8:	8b 0d 68 47 11 80    	mov    0x80114768,%ecx
801035be:	a1 5c 47 11 80       	mov    0x8011475c,%eax
801035c3:	8d 50 01             	lea    0x1(%eax),%edx
801035c6:	89 d0                	mov    %edx,%eax
801035c8:	c1 e0 02             	shl    $0x2,%eax
801035cb:	01 d0                	add    %edx,%eax
801035cd:	01 c0                	add    %eax,%eax
801035cf:	01 c8                	add    %ecx,%eax
801035d1:	83 f8 1e             	cmp    $0x1e,%eax
801035d4:	7e 17                	jle    801035ed <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801035d6:	83 ec 08             	sub    $0x8,%esp
801035d9:	68 20 47 11 80       	push   $0x80114720
801035de:	68 20 47 11 80       	push   $0x80114720
801035e3:	e8 64 16 00 00       	call   80104c4c <sleep>
801035e8:	83 c4 10             	add    $0x10,%esp
801035eb:	eb ab                	jmp    80103598 <begin_op+0x16>
    } else {
      log.outstanding += 1;
801035ed:	a1 5c 47 11 80       	mov    0x8011475c,%eax
801035f2:	83 c0 01             	add    $0x1,%eax
801035f5:	a3 5c 47 11 80       	mov    %eax,0x8011475c
      release(&log.lock);
801035fa:	83 ec 0c             	sub    $0xc,%esp
801035fd:	68 20 47 11 80       	push   $0x80114720
80103602:	e8 e8 1b 00 00       	call   801051ef <release>
80103607:	83 c4 10             	add    $0x10,%esp
      break;
8010360a:	90                   	nop
    }
  }
}
8010360b:	90                   	nop
8010360c:	c9                   	leave  
8010360d:	c3                   	ret    

8010360e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010360e:	55                   	push   %ebp
8010360f:	89 e5                	mov    %esp,%ebp
80103611:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103614:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
8010361b:	83 ec 0c             	sub    $0xc,%esp
8010361e:	68 20 47 11 80       	push   $0x80114720
80103623:	e8 59 1b 00 00       	call   80105181 <acquire>
80103628:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
8010362b:	a1 5c 47 11 80       	mov    0x8011475c,%eax
80103630:	83 e8 01             	sub    $0x1,%eax
80103633:	a3 5c 47 11 80       	mov    %eax,0x8011475c
  if(log.committing)
80103638:	a1 60 47 11 80       	mov    0x80114760,%eax
8010363d:	85 c0                	test   %eax,%eax
8010363f:	74 0d                	je     8010364e <end_op+0x40>
    panic("log.committing");
80103641:	83 ec 0c             	sub    $0xc,%esp
80103644:	68 59 8c 10 80       	push   $0x80108c59
80103649:	e8 52 cf ff ff       	call   801005a0 <panic>
  if(log.outstanding == 0){
8010364e:	a1 5c 47 11 80       	mov    0x8011475c,%eax
80103653:	85 c0                	test   %eax,%eax
80103655:	75 13                	jne    8010366a <end_op+0x5c>
    do_commit = 1;
80103657:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
8010365e:	c7 05 60 47 11 80 01 	movl   $0x1,0x80114760
80103665:	00 00 00 
80103668:	eb 10                	jmp    8010367a <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
8010366a:	83 ec 0c             	sub    $0xc,%esp
8010366d:	68 20 47 11 80       	push   $0x80114720
80103672:	e8 be 16 00 00       	call   80104d35 <wakeup>
80103677:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
8010367a:	83 ec 0c             	sub    $0xc,%esp
8010367d:	68 20 47 11 80       	push   $0x80114720
80103682:	e8 68 1b 00 00       	call   801051ef <release>
80103687:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
8010368a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010368e:	74 3f                	je     801036cf <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103690:	e8 f5 00 00 00       	call   8010378a <commit>
    acquire(&log.lock);
80103695:	83 ec 0c             	sub    $0xc,%esp
80103698:	68 20 47 11 80       	push   $0x80114720
8010369d:	e8 df 1a 00 00       	call   80105181 <acquire>
801036a2:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
801036a5:	c7 05 60 47 11 80 00 	movl   $0x0,0x80114760
801036ac:	00 00 00 
    wakeup(&log);
801036af:	83 ec 0c             	sub    $0xc,%esp
801036b2:	68 20 47 11 80       	push   $0x80114720
801036b7:	e8 79 16 00 00       	call   80104d35 <wakeup>
801036bc:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801036bf:	83 ec 0c             	sub    $0xc,%esp
801036c2:	68 20 47 11 80       	push   $0x80114720
801036c7:	e8 23 1b 00 00       	call   801051ef <release>
801036cc:	83 c4 10             	add    $0x10,%esp
  }
}
801036cf:	90                   	nop
801036d0:	c9                   	leave  
801036d1:	c3                   	ret    

801036d2 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
801036d2:	55                   	push   %ebp
801036d3:	89 e5                	mov    %esp,%ebp
801036d5:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036df:	e9 95 00 00 00       	jmp    80103779 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801036e4:	8b 15 54 47 11 80    	mov    0x80114754,%edx
801036ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036ed:	01 d0                	add    %edx,%eax
801036ef:	83 c0 01             	add    $0x1,%eax
801036f2:	89 c2                	mov    %eax,%edx
801036f4:	a1 64 47 11 80       	mov    0x80114764,%eax
801036f9:	83 ec 08             	sub    $0x8,%esp
801036fc:	52                   	push   %edx
801036fd:	50                   	push   %eax
801036fe:	e8 cb ca ff ff       	call   801001ce <bread>
80103703:	83 c4 10             	add    $0x10,%esp
80103706:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103709:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010370c:	83 c0 10             	add    $0x10,%eax
8010370f:	8b 04 85 2c 47 11 80 	mov    -0x7feeb8d4(,%eax,4),%eax
80103716:	89 c2                	mov    %eax,%edx
80103718:	a1 64 47 11 80       	mov    0x80114764,%eax
8010371d:	83 ec 08             	sub    $0x8,%esp
80103720:	52                   	push   %edx
80103721:	50                   	push   %eax
80103722:	e8 a7 ca ff ff       	call   801001ce <bread>
80103727:	83 c4 10             	add    $0x10,%esp
8010372a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
8010372d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103730:	8d 50 5c             	lea    0x5c(%eax),%edx
80103733:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103736:	83 c0 5c             	add    $0x5c,%eax
80103739:	83 ec 04             	sub    $0x4,%esp
8010373c:	68 00 02 00 00       	push   $0x200
80103741:	52                   	push   %edx
80103742:	50                   	push   %eax
80103743:	e8 6f 1d 00 00       	call   801054b7 <memmove>
80103748:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
8010374b:	83 ec 0c             	sub    $0xc,%esp
8010374e:	ff 75 f0             	pushl  -0x10(%ebp)
80103751:	e8 b1 ca ff ff       	call   80100207 <bwrite>
80103756:	83 c4 10             	add    $0x10,%esp
    brelse(from);
80103759:	83 ec 0c             	sub    $0xc,%esp
8010375c:	ff 75 ec             	pushl  -0x14(%ebp)
8010375f:	e8 ec ca ff ff       	call   80100250 <brelse>
80103764:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103767:	83 ec 0c             	sub    $0xc,%esp
8010376a:	ff 75 f0             	pushl  -0x10(%ebp)
8010376d:	e8 de ca ff ff       	call   80100250 <brelse>
80103772:	83 c4 10             	add    $0x10,%esp
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103775:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103779:	a1 68 47 11 80       	mov    0x80114768,%eax
8010377e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103781:	0f 8f 5d ff ff ff    	jg     801036e4 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from);
    brelse(to);
  }
}
80103787:	90                   	nop
80103788:	c9                   	leave  
80103789:	c3                   	ret    

8010378a <commit>:

static void
commit()
{
8010378a:	55                   	push   %ebp
8010378b:	89 e5                	mov    %esp,%ebp
8010378d:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103790:	a1 68 47 11 80       	mov    0x80114768,%eax
80103795:	85 c0                	test   %eax,%eax
80103797:	7e 1e                	jle    801037b7 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103799:	e8 34 ff ff ff       	call   801036d2 <write_log>
    write_head();    // Write header to disk -- the real commit
8010379e:	e8 3a fd ff ff       	call   801034dd <write_head>
    install_trans(); // Now install writes to home locations
801037a3:	e8 09 fc ff ff       	call   801033b1 <install_trans>
    log.lh.n = 0;
801037a8:	c7 05 68 47 11 80 00 	movl   $0x0,0x80114768
801037af:	00 00 00 
    write_head();    // Erase the transaction from the log
801037b2:	e8 26 fd ff ff       	call   801034dd <write_head>
  }
}
801037b7:	90                   	nop
801037b8:	c9                   	leave  
801037b9:	c3                   	ret    

801037ba <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801037ba:	55                   	push   %ebp
801037bb:	89 e5                	mov    %esp,%ebp
801037bd:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801037c0:	a1 68 47 11 80       	mov    0x80114768,%eax
801037c5:	83 f8 1d             	cmp    $0x1d,%eax
801037c8:	7f 12                	jg     801037dc <log_write+0x22>
801037ca:	a1 68 47 11 80       	mov    0x80114768,%eax
801037cf:	8b 15 58 47 11 80    	mov    0x80114758,%edx
801037d5:	83 ea 01             	sub    $0x1,%edx
801037d8:	39 d0                	cmp    %edx,%eax
801037da:	7c 0d                	jl     801037e9 <log_write+0x2f>
    panic("too big a transaction");
801037dc:	83 ec 0c             	sub    $0xc,%esp
801037df:	68 68 8c 10 80       	push   $0x80108c68
801037e4:	e8 b7 cd ff ff       	call   801005a0 <panic>
  if (log.outstanding < 1)
801037e9:	a1 5c 47 11 80       	mov    0x8011475c,%eax
801037ee:	85 c0                	test   %eax,%eax
801037f0:	7f 0d                	jg     801037ff <log_write+0x45>
    panic("log_write outside of trans");
801037f2:	83 ec 0c             	sub    $0xc,%esp
801037f5:	68 7e 8c 10 80       	push   $0x80108c7e
801037fa:	e8 a1 cd ff ff       	call   801005a0 <panic>

  acquire(&log.lock);
801037ff:	83 ec 0c             	sub    $0xc,%esp
80103802:	68 20 47 11 80       	push   $0x80114720
80103807:	e8 75 19 00 00       	call   80105181 <acquire>
8010380c:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
8010380f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103816:	eb 1d                	jmp    80103835 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103818:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010381b:	83 c0 10             	add    $0x10,%eax
8010381e:	8b 04 85 2c 47 11 80 	mov    -0x7feeb8d4(,%eax,4),%eax
80103825:	89 c2                	mov    %eax,%edx
80103827:	8b 45 08             	mov    0x8(%ebp),%eax
8010382a:	8b 40 08             	mov    0x8(%eax),%eax
8010382d:	39 c2                	cmp    %eax,%edx
8010382f:	74 10                	je     80103841 <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103831:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103835:	a1 68 47 11 80       	mov    0x80114768,%eax
8010383a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010383d:	7f d9                	jg     80103818 <log_write+0x5e>
8010383f:	eb 01                	jmp    80103842 <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
80103841:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
80103842:	8b 45 08             	mov    0x8(%ebp),%eax
80103845:	8b 40 08             	mov    0x8(%eax),%eax
80103848:	89 c2                	mov    %eax,%edx
8010384a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010384d:	83 c0 10             	add    $0x10,%eax
80103850:	89 14 85 2c 47 11 80 	mov    %edx,-0x7feeb8d4(,%eax,4)
  if (i == log.lh.n)
80103857:	a1 68 47 11 80       	mov    0x80114768,%eax
8010385c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010385f:	75 0d                	jne    8010386e <log_write+0xb4>
    log.lh.n++;
80103861:	a1 68 47 11 80       	mov    0x80114768,%eax
80103866:	83 c0 01             	add    $0x1,%eax
80103869:	a3 68 47 11 80       	mov    %eax,0x80114768
  b->flags |= B_DIRTY; // prevent eviction
8010386e:	8b 45 08             	mov    0x8(%ebp),%eax
80103871:	8b 00                	mov    (%eax),%eax
80103873:	83 c8 04             	or     $0x4,%eax
80103876:	89 c2                	mov    %eax,%edx
80103878:	8b 45 08             	mov    0x8(%ebp),%eax
8010387b:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
8010387d:	83 ec 0c             	sub    $0xc,%esp
80103880:	68 20 47 11 80       	push   $0x80114720
80103885:	e8 65 19 00 00       	call   801051ef <release>
8010388a:	83 c4 10             	add    $0x10,%esp
}
8010388d:	90                   	nop
8010388e:	c9                   	leave  
8010388f:	c3                   	ret    

80103890 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103896:	8b 55 08             	mov    0x8(%ebp),%edx
80103899:	8b 45 0c             	mov    0xc(%ebp),%eax
8010389c:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010389f:	f0 87 02             	lock xchg %eax,(%edx)
801038a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801038a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801038a8:	c9                   	leave  
801038a9:	c3                   	ret    

801038aa <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801038aa:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801038ae:	83 e4 f0             	and    $0xfffffff0,%esp
801038b1:	ff 71 fc             	pushl  -0x4(%ecx)
801038b4:	55                   	push   %ebp
801038b5:	89 e5                	mov    %esp,%ebp
801038b7:	51                   	push   %ecx
801038b8:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801038bb:	83 ec 08             	sub    $0x8,%esp
801038be:	68 00 00 40 80       	push   $0x80400000
801038c3:	68 48 99 11 80       	push   $0x80119948
801038c8:	e8 e1 f2 ff ff       	call   80102bae <kinit1>
801038cd:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
801038d0:	e8 60 49 00 00       	call   80108235 <kvmalloc>
  mpinit();        // detect other processors
801038d5:	e8 ba 03 00 00       	call   80103c94 <mpinit>
  lapicinit();     // interrupt controller
801038da:	e8 3b f6 ff ff       	call   80102f1a <lapicinit>
  seginit();       // segment descriptors
801038df:	e8 3c 44 00 00       	call   80107d20 <seginit>
  picinit();       // disable pic
801038e4:	e8 fc 04 00 00       	call   80103de5 <picinit>
  ioapicinit();    // another interrupt controller
801038e9:	e8 dc f1 ff ff       	call   80102aca <ioapicinit>
  consoleinit();   // console hardware
801038ee:	e8 58 d2 ff ff       	call   80100b4b <consoleinit>
  uartinit();      // serial port
801038f3:	e8 c1 37 00 00       	call   801070b9 <uartinit>
  pinit();         // process table
801038f8:	e8 21 09 00 00       	call   8010421e <pinit>
  tvinit();        // trap vectors
801038fd:	e8 8d 2f 00 00       	call   8010688f <tvinit>
  binit();         // buffer cache
80103902:	e8 2d c7 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103907:	e8 16 d7 ff ff       	call   80101022 <fileinit>
  ideinit();       // disk 
8010390c:	e8 90 ed ff ff       	call   801026a1 <ideinit>
  startothers();   // start other processors
80103911:	e8 80 00 00 00       	call   80103996 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103916:	83 ec 08             	sub    $0x8,%esp
80103919:	68 00 00 00 8e       	push   $0x8e000000
8010391e:	68 00 00 40 80       	push   $0x80400000
80103923:	e8 bf f2 ff ff       	call   80102be7 <kinit2>
80103928:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
8010392b:	e8 0c 0b 00 00       	call   8010443c <userinit>
  mpmain();        // finish this processor's setup
80103930:	e8 1a 00 00 00       	call   8010394f <mpmain>

80103935 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103935:	55                   	push   %ebp
80103936:	89 e5                	mov    %esp,%ebp
80103938:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010393b:	e8 0d 49 00 00       	call   8010824d <switchkvm>
  seginit();
80103940:	e8 db 43 00 00       	call   80107d20 <seginit>
  lapicinit();
80103945:	e8 d0 f5 ff ff       	call   80102f1a <lapicinit>
  mpmain();
8010394a:	e8 00 00 00 00       	call   8010394f <mpmain>

8010394f <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
8010394f:	55                   	push   %ebp
80103950:	89 e5                	mov    %esp,%ebp
80103952:	53                   	push   %ebx
80103953:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103956:	e8 e1 08 00 00       	call   8010423c <cpuid>
8010395b:	89 c3                	mov    %eax,%ebx
8010395d:	e8 da 08 00 00       	call   8010423c <cpuid>
80103962:	83 ec 04             	sub    $0x4,%esp
80103965:	53                   	push   %ebx
80103966:	50                   	push   %eax
80103967:	68 99 8c 10 80       	push   $0x80108c99
8010396c:	e8 8f ca ff ff       	call   80100400 <cprintf>
80103971:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103974:	e8 8c 30 00 00       	call   80106a05 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103979:	e8 df 08 00 00       	call   8010425d <mycpu>
8010397e:	05 a0 00 00 00       	add    $0xa0,%eax
80103983:	83 ec 08             	sub    $0x8,%esp
80103986:	6a 01                	push   $0x1
80103988:	50                   	push   %eax
80103989:	e8 02 ff ff ff       	call   80103890 <xchg>
8010398e:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103991:	e8 c0 10 00 00       	call   80104a56 <scheduler>

80103996 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103996:	55                   	push   %ebp
80103997:	89 e5                	mov    %esp,%ebp
80103999:	83 ec 18             	sub    $0x18,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
8010399c:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801039a3:	b8 8a 00 00 00       	mov    $0x8a,%eax
801039a8:	83 ec 04             	sub    $0x4,%esp
801039ab:	50                   	push   %eax
801039ac:	68 0c c5 10 80       	push   $0x8010c50c
801039b1:	ff 75 f0             	pushl  -0x10(%ebp)
801039b4:	e8 fe 1a 00 00       	call   801054b7 <memmove>
801039b9:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
801039bc:	c7 45 f4 20 48 11 80 	movl   $0x80114820,-0xc(%ebp)
801039c3:	eb 79                	jmp    80103a3e <startothers+0xa8>
    if(c == mycpu())  // We've started already.
801039c5:	e8 93 08 00 00       	call   8010425d <mycpu>
801039ca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801039cd:	74 67                	je     80103a36 <startothers+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801039cf:	e8 0e f3 ff ff       	call   80102ce2 <kalloc>
801039d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
801039d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039da:	83 e8 04             	sub    $0x4,%eax
801039dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
801039e0:	81 c2 00 10 00 00    	add    $0x1000,%edx
801039e6:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
801039e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039eb:	83 e8 08             	sub    $0x8,%eax
801039ee:	c7 00 35 39 10 80    	movl   $0x80103935,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801039f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039f7:	83 e8 0c             	sub    $0xc,%eax
801039fa:	ba 00 b0 10 80       	mov    $0x8010b000,%edx
801039ff:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80103a05:	89 10                	mov    %edx,(%eax)

    lapicstartap(c->apicid, V2P(code));
80103a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a0a:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a13:	0f b6 00             	movzbl (%eax),%eax
80103a16:	0f b6 c0             	movzbl %al,%eax
80103a19:	83 ec 08             	sub    $0x8,%esp
80103a1c:	52                   	push   %edx
80103a1d:	50                   	push   %eax
80103a1e:	e8 58 f6 ff ff       	call   8010307b <lapicstartap>
80103a23:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103a26:	90                   	nop
80103a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a2a:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
80103a30:	85 c0                	test   %eax,%eax
80103a32:	74 f3                	je     80103a27 <startothers+0x91>
80103a34:	eb 01                	jmp    80103a37 <startothers+0xa1>
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == mycpu())  // We've started already.
      continue;
80103a36:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103a37:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
80103a3e:	a1 a0 4d 11 80       	mov    0x80114da0,%eax
80103a43:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103a49:	05 20 48 11 80       	add    $0x80114820,%eax
80103a4e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a51:	0f 87 6e ff ff ff    	ja     801039c5 <startothers+0x2f>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103a57:	90                   	nop
80103a58:	c9                   	leave  
80103a59:	c3                   	ret    

80103a5a <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103a5a:	55                   	push   %ebp
80103a5b:	89 e5                	mov    %esp,%ebp
80103a5d:	83 ec 14             	sub    $0x14,%esp
80103a60:	8b 45 08             	mov    0x8(%ebp),%eax
80103a63:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103a67:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103a6b:	89 c2                	mov    %eax,%edx
80103a6d:	ec                   	in     (%dx),%al
80103a6e:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103a71:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103a75:	c9                   	leave  
80103a76:	c3                   	ret    

80103a77 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a77:	55                   	push   %ebp
80103a78:	89 e5                	mov    %esp,%ebp
80103a7a:	83 ec 08             	sub    $0x8,%esp
80103a7d:	8b 55 08             	mov    0x8(%ebp),%edx
80103a80:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a83:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a87:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a8a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a8e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a92:	ee                   	out    %al,(%dx)
}
80103a93:	90                   	nop
80103a94:	c9                   	leave  
80103a95:	c3                   	ret    

80103a96 <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80103a96:	55                   	push   %ebp
80103a97:	89 e5                	mov    %esp,%ebp
80103a99:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
80103a9c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103aa3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103aaa:	eb 15                	jmp    80103ac1 <sum+0x2b>
    sum += addr[i];
80103aac:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103aaf:	8b 45 08             	mov    0x8(%ebp),%eax
80103ab2:	01 d0                	add    %edx,%eax
80103ab4:	0f b6 00             	movzbl (%eax),%eax
80103ab7:	0f b6 c0             	movzbl %al,%eax
80103aba:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103abd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103ac1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103ac4:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103ac7:	7c e3                	jl     80103aac <sum+0x16>
    sum += addr[i];
  return sum;
80103ac9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103acc:	c9                   	leave  
80103acd:	c3                   	ret    

80103ace <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103ace:	55                   	push   %ebp
80103acf:	89 e5                	mov    %esp,%ebp
80103ad1:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80103ad4:	8b 45 08             	mov    0x8(%ebp),%eax
80103ad7:	05 00 00 00 80       	add    $0x80000000,%eax
80103adc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103adf:	8b 55 0c             	mov    0xc(%ebp),%edx
80103ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ae5:	01 d0                	add    %edx,%eax
80103ae7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103aea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103aed:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103af0:	eb 36                	jmp    80103b28 <mpsearch1+0x5a>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103af2:	83 ec 04             	sub    $0x4,%esp
80103af5:	6a 04                	push   $0x4
80103af7:	68 b0 8c 10 80       	push   $0x80108cb0
80103afc:	ff 75 f4             	pushl  -0xc(%ebp)
80103aff:	e8 5b 19 00 00       	call   8010545f <memcmp>
80103b04:	83 c4 10             	add    $0x10,%esp
80103b07:	85 c0                	test   %eax,%eax
80103b09:	75 19                	jne    80103b24 <mpsearch1+0x56>
80103b0b:	83 ec 08             	sub    $0x8,%esp
80103b0e:	6a 10                	push   $0x10
80103b10:	ff 75 f4             	pushl  -0xc(%ebp)
80103b13:	e8 7e ff ff ff       	call   80103a96 <sum>
80103b18:	83 c4 10             	add    $0x10,%esp
80103b1b:	84 c0                	test   %al,%al
80103b1d:	75 05                	jne    80103b24 <mpsearch1+0x56>
      return (struct mp*)p;
80103b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b22:	eb 11                	jmp    80103b35 <mpsearch1+0x67>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103b24:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b2b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103b2e:	72 c2                	jb     80103af2 <mpsearch1+0x24>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103b30:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103b35:	c9                   	leave  
80103b36:	c3                   	ret    

80103b37 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103b37:	55                   	push   %ebp
80103b38:	89 e5                	mov    %esp,%ebp
80103b3a:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103b3d:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b47:	83 c0 0f             	add    $0xf,%eax
80103b4a:	0f b6 00             	movzbl (%eax),%eax
80103b4d:	0f b6 c0             	movzbl %al,%eax
80103b50:	c1 e0 08             	shl    $0x8,%eax
80103b53:	89 c2                	mov    %eax,%edx
80103b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b58:	83 c0 0e             	add    $0xe,%eax
80103b5b:	0f b6 00             	movzbl (%eax),%eax
80103b5e:	0f b6 c0             	movzbl %al,%eax
80103b61:	09 d0                	or     %edx,%eax
80103b63:	c1 e0 04             	shl    $0x4,%eax
80103b66:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103b69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103b6d:	74 21                	je     80103b90 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103b6f:	83 ec 08             	sub    $0x8,%esp
80103b72:	68 00 04 00 00       	push   $0x400
80103b77:	ff 75 f0             	pushl  -0x10(%ebp)
80103b7a:	e8 4f ff ff ff       	call   80103ace <mpsearch1>
80103b7f:	83 c4 10             	add    $0x10,%esp
80103b82:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b85:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b89:	74 51                	je     80103bdc <mpsearch+0xa5>
      return mp;
80103b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b8e:	eb 61                	jmp    80103bf1 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b93:	83 c0 14             	add    $0x14,%eax
80103b96:	0f b6 00             	movzbl (%eax),%eax
80103b99:	0f b6 c0             	movzbl %al,%eax
80103b9c:	c1 e0 08             	shl    $0x8,%eax
80103b9f:	89 c2                	mov    %eax,%edx
80103ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ba4:	83 c0 13             	add    $0x13,%eax
80103ba7:	0f b6 00             	movzbl (%eax),%eax
80103baa:	0f b6 c0             	movzbl %al,%eax
80103bad:	09 d0                	or     %edx,%eax
80103baf:	c1 e0 0a             	shl    $0xa,%eax
80103bb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103bb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bb8:	2d 00 04 00 00       	sub    $0x400,%eax
80103bbd:	83 ec 08             	sub    $0x8,%esp
80103bc0:	68 00 04 00 00       	push   $0x400
80103bc5:	50                   	push   %eax
80103bc6:	e8 03 ff ff ff       	call   80103ace <mpsearch1>
80103bcb:	83 c4 10             	add    $0x10,%esp
80103bce:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103bd1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103bd5:	74 05                	je     80103bdc <mpsearch+0xa5>
      return mp;
80103bd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103bda:	eb 15                	jmp    80103bf1 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103bdc:	83 ec 08             	sub    $0x8,%esp
80103bdf:	68 00 00 01 00       	push   $0x10000
80103be4:	68 00 00 0f 00       	push   $0xf0000
80103be9:	e8 e0 fe ff ff       	call   80103ace <mpsearch1>
80103bee:	83 c4 10             	add    $0x10,%esp
}
80103bf1:	c9                   	leave  
80103bf2:	c3                   	ret    

80103bf3 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103bf3:	55                   	push   %ebp
80103bf4:	89 e5                	mov    %esp,%ebp
80103bf6:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103bf9:	e8 39 ff ff ff       	call   80103b37 <mpsearch>
80103bfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c05:	74 0a                	je     80103c11 <mpconfig+0x1e>
80103c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c0a:	8b 40 04             	mov    0x4(%eax),%eax
80103c0d:	85 c0                	test   %eax,%eax
80103c0f:	75 07                	jne    80103c18 <mpconfig+0x25>
    return 0;
80103c11:	b8 00 00 00 00       	mov    $0x0,%eax
80103c16:	eb 7a                	jmp    80103c92 <mpconfig+0x9f>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c1b:	8b 40 04             	mov    0x4(%eax),%eax
80103c1e:	05 00 00 00 80       	add    $0x80000000,%eax
80103c23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103c26:	83 ec 04             	sub    $0x4,%esp
80103c29:	6a 04                	push   $0x4
80103c2b:	68 b5 8c 10 80       	push   $0x80108cb5
80103c30:	ff 75 f0             	pushl  -0x10(%ebp)
80103c33:	e8 27 18 00 00       	call   8010545f <memcmp>
80103c38:	83 c4 10             	add    $0x10,%esp
80103c3b:	85 c0                	test   %eax,%eax
80103c3d:	74 07                	je     80103c46 <mpconfig+0x53>
    return 0;
80103c3f:	b8 00 00 00 00       	mov    $0x0,%eax
80103c44:	eb 4c                	jmp    80103c92 <mpconfig+0x9f>
  if(conf->version != 1 && conf->version != 4)
80103c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c49:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c4d:	3c 01                	cmp    $0x1,%al
80103c4f:	74 12                	je     80103c63 <mpconfig+0x70>
80103c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c54:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c58:	3c 04                	cmp    $0x4,%al
80103c5a:	74 07                	je     80103c63 <mpconfig+0x70>
    return 0;
80103c5c:	b8 00 00 00 00       	mov    $0x0,%eax
80103c61:	eb 2f                	jmp    80103c92 <mpconfig+0x9f>
  if(sum((uchar*)conf, conf->length) != 0)
80103c63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c66:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c6a:	0f b7 c0             	movzwl %ax,%eax
80103c6d:	83 ec 08             	sub    $0x8,%esp
80103c70:	50                   	push   %eax
80103c71:	ff 75 f0             	pushl  -0x10(%ebp)
80103c74:	e8 1d fe ff ff       	call   80103a96 <sum>
80103c79:	83 c4 10             	add    $0x10,%esp
80103c7c:	84 c0                	test   %al,%al
80103c7e:	74 07                	je     80103c87 <mpconfig+0x94>
    return 0;
80103c80:	b8 00 00 00 00       	mov    $0x0,%eax
80103c85:	eb 0b                	jmp    80103c92 <mpconfig+0x9f>
  *pmp = mp;
80103c87:	8b 45 08             	mov    0x8(%ebp),%eax
80103c8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c8d:	89 10                	mov    %edx,(%eax)
  return conf;
80103c8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103c92:	c9                   	leave  
80103c93:	c3                   	ret    

80103c94 <mpinit>:

void
mpinit(void)
{
80103c94:	55                   	push   %ebp
80103c95:	89 e5                	mov    %esp,%ebp
80103c97:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103c9a:	83 ec 0c             	sub    $0xc,%esp
80103c9d:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103ca0:	50                   	push   %eax
80103ca1:	e8 4d ff ff ff       	call   80103bf3 <mpconfig>
80103ca6:	83 c4 10             	add    $0x10,%esp
80103ca9:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103cac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103cb0:	75 0d                	jne    80103cbf <mpinit+0x2b>
    panic("Expect to run on an SMP");
80103cb2:	83 ec 0c             	sub    $0xc,%esp
80103cb5:	68 ba 8c 10 80       	push   $0x80108cba
80103cba:	e8 e1 c8 ff ff       	call   801005a0 <panic>
  ismp = 1;
80103cbf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
80103cc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103cc9:	8b 40 24             	mov    0x24(%eax),%eax
80103ccc:	a3 1c 47 11 80       	mov    %eax,0x8011471c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103cd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103cd4:	83 c0 2c             	add    $0x2c,%eax
80103cd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103cda:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103cdd:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103ce1:	0f b7 d0             	movzwl %ax,%edx
80103ce4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ce7:	01 d0                	add    %edx,%eax
80103ce9:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103cec:	eb 7b                	jmp    80103d69 <mpinit+0xd5>
    switch(*p){
80103cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cf1:	0f b6 00             	movzbl (%eax),%eax
80103cf4:	0f b6 c0             	movzbl %al,%eax
80103cf7:	83 f8 04             	cmp    $0x4,%eax
80103cfa:	77 65                	ja     80103d61 <mpinit+0xcd>
80103cfc:	8b 04 85 f4 8c 10 80 	mov    -0x7fef730c(,%eax,4),%eax
80103d03:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(ncpu < NCPU) {
80103d0b:	a1 a0 4d 11 80       	mov    0x80114da0,%eax
80103d10:	83 f8 07             	cmp    $0x7,%eax
80103d13:	7f 28                	jg     80103d3d <mpinit+0xa9>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103d15:	8b 15 a0 4d 11 80    	mov    0x80114da0,%edx
80103d1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d1e:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d22:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
80103d28:	81 c2 20 48 11 80    	add    $0x80114820,%edx
80103d2e:	88 02                	mov    %al,(%edx)
        ncpu++;
80103d30:	a1 a0 4d 11 80       	mov    0x80114da0,%eax
80103d35:	83 c0 01             	add    $0x1,%eax
80103d38:	a3 a0 4d 11 80       	mov    %eax,0x80114da0
      }
      p += sizeof(struct mpproc);
80103d3d:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103d41:	eb 26                	jmp    80103d69 <mpinit+0xd5>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d46:	89 45 e0             	mov    %eax,-0x20(%ebp)
      ioapicid = ioapic->apicno;
80103d49:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103d4c:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d50:	a2 00 48 11 80       	mov    %al,0x80114800
      p += sizeof(struct mpioapic);
80103d55:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d59:	eb 0e                	jmp    80103d69 <mpinit+0xd5>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103d5b:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d5f:	eb 08                	jmp    80103d69 <mpinit+0xd5>
    default:
      ismp = 0;
80103d61:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
80103d68:	90                   	nop

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d6c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80103d6f:	0f 82 79 ff ff ff    	jb     80103cee <mpinit+0x5a>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103d75:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103d79:	75 0d                	jne    80103d88 <mpinit+0xf4>
    panic("Didn't find a suitable machine");
80103d7b:	83 ec 0c             	sub    $0xc,%esp
80103d7e:	68 d4 8c 10 80       	push   $0x80108cd4
80103d83:	e8 18 c8 ff ff       	call   801005a0 <panic>

  if(mp->imcrp){
80103d88:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103d8b:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103d8f:	84 c0                	test   %al,%al
80103d91:	74 30                	je     80103dc3 <mpinit+0x12f>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103d93:	83 ec 08             	sub    $0x8,%esp
80103d96:	6a 70                	push   $0x70
80103d98:	6a 22                	push   $0x22
80103d9a:	e8 d8 fc ff ff       	call   80103a77 <outb>
80103d9f:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103da2:	83 ec 0c             	sub    $0xc,%esp
80103da5:	6a 23                	push   $0x23
80103da7:	e8 ae fc ff ff       	call   80103a5a <inb>
80103dac:	83 c4 10             	add    $0x10,%esp
80103daf:	83 c8 01             	or     $0x1,%eax
80103db2:	0f b6 c0             	movzbl %al,%eax
80103db5:	83 ec 08             	sub    $0x8,%esp
80103db8:	50                   	push   %eax
80103db9:	6a 23                	push   $0x23
80103dbb:	e8 b7 fc ff ff       	call   80103a77 <outb>
80103dc0:	83 c4 10             	add    $0x10,%esp
  }
}
80103dc3:	90                   	nop
80103dc4:	c9                   	leave  
80103dc5:	c3                   	ret    

80103dc6 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103dc6:	55                   	push   %ebp
80103dc7:	89 e5                	mov    %esp,%ebp
80103dc9:	83 ec 08             	sub    $0x8,%esp
80103dcc:	8b 55 08             	mov    0x8(%ebp),%edx
80103dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dd2:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103dd6:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103dd9:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103ddd:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103de1:	ee                   	out    %al,(%dx)
}
80103de2:	90                   	nop
80103de3:	c9                   	leave  
80103de4:	c3                   	ret    

80103de5 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103de5:	55                   	push   %ebp
80103de6:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103de8:	68 ff 00 00 00       	push   $0xff
80103ded:	6a 21                	push   $0x21
80103def:	e8 d2 ff ff ff       	call   80103dc6 <outb>
80103df4:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103df7:	68 ff 00 00 00       	push   $0xff
80103dfc:	68 a1 00 00 00       	push   $0xa1
80103e01:	e8 c0 ff ff ff       	call   80103dc6 <outb>
80103e06:	83 c4 08             	add    $0x8,%esp
}
80103e09:	90                   	nop
80103e0a:	c9                   	leave  
80103e0b:	c3                   	ret    

80103e0c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103e0c:	55                   	push   %ebp
80103e0d:	89 e5                	mov    %esp,%ebp
80103e0f:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103e12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103e19:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103e22:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e25:	8b 10                	mov    (%eax),%edx
80103e27:	8b 45 08             	mov    0x8(%ebp),%eax
80103e2a:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103e2c:	e8 0f d2 ff ff       	call   80101040 <filealloc>
80103e31:	89 c2                	mov    %eax,%edx
80103e33:	8b 45 08             	mov    0x8(%ebp),%eax
80103e36:	89 10                	mov    %edx,(%eax)
80103e38:	8b 45 08             	mov    0x8(%ebp),%eax
80103e3b:	8b 00                	mov    (%eax),%eax
80103e3d:	85 c0                	test   %eax,%eax
80103e3f:	0f 84 cb 00 00 00    	je     80103f10 <pipealloc+0x104>
80103e45:	e8 f6 d1 ff ff       	call   80101040 <filealloc>
80103e4a:	89 c2                	mov    %eax,%edx
80103e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e4f:	89 10                	mov    %edx,(%eax)
80103e51:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e54:	8b 00                	mov    (%eax),%eax
80103e56:	85 c0                	test   %eax,%eax
80103e58:	0f 84 b2 00 00 00    	je     80103f10 <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103e5e:	e8 7f ee ff ff       	call   80102ce2 <kalloc>
80103e63:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103e6a:	0f 84 9f 00 00 00    	je     80103f0f <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
80103e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e73:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103e7a:	00 00 00 
  p->writeopen = 1;
80103e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e80:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103e87:	00 00 00 
  p->nwrite = 0;
80103e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e8d:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103e94:	00 00 00 
  p->nread = 0;
80103e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e9a:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103ea1:	00 00 00 
  initlock(&p->lock, "pipe");
80103ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ea7:	83 ec 08             	sub    $0x8,%esp
80103eaa:	68 08 8d 10 80       	push   $0x80108d08
80103eaf:	50                   	push   %eax
80103eb0:	e8 aa 12 00 00       	call   8010515f <initlock>
80103eb5:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103eb8:	8b 45 08             	mov    0x8(%ebp),%eax
80103ebb:	8b 00                	mov    (%eax),%eax
80103ebd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103ec3:	8b 45 08             	mov    0x8(%ebp),%eax
80103ec6:	8b 00                	mov    (%eax),%eax
80103ec8:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103ecc:	8b 45 08             	mov    0x8(%ebp),%eax
80103ecf:	8b 00                	mov    (%eax),%eax
80103ed1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103ed5:	8b 45 08             	mov    0x8(%ebp),%eax
80103ed8:	8b 00                	mov    (%eax),%eax
80103eda:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103edd:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ee3:	8b 00                	mov    (%eax),%eax
80103ee5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
80103eee:	8b 00                	mov    (%eax),%eax
80103ef0:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ef7:	8b 00                	mov    (%eax),%eax
80103ef9:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103efd:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f00:	8b 00                	mov    (%eax),%eax
80103f02:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f05:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103f08:	b8 00 00 00 00       	mov    $0x0,%eax
80103f0d:	eb 4e                	jmp    80103f5d <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80103f0f:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
80103f10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103f14:	74 0e                	je     80103f24 <pipealloc+0x118>
    kfree((char*)p);
80103f16:	83 ec 0c             	sub    $0xc,%esp
80103f19:	ff 75 f4             	pushl  -0xc(%ebp)
80103f1c:	e8 27 ed ff ff       	call   80102c48 <kfree>
80103f21:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80103f24:	8b 45 08             	mov    0x8(%ebp),%eax
80103f27:	8b 00                	mov    (%eax),%eax
80103f29:	85 c0                	test   %eax,%eax
80103f2b:	74 11                	je     80103f3e <pipealloc+0x132>
    fileclose(*f0);
80103f2d:	8b 45 08             	mov    0x8(%ebp),%eax
80103f30:	8b 00                	mov    (%eax),%eax
80103f32:	83 ec 0c             	sub    $0xc,%esp
80103f35:	50                   	push   %eax
80103f36:	e8 c3 d1 ff ff       	call   801010fe <fileclose>
80103f3b:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f41:	8b 00                	mov    (%eax),%eax
80103f43:	85 c0                	test   %eax,%eax
80103f45:	74 11                	je     80103f58 <pipealloc+0x14c>
    fileclose(*f1);
80103f47:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f4a:	8b 00                	mov    (%eax),%eax
80103f4c:	83 ec 0c             	sub    $0xc,%esp
80103f4f:	50                   	push   %eax
80103f50:	e8 a9 d1 ff ff       	call   801010fe <fileclose>
80103f55:	83 c4 10             	add    $0x10,%esp
  return -1;
80103f58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f5d:	c9                   	leave  
80103f5e:	c3                   	ret    

80103f5f <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103f5f:	55                   	push   %ebp
80103f60:	89 e5                	mov    %esp,%ebp
80103f62:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80103f65:	8b 45 08             	mov    0x8(%ebp),%eax
80103f68:	83 ec 0c             	sub    $0xc,%esp
80103f6b:	50                   	push   %eax
80103f6c:	e8 10 12 00 00       	call   80105181 <acquire>
80103f71:	83 c4 10             	add    $0x10,%esp
  if(writable){
80103f74:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103f78:	74 23                	je     80103f9d <pipeclose+0x3e>
    p->writeopen = 0;
80103f7a:	8b 45 08             	mov    0x8(%ebp),%eax
80103f7d:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103f84:	00 00 00 
    wakeup(&p->nread);
80103f87:	8b 45 08             	mov    0x8(%ebp),%eax
80103f8a:	05 34 02 00 00       	add    $0x234,%eax
80103f8f:	83 ec 0c             	sub    $0xc,%esp
80103f92:	50                   	push   %eax
80103f93:	e8 9d 0d 00 00       	call   80104d35 <wakeup>
80103f98:	83 c4 10             	add    $0x10,%esp
80103f9b:	eb 21                	jmp    80103fbe <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80103f9d:	8b 45 08             	mov    0x8(%ebp),%eax
80103fa0:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103fa7:	00 00 00 
    wakeup(&p->nwrite);
80103faa:	8b 45 08             	mov    0x8(%ebp),%eax
80103fad:	05 38 02 00 00       	add    $0x238,%eax
80103fb2:	83 ec 0c             	sub    $0xc,%esp
80103fb5:	50                   	push   %eax
80103fb6:	e8 7a 0d 00 00       	call   80104d35 <wakeup>
80103fbb:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103fbe:	8b 45 08             	mov    0x8(%ebp),%eax
80103fc1:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103fc7:	85 c0                	test   %eax,%eax
80103fc9:	75 2c                	jne    80103ff7 <pipeclose+0x98>
80103fcb:	8b 45 08             	mov    0x8(%ebp),%eax
80103fce:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103fd4:	85 c0                	test   %eax,%eax
80103fd6:	75 1f                	jne    80103ff7 <pipeclose+0x98>
    release(&p->lock);
80103fd8:	8b 45 08             	mov    0x8(%ebp),%eax
80103fdb:	83 ec 0c             	sub    $0xc,%esp
80103fde:	50                   	push   %eax
80103fdf:	e8 0b 12 00 00       	call   801051ef <release>
80103fe4:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80103fe7:	83 ec 0c             	sub    $0xc,%esp
80103fea:	ff 75 08             	pushl  0x8(%ebp)
80103fed:	e8 56 ec ff ff       	call   80102c48 <kfree>
80103ff2:	83 c4 10             	add    $0x10,%esp
80103ff5:	eb 0f                	jmp    80104006 <pipeclose+0xa7>
  } else
    release(&p->lock);
80103ff7:	8b 45 08             	mov    0x8(%ebp),%eax
80103ffa:	83 ec 0c             	sub    $0xc,%esp
80103ffd:	50                   	push   %eax
80103ffe:	e8 ec 11 00 00       	call   801051ef <release>
80104003:	83 c4 10             	add    $0x10,%esp
}
80104006:	90                   	nop
80104007:	c9                   	leave  
80104008:	c3                   	ret    

80104009 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104009:	55                   	push   %ebp
8010400a:	89 e5                	mov    %esp,%ebp
8010400c:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
8010400f:	8b 45 08             	mov    0x8(%ebp),%eax
80104012:	83 ec 0c             	sub    $0xc,%esp
80104015:	50                   	push   %eax
80104016:	e8 66 11 00 00       	call   80105181 <acquire>
8010401b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
8010401e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104025:	e9 ac 00 00 00       	jmp    801040d6 <pipewrite+0xcd>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
8010402a:	8b 45 08             	mov    0x8(%ebp),%eax
8010402d:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104033:	85 c0                	test   %eax,%eax
80104035:	74 0c                	je     80104043 <pipewrite+0x3a>
80104037:	e8 99 02 00 00       	call   801042d5 <myproc>
8010403c:	8b 40 24             	mov    0x24(%eax),%eax
8010403f:	85 c0                	test   %eax,%eax
80104041:	74 19                	je     8010405c <pipewrite+0x53>
        release(&p->lock);
80104043:	8b 45 08             	mov    0x8(%ebp),%eax
80104046:	83 ec 0c             	sub    $0xc,%esp
80104049:	50                   	push   %eax
8010404a:	e8 a0 11 00 00       	call   801051ef <release>
8010404f:	83 c4 10             	add    $0x10,%esp
        return -1;
80104052:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104057:	e9 a8 00 00 00       	jmp    80104104 <pipewrite+0xfb>
      }
      wakeup(&p->nread);
8010405c:	8b 45 08             	mov    0x8(%ebp),%eax
8010405f:	05 34 02 00 00       	add    $0x234,%eax
80104064:	83 ec 0c             	sub    $0xc,%esp
80104067:	50                   	push   %eax
80104068:	e8 c8 0c 00 00       	call   80104d35 <wakeup>
8010406d:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104070:	8b 45 08             	mov    0x8(%ebp),%eax
80104073:	8b 55 08             	mov    0x8(%ebp),%edx
80104076:	81 c2 38 02 00 00    	add    $0x238,%edx
8010407c:	83 ec 08             	sub    $0x8,%esp
8010407f:	50                   	push   %eax
80104080:	52                   	push   %edx
80104081:	e8 c6 0b 00 00       	call   80104c4c <sleep>
80104086:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104089:	8b 45 08             	mov    0x8(%ebp),%eax
8010408c:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104092:	8b 45 08             	mov    0x8(%ebp),%eax
80104095:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010409b:	05 00 02 00 00       	add    $0x200,%eax
801040a0:	39 c2                	cmp    %eax,%edx
801040a2:	74 86                	je     8010402a <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801040a4:	8b 45 08             	mov    0x8(%ebp),%eax
801040a7:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801040ad:	8d 48 01             	lea    0x1(%eax),%ecx
801040b0:	8b 55 08             	mov    0x8(%ebp),%edx
801040b3:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801040b9:	25 ff 01 00 00       	and    $0x1ff,%eax
801040be:	89 c1                	mov    %eax,%ecx
801040c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801040c6:	01 d0                	add    %edx,%eax
801040c8:	0f b6 10             	movzbl (%eax),%edx
801040cb:	8b 45 08             	mov    0x8(%ebp),%eax
801040ce:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801040d2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801040d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040d9:	3b 45 10             	cmp    0x10(%ebp),%eax
801040dc:	7c ab                	jl     80104089 <pipewrite+0x80>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801040de:	8b 45 08             	mov    0x8(%ebp),%eax
801040e1:	05 34 02 00 00       	add    $0x234,%eax
801040e6:	83 ec 0c             	sub    $0xc,%esp
801040e9:	50                   	push   %eax
801040ea:	e8 46 0c 00 00       	call   80104d35 <wakeup>
801040ef:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801040f2:	8b 45 08             	mov    0x8(%ebp),%eax
801040f5:	83 ec 0c             	sub    $0xc,%esp
801040f8:	50                   	push   %eax
801040f9:	e8 f1 10 00 00       	call   801051ef <release>
801040fe:	83 c4 10             	add    $0x10,%esp
  return n;
80104101:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104104:	c9                   	leave  
80104105:	c3                   	ret    

80104106 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104106:	55                   	push   %ebp
80104107:	89 e5                	mov    %esp,%ebp
80104109:	53                   	push   %ebx
8010410a:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
8010410d:	8b 45 08             	mov    0x8(%ebp),%eax
80104110:	83 ec 0c             	sub    $0xc,%esp
80104113:	50                   	push   %eax
80104114:	e8 68 10 00 00       	call   80105181 <acquire>
80104119:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010411c:	eb 3e                	jmp    8010415c <piperead+0x56>
    if(myproc()->killed){
8010411e:	e8 b2 01 00 00       	call   801042d5 <myproc>
80104123:	8b 40 24             	mov    0x24(%eax),%eax
80104126:	85 c0                	test   %eax,%eax
80104128:	74 19                	je     80104143 <piperead+0x3d>
      release(&p->lock);
8010412a:	8b 45 08             	mov    0x8(%ebp),%eax
8010412d:	83 ec 0c             	sub    $0xc,%esp
80104130:	50                   	push   %eax
80104131:	e8 b9 10 00 00       	call   801051ef <release>
80104136:	83 c4 10             	add    $0x10,%esp
      return -1;
80104139:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010413e:	e9 bf 00 00 00       	jmp    80104202 <piperead+0xfc>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104143:	8b 45 08             	mov    0x8(%ebp),%eax
80104146:	8b 55 08             	mov    0x8(%ebp),%edx
80104149:	81 c2 34 02 00 00    	add    $0x234,%edx
8010414f:	83 ec 08             	sub    $0x8,%esp
80104152:	50                   	push   %eax
80104153:	52                   	push   %edx
80104154:	e8 f3 0a 00 00       	call   80104c4c <sleep>
80104159:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010415c:	8b 45 08             	mov    0x8(%ebp),%eax
8010415f:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104165:	8b 45 08             	mov    0x8(%ebp),%eax
80104168:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010416e:	39 c2                	cmp    %eax,%edx
80104170:	75 0d                	jne    8010417f <piperead+0x79>
80104172:	8b 45 08             	mov    0x8(%ebp),%eax
80104175:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010417b:	85 c0                	test   %eax,%eax
8010417d:	75 9f                	jne    8010411e <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010417f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104186:	eb 49                	jmp    801041d1 <piperead+0xcb>
    if(p->nread == p->nwrite)
80104188:	8b 45 08             	mov    0x8(%ebp),%eax
8010418b:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104191:	8b 45 08             	mov    0x8(%ebp),%eax
80104194:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010419a:	39 c2                	cmp    %eax,%edx
8010419c:	74 3d                	je     801041db <piperead+0xd5>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010419e:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041a1:	8b 45 0c             	mov    0xc(%ebp),%eax
801041a4:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801041a7:	8b 45 08             	mov    0x8(%ebp),%eax
801041aa:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801041b0:	8d 48 01             	lea    0x1(%eax),%ecx
801041b3:	8b 55 08             	mov    0x8(%ebp),%edx
801041b6:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
801041bc:	25 ff 01 00 00       	and    $0x1ff,%eax
801041c1:	89 c2                	mov    %eax,%edx
801041c3:	8b 45 08             	mov    0x8(%ebp),%eax
801041c6:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
801041cb:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801041cd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801041d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041d4:	3b 45 10             	cmp    0x10(%ebp),%eax
801041d7:	7c af                	jl     80104188 <piperead+0x82>
801041d9:	eb 01                	jmp    801041dc <piperead+0xd6>
    if(p->nread == p->nwrite)
      break;
801041db:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801041dc:	8b 45 08             	mov    0x8(%ebp),%eax
801041df:	05 38 02 00 00       	add    $0x238,%eax
801041e4:	83 ec 0c             	sub    $0xc,%esp
801041e7:	50                   	push   %eax
801041e8:	e8 48 0b 00 00       	call   80104d35 <wakeup>
801041ed:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801041f0:	8b 45 08             	mov    0x8(%ebp),%eax
801041f3:	83 ec 0c             	sub    $0xc,%esp
801041f6:	50                   	push   %eax
801041f7:	e8 f3 0f 00 00       	call   801051ef <release>
801041fc:	83 c4 10             	add    $0x10,%esp
  return i;
801041ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104202:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104205:	c9                   	leave  
80104206:	c3                   	ret    

80104207 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104207:	55                   	push   %ebp
80104208:	89 e5                	mov    %esp,%ebp
8010420a:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010420d:	9c                   	pushf  
8010420e:	58                   	pop    %eax
8010420f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104212:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104215:	c9                   	leave  
80104216:	c3                   	ret    

80104217 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80104217:	55                   	push   %ebp
80104218:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010421a:	fb                   	sti    
}
8010421b:	90                   	nop
8010421c:	5d                   	pop    %ebp
8010421d:	c3                   	ret    

8010421e <pinit>:
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void) {
8010421e:	55                   	push   %ebp
8010421f:	89 e5                	mov    %esp,%ebp
80104221:	83 ec 08             	sub    $0x8,%esp
    initlock(&ptable.lock, "ptable");
80104224:	83 ec 08             	sub    $0x8,%esp
80104227:	68 10 8d 10 80       	push   $0x80108d10
8010422c:	68 c0 4d 11 80       	push   $0x80114dc0
80104231:	e8 29 0f 00 00       	call   8010515f <initlock>
80104236:	83 c4 10             	add    $0x10,%esp
}
80104239:	90                   	nop
8010423a:	c9                   	leave  
8010423b:	c3                   	ret    

8010423c <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
8010423c:	55                   	push   %ebp
8010423d:	89 e5                	mov    %esp,%ebp
8010423f:	83 ec 08             	sub    $0x8,%esp
    return mycpu() - cpus;
80104242:	e8 16 00 00 00       	call   8010425d <mycpu>
80104247:	89 c2                	mov    %eax,%edx
80104249:	b8 20 48 11 80       	mov    $0x80114820,%eax
8010424e:	29 c2                	sub    %eax,%edx
80104250:	89 d0                	mov    %edx,%eax
80104252:	c1 f8 04             	sar    $0x4,%eax
80104255:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010425b:	c9                   	leave  
8010425c:	c3                   	ret    

8010425d <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu *
mycpu(void) {
8010425d:	55                   	push   %ebp
8010425e:	89 e5                	mov    %esp,%ebp
80104260:	83 ec 18             	sub    $0x18,%esp
    int apicid, i;

    if (readeflags() & FL_IF)
80104263:	e8 9f ff ff ff       	call   80104207 <readeflags>
80104268:	25 00 02 00 00       	and    $0x200,%eax
8010426d:	85 c0                	test   %eax,%eax
8010426f:	74 0d                	je     8010427e <mycpu+0x21>
        panic("mycpu called with interrupts enabled\n");
80104271:	83 ec 0c             	sub    $0xc,%esp
80104274:	68 18 8d 10 80       	push   $0x80108d18
80104279:	e8 22 c3 ff ff       	call   801005a0 <panic>

    apicid = lapicid();
8010427e:	e8 b5 ed ff ff       	call   80103038 <lapicid>
80104283:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
80104286:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010428d:	eb 2d                	jmp    801042bc <mycpu+0x5f>
        if (cpus[i].apicid == apicid)
8010428f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104292:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80104298:	05 20 48 11 80       	add    $0x80114820,%eax
8010429d:	0f b6 00             	movzbl (%eax),%eax
801042a0:	0f b6 c0             	movzbl %al,%eax
801042a3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801042a6:	75 10                	jne    801042b8 <mycpu+0x5b>
            return &cpus[i];
801042a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042ab:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801042b1:	05 20 48 11 80       	add    $0x80114820,%eax
801042b6:	eb 1b                	jmp    801042d3 <mycpu+0x76>
        panic("mycpu called with interrupts enabled\n");

    apicid = lapicid();
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
801042b8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801042bc:	a1 a0 4d 11 80       	mov    0x80114da0,%eax
801042c1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801042c4:	7c c9                	jl     8010428f <mycpu+0x32>
        if (cpus[i].apicid == apicid)
            return &cpus[i];
    }
    panic("unknown apicid\n");
801042c6:	83 ec 0c             	sub    $0xc,%esp
801042c9:	68 3e 8d 10 80       	push   $0x80108d3e
801042ce:	e8 cd c2 ff ff       	call   801005a0 <panic>
}
801042d3:	c9                   	leave  
801042d4:	c3                   	ret    

801042d5 <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc *
myproc(void) {
801042d5:	55                   	push   %ebp
801042d6:	89 e5                	mov    %esp,%ebp
801042d8:	83 ec 18             	sub    $0x18,%esp
    struct cpu *c;
    struct proc *p;
    pushcli();
801042db:	e8 0c 10 00 00       	call   801052ec <pushcli>
    c = mycpu();
801042e0:	e8 78 ff ff ff       	call   8010425d <mycpu>
801042e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = c->proc;
801042e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042eb:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801042f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    popcli();
801042f4:	e8 41 10 00 00       	call   8010533a <popcli>
    return p;
801042f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801042fc:	c9                   	leave  
801042fd:	c3                   	ret    

801042fe <allocpid>:


int
allocpid(void) {
801042fe:	55                   	push   %ebp
801042ff:	89 e5                	mov    %esp,%ebp
80104301:	83 ec 18             	sub    $0x18,%esp
    int pid;
    acquire(&ptable.lock);
80104304:	83 ec 0c             	sub    $0xc,%esp
80104307:	68 c0 4d 11 80       	push   $0x80114dc0
8010430c:	e8 70 0e 00 00       	call   80105181 <acquire>
80104311:	83 c4 10             	add    $0x10,%esp
    pid = nextpid++;
80104314:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80104319:	8d 50 01             	lea    0x1(%eax),%edx
8010431c:	89 15 00 c0 10 80    	mov    %edx,0x8010c000
80104322:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&ptable.lock);
80104325:	83 ec 0c             	sub    $0xc,%esp
80104328:	68 c0 4d 11 80       	push   $0x80114dc0
8010432d:	e8 bd 0e 00 00       	call   801051ef <release>
80104332:	83 c4 10             	add    $0x10,%esp
    return pid;
80104335:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104338:	c9                   	leave  
80104339:	c3                   	ret    

8010433a <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *
allocproc(void) {
8010433a:	55                   	push   %ebp
8010433b:	89 e5                	mov    %esp,%ebp
8010433d:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);
80104340:	83 ec 0c             	sub    $0xc,%esp
80104343:	68 c0 4d 11 80       	push   $0x80114dc0
80104348:	e8 34 0e 00 00       	call   80105181 <acquire>
8010434d:	83 c4 10             	add    $0x10,%esp

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104350:	c7 45 f4 f4 4d 11 80 	movl   $0x80114df4,-0xc(%ebp)
80104357:	eb 11                	jmp    8010436a <allocproc+0x30>
        if (p->state == UNUSED)
80104359:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010435c:	8b 40 0c             	mov    0xc(%eax),%eax
8010435f:	85 c0                	test   %eax,%eax
80104361:	74 2a                	je     8010438d <allocproc+0x53>
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104363:	81 45 f4 0c 01 00 00 	addl   $0x10c,-0xc(%ebp)
8010436a:	81 7d f4 f4 90 11 80 	cmpl   $0x801190f4,-0xc(%ebp)
80104371:	72 e6                	jb     80104359 <allocproc+0x1f>
        if (p->state == UNUSED)
            goto found;

    release(&ptable.lock);
80104373:	83 ec 0c             	sub    $0xc,%esp
80104376:	68 c0 4d 11 80       	push   $0x80114dc0
8010437b:	e8 6f 0e 00 00       	call   801051ef <release>
80104380:	83 c4 10             	add    $0x10,%esp
    return 0;
80104383:	b8 00 00 00 00       	mov    $0x0,%eax
80104388:	e9 ad 00 00 00       	jmp    8010443a <allocproc+0x100>

    acquire(&ptable.lock);

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if (p->state == UNUSED)
            goto found;
8010438d:	90                   	nop

    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
8010438e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104391:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
    release(&ptable.lock);
80104398:	83 ec 0c             	sub    $0xc,%esp
8010439b:	68 c0 4d 11 80       	push   $0x80114dc0
801043a0:	e8 4a 0e 00 00       	call   801051ef <release>
801043a5:	83 c4 10             	add    $0x10,%esp
    p->pid = allocpid();
801043a8:	e8 51 ff ff ff       	call   801042fe <allocpid>
801043ad:	89 c2                	mov    %eax,%edx
801043af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043b2:	89 50 10             	mov    %edx,0x10(%eax)


    // Allocate kernel stack.
    if ((p->kstack = kalloc()) == 0) {
801043b5:	e8 28 e9 ff ff       	call   80102ce2 <kalloc>
801043ba:	89 c2                	mov    %eax,%edx
801043bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043bf:	89 50 08             	mov    %edx,0x8(%eax)
801043c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043c5:	8b 40 08             	mov    0x8(%eax),%eax
801043c8:	85 c0                	test   %eax,%eax
801043ca:	75 11                	jne    801043dd <allocproc+0xa3>
        p->state = UNUSED;
801043cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043cf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        return 0;
801043d6:	b8 00 00 00 00       	mov    $0x0,%eax
801043db:	eb 5d                	jmp    8010443a <allocproc+0x100>
    }
    sp = p->kstack + KSTACKSIZE;
801043dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043e0:	8b 40 08             	mov    0x8(%eax),%eax
801043e3:	05 00 10 00 00       	add    $0x1000,%eax
801043e8:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
801043eb:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
    p->tf = (struct trapframe *) sp;
801043ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043f5:	89 50 18             	mov    %edx,0x18(%eax)

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
801043f8:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
    *(uint *) sp = (uint) trapret;
801043fc:	ba 39 68 10 80       	mov    $0x80106839,%edx
80104401:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104404:	89 10                	mov    %edx,(%eax)

    sp -= sizeof *p->context;
80104406:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
    p->context = (struct context *) sp;
8010440a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010440d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104410:	89 50 1c             	mov    %edx,0x1c(%eax)
    memset(p->context, 0, sizeof *p->context);
80104413:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104416:	8b 40 1c             	mov    0x1c(%eax),%eax
80104419:	83 ec 04             	sub    $0x4,%esp
8010441c:	6a 14                	push   $0x14
8010441e:	6a 00                	push   $0x0
80104420:	50                   	push   %eax
80104421:	e8 d2 0f 00 00       	call   801053f8 <memset>
80104426:	83 c4 10             	add    $0x10,%esp
    p->context->eip = (uint) forkret;
80104429:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010442c:	8b 40 1c             	mov    0x1c(%eax),%eax
8010442f:	ba 06 4c 10 80       	mov    $0x80104c06,%edx
80104434:	89 50 10             	mov    %edx,0x10(%eax)

    return p;
80104437:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010443a:	c9                   	leave  
8010443b:	c3                   	ret    

8010443c <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void) {
8010443c:	55                   	push   %ebp
8010443d:	89 e5                	mov    %esp,%ebp
8010443f:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    p = allocproc();
80104442:	e8 f3 fe ff ff       	call   8010433a <allocproc>
80104447:	89 45 f4             	mov    %eax,-0xc(%ebp)

    initproc = p;
8010444a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010444d:	a3 40 c6 10 80       	mov    %eax,0x8010c640
    if ((p->pgdir = setupkvm()) == 0)
80104452:	e8 45 3d 00 00       	call   8010819c <setupkvm>
80104457:	89 c2                	mov    %eax,%edx
80104459:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010445c:	89 50 04             	mov    %edx,0x4(%eax)
8010445f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104462:	8b 40 04             	mov    0x4(%eax),%eax
80104465:	85 c0                	test   %eax,%eax
80104467:	75 0d                	jne    80104476 <userinit+0x3a>
        panic("userinit: out of memory?");
80104469:	83 ec 0c             	sub    $0xc,%esp
8010446c:	68 4e 8d 10 80       	push   $0x80108d4e
80104471:	e8 2a c1 ff ff       	call   801005a0 <panic>
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
80104476:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010447b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010447e:	8b 40 04             	mov    0x4(%eax),%eax
80104481:	83 ec 04             	sub    $0x4,%esp
80104484:	52                   	push   %edx
80104485:	68 e0 c4 10 80       	push   $0x8010c4e0
8010448a:	50                   	push   %eax
8010448b:	e8 74 3f 00 00       	call   80108404 <inituvm>
80104490:	83 c4 10             	add    $0x10,%esp
    p->sz = PGSIZE;
80104493:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104496:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
    memset(p->tf, 0, sizeof(*p->tf));
8010449c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010449f:	8b 40 18             	mov    0x18(%eax),%eax
801044a2:	83 ec 04             	sub    $0x4,%esp
801044a5:	6a 4c                	push   $0x4c
801044a7:	6a 00                	push   $0x0
801044a9:	50                   	push   %eax
801044aa:	e8 49 0f 00 00       	call   801053f8 <memset>
801044af:	83 c4 10             	add    $0x10,%esp
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801044b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044b5:	8b 40 18             	mov    0x18(%eax),%eax
801044b8:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801044be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044c1:	8b 40 18             	mov    0x18(%eax),%eax
801044c4:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
    p->tf->es = p->tf->ds;
801044ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044cd:	8b 40 18             	mov    0x18(%eax),%eax
801044d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044d3:	8b 52 18             	mov    0x18(%edx),%edx
801044d6:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801044da:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
801044de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044e1:	8b 40 18             	mov    0x18(%eax),%eax
801044e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044e7:	8b 52 18             	mov    0x18(%edx),%edx
801044ea:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801044ee:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
801044f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044f5:	8b 40 18             	mov    0x18(%eax),%eax
801044f8:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
801044ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104502:	8b 40 18             	mov    0x18(%eax),%eax
80104505:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
8010450c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010450f:	8b 40 18             	mov    0x18(%eax),%eax
80104512:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
    p->mask=0xffff;     //at first, handle all signals.
80104519:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010451c:	c7 80 80 00 00 00 ff 	movl   $0xffff,0x80(%eax)
80104523:	ff 00 00 
    p->pending=0;
80104526:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104529:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
    safestrcpy(p->name, "initcode", sizeof(p->name));
80104530:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104533:	83 c0 6c             	add    $0x6c,%eax
80104536:	83 ec 04             	sub    $0x4,%esp
80104539:	6a 10                	push   $0x10
8010453b:	68 67 8d 10 80       	push   $0x80108d67
80104540:	50                   	push   %eax
80104541:	e8 b5 10 00 00       	call   801055fb <safestrcpy>
80104546:	83 c4 10             	add    $0x10,%esp
    p->cwd = namei("/");
80104549:	83 ec 0c             	sub    $0xc,%esp
8010454c:	68 70 8d 10 80       	push   $0x80108d70
80104551:	e8 47 e0 ff ff       	call   8010259d <namei>
80104556:	83 c4 10             	add    $0x10,%esp
80104559:	89 c2                	mov    %eax,%edx
8010455b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010455e:	89 50 68             	mov    %edx,0x68(%eax)

    // this assignment to p->state lets other cores
    // run this process. the acquire forces the above
    // writes to be visible, and the lock is also needed
    // because the assignment might not be atomic.
    acquire(&ptable.lock);
80104561:	83 ec 0c             	sub    $0xc,%esp
80104564:	68 c0 4d 11 80       	push   $0x80114dc0
80104569:	e8 13 0c 00 00       	call   80105181 <acquire>
8010456e:	83 c4 10             	add    $0x10,%esp
    //set Default handler
    memset(p->handlers, SIG_DFL, 32 * sizeof(void *));
80104571:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104574:	05 88 00 00 00       	add    $0x88,%eax
80104579:	83 ec 04             	sub    $0x4,%esp
8010457c:	68 80 00 00 00       	push   $0x80
80104581:	6a 00                	push   $0x0
80104583:	50                   	push   %eax
80104584:	e8 6f 0e 00 00       	call   801053f8 <memset>
80104589:	83 c4 10             	add    $0x10,%esp

    p->state = RUNNABLE;
8010458c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010458f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

    release(&ptable.lock);
80104596:	83 ec 0c             	sub    $0xc,%esp
80104599:	68 c0 4d 11 80       	push   $0x80114dc0
8010459e:	e8 4c 0c 00 00       	call   801051ef <release>
801045a3:	83 c4 10             	add    $0x10,%esp
}
801045a6:	90                   	nop
801045a7:	c9                   	leave  
801045a8:	c3                   	ret    

801045a9 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n) {
801045a9:	55                   	push   %ebp
801045aa:	89 e5                	mov    %esp,%ebp
801045ac:	83 ec 18             	sub    $0x18,%esp
    uint sz;
    struct proc *curproc = myproc();
801045af:	e8 21 fd ff ff       	call   801042d5 <myproc>
801045b4:	89 45 f0             	mov    %eax,-0x10(%ebp)

    sz = curproc->sz;
801045b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801045ba:	8b 00                	mov    (%eax),%eax
801045bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (n > 0) {
801045bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801045c3:	7e 2e                	jle    801045f3 <growproc+0x4a>
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801045c5:	8b 55 08             	mov    0x8(%ebp),%edx
801045c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045cb:	01 c2                	add    %eax,%edx
801045cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801045d0:	8b 40 04             	mov    0x4(%eax),%eax
801045d3:	83 ec 04             	sub    $0x4,%esp
801045d6:	52                   	push   %edx
801045d7:	ff 75 f4             	pushl  -0xc(%ebp)
801045da:	50                   	push   %eax
801045db:	e8 61 3f 00 00       	call   80108541 <allocuvm>
801045e0:	83 c4 10             	add    $0x10,%esp
801045e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801045e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801045ea:	75 3b                	jne    80104627 <growproc+0x7e>
            return -1;
801045ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045f1:	eb 4f                	jmp    80104642 <growproc+0x99>
    } else if (n < 0) {
801045f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801045f7:	79 2e                	jns    80104627 <growproc+0x7e>
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801045f9:	8b 55 08             	mov    0x8(%ebp),%edx
801045fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ff:	01 c2                	add    %eax,%edx
80104601:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104604:	8b 40 04             	mov    0x4(%eax),%eax
80104607:	83 ec 04             	sub    $0x4,%esp
8010460a:	52                   	push   %edx
8010460b:	ff 75 f4             	pushl  -0xc(%ebp)
8010460e:	50                   	push   %eax
8010460f:	e8 32 40 00 00       	call   80108646 <deallocuvm>
80104614:	83 c4 10             	add    $0x10,%esp
80104617:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010461a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010461e:	75 07                	jne    80104627 <growproc+0x7e>
            return -1;
80104620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104625:	eb 1b                	jmp    80104642 <growproc+0x99>
    }
    curproc->sz = sz;
80104627:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010462a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010462d:	89 10                	mov    %edx,(%eax)
    switchuvm(curproc);
8010462f:	83 ec 0c             	sub    $0xc,%esp
80104632:	ff 75 f0             	pushl  -0x10(%ebp)
80104635:	e8 2c 3c 00 00       	call   80108266 <switchuvm>
8010463a:	83 c4 10             	add    $0x10,%esp
    return 0;
8010463d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104642:	c9                   	leave  
80104643:	c3                   	ret    

80104644 <fork>:

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void) {
80104644:	55                   	push   %ebp
80104645:	89 e5                	mov    %esp,%ebp
80104647:	57                   	push   %edi
80104648:	56                   	push   %esi
80104649:	53                   	push   %ebx
8010464a:	83 ec 1c             	sub    $0x1c,%esp
    int i, pid;
    struct proc *np;
    struct proc *curproc = myproc();
8010464d:	e8 83 fc ff ff       	call   801042d5 <myproc>
80104652:	89 45 e0             	mov    %eax,-0x20(%ebp)

    // Allocate process.
    if ((np = allocproc()) == 0) {
80104655:	e8 e0 fc ff ff       	call   8010433a <allocproc>
8010465a:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010465d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80104661:	75 0a                	jne    8010466d <fork+0x29>
        return -1;
80104663:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104668:	e9 9b 01 00 00       	jmp    80104808 <fork+0x1c4>
    }

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
8010466d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104670:	8b 10                	mov    (%eax),%edx
80104672:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104675:	8b 40 04             	mov    0x4(%eax),%eax
80104678:	83 ec 08             	sub    $0x8,%esp
8010467b:	52                   	push   %edx
8010467c:	50                   	push   %eax
8010467d:	e8 62 41 00 00       	call   801087e4 <copyuvm>
80104682:	83 c4 10             	add    $0x10,%esp
80104685:	89 c2                	mov    %eax,%edx
80104687:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010468a:	89 50 04             	mov    %edx,0x4(%eax)
8010468d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104690:	8b 40 04             	mov    0x4(%eax),%eax
80104693:	85 c0                	test   %eax,%eax
80104695:	75 30                	jne    801046c7 <fork+0x83>
        kfree(np->kstack);
80104697:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010469a:	8b 40 08             	mov    0x8(%eax),%eax
8010469d:	83 ec 0c             	sub    $0xc,%esp
801046a0:	50                   	push   %eax
801046a1:	e8 a2 e5 ff ff       	call   80102c48 <kfree>
801046a6:	83 c4 10             	add    $0x10,%esp
        np->kstack = 0;
801046a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046ac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        np->state = UNUSED;
801046b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046b6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        return -1;
801046bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046c2:	e9 41 01 00 00       	jmp    80104808 <fork+0x1c4>
    }
    np->sz = curproc->sz;
801046c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046ca:	8b 10                	mov    (%eax),%edx
801046cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046cf:	89 10                	mov    %edx,(%eax)
    np->parent = curproc;
801046d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
801046d7:	89 50 14             	mov    %edx,0x14(%eax)
    *np->tf = *curproc->tf;
801046da:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046dd:	8b 50 18             	mov    0x18(%eax),%edx
801046e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046e3:	8b 40 18             	mov    0x18(%eax),%eax
801046e6:	89 c3                	mov    %eax,%ebx
801046e8:	b8 13 00 00 00       	mov    $0x13,%eax
801046ed:	89 d7                	mov    %edx,%edi
801046ef:	89 de                	mov    %ebx,%esi
801046f1:	89 c1                	mov    %eax,%ecx
801046f3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
801046f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046f8:	8b 40 18             	mov    0x18(%eax),%eax
801046fb:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

    for (i = 0; i < NOFILE; i++)
80104702:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104709:	eb 3d                	jmp    80104748 <fork+0x104>
        if (curproc->ofile[i])
8010470b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010470e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104711:	83 c2 08             	add    $0x8,%edx
80104714:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104718:	85 c0                	test   %eax,%eax
8010471a:	74 28                	je     80104744 <fork+0x100>
            np->ofile[i] = filedup(curproc->ofile[i]);
8010471c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010471f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104722:	83 c2 08             	add    $0x8,%edx
80104725:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104729:	83 ec 0c             	sub    $0xc,%esp
8010472c:	50                   	push   %eax
8010472d:	e8 7b c9 ff ff       	call   801010ad <filedup>
80104732:	83 c4 10             	add    $0x10,%esp
80104735:	89 c1                	mov    %eax,%ecx
80104737:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010473a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010473d:	83 c2 08             	add    $0x8,%edx
80104740:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
    *np->tf = *curproc->tf;

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
80104744:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104748:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
8010474c:	7e bd                	jle    8010470b <fork+0xc7>
        if (curproc->ofile[i])
            np->ofile[i] = filedup(curproc->ofile[i]);
    np->cwd = idup(curproc->cwd);
8010474e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104751:	8b 40 68             	mov    0x68(%eax),%eax
80104754:	83 ec 0c             	sub    $0xc,%esp
80104757:	50                   	push   %eax
80104758:	e8 c6 d2 ff ff       	call   80101a23 <idup>
8010475d:	83 c4 10             	add    $0x10,%esp
80104760:	89 c2                	mov    %eax,%edx
80104762:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104765:	89 50 68             	mov    %edx,0x68(%eax)

    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104768:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010476b:	8d 50 6c             	lea    0x6c(%eax),%edx
8010476e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104771:	83 c0 6c             	add    $0x6c,%eax
80104774:	83 ec 04             	sub    $0x4,%esp
80104777:	6a 10                	push   $0x10
80104779:	52                   	push   %edx
8010477a:	50                   	push   %eax
8010477b:	e8 7b 0e 00 00       	call   801055fb <safestrcpy>
80104780:	83 c4 10             	add    $0x10,%esp

    pid = np->pid;
80104783:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104786:	8b 40 10             	mov    0x10(%eax),%eax
80104789:	89 45 d8             	mov    %eax,-0x28(%ebp)

    acquire(&ptable.lock);
8010478c:	83 ec 0c             	sub    $0xc,%esp
8010478f:	68 c0 4d 11 80       	push   $0x80114dc0
80104794:	e8 e8 09 00 00       	call   80105181 <acquire>
80104799:	83 c4 10             	add    $0x10,%esp
    //task 2.1.2.2 - inheriting parent's stuff
    if (curproc != 0) {
8010479c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801047a0:	74 49                	je     801047eb <fork+0x1a7>
        for (i = 0; i < 32; i++) { np->handlers[i] = curproc->handlers[i]; }
801047a2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801047a9:	eb 1e                	jmp    801047c9 <fork+0x185>
801047ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047b1:	83 c2 20             	add    $0x20,%edx
801047b4:	8b 54 90 08          	mov    0x8(%eax,%edx,4),%edx
801047b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801047bb:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801047be:	83 c1 20             	add    $0x20,%ecx
801047c1:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
801047c5:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801047c9:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
801047cd:	7e dc                	jle    801047ab <fork+0x167>
        np->mask = curproc->mask;
801047cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047d2:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
801047d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801047db:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
        np->pending=0;
801047e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801047e4:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
    }
    np->state = RUNNABLE;
801047eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
801047ee:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

    release(&ptable.lock);
801047f5:	83 ec 0c             	sub    $0xc,%esp
801047f8:	68 c0 4d 11 80       	push   $0x80114dc0
801047fd:	e8 ed 09 00 00       	call   801051ef <release>
80104802:	83 c4 10             	add    $0x10,%esp

    return pid;
80104805:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
80104808:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010480b:	5b                   	pop    %ebx
8010480c:	5e                   	pop    %esi
8010480d:	5f                   	pop    %edi
8010480e:	5d                   	pop    %ebp
8010480f:	c3                   	ret    

80104810 <exit>:

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void) {
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	83 ec 18             	sub    $0x18,%esp
    struct proc *curproc = myproc();
80104816:	e8 ba fa ff ff       	call   801042d5 <myproc>
8010481b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    struct proc *p;
    int fd;

    if (curproc == initproc)
8010481e:	a1 40 c6 10 80       	mov    0x8010c640,%eax
80104823:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104826:	75 0d                	jne    80104835 <exit+0x25>
        panic("init exiting");
80104828:	83 ec 0c             	sub    $0xc,%esp
8010482b:	68 72 8d 10 80       	push   $0x80108d72
80104830:	e8 6b bd ff ff       	call   801005a0 <panic>

    // Close all open files.
    for (fd = 0; fd < NOFILE; fd++) {
80104835:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010483c:	eb 3f                	jmp    8010487d <exit+0x6d>
        if (curproc->ofile[fd]) {
8010483e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104841:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104844:	83 c2 08             	add    $0x8,%edx
80104847:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010484b:	85 c0                	test   %eax,%eax
8010484d:	74 2a                	je     80104879 <exit+0x69>
            fileclose(curproc->ofile[fd]);
8010484f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104852:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104855:	83 c2 08             	add    $0x8,%edx
80104858:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010485c:	83 ec 0c             	sub    $0xc,%esp
8010485f:	50                   	push   %eax
80104860:	e8 99 c8 ff ff       	call   801010fe <fileclose>
80104865:	83 c4 10             	add    $0x10,%esp
            curproc->ofile[fd] = 0;
80104868:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010486b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010486e:	83 c2 08             	add    $0x8,%edx
80104871:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104878:	00 

    if (curproc == initproc)
        panic("init exiting");

    // Close all open files.
    for (fd = 0; fd < NOFILE; fd++) {
80104879:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010487d:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104881:	7e bb                	jle    8010483e <exit+0x2e>
            fileclose(curproc->ofile[fd]);
            curproc->ofile[fd] = 0;
        }
    }

    begin_op();
80104883:	e8 fa ec ff ff       	call   80103582 <begin_op>
    iput(curproc->cwd);
80104888:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010488b:	8b 40 68             	mov    0x68(%eax),%eax
8010488e:	83 ec 0c             	sub    $0xc,%esp
80104891:	50                   	push   %eax
80104892:	e8 27 d3 ff ff       	call   80101bbe <iput>
80104897:	83 c4 10             	add    $0x10,%esp
    end_op();
8010489a:	e8 6f ed ff ff       	call   8010360e <end_op>
    curproc->cwd = 0;
8010489f:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048a2:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

    acquire(&ptable.lock);
801048a9:	83 ec 0c             	sub    $0xc,%esp
801048ac:	68 c0 4d 11 80       	push   $0x80114dc0
801048b1:	e8 cb 08 00 00       	call   80105181 <acquire>
801048b6:	83 c4 10             	add    $0x10,%esp

    // Parent might be sleeping in wait().
    wakeup1(curproc->parent);
801048b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048bc:	8b 40 14             	mov    0x14(%eax),%eax
801048bf:	83 ec 0c             	sub    $0xc,%esp
801048c2:	50                   	push   %eax
801048c3:	e8 2b 04 00 00       	call   80104cf3 <wakeup1>
801048c8:	83 c4 10             	add    $0x10,%esp

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801048cb:	c7 45 f4 f4 4d 11 80 	movl   $0x80114df4,-0xc(%ebp)
801048d2:	eb 3a                	jmp    8010490e <exit+0xfe>
        if (p->parent == curproc) {
801048d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048d7:	8b 40 14             	mov    0x14(%eax),%eax
801048da:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801048dd:	75 28                	jne    80104907 <exit+0xf7>
            p->parent = initproc;
801048df:	8b 15 40 c6 10 80    	mov    0x8010c640,%edx
801048e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048e8:	89 50 14             	mov    %edx,0x14(%eax)
            if (p->state == ZOMBIE)
801048eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048ee:	8b 40 0c             	mov    0xc(%eax),%eax
801048f1:	83 f8 05             	cmp    $0x5,%eax
801048f4:	75 11                	jne    80104907 <exit+0xf7>
                wakeup1(initproc);
801048f6:	a1 40 c6 10 80       	mov    0x8010c640,%eax
801048fb:	83 ec 0c             	sub    $0xc,%esp
801048fe:	50                   	push   %eax
801048ff:	e8 ef 03 00 00       	call   80104cf3 <wakeup1>
80104904:	83 c4 10             	add    $0x10,%esp

    // Parent might be sleeping in wait().
    wakeup1(curproc->parent);

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104907:	81 45 f4 0c 01 00 00 	addl   $0x10c,-0xc(%ebp)
8010490e:	81 7d f4 f4 90 11 80 	cmpl   $0x801190f4,-0xc(%ebp)
80104915:	72 bd                	jb     801048d4 <exit+0xc4>
                wakeup1(initproc);
        }
    }

    // Jump into the scheduler, never to return.
    curproc->state = ZOMBIE;
80104917:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010491a:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    sched();
80104921:	e8 eb 01 00 00       	call   80104b11 <sched>
    panic("zombie exit");
80104926:	83 ec 0c             	sub    $0xc,%esp
80104929:	68 7f 8d 10 80       	push   $0x80108d7f
8010492e:	e8 6d bc ff ff       	call   801005a0 <panic>

80104933 <wait>:
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void) {
80104933:	55                   	push   %ebp
80104934:	89 e5                	mov    %esp,%ebp
80104936:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
    int havekids, pid;
    struct proc *curproc = myproc();
80104939:	e8 97 f9 ff ff       	call   801042d5 <myproc>
8010493e:	89 45 ec             	mov    %eax,-0x14(%ebp)

    acquire(&ptable.lock);
80104941:	83 ec 0c             	sub    $0xc,%esp
80104944:	68 c0 4d 11 80       	push   $0x80114dc0
80104949:	e8 33 08 00 00       	call   80105181 <acquire>
8010494e:	83 c4 10             	add    $0x10,%esp
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
80104951:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104958:	c7 45 f4 f4 4d 11 80 	movl   $0x80114df4,-0xc(%ebp)
8010495f:	e9 a4 00 00 00       	jmp    80104a08 <wait+0xd5>
            if (p->parent != curproc)
80104964:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104967:	8b 40 14             	mov    0x14(%eax),%eax
8010496a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010496d:	0f 85 8d 00 00 00    	jne    80104a00 <wait+0xcd>
                continue;
            havekids = 1;
80104973:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            if (p->state == ZOMBIE) {
8010497a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010497d:	8b 40 0c             	mov    0xc(%eax),%eax
80104980:	83 f8 05             	cmp    $0x5,%eax
80104983:	75 7c                	jne    80104a01 <wait+0xce>
                // Found one.
                pid = p->pid;
80104985:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104988:	8b 40 10             	mov    0x10(%eax),%eax
8010498b:	89 45 e8             	mov    %eax,-0x18(%ebp)
                kfree(p->kstack);
8010498e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104991:	8b 40 08             	mov    0x8(%eax),%eax
80104994:	83 ec 0c             	sub    $0xc,%esp
80104997:	50                   	push   %eax
80104998:	e8 ab e2 ff ff       	call   80102c48 <kfree>
8010499d:	83 c4 10             	add    $0x10,%esp
                p->kstack = 0;
801049a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049a3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                freevm(p->pgdir);
801049aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049ad:	8b 40 04             	mov    0x4(%eax),%eax
801049b0:	83 ec 0c             	sub    $0xc,%esp
801049b3:	50                   	push   %eax
801049b4:	e8 51 3d 00 00       	call   8010870a <freevm>
801049b9:	83 c4 10             	add    $0x10,%esp
                p->pid = 0;
801049bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049bf:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
                p->parent = 0;
801049c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c9:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
                p->name[0] = 0;
801049d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d3:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
                p->killed = 0;
801049d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049da:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
                p->state = UNUSED;
801049e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
                release(&ptable.lock);
801049eb:	83 ec 0c             	sub    $0xc,%esp
801049ee:	68 c0 4d 11 80       	push   $0x80114dc0
801049f3:	e8 f7 07 00 00       	call   801051ef <release>
801049f8:	83 c4 10             	add    $0x10,%esp
                return pid;
801049fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801049fe:	eb 54                	jmp    80104a54 <wait+0x121>
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
            if (p->parent != curproc)
                continue;
80104a00:	90                   	nop

    acquire(&ptable.lock);
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104a01:	81 45 f4 0c 01 00 00 	addl   $0x10c,-0xc(%ebp)
80104a08:	81 7d f4 f4 90 11 80 	cmpl   $0x801190f4,-0xc(%ebp)
80104a0f:	0f 82 4f ff ff ff    	jb     80104964 <wait+0x31>
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if (!havekids || curproc->killed) {
80104a15:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104a19:	74 0a                	je     80104a25 <wait+0xf2>
80104a1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a1e:	8b 40 24             	mov    0x24(%eax),%eax
80104a21:	85 c0                	test   %eax,%eax
80104a23:	74 17                	je     80104a3c <wait+0x109>
            release(&ptable.lock);
80104a25:	83 ec 0c             	sub    $0xc,%esp
80104a28:	68 c0 4d 11 80       	push   $0x80114dc0
80104a2d:	e8 bd 07 00 00       	call   801051ef <release>
80104a32:	83 c4 10             	add    $0x10,%esp
            return -1;
80104a35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a3a:	eb 18                	jmp    80104a54 <wait+0x121>
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104a3c:	83 ec 08             	sub    $0x8,%esp
80104a3f:	68 c0 4d 11 80       	push   $0x80114dc0
80104a44:	ff 75 ec             	pushl  -0x14(%ebp)
80104a47:	e8 00 02 00 00       	call   80104c4c <sleep>
80104a4c:	83 c4 10             	add    $0x10,%esp
    }
80104a4f:	e9 fd fe ff ff       	jmp    80104951 <wait+0x1e>
}
80104a54:	c9                   	leave  
80104a55:	c3                   	ret    

80104a56 <scheduler>:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void) {
80104a56:	55                   	push   %ebp
80104a57:	89 e5                	mov    %esp,%ebp
80104a59:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
    struct cpu *c = mycpu();
80104a5c:	e8 fc f7 ff ff       	call   8010425d <mycpu>
80104a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
    c->proc = 0;
80104a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a67:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104a6e:	00 00 00 

    for (;;) {
        // Enable interrupts on this processor.
        sti();
80104a71:	e8 a1 f7 ff ff       	call   80104217 <sti>

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
80104a76:	83 ec 0c             	sub    $0xc,%esp
80104a79:	68 c0 4d 11 80       	push   $0x80114dc0
80104a7e:	e8 fe 06 00 00       	call   80105181 <acquire>
80104a83:	83 c4 10             	add    $0x10,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104a86:	c7 45 f4 f4 4d 11 80 	movl   $0x80114df4,-0xc(%ebp)
80104a8d:	eb 64                	jmp    80104af3 <scheduler+0x9d>
            if (p->state != RUNNABLE)
80104a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a92:	8b 40 0c             	mov    0xc(%eax),%eax
80104a95:	83 f8 03             	cmp    $0x3,%eax
80104a98:	75 51                	jne    80104aeb <scheduler+0x95>

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.

            c->proc = p;
80104a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104aa0:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
            switchuvm(p);
80104aa6:	83 ec 0c             	sub    $0xc,%esp
80104aa9:	ff 75 f4             	pushl  -0xc(%ebp)
80104aac:	e8 b5 37 00 00       	call   80108266 <switchuvm>
80104ab1:	83 c4 10             	add    $0x10,%esp
            p->state = RUNNING;
80104ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab7:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

            swtch(&(c->scheduler), p->context);
80104abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac1:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ac4:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ac7:	83 c2 04             	add    $0x4,%edx
80104aca:	83 ec 08             	sub    $0x8,%esp
80104acd:	50                   	push   %eax
80104ace:	52                   	push   %edx
80104acf:	e8 98 0b 00 00       	call   8010566c <swtch>
80104ad4:	83 c4 10             	add    $0x10,%esp
            switchkvm();
80104ad7:	e8 71 37 00 00       	call   8010824d <switchkvm>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
80104adc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104adf:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104ae6:	00 00 00 
80104ae9:	eb 01                	jmp    80104aec <scheduler+0x96>

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
            if (p->state != RUNNABLE)
                continue;
80104aeb:	90                   	nop
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104aec:	81 45 f4 0c 01 00 00 	addl   $0x10c,-0xc(%ebp)
80104af3:	81 7d f4 f4 90 11 80 	cmpl   $0x801190f4,-0xc(%ebp)
80104afa:	72 93                	jb     80104a8f <scheduler+0x39>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
        }
        release(&ptable.lock);
80104afc:	83 ec 0c             	sub    $0xc,%esp
80104aff:	68 c0 4d 11 80       	push   $0x80114dc0
80104b04:	e8 e6 06 00 00       	call   801051ef <release>
80104b09:	83 c4 10             	add    $0x10,%esp

    }
80104b0c:	e9 60 ff ff ff       	jmp    80104a71 <scheduler+0x1b>

80104b11 <sched>:
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void) {
80104b11:	55                   	push   %ebp
80104b12:	89 e5                	mov    %esp,%ebp
80104b14:	83 ec 18             	sub    $0x18,%esp
    int intena;
    struct proc *p = myproc();
80104b17:	e8 b9 f7 ff ff       	call   801042d5 <myproc>
80104b1c:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (!holding(&ptable.lock))
80104b1f:	83 ec 0c             	sub    $0xc,%esp
80104b22:	68 c0 4d 11 80       	push   $0x80114dc0
80104b27:	e8 8f 07 00 00       	call   801052bb <holding>
80104b2c:	83 c4 10             	add    $0x10,%esp
80104b2f:	85 c0                	test   %eax,%eax
80104b31:	75 0d                	jne    80104b40 <sched+0x2f>
        panic("sched ptable.lock");
80104b33:	83 ec 0c             	sub    $0xc,%esp
80104b36:	68 8b 8d 10 80       	push   $0x80108d8b
80104b3b:	e8 60 ba ff ff       	call   801005a0 <panic>
    if (mycpu()->ncli != 1)
80104b40:	e8 18 f7 ff ff       	call   8010425d <mycpu>
80104b45:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b4b:	83 f8 01             	cmp    $0x1,%eax
80104b4e:	74 0d                	je     80104b5d <sched+0x4c>
        panic("sched locks");
80104b50:	83 ec 0c             	sub    $0xc,%esp
80104b53:	68 9d 8d 10 80       	push   $0x80108d9d
80104b58:	e8 43 ba ff ff       	call   801005a0 <panic>
    if (p->state == RUNNING)
80104b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b60:	8b 40 0c             	mov    0xc(%eax),%eax
80104b63:	83 f8 04             	cmp    $0x4,%eax
80104b66:	75 0d                	jne    80104b75 <sched+0x64>
        panic("sched running");
80104b68:	83 ec 0c             	sub    $0xc,%esp
80104b6b:	68 a9 8d 10 80       	push   $0x80108da9
80104b70:	e8 2b ba ff ff       	call   801005a0 <panic>
    if (readeflags() & FL_IF)
80104b75:	e8 8d f6 ff ff       	call   80104207 <readeflags>
80104b7a:	25 00 02 00 00       	and    $0x200,%eax
80104b7f:	85 c0                	test   %eax,%eax
80104b81:	74 0d                	je     80104b90 <sched+0x7f>
        panic("sched interruptible");
80104b83:	83 ec 0c             	sub    $0xc,%esp
80104b86:	68 b7 8d 10 80       	push   $0x80108db7
80104b8b:	e8 10 ba ff ff       	call   801005a0 <panic>
    intena = mycpu()->intena;
80104b90:	e8 c8 f6 ff ff       	call   8010425d <mycpu>
80104b95:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    swtch(&p->context, mycpu()->scheduler);
80104b9e:	e8 ba f6 ff ff       	call   8010425d <mycpu>
80104ba3:	8b 40 04             	mov    0x4(%eax),%eax
80104ba6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ba9:	83 c2 1c             	add    $0x1c,%edx
80104bac:	83 ec 08             	sub    $0x8,%esp
80104baf:	50                   	push   %eax
80104bb0:	52                   	push   %edx
80104bb1:	e8 b6 0a 00 00       	call   8010566c <swtch>
80104bb6:	83 c4 10             	add    $0x10,%esp
    mycpu()->intena = intena;
80104bb9:	e8 9f f6 ff ff       	call   8010425d <mycpu>
80104bbe:	89 c2                	mov    %eax,%edx
80104bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bc3:	89 82 a8 00 00 00    	mov    %eax,0xa8(%edx)
}
80104bc9:	90                   	nop
80104bca:	c9                   	leave  
80104bcb:	c3                   	ret    

80104bcc <yield>:

// Give up the CPU for one scheduling round.
void
yield(void) {
80104bcc:	55                   	push   %ebp
80104bcd:	89 e5                	mov    %esp,%ebp
80104bcf:	83 ec 08             	sub    $0x8,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
80104bd2:	83 ec 0c             	sub    $0xc,%esp
80104bd5:	68 c0 4d 11 80       	push   $0x80114dc0
80104bda:	e8 a2 05 00 00       	call   80105181 <acquire>
80104bdf:	83 c4 10             	add    $0x10,%esp
    myproc()->state = RUNNABLE;
80104be2:	e8 ee f6 ff ff       	call   801042d5 <myproc>
80104be7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    sched();
80104bee:	e8 1e ff ff ff       	call   80104b11 <sched>
    release(&ptable.lock);
80104bf3:	83 ec 0c             	sub    $0xc,%esp
80104bf6:	68 c0 4d 11 80       	push   $0x80114dc0
80104bfb:	e8 ef 05 00 00       	call   801051ef <release>
80104c00:	83 c4 10             	add    $0x10,%esp
}
80104c03:	90                   	nop
80104c04:	c9                   	leave  
80104c05:	c3                   	ret    

80104c06 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void) {
80104c06:	55                   	push   %ebp
80104c07:	89 e5                	mov    %esp,%ebp
80104c09:	83 ec 08             	sub    $0x8,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80104c0c:	83 ec 0c             	sub    $0xc,%esp
80104c0f:	68 c0 4d 11 80       	push   $0x80114dc0
80104c14:	e8 d6 05 00 00       	call   801051ef <release>
80104c19:	83 c4 10             	add    $0x10,%esp

    if (first) {
80104c1c:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104c21:	85 c0                	test   %eax,%eax
80104c23:	74 24                	je     80104c49 <forkret+0x43>
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot
        // be run from main().
        first = 0;
80104c25:	c7 05 04 c0 10 80 00 	movl   $0x0,0x8010c004
80104c2c:	00 00 00 
        iinit(ROOTDEV);
80104c2f:	83 ec 0c             	sub    $0xc,%esp
80104c32:	6a 01                	push   $0x1
80104c34:	e8 b2 ca ff ff       	call   801016eb <iinit>
80104c39:	83 c4 10             	add    $0x10,%esp
        initlog(ROOTDEV);
80104c3c:	83 ec 0c             	sub    $0xc,%esp
80104c3f:	6a 01                	push   $0x1
80104c41:	e8 1e e7 ff ff       	call   80103364 <initlog>
80104c46:	83 c4 10             	add    $0x10,%esp
    }

    // Return to "caller", actually trapret (see allocproc).
}
80104c49:	90                   	nop
80104c4a:	c9                   	leave  
80104c4b:	c3                   	ret    

80104c4c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk) {
80104c4c:	55                   	push   %ebp
80104c4d:	89 e5                	mov    %esp,%ebp
80104c4f:	83 ec 18             	sub    $0x18,%esp
    struct proc *p = myproc();
80104c52:	e8 7e f6 ff ff       	call   801042d5 <myproc>
80104c57:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (p == 0)
80104c5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104c5e:	75 0d                	jne    80104c6d <sleep+0x21>
        panic("sleep");
80104c60:	83 ec 0c             	sub    $0xc,%esp
80104c63:	68 cb 8d 10 80       	push   $0x80108dcb
80104c68:	e8 33 b9 ff ff       	call   801005a0 <panic>

    if (lk == 0)
80104c6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104c71:	75 0d                	jne    80104c80 <sleep+0x34>
        panic("sleep without lk");
80104c73:	83 ec 0c             	sub    $0xc,%esp
80104c76:	68 d1 8d 10 80       	push   $0x80108dd1
80104c7b:	e8 20 b9 ff ff       	call   801005a0 <panic>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if (lk != &ptable.lock) {  //DOC: sleeplock0
80104c80:	81 7d 0c c0 4d 11 80 	cmpl   $0x80114dc0,0xc(%ebp)
80104c87:	74 1e                	je     80104ca7 <sleep+0x5b>
        acquire(&ptable.lock);  //DOC: sleeplock1
80104c89:	83 ec 0c             	sub    $0xc,%esp
80104c8c:	68 c0 4d 11 80       	push   $0x80114dc0
80104c91:	e8 eb 04 00 00       	call   80105181 <acquire>
80104c96:	83 c4 10             	add    $0x10,%esp
        release(lk);
80104c99:	83 ec 0c             	sub    $0xc,%esp
80104c9c:	ff 75 0c             	pushl  0xc(%ebp)
80104c9f:	e8 4b 05 00 00       	call   801051ef <release>
80104ca4:	83 c4 10             	add    $0x10,%esp
    }
    // Go to sleep.
    p->chan = chan;
80104ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104caa:	8b 55 08             	mov    0x8(%ebp),%edx
80104cad:	89 50 20             	mov    %edx,0x20(%eax)
    p->state = SLEEPING;
80104cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cb3:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

    sched();
80104cba:	e8 52 fe ff ff       	call   80104b11 <sched>

    // Tidy up.
    p->chan = 0;
80104cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cc2:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
80104cc9:	81 7d 0c c0 4d 11 80 	cmpl   $0x80114dc0,0xc(%ebp)
80104cd0:	74 1e                	je     80104cf0 <sleep+0xa4>
        release(&ptable.lock);
80104cd2:	83 ec 0c             	sub    $0xc,%esp
80104cd5:	68 c0 4d 11 80       	push   $0x80114dc0
80104cda:	e8 10 05 00 00       	call   801051ef <release>
80104cdf:	83 c4 10             	add    $0x10,%esp
        acquire(lk);
80104ce2:	83 ec 0c             	sub    $0xc,%esp
80104ce5:	ff 75 0c             	pushl  0xc(%ebp)
80104ce8:	e8 94 04 00 00       	call   80105181 <acquire>
80104ced:	83 c4 10             	add    $0x10,%esp
    }
}
80104cf0:	90                   	nop
80104cf1:	c9                   	leave  
80104cf2:	c3                   	ret    

80104cf3 <wakeup1>:

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan) {
80104cf3:	55                   	push   %ebp
80104cf4:	89 e5                	mov    %esp,%ebp
80104cf6:	83 ec 10             	sub    $0x10,%esp
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104cf9:	c7 45 fc f4 4d 11 80 	movl   $0x80114df4,-0x4(%ebp)
80104d00:	eb 27                	jmp    80104d29 <wakeup1+0x36>
        if (p->state == SLEEPING && p->chan == chan)
80104d02:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d05:	8b 40 0c             	mov    0xc(%eax),%eax
80104d08:	83 f8 02             	cmp    $0x2,%eax
80104d0b:	75 15                	jne    80104d22 <wakeup1+0x2f>
80104d0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d10:	8b 40 20             	mov    0x20(%eax),%eax
80104d13:	3b 45 08             	cmp    0x8(%ebp),%eax
80104d16:	75 0a                	jne    80104d22 <wakeup1+0x2f>
            p->state = RUNNABLE;
80104d18:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d1b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d22:	81 45 fc 0c 01 00 00 	addl   $0x10c,-0x4(%ebp)
80104d29:	81 7d fc f4 90 11 80 	cmpl   $0x801190f4,-0x4(%ebp)
80104d30:	72 d0                	jb     80104d02 <wakeup1+0xf>
        if (p->state == SLEEPING && p->chan == chan)
            p->state = RUNNABLE;
}
80104d32:	90                   	nop
80104d33:	c9                   	leave  
80104d34:	c3                   	ret    

80104d35 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
80104d35:	55                   	push   %ebp
80104d36:	89 e5                	mov    %esp,%ebp
80104d38:	83 ec 08             	sub    $0x8,%esp
    acquire(&ptable.lock);
80104d3b:	83 ec 0c             	sub    $0xc,%esp
80104d3e:	68 c0 4d 11 80       	push   $0x80114dc0
80104d43:	e8 39 04 00 00       	call   80105181 <acquire>
80104d48:	83 c4 10             	add    $0x10,%esp
    wakeup1(chan);
80104d4b:	83 ec 0c             	sub    $0xc,%esp
80104d4e:	ff 75 08             	pushl  0x8(%ebp)
80104d51:	e8 9d ff ff ff       	call   80104cf3 <wakeup1>
80104d56:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80104d59:	83 ec 0c             	sub    $0xc,%esp
80104d5c:	68 c0 4d 11 80       	push   $0x80114dc0
80104d61:	e8 89 04 00 00       	call   801051ef <release>
80104d66:	83 c4 10             	add    $0x10,%esp
}
80104d69:	90                   	nop
80104d6a:	c9                   	leave  
80104d6b:	c3                   	ret    

80104d6c <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid, int signum) {
80104d6c:	55                   	push   %ebp
80104d6d:	89 e5                	mov    %esp,%ebp
80104d6f:	53                   	push   %ebx
80104d70:	83 ec 14             	sub    $0x14,%esp
    struct proc *p;
    //Legal signal number
    if (signum >= 0 && signum <= 31) {
80104d73:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104d77:	78 7d                	js     80104df6 <kill+0x8a>
80104d79:	83 7d 0c 1f          	cmpl   $0x1f,0xc(%ebp)
80104d7d:	7f 77                	jg     80104df6 <kill+0x8a>
        acquire(&ptable.lock);
80104d7f:	83 ec 0c             	sub    $0xc,%esp
80104d82:	68 c0 4d 11 80       	push   $0x80114dc0
80104d87:	e8 f5 03 00 00       	call   80105181 <acquire>
80104d8c:	83 c4 10             	add    $0x10,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104d8f:	c7 45 f4 f4 4d 11 80 	movl   $0x80114df4,-0xc(%ebp)
80104d96:	eb 45                	jmp    80104ddd <kill+0x71>
            if (p->pid == pid) {
80104d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d9b:	8b 40 10             	mov    0x10(%eax),%eax
80104d9e:	3b 45 08             	cmp    0x8(%ebp),%eax
80104da1:	75 33                	jne    80104dd6 <kill+0x6a>

                p->pending = p->pending | (1 << signum);
80104da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104da6:	8b 50 7c             	mov    0x7c(%eax),%edx
80104da9:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dac:	bb 01 00 00 00       	mov    $0x1,%ebx
80104db1:	89 c1                	mov    %eax,%ecx
80104db3:	d3 e3                	shl    %cl,%ebx
80104db5:	89 d8                	mov    %ebx,%eax
80104db7:	09 c2                	or     %eax,%edx
80104db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dbc:	89 50 7c             	mov    %edx,0x7c(%eax)
                //p->killed = 1;
                // Wake process from sleep if necessary.
                //if(p->state == SLEEPING)
                //  p->state = RUNNABLE;
                release(&ptable.lock);
80104dbf:	83 ec 0c             	sub    $0xc,%esp
80104dc2:	68 c0 4d 11 80       	push   $0x80114dc0
80104dc7:	e8 23 04 00 00       	call   801051ef <release>
80104dcc:	83 c4 10             	add    $0x10,%esp
                return 0;
80104dcf:	b8 00 00 00 00       	mov    $0x0,%eax
80104dd4:	eb 25                	jmp    80104dfb <kill+0x8f>
kill(int pid, int signum) {
    struct proc *p;
    //Legal signal number
    if (signum >= 0 && signum <= 31) {
        acquire(&ptable.lock);
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104dd6:	81 45 f4 0c 01 00 00 	addl   $0x10c,-0xc(%ebp)
80104ddd:	81 7d f4 f4 90 11 80 	cmpl   $0x801190f4,-0xc(%ebp)
80104de4:	72 b2                	jb     80104d98 <kill+0x2c>
                //  p->state = RUNNABLE;
                release(&ptable.lock);
                return 0;
            }
        }
        release(&ptable.lock);
80104de6:	83 ec 0c             	sub    $0xc,%esp
80104de9:	68 c0 4d 11 80       	push   $0x80114dc0
80104dee:	e8 fc 03 00 00       	call   801051ef <release>
80104df3:	83 c4 10             	add    $0x10,%esp
    }
    return -1;
80104df6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dfb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dfe:	c9                   	leave  
80104dff:	c3                   	ret    

80104e00 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	83 ec 48             	sub    $0x48,%esp
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104e06:	c7 45 f0 f4 4d 11 80 	movl   $0x80114df4,-0x10(%ebp)
80104e0d:	e9 da 00 00 00       	jmp    80104eec <procdump+0xec>
        if (p->state == UNUSED)
80104e12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e15:	8b 40 0c             	mov    0xc(%eax),%eax
80104e18:	85 c0                	test   %eax,%eax
80104e1a:	0f 84 c4 00 00 00    	je     80104ee4 <procdump+0xe4>
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e23:	8b 40 0c             	mov    0xc(%eax),%eax
80104e26:	83 f8 05             	cmp    $0x5,%eax
80104e29:	77 23                	ja     80104e4e <procdump+0x4e>
80104e2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e2e:	8b 40 0c             	mov    0xc(%eax),%eax
80104e31:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104e38:	85 c0                	test   %eax,%eax
80104e3a:	74 12                	je     80104e4e <procdump+0x4e>
            state = states[p->state];
80104e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e3f:	8b 40 0c             	mov    0xc(%eax),%eax
80104e42:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104e49:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104e4c:	eb 07                	jmp    80104e55 <procdump+0x55>
        else
            state = "???";
80104e4e:	c7 45 ec e2 8d 10 80 	movl   $0x80108de2,-0x14(%ebp)
        cprintf("%d %s %s", p->pid, state, p->name);
80104e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e58:	8d 50 6c             	lea    0x6c(%eax),%edx
80104e5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e5e:	8b 40 10             	mov    0x10(%eax),%eax
80104e61:	52                   	push   %edx
80104e62:	ff 75 ec             	pushl  -0x14(%ebp)
80104e65:	50                   	push   %eax
80104e66:	68 e6 8d 10 80       	push   $0x80108de6
80104e6b:	e8 90 b5 ff ff       	call   80100400 <cprintf>
80104e70:	83 c4 10             	add    $0x10,%esp
        if (p->state == SLEEPING) {
80104e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e76:	8b 40 0c             	mov    0xc(%eax),%eax
80104e79:	83 f8 02             	cmp    $0x2,%eax
80104e7c:	75 54                	jne    80104ed2 <procdump+0xd2>
            getcallerpcs((uint *) p->context->ebp + 2, pc);
80104e7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e81:	8b 40 1c             	mov    0x1c(%eax),%eax
80104e84:	8b 40 0c             	mov    0xc(%eax),%eax
80104e87:	83 c0 08             	add    $0x8,%eax
80104e8a:	89 c2                	mov    %eax,%edx
80104e8c:	83 ec 08             	sub    $0x8,%esp
80104e8f:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104e92:	50                   	push   %eax
80104e93:	52                   	push   %edx
80104e94:	e8 a8 03 00 00       	call   80105241 <getcallerpcs>
80104e99:	83 c4 10             	add    $0x10,%esp
            for (i = 0; i < 10 && pc[i] != 0; i++)
80104e9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104ea3:	eb 1c                	jmp    80104ec1 <procdump+0xc1>
                cprintf(" %p", pc[i]);
80104ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ea8:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104eac:	83 ec 08             	sub    $0x8,%esp
80104eaf:	50                   	push   %eax
80104eb0:	68 ef 8d 10 80       	push   $0x80108def
80104eb5:	e8 46 b5 ff ff       	call   80100400 <cprintf>
80104eba:	83 c4 10             	add    $0x10,%esp
        else
            state = "???";
        cprintf("%d %s %s", p->pid, state, p->name);
        if (p->state == SLEEPING) {
            getcallerpcs((uint *) p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
80104ebd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104ec1:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104ec5:	7f 0b                	jg     80104ed2 <procdump+0xd2>
80104ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eca:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104ece:	85 c0                	test   %eax,%eax
80104ed0:	75 d3                	jne    80104ea5 <procdump+0xa5>
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
80104ed2:	83 ec 0c             	sub    $0xc,%esp
80104ed5:	68 f3 8d 10 80       	push   $0x80108df3
80104eda:	e8 21 b5 ff ff       	call   80100400 <cprintf>
80104edf:	83 c4 10             	add    $0x10,%esp
80104ee2:	eb 01                	jmp    80104ee5 <procdump+0xe5>
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state == UNUSED)
            continue;
80104ee4:	90                   	nop
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104ee5:	81 45 f0 0c 01 00 00 	addl   $0x10c,-0x10(%ebp)
80104eec:	81 7d f0 f4 90 11 80 	cmpl   $0x801190f4,-0x10(%ebp)
80104ef3:	0f 82 19 ff ff ff    	jb     80104e12 <procdump+0x12>
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
    }
}
80104ef9:	90                   	nop
80104efa:	c9                   	leave  
80104efb:	c3                   	ret    

80104efc <sigprocmask>:

//Task 2.1.3
uint sigprocmask(uint sigmask) {
80104efc:	55                   	push   %ebp
80104efd:	89 e5                	mov    %esp,%ebp
80104eff:	83 ec 18             	sub    $0x18,%esp
    struct proc *curproc = myproc();
80104f02:	e8 ce f3 ff ff       	call   801042d5 <myproc>
80104f07:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (curproc != 0) {
80104f0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104f0e:	74 1d                	je     80104f2d <sigprocmask+0x31>
        uint oldmask = curproc->mask;
80104f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f13:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104f19:	89 45 f0             	mov    %eax,-0x10(%ebp)
        curproc->mask = sigmask;
80104f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f1f:	8b 55 08             	mov    0x8(%ebp),%edx
80104f22:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
        return oldmask;
80104f28:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f2b:	eb 05                	jmp    80104f32 <sigprocmask+0x36>
    }
    return 0;
80104f2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104f32:	c9                   	leave  
80104f33:	c3                   	ret    

80104f34 <signal>:

//Task 2.1.4
sighandler_t signal(int signum, sighandler_t handler) {
80104f34:	55                   	push   %ebp
80104f35:	89 e5                	mov    %esp,%ebp
80104f37:	83 ec 18             	sub    $0x18,%esp
    struct proc *curproc = myproc();
80104f3a:	e8 96 f3 ff ff       	call   801042d5 <myproc>
80104f3f:	89 45 f4             	mov    %eax,-0xc(%ebp)


    if (curproc != 0 && signum >= 0 && signum <= 31) {
80104f42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104f46:	74 6c                	je     80104fb4 <signal+0x80>
80104f48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104f4c:	78 66                	js     80104fb4 <signal+0x80>
80104f4e:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
80104f52:	7f 60                	jg     80104fb4 <signal+0x80>
        cprintf("SIGNALING! signal(%d , handler)\n, %d",signum,handler);
80104f54:	83 ec 04             	sub    $0x4,%esp
80104f57:	ff 75 0c             	pushl  0xc(%ebp)
80104f5a:	ff 75 08             	pushl  0x8(%ebp)
80104f5d:	68 f8 8d 10 80       	push   $0x80108df8
80104f62:	e8 99 b4 ff ff       	call   80100400 <cprintf>
80104f67:	83 c4 10             	add    $0x10,%esp
        sighandler_t oldHandler = curproc->handlers[signum];
80104f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f6d:	8b 55 08             	mov    0x8(%ebp),%edx
80104f70:	83 c2 20             	add    $0x20,%edx
80104f73:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104f77:	89 45 f0             	mov    %eax,-0x10(%ebp)
        curproc->handlers[signum] = handler;
80104f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f7d:	8b 55 08             	mov    0x8(%ebp),%edx
80104f80:	8d 4a 20             	lea    0x20(%edx),%ecx
80104f83:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f86:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
        cprintf("Curproc == %d, pid: %d\n handler: %d\n",curproc,curproc->pid,curproc->handlers[signum]);
80104f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f8d:	8b 55 08             	mov    0x8(%ebp),%edx
80104f90:	83 c2 20             	add    $0x20,%edx
80104f93:	8b 54 90 08          	mov    0x8(%eax,%edx,4),%edx
80104f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f9a:	8b 40 10             	mov    0x10(%eax),%eax
80104f9d:	52                   	push   %edx
80104f9e:	50                   	push   %eax
80104f9f:	ff 75 f4             	pushl  -0xc(%ebp)
80104fa2:	68 20 8e 10 80       	push   $0x80108e20
80104fa7:	e8 54 b4 ff ff       	call   80100400 <cprintf>
80104fac:	83 c4 10             	add    $0x10,%esp

        return oldHandler;
80104faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fb2:	eb 05                	jmp    80104fb9 <signal+0x85>
    }
    return (sighandler_t)-2;
80104fb4:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
}
80104fb9:	c9                   	leave  
80104fba:	c3                   	ret    

80104fbb <sigret>:


void
sigret() {
80104fbb:	55                   	push   %ebp
80104fbc:	89 e5                	mov    %esp,%ebp
80104fbe:	83 ec 18             	sub    $0x18,%esp
    struct proc *curproc = myproc();
80104fc1:	e8 0f f3 ff ff       	call   801042d5 <myproc>
80104fc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (curproc) {
80104fc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104fcd:	74 30                	je     80104fff <sigret+0x44>
        memmove(curproc->tf, curproc->trap_backup, sizeof(struct trapframe));
80104fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fd2:	8b 90 08 01 00 00    	mov    0x108(%eax),%edx
80104fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fdb:	8b 40 18             	mov    0x18(%eax),%eax
80104fde:	83 ec 04             	sub    $0x4,%esp
80104fe1:	6a 4c                	push   $0x4c
80104fe3:	52                   	push   %edx
80104fe4:	50                   	push   %eax
80104fe5:	e8 cd 04 00 00       	call   801054b7 <memmove>
80104fea:	83 c4 10             	add    $0x10,%esp
        curproc->mask = curproc->mask_backup;     //restore the mask
80104fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ff0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ff9:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
    }
}
80104fff:	90                   	nop
80105000:	c9                   	leave  
80105001:	c3                   	ret    

80105002 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105002:	55                   	push   %ebp
80105003:	89 e5                	mov    %esp,%ebp
80105005:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
80105008:	8b 45 08             	mov    0x8(%ebp),%eax
8010500b:	83 c0 04             	add    $0x4,%eax
8010500e:	83 ec 08             	sub    $0x8,%esp
80105011:	68 6f 8e 10 80       	push   $0x80108e6f
80105016:	50                   	push   %eax
80105017:	e8 43 01 00 00       	call   8010515f <initlock>
8010501c:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
8010501f:	8b 45 08             	mov    0x8(%ebp),%eax
80105022:	8b 55 0c             	mov    0xc(%ebp),%edx
80105025:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80105028:	8b 45 08             	mov    0x8(%ebp),%eax
8010502b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80105031:	8b 45 08             	mov    0x8(%ebp),%eax
80105034:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
8010503b:	90                   	nop
8010503c:	c9                   	leave  
8010503d:	c3                   	ret    

8010503e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
8010503e:	55                   	push   %ebp
8010503f:	89 e5                	mov    %esp,%ebp
80105041:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80105044:	8b 45 08             	mov    0x8(%ebp),%eax
80105047:	83 c0 04             	add    $0x4,%eax
8010504a:	83 ec 0c             	sub    $0xc,%esp
8010504d:	50                   	push   %eax
8010504e:	e8 2e 01 00 00       	call   80105181 <acquire>
80105053:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80105056:	eb 15                	jmp    8010506d <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
80105058:	8b 45 08             	mov    0x8(%ebp),%eax
8010505b:	83 c0 04             	add    $0x4,%eax
8010505e:	83 ec 08             	sub    $0x8,%esp
80105061:	50                   	push   %eax
80105062:	ff 75 08             	pushl  0x8(%ebp)
80105065:	e8 e2 fb ff ff       	call   80104c4c <sleep>
8010506a:	83 c4 10             	add    $0x10,%esp

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010506d:	8b 45 08             	mov    0x8(%ebp),%eax
80105070:	8b 00                	mov    (%eax),%eax
80105072:	85 c0                	test   %eax,%eax
80105074:	75 e2                	jne    80105058 <acquiresleep+0x1a>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80105076:	8b 45 08             	mov    0x8(%ebp),%eax
80105079:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
8010507f:	e8 51 f2 ff ff       	call   801042d5 <myproc>
80105084:	8b 50 10             	mov    0x10(%eax),%edx
80105087:	8b 45 08             	mov    0x8(%ebp),%eax
8010508a:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
8010508d:	8b 45 08             	mov    0x8(%ebp),%eax
80105090:	83 c0 04             	add    $0x4,%eax
80105093:	83 ec 0c             	sub    $0xc,%esp
80105096:	50                   	push   %eax
80105097:	e8 53 01 00 00       	call   801051ef <release>
8010509c:	83 c4 10             	add    $0x10,%esp
}
8010509f:	90                   	nop
801050a0:	c9                   	leave  
801050a1:	c3                   	ret    

801050a2 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801050a2:	55                   	push   %ebp
801050a3:	89 e5                	mov    %esp,%ebp
801050a5:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
801050a8:	8b 45 08             	mov    0x8(%ebp),%eax
801050ab:	83 c0 04             	add    $0x4,%eax
801050ae:	83 ec 0c             	sub    $0xc,%esp
801050b1:	50                   	push   %eax
801050b2:	e8 ca 00 00 00       	call   80105181 <acquire>
801050b7:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
801050ba:	8b 45 08             	mov    0x8(%ebp),%eax
801050bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
801050c3:	8b 45 08             	mov    0x8(%ebp),%eax
801050c6:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
801050cd:	83 ec 0c             	sub    $0xc,%esp
801050d0:	ff 75 08             	pushl  0x8(%ebp)
801050d3:	e8 5d fc ff ff       	call   80104d35 <wakeup>
801050d8:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
801050db:	8b 45 08             	mov    0x8(%ebp),%eax
801050de:	83 c0 04             	add    $0x4,%eax
801050e1:	83 ec 0c             	sub    $0xc,%esp
801050e4:	50                   	push   %eax
801050e5:	e8 05 01 00 00       	call   801051ef <release>
801050ea:	83 c4 10             	add    $0x10,%esp
}
801050ed:	90                   	nop
801050ee:	c9                   	leave  
801050ef:	c3                   	ret    

801050f0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	83 ec 18             	sub    $0x18,%esp
  int r;
  
  acquire(&lk->lk);
801050f6:	8b 45 08             	mov    0x8(%ebp),%eax
801050f9:	83 c0 04             	add    $0x4,%eax
801050fc:	83 ec 0c             	sub    $0xc,%esp
801050ff:	50                   	push   %eax
80105100:	e8 7c 00 00 00       	call   80105181 <acquire>
80105105:	83 c4 10             	add    $0x10,%esp
  r = lk->locked;
80105108:	8b 45 08             	mov    0x8(%ebp),%eax
8010510b:	8b 00                	mov    (%eax),%eax
8010510d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80105110:	8b 45 08             	mov    0x8(%ebp),%eax
80105113:	83 c0 04             	add    $0x4,%eax
80105116:	83 ec 0c             	sub    $0xc,%esp
80105119:	50                   	push   %eax
8010511a:	e8 d0 00 00 00       	call   801051ef <release>
8010511f:	83 c4 10             	add    $0x10,%esp
  return r;
80105122:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105125:	c9                   	leave  
80105126:	c3                   	ret    

80105127 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105127:	55                   	push   %ebp
80105128:	89 e5                	mov    %esp,%ebp
8010512a:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010512d:	9c                   	pushf  
8010512e:	58                   	pop    %eax
8010512f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105132:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105135:	c9                   	leave  
80105136:	c3                   	ret    

80105137 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80105137:	55                   	push   %ebp
80105138:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010513a:	fa                   	cli    
}
8010513b:	90                   	nop
8010513c:	5d                   	pop    %ebp
8010513d:	c3                   	ret    

8010513e <sti>:

static inline void
sti(void)
{
8010513e:	55                   	push   %ebp
8010513f:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105141:	fb                   	sti    
}
80105142:	90                   	nop
80105143:	5d                   	pop    %ebp
80105144:	c3                   	ret    

80105145 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105145:	55                   	push   %ebp
80105146:	89 e5                	mov    %esp,%ebp
80105148:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010514b:	8b 55 08             	mov    0x8(%ebp),%edx
8010514e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105151:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105154:	f0 87 02             	lock xchg %eax,(%edx)
80105157:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010515a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010515d:	c9                   	leave  
8010515e:	c3                   	ret    

8010515f <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010515f:	55                   	push   %ebp
80105160:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105162:	8b 45 08             	mov    0x8(%ebp),%eax
80105165:	8b 55 0c             	mov    0xc(%ebp),%edx
80105168:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
8010516b:	8b 45 08             	mov    0x8(%ebp),%eax
8010516e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105174:	8b 45 08             	mov    0x8(%ebp),%eax
80105177:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010517e:	90                   	nop
8010517f:	5d                   	pop    %ebp
80105180:	c3                   	ret    

80105181 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105181:	55                   	push   %ebp
80105182:	89 e5                	mov    %esp,%ebp
80105184:	53                   	push   %ebx
80105185:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105188:	e8 5f 01 00 00       	call   801052ec <pushcli>
  if(holding(lk))
8010518d:	8b 45 08             	mov    0x8(%ebp),%eax
80105190:	83 ec 0c             	sub    $0xc,%esp
80105193:	50                   	push   %eax
80105194:	e8 22 01 00 00       	call   801052bb <holding>
80105199:	83 c4 10             	add    $0x10,%esp
8010519c:	85 c0                	test   %eax,%eax
8010519e:	74 0d                	je     801051ad <acquire+0x2c>
    panic("acquire");
801051a0:	83 ec 0c             	sub    $0xc,%esp
801051a3:	68 7a 8e 10 80       	push   $0x80108e7a
801051a8:	e8 f3 b3 ff ff       	call   801005a0 <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801051ad:	90                   	nop
801051ae:	8b 45 08             	mov    0x8(%ebp),%eax
801051b1:	83 ec 08             	sub    $0x8,%esp
801051b4:	6a 01                	push   $0x1
801051b6:	50                   	push   %eax
801051b7:	e8 89 ff ff ff       	call   80105145 <xchg>
801051bc:	83 c4 10             	add    $0x10,%esp
801051bf:	85 c0                	test   %eax,%eax
801051c1:	75 eb                	jne    801051ae <acquire+0x2d>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801051c3:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801051c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801051cb:	e8 8d f0 ff ff       	call   8010425d <mycpu>
801051d0:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
801051d3:	8b 45 08             	mov    0x8(%ebp),%eax
801051d6:	83 c0 0c             	add    $0xc,%eax
801051d9:	83 ec 08             	sub    $0x8,%esp
801051dc:	50                   	push   %eax
801051dd:	8d 45 08             	lea    0x8(%ebp),%eax
801051e0:	50                   	push   %eax
801051e1:	e8 5b 00 00 00       	call   80105241 <getcallerpcs>
801051e6:	83 c4 10             	add    $0x10,%esp
}
801051e9:	90                   	nop
801051ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051ed:	c9                   	leave  
801051ee:	c3                   	ret    

801051ef <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801051ef:	55                   	push   %ebp
801051f0:	89 e5                	mov    %esp,%ebp
801051f2:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801051f5:	83 ec 0c             	sub    $0xc,%esp
801051f8:	ff 75 08             	pushl  0x8(%ebp)
801051fb:	e8 bb 00 00 00       	call   801052bb <holding>
80105200:	83 c4 10             	add    $0x10,%esp
80105203:	85 c0                	test   %eax,%eax
80105205:	75 0d                	jne    80105214 <release+0x25>
    panic("release");
80105207:	83 ec 0c             	sub    $0xc,%esp
8010520a:	68 82 8e 10 80       	push   $0x80108e82
8010520f:	e8 8c b3 ff ff       	call   801005a0 <panic>

  lk->pcs[0] = 0;
80105214:	8b 45 08             	mov    0x8(%ebp),%eax
80105217:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010521e:	8b 45 08             	mov    0x8(%ebp),%eax
80105221:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80105228:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010522d:	8b 45 08             	mov    0x8(%ebp),%eax
80105230:	8b 55 08             	mov    0x8(%ebp),%edx
80105233:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80105239:	e8 fc 00 00 00       	call   8010533a <popcli>
}
8010523e:	90                   	nop
8010523f:	c9                   	leave  
80105240:	c3                   	ret    

80105241 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105241:	55                   	push   %ebp
80105242:	89 e5                	mov    %esp,%ebp
80105244:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80105247:	8b 45 08             	mov    0x8(%ebp),%eax
8010524a:	83 e8 08             	sub    $0x8,%eax
8010524d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105250:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105257:	eb 38                	jmp    80105291 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105259:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010525d:	74 53                	je     801052b2 <getcallerpcs+0x71>
8010525f:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105266:	76 4a                	jbe    801052b2 <getcallerpcs+0x71>
80105268:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
8010526c:	74 44                	je     801052b2 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010526e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105271:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105278:	8b 45 0c             	mov    0xc(%ebp),%eax
8010527b:	01 c2                	add    %eax,%edx
8010527d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105280:	8b 40 04             	mov    0x4(%eax),%eax
80105283:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105285:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105288:	8b 00                	mov    (%eax),%eax
8010528a:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010528d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105291:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105295:	7e c2                	jle    80105259 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105297:	eb 19                	jmp    801052b2 <getcallerpcs+0x71>
    pcs[i] = 0;
80105299:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010529c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801052a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801052a6:	01 d0                	add    %edx,%eax
801052a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801052ae:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801052b2:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801052b6:	7e e1                	jle    80105299 <getcallerpcs+0x58>
    pcs[i] = 0;
}
801052b8:	90                   	nop
801052b9:	c9                   	leave  
801052ba:	c3                   	ret    

801052bb <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801052bb:	55                   	push   %ebp
801052bc:	89 e5                	mov    %esp,%ebp
801052be:	53                   	push   %ebx
801052bf:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
801052c2:	8b 45 08             	mov    0x8(%ebp),%eax
801052c5:	8b 00                	mov    (%eax),%eax
801052c7:	85 c0                	test   %eax,%eax
801052c9:	74 16                	je     801052e1 <holding+0x26>
801052cb:	8b 45 08             	mov    0x8(%ebp),%eax
801052ce:	8b 58 08             	mov    0x8(%eax),%ebx
801052d1:	e8 87 ef ff ff       	call   8010425d <mycpu>
801052d6:	39 c3                	cmp    %eax,%ebx
801052d8:	75 07                	jne    801052e1 <holding+0x26>
801052da:	b8 01 00 00 00       	mov    $0x1,%eax
801052df:	eb 05                	jmp    801052e6 <holding+0x2b>
801052e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801052e6:	83 c4 04             	add    $0x4,%esp
801052e9:	5b                   	pop    %ebx
801052ea:	5d                   	pop    %ebp
801052eb:	c3                   	ret    

801052ec <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801052ec:	55                   	push   %ebp
801052ed:	89 e5                	mov    %esp,%ebp
801052ef:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
801052f2:	e8 30 fe ff ff       	call   80105127 <readeflags>
801052f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
801052fa:	e8 38 fe ff ff       	call   80105137 <cli>
  if(mycpu()->ncli == 0)
801052ff:	e8 59 ef ff ff       	call   8010425d <mycpu>
80105304:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
8010530a:	85 c0                	test   %eax,%eax
8010530c:	75 15                	jne    80105323 <pushcli+0x37>
    mycpu()->intena = eflags & FL_IF;
8010530e:	e8 4a ef ff ff       	call   8010425d <mycpu>
80105313:	89 c2                	mov    %eax,%edx
80105315:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105318:	25 00 02 00 00       	and    $0x200,%eax
8010531d:	89 82 a8 00 00 00    	mov    %eax,0xa8(%edx)
  mycpu()->ncli += 1;
80105323:	e8 35 ef ff ff       	call   8010425d <mycpu>
80105328:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010532e:	83 c2 01             	add    $0x1,%edx
80105331:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80105337:	90                   	nop
80105338:	c9                   	leave  
80105339:	c3                   	ret    

8010533a <popcli>:

void
popcli(void)
{
8010533a:	55                   	push   %ebp
8010533b:	89 e5                	mov    %esp,%ebp
8010533d:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80105340:	e8 e2 fd ff ff       	call   80105127 <readeflags>
80105345:	25 00 02 00 00       	and    $0x200,%eax
8010534a:	85 c0                	test   %eax,%eax
8010534c:	74 0d                	je     8010535b <popcli+0x21>
    panic("popcli - interruptible");
8010534e:	83 ec 0c             	sub    $0xc,%esp
80105351:	68 8a 8e 10 80       	push   $0x80108e8a
80105356:	e8 45 b2 ff ff       	call   801005a0 <panic>
  if(--mycpu()->ncli < 0)
8010535b:	e8 fd ee ff ff       	call   8010425d <mycpu>
80105360:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105366:	83 ea 01             	sub    $0x1,%edx
80105369:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
8010536f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105375:	85 c0                	test   %eax,%eax
80105377:	79 0d                	jns    80105386 <popcli+0x4c>
    panic("popcli");
80105379:	83 ec 0c             	sub    $0xc,%esp
8010537c:	68 a1 8e 10 80       	push   $0x80108ea1
80105381:	e8 1a b2 ff ff       	call   801005a0 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105386:	e8 d2 ee ff ff       	call   8010425d <mycpu>
8010538b:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105391:	85 c0                	test   %eax,%eax
80105393:	75 14                	jne    801053a9 <popcli+0x6f>
80105395:	e8 c3 ee ff ff       	call   8010425d <mycpu>
8010539a:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801053a0:	85 c0                	test   %eax,%eax
801053a2:	74 05                	je     801053a9 <popcli+0x6f>
    sti();
801053a4:	e8 95 fd ff ff       	call   8010513e <sti>
}
801053a9:	90                   	nop
801053aa:	c9                   	leave  
801053ab:	c3                   	ret    

801053ac <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
801053ac:	55                   	push   %ebp
801053ad:	89 e5                	mov    %esp,%ebp
801053af:	57                   	push   %edi
801053b0:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801053b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
801053b4:	8b 55 10             	mov    0x10(%ebp),%edx
801053b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801053ba:	89 cb                	mov    %ecx,%ebx
801053bc:	89 df                	mov    %ebx,%edi
801053be:	89 d1                	mov    %edx,%ecx
801053c0:	fc                   	cld    
801053c1:	f3 aa                	rep stos %al,%es:(%edi)
801053c3:	89 ca                	mov    %ecx,%edx
801053c5:	89 fb                	mov    %edi,%ebx
801053c7:	89 5d 08             	mov    %ebx,0x8(%ebp)
801053ca:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801053cd:	90                   	nop
801053ce:	5b                   	pop    %ebx
801053cf:	5f                   	pop    %edi
801053d0:	5d                   	pop    %ebp
801053d1:	c3                   	ret    

801053d2 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801053d2:	55                   	push   %ebp
801053d3:	89 e5                	mov    %esp,%ebp
801053d5:	57                   	push   %edi
801053d6:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801053d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801053da:	8b 55 10             	mov    0x10(%ebp),%edx
801053dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801053e0:	89 cb                	mov    %ecx,%ebx
801053e2:	89 df                	mov    %ebx,%edi
801053e4:	89 d1                	mov    %edx,%ecx
801053e6:	fc                   	cld    
801053e7:	f3 ab                	rep stos %eax,%es:(%edi)
801053e9:	89 ca                	mov    %ecx,%edx
801053eb:	89 fb                	mov    %edi,%ebx
801053ed:	89 5d 08             	mov    %ebx,0x8(%ebp)
801053f0:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801053f3:	90                   	nop
801053f4:	5b                   	pop    %ebx
801053f5:	5f                   	pop    %edi
801053f6:	5d                   	pop    %ebp
801053f7:	c3                   	ret    

801053f8 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801053f8:	55                   	push   %ebp
801053f9:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
801053fb:	8b 45 08             	mov    0x8(%ebp),%eax
801053fe:	83 e0 03             	and    $0x3,%eax
80105401:	85 c0                	test   %eax,%eax
80105403:	75 43                	jne    80105448 <memset+0x50>
80105405:	8b 45 10             	mov    0x10(%ebp),%eax
80105408:	83 e0 03             	and    $0x3,%eax
8010540b:	85 c0                	test   %eax,%eax
8010540d:	75 39                	jne    80105448 <memset+0x50>
    c &= 0xFF;
8010540f:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105416:	8b 45 10             	mov    0x10(%ebp),%eax
80105419:	c1 e8 02             	shr    $0x2,%eax
8010541c:	89 c1                	mov    %eax,%ecx
8010541e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105421:	c1 e0 18             	shl    $0x18,%eax
80105424:	89 c2                	mov    %eax,%edx
80105426:	8b 45 0c             	mov    0xc(%ebp),%eax
80105429:	c1 e0 10             	shl    $0x10,%eax
8010542c:	09 c2                	or     %eax,%edx
8010542e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105431:	c1 e0 08             	shl    $0x8,%eax
80105434:	09 d0                	or     %edx,%eax
80105436:	0b 45 0c             	or     0xc(%ebp),%eax
80105439:	51                   	push   %ecx
8010543a:	50                   	push   %eax
8010543b:	ff 75 08             	pushl  0x8(%ebp)
8010543e:	e8 8f ff ff ff       	call   801053d2 <stosl>
80105443:	83 c4 0c             	add    $0xc,%esp
80105446:	eb 12                	jmp    8010545a <memset+0x62>
  } else
    stosb(dst, c, n);
80105448:	8b 45 10             	mov    0x10(%ebp),%eax
8010544b:	50                   	push   %eax
8010544c:	ff 75 0c             	pushl  0xc(%ebp)
8010544f:	ff 75 08             	pushl  0x8(%ebp)
80105452:	e8 55 ff ff ff       	call   801053ac <stosb>
80105457:	83 c4 0c             	add    $0xc,%esp
  return dst;
8010545a:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010545d:	c9                   	leave  
8010545e:	c3                   	ret    

8010545f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
8010545f:	55                   	push   %ebp
80105460:	89 e5                	mov    %esp,%ebp
80105462:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
80105465:	8b 45 08             	mov    0x8(%ebp),%eax
80105468:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
8010546b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010546e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105471:	eb 30                	jmp    801054a3 <memcmp+0x44>
    if(*s1 != *s2)
80105473:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105476:	0f b6 10             	movzbl (%eax),%edx
80105479:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010547c:	0f b6 00             	movzbl (%eax),%eax
8010547f:	38 c2                	cmp    %al,%dl
80105481:	74 18                	je     8010549b <memcmp+0x3c>
      return *s1 - *s2;
80105483:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105486:	0f b6 00             	movzbl (%eax),%eax
80105489:	0f b6 d0             	movzbl %al,%edx
8010548c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010548f:	0f b6 00             	movzbl (%eax),%eax
80105492:	0f b6 c0             	movzbl %al,%eax
80105495:	29 c2                	sub    %eax,%edx
80105497:	89 d0                	mov    %edx,%eax
80105499:	eb 1a                	jmp    801054b5 <memcmp+0x56>
    s1++, s2++;
8010549b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010549f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801054a3:	8b 45 10             	mov    0x10(%ebp),%eax
801054a6:	8d 50 ff             	lea    -0x1(%eax),%edx
801054a9:	89 55 10             	mov    %edx,0x10(%ebp)
801054ac:	85 c0                	test   %eax,%eax
801054ae:	75 c3                	jne    80105473 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801054b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801054b5:	c9                   	leave  
801054b6:	c3                   	ret    

801054b7 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801054b7:	55                   	push   %ebp
801054b8:	89 e5                	mov    %esp,%ebp
801054ba:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801054bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801054c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801054c3:	8b 45 08             	mov    0x8(%ebp),%eax
801054c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801054c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054cc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801054cf:	73 54                	jae    80105525 <memmove+0x6e>
801054d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
801054d4:	8b 45 10             	mov    0x10(%ebp),%eax
801054d7:	01 d0                	add    %edx,%eax
801054d9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801054dc:	76 47                	jbe    80105525 <memmove+0x6e>
    s += n;
801054de:	8b 45 10             	mov    0x10(%ebp),%eax
801054e1:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801054e4:	8b 45 10             	mov    0x10(%ebp),%eax
801054e7:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801054ea:	eb 13                	jmp    801054ff <memmove+0x48>
      *--d = *--s;
801054ec:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801054f0:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801054f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054f7:	0f b6 10             	movzbl (%eax),%edx
801054fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054fd:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801054ff:	8b 45 10             	mov    0x10(%ebp),%eax
80105502:	8d 50 ff             	lea    -0x1(%eax),%edx
80105505:	89 55 10             	mov    %edx,0x10(%ebp)
80105508:	85 c0                	test   %eax,%eax
8010550a:	75 e0                	jne    801054ec <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010550c:	eb 24                	jmp    80105532 <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
8010550e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105511:	8d 50 01             	lea    0x1(%eax),%edx
80105514:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105517:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010551a:	8d 4a 01             	lea    0x1(%edx),%ecx
8010551d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105520:	0f b6 12             	movzbl (%edx),%edx
80105523:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105525:	8b 45 10             	mov    0x10(%ebp),%eax
80105528:	8d 50 ff             	lea    -0x1(%eax),%edx
8010552b:	89 55 10             	mov    %edx,0x10(%ebp)
8010552e:	85 c0                	test   %eax,%eax
80105530:	75 dc                	jne    8010550e <memmove+0x57>
      *d++ = *s++;

  return dst;
80105532:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105535:	c9                   	leave  
80105536:	c3                   	ret    

80105537 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105537:	55                   	push   %ebp
80105538:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
8010553a:	ff 75 10             	pushl  0x10(%ebp)
8010553d:	ff 75 0c             	pushl  0xc(%ebp)
80105540:	ff 75 08             	pushl  0x8(%ebp)
80105543:	e8 6f ff ff ff       	call   801054b7 <memmove>
80105548:	83 c4 0c             	add    $0xc,%esp
}
8010554b:	c9                   	leave  
8010554c:	c3                   	ret    

8010554d <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010554d:	55                   	push   %ebp
8010554e:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105550:	eb 0c                	jmp    8010555e <strncmp+0x11>
    n--, p++, q++;
80105552:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105556:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010555a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010555e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105562:	74 1a                	je     8010557e <strncmp+0x31>
80105564:	8b 45 08             	mov    0x8(%ebp),%eax
80105567:	0f b6 00             	movzbl (%eax),%eax
8010556a:	84 c0                	test   %al,%al
8010556c:	74 10                	je     8010557e <strncmp+0x31>
8010556e:	8b 45 08             	mov    0x8(%ebp),%eax
80105571:	0f b6 10             	movzbl (%eax),%edx
80105574:	8b 45 0c             	mov    0xc(%ebp),%eax
80105577:	0f b6 00             	movzbl (%eax),%eax
8010557a:	38 c2                	cmp    %al,%dl
8010557c:	74 d4                	je     80105552 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
8010557e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105582:	75 07                	jne    8010558b <strncmp+0x3e>
    return 0;
80105584:	b8 00 00 00 00       	mov    $0x0,%eax
80105589:	eb 16                	jmp    801055a1 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
8010558b:	8b 45 08             	mov    0x8(%ebp),%eax
8010558e:	0f b6 00             	movzbl (%eax),%eax
80105591:	0f b6 d0             	movzbl %al,%edx
80105594:	8b 45 0c             	mov    0xc(%ebp),%eax
80105597:	0f b6 00             	movzbl (%eax),%eax
8010559a:	0f b6 c0             	movzbl %al,%eax
8010559d:	29 c2                	sub    %eax,%edx
8010559f:	89 d0                	mov    %edx,%eax
}
801055a1:	5d                   	pop    %ebp
801055a2:	c3                   	ret    

801055a3 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801055a3:	55                   	push   %ebp
801055a4:	89 e5                	mov    %esp,%ebp
801055a6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
801055a9:	8b 45 08             	mov    0x8(%ebp),%eax
801055ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801055af:	90                   	nop
801055b0:	8b 45 10             	mov    0x10(%ebp),%eax
801055b3:	8d 50 ff             	lea    -0x1(%eax),%edx
801055b6:	89 55 10             	mov    %edx,0x10(%ebp)
801055b9:	85 c0                	test   %eax,%eax
801055bb:	7e 2c                	jle    801055e9 <strncpy+0x46>
801055bd:	8b 45 08             	mov    0x8(%ebp),%eax
801055c0:	8d 50 01             	lea    0x1(%eax),%edx
801055c3:	89 55 08             	mov    %edx,0x8(%ebp)
801055c6:	8b 55 0c             	mov    0xc(%ebp),%edx
801055c9:	8d 4a 01             	lea    0x1(%edx),%ecx
801055cc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801055cf:	0f b6 12             	movzbl (%edx),%edx
801055d2:	88 10                	mov    %dl,(%eax)
801055d4:	0f b6 00             	movzbl (%eax),%eax
801055d7:	84 c0                	test   %al,%al
801055d9:	75 d5                	jne    801055b0 <strncpy+0xd>
    ;
  while(n-- > 0)
801055db:	eb 0c                	jmp    801055e9 <strncpy+0x46>
    *s++ = 0;
801055dd:	8b 45 08             	mov    0x8(%ebp),%eax
801055e0:	8d 50 01             	lea    0x1(%eax),%edx
801055e3:	89 55 08             	mov    %edx,0x8(%ebp)
801055e6:	c6 00 00             	movb   $0x0,(%eax)
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801055e9:	8b 45 10             	mov    0x10(%ebp),%eax
801055ec:	8d 50 ff             	lea    -0x1(%eax),%edx
801055ef:	89 55 10             	mov    %edx,0x10(%ebp)
801055f2:	85 c0                	test   %eax,%eax
801055f4:	7f e7                	jg     801055dd <strncpy+0x3a>
    *s++ = 0;
  return os;
801055f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801055f9:	c9                   	leave  
801055fa:	c3                   	ret    

801055fb <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801055fb:	55                   	push   %ebp
801055fc:	89 e5                	mov    %esp,%ebp
801055fe:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80105601:	8b 45 08             	mov    0x8(%ebp),%eax
80105604:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105607:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010560b:	7f 05                	jg     80105612 <safestrcpy+0x17>
    return os;
8010560d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105610:	eb 31                	jmp    80105643 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105612:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105616:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010561a:	7e 1e                	jle    8010563a <safestrcpy+0x3f>
8010561c:	8b 45 08             	mov    0x8(%ebp),%eax
8010561f:	8d 50 01             	lea    0x1(%eax),%edx
80105622:	89 55 08             	mov    %edx,0x8(%ebp)
80105625:	8b 55 0c             	mov    0xc(%ebp),%edx
80105628:	8d 4a 01             	lea    0x1(%edx),%ecx
8010562b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010562e:	0f b6 12             	movzbl (%edx),%edx
80105631:	88 10                	mov    %dl,(%eax)
80105633:	0f b6 00             	movzbl (%eax),%eax
80105636:	84 c0                	test   %al,%al
80105638:	75 d8                	jne    80105612 <safestrcpy+0x17>
    ;
  *s = 0;
8010563a:	8b 45 08             	mov    0x8(%ebp),%eax
8010563d:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105640:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105643:	c9                   	leave  
80105644:	c3                   	ret    

80105645 <strlen>:

int
strlen(const char *s)
{
80105645:	55                   	push   %ebp
80105646:	89 e5                	mov    %esp,%ebp
80105648:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
8010564b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105652:	eb 04                	jmp    80105658 <strlen+0x13>
80105654:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105658:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010565b:	8b 45 08             	mov    0x8(%ebp),%eax
8010565e:	01 d0                	add    %edx,%eax
80105660:	0f b6 00             	movzbl (%eax),%eax
80105663:	84 c0                	test   %al,%al
80105665:	75 ed                	jne    80105654 <strlen+0xf>
    ;
  return n;
80105667:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010566a:	c9                   	leave  
8010566b:	c3                   	ret    

8010566c <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010566c:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105670:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105674:	55                   	push   %ebp
  pushl %ebx
80105675:	53                   	push   %ebx
  pushl %esi
80105676:	56                   	push   %esi
  pushl %edi
80105677:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105678:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
8010567a:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010567c:	5f                   	pop    %edi
  popl %esi
8010567d:	5e                   	pop    %esi
  popl %ebx
8010567e:	5b                   	pop    %ebx
  popl %ebp
8010567f:	5d                   	pop    %ebp
  ret
80105680:	c3                   	ret    

80105681 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105681:	55                   	push   %ebp
80105682:	89 e5                	mov    %esp,%ebp
80105684:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80105687:	e8 49 ec ff ff       	call   801042d5 <myproc>
8010568c:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010568f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105692:	8b 00                	mov    (%eax),%eax
80105694:	3b 45 08             	cmp    0x8(%ebp),%eax
80105697:	76 0f                	jbe    801056a8 <fetchint+0x27>
80105699:	8b 45 08             	mov    0x8(%ebp),%eax
8010569c:	8d 50 04             	lea    0x4(%eax),%edx
8010569f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056a2:	8b 00                	mov    (%eax),%eax
801056a4:	39 c2                	cmp    %eax,%edx
801056a6:	76 07                	jbe    801056af <fetchint+0x2e>
    return -1;
801056a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ad:	eb 0f                	jmp    801056be <fetchint+0x3d>
  *ip = *(int*)(addr);
801056af:	8b 45 08             	mov    0x8(%ebp),%eax
801056b2:	8b 10                	mov    (%eax),%edx
801056b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801056b7:	89 10                	mov    %edx,(%eax)
  return 0;
801056b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056be:	c9                   	leave  
801056bf:	c3                   	ret    

801056c0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
801056c6:	e8 0a ec ff ff       	call   801042d5 <myproc>
801056cb:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
801056ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056d1:	8b 00                	mov    (%eax),%eax
801056d3:	3b 45 08             	cmp    0x8(%ebp),%eax
801056d6:	77 07                	ja     801056df <fetchstr+0x1f>
    return -1;
801056d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056dd:	eb 43                	jmp    80105722 <fetchstr+0x62>
  *pp = (char*)addr;
801056df:	8b 55 08             	mov    0x8(%ebp),%edx
801056e2:	8b 45 0c             	mov    0xc(%ebp),%eax
801056e5:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
801056e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056ea:	8b 00                	mov    (%eax),%eax
801056ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
801056ef:	8b 45 0c             	mov    0xc(%ebp),%eax
801056f2:	8b 00                	mov    (%eax),%eax
801056f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801056f7:	eb 1c                	jmp    80105715 <fetchstr+0x55>
    if(*s == 0)
801056f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056fc:	0f b6 00             	movzbl (%eax),%eax
801056ff:	84 c0                	test   %al,%al
80105701:	75 0e                	jne    80105711 <fetchstr+0x51>
      return s - *pp;
80105703:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105706:	8b 45 0c             	mov    0xc(%ebp),%eax
80105709:	8b 00                	mov    (%eax),%eax
8010570b:	29 c2                	sub    %eax,%edx
8010570d:	89 d0                	mov    %edx,%eax
8010570f:	eb 11                	jmp    80105722 <fetchstr+0x62>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80105711:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105715:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105718:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010571b:	72 dc                	jb     801056f9 <fetchstr+0x39>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
8010571d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105722:	c9                   	leave  
80105723:	c3                   	ret    

80105724 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105724:	55                   	push   %ebp
80105725:	89 e5                	mov    %esp,%ebp
80105727:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010572a:	e8 a6 eb ff ff       	call   801042d5 <myproc>
8010572f:	8b 40 18             	mov    0x18(%eax),%eax
80105732:	8b 40 44             	mov    0x44(%eax),%eax
80105735:	8b 55 08             	mov    0x8(%ebp),%edx
80105738:	c1 e2 02             	shl    $0x2,%edx
8010573b:	01 d0                	add    %edx,%eax
8010573d:	83 c0 04             	add    $0x4,%eax
80105740:	83 ec 08             	sub    $0x8,%esp
80105743:	ff 75 0c             	pushl  0xc(%ebp)
80105746:	50                   	push   %eax
80105747:	e8 35 ff ff ff       	call   80105681 <fetchint>
8010574c:	83 c4 10             	add    $0x10,%esp
}
8010574f:	c9                   	leave  
80105750:	c3                   	ret    

80105751 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105751:	55                   	push   %ebp
80105752:	89 e5                	mov    %esp,%ebp
80105754:	83 ec 18             	sub    $0x18,%esp
  int i;
  struct proc *curproc = myproc();
80105757:	e8 79 eb ff ff       	call   801042d5 <myproc>
8010575c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
8010575f:	83 ec 08             	sub    $0x8,%esp
80105762:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105765:	50                   	push   %eax
80105766:	ff 75 08             	pushl  0x8(%ebp)
80105769:	e8 b6 ff ff ff       	call   80105724 <argint>
8010576e:	83 c4 10             	add    $0x10,%esp
80105771:	85 c0                	test   %eax,%eax
80105773:	79 07                	jns    8010577c <argptr+0x2b>
    return -1;
80105775:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010577a:	eb 3b                	jmp    801057b7 <argptr+0x66>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010577c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105780:	78 1f                	js     801057a1 <argptr+0x50>
80105782:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105785:	8b 00                	mov    (%eax),%eax
80105787:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010578a:	39 d0                	cmp    %edx,%eax
8010578c:	76 13                	jbe    801057a1 <argptr+0x50>
8010578e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105791:	89 c2                	mov    %eax,%edx
80105793:	8b 45 10             	mov    0x10(%ebp),%eax
80105796:	01 c2                	add    %eax,%edx
80105798:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010579b:	8b 00                	mov    (%eax),%eax
8010579d:	39 c2                	cmp    %eax,%edx
8010579f:	76 07                	jbe    801057a8 <argptr+0x57>
    return -1;
801057a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057a6:	eb 0f                	jmp    801057b7 <argptr+0x66>
  *pp = (char*)i;
801057a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057ab:	89 c2                	mov    %eax,%edx
801057ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801057b0:	89 10                	mov    %edx,(%eax)
  return 0;
801057b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801057b7:	c9                   	leave  
801057b8:	c3                   	ret    

801057b9 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801057b9:	55                   	push   %ebp
801057ba:	89 e5                	mov    %esp,%ebp
801057bc:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
801057bf:	83 ec 08             	sub    $0x8,%esp
801057c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057c5:	50                   	push   %eax
801057c6:	ff 75 08             	pushl  0x8(%ebp)
801057c9:	e8 56 ff ff ff       	call   80105724 <argint>
801057ce:	83 c4 10             	add    $0x10,%esp
801057d1:	85 c0                	test   %eax,%eax
801057d3:	79 07                	jns    801057dc <argstr+0x23>
    return -1;
801057d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057da:	eb 12                	jmp    801057ee <argstr+0x35>
  return fetchstr(addr, pp);
801057dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057df:	83 ec 08             	sub    $0x8,%esp
801057e2:	ff 75 0c             	pushl  0xc(%ebp)
801057e5:	50                   	push   %eax
801057e6:	e8 d5 fe ff ff       	call   801056c0 <fetchstr>
801057eb:	83 c4 10             	add    $0x10,%esp
}
801057ee:	c9                   	leave  
801057ef:	c3                   	ret    

801057f0 <syscall>:
[SYS_sigret] sys_sigret,
};

void
syscall(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	53                   	push   %ebx
801057f4:	83 ec 14             	sub    $0x14,%esp
  int num;
  struct proc *curproc = myproc();
801057f7:	e8 d9 ea ff ff       	call   801042d5 <myproc>
801057fc:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
801057ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105802:	8b 40 18             	mov    0x18(%eax),%eax
80105805:	8b 40 1c             	mov    0x1c(%eax),%eax
80105808:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010580b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010580f:	7e 2d                	jle    8010583e <syscall+0x4e>
80105811:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105814:	83 f8 18             	cmp    $0x18,%eax
80105817:	77 25                	ja     8010583e <syscall+0x4e>
80105819:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010581c:	8b 04 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%eax
80105823:	85 c0                	test   %eax,%eax
80105825:	74 17                	je     8010583e <syscall+0x4e>
    curproc->tf->eax = syscalls[num]();
80105827:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010582a:	8b 58 18             	mov    0x18(%eax),%ebx
8010582d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105830:	8b 04 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%eax
80105837:	ff d0                	call   *%eax
80105839:	89 43 1c             	mov    %eax,0x1c(%ebx)
8010583c:	eb 2b                	jmp    80105869 <syscall+0x79>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
8010583e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105841:	8d 50 6c             	lea    0x6c(%eax),%edx

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105844:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105847:	8b 40 10             	mov    0x10(%eax),%eax
8010584a:	ff 75 f0             	pushl  -0x10(%ebp)
8010584d:	52                   	push   %edx
8010584e:	50                   	push   %eax
8010584f:	68 a8 8e 10 80       	push   $0x80108ea8
80105854:	e8 a7 ab ff ff       	call   80100400 <cprintf>
80105859:	83 c4 10             	add    $0x10,%esp
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
8010585c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010585f:	8b 40 18             	mov    0x18(%eax),%eax
80105862:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105869:	90                   	nop
8010586a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010586d:	c9                   	leave  
8010586e:	c3                   	ret    

8010586f <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
8010586f:	55                   	push   %ebp
80105870:	89 e5                	mov    %esp,%ebp
80105872:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105875:	83 ec 08             	sub    $0x8,%esp
80105878:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010587b:	50                   	push   %eax
8010587c:	ff 75 08             	pushl  0x8(%ebp)
8010587f:	e8 a0 fe ff ff       	call   80105724 <argint>
80105884:	83 c4 10             	add    $0x10,%esp
80105887:	85 c0                	test   %eax,%eax
80105889:	79 07                	jns    80105892 <argfd+0x23>
    return -1;
8010588b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105890:	eb 51                	jmp    801058e3 <argfd+0x74>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105892:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105895:	85 c0                	test   %eax,%eax
80105897:	78 22                	js     801058bb <argfd+0x4c>
80105899:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010589c:	83 f8 0f             	cmp    $0xf,%eax
8010589f:	7f 1a                	jg     801058bb <argfd+0x4c>
801058a1:	e8 2f ea ff ff       	call   801042d5 <myproc>
801058a6:	89 c2                	mov    %eax,%edx
801058a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058ab:	83 c0 08             	add    $0x8,%eax
801058ae:	8b 44 82 08          	mov    0x8(%edx,%eax,4),%eax
801058b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801058b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058b9:	75 07                	jne    801058c2 <argfd+0x53>
    return -1;
801058bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058c0:	eb 21                	jmp    801058e3 <argfd+0x74>
  if(pfd)
801058c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801058c6:	74 08                	je     801058d0 <argfd+0x61>
    *pfd = fd;
801058c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801058cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801058ce:	89 10                	mov    %edx,(%eax)
  if(pf)
801058d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801058d4:	74 08                	je     801058de <argfd+0x6f>
    *pf = f;
801058d6:	8b 45 10             	mov    0x10(%ebp),%eax
801058d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058dc:	89 10                	mov    %edx,(%eax)
  return 0;
801058de:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058e3:	c9                   	leave  
801058e4:	c3                   	ret    

801058e5 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801058e5:	55                   	push   %ebp
801058e6:	89 e5                	mov    %esp,%ebp
801058e8:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
801058eb:	e8 e5 e9 ff ff       	call   801042d5 <myproc>
801058f0:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
801058f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801058fa:	eb 2a                	jmp    80105926 <fdalloc+0x41>
    if(curproc->ofile[fd] == 0){
801058fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105902:	83 c2 08             	add    $0x8,%edx
80105905:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105909:	85 c0                	test   %eax,%eax
8010590b:	75 15                	jne    80105922 <fdalloc+0x3d>
      curproc->ofile[fd] = f;
8010590d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105910:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105913:	8d 4a 08             	lea    0x8(%edx),%ecx
80105916:	8b 55 08             	mov    0x8(%ebp),%edx
80105919:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
8010591d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105920:	eb 0f                	jmp    80105931 <fdalloc+0x4c>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105922:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105926:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010592a:	7e d0                	jle    801058fc <fdalloc+0x17>
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
8010592c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105931:	c9                   	leave  
80105932:	c3                   	ret    

80105933 <sys_dup>:

int
sys_dup(void)
{
80105933:	55                   	push   %ebp
80105934:	89 e5                	mov    %esp,%ebp
80105936:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105939:	83 ec 04             	sub    $0x4,%esp
8010593c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010593f:	50                   	push   %eax
80105940:	6a 00                	push   $0x0
80105942:	6a 00                	push   $0x0
80105944:	e8 26 ff ff ff       	call   8010586f <argfd>
80105949:	83 c4 10             	add    $0x10,%esp
8010594c:	85 c0                	test   %eax,%eax
8010594e:	79 07                	jns    80105957 <sys_dup+0x24>
    return -1;
80105950:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105955:	eb 31                	jmp    80105988 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105957:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010595a:	83 ec 0c             	sub    $0xc,%esp
8010595d:	50                   	push   %eax
8010595e:	e8 82 ff ff ff       	call   801058e5 <fdalloc>
80105963:	83 c4 10             	add    $0x10,%esp
80105966:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105969:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010596d:	79 07                	jns    80105976 <sys_dup+0x43>
    return -1;
8010596f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105974:	eb 12                	jmp    80105988 <sys_dup+0x55>
  filedup(f);
80105976:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105979:	83 ec 0c             	sub    $0xc,%esp
8010597c:	50                   	push   %eax
8010597d:	e8 2b b7 ff ff       	call   801010ad <filedup>
80105982:	83 c4 10             	add    $0x10,%esp
  return fd;
80105985:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105988:	c9                   	leave  
80105989:	c3                   	ret    

8010598a <sys_read>:

int
sys_read(void)
{
8010598a:	55                   	push   %ebp
8010598b:	89 e5                	mov    %esp,%ebp
8010598d:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105990:	83 ec 04             	sub    $0x4,%esp
80105993:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105996:	50                   	push   %eax
80105997:	6a 00                	push   $0x0
80105999:	6a 00                	push   $0x0
8010599b:	e8 cf fe ff ff       	call   8010586f <argfd>
801059a0:	83 c4 10             	add    $0x10,%esp
801059a3:	85 c0                	test   %eax,%eax
801059a5:	78 2e                	js     801059d5 <sys_read+0x4b>
801059a7:	83 ec 08             	sub    $0x8,%esp
801059aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059ad:	50                   	push   %eax
801059ae:	6a 02                	push   $0x2
801059b0:	e8 6f fd ff ff       	call   80105724 <argint>
801059b5:	83 c4 10             	add    $0x10,%esp
801059b8:	85 c0                	test   %eax,%eax
801059ba:	78 19                	js     801059d5 <sys_read+0x4b>
801059bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059bf:	83 ec 04             	sub    $0x4,%esp
801059c2:	50                   	push   %eax
801059c3:	8d 45 ec             	lea    -0x14(%ebp),%eax
801059c6:	50                   	push   %eax
801059c7:	6a 01                	push   $0x1
801059c9:	e8 83 fd ff ff       	call   80105751 <argptr>
801059ce:	83 c4 10             	add    $0x10,%esp
801059d1:	85 c0                	test   %eax,%eax
801059d3:	79 07                	jns    801059dc <sys_read+0x52>
    return -1;
801059d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059da:	eb 17                	jmp    801059f3 <sys_read+0x69>
  return fileread(f, p, n);
801059dc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801059df:	8b 55 ec             	mov    -0x14(%ebp),%edx
801059e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059e5:	83 ec 04             	sub    $0x4,%esp
801059e8:	51                   	push   %ecx
801059e9:	52                   	push   %edx
801059ea:	50                   	push   %eax
801059eb:	e8 4d b8 ff ff       	call   8010123d <fileread>
801059f0:	83 c4 10             	add    $0x10,%esp
}
801059f3:	c9                   	leave  
801059f4:	c3                   	ret    

801059f5 <sys_write>:

int
sys_write(void)
{
801059f5:	55                   	push   %ebp
801059f6:	89 e5                	mov    %esp,%ebp
801059f8:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801059fb:	83 ec 04             	sub    $0x4,%esp
801059fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a01:	50                   	push   %eax
80105a02:	6a 00                	push   $0x0
80105a04:	6a 00                	push   $0x0
80105a06:	e8 64 fe ff ff       	call   8010586f <argfd>
80105a0b:	83 c4 10             	add    $0x10,%esp
80105a0e:	85 c0                	test   %eax,%eax
80105a10:	78 2e                	js     80105a40 <sys_write+0x4b>
80105a12:	83 ec 08             	sub    $0x8,%esp
80105a15:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a18:	50                   	push   %eax
80105a19:	6a 02                	push   $0x2
80105a1b:	e8 04 fd ff ff       	call   80105724 <argint>
80105a20:	83 c4 10             	add    $0x10,%esp
80105a23:	85 c0                	test   %eax,%eax
80105a25:	78 19                	js     80105a40 <sys_write+0x4b>
80105a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a2a:	83 ec 04             	sub    $0x4,%esp
80105a2d:	50                   	push   %eax
80105a2e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a31:	50                   	push   %eax
80105a32:	6a 01                	push   $0x1
80105a34:	e8 18 fd ff ff       	call   80105751 <argptr>
80105a39:	83 c4 10             	add    $0x10,%esp
80105a3c:	85 c0                	test   %eax,%eax
80105a3e:	79 07                	jns    80105a47 <sys_write+0x52>
    return -1;
80105a40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a45:	eb 17                	jmp    80105a5e <sys_write+0x69>
  return filewrite(f, p, n);
80105a47:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105a4a:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a50:	83 ec 04             	sub    $0x4,%esp
80105a53:	51                   	push   %ecx
80105a54:	52                   	push   %edx
80105a55:	50                   	push   %eax
80105a56:	e8 9a b8 ff ff       	call   801012f5 <filewrite>
80105a5b:	83 c4 10             	add    $0x10,%esp
}
80105a5e:	c9                   	leave  
80105a5f:	c3                   	ret    

80105a60 <sys_close>:

int
sys_close(void)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105a66:	83 ec 04             	sub    $0x4,%esp
80105a69:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a6c:	50                   	push   %eax
80105a6d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a70:	50                   	push   %eax
80105a71:	6a 00                	push   $0x0
80105a73:	e8 f7 fd ff ff       	call   8010586f <argfd>
80105a78:	83 c4 10             	add    $0x10,%esp
80105a7b:	85 c0                	test   %eax,%eax
80105a7d:	79 07                	jns    80105a86 <sys_close+0x26>
    return -1;
80105a7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a84:	eb 29                	jmp    80105aaf <sys_close+0x4f>
  myproc()->ofile[fd] = 0;
80105a86:	e8 4a e8 ff ff       	call   801042d5 <myproc>
80105a8b:	89 c2                	mov    %eax,%edx
80105a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a90:	83 c0 08             	add    $0x8,%eax
80105a93:	c7 44 82 08 00 00 00 	movl   $0x0,0x8(%edx,%eax,4)
80105a9a:	00 
  fileclose(f);
80105a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a9e:	83 ec 0c             	sub    $0xc,%esp
80105aa1:	50                   	push   %eax
80105aa2:	e8 57 b6 ff ff       	call   801010fe <fileclose>
80105aa7:	83 c4 10             	add    $0x10,%esp
  return 0;
80105aaa:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105aaf:	c9                   	leave  
80105ab0:	c3                   	ret    

80105ab1 <sys_fstat>:

int
sys_fstat(void)
{
80105ab1:	55                   	push   %ebp
80105ab2:	89 e5                	mov    %esp,%ebp
80105ab4:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105ab7:	83 ec 04             	sub    $0x4,%esp
80105aba:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105abd:	50                   	push   %eax
80105abe:	6a 00                	push   $0x0
80105ac0:	6a 00                	push   $0x0
80105ac2:	e8 a8 fd ff ff       	call   8010586f <argfd>
80105ac7:	83 c4 10             	add    $0x10,%esp
80105aca:	85 c0                	test   %eax,%eax
80105acc:	78 17                	js     80105ae5 <sys_fstat+0x34>
80105ace:	83 ec 04             	sub    $0x4,%esp
80105ad1:	6a 14                	push   $0x14
80105ad3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ad6:	50                   	push   %eax
80105ad7:	6a 01                	push   $0x1
80105ad9:	e8 73 fc ff ff       	call   80105751 <argptr>
80105ade:	83 c4 10             	add    $0x10,%esp
80105ae1:	85 c0                	test   %eax,%eax
80105ae3:	79 07                	jns    80105aec <sys_fstat+0x3b>
    return -1;
80105ae5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aea:	eb 13                	jmp    80105aff <sys_fstat+0x4e>
  return filestat(f, st);
80105aec:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105af2:	83 ec 08             	sub    $0x8,%esp
80105af5:	52                   	push   %edx
80105af6:	50                   	push   %eax
80105af7:	e8 ea b6 ff ff       	call   801011e6 <filestat>
80105afc:	83 c4 10             	add    $0x10,%esp
}
80105aff:	c9                   	leave  
80105b00:	c3                   	ret    

80105b01 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105b01:	55                   	push   %ebp
80105b02:	89 e5                	mov    %esp,%ebp
80105b04:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105b07:	83 ec 08             	sub    $0x8,%esp
80105b0a:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105b0d:	50                   	push   %eax
80105b0e:	6a 00                	push   $0x0
80105b10:	e8 a4 fc ff ff       	call   801057b9 <argstr>
80105b15:	83 c4 10             	add    $0x10,%esp
80105b18:	85 c0                	test   %eax,%eax
80105b1a:	78 15                	js     80105b31 <sys_link+0x30>
80105b1c:	83 ec 08             	sub    $0x8,%esp
80105b1f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105b22:	50                   	push   %eax
80105b23:	6a 01                	push   $0x1
80105b25:	e8 8f fc ff ff       	call   801057b9 <argstr>
80105b2a:	83 c4 10             	add    $0x10,%esp
80105b2d:	85 c0                	test   %eax,%eax
80105b2f:	79 0a                	jns    80105b3b <sys_link+0x3a>
    return -1;
80105b31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b36:	e9 68 01 00 00       	jmp    80105ca3 <sys_link+0x1a2>

  begin_op();
80105b3b:	e8 42 da ff ff       	call   80103582 <begin_op>
  if((ip = namei(old)) == 0){
80105b40:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105b43:	83 ec 0c             	sub    $0xc,%esp
80105b46:	50                   	push   %eax
80105b47:	e8 51 ca ff ff       	call   8010259d <namei>
80105b4c:	83 c4 10             	add    $0x10,%esp
80105b4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b56:	75 0f                	jne    80105b67 <sys_link+0x66>
    end_op();
80105b58:	e8 b1 da ff ff       	call   8010360e <end_op>
    return -1;
80105b5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b62:	e9 3c 01 00 00       	jmp    80105ca3 <sys_link+0x1a2>
  }

  ilock(ip);
80105b67:	83 ec 0c             	sub    $0xc,%esp
80105b6a:	ff 75 f4             	pushl  -0xc(%ebp)
80105b6d:	e8 eb be ff ff       	call   80101a5d <ilock>
80105b72:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b78:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105b7c:	66 83 f8 01          	cmp    $0x1,%ax
80105b80:	75 1d                	jne    80105b9f <sys_link+0x9e>
    iunlockput(ip);
80105b82:	83 ec 0c             	sub    $0xc,%esp
80105b85:	ff 75 f4             	pushl  -0xc(%ebp)
80105b88:	e8 01 c1 ff ff       	call   80101c8e <iunlockput>
80105b8d:	83 c4 10             	add    $0x10,%esp
    end_op();
80105b90:	e8 79 da ff ff       	call   8010360e <end_op>
    return -1;
80105b95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b9a:	e9 04 01 00 00       	jmp    80105ca3 <sys_link+0x1a2>
  }

  ip->nlink++;
80105b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ba2:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105ba6:	83 c0 01             	add    $0x1,%eax
80105ba9:	89 c2                	mov    %eax,%edx
80105bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bae:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105bb2:	83 ec 0c             	sub    $0xc,%esp
80105bb5:	ff 75 f4             	pushl  -0xc(%ebp)
80105bb8:	e8 c3 bc ff ff       	call   80101880 <iupdate>
80105bbd:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105bc0:	83 ec 0c             	sub    $0xc,%esp
80105bc3:	ff 75 f4             	pushl  -0xc(%ebp)
80105bc6:	e8 a5 bf ff ff       	call   80101b70 <iunlock>
80105bcb:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105bce:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105bd1:	83 ec 08             	sub    $0x8,%esp
80105bd4:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105bd7:	52                   	push   %edx
80105bd8:	50                   	push   %eax
80105bd9:	e8 db c9 ff ff       	call   801025b9 <nameiparent>
80105bde:	83 c4 10             	add    $0x10,%esp
80105be1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105be4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105be8:	74 71                	je     80105c5b <sys_link+0x15a>
    goto bad;
  ilock(dp);
80105bea:	83 ec 0c             	sub    $0xc,%esp
80105bed:	ff 75 f0             	pushl  -0x10(%ebp)
80105bf0:	e8 68 be ff ff       	call   80101a5d <ilock>
80105bf5:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bfb:	8b 10                	mov    (%eax),%edx
80105bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c00:	8b 00                	mov    (%eax),%eax
80105c02:	39 c2                	cmp    %eax,%edx
80105c04:	75 1d                	jne    80105c23 <sys_link+0x122>
80105c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c09:	8b 40 04             	mov    0x4(%eax),%eax
80105c0c:	83 ec 04             	sub    $0x4,%esp
80105c0f:	50                   	push   %eax
80105c10:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105c13:	50                   	push   %eax
80105c14:	ff 75 f0             	pushl  -0x10(%ebp)
80105c17:	e8 e6 c6 ff ff       	call   80102302 <dirlink>
80105c1c:	83 c4 10             	add    $0x10,%esp
80105c1f:	85 c0                	test   %eax,%eax
80105c21:	79 10                	jns    80105c33 <sys_link+0x132>
    iunlockput(dp);
80105c23:	83 ec 0c             	sub    $0xc,%esp
80105c26:	ff 75 f0             	pushl  -0x10(%ebp)
80105c29:	e8 60 c0 ff ff       	call   80101c8e <iunlockput>
80105c2e:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105c31:	eb 29                	jmp    80105c5c <sys_link+0x15b>
  }
  iunlockput(dp);
80105c33:	83 ec 0c             	sub    $0xc,%esp
80105c36:	ff 75 f0             	pushl  -0x10(%ebp)
80105c39:	e8 50 c0 ff ff       	call   80101c8e <iunlockput>
80105c3e:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105c41:	83 ec 0c             	sub    $0xc,%esp
80105c44:	ff 75 f4             	pushl  -0xc(%ebp)
80105c47:	e8 72 bf ff ff       	call   80101bbe <iput>
80105c4c:	83 c4 10             	add    $0x10,%esp

  end_op();
80105c4f:	e8 ba d9 ff ff       	call   8010360e <end_op>

  return 0;
80105c54:	b8 00 00 00 00       	mov    $0x0,%eax
80105c59:	eb 48                	jmp    80105ca3 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105c5b:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80105c5c:	83 ec 0c             	sub    $0xc,%esp
80105c5f:	ff 75 f4             	pushl  -0xc(%ebp)
80105c62:	e8 f6 bd ff ff       	call   80101a5d <ilock>
80105c67:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c6d:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105c71:	83 e8 01             	sub    $0x1,%eax
80105c74:	89 c2                	mov    %eax,%edx
80105c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c79:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105c7d:	83 ec 0c             	sub    $0xc,%esp
80105c80:	ff 75 f4             	pushl  -0xc(%ebp)
80105c83:	e8 f8 bb ff ff       	call   80101880 <iupdate>
80105c88:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105c8b:	83 ec 0c             	sub    $0xc,%esp
80105c8e:	ff 75 f4             	pushl  -0xc(%ebp)
80105c91:	e8 f8 bf ff ff       	call   80101c8e <iunlockput>
80105c96:	83 c4 10             	add    $0x10,%esp
  end_op();
80105c99:	e8 70 d9 ff ff       	call   8010360e <end_op>
  return -1;
80105c9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ca3:	c9                   	leave  
80105ca4:	c3                   	ret    

80105ca5 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105ca5:	55                   	push   %ebp
80105ca6:	89 e5                	mov    %esp,%ebp
80105ca8:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105cab:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105cb2:	eb 40                	jmp    80105cf4 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cb7:	6a 10                	push   $0x10
80105cb9:	50                   	push   %eax
80105cba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105cbd:	50                   	push   %eax
80105cbe:	ff 75 08             	pushl  0x8(%ebp)
80105cc1:	e8 88 c2 ff ff       	call   80101f4e <readi>
80105cc6:	83 c4 10             	add    $0x10,%esp
80105cc9:	83 f8 10             	cmp    $0x10,%eax
80105ccc:	74 0d                	je     80105cdb <isdirempty+0x36>
      panic("isdirempty: readi");
80105cce:	83 ec 0c             	sub    $0xc,%esp
80105cd1:	68 c4 8e 10 80       	push   $0x80108ec4
80105cd6:	e8 c5 a8 ff ff       	call   801005a0 <panic>
    if(de.inum != 0)
80105cdb:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105cdf:	66 85 c0             	test   %ax,%ax
80105ce2:	74 07                	je     80105ceb <isdirempty+0x46>
      return 0;
80105ce4:	b8 00 00 00 00       	mov    $0x0,%eax
80105ce9:	eb 1b                	jmp    80105d06 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cee:	83 c0 10             	add    $0x10,%eax
80105cf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cf4:	8b 45 08             	mov    0x8(%ebp),%eax
80105cf7:	8b 50 58             	mov    0x58(%eax),%edx
80105cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cfd:	39 c2                	cmp    %eax,%edx
80105cff:	77 b3                	ja     80105cb4 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105d01:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105d06:	c9                   	leave  
80105d07:	c3                   	ret    

80105d08 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105d08:	55                   	push   %ebp
80105d09:	89 e5                	mov    %esp,%ebp
80105d0b:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105d0e:	83 ec 08             	sub    $0x8,%esp
80105d11:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105d14:	50                   	push   %eax
80105d15:	6a 00                	push   $0x0
80105d17:	e8 9d fa ff ff       	call   801057b9 <argstr>
80105d1c:	83 c4 10             	add    $0x10,%esp
80105d1f:	85 c0                	test   %eax,%eax
80105d21:	79 0a                	jns    80105d2d <sys_unlink+0x25>
    return -1;
80105d23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d28:	e9 bc 01 00 00       	jmp    80105ee9 <sys_unlink+0x1e1>

  begin_op();
80105d2d:	e8 50 d8 ff ff       	call   80103582 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105d32:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105d35:	83 ec 08             	sub    $0x8,%esp
80105d38:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105d3b:	52                   	push   %edx
80105d3c:	50                   	push   %eax
80105d3d:	e8 77 c8 ff ff       	call   801025b9 <nameiparent>
80105d42:	83 c4 10             	add    $0x10,%esp
80105d45:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d4c:	75 0f                	jne    80105d5d <sys_unlink+0x55>
    end_op();
80105d4e:	e8 bb d8 ff ff       	call   8010360e <end_op>
    return -1;
80105d53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d58:	e9 8c 01 00 00       	jmp    80105ee9 <sys_unlink+0x1e1>
  }

  ilock(dp);
80105d5d:	83 ec 0c             	sub    $0xc,%esp
80105d60:	ff 75 f4             	pushl  -0xc(%ebp)
80105d63:	e8 f5 bc ff ff       	call   80101a5d <ilock>
80105d68:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105d6b:	83 ec 08             	sub    $0x8,%esp
80105d6e:	68 d6 8e 10 80       	push   $0x80108ed6
80105d73:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105d76:	50                   	push   %eax
80105d77:	e8 b1 c4 ff ff       	call   8010222d <namecmp>
80105d7c:	83 c4 10             	add    $0x10,%esp
80105d7f:	85 c0                	test   %eax,%eax
80105d81:	0f 84 4a 01 00 00    	je     80105ed1 <sys_unlink+0x1c9>
80105d87:	83 ec 08             	sub    $0x8,%esp
80105d8a:	68 d8 8e 10 80       	push   $0x80108ed8
80105d8f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105d92:	50                   	push   %eax
80105d93:	e8 95 c4 ff ff       	call   8010222d <namecmp>
80105d98:	83 c4 10             	add    $0x10,%esp
80105d9b:	85 c0                	test   %eax,%eax
80105d9d:	0f 84 2e 01 00 00    	je     80105ed1 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105da3:	83 ec 04             	sub    $0x4,%esp
80105da6:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105da9:	50                   	push   %eax
80105daa:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105dad:	50                   	push   %eax
80105dae:	ff 75 f4             	pushl  -0xc(%ebp)
80105db1:	e8 92 c4 ff ff       	call   80102248 <dirlookup>
80105db6:	83 c4 10             	add    $0x10,%esp
80105db9:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105dbc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105dc0:	0f 84 0a 01 00 00    	je     80105ed0 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80105dc6:	83 ec 0c             	sub    $0xc,%esp
80105dc9:	ff 75 f0             	pushl  -0x10(%ebp)
80105dcc:	e8 8c bc ff ff       	call   80101a5d <ilock>
80105dd1:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105dd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dd7:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105ddb:	66 85 c0             	test   %ax,%ax
80105dde:	7f 0d                	jg     80105ded <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80105de0:	83 ec 0c             	sub    $0xc,%esp
80105de3:	68 db 8e 10 80       	push   $0x80108edb
80105de8:	e8 b3 a7 ff ff       	call   801005a0 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105df0:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105df4:	66 83 f8 01          	cmp    $0x1,%ax
80105df8:	75 25                	jne    80105e1f <sys_unlink+0x117>
80105dfa:	83 ec 0c             	sub    $0xc,%esp
80105dfd:	ff 75 f0             	pushl  -0x10(%ebp)
80105e00:	e8 a0 fe ff ff       	call   80105ca5 <isdirempty>
80105e05:	83 c4 10             	add    $0x10,%esp
80105e08:	85 c0                	test   %eax,%eax
80105e0a:	75 13                	jne    80105e1f <sys_unlink+0x117>
    iunlockput(ip);
80105e0c:	83 ec 0c             	sub    $0xc,%esp
80105e0f:	ff 75 f0             	pushl  -0x10(%ebp)
80105e12:	e8 77 be ff ff       	call   80101c8e <iunlockput>
80105e17:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105e1a:	e9 b2 00 00 00       	jmp    80105ed1 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80105e1f:	83 ec 04             	sub    $0x4,%esp
80105e22:	6a 10                	push   $0x10
80105e24:	6a 00                	push   $0x0
80105e26:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e29:	50                   	push   %eax
80105e2a:	e8 c9 f5 ff ff       	call   801053f8 <memset>
80105e2f:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105e32:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105e35:	6a 10                	push   $0x10
80105e37:	50                   	push   %eax
80105e38:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e3b:	50                   	push   %eax
80105e3c:	ff 75 f4             	pushl  -0xc(%ebp)
80105e3f:	e8 61 c2 ff ff       	call   801020a5 <writei>
80105e44:	83 c4 10             	add    $0x10,%esp
80105e47:	83 f8 10             	cmp    $0x10,%eax
80105e4a:	74 0d                	je     80105e59 <sys_unlink+0x151>
    panic("unlink: writei");
80105e4c:	83 ec 0c             	sub    $0xc,%esp
80105e4f:	68 ed 8e 10 80       	push   $0x80108eed
80105e54:	e8 47 a7 ff ff       	call   801005a0 <panic>
  if(ip->type == T_DIR){
80105e59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e5c:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105e60:	66 83 f8 01          	cmp    $0x1,%ax
80105e64:	75 21                	jne    80105e87 <sys_unlink+0x17f>
    dp->nlink--;
80105e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e69:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105e6d:	83 e8 01             	sub    $0x1,%eax
80105e70:	89 c2                	mov    %eax,%edx
80105e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e75:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105e79:	83 ec 0c             	sub    $0xc,%esp
80105e7c:	ff 75 f4             	pushl  -0xc(%ebp)
80105e7f:	e8 fc b9 ff ff       	call   80101880 <iupdate>
80105e84:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105e87:	83 ec 0c             	sub    $0xc,%esp
80105e8a:	ff 75 f4             	pushl  -0xc(%ebp)
80105e8d:	e8 fc bd ff ff       	call   80101c8e <iunlockput>
80105e92:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e98:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105e9c:	83 e8 01             	sub    $0x1,%eax
80105e9f:	89 c2                	mov    %eax,%edx
80105ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ea4:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105ea8:	83 ec 0c             	sub    $0xc,%esp
80105eab:	ff 75 f0             	pushl  -0x10(%ebp)
80105eae:	e8 cd b9 ff ff       	call   80101880 <iupdate>
80105eb3:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105eb6:	83 ec 0c             	sub    $0xc,%esp
80105eb9:	ff 75 f0             	pushl  -0x10(%ebp)
80105ebc:	e8 cd bd ff ff       	call   80101c8e <iunlockput>
80105ec1:	83 c4 10             	add    $0x10,%esp

  end_op();
80105ec4:	e8 45 d7 ff ff       	call   8010360e <end_op>

  return 0;
80105ec9:	b8 00 00 00 00       	mov    $0x0,%eax
80105ece:	eb 19                	jmp    80105ee9 <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80105ed0:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105ed1:	83 ec 0c             	sub    $0xc,%esp
80105ed4:	ff 75 f4             	pushl  -0xc(%ebp)
80105ed7:	e8 b2 bd ff ff       	call   80101c8e <iunlockput>
80105edc:	83 c4 10             	add    $0x10,%esp
  end_op();
80105edf:	e8 2a d7 ff ff       	call   8010360e <end_op>
  return -1;
80105ee4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ee9:	c9                   	leave  
80105eea:	c3                   	ret    

80105eeb <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105eeb:	55                   	push   %ebp
80105eec:	89 e5                	mov    %esp,%ebp
80105eee:	83 ec 38             	sub    $0x38,%esp
80105ef1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105ef4:	8b 55 10             	mov    0x10(%ebp),%edx
80105ef7:	8b 45 14             	mov    0x14(%ebp),%eax
80105efa:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105efe:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105f02:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105f06:	83 ec 08             	sub    $0x8,%esp
80105f09:	8d 45 de             	lea    -0x22(%ebp),%eax
80105f0c:	50                   	push   %eax
80105f0d:	ff 75 08             	pushl  0x8(%ebp)
80105f10:	e8 a4 c6 ff ff       	call   801025b9 <nameiparent>
80105f15:	83 c4 10             	add    $0x10,%esp
80105f18:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f1f:	75 0a                	jne    80105f2b <create+0x40>
    return 0;
80105f21:	b8 00 00 00 00       	mov    $0x0,%eax
80105f26:	e9 90 01 00 00       	jmp    801060bb <create+0x1d0>
  ilock(dp);
80105f2b:	83 ec 0c             	sub    $0xc,%esp
80105f2e:	ff 75 f4             	pushl  -0xc(%ebp)
80105f31:	e8 27 bb ff ff       	call   80101a5d <ilock>
80105f36:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80105f39:	83 ec 04             	sub    $0x4,%esp
80105f3c:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f3f:	50                   	push   %eax
80105f40:	8d 45 de             	lea    -0x22(%ebp),%eax
80105f43:	50                   	push   %eax
80105f44:	ff 75 f4             	pushl  -0xc(%ebp)
80105f47:	e8 fc c2 ff ff       	call   80102248 <dirlookup>
80105f4c:	83 c4 10             	add    $0x10,%esp
80105f4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f52:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f56:	74 50                	je     80105fa8 <create+0xbd>
    iunlockput(dp);
80105f58:	83 ec 0c             	sub    $0xc,%esp
80105f5b:	ff 75 f4             	pushl  -0xc(%ebp)
80105f5e:	e8 2b bd ff ff       	call   80101c8e <iunlockput>
80105f63:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105f66:	83 ec 0c             	sub    $0xc,%esp
80105f69:	ff 75 f0             	pushl  -0x10(%ebp)
80105f6c:	e8 ec ba ff ff       	call   80101a5d <ilock>
80105f71:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80105f74:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105f79:	75 15                	jne    80105f90 <create+0xa5>
80105f7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f7e:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105f82:	66 83 f8 02          	cmp    $0x2,%ax
80105f86:	75 08                	jne    80105f90 <create+0xa5>
      return ip;
80105f88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f8b:	e9 2b 01 00 00       	jmp    801060bb <create+0x1d0>
    iunlockput(ip);
80105f90:	83 ec 0c             	sub    $0xc,%esp
80105f93:	ff 75 f0             	pushl  -0x10(%ebp)
80105f96:	e8 f3 bc ff ff       	call   80101c8e <iunlockput>
80105f9b:	83 c4 10             	add    $0x10,%esp
    return 0;
80105f9e:	b8 00 00 00 00       	mov    $0x0,%eax
80105fa3:	e9 13 01 00 00       	jmp    801060bb <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105fa8:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105faf:	8b 00                	mov    (%eax),%eax
80105fb1:	83 ec 08             	sub    $0x8,%esp
80105fb4:	52                   	push   %edx
80105fb5:	50                   	push   %eax
80105fb6:	e8 ee b7 ff ff       	call   801017a9 <ialloc>
80105fbb:	83 c4 10             	add    $0x10,%esp
80105fbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105fc1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105fc5:	75 0d                	jne    80105fd4 <create+0xe9>
    panic("create: ialloc");
80105fc7:	83 ec 0c             	sub    $0xc,%esp
80105fca:	68 fc 8e 10 80       	push   $0x80108efc
80105fcf:	e8 cc a5 ff ff       	call   801005a0 <panic>

  ilock(ip);
80105fd4:	83 ec 0c             	sub    $0xc,%esp
80105fd7:	ff 75 f0             	pushl  -0x10(%ebp)
80105fda:	e8 7e ba ff ff       	call   80101a5d <ilock>
80105fdf:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105fe2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fe5:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105fe9:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
80105fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ff0:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105ff4:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
80105ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ffb:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80106001:	83 ec 0c             	sub    $0xc,%esp
80106004:	ff 75 f0             	pushl  -0x10(%ebp)
80106007:	e8 74 b8 ff ff       	call   80101880 <iupdate>
8010600c:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
8010600f:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106014:	75 6a                	jne    80106080 <create+0x195>
    dp->nlink++;  // for ".."
80106016:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106019:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010601d:	83 c0 01             	add    $0x1,%eax
80106020:	89 c2                	mov    %eax,%edx
80106022:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106025:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80106029:	83 ec 0c             	sub    $0xc,%esp
8010602c:	ff 75 f4             	pushl  -0xc(%ebp)
8010602f:	e8 4c b8 ff ff       	call   80101880 <iupdate>
80106034:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106037:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010603a:	8b 40 04             	mov    0x4(%eax),%eax
8010603d:	83 ec 04             	sub    $0x4,%esp
80106040:	50                   	push   %eax
80106041:	68 d6 8e 10 80       	push   $0x80108ed6
80106046:	ff 75 f0             	pushl  -0x10(%ebp)
80106049:	e8 b4 c2 ff ff       	call   80102302 <dirlink>
8010604e:	83 c4 10             	add    $0x10,%esp
80106051:	85 c0                	test   %eax,%eax
80106053:	78 1e                	js     80106073 <create+0x188>
80106055:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106058:	8b 40 04             	mov    0x4(%eax),%eax
8010605b:	83 ec 04             	sub    $0x4,%esp
8010605e:	50                   	push   %eax
8010605f:	68 d8 8e 10 80       	push   $0x80108ed8
80106064:	ff 75 f0             	pushl  -0x10(%ebp)
80106067:	e8 96 c2 ff ff       	call   80102302 <dirlink>
8010606c:	83 c4 10             	add    $0x10,%esp
8010606f:	85 c0                	test   %eax,%eax
80106071:	79 0d                	jns    80106080 <create+0x195>
      panic("create dots");
80106073:	83 ec 0c             	sub    $0xc,%esp
80106076:	68 0b 8f 10 80       	push   $0x80108f0b
8010607b:	e8 20 a5 ff ff       	call   801005a0 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106080:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106083:	8b 40 04             	mov    0x4(%eax),%eax
80106086:	83 ec 04             	sub    $0x4,%esp
80106089:	50                   	push   %eax
8010608a:	8d 45 de             	lea    -0x22(%ebp),%eax
8010608d:	50                   	push   %eax
8010608e:	ff 75 f4             	pushl  -0xc(%ebp)
80106091:	e8 6c c2 ff ff       	call   80102302 <dirlink>
80106096:	83 c4 10             	add    $0x10,%esp
80106099:	85 c0                	test   %eax,%eax
8010609b:	79 0d                	jns    801060aa <create+0x1bf>
    panic("create: dirlink");
8010609d:	83 ec 0c             	sub    $0xc,%esp
801060a0:	68 17 8f 10 80       	push   $0x80108f17
801060a5:	e8 f6 a4 ff ff       	call   801005a0 <panic>

  iunlockput(dp);
801060aa:	83 ec 0c             	sub    $0xc,%esp
801060ad:	ff 75 f4             	pushl  -0xc(%ebp)
801060b0:	e8 d9 bb ff ff       	call   80101c8e <iunlockput>
801060b5:	83 c4 10             	add    $0x10,%esp

  return ip;
801060b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801060bb:	c9                   	leave  
801060bc:	c3                   	ret    

801060bd <sys_open>:

int
sys_open(void)
{
801060bd:	55                   	push   %ebp
801060be:	89 e5                	mov    %esp,%ebp
801060c0:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801060c3:	83 ec 08             	sub    $0x8,%esp
801060c6:	8d 45 e8             	lea    -0x18(%ebp),%eax
801060c9:	50                   	push   %eax
801060ca:	6a 00                	push   $0x0
801060cc:	e8 e8 f6 ff ff       	call   801057b9 <argstr>
801060d1:	83 c4 10             	add    $0x10,%esp
801060d4:	85 c0                	test   %eax,%eax
801060d6:	78 15                	js     801060ed <sys_open+0x30>
801060d8:	83 ec 08             	sub    $0x8,%esp
801060db:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801060de:	50                   	push   %eax
801060df:	6a 01                	push   $0x1
801060e1:	e8 3e f6 ff ff       	call   80105724 <argint>
801060e6:	83 c4 10             	add    $0x10,%esp
801060e9:	85 c0                	test   %eax,%eax
801060eb:	79 0a                	jns    801060f7 <sys_open+0x3a>
    return -1;
801060ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060f2:	e9 61 01 00 00       	jmp    80106258 <sys_open+0x19b>

  begin_op();
801060f7:	e8 86 d4 ff ff       	call   80103582 <begin_op>

  if(omode & O_CREATE){
801060fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060ff:	25 00 02 00 00       	and    $0x200,%eax
80106104:	85 c0                	test   %eax,%eax
80106106:	74 2a                	je     80106132 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80106108:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010610b:	6a 00                	push   $0x0
8010610d:	6a 00                	push   $0x0
8010610f:	6a 02                	push   $0x2
80106111:	50                   	push   %eax
80106112:	e8 d4 fd ff ff       	call   80105eeb <create>
80106117:	83 c4 10             	add    $0x10,%esp
8010611a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010611d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106121:	75 75                	jne    80106198 <sys_open+0xdb>
      end_op();
80106123:	e8 e6 d4 ff ff       	call   8010360e <end_op>
      return -1;
80106128:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010612d:	e9 26 01 00 00       	jmp    80106258 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80106132:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106135:	83 ec 0c             	sub    $0xc,%esp
80106138:	50                   	push   %eax
80106139:	e8 5f c4 ff ff       	call   8010259d <namei>
8010613e:	83 c4 10             	add    $0x10,%esp
80106141:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106144:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106148:	75 0f                	jne    80106159 <sys_open+0x9c>
      end_op();
8010614a:	e8 bf d4 ff ff       	call   8010360e <end_op>
      return -1;
8010614f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106154:	e9 ff 00 00 00       	jmp    80106258 <sys_open+0x19b>
    }
    ilock(ip);
80106159:	83 ec 0c             	sub    $0xc,%esp
8010615c:	ff 75 f4             	pushl  -0xc(%ebp)
8010615f:	e8 f9 b8 ff ff       	call   80101a5d <ilock>
80106164:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80106167:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010616a:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010616e:	66 83 f8 01          	cmp    $0x1,%ax
80106172:	75 24                	jne    80106198 <sys_open+0xdb>
80106174:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106177:	85 c0                	test   %eax,%eax
80106179:	74 1d                	je     80106198 <sys_open+0xdb>
      iunlockput(ip);
8010617b:	83 ec 0c             	sub    $0xc,%esp
8010617e:	ff 75 f4             	pushl  -0xc(%ebp)
80106181:	e8 08 bb ff ff       	call   80101c8e <iunlockput>
80106186:	83 c4 10             	add    $0x10,%esp
      end_op();
80106189:	e8 80 d4 ff ff       	call   8010360e <end_op>
      return -1;
8010618e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106193:	e9 c0 00 00 00       	jmp    80106258 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106198:	e8 a3 ae ff ff       	call   80101040 <filealloc>
8010619d:	89 45 f0             	mov    %eax,-0x10(%ebp)
801061a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801061a4:	74 17                	je     801061bd <sys_open+0x100>
801061a6:	83 ec 0c             	sub    $0xc,%esp
801061a9:	ff 75 f0             	pushl  -0x10(%ebp)
801061ac:	e8 34 f7 ff ff       	call   801058e5 <fdalloc>
801061b1:	83 c4 10             	add    $0x10,%esp
801061b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801061b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801061bb:	79 2e                	jns    801061eb <sys_open+0x12e>
    if(f)
801061bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801061c1:	74 0e                	je     801061d1 <sys_open+0x114>
      fileclose(f);
801061c3:	83 ec 0c             	sub    $0xc,%esp
801061c6:	ff 75 f0             	pushl  -0x10(%ebp)
801061c9:	e8 30 af ff ff       	call   801010fe <fileclose>
801061ce:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801061d1:	83 ec 0c             	sub    $0xc,%esp
801061d4:	ff 75 f4             	pushl  -0xc(%ebp)
801061d7:	e8 b2 ba ff ff       	call   80101c8e <iunlockput>
801061dc:	83 c4 10             	add    $0x10,%esp
    end_op();
801061df:	e8 2a d4 ff ff       	call   8010360e <end_op>
    return -1;
801061e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061e9:	eb 6d                	jmp    80106258 <sys_open+0x19b>
  }
  iunlock(ip);
801061eb:	83 ec 0c             	sub    $0xc,%esp
801061ee:	ff 75 f4             	pushl  -0xc(%ebp)
801061f1:	e8 7a b9 ff ff       	call   80101b70 <iunlock>
801061f6:	83 c4 10             	add    $0x10,%esp
  end_op();
801061f9:	e8 10 d4 ff ff       	call   8010360e <end_op>

  f->type = FD_INODE;
801061fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106201:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106207:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010620a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010620d:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106210:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106213:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010621a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010621d:	83 e0 01             	and    $0x1,%eax
80106220:	85 c0                	test   %eax,%eax
80106222:	0f 94 c0             	sete   %al
80106225:	89 c2                	mov    %eax,%edx
80106227:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010622a:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010622d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106230:	83 e0 01             	and    $0x1,%eax
80106233:	85 c0                	test   %eax,%eax
80106235:	75 0a                	jne    80106241 <sys_open+0x184>
80106237:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010623a:	83 e0 02             	and    $0x2,%eax
8010623d:	85 c0                	test   %eax,%eax
8010623f:	74 07                	je     80106248 <sys_open+0x18b>
80106241:	b8 01 00 00 00       	mov    $0x1,%eax
80106246:	eb 05                	jmp    8010624d <sys_open+0x190>
80106248:	b8 00 00 00 00       	mov    $0x0,%eax
8010624d:	89 c2                	mov    %eax,%edx
8010624f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106252:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106255:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106258:	c9                   	leave  
80106259:	c3                   	ret    

8010625a <sys_mkdir>:

int
sys_mkdir(void)
{
8010625a:	55                   	push   %ebp
8010625b:	89 e5                	mov    %esp,%ebp
8010625d:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106260:	e8 1d d3 ff ff       	call   80103582 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106265:	83 ec 08             	sub    $0x8,%esp
80106268:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010626b:	50                   	push   %eax
8010626c:	6a 00                	push   $0x0
8010626e:	e8 46 f5 ff ff       	call   801057b9 <argstr>
80106273:	83 c4 10             	add    $0x10,%esp
80106276:	85 c0                	test   %eax,%eax
80106278:	78 1b                	js     80106295 <sys_mkdir+0x3b>
8010627a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010627d:	6a 00                	push   $0x0
8010627f:	6a 00                	push   $0x0
80106281:	6a 01                	push   $0x1
80106283:	50                   	push   %eax
80106284:	e8 62 fc ff ff       	call   80105eeb <create>
80106289:	83 c4 10             	add    $0x10,%esp
8010628c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010628f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106293:	75 0c                	jne    801062a1 <sys_mkdir+0x47>
    end_op();
80106295:	e8 74 d3 ff ff       	call   8010360e <end_op>
    return -1;
8010629a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010629f:	eb 18                	jmp    801062b9 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
801062a1:	83 ec 0c             	sub    $0xc,%esp
801062a4:	ff 75 f4             	pushl  -0xc(%ebp)
801062a7:	e8 e2 b9 ff ff       	call   80101c8e <iunlockput>
801062ac:	83 c4 10             	add    $0x10,%esp
  end_op();
801062af:	e8 5a d3 ff ff       	call   8010360e <end_op>
  return 0;
801062b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801062b9:	c9                   	leave  
801062ba:	c3                   	ret    

801062bb <sys_mknod>:

int
sys_mknod(void)
{
801062bb:	55                   	push   %ebp
801062bc:	89 e5                	mov    %esp,%ebp
801062be:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801062c1:	e8 bc d2 ff ff       	call   80103582 <begin_op>
  if((argstr(0, &path)) < 0 ||
801062c6:	83 ec 08             	sub    $0x8,%esp
801062c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801062cc:	50                   	push   %eax
801062cd:	6a 00                	push   $0x0
801062cf:	e8 e5 f4 ff ff       	call   801057b9 <argstr>
801062d4:	83 c4 10             	add    $0x10,%esp
801062d7:	85 c0                	test   %eax,%eax
801062d9:	78 4f                	js     8010632a <sys_mknod+0x6f>
     argint(1, &major) < 0 ||
801062db:	83 ec 08             	sub    $0x8,%esp
801062de:	8d 45 ec             	lea    -0x14(%ebp),%eax
801062e1:	50                   	push   %eax
801062e2:	6a 01                	push   $0x1
801062e4:	e8 3b f4 ff ff       	call   80105724 <argint>
801062e9:	83 c4 10             	add    $0x10,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801062ec:	85 c0                	test   %eax,%eax
801062ee:	78 3a                	js     8010632a <sys_mknod+0x6f>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801062f0:	83 ec 08             	sub    $0x8,%esp
801062f3:	8d 45 e8             	lea    -0x18(%ebp),%eax
801062f6:	50                   	push   %eax
801062f7:	6a 02                	push   $0x2
801062f9:	e8 26 f4 ff ff       	call   80105724 <argint>
801062fe:	83 c4 10             	add    $0x10,%esp
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106301:	85 c0                	test   %eax,%eax
80106303:	78 25                	js     8010632a <sys_mknod+0x6f>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106305:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106308:	0f bf c8             	movswl %ax,%ecx
8010630b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010630e:	0f bf d0             	movswl %ax,%edx
80106311:	8b 45 f0             	mov    -0x10(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106314:	51                   	push   %ecx
80106315:	52                   	push   %edx
80106316:	6a 03                	push   $0x3
80106318:	50                   	push   %eax
80106319:	e8 cd fb ff ff       	call   80105eeb <create>
8010631e:	83 c4 10             	add    $0x10,%esp
80106321:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106324:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106328:	75 0c                	jne    80106336 <sys_mknod+0x7b>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
8010632a:	e8 df d2 ff ff       	call   8010360e <end_op>
    return -1;
8010632f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106334:	eb 18                	jmp    8010634e <sys_mknod+0x93>
  }
  iunlockput(ip);
80106336:	83 ec 0c             	sub    $0xc,%esp
80106339:	ff 75 f4             	pushl  -0xc(%ebp)
8010633c:	e8 4d b9 ff ff       	call   80101c8e <iunlockput>
80106341:	83 c4 10             	add    $0x10,%esp
  end_op();
80106344:	e8 c5 d2 ff ff       	call   8010360e <end_op>
  return 0;
80106349:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010634e:	c9                   	leave  
8010634f:	c3                   	ret    

80106350 <sys_chdir>:

int
sys_chdir(void)
{
80106350:	55                   	push   %ebp
80106351:	89 e5                	mov    %esp,%ebp
80106353:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106356:	e8 7a df ff ff       	call   801042d5 <myproc>
8010635b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
8010635e:	e8 1f d2 ff ff       	call   80103582 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106363:	83 ec 08             	sub    $0x8,%esp
80106366:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106369:	50                   	push   %eax
8010636a:	6a 00                	push   $0x0
8010636c:	e8 48 f4 ff ff       	call   801057b9 <argstr>
80106371:	83 c4 10             	add    $0x10,%esp
80106374:	85 c0                	test   %eax,%eax
80106376:	78 18                	js     80106390 <sys_chdir+0x40>
80106378:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010637b:	83 ec 0c             	sub    $0xc,%esp
8010637e:	50                   	push   %eax
8010637f:	e8 19 c2 ff ff       	call   8010259d <namei>
80106384:	83 c4 10             	add    $0x10,%esp
80106387:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010638a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010638e:	75 0c                	jne    8010639c <sys_chdir+0x4c>
    end_op();
80106390:	e8 79 d2 ff ff       	call   8010360e <end_op>
    return -1;
80106395:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010639a:	eb 68                	jmp    80106404 <sys_chdir+0xb4>
  }
  ilock(ip);
8010639c:	83 ec 0c             	sub    $0xc,%esp
8010639f:	ff 75 f0             	pushl  -0x10(%ebp)
801063a2:	e8 b6 b6 ff ff       	call   80101a5d <ilock>
801063a7:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
801063aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063ad:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801063b1:	66 83 f8 01          	cmp    $0x1,%ax
801063b5:	74 1a                	je     801063d1 <sys_chdir+0x81>
    iunlockput(ip);
801063b7:	83 ec 0c             	sub    $0xc,%esp
801063ba:	ff 75 f0             	pushl  -0x10(%ebp)
801063bd:	e8 cc b8 ff ff       	call   80101c8e <iunlockput>
801063c2:	83 c4 10             	add    $0x10,%esp
    end_op();
801063c5:	e8 44 d2 ff ff       	call   8010360e <end_op>
    return -1;
801063ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063cf:	eb 33                	jmp    80106404 <sys_chdir+0xb4>
  }
  iunlock(ip);
801063d1:	83 ec 0c             	sub    $0xc,%esp
801063d4:	ff 75 f0             	pushl  -0x10(%ebp)
801063d7:	e8 94 b7 ff ff       	call   80101b70 <iunlock>
801063dc:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
801063df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063e2:	8b 40 68             	mov    0x68(%eax),%eax
801063e5:	83 ec 0c             	sub    $0xc,%esp
801063e8:	50                   	push   %eax
801063e9:	e8 d0 b7 ff ff       	call   80101bbe <iput>
801063ee:	83 c4 10             	add    $0x10,%esp
  end_op();
801063f1:	e8 18 d2 ff ff       	call   8010360e <end_op>
  curproc->cwd = ip;
801063f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801063fc:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801063ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106404:	c9                   	leave  
80106405:	c3                   	ret    

80106406 <sys_exec>:

int
sys_exec(void)
{
80106406:	55                   	push   %ebp
80106407:	89 e5                	mov    %esp,%ebp
80106409:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010640f:	83 ec 08             	sub    $0x8,%esp
80106412:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106415:	50                   	push   %eax
80106416:	6a 00                	push   $0x0
80106418:	e8 9c f3 ff ff       	call   801057b9 <argstr>
8010641d:	83 c4 10             	add    $0x10,%esp
80106420:	85 c0                	test   %eax,%eax
80106422:	78 18                	js     8010643c <sys_exec+0x36>
80106424:	83 ec 08             	sub    $0x8,%esp
80106427:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
8010642d:	50                   	push   %eax
8010642e:	6a 01                	push   $0x1
80106430:	e8 ef f2 ff ff       	call   80105724 <argint>
80106435:	83 c4 10             	add    $0x10,%esp
80106438:	85 c0                	test   %eax,%eax
8010643a:	79 0a                	jns    80106446 <sys_exec+0x40>
    return -1;
8010643c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106441:	e9 c6 00 00 00       	jmp    8010650c <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80106446:	83 ec 04             	sub    $0x4,%esp
80106449:	68 80 00 00 00       	push   $0x80
8010644e:	6a 00                	push   $0x0
80106450:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106456:	50                   	push   %eax
80106457:	e8 9c ef ff ff       	call   801053f8 <memset>
8010645c:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
8010645f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106466:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106469:	83 f8 1f             	cmp    $0x1f,%eax
8010646c:	76 0a                	jbe    80106478 <sys_exec+0x72>
      return -1;
8010646e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106473:	e9 94 00 00 00       	jmp    8010650c <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106478:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010647b:	c1 e0 02             	shl    $0x2,%eax
8010647e:	89 c2                	mov    %eax,%edx
80106480:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106486:	01 c2                	add    %eax,%edx
80106488:	83 ec 08             	sub    $0x8,%esp
8010648b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106491:	50                   	push   %eax
80106492:	52                   	push   %edx
80106493:	e8 e9 f1 ff ff       	call   80105681 <fetchint>
80106498:	83 c4 10             	add    $0x10,%esp
8010649b:	85 c0                	test   %eax,%eax
8010649d:	79 07                	jns    801064a6 <sys_exec+0xa0>
      return -1;
8010649f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064a4:	eb 66                	jmp    8010650c <sys_exec+0x106>
    if(uarg == 0){
801064a6:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801064ac:	85 c0                	test   %eax,%eax
801064ae:	75 27                	jne    801064d7 <sys_exec+0xd1>
      argv[i] = 0;
801064b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064b3:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801064ba:	00 00 00 00 
      break;
801064be:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801064bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064c2:	83 ec 08             	sub    $0x8,%esp
801064c5:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801064cb:	52                   	push   %edx
801064cc:	50                   	push   %eax
801064cd:	e8 c4 a6 ff ff       	call   80100b96 <exec>
801064d2:	83 c4 10             	add    $0x10,%esp
801064d5:	eb 35                	jmp    8010650c <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801064d7:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801064dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064e0:	c1 e2 02             	shl    $0x2,%edx
801064e3:	01 c2                	add    %eax,%edx
801064e5:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801064eb:	83 ec 08             	sub    $0x8,%esp
801064ee:	52                   	push   %edx
801064ef:	50                   	push   %eax
801064f0:	e8 cb f1 ff ff       	call   801056c0 <fetchstr>
801064f5:	83 c4 10             	add    $0x10,%esp
801064f8:	85 c0                	test   %eax,%eax
801064fa:	79 07                	jns    80106503 <sys_exec+0xfd>
      return -1;
801064fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106501:	eb 09                	jmp    8010650c <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106503:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106507:	e9 5a ff ff ff       	jmp    80106466 <sys_exec+0x60>
  return exec(path, argv);
}
8010650c:	c9                   	leave  
8010650d:	c3                   	ret    

8010650e <sys_pipe>:

int
sys_pipe(void)
{
8010650e:	55                   	push   %ebp
8010650f:	89 e5                	mov    %esp,%ebp
80106511:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106514:	83 ec 04             	sub    $0x4,%esp
80106517:	6a 08                	push   $0x8
80106519:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010651c:	50                   	push   %eax
8010651d:	6a 00                	push   $0x0
8010651f:	e8 2d f2 ff ff       	call   80105751 <argptr>
80106524:	83 c4 10             	add    $0x10,%esp
80106527:	85 c0                	test   %eax,%eax
80106529:	79 0a                	jns    80106535 <sys_pipe+0x27>
    return -1;
8010652b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106530:	e9 b0 00 00 00       	jmp    801065e5 <sys_pipe+0xd7>
  if(pipealloc(&rf, &wf) < 0)
80106535:	83 ec 08             	sub    $0x8,%esp
80106538:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010653b:	50                   	push   %eax
8010653c:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010653f:	50                   	push   %eax
80106540:	e8 c7 d8 ff ff       	call   80103e0c <pipealloc>
80106545:	83 c4 10             	add    $0x10,%esp
80106548:	85 c0                	test   %eax,%eax
8010654a:	79 0a                	jns    80106556 <sys_pipe+0x48>
    return -1;
8010654c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106551:	e9 8f 00 00 00       	jmp    801065e5 <sys_pipe+0xd7>
  fd0 = -1;
80106556:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010655d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106560:	83 ec 0c             	sub    $0xc,%esp
80106563:	50                   	push   %eax
80106564:	e8 7c f3 ff ff       	call   801058e5 <fdalloc>
80106569:	83 c4 10             	add    $0x10,%esp
8010656c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010656f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106573:	78 18                	js     8010658d <sys_pipe+0x7f>
80106575:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106578:	83 ec 0c             	sub    $0xc,%esp
8010657b:	50                   	push   %eax
8010657c:	e8 64 f3 ff ff       	call   801058e5 <fdalloc>
80106581:	83 c4 10             	add    $0x10,%esp
80106584:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106587:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010658b:	79 40                	jns    801065cd <sys_pipe+0xbf>
    if(fd0 >= 0)
8010658d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106591:	78 15                	js     801065a8 <sys_pipe+0x9a>
      myproc()->ofile[fd0] = 0;
80106593:	e8 3d dd ff ff       	call   801042d5 <myproc>
80106598:	89 c2                	mov    %eax,%edx
8010659a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010659d:	83 c0 08             	add    $0x8,%eax
801065a0:	c7 44 82 08 00 00 00 	movl   $0x0,0x8(%edx,%eax,4)
801065a7:	00 
    fileclose(rf);
801065a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801065ab:	83 ec 0c             	sub    $0xc,%esp
801065ae:	50                   	push   %eax
801065af:	e8 4a ab ff ff       	call   801010fe <fileclose>
801065b4:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
801065b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801065ba:	83 ec 0c             	sub    $0xc,%esp
801065bd:	50                   	push   %eax
801065be:	e8 3b ab ff ff       	call   801010fe <fileclose>
801065c3:	83 c4 10             	add    $0x10,%esp
    return -1;
801065c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065cb:	eb 18                	jmp    801065e5 <sys_pipe+0xd7>
  }
  fd[0] = fd0;
801065cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801065d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801065d3:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801065d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801065d8:	8d 50 04             	lea    0x4(%eax),%edx
801065db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065de:	89 02                	mov    %eax,(%edx)
  return 0;
801065e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801065e5:	c9                   	leave  
801065e6:	c3                   	ret    

801065e7 <sys_fork>:
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void) {
801065e7:	55                   	push   %ebp
801065e8:	89 e5                	mov    %esp,%ebp
801065ea:	83 ec 08             	sub    $0x8,%esp
    return fork();
801065ed:	e8 52 e0 ff ff       	call   80104644 <fork>
}
801065f2:	c9                   	leave  
801065f3:	c3                   	ret    

801065f4 <sys_exit>:

int
sys_exit(void) {
801065f4:	55                   	push   %ebp
801065f5:	89 e5                	mov    %esp,%ebp
801065f7:	83 ec 08             	sub    $0x8,%esp
    exit();
801065fa:	e8 11 e2 ff ff       	call   80104810 <exit>
    return 0;  // not reached
801065ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106604:	c9                   	leave  
80106605:	c3                   	ret    

80106606 <sys_wait>:

int
sys_wait(void) {
80106606:	55                   	push   %ebp
80106607:	89 e5                	mov    %esp,%ebp
80106609:	83 ec 08             	sub    $0x8,%esp
    return wait();
8010660c:	e8 22 e3 ff ff       	call   80104933 <wait>
}
80106611:	c9                   	leave  
80106612:	c3                   	ret    

80106613 <sys_kill>:

int
sys_kill(void) {
80106613:	55                   	push   %ebp
80106614:	89 e5                	mov    %esp,%ebp
80106616:	83 ec 18             	sub    $0x18,%esp
    int pid;
    int signum;
    if (argint(0, &pid) < 0 || argint(1, &signum) < 0)
80106619:	83 ec 08             	sub    $0x8,%esp
8010661c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010661f:	50                   	push   %eax
80106620:	6a 00                	push   $0x0
80106622:	e8 fd f0 ff ff       	call   80105724 <argint>
80106627:	83 c4 10             	add    $0x10,%esp
8010662a:	85 c0                	test   %eax,%eax
8010662c:	78 15                	js     80106643 <sys_kill+0x30>
8010662e:	83 ec 08             	sub    $0x8,%esp
80106631:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106634:	50                   	push   %eax
80106635:	6a 01                	push   $0x1
80106637:	e8 e8 f0 ff ff       	call   80105724 <argint>
8010663c:	83 c4 10             	add    $0x10,%esp
8010663f:	85 c0                	test   %eax,%eax
80106641:	79 07                	jns    8010664a <sys_kill+0x37>
        return -1;
80106643:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106648:	eb 13                	jmp    8010665d <sys_kill+0x4a>
    return kill(pid, signum);
8010664a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010664d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106650:	83 ec 08             	sub    $0x8,%esp
80106653:	52                   	push   %edx
80106654:	50                   	push   %eax
80106655:	e8 12 e7 ff ff       	call   80104d6c <kill>
8010665a:	83 c4 10             	add    $0x10,%esp
}
8010665d:	c9                   	leave  
8010665e:	c3                   	ret    

8010665f <sys_getpid>:

int
sys_getpid(void) {
8010665f:	55                   	push   %ebp
80106660:	89 e5                	mov    %esp,%ebp
80106662:	83 ec 08             	sub    $0x8,%esp
    return myproc()->pid;
80106665:	e8 6b dc ff ff       	call   801042d5 <myproc>
8010666a:	8b 40 10             	mov    0x10(%eax),%eax
}
8010666d:	c9                   	leave  
8010666e:	c3                   	ret    

8010666f <sys_sbrk>:

int
sys_sbrk(void) {
8010666f:	55                   	push   %ebp
80106670:	89 e5                	mov    %esp,%ebp
80106672:	83 ec 18             	sub    $0x18,%esp
    int addr;
    int n;

    if (argint(0, &n) < 0)
80106675:	83 ec 08             	sub    $0x8,%esp
80106678:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010667b:	50                   	push   %eax
8010667c:	6a 00                	push   $0x0
8010667e:	e8 a1 f0 ff ff       	call   80105724 <argint>
80106683:	83 c4 10             	add    $0x10,%esp
80106686:	85 c0                	test   %eax,%eax
80106688:	79 07                	jns    80106691 <sys_sbrk+0x22>
        return -1;
8010668a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010668f:	eb 27                	jmp    801066b8 <sys_sbrk+0x49>
    addr = myproc()->sz;
80106691:	e8 3f dc ff ff       	call   801042d5 <myproc>
80106696:	8b 00                	mov    (%eax),%eax
80106698:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (growproc(n) < 0)
8010669b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010669e:	83 ec 0c             	sub    $0xc,%esp
801066a1:	50                   	push   %eax
801066a2:	e8 02 df ff ff       	call   801045a9 <growproc>
801066a7:	83 c4 10             	add    $0x10,%esp
801066aa:	85 c0                	test   %eax,%eax
801066ac:	79 07                	jns    801066b5 <sys_sbrk+0x46>
        return -1;
801066ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066b3:	eb 03                	jmp    801066b8 <sys_sbrk+0x49>
    return addr;
801066b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801066b8:	c9                   	leave  
801066b9:	c3                   	ret    

801066ba <sys_sleep>:

int
sys_sleep(void) {
801066ba:	55                   	push   %ebp
801066bb:	89 e5                	mov    %esp,%ebp
801066bd:	83 ec 18             	sub    $0x18,%esp
    int n;
    uint ticks0;

    if (argint(0, &n) < 0)
801066c0:	83 ec 08             	sub    $0x8,%esp
801066c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801066c6:	50                   	push   %eax
801066c7:	6a 00                	push   $0x0
801066c9:	e8 56 f0 ff ff       	call   80105724 <argint>
801066ce:	83 c4 10             	add    $0x10,%esp
801066d1:	85 c0                	test   %eax,%eax
801066d3:	79 07                	jns    801066dc <sys_sleep+0x22>
        return -1;
801066d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066da:	eb 76                	jmp    80106752 <sys_sleep+0x98>
    acquire(&tickslock);
801066dc:	83 ec 0c             	sub    $0xc,%esp
801066df:	68 00 91 11 80       	push   $0x80119100
801066e4:	e8 98 ea ff ff       	call   80105181 <acquire>
801066e9:	83 c4 10             	add    $0x10,%esp
    ticks0 = ticks;
801066ec:	a1 40 99 11 80       	mov    0x80119940,%eax
801066f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (ticks - ticks0 < n) {
801066f4:	eb 38                	jmp    8010672e <sys_sleep+0x74>
        if (myproc()->killed) {
801066f6:	e8 da db ff ff       	call   801042d5 <myproc>
801066fb:	8b 40 24             	mov    0x24(%eax),%eax
801066fe:	85 c0                	test   %eax,%eax
80106700:	74 17                	je     80106719 <sys_sleep+0x5f>
            release(&tickslock);
80106702:	83 ec 0c             	sub    $0xc,%esp
80106705:	68 00 91 11 80       	push   $0x80119100
8010670a:	e8 e0 ea ff ff       	call   801051ef <release>
8010670f:	83 c4 10             	add    $0x10,%esp
            return -1;
80106712:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106717:	eb 39                	jmp    80106752 <sys_sleep+0x98>
        }
        sleep(&ticks, &tickslock);
80106719:	83 ec 08             	sub    $0x8,%esp
8010671c:	68 00 91 11 80       	push   $0x80119100
80106721:	68 40 99 11 80       	push   $0x80119940
80106726:	e8 21 e5 ff ff       	call   80104c4c <sleep>
8010672b:	83 c4 10             	add    $0x10,%esp

    if (argint(0, &n) < 0)
        return -1;
    acquire(&tickslock);
    ticks0 = ticks;
    while (ticks - ticks0 < n) {
8010672e:	a1 40 99 11 80       	mov    0x80119940,%eax
80106733:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106736:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106739:	39 d0                	cmp    %edx,%eax
8010673b:	72 b9                	jb     801066f6 <sys_sleep+0x3c>
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    }
    release(&tickslock);
8010673d:	83 ec 0c             	sub    $0xc,%esp
80106740:	68 00 91 11 80       	push   $0x80119100
80106745:	e8 a5 ea ff ff       	call   801051ef <release>
8010674a:	83 c4 10             	add    $0x10,%esp
    return 0;
8010674d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106752:	c9                   	leave  
80106753:	c3                   	ret    

80106754 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void) {
80106754:	55                   	push   %ebp
80106755:	89 e5                	mov    %esp,%ebp
80106757:	83 ec 18             	sub    $0x18,%esp
    uint xticks;

    acquire(&tickslock);
8010675a:	83 ec 0c             	sub    $0xc,%esp
8010675d:	68 00 91 11 80       	push   $0x80119100
80106762:	e8 1a ea ff ff       	call   80105181 <acquire>
80106767:	83 c4 10             	add    $0x10,%esp
    xticks = ticks;
8010676a:	a1 40 99 11 80       	mov    0x80119940,%eax
8010676f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&tickslock);
80106772:	83 ec 0c             	sub    $0xc,%esp
80106775:	68 00 91 11 80       	push   $0x80119100
8010677a:	e8 70 ea ff ff       	call   801051ef <release>
8010677f:	83 c4 10             	add    $0x10,%esp
    return xticks;
80106782:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106785:	c9                   	leave  
80106786:	c3                   	ret    

80106787 <sys_sigprocmask>:

//Task 2.1.3
int sys_sigprocmask(void) {
80106787:	55                   	push   %ebp
80106788:	89 e5                	mov    %esp,%ebp
8010678a:	83 ec 18             	sub    $0x18,%esp
    int sigmask;
    if (argint(0, &sigmask) < 0)
8010678d:	83 ec 08             	sub    $0x8,%esp
80106790:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106793:	50                   	push   %eax
80106794:	6a 00                	push   $0x0
80106796:	e8 89 ef ff ff       	call   80105724 <argint>
8010679b:	83 c4 10             	add    $0x10,%esp
8010679e:	85 c0                	test   %eax,%eax
801067a0:	79 07                	jns    801067a9 <sys_sigprocmask+0x22>
        return -1;
801067a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067a7:	eb 0f                	jmp    801067b8 <sys_sigprocmask+0x31>
    return sigprocmask((uint)sigmask);
801067a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067ac:	83 ec 0c             	sub    $0xc,%esp
801067af:	50                   	push   %eax
801067b0:	e8 47 e7 ff ff       	call   80104efc <sigprocmask>
801067b5:	83 c4 10             	add    $0x10,%esp
}
801067b8:	c9                   	leave  
801067b9:	c3                   	ret    

801067ba <sys_signal>:

//Task 2.1.4
int sys_signal(void) {
801067ba:	55                   	push   %ebp
801067bb:	89 e5                	mov    %esp,%ebp
801067bd:	83 ec 18             	sub    $0x18,%esp
    int signum;
    int handler=7;
801067c0:	c7 45 f0 07 00 00 00 	movl   $0x7,-0x10(%ebp)
    //TODO:make sure 'argint' is ok

    if (argint(0, &signum) < 0 || argint(1,  &handler) < 0)
801067c7:	83 ec 08             	sub    $0x8,%esp
801067ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
801067cd:	50                   	push   %eax
801067ce:	6a 00                	push   $0x0
801067d0:	e8 4f ef ff ff       	call   80105724 <argint>
801067d5:	83 c4 10             	add    $0x10,%esp
801067d8:	85 c0                	test   %eax,%eax
801067da:	78 15                	js     801067f1 <sys_signal+0x37>
801067dc:	83 ec 08             	sub    $0x8,%esp
801067df:	8d 45 f0             	lea    -0x10(%ebp),%eax
801067e2:	50                   	push   %eax
801067e3:	6a 01                	push   $0x1
801067e5:	e8 3a ef ff ff       	call   80105724 <argint>
801067ea:	83 c4 10             	add    $0x10,%esp
801067ed:	85 c0                	test   %eax,%eax
801067ef:	79 07                	jns    801067f8 <sys_signal+0x3e>
        return -1;
801067f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067f6:	eb 15                	jmp    8010680d <sys_signal+0x53>
    return (int)signal(signum, (sighandler_t)handler);
801067f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067fb:	89 c2                	mov    %eax,%edx
801067fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106800:	83 ec 08             	sub    $0x8,%esp
80106803:	52                   	push   %edx
80106804:	50                   	push   %eax
80106805:	e8 2a e7 ff ff       	call   80104f34 <signal>
8010680a:	83 c4 10             	add    $0x10,%esp
}
8010680d:	c9                   	leave  
8010680e:	c3                   	ret    

8010680f <sys_sigret>:

int sys_sigret(void) {
8010680f:	55                   	push   %ebp
80106810:	89 e5                	mov    %esp,%ebp
80106812:	83 ec 08             	sub    $0x8,%esp
    sigret();
80106815:	e8 a1 e7 ff ff       	call   80104fbb <sigret>
    return 1;
8010681a:	b8 01 00 00 00       	mov    $0x1,%eax

}
8010681f:	c9                   	leave  
80106820:	c3                   	ret    

80106821 <alltraps>:
.globl call_sigret_syscall
.globl end_sigret_syscall

alltraps:
  # Build trap frame.
  pushl %ds
80106821:	1e                   	push   %ds
  pushl %es
80106822:	06                   	push   %es
  pushl %fs
80106823:	0f a0                	push   %fs
  pushl %gs
80106825:	0f a8                	push   %gs
  pushal
80106827:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106828:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010682c:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010682e:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106830:	54                   	push   %esp
  call trap
80106831:	e8 e7 01 00 00       	call   80106a1d <trap>
  addl $4, %esp
80106836:	83 c4 04             	add    $0x4,%esp

80106839 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  pushl %esp    #
80106839:	54                   	push   %esp
  call check_kernel_sigs
8010683a:	e8 da 04 00 00       	call   80106d19 <check_kernel_sigs>
  addl $4, %esp #
8010683f:	83 c4 04             	add    $0x4,%esp
  popal
80106842:	61                   	popa   
  popl %gs
80106843:	0f a9                	pop    %gs
  popl %fs
80106845:	0f a1                	pop    %fs
  popl %es
80106847:	07                   	pop    %es
  popl %ds
80106848:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106849:	83 c4 08             	add    $0x8,%esp
  iret
8010684c:	cf                   	iret   

8010684d <call_sigret_syscall>:

call_sigret_syscall:
    movl $SYS_sigret, %eax
8010684d:	b8 18 00 00 00       	mov    $0x18,%eax
    int $T_SYSCALL
80106852:	cd 40                	int    $0x40

80106854 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106854:	55                   	push   %ebp
80106855:	89 e5                	mov    %esp,%ebp
80106857:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010685a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010685d:	83 e8 01             	sub    $0x1,%eax
80106860:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106864:	8b 45 08             	mov    0x8(%ebp),%eax
80106867:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010686b:	8b 45 08             	mov    0x8(%ebp),%eax
8010686e:	c1 e8 10             	shr    $0x10,%eax
80106871:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106875:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106878:	0f 01 18             	lidtl  (%eax)
}
8010687b:	90                   	nop
8010687c:	c9                   	leave  
8010687d:	c3                   	ret    

8010687e <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
8010687e:	55                   	push   %ebp
8010687f:	89 e5                	mov    %esp,%ebp
80106881:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106884:	0f 20 d0             	mov    %cr2,%eax
80106887:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
8010688a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010688d:	c9                   	leave  
8010688e:	c3                   	ret    

8010688f <tvinit>:

struct spinlock tickslock;
uint ticks;

void
tvinit(void) {
8010688f:	55                   	push   %ebp
80106890:	89 e5                	mov    %esp,%ebp
80106892:	83 ec 18             	sub    $0x18,%esp
    int i;

    for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80106895:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010689c:	e9 c3 00 00 00       	jmp    80106964 <tvinit+0xd5>
801068a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068a4:	8b 04 85 84 c0 10 80 	mov    -0x7fef3f7c(,%eax,4),%eax
801068ab:	89 c2                	mov    %eax,%edx
801068ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068b0:	66 89 14 c5 40 91 11 	mov    %dx,-0x7fee6ec0(,%eax,8)
801068b7:	80 
801068b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068bb:	66 c7 04 c5 42 91 11 	movw   $0x8,-0x7fee6ebe(,%eax,8)
801068c2:	80 08 00 
801068c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068c8:	0f b6 14 c5 44 91 11 	movzbl -0x7fee6ebc(,%eax,8),%edx
801068cf:	80 
801068d0:	83 e2 e0             	and    $0xffffffe0,%edx
801068d3:	88 14 c5 44 91 11 80 	mov    %dl,-0x7fee6ebc(,%eax,8)
801068da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068dd:	0f b6 14 c5 44 91 11 	movzbl -0x7fee6ebc(,%eax,8),%edx
801068e4:	80 
801068e5:	83 e2 1f             	and    $0x1f,%edx
801068e8:	88 14 c5 44 91 11 80 	mov    %dl,-0x7fee6ebc(,%eax,8)
801068ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068f2:	0f b6 14 c5 45 91 11 	movzbl -0x7fee6ebb(,%eax,8),%edx
801068f9:	80 
801068fa:	83 e2 f0             	and    $0xfffffff0,%edx
801068fd:	83 ca 0e             	or     $0xe,%edx
80106900:	88 14 c5 45 91 11 80 	mov    %dl,-0x7fee6ebb(,%eax,8)
80106907:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010690a:	0f b6 14 c5 45 91 11 	movzbl -0x7fee6ebb(,%eax,8),%edx
80106911:	80 
80106912:	83 e2 ef             	and    $0xffffffef,%edx
80106915:	88 14 c5 45 91 11 80 	mov    %dl,-0x7fee6ebb(,%eax,8)
8010691c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010691f:	0f b6 14 c5 45 91 11 	movzbl -0x7fee6ebb(,%eax,8),%edx
80106926:	80 
80106927:	83 e2 9f             	and    $0xffffff9f,%edx
8010692a:	88 14 c5 45 91 11 80 	mov    %dl,-0x7fee6ebb(,%eax,8)
80106931:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106934:	0f b6 14 c5 45 91 11 	movzbl -0x7fee6ebb(,%eax,8),%edx
8010693b:	80 
8010693c:	83 ca 80             	or     $0xffffff80,%edx
8010693f:	88 14 c5 45 91 11 80 	mov    %dl,-0x7fee6ebb(,%eax,8)
80106946:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106949:	8b 04 85 84 c0 10 80 	mov    -0x7fef3f7c(,%eax,4),%eax
80106950:	c1 e8 10             	shr    $0x10,%eax
80106953:	89 c2                	mov    %eax,%edx
80106955:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106958:	66 89 14 c5 46 91 11 	mov    %dx,-0x7fee6eba(,%eax,8)
8010695f:	80 
80106960:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106964:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
8010696b:	0f 8e 30 ff ff ff    	jle    801068a1 <tvinit+0x12>
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80106971:	a1 84 c1 10 80       	mov    0x8010c184,%eax
80106976:	66 a3 40 93 11 80    	mov    %ax,0x80119340
8010697c:	66 c7 05 42 93 11 80 	movw   $0x8,0x80119342
80106983:	08 00 
80106985:	0f b6 05 44 93 11 80 	movzbl 0x80119344,%eax
8010698c:	83 e0 e0             	and    $0xffffffe0,%eax
8010698f:	a2 44 93 11 80       	mov    %al,0x80119344
80106994:	0f b6 05 44 93 11 80 	movzbl 0x80119344,%eax
8010699b:	83 e0 1f             	and    $0x1f,%eax
8010699e:	a2 44 93 11 80       	mov    %al,0x80119344
801069a3:	0f b6 05 45 93 11 80 	movzbl 0x80119345,%eax
801069aa:	83 c8 0f             	or     $0xf,%eax
801069ad:	a2 45 93 11 80       	mov    %al,0x80119345
801069b2:	0f b6 05 45 93 11 80 	movzbl 0x80119345,%eax
801069b9:	83 e0 ef             	and    $0xffffffef,%eax
801069bc:	a2 45 93 11 80       	mov    %al,0x80119345
801069c1:	0f b6 05 45 93 11 80 	movzbl 0x80119345,%eax
801069c8:	83 c8 60             	or     $0x60,%eax
801069cb:	a2 45 93 11 80       	mov    %al,0x80119345
801069d0:	0f b6 05 45 93 11 80 	movzbl 0x80119345,%eax
801069d7:	83 c8 80             	or     $0xffffff80,%eax
801069da:	a2 45 93 11 80       	mov    %al,0x80119345
801069df:	a1 84 c1 10 80       	mov    0x8010c184,%eax
801069e4:	c1 e8 10             	shr    $0x10,%eax
801069e7:	66 a3 46 93 11 80    	mov    %ax,0x80119346

    initlock(&tickslock, "time");
801069ed:	83 ec 08             	sub    $0x8,%esp
801069f0:	68 28 8f 10 80       	push   $0x80108f28
801069f5:	68 00 91 11 80       	push   $0x80119100
801069fa:	e8 60 e7 ff ff       	call   8010515f <initlock>
801069ff:	83 c4 10             	add    $0x10,%esp
}
80106a02:	90                   	nop
80106a03:	c9                   	leave  
80106a04:	c3                   	ret    

80106a05 <idtinit>:

void
idtinit(void) {
80106a05:	55                   	push   %ebp
80106a06:	89 e5                	mov    %esp,%ebp
    lidt(idt, sizeof(idt));
80106a08:	68 00 08 00 00       	push   $0x800
80106a0d:	68 40 91 11 80       	push   $0x80119140
80106a12:	e8 3d fe ff ff       	call   80106854 <lidt>
80106a17:	83 c4 08             	add    $0x8,%esp
}
80106a1a:	90                   	nop
80106a1b:	c9                   	leave  
80106a1c:	c3                   	ret    

80106a1d <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf) {
80106a1d:	55                   	push   %ebp
80106a1e:	89 e5                	mov    %esp,%ebp
80106a20:	57                   	push   %edi
80106a21:	56                   	push   %esi
80106a22:	53                   	push   %ebx
80106a23:	83 ec 1c             	sub    $0x1c,%esp

    if (tf->trapno == T_SYSCALL) {
80106a26:	8b 45 08             	mov    0x8(%ebp),%eax
80106a29:	8b 40 30             	mov    0x30(%eax),%eax
80106a2c:	83 f8 40             	cmp    $0x40,%eax
80106a2f:	75 3d                	jne    80106a6e <trap+0x51>
        if (myproc()->killed)
80106a31:	e8 9f d8 ff ff       	call   801042d5 <myproc>
80106a36:	8b 40 24             	mov    0x24(%eax),%eax
80106a39:	85 c0                	test   %eax,%eax
80106a3b:	74 05                	je     80106a42 <trap+0x25>
            exit();
80106a3d:	e8 ce dd ff ff       	call   80104810 <exit>
        myproc()->tf = tf;
80106a42:	e8 8e d8 ff ff       	call   801042d5 <myproc>
80106a47:	89 c2                	mov    %eax,%edx
80106a49:	8b 45 08             	mov    0x8(%ebp),%eax
80106a4c:	89 42 18             	mov    %eax,0x18(%edx)
        syscall();
80106a4f:	e8 9c ed ff ff       	call   801057f0 <syscall>
        if (myproc()->killed)
80106a54:	e8 7c d8 ff ff       	call   801042d5 <myproc>
80106a59:	8b 40 24             	mov    0x24(%eax),%eax
80106a5c:	85 c0                	test   %eax,%eax
80106a5e:	0f 84 04 02 00 00    	je     80106c68 <trap+0x24b>
            exit();
80106a64:	e8 a7 dd ff ff       	call   80104810 <exit>
        return;
80106a69:	e9 fa 01 00 00       	jmp    80106c68 <trap+0x24b>
    }

    switch (tf->trapno) {
80106a6e:	8b 45 08             	mov    0x8(%ebp),%eax
80106a71:	8b 40 30             	mov    0x30(%eax),%eax
80106a74:	83 e8 20             	sub    $0x20,%eax
80106a77:	83 f8 1f             	cmp    $0x1f,%eax
80106a7a:	0f 87 b5 00 00 00    	ja     80106b35 <trap+0x118>
80106a80:	8b 04 85 d0 8f 10 80 	mov    -0x7fef7030(,%eax,4),%eax
80106a87:	ff e0                	jmp    *%eax
        case T_IRQ0 + IRQ_TIMER:
            if (cpuid() == 0) {
80106a89:	e8 ae d7 ff ff       	call   8010423c <cpuid>
80106a8e:	85 c0                	test   %eax,%eax
80106a90:	75 3d                	jne    80106acf <trap+0xb2>
                acquire(&tickslock);
80106a92:	83 ec 0c             	sub    $0xc,%esp
80106a95:	68 00 91 11 80       	push   $0x80119100
80106a9a:	e8 e2 e6 ff ff       	call   80105181 <acquire>
80106a9f:	83 c4 10             	add    $0x10,%esp
                ticks++;
80106aa2:	a1 40 99 11 80       	mov    0x80119940,%eax
80106aa7:	83 c0 01             	add    $0x1,%eax
80106aaa:	a3 40 99 11 80       	mov    %eax,0x80119940
                wakeup(&ticks);
80106aaf:	83 ec 0c             	sub    $0xc,%esp
80106ab2:	68 40 99 11 80       	push   $0x80119940
80106ab7:	e8 79 e2 ff ff       	call   80104d35 <wakeup>
80106abc:	83 c4 10             	add    $0x10,%esp
                release(&tickslock);
80106abf:	83 ec 0c             	sub    $0xc,%esp
80106ac2:	68 00 91 11 80       	push   $0x80119100
80106ac7:	e8 23 e7 ff ff       	call   801051ef <release>
80106acc:	83 c4 10             	add    $0x10,%esp
            }
            lapiceoi();
80106acf:	e8 86 c5 ff ff       	call   8010305a <lapiceoi>
            break;
80106ad4:	e9 0f 01 00 00       	jmp    80106be8 <trap+0x1cb>
        case T_IRQ0 + IRQ_IDE:
            ideintr();
80106ad9:	e8 f6 bd ff ff       	call   801028d4 <ideintr>
            lapiceoi();
80106ade:	e8 77 c5 ff ff       	call   8010305a <lapiceoi>
            break;
80106ae3:	e9 00 01 00 00       	jmp    80106be8 <trap+0x1cb>
        case T_IRQ0 + IRQ_IDE + 1:
            // Bochs generates spurious IDE1 interrupts.
            break;
        case T_IRQ0 + IRQ_KBD:
            kbdintr();
80106ae8:	e8 b6 c3 ff ff       	call   80102ea3 <kbdintr>
            lapiceoi();
80106aed:	e8 68 c5 ff ff       	call   8010305a <lapiceoi>
            break;
80106af2:	e9 f1 00 00 00       	jmp    80106be8 <trap+0x1cb>
        case T_IRQ0 + IRQ_COM1:
            uartintr();
80106af7:	e8 4c 07 00 00       	call   80107248 <uartintr>
            lapiceoi();
80106afc:	e8 59 c5 ff ff       	call   8010305a <lapiceoi>
            break;
80106b01:	e9 e2 00 00 00       	jmp    80106be8 <trap+0x1cb>
        case T_IRQ0 + 7:
        case T_IRQ0 + IRQ_SPURIOUS:
            cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b06:	8b 45 08             	mov    0x8(%ebp),%eax
80106b09:	8b 70 38             	mov    0x38(%eax),%esi
                    cpuid(), tf->cs, tf->eip);
80106b0c:	8b 45 08             	mov    0x8(%ebp),%eax
80106b0f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
            uartintr();
            lapiceoi();
            break;
        case T_IRQ0 + 7:
        case T_IRQ0 + IRQ_SPURIOUS:
            cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b13:	0f b7 d8             	movzwl %ax,%ebx
80106b16:	e8 21 d7 ff ff       	call   8010423c <cpuid>
80106b1b:	56                   	push   %esi
80106b1c:	53                   	push   %ebx
80106b1d:	50                   	push   %eax
80106b1e:	68 30 8f 10 80       	push   $0x80108f30
80106b23:	e8 d8 98 ff ff       	call   80100400 <cprintf>
80106b28:	83 c4 10             	add    $0x10,%esp
                    cpuid(), tf->cs, tf->eip);
            lapiceoi();
80106b2b:	e8 2a c5 ff ff       	call   8010305a <lapiceoi>
            break;
80106b30:	e9 b3 00 00 00       	jmp    80106be8 <trap+0x1cb>

            //PAGEBREAK: 13
        default:
            if (myproc() == 0 || (tf->cs & 3) == 0) {
80106b35:	e8 9b d7 ff ff       	call   801042d5 <myproc>
80106b3a:	85 c0                	test   %eax,%eax
80106b3c:	74 11                	je     80106b4f <trap+0x132>
80106b3e:	8b 45 08             	mov    0x8(%ebp),%eax
80106b41:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106b45:	0f b7 c0             	movzwl %ax,%eax
80106b48:	83 e0 03             	and    $0x3,%eax
80106b4b:	85 c0                	test   %eax,%eax
80106b4d:	75 3b                	jne    80106b8a <trap+0x16d>
                // In kernel, it must be our mistake.
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106b4f:	e8 2a fd ff ff       	call   8010687e <rcr2>
80106b54:	89 c6                	mov    %eax,%esi
80106b56:	8b 45 08             	mov    0x8(%ebp),%eax
80106b59:	8b 58 38             	mov    0x38(%eax),%ebx
80106b5c:	e8 db d6 ff ff       	call   8010423c <cpuid>
80106b61:	89 c2                	mov    %eax,%edx
80106b63:	8b 45 08             	mov    0x8(%ebp),%eax
80106b66:	8b 40 30             	mov    0x30(%eax),%eax
80106b69:	83 ec 0c             	sub    $0xc,%esp
80106b6c:	56                   	push   %esi
80106b6d:	53                   	push   %ebx
80106b6e:	52                   	push   %edx
80106b6f:	50                   	push   %eax
80106b70:	68 54 8f 10 80       	push   $0x80108f54
80106b75:	e8 86 98 ff ff       	call   80100400 <cprintf>
80106b7a:	83 c4 20             	add    $0x20,%esp
                        tf->trapno, cpuid(), tf->eip, rcr2());
                panic("trap");
80106b7d:	83 ec 0c             	sub    $0xc,%esp
80106b80:	68 86 8f 10 80       	push   $0x80108f86
80106b85:	e8 16 9a ff ff       	call   801005a0 <panic>
            }
            // In user space, assume process misbehaved.
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80106b8a:	e8 ef fc ff ff       	call   8010687e <rcr2>
80106b8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b92:	8b 45 08             	mov    0x8(%ebp),%eax
80106b95:	8b 78 38             	mov    0x38(%eax),%edi
80106b98:	e8 9f d6 ff ff       	call   8010423c <cpuid>
80106b9d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106ba0:	8b 45 08             	mov    0x8(%ebp),%eax
80106ba3:	8b 70 34             	mov    0x34(%eax),%esi
80106ba6:	8b 45 08             	mov    0x8(%ebp),%eax
80106ba9:	8b 58 30             	mov    0x30(%eax),%ebx
                            "eip 0x%x addr 0x%x--kill proc\n",
                    myproc()->pid, myproc()->name, tf->trapno,
80106bac:	e8 24 d7 ff ff       	call   801042d5 <myproc>
80106bb1:	8d 48 6c             	lea    0x6c(%eax),%ecx
80106bb4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80106bb7:	e8 19 d7 ff ff       	call   801042d5 <myproc>
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
                        tf->trapno, cpuid(), tf->eip, rcr2());
                panic("trap");
            }
            // In user space, assume process misbehaved.
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80106bbc:	8b 40 10             	mov    0x10(%eax),%eax
80106bbf:	ff 75 e4             	pushl  -0x1c(%ebp)
80106bc2:	57                   	push   %edi
80106bc3:	ff 75 e0             	pushl  -0x20(%ebp)
80106bc6:	56                   	push   %esi
80106bc7:	53                   	push   %ebx
80106bc8:	ff 75 dc             	pushl  -0x24(%ebp)
80106bcb:	50                   	push   %eax
80106bcc:	68 8c 8f 10 80       	push   $0x80108f8c
80106bd1:	e8 2a 98 ff ff       	call   80100400 <cprintf>
80106bd6:	83 c4 20             	add    $0x20,%esp
                            "eip 0x%x addr 0x%x--kill proc\n",
                    myproc()->pid, myproc()->name, tf->trapno,
                    tf->err, cpuid(), tf->eip, rcr2());
            myproc()->killed = 1;
80106bd9:	e8 f7 d6 ff ff       	call   801042d5 <myproc>
80106bde:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106be5:	eb 01                	jmp    80106be8 <trap+0x1cb>
            ideintr();
            lapiceoi();
            break;
        case T_IRQ0 + IRQ_IDE + 1:
            // Bochs generates spurious IDE1 interrupts.
            break;
80106be7:	90                   	nop
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106be8:	e8 e8 d6 ff ff       	call   801042d5 <myproc>
80106bed:	85 c0                	test   %eax,%eax
80106bef:	74 23                	je     80106c14 <trap+0x1f7>
80106bf1:	e8 df d6 ff ff       	call   801042d5 <myproc>
80106bf6:	8b 40 24             	mov    0x24(%eax),%eax
80106bf9:	85 c0                	test   %eax,%eax
80106bfb:	74 17                	je     80106c14 <trap+0x1f7>
80106bfd:	8b 45 08             	mov    0x8(%ebp),%eax
80106c00:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106c04:	0f b7 c0             	movzwl %ax,%eax
80106c07:	83 e0 03             	and    $0x3,%eax
80106c0a:	83 f8 03             	cmp    $0x3,%eax
80106c0d:	75 05                	jne    80106c14 <trap+0x1f7>
        exit();
80106c0f:	e8 fc db ff ff       	call   80104810 <exit>

    // Force process to give up CPU on clock tick.
    // If interrupts were on while locks held, would need to check nlock.
    if (myproc() && myproc()->state == RUNNING &&
80106c14:	e8 bc d6 ff ff       	call   801042d5 <myproc>
80106c19:	85 c0                	test   %eax,%eax
80106c1b:	74 1d                	je     80106c3a <trap+0x21d>
80106c1d:	e8 b3 d6 ff ff       	call   801042d5 <myproc>
80106c22:	8b 40 0c             	mov    0xc(%eax),%eax
80106c25:	83 f8 04             	cmp    $0x4,%eax
80106c28:	75 10                	jne    80106c3a <trap+0x21d>
        tf->trapno == T_IRQ0 + IRQ_TIMER)
80106c2a:	8b 45 08             	mov    0x8(%ebp),%eax
80106c2d:	8b 40 30             	mov    0x30(%eax),%eax
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
        exit();

    // Force process to give up CPU on clock tick.
    // If interrupts were on while locks held, would need to check nlock.
    if (myproc() && myproc()->state == RUNNING &&
80106c30:	83 f8 20             	cmp    $0x20,%eax
80106c33:	75 05                	jne    80106c3a <trap+0x21d>
        tf->trapno == T_IRQ0 + IRQ_TIMER)
        yield();
80106c35:	e8 92 df ff ff       	call   80104bcc <yield>

    // Check if the process has been killed since we yielded
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106c3a:	e8 96 d6 ff ff       	call   801042d5 <myproc>
80106c3f:	85 c0                	test   %eax,%eax
80106c41:	74 26                	je     80106c69 <trap+0x24c>
80106c43:	e8 8d d6 ff ff       	call   801042d5 <myproc>
80106c48:	8b 40 24             	mov    0x24(%eax),%eax
80106c4b:	85 c0                	test   %eax,%eax
80106c4d:	74 1a                	je     80106c69 <trap+0x24c>
80106c4f:	8b 45 08             	mov    0x8(%ebp),%eax
80106c52:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106c56:	0f b7 c0             	movzwl %ax,%eax
80106c59:	83 e0 03             	and    $0x3,%eax
80106c5c:	83 f8 03             	cmp    $0x3,%eax
80106c5f:	75 08                	jne    80106c69 <trap+0x24c>
        exit();
80106c61:	e8 aa db ff ff       	call   80104810 <exit>
80106c66:	eb 01                	jmp    80106c69 <trap+0x24c>
            exit();
        myproc()->tf = tf;
        syscall();
        if (myproc()->killed)
            exit();
        return;
80106c68:	90                   	nop
        yield();

    // Check if the process has been killed since we yielded
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
        exit();
}
80106c69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c6c:	5b                   	pop    %ebx
80106c6d:	5e                   	pop    %esi
80106c6e:	5f                   	pop    %edi
80106c6f:	5d                   	pop    %ebp
80106c70:	c3                   	ret    

80106c71 <hasSignal>:



//return 1 if process p has received signal 'signum'
int hasSignal(struct proc *p, int signum) {
80106c71:	55                   	push   %ebp
80106c72:	89 e5                	mov    %esp,%ebp
80106c74:	53                   	push   %ebx

    if ((p->pending & (1 << signum)) > 0)
80106c75:	8b 45 08             	mov    0x8(%ebp),%eax
80106c78:	8b 50 7c             	mov    0x7c(%eax),%edx
80106c7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c7e:	bb 01 00 00 00       	mov    $0x1,%ebx
80106c83:	89 c1                	mov    %eax,%ecx
80106c85:	d3 e3                	shl    %cl,%ebx
80106c87:	89 d8                	mov    %ebx,%eax
80106c89:	21 d0                	and    %edx,%eax
80106c8b:	85 c0                	test   %eax,%eax
80106c8d:	74 07                	je     80106c96 <hasSignal+0x25>
        return 1;
80106c8f:	b8 01 00 00 00       	mov    $0x1,%eax
80106c94:	eb 05                	jmp    80106c9b <hasSignal+0x2a>
    return 0;
80106c96:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c9b:	5b                   	pop    %ebx
80106c9c:	5d                   	pop    %ebp
80106c9d:	c3                   	ret    

80106c9e <isBlocked>:

//indicates if signal 'signum' is blocked for handling
int isBlocked(int signum) {
80106c9e:	55                   	push   %ebp
80106c9f:	89 e5                	mov    %esp,%ebp
80106ca1:	53                   	push   %ebx
80106ca2:	83 ec 14             	sub    $0x14,%esp
    struct proc *curproc = myproc();
80106ca5:	e8 2b d6 ff ff       	call   801042d5 <myproc>
80106caa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (curproc != 0) {
80106cad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106cb1:	74 2b                	je     80106cde <isBlocked+0x40>
        if ((curproc->mask & (1 << signum)) > 0)
80106cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cb6:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80106cbc:	8b 45 08             	mov    0x8(%ebp),%eax
80106cbf:	bb 01 00 00 00       	mov    $0x1,%ebx
80106cc4:	89 c1                	mov    %eax,%ecx
80106cc6:	d3 e3                	shl    %cl,%ebx
80106cc8:	89 d8                	mov    %ebx,%eax
80106cca:	21 d0                	and    %edx,%eax
80106ccc:	85 c0                	test   %eax,%eax
80106cce:	74 07                	je     80106cd7 <isBlocked+0x39>
            return 0;
80106cd0:	b8 00 00 00 00       	mov    $0x0,%eax
80106cd5:	eb 0c                	jmp    80106ce3 <isBlocked+0x45>
        return 1;
80106cd7:	b8 01 00 00 00       	mov    $0x1,%eax
80106cdc:	eb 05                	jmp    80106ce3 <isBlocked+0x45>
    }
    return 1;
80106cde:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106ce3:	83 c4 14             	add    $0x14,%esp
80106ce6:	5b                   	pop    %ebx
80106ce7:	5d                   	pop    %ebp
80106ce8:	c3                   	ret    

80106ce9 <cancelSignal>:

//cancel a certain signal for a certain process!
void cancelSignal(struct proc *p, int signum) {
80106ce9:	55                   	push   %ebp
80106cea:	89 e5                	mov    %esp,%ebp
80106cec:	53                   	push   %ebx
    if (signum >= 0 && signum <= 31) {
80106ced:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106cf1:	78 22                	js     80106d15 <cancelSignal+0x2c>
80106cf3:	83 7d 0c 1f          	cmpl   $0x1f,0xc(%ebp)
80106cf7:	7f 1c                	jg     80106d15 <cancelSignal+0x2c>
        p->pending = p->pending ^ (1 << signum);
80106cf9:	8b 45 08             	mov    0x8(%ebp),%eax
80106cfc:	8b 50 7c             	mov    0x7c(%eax),%edx
80106cff:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d02:	bb 01 00 00 00       	mov    $0x1,%ebx
80106d07:	89 c1                	mov    %eax,%ecx
80106d09:	d3 e3                	shl    %cl,%ebx
80106d0b:	89 d8                	mov    %ebx,%eax
80106d0d:	31 c2                	xor    %eax,%edx
80106d0f:	8b 45 08             	mov    0x8(%ebp),%eax
80106d12:	89 50 7c             	mov    %edx,0x7c(%eax)
    }
}
80106d15:	90                   	nop
80106d16:	5b                   	pop    %ebx
80106d17:	5d                   	pop    %ebp
80106d18:	c3                   	ret    

80106d19 <check_kernel_sigs>:

//called in kernel mode
void
check_kernel_sigs() {
80106d19:	55                   	push   %ebp
80106d1a:	89 e5                	mov    %esp,%ebp
80106d1c:	53                   	push   %ebx
80106d1d:	83 ec 24             	sub    $0x24,%esp
    struct proc *curproc = myproc();
80106d20:	e8 b0 d5 ff ff       	call   801042d5 <myproc>
80106d25:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (curproc == 0 || curproc->mask == 0 || curproc->pending == 0)
80106d28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106d2c:	0f 84 45 03 00 00    	je     80107077 <check_kernel_sigs+0x35e>
80106d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d35:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80106d3b:	85 c0                	test   %eax,%eax
80106d3d:	0f 84 34 03 00 00    	je     80107077 <check_kernel_sigs+0x35e>
80106d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d46:	8b 40 7c             	mov    0x7c(%eax),%eax
80106d49:	85 c0                	test   %eax,%eax
80106d4b:	0f 84 26 03 00 00    	je     80107077 <check_kernel_sigs+0x35e>
        return;
    int i;
    //check each possible signal
    for (i = 0; i < 32; i++) {
80106d51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106d58:	e9 0e 03 00 00       	jmp    8010706b <check_kernel_sigs+0x352>

        if( !(hasSignal(curproc, i) && !isBlocked(i)) )       //if signal i should NOT be handled right now, go to the next one
80106d5d:	83 ec 08             	sub    $0x8,%esp
80106d60:	ff 75 f4             	pushl  -0xc(%ebp)
80106d63:	ff 75 f0             	pushl  -0x10(%ebp)
80106d66:	e8 06 ff ff ff       	call   80106c71 <hasSignal>
80106d6b:	83 c4 10             	add    $0x10,%esp
80106d6e:	85 c0                	test   %eax,%eax
80106d70:	0f 84 f0 02 00 00    	je     80107066 <check_kernel_sigs+0x34d>
80106d76:	83 ec 0c             	sub    $0xc,%esp
80106d79:	ff 75 f4             	pushl  -0xc(%ebp)
80106d7c:	e8 1d ff ff ff       	call   80106c9e <isBlocked>
80106d81:	83 c4 10             	add    $0x10,%esp
80106d84:	85 c0                	test   %eax,%eax
80106d86:	0f 85 da 02 00 00    	jne    80107066 <check_kernel_sigs+0x34d>
            continue;

        curproc->mask_backup = curproc->mask;
80106d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d8f:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80106d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d98:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
        curproc->mask = 0;
80106d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106da1:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80106da8:	00 00 00 
        //handle signals which require DEFAULT handling
        switch (i) {
80106dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dae:	83 f8 11             	cmp    $0x11,%eax
80106db1:	0f 84 99 00 00 00    	je     80106e50 <check_kernel_sigs+0x137>
80106db7:	83 f8 13             	cmp    $0x13,%eax
80106dba:	74 46                	je     80106e02 <check_kernel_sigs+0xe9>
80106dbc:	83 f8 09             	cmp    $0x9,%eax
80106dbf:	0f 85 d8 00 00 00    	jne    80106e9d <check_kernel_sigs+0x184>
            case SIGKILL:
                if (curproc->handlers[i] == SIG_DFL) {
80106dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106dc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106dcb:	83 c2 20             	add    $0x20,%edx
80106dce:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106dd2:	85 c0                	test   %eax,%eax
80106dd4:	0f 85 43 01 00 00    	jne    80106f1d <check_kernel_sigs+0x204>
                    curproc->killed = 1;
80106dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ddd:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
                    if (curproc->state == SLEEPING)
80106de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106de7:	8b 40 0c             	mov    0xc(%eax),%eax
80106dea:	83 f8 02             	cmp    $0x2,%eax
80106ded:	0f 85 2a 01 00 00    	jne    80106f1d <check_kernel_sigs+0x204>
                        curproc->state = RUNNABLE;
80106df3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106df6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
                }
                break;
80106dfd:	e9 1b 01 00 00       	jmp    80106f1d <check_kernel_sigs+0x204>
            case SIGCONT:
                if (curproc->handlers[i] == SIG_DFL) {
80106e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106e05:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106e08:	83 c2 20             	add    $0x20,%edx
80106e0b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106e0f:	85 c0                	test   %eax,%eax
80106e11:	0f 85 09 01 00 00    	jne    80106f20 <check_kernel_sigs+0x207>
                    if (hasSignal(curproc, SIGSTOP))
80106e17:	83 ec 08             	sub    $0x8,%esp
80106e1a:	6a 11                	push   $0x11
80106e1c:	ff 75 f0             	pushl  -0x10(%ebp)
80106e1f:	e8 4d fe ff ff       	call   80106c71 <hasSignal>
80106e24:	83 c4 10             	add    $0x10,%esp
80106e27:	85 c0                	test   %eax,%eax
80106e29:	74 10                	je     80106e3b <check_kernel_sigs+0x122>
                        cancelSignal(curproc, SIGSTOP);
80106e2b:	83 ec 08             	sub    $0x8,%esp
80106e2e:	6a 11                	push   $0x11
80106e30:	ff 75 f0             	pushl  -0x10(%ebp)
80106e33:	e8 b1 fe ff ff       	call   80106ce9 <cancelSignal>
80106e38:	83 c4 10             	add    $0x10,%esp
                    cancelSignal(curproc, SIGCONT);
80106e3b:	83 ec 08             	sub    $0x8,%esp
80106e3e:	6a 13                	push   $0x13
80106e40:	ff 75 f0             	pushl  -0x10(%ebp)
80106e43:	e8 a1 fe ff ff       	call   80106ce9 <cancelSignal>
80106e48:	83 c4 10             	add    $0x10,%esp
                }
                break;
80106e4b:	e9 d0 00 00 00       	jmp    80106f20 <check_kernel_sigs+0x207>
            case SIGSTOP:
                if (curproc->handlers[i] == SIG_DFL)
80106e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106e53:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106e56:	83 c2 20             	add    $0x20,%edx
80106e59:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106e5d:	85 c0                	test   %eax,%eax
80106e5f:	0f 85 be 00 00 00    	jne    80106f23 <check_kernel_sigs+0x20a>
                    while ((!hasSignal(curproc, SIGCONT)) && (!hasSignal(curproc, SIGKILL)))
80106e65:	eb 05                	jmp    80106e6c <check_kernel_sigs+0x153>
                        yield();
80106e67:	e8 60 dd ff ff       	call   80104bcc <yield>
                    cancelSignal(curproc, SIGCONT);
                }
                break;
            case SIGSTOP:
                if (curproc->handlers[i] == SIG_DFL)
                    while ((!hasSignal(curproc, SIGCONT)) && (!hasSignal(curproc, SIGKILL)))
80106e6c:	83 ec 08             	sub    $0x8,%esp
80106e6f:	6a 13                	push   $0x13
80106e71:	ff 75 f0             	pushl  -0x10(%ebp)
80106e74:	e8 f8 fd ff ff       	call   80106c71 <hasSignal>
80106e79:	83 c4 10             	add    $0x10,%esp
80106e7c:	85 c0                	test   %eax,%eax
80106e7e:	0f 85 9f 00 00 00    	jne    80106f23 <check_kernel_sigs+0x20a>
80106e84:	83 ec 08             	sub    $0x8,%esp
80106e87:	6a 09                	push   $0x9
80106e89:	ff 75 f0             	pushl  -0x10(%ebp)
80106e8c:	e8 e0 fd ff ff       	call   80106c71 <hasSignal>
80106e91:	83 c4 10             	add    $0x10,%esp
80106e94:	85 c0                	test   %eax,%eax
80106e96:	74 cf                	je     80106e67 <check_kernel_sigs+0x14e>
                        yield();
                break;
80106e98:	e9 86 00 00 00       	jmp    80106f23 <check_kernel_sigs+0x20a>
            default:
                if (curproc->handlers[i] == (void *) SIG_DFL) {
80106e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ea0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106ea3:	83 c2 20             	add    $0x20,%edx
80106ea6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106eaa:	85 c0                	test   %eax,%eax
80106eac:	75 78                	jne    80106f26 <check_kernel_sigs+0x20d>
                    cprintf("i: %d, i-1: %d , i+1:%d ",curproc->handlers[i],curproc->handlers[i-1],curproc->handlers[i+1]);
80106eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106eb1:	8d 50 01             	lea    0x1(%eax),%edx
80106eb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106eb7:	83 c2 20             	add    $0x20,%edx
80106eba:	8b 4c 90 08          	mov    0x8(%eax,%edx,4),%ecx
80106ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ec1:	8d 50 ff             	lea    -0x1(%eax),%edx
80106ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ec7:	83 c2 20             	add    $0x20,%edx
80106eca:	8b 54 90 08          	mov    0x8(%eax,%edx,4),%edx
80106ece:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ed1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80106ed4:	83 c3 20             	add    $0x20,%ebx
80106ed7:	8b 44 98 08          	mov    0x8(%eax,%ebx,4),%eax
80106edb:	51                   	push   %ecx
80106edc:	52                   	push   %edx
80106edd:	50                   	push   %eax
80106ede:	68 50 90 10 80       	push   $0x80109050
80106ee3:	e8 18 95 ff ff       	call   80100400 <cprintf>
80106ee8:	83 c4 10             	add    $0x10,%esp
                    cancelSignal(curproc, i);
80106eeb:	83 ec 08             	sub    $0x8,%esp
80106eee:	ff 75 f4             	pushl  -0xc(%ebp)
80106ef1:	ff 75 f0             	pushl  -0x10(%ebp)
80106ef4:	e8 f0 fd ff ff       	call   80106ce9 <cancelSignal>
80106ef9:	83 c4 10             	add    $0x10,%esp
                    curproc->killed = 1;
80106efc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106eff:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
                    if (curproc->state == SLEEPING)
80106f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f09:	8b 40 0c             	mov    0xc(%eax),%eax
80106f0c:	83 f8 02             	cmp    $0x2,%eax
80106f0f:	75 15                	jne    80106f26 <check_kernel_sigs+0x20d>
                        curproc->state = RUNNABLE;
80106f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f14:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
                }
                break;
80106f1b:	eb 09                	jmp    80106f26 <check_kernel_sigs+0x20d>
                if (curproc->handlers[i] == SIG_DFL) {
                    curproc->killed = 1;
                    if (curproc->state == SLEEPING)
                        curproc->state = RUNNABLE;
                }
                break;
80106f1d:	90                   	nop
80106f1e:	eb 07                	jmp    80106f27 <check_kernel_sigs+0x20e>
                if (curproc->handlers[i] == SIG_DFL) {
                    if (hasSignal(curproc, SIGSTOP))
                        cancelSignal(curproc, SIGSTOP);
                    cancelSignal(curproc, SIGCONT);
                }
                break;
80106f20:	90                   	nop
80106f21:	eb 04                	jmp    80106f27 <check_kernel_sigs+0x20e>
            case SIGSTOP:
                if (curproc->handlers[i] == SIG_DFL)
                    while ((!hasSignal(curproc, SIGCONT)) && (!hasSignal(curproc, SIGKILL)))
                        yield();
                break;
80106f23:	90                   	nop
80106f24:	eb 01                	jmp    80106f27 <check_kernel_sigs+0x20e>
                    cancelSignal(curproc, i);
                    curproc->killed = 1;
                    if (curproc->state == SLEEPING)
                        curproc->state = RUNNABLE;
                }
                break;
80106f26:	90                   	nop
        }
        //if should ignore this signal
        if (curproc->handlers[i] == (void *) SIG_IGN) {
80106f27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106f2d:	83 c2 20             	add    $0x20,%edx
80106f30:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106f34:	83 f8 01             	cmp    $0x1,%eax
80106f37:	75 16                	jne    80106f4f <check_kernel_sigs+0x236>
            cancelSignal(curproc, i);
80106f39:	83 ec 08             	sub    $0x8,%esp
80106f3c:	ff 75 f4             	pushl  -0xc(%ebp)
80106f3f:	ff 75 f0             	pushl  -0x10(%ebp)
80106f42:	e8 a2 fd ff ff       	call   80106ce9 <cancelSignal>
80106f47:	83 c4 10             	add    $0x10,%esp
80106f4a:	e9 03 01 00 00       	jmp    80107052 <check_kernel_sigs+0x339>
        }
            // custom handlers
        else if (curproc->handlers[i] != SIG_DFL) {           //user handler
80106f4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f52:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106f55:	83 c2 20             	add    $0x20,%edx
80106f58:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106f5c:	85 c0                	test   %eax,%eax
80106f5e:	0f 84 ee 00 00 00    	je     80107052 <check_kernel_sigs+0x339>
            cprintf("handling custom!!!! i: %d\n");
80106f64:	83 ec 0c             	sub    $0xc,%esp
80106f67:	68 69 90 10 80       	push   $0x80109069
80106f6c:	e8 8f 94 ff ff       	call   80100400 <cprintf>
80106f71:	83 c4 10             	add    $0x10,%esp
            memmove(curproc->trap_backup, curproc->tf, sizeof(struct trapframe));
80106f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f77:	8b 50 18             	mov    0x18(%eax),%edx
80106f7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f7d:	8b 80 08 01 00 00    	mov    0x108(%eax),%eax
80106f83:	83 ec 04             	sub    $0x4,%esp
80106f86:	6a 4c                	push   $0x4c
80106f88:	52                   	push   %edx
80106f89:	50                   	push   %eax
80106f8a:	e8 28 e5 ff ff       	call   801054b7 <memmove>
80106f8f:	83 c4 10             	add    $0x10,%esp
            void *handler_pointer = curproc->handlers[i];
80106f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106f98:	83 c2 20             	add    $0x20,%edx
80106f9b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106f9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
            //"push" the code of the sigret injection program
            int sigret_size = &call_sigret_syscall - &end_sigret_syscall;   //size of the "injected" program
80106fa2:	ba 4d 68 10 80       	mov    $0x8010684d,%edx
80106fa7:	b8 54 68 10 80       	mov    $0x80106854,%eax
80106fac:	29 c2                	sub    %eax,%edx
80106fae:	89 d0                	mov    %edx,%eax
80106fb0:	c1 f8 02             	sar    $0x2,%eax
80106fb3:	89 45 e8             	mov    %eax,-0x18(%ebp)
            curproc->tf->esp -= sigret_size;
80106fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106fb9:	8b 40 18             	mov    0x18(%eax),%eax
80106fbc:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106fbf:	8b 52 18             	mov    0x18(%edx),%edx
80106fc2:	8b 4a 44             	mov    0x44(%edx),%ecx
80106fc5:	8b 55 e8             	mov    -0x18(%ebp),%edx
80106fc8:	29 d1                	sub    %edx,%ecx
80106fca:	89 ca                	mov    %ecx,%edx
80106fcc:	89 50 44             	mov    %edx,0x44(%eax)
            void *injected_pointer = (void *) curproc->tf->esp;                    //points to the injected function's code.
80106fcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106fd2:	8b 40 18             	mov    0x18(%eax),%eax
80106fd5:	8b 40 44             	mov    0x44(%eax),%eax
80106fd8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            memmove((void *) curproc->tf->esp, call_sigret_syscall, sigret_size);   //copy the code to the stack
80106fdb:	8b 55 e8             	mov    -0x18(%ebp),%edx
80106fde:	a1 4d 68 10 80       	mov    0x8010684d,%eax
80106fe3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106fe6:	8b 49 18             	mov    0x18(%ecx),%ecx
80106fe9:	8b 49 44             	mov    0x44(%ecx),%ecx
80106fec:	83 ec 04             	sub    $0x4,%esp
80106fef:	52                   	push   %edx
80106ff0:	50                   	push   %eax
80106ff1:	51                   	push   %ecx
80106ff2:	e8 c0 e4 ff ff       	call   801054b7 <memmove>
80106ff7:	83 c4 10             	add    $0x10,%esp
            //push the signum
            curproc->tf->esp -= 4;
80106ffa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ffd:	8b 40 18             	mov    0x18(%eax),%eax
80107000:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107003:	8b 52 18             	mov    0x18(%edx),%edx
80107006:	8b 52 44             	mov    0x44(%edx),%edx
80107009:	83 ea 04             	sub    $0x4,%edx
8010700c:	89 50 44             	mov    %edx,0x44(%eax)
            *((int *) curproc->tf->esp) = i;
8010700f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107012:	8b 40 18             	mov    0x18(%eax),%eax
80107015:	8b 40 44             	mov    0x44(%eax),%eax
80107018:	89 c2                	mov    %eax,%edx
8010701a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010701d:	89 02                	mov    %eax,(%edx)
            curproc->tf->eip = (uint) handler_pointer;
8010701f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107022:	8b 40 18             	mov    0x18(%eax),%eax
80107025:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107028:	89 50 38             	mov    %edx,0x38(%eax)
            //push a pointer to the injected function
            curproc->tf->esp -= 4;
8010702b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010702e:	8b 40 18             	mov    0x18(%eax),%eax
80107031:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107034:	8b 52 18             	mov    0x18(%edx),%edx
80107037:	8b 52 44             	mov    0x44(%edx),%edx
8010703a:	83 ea 04             	sub    $0x4,%edx
8010703d:	89 50 44             	mov    %edx,0x44(%eax)
            *((int *) curproc->tf->esp) = (int) injected_pointer;
80107040:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107043:	8b 40 18             	mov    0x18(%eax),%eax
80107046:	8b 40 44             	mov    0x44(%eax),%eax
80107049:	89 c2                	mov    %eax,%edx
8010704b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010704e:	89 02                	mov    %eax,(%edx)
            return;
80107050:	eb 26                	jmp    80107078 <check_kernel_sigs+0x35f>
        }
        curproc->mask = curproc->mask_backup;     //restore the mask
80107052:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107055:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
8010705b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010705e:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
80107064:	eb 01                	jmp    80107067 <check_kernel_sigs+0x34e>
    int i;
    //check each possible signal
    for (i = 0; i < 32; i++) {

        if( !(hasSignal(curproc, i) && !isBlocked(i)) )       //if signal i should NOT be handled right now, go to the next one
            continue;
80107066:	90                   	nop
    struct proc *curproc = myproc();
    if (curproc == 0 || curproc->mask == 0 || curproc->pending == 0)
        return;
    int i;
    //check each possible signal
    for (i = 0; i < 32; i++) {
80107067:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010706b:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
8010706f:	0f 8e e8 fc ff ff    	jle    80106d5d <check_kernel_sigs+0x44>
80107075:	eb 01                	jmp    80107078 <check_kernel_sigs+0x35f>
//called in kernel mode
void
check_kernel_sigs() {
    struct proc *curproc = myproc();
    if (curproc == 0 || curproc->mask == 0 || curproc->pending == 0)
        return;
80107077:	90                   	nop
            *((int *) curproc->tf->esp) = (int) injected_pointer;
            return;
        }
        curproc->mask = curproc->mask_backup;     //restore the mask
    }
}
80107078:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010707b:	c9                   	leave  
8010707c:	c3                   	ret    

8010707d <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010707d:	55                   	push   %ebp
8010707e:	89 e5                	mov    %esp,%ebp
80107080:	83 ec 14             	sub    $0x14,%esp
80107083:	8b 45 08             	mov    0x8(%ebp),%eax
80107086:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010708a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010708e:	89 c2                	mov    %eax,%edx
80107090:	ec                   	in     (%dx),%al
80107091:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107094:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107098:	c9                   	leave  
80107099:	c3                   	ret    

8010709a <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010709a:	55                   	push   %ebp
8010709b:	89 e5                	mov    %esp,%ebp
8010709d:	83 ec 08             	sub    $0x8,%esp
801070a0:	8b 55 08             	mov    0x8(%ebp),%edx
801070a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801070a6:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801070aa:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801070ad:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801070b1:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801070b5:	ee                   	out    %al,(%dx)
}
801070b6:	90                   	nop
801070b7:	c9                   	leave  
801070b8:	c3                   	ret    

801070b9 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801070b9:	55                   	push   %ebp
801070ba:	89 e5                	mov    %esp,%ebp
801070bc:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801070bf:	6a 00                	push   $0x0
801070c1:	68 fa 03 00 00       	push   $0x3fa
801070c6:	e8 cf ff ff ff       	call   8010709a <outb>
801070cb:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801070ce:	68 80 00 00 00       	push   $0x80
801070d3:	68 fb 03 00 00       	push   $0x3fb
801070d8:	e8 bd ff ff ff       	call   8010709a <outb>
801070dd:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
801070e0:	6a 0c                	push   $0xc
801070e2:	68 f8 03 00 00       	push   $0x3f8
801070e7:	e8 ae ff ff ff       	call   8010709a <outb>
801070ec:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
801070ef:	6a 00                	push   $0x0
801070f1:	68 f9 03 00 00       	push   $0x3f9
801070f6:	e8 9f ff ff ff       	call   8010709a <outb>
801070fb:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801070fe:	6a 03                	push   $0x3
80107100:	68 fb 03 00 00       	push   $0x3fb
80107105:	e8 90 ff ff ff       	call   8010709a <outb>
8010710a:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
8010710d:	6a 00                	push   $0x0
8010710f:	68 fc 03 00 00       	push   $0x3fc
80107114:	e8 81 ff ff ff       	call   8010709a <outb>
80107119:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
8010711c:	6a 01                	push   $0x1
8010711e:	68 f9 03 00 00       	push   $0x3f9
80107123:	e8 72 ff ff ff       	call   8010709a <outb>
80107128:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010712b:	68 fd 03 00 00       	push   $0x3fd
80107130:	e8 48 ff ff ff       	call   8010707d <inb>
80107135:	83 c4 04             	add    $0x4,%esp
80107138:	3c ff                	cmp    $0xff,%al
8010713a:	74 61                	je     8010719d <uartinit+0xe4>
    return;
  uart = 1;
8010713c:	c7 05 44 c6 10 80 01 	movl   $0x1,0x8010c644
80107143:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107146:	68 fa 03 00 00       	push   $0x3fa
8010714b:	e8 2d ff ff ff       	call   8010707d <inb>
80107150:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80107153:	68 f8 03 00 00       	push   $0x3f8
80107158:	e8 20 ff ff ff       	call   8010707d <inb>
8010715d:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
80107160:	83 ec 08             	sub    $0x8,%esp
80107163:	6a 00                	push   $0x0
80107165:	6a 04                	push   $0x4
80107167:	e8 05 ba ff ff       	call   80102b71 <ioapicenable>
8010716c:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010716f:	c7 45 f4 84 90 10 80 	movl   $0x80109084,-0xc(%ebp)
80107176:	eb 19                	jmp    80107191 <uartinit+0xd8>
    uartputc(*p);
80107178:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010717b:	0f b6 00             	movzbl (%eax),%eax
8010717e:	0f be c0             	movsbl %al,%eax
80107181:	83 ec 0c             	sub    $0xc,%esp
80107184:	50                   	push   %eax
80107185:	e8 16 00 00 00       	call   801071a0 <uartputc>
8010718a:	83 c4 10             	add    $0x10,%esp
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010718d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107191:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107194:	0f b6 00             	movzbl (%eax),%eax
80107197:	84 c0                	test   %al,%al
80107199:	75 dd                	jne    80107178 <uartinit+0xbf>
8010719b:	eb 01                	jmp    8010719e <uartinit+0xe5>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
8010719d:	90                   	nop
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
8010719e:	c9                   	leave  
8010719f:	c3                   	ret    

801071a0 <uartputc>:

void
uartputc(int c)
{
801071a0:	55                   	push   %ebp
801071a1:	89 e5                	mov    %esp,%ebp
801071a3:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
801071a6:	a1 44 c6 10 80       	mov    0x8010c644,%eax
801071ab:	85 c0                	test   %eax,%eax
801071ad:	74 53                	je     80107202 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801071af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801071b6:	eb 11                	jmp    801071c9 <uartputc+0x29>
    microdelay(10);
801071b8:	83 ec 0c             	sub    $0xc,%esp
801071bb:	6a 0a                	push   $0xa
801071bd:	e8 b3 be ff ff       	call   80103075 <microdelay>
801071c2:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801071c5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801071c9:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801071cd:	7f 1a                	jg     801071e9 <uartputc+0x49>
801071cf:	83 ec 0c             	sub    $0xc,%esp
801071d2:	68 fd 03 00 00       	push   $0x3fd
801071d7:	e8 a1 fe ff ff       	call   8010707d <inb>
801071dc:	83 c4 10             	add    $0x10,%esp
801071df:	0f b6 c0             	movzbl %al,%eax
801071e2:	83 e0 20             	and    $0x20,%eax
801071e5:	85 c0                	test   %eax,%eax
801071e7:	74 cf                	je     801071b8 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
801071e9:	8b 45 08             	mov    0x8(%ebp),%eax
801071ec:	0f b6 c0             	movzbl %al,%eax
801071ef:	83 ec 08             	sub    $0x8,%esp
801071f2:	50                   	push   %eax
801071f3:	68 f8 03 00 00       	push   $0x3f8
801071f8:	e8 9d fe ff ff       	call   8010709a <outb>
801071fd:	83 c4 10             	add    $0x10,%esp
80107200:	eb 01                	jmp    80107203 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80107202:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80107203:	c9                   	leave  
80107204:	c3                   	ret    

80107205 <uartgetc>:

static int
uartgetc(void)
{
80107205:	55                   	push   %ebp
80107206:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107208:	a1 44 c6 10 80       	mov    0x8010c644,%eax
8010720d:	85 c0                	test   %eax,%eax
8010720f:	75 07                	jne    80107218 <uartgetc+0x13>
    return -1;
80107211:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107216:	eb 2e                	jmp    80107246 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80107218:	68 fd 03 00 00       	push   $0x3fd
8010721d:	e8 5b fe ff ff       	call   8010707d <inb>
80107222:	83 c4 04             	add    $0x4,%esp
80107225:	0f b6 c0             	movzbl %al,%eax
80107228:	83 e0 01             	and    $0x1,%eax
8010722b:	85 c0                	test   %eax,%eax
8010722d:	75 07                	jne    80107236 <uartgetc+0x31>
    return -1;
8010722f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107234:	eb 10                	jmp    80107246 <uartgetc+0x41>
  return inb(COM1+0);
80107236:	68 f8 03 00 00       	push   $0x3f8
8010723b:	e8 3d fe ff ff       	call   8010707d <inb>
80107240:	83 c4 04             	add    $0x4,%esp
80107243:	0f b6 c0             	movzbl %al,%eax
}
80107246:	c9                   	leave  
80107247:	c3                   	ret    

80107248 <uartintr>:

void
uartintr(void)
{
80107248:	55                   	push   %ebp
80107249:	89 e5                	mov    %esp,%ebp
8010724b:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
8010724e:	83 ec 0c             	sub    $0xc,%esp
80107251:	68 05 72 10 80       	push   $0x80107205
80107256:	e8 d1 95 ff ff       	call   8010082c <consoleintr>
8010725b:	83 c4 10             	add    $0x10,%esp
}
8010725e:	90                   	nop
8010725f:	c9                   	leave  
80107260:	c3                   	ret    

80107261 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107261:	6a 00                	push   $0x0
  pushl $0
80107263:	6a 00                	push   $0x0
  jmp alltraps
80107265:	e9 b7 f5 ff ff       	jmp    80106821 <alltraps>

8010726a <vector1>:
.globl vector1
vector1:
  pushl $0
8010726a:	6a 00                	push   $0x0
  pushl $1
8010726c:	6a 01                	push   $0x1
  jmp alltraps
8010726e:	e9 ae f5 ff ff       	jmp    80106821 <alltraps>

80107273 <vector2>:
.globl vector2
vector2:
  pushl $0
80107273:	6a 00                	push   $0x0
  pushl $2
80107275:	6a 02                	push   $0x2
  jmp alltraps
80107277:	e9 a5 f5 ff ff       	jmp    80106821 <alltraps>

8010727c <vector3>:
.globl vector3
vector3:
  pushl $0
8010727c:	6a 00                	push   $0x0
  pushl $3
8010727e:	6a 03                	push   $0x3
  jmp alltraps
80107280:	e9 9c f5 ff ff       	jmp    80106821 <alltraps>

80107285 <vector4>:
.globl vector4
vector4:
  pushl $0
80107285:	6a 00                	push   $0x0
  pushl $4
80107287:	6a 04                	push   $0x4
  jmp alltraps
80107289:	e9 93 f5 ff ff       	jmp    80106821 <alltraps>

8010728e <vector5>:
.globl vector5
vector5:
  pushl $0
8010728e:	6a 00                	push   $0x0
  pushl $5
80107290:	6a 05                	push   $0x5
  jmp alltraps
80107292:	e9 8a f5 ff ff       	jmp    80106821 <alltraps>

80107297 <vector6>:
.globl vector6
vector6:
  pushl $0
80107297:	6a 00                	push   $0x0
  pushl $6
80107299:	6a 06                	push   $0x6
  jmp alltraps
8010729b:	e9 81 f5 ff ff       	jmp    80106821 <alltraps>

801072a0 <vector7>:
.globl vector7
vector7:
  pushl $0
801072a0:	6a 00                	push   $0x0
  pushl $7
801072a2:	6a 07                	push   $0x7
  jmp alltraps
801072a4:	e9 78 f5 ff ff       	jmp    80106821 <alltraps>

801072a9 <vector8>:
.globl vector8
vector8:
  pushl $8
801072a9:	6a 08                	push   $0x8
  jmp alltraps
801072ab:	e9 71 f5 ff ff       	jmp    80106821 <alltraps>

801072b0 <vector9>:
.globl vector9
vector9:
  pushl $0
801072b0:	6a 00                	push   $0x0
  pushl $9
801072b2:	6a 09                	push   $0x9
  jmp alltraps
801072b4:	e9 68 f5 ff ff       	jmp    80106821 <alltraps>

801072b9 <vector10>:
.globl vector10
vector10:
  pushl $10
801072b9:	6a 0a                	push   $0xa
  jmp alltraps
801072bb:	e9 61 f5 ff ff       	jmp    80106821 <alltraps>

801072c0 <vector11>:
.globl vector11
vector11:
  pushl $11
801072c0:	6a 0b                	push   $0xb
  jmp alltraps
801072c2:	e9 5a f5 ff ff       	jmp    80106821 <alltraps>

801072c7 <vector12>:
.globl vector12
vector12:
  pushl $12
801072c7:	6a 0c                	push   $0xc
  jmp alltraps
801072c9:	e9 53 f5 ff ff       	jmp    80106821 <alltraps>

801072ce <vector13>:
.globl vector13
vector13:
  pushl $13
801072ce:	6a 0d                	push   $0xd
  jmp alltraps
801072d0:	e9 4c f5 ff ff       	jmp    80106821 <alltraps>

801072d5 <vector14>:
.globl vector14
vector14:
  pushl $14
801072d5:	6a 0e                	push   $0xe
  jmp alltraps
801072d7:	e9 45 f5 ff ff       	jmp    80106821 <alltraps>

801072dc <vector15>:
.globl vector15
vector15:
  pushl $0
801072dc:	6a 00                	push   $0x0
  pushl $15
801072de:	6a 0f                	push   $0xf
  jmp alltraps
801072e0:	e9 3c f5 ff ff       	jmp    80106821 <alltraps>

801072e5 <vector16>:
.globl vector16
vector16:
  pushl $0
801072e5:	6a 00                	push   $0x0
  pushl $16
801072e7:	6a 10                	push   $0x10
  jmp alltraps
801072e9:	e9 33 f5 ff ff       	jmp    80106821 <alltraps>

801072ee <vector17>:
.globl vector17
vector17:
  pushl $17
801072ee:	6a 11                	push   $0x11
  jmp alltraps
801072f0:	e9 2c f5 ff ff       	jmp    80106821 <alltraps>

801072f5 <vector18>:
.globl vector18
vector18:
  pushl $0
801072f5:	6a 00                	push   $0x0
  pushl $18
801072f7:	6a 12                	push   $0x12
  jmp alltraps
801072f9:	e9 23 f5 ff ff       	jmp    80106821 <alltraps>

801072fe <vector19>:
.globl vector19
vector19:
  pushl $0
801072fe:	6a 00                	push   $0x0
  pushl $19
80107300:	6a 13                	push   $0x13
  jmp alltraps
80107302:	e9 1a f5 ff ff       	jmp    80106821 <alltraps>

80107307 <vector20>:
.globl vector20
vector20:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $20
80107309:	6a 14                	push   $0x14
  jmp alltraps
8010730b:	e9 11 f5 ff ff       	jmp    80106821 <alltraps>

80107310 <vector21>:
.globl vector21
vector21:
  pushl $0
80107310:	6a 00                	push   $0x0
  pushl $21
80107312:	6a 15                	push   $0x15
  jmp alltraps
80107314:	e9 08 f5 ff ff       	jmp    80106821 <alltraps>

80107319 <vector22>:
.globl vector22
vector22:
  pushl $0
80107319:	6a 00                	push   $0x0
  pushl $22
8010731b:	6a 16                	push   $0x16
  jmp alltraps
8010731d:	e9 ff f4 ff ff       	jmp    80106821 <alltraps>

80107322 <vector23>:
.globl vector23
vector23:
  pushl $0
80107322:	6a 00                	push   $0x0
  pushl $23
80107324:	6a 17                	push   $0x17
  jmp alltraps
80107326:	e9 f6 f4 ff ff       	jmp    80106821 <alltraps>

8010732b <vector24>:
.globl vector24
vector24:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $24
8010732d:	6a 18                	push   $0x18
  jmp alltraps
8010732f:	e9 ed f4 ff ff       	jmp    80106821 <alltraps>

80107334 <vector25>:
.globl vector25
vector25:
  pushl $0
80107334:	6a 00                	push   $0x0
  pushl $25
80107336:	6a 19                	push   $0x19
  jmp alltraps
80107338:	e9 e4 f4 ff ff       	jmp    80106821 <alltraps>

8010733d <vector26>:
.globl vector26
vector26:
  pushl $0
8010733d:	6a 00                	push   $0x0
  pushl $26
8010733f:	6a 1a                	push   $0x1a
  jmp alltraps
80107341:	e9 db f4 ff ff       	jmp    80106821 <alltraps>

80107346 <vector27>:
.globl vector27
vector27:
  pushl $0
80107346:	6a 00                	push   $0x0
  pushl $27
80107348:	6a 1b                	push   $0x1b
  jmp alltraps
8010734a:	e9 d2 f4 ff ff       	jmp    80106821 <alltraps>

8010734f <vector28>:
.globl vector28
vector28:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $28
80107351:	6a 1c                	push   $0x1c
  jmp alltraps
80107353:	e9 c9 f4 ff ff       	jmp    80106821 <alltraps>

80107358 <vector29>:
.globl vector29
vector29:
  pushl $0
80107358:	6a 00                	push   $0x0
  pushl $29
8010735a:	6a 1d                	push   $0x1d
  jmp alltraps
8010735c:	e9 c0 f4 ff ff       	jmp    80106821 <alltraps>

80107361 <vector30>:
.globl vector30
vector30:
  pushl $0
80107361:	6a 00                	push   $0x0
  pushl $30
80107363:	6a 1e                	push   $0x1e
  jmp alltraps
80107365:	e9 b7 f4 ff ff       	jmp    80106821 <alltraps>

8010736a <vector31>:
.globl vector31
vector31:
  pushl $0
8010736a:	6a 00                	push   $0x0
  pushl $31
8010736c:	6a 1f                	push   $0x1f
  jmp alltraps
8010736e:	e9 ae f4 ff ff       	jmp    80106821 <alltraps>

80107373 <vector32>:
.globl vector32
vector32:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $32
80107375:	6a 20                	push   $0x20
  jmp alltraps
80107377:	e9 a5 f4 ff ff       	jmp    80106821 <alltraps>

8010737c <vector33>:
.globl vector33
vector33:
  pushl $0
8010737c:	6a 00                	push   $0x0
  pushl $33
8010737e:	6a 21                	push   $0x21
  jmp alltraps
80107380:	e9 9c f4 ff ff       	jmp    80106821 <alltraps>

80107385 <vector34>:
.globl vector34
vector34:
  pushl $0
80107385:	6a 00                	push   $0x0
  pushl $34
80107387:	6a 22                	push   $0x22
  jmp alltraps
80107389:	e9 93 f4 ff ff       	jmp    80106821 <alltraps>

8010738e <vector35>:
.globl vector35
vector35:
  pushl $0
8010738e:	6a 00                	push   $0x0
  pushl $35
80107390:	6a 23                	push   $0x23
  jmp alltraps
80107392:	e9 8a f4 ff ff       	jmp    80106821 <alltraps>

80107397 <vector36>:
.globl vector36
vector36:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $36
80107399:	6a 24                	push   $0x24
  jmp alltraps
8010739b:	e9 81 f4 ff ff       	jmp    80106821 <alltraps>

801073a0 <vector37>:
.globl vector37
vector37:
  pushl $0
801073a0:	6a 00                	push   $0x0
  pushl $37
801073a2:	6a 25                	push   $0x25
  jmp alltraps
801073a4:	e9 78 f4 ff ff       	jmp    80106821 <alltraps>

801073a9 <vector38>:
.globl vector38
vector38:
  pushl $0
801073a9:	6a 00                	push   $0x0
  pushl $38
801073ab:	6a 26                	push   $0x26
  jmp alltraps
801073ad:	e9 6f f4 ff ff       	jmp    80106821 <alltraps>

801073b2 <vector39>:
.globl vector39
vector39:
  pushl $0
801073b2:	6a 00                	push   $0x0
  pushl $39
801073b4:	6a 27                	push   $0x27
  jmp alltraps
801073b6:	e9 66 f4 ff ff       	jmp    80106821 <alltraps>

801073bb <vector40>:
.globl vector40
vector40:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $40
801073bd:	6a 28                	push   $0x28
  jmp alltraps
801073bf:	e9 5d f4 ff ff       	jmp    80106821 <alltraps>

801073c4 <vector41>:
.globl vector41
vector41:
  pushl $0
801073c4:	6a 00                	push   $0x0
  pushl $41
801073c6:	6a 29                	push   $0x29
  jmp alltraps
801073c8:	e9 54 f4 ff ff       	jmp    80106821 <alltraps>

801073cd <vector42>:
.globl vector42
vector42:
  pushl $0
801073cd:	6a 00                	push   $0x0
  pushl $42
801073cf:	6a 2a                	push   $0x2a
  jmp alltraps
801073d1:	e9 4b f4 ff ff       	jmp    80106821 <alltraps>

801073d6 <vector43>:
.globl vector43
vector43:
  pushl $0
801073d6:	6a 00                	push   $0x0
  pushl $43
801073d8:	6a 2b                	push   $0x2b
  jmp alltraps
801073da:	e9 42 f4 ff ff       	jmp    80106821 <alltraps>

801073df <vector44>:
.globl vector44
vector44:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $44
801073e1:	6a 2c                	push   $0x2c
  jmp alltraps
801073e3:	e9 39 f4 ff ff       	jmp    80106821 <alltraps>

801073e8 <vector45>:
.globl vector45
vector45:
  pushl $0
801073e8:	6a 00                	push   $0x0
  pushl $45
801073ea:	6a 2d                	push   $0x2d
  jmp alltraps
801073ec:	e9 30 f4 ff ff       	jmp    80106821 <alltraps>

801073f1 <vector46>:
.globl vector46
vector46:
  pushl $0
801073f1:	6a 00                	push   $0x0
  pushl $46
801073f3:	6a 2e                	push   $0x2e
  jmp alltraps
801073f5:	e9 27 f4 ff ff       	jmp    80106821 <alltraps>

801073fa <vector47>:
.globl vector47
vector47:
  pushl $0
801073fa:	6a 00                	push   $0x0
  pushl $47
801073fc:	6a 2f                	push   $0x2f
  jmp alltraps
801073fe:	e9 1e f4 ff ff       	jmp    80106821 <alltraps>

80107403 <vector48>:
.globl vector48
vector48:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $48
80107405:	6a 30                	push   $0x30
  jmp alltraps
80107407:	e9 15 f4 ff ff       	jmp    80106821 <alltraps>

8010740c <vector49>:
.globl vector49
vector49:
  pushl $0
8010740c:	6a 00                	push   $0x0
  pushl $49
8010740e:	6a 31                	push   $0x31
  jmp alltraps
80107410:	e9 0c f4 ff ff       	jmp    80106821 <alltraps>

80107415 <vector50>:
.globl vector50
vector50:
  pushl $0
80107415:	6a 00                	push   $0x0
  pushl $50
80107417:	6a 32                	push   $0x32
  jmp alltraps
80107419:	e9 03 f4 ff ff       	jmp    80106821 <alltraps>

8010741e <vector51>:
.globl vector51
vector51:
  pushl $0
8010741e:	6a 00                	push   $0x0
  pushl $51
80107420:	6a 33                	push   $0x33
  jmp alltraps
80107422:	e9 fa f3 ff ff       	jmp    80106821 <alltraps>

80107427 <vector52>:
.globl vector52
vector52:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $52
80107429:	6a 34                	push   $0x34
  jmp alltraps
8010742b:	e9 f1 f3 ff ff       	jmp    80106821 <alltraps>

80107430 <vector53>:
.globl vector53
vector53:
  pushl $0
80107430:	6a 00                	push   $0x0
  pushl $53
80107432:	6a 35                	push   $0x35
  jmp alltraps
80107434:	e9 e8 f3 ff ff       	jmp    80106821 <alltraps>

80107439 <vector54>:
.globl vector54
vector54:
  pushl $0
80107439:	6a 00                	push   $0x0
  pushl $54
8010743b:	6a 36                	push   $0x36
  jmp alltraps
8010743d:	e9 df f3 ff ff       	jmp    80106821 <alltraps>

80107442 <vector55>:
.globl vector55
vector55:
  pushl $0
80107442:	6a 00                	push   $0x0
  pushl $55
80107444:	6a 37                	push   $0x37
  jmp alltraps
80107446:	e9 d6 f3 ff ff       	jmp    80106821 <alltraps>

8010744b <vector56>:
.globl vector56
vector56:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $56
8010744d:	6a 38                	push   $0x38
  jmp alltraps
8010744f:	e9 cd f3 ff ff       	jmp    80106821 <alltraps>

80107454 <vector57>:
.globl vector57
vector57:
  pushl $0
80107454:	6a 00                	push   $0x0
  pushl $57
80107456:	6a 39                	push   $0x39
  jmp alltraps
80107458:	e9 c4 f3 ff ff       	jmp    80106821 <alltraps>

8010745d <vector58>:
.globl vector58
vector58:
  pushl $0
8010745d:	6a 00                	push   $0x0
  pushl $58
8010745f:	6a 3a                	push   $0x3a
  jmp alltraps
80107461:	e9 bb f3 ff ff       	jmp    80106821 <alltraps>

80107466 <vector59>:
.globl vector59
vector59:
  pushl $0
80107466:	6a 00                	push   $0x0
  pushl $59
80107468:	6a 3b                	push   $0x3b
  jmp alltraps
8010746a:	e9 b2 f3 ff ff       	jmp    80106821 <alltraps>

8010746f <vector60>:
.globl vector60
vector60:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $60
80107471:	6a 3c                	push   $0x3c
  jmp alltraps
80107473:	e9 a9 f3 ff ff       	jmp    80106821 <alltraps>

80107478 <vector61>:
.globl vector61
vector61:
  pushl $0
80107478:	6a 00                	push   $0x0
  pushl $61
8010747a:	6a 3d                	push   $0x3d
  jmp alltraps
8010747c:	e9 a0 f3 ff ff       	jmp    80106821 <alltraps>

80107481 <vector62>:
.globl vector62
vector62:
  pushl $0
80107481:	6a 00                	push   $0x0
  pushl $62
80107483:	6a 3e                	push   $0x3e
  jmp alltraps
80107485:	e9 97 f3 ff ff       	jmp    80106821 <alltraps>

8010748a <vector63>:
.globl vector63
vector63:
  pushl $0
8010748a:	6a 00                	push   $0x0
  pushl $63
8010748c:	6a 3f                	push   $0x3f
  jmp alltraps
8010748e:	e9 8e f3 ff ff       	jmp    80106821 <alltraps>

80107493 <vector64>:
.globl vector64
vector64:
  pushl $0
80107493:	6a 00                	push   $0x0
  pushl $64
80107495:	6a 40                	push   $0x40
  jmp alltraps
80107497:	e9 85 f3 ff ff       	jmp    80106821 <alltraps>

8010749c <vector65>:
.globl vector65
vector65:
  pushl $0
8010749c:	6a 00                	push   $0x0
  pushl $65
8010749e:	6a 41                	push   $0x41
  jmp alltraps
801074a0:	e9 7c f3 ff ff       	jmp    80106821 <alltraps>

801074a5 <vector66>:
.globl vector66
vector66:
  pushl $0
801074a5:	6a 00                	push   $0x0
  pushl $66
801074a7:	6a 42                	push   $0x42
  jmp alltraps
801074a9:	e9 73 f3 ff ff       	jmp    80106821 <alltraps>

801074ae <vector67>:
.globl vector67
vector67:
  pushl $0
801074ae:	6a 00                	push   $0x0
  pushl $67
801074b0:	6a 43                	push   $0x43
  jmp alltraps
801074b2:	e9 6a f3 ff ff       	jmp    80106821 <alltraps>

801074b7 <vector68>:
.globl vector68
vector68:
  pushl $0
801074b7:	6a 00                	push   $0x0
  pushl $68
801074b9:	6a 44                	push   $0x44
  jmp alltraps
801074bb:	e9 61 f3 ff ff       	jmp    80106821 <alltraps>

801074c0 <vector69>:
.globl vector69
vector69:
  pushl $0
801074c0:	6a 00                	push   $0x0
  pushl $69
801074c2:	6a 45                	push   $0x45
  jmp alltraps
801074c4:	e9 58 f3 ff ff       	jmp    80106821 <alltraps>

801074c9 <vector70>:
.globl vector70
vector70:
  pushl $0
801074c9:	6a 00                	push   $0x0
  pushl $70
801074cb:	6a 46                	push   $0x46
  jmp alltraps
801074cd:	e9 4f f3 ff ff       	jmp    80106821 <alltraps>

801074d2 <vector71>:
.globl vector71
vector71:
  pushl $0
801074d2:	6a 00                	push   $0x0
  pushl $71
801074d4:	6a 47                	push   $0x47
  jmp alltraps
801074d6:	e9 46 f3 ff ff       	jmp    80106821 <alltraps>

801074db <vector72>:
.globl vector72
vector72:
  pushl $0
801074db:	6a 00                	push   $0x0
  pushl $72
801074dd:	6a 48                	push   $0x48
  jmp alltraps
801074df:	e9 3d f3 ff ff       	jmp    80106821 <alltraps>

801074e4 <vector73>:
.globl vector73
vector73:
  pushl $0
801074e4:	6a 00                	push   $0x0
  pushl $73
801074e6:	6a 49                	push   $0x49
  jmp alltraps
801074e8:	e9 34 f3 ff ff       	jmp    80106821 <alltraps>

801074ed <vector74>:
.globl vector74
vector74:
  pushl $0
801074ed:	6a 00                	push   $0x0
  pushl $74
801074ef:	6a 4a                	push   $0x4a
  jmp alltraps
801074f1:	e9 2b f3 ff ff       	jmp    80106821 <alltraps>

801074f6 <vector75>:
.globl vector75
vector75:
  pushl $0
801074f6:	6a 00                	push   $0x0
  pushl $75
801074f8:	6a 4b                	push   $0x4b
  jmp alltraps
801074fa:	e9 22 f3 ff ff       	jmp    80106821 <alltraps>

801074ff <vector76>:
.globl vector76
vector76:
  pushl $0
801074ff:	6a 00                	push   $0x0
  pushl $76
80107501:	6a 4c                	push   $0x4c
  jmp alltraps
80107503:	e9 19 f3 ff ff       	jmp    80106821 <alltraps>

80107508 <vector77>:
.globl vector77
vector77:
  pushl $0
80107508:	6a 00                	push   $0x0
  pushl $77
8010750a:	6a 4d                	push   $0x4d
  jmp alltraps
8010750c:	e9 10 f3 ff ff       	jmp    80106821 <alltraps>

80107511 <vector78>:
.globl vector78
vector78:
  pushl $0
80107511:	6a 00                	push   $0x0
  pushl $78
80107513:	6a 4e                	push   $0x4e
  jmp alltraps
80107515:	e9 07 f3 ff ff       	jmp    80106821 <alltraps>

8010751a <vector79>:
.globl vector79
vector79:
  pushl $0
8010751a:	6a 00                	push   $0x0
  pushl $79
8010751c:	6a 4f                	push   $0x4f
  jmp alltraps
8010751e:	e9 fe f2 ff ff       	jmp    80106821 <alltraps>

80107523 <vector80>:
.globl vector80
vector80:
  pushl $0
80107523:	6a 00                	push   $0x0
  pushl $80
80107525:	6a 50                	push   $0x50
  jmp alltraps
80107527:	e9 f5 f2 ff ff       	jmp    80106821 <alltraps>

8010752c <vector81>:
.globl vector81
vector81:
  pushl $0
8010752c:	6a 00                	push   $0x0
  pushl $81
8010752e:	6a 51                	push   $0x51
  jmp alltraps
80107530:	e9 ec f2 ff ff       	jmp    80106821 <alltraps>

80107535 <vector82>:
.globl vector82
vector82:
  pushl $0
80107535:	6a 00                	push   $0x0
  pushl $82
80107537:	6a 52                	push   $0x52
  jmp alltraps
80107539:	e9 e3 f2 ff ff       	jmp    80106821 <alltraps>

8010753e <vector83>:
.globl vector83
vector83:
  pushl $0
8010753e:	6a 00                	push   $0x0
  pushl $83
80107540:	6a 53                	push   $0x53
  jmp alltraps
80107542:	e9 da f2 ff ff       	jmp    80106821 <alltraps>

80107547 <vector84>:
.globl vector84
vector84:
  pushl $0
80107547:	6a 00                	push   $0x0
  pushl $84
80107549:	6a 54                	push   $0x54
  jmp alltraps
8010754b:	e9 d1 f2 ff ff       	jmp    80106821 <alltraps>

80107550 <vector85>:
.globl vector85
vector85:
  pushl $0
80107550:	6a 00                	push   $0x0
  pushl $85
80107552:	6a 55                	push   $0x55
  jmp alltraps
80107554:	e9 c8 f2 ff ff       	jmp    80106821 <alltraps>

80107559 <vector86>:
.globl vector86
vector86:
  pushl $0
80107559:	6a 00                	push   $0x0
  pushl $86
8010755b:	6a 56                	push   $0x56
  jmp alltraps
8010755d:	e9 bf f2 ff ff       	jmp    80106821 <alltraps>

80107562 <vector87>:
.globl vector87
vector87:
  pushl $0
80107562:	6a 00                	push   $0x0
  pushl $87
80107564:	6a 57                	push   $0x57
  jmp alltraps
80107566:	e9 b6 f2 ff ff       	jmp    80106821 <alltraps>

8010756b <vector88>:
.globl vector88
vector88:
  pushl $0
8010756b:	6a 00                	push   $0x0
  pushl $88
8010756d:	6a 58                	push   $0x58
  jmp alltraps
8010756f:	e9 ad f2 ff ff       	jmp    80106821 <alltraps>

80107574 <vector89>:
.globl vector89
vector89:
  pushl $0
80107574:	6a 00                	push   $0x0
  pushl $89
80107576:	6a 59                	push   $0x59
  jmp alltraps
80107578:	e9 a4 f2 ff ff       	jmp    80106821 <alltraps>

8010757d <vector90>:
.globl vector90
vector90:
  pushl $0
8010757d:	6a 00                	push   $0x0
  pushl $90
8010757f:	6a 5a                	push   $0x5a
  jmp alltraps
80107581:	e9 9b f2 ff ff       	jmp    80106821 <alltraps>

80107586 <vector91>:
.globl vector91
vector91:
  pushl $0
80107586:	6a 00                	push   $0x0
  pushl $91
80107588:	6a 5b                	push   $0x5b
  jmp alltraps
8010758a:	e9 92 f2 ff ff       	jmp    80106821 <alltraps>

8010758f <vector92>:
.globl vector92
vector92:
  pushl $0
8010758f:	6a 00                	push   $0x0
  pushl $92
80107591:	6a 5c                	push   $0x5c
  jmp alltraps
80107593:	e9 89 f2 ff ff       	jmp    80106821 <alltraps>

80107598 <vector93>:
.globl vector93
vector93:
  pushl $0
80107598:	6a 00                	push   $0x0
  pushl $93
8010759a:	6a 5d                	push   $0x5d
  jmp alltraps
8010759c:	e9 80 f2 ff ff       	jmp    80106821 <alltraps>

801075a1 <vector94>:
.globl vector94
vector94:
  pushl $0
801075a1:	6a 00                	push   $0x0
  pushl $94
801075a3:	6a 5e                	push   $0x5e
  jmp alltraps
801075a5:	e9 77 f2 ff ff       	jmp    80106821 <alltraps>

801075aa <vector95>:
.globl vector95
vector95:
  pushl $0
801075aa:	6a 00                	push   $0x0
  pushl $95
801075ac:	6a 5f                	push   $0x5f
  jmp alltraps
801075ae:	e9 6e f2 ff ff       	jmp    80106821 <alltraps>

801075b3 <vector96>:
.globl vector96
vector96:
  pushl $0
801075b3:	6a 00                	push   $0x0
  pushl $96
801075b5:	6a 60                	push   $0x60
  jmp alltraps
801075b7:	e9 65 f2 ff ff       	jmp    80106821 <alltraps>

801075bc <vector97>:
.globl vector97
vector97:
  pushl $0
801075bc:	6a 00                	push   $0x0
  pushl $97
801075be:	6a 61                	push   $0x61
  jmp alltraps
801075c0:	e9 5c f2 ff ff       	jmp    80106821 <alltraps>

801075c5 <vector98>:
.globl vector98
vector98:
  pushl $0
801075c5:	6a 00                	push   $0x0
  pushl $98
801075c7:	6a 62                	push   $0x62
  jmp alltraps
801075c9:	e9 53 f2 ff ff       	jmp    80106821 <alltraps>

801075ce <vector99>:
.globl vector99
vector99:
  pushl $0
801075ce:	6a 00                	push   $0x0
  pushl $99
801075d0:	6a 63                	push   $0x63
  jmp alltraps
801075d2:	e9 4a f2 ff ff       	jmp    80106821 <alltraps>

801075d7 <vector100>:
.globl vector100
vector100:
  pushl $0
801075d7:	6a 00                	push   $0x0
  pushl $100
801075d9:	6a 64                	push   $0x64
  jmp alltraps
801075db:	e9 41 f2 ff ff       	jmp    80106821 <alltraps>

801075e0 <vector101>:
.globl vector101
vector101:
  pushl $0
801075e0:	6a 00                	push   $0x0
  pushl $101
801075e2:	6a 65                	push   $0x65
  jmp alltraps
801075e4:	e9 38 f2 ff ff       	jmp    80106821 <alltraps>

801075e9 <vector102>:
.globl vector102
vector102:
  pushl $0
801075e9:	6a 00                	push   $0x0
  pushl $102
801075eb:	6a 66                	push   $0x66
  jmp alltraps
801075ed:	e9 2f f2 ff ff       	jmp    80106821 <alltraps>

801075f2 <vector103>:
.globl vector103
vector103:
  pushl $0
801075f2:	6a 00                	push   $0x0
  pushl $103
801075f4:	6a 67                	push   $0x67
  jmp alltraps
801075f6:	e9 26 f2 ff ff       	jmp    80106821 <alltraps>

801075fb <vector104>:
.globl vector104
vector104:
  pushl $0
801075fb:	6a 00                	push   $0x0
  pushl $104
801075fd:	6a 68                	push   $0x68
  jmp alltraps
801075ff:	e9 1d f2 ff ff       	jmp    80106821 <alltraps>

80107604 <vector105>:
.globl vector105
vector105:
  pushl $0
80107604:	6a 00                	push   $0x0
  pushl $105
80107606:	6a 69                	push   $0x69
  jmp alltraps
80107608:	e9 14 f2 ff ff       	jmp    80106821 <alltraps>

8010760d <vector106>:
.globl vector106
vector106:
  pushl $0
8010760d:	6a 00                	push   $0x0
  pushl $106
8010760f:	6a 6a                	push   $0x6a
  jmp alltraps
80107611:	e9 0b f2 ff ff       	jmp    80106821 <alltraps>

80107616 <vector107>:
.globl vector107
vector107:
  pushl $0
80107616:	6a 00                	push   $0x0
  pushl $107
80107618:	6a 6b                	push   $0x6b
  jmp alltraps
8010761a:	e9 02 f2 ff ff       	jmp    80106821 <alltraps>

8010761f <vector108>:
.globl vector108
vector108:
  pushl $0
8010761f:	6a 00                	push   $0x0
  pushl $108
80107621:	6a 6c                	push   $0x6c
  jmp alltraps
80107623:	e9 f9 f1 ff ff       	jmp    80106821 <alltraps>

80107628 <vector109>:
.globl vector109
vector109:
  pushl $0
80107628:	6a 00                	push   $0x0
  pushl $109
8010762a:	6a 6d                	push   $0x6d
  jmp alltraps
8010762c:	e9 f0 f1 ff ff       	jmp    80106821 <alltraps>

80107631 <vector110>:
.globl vector110
vector110:
  pushl $0
80107631:	6a 00                	push   $0x0
  pushl $110
80107633:	6a 6e                	push   $0x6e
  jmp alltraps
80107635:	e9 e7 f1 ff ff       	jmp    80106821 <alltraps>

8010763a <vector111>:
.globl vector111
vector111:
  pushl $0
8010763a:	6a 00                	push   $0x0
  pushl $111
8010763c:	6a 6f                	push   $0x6f
  jmp alltraps
8010763e:	e9 de f1 ff ff       	jmp    80106821 <alltraps>

80107643 <vector112>:
.globl vector112
vector112:
  pushl $0
80107643:	6a 00                	push   $0x0
  pushl $112
80107645:	6a 70                	push   $0x70
  jmp alltraps
80107647:	e9 d5 f1 ff ff       	jmp    80106821 <alltraps>

8010764c <vector113>:
.globl vector113
vector113:
  pushl $0
8010764c:	6a 00                	push   $0x0
  pushl $113
8010764e:	6a 71                	push   $0x71
  jmp alltraps
80107650:	e9 cc f1 ff ff       	jmp    80106821 <alltraps>

80107655 <vector114>:
.globl vector114
vector114:
  pushl $0
80107655:	6a 00                	push   $0x0
  pushl $114
80107657:	6a 72                	push   $0x72
  jmp alltraps
80107659:	e9 c3 f1 ff ff       	jmp    80106821 <alltraps>

8010765e <vector115>:
.globl vector115
vector115:
  pushl $0
8010765e:	6a 00                	push   $0x0
  pushl $115
80107660:	6a 73                	push   $0x73
  jmp alltraps
80107662:	e9 ba f1 ff ff       	jmp    80106821 <alltraps>

80107667 <vector116>:
.globl vector116
vector116:
  pushl $0
80107667:	6a 00                	push   $0x0
  pushl $116
80107669:	6a 74                	push   $0x74
  jmp alltraps
8010766b:	e9 b1 f1 ff ff       	jmp    80106821 <alltraps>

80107670 <vector117>:
.globl vector117
vector117:
  pushl $0
80107670:	6a 00                	push   $0x0
  pushl $117
80107672:	6a 75                	push   $0x75
  jmp alltraps
80107674:	e9 a8 f1 ff ff       	jmp    80106821 <alltraps>

80107679 <vector118>:
.globl vector118
vector118:
  pushl $0
80107679:	6a 00                	push   $0x0
  pushl $118
8010767b:	6a 76                	push   $0x76
  jmp alltraps
8010767d:	e9 9f f1 ff ff       	jmp    80106821 <alltraps>

80107682 <vector119>:
.globl vector119
vector119:
  pushl $0
80107682:	6a 00                	push   $0x0
  pushl $119
80107684:	6a 77                	push   $0x77
  jmp alltraps
80107686:	e9 96 f1 ff ff       	jmp    80106821 <alltraps>

8010768b <vector120>:
.globl vector120
vector120:
  pushl $0
8010768b:	6a 00                	push   $0x0
  pushl $120
8010768d:	6a 78                	push   $0x78
  jmp alltraps
8010768f:	e9 8d f1 ff ff       	jmp    80106821 <alltraps>

80107694 <vector121>:
.globl vector121
vector121:
  pushl $0
80107694:	6a 00                	push   $0x0
  pushl $121
80107696:	6a 79                	push   $0x79
  jmp alltraps
80107698:	e9 84 f1 ff ff       	jmp    80106821 <alltraps>

8010769d <vector122>:
.globl vector122
vector122:
  pushl $0
8010769d:	6a 00                	push   $0x0
  pushl $122
8010769f:	6a 7a                	push   $0x7a
  jmp alltraps
801076a1:	e9 7b f1 ff ff       	jmp    80106821 <alltraps>

801076a6 <vector123>:
.globl vector123
vector123:
  pushl $0
801076a6:	6a 00                	push   $0x0
  pushl $123
801076a8:	6a 7b                	push   $0x7b
  jmp alltraps
801076aa:	e9 72 f1 ff ff       	jmp    80106821 <alltraps>

801076af <vector124>:
.globl vector124
vector124:
  pushl $0
801076af:	6a 00                	push   $0x0
  pushl $124
801076b1:	6a 7c                	push   $0x7c
  jmp alltraps
801076b3:	e9 69 f1 ff ff       	jmp    80106821 <alltraps>

801076b8 <vector125>:
.globl vector125
vector125:
  pushl $0
801076b8:	6a 00                	push   $0x0
  pushl $125
801076ba:	6a 7d                	push   $0x7d
  jmp alltraps
801076bc:	e9 60 f1 ff ff       	jmp    80106821 <alltraps>

801076c1 <vector126>:
.globl vector126
vector126:
  pushl $0
801076c1:	6a 00                	push   $0x0
  pushl $126
801076c3:	6a 7e                	push   $0x7e
  jmp alltraps
801076c5:	e9 57 f1 ff ff       	jmp    80106821 <alltraps>

801076ca <vector127>:
.globl vector127
vector127:
  pushl $0
801076ca:	6a 00                	push   $0x0
  pushl $127
801076cc:	6a 7f                	push   $0x7f
  jmp alltraps
801076ce:	e9 4e f1 ff ff       	jmp    80106821 <alltraps>

801076d3 <vector128>:
.globl vector128
vector128:
  pushl $0
801076d3:	6a 00                	push   $0x0
  pushl $128
801076d5:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801076da:	e9 42 f1 ff ff       	jmp    80106821 <alltraps>

801076df <vector129>:
.globl vector129
vector129:
  pushl $0
801076df:	6a 00                	push   $0x0
  pushl $129
801076e1:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801076e6:	e9 36 f1 ff ff       	jmp    80106821 <alltraps>

801076eb <vector130>:
.globl vector130
vector130:
  pushl $0
801076eb:	6a 00                	push   $0x0
  pushl $130
801076ed:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801076f2:	e9 2a f1 ff ff       	jmp    80106821 <alltraps>

801076f7 <vector131>:
.globl vector131
vector131:
  pushl $0
801076f7:	6a 00                	push   $0x0
  pushl $131
801076f9:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801076fe:	e9 1e f1 ff ff       	jmp    80106821 <alltraps>

80107703 <vector132>:
.globl vector132
vector132:
  pushl $0
80107703:	6a 00                	push   $0x0
  pushl $132
80107705:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010770a:	e9 12 f1 ff ff       	jmp    80106821 <alltraps>

8010770f <vector133>:
.globl vector133
vector133:
  pushl $0
8010770f:	6a 00                	push   $0x0
  pushl $133
80107711:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107716:	e9 06 f1 ff ff       	jmp    80106821 <alltraps>

8010771b <vector134>:
.globl vector134
vector134:
  pushl $0
8010771b:	6a 00                	push   $0x0
  pushl $134
8010771d:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107722:	e9 fa f0 ff ff       	jmp    80106821 <alltraps>

80107727 <vector135>:
.globl vector135
vector135:
  pushl $0
80107727:	6a 00                	push   $0x0
  pushl $135
80107729:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010772e:	e9 ee f0 ff ff       	jmp    80106821 <alltraps>

80107733 <vector136>:
.globl vector136
vector136:
  pushl $0
80107733:	6a 00                	push   $0x0
  pushl $136
80107735:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010773a:	e9 e2 f0 ff ff       	jmp    80106821 <alltraps>

8010773f <vector137>:
.globl vector137
vector137:
  pushl $0
8010773f:	6a 00                	push   $0x0
  pushl $137
80107741:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107746:	e9 d6 f0 ff ff       	jmp    80106821 <alltraps>

8010774b <vector138>:
.globl vector138
vector138:
  pushl $0
8010774b:	6a 00                	push   $0x0
  pushl $138
8010774d:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107752:	e9 ca f0 ff ff       	jmp    80106821 <alltraps>

80107757 <vector139>:
.globl vector139
vector139:
  pushl $0
80107757:	6a 00                	push   $0x0
  pushl $139
80107759:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010775e:	e9 be f0 ff ff       	jmp    80106821 <alltraps>

80107763 <vector140>:
.globl vector140
vector140:
  pushl $0
80107763:	6a 00                	push   $0x0
  pushl $140
80107765:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010776a:	e9 b2 f0 ff ff       	jmp    80106821 <alltraps>

8010776f <vector141>:
.globl vector141
vector141:
  pushl $0
8010776f:	6a 00                	push   $0x0
  pushl $141
80107771:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107776:	e9 a6 f0 ff ff       	jmp    80106821 <alltraps>

8010777b <vector142>:
.globl vector142
vector142:
  pushl $0
8010777b:	6a 00                	push   $0x0
  pushl $142
8010777d:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107782:	e9 9a f0 ff ff       	jmp    80106821 <alltraps>

80107787 <vector143>:
.globl vector143
vector143:
  pushl $0
80107787:	6a 00                	push   $0x0
  pushl $143
80107789:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010778e:	e9 8e f0 ff ff       	jmp    80106821 <alltraps>

80107793 <vector144>:
.globl vector144
vector144:
  pushl $0
80107793:	6a 00                	push   $0x0
  pushl $144
80107795:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010779a:	e9 82 f0 ff ff       	jmp    80106821 <alltraps>

8010779f <vector145>:
.globl vector145
vector145:
  pushl $0
8010779f:	6a 00                	push   $0x0
  pushl $145
801077a1:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801077a6:	e9 76 f0 ff ff       	jmp    80106821 <alltraps>

801077ab <vector146>:
.globl vector146
vector146:
  pushl $0
801077ab:	6a 00                	push   $0x0
  pushl $146
801077ad:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801077b2:	e9 6a f0 ff ff       	jmp    80106821 <alltraps>

801077b7 <vector147>:
.globl vector147
vector147:
  pushl $0
801077b7:	6a 00                	push   $0x0
  pushl $147
801077b9:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801077be:	e9 5e f0 ff ff       	jmp    80106821 <alltraps>

801077c3 <vector148>:
.globl vector148
vector148:
  pushl $0
801077c3:	6a 00                	push   $0x0
  pushl $148
801077c5:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801077ca:	e9 52 f0 ff ff       	jmp    80106821 <alltraps>

801077cf <vector149>:
.globl vector149
vector149:
  pushl $0
801077cf:	6a 00                	push   $0x0
  pushl $149
801077d1:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801077d6:	e9 46 f0 ff ff       	jmp    80106821 <alltraps>

801077db <vector150>:
.globl vector150
vector150:
  pushl $0
801077db:	6a 00                	push   $0x0
  pushl $150
801077dd:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801077e2:	e9 3a f0 ff ff       	jmp    80106821 <alltraps>

801077e7 <vector151>:
.globl vector151
vector151:
  pushl $0
801077e7:	6a 00                	push   $0x0
  pushl $151
801077e9:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801077ee:	e9 2e f0 ff ff       	jmp    80106821 <alltraps>

801077f3 <vector152>:
.globl vector152
vector152:
  pushl $0
801077f3:	6a 00                	push   $0x0
  pushl $152
801077f5:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801077fa:	e9 22 f0 ff ff       	jmp    80106821 <alltraps>

801077ff <vector153>:
.globl vector153
vector153:
  pushl $0
801077ff:	6a 00                	push   $0x0
  pushl $153
80107801:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107806:	e9 16 f0 ff ff       	jmp    80106821 <alltraps>

8010780b <vector154>:
.globl vector154
vector154:
  pushl $0
8010780b:	6a 00                	push   $0x0
  pushl $154
8010780d:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107812:	e9 0a f0 ff ff       	jmp    80106821 <alltraps>

80107817 <vector155>:
.globl vector155
vector155:
  pushl $0
80107817:	6a 00                	push   $0x0
  pushl $155
80107819:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
8010781e:	e9 fe ef ff ff       	jmp    80106821 <alltraps>

80107823 <vector156>:
.globl vector156
vector156:
  pushl $0
80107823:	6a 00                	push   $0x0
  pushl $156
80107825:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010782a:	e9 f2 ef ff ff       	jmp    80106821 <alltraps>

8010782f <vector157>:
.globl vector157
vector157:
  pushl $0
8010782f:	6a 00                	push   $0x0
  pushl $157
80107831:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107836:	e9 e6 ef ff ff       	jmp    80106821 <alltraps>

8010783b <vector158>:
.globl vector158
vector158:
  pushl $0
8010783b:	6a 00                	push   $0x0
  pushl $158
8010783d:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107842:	e9 da ef ff ff       	jmp    80106821 <alltraps>

80107847 <vector159>:
.globl vector159
vector159:
  pushl $0
80107847:	6a 00                	push   $0x0
  pushl $159
80107849:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
8010784e:	e9 ce ef ff ff       	jmp    80106821 <alltraps>

80107853 <vector160>:
.globl vector160
vector160:
  pushl $0
80107853:	6a 00                	push   $0x0
  pushl $160
80107855:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010785a:	e9 c2 ef ff ff       	jmp    80106821 <alltraps>

8010785f <vector161>:
.globl vector161
vector161:
  pushl $0
8010785f:	6a 00                	push   $0x0
  pushl $161
80107861:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107866:	e9 b6 ef ff ff       	jmp    80106821 <alltraps>

8010786b <vector162>:
.globl vector162
vector162:
  pushl $0
8010786b:	6a 00                	push   $0x0
  pushl $162
8010786d:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107872:	e9 aa ef ff ff       	jmp    80106821 <alltraps>

80107877 <vector163>:
.globl vector163
vector163:
  pushl $0
80107877:	6a 00                	push   $0x0
  pushl $163
80107879:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010787e:	e9 9e ef ff ff       	jmp    80106821 <alltraps>

80107883 <vector164>:
.globl vector164
vector164:
  pushl $0
80107883:	6a 00                	push   $0x0
  pushl $164
80107885:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010788a:	e9 92 ef ff ff       	jmp    80106821 <alltraps>

8010788f <vector165>:
.globl vector165
vector165:
  pushl $0
8010788f:	6a 00                	push   $0x0
  pushl $165
80107891:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107896:	e9 86 ef ff ff       	jmp    80106821 <alltraps>

8010789b <vector166>:
.globl vector166
vector166:
  pushl $0
8010789b:	6a 00                	push   $0x0
  pushl $166
8010789d:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801078a2:	e9 7a ef ff ff       	jmp    80106821 <alltraps>

801078a7 <vector167>:
.globl vector167
vector167:
  pushl $0
801078a7:	6a 00                	push   $0x0
  pushl $167
801078a9:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801078ae:	e9 6e ef ff ff       	jmp    80106821 <alltraps>

801078b3 <vector168>:
.globl vector168
vector168:
  pushl $0
801078b3:	6a 00                	push   $0x0
  pushl $168
801078b5:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801078ba:	e9 62 ef ff ff       	jmp    80106821 <alltraps>

801078bf <vector169>:
.globl vector169
vector169:
  pushl $0
801078bf:	6a 00                	push   $0x0
  pushl $169
801078c1:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801078c6:	e9 56 ef ff ff       	jmp    80106821 <alltraps>

801078cb <vector170>:
.globl vector170
vector170:
  pushl $0
801078cb:	6a 00                	push   $0x0
  pushl $170
801078cd:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801078d2:	e9 4a ef ff ff       	jmp    80106821 <alltraps>

801078d7 <vector171>:
.globl vector171
vector171:
  pushl $0
801078d7:	6a 00                	push   $0x0
  pushl $171
801078d9:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801078de:	e9 3e ef ff ff       	jmp    80106821 <alltraps>

801078e3 <vector172>:
.globl vector172
vector172:
  pushl $0
801078e3:	6a 00                	push   $0x0
  pushl $172
801078e5:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801078ea:	e9 32 ef ff ff       	jmp    80106821 <alltraps>

801078ef <vector173>:
.globl vector173
vector173:
  pushl $0
801078ef:	6a 00                	push   $0x0
  pushl $173
801078f1:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801078f6:	e9 26 ef ff ff       	jmp    80106821 <alltraps>

801078fb <vector174>:
.globl vector174
vector174:
  pushl $0
801078fb:	6a 00                	push   $0x0
  pushl $174
801078fd:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107902:	e9 1a ef ff ff       	jmp    80106821 <alltraps>

80107907 <vector175>:
.globl vector175
vector175:
  pushl $0
80107907:	6a 00                	push   $0x0
  pushl $175
80107909:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
8010790e:	e9 0e ef ff ff       	jmp    80106821 <alltraps>

80107913 <vector176>:
.globl vector176
vector176:
  pushl $0
80107913:	6a 00                	push   $0x0
  pushl $176
80107915:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010791a:	e9 02 ef ff ff       	jmp    80106821 <alltraps>

8010791f <vector177>:
.globl vector177
vector177:
  pushl $0
8010791f:	6a 00                	push   $0x0
  pushl $177
80107921:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107926:	e9 f6 ee ff ff       	jmp    80106821 <alltraps>

8010792b <vector178>:
.globl vector178
vector178:
  pushl $0
8010792b:	6a 00                	push   $0x0
  pushl $178
8010792d:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107932:	e9 ea ee ff ff       	jmp    80106821 <alltraps>

80107937 <vector179>:
.globl vector179
vector179:
  pushl $0
80107937:	6a 00                	push   $0x0
  pushl $179
80107939:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
8010793e:	e9 de ee ff ff       	jmp    80106821 <alltraps>

80107943 <vector180>:
.globl vector180
vector180:
  pushl $0
80107943:	6a 00                	push   $0x0
  pushl $180
80107945:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010794a:	e9 d2 ee ff ff       	jmp    80106821 <alltraps>

8010794f <vector181>:
.globl vector181
vector181:
  pushl $0
8010794f:	6a 00                	push   $0x0
  pushl $181
80107951:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107956:	e9 c6 ee ff ff       	jmp    80106821 <alltraps>

8010795b <vector182>:
.globl vector182
vector182:
  pushl $0
8010795b:	6a 00                	push   $0x0
  pushl $182
8010795d:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107962:	e9 ba ee ff ff       	jmp    80106821 <alltraps>

80107967 <vector183>:
.globl vector183
vector183:
  pushl $0
80107967:	6a 00                	push   $0x0
  pushl $183
80107969:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
8010796e:	e9 ae ee ff ff       	jmp    80106821 <alltraps>

80107973 <vector184>:
.globl vector184
vector184:
  pushl $0
80107973:	6a 00                	push   $0x0
  pushl $184
80107975:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010797a:	e9 a2 ee ff ff       	jmp    80106821 <alltraps>

8010797f <vector185>:
.globl vector185
vector185:
  pushl $0
8010797f:	6a 00                	push   $0x0
  pushl $185
80107981:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107986:	e9 96 ee ff ff       	jmp    80106821 <alltraps>

8010798b <vector186>:
.globl vector186
vector186:
  pushl $0
8010798b:	6a 00                	push   $0x0
  pushl $186
8010798d:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107992:	e9 8a ee ff ff       	jmp    80106821 <alltraps>

80107997 <vector187>:
.globl vector187
vector187:
  pushl $0
80107997:	6a 00                	push   $0x0
  pushl $187
80107999:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
8010799e:	e9 7e ee ff ff       	jmp    80106821 <alltraps>

801079a3 <vector188>:
.globl vector188
vector188:
  pushl $0
801079a3:	6a 00                	push   $0x0
  pushl $188
801079a5:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801079aa:	e9 72 ee ff ff       	jmp    80106821 <alltraps>

801079af <vector189>:
.globl vector189
vector189:
  pushl $0
801079af:	6a 00                	push   $0x0
  pushl $189
801079b1:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801079b6:	e9 66 ee ff ff       	jmp    80106821 <alltraps>

801079bb <vector190>:
.globl vector190
vector190:
  pushl $0
801079bb:	6a 00                	push   $0x0
  pushl $190
801079bd:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801079c2:	e9 5a ee ff ff       	jmp    80106821 <alltraps>

801079c7 <vector191>:
.globl vector191
vector191:
  pushl $0
801079c7:	6a 00                	push   $0x0
  pushl $191
801079c9:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801079ce:	e9 4e ee ff ff       	jmp    80106821 <alltraps>

801079d3 <vector192>:
.globl vector192
vector192:
  pushl $0
801079d3:	6a 00                	push   $0x0
  pushl $192
801079d5:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801079da:	e9 42 ee ff ff       	jmp    80106821 <alltraps>

801079df <vector193>:
.globl vector193
vector193:
  pushl $0
801079df:	6a 00                	push   $0x0
  pushl $193
801079e1:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801079e6:	e9 36 ee ff ff       	jmp    80106821 <alltraps>

801079eb <vector194>:
.globl vector194
vector194:
  pushl $0
801079eb:	6a 00                	push   $0x0
  pushl $194
801079ed:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801079f2:	e9 2a ee ff ff       	jmp    80106821 <alltraps>

801079f7 <vector195>:
.globl vector195
vector195:
  pushl $0
801079f7:	6a 00                	push   $0x0
  pushl $195
801079f9:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801079fe:	e9 1e ee ff ff       	jmp    80106821 <alltraps>

80107a03 <vector196>:
.globl vector196
vector196:
  pushl $0
80107a03:	6a 00                	push   $0x0
  pushl $196
80107a05:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107a0a:	e9 12 ee ff ff       	jmp    80106821 <alltraps>

80107a0f <vector197>:
.globl vector197
vector197:
  pushl $0
80107a0f:	6a 00                	push   $0x0
  pushl $197
80107a11:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107a16:	e9 06 ee ff ff       	jmp    80106821 <alltraps>

80107a1b <vector198>:
.globl vector198
vector198:
  pushl $0
80107a1b:	6a 00                	push   $0x0
  pushl $198
80107a1d:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107a22:	e9 fa ed ff ff       	jmp    80106821 <alltraps>

80107a27 <vector199>:
.globl vector199
vector199:
  pushl $0
80107a27:	6a 00                	push   $0x0
  pushl $199
80107a29:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107a2e:	e9 ee ed ff ff       	jmp    80106821 <alltraps>

80107a33 <vector200>:
.globl vector200
vector200:
  pushl $0
80107a33:	6a 00                	push   $0x0
  pushl $200
80107a35:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107a3a:	e9 e2 ed ff ff       	jmp    80106821 <alltraps>

80107a3f <vector201>:
.globl vector201
vector201:
  pushl $0
80107a3f:	6a 00                	push   $0x0
  pushl $201
80107a41:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107a46:	e9 d6 ed ff ff       	jmp    80106821 <alltraps>

80107a4b <vector202>:
.globl vector202
vector202:
  pushl $0
80107a4b:	6a 00                	push   $0x0
  pushl $202
80107a4d:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107a52:	e9 ca ed ff ff       	jmp    80106821 <alltraps>

80107a57 <vector203>:
.globl vector203
vector203:
  pushl $0
80107a57:	6a 00                	push   $0x0
  pushl $203
80107a59:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107a5e:	e9 be ed ff ff       	jmp    80106821 <alltraps>

80107a63 <vector204>:
.globl vector204
vector204:
  pushl $0
80107a63:	6a 00                	push   $0x0
  pushl $204
80107a65:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107a6a:	e9 b2 ed ff ff       	jmp    80106821 <alltraps>

80107a6f <vector205>:
.globl vector205
vector205:
  pushl $0
80107a6f:	6a 00                	push   $0x0
  pushl $205
80107a71:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107a76:	e9 a6 ed ff ff       	jmp    80106821 <alltraps>

80107a7b <vector206>:
.globl vector206
vector206:
  pushl $0
80107a7b:	6a 00                	push   $0x0
  pushl $206
80107a7d:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107a82:	e9 9a ed ff ff       	jmp    80106821 <alltraps>

80107a87 <vector207>:
.globl vector207
vector207:
  pushl $0
80107a87:	6a 00                	push   $0x0
  pushl $207
80107a89:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107a8e:	e9 8e ed ff ff       	jmp    80106821 <alltraps>

80107a93 <vector208>:
.globl vector208
vector208:
  pushl $0
80107a93:	6a 00                	push   $0x0
  pushl $208
80107a95:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107a9a:	e9 82 ed ff ff       	jmp    80106821 <alltraps>

80107a9f <vector209>:
.globl vector209
vector209:
  pushl $0
80107a9f:	6a 00                	push   $0x0
  pushl $209
80107aa1:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107aa6:	e9 76 ed ff ff       	jmp    80106821 <alltraps>

80107aab <vector210>:
.globl vector210
vector210:
  pushl $0
80107aab:	6a 00                	push   $0x0
  pushl $210
80107aad:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107ab2:	e9 6a ed ff ff       	jmp    80106821 <alltraps>

80107ab7 <vector211>:
.globl vector211
vector211:
  pushl $0
80107ab7:	6a 00                	push   $0x0
  pushl $211
80107ab9:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107abe:	e9 5e ed ff ff       	jmp    80106821 <alltraps>

80107ac3 <vector212>:
.globl vector212
vector212:
  pushl $0
80107ac3:	6a 00                	push   $0x0
  pushl $212
80107ac5:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107aca:	e9 52 ed ff ff       	jmp    80106821 <alltraps>

80107acf <vector213>:
.globl vector213
vector213:
  pushl $0
80107acf:	6a 00                	push   $0x0
  pushl $213
80107ad1:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107ad6:	e9 46 ed ff ff       	jmp    80106821 <alltraps>

80107adb <vector214>:
.globl vector214
vector214:
  pushl $0
80107adb:	6a 00                	push   $0x0
  pushl $214
80107add:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107ae2:	e9 3a ed ff ff       	jmp    80106821 <alltraps>

80107ae7 <vector215>:
.globl vector215
vector215:
  pushl $0
80107ae7:	6a 00                	push   $0x0
  pushl $215
80107ae9:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107aee:	e9 2e ed ff ff       	jmp    80106821 <alltraps>

80107af3 <vector216>:
.globl vector216
vector216:
  pushl $0
80107af3:	6a 00                	push   $0x0
  pushl $216
80107af5:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107afa:	e9 22 ed ff ff       	jmp    80106821 <alltraps>

80107aff <vector217>:
.globl vector217
vector217:
  pushl $0
80107aff:	6a 00                	push   $0x0
  pushl $217
80107b01:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107b06:	e9 16 ed ff ff       	jmp    80106821 <alltraps>

80107b0b <vector218>:
.globl vector218
vector218:
  pushl $0
80107b0b:	6a 00                	push   $0x0
  pushl $218
80107b0d:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107b12:	e9 0a ed ff ff       	jmp    80106821 <alltraps>

80107b17 <vector219>:
.globl vector219
vector219:
  pushl $0
80107b17:	6a 00                	push   $0x0
  pushl $219
80107b19:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107b1e:	e9 fe ec ff ff       	jmp    80106821 <alltraps>

80107b23 <vector220>:
.globl vector220
vector220:
  pushl $0
80107b23:	6a 00                	push   $0x0
  pushl $220
80107b25:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107b2a:	e9 f2 ec ff ff       	jmp    80106821 <alltraps>

80107b2f <vector221>:
.globl vector221
vector221:
  pushl $0
80107b2f:	6a 00                	push   $0x0
  pushl $221
80107b31:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107b36:	e9 e6 ec ff ff       	jmp    80106821 <alltraps>

80107b3b <vector222>:
.globl vector222
vector222:
  pushl $0
80107b3b:	6a 00                	push   $0x0
  pushl $222
80107b3d:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107b42:	e9 da ec ff ff       	jmp    80106821 <alltraps>

80107b47 <vector223>:
.globl vector223
vector223:
  pushl $0
80107b47:	6a 00                	push   $0x0
  pushl $223
80107b49:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107b4e:	e9 ce ec ff ff       	jmp    80106821 <alltraps>

80107b53 <vector224>:
.globl vector224
vector224:
  pushl $0
80107b53:	6a 00                	push   $0x0
  pushl $224
80107b55:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107b5a:	e9 c2 ec ff ff       	jmp    80106821 <alltraps>

80107b5f <vector225>:
.globl vector225
vector225:
  pushl $0
80107b5f:	6a 00                	push   $0x0
  pushl $225
80107b61:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107b66:	e9 b6 ec ff ff       	jmp    80106821 <alltraps>

80107b6b <vector226>:
.globl vector226
vector226:
  pushl $0
80107b6b:	6a 00                	push   $0x0
  pushl $226
80107b6d:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107b72:	e9 aa ec ff ff       	jmp    80106821 <alltraps>

80107b77 <vector227>:
.globl vector227
vector227:
  pushl $0
80107b77:	6a 00                	push   $0x0
  pushl $227
80107b79:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107b7e:	e9 9e ec ff ff       	jmp    80106821 <alltraps>

80107b83 <vector228>:
.globl vector228
vector228:
  pushl $0
80107b83:	6a 00                	push   $0x0
  pushl $228
80107b85:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107b8a:	e9 92 ec ff ff       	jmp    80106821 <alltraps>

80107b8f <vector229>:
.globl vector229
vector229:
  pushl $0
80107b8f:	6a 00                	push   $0x0
  pushl $229
80107b91:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107b96:	e9 86 ec ff ff       	jmp    80106821 <alltraps>

80107b9b <vector230>:
.globl vector230
vector230:
  pushl $0
80107b9b:	6a 00                	push   $0x0
  pushl $230
80107b9d:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107ba2:	e9 7a ec ff ff       	jmp    80106821 <alltraps>

80107ba7 <vector231>:
.globl vector231
vector231:
  pushl $0
80107ba7:	6a 00                	push   $0x0
  pushl $231
80107ba9:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107bae:	e9 6e ec ff ff       	jmp    80106821 <alltraps>

80107bb3 <vector232>:
.globl vector232
vector232:
  pushl $0
80107bb3:	6a 00                	push   $0x0
  pushl $232
80107bb5:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107bba:	e9 62 ec ff ff       	jmp    80106821 <alltraps>

80107bbf <vector233>:
.globl vector233
vector233:
  pushl $0
80107bbf:	6a 00                	push   $0x0
  pushl $233
80107bc1:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107bc6:	e9 56 ec ff ff       	jmp    80106821 <alltraps>

80107bcb <vector234>:
.globl vector234
vector234:
  pushl $0
80107bcb:	6a 00                	push   $0x0
  pushl $234
80107bcd:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107bd2:	e9 4a ec ff ff       	jmp    80106821 <alltraps>

80107bd7 <vector235>:
.globl vector235
vector235:
  pushl $0
80107bd7:	6a 00                	push   $0x0
  pushl $235
80107bd9:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107bde:	e9 3e ec ff ff       	jmp    80106821 <alltraps>

80107be3 <vector236>:
.globl vector236
vector236:
  pushl $0
80107be3:	6a 00                	push   $0x0
  pushl $236
80107be5:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107bea:	e9 32 ec ff ff       	jmp    80106821 <alltraps>

80107bef <vector237>:
.globl vector237
vector237:
  pushl $0
80107bef:	6a 00                	push   $0x0
  pushl $237
80107bf1:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107bf6:	e9 26 ec ff ff       	jmp    80106821 <alltraps>

80107bfb <vector238>:
.globl vector238
vector238:
  pushl $0
80107bfb:	6a 00                	push   $0x0
  pushl $238
80107bfd:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107c02:	e9 1a ec ff ff       	jmp    80106821 <alltraps>

80107c07 <vector239>:
.globl vector239
vector239:
  pushl $0
80107c07:	6a 00                	push   $0x0
  pushl $239
80107c09:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107c0e:	e9 0e ec ff ff       	jmp    80106821 <alltraps>

80107c13 <vector240>:
.globl vector240
vector240:
  pushl $0
80107c13:	6a 00                	push   $0x0
  pushl $240
80107c15:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107c1a:	e9 02 ec ff ff       	jmp    80106821 <alltraps>

80107c1f <vector241>:
.globl vector241
vector241:
  pushl $0
80107c1f:	6a 00                	push   $0x0
  pushl $241
80107c21:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107c26:	e9 f6 eb ff ff       	jmp    80106821 <alltraps>

80107c2b <vector242>:
.globl vector242
vector242:
  pushl $0
80107c2b:	6a 00                	push   $0x0
  pushl $242
80107c2d:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107c32:	e9 ea eb ff ff       	jmp    80106821 <alltraps>

80107c37 <vector243>:
.globl vector243
vector243:
  pushl $0
80107c37:	6a 00                	push   $0x0
  pushl $243
80107c39:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107c3e:	e9 de eb ff ff       	jmp    80106821 <alltraps>

80107c43 <vector244>:
.globl vector244
vector244:
  pushl $0
80107c43:	6a 00                	push   $0x0
  pushl $244
80107c45:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107c4a:	e9 d2 eb ff ff       	jmp    80106821 <alltraps>

80107c4f <vector245>:
.globl vector245
vector245:
  pushl $0
80107c4f:	6a 00                	push   $0x0
  pushl $245
80107c51:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107c56:	e9 c6 eb ff ff       	jmp    80106821 <alltraps>

80107c5b <vector246>:
.globl vector246
vector246:
  pushl $0
80107c5b:	6a 00                	push   $0x0
  pushl $246
80107c5d:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107c62:	e9 ba eb ff ff       	jmp    80106821 <alltraps>

80107c67 <vector247>:
.globl vector247
vector247:
  pushl $0
80107c67:	6a 00                	push   $0x0
  pushl $247
80107c69:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107c6e:	e9 ae eb ff ff       	jmp    80106821 <alltraps>

80107c73 <vector248>:
.globl vector248
vector248:
  pushl $0
80107c73:	6a 00                	push   $0x0
  pushl $248
80107c75:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107c7a:	e9 a2 eb ff ff       	jmp    80106821 <alltraps>

80107c7f <vector249>:
.globl vector249
vector249:
  pushl $0
80107c7f:	6a 00                	push   $0x0
  pushl $249
80107c81:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107c86:	e9 96 eb ff ff       	jmp    80106821 <alltraps>

80107c8b <vector250>:
.globl vector250
vector250:
  pushl $0
80107c8b:	6a 00                	push   $0x0
  pushl $250
80107c8d:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107c92:	e9 8a eb ff ff       	jmp    80106821 <alltraps>

80107c97 <vector251>:
.globl vector251
vector251:
  pushl $0
80107c97:	6a 00                	push   $0x0
  pushl $251
80107c99:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107c9e:	e9 7e eb ff ff       	jmp    80106821 <alltraps>

80107ca3 <vector252>:
.globl vector252
vector252:
  pushl $0
80107ca3:	6a 00                	push   $0x0
  pushl $252
80107ca5:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107caa:	e9 72 eb ff ff       	jmp    80106821 <alltraps>

80107caf <vector253>:
.globl vector253
vector253:
  pushl $0
80107caf:	6a 00                	push   $0x0
  pushl $253
80107cb1:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107cb6:	e9 66 eb ff ff       	jmp    80106821 <alltraps>

80107cbb <vector254>:
.globl vector254
vector254:
  pushl $0
80107cbb:	6a 00                	push   $0x0
  pushl $254
80107cbd:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107cc2:	e9 5a eb ff ff       	jmp    80106821 <alltraps>

80107cc7 <vector255>:
.globl vector255
vector255:
  pushl $0
80107cc7:	6a 00                	push   $0x0
  pushl $255
80107cc9:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107cce:	e9 4e eb ff ff       	jmp    80106821 <alltraps>

80107cd3 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107cd3:	55                   	push   %ebp
80107cd4:	89 e5                	mov    %esp,%ebp
80107cd6:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cdc:	83 e8 01             	sub    $0x1,%eax
80107cdf:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107ce3:	8b 45 08             	mov    0x8(%ebp),%eax
80107ce6:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107cea:	8b 45 08             	mov    0x8(%ebp),%eax
80107ced:	c1 e8 10             	shr    $0x10,%eax
80107cf0:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107cf4:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107cf7:	0f 01 10             	lgdtl  (%eax)
}
80107cfa:	90                   	nop
80107cfb:	c9                   	leave  
80107cfc:	c3                   	ret    

80107cfd <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107cfd:	55                   	push   %ebp
80107cfe:	89 e5                	mov    %esp,%ebp
80107d00:	83 ec 04             	sub    $0x4,%esp
80107d03:	8b 45 08             	mov    0x8(%ebp),%eax
80107d06:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107d0a:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107d0e:	0f 00 d8             	ltr    %ax
}
80107d11:	90                   	nop
80107d12:	c9                   	leave  
80107d13:	c3                   	ret    

80107d14 <lcr3>:
  return val;
}

static inline void
lcr3(uint val)
{
80107d14:	55                   	push   %ebp
80107d15:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107d17:	8b 45 08             	mov    0x8(%ebp),%eax
80107d1a:	0f 22 d8             	mov    %eax,%cr3
}
80107d1d:	90                   	nop
80107d1e:	5d                   	pop    %ebp
80107d1f:	c3                   	ret    

80107d20 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107d20:	55                   	push   %ebp
80107d21:	89 e5                	mov    %esp,%ebp
80107d23:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107d26:	e8 11 c5 ff ff       	call   8010423c <cpuid>
80107d2b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107d31:	05 20 48 11 80       	add    $0x80114820,%eax
80107d36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d3c:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d45:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d4e:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d55:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107d59:	83 e2 f0             	and    $0xfffffff0,%edx
80107d5c:	83 ca 0a             	or     $0xa,%edx
80107d5f:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d65:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107d69:	83 ca 10             	or     $0x10,%edx
80107d6c:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d72:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107d76:	83 e2 9f             	and    $0xffffff9f,%edx
80107d79:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d7f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107d83:	83 ca 80             	or     $0xffffff80,%edx
80107d86:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d8c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d90:	83 ca 0f             	or     $0xf,%edx
80107d93:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d99:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d9d:	83 e2 ef             	and    $0xffffffef,%edx
80107da0:	88 50 7e             	mov    %dl,0x7e(%eax)
80107da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107da6:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107daa:	83 e2 df             	and    $0xffffffdf,%edx
80107dad:	88 50 7e             	mov    %dl,0x7e(%eax)
80107db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db3:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107db7:	83 ca 40             	or     $0x40,%edx
80107dba:	88 50 7e             	mov    %dl,0x7e(%eax)
80107dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dc0:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107dc4:	83 ca 80             	or     $0xffffff80,%edx
80107dc7:	88 50 7e             	mov    %dl,0x7e(%eax)
80107dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dcd:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dd4:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107ddb:	ff ff 
80107ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de0:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107de7:	00 00 
80107de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dec:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107df6:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107dfd:	83 e2 f0             	and    $0xfffffff0,%edx
80107e00:	83 ca 02             	or     $0x2,%edx
80107e03:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e0c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107e13:	83 ca 10             	or     $0x10,%edx
80107e16:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e1f:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107e26:	83 e2 9f             	and    $0xffffff9f,%edx
80107e29:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e32:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107e39:	83 ca 80             	or     $0xffffff80,%edx
80107e3c:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e45:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e4c:	83 ca 0f             	or     $0xf,%edx
80107e4f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e58:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e5f:	83 e2 ef             	and    $0xffffffef,%edx
80107e62:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e6b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e72:	83 e2 df             	and    $0xffffffdf,%edx
80107e75:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e7e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e85:	83 ca 40             	or     $0x40,%edx
80107e88:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e91:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e98:	83 ca 80             	or     $0xffffff80,%edx
80107e9b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea4:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eae:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
80107eb5:	ff ff 
80107eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eba:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
80107ec1:	00 00 
80107ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ec6:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
80107ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ed0:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107ed7:	83 e2 f0             	and    $0xfffffff0,%edx
80107eda:	83 ca 0a             	or     $0xa,%edx
80107edd:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ee6:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107eed:	83 ca 10             	or     $0x10,%edx
80107ef0:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef9:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107f00:	83 ca 60             	or     $0x60,%edx
80107f03:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f0c:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107f13:	83 ca 80             	or     $0xffffff80,%edx
80107f16:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f1f:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107f26:	83 ca 0f             	or     $0xf,%edx
80107f29:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f32:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107f39:	83 e2 ef             	and    $0xffffffef,%edx
80107f3c:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f45:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107f4c:	83 e2 df             	and    $0xffffffdf,%edx
80107f4f:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f58:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107f5f:	83 ca 40             	or     $0x40,%edx
80107f62:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f6b:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107f72:	83 ca 80             	or     $0xffffff80,%edx
80107f75:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f7e:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f88:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107f8f:	ff ff 
80107f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f94:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107f9b:	00 00 
80107f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa0:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107faa:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107fb1:	83 e2 f0             	and    $0xfffffff0,%edx
80107fb4:	83 ca 02             	or     $0x2,%edx
80107fb7:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc0:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107fc7:	83 ca 10             	or     $0x10,%edx
80107fca:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd3:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107fda:	83 ca 60             	or     $0x60,%edx
80107fdd:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe6:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107fed:	83 ca 80             	or     $0xffffff80,%edx
80107ff0:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff9:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108000:	83 ca 0f             	or     $0xf,%edx
80108003:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108009:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010800c:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108013:	83 e2 ef             	and    $0xffffffef,%edx
80108016:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010801c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010801f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108026:	83 e2 df             	and    $0xffffffdf,%edx
80108029:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010802f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108032:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108039:	83 ca 40             	or     $0x40,%edx
8010803c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108042:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108045:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010804c:	83 ca 80             	or     $0xffffff80,%edx
8010804f:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108055:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108058:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010805f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108062:	83 c0 70             	add    $0x70,%eax
80108065:	83 ec 08             	sub    $0x8,%esp
80108068:	6a 30                	push   $0x30
8010806a:	50                   	push   %eax
8010806b:	e8 63 fc ff ff       	call   80107cd3 <lgdt>
80108070:	83 c4 10             	add    $0x10,%esp
}
80108073:	90                   	nop
80108074:	c9                   	leave  
80108075:	c3                   	ret    

80108076 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80108076:	55                   	push   %ebp
80108077:	89 e5                	mov    %esp,%ebp
80108079:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010807c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010807f:	c1 e8 16             	shr    $0x16,%eax
80108082:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108089:	8b 45 08             	mov    0x8(%ebp),%eax
8010808c:	01 d0                	add    %edx,%eax
8010808e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80108091:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108094:	8b 00                	mov    (%eax),%eax
80108096:	83 e0 01             	and    $0x1,%eax
80108099:	85 c0                	test   %eax,%eax
8010809b:	74 14                	je     801080b1 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010809d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080a0:	8b 00                	mov    (%eax),%eax
801080a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080a7:	05 00 00 00 80       	add    $0x80000000,%eax
801080ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
801080af:	eb 42                	jmp    801080f3 <walkpgdir+0x7d>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801080b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801080b5:	74 0e                	je     801080c5 <walkpgdir+0x4f>
801080b7:	e8 26 ac ff ff       	call   80102ce2 <kalloc>
801080bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801080bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801080c3:	75 07                	jne    801080cc <walkpgdir+0x56>
      return 0;
801080c5:	b8 00 00 00 00       	mov    $0x0,%eax
801080ca:	eb 3e                	jmp    8010810a <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801080cc:	83 ec 04             	sub    $0x4,%esp
801080cf:	68 00 10 00 00       	push   $0x1000
801080d4:	6a 00                	push   $0x0
801080d6:	ff 75 f4             	pushl  -0xc(%ebp)
801080d9:	e8 1a d3 ff ff       	call   801053f8 <memset>
801080de:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801080e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e4:	05 00 00 00 80       	add    $0x80000000,%eax
801080e9:	83 c8 07             	or     $0x7,%eax
801080ec:	89 c2                	mov    %eax,%edx
801080ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080f1:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801080f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801080f6:	c1 e8 0c             	shr    $0xc,%eax
801080f9:	25 ff 03 00 00       	and    $0x3ff,%eax
801080fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108105:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108108:	01 d0                	add    %edx,%eax
}
8010810a:	c9                   	leave  
8010810b:	c3                   	ret    

8010810c <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010810c:	55                   	push   %ebp
8010810d:	89 e5                	mov    %esp,%ebp
8010810f:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80108112:	8b 45 0c             	mov    0xc(%ebp),%eax
80108115:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010811a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010811d:	8b 55 0c             	mov    0xc(%ebp),%edx
80108120:	8b 45 10             	mov    0x10(%ebp),%eax
80108123:	01 d0                	add    %edx,%eax
80108125:	83 e8 01             	sub    $0x1,%eax
80108128:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010812d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108130:	83 ec 04             	sub    $0x4,%esp
80108133:	6a 01                	push   $0x1
80108135:	ff 75 f4             	pushl  -0xc(%ebp)
80108138:	ff 75 08             	pushl  0x8(%ebp)
8010813b:	e8 36 ff ff ff       	call   80108076 <walkpgdir>
80108140:	83 c4 10             	add    $0x10,%esp
80108143:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108146:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010814a:	75 07                	jne    80108153 <mappages+0x47>
      return -1;
8010814c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108151:	eb 47                	jmp    8010819a <mappages+0x8e>
    if(*pte & PTE_P)
80108153:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108156:	8b 00                	mov    (%eax),%eax
80108158:	83 e0 01             	and    $0x1,%eax
8010815b:	85 c0                	test   %eax,%eax
8010815d:	74 0d                	je     8010816c <mappages+0x60>
      panic("remap");
8010815f:	83 ec 0c             	sub    $0xc,%esp
80108162:	68 8c 90 10 80       	push   $0x8010908c
80108167:	e8 34 84 ff ff       	call   801005a0 <panic>
    *pte = pa | perm | PTE_P;
8010816c:	8b 45 18             	mov    0x18(%ebp),%eax
8010816f:	0b 45 14             	or     0x14(%ebp),%eax
80108172:	83 c8 01             	or     $0x1,%eax
80108175:	89 c2                	mov    %eax,%edx
80108177:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010817a:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010817c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010817f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108182:	74 10                	je     80108194 <mappages+0x88>
      break;
    a += PGSIZE;
80108184:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
8010818b:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80108192:	eb 9c                	jmp    80108130 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80108194:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80108195:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010819a:	c9                   	leave  
8010819b:	c3                   	ret    

8010819c <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
8010819c:	55                   	push   %ebp
8010819d:	89 e5                	mov    %esp,%ebp
8010819f:	53                   	push   %ebx
801081a0:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801081a3:	e8 3a ab ff ff       	call   80102ce2 <kalloc>
801081a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801081ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801081af:	75 07                	jne    801081b8 <setupkvm+0x1c>
    return 0;
801081b1:	b8 00 00 00 00       	mov    $0x0,%eax
801081b6:	eb 78                	jmp    80108230 <setupkvm+0x94>
  memset(pgdir, 0, PGSIZE);
801081b8:	83 ec 04             	sub    $0x4,%esp
801081bb:	68 00 10 00 00       	push   $0x1000
801081c0:	6a 00                	push   $0x0
801081c2:	ff 75 f0             	pushl  -0x10(%ebp)
801081c5:	e8 2e d2 ff ff       	call   801053f8 <memset>
801081ca:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801081cd:	c7 45 f4 a0 c4 10 80 	movl   $0x8010c4a0,-0xc(%ebp)
801081d4:	eb 4e                	jmp    80108224 <setupkvm+0x88>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801081d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081d9:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0) {
801081dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081df:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801081e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081e5:	8b 58 08             	mov    0x8(%eax),%ebx
801081e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081eb:	8b 40 04             	mov    0x4(%eax),%eax
801081ee:	29 c3                	sub    %eax,%ebx
801081f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f3:	8b 00                	mov    (%eax),%eax
801081f5:	83 ec 0c             	sub    $0xc,%esp
801081f8:	51                   	push   %ecx
801081f9:	52                   	push   %edx
801081fa:	53                   	push   %ebx
801081fb:	50                   	push   %eax
801081fc:	ff 75 f0             	pushl  -0x10(%ebp)
801081ff:	e8 08 ff ff ff       	call   8010810c <mappages>
80108204:	83 c4 20             	add    $0x20,%esp
80108207:	85 c0                	test   %eax,%eax
80108209:	79 15                	jns    80108220 <setupkvm+0x84>
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
8010820b:	83 ec 0c             	sub    $0xc,%esp
8010820e:	ff 75 f0             	pushl  -0x10(%ebp)
80108211:	e8 f4 04 00 00       	call   8010870a <freevm>
80108216:	83 c4 10             	add    $0x10,%esp
      return 0;
80108219:	b8 00 00 00 00       	mov    $0x0,%eax
8010821e:	eb 10                	jmp    80108230 <setupkvm+0x94>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108220:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108224:	81 7d f4 e0 c4 10 80 	cmpl   $0x8010c4e0,-0xc(%ebp)
8010822b:	72 a9                	jb     801081d6 <setupkvm+0x3a>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
8010822d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108230:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108233:	c9                   	leave  
80108234:	c3                   	ret    

80108235 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108235:	55                   	push   %ebp
80108236:	89 e5                	mov    %esp,%ebp
80108238:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010823b:	e8 5c ff ff ff       	call   8010819c <setupkvm>
80108240:	a3 44 99 11 80       	mov    %eax,0x80119944
  switchkvm();
80108245:	e8 03 00 00 00       	call   8010824d <switchkvm>
}
8010824a:	90                   	nop
8010824b:	c9                   	leave  
8010824c:	c3                   	ret    

8010824d <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010824d:	55                   	push   %ebp
8010824e:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108250:	a1 44 99 11 80       	mov    0x80119944,%eax
80108255:	05 00 00 00 80       	add    $0x80000000,%eax
8010825a:	50                   	push   %eax
8010825b:	e8 b4 fa ff ff       	call   80107d14 <lcr3>
80108260:	83 c4 04             	add    $0x4,%esp
}
80108263:	90                   	nop
80108264:	c9                   	leave  
80108265:	c3                   	ret    

80108266 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108266:	55                   	push   %ebp
80108267:	89 e5                	mov    %esp,%ebp
80108269:	56                   	push   %esi
8010826a:	53                   	push   %ebx
8010826b:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
8010826e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108272:	75 0d                	jne    80108281 <switchuvm+0x1b>
    panic("switchuvm: no process");
80108274:	83 ec 0c             	sub    $0xc,%esp
80108277:	68 92 90 10 80       	push   $0x80109092
8010827c:	e8 1f 83 ff ff       	call   801005a0 <panic>
  if(p->kstack == 0)
80108281:	8b 45 08             	mov    0x8(%ebp),%eax
80108284:	8b 40 08             	mov    0x8(%eax),%eax
80108287:	85 c0                	test   %eax,%eax
80108289:	75 0d                	jne    80108298 <switchuvm+0x32>
    panic("switchuvm: no kstack");
8010828b:	83 ec 0c             	sub    $0xc,%esp
8010828e:	68 a8 90 10 80       	push   $0x801090a8
80108293:	e8 08 83 ff ff       	call   801005a0 <panic>
  if(p->pgdir == 0)
80108298:	8b 45 08             	mov    0x8(%ebp),%eax
8010829b:	8b 40 04             	mov    0x4(%eax),%eax
8010829e:	85 c0                	test   %eax,%eax
801082a0:	75 0d                	jne    801082af <switchuvm+0x49>
    panic("switchuvm: no pgdir");
801082a2:	83 ec 0c             	sub    $0xc,%esp
801082a5:	68 bd 90 10 80       	push   $0x801090bd
801082aa:	e8 f1 82 ff ff       	call   801005a0 <panic>

  pushcli();
801082af:	e8 38 d0 ff ff       	call   801052ec <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801082b4:	e8 a4 bf ff ff       	call   8010425d <mycpu>
801082b9:	89 c3                	mov    %eax,%ebx
801082bb:	e8 9d bf ff ff       	call   8010425d <mycpu>
801082c0:	83 c0 08             	add    $0x8,%eax
801082c3:	89 c6                	mov    %eax,%esi
801082c5:	e8 93 bf ff ff       	call   8010425d <mycpu>
801082ca:	83 c0 08             	add    $0x8,%eax
801082cd:	c1 e8 10             	shr    $0x10,%eax
801082d0:	88 45 f7             	mov    %al,-0x9(%ebp)
801082d3:	e8 85 bf ff ff       	call   8010425d <mycpu>
801082d8:	83 c0 08             	add    $0x8,%eax
801082db:	c1 e8 18             	shr    $0x18,%eax
801082de:	89 c2                	mov    %eax,%edx
801082e0:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801082e7:	67 00 
801082e9:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
801082f0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
801082f4:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
801082fa:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80108301:	83 e0 f0             	and    $0xfffffff0,%eax
80108304:	83 c8 09             	or     $0x9,%eax
80108307:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010830d:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80108314:	83 c8 10             	or     $0x10,%eax
80108317:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010831d:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80108324:	83 e0 9f             	and    $0xffffff9f,%eax
80108327:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010832d:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80108334:	83 c8 80             	or     $0xffffff80,%eax
80108337:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010833d:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108344:	83 e0 f0             	and    $0xfffffff0,%eax
80108347:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010834d:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108354:	83 e0 ef             	and    $0xffffffef,%eax
80108357:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010835d:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108364:	83 e0 df             	and    $0xffffffdf,%eax
80108367:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010836d:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108374:	83 c8 40             	or     $0x40,%eax
80108377:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010837d:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108384:	83 e0 7f             	and    $0x7f,%eax
80108387:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010838d:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80108393:	e8 c5 be ff ff       	call   8010425d <mycpu>
80108398:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010839f:	83 e2 ef             	and    $0xffffffef,%edx
801083a2:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801083a8:	e8 b0 be ff ff       	call   8010425d <mycpu>
801083ad:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801083b3:	e8 a5 be ff ff       	call   8010425d <mycpu>
801083b8:	89 c2                	mov    %eax,%edx
801083ba:	8b 45 08             	mov    0x8(%ebp),%eax
801083bd:	8b 40 08             	mov    0x8(%eax),%eax
801083c0:	05 00 10 00 00       	add    $0x1000,%eax
801083c5:	89 42 0c             	mov    %eax,0xc(%edx)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801083c8:	e8 90 be ff ff       	call   8010425d <mycpu>
801083cd:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
801083d3:	83 ec 0c             	sub    $0xc,%esp
801083d6:	6a 28                	push   $0x28
801083d8:	e8 20 f9 ff ff       	call   80107cfd <ltr>
801083dd:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir));  // switch to process's address space
801083e0:	8b 45 08             	mov    0x8(%ebp),%eax
801083e3:	8b 40 04             	mov    0x4(%eax),%eax
801083e6:	05 00 00 00 80       	add    $0x80000000,%eax
801083eb:	83 ec 0c             	sub    $0xc,%esp
801083ee:	50                   	push   %eax
801083ef:	e8 20 f9 ff ff       	call   80107d14 <lcr3>
801083f4:	83 c4 10             	add    $0x10,%esp
  popcli();
801083f7:	e8 3e cf ff ff       	call   8010533a <popcli>
}
801083fc:	90                   	nop
801083fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108400:	5b                   	pop    %ebx
80108401:	5e                   	pop    %esi
80108402:	5d                   	pop    %ebp
80108403:	c3                   	ret    

80108404 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108404:	55                   	push   %ebp
80108405:	89 e5                	mov    %esp,%ebp
80108407:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
8010840a:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108411:	76 0d                	jbe    80108420 <inituvm+0x1c>
    panic("inituvm: more than a page");
80108413:	83 ec 0c             	sub    $0xc,%esp
80108416:	68 d1 90 10 80       	push   $0x801090d1
8010841b:	e8 80 81 ff ff       	call   801005a0 <panic>
  mem = kalloc();
80108420:	e8 bd a8 ff ff       	call   80102ce2 <kalloc>
80108425:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108428:	83 ec 04             	sub    $0x4,%esp
8010842b:	68 00 10 00 00       	push   $0x1000
80108430:	6a 00                	push   $0x0
80108432:	ff 75 f4             	pushl  -0xc(%ebp)
80108435:	e8 be cf ff ff       	call   801053f8 <memset>
8010843a:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010843d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108440:	05 00 00 00 80       	add    $0x80000000,%eax
80108445:	83 ec 0c             	sub    $0xc,%esp
80108448:	6a 06                	push   $0x6
8010844a:	50                   	push   %eax
8010844b:	68 00 10 00 00       	push   $0x1000
80108450:	6a 00                	push   $0x0
80108452:	ff 75 08             	pushl  0x8(%ebp)
80108455:	e8 b2 fc ff ff       	call   8010810c <mappages>
8010845a:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
8010845d:	83 ec 04             	sub    $0x4,%esp
80108460:	ff 75 10             	pushl  0x10(%ebp)
80108463:	ff 75 0c             	pushl  0xc(%ebp)
80108466:	ff 75 f4             	pushl  -0xc(%ebp)
80108469:	e8 49 d0 ff ff       	call   801054b7 <memmove>
8010846e:	83 c4 10             	add    $0x10,%esp
}
80108471:	90                   	nop
80108472:	c9                   	leave  
80108473:	c3                   	ret    

80108474 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108474:	55                   	push   %ebp
80108475:	89 e5                	mov    %esp,%ebp
80108477:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
8010847a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010847d:	25 ff 0f 00 00       	and    $0xfff,%eax
80108482:	85 c0                	test   %eax,%eax
80108484:	74 0d                	je     80108493 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80108486:	83 ec 0c             	sub    $0xc,%esp
80108489:	68 ec 90 10 80       	push   $0x801090ec
8010848e:	e8 0d 81 ff ff       	call   801005a0 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108493:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010849a:	e9 8f 00 00 00       	jmp    8010852e <loaduvm+0xba>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010849f:	8b 55 0c             	mov    0xc(%ebp),%edx
801084a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084a5:	01 d0                	add    %edx,%eax
801084a7:	83 ec 04             	sub    $0x4,%esp
801084aa:	6a 00                	push   $0x0
801084ac:	50                   	push   %eax
801084ad:	ff 75 08             	pushl  0x8(%ebp)
801084b0:	e8 c1 fb ff ff       	call   80108076 <walkpgdir>
801084b5:	83 c4 10             	add    $0x10,%esp
801084b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
801084bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801084bf:	75 0d                	jne    801084ce <loaduvm+0x5a>
      panic("loaduvm: address should exist");
801084c1:	83 ec 0c             	sub    $0xc,%esp
801084c4:	68 0f 91 10 80       	push   $0x8010910f
801084c9:	e8 d2 80 ff ff       	call   801005a0 <panic>
    pa = PTE_ADDR(*pte);
801084ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084d1:	8b 00                	mov    (%eax),%eax
801084d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801084db:	8b 45 18             	mov    0x18(%ebp),%eax
801084de:	2b 45 f4             	sub    -0xc(%ebp),%eax
801084e1:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801084e6:	77 0b                	ja     801084f3 <loaduvm+0x7f>
      n = sz - i;
801084e8:	8b 45 18             	mov    0x18(%ebp),%eax
801084eb:	2b 45 f4             	sub    -0xc(%ebp),%eax
801084ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
801084f1:	eb 07                	jmp    801084fa <loaduvm+0x86>
    else
      n = PGSIZE;
801084f3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801084fa:	8b 55 14             	mov    0x14(%ebp),%edx
801084fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108500:	01 d0                	add    %edx,%eax
80108502:	8b 55 e8             	mov    -0x18(%ebp),%edx
80108505:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010850b:	ff 75 f0             	pushl  -0x10(%ebp)
8010850e:	50                   	push   %eax
8010850f:	52                   	push   %edx
80108510:	ff 75 10             	pushl  0x10(%ebp)
80108513:	e8 36 9a ff ff       	call   80101f4e <readi>
80108518:	83 c4 10             	add    $0x10,%esp
8010851b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010851e:	74 07                	je     80108527 <loaduvm+0xb3>
      return -1;
80108520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108525:	eb 18                	jmp    8010853f <loaduvm+0xcb>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108527:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010852e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108531:	3b 45 18             	cmp    0x18(%ebp),%eax
80108534:	0f 82 65 ff ff ff    	jb     8010849f <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010853a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010853f:	c9                   	leave  
80108540:	c3                   	ret    

80108541 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108541:	55                   	push   %ebp
80108542:	89 e5                	mov    %esp,%ebp
80108544:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108547:	8b 45 10             	mov    0x10(%ebp),%eax
8010854a:	85 c0                	test   %eax,%eax
8010854c:	79 0a                	jns    80108558 <allocuvm+0x17>
    return 0;
8010854e:	b8 00 00 00 00       	mov    $0x0,%eax
80108553:	e9 ec 00 00 00       	jmp    80108644 <allocuvm+0x103>
  if(newsz < oldsz)
80108558:	8b 45 10             	mov    0x10(%ebp),%eax
8010855b:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010855e:	73 08                	jae    80108568 <allocuvm+0x27>
    return oldsz;
80108560:	8b 45 0c             	mov    0xc(%ebp),%eax
80108563:	e9 dc 00 00 00       	jmp    80108644 <allocuvm+0x103>

  a = PGROUNDUP(oldsz);
80108568:	8b 45 0c             	mov    0xc(%ebp),%eax
8010856b:	05 ff 0f 00 00       	add    $0xfff,%eax
80108570:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108575:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108578:	e9 b8 00 00 00       	jmp    80108635 <allocuvm+0xf4>
    mem = kalloc();
8010857d:	e8 60 a7 ff ff       	call   80102ce2 <kalloc>
80108582:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108585:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108589:	75 2e                	jne    801085b9 <allocuvm+0x78>
      cprintf("allocuvm out of memory\n");
8010858b:	83 ec 0c             	sub    $0xc,%esp
8010858e:	68 2d 91 10 80       	push   $0x8010912d
80108593:	e8 68 7e ff ff       	call   80100400 <cprintf>
80108598:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
8010859b:	83 ec 04             	sub    $0x4,%esp
8010859e:	ff 75 0c             	pushl  0xc(%ebp)
801085a1:	ff 75 10             	pushl  0x10(%ebp)
801085a4:	ff 75 08             	pushl  0x8(%ebp)
801085a7:	e8 9a 00 00 00       	call   80108646 <deallocuvm>
801085ac:	83 c4 10             	add    $0x10,%esp
      return 0;
801085af:	b8 00 00 00 00       	mov    $0x0,%eax
801085b4:	e9 8b 00 00 00       	jmp    80108644 <allocuvm+0x103>
    }
    memset(mem, 0, PGSIZE);
801085b9:	83 ec 04             	sub    $0x4,%esp
801085bc:	68 00 10 00 00       	push   $0x1000
801085c1:	6a 00                	push   $0x0
801085c3:	ff 75 f0             	pushl  -0x10(%ebp)
801085c6:	e8 2d ce ff ff       	call   801053f8 <memset>
801085cb:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801085ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085d1:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801085d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085da:	83 ec 0c             	sub    $0xc,%esp
801085dd:	6a 06                	push   $0x6
801085df:	52                   	push   %edx
801085e0:	68 00 10 00 00       	push   $0x1000
801085e5:	50                   	push   %eax
801085e6:	ff 75 08             	pushl  0x8(%ebp)
801085e9:	e8 1e fb ff ff       	call   8010810c <mappages>
801085ee:	83 c4 20             	add    $0x20,%esp
801085f1:	85 c0                	test   %eax,%eax
801085f3:	79 39                	jns    8010862e <allocuvm+0xed>
      cprintf("allocuvm out of memory (2)\n");
801085f5:	83 ec 0c             	sub    $0xc,%esp
801085f8:	68 45 91 10 80       	push   $0x80109145
801085fd:	e8 fe 7d ff ff       	call   80100400 <cprintf>
80108602:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80108605:	83 ec 04             	sub    $0x4,%esp
80108608:	ff 75 0c             	pushl  0xc(%ebp)
8010860b:	ff 75 10             	pushl  0x10(%ebp)
8010860e:	ff 75 08             	pushl  0x8(%ebp)
80108611:	e8 30 00 00 00       	call   80108646 <deallocuvm>
80108616:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
80108619:	83 ec 0c             	sub    $0xc,%esp
8010861c:	ff 75 f0             	pushl  -0x10(%ebp)
8010861f:	e8 24 a6 ff ff       	call   80102c48 <kfree>
80108624:	83 c4 10             	add    $0x10,%esp
      return 0;
80108627:	b8 00 00 00 00       	mov    $0x0,%eax
8010862c:	eb 16                	jmp    80108644 <allocuvm+0x103>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
8010862e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108635:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108638:	3b 45 10             	cmp    0x10(%ebp),%eax
8010863b:	0f 82 3c ff ff ff    	jb     8010857d <allocuvm+0x3c>
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
  }
  return newsz;
80108641:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108644:	c9                   	leave  
80108645:	c3                   	ret    

80108646 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108646:	55                   	push   %ebp
80108647:	89 e5                	mov    %esp,%ebp
80108649:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010864c:	8b 45 10             	mov    0x10(%ebp),%eax
8010864f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108652:	72 08                	jb     8010865c <deallocuvm+0x16>
    return oldsz;
80108654:	8b 45 0c             	mov    0xc(%ebp),%eax
80108657:	e9 ac 00 00 00       	jmp    80108708 <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
8010865c:	8b 45 10             	mov    0x10(%ebp),%eax
8010865f:	05 ff 0f 00 00       	add    $0xfff,%eax
80108664:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108669:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010866c:	e9 88 00 00 00       	jmp    801086f9 <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108671:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108674:	83 ec 04             	sub    $0x4,%esp
80108677:	6a 00                	push   $0x0
80108679:	50                   	push   %eax
8010867a:	ff 75 08             	pushl  0x8(%ebp)
8010867d:	e8 f4 f9 ff ff       	call   80108076 <walkpgdir>
80108682:	83 c4 10             	add    $0x10,%esp
80108685:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108688:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010868c:	75 16                	jne    801086a4 <deallocuvm+0x5e>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010868e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108691:	c1 e8 16             	shr    $0x16,%eax
80108694:	83 c0 01             	add    $0x1,%eax
80108697:	c1 e0 16             	shl    $0x16,%eax
8010869a:	2d 00 10 00 00       	sub    $0x1000,%eax
8010869f:	89 45 f4             	mov    %eax,-0xc(%ebp)
801086a2:	eb 4e                	jmp    801086f2 <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
801086a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086a7:	8b 00                	mov    (%eax),%eax
801086a9:	83 e0 01             	and    $0x1,%eax
801086ac:	85 c0                	test   %eax,%eax
801086ae:	74 42                	je     801086f2 <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
801086b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086b3:	8b 00                	mov    (%eax),%eax
801086b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801086ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801086bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801086c1:	75 0d                	jne    801086d0 <deallocuvm+0x8a>
        panic("kfree");
801086c3:	83 ec 0c             	sub    $0xc,%esp
801086c6:	68 61 91 10 80       	push   $0x80109161
801086cb:	e8 d0 7e ff ff       	call   801005a0 <panic>
      char *v = P2V(pa);
801086d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086d3:	05 00 00 00 80       	add    $0x80000000,%eax
801086d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801086db:	83 ec 0c             	sub    $0xc,%esp
801086de:	ff 75 e8             	pushl  -0x18(%ebp)
801086e1:	e8 62 a5 ff ff       	call   80102c48 <kfree>
801086e6:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
801086e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801086f2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801086f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086fc:	3b 45 0c             	cmp    0xc(%ebp),%eax
801086ff:	0f 82 6c ff ff ff    	jb     80108671 <deallocuvm+0x2b>
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108705:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108708:	c9                   	leave  
80108709:	c3                   	ret    

8010870a <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010870a:	55                   	push   %ebp
8010870b:	89 e5                	mov    %esp,%ebp
8010870d:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80108710:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108714:	75 0d                	jne    80108723 <freevm+0x19>
    panic("freevm: no pgdir");
80108716:	83 ec 0c             	sub    $0xc,%esp
80108719:	68 67 91 10 80       	push   $0x80109167
8010871e:	e8 7d 7e ff ff       	call   801005a0 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108723:	83 ec 04             	sub    $0x4,%esp
80108726:	6a 00                	push   $0x0
80108728:	68 00 00 00 80       	push   $0x80000000
8010872d:	ff 75 08             	pushl  0x8(%ebp)
80108730:	e8 11 ff ff ff       	call   80108646 <deallocuvm>
80108735:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108738:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010873f:	eb 48                	jmp    80108789 <freevm+0x7f>
    if(pgdir[i] & PTE_P){
80108741:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108744:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010874b:	8b 45 08             	mov    0x8(%ebp),%eax
8010874e:	01 d0                	add    %edx,%eax
80108750:	8b 00                	mov    (%eax),%eax
80108752:	83 e0 01             	and    $0x1,%eax
80108755:	85 c0                	test   %eax,%eax
80108757:	74 2c                	je     80108785 <freevm+0x7b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108759:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010875c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108763:	8b 45 08             	mov    0x8(%ebp),%eax
80108766:	01 d0                	add    %edx,%eax
80108768:	8b 00                	mov    (%eax),%eax
8010876a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010876f:	05 00 00 00 80       	add    $0x80000000,%eax
80108774:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108777:	83 ec 0c             	sub    $0xc,%esp
8010877a:	ff 75 f0             	pushl  -0x10(%ebp)
8010877d:	e8 c6 a4 ff ff       	call   80102c48 <kfree>
80108782:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108785:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108789:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108790:	76 af                	jbe    80108741 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108792:	83 ec 0c             	sub    $0xc,%esp
80108795:	ff 75 08             	pushl  0x8(%ebp)
80108798:	e8 ab a4 ff ff       	call   80102c48 <kfree>
8010879d:	83 c4 10             	add    $0x10,%esp
}
801087a0:	90                   	nop
801087a1:	c9                   	leave  
801087a2:	c3                   	ret    

801087a3 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801087a3:	55                   	push   %ebp
801087a4:	89 e5                	mov    %esp,%ebp
801087a6:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801087a9:	83 ec 04             	sub    $0x4,%esp
801087ac:	6a 00                	push   $0x0
801087ae:	ff 75 0c             	pushl  0xc(%ebp)
801087b1:	ff 75 08             	pushl  0x8(%ebp)
801087b4:	e8 bd f8 ff ff       	call   80108076 <walkpgdir>
801087b9:	83 c4 10             	add    $0x10,%esp
801087bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801087bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801087c3:	75 0d                	jne    801087d2 <clearpteu+0x2f>
    panic("clearpteu");
801087c5:	83 ec 0c             	sub    $0xc,%esp
801087c8:	68 78 91 10 80       	push   $0x80109178
801087cd:	e8 ce 7d ff ff       	call   801005a0 <panic>
  *pte &= ~PTE_U;
801087d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087d5:	8b 00                	mov    (%eax),%eax
801087d7:	83 e0 fb             	and    $0xfffffffb,%eax
801087da:	89 c2                	mov    %eax,%edx
801087dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087df:	89 10                	mov    %edx,(%eax)
}
801087e1:	90                   	nop
801087e2:	c9                   	leave  
801087e3:	c3                   	ret    

801087e4 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801087e4:	55                   	push   %ebp
801087e5:	89 e5                	mov    %esp,%ebp
801087e7:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801087ea:	e8 ad f9 ff ff       	call   8010819c <setupkvm>
801087ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
801087f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801087f6:	75 0a                	jne    80108802 <copyuvm+0x1e>
    return 0;
801087f8:	b8 00 00 00 00       	mov    $0x0,%eax
801087fd:	e9 eb 00 00 00       	jmp    801088ed <copyuvm+0x109>
  for(i = 0; i < sz; i += PGSIZE){
80108802:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108809:	e9 b7 00 00 00       	jmp    801088c5 <copyuvm+0xe1>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010880e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108811:	83 ec 04             	sub    $0x4,%esp
80108814:	6a 00                	push   $0x0
80108816:	50                   	push   %eax
80108817:	ff 75 08             	pushl  0x8(%ebp)
8010881a:	e8 57 f8 ff ff       	call   80108076 <walkpgdir>
8010881f:	83 c4 10             	add    $0x10,%esp
80108822:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108825:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108829:	75 0d                	jne    80108838 <copyuvm+0x54>
      panic("copyuvm: pte should exist");
8010882b:	83 ec 0c             	sub    $0xc,%esp
8010882e:	68 82 91 10 80       	push   $0x80109182
80108833:	e8 68 7d ff ff       	call   801005a0 <panic>
    if(!(*pte & PTE_P))
80108838:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010883b:	8b 00                	mov    (%eax),%eax
8010883d:	83 e0 01             	and    $0x1,%eax
80108840:	85 c0                	test   %eax,%eax
80108842:	75 0d                	jne    80108851 <copyuvm+0x6d>
      panic("copyuvm: page not present");
80108844:	83 ec 0c             	sub    $0xc,%esp
80108847:	68 9c 91 10 80       	push   $0x8010919c
8010884c:	e8 4f 7d ff ff       	call   801005a0 <panic>
    pa = PTE_ADDR(*pte);
80108851:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108854:	8b 00                	mov    (%eax),%eax
80108856:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010885b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
8010885e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108861:	8b 00                	mov    (%eax),%eax
80108863:	25 ff 0f 00 00       	and    $0xfff,%eax
80108868:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
8010886b:	e8 72 a4 ff ff       	call   80102ce2 <kalloc>
80108870:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108873:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108877:	74 5d                	je     801088d6 <copyuvm+0xf2>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108879:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010887c:	05 00 00 00 80       	add    $0x80000000,%eax
80108881:	83 ec 04             	sub    $0x4,%esp
80108884:	68 00 10 00 00       	push   $0x1000
80108889:	50                   	push   %eax
8010888a:	ff 75 e0             	pushl  -0x20(%ebp)
8010888d:	e8 25 cc ff ff       	call   801054b7 <memmove>
80108892:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80108895:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108898:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010889b:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801088a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088a4:	83 ec 0c             	sub    $0xc,%esp
801088a7:	52                   	push   %edx
801088a8:	51                   	push   %ecx
801088a9:	68 00 10 00 00       	push   $0x1000
801088ae:	50                   	push   %eax
801088af:	ff 75 f0             	pushl  -0x10(%ebp)
801088b2:	e8 55 f8 ff ff       	call   8010810c <mappages>
801088b7:	83 c4 20             	add    $0x20,%esp
801088ba:	85 c0                	test   %eax,%eax
801088bc:	78 1b                	js     801088d9 <copyuvm+0xf5>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801088be:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801088c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088c8:	3b 45 0c             	cmp    0xc(%ebp),%eax
801088cb:	0f 82 3d ff ff ff    	jb     8010880e <copyuvm+0x2a>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }
  return d;
801088d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088d4:	eb 17                	jmp    801088ed <copyuvm+0x109>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
801088d6:	90                   	nop
801088d7:	eb 01                	jmp    801088da <copyuvm+0xf6>
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
801088d9:	90                   	nop
  }
  return d;

bad:
  freevm(d);
801088da:	83 ec 0c             	sub    $0xc,%esp
801088dd:	ff 75 f0             	pushl  -0x10(%ebp)
801088e0:	e8 25 fe ff ff       	call   8010870a <freevm>
801088e5:	83 c4 10             	add    $0x10,%esp
  return 0;
801088e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801088ed:	c9                   	leave  
801088ee:	c3                   	ret    

801088ef <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801088ef:	55                   	push   %ebp
801088f0:	89 e5                	mov    %esp,%ebp
801088f2:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801088f5:	83 ec 04             	sub    $0x4,%esp
801088f8:	6a 00                	push   $0x0
801088fa:	ff 75 0c             	pushl  0xc(%ebp)
801088fd:	ff 75 08             	pushl  0x8(%ebp)
80108900:	e8 71 f7 ff ff       	call   80108076 <walkpgdir>
80108905:	83 c4 10             	add    $0x10,%esp
80108908:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
8010890b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010890e:	8b 00                	mov    (%eax),%eax
80108910:	83 e0 01             	and    $0x1,%eax
80108913:	85 c0                	test   %eax,%eax
80108915:	75 07                	jne    8010891e <uva2ka+0x2f>
    return 0;
80108917:	b8 00 00 00 00       	mov    $0x0,%eax
8010891c:	eb 22                	jmp    80108940 <uva2ka+0x51>
  if((*pte & PTE_U) == 0)
8010891e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108921:	8b 00                	mov    (%eax),%eax
80108923:	83 e0 04             	and    $0x4,%eax
80108926:	85 c0                	test   %eax,%eax
80108928:	75 07                	jne    80108931 <uva2ka+0x42>
    return 0;
8010892a:	b8 00 00 00 00       	mov    $0x0,%eax
8010892f:	eb 0f                	jmp    80108940 <uva2ka+0x51>
  return (char*)P2V(PTE_ADDR(*pte));
80108931:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108934:	8b 00                	mov    (%eax),%eax
80108936:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010893b:	05 00 00 00 80       	add    $0x80000000,%eax
}
80108940:	c9                   	leave  
80108941:	c3                   	ret    

80108942 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108942:	55                   	push   %ebp
80108943:	89 e5                	mov    %esp,%ebp
80108945:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108948:	8b 45 10             	mov    0x10(%ebp),%eax
8010894b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
8010894e:	eb 7f                	jmp    801089cf <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108950:	8b 45 0c             	mov    0xc(%ebp),%eax
80108953:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108958:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
8010895b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010895e:	83 ec 08             	sub    $0x8,%esp
80108961:	50                   	push   %eax
80108962:	ff 75 08             	pushl  0x8(%ebp)
80108965:	e8 85 ff ff ff       	call   801088ef <uva2ka>
8010896a:	83 c4 10             	add    $0x10,%esp
8010896d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108970:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108974:	75 07                	jne    8010897d <copyout+0x3b>
      return -1;
80108976:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010897b:	eb 61                	jmp    801089de <copyout+0x9c>
    n = PGSIZE - (va - va0);
8010897d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108980:	2b 45 0c             	sub    0xc(%ebp),%eax
80108983:	05 00 10 00 00       	add    $0x1000,%eax
80108988:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
8010898b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010898e:	3b 45 14             	cmp    0x14(%ebp),%eax
80108991:	76 06                	jbe    80108999 <copyout+0x57>
      n = len;
80108993:	8b 45 14             	mov    0x14(%ebp),%eax
80108996:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108999:	8b 45 0c             	mov    0xc(%ebp),%eax
8010899c:	2b 45 ec             	sub    -0x14(%ebp),%eax
8010899f:	89 c2                	mov    %eax,%edx
801089a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801089a4:	01 d0                	add    %edx,%eax
801089a6:	83 ec 04             	sub    $0x4,%esp
801089a9:	ff 75 f0             	pushl  -0x10(%ebp)
801089ac:	ff 75 f4             	pushl  -0xc(%ebp)
801089af:	50                   	push   %eax
801089b0:	e8 02 cb ff ff       	call   801054b7 <memmove>
801089b5:	83 c4 10             	add    $0x10,%esp
    len -= n;
801089b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089bb:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801089be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089c1:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801089c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089c7:	05 00 10 00 00       	add    $0x1000,%eax
801089cc:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801089cf:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801089d3:	0f 85 77 ff ff ff    	jne    80108950 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801089d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801089de:	c9                   	leave  
801089df:	c3                   	ret    
