


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
L0000306E            MOVE.L  #$0000001f,D7
L00003070            MOVE.W  D0,(A0)+
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

                    ; ------ enter supervisor mode -------
.enter_supervisor   LEA.L   .supervisor_trap(PC),A0         ; A0 = address of supervisor trap $00001F58
                    MOVE.L  A0,$00000080                    ; Set TRAP 0 vector
                    MOVEA.L A7,A0                           ; store stack pointer
                    TRAP    #$00000000                      ; do the trap (jmp to next instruction in supervisor mode)
                    ; this trap never returns.
                    ; enter supervisor mode
.supervisor_trap    MOVEA.L A0,A7                           ; restore the stack (i.e. rts return address etc)
                    ; ------ enter supervisor mode -------

                    ;jsr     _DEBUG_COLOURS

                    ; set stack address
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

L0000317A            MOVE.W  #$1200,D0 ; timer 12:00 BCD
L0000317E            JSR     $0007c80e                       ; PANEL
L00003184            JSR     $0007c854                       ; PANEL

L0000318A            BSR.W   L0000373a
L0000318E            LEA.L   L000031bc,A0 ; Copper
L00003194            BSR.W   L0000367e
L00003198            BSR.W   L000036ee
L0000319C            BRA.W   L00003ad4 ; Initialise game


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
L00003294           dc.w    $0000,$0060,$0fff,$0008
                    dc.w    $0a22,$0444,$0862,$0666
                    dc.w    $0888,$0aaa,$0a40,$0c60
                    dc.w    $0e80,$0ea0,$0ec0,$0eee

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
L00003444                
                        dc.b $27
                        dc.b $31 
                        dc.b $32
                        dc.b $33 
                        dc.b $34
                        dc.b $35 
                        dc.b $36
                        dc.b $37  
                        dc.b $38
                        dc.b $39 
                        dc.b $30
                        dc.b $2d 
                        dc.b $3d
                        dc.b $5c  
                        dc.b $00
                        dc.b $30 
                        dc.b $51
                        dc.b $57 
                        dc.b $45
                        dc.b $52 
                        dc.b $54
                        dc.b $59 
                        dc.b $55
                        dc.b $49 
                        dc.b $4f
                        dc.b $50 
                        dc.b $5b
                        dc.b $5d 
                        dc.b $00
                        dc.b $31 
                        dc.b $32
                        dc.b $33 
                        dc.b $41
                        dc.b $53 
                        dc.b $44
                        dc.b $46 
                        dc.b $47
                        dc.b $48 
                        dc.b $4a
                        dc.b $4b 
                        dc.b $4c
                        dc.b $3b
                        dc.b $23
                        dc.b $00
                        dc.b $00
                        dc.b $34 
                        dc.b $35
                        dc.b $36 
                        dc.b $00
                        dc.b $5a 
                        dc.b $58
                        dc.b $43 
                        dc.b $56
                        dc.b $42
                        dc.b $4e
                        dc.b $4d 
                        dc.b $2c
                        dc.b $2e 
                        dc.b $2f
                        dc.b $00  
                        dc.b $00
                        dc.b $37 
                        dc.b $38
                        dc.b $39 
                        dc.b $20
                        dc.b $08  
                        dc.b $09
                        dc.b $0d 
                        dc.b $0d
                        dc.b $1b
                        dc.b $7f
                        dc.b $00
                        dc.b $00
                        dc.b $00 
                        dc.b $2d
                        dc.b $00 
                        dc.b $8c
                        dc.b $8d
                        dc.b $8e
                        dc.b $8f
                        dc.b $81
                        dc.b $82
                        dc.b $83
                        dc.b $84
                        dc.b $85
                        dc.b $86
                        dc.b $87
                        dc.b $88
                        dc.b $89
                        dc.b $8a
                        dc.b $28
                        dc.b $29 
                        dc.b $2f
                        dc.b $2a
                        dc.b $2b
                        dc.b $8b 
                        dc.b $00
                        dc.b $00
                        dc.b $00
                        dc.b $00 
                        dc.b $00
                        dc.b $00
                        dc.b $00
                        dc.b $00 
                        dc.b $00
                        dc.b $00
                        dc.b $00
                        dc.b $00 
                        dc.b $00
                        dc.b $00
                        dc.b $00
                        dc.b $00 
                        dc.b $00
                        dc.b $00
                        dc.b $00
                        dc.b $00 
                        dc.b $00
                        dc.b $00
                        dc.b $00
                        dc.b $00 
                        dc.b $00
                        dc.b $00
                        dc.b $00
                        dc.b $00 
                        dc.b $00
                        dc.b $00
                        dc.b $00
                        dc.b $00
                    ; End of Keycode - Ascii lookup table

L000034C2                   dc.b $00,$00,$00,$00,$00,$00,$00,$00 
                            dc.b $00,$00,$00,$00,$00,$00,$00,$00
                            dc.b $00,$00,$00,$00,$00,$00,$00,$00
                            dc.b $00,$00,$00,$00,$00,$00,$00,$00 

L000034E2                   dc.w $0000
L000034E6                   dc.w $0000 

L000034E8                   dc.w $0000,$0000,$0000,$0000
                            dc.w $0000,$0000,$0000,$0000 

L000034F8                   dc.w $0000,$0000,$0000,$0000 
                            dc.w $0000,$0000,$0000,$0000 


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
L00003614                   dc.b    $00
                            dc.b    $04 
                            dc.b    $05
                            dc.b    $01
                            dc.b    $08
                            dc.b    $0c
L0000361A                   dc.b    $0d
                            dc.b    $09 
                            dc.b    $0a
                            dc.b    $0e
                            dc.b    $0f
                            dc.b    $0b
                            dc.b    $02
                            dc.b    $06
                            dc.b    $07
                            dc.b    $03 

L00003624                   dc.w    $d98c     
L00003626                   dc.w    $0000 
L00003628                   dc.w    $0000
L0000362A                   dc.b    $00
                            dc.b    $08      
L0000362C                   dc.w    $0000 
L0000362E                   dc.b    $00
                            dc.b    $00
L00003630                   dc.w    $0000 
L00003632                   dc.w    $0000
L00003634                   dc.w    $0000 
L00003636                   dc.w    $0000
L00003638                   dc.b    $00
                            dc.b    $00 
L0000363A                   dc.w    $f48c
L0000363C                   dc.w    $fdd9      
L0000363E                   dc.b    $00
                            dc.b    $00 
L00003640                   dc.w    $0000
L00003642                   dc.w    $0000 



                    ; -------------------- wait key --------------------
                    ; wait/loop until a key is pressed
                    ;
L00003644                   MOVE.L  D0,-(A7)
L00003646                   BSR.B   L0000364e
L00003648                   BNE.B   L00003646
L0000364A                   MOVE.L  (A7)+,D0
L0000364C                   RTS 



                    ; -------------------- get key --------------------
                    ; dequeue an ascii code from the keybaord queue
                    ;
                    ; OUT:
                    ;   d0.b    - Ascii code (0 if queue empty)
                    ;           - Z = 1 if queue is empty
                    ;
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




                    ;--------------- reset display -------------------
                    ; Set the copper list and 4 bitplane display,
                    ; reset bitplane modulos.
                    ; reset display fetch and window size (320x218)
                    ;
                    ; IN:
                    ;   a0 = copper list address
                    ;
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

L000036E2                   dc.w $0000
L000036E4                   dc.w $0000
L000036E6                   dc.l $00068dce 
L000036EA                   dc.l $00061b9c 




                    ; ----------------------- double buffer display playfield --------------------------
                    ; swap display buffer pointers and update the copper list display.
                    ; can wait for future frame count, typically waits for top of next frame.
                    ;
L000036EE                   MOVE.W  L000036e2,D0
L000036F2                   CMP.W   L000036e2,D0
L000036F6                   BEQ.B   L000036f2
L000036F8                   MOVE.W  L000036e4,D1
L000036FC                   CMP.W   D0,D1
L000036FE                   BPL.B   L000036ee 
L00003700                   ADD.W   #$0001,D0
L00003704                   MOVE.W  D0,L000036e4
L00003708                   MOVEM.L L000036e6,D0-D1
L0000370E                   EXG.L   D0,D1
L00003710                   MOVEM.L D0-D1,L000036e6
L00003716                   LEA.L   L000031ca,A0
L0000371A                   MOVE.L  #$00001c8c,D1
L00003720                   MOVE.L  #$00000003,D7
L00003722                   MOVE.W  D0,(A0)
L00003724                   ADDA.W  #$00000004,A0
L00003726                   SWAP.W  D0
L00003728                   MOVE.W  D0,(A0)
L0000372A                   ADDA.W  #$00000004,A0
L0000372C                   SWAP.W  D0
L0000372E                   ADD.L   D1,D0
L00003730                   DBF.W   D7,L00003722
L00003734                   ADD.W   #$00000001,L00006374
L00003738                   RTS 




                    ; ----------------------- clear display memory ---------------------------
                    ; Clear Double Buffer Display (back & front)
                    ; Clear Off-Screen Displaty Buffer
                    ;
L0000373A                   LEA.L   $00061b9c,A0        ; Screen Buffer
L00003740                   MOVE.W  #$3917,D7
L00003744                   CLR.L   (A0)+
L00003746                   DBF.W   D7,L00003744
L0000374A                   LEA.L   $0005a36c,A0        ; Screen Buffer
L00003750                   MOVE.W  #$1c8b,D7
L00003754                   CLR.L   (A0)+
L00003756                   DBF.W   D7,L00003754
L0000375A                   RTS 




                    ; ----------------------- debug print word value ------------------------
                    ; Debug print routine that converts an 16bit value into an ASCII string
                    ; and displays is in the 'Panel' area at the bottom of the screen.
                    ;
                    ; Doesn't appear to be in use by the code.
                    ; This code would be better suited as part of the Panel.s code.
                    ;
                    ; IN:
                    ;   d0 - 16bit value to be converted to ASCII characters for display
                    ;   d1 - Y,X co-ords for the display, 1 byte each.
                    ;
L0000375C               dc.w $0a0a
L0000375E               dc.b '0000' 
L00003762               dc.b $00,$ff 

L00003764               LEA.L   L0000375c,A0
L0000376A               MOVE.W  D1,(A0)
L0000376C               MOVE.L  #$00000003,D2
L0000376E               CLR.W   D1
L00003770               MOVE.W  D0,D1
L00003772               AND.W   #$000f,D1
L00003776               CMP.W   #$000a,D1
L0000377A               BCS.B   L0000377e
L0000377C               ADD.W   #$00000007,D1
L0000377E               ADD.B   #$30,D1
L00003782               MOVE.B  D1,$02(A0,D2.w)
L00003786               LSR.W   #$00000004,D0
L00003788               DBF.W   D2,L0000376e
L0000378C               MOVE.B  (A0)+,D0
L0000378E               CMP.B   #$ff,D0
L00003792               BEQ.B   L000037e2
L00003794               AND.W   #$00ff,D0
L00003798               MULU.W  #$0028,D0
L0000379C               MOVE.L  #$00000000,D1
L0000379E               MOVE.B  (A0)+,D1
L000037A0               ADD.W   D1,D0
L000037A2               MOVEA.L #$0007c89a,A1       ; Panel
L000037A8               LEA.L   $02(A1,D0.w),A1
L000037AC               MOVE.L  #$00000000,D0
L000037AE               MOVE.B  (A0)+,D0
L000037B0               BEQ.B   L0000378c
L000037B2               SUB.W   #$0020,D0
L000037B6               LSL.W   #$00000003,D0
L000037B8               LEA.L   L000037e4,A2
L000037BE               LEA.L   $00(A2,D0.w),A2
L000037C2               MOVE.L  #$00000007,D7
L000037C4               MOVEA.L A1,A3
L000037C6               MOVE.B  (A2),(A3)
L000037C8               MOVE.B  (A2),$0780(A3)
L000037CC               MOVE.B  (A2),$0f00(A3)
L000037D0               MOVE.B  (A2)+,$1680(A3)
L000037D4               LEA.L   $0028(A3),A3
L000037D8               DBF.W   D7,L000037c6
L000037DC               LEA.L   $0001(A1),A1
L000037E0               BRA.B   L000037ac
L000037E2               RTS 


                    ; -------------------------- 8x8 pixel font ----------------------
                    ; This font is used by the routine above.

L000037E4   dc.w $0000,$0000,$0000,$0000,$3030,$3030,$0030,$3000  ;........0000.00.
L000037F4   dc.w $3624,$0000,$0000,$0000,$6C9A,$BCFA,$7428,$1000  ;6$......l...t(..
L00003804   dc.w $7ED6,$D07C,$16D6,$FC00,$82C6,$FE54,$7C38,$1000  ;~..|.......T|8..
L00003814   dc.w $2874,$7474,$7420,$7400,$1810,$0000,$0000,$0000  ;(tttt t.........
L00003824   dc.w $3870,$7070,$7070,$3800,$381C,$1C1C,$1C1C,$3800  ;8ppppp8.8.....8.
L00003834   dc.w $1054,$28D6,$2854,$1000,$0000,$0808,$3E08,$0800  ;.T(.(T......>...
L00003844   dc.w $0000,$0000,$0008,$0810,$0000,$0000,$3E00,$0000  ;............>...
L00003854   dc.w $0000,$0000,$0018,$1800,$3078,$B078,$3478,$3000  ;........0x.x4x0.
L00003864   dc.w $7CE6,$E6E6,$E6E6,$7C00,$7838,$3838,$3838,$3800  ;|.....|.x888888.
L00003874   dc.w $7CCE,$0E7C,$C0CE,$FE00,$7CCE,$0E3C,$0ECE,$7C00  ;|..|....|..<..|.
L00003884   dc.w $7CDC,$DCDC,$FE1C,$1C00,$FEE6,$E0FC,$06E6,$7C00  ;|.............|.
L00003894   dc.w $7CE6,$E0FC,$E6E6,$7C00,$FECE,$0E1C,$1C38,$3800  ;|.....|......88.
L000038A4   dc.w $7CE6,$E67C,$E6E6,$7C00,$7CE6,$E67E,$06E6,$7C00  ;|..|..|.|..~..|.
L000038B4   dc.w $0030,$3000,$0030,$3000,$0030,$3000,$3030,$6000  ;.00..00..00.00`.
L000038C4   dc.w $1C38,$70E0,$7038,$1C00,$007C,$7C00,$7C7C,$0000  ;.8p.p8...||.||..
L000038D4   dc.w $E070,$381C,$3870,$E000,$7CEE,$CE3C,$3000,$3000  ;.p8.8p..|..<0.0.
L000038E4   dc.w $003C,$4A56,$5E40,$3C00,$7CE6,$E6FE,$E6E6,$E600  ;.<JV^@<.|.......
L000038F4   dc.w $FCE6,$E6FC,$E6E6,$FC00,$7CE6,$E6E0,$E6E6,$7C00  ;........|.....|.
L00003904   dc.w $FCE6,$E6E6,$E6E6,$FC00,$FEE0,$E0FE,$E0E0,$FE00  ;................
L00003914   dc.w $FEE0,$E0FE,$E0E0,$E000,$7CE6,$E6E0,$EEE6,$7E00  ;........|.....~.
L00003924   dc.w $E6E6,$E6FE,$E6E6,$E600,$3838,$3838,$3838,$3800  ;........8888888.
L00003934   dc.w $0E0E,$0E0E,$0E0E,$FC00,$E6E6,$E4F8,$E4E6,$E600  ;................
L00003944   dc.w $E0E0,$E0E0,$E0E0,$FE00,$FCDA,$DADA,$DADA,$DA00  ;................
L00003954   dc.w $FCE6,$E6E6,$E6E6,$E600,$7CE6,$E6E6,$E6E6,$7C00  ;........|.....|.
L00003964   dc.w $FCE6,$E6E6,$FCE0,$E000,$7CE6,$E6E2,$ECEE,$7600  ;........|.....v.
L00003974   dc.w $FCE6,$E6FC,$E6E6,$E600,$7CE6,$F87C,$1EE6,$7C00  ;........|..|..|.
L00003984   dc.w $FE38,$3838,$3838,$3800,$E6E6,$E6E6,$E6E6,$7C00  ;.888888.......|.
L00003994   dc.w $E6E6,$E6E6,$E664,$3800,$DADA,$DADA,$DADA,$7C00  ;.....d8.......|.
L000039A4   dc.w $E6E6,$E638,$CECE,$CE00,$E6E6,$E67C,$3838,$3800  ;...8.......|888.
L000039B4   dc.w $FEEE,$DC38,$76E6,$FE00,$0000,$0119,$003A,$0097  ;...8v........:..
L000039C4   dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  ;................
L000039D4   dc.w $00A0,$0038,$0046,$0000,$0000,$0000,$0000,$0000  ;...8.F..........
L000039E4   dc.w $0000,$0000,$0000,$00A0,$0038,$0046,$0000,$0000  ;.........8.F....
L000039F4   dc.w $0000,$0000,$0000,$0000,$0000,$0000,$00A0,$0038  ;...............8
L00003A04   dc.w $0046,$0000,$0000,$0000,$0000,$0000,$0000,$0000  ;.F..............
L00003A14   dc.w $0000,$00A0,$0038,$0046,$0000,$0000,$0000,$0000  ;.....8.F........
L00003A24   dc.w $0000,$0000,$0000,$0000,$00A0,$0038,$0046,$0000  ;...........8.F..
L00003A34   dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$00A0  ;................
L00003A44   dc.w $0038,$0046,$0000,$0000,$0000,$0000,$0000,$0000  ;.8.F............
L00003A54   dc.w $0000,$0000,$00A0,$0038,$0046,$0000,$0000,$0000  ;.......8.F......
L00003A64   dc.w $0000,$0000,$0000,$0000,$0000,$00A0,$0038,$0046  ;.............8.F
L00003A74   dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  ;................
L00003A84   dc.w $00A0,$0038,$0046,$0000,$0000,$0000,$0000,$0000  ;...8.F..........
L00003A94   dc.w $0000,$0000,$5009,$474F,$5448,$414D,$2043,$4954  ;....P.GOTHAM CIT
L00003AA4   dc.w $5920,$4341,$5448,$4544,$5241,$4C00,$FF40,$1054  ;Y CATHEDRAL..@.T
L00003AB4   dc.w $4845,$2045,$4E44,$2E00,$FF60,$0B46,$4F52,$2054  ;HE END...`.FOR T
L00003AC4   dc.w $4845,$2054,$494D,$4520,$4245,$494E,$472E,$00FF  ;HE TIME BEING...




                    ; ----------------------- start game ------------------------
                    ; Called after the system is initialised, initialise the
                    ; game level & play the game loop
                    ;
initialise_game    
L00003AD4               CLR.L   $000036e2
L00003ADA               BSR.W   L000036ee
L00003ADE               BSR.W   L00005922
L00003AE2               JSR     $00048000       ; Audio
L00003AE8               CLR.W   L00006344
L00003AEC               CLR.W   L00006360
L00003AF0               CLR.L   L000036e2
L00003AF6               BSR.W   L0000373a
L00003AFA               MOVE.W  #$1200,D0
L00003AFE               JSR     L0007c80e       ; Panel
L00003B04               JSR     L0007c854       ; Panel
L00003B0A               BSR.W   L00003d2a
L00003B0E               LEA.L   $0000807c,A0    ; Mapgr
L00003B14               MOVEA.L L00005fac,A5
L00003B1A               MOVEM.W (A5)+,D2-D4
L00003B1E               TST.W D3
L00003B20               BEQ.B   L00003b38
L00003B22               MOVE.B  D2,$01(A0,D3.w)
L00003B26               LSR.W   #$00000008,D2
L00003B28               MOVE.B  D2,$00(A0,D3.w)
L00003B2C               MOVE.B  D4,$03(A0,D3.w)
L00003B30               LSR.W   #$00000008,D4
L00003B32               MOVE.B  D4,$02(A0,D3.w)
L00003B36               BRA.B   L00003b1a 

L00003B38               MOVE.L  #$0000600c,L00005fac
L00003B42               LEA.L   L000048d2,A0
L00003B46               MOVE.L  #$00000027,D7
L00003B48               CLR.L   (A0)+
L00003B4A               DBF.W   D7,L00003b48

L00003B4E               LEA.L   L00006476,A0
L00003B52               BCLR.B  #$0007,(A0)
L00003B56               MOVE.W  $0004(A0),D0
L00003B5A               MULU.W  #$0006,D0
L00003B5E               LEA.L   $06(A0,D0.w),A0
L00003B62               CMPA.W  #$6944,A0
L00003B66               BCS.B   L00003b52
L00003B68               BCLR.B  #$0007,$0004(A0)
L00003B6E               ADDA.W  #$00000006,A0
L00003B70               CMPA.W  #$69c2,A0
L00003B74               BCS.B   L00003b68


L00003B76               LEA.L   L000039bc,A0
L00003B7A               MOVE.L  #$0000006d,D7
L00003B7C               CLR.W   (A0)+
L00003B7E               DBF.W   D7,L00003b7c
L00003B82               CLR.W   L00006336
L00003B86               LEA.L   L0000641b,A0
L00003B8A               BSR.W   L00005470
L00003B8E               MOVE.W  #$4c7c,L00003c7c
L00003B94               LEA.L   L000069c2,A0
L00003B98               MOVE.W  L00006344,D6
L00003B9C               MOVE.L  #$00000006,D7
L00003B9E               LEA.L   L000069ec,A1
L00003BA2               MOVE.W  (A0)+,(A1)+
L00003BA4               DBF.W   D7,L00003ba2
L00003BA8               DBF.W   D6,L00003b9c
L00003BAC               LEA.L   L00003a98,A0
L00003BB0               BSR.W   L000069fa
L00003BB4               BSR.W   L000036ee
L00003BB8               BSR.W   L000058ea
L00003BBC               BSR.W   L00004ba0
L00003BC0               BSR.W   L00005604
L00003BC4               MOVE.L  #$00000032,D0
L00003BC6               BSR.W   L00005ed4
L00003BCA               BTST.B  #$0000,$0007c875    ; Panel
L00003BD2               BNE.B   L00003bdc
L00003BD4               MOVE.L  #$00000001,D0
L00003BD6               JSR     $00048010           ; Audio?
L00003BDC               BSR.W   L00003caa
L00003BE0               CLR.L   L000036e2

game_loop
L00003BE4               BSR.W   L0000364e
L00003BE8               BEQ.B   L00003c44
L00003BEA               CMP.W   #$0081,D0
L00003BEE               BNE.B   L00003c0c
L00003BF0               BSR.W   L0000364e
L00003BF4               BEQ.B   L00003bf0
L00003BF6               CMP.W   #$001b,D0
L00003BFA               BNE.B   L00003c0c
L00003BFC               BSR.W   L00003ca6
L00003C00               BSET.B  #$0005,$0007c875           ; Panel
L00003C08               BRA.W   L00004e3e
L00003C0C               CMP.W   #$0082,D0
L00003C10               BNE.B   L00003c32
L00003C12               BCHG.B  #$0000,$0007c875    ; Panel
L00003C1A               BNE.B   L00003c26
L00003C1C               JSR     $00048008           ; external
L00003C22               BRA.W   L00003c44
L00003C26               MOVE.L  #$00000001,D0
L00003C28               JSR     $00048010           ; external
L00003C2E               BRA.W   L00003c44
L00003C32               CMP.W   #$008a,D0
L00003C36               BNE.B   L00003c44
L00003C38               BTST.B  #$0007,$0007c875    ; Panel
L00003C40               BNE.W   L00005e7a
L00003C44               BTST.B  #$0000,$0007c874    ; Panel
L00003C4C               BNE.B   L00003c6a
L00003C4E               JSR     $0007c800           ; panel
L00003C54               JSR     $0007c800           ; panel
L00003C5A               BTST.B  #$0000,$0007c874    ; panel
L00003C62               BEQ.B   L00003c6a
L00003C64               MOVE.L  #$00000001,D6
L00003C66               BSR.W   L00004d22
L00003C6A               CLR.L   D0
L00003C6C               CLR.L   D1
L00003C6E               BSR.W   L00005894
L00003C72               MOVEM.W L000069f2,D0-D1

                    ; ----- PLAYER STATE - SELF MODIFYING CODE -----
                    ; updated all over the place to run an alternative routine.
                    ; a bit of a state machine kinda update routine.
;L00003C78               JSR     L00004c7c
L00003C78               dc.w    $4eb9
L00003C7A               dc.l    $00000000
                    ; ----- END OF SELF MODIFYING CODE -----

L00003C7E               BSR.W   L00004974
L00003C82               BSR.W   L00003dbe
L00003C86               BSR.W   L00003dec
L00003C8A               BSR.W   L00004ba0
L00003C8E               BSR.W   L00005604
L00003C92               BSR.W   L00003ed4
L00003C96               BSR.W   L00004696
L00003C9A               BSR.W   L0000463c
L00003C9E               BSR.W   L000036ee
L00003CA2               BRA.W   L00003be4      ; game_loop


