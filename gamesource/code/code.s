
                ; Load Address: $2ffc
                ; File Size: $9df
                ; File End: $cdf3
                ;
                section panel,code_c

                ;--------------------- includes and constants ---------------------------
                INCDIR      "include"
                INCLUDE     "hw.i"

        IFND    TEST_BUILD_LEVEL
                org     $2ffc                                         ; original load address
        ENDC

start
                jmp start     
           
L00003000               bra.b   L00003010
L00003002               move.w  #$0001,L00008d1e        ; batmobile
L0000300a               jmp     L0000301e
L00003010               move.w  #$0000,L00008d1e        ; batwing
L00003018               jmp     L0000301e
L0000301e               moveq   #$00,d0
L00003020               move.w  #$7fff,$00dff09a
L00003028               move.w  #$1fff,$00dff096
L00003030               move.w  #$0200,$00dff100
L00003038               move.l  d0,$00dff102
L0000303e               move.w  #$4000,$00dff024
L00003046               move.l  d0,$00dff040
L0000304c               move.w  #$0041,$00dff058
L00003054               move.w  #$8340,$00dff096
L0000305c               move.w  #$7fff,$00dff09e
L00003064               moveq   #$07,d7
L00003066               lea.l   $00dff140,a0
L0000306c               move.w  d0,(a0)
L0000306e               addq.w  #$08,a0
L00003070               dbf.w   d7,L0000306c 
L00003074               moveq   #$03,d7
L00003076               lea.l   $00dff0a8,a0
L0000307c               move.w  d0,(a0) 
L0000307e               lea.l   $0010(a0),a0
L00003082               dbf.w   d7,L0000307c
L00003086               lea.l   $00dff180,a0
L0000308c               moveq   #$1f,d7
L0000308e               move.w  d0,(a0)+
L00003090               dbf.w   d7,L0000308e
L00003094               move.b  #$7f,$00bfed01
L0000309c               move.b  d0,$00bfee01
L000030a2               move.b  d0,$00bfef01
L000030a8               move.b  d0,$00bfe001
L000030ae               move.b  #$03,$00bfe201
L000030b6               move.b  d0,$00bfe101
L000030bc               move.b  #$ff,$00bfe301
L000030c4               move.b  #$7f,$00bfdd00
L000030cc               move.b  d0,$00bfde00
L000030d2               move.b  d0,$00bfdf00
L000030d8               move.b  #$c0,$00bfd000
L000030e0               move.b  #$c0,$00bfd200
L000030e8               move.b  #$ff,$00bfd100
L000030f0               move.b  #$ff,$00bfd300
L000030f8               lea.l   $0005c1f0,a7                    ; stack
L000030fe               pea.l   $0000310a
L00003104               jmp     $00068f80                       ; music

L0000310a               moveq   #$02,d7
L0000310c               lea.l   L000031ba,a0
L00003112               lea.l   $00000064,a1
L00003118               move.l  (a0)+,(a1)+
L0000311a               dbf.w   d7,L00003118

L0000311e               move.w  #$ff00,$00dff034
L00003126               move.w  d0,$00dff036
L0000312c               or.b    #$ff,$00bfd100
L00003134               and.b   #$87,$00bfd100
L0000313c               and.b   #$87,$00bfd100
L00003144               or.b    #$ff,$00bfd100
L0000314c               move.b  #$f0,$00bfe601
L00003154               move.b  #$37,$00bfeb01
L0000315c               move.b  #$11,$00bfef01
L00003164               move.b  #$91,$00bfd600
L0000316c               move.b  d0,$00bfdb00
L00003172               move.b  d0,$00bfdf00
L00003178               move.w  #$7fff,$00dff09c
L00003180               tst.b   $00bfed01
L00003186               move.b  #$8a,$00bfed01
L0000318e               tst.b   $00bfdd00
L00003194               move.b  #$93,$00bfdd00
L0000319c               move.w  #$e078,$00dff09a
L000031a4               bsr.w   L00003810
L000031a8               lea.l   L000031d2,a0
L000031ae               bsr.w   L00003758
L000031b2               bsr.w   L000037c8
L000031b6               bra.w   L00003822


L000031BA               dc.w    $0000,$3306,$0000,$333E,$0000,$3364,$0000,$33A0        ;..3...3>..3d..3.
L000031CA               dc.w    $0000,$33B6,$0000,$33DC,$400F,$FFFE,$00E0,$0000        ;..3...3.@.......
L000031DA               dc.w    $00E2,$0000,$00E4,$0000,$00E6,$0000,$00E8,$0000        ;................
L000031EA               dc.w    $00EA,$0000,$00EC,$0000,$00EE,$0000,$0180,$0000        ;................
L000031FA               dc.w    $0182,$0002,$0184,$0888,$0186,$0EEE,$0188,$0060        ;...............`
L0000320A               dc.w    $018A,$0800,$018C,$0C00,$018E,$0CCC,$0190,$0AAA        ;................
L0000321A               dc.w    $0192,$0666,$0194,$0000,$0196,$0C60,$0198,$0EA2        ;...f.......`....
L0000322A               dc.w    $019A,$0EE0,$019C,$0EE8,$019E,$0444,$460F,$FFFE        ;...........DF...
L0000323A               dc.w    $0182,$0003,$4B0F,$FFFE,$0182,$0004,$500F,$FFFE        ;....K.......P...
L0000324A               dc.w    $0182,$0005,$550F,$FFFE,$0182,$0006,$5A0F,$FFFE        ;....U.......Z...
L0000325A               dc.w    $0182,$0007,$5F0F,$FFFE,$0182,$0008,$640F,$FFFE        ;...._.......d...
L0000326A               dc.w    $0182,$0009,$690F,$FFFE,$0182,$000A,$600F,$FFFE        ;....i.......`...
L0000327A               dc.w    $0182,$0333,$D90F,$FFFE,$00E0,$0007,$00E2,$C89A        ;...3............
L0000328A               dc.w    $00E4,$0007,$00E6,$D01A,$00E8,$0007,$00EA,$D79A        ;................
L0000329A               dc.w    $00EC,$0007,$00EE,$DF1A,$0180,$0000,$0182,$0000        ;................
L000032AA               dc.w    $0184,$0000,$0186,$0000,$0188,$0000,$018A,$0000        ;................
L000032BA               dc.w    $018C,$0000,$018E,$0000,$0190,$0000,$0192,$0000        ;................
L000032CA               dc.w    $0194,$0000,$0196,$0000,$0198,$0000,$019A,$0000        ;................
L000032DA               dc.w    $019C,$0000,$019E,$0000,$FFFF,$FFFE,$0000,$0060        ;...............`
L000032EA               dc.w    $0FFF,$0008,$0A22,$0444,$0862,$0666,$0888,$0AAA        ;.....".D.b.f....
L000032FA               dc.w    $0A40,$0C60,$0E80,$0EA0,$0EC0,$0EEE 


L00003306               move.l  d0,-(a7)
L00003308               move.w  $00dff01e,d0
L0000330e               btst.l  #$0002,d0
L00003312               bne.b   L00003332
L00003314               btst.l  #$0001,d0
L00003318               bne.b   L00003326
L0000331a               move.w  #$0001,$00dff09c
L00003322               move.l  (a7)+,d0
L00003324               rte

L00003326               move.w  #$0002,$00dff09c
L0000332e               move.l (a7)+,d0
L00003330               rte 

L00003332               move.w  #$0004,$00dff09c
L0000333a               move.l  (a7)+,d0
L0000333c               rte  

L0000333e               move.l  d0,-(a7)
L00003340               move.b  $00bfed01,d0
L00003346               bpl.b   L00003358
L00003348               bsr.w   L0000341a
L0000334c               move.w  #$0008,$00dff09c
L00003354               move.l  (a7)+,d0
L00003356               rte  

L00003358               move.w #$0008,$00dff09c
L00003360               move.l (a7)+,d0
L00003362               rte  

L00003364               move.l  d0,-(a7)
L00003366               move.w  $00dff01e,d0
L0000336c               btst.l  #$0004,d0
L00003370               bne.b   L00003394
L00003372               btst.l  #$0005,d0
L00003376               bne.b   L00003384
L00003378               move.w  #$0040,$00dff09c
L00003380               move.l  (a7)+,d0
L00003382               rte  

L00003384               bsr.w   L00003568
L00003388               move.w  #$0020,$00dff09c
L00003390               move.l  (a7)+,d0
L00003392               rte  

L00003394               move.w #$0010,$00dff09c
L0000339c               move.l (a7)+,d0
L0000339e               rte 

L000033a0               move.l  d0,-(a7)
L000033a2               move.w  $00dff01e,d0
L000033a8               and.w   #$0780,d0
L000033ac               move.w  d0,$00dff09a
L000033b2               move.l  (a7)+,d0
L000033b4               rte  

L000033b6               move.l  d0,-(a7)
L000033b8               move.w  $00dff01e,d0
L000033be               btst.l  #$000c,d0
L000033c2               bne.b   L000033d0
L000033c4               move.w  #$0800,$00dff09c
L000033cc               move.l  (a7)+,d0
L000033ce               rte 

L000033d0               move.w  #$1000,$00dff09c
L000033d8               move.l  (a7)+,d0
L000033da               rte  

L000033dc               move.l  d0,-(a7)
L000033de               move.w  $00dff01e,d0
L000033e4               btst.l  #$000e,d0
L000033e8               bne.b   L0000340e
L000033ea               move.b  $00bfdd00,d0
L000033f0               bpl.b   L00003402
L000033f2               bsr.w   L0000355a
L000033f6               move.w  #$2000,$00dff09c
L000033fe               move.l  (a7)+,d0
L00003400               rte  

L00003402               move.w  #$2000,$00dff09c
L0000340a               move.l  (a7)+,d0
L0000340c               rte 

L0000340e               move.w #$4000,$00dff09c
L00003416               move.l (a7)+,d0
L00003418               rte 

L0000341a               lsr.b   #$02,d0
L0000341c               bcc.b   L00003422
L0000341e               bsr.w   L0000361e
L00003422               lsr.b   #$02,d0
L00003424               bcc.b   L00003494
L00003426               movem.l d1-d2/a0,-(a7)
L0000342a               move.b  $00bfec01,d1
L00003430               not.b   d1
L00003432               lsr.b   #$01,d1
L00003434               bcc.b   L0000344c
L00003436               lea.l   L0000353a,a0
L0000343c               ext.w   d1
L0000343e               move.b  L00003496(pc,d1.w),d1
L00003442               move.w  d1,d2
L00003444               lsr.w   #$03,d2
L00003446               bclr.b  d1,$00(a0,d2.w)
L0000344a               bra.b   L00003488
L0000344c               lea.l   L0000353a,a0
L00003452               ext.w   d1
L00003454               move.b  L00003496(pc,d1.w),d1
L00003458               move.w  d1,d2
L0000345a               lsr.w   #$03,d2
L0000345c               bset.b  d1,$00(a0,d2.w)
L00003460               tst.b   d1
L00003462               beq.b   L00003488
L00003464               lea.l   L00003516,a0
L0000346a               move.w  L00003536,d2
L00003470               move.b  d1,$00(a0,d2.w)
L00003474               addq.w  #$01,d2
L00003476               and.w   #$001f,d2
L0000347a               cmp.w   L00003538,d2
L00003480               beq.b   L00003488
L00003482               move.w  d2,L00003536
L00003488               move.b  #$40,$00bfee01
L00003490               movem.l (a7)+,d1-d2/a0
L00003494               rts  



L00003496               dc.w    $2731,$3233,$3435,$3637,$3839,$302D,$3D5C,$0030         ;'1234567890-=\.0
L000034A6               dc.w    $5157,$4552,$5459,$5549,$4F50,$5B5D,$0031,$3233         ;QWERTYUIOP[].123
L000034B6               dc.w    $4153,$4446,$4748,$4A4B,$4C3B,$2300,$0034,$3536         ;ASDFGHJKL;#..456
L000034C6               dc.w    $005A,$5843,$5642,$4E4D,$2C2E,$2F00,$0037,$3839         ;.ZXCVBNM,./..789
L000034D6               dc.w    $2008,$090D,$0D1B,$7F00,$0000,$2D00,$8C8D,$8E8F         ; .........-.....
L000034E6               dc.w    $8182,$8384,$8586,$8788,$898A,$2829,$2F2A,$2B8B         ;..........()/*+.
L000034F6               dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00003506               dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00003516               dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00003526               dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00003536               dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00003546               dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00003556               dc.w    $0000,$0000 


L0000355a               lsr.b   #$02,d0
L0000355c               bcc.b   L00003566
L0000355e               move.b  #$00,$00bfee01
L00003566               rts 

L00003568               movem.l d0-d7/a0-a6,-(a7)
L0000356c               move.l  L000037c0,d0
L00003572               move.w  d0,L000031dc
L00003578               swap.w  d0
L0000357a               move.w  d0,L000031d8
L00003580               swap.w  d0

L00003582                       add.l   #$000017c0,d0
L00003588                       move.w  d0,L000031e4
L0000358e                       swap.w  d0
L00003590                       move.w  d0,L000031e0 
L00003596                       swap.w  d0
L00003598                       add.l   #$000017c0,d0
L0000359e                       move.w  d0,L000031ec 
L000035a4                       swap.w  d0
L000035a6                       move.w  d0,L000031e8
L000035ac                       swap.w  d0
L000035ae                       add.l   #$000017c0,d0
L000035b4                       move.w  d0,L000031f4
L000035ba                       swap.w  d0
L000035bc                       move.w  d0,L000031f0 
L000035c2                       addq.w  #$01,L000037bc
L000035c8                       tst.w   L00008d20
L000035ce                       bne.b   L00003604
L000035d0                       pea.l   L000035dc
L000035d6                       jmp     $0007c800               ; panel

L000035dc                       tst.w   L00008d32
L000035e2                       bne.b   L00003604
L000035e4                       move.w  L00008f6e,d0
L000035ea                       neg.w   d0
L000035ec                       move.w  #$02ee,d1
L000035f0                       tst.w   L00008d1e 
L000035f6                       beq.b   L000035fc
L000035f8                       move.w  #$0384,d1
L000035fc                       add.w   d1,d0
L000035fe                       move.w  d0,$000690f0            ; music
L00003604                       pea.l   L00003610
L0000360a                       jmp     $00068f98               ; music

L00003610                       move.b  #$00,$00bfee01
L00003618                       movem.l (a7)+,d0-d7/a0-a6
L0000361c                       rts  

L0000361e                       movem.l d0-d7/a0-a6,-(a7)
L00003622                       bsr.w   L00003634
L00003626                       addq.w  #$01,L00003632
L0000362c                       movem.l (a7)+,d0-d7/a0-a6
L00003630                       rts 

L00003632                       dc.w   $0000,$3039
L00003636                       dc.w   $00df
L00003638                       dc.w   $f00a

L0000363a                       move.w  L000036fe,d1
L00003640                       move.w  d0,L000036fe 
L00003646                       bsr.w   L000036c8
L0000364a                       move.b  d0,L00003705 
L00003650                       add.w   d1,L00003714 
L00003656                       add.w   d2,L00003716 
L0000365c                       btst.b  #$0006,$00bfe001
L00003664                       seq.b   L00003704 
L0000366a                       seq.b   L00003712 
L00003670                       btst.b  #$0002,$00dff016
L00003678                       seq.b   L00003713 
L0000367e                       move.w  $00dff00c,d0
L00003684                       move.w  L00003700,d1
L0000368a                       move.w  d0,L00003700 
L00003690                       bsr.b   L000036c8
L00003692                       move.b  d0,L00003709 
L00003698                       add.w   d1,L0000371a 
L0000369e                       add.w   d2,L0000371c 
L000036a4                       btst.b  #$0007,$00bfe001
L000036ac                       seq.b   L00003708 
L000036b2                       seq.b   L00003718 
L000036b8                       btst.b  #$0006,$00dff016
L000036c0                       seq.b   L00003719 
L000036c6                       rts  

L000036c8                       move.w  d0,d3
L000036ca                       move.w  d1,d2
L000036cc                       sub.b   d3,d1
L000036ce                       neg.b   d1
L000036d0                       ext.l   d1
L000036d2                       lsr.w   #$08,d2
L000036d4                       lsr.w   #$08,d3
L000036d6                       sub.b   d3,d2
L000036d8                       neg.b   d2
L000036da                       ext.l   d2
L000036dc                       moveq   #$03,d3
L000036de                       and.w   d0,d3
L000036e0                       lsr.w   #$06,d0
L000036e2                       and.w   #$000c,d0
L000036e6                       or.w    d3,d0
L000036e8                       move.b  L000036ee(pc,d0.w),d0
L000036ec                       rts 


L000036ee                       dc.w    $0002,$0a08
L000036f2                       dc.w    $0103 
L000036f4                       dc.w    $0b09,$0507 
L000036f8                       dc.w    $0f0d,$0406 
L000036fc                       dc.w    $0e0c 
L000036fe                       dc.w    $0000,$0000
L00003702                       dc.w    $0000,$0000
L00003706                       dc.w    $0000,$0000
L0000370a                       dc.w    $0000,$0000
L0000370e                       dc.w    $0000,$0000
L00003712                       dc.w    $0000,$0000
L00003716                       dc.w    $0000,$0000
L0000371a                       dc.w    $0000,$0000

L0000371e                       move.l  d0,-(a7) 
L00003720                       bsr.b   L00003728
L00003722                       bne.b   L00003720
L00003724                       move.l  (a7)+,d0
L00003726                       rts  

L00003728                       movem.l d1-d2/a0,-(a7)
L0000372c                       lea.l   L00003516,a0
L00003732                       moveq   #$00,d0
L00003734                       movem.w L00003536,d1-d2
L0000373c                       cmp.w   d1,d2
L0000373e                       beq.b   L00003750
L00003740                       move.b  $00(a0,d2.w),d0
L00003744                       addq.w  #$01,d2
L00003746                       and.w   #$001f,d2
L0000374a                       move.w  d2,L00003538
L00003750                       tst.b   d0
L00003752                       movem.l (a7)+,d1-d2/a0
L00003756                       rts  

L00003758                       move.w  #$0080,$00dff096
L00003760                       move.l  a0,$00dff080
L00003766                       move.w  a0,$00dff088
L0000376c                       move.w  #$0038,$00dff092
L00003774                       move.w  #$00d0,$00dff094
L0000377c                       move.w  #$4181,$00dff08e
L00003784                       move.w  #$09c1,$00dff090
L0000378c                       move.w  #$0000,$00dff108
L00003794                       move.w  #$0000,$00dff10a
L0000379c                       move.w  #$4200,$00dff100
L000037a4                       clr.w   L000037bc
L000037aa                       tst.w   L000037bc
L000037b0                       beq.b   L000037aa
L000037b2                       move.w  #$8180,$00dff096
L000037ba                       rts  

L000037bc                       dc.w    $0000,$0002
L000037c0                       dc.w    $0005,$c200
L000037c4                       dc.w    $0006,$2100

L000037c8                       move.w  L000037be,d0
L000037ce                       cmp.w   L000037bc,d0
L000037d4                       bhi.b   L000037ce
L000037d6                       movem.l L000037c0,d0-d1
L000037de                       exg.l   d0,d1
L000037e0                       movem.l d0-d1,L000037c0
L000037e8                       move.w  L000037bc,d0
L000037ee                       cmp.w   L000037bc,d0
L000037f4                       beq.b   L000037ee
L000037f6                       clr.w   L000037bc
L000037fc                       move.w  L00008d3a,d0
L00003802                       not.b   d0
L00003804                       add.b   #$d9,d0
L00003808                       move.b  d0,$00003276
L0000380e                       rts 

L00003810                       lea.l   $0005c200,a0            ; external address
L00003816                       move.w  #$2f7f,d7
L0000381a                       clr.l   (a0)+
L0000381c                       dbf.w   d7,L0000381a
L00003820                       rts  

L00003822                       pea.l   L00003834
L00003828                       pea.l   $0007c838               ; panel
L0000382e                       jmp     $0007c854               ; panel

L00003834                       tst.w   L00008d1e
L0000383a                       bne.w   L000038ec
L0000383e                       bsr.w   L00003de0
L00003842                       lea.l   L00003e74,a0
L00003848                       bsr.w   L0000410a
L0000384c                       bsr.w   L00003d6c
L00003850                       bsr.w   L00008158
L00003854                       bsr.w   L000074a4
L00003858                       lea.l   $0003dec0,a0            ; external address
L0000385e                       lea.l   $00045c28,a1            ; external address
L00003864                       bsr.w   L00007b20
L00003868                       lea.l   $00026be6,a0            ; external address
L0000386e                       lea.l   $00028800,a1            ; external address
L00003874                       bsr.w   L00007b20
L00003878                       bsr.w   L00003de0
L0000387c                       move.w  #$03e7,L00008d22
L00003884                       move.w  #$0500,d0
L00003888                       bsr.w   L00003986
L0000388c                       lea.l   L00008d5c,a0
L00003892                       move.w  #$0091,$0010(a0)
L00003898                       move.w  #$00bc,$0030(a0)
L0000389e                       move.w  #$0084,$002e(a0)
L000038a4                       move.w  #$0014,$002a(a0)
L000038aa                       move.w  #$fffc,$002c(a0)
L000038b0                       move.w  #$0004,L00008d2c
L000038b8                       move.w  #$0008,L00008d2e
L000038c0                       move.w  #$0002,L00008d30
L000038c8                       move.w  #$01f4,d0
L000038cc                       cmp.w   L00008d22,d0
L000038d2                       bcc.b   L000038d8
L000038d4                       move.w  #$03e7,d0
L000038d8                       move.w  d0,L00008d22
L000038de                       move.l  #$00008236,L0000907c
L000038e8                       bra.w   L000039aa

L000038ec                       bsr.w   L00003de0
L000038f0                       lea.l   L00003ed0,a0
L000038f6                       bsr.w   L0000410a
L000038fa                       bsr.w   L00003d6c
L000038fe                       bsr.w   L000074a4
L00003902                       lea.l   $00044646,a0            ; external address
L00003908                       lea.l   $0004c3fe,a1            ; external address
L0000390e                       bsr.w   L00007b20
L00003912                       lea.l   $00026be6,a0            ; external address
L00003918                       lea.l   $00028800,a1            ; external address
L0000391e                       bsr.w   L00007b20
L00003922                       bsr.w   L000081ce
L00003926                       move.w  #$0064,L00008d24
L0000392e                       move.w  #$0300,d0
L00003932                       bsr.w   L00003986
L00003936                       lea.l   L00008d5c,a0
L0000393c                       move.w  #$0064,$0010(a0)
L00003942                       move.w  #$0078,L00008f6e
L0000394a                       move.w  #$00c6,$0030(a0)
L00003950                       move.w  #$0070,$002e(a0)
L00003956                       move.w  #$0001,$002a(a0)
L0000395c                       move.w  #$ffec,$002c(a0)
L00003962                       move.w  #$0032,d0
L00003966                       cmp.w   L00008d24,d0
L0000396c                       bcc.b   L00003972
L0000396e                       move.w  #$0064,d0
L00003972                       move.w  d0,L00008d24
L00003978                       move.l  #$00008266,L0000907c
L00003982                       bra.w   L000039aa

L00003986                       lea.l   L00008d26,a0
L0000398c                       move.w  #$01bb,d7
L00003990                       clr.w   (a0)+ [003c]
L00003992                       dbf.w   d7,L00003990
L00003996                       move.w  #$0002,L00008d2a
L0000399e                       pea.l   $0007c854               ; panel
L000039a4                       jmp     $0007c80e               ; panel

L000039aa                       bsr.w   L00006a2c
L000039ae                       move.w  #$0000,L00008d26
L000039b6                       btst.b  #$0000,$0007c875        ; panel
L000039be                       bne.b   L000039ce
L000039c0                       moveq   #$01,d0
L000039c2                       pea.l   L000039ce
L000039c8                       jmp     $00068f90                 ; music

L000039ce                       bsr.w   L00006ee6
L000039d2                       bsr.w   L000067ba
L000039d6                       bsr.w   L00006b02
L000039da                       bsr.w   L0000764a
L000039de                       bsr.w   L000074c8
L000039e2                       bsr.w   L00006d40
L000039e6                       bsr.w   L000051da
L000039ea                       bsr.w   L00005086
L000039ee                       tst.w   L00008d1e 
L000039f4                       bne.b   L00003a00
L000039f6                       bsr.w   L0000459c
L000039fa                       bsr.w   L000044a8
L000039fe                       bra.b   L00003a04
L00003a00                       bsr.w   L000042be
L00003a04                       bsr.w   L00004792
L00003a08                       bsr.w   L00005764
L00003a0c                       bsr.w   L00006f1c
L00003a10                       bsr.w   L00004cb2
L00003a14                       bsr.w   L00003f70
L00003a18                       bsr.w   L00003be0
L00003a1c                       bsr.w   L00003a34
L00003a20                       pea.l   L000039ce
L00003a26                       move.w  L00008d2a,d0
L00003a2c                       bne.w   L00003cb8
L00003a30                       bra.w   L000037c8

L00003a34                       tst.w   L00008f66
L00003a3a                       bne.b   L00003a62
L00003a3c                       move.b  $0007c874,d0            ; panel
L00003a42                       and.b   #$07,d0
L00003a46                       beq.b   L00003a60
L00003a48                       tst.w   L00008d1e
L00003a4e                       beq.b   L00003a62
L00003a50                       tst.w   L00008d38
L00003a56                       bne.b   L00003a60
L00003a58                       move.w  #$0019,L00008d38
L00003a60                       rts  

L00003a62                       move.w  #$0001,L00008d20
L00003a6a                       btst.b  #$0001,$0007c874        ; panel
L00003a72                       bne.w   L00003b18
L00003a76                       pea.l   L00003a82
L00003a7c                       jmp     $00068f84               ; music
L00003a82                       pea.l   L00003a90
L00003a88                       moveq   #$03,d0
L00003a8a                       jmp     $00068f90               ; music

L00003a90                       btst.b  #$0000,$0007c874        ; panel
L00003a98                       beq.b   L00003abc
L00003a9a                       bsr.w   L00003d5a
L00003a9e                       lea.l   L00003f20,a0
L00003aa4                       bsr.w   L0000410a
L00003aa8                       bsr.w   L00003d6c
L00003aac                       clr.w   L000037bc
L00003ab2                       cmp.w   #$0032,L000037bc
L00003aba                       bcs.b   L00003ab2
L00003abc                       bsr.w   L00003d5a
L00003ac0                       lea.l   L00003e74,a0
L00003ac6                       lea.l   L00003884,a1
L00003acc                       tst.w   L00008d1e 
L00003ad2                       beq.b   L00003ae0 
L00003ad4                       lea.l   L00003ed0,a0
L00003ada                       lea.l   L0000392e,a1
L00003ae0                       move.l  a1,(a7)
L00003ae2                       bsr.w   L0000410a
L00003ae6                       bsr.w   L00003d6c
L00003aea                       clr.w   L000037bc
L00003af0                       cmp.w   #$0032,L000037bc
L00003af8                       bcs.b   L00003af0
L00003afa                       cmp.w   #$0001,L00008f66 
L00003b02                       bne.b   L00003b0a
L00003b04                       pea.l   L0007c862               ; panel
L00003b0a                       move.w  #$0000,L00008f66
L00003b12                       jmp     $0007c854               ; panel

L00003b18                       move.w  #$0001,L00008d20
L00003b20                       pea.l   L00003b2c
L00003b26                       jmp     L00068f84
L00003b2c                       pea.l   L00003b3a
L00003b32                       moveq   #$04,d0
L00003b34                       jmp     $00068f90               ; music

L00003b3a                       bsr.w   L00003d5a
L00003b3e                       lea.l   L00003f2c,a0
L00003b44                       bsr.w   L0000410a
L00003b48                       bsr.w   L00003d6c
L00003b4c                       clr.w   L000037bc
L00003b52                       cmp.w   #$0050,L000037bc
L00003b5a                       bcs.b   L00003b52
L00003b5c                       bsr.w   L00003d5a
L00003b60                       bsr.w   L00003d6c
L00003b64                       bsr.w   L00003e2c
L00003b68                       jmp     $00000820               ; loader


L00003b6e                       move.w  #$0001,L00008d20
L00003b76                       pea.l   L00003b82
L00003b7c                       jmp     L00068f84
L00003b82                       pea.l   L00003b90
L00003b88                       moveq   #$02,d0
L00003b8a                       jmp     $00068f90               ; music

L00003b90                       bsr.w   L00003d5a
L00003b94                       lea.l   L00003e92,a0
L00003b9a                       tst.w   L00008d1e 
L00003ba0                       beq.b   L00003ba8 
L00003ba2                       lea.l   L00003ee8,a0
L00003ba8                       bsr.w   L0000410a
L00003bac                       bsr.w   L00003d6c
L00003bb0                       clr.w   L000037bc
L00003bb6                       cmp.w   #$0055,L000037bc
L00003bbe                       bcs.b   L00003bb6
L00003bc0                       bsr.w   L00003d5a
L00003bc4                       bsr.w   L00003d6c
L00003bc8                       bsr.w   L00003e2c
L00003bcc                       tst.w   L00008d1e
L00003bd2                       bne.b   L00003bda
L00003bd4                       jmp     $0000082c               ; loader
L00003bda                       jmp     $00000834               ; loader

L00003be0                       lea.l   L00008d5c,a6
L00003be6                       tst.w   L00008d1e
L00003bec                       beq.b   L00003c2a
L00003bee                       tst.w   $0028(a6)
L00003bf2                       beq.b   L00003c14 
L00003bf4                       tst.w   L00008d34
L00003bfa                       bne.b   L00003c66
L00003bfc                       move.w  #$0001,L00008d34
L00003c04                       move.w  #$0001,L00008d32
L00003c0c                       moveq   #$07,d0
L00003c0e                       jmp     $00068f94               ; music

L00003c14                       tst.w   L00008d34
L00003c1a                       beq.b   L00003c66
L00003c1c                       moveq   #$07,d0
L00003c1e                       pea.l   L00003c66
L00003c24                       jmp     $00068f8c               ; music?

L00003c2a                       tst.w   $0032(a6)
L00003c2e                       beq.b   L00003c50
L00003c30                       tst.w   L00008d34
L00003c36                       bne.b   L00003c66
L00003c38                       move.w  #$0001,L00008d34
L00003c40                       move.w  #$0001,L00008d32
L00003c48                       moveq   #$09,d0
L00003c4a                       jmp     $00068f94               ; music?

L00003c50                       tst.w   L00008d34
L00003c56                       beq.b   L00003c66
L00003c58                       moveq   #$09,d0
L00003c5a                       pea.l   L00003c66
L00003c60                       jmp     $00068f8c               ; music?
L00003c66                       tst.w   $000690a6               ; music?
L00003c6c                       bne.b   L00003c90
L00003c6e                       move.w  #$0000,L00008d32
L00003c76                       move.w  #$0000,L00008d34
L00003c7e                       moveq   #$05,d0
L00003c80                       tst.w   L00008d1e
L00003c86                       beq.b   L00003c8a
L00003c88                       moveq   #$06,d0
L00003c8a                       jmp     $00068f94               ; music

L00003c90                       rts  

L00003c92                       movem.l d1-d7/a0-a6,-(a7)
L00003c96                       move.w  #$0001,L00008d32
L00003c9e                       move.w  #$0000,L00008d34
L00003ca6                       pea.l   L00003cb2
L00003cac                       jmp     L00068f94
L00003cb2                       movem.l (a7)+,d1-d7/a0-a6
L00003cb6                       rts  

L00003cb8                       move.w  #$0000,L00008d2a
L00003cc0                       move.w  #$0000,L00008d20
L00003cc8                       move.w  L00008d3a,d1
L00003cce                       not.b   d1
L00003cd0                       add.b   #$d9,d1
L00003cd4                       move.b  d1,L00003276
L00003cda                       cmp.w   #$0002,d0
L00003cde                       beq.w   L00003d6c
L00003ce2                       moveq   #$00,d0
L00003ce4                       moveq   #$26,d1
L00003ce6                       movea.l L000037c0,a0
L00003cec                       movea.l L000037c4,a1
L00003cf2                       lea.l   $28(a0,d1.w),a2
L00003cf6                       lea.l   $28(a1,d1.w),a3
L00003cfa                       lea.l   $00(a0,d0.w),a0
L00003cfe                       lea.l   $00(a1,d0.w),a1
L00003d02                       moveq   #$4b,d7
L00003d04                       move.w  (a1),(a0)
L00003d06                       move.w  $17c0(a1),$17c0(a0)
L00003d0c                       move.w  $2f80(a1),$2f80(a0)
L00003d12                       move.w  $4740(a1),$4740(a0)
L00003d18                       move.w  (a3),(a2)
L00003d1a                       move.w  $17c0(a3),$17c0(a2)
L00003d20                       move.w  $2f80(a3),$2f80(a2)
L00003d26                       move.w  $4740(a3),$4740(a2)
L00003d2c                       lea.l   $0050(a0),a0
L00003d30                       lea.l   $0050(a1),a1
L00003d34                       lea.l   $0050(a2),a2
L00003d38                       lea.l   $0050(a3),a3
L00003d3c                       dbf.w   d7,L00003d04
L00003d40                       addq.w  #$02,d0
L00003d42                       subq.w  #$02,d1
L00003d44                       bmi.b   L00003d58
L00003d46                       tst.w   L000037bc
L00003d4c                       beq.b   L00003d46
L00003d4e                       move.w  #$0000,L000037bc
L00003d56                       bra.b   L00003ce6
L00003d58                       rts  

L00003d5a                       movea.l L000037c4,a0
L00003d60                       move.w  #$17bf,d7
L00003d64                       clr.l   (a0)+
L00003d66                       dbf.w   d7,L00003d64
L00003d6a                       rts  

L00003d6c                       move.w  #$0028,d0
L00003d70                       move.w  #$0098,d1
L00003d74                       movem.l L000037c0,a0-a1
L00003d7a                       clr.w   d2
L00003d7c                       moveq   #$7f,d3
L00003d7e                       and.w   d2,d3
L00003d80                       moveq   #$0f,d5
L00003d82                       lsr.w   #$01,d3
L00003d84                       bcc.b   L00003d88
L00003d86                       moveq.l #$fffffff0,d5
L00003d88                       cmp.w   d0,d3
L00003d8a                       bcc.b   L00003dd2
L00003d8c                       move.w  d2,d4
L00003d8e                       lsr.w   #$05,d4
L00003d90                       and.w   #$00fc,d4
L00003d94                       cmp.w   d1,d4
L00003d96                       bcc.b   L00003dd2
L00003d98                       mulu.w  d0,d4
L00003d9a                       add.w   d3,d4
L00003d9c                       move.w  d2,-(a7)
L00003d9e                       move.w  d0,d3
L00003da0                       mulu.w  d1,d3
L00003da2                       moveq   #$03,d7
L00003da4                       move.w  d4,-(a7)
L00003da6                       moveq   #$03,d2
L00003da8                       move.b  d5,d6
L00003daa                       not.w   d6
L00003dac                       and.b   $00(a0,d4.w),d6
L00003db0                       move.b  d6,$00(a0,d4.w)
L00003db4                       move.b  d5,d6
L00003db6                       and.b   $00(a1,d4.w),d6
L00003dba                       or.b    $00(a0,d4.w),d6
L00003dbe                       move.b  d6,$00(a0,d4.w)
L00003dc2                       add.w   d0,d4
L00003dc4                       dbf.w   d2,L00003da8
L00003dc8                       move.w  (a7)+,d4
L00003dca                       add.w   d3,d4
L00003dcc                       dbf.w   d7,L00003da4
L00003dd0                       move.w  (a7)+,d2
L00003dd2                       mulu.w  #$0555,d2
L00003dd6                       addq.w  #$01,d2
L00003dd8                       and.w   #$1fff,d2
L00003ddc                       bne.b   L00003d7c
L00003dde                       rts  

L00003de0                       moveq   #$0f,d7
L00003de2                       lea.l   L000032a4,a0
L00003de6                       lea.l   L000032e6,a1
L00003dea                       moveq   #$0f,d6
L00003dec                       move.w  (a0),d0
L00003dee                       move.w  (a1)+,d1
L00003df0                       eor.w   d0,d1
L00003df2                       moveq   #$0f,d2
L00003df4                       and.w   d1,d2
L00003df6                       beq.b   L00003dfa
L00003df8                       addq.w  #$01,d0
L00003dfa                       moveq.l #$fffffff0,d2
L00003dfc                       and.b   d1,d2
L00003dfe                       beq.b   L00003e04
L00003e00                       add.w   #$0010,d0
L00003e04                       and.w   #$0f00,d1
L00003e08                       beq.b   L00003e0e
L00003e0a                       add.w   #$0100,d0
L00003e0e                       move.w  d0,(a0)
L00003e10                       addq.w  #$04,a0
L00003e12                       dbf.w   d6,L00003dec
L00003e16                       move.w  L000037bc,d0
L00003e1c                       addq.w  #$04,d0
L00003e1e                       cmp.w   L000037bc,d0
L00003e24                       bne.b   L00003e1e
L00003e26                       dbf.w   d7,L00003de2
L00003e2a                       rts  

L00003e2c                       moveq   #$0f,d7
L00003e2e                       lea.l   L000032a4,a0
L00003e32                       moveq   #$0f,d6
L00003e34                       move.w  (a0),d0
L00003e36                       moveq   #$0f,d1
L00003e38                       and.w   d0,d1
L00003e3a                       beq.b   L00003e3e
L00003e3c                       subq.w  #$01,d0
L00003e3e                       move.w  #$00f0,d1
L00003e42                       and.w   d0,d1
L00003e44                       beq.b   L00003e4a
L00003e46                       sub.w   #$0010,d0
L00003e4a                       move.w  #$0f00,d1
L00003e4e                       and.w   d0,d1
L00003e50                       beq.b   L00003e56
L00003e52                       sub.w   #$0100,d0
L00003e56                       move.w  d0,(a0)
L00003e58                       addq.w  #$04,a0
L00003e5a                       dbf.w   d6,L00003e34
L00003e5e                       move.w  L000037bc,d0
L00003e64                       addq.w  #$04,d0
L00003e66                       cmp.w   L000037bc,d0
L00003e6c                       bne.b   L00003e66
L00003e6e                       dbf.w   d7,L00003e2e
L00003e72                       rts 

L00003E74                       dc.w    $4407,$5448,$4520,$5354,$5245,$4554,$5320,$4F46         ;D.THE STREETS OF
L00003E84                       dc.w    $2047,$4F54,$4841,$4D20,$4349,$5459,$00FF,$3A07         ; GOTHAM CITY..:.
L00003E94                       dc.w    $594F,$5520,$4841,$5645,$2045,$5343,$4150,$4544         ;YOU HAVE ESCAPED
L00003EA4                       dc.w    $2054,$4845,$204A,$4F4B,$4552,$004E,$0642,$5554         ; THE JOKER.N.BUT
L00003EB4                       dc.w    $2057,$4841,$5420,$5345,$4352,$4554,$5320,$4C49         ; WHAT SECRETS LI
L00003EC4                       dc.w    $4520,$4148,$4541,$442E,$2E2E,$00FF,$440A,$474F         ;E AHEAD.....D.GO
L00003ED4                       dc.w    $5448,$414D,$2043,$4954,$5920,$4341,$524E,$4956         ;THAM CITY CARNIV
L00003EE4                       dc.w    $414C,$00FF,$3A08,$5448,$4520,$4349,$5459,$2049         ;AL..:.THE CITY I
L00003EF4                       dc.w    $5320,$5341,$4645,$2042,$5554,$2054,$4845,$004E         ;S SAFE BUT THE.N
L00003F04                       dc.w    $084A,$4F4B,$4552,$2049,$5320,$5354,$494C,$4C20         ;.JOKER IS STILL
L00003F14                       dc.w    $4154,$204C,$4152,$4745,$2E00,$FF92,$4410,$5449         ;AT LARGE....D.TI
L00003F24                       dc.w    $4D45,$2055,$5000,$FF49,$440F,$4741,$4D45,$204F         ;ME UP..ID.GAME O
L00003F34                       dc.w    $5645,$5200,$FF55,$0201,$5350,$4545,$4400,$0C02         ;VER..U..SPEED...
L00003F44                       dc.w    $3030,$3000,$FF92,$021F,$4449,$5354,$414E,$4345         ;000.....DISTANCE
L00003F54                       dc.w    $000C,$2139,$392E,$3900,$FF29,$021F,$4241,$4C4C         ;..!99.9..)..BALL
L00003F64                       dc.w    $4F4F,$4E53,$000C,$2230,$3030,$00FF 


L00003f70                       move.w  L00008f6e,d0
L00003f76                       tst.w   L00008d98
L00003f7c                       beq.b   L00003f8e
L00003f7e                       cmp.w   #$0002,L00008d98 
L00003f86                       bcs.b   L00003f8e 
L00003f88                       move.w  L00008f70,d0
L00003f8e                       lsr.w   #$01,d0
L00003f90                       lea.l   L00003f44,a0
L00003f96                       bsr.w   L00006780
L00003f9a                       lea.l   L00003f3a,a0
L00003fa0                       bsr.w   L0000410e
L00003fa4                       move.w  $0007c88e,d0            ; panel
L00003faa                       cmp.w   #$0012,d0
L00003fae                       bcc.b   L00003fb6
L00003fb0                       move.w  d0,L00008d28
L00003fb6                       bsr.w   L00003728
L00003fba                       beq.b   L00003fd6
L00003fbc                       cmp.w   #$0081,d0
L00003fc0                       beq.w   L0000403e
L00003fc4                       cmp.w   #$0082,d0
L00003fc8                       beq.b   L0000400c
L00003fca                       cmp.w   #$001b,d0
L00003fce                       beq.b   L00004032
L00003fd0                       cmp.w   #$008a,d0
L00003fd4                       beq.b   L00003ffe 
L00003fd6                       tst.w   L00008d1e
L00003fdc                       beq.w   L0000407a
L00003fe0                       move.w  L00008d24,d0
L00003fe6                       beq.w   L00003b6e
L00003fea                       lea.l   L00003f6b,a0
L00003ff0                       bsr.w   L00006780
L00003ff4                       lea.l   L00003f5e,a0
L00003ffa                       bra.w   L0000410e
L00003ffe                       btst.b  #$0007,$0007c875        ; panel
L00004006                       beq.b   L00003fd6
L00004008                       bra.w   L00003b6e

L0000400c                       bchg.b  #$0000,$0007c875               ; panel
L00004014                       bne.b   L00004024
L00004016                       moveq   #$01,d0
L00004018                       pea.l   L00003fd6               
L0000401e                       jmp     $00068f88               ; music
L00004024                       moveq   #$01,d0
L00004026                       pea.l   L00003fd6
L0000402c                       jmp     $00068f90               ; music
L00004032                       bset.b  #$0005,$0007c875        ; panel
L0000403a                       bra.w   L00003b18

L0000403e                       move.w  #$0001,L00008d20
L00004046                       pea.l   L0000405a
L0000404c                       move.w  L00008d1e,d0
L00004052                       addq.w  #$05,d0
L00004054                       jmp     $00068f8c               ; music
L0000405a                       bsr.w   L00003728
L0000405e                       cmp.w   #$0081,d0
L00004062                       beq.b   L0000405a
L00004064                       bsr.w   L00003728
L00004068                       cmp.w   #$0081,d0
L0000406c                       bne.b   L00004064
L0000406e                       move.w  #$0000,L00008d20
L00004076                       bra.w   L00003fd6

L0000407a                       lea.l   L00003f57,a0
L00004080                       move.w  L00008d26,d1
L00004086                       move.w  L00008d22,d0
L0000408c                       beq.w   L00003b6e
L00004090                       sub.w   #$0006,d1
L00004094                       bmi.b   L000040a4
L00004096                       move.w  d1,L00008d26
L0000409c                       subq.w  #$01,d0
L0000409e                       move.w  d0,L00008d22
L000040a4                       bsr.w   L00006780
L000040a8                       move.b  $0000002e,(a0)+                 ; Exception Vector?
L000040ae                       move.b  d0,(a0)
L000040b0                       lea.l   L00003f4a,a0
L000040b6                       bsr.w   L0000410e
L000040ba                       move.w  L00008d30,d0
L000040c0                       mulu.w  #$0005,d0
L000040c4                       move.w  L00008d36,d1
L000040ca                       cmp.w   #$0005,d1
L000040ce                       bcc.b   L000040d2
L000040d0                       add.w   d1,d0
L000040d2                       lsl.w   #$04,d0
L000040d4                       lea.l   $00036fc8,a5                    ; external address
L000040da                       lea.l   $02(a5,d0.w),a5
L000040de                       moveq   #$00,d3
L000040e0                       move.w  (a5)+,d4
L000040e2                       move.w  (a5)+,d5
L000040e4                       move.w  (a5)+,d7
L000040e6                       move.w  #$0090,d0
L000040ea                       moveq   #$02,d2
L000040ec                       add.w   d7,d2
L000040ee                       bsr.w   L00004e5e

L000040f2                       move.w  L00008d36,d0
L000040f8                       addq.w  #$01,d0
L000040fa                       cmp.w   #$0012,d0
L000040fe                       bcs.b   L00004102
L00004100                       moveq   #$00,d0
L00004102                       move.w  d0,L00008d36
L00004108                       rts     

L0000410a                       moveq.l  #$ffffffff,d6
L0000410c                       bra.b   L00004110
L0000410e                       moveq   #$00,d6
L00004110                       move.b  (a0)+,d0
L00004112                       bmi.w   L00004218
L00004116                       and.w   #$00ff,d0
L0000411a                       mulu.w  #$0028,d0
L0000411e                       move.b  (a0)+,d1
L00004120                       ext.w   d1
L00004122                       add.w   d1,d0
L00004124                       movea.l L000037c4,a1

L0000412a                       lea.l   $00(a1,d0.w),a1
L0000412e                       moveq   #$00,d0
L00004130                       move.b  (a0)+,d0
L00004132                       beq.b   L00004110
L00004134                       cmp.b   #$20,d0
L00004138                       beq.w   L000041b2
L0000413c                       moveq.l #$ffffffcd,d1
L0000413e                       cmp.b   #$41,d0
L00004142                       bcc.b   L00004168
L00004144                       moveq.l #$ffffffd4,d1
L00004146                       cmp.b   #$30,d0
L0000414a                       bcc.b   L00004168
L0000414c                       moveq   #$00,d1
L0000414e                       cmp.b   #$21,d0
L00004152                       beq.b   L0000416e
L00004154                       moveq   #$01,d1
L00004156                       cmp.b   #$28,d0
L0000415a                       beq.b   L0000416e
L0000415c                       moveq   #$02,d1
L0000415e                       cmp.b   #$29,d0
L00004162                       beq.b   L0000416e
L00004164                       moveq   #$03,d1
L00004166                       bra.b   L0000416e

L00004168                       add.b   d0,d1
L0000416a                       and.w   #$00ff,d1
L0000416e                       mulu.w  #$0028,d1
L00004172                       lea.l   L0000910e,a2
L00004178                       lea.l   $00(a2,d1.w),a2
L0000417c                       moveq   #$07,d7
L0000417e                       movea.l a1,a3
L00004180                       tst.w   d6
L00004182                       bmi.b   L000041ba
L00004184                       move.b  (a2)+,d1
L00004186                       and.b   d1,(a3)
L00004188                       move.b  (a2)+,d2
L0000418a                       or.b    d2,(a3)
L0000418c                       and.b   d1,$17c0(a3)
L00004190                       move.b  (a2)+,d2
L00004192                       or.b    d2,$17c0(a3)
L00004196                       and.b   d1,$2f80(a3)
L0000419a                       move.b  (a2)+,d2
L0000419c                       or.b    d2,$2f80(a3)
L000041a0                       and.b   d1,$4740(a3)
L000041a4                       move.b  (a2)+,d2
L000041a6                       or.b    d2,$4740(a3)
L000041aa                       lea.l   $0028(a3),a3
L000041ae                       dbf.w   d7,L00004184
L000041b2                       lea.l   $0001(a1),a1
L000041b6                       bra.w   L0000412e

L000041ba                       move.b  (a2)+,d1
L000041bc                       and.b   d1,(a3)
L000041be                       move.b  (a2)+,d2
L000041c0                       or.b    d2,(a3)
L000041c2                       and.b   d1,$17c0(a3)
L000041c6                       move.b  (a2)+,d2
L000041c8                       or.b    d2,$17c0(a3)
L000041cc                       and.b   d1,$2f80(a3)
L000041d0                       move.b  (a2)+,d2
L000041d2                       or.b    d2,$2f80(a3)
L000041d6                       and.b   d1,$4740(a3)
L000041da                       move.b  (a2)+,d2
L000041dc                       or.b    d2,$4740(a3)
L000041e0                       lea.l   $0028(a3),a3
L000041e4                       lea.l   -$0005(a2),a2
L000041e8                       move.b  (a2)+,d1
L000041ea                       and.b   d1,(a3)
L000041ec                       move.b  (a2)+,d2
L000041ee                       or.b    d2,(a3)
L000041f0                       and.b   d1,$17c0(a3)
L000041f4                       move.b  (a2)+,d2
L000041f6                       or.b    d2,$17c0(a3)
L000041fa                       and.b   d1,$2f80(a3)
L000041fe                       move.b  (a2)+,d2
L00004200                       or.b    d2,$2f80(a3)
L00004204                       and.b   d1,$4740(a3)
L00004208                       move.b  (a2)+,d2
L0000420a                       or.b    d2,$4740(a3)
L0000420e                       lea.l   $0028(a3),a3
L00004212                       dbf.w   d7,L000041ba
L00004216                       bra.b   L000041b2
L00004218                       rts  

L0000421a                       move.l  a0,-(a7)
L0000421c                       lea.l   L00004238,a0
L00004222                       addq.w  #$03,(a0)
L00004224                       move.w  (a0)+,d0
L00004226                       sub.w   #$008d,(a0)
L0000422a                       add.w   (a0)+,d0
L0000422c                       rol.w   #$01,d0
L0000422e                       rol.w   (a0)
L00004230                       add.w   (a0),d0
L00004232                       move.w  d0,(a0)
L00004234                       movea.l (a7)+,a0
L00004236                       rts  

L00004238                       dc.w    $0D80,$007B,$B26E,$0003,$90E2,$0003,$B732,$0000         ;...{.n.......2..
L00004248                       dc.w    $0023,$0000,$4C22,$0003,$90E2,$0003,$D0A4,$0000         ;.#..L"..........
L00004258                       dc.w    $0023,$0000,$4C22,$0003,$90E2,$0003,$E462,$0000         ;.#..L".......b..
L00004268                       dc.w    $002D,$0000,$4BDA,$0003,$90E2,$0004,$0E00,$0000         ;.-..K...........
L00004278                       dc.w    $002D,$0000,$4C22,$0003,$A0C2,$0003,$B732,$0000         ;.-..L".......2..
L00004288                       dc.w    $0037,$0000,$4C22,$0003,$A0C2,$0003,$D0A4,$0000         ;.7..L"..........
L00004298                       dc.w    $0037,$0000,$4C22,$0003,$A0C2,$0003,$E462,$0000         ;.7..L".......b..
L000042A8                       dc.w    $0037,$0000,$4BDA,$0003,$A0C2,$0004,$0E00,$0000         ;.7..K...........
L000042B8                       dc.w    $0037,$0000,$4C22 


L000042be                       move.w  L00008f72,d0
L000042c4                       beq.w   L00004358
L000042c8                       sub.w   d0,L00008d2c
L000042ce                       bcc.w   L00004358
L000042d2                       bsr.w   L0000421a
L000042d6                       and.w   #$000f,d0
L000042da                       add.w   #$000a,d0
L000042de                       move.w  d0,L00008d2c
L000042e4                       bsr.w   L0000475a
L000042e8                       movea.l a6,a5
L000042ea                       pea.l   L0000435a
L000042f0                       bsr.w   L0000475a
L000042f4                       addq.l  #$04,a7
L000042f6                       bsr.w   L0000421a
L000042fa                       and.w   #$0003,d0
L000042fe                       move.b  d0,$0005(a5)
L00004302                       move.b  d0,$0005(a6)
L00004306                       lea.l   L0000478e,a0
L0000430c                       move.b  $00(a0,d0.w),d1
L00004310                       bsr.w   L0000421a
L00004314                       and.w   #$0007,d0
L00004318                       lsl.w   #$04,d0
L0000431a                       lea.l   L0000423e,a0
L00004320                       lea.l   $00(a0,d0.w),a0
L00004324                       move.l  (a0)+,$0012(a6)
L00004328                       move.b  d1,$0003(a6)
L0000432c                       move.l  #$00004362,$0016(a6)
L00004334                       move.l  a5,$0020(a6)
L00004338                       move.l  (a0)+,$0012(a5)
L0000433c                       add.w   (a0)+,d1
L0000433e                       move.b  d1,$0003(a5)
L00004342                       move.l  #$00004436,$0016(a5)
L0000434a                       move.w  (a0)+,$001c(a5)
L0000434e                       move.l  (a0),$0020(a5)
L00004352                       move.w  #$0001,$001a(a5)
L00004358                       rts 

L0000435a                       move.b #$00,$0000(a5)
L00004360                       rts  

L00004362                       move.b  $0008(a1),d0
L00004366                       beq.w   L00004434
L0000436a                       move.b  #$00,$0000(a1)
L00004370                       lea.l   L00008d5c,a6
L00004376                       tst.w   $003a(a6)
L0000437a                       bne.w   L00004434
L0000437e                       move.w  #$0005,$0032(a6)
L00004384                       move.w  #$0004,$003a(a6)
L0000438a                       moveq   #$00,d1
L0000438c                       cmp.b   #$02,d0
L00004390                       beq.b   L000043b4
L00004392                       cmp.b   #$03,d0
L00004396                       bne.b   L0000439a
L00004398                       moveq.l #$ffffffff,d1
L0000439a                       move.w  d1,$0038(a6)
L0000439e                       move.w  L00008f6e,d0
L000043a4                       ext.l   d0

L000043a6                       divu.w  #$000c,d0
L000043aa                       move.w  d0,$0036(a6)
L000043ae                       move.w  $0006(a1),d1
L000043b2                       lsr.w   #$06,d1
L000043b4                       move.w  L00008f6e,d0
L000043ba                       move.w  d0,d2
L000043bc                       ext.l   d0
L000043be                       divu.w  #$0003,d0
L000043c2                       move.w  $0006(a1),d1
L000043c6                       lsr.w   #$06,d1
L000043c8                       add.w   d1,d0
L000043ca                       move.w  d0,L00008f6e
L000043d0                       lea.l   L00008dfc,a6
L000043d6                       moveq   #$01,d6
L000043d8                       tst.w   $0000(a6)
L000043dc                       beq.b   L000043e6
L000043de                       lea.l   $0006(a6),a6
L000043e2                       dbf.w   d6,L000043d8
L000043e6                       move.w  #$0001,$0000(a6)
L000043ec                       move.w  $0010(a1),$0002(a6)
L000043f2                       move.w  $0026(a1),$0004(a6)
L000043f8                       movem.l d7/a1,-(a7)
L000043fc                       move.b  $0002(a1),d0
L00004400                       movea.l $0020(a1),a1
L00004404                       beq.b   L00004422
L00004406                       tst.b   $0000(a1)
L0000440a                       beq.b   L00004422
L0000440c                       cmp.b   $0002(a1),d0
L00004410                       bne.b   L00004422
L00004412                       bsr.b   L0000443e
L00004414                       moveq   #$0e,d0
L00004416                       pea.l   L00004422
L0000441c                       jmp     $00068f8c               ; music

L00004422                       movem.l (a7)+,d7/a1
L00004426                       moveq   #$0d,d0
L00004428                       bsr.w   L00003c92
L0000442c                       moveq   #$01,d0
L0000442e                       jmp     $0007c870               ; panel

L00004434                       rts 

L00004436                       move.b  $0008(a1),d0
L0000443a                       bne.b   L0000443e
L0000443c                       rts  

L0000443e                       move.b  #$00,$0000(a1)
L00004444                       lea.l   L00008dc0,a6
L0000444a                       moveq   #$01,d6
L0000444c                       tst.w   $0000(a6)
L00004450                       beq.b   L0000445a
L00004452                       lea.l   $0014(a6),a6
L00004456                       dbf.w   d6,L0000444c
L0000445a                       move.w  $0010(a1),d0
L0000445e                       move.w  $0026(a1),d1
L00004462                       move.w  #$000c,$0000(a6)
L00004468                       move.w  #$0000,$0002(a6)
L0000446e                       move.w  d0,$0004(a6)
L00004472                       move.w  d1,$0006(a6)
L00004476                       add.w   #$0028,d0
L0000447a                       move.w  d0,$0008(a6)
L0000447e                       move.w  d1,$000a(a6)
L00004482                       sub.w   #$0028,d1
L00004486                       move.w  d0,$000c(a6)
L0000448a                       move.w  d1,$000e(a6)
L0000448e                       sub.w   #$0028,d0
L00004492                       move.w  d0,$0010(a6)
L00004496                       move.w  d1,$0012(a6)
L0000449a                       moveq   #$0e,d0
L0000449c                       bsr.w   L00003c92
L000044a0                       moveq   #$01,d0
L000044a2                       jmp     $0007c870                       ; panel

L000044a8                       tst.w   L00008f64
L000044ae                       beq.w   L00004570
L000044b2                       tst.w   L00008f72
L000044b8                       beq.w   L00004570
L000044bc                       move.w  #$0000,L00008f64
L000044c4                       bsr.w   L0000475a
L000044c8                       move.b  #$00,$0005(a6)
L000044ce                       move.b  L0000478e,$0003(a6)
L000044d6                       move.l  #$0003d214,$0012(a6)            ; addresses?
L000044de                       move.l  #$00004572,$0016(a6)            ; addresses?
L000044e6                       move.w  #$0001,$0024(a6)
L000044ec                       bsr.w   L0000475a
L000044f0                       move.b  #$01,$0005(a6)
L000044f6                       move.b  L0000478f,$0003(a6)
L000044fe                       move.l  #$0003d214,$0012(a6)            ; addresses?
L00004506                       move.l  #$0000478c,$0016(a6)            ; addresses?
L0000450e                       move.w  #$0001,$0024(a6)
L00004514                       move.b  #$15,$0002(a6)
L0000451a                       bsr.w   L0000475a
L0000451e                       move.b  #$02,$0005(a6)
L00004524                       move.b  L00004790,$0003(a6)
L0000452c                       move.l  #$0003d214,$0012(a6)            ; addresses?
L00004534                       move.l  #$0000478c,$0016(a6)            ; addresses?
L0000453c                       move.w  #$0001,$0024(a6)
L00004542                       bsr.w   L0000475a
L00004546                       move.b  #$03,$0005(a6)
L0000454c                       move.b  L00004791,$0003(a6)
L00004554                       move.l  #$0003d214,$0012(a6)            ; addresses?
L0000455c                       move.l  #$0000478c,$0016(a6)            ; addresses?
L00004564                       move.w  #$0001,$0024(a6)
L0000456a                       move.b  #$15,$0002(a6)
L00004570                       rts  

L00004572                       move.b  $0002(a1),d0
L00004576                       ext.w   d0
L00004578                       cmp.w   #$0004,d0
L0000457c                       bcc.b   L0000458a
L0000457e                       move.w  #$0001,L00008f66
L00004586                       moveq   #$00,d0
L00004588                       bra.b   L00004594
L0000458a                       lsl.w   #$04,d0
L0000458c                       cmp.w   L00008f6e,d0
L00004592                       bcc.b   L0000459a
L00004594                       move.w  d0,L00008f6e
L0000459a                       rts  

L0000459c                       move.w  L00008f72,d0
L000045a2                       beq.w   L0000461c
L000045a6                       sub.w   d0,L00008d2c
L000045ac                       bcc.w   L0000461c
L000045b0                       bsr.w   L0000421a
L000045b4                       and.w   #$000f,d0
L000045b8                       add.w   L00008d2e,d0
L000045be                       move.w  d0,L00008d2c
L000045c4                       moveq   #$03,d7
L000045c6                       bsr.w   L0000475c
L000045ca                       bsr.w   L0000421a
L000045ce                       and.w   #$0003,d0
L000045d2                       move.b  $0005d0,(a6)
L000045d6                       lea.l   L0000478e,a0
L000045dc                       move.b  $00(a0,d0.w),$0003(a6)
L000045e2                       bsr.w   L0000421a
L000045e6                       and.w   #$00ff,d0
L000045ea                       add.w   #$0032,d0
L000045ee                       cmp.w   #$0096,d0
L000045f2                       bcc.w   L000045fa
L000045f6                       add.w   #$0096,d0
L000045fa                       move.w  d0,$0006(a6)
L000045fe                       bsr.w   L0000421a
L00004602                       and.w   #$0007,d0
L00004606                       lsl.w   #$02,d0
L00004608                       lea.l   L0000461e,a0
L0000460e                       move.l  $00(a0,d0.w),$0012(a6)
L00004614                       move.l  #$0000463e,$0016(a6)
L0000461c                       rts  


L0000461e                       dc.w    $0003,$8760 
L00004622                       dc.w    $0003,$bbf4 
L00004626                       dc.w    $0003,$9092 
L0000462a                       dc.w    $0003,$9c26 
L0000462e                       dc.w    $0003,$a4e0 
L00004632                       dc.w    $0003,$b060 
L00004636                       dc.w    $0003,$9c26 
L0000463a                       dc.w    $0003,$a4e0 


L0000463e                       bsr.w   L000046c2
L00004642                       move.b  $0008(a1),d0
L00004646                       beq.b   L000046c0
L00004648                       move.b  #$00,$0008(a1)
L0000464e                       lea.l   L00008d5c,a6
L00004654                       tst.w   $003a(a6)
L00004658                       bne.b   L000046c0
L0000465a                       move.w  #$0005,$0032(a6)
L00004660                       move.w  #$0004,$003a(a6)
L00004666                       moveq   #$00,d1
L00004668                       cmp.b   #$02,d0
L0000466c                       beq.b   L00004690
L0000466e                       cmp.b   #$03,d0
L00004672                       bne.b   L00004676
L00004674                       moveq.l #$ffffffff,d1
L00004676                       move.w  d1,$0038(a6)
L0000467a                       move.w  L00008f6e,d0
L00004680                       ext.l   d0
L00004682                       divu.w  #$000c,d0
L00004686                       move.w  d0,$0036(a6)
L0000468a                       move.w  $0006(a1),d1
L0000468e                       lsr.w   #$06,d1
L00004690                       move.w  L00008f6e,d0
L00004696                       move.w  d0,d2
L00004698                       ext.l   d0
L0000469a                       divu.w  #$0003,d0
L0000469e                       move.w  $0006(a1),d1
L000046a2                       lsr.w   #$06,d1
L000046a4                       add.w   d1,d0
L000046a6                       move.w  d0,L00008f6e
L000046ac                       add.b   #$02,$0002(a1)
L000046b2                       moveq   #$0c,d0
L000046b4                       bsr.w   L00003c92
L000046b8                       moveq   #$03,d0
L000046ba                       jmp     $0007c870               ; panel

L000046c0                       rts  

L000046c2                       move.b  $0005(a1),d2
L000046c6                       move.b  $0002(a1),d0
L000046ca                       moveq   #$07,d6
L000046cc                       lea.l   L00008e0e,a2
L000046d2                       cmpa.l  a1,a2
L000046d4                       beq.b   L000046fe
L000046d6                       tst.b   $0000(a2)
L000046da                       beq.b   L000046fe
L000046dc                       move.b  $0002(a2),d1
L000046e0                       sub.b   d0,d1
L000046e2                       bcs.b   L000046fe
L000046e4                       cmp.b   #$03,d1
L000046e8                       bcc.b   L000046fe
L000046ea                       tst.w   $0024(a2)
L000046ee                       beq.b   L000046f8
L000046f0                       move.w  #$0000,$0006(a1)
L000046f6                       bra.b   L000046fe
L000046f8                       cmp.b   $0005(a2),d2
L000046fc                       beq.b   L00004708
L000046fe                       lea.l   $002a(a2),a2
L00004702                       dbf.w   d6,L000046d2
L00004706                       bra.b   L0000472c
L00004708                       tst.b   d2
L0000470a                       bne.b   L00004710
L0000470c                       moveq   #$01,d2
L0000470e                       bra.b   L00004728
L00004710                       cmp.b   #$03,d2
L00004714                       bne.b   L0000471a
L00004716                       moveq   #$02,d2
L00004718                       bra.b   L00004728

L0000471a                       bsr.w   L0000421a
L0000471e                       addq.b  #$01,d2
L00004720                       btst.l  #$0000,d0
L00004724                       beq.b   L00004728 
L00004726                       subq.b  #$02,d2
L00004728                       move.b  d2,$0005(a1)
L0000472c                       lea.l   L0000478e,a2
L00004732                       ext.w   d2
L00004734                       move.b  $00(a2,d2.w),d1
L00004738                       move.b  $0003(a1),d0
L0000473c                       cmp.b   d0,d1
L0000473e                       beq.b   L00004758
L00004740                       bcc.b   L0000474c
L00004742                       subq.b  #$06,d0
L00004744                       cmp.b   d0,d1
L00004746                       bcs.b   L00004754
L00004748                       move.b  d1,d0
L0000474a                       bra.b   L00004754
L0000474c                       addq.b  #$06,d0
L0000474e                       cmp.b   d0,d1
L00004750                       bcc.b   L00004754
L00004752                       move.b  d1,d0
L00004754                       move.b  d0,$0003(a1)
L00004758                       rts  

L0000475a                       moveq   #$07,d7
L0000475c                       lea.l   L00008e0e,a6
L00004762                       tst.b   $0000(a6)
L00004766                       beq.b   L00004774
L00004768                       lea.l   $002a(a6),a6
L0000476c                       dbf.w   d7,L00004762
L00004770                       addq.l  #$04,a7
L00004772                       rts 

L00004774                       moveq   #$14,d7
L00004776                       movea.l a6,a4
L00004778                       move.w  #$0000,(a4)+
L0000477c                       dbf.w   d7,L00004778
L00004780                       move.b  #$16,$0002(a6)
L00004786                       move.b  #$01,$0000(a6)
L0000478c                       rts 


L0000478E                       dc.w    $2864,$A4E2,$41F9,$0000,$8122,$23C8,$0000,$8F5E         ;(d..A...."#....^
L0000479E                       dc.w    $70FF,$3080,$5C48,$3080,$5C48,$3080,$5C48,$3080         ;p.0.\H0.\H0.\H0.
L000047AE                       dc.w    $5C48,$3080,$5C48,$3080,$5C48,$3080,$5C48,$3080         ;\H0.\H0.\H0.\H0.
L000047BE                       dc.w    $5C48,$3080 



L000047c2                       lea.l   L0000909e,a0
L000047c8                       lea.l   L00008e0e,a1
L000047ce                       moveq   #$07,d7
L000047d0                       tst.b   $0000(a1)
L000047d4                       bne.b   L000047e0
L000047d6                       lea.l   $002a(a1),a1
L000047da                       dbf.w   d7,L000047d0
L000047de                       rts 

L000047e0                       moveq   #$00,d1
L000047e2                       move.w  d1,d0
L000047e4                       move.b  $0004(a1),d0
L000047e8                       move.b  $0006(a1),d1
L000047ec                       sub.b   $0007(a1),d0
L000047f0                       bcc.b   L000047f6
L000047f2                       add.b   #$01,d1
L000047f6                       add.b   $0002(a1),d1
L000047fa                       tst.b   $0001(a1)
L000047fe                       bne.b   L0000480e
L00004800                       cmp.b   #$18,d1
L00004804                       bcs.b   L00004824
L00004806                       move.b  #$00,$0000(a1)
L0000480c                       bra.b   L000047d6
L0000480e                       tst.b   d1
L00004810                       ble.b   L00004824
L00004812                       cmp.b   #$02,d1
L00004816                       bcs.b   L0000481e
L00004818                       cmp.b   #$be,d0
L0000481c                       bcc.b   L00004824
L0000481e                       move.b  #$be,d0
L00004822                       moveq   #$01,d1
L00004824                       move.b  d1,$0002(a1)
L00004828                       move.b  d0,$0004(a1)
L0000482c                       cmp.b   #$14,d1
L00004830                       bcc.w   L00004a2c
L00004834                       tst.b   d1
L00004836                       bne.b   L00004858
L00004838                       move.w  L00009078,d2
L0000483e                       and.b   #$e0,d2
L00004842                       not.b   d2
L00004844                       cmp.b   d0,d2
L00004846                       bcc.b   L00004858
L00004848                       tst.b   $0001(a1)
L0000484c                       bne.b   L000047d6
L0000484e                       move.b  #$00,$0000(a1)
L00004854                       bra.w   L000047d6

L00004858                       move.b  $5b(a0,d1.w),d0
L0000485c                       move.b  d0,d2
L0000485e                       sub.b   $5a(a0,d1.w),d0
L00004862                       move.b  $0004(a1),d1
L00004866                       mulu.w  d1,d0
L00004868                       lsr.w   #$08,d0
L0000486a                       move.w  d0,$000a(a1)
L0000486e                       sub.b   d0,d2
L00004870                       add.b   d2,d2
L00004872                       and.w   #$00ff,d2
L00004876                       lea.l   L00007bc8,a2
L0000487c                       lea.l   $00(a2,d2.w),a2
L00004880                       move.w  $0400(a2),d0
L00004884                       move.w  (a2),d1
L00004886                       sub.w   d1,d0
L00004888                       moveq   #$00,d2
L0000488a                       move.b  $0003(a1),d2
L0000488e                       mulu.w  d2,d0
L00004890                       lsr.l   #$08,d0
L00004892                       add.w   d1,d0
L00004894                       move.b  $0002(a1),d2
L00004898                       move.w  d2,d3
L0000489a                       lsr.b   #$02,d2
L0000489c                       add.w   d2,d0
L0000489e                       lsr.w   #$01,d3
L000048a0                       cmp.w   #$0007,d3
L000048a4                       bcs.b   L000048a8
L000048a6                       moveq   #$07,d3
L000048a8                       asl.w   #$04,d3
L000048aa                       movea.l $0012(a1),a2
L000048ae                       lea.l   $00(a2,d3.w),a2
L000048b2                       move.w  (a2),d3
L000048b4                       move.w  d3,$000c(a1)
L000048b8                       move.w  $0006(a2),$000e(a1)
L000048be                       move.w  d0,d6
L000048c0                       lsr.w   #$01,d3
L000048c2                       sub.w   d3,d0
L000048c4                       move.w  d0,$0010(a1)
L000048c8                       tst.w   $0028(a1)
L000048cc                       beq.b   L000048e4
L000048ce                       addq.w  #$06,$001c(a1)
L000048d2                       cmp.w   #$0050,$001c(a1)
L000048d8                       bcs.b   L000048ea
L000048da                       move.b  #$00,$0000(a1)
L000048e0                       bra.w   L000047d6

L000048e4                       tst.w   $001a(a1)
L000048e8                       beq.b   L00004910
L000048ea                       move.w  L00009078,d1
L000048f0                       and.w   #$00e0,d1
L000048f4                       add.b   $0002(a1),d1

L000048f8                       lea.l   L00007821,a2
L000048fe                       move.b  $00(a2,d1.w),d1
L00004902                       mulu.w  $001c(a1),d1
L00004906                       lsr.w   #$05,d1
L00004908                       add.w   $000a(a1),d1
L0000490c                       move.w  d1,$001e(a1)
L00004910                       move.b  $0002(a1),d1
L00004914                       cmp.b   #$02,d1
L00004918                       bcc.w   L000049f0
L0000491c                       ext.w   d1
L0000491e                       move.b  $01(a0,d1.w),d2
L00004922                       and.w   #$00ff,d2
L00004926                       add.w   #$0038,d2
L0000492a                       add.w   $000a(a1),d2
L0000492e                       move.w  d2,$0026(a1)
L00004932                       lea.l   L00008d5c,a2
L00004938                       move.w  $0010(a2),d3
L0000493c                       add.w   $002c(a2),d3
L00004940                       move.w  d3,d4
L00004942                       sub.w   $002a(a2),d4
L00004946                       tst.w   $001a(a1)
L0000494a                       beq.b   L000049aa
L0000494c                       cmp.w   d4,d2
L0000494e                       bcs.b   L000049aa
L00004950                       move.w  d2,d5
L00004952                       sub.w   $001e(a1),d5
L00004956                       move.w  d5,$0026(a1)
L0000495a                       bmi.b   L00004960
L0000495c                       cmp.w   d3,d5
L0000495e                       bcc.b   L000049aa
L00004960                       tst.b   d1
L00004962                       beq.b   L0000496c
L00004964                       tst.b   L00009079
L0000496a                       bpl.b   L000049aa
L0000496c                       sub.w   #$0008,d6
L00004970                       cmp.w   $0030(a2),d6
L00004974                       bcc.b   L000049aa
L00004976                       add.w   #$0010,d6
L0000497a                       cmp.w   $002e(a2),d6
L0000497e                       bcs.b   L000049aa
L00004980                       move.w  #$0000,$001a(a1)
L00004986                       move.w  #$0001,$0028(a1)
L0000498c                       subq.w  #$01,L00008d24
L00004992                       moveq   #$0f,d0
L00004994                       bsr.w   L00003c92
L00004998                       move.l  #$00000200,d0
L0000499e                       pea.l   L000049aa
L000049a4                       jmp     $0007c82a                       ; panel

L000049aa                       sub.w   $001e(a1),d2
L000049ae                       bmi.b   L000049f0
L000049b0                       tst.w   $0028(a1)
L000049b4                       bne.b   L000049f0
L000049b6                       cmp.w   d4,d2
L000049b8                       bcs.b   L000049f0
L000049ba                       sub.w   $000e(a1),d2
L000049be                       bmi.b   L000049c4
L000049c0                       cmp.w   d3,d2
L000049c2                       bcc.b   L000049f0
L000049c4                       cmp.w   $0030(a2),d0
L000049c8                       bcc.b   L000049f0
L000049ca                       move.w  $000c(a1),d2
L000049ce                       add.w   d2,d0
L000049d0                       cmp.w   $002e(a2),d0
L000049d4                       bcs.b   L000049f0
L000049d6                       lsr.w   #$01,d2
L000049d8                       sub.w   d2,d0
L000049da                       moveq   #$03,d1
L000049dc                       cmp.w   #$00b9,d0
L000049e0                       bcc.b   L000049ec
L000049e2                       moveq   #$02,d1
L000049e4                       cmp.w   #$0087,d0
L000049e8                       bcc.b   L000049ec

L000049ea                       moveq   #$01,d1
L000049ec                       move.b  d1,$0008(a1)
L000049f0                       move.b  $0002(a1),d0
L000049f4                       lsl.w   #$08,d0
L000049f6                       move.b  $0004(a1),d0
L000049fa                       not.b   d0
L000049fc                       lea.l   L00008122,a2
L00004a02                       moveq   #$07,d6
L00004a04                       move.w  (a2),d1
L00004a06                       bmi.b   L00004a28
L00004a08                       cmp.w   d0,d1
L00004a0a                       bcs.b   L00004a12
L00004a0c                       addq.l  #$06,a2
L00004a0e                       subq.w  #$01,d6
L00004a10                       bra.b   L00004a04
L00004a12                       subq.w  #$01,d6
L00004a14                       bmi.b   L00004a28
L00004a16                       lea.l   L00008152,a3
L00004a1c                       lea.l   -$0006(a3),a2
L00004a20                       move.l  -(a2),-(a3)
L00004a22                       move.w  -(a2),-(a3)
L00004a24                       dbf.w   d6,L00004a20
L00004a28                       move.w  d0,(a2)+
L00004a2a                       move.l  a1,(a2)
L00004a2c                       movea.l $0016(a1),a2
L00004a30                       pea.l   L000047d6
L00004a36                       jmp     (a2)


L00004a38                       movea.l L00008f5e,a4
L00004a3e                       cmp.b   (a4),d7
L00004a40                       beq.b   L00004a44
L00004a42                       rts  

L00004a44                       movea.l $0002(a4),a6
L00004a48                       addq.l  #$06,L00008f5e
L00004a4e                       movea.l $0012(a6),a5
L00004a52                       lea.l   $00(a5,d5.w),a5
L00004a56                       move.w  (a5)+,d1
L00004a58                       move.w  $0010(a6),d0
L00004a5c                       bmi.b   L00004a68
L00004a5e                       cmp.w   #$0140,d0
L00004a62                       bcs.b   L00004a72
L00004a64                       bra.w   L00004a38

L00004a68                       add.w   d0,d1
L00004a6a                       bmi.b   L00004a38
L00004a6c                       cmp.w   #$0000,d1
L00004a70                       bcs.b   L00004a38
L00004a72                       tst.w   $001a(a6)
L00004a76                       bne.b   L00004a8e
L00004a78                       movem.l d5-d7/a0-a3,-(a7)
L00004a7c                       move.w  $000a(a6),d6
L00004a80                       sub.w   $001e(a6),d6
L00004a84                       bsr.w   L00004e0a
L00004a88                       movem.l (a7)+,d5-d7/a0-a3
L00004a8c                       bra.b   L00004a38

L00004a8e                       movem.l d0-d7/a0-a6,-(a7)
L00004a92                       movea.l $0020(a6),a5
L00004a96                       lsr.w   #$01,d5
L00004a98                       lea.l   $00(a5,d5.w),a5
L00004a9c                       lea.l   $00004c6a,a4
L00004aa2                       lea.l   $00(a4,d5.w),a4
L00004aa6                       add.w   (a5),d0
L00004aa8                       bmi.w   L00004b90
L00004aac                       cmp.w   #$0130,d0
L00004ab0                       bcc.w   L00004b90
L00004ab4                       move.w  $000a(a6),d6
L00004ab8                       move.w  $0002(a5),d7
L00004abc                       beq.w   L00004b90
L00004ac0                       add.w   d7,d6
L00004ac2                       add.w   $0004(a5),d7
L00004ac6                       add.w   $001e(a6),d7
L00004aca                       moveq   #$00,d2
L00004acc                       move.w  d2,d1
L00004ace                       move.b  (a1),d1
L00004ad0                       move.b  $0043(a1),d2
L00004ad4                       sub.w   d2,d1
L00004ad6                       bne.b   L00004aea
L00004ad8                       add.w   d6,d2
L00004ada                       bmi.w   L00004b90
L00004ade                       move.w  d2,d1
L00004ae0                       addq.w  #$01,d1
L00004ae2                       sub.w   d7,d1
L00004ae4                       bcc.b   L00004b06
L00004ae6                       add.w   d1,d7
L00004ae8                       bra.b   L00004b06

L00004aea                       tst.w   d6
L00004aec                       bmi.b   L00004af2
L00004aee                       sub.w   d6,d1
L00004af0                       bra.b   L00004af4

L00004af2                       add.w   d6,d1
L00004af4                       move.w  d1,d6
L00004af6                       beq.b   L00004ad8
L00004af8                       bmi.b   L00004ad8
L00004afa                       subq.w  #$01,d7
L00004afc                       sub.w   d6,d7
L00004afe                       bcs.w   L00004b90
L00004b02                       addq.w  #$01,d7
L00004b04                       bra.b   L00004ade

L00004b06                       movea.l L000037c4,a0
L00004b0c                       addq.w  #$01,d2
L00004b0e                       sub.w   d7,d2
L00004b10                       move.w  d2,d4
L00004b12                       lsl.w   #$02,d2
L00004b14                       add.w   d4,d2
L00004b16                       lsl.w   #$03,d2
L00004b18                       move.w  d0,d4
L00004b1a                       lsr.w   #$03,d0
L00004b1c                       bclr.l  #$0000,d0
L00004b20                       add.w   d2,d0
L00004b22                       lea.l   $00(a0,d0.w),a0
L00004b26                       and.w   #$000f,d4
L00004b2a                       move.w  (a4)+,d0
L00004b2c                       moveq.l #$ffffffff,d1
L00004b2e                       move.w  (a4)+,d1
L00004b30                       swap.w  d1
L00004b32                       movea.l (a4),a4
L00004b34                       subq.w  #$01,d4
L00004b36                       bmi.b   L00004b42
L00004b38                       ror.l   #$01,d1

L00004b3a                       lea.l   $0140(a4),a4
L00004b3e                       dbf.w   d4,L00004b38
L00004b42                       subq.w  #$01,d7
L00004b44                       lea.l   $17c0(a0),a1
L00004b48                       lea.l   $17c0(a1),a2
L00004b4c                       lea.l   $17c0(a2),a3
L00004b50                       moveq   #$00,d2
L00004b52                       tst.w   d0
L00004b54                       bmi.b   L00004b98
L00004b56                       and.l   d1,(a0)
L00004b58                       move.l  $00(a4,d2.w),d3
L00004b5c                       or.l    d3,(a0)
L00004b5e                       and.l   d1,(a1)
L00004b60                       move.l  $04(a4,d2.w),d3
L00004b64                       or.l    d3,(a1)
L00004b66                       and.l   d1,(a2)
L00004b68                       move.l  $08(a4,d2.w),d3
L00004b6c                       or.l    d3,(a2)
L00004b6e                       and.l   d1,(a3)
L00004b70                       move.l  $0c(a4,d2.w),d3
L00004b74                       or.l    d3,(a3)
L00004b76                       lea.l   $0028(a0),a0
L00004b7a                       lea.l   $0028(a1),a1
L00004b7e                       lea.l   $0028(a2),a2
L00004b82                       lea.l   $0028(a3),a3
L00004b86                       add.w   #$0010,d2
L00004b8a                       and.w   d0,d2
L00004b8c                       dbf.w   d7,L00004b56
L00004b90                       movem.l (a7)+,d0-d7/a0-a6
L00004b94                       bra.w   L00004a78

L00004b98                       and.l   d1,(a0)
L00004b9a                       move.l  $00(a4,d2.w),d3
L00004b9e                       or.l    d3,(a0)
L00004ba0                       and.l   d1,(a1)
L00004ba2                       move.l  $04(a4,d2.w),d3
L00004ba6                       or.l    d3,(a1)
L00004ba8                       and.l   d1,(a2)
L00004baa                       move.l  $08(a4,d2.w),d3
L00004bae                       or.l    d3,(a2)
L00004bb0                       and.l   d1,(a3)
L00004bb2                       move.l  $0c(a4,d2.w),d3
L00004bb6                       or.l    d3,(a3)
L00004bb8                       lea.l   $0028(a0),a0
L00004bbc                       lea.l   $0028(a1),a1
L00004bc0                       lea.l   $0028(a2),a2
L00004bc4                       lea.l   $0028(a3),a3
L00004bc8                       add.w   #$0010,d2
L00004bcc                       cmp.w   #$0030,d2
L00004bd0                       bne.b   L00004bd4
L00004bd2                       moveq   #$00,d2
L00004bd4                       dbf.w   d7,L00004b98
L00004bd8                       bra.b   L00004b90



L00004BDA                       dc.w    $0032,$FFDC,$000A,$0000,$0021,$FFE4,$0008,$0000         ;.2.......!......
L00004BEA                       dc.w    $0018,$FFEA,$0006,$0000,$0013,$FFEE,$0004,$0000         ;................
L00004BFA                       dc.w    $0011,$FFF2,$0002,$0000,$000E,$FFF4,$0002,$0000         ;................
L00004C0A                       dc.w    $000C,$FFF6,$0002,$0000,$000B,$FFF8,$0002,$0000         ;................
L00004C1A                       dc.w    $000B,$FFFA,$0002,$0000,$001D,$FFDC,$000A,$0000         ;................
L00004C2A                       dc.w    $0013,$FFE4,$0008,$0000,$000E,$FFEA,$0006,$0000         ;................
L00004C3A                       dc.w    $000B,$FFEE,$0004,$0000,$0009,$FFF2,$0002,$0000         ;................
L00004C4A                       dc.w    $0008,$FFF4,$0002,$0000,$0007,$FFF6,$0002,$0000         ;................
L00004C5A                       dc.w    $0006,$FFF8,$0002,$0000,$0006,$FFFA,$0002,$0000         ;................
L00004C6A                       dc.w    $0030,$07FF,$0003,$7CE2,$FFFF,$07FF,$0003,$7D22         ;.0....|.......}"
L00004C7A                       dc.w    $FFFF,$0FFF,$0003,$7D52,$0010,$0FFF,$0003,$7D82         ;......}R......}.
L00004C8A                       dc.w    $0010,$1FFF,$0003,$7DA2,$0010,$3FFF,$0003,$7DC2         ;......}...?...}.
L00004C9A                       dc.w    $0000,$3FFF,$0003,$7DE2,$0010,$7FFF,$0003,$7DF2         ;..?...}.......}.
L00004CAA                       dc.w    $0000,$7FFF,$0003,$7E12 



L00004cb2                       tst.w   L00008d1e
L00004cb8                       beq.b   L00004cbe
L00004cba                       bsr.w   L00005f5a
L00004cbe                       lea.l   L0000909f,a0
L00004cc4                       lea.l   L000090e2,a1
L00004cca                       move.w  #$0014,d7
L00004cce                       move.w  #$0038,d0
L00004cd2                       add.b   d0,(a0)+
L00004cd4                       add.b   d0,(a1)+
L00004cd6                       dbf.w   d7,L00004cd2
L00004cda                       lea.l   L00008116,a0
L00004ce0                       lea.l   L000090b2,a1
L00004ce6                       lea.l   L00008f74,a2
L00004cec                       lea.l   L00007a20,a3
L00004cf2                       move.w  L00009078,d0
L00004cf8                       and.w   #$00e0,d0
L00004cfc                       lea.l   $00(a3,d0.w),a3
L00004d00                       move.w  L00009076,d6
L00004d06                       add.b   #$53,d6
L00004d0a                       move.w  #$0013,d7
L00004d0e                       tst.w   L00008d1e
L00004d14                       beq.w   L00005c88
L00004d18                       move.w  d7,d5
L00004d1a                       lsr.w   #$01,d5
L00004d1c                       cmp.w   #$0008,d5
L00004d20                       bcs.b   L00004d24
L00004d22                       moveq   #$08,d5
L00004d24                       asl.w   #$04,d5
L00004d26                       bsr.w   L00004a38
L00004d2a                       move.b  $00(a2,d6.w),d0
L00004d2e                       bne.b   L00004d56
L00004d30                       add.b   #$20,d6
L00004d34                       subq.w  #$02,a0
L00004d36                       move.b  $00(a2,d6.w),d0
L00004d3a                       bne.b   L00004da8
L00004d3c                       sub.b   #$21,d6
L00004d40                       subq.w  #$02,a0
L00004d42                       subq.w  #$01,a1
L00004d44                       dbf.w   d7,L00004d0e

L00004d48                       tst.w   L00008d1e
L00004d4e                       beq.w   L00005c9c
L00004d52                       bra.w   L00005f92
L00004d56                       lsl.w   #$04,d0
L00004d58                       and.w   #$00f0,d0
L00004d5c                       lea.l   L00008bae,a4
L00004d62                       movea.l $00(a4,d0.w),a5
L00004d66                       move.b  $04(a4,d0.w),d1
L00004d6a                       move.b  $05(a4,d0.w),d2
L00004d6e                       move.b  $00(a3,d7.w),d0
L00004d72                       ext.w   d0
L00004d74                       ext.w   d1
L00004d76                       mulu.w  d1,d0
L00004d78                       ext.w   d2
L00004d7a                       beq.b   L00004d7e
L00004d7c                       divu.w  d2,d0
L00004d7e                       add.w   (a0),d0
L00004d80                       lea.l   $00(a5,d5.w),a5
L00004d84                       move.w  (a5)+,d1
L00004d86                       tst.w   d0
L00004d88                       bmi.b   L00004d92
L00004d8a                       cmp.w   #$0130,d0
L00004d8e                       bcs.b   L00004d9c
L00004d90                       bra.b   L00004d30
L00004d92                       add.w   d0,d1
L00004d94                       bmi.b   L00004d30
L00004d96                       cmp.w   #$fff0,d0
L00004d9a                       bcs.b   L00004d30
L00004d9c                       movem.l d5-d7/a0-a3,-(a7)
L00004da0                       bsr.b   L00004e08
L00004da2                       movem.l (a7)+,d5-d7/a0-a3
L00004da6                       bra.b   L00004d30

L00004da8                       lsl.w   #$04,d0
L00004daa                       and.w   #$00f0,d0
L00004dae                       lea.l   L00008c5e,a4
L00004db4                       movea.l $00(a4,d0.w),a5
L00004db8                       move.b  $04(a4,d0.w),d1
L00004dbc                       move.b  $05(a4,d0.w),d2
L00004dc0                       move.b  $00(a3,d7.w),d0
L00004dc4                       ext.w   d0
L00004dc6                       ext.w   d1
L00004dc8                       mulu.w  d1,d0
L00004dca                       ext.w   d2
L00004dcc                       beq.b   L00004dd0
L00004dce                       divu.w  d2,d0
L00004dd0                       neg.w   d0
L00004dd2                       add.w   #$000a,d0
L00004dd6                       add.w   (a0),d0
L00004dd8                       lea.l   $00(a5,d5.w),a5
L00004ddc                       move.w  (a5)+,d1
L00004dde                       sub.w   d1,d0
L00004de0                       bmi.b   L00004dec
L00004de2                       cmp.w   #$0130,d0
L00004de6                       bcs.b   L00004dfa
L00004de8                       bra.w   L00004d3c
L00004dec                       add.w   d0,d1
L00004dee                       bmi.w   L00004d3c
L00004df2                       cmp.w   #$0000,d1
L00004df6                       bcs.w   L00004d3c
L00004dfa                       movem.l d5-d7/a0-a3,-(a7)
L00004dfe                       bsr.b   L00004e08
L00004e00                       movem.l (a7)+,d5-d7/a0-a3
L00004e04                       bra.w   L00004d3c

L00004e08                       moveq   #$00,d6
L00004e0a                       move.w  (a5)+,d4
L00004e0c                       move.w  (a5)+,d5
L00004e0e                       move.w  (a5)+,d7
L00004e10                       moveq   #$00,d3
L00004e12                       move.w  d3,d2
L00004e14                       move.w  d3,d1
L00004e16                       move.b  (a1),d1
L00004e18                       move.b  $0043(a1),d2
L00004e1c                       sub.w   d2,d1
L00004e1e                       bne.b   L00004e3c
L00004e20                       add.w   d6,d2
L00004e22                       bmi.b   L00004e3a
L00004e24                       move.w  d2,d1
L00004e26                       addq.w  #$01,d1
L00004e28                       sub.w   d7,d1
L00004e2a                       bcc.b   L00004e5e
L00004e2c                       add.w   d1,d7
L00004e2e                       neg.w   d1
L00004e30                       subq.w  #$01,d1
L00004e32                       add.w   d5,d3
L00004e34                       dbf.w   d1,L00004e32
L00004e38                       bra.b   L00004e5e
L00004e3a                       rts  

L00004e3c                       tst.w   d6
L00004e3e                       bmi.b   L00004e44
L00004e40                       sub.w   d6,d1
L00004e42                       bra.b   L00004e46

L00004e44                       add.w   d6,d1
L00004e46                       move.w  d1,d6
L00004e48                       beq.b   L00004e20
L00004e4a                       bmi.b   L00004e20
L00004e4c                       subq.w  #$01,d7
L00004e4e                       sub.w   d6,d7
L00004e50                       bcs.b   L00004e3a
L00004e52                       addq.w  #$01,d7
L00004e54                       bra.b   L00004e24
L00004e56                       lea.l   L00004fcc,a6
L00004e5c                       bra.b   L00004e64

L00004e5e                       lea.l   L00004ec0,a6
L00004e64                       move.w  d0,d1
L00004e66                       asr.w   #$04,d1
L00004e68                       bmi.b   L00004e86
L00004e6a                       cmp.w   #$0000,d1
L00004e6e                       bcs.b   L00004e86
L00004e70                       moveq   #$00,d6
L00004e72                       add.w   d4,d1
L00004e74                       sub.w   #$0014,d1
L00004e78                       bcs.b   L00004e82
L00004e7a                       sub.w   d4,d1
L00004e7c                       neg.w   d1
L00004e7e                       not.w   d6
L00004e80                       bra.b   L00004e9a

L00004e82                       move.w  d4,d1
L00004e84                       bra.b   L00004e9a
L00004e86                       add.w   d4,d1
L00004e88                       sub.w   #$0000,d1
L00004e8c                       move.w  d1,d6
L00004e8e                       neg.w   d6
L00004e90                       add.w   d4,d6
L00004e92                       and.w   #$000f,d0
L00004e96                       or.w    #$0000,d0
L00004e9a                       movea.l L000037c4,a0
L00004ea0                       addq.w  #$01,d2
L00004ea2                       sub.w   d7,d2
L00004ea4                       move.w  d2,d4
L00004ea6                       lsl.w   #$02,d2
L00004ea8                       add.w   d4,d2
L00004eaa                       lsl.w   #$03,d2
L00004eac                       move.w  d0,d4
L00004eae                       lsr.w   #$03,d0
L00004eb0                       bclr.l  #$0000,d0
L00004eb4                       add.w   d2,d0
L00004eb6                       lea.l   $00(a0,d0.w),a0
L00004eba                       and.w   #$000f,d4
L00004ebe                       jmp     (a6)

L00004ec0                       move.w  #$0000,$00dff046
L00004ec8                       move.w  #$ffff,$00dff044
L00004ed0                       lsl.w   #$01,d6
L00004ed2                       beq.b   L00004f06
L00004ed4                       bmi.b   L00004ef2
L00004ed6                       add.w   d6,d3
L00004ed8                       move.w  d4,d6
L00004eda                       lsl.w   #$01,d6
L00004edc                       lea.l   L00004fac,a1
L00004ee2                       move.w  $00(a1,d6.w),$00dff044
L00004eea                       subq.w  #$02,a0
L00004eec                       subq.w  #$02,d3
L00004eee                       addq.w  #$01,d1
L00004ef0                       bra.b   L00004f06
L00004ef2                       move.w  d4,d6
L00004ef4                       lsl.w   #$01,d6

L00004ef6                       lea.l   $00004f8c,a1
L00004efc                       move.w  $00(a1,d6.w),$00dff046
L00004f04                       subq.w  #$01,d1
L00004f06                       move.l  (a5),d0
L00004f08                       lea.l   $00(a5,d0.l),a4
L00004f0c                       lea.l   $00(a4,d3.w),a4
L00004f10                       move.l  $0004(a5),d3
L00004f14                       lsl.w   #$06,d7
L00004f16                       addq.w  #$01,d1
L00004f18                       move.w  d1,d2
L00004f1a                       or.w    d7,d1
L00004f1c                       ror.w   #$04,d4
L00004f1e                       move.w  d4,$00dff042
L00004f24                       or.w    #$0fca,d4
L00004f28                       move.w  d4,$00dff040
L00004f2e                       lsl.w   #$01,d2
L00004f30                       sub.w   d2,d5
L00004f32                       not.w   d2
L00004f34                       add.w   #$0029,d2
L00004f38                       movea.l a4,a1
L00004f3a                       move.w  d5,$00dff064
L00004f40                       move.w  d5,$00dff062
L00004f46                       move.w  d2,$00dff060
L00004f4c                       move.w  d2,$00dff066
L00004f52                       moveq   #$03,d7
L00004f54                       lea.l   $00(a1,d3.l),a1
L00004f58                       move.l  a4,$00dff050
L00004f5e                       move.l  a1,$00dff04c
L00004f64                       move.l  a0,$00dff048
L00004f6a                       move.l  a0,$00dff054
L00004f70                       move.w  d1,$00dff058
L00004f76                       move.w  $00dff002,d0
L00004f7c                       btst.l  #$000e,d0
L00004f80                       bne.b   L00004f76
L00004f82                       lea.l   $17c0(a0),a0
L00004f86                       dbf.w   d7,L00004f54
L00004f8a                       rts 



L00004F8A                       dc.w    $4E75,$FFFF,$FFFE,$FFFC,$FFF8,$FFF0,$FFE0,$FFC0         ;Nu..............
L00004F9A                       dc.w    $FF80,$FF00,$FE00,$FC00,$F800,$F000,$E000,$C000         ;................
L00004FAA                       dc.w    $8000,$0000,$0001,$0003,$0007,$000F,$001F,$003F         ;...............?
L00004FBA                       dc.w    $007F,$00FF,$01FF,$03FF,$07FF,$0FFF,$1FFF,$3FFF         ;..............?.
L00004FCA                       dc.w    $7FFF 



L00004fcc                       move.w  #$0000,$00dff046
L00004fd4                       move.w  #$ffff,$00dff044
L00004fdc                       lsl.w   #$01,d6
L00004fde                       beq.b   L00005012
L00004fe0                       bmi.b   L00004ffe
L00004fe2                       add.w   d6,d3
L00004fe4                       move.w  d4,d6
L00004fe6                       lsl.w   #$01,d6
L00004fe8                       lea.l   L00004fac,a1
L00004fee                       move.w  $00(a1,d6.w),$00dff044
L00004ff6                       subq.w  #$02,a0
L00004ff8                       subq.w  #$02,d3
L00004ffa                       addq.w  #$01,d1
L00004ffc                       bra.b   L00005012

L00004ffe                       move.w  d4,d6
L00005000                       lsl.w   #$01,d6
L00005002                       lea.l   L00004f8c,a1
L00005008                       move.w  $00(a1,d6.w),$00dff046
L00005010                       subq.w  #$01,d1
L00005012                       move.l  (a5),d0
L00005014                       lea.l   $00(a5,d0.l),a4
L00005018                       lea.l   $00(a4,d3.w),a4
L0000501c                       lsl.w   #$06,d7
L0000501e                       addq.w  #$01,d1
L00005020                       move.w  d1,d2
L00005022                       or.w    d7,d1
L00005024                       ror.w   #$04,d4
L00005026                       move.w  #$0000,$00dff042
L0000502e                       or.w    #$0b0a,d4
L00005032                       move.w  d4,$00dff040
L00005038                       lsl.w   #$01,d2
L0000503a                       sub.w   d2,d5
L0000503c                       not.w   d2
L0000503e                       add.w   #$0029,d2
L00005042                       movea.l a4,a1
L00005044                       move.w  d5,$00dff064
L0000504a                       move.w  d2,$00dff060
L00005050                       move.w  d2,$00dff066
L00005056                       moveq   #$03,d7
L00005058                       move.l  a4,$00dff050
L0000505e                       move.l  a0,$00dff048
L00005064                       move.l  a0,$00dff054
L0000506a                       move.w  d1,$00dff058
L00005070                       move.w  $00dff002,d0
L00005076                       btst.l  #$000e,d0
L0000507a                       bne.b   L00005070
L0000507c                       lea.l   $17c0(a0),a0
L00005080                       dbf.w   d7,L00005058
L00005084                       rts  

L00005086                       lea.l   L000080c8,a0
L0000508c                       lea.l   L00008d5c,a1
L00005092                       tst.w   $003a(a1)
L00005096                       bne.w   L000051d8
L0000509a                       moveq   #$00,d1
L0000509c                       move.w  (a0)+,d0
L0000509e                       bmi.b   L000050c2
L000050a0                       move.w  $002e(a1),d3
L000050a4                       addq.w  #$05,d3
L000050a6                       cmp.w   d3,d0
L000050a8                       bcs.b   L000050c2
L000050aa                       moveq   #$00,d6
L000050ac                       moveq   #$60,d2
L000050ae                       lea.l   L00008c5e,a3
L000050b4                       moveq   #$01,d1
L000050b6                       add.w   #$0037,d3
L000050ba                       cmp.w   d3,d0
L000050bc                       bcs.b   L000050e4
L000050be                       moveq   #$02,d1
L000050c0                       bra.b   L000050e4

L000050c2                       move.w  (a0)+,d0
L000050c4                       move.w  $0030(a1),d3
L000050c8                       subq.w  #$05,d3
L000050ca                       cmp.w   d3,d0
L000050cc                       bcc.b   L000050e4
L000050ce                       moveq.l #$ffffffff,d6
L000050d0                       moveq   #$40,d2

L000050d2                       lea.l   L00008bae,a3
L000050d8                       moveq   #$01,d1
L000050da                       sub.w   #$0037,d3
L000050de                       cmp.w   d3,d0
L000050e0                       bcc.b   L000050e4
L000050e2                       moveq   #$02,d1
L000050e4                       move.w  d1,L00008f62
L000050ea                       beq.w   L000051d8
L000050ee                       lea.l   L00007a20,a2
L000050f4                       move.w  L00009078,d3
L000050fa                       and.w   #$00e0,d3
L000050fe                       lea.l   $00(a2,d3.w),a2
L00005102                       lea.l   L0000909f,a4
L00005108                       lea.l   L00008f74,a5
L0000510e                       add.b   L00009077,d2
L00005114                       move.b  $00(a5,d2.w),d1
L00005118                       bne.b   L0000512a
L0000511a                       move.b  $01(a5,d2.w),d1
L0000511e                       beq.w   L000051d8
L00005122                       move.w  $0002(a0),d0
L00005126                       addq.l  #$01,a2
L00005128                       addq.l  #$01,a4
L0000512a                       lsl.w   #$04,d1
L0000512c                       lea.l   $00(a3,d1.w),a3
L00005130                       move.b  $0004(a3),d2
L00005134                       move.b  $0005(a3),d3
L00005138                       move.b  (a2),d1
L0000513a                       ext.w   d2
L0000513c                       ext.w   d1
L0000513e                       mulu.w  d2,d1
L00005140                       ext.w   d3
L00005142                       beq.b   L00005146
L00005144                       divu.w  d3,d1
L00005146                       tst.w   d6
L00005148                       bmi.b   L00005154
L0000514a                       neg.w   d1
L0000514c                       add.w   #$000a,d1
L00005150                       sub.w   $000c(a3),d0
L00005154                       add.w   d1,d0
L00005156                       add.w   $0006(a3),d0
L0000515a                       move.b  (a4),d2
L0000515c                       and.w   #$00ff,d2
L00005160                       add.w   #$0038,d2

L00005164                       move.w  $0010(a1),d3
L00005168                       add.w   $002c(a1),d3
L0000516c                       move.w  d3,d4
L0000516e                       sub.w   $002a(a1),d4
L00005172                       cmp.w   d4,d2
L00005174                       bcs.b   L000051d8
L00005176                       sub.w   $000a(a3),d2
L0000517a                       bmi.b   L00005180
L0000517c                       cmp.w   d3,d2
L0000517e                       bcc.b   L000051d8
L00005180                       moveq   #$01,d1
L00005182                       cmp.w   $0030(a1),d0
L00005186                       bcc.b   L000051d8
L00005188                       add.w   $0008(a3),d0
L0000518c                       cmp.w   $002e(a1),d0
L00005190                       bcs.b   L000051d8
L00005192                       cmp.w   #$00a0,d0
L00005196                       bcs.b   L0000519a
L00005198                       addq.b  #$01,d1
L0000519a                       move.w  #$0004,$003a(a1)
L000051a0                       move.w  d6,$0038(a1)
L000051a4                       move.w  L00008f6e,d0
L000051aa                       ext.l   d0
L000051ac                       divu.w  #$0007,d0
L000051b0                       add.w   #$0008,d0
L000051b4                       move.w  d0,$0036(a1)
L000051b8                       move.w  L00008f6e,d0
L000051be                       ext.l   d0
L000051c0                       divu.w  #$0003,d0
L000051c4                       move.w  d0,L00008f6e
L000051ca                       moveq   #$0c,d0
L000051cc                       bsr.w   L00003c92
L000051d0                       moveq   #$03,d0
L000051d2                       jmp     $0007c870               ; Panel


L000051d8                       rts  


L000051da                       lea.l   L000090f9,a0
L000051e0                       movea.l a0,a1
L000051e2                       move.w  #$0014,d7
L000051e6                       move.w  d7,d6
L000051e8                       moveq   #$00,d0
L000051ea                       add.b   (a0),d0
L000051ec                       move.b  d0,(a0)+
L000051ee                       dbf.w   d7,L000051ea
L000051f2                       lea.l   L000080c8,a0
L000051f8                       lea.l   L00007bc8,a2
L000051fe                       lea.l   L00007fc8,a3
L00005204                       move.b  (a1)+,d0
L00005206                       lsl.w   #$01,d0
L00005208                       move.w  $00(a2,d0.w),(a0)+
L0000520c                       move.w  $00(a3,d0.w),(a0)+
L00005210                       dbf.w   d6,L00005204
L00005214                       rts  


L00005216                       dc.w    $ffce
L00005218                       dc.w    $0000,$ffe2
L0000521c                       dc.w    $0000,$ffec
L00005220                       dc.w    $0000,$fff6
L00005224                       dc.w    $0000,$fff8
L00005228                       dc.w    $0001,$fffc
L0000522c                       dc.w    $0001,$ffff
L00005230                       dc.w    $0001,$0001
L00005234                       dc.w    $0001,$0004
L00005238                       dc.w    $0001,$0008
L0000523c                       dc.w    $0001,$000a
L00005240                       dc.w    $0001,$0014
L00005244                       dc.w    $0001,$001e
L00005248                       dc.w    $0000,$0032
L0000524c                       dc.w    $0000,$2a79
L00005250                       dc.w    $0000,$37c4


L00005254                       lea.l   L00009bce,a4
L0000525a                       move.w  $0040(a6),d0
L0000525e                       move.w  $004a(a6),d1
L00005262                       move.w  $0042(a6),d2
L00005266                       move.w  $004c(a6),d3
L0000526a                       sub.w   d0,d1
L0000526c                       move.w  d2,d4
L0000526e                       sub.w   d3,d2
L00005270                       bcc.b   L0000527a
L00005272                       add.w   d1,d0
L00005274                       neg.w   d1
L00005276                       move.w  d3,d4
L00005278                       neg.w   d2
L0000527a                       move.w  d4,d3
L0000527c                       lsl.w   #$02,d3
L0000527e                       add.w   d4,d3
L00005280                       lsl.w   #$03,d3
L00005282                       lea.l   $00(a5,d3.w),a5
L00005286                       move.w  d2,d7
L00005288                       beq.w   L00005302
L0000528c                       subq.w  #$01,d7
L0000528e                       bmi.b   L000052b6
L00005290                       moveq   #$01,d4
L00005292                       tst.w   d1
L00005294                       bpl.w   L0000529c
L00005298                       neg.w   d1
L0000529a                       neg.w   d4
L0000529c                       cmp.w   d1,d2
L0000529e                       bcs.b   L000052d0
L000052a0                       move.b  d2,d3
L000052a2                       lsr.b   #$01,d3
L000052a4                       add.b   d1,d3
L000052a6                       cmp.b   d2,d3
L000052a8                       bcs.b   L000052ae
L000052aa                       sub.b   d2,d3
L000052ac                       add.w   d4,d0
L000052ae                       lea.l   -$0028(a5),a5
L000052b2                       dbf.w   d7,L000052b8
L000052b6                       rts  


L000052b8                       add.b   d1,d3
L000052ba                       cmp.b   d2,d3
L000052bc                       bcs.b   L000052c2
L000052be                       sub.b   d2,d3
L000052c0                       add.w   d4,d0
L000052c2                       bsr.w   L0000531e
L000052c6                       lea.l   -$0028(a5),a5
L000052ca                       dbf.w   d7,L000052a4
L000052ce                       rts  

L000052d0                       moveq   #$00,d3
L000052d2                       bsr.w   L0000531e
L000052d6                       add.w   d4,d0
L000052d8                       add.b   d2,d3
L000052da                       bcs.b   L000052e0
L000052dc                       cmp.b   d1,d3
L000052de                       bcs.b   L000052ec
L000052e0                       sub.b   d1,d3
L000052e2                       lea.l   -$0028(a5),a5
L000052e6                       dbf.w   d7,L000052ec
L000052ea                       rts  


L000052ec                       add.w   d4,d0
L000052ee                       add.b   d2,d3
L000052f0                       bcs.b   L000052f6
L000052f2                       cmp.b   d1,d3
L000052f4                       bcs.b   L000052d2
L000052f6                       sub.b   d1,d3
L000052f8                       lea.l   -$0028(a5),a5
L000052fc                       dbf.w   d7,L000052d2 
L00005300                       rts 


L00005302                       moveq   #$02,d2
L00005304                       tst.w   d1
L00005306                       beq.b   L0000531c
L00005308                       bpl.b   L0000530e
L0000530a                       neg.w   d2
L0000530c                       neg.w   d1
L0000530e                       lsr.w   #$01,d1
L00005310                       subq.w  #$01,d1
L00005312                       bsr.w   L0000531e
L00005316                       add.w   d2,d0
L00005318                       dbf.w   d1,L00005312
L0000531c                       rts  


L0000531e                       move.w  d0,d6
L00005320                       lsl.w   #$02,d6
L00005322                       and.w   #$003c,d6
L00005326                       lea.l   $00(a4,d6.w),a2
L0000532a                       move.w  d0,d6
L0000532c                       lsr.w   #$03,d6
L0000532e                       bclr.l  #$0000,d6
L00005332                       lea.l   $00(a5,d6.w),a3
L00005336                       move.l  $0040(a2),d6
L0000533a                       not.l   d6
L0000533c                       cmp.w   #$0130,d0
L00005340                       bcc.b   L000053a0
L00005342                       and.l   d6,(a3)
L00005344                       move.l  (a2),d5
L00005346                       or.l    d5,(a3)
L00005348                       and.l   d6,$17c0(a3)
L0000534c                       move.l  $0040(a2),d5
L00005350                       or.l    d5,$17c0(a3)
L00005354                       and.l   d6,$2f80(a3)
L00005358                       move.l  $0080(a2),d5
L0000535c                       or.l    d5,$2f80(a3)
L00005360                       and.l   d6,$4740(a3)
L00005364                       move.l  $00c0(a2),d5
L00005368                       or.l    d5,$4740(a3)
L0000536c                       lea.l   $0028(a3),a3
L00005370                       lea.l   $0100(a2),a2
L00005374                       and.l   d6,(a3)
L00005376                       move.l  (a2),d5
L00005378                       or.l    d5,(a3)
L0000537a                       and.l   d6,$17c0(a3)
L0000537e                       move.l  $0040(a2),d5
L00005382                       or.l    d5,$17c0(a3)
L00005386                       and.l   d6,$2f80(a3)
L0000538a                       move.l  $0080(a2),d5
L0000538e                       or.l    d5,$2f80(a3)
L00005392                       and.l   d6,$4740(a3)
L00005396                       move.l  $00c0(a2),d5
L0000539a                       or.l    d5,$4740(a3)
L0000539e                       rts 


L000053a0                       cmp.w   #$0140,d0
L000053a4                       bcc.b   L0000539e
L000053a6                       swap.w  d6
L000053a8                       and.w   d6,(a3)
L000053aa                       move.w  (a2),d5
L000053ac                       or.w    d5,(a3)
L000053ae                       and.w   d6,$17c0(a3)
L000053b2                       move.w  $0040(a2),d5
L000053b6                       or.w    d5,$17c0(a3)
L000053ba                       and.w   d6,$2f80(a3)
L000053be                       move.w  $0080(a2),d5
L000053c2                       or.w    d5,$2f80(a3)
L000053c6                       and.w   d6,$4740(a3)
L000053ca                       move.w  $00c0(a2),d5
L000053ce                       or.w    d5,$4740(a3)
L000053d2                       lea.l   $0028(a3),a3
L000053d6                       lea.l   $0100(a2),a2
L000053da                       and.w   d6,(a3)
L000053dc                       move.w  (a2),d5
L000053de                       or.w    d5,(a3)
L000053e0                       and.w   d6,$17c0(a3)
L000053e4                       move.w  $0040(a2),d5
L000053e8                       or.w    d5,$17c0(a3)
L000053ec                       and.w   d6,$2f80(a3)
L000053f0                       move.w  $0080(a2),d5
L000053f4                       or.w    d5,$2f80(a3)
L000053f8                       and.w   d6,$4740(a3)
L000053fc                       move.w  $00c0(a2),d5
L00005400                       or.w    d5,$4740(a3)
L00005404                       rts  


L00005406                       lea.l   L00008d5c,a6
L0000540c                       move.w  $003c(a6),d0
L00005410                       bne.b   L00005414 
L00005412                       rts  


L00005414                       cmp.w   #$0003,d0
L00005418                       beq.b   L00005412
L0000541a                       lea.l   L0000974e,a5
L00005420                       move.w  $0054(a6),d0
L00005424                       add.w   $004e(a6),d0
L00005428                       lsl.w   #$04,d0
L0000542a                       lea.l   $02(a5,d0.w),a5
L0000542e                       moveq   #$00,d3
L00005430                       move.w  (a5)+,d4
L00005432                       move.w  (a5)+,d5
L00005434                       move.w  (a5)+,d7
L00005436                       move.w  $004a(a6),d0
L0000543a                       move.w  $004c(a6),d2
L0000543e                       cmp.w   #$0140,d0
L00005442                       bcc.b   L00005412
L00005444                       addq.w  #$06,d2
L00005446                       subq.w  #$06,d0
L00005448                       bra.w   L00004e5e


L0000544c                       move.w  $003c(a6),d0
L00005450                       bne.b   L000054ba
L00005452                       tst.b   L00003708
L00005458                       bne.b   L0000545c
L0000545a                       rts  


L0000545c                       cmp.w   #$0050,L00008f6e
L00005464                       bcs.b   L0000545a
L00005466                       moveq   #$0a,d0
L00005468                       bsr.w   L00003c92
L0000546c                       move.w  #$0001,$003c(a6)
L00005472                       move.w  #$000e,$0044(a6)
L00005478                       move.w  #$007f,$004c(a6)
L0000547e                       move.w  #$007f,$0042(a6)
L00005484                       move.l  #$00005216,$0046(a6)
L0000548c                       move.w  #$007e,d0
L00005490                       moveq   #$00,d1
L00005492                       btst.l  #$0002,d5
L00005496                       bne.b   L000054ae
L00005498                       btst.l  #$0003,d5
L0000549c                       bne.b   L000054a8
L0000549e                       cmp.w   #$016d,L00009074
L000054a6                       bcc.b   L000054ae
L000054a8                       move.w  #$00c0,d0
L000054ac                       moveq   #$02,d1
L000054ae                       move.w  d0,$004a(a6)
L000054b2                       move.w  d0,$0040(a6)
L000054b6                       move.w  d1,$004e(a6)
L000054ba                       cmp.w   #$0002,d0
L000054be                       beq.w   L00005608
L000054c2                       cmp.w   #$0003,d0
L000054c6                       beq.w   L000056c0
L000054ca                       subq.w  #$01,$0044(a6)
L000054ce                       bpl.b   L000054da
L000054d0                       move.w  #$0000,$003c(a6)
L000054d6                       bra.w   L00005572

L000054da                       movea.l $0046(a6),a0
L000054de                       move.w  (a0)+,d0
L000054e0                       tst.w   $004e(a6)
L000054e4                       beq.b   L000054e8
L000054e6                       neg.w   d0
L000054e8                       add.w   d0,$004a(a6)
L000054ec                       move.w  (a0)+,$0054(a6)
L000054f0                       move.l  a0,$0046(a6)
L000054f4                       lea.l   L00008f74,a0
L000054fa                       move.w  L00009076,d0
L00005500                       moveq   #$00,d6
L00005502                       add.b   #$40,d0
L00005506                       move.w  L00007ff2,d1
L0000550c                       add.w   #$0024,d1
L00005510                       tst.w   $004e(a6)
L00005514                       bne.b   L00005524
L00005516                       add.b   #$20,d0
L0000551a                       move.w  L00007bf2,d1
L00005520                       sub.w   #$0024,d1
L00005524                       cmp.b   #$01,$00(a0,d0.w)
L0000552a                       beq.b   L00005552
L0000552c                       tst.b   L00008f6e
L00005532                       beq.b   L00005572
L00005534                       move.b  L00008f6f,d2
L0000553a                       bmi.b   L00005544
L0000553c                       cmp.b   L00009079,d2
L00005542                       bcc.b   L00005572
L00005544                       add.b   #$01,d0
L00005548                       cmp.b   #$01,$00(a0,d0.w)
L0000554e                       bne.b   L00005572
L00005550                       moveq   #$01,d6
L00005552                       tst.w   d1
L00005554                       bmi.w   L00005572
L00005558                       move.w  d1,d2
L0000555a                       sub.w   $0040(a6),d2
L0000555e                       tst.w   $004e(a6)
L00005562                       bne.b   L00005574
L00005564                       cmp.w   #$0065,d1
L00005568                       bcc.b   L00005572
L0000556a                       neg.w   d2
L0000556c                       cmp.w   $004a(a6),d1
L00005570                       bcc.b   L00005580
L00005572                       rts  


L00005574                       cmp.w   #$00d9,d1
L00005578                       bcs.b   L00005572 
L0000557a                       cmp.w   $004a(a6),d1
L0000557e                       bcc.b   L00005572
L00005580                       move.w  d1,$004a(a6)
L00005584                       move.w  #$0002,$003c(a6)
L0000558a                       move.w  d2,$0050(a6)
L0000558e                       moveq   #$00,d5
L00005590                       move.w  d5,d0
L00005592                       tst.w   d6
L00005594                       beq.b   L0000559a
L00005596                       move.w  #$00fb,d0
L0000559a                       move.w  L00008f6e,d1
L000055a0                       move.w  d1,L00008f70
L000055a6                       move.w  d0,L00008f6e
L000055ac                       move.w  d5,$0004(a6)
L000055b0                       move.w  d5,$0002(a6)
L000055b4                       move.w  d5,L00003708
L000055ba                       divu.w  #$00a4,d1
L000055be                       mulu.w  #$0019,d1
L000055c2                       add.w   #$0019,d1
L000055c6                       move.w  #$004e,$0044(a6)
L000055cc                       move.w  d1,$0056(a6)
L000055d0                       move.w  d1,$0052(a6)
L000055d4                       move.w  #$00c0,L00009078
L000055dc                       move.w  #$0001,$0054(a6)
L000055e2                       moveq   #$00,d6
L000055e4                       tst.w   $004e(a6)
L000055e8                       beq.b   L000055ec
L000055ea                       moveq.l #$ffffffff,d6
L000055ec                       move.w  d6,$0038(a6)
L000055f0                       move.w  L00008f70,d0
L000055f6                       ext.l   d0
L000055f8                       divu.w  #$0009,d0
L000055fc                       addq.w  #$03,d0
L000055fe                       move.w  d0,$0036(a6)
L00005602                       moveq   #$0b,d0
L00005604                       bra.w   L00003c92

L00005608                       move.w  $0052(a6),d0
L0000560c                       move.w  $0044(a6),d7
L00005610                       move.w  d0,d1
L00005612                       mulu.w  #$013a,d1
L00005616                       divu.w  #$03e8,d1
L0000561a                       mulu.w  d1,d1
L0000561c                       divu.w  #$0005,d1
L00005620                       and.l   #$0000ffff,d1
L00005626                       divu.w  #$0064,d1
L0000562a                       move.w  d1,$0046(a6)
L0000562e                       cmp.w   $0050(a6),d1
L00005632                       bcc.b   L0000569c 
L00005634                       tst.w   $004e(a6)
L00005638                       beq.b   L0000564a
L0000563a                       add.w   #$00c0,d1
L0000563e                       move.w  L00007ff2,d4
L00005644                       add.w   #$0024,d4
L00005648                       bra.b   L0000565a 
L0000564a                       neg.w   d1
L0000564c                       add.w   #$007e,d1
L00005650                       move.w  L00007bf2,d4
L00005656                       sub.w   #$0024,d4
L0000565a                       move.w  d1,$0040(a6)
L0000565e                       move.w  d4,$004a(a6)
L00005662                       move.w  d0,d2
L00005664                       mulu.w  d7,d2
L00005666                       divu.w  #$000e,d2
L0000566a                       and.l   #$0000ffff,d2
L00005670                       divu.w  #$0064,d2
L00005674                       neg.w   d2
L00005676                       add.w   #$007f,d2
L0000567a                       move.w  d2,$0042(a6)
L0000567e                       add.w   $0056(a6),d0
L00005682                       move.w  d0,$0052(a6)
L00005686                       subq.w  #$01,d7
L00005688                       move.w  d7,$0044(a6)
L0000568c                       moveq   #$00,d5
L0000568e                       move.w  d5,L00008f6e
L00005694                       move.w  d5,L00003708
L0000569a                       rts  


L0000569c                       move.w  #$0003,$003c(a6)
L000056a2                       tst.w   $004e(a6)
L000056a6                       beq.b   L000056ae
L000056a8                       add.w   #$00c0,d1
L000056ac                       bra.b   L000056b4
L000056ae                       neg.w   d1
L000056b0                       add.w   #$007e,d1
L000056b4                       sub.w   $0040(a6),d1
L000056b8                       bpl.b   L000056bc
L000056ba                       neg.w   d1
L000056bc                       move.w  d1,$0044(a6)
L000056c0                       move.w  $0044(a6),d0
L000056c4                       addq.w  #$01,d0
L000056c6                       move.w  d0,$0044(a6)
L000056ca                       move.w  $0040(a6),d1
L000056ce                       tst.w   $004e(a6)
L000056d2                       beq.b   L000056de
L000056d4                       add.w   d0,d1
L000056d6                       cmp.w   #$01a4,d1
L000056da                       bcc.b   L000056ee
L000056dc                       bra.b   L000056e8
L000056de                       sub.w   d0,d1
L000056e0                       bpl.b   L000056e8
L000056e2                       cmp.w   #$ff9c,d1
L000056e6                       bcs.b   L000056ee
L000056e8                       move.w  d1,$0040(a6)
L000056ec                       bra.b   L0000568c

L000056ee                       move.w  #$0000,$003c(a6)
L000056f4                       bsr.w   L00006a2c
L000056f8                       move.w  L00008f70,L00008f6e
L00005702                       lea.l   $0008(a7),a7
L00005706                       movea.l L000037c4,a0
L0000570c                       moveq   #$00,d0
L0000570e                       move.w  #$17bf,d7
L00005712                       move.l  d0,(a0)+
L00005714                       dbf.w   d7,L00005712
L00005718                       bsr.w   L00003ce2
L0000571c                       move.w  #$0001,L00008d2a
L00005724                       bra.w   L000039ce 


L00005728                       dc.w    $0005,$fff4
L0000572c                       dc.w    $0005,$fff8
L00005730                       dc.w    $0005,$fffc
L00005734                       dc.w    $0000,$fffe
L00005738                       dc.w    $0000,$ffff
L0000573c                       dc.w    $0000,$0001
L00005740                       dc.w    $0000,$0002
L00005744                       dc.w    $000a    
L00005746                       dc.w    $0004,$000a 
L0000574a                       dc.w    $0008  
L0000574c                       dc.w    $000a  
L0000574e                       dc.w    $000c  
L00005750                       dc.w    $0010,$0002  
L00005754                       dc.w    $000c      
L00005756                       dc.w    $0004,$0008   
L0000575a                       dc.w    $0006,$0004 
L0000575e                       dc.w    $0008      
L00005760                       dc.w    $0000,$000a 


L00005764                       lea.l   L00008d5c,a6
L0000576a                       tst.w   $003a(a6)
L0000576e                       beq.b   L00005774
L00005770                       subq.w  #$01,$003a(a6)
L00005774                       tst.w   $0032(a6)
L00005778                       beq.b   L0000577e
L0000577a                       subq.w  #$01,$0032(a6)
L0000577e                       move.w  $0022(a6),d0
L00005782                       addq.w  #$01,d0
L00005784                       and.w   #$0003,d0
L00005788                       move.w  d0,$0022(a6)
L0000578c                       btst.l  #$0000,d0
L00005790                       beq.b   L0000579c
L00005792                       addq.w  #$01,$0024(a6) 
L00005796                       and.w   #$0003,$0024(a6)
L0000579c                       move.w  L00003708,d5
L000057a2                       tst.w   L00008f66
L000057a8                       beq.w   L000057ae 
L000057ac                       moveq   #$00,d5
L000057ae                       tst.w   L00008d1e
L000057b4                       bne.w   L00005a28
L000057b8                       bsr.w   L0000544c
L000057bc                       move.w  $0018(a6),d0
L000057c0                       beq.b   L00005802
L000057c2                       subq.w  #$01,d0
L000057c4                       move.w  d0,$0018(a6)
L000057c8                       bne.b   L000057d0
L000057ca                       moveq   #$08,d0
L000057cc                       bsr.w   L00003c92
L000057d0                       movea.l $001c(a6),a0
L000057d4                       move.w  #$0000,L00003708
L000057dc                       move.w  (a0)+,$0016(a6)
L000057e0                       move.w  $0010(a6),d0
L000057e4                       add.w   (a0)+,d0
L000057e6                       move.w  d0,$0010(a6)
L000057ea                       add.w   #$007f,d0
L000057ee                       sub.w   #$0091,d0
L000057f2                       move.w  d0,$004c(a6)
L000057f6                       move.w  d0,$0042(a6)
L000057fa                       move.l  a0,$001c(a6)
L000057fe                       bra.w   L00005894
L00005802                       tst.w   $0036(a6)
L00005806                       beq.b   L0000581a
L00005808                       move.w  $0038(a6),d0
L0000580c                       add.w   #$0002,d0
L00005810                       move.w  d5,d1
L00005812                       and.w   #$0003,d1

L00005816                       cmp.w   d5,d1
L00005818                       beq.b   L00005894
L0000581a                       move.w  d5,d0
L0000581c                       move.w  L00008f6e,d2
L00005822                       move.w  d2,d3
L00005824                       move.w  #$fffb,d1
L00005828                       and.w   #$0003,d0
L0000582c                       beq.b   L0000587e
L0000582e                       move.w  #$ffe7,d1
L00005832                       btst.l  #$0000,d0
L00005836                       beq.b   L0000587e
L00005838                       move.w  #$01c3,d1
L0000583c                       move.w  L00008f62,d0
L00005842                       beq.b   L00005852
L00005844                       move.w  #$0078,d1
L00005848                       cmp.w   #$0001,d0
L0000584c                       bcs.b   L00005852
L0000584e                       move.w  #$0078,d1
L00005852                       sub.w   d1,d2
L00005854                       bcc.b   L00005876
L00005856                       add.w   #$0118,d1
L0000585a                       bcs.b   L00005868
L0000585c                       add.w   #$0118,d1
L00005860                       lsr.w   #$06,d1
L00005862                       or.w    #$0001,d1
L00005866                       bra.b   L0000587e

L00005868                       sub.w   #$0118,d1
L0000586c                       neg.w   d1
L0000586e                       lsr.w   #$06,d1
L00005870                       or.w    #$0001,d1
L00005874                       bra.b   L0000587e

L00005876                       lsr.w   #$06,d1
L00005878                       or.w    #$0001,d1
L0000587c                       neg.w   d1
L0000587e                       add.w   d3,d1
L00005880                       bpl.b   L00005884
L00005882                       moveq   #$00,d1
L00005884                       cmp.w   #$01c2,d1
L00005888                       bcs.b   L0000588e
L0000588a                       move.w  #$01c2,d1
L0000588e                       move.w  d1,L00008f6e
L00005894                       move.w  $0002(a6),d0
L00005898                       move.w  $0004(a6),d1
L0000589c                       tst.w   $0018(a6)
L000058a0                       bne.b   L0000590c
L000058a2                       btst.l  #$0002,d5
L000058a6                       bne.b   L000058d0
L000058a8                       btst.l  #$0003,d5
L000058ac                       bne.b   L000058be
L000058ae                       subq.w  #$02,d0
L000058b0                       bcc.w   L000058b6
L000058b4                       moveq   #$00,d0
L000058b6                       subq.w  #$02,d1
L000058b8                       bcc.b   L000058e2 
L000058ba                       moveq   #$00,d1
L000058bc                       bra.b   L000058e2 

L000058be                       addq.w  #$03,d0
L000058c0                       cmp.w   #$0010,d0
L000058c4                       bcs.b   L000058c8
L000058c6                       moveq   #$10,d0
L000058c8                       sub.w   d0,d1
L000058ca                       bcc.b   L000058e2
L000058cc                       moveq   #$00,d1
L000058ce                       bra.b   L000058e2
L000058d0                       addq.w  #$03,d1
L000058d2                       cmp.w   #$0010,d1
L000058d6                       bcs.b   L000058da
L000058d8                       moveq   #$10,d1
L000058da                       sub.w   d1,d0
L000058dc                       bcc.b   L000058e2
L000058de                       move.w  #$0000,d0
L000058e2                       move.w  L00008f6e,d2
L000058e8                       lsr.w   #$04,d2
L000058ea                       move.w  d2,d3
L000058ec                       lsr.w   #$02,d2
L000058ee                       add.w   d3,d2
L000058f0                       cmp.w   d2,d0
L000058f2                       bcs.b   L000058f6
L000058f4                       move.w  d2,d0
L000058f6                       cmp.w   d2,d1
L000058f8                       bcs.b   L000058fc

L000058fa                       move.w  d2,d1
L000058fc                       move.w  d0,$0002(a6)
L00005900                       move.w  d1,$0004(a6)
L00005904                       move.w  $0036(a6),d2
L00005908                       beq.b   L0000590c
L0000590a                       exg.l   d0,d1
L0000590c                       bsr.w   L00005980
L00005910                       moveq   #$02,d0
L00005912                       moveq.l #$ffffffff,d2
L00005914                       tst.w   d1
L00005916                       bpl.b   L0000591c 
L00005918                       neg.w   d1
L0000591a                       neg.w   d2
L0000591c                       cmp.w   #$0008,d1
L00005920                       bcs.b   L0000592c
L00005922                       add.w   d2,d0
L00005924                       cmp.w   #$0010,d1
L00005928                       bcs.b   L0000592c

L0000592a                       add.w   d2,d0
L0000592c                       move.w  d0,$0012(a6)
L00005930                       move.w  $0036(a6),d0
L00005934                       beq.w   L0000597e
L00005938                       ext.l   d0
L0000593a                       move.w  d0,d1
L0000593c                       tst.w   $0018(a6)
L00005940                       bne.b   L0000594e
L00005942                       mulu.w  #$0004,d1
L00005946                       divu.w  #$0005,d1
L0000594a                       move.w  d1,$0036(a6)
L0000594e                       move.w  d0,d1
L00005950                       lsr.w   #$03,d1
L00005952                       cmp.w   #$0003,d1
L00005956                       bcs.b   L0000595c
L00005958                       move.w  #$0002,d1
L0000595c                       add.w   #$0002,d1
L00005960                       tst.w   $0038(a6)
L00005964                       bmi.b   L0000596e 
L00005966                       neg.w   d1
L00005968                       add.w   #$0004,d1
L0000596c                       neg.w   d0
L0000596e                       add.w   d0,L00009074 
L00005974                       move.w  d1,$0012(a6)
L00005978                       move.w  #$0002,$0032(a6)
L0000597e                       rts 


L00005980                       moveq   #$00,d5
L00005982                       move.w  $000e(a6),d2
L00005986                       beq.b   L000059c6 
L00005988                       bpl.b   L0000598c 

L0000598a                       neg.w   d2
L0000598c                       move.w  #$005e,d3
L00005990                       divu.w  d2,d3
L00005992                       move.w  d3,d2
L00005994                       move.w  $000a(a6),d3
L00005998                       move.w  L00009078,d4
L0000599e                       sub.w   d3,d4
L000059a0                       beq.b   L000059c6
L000059a2                       sub.w   d2,d4
L000059a4                       bcs.b   L000059ac
L000059a6                       addq.w  #$01,d5
L000059a8                       add.b   d2,d3
L000059aa                       bcs.b   L000059a2
L000059ac                       tst.w   d5
L000059ae                       beq.b   L000059c2
L000059b0                       add.w   d5,$000c(a6)
L000059b4                       move.w  d5,d4
L000059b6                       lsl.w   #$01,d5
L000059b8                       add.w   d4,d5
L000059ba                       tst.w   $000e(a6)
L000059be                       bpl.b   L000059c2
L000059c0                       neg.w   d5
L000059c2                       move.w  d3,$000a(a6)
L000059c6                       add.w   $0034(a6),d5
L000059ca                       move.w  #$0000,$0034(a6)
L000059d0                       sub.w   d0,d1
L000059d2                       add.w   d1,d5

L000059d4                       tst.w   d1
L000059d6                       beq.b   L000059fc 
L000059d8                       move.w  d1,d0
L000059da                       and.b   #$0f,d0
L000059de                       bne.b   L000059fc 
L000059e0                       tst.w   d5
L000059e2                       bpl.b   L000059ee
L000059e4                       tst.w   d1
L000059e6                       bmi.b   L000059fc
L000059e8                       tst.w   d5
L000059ea                       bpl.b   L000059fc
L000059ec                       bra.b   L000059f6
L000059ee                       tst.w   d1
L000059f0                       bpl.b   L000059fc
L000059f2                       tst.w   d5
L000059f4                       bmi.b   L000059fc
L000059f6                       move.w  #$0002,$0032(a6)
L000059fc                       add.w   L00009074,d5
L00005a02                       move.w  #$0034,d2
L00005a06                       cmp.w   d2,d5
L00005a08                       bcc.b   L00005a0c
L00005a0a                       move.w  d2,d5
L00005a0c                       move.w  #$029f,d2
L00005a10                       cmp.w   d2,d5
L00005a12                       bcs.b   L00005a16 
L00005a14                       move.w  d2,d5
L00005a16                       move.w  d5,L00009074
L00005a1c                       addq.w  #$01,$0026(a6)
L00005a20                       and.w   #$0003,$0026(a6)
L00005a26                       rts     


L00005a28                       tst.w   L00008d38
L00005a2e                       beq.b   L00005a32
L00005a30                       rts  


L00005a32                       move.w  L00008f6e,d2
L00005a38                       move.w  d2,d3
L00005a3a                       moveq   #$00,d1
L00005a3c                       tst.b   L00003708 
L00005a42                       beq.b   L00005a86 
L00005a44                       move.w  d5,d0
L00005a46                       and.w   #$0003,d0
L00005a4a                       beq.b   L00005a86 
L00005a4c                       move.w  #$ffec,d1
L00005a50                       btst.l  #$0000,d0
L00005a54                       beq.b   L00005a86

L00005a56                       move.w  #$0200,d1
L00005a5a                       sub.w   d1,d2
L00005a5c                       bcc.b   L00005a7e
L00005a5e                       add.w   #$012c,d1
L00005a62                       bcs.b   L00005a70 
L00005a64                       add.w   #$012c,d1
L00005a68                       lsr.w   #$06,d1
L00005a6a                       or.w    #$0001,d1
L00005a6e                       bra.b   L00005a86
L00005a70                       sub.w   #$012c,d1
L00005a74                       neg.w   d1
L00005a76                       lsr.w   #$06,d1
L00005a78                       or.w    #$0001,d1
L00005a7c                       bra.b   L00005a86
L00005a7e                       lsr.w   #$06,d1
L00005a80                       or.w    #$0001,d1
L00005a84                       neg.w   d1
L00005a86                       add.w   d3,d1
L00005a88                       bpl.b   L00005a8c
L00005a8a                       moveq   #$78,d1
L00005a8c                       cmp.w   #$01ff,d1
L00005a90                       bcs.b   L00005a96
L00005a92                       move.w  #$01ff,d1
L00005a96                       cmp.w   #$0078,d1
L00005a9a                       bcc.b   L00005a9e
L00005a9c                       moveq   #$78,d1
L00005a9e                       move.w  d1,L00008f6e

L00005aa4                       lea.l   L00008f74,a0
L00005aaa                       move.w  L00009076,d0
L00005ab0                       add.b   #$20,d0
L00005ab4                       moveq   #$00,d1
L00005ab6                       moveq   #$04,d2
L00005ab8                       move.b  $00(a0,d0.w),d3
L00005abc                       bmi.b   L00005ac0
L00005abe                       asr.b   #$01,d3
L00005ac0                       add.b   d3,d1
L00005ac2                       addq.b  #$01,d0
L00005ac4                       dbf.w   d2,L00005ab8
L00005ac8                       add.b   #$87,d1
L00005acc                       move.w  d1,$0020(a6)
L00005ad0                       move.w  $0006(a6),d0
L00005ad4                       move.w  $0008(a6),d1
L00005ad8                       tst.b   L00003708 
L00005ade                       bne.b   L00005aec 
L00005ae0                       btst.l  #$0000,d5
L00005ae4                       bne.b   L00005afa 
L00005ae6                       btst.l  #$0001,d5
L00005aea                       bne.b   L00005b0e
L00005aec                       subq.w  #$01,d0
L00005aee                       bcc.b   L00005af2
L00005af0                       moveq   #$00,d0
L00005af2                       subq.w  #$01,d1
L00005af4                       bcc.b   L00005b22
L00005af6                       moveq   #$00,d1
L00005af8                       bra.b   L00005b22

L00005afa                       move.w  d0,d2
L00005afc                       addq.w  #$01,d2
L00005afe                       cmp.w   #$0005,d2
L00005b02                       bcc.b   L00005b06
L00005b04                       move.w  d2,d0
L00005b06                       sub.w   d0,d1
L00005b08                       bcc.b   L00005b22
L00005b0a                       moveq   #$00,d1
L00005b0c                       bra.b   L00005b22
L00005b0e                       move.w  d1,d2
L00005b10                       addq.w  #$01,d2
L00005b12                       cmp.w   #$0005,d2
L00005b16                       bcc.b   L00005b1a
L00005b18                       move.w  d2,d1
L00005b1a                       sub.w   d1,d0
L00005b1c                       bcc.b   L00005b22
L00005b1e                       move.w  #$0000,d0
L00005b22                       move.w  L00008f6e,d2
L00005b28                       lsr.w   #$04,d2
L00005b2a                       move.w  d2,d3
L00005b2c                       lsr.w   #$02,d2
L00005b2e                       add.w   d3,d2
L00005b30                       bra.b   L00005b3e

L00005b32                       cmp.w   d2,d0
L00005b34                       bcs.b   L00005b38
L00005b36                       move.w  d2,d0
L00005b38                       cmp.w   d2,d1
L00005b3a                       bcs.b   L00005b3e
L00005b3c                       move.w  d2,d1
L00005b3e                       move.w  d0,$0006(a6)
L00005b42                       move.w  d1,$0008(a6)
L00005b46                       sub.w   d1,d0
L00005b48                       move.w  d0,d1
L00005b4a                       add.w   $0010(a6),d0
L00005b4e                       cmp.w   #$0026,d0
L00005b52                       bcc.b   L00005b58
L00005b54                       move.w  #$0026,d0
L00005b58                       move.w  $0020(a6),d2
L00005b5c                       cmp.w   d2,d0
L00005b5e                       bcs.b   L00005b90
L00005b60                       tst.w   $0028(a6)
L00005b64                       bne.b   L00005b6c

L00005b66                       move.w  #$0001,$0028(a6)
L00005b6c                       move.w  d2,d0
L00005b6e                       sub.w   #$0087,d2
L00005b72                       neg.w   d2
L00005b74                       bpl.b   L00005b78
L00005b76                       moveq   #$00,d2
L00005b78                       lsr.w   #$01,d2
L00005b7a                       add.w   $0006(a6),d2
L00005b7e                       cmp.w   #$0009,d2
L00005b82                       bcs.b   L00005b86
L00005b84                       moveq   #$09,d2
L00005b86                       move.w  #$0000,$0006(a6)
L00005b8c                       move.w  d2,$0008(a6)
L00005b90                       move.w  d0,$0010(a6)
L00005b94                       moveq   #$00,d0
L00005b96                       tst.w   d1
L00005b98                       beq.b   L00005bac
L00005b9a                       moveq   #$0a,d2
L00005b9c                       tst.w   d1
L00005b9e                       bpl.b   L00005ba4
L00005ba0                       moveq   #$05,d2
L00005ba2                       neg.w   d1
L00005ba4                       cmp.w   #$0002,d1
L00005ba8                       bcs.b   L00005bac

L00005baa                       move.w  d2,d0
L00005bac                       move.w  d0,$001e(a6)
L00005bb0                       move.w  $0002(a6),d0
L00005bb4                       move.w  $0004(a6),d1
L00005bb8                       btst.l  #$0002,d5
L00005bbc                       bne.b   L00005be4
L00005bbe                       btst.l  #$0003,d5
L00005bc2                       bne.b   L00005bd2
L00005bc4                       subq.w  #$03,d0
L00005bc6                       bcc.b   L00005bca
L00005bc8                       moveq   #$00,d0
L00005bca                       subq.w  #$03,d1
L00005bcc                       bcc.b   L00005bf6
L00005bce                       moveq   #$00,d1
L00005bd0                       bra.b   L00005bf6 
L00005bd2                       addq.w  #$04,d0
L00005bd4                       cmp.w   #$0012,d0
L00005bd8                       bcs.b   L00005bdc
L00005bda                       moveq   #$12,d0
L00005bdc                       sub.w   d0,d1
L00005bde                       bcc.b   L00005bf6
L00005be0                       moveq   #$00,d1
L00005be2                       bra.b   L00005bf6

L00005be4                       addq.w  #$04,d1
L00005be6                       cmp.w   #$0012,d1
L00005bea                       bcs.b   L00005bee
L00005bec                       moveq   #$12,d1
L00005bee                       sub.w   d1,d0
L00005bf0                       bcc.b   L00005bf6
L00005bf2                       move.w  #$0000,d0
L00005bf6                       move.w  L00008f6e,d2
L00005bfc                       lsr.w   #$04,d2
L00005bfe                       move.w  d2,d3
L00005c00                       lsr.w   #$02,d2
L00005c02                       add.w   d3,d2
L00005c04                       bra.b   L00005c12

L00005c06                       cmp.w   d2,d0
L00005c08                       bcs.b   L00005c0c
L00005c0a                       move.w  d2,d0
L00005c0c                       cmp.w   d2,d1
L00005c0e                       bcs.b   L00005c12
L00005c10                       move.w  d2,d1
L00005c12                       move.w  d0,$0002(a6)
L00005c16                       move.w  d1,$0004(a6)
L00005c1a                       bsr.w   L00005980
L00005c1e                       moveq   #$00,d0
L00005c20                       tst.w   d1
L00005c22                       beq.b   L00005c40
L00005c24                       moveq   #$03,d2
L00005c26                       tst.w   d1
L00005c28                       bpl.b   L00005c2e
L00005c2a                       moveq   #$01,d2
L00005c2c                       neg.w   d1
L00005c2e                       cmp.w   #$0006,d1
L00005c32                       bcs.b   L00005c40
L00005c34                       move.w  d2,d0
L00005c36                       cmp.w   #$000c,d1
L00005c3a                       bcs.b   L00005c40

L00005c3c                       add.w   #$0001,d0
L00005c40                       move.w  d0,$0012(a6)
L00005c44                       move.w  $0036(a6),d0
L00005c48                       beq.w   L00005c86
L00005c4c                       ext.l   d0
L00005c4e                       move.w  d0,d1
L00005c50                       mulu.w  #$0004,d1
L00005c54                       divu.w  #$0005,d1
L00005c58                       move.w  d1,$0036(a6)
L00005c5c                       move.w  d0,d1
L00005c5e                       lsr.w   #$03,d1
L00005c60                       cmp.w   #$0003,d1
L00005c64                       bcs.b   L00005c6a
L00005c66                       move.w  #$0002,d1
L00005c6a                       add.w   #$0002,d1
L00005c6e                       tst.w   $0038(a6)
L00005c72                       bmi.b   L00005c7c
L00005c74                       neg.w   d1
L00005c76                       add.w   #$0004,d1
L00005c7a                       neg.w   d0
L00005c7c                       add.w   d0,L00009074
L00005c82                       move.w  d1,$0012(a6)
L00005c86                       rts  


L00005c88                       tst.w   d7
L00005c8a                       bne.w   L00004d18
L00005c8e                       movem.l d6/d7/a0-a3,-(a7)
L00005c92                       bsr.b   L00005c9c
L00005c94                       movem.l (a7)+,d6/d7/a0-a3
L00005c98                       bra.w   L00004d18

L00005c9c                       lea.l   L00008d5c,a6
L00005ca2                       move.w  $003c(a6),d0
L00005ca6                       cmp.w   #$0002,d0
L00005caa                       bcc.w   L00005e86
L00005cae                       tst.w   d7
L00005cb0                       bpl.w   L00005f58
L00005cb4                       tst.w   d0
L00005cb6                       beq.b   L00005cde
L00005cb8                       move.w  $0012(a6),d0
L00005cbc                       sub.w   #$0002,d0
L00005cc0                       beq.b   L00005cd0
L00005cc2                       ext.l   d0
L00005cc4                       swap.w  d0
L00005cc6                       move.w  $004e(a6),d1
L00005cca                       lsr.w   #$01,d1
L00005ccc                       add.w   d0,d1
L00005cce                       bne.b   L00005cde
L00005cd0                       bsr.w   L0000524e
L00005cd4                       bsr.w   L00005406

L00005cd8                       lea.l   L00008d5c,a6
L00005cde                       move.w  $0012(a6),d1
L00005ce2                       add.w   $0016(a6),d1
L00005ce6                       move.w  d1,d3
L00005ce8                       lsl.w   #$02,d3
L00005cea                       lea.l   L000063d6,a4
L00005cf0                       move.w  #$0074,d0
L00005cf4                       add.w   $00(a4,d3.w),d0
L00005cf8                       move.w  #$0091,d2
L00005cfc                       add.w   $02(a4,d3.w),d2
L00005d00                       lea.l   $0003622e,a5                            ; external address
L00005d06                       movem.l d1-d3/a6,-(a7)
L00005d0a                       bsr.w   L000062a4
L00005d0e                       movem.l (a7)+,d1-d3/a6
L00005d12                       lea.l   L0000639a,a4
L00005d18                       move.w  #$0077,d0
L00005d1c                       add.w   $00(a4,d3.w),d0
L00005d20                       move.w  $0010(a6),d2
L00005d24                       add.w   $02(a4,d3.w),d2

L00005d28                       lea.l   $0002a41a,a5                    ; external address
L00005d2e                       bsr.w   L000062ce
L00005d32                       lea.l   L00008d5c,a6
L00005d38                       move.w  $0026(a6),d0
L00005d3c                       beq.b   L00005d68 
L00005d3e                       subq.w  #$01,d0
L00005d40                       and.w   #$0001,d0
L00005d44                       move.w  d0,d1
L00005d46                       move.w  $0012(a6),d2
L00005d4a                       lsl.w   #$01,d2
L00005d4c                       add.w   d2,d0
L00005d4e                       add.w   #$001d,d0
L00005d52                       mulu.w  #$000f,d1
L00005d56                       add.w   #$0069,d1
L00005d5a                       add.w   $0016(a6),d1

L00005d5e                       lea.l   $0002a41a,a5                    ; external address
L00005d64                       bsr.w   L00006206
L00005d68                       lea.l   L00008d5c,a6
L00005d6e                       tst.w   $0018(a6)
L00005d72                       bne.b   L00005dd8 
L00005d74                       tst.w   L00008f6e 
L00005d7a                       beq.b   L00005dd8 
L00005d7c                       move.w  L00008f62,d0
L00005d82                       beq.b   L00005d9a 
L00005d84                       cmp.w   #$0002,d0
L00005d88                       beq.b   L00005da0
L00005d8a                       moveq   #$01,d2
L00005d8c                       cmp.w   #$016d,L00009074
L00005d94                       bcc.b   L00005da2
L00005d96                       moveq   #$02,d2
L00005d98                       bra.b   L00005da2
L00005d9a                       tst.w   $0032(a6)
L00005d9e                       beq.b   L00005dd8
L00005da0                       moveq   #$03,d2
L00005da2                       move.w  $0024(a6),d0
L00005da6                       move.w  $0016(a6),d1

L00005daa                       lea.l   $0002a41a,a5                    ; external address
L00005db0                       lsr.w   #$01,d2
L00005db2                       bcc.b   L00005dc8
L00005db4                       movem.l d0-d2/a5-a6,-(a7)
L00005db8                       add.w   #$0019,d0
L00005dbc                       add.w   #$004b,d1
L00005dc0                       bsr.w   L00006206
L00005dc4                       movem.l (a7)+,d0-d2/a5-a6
L00005dc8                       lsr.w   #$01,d2
L00005dca                       bcc.b   L00005dd8
L00005dcc                       add.w   #$0015,d0
L00005dd0                       add.w   #$005a,d1
L00005dd4                       bsr.w   L00006206
L00005dd8                       move.w  L00008d28,d7
L00005dde                       beq.b   L00005e54
L00005de0                       lsr.w   #$02,d7
L00005de2                       neg.w   d7
L00005de4                       addq.w  #$04,d7
L00005de6                       cmp.w   #$0004,d7
L00005dea                       bcs.b   L00005dee
L00005dec                       moveq   #$03,d7

L00005dee                       lea.l   L00006718,a0
L00005df4                       movem.l d7/a0,-(a7)
L00005df8                       lea.l   L00008d5c,a6
L00005dfe                       move.w  (a0),d0
L00005e00                       addq.w  #$01,d0
L00005e02                       cmp.w   #$000c,d0
L00005e06                       bne.b   L00005e14
L00005e08                       bsr.w   L0000421a
L00005e0c                       and.w   #$000f,d0
L00005e10                       add.w   #$000c,d0
L00005e14                       cmp.w   #$0014,d0
L00005e18                       bcs.b   L00005e1c
L00005e1a                       moveq   #$00,d0
L00005e1c                       move.w  d0,(a0)+ 
L00005e1e                       lsr.w   #$01,d0
L00005e20                       cmp.w   #$0006,d0
L00005e24                       bcc.b   L00005e48
L00005e26                       move.w  d0,d1
L00005e28                       lsl.w   #$02,d1
L00005e2a                       move.w  $00(a0,d1.w),d2
L00005e2e                       move.w  $02(a0,d1.w),d3
L00005e32                       add.w   #$0027,d0
L00005e36                       move.w  #$0087,d1
L00005e3a                       add.w   $0016(a6),d1
L00005e3e                       lea.l   $0002a41a,a5                    ; external address
L00005e44                       bsr.w   L00006266
L00005e48                       movem.l (a7)+,d7/a0
L00005e4c                       lea.l   $001a(a0),a0
L00005e50                       dbf.w   d7,L00005df4

L00005e54                       lea.l   L00008d5c,a6
L00005e5a                       tst.w   $003c(a6)
L00005e5e                       beq.w   L00005f58
L00005e62                       move.w  $0012(a6),d0
L00005e66                       sub.w   #$0002,d0
L00005e6a                       beq.w   L00005f58
L00005e6e                       ext.l   d0
L00005e70                       swap.w  d0
L00005e72                       move.w  $004e(a6),d1
L00005e76                       lsr.w   #$01,d1
L00005e78                       add.w   d0,d1
L00005e7a                       beq.w   L00005f58
L00005e7e                       bsr.w   L0000524e
L00005e82                       bra.w   L00005406
L00005e86                       tst.w   d7
L00005e88                       bmi.w   L00005406
L00005e8c                       moveq   #$05,d0
L00005e8e                       cmp.w   #$0003,$003c(a6)
L00005e94                       beq.b   L00005eca
L00005e96                       move.w  $0050(a6),d1
L00005e9a                       move.w  d1,d2
L00005e9c                       sub.w   $0046(a6),d1

L00005ea0                       lsr.w   #$02,d2
L00005ea2                       move.w  d2,d3
L00005ea4                       cmp.w   d2,d1
L00005ea6                       bcs.b   L00005eca
L00005ea8                       moveq   #$04,d0
L00005eaa                       add.w   d3,d2
L00005eac                       cmp.w   d2,d1
L00005eae                       bcs.b   L00005eca
L00005eb0                       moveq   #$03,d0
L00005eb2                       add.w   d3,d2
L00005eb4                       cmp.w   d2,d1
L00005eb6                       bcs.b   L00005eca
L00005eb8                       moveq   #$02,d0
L00005eba                       add.w   d3,d2
L00005ebc                       cmp.w   d2,d1
L00005ebe                       bcs.b   L00005eca
L00005ec0                       moveq   #$01,d0
L00005ec2                       add.w   d3,d2
L00005ec4                       cmp.w   d2,d1
L00005ec6                       bcs.b   L00005eca
L00005ec8                       moveq   #$00,d0
L00005eca                       lea.l   L00006346,a4
L00005ed0                       tst.w   $004e(a6)
L00005ed4                       bne.b   L00005edc

L00005ed6                       lea.l   L000062f2,a4
L00005edc                       mulu.w  #$000e,d0
L00005ee0                       lea.l   $00(a4,d0.w),a4
L00005ee4                       cmp.w   #$0003,$003c(a6)
L00005eea                       beq.b   L00005efc
L00005eec                       tst.w   (a4)
L00005eee                       bne.b   L00005efc
L00005ef0                       movem.l a4/a6,-(a7)
L00005ef4                       bsr.w   L0000524e
L00005ef8                       movem.l (a7)+,a4/a6
L00005efc                       move.w  $0002(a4),d1
L00005f00                       bmi.b   L00005f24
L00005f02                       move.w  $0040(a6),d0
L00005f06                       move.w  $0042(a6),d2
L00005f0a                       add.w   $0004(a4),d0
L00005f0e                       add.w   $0006(a4),d2

L00005f12                       movem.l a4/a6,-(a7)
L00005f16                       lea.l   $0003622e,a5                    ; external address
L00005f1c                       bsr.w   L000062a4
L00005f20                       movem.l (a7)+,a4/a6
L00005f24                       move.w  $0008(a4),d1
L00005f28                       move.w  $0040(a6),d0
L00005f2c                       move.w  $0042(a6),d2
L00005f30                       add.w   $000a(a4),d0
L00005f34                       add.w   $000c(a4),d2
L00005f38                       movem.l a4/a6,-(a7)
L00005f3c                       lea.l   $0002a41a,a5                    ;external address
L00005f42                       bsr.w   L000062ce
L00005f46                       movem.l (a7)+,a4/a6
L00005f4a                       cmp.w   #$0003,$003c(a6)
L00005f50                       beq.b   L00005f58
L00005f52                       tst.w   (a4)
L00005f54                       bne.w   L0000524e
L00005f58                       rts  



L00005f5a                       lea.l   L00008d5c,a6
L00005f60                       move.w  $0020(a6),d1
L00005f64                       move.w  d1,d2
L00005f66                       sub.w   $0010(a6),d1
L00005f6a                       lsr.w   #$04,d1
L00005f6c                       cmp.w   #$0004,d1
L00005f70                       bcs.b   L00005f76
L00005f72                       move.w  #$0004,d1
L00005f76                       move.w  d1,d3
L00005f78                       lsl.w   #$02,d3

L00005f7a                       lea.l   L00006704,a1
L00005f80                       move.w  #$005a,d0
L00005f84                       add.w   $00(a1,d3.w),d0
L00005f88                       lea.l   $000358b0,a5                    ; external address
L00005f8e                       bra.w   L000062a4
L00005f92                       lea.l   L00008dfc,a6
L00005f98                       lea.l   $00035d4c,a5                    ; external address
L00005f9e                       moveq   #$02,d7
L00005fa0                       move.w  $0000(a6),d1
L00005fa4                       bne.b   L00005fb0
L00005fa6                       lea.l   $0006(a6),a6
L00005faa                       dbf.w   d7,L00005fa0
L00005fae                       bra.b   L00005ff2
L00005fb0                       cmp.w   #$0009,d1
L00005fb4                       bcs.b   L00005fbe
L00005fb6                       move.w  #$0000,$0000(a6)
L00005fbc                       bra.b   L00005fa6
L00005fbe                       addq.w  #$01,$0000(a6)
L00005fc2                       subq.w  #$01,d1
L00005fc4                       lsr.w   #$01,d1

L00005fc6                       lea.l   L000066f4,a0
L00005fcc                       move.w  d1,d3
L00005fce                       lsl.w   #$02,d3
L00005fd0                       add.w   #$0011,d1
L00005fd4                       move.w  $0002(a6),d0
L00005fd8                       add.w   $00(a0,d3.w),d0
L00005fdc                       move.w  $0004(a6),d2
L00005fe0                       add.w   $02(a0,d3.w),d2
L00005fe4                       movem.l d7/a5-a6,-(a7)
L00005fe8                       bsr.w   L000062ce
L00005fec                       movem.l (a7)+,d7/a5-a6
L00005ff0                       bra.b   L00005fa6
L00005ff2                       lea.l   L00008dc0,a6
L00005ff8                       lea.l   $00042592,a5                    ; external address
L00005ffe                       moveq   #$02,d7
L00006000                       tst.w   $0000(a6)
L00006004                       bne.b   L00006012
L00006006                       lea.l   $0014(a6),a6
L0000600a                       dbf.w   d7,L00006000
L0000600e                       bra.w   L000060c6


L00006012                       subq.w  #$01,$0000(a6)
L00006016                       move.w  $0002(a6),d1
L0000601a                       cmp.w   #$0003,d1
L0000601e                       bcc.b   L0000603a
L00006020                       addq.w  #$01,$0002(a6)
L00006024                       move.w  $0004(a6),d0
L00006028                       move.w  $0006(a6),d2
L0000602c                       movem.l d7/a5-a6,-(a7)
L00006030                       bsr.w   L000062ce
L00006034                       movem.l (a7)+,d7/a5-a6
L00006038                       bra.b   L00006006

L0000603a                       move.w  $0004(a6),d0
L0000603e                       move.w  $0006(a6),d2
L00006042                       moveq   #$05,d1
L00006044                       sub.w   #$0010,$0004(a6)
L0000604a                       add.w   #$0010,$0006(a6)
L00006050                       movem.l d7/a5-a6,-(a7)
L00006054                       bsr.w   L000062c6
L00006058                       movem.l (a7)+,d7/a5-a6
L0000605c                       move.w  $0008(a6),d0
L00006060                       move.w  $000a(a6),d2
L00006064                       moveq   #$06,d1
L00006066                       add.w   #$0010,$0008(a6)
L0000606c                       add.w   #$0010,$000a(a6)
L00006072                       movem.l d7/a5-a6,-(a7)
L00006076                       bsr.w   L000062c6
L0000607a                       movem.l (a7)+,d7/a5-a6
L0000607e                       move.w  $000c(a6),d0
L00006082                       move.w  $000e(a6),d2
L00006086                       moveq   #$03,d1
L00006088                       add.w   #$0010,$000c(a6)
L0000608e                       sub.w   #$0010,$000e(a6)
L00006094                       movem.l d7/a5-a6,-(a7)
L00006098                       bsr.w   L000062c6
L0000609c                       movem.l (a7)+,d7/a5-a6
L000060a0                       move.w  $0010(a6),d0
L000060a4                       move.w  $0012(a6),d2
L000060a8                       moveq   #$04,d1
L000060aa                       sub.w   #$0010,$0010(a6)
L000060b0                       sub.w   #$0010,$0012(a6)

L000060b6                       movem.l d7/a5-a6,-(a7)
L000060ba                       bsr.w   L000062c6
L000060be                       movem.l (a7)+,d7/a5-a6
L000060c2                       bra.w   L00006006

L000060c6                       lea.l   L00008d5c,a6
L000060cc                       cmp.w   #$000a,$001e(a6)
L000060d2                       bne.b   L000060d8
L000060d4                       bsr.w   L000061de
L000060d8                       lea.l   L00008d5c,a6
L000060de                       lea.l   L00006412,a5
L000060e4                       move.w  $0012(a6),d1
L000060e8                       add.w   $001e(a6),d1
L000060ec                       move.w  d1,d3
L000060ee                       lsl.w   #$01,d3
L000060f0                       move.w  $00(a5,d3.w),d2
L000060f4                       move.w  #$0062,d0
L000060f8                       add.w   $0010(a6),d2
L000060fc                       lea.l   $0002a41a,a5                    ; external address
L00006102                       bsr.w   L000062ce
L00006106                       lea.l   L00008d5c,a6
L0000610c                       move.w  $0026(a6),d0
L00006110                       beq.b   L00006132
L00006112                       move.w  #$0007,d2
L00006116                       move.w  $001e(a6),d1
L0000611a                       beq.b   L0000612a 
L0000611c                       move.w  #$000d,d2
L00006120                       cmp.w   #$0009,d1
L00006124                       bcc.b   L0000612a 
L00006126                       move.w  #$000a,d2
L0000612a                       add.w   d2,d0
L0000612c                       moveq   #$1e,d1
L0000612e                       bsr.w   L000061fc
L00006132                       lea.l   L00008d5c,a6
L00006138                       move.w  $0028(a6),d0
L0000613c                       beq.b   L0000616e 
L0000613e                       add.w   #$ffff,d0
L00006142                       moveq   #$00,d1
L00006144                       bsr.w   L000061fc

L00006148                       lea.l   L00008d5c,a6
L0000614e                       move.w  $0028(a6),d0
L00006152                       move.w  d0,d1
L00006154                       addq.w  #$01,d1
L00006156                       cmp.w   #$0005,d1
L0000615a                       bcs.w   L00006160
L0000615e                       moveq   #$00,d1
L00006160                       move.w  d1,$0028(a6)
L00006164                       add.w   #$ffff,d0
L00006168                       moveq   #$0f,d1
L0000616a                       bsr.w   L000061fc
L0000616e                       lea.l   L00008d5c,a6
L00006174                       cmp.w   #$000a,$001e(a6)
L0000617a                       beq.b   L0000617e
L0000617c                       bsr.b   L000061de
L0000617e                       tst.w   L00008d38
L00006184                       beq.b   L000061dc
L00006186                       subq.w  #$01,L00008d38
L0000618c                       bne.b   L00006196
L0000618e                       move.w  #$0002,L00008f66
L00006196                       lea.l   L00006688,a1
L0000619c                       moveq   #$05,d7
L0000619e                       movem.l d7/a1,-(a7)
L000061a2                       move.w  (a1),d0
L000061a4                       addq.w  #$01,d0
L000061a6                       cmp.w   #$000c,d0
L000061aa                       bcs.b   L000061b4
L000061ac                       moveq   #$0d,d0
L000061ae                       bsr.w   L00003c92
L000061b2                       moveq   #$00,d0
L000061b4                       move.w  d0,(a1)+ 
L000061b6                       cmp.w   #$0004,d0
L000061ba                       bcc.b   L000061d0
L000061bc                       move.w  d0,d1
L000061be                       add.w   #$0011,d0

L000061c2                       lea.l   $00035d4c,a5                    ; external address
L000061c8                       lea.l   L00008d5c,a6
L000061ce                       bsr.b   L00006210
L000061d0                       movem.l (a7)+,d7/a1
L000061d4                       lea.l   $0012(a1),a1
L000061d8                       dbf.w   d7,L0000619e
L000061dc                       rts  



L000061de                       move.w  L00008d28,d3
L000061e4                       beq.b   L000061dc
L000061e6                       move.w  $0022(a6),d0
L000061ea                       addq.w  #$04,d0
L000061ec                       moveq   #$2d,d1
L000061ee                       movem.l d0-d3/a6,-(a7)
L000061f2                       bsr.b   L00006240
L000061f4                       movem.l (a7)+,d0-d3/a6
L000061f8                       moveq   #$3c,d1
L000061fa                       bra.b   L00006240


L000061fc                       lea.l   $00035d4c,a5                    ; external address
L00006202                       add.w   $001e(a6),d1
L00006206                       add.w   $0012(a6),d1
L0000620a                       lea.l   L00006430,a1
L00006210                       lsl.w   #$04,d0
L00006212                       lsl.w   #$02,d1
L00006214                       lea.l   $02(a5,d0.w),a5
L00006218                       move.w  (a5)+,d4
L0000621a                       move.w  (a5)+,d5
L0000621c                       move.w  (a5)+,d7
L0000621e                       move.w  #$0062,d0
L00006222                       move.w  $00(a1,d1.w),d2
L00006226                       cmp.w   #$0064,d2
L0000622a                       beq.b   L0000623e
L0000622c                       add.w   d2,d0
L0000622e                       move.w  $0010(a6),d2
L00006232                       add.w   $02(a1,d1.w),d2
L00006236                       moveq   #$00,d3
L00006238                       move.w  d3,d6
L0000623a                       bra.w   L00004e20

L0000623e                       rts

L00006240                       lea.l   $00035d4c,a5                    ; external address
L00006246                       add.w   $001e(a6),d1
L0000624a                       add.w   $0012(a6),d1
L0000624e                       lea.l   $00006430,a1
L00006254                       lsl.w   #$04,d0
L00006256                       lsl.w   #$02,d1
L00006258                       lea.l   $02(a5,d0.w),a5
L0000625c                       move.w  (a5)+,d4
L0000625e                       move.w  (a5)+,d5
L00006260                       move.w  (a5)+,d7
L00006262                       sub.w   d3,d7
L00006264                       bra.b   L0000621e
L00006266                       add.w   $0012(a6),d1
L0000626a                       lea.l   L00006430,a1
L00006270                       lsl.w   #$04,d0
L00006272                       lsl.w   #$02,d1
L00006274                       lea.l   $02(a5,d0.w),a5
L00006278                       move.w  (a5)+,d4
L0000627a                       move.w  (a5)+,d5
L0000627c                       move.w  (a5)+,d7
L0000627e                       move.w  #$0062,d0
L00006282                       add.w   d2,d0
L00006284                       move.w  $00(a1,d1.w),d2
L00006288                       cmp.w   #$0064,d2
L0000628c                       beq.b   L000062a2
L0000628e                       add.w   d2,d0
L00006290                       move.w  $0010(a6),d2
L00006294                       add.w   d3,d2
L00006296                       add.w   $02(a1,d1.w),d2
L0000629a                       moveq   #$00,d3
L0000629c                       move.w  d3,d6
L0000629e                       bra.w   L00004e20

L000062a2                       rts

L000062a4                       lsl.w   #$04,d1
L000062a6                       lea.l   $00(a5,d1.w),a5
L000062aa                       move.w  (a5)+,d1
L000062ac                       cmp.w   #$0140,d0
L000062b0                       bcs.b   L000062ba
L000062b2                       bpl.b   L000062b8
L000062b4                       add.w   d0,d1
L000062b6                       bpl.b   L000062ba
L000062b8                       rts  

L000062ba                       moveq   #$00,d3
L000062bc                       move.w  (a5)+,d4
L000062be                       move.w  (a5)+,d5
L000062c0                       move.w  (a5)+,d7
L000062c2                       bra.w   L00004e56
L000062c6                       cmp.w   #$0098,d2
L000062ca                       bcs.b   L000062ce
L000062cc                       rts  

L000062ce                       lsl.w   #$04,d1
L000062d0                       lea.l   $00(a5,d1.w),a5
L000062d4                       move.w  (a5)+,d1
L000062d6                       cmp.w   #$0140,d0
L000062da                       bcs.b   L000062e4
L000062dc                       bpl.b   L000062e2
L000062de                       add.w   d0,d1
L000062e0                       bpl.b   L000062e4
L000062e2                       rts  

L000062e4                       moveq   #$00,d3
L000062e6                       move.w  d3,d6
L000062e8                       move.w  (a5)+,d4
L000062ea                       move.w  (a5)+,d5
L000062ec                       move.w  (a5)+,d7
L000062ee                       bra.w   L00004e20


L000062F2               dc.w    $0000,$000C,$FFFB,$000C,$000C,$FFFE,$000A,$0001         ;................
L00006302               dc.w    $000B,$FFFB,$000E,$000B,$FFFE,$000C,$0001,$000A         ;................
L00006312               dc.w    $FFF7,$0010,$000A,$FFFA,$000E,$0001,$FFFF,$0000         ;................
L00006322               dc.w    $0000,$0012,$FFEC,$000E,$0001,$FFFF,$0000,$0000         ;................
L00006332               dc.w    $0013,$FFDC,$000E,$0001,$FFFF,$0000,$0000,$0014         ;................
L00006342               dc.w    $FFC6,$0008,$0000,$000C,$FFBC,$000C,$000C,$FFBC         ;................
L00006352               dc.w    $000A,$0001,$000D,$FFBD,$000E,$000D,$FFBD,$000C         ;................
L00006362               dc.w    $0001,$000E,$FFB8,$0010,$000E,$FFB8,$000E,$0001         ;................
L00006372               dc.w    $FFFF,$0000,$0000,$000F,$FFB2,$000E,$0001,$FFFF         ;................
L00006382               dc.w    $0000,$0000,$0010,$FFB4,$000E,$0001,$FFFF,$0000         ;................
L00006392               dc.w    $0000,$0011,$FFB6,$0008,$0000,$0000,$0006,$0000         ;................
L000063A2               dc.w    $0007,$0000,$0006,$0000,$0003,$0000,$0000,$0002         ;................
L000063B2               dc.w    $0005,$0001,$0007,$0002,$0006,$0001,$0003,$0002         ;................
L000063C2               dc.w    $0000,$FFFE,$0006,$FFFD,$0007,$FFFD,$0006,$FFFD         ;................
L000063D2               dc.w    $0003,$FFFE,$0000,$0002,$0006,$0001,$0007,$0001         ;................
L000063E2               dc.w    $0006,$0001,$0004,$0002,$0000,$0003,$0005,$0002         ;................
L000063F2               dc.w    $0007,$0002,$0006,$0002,$0003,$0003,$0000,$0000         ;................
L00006402               dc.w    $0006,$FFFF,$0007,$FFFF,$0006,$FFFF,$0004,$0000         ;................
L00006412               dc.w    $FFFD,$FFFF,$FFFF,$FFFF,$0000,$FFFB,$FFFC,$FFFD         ;................
L00006422               dc.w    $FFFC,$FFFD,$FFF8,$FFF9,$FFFB,$FFF9,$FFFB,$0020         ;...............
L00006432               dc.w    $0000,$0064,$0000,$0064,$0000,$0022,$0001,$0024         ;...d...d..."...$
L00006442               dc.w    $0002,$0022,$FFFE,$0064,$0000,$0064,$0000,$0022         ;..."...d...d..."
L00006452               dc.w    $0000,$0024,$0001,$0020,$FFFA,$0064,$0000,$0064         ;...$... ...d...d
L00006462               dc.w    $0000,$0022,$FFFB,$0024,$FFFC,$0040,$0000,$003E         ;..."...$...@...>
L00006472               dc.w    $0001,$003C,$0002,$0064,$0000,$0064,$0000,$003E         ;...<...d...d...>
L00006482               dc.w    $FFFE,$003E,$0000,$003C,$0001,$0064,$0000,$0064         ;...>...<...d...d
L00006492               dc.w    $0000,$0040,$FFFA,$003E,$FFFB,$003C,$FFFC,$0064         ;...@...>...<...d
L000064A2               dc.w    $0000,$0064,$0000,$0030,$FFF3,$0030,$FFF3,$0030         ;...d...0...0...0
L000064B2               dc.w    $FFF3,$0030,$FFF3,$0030,$FFF3,$0030,$FFF7,$0030         ;...0...0...0...0
L000064C2               dc.w    $FFF7,$002F,$FFF7,$0030,$FFF7,$0031,$FFF7,$0030         ;.../...0...1...0
L000064D2               dc.w    $FFEC,$0030,$FFEC,$0030,$FFEC,$0030,$FFEC,$0030         ;...0...0...0...0
L000064E2               dc.w    $FFEC,$0000,$FFEB,$0000,$FFE7,$0000,$FFE4,$0000         ;................
L000064F2               dc.w    $FFEF,$0000,$FFF2,$0000,$FFE9,$0000,$FFE5,$0000         ;................
L00006502               dc.w    $FFE2,$0000,$FFED,$0000,$FFF0,$0000,$FFEB,$0000         ;................
L00006512               dc.w    $FFE7,$0000,$FFE4,$0000,$FFEF,$0000,$FFF2,$0052         ;...............R
L00006522               dc.w    $FFEB,$0052,$FFEF,$0052,$FFF2,$0052,$FFE7,$0052         ;...R...R...R...R
L00006532               dc.w    $FFE4,$0052,$FFE9,$0052,$FFED,$0052,$FFF0,$0052         ;...R...R...R...R
L00006542               dc.w    $FFE5,$0052,$FFE2,$0052,$FFEB,$0052,$FFEF,$0052         ;...R...R...R...R
L00006552               dc.w    $FFF2,$0052,$FFE7,$0052,$FFE4,$000E,$0000,$0008         ;...R...R........
L00006562               dc.w    $0000,$0004,$0000,$0000,$0000,$FFFC,$0000,$000E         ;................
L00006572               dc.w    $0003,$0008,$0003,$0004,$0003,$0000,$0003,$FFFC         ;................
L00006582               dc.w    $0003,$000E,$FFFF,$0008,$FFFF,$0004,$FFFF,$0000         ;................
L00006592               dc.w    $FFFF,$FFFC,$FFFF,$0060,$0000,$005C,$0000,$005A         ;.......`...\...Z
L000065A2               dc.w    $0000,$0056,$0000,$0050,$0000,$0060,$0003,$005C         ;...V...P...`...\
L000065B2               dc.w    $0003,$005A,$0003,$0056,$0003,$0050,$0003,$0060         ;...Z...V...P...`
L000065C2               dc.w    $FFFF,$005C,$FFFF,$005A,$FFFF,$0056,$FFFF,$0050         ;...\...Z...V...P
L000065D2               dc.w    $FFFF,$0045,$FFFE,$003F,$FFFE,$0039,$FFFE,$0034         ;...E...?...9...4
L000065E2               dc.w    $FFFE,$0030,$FFFE,$0045,$0000,$003F,$0000,$0039         ;...0...E...?...9
L000065F2               dc.w    $0000,$0034,$0000,$0030,$0000,$0045,$FFFB,$003F         ;...4...0...E...?
L00006602               dc.w    $FFFB,$0039,$FFFB,$0034,$FFFB,$0030,$FFFB,$0044         ;...9...4...0...D
L00006612               dc.w    $FFFF,$003E,$FFFF,$0039,$FFFE,$0033,$FFFF,$002F         ;...>...9...3.../
L00006622               dc.w    $FFFF,$0044,$0001,$003E,$0001,$0039,$0000,$0033         ;...D...>...9...3
L00006632               dc.w    $0001,$002F,$0001,$0044,$FFFC,$003E,$FFFC,$0039         ;.../...D...>...9
L00006642               dc.w    $FFFB,$0033,$FFFC,$002F,$FFFC,$0048,$FFF0,$0043         ;...3.../...H...C
L00006652               dc.w    $FFF0,$003D,$FFF0,$0038,$FFF0,$0033,$FFF0,$0048         ;...=...8...3...H
L00006662               dc.w    $FFF2,$0043,$FFF2,$003D,$FFF2,$0038,$FFF2,$0033         ;...C...=...8...3
L00006672               dc.w    $FFF2,$0048,$FFEB,$0043,$FFEB,$003D,$FFEB,$0038         ;...H...C...=...8
L00006682               dc.w    $FFEB,$0033,$FFEB,$0003,$0010,$FFF4,$0010,$FFF8         ;...3............
L00006692               dc.w    $0000,$FFFC,$0000,$0000,$0007,$0024,$FFEE,$0024         ;...........$...$
L000066A2               dc.w    $FFF2,$0014,$FFF6,$0014,$FFFA,$000A,$0038,$FFFC         ;.............8..
L000066B2               dc.w    $0038,$0000,$0028,$0004,$0028,$0008,$0002,$004C         ;.8...(...(.....L
L000066C2               dc.w    $FFFE,$004C,$0002,$003C,$0006,$003C,$000A,$0005         ;...L...<...<....
L000066D2               dc.w    $0042,$FFF0,$0042,$FFF4,$0032,$FFF8,$0032,$FFFC         ;.B...B...2...2..
L000066E2               dc.w    $0000,$001A,$0002,$001A,$0006,$000A,$000A,$000A         ;................
L000066F2               dc.w    $000E,$0010,$FFF4,$0010,$FFF8,$0000,$FFFC,$0000         ;................
L00006702               dc.w    $0000,$0000,$0000,$0010,$0000,$0010,$0000,$0010         ;................
L00006712               dc.w    $0000,$0010,$0000,$0008,$FFFE,$0000,$FFFC,$0000         ;................
L00006722               dc.w    $FFF8,$0002,$FFF6,$0004,$FFF5,$0006,$FFF4,$0008         ;................
L00006732               dc.w    $000C,$FFEE,$0008,$FFEC,$0008,$FFE8,$000A,$FFE6         ;................
L00006742               dc.w    $000C,$FFE5,$000E,$FFE4,$0010,$0005,$000E,$0004         ;................
L00006752               dc.w    $000C,$0004,$0008,$0006,$0006,$0008,$0005,$000A         ;................
L00006762               dc.w    $0004,$000C,$0000,$0002,$0006,$0000,$0006,$FFFC         ;................
L00006772               dc.w    $0008,$FFFA,$000A,$FFF9,$000C,$FFF8,$000E 



L00006780                       moveq.l #$ffffffff,d1
L00006782                       addq.b  #$01,d1
L00006784                       sub.w   #$0064,d0
L00006788                       bcc.b   L00006782 
L0000678a                       add.w   #$0064,d0
L0000678e                       move.b  d1,d2
L00006790                       add.b   #$30,d1
L00006794                       move.b  d1,(a0)+ 
L00006796                       moveq.l #$ffffffff,d1
L00006798                       addq.b  #$01,d1
L0000679a                       sub.w   #$000a,d0
L0000679e                       bcc.b   L00006798 
L000067a0                       add.w   #$000a,d0
L000067a4                       lsl.b   #$04,d2
L000067a6                       or.b    d1,d2
L000067a8                       add.b   #$30,d1
L000067ac                       move.b  d1,(a0)+
L000067ae                       lsl.w   #$04,d2
L000067b0                       or.b    d0,d2
L000067b2                       add.b   #$30,d0
L000067b6                       move.b  d0,(a0) 
L000067b8                       rts  


L000067ba                       move.w  #$0000,L00008f72
L000067c2                       tst.b   L00008f6e
L000067c8                       beq.b   L000067cc
L000067ca                       bsr.b   L000067dc
L000067cc                       move.w  L00008f6e,d0
L000067d2                       add.b   d0,L00009079
L000067d8                       bcs.b   L000067dc
L000067da                       rts  


L000067dc                       move.l  #$00000010,d0
L000067e2                       pea.l   L000067ee
L000067e8                       jmp     $0007c82a               ; Panel


L000067ee                       move.w  L00009076,d0
L000067f4                       addq.b  #$01,d0
L000067f6                       move.w  d0,L00009076
L000067fc                       addq.w  #$01,L00008f72
L00006802                       addq.w  #$01,L00008d26
L00006808                       lea.l   L00008f74,a0
L0000680e                       move.w  L00009076,d0
L00006814                       add.b   #$1f,d0
L00006818                       move.b  L00009098,d1
L0000681e                       sub.b   #$10,d1
L00006822                       bcc.b   L0000683a
L00006824                       movea.l L00009084,a1
L0000682a                       move.b  (a1)+,d1
L0000682c                       beq.w   L000069ca
L00006830                       move.l  a1,L00009084
L00006836                       sub.b   #$10,d1
L0000683a                       move.b  d1,L00009098
L00006840                       and.b   #$0f,d1
L00006844                       btst.l  #$0003,d1
L00006848                       beq.b   L00006850
L0000684a                       and.w   #$0007,d1
L0000684e                       neg.b   d1
L00006850                       asl.b   #$01,d1
L00006852                       move.b  d1,$00(a0,d0.w)
L00006856                       add.b   #$20,d0
L0000685a                       move.b  L00009099,d1
L00006860                       sub.b   #$10,d1
L00006864                       bcc.b   L0000687c
L00006866                       movea.l L00009088,a1
L0000686c                       move.b  (a1)+,d1
L0000686e                       beq.w   L000069ca
L00006872                       move.l  a1,L00009088
L00006878                       sub.b   #$10,d1
L0000687c                       move.b  d1,L00009099
L00006882                       and.b   #$0f,d1
L00006886                       subq.b  #$08,d1
L00006888                       move.b  d1,$00(a0,d0.w)
L0000688c                       add.b   #$20,d0
L00006890                       add.w   #$0001,L0000907a
L00006898                       and.w   #$0001,L0000907a
L000068a0                       bne.b   L000068b4
L000068a2                       move.b  #$00,$00(a0,d0.w)
L000068a8                       add.b   #$20,d0
L000068ac                       move.b  #$00,$00(a0,d0.w)
L000068b2                       bra.b   L00006918


L000068b4                       move.b  L0000909b,d1
L000068ba                       sub.b   #$10,d1
L000068be                       bcc.b   L000068d6
L000068c0                       movea.l L00009094,a1
L000068c6                       move.b  (a1)+,d1
L000068c8                       beq.w   L000069ca
L000068cc                       move.l  a1,L00009094
L000068d2                       sub.b   #$10,d1
L000068d6                       move.b  d1,L0000909b
L000068dc                       and.b   #$0f,d1
L000068e0                       move.b  d1,$00(a0,d0.w)
L000068e4                       add.b   #$20,d0
L000068e8                       move.b  L0000909a,d1
L000068ee                       sub.b   #$10,d1
L000068f2                       bcc.b   L0000690a
L000068f4                       movea.l L00009090,a1
L000068fa                       move.b  (a1)+,d1
L000068fc                       beq.w   L000069ca
L00006900                       move.l  a1,L00009090
L00006906                       sub.b   #$10,d1
L0000690a                       move.b  d1,L0000909a
L00006910                       and.b   #$0f,d1
L00006914                       move.b  d1,$00(a0,d0.w)
L00006918                       add.b   #$20,d0
L0000691c                       move.b  L0000909c,d1
L00006922                       subq.b  #$01,d1
L00006924                       bcc.b   L00006974
L00006926                       movea.l L0000908c,a1
L0000692c                       move.b  (a1)+,d1
L0000692e                       beq.w   L000069ca
L00006932                       subq.b  #$01,d1
L00006934                       move.b  d1,L0000909c
L0000693a                       move.b  (a1)+,d1
L0000693c                       move.l  a1,L0000908c
L00006942                       cmp.b   #$40,d1
L00006946                       bcs.b   L00006958
L00006948                       rol.b   #$02,d1
L0000694a                       and.w   #$0003,d1
L0000694e                       subq.w  #$01,d1
L00006950                       move.w  d1,L00008d30
L00006956                       bra.b   L00006966


L00006958                       cmp.b   #$20,d1
L0000695c                       bne.b   L00006968
L0000695e                       move.w  #$0001,L00008f64
L00006966                       moveq   #$00,d1
L00006968                       move.b  d1,L0000909d
L0000696e                       move.b  d1,$00(a0,d0.w)
L00006972                       bra.b   L00006982
L00006974                       move.b  d1,L0000909c
L0000697a                       move.b  L0000909d,$00(a0,d0.w)
L00006982                       bsr.w   L00006bda
L00006986                       lea.l   L00008e0e,a0
L0000698c                       moveq   #$07,d7
L0000698e                       tst.b   $0000(a0)
L00006992                       beq.b   L000069c0
L00006994                       move.b  $0002(a0),d0
L00006998                       subq.b  #$01,d0
L0000699a                       bpl.b   L000069bc
L0000699c                       move.b  #$00,$0000(a0)
L000069a2                       tst.w   $001a(a0)
L000069a6                       beq.b   L000069c0
L000069a8                       tst.w   $0028(a0)
L000069ac                       bne.b   L000069c0
L000069ae                       pea.l   L000069c0
L000069b4                       moveq   #$01,d0
L000069b6                       jmp     $0007c870                       ; Panel


L000069bc                       move.b  d0,$0002(a0)
L000069c0                       lea.l   $002a(a0),a0
L000069c4                       dbf.w   d7,L0000698e
L000069c8                       rts 


L000069ca                       movea.l L00009080,a0
L000069d0                       move.l  (a0)+,d0
L000069d2                       bne.b   L000069d8
L000069d4                       movea.l (a0),a0
L000069d6                       bra.b   L000069d0
L000069d8                       move.l  d0,L00009084
L000069de                       move.l  (a0)+,$00009088
L000069e4                       move.l  (a0)+,$00009094
L000069ea                       move.l  (a0)+,$00009090
L000069f0                       move.l  (a0)+,$0000908c
L000069f6                       move.l  a0,L00009080
L000069fc                       moveq   #$00,d0

L000069fe                       move.w  d0,L0000907a 
L00006a04                       move.b  d0,L00009098
L00006a0a                       move.b  d0,L00009099
L00006a10                       move.b  d0,L0000909b
L00006a16                       move.b  d0,L0000909a
L00006a1c                       move.b  d0,L0000909c
L00006a22                       move.b  d0,L0000909d
L00006a28                       bra.w   L00006808
L00006a2c                       movea.l L0000907c,a0
L00006a32                       move.l  (a0)+,d0
L00006a34                       bne.b   L00006a3a
L00006a36                       movea.l (a0),a0
L00006a38                       bra.b   L00006a32
L00006a3a                       move.l  d0,L00009080
L00006a40                       move.l  a0,L0000907c
L00006a46                       moveq   #$00,d0
L00006a48                       move.w  d0,L00009076
L00006a4e                       move.w  d0,L00009078
L00006a54                       lea.l   L00008f74,a0
L00006a5a                       move.w  #$003f,d7
L00006a5e                       move.l  d0,(a0)+
L00006a60                       dbf.w   d7,L00006a5e 
L00006a64                       bsr.w   L000069ca
L00006a68                       moveq   #$1f,d7
L00006a6a                       move.w  d7,-(a7)
L00006a6c                       bsr.w   L000067ee
L00006a70                       move.w  (a7)+,d7
L00006a72                       dbf.w   d7,L00006a6a
L00006a76                       lea.l   L00008d3c,a0
L00006a7c                       move.w  $0008(a0),d1
L00006a80                       movea.l a0,a1
L00006a82                       moveq   #$0f,d7
L00006a84                       move.w  #$0000,(a0)+
L00006a88                       dbf.w   d7,L00006a84
L00006a8c                       move.w  #$0058,$0006(a1)
L00006a92                       add.w   #$0028,d1
L00006a96                       cmp.w   #$0140,d1
L00006a9a                       bcs.b   L00006aa0
L00006a9c                       sub.w   #$0140,d1
L00006aa0                       move.w  d1,$0008(a1)
L00006aa4                       move.w  d1,$0018(a1)
L00006aa8                       move.w  #$016d,L00009074
L00006ab0                       rts 


L00006ab2                       dc.w    $ffff 
L00006ab4                       dc.w    $ffff 
L00006ab6                       dc.w    $7f7f 
L00006ab8                       dc.w    $5555 
L00006aba                       dc.w    $0000
L00006abc                       dc.w    $0101
L00006abe                       dc.w    $0202
L00006ac0                       dc.w    $0303
L00006ac2                       dc.w    $ffff 
L00006ac4                       dc.w    $ffff 
L00006ac6                       dc.w    $ffff 
L00006ac8                       dc.w    $7f7f 
L00006aca                       dc.w    $0000 
L00006acc                       dc.w    $0101
L00006ace                       dc.w    $0202 
L00006ad0                       dc.w    $0303
L00006ad2                       dc.w    $0401 
L00006ad4                       dc.w    $0301
L00006ad6                       dc.w    $0201 
L00006ad8                       dc.w    $0101
L00006ada                       dc.w    $0301 
L00006adc                       dc.w    $0201
L00006ade                       dc.w    $0201
L00006ae0                       dc.w    $0102 
L00006ae2                       dc.w    $0201
L00006ae4                       dc.w    $0102
L00006ae6                       dc.w    $0103 
L00006ae8                       dc.w    $0104 
L00006aea                       dc.w    $0201 
L00006aec                       dc.w    $0101
L00006aee                       dc.w    $0102
L00006af0                       dc.w    $0102
L00006af2                       dc.w    $0101
L00006af4                       dc.w    $0102
L00006af6                       dc.w    $0102
L00006af8                       dc.w    $0104
L00006afa                       dc.w    $0102
L00006afc                       dc.w    $0104
L00006afe                       dc.w    $0104
L00006b00                       dc.w    $0106


L00006b02                       lea.l   L00008d3c,a0
L00006b08                       lea.l   L00006ae2,a1
L00006b0e                       lea.l   L00006ab1,a2
L00006b14                       move.w  #$0140,d7
L00006b18                       bsr.b   L00006b4a
L00006b1a                       move.w  $0006(a0),d0
L00006b1e                       move.w  d0,-(a7)
L00006b20                       lea.l   L00008d4c,a0
L00006b26                       lea.l   L00006aca,a1
L00006b2c                       lea.l   L00006ac1,a2
L00006b32                       move.w  #$0140,d7
L00006b36                       bsr.b   L00006b4a
L00006b38                       move.w  (a7)+,d0
L00006b3a                       sub.w   #$0058,d0
L00006b3e                       asr.w   #$01,d0
L00006b40                       add.w   #$006e,d0
L00006b44                       move.w  d0,$0006(a0)
L00006b48                       rts  


L00006b4a                       move.w  L00008f6e,d0
L00006b50                       bne.b   L00006b54
L00006b52                       rts  


L00006b54                       tst.w   $000e(a0)
L00006b58                       beq.w   L00006b98
L00006b5c                       subq.w  #$01,$000c(a0)
L00006b60                       bne.b   L00006b98
L00006b62                       lsr.w   #$05,d0
L00006b64                       and.w   #$00fe,d0
L00006b68                       add.w   $000a(a0),d0
L00006b6c                       moveq   #$00,d1
L00006b6e                       move.b  $00(a1,d0.w),d1
L00006b72                       move.w  d1,$000c(a0)
L00006b76                       move.b  $01(a1,d0.w),d1
L00006b7a                       tst.w   $000e(a0)
L00006b7e                       bmi.w   L00006b84
L00006b82                       neg.w   d1
L00006b84                       add.w   $0008(a0),d1
L00006b88                       bpl.b   L00006b8e
L00006b8a                       add.w   d7,d1
L00006b8c                       bra.b   L00006b94

L00006b8e                       cmp.w   d7,d1
L00006b90                       bcs.b   L00006b94
L00006b92                       sub.w   d7,d1
L00006b94                       move.w  d1,$0008(a0)
L00006b98                       move.w  $0002(a0),d0
L00006b9c                       beq.b   L00006bd8
L00006b9e                       bpl.b   L00006ba2
L00006ba0                       neg.w   d0
L00006ba2                       move.b  $00(a2,d0.w),d0
L00006ba6                       move.w  L00009078,d1
L00006bac                       sub.w   $0004(a0),d1
L00006bb0                       beq.b   L00006bd8
L00006bb2                       moveq   #$00,d2
L00006bb4                       move.w  d2,d3
L00006bb6                       sub.b   d0,d1
L00006bb8                       bcs.b   L00006bc0
L00006bba                       addq.w  #$01,d2
L00006bbc                       add.w   d0,d3
L00006bbe                       bra.b   L00006bb6


L00006bc0                       tst.w   d2
L00006bc2                       beq.b   L00006bd8
L00006bc4                       add.w   d2,$0000(a0)
L00006bc8                       tst.w   $0002(a0)
L00006bcc                       bpl.b   L00006bd0
L00006bce                       neg.w   d2
L00006bd0                       add.w   d2,$0006(a0)
L00006bd4                       add.w   d3,$0004(a0)
L00006bd8                       rts 


L00006bda                       lea.l   L00008f74,a6
L00006be0                       lea.l   L00008d3c,a0
L00006be6                       lea.l   L00006ae2,a2
L00006bec                       lea.l   L00006ab9,a3
L00006bf2                       bsr.w   L00006cbc
L00006bf6                       lea.l   L00008d4c,a0
L00006bfc                       lea.l   L00006aca,a2
L00006c02                       lea.l   L00006ac9,a3
L00006c08                       bsr.w   L00006cbc
L00006c0c                       lea.l   L00008d5c,a1
L00006c12                       move.w  $000e(a1),d0
L00006c16                       bpl.b   L00006c1a
L00006c18                       neg.w   d0
L00006c1a                       sub.w   $000c(a1),d0
L00006c1e                       bcs.b   L00006c36
L00006c20                       beq.b   L00006c36
L00006c22                       move.w  d0,d1
L00006c24                       mulu.w  #$0003,d0
L00006c28                       add.w   d1,d0
L00006c2a                       tst.w   $000e(a1)
L00006c2e                       bpl.b   L00006c32
L00006c30                       neg.w   d0

L00006c32                       add.w   d0,$0034(a1)
L00006c36                       move.w  #$0000,$000a(a1)
L00006c3c                       move.w  #$0000,$000c(a1)
L00006c42                       move.w  $000e(a0),$000e(a1)
L00006c48                       move.w  L00009076,d0
L00006c4e                       add.b   #$21,d0
L00006c52                       moveq   #$00,d1
L00006c54                       move.b  $00(a6,d0.w),d0
L00006c58                       beq.b   L00006c62
L00006c5a                       moveq   #$05,d1
L00006c5c                       tst.b   d0
L00006c5e                       bmi.b   L00006c62
L00006c60                       moveq   #$0a,d1
L00006c62                       move.w  d1,$0016(a1)
L00006c66                       move.w  $001a(a1),d1
L00006c6a                       bpl.b   L00006cae
L00006c6c                       tst.b   d0
L00006c6e                       bmi.b   L00006cae
L00006c70                       neg.w   d1
L00006c72                       subq.w  #$02,d1
L00006c74                       bcs.b   L00006cae
L00006c76                       tst.w   $0018(a1)
L00006c7a                       bne.b   L00006cae
L00006c7c                       move.w  L00008f6e,d2
L00006c82                       lsr.w   #$07,d2
L00006c84                       not.w   d2
L00006c86                       addq.w  #$04,d2
L00006c88                       sub.w   d2,d1
L00006c8a                       bcs.b   L00006cae
L00006c8c                       beq.b   L00006cae
L00006c8e                       lsl.w   #$02,d1
L00006c90                       lea.l   L0000574c,a2
L00006c96                       lea.l   $00(a2,d1.w),a2
L00006c9a                       move.w  (a2)+,d1
L00006c9c                       move.w  (a2),$0018(a1)
L00006ca0                       lea.l   L00005728,a2
L00006ca6                       lea.l   $00(a2,d1.w),a2
L00006caa                       move.l  a2,$001c(a1)
L00006cae                       tst.b   d0
L00006cb0                       bpl.b   L00006cb6
L00006cb2                       or.w    #$ff00,d0
L00006cb6                       move.w  d0,$001a(a1)
L00006cba                       rts  


L00006cbc                       move.w  $0000(a0),d0
L00006cc0                       move.w  $0002(a0),d1
L00006cc4                       beq.b   L00006cde
L00006cc6                       bpl.b   L00006cca
L00006cc8                       neg.w   d1
L00006cca                       move.b  $00(a3,d1.w),d1
L00006cce                       sub.w   d0,d1
L00006cd0                       beq.b   L00006cde
L00006cd2                       tst.w   $0002(a0)
L00006cd6                       bpl.b   L00006cda
L00006cd8                       neg.w   d1
L00006cda                       add.w   d1,$0006(a0)
L00006cde                       move.w  L00009076,d0
L00006ce4                       add.b   #$22,d0
L00006ce8                       moveq   #$00,d1
L00006cea                       move.w  d1,$0004(a0)
L00006cee                       move.w  d1,$0000(a0)
L00006cf2                       move.b  $00(a6,d0.w),d1
L00006cf6                       bpl.b   L00006cfc
L00006cf8                       or.w    #$ff00,d1
L00006cfc                       move.w  d1,$0002(a0)
L00006d00                       move.w  L00009076,d0
L00006d06                       move.b  $00(a6,d0.w),d0
L00006d0a                       bpl.b   L00006d10
L00006d0c                       or.w    #$ff00,d0
L00006d10                       move.w  d0,$000e(a0)
L00006d14                       tst.w   d0
L00006d16                       beq.b   L00006d3a
L00006d18                       bpl.b   L00006d1c
L00006d1a                       neg.w   d0
L00006d1c                       asl.w   #$02,d0
L00006d1e                       move.w  d0,$000a(a0)
L00006d22                       tst.w   $000c(a0)
L00006d26                       bne.b   L00006d3e
L00006d28                       move.w  L00008f6e,d1
L00006d2e                       lsr.w   #$05,d1
L00006d30                       and.w   #$00fe,d1
L00006d34                       add.w   d0,d1
L00006d36                       move.b  $00(a2,d1.w),d0
L00006d3a                       move.w  d0,$000c(a0)
L00006d3e                       rts 


L00006d40                       lea.l   L00007bc8,a1
L00006d46                       lea.l   L00007cc8,a2
L00006d4c                       lea.l   L00007dc8,a3
L00006d52                       lea.l   L00007ec8,a4
L00006d58                       lea.l   L00007fc8,a5
L00006d5e                       move.w  #$006f,d7
L00006d62                       move.w  (a1)+,d1
L00006d64                       move.w  (a5)+,d0
L00006d66                       sub.w   d1,d0
L00006d68                       asr.w   #$01,d0
L00006d6a                       move.w  d0,d2
L00006d6c                       add.w   d1,d0
L00006d6e                       move.w  d0,(a3)+
L00006d70                       move.w  d2,d1
L00006d72                       asr.w   #$01,d2
L00006d74                       add.w   d2,d0
L00006d76                       move.w  d0,(a4)+
L00006d78                       sub.w   d1,d0
L00006d7a                       move.w  d0,(a2)+
L00006d7c                       dbf.w   d7,L00006d62 
L00006d80                       rts  


L00006d82                       move.l  a4,d2
L00006d84                       sub.l   #$0000909e,d2
L00006d8a                       cmp.w   #$0015,d2
L00006d8e                       bcc.w   L00006e96
L00006d92                       lea.l   L00007a20,a1
L00006d98                       move.w  L00009078,d1
L00006d9e                       and.w   #$00e0,d1
L00006da2                       add.b   d2,d1
L00006da4                       move.w  d7,d3
L00006da6                       lsl.w   #$01,d3
L00006da8                       btst.l  #$0000,d0
L00006dac                       bne.b   L00006e12
L00006dae                       btst.l  #$0001,d0
L00006db2                       bne.b   L00006de4
L00006db4                       move.b  -$01(a1,d1.w),d1         ;$ff(a1,d1.w),d1
L00006db8                       lea.l   $0400(a5),a1
L00006dbc                       move.w  (a1),d0
L00006dbe                       add.w   d1,d0
L00006dc0                       move.w  $00(a1,d3.w),d3
L00006dc4                       cmp.w   #$0001,d2
L00006dc8                       bne.b   L00006ddc
L00006dca                       move.w  L00009078,d2
L00006dd0                       and.w   #$00e0,d2
L00006dd4                       lsr.w   #$02,d2
L00006dd6                       sub.w   d2,d0
L00006dd8                       lsr.w   #$02,d2
L00006dda                       sub.w   d2,d0
L00006ddc                       sub.w   d0,d3
L00006dde                       move.w  d3,d1
L00006de0                       bra.w   L00006e6e 


L00006de4                       move.b  $00(a1,d1.w),d1
L00006de8                       lea.l   $0400(a5),a1
L00006dec                       move.w  (a1),d0
L00006dee                       move.w  $00(a1,d3.w),d3
L00006df2                       add.w   d1,d3
L00006df4                       cmp.w   #$0001,d2
L00006df8                       bne.b   L00006e0c
L00006dfa                       move.w  L00009078,d2
L00006e00                       and.w   #$00e0,d2
L00006e04                       lsr.w   #$02,d2
L00006e06                       add.w   d2,d0
L00006e08                       lsr.w   #$02,d2
L00006e0a                       add.w   d2,d0
L00006e0c                       sub.w   d0,d3
L00006e0e                       move.w  d3,d1
L00006e10                       bra.b   L00006e6e


L00006e12                       btst.l  #$0001,d0
L00006e16                       bne.b   L00006e44
L00006e18                       move.w  (a5),d0
L00006e1a                       move.b  -$01(a1,d1.w),d1 ; $ff(a1,d1.w),d1
L00006e1e                       sub.w   d1,d0
L00006e20                       move.w  $00(a5,d3.w),d3
L00006e24                       cmp.w   #$0001,d2
L00006e28                       bne.b   L00006e3c
L00006e2a                       move.w  L00009078,d2
L00006e30                       and.w   #$00e0,d2
L00006e34                       lsr.w   #$02,d2
L00006e36                       add.w   d2,d0
L00006e38                       lsr.w   #$02,d2
L00006e3a                       add.w   d2,d0
L00006e3c                       sub.w   d0,d3
L00006e3e                       move.w  d3,d1
L00006e40                       movea.l a5,a1
L00006e42                       bra.b   L00006e6e


L00006e44                       move.w  (a5),d0
L00006e46                       move.w  $00(a5,d3.w),d3
L00006e4a                       move.b  $00(a1,d1.w),d1
L00006e4e                       sub.w   d1,d3
L00006e50                       cmp.w   #$0001,d2
L00006e54                       bne.b   L00006e68
L00006e56                       move.w  L00009078,d2
L00006e5c                       and.w   #$00e0,d2
L00006e60                       lsr.w   #$02,d2
L00006e62                       sub.w   d2,d0
L00006e64                       lsr.w   #$02,d2
L00006e66                       sub.w   d2,d0
L00006e68                       sub.w   d0,d3
L00006e6a                       move.w  d3,d1
L00006e6c                       movea.l a5,a1
L00006e6e                       cmp.w   #$0002,d7
L00006e72                       bcs.b   L00006ee0
L00006e74                       move.w  d7,d2
L00006e76                       subq.w  #$01,d2
L00006e78                       tst.w   d1
L00006e7a                       bpl.b   L00006eae
L00006e7c                       neg.w   d1
L00006e7e                       cmp.w   d1,d7
L00006e80                       bcs.b   L00006e98
L00006e82                       move.b  d7,d3
L00006e84                       lsr.b   #$01,d3
L00006e86                       add.b   d1,d3
L00006e88                       cmp.b   d7,d3
L00006e8a                       bcs.b   L00006e90
L00006e8c                       sub.b   d7,d3
L00006e8e                       subq.w  #$01,d0
L00006e90                       move.w  d0,(a1)+
L00006e92                       dbf.w   d2,L00006e86
L00006e96                       rts  


L00006e98                       moveq   #$00,d3
L00006e9a                       subq.w  #$01,d0
L00006e9c                       add.b   d7,d3
L00006e9e                       bcs.b   L00006ea4
L00006ea0                       cmp.b   d1,d3
L00006ea2                       bcs.b   L00006e9a
L00006ea4                       sub.b   d1,d3
L00006ea6                       move.w  d0,(a1)+
L00006ea8                       dbf.w   d2,L00006e9a
L00006eac                       rts     


L00006eae                       cmp.w   d1,d7
L00006eb0                       bcs.w   L00006eca
L00006eb4                       move.b  d7,d3
L00006eb6                       lsr.b   #$01,d3
L00006eb8                       add.b   d1,d3
L00006eba                       cmp.b   d7,d3
L00006ebc                       bcs.b   L00006ec2
L00006ebe                       sub.b   d7,d3
L00006ec0                       addq.w  #$01,d0
L00006ec2                       move.w  d0,(a1)+
L00006ec4                       dbf.w   d2,L00006eb8
L00006ec8                       rts  


L00006eca                       moveq   #$00,d3
L00006ecc                       addq.w  #$01,d0
L00006ece                       add.b   d7,d3
L00006ed0                       bcs.b   L00006ed6
L00006ed2                       cmp.b   d1,d3
L00006ed4                       bcs.b   L00006ecc
L00006ed6                       sub.b   d1,d3
L00006ed8                       move.w  d0,(a1)+
L00006eda                       dbf.w   d2,L00006ecc
L00006ede                       rts  


L00006ee0                       add.w   d1,d0
L00006ee2                       move.w  d0,(a1)+
L00006ee4                       rts 


L00006ee6                       movea.l L000037c4,a0
L00006eec                       move.l  a0,$00dff054
L00006ef2                       move.w  #$0000,$00dff066
L00006efa                       move.w  #$ffff,$00dff070
L00006f02                       move.w  #$01aa,$00dff040
L00006f0a                       move.w  #$0000,$00dff042
L00006f12                       move.w  #$2614,$00dff058
L00006f1a                       rts 


L00006f1c                       movea.l L000037c4,a0
L00006f22                       lea.l   $2f80(a0),a0
L00006f26                       lea.l   L0000909f,a4
L00006f2c                       lea.l   L00007bc8,a5
L00006f32                       moveq   #$00,d5
L00006f34                       move.l  #$00000130,d6
L00006f3a                       moveq   #$60,d7
L00006f3c                       sub.b   (a4),d7
L00006f3e                       lea.l   L00008f74,a2
L00006f44                       move.w  L00009076,d4
L00006f4a                       move.w  d4,d0
L00006f4c                       move.w  d4,d1
L00006f4e                       add.b   #$80,d4
L00006f52                       and.w   #$0001,d0
L00006f56                       move.w  d0,L00008f68
L00006f5c                       and.w   #$0002,d1
L00006f60                       lsr.w   #$01,d1
L00006f62                       move.w  d1,L00008f6a
L00006f68                       move.w  #$0002,L00008f6c
L00006f70                       tst.w   L00008f6a
L00006f76                       movea.l a0,a3
L00006f78                       bne.b   L00006f7e
L00006f7a                       lea.l   $2f80(a0),a3
L00006f7e                       move.b  $00(a2,d4.w),d0
L00006f82                       and.w   #$000f,d0
L00006f86                       beq.b   L00006fa0
L00006f88                       btst.l  #$0003,d0
L00006f8c                       beq.b   L00006f9a
L00006f8e                       and.l   #$00000003,d0
L00006f94                       swap.w  d0
L00006f96                       or.l    d0,d5
L00006f98                       bra.b   L00006fa6


L00006f9a                       bsr.w   L00006d82
L00006f9e                       movea.l a0,a3
L00006fa0                       and.l   #$0000ffff,d5
L00006fa6                       subq.b  #$01,d7
L00006fa8                       moveq   #$00,d0
L00006faa                       move.l  d0,d1
L00006fac                       move.l  d0,d2
L00006fae                       move.l  d0,d3
L00006fb0                       movem.l d0-d3,-(a0)
L00006fb4                       movem.l d0-d3,-(a0)
L00006fb8                       movem.l d0-d1,-(a0)
L00006fbc                       lea.l   $17e8(a0),a1
L00006fc0                       movem.l d0-d3,-(a1)
L00006fc4                       movem.l d0-d3,-(a1)
L00006fc8                       movem.l d0-d1,-(a1)
L00006fcc                       lea.l   $17e8(a1),a1
L00006fd0                       movem.l d0-d3,-(a1)
L00006fd4                       movem.l d0-d3,-(a1)
L00006fd8                       movem.l d0-d1,-(a1)

L00006fdc                       lea.l   -$0028(a3),a3
L00006fe0                       move.w  (a5)+,d1
L00006fe2                       btst.l  #$0010,d5
L00006fe6                       bne.b   L00007008
L00006fe8                       cmp.w   d6,d1
L00006fea                       bcc.b   L00007008
L00006fec                       move.w  d1,d0
L00006fee                       lsl.w   #$02,d0
L00006ff0                       and.w   #$003c,d0
L00006ff4                       or.w    d5,d0
L00006ff6                       lsr.w   #$03,d1
L00006ff8                       bclr.l  #$0000,d1
L00006ffc                       lea.l   L0000994e,a6
L00007002                       move.l  $00(a6,d0.w),$00(a3,d1.w)
L00007008                       tst.w   L00008f6a
L0000700e                       bne.w   L00007082
L00007012                       tst.w   L00008f68
L00007018                       bne.w   L00007082
L0000701c                       lea.l   L00009a8e,a6
L00007022                       move.w  $00fe(a5),d1
L00007026                       cmp.w   d6,d1
L00007028                       bcc.b   L00007042
L0000702a                       move.w  d1,d0
L0000702c                       lsl.w   #$02,d0
L0000702e                       and.w   #$003c,d0
L00007032                       or.w    d5,d0
L00007034                       lsr.w   #$03,d1
L00007036                       bclr.l  #$0000,d1
L0000703a                       move.l  $00(a6,d0.w),d0
L0000703e                       or.l    d0,$00(a0,d1.w)
L00007042                       move.w  $01fe(a5),d1

L00007046                       cmp.w   d6,d1
L00007048                       bcc.b   L00007062
L0000704a                       move.w  d1,d0
L0000704c                       lsl.w    #$02,d0
L0000704e                       and.w   #$003c,d0
L00007052                       or.w    d5,d0
L00007054                       lsr.w   #$03,d1
L00007056                       bclr.l  #$0000,d1
L0000705a                       move.l  $00(a6,d0.w),d0
L0000705e                       or.l    d0,$00(a0,d1.w)
L00007062                       move.w  $02fe(a5),d1
L00007066                       cmp.w   d6,d1
L00007068                       bcc.b   L00007082
L0000706a                       move.w  d1,d0
L0000706c                       lsl.w   #$02,d0
L0000706e                       and.w   #$003c,d0
L00007072                       or.w    d5,d0
L00007074                       lsr.w   #$03,d1
L00007076                       bclr.l  #$0000,d1
L0000707a                       move.l  $00(a6,d0.w),d0
L0000707e                       or.l    d0,$00(a0,d1.w)
L00007082                       btst.l  #$0011,d5
L00007086                       bne.b   L000070ae
L00007088                       move.w  $03fe(a5),d1
L0000708c                       cmp.w   d6,d1
L0000708e                       bcc.b   L000070ae
L00007090                       move.w  d1,d0
L00007092                       lsl.w   #$02,d0
L00007094                       and.w   #$003c,d0
L00007098                       or.w    d5,d0
L0000709a                       lsr.w   #$03,d1
L0000709c                       bclr.l  #$0000,d1
L000070a0                       lea.l   L0000994e,a6
L000070a6                       move.l  $00(a6,d0.w),d0
L000070aa                       or.l    d0,$00(a3,d1.w)
L000070ae                       add.l   #$00010000,d6
L000070b4                       dbf.w   d7,L00006fa8

L000070b8                       not.w   d7
L000070ba                       bra.b   L000070be
L000070bc                       addq.w  #$02,a5
L000070be                       bsr.b   L000070f4
L000070c0                       addq.b  #$01,d4
L000070c2                       move.b  (a4)+,d7
L000070c4                       sub.b   (a4),d7
L000070c6                       beq.b   L000070bc
L000070c8                       bpl.b   L000070ea
L000070ca                       bsr.b   L000070f4
L000070cc                       move.b  (a4)+,d0
L000070ce                       sub.b   (a4),d0
L000070d0                       cmp.b   #$e0,d0
L000070d4                       bcc.b   L000070dc
L000070d6                       cmp.b   #$50,d0
L000070da                       bcc.b   L00007122
L000070dc                       addq.w  #$02,a5
L000070de                       addq.b  #$01,d4
L000070e0                       add.b   d0,d7
L000070e2                       beq.b   L000070ca
L000070e4                       bmi.b   L000070ca
L000070e6                       bra.w   L00006f70
L000070ea                       cmp.b   #$50,d7
L000070ee                       bcs.w   L00006f70
L000070f2                       bra.b   L00007122
L000070f4                       eor.w   #$0001,L00008f68
L000070fc                       bne.b   L00007106
L000070fe                       eor.w   #$0001,L00008f6a
L00007106                       subq.w  #$01,L00008f6c
L0000710c                       bne.b   L00007120
L0000710e                       move.w  #$0003,L00008f6c 
L00007116                       cmp.w   #$0100,d5
L0000711a                       bcc.b   L00007120
L0000711c                       add.w   #$0040,d5
L00007120                       rts 


L00007122                       swap.w  d6
L00007124                       move.w  d6,L00008d3a
L0000712a                       movem.l d6/a0,-(a7)
L0000712e                       lea.l   $00024b00,a4                    ; external address
L00007134                       lea.l   L00008d4c,a5
L0000713a                       move.w  #$0020,d7
L0000713e                       move.w  $0006(a5),d0
L00007142                       bmi.w   L00007276
L00007146                       sub.w   d6,d0
L00007148                       beq.b   L00007174
L0000714a                       bcs.b   L0000716c
L0000714c                       add.w   d0,d6
L0000714e                       subq.w  #$01,d0
L00007150                       moveq   #$00,d1
L00007152                       move.l  d1,d2
L00007154                       move.l  d1,d3
L00007156                       move.l  d1,d4
L00007158                       move.l  d1,d5
L0000715a                       lea.l   -$17c0(a0),a0
L0000715e                       movem.l d1-d5,-(a0)
L00007162                       movem.l d1-d5,-(a0)
L00007166                       dbf.w   d0,L0000715e
L0000716a                       bra.b   L00007174
L0000716c                       add.w   d7,d0
L0000716e                       beq.w   L00007276
L00007172                       move.w  d0,d7
L00007174                       add.w   d7,d6
L00007176                       sub.w   #$0098,d6
L0000717a                       bcs.b   L00007188
L0000717c                       sub.w   d6,d7
L0000717e                       mulu.w  #$0050,d6

L00007182                       lea.l   $00(a4,d6.w),a4
L00007186                       moveq   #$00,d6
L00007188                       movea.l L000037c4,a0
L0000718e                       lea.l   -$0002(a0),a0
L00007192                       neg.w   d6
L00007194                       beq.b   L000071a2
L00007196                       move.w  d6,d0
L00007198                       lsl.w   #$02,d0
L0000719a                       add.w   d6,d0
L0000719c                       lsl.w   #$03,d0
L0000719e                       lea.l   $00(a0,d0.w),a0
L000071a2                       lsl.w   #$06,d7
L000071a4                       move.w  d7,d6
L000071a6                       or.w    #$0015,d7
L000071aa                       move.w  $0008(a5),d0
L000071ae                       move.w  d0,d1
L000071b0                       and.w   #$000f,d0
L000071b4                       move.w  d0,d2
L000071b6                       ror.w   #$04,d0
L000071b8                       or.w    #$0b0a,d0
L000071bc                       move.w  d0,$00dff040
L000071c2                       move.w  #$0000,$00dff042
L000071ca                       lsl.w   #$01,d2

L000071cc                       lea.l   L00004f8c,a1
L000071d2                       move.w  $00(a1,d2.w),$00dff046
L000071da                       move.w  $20(a1,d2.w),$00dff044
L000071e2                       and.w   #$fff0,d1
L000071e6                       lsr.w   #$03,d1
L000071e8                       neg.w   d1
L000071ea                       add.w   #$0028,d1

L000071ee                       lea.l   -$02(a4,d1.w),a4                ; $fe
L000071f2                       move.w  #$0026,$00dff064
L000071fa                       move.w  #$fffe,$00dff060
L00007202                       move.w  #$fffe,$00dff066
L0000720a                       move.l  a4,$00dff050
L00007210                       move.l  a0,$00dff054
L00007216                       move.l  a0,$00dff048
L0000721c                       move.w  d7,$00dff058
L00007222                       move.w  $00dff002,d1
L00007228                       btst.l  #$000e,d1
L0000722c                       bne.b   L00007222
L0000722e                       lea.l   $0026(a0),a0
L00007232                       lea.l   $0026(a4),a4
L00007236                       move.w  #$004c,$00dff064
L0000723e                       move.w  #$0024,$00dff060
L00007246                       move.w  #$0024,$00dff066
L0000724e                       move.l  a4,$00dff050
L00007254                       move.l  a0,$00dff048
L0000725a                       move.l  a0,$00dff054
L00007260                       or.w    #$0002,d6
L00007264                       move.w  d6,$00dff058
L0000726a                       move.w  $00dff002,d0
L00007270                       btst.l  #$000e,d0
L00007274                       bne.b   L0000726a
L00007276                       movem.l (a7)+,d6/a0

L0000727a                       lea.l   $00020000,a4                    ; external gfx?
L00007280                       lea.l   L00008d3c,a5
L00007286                       move.w  #$0030,d7
L0000728a                       move.w  $0006(a5),d0
L0000728e                       bmi.w   L00007498
L00007292                       sub.w   d6,d0
L00007294                       bcc.b   L000072a2
L00007296                       add.w   d7,d0
L00007298                       beq.w   L00007498
L0000729c                       bcc.w   L00007498
L000072a0                       move.w  d0,d7
L000072a2                       add.w   d7,d6
L000072a4                       sub.w   #$0098,d6
L000072a8                       bcs.b   L000072b4
L000072aa                       sub.w   d6,d7
L000072ac                       mulu.w  #$0050,d6
L000072b0                       adda.w  d6,a4
L000072b2                       moveq   #$00,d6
L000072b4                       movea.l L000037c4,a0
L000072ba                       lea.l   -$0002(a0),a0
L000072be                       neg.w   d6
L000072c0                       move.w  d6,-(a7)
L000072c2                       beq.b   L000072d0
L000072c4                       move.w  d6,d0
L000072c6                       lsl.w   #$02,d0
L000072c8                       add.w   d6,d0
L000072ca                       lsl.w   #$03,d0
L000072cc                       lea.l   $00(a0,d0.w),a0
L000072d0                       lsl.w   #$06,d7
L000072d2                       move.w  d7,d6
L000072d4                       or.w    #$0015,d7
L000072d8                       move.w  $0008(a5),d0
L000072dc                       move.w  d0,d1
L000072de                       and.w   #$000f,d0
L000072e2                       move.w  d0,d2
L000072e4                       ror.w   #$04,d0
L000072e6                       move.w  d0,d5
L000072e8                       move.w  d0,$00dff042
L000072ee                       or.w    #$0fca,d0
L000072f2                       move.w  d0,$00dff040
L000072f8                       lsl.w   #$01,d2

L000072fa                       lea.l   $00004f8c,a1
L00007300                       move.w  $00(a1,d2.w),$00dff046
L00007308                       move.w  $20(a1,d2.w),$00dff044
L00007310                       and.w   #$fff0,d1
L00007314                       lsr.w   #$03,d1
L00007316                       neg.w   d1
L00007318                       add.w   #$0028,d1
L0000731c                       lea.l   -$02(a4,d1.w),a4        ; $fe
L00007320                       movea.l a4,a5
L00007322                       move.w  #$0026,$00dff064
L0000732a                       move.w  #$0026,$00dff062
L00007332                       move.w  #$fffe,$00dff060
L0000733a                       move.w  #$fffe,$00dff066
L00007342                       lea.l   $0f00(a5),a5
L00007346                       move.l  a4,$00dff050
L0000734c                       move.l  a5,$00dff04c
L00007352                       move.l  a0,$00dff048
L00007358                       move.l  a0,$00dff054
L0000735e                       move.w  d7,$00dff058
L00007364                       move.w  $00dff002,d1
L0000736a                       btst.l  #$000e,d1
L0000736e                       bne.b   L00007364
L00007370                       move.w  #$004c,$00dff064
L00007378                       move.w  #$004c,$00dff062
L00007380                       move.w  #$0024,$00dff060
L00007388                       move.w  #$0024,$00dff066

L00007390                       lea.l   $0026(a4),a4
L00007394                       move.l  a4,$00dff050
L0000739a                       lea.l   $0026(a5),a1
L0000739e                       move.l  a1,$00dff04c
L000073a4                       lea.l   $0026(a0),a1
L000073a8                       move.l  a1,$00dff048
L000073ae                       move.l  a1,$00dff054
L000073b4                       or.w    #$0002,d6
L000073b8                       move.w  d6,$00dff058
L000073be                       move.w  $00dff002,d1
L000073c4                       btst.l  #$000e,d1
L000073c8                       bne.b   L000073be
L000073ca                       or.w    #$09f0,d5
L000073ce                       move.w  d5,$00dff040
L000073d4                       move.w  #$0026,$00dff064
L000073dc                       move.w  #$fffe,$00dff066
L000073e4                       moveq   #$02,d4
L000073e6                       lea.l   $0f00(a5),a5
L000073ea                       move.l  a5,$00dff050
L000073f0                       lea.l   $17c0(a0),a0
L000073f4                       move.l  a0,$00dff054
L000073fa                       move.w  d7,$00dff058
L00007400                       move.w  $00dff002,d1
L00007406                       btst.l  #$000e,d1
L0000740a                       bne.b   L00007400
L0000740c                       dbf.w   d4,L000073e6
L00007410                       move.w  d0,$00dff040
L00007416                       move.w  #$004c,$00dff064
L0000741e                       move.w  #$0024,$00dff066

L00007426                       lea.l   -$2cda(a5),a5
L0000742a                       moveq   #$02,d4
L0000742c                       lea.l   $0f00(a5),a5
L00007430                       move.l  a4,$00dff050
L00007436                       move.l  a5,$00dff04c
L0000743c                       lea.l   $17c0(a1),a1
L00007440                       move.l  a1,$00dff048
L00007446                       move.l  a1,$00dff054
L0000744c                       move.w  d6,$00dff058
L00007452                       move.w  $00dff002,d1
L00007458                       btst.l  #$000e,d1
L0000745c                       bne.b   L00007452
L0000745e                       dbf.w   d4,L0000742c
L00007462                       move.w  (a7)+,d6
L00007464                       beq.b   L00007496
L00007466                       subq.w  #$01,d6
L00007468                       moveq   #$00,d1
L0000746a                       move.l  d1,d2
L0000746c                       move.l  d1,d3
L0000746e                       move.l  d1,d4
L00007470                       move.l  d1,d5
L00007472                       lea.l   -$17c0(a0),a1
L00007476                       lea.l   -$17c0(a1),a2
L0000747a                       movem.l d1-d5,-(a0)
L0000747e                       movem.l d1-d5,-(a0)
L00007482                       movem.l d1-d5,-(a1)
L00007486                       movem.l d1-d5,-(a1)
L0000748a                       movem.l d1-d5,-(a2)
L0000748e                       movem.l d1-d5,-(a2)
L00007492                       dbf.w   d6,L0000747a
L00007496                       rts 


L00007498                       lea.l   $2f80(a0),a0
L0000749c                       sub.w   #$0098,d6
L000074a0                       neg.w   d6
L000074a2                       bra.b   L00007466
L000074a4                       lea.l   L0000994e,a0
L000074aa                       lea.l   L00009dce,a1
L000074b0                       moveq   #$11,d7
L000074b2                       moveq   #$00,d0
L000074b4                       move.w  (a1)+,d0
L000074b6                       swap.w  d0
L000074b8                       moveq   #$0f,d6
L000074ba                       move.l  d0,(a0)+
L000074bc                       lsr.l   #$01,d0
L000074be                       dbf.w   d6,L000074ba
L000074c2                       dbf.w   d7,L000074b2
L000074c6                       rts 


L000074c8                       move.w  L00009074,d5
L000074ce                       move.w  d5,-(a7)
L000074d0                       lea.l   L00007fc8,a5
L000074d6                       bsr.w   L000074e6
L000074da                       move.w  (a7)+,d5
L000074dc                       sub.w   #$01a9,d5
L000074e0                       lea.l   L00007bc8,a5
L000074e6                       lea.l   L00008f74,a0
L000074ec                       move.w  L00009076,d6
L000074f2                       move.b  $00(a0,d6.w),d2
L000074f6                       move.w  L00009078,d1
L000074fc                       and.b   #$e0,d1
L00007500                       lea.l   L00007920,a1
L00007506                       adda.w  d1,a1
L00007508                       bsr.w   L00007704
L0000750c                       neg.b   d0
L0000750e                       add.b   #$80,d0
L00007512                       and.w   #$00fe,d0
L00007516                       lea.l   L00007720,a2
L0000751c                       lea.l   L000090b6,a3
L00007522                       moveq   #$15,d7
L00007524                       move.w  d5,d1
L00007526                       add.b   $00(a0,d6.w),d0
L0000752a                       addq.b  #$01,d6
L0000752c                       moveq   #$00,d2
L0000752e                       move.w  $00(a2,d0.w),d4
L00007532                       sub.w   d1,d4
L00007534                       add.w   #$001e,d4
L00007538                       ext.l   d4

L0000753a                       move.b  (a1)+,d3
L0000753c                       lsl.b   #$01,d3
L0000753e                       bcc.b   L00007544
L00007540                       move.l  d4,d2
L00007542                       asl.l   #$01,d2
L00007544                       asl.b   #$01,d3
L00007546                       bcc.b   L0000754a
L00007548                       add.l   d4,d2
L0000754a                       asl.l   #$01,d2
L0000754c                       asl.b   #$01,d3
L0000754e                       bcc.b   L00007552
L00007550                       add.l   d4,d2
L00007552                       asl.l   #$01,d2
L00007554                       asl.b   #$01,d3
L00007556                       bcc.b   L0000755a
L00007558                       add.l   d4,d2
L0000755a                       asl.l   #$01,d2
L0000755c                       asl.b   #$01,d3
L0000755e                       bcc.b   L00007562
L00007560                       add.l   d4,d2
L00007562                       asl.l   #$01,d2
L00007564                       asl.b   #$01,d3
L00007566                       bcc.b   L0000756a
L00007568                       add.l   d4,d2
L0000756a                       asl.l   #$01,d2
L0000756c                       asl.b   #$01,d3
L0000756e                       bcc.b   L00007572
L00007570                       add.l   d4,d2
L00007572                       asr.l   #$01,d2
L00007574                       asr.l   #$08,d2
L00007576                       move.b  d2,(a3)+
L00007578                       add.w   d2,d1
L0000757a                       asr.w   #$08,d2
L0000757c                       move.b  d2,$0015(a3)
L00007580                       dbf.w   d7,L00007526

L00007584                       lea.l   L0000909e,a1
L0000758a                       moveq   #$14,d7
L0000758c                       moveq   #$00,d1
L0000758e                       move.w  d1,d2
L00007590                       subq.b  #$02,d2
L00007592                       add.b   (a1)+,d2
L00007594                       sub.b   (a1),d2
L00007596                       bmi.w   L00007628
L0000759a                       addq.b  #$02,d2
L0000759c                       move.b  d2,$005a(a1)
L000075a0                       sub.b   d1,d2
L000075a2                       move.b  d2,d1
L000075a4                       subq.b  #$01,d1
L000075a6                       move.b  $002d(a1),d3
L000075aa                       bpl.b   L000075ea
L000075ac                       move.b  $0017(a1),d3
L000075b0                       neg.b   d3
L000075b2                       cmp.b   d3,d2
L000075b4                       bcs.b   L000075d0
L000075b6                       move.b  d2,d4
L000075b8                       lsr.b   #$01,d4
L000075ba                       add.b   d3,d4
L000075bc                       cmp.b   d2,d4
L000075be                       bcs.b   L000075c4
L000075c0                       sub.b   d2,d4
L000075c2                       subq.w  #$01,d5
L000075c4                       move.w  d5,(a5)+
L000075c6                       dbf.w   d1,L000075ba
L000075ca                       dbf.w   d7,L0000758c
L000075ce                       rts  


L000075d0                       moveq   #$00,d4
L000075d2                       subq.w  #$01,d5
L000075d4                       add.b   d2,d4
L000075d6                       bcs.b   L000075dc
L000075d8                       cmp.b   d3,d4
L000075da                       bcs.b   L000075d2
L000075dc                       sub.b   d3,d4
L000075de                       move.w  d5,(a5)+
L000075e0                       dbf.w   d1,L000075d2
L000075e4                       dbf.w   d7,L0000758c
L000075e8                       rts 



L000075ea                       move.b  $0017(a1),d3
L000075ee                       cmp.b   d3,d2
L000075f0                       bcs.w   L0000760e
L000075f4                       move.b  d2,d4
L000075f6                       lsr.b   #$01,d4
L000075f8                       add.b   d3,d4
L000075fa                       cmp.b   d2,d4
L000075fc                       bcs.b   L00007602
L000075fe                       sub.b   d2,d4
L00007600                       addq.w  #$01,d5
L00007602                       move.w  d5,(a5)+
L00007604                       dbf.w   d1,L000075f8
L00007608                       dbf.w   d7,L0000758c
L0000760c                       rts


L0000760e                       moveq   #$00,d4
L00007610                       addq.w  #$01,d5
L00007612                       add.b   d2,d4
L00007614                       bcs.b   L0000761a
L00007616                       cmp.b   d3,d4
L00007618                       bcs.b   L00007610
L0000761a                       sub.b   d3,d4
L0000761c                       move.w  d5,(a5)+
L0000761e                       dbf.w   d1,L00007610
L00007622                       dbf.w   d7,L0000758c
L00007626                       rts


L00007628                       move.b  #$01,$005a(a1)
L0000762e                       addq.b  #$01,d2
L00007630                       beq.b   L00007634
L00007632                       addq.b  #$01,d2
L00007634                       move.w  d2,d1
L00007636                       move.b  $002d(a1),d2
L0000763a                       lsl.w   #$08,d2
L0000763c                       move.b  $0017(a1),d2
L00007640                       add.w   d2,d5
L00007642                       move.w  d5,(a5)+
L00007644                       dbf.w   d7,L0000758e
L00007648                       rts 


L0000764a                       lea.l   L00008f74,a0
L00007650                       move.w  L00009076,d6
L00007656                       add.b   #$20,d6
L0000765a                       move.b  $00(a0,d6.w),d2
L0000765e                       move.w  L00009078,d1
L00007664                       and.b   #$e0,d1
L00007668                       lea.l   L00007821,a1
L0000766e                       adda.w  d1,a1
L00007670                       bsr.w   L00007704
L00007674                       neg.b   d0
L00007676                       moveq   #$14,d7

L00007678                       lea.l   L0000909f,a2
L0000767e                       moveq   #$00,d1
L00007680                       move.w  d1,d3
L00007682                       move.b  (a1),d1
L00007684                       asl.w   #$01,d1
L00007686                       add.b   $00(a0,d6.w),d0
L0000768a                       beq.b   L00007700
L0000768c                       move.b  d0,d2
L0000768e                       bpl.b   L00007694
L00007690                       neg.w   d1
L00007692                       neg.b   d2
L00007694                       add.b   d2,d2
L00007696                       add.b   d2,d2
L00007698                       bcc.b   L0000769e
L0000769a                       move.w  d1,d3
L0000769c                       asl.w   #$01,d3
L0000769e                       asl.b   #$01,d2
L000076a0                       bcc.b   L000076a4
L000076a2                       add.w   d1,d3
L000076a4                       asl.w   #$01,d3
L000076a6                       asl.b   #$01,d2
L000076a8                       bcc.b   L000076ac
L000076aa                       add.w   d1,d3
L000076ac                       asl.w   #$01,d3
L000076ae                       asl.b   #$01,d2
L000076b0                       bcc.b   L000076b4
L000076b2                       add.w   d1,d3
L000076b4                       asl.w   #$01,d3
L000076b6                       asl.b   #$01,d2
L000076b8                       bcc.b   L000076bc
L000076ba                       add.w   d1,d3
L000076bc                       asl.w   #$01,d3
L000076be                       asl.b   #$01,d2
L000076c0                       bcc.b   L000076c4
L000076c2                       add.w   d1,d3
L000076c4                       asl.w   #$01,d3
L000076c6                       asl.b   #$01,d2
L000076c8                       bcc.b   L000076cc
L000076ca                       add.w   d1,d3
L000076cc                       asr.w   #$07,d3
L000076ce                       add.b   (a1)+,d3
L000076d0                       move.b  d3,(a2)+
L000076d2                       addq.b  #$01,d6
L000076d4                       dbf.w   d7,L0000767e

L000076d8                       move.b  #$a0,(a2)
L000076dc                       lea.l   L000090e2,a0
L000076e2                       lea.l   L0000909f,a1
L000076e8                       move.w  #$0014,d7
L000076ec                       move.b  #$60,d1
L000076f0                       move.b  (a1)+,d2
L000076f2                       cmp.b   d1,d2
L000076f4                       bpl.b   L000076f8
L000076f6                       move.b  d2,d1
L000076f8                       move.b  d1,(a0)+
L000076fa                       dbf.w   d7,L000076f0 
L000076fe                       rts  


L00007700                       move.b  d0,d3
L00007702                       bra.b   L000076ce
L00007704                       moveq   #$02,d7
L00007706                       moveq   #$00,d0
L00007708                       rol.b   #$01,d1
L0000770a                       bcc.w   L00007710
L0000770e                       add.b   d2,d0
L00007710                       asl.b   #$01,d0
L00007712                       dbf.w   d7,L00007708
L00007716                       roxr.b  #$01,d0


L00007718                       asr.b   #$03,d0
L0000771a                       moveq   #$00,d7
L0000771c                       addx.b  d7,d0
L0000771e                       rts  



L00007720       dc.w    $0000,$EC22,$F653,$F9B9,$FB6C,$FC72,$FD21,$FD9E         ;...".S...l.r.!..
L00007730       dc.w    $FDFD,$FE46,$FE81,$FEB1,$FEDA,$FEFD,$FF1A,$FF34         ;...F...........4
L00007740       dc.w    $FF4B,$FF5F,$FF71,$FF82,$FF91,$FF9E,$FFAA,$FFB6         ;.K._.q..........
L00007750       dc.w    $FFC0,$FFCA,$FFD3,$FFDC,$FFE4,$FFEC,$FFF3,$FFFA         ;................
L00007760       dc.w    $0000,$0006,$000C,$0012,$0017,$001C,$0021,$0026         ;.............!.&
L00007770       dc.w    $002A,$002F,$0033,$0037,$003C,$0040,$0043,$0047         ;.*./.3.7.<.@.C.G
L00007780       dc.w    $002B,$004F,$0052,$0056,$0059,$005D,$0060,$0063         ;.+.O.R.V.Y.].`.c
L00007790       dc.w    $0067,$006A,$006D,$0070,$0073,$0077,$007A,$007D         ;.g.j.m.p.s.w.z.}
L000077A0       dc.w    $0080,$0083,$0086,$0089,$008D,$0090,$0093,$0096         ;................
L000077B0       dc.w    $0099,$009D,$00A0,$00A3,$00A7,$00AA,$00AE,$00B1         ;................
L000077C0       dc.w    $00B5,$00B9,$00BD,$00C0,$00C4,$00C9,$00CD,$00D1         ;................
L000077D0       dc.w    $00D6,$00DA,$00DF,$00E4,$00E9,$00EE,$00F4,$00FA         ;................
L000077E0       dc.w    $0100,$0106,$010D,$0114,$011C,$0124,$012D,$0136         ;...........$.-.6
L000077F0       dc.w    $0140,$014A,$0156,$0162,$016F,$017E,$018F,$01A1         ;.@.J.V.b.o.~....
L00007800       dc.w    $01B5,$01CC,$01E6,$0203,$0226,$024F,$027F,$02BA         ;.........&.O....
L00007810       dc.w    $0303,$0362,$03DF,$048E,$0594,$0747,$0AAD,$14DE         ;...b.......G....
L00007820       dc.w    $604A,$3C32,$2B25,$211E,$1B18,$1615,$1312,$1110         ;`J<2+%!.........
L00007830       dc.w    $0F0E,$0D0C,$0B0A,$0000,$0000,$0000,$0000,$0000         ;................
L00007840       dc.w    $604C,$3D33,$2C26,$221E,$1B19,$1715,$1312,$1110         ;`L=3,&".........
L00007850       dc.w    $0F0E,$0D0C,$0B0A,$0000,$0000,$0000,$0000,$0000         ;................
L00007860       dc.w    $604F,$3F34,$2D27,$221E,$1B19,$1715,$1412,$1110         ;`O?4-'".........
L00007870       dc.w    $0F0E,$0D0C,$0B0A,$0000,$0000,$0000,$0000,$0000         ;................
L00007880       dc.w    $6051,$4135,$2D27,$231F,$1C19,$1715,$1412,$1110         ;`QA5-'#.........
L00007890       dc.w    $0F0E,$0D0C,$0B0A,$0000,$0000,$0000,$0000,$0000         ;................
L000078A0       dc.w    $6054,$4237,$2E28,$231F,$1C1A,$1716,$1413,$1110         ;`TB7.(#.........
L000078B0       dc.w    $0F0E,$0D0C,$0B0A,$0000,$0000,$0000,$0000,$0000         ;................
L000078C0       dc.w    $6057,$4438,$2F29,$2420,$1D1A,$1816,$1413,$1110         ;`WD8/)$ ........
L000078D0       dc.w    $0F0E,$0D0C,$0B0A,$0000,$0000,$0000,$0000,$0000         ;................
L000078E0       dc.w    $6059,$4639,$3029,$2420,$1D1A,$1816,$1413,$1210         ;`YF90)$ ........
L000078F0       dc.w    $0F0E,$0D0C,$0B0A,$0000,$0000,$0000,$0000,$0000         ;................
L00007900       dc.w    $605D,$483B,$312A,$2521,$1D1A,$1816,$1413,$1211         ;`]H;1*%!........
L00007910       dc.w    $100F,$0E0D,$0C0A,$0000,$0000,$0000,$0000,$0000         ;................
L00007920       dc.w    $EBC1,$AA8F,$8E6E,$5D66,$7155,$2E61,$3538,$3C40         ;.....n]fqU.a58<@
L00007930       dc.w    $4449,$4E55,$5D66,$0000,$0000,$0000,$0000,$0000         ;DINU]f..........
L00007940       dc.w    $D5CA,$A78C,$8B6B,$7866,$4B51,$5961,$3538,$3C40         ;.....kxfKQYa58<@
L00007950       dc.w    $4449,$4E55,$5D66,$0000,$0000,$0000,$0000,$0000         ;DINU]f..........
L00007960       dc.w    $B5CF,$B389,$8883,$7866,$4B51,$5930,$6638,$3C40         ;......xfKQY0f8<@
L00007970       dc.w    $4449,$4E55,$5D66,$0000,$0000,$0000,$0000,$0000         ;DINU]f..........
L00007980       dc.w    $A0CA,$BD9A,$8869,$7563,$6D51,$5930,$6638,$3C40         ;.....iucmQY0f8<@
L00007990       dc.w    $4449,$4E55,$5D66,$0000,$0000,$0000,$0000,$0000         ;DINU]f..........
L000079A0       dc.w    $80DB,$AAA7,$8580,$7563,$4976,$2C5D,$336B,$3C40         ;......ucIv,]3k<@
L000079B0       dc.w    $4449,$4E55,$5D66,$0000,$0000,$0000,$0000,$0000         ;DINU]f..........
L000079C0       dc.w    $60DF,$B5A4,$827C,$7160,$694E,$555D,$336B,$3C40         ;`....|q`iNU]3k<@
L000079D0       dc.w    $4449,$4E55,$5D66,$0000,$0000,$0000,$0000,$0000         ;DINU]f..........
L000079E0       dc.w    $4BDB,$BEA1,$957C,$7160,$694E,$555D,$3335,$7140         ;K....|q`iNU]35q@
L000079F0       dc.w    $4449,$4E55,$5D66,$0000,$0000,$0000,$0000,$0000         ;DINU]f..........
L00007A00       dc.w    $20E7,$B9AD,$9279,$6E7C,$694E,$555D,$3335,$383C         ; ....yn|iNU]358<
L00007A10       dc.w    $4044,$494E,$555D,$0000,$0000,$0000,$0000,$0000         ;@DINU]..........
L00007A20       dc.w    $5343,$3830,$2924,$211D,$1A18,$1614,$1312,$100F         ;SC80)$!.........
L00007A30       dc.w    $0E0D,$0B0A,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007A40       dc.w    $5644,$3931,$2A25,$211D,$1B19,$1614,$1312,$100F         ;VD91*%!.........
L00007A50       dc.w    $0E0D,$0B0A,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007A60       dc.w    $5947,$3A32,$2B26,$211D,$1B19,$1615,$1312,$100F         ;YG:2+&!.........
L00007A70       dc.w    $0E0D,$0B0A,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007A80       dc.w    $5B49,$3B32,$2B26,$221E,$1B18,$1615,$1311,$100F         ;[I;2+&".........
L00007A90       dc.w    $0E0C,$0B0A,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007AA0       dc.w    $5F4A,$3E33,$2C27,$221E,$1C19,$1715,$1412,$100F         ;_J>3,'".........
L00007AB0       dc.w    $0E0D,$0B0A,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007AC0       dc.w    $624D,$3F34,$2D28,$2320,$1C1A,$1715,$1412,$100F         ;bM?4-(# ........
L00007AD0       dc.w    $0E0D,$0B0A,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007AE0       dc.w    $644F,$4036,$2E28,$2320,$1C1A,$1715,$1413,$100F         ;dO@6.(# ........
L00007AF0       dc.w    $0E0D,$0B0A,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007B00       dc.w    $6951,$4237,$2F29,$241F,$1C1A,$1715,$1413,$1110         ;iQB7/)$.........
L00007B10       dc.w    $0F0E,$0C0C,$0000,$0000,$0000,$0000,$0000,$0000         ;................





L00007b20                       moveq   #$08,d7
L00007b22                       lea.l   $0090(a1),a2
L00007b26                       move.w  d7,-(a7)
L00007b28                       move.w  (a0)+,d0
L00007b2a                       move.w  d0,(a1)+
L00007b2c                       move.w  (a0)+,(a1)+
L00007b2e                       move.w  (a0)+,d1
L00007b30                       move.w  d1,(a1)+
L00007b32                       move.w  (a0)+,d7
L00007b34                       move.w  d7,(a1)+
L00007b36                       move.l  (a0)+,d2
L00007b38                       move.l  d2,(a1)+
L00007b3a                       move.l  (a0)+,(a1)+
L00007b3c                       lea.l   -$08(a0,d2.w),a3                ; $f8
L00007b40                       and.w   #$000f,d0
L00007b44                       neg.w   d0
L00007b46                       beq.b   L00007b4e 
L00007b48                       add.w   #$000f,d0
L00007b4c                       addq.w  #$01,d0
L00007b4e                       mulu.w  #$0005,d7
L00007b52                       subq.w  #$01,d7
L00007b54                       move.w  d1,d5
L00007b56                       lsr.w   #$01,d5
L00007b58                       subq.w  #$01,d5
L00007b5a                       lea.l   $00(a2,d1.w),a2
L00007b5e                       move.w  d5,d6
L00007b60                       moveq   #$00,d2
L00007b62                       move.w  (a3)+,d3
L00007b64                       moveq   #$00,d4
L00007b66                       lsr.w   #$01,d3
L00007b68                       roxl.w  #$01,d4
L00007b6a                       lsr.w   #$01,d3
L00007b6c                       roxl.w  #$01,d4
L00007b6e                       lsr.w   #$01,d3
L00007b70                       roxl.w  #$01,d4
L00007b72                       lsr.w   #$01,d3
L00007b74                       roxl.w  #$01,d4
L00007b76                       lsr.w   #$01,d3
L00007b78                       roxl.w  #$01,d4
L00007b7a                       lsr.w   #$01,d3
L00007b7c                       roxl.w  #$01,d4
L00007b7e                       lsr.w   #$01,d3
L00007b80                       roxl.w  #$01,d4
L00007b82                       lsr.w   #$01,d3
L00007b84                       roxl.w  #$01,d4
L00007b86                       lsr.w   #$01,d3
L00007b88                       roxl.w  #$01,d4
L00007b8a                       lsr.w   #$01,d3
L00007b8c                       roxl.w  #$01,d4
L00007b8e                       lsr.w   #$01,d3
L00007b90                       roxl.w  #$01,d4
L00007b92                       lsr.w   #$01,d3
L00007b94                       roxl.w  #$01,d4
L00007b96                       lsr.w   #$01,d3
L00007b98                       roxl.w  #$01,d4
L00007b9a                       lsr.w   #$01,d3
L00007b9c                       roxl.w  #$01,d4
L00007b9e                       lsr.w   #$01,d3
L00007ba0                       roxl.w  #$01,d4
L00007ba2                       lsr.w   #$01,d3
L00007ba4                       roxl.w  #$01,d4
L00007ba6                       tst.w   d0
L00007ba8                       beq.b   L00007bae
L00007baa                       lsl.l   d0,d4
L00007bac                       or.w    d2,d4
L00007bae                       move.w  d4,-(a2)
L00007bb0                       swap.w  d4
L00007bb2                       move.w  d4,d2
L00007bb4                       dbf.w   d6,L00007b62
L00007bb8                       lea.l   $00(a2,d1.w),a2
L00007bbc                       dbf.w   d7,L00007b5a
L00007bc0                       move.w  (a7)+,d7
L00007bc2                       dbf.w  d7,L00007b26
L00007bc6                       rts  



L00007BC8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007BD8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007BE8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007BF8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007C08       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007C18       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007C28       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007C38       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007C48       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007C58       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007C68       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007C78       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007C88       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007C98       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007CA8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007CB8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007CC8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007CD8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007CE8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007CF8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007D08       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007D18       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007D28       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007D38       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007D48       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007D58       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007D68       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007D78       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007D88       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007D98       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007DA8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007DB8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007DC8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007DD8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007DE8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007DF8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007E08       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007E18       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007E28       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007E38       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007E48       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007E58       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007E68       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007E78       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007E88       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007E98       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007EA8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007EB8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007EC8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007ED8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007EE8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007EF8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007F08       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007F18       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007F28       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007F38       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007F48       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007F58       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007F68       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007F78       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007F88       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007F98       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007FA8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007FB8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007FC8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007FD8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007FE8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00007FF8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008008       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008018       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008028       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008038       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008048       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008058       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008068       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008078       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008088       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008098       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000080A8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000080B8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000080C8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000080D8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000080E8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000080F8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008108       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008118       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008128       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008138       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008148       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................





L00008158                       lea.l   L00008272,a5
L0000815e                       lea.l   L00008288,a0
L00008164                       lea.l   L000085a8,a1
L0000816a                       lea.l   L00008642,a2
L00008170                       lea.l   L00008662,a3
L00008176                       lea.l   L00008732,a4
L0000817c                       move.w  (a5)+,d7
L0000817e                       bmi.b   L000081cc
L00008180                       bsr.w   L0000421a
L00008184                       and.w   #$000f,d0
L00008188                       mulu.w  #$0006,d0
L0000818c                       lea.l   $00(a1,d0.w),a6
L00008190                       move.l  a6,(a0)+
L00008192                       bsr.w   L0000421a
L00008196                       and.w   #$0007,d0
L0000819a                       lsl.w   #$02,d0
L0000819c                       move.l  $00(a2,d0.w),(a0)+
L000081a0                       bsr.w   L0000421a
L000081a4                       and.w   #$0007,d0
L000081a8                       mulu.w  #$001a,d0
L000081ac                       lea.l   $00(a3,d0.w),a6
L000081b0                       move.l  a6,(a0)+
L000081b2                       and.w   #$0007,d0
L000081b6                       mulu.w  #$001a,d0
L000081ba                       lea.l   $00(a3,d0.w),a6
L000081be                       move.l  a6,(a0)+
L000081c0                       move.l  a4,(a0)+
L000081c2                       dbf.w   d7,L00008180
L000081c6                       lea.l   $0014(a0),a0
L000081ca                       bra.b   L0000817c
L000081cc                       rts  

L000081ce                       lea.l   L00008838,a0
L000081d4                       lea.l   L00008a34,a1
L000081da                       lea.l   L00008ace,a2
L000081e0                       lea.l   L00008aee,a3
L000081e6                       lea.l   L00008732,a4
L000081ec                       moveq   #$18,d7
L000081ee                       bsr.w   L0000421a
L000081f2                       and.w   #$000f,d0
L000081f6                       mulu.w  #$0006,d0
L000081fa                       lea.l   $00(a1,d0.w),a6
L000081fe                       move.l  a6,(a0)+
L00008200                       bsr.w   L0000421a
L00008204                       and.w   #$0007,d0
L00008208                       lsl.w   #$02,d0
L0000820a                       move.l  $00(a2,d0.w),(a0)+
L0000820e                       bsr.w   L0000421a
L00008212                       and.w   #$0007,d0
L00008216                       mulu.w  #$001a,d0
L0000821a                       lea.l   $00(a3,d0.w),a6
L0000821e                       move.l  a6,(a0)+
L00008220                       and.w   #$0007,d0
L00008224                       mulu.w  #$001a,d0
L00008228                       lea.l   $00(a3,d0.w),a6
L0000822c                       move.l  a6,(a0)+
L0000822e                       move.l  a4,(a0)+
L00008230                       dbf.w   d7,L000081ee
L00008234                       rts 


; end of program data? no idea what is contains yet.
L00008236       dc.w    $0000,$8288,$0000,$8300,$0000,$8350,$0000,$83B4         ;...........P....
L00008246       dc.w    $0000,$8440,$0000,$847C,$0000,$84B8,$0000,$8530         ;...@...|.......0
L00008256       dc.w    $0000,$8558,$0000,$8580,$0000,$0000,$0000,$8236         ;...X...........6
L00008266       dc.w    $0000,$8838,$0000,$0000,$0000,$8266,$0004,$0002         ;...8.......f....
L00008276       dc.w    $0003,$0005,$0001,$0001,$0004,$0000,$0000,$0000         ;................
L00008286       dc.w    $FFFF,$C000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008296       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000082A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000082B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000082C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000082D6       dc.w    $0003,$C000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000082E6       dc.w    $0000,$0000,$0000,$0000,$8824,$0000,$8810,$0000         ;.........$......
L000082F6       dc.w    $87D6,$0000,$878A,$0000,$8736,$0000,$0000,$0000         ;.........6......
L00008306       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008316       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008326       dc.w    $0003,$C000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008336       dc.w    $0000,$0000,$0000,$0000,$8824,$0000,$8810,$0000         ;.........$......
L00008346       dc.w    $878A,$0000,$87D6,$0000,$8760,$0000,$0000,$0000         ;.........`......
L00008356       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008366       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008376       dc.w    $0003,$C000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008386       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008396       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$8824,$0000         ;.............$..
L000083A6       dc.w    $8810,$0000,$87D6,$0000,$878A,$0000,$8736,$0000         ;.............6..
L000083B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000083C6       dc.w    $0003,$C000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000083D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000083E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000083F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008406       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008416       dc.w    $0003,$C000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008426       dc.w    $0000,$0000,$0000,$0000,$8824,$0000,$8810,$0000         ;.........$......
L00008436       dc.w    $87D6,$0000,$878A,$0000,$8736,$0000,$0000,$0000         ;.........6......
L00008446       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008456       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008466       dc.w    $0003,$0000,$8824,$0000,$8810,$0000,$878A,$0000         ;.....$..........
L00008476       dc.w    $87D6,$0000,$8760,$0000,$0000,$0000,$0000,$0000         ;.....`..........
L00008486       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008496       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000084A6       dc.w    $8824,$0000,$8810,$0000,$87D6,$0000,$878A,$0000         ;.$..............
L000084B6       dc.w    $8736,$C000,$0000,$0000,$0000,$0000,$0000,$0000         ;.6..............
L000084C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000084D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000084E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000084F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008506       dc.w    $0003,$C000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008516       dc.w    $0000,$0000,$0000,$0000,$8824,$0000,$8810,$0000         ;.........$......
L00008526       dc.w    $878A,$0000,$87D6,$0000,$8760,$0000,$0000,$0000         ;.........`......
L00008536       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008546       dc.w    $8824,$0000,$8810,$0000,$878A,$0000,$87D6,$0000         ;.$..............
L00008556       dc.w    $8760,$C000,$0000,$0000,$0000,$0000,$0000,$0000         ;.`..............
L00008566       dc.w    $0000,$0000,$0000,$0000,$8824,$0000,$8810,$0000         ;.........$......
L00008576       dc.w    $87D6,$0000,$878A,$0000,$8736,$0000,$0000,$0000         ;.........6......
L00008586       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008596       dc.w    $8824,$0000,$8810,$0000,$878A,$0000,$87D6,$0000         ;.$..............
L000085A6       dc.w    $8760,$F0F0,$F050,$0000,$F0F1,$F150,$0000,$F1F2         ;.`...P.....P....
L000085B6       dc.w    $F150,$0000,$F0F9,$F950,$0000,$F9FA,$F950,$0000         ;.P.....P.....P..
L000085C6       dc.w    $F0F0,$F059,$0000,$F1F2,$F151,$0000,$F0F0,$F050         ;...Y.....Q.....P
L000085D6       dc.w    $0000,$F1F0,$F950,$0000,$F0F0,$F051,$0000,$F0F9         ;.....P.....Q....
L000085E6       dc.w    $FA5A,$0000,$F9F9,$F151,$0000,$F0F0,$F050,$0000         ;.Z.....Q.....P..
L000085F6       dc.w    $F1F1,$F050,$0000,$F0F0,$F150,$0000,$F0F0,$F959         ;...P.....P.....Y
L00008606       dc.w    $0000,$F8F8,$F858,$0000,$3847,$3625,$2425,$3647         ;.....X..8G6%$%6G
L00008616       dc.w    $4849,$3A2B,$2C2B,$3A49,$3800,$F827,$2635,$4441         ;HI:+,+:I8..'&5DA
L00008626       dc.w    $184F,$4C3B,$2A29,$3800,$E827,$2523,$2527,$2829         ;.OL;*)8..'%#%'()
L00008636       dc.w    $2B2D,$2B29,$E800,$A4F6,$FAAC,$0000,$0000,$8608         ;+-+)............
L00008646       dc.w    $0000,$860E,$0000,$8608,$0000,$8620,$0000,$862E         ;........... ....
L00008656       dc.w    $0000,$863C,$0000,$8608,$0000,$860E,$1210,$1010         ;...<............
L00008666       dc.w    $1210,$1218,$1210,$1618,$1618,$1210,$1610,$1216         ;................
L00008676       dc.w    $1010,$1216,$1200,$1012,$1018,$1016,$1016,$1016         ;................
L00008686       dc.w    $1216,$1216,$1010,$1210,$1216,$1010,$1016,$1200         ;................
L00008696       dc.w    $1019,$1019,$1014,$1014,$1614,$1610,$1610,$1610         ;................
L000086A6       dc.w    $1810,$1610,$1610,$1610,$1000,$1810,$1210,$1410         ;................
L000086B6       dc.w    $1210,$1410,$1610,$1010,$1610,$1610,$1410,$1410         ;................
L000086C6       dc.w    $1610,$1000,$1210,$1210,$1010,$1210,$1012,$1012         ;................
L000086D6       dc.w    $1010,$1910,$1910,$1916,$1910,$1610,$1000,$1610         ;................
L000086E6       dc.w    $1610,$1010,$1810,$1010,$1018,$1010,$1410,$1410         ;................
L000086F6       dc.w    $1810,$1410,$1410,$1000,$1210,$1210,$1216,$1216         ;................
L00008706       dc.w    $1216,$1016,$1016,$1016,$1016,$1010,$1610,$1010         ;................
L00008716       dc.w    $1000,$1812,$1618,$1012,$1014,$1012,$1014,$1014         ;................
L00008726       dc.w    $1014,$1016,$1016,$1010,$1910,$1000,$32C0,$0000         ;............2...
L00008736       dc.w    $0140,$2300,$0107,$0309,$0105,$0900,$0140,$1700         ;.@#..........@..
L00008746       dc.w    $0107,$0309,$0105,$0900,$0140,$1700,$0107,$0309         ;.........@......
L00008756       dc.w    $0105,$0900,$0800,$0120,$FF00,$0180,$2300,$0106         ;....... ....#...
L00008766       dc.w    $030A,$0104,$0900,$0180,$1700,$0106,$030A,$0104         ;................
L00008776       dc.w    $0900,$0180,$1700,$0106,$030A,$0104,$0900,$0800         ;................
L00008786       dc.w    $0120,$FF00,$1019,$1019,$1019,$1019,$1019,$1019         ;. ..............
L00008796       dc.w    $1017,$1017,$1011,$2012,$1019,$1019,$1012,$1014         ;...... .........
L000087A6       dc.w    $1014,$1017,$1017,$1011,$2012,$1019,$1019,$1010         ;........ .......
L000087B6       dc.w    $1014,$1014,$1017,$1017,$1011,$2019,$1014,$1014         ;.......... .....
L000087C6       dc.w    $1016,$1016,$1016,$1016,$1016,$1016,$F0F0,$F000         ;................
L000087D6       dc.w    $1019,$1019,$1019,$1019,$1A19,$1019,$1A19,$1A19         ;................
L000087E6       dc.w    $1A19,$1019,$1A19,$1019,$1A19,$1019,$1A19,$1019         ;................
L000087F6       dc.w    $1019,$1019,$1019,$1A19,$1019,$1019,$1A19,$1A19         ;................
L00008806       dc.w    $1019,$1A19,$1019,$F0F0,$F000,$F8F8,$F8F8,$F8F8         ;................
L00008816       dc.w    $F8F8,$F8F8,$F8F8,$F8F8,$F8F8,$F8F8,$F8F8,$F0F0         ;................
L00008826       dc.w    $F0F0,$F0F0,$F0F0,$F0F0,$F0F0,$F0F0,$F0F0,$F0F0         ;................
L00008836       dc.w    $F0F0,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008846       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008856       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008866       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008876       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008886       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008896       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000088A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000088B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000088C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000088D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000088E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000088F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008906       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008916       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008926       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008936       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008946       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008956       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008966       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008976       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008986       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008996       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000089A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000089B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000089C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000089D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000089E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000089F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008A06       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008A16       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008A26       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$8838,$F0F0         ;.............8..
L00008A36       dc.w    $F050,$0000,$F0F1,$F150,$0000,$F1F2,$F150,$0000         ;.P.....P.....P..
L00008A46       dc.w    $F0F9,$F950,$0000,$F9FA,$F950,$0000,$F0F0,$F059         ;...P.....P.....Y
L00008A56       dc.w    $0000,$F1F2,$F151,$0000,$F0F0,$F050,$0000,$F1F0         ;.....Q.....P....
L00008A66       dc.w    $F950,$0000,$F0F0,$F051,$0000,$F0F9,$FA5A,$0000         ;.P.....Q.....Z..
L00008A76       dc.w    $F9F9,$F151,$0000,$F0F0,$F050,$0000,$F1F1,$F050         ;...Q.....P.....P
L00008A86       dc.w    $0000,$F0F0,$F150,$0000,$F0F0,$F959,$0000,$F8F8         ;.....P.....Y....
L00008A96       dc.w    $F858,$0000,$3847,$3625,$2425,$3647,$4849,$3A2B         ;.X..8G6%$%6GHI:+
L00008AA6       dc.w    $2C2B,$3A49,$3800,$F827,$2635,$4441,$184F,$4C3B         ;,+:I8..'&5DA.OL;
L00008AB6       dc.w    $2A29,$3800,$E827,$2523,$2527,$2829,$2B2D,$2B29         ;*)8..'%#%'()+-+)
L00008AC6       dc.w    $E800,$A4F6,$FAAC,$0000,$0000,$8A94,$0000,$8A9A         ;................
L00008AD6       dc.w    $0000,$8A94,$0000,$8AAC,$0000,$8ABA,$0000,$8AC8         ;................
L00008AE6       dc.w    $0000,$8A94,$0000,$8A9A,$1B10,$1B10,$1B10,$1B10         ;................
L00008AF6       dc.w    $1B10,$1B10,$1B10,$1B10,$1B10,$1B10,$1B10,$1B10         ;................
L00008B06       dc.w    $1000,$1915,$1910,$1915,$1915,$1910,$1915,$1615         ;................
L00008B16       dc.w    $1015,$1615,$1016,$1010,$1610,$1000,$1810,$1310         ;................
L00008B26       dc.w    $1318,$1310,$1010,$1310,$1310,$1310,$1910,$1910         ;................
L00008B36       dc.w    $1910,$1910,$1900,$1010,$1013,$1010,$1013,$1013         ;................
L00008B46       dc.w    $1013,$1013,$1613,$1610,$1610,$1618,$1610,$1000         ;................
L00008B56       dc.w    $1110,$1810,$1110,$1110,$1110,$1110,$1110,$1010         ;................
L00008B66       dc.w    $1110,$1011,$1010,$1110,$1000,$101B,$1013,$1013         ;................
L00008B76       dc.w    $1013,$101B,$1018,$1B10,$1B10,$1B16,$1316,$1013         ;................
L00008B86       dc.w    $1013,$1000,$1110,$1110,$1810,$1010,$1010,$1010         ;................
L00008B96       dc.w    $1010,$1010,$1010,$1010,$1810,$1010,$1000,$1016         ;................
L00008BA6       dc.w    $1016,$1016,$1018,$101B,$101B,$101B,$181B,$101B         ;................
L00008BB6       dc.w    $101B,$101B,$101B,$1000,$0002,$8800,$0000,$0004         ;................
L00008BC6       dc.w    $0010,$005E,$0000,$0000,$0003,$DEC0,$0101,$0018         ;...^............
L00008BD6       dc.w    $0058,$0098,$0000,$0000,$0004,$4646,$0101,$0000         ;.X........FF....
L00008BE6       dc.w    $0070,$0098,$0000,$0000,$0003,$DEC0,$0201,$0018         ;.p..............
L00008BF6       dc.w    $0058,$0098,$0000,$0000,$0004,$4646,$0201,$0000         ;.X........FF....
L00008C06       dc.w    $0070,$0098,$0000,$0000,$0002,$8800,$0102,$0004         ;.p..............
L00008C16       dc.w    $0010,$005E,$0000,$0000,$0002,$5500,$0102,$0004         ;...^......U.....
L00008C26       dc.w    $000F,$0038,$0000,$0000,$0002,$6044,$0102,$0002         ;...8......`D....
L00008C36       dc.w    $0012,$0019,$0000,$0000,$0002,$6534,$0102,$0002         ;..........e4....
L00008C46       dc.w    $0006,$0028,$0000,$0000,$0004,$5C28,$0301,$0000         ;...(......\(....
L00008C56       dc.w    $0058,$0098,$0000,$0000,$0004,$4646,$0102,$0000         ;.X........FF....
L00008C66       dc.w    $0070,$0098,$0000,$0000,$0002,$6BE6,$0001,$0004         ;.p........k.....
L00008C76       dc.w    $0010,$005E,$002C,$0000,$0004,$5C28,$0101,$0000         ;...^.,....\(....
L00008C86       dc.w    $0058,$0098,$0070,$0000,$0004,$C3FE,$0101,$0000         ;.X...p..........
L00008C96       dc.w    $0070,$0098,$0070,$0000,$0004,$5C28,$0201,$0000         ;.p...p....\(....
L00008CA6       dc.w    $0058,$0098,$0070,$0000,$0004,$C3FE,$0201,$0000         ;.X...p..........
L00008CB6       dc.w    $0070,$0098,$0070,$0000,$0002,$6BE6,$0102,$0004         ;.p...p....k.....
L00008CC6       dc.w    $0010,$005E,$002C,$0000,$0002,$5500,$0102,$0004         ;...^.,....U.....
L00008CD6       dc.w    $000F,$0038,$0038,$0000,$0002,$6044,$0102,$0002         ;...8.8....`D....
L00008CE6       dc.w    $0012,$0019,$0019,$0000,$0002,$6534,$0102,$0002         ;..........e4....
L00008CF6       dc.w    $0006,$0028,$0028,$0000,$0004,$5C28,$0301,$0000         ;...(.(....\(....
L00008D06       dc.w    $0058,$0098,$0070,$0000,$0004,$C3FE,$0102,$0000         ;.X...p..........
L00008D16       dc.w    $0070,$0098,$0070,$0000
L00008d1e       dc.w    $0000,$0001,$0000,$0000         ;.p...p..........
L00008D26       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008D36       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008D46       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008D56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008D66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008D76       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008D86       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008D96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008DA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008DB6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008DC6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008DD6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008DE6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008DF6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008E06       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008E16       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008E26       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008E36       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008E46       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008E56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008E66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008E76       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008E86       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008E96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008EA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008EB6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008EC6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008ED6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008EE6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008EF6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008F06       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008F16       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008F26       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008F36       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008F46       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008F56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008F66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008F76       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008F86       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008F96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008FA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008FB6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008FC6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008FD6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008FE6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00008FF6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009006       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009016       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009026       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009036       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009046       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009056       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009066       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009076       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009086       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009096       dc.w    $0000,$0000,$0000,$0000,$6000,$0000,$0000,$0000         ;........`.......
L000090A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000090B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000090C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000090D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000090E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000090F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009106       dc.w    $0000,$0000,$0000,$0000,$CF30,$3000,$00C7,$3038         ;.........00...08
L00009116       dc.w    $0800,$C730,$3808,$00C7,$3038,$0800,$C730,$3808         ;...08...08...08.
L00009126       dc.w    $00E7,$0018,$1800,$CF30,$3000,$00E7,$0018,$1800         ;.......00.......
L00009136       dc.w    $F30C,$0C00,$00E1,$181E,$0600,$E318,$1C04,$00E3         ;................
L00009146       dc.w    $181C,$0400,$E318,$1C04,$00E3,$181C,$0400,$F30C         ;................
L00009156       dc.w    $0C00,$00F9,$0006,$0600,$9F60,$6000,$00CF,$3030         ;.........``...00
L00009166       dc.w    $0000,$C730,$3808,$00C7,$3038,$0800,$C730,$3808         ;...08...08...08.
L00009176       dc.w    $00C7,$3038,$0800,$8760,$7818,$00CF,$0030,$3000         ;..08...`x....00.
L00009186       dc.w    $FF00,$0000,$00FF,$0000,$0000,$FF00,$0000,$00FF         ;................
L00009196       dc.w    $0000,$0000,$FF00,$0000,$009F,$6060,$0000,$8F60         ;..........``...`
L000091A6       dc.w    $7010,$00CF,$0030,$3000,$837C,$7C00,$0001,$C6FE         ;p....00..||.....
L000091B6       dc.w    $3800,$10CE,$EF21,$0000,$D6FF,$2900,$08E6,$F711         ;8....!....).....
L000091C6       dc.w    $0018,$C6E7,$2100,$807C,$7F03,$00C1,$003E,$3E00         ;....!..|.....>>.
L000091D6       dc.w    $C738,$3800,$00C3,$383C,$0400,$E318,$1C04,$00E3         ;.88...8<........
L000091E6       dc.w    $181C,$0400,$E318,$1C04,$00E3,$181C,$0400,$E318         ;................
L000091F6       dc.w    $1C04,$00F3,$000C,$0C00,$837C,$7C00,$0001,$C6FE         ;.........||.....
L00009206       dc.w    $3800,$900C,$6F63,$00E1,$181E,$0600,$C330,$3C0C         ;8...oc.......0<.
L00009216       dc.w    $0087,$6078,$1800,$00FE,$FF01,$0080,$007F,$7F00         ;..`x............
L00009226       dc.w    $837C,$7C00,$0001,$C6FE,$3800,$9806,$6761,$00C0         ;.||.....8...ga..
L00009236       dc.w    $3C3F,$0300,$E106,$1E18,$0038,$C6C7,$0100,$807C         ;<?.......8.....|
L00009246       dc.w    $7F03,$00C1,$003E,$3E00,$E31C,$1C00,$00C1,$3C3E         ;.....>>.......<>
L00009256       dc.w    $0200,$816C,$7E12,$0001,$CCFE,$3200,$01FE,$FE00         ;...l~.....2.....
L00009266       dc.w    $0080,$0C7F,$7300,$F10C,$0E02,$00F9,$0006,$0600         ;....s...........
L00009276       dc.w    $00FE,$FF00,$0000,$C0FF,$3F00,$1FC0,$E020,$0003         ;........?.... ..
L00009286       dc.w    $FCFC,$0000,$8006,$7F79,$0038,$C6C7,$0100,$807C         ;.......y.8.....|
L00009296       dc.w    $7F03,$00C1,$003E,$3E00,$837C,$7C00,$0001,$C6FE         ;.....>>..||.....
L000092A6       dc.w    $3800,$1CC0,$E323,$0003,$FCFC,$0000,$01C6,$FE38         ;8....#.........8
L000092B6       dc.w    $0018,$C6E7,$2100,$807C,$7F03,$00C1,$003E,$3E00         ;....!..|.....>>.
L000092C6       dc.w    $01FE,$FE00,$0080,$067F,$7900,$F00C,$0F03,$00E1         ;........y.......
L000092D6       dc.w    $181E,$0600,$E318,$1C04,$00C7,$3038,$0800,$C730         ;..........08...0
L000092E6       dc.w    $3808,$00E7,$0018,$1800,$837C,$7C00,$0001,$C6FE         ;8........||.....
L000092F6       dc.w    $3800,$18C6,$E721,$0080,$7C7F,$0300,$01C6,$FE38         ;8....!..|......8
L00009306       dc.w    $0018,$C6E7,$2100,$807C,$7F03,$00C1,$003E,$3E00         ;....!..|.....>>.
L00009316       dc.w    $837C,$7C00,$0001,$C6FE,$3800,$18C6,$E721,$0080         ;.||.....8....!..
L00009326       dc.w    $7E7F,$0100,$C006,$3F39,$0038,$C6C7,$0100,$807C         ;~.....?9.8.....|
L00009336       dc.w    $7F03,$00C1,$003E,$3E00,$EF10,$1000,$00C7,$3838         ;.....>>.......88
L00009346       dc.w    $0000,$C338,$3C04,$0083,$6C7C,$1000,$817C,$7E02         ;...8<...l|...|~.
L00009356       dc.w    $0001,$C6FE,$3800,$18C6,$E721,$009C,$0063,$6300         ;....8....!...cc.
L00009366       dc.w    $03FC,$FC00,$0001,$C6FE,$3800,$18C6,$E721,$0000         ;........8....!..
L00009376       dc.w    $FCFF,$0300,$01C6,$FE38,$0018,$C6E7,$2100,$00FC         ;.......8....!...
L00009386       dc.w    $FF03,$0081,$007E,$7E00,$837C,$7C00,$0001,$C6FE         ;.....~~..||.....
L00009396       dc.w    $3800,$1CC0,$E323,$001F,$C0E0,$2000,$1FC0,$E020         ;8....#.... ....
L000093A6       dc.w    $0019,$C6E6,$2000,$807C,$7F03,$00C1,$003E,$3E00         ;.... ..|.....>>.
L000093B6       dc.w    $07F8,$F800,$0003,$CCFC,$3000,$19C6,$E620,$0018         ;........0.... ..
L000093C6       dc.w    $C6E7,$2100,$18C6,$E721,$0010,$CCEF,$2300,$01F8         ;..!....!....#...
L000093D6       dc.w    $FE06,$0083,$007C,$7C00,$01FE,$FE00,$0000,$C0FF         ;.....||.........
L000093E6       dc.w    $3F00,$1FC0,$E020,$0007,$F8F8,$0000,$03C0,$FC3C         ;?.... .........<
L000093F6       dc.w    $001F,$C0E0,$2000,$01FE,$FE00,$0080,$007F,$7F00         ;.... ...........
L00009406       dc.w    $01FE,$FE00,$0000,$C0FF,$3F00,$1FC0,$E020,$0007         ;........?.... ..
L00009416       dc.w    $F8F8,$0000,$03C0,$FC3C,$001F,$C0E0,$2000,$1FC0         ;.......<.... ...
L00009426       dc.w    $E020,$009F,$0060,$6000,$837C,$7C00,$0001,$C6FE         ;. ...``..||.....
L00009436       dc.w    $3800,$1CC0,$E323,$0001,$DEFE,$2000,$10C6,$EF29         ;8....#.... ....)
L00009446       dc.w    $0018,$C6E7,$2100,$807E,$7F01,$00C0,$003F,$3F00         ;....!..~.....??.
L00009456       dc.w    $39C6,$C600,$0018,$C6E7,$2100,$18C6,$E721,$0000         ;9.......!....!..
L00009466       dc.w    $FEFF,$0100,$00C6,$FF39,$0018,$C6E7,$2100,$18C6         ;.......9....!...
L00009476       dc.w    $E721,$009C,$0063,$6300,$8778,$7800,$00C3,$303C         ;.!...cc..xx...0<
L00009486       dc.w    $0C00,$C730,$3808,$00C7,$3038,$0800,$C730,$3808         ;...08...08...08.
L00009496       dc.w    $00C7,$3038,$0800,$8778,$7800,$00C3,$003C,$3C00         ;..08...xx....<<.
L000094A6       dc.w    $F906,$0600,$00F8,$0607,$0100,$F806,$0701,$00F8         ;................
L000094B6       dc.w    $0607,$0100,$38C6,$C701,$0018,$C6E7,$2100,$807C         ;....8.......!..|
L000094C6       dc.w    $7F03,$00C1,$003E,$3E00,$39C6,$C600,$0010,$CCEF         ;.....>>.9.......
L000094D6       dc.w    $2300,$01D8,$FE26,$0003,$F0FC,$0C00,$07D8,$F820         ;#....&.........
L000094E6       dc.w    $0013,$CCEC,$2000,$19C6,$E620,$009C,$0063,$6300         ;.... .... ...cc.
L000094F6       dc.w    $3FC0,$C000,$001F,$C0E0,$2000,$1FC0,$E020,$001F         ;?....... .... ..
L00009506       dc.w    $C0E0,$2000,$1FC0,$E020,$0019,$C6E6,$2000,$00FE         ;.. .... .... ...
L00009516       dc.w    $FF01,$0080,$007F,$7F00,$39C6,$C600,$0010,$EEEF         ;........9.......
L00009526       dc.w    $0100,$00FE,$FF01,$0000,$D6FF,$2900,$10C6,$EF29         ;..........)....)
L00009536       dc.w    $0018,$C6E7,$2100,$18C6,$E721,$009C,$0063,$6300         ;....!....!...cc.
L00009546       dc.w    $39C6,$C600,$0018,$E6E7,$0100,$08F6,$F701,$0000         ;9...............
L00009556       dc.w    $DEFF,$2100,$10CE,$EF21,$0018,$C6E7,$2100,$18C6         ;..!....!....!...
L00009566       dc.w    $E721,$009C,$0063,$6300,$837C,$7C00,$0001,$C6FE         ;.!...cc..||.....
L00009576       dc.w    $3800,$18C6,$E721,$0018,$C6E7,$2100,$18C6,$E721         ;8....!....!....!
L00009586       dc.w    $0018,$C6E7,$2100,$807C,$7F03,$00C1,$003E,$3E00         ;....!..|.....>>.
L00009596       dc.w    $03FC,$FC00,$0001,$C6FE,$3800,$18C6,$E721,$0000         ;........8....!..
L000095A6       dc.w    $FCFF,$0300,$01C0,$FE3E,$001F,$C0E0,$2000,$1FC0         ;.......>.... ...
L000095B6       dc.w    $E020,$009F,$0060,$6000,$837C,$7C00,$0001,$C6FE         ;. ...``..||.....
L000095C6       dc.w    $3800,$18C6,$E721,$0018,$C6E7,$2100,$00DA,$FF25         ;8....!....!....%
L000095D6       dc.w    $0000,$CCFF,$3300,$8176,$7E08,$00C4,$003B,$3B00         ;....3..v~....;;.
L000095E6       dc.w    $03FC,$FC00,$0001,$C6FE,$3800,$18C6,$E721,$0000         ;........8....!..
L000095F6       dc.w    $FCFF,$0300,$01CC,$FE32,$0018,$C6E7,$2100,$18C6         ;.......2....!...
L00009606       dc.w    $E721,$009C,$0063,$6300,$837C,$7C00,$0001,$C6FE         ;.!...cc..||.....
L00009616       dc.w    $3800,$1CC0,$E323,$0083,$7C7C,$0000,$C106,$3E38         ;8....#..||....>8
L00009626       dc.w    $0038,$C6C7,$0100,$807C,$7F03,$00C1,$003E,$3E00         ;.8.....|.....>>.
L00009636       dc.w    $03FC,$FC00,$0081,$307E,$4E00,$C730,$3808,$00C7         ;......0~N..08...
L00009646       dc.w    $3038,$0800,$C730,$3808,$00C7,$3038,$0800,$C730         ;08...08...08...0
L00009656       dc.w    $3808,$00E7,$0018,$1800,$39C6,$C600,$0018,$C6E7         ;8.......9.......
L00009666       dc.w    $2100,$18C6,$E721,$0018,$C6E7,$2100,$18C6,$E721         ;!....!....!....!
L00009676       dc.w    $0018,$C6E7,$2100,$807C,$7F03,$00C1,$003E,$3E00         ;....!..|.....>>.
L00009686       dc.w    $39C6,$C600,$0018,$C6E7,$2100,$18C6,$E721,$0080         ;9.......!....!..
L00009696       dc.w    $6C7F,$1300,$817C,$7E02,$00C1,$383E,$0600,$E310         ;l....|~...8>....
L000096A6       dc.w    $1C0C,$00F7,$0008,$0800,$39C6,$C600,$0018,$C6E7         ;........9.......
L000096B6       dc.w    $2100,$08D6,$F721,$0000,$D6FF,$2900,$00FE,$FF01         ;!....!....).....
L000096C6       dc.w    $0080,$7C7F,$0300,$816C,$7E12,$00C9,$0036,$3600         ;..|....l~....66.
L000096D6       dc.w    $39C6,$C600,$0018,$C6E7,$2100,$10EE,$EF01,$0080         ;9.......!.......
L000096E6       dc.w    $7C7F,$0300,$01EE,$FE10,$0018,$C6E7,$2100,$18C6         ;|...........!...
L000096F6       dc.w    $E721,$009C,$0063,$6300,$33CC,$CC00,$0011,$CCEE         ;.!...cc.3.......
L00009706       dc.w    $2200,$11CC,$EE22,$0081,$787E,$0600,$C330,$3C0C         ;"...."..x~...0<.
L00009716       dc.w    $00C7,$3038,$0800,$C730,$3808,$00E7,$0018,$1800         ;..08...08.......
L00009726       dc.w    $03FC,$FC00,$0001,$CCFE,$3200,$8118,$7E66,$00C3         ;........2...~f..
L00009736       dc.w    $303C,$0C00,$8760,$7818,$0003,$CCFC,$3000,$01FC         ;0<...`x.....0...
L00009746       dc.w    $FE02,$0081,$007E,$7E00,$0010,$0001,$0002,$000B         ;.....~~.........
L00009756       dc.w    $0000,$0038,$0000,$0016,$0010,$0001,$0002,$000B         ;...8............
L00009766       dc.w    $0000,$0096,$0000,$0016,$0010,$0001,$0002,$000B         ;................
L00009776       dc.w    $0000,$00F4,$0000,$0016,$0010,$0001,$0002,$000B         ;................
L00009786       dc.w    $0000,$0152,$0000,$0016,$0000,$0000,$0000,$07E0         ;...R............
L00009796       dc.w    $1FFC,$3FFC,$1FFC,$07E0,$0000,$0000,$0000,$0000         ;..?.............
L000097A6       dc.w    $0000,$0000,$0000,$07C0,$1C00,$07C0,$0000,$0000         ;................
L000097B6       dc.w    $0000,$0000,$0000,$0000,$0000,$07E0,$1FFC,$3304         ;..............3.
L000097C6       dc.w    $1FFC,$07E0,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000097D6       dc.w    $0000,$07C0,$1000,$07C0,$0000,$0000,$0000,$0000         ;................
L000097E6       dc.w    $0000,$0000,$0000,$07E0,$1FFC,$3CFC,$1FFC,$07E0         ;..........<.....
L000097F6       dc.w    $0000,$0000,$0000,$0700,$1E00,$3C00,$7800,$FF80         ;..........<.x...
L00009806       dc.w    $FF80,$FF80,$7800,$3C00,$1E00,$0700,$0000,$0400         ;....x.<.........
L00009816       dc.w    $1800,$0000,$0000,$6300,$0000,$0000,$1800,$0400         ;......c.........
L00009826       dc.w    $0000,$0700,$1E00,$2400,$7800,$FF80,$9380,$FF80         ;......$.x.......
L00009836       dc.w    $7800,$2400,$1E00,$0700,$0000,$0400,$0000,$0000         ;x.$.............
L00009846       dc.w    $0000,$0000,$0000,$0000,$0000,$0400,$0000,$0700         ;................
L00009856       dc.w    $1E00,$3C00,$4800,$FF80,$EC80,$FF80,$4800,$3C00         ;..<.H.......H.<.
L00009866       dc.w    $1E00,$0700,$0000,$0000,$0000,$07E0,$3FF8,$3FFC         ;............?.?.
L00009876       dc.w    $3FF8,$07E0,$0000,$0000,$0000,$0000,$0000,$0000         ;?...............
L00009886       dc.w    $0000,$03E0,$0038,$03E0,$0000,$0000,$0000,$0000         ;.....8..........
L00009896       dc.w    $0000,$0000,$0000,$07E0,$3FF8,$20CC,$3FF8,$07E0         ;........?. .?...
L000098A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$03E0         ;................
L000098B6       dc.w    $0008,$03E0,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000098C6       dc.w    $0000,$07E0,$3FF8,$3F3C,$3FF8,$07E0,$0000,$0000         ;....?.?<?.......
L000098D6       dc.w    $0000,$00E0,$0078,$003C,$001E,$01FF,$01FF,$01FF         ;.....x.<........
L000098E6       dc.w    $001E,$003C,$0078,$00E0,$0000,$0020,$0018,$0000         ;...<.x..... ....
L000098F6       dc.w    $0000,$00C6,$0000,$0000,$0018,$0020,$0000,$00E0         ;........... ....
L00009906       dc.w    $0078,$0024,$001E,$01FF,$01C9,$01FF,$001E,$0024         ;.x.$...........$
L00009916       dc.w    $0078,$00E0,$0000,$0020,$0000,$0000,$0000,$0000         ;.x..... ........
L00009926       dc.w    $0000,$0000,$0000,$0020,$0000,$00E0,$0078,$003C         ;....... .....x.<
L00009936       dc.w    $0012,$01FF,$0137,$01FF,$0012,$003C,$0078,$00E0         ;.....7.....<.x..
L00009946       dc.w    $000E,$0000,$0000,$000E,$0000,$0000,$0000,$0000         ;................
L00009956       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009966       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009976       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009986       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009996       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000099A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000099B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000099C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000099D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000099E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000099F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009A06       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009A16       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009A26       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009A36       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009A46       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009A56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009A66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009A76       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009A86       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009A96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009AA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009AB6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009AC6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009AD6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009AE6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009AF6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009B06       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009B16       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009B26       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009B36       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009B46       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009B56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009B66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009B76       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009B86       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009B96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009BA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009BB6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009BC6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009BD6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009BE6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009BF6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009C06       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009C16       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009C26       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009C36       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009C46       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009C56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009C66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009C76       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009C86       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009C96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009CA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009CB6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009CC6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009CD6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009CE6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009CF6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009D06       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009D16       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009D26       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009D36       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009D46       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009D56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009D66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009D76       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009D86       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009D96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009DA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009DB6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009DC6       dc.w    $0000,$0000,$0000,$0000,$FFC0,$7F80,$3F00,$1E00         ;............?...
L00009DD6       dc.w    $0C00,$07C0,$0380,$0300,$0100,$0100,$A000,$E000         ;................
L00009DE6       dc.w    $A000,$A000,$4000,$E000,$0000,$0000,$0000,$0000         ;....@...........
L00009DF6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009E06       dc.w    $FCF3,$C000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009E16       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009E26       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009E36       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009E46       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009E56       dc.w    $FCF3,$C000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009E66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009E76       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009E86       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009E96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009EA6       dc.w    $FCF3,$C000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009EB6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009EC6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009ED6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009EE6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009EF6       dc.w    $FC03,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF         ;................
L00009F06       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF         ;................
L00009F16       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF         ;................
L00009F26       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF         ;................
L00009F36       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF         ;................
L00009F46       dc.w    $FFFF,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009F56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009F66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009F76       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009F86       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009F96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009FA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009FB6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009FC6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009FD6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009FE6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00009FF6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A006       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A016       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A026       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A036       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A046       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A056       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A066       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A076       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A086       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A096       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A0A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A0B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A0C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A0D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A0E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A0F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A106       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A116       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A126       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A136       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A146       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A156       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A166       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A176       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A186       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A196       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A1A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A1B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A1C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A1D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A1E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A1F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A206       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A216       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A226       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A236       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A246       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A256       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A266       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A276       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A286       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A296       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A2A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A2B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A2C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A2D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A2E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A2F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A306       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A316       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A326       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A336       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A346       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A356       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A366       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A376       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A386       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A396       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A3A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A3B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A3C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A3D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A3E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A3F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A406       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A416       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A426       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A436       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A446       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A456       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A466       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A476       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A486       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A496       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A4A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A4B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A4C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A4D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A4E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A4F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A506       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A516       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A526       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A536       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A546       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A556       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A566       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A576       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A586       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A596       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A5A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A5B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A5C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A5D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A5E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A5F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A606       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A616       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A626       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A636       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A646       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A656       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A666       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A676       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A686       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A696       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A6A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A6B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A6C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A6D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A6E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A6F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A706       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A716       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A726       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A736       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A746       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A756       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A766       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A776       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A786       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A796       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A7A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A7B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A7C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A7D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A7E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A7F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A806       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A816       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A826       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A836       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A846       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A856       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A866       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A876       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A886       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A896       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A8A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A8B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A8C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A8D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A8E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A8F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A906       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A916       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A926       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A936       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A946       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A956       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A966       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A976       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A986       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A996       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A9A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A9B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A9C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A9D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A9E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000A9F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AA06       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AA16       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AA26       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AA36       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AA46       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AA56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AA66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AA76       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AA86       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AA96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AAA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AAB6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AAC6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AAD6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AAE6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AAF6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AB06       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AB16       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AB26       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AB36       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AB46       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AB56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AB66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AB76       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AB86       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AB96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000ABA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000ABB6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000ABC6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000ABD6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000ABE6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000ABF6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AC06       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AC16       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AC26       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AC36       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AC46       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AC56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AC66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AC76       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AC86       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AC96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000ACA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000ACB6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000ACC6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000ACD6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000ACE6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000ACF6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AD06       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AD16       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AD26       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AD36       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AD46       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AD56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AD66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AD76       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AD86       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AD96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000ADA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000ADB6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000ADC6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000ADD6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000ADE6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000ADF6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AE06       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AE16       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AE26       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AE36       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AE46       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AE56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AE66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AE76       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AE86       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AE96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AEA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AEB6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AEC6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AED6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AEE6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AEF6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AF06       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AF16       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AF26       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AF36       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AF46       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AF56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AF66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AF76       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AF86       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AF96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AFA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AFB6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AFC6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AFD6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AFE6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000AFF6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B006       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B016       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B026       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B036       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B046       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B056       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B066       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B076       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B086       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B096       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B0A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B0B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B0C6       dc.w    $0000,$2B01,$FFFE,$0180,$005A,$0182,$0FFF,$0184         ;..+......Z......
L0000B0D6       dc.w    $0002,$0186,$0F80,$01A0,$0000,$01A2,$0D22,$01A4         ;............."..
L0000B0E6       dc.w    $0000,$01A6,$0FCA,$01A8,$0444,$01AA,$0555,$01AC         ;.........D...U..
L0000B0F6       dc.w    $0666,$01AE,$0777,$01B0,$0888,$01B2,$0999,$01B4         ;.f...w..........
L0000B106       dc.w    $0AAA,$01B6,$0BBB,$01B8,$0CCC,$01BA,$0DDD,$01BC         ;................
L0000B116       dc.w    $0EEE,$01BE,$0FFF,$008E,$0581,$0100,$0200,$0104         ;................
L0000B126       dc.w    $0024,$0090,$40C1,$0092,$003C,$0094,$00D0,$0102         ;.$..@....<......
L0000B136       dc.w    $0000,$0108,$0000,$010A,$0000,$00E0,$0000,$00E2         ;................
L0000B146       dc.w    $60C8,$00E4,$0000,$00E6,$B8F0,$2C01,$FFFE,$0100         ;`.........,.....
L0000B156       dc.w    $A200,$FFDF,$FFFE,$2C01,$FFFE,$0100,$0200,$FFFF         ;......,.........
L0000B166       dc.w    $FFFE,$0000,$0000,$0000,$0000,$0001,$08F0,$0000         ;................
L0000B176       dc.w    $0718,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B186       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B196       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B1A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B1B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$7F00         ;................
L0000B1C6       dc.w    $01C0,$0000,$0000,$0000,$0C00,$01F0,$0000,$0000         ;................
L0000B1D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B1E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B1F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B206       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B216       dc.w    $0000,$3180,$00C0,$0000,$0000,$0000,$1C00,$0318         ;..1.............
L0000B226       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B236       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B246       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B256       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B266       dc.w    $0000,$0000,$0000,$3187,$C0C0,$7C3E,$07E1,$F000         ;......1...|>....
L0000B276       dc.w    $0C00,$0018,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B286       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B296       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B2A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B2B6       dc.w    $0000,$0000,$0000,$0000,$0000,$3F0C,$60C0,$C603         ;..........?.`...
L0000B2C6       dc.w    $0C03,$1800,$0C00,$00F0,$0000,$0000,$0000,$0000         ;................
L0000B2D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B2E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B2F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B306       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$330F         ;..............3.
L0000B316       dc.w    $E0C0,$FE1F,$07C3,$F800,$0C00,$0018,$0000,$0000         ;................
L0000B326       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B336       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B346       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B356       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B366       dc.w    $0000,$318C,$00C0,$C063,$0063,$0000,$0C03,$0318         ;..1....c.c......
L0000B376       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B386       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B396       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B3A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B3B6       dc.w    $0000,$0000,$0000,$70C7,$C1E0,$7C3D,$8FC1,$F000         ;......p...|=....
L0000B3C6       dc.w    $3F03,$01F0,$0000,$0000,$0000,$0000,$0000,$0000         ;?...............
L0000B3D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B3E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B3F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B406       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B416       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B426       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B436       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B446       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B456       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B466       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B476       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B486       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B496       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B4A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B4B6       dc.w    $0000,$0001,$08F0,$0000,$03D0,$0000,$0000,$0000         ;................
L0000B4C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B4D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B4E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B4F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B506       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B516       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B526       dc.w    $0000,$0000,$0000,$0000,$0000,$0001,$0CB0,$0000         ;................
L0000B536       dc.w    $0358,$0000,$0000,$0000,$0000,$0000,$0000,$FFFF         ;.X..............
L0000B546       dc.w    $FFFF,$FFFF,$E000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B556       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B566       dc.w    $0000,$0000,$0000,$FFFF,$FFFF,$FFFF,$E000,$0000         ;................
L0000B576       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B586       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B596       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B5A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B5B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B5C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B5D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B5E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B5F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B606       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B616       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B626       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B636       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B646       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B656       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B666       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B676       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B686       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B696       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B6A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B6B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B6C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B6D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B6E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B6F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B706       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B716       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B726       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B736       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B746       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B756       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B766       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B776       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B786       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B796       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B7A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B7B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B7C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B7D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B7E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B7F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B806       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B816       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B826       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B836       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B846       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B856       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B866       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B876       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B886       dc.w    $0000,$2B01,$FFFE,$0180,$0FFF,$0182,$0000,$0184         ;..+.............
L0000B896       dc.w    $077C,$0186,$0BBB,$008E,$0581,$0100,$0200,$0104         ;.|..............
L0000B8A6       dc.w    $0024,$0090,$40C1,$0092,$0038,$0094,$00D0,$0102         ;.$..@....8......
L0000B8B6       dc.w    $0000,$0108,$0000,$010A,$0000,$00E0,$0000,$00E2         ;................
L0000B8C6       dc.w    $5AC2,$00E4,$0000,$00E6,$7A02,$2C01,$FFFE,$0100         ;Z.......z.,.....
L0000B8D6       dc.w    $2200,$F401,$FFFE,$0100,$0200,$FFFF,$FFFE,$0000         ;"...............
L0000B8E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B8F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B906       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B916       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B926       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B936       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B946       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B956       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B966       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B976       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B986       dc.w    $0000,$0000,$0000,$01FF,$F800,$0000,$0000,$0000         ;................
L0000B996       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B9A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B9B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B9C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B9D6       dc.w    $0000,$0000,$0000,$01E0,$0000,$0000,$0000,$0000         ;................
L0000B9E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000B9F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BA06       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BA16       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BA26       dc.w    $0000,$0000,$1FFF,$81E0,$0000,$0000,$0000,$0000         ;................
L0000BA36       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BA46       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BA56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BA66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BA76       dc.w    $0000,$0000,$1FFF,$81E0,$0000,$0000,$0000,$0000         ;................
L0000BA86       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BA96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BAA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BAB6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BAC6       dc.w    $0000,$0000,$1FFF,$81E0,$0000,$0000,$0000,$0000         ;................
L0000BAD6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BAE6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BAF6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BB06       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BB16       dc.w    $0000,$0000,$1FFF,$81E0,$0000,$0000,$0000,$0000         ;................
L0000BB26       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BB36       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BB46       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BB56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BB66       dc.w    $0000,$0000,$1FFF,$8000,$0000,$0000,$0000,$0000         ;................
L0000BB76       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BB86       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BB96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BBA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BBB6       dc.w    $0000,$0000,$1FFF,$8000,$0000,$0000,$0000,$0000         ;................
L0000BBC6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BBD6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BBE6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BBF6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BC06       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BC16       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BC26       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BC36       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BC46       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BC56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BC66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BC76       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BC86       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BC96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BCA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BCB6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BCC6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BCD6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BCE6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BCF6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BD06       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BD16       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BD26       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BD36       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BD46       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BD56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BD66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BD76       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BD86       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BD96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BDA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BDB6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BDC6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BDD6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BDE6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BDF6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BE06       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BE16       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BE26       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BE36       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BE46       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BE56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BE66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BE76       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BE86       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BE96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BEA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BEB6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BEC6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BED6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BEE6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BEF6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BF06       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BF16       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BF26       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BF36       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BF46       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BF56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BF66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BF76       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BF86       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BF96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BFA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BFB6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BFC6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BFD6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BFE6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000BFF6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C006       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C016       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C026       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C036       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C046       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C056       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C066       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C076       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C086       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C096       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C0A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C0B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C0C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C0D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C0E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C0F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C106       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C116       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C126       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C136       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C146       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C156       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C166       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C176       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C186       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C196       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C1A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C1B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C1C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C1D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C1E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C1F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C206       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C216       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C226       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C236       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C246       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C256       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C266       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C276       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C286       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C296       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C2A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C2B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C2C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C2D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C2E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C2F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C306       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C316       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C326       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C336       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C346       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C356       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C366       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C376       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C386       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C396       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C3A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C3B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C3C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C3D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C3E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C3F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C406       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C416       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C426       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C436       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C446       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C456       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C466       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C476       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C486       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C496       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C4A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C4B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C4C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C4D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C4E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C4F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C506       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C516       dc.w    $0000,$0000,$0000,$0000,$0000,$0FFC,$0000,$0000         ;................
L0000C526       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C536       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C546       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C556       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C566       dc.w    $0000,$0000,$0000,$0000,$0000,$0FFC,$0000,$0000         ;................
L0000C576       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C586       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C596       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C5A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C5B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0FFC,$0000,$0000         ;................
L0000C5C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C5D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C5E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C5F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C606       dc.w    $0000,$0000,$0000,$0000,$0000,$0FFC,$0000,$0000         ;................
L0000C616       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C626       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C636       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C646       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C656       dc.w    $0000,$0000,$0000,$0000,$0000,$0FFC,$0000,$0000         ;................
L0000C666       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C676       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C686       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C696       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C6A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0FFC,$0000,$0000         ;................
L0000C6B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C6C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C6D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C6E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C6F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0FFC,$0000,$0000         ;................
L0000C706       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C716       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C726       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C736       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C746       dc.w    $0000,$0000,$0000,$0000,$0000,$0FFC,$0000,$0000         ;................
L0000C756       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C766       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C776       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C786       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C796       dc.w    $0000,$0000,$0000,$0000,$0000,$0FFC,$0000,$0000         ;................
L0000C7A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C7B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C7C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C7D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C7E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C7F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C806       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C816       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C826       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C836       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C846       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C856       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C866       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C876       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C886       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C896       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C8A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C8B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C8C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C8D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C8E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C8F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C906       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C916       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C926       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C936       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C946       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C956       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C966       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C976       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C986       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C996       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C9A6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C9B6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C9C6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C9D6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C9E6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000C9F6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CA06       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CA16       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CA26       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CA36       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CA46       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CA56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CA66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CA76       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CA86       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CA96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CAA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CAB6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CAC6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CAD6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CAE6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CAF6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CB06       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CB16       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CB26       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CB36       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CB46       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CB56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CB66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CB76       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CB86       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CB96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CBA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CBB6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CBC6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CBD6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CBE6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CBF6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CC06       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CC16       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CC26       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CC36       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CC46       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CC56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CC66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CC76       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CC86       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CC96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CCA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CCB6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CCC6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CCD6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CCE6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CCF6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CD06       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CD16       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CD26       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CD36       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CD46       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CD56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CD66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CD76       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CD86       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CD96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CDA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CDB6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CDC6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CDD6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CDE6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CDF6       dc.w    $0000,$0000,$0006,$0000,$0000,$0000,$0000,$0000         ;................
L0000CE06       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0002         ;................
L0000CE16       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0003,$0000         ;................
L0000CE26       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CE36       dc.w    $0000,$0000,$0000,$0002,$0000,$0000,$0000,$0000         ;................
L0000CE46       dc.w    $0000,$0000,$0001,$0000,$0000,$0000,$0000,$0000         ;................
L0000CE56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0002         ;................
L0000CE66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0001,$0000         ;................
L0000CE76       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CE86       dc.w    $0000,$0000,$0000,$0002,$0000,$0000,$0000,$0000         ;................
L0000CE96       dc.w    $0000,$0000,$0001,$0000,$0000,$0000,$0000,$0000         ;................
L0000CEA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0002         ;................
L0000CEB6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0001,$0000         ;................
L0000CEC6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CED6       dc.w    $0000,$0000,$0000,$0002,$0000,$0000,$0000,$0000         ;................
L0000CEE6       dc.w    $0000,$0000,$0001,$0000,$0000,$0000,$0000,$0000         ;................
L0000CEF6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0202         ;................
L0000CF06       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0001,$0000         ;................
L0000CF16       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CF26       dc.w    $0000,$0000,$0000,$0202,$0000,$0000,$0000,$0000         ;................
L0000CF36       dc.w    $0000,$0000,$0001,$0000,$0000,$0000,$0000,$0000         ;................
L0000CF46       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0402         ;................
L0000CF56       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0001,$0000         ;................
L0000CF66       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L0000CF76       dc.w    $0000,$0000,$0000,$0402,$0000,$0000,$0000,$0000         ;................
L0000CF86       dc.w    $0000,$0000,$0001,$0000,$0000,$0000,$0000,$0000         ;................
L0000CF96       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0E32         ;...............2
L0000CFA6       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0001,$0000         ;................














