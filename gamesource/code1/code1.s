


; Code1 - $2FFC - $6FFE (16K of code and music)


                section code1,code_c
                ;org     $0                                          ; original load address


                ;--------------------- includes and constants ---------------------------
                INCDIR      "include"
                INCLUDE     "hw.i"

start
                jmp game_start     
           


original_start:                                     ; original address $2FFC
                dc.l    $00003000                   ; long word of start address
           

game_start:
L00003000           moveq   #$00,d0
L00003002           move.w  #$1fff,$00dff09a
L0000300a           move.w  #$1fff,$00dff096
L00003012           move.w  #$0200,$00dff100
L0000301a           move.l  d0,$00dff102
L00003020           move.w  #$4000,$00dff024
L00003028           move.l  d0,$00dff040
L0000302e           move.w  #$0041,$00dff058
L00003036           move.w  #$8340,$00dff096
L0000303e           move.w  #$7fff,$00dff09e

L00003046           moveq   #$07,d7
L00003048           lea.l   $00dff140,a0
L0000304e           move.w  d0,(a0)
L00003050           addaq.w #$08,a0
L00003052           dbf.w   d7,L0000304e

L00003056           moveq   #$03,d7
L00003058           lea.l   $00dff0a8,a0
L0000305e           move.w  d0,(a0)
L00003060           lea.l   $0010(a0),a0
L00003064           dbf.w   d7,L0000305e

L00003068           lea.l   $00dff180,a0
L0000306e           moveq   #$1f,d7
L00003070           move.w  d0,(a0)+
L00003072           dbf.w   d7,L00003070

L00003076           move.b  #$7f,$00bfed01
L0000307e           move.b  d0,$00bfee01
L00003084           move.b  d0,$00bfef01
L0000308a           move.b  d0,$00bfe001
L00003090           move.b  #$03,$00bfe201
L00003098           move.b  d0,$00bfe101
L0000309e           move.b  #$ff,$00bfe301
L000030a6           move.b  #$7f,$00bfdd00
L000030ae           move.b  d0,$00bfde00
L000030b4           move.b  d0,$00bfdf00
L000030ba           move.b  #$c0,$00bfd000
L000030c2           move.b  #$c0,$00bfd200
L000030ca           move.b  #$ff,$00bfd100
L000030d2           move.b  #$ff,$00bfd300
L000030da           lea.l   $0005a36c,a7                       ; Extername Address - Stack

L000030e0           moveq   #$02,d7
L000030e2           lea.l   L000031b0,a0
L000030e8           lea.l   $00000064,a1
L000030ee           move.l  (a0)+,(a1)+
L000030f0           dbf.w   d7,L000030ee

L000030f4           move.w  #$ff00,$00dff034
L000030fc           move.w  d0,$00dff036
L00003102           or.b    #$ff,$00bfd100
L0000310a           and.b   #$87,$00bfd100
L00003112           and.b   #$87,$00bfd100
L0000311a           or.b    #$ff,$00bfd100
L00003122           move.b  #$f0,$00bfe601
L0000312a           move.b  #$37,$00bfeb01
L00003132           move.b  #$11,$00bfef01
L0000313a           move.b  #$91,$00bfd600
L00003142           move.b  d0,$00bfdb00
L00003148           move.b  d0,$00bfdf00
L0000314e           move.w  #$7fff,$00dff09c
L00003156           tst.b   $00bfed01
L0000315c           move.b  #$8a,$00bfed01
L00003164           tst.b   $00bfdd00
L0000316a           move.b  #$93,$00bfdd00
L00003172           move.w  #$e078,$00dff09a
L0000317a           jsr     $0007c838                    ; Panel - Function
L00003180           jsr     $0007c81c                    ; Panel - Function
L00003186           jsr     $0007c854                    ; Panel - Function
L0000318c           move.w  #$0800,d0
L00003190           jsr     $0007c80e                    ; Panel - Function
L00003196           bsr.w   L00003746
L0000319a           lea.l   L000031c8,a0
L000031a0           bsr.w   L0000368a
L000031a4           bsr.w   L000036fa
L000031a8           bra.w   L00003ae4

L000031ac ffff                     illegal
L000031ae fffe                     illegal
L000031b0 0000 32c0                or.b #$c0,d0
L000031b4 0000 32f8                or.b #$f8,d0
L000031b8 0000 331e                or.b #$1e,d0
L000031bc 0000 335a                or.b #$5a,d0
L000031c0 0000 3370                or.b #$70,d0
L000031c4 0000 3396                or.b #$96,d0
L000031c8 2c01                     move.l d1,d6
L000031ca fffe                     illegal
L000031cc 010a 0002                movep.w (a2,$0002) == $0006d7ea,d0
L000031d0 0108 0002                movep.w (a0,$0002) == $00000a02,d0
L000031d4 00e2                     illegal
L000031d6 7680                     moveq #$80,d3
L000031d8 00e0                     illegal
L000031da 0006 00e6                or.b #$e6,d6
L000031de 98e0                     suba.w -(a0) [3000],a4
L000031e0 00e4                     illegal
L000031e2 0006 00ea                or.b #$ea,d6
L000031e6 bb40                     eor.w d5,d0
L000031e8 00e8 0006 00ee           [ cmp2.b (a0,$00ee) == $00000aee,d0 ]
L000031ea 0006 00ee                or.b #$ee,d6
L000031ee dda0                     add.l d6,-(a0) [4ef83000]
L000031f0 00ec 0006 0182           [ cmp2.b (a4,$0182) == $00bfe283,d0 ]
L000031f2 0006 0182                or.b #$82,d6
L000031f6 0446 0184                sub.w #$0184,d6
L000031fa 088a                     illegal
L000031fc 0186                     bclr.l d0,d6
L000031fe 0cce                     illegal
L00003200 0188 0048                movep.w d0,(a0,$0048) == $00000a48
L00003204 018a 028c                movep.w d0,(a2,$028c) == $0006da74
L00003208 018c 0c64                movep.w d0,(a4,$0c64) == $00bfed65
L0000320c 018e 0a22                movep.w d0,(a6,$0a22) == $00dffa22
L00003210 0190                     bclr.b d0,(a0) [00]
L00003212 06a6 0192 0c4a           add.l #$01920c4a,-(a6)
L00003218 0194                     bclr.b d0,(a4)
L0000321a 0ec6                     illegal
L0000321c 0196                     bclr.b d0,(a6)
L0000321e 0e88                     illegal
L00003220 0198                     bclr.b d0,(a0)+ [00]
L00003222 0600 019a                add.b #$9a,d0
L00003226 0262 019c                and.w #$019c,-(a2) [93f1]
L0000322a 0668 019e 06ae           add.w #$019e,(a0,$06ae) == $000010ae [0d1b]
L00003230 da01                     add.b d1,d5
L00003232 fffe                     illegal
L00003234 010a 0000                movep.w (a2,$0000) == $0006d7e8,d0
L00003238 0108 0000                movep.w (a0,$0000) == $00000a00,d0
L0000323c 00e2                     illegal
L0000323e c89a                     and.l (a2)+ [124197f7],d4
L00003240 00e0                     illegal
L00003242 0007 00e6                or.b #$e6,d7
L00003246 d01a                     add.b (a2)+ [12],d0
L00003248 00e4                     illegal
L0000324a 0007 00ea                or.b #$ea,d7
L0000324e d79a                     add.l d3,(a2)+ [124197f7]
L00003250 00e8 0007 00ee           [ cmp2.b (a0,$00ee) == $00000aee,d0 ]
L00003252 0007 00ee                or.b #$ee,d7
L00003256 df1a                     add.b d7,(a2)+ [12]
L00003258 00ec 0007 0180           [ cmp2.b (a4,$0180) == $00bfe281,d0 ]
L0000325a 0007 0180                or.b #$80,d7
L0000325e 0000 0182                or.b #$82,d0
L00003262 0000 0184                or.b #$84,d0
L00003266 0000 0186                or.b #$86,d0
L0000326a 0000 0188                or.b #$88,d0
L0000326e 0000 018a                or.b #$8a,d0
L00003272 0000 018c                or.b #$8c,d0
L00003276 0000 018e                or.b #$8e,d0
L0000327a 0000 0190                or.b #$90,d0
L0000327e 0000 0192                or.b #$92,d0
L00003282 0000 0194                or.b #$94,d0
L00003286 0000 0196                or.b #$96,d0
L0000328a 0000 0198                or.b #$98,d0
L0000328e 0000 019a                or.b #$9a,d0
L00003292 0000 019c                or.b #$9c,d0
L00003296 0000 019e                or.b #$9e,d0
L0000329a 0000 ffff                or.b #$ff,d0
L0000329e fffe                     illegal
L000032a0 0000 0060                or.b #$60,d0
L000032a4 0fff                     illegal
L000032a6 0008                     illegal
L000032a8 0a22 0444                eor.b #$44,-(a2) [f1]
L000032ac 0862 0666                bchg.b #$0666,-(a2) [f1]
L000032b0 0888                     illegal
L000032b2 0aaa 0a40 0c60 0e80      eor.l #$0a400c60,(a2,$0e80) == $0006e668 [25e19a09]
L000032ba 0ea0 0ec0                [ moves.l d0,-(a0) [4ef83000] ]
L000032bc 0ec0                     illegal
L000032be 0eee 2f00 3039           [ cas.l d0,d4,(a6,$3039) == $00e02039 [6e011422] ]

L000032c0           move.l  d0,-(a7)
L000032c2           move.w  $00dff01e,d0
L000032c8           btst.l  #$0002,d0
L000032cc           bne.b   L000032ec
L000032ce           btst.l  #$0001,d0
L000032d2           bne.b   L000032e0
L000032d4           move.w  #$0001,$00dff09c
L000032dc           move.l  (a7)+,d0
L000032de           rte

L000032e0           move.w  #$0002,$00dff09c
L000032e8           move.l  (a7)+,d0
L000032ea           rte

L000032ec           move.w  #$0004,$00dff09c
L000032f4           move.l  (a7)+,d0
L000032f6           rte

L000032f8           move.l  d0,-(a7)
L000032fa           move.b  $00bfed01,d0
L00003300           bpl.b   L00003312
L00003302           bsr.w   L000033d4
L00003306           move.w  #$0008,$00dff09c
L0000330e           move.l  (a7)+,d0
L00003310           rte

L00003312 33fc 0008 00df f09c      move.w #$0008,$00dff09c
L0000331a 201f                     move.l (a7)+ [6000001a],d0
L0000331c 4e73                     rte  == $001a6000

L0000331e 2f00                     move.l d0,-(a7) [000009ec]
L00003320 3039 00df f01e           move.w $00dff01e,d0
L00003326 0800 0004                btst.l #$0004,d0
L0000332a 6622                     bne.b #$22 == $0000334e (T)
L0000332c 0800 0005                btst.l #$0005,d0
L00003330 660c                     bne.b #$0c == $0000333e (T)
L00003332 33fc 0040 00df f09c      move.w #$0040,$00dff09c
L0000333a 201f                     move.l (a7)+ [6000001a],d0
L0000333c 4e73                     rte  == $001a6000

L0000333e 6100 01e6                bsr.w #$01e6 == $00003526
L00003342 33fc 0020 00df f09c      move.w #$0020,$00dff09c
L0000334a 201f                     move.l (a7)+ [6000001a],d0
L0000334c 4e73                     rte  == $001a6000

L0000334e 33fc 0010 00df f09c      move.w #$0010,$00dff09c
L00003356 201f                     move.l (a7)+ [6000001a],d0
L00003358 4e73                     rte  == $001a6000

L0000335a 2f00                     move.l d0,-(a7) [000009ec]
L0000335c 3039 00df f01e           move.w $00dff01e,d0
L00003362 0240 0780                and.w #$0780,d0
L00003366 33c0 00df f09a           move.w d0,$00dff09a
L0000336c 201f                     move.l (a7)+ [6000001a],d0
L0000336e 4e73                     rte  == $001a6000

L00003370 2f00                     move.l d0,-(a7) [000009ec]
L00003372 3039 00df f01e           move.w $00dff01e,d0
L00003378 0800 000c                btst.l #$000c,d0
L0000337c 660c                     bne.b #$0c == $0000338a (T)
L0000337e 33fc 0800 00df f09c      move.w #$0800,$00dff09c
L00003386 201f                     move.l (a7)+ [6000001a],d0
L00003388 4e73                     rte  == $001a6000

L0000338a 33fc 1000 00df f09c      move.w #$1000,$00dff09c
L00003392 201f                     move.l (a7)+ [6000001a],d0
L00003394 4e73                     rte  == $001a6000

L00003396 2f00                     move.l d0,-(a7) [000009ec]
L00003398 3039 00df f01e           move.w $00dff01e,d0
L0000339e 0800 000e                btst.l #$000e,d0
L000033a2 6624                     bne.b #$24 == $000033c8 (T)
L000033a4 1039 00bf dd00           move.b $00bfdd00,d0
L000033aa 6a10                     bpl.b #$10 == $000033bc (T)
L000033ac 6100 0166                bsr.w #$0166 == $00003514
L000033b0 33fc 2000 00df f09c      move.w #$2000,$00dff09c
L000033b8 201f                     move.l (a7)+ [6000001a],d0
L000033ba 4e73                     rte  == $001a6000

L000033bc 33fc 2000 00df f09c      move.w #$2000,$00dff09c
L000033c4 201f                     move.l (a7)+ [6000001a],d0
L000033c6 4e73                     rte  == $001a6000

L000033c8 33fc 4000 00df f09c      move.w #$4000,$00dff09c
L000033d0 201f                     move.l (a7)+ [6000001a],d0
L000033d2 4e73                     rte  == $001a6000

L000033d4 e408                     lsr.b #$02,d0
L000033d6 6404                     bcc.b #$04 == $000033dc (T)
L000033d8 6100 016a                bsr.w #$016a == $00003544
L000033dc e408                     lsr.b #$02,d0
L000033de 646e                     bcc.b #$6e == $0000344e (T)
L000033e0 48e7 6080                movem.l d1-d2/a0,-(a7)
L000033e4 1239 00bf ec01           move.b $00bfec01,d1
L000033ea 4601                     not.b d1
L000033ec e209                     lsr.b #$01,d1
L000033ee 6416                     bcc.b #$16 == $00003406 (T)
L000033f0 41f9 0000 34f4           lea.l $000034f4,a0
L000033f6 4881                     ext.w d1
L000033f8 123b 1056                move.b (pc,d1.W,$56=$00003450) == $0000344f [75],d1
L000033fc 3401                     move.w d1,d2
L000033fe e64a                     lsr.w #$03,d2
L00003400 03b0 2000                bclr.b d1,(a0,d2.W,$00) == $00001407 [28]
L00003404 603c                     bra.b #$3c == $00003442 (T)
L00003406 41f9 0000 34f4           lea.l $000034f4,a0
L0000340c 4881                     ext.w d1
L0000340e 123b 1040                move.b (pc,d1.W,$40=$00003450) == $0000344f [75],d1
L00003412 3401                     move.w d1,d2
L00003414 e64a                     lsr.w #$03,d2
L00003416 03f0 2000                bset.b d1,(a0,d2.W,$00) == $00001407 [28]
L0000341a 4a01                     tst.b d1
L0000341c 6724                     beq.b #$24 == $00003442 (F)
L0000341e 41f9 0000 34d0           lea.l $000034d0,a0
L00003424 3439 0000 34f0           move.w $000034f0 [0000],d2
L0000342a 1181 2000                move.b d1,(a0,d2.W,$00) == $00001407 [28]
L0000342e 5242                     addq.w #$01,d2
L00003430 0242 001f                and.w #$001f,d2
L00003434 b479 0000 34f2           cmp.w $000034f2 [0000],d2
L0000343a 6706                     beq.b #$06 == $00003442 (F)
L0000343c 33c2 0000 34f0           move.w d2,$000034f0 [0000]
L00003442 13fc 0040 00bf ee01      move.b #$40,$00bfee01
L0000344a 4cdf 0106                movem.l (a7)+,d1-d2/a0
L0000344e 4e75                     rts  == $6000001a

L00003450 2731 3233                move.l (a1,d3.W[*2],$33) == $000402a0 (68020+) [17000018],-(a3) [43338718]
L00003454 3435 3637                move.w (a5,d3.W[*8],$37) == $00bfd44a (68020+),d2
L00003458 3839 302d 3d5c           move.w $302d3d5c,d4
L0000345e 0030 5157 4552           or.b #$57,(a0,d4.W[*4],$52) == $00000b53 (68020+) [7c]
L00003464 5459                     addq.w #$02,(a1)+ [0400]
L00003466 5549                     subaq.w #$02,a1
L00003468 4f50                     illegal
L0000346a 5b5d                     subq.w #$05,(a5)+
L0000346c 0031 3233 4153           or.b #$33,(a1,d4.W,$53) == $000400ae (68020+) [00]
L00003472 4446                     neg.w d6
L00003474 4748                     illegal
L00003476 4a4b                     [ tst.w a3 ]
L00003478 4c3b 2300 0034           [ mulu.l (pc,d0.W,$34=$000034b0) == $00001440,d2 ]
L0000347a 2300                     move.l d0,-(a1) [00000000]
L0000347c 0034 3536 005a           or.b #$36,(a4,d0.W,$5a) == $00bfc0eb
L00003482 5843                     addq.w #$04,d3
L00003484 5642                     addq.w #$03,d2
L00003486 4e4d                     trap #$0d
L00003488 2c2e 2f00                move.l (a6,$2f00) == $00e01f00 [33fcc000],d6
L0000348c 0037 3839 2008           or.b #$39,(a7,d2.W,$08) == $0000122b [b0]
L00003492 090d 0d1b                movep.w (a5,$0d1b) == $00bfde1b,d4
L00003496 7f00                     illegal
L00003498 0000 2d00                or.b #$00,d0
L0000349c 8c8d                     illegal
L0000349e 8e8f                     illegal
L000034a0 8182 8384                [ unpk d2,d0,#$8384 ]
L000034a2 8384 8586                [ unpk d4,d1,#$8586 ]
L000034a4 8586 8788                [ unpk d6,d2,#$8788 ]
L000034a6 8788 898a                [ unpk -(a0),-(a3),#$898a ]
L000034a8 898a 2829                [ unpk -(a2),-(a4),#$2829 ]
L000034aa 2829 2f2a                move.l (a1,$2f2a) == $00042e84 [00000000],d4
L000034ae 2b8b 0000                move.l a3,(a5,d0.W,$00) == $00bfb090
L000034b2 0000 0000                or.b #$00,d0
L000034b6 0000 0000                or.b #$00,d0
L000034ba 0000 0000                or.b #$00,d0
L000034be 0000 0000                or.b #$00,d0
L000034c2 0000 0000                or.b #$00,d0
L000034c6 0000 0000                or.b #$00,d0
L000034ca 0000 0000                or.b #$00,d0
L000034ce 0000 0000                or.b #$00,d0
L000034d2 0000 0000                or.b #$00,d0
L000034d6 0000 0000                or.b #$00,d0
L000034da 0000 0000                or.b #$00,d0
L000034de 0000 0000                or.b #$00,d0
L000034e2 0000 0000                or.b #$00,d0
L000034e6 0000 0000                or.b #$00,d0
L000034ea 0000 0000                or.b #$00,d0
L000034ee 0000 0000                or.b #$00,d0
L000034f2 0000 0000                or.b #$00,d0
L000034f6 0000 0000                or.b #$00,d0
L000034fa 0000 0000                or.b #$00,d0
L000034fe 0000 0000                or.b #$00,d0
L00003502 0000 0000                or.b #$00,d0
L00003506 0000 0000                or.b #$00,d0
L0000350a 0000 0000                or.b #$00,d0
L0000350e 0000 0000                or.b #$00,d0
L00003512 0000 e408                or.b #$08,d0
L00003516 6408                     bcc.b #$08 == $00003520 (T)
L00003518 13fc 0000 00bf ee01      move.b #$00,$00bfee01
L00003520 4e75                     rts  == $6000001a
L00003522 0000 3542                or.b #$42,d0
L00003526 48e7 7ffe                movem.l d1-d7/a0-a6,-(a7)
L0000352a 5279 0000 36ee           addq.w #$01,$000036ee [0000]
L00003530 4eb9 0004 8018           jsr $00048018
L00003536 13fc 0000 00bf ee01      move.b #$00,$00bfee01
L0000353e 4cdf 7ffe                movem.l (a7)+,d1-d7/a0-a6
L00003542 4e75                     rts  == $6000001a
L00003544 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
L00003548 6100 001c                bsr.w #$001c == $00003566
L0000354c 5279 0000 3564           addq.w #$01,$00003564 [0000]
L00003552 2079 0000 3560           movea.l $00003560 [00003542],a0
L00003558 4e90                     jsr (a0)
L0000355a 4cdf 7fff                movem.l (a7)+,d0-d7/a0-a6
L0000355e 4e75                     rts  == $6000001a
L00003560 0000 3542                or.b #$42,d0
L00003564 0000 3039                or.b #$39,d0
L00003568 00df                     illegal
L0000356a f00a 3239                [ F-LINE (MMU 68030) ]
L0000356c 3239 0000 3630           move.w $00003630 [0000],d1
L00003572 33c0 0000 3630           move.w d0,$00003630 [0000]
L00003578 6100 0080                bsr.w #$0080 == $000035fa
L0000357c 13c0 0000 3637           move.b d0,$00003637 [00]
L00003582 d379 0000 3646           add.w d1,$00003646 [0000]
L00003588 d579 0000 3648           add.w d2,$00003648 [0000]
L0000358e 0839 0006 00bf e001      btst.b #$0006,$00bfe001
L00003596 57f9 0000 3636           seq.b $00003636 [00] (F)
L0000359c 57f9 0000 3644           seq.b $00003644 [00] (F)
L000035a2 0839 0002 00df f016      btst.b #$0002,$00dff016
L000035aa 57f9 0000 3645           seq.b $00003645 [00] (F)
L000035b0 3039 00df f00c           move.w $00dff00c,d0
L000035b6 3239 0000 3632           move.w $00003632 [0000],d1
L000035bc 33c0 0000 3632           move.w d0,$00003632 [0000]
L000035c2 6136                     bsr.b #$36 == $000035fa
L000035c4 13c0 0000 363b           move.b d0,$0000363b [00]
L000035ca d379 0000 364c           add.w d1,$0000364c [0000]
L000035d0 d579 0000 364e           add.w d2,$0000364e [0000]
L000035d6 0839 0007 00bf e001      btst.b #$0007,$00bfe001
L000035de 57f9 0000 363a           seq.b $0000363a [00] (F)
L000035e4 57f9 0000 364a           seq.b $0000364a [00] (F)
L000035ea 0839 0006 00df f016      btst.b #$0006,$00dff016
L000035f2 57f9 0000 364b           seq.b $0000364b [00] (F)
L000035f8 4e75                     rts  == $6000001a
L000035fa 3600                     move.w d0,d3
L000035fc 3401                     move.w d1,d2
L000035fe 9203                     sub.b d3,d1
L00003600 4401                     neg.b d1
L00003602 4881                     ext.w d1
L00003604 e04a                     lsr.w #$08,d2
L00003606 e04b                     lsr.w #$08,d3
L00003608 9403                     sub.b d3,d2
L0000360a 4402                     neg.b d2
L0000360c 4882                     ext.w d2
L0000360e 7603                     moveq #$03,d3
L00003610 c640                     and.w d0,d3
L00003612 ec48                     lsr.w #$06,d0
L00003614 0240 000c                and.w #$000c,d0
L00003618 8043                     or.w d3,d0
L0000361a 103b 0004                move.b (pc,d0.W,$04=$00003620) == $000015b0 [ff],d0
L0000361e 4e75                     rts  == $6000001a
L00003620 0004 0501                or.b #$01,d4
L00003624 080c                     illegal
L00003626 0d09 0a0e                movep.w (a1,$0a0e) == $00040968,d6
L0000362a 0f0b 0206                movep.w (a3,$0206) == $00063daf,d7
L0000362e 0703                     btst.l d3,d3
L00003630 0000 0000                or.b #$00,d0
L00003634 0000 0000                or.b #$00,d0
L00003638 0000 0000                or.b #$00,d0
L0000363c 0000 0000                or.b #$00,d0
L00003640 0000 0000                or.b #$00,d0
L00003644 0000 0000                or.b #$00,d0
L00003648 0000 0000                or.b #$00,d0
L0000364c 0000 0000                or.b #$00,d0
L00003650 2f00                     move.l d0,-(a7) [000009ec]
L00003652 6106                     bsr.b #$06 == $0000365a
L00003654 66fc                     bne.b #$fc == $00003652 (T)
L00003656 201f                     move.l (a7)+ [6000001a],d0
L00003658 4e75                     rts  == $6000001a
L0000365a 48e7 6080                movem.l d1-d2/a0,-(a7)
L0000365e 41f9 0000 34d0           lea.l $000034d0,a0
L00003664 7000                     moveq #$00,d0
L00003666 4cb9 0006 0000 34f0      movem.w $000034f0,d1-d2
L0000366e b441                     cmp.w d1,d2
L00003670 6710                     beq.b #$10 == $00003682 (F)
L00003672 1030 2000                move.b (a0,d2.W,$00) == $00001407 [28],d0
L00003676 5242                     addq.w #$01,d2
L00003678 0242 001f                and.w #$001f,d2
L0000367c 33c2 0000 34f2           move.w d2,$000034f2 [0000]
L00003682 4a00                     tst.b d0
L00003684 4cdf 0106                movem.l (a7)+,d1-d2/a0
L00003688 4e75                     rts  == $6000001a


L0000368a           move.w  #$0080,$00dff096
L00003692           move.l  a0,$00dff080
L00003698           move.w  a0,$00dff088
L0000369e           move.w  #$0000,$00dff10a
L000036a6           move.w  #$0000,$00dff108
L000036ae           move.w  #$0038,$00dff092
L000036b6           move.w  #$00d0,$00dff094
L000036be           move.w  #$3080,$00dff08e
L000036c6           move.w  #$0ac0,$00dff090
L000036ce           move.w  #$4200,$00dff100
L000036d6           clr.w   L000036ee
L000036dc           tst.w   L000036ee
L000036e2           beq.b   L000036dc
L000036e4           move.w  #$8180,$00dff096
L000036ec           rts 

L000036ee 0000 0000                or.b #$00,d0
L000036f2 0006 8dce                or.b #$ce,d6
L000036f6 0006 1b9c                or.b #$9c,d6

L000036fa 3038 36ee                move.w $36ee [0000],d0
L000036fe b078 36ee                cmp.w $36ee [0000],d0
L00003702 67fa                     beq.b #$fa == $000036fe (F)
L00003704 3238 36f0                move.w $36f0 [0000],d1
L00003708 b240                     cmp.w d0,d1
L0000370a 6aee                     bpl.b #$ee == $000036fa (T)
L0000370c 0640 0001                add.w #$0001,d0
L00003710 31c0 36f0                move.w d0,$36f0 [0000]
L00003714 4cf8 0003 36f2           movem.l $36f2,d0-d1
L0000371a c141                     exg.l d0,d1
L0000371c 48f8 0003 36f2           movem.l d0-d1,$36f2
L00003722 41f8 31d6                lea.l $31d6,a0
L00003726 223c 0000 1c8c           move.l #$00001c8c,d1
L0000372c 7e03                     moveq #$03,d7
L0000372e 3080                     move.w d0,(a0) [003c]
L00003730 5848                     addaq.w #$04,a0
L00003732 4840                     swap.w d0
L00003734 3080                     move.w d0,(a0) [003c]
L00003736 5848                     addaq.w #$04,a0
L00003738 4840                     swap.w d0
L0000373a d081                     add.l d1,d0
L0000373c 51cf fff0                dbf .w d7,#$fff0 == $0000372e (F)
L00003740 5278 632c                addq.w #$01,$632c [0000]
L00003744 4e75                     rts  == $6000001a


L00003746           lea.l   L00061b9c,a0                ; External Address
L0000374c           move.w   #$3917,d7
L00003750           clr.l   (a0)+
L00003752           dbf.w   d7,L00003750
L00003756           lea.l   L0005a36c,a0                ; External Address
L0000375c           move.w  #$1c8b,d7
L00003760           clr.l   (a0)+
L00003762           dbf.w   d7,L00003760
L00003766           rts 


L00003768 0a0a                     illegal
L0000376a 3030 3030                move.w (a0,d3.W,$30) == $00000d43 [001b],d0
L0000376e 00ff                     illegal
L00003770 41f9 0000 3768           lea.l $00003768,a0
L00003776 3081                     move.w d1,(a0) [003c]
L00003778 7403                     moveq #$03,d2
L0000377a 4241                     clr.w d1
L0000377c 3200                     move.w d0,d1
L0000377e 0241 000f                and.w #$000f,d1
L00003782 0c41 000a                cmp.w #$000a,d1
L00003786 6502                     bcs.b #$02 == $0000378a (F)
L00003788 5e41                     addq.w #$07,d1
L0000378a 0601 0030                add.b #$30,d1
L0000378e 1181 2002                move.b d1,(a0,d2.W,$02) == $00001409 [c8]
L00003792 e848                     lsr.w #$04,d0
L00003794 51ca ffe4                dbf .w d2,#$ffe4 == $0000377a (F)
L00003798 1018                     move.b (a0)+ [00],d0
L0000379a 0c00 00ff                cmp.b #$ff,d0
L0000379e 674e                     beq.b #$4e == $000037ee (F)
L000037a0 0240 00ff                and.w #$00ff,d0
L000037a4 c0fc 0028                mulu.w #$0028,d0
L000037a8 7200                     moveq #$00,d1
L000037aa 1218                     move.b (a0)+ [00],d1
L000037ac d041                     add.w d1,d0
L000037ae 227c 0007 c89a           movea.l #$0007c89a,a1
L000037b4 43f1 0002                lea.l (a1,d0.W,$02) == $0003deec,a1
L000037b8 7000                     moveq #$00,d0
L000037ba 1018                     move.b (a0)+ [00],d0
L000037bc 67da                     beq.b #$da == $00003798 (F)
L000037be 0440 0020                sub.w #$0020,d0
L000037c2 e748                     lsl.w #$03,d0
L000037c4 45f9 0000 37f0           lea.l $000037f0,a2
L000037ca 45f2 0000                lea.l (a2,d0.W,$00) == $0006b778,a2
L000037ce 7e07                     moveq #$07,d7
L000037d0 2649                     movea.l a1,a3
L000037d2 1692                     move.b (a2) [12],(a3) [71]
L000037d4 1752 0780                move.b (a2) [12],(a3,$0780) == $00064329 [24]
L000037d8 1752 0f00                move.b (a2) [12],(a3,$0f00) == $00064aa9 [41]
L000037dc 175a 1680                move.b (a2)+ [12],(a3,$1680) == $00065229 [c6]
L000037e0 47eb 0028                lea.l (a3,$0028) == $00063bd1,a3
L000037e4 51cf ffec                dbf .w d7,#$ffec == $000037d2 (F)
L000037e8 43e9 0001                lea.l (a1,$0001) == $0003ff5b,a1
L000037ec 60ca                     bra.b #$ca == $000037b8 (T)
L000037ee 4e75                     rts  == $6000001a
L000037f0 0000 0000                or.b #$00,d0
L000037f4 0000 0000                or.b #$00,d0
L000037f8 3030 3030                move.w (a0,d3.W,$30) == $00000d43 [001b],d0
L000037fc 0030 3000 3624           or.b #$00,(a0,d3.W[*8],$24) == $00000d37 (68020+) [7c]
L00003802 0000 0000                or.b #$00,d0
L00003806 0000 6c9a                or.b #$9a,d0
L0000380a bcfa 7428                cmpa.w (pc,$7428) == $0000ac34 [2000],a6
L0000380e 1000                     move.b d0,d0
L00003810 7ed6                     moveq #$d6,d7
L00003812 d07c 16d6                add.w #$16d6,d0
L00003816 fc00                     illegal
L00003818 82c6                     divu.w d6,d1
L0000381a fe54                     illegal
L0000381c 7c38                     moveq #$38,d6
L0000381e 1000                     move.b d0,d0
L00003820 2874 7474                movea.l (a4,d7.W[*4],$74) == $00bfe174 (68020+),a4
L00003824 7420                     moveq #$20,d2
L00003826 7400                     moveq #$00,d2
L00003828 1810                     move.b (a0) [00],d4
L0000382a 0000 0000                or.b #$00,d0
L0000382e 0000 3870                or.b #$70,d0
L00003832 7070                     moveq #$70,d0
L00003834 7070                     moveq #$70,d0
L00003836 3800                     move.w d0,d4
L00003838 381c                     move.w (a4)+,d4
L0000383a 1c1c                     move.b (a4)+,d6
L0000383c 1c1c                     move.b (a4)+,d6
L0000383e 3800                     move.w d0,d4
L00003840 1054                     illegal
L00003842 28d6                     move.l (a6),(a4)+
L00003844 2854                     movea.l (a4),a4
L00003846 1000                     move.b d0,d0
L00003848 0000 0808                or.b #$08,d0
L0000384c 3e08                     move.w a0,d7
L0000384e 0800 0000                btst.l #$0000,d0
L00003852 0000 0008                or.b #$08,d0
L00003856 0810 0000                btst.b #$0000,(a0) [00]
L0000385a 0000 3e00                or.b #$00,d0
L0000385e 0000 0000                or.b #$00,d0
L00003862 0000 0018                or.b #$18,d0
L00003866 1800                     move.b d0,d4
L00003868 3078 b078                movea.w $b078 [42b0],a0
L0000386c 3478 3000                movea.w $3000 [7000],a2
L00003870 7ce6                     moveq #$e6,d6
L00003872 e6e6                     ror.w -(a6)
L00003874 e6e6                     ror.w -(a6)
L00003876 7c00                     moveq #$00,d6
L00003878 7838                     moveq #$38,d4
L0000387a 3838 3838                move.w $3838 [381c],d4
L0000387e 3800                     move.w d0,d4
L00003880 7cce                     moveq #$ce,d6
L00003882 0e7c                     illegal
L00003884 c0ce                     illegal
L00003886 fe00                     illegal
L00003888 7cce                     moveq #$ce,d6
L0000388a 0e3c                     illegal
L0000388c 0ece                     illegal
L0000388e 7c00                     moveq #$00,d6
L00003890 7cdc                     moveq #$dc,d6
L00003892 dcdc                     adda.w (a4)+,a6
L00003894 fe1c                     illegal
L00003896 1c00                     move.b d0,d6
L00003898 fee6                     illegal
L0000389a e0fc                     illegal
L0000389c 06e6                     illegal
L0000389e 7c00                     moveq #$00,d6
L000038a0 7ce6                     moveq #$e6,d6
L000038a2 e0fc                     illegal
L000038a4 e6e6                     ror.w -(a6)
L000038a6 7c00                     moveq #$00,d6
L000038a8 fece                     illegal
L000038aa 0e1c 1c38                [ moves.b d1,(a4)+ ]
L000038ac 1c38 3800                move.b $3800 [36],d6
L000038b0 7ce6                     moveq #$e6,d6
L000038b2 e67c                     ror.w d3,d4
L000038b4 e6e6                     ror.w -(a6)
L000038b6 7c00                     moveq #$00,d6
L000038b8 7ce6                     moveq #$e6,d6
L000038ba e67e                     ror.w d3,d6
L000038bc 06e6                     illegal
L000038be 7c00                     moveq #$00,d6
L000038c0 0030 3000 0030           or.b #$00,(a0,d0.W,$30) == $ffffe9c0 [49]
L000038c6 3000                     move.w d0,d0
L000038c8 0030 3000 3030           or.b #$00,(a0,d3.W,$30) == $00000d43 [00]
L000038ce 6000 1c38                bra.w #$1c38 == $00005508 (T)
L000038d2 70e0                     moveq #$e0,d0
L000038d4 7038                     moveq #$38,d0
L000038d6 1c00                     move.b d0,d6
L000038d8 007c 7c00                or.w #$7c00,sr
L000038dc 7c7c                     moveq #$7c,d6
L000038de 0000 e070                or.b #$70,d0
L000038e2 381c                     move.w (a4)+,d4
L000038e4 3870 e000                movea.w (a0,a6.W,$00) == $fffffa00 [0048],a4
L000038e8 7cee                     moveq #$ee,d6
L000038ea ce3c 3000                and.b #$00,d7
L000038ee 3000                     move.w d0,d0
L000038f0 003c 4a56                or.b #$4a56,ccr
L000038f4 5e40                     addq.w #$07,d0
L000038f6 3c00                     move.w d0,d6
L000038f8 7ce6                     moveq #$e6,d6
L000038fa e6fe                     illegal
L000038fc e6e6                     ror.w -(a6)
L000038fe e600                     asr.b #$03,d0
L00003900 fce6                     illegal
L00003902 e6fc                     illegal
L00003904 e6e6                     ror.w -(a6)
L00003906 fc00                     illegal
L00003908 7ce6                     moveq #$e6,d6
L0000390a e6e0                     ror.w -(a0) [3000]
L0000390c e6e6                     ror.w -(a6)
L0000390e 7c00                     moveq #$00,d6
L00003910 fce6                     illegal
L00003912 e6e6                     ror.w -(a6)
L00003914 e6e6                     ror.w -(a6)
L00003916 fc00                     illegal
L00003918 fee0                     illegal
L0000391a e0fe                     illegal
L0000391c e0e0                     asr.w -(a0) [3000]
L0000391e fe00                     illegal
L00003920 fee0                     illegal
L00003922 e0fe                     illegal
L00003924 e0e0                     asr.w -(a0) [3000]
L00003926 e000                     asr.b #$08,d0
L00003928 7ce6                     moveq #$e6,d6
L0000392a e6e0                     ror.w -(a0) [3000]
L0000392c eee6                     illegal
L0000392e 7e00                     moveq #$00,d7
L00003930 e6e6                     ror.w -(a6)
L00003932 e6fe                     illegal
L00003934 e6e6                     ror.w -(a6)
L00003936 e600                     asr.b #$03,d0
L00003938 3838 3838                move.w $3838 [381c],d4
L0000393c 3838 3800                move.w $3800 [3624],d4
L00003940 0e0e                     illegal
L00003942 0e0e                     illegal
L00003944 0e0e                     illegal
L00003946 fc00                     illegal
L00003948 e6e6                     ror.w -(a6)
L0000394a e4f8 e4e6                roxr.w $e4e6 [2229]
L0000394e e600                     asr.b #$03,d0
L00003950 e0e0                     asr.w -(a0) [3000]
L00003952 e0e0                     asr.w -(a0) [3000]
L00003954 e0e0                     asr.w -(a0) [3000]
L00003956 fe00                     illegal
L00003958 fcda                     illegal
L0000395a dada                     adda.w (a2)+ [1241],a5
L0000395c dada                     adda.w (a2)+ [1241],a5
L0000395e da00                     add.b d0,d5
L00003960 fce6                     illegal
L00003962 e6e6                     ror.w -(a6)
L00003964 e6e6                     ror.w -(a6)
L00003966 e600                     asr.b #$03,d0
L00003968 7ce6                     moveq #$e6,d6
L0000396a e6e6                     ror.w -(a6)
L0000396c e6e6                     ror.w -(a6)
L0000396e 7c00                     moveq #$00,d6
L00003970 fce6                     illegal
L00003972 e6e6                     ror.w -(a6)
L00003974 fce0                     illegal
L00003976 e000                     asr.b #$08,d0
L00003978 7ce6                     moveq #$e6,d6
L0000397a e6e2                     ror.w -(a2) [93f1]
L0000397c ecee 7600 fce6           [ bfclr (a6,-$031a) == $00dfece6 {24:0} ]
L0000397e 7600                     moveq #$00,d3
L00003980 fce6                     illegal
L00003982 e6fc                     illegal
L00003984 e6e6                     ror.w -(a6)
L00003986 e600                     asr.b #$03,d0
L00003988 7ce6                     moveq #$e6,d6
L0000398a f87c                     illegal
L0000398c 1ee6                     move.b -(a6),(a7)+ [60]
L0000398e 7c00                     moveq #$00,d6
L00003990 fe38                     illegal
L00003992 3838 3838                move.w $3838 [381c],d4
L00003996 3800                     move.w d0,d4
L00003998 e6e6                     ror.w -(a6)
L0000399a e6e6                     ror.w -(a6)
L0000399c e6e6                     ror.w -(a6)
L0000399e 7c00                     moveq #$00,d6
L000039a0 e6e6                     ror.w -(a6)
L000039a2 e6e6                     ror.w -(a6)
L000039a4 e664                     asr.w d3,d4
L000039a6 3800                     move.w d0,d4
L000039a8 dada                     adda.w (a2)+ [1241],a5
L000039aa dada                     adda.w (a2)+ [1241],a5
L000039ac dada                     adda.w (a2)+ [1241],a5
L000039ae 7c00                     moveq #$00,d6
L000039b0 e6e6                     ror.w -(a6)
L000039b2 e638                     ror.b d3,d0
L000039b4 cece                     illegal
L000039b6 ce00                     and.b d0,d7
L000039b8 e6e6                     ror.w -(a6)
L000039ba e67c                     ror.w d3,d4
L000039bc 3838 3800                move.w $3800 [3624],d4
L000039c0 feee                     illegal
L000039c2 dc38 76e6                add.b $76e6 [0e],d6
L000039c6 fe00                     illegal
L000039c8 0000 0119                or.b #$19,d0
L000039cc 003a                     illegal
L000039ce 0097 0000 0000           or.l #$00000000,(a7) [6000001a]
L000039d4 0000 0000                or.b #$00,d0
L000039d8 0000 0000                or.b #$00,d0
L000039dc 0000 0000                or.b #$00,d0
L000039e0 00a0 0038 0046           or.l #$00380046,-(a0) [4ef83000]
L000039e6 0000 0000                or.b #$00,d0
L000039ea 0000 0000                or.b #$00,d0
L000039ee 0000 0000                or.b #$00,d0
L000039f2 0000 0000                or.b #$00,d0
L000039f6 00a0 0038 0046           or.l #$00380046,-(a0) [4ef83000]
L000039fc 0000 0000                or.b #$00,d0
L00003a00 0000 0000                or.b #$00,d0
L00003a04 0000 0000                or.b #$00,d0
L00003a08 0000 0000                or.b #$00,d0
L00003a0c 00a0 0038 0046           or.l #$00380046,-(a0) [4ef83000]
L00003a12 0000 0000                or.b #$00,d0
L00003a16 0000 0000                or.b #$00,d0
L00003a1a 0000 0000                or.b #$00,d0
L00003a1e 0000 0000                or.b #$00,d0
L00003a22 00a0 0038 0046           or.l #$00380046,-(a0) [4ef83000]
L00003a28 0000 0000                or.b #$00,d0
L00003a2c 0000 0000                or.b #$00,d0
L00003a30 0000 0000                or.b #$00,d0
L00003a34 0000 0000                or.b #$00,d0
L00003a38 00a0 0038 0046           or.l #$00380046,-(a0) [4ef83000]
L00003a3e 0000 0000                or.b #$00,d0
L00003a42 0000 0000                or.b #$00,d0
L00003a46 0000 0000                or.b #$00,d0
L00003a4a 0000 0000                or.b #$00,d0
L00003a4e 00a0 0038 0046           or.l #$00380046,-(a0) [4ef83000]
L00003a54 0000 0000                or.b #$00,d0
L00003a58 0000 0000                or.b #$00,d0
L00003a5c 0000 0000                or.b #$00,d0
L00003a60 0000 0000                or.b #$00,d0
L00003a64 00a0 0038 0046           or.l #$00380046,-(a0) [4ef83000]
L00003a6a 0000 0000                or.b #$00,d0
L00003a6e 0000 0000                or.b #$00,d0
L00003a72 0000 0000                or.b #$00,d0
L00003a76 0000 0000                or.b #$00,d0
L00003a7a 00a0 0038 0046           or.l #$00380046,-(a0) [4ef83000]
L00003a80 0000 0000                or.b #$00,d0
L00003a84 0000 0000                or.b #$00,d0
L00003a88 0000 0000                or.b #$00,d0
L00003a8c 0000 0000                or.b #$00,d0
L00003a90 00a0 0038 0046           or.l #$00380046,-(a0) [4ef83000]
L00003a96 0000 0000                or.b #$00,d0
L00003a9a 0000 0000                or.b #$00,d0
L00003a9e 0000 0000                or.b #$00,d0
L00003aa2 0000 5009                or.b #$09,d0
L00003aa6 4158                     illegal
L00003aa8 4953                     illegal
L00003aaa 2043                     movea.l d3,a0
L00003aac 4845                     swap.w d5
L00003aae 4d49                     illegal
L00003ab0 4341                     illegal
L00003ab2 4c20 4641                [ mulu.l -(a0),d1:d4 ]
L00003ab4 4641                     not.w d1
L00003ab6 4354                     illegal
L00003ab8 4f52                     illegal
L00003aba 5900                     subq.b #$04,d0
L00003abc ff40                     illegal
L00003abe 0e4a                     illegal
L00003ac0 4143                     illegal
L00003ac2 4b20                     [ chk.l -(a0),d5 ]
L00003ac4 4953                     illegal
L00003ac6 2044                     movea.l d4,a0
L00003ac8 4541                     illegal
L00003aca 4400                     neg.b d0
L00003acc ff60                     illegal
L00003ace 0b54                     bchg.b d5,(a4)
L00003ad0 4845                     swap.w d5
L00003ad2 204a                     movea.l a2,a0
L00003ad4 4f4b                     illegal
L00003ad6 4552                     illegal
L00003ad8 204c                     movea.l a4,a0
L00003ada 4956                     illegal
L00003adc 4553                     illegal
L00003ade 2e2e 2e00                move.l (a6,$2e00) == $00e01e00 [f09a4e75],d7
L00003ae2 ffb9                     illegal



L00003ae4           clr.l   L000036ee
L00003aea           bsr.w   L000036fa
L00003aee           bsr.w   L000058e2
L00003af2           jsr     $00048000               ; External Address $48000
L00003af8           clr.w   L62fc
L00003afc           jsr     L0007c838
L00003b02           clr.w   L00006318
L00003b06           clr.l   L000036ee
L00003b0c           bsr.w   L00003746
L00003b10           move.w  #$0800,d0
L00003b14           jsr     $0007c80e               ; Panel - Function
L00003b1a           jsr     $0007c854               ; Panel - Function
L00003b20           bsr.w   #$021e == $00003d40
L00003b24           lea.l   $0000807c,a0            ; External Address $807c
L00003b2a           movea.l L00005f64,a5
L00003b30           movem.w (a5)+,d2-d4
L00003b34           tst.w   d3
L00003b36           beq.b   L00003b4e
L00003b38           move.b  d2,$01(a0,d3.W)
L00003b3c           lsr.w   #$08,d2
L00003b3e           move.b  d2,$00(a0,d3.W)
L00003b42           move.b  d4,$03(a0,d3.W)
L00003b46           lsr.w   #$08,d4
L00003b48           move.b  d4,$02(a0,d3.W)
L00003b4c           bra.b   L00003b30

L00003b4e           move.l  #$00005fc4,L00005f64
L00003b58           lea.l   $4894,a0
L00003b5c           moveq   #$27,d7
L00003b5e           clr.l   (a0)+
L00003b60           dbf.w   d7,L00003b5e

L00003b64           lea.l   L0000642e,a0
L00003b68           bclr.b  #$0007,(a0)
L00003b6c           move.w  $0004(a0),d0
L00003b70           mulu.w  #$0006,d0
L00003b74           lea.l   $06(a0,d0.W),a0
L00003b78           cmpa.w  #$6722,a0
L00003b7c           bcs.b   L00003b68
L00003b7e           bclr.b  #$0007,$0004(a0)
L00003b84           addaq.w #$06,a0
L00003b86           cmpa.w  #$67a0,a0
L00003b8a           bcs.b   L00003b7e
L00003b8c           lea.l   L000039c8,a0
L00003b90           moveq   #$6d,d7
L00003b92           clr.w   (a0)+ [003c]
L00003b94           dbf.w   d7,L00003b92

L00003b98           clr.w   L000062ee
L00003b9c           lea.l   L000063d3,a0
L00003ba0           bsr.w   L00005438
L00003ba4           move.w  #$4c3e,L00003c92
L00003baa           lea.l   L000067a0,a0
L00003bae           move.w  L000062fc,d6
L00003bb2           moveq   #$06,d7
L00003bb4           lea.l   L000067bc,a1
L00003bb8           move.w  (a0)+,(a1)+
L00003bba           dbf.w   d7,L00003bb8
L00003bbe           dbf.w   d6,L00003bb2
L00003bc2           lea.l   L00003aa4,a0
L00003bc6           bsr.w   L000067ca
L00003bca           bsr.w   L000036fa
L00003bce           bsr.w   L000058aa
L00003bd2           bsr.w   L00004b62
L00003bd6           bsr.w   L000055c4
L00003bda           moveq   #$32,d0
L00003bdc           bsr.w   L00005e8c
L00003be0           btst.b  #$0000,$0007c875            ; Panel - 
L00003be8           bne.b   L00003bf2
L00003bea           moveq   #$01,d0
L00003bec           jsr     $00048010                   ; External Address $48010
L00003bf2           bsr.w   L00003cc0
L00003bf6           clr.l   L000036ee
L00003bfa           bsr.w   L0000365a
L00003bfe           beq.b   L00003c5a
L00003c00           cmp.w   #$0081,d0
L00003c04           bne.b   L00003c22
L00003c06           bsr.w   L0000365a
L00003c0a           beq.b   L00003c06
L00003c0c           cmp.w   #$001b,d0
L00003c10           bne.b   L00003c22
L00003c12           bsr.w   L00003cbc
L00003c16           bset.b  #$0005,$0007c875            ; Panel - 
L00003c1e           bra.w   L00004e00
L00003c22           cmp.w   #$0082,d0
L00003c26           bne.b   L00003c48
L00003c28           bchg.b  #$0000,$0007c875            ; Panel - 
L00003c30           bne.b   L00003c3c
L00003c32           jsr     $00048008                   ; External Address $48008
L00003c38           bra.w   L00003c5a
L00003c3c           moveq   #$01,d0
L00003c3e           jsr     $00048010                   ; External Address $48010
L00003c44           bra.w   L00003c5a

L00003c48           cmp.w   #$008a,d0
L00003c4c           bne.b   L00003c5a
L00003c4e           btst.b  #$0007,$0007c875            ; Panel - 
L00003c56           bne.w   L00005e3a
L00003c5a           btst.b  #$0000,$0007c874            ; Panel - 
L00003c62           bne.b   L00003c80
L00003c64           jsr     $0007c800                   ; Panel - 
L00003c6a           jsr     $0007c800                   ; Panel - 
L00003c70           btst.b  #$0000,$0007c874            ; Panel - 
L00003c78           beq.b   L00003c80
L00003c7a           moveq   #$01,d6
L00003c7c           bsr.w   L00004ce4
L00003c80           clr.l   d0
L00003c82           clr.l   d1
L00003c84           bsr.w   L00005854
L00003c88           movem.w $67c2,d0-d1
L00003c8e           jsr     L00004c3e
L00003c94           bsr.w   L00004936
L00003c98           bsr.w   L00003dd4
L00003c9c           bsr.w   L00003dfe
L00003ca0           bsr.w   L00004b62
L00003ca4           bsr.w   L000055c4
L00003ca8           bsr.w   L00003ee6
L00003cac           bsr.w   L00004658
L00003cb0           bsr.w   L000045fe
L00003cb4           bsr.w   L000036fa
L00003cb8           bra.w   L00003bfa

L00003cbc           bsr.w   L00004e28
L00003cc0           move.w  #$002a,d0
L00003cc4           move.w  #$00ae,d1
L00003cc8           movem.l L000036f2,a0-a1
L00003cce           clr.w   d2
L00003cd0           moveq   #$7f,d3
L00003cd2           and.w   d2,d3
L00003cd4           moveq   #$0f,d5
L00003cd6           lsr.w   #$01,d3
L00003cd8           bcc.b   L00003cdc
L00003cda           moveq   #$f0,d5
L00003cdc           cmp.w   d0,d3
L00003cde           bcc.b   L00003d32
L00003ce0           move.w  d2,d4
L00003ce2           lsr.w   #$05,d4
L00003ce4           and.w   #$00fc,d4
L00003ce8           cmp.w   d1,d4
L00003cea           bcc.b   L00003d32
L00003cec           mulu.w  d0,d4
L00003cee           add.w   d3,d4
L00003cf0           move.w  d2,-(a7)
L00003cf2           move.w  d0,d3
L00003cf4           mulu.w  d1,d3
L00003cf6           moveq   #$03,d7
L00003cf8           move.w  d4,-(a7)
L00003cfa           moveq   #$03,d2
L00003cfc           move.w  $0002(a7),d6
L00003d00           cmp.w   #$1580,d6
L00003d04           bcs.b   L00003d08
L00003d06           moveq   #$01,d2
L00003d08           move.b  d5,d6
L00003d0a           not.w   d6
L00003d0c           and.b   $00(a0,d4.W),d6
L00003d10           move.b  d6,$00(a0,d4.W)
L00003d14           move.b  d5,d6
L00003d16           and.b   $00(a1,d4.W),d6
L00003d1a           or.b    $00(a0,d4.W),d6
L00003d1e           move.b  d6,$00(a0,d4.W)
L00003d22           add.w   d0,d4
L00003d24           dbf.w   d2,L00003d08

L00003d28           move.w  (a7)+,d4
L00003d2a           add.w   d3,d4
L00003d2c           dbf.w   d7,L00003cf8

L00003d30           move.w  (a7)+,d2
L00003d32           mulu.w  #$5555,d2
L00003d36           addq.w  #$01,d2
L00003d38           and.w   #$1fff,d2
L00003d3c           bne.b   L00003cd0
L00003d3e           rts

L00003d40           moveq   #$0f,d7
L00003d42           lea.l   $325e,a0
L00003d46           lea.l   $32a0,a1
L00003d4a           moveq   #$0f,d6
L00003d4c           move.w  (a0),d0
L00003d4e           move.w  (a1)+,d1
L00003d50           eor.w   d0,d1
L00003d52           moveq   #$0f,d2
L00003d54           and.w   d1,d2
L00003d56           beq.b   L00003d5a
L00003d58           addq.w  #$01,d0
L00003d5a           moveq   #$f0,d2
L00003d5c           and.b   d1,d2
L00003d5e           beq.b   L00003d64
L00003d60           add.w   #$0010,d0
L00003d64           and.w   #$0f00,d1
L00003d68           beq.b   L00003d6e
L00003d6a           add.w   #$0100,d0
L00003d6e           move.w  d0,(a0)
L00003d70           addaq.w #$04,a0
L00003d72           dbf.w   d6,L00003d4c

L00003d76           move.w  L000036ee,d0
L00003d7c           addq.w  #$04,d0
L00003d7e           cmp.w   L000036ee,d0
L00003d84           bne.b   L00003d7e
L00003d86           dbf.w   d7,L00003d42
L00003d8a           rts

L00003d8c           moveq   #$0f,d7
L00003d8e           lea.l   L0000325e,a0
L00003d92           moveq   #$0f,d6
L00003d94           move.w  (a0),d0
L00003d96           moveq   #$0f,d1
L00003d98           and.w   d0,d1
L00003d9a           beq.b   L00003d9e
L00003d9c           subq.w  #$01,d0
L00003d9e           move.w  #$00f0,d1
L00003da2           and.w   d0,d1
L00003da4           beq.b   L00003daa
L00003da6           sub.w   #$0010,d0
L00003daa           move.w  #$0f00,d1
L00003dae           and.w   d0,d1
L00003db0           beq.b   L00003db6
L00003db2           sub.w   #$0100,d0
L00003db6           move.w  d0,(a0)
L00003db8           addaq.w #$04,a0
L00003dba           dbf.w   d6,L00003d94

L00003dbe           move.w  L000036ee,d0
L00003dc4           addq.w  #$04,d0
L00003dc6           cmp.w   L000036ee,d0
L00003dcc           bne.b   L00003dc6
L00003dce           dbf.w   d7,L00003d8e
L00003dd2           rts

L00003dd4           clr.l   d0
L00003dd6           move.w  L000067bc,d1
L00003dda           sub.w   L000067c0,d1
L00003dde           bls.b   L00003dfc
L00003de0           move.w  L000067bc,L000067c0
L00003de6           lsl.w   #$04,d1
L00003de8           move.b  d1,d0
L00003dea           bra.b   L00003df0
L00003dec           add.w   #$0100,d0
L00003df0           sub.w   #$0064,d1
L00003df4           bcc.b   L00003dec
L00003df6           jmp     $0007c82a               ; Panel - 
L00003dfc           rts     

L00003dfe           movem.w L000067bc,d0-d1
L00003e04           lea.l   L0000642e,a0
L00003e08           movem.w (a0)+,d2-d3
L00003e0c           sub.w   d0,d2
L00003e0e           cmp.w   #$0098,d2
L00003e12           bcc.b   L00003e30
L00003e14           sub.w   d1,d3
L00003e16           cmp.w   #$0050,d3
L00003e1a           bcc.b   L00003e30
L00003e1c           bset.b  #$0007,-$0004(a0)
L00003e22           move.w  (a0)+,d7
L00003e24           subq.w  #$01,d7
L00003e26           bsr.w   L00003e74
L00003e2a           dbf.w   d7,L00003e26
L00003e2e           bra.b   L00003e3c

L00003e30           move.w  (a0),d2
L00003e32           add.w   d2,d2
L00003e34           add.w   (a0),d2
L00003e36           add.w   d2,d2
L00003e38           lea.l   $02(a0,d2.W),a0
L00003e3c           cmpa.w  #$6722,a0
L00003e40           bcs.b   L00003e08
L00003e42           sub.w   #$0010,d0
L00003e46           subq.w  #$08,d1
L00003e48           movem.w $0002(a0),d2-d3
L00003e4e           sub.w   d0,d2
L00003e50           cmp.w   #$00c0,d2
L00003e54           bcc.b   L00003e6a
L00003e56           sub.w   d1,d3
L00003e58           cmp.w   #$0060,d3
L00003e5c           bcc.b   L00003e6a
L00003e5e           bsr.w   L00003e74
L00003e62           bset.b  #$0007,-$0002(a0)
L00003e68           bra.b   L00003e6c
L00003e6a           addaq.w #$06,a0
L00003e6c           cmpa.w  #$67a0,a0
L00003e70           bcs.b   L00003e48
L00003e72           rts

L00003e74           movem.w (a0)+,d2-d4
L00003e78           cmp.w   $00000022,d0
L00003e7e           beq.b   L00003e7e
L00003e80           nop
L00003e82           lea.l   L000039c8,a6
L00003e86           moveq   #$09,d6
L00003e88           tst.w   (a6)
L00003e8a           beq.b   L00003e96
L00003e8c           lea.l   $0016(a6),a6
L00003e90           dbf.w   d6,L00003e88
L00003e94           rts

L00003e96           move.w  a0,$0014(a6)
L00003e9a           bset.l  #$000f,d2
L00003e9e           movem.w d2-d4,(a6)
L00003ea2           clr.l   $0008(a6)
L00003ea6           bclr.l  #$000f,d2
L00003eaa           clr.l   $0010(a6)
L00003eae           lea.l   L00005a7a,a5
L00003eb2           cmp.w   (a5)+,d2
L00003eb4           bcs.b   L00003eba
L00003eb6           addaq.w #$02,a5
L00003eb8           bra.b   L00003eb2
L00003eba           move.w  (a5),d3
L00003ebc           cmp.w   #$0046,d3
L00003ec0           bne.b   L00003ed0
L00003ec2           bsr.w   L00003ed6
L00003ec6           btst.l  #$000c,d2
L00003eca           beq.b   L00003ed0
L00003ecc           move.w  #$009e,d3
L00003ed0           move.w  d3,$0006(a6)
L00003ed4           rts

L00003ed6           movea.l L00006322,a1
L00003edc           move.w  (a1)+,d2
L00003ede           move.l  a1,L00006322
L00003ee4           rts

L00003ee6           lea.l   L000039c8,a6
L00003eea           moveq   #$09,d7
L00003eec           move.w  (a6),d6
L00003eee           beq.w   L00003fa8
L00003ef2           movem.w $0002(a6),d0-d1
L00003ef8           move.w  d0,d4
L00003efa           movem.w L000067bc,d2-d3
L00003f00           sub.w   d2,d0
L00003f02           sub.w   d3,d1
L00003f04           cmp.w   #$0140,d0
L00003f08           bcs.b   L00003f10
L00003f0a           cmp.w   #$ff60,d0
L00003f0e           bcs.b   L00003f2e
L00003f10           cmp.w   #$00a0,d1
L00003f14           bcs.b   L00003f1c
L00003f16           cmp.w   #$ffb0,d1
L00003f1a           bcs.b   L00003f2e
L00003f1c           bclr.b  #$0007,(a6)
L00003f20           beq.b   L00003f48
L00003f22           cmp.w   #$0050,d1
L00003f26           bcc.b   L00003f48
L00003f28           cmp.w   #$00a0,d0
L00003f2c           bcc.b   L00003f48
L00003f2e           cmp.w   #$0014,d6
L00003f32           bcs.b   L00003f44
L00003f34           lea.l   $00000000,a0                    ; External Address $00000000
L00003f38           movea.l d0,a0
L00003f3a           movea.w $0014(a6),a0
L00003f3e           bclr.b  #$0007,-$0002(a0)
L00003f44           clr.w   (a6)
L00003f46           bra.b   L00003fa8
L00003f48           lea.l   L00005a9a,a0
L00003f4c           add.w   d6,d6
L00003f4e           adda.w  d6,a0
L00003f50           movea.w (a0),a0
L00003f52           move.w  d7,-(a7)
L00003f54           jsr     (a0)
L00003f56           movem.w $000e(a6),d0-d2
L00003f5c           sub.w   L000067c2,d0
L00003f60           addq.w  #$06,d0
L00003f62           cmp.w   #$000d,d0
L00003f66           bcc.b   L00003fa6
L00003f68           sub.w   L000062f0,d1
L00003f6c           subq.w  #$06,d1
L00003f6e           bmi.b   L00003fa6
L00003f70           sub.w   L000067c4,d2
L00003f74           bpl.b   L00003fa6
L00003f76           move.w  (a6),d0
L00003f78           subq.w  #$02,d0
L00003f7a           bmi.b   L00003fa6
L00003f7c           move.w  #$0001,(a6)
L00003f80           moveq   #$0a,d0
L00003f82           jsr     $00048014               ; External Address $48014
L00003f88           move.w  #$fffe,$000a(a6)
L00003f8e           tst.w   L000062fa
L00003f92           bmi.b   L00003fa6
L00003f94           tst.w   L00006318
L00003f98           beq.b   L00003fa0
L00003f9a           tst.w   L000062f4
L00003f9e           bne.b   L00003fa6
L00003fa0           moveq   #$05,d6
L00003fa2           bsr.w   L00004ccc
L00003fa6           move.w  (a7)+,d7
L00003fa8           lea.l   $0016(a6),a6
L00003fac           dbf.w   d7,L00003eec
L00003fb0           rts

L00003fb2           add.w   #$0002,(a6)
L00003fb6           movem.w L000067c2,d2
L00003fbc           move.w  L000062f0,d3
L00003fc0           add.w   #$0015,d3
L00003fc4           sub.w   d1,d3
L00003fc6           asl.w   #$03,d3
L00003fc8           ext.l   d3
L00003fca           sub.w   d0,d2
L00003fcc           bpl.b   L00003fd0
L00003fce           neg.w   d2
L00003fd0           beq.b   L00003fd4
L00003fd2           divs.w  d2,d3
L00003fd4           asr.w   #$02,d2
L00003fd6           sub.w   d2,d3
L00003fd8           bsr.w   L0000463e
L00003fdc           cmp.w   #$0008,d3
L00003fe0           bcs.b   L00003ff0
L00003fe2           bmi.b   L00003fe8
L00003fe4           moveq   #$08,d3
L00003fe6           bra.b   L00003ff0
L00003fe8           cmp.w   #$ffe8,d3
L00003fec           bcc.b   L00003ff0
L00003fee           moveq   #$e8,d3
L00003ff0           move.w  d3,$0006(a0)
L00003ff4           cmp.w   #$0073,d1
L00003ff8           bpl.b   L0000400a
L00003ffa           movem.w d0-d1,-(a7)
L00003ffe           moveq   #$09,d0
L00004000           jsr     $00048014               ; External Address $48014
L00004006           movem.w (a7)+,d0-d1
L0000400a           rts

L0000400c           move.w  $0008(a6),d2
L00004010           cmp.w   #$0007,d2
L00004014           bne.b   L0000402e
L00004016           subq.w  #$05,d0
L00004018           bsr.w   L00003fb2
L0000401c           move.w  #$000d,(a0)+
L00004020           move.w  d1,d3
L00004022           sub.w   #$0011,d3
L00004026           movem.w d0/d3,(a0)
L0000402a           addq.w  #$05,d0
L0000402c           moveq   #$08,d2
L0000402e           addq.w  #$01,$0008(a6)
L00004032           lea.l   L000044d4,a5
L00004036           and.w   #$00fe,d2
L0000403a           adda.w  d2,a5
L0000403c           add.w   d2,d2
L0000403e           adda.w  d2,a5
L00004040           bra.w   L0000457c
L00004044           lea.l   L000044ec,a5
L00004048           bsr.w   L0000457c
L0000404c           subq.w  #$01,$0008(a6)
L00004050           bne.b   L0000405c
L00004052           move.w  #$0020,$0008(a6)
L00004058           move.   w #$0002,(a6)
L0000405c           rts

L0000405e           cmp.w   #$ffc0,d0
L00004062           bmi.b   L000040b0
L00004064           subq.w  #$01,$0008(a6)
L00004068           bpl.b   L00004082
L0000406a           move.w  d0,d2
L0000406c           sub.w   L000067c2,d2
L00004070           cmp.w   #$0030,d2
L00004074           bcc.b   L00004082
L00004076           clr.w   $0008(a6)
L0000407a           move.w  #$0005,(a6)
L0000407e           bra.w   L0000431e
L00004082           moveq   #$07,d2
L00004084           and.w   d4,d2
L00004086           bne.w   L00004318
L0000408a           sub.w   #$000c,d0
L0000408e           bsr.w   L000055a0
L00004092           add.w   #$000c,d0
L00004096           cmp.b   #$79,d2
L0000409a           bcc.w   L00004318
L0000409e           tst.w   $0008(a6)
L000040a2           bpl.b   L000040b0
L000040a4           move.w  d0,d2
L000040a6           sub.w   L000067c2,d2
L000040aa           cmp.w   #$0040,d2
L000040ae           bcs.b   L00004076
L000040b0           move.w  #$0002,(a6)
L000040b4           bra.w   L0000431e
L000040b8           move.w  $0008(a6),d2
L000040bc           cmp.w   #$0007,d2
L000040c0           bne.b   L000040da
L000040c2           addq.w  #$05,d0
L000040c4           bsr.w   L00003fb2
L000040c8           move.w  #$000c,(a0)+
L000040cc           move.w  d1,d3
L000040ce           sub.w   #$0011,d3
L000040d2           movem.w d0/d3,(a0)
L000040d6           subq.w  #$05,d0
L000040d8           moveq   #$08,d2
L000040da           addq.w  #$01,$0008(a6)
L000040de           lea.l   L000044f2,a5
L000040e2           and.w   #$00fe,d2
L000040e6           adda.w  d2,a5
L000040e8           add.w   d2,d2
L000040ea           adda.w  d2,a5
L000040ec           bra.w   L0000457c
L000040f0           lea.l   L0000450a,a5
L000040f4           bsr.w   L0000457c
L000040f8           subq.w  #$01,$0008(a6)
L000040fc           bne.b   L00004108
L000040fe           move.w  #$0020,$0008(a6)
L00004104           move.w  #$0003,(a6)
L00004108           rts

L0000410a           cmp.w   #$00e0,d0
L0000410e           bpl.b   L00004158
L00004110           subq.w  #$01,$0008(a6)
L00004114           bpl.b   L0000412e
L00004116           move.w  L000067c2,d2
L0000411a           sub.w   d0,d2
L0000411c           cmp.w   #$0030,d2
L00004120           bcc.b   L0000412e
L00004122           clr.w   $0008(a6)
L00004126           move.w  #$0004,(a6)
L0000412a           bra.w   L00004248
L0000412e           moveq   #$07,d2
L00004130           and.w   d4,d2
L00004132           bne.w   L00004242
L00004136           addq.w  #$08,d0
L00004138           bsr.w   L000055a0
L0000413c           subq.w  #$08,d0
L0000413e           cmp.b   #$79,d2
L00004142           bcc.w   L00004242
L00004146           tst.w   $0008(a6)
L0000414a           bpl.b   L00004158
L0000414c           move.w  L000067c2,d2
L00004150           sub.w   d0,d2
L00004152           cmp.w   #$0040,d2
L00004156           bcs.b   L00004122
L00004158           move.w  #$0003,(a6)
L0000415c           bra.w   L00004248
L00004160           move.w  L000067c4,d5
L00004164           sub.w   d1,d5
L00004166           add.w   #$0010,d5
L0000416a           cmp.w   #$0020,d5
L0000416e           bcs.b   L000041a0
L00004170           bpl.b   L00004184
L00004172           move.w  $00008002,d2        ; External Address
L00004178           add.w   d2,d2
L0000417a           add.w   d2,d2
L0000417c           sub.w   d2,d3
L0000417e           clr.w   d2
L00004180           move.b  $00(a0,d3.W),d2
L00004184           cmp.b   #$85,d2
L00004188           bcs.b   L000041a0
L0000418a           move.w  #$0002,$0008(a6)
L00004190           move.w  #$000d,$000c(a6)
L00004196           subq.w  #$08,d5
L00004198           bpl.b   L000041a0
L0000419a           move.w  #$000c,$000c(a6)
L000041a0           rts

L000041a2           move.w  d4,d2
L000041a4           addq.w  #$04,d2
L000041a6           and.w   #$0007,d2
L000041aa           bne.w   L00004242
L000041ae           cmp.w   #$0140,d0
L000041b2           bpl.b   L000041c2
L000041b4           addq.w  #$07,d0
L000041b6           bsr.w   L000055a0
L000041ba           subq.w  #$07,d0
L000041bc           cmp.b   #$79,d2
L000041c0           bcc.b   L000041ce
L000041c2           move.w  #$000f,(a6)
L000041c6           clr.w   $0008(a6)
L000041ca           bra.w   L00004242
L000041ce           bsr.w   L00004160
L000041d2           subq.w  #$01,$0008(a6)
L000041d6           beq.w   L00004348
L000041da           bpl.b   L00004242
L000041dc           move.w  L000067c2,d2
L000041e0           sub.w   d0,d2
L000041e2           bmi.b   L00004242
L000041e4           cmp.w   #$0020,d5
L000041e8           bpl.b   L00004224
L000041ea           bcc.b   L00004202
L000041ec           cmp.w   #$0038,d2
L000041f0           bcc.b   L00004242
L000041f2           move.w  #$0010,$000c(a6)
L000041f8           move.l  #$00010000,$0008(a6)        ; External Address?
L00004200           bra.b   L00004242
L00004202           sub.w   #$0010,d5
L00004206           add.w   d5,d2
L00004208           ble.b   L00004242
L0000420a           subq.w  #$04,d2
L0000420c           lsr.w   #$03,d2
L0000420e           addq.w  #$01,d2
L00004210           cmp.w   #$0008,d2
L00004214           bcc.b   L00004242
L00004216           move.w  d2,$0008(a6)
L0000421a           move.l  #$00050010,$000a(a6)        ; External Address?
L00004222           bra.b   L00004242
L00004224           subq.w  #$08,d5
L00004226           sub.w   d5,d2
L00004228           bls.b   L00004242
L0000422a           subq.w  #$04,d2
L0000422c           lsr.w   #$03,d2
L0000422e           addq.w  #$01,d2
L00004230           cmp.w   #$0008,d2
L00004234           bcc.b   L00004242
L00004236           move.w d2,$0008(a6)
L0000423a           move.l #$00070010,$000a(a6)         ; External Address?
L00004242           addq.w #$01,d4
L00004244           move.w d4,$0002(a6)
L00004248           and.w   #$000e,d4
L0000424c           lsr.w   #$01,d4
L0000424e           move.w  d4,-(a7)
L00004250           addq.w  #$08,d4
L00004252           move.w  d4,d2
L00004254           bsr.w   L000045bc
L00004258           move.w  (a7)+,d2
L0000425a           lsr.w   #$01,d2
L0000425c           bne.b   L00004260
L0000425e           addq.w  #$02,d2
L00004260           addq.w  #$04,d2
L00004262           bsr.w   L000045bc
L00004266           moveq   #$04,d2
L00004268           bra.w   L0000458a
L0000426c           move.w  d4,d2
L0000426e           addq.w  #$04,d2
L00004270           and.w   #$0007,d2
L00004274           bne.w   L00004318
L00004278           cmp.w   #$ff60,d0
L0000427c           bmi.b   L00004298
L0000427e           subq.w  #$07,d0
L00004280           bsr.w   L000055a0
L00004284           addq.w  #$07,d0
L00004286           cmp.b   #$79,d2
L0000428a           bcc.b   L000042a4
L0000428c           move.w  $0006(a6),d2
L00004290           cmp.w   #$0085,d2
L00004294           beq.w   L0000440a
L00004298           move.w  #$000e,(a6)
L0000429c           clr.w   $0008(a6)
L000042a0           bra.w   L00004318
L000042a4           bsr.w   L00004160
L000042a8           subq.w  #$01,$0008(a6)
L000042ac           beq.w   L00004348
L000042b0           bpl.b   L00004318
L000042b2           move.w  d0,d2
L000042b4           sub.w   L000067c2,d2
L000042b8           bmi.b   L00004318
L000042ba           cmp.w   #$0020,d5
L000042be           bpl.b   L000042fa
L000042c0           bcc.b   L000042d8
L000042c2           cmp.w   #$0038,d2
L000042c6           bcc.b   L00004318
L000042c8           move.w  #$0010,$000c(a6)
L000042ce           move.l  #$00010001,$0008(a6)            ; External Address ?
L000042d6           bra.b   L00004318
L000042d8           sub.w   #$0010,d5
L000042dc           add.w   d5,d2
L000042de           ble.b   L00004318
L000042e0           subq.w  #$04,d2
L000042e2           lsr.w   #$03,d2
L000042e4           addq.w  #$01,d2
L000042e6           cmp.w   #$0008,d2
L000042ea           bcc.b   L00004318
L000042ec           move.w  d2,$0008(a6)
L000042f0           move.l  #$00040010,$000a(a6)            ; External Address ?
L000042f8           bra.b   L00004318
L000042fa           subq.w  #$08,d5
L000042fc           sub.w   d5,d2
L000042fe           bls.b   L00004318
L00004300           subq.w  #$04,d2
L00004302           lsr.w   #$03,d2
L00004304           addq.w  #$01,d2
L00004306           cmp.w   #$0008,d2
L0000430a           bcc.b   L00004318
L0000430c           move.w  d2,$0008(a6)
L00004310           move.l  #$00060010,$000a(a6)            ; External Address ?
L00004318           subq.w  #$01,d4
L0000431a           move.w  d4,$0002(a6)
L0000431e           and.w   #$000e,d4
L00004322           lsr.w   #$01,d4
L00004324           eor.w   #$e007,d4
L00004328           move.w  d4,-(a7)
L0000432a           addq.w  #$08,d4
L0000432c           move.w  d4,d2
L0000432e           bsr.w   L000045bc
L00004332           move.w  (a7)+,d2
L00004334           lsr.b   #$01,d2
L00004336           bne.b   L0000433a
L00004338           addq.w  #$02,d2
L0000433a           addq.w  #$04,d2
L0000433c           bsr.w   L000045bc
L00004340           move.w  #$e004,d2
L00004344           bra.w   L0000458a
L00004348           move.w  $000c(a6),d6
L0000434c           move.w  d6,(a6)
L0000434e           cmp.w   #$0010,d6
L00004352           bne.b   L00004374
L00004354           move.w  #$0002,$0008(a6)
L0000435a           move.w  $000a(a6),d2
L0000435e           cmp.w   #$0002,d2
L00004362           bcc.b   L00004374
L00004364           move.w  $0012(a6),d2
L00004368           addq.w  #$04,d2
L0000436a           sub.w   L000062f0,d2
L0000436e           bpl.b   L00004374
L00004370           addq.w  #$02,$000a(a6)
L00004374           lea.l   L00005a9a,a0
L00004378           add.w   d6,d6
L0000437a           adda.w  d6,a0
L0000437c           movea.w (a0),a0
L0000437e           jmp     (a0)
L00004380           move.w  $0004(a6),d4
L00004384           btst.b  #$0000,L0000632d
L0000438a           bne.b   L000043ce
L0000438c           addq.w  #$01,d4
L0000438e           move.w  d4,$0004(a6)
L00004392           addq.w  #$01,d1
L00004394           and.w   #$0007,d4
L00004398           bne.b   L000043ce
L0000439a           bsr.w   L000055a0
L0000439e           bra.b   L000043c6
L000043a0           move.w  $0004(a6),d4
L000043a4           btst.b  #$0000,L0000632d
L000043aa           bne.b   L000043ce
L000043ac           subq.w  #$01,d4
L000043ae           move.w  d4,$0004(a6)
L000043b2           subq.w  #$01,d1
L000043b4           and.w   #$0007,d4
L000043b8           bne.b   L000043ce
L000043ba           sub.w   #$0018,d1
L000043be           bsr.w   L000055a0
L000043c2           add.w   #$0018,d1
L000043c6           cmp.b   #$85,d2
L000043ca           bcc.b   L000043ce
L000043cc           bsr.b   L000043fc
L000043ce           not.w   d4
L000043d0           and.w   #$0007,d4
L000043d4           subq.w  #$01,d0
L000043d6           move.w  d4,d2
L000043d8           bclr.l  #$0002,d2
L000043dc           beq.b   L000043e4
L000043de           or.w    #$e000,d2
L000043e2           addq.w  #$01,d0
L000043e4           add.w   #$001b,d2
L000043e8           move.w  d2,-(a7)
L000043ea           bsr.w   L000045bc
L000043ee           move.w  (a7)+,d2
L000043f0           and.w   #$e000,d2
L000043f4           add.w   #$001a,d2
L000043f8           bra.w   L0000458a
L000043fc           moveq   #$07,d2
L000043fe           moveq   #$4c,d3
L00004400           sub.w   d0,d3
L00004402           add.w   d3,d3
L00004404           addx.w  d2,d2
L00004406           move.w  d2,(a6)
L00004408           rts

L0000440a           move.w  #$ffff,$0008(a6)
L00004410           moveq   #$06,d2
L00004412           cmp.w   L000062f0,d1
L00004416           bmi.b   L00004428
L00004418           moveq   #$01,d2
L0000441a           move.w  $0012(a6),d3
L0000441e           addq.w  #$04,d3
L00004420           cmp.w   L000062f0,d3
L00004424           bpl.b   L00004428
L00004426           addq.w  #$02,d2
L00004428           move.w  d2,$000a(a6)
L0000442c           move.w  #$0010,(a6)
L00004430           bsr.w   L00004570
L00004434           subq.w  #$01,$0008(a6)
L00004438           bpl.b   L00004442
L0000443a           addq.w  #$01,(a6)
L0000443c           move.w  #$0003,$0008(a6)
L00004442           rts

L00004444           bsr.w   L00004570
L00004448           btst.b  #$0000,L0000632d
L00004450           bne.b   L00004442
L00004452           bsr.w   L0000463e
L00004456           sub.w   (a5)+,d1
L00004458           add.w   L00006310,d1
L0000445c           add.w   (a5)+,d0
L0000445e           add.w   L0000630e,d0
L00004462           move.w  (a5),(a0)+
L00004464           movem.w d0-d1,(a0)
L00004468           moveq   #$0c,d2
L0000446a           bsr.w   L000044b6
L0000446e           subq.w  #$01,$0008(a6)
L00004472           bne.b   L00004442
L00004474           move.w  #$0006,$0008(a6)
L0000447a           addq.w  #$01,(a6)
L0000447c           rts 

L0000447e           bsr.w   L00004570
L00004482           subq.w  #$01,$0008(a6)
L00004486           bne.b   L00004442
L00004488           move.w  #$0004,$0008(a6)
L0000448e           move.w  $000a(a6),d2
L00004492           move.w  $0006(a6),d3
L00004496           cmp.w   #$0085,d3
L0000449a           bne.b   L000044a0
L0000449c           move.w  #$0001,d2
L000044a0           not.w   d2
L000044a2           and.w   #$0001,d2
L000044a6           add.w   #$000e,d2
L000044aa           move.w  d2,(a6)
L000044ac           move.w  d2,$000c(a6)
L000044b0           move.w $0002(a6),d4
L000044b4           rts

L000044b6           cmp.w   #$00a0,d0
L000044ba           bcc.b   L000044b4
L000044bc           cmp.w   #$0059,d1
L000044c0           bcc.b   L000044b4
L000044c2           movem.w d0-d1,-(a7)
L000044c6           move.w  d2,d0
L000044c8           jsr     $00048014           ; External Address
L000044ce           movem.w (a7)+,d0-d1
L000044d2           rts

L000044d4 e004                     asr.b #$08,d4
L000044d6 e005                     asr.b #$08,d5
L000044d8 e008                     lsr.b #$08,d0
L000044da e010                     roxr.b #$08,d0
L000044dc e011                     roxr.b #$08,d1
L000044de 0000 e012                or.b #$12,d0
L000044e2 e011                     roxr.b #$08,d1
L000044e4 0000 e013                or.b #$13,d0
L000044e8 e014                     roxr.b #$08,d4
L000044ea e011                     roxr.b #$08,d1
L000044ec e015                     roxr.b #$08,d5
L000044ee e016                     roxr.b #$08,d6
L000044f0 e011                     roxr.b #$08,d1
L000044f2 0004 0005                or.b #$05,d4
L000044f6 0008                     illegal
L000044f8 0010 0011                or.b #$11,(a0) [00]
L000044fc 0000 0012                or.b #$12,d0
L00004500 0011 0000                or.b #$00,(a1) [04]
L00004504 0013 0014                or.b #$14,(a3) [71]
L00004508 0011 0015                or.b #$15,(a1) [04]
L0000450c 0016 0011                or.b #$11,(a6)
L00004510 0010 0011                or.b #$11,(a0) [00]
L00004514 0012 0012                or.b #$12,(a2) [12]
L00004518 0008                     illegal
L0000451a 8006                     or.b d6,d0
L0000451c e010                     roxr.b #$08,d0
L0000451e e011                     roxr.b #$08,d1
L00004520 e012                     roxr.b #$08,d2
L00004522 0012 fff8                or.b #$f8,(a2) [12]
L00004526 8007                     or.b d7,d0
L00004528 0017 0018                or.b #$18,(a7) [60]
L0000452c 0019 000e                or.b #$0e,(a1)+ [04]
L00004530 0008                     illegal
L00004532 8006                     or.b d6,d0
L00004534 e017                     roxr.b #$08,d7
L00004536 e018                     ror.b #$08,d0
L00004538 e019                     ror.b #$08,d1
L0000453a 000e                     illegal
L0000453c fff8                     illegal
L0000453e 8007                     or.b d7,d0
L00004540 e013                     roxr.b #$08,d3
L00004542 e014                     roxr.b #$08,d4
L00004544 e012                     roxr.b #$08,d2
L00004546 0012 fffd                or.b #$fd,(a2) [12]
L0000454a 800b                     illegal
L0000454c 0013 0014                or.b #$14,(a3) [71]
L00004550 0012 0012                or.b #$12,(a2) [12]
L00004554 0003 800a                or.b #$0a,d3
L00004558 e015                     roxr.b #$08,d5
L0000455a e016                     roxr.b #$08,d6
L0000455c e012                     roxr.b #$08,d2
L0000455e 000c                     illegal
L00004560 fffb                     illegal
L00004562 8009                     illegal
L00004564 0015 0016                or.b #$16,(a5)
L00004568 0012 000c                or.b #$0c,(a2) [12]
L0000456c 0005 8008                or.b #$08,d5
L00004570 342e 000a                move.w (a6,$000a) == $00dff00a,d2
L00004574 c4fc 000c                mulu.w #$000c,d2
L00004578 4bfb 2096                lea.l (pc,d2.W,$96=$00004510) == $00004f17,a5
L0000457c 341d                     move.w (a5)+,d2
L0000457e 610a                     bsr.b #$0a == $0000458a
L00004580 341d                     move.w (a5)+,d2
L00004582 6138                     bsr.b #$38 == $000045bc
L00004584 341d                     move.w (a5)+,d2
L00004586 6634                     bne.b #$34 == $000045bc (T)
L00004588 4e75                     rts  == $6000001a
L0000458a d46e 0006                add.w (a6,$0006) == $00dff006,d2
L0000458e 3602                     move.w d2,d3
L00004590 0243 1fff                and.w #$1fff,d3
L00004594 e34b                     lsl.w #$01,d3
L00004596 41f8 607c                lea.l $607c,a0
L0000459a 3801                     move.w d1,d4
L0000459c d844                     add.w d4,d4
L0000459e 1a30 30fe                move.b (a0,d3.W,$fe) == $00000d11 [00],d5
L000045a2 4885                     ext.w d5
L000045a4 9845                     sub.w d5,d4
L000045a6 e244                     asr.w #$01,d4
L000045a8 48ae 0013 000e           movem.w d0-d1/d4,(a6,$000e) == $00dff00e
L000045ae 48a7 c006                movem.w d0-d1/a5-a6,-(a7)
L000045b2 6100 1140                bsr.w #$1140 == $000056f4
L000045b6 4c9f 6003                movem.w (a7)+,d0-d1/a5-a6
L000045ba 4e75                     rts  == $6000001a
L000045bc d46e 0006                add.w (a6,$0006) == $00dff006,d2
L000045c0 48a7 c006                movem.w d0-d1/a5-a6,-(a7)
L000045c4 6100 112e                bsr.w #$112e == $000056f4
L000045c8 4c9f 6003                movem.w (a7)+,d0-d1/a5-a6
L000045cc 4e75                     rts  == $6000001a
L000045ce 342e 000a                move.w (a6,$000a) == $00dff00a,d2
L000045d2 5242                     addq.w #$01,d2
L000045d4 0c42 000e                cmp.w #$000e,d2
L000045d8 6a04                     bpl.b #$04 == $000045de (T)
L000045da 3d42 000a                move.w d2,(a6,$000a) == $00dff00a
L000045de e242                     asr.w #$01,d2
L000045e0 d56e 0004                add.w d2,(a6,$0004) == $00dff004
L000045e4 4bf8 62de                lea.l $62de,a5
L000045e8 0c41 0064                cmp.w #$0064,d1
L000045ec 6b00 ff8e                bmi.w #$ff8e == $0000457c (F)
L000045f0 4256                     clr.w (a6)
L000045f2 203c 0000 0350           move.l #$00000350,d0
L000045f8 4ef9 0007 c82a           jmp $0007c82a
L000045fe 4bf8 4866                lea.l $4866,a5
L00004602 4df8 4894                lea.l $4894,a6
L00004606 7e13                     moveq #$13,d7
L00004608 341e                     move.w (a6)+,d2
L0000460a 672a                     beq.b #$2a == $00004636 (F)
L0000460c 4c96 0003                movem.w (a6),d0-d1
L00004610 2f0e                     move.l a6,-(a7) [000009ec]
L00004612 3f07                     move.w d7,-(a7) [09ec]
L00004614 0802 000f                btst.l #$000f,d2
L00004618 6708                     beq.b #$08 == $00004622 (F)
L0000461a 4882                     ext.w d2
L0000461c 3d42 fffe                move.w d2,(a6,-$0002) == $00dfeffe
L00004620 7404                     moveq #$04,d2
L00004622 e25a                     ror.w #$01,d2
L00004624 6a04                     bpl.b #$04 == $0000462a (T)
L00004626 0042 e000                or.w #$e000,d2
L0000462a 0642 003b                add.w #$003b,d2
L0000462e 6100 10c4                bsr.w #$10c4 == $000056f4
L00004632 3e1f                     move.w (a7)+ [6000],d7
L00004634 2c5f                     movea.l (a7)+ [6000001a],a6
L00004636 5c4e                     addaq.w #$06,a6
L00004638 51cf ffce                dbf .w d7,#$ffce == $00004608 (F)
L0000463c 4e75                     rts  == $6000001a
L0000463e 41f8 4894                lea.l $4894,a0
L00004642 7e13                     moveq #$13,d7
L00004644 4a50                     tst.w (a0) [003c]
L00004646 670e                     beq.b #$0e == $00004656 (F)
L00004648 41e8 0008                lea.l (a0,$0008) == $00000a08,a0
L0000464c 51cf fff6                dbf .w d7,#$fff6 == $00004644 (F)
L00004650 207c ffff fff8           movea.l #$fffffff8,a0
L00004656 4e75                     rts  == $6000001a
L00004658 4bf8 4866                lea.l $4866,a5
L0000465c 4df8 4894                lea.l $4894,a6
L00004660 7e13                     moveq #$13,d7
L00004662 3c1e                     move.w (a6)+,d6
L00004664 6718                     beq.b #$18 == $0000467e (F)
L00004666 4c96 0003                movem.w (a6),d0-d1
L0000466a 9078 630e                sub.w $630e [0000],d0
L0000466e 9278 6310                sub.w $6310 [0000],d1
L00004672 e346                     asl.w #$01,d6
L00004674 4282                     clr.l d2
L00004676 2042                     movea.l d2,a0
L00004678 3075 60fe                movea.w (a5,d6.W,$fe) == $00bfdd53,a0
L0000467c 4e90                     jsr (a0)
L0000467e 5c4e                     addaq.w #$06,a6
L00004680 51cf ffe0                dbf .w d7,#$ffe0 == $00004662 (F)
L00004684 4e75                     rts  == $6000001a
L00004686 4896 0003                movem.w d0-d1,(a6)
L0000468a 6100 0f14                bsr.w #$0f14 == $000055a0
L0000468e 0c02 0017                cmp.b #$17,d2
L00004692 6526                     bcs.b #$26 == $000046ba (F)
L00004694 9078 67c2                sub.w $67c2 [0050],d0
L00004698 5840                     addq.w #$04,d0
L0000469a 0c40 0009                cmp.w #$0009,d0
L0000469e 6420                     bcc.b #$20 == $000046c0 (T)
L000046a0 b278 67c4                cmp.w $67c4 [0048],d1
L000046a4 6a1a                     bpl.b #$1a == $000046c0 (T)
L000046a6 b278 62f0                cmp.w $62f0 [0000],d1
L000046aa 6b14                     bmi.b #$14 == $000046c0 (F)
L000046ac 7c01                     moveq #$01,d6
L000046ae 6100 061c                bsr.w #$061c == $00004ccc
L000046b2 700a                     moveq #$0a,d0
L000046b4 4eb9 0004 8014           jsr $00048014
L000046ba 3d7c 0004 fffe           move.w #$0004,(a6,-$0002) == $00dfeffe
L000046c0 4e75                     rts  == $6000001a
L000046c2 5740                     subq.w #$03,d0
L000046c4 0c40 fff6                cmp.w #$fff6,d0
L000046c8 6b58                     bmi.b #$58 == $00004722 (F)
L000046ca 5741                     subq.w #$03,d1
L000046cc 0c41 0058                cmp.w #$0058,d1
L000046d0 65b4                     bcs.b #$b4 == $00004686 (F)
L000046d2 604e                     bra.b #$4e == $00004722 (T)
L000046d4 5640                     addq.w #$03,d0
L000046d6 0c40 00a8                cmp.w #$00a8,d0
L000046da 6a46                     bpl.b #$46 == $00004722 (T)
L000046dc 5741                     subq.w #$03,d1
L000046de 0c41 0058                cmp.w #$0058,d1
L000046e2 65a2                     bcs.b #$a2 == $00004686 (F)
L000046e4 603c                     bra.b #$3c == $00004722 (T)
L000046e6 5740                     subq.w #$03,d0
L000046e8 0c40 fff6                cmp.w #$fff6,d0
L000046ec 6b34                     bmi.b #$34 == $00004722 (F)
L000046ee 5641                     addq.w #$03,d1
L000046f0 0c41 0058                cmp.w #$0058,d1
L000046f4 6590                     bcs.b #$90 == $00004686 (F)
L000046f6 602a                     bra.b #$2a == $00004722 (T)
L000046f8 5640                     addq.w #$03,d0
L000046fa 0c40 00a8                cmp.w #$00a8,d0
L000046fe 6a22                     bpl.b #$22 == $00004722 (T)
L00004700 5641                     addq.w #$03,d1
L00004702 0c41 0058                cmp.w #$0058,d1
L00004706 6500 ff7e                bcs.w #$ff7e == $00004686 (F)
L0000470a 6016                     bra.b #$16 == $00004722 (T)
L0000470c 5b40                     subq.w #$05,d0
L0000470e 0c40 fff6                cmp.w #$fff6,d0
L00004712 6a00 ff72                bpl.w #$ff72 == $00004686 (T)
L00004716 600a                     bra.b #$0a == $00004722 (T)
L00004718 5a40                     addq.w #$05,d0
L0000471a 0c40 00a8                cmp.w #$00a8,d0
L0000471e 6b00 ff66                bmi.w #$ff66 == $00004686 (F)
L00004722 426e fffe                clr.w (a6,-$0002) == $00dfeffe
L00004726 4e75                     rts  == $6000001a
L00004728 5840                     addq.w #$04,d0
L0000472a 0c40 00a8                cmp.w #$00a8,d0
L0000472e 6af2                     bpl.b #$f2 == $00004722 (T)
L00004730 6100 0e6e                bsr.w #$0e6e == $000055a0
L00004734 0c02 0017                cmp.b #$17,d2
L00004738 4896 0003                movem.w d0-d1,(a6)
L0000473c 6440                     bcc.b #$40 == $0000477e (T)
L0000473e 65e2                     bcs.b #$e2 == $00004722 (F)
L00004740 5940                     subq.w #$04,d0
L00004742 0c40 fff6                cmp.w #$fff6,d0
L00004746 6bda                     bmi.b #$da == $00004722 (F)
L00004748 6100 0e56                bsr.w #$0e56 == $000055a0
L0000474c 0c02 0017                cmp.b #$17,d2
L00004750 4896 0003                movem.w d0-d1,(a6)
L00004754 6428                     bcc.b #$28 == $0000477e (T)
L00004756 60ca                     bra.b #$ca == $00004722 (T)
L00004758 3038 6318                move.w $6318 [0000],d0
L0000475c 67c4                     beq.b #$c4 == $00004722 (F)
L0000475e 4cb8 0003 67c2           movem.w $67c2,d0-d1
L00004764 d078 631a                add.w $631a [0000],d0
L00004768 9278 631c                sub.w $631c [0034],d1
L0000476c 0441 000c                sub.w #$000c,d1
L00004770 5a40                     addq.w #$05,d0
L00004772 4a78 62ee                tst.w $62ee [0001]
L00004776 6a02                     bpl.b #$02 == $0000477a (T)
L00004778 5f40                     subq.w #$07,d0
L0000477a 4896 0003                movem.w d0-d1,(a6)
L0000477e 49f8 3a8e                lea.l $3a8e,a4
L00004782 7c09                     moveq #$09,d6
L00004784 3414                     move.w (a4),d2
L00004786 5542                     subq.w #$02,d2
L00004788 6b1a                     bmi.b #$1a == $000047a4 (F)
L0000478a 342c 000e                move.w (a4,$000e) == $00bfe10f,d2
L0000478e 9440                     sub.w d0,d2
L00004790 5842                     addq.w #$04,d2
L00004792 0c42 0008                cmp.w #$0008,d2
L00004796 640c                     bcc.b #$0c == $000047a4 (T)
L00004798 b26c 0010                cmp.w (a4,$0010) == $00bfe111,d1
L0000479c 6a06                     bpl.b #$06 == $000047a4 (T)
L0000479e b26c 0012                cmp.w (a4,$0012) == $00bfe113,d1
L000047a2 6a0a                     bpl.b #$0a == $000047ae (T)
L000047a4 49ec ffea                lea.l (a4,-$0016) == $00bfe0eb,a4
L000047a8 51ce ffda                dbf .w d6,#$ffda == $00004784 (F)
L000047ac 4e75                     rts  == $6000001a
L000047ae 38bc 0001                move.w #$0001,(a4)
L000047b2 397c fffc 000a           move.w #$fffc,(a4,$000a) == $00bfe10b
L000047b8 6100 ff68                bsr.w #$ff68 == $00004722
L000047bc 700a                     moveq #$0a,d0
L000047be 4ef9 0004 8014           jmp $00048014
L000047c4 5440                     addq.w #$02,d0
L000047c6 342e 0004                move.w (a6,$0004) == $00dff004,d2
L000047ca 0c42 0028                cmp.w #$0028,d2
L000047ce 6a04                     bpl.b #$04 == $000047d4 (T)
L000047d0 526e 0004                addq.w #$01,(a6,$0004) == $00dff004
L000047d4 e442                     asr.w #$02,d2
L000047d6 6a02                     bpl.b #$02 == $000047da (T)
L000047d8 5242                     addq.w #$01,d2
L000047da d242                     add.w d2,d1
L000047dc 0c41 0060                cmp.w #$0060,d1
L000047e0 6a00 ff40                bpl.w #$ff40 == $00004722 (T)
L000047e4 4896 0003                movem.w d0-d1,(a6)
L000047e8 6100 0db6                bsr.w #$0db6 == $000055a0
L000047ec 0c02 0017                cmp.b #$17,d2
L000047f0 6522                     bcs.b #$22 == $00004814 (F)
L000047f2 9078 67c2                sub.w $67c2 [0050],d0
L000047f6 5640                     addq.w #$03,d0
L000047f8 0c40 0007                cmp.w #$0007,d0
L000047fc 6422                     bcc.b #$22 == $00004820 (T)
L000047fe b278 67c4                cmp.w $67c4 [0048],d1
L00004802 6a1c                     bpl.b #$1c == $00004820 (T)
L00004804 b278 62f0                cmp.w $62f0 [0000],d1
L00004808 6b16                     bmi.b #$16 == $00004820 (F)
L0000480a 7c06                     moveq #$06,d6
L0000480c 6100 04be                bsr.w #$04be == $00004ccc
L00004810 4c96 0003                movem.w (a6),d0-d1
L00004814 3d7c 000e fffe           move.w #$000e,(a6,-$0002) == $00dfeffe
L0000481a 740d                     moveq #$0d,d2
L0000481c 6000 fc98                bra.w #$fc98 == $000044b6 (T)
L00004820 4e75                     rts  == $6000001a
L00004822 5540                     subq.w #$02,d0
L00004824 342e 0004                move.w (a6,$0004) == $00dff004,d2
L00004828 0c42 0028                cmp.w #$0028,d2
L0000482c 6a04                     bpl.b #$04 == $00004832 (T)
L0000482e 526e 0004                addq.w #$01,(a6,$0004) == $00dff004
L00004832 e442                     asr.w #$02,d2
L00004834 6a02                     bpl.b #$02 == $00004838 (T)
L00004836 5242                     addq.w #$01,d2
L00004838 d242                     add.w d2,d1
L0000483a 0c41 0060                cmp.w #$0060,d1
L0000483e 6a00 fee2                bpl.w #$fee2 == $00004722 (T)
L00004842 60a0                     bra.b #$a0 == $000047e4 (T)
L00004844 4896 0003                movem.w d0-d1,(a6)
L00004848 0838 0000 632d           btst.b #$0000,$632d [00]
L0000484e 6614                     bne.b #$14 == $00004864 (T)
L00004850 342e fffe                move.w (a6,-$0002) == $00dfeffe,d2
L00004854 5242                     addq.w #$01,d2
L00004856 0c42 0018                cmp.w #$0018,d2
L0000485a 6600 0004                bne.w #$0004 == $00004860 (T)
L0000485e 4242                     clr.w d2
L00004860 3d42 fffe                move.w d2,(a6,-$0002) == $00dfeffe
L00004864 4e75                     rts  == $6000001a
L00004866 4758                     illegal
L00004868 4728 4740                [ chk.l (a0,$4740) == $00005140,d3 ]
L0000486a 4740                     illegal
L0000486c 4722                     [ chk.l -(a2),d3 ]
L0000486e 4722                     [ chk.l -(a2),d3 ]
L00004870 4718                     [ chk.l (a0)+,d3 ]
L00004872 470c                     illegal
L00004874 46f8 46e6                move.w $46e6,sr
L00004878 46d4                     move.w (a4),sr
L0000487a 46c2                     move.w d2,sr
L0000487c 47c4                     illegal
L0000487e 4822                     nbcd.b -(a2)
L00004880 4844                     swap.w d4
L00004882 4844                     swap.w d4
L00004884 4844                     swap.w d4
L00004886 4844                     swap.w d4
L00004888 4844                     swap.w d4
L0000488a 4844                     swap.w d4
L0000488c 4844                     swap.w d4
L0000488e 4844                     swap.w d4
L00004890 4844                     swap.w d4
L00004892 4844                     swap.w d4
L00004894 0000 0000                or.b #$00,d0
L00004898 0000 0000                or.b #$00,d0
L0000489c 0000 0000                or.b #$00,d0
L000048a0 0000 0000                or.b #$00,d0
L000048a4 0000 0000                or.b #$00,d0
L000048a8 0000 0000                or.b #$00,d0
L000048ac 0000 0000                or.b #$00,d0
L000048b0 0000 0000                or.b #$00,d0
L000048b4 0000 0000                or.b #$00,d0
L000048b8 0000 0000                or.b #$00,d0
L000048bc 0000 0000                or.b #$00,d0
L000048c0 0000 0000                or.b #$00,d0
L000048c4 0000 0000                or.b #$00,d0
L000048c8 0000 0000                or.b #$00,d0
L000048cc 0000 0000                or.b #$00,d0
L000048d0 0000 0000                or.b #$00,d0
L000048d4 0000 0000                or.b #$00,d0
L000048d8 0000 0000                or.b #$00,d0
L000048dc 0000 0000                or.b #$00,d0
L000048e0 0000 0000                or.b #$00,d0
L000048e4 0000 0000                or.b #$00,d0
L000048e8 0000 0000                or.b #$00,d0
L000048ec 0000 0000                or.b #$00,d0
L000048f0 0000 0000                or.b #$00,d0
L000048f4 0000 0000                or.b #$00,d0
L000048f8 0000 0000                or.b #$00,d0
L000048fc 0000 0000                or.b #$00,d0
L00004900 0000 0000                or.b #$00,d0
L00004904 0000 0000                or.b #$00,d0
L00004908 0000 0000                or.b #$00,d0
L0000490c 0000 0000                or.b #$00,d0
L00004910 0000 0000                or.b #$00,d0
L00004914 0000 0000                or.b #$00,d0
L00004918 0000 0000                or.b #$00,d0
L0000491c 0000 0000                or.b #$00,d0
L00004920 0000 0000                or.b #$00,d0
L00004924 0000 0000                or.b #$00,d0
L00004928 0000 0000                or.b #$00,d0
L0000492c 0000 0000                or.b #$00,d0
L00004930 0000 0000                or.b #$00,d0
L00004934 0000 4cb8                or.b #$b8,d0
L00004938 0006 67c4                or.b #$c4,d6
L0000493c 3001                     move.w d1,d0
L0000493e 9042                     sub.w d2,d0
L00004940 31f8 6310 4934           move.w $6310 [0000],$4934 [0000]
L00004946 31c0 6310                move.w d0,$6310 [0000]
L0000494a 6700 00a0                beq.w #$00a0 == $000049ec (F)
L0000494e 4a78 62fa                tst.w $62fa [0001]
L00004952 6b18                     bmi.b #$18 == $0000496c (F)
L00004954 672a                     beq.b #$2a == $00004980 (F)
L00004956 0c40 0004                cmp.w #$0004,d0
L0000495a 6524                     bcs.b #$24 == $00004980 (F)
L0000495c 0c40 fffd                cmp.w #$fffd,d0
L00004960 641e                     bcc.b #$1e == $00004980 (T)
L00004962 6a04                     bpl.b #$04 == $00004968 (T)
L00004964 70fe                     moveq #$fe,d0
L00004966 6018                     bra.b #$18 == $00004980 (T)
L00004968 7002                     moveq #$02,d0
L0000496a 6014                     bra.b #$14 == $00004980 (T)
L0000496c 0c40 0008                cmp.w #$0008,d0
L00004970 650e                     bcs.b #$0e == $00004980 (F)
L00004972 0c40 fffd                cmp.w #$fffd,d0
L00004976 6408                     bcc.b #$08 == $00004980 (T)
L00004978 6b04                     bmi.b #$04 == $0000497e (F)
L0000497a 7007                     moveq #$07,d0
L0000497c 6002                     bra.b #$02 == $00004980 (T)
L0000497e 70fd                     moveq #$fd,d0
L00004980 3238 67be                move.w $67be [00f0],d1
L00004984 3601                     move.w d1,d3
L00004986 d240                     add.w d0,d1
L00004988 0c41 00f1                cmp.w #$00f1,d1
L0000498c 6512                     bcs.b #$12 == $000049a0 (F)
L0000498e 6b0c                     bmi.b #$0c == $0000499c (F)
L00004990 343c 00f0                move.w #$00f0,d2
L00004994 9242                     sub.w d2,d1
L00004996 9041                     sub.w d1,d0
L00004998 3202                     move.w d2,d1
L0000499a 6004                     bra.b #$04 == $000049a0 (T)
L0000499c 9041                     sub.w d1,d0
L0000499e 4241                     clr.w d1
L000049a0 9178 67c4                sub.w d0,$67c4 [0048]
L000049a4 31c1 67be                move.w d1,$67be [00f0]
L000049a8 9243                     sub.w d3,d1
L000049aa 31c1 6310                move.w d1,$6310 [0000]
L000049ae 673c                     beq.b #$3c == $000049ec (F)
L000049b0 6b22                     bmi.b #$22 == $000049d4 (F)
L000049b2 0643 0057                add.w #$0057,d3
L000049b6 3438 6312                move.w $6312 [0000],d2
L000049ba 3801                     move.w d1,d4
L000049bc d842                     add.w d2,d4
L000049be 0c44 0057                cmp.w #$0057,d4
L000049c2 6504                     bcs.b #$04 == $000049c8 (F)
L000049c4 0444 0057                sub.w #$0057,d4
L000049c8 31c4 6312                move.w d4,$6312 [0000]
L000049cc 6100 0090                bsr.w #$0090 == $00004a5e
L000049d0 6000 001a                bra.w #$001a == $000049ec (T)
L000049d4 3438 6312                move.w $6312 [0000],d2
L000049d8 d441                     add.w d1,d2
L000049da 6a04                     bpl.b #$04 == $000049e0 (T)
L000049dc 0642 0057                add.w #$0057,d2
L000049e0 31c2 6312                move.w d2,$6312 [0000]
L000049e4 d641                     add.w d1,d3
L000049e6 4441                     neg.w d1
L000049e8 6100 0074                bsr.w #$0074 == $00004a5e
L000049ec 3038 67c2                move.w $67c2 [0050],d0
L000049f0 9078 67c8                sub.w $67c8 [0050],d0
L000049f4 31c0 630e                move.w d0,$630e [0000]
L000049f8 6700 0062                beq.w #$0062 == $00004a5c (F)
L000049fc 3238 67bc                move.w $67bc [0000],d1
L00004a00 3401                     move.w d1,d2
L00004a02 d240                     add.w d0,d1
L00004a04 6a06                     bpl.b #$06 == $00004a0c (T)
L00004a06 3001                     move.w d1,d0
L00004a08 4241                     clr.w d1
L00004a0a 6010                     bra.b #$10 == $00004a1c (T)
L00004a0c 4240                     clr.w d0
L00004a0e 0c41 0540                cmp.w #$0540,d1
L00004a12 6308                     bls.b #$08 == $00004a1c (F)
L00004a14 303c 0540                move.w #$0540,d0
L00004a18 9240                     sub.w d0,d1
L00004a1a c340                     exg.l d1,d0
L00004a1c d078 67c8                add.w $67c8 [0050],d0
L00004a20 31c0 67c2                move.w d0,$67c2 [0050]
L00004a24 31c1 67bc                move.w d1,$67bc [0000]
L00004a28 3601                     move.w d1,d3
L00004a2a 9642                     sub.w d2,d3
L00004a2c 31c3 630e                move.w d3,$630e [0000]
L00004a30 672a                     beq.b #$2a == $00004a5c (F)
L00004a32 b342                     eor.w d1,d2
L00004a34 0802 0003                btst.l #$0003,d2
L00004a38 6722                     beq.b #$22 == $00004a5c (F)
L00004a3a 2878 631e                movea.l $631e [0005a36c],a4
L00004a3e 4a43                     tst.w d3
L00004a40 6b10                     bmi.b #$10 == $00004a52 (F)
L00004a42 0641 00a0                add.w #$00a0,d1
L00004a46 544c                     addaq.w #$02,a4
L00004a48 21cc 631e                move.l a4,$631e [0005a36c]
L00004a4c 49ec 0028                lea.l (a4,$0028) == $00bfe129,a4
L00004a50 6006                     bra.b #$06 == $00004a58 (T)
L00004a52 554c                     subaq.w #$02,a4
L00004a54 21cc 631e                move.l a4,$631e [0005a36c]
L00004a58 6100 007c                bsr.w #$007c == $00004ad6
L00004a5c 4e75                     rts  == $6000001a
L00004a5e 5341                     subq.w #$01,d1
L00004a60 3803                     move.w d3,d4
L00004a62 0244 0007                and.w #$0007,d4
L00004a66 e944                     asl.w #$04,d4
L00004a68 13c4 0000 4aa1           move.b d4,$00004aa1 [00]
L00004a6e 3803                     move.w d3,d4
L00004a70 e64c                     lsr.w #$03,d4
L00004a72 41f9 0000 8002           lea.l $00008002,a0
L00004a78 c8d0                     mulu.w (a0) [003c],d4
L00004a7a 3038 67bc                move.w $67bc [0000],d0
L00004a7e e648                     lsr.w #$03,d0
L00004a80 d840                     add.w d0,d4
L00004a82 41f0 407a                lea.l (a0,d4.W,$7a) == $00000b7b,a0
L00004a86 3802                     move.w d2,d4
L00004a88 c8fc 0054                mulu.w #$0054,d4
L00004a8c d8b8 631e                add.l $631e [0005a36c],d4
L00004a90 2244                     movea.l d4,a1
L00004a92 7e14                     moveq #$14,d7
L00004a94 2478 630a                movea.l $630a [0000a07c],a2
L00004a98 4240                     clr.w d0
L00004a9a 1018                     move.b (a0)+ [00],d0
L00004a9c ef40                     asl.w #$07,d0
L00004a9e 47f2 0000                lea.l (a2,d0.W,$00) == $0006b778,a3
L00004aa2 32db                     move.w (a3)+ [7185],(a1)+ [0400]
L00004aa4 335b 1c8a                move.w (a3)+ [7185],(a1,$1c8a) == $00041be4 [8012]
L00004aa8 335b 3916                move.w (a3)+ [7185],(a1,$3916) == $00043870 [1080]
L00004aac 335b 55a2                move.w (a3)+ [7185],(a1,$55a2) == $000454fc [7868]
L00004ab0 335b 0028                move.w (a3)+ [7185],(a1,$0028) == $0003ff82 [0000]
L00004ab4 335b 1cb4                move.w (a3)+ [7185],(a1,$1cb4) == $00041c0e [02c0]
L00004ab8 335b 3940                move.w (a3)+ [7185],(a1,$3940) == $0004389a [0001]
L00004abc 335b 55cc                move.w (a3)+ [7185],(a1,$55cc) == $00045526 [00e0]
L00004ac0 51cf ffd6                dbf .w d7,#$ffd6 == $00004a98 (F)
L00004ac4 5243                     addq.w #$01,d3
L00004ac6 5242                     addq.w #$01,d2
L00004ac8 0c42 0057                cmp.w #$0057,d2
L00004acc 6502                     bcs.b #$02 == $00004ad0 (F)
L00004ace 4242                     clr.w d2
L00004ad0 51c9 ff8e                dbf .w d1,#$ff8e == $00004a60 (F)
L00004ad4 4e75                     rts  == $6000001a
L00004ad6 2478 630a                movea.l $630a [0000a07c],a2
L00004ada 3401                     move.w d1,d2
L00004adc e64a                     lsr.w #$03,d2
L00004ade 3238 67be                move.w $67be [00f0],d1
L00004ae2 3001                     move.w d1,d0
L00004ae4 0240 0007                and.w #$0007,d0
L00004ae8 3a00                     move.w d0,d5
L00004aea 4645                     not.w d5
L00004aec 0245 0007                and.w #$0007,d5
L00004af0 e948                     lsl.w #$04,d0
L00004af2 e649                     lsr.w #$03,d1
L00004af4 41f9 0000 8002           lea.l $00008002,a0
L00004afa 3810                     move.w (a0) [003c],d4
L00004afc c2c4                     mulu.w d4,d1
L00004afe d242                     add.w d2,d1
L00004b00 41f0 107a                lea.l (a0,d1.W,$7a) == $00000a79,a0
L00004b04 7e56                     moveq #$56,d7
L00004b06 3238 6312                move.w $6312 [0000],d1
L00004b0a 7c56                     moveq #$56,d6
L00004b0c 9c41                     sub.w d1,d6
L00004b0e c2fc 0054                mulu.w #$0054,d1
L00004b12 43f4 1800                lea.l (a4,d1.L,$00) == $00c0e100,a1
L00004b16 4241                     clr.w d1
L00004b18 1210                     move.b (a0) [00],d1
L00004b1a ef41                     asl.w #$07,d1
L00004b1c d041                     add.w d1,d0
L00004b1e 600c                     bra.b #$0c == $00004b2c (T)
L00004b20 51cd 0010                dbf .w d5,#$0010 == $00004b32 (F)
L00004b24 7a07                     moveq #$07,d5
L00004b26 4240                     clr.w d0
L00004b28 1010                     move.b (a0) [00],d0
L00004b2a ef40                     asl.w #$07,d0
L00004b2c 47f2 0000                lea.l (a2,d0.W,$00) == $0006b778,a3
L00004b30 d0c4                     adda.w d4,a0
L00004b32 329b                     move.w (a3)+ [7185],(a1) [0400]
L00004b34 335b 1c8c                move.w (a3)+ [7185],(a1,$1c8c) == $00041be6 [02c0]
L00004b38 335b 3918                move.w (a3)+ [7185],(a1,$3918) == $00043872 [0101]
L00004b3c 335b 55a4                move.w (a3)+ [7185],(a1,$55a4) == $000454fe [00e0]
L00004b40 335b 002a                move.w (a3)+ [7185],(a1,$002a) == $0003ff84 [0000]
L00004b44 335b 1cb6                move.w (a3)+ [7185],(a1,$1cb6) == $00041c10 [0038]
L00004b48 335b 3942                move.w (a3)+ [7185],(a1,$3942) == $0004389c [8000]
L00004b4c 335b 55ce                move.w (a3)+ [7185],(a1,$55ce) == $00045528 [00f7]
L00004b50 43e9 0054                lea.l (a1,$0054) == $0003ffae,a1
L00004b54 51ce 0006                dbf .w d6,#$0006 == $00004b5c (F)
L00004b58 43e9 e374                lea.l (a1,-$1c8c) == $0003e2ce,a1
L00004b5c 51cf ffc2                dbf .w d7,#$ffc2 == $00004b20 (F)
L00004b60 4e75                     rts  == $6000001a
L00004b62 33fc 8400 00df f096      move.w #$8400,$00dff096
L00004b6a 2c78 36f6                movea.l $36f6 [00061b9c],a6
L00004b6e 554e                     subaq.w #$02,a6
L00004b70 2a78 631e                movea.l $631e [0005a36c],a5
L00004b74 3238 6312                move.w $6312 [0000],d1
L00004b78 4286                     clr.l d6
L00004b7a 5346                     subq.w #$01,d6
L00004b7c 4846                     swap.w d6
L00004b7e 3438 67bc                move.w $67bc [0000],d2
L00004b82 0242 0007                and.w #$0007,d2
L00004b86 6704                     beq.b #$04 == $00004b8c (F)
L00004b88 e4be                     ror.l d2,d6
L00004b8a e4be                     ror.l d2,d6
L00004b8c 4442                     neg.w d2
L00004b8e e65a                     ror.w #$03,d2
L00004b90 0282 0000 e000           and.l #$0000e000,d2
L00004b96 6602                     bne.b #$02 == $00004b9a (T)
L00004b98 544e                     addaq.w #$02,a6
L00004b9a 0042 09f0                or.w #$09f0,d2
L00004b9e 4842                     swap.w d2
L00004ba0 3801                     move.w d1,d4
L00004ba2 c8fc 0054                mulu.w #$0054,d4
L00004ba6 43f5 4800                lea.l (a5,d4.L,$00) == $1022d201,a1
L00004baa 204e                     movea.l a6,a0
L00004bac 7628                     moveq #$28,d3
L00004bae 383c 00ae                move.w #$00ae,d4
L00004bb2 9841                     sub.w d1,d4
L00004bb4 9841                     sub.w d1,d4
L00004bb6 6100 0026                bsr.w #$0026 == $00004bde
L00004bba 3801                     move.w d1,d4
L00004bbc 6716                     beq.b #$16 == $00004bd4 (F)
L00004bbe 7657                     moveq #$57,d3
L00004bc0 9644                     sub.w d4,d3
L00004bc2 c6fc 0054                mulu.w #$0054,d3
L00004bc6 41f6 3800                lea.l (a6,d3.L,$00) == $04f3f313,a0
L00004bca d844                     add.w d4,d4
L00004bcc 7628                     moveq #$28,d3
L00004bce 43d5                     lea.l (a5),a1
L00004bd0 6100 000c                bsr.w #$000c == $00004bde
L00004bd4 33fc 0400 00df f096      move.w #$0400,$00dff096
L00004bdc 4e75                     rts  == $6000001a
L00004bde 2a02                     move.l d2,d5
L00004be0 4845                     swap.w d5
L00004be2 0245 e000                and.w #$e000,d5
L00004be6 5443                     addq.w #$02,d3
L00004be8 ed44                     asl.w #$06,d4
L00004bea 3a03                     move.w d3,d5
L00004bec e24d                     lsr.w #$01,d5
L00004bee d845                     add.w d5,d4
L00004bf0 0443 002a                sub.w #$002a,d3
L00004bf4 4443                     neg.w d3
L00004bf6 49f9 00df f000           lea.l $00dff000,a4
L00004bfc 2a3c 0000 1c8c           move.l #$00001c8c,d5
L00004c02 0839 0006 00df f002      btst.b #$0006,$00dff002
L00004c0a 66f6                     bne.b #$f6 == $00004c02 (T)
L00004c0c 2946 0044                move.l d6,(a4,$0044) == $00bfe145
L00004c10 3943 0064                move.w d3,(a4,$0064) == $00bfe165
L00004c14 3943 0066                move.w d3,(a4,$0066) == $00bfe167
L00004c18 2942 0040                move.l d2,(a4,$0040) == $00bfe141
L00004c1c 7e03                     moveq #$03,d7
L00004c1e 0839 0006 00df f002      btst.b #$0006,$00dff002
L00004c26 66f6                     bne.b #$f6 == $00004c1e (T)
L00004c28 2949 0050                move.l a1,(a4,$0050) == $00bfe151
L00004c2c 2948 0054                move.l a0,(a4,$0054) == $00bfe155
L00004c30 3944 0058                move.w d4,(a4,$0058) == $00bfe159
L00004c34 d3c5                     adda.l d5,a1
L00004c36 d1c5                     adda.l d5,a0
L00004c38 51cf ffe4                dbf .w d7,#$ffe4 == $00004c1e (F)
L00004c3c 4e75                     rts  == $6000001a
L00004c3e 4242                     clr.w d2
L00004c40 1438 6308                move.b $6308 [00],d2
L00004c44 e542                     asl.w #$02,d2
L00004c46 207b 2004                movea.l (pc,d2.W,$04=$00004c4c) == $00005653 [623b4600],a0
L00004c4a 4ed0                     jmp (a0)
L00004c4c 0000 5290                or.b #$90,d0
L00004c50 0000 5246                or.b #$46,d0
L00004c54 0000 529c                or.b #$9c,d0
L00004c58 0000 5290                or.b #$90,d0
L00004c5c 0000 53f4                or.b #$f4,d0
L00004c60 0000 5240                or.b #$40,d0
L00004c64 0000 5292                or.b #$92,d0
L00004c68 0000 5290                or.b #$90,d0
L00004c6c 0000 5202                or.b #$02,d0
L00004c70 0000 5244                or.b #$44,d0
L00004c74 0000 5298                or.b #$98,d0
L00004c78 0000 5290                or.b #$90,d0
L00004c7c 0000 5290                or.b #$90,d0
L00004c80 0000 5290                or.b #$90,d0
L00004c84 0000 5290                or.b #$90,d0
L00004c88 0000 5290                or.b #$90,d0
L00004c8c 0000 4fe0                or.b #$e0,d0
L00004c90 0000 4fe0                or.b #$e0,d0
L00004c94 0000 4fe0                or.b #$e0,d0
L00004c98 0000 4fe0                or.b #$e0,d0
L00004c9c 0000 53d6                or.b #$d6,d0
L00004ca0 0000 53d6                or.b #$d6,d0
L00004ca4 0000 53d6                or.b #$d6,d0
L00004ca8 0000 53d6                or.b #$d6,d0
L00004cac 0000 50f8                or.b #$f8,d0
L00004cb0 0000 50e6                or.b #$e6,d0
L00004cb4 0000 50ee                or.b #$ee,d0
L00004cb8 0000 5290                or.b #$90,d0
L00004cbc 0000 5290                or.b #$90,d0
L00004cc0 0000 5290                or.b #$90,d0
L00004cc4 0000 5290                or.b #$90,d0
L00004cc8 0000 5290                or.b #$90,d0
L00004ccc 4a39 0007 c874           tst.b $0007c874 [00]
L00004cd2 6662                     bne.b #$62 == $00004d36 (T)
L00004cd4 48e7 ff06                movem.l d0-d7/a5-a6,-(a7)
L00004cd8 3006                     move.w d6,d0
L00004cda 4eb9 0007 c870           jsr $0007c870
L00004ce0 4cdf 60ff                movem.l (a7)+,d0-d7/a5-a6
L00004ce4 3438 3c92                move.w $3c92 [4c3e],d2
L00004ce8 0c42 5482                cmp.w #$5482,d2
L00004cec 6748                     beq.b #$48 == $00004d36 (F)
L00004cee 363c 4e3a                move.w #$4e3a,d3
L00004cf2 b443                     cmp.w d3,d2
L00004cf4 6726                     beq.b #$26 == $00004d1c (F)
L00004cf6 0c42 4e64                cmp.w #$4e64,d2
L00004cfa 6720                     beq.b #$20 == $00004d1c (F)
L00004cfc 0c42 5058                cmp.w #$5058,d2
L00004d00 6736                     beq.b #$36 == $00004d38 (F)
L00004d02 363c 4d48                move.w #$4d48,d3
L00004d06 0c42 5308                cmp.w #$5308,d2
L00004d0a 6710                     beq.b #$10 == $00004d1c (F)
L00004d0c b642                     cmp.w d2,d3
L00004d0e 670c                     beq.b #$0c == $00004d1c (F)
L00004d10 41f8 5457                lea.l $5457,a0
L00004d14 6100 0722                bsr.w #$0722 == $00005438
L00004d18 363c 4d56                move.w #$4d56,d3
L00004d1c 31c3 3c92                move.w d3,$3c92 [4c3e]
L00004d20 3438 6306                move.w $6306 [0000],d2
L00004d24 dc46                     add.w d6,d6
L00004d26 dc46                     add.w d6,d6
L00004d28 d446                     add.w d6,d2
L00004d2a 0c42 000c                cmp.w #$000c,d2
L00004d2e 6502                     bcs.b #$02 == $00004d32 (F)
L00004d30 740c                     moveq #$0c,d2
L00004d32 31c2 6306                move.w d2,$6306 [0000]
L00004d36 4e75                     rts  == $6000001a
L00004d38 3438 62f2                move.w $62f2 [0000],d2
L00004d3c d446                     add.w d6,d2
L00004d3e d446                     add.w d6,d2
L00004d40 d446                     add.w d6,d2
L00004d42 31c2 62f2                move.w d2,$62f2 [0000]
L00004d46 4e75                     rts  == $6000001a
L00004d48 5378 6306                subq.w #$01,$6306 [0000]
L00004d4c 66e8                     bne.b #$e8 == $00004d36 (T)
L00004d4e 31fc 5308 3c92           move.w #$5308,$3c92 [4c3e]
L00004d54 6024                     bra.b #$24 == $00004d7a (T)
L00004d56 4a78 6318                tst.w $6318 [0000]
L00004d5a 6704                     beq.b #$04 == $00004d60 (F)
L00004d5c 6100 0452                bsr.w #$0452 == $000051b0
L00004d60 5378 6306                subq.w #$01,$6306 [0000]
L00004d64 66d0                     bne.b #$d0 == $00004d36 (T)
L00004d66 31fc 4c3e 3c92           move.w #$4c3e,$3c92 [4c3e]
00004d6c 4a78 6318                tst.w $6318 [0000]
00004d70 6704                     beq.b #$04 == $00004d76 (F)
00004d72 6100 0434                bsr.w #$0434 == $000051a8
00004d76 6100 06b8                bsr.w #$06b8 == $00005430
00004d7a 4a39 0007 c874           tst.b $0007c874 [00]
00004d80 67b4                     beq.b #$b4 == $00004d36 (F)
00004d82 4eb9 0004 8004           jsr $00048004
00004d88 4278 6318                clr.w $6318 [0000]
00004d8c 7003                     moveq #$03,d0
00004d8e 4eb9 0004 8010           jsr $00048010
00004d94 31fc 4da2 3c92           move.w #$4da2,$3c92 [4c3e]
00004d9a 31fc 63dc 6326           move.w #$63dc,$6326 [0000]
00004da0 4e75                     rts  == $6000001a
00004da2 3078 6326                movea.w $6326 [0000],a0
00004da6 6100 0690                bsr.w #$0690 == $00005438
00004daa 31c8 6326                move.w a0,$6326 [0000]
00004dae 4a10                     tst.b (a0) [00]
00004db0 6684                     bne.b #$84 == $00004d36 (T)
00004db2 4eb9 0004 800c           jsr $0004800c
00004db8 303c 0032                move.w #$0032,d0
00004dbc 6100 10ce                bsr.w #$10ce == $00005e8c
00004dc0 6100 0066                bsr.w #$0066 == $00004e28
00004dc4 0839 0000 0007 c874      btst.b #$0000,$0007c874 [00]
00004dcc 6708                     beq.b #$08 == $00004dd6 (F)
00004dce 41f8 4e1c                lea.l $4e1c,a0
00004dd2 6100 19f6                bsr.w #$19f6 == $000067ca
00004dd6 0839 0001 0007 c874      btst.b #$0001,$0007c874 [00]
00004dde 6708                     beq.b #$08 == $00004de8 (F)
00004de0 41f8 4e0e                lea.l $4e0e,a0
00004de4 6100 19e4                bsr.w #$19e4 == $000067ca
00004de8 6100 eed6                bsr.w #$eed6 == $00003cc0
00004dec 303c 001e                move.w #$001e,d0
00004df0 6100 109a                bsr.w #$109a == $00005e8c
00004df4 0839 0001 0007 c874      btst.b #$0001,$0007c874 [00]
00004dfc 6700 ed04                beq.w #$ed04 == $00003b02 (F)
00004e00 4eb9 0004 8004           jsr $00048004
00004e06 6100 ef84                bsr.w #$ef84 == $00003d8c
00004e0a 6000 ba14                bra.w #$ba14 == $00000820 (T)
00004e0e 5f0f                     illegal
00004e10 4741                     illegal
00004e12 4d45                     illegal
00004e14 2020                     move.l -(a0) [4ef83000],d0
00004e16 4f56                     illegal
00004e18 4552                     illegal
00004e1a 00ff                     illegal
00004e1c 4310                     [ chk.l (a0),d1 ]
00004e1e 5449                     addaq.w #$02,a1
00004e20 4d45                     illegal
00004e22 2020                     move.l -(a0) [4ef83000],d0
00004e24 5550                     subq.w #$02,(a0) [003c]
00004e26 00ff                     illegal
00004e28 2079 0000 36f6           movea.l $000036f6 [00061b9c],a0
00004e2e 3e3c 1c8b                move.w #$1c8b,d7
00004e32 4298                     clr.l (a0)+ [003c004a]
00004e34 51cf fffc                dbf .w d7,#$fffc == $00004e32 (F)
00004e38 4e75                     rts  == $6000001a
00004e3a 7610                     moveq #$10,d3
00004e3c 4a39 0007 c874           tst.b $0007c874 [00]
00004e42 661c                     bne.b #$1c == $00004e60 (T)
00004e44 41f8 6318                lea.l $6318,a0
00004e48 3410                     move.w (a0) [003c],d2
00004e4a 0c42 0050                cmp.w #$0050,d2
00004e4e 6410                     bcc.b #$10 == $00004e60 (T)
00004e50 5250                     addq.w #$01,(a0) [003c]
00004e52 4243                     clr.w d3
00004e54 5378 6306                subq.w #$01,$6306 [0000]
00004e58 6606                     bne.b #$06 == $00004e60 (T)
00004e5a 31fc 4e64 3c92           move.w #$4e64,$3c92 [4c3e]
00004e60 11c3 6308                move.b d3,$6308 [00]
00004e64 41f8 6318                lea.l $6318,a0
00004e68 3a10                     move.w (a0) [003c],d5
00004e6a 1838 6308                move.b $6308 [00],d4
00004e6e 0804 0003                btst.l #$0003,d4
00004e72 6734                     beq.b #$34 == $00004ea8 (F)
00004e74 31fc 0048 67c6           move.w #$0048,$67c6 [0048]
00004e7a 5345                     subq.w #$01,d5
00004e7c 6228                     bhi.b #$28 == $00004ea6 (T)
00004e7e 4250                     clr.w (a0) [003c]
00004e80 31fc 5058 3c92           move.w #$5058,$3c92 [4c3e]
00004e86 31fc 0005 62f2           move.w #$0005,$62f2 [0000]
00004e8c 31fc 6426 6326           move.w #$6426,$6326 [0000]
00004e92 3401                     move.w d1,d2
00004e94 d478 67be                add.w $67be [00f0],d2
00004e98 5542                     subq.w #$02,d2
00004e9a 0242 0007                and.w #$0007,d2
00004e9e 9242                     sub.w d2,d1
00004ea0 31c1 67c4                move.w d1,$67c4 [0048]
00004ea4 4e75                     rts  == $6000001a
00004ea6 3085                     move.w d5,(a0) [003c]
00004ea8 0804 0002                btst.l #$0002,d4
00004eac 6700 0012                beq.w #$0012 == $00004ec0 (F)
00004eb0 31fc 0028 67c6           move.w #$0028,$67c6 [0048]
00004eb6 5245                     addq.w #$01,d5
00004eb8 0c45 0050                cmp.w #$0050,d5
00004ebc 6402                     bcc.b #$02 == $00004ec0 (T)
00004ebe 3085                     move.w d5,(a0) [003c]
00004ec0 41f8 6314                lea.l $6314,a0
00004ec4 4c90 000c                movem.w (a0),d2-d3
00004ec8 4247                     clr.w d7
00004eca 7c07                     moveq #$07,d6
00004ecc 0c45 0028                cmp.w #$0028,d5
00004ed0 640a                     bcc.b #$0a == $00004edc (T)
00004ed2 7c03                     moveq #$03,d6
00004ed4 0c46 0014                cmp.w #$0014,d6
00004ed8 6402                     bcc.b #$02 == $00004edc (T)
00004eda 7c01                     moveq #$01,d6
00004edc cc78 632c                and.w $632c [0000],d6
00004ee0 660a                     bne.b #$0a == $00004eec (T)
00004ee2 0244 0003                and.w #$0003,d4
00004ee6 e244                     asr.w #$01,d4
00004ee8 9947                     subx.w d7,d4
00004eea 3e04                     move.w d4,d7
00004eec 3802                     move.w d2,d4
00004eee 48c4                     ext.l d4
00004ef0 89c5                     divs.w d5,d4
00004ef2 9847                     sub.w d7,d4
00004ef4 d644                     add.w d4,d3
00004ef6 9443                     sub.w d3,d2
00004ef8 0642 0080                add.w #$0080,d2
00004efc 0c42 0100                cmp.w #$0100,d2
00004f00 6406                     bcc.b #$06 == $00004f08 (T)
00004f02 0442 0080                sub.w #$0080,d2
00004f06 600e                     bra.b #$0e == $00004f16 (T)
00004f08 4243                     clr.w d3
00004f0a 0442 0080                sub.w #$0080,d2
00004f0e 6a04                     bpl.b #$04 == $00004f14 (T)
00004f10 7481                     moveq #$81,d2
00004f12 6002                     bra.b #$02 == $00004f16 (T)
00004f14 747f                     moveq #$7f,d2
00004f16 4890 000c                movem.w d2-d3,(a0)
00004f1a 41f8 6314                lea.l $6314,a0
00004f1e 45f8 67c2                lea.l $67c2,a2
00004f22 6100 0186                bsr.w #$0186 == $000050aa
00004f26 4cb8 0003 67c2           movem.w $67c2,d0-d1
00004f2c 4cb8 0060 6328           movem.w $6328,d5-d6
00004f32 9a43                     sub.w d3,d5
00004f34 31c5 62f4                move.w d5,$62f4 [0000]
00004f38 31c5 630e                move.w d5,$630e [0000]
00004f3c 9846                     sub.w d6,d4
00004f3e 31c4 62f6                move.w d4,$62f6 [0000]
00004f42 d244                     add.w d4,d1
00004f44 d045                     add.w d5,d0
00004f46 5941                     subq.w #$04,d1
00004f48 5b40                     subq.w #$05,d0
00004f4a 6100 0654                bsr.w #$0654 == $000055a0
00004f4e 7e02                     moveq #$02,d7
00004f50 1430 3000                move.b (a0,d3.W,$00) == $00000d13 [d6],d2
00004f54 0c02 0017                cmp.b #$17,d2
00004f58 6534                     bcs.b #$34 == $00004f8e (F)
00004f5a 1430 3001                move.b (a0,d3.W,$01) == $00000d14 [00],d2
00004f5e 0c02 0017                cmp.b #$17,d2
00004f62 652a                     bcs.b #$2a == $00004f8e (F)
00004f64 9679 0000 8002           sub.w $00008002 [00c0],d3
00004f6a 51cf ffe4                dbf .w d7,#$ffe4 == $00004f50 (F)
00004f6e 4cb8 0003 67c2           movem.w $67c2,d0-d1
00004f74 d244                     add.w d4,d1
00004f76 d045                     add.w d5,d0
00004f78 48b8 0003 67c2           movem.w d0-d1,$67c2
00004f7e 21f8 631a 6328           move.l $631a [00000034],$6328 [00000000]
00004f84 0838 0004 6308           btst.b #$0004,$6308 [00]
00004f8a 6622                     bne.b #$22 == $00004fae (T)
00004f8c 4e75                     rts  == $6000001a
00004f8e 4a44                     tst.w d4
00004f90 6b08                     bmi.b #$08 == $00004f9a (F)
00004f92 5578 6318                subq.w #$02,$6318 [0000]
00004f96 6000 ff82                bra.w #$ff82 == $00004f1a (T)
00004f9a 48a7 ff00                movem.w d0-d7,-(a7)
00004f9e 7c02                     moveq #$02,d6
00004fa0 6100 fd2a                bsr.w #$fd2a == $00004ccc
00004fa4 4c9f 00ff                movem.w (a7)+,d0-d7
00004fa8 4244                     clr.w d4
00004faa 4245                     clr.w d5
00004fac 601e                     bra.b #$1e == $00004fcc (T)
00004fae 4cb8 0030 62f4           movem.w $62f4,d4-d5
00004fb4 5745                     subq.w #$03,d5
00004fb6 0c45 fffa                cmp.w #$fffa,d5
00004fba 6a02                     bpl.b #$02 == $00004fbe (T)
00004fbc 7afa                     moveq #$fa,d5
00004fbe 5544                     subq.w #$02,d4
00004fc0 0c44 fffc                cmp.w #$fffc,d4
00004fc4 6404                     bcc.b #$04 == $00004fca (T)
00004fc6 5bc4                     smi.b d4 (F)
00004fc8 e544                     asl.w #$02,d4
00004fca 5444                     addq.w #$02,d4
00004fcc 48b8 0030 62f4           movem.w d4-d5,$62f4
00004fd2 4278 6318                clr.w $6318 [0000]
00004fd6 4cb8 0003 67c2           movem.w $67c2,d0-d1
00004fdc 6000 0486                bra.w #$0486 == $00005464 (T)
00004fe0 33fc 6419 0000 6326      move.w #$6419,$00006326 [0000]
00004fe8 31fc 4ff6 3c92           move.w #$4ff6,$3c92 [4c3e]
00004fee 7008                     moveq #$08,d0
00004ff0 4eb9 0004 8014           jsr $00048014
00004ff6 3078 6326                movea.w $6326 [0000],a0
00004ffa 6100 043c                bsr.w #$043c == $00005438
00004ffe 31c8 6326                move.w a0,$6326 [0000]
00005002 4a10                     tst.b (a0) [00]
00005004 662e                     bne.b #$2e == $00005034 (T)
00005006 31fc 0008 62f2           move.w #$0008,$62f2 [0000]
0000500c 31fc 5036 3c92           move.w #$5036,$3c92 [4c3e]
00005012 6100 f62a                bsr.w #$f62a == $0000463e
00005016 0440 0007                sub.w #$0007,d0
0000501a 3438 62ee                move.w $62ee [0001],d2
0000501e 5ac2                     spl.b d2 (T)
00005020 4882                     ext.w d2
00005022 6a04                     bpl.b #$04 == $00005028 (T)
00005024 0640 000e                add.w #$000e,d0
00005028 5642                     addq.w #$03,d2
0000502a 30c2                     move.w d2,(a0)+ [003c]
0000502c 0441 0010                sub.w #$0010,d1
00005030 4890 0003                movem.w d0-d1,(a0)
00005034 4e75                     rts  == $6000001a
00005036 1839 0000 6308           move.b $00006308 [00],d4
0000503c 6600 0010                bne.w #$0010 == $0000504e (T)
00005040 5378 62f2                subq.w #$01,$62f2 [0000]
00005044 66ee                     bne.b #$ee == $00005034 (T)
00005046 41f8 63d3                lea.l $63d3,a0
0000504a 6000 03ec                bra.w #$03ec == $00005438 (T)
0000504e 31fc 4c3e 3c92           move.w #$4c3e,$3c92 [4c3e]
00005054 6000 fbe8                bra.w #$fbe8 == $00004c3e (T)
00005058 5378 62f2                subq.w #$01,$62f2 [0000]
0000505c 66d6                     bne.b #$d6 == $00005034 (T)
0000505e 31fc 0006 62f2           move.w #$0006,$62f2 [0000]
00005064 5b78 67c4                subq.w #$05,$67c4 [0048]
00005068 5941                     subq.w #$04,d1
0000506a 3438 62ee                move.w $62ee [0001],d2
0000506e 6b12                     bmi.b #$12 == $00005082 (F)
00005070 5e40                     addq.w #$07,d0
00005072 6100 052c                bsr.w #$052c == $000055a0
00005076 0c02 0017                cmp.b #$17,d2
0000507a 6516                     bcs.b #$16 == $00005092 (F)
0000507c 5278 67c2                addq.w #$01,$67c2 [0050]
00005080 6010                     bra.b #$10 == $00005092 (T)
00005082 5d40                     subq.w #$06,d0
00005084 6100 051a                bsr.w #$051a == $000055a0
00005088 0c02 0017                cmp.b #$17,d2
0000508c 6504                     bcs.b #$04 == $00005092 (F)
0000508e 5378 67c2                subq.w #$01,$67c2 [0050]
00005092 3078 6326                movea.w $6326 [0000],a0
00005096 6100 03a0                bsr.w #$03a0 == $00005438
0000509a 31c8 6326                move.w a0,$6326 [0000]
0000509e 1e10                     move.b (a0) [00],d7
000050a0 6606                     bne.b #$06 == $000050a8 (T)
000050a2 31fc 5414 3c92           move.w #$5414,$3c92 [4c3e]
000050a8 4e75                     rts  == $6000001a
000050aa 43e8 007c                lea.l (a0,$007c) == $00000a7c,a1
000050ae 3410                     move.w (a0) [003c],d2
000050b0 e242                     asr.w #$01,d2
000050b2 3802                     move.w d2,d4
000050b4 6a02                     bpl.b #$02 == $000050b8 (T)
000050b6 4444                     neg.w d4
000050b8 4243                     clr.w d3
000050ba 1631 40c0                move.b (a1,d4.W,$c0) == $0004001b [00],d3
000050be c6e8 0004                mulu.w (a0,$0004) == $00000a04 [0000],d3
000050c2 0802 000f                btst.l #$000f,d2
000050c6 6702                     beq.b #$02 == $000050ca (F)
000050c8 4443                     neg.w d3
000050ca e043                     asr.w #$08,d3
000050cc 3143 0006                move.w d3,(a0,$0006) == $00000a06 [2ffc]
000050d0 3404                     move.w d4,d2
000050d2 4442                     neg.w d2
000050d4 4244                     clr.w d4
000050d6 1831 203f                move.b (a1,d2.W,$3f) == $000409a0 [00],d4
000050da c8e8 0004                mulu.w (a0,$0004) == $00000a04 [0000],d4
000050de e04c                     lsr.w #$08,d4
000050e0 3144 0008                move.w d4,(a0,$0008) == $00000a08 [0000]
000050e4 4e75                     rts  == $6000001a
000050e6 4278 62ee                clr.w $62ee [0001]
000050ea 707f                     moveq #$7f,d0
000050ec 600c                     bra.b #$0c == $000050fa (T)
000050ee 31fc e000 62ee           move.w #$e000,$62ee [0001]
000050f4 7081                     moveq #$81,d0
000050f6 6002                     bra.b #$02 == $000050fa (T)
000050f8 4240                     clr.w d0
000050fa 31fc 0048 67c6           move.w #$0048,$67c6 [0048]
00005100 41f8 6314                lea.l $6314,a0
00005104 30c0                     move.w d0,(a0)+ [003c]
00005106 4298                     clr.l (a0)+ [003c004a]
00005108 6100 f534                bsr.w #$f534 == $0000463e
0000510c 30bc 0001                move.w #$0001,(a0) [003c]
00005110 31fc 5132 3c92           move.w #$5132,$3c92 [4c3e]
00005116 41f8 63d0                lea.l $63d0,a0
0000511a 6100 031c                bsr.w #$031c == $00005438
0000511e 7007                     moveq #$07,d0
00005120 4eb9 0004 8014           jsr $00048014
00005126 4cb8 0003 67c2           movem.w $67c2,d0-d1
0000512c 08b8 0004 6308           bclr.b #$0004,$6308 [00]
00005132 41f8 6314                lea.l $6314,a0
00005136 0839 0004 0000 6308      btst.b #$0004,$00006308 [00]
0000513e 667e                     bne.b #$7e == $000051be (T)
00005140 3428 0004                move.w (a0,$0004) == $00000a04 [0000],d2
00005144 5442                     addq.w #$02,d2
00005146 0c42 0028                cmp.w #$0028,d2
0000514a 640a                     bcc.b #$0a == $00005156 (T)
0000514c 5242                     addq.w #$01,d2
0000514e 0c42 0014                cmp.w #$0014,d2
00005152 6402                     bcc.b #$02 == $00005156 (T)
00005154 5242                     addq.w #$01,d2
00005156 3142 0004                move.w d2,(a0,$0004) == $00000a04 [0000]
0000515a 6100 ff4e                bsr.w #$ff4e == $000050aa
0000515e 5643                     addq.w #$03,d3
00005160 3e38 62ee                move.w $62ee [0001],d7
00005164 6a02                     bpl.b #$02 == $00005168 (T)
00005166 5f43                     subq.w #$07,d3
00005168 0644 000a                add.w #$000a,d4
0000516c 9244                     sub.w d4,d1
0000516e 6538                     bcs.b #$38 == $000051a8 (F)
00005170 3a38 67be                move.w $67be [00f0],d5
00005174 da41                     add.w d1,d5
00005176 0805 0002                btst.l #$0002,d5
0000517a 6632                     bne.b #$32 == $000051ae (T)
0000517c d043                     add.w d3,d0
0000517e 6100 0420                bsr.w #$0420 == $000055a0
00005182 0c02 0017                cmp.b #$17,d2
00005186 6520                     bcs.b #$20 == $000051a8 (F)
00005188 0c02 0085                cmp.b #$85,d2
0000518c 641a                     bcc.b #$1a == $000051a8 (T)
0000518e 0c02 0079                cmp.b #$79,d2
00005192 651a                     bcs.b #$1a == $000051ae (F)
00005194 31fc 4e64 3c92           move.w #$4e64,$3c92 [4c3e]
0000519a 21f8 631a 6328           move.l $631a [00000034],$6328 [00000000]
000051a0 41f8 6416                lea.l $6416,a0
000051a4 6000 0292                bra.w #$0292 == $00005438 (T)
000051a8 31fc 51b0 3c92           move.w #$51b0,$3c92 [4c3e]
000051ae 4e75                     rts  == $6000001a
000051b0 41f8 6314                lea.l $6314,a0
000051b4 0839 0004 0000 6308      btst.b #$0004,$00006308 [00]
000051bc 6706                     beq.b #$06 == $000051c4 (F)
000051be 317c 0002 0004           move.w #$0002,(a0,$0004) == $00000a04 [0000]
000051c4 5768 0004                subq.w #$03,(a0,$0004) == $00000a04 [0000]
000051c8 6304                     bls.b #$04 == $000051ce (F)
000051ca 6000 fede                bra.w #$fede == $000050aa (T)
000051ce 4268 0004                clr.w (a0,$0004) == $00000a04 [0000]
000051d2 31fc 4c3e 3c92           move.w #$4c3e,$3c92 [4c3e]
000051d8 41f8 63d3                lea.l $63d3,a0
000051dc 6000 025a                bra.w #$025a == $00005438 (T)
000051e0 4e75                     rts  == $6000001a
000051e2 31fc 0028 67c6           move.w #$0028,$67c6 [0048]
000051e8 3438 67bc                move.w $67bc [0000],d2
000051ec d440                     add.w d0,d2
000051ee 0242 0007                and.w #$0007,d2
000051f2 5942                     subq.w #$04,d2
000051f4 66ea                     bne.b #$ea == $000051e0 (T)
000051f6 6100 03a8                bsr.w #$03a8 == $000055a0
000051fa 0c02 0085                cmp.b #$85,d2
000051fe 65e0                     bcs.b #$e0 == $000051e0 (F)
00005200 602c                     bra.b #$2c == $0000522e (T)
00005202 6104                     bsr.b #$04 == $00005208
00005204 6000 022a                bra.w #$022a == $00005430 (T)
00005208 31fc 0048 67c6           move.w #$0048,$67c6 [0048]
0000520e 3438 67bc                move.w $67bc [0000],d2
00005212 d440                     add.w d0,d2
00005214 0242 0007                and.w #$0007,d2
00005218 5942                     subq.w #$04,d2
0000521a 66c4                     bne.b #$c4 == $000051e0 (T)
0000521c 0441 000c                sub.w #$000c,d1
00005220 6100 037e                bsr.w #$037e == $000055a0
00005224 0641 000c                add.w #$000c,d1
00005228 0c02 0085                cmp.b #$85,d2
0000522c 65b2                     bcs.b #$b2 == $000051e0 (F)
0000522e 584f                     addaq.w #$04,a7
00005230 0238 000c 6308           and.b #$0c,$6308 [00]
00005236 31fc 5308 3c92           move.w #$5308,$3c92 [4c3e]
0000523c 6000 00ca                bra.w #$00ca == $00005308 (T)
00005240 61a0                     bsr.b #$a0 == $000051e2
00005242 6002                     bra.b #$02 == $00005246 (T)
00005244 61c2                     bsr.b #$c2 == $00005208
00005246 5840                     addq.w #$04,d0
00005248 5541                     subq.w #$02,d1
0000524a 6100 0354                bsr.w #$0354 == $000055a0
0000524e 0c02 0017                cmp.b #$17,d2
00005252 653c                     bcs.b #$3c == $00005290 (F)
00005254 5278 67c2                addq.w #$01,$67c2 [0050]
00005258 5e41                     addq.w #$07,d1
0000525a 5b40                     subq.w #$05,d0
0000525c 6100 0342                bsr.w #$0342 == $000055a0
00005260 0402 0079                sub.b #$79,d2
00005264 0c02 000d                cmp.b #$0d,d2
00005268 6400 01f0                bcc.w #$01f0 == $0000545a (T)
0000526c 41f8 62ea                lea.l $62ea,a0
00005270 d078 67bc                add.w $67bc [0000],d0
00005274 e248                     lsr.w #$01,d0
00005276 0240 0007                and.w #$0007,d0
0000527a 5a40                     addq.w #$05,d0
0000527c 30c0                     move.w d0,(a0)+ [003c]
0000527e 0240 0006                and.w #$0006,d0
00005282 e248                     lsr.w #$01,d0
00005284 6602                     bne.b #$02 == $00005288 (T)
00005286 7002                     moveq #$02,d0
00005288 5240                     addq.w #$01,d0
0000528a 30c0                     move.w d0,(a0)+ [003c]
0000528c 30bc 0001                move.w #$0001,(a0) [003c]
00005290 4e75                     rts  == $6000001a
00005292 6100 ff4e                bsr.w #$ff4e == $000051e2
00005296 6004                     bra.b #$04 == $0000529c (T)
00005298 6100 ff6e                bsr.w #$ff6e == $00005208
0000529c 5b40                     subq.w #$05,d0
0000529e 5541                     subq.w #$02,d1
000052a0 6100 02fe                bsr.w #$02fe == $000055a0
000052a4 0c02 0017                cmp.b #$17,d2
000052a8 65e6                     bcs.b #$e6 == $00005290 (F)
000052aa 5378 67c2                subq.w #$01,$67c2 [0050]
000052ae 5e41                     addq.w #$07,d1
000052b0 5a40                     addq.w #$05,d0
000052b2 6100 02ec                bsr.w #$02ec == $000055a0
000052b6 0402 0079                sub.b #$79,d2
000052ba 0c02 000d                cmp.b #$0d,d2
000052be 6400 019a                bcc.w #$019a == $0000545a (T)
000052c2 41f8 62ea                lea.l $62ea,a0
000052c6 d078 67bc                add.w $67bc [0000],d0
000052ca 4640                     not.w d0
000052cc e248                     lsr.w #$01,d0
000052ce 0240 0007                and.w #$0007,d0
000052d2 0640 e005                add.w #$e005,d0
000052d6 30c0                     move.w d0,(a0)+ [003c]
000052d8 0240 e006                and.w #$e006,d0
000052dc e208                     lsr.b #$01,d0
000052de 6604                     bne.b #$04 == $000052e4 (T)
000052e0 303c e002                move.w #$e002,d0
000052e4 5240                     addq.w #$01,d0
000052e6 30c0                     move.w d0,(a0)+ [003c]
000052e8 30bc e001                move.w #$e001,(a0) [003c]
000052ec 4e75                     rts  == $6000001a
000052ee d645                     add.w d5,d3
000052f0 1430 3000                move.b (a0,d3.W,$00) == $00000d13 [d6],d2
000052f4 0402 0079                sub.b #$79,d2
000052f8 0c02 000d                cmp.b #$0d,d2
000052fc 646a                     bcc.b #$6a == $00005368 (T)
000052fe 31fc 4c3e 3c92           move.w #$4c3e,$3c92 [4c3e]
00005304 6000 f938                bra.w #$f938 == $00004c3e (T)
00005308 0838 0004 6308           btst.b #$0004,$6308 [00]
0000530e 6600 014a                bne.w #$014a == $0000545a (T)
00005312 0838 0000 632d           btst.b #$0000,$632d [00]
00005318 66d2                     bne.b #$d2 == $000052ec (T)
0000531a 4244                     clr.w d4
0000531c 1838 6308                move.b $6308 [00],d4
00005320 3438 67be                move.w $67be [00f0],d2
00005324 d441                     add.w d1,d2
00005326 0242 0007                and.w #$0007,d2
0000532a 6722                     beq.b #$22 == $0000534e (F)
0000532c 0804 0002                btst.l #$0002,d4
00005330 6708                     beq.b #$08 == $0000533a (F)
00005332 5241                     addq.w #$01,d1
00005334 31fc 0028 67c6           move.w #$0028,$67c6 [0048]
0000533a 0804 0003                btst.l #$0003,d4
0000533e 6708                     beq.b #$08 == $00005348 (F)
00005340 5341                     subq.w #$01,d1
00005342 31fc 0048 67c6           move.w #$0048,$67c6 [0048]
00005348 31c1 67c4                move.w d1,$67c4 [0048]
0000534c 6058                     bra.b #$58 == $000053a6 (T)
0000534e 6100 0250                bsr.w #$0250 == $000055a0
00005352 3a04                     move.w d4,d5
00005354 0205 0003                and.b #$03,d5
00005358 11c5 6308                move.b d5,$6308 [00]
0000535c 7a01                     moveq #$01,d5
0000535e e244                     asr.w #$01,d4
00005360 658c                     bcs.b #$8c == $000052ee (F)
00005362 7aff                     moveq #$ff,d5
00005364 e244                     asr.w #$01,d4
00005366 6586                     bcs.b #$86 == $000052ee (F)
00005368 e244                     asr.w #$01,d4
0000536a 6414                     bcc.b #$14 == $00005380 (T)
0000536c 31fc 0028 67c6           move.w #$0028,$67c6 [0048]
00005372 0c02 0085                cmp.b #$85,d2
00005376 6500 0056                bcs.w #$0056 == $000053ce (F)
0000537a 5278 67c4                addq.w #$01,$67c4 [0048]
0000537e 6026                     bra.b #$26 == $000053a6 (T)
00005380 e244                     asr.w #$01,d4
00005382 6448                     bcc.b #$48 == $000053cc (T)
00005384 31fc 0048 67c6           move.w #$0048,$67c6 [0048]
0000538a 3a39 0000 8002           move.w $00008002 [00c0],d5
00005390 9645                     sub.w d5,d3
00005392 9645                     sub.w d5,d3
00005394 9645                     sub.w d5,d3
00005396 1430 3000                move.b (a0,d3.W,$00) == $00000d13 [d6],d2
0000539a 0c02 0085                cmp.b #$85,d2
0000539e 652e                     bcs.b #$2e == $000053ce (F)
000053a0 5341                     subq.w #$01,d1
000053a2 31c1 67c4                move.w d1,$67c4 [0048]
000053a6 3438 67be                move.w $67be [00f0],d2
000053aa d478 67c4                add.w $67c4 [0048],d2
000053ae 5442                     addq.w #$02,d2
000053b0 4642                     not.w d2
000053b2 0242 0007                and.w #$0007,d2
000053b6 0882 0002                bclr.l #$0002,d2
000053ba 6704                     beq.b #$04 == $000053c0 (F)
000053bc 0642 e000                add.w #$e000,d2
000053c0 0642 0020                add.w #$0020,d2
000053c4 41f8 62ea                lea.l $62ea,a0
000053c8 4298                     clr.l (a0)+ [003c004a]
000053ca 3082                     move.w d2,(a0) [003c]
000053cc 4e75                     rts  == $6000001a
000053ce 31fc 4c3e 3c92           move.w #$4c3e,$3c92 [4c3e]
000053d4 4e75                     rts  == $6000001a
000053d6 0641 0008                add.w #$0008,d1
000053da 6100 01c4                bsr.w #$01c4 == $000055a0
000053de 4cb8 0003 67c2           movem.w $67c2,d0-d1
000053e4 0c02 0017                cmp.b #$17,d2
000053e8 650a                     bcs.b #$0a == $000053f4 (F)
000053ea 31fc 8000 5506           move.w #$8000,$5506 [4e71]
000053f0 6000 0068                bra.w #$0068 == $0000545a (T)
000053f4 6100 fdec                bsr.w #$fdec == $000051e2
000053f8 41f8 63d6                lea.l $63d6,a0
000053fc 613a                     bsr.b #$3a == $00005438
000053fe 31fc 5406 3c92           move.w #$5406,$3c92 [4c3e]
00005404 4e75                     rts  == $6000001a
00005406 41f8 63d9                lea.l $63d9,a0
0000540a 612c                     bsr.b #$2c == $00005438
0000540c 0838 0002 6308           btst.b #$0002,$6308 [00]
00005412 660c                     bne.b #$0c == $00005420 (T)
00005414 31fc 542a 3c92           move.w #$542a,$3c92 [4c3e]
0000541a 41f8 63d6                lea.l $63d6,a0
0000541e 6018                     bra.b #$18 == $00005438 (T)
00005420 0838 0004 6308           btst.b #$0004,$6308 [00]
00005426 66ae                     bne.b #$ae == $000053d6 (T)
00005428 4e75                     rts  == $6000001a
0000542a 31fc 4c3e 3c92           move.w #$4c3e,$3c92 [4c3e]
00005430 41f8 63d3                lea.l $63d3,a0
00005434 6000 0002                bra.w #$0002 == $00005438 (T)
00005438 3f07                     move.w d7,-(a7) [09ec]
0000543a 43f8 62ee                lea.l $62ee,a1
0000543e 3e11                     move.w (a1) [0400],d7
00005440 0247 e000                and.w #$e000,d7
00005444 de18                     add.b (a0)+ [00],d7
00005446 3287                     move.w d7,(a1) [0400]
00005448 de18                     add.b (a0)+ [00],d7
0000544a 3307                     move.w d7,-(a1) [0000]
0000544c de18                     add.b (a0)+ [00],d7
0000544e 3307                     move.w d7,-(a1) [0000]
00005450 3e1f                     move.w (a7)+ [6000],d7
00005452 4e75                     rts  == $6000001a
00005454 0d01                     btst.l d6,d1
00005456 0111                     btst.b d0,(a1) [04]
00005458 ff02                     illegal
0000545a 4cb8 0003 67c2           movem.w $67c2,d0-d1
00005460 42b8 62f4                clr.l $62f4 [00000000]
00005464 31f8 67c4 67c6           move.w $67c4 [0048],$67c6 [0048]
0000546a 41fa ffe8                lea.l (pc,$ffe8) == $00005454,a0
0000546e 6100 ffc8                bsr.w #$ffc8 == $00005438
00005472 31fc 5482 3c92           move.w #$5482,$3c92 [4c3e]
00005478 31fc ffff 62fa           move.w #$ffff,$62fa [0001]
0000547e 4278 62f8                clr.w $62f8 [0000]
00005482 4cb8 0030 62f4           movem.w $62f4,d4-d5
00005488 31c4 630e                move.w d4,$630e [0000]
0000548c 673e                     beq.b #$3e == $000054cc (F)
0000548e 0441 0010                sub.w #$0010,d1
00005492 5940                     subq.w #$04,d0
00005494 d044                     add.w d4,d0
00005496 6100 0108                bsr.w #$0108 == $000055a0
0000549a 4cb8 0003 67c2           movem.w $67c2,d0-d1
000054a0 7e01                     moveq #$01,d7
000054a2 0c02 0017                cmp.b #$17,d2
000054a6 6520                     bcs.b #$20 == $000054c8 (F)
000054a8 1430 3001                move.b (a0,d3.W,$01) == $00000d14 [00],d2
000054ac 0c02 0017                cmp.b #$17,d2
000054b0 6516                     bcs.b #$16 == $000054c8 (F)
000054b2 d679 0000 8002           add.w $00008002 [00c0],d3
000054b8 1430 3000                move.b (a0,d3.W,$00) == $00000d13 [d6],d2
000054bc 51cf ffe4                dbf .w d7,#$ffe4 == $000054a2 (F)
000054c0 d840                     add.w d0,d4
000054c2 31c4 67c2                move.w d4,$67c2 [0050]
000054c6 6004                     bra.b #$04 == $000054cc (T)
000054c8 4278 62f4                clr.w $62f4 [0000]
000054cc 0c45 0010                cmp.w #$0010,d5
000054d0 6a02                     bpl.b #$02 == $000054d4 (T)
000054d2 5245                     addq.w #$01,d5
000054d4 31c5 62f6                move.w d5,$62f6 [0000]
000054d8 e445                     asr.w #$02,d5
000054da d245                     add.w d5,d1
000054dc 31c1 67c4                move.w d1,$67c4 [0048]
000054e0 0801 000f                btst.l #$000f,d1
000054e4 6702                     beq.b #$02 == $000054e8 (F)
000054e6 4e75                     rts  == $6000001a
000054e8 6100 00b6                bsr.w #$00b6 == $000055a0
000054ec 0c02 0017                cmp.b #$17,d2
000054f0 640c                     bcc.b #$0c == $000054fe (T)
000054f2 5f78 67c4                subq.w #$07,$67c4 [0048]
000054f6 4cb8 0003 67c2           movem.w $67c2,d0-d1
000054fc 6084                     bra.b #$84 == $00005482 (T)
000054fe 0402 0079                sub.b #$79,d2
00005502 0c02 000d                cmp.b #$0d,d2
00005506 4e71                     nop
00005508 40c6                     move.w sr,d6
0000550a da78 62f8                add.w $62f8 [0000],d5
0000550e 31c5 62f8                move.w d5,$62f8 [0000]
00005512 0c45 0008                cmp.w #$0008,d5
00005516 6506                     bcs.b #$06 == $0000551e (F)
00005518 31fc 4e71 5506           move.w #$4e71,$5506 [4e71]
0000551e 46c6                     move.w d6,sr
00005520 64c4                     bcc.b #$c4 == $000054e6 (T)
00005522 31fc 0028 67c6           move.w #$0028,$67c6 [0048]
00005528 41f8 5457                lea.l $5457,a0
0000552c 6100 ff0a                bsr.w #$ff0a == $00005438
00005530 21fc 0000 555a 3c90      move.l #$0000555a,$3c90 [00004c3e]
00005538 4278 62f6                clr.w $62f6 [0000]
0000553c 31fc 0001 62fa           move.w #$0001,$62fa [0001]
00005542 31fc 0002 62f2           move.w #$0002,$62f2 [0000]
00005548 3038 67be                move.w $67be [00f0],d0
0000554c d041                     add.w d1,d0
0000554e 0240 0007                and.w #$0007,d0
00005552 9240                     sub.w d0,d1
00005554 31c1 67c4                move.w d1,$67c4 [0048]
00005558 4e75                     rts  == $6000001a
0000555a 5378 62f2                subq.w #$01,$62f2 [0000]
0000555e 66f8                     bne.b #$f8 == $00005558 (T)
00005560 4a39 0007 c874           tst.b $0007c874 [00]
00005566 6600 f81a                bne.w #$f81a == $00004d82 (T)
0000556a 21fc 0000 4c3e 3c90      move.l #$00004c3e,$3c90 [00004c3e]
00005572 41f8 63d3                lea.l $63d3,a0
00005576 0c78 0050 62f8           cmp.w #$0050,$62f8 [0000]
0000557c 6b00 feba                bmi.w #$feba == $00005438 (F)
00005580 7c5a                     moveq #$5a,d6
00005582 6100 f748                bsr.w #$f748 == $00004ccc
00005586 13fc 0004 0007 c874      move.b #$04,$0007c874 [00]
0000558e 0839 0007 0007 c875      btst.b #$0007,$0007c875 [00]
00005596 6606                     bne.b #$06 == $0000559e (T)
00005598 4ef9 0007 c862           jmp $0007c862
0000559e 4e75                     rts  == $6000001a
000055a0 4cb8 000c 67bc           movem.w $67bc,d2-d3
000055a6 d440                     add.w d0,d2
000055a8 d641                     add.w d1,d3
000055aa e64a                     lsr.w #$03,d2
000055ac e64b                     lsr.w #$03,d3
000055ae c6f9 0000 8002           mulu.w $00008002 [00c0],d3
000055b4 d642                     add.w d2,d3
000055b6 41f9 0000 807c           lea.l $0000807c,a0
000055bc 4242                     clr.w d2
000055be 1430 3000                move.b (a0,d3.W,$00) == $00000d13 [d6],d2
000055c2 4e75                     rts  == $6000001a
000055c4 3438 6318                move.w $6318 [0000],d2
000055c8 6700 00dc                beq.w #$00dc == $000056a6 (F)
000055cc 4cb8 0003 67c2           movem.w $67c2,d0-d1
000055d2 0441 000c                sub.w #$000c,d1
000055d6 5640                     addq.w #$03,d0
000055d8 3438 62ee                move.w $62ee [0001],d2
000055dc 6a02                     bpl.b #$02 == $000055e0 (T)
000055de 5f40                     subq.w #$07,d0
000055e0 d241                     add.w d1,d1
000055e2 3e01                     move.w d1,d7
000055e4 c2fc 002a                mulu.w #$002a,d1
000055e8 e658                     ror.w #$03,d0
000055ea 3400                     move.w d0,d2
000055ec 0242 0fff                and.w #$0fff,d2
000055f0 d442                     add.w d2,d2
000055f2 d242                     add.w d2,d1
000055f4 48c1                     ext.l d1
000055f6 d2b8 36f6                add.l $36f6 [00061b9c],d1
000055fa 4cb8 000c 631a           movem.w $631a,d2-d3
00005600 d442                     add.w d2,d2
00005602 d643                     add.w d3,d3
00005604 6700 00a0                beq.w #$00a0 == $000056a6 (F)
00005608 0240 e000                and.w #$e000,d0
0000560c 7805                     moveq #$05,d4
0000560e 8840                     or.w d0,d4
00005610 0802 000f                btst.l #$000f,d2
00005614 6706                     beq.b #$06 == $0000561c (F)
00005616 4442                     neg.w d2
00005618 08c4 0003                bset.l #$0003,d4
0000561c d442                     add.w d2,d2
0000561e 3a02                     move.w d2,d5
00005620 9a43                     sub.w d3,d5
00005622 6a04                     bpl.b #$04 == $00005628 (T)
00005624 08c4 0006                bset.l #$0006,d4
00005628 3c05                     move.w d5,d6
0000562a 9c43                     sub.w d3,d6
0000562c 9e43                     sub.w d3,d7
0000562e 5747                     subq.w #$03,d7
00005630 6a02                     bpl.b #$02 == $00005634 (T)
00005632 d647                     add.w d7,d3
00005634 ed43                     asl.w #$06,d3
00005636 5443                     addq.w #$02,d3
00005638 0040 0bca                or.w #$0bca,d0
0000563c 4840                     swap.w d0
0000563e 3004                     move.w d4,d0
00005640 4bf9 00df f000           lea.l $00dff000,a5
00005646 0839 0006 00df f002      btst.b #$0006,$00dff002
0000564e 66f6                     bne.b #$f6 == $00005646 (T)
00005650 3b42 0062                move.w d2,(a5,$0062) == $00bfd162
00005654 3b46 0064                move.w d6,(a5,$0064) == $00bfd164
00005658 3b7c 002a 0066           move.w #$002a,(a5,$0066) == $00bfd166
0000565e 3b7c 002a 0060           move.w #$002a,(a5,$0060) == $00bfd160
00005664 3b7c c000 0074           move.w #$c000,(a5,$0074) == $00bfd174
0000566a 2b7c ffff ffff 0044      move.l #$ffffffff,(a5,$0044) == $00bfd144
00005672 3c3c eeee                move.w #$eeee,d6
00005676 7e03                     moveq #$03,d7
00005678 0839 0006 00df f002      btst.b #$0006,$00dff002
00005680 66f6                     bne.b #$f6 == $00005678 (T)
00005682 3b45 0052                move.w d5,(a5,$0052) == $00bfd152
00005686 2b40 0040                move.l d0,(a5,$0040) == $00bfd140
0000568a 2b41 0048                move.l d1,(a5,$0048) == $00bfd148
0000568e 2b41 0054                move.l d1,(a5,$0054) == $00bfd154
00005692 3b46 0072                move.w d6,(a5,$0072) == $00bfd172
00005696 3b43 0058                move.w d3,(a5,$0058) == $00bfd158
0000569a 0681 0000 1c8c           add.l #$00001c8c,d1
000056a0 4646                     not.w d6
000056a2 51cf ffd4                dbf .w d7,#$ffd4 == $00005678 (F)
000056a6 4cb8 0003 67c2           movem.w $67c2,d0-d1
000056ac 3438 62ee                move.w $62ee [0001],d2
000056b0 4244                     clr.w d4
000056b2 1802                     move.b d2,d4
000056b4 6700 003c                beq.w #$003c == $000056f2 (F)
000056b8 3601                     move.w d1,d3
000056ba 41f8 607c                lea.l $607c,a0
000056be d844                     add.w d4,d4
000056c0 d643                     add.w d3,d3
000056c2 9630 40fe                sub.b (a0,d4.W,$fe) == $00000aff [45],d3
000056c6 e243                     asr.w #$01,d3
000056c8 31c3 62f0                move.w d3,$62f0 [0000]
000056cc 6126                     bsr.b #$26 == $000056f4
000056ce 4cb8 0003 67c2           movem.w $67c2,d0-d1
000056d4 3438 62ec                move.w $62ec [0002],d2
000056d8 1402                     move.b d2,d2
000056da 6700 0016                beq.w #$0016 == $000056f2 (F)
000056de 6114                     bsr.b #$14 == $000056f4
000056e0 4cb8 0003 67c2           movem.w $67c2,d0-d1
000056e6 3438 62ea                move.w $62ea [0005],d2
000056ea 1402                     move.b d2,d2
000056ec 6700 0004                beq.w #$0004 == $000056f2 (F)
000056f0 6102                     bsr.b #$02 == $000056f4
000056f2 4e75                     rts  == $6000001a
000056f4 2278 62fe                movea.l $62fe [00010000],a1
000056f8 d241                     add.w d1,d1
000056fa e742                     asl.w #$03,d2
000056fc 43f1 20f8                lea.l (a1,d2.W,$f8) == $00040959,a1
00005700 6422                     bcc.b #$22 == $00005724 (T)
00005702 1819                     move.b (a1)+ [04],d4
00005704 4884                     ext.w d4
00005706 9244                     sub.w d4,d1
00005708 1819                     move.b (a1)+ [04],d4
0000570a 4884                     ext.w d4
0000570c d044                     add.w d4,d0
0000570e 4242                     clr.w d2
00005710 1419                     move.b (a1)+ [04],d2
00005712 3802                     move.w d2,d4
00005714 e74c                     lsl.w #$03,d4
00005716 9044                     sub.w d4,d0
00005718 4243                     clr.w d3
0000571a 1619                     move.b (a1)+ [04],d3
0000571c 2059                     movea.l (a1)+ [04004200],a0
0000571e d1f8 6302                adda.l $6302 [00000000],a0
00005722 6016                     bra.b #$16 == $0000573a (T)
00005724 1819                     move.b (a1)+ [04],d4
00005726 4884                     ext.w d4
00005728 9244                     sub.w d4,d1
0000572a 1819                     move.b (a1)+ [04],d4
0000572c 4884                     ext.w d4
0000572e 9044                     sub.w d4,d0
00005730 4242                     clr.w d2
00005732 1419                     move.b (a1)+ [04],d2
00005734 4243                     clr.w d3
00005736 1619                     move.b (a1)+ [04],d3
00005738 2059                     movea.l (a1)+ [04004200],a0
0000573a 3803                     move.w d3,d4
0000573c c8c2                     mulu.w d2,d4
0000573e d884                     add.l d4,d4
00005740 2244                     movea.l d4,a1
00005742 3201                     move.w d1,d1
00005744 6a12                     bpl.b #$12 == $00005758 (T)
00005746 4441                     neg.w d1
00005748 9641                     sub.w d1,d3
0000574a 6300 0106                bls.w #$0106 == $00005852 (F)
0000574e c2c2                     mulu.w d2,d1
00005750 d1c1                     adda.l d1,a0
00005752 d1c1                     adda.l d1,a0
00005754 7200                     moveq #$00,d1
00005756 6010                     bra.b #$10 == $00005768 (T)
00005758 3c3c 00ad                move.w #$00ad,d6
0000575c 9c41                     sub.w d1,d6
0000575e 6300 00f2                bls.w #$00f2 == $00005852 (F)
00005762 bc43                     cmp.w d3,d6
00005764 6a02                     bpl.b #$02 == $00005768 (T)
00005766 3606                     move.w d6,d3
00005768 7eff                     moveq #$ff,d7
0000576a 3a02                     move.w d2,d5
0000576c 7c07                     moveq #$07,d6
0000576e cc40                     and.w d0,d6
00005770 6622                     bne.b #$22 == $00005794 (T)
00005772 e640                     asr.w #$03,d0
00005774 6a0e                     bpl.b #$0e == $00005784 (T)
00005776 4440                     neg.w d0
00005778 9a40                     sub.w d0,d5
0000577a 6300 00d6                bls.w #$00d6 == $00005852 (F)
0000577e d0c0                     adda.w d0,a0
00005780 d0c0                     adda.w d0,a0
00005782 7000                     moveq #$00,d0
00005784 7814                     moveq #$14,d4
00005786 9840                     sub.w d0,d4
00005788 6f00 00c8                ble.w #$00c8 == $00005852 (F)
0000578c ba44                     cmp.w d4,d5
0000578e 633e                     bls.b #$3e == $000057ce (F)
00005790 3a04                     move.w d4,d5
00005792 603a                     bra.b #$3a == $000057ce (T)
00005794 4247                     clr.w d7
00005796 5245                     addq.w #$01,d5
00005798 e640                     asr.w #$03,d0
0000579a 6a1c                     bpl.b #$1c == $000057b8 (T)
0000579c 4440                     neg.w d0
0000579e 5340                     subq.w #$01,d0
000057a0 9a40                     sub.w d0,d5
000057a2 6300 00ae                bls.w #$00ae == $00005852 (F)
000057a6 d0c0                     adda.w d0,a0
000057a8 d0c0                     adda.w d0,a0
000057aa 70ff                     moveq #$ff,d0
000057ac 7808                     moveq #$08,d4
000057ae 9846                     sub.w d6,d4
000057b0 d844                     add.w d4,d4
000057b2 e868                     lsr.w d4,d0
000057b4 4840                     swap.w d0
000057b6 ce80                     and.l d0,d7
000057b8 7814                     moveq #$14,d4
000057ba 9840                     sub.w d0,d4
000057bc 6f00 0094                ble.w #$0094 == $00005852 (F)
000057c0 ba44                     cmp.w d4,d5
000057c2 630a                     bls.b #$0a == $000057ce (F)
000057c4 3a04                     move.w d4,d5
000057c6 78ff                     moveq #$ff,d4
000057c8 ed6c                     lsl.w d6,d4
000057ca ed6c                     lsl.w d6,d4
000057cc 3e04                     move.w d4,d7
000057ce ed43                     asl.w #$06,d3
000057d0 d645                     add.w d5,d3
000057d2 9445                     sub.w d5,d2
000057d4 d442                     add.w d2,d2
000057d6 7815                     moveq #$15,d4
000057d8 9845                     sub.w d5,d4
000057da d844                     add.w d4,d4
000057dc 2479 0000 36f6           movea.l $000036f6 [00061b9c],a2
000057e2 d040                     add.w d0,d0
000057e4 d4c0                     adda.w d0,a2
000057e6 c2fc 002a                mulu.w #$002a,d1
000057ea d5c1                     adda.l d1,a2
000057ec 48c6                     ext.l d6
000057ee e69e                     ror.l #$03,d6
000057f0 2006                     move.l d6,d0
000057f2 4840                     swap.w d0
000057f4 8c80                     or.l d0,d6
000057f6 2a7c 00df f000           movea.l #$00dff000,a5
000057fc 0086 0fca 0000           or.l #$0fca0000,d6
00005802 0839 0006 00df f002      btst.b #$0006,$00dff002
0000580a 66f6                     bne.b #$f6 == $00005802 (T)
0000580c 3b42 0064                move.w d2,(a5,$0064) == $00bfd164
00005810 3b42 0062                move.w d2,(a5,$0062) == $00bfd162
00005814 2b47 0044                move.l d7,(a5,$0044) == $00bfd144
00005818 3b44 0060                move.w d4,(a5,$0060) == $00bfd160
0000581c 3b44 0066                move.w d4,(a5,$0066) == $00bfd166
00005820 2b46 0040                move.l d6,(a5,$0040) == $00bfd140
00005824 47d0                     lea.l (a0),a3
00005826 7e03                     moveq #$03,d7
00005828 0839 0006 00df f002      btst.b #$0006,$00dff002
00005830 66f6                     bne.b #$f6 == $00005828 (T)
00005832 41f0 9800                lea.l (a0,a1.L,$00) == $0004095a,a0
00005836 2b4b 0050                move.l a3,(a5,$0050) == $00bfd150
0000583a 2b48 004c                move.l a0,(a5,$004c) == $00bfd14c
0000583e 2b4a 0048                move.l a2,(a5,$0048) == $00bfd148
00005842 2b4a 0054                move.l a2,(a5,$0054) == $00bfd154
00005846 3b43 0058                move.w d3,(a5,$0058) == $00bfd158
0000584a 45ea 1c8c                lea.l (a2,$1c8c) == $0006f474,a2
0000584e 51cf ffd8                dbf .w d7,#$ffd8 == $00005828 (F)
00005852 4e75                     rts  == $6000001a
00005854 3039 00df f00c           move.w $00dff00c,d0
0000585a 4202                     clr.b d2
0000585c 0800 0001                btst.l #$0001,d0
00005860 6704                     beq.b #$04 == $00005866 (F)
00005862 08c2 0000                bset.l #$0000,d2
00005866 0800 0009                btst.l #$0009,d0
0000586a 6704                     beq.b #$04 == $00005870 (F)
0000586c 08c2 0001                bset.l #$0001,d2
00005870 3200                     move.w d0,d1
00005872 e249                     lsr.w #$01,d1
00005874 b141                     eor.w d0,d1
00005876 0801 0000                btst.l #$0000,d1
0000587a 6704                     beq.b #$04 == $00005880 (F)
0000587c 08c2 0002                bset.l #$0002,d2
00005880 0801 0008                btst.l #$0008,d1
00005884 6704                     beq.b #$04 == $0000588a (F)
00005886 08c2 0003                bset.l #$0003,d2
0000588a 0839 0007 00bf e001      btst.b #$0007,$00bfe001
00005892 57c0                     seq.b d0 (F)
00005894 1238 6309                move.b $6309 [00],d1
00005898 6606                     bne.b #$06 == $000058a0 (T)
0000589a 0240 0010                and.w #$0010,d0
0000589e 8440                     or.w d0,d2
000058a0 11c0 6309                move.b d0,$6309 [00]
000058a4 11c2 6308                move.b d2,$6308 [00]
000058a8 4e75                     rts  == $6000001a
000058aa 4280                     clr.l d0
000058ac 3038 67bc                move.w $67bc [0000],d0
000058b0 e648                     lsr.w #$03,d0
000058b2 d040                     add.w d0,d0
000058b4 287c 0005 a36c           movea.l #$0005a36c,a4
000058ba d9c0                     adda.l d0,a4
000058bc 21cc 631e                move.l a4,$631e [0005a36c]
000058c0 4278 6312                clr.w $6312 [0000]
000058c4 4281                     clr.l d1
000058c6 3238 67bc                move.w $67bc [0000],d1
000058ca 7e14                     moveq #$14,d7
000058cc 48e7 4108                movem.l d1/d7/a4,-(a7)
000058d0 6100 f204                bsr.w #$f204 == $00004ad6
000058d4 4cdf 1082                movem.l (a7)+,d1/d7/a4
000058d8 5041                     addq.w #$08,d1
000058da 548c                     addaq.l #$02,a4
000058dc 51cf ffee                dbf .w d7,#$ffee == $000058cc (F)
000058e0 4e75                     rts  == $6000001a
000058e2 3e3c 013f                move.w #$013f,d7
000058e6 41f8 68a0                lea.l $68a0,a0
000058ea 1028 0004                move.b (a0,$0004) == $00000a04 [00],d0
000058ee c028 0001                and.b (a0,$0001) == $00000a01 [3c],d0
000058f2 4600                     not.b d0
000058f4 c028 0002                and.b (a0,$0002) == $00000a02 [00],d0
000058f8 c028 0003                and.b (a0,$0003) == $00000a03 [4a],d0
000058fc b128 0001                eor.b d0,(a0,$0001) == $00000a01 [3c]
00005900 5a48                     addaq.w #$05,a0
00005902 51cf ffe6                dbf .w d7,#$ffe6 == $000058ea (F)
00005906 41f9 0000 8002           lea.l $00008002,a0
0000590c 3a18                     move.w (a0)+ [003c],d5
0000590e 3c18                     move.w (a0)+ [003c],d6
00005910 41e8 0076                lea.l (a0,$0076) == $00000a76,a0
00005914 1028 0028                move.b (a0,$0028) == $00000a28 [00],d0
00005918 0c00 0017                cmp.b #$17,d0
0000591c 6424                     bcc.b #$24 == $00005942 (T)
0000591e 3006                     move.w d6,d0
00005920 5340                     subq.w #$01,d0
00005922 c0c5                     mulu.w d5,d0
00005924 43f0 0800                lea.l (a0,d0.L,$00) == $ffffe990,a1
00005928 e24e                     lsr.w #$01,d6
0000592a 5346                     subq.w #$01,d6
0000592c 3805                     move.w d5,d4
0000592e 5344                     subq.w #$01,d4
00005930 1010                     move.b (a0) [00],d0
00005932 10d1                     move.b (a1) [04],(a0)+ [00]
00005934 12c0                     move.b d0,(a1)+ [04]
00005936 51cc fff8                dbf .w d4,#$fff8 == $00005930 (F)
0000593a 92c5                     suba.w d5,a1
0000593c 92c5                     suba.w d5,a1
0000593e 51ce ffec                dbf .w d6,#$ffec == $0000592c (F)
00005942 2278 62fe                movea.l $62fe [00010000],a1
00005946 207c 0001 1002           movea.l #$00011002,a0
0000594c 45f9 0000 607c           lea.l $0000607c,a2
00005952 3e18                     move.w (a0)+ [003c],d7
00005954 4280                     clr.l d0
00005956 3007                     move.w d7,d0
00005958 5347                     subq.w #$01,d7
0000595a 3c07                     move.w d7,d6
0000595c e740                     asl.w #$03,d0
0000595e d088                     add.l a0,d0
00005960 2a40                     movea.l d0,a5
00005962 41e8 0002                lea.l (a0,$0002) == $00000a02,a0
00005966 32da                     move.w (a2)+ [1241],(a1)+ [0400]
00005968 1018                     move.b (a0)+ [00],d0
0000596a e808                     lsr.b #$04,d0
0000596c 5240                     addq.w #$01,d0
0000596e 12c0                     move.b d0,(a1)+ [04]
00005970 1018                     move.b (a0)+ [00],d0
00005972 5240                     addq.w #$01,d0
00005974 12c0                     move.b d0,(a1)+ [04]
00005976 2018                     move.l (a0)+ [003c004a],d0
00005978 d08d                     add.l a5,d0
0000597a 22c0                     move.l d0,(a1)+ [04004200]
0000597c 51cf ffe4                dbf .w d7,#$ffe4 == $00005962 (F)
00005980 3e06                     move.w d6,d7
00005982 2478 62fe                movea.l $62fe [00010000],a2
00005986 4282                     clr.l d2
00005988 544a                     addaq.w #$02,a2
0000598a 4240                     clr.w d0
0000598c 101a                     move.b (a2)+ [12],d0
0000598e 4241                     clr.w d1
00005990 121a                     move.b (a2)+ [12],d1
00005992 c0c1                     mulu.w d1,d0
00005994 d440                     add.w d0,d2
00005996 5c4a                     addaq.w #$06,a2
00005998 51cf fff0                dbf .w d7,#$fff0 == $0000598a (F)
0000599c c4fc 000a                mulu.w #$000a,d2
000059a0 21c2 6302                move.l d2,$6302 [00000000]
000059a4 2278 62fe                movea.l $62fe [00010000],a1
000059a8 2269 0004                movea.l (a1,$0004) == $0003ff5e [19002100],a1
000059ac 5249                     addaq.w #$01,a1
000059ae 0811 0000                btst.b #$0000,(a1) [04]
000059b2 6600 0004                bne.w #$0004 == $000059b8 (T)
000059b6 4e75                     rts  == $6000001a
000059b8 3e06                     move.w d6,d7
000059ba 2278 62fe                movea.l $62fe [00010000],a1
000059be 5449                     addaq.w #$02,a1
000059c0 2a48                     movea.l a0,a5
000059c2 2648                     movea.l a0,a3
000059c4 4285                     clr.l d5
000059c6 4280                     clr.l d0
000059c8 1019                     move.b (a1)+ [04],d0
000059ca 1a11                     move.b (a1) [04],d5
000059cc cac0                     mulu.w d0,d5
000059ce 2805                     move.l d5,d4
000059d0 d844                     add.w d4,d4
000059d2 2604                     move.l d4,d3
000059d4 d644                     add.w d4,d3
000059d6 2403                     move.l d3,d2
000059d8 d444                     add.w d4,d2
000059da 2202                     move.l d2,d1
000059dc d244                     add.w d4,d1
000059de 5345                     subq.w #$01,d5
000059e0 247c 0006 1b9c           movea.l #$00061b9c,a2
000059e6 3498                     move.w (a0)+ [003c],(a2) [1241]
000059e8 4652                     not.w (a2) [1241]
000059ea 3598 4000                move.w (a0)+ [003c],(a2,d4.W,$00) == $0006d8e9 [62ff]
000059ee 3598 3000                move.w (a0)+ [003c],(a2,d3.W,$00) == $0006dafb [b79f]
000059f2 3598 2000                move.w (a0)+ [003c],(a2,d2.W,$00) == $0006e1ef [a4e0]
000059f6 3598 1000                move.w (a0)+ [003c],(a2,d1.W,$00) == $0006d7e7 [f112]
000059fa 544a                     addaq.w #$02,a2
000059fc 51cd ffe8                dbf .w d5,#$ffe8 == $000059e6 (F)
00005a00 383c 0004                move.w #$0004,d4
00005a04 4245                     clr.w d5
00005a06 1a11                     move.b (a1) [04],d5
00005a08 5345                     subq.w #$01,d5
00005a0a 3400                     move.w d0,d2
00005a0c 5342                     subq.w #$01,d2
00005a0e 95c0                     suba.l d0,a2
00005a10 95c0                     suba.l d0,a2
00005a12 36da                     move.w (a2)+ [1241],(a3)+ [7185]
00005a14 51ca fffc                dbf .w d2,#$fffc == $00005a12 (F)
00005a18 95c0                     suba.l d0,a2
00005a1a 95c0                     suba.l d0,a2
00005a1c 51cd ffec                dbf .w d5,#$ffec == $00005a0a (F)
00005a20 d5c3                     adda.l d3,a2
00005a22 51cc ffe0                dbf .w d4,#$ffe0 == $00005a04 (F)
00005a26 43e9 0007                lea.l (a1,$0007) == $0003ff61,a1
00005a2a 51cf ff98                dbf .w d7,#$ff98 == $000059c4 (F)
00005a2e 284b                     movea.l a3,a4
00005a30 2278 62fe                movea.l $62fe [00010000],a1
00005a34 3e06                     move.w d6,d7
00005a36 7c04                     moveq #$04,d6
00005a38 2069 0004                movea.l (a1,$0004) == $0003ff5e [19002100],a0
00005a3c 4285                     clr.l d5
00005a3e 4284                     clr.l d4
00005a40 1829 0002                move.b (a1,$0002) == $0003ff5c [42],d4
00005a44 1a29 0003                move.b (a1,$0003) == $0003ff5d [00],d5
00005a48 5345                     subq.w #$01,d5
00005a4a 3604                     move.w d4,d3
00005a4c d643                     add.w d3,d3
00005a4e 5343                     subq.w #$01,d3
00005a50 1030 3000                move.b (a0,d3.W,$00) == $00000d13 [d6],d0
00005a54 7407                     moveq #$07,d2
00005a56 e210                     roxr.b #$01,d0
00005a58 e311                     roxl.b #$01,d1
00005a5a 51ca fffa                dbf .w d2,#$fffa == $00005a56 (F)
00005a5e 16c1                     move.b d1,(a3)+ [71]
00005a60 51cb ffee                dbf .w d3,#$ffee == $00005a50 (F)
00005a64 d1c4                     adda.l d4,a0
00005a66 d1c4                     adda.l d4,a0
00005a68 51cd ffe0                dbf .w d5,#$ffe0 == $00005a4a (F)
00005a6c 51ce ffce                dbf .w d6,#$ffce == $00005a3c (F)
00005a70 43e9 0008                lea.l (a1,$0008) == $0003ff62,a1
00005a74 51cf ffc0                dbf .w d7,#$ffc0 == $00005a36 (F)
00005a78 4e75                     rts  == $6000001a
00005a7a 0004 006b                or.b #$6b,d4
00005a7e 0012 0046                or.b #$46,(a2) [12]
00005a82 0015 0097                or.b #$97,(a5)
00005a86 0017 0064                or.b #$64,(a7) [60]
00005a8a 0018 0085                or.b #$85,(a0)+ [00]
00005a8e 001b 00bc                or.b #$bc,(a3)+ [71]
00005a92 001f 00c1                or.b #$c1,(a7)+ [60]
00005a96 00ff                     illegal
00005a98 0000 5290                or.b #$90,d0
00005a9c 45ce                     illegal
00005a9e 410a                     illegal
00005aa0 405e                     negx.w (a6)+
00005aa2 40b8 400c                negx.l $400c [342e0008]
00005aa6 40f0 4044                move.w sr,(a0,d4.W,$44) == $00000b45
00005aaa 5290                     addq.l #$01,(a0) [003c004a]
00005aac 5290                     addq.l #$01,(a0) [003c004a]
00005aae 5290                     addq.l #$01,(a0) [003c004a]
00005ab0 5290                     addq.l #$01,(a0) [003c004a]
00005ab2 43a0                     chk.w -(a0),d1
00005ab4 4380                     chk.w d0,d1
00005ab6 41a2                     chk.w -(a2),d0
00005ab8 426c 4430                clr.w (a4,$4430) == $00c02531 [0000]
00005abc 4444                     neg.w d4
00005abe 447e                     illegal
00005ac0 0000 5c6e                or.b #$6e,d0
00005ac4 5bea 5c02                smi.b (a2,$5c02) == $000733ea [d5] (F)
00005ac8 426c 5b5c                clr.w (a4,$5b5c) == $00c03c5d [f44e]
00005acc 5b06                     subq.b #$05,d6
00005ace 5eb8 5ecc                addq.l #$07,$5ecc [536e0008]
00005ad2 5f42                     subq.w #$07,d2
00005ad4 5fcc 6020                dble.w d4,#$6020 == $0000baf6 (F)
00005ad8 5d04                     subq.b #$06,d4
00005ada 5d3c                     illegal
00005adc 5db0 5ae4                subq.l #$06,(a0,d5.L[*2],$e4) == $02120e17 (68020+) [43003800]
00005ae0 5aee 5af8                spl.b (a6,$5af8) == $00e04af8 [4c] (T)
00005ae4 7001                     moveq #$01,d0
00005ae6 b078 62fc                cmp.w $62fc [0000],d0
00005aea 6516                     bcs.b #$16 == $00005b02 (F)
00005aec 6010                     bra.b #$10 == $00005afe (T)
00005aee 7002                     moveq #$02,d0
00005af0 b078 62fc                cmp.w $62fc [0000],d0
00005af4 650c                     bcs.b #$0c == $00005b02 (F)
00005af6 6006                     bra.b #$06 == $00005afe (T)
00005af8 7003                     moveq #$03,d0
00005afa b078 62fc                cmp.w $62fc [0000],d0
00005afe 31c0 62fc                move.w d0,$62fc [0000]
00005b02 4256                     clr.w (a6)
00005b04 4e75                     rts  == $6000001a
00005b06 303c 0590                move.w #$0590,d0
00005b0a 9078 67bc                sub.w $67bc [0000],d0
00005b0e 546e 000a                addq.w #$02,(a6,$000a) == $00dff00a
00005b12 2a6e 0008                movea.l (a6,$0008) == $00dff008,a5
00005b16 3415                     move.w (a5),d2
00005b18 6a00 eaa2                bpl.w #$eaa2 == $000045bc (T)
00005b1c 6100 dbdc                bsr.w #$dbdc == $000036fa
00005b20 7032                     moveq #$32,d0
00005b22 6100 0368                bsr.w #$0368 == $00005e8c
00005b26 6000 0312                bra.w #$0312 == $00005e3a (T)
00005b2a 0001 0001                or.b #$01,d1
00005b2e 0001 0001                or.b #$01,d1
00005b32 0002 0002                or.b #$02,d2
00005b36 0002 0002                or.b #$02,d2
00005b3a 0003 0003                or.b #$03,d3
00005b3e 0003 0003                or.b #$03,d3
00005b42 0004 0004                or.b #$04,d4
00005b46 0004 0004                or.b #$04,d4
00005b4a 0002 0002                or.b #$02,d2
00005b4e 0002 0002                or.b #$02,d2
00005b52 0001 0001                or.b #$01,d1
00005b56 0001 0001                or.b #$01,d1
00005b5a ffff                     illegal
00005b5c 3d7c 0098 0004           move.w #$0098,(a6,$0004) == $00dff004
00005b62 4bf8 39c8                lea.l $39c8,a5
00005b66 343c 0085                move.w #$0085,d2
00005b6a 7e09                     moveq #$09,d7
00005b6c b46d 0006                cmp.w (a5,$0006) == $00bfd106,d2
00005b70 670a                     beq.b #$0a == $00005b7c (F)
00005b72 4bed 0016                lea.l (a5,$0016) == $00bfd116,a5
00005b76 51cf fff4                dbf .w d7,#$fff4 == $00005b6c (F)
00005b7a 6004                     bra.b #$04 == $00005b80 (T)
00005b7c 3415                     move.w (a5),d2
00005b7e 660c                     bne.b #$0c == $00005b8c (T)
00005b80 08b9 0007 0000 670a      bclr.b #$0007,$0000670a [05]
00005b88 4256                     clr.w (a6)
00005b8a 4e75                     rts  == $6000001a
00005b8c 5342                     subq.w #$01,d2
00005b8e 66fa                     bne.b #$fa == $00005b8a (T)
00005b90 4eb9 0004 8008           jsr $00048008
00005b96 08f9 0000 0007 c874      bset.b #$0000,$0007c874 [00]
00005b9e 31fc 5290 3c92           move.w #$5290,$3c92 [4c3e]
00005ba4 4278 62fa                clr.w $62fa [0001]
00005ba8 4278 6318                clr.w $6318 [0000]
00005bac 302d 0004                move.w (a5,$0004) == $00bfd104,d0
00005bb0 0c40 00d4                cmp.w #$00d4,d0
00005bb4 651c                     bcs.b #$1c == $00005bd2 (F)
00005bb6 3b7c 0081 0006           move.w #$0081,(a5,$0006) == $00bfd106
00005bbc 2b7c 0000 5b28 0008      move.l #$00005b28,(a5,$0008) == $00bfd108
00005bc4 3abc 0019                move.w #$0019,(a5)
00005bc8 4256                     clr.w (a6)
00005bca 700b                     moveq #$0b,d0
00005bcc 4ef9 0004 8014           jmp $00048014
00005bd2 5378 67c8                subq.w #$01,$67c8 [0050]
00005bd6 0440 0018                sub.w #$0018,d0
00005bda 9078 67be                sub.w $67be [00f0],d0
00005bde 4440                     neg.w d0
00005be0 d078 67c4                add.w $67c4 [0048],d0
00005be4 31c0 67c6                move.w d0,$67c6 [0048]
00005be8 4e75                     rts  == $6000001a
00005bea 6134                     bsr.b #$34 == $00005c20
00005bec 0c42 0008                cmp.w #$0008,d2
00005bf0 64f6                     bcc.b #$f6 == $00005be8 (T)
00005bf2 0c42 0004                cmp.w #$0004,d2
00005bf6 6600 e9c4                bne.w #$e9c4 == $000045bc (T)
00005bfa 6152                     bsr.b #$52 == $00005c4e
00005bfc 7404                     moveq #$04,d2
00005bfe 6000 e9bc                bra.w #$e9bc == $000045bc (T)
00005c02 611c                     bsr.b #$1c == $00005c20
00005c04 0042 e000                or.w #$e000,d2
00005c08 0c42 e008                cmp.w #$e008,d2
00005c0c 64da                     bcc.b #$da == $00005be8 (T)
00005c0e 0c42 e004                cmp.w #$e004,d2
00005c12 6600 e9a8                bne.w #$e9a8 == $000045bc (T)
00005c16 612a                     bsr.b #$2a == $00005c42
00005c18 343c e004                move.w #$e004,d2
00005c1c 6000 e99e                bra.w #$e99e == $000045bc (T)
00005c20 4242                     clr.w d2
00005c22 342e 0008                move.w (a6,$0008) == $00dff008,d2
00005c26 5802                     addq.b #$04,d2
00005c28 6408                     bcc.b #$08 == $00005c32 (T)
00005c2a 7406                     moveq #$06,d2
00005c2c 6100 e888                bsr.w #$e888 == $000044b6
00005c30 4242                     clr.w d2
00005c32 3d42 0008                move.w d2,(a6,$0008) == $00dff008
00005c36 0c42 0037                cmp.w #$0037,d2
00005c3a 6404                     bcc.b #$04 == $00005c40 (T)
00005c3c e64a                     lsr.w #$03,d2
00005c3e 5242                     addq.w #$01,d2
00005c40 4e75                     rts  == $6000001a
00005c42 4cb8 0018 67c2           movem.w $67c2,d3-d4
00005c48 0643 0010                add.w #$0010,d3
00005c4c 6008                     bra.b #$08 == $00005c56 (T)
00005c4e 4cb8 0018 67c2           movem.w $67c2,d3-d4
00005c54 5843                     addq.w #$04,d3
00005c56 9640                     sub.w d0,d3
00005c58 0c43 0016                cmp.w #$0016,d3
00005c5c 64e2                     bcc.b #$e2 == $00005c40 (T)
00005c5e b841                     cmp.w d1,d4
00005c60 6bde                     bmi.b #$de == $00005c40 (F)
00005c62 b278 62f0                cmp.w $62f0 [0000],d1
00005c66 6bd8                     bmi.b #$d8 == $00005c40 (F)
00005c68 7c03                     moveq #$03,d6
00005c6a 6000 f060                bra.w #$f060 == $00004ccc (T)
00005c6e 362e 000c                move.w (a6,$000c) == $00dff00c,d3
00005c72 5c03                     addq.b #$06,d3
00005c74 3d43 000c                move.w d3,(a6,$000c) == $00dff00c
00005c78 0c03 0020                cmp.b #$20,d3
00005c7c 65c2                     bcs.b #$c2 == $00005c40 (F)
00005c7e 7401                     moveq #$01,d2
00005c80 0c03 0040                cmp.b #$40,d3
00005c84 6500 e936                bcs.w #$e936 == $000045bc (F)
00005c88 3a2e 000a                move.w (a6,$000a) == $00dff00a,d5
00005c8c 0c45 0010                cmp.w #$0010,d5
00005c90 6400 0004                bcc.w #$0004 == $00005c96 (T)
00005c94 5245                     addq.w #$01,d5
00005c96 3d45 000a                move.w d5,(a6,$000a) == $00dff00a
00005c9a e24d                     lsr.w #$01,d5
00005c9c da6e 0008                add.w (a6,$0008) == $00dff008,d5
00005ca0 3d45 0008                move.w d5,(a6,$0008) == $00dff008
00005ca4 d245                     add.w d5,d1
00005ca6 6100 f8f8                bsr.w #$f8f8 == $000055a0
00005caa 0c02 0079                cmp.b #$79,d2
00005cae 6528                     bcs.b #$28 == $00005cd8 (F)
00005cb0 3638 67be                move.w $67be [00f0],d3
00005cb4 d641                     add.w d1,d3
00005cb6 0243 0007                and.w #$0007,d3
00005cba 4643                     not.w d3
00005cbc d243                     add.w d3,d1
00005cbe 7404                     moveq #$04,d2
00005cc0 b56e 0002                eor.w d2,(a6,$0002) == $00dff002
00005cc4 42ae 0008                clr.l (a6,$0008) == $00dff008
00005cc8 426e 000c                clr.w (a6,$000c) == $00dff00c
00005ccc 7405                     moveq #$05,d2
00005cce 6100 e7e6                bsr.w #$e7e6 == $000044b6
00005cd2 7402                     moveq #$02,d2
00005cd4 6000 e8e6                bra.w #$e8e6 == $000045bc (T)
00005cd8 7401                     moveq #$01,d2
00005cda 3638 67c2                move.w $67c2 [0050],d3
00005cde 9640                     sub.w d0,d3
00005ce0 5643                     addq.w #$03,d3
00005ce2 0c43 0007                cmp.w #$0007,d3
00005ce6 6400 e8d4                bcc.w #$e8d4 == $000045bc (T)
00005cea b278 62f0                cmp.w $62f0 [0000],d1
00005cee 6b00 e8cc                bmi.w #$e8cc == $000045bc (F)
00005cf2 b278 67c4                cmp.w $67c4 [0048],d1
00005cf6 6a00 e8c4                bpl.w #$e8c4 == $000045bc (T)
00005cfa 7c02                     moveq #$02,d6
00005cfc 6100 efce                bsr.w #$efce == $00004ccc
00005d00 60bc                     bra.b #$bc == $00005cbe (T)
00005d02 4e75                     rts  == $6000001a
00005d04 342e 0004                move.w (a6,$0004) == $00dff004,d2
00005d08 4642                     not.w d2
00005d0a 0242 0007                and.w #$0007,d2
00005d0e 0882 0002                bclr.l #$0002,d2
00005d12 6604                     bne.b #$04 == $00005d18 (T)
00005d14 0642 e000                add.w #$e000,d2
00005d18 3f02                     move.w d2,-(a7) [09ec]
00005d1a 5442                     addq.w #$02,d2
00005d1c 6100 e89e                bsr.w #$e89e == $000045bc
00005d20 341f                     move.w (a7)+ [6000],d2
00005d22 0242 e000                and.w #$e000,d2
00005d26 5242                     addq.w #$01,d2
00005d28 6100 e860                bsr.w #$e860 == $0000458a
00005d2c 0838 0000 632d           btst.b #$0000,$632d [00]
00005d32 67ce                     beq.b #$ce == $00005d02 (F)
00005d34 536e 0004                subq.w #$01,(a6,$0004) == $00dff004
00005d38 6b48                     bmi.b #$48 == $00005d82 (F)
00005d3a 4e75                     rts  == $6000001a
00005d3c 0838 0000 632d           btst.b #$0000,$632d [00]
00005d42 6710                     beq.b #$10 == $00005d54 (F)
00005d44 48e7 c002                movem.l d0-d1/a6,-(a7)
00005d48 700b                     moveq #$0b,d0
00005d4a 4eb9 0004 8014           jsr $00048014
00005d50 4cdf 4003                movem.l (a7)+,d0-d1/a6
00005d54 3438 632c                move.w $632c [0000],d2
00005d58 e44a                     lsr.w #$02,d2
00005d5a 0242 0003                and.w #$0003,d2
00005d5e 5242                     addq.w #$01,d2
00005d60 6100 e85a                bsr.w #$e85a == $000045bc
00005d64 0441 0010                sub.w #$0010,d1
00005d68 6aea                     bpl.b #$ea == $00005d54 (T)
00005d6a 4bf8 39c8                lea.l $39c8,a5
00005d6e 343c 0103                move.w #$0103,d2
00005d72 7e09                     moveq #$09,d7
00005d74 b46d 0006                cmp.w (a5,$0006) == $00bfd106,d2
00005d78 670e                     beq.b #$0e == $00005d88 (F)
00005d7a 4bed 0016                lea.l (a5,$0016) == $00bfd116,a5
00005d7e 51cf fff4                dbf .w d7,#$fff4 == $00005d74 (F)
00005d82 7c5a                     moveq #$5a,d6
00005d84 6000 ef46                bra.w #$ef46 == $00004ccc (T)
00005d88 3415                     move.w (a5),d2
00005d8a 67f6                     beq.b #$f6 == $00005d82 (F)
00005d8c 5342                     subq.w #$01,d2
00005d8e 6600 ff72                bne.w #$ff72 == $00005d02 (T)
00005d92 31fc 5290 3c92           move.w #$5290,$3c92 [4c3e]
00005d98 3abc 0021                move.w #$0021,(a5)
00005d9c 4278 6318                clr.w $6318 [0000]
00005da0 31fc ffff 62fa           move.w #$ffff,$62fa [0001]
00005da6 13fc 0001 0007 c874      move.b #$01,$0007c874 [00]
00005dae 4e75                     rts  == $6000001a
00005db0 3438 67bc                move.w $67bc [0000],d2
00005db4 0c42 0540                cmp.w #$0540,d2
00005db8 6714                     beq.b #$14 == $00005dce (F)
00005dba 546e 0002                addq.w #$02,(a6,$0002) == $00dff002
00005dbe 7470                     moveq #$70,d2
00005dc0 9440                     sub.w d0,d2
00005dc2 0c42 fffd                cmp.w #$fffd,d2
00005dc6 6402                     bcc.b #$02 == $00005dca (T)
00005dc8 74fe                     moveq #$fe,d2
00005dca d578 67c8                add.w d2,$67c8 [0050]
00005dce 0c41 0048                cmp.w #$0048,d1
00005dd2 6452                     bcc.b #$52 == $00005e26 (T)
00005dd4 362e 000a                move.w (a6,$000a) == $00dff00a,d3
00005dd8 0c43 000e                cmp.w #$000e,d3
00005ddc 6a06                     bpl.b #$06 == $00005de4 (T)
00005dde 5243                     addq.w #$01,d3
00005de0 3d43 000a                move.w d3,(a6,$000a) == $00dff00a
00005de4 e243                     asr.w #$01,d3
00005de6 d76e 0004                add.w d3,(a6,$0004) == $00dff004
00005dea 7418                     moveq #$18,d2
00005dec 9441                     sub.w d1,d2
00005dee d578 67c6                add.w d2,$67c6 [0048]
00005df2 7406                     moveq #$06,d2
00005df4 0c43 0004                cmp.w #$0004,d3
00005df8 6b16                     bmi.b #$16 == $00005e10 (F)
00005dfa 7407                     moveq #$07,d2
00005dfc 0c42 0007                cmp.w #$0007,d2
00005e00 6b0e                     bmi.b #$0e == $00005e10 (F)
00005e02 740c                     moveq #$0c,d2
00005e04 c478 632c                and.w $632c [0000],d2
00005e08 e44a                     lsr.w #$02,d2
00005e0a 6602                     bne.b #$02 == $00005e0e (T)
00005e0c 7402                     moveq #$02,d2
00005e0e 5e42                     addq.w #$07,d2
00005e10 6100 e7aa                bsr.w #$e7aa == $000045bc
00005e14 4eb9 0004 8004           jsr $00048004
00005e1a 203c 0000 0210           move.l #$00000210,d0
00005e20 4ef9 0007 c82a           jmp $0007c82a
00005e26 7250                     moveq #$50,d1
00005e28 740b                     moveq #$0b,d2
00005e2a 6100 e790                bsr.w #$e790 == $000045bc
00005e2e 6100 d8ca                bsr.w #$d8ca == $000036fa
00005e32 08f9 0006 0007 c875      bset.b #$0006,$0007c875 [00]
00005e3a 4eb9 0004 8004           jsr $00048004
00005e40 7002                     moveq #$02,d0
00005e42 4eb9 0004 8010           jsr $00048010
00005e48 303c 00fa                move.w #$00fa,d0
00005e4c 613e                     bsr.b #$3e == $00005e8c
00005e4e 7064                     moveq #$64,d0
00005e50 6100 003a                bsr.w #$003a == $00005e8c
00005e54 6100 efd2                bsr.w #$efd2 == $00004e28
00005e58 41f8 3abd                lea.l $3abd,a0
00005e5c 6100 096c                bsr.w #$096c == $000067ca
00005e60 6100 de5e                bsr.w #$de5e == $00003cc0
00005e64 7064                     moveq #$64,d0
00005e66 6100 0024                bsr.w #$0024 == $00005e8c
00005e6a 6100 efbc                bsr.w #$efbc == $00004e28
00005e6e 41f8 3acd                lea.l $3acd,a0
00005e72 6100 0956                bsr.w #$0956 == $000067ca
00005e76 6100 de48                bsr.w #$de48 == $00003cc0
00005e7a 7064                     moveq #$64,d0
00005e7c 6100 000e                bsr.w #$000e == $00005e8c
00005e80 6100 de3a                bsr.w #$de3a == $00003cbc
00005e84 6100 df06                bsr.w #$df06 == $00003d8c
00005e88 6000 a99e                bra.w #$a99e == $00000828 (T)
00005e8c d078 36ee                add.w $36ee [0000],d0
00005e90 b078 36ee                cmp.w $36ee [0000],d0
00005e94 6afa                     bpl.b #$fa == $00005e90 (T)
00005e96 4e75                     rts  == $6000001a
00005e98 4cb8 000c 67c2           movem.w $67c2,d2-d3
00005e9e 9641                     sub.w d1,d3
00005ea0 0c43 0001                cmp.w #$0001,d3
00005ea4 6424                     bcc.b #$24 == $00005eca (T)
00005ea6 9440                     sub.w d0,d2
00005ea8 0c42 0020                cmp.w #$0020,d2
00005eac 641c                     bcc.b #$1c == $00005eca (T)
00005eae 1438 62ef                move.b $62ef [01],d2
00005eb2 0c02 0024                cmp.b #$24,d2
00005eb6 4e75                     rts  == $6000001a
00005eb8 61de                     bsr.b #$de == $00005e98
00005eba 640e                     bcc.b #$0e == $00005eca (T)
00005ebc 31fc 0018 67c6           move.w #$0018,$67c6 [0048]
00005ec2 5256                     addq.w #$01,(a6)
00005ec4 3d7c 0020 0008           move.w #$0020,(a6,$0008) == $00dff008
00005eca 4e75                     rts  == $6000001a
00005ecc 536e 0008                subq.w #$01,(a6,$0008) == $00dff008
00005ed0 6726                     beq.b #$26 == $00005ef8 (F)
00005ed2 7427                     moveq #$27,d2
00005ed4 946e 0008                sub.w (a6,$0008) == $00dff008,d2
00005ed8 e64a                     lsr.w #$03,d2
00005eda 3f02                     move.w d2,-(a7) [09ec]
00005edc 6100 e6de                bsr.w #$e6de == $000045bc
00005ee0 5040                     addq.w #$08,d0
00005ee2 3417                     move.w (a7) [6000],d2
00005ee4 6100 e6d6                bsr.w #$e6d6 == $000045bc
00005ee8 5040                     addq.w #$08,d0
00005eea 3417                     move.w (a7) [6000],d2
00005eec 6100 e6ce                bsr.w #$e6ce == $000045bc
00005ef0 5040                     addq.w #$08,d0
00005ef2 341f                     move.w (a7)+ [6000],d2
00005ef4 6000 e6c6                bra.w #$e6c6 == $000045bc (T)
00005ef8 4256                     clr.w (a6)
00005efa 6100 f6a4                bsr.w #$f6a4 == $000055a0
00005efe e14a                     lsl.w #$08,d2
00005f00 1430 3001                move.b (a0,d3.W,$01) == $00000d14 [00],d2
00005f04 1830 3002                move.b (a0,d3.W,$02) == $00000d15 [00],d4
00005f08 e14c                     lsl.w #$08,d4
00005f0a 1830 3003                move.b (a0,d3.W,$03) == $00000d16 [1a],d4
00005f0e 2a78 5f64                movea.l $5f64 [00005fc4],a5
00005f12 48a5 3800                movem.w d2-d4,-(a5)
00005f16 21cd 5f64                move.l a5,$5f64 [00005fc4]
00005f1a 11bc 004f 3000           move.b #$4f,(a0,d3.W,$00) == $00000d13 [d6]
00005f20 11bc 004f 3001           move.b #$4f,(a0,d3.W,$01) == $00000d14 [00]
00005f26 11bc 004f 3002           move.b #$4f,(a0,d3.W,$02) == $00000d15 [00]
00005f2c 11bc 004f 3003           move.b #$4f,(a0,d3.W,$03) == $00000d16 [1a]
00005f32 6100 ff64                bsr.w #$ff64 == $00005e98
00005f36 640a                     bcc.b #$0a == $00005f42 (T)
00005f38 31fc 53d6 3c92           move.w #$53d6,$3c92 [4c3e]
00005f3e 4278 6318                clr.w $6318 [0000]
00005f42 7405                     moveq #$05,d2
00005f44 6100 e676                bsr.w #$e676 == $000045bc
00005f48 7405                     moveq #$05,d2
00005f4a 5040                     addq.w #$08,d0
00005f4c 6100 e66e                bsr.w #$e66e == $000045bc
00005f50 7405                     moveq #$05,d2
00005f52 5040                     addq.w #$08,d0
00005f54 6100 e666                bsr.w #$e666 == $000045bc
00005f58 7405                     moveq #$05,d2
00005f5a 5040                     addq.w #$08,d0
00005f5c 6100 e65e                bsr.w #$e65e == $000045bc
00005f60 6000 f948                bra.w #$f948 == $000058aa (T)
00005f64 0000 5fc4                or.b #$c4,d0
00005f68 0000 0000                or.b #$00,d0
00005f6c 0000 0000                or.b #$00,d0
00005f70 0000 0000                or.b #$00,d0
00005f74 0000 0000                or.b #$00,d0
00005f78 0000 0000                or.b #$00,d0
00005f7c 0000 0000                or.b #$00,d0
00005f80 0000 0000                or.b #$00,d0
00005f84 0000 0000                or.b #$00,d0
00005f88 0000 0000                or.b #$00,d0
00005f8c 0000 0000                or.b #$00,d0
00005f90 0000 0000                or.b #$00,d0
00005f94 0000 0000                or.b #$00,d0
00005f98 0000 0000                or.b #$00,d0
00005f9c 0000 0000                or.b #$00,d0
00005fa0 0000 0000                or.b #$00,d0
00005fa4 0000 0000                or.b #$00,d0
00005fa8 0000 0000                or.b #$00,d0
00005fac 0000 0000                or.b #$00,d0
00005fb0 0000 0000                or.b #$00,d0
00005fb4 0000 0000                or.b #$00,d0
00005fb8 0000 0000                or.b #$00,d0
00005fbc 0000 0000                or.b #$00,d0
00005fc0 0000 0000                or.b #$00,d0
00005fc4 0000 0000                or.b #$00,d0
00005fc8 0000 0000                or.b #$00,d0
00005fcc 0c40 00c0                cmp.w #$00c0,d0
00005fd0 6a40                     bpl.b #$40 == $00006012 (T)
00005fd2 0244 0007                and.w #$0007,d4
00005fd6 660e                     bne.b #$0e == $00005fe6 (T)
00005fd8 5040                     addq.w #$08,d0
00005fda 6100 f5c4                bsr.w #$f5c4 == $000055a0
00005fde 5140                     subq.w #$08,d0
00005fe0 0c02 0079                cmp.b #$79,d2
00005fe4 652c                     bcs.b #$2c == $00006012 (F)
00005fe6 526e 0002                addq.w #$01,(a6,$0002) == $00dff002
00005fea 536e 0008                subq.w #$01,(a6,$0008) == $00dff008
00005fee 6a26                     bpl.b #$26 == $00006016 (T)
00005ff0 4cb8 000c 67c2           movem.w $67c2,d2-d3
00005ff6 9440                     sub.w d0,d2
00005ff8 0c42 0008                cmp.w #$0008,d2
00005ffc 6418                     bcc.b #$18 == $00006016 (T)
00005ffe 9641                     sub.w d1,d3
00006000 0c43 0013                cmp.w #$0013,d3
00006004 6410                     bcc.b #$10 == $00006016 (T)
00006006 3d7c 0019 0008           move.w #$0019,(a6,$0008) == $00dff008
0000600c 7c02                     moveq #$02,d6
0000600e 6100 ecbc                bsr.w #$ecbc == $00004ccc
00006012 3cbc 001e                move.w #$001e,(a6)
00006016 3404                     move.w d4,d2
00006018 e24a                     lsr.w #$01,d2
0000601a 5242                     addq.w #$01,d2
0000601c 6000 e59e                bra.w #$e59e == $000045bc (T)
00006020 0c40 ffc0                cmp.w #$ffc0,d0
00006024 6b44                     bmi.b #$44 == $0000606a (F)
00006026 0244 0007                and.w #$0007,d4
0000602a 6612                     bne.b #$12 == $0000603e (T)
0000602c 0440 0010                sub.w #$0010,d0
00006030 6100 f56e                bsr.w #$f56e == $000055a0
00006034 0640 0010                add.w #$0010,d0
00006038 0c02 0079                cmp.b #$79,d2
0000603c 652c                     bcs.b #$2c == $0000606a (F)
0000603e 536e 0002                subq.w #$01,(a6,$0002) == $00dff002
00006042 536e 0008                subq.w #$01,(a6,$0008) == $00dff008
00006046 6a26                     bpl.b #$26 == $0000606e (T)
00006048 4cb8 000c 67c2           movem.w $67c2,d2-d3
0000604e 9440                     sub.w d0,d2
00006050 0642 000a                add.w #$000a,d2
00006054 6418                     bcc.b #$18 == $0000606e (T)
00006056 9641                     sub.w d1,d3
00006058 0c43 0013                cmp.w #$0013,d3
0000605c 6410                     bcc.b #$10 == $0000606e (T)
0000605e 3d7c 0019 0008           move.w #$0019,(a6,$0008) == $00dff008
00006064 7c02                     moveq #$02,d6
00006066 6100 ec64                bsr.w #$ec64 == $00004ccc
0000606a 3cbc 001d                move.w #$001d,(a6)
0000606e 343c e003                move.w #$e003,d2
00006072 e24c                     lsr.w #$01,d4
00006074 b942                     eor.w d4,d2
00006076 5242                     addq.w #$01,d2
00006078 6000 e542                bra.w #$e542 == $000045bc (T)
0000607c 2a02                     move.l d2,d5
0000607e 2005                     move.l d5,d0
00006080 2005                     move.l d5,d0
00006082 2004                     move.l d4,d0
00006084 1505                     move.b d5,-(a2) [f1]
00006086 1506                     move.b d6,-(a2) [f1]
00006088 1506                     move.b d6,-(a2) [f1]
0000608a 1507                     move.b d7,-(a2) [f1]
0000608c 1507                     move.b d7,-(a2) [f1]
0000608e 1506                     move.b d6,-(a2) [f1]
00006090 1507                     move.b d7,-(a2) [f1]
00006092 1507                     move.b d7,-(a2) [f1]
00006094 2c10                     move.l (a0) [003c004a],d6
00006096 2c08                     move.l a0,d6
00006098 1402                     move.b d2,d2
0000609a 210d                     move.l a5,-(a0) [4ef83000]
0000609c 2b05                     move.l d5,-(a5)
0000609e 1905                     move.b d5,-(a4)
000060a0 2504                     move.l d4,-(a2) [0ca693f1]
000060a2 1706                     move.b d6,-(a3) [18]
000060a4 1702                     move.b d2,-(a3) [18]
000060a6 2005                     move.l d5,d0
000060a8 0f06                     btst.l d7,d6
000060aa 0006 2405                or.b #$05,d6
000060ae 1507                     move.b d7,-(a2) [f1]
000060b0 1c05                     move.b d5,d6
000060b2 1007                     move.b d7,d0
000060b4 1207                     move.b d7,d1
000060b6 1b03                     move.b d3,-(a5)
000060b8 1308                     illegal
000060ba 2c07                     move.l d7,d6
000060bc 2c07                     move.l d7,d6
000060be 2c07                     move.l d7,d6
000060c0 2c07                     move.l d7,d6
000060c2 2904                     move.l d4,-(a4)
000060c4 1a06                     move.b d6,d5
000060c6 03fe                     illegal
000060c8 2902                     move.l d2,-(a4)
000060ca 2008                     move.l a0,d0
000060cc 1306                     move.b d6,-(a1) [00]
000060ce 2a08                     move.l a0,d5
000060d0 2007                     move.l d7,d0
000060d2 2a04                     move.l d4,d5
000060d4 2a02                     move.l d2,d5
000060d6 24fa 1405                move.l (pc,$1405) == $000074dd [24552aa9],(a2)+ [124197f7]
000060da 2a03                     move.l d3,d5
000060dc 2a08                     move.l a0,d5
000060de 0f05                     btst.l d7,d5
000060e0 0f05                     btst.l d7,d5
000060e2 0f05                     btst.l d7,d5
000060e4 0f05                     btst.l d7,d5
000060e6 2a07                     move.l d7,d5
000060e8 1507                     move.b d7,-(a2) [f1]
000060ea 1508                     illegal
000060ec 1507                     move.b d7,-(a2) [f1]
000060ee 1508                     illegal
000060f0 0200 0201                and.b #$01,d0
000060f4 0202 0000                and.b #$00,d2
000060f8 0100                     btst.l d0,d0
000060fa 0100                     btst.l d0,d0
000060fc 0101                     btst.l d0,d1
000060fe 0604 0b07                add.b #$07,d4
00006102 0f07                     btst.l d7,d7
00006104 0c07 0b06                cmp.b #$06,d7
00006108 2005                     move.l d5,d0
0000610a 1208                     illegal
0000610c 1200                     move.b d0,d1
0000610e 2903                     move.l d3,-(a4)
00006110 2206                     move.l d6,d1
00006112 2205                     move.l d5,d1
00006114 2204                     move.l d4,d1
00006116 1506                     move.b d6,-(a2) [f1]
00006118 1507                     move.b d7,-(a2) [f1]
0000611a 1508                     illegal
0000611c 1504                     move.b d4,-(a2) [f1]
0000611e 1504                     move.b d4,-(a2) [f1]
00006120 1506                     move.b d6,-(a2) [f1]
00006122 1507                     move.b d7,-(a2) [f1]
00006124 1504                     move.b d4,-(a2) [f1]
00006126 2904                     move.l d4,-(a4)
00006128 25fd                     illegal
0000612a 1305                     move.b d5,-(a1) [00]
0000612c 2904                     move.l d4,-(a4)
0000612e 2cfd                     illegal
00006130 2904                     move.l d4,-(a4)
00006132 1bfd                     illegal
00006134 2004                     move.l d4,d0
00006136 1cfd                     illegal
00006138 0c07 2805                cmp.b #$05,d7
0000613c 1503                     move.b d3,-(a2) [f1]
0000613e 1503                     move.b d3,-(a2) [f1]
00006140 1503                     move.b d3,-(a2) [f1]
00006142 1503                     move.b d3,-(a2) [f1]
00006144 0301                     btst.l d1,d1
00006146 0301                     btst.l d1,d1
00006148 0601 0401                add.b #$01,d1
0000614c 0400 04fd                sub.b #$fd,d0
00006150 04fa 1d05 1108           [ chk2.l (pc,$1108) == $0000725c,d1 ]
00006152 1d05                     move.b d5,-(a6)
00006154 1108                     illegal
00006156 0809                     illegal
00006158 2903                     move.l d3,-(a4)
0000615a 2006                     move.l d6,d0
0000615c 2005                     move.l d5,d0
0000615e 2004                     move.l d4,d0
00006160 1506                     move.b d6,-(a2) [f1]
00006162 1507                     move.b d7,-(a2) [f1]
00006164 1508                     illegal
00006166 1504                     move.b d4,-(a2) [f1]
00006168 1504                     move.b d4,-(a2) [f1]
0000616a 1506                     move.b d6,-(a2) [f1]
0000616c 1507                     move.b d7,-(a2) [f1]
0000616e 1504                     move.b d4,-(a2) [f1]
00006170 2906                     move.l d6,-(a4)
00006172 1306                     move.b d6,-(a1) [00]
00006174 2a07                     move.l d7,d5
00006176 2904                     move.l d4,-(a4)
00006178 2efc 2904 25fb           move.l #$290425fb,(a7)+ [6000001a]
0000617e 0c0f                     illegal
00006180 2211                     move.l (a1) [04004200],d1
00006182 3416                     move.w (a6),d2
00006184 2c16                     move.l (a6),d6
00006186 2009                     move.l a1,d0
00006188 1208                     illegal
0000618a 0b08 2903                movep.w (a0,$2903) == $00003303,d5
0000618e 2005                     move.l d5,d0
00006190 2004                     move.l d4,d0
00006192 2004                     move.l d4,d0
00006194 1505                     move.b d5,-(a2) [f1]
00006196 1506                     move.b d6,-(a2) [f1]
00006198 1507                     move.b d7,-(a2) [f1]
0000619a 1503                     move.b d3,-(a2) [f1]
0000619c 1504                     move.b d4,-(a2) [f1]
0000619e 1505                     move.b d5,-(a2) [f1]
000061a0 1506                     move.b d6,-(a2) [f1]
000061a2 1503                     move.b d3,-(a2) [f1]
000061a4 2903                     move.l d3,-(a4)
000061a6 25fc                     illegal
000061a8 1405                     move.b d5,d2
000061aa 0800 0303                btst.l #$0303,d0
000061ae 2904                     move.l d4,-(a4)
000061b0 1bfd                     illegal
000061b2 2004                     move.l d4,d0
000061b4 1cfd                     illegal
000061b6 0c07 2004                cmp.b #$04,d7
000061ba 1207                     move.b d7,d1
000061bc 0b07                     btst.l d5,d7
000061be 2904                     move.l d4,-(a4)
000061c0 2006                     move.l d6,d0
000061c2 2005                     move.l d5,d0
000061c4 2004                     move.l d4,d0
000061c6 1506                     move.b d6,-(a2) [f1]
000061c8 1507                     move.b d7,-(a2) [f1]
000061ca 1508                     illegal
000061cc 1504                     move.b d4,-(a2) [f1]
000061ce 1504                     move.b d4,-(a2) [f1]
000061d0 1506                     move.b d6,-(a2) [f1]
000061d2 1507                     move.b d7,-(a2) [f1]
000061d4 1504                     move.b d4,-(a2) [f1]
000061d6 2904                     move.l d4,-(a4)
000061d8 25fd                     illegal
000061da 1405                     move.b d5,d2
000061dc 2b04                     move.l d4,-(a5)
000061de 2ffd                     illegal
000061e0 2904                     move.l d4,-(a4)
000061e2 18fc 2004                move.b #$04,(a4)+
000061e6 1cfd                     illegal
000061e8 0c07 2806                cmp.b #$06,d7
000061ec 1803                     move.b d3,d4
000061ee 1803                     move.b d3,d4
000061f0 1803                     move.b d3,d4
000061f2 1803                     move.b d3,d4
000061f4 0000 0000                or.b #$00,d0
000061f8 0000 0000                or.b #$00,d0
000061fc 0000 0908                or.b #$08,d0
00006200 0908 0908                movep.w (a0,$0908) == $00001308,d4
00006204 0808                     illegal
00006206 1d05                     move.b d5,-(a6)
00006208 1308                     illegal
0000620a 0809                     illegal
0000620c 2904                     move.l d4,-(a4)
0000620e 2006                     move.l d6,d0
00006210 2005                     move.l d5,d0
00006212 2004                     move.l d4,d0
00006214 1506                     move.b d6,-(a2) [f1]
00006216 1507                     move.b d7,-(a2) [f1]
00006218 1508                     illegal
0000621a 1504                     move.b d4,-(a2) [f1]
0000621c 1504                     move.b d4,-(a2) [f1]
0000621e 1506                     move.b d6,-(a2) [f1]
00006220 1507                     move.b d7,-(a2) [f1]
00006222 1503                     move.b d3,-(a2) [f1]
00006224 2904                     move.l d4,-(a4)
00006226 25fd                     illegal
00006228 1505                     move.b d5,-(a2) [f1]
0000622a 2b04                     move.l d4,-(a5)
0000622c 2ffe                     illegal
0000622e 2904                     move.l d4,-(a4)
00006230 19fd                     illegal
00006232 2202                     move.l d2,d1
00006234 1efc 1005                move.b #$05,(a7)+ [60]
00006238 2805                     move.l d5,d4
0000623a 1504                     move.b d4,-(a2) [f1]
0000623c 1504                     move.b d4,-(a2) [f1]
0000623e 1504                     move.b d4,-(a2) [f1]
00006240 1504                     move.b d4,-(a2) [f1]
00006242 2906                     move.l d6,-(a4)
00006244 1503                     move.b d3,-(a2) [f1]
00006246 1503                     move.b d3,-(a2) [f1]
00006248 1503                     move.b d3,-(a2) [f1]
0000624a 1503                     move.b d3,-(a2) [f1]
0000624c 1505                     move.b d5,-(a2) [f1]
0000624e 0a08                     illegal
00006250 0009                     illegal
00006252 2903                     move.l d3,-(a4)
00006254 2005                     move.l d5,d0
00006256 2004                     move.l d4,d0
00006258 2004                     move.l d4,d0
0000625a 1405                     move.b d5,d2
0000625c 1406                     move.b d6,d2
0000625e 1407                     move.b d7,d2
00006260 1404                     move.b d4,d2
00006262 1404                     move.b d4,d2
00006264 1405                     move.b d5,d2
00006266 1406                     move.b d6,d2
00006268 1402                     move.b d2,d2
0000626a 2906                     move.l d6,-(a4)
0000626c 1506                     move.b d6,-(a2) [f1]
0000626e 2906                     move.l d6,-(a4)
00006270 2a07                     move.l d7,d5
00006272 2903                     move.l d3,-(a4)
00006274 2efc 2903 24fc           move.l #$290324fc,(a7)+ [6000001a]
0000627a 2004                     move.l d4,d0
0000627c 2004                     move.l d4,d0
0000627e 2004                     move.l d4,d0
00006280 2004                     move.l d4,d0
00006282 2706                     move.l d6,-(a3) [43338718]
00006284 1304                     move.b d4,-(a1) [00]
00006286 1304                     move.b d4,-(a1) [00]
00006288 1304                     move.b d4,-(a1) [00]
0000628a 1303                     move.b d3,-(a1) [00]
0000628c 190b                     illegal
0000628e 0f09 120d                movep.w (a1,$120d) == $00041167,d7
00006292 130d                     illegal
00006294 1309                     illegal
00006296 0b0f 1d05                movep.w (a7,$1d05) == $00002521,d5
0000629a 1208                     illegal
0000629c 0808                     illegal
0000629e 2903                     move.l d3,-(a4)
000062a0 2005                     move.l d5,d0
000062a2 2004                     move.l d4,d0
000062a4 2004                     move.l d4,d0
000062a6 1405                     move.b d5,d2
000062a8 1406                     move.b d6,d2
000062aa 1407                     move.b d7,d2
000062ac 1404                     move.b d4,d2
000062ae 1404                     move.b d4,d2
000062b0 1405                     move.b d5,d2
000062b2 1406                     move.b d6,d2
000062b4 1402                     move.b d2,d2
000062b6 2903                     move.l d3,-(a4)
000062b8 25fd                     illegal
000062ba 1306                     move.b d6,-(a1) [00]
000062bc 2b04                     move.l d4,-(a5)
000062be 2ffd                     illegal
000062c0 2903                     move.l d3,-(a4)
000062c2 18fc 2202                move.b #$02,(a4)+
000062c6 1efc 1005                move.b #$05,(a7)+ [60]
000062ca 2805                     move.l d5,d4
000062cc 1504                     move.b d4,-(a2) [f1]
000062ce 1504                     move.b d4,-(a2) [f1]
000062d0 1504                     move.b d4,-(a2) [f1]
000062d2 1504                     move.b d4,-(a2) [f1]
000062d4 2906                     move.l d6,-(a4)
000062d6 1503                     move.b d3,-(a2) [f1]
000062d8 1503                     move.b d3,-(a2) [f1]
000062da 1503                     move.b d3,-(a2) [f1]
000062dc 1503                     move.b d3,-(a2) [f1]
000062de 0001 0002                or.b #$02,d1
000062e2 0003 0004                or.b #$04,d3
000062e6 0005 0007                or.b #$07,d5
000062ea 0005 0002                or.b #$02,d5
000062ee 0001 0000                or.b #$00,d1
000062f2 0000 0000                or.b #$00,d0
000062f6 0000 0000                or.b #$00,d0
000062fa 0001 0000                or.b #$00,d1
000062fe 0001 0000                or.b #$00,d1
00006302 0000 0000                or.b #$00,d0
00006306 0000 0000                or.b #$00,d0
0000630a 0000 a07c                or.b #$7c,d0
0000630e 0000 0000                or.b #$00,d0
00006312 0000 0000                or.b #$00,d0
00006316 0000 0000                or.b #$00,d0
0000631a 0000 0034                or.b #$34,d0
0000631e 0005 a36c                or.b #$6c,d5
00006322 0000 3dfe                or.b #$fe,d0
00006326 0000 0000                or.b #$00,d0
0000632a 0000 0000                or.b #$00,d0
0000632e 2221                     move.l -(a1) [00000000],d1
00006330 201f                     move.l (a7)+ [6000001a],d0
00006332 1e1d                     move.b (a5)+,d7
00006334 1c1b                     move.b (a3)+ [71],d6
00006336 1a19                     move.b (a1)+ [04],d5
00006338 1817                     move.b (a7) [60],d4
0000633a 1615                     move.b (a5),d3
0000633c 1413                     move.b (a3) [71],d2
0000633e 1211                     move.b (a1) [04],d1
00006340 100f                     illegal
00006342 0e0d                     illegal
00006344 0c0b                     illegal
00006346 0a09                     illegal
00006348 0807 0605                btst.l #$0605,d7
0000634c 0403 0201                sub.b #$01,d3
00006350 0003 0609                or.b #$09,d3
00006354 0d10                     btst.b d6,(a0) [00]
00006356 1316                     move.b (a6),-(a1) [00]
00006358 191c                     move.b (a4)+,-(a4)
0000635a 1f22                     move.b -(a2) [f1],-(a7) [ec]
0000635c 2529 2c2f                move.l (a1,$2c2f) == $00042b89 [000005ef],-(a2) [0ca693f1]
00006360 3235 383b                move.w (a5,d3.L,$3b) == $04d3d44e,d1
00006364 3e41                     movea.w d1,a7
00006366 4447                     neg.w d7
00006368 4a4d                     [ tst.w a5 ]
0000636a 5053                     addq.w #$08,(a3) [7185]
0000636c 5659                     addq.w #$03,(a1)+ [0400]
0000636e 5c5f                     addq.w #$06,(a7)+ [6000]
00006370 6264                     bhi.b #$64 == $000063d6 (T)
00006372 676a                     beq.b #$6a == $000063de (F)
00006374 6d70                     blt.b #$70 == $000063e6 (F)
00006376 7375                     illegal
00006378 787b                     moveq #$7b,d4
0000637a 7e80                     moveq #$80,d7
0000637c 8386 888b                [ unpk d6,d1,#$888b ]
0000637e 888b                     illegal
00006380 8e90                     or.l (a0) [003c004a],d7
00006382 9395                     sub.l d1,(a5)
00006384 989a                     sub.l (a2)+ [124197f7],d4
00006386 9d9f                     sub.l d6,(a7)+ [6000001a]
00006388 a2a4                     illegal
0000638a a7a9                     illegal
0000638c abae                     illegal
0000638e b0b2 b4b7                cmp.l (a2,a3.W[*4],$b7) == $00071348 (68020+) [b61c8d72],d0
00006392 b9bb                     illegal
00006394 bdbf                     illegal
00006396 c1c3                     muls.w d3,d0
00006398 c5c7                     muls.w d7,d2
0000639a c9cb                     illegal
0000639c cdcf                     illegal
0000639e d0d2                     adda.w (a2) [1241],a0
000063a0 d4d6                     adda.w (a6),a2
000063a2 d7d9                     adda.l (a1)+ [04004200],a3
000063a4 dbdc                     adda.l (a4)+,a5
000063a6 dedf                     adda.w (a7)+ [6000],a7
000063a8 e1e2                     asl.w -(a2) [93f1]
000063aa e4e5                     roxr.w -(a5)
000063ac e7e8 e9ea                rol.w (a0,-$1616) == $fffff3ea [6700]
000063b0 eced eeef f0f1           [ bfclr (a5,-$0f0f) == $00bfc1f1 {d3:d7} ]
000063b2 eeef f0f1 f2f3           [ bfset (a7,-$0d0d) == $fffffb0f {3:d1} ]
000063b4 f0f1                     illegal
000063b6 f2f3 f4f5 f6f7           [ fbge #$33,#$f4f5f6f7 ]
000063b8 f4f5                     [ cpushp bc,(a5) ]
000063ba f6f7                     illegal
000063bc f7f8                     illegal
000063be f9f9                     illegal
000063c0 fafb                     illegal
000063c2 fbfc                     illegal
000063c4 fcfd                     illegal
000063c6 fdfd                     illegal
000063c8 fefe                     illegal
000063ca feff                     illegal
000063cc ffff                     illegal
000063ce ffff                     illegal
000063d0 30d2                     move.w (a2) [1241],(a0)+ [003c]
000063d2 0401 0207                sub.b #$07,d1
000063d6 1901                     move.b d1,-(a4)
000063d8 e61e                     ror.b #$03,d6
000063da 01e1                     bset.b d0,-(a1) [00]
000063dc 1901                     move.b d1,-(a4)
000063de e619                     ror.b #$03,d1
000063e0 01e6                     bset.b d0,-(a6)
000063e2 1901                     move.b d1,-(a4)
000063e4 e61b                     ror.b #$03,d3
000063e6 01e4                     bset.b d0,-(a4)
000063e8 1b01                     move.b d1,-(a5)
000063ea e41b                     ror.b #$02,d3
000063ec 01e4                     bset.b d0,-(a4)
000063ee 1b01                     move.b d1,-(a5)
000063f0 e41b                     ror.b #$02,d3
000063f2 01e4                     bset.b d0,-(a4)
000063f4 1b01                     move.b d1,-(a5)
000063f6 e41b                     ror.b #$02,d3
000063f8 01e4                     bset.b d0,-(a4)
000063fa 1b01                     move.b d1,-(a5)
000063fc e41d                     ror.b #$02,d5
000063fe e300                     asl.b #$01,d0
00006400 1de3                     illegal
00006402 001d e300                or.b #$00,(a5)+
00006406 1de3                     illegal
00006408 001d e300                or.b #$00,(a5)+
0000640c 1de3                     illegal
0000640e 001d e300                or.b #$00,(a5)+
00006412 1de3                     illegal
00006414 0000 2401                or.b #$01,d0
00006418 0127                     btst.b d0,-(a7) [ec]
0000641a 0101                     btst.l d0,d1
0000641c 2a01                     move.l d1,d5
0000641e fe2c                     illegal
00006420 fdd7                     illegal
00006422 2d01                     move.l d1,-(a6)
00006424 0100                     btst.l d0,d0
00006426 1301                     move.b d1,-(a1) [00]
00006428 0116                     btst.b d0,(a6)
0000642a 0101                     btst.l d0,d1
0000642c 001b 02c1                or.b #$c1,(a3)+ [71]
00006430 0081 0001 0022           or.l #$00010022,d1
00006436 0240 00c0                and.w #$00c0,d0
0000643a 0040 00f0                or.w #$00f0,d0
0000643e 0002 0003                or.b #$03,d2
00006442 00c0                     illegal
00006444 0118                     btst.b d0,(a0)+ [00]
00006446 000f                     illegal
00006448 00a0 0118 0040           or.l #$01180040,-(a0) [4ef83000]
0000644e 00e2                     illegal
00006450 0001 0002                or.b #$02,d1
00006454 0008                     illegal
00006456 00d8                     illegal
00006458 00a8 00f0 0003 000e      or.l #$00f00003,(a0,$000e) == $00000a0e [7ea20047]
00006460 0010 0118                or.b #$18,(a0) [00]
00006464 000f                     illegal
00006466 00c8                     illegal
00006468 0118                     btst.b d0,(a0)+ [00]
0000646a 000f                     illegal
0000646c 00c8                     illegal
0000646e 0138 00e0                btst.b d0,$00e0 [00]
00006472 00f0 0001 000f           [ cmp2.b (a0,d0.W,$0f) == $ffffe99f,d0 ]
00006474 0001 000f                or.b #$0f,d1
00006478 00f0 00d8 00e0           [ cmp2.b (a0,d0.W,$e0) == $ffffe970,d0 ]
0000647a 00d8                     illegal
0000647c 00e0                     illegal
0000647e 00a7 0001 0003           or.l #$00010003,-(a7) [000009ec]
00006484 0080 0098 0038           or.l #$00980038,d0
0000648a 0078 0001 000e           or.w #$0001,$000e [2070]
00006490 0008                     illegal
00006492 0098 0024 0078           or.l #$00240078,(a0)+ [003c004a]
00006498 0001 000f                or.b #$0f,d1
0000649c 00c8                     illegal
0000649e 0098 0040 001f           or.l #$0040001f,(a0)+ [003c004a]
000064a4 0001 0003                or.b #$03,d1
000064a8 00b0 0018 00a8 0010      or.l #$001800a8,(a0,d0.W,$10) == $ffffe9a0 [286a0298]
000064b0 0003 000e                or.b #$0e,d3
000064b4 0008                     illegal
000064b6 0018 000f                or.b #$0f,(a0)+ [00]
000064ba 00d0 0018                [ cmp2.b (a0),d0 ]
000064bc 0018 000f                or.b #$0f,(a0)+ [00]
000064c0 00d0 0038                [ cmp2.b (a0),d0 ]
000064c2 0038 00d8 0040           or.b #$d8,$0040 [00]
000064c8 0003 000e                or.b #$0e,d3
000064cc 0008                     illegal
000064ce 0018 000f                or.b #$0f,(a0)+ [00]
000064d2 00f0 0018 000f           [ cmp2.b (a0,d0.W,$0f) == $ffffe99f,d0 ]
000064d4 0018 000f                or.b #$0f,(a0)+ [00]
000064d8 00f0 0058 0128           [ cmp2.b (a0,d0.W,$28) == $ffffe9b8 (68020+),d0 ]
000064da 0058 0128                or.w #$0128,(a0)+ [003c]
000064de 0040 0002                or.w #$0002,d0
000064e2 000e                     illegal
000064e4 0140                     bchg.l d0,d0
000064e6 0078 000e 0088           or.w #$000e,$0088 [00fc]
000064ec 0018 0178                or.b #$78,(a0)+ [00]
000064f0 0040 0002                or.w #$0002,d0
000064f4 0003 0190                or.b #$90,d3
000064f8 0038 000f 01b0           or.b #$0f,$01b0 [00]
000064fe 0018 01bc                or.b #$bc,(a0)+ [00]
00006502 0011 0002                or.b #$02,(a1) [04]
00006506 000f                     illegal
00006508 01d0                     bset.b d0,(a0) [00]
0000650a 0018 000f                or.b #$0f,(a0)+ [00]
0000650e 01b0 0078                bclr.b d0,(a0,d0.W,$78) == $ffffea08 [e5]
00006512 0168 00b0                bchg.b d0,(a0,$00b0) == $00000ab0 [00]
00006516 0002 000f                or.b #$0f,d2
0000651a 0160                     bchg.b d0,-(a0) [00]
0000651c 00f8 0003 0150           [ cmp2.b $0150,d0 ]
0000651e 0003 0150                or.b #$50,d3
00006522 0118                     btst.b d0,(a0)+ [00]
00006524 0190                     bclr.b d0,(a0) [00]
00006526 0111                     btst.b d0,(a1) [04]
00006528 0002 000e                or.b #$0e,d2
0000652c 0138 0138                btst.b d0,$0138 [00]
00006530 000f                     illegal
00006532 0178 0138                bchg.b d0,$0138 [00]
00006536 01e8 0100                bset.b d0,(a0,$0100) == $00000b00 [20]
0000653a 0004 000f                or.b #$0f,d4
0000653e 0150                     bchg.b d0,(a0) [00]
00006540 0118                     btst.b d0,(a0)+ [00]
00006542 000f                     illegal
00006544 0140                     bchg.l d0,d0
00006546 0138 000e                btst.b d0,$000e [20]
0000654a 0200 0138                and.b #$38,d0
0000654e 0003 0220                or.b #$20,d3
00006552 0118                     btst.b d0,(a0)+ [00]
00006554 0220 00ef                and.b #$ef,-(a0) [00]
00006558 0002 000f                or.b #$0f,d2
0000655c 0188 00b8                movep.w d0,(a0,$00b8) == $00000ab8
00006560 000f                     illegal
00006562 0200 00d8                and.b #$d8,d0
00006566 0240 003b                and.w #$003b,d0
0000656a 0001 000f                or.b #$0f,d1
0000656e 0250 0038                and.w #$0038,(a0) [003c]
00006572 0280 007b 0001           and.l #$007b0001,d0
00006578 000e                     illegal
0000657a 0250 0098                and.w #$0098,(a0) [003c]
0000657e 02b0 0071 0001 000f      and.l #$00710001,(a0,d0.W,$0f) == $ffffe99f [5c286a02]
00006586 02d0 00b8                [ cmp2.w (a0),d0 ]
00006588 00b8 02f0 0071 0002      or.l #$02f00071,$0002 [00000000]
00006590 000e                     illegal
00006592 0258 0098                and.w #$0098,(a0)+ [003c]
00006596 000f                     illegal
00006598 0300                     btst.l d1,d0
0000659a 0078 02e0 00c2           or.w #$02e0,$00c2 [0000]
000065a0 0003 000e                or.b #$0e,d3
000065a4 0250 00d8                and.w #$00d8,(a0) [003c]
000065a8 000f                     illegal
000065aa 0250 00f8                and.w #$00f8,(a0) [003c]
000065ae 000f                     illegal
000065b0 0300                     btst.l d1,d0
000065b2 00d8                     illegal
000065b4 025c 00cf                and.w #$00cf,(a4)+
000065b8 0003 000f                or.b #$0f,d3
000065bc 0300                     btst.l d1,d0
000065be 00d8                     illegal
000065c0 000f                     illegal
000065c2 02e8 0118 000f           [ cmp2.w (a0,$000f) == $00000a0f,d0 ]
000065c4 0118                     btst.b d0,(a0)+ [00]
000065c6 000f                     illegal
000065c8 0230 00d8 02f8           and.b #$d8,(a0,d0.W[*2],$f8) == $ffffe988 (68020+) [03]
000065ce 0120                     btst.b d0,-(a0) [00]
000065d0 0003 000e                or.b #$0e,d3
000065d4 0250 0118                and.w #$0118,(a0) [003c]
000065d8 000e                     illegal
000065da 0250 0138                and.w #$0138,(a0) [003c]
000065de 000f                     illegal
000065e0 0320                     btst.b d1,-(a0) [00]
000065e2 0138 0318                btst.b d0,$0318 [00]
000065e6 0120                     btst.b d0,-(a0) [00]
000065e8 0003 000e                or.b #$0e,d3
000065ec 0340                     bchg.l d1,d0
000065ee 0138 0003                btst.b d0,$0003 [00]
000065f2 0260 0118                and.w #$0118,-(a0) [3000]
000065f6 000f                     illegal
000065f8 0260 0138                and.w #$0138,-(a0) [3000]
000065fc 0360                     bchg.b d1,-(a0) [00]
000065fe 0118                     btst.b d0,(a0)+ [00]
00006600 0002 000f                or.b #$0f,d2
00006604 0378 00f8                bchg.b d1,$00f8 [00]
00006608 000f                     illegal
0000660a 0378 0118                bchg.b d1,$0118 [00]
0000660e 02f0 0048 0003           [ cmp2.w (a0,d0.W,$03) == $ffffe993,d0 ]
00006610 0048                     illegal
00006612 0003 000f                or.b #$0f,d3
00006616 0288                     illegal
00006618 0038 000e 0310           or.b #$0e,$0310 [00]
0000661e 0038 000f 0288           or.b #$0f,$0288 [4e]
00006624 0018 0360                or.b #$60,(a0)+ [00]
00006628 0038 0001 0003           or.b #$01,$0003 [00]
0000662e 0370 0018                bchg.b d1,(a0,d0.W,$18) == $ffffe9a8 [00]
00006632 03b0 00b0                bclr.b d1,(a0,d0.W,$b0) == $ffffe940 [b4]
00006636 0002 0003                or.b #$03,d2
0000663a 03c0                     bset.l d1,d0
0000663c 00b8 000f 03e0 00d8      or.l #$000f03e0,$00d8 [00000000]
00006644 03f0 0102                bset.b d1,(a0,d0.W,$02) == $ffffe992 (68020+) [22]
00006648 0001 000e                or.b #$0e,d1
0000664c 03c0                     bset.l d1,d0
0000664e 0138 0450                btst.b d0,$0450 [00]
00006652 00f2 0003 000e           [ cmp2.b (a2,d0.W,$0e) == $0006b786,d0 ]
00006654 0003 000e                or.b #$0e,d3
00006658 03b8 0138                bclr.b d1,$0138 [00]
0000665c 000f                     illegal
0000665e 0460 0138                sub.w #$0138,-(a0) [3000]
00006662 0003 0470                or.b #$70,d3
00006666 00f8 0468 00c6           [ cmp2.b $00c6,d0 ]
00006668 0468 00c6 0001           sub.w #$00c6,(a0,$0001) == $00000a01 [3c00]
0000666e 0003 0470                or.b #$70,d3
00006672 00b8 0468 00a6 0001      or.l #$046800a6,$0001 [00000000]
0000667a 000e                     illegal
0000667c 0400 0078                sub.b #$78,d0
00006680 03a0                     bclr.b d1,-(a0) [00]
00006682 0050 0001                or.w #$0001,(a0) [003c]
00006686 000f                     illegal
00006688 0440 0098                sub.w #$0098,d0
0000668c 03d0                     bset.b d1,(a0) [00]
0000668e 0020 0001                or.b #$01,-(a0) [00]
00006692 000f                     illegal
00006694 0420 0018                sub.b #$18,-(a0) [00]
00006698 0430 0001 0002           sub.b #$01,(a0,d0.W,$02) == $ffffe992 [22]
0000669e 000f                     illegal
000066a0 0450 0018                sub.w #$0018,(a0) [003c]
000066a4 000f                     illegal
000066a6 0440 0038                sub.w #$0038,d0
000066aa 0480 0012 0002           sub.l #$00120002,d0
000066b0 0003 0490                or.b #$90,d3
000066b4 0058 000e                or.w #$000e,(a0)+ [003c]
000066b8 03e0                     bset.b d1,-(a0) [00]
000066ba 0018 04b8                or.b #$b8,(a0)+ [00]
000066be 0093 0001 0002           or.l #$00010002,(a3) [71859a3b]
000066c4 04a4 00b8 04d8           sub.l #$00b804d8,-(a4)
000066ca 0110                     btst.b d0,(a0) [00]
000066cc 0002 000e                or.b #$0e,d2
000066d0 04a4 0138 000f           sub.l #$0138000f,-(a4)
000066d6 0500                     btst.l d2,d0
000066d8 0118                     btst.b d0,(a0)+ [00]
000066da 0530 00f0                btst.b d2,(a0,d0.W,$f0) == $ffffe980 [60]
000066de 0001 0003                or.b #$03,d1
000066e2 0580                     bclr.l d2,d0
000066e4 00f0 05b0 00c8           [ cmp2.b (a0,d0.W,$c8) == $ffffe958,d0 ]
000066e6 05b0 00c8                bclr.b d2,(a0,d0.W,$c8) == $ffffe958 [52]
000066ea 0002 000f                or.b #$0f,d2
000066ee 0540                     bchg.l d2,d0
000066f0 00b8 000f 0580 00b8      or.l #$000f0580,$00b8 [00fc0852]
000066f8 0580                     bclr.l d2,d0
000066fa 0090 0002 000e           or.l #$0002000e,(a0) [003c004a]
00006700 0568 0078                bchg.b d2,(a0,$0078) == $00000a78 [4f]
00006704 000f                     illegal
00006706 0568 0078                bchg.b d2,(a0,$0078) == $00000a78 [4f]
0000670a 0574 0030                bchg.b d2,(a4,d0.W,$30) == $00bfc0c1
0000670e 0003 0018                or.b #$18,d3
00006712 0520                     btst.b d2,-(a0) [00]
00006714 0018 0017                or.b #$17,(a0)+ [00]
00006718 0580                     bclr.l d2,d0
0000671a 0018 0002                or.b #$02,(a0)+ [00]
0000671e 0530 0018                btst.b d2,(a0,d0.W,$18) == $ffffe9a8 [00]
00006722 0014 0118                or.b #$18,(a4)
00006726 0038 0015 00d0           or.b #$15,$00d0 [00]
0000672c 0028 0014 0070           or.b #$14,(a0,$0070) == $00000a70 [4d]
00006732 0068 0014 01b0           or.w #$0014,(a0,$01b0) == $00000bb0 [6100]
00006738 0110                     btst.b d0,(a0) [00]
0000673a 0014 01f0                or.b #$f0,(a4)
0000673e 0038 0015 01ef           or.b #$15,$01ef [00]
00006744 0078 0015 0217           or.w #$0015,$0217 [1000]
0000674a 0028 0014 0270           or.b #$14,(a0,$0270) == $00000c70 [46]
00006750 0060 0016                or.w #$0016,-(a0) [3000]
00006754 0298 0090 0014           and.l #$00900014,(a0)+ [003c004a]
0000675a 0310                     btst.b d1,(a0) [00]
0000675c 0120                     btst.b d0,-(a0) [00]
0000675e 0016 0378                or.b #$78,(a6)
00006762 0038 0014 0378           or.b #$14,$0378 [00]
00006768 0098 0014 0398           or.l #$00140398,(a0)+ [003c004a]
0000676e 0090 0015 0400           or.l #$00150400,(a0) [003c004a]
00006774 0130 0014                btst.b d0,(a0,d0.W,$14) == $ffffe9a4 [4e]
00006778 0458 0078                sub.w #$0078,(a0)+ [003c]
0000677c 0015 04ec                or.b #$ec,(a5)
00006780 0064 0014                or.w #$0014,-(a4)
00006784 03c8 0030                movep.l d1,(a0,$0030) == $00000a30
00006788 0014 03d8                or.b #$d8,(a4)
0000678c 0030 0014 0510           or.b #$14,(a0,d0.W[*4],$10) == $ffffe9a0 (68020+) [28]
00006792 0100                     btst.l d0,d0
00006794 0014 0570                or.b #$70,(a4)
00006798 0108 0014                movep.w (a0,$0014) == $00000a14,d0
0000679c 0578 0108                bchg.b d2,$0108 [00]
000067a0 0000 00f0                or.b #$f0,d0
000067a4 0000 0050                or.b #$50,d0
000067a8 0048                     illegal
000067aa 0048                     illegal
000067ac 0050 0200                or.w #$0200,(a0) [003c]
000067b0 0000 0200                or.b #$00,d0
000067b4 0050 0038                or.w #$0038,(a0) [003c]
000067b8 0038 0050 0000           or.b #$50,$0000 [00]
000067be 00f0 0000 0050           [ cmp2.b (a0,d0.W,$50) == $ffffe9e0,d0 ]
000067c0 0000 0050                or.b #$50,d0
000067c4 0048                     illegal
000067c6 0048                     illegal
000067c8 0050 1018                or.w #$1018,(a0) [003c]
000067cc 6b00 00d0                bmi.w #$00d0 == $0000689e (F)
000067d0 0240 00ff                and.w #$00ff,d0
000067d4 c0fc 002a                mulu.w #$002a,d0
000067d8 1218                     move.b (a0)+ [00],d1
000067da 4881                     ext.w d1
000067dc d041                     add.w d1,d0
000067de 2279 0000 36f6           movea.l $000036f6 [00061b9c],a1
000067e4 43f1 0000                lea.l (a1,d0.W,$00) == $0003deea,a1
000067e8 7000                     moveq #$00,d0
000067ea 1018                     move.b (a0)+ [00],d0
000067ec 67dc                     beq.b #$dc == $000067ca (F)
000067ee 0c00 0020                cmp.b #$20,d0
000067f2 6700 00a2                beq.w #$00a2 == $00006896 (F)
000067f6 72cd                     moveq #$cd,d1
000067f8 0c00 0041                cmp.b #$41,d0
000067fc 6424                     bcc.b #$24 == $00006822 (T)
000067fe 72d4                     moveq #$d4,d1
00006800 0c00 0030                cmp.b #$30,d0
00006804 641c                     bcc.b #$1c == $00006822 (T)
00006806 7200                     moveq #$00,d1
00006808 0c00 0021                cmp.b #$21,d0
0000680c 671a                     beq.b #$1a == $00006828 (F)
0000680e 7201                     moveq #$01,d1
00006810 0c00 0028                cmp.b #$28,d0
00006814 6712                     beq.b #$12 == $00006828 (F)
00006816 7202                     moveq #$02,d1
00006818 0c00 0029                cmp.b #$29,d0
0000681c 670a                     beq.b #$0a == $00006828 (F)
0000681e 7203                     moveq #$03,d1
00006820 6006                     bra.b #$06 == $00006828 (T)
00006822 d200                     add.b d0,d1
00006824 0241 00ff                and.w #$00ff,d1
00006828 c2fc 0028                mulu.w #$0028,d1
0000682c 45f9 0000 68a0           lea.l $000068a0,a2
00006832 45f2 1000                lea.l (a2,d1.W,$00) == $0006d7e7,a2
00006836 7e07                     moveq #$07,d7
00006838 2649                     movea.l a1,a3
0000683a 121a                     move.b (a2)+ [12],d1
0000683c c313                     and.b d1,(a3) [71]
0000683e 141a                     move.b (a2)+ [12],d2
00006840 8513                     or.b d2,(a3) [71]
00006842 c32b 1c8c                and.b d1,(a3,$1c8c) == $00065835 [4e]
00006846 141a                     move.b (a2)+ [12],d2
00006848 852b 1c8c                or.b d2,(a3,$1c8c) == $00065835 [4e]
0000684c c32b 3918                and.b d1,(a3,$3918) == $000674c1 [b0]
00006850 141a                     move.b (a2)+ [12],d2
00006852 852b 3918                or.b d2,(a3,$3918) == $000674c1 [b0]
00006856 c32b 55a4                and.b d1,(a3,$55a4) == $0006914d [ec]
0000685a 141a                     move.b (a2)+ [12],d2
0000685c 852b 55a4                or.b d2,(a3,$55a4) == $0006914d [ec]
00006860 47eb 002a                lea.l (a3,$002a) == $00063bd3,a3
00006864 45ea fffb                lea.l (a2,-$0005) == $0006d7e3,a2
00006868 121a                     move.b (a2)+ [12],d1
0000686a c313                     and.b d1,(a3) [71]
0000686c 141a                     move.b (a2)+ [12],d2
0000686e 8513                     or.b d2,(a3) [71]
00006870 c32b 1c8c                and.b d1,(a3,$1c8c) == $00065835 [4e]
00006874 141a                     move.b (a2)+ [12],d2
00006876 852b 1c8c                or.b d2,(a3,$1c8c) == $00065835 [4e]
0000687a c32b 3918                and.b d1,(a3,$3918) == $000674c1 [b0]
0000687e 141a                     move.b (a2)+ [12],d2
00006880 852b 3918                or.b d2,(a3,$3918) == $000674c1 [b0]
00006884 c32b 55a4                and.b d1,(a3,$55a4) == $0006914d [ec]
00006888 141a                     move.b (a2)+ [12],d2
0000688a 852b 55a4                or.b d2,(a3,$55a4) == $0006914d [ec]
0000688e 47eb 002a                lea.l (a3,$002a) == $00063bd3,a3
00006892 51cf ffa6                dbf .w d7,#$ffa6 == $0000683a (F)
00006896 43e9 0001                lea.l (a1,$0001) == $0003ff5b,a1
0000689a 6000 ff4c                bra.w #$ff4c == $000067e8 (T)
0000689e 4e75                     rts  == $6000001a
000068a0 cf30 3000                and.b d7,(a0,d3.W,$00) == $00000d13 [d6]
000068a4 00c7                     illegal
000068a6 3038 0800                move.w $0800 [0003],d0
000068aa c730 3808                and.b d3,(a0,d3.L,$08) == $04140d1b [0f]
000068ae 00c7                     illegal
000068b0 3038 0800                move.w $0800 [0003],d0
000068b4 c730 3808                and.b d3,(a0,d3.L,$08) == $04140d1b [0f]
000068b8 00e7                     illegal
000068ba 0018 1800                or.b #$00,(a0)+ [00]
000068be cf30 3000                and.b d7,(a0,d3.W,$00) == $00000d13 [d6]
000068c2 00e7                     illegal
000068c4 0018 1800                or.b #$00,(a0)+ [00]
000068c8 f30c                     illegal
000068ca 0c00 00e1                cmp.b #$e1,d0
000068ce 181e                     move.b (a6)+,d4
000068d0 0600 e318                add.b #$18,d0
000068d4 1c04                     move.b d4,d6
000068d6 00e3                     illegal
000068d8 181c                     move.b (a4)+,d4
000068da 0400 e318                sub.b #$18,d0
000068de 1c04                     move.b d4,d6
000068e0 00e3                     illegal
000068e2 181c                     move.b (a4)+,d4
000068e4 0400 f30c                sub.b #$0c,d0
000068e8 0c00 00f9                cmp.b #$f9,d0
000068ec 0006 0600                or.b #$00,d6
000068f0 9f60                     sub.w d7,-(a0) [3000]
000068f2 6000 00cf                bra.w #$00cf == $000069c3 (T)
000068f6 3030 0000                move.w (a0,d0.W,$00) == $ffffe990 [0044],d0
000068fa c730 3808                and.b d3,(a0,d3.L,$08) == $04140d1b [0f]
000068fe 00c7                     illegal
00006900 3038 0800                move.w $0800 [0003],d0
00006904 c730 3808                and.b d3,(a0,d3.L,$08) == $04140d1b [0f]
00006908 00c7                     illegal
0000690a 3038 0800                move.w $0800 [0003],d0
0000690e 8760                     or.w d3,-(a0) [3000]
00006910 7818                     moveq #$18,d4
00006912 00cf                     illegal
00006914 0030 3000 ff00           or.b #$00,(a0,a7.L[*8],$00) == $0000121c (68020+) [a9]
0000691a 0000 00ff                or.b #$ff,d0
0000691e 0000 0000                or.b #$00,d0
00006922 ff00                     illegal
00006924 0000 00ff                or.b #$ff,d0
00006928 0000 0000                or.b #$00,d0
0000692c ff00                     illegal
0000692e 0000 009f                or.b #$9f,d0
00006932 6060                     bra.b #$60 == $00006994 (T)
00006934 0000 8f60                or.b #$60,d0
00006938 7010                     moveq #$10,d0
0000693a 00cf                     illegal
0000693c 0030 3000 837c           or.b #$00,(a0,a0.W[*2],$7c) == $0000147c (68020+) [00]
00006942 7c00                     moveq #$00,d6
00006944 0001 c6fe                or.b #$fe,d1
00006948 3800                     move.w d0,d4
0000694a 10ce                     illegal
0000694c ef21                     asl.b d7,d1
0000694e 0000 d6ff                or.b #$ff,d0
00006952 2900                     move.l d0,-(a4)
00006954 08e6 f711                bset.b #$f711,-(a6)
00006958 0018 c6e7                or.b #$e7,(a0)+ [00]
0000695c 2100                     move.l d0,-(a0) [4ef83000]
0000695e 807c 7f03                or.w #$7f03,d0
00006962 00c1                     illegal
00006964 003e                     illegal
00006966 3e00                     move.w d0,d7
00006968 c738 3800                and.b d3,$3800 [36]
0000696c 00c3                     illegal
0000696e 383c 0400                move.w #$0400,d4
00006972 e318                     rol.b #$01,d0
00006974 1c04                     move.b d4,d6
00006976 00e3                     illegal
00006978 181c                     move.b (a4)+,d4
0000697a 0400 e318                sub.b #$18,d0
0000697e 1c04                     move.b d4,d6
00006980 00e3                     illegal
00006982 181c                     move.b (a4)+,d4
00006984 0400 e318                sub.b #$18,d0
00006988 1c04                     move.b d4,d6
0000698a 00f3 000c 0c00           [ cmp2.b (a3,d0.L[*4],$00) == $00061b39 (68020+),d0 ]
0000698c 000c                     illegal
0000698e 0c00 837c                cmp.b #$7c,d0
00006992 7c00                     moveq #$00,d6
00006994 0001 c6fe                or.b #$fe,d1
00006998 3800                     move.w d0,d4
0000699a 900c                     illegal
0000699c 6f63                     ble.b #$63 == $00006a01 (F)
0000699e 00e1                     illegal
000069a0 181e                     move.b (a6)+,d4
000069a2 0600 c330                add.b #$30,d0
000069a6 3c0c                     move.w a4,d6
000069a8 0087 6078 1800           or.l #$60781800,d7
000069ae 00fe                     illegal
000069b0 ff01                     illegal
000069b2 0080 007f 7f00           or.l #$007f7f00,d0
000069b8 837c                     illegal
000069ba 7c00                     moveq #$00,d6
000069bc 0001 c6fe                or.b #$fe,d1
000069c0 3800                     move.w d0,d4
000069c2 9806                     sub.b d6,d4
000069c4 6761                     beq.b #$61 == $00006a27 (F)
000069c6 00c0                     illegal
000069c8 3c3f                     illegal
000069ca 0300                     btst.l d1,d0
000069cc e106                     asl.b #$08,d6
000069ce 1e18                     move.b (a0)+ [00],d7
000069d0 0038 c6c7 0100           or.b #$c7,$0100 [00]
000069d6 807c 7f03                or.w #$7f03,d0
000069da 00c1                     illegal
000069dc 003e                     illegal
000069de 3e00                     move.w d0,d7
000069e0 e31c                     rol.b #$01,d4
000069e2 1c00                     move.b d0,d6
000069e4 00c1                     illegal
000069e6 3c3e                     illegal
000069e8 0200 816c                and.b #$6c,d0
000069ec 7e12                     moveq #$12,d7
000069ee 0001 ccfe                or.b #$fe,d1
000069f2 3200                     move.w d0,d1
000069f4 01fe                     illegal
000069f6 fe00                     illegal
000069f8 0080 0c7f 7300           or.l #$0c7f7300,d0
000069fe f10c                     illegal
00006a00 0e02                     illegal
00006a02 00f9 0006 0600 00fe      [ cmp2.b $060000fe,d0 ]
00006a04 0006 0600                or.b #$00,d6
00006a08 00fe                     illegal
00006a0a ff00                     illegal
00006a0c 0000 c0ff                or.b #$ff,d0
00006a10 3f00                     move.w d0,-(a7) [09ec]
00006a12 1fc0                     illegal
00006a14 e020                     asr.b d0,d0
00006a16 0003 fcfc                or.b #$fc,d3
00006a1a 0000 8006                or.b #$06,d0
00006a1e 7f79                     illegal
00006a20 0038 c6c7 0100           or.b #$c7,$0100 [00]
00006a26 807c 7f03                or.w #$7f03,d0
00006a2a 00c1                     illegal
00006a2c 003e                     illegal
00006a2e 3e00                     move.w d0,d7
00006a30 837c                     illegal
00006a32 7c00                     moveq #$00,d6
00006a34 0001 c6fe                or.b #$fe,d1
00006a38 3800                     move.w d0,d4
00006a3a 1cc0                     move.b d0,(a6)+
00006a3c e323                     asl.b d1,d3
00006a3e 0003 fcfc                or.b #$fc,d3
00006a42 0000 01c6                or.b #$c6,d0
00006a46 fe38                     illegal
00006a48 0018 c6e7                or.b #$e7,(a0)+ [00]
00006a4c 2100                     move.l d0,-(a0) [4ef83000]
00006a4e 807c 7f03                or.w #$7f03,d0
00006a52 00c1                     illegal
00006a54 003e                     illegal
00006a56 3e00                     move.w d0,d7
00006a58 01fe                     illegal
00006a5a fe00                     illegal
00006a5c 0080 067f 7900           or.l #$067f7900,d0
00006a62 f00c 0f03                [ F-LINE (MMU 68030) ]
00006a64 0f03                     btst.l d7,d3
00006a66 00e1                     illegal
00006a68 181e                     move.b (a6)+,d4
00006a6a 0600 e318                add.b #$18,d0
00006a6e 1c04                     move.b d4,d6
00006a70 00c7                     illegal
00006a72 3038 0800                move.w $0800 [0003],d0
00006a76 c730 3808                and.b d3,(a0,d3.L,$08) == $04140d1b [0f]
00006a7a 00e7                     illegal
00006a7c 0018 1800                or.b #$00,(a0)+ [00]
00006a80 837c                     illegal
00006a82 7c00                     moveq #$00,d6
00006a84 0001 c6fe                or.b #$fe,d1
00006a88 3800                     move.w d0,d4
00006a8a 18c6                     move.b d6,(a4)+
00006a8c e721                     asl.b d3,d1
00006a8e 0080 7c7f 0300           or.l #$7c7f0300,d0
00006a94 01c6                     bset.l d0,d6
00006a96 fe38                     illegal
00006a98 0018 c6e7                or.b #$e7,(a0)+ [00]
00006a9c 2100                     move.l d0,-(a0) [4ef83000]
00006a9e 807c 7f03                or.w #$7f03,d0
00006aa2 00c1                     illegal
00006aa4 003e                     illegal
00006aa6 3e00                     move.w d0,d7
00006aa8 837c                     illegal
00006aaa 7c00                     moveq #$00,d6
00006aac 0001 c6fe                or.b #$fe,d1
00006ab0 3800                     move.w d0,d4
00006ab2 18c6                     move.b d6,(a4)+
00006ab4 e721                     asl.b d3,d1
00006ab6 0080 7e7f 0100           or.l #$7e7f0100,d0
00006abc c006                     and.b d6,d0
00006abe 3f39 0038 c6c7           move.w $0038c6c7,-(a7) [09ec]
00006ac4 0100                     btst.l d0,d0
00006ac6 807c 7f03                or.w #$7f03,d0
00006aca 00c1                     illegal
00006acc 003e                     illegal
00006ace 3e00                     move.w d0,d7
00006ad0 ef10                     roxl.b #$07,d0
00006ad2 1000                     move.b d0,d0
00006ad4 00c7                     illegal
00006ad6 3838 0000                move.w $0000 [0000],d4
00006ada c338 3c04                and.b d1,$3c04 [66]
00006ade 0083 6c7c 1000           or.l #$6c7c1000,d3
00006ae4 817c                     illegal
00006ae6 7e02                     moveq #$02,d7
00006ae8 0001 c6fe                or.b #$fe,d1
00006aec 3800                     move.w d0,d4
00006aee 18c6                     move.b d6,(a4)+
00006af0 e721                     asl.b d3,d1
00006af2 009c 0063 6300           or.l #$00636300,(a4)+
00006af8 03fc                     illegal
00006afa fc00                     illegal
00006afc 0001 c6fe                or.b #$fe,d1
00006b00 3800                     move.w d0,d4
00006b02 18c6                     move.b d6,(a4)+
00006b04 e721                     asl.b d3,d1
00006b06 0000 fcff                or.b #$ff,d0
00006b0a 0300                     btst.l d1,d0
00006b0c 01c6                     bset.l d0,d6
00006b0e fe38                     illegal
00006b10 0018 c6e7                or.b #$e7,(a0)+ [00]
00006b14 2100                     move.l d0,-(a0) [4ef83000]
00006b16 00fc                     illegal
00006b18 ff03                     illegal
00006b1a 0081 007e 7e00           or.l #$007e7e00,d1
00006b20 837c                     illegal
00006b22 7c00                     moveq #$00,d6
00006b24 0001 c6fe                or.b #$fe,d1
00006b28 3800                     move.w d0,d4
00006b2a 1cc0                     move.b d0,(a6)+
00006b2c e323                     asl.b d1,d3
00006b2e 001f c0e0                or.b #$e0,(a7)+ [60]
00006b32 2000                     move.l d0,d0
00006b34 1fc0                     illegal
00006b36 e020                     asr.b d0,d0
00006b38 0019 c6e6                or.b #$e6,(a1)+ [04]
00006b3c 2000                     move.l d0,d0
00006b3e 807c 7f03                or.w #$7f03,d0
00006b42 00c1                     illegal
00006b44 003e                     illegal
00006b46 3e00                     move.w d0,d7
00006b48 07f8 f800                bset.b d3,$f800 [ff]
00006b4c 0003 ccfc                or.b #$fc,d3
00006b50 3000                     move.w d0,d0
00006b52 19c6                     illegal
00006b54 e620                     asr.b d3,d0
00006b56 0018 c6e7                or.b #$e7,(a0)+ [00]
00006b5a 2100                     move.l d0,-(a0) [4ef83000]
00006b5c 18c6                     move.b d6,(a4)+
00006b5e e721                     asl.b d3,d1
00006b60 0010 ccef                or.b #$ef,(a0) [00]
00006b64 2300                     move.l d0,-(a1) [00000000]
00006b66 01f8 fe06                bset.b d0,$fe06 [65]
00006b6a 0083 007c 7c00           or.l #$007c7c00,d3
00006b70 01fe                     illegal
00006b72 fe00                     illegal
00006b74 0000 c0ff                or.b #$ff,d0
00006b78 3f00                     move.w d0,-(a7) [09ec]
00006b7a 1fc0                     illegal
00006b7c e020                     asr.b d0,d0
00006b7e 0007 f8f8                or.b #$f8,d7
00006b82 0000 03c0                or.b #$c0,d0
00006b86 fc3c                     illegal
00006b88 001f c0e0                or.b #$e0,(a7)+ [60]
00006b8c 2000                     move.l d0,d0
00006b8e 01fe                     illegal
00006b90 fe00                     illegal
00006b92 0080 007f 7f00           or.l #$007f7f00,d0
00006b98 01fe                     illegal
00006b9a fe00                     illegal
00006b9c 0000 c0ff                or.b #$ff,d0
00006ba0 3f00                     move.w d0,-(a7) [09ec]
00006ba2 1fc0                     illegal
00006ba4 e020                     asr.b d0,d0
00006ba6 0007 f8f8                or.b #$f8,d7
00006baa 0000 03c0                or.b #$c0,d0
00006bae fc3c                     illegal
00006bb0 001f c0e0                or.b #$e0,(a7)+ [60]
00006bb4 2000                     move.l d0,d0
00006bb6 1fc0                     illegal
00006bb8 e020                     asr.b d0,d0
00006bba 009f 0060 6000           or.l #$00606000,(a7)+ [6000001a]
00006bc0 837c                     illegal
00006bc2 7c00                     moveq #$00,d6
00006bc4 0001 c6fe                or.b #$fe,d1
00006bc8 3800                     move.w d0,d4
00006bca 1cc0                     move.b d0,(a6)+
00006bcc e323                     asl.b d1,d3
00006bce 0001 defe                or.b #$fe,d1
00006bd2 2000                     move.l d0,d0
00006bd4 10c6                     move.b d6,(a0)+ [00]
00006bd6 ef29                     lsl.b d7,d1
00006bd8 0018 c6e7                or.b #$e7,(a0)+ [00]
00006bdc 2100                     move.l d0,-(a0) [4ef83000]
00006bde 807e                     illegal
00006be0 7f01                     illegal
00006be2 00c0                     illegal
00006be4 003f                     illegal
00006be6 3f00                     move.w d0,-(a7) [09ec]
00006be8 39c6                     illegal
00006bea c600                     and.b d0,d3
00006bec 0018 c6e7                or.b #$e7,(a0)+ [00]
00006bf0 2100                     move.l d0,-(a0) [4ef83000]
00006bf2 18c6                     move.b d6,(a4)+
00006bf4 e721                     asl.b d3,d1
00006bf6 0000 feff                or.b #$ff,d0
00006bfa 0100                     btst.l d0,d0
00006bfc 00c6                     illegal
00006bfe ff39                     illegal
00006c00 0018 c6e7                or.b #$e7,(a0)+ [00]
00006c04 2100                     move.l d0,-(a0) [4ef83000]
00006c06 18c6                     move.b d6,(a4)+
00006c08 e721                     asl.b d3,d1
00006c0a 009c 0063 6300           or.l #$00636300,(a4)+
00006c10 8778 7800                or.w d3,$7800 [e9e0]
00006c14 00c3                     illegal
00006c16 303c 0c00                move.w #$0c00,d0
00006c1a c730 3808                and.b d3,(a0,d3.L,$08) == $04140d1b [0f]
00006c1e 00c7                     illegal
00006c20 3038 0800                move.w $0800 [0003],d0
00006c24 c730 3808                and.b d3,(a0,d3.L,$08) == $04140d1b [0f]
00006c28 00c7                     illegal
00006c2a 3038 0800                move.w $0800 [0003],d0
00006c2e 8778 7800                or.w d3,$7800 [e9e0]
00006c32 00c3                     illegal
00006c34 003c 3c00                or.b #$3c00,ccr
00006c38 f906                     illegal
00006c3a 0600 00f8                add.b #$f8,d0
00006c3e 0607 0100                add.b #$00,d7
00006c42 f806                     illegal
00006c44 0701                     btst.l d3,d1
00006c46 00f8 0607 0100           [ cmp2.b $0100,d0 ]
00006c48 0607 0100                add.b #$00,d7
00006c4c 38c6                     move.w d6,(a4)+
00006c4e c701                     abcd.b d1,d3
00006c50 0018 c6e7                or.b #$e7,(a0)+ [00]
00006c54 2100                     move.l d0,-(a0) [4ef83000]
00006c56 807c 7f03                or.w #$7f03,d0
00006c5a 00c1                     illegal
00006c5c 003e                     illegal
00006c5e 3e00                     move.w d0,d7
00006c60 39c6                     illegal
00006c62 c600                     and.b d0,d3
00006c64 0010 ccef                or.b #$ef,(a0) [00]
00006c68 2300                     move.l d0,-(a1) [00000000]
00006c6a 01d8                     bset.b d0,(a0)+ [00]
00006c6c fe26                     illegal
00006c6e 0003 f0fc                or.b #$fc,d3
00006c72 0c00 07d8                cmp.b #$d8,d0
00006c76 f820                     illegal
00006c78 0013 ccec                or.b #$ec,(a3) [71]
00006c7c 2000                     move.l d0,d0
00006c7e 19c6                     illegal
00006c80 e620                     asr.b d3,d0
00006c82 009c 0063 6300           or.l #$00636300,(a4)+
00006c88 3fc0                     illegal
00006c8a c000                     and.b d0,d0
00006c8c 001f c0e0                or.b #$e0,(a7)+ [60]
00006c90 2000                     move.l d0,d0
00006c92 1fc0                     illegal
00006c94 e020                     asr.b d0,d0
00006c96 001f c0e0                or.b #$e0,(a7)+ [60]
00006c9a 2000                     move.l d0,d0
00006c9c 1fc0                     illegal
00006c9e e020                     asr.b d0,d0
00006ca0 0019 c6e6                or.b #$e6,(a1)+ [04]
00006ca4 2000                     move.l d0,d0
00006ca6 00fe                     illegal
00006ca8 ff01                     illegal
00006caa 0080 007f 7f00           or.l #$007f7f00,d0
00006cb0 39c6                     illegal
00006cb2 c600                     and.b d0,d3
00006cb4 0010 eeef                or.b #$ef,(a0) [00]
00006cb8 0100                     btst.l d0,d0
00006cba 00fe                     illegal
00006cbc ff01                     illegal
00006cbe 0000 d6ff                or.b #$ff,d0
00006cc2 2900                     move.l d0,-(a4)
00006cc4 10c6                     move.b d6,(a0)+ [00]
00006cc6 ef29                     lsl.b d7,d1
00006cc8 0018 c6e7                or.b #$e7,(a0)+ [00]
00006ccc 2100                     move.l d0,-(a0) [4ef83000]
00006cce 18c6                     move.b d6,(a4)+
00006cd0 e721                     asl.b d3,d1
00006cd2 009c 0063 6300           or.l #$00636300,(a4)+
00006cd8 39c6                     illegal
00006cda c600                     and.b d0,d3
00006cdc 0018 e6e7                or.b #$e7,(a0)+ [00]
00006ce0 0100                     btst.l d0,d0
00006ce2 08f6 f701 0000           bset.b #$f701,(a6,d0.W,$00) == $00dfcf90
00006ce8 deff                     illegal
00006cea 2100                     move.l d0,-(a0) [4ef83000]
00006cec 10ce                     illegal
00006cee ef21                     asl.b d7,d1
00006cf0 0018 c6e7                or.b #$e7,(a0)+ [00]
00006cf4 2100                     move.l d0,-(a0) [4ef83000]
00006cf6 18c6                     move.b d6,(a4)+
00006cf8 e721                     asl.b d3,d1
00006cfa 009c 0063 6300           or.l #$00636300,(a4)+
00006d00 837c                     illegal
00006d02 7c00                     moveq #$00,d6
00006d04 0001 c6fe                or.b #$fe,d1
00006d08 3800                     move.w d0,d4
00006d0a 18c6                     move.b d6,(a4)+
00006d0c e721                     asl.b d3,d1
00006d0e 0018 c6e7                or.b #$e7,(a0)+ [00]
00006d12 2100                     move.l d0,-(a0) [4ef83000]
00006d14 18c6                     move.b d6,(a4)+
00006d16 e721                     asl.b d3,d1
00006d18 0018 c6e7                or.b #$e7,(a0)+ [00]
00006d1c 2100                     move.l d0,-(a0) [4ef83000]
00006d1e 807c 7f03                or.w #$7f03,d0
00006d22 00c1                     illegal
00006d24 003e                     illegal
00006d26 3e00                     move.w d0,d7
00006d28 03fc                     illegal
00006d2a fc00                     illegal
00006d2c 0001 c6fe                or.b #$fe,d1
00006d30 3800                     move.w d0,d4
00006d32 18c6                     move.b d6,(a4)+
00006d34 e721                     asl.b d3,d1
00006d36 0000 fcff                or.b #$ff,d0
00006d3a 0300                     btst.l d1,d0
00006d3c 01c0                     bset.l d0,d0
00006d3e fe3e                     illegal
00006d40 001f c0e0                or.b #$e0,(a7)+ [60]
00006d44 2000                     move.l d0,d0
00006d46 1fc0                     illegal
00006d48 e020                     asr.b d0,d0
00006d4a 009f 0060 6000           or.l #$00606000,(a7)+ [6000001a]
00006d50 837c                     illegal
00006d52 7c00                     moveq #$00,d6
00006d54 0001 c6fe                or.b #$fe,d1
00006d58 3800                     move.w d0,d4
00006d5a 18c6                     move.b d6,(a4)+
00006d5c e721                     asl.b d3,d1
00006d5e 0018 c6e7                or.b #$e7,(a0)+ [00]
00006d62 2100                     move.l d0,-(a0) [4ef83000]
00006d64 00da                     illegal
00006d66 ff25                     illegal
00006d68 0000 ccff                or.b #$ff,d0
00006d6c 3300                     move.w d0,-(a1) [0000]
00006d6e 8176 7e08                or.w d0,(a6,d7.L[*8],$08) == $00e0f007 (68020+) [1824]
00006d72 00c4                     illegal
00006d74 003b                     illegal
00006d76 3b00                     move.w d0,-(a5)
00006d78 03fc                     illegal
00006d7a fc00                     illegal
00006d7c 0001 c6fe                or.b #$fe,d1
00006d80 3800                     move.w d0,d4
00006d82 18c6                     move.b d6,(a4)+
00006d84 e721                     asl.b d3,d1
00006d86 0000 fcff                or.b #$ff,d0
00006d8a 0300                     btst.l d1,d0
00006d8c 01cc fe32                movep.l d0,(a4,-$01ce) == $00bfdf33
00006d90 0018 c6e7                or.b #$e7,(a0)+ [00]
00006d94 2100                     move.l d0,-(a0) [4ef83000]
00006d96 18c6                     move.b d6,(a4)+
00006d98 e721                     asl.b d3,d1
00006d9a 009c 0063 6300           or.l #$00636300,(a4)+
00006da0 837c                     illegal
00006da2 7c00                     moveq #$00,d6
00006da4 0001 c6fe                or.b #$fe,d1
00006da8 3800                     move.w d0,d4
00006daa 1cc0                     move.b d0,(a6)+
00006dac e323                     asl.b d1,d3
00006dae 0083 7c7c 0000           or.l #$7c7c0000,d3
00006db4 c106                     abcd.b d6,d0
00006db6 3e38 0038                move.w $0038 [00fc],d7
00006dba c6c7                     mulu.w d7,d3
00006dbc 0100                     btst.l d0,d0
00006dbe 807c 7f03                or.w #$7f03,d0
00006dc2 00c1                     illegal
00006dc4 003e                     illegal
00006dc6 3e00                     move.w d0,d7
00006dc8 03fc                     illegal
00006dca fc00                     illegal
00006dcc 0081 307e 4e00           or.l #$307e4e00,d1
00006dd2 c730 3808                and.b d3,(a0,d3.L,$08) == $04140d1b [0f]
00006dd6 00c7                     illegal
00006dd8 3038 0800                move.w $0800 [0003],d0
00006ddc c730 3808                and.b d3,(a0,d3.L,$08) == $04140d1b [0f]
00006de0 00c7                     illegal
00006de2 3038 0800                move.w $0800 [0003],d0
00006de6 c730 3808                and.b d3,(a0,d3.L,$08) == $04140d1b [0f]
00006dea 00e7                     illegal
00006dec 0018 1800                or.b #$00,(a0)+ [00]
00006df0 39c6                     illegal
00006df2 c600                     and.b d0,d3
00006df4 0018 c6e7                or.b #$e7,(a0)+ [00]
00006df8 2100                     move.l d0,-(a0) [4ef83000]
00006dfa 18c6                     move.b d6,(a4)+
00006dfc e721                     asl.b d3,d1
00006dfe 0018 c6e7                or.b #$e7,(a0)+ [00]
00006e02 2100                     move.l d0,-(a0) [4ef83000]
00006e04 18c6                     move.b d6,(a4)+
00006e06 e721                     asl.b d3,d1
00006e08 0018 c6e7                or.b #$e7,(a0)+ [00]
00006e0c 2100                     move.l d0,-(a0) [4ef83000]
00006e0e 807c 7f03                or.w #$7f03,d0
00006e12 00c1                     illegal
00006e14 003e                     illegal
00006e16 3e00                     move.w d0,d7
00006e18 39c6                     illegal
00006e1a c600                     and.b d0,d3
00006e1c 0018 c6e7                or.b #$e7,(a0)+ [00]
00006e20 2100                     move.l d0,-(a0) [4ef83000]
00006e22 18c6                     move.b d6,(a4)+
00006e24 e721                     asl.b d3,d1
00006e26 0080 6c7f 1300           or.l #$6c7f1300,d0
00006e2c 817c                     illegal
00006e2e 7e02                     moveq #$02,d7
00006e30 00c1                     illegal
00006e32 383e                     illegal
00006e34 0600 e310                add.b #$10,d0
00006e38 1c0c                     illegal
00006e3a 00f7 0008 0800           [ cmp2.b (a7,d0.L,$00) == $ffffe7ac,d0 ]
00006e3c 0008                     illegal
00006e3e 0800 39c6                btst.l #$39c6,d0
00006e42 c600                     and.b d0,d3
00006e44 0018 c6e7                or.b #$e7,(a0)+ [00]
00006e48 2100                     move.l d0,-(a0) [4ef83000]
00006e4a 08d6 f721                bset.b #$f721,(a6)
00006e4e 0000 d6ff                or.b #$ff,d0
00006e52 2900                     move.l d0,-(a4)
00006e54 00fe                     illegal
00006e56 ff01                     illegal
00006e58 0080 7c7f 0300           or.l #$7c7f0300,d0
00006e5e 816c 7e12                or.w d0,(a4,$7e12) == $00c05f13 [0000]
00006e62 00c9                     illegal
00006e64 0036 3600 39c6           or.b #$00,(a6,d3.L,$c6) == $04f3f2d9 (68020+)
00006e6a c600                     and.b d0,d3
00006e6c 0018 c6e7                or.b #$e7,(a0)+ [00]
00006e70 2100                     move.l d0,-(a0) [4ef83000]
00006e72 10ee ef01                move.b (a6,-$10ff) == $00dfdf01,(a0)+ [00]
00006e76 0080 7c7f 0300           or.l #$7c7f0300,d0
00006e7c 01ee fe10                bset.b d0,(a6,-$01f0) == $00dfee10
00006e80 0018 c6e7                or.b #$e7,(a0)+ [00]
00006e84 2100                     move.l d0,-(a0) [4ef83000]
00006e86 18c6                     move.b d6,(a4)+
00006e88 e721                     asl.b d3,d1
00006e8a 009c 0063 6300           or.l #$00636300,(a4)+
00006e90 33cc cc00 0011           move.w a4,$cc000011 [fc08]
00006e96 ccee 2200                mulu.w (a6,$2200) == $00e01200 [532e],d6
00006e9a 11cc                     illegal
00006e9c ee22                     asr.b d7,d2
00006e9e 0081 787e 0600           or.l #$787e0600,d1
00006ea4 c330 3c0c                and.b d1,(a0,d3.L[*4],$0c) == $04140d1f (68020+) [00]
00006ea8 00c7                     illegal
00006eaa 3038 0800                move.w $0800 [0003],d0
00006eae c730 3808                and.b d3,(a0,d3.L,$08) == $04140d1b [0f]
00006eb2 00e7                     illegal
00006eb4 0018 1800                or.b #$00,(a0)+ [00]
00006eb8 03fc                     illegal
00006eba fc00                     illegal
00006ebc 0001 ccfe                or.b #$fe,d1
00006ec0 3200                     move.w d0,d1
00006ec2 8118                     or.b d0,(a0)+ [00]
00006ec4 7e66                     moveq #$66,d7
00006ec6 00c3                     illegal
00006ec8 303c 0c00                move.w #$0c00,d0
00006ecc 8760                     or.w d3,-(a0) [3000]
00006ece 7818                     moveq #$18,d4
00006ed0 0003 ccfc                or.b #$fc,d3
00006ed4 3000                     move.w d0,d0
00006ed6 01fc                     illegal
00006ed8 fe02                     illegal
00006eda 0081 007e 7e00           or.l #$007e7e00,d1
00006ee0 39c6                     illegal
00006ee2 c600                     and.b d0,d3
00006ee4 0010 eeef                or.b #$ef,(a0) [00]
00006ee8 0100                     btst.l d0,d0
00006eea 00fe                     illegal
00006eec ff01                     illegal
00006eee 0000 d6ff                or.b #$ff,d0
00006ef2 2900                     move.l d0,-(a4)
00006ef4 10c6                     move.b d6,(a0)+ [00]
00006ef6 ef29                     lsl.b d7,d1
00006ef8 0018 c6e7                or.b #$e7,(a0)+ [00]
00006efc 2100                     move.l d0,-(a0) [4ef83000]
00006efe 18c6                     move.b d6,(a4)+
00006f00 e721                     asl.b d3,d1
00006f02 009c 0063 6300           or.l #$00636300,(a4)+
00006f08 39c6                     illegal
00006f0a c600                     and.b d0,d3
00006f0c 0018 e6e7                or.b #$e7,(a0)+ [00]
00006f10 0100                     btst.l d0,d0
00006f12 08f6 f701 0000           bset.b #$f701,(a6,d0.W,$00) == $00dfcf90
00006f18 deff                     illegal
00006f1a 2100                     move.l d0,-(a0) [4ef83000]
00006f1c 10ce                     illegal
00006f1e ef21                     asl.b d7,d1
00006f20 0018 c6e7                or.b #$e7,(a0)+ [00]
00006f24 2100                     move.l d0,-(a0) [4ef83000]
00006f26 18c6                     move.b d6,(a4)+
00006f28 e721                     asl.b d3,d1
00006f2a 009c 0063 6300           or.l #$00636300,(a4)+
00006f30 837c                     illegal
00006f32 7c00                     moveq #$00,d6
00006f34 0001 c6fe                or.b #$fe,d1
00006f38 3800                     move.w d0,d4
00006f3a 18c6                     move.b d6,(a4)+
00006f3c e721                     asl.b d3,d1
00006f3e 0018 c6e7                or.b #$e7,(a0)+ [00]
00006f42 2100                     move.l d0,-(a0) [4ef83000]
00006f44 18c6                     move.b d6,(a4)+
00006f46 e721                     asl.b d3,d1
00006f48 0018 c6e7                or.b #$e7,(a0)+ [00]
00006f4c 2100                     move.l d0,-(a0) [4ef83000]
00006f4e 807c 7f03                or.w #$7f03,d0
00006f52 00c1                     illegal
00006f54 003e                     illegal
00006f56 3e00                     move.w d0,d7
00006f58 03fc                     illegal
00006f5a fc00                     illegal
00006f5c 0001 c6fe                or.b #$fe,d1
00006f60 3800                     move.w d0,d4
00006f62 18c6                     move.b d6,(a4)+
00006f64 e721                     asl.b d3,d1
00006f66 0000 fcff                or.b #$ff,d0
00006f6a 0300                     btst.l d1,d0
00006f6c 01c0                     bset.l d0,d0
00006f6e fe3e                     illegal
00006f70 001f c0e0                or.b #$e0,(a7)+ [60]
00006f74 2000                     move.l d0,d0
00006f76 1fc0                     illegal
00006f78 e020                     asr.b d0,d0
00006f7a 009f 0060 6000           or.l #$00606000,(a7)+ [6000001a]
00006f80 837c                     illegal
00006f82 7c00                     moveq #$00,d6
00006f84 0001 c6fe                or.b #$fe,d1
00006f88 3800                     move.w d0,d4
00006f8a 18c6                     move.b d6,(a4)+
00006f8c e721                     asl.b d3,d1
00006f8e 0018 c6e7                or.b #$e7,(a0)+ [00]
00006f92 2100                     move.l d0,-(a0) [4ef83000]
00006f94 00da                     illegal
00006f96 ff25                     illegal
00006f98 0000 ccff                or.b #$ff,d0
00006f9c 3300                     move.w d0,-(a1) [0000]
00006f9e 8176 7e08                or.w d0,(a6,d7.L[*8],$08) == $00e0f007 (68020+) [1824]
00006fa2 00c4                     illegal
00006fa4 003b                     illegal
00006fa6 3b00                     move.w d0,-(a5)
00006fa8 03fc                     illegal
00006faa fc00                     illegal
00006fac 0001 c6fe                or.b #$fe,d1
00006fb0 3800                     move.w d0,d4
00006fb2 18c6                     move.b d6,(a4)+
00006fb4 e721                     asl.b d3,d1
00006fb6 0000 fcff                or.b #$ff,d0
00006fba 0300                     btst.l d1,d0
00006fbc 01cc fe32                movep.l d0,(a4,-$01ce) == $00bfdf33
00006fc0 0018 c6e7                or.b #$e7,(a0)+ [00]
00006fc4 2100                     move.l d0,-(a0) [4ef83000]
00006fc6 18c6                     move.b d6,(a4)+
00006fc8 e721                     asl.b d3,d1
00006fca 009c 0063 6300           or.l #$00636300,(a4)+
00006fd0 837c                     illegal
00006fd2 7c00                     moveq #$00,d6
00006fd4 0001 c6fe                or.b #$fe,d1
00006fd8 3800                     move.w d0,d4
00006fda 1cc0                     move.b d0,(a6)+
00006fdc e323                     asl.b d1,d3
00006fde 0083 7c7c 0000           or.l #$7c7c0000,d3
00006fe4 c106                     abcd.b d6,d0
00006fe6 3e38 0038                move.w $0038 [00fc],d7
00006fea c6c7                     mulu.w d7,d3
00006fec 0100                     btst.l d0,d0
00006fee 807c 7f03                or.w #$7f03,d0
00006ff2 00c1                     illegal
00006ff4 003e                     illegal
00006ff6 3e00                     move.w d0,d7
00006ff8 03fc                     illegal
00006ffa fc00                     illegal
00006ffc 0081 307e 4e54           or.l #$307e4e54,d1
