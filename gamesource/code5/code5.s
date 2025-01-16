


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
00003000 7000                     MOVE.L #$00000000,D0
00003002 33fc 1fff 00df f09a      MOVE.W #$1fff,$00dff09a
0000300A 33fc 1fff 00df f096      MOVE.W #$1fff,$00dff096
00003012 33fc 0200 00df f100      MOVE.W #$0200,$00dff100
0000301A 23c0 00df f102           MOVE.L D0,$00dff102
00003020 33fc 4000 00df f024      MOVE.W #$4000,$00dff024
00003028 23c0 00df f040           MOVE.L D0,$00dff040
0000302E 33fc 0041 00df f058      MOVE.W #$0041,$00dff058
00003036 33fc 8340 00df f096      MOVE.W #$8340,$00dff096
0000303E 33fc 7fff 00df f09e      MOVE.W #$7fff,$00dff09e
00003046 7e07                     MOVE.L #$00000007,D7
00003048 41f9 00df f140           LEA.L $00dff140,A0
0000304E 3080                     MOVE.W D0,(A0)
00003050 5048                     ADDA.W #$00000008,A0
00003052 51cf fffa                DBF .W D7,#$fffa == $0000304e (F)
00003056 7e03                     MOVE.L #$00000003,D7
00003058 41f9 00df f0a8           LEA.L $00dff0a8,A0
0000305E 3080                     MOVE.W D0,(A0)
00003060 41e8 0010                LEA.L (A0, $0010) == $00037298,A0
00003064 51cf fff8                DBF .W D7,#$fff8 == $0000305e (F)
00003068 41f9 00df f180           LEA.L $00dff180,A0
0000306E 7e1f                     MOVE.L #$0000001f,D7
00003070 30c0                     MOVE.W D0,(A0)+
00003072 51cf fffc                DBF .W D7,#$fffc == $00003070 (F)
00003076 13fc 007f 00bf ed01      MOVE.B #$7f,$00bfed01
0000307E 13c0 00bf ee01           MOVE.B D0,$00bfee01
00003084 13c0 00bf ef01           MOVE.B D0,$00bfef01
0000308A 13c0 00bf e001           MOVE.B D0,$00bfe001
00003090 13fc 0003 00bf e201      MOVE.B #$03,$00bfe201
00003098 13c0 00bf e101           MOVE.B D0,$00bfe101
0000309E 13fc 00ff 00bf e301      MOVE.B #$ff,$00bfe301
000030A6 13fc 007f 00bf dd00      MOVE.B #$7f,$00bfdd00
000030AE 13c0 00bf de00           MOVE.B D0,$00bfde00
000030B4 13c0 00bf df00           MOVE.B D0,$00bfdf00
000030BA 13fc 00c0 00bf d000      MOVE.B #$c0,$00bfd000
000030C2 13fc 00c0 00bf d200      MOVE.B #$c0,$00bfd200
000030CA 13fc 00ff 00bf d100      MOVE.B #$ff,$00bfd100
000030D2 13fc 00ff 00bf d300      MOVE.B #$ff,$00bfd300
000030DA 4ff9 0005 a36c           LEA.L $0005a36c,A7
000030E0 7e02                     MOVE.L #$00000002,D7
000030E2 41f9 0000 31a4           LEA.L $000031a4,A0
000030E8 43f9 0000 0064           LEA.L $00000064,A1
000030EE 22d8                     MOVE.L (A0)+,(A1)+
000030F0 51cf fffc                DBF .W D7,#$fffc == $000030ee (F)
000030F4 33fc ff00 00df f034      MOVE.W #$ff00,$00dff034
000030FC 33c0 00df f036           MOVE.W D0,$00dff036
00003102 0039 00ff 00bf d100      OR.B #$ff,$00bfd100
0000310A 0239 0087 00bf d100      AND.B #$87,$00bfd100
00003112 0239 0087 00bf d100      AND.B #$87,$00bfd100
0000311A 0039 00ff 00bf d100      OR.B #$ff,$00bfd100
00003122 13fc 00f0 00bf e601      MOVE.B #$f0,$00bfe601
0000312A 13fc 0037 00bf eb01      MOVE.B #$37,$00bfeb01
00003132 13fc 0011 00bf ef01      MOVE.B #$11,$00bfef01
0000313A 13fc 0091 00bf d600      MOVE.B #$91,$00bfd600
00003142 13c0 00bf db00           MOVE.B D0,$00bfdb00
00003148 13c0 00bf df00           MOVE.B D0,$00bfdf00
0000314E 33fc 7fff 00df f09c      MOVE.W #$7fff,$00dff09c
00003156 4a39 00bf ed01           TST.B $00bfed01
0000315C 13fc 008a 00bf ed01      MOVE.B #$8a,$00bfed01
00003164 4a39 00bf dd00           TST.B $00bfdd00
0000316A 13fc 0093 00bf dd00      MOVE.B #$93,$00bfdd00
00003172 33fc e078 00df f09a      MOVE.W #$e078,$00dff09a
0000317A 303c 1200                MOVE.W #$1200,D0
0000317E 4eb9 0007 c80e           JSR $0007c80e
00003184 4eb9 0007 c854           JSR $0007c854
0000318A 6100 05ae                BSR.W #$05ae == $0000373a
0000318E 41f9 0000 31bc           LEA.L $000031bc,A0
00003194 6100 04e8                BSR.W #$04e8 == $0000367e
00003198 6100 0554                BSR.W #$0554 == $000036ee
0000319C 6000 0936                BT .W #$0936 == $00003ad4 (T)


000031A0 ffff                     ILLEGAL 
000031A2 fffe                     ILLEGAL 

interrupt_handlers_table
000031A4 0000 32b4                OR.B #$b4,D0
000031A8 0000 32ec                OR.B #$ec,D0
000031AC 0000 3312                OR.B #$12,D0
000031B0 0000 334e                OR.B #$4e,D0
000031B4 0000 3364                OR.B #$64,D0
000031B8 0000 338a                OR.B #$8a,D0

copper_list
000031BC 2c01                     MOVE.L D1,D6
000031BE fffe                     ILLEGAL 
000031C0 010a 0002                MVPMR.W (A2, $0002) == $00069eda,D0
000031C4 0108 0002                MVPMR.W (A0, $0002) == $0003728a,D0
000031C8 00e2                     ILLEGAL 
000031CA 8dce                     ILLEGAL 
000031CC 00e0                     ILLEGAL 
000031CE 0006 00e6                OR.B #$e6,D6
000031D2 aa5a                     ILLEGAL 
000031D4 00e4                     ILLEGAL 
000031D6 0006 00ea                OR.B #$ea,D6
000031DA c6e6                     MULU.W -(A6),D3
000031DC 00e8 0006 00ee           [ CHK2.B #$0006,(A0, $00ee) == $00037376 ]
000031DE 0006 00ee                OR.B #$ee,D6
000031E2 e372                     ROXL.W D1,D2
000031E4 00ec 0006 0182           [ CHK2.B #$0006,(A4, $0182) == $00dff182 ]
000031E6 0006 0182                OR.B #$82,D6
000031EA 0446 0184                SUB.W #$0184,D6
000031EE 088a                     ILLEGAL 
000031F0 0186                     BCLR.L D0,D6
000031F2 0cce                     ILLEGAL 
000031F4 0188 0048                MVPRM.W D0,(A0, $0048) == $000372d0
000031F8 018a 028c                MVPRM.W D0,(A2, $028c) == $0006a164
000031FC 018c 0c64                MVPRM.W D0,(A4, $0c64) == $00dffc64
00003200 018e 0a22                MVPRM.W D0,(A6, $0a22) == $00005394
00003204 0190                     BCLR.B D0,(A0)
00003206 06a6 0192 0c4a           ADD.L #$01920c4a,-(A6)
0000320C 0194                     BCLR.B D0,(A4)
0000320E 0ec6                     ILLEGAL 
00003210 0196                     BCLR.B D0,(A6)
00003212 0e88                     ILLEGAL 
00003214 0198                     BCLR.B D0,(A0)+
00003216 0600 019a                ADD.B #$9a,D0
0000321A 0262 019c                AND.W #$019c,-(A2)
0000321E 0668 019e 06ae           ADD.W #$019e,(A0, $06ae) == $00037936
00003224 da01                     ADD.B D1,D5
00003226 fffe                     ILLEGAL 
00003228 010a 0000                MVPMR.W (A2, $0000) == $00069ed8,D0
0000322C 0108 0000                MVPMR.W (A0, $0000) == $00037288,D0
00003230 00e2                     ILLEGAL 
00003232 c89a                     AND.L (A2)+,D4
00003234 00e0                     ILLEGAL 
00003236 0007 00e6                OR.B #$e6,D7
0000323A d01a                     ADD.B (A2)+,D0
0000323C 00e4                     ILLEGAL 
0000323E 0007 00ea                OR.B #$ea,D7
00003242 d79a                     ADD.L D3,(A2)+
00003244 00e8 0007 00ee           [ CHK2.B #$0007,(A0, $00ee) == $00037376 ]
00003246 0007 00ee                OR.B #$ee,D7
0000324A df1a                     ADD.B D7,(A2)+
0000324C 00ec 0007 0180           [ CHK2.B #$0007,(A4, $0180) == $00dff180 ]
0000324E 0007 0180                OR.B #$80,D7
00003252 0000 0182                OR.B #$82,D0
00003256 0060 0184                OR.W #$0184,-(A0)
0000325A 0fff                     ILLEGAL 
0000325C 0186                     BCLR.L D0,D6
0000325E 0008                     ILLEGAL 
00003260 0188 0a22                MVPRM.W D0,(A0, $0a22) == $00037caa
00003264 018a 0444                MVPRM.W D0,(A2, $0444) == $0006a31c
00003268 018c 0862                MVPRM.W D0,(A4, $0862) == $00dff862
0000326C 018e 0666                MVPRM.W D0,(A6, $0666) == $00004fd8
00003270 0190                     BCLR.B D0,(A0)
00003272 0888                     ILLEGAL 
00003274 0192                     BCLR.B D0,(A2)
00003276 0aaa 0194 0a40 0196      EOR.L #$01940a40,(A2, $0196) == $0006a06e
0000327E 0c60 0198                CMP.W #$0198,-(A0)
00003282 0e80                     ILLEGAL 
00003284 019a                     BCLR.B D0,(A2)+
00003286 0ea0 019c                [ MOVES.L -(A0),D0 ]
00003288 019c                     BCLR.B D0,(A4)+
0000328A 0ec0                     ILLEGAL 
0000328C 019e                     BCLR.B D0,(A6)+
0000328E 0eee ffff fffe           [ CAS.L #$ffff,(A6, -$0002) == $00004970 ]

00003290 ffff                     ILLEGAL 
00003292 fffe                     ILLEGAL 


                    ;------------------- 16 colours for the Panel ---------------------
panel_colours                                       ; original address L00003294
00003294 0000 0060
00003298 0fff
0000329A 0008
0000329C 0a22 0444
000032A0 0862 0666
000032A4 0888
000032A6 0aaa 0a40 0c60 0e80
000032AE 0ea0 
000032B0 0ec0
000032B2 0eee

                    ; -------------------- level 1 - interrupt handler --------------------
                    ; TBE, DSKBLK, SOFT - Interrupts, just clear the bits from INTREQ
                    ;  NB: not enabled by init_system above
                    ;
level1_interrupt_handler                            ; original addr: 000032B4
000032B4 2f00                     MOVE.L D0,-(A7)
000032B6 3039 00df f01e           MOVE.W $00dff01e,D0
000032BC 0800 0002                BTST.L #$0002,D0
000032C0 661e                     BNE.B #$0000001e == $000032e0 (F)
000032C2 0800 0001                BTST.L #$0001,D0
000032C6 660c                     BNE.B #$0000000c == $000032d4 (F)
000032C8 33fc 0001 00df f09c      MOVE.W #$0001,$00dff09c
000032D0 201f                     MOVE.L (A7)+,D0
000032D2 4e73                     RTE 

000032D4 33fc 0002 00df f09c      MOVE.W #$0002,$00dff09c
000032DC 201f                     MOVE.L (A7)+,D0
000032DE 4e73                     RTE 

000032E0 33fc 0004 00df f09c      MOVE.W #$0004,$00dff09c
000032E8 201f                     MOVE.L (A7)+,D0
000032EA 4e73                     RTE 

000032EC 2f00                     MOVE.L D0,-(A7)
000032EE 1039 00bf ed01           MOVE.B $00bfed01,D0
000032F4 6a10                     BPL.B #$00000010 == $00003306 (T)
000032F6 6100 00d0                BSR.W #$00d0 == $000033c8
000032FA 33fc 0008 00df f09c      MOVE.W #$0008,$00dff09c
00003302 201f                     MOVE.L (A7)+,D0
00003304 4e73                     RTE 

00003306 33fc 0008 00df f09c      MOVE.W #$0008,$00dff09c
0000330E 201f                     MOVE.L (A7)+,D0
00003310 4e73                     RTE 

00003312 2f00                     MOVE.L D0,-(A7)
00003314 3039 00df f01e           MOVE.W $00dff01e,D0
0000331A 0800 0004                BTST.L #$0004,D0
0000331E 6622                     BNE.B #$00000022 == $00003342 (F)
00003320 0800 0005                BTST.L #$0005,D0
00003324 660c                     BNE.B #$0000000c == $00003332 (F)
00003326 33fc 0040 00df f09c      MOVE.W #$0040,$00dff09c
0000332E 201f                     MOVE.L (A7)+,D0
00003330 4e73                     RTE 

00003332 6100 01e6                BSR.W #$01e6 == $0000351a
00003336 33fc 0020 00df f09c      MOVE.W #$0020,$00dff09c
0000333E 201f                     MOVE.L (A7)+,D0
00003340 4e73                     RTE 

00003342 33fc 0010 00df f09c      MOVE.W #$0010,$00dff09c
0000334A 201f                     MOVE.L (A7)+,D0
0000334C 4e73                     RTE 

0000334E 2f00                     MOVE.L D0,-(A7)
00003350 3039 00df f01e           MOVE.W $00dff01e,D0
00003356 0240 0780                AND.W #$0780,D0
0000335A 33c0 00df f09a           MOVE.W D0,$00dff09a
00003360 201f                     MOVE.L (A7)+,D0
00003362 4e73                     RTE 

00003364 2f00                     MOVE.L D0,-(A7)
00003366 3039 00df f01e           MOVE.W $00dff01e,D0
0000336C 0800 000c                BTST.L #$000c,D0
00003370 660c                     BNE.B #$0000000c == $0000337e (F)
00003372 33fc 0800 00df f09c      MOVE.W #$0800,$00dff09c
0000337A 201f                     MOVE.L (A7)+,D0
0000337C 4e73                     RTE 

0000337E 33fc 1000 00df f09c      MOVE.W #$1000,$00dff09c
00003386 201f                     MOVE.L (A7)+,D0
00003388 4e73                     RTE 

0000338A 2f00                     MOVE.L D0,-(A7)
0000338C 3039 00df f01e           MOVE.W $00dff01e,D0
00003392 0800 000e                BTST.L #$000e,D0
00003396 6624                     BNE.B #$00000024 == $000033bc (F)
00003398 1039 00bf dd00           MOVE.B $00bfdd00,D0
0000339E 6a10                     BPL.B #$00000010 == $000033b0 (T)
000033A0 6100 0166                BSR.W #$0166 == $00003508
000033A4 33fc 2000 00df f09c      MOVE.W #$2000,$00dff09c
000033AC 201f                     MOVE.L (A7)+,D0
000033AE 4e73                     RTE 



000033B0 33fc 2000 00df f09c      MOVE.W #$2000,$00dff09c
000033B8 201f                     MOVE.L (A7)+,D0
000033BA 4e73                     RTE 

000033BC 33fc 4000 00df f09c      MOVE.W #$4000,$00dff09c
000033C4 201f                     MOVE.L (A7)+,D0
000033C6 4e73                     RTE 

000033C8 e408                     LSR.B #$00000002,D0
000033CA 6404                     BCC.B #$00000004 == $000033d0 (T)
000033CC 6100 016a                BSR.W #$016a == $00003538
000033D0 e408                     LSR.B #$00000002,D0
000033D2 646e                     BCC.B #$0000006e == $00003442 (T)
000033D4 48e7 6080                MOVEM.L D1-D2/A0,-(A7)
000033D8 1239 00bf ec01           MOVE.B $00bfec01,D1
000033DE 4601                     NOT.B D1
000033E0 e209                     LSR.B #$00000001,D1
000033E2 6416                     BCC.B #$00000016 == $000033fa (T)
000033E4 41f9 0000 34e8           LEA.L $000034e8,A0
000033EA 4881                     EXT.W D1
000033EC 123b 1056                MOVE.B (PC, D1.W*1, $56) == $0000348c,D1
000033F0 3401                     MOVE.W D1,D2
000033F2 e64a                     LSR.W #$00000003,D2
000033F4 03b0 2000                BCLR.B D1,(A0, D2.W*1, $00) == $00037288
000033F8 603c                     BT .B #$0000003c == $00003436 (T)
000033FA 41f9 0000 34e8           LEA.L $000034e8,A0
00003400 4881                     EXT.W D1
00003402 123b 1040                MOVE.B (PC, D1.W*1, $40) == $0000348c,D1
00003406 3401                     MOVE.W D1,D2
00003408 e64a                     LSR.W #$00000003,D2
0000340A 03f0 2000                BSET.B D1,(A0, D2.W*1, $00) == $00037288
0000340E 4a01                     TST.B D1
00003410 6724                     BEQ.B #$00000024 == $00003436 (T)
00003412 41f9 0000 34c4           LEA.L $000034c4,A0
00003418 3439 0000 34e4           MOVE.W $000034e4,D2
0000341E 1181 2000                MOVE.B D1,(A0, D2.W*1, $00) == $00037288
00003422 5242                     ADD.W #$00000001,D2
00003424 0242 001f                AND.W #$001f,D2
00003428 b479 0000 34e6           CMP.W $000034e6,D2
0000342E 6706                     BEQ.B #$00000006 == $00003436 (T)
00003430 33c2 0000 34e4           MOVE.W D2,$000034e4
00003436 13fc 0040 00bf ee01      MOVE.B #$40,$00bfee01
0000343E 4cdf 0106                MOVEM.L (A7)+,D1-D2/A0
00003442 4e75                     RTS 


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


00003508 e408                     LSR.B #$00000002,D0
0000350A 6408                     BCC.B #$00000008 == $00003514 (T)
0000350C 13fc 0000 00bf ee01      MOVE.B #$00,$00bfee01
00003514 4e75                     RTS 

00003516 dc.l $00003536                 ; L00003542 ; unused ptr to 'rts' below

0000351A 48e7 7ffe                MOVEM.L D1-D7/A0-A6,-(A7)
0000351E 5279 0000 36e2           ADD.W #$00000001,$000036e2
00003524 4eb9 0004 8018           JSR $00048018
0000352A 13fc 0000 00bf ee01      MOVE.B #$00,$00bfee01
00003532 4cdf 7ffe                MOVEM.L (A7)+,D1-D7/A0-A6
00003536 4e75                     RTS 

00003538 48e7 fffe                MOVEM.L D0-D7/A0-A6,-(A7)
0000353C 6100 001c                BSR.W #$001c == $0000355a
00003540 5279 0000 3558           ADD.W #$00000001,$00003558
00003546 2079 0000 3554           MOVEA.L $00003554,A0
0000354C 4e90                     JSR (A0)
0000354E 4cdf 7fff                MOVEM.L (A7)+,D0-D7/A0-A6
00003552 4e75                     RTS 

00003554 dc.l $00003536                 ; L00003542 ; CIAB - Timer B - Handler Routine - Default ptr to 'rts' @ $00003542
00003558 dc.w $06e6                     ; CIAB - Timer B - Ticker Count 

0000355A 3039 00df f00a           MOVE.W $00dff00a,D0
00003560 3239 0000 3624           MOVE.W $00003624,D1
00003566 33c0 0000 3624           MOVE.W D0,$00003624
0000356C 6100 0080                BSR.W #$0080 == $000035ee
00003570 13c0 0000 362b           MOVE.B D0,$0000362b
00003576 d379 0000 363a           ADD.W D1,$0000363a
0000357C d579 0000 363c           ADD.W D2,$0000363c
00003582 0839 0006 00bf e001      BTST.B #$0006,$00bfe001
0000358A 57f9 0000 362a           SEQ.B $0000362a == $0000362a (T)
00003590 57f9 0000 3638           SEQ.B $00003638 == $00003638 (T)
00003596 0839 0002 00df f016      BTST.B #$0002,$00dff016
0000359E 57f9 0000 3639           SEQ.B $00003639 == $00003639 (T)
000035A4 3039 00df f00c           MOVE.W $00dff00c,D0
000035AA 3239 0000 3626           MOVE.W $00003626,D1
000035B0 33c0 0000 3626           MOVE.W D0,$00003626
000035B6 6136                     BSR.B #$00000036 == $000035ee
000035B8 13c0 0000 362f           MOVE.B D0,$0000362f
000035BE d379 0000 3640           ADD.W D1,$00003640
000035C4 d579 0000 3642           ADD.W D2,$00003642
000035CA 0839 0007 00bf e001      BTST.B #$0007,$00bfe001
000035D2 57f9 0000 362e           SEQ.B $0000362e == $0000362e (T)
000035D8 57f9 0000 363e           SEQ.B $0000363e == $0000363e (T)
000035DE 0839 0006 00df f016      BTST.B #$0006,$00dff016
000035E6 57f9 0000 363f           SEQ.B $0000363f == $0000363f (T)
000035EC 4e75                     RTS 

000035EE 3600                     MOVE.W D0,D3
000035F0 3401                     MOVE.W D1,D2
000035F2 9203                     SUB.B D3,D1
000035F4 4401                     NEG.B D1
000035F6 4881                     EXT.W D1
000035F8 e04a                     LSR.W #$00000008,D2
000035FA e04b                     LSR.W #$00000008,D3
000035FC 9403                     SUB.B D3,D2
000035FE 4402                     NEG.B D2
00003600 4882                     EXT.W D2
00003602 7603                     MOVE.L #$00000003,D3
00003604 c640                     AND.W D0,D3
00003606 ec48                     LSR.W #$00000006,D0
00003608 0240 000c                AND.W #$000c,D0
0000360C 8043                     OR.W D3,D0
0000360E 103b 0004                MOVE.B (PC, D0.W*1, $04) == $00003641,D0
00003612 4e75                     RTS 

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


00003644 2f00                     MOVE.L D0,-(A7)
00003646 6106                     BSR.B #$00000006 == $0000364e
00003648 66fc                     BNE.B #$fffffffc == $00003646 (F)
0000364A 201f                     MOVE.L (A7)+,D0
0000364C 4e75                     RTS 
0000364E 48e7 6080                MOVEM.L D1-D2/A0,-(A7)
00003652 41f9 0000 34c4           LEA.L $000034c4,A0
00003658 7000                     MOVE.L #$00000000,D0
0000365A 4cb9 0006 0000 34e4      MOVEM.W $000034e4,D1-D2
00003662 b441                     CMP.W D1,D2
00003664 6710                     BEQ.B #$00000010 == $00003676 (T)
00003666 1030 2000                MOVE.B (A0, D2.W*1, $00) == $00037288,D0
0000366A 5242                     ADD.W #$00000001,D2
0000366C 0242 001f                AND.W #$001f,D2
00003670 33c2 0000 34e6           MOVE.W D2,$000034e6
00003676 4a00                     TST.B D0
00003678 4cdf 0106                MOVEM.L (A7)+,D1-D2/A0
0000367C 4e75                     RTS 


0000367E 33fc 0080 00df f096      MOVE.W #$0080,$00dff096
00003686 23c8 00df f080           MOVE.L A0,$00dff080
0000368C 33c8 00df f088           MOVE.W A0,$00dff088
00003692 33fc 0000 00df f10a      MOVE.W #$0000,$00dff10a
0000369A 33fc 0000 00df f108      MOVE.W #$0000,$00dff108
000036A2 33fc 0038 00df f092      MOVE.W #$0038,$00dff092
000036AA 33fc 00d0 00df f094      MOVE.W #$00d0,$00dff094
000036B2 33fc 3080 00df f08e      MOVE.W #$3080,$00dff08e
000036BA 33fc 0ac0 00df f090      MOVE.W #$0ac0,$00dff090
000036C2 33fc 4200 00df f100      MOVE.W #$4200,$00dff100
000036CA 4279 0000 36e2           CLR.W $000036e2
000036D0 4a79 0000 36e2           TST.W $000036e2
000036D6 67f8                     BEQ.B #$fffffff8 == $000036d0 (T)
000036D8 33fc 8180 00df f096      MOVE.W #$8180,$00dff096
000036E0 4e75                     RTS 
