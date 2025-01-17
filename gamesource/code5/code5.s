


TEST_BUILD_LEVEL    SET 1                              ; run a test build with imported GFX, level data and Panel




                section code1,code_c
                
             
            ; if not test then org $2FFC   
            IFND TEST_BUILD_LEVEL
                org     $2ffc                                           ; original load address $2FFC
            ENDC



                ;--------------------- includes and constants ---------------------------
                INCDIR      "include"
                INCLUDE     "hw.i"
                opt         o-




            ; if test then jump to game start
            IFD TEST_BUILD_LEVEL
start               ; added for testing 
                    jmp game_start     
            ENDC



original_start:  
                    dc.l    $00002FFC                           ; original address $00002ffc

game_start          ; original address $00003000
initialise_system   ; original address $00003000 
L00003000            MOVE.L  #$00000000,D0
L00003002            MOVE.W  #$1fff,$00dff09a
L0000300A            MOVE.W  #$1fff,$00dff096
L00003012            MOVE.W  #$0200,$00dff100
L0000301A            MOVE.L  D0,$00dff102
L00003020            MOVE.W  #$4000,$00dff024
L00003028            MOVE.L  D0,$00dff040
L0000302E            MOVE.W  #$0041,$00dff058
L00003036            MOVE.W  #$8340,$00dff096
L0000303E            MOVE.W  #$7fff,$00dff09e
L00003046            MOVE.L  #$00000007,D7
L00003048            LEA.L   $00dff140,A0
L0000304E            MOVE.W  D0,(A0)
L00003050            ADDA.W  #$00000008,A0
L00003052            DBF.W   D7,L0000304e
L00003056            MOVE.L  #$00000003,D7
L00003058            LEA.L   $00dff0a8,A0
L0000305E            MOVE.W  D0,(A0)
L00003060            LEA.L   $0010(A0),A0
L00003064            DBF.W   D7,L0000305e
L00003068            LEA.L   $00dff180,A0
L00003070            MOVE.W  D0,(A0)+
L0000306E            MOVE.L  #$0000001f,D7
L00003072            DBF.W   D7,L00003070
L00003076            MOVE.B  #$7f,$00bfed01
L0000307E            MOVE.B  D0,$00bfee01
L00003084            MOVE.B  D0,$00bfef01
L0000308A            MOVE.B  D0,$00bfe001
L00003090            MOVE.B  #$03,$00bfe201
L00003098            MOVE.B  D0,$00bfe101
L0000309E            MOVE.B  #$ff,$00bfe301
L000030A6            MOVE.B  #$7f,$00bfdd00
L000030AE            MOVE.B  D0,$00bfde00
L000030B4            MOVE.B  D0,$00bfdf00
L000030BA            MOVE.B  #$c0,$00bfd000
L000030C2            MOVE.B  #$c0,$00bfd200
L000030CA            MOVE.B  #$ff,$00bfd100
L000030D2            MOVE.B  #$ff,$00bfd300
L000030DA            LEA.L   $0005a36c,A7                    ; STACK
L000030E0            MOVE.L  #$00000002,D7
L000030E2            LEA.L   L000031a4,A0
L000030E8            LEA.L   $00000064,A1
L000030EE            MOVE.L  (A0)+,(A1)+
L000030F0            DBF.W   D7,L000030ee
L000030F4            MOVE.W  #$ff00,$00dff034
L000030FC            MOVE.W  D0,$00dff036
L00003102            OR.B    #$ff,$00bfd100
L0000310A            AND.B   #$87,$00bfd100
L00003112            AND.B   #$87,$00bfd100
L0000311A            OR.B    #$ff,$00bfd100
L00003122            MOVE.B  #$f0,$00bfe601
L0000312A            MOVE.B  #$37,$00bfeb01
L00003132            MOVE.B  #$11,$00bfef01
L0000313A            MOVE.B  #$91,$00bfd600
L00003142            MOVE.B  D0,$00bfdb00
L00003148            MOVE.B  D0,$00bfdf00
L0000314E            MOVE.W  #$7fff,$00dff09c
L00003156            TST.B   $00bfed01
L0000315C            MOVE.B  #$8a,$00bfed01
L00003164            TST.B   $00bfdd00
L0000316A            MOVE.B  #$93,$00bfdd00
L00003172            MOVE.W  #$e078,$00dff09a
L0000317A            MOVE.W  #$1200,D0
L0000317E            JSR     $0007c80e                       ; PANEL
L00003184            JSR     $0007c854                       ; PANEL
L0000318A            BSR.W   L0000373a
L0000318E            LEA.L   L000031bc,A0
L00003194            BSR.W   L0000367e
L00003198            BSR.W   L000036ee
L0000319C            BRA.W   L00003ad4


L000031A0           dc.w    $ffff 
L000031A2           dc.w    $fffe 

interrupt_handlers_table
L000031A4           dc.l    L000032b4
L000031A8           dc.l    L000032ec
L000031AC           dc.l    L00003312
L000031B0           dc.l    L0000334e
L000031B4           dc.l    L00003364
L000031B8           dc.l    L0000338a

copper_list
L000031BC           dc.w    $2c01,$fffe
L000031C0           dc.w    $010a,$0002
L000031C4           dc.w    $0108,$0002
L000031C8           dc.w    $00e2,$8dce
L000031CC           dc.w    $00e0,$0006
                    dc.w    $00e6,$aa5a 
L000031D4           dc.w    $00e4,$0006
                    dc.w    $00ea,$c6e6
L000031DC           dc.w    $00e8,$0006
                    dc.w    $00ee,$e372
L000031E4           dc.w    $00ec,$0006
                    dc.w    $0182,$0446
                    dc.w    $0184,$088a
L000031F0           dc.w    $0186,$0cce 
L000031F4           dc.w    $0188,$0048
L000031F8           dc.w    $018a,$028c
L000031FC           dc.w    $018c,$0c64
L00003200           dc.w    $018e,$0a22
L00003204           dc.w    $0190,$06a6
                    dc.w    $0192,$0c4a
L0000320C           dc.w    $0194,$0ec6
L00003210           dc.w    $0196,$0e88 
L00003214           dc.w    $0198,$0600
                    dc.w    $019a,$0262
                    dc.w    $019c,$0668
                    dc.w    $019e,$06ae
L00003224           dc.w    $da01,$fffe
L00003228           dc.w    $010a,$0000
L0000322C           dc.w    $0108,$0000
L00003230           dc.w    $00e2,$c89a
L00003234           dc.w    $00e0,$0007
                    dc.w    $00e6,$d01a
L0000323C           dc.w    $00e4,$0007
                    dc.w    $00ea,$d79a
L00003244           dc.w    $00e8,$0007
                    dc.w    $00ee,$df1a
L0000324C           dc.w    $00ec,$0007
                    dc.w    $0180,$0000
                    dc.w    $0182,$0060
                    dc.w    $0184,$0fff
L0000325C           dc.w    $0186,$0008
L00003260           dc.w    $0188,$0a22
L00003264           dc.w    $018a,$0444
L00003268           dc.w    $018c,$0862
L0000326C           dc.w    $018e,$0666
L00003270           dc.w    $0190,$0888
L00003274           dc.w    $0192,$0aaa 
                    dc.w    $0194,$0a40
                    dc.w    $0196,$0c60
                    dc.w    $0198,$0e80
L00003284           dc.w    $019a,$0ea0 
L00003288           dc.w    $019c,$0ec0
L0000328C           dc.w    $019e,$0eee 
                    dc.w    $ffff,$fffe
L00003290           dc.w    $ffff,$fffe


                    ;------------------- 16 colours for the Panel ---------------------
panel_colours                                       ; original address L00003294
L00003294           dc.w    $0000,$0060,$0fff,$0008,$0a22,$0444,$0862,$0666
L000032A4           dc.w    $0888,$0aaa,$0a40,$0c60,$0e80,$0ea0,$0ec0,$0eee

                    ; -------------------- level 1 - interrupt handler --------------------
                    ; TBE, DSKBLK, SOFT - Interrupts, just clear the bits from INTREQ
                    ;  NB: not enabled by init_system above
                    ;
level1_interrupt_handler                            ; original addr: 000032B4
L000032B4               MOVE.L  D0,-(A7)
L000032B6               MOVE.W  $00dff01e,D0
L000032BC               BTST.L  #$0002,D0
L000032C0               BNE.B   L000032e0
L000032C2               BTST.L  #$0001,D0
L000032C6               BNE.B   L000032d4
L000032C8               MOVE.W  #$0001,$00dff09c
L000032D0               MOVE.L  (A7)+,D0
L000032D2               RTE 

L000032D4               MOVE.W  #$0002,$00dff09c
L000032DC               MOVE.L  (A7)+,D0
L000032DE               RTE 

L000032E0               MOVE.W  #$0004,$00dff09c
L000032E8               MOVE.L  (A7)+,D0
L000032EA               RTE 

L000032EC               MOVE.L  D0,-(A7)
L000032EE               MOVE.B  $00bfed01,D0
L000032F4               BPL.B   L00003306
L000032F6               BSR.W   L000033c8
L000032FA               MOVE.W  #$0008,$00dff09c
L00003302               MOVE.L  (A7)+,D0
L00003304               RTE 

L00003306               MOVE.W  #$0008,$00dff09c
L0000330E               MOVE.L  (A7)+,D0
L00003310               RTE 

L00003312               MOVE.L  D0,-(A7)
L00003314               MOVE.W  $00dff01e,D0
L0000331A               BTST.L  #$0004,D0
L0000331E               BNE.B   L00003342
L00003320               BTST.L  #$0005,D0
L00003324               BNE.B   L00003332
L00003326               MOVE.W  #$0040,$00dff09c
L0000332E               MOVE.L  (A7)+,D0
L00003330               RTE 

L00003332               BSR.W   L0000351a
L00003336               MOVE.W  #$0020,$00dff09c
L0000333E               MOVE.L  (A7)+,D0
L00003340               RTE 

L00003342               MOVE.W  #$0010,$00dff09c
L0000334A               MOVE.L  (A7)+,D0
L0000334C               RTE 

L0000334E               MOVE.L  D0,-(A7)
L00003350               MOVE.W  $00dff01e,D0
L00003356               AND.W   #$0780,D0
L0000335A               MOVE.W  D0,$00dff09a
L00003360               MOVE.L  (A7)+,D0
L00003362               RTE 

L00003364               MOVE.L  D0,-(A7)
L00003366               MOVE.W  $00dff01e,D0
L0000336C               BTST.L  #$000c,D0
L00003370               BNE.B   L0000337e
L00003372               MOVE.W  #$0800,$00dff09c
L0000337A               MOVE.L  (A7)+,D0
L0000337C               RTE 

L0000337E               MOVE.W  #$1000,$00dff09c
L00003386               MOVE.L  (A7)+,D0
L00003388               RTE 

L0000338A               MOVE.L  D0,-(A7)
L0000338C               MOVE.W  $00dff01e,D0
L00003392               BTST.L  #$000e,D0
L00003396               BNE.B   L000033bc
L00003398               MOVE.B  $00bfdd00,D0
L0000339E               BPL.B   L000033b0
L000033A0               BSR.W   L00003508
L000033A4               MOVE.W  #$2000,$00dff09c
L000033AC               MOVE.L  (A7)+,D0
L000033AE               RTE 

L000033B0               MOVE.W  #$2000,$00dff09c
L000033B8               MOVE.L  (A7)+,D0
L000033BA               RTE 

L000033BC               MOVE.W  #$4000,$00dff09c
L000033C4               MOVE.L  (A7)+,D0
L000033C6               RTE 

L000033C8               LSR.B   #$00000002,D0
L000033CA               BCC.B   L000033d0
L000033CC               BSR.W   L00003538
L000033D0               LSR.B   #$00000002,D0
L000033D2               BCC.B   L00003442
L000033D4               MOVEM.L D1-D2/A0,-(A7)
L000033D8               MOVE.B  $00bfec01,D1
L000033DE               NOT.B   D1
L000033E0               LSR.B   #$00000001,D1
L000033E2               BCC.B   L000033fa
L000033E4               LEA.L   L000034e8,A0
L000033EA               EXT.W   D1
L000033EC               MOVE.B  $56(PC,D1.w),D1
L000033F0               MOVE.W  D1,D2
L000033F2               LSR.W   #$00000003,D2
L000033F4               BCLR.B  D1,$00(A0,D2.w)
L000033F8               BRA.B   L00003436

L000033FA               LEA.L   L000034e8,A0
L00003400               EXT.W   D1
L00003402               MOVE.B  $40(PC,D1.w),D1
L00003406               MOVE.W  D1,D2
L00003408               LSR.W   #$00000003,D2
L0000340A               BSET.B  D1,$00(A0,D2.w)
L0000340E               TST.B   D1
L00003410               BEQ.B   L00003436
L00003412               LEA.L   L000034c4,A0
L00003418               MOVE.W  L000034e4,D2
L0000341E               MOVE.B  D1,$00(A0,D2.w)
L00003422               ADD.W   #$00000001,D2
L00003424               AND.W   #$001f,D2
L00003428               CMP.W   L000034e6,D2
L0000342E               BEQ.B   L00003436
L00003430               MOVE.W  D2,L000034e4
L00003436               MOVE.B  #$40,$00bfee01
L0000343E               MOVEM.L (A7)+,D1-D2/A0
L00003442               RTS 


                    ; raw key code translation table (raw keycode index into the table, ascii lookup)
                    ; keycode in range $00 - $7f
acsii_lookup_table                          ; original address 00003444
00003444 2731 3233                MOVE.L (A1, D3.W*2, $33) == $000004c7,-(A3)
00003448 3435 3637                MOVE.W (A5, D3.W*8, $37) == $00005ae3,D2
0000344C 3839 302d 3d5c           MOVE.W $302d3d5c,D4
00003452 0030 5157 4552 5459      OR.B #$57,(A0, D4.W*4+0)+21593 == $00005459
0000345A 5549                     SUBA.W #$00000002,A1
0000345C 4f50                     ILLEGAL 
0000345E 5b5d                     SUB.W #$00000005,(A5)+
00003460 0031 3233 4153 4446 4748 OR.B #$33,(A1, D4.W*1+0)+1145456456 == $4c624844
0000346A 4a4b                     [ TST.W A3 ]
0000346C 4c3b 2300 0034           [ MULL.L (PC, D2.W*2+0)+0 == $0000346e,D0 ]
0000346E 2300                     MOVE.L D0,-(A1)
00003470 0034 3536 005a           OR.B #$36,(A4, D0.W*1, $5a) == $00dff087
00003476 5843                     ADD.W #$00000004,D3
00003478 5642                     ADD.W #$00000003,D2
0000347A 4e4d                     TRAP #$0000000d
0000347C 2c2e 2f00                MOVE.L (A6, $2f00) == $00007872,D6
00003480 0037 3839 2008           OR.B #$39,(A7, D2.W*1, $08) == $0005a36c
00003486 090d 0d1b                MVPMR.W (A5, $0d1b) == $000055bf,D4
0000348A 7f00                     ILLEGAL 
0000348C 0000 2d00                OR.B #$00,D0
00003490 8c8d                     ILLEGAL 
00003492 8e8f                     ILLEGAL 
00003494 8182                     [ UNPK D2,D0 ]
00003496 8384                     [ UNPK D4,D1 ]
00003498 8586                     [ UNPK D6,D2 ]
0000349A 8788                     [ UNPK -(A0),-(A3) ]
0000349C 898a                     [ UNPK -(A2),-(A4) ]
0000349E 2829 2f2a                MOVE.L (A1, $2f2a) == $00002f3c,D4
000034A2 2b8b 0000                MOVE.L A3,(A5, D0.W*1, $00) == $000048d1
000034A6 0000 0000                OR.B #$00,D0
000034AA 0000 0000                OR.B #$00,D0
000034AE 0000 0000                OR.B #$00,D0
000034B2 0000 0000                OR.B #$00,D0
000034B6 0000 0000                OR.B #$00,D0
000034BA 0000 0000                OR.B #$00,D0
000034BE 0000 0000                OR.B #$00,D0
000034C2 0000 0000                OR.B #$00,D0
000034C6 0000 0000                OR.B #$00,D0
000034CA 0000 0000                OR.B #$00,D0
000034CE 0000 0000                OR.B #$00,D0
000034D2 0000 0000                OR.B #$00,D0
000034D6 0000 0000                OR.B #$00,D0
000034DA 0000 0000                OR.B #$00,D0
000034DE 0000 0000                OR.B #$00,D0
000034E2 0000 0000                OR.B #$00,D0
000034E6 0000 0000                OR.B #$00,D0
000034EA 0000 0000                OR.B #$00,D0
000034EE 0000 0000                OR.B #$00,D0
000034F2 0000 0000                OR.B #$00,D0
000034F6 0000 0000                OR.B #$00,D0
000034FA 0000 0000                OR.B #$00,D0
000034FE 0000 0000                OR.B #$00,D0
00003502 0000 0000                OR.B #$00,D0
00003506 0000 


L00003508                   LSR.B   #$00000002,D0
L0000350A                   BCC.B   L00003514
L0000350C                   MOVE.B  #$00,$00bfee01
L00003514                   RTS 

L00003516                   dc.l    $00003536                 ; L00003542 ; unused ptr to 'rts' below

L0000351A                   MOVEM.L D1-D7/A0-A6,-(A7)
L0000351E                   ADD.W   #$00000001,L000036e2
L00003524                   JSR     $00048018               ; AUDIO
L0000352A                   MOVE.B  #$00,$00bfee01
L00003532                   MOVEM.L (A7)+,D1-D7/A0-A6
L00003536                   RTS 

L00003538                   MOVEM.L D0-D7/A0-A6,-(A7)
L0000353C                   BSR.W   L0000355a
L00003540                   ADD.W   #$00000001,L00003558
L00003546                   MOVEA.L L00003554,A0
L0000354C                   JSR (A0)
L0000354E                   MOVEM.L (A7)+,D0-D7/A0-A6
L00003552                   RTS 

L00003554                   dc.l $00003536                 ; L00003542 ; CIAB - Timer B - Handler Routine - Default ptr to 'rts' @ $00003542
L00003558                   dc.w $06e6                     ; CIAB - Timer B - Ticker Count 

L0000355A                   MOVE.W  $00dff00a,D0
L00003560                   MOVE.W  L00003624,D1
L00003566                   MOVE.W  D0,$00003624
L0000356C                   BSR.W   L000035ee
L00003570                   MOVE.B  D0,L0000362b
L00003576                   ADD.W   D1,L0000363a
L0000357C                   ADD.W   D2,L0000363c
L00003582                   BTST.B  #$0006,$00bfe001
L0000358A                   SEQ.B   L0000362a
L00003590                   SEQ.B   L00003638
L00003596                   BTST.B  #$0002,$00dff016
L0000359E                   SEQ.B   L00003639
L000035A4                   MOVE.W  $00dff00c,D0
L000035AA                   MOVE.W  L00003626,D1
L000035B0                   MOVE.W  D0,L00003626
L000035B6                   BSR.B   L000035ee
L000035B8                   MOVE.B  D0,L0000362f
L000035BE                   ADD.W   D1,L00003640
L000035C4                   ADD.W   D2,L00003642
L000035CA                   BTST.B  #$0007,$00bfe001
L000035D2                   SEQ.B   L0000362e
L000035D8                   SEQ.B   L0000363e
L000035DE                   BTST.B  #$0006,$00dff016
L000035E6                   SEQ.B   L0000363f
L000035EC                   RTS 


L000035EE                   MOVE.W  D0,D3
L000035F0                   MOVE.W  D1,D2
L000035F2                   SUB.B   D3,D1
L000035F4                   NEG.B   D1
L000035F6                   EXT.W   D1
L000035F8                   LSR.W   #$00000008,D2
L000035FA                   LSR.W   #$00000008,D3
L000035FC                   SUB.B   D3,D2
L000035FE                   NEG.B   D2
L00003600                   EXT.W   D2
L00003602                   MOVE.L  #$00000003,D3
L00003604                   AND.W   D0,D3
L00003606                   LSR.W   #$00000006,D0
L00003608                   AND.W   #$000c,D0
L0000360C                   OR.W    D3,D0
L0000360E                   MOVE.B  $04(PC,D0.w),D0
L00003612                   RTS 

                ; Data - Joystick stuff (largely unused)
00003614 0004 0501                OR.B #$01,D4
00003618 080c                     ILLEGAL 
0000361A 0d09 0a0e                MVPMR.W (A1, $0a0e) == $00000a20,D6
0000361E 0f0b 0206                MVPMR.W (A3, $0206) == $00037446,D7
00003622 0703                     BTST.L D3,D3
00003624 d98c                     ADDX.L -(A4),-(A4)
00003626 0000 0000                OR.B #$00,D0
0000362A 0008                     ILLEGAL 

0000362C 0000 0000                OR.B #$00,D0
00003630 0000 0000                OR.B #$00,D0
00003634 0000 0000                OR.B #$00,D0
00003638 0000 f48c                OR.B #$8c,D0
0000363C fdd9                     ILLEGAL 
0000363E 0000 0000                OR.B #$00,D0
00003642 0000 


L00003644                   MOVE.L  D0,-(A7)
L00003646                   BSR.B   L0000364e
L00003648                   BNE.B   L00003646
L0000364A                   MOVE.L  (A7)+,D0
L0000364C                   RTS 

L0000364E                   MOVEM.L D1-D2/A0,-(A7)
L00003652                   LEA.L   L000034c4,A0
L00003658                   MOVE.L  #$00000000,D0
L0000365A                   MOVEM.W L000034e4,D1-D2
L00003662                   CMP.W   D1,D2
L00003664                   BEQ.B   L00003676
L00003666                   MOVE.B  $00(A0,D2.w),D0
L0000366A                   ADD.W   #$00000001,D2
L0000366C                   AND.W   #$001f,D2
L00003670                   MOVE.W  D2,L000034e6
L00003676                   TST.B   D0
L00003678                   MOVEM.L (A7)+,D1-D2/A0
L0000367C                   RTS 


L0000367E                   MOVE.W  #$0080,$00dff096
L00003686                   MOVE.L  A0,$00dff080
L0000368C                   MOVE.W  A0,$00dff088
L00003692                   MOVE.W  #$0000,$00dff10a
L0000369A                   MOVE.W  #$0000,$00dff108
L000036A2                   MOVE.W  #$0038,$00dff092
L000036AA                   MOVE.W  #$00d0,$00dff094
L000036B2                   MOVE.W  #$3080,$00dff08e
L000036BA                   MOVE.W  #$0ac0,$00dff090
L000036C2                   MOVE.W  #$4200,$00dff100
L000036CA                   CLR.W   $000036e2
L000036D0                   TST.W   $000036e2
L000036D6                   BEQ.B   L000036d0
L000036D8                   MOVE.W  #$8180,$00dff096
L000036E0                   RTS 
