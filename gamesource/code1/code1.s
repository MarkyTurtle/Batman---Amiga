


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
L00003050           addq.w #$08,a0                      ; adda.w
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
L000030da           lea.l   $0005a36c,a7                       ; External Address - Stack

L000030e0           moveq   #$02,d7
L000030e2           lea.l   L000031b0,a0
L000030e8           lea.l   $00000064,a1                        ; Vector 
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

L000031ac           dc.w $ffff                      ; illegal
L000031ae           dc.w $fffe                      ; illegal
L000031b0           dc.w $0000, $32c0               ; or.b #$c0,d0
L000031b4           dc.w $0000, $32f8               ; or.b #$f8,d0
L000031b8           dc.w $0000, $331e               ; or.b #$1e,d0
L000031bc           dc.w $0000, $335a               ; or.b #$5a,d0
L000031c0           dc.w $0000, $3370               ; or.b #$70,d0
L000031c4           dc.w $0000, $3396               ; or.b #$96,d0
L000031c8           dc.w $2c01                      ; move.l d1,d6
L000031ca           dc.w $fffe                      ; illegal
L000031cc           dc.w $010a, $0002               ; movep.w (a2,$0002) == $0006d7ea,d0
L000031d0           dc.w $0108, $0002               ; movep.w (a0,$0002) == $00000a02,d0
L000031d4           dc.w $00e2                      ; illegal
L000031d6           dc.w $7680                      ; moveq #$80,d3
L000031d8           dc.w $00e0                      ; illegal
L000031da           dc.w $0006, $00e6               ; or.b #$e6,d6
L000031de           dc.w $98e0                      ; suba.w -(a0) [3000],a4
L000031e0           dc.w $00e4                      ; illegal
L000031e2           dc.w $0006, $00ea               ; or.b #$ea,d6
L000031e6           dc.w $bb40                      ; eor.w d5,d0
L000031e8           dc.w $00e8                      ; $0006, $00ee [ cmp2.b (a0,$00ee) == $00000aee,d0 ]
L000031ea           dc.w $0006, $00ee               ; or.b #$ee,d6
L000031ee           dc.w $dda0                      ; add.l d6,-(a0) [4ef83000]
L000031f0           dc.w $00ec                      ; $0006, $0182 [ cmp2.b (a4,$0182) == $00bfe283,d0 ]
L000031f2           dc.w $0006, $0182               ; or.b #$82,d6
L000031f6           dc.w $0446, $0184               ; sub.w #$0184,d6
L000031fa           dc.w $088a                      ; illegal
L000031fc           dc.w $0186                      ; bclr.l d0,d6
L000031fe           dc.w $0cce                      ; illegal
L00003200           dc.w $0188, $0048             ; movep.w d0,(a0,$0048) == $00000a48
L00003204           dc.w $018a, $028c             ; movep.w d0,(a2,$028c) == $0006da74
L00003208           dc.w $018c, $0c64             ; movep.w d0,(a4,$0c64) == $00bfed65
L0000320c           dc.w $018e, $0a22             ; movep.w d0,(a6,$0a22) == $00dffa22
L00003210           dc.w $0190                      ; bclr.b d0,(a0) [00]
L00003212           dc.w $06a6, $0192, $0c4a      ; add.l #$01920c4a,-(a6)
L00003218           dc.w $0194                      ; bclr.b d0,(a4)
L0000321a           dc.w $0ec6                      ; illegal
L0000321c           dc.w $0196                      ; bclr.b d0,(a6)
L0000321e           dc.w $0e88                      ; illegal
L00003220           dc.w $0198                      ; bclr.b d0,(a0)+ [00]
L00003222           dc.w $0600, $019a               ; add.b #$9a,d0
L00003226           dc.w $0262, $019c               ; and.w #$019c,-(a2) [93f1]
L0000322a           dc.w $0668, $019e, $06ae      ; add.w #$019e,(a0,$06ae) == $000010ae [0d1b]
L00003230           dc.w $da01                      ; add.b d1,d5
L00003232           dc.w $fffe                      ; illegal
L00003234           dc.w $010a, $0000               ; movep.w (a2,$0000) == $0006d7e8,d0
L00003238           dc.w $0108, $0000               ; movep.w (a0,$0000) == $00000a00,d0
L0000323c           dc.w $00e2                      ; illegal
L0000323e           dc.w $c89a                      ; and.l (a2)+ [124197f7],d4
L00003240           dc.w $00e0                      ; illegal
L00003242           dc.w $0007, $00e6               ; or.b #$e6,d7
L00003246           dc.w $d01a                      ; add.b (a2)+ [12],d0
L00003248           dc.w $00e4                      ; illegal
L0000324a           dc.w $0007, $00ea               ; or.b #$ea,d7
L0000324e           dc.w $d79a                      ; add.l d3,(a2)+ [124197f7]
L00003250           dc.w $00e8                      ; $0007, $00ee [ cmp2.b (a0,$00ee) == $00000aee,d0 ]
L00003252           dc.w $0007, $00ee               ; or.b #$ee,d7
L00003256           dc.w $df1a                      ; add.b d7,(a2)+ [12]
L00003258           dc.w $00ec                      ; $0007, $0180 [ cmp2.b (a4,$0180) == $00bfe281,d0 ]
L0000325a           dc.w $0007, $0180               ; or.b #$80,d7
L0000325e           dc.w $0000, $0182               ; or.b #$82,d0
L00003262           dc.w $0000, $0184               ; or.b #$84,d0
L00003266           dc.w $0000, $0186               ; or.b #$86,d0
L0000326a           dc.w $0000, $0188               ; or.b #$88,d0
L0000326e           dc.w $0000, $018a               ; or.b #$8a,d0
L00003272           dc.w $0000, $018c               ; or.b #$8c,d0
L00003276           dc.w $0000, $018e               ; or.b #$8e,d0
L0000327a           dc.w $0000, $0190               ; or.b #$90,d0
L0000327e           dc.w $0000, $0192               ; or.b #$92,d0
L00003282           dc.w $0000, $0194               ; or.b #$94,d0
L00003286           dc.w $0000, $0196               ; or.b #$96,d0
L0000328a           dc.w $0000, $0198               ; or.b #$98,d0
L0000328e           dc.w $0000, $019a               ; or.b #$9a,d0
L00003292           dc.w $0000, $019c               ; or.b #$9c,d0
L00003296           dc.w $0000, $019e               ; or.b #$9e,d0
L0000329a           dc.w $0000, $ffff               ; or.b #$ff,d0
L0000329e           dc.w $fffe                      ; illegal


L000032a0           dc.w $0000, $0060               ; or.b #$60,d0
L000032a4           dc.w $0fff                      ; illegal
L000032a6           dc.w $0008                      ; illegal
L000032a8           dc.w $0a22, $0444               ; eor.b #$44,-(a2) [f1]
L000032ac           dc.w $0862, $0666               ; bchg.b #$0666,-(a2) [f1]
L000032b0           dc.w $0888                      ; illegal
L000032b2           dc.w $0aaa, $0a40, $0c60, $0e80 ; eor.l #$0a400c60,(a2,$0e80) == $0006e668 [25e19a09]
L000032ba           dc.w $0ea0                      ; $0ec0 [ moves.l d0,-(a0) [4ef83000] ]
L000032bc           dc.w $0ec0                      ; illegal
L000032be           dc.w $0eee                      ; $2f00 3039 [ cas.l d0,d4,(a6,$3039) == $00e02039 [6e011422] ]

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

L00003312           move.w #$0008,$00dff09c
L0000331a           move.l (a7)+,d0
L0000331c           rte

L0000331e           move.l  d0,-(a7) 
L00003320           move.w  $00dff01e,d0
L00003326           btst.l  #$0004,d0
L0000332a           bne.b   L0000334e
L0000332c           btst.l  #$0005,d0
L00003330           bne.b   L0000333e
L00003332           move.w  #$0040,$00dff09c
L0000333a           move.l  (a7)+,d0
L0000333c           rte 

L0000333e           bsr.w   L00003526
L00003342           move.w  #$0020,$00dff09c
L0000334a           move.l  (a7)+,d0
L0000334c           rte 

L0000334e           move.w  #$0010,$00dff09c
L00003356           move.l  (a7)+,d0
L00003358           rte 

L0000335a           move.l  d0,-(a7)
L0000335c           move.w  $00dff01e,d0
L00003362           and.w   #$0780,d0
L00003366           move.w  d0,$00dff09a
L0000336c           move.l  (a7)+,d0
L0000336e           rte

L00003370           move.l  d0,-(a7)
L00003372           move.w  $00dff01e,d0
L00003378           btst.l  #$000c,d0
L0000337c           bne.b   L0000338a
L0000337e           move.w  #$0800,$00dff09c
L00003386           move.l  (a7)+,d0
L00003388           rte 

L0000338a           move.w  #$1000,$00dff09c
L00003392           move.l  (a7)+,d0
L00003394           rte 

L00003396           move.l  d0,-(a7)
L00003398           move.w  $00dff01e,d0
L0000339e           btst.l  #$000e,d0
L000033a2           bne.b   L000033c8
L000033a4           move.b  $00bfdd00,d0
L000033aa           bpl.b   L000033bc
L000033ac           bsr.w   L00003514
L000033b0           move.w  #$2000,$00dff09c
L000033b8           move.l  (a7)+,d0
L000033ba           rte 

L000033bc           move.w  #$2000,$00dff09c
L000033c4           move.l  (a7)+,d0
L000033c6           rte  

L000033c8           move.w  #$4000,$00dff09c
L000033d0           move.l  (a7)+,d0
L000033d2           rte



L000033d4           lsr.b   #$02,d0
L000033d6           bcc.b   L000033dc
L000033d8           bsr.w   L00003544
L000033dc           lsr.b   #$02,d0
L000033de           bcc.b   L0000344e
L000033e0           movem.l d1-d2/a0,-(a7)
L000033e4           move.b  $00bfec01,d1
L000033ea           not.b   d1
L000033ec           lsr.b   #$01,d1
L000033ee           bcc.b   L00003406
L000033f0           lea.l   L000034f4,a0
L000033f6           ext.w   d1
L000033f8           move.b  (pc,d1.W),d1            ; $00003450
L000033fc           move.w  d1,d2
L000033fe           lsr.w   #$03,d2
L00003400           bclr.b  d1,$00(a0,d2.W)         ; $00001407
L00003404           bra.b   L00003442
L00003406           lea.l   L000034f4,a0
L0000340c           ext.w   d1
L0000340e           move.b  (pc,d1.W),d1            ; $00003450
L00003412           move.w  d1,d2
L00003414           lsr.w   #$03,d2
L00003416           bset.b  d1,$00(a0,d2.W)         ; $00001407 [28]
L0000341a           tst.b   d1
L0000341c           beq.b   L00003442
L0000341e           lea.l   L000034d0,a0
L00003424           move.w  L000034f0,d2
L0000342a           move.b  d1,$00(a0,d2.W)         ; $00001407 [28]
L0000342e           addq.w  #$01,d2
L00003430           and.w   #$001f,d2
L00003434           cmp.w   L000034f2,d2
L0000343a           beq.b   L00003442
L0000343c           move.w  d2,L000034f0
L00003442           move.b  #$40,$00bfee01
L0000344a           movem.l (a7)+,d1-d2/a0
L0000344e           rts 



L00003450           dc.w    $2731, $3233                ; move.l (a1,d3.W[*2],$33) == $000402a0 (68020+) [17000018],-(a3) [43338718]
L00003454           dc.w    $3435, $3637                ; move.w (a5,d3.W[*8],$37) == $00bfd44a (68020+),d2
L00003458           dc.w    $3839, $302d 3d5c           ; move.w $302d3d5c,d4
L0000345e           dc.w    $0030, $5157 4552           ; or.b #$57,(a0,d4.W[*4],$52) == $00000b53 (68020+) [7c]
L00003464           dc.w    $5459                       ; addq.w #$02,(a1)+ [0400]
L00003466           dc.w    $5549                       ; subaq.w #$02,a1
L00003468           dc.w    $4f50                       ; illegal
L0000346a           dc.w    $5b5d                       ; subq.w #$05,(a5)+
L0000346c           dc.w    $0031, $3233 4153           ; or.b #$33,(a1,d4.W,$53) == $000400ae (68020+) [00]
L00003472           dc.w    $4446                       ; neg.w d6
L00003474           dc.w    $4748                       ; illegal
L00003476           dc.w    $4a4b                       ; [ tst.w a3 ]
L00003478           dc.w    $4c3b                       ; 2300 0034 [ mulu.l (pc,d0.W,$34=$000034b0) == $00001440,d2 ]
L0000347a           dc.w    $2300                       ; move.l d0,-(a1) [00000000]
L0000347c           dc.w    $0034, $3536, $005a         ; or.b #$36,(a4,d0.W,$5a) == $00bfc0eb
L00003482           dc.w    $5843                       ; addq.w #$04,d3
L00003484           dc.w    $5642                       ; addq.w #$03,d2
L00003486           dc.w    $4e4d                       ; trap #$0d
L00003488           dc.w    $2c2e, $2f00                ; move.l (a6,$2f00) == $00e01f00 [33fcc000],d6
L0000348c           dc.w    $0037, $3839 2008           ; or.b #$39,(a7,d2.W,$08) == $0000122b [b0]
L00003492           dc.w    $090d, $0d1b                ; movep.w (a5,$0d1b) == $00bfde1b,d4
L00003496           dc.w    $7f00                       ; illegal
L00003498           dc.w    $0000, $2d00                ; or.b #$00,d0
L0000349c           dc.w    $8c8d                       ; illegal
L0000349e           dc.w    $8e8f                       ; illegal
L000034a0           dc.w    $8182                       ; [ unpk d2,d0,#$8384 ]
L000034a2           dc.w    $8384                       ; [ unpk d4,d1,#$8586 ]
L000034a4           dc.w    $8586                       ; [ unpk d6,d2,#$8788 ]
L000034a6           dc.w    $8788                       ; [ unpk -(a0),-(a3),#$898a ]
L000034a8           dc.w    $898a                       ; [ unpk -(a2),-(a4),#$2829 ]
L000034aa           dc.w    $2829, $2f2a                ; move.l (a1,$2f2a) == $00042e84 [00000000],d4
L000034ae           dc.w    $2b8b, $0000                ; move.l a3,(a5,d0.W,$00) == $00bfb090
L000034b2           dc.w    $0000, $0000                ; or.b #$00,d0
L000034b6           dc.w    $0000, $0000                ; or.b #$00,d0
L000034ba           dc.w    $0000, $0000                ; or.b #$00,d0
L000034be           dc.w    $0000, $0000                ; or.b #$00,d0
L000034c2           dc.w    $0000, $0000                ; or.b #$00,d0
L000034c6           dc.w    $0000, $0000                ; or.b #$00,d0
L000034ca           dc.w    $0000, $0000                ; or.b #$00,d0
L000034ce           dc.w    $0000, $0000                ; or.b #$00,d0
L000034d2           dc.w    $0000, $0000                ; or.b #$00,d0
L000034d6           dc.w    $0000, $0000                ; or.b #$00,d0
L000034da           dc.w    $0000, $0000                ; or.b #$00,d0
L000034de           dc.w    $0000, $0000                ; or.b #$00,d0
L000034e2           dc.w    $0000, $0000                ; or.b #$00,d0
L000034e6           dc.w    $0000, $0000                ; or.b #$00,d0
L000034ea           dc.w    $0000, $0000                ; or.b #$00,d0
L000034ee           dc.w    $0000, $0000                ; or.b #$00,d0
L000034f2           dc.w    $0000, $0000                ; or.b #$00,d0
L000034f6           dc.w    $0000, $0000                ; or.b #$00,d0
L000034fa           dc.w    $0000, $0000                ; or.b #$00,d0
L000034fe           dc.w    $0000, $0000                ; or.b #$00,d0
L00003502           dc.w    $0000, $0000                ; or.b #$00,d0
L00003506           dc.w    $0000, $0000                ; or.b #$00,d0
L0000350a           dc.w    $0000, $0000                ; or.b #$00,d0
L0000350e           dc.w    $0000, $0000                ; or.b #$00,d0
L00003512           dc.w    $0000, $e408                ; or.b #$08,d0
    


L00003516           bcc.b   L00003520 4e75              ; 6408
L00003518           move.b  #$00,$00bfee01              ; 13fc 0000 00bf ee01
L00003520           rts                                 ; 4e75


L00003522           dc.w    $0000, $3542                ; or.b #$42,d0


L00003526           movem.l d1-d7/a0-a6,-(a7)
L0000352a           addq.w  #$01,L000036ee
L00003530           jsr     $00048018               ; External Address
L00003536           move.b  #$00,$00bfee01
L0000353e           movem.l (a7)+,d1-d7/a0-a6
L00003542           rts


L00003544           movem.l d0-d7/a0-a6,-(a7)
L00003548           bsr.w   L00003566
L0000354c           addq.w  #$01,L00003564
L00003552           movea.l L00003560,a0
L00003558           jsr     (a0)
L0000355a           movem.l (a7)+,d0-d7/a0-a6
L0000355e           rts


L00003560           dc.w $0000, $3542               ; or.b #$42,d0
L00003564           dc.w $0000, $3039               ; or.b #$39,d0
L00003568           dc.w $00df                      ; illegal
L0000356a           dc.w $f00a                      ; $3239 [ F-LINE (MMU 68030) ]


L0000356c           move.w  L00003630,d1
L00003572           move.w  d0,L00003630
L00003578           bsr.w   L000035fa
L0000357c           move.b  d0,L00003637
L00003582           add.w   d1,L00003646
L00003588           add.w   d2,L00003648
L0000358e           btst.b  #$0006,$00bfe001
L00003596           seq.b   L00003636
L0000359c           seq.b   L00003644
L000035a2           btst.b  #$0002,$00dff016
L000035aa           seq.b   L00003645
L000035b0           move.w  $00dff00c,d0
L000035b6           move.w  L00003632,d1
L000035bc           move.w  d0,L00003632
L000035c2           bsr.b   L000035fa
L000035c4           move.b  d0,L0000363b
L000035ca           add.w   d1,L0000364c
L000035d0           add.w   d2,L0000364e
L000035d6           btst.b  #$0007,$00bfe001
L000035de           seq.b   L0000363a
L000035e4           seq.b   L0000364a
L000035ea           btst.b  #$0006,$00dff016
L000035f2           seq.b   L0000364b
L000035f8           rts 



L000035fa           move.w  d0,d3
L000035fc           move.w  d1,d2
L000035fe           sub.b   d3,d1
L00003600           neg.b   d1
L00003602           ext.w   d1
L00003604           lsr.w   #$08,d2
L00003606           lsr.w   #$08,d3
L00003608           sub.b   d3,d2
L0000360a           neg.b   d2
L0000360c           ext.w   d2
L0000360e           moveq   #$03,d3
L00003610           and.w   d0,d3
L00003612           lsr.w   #$06,d0
L00003614           and.w   #$000c,d0
L00003618           or.w    d3,d0
L0000361a           move.b  $04(pc,d0.W),d0         ; $00003620? table?
L0000361e           rts 



L00003620           dc.w $0004, $0501               ; or.b #$01,d4
L00003624           dc.w $080c                      ; illegal
L00003626           dc.w $0d09, $0a0e               ; movep.w (a1,$0a0e) == $00040968,d6
L0000362a           dc.w $0f0b, $0206               ; movep.w (a3,$0206) == $00063daf,d7
L0000362e           dc.w $0703                      ; btst.l d3,d3
L00003630           dc.w $0000, $0000               ; or.b #$00,d0
L00003634           dc.w $0000, $0000               ; or.b #$00,d0
L00003638           dc.w $0000, $0000               ; or.b #$00,d0
L0000363c           dc.w $0000, $0000               ; or.b #$00,d0
L00003640           dc.w $0000, $0000               ; or.b #$00,d0
L00003644           dc.w $0000, $0000               ; or.b #$00,d0
L00003648           dc.w $0000, $0000               ; or.b #$00,d0
L0000364c           dc.w $0000, $0000               ; or.b #$00,d0



                                                        ; Address L00003650 not called directly from this code.
L00003650           move.l  d0,-(a7)
L00003652           bsr.b   L0000365a
L00003654           bne.b   L00003652
L00003656           move.l  (a7)+,d0
L00003658           rts



L0000365a           movem.l d1-d2/a0,-(a7)
L0000365e           lea.l   L000034d0,a0
L00003664           moveq   #$00,d0
L00003666           movem.w L000034f0,d1-d2
L0000366e           cmp.w   d1,d2
L00003670           beq.b   L00003682
L00003672           move.b  $00(a0,d2.W),d0
L00003676           addq.w  #$01,d2
L00003678           and.w   #$001f,d2
L0000367c           move.w  d2,L000034f2
L00003682           tst.b   d0
L00003684           movem.l (a7)+,d1-d2/a0
L00003688           rts 



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



L000036ee           dc.w    $0000, $0000            ; or.b #$00,d0
L000036f2           dc.w    $0006, $8dce            ; or.b #$ce,d6
L000036f6           dc.w    $0006, $1b9c            ; or.b #$9c,d6



L000036fa           move.w  L000036ee,d0
L000036fe           cmp.w   L000036ee,d0
L00003702           beq.b   L000036fe
L00003704           move.w  L000036f0,d1
L00003708           cmp.w   d0,d1
L0000370a           bpl.b   L000036fa
L0000370c           add.w   #$0001,d0
L00003710           move.w  d0,L000036f0
L00003714           movem.l L000036f2,d0-d1
L0000371a           exg.l   d0,d1
L0000371c           movem.l d0-d1,L000036f2
L00003722           lea.l   L000031d6,a0
L00003726           move.l  #$00001c8c,d1
L0000372c           moveq   #$03,d7
L0000372e           move.w  d0,(a0)
L00003730           addq.w #$04,a0                  ; addaq.w
L00003732           swap.w  d0
L00003734           move.w  d0,(a0)
L00003736           addq.w #$04,a0                  ; addaq.w
L00003738           swap.w  d0
L0000373a           add.l   d1,d0
L0000373c           dbf.w   d7,L0000372e
L00003740           addq.w  #$01,L0000632c
L00003744           rts



L00003746           lea.l   L00061b9c,a0                ; External Address
L0000374c           move.w   #$3917,d7
L00003750           clr.l   (a0)+
L00003752           dbf.w   d7,L00003750
L00003756           lea.l   L0005a36c,a0                ; External Address
L0000375c           move.w  #$1c8b,d7
L00003760           clr.l   (a0)+
L00003762           dbf.w   d7,L00003760
L00003766           rts 


L00003768           dc.w $0a0a                      ; illegal
L0000376a           dc.w $3030, $3030               ; move.w (a0,d3.W,$30) == $00000d43 [001b],d0
L0000376e           dc.w $00ff                      ; illegal


L00003770           lea.l   L00003768,a0
L00003776           move.w  d1,(a0)
L00003778           moveq   #$03,d2
L0000377a           clr.w   d1
L0000377c           move.w  d0,d1
L0000377e           and.w   #$000f,d1
L00003782           cmp.w   #$000a,d1
L00003786           bcs.b   L0000378a
L00003788           addq.w  #$07,d1
L0000378a           add.b   #$30,d1
L0000378e           move.b  d1,$02(a0,d2.W)             ; $00001409 [c8]
L00003792           lsr.w   #$04,d0
L00003794           dbf.w   d2,L0000377a
L00003798           move.b  (a0)+,d0
L0000379a           cmp.b   #$ff,d0
L0000379e           beq.b   L000037ee
L000037a0           and.w   #$00ff,d0
L000037a4           mulu.w  #$0028,d0
L000037a8           moveq   #$00,d1
L000037aa           move.b  (a0)+,d1
L000037ac           add.w   d1,d0
L000037ae           movea.l #$0007c89a,a1           ; External Address - Panel
L000037b4           lea.l   $02(a1,d0.W),a1
L000037b8           moveq   #$00,d0
L000037ba           move.b  (a0)+,d0
L000037bc           beq.b   L00003798
L000037be           sub.w   #$0020,d0
L000037c2           lsl.w   #$03,d0
L000037c4           lea.l   L000037f0,a2
L000037ca           lea.l   $00(a2,d0.W),a2
L000037ce           moveq   #$07,d7
L000037d0           movea.l a1,a3
L000037d2           move.b  (a2),(a3)
L000037d4           move.b  (a2),$0780(a3)          ; $00064329
L000037d8           move.b  (a2),$0f00(a3)          ; $00064aa9
L000037dc           move.b  (a2)+,$1680(a3)         ; $00065229 [c6]
L000037e0           lea.l   $0028(a3),a3            ; == $00063bd1,a3
L000037e4           dbf.w   d7,L000037d2
L000037e8           lea.l   $0001(a1),a1            ; == $0003ff5b,a1
L000037ec           bra.b   L000037b8
L000037ee           rts



L000037f0           dc.w    $0000, $0000                ; or.b #$00,d0
L000037f4           dc.w    $0000, $0000                ; or.b #$00,d0
L000037f8           dc.w    $3030, $3030                ; move.w (a0,d3.W,$30) == $00000d43 [001b],d0
L000037fc           dc.w    $0030, $3000, $3624         ; or.b #$00,(a0,d3.W[*8],$24) == $00000d37 (68020+) [7c]
L00003802           dc.w    $0000, $0000                ; or.b #$00,d0
L00003806           dc.w    $0000, $6c9a                ; or.b #$9a,d0
L0000380a           dc.w    $bcfa, $7428                ; cmpa.w (pc,$7428) == $0000ac34 [2000],a6
L0000380e           dc.w    $1000                       ; move.b d0,d0
L00003810           dc.w    $7ed6                       ; moveq #$d6,d7
L00003812           dc.w    $d07c, $16d6                ; add.w #$16d6,d0
L00003816           dc.w    $fc00                       ; illegal
L00003818           dc.w    $82c6                       ; divu.w d6,d1
L0000381a           dc.w    $fe54                       ; illegal
L0000381c           dc.w    $7c38                       ; moveq #$38,d6
L0000381e           dc.w    $1000                       ; move.b d0,d0
L00003820           dc.w    $2874, $7474                ; movea.l (a4,d7.W[*4],$74) == $00bfe174 (68020+),a4
L00003824           dc.w    $7420                       ; moveq #$20,d2
L00003826           dc.w    $7400                       ; moveq #$00,d2
L00003828           dc.w    $1810                       ; move.b (a0) [00],d4
L0000382a           dc.w    $0000, $0000                ; or.b #$00,d0
L0000382e           dc.w    $0000, $3870                ; or.b #$70,d0
L00003832           dc.w    $7070                       ; moveq #$70,d0
L00003834           dc.w    $7070                       ; moveq #$70,d0
L00003836           dc.w    $3800                       ; move.w d0,d4
L00003838           dc.w    $381c                       ; move.w (a4)+,d4
L0000383a           dc.w    $1c1c                       ; move.b (a4)+,d6
L0000383c           dc.w    $1c1c                       ; move.b (a4)+,d6
L0000383e           dc.w    $3800                       ; move.w d0,d4
L00003840           dc.w    $1054                       ; illegal
L00003842           dc.w    $28d6                       ; move.l (a6),(a4)+
L00003844           dc.w    $2854                       ; movea.l (a4),a4
L00003846           dc.w    $1000                       ; move.b d0,d0
L00003848           dc.w    $0000, $0808                ; or.b #$08,d0
L0000384c           dc.w    $3e08                       ; move.w a0,d7
L0000384e           dc.w    $0800, $0000                ; btst.l #$0000,d0
L00003852           dc.w    $0000, $0008                ; or.b #$08,d0
L00003856           dc.w    $0810, $0000                ; btst.b #$0000,(a0) [00]
L0000385a           dc.w    $0000, $3e00                ; or.b #$00,d0
L0000385e           dc.w    $0000, $0000                ; or.b #$00,d0
L00003862           dc.w    $0000, $0018                ; or.b #$18,d0
L00003866           dc.w    $1800                       ; move.b d0,d4
L00003868           dc.w    $3078, $b078                ; movea.w $b078 [42b0],a0
L0000386c           dc.w    $3478, $3000                ; movea.w $3000 [7000],a2
L00003870           dc.w    $7ce6                       ; moveq #$e6,d6
L00003872           dc.w    $e6e6                       ; ror.w -(a6)
L00003874           dc.w    $e6e6                       ; ror.w -(a6)
L00003876           dc.w    $7c00                       ; moveq #$00,d6
L00003878           dc.w    $7838                       ; moveq #$38,d4
L0000387a           dc.w    $3838, $3838                ; move.w $3838 [381c],d4
L0000387e           dc.w    $3800                       ; move.w d0,d4
L00003880           dc.w    $7cce                       ; moveq #$ce,d6
L00003882           dc.w    $0e7c                       ; illegal
L00003884           dc.w    $c0ce                       ; illegal
L00003886           dc.w    $fe00                       ; illegal
L00003888           dc.w    $7cce                       ; moveq #$ce,d6
L0000388a           dc.w    $0e3c                       ; illegal
L0000388c           dc.w    $0ece                       ; illegal
L0000388e           dc.w    $7c00                       ; moveq #$00,d6
L00003890           dc.w    $7cdc                       ; moveq #$dc,d6
L00003892           dc.w    $dcdc                       ; adda.w (a4)+,a6
L00003894           dc.w    $fe1c                       ; illegal
L00003896           dc.w    $1c00                       ; move.b d0,d6
L00003898           dc.w    $fee6                       ; illegal
L0000389a           dc.w    $e0fc                       ; illegal
L0000389c           dc.w    $06e6                       ; illegal
L0000389e           dc.w    $7c00                       ; moveq #$00,d6
L000038a0           dc.w    $7ce6                       ; moveq #$e6,d6
L000038a2           dc.w    $e0fc                       ; illegal
L000038a4           dc.w    $e6e6                       ; ror.w -(a6)
L000038a6           dc.w    $7c00                       ; moveq #$00,d6
L000038a8           dc.w    $fece                       ; illegal
L000038aa           dc.w    $0e1c                       ;  ; 1c38 [ moves.b d1,(a4)+ ]
L000038ac           dc.w    $1c38, $3800                ; move.b $3800 [36],d6
L000038b0           dc.w    $7ce6                       ; moveq #$e6,d6
L000038b2           dc.w    $e67c                       ; ror.w d3,d4
L000038b4           dc.w    $e6e6                       ; ror.w -(a6)
L000038b6           dc.w    $7c00                       ; moveq #$00,d6
L000038b8           dc.w    $7ce6                       ; moveq #$e6,d6
L000038ba           dc.W    $e67e                       ; ror.w d3,d6
L000038bc           dc.W    $06e6                       ; illegal
L000038be           dc.W    $7c00                       ; moveq #$00,d6
L000038c0           dc.W    $0030, $3000, $0030         ; or.b #$00,(a0,d0.W,$30) == $ffffe9c0 [49]
L000038c6           dc.W    $3000                       ; move.w d0,d0
L000038c8           dc.W    $0030, $3000, $3030         ; or.b #$00,(a0,d3.W,$30) == $00000d43 [00]
L000038ce           dc.W    $6000, $1c38                ; bra.w #$1c38 == $00005508 (T)
L000038d2           dc.W    $70e0                       ; moveq #$e0,d0
L000038d4           dc.W    $7038                       ; moveq #$38,d0
L000038d6           dc.W    $1c00                       ; move.b d0,d6
L000038d8           dc.W    $007c, $7c00                ; or.w #$7c00,sr
L000038dc           dc.W    $7c7c                       ; moveq #$7c,d6
L000038de           dc.W    $0000, $e070                ; or.b #$70,d0
L000038e2           dc.W    $381c                       ; move.w (a4)+,d4
L000038e4           dc.W    $3870, $e000                ; movea.w (a0,a6.W,$00) == $fffffa00 [0048],a4
L000038e8           dc.W    $7cee                       ; moveq #$ee,d6
L000038ea           dc.W    $ce3c, $3000                ; and.b #$00,d7
L000038ee           dc.W    $3000                       ; move.w d0,d0
L000038f0           dc.W    $003c, $4a56                ; or.b #$4a56,ccr
L000038f4           dc.W    $5e40                       ; addq.w #$07,d0
L000038f6           dc.W    $3c00                       ; move.w d0,d6
L000038f8           dc.W    $7ce6                       ; moveq #$e6,d6
L000038fa           dc.W    $e6fe                       ; illegal
L000038fc           dc.W    $e6e6                       ; ror.w -(a6)
L000038fe           dc.W    $e600                       ; asr.b #$03,d0
L00003900           dc.W    $fce6                       ; illegal
L00003902           dc.W    $e6fc                       ; illegal
L00003904           dc.W    $e6e6                       ; ror.w -(a6)
L00003906           dc.W    $fc00                       ; illegal
L00003908           dc.W    $7ce6                       ; moveq #$e6,d6
L0000390a           dc.W    $e6e0                       ; ror.w -(a0) [3000]
L0000390c           dc.W    $e6e6                       ; ror.w -(a6)
L0000390e           dc.W    $7c00                       ; moveq #$00,d6
L00003910           dc.W    $fce6                       ; illegal
L00003912           dc.W    $e6e6                       ; ror.w -(a6)
L00003914           dc.W    $e6e6                       ; ror.w -(a6)
L00003916           dc.W    $fc00                       ; illegal
L00003918           dc.W    $fee0                       ; illegal
L0000391a           dc.W    $e0fe                       ; illegal
L0000391c           dc.W    $e0e0                       ; asr.w -(a0) [3000]
L0000391e           dc.W    $fe00                       ; illegal
L00003920           dc.W    $fee0                       ; illegal
L00003922           dc.w    $e0fe                       ; illegal
L00003924           dc.w    $e0e0                       ; asr.w -(a0) [3000]
L00003926           dc.w    $e000                       ; asr.b #$08,d0
L00003928           dc.w    $7ce6                       ; moveq #$e6,d6
L0000392a           dc.w    $e6e0                       ; ror.w -(a0) [3000]
L0000392c           dc.w    $eee6                       ; illegal
L0000392e           dc.w    $7e00                       ; moveq #$00,d7
L00003930           dc.w    $e6e6                       ; ror.w -(a6)
L00003932           dc.w    $e6fe                       ; illegal
L00003934           dc.w    $e6e6                       ; ror.w -(a6)
L00003936           dc.w    $e600                       ; asr.b #$03,d0
L00003938           dc.w    $3838, $3838                ; move.w $3838 [381c],d4
L0000393c           dc.w    $3838, $3800                ; move.w $3800 [3624],d4
L00003940           dc.w    $0e0e                       ; illegal
L00003942           dc.w    $0e0e                       ; illegal
L00003944           dc.w    $0e0e                       ; illegal
L00003946           dc.w    $fc00                       ; illegal
L00003948           dc.w    $e6e6                       ; ror.w -(a6)
L0000394a           dc.w    $e4f8, $e4e6                ; roxr.w $e4e6 [2229]
L0000394e           dc.w    $e600                       ; asr.b #$03,d0
L00003950           dc.w    $e0e0                       ; asr.w -(a0) [3000]
L00003952           dc.w    $e0e0                       ; asr.w -(a0) [3000]
L00003954           dc.w    $e0e0                       ; asr.w -(a0) [3000]
L00003956           dc.w    $fe00                       ; illegal
L00003958           dc.w    $fcda                       ; illegal
L0000395a           dc.w    $dada                       ; adda.w (a2)+ [1241],a5
L0000395c           dc.w    $dada                       ; adda.w (a2)+ [1241],a5
L0000395e           dc.w    $da00                       ; add.b d0,d5
L00003960           dc.w    $fce6                       ; illegal
L00003962           dc.w    $e6e6                       ; ror.w -(a6)
L00003964           dc.w    $e6e6                       ; ror.w -(a6)
L00003966           dc.w    $e600                       ; asr.b #$03,d0
L00003968           dc.w    $7ce6                       ; moveq #$e6,d6
L0000396a           dc.w    $e6e6                       ; ror.w -(a6)
L0000396c           dc.w    $e6e6                       ; ror.w -(a6)
L0000396e           dc.w    $7c00                       ; moveq #$00,d6
L00003970           dc.w    $fce6                       ; illegal
L00003972           dc.w    $e6e6                       ; ror.w -(a6)
L00003974           dc.w    $fce0                       ; illegal
L00003976           dc.w    $e000                       ; asr.b #$08,d0
L00003978           dc.w    $7ce6                       ; moveq #$e6,d6
L0000397a           dc.w    $e6e2                       ; ror.w -(a2) [93f1]
L0000397c           dc.w    $ecee                       ; 7600 fce6 [ bfclr (a6,-$031a) == $00dfece6 {24:0} ]
L0000397e           dc.w    $7600                       ; moveq #$00,d3
L00003980           dc.w    $fce6                       ; illegal
L00003982           dc.w    $e6fc                       ; illegal
L00003984           dc.w    $e6e6                       ; ror.w -(a6)
L00003986           dc.w    $e600                       ; asr.b #$03,d0
L00003988           dc.w    $7ce6                       ; moveq #$e6,d6
L0000398a           dc.w    $f87c                       ; illegal
L0000398c           dc.w    $1ee6                       ; move.b -(a6),(a7)+ [60]
L0000398e           dc.w    $7c00                       ; moveq #$00,d6
L00003990           dc.w    $fe38                       ; illegal
L00003992           dc.w    $3838, $3838                ; move.w $3838 [381c],d4
L00003996           dc.w    $3800                       ; move.w d0,d4
L00003998           dc.w    $e6e6                       ; ror.w -(a6)
L0000399a           dc.w    $e6e6                       ; ror.w -(a6)
L0000399c           dc.w    $e6e6                       ; ror.w -(a6)
L0000399e           dc.w    $7c00                       ; moveq #$00,d6
L000039a0           dc.w    $e6e6                       ; ror.w -(a6)
L000039a2           dc.w    $e6e6                       ; ror.w -(a6)
L000039a4           dc.w    $e664                       ; asr.w d3,d4
L000039a6           dc.w    $3800                       ; move.w d0,d4
L000039a8           dc.w    $dada                       ; adda.w (a2)+ [1241],a5
L000039aa           dc.w    $dada                       ; adda.w (a2)+ [1241],a5
L000039ac           dc.w    $dada                       ; adda.w (a2)+ [1241],a5
L000039ae           dc.w    $7c00                       ; moveq #$00,d6
L000039b0           dc.w    $e6e6                       ; ror.w -(a6)
L000039b2           dc.w    $e638                       ; ror.b d3,d0
L000039b4           dc.w    $cece                       ; illegal
L000039b6           dc.w    $ce00                       ; and.b d0,d7
L000039b8           dc.w    $e6e6                       ; ror.w -(a6)
L000039ba           dc.w    $e67c                       ; ror.w d3,d4
L000039bc           dc.w    $3838, $3800                ; move.w $3800 [3624],d4
L000039c0           dc.w    $feee                       ; illegal
L000039c2           dc.w    $dc38, $76e6                ; add.b $76e6 [0e],d6
L000039c6           dc.w    $fe00                       ; illegal
L000039c8           dc.w    $0000, $0119                ; or.b #$19,d0
L000039cc           dc.w    $003a                       ; illegal
L000039ce           dc.w    $0097, $0000, $0000         ; or.l #$00000000,(a7) [6000001a]
L000039d4           dc.w    $0000, $0000                ; or.b #$00,d0
L000039d8           dc.w    $0000, $0000                ; or.b #$00,d0
L000039dc           dc.w    $0000, $0000                ; or.b #$00,d0
L000039e0           dc.w    $00a0, $0038, $0046         ; or.l #$00380046,-(a0) [4ef83000]
L000039e6           dc.w    $0000, $0000                ; or.b #$00,d0
L000039ea           dc.w    $0000, $0000                ; or.b #$00,d0
L000039ee           dc.w    $0000, $0000                ; or.b #$00,d0
L000039f2           dc.w    $0000, $0000                ; or.b #$00,d0
L000039f6           dc.w    $00a0, $0038, $0046         ; or.l #$00380046,-(a0) [4ef83000]
L000039fc           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a00           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a04           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a08           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a0c           dc.w    $00a0, $0038, $0046         ; or.l #$00380046,-(a0) [4ef83000]
L00003a12           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a16           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a1a           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a1e           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a22           dc.w    $00a0, $0038, $0046         ; or.l #$00380046,-(a0) [4ef83000]
L00003a28           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a2c           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a30           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a34           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a38           dc.w    $00a0, $0038, $0046         ; or.l #$00380046,-(a0) [4ef83000]
L00003a3e           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a42           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a46           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a4a           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a4e           dc.w    $00a0, $0038, $0046         ; or.l #$00380046,-(a0) [4ef83000]
L00003a54           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a58           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a5c           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a60           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a64           dc.w    $00a0, $0038, $0046         ; or.l #$00380046,-(a0) [4ef83000]
L00003a6a           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a6e           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a72           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a76           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a7a           dc.w    $00a0, $0038, $0046         ; or.l #$00380046,-(a0) [4ef83000]
L00003a80           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a84           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a88           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a8c           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a90           dc.w    $00a0, $0038, $0046         ; or.l #$00380046,-(a0) [4ef83000]
L00003a96           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a9a           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a9e           dc.w    $0000, $0000                ; or.b #$00,d0
L00003aa2           dc.w    $0000, $5009                ; or.b #$09,d0
L00003aa6           dc.w    $4158                       ; illegal
L00003aa8           dc.w    $4953                       ; illegal
L00003aaa           dc.w    $2043                       ; movea.l d3,a0
L00003aac           dc.w    $4845                       ; swap.w d5
L00003aae           dc.w    $4d49                       ; illegal
L00003ab0           dc.w    $4341                       ; illegal
L00003ab2           dc.w    $4c20                       ; 4641 [ mulu.l -(a0),d1:d4 ]
L00003ab4           dc.w    $4641                       ; not.w d1
L00003ab6           dc.w    $4354                       ; illegal
L00003ab8           dc.w    $4f52                       ; illegal
L00003aba           dc.w    $5900                       ; subq.b #$04,d0
L00003abc           dc.w    $ff40                       ; illegal
L00003abe           dc.w    $0e4a                       ; illegal
L00003ac0           dc.w    $4143                       ; illegal
L00003ac2           dc.w    $4b20                       ; [ chk.l -(a0),d5 ]
L00003ac4           dc.w    $4953                       ; illegal
L00003ac6           dc.w    $2044                       ; movea.l d4,a0
L00003ac8           dc.w    $4541                       ; illegal
L00003aca           dc.w    $4400                       ; neg.b d0
L00003acc           dc.w    $ff60                       ; illegal
L00003ace           dc.w    $0b54                       ; bchg.b d5,(a4)
L00003ad0           dc.w    $4845                       ; swap.w d5
L00003ad2           dc.w    $204a                       ; movea.l a2,a0
L00003ad4           dc.w    $4f4b                       ; illegal
L00003ad6           dc.w    $4552                       ; illegal
L00003ad8           dc.w    $204c                       ; movea.l a4,a0
L00003ada           dc.w    $4956                       ; illegal
L00003adc           dc.w    $4553                       ; illegal
L00003ade           dc.w    $2e2e, $2e00                ; move.l (a6,$2e00) == $00e01e00 [f09a4e75],d7
L00003ae2           dc.w    $ffb9                       ; illegal



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
L00003b20           bsr.w   L00003d40
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
L00003b84           addq.w #$06,a0                  ; addaq.w
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
L00003c88           movem.w L000067c2,d0-d1
L00003c8e           jsr     L00004c3e                   ; 4eb9 0000 4c3e (self modifying code $3c92)
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
L00003d70           addq.w  #$04,a0              ; addaq.w
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
L00003db8           addq.w  #$04,a0              ; addaq.w
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
L00003e6a           addq.w  #$06,a0                 ; addaq.w
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
L00003eb6           addq.w  #$02,a5             ; addaq.w
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
L00004058           move.w  #$0002,(a6)
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


L000044d4           dc.w    $e004                       ; asr.b #$08,d4
L000044d6           dc.w    $e005                       ; asr.b #$08,d5
L000044d8           dc.w    $e008                       ; lsr.b #$08,d0
L000044da           dc.w    $e010                       ; roxr.b #$08,d0
L000044dc           dc.w    $e011                       ; roxr.b #$08,d1
L000044de           dc.w    $0000, $e012                ; or.b #$12,d0
L000044e2           dc.w    $e011                       ; roxr.b #$08,d1
L000044e4           dc.w    $0000, $e013                ; or.b #$13,d0
L000044e8           dc.w    $e014                       ; roxr.b #$08,d4
L000044ea           dc.w    $e011                       ; roxr.b #$08,d1
L000044ec           dc.w    $e015                       ; roxr.b #$08,d5
L000044ee           dc.w    $e016                       ; roxr.b #$08,d6
L000044f0           dc.w    $e011                       ; roxr.b #$08,d1
L000044f2           dc.w    $0004, $0005                ; or.b #$05,d4
L000044f6           dc.w    $0008                       ; illegal
L000044f8           dc.w    $0010, $0011                ; or.b #$11,(a0) [00]
L000044fc           dc.w    $0000, $0012                ; or.b #$12,d0
L00004500           dc.w    $0011, $0000                ; or.b #$00,(a1) [04]
L00004504           dc.w    $0013, $0014                ; or.b #$14,(a3) [71]
L00004508           dc.w    $0011, $0015                ; or.b #$15,(a1) [04]
L0000450c           dc.w    $0016, $0011                ; or.b #$11,(a6)

L00004510           dc.w    $0010, $0011                ; or.b #$11,(a0) [00]
L00004514           dc.w    $0012, $0012                ; or.b #$12,(a2) [12]
L00004518           dc.w    $0008                       ; illegal
L0000451a           dc.w    $8006                       ; or.b d6,d0
L0000451c           dc.w    $e010                       ; roxr.b #$08,d0
L0000451e           dc.w    $e011                       ; roxr.b #$08,d1
L00004520           dc.w    $e012                       ; roxr.b #$08,d2
L00004522           dc.w    $0012, $fff8                ; or.b #$f8,(a2) [12]
L00004526           dc.w    $8007                       ; or.b d7,d0
L00004528           dc.w    $0017, $0018                ; or.b #$18,(a7) [60]
L0000452c           dc.w    $0019, $000e                ; or.b #$0e,(a1)+ [04]
L00004530           dc.w    $0008                       ; illegal
L00004532           dc.w    $8006                       ; or.b d6,d0
L00004534           dc.w    $e017                       ; roxr.b #$08,d7
L00004536           dc.w    $e018                       ; ror.b #$08,d0
L00004538           dc.w    $e019                       ; ror.b #$08,d1
L0000453a           dc.w    $000e                       ; illegal
L0000453c           dc.w    $fff8                       ; illegal
L0000453e           dc.w    $8007                       ; or.b d7,d0
L00004540           dc.w    $e013                       ; roxr.b #$08,d3
L00004542           dc.w    $e014                       ; roxr.b #$08,d4
L00004544           dc.w    $e012                       ; roxr.b #$08,d2
L00004546           dc.w    $0012, $fffd                ; or.b #$fd,(a2) [12]
L0000454a           dc.w    $800b                       ; illegal
L0000454c           dc.w    $0013, $0014                ; or.b #$14,(a3) [71]
L00004550           dc.w    $0012, $0012                ; or.b #$12,(a2) [12]
L00004554           dc.w    $0003, $800a                ; or.b #$0a,d3
L00004558           dc.w    $e015                       ; roxr.b #$08,d5
L0000455a           dc.w    $e016                       ; roxr.b #$08,d6
L0000455c           dc.w    $e012                       ; roxr.b #$08,d2
L0000455e           dc.w    $000c                       ; illegal
L00004560           dc.w    $fffb                       ; illegal
L00004562           dc.w    $8009                       ; illegal
L00004564           dc.w    $0015, $0016                ; or.b #$16,(a5)
L00004568           dc.w    $0012, $000c                ; or.b #$0c,(a2) [12]
L0000456c           dc.w    $0005, $8008                ; or.b #$08,d5



L00004570           move.w  $000a(a6),d2        ; $00dff00a
L00004574           mulu.w  #$000c,d2
L00004578           lea.l   (pc,d2.W),a5        ; $00004510
L0000457c           move.w  (a5)+,d2
L0000457e           bsr.b   L0000458a
L00004580           move.w  (a5)+,d2
L00004582           bsr.b   L000045bc
L00004584           move.w  (a5)+,d2
L00004586           bne.b   L000045bc
L00004588           rts 



L0000458a           add.w   $0006(a6),d2        ; $00dff006
L0000458e           move.w  d2,d3
L00004590           and.w   #$1fff,d3
L00004594           lsl.w   #$01,d3
L00004596           lea.l   L0000607c,a0
L0000459a           move.w  d1,d4
L0000459c           add.w   d4,d4
L0000459e           move.b  $fe(a0,d3.W),d5     ; $00000d11
L000045a2           ext.w   d5
L000045a4           sub.w   d5,d4
L000045a6           asr.w   #$01,d4
L000045a8           movem.w d0-d1/d4,$000e(a6)  ; $00dff00e
L000045ae           movem.w d0-d1/a5-a6,-(a7)
L000045b2           bsr.w   L000056f4
L000045b6           movem.w (a7)+,d0-d1/a5-a6
L000045ba           rts 


L000045bc           add.w   $0006(a6),d2        ; $00dff006
L000045c0           movem.w d0-d1/a5-a6,-(a7)
L000045c4           bsr.w   L000056f4
L000045c8           movem.w (a7)+,d0-d1/a5-a6
L000045cc           rts 


L000045ce           move.w  $000a(a6),d2            ; $00dff00a
L000045d2           addq.w  #$01,d2
L000045d4           cmp.w   #$000e,d2
L000045d8           bpl.b   L000045de
L000045da           move.w  d2,$000a(a6)            ; $00dff00a
L000045de           asr.w   #$01,d2
L000045e0           add.w   d2,$0004(a6)            ;$00dff004
L000045e4           lea.l   L000062de,a5
L000045e8           cmp.w   #$0064,d1
L000045ec           bmi.w   L0000457c
L000045f0           clr.w   (a6)
L000045f2           move.l  #$00000350,d0
L000045f8           jmp     $0007c82a               ; External Address - Panel


L000045fe           lea.l   L00004866,a5
L00004602           lea.l   L00004894,a6
L00004606           moveq   #$13,d7
L00004608           move.w  (a6)+,d2
L0000460a           beq.b   L00004636
L0000460c           movem.w (a6),d0-d1
L00004610           move.l  a6,-(a7)
L00004612           move.w  d7,-(a7)
L00004614           btst.l  #$000f,d2
L00004618           beq.b   L00004622
L0000461a           ext.w   d2
L0000461c           move.w  d2,-$0002(a6)
L00004620           moveq   #$04,d2
L00004622           ror.w   #$01,d2
L00004624           bpl.b   L0000462a
L00004626           or.w    #$e000,d2
L0000462a           add.w   #$003b,d2
L0000462e           bsr.w   L000056f4
L00004632           move.w  (a7)+,d7
L00004634           movea.l (a7)+,a6
L00004636           addq.w  #$06,a6             ; addaq.w
L00004638           dbf.w   d7,L00004608
L0000463c           rts


L0000463e           lea.l   L00004894,a0
L00004642           moveq   #$13,d7
L00004644           tst.w   (a0)
L00004646           beq.b   L00004656
L00004648           lea.l   $0008(a0),a0        ; $00000a08
L0000464c           dbf.w   d7,L00004644
L00004650           movea.l #$fffffff8,a0
L00004656           rts


L00004658           lea.l   L00004866,a5
L0000465c           lea.l   L00004894,a6
L00004660           moveq   #$13,d7
L00004662           move.w  (a6)+,d6
L00004664           beq.b   L0000467e
L00004666           movem.w (a6),d0-d1
L0000466a           sub.w   L0000630e,d0
L0000466e           sub.w   L00006310,d1
L00004672           asl.w   #$01,d6
L00004674           clr.l   d2
L00004676           movea.l d2,a0
L00004678           movea.w $fe(a5,d6.W),a0
L0000467c           jsr     (a0)
L0000467e           addq.w  #$06,a6                 ; addaq.w
L00004680           dbf.w d7,L00004662
L00004684           rts


L00004686           movem.w d0-d1,(a6)
L0000468a           bsr.w   L000055a0
L0000468e           cmp.b   #$17,d2
L00004692           bcs.b   L000046ba
L00004694           sub.w   L000067c2,d0
L00004698           addq.w  #$04,d0
L0000469a           cmp.w   #$0009,d0
L0000469e           bcc.b   L000046c0
L000046a0           cmp.w   L000067c4,d1
L000046a4           bpl.b   L000046c0
L000046a6           cmp.w   L000062f0,d1
L000046aa           bmi.b   L000046c0
L000046ac           moveq   #$01,d6
L000046ae           bsr.w   L00004ccc
L000046b2           moveq   #$0a,d0
L000046b4           jsr     $00048014           ; External Address
L000046ba           move.w  #$0004,-$0002(a6)   
L000046c0           rts


L000046c2           subq.w  #$03,d0
L000046c4           cmp.w   #$fff6,d0
L000046c8           bmi.b   L00004722
L000046ca           subq.w  #$03,d1
L000046cc           cmp.w   #$0058,d1
L000046d0           bcs.b   L00004686
L000046d2           bra.b   L00004722
L000046d4           addq.w  #$03,d0
L000046d6           cmp.w   #$00a8,d0
L000046da           bpl.b   L00004722
L000046dc           subq.w  #$03,d1
L000046de           cmp.w   #$0058,d1
L000046e2           bcs.b   L00004686
L000046e4           bra.b   L00004722
L000046e6           subq.w  #$03,d0
L000046e8           cmp.w   #$fff6,d0
L000046ec           bmi.b   L00004722
L000046ee           addq.w  #$03,d1
L000046f0           cmp.w   #$0058,d1
L000046f4           bcs.b   L00004686
L000046f6           bra.b   L00004722
L000046f8           addq.w  #$03,d0
L000046fa           cmp.w   #$00a8,d0
L000046fe           bpl.b   L00004722
L00004700           addq.w  #$03,d1
L00004702           cmp.w   #$0058,d1
L00004706           bcs.w   L00004686
L0000470a           bra.b   L00004722
L0000470c           subq.w  #$05,d0
L0000470e           cmp.w   #$fff6,d0
L00004712           bpl.w   L00004686
L00004716           bra.b   L00004722
L00004718           addq.w  #$05,d0
L0000471a           cmp.w   #$00a8,d0
L0000471e           bmi.w   L00004686
L00004722           clr.w   -$0002(a6)
L00004726           rts


L00004728           addq.w  #$04,d0
L0000472a           cmp.w   #$00a8,d0
L0000472e           bpl.b   L00004722
L00004730           bsr.w   L000055a0
L00004734           cmp.b   #$17,d2
L00004738           movem.w d0-d1,(a6)
L0000473c           bcc.b   L0000477e
L0000473e           bcs.b   L00004722
L00004740           subq.w  #$04,d0
L00004742           cmp.w   #$fff6,d0
L00004746           bmi.b   L00004722
L00004748           bsr.w   L000055a0
L0000474c           cmp.b   #$17,d2
L00004750           movem.w d0-d1,(a6)
L00004754           bcc.b   L0000477e
L00004756           bra.b   L00004722
L00004758           move.w  L00006318,d0
L0000475c           beq.b   L00004722
L0000475e           movem.w L000067c2,d0-d1
L00004764           add.w   L0000631a,d0
L00004768           sub.w   L0000631c,d1
L0000476c           sub.w   #$000c,d1
L00004770           addq.w  #$05,d0
L00004772           tst.w   L000062ee
L00004776           bpl.b   L0000477a
L00004778           subq.w  #$07,d0
L0000477a           movem.w d0-d1,(a6)
L0000477e           lea.l   L00003a8e,a4
L00004782           moveq   #$09,d6
L00004784           move.w  (a4),d2
L00004786           subq.w  #$02,d2
L00004788           bmi.b   L000047a4
L0000478a           move.w  $000e(a4),d2
L0000478e           sub.w   d0,d2
L00004790           addq.w  #$04,d2
L00004792           cmp.w   #$0008,d2
L00004796           bcc.b   L000047a4
L00004798           cmp.w   $0010(a4),d1
L0000479c           bpl.b   L000047a4
L0000479e           cmp.w   $0012(a4),d1
L000047a2           bpl.b   L000047ae
L000047a4           lea.l   -$0016(a4),a4
L000047a8           dbf.w   d6,L00004784
L000047ac           rts



L000047ae           move.w  #$0001,(a4)
L000047b2           move.w  #$fffc,$000a(a4)
L000047b8           bsr.w   L00004722
L000047bc           moveq   #$0a,d0
L000047be           jmp     $00048014           ; External Address
L000047c4           addq.w  #$02,d0
L000047c6           move.w  $0004(a6),d2
L000047ca           cmp.w   #$0028,d2
L000047ce           bpl.b   L000047d4
L000047d0           addq.w  #$01,$0004(a6)
L000047d4           asr.w   #$02,d2
L000047d6           bpl.b   L000047da
L000047d8           addq.w  #$01,d2
L000047da           add.w   d2,d1
L000047dc           cmp.w   #$0060,d1
L000047e0           bpl.w   L00004722
L000047e4           movem.w d0-d1,(a6)
L000047e8           bsr.w   L000055a0
L000047ec           cmp.b   #$17,d2
L000047f0           bcs.b   L00004814
L000047f2           sub.w   L000067c2,d0
L000047f6           addq.w  #$03,d0
L000047f8           cmp.w   #$0007,d0
L000047fc           bcc.b   L00004820
L000047fe           cmp.w   L000067c4,d1
L00004802           bpl.b   L00004820
L00004804           cmp.w   L000062f0,d1
L00004808           bmi.b   L00004820
L0000480a           moveq   #$06,d6
L0000480c           bsr.w   L00004ccc
L00004810           movem.w (a6),d0-d1
L00004814           move.w  #$000e,-$0002(a6)
L0000481a           moveq   #$0d,d2
L0000481c           bra.w   L000044b6
L00004820           rts



L00004822           subq.w  #$02,d0
L00004824           move.w  $0004(a6),d2
L00004828           cmp.w   #$0028,d2
L0000482c           bpl.b   L00004832
L0000482e           addq.w  #$01,$0004(a6)
L00004832           asr.w   #$02,d2
L00004834           bpl.b   L00004838
L00004836           addq.w  #$01,d2
L00004838           add.w   d2,d1
L0000483a           cmp.w   #$0060,d1
L0000483e           bpl.w   L00004722
L00004842           bra.b   L000047e4
L00004844           movem.w d0-d1,(a6)
L00004848           btst.b  #$0000,L0000632d
L0000484e           bne.b   L00004864
L00004850           move.w  -$0002(a6),d2
L00004854           addq.w  #$01,d2
L00004856           cmp.w   #$0018,d2
L0000485a           bne.w   L00004860
L0000485e           clr.w   d2
L00004860           move.w  d2,-$0002(a6)
L00004864           rts



L00004866           dc.w    $4758                       ; illegal
L00004868           dc.w    $4728, $4740                ; [ chk.l (a0,$4740) == $00005140,d3 ]
L0000486a           dc.w    $4740                       ; illegal
L0000486c           dc.w    $4722                       ; [ chk.l -(a2),d3 ]
L0000486e           dc.w    $4722                       ; [ chk.l -(a2),d3 ]
L00004870           dc.w    $4718                       ; [ chk.l (a0)+,d3 ]
L00004872           dc.w    $470c                       ; illegal
L00004874           dc.w    $46f8, $46e6                ; move.w $46e6,sr
L00004878           dc.w    $46d4                       ; move.w (a4),sr
L0000487a           dc.w    $46c2                       ; move.w d2,sr
L0000487c           dc.w    $47c4                       ; illegal
L0000487e           dc.w    $4822                       ; nbcd.b -(a2)
L00004880           dc.w    $4844                       ; swap.w d4
L00004882           dc.w    $4844                       ; swap.w d4
L00004884           dc.w    $4844                       ; swap.w d4
L00004886           dc.w    $4844                       ; swap.w d4
L00004888           dc.w    $4844                       ; swap.w d4
L0000488a           dc.w    $4844                       ; swap.w d4
L0000488c           dc.w    $4844                       ; swap.w d4
L0000488e           dc.w    $4844                       ; swap.w d4
L00004890           dc.w    $4844                       ; swap.w d4
L00004892           dc.w    $4844                       ; swap.w d4
L00004894           dc.w    $0000, $0000                ; or.b #$00,d0
L00004898           dc.w    $0000, $0000                ; or.b #$00,d0
L0000489c           dc.w    $0000, $0000                ; or.b #$00,d0
L000048a0           dc.w    $0000, $0000                ; or.b #$00,d0
L000048a4           dc.w    $0000, $0000                ; or.b #$00,d0
L000048a8           dc.w    $0000, $0000                ; or.b #$00,d0
L000048ac           dc.w    $0000, $0000                ; or.b #$00,d0
L000048b0           dc.w    $0000, $0000                ; or.b #$00,d0
L000048b4           dc.w    $0000, $0000                ; or.b #$00,d0
L000048b8           dc.w    $0000, $0000                ; or.b #$00,d0
L000048bc           dc.w    $0000, $0000                ; or.b #$00,d0
L000048c0           dc.w    $0000, $0000                ; or.b #$00,d0
L000048c4           dc.w    $0000, $0000                ; or.b #$00,d0
L000048c8           dc.w    $0000, $0000                ; or.b #$00,d0
L000048cc           dc.w    $0000, $0000                ; or.b #$00,d0
L000048d0           dc.w    $0000, $0000                ; or.b #$00,d0
L000048d4           dc.w    $0000, $0000                ; or.b #$00,d0
L000048d8           dc.w    $0000, $0000                ; or.b #$00,d0
L000048dc           dc.w    $0000, $0000                ; or.b #$00,d0
L000048e0           dc.w    $0000, $0000                ; or.b #$00,d0
L000048e4           dc.w    $0000, $0000                ; or.b #$00,d0
L000048e8           dc.w    $0000, $0000                ; or.b #$00,d0
L000048ec           dc.w    $0000, $0000                ; or.b #$00,d0
L000048f0           dc.w    $0000, $0000                ; or.b #$00,d0
L000048f4           dc.w    $0000, $0000                ; or.b #$00,d0
L000048f8           dc.w    $0000, $0000                ; or.b #$00,d0
L000048fc           dc.w    $0000, $0000                ; or.b #$00,d0
L00004900           dc.w    $0000, $0000                ; or.b #$00,d0
L00004904           dc.w    $0000, $0000                ; or.b #$00,d0
L00004908           dc.w    $0000, $0000                ; or.b #$00,d0
L0000490c           dc.w    $0000, $0000                ; or.b #$00,d0
L00004910           dc.w    $0000, $0000                ; or.b #$00,d0
L00004914           dc.w    $0000, $0000                ; or.b #$00,d0
L00004918           dc.w    $0000, $0000                ; or.b #$00,d0
L0000491c           dc.w    $0000, $0000                ; or.b #$00,d0
L00004920           dc.w    $0000, $0000                ; or.b #$00,d0
L00004924           dc.w    $0000, $0000                ; or.b #$00,d0
L00004928           dc.w    $0000, $0000                ; or.b #$00,d0
L0000492c           dc.w    $0000, $0000                ; or.b #$00,d0
L00004930           dc.w    $0000, $0000                ; or.b #$00,d0
L00004934           dc.w    $0000                       ; 4cb8 or.b #$b8,d0



L00004936           movem.w L000067c4,D1-D2
L0000493c           move.w  d1,d0
L0000493e           sub.w   d2,d0
L00004940           move.w  L00006310,L00004934
L00004946           move.w  d0,L00006310
L0000494a           beq.w   L000049ec
L0000494e           tst.w   L000062fa
L00004952           bmi.b   L0000496c
L00004954           beq.b   L00004980
L00004956           cmp.w   #$0004,d0
L0000495a           bcs.b   L00004980
L0000495c           cmp.w   #$fffd,d0
L00004960           bcc.b   L00004980
L00004962           bpl.b   L00004968
L00004964           moveq   #$fe,d0
L00004966           bra.b   L00004980
L00004968           moveq   #$02,d0
L0000496a           bra.b   L00004980
L0000496c           cmp.w   #$0008,d0
L00004970           bcs.b   L00004980
L00004972           cmp.w   #$fffd,d0
L00004976           bcc.b   L00004980
L00004978           bmi.b   L0000497e
L0000497a           moveq   #$07,d0
L0000497c           bra.b   L00004980
L0000497e           moveq   #$fd,d0
L00004980           move.w  L000067be,d1
L00004984           move.w  d1,d3
L00004986           add.w   d0,d1
L00004988           cmp.w   #$00f1,d1
L0000498c           bcs.b   L000049a0
L0000498e           bmi.b   L0000499c
L00004990           move.w  #$00f0,d2
L00004994           sub.w   d2,d1
L00004996           sub.w   d1,d0
L00004998           move.w  d2,d1
L0000499a           bra.b   L000049a0
L0000499c           sub.w   d1,d0
L0000499e           clr.w   d1
L000049a0           sub.w   d0,L000067c4
L000049a4           move.w  d1,L000067be
L000049a8           sub.w   d3,d1
L000049aa           move.w  d1,L00006310
L000049ae           beq.b   L000049ec
L000049b0           bmi.b   L000049d4
L000049b2           add.w   #$0057,d3
L000049b6           move.w  L00006312,d2
L000049ba           move.w  d1,d4
L000049bc           add.w   d2,d4
L000049be           cmp.w   #$0057,d4
L000049c2           bcs.b   L000049c8
L000049c4           sub.w   #$0057,d4
L000049c8           move.w  d4,L00006312
L000049cc           bsr.w   L00004a5e
L000049d0           bra.w   L000049ec
L000049d4           move.w  L00006312,d2
L000049d8           add.w   d1,d2
L000049da           bpl.b   L000049e0
L000049dc           add.w   #$0057,d2
L000049e0           move.w  d2,L00006312
L000049e4           add.w   d1,d3
L000049e6           neg.w   d1
L000049e8           bsr.w   L00004a5e
L000049ec           move.w  L000067c2,d0
L000049f0           sub.w   L000067c8,d0
L000049f4           move.w  d0,L0000630e
L000049f8           beq.w   L00004a5c
L000049fc           move.w  L000067bc,d1
L00004a00           move.w  d1,d2
L00004a02           add.w   d0,d1
L00004a04           bpl.b   L00004a0c
L00004a06           move.w  d1,d0
L00004a08           clr.w   d1
L00004a0a           bra.b   L00004a1c
L00004a0c           clr.w   d0
L00004a0e           cmp.w   #$0540,d1
L00004a12           bls.b   L00004a1c
L00004a14           move.w  #$0540,d0
L00004a18           sub.w   d0,d1
L00004a1a           exg.l   d1,d0
L00004a1c           add.w   L000067c8,d0
L00004a20           move.w  d0,L000067c2 
L00004a24           move.w  d1,L000067bc 
L00004a28           move.w  d1,d3
L00004a2a           sub.w   d2,d3
L00004a2c           move.w  d3,L0000630e
L00004a30           beq.b   L00004a5c
L00004a32           eor.w   d1,d2
L00004a34           btst.l  #$0003,d2
L00004a38           beq.b   L00004a5c
L00004a3a           movea.l L0000631e,a4
L00004a3e           tst.w   d3
L00004a40           bmi.b   L00004a52
L00004a42           add.w   #$00a0,d1
L00004a46           addq.w  #$02,a4             ; addaq.w
L00004a48           move.l  a4,L0000631e
L00004a4c           lea.l   $0028(a4),a4
L00004a50           bra.b   L00004a58
L00004a52           subq.w  #$02,a4             ; subaq.w
L00004a54           move.l  a4,L0000631e
L00004a58           bsr.w   L00004ad6
L00004a5c           rts  



L00004a5e           subq.w  #$01,d1
L00004a60           move.w  d3,d4
L00004a62           and.w   #$0007,d4
L00004a66           asl.w   #$04,d4
L00004a68           move.b  d4,L00004aa1
L00004a6e           move.w  d3,d4
L00004a70           lsr.w   #$03,d4
L00004a72           lea.l   $00008002,a0            ; External Address
L00004a78           mulu.w  (a0),d4
L00004a7a           move.w  L000067bc,d0
L00004a7e           lsr.w   #$03,d0
L00004a80           add.w   d0,d4
L00004a82           lea.l   $7a(a0,d4.W),a0
L00004a86           move.w  d2,d4
L00004a88           mulu.w  #$0054,d4
L00004a8c           add.l   L0000631e,d4
L00004a90           movea.l d4,a1
L00004a92           moveq   #$14,d7
L00004a94           movea.l L0000630a,a2            ; [0000a07c]
L00004a98           clr.w   d0
L00004a9a           move.b  (a0)+,d0
L00004a9c           asl.w   #$07,d0
L00004a9e           lea.l   $00(a2,d0.W),a3         ; $0006b778,a3
L00004aa2           move.w  (a3)+,(a1)+
L00004aa4           move.w  (a3)+,$1c8a(a1)         ; $00041be4 [8012]
L00004aa8           move.w  (a3)+,$3916(a1)         ; $00043870 [1080]
L00004aac           move.w  (a3)+,$55a2(a1)         ; $000454fc [7868]
L00004ab0           move.w  (a3)+,$0028(a1)         ; $0003ff82 [0000]
L00004ab4           move.w  (a3)+,$1cb4(a1)         ; $00041c0e [02c0]
L00004ab8           move.w  (a3)+,$3940(a1)         ; $0004389a [0001]
L00004abc           move.w  (a3)+,$55cc(a1)         ; $00045526 [00e0]
L00004ac0           dbf.w   d7,L00004a98
L00004ac4           addq.w  #$01,d3
L00004ac6           addq.w  #$01,d2
L00004ac8           cmp.w   #$0057,d2
L00004acc           bcs.b   L00004ad0
L00004ace           clr.w   d2
L00004ad0           dbf.w   d1,L00004a60
L00004ad4           rts 


L00004ad6           movea.l L000630a,a2         ; [0000a07c]
L00004ada           move.w  d1,d2
L00004adc           lsr.w   #$03,d2
L00004ade           move.w  L000067be,d1        ; [00f0]
L00004ae2           move.w  d1,d0
L00004ae4           and.w   #$0007,d0
L00004ae8           move.w  d0,d5
L00004aea           not.w   d5
L00004aec           and.w   #$0007,d5
L00004af0           lsl.w   #$04,d0
L00004af2           lsr.w   #$03,d1
L00004af4           lea.l   $00008002,a0        ; External Address
L00004afa           move.w  (a0),d4
L00004afc           mulu.w  d4,d1
L00004afe           add.w   d2,d1
L00004b00           lea.l   $7a(a0,d1.W),a0     ; $00000a79,a0
L00004b04           moveq   #$56,d7
L00004b06           move.w  L00006312,d1
L00004b0a           moveq   #$56,d6
L00004b0c           sub.w   d1,d6
L00004b0e           mulu.w  #$0054,d1
L00004b12           lea.l   $00(a4,d1.L),a1     
L00004b16           clr.w   d1
L00004b18           move.b  (a0),d1
L00004b1a           asl.w   #$07,d1
L00004b1c           add.w   d1,d0
L00004b1e           bra.b   L00004b2c
L00004b20           dbf.w   d5,L00004b32
L00004b24           moveq   #$07,d5
L00004b26           clr.w   d0
L00004b28           move.b  (a0),d0
L00004b2a           asl.w   #$07,d0
L00004b2c           lea.l   $00(a2,d0.W),a3     ; $0006b778,a3
L00004b30           adda.w  d4,a0
L00004b32           move.w  (a3)+,(a1)
L00004b34           move.w  (a3)+,$1c8c(a1)      ; $00041be6 [02c0]
L00004b38           move.w  (a3)+,$3918(a1)      ; $00043872 [0101]
L00004b3c           move.w  (a3)+,$55a4(a1)      ; $000454fe [00e0]
L00004b40           move.w  (a3)+,$002a(a1)      ; $0003ff84 [0000]
L00004b44           move.w  (a3)+,$1cb6(a1)      ; $00041c10 [0038]
L00004b48           move.w  (a3)+,$3942(a1)      ; $0004389c [8000]
L00004b4c           move.w  (a3)+,$55ce(a1)      ; $00045528 [00f7]
L00004b50           lea.l   $0054(a1),a1
L00004b54           dbf.w   d6,L00004b5c
L00004b58           lea.l   -$1c8c(a1),a1       ; $0003e2ce,a1
L00004b5c           dbf.w   d7,L00004b20
L00004b60           rts 



L00004b62           move.w  #$8400,$00dff096
L00004b6a           movea.l L000036f6,a6        ;  [00061b9c]
L00004b6e           subq.w #$02,a6              ; subaq.w
L00004b70           movea.l L0000631e,a5        ; [0005a36c]
L00004b74           move.w  L00006312,d1
L00004b78           clr.l   d6
L00004b7a           subq.w  #$01,d6
L00004b7c           swap.w  d6
L00004b7e           move.w  L000067bc,d2
L00004b82           and.w   #$0007,d2
L00004b86           beq.b   L00004b8c
L00004b88           ror.l   d2,d6
L00004b8a           ror.l   d2,d6
L00004b8c           neg.w   d2
L00004b8e           ror.w   #$03,d2
L00004b90           and.l   #$0000e000,d2
L00004b96           bne.b   L00004b9a
L00004b98           addq.w #$02,a6              ; addaq.w
L00004b9a           or.w    #$09f0,d2
L00004b9e           swap.w  d2
L00004ba0           move.w  d1,d4
L00004ba2           mulu.w  #$0054,d4
L00004ba6           lea.l   $00(a5,d4.L),a1
L00004baa           movea.l a6,a0
L00004bac           moveq   #$28,d3
L00004bae           move.w  #$00ae,d4
L00004bb2           sub.w   d1,d4
L00004bb4           sub.w   d1,d4
L00004bb6           bsr.w   L00004bde
L00004bba           move.w  d1,d4
L00004bbc           beq.b   L00004bd4
L00004bbe           moveq   #$57,d3
L00004bc0           sub.w   d4,d3
L00004bc2           mulu.w  #$0054,d3
L00004bc6           lea.l   $00(a6,d3.L),a0
L00004bca           add.w   d4,d4
L00004bcc           moveq   #$28,d3
L00004bce           lea.l   (a5),a1
L00004bd0           bsr.w   L00004bde
L00004bd4           move.w  #$0400,$00dff096
L00004bdc           rts  



L00004bde           move.l  d2,d5
L00004be0           swap.w  d5
L00004be2           and.w   #$e000,d5
L00004be6           addq.w  #$02,d3
L00004be8           asl.w   #$06,d4
L00004bea           move.w  d3,d5
L00004bec           lsr.w   #$01,d5
L00004bee           add.w   d5,d4
L00004bf0           sub.w   #$002a,d3
L00004bf4           neg.w   d3
L00004bf6           lea.l   $00dff000,a4
L00004bfc           move.l  #$00001c8c,d5               
L00004c02           btst.b  #$0006,$00dff002
L00004c0a           bne.b   L00004c02
L00004c0c           move.l  d6,$0044(a4)
L00004c10           move.w  d3,$0064(a4)
L00004c14           move.w  d3,$0066(a4)
L00004c18           move.l  d2,$0040(a4)
L00004c1c           moveq   #$03,d7
L00004c1e           btst.b  #$0006,$00dff002
L00004c26           bne.b   L00004c1e
L00004c28           move.l  a1,$0050(a4)        ; $00bfe151
L00004c2c           move.l  a0,$0054(a4)        ; $00bfe155
L00004c30           move.w  d4,$0058(a4)        ; $00bfe159
L00004c34           adda.l  d5,a1
L00004c36           adda.l  d5,a0
L00004c38           dbf.w   d7,L00004c1e
L00004c3c           rts  



L00004c3e           clr.w   d2
L00004c40           move.b  L00006308,d2
L00004c44           asl.w   #$02,d2
L00004c46           movea.l (pc,d2.W),a0        ; $04=$00004c4c
L00004c4a           jmp (a0)


; Jump Table (for above)
L00004c4c           dc.l    $00005290                   ; rts
L00004c50           dc.l    $00005246                   ; CMD1
L00004c54           dc.l    $0000529c                   ; CMD2
L00004c58           dc.l    $00005290                   ; rts
L00004c5c           dc.l    $000053f4                   ; CMD3
L00004c60           dc.l    $00005240                   ; CMD4
L00004c64           dc.l    $00005292                   ; CMD5
L00004c68           dc.l    $00005290                   ; rts
L00004c6c           dc.l    $00005202                   ; CMD6
L00004c70           dc.l    $00005244                   ; CMD7
L00004c74           dc.l    $00005298                   ; CMD8
L00004c78           dc.l    $00005290                   ; rts
L00004c7c           dc.l    $00005290                   ; rts
L00004c80           dc.l    $00005290                   ; rts
L00004c84           dc.l    $00005290                   ; rts
L00004c88           dc.l    $00005290                   ; rts
L00004c8c           dc.l    $00004fe0                   ; CMD9 
L00004c90           dc.l    $00004fe0                   ; CMD9 
L00004c94           dc.l    $00004fe0                   ; CMD9 
L00004c98           dc.l    $00004fe0                   ; CMD9 
L00004c9c           dc.l    $000053d6                   ; CMD10
L00004ca0           dc.l    $000053d6                   ; CMD10
L00004ca4           dc.l    $000053d6                   ; CMD10
L00004ca8           dc.l    $000053d6                   ; CMD10
L00004cac           dc.l    $000050f8                   ; CMD11
L00004cb0           dc.l    $000050e6                   ; CMD12
L00004cb4           dc.l    $000050ee                   ; CMD13
L00004cb8           dc.l    $00005290                   ; rts
L00004cbc           dc.l    $00005290                   ; rts
L00004cc0           dc.l    $00005290                   ; rts
L00004cc4           dc.l    $00005290                   ; rts
L00004cc8           dc.l    $00005290                   ; rts



L0004cccc           tst.b   $0007c874                   ; External Address - Panel
L00004cd2           bne.b   L00004d36
L00004cd4           movem.l d0-d7/a5-a6,-(a7)
L00004cd8           move.w  d6,d0
L00004cda           jsr     $0007c870                   ; External Address - Panel
L00004ce0           movem.l (a7)+,d0-d7/a5-a6
L00004ce4           move.w  L00003c92,d2
L00004ce8           cmp.w   #$5482,d2
L00004cec           beq.b   L00004d36
L00004cee           move.w  #$4e3a,d3
L00004cf2           cmp.w   d3,d2
L00004cf4           beq.b   L00004d1c
L00004cf6           cmp.w   #$4e64,d2
L00004cfa           beq.b   L00004d1c
L00004cfc           cmp.w   #$5058,d2
L00004d00           beq.b   L00004d38
L00004d02           move.w  #$4d48,d3
L00004d06           cmp.w   #$5308,d2
L00004d0a           beq.b   L00004d1c
L00004d0c           cmp.w   d2,d3
L00004d0e           beq.b   L00004d1c
L00004d10           lea.l   L00005457,a0
L00004d14           bsr.w   L00005438
L00004d18           move.w  #$4d56,d3
L00004d1c           move.w  d3,L00003c92 
L00004d20           move.w  L00006306,d2
L00004d24           add.w   d6,d6
L00004d26           add.w   d6,d6
L00004d28           add.w   d6,d2
L00004d2a           cmp.w   #$000c,d2
L00004d2e           bcs.b   L00004d32
L00004d30           moveq   #$0c,d2
L00004d32           move.w  d2,L00006306
L00004d36           rts 


L00004d38           move.w  L000062f2,d2
L00004d3c           add.w   d6,d2
L00004d3e           add.w   d6,d2
L00004d40           add.w   d6,d2
L00004d42           move.w  d2,L000062f2
L00004d46           rts 


L00004d48           subq.w  #$01,L00006306
L00004d4c           bne.b   L00004d36
L00004d4e           move.w  #$5308,L00003c92
L00004d54           bra.b   L00004d7a
L00004d56           tst.w   L00006318
L00004d5a           beq.b   L00004d60
L00004d5c           bsr.w   L000051b0
L00004d60           subq.w  #$01,L00006306
L00004d64           bne.b   L00004d36
L00004d66           move.w  #$4c3e,L00003c92
L00004d6c           tst.w   L00006318
L00004d70           beq.b   L00004d76
L00004d72           bsr.w   L000051a8
L00004d76           bsr.w   L00005430
L00004d7a           tst.b   $0007c874           ; External Address - Panel
L00004d80           beq.b   L00004d36
L00004d82           jsr     $00048004
L00004d88           clr.w   L00006318
L00004d8c           moveq   #$03,d0
L00004d8e           jsr     $00048010           ; External Address
L00004d94           move.w  #$4da2,L00003c92
L00004d9a           move.w  #$63dc,L00006326
L00004da0           rts 


L00004da2            movea.w L00006326,a0
L00004da6            bsr.w   L00005438
L00004daa            move.w  a0,L00006326
L00004dae            tst.b   (a0)
L00004db0            bne.b   L00004d36
L00004db2            jsr     $0004800c           ; External Address
L00004db8            move.w  #$0032,d0
L00004dbc            bsr.w   L00005e8c
L00004dc0            bsr.w   L00004e28
L00004dc4            btst.b  #$0000,$0007c874    ; External Address - Panel
L00004dcc            beq.b   L00004dd6
L00004dce            lea.l   L00004e1c,a0
L00004dd2            bsr.w   L000067ca
L00004dd6            btst.b  #$0001,L0007c874    ; External Address - Panel
L00004dde            beq.b   L00004de8
L00004de0            lea.l   L00004e0e,a0
L00004de4            bsr.w   L000067ca
L00004de8            bsr.w   L00003cc0
L00004dec            move.w  #$001e,d0
L00004df0            bsr.w   L00005e8c
L00004df4            btst.b  #$0001,$0007c874    ; External Address - Panel
L00004dfc            beq.w   L00003b02
L00004e00            jsr     $00048004           ; External Address
L00004e06            bsr.w   L00003d8c
L00004e0a            bra.w   $00000820           ; **** LOADER ****


L00004e0e            dc.w    $5f0f                       ; illegal
L00004e10            dc.w    $4741                       ; illegal
L00004e12            dc.w    $4d45                       ; illegal
L00004e14            dc.w    $2020                       ; move.l -(a0) [4ef83000],d0
L00004e16            dc.w    $4f56                       ; illegal
L00004e18            dc.w    $4552                       ; illegal
L00004e1a            dc.w    $00ff                       ; illegal
L00004e1c            dc.w    $4310                       ; [ chk.l (a0),d1 ]
L00004e1e            dc.w    $5449                       ; addaq.w #$02,a1
L00004e20            dc.w    $4d45                       ; illegal
L00004e22            dc.w    $2020                       ; move.l -(a0) [4ef83000],d0
L00004e24            dc.w    $5550                       ; subq.w #$02,(a0) [003c]
L00004e26            dc.w    $00ff                       ; illegal


L00004e28            movea.l L000036f6,a0                ; [00061b9c]
L00004e2e            move.w  #$1c8b,d7
L00004e32            clr.l   (a0)+
L00004e34            dbf.w   d7,L00004e32
L00004e38            rts 


L00004e3a            moveq   #$10,d3
L00004e3c            tst.b   $0007c874                   ; External Address - Panel
L00004e42            bne.b   L00004e60
L00004e44            lea.l   L00006318,a0
L00004e48            move.w  (a0),d2
L00004e4a            cmp.w   #$0050,d2
L00004e4e            bcc.b   L00004e60
L00004e50            addq.w  #$01,(a0)
L00004e52            clr.w   d3
L00004e54            subq.w  #$01,L00006306
L00004e58            bne.b   L00004e60
L00004e5a            move.w  #$4e64,L00003c92
L00004e60            move.b  d3,L00006308
L00004e64            lea.l   L00006318,a0                ; External Address
L00004e68            move.w  (a0),d5
L00004e6a            move.b  L00006308,d4
L00004e6e            btst.l  #$0003,d4
L00004e72            beq.b   L00004ea8
L00004e74            move.w  #$0048,L000067c6
L00004e7a            subq.w  #$01,d5
L00004e7c            bhi.b   L00004ea6
L00004e7e            clr.w   (a0)
L00004e80            move.w  #$5058,L00003c92
L00004e86            move.w  #$0005,L000062f2
L00004e8c            move.w  #$6426,L00006326
L00004e92            move.w  d1,d2
L00004e94            add.w   L000067be,d2
L00004e98            subq.w  #$02,d2
L00004e9a            and.w   #$0007,d2
L00004e9e            sub.w   d2,d1
L00004ea0            move.w  d1,L000067c4
L00004ea4            rts  


L00004ea6            move.w  d5,(a0) 
L00004ea8            btst.l  #$0002,d4
L00004eac            beq.w   L00004ec0
L00004eb0            move.w  #$0028,L000067c6
L00004eb6            addq.w  #$01,d5
L00004eb8            cmp.w   #$0050,d5
L00004ebc            bcc.b   L00004ec0
L00004ebe            move.w  d5,(a0)
L00004ec0            lea.l   L00006314,a0
L00004ec4            movem.w (a0),d2-d3
L00004ec8            clr.w   d7
L00004eca            moveq   #$07,d6
L00004ecc            cmp.w   #$0028,d5
L00004ed0            bcc.b   L00004edc
L00004ed2            moveq   #$03,d6
L00004ed4            cmp.w   #$0014,d6
L00004ed8            bcc.b   L00004edc
L00004eda            moveq   #$01,d6
L00004edc            and.w   L0000632c,d6
L00004ee0            bne.b   L00004eec
L00004ee2            and.w   #$0003,d4
L00004ee6            asr.w   #$01,d4
L00004ee8            subx.w  d7,d4
L00004eea            move.w  d4,d7
L00004eec            move.w  d2,d4
L00004eee            ext.l   d4
L00004ef0            divs.w  d5,d4
L00004ef2            sub.w   d7,d4
L00004ef4            add.w   d4,d3
L00004ef6            sub.w   d3,d2
L00004ef8            add.w   #$0080,d2
L00004efc            cmp.w   #$0100,d2
L00004f00            bcc.b   L00004f08
L00004f02            sub.w   #$0080,d2
L00004f06            bra.b   L00004f16
L00004f08            clr.w   d3
L00004f0a            sub.w   #$0080,d2
L00004f0e            bpl.b   L00004f14
L00004f10            moveq   #$81,d2
L00004f12            bra.b   L00004f16
L00004f14            moveq   #$7f,d2
L00004f16            movem.w d2-d3,(a0)
L00004f1a            lea.l   L00006314,a0
L00004f1e            lea.l   L000067c2,a2
L00004f22            bsr.w   L000050aa
L00004f26            movem.w L000067c2,d0-d1
L00004f2c            movem.w L00006328,d5-d6
L00004f32            sub.w   d3,d5
L00004f34            move.w  d5,L000062f4
L00004f38            move.w  d5,L0000630e
L00004f3c            sub.w   d6,d4
L00004f3e            move.w  d4,L000062f6
L00004f42            add.w   d4,d1
L00004f44            add.w   d5,d0
L00004f46            subq.w  #$04,d1
L00004f48            subq.w  #$05,d0
L00004f4a            bsr.w   L000055a0
L00004f4e            moveq   #$02,d7
L00004f50            move.b  $00(a0,d3.W),d2
L00004f54            cmp.b   #$17,d2
L00004f58            bcs.b   L00004f8e
L00004f5a            move.b  $01(a0,d3.W),d2
L00004f5e            cmp.b   #$17,d2
L00004f62            bcs.b   L00004f8e
L00004f64            sub.w   $00008002,d3            ; External Address
L00004f6a            dbf.w   d7,L00004f50
L00004f6e            movem.w L000067c2,d0-d1
L00004f74            add.w   d4,d1
L00004f76            add.w   d5,d0
L00004f78            movem.w d0-d1,L000067c2
L00004f7e            move.l  L0000631a,L00006328
L00004f84            btst.b  #$0004,L00006308
L00004f8a            bne.b   L00004fae
L00004f8c            rts 


L00004f8e           tst.w   d4
L00004f90           bmi.b   L00004f9a
L00004f92           subq.w  #$02,L00006318
L00004f96           bra.w   L00004f1a

L00004f9a           movem.w d0-d7,-(a7)
L00004f9e           moveq   #$02,d6
L00004fa0           bsr.w   L00004ccc
L00004fa4           movem.w (a7)+,d0-d7
L00004fa8           clr.w   d4
L00004faa           clr.w   d5
L00004fac           bra.b   L00004fcc

L00004fae           movem.w L000062f4,d4-d5
L00004fb4           subq.w  #$03,d5
L00004fb6           cmp.w   #$fffa,d5
L00004fba           bpl.b   L00004fbe
L00004fbc           moveq   #$fa,d5
L00004fbe           subq.w  #$02,d4
L00004fc0           cmp.w   #$fffc,d4
L00004fc4           bcc.b   L00004fca
L00004fc6           smi.b   d4
L00004fc8           asl.w   #$02,d4
L00004fca           addq.w  #$02,d4
L00004fcc           movem.w d4-d5,L000062f4
L00004fd2           clr.w   L00006318
L00004fd6           movem.w L000067c2,d0-d1
L00004fdc           bra.w   L00005464

L00004fe0           move.w  #$6419,L00003626        ; Jump Table CMD9
L00004fe8           move.w  #$4ff6,L00003c92
L00004fee           moveq   #$08,d0
L00004ff0           jsr     $00048014               ; External Address
L00004ff6           movea.w L00006326,a0
L00004ffa           bsr.w   L00005438
L00004ffe           move.w  a0,L00006326
L00005002           tst.b   (a0)
L00005004           bne.b   L00005034
L00005006           move.w  #$0008,L000062f2
L0000500c           move.w  #$5036,L00003c92
L00005012           bsr.w   L0000463e
L00005016           sub.w   #$0007,d0
L0000501a           move.w  L000062ee,d2
L0000501e           spl.b   d2
L00005020           ext.w   d2
L00005022           bpl.b   L00005028
L00005024           add.w   #$000e,d0
L00005028           addq.w  #$03,d2
L0000502a           move.w  d2,(a0)+
L0000502c           sub.w   #$0010,d1
L00005030           movem.w d0-d1,(a0)
L00005034           rts  


L00005036           move.b  L00006308,d4
L0000503c           bne.w   L0000504e
L00005040           subq.w  #$01,L000062f2
L00005044           bne.b   L00005034
L00005046           lea.l   L000063d3,a0
L0000504a           bra.w   L00004538

L0000504e           move.w  #$4c3e,L00003c92
L00005054           bra.w   L00004c3e

L00005058           subq.w  #$01,L000062f2
L0000505c           bne.b   L00005034
L0000505e           move.w  #$0006,L000062f2
L00005064           subq.w  #$05,L000067c4
L00005068           subq.w  #$04,d1
L0000506a           move.w  L000062ee,d2
L0000506e           bmi.b   L00005082
L00005070           addq.w  #$07,d0
L00005072           bsr.w   L000055a0
L00005076           cmp.b   #$17,d2
L0000507a           bcs.b   L00005092
L0000507c           addq.w  #$01,L000067c2
L00005080           bra.b   L00005092
L00005082           subq.w  #$06,d0
L00005084           bsr.w   L000055a0
L00005088           cmp.b   #$17,d2
L0000508c           bcs.b   L00005092
L0000508e           subq.w  #$01,L000067c2
L00005092           movea.w L00006326,a0
L00005096           bsr.w   L00005438
L0000509a           move.w  a0,L00006326
L0000509e           move.b  (a0),d7
L000050a0           bne.b   L000050a8
L000050a2           move.w  #$5414,L00003c92
L000050a8           rts 


L000050aa           lea.l   $007c(a0),a1
L000050ae           move.w  (a0),d2
L000050b0           asr.w   #$01,d2
L000050b2           move.w  d2,d4
L000050b4           bpl.b   L000050b8
L000050b6           neg.w   d4
L000050b8           clr.w   d3
L000050ba           move.b  $c0(a1,d4.W),d3
L000050be           mulu.w  $0004(a0),d3
L000050c2           btst.l  #$000f,d2
L000050c6           beq.b   L000050ca
L000050c8           neg.w   d3
L000050ca           asr.w   #$08,d3
L000050cc           move.w  d3,$0006(a0)            ; $00000a06 [2ffc]
L000050d0           move.w  d4,d2
L000050d2           neg.w   d2
L000050d4           clr.w   d4
L000050d6           move.b  $3f(a1,d2.W),d4         ; $000409a0 [00],d4
L000050da           mulu.w  $0004(a0),d4            ; $00000a04 [0000],d4
L000050de           lsr.w   #$08,d4
L000050e0           move.w  d4,$0008(a0)            ; $00000a08 [0000]
L000050e4           rts 


L000050e6           clr.w   L000062ee               ; Jump Table CMD12
L000050ea           moveq   #$7f,d0
L000050ec           bra.b   L000050fa

L000050ee           move.w  #$e000,L000062ee        ; Jump Table CMD13
L000050f4           moveq   #$81,d0
L000050f6           bra.b   L000050fa


L000050f8           clr.w   d0                          ; Jump Table CMD11
L000050fa           move.w  #$0048,L000067c6
L00005100           lea.l   $6314,a0
L00005104           move.w  d0,(a0)+
L00005106           clr.l   (a0)+
L00005108           bsr.w   L0000463e
L0000510c           move.w  #$0001,(a0)
L00005110           move.w  #$5132,L00003c92
L00005116           lea.l   L000063d0,a0
L0000511a           bsr.w   L00005438
L0000511e           moveq   #$07,d0
L00005120           jsr     $00048014               ; External Address
L00005126           movem.w L000067c2,d0-d1
L0000512c           bclr.b  #$0004,L00006308
L00005132           lea.l   L00006314,a0
L00005136           btst.b  #$0004,L00006308
L0000513e           bne.b   L000051be 
L00005140           move.w  $0004(a0),d2
L00005144           addq.w  #$02,d2
L00005146           cmp.w   #$0028,d2
L0000514a           bcc.b   L00005156
L0000514c           addq.w  #$01,d2
L0000514e           cmp.w   #$0014,d2
L00005152           bcc.b   L00005156
L00005154           addq.w  #$01,d2
L00005156           move.w  d2,$0004(a0)
L0000515a           bsr.w   L000050aa
L0000515e           addq.w  #$03,d3
L00005160           move.w  L000062ee,d7
L00005164           bpl.b   L00005168
L00005166           subq.w  #$07,d3
L00005168           add.w   #$000a,d4
L0000516c           sub.w   d4,d1
L0000516e           bcs.b   L000051a8
L00005170           move.w  L000067be,d5
L00005174           add.w   d1,d5
L00005176           btst.l  #$0002,d5
L0000517a           bne.b   L000051ae
L0000517c           add.w   d3,d0
L0000517e           bsr.w   L000055a0
L00005182           cmp.b   #$17,d2
L00005186           bcs.b   L000051a8
L00005188           cmp.b   #$85,d2
L0000518c           bcc.b   L000051a8
L0000518e           cmp.b   #$79,d2
L00005192           bcs.b   L000051ae
L00005194           move.w  #$4e64,L00003c92
L0000519a           move.l  L0000631a,L00006328
L000051a0           lea.l   L00006416,a0
L000051a4           bra.w   L00005438
L000051a8           move.w  #$51b0,L00003c92
L000051ae           rts


L000051b0           lea.l   L00006314,a0
L000051b4           btst.b  #$0004,L00006308
L000051bc           beq.b   L000051c4
L000051be           move.w  #$0002,$0004(a0)
L000051c4           subq.w  #$03,$0004(a0)
L000051c8           bls.b   L000051ce
L000051ca           bra.w   L000050aa
L000051ce           clr.w   $0004(a0)
L000051d2           move.w  #$4c3e,L00003c92
L000051d8           lea.l   L000063d3,a0
L000051dc           bra.w   L00005438
L000051e0           rts 


L000051e2           move.w  #$0028,L000067c6
L000051e8           move.w  L000067bc,d2
L000051ec           add.w   d0,d2
L000051ee           and.w   #$0007,d2
L000051f2           subq.w  #$04,d2
L000051f4           bne.b   L000051e0
L000051f6           bsr.w   L000055a0
L000051fa           cmp.b   #$85,d2
L000051fe           bcs.b   L000051e0
L00005200           bra.b   L0000522e


L00005202           bsr.b   L00005208           ; Jmp Table CMD6
L00005204           bra.w   L00005430
L00005208           move.w  #$0048,L000067c6
L0000520e           move.w  L000067bc,d2
L00005212           add.w   d0,d2
L00005214           and.w   #$0007,d2
L00005218           subq.w  #$04,d2
L0000521a           bne.b   L000051e0
L0000521c           sub.w   #$000c,d1
L00005220           bsr.w   L000055a0
L00005224           add.w   #$000c,d1
L00005228           cmp.b   #$85,d2
L0000522c           bcs.b   L000051e0
L0000522e           addq.w  #$04,a7             ; addaq.w
L00005230           and.b   #$0c,L00006308
L00005236           move.w  #$5308,L00003c92
L0000523c           bra.w   L00005308


L00005240           bsr.b   L000051e2           ; jmp table CMD4
L00005242           bra.b   L00005246 


L00005244           bsr.b   L00005208           ; jmp table CMD7

L00005246           addq.w  #$04,d0                    ; jmp table CMD1
L00005248           subq.w  #$02,d1
L0000524a           bsr.w   L000055a0
L0000524e           cmp.b   #$17,d2
L00005252           bcs.b   L00005290
L00005254           addq.w  #$01,L000067c2
L00005258           addq.w  #$07,d1
L0000525a           subq.w  #$05,d0
L0000525c           bsr.w   L000055a0
L00005260           sub.b   #$79,d2
L00005264           cmp.b   #$0d,d2
L00005268           bcc.w   L0000545a
L0000526c           lea.l   L000062ea,a0
L00005270           add.w   L000067bc,d0
L00005274           lsr.w   #$01,d0
L00005276           and.w   #$0007,d0
L0000527a           addq.w  #$05,d0
L0000527c           move.w  d0,(a0)+
L0000527e           and.w   #$0006,d0
L00005282           lsr.w   #$01,d0
L00005284           bne.b   L00005288
L00005286           moveq   #$02,d0
L00005288           addq.w  #$01,d0
L0000528a           move.w  d0,(a0)+
L0000528c           move.w  #$0001,(a0)
L00005290           rts                      


L00005292           bsr.w   L000051e2     ; Jump Table CMD5
L00005296           bra.b   L0000592c


L00005298           bsr.w   L00005208     ; Jump Table CMD8


L0000529c           subq.w  #$05,d0                ; Jump Table CMD2
L0000529e           subq.w  #$02,d1
L000052a0           bsr.w   L000055a0
L000052a4           cmp.b   #$17,d2
L000052a8           bcs.b   L00005290
L000052aa           subq.w  #$01,L000067c2
L000052ae           addq.w  #$07,d1
L000052b0           addq.w  #$05,d0
L000052b2           bsr.w   L000055a0
L000052b6           sub.b   #$79,d2
L000052ba           cmp.b   #$0d,d2
L000052be           bcc.w   L0000545a
L000052c2           lea.l   L000062ea,a0
L000052c6           add.w   L000067bc,d0
L000052ca           not.w   d0
L000052cc           lsr.w   #$01,d0
L000052ce           and.w   #$0007,d0
L000052d2           add.w   #$e005,d0
L000052d6           move.w  d0,(a0)+
L000052d8           and.w   #$e006,d0
L000052dc           lsr.b   #$01,d0
L000052de           bne.b   L000052e4
L000052e0           move.w  #$e002,d0
L000052e4           addq.w  #$01,d0
L000052e6           move.w  d0,(a0)+ 
L000052e8           move.w  #$e001,(a0)
L000052ec           rts 


L000052ee           add.w   d5,d3
L000052f0           move.b  (a0,d3.W,$00) == $00000d13 [d6],d2
L000052f4           sub.b   #$79,d2
L000052f8           cmp.b   #$0d,d2
L000052fc           bcc.b   #$6a == $00005368 (T)
L000052fe           move.w  #$4c3e,$3c92 [4c3e]
L00005304           bra.w   #$f938 == $00004c3e (T)
L00005308           btst.b  #$0004,$6308 [00]
L0000530e           bne.w   #$014a == $0000545a (T)
L00005312           btst.b  #$0000,$632d [00]
L00005318           bne.b   #$d2 == $000052ec (T)
L0000531a           clr.w   d4
L0000531c           move.b  $6308 [00],d4
L00005320           move.w  $67be [00f0],d2
L00005324           add.w   d1,d2
L00005326           and.w   #$0007,d2
L0000532a           beq.b   #$22 == $0000534e (F)
L0000532c           btst.l  #$0002,d4
L00005330           beq.b   #$08 == $0000533a (F)
L00005332           addq.w  #$01,d1
L00005334           move.w  #$0028,$67c6 [0048]
L0000533a           btst.l  #$0003,d4
L0000533e           beq.b   #$08 == $00005348 (F)
L00005340           subq.w  #$01,d1
L00005342           move.w  #$0048,$67c6 [0048]
L00005348           move.w  d1,$67c4 [0048]
L0000534c           bra.b   #$58 == $000053a6 (T)
L0000534e           bsr.w   #$0250 == $000055a0
L00005352           move.w  d4,d5
L00005354           and.b   #$03,d5
L00005358           move.b  d5,$6308 [00]
L0000535c           moveq #$01,d5
L0000535e           asr.w #$01,d4
L00005360           bcs.b #$8c == $000052ee (F)
L00005362           moveq #$ff,d5
L00005364           asr.w #$01,d4
L00005366           bcs.b #$86 == $000052ee (F)
L00005368           asr.w #$01,d4
L0000536a           bcc.b #$14 == $00005380 (T)
L0000536c           move.w #$0028,$67c6 [0048]
L00005372           cmp.b #$85,d2
L00005376           bcs.w #$0056 == $000053ce (F)
L0000537a           addq.w #$01,$67c4 [0048]
L0000537e           bra.b #$26 == $000053a6 (T)
L00005380           asr.w #$01,d4
L00005382           bcc.b #$48 == $000053cc (T)
L00005384           move.w #$0048,$67c6 [0048]
L0000538a           move.w $00008002 [00c0],d5
L00005390           sub.w d5,d3
L00005392           sub.w d5,d3
L00005394           sub.w d5,d3
L00005396           move.b (a0,d3.W,$00) == $00000d13 [d6],d2
L0000539a           cmp.b #$85,d2
L0000539e           bcs.b #$2e == $000053ce (F)
L000053a0           subq.w #$01,d1
L000053a2           move.w d1,$67c4 [0048]
L000053a6           move.w $67be [00f0],d2
L000053aa           add.w $67c4 [0048],d2
L000053ae           addq.w #$02,d2
L000053b0           not.w d2
L000053b2           and.w #$0007,d2
L000053b6           bclr.l #$0002,d2
L000053ba           beq.b #$04 == $000053c0 (F)
L000053bc           add.w #$e000,d2
L000053c0           add.w #$0020,d2
L000053c4           lea.l $62ea,a0
L000053c8           clr.l (a0)+ [003c004a]
L000053ca           move.w d2,(a0) [003c]
L000053cc           rts  == $6000001a


000053ce 31fc 4c3e 3c92           move.w #$4c3e,$3c92 [4c3e]
000053d4 4e75                     rts  == $6000001a


000053d6 0641 0008                add.w #$0008,d1                   ; Jump Table CMD10
000053da 6100 01c4                bsr.w #$01c4 == $000055a0
000053de 4cb8 0003 67c2           movem.w $67c2,d0-d1
000053e4 0c02 0017                cmp.b #$17,d2
000053e8 650a                     bcs.b #$0a == $000053f4 (F)
000053ea 31fc 8000 5506           move.w #$8000,$5506 [4e71]
000053f0 6000 0068                bra.w #$0068 == $0000545a (T)

000053f4 6100 fdec                bsr.w #$fdec == $000051e2         ; Jump table CMD3
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


L0000545a           movem.w L000067c2,d0-d1
L00005460           clr.l   L000062f4
L00005464           move.w  L000067c4,L000067c6
L0000546a           lea.l   $ffe8(pc),a0            ; $00005454
L0000546e           bsr.w   L00005438
L00005472           move.w  #$5482,L00003c92        ; Self Modifying Code? 
L00005478           move.w  #$ffff,L000062fa
L0000547e           clr.w   L000062f8
L00005482           movem.w L000062f4,d4-d5
L00005488           move.w d4,L0000630e
L0000548c           beq.b   L000054cc
L0000548e           sub.w   #$0010,d1
L00005492           subq.w  #$04,d0
L00005494           add.w   d4,d0
L00005496           bsr.w   L000055a0
L0000549a           movem.w L000067c2,d0-d1
L000054a0           moveq   #$01,d7
L000054a2           cmp.b   #$17,d2
L000054a6           bcs.b   L000054c8
L000054a8           move.b  $01(a0,d3.W),d2
L000054ac           cmp.b   #$17,d2
L000054b0           bcs.b #$16 == $000054c8 (F)
L000054b2           add.w $00008002 [00c0],d3
L000054b8           move.b (a0,d3.W,$00) == $00000d13 [d6],d2
L000054bc           dbf .w d7,#$ffe4 == $000054a2 (F)
L000054c0           add.w d0,d4
L000054c2           move.w d4,$67c2 [0050]
L000054c6           bra.b #$04 == $000054cc (T)
L000054c8           clr.w $62f4 [0000]
L000054cc           cmp.w #$0010,d5
L000054d0           bpl.b #$02 == $000054d4 (T)
L000054d2           addq.w #$01,d5
L000054d4           move.w d5,$62f6 [0000]
L000054d8           asr.w #$02,d5
L000054da           add.w d5,d1
L000054dc           move.w d1,$67c4 [0048]
L000054e0           btst.l #$000f,d1
L000054e4           beq.b #$02 == $000054e8 (F)
L000054e6           rts  == $6000001a





L000054e8           bsr.w   L000055a0
L000054ec           cmp.b   #$17,d2
L000054f0           bcc.b   L000054fe
L000054f2           subq.w  #$07,L000067c4
L000054f6           movem.w L000067c2,d0-d1
L000054fc           bra.b   L00005482
L000054fe           sub.b   #$79,d2
L00005502           cmp.b   #$0d,d2
L00005506           nop
L00005508           move.w  sr,d6
L0000550a           add.w   L000062f8,d5
L0000550e           move.w  d5,L000062f8
L00005512           cmp.w   #$0008,d5
L00005516           bcs.b   L0000551e
L00005518           move.w  #$4e71,L00005506
L0000551e           move.w  d6,sr
L00005520           bcc.b   L000054e6
L00005522           move.w  #$0028,L000067c6
L00005528           lea.l   L00005457,a0
L0000552c           bsr.w   L00005438
L00005530           move.l  #$0000555a,L00003c90
L00005538           clr.w   L000062f6
L0000553c           move.w  #$0001,L000062fa
L00005542           move.w  #$0002,L000062f2
L00005548           move.w  L000067be,d0
L0000554c           add.w   d1,d0
L0000554e           and.w   #$0007,d0
L00005552           sub.w   d0,d1
L00005554           move.w  d1,L000067c4
L00005558           rts





L0000555a           subq.w  #$01,L000062f2
L0000555e           bne.b   L00005558
L00005560           tst.b   $0007c874               ; External Address - Panel
L00005566           bne.w   L00004d82
L0000556a           move.l  #$00004c3e,L00003c90
L00005572           lea.l   L000063d3,a0
L00005576           cmp.w   #$0050,L000062f8
L0000557c           bmi.w   L00005438
L00005580           moveq   #$5a,d6
L00005582           bsr.w   L00004ccc
L00005586           move.b  #$04,$0007c874          ; External Address - Panel
L0000558e           btst.b  #$0007,$0007c875        ; External Address - Panel
L00005596           bne.b   L0000559e
L00005598           jmp     $0007c862               ; External Address - Panel (rts in panel will return to caller)
L0000559e           rts




L000055a0           movem.w L000067bc,d2-d3
L000055a6           add.w   d0,d2
L000055a8           add.w   d1,d3
L000055aa           lsr.w   #$03,d2
L000055ac           lsr.w   #$03,d3
L000055ae           mulu.w  $00008002,d3            ; External Address
L000055b4           add.w   d2,d3
L000055b6           lea.l   $0000807c,a0            ; External Address
L000055bc           clr.w   d2
L000055be           move.b  $00(a0,d3.W),d2
L000055c2           rts





L000055c4           move.w  L00006318,d2
L000055c8           beq.w   L000056a6
L000055cc           movem.w L000067c2,d0-d1
L000055d2           sub.w   #$000c,d1
L000055d6           addq.w  #$03,d0
L000055d8           move.w  L000062ee,d2
L000055dc           bpl.b   L000055e0
L000055de           subq.w  #$07,d0
L000055e0           add.w   d1,d1
L000055e2           move.w  d1,d7
L000055e4           mulu.w  #$002a,d1
L000055e8           ror.w   #$03,d0
L000055ea           move.w  d0,d2
L000055ec           and.w   #$0fff,d2
L000055f0           add.w   d2,d2
L000055f2           add.w   d2,d1
L000055f4           ext.l   d1
L000055f6           add.l   L000036f6,d1
L000055fa           movem.w L0000631a,d2-d3
L00005600           add.w   d2,d2
L00005602           add.w   d3,d3
L00005604           beq.w   L000056a6
L00005608           and.w   #$e000,d0
L0000560c           moveq   #$05,d4
L0000560e           or.w    d0,d4
L00005610           btst.l  #$000f,d2
L00005614           beq.b   L0000561c
L00005616           neg.w   d2
L00005618           bset.l  #$0003,d4
L0000561c           add.w   d2,d2
L0000561e           move.w  d2,d5
L00005620           sub.w   d3,d5
L00005622           bpl.b   L00005628
L00005624           bset.l  #$0006,d4
L00005628           move.w  d5,d6
L0000562a           sub.w   d3,d6
L0000562c           sub.w   d3,d7
L0000562e           subq.w  #$03,d7
L00005630           bpl.b   L00005634
L00005632           add.w   d7,d3
L00005634           asl.w   #$06,d3
L00005636           addq.w  #$02,d3
L00005638           or.w    #$0bca,d0
L0000563c           swap.w  d0
L0000563e           move.w  d4,d0
L00005640           lea.l   $00dff000,a5
L00005646           btst.b  #$0006,$00dff002
L0000564e           bne.b   L00005646
L00005650           move.w  d2,$0062(a5)
L00005654           move.w  d6,$0064(a5)
L00005658           move.w  #$002a,$0066(a5)
L0000565e           move.w  #$002a,$0060(a5)
L00005664           move.w  #$c000,$0074(a5)
L0000566a           move.l  #$ffffffff,$0044(a5)
L00005672           move.w  #$eeee,d6
L00005676           moveq   #$03,d7
L00005678           btst.b  #$0006,$00dff002
L00005680           bne.b   L00005678
L00005682           move.w  d5,$0052(a5)
L00005686           move.l  d0,$0040(a5)
L0000568a           move.l  d1,$0048(a5)
L0000568e           move.l  d1,$0054(a5)
L00005692           move.w  d6,$0072(a5)
L00005696           move.w  d3,$0058(a5)
L0000569a           add.l   #$00001c8c,d1
L000056a0           not.w   d6
L000056a2           dbf.w   d7,L00005678
L000056a6           movem.w L000067c2,d0-d1
L000056ac           move.w  L000062ee,d2
L000056b0           clr.w   d4
L000056b2           move.b  d2,d4
L000056b4           beq.w   L000056f2
L000056b8           move.w  d1,d3
L000056ba           lea.l   L0000607c,a0
L000056be           add.w   d4,d4
L000056c0           add.w   d3,d3
L000056c2           sub.b   $fe(a0,d4.W),d3
L000056c6           asr.w   #$01,d3
L000056c8           move.w  d3,L000062f0
L000056cc           bsr.b   L000056f4
L000056ce           movem.w L000067c2,d0-d1
L000056d4           move.w  L000062ec,d2
L000056d8           move.b  d2,d2
L000056da           beq.w   L000056f2
L000056de           bsr.b   L000056f4
L000056e0           movem.w L000067c2,d0-d1
L000056e6           move.w  L000062ea,d2
L000056ea           move.b  d2,d2
L000056ec           beq.w   L000056f2
L000056f0           bsr.b   L000056f4
L000056f2           rts 





L000056f4           movea.l L000062fe,a1
L000056f8           add.w   d1,d1
L000056fa           asl.w   #$03,d2
L000056fc           lea.l   $f8(a1,d2.W),a1
L00005700           bcc.b   L00005724
L00005702           move.b  (a1)+,d4
L00005704           ext.w   d4
L00005706           sub.w   d4,d1
L00005708           move.b  (a1)+,d4
L0000570a           ext.w   d4
L0000570c           add.w   d4,d0
L0000570e           clr.w   d2
L00005710           move.b  (a1)+,d2
L00005712           move.w  d2,d4
L00005714           lsl.w   #$03,d4
L00005716           sub.w   d4,d0
L00005718           clr.w   d3
L0000571a           move.b  (a1)+,d3
L0000571c           movea.l (a1)+,a0
L0000571e           adda.l  L00006302,a0
L00005722           bra.b   L0000573a
L00005724           move.b  (a1)+,d4
L00005726           ext.w   d4
L00005728           sub.w   d4,d1
L0000572a           move.b  (a1)+,d4
L0000572c           ext.w   d4
L0000572e           sub.w   d4,d0
L00005730           clr.w   d2
L00005732           move.b  (a1)+,d2
L00005734           clr.w   d3
L00005736           move.b  (a1)+,d3
L00005738           movea.l (a1)+,a0
L0000573a           move.w  d3,d4
L0000573c           mulu.w  d2,d4
L0000573e           add.l   d4,d4
L00005740           movea.l d4,a1
L00005742           move.w  d1,d1
L00005744           bpl.b   L00005758
L00005746           neg.w   d1
L00005748           sub.w   d1,d3
L0000574a           bls.w   L00005852
L0000574e           mulu.w  d2,d1
L00005750           adda.l  d1,a0
L00005752           adda.l  d1,a0
L00005754           moveq   #$00,d1
L00005756           bra.b   L00005768
L00005758           move.w  #$00ad,d6
L0000575c           sub.w   d1,d6
L0000575e           bls.w   L00005852
L00005762           cmp.w   d3,d6
L00005764           bpl.b   L00005768
L00005766           move.w  d6,d3
L00005768           moveq   #$ff,d7
L0000576a           move.w  d2,d5
L0000576c           moveq   #$07,d6
L0000576e           and.w   d0,d6
L00005770           bne.b   L00005794
L00005772           asr.w   #$03,d0
L00005774           bpl.b   L00005784
L00005776           neg.w   d0
L00005778           sub.w   d0,d5
L0000577a           bls.w   L00005852
L0000577e           adda.w  d0,a0
L00005780           adda.w  d0,a0
L00005782           moveq   #$00,d0
L00005784           moveq   #$14,d4
L00005786           sub.w   d0,d4
L00005788           ble.w   L00005852
L0000578c           cmp.w   d4,d5
L0000578e           bls.b   L000057ce
L00005790           move.w  d4,d5
L00005792           bra.b   L000057ce
L00005794           clr.w   d7
L00005796           addq.w  #$01,d5
L00005798           asr.w   #$03,d0
L0000579a           bpl.b   L000057b8
L0000579c           neg.w   d0
L0000579e           subq.w  #$01,d0
L000057a0           sub.w   d0,d5
L000057a2           bls.w   L00005852
L000057a6           adda.w  d0,a0
L000057a8           adda.w  d0,a0
L000057aa           moveq   #$ff,d0
L000057ac           moveq   #$08,d4
L000057ae           sub.w   d6,d4
L000057b0           add.w   d4,d4
L000057b2           lsr.w   d4,d0
L000057b4           swap.w  d0
L000057b6           and.l   d0,d7
L000057b8           moveq   #$14,d4
L000057ba           sub.w   d0,d4
L000057bc           ble.w   L00005852
L000057c0           cmp.w   d4,d5
L000057c2           bls.b   L000057ce
L000057c4           move.w  d4,d5
L000057c6           moveq   #$ff,d4
L000057c8           lsl.w   d6,d4
L000057ca           lsl.w   d6,d4
L000057cc           move.w  d4,d7
L000057ce           asl.w   #$06,d3
L000057d0           add.w   d5,d3
L000057d2           sub.w   d5,d2
L000057d4           add.w   d2,d2
L000057d6           moveq   #$15,d4
L000057d8           sub.w   d5,d4
L000057da           add.w   d4,d4
L000057dc           movea.l L000036f6,a2
L000057e2           add.w   d0,d0
L000057e4           adda.w  d0,a2
L000057e6           mulu.w  #$002a,d1
L000057ea           adda.l  d1,a2
L000057ec           ext.l   d6
L000057ee           ror.l   #$03,d6
L000057f0           move.l  d6,d0
L000057f2           swap.w  d0
L000057f4           or.l    d0,d6
L000057f6           movea.l #$00dff000,a5
L000057fc           or.l    #$0fca0000,d6
L00005802           btst.b  #$0006,$00dff002
L0000580a           bne.b   L00005802
L0000580c           move.w  d2,$0064(a5)
L00005810           move.w  d2,$0062(a5)
L00005814           move.l  d7,$0044(a5)
L00005818           move.w  d4,$0060(a5)
L0000581c           move.w  d4,$0066(a5)
L00005820           move.l  d6,$0040(a5)
L00005824           lea.l   (a0),a3
L00005826           moveq   #$03,d7
L00005828           btst.b  #$0006,$00dff002
L00005830           bne.b   L00005828
L00005832           lea.l   $00(a0,a1.L),a0
L00005836           move.l  a3,$0050(a5)
L0000583a           move.l  a0,$004c(a5)
L0000583e           move.l  a2,$0048(a5)
L00005842           move.l  a2,$0054(a5)
L00005846           move.w  d3,$0058(a5)
L0000584a           lea.l   $1c8c(a2),a2
L0000584e           dbf.w   d7,L00005828
L00005852           rts





L00005854           move.w  $00dff00c,d0
L0000585a           clr.b   d2
L0000585c           btst.l  #$0001,d0
L00005860           beq.b   L00005866
L00005862           bset.l  #$0000,d2
L00005866           btst.l  #$0009,d0
L0000586a           beq.b   L00005870
L0000586c           bset.l  #$0001,d2
L00005870           move.w  d0,d1
L00005872           lsr.w   #$01,d1
L00005874           eor.w   d0,d1
L00005876           btst.l  #$0000,d1
L0000587a           beq.b   L00005880
L0000587c           bset.l  #$0002,d2
L00005880           btst.l  #$0008,d1
L00005884           beq.b   L0000588a
L00005886           bset.l  #$0003,d2
L0000588a           btst.b  #$0007,$00bfe001
L00005892           seq.b   d0
L00005894           move.b  L00006309,d1
L00005898           bne.b   L000058a0
L0000589a           and.w   #$0010,d0
L0000589e           or.w    d0,d2
L000058a0           move.b  d0,L00006309
L000058a4           move.b  d2,L00006308
L000058a8           rts





L000058aa           clr.l   d0
L000058ac           move.w  L000067bc,d0
L000058b0           lsr.w   #$03,d0
L000058b2           add.w   d0,d0
L000058b4           movea.l #$0005a36c,a4
L000058ba           adda.l  d0,a4
L000058bc           move.l  a4,L0000631e
L000058c0           clr.w   L00006312
L000058c4           clr.l   d1
L000058c6           move.w  L000067bc,d1
L000058ca           moveq   #$14,d7
L000058cc           movem.l d1/d7/a4,-(a7)
L000058d0           bsr.w   L00004ad6
L000058d4           movem.l (a7)+,d1/d7/a4
L000058d8           addq.w  #$08,d1
L000058da           addq.l  #$02,a4                 ; addaq.l
L000058dc           dbf.w   d7,L000058cc
L000058e0           rts 





L000058e2           move.w  #$013f,d7
L000058e6           lea.l   L000068a0,a0
L000058ea           move.b  $0004(a0),d0
L000058ee           and.b   $0001(a0),d0
L000058f2           not.b   d0
L000058f4           and.b   $0002(a0),d0
L000058f8           and.b   $0003(a0),d0
L000058fc           eor.b   d0,$0001(a0)
L00005900           addq.w  #$05,a0                     ; addaq.w
L00005902           dbf.w   d7,L000058ea
L00005906           lea.l   $00008002,a0                ; External Address
L0000590c           move.w  (a0)+,d5
L0000590e           move.w  (a0)+,d6
L00005910           lea.l   $0076(a0),a0
L00005914           move.b  $0028(a0),d0
L00005918           cmp.b   #$17,d0
L0000591c           bcc.b   L00005942
L0000591e           move.w  d6,d0
L00005920           subq.w  #$01,d0
L00005922           mulu.w  d5,d0
L00005924           lea.l   $00(a0,d0.L),a1
L00005928           lsr.w   #$01,d6
L0000592a           subq.w  #$01,d6
L0000592c           move.w  d5,d4
L0000592e           subq.w  #$01,d4
L00005930           move.b  (a0),d0
L00005932           move.b  (a1),(a0)+
L00005934           move.b  d0,(a1)+
L00005936           dbf.w   d4,L00005930
L0000593a           suba.w  d5,a1
L0000593c           suba.w  d5,a1
L0000593e           dbf.w   d6,L0000592c
L00005942           movea.l L000062fe,a1
L00005946           movea.l #$00011002,a0
L0000594c           lea.l   L0000607c,a2
L00005952           move.w  (a0)+,d7
L00005954           clr.l   d0
L00005956           move.w  d7,d0
L00005958           subq.w  #$01,d7
L0000595a           move.w  d7,d6
L0000595c           asl.w   #$03,d0
L0000595e           add.l   a0,d0
L00005960           movea.l d0,a5
L00005962           lea.l   $0002(a0),a0
L00005966           move.w  (a2)+,(a1)+
L00005968           move.b  (a0)+,d0
L0000596a           lsr.b   #$04,d0
L0000596c           addq.w  #$01,d0
L0000596e           move.b  d0,(a1)+
L00005970           move.b  (a0)+,d0
L00005972           addq.w  #$01,d0
L00005974           move.b  d0,(a1)+
L00005976           move.l  (a0)+,d0
L00005978           add.l   a5,d0
L0000597a           move.l  d0,(a1)+
L0000597c           dbf.w   d7,L00005962
L00005980           move.w  d6,d7
L00005982           movea.l L000062fe,a2
L00005986           clr.l   d2
L00005988           addq.w  #$02,a2                 ; Addaq.w
L0000598a           clr.w   d0
L0000598c           move.b  (a2)+,d0
L0000598e           clr.w   d1
L00005990           move.b  (a2)+,d1
L00005992           mulu.w  d1,d0
L00005994           add.w   d0,d2
L00005996           addq.w  #$06,a2                  ; addaq.w
L00005998           dbf.w   d7,L0000598a
L0000599c           mulu.w  #$000a,d2
L000059a0           move.l  d2,L00006302
L000059a4           movea.l L000062fe,a1
L000059a8           movea.l $0004(a1),a1
L000059ac           addq.w  #$01,a1                 ; addaq.w
L000059ae           btst.b  #$0000,(a1)
L000059b2           bne.w   L000059b8
L000059b6           rts





L000059b8           move.w  d6,d7
L000059ba           movea.l L000062fe,a1
L000059be           addq.w  #$02,a1                 ; addaq.w
L000059c0           movea.l a0,a5
L000059c2           movea.l a0,a3
L000059c4           clr.l   d5
L000059c6           clr.l   d0
L000059c8           move.b  (a1)+,d0
L000059ca           move.b  (a1),d5
L000059cc           mulu.w  d0,d5
L000059ce           move.l  d5,d4
L000059d0           add.w   d4,d4
L000059d2           move.l  d4,d3
L000059d4           add.w   d4,d3
L000059d6           move.l  d3,d2
L000059d8           add.w   d4,d2
L000059da           move.l  d2,d1
L000059dc           add.w   d4,d1
L000059de           subq.w  #$01,d5
L000059e0           movea.l #$00061b9c,a2               ; External Address
L000059e6           move.w  (a0)+,(a2)
L000059e8           not.w   (a2)
L000059ea           move.w  (a0)+,$00(a2,d4.W)
L000059ee           move.w  (a0)+,$00(a2,d3.W)
L000059f2           move.w  (a0)+,$00(a2,d2.W)
L000059f6           move.w  (a0)+,$00(a2,d1.W)
L000059fa           addq.w  #$02,a2                     ; addaq.w
L000059fc           dbf.w   d5,L000059e6
L00005a00           move.w  #$0004,d4
L00005a04           clr.w   d5
L00005a06           move.b  (a1),d5
L00005a08           subq.w  #$01,d5
L00005a0a           move.w  d0,d2
L00005a0c           subq.w  #$01,d2
L00005a0e           suba.l  d0,a2
L00005a10           suba.l  d0,a2
L00005a12           move.w  (a2)+,(a3)+
L00005a14           dbf.w   d2,L00005a12
L00005a18           suba.l  d0,a2
L00005a1a           suba.l  d0,a2
L00005a1c           dbf.w   d5,L00005a0a
L00005a20           adda.l d3,a2
L00005a22           dbf.w   d4,L00005a04
L00005a26           lea.l   $0007(a1),a1
L00005a2a           dbf.w   d7,L000059c4
L00005a2e           movea.l a3,a4
L00005a30           movea.l L000062fe,a1
L00005a34           move.w  d6,d7
L00005a36           moveq   #$04,d6
L00005a38           movea.l $0004(a1),a0
L00005a3c           clr.l   d5
L00005a3e           clr.l   d4
L00005a40           move.b  $0002(a1),d4
L00005a44           move.b  $0003(a1),d5
L00005a48           subq.w  #$01,d5
L00005a4a           move.w  d4,d3
L00005a4c           add.w   d3,d3
L00005a4e           subq.w  #$01,d3
L00005a50           move.b  $00(a0,d3.W),d0
L00005a54           moveq   #$07,d2
L00005a56           roxr.b  #$01,d0
L00005a58           roxl.b  #$01,d1
L00005a5a           dbf.w   d2,L00005a56
L00005a5e           move.b  d1,(a3)+
L00005a60           dbf.w   d3,L00005a50
L00005a64           adda.l  d4,a0
L00005a66           adda.l  d4,a0
L00005a68           dbf.w   d5,L00005a4a
L00005a6c           dbf.w   d6,L00005a3c
L00005a70           lea.l   $0008(a1),a1
L00005a74           dbf.w   d7,L00005a36
L00005a78           rts



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
