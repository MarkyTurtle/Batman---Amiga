


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

update_level_data
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
.exit_update_level_data   
L00003B38               MOVE.L  #$0000600c,L00005fac

clear_projectile_data 
L00003B42               LEA.L   L000048d2,A0
L00003B46               MOVE.L  #$00000027,D7
L00003B48               CLR.L   (A0)+
L00003B4A               DBF.W   D7,L00003b48

                    ; ------------ reset actors/triggers -------------
                    ; clear MSB flag of each data structure
clear_msb 
L00003B4E               LEA.L   L00006476,A0
L00003B52               BCLR.B  #$0007,(A0)
L00003B56               MOVE.W  $0004(A0),D0
L00003B5A               MULU.W  #$0006,D0
L00003B5E               LEA.L   $06(A0,D0.w),A0
L00003B62               CMPA.W  #$6944,A0
L00003B66               BCS.B   L00003b52

                    ; clear MSB flag of each data structure
                    ; original address L00003b7e  
L00003B68               BCLR.B  #$0007,$0004(A0)
L00003B6E               ADDA.W  #$00000006,A0
L00003B70               CMPA.W  #$69c2,A0
L00003B74               BCS.B   L00003b68

                    ; Clear Active Actors List? 
L00003B76               LEA.L   L000039bc,A0
L00003B7A               MOVE.L  #$0000006d,D7
L00003B7C               CLR.W   (A0)+
L00003B7E               DBF.W   D7,L00003b7c

                    ; ------ Set initial batman sprite ids ----- 
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

                    ;-----------------------------------------------------
                    ;------------------ End of Game Loop -----------------
                    ;-----------------------------------------------------
                    ; code1.s - line1871


                    ; -------------- Wipe Screen to Black ----------------
                    ; Perform screen wipe to black.
                    ;   - Clears back buffer
                    ;   - falls through to screen_wipe_to_backbuffer
                    ;
screen_wipe_to_black
L00003ca6               bsr.w L00004e66

                    ; ---------------- Wipe Screen to Back buffer ---------------------
                    ; Gradually replace the current display buffer with the gfx from
                    ; the back buffer. Used to fade from display text to level gfx
                    ; at the start of the level. 'Axis Chemical Factory' screen on
                    ; start-up etc.
                    ; Probably works a bit like the CD randomise play, a psuedo random
                    ; generator which doesn't pick the same two numbers twice until
                    ; the entire sequence has been selected.
                    ;   - that particular routine would use the modulo of a prime
                    ;       number (much larger than the dataset) to loop through
                    ;       the data (wrapping around back to the start)
                    ;   - not sure if this does that, may take a look in the future.
                    ;   
                    ;   for now, knowing what the routine does it good enough.
                    ; 
screen_wipe_to_backbuffer
L00003caa               move.w  #$002a,d0
L00003cae               move.w  #$00ae,d1
L00003cb2               movem.l L000036e6,a0-a1
L00003cb8               clr.w   d2
L00003cba               moveq   #$7f,d3
L00003cbc               and.w   d2,d3
L00003cbe               moveq   #$0f,d5
L00003cc0               lsr.w   #$01,d3
L00003cc2               bcc.b   L00003cc6
L00003cc4               moveq   #$f0,d5
L00003cc6               cmp.w   d0,d3
L00003cc8               bcc.b   L00003d1c
L00003cca               move.w  d2,d4
L00003ccc               lsr.w   #$05,d4
L00003cce               and.w   #$00fc,d4
L00003cd2               cmp.w   d1,d4
L00003cd4               bcc.b   L00003d1c
L00003cd6               mulu.w  d0,d4
L00003cd8               add.w   d3,d4
L00003cda               move.w  d2,-(a7) 
L00003cdc               move.w  d0,d3
L00003cde               mulu.w  d1,d3
L00003ce0               moveq   #$03,d7
L00003ce2               move.w  d4,-(a7) 
L00003ce4               moveq   #$03,d2
L00003ce6               move.w  $0002(a7),d6
L00003cea               cmp.w   #$1580,d6
L00003cee               bcs.b   L00003cf2
L00003cf0               moveq   #$01,d2
L00003cf2               move.b  d5,d6
L00003cf4               not.w   d6
L00003cf6               and.b   $00(a0,d4.w),d6
L00003cfa               move.b  d6,$00(a0,d4.w)
L00003cfe               move.b  d5,d6
L00003d00               and.b   $00(a1,d4.w),d6
L00003d04               or.b    $00(a0,d4.w),d6
L00003d08               move.b  d6,$00(a0,d4.w)
L00003d0c               add.w   d0,d4
L00003d0e               dbf.w   d2,L00003cf2
L00003d12               move.w  (a7)+,d4
L00003d14               add.w   d3,d4
L00003d16               dbf.w   d7,L00003ce2
L00003d1a               move.w  (a7)+,d2
L00003d1c               mulu.w  #$5555,d2
L00003d20               addq.w  #$01,d2
L00003d22               and.w   #$1fff,d2
L00003d26               bne.b   L00003cba
L00003d28               rts 


                    ;---------------------- panel fade in -----------------------
                    ; fades the panel colours from black to expected colours.
                    ; waits 4 frames between each fade loop.
                    ; loops 16 times, 64 frames fade in. approx 1 seconds.
                    ;
panel_fade_in
L00003d2a               moveq   #$0f,d7
L00003d2c               lea.l   L00003252,a0
L00003d30               lea.l   L00003294,a1
L00003d34               moveq   #$0f,d6
L00003d36               move.w  (a0),d0
L00003d38               move.w  (a1)+,d1
L00003d3a               eor.w   d0,d1
L00003d3c               moveq   #$0f,d2
L00003d3e               and.w   d1,d2
L00003d40               beq.b   L00003d44
L00003d42               addq.w  #$01,d0
L00003d44               moveq   #$f0,d2
L00003d46               and.b   d1,d2
L00003d48               beq.b   L00003d4e
L00003d4a               add.w   #$0010,d0
L00003d4e               and.w   #$0f00,d1
L00003d52               beq.b   L00003d58
L00003d54               add.w   #$0100,d0
L00003d58               move.w  d0,(a0)
L00003d5a               addq.w  #$04,a0
L00003d5c               dbf.w   d6,L00003d36
L00003d60               move.w  L000036e2,d0
L00003d66               addq.w  #$04,d0
L00003d68               cmp.w   L000036e2,d0
L00003d6e               bne.b   L00003d68
L00003d70               dbf.w   d7,L00003d2c
L00003d74               rts


                    ;---------------------- panel fade out -----------------------
                    ; fades the panel colours to black.
                    ; waits 4 frames between each fade loop.
                    ; loops 16 times, 64 frames fade in. approx 1 seconds.
                    ;
panel_fade_out    
L00003d76               moveq   #$0f,d7
L00003d78               lea.l   L00003252,a0
L00003d7c               moveq   #$0f,d6
L00003d7e               move.w  (a0),d0
L00003d80               moveq   #$0f,d1
L00003d82               and.w   d0,d1
L00003d84               beq.b   L00003d88
L00003d86               subq.w  #$01,d0
L00003d88               move.w  #$00f0,d1
L00003d8c               and.w   d0,d1
L00003d8e               beq.b   L00003d94
L00003d90               sub.w   #$0010,d0
L00003d94               move.w  #$0f00,d1
L00003d98               and.w   d0,d1
L00003d9a               beq.b   L00003da0
L00003d9c               sub.w   #$0100,d0
L00003da0               move.w  d0,(a0)
L00003da2               addq.w  #$04,a0
L00003da4               dbf.w   d6,L00003d7e
L00003da8               move.w  L000036e2,d0
L00003dae               addq.w  #$04,d0
L00003db0               cmp.w   L000036e2,d0
L00003db6               bne.b   L00003db0
L00003db8               dbf.w   d7,L00003d78
L00003dbc               rts  


                    ; ----------------- update score by level progress ------------------   
                    ; Update the score based on X distance travelled through the level.
                    ;
update_score_by_level_progress 
L00003dbe               clr.l   d0
L00003dc0               move.w  L000069ee,d1
L00003dc4               add.w   L000069f4,d1
L00003dc8               sub.w   L000069f0,d1
L00003dcc               bpl.b   L00003dea
L00003dce               add.w   d1,L000069f0
L00003dd2               neg.w   d1
L00003dd4               lsl.w   #$04,d1
L00003dd6               move.b  d1,d0
L00003dd8               bra.b   L00003dde
L00003dda               add.w   #$0100,d0
L00003dde               sub.w   #$0064,d1
L00003de2               bcc.b   L00003dda
L00003de4               jmp     $0007c82a           ; PANEL_ADD_SCORE
L00003dea               rts  



                    ; ---------------------- trigger-new-actors ----------------------
                    ; Processes the list of bad-guy triggers and list of 
                    ; gas-leaks/drips.
                    ; Spawns new actors if there is room to do so (max 10 at anytime)
                    ;
                    ; Code Checked 9/1/2025
                    ;
trigger_new_actors 
L00003dec               movem.w L000069ec,d0-d1
L00003df2               lea.l   L00006476,a0
L00003df6               movem.w (a0)+,d2-d3
L00003dfa               sub.w   d0,d2
L00003dfc               cmp.w   #$0098,d2
L00003e00               bcc.b   L00003e1e
L00003e02               sub.w   d1,d3
L00003e04               cmp.w   #$0050,d3
L00003e08               bcc.b   L00003e1e
L00003e0a               bset.b  #$0007,-$0004(a0)
L00003e10               move.w  (a0)+,d7
L00003e12               subq.w  #$01,d7
L00003e14               bsr.w   L00003e62
L00003e18               dbf.w   d7,L00003e14
L00003e1c               bra.b   L00003e2a
L00003e1e               move.w  (a0),d2
L00003e20               add.w   d2,d2
L00003e22               add.w   (a0),d2
L00003e24               add.w   d2,d2
L00003e26               lea.l   $02(a0,d2.w),a0
L00003e2a               cmpa.w  #$00006944,a0
L00003e2e               bcs.b   L00003df6


                    ; ----------------------- trigger_gasleak_and_drips -------------------------
                    ; process list of 6 bytes (other actors - steam jets and toxic drips)
                    ;
                    ; IN:-
                    ;   a0.l = start of gasleak/drip trigger locations. (3 word structure per item)
                    ;
                    ; Code Checked 9/1/2025
                    ;
trigger_gasleak_and_drips 
L00003e30               sub.w   #$0010,d0
L00003e34               subq.w  #$08,d1
L00003e36               movem.w $0002(a0),d2-d3
L00003e3c               sub.w   d0,d2
L00003e3e               cmp.w   #$00c0,d2
L00003e42               bcc.b   L00003e58
L00003e44               sub.w   d1,d3
L00003e46               cmp.w   #$0060,d3
L00003e4a               bcc.b   L00003e58
L00003e4c               bsr.w   L00003e62
L00003e50               bset.b  #$0007,-$0002(a0)
L00003e56               bra.b   L00003e5a
L00003e58               addq.w  #$06,a0
L00003e5a               cmpa.w  #$000069c2,a0
L00003e5e               bcs.b   L00003e36
L00003e60               rts


                    ; -------------------- spawn new actor ------------------------
                    ; Adds new actor to list of actors for processing.
                    ; Includes a bit of a copy protection check also at the start.
                    ;
                    ; IN:
                    ;   d0.w = window scroll x
                    ;   d1.w = window scroll y
                    ;   a0.l = ptr to actor init data in trigger data
                    ;
                    ; Code Checked 9/1/2025
                    ;
spawn_new_actor 
L00003e62               movem.w (a0)+,d2-d4
L00003e66               cmp.w   $00000022,d0
L00003e6c               beq.b   L00003e6c
L00003e6e               nop
L00003e70               lea.l   L000039bc,a6
L00003e74               moveq   #$09,d6
L00003e76               tst.w   (a6)
L00003e78               beq.b   L00003e84
L00003e7a               lea.l   $0016(a6),a6
L00003e7e               dbf.w   d6,L00003e76
L00003e82               rts 


                    ; ----------------- initialise new actor ------------------
                    ; Sets up new actor in actor_list for processing each
                    ; game cycle.
                    ;
                    ; d2.w = actor init data
                    ; d3.w = actor init data
                    ; d4.w = actor init data
                    ; a6.l = address of blank entry in actors_list
                    ; a0.l = ptr to actor init data in trigger data
                    ;
                    ; Code Check 9/1/2025 - not understood yet
                    ;
initialise_new_actor
L00003e84               move.w  a0,$0014(a6)
L00003e88               bset.l  #$000f,d2
L00003e8c               movem.w d2-d4,(a6)
L00003e90               clr.l   $0008(a6)
L00003e94               bclr.l  #$000f,d2
L00003e98               clr.l   $0010(a6)
L00003e9c               lea.l   L00005aba,a5
L00003ea0               cmp.w   (a5)+,d2
L00003ea2               bcs.b   L00003ea8
L00003ea4               addq.w  #$02,a5
L00003ea6               bra.b   L00003ea0
L00003ea8               move.w  (a5),d3
L00003eaa               cmp.w   #$00c5,d3
L00003eae               bne.b   L00003ebe
L00003eb0               bsr.w   L00003ec4
L00003eb4               btst.l  #$000c,d2
L00003eb8               beq.b   L00003ebe
L00003eba               move.w  #$010e,d3
L00003ebe               move.w  d3,$0006(a6)
L00003ec2               rts 

L00003ec4               movea.l L0000636a,a1
L00003eca               move.w  (a1)+,d2
L00003ecc               move.l  a1,L0000636a
L00003ed2               rts  




                    ;-----------------------------------------------------------------------------------------------
                    ; -- Update Level Actors 02
                    ;-----------------------------------------------------------------------------------------------
                    ; called from game_loop every cycle.
                    ;
                    ; Code Checked 14/01/2025
                    ;
update_active_actors 
L00003ed4               lea.l   L000039bc,a6                    ; actors_list
L00003ed8               moveq   #$09,d7
L00003eda               move.w  (a6),d6
L00003edc               beq.w   L00003f96
L00003ee0               movem.w $0002(a6),d0-d1
L00003ee6               move.w  d0,d4
L00003ee8               movem.w L000069ec,d2-d3
L00003eee               sub.w   d2,d0
L00003ef0               sub.w   d3,d1
L00003ef2               cmp.w   #$0140,d0
L00003ef6               bcs.b   L00003efe
L00003ef8               cmp.w   #$ff60,d0
L00003efc               bcs.b   L00003f1c
L00003efe               cmp.w   #$00a0,d1
L00003f02               bcs.b   L00003f0a
L00003f04               cmp.w   #$ffb0,d1
L00003f08               bcs.b   L00003f1c
L00003f0a               bclr.b  #$0007,(a6)
L00003f0e               beq.b   L00003f36
L00003f10               cmp.w   #$0050,d1
L00003f14               bcc.b   L00003f36
L00003f16               cmp.w   #$00a0,d0
L00003f1a               bcc.b   L00003f36
L00003f1c               cmp.w   #$0014,d6
L00003f20               bcs.b   L00003f32
L00003f22               lea.l   $00000000,a0
L00003f26               movea.l d0,a0
L00003f28               movea.w $0014(a6),a0
L00003f2c               bclr.b  #$0007,-$0002(a0)
L00003f32               clr.w   (a6)
L00003f34               bra.b   L00003f96
L00003f36               lea.l   L00005ae2,a0
L00003f3a               add.w   d6,d6
L00003f3c               adda.w  d6,a0
L00003f3e               movea.w (a0),a0
L00003f40               move.w  d7,-(a7)
L00003f42               jsr     (a0)

                    ; L00003f44 - check batman collision with actor?
L00003f44               movem.w $000e(a6),d0-d2
L00003f4a               sub.w   L000069f2,d0
L00003f4e               addq.w  #$06,d0
L00003f50               cmp.w   #$000d,d0
L00003f54               bcc.b   L00003f94
L00003f56               sub.w   L00006338,d1
L00003f5a               subq.w  #$06,d1
L00003f5c               bmi.b   L00003f94
L00003f5e               sub.w   L000069f4,d2
L00003f62               bpl.b   L00003f94
L00003f64               move.w  (a6),d0
L00003f66               subq.w  #$02,d0
L00003f68               bmi.b   L00003f94
L00003f6a               move.w  #$0001,(a6)
L00003f6e               moveq   #$0a,d0                 ; SFX_GUYHIT
L00003f70               jsr     $00048014               ; AUDIO_PLAYER_INIT_SFX
L00003f76               move.w  #$fffe,$000a(a6)
L00003f7c               tst.w   L00006342
L00003f80               bmi.b   L00003f94
L00003f82               tst.w   L00006360
L00003f86               beq.b   L00003f8e
L00003f88               tst.w   L0000633c
L00003f8c               bne.b   L00003f94
L00003f8e               moveq   #$05,d6
L00003f90               bsr.w   L00004d0a
L00003f94               move.w  (a7)+,d7
L00003f96               lea.l   $0016(a6),a6
L00003f9a               dbf.w   d7,L00003eda
L00003f9e               rts  


                    ; ---------- calculate grenade inital drop speed ----------
                    ; a6 = actor list struct ptr
                    ; d0 = actorX - display
                    ; d1 = actorY - display
                    ; d2 = windowX
                    ; d3 = windowY
                    ; d4 = actor WorldX
                    ;
calc_grenade_speed
L00003fa0               add.w   #$0002,(a6)
L00003fa4               movem.w L000069f2,d2
L00003faa               move.w  L00006338,d3
L00003fae               add.w   #$0015,d3
L00003fb2               sub.w   d1,d3
L00003fb4               asl.w   #$03,d3
L00003fb6               ext.l   d3

L00003fb8               sub.w   d0,d2
L00003fba               bpl.b   L00003fbe
L00003fbc               neg.w   d2
L00003fbe               beq.b   L00003fc2
L00003fc0               divs.w  d2,d3
L00003fc2               asr.w   #$02,d2
L00003fc4               sub.w   d2,d3

L00003fc6               bsr.w   L0000467c         ;get_empty_projectile
L00003fca               cmp.w   #$0008,d3
L00003fce               bcs.b   L00003fde
L00003fd0               bmi.b   L00003fd6
L00003fd2               moveq   #$08,d3
L00003fd4               bra.b   L00003fde

L00003fd6               cmp.w   #$ffe8,d3
L00003fda               bcc.b   L00003fde
L00003fdc               moveq   #$e8,d3

L00003fde               move.w  d3,$0006(a0)
L00003fe2               cmp.w   #$0073,d1
L00003fe6               bpl.b   L00003ff8
L00003fe8               movem.w d0-d1,-(a7)
L00003fec               moveq   #$09,d0             ; SFX_GRENADE
L00003fee               jsr     $00048014           ; AUDIO_PLAYER_INIT_SFX
L00003ff4               movem.w (a7)+,d0-d1
L00003ff8               rts  


                    ; ---------------------- actor throw a grenade left ------------------
                    ; a6 = actor list struct ptr
                    ; d0 = actorX - display
                    ; d1 = actorY - display
                    ; d2 = windowX
                    ; d3 = windowY
                    ; d4 = actor WorldX
                    ;
actor_cmd_grenade_left_01
L00003ffa               move.w  $0008(a6),d2
L00003ffe               cmp.w   #$0007,d2
L00004002               bne.b   L0000401c

L00004004               subq.w  #$05,d0
L00004006               bsr.w   L00003fa0
L0000400a               move.w  #$000d,(a0)+
L0000400e               move.w  d1,d3
L00004010               sub.w   #$0011,d3
L00004014               movem.w d0/d3,(a0)
L00004018               addq.w  #$05,d0

L0000401a               moveq   #$08,d2
L0000401c               addq.w  #$01,$0008(a6)
L00004020               lea.l   L00004512,a5
L00004024               and.w   #$00fe,d2
L00004028               adda.w  d2,a5
L0000402a               add.w   d2,d2
L0000402c               adda.w  d2,a5
L0000402e               bra.w   L000045ba


                    ; called when green-guy throws a grenade
                    ; a6 = actor list struct ptr
                    ; d0 = actorX - display
                    ; d1 = actorY - display
                    ; d2 = windowX
                    ; d3 = windowY
                    ; d4 = actor WorldX
                    ;
actor_cmd_grenade_left_02
L00004032           lea.l   L0000452a,a5
L00004036           bsr.w   L000045ba       ; drawcollide_actor_sprites_a5
L0000403a           subq.w  #$01,$0008(a6)
L0000403e           bne.b   L0000404a
L00004040           move.w  #$0020,$0008(a6)
L00004046           move.w  #$0002,(a6)
L0000404a           rts  


                    ; a6 = actor list struct ptr
                    ; d0 = actorX - display
                    ; d1 = actorY - display
                    ; d2 = windowX
                    ; d3 = windowY
                    ; d4 = actor WorldX
actor_cmd_green_walk_left
L0000404c               cmp.w   #$ffc0,d0
L00004050               bmi.b   L0000409e
L00004052               subq.w  #$01,$0008(a6)
L00004056               bpl.b   L00004070
L00004058               move.w  d0,d2
L0000405a               sub.w   L000069f2,d2
L0000405e               cmp.w   #$0030,d2
L00004062               bcc.b   L00004070
L00004064               clr.w   $0008(a6)
L00004068               move.w  #$0005,(a6)
L0000406c               bra.w   L0000432a

L00004070               moveq   #$07,d2
L00004072               and.w   d4,d2
L00004074               bne.w   L00004324
L00004078               sub.w   #$000c,d0
L0000407c               bsr.w   L000055e0
L00004080               add.w   #$000c,d0
L00004084               cmp.b   #$51,d2
L00004088               bcc.w   L00004324
L0000408c               tst.w   $0008(a6)
L00004090               bpl.b   L0000409e
L00004092               move.w  d0,d2
L00004094               sub.w   L000069f2,d2
L00004098               cmp.w   #$0040,d2
L0000409c               bcs.b   L00004064

L0000409e               move.w  #$0002,(a6)
L000040a2               bra.w   L0000432a




                    ; a6 = actor list struct ptr
                    ; d0 = actorX - display
                    ; d1 = actorY - display
                    ; d2 = windowX
                    ; d3 = windowY
                    ; d4 = actor WorldX
actor_cmd_grenade_right_01
L000040a6               move.w  $0008(a6),d2
L000040aa               cmp.w   #$0007,d2
L000040ae               bne.b   L000040c8
L000040b0               addq.w  #$05,d0
L000040b2               bsr.w   L00003fa0
L000040b6               move.w  #$000c,(a0)+
L000040ba               move.w  d1,d3
L000040bc               sub.w   #$0011,d3
L000040c0               movem.w d0/d3,(a0)
L000040c4               subq.w  #$05,d0
L000040c6               moveq   #$08,d2
L000040c8               addq.w  #$01,$0008(a6)
L000040cc               lea.l   L00004530,a5
L000040d0               and.w   #$00fe,d2
L000040d4               adda.w  d2,a5
L000040d6               add.w   d2,d2
L000040d8               adda.w  d2,a5
L000040da               bra.w   L000045ba

                    ; a6 = actor list struct ptr
                    ; d0 = actorX - display
                    ; d1 = actorY - display
                    ; d2 = windowX
                    ; d3 = windowY
                    ; d4 = actor WorldX
actor_cmd_grenade_right_02
L000040de               lea.l   L00004548,a5
L000040e2               bsr.w   L000045ba
L000040e6               subq.w  #$01,$0008(a6)
L000040ea               bne.b   L000040f6
L000040ec               move.w  #$0020,$0008(a6)
L000040f2               move.w  #$0003,(a6)
L000040f6               rts  


                    ; a6 = actor list struct ptr
                    ; d0 = actorX - display
                    ; d1 = actorY - display
                    ; d2 = windowX
                    ; d3 = windowY
                    ; d4 = actor WorldX
actor_cmd_green_walk_right
L000040f8               cmp.w   #$00e0,d0
L000040fc               bpl.b   L00004146
L000040fe               subq.w  #$01,$0008(a6)
L00004102               bpl.b   L0000411c
L00004104               move.w  L000069f2,d2
L00004108               sub.w   d0,d2
L0000410a               cmp.w   #$0030,d2
L0000410e               bcc.b   L0000411c
L00004110               clr.w   $0008(a6)
L00004114               move.w  #$0004,(a6)
L00004118               bra.w   L00004254

L0000411c               moveq   #$07,d2
L0000411e               and.w   d4,d2
L00004120               bne.w   L0000424e
L00004124               addq.w  #$08,d0
L00004126               bsr.w   L000055e0
L0000412a               subq.w  #$08,d0
L0000412c               cmp.b   #$51,d2
L00004130               bcc.w   L0000424e 
L00004134               tst.w   $0008(a6)
L00004138               bpl.b   L00004146 
L0000413a               move.w  L000069f2,d2
L0000413e               sub.w   d0,d2
L00004140               cmp.w   #$0040,d2
L00004144               bcs.b   L00004110
L00004146               move.w  #$0003,(a6)
L0000414a               bra.w   L00004254
L0000414e               move.w  L000069f4,d5
L00004152               sub.w   d1,d5
L00004154               add.w   #$0010,d5
L00004158               btst.b  #$0002,$0003(a6) 
L0000415e               beq.b   L000041ac
L00004160               cmp.w   #$0020,d5
L00004164               bcs.b   L000041ac 
L00004166               bpl.b   L0000417a 
L00004168               move.w  $00008002,d2          ; MAPGR_BASE (width)
L0000416e               add.w   d2,d2
L00004170               add.w   d2,d2
L00004172               sub.w   d2,d3
L00004174               clr.w   d2
L00004176               move.b  $00(a0,d3.w),d2
                        ; different from code1.s
L0000417a               cmp.b   #$5f,d2
L0000417e               bcs.b   L000041ac
L00004180               move.b  $01(a0,d3.w),d2
L00004184               btst.b  #$0000,$0001(a6)
L0000418a               bne.b   L00004190
L0000418c               move.b  $ff(a0,d3.w),d2
L00004190               cmp.b   #$5f,d2
L00004194               bcs.b   L000041ac
L00004196               move.w  #$0002,$0008(a6)
L0000419c               move.w  #$000d,$000c(a6)
L000041a2               subq.w  #$08,d5
L000041a4               bpl.b   L000041ac
L000041a6               move.w  #$000c,$000c(a6)
L000041ac               rts  



                    ; a6 = actor list struct ptr
                    ; d0 = actorX - display
                    ; d1 = actorY - display
                    ; d2 = windowX
                    ; d3 = windowY
                    ; d4 = actor WorldX
actor_cmd_actor_brown_walk_right
L000041ae               move.w  d4,d2
L000041b0               addq.w  #$04,d2
L000041b2               and.w   #$0007,d2
L000041b6               bne.w   L0000424e
L000041ba               cmp.w   #$0140,d0
L000041be               bpl.b   L000041ce
L000041c0               addq.w  #$07,d0
L000041c2               bsr.w   L000055e0     ; get_map_tile_at_display_offset_d0_d1
L000041c6               subq.w  #$07,d0
L000041c8               cmp.b   #$51,d2
L000041cc               bcc.b   L000041da
L000041ce               move.w  #$000f,(a6)
L000041d2               clr.w   $0008(a6)
L000041d6               bra.w   L0000424e
L000041da               bsr.w   L0000414e
L000041de               subq.w  #$01,$0008(a6)
L000041e2               beq.w   L00004354
L000041e6               bpl.b   L0000424e
L000041e8               move.w  L000069f2,d2
L000041ec               sub.w   d0,d2
L000041ee               bmi.b   L0000424e
L000041f0               cmp.w   #$0020,d5
L000041f4               bpl.b   L00004230
L000041f6               bcc.b   L0000420e
L000041f8               cmp.w   #$0038,d2
L000041fc               bcc.b   L0000424e 
L000041fe               move.w  #$0010,$000c(a6)
L00004204               move.l  #$00010000,$0008(a6)
L0000420c               bra.b   L0000424e
L0000420e               sub.w   #$0010,d5
L00004212               add.w   d5,d2
L00004214               ble.b   L0000424e
L00004216               subq.w  #$04,d2
L00004218               lsr.w   #$03,d2
L0000421a               addq.w  #$01,d2
L0000421c               cmp.w   #$0008,d2
L00004220               bcc.b   L0000424e
L00004222               move.w  d2,$0008(a6)
L00004226               move.l  #$00050010,$000a(a6)        ; external address?
L0000422e               bra.b   L0000424e
L00004230               subq.w  #$08,d5
L00004232               sub.w   d5,d2
L00004234               bls.b   L0000424e
L00004236               subq.w  #$04,d2
L00004238               lsr.w   #$03,d2
L0000423a               addq.w  #$01,d2
L0000423c               cmp.w   #$0008,d2
L00004240               bcc.b   L0000424e
L00004242               move.w  d2,$0008(a6)
L00004246               move.l  #$00070010,$000a(a6)    ; external address?
L0000424e               addq.w  #$01,d4
L00004250               move.w  d4,$0002(a6)
L00004254               and.w   #$000e,d4
L00004258               lsr.w   #$01,d4
L0000425a               move.w  d4,-(a7)
L0000425c               addq.w  #$08,d4
L0000425e               move.w  d4,d2
L00004260               bsr.w   L00004f5a               ; draw next sprite
L00004264               move.w  (a7)+,d2
L00004266               lsr.w   #$01,d2
L00004268               bne.b   L0000426c
L0000426a               addq.w  #$02,d2
L0000426c               addq.w  #$04,d2
L0000426e               bsr.w   L000045fa               ; draw next sprite
L00004272               moveq   #$04,d2
L00004274               bra.w   L000045c8               ; actor_collision_and_sprite1



                    ; a6 = actor list struct ptr
                    ; d0 = actorX - display
                    ; d1 = actorY - display
                    ; d2 = windowX
                    ; d3 = windowY
                    ; d4 = actor WorldX
actor_cmd_brown_walk_left
L00004278               move.w  d4,d2
L0000427a               addq.w  #$04,d2
L0000427c               and.w   #$0003,d2
L00004280               bne.w   L00004324 
L00004284               cmp.w   #$ff60,d0
L00004288               bmi.b   L000042a4
L0000428a               subq.w  #$07,d0
L0000428c               bsr.w   L000055e0       ; get_map_tile_at_display_offset_d0_d1
L00004290               addq.w  #$07,d0
L00004292               cmp.b   #$51,d2
L00004296               bcc.b   L000042b0 
L00004298               move.w  $0006(a6),d2
L0000429c               cmp.w   #$0085,d2
L000042a0               beq.w   L00004448 
L000042a4               move.w  #$000e,(a6)
L000042a8               clr.w   $0008(a6)
L000042ac               bra.w   L00004324
L000042b0               bsr.w   L0000414e
L000042b4               subq.w  #$01,$0008(a6)
L000042b8               beq.w   L00004354
L000042bc               bpl.b   L00004324
L000042be               move.w  d0,d2
L000042c0               sub.w   L000069f2,d2
L000042c4               bmi.b   L00004324
L000042c6               cmp.w   #$0020,d5
L000042ca               bpl.b   L00004306
L000042cc               bcc.b   L000042e4
L000042ce               cmp.w   #$0038,d2
L000042d2               bcc.b   L00004324
L000042d4               move.w  #$0010,$000c(a6)
L000042da               move.l  #$00010001,$0008(a6)            ; external address?
L000042e2               bra.b   L00004324 
L000042e4               sub.w   #$0010,d5
L000042e8               add.w   d5,d2
L000042ea               ble.b   L00004324
L000042ec               subq.w  #$04,d2
L000042ee               lsr.w   #$02,d2
L000042f0               addq.w  #$01,d2
L000042f2               cmp.w   #$0008,d2
L000042f6               bcc.b   L00004324
L000042f8               move.w  d2,$0008(a6)
L000042fc               move.l  #$00040010,$000a(a6)            ; external address?
L00004304               bra.b   L00004324
L00004306               subq.w  #$08,d5
L00004308               sub.w   d5,d2
L0000430a               bls.b   L00004324
L0000430c               subq.w  #$04,d2
L0000430e               lsr.w   #$02,d2
L00004310               addq.w  #$01,d2
L00004312               cmp.w   #$0008,d2
L00004316               bcc.b   L00004324
L00004318               move.w  d2,$0008(a6)
L0000431c               move.l  #$00060010,$000a(a6)            ; external address?
L00004324               subq.w  #$01,d4
L00004326               move.w  d4,$0002(a6)
L0000432a               and.w   #$000e,d4
L0000432e               lsr.w   #$01,d4
L00004330               eor.w   #$e007,d4
L00004334               move.w  d4,-(a7)
L00004336               addq.w  #$08,d4
L00004338               move.w  d4,d2
L0000433a               bsr.w   L00004f5a               ; draw next sprite
L0000433e               move.w  (a7)+,d2
L00004340               lsr.b   #$01,d2
L00004342               bne.b   L00004346
L00004344               addq.w  #$02,d2
L00004346               addq.w  #$04,d2
L00004348               bsr.w   L00004f5a               ; draw next sprite
L0000434c               move.w  #$e004,d2
L00004350               bra.w   L000045c8
L00004354               move.w  $000c(a6),d6
L00004358               move.w  d6,(a6)
L0000435a               cmp.w   #$0010,d6
L0000435e               bne.b   L00004380
L00004360               move.w  #$0002,$0008(a6)
L00004366               move.w  $000a(a6),d2
L0000436a               cmp.w   #$0002,d2
L0000436e               bcc.b   L00004380
L00004370               move.w  $0012(a6),d2
L00004374               addq.w  #$04,d2
L00004376               sub.w   L00006338,d2
L0000437a               bpl.b   L00004380
L0000437c               addq.w  #$02,$000a(a6)


L00004380               lea.l   L00005ae2,a0        ; actor_handler_table
L00004384               add.w   d6,d6
L00004386               adda.w  d6,a0
L00004388               movea.w (a0),a0
L0000438a               jmp     (a0)



                    ; a6 = actor list struct ptr
                    ; d0 = actorX - display
                    ; d1 = actorY - display
                    ; d2 = windowX
                    ; d3 = windowY
                    ; d4 = actor WorldX
                    ;
                    ; Differnet to Code1.s
actor_cmd_climb_down_ladder
L0000438c               move.w  $0004(a6),d4
L00004390               btst.b  #$0000,L00006375         ; playfield_swap_count+1 
L00004396               bne.b   L000043b4
L00004398               addq.w  #$01,d4
L0000439a               move.w  d4,$0004(a6)
L0000439e               addq.w  #$01,d1
L000043a0               and.w   #$0007,d4
L000043a4               bne.b   L000043b4
L000043a6               bsr.w   L000055e0
                        ; Additional to code1.s
L000043aa               cmp.b   #$5f,d2
L000043ae               bcc.b   L000043b4
L000043b0               bsr.w   L0000443a
L000043b4               not.w   d4
L000043b6               and.w   #$0007,d4
L000043ba               subq.w  #$01,d0
L000043bc               move.w  d4,d2
L000043be               bclr.l  #$0002,d2
L000043c2               beq.b   L000043ca
L000043c4               or.w    #$e000,d2
L000043c8               addq.w  #$01,d0
L000043ca               add.w   #$0020,d2
L000043ce               move.w  d2,-(a7)
L000043d0               bsr.w   L000045fa
L000043d4               move.w  (a7)+,d2
L000043d6               and.w   #$e000,d2
L000043da               add.w   #$001f,d2
L000043de               bra.w   L000045c8 


                    ; a6 = actor list struct ptr
                    ; d0 = actorX - display
                    ; d1 = actorY - display
                    ; d2 = windowX
                    ; d3 = windowY
                    ; d4 = actor WorldX
actor_cmd_climb_up_ladder
L000043e2               move.w  $0004(a6),d4
L000043e6               btst.b  #$0000,L00006375            ; playfield_swap_count+1 
L000043ec               bne.b   L0000440c
L000043ee               subq.w  #$01,d4
L000043f0               move.w  d4,$0004(a6)
L000043f4               subq.w  #$01,d1
L000043f6               and.w   #$0007,d4
L000043fa               bne.b   L0000440c 
L000043fc               subq.w  #$08,d1
L000043fe               bsr.w   L000055e0           ; get_map_tile_at_display_offset_d0_d1
L00004402               addq.w  #$08,d1

                ; actor_cmd_climb_ladder_common
L00004404               cmp.b   #$5f,d2
L00004408               bcc.b   L0000440c
L0000440a               bsr.b   L0000443a
L0000440c               not.w   d4
L0000440e               and.w   #$0007,d4
L00004412               subq.w  #$01,d0
L00004414               move.w  d4,d2
L00004416               bclr.l  #$0002,d2
L0000441a               beq.b   L00004422
L0000441c               or.w    #$e000,d2
L00004420               addq.w  #$01,d0
L00004422               add.w   #$001b,d2
L00004426               move.w  d2,-(a7)
L00004428               bsr.w   L000045fa           ; draw_next_sprite
L0000442c               move.w  (a7)+,d2
L0000442e               and.w   #$e000,d2
L00004432               add.w   #$001a,d2
L00004436               bra.w   L000045c8
L0000443a               moveq   #$07,d2
L0000443c               moveq   #$4c,d3
L0000443e               sub.w   d0,d3
L00004440               add.w   d3,d3
L00004442               addx.w  d2,d2
L00004444               move.w  d2,(a6)
L00004446               rts 



L00004448               move.w  #$ffff,$0008(a6)
L0000444e               moveq   #$06,d2
L00004450               cmp.w   L00006338,d1
L00004454               bmi.b   L00004466
L00004456               moveq   #$01,d2
L00004458               move.w  $0012(a6),d3
L0000445c               addq.w  #$04,d3
L0000445e               cmp.w   L00006338,d3
L00004462               bpl.b   L00004466
L00004464               addq.w  #$02,d2
L00004466               move.w  d2,$000a(a6)
L0000446a               move.w  #$0010,(a6)


                    ; a6 = actor list struct ptr
                    ; d0 = actorX - display
                    ; d1 = actorY - display
                    ; d2 = windowX
                    ; d3 = windowY
                    ; d4 = actor WorldX
actor_cmd_shooting_diagonally_01
L0000446e               bsr.w   L000045ae
L00004472               subq.w  #$01,$0008(a6)
L00004476               bpl.b   L00004480
L00004478               addq.w  #$01,(a6)
L0000447a               move.w  #$0003,$0008(a6) 
L00004480               rts  


                    ; a6 = actor list struct ptr
                    ; d0 = actorX - display
                    ; d1 = actorY - display
                    ; d2 = windowX
                    ; d3 = windowY
                    ; d4 = actor WorldX
actor_cmd_shooting_diagonally_02
L00004482               bsr.w   L000045ae           ; drawcollide_sprites_from_actor_list_struct_0a
L00004486               btst.b  #$0000,L00006375
L0000448e               bne.b   L00004480
L00004490               bsr.w   L0000467c           ; get_empty_projectile
L00004494               sub.w   (a5)+,d1
L00004496               add.w   L00006358,d1
L0000449a               add.w   (a5)+,d0
L0000449c               add.w   L00006356,d0
L000044a0               move.w  (a5),(a0)+
L000044a2               movem.w d0-d1,(a0)
L000044a6               moveq   #$0c,d2             ; SFX_Ricochet
L000044a8               bsr.w   L000044f4           ; play_proximity_sfx
L000044ac               subq.w  #$01,$0008(a6)
L000044b0               bne.b   L00004480
L000044b2               move.w  #$0006,$0008(a6)
L000044b8               addq.w  #$01,(a6)
L000044ba               rts  

                    ; a6 = actor list struct ptr
                    ; d0 = actorX - display
                    ; d1 = actorY - display
                    ; d2 = windowX
                    ; d3 = windowY
                    ; d4 = actor WorldX
actor_cmd_shooting_horizontal
L000044bc               bsr.w   L000045ae           ; drawcollide_sprites_from_actor_list_struct_0a
L000044c0               subq.w  #$01,$0008(a6)
L000044c4               bne.b   L00004480
L000044c6               move.w  #$0004,$0008(a6)
L000044cc               move.w  $000a(a6),d2
L000044d0               move.w  $0006(a6),d3
L000044d4               cmp.w   #$0085,d3
L000044d8               bne.b   L000044de
L000044da               move.w  #$0001,d2
L000044de               not.w   d2
L000044e0               and.w   #$0001,d2
L000044e4               add.w   #$000e,d2
L000044e8               move.w  d2,(a6)
L000044ea               move.w  d2,$000c(a6)
L000044ee               move.w  $0002(a6),d4
L000044f2               rts  


                    ; ------------------- play proximity sfx ---------------------
                    ; Play SFX if X & Y co-ordinates within range
                    ; IN:-
                    ;   d0.w = probably X distance
                    ;   d1.w = probably Y distance
                    ;   d2 = sfx number to play 5 - 13
play_proximity_sfx   
L000044f4               cmp.w   #$00a0,d0
L000044f8               bcc.b   L000044f2
L000044fa               cmp.w   #$0059,d1
L000044fe               bcc.b   L000044f2
L00004500               movem.w d0-d1,-(a7)
L00004504               move.w  d2,d0
L00004506               jsr     $00048014           ; AUDIO_PLAYER_INIT_SFX
L0000450c               movem.w (a7)+,d0-d1
L00004510               rts 


                ; bad-guy - actor animation frames (left)
L00004512       dc.w $E010,$E011,$0000
                dc.w $E012,$E011,$0000
                dc.w $E013,$E011,$0000
                dc.w $E014,$E015,$E011
throw_grenade_left                                  ; final animation frame?
                dc.w $E016,$E017,$E011

                dc.w $0010,$0011,$0000
                dc.w $0012,$0011,$0000
                dc.w $0013,$0011,$0000
L00004542       dc.w $0014,$0015,$0011
                dc.w $0016,$0017,$0011

actor_sprite_ids
L0000454e       dc.w $0010,$0011,$0012,$0012,$0008,$8006
                dc.w $E010,$E011,$E012,$0012,$FFF8,$8007
                dc.w $0017,$0018,$0019,$000E,$0008,$8006 
L00004572       dc.w $E017,$E018,$E019,$000E,$FFF8,$8007
                dc.w $E013,$E014,$E012,$0014,$FFFE,$800B
                dc.w $0013,$0014,$0012,$0014,$0002,$800A
                dc.w $E015,$E016,$E012,$000B,$FFFC,$8009
L000045A2       dc.w $0015,$0016,$0012,$000B,$0004,$8008


                    ; ---------------------- draw and collide actor sprites ------------------------
                    ; Draws actor sprites using an offset specified in the 'actor list structure'
                    ; offset is a word at byte  offset #$0a (10)
                    ; 
                    ; IN:-
                    ;   a6 = actor list structure ptr
                    ;
drawcollide_sprites_from_actor_list_struct_0a
L000045ae               move.w $000a(a6),d2
L000045b2               mulu.w #$000c,d2
L000045b6               lea.l L0000454e(pc,d2.w),a5
                        ; fall through to 'drawcollide_actor_sprites_a5' below...

                    ; ----------------------- draw and collide sprites ids --------------------------
                    ; draw and collide sprites using 3 word ids specified by address a5.
                    ;
                    ; IN:-
                    ;   a5 = address ptr to 3 sprite ids
                    ;
drawcollide_actor_sprites_a5 
L000045ba               move.w  (a5)+,d2
L000045bc               bsr.b   L000045c8       ; actor_collision_and_sprite1
L000045be               move.w  (a5)+,d2
L000045c0               bsr.b   L000045fa       ; draw_next_sprite
L000045c2               move.w  (a5)+,d2
L000045c4               bne.b   L000045fa       ; draw_next_sprite
L000045c6               rts  


                    ; do bad guy collision
                    ; draw bad guy head/sprite 1
actor_collision_and_sprite1 
;000045c8        code1.s line 3087
L000045c8               add.w   $0006(a6),d2
L000045cc               move.w  d2,d3
L000045ce               and.w   #$1fff,d3
L000045d2               lsl.w   #$01,d3
L000045d4               lea.l   L000060c4,a0
L000045d8               move.w  d1,d4
L000045da               add.w   d4,d4
L000045dc               move.b  -$2(a0,d3.w),d5
L000045e0               ext.w   d5
L000045e2               sub.w   d5,d4
L000045e4               asr.w   #$01,d4
L000045e6               movem.w d0-d1/d4,$000e(a6)
                        ; draw sprite
L000045ec               movem.w d0-d1/a5-a6,-(a7)
L000045f0               bsr.w   L00005734           ; draw_sprite
L000045f4               movem.w (a7)+,d0-d1/a5-a6
L000045f8               rts  


                    ; IN:-
                    ;   d0.w - Sprite X Position
                    ;   d1.w - Sprite Y Position
                    ;   d2.w - current sprite id
                    ;   a6.l - address of object/sprite struct
                    ; OUT:
                    ;   d2.w - updated sprite id
draw_next_sprite   
L000045fa               add.w   $0006(a6),d2
L000045fe               movem.w d0-d1/a5-a6,-(a7)
L00004602               bsr.w   L00005734               ; draw_sprite
L00004606               movem.w (a7)+,d0-d1/a5-a6
L0000460a               rts  


                    ; -------------------- actor command - falling -----------------------
                    ; Called to handle actor killed/falling form playform.
                    ;   - Brown Bad Guy
                    ;   - Green Bad Guy
                    ;   - Grey Bad Guy (Jack)
                    ;
                    ; a6 = actor list struct ptr
                    ; d0 = actorX - display
                    ; d1 = actorY - display
                    ; d2 = windowX
                    ; d3 = windowY
                    ; d4 = actor WorldX
actor_cmd_falling
L0000460c               move.w  $000a(a6),d2
L00004610               addq.w  #$01,d2
L00004612               cmp.w   #$000e,d2
L00004616               bpl.b   L0000461c
L00004618               move.w  d2,$000a(a6)
L0000461c               asr.w   #$01,d2
L0000461e               add.w   d2,$0004(a6)
L00004622               lea.l   L00006326,a5
L00004626               cmp.w   #$0064,d1
L0000462a               bmi.w   L000045ba           ; drawcollide_actor_sprites_a5
L0000462e               clr.w   (a6)
L00004630               move.l  #$00000350,d0
L00004636               jmp     $0007c82a           ; PANEL_ADD_SCORE
                    ; uses rts in 'panel_add_score' above

                    ;-----------------------------------------------------------------------------------------------------------------------------
                    ;
                    ; END OF - ACTOR HANDLER CODE
                    ;
                    ;-----------------------------------------------------------------------------------------------------------------------------




                    ;-----------------------------------------------------------------------------------------------------------------------------
                    ;
                    ; PROJECTILE HANDLER CODE
                    ;
                    ;-----------------------------------------------------------------------------------------------------------------------------


                    ;----------------------------------------------------------------------------------------------
                    ; Draw Projectiles (bombs, bullets, batarang)
                    ;----------------------------------------------------------------------------------------------
                    ; draws the projectiles on the screen 
                    ;
                    ;  - bombs
                    ;  - bullets
                    ;  - player's batarang 
                    ;  - end of bat-rope
                    ;
                    ; L00004894 - 8 byte structure (20 active projectiles?)
                    ;               Handler Index, X Co-ord, Y Co-ord, Grenade Acceleration
                    ;
                    ; Code Checked 2/1/2025
                    ;
draw_projectiles  
L0000463c               lea.l   L000048a4,a5            ; projectile_jmp_table - unused here
L00004640               lea.l   L000048d2,a6
L00004644               moveq   #$13,d7
L00004646               move.w  (a6)+,d2
L00004648               beq.b   L00004674 
L0000464a               movem.w (a6),d0-d1
L0000464e               move.l  a6,-(a7) 
L00004650               move.w  d7,-(a7) 
L00004652               btst.l  #$000f,d2
L00004656               beq.b   L00004660
L00004658               ext.w   d2
L0000465a               move.w  d2,-$0002(a6)
L0000465e               moveq   #$04,d2
L00004660               ror.w   #$01,d2
L00004662               bpl.b   L00004668
L00004664               or.w    #$e000,d2
L00004668               add.w   #$003b,d2
L0000466c               bsr.w   L00005734               ; draw_sprite
L00004670               move.w  (a7)+,d7
L00004672               movea.l (a7)+,a6
L00004674               addq.w  #$06,a6                 ; #PROJECTILE_LISTITEM_SIZE-2
L00004676               dbf.w   d7,L00004646
L0000467a               rts  


                    ; ---------------- find empty projectile entry ------------------
                    ; skips through the list of projectiles, returns the address of
                    ; the first empty entry in a0.
                    ; if there are no empty entries then a0 = the address of the
                    ; end of the list.
                    ;
                    ; OUT:
                    ;   a0.l = address of first empty entry in the list
                    ;           or the address of the end of the list if the list is full.
                    ;
                    ; Code Checked 2/1/2025
                    ;
get_empty_projectile 
L0000467c               lea.l   L000048d2,a0          ; projectile_list
L00004680               moveq   #$13,d7
L00004682               tst.w   (a0)
L00004684               beq.b   L00004694
L00004686               lea.l   $0008(a0),a0
L0000468a               dbf.w   d7,L00004682
L0000468e               movea.l #$fffffff8,a0
L00004694               rts  


                    ;-------------------------------------------------------------------------------------
                    ; -- Update the Projectiles (bombs, bullets, player's batarang)
                    ;-------------------------------------------------------------------------------------
                    ; update projectiles on the level, including the player's projectiles
                    ; it does not draw them..
                    ;
                    ; Code Checked: 2/1/2025
                    ;
update_projectiles
L00004696               lea.l   L000048a4,a5        ; projectile_jmp_table
L0000469a               lea.l   L000048d2,a6        ; projectile_list
L0000469e               moveq   #$13,d7
L000046a0               move.w (a6)+,d6
L000046a2               beq.b   L000046bc
L000046a4               movem.w (a6),d0-d1
L000046a8               sub.w   L00006356,d0
L000046ac               sub.w   L00006358,d1
L000046b0               asl.w   #$02,d6             ; modified address table to 32 bit addresses, original code 'asl.w #$01,d6'
L000046b2               clr.l   d2
L000046b4               movea.l d2,a0
L000046b6               movea.l -$4(a5,d6.w),a0     ; modified address table to 32 bit addresses, original code 'movea.w $fe(a5,d6.W),a0' 
L000046ba               jsr     (a0)
L000046bc               addq.w  #$06,a6
L000046be               dbf.w   d7,L000046a0
L000046c2               rts  




                    ; badguy shooting - common code
                    ; executed after the projectile x & y
                    ; has been updated and screen boundary checks
                    ; have passed.
                    ;       
                    ; PROJECTILE HANDLER 
                    ;   referenced from: projectile_jmp_table
                    ;
                    ; d0.w = X
                    ; d1.w = Y
                    ; d2.l = #$00000000
                    ; d6.w = index into projectile_list
                    ; d7.w = projectile loop counter
                    ; a0.l = routine address
                    ; a5.l = projectile_jmp_table
                    ; a6.l = projectile_list entry + 2
                    ;
badguy_shooting 
L000046c4               movem.w d0-d1,(a6)
L000046c8               bsr.w   L000055e0       ; get_map_tile_at_display_offset_d0_d1
L000046cc               cmp.b   #$03,d2
L000046d0               bcs.b   L000046f8
L000046d2               sub.w   L000069f2,d0
L000046d6               addq.w  #$04,d0
L000046d8               cmp.w   #$0009,d0
L000046dc               bcc.b   L00046fe
L000046de               cmp.w   L000069f4,d1
L000046e2               bpl.b   L000046fe
L000046e4               cmp.w   L00006338,d1
L000046e8               bmi.b   L000046fe
L000046ea               moveq   #$01,d6
L000046ec               bsr.w   L00004d0a
L000046f0               moveq   #$0a,d0         ; SFX_GUYHIT
L000046f2               jsr     $00048014       ; AUDIO_PLAYER_INIT_SFX
L000046f8               move.w  #$0004,-$0002(a6)
L000046fe               rts  



                    ; ----------- badguy shooting left & up - diagonal ----------
                    ; Update X,Y co-ords, check bullet on screen and remove if not.
                    ; Perform common code if on screen.
                    ;
                    ; PROJECTILE HANDLER 
                    ;   referenced from: projectile_jmp_table
                    ;
                    ; d0.w = X
                    ; d1.w = Y
                    ; d2.l = #$00000000
                    ; d6.w = index into projectile_list
                    ; d7.w = projectile loop counter
                    ; a0.l = routine address
                    ; a5.l = projectile_jmp_table
                    ; a6.l = projectile_list entry + 2
                    ;
                    ; Code Checked 2/1/2025
                    ;
badguy_shooting_left_up 
L00004700               subq.w  #$03,d0
L00004702               cmp.w   #$fff6,d0
L00004706               bmi.b   L00004760           ; remove_projectile
L00004708               subq.w  #$03,d1
L0000470a               cmp.w   #$0058,d1
L0000470e               bcs.b   L000046c4
L00004710               bra.b   L00004760


                    ; ---------- badguy shooting right & up - diagonal ----------
                    ;
                    ; PROJECTILE HANDLER 
                    ;   referenced from: projectile_jmp_table
                    ;
                    ; d0.w = X
                    ; d1.w = Y
                    ; d2.l = #$00000000
                    ; d6.w = index into projectile_list
                    ; d7.w = projectile loop counter
                    ; a0.l = routine address
                    ; a5.l = projectile_jmp_table
                    ; a6.l = projectile_list entry + 2
                    ;
                    ; Code Checked 2/1/2025
                    ;
badguy_shooting_right_up  
L00004712               addq.w  #$03,d0
L00004714               cmp.w   #$00a8,d0
L00004718               bpl.b   L00004760       ; remove_projectile
L0000471a               subq.w  #$03,d1
L0000471c               cmp.w   #$0058,d1
L00004720               bcs.b   L000046c4
L00004722               bra.b   L00004760


                    ; --------- badguy shooting left & down - diagonal ----------
                    ;
                    ; PROJECTILE HANDLER 
                    ;   referenced from: projectile_jmp_table
                    ;
                    ; d0.w = X
                    ; d1.w = Y
                    ; d2.l = #$00000000
                    ; d6.w = index into projectile_list
                    ; d7.w = projectile loop counter
                    ; a0.l = routine address
                    ; a5.l = projectile_jmp_table
                    ; a6.l = projectile_list entry + 2
                    ;
                    ; Code Checked 2/1/2-15
                    ;
badguy_shooting_left_down 
L00004724               subq.w  #$03,d0
L00004726               cmp.w   #$fff6,d0
L0000472a               bmi.b   L00004760       ; remove_projectile
L0000472c               addq.w  #$03,d1
L0000472e               cmp.w   #$0058,d1
L00004732               bcs.b   L000046c4
L00004734               bra.b   L00004760       ; remove_projectile



                    ; ---------- badguy shooting right & down - diagonal ----------
                    ;
                    ; PROJECTILE HANDLER 
                    ;   referenced from: projectile_jmp_table
                    ;
                    ; d0.w = X
                    ; d1.w = Y
                    ; d2.l = #$00000000
                    ; d6.w = index into projectile_list
                    ; d7.w = projectile loop counter
                    ; a0.l = routine address
                    ; a5.l = projectile_jmp_table
                    ; a6.l = projectile_list entry + 2
                    ;
                    ; Code Checked 2/1/2025
                    ;
badguy_shooting_right_down 
L00004736               addq.w  #$03,d0
L00004738               cmp.w   #$00a8,d0
L0000473c               bpl.b   L00004760       ; remove_projectile
L0000473e               addq.w  #$03,d1
L00004740               cmp.w   #$0058,d1
L00004744               bcs.w   L000046c4
L00004748               bra.b   L00004760       ; remove_projectile



                    ; ---------- badguy shooting left ----------
                    ;
                    ; PROJECTILE HANDLER 
                    ;   referenced from: projectile_jmp_table
                    ;
                    ; d0.w = X
                    ; d1.w = Y
                    ; d2.l = #$00000000
                    ; d6.w = index into projectile_list
                    ; d7.w = projectile loop counter
                    ; a0.l = routine address
                    ; a5.l = projectile_jmp_table
                    ; a6.l = projectile_list entry + 2
                    ;
                    ; Code Checked 2/1/2-15
                    ;
badguy_shooting_left  
L0000474a               subq.w  #$05,d0
L0000474c               cmp.w   #$fff6,d0
L00004750               bpl.w   L000046c4
L00004754               bra.b   L00004760       ; remove_projectile


                    ; ---------- badguy shooting right ----------
                    ;
                    ; PROJECTILE HANDLER 
                    ;   referenced from: projectile_jmp_table
                    ;
                    ; d0.w = X
                    ; d1.w = Y
                    ; d2.l = #$00000000
                    ; d6.w = index into projectile_list
                    ; d7.w = projectile loop counter
                    ; a0.l = routine address
                    ; a5.l = projectile_jmp_table
                    ; a6.l = projectile_list entry + 2
                    ;
                    ; Code Checked 2/1/2015
                    ;
badguy_shooting_right
L00004756               addq.w  #$05,d0
L00004758               cmp.w   #$00a8,d0
L0000475c               bmi.w   L000046c4       ; badguy_shooting


        ;------------------------------------------------------------------------------------------------------
        ; Projectile Handling Code & Data
        ;------------------------------------------------------------------------------------------------------
        ; 
        ;------------------------------------------------------------------------------------------------------


                    ; ---------------- remove projectile -----------------
                    ; IN:-
                    ;   a6.l = Projectile List Entry +2
                    ;
                    ; Code Checked 2/1/2-15
                    ;
remove_projectile
L00004760               clr.w   -$0002(a6)
L00004764               rts 


                    ; ------------------- batarang fire right ------------------
                    ; batman firing a bat-a-rang projectile to the right
                    ;
                    ; PROJECTILE HANDLER 
                    ;   referenced from: projectile_jmp_table
                    ;
                    ; d0.w = X
                    ; d1.w = Y
                    ; d2.l = #$00000000
                    ; d6.w = index into projectile_list
                    ; d7.w = projectile loop counter
                    ; a0.l = routine address
                    ; a5.l = projectile_jmp_table
                    ; a6.l = projectile_list entry + 2
                    ;
                    ; Code Checked 2/1/2015
                    ;
batarang_right
L00004766               addq.w  #$04,d0
L00004768               cmp.w   #$00a8,d0
L0000476c               bpl.b   L00004760           ; remove_projectile
L0000476e               bsr.w   L000055e0           ; get_map_tile_at_display_offset_d0_d1
L00004772               cmp.b   #$03,d2
L00004776               movem.w d0-d1,(a6)
L0000477a               bcc.b   L000047bc           ; actor_projectile_collision_handler
L0000477c               bra.b   L00004760           ; remove_projectile
;L0000477c               bcs.b   #$e2 == $00004760 (F)


                    ; ------------------ batarang fire left ----------------
                    ; batman firing a bat-a-rang projectile to the left.
                    ;
                    ; PROJECTILE HANDLER 
                    ;   referenced from: projectile_jmp_table
                    ;
                    ; d0.w = X
                    ; d1.w = Y
                    ; d2.l = #$00000000
                    ; d6.w = index into projectile_list
                    ; d7.w = projectile loop counter
                    ; a0.l = routine address
                    ; a5.l = projectile_jmp_table
                    ; a6.l = projectile_list entry + 2
                    ;
                    ; Code Checked 2/1/2015
                    ;
batarang_left 
L0000477e           subq.w  #$04,d0
L00004780           cmp.w   #$fff6,d0
L00004784           bmi.b   L00004760               ; remove_projectile
L00004786           bsr.w   L000055e0               ; get_map_tile_at_display_offset_d0_d1
L0000478a           cmp.b   #$03,d2
L0000478e           movem.w d0-d1,(a6)
L00004792           bcc.b   L000047bc               ; actor_projectile_collision_handler
L00004794           bra.b   L00004760               ; remove_projectile



                    ; ------------- batman grappling hook ---------------
                    ; Update grappling hook X,Y and whether it has hit
                    ; any actor to kill any bad guys.
                    ; This routine does not manage 'batman state', or
                    ; batman attaching and/or swinging from the rope etc. 
                    ; It is concerned only with the hook part used as a 
                    ; projectile (i.e. its travel and collision with actors)
                    ;
                    ; PROJECTILE HANDLER 
                    ;   referenced from: projectile_jmp_table
                    ;
                    ; d0.w = X - Current
                    ; d1.w = Y - Current
                    ; d2.l = #$00000000
                    ; d6.w = index into projectile_list
                    ; d7.w = projectile loop counter
                    ; a0.l = routine address
                    ; a5.l = projectile_jmp_table
                    ; a6.l = projectile_list entry + 2
                    ;
                    ; Code Checked 2/1/2015
                    ;
batman_grappling_hook
L00004796               move.w  L00006360,d0
L0000479a               beq.b   L00004760           ; remove_projectile
L0000479c               movem.w L000069f2,d0-d1
L000047a2               add.w   L00006362,d0
L000047a6               sub.w   L00006364,d1
L000047aa               sub.w   #$000c,d1
L000047ae               addq.w  #$05,d0
L000047b0               tst.w   L00006336
L000047b4               bpl.b   L000047b8
L000047b6               subq.w  #$07,d0
L000047b8               movem.w d0-d1,(a6)
                    ; falls through to actor collision
                    ; can be used to kill bad guys



                    ; ------------- actor to projectile collision check -----------
                    ; Tests and if necessary handles the collision between the
                    ; batman's bat-a-rang projectile and an enemy actor.
                    ; It steps through active actor list backwards, maybe an optimisation
                    ; thinking that the most recently added actor is most likley to
                    ; be hit first?
                    ;
                    ; d0.w = X - Current
                    ; d1.w = Y - Current
                    ; d2.l = #$00000000
                    ; d6.w = index into projectile_list
                    ; d7.w = projectile loop counter
                    ; a0.l = routine address
                    ; a5.l = projectile_jmp_table
                    ; a6.l = projectile_list entry + 2
                    ;
                    ; Code Checked 2/1/2015
                    ;
actor_projectile_collision_handler 
L000047bc               lea.l   L00003a82,a4            ; last_active_actor
L000047c0               moveq   #$09,d6
L000047c2               move.w  (a4),d2
L000047c4               subq.w  #$02,d2
L000047c6               bmi.b   L000047e2 

L000047c8               move.w  $000e(a4),d2
L000047cc               sub.w   d0,d2
L000047ce               addq.w  #$04,d2
L000047d0               cmp.w   #$0008,d2
L000047d4               bcc.b   L000047e2

L000047d6               cmp.w   $0010(a4),d1
L000047da               bpl.b   L000047e2
L000047dc               cmp.w   $0012(a4),d1
L000047e0               bpl.b   L000047ec
;L000047e2               lea.l   -$0016(a4),a4
L000047e2               lea.l   -$0018(a4),a4
L000047e6               dbf.w   d6,L000047c2
L000047ea               rts  

                    ; ---------- actor collided with projectile -----------
                    ; Batman's bat-a-rang projectile has hit an actor.
                    ; This routine sets the handler index to $0001 (a4)
                    ;
                    ; IN:
                    ;   a4.l = Actor Structure
                    ;
                    ; Code Checked 2/1/2015
                    ;
projectile_hit_actor  
L000047ec           move.w  #$0001,(a4)
L000047f0           move.w  #$fffc,$000a(a4)
L000047f6           bsr.w   L00004760           ; remove_projectile
L000047fa           moveq   #$0a,d0             ; SFX_GUYHIT
L000047fc           jmp     $00048014           ; AUDIO_PLAYER_INIT_SFX
                    ; use rts in audio player to return



                    ; --------------- bad guy grenade right ---------------
                    ; handle bad guy grenade thrown to the right.
                    ; update X, Y and check for off bottom of the screen
                    ;
                    ; d0.w = X - Current
                    ; d1.w = Y - Current
                    ; d2.l = #$00000000
                    ; d6.w = index into projectile_list
                    ; d7.w = projectile loop counter
                    ; a0.l = routine address
                    ; a5.l = projectile_jmp_table
                    ; a6.l = projectile_list entry + 2
                    ;
                    ; Code Checked 2/1/2015
                    ;                  
badguy_grenade_right 
L00004802               addq.w  #$02,d0
L00004804               move.w  $0004(a6),d2
L00004808               cmp.w   #$0028,d2
L0000480c               bpl.b   L00004812
L0000480e               addq.w  #$01,$0004(a6)
L00004812               asr.w   #$02,d2
L00004814               bpl.b   L00004818
L00004816               addq.w  #$01,d2
L00004818               add.w   d2,d1
L0000481a               cmp.w   #$0060,d1
L0000481e               bpl.w   L00004760           ; remove_projectile ; rts in remove_projectile returns
                    ; fall through to common processing


                    ; --------------- bad guy grenade common ---------------
                    ; common code for bad guy grenade when thrown left and right.
                    ; test for grenade collision with batman. 
                    ; If so, deplete energy level & explode the grenade & play SFX.
                    ;
                    ; test for collision with wall, if so then explode the grenade & play SFX.
                    ;
                    ; d0.w = X - Current
                    ; d1.w = Y - Current
                    ; d2.l = #$00000000
                    ; d6.w = index into projectile_list
                    ; d7.w = projectile loop counter
                    ; a0.l = routine address
                    ; a5.l = projectile_jmp_table
                    ; a6.l = projectile_list entry + 2
                    ;
                    ; Code Checked 2/1/2015
                    ; 
badguy_grenade_common
L00004822               movem.w d0-d1,(a6)
L00004826               bsr.w   L000055e0       ; get_map_tile_at_display_offset_d0_d1
L0000482a               cmp.b   #$03,d2
L0000482e               bcs.b   L00004852 
L00004830               sub.w   L000069f2,d0
L00004834               addq.w  #$03,d0
L00004836               cmp.w   #$0007,d0
L0000483a               bcc.b   L0000485e
L0000483c               cmp.w   L000069f4,d1
L00004840               bpl.b   L0000485e
L00004842               cmp.w   L00006338,d1
L00004846               bmi.b   L0000485e
L00004848               moveq   #$06,d6
L0000484a               bsr.w   L00004d0a       ; batman_lose_energy
L0000484e               movem.w (a6),d0-d1
L00004852               move.w  #$000e,-$0002(a6)
L00004858               moveq   #$0d,d2         ; SFX_EXPLOSION
L0000485a               bra.w   L000044f4       ; play_proximity_sfx
L0000485e               rts  


                    ; --------------- bad guy grenade left ---------------
                    ; handle bad guy grenade thrown to the left.
                    ; update X, Y and check for off bottom of the screen
                    ;
                    ; d0.w = X - Current
                    ; d1.w = Y - Current
                    ; d2.l = #$00000000
                    ; d6.w = index into projectile_list
                    ; d7.w = projectile loop counter
                    ; a0.l = routine address
                    ; a5.l = projectile_jmp_table
                    ; a6.l = projectile_list entry + 2
                    ;
                    ; Code Checked 2/1/2015
                    ; 
badguy_grenade_left 
L00004860           subq.w  #$02,d0
L00004862           move.w  $0004(a6),d2
L00004866           cmp.w   #$0028,d2
L0000486a           bpl.b   L00004870
L0000486c           addq.w  #$01,$0004(a6)
L00004870           asr.w   #$02,d2
L00004872           bpl.b   L00004876
L00004874           addq.w  #$01,d2
L00004876           add.w   d2,d1
L00004878           cmp.w   #$0060,d1
L0000487c           bpl.w   L00004760       ; remove_projectile
L00004880           bra.b   L00004822       ; badguy_grenade_common


                    ; --------------- grenade explosion effect -----------------
                    ; Effect #14 is set to be executed after a grenade explodes.
                    ; Cycles through the handlers from 14-24 (10 handlers).
                    ; All handlers point to this routine.
                    ; When the last hander is executed, then the projectile is
                    ; removed from the list.  It's just a delay for the
                    ; grenade explosion, a bit of a hack, instead of holding
                    ; a couter value (which could be done in offset 6 of the struct (a6)
                    ;
                    ; d0.w = X - Current
                    ; d1.w = Y - Current
                    ; d2.l = #$00000000
                    ; d6.w = index into projectile_list
                    ; d7.w = projectile loop counter
                    ; a0.l = routine address
                    ; a5.l = projectile_jmp_table
                    ; a6.l = projectile_list entry + 2
                    ;
grenade_explosion_effect
L00004882               movem.w d0-d1,(a6)
L00004886               btst.b  #$0000,L00006375
L0000488c               bne.b   L000048a2
L0000488e               move.w  -$0002(a6),d2
L00004892               addq.w  #$01,d2
L00004894               cmp.w   #$0018,d2
L00004898               bne.w   L0000489e
L0000489c               clr.w   d2
L0000489e               move.w  d2,$0002(a6)
L000048a2               rts  


                    ; ------------------- projectile handler jump table -------------------------
                    ; Used by the update_projectiles routine, along with the handler/index id
                    ; stored in the projectile_list entry to execute code to handle the 
                    ; lifetime of the projectile, i.e. flight, collision, deactivation.
                    ;
                    ; Entries 5 & 6 - used to remove projectiles on next execution.
                    ;
                    ; The handler entries alternate odd/even, the handler index id is used
                    ; to decide on left/right sprites to draw in the 'draw_projectiles' 
                    ; routine. A hidden aspect of the draw routine which may or may not
                    ; have any impact to the game, as i'm not sure whether the projectiles
                    ; have different GFX for left/right facing items.
                    ; The Batman Bat-a-rang left/right lookups do-not conform to this,
                    ; maybe a bug or maybe intensional.
                    ;
                    ; Code Checked 2/1/2025
                    ;
projectile_jmp_table 
L000048A4           dc.l L00004796
                    dc.l L00004766
                    dc.l L0000477E 
                    dc.l L00004760 
                    dc.l L00004760 
                    dc.l L00004756 
                    dc.l L0000474A 
                    dc.l L00004736
L000048B4           dc.l L00004724
                    dc.l L00004712
                    dc.l L00004700 
                    dc.l L00004802 
                    dc.l L00004860 
                    dc.l L00004882 
                    dc.l L00004882 
                    dc.l L00004882
L000048C4           dc.l L00004882
                    dc.l L00004882
                    dc.l L00004882 
                    dc.l L00004882 
                    dc.l L00004882 
                    dc.l L00004882 
                    dc.l L00004882 
                    ;dc.l $00000000

projectile_list
L000048d2   
            dc.w $0000,$0000,$0000,$0000
            dc.w $0000,$0000,$0000,$0000
            dc.w $0000,$0000,$0000,$0000
            dc.w $0000,$0000,$0000,$0000
            dc.w $0000,$0000,$0000,$0000
            dc.w $0000,$0000,$0000,$0000
            dc.w $0000,$0000,$0000,$0000 
            dc.w $0000,$0000,$0000,$0000 
            dc.w $0000,$0000,$0000,$0000
            dc.w $0000,$0000,$0000,$0000 
            dc.w $0000,$0000,$0000,$0000 
            dc.w $0000,$0000,$0000,$0000 
            dc.w $0000,$0000,$0000,$0000
            dc.w $0000,$0000,$0000,$0000
            dc.w $0000,$0000,$0000,$0000
            dc.w $0000,$0000,$0000,$0000
            dc.w $0000,$0000,$0000,$0000
            dc.w $0000,$0000,$0000,$0000
            dc.w $0000,$0000,$0000,$0000 
            dc.w $0000,$0000,$0000,$0000

         ;------------------------------------------------------------------------------------------------------
        ; END OF - Projectile Handling Code & Data
        ;------------------------------------------------------------------------------------------------------
        ; 
        ;------------------------------------------------------------------------------------------------------



; Code1.s Line 3959



                    ;-----------------------------------------------------------------------------------------------
                    ; This routine manages the background level scrolling,
                    ; It draws the changes into the Off-Screen Buffer (kinda like a circular buffer of screen data)
                    ;
                    ;-----------------------------------------------------------------------------------------------
temp_vertical_scroll_increments 

L00004972   dc.w $0000 

L00004974               movem.w L000069f4,d1-d2
L0000497a               move.w  d1,d0
L0000497c               sub.w   d2,d0
L0000497e               move.w  L00006358,L00004972
L00004984               move.w  d0,L00006358
L00004988               beq.w   L00004a2a 

                    ; think this is doing something to set the scroll speed.
                    ; it's fannying around with values in d0.
                    ; d0 is an offset added to the window Y coord further below.
scroll_speed_shenanigans 
L0000498c               tst.w   L00006342
L00004990               bmi.b   L000049aa
L00004992               beq.b   L000049be
L00004994               cmp.w   #$0004,d0
L00004998               bcs.b   L000049be
L0000499a               cmp.w   #$fffd,d0       ; -3
L0000499e               bcc.b   L000049be
L000049a0               bpl.b   L000049a6
L000049a2               moveq   #$fe,d0         ; -2
L000049a4               bra.b   L000049be

L000049a6               moveq   #$02,d0
L000049a8               bra.b   L000049be

L000049aa               cmp.w   #$0008,d0
L000049ae               bcs.b   L000049be
L000049b0               cmp.w   #$fffd,d0       ; -3
L000049b4               bcc.b   L000049be
L000049b6               bmi.b   L000049bc
L000049b8               moveq   #$07,d0
L000049ba               bra.b   L000049be
L000049bc               moveq   #$fd,d0         ; -3

.continue_vertical_scroll  
L000049be               move.w  L000069ee,d1
L000049c2               move.w  d1,d3
L000049c4               add.w   d0,d1
L000049c6               cmp.w   #$0601,d1
L000049ca               bcs.b   L000049de

L000049cc               bmi.b   L000049da

.clamp_y_max        ; clamp to max Y coord     
L000049ce               move.w  #$0600,d2
L000049d2               sub.w   d2,d1
L000049d4               sub.w   d1,d0
L000049d6               move.w  d2,d1
L000049d8               bra.b   L000049de

.clamp_y_min        ; clamp to min Y coord?   
L000049da               sub.w   d1,d0
L000049dc               clr.w   d1

.update_y_scroll_position   ; original address L000049a0
L000049de               sub.w   d0,L000069f4
L000049e2               move.w  d1,L000069ee

check_vertical_scroll  ; original address L000049a8
                    ; calculate the number of increments to scroll
L000049e6               sub.w   d3,d1
L000049e8               move.w  d1,L00006358
L000049ec               beq.b   L00004a2a
L000049ee               bmi.b   L00004a12

scroll_display_window_down 
L000049f0               add.w   #$0057,d3
L000049f4               move.w  L0000635a,d2
L000049f8               move.w  d1,d4
L000049fa               add.w   d2,d4
L000049fc               cmp.w   #$0057,d4
L00004a00               bcs.b   L00004a06
.is_display_wrap
L00004a02               sub.w   #$0057,d4
.no_display_wrap
L00004a06               move.w  d4,L0000635a
L00004a0a               bsr.w   L00004a9c
L00004a0e               bra.w   L00004a2a
                    ;---------------------------------------

                    ; scroll display up (e.g. climbing upwards)
                    ; NB: d1 is negative
scroll_display_window_up 
L00004a12               move.w  L0000635a,d2
L00004a16               add.w   d1,d2
L00004a18               bpl.b   L00004a1e
.is_enderflow_wrap
L00004a1a               add.w   #$0057,d2
.no_underflow_wrap 
L00004a1e               move.w  d2,L0000635a
L00004a22               add.w   d1,d3
L00004a24               neg.w   d1
L00004a26               bsr.w   L00004a9c       ; draw_background_vertical_scroll

                    ; ------- do horizontal scroll -------
do_horizontal_scroll
L00004a2a               move.w  L000069f2,d0
L00004a2e               sub.w   L000069f8,d0
L00004a32               move.w  d0,L00006356
L00004a36               beq.w   L00004a9a

L00004a3a               move.w  L000069ec,d1

.test_min_X         ; test window min X value (0)
L00004a3e               move.w  d1,d2
L00004a40               add.w   d0,d1
L00004a42               bpl.b   L00004a4a

.clamp_low_X        ; clamp window at X=0
L00004a44               move.w  d1,d0
L00004a46               clr.w   d1
L00004a48               bra.b   L00004a5a

.test_max_X        ; test window max X value
L0004a4a                clr.w   d0
L0004a4c                cmp.w   #$0230,d1
L0004a50                bls.b   L00004a5a

.clamp_max_X        ; clamp window at x = #$230
L00004a52               move.w  #$0230,d0
L00004a56               sub.w   d0,d1
L00004a58               exg.l   d1,d0

.cont_horiz_scroll  ; calc amount of horizontal scroll  
L00004a5a               add.w   L000069f8,d0
L00004a5e               move.w  d0,L000069f2
L00004a62               move.w  d1,L000069ec
L00004a66               move.w  d1,d3
L00004a68               sub.w   d2,d3
L00004a6a               move.w  d3,L00006356
L00004a6e               beq.b   L00004a9a

                    ; check if coarse scroll     
L00004a70               eor.w   d1,d2
L00004a72               btst.l  #$0003,d2
L00004a76               beq.b   L00004a9a

                    ; set up coarse scroll  
L00004a78               movea.l L00006366,a4
L00004a7c               tst.w   d3
L00004a7e               bmi.b   L00004a90

.scroll_right       ; do scroll right 
L00004a80               add.w   #$00a0,d1
L00004a84               addq.w  #$02,a4
L00004a86               move.l  a4,L00006366
L00004a8a               lea.l   $0028(a4),a4
L00004a8e               bra.b   L00004a96

.scroll_left        ; do scroll left. L00004a52
L00004a90               subq.w  #$02,a4
L00004a92               move.l  a4,L00006366

.update_horizontal  ; draw new column of tile map
L00004a96               bsr.w   L00004b14

.exit_horizontal_scroll ; original address L00004a5c
L00004a9a               rts


                    ; -------------------- draw background vertical scroll --------------------
                    ; The vertical scroll window moves 2 rasters at a time.
                    ; This routine draws 2 raster lines of graphics that are being scrolled 
                    ; into the new window when the screen scrolls vertically.
                    ;
                    ; NB: This routine draws the background information into the 
                    ;       off-screen buffer. This buffer is a then presented into
                    ;       
                    ;
                    ; The way the scroll window works is that it moves to keep batman in
                    ; the frame.  The vertical scroll moves when the joystick movement
                    ; is made up/down and allows the player to see more background
                    ; displayed above or below batman on thhe platforms.
                    ;
                    ; it also scrolls when batman is hanging on his batrope.
                    ; it also scrolls when batman is falling between platforms.
                    ; it also scrolls when batman is climbing a ladder.
                    ;
                    ; IN:
                    ;   d1.w - Number of 'scroll' counts (two raster lines per scroll)
                    ;   d2.w - Destination GFX Buffer Y Value to add scroll GFX into. - Y value is divided by 2
                    ;   d3.w - Y value of world/tilemap location to display - Y value is divided by 2
                    ;   a3.l - source base gfx ptr
                    ;
draw_background_vertical_scroll
L00004a9c               subq.w  #$01,d1

                    ; calc source gfx start offset (depends on soft scroll value)
                    ; self modified code, updates LEA offset value below.
.draw_next_scroll_line ; draw new line (2 rasters) of scroll gfx
L00004a9e               move.w  d3,d4
L00004aa0               and.w   #$0007,d4
L00004aa4               asl.w   #$04,d4
L00004aa6               move.b  d4,gfx_lea_offset       ; L00004adf 

                    ; calc Y offset into map tile map data
L00004aac               move.w  d3,d4
L00004aae               lsr.w   #$03,d4
L00004ab0               lea.l   $00008002,a0            ; MAPGR_BASE
L00004ab6               mulu.w  (a0),d4

                    ; calc X offset into map tile map data
L00004ab8               move.w  L000069ec,d0
L00004abc               lsr.w   #$03,d0

                    ; calc total offset into tile map data
L00004abe               add.w   d0,d4
L00004ac0               lea.l   $7a(a0,d4.w),a0         ; MAPGR_TILEDATA_OFFSET

                    ; calc gfx destination address
L00004ac4               move.w  d2,d4
L00004ac6               mulu.w  #$0054,d4
L00004aca               add.l   L00006366,d4
L00004ace               movea.l d4,a1

                    ; Initialise Draw Loop 
                    ; width of display buffer - #$14 (21) words
L00004ad0               moveq   #$14,d7
L00004ad2               movea.l L00006352,a2

.draw_next_block    ; draw tile gfx (2 rasters worth)
L00004ad6               clr.w   d0
L00004ad8               move.b  (a0)+,d0
L00004ada               asl.w   #$07,d0

                    ; calc gfx source address ptr 
                    ; lea.l   $XX(a2,d0.W),a3 - Self Modified Code 
;00004adc                lea.l $00(a2,d0.W),a3
                        dc.w    $47f2                               ; lea.l   $XX(a2,d0.W),a3 - Self Modified Code                          
                        dc.b    $00
gfx_lea_offset          dc.b    $00                                 ; $XX - byte offset value - original address L00004aa1

                    ; draw gfx block (2 rasters)
L00004ae0               move.w  (a3)+,(a1)+
L00004ae2               move.w  (a3)+,$1c8a(a1)
L00004ae6               move.w  (a3)+,$3916(a1)
L00004aea               move.w  (a3)+,$55a2(a1)
L00004aee               move.w  (a3)+,$0028(a1)
L00004af2               move.w  (a3)+,$1cb4(a1)
L00004af6               move.w  (a3)+,$3940(a1)
L00004afa               move.w  (a3)+,$55cc(a1)
L00004afe               dbf.w   d7,L00004ad6

                        ; update Y co-ords
L00004b02               addq.w  #$01,d3
L00004b04               addq.w  #$01,d2

                        ; test for dest gfx buffer overrun
L00004b06               cmp.w   #$0057,d2
L00004b0a               bcs.b   L00004b0e
L00004b0c               clr.w   d2
L00004b0e               dbf.w   d1,L00004a9e
L00004b12               rts  



                    ; -------------------- draw background vertical scroll --------------------
                    ; draw background screen blocks for Horizonal Scroll.
                    ; Draws a column of tiles into the offscreen buffer.
                    ;
                    ; The draw loops for the tile are 'upsidedown' see 'dbf' at display_gfx_loop
                    ; this makes understanding the draw a little more complicated.
                    ; the d5 in this loop represents the count of 2 rasters of gfx displayed.
                    ; once this loop ends it moves on to the next tile to draw.
                    ;
                    ; IN: -
                    ;   d1.w = world X co-ordinate
                    ;   a4.l = offscreen display buffer. 
                    ;
draw_background_horizontal_scroll    
L00004b14               movea.l L00006352,a2
L00004b18               move.w  d1,d2
L00004b1a               lsr.w   #$03,d2
L00004b1c               move.w  L000069ee,d1
L00004b20               move.w  d1,d0
L00004b22               and.w   #$0007,d0
L00004b26               move.w  d0,d5
L00004b28               not.w   d5
L00004b2a               and.w   #$0007,d5
L00004b2e               lsl.w   #$04,d0
L00004b30               lsr.w   #$03,d1
L00004b32               lea.l   $00008002,a0        ; MAPGR_BASE
L00004b38               move.w  (a0),d4
L00004b3a               mulu.w  d4,d1
L00004b3c               add.w   d2,d1
L00004b3e               lea.l   $7a(a0,d1.w),a0     ; MAPGR_TILEDATA_OFFSET
L00004b42               moveq   #$56,d7
L00004b44               move.w  L0000635a,d1
L00004b48               moveq   #$56,d6
L00004b4a               sub.w   d1,d6
L00004b4c               mulu.w  #$0054,d1
L00004b50               lea.l   $00(a4,d1.l),a1

L00004b54               clr.w   d1
L00004b56               move.b  (a0),d1
L00004b58               asl.w   #$07,d1
L00004b5a               add.w   d1,d0
L00004b5c               bra.b   L00004b6a

L00004b5e               dbf.w   d5,L00004b70

L00004b62               moveq   #$07,d5
L00004b64               clr.w   d0
L00004b66               move.b  (a0),d0
L00004b68               asl.w   #$07,d0

L00004b6a               lea.l   $00(a2,d0.w),a3
L00004b6e               adda.w  d4,a0

L00004b70               move.w  (a3)+,(a1)
L00004b72               move.w  (a3)+,$1c8c(a1)
L00004b76               move.w  (a3)+,$3918(a1)
L00004b7a               move.w  (a3)+,$55a4(a1)
L00004b7e               move.w  (a3)+,$002a(a1)
L00004b82               move.w  (a3)+,$1cb6(a1)
L00004b86               move.w  (a3)+,$3942(a1)
L00004b8a               move.w  (a3)+,$55ce(a1)
L00004b8e               lea.l   $0054(a1),a1
L00004b92               dbf.w   d6,L00004b9a
L00004b96               lea.l   -$1c8c(a1),a1
L00004b9a               dbf.w   d7,L00004b5e
L00004b9e               rts  


                    ;-------------------- copy off-screen buffer to back buffer --------------------------
                    ; This routine copies the background scroll GFX from the off-screen buffer into
                    ; the back buffer of the double-buffered display.
                    ;
                    ; the offscreen buffer is circular (i.e it wraps in the Y direction)
                    ; This means that the start (source gfx ptr) of the back buffer may vary any number
                    ; of rasters down into the buffer.
                    ;
                    ; so, when the gfx in the off-screen buffer aligned to the top, then only a single
                    ; full screen blit is required.
                    ;
                    ; whem the gfx in the offscreen buffer starts (x) rasters down the buffer then
                    ; the gfx requires two blits to the back buffer.
                    ;   1) one for the first section of the display
                    ;   2) for the wrapped portion of the display. 
                    ;
                    ; I like to think of the back buffer like an old CRT monitor where the picture
                    ; is rolling (mechanism used to manage the 8 way scrolling without requiring huge
                    ; double buffering)
                    ;;
                    ; This off-screen buffer needs to be re-aligned to the back buffer before
                    ; being displayed to the player.
                    ;
copy_offscreen_to_backbuffer 
L00004ba0               move.w  #$8400,$00dff096
L00004ba8               movea.l L000036ea,a6
L00004bac               subq.w  #$02,a6
L00004bae               movea.l L00006366,a5
L00004bb2               move.w  L0000635a,d1
L00004bb6               clr.l   d6
L00004bb8               subq.w  #$01,d6
L00004bba               swap.w  d6
L00004bbc               move.w  L000069ec,d2
L00004bc0               and.w   #$0007,d2
L00004bc4               beq.b   L00004bca 
L00004bc6               ror.l   d2,d6
L00004bc8               ror.l   d2,d6
L00004bca               neg.w   d2
L00004bcc               ror.w   #$03,d2
L00004bce               and.l   #$0000e000,d2
L00004bd4               bne.b   L00004bd8
L00004bd6               addq.w  #$02,a6
L00004bd8               or.w    #$09f0,d2
L00004bdc               swap.w  d2
L00004bde               move.w  d1,d4
L00004be0               mulu.w  #$0054,d4
L00004be4               lea.l   $00(a5,d4.l),a1
L00004be8               movea.l a6,a0
L00004bea               moveq   #$28,d3
L00004bec               move.w  #$00ae,d4
L00004bf0               sub.w   d1,d4
L00004bf2               sub.w   d1,d4
L00004bf4               bsr.w   L00004c1c
L00004bf8               move.w  d1,d4
L00004bfa               beq.b   L00004c12
L00004bfc               moveq   #$57,d3
L00004bfe               sub.w   d4,d3
L00004c00               mulu.w  #$0054,d3
L00004c04               lea.l   $00(a6,d3.l),a0
L00004c08               add.w   d4,d4
L00004c0a               moveq   #$28,d3
L00004c0c               lea.l   (a5),a1
L00004c0e               bsr.w   L00004c1c
L00004c12               move.w  #$0400,$00dff096
L00004c1a               rts  


                    ; -------------------- blit source to destination --------------------
                    ; Routine used by the copy_offscreen_to_backbuffer routine above
                    ; to copy the off-screen background scroll gfx into the back buffer
                    ; of the double buffered display.
                    ;
                    ; IN:-
                    ;   d2.l = BLTCON0 & BLTCON1 ($x9f00000) x = shift
                    ;   d3.w = Blit Width
                    ;   d4.w = Blit Height
                    ;   d6.l = firstword/lastwoord mask
                    ;   a0.l = DEST Blitter Address ptr
                    ;   a1.l = GFX Source Address ptr
blit_src_to_dest 
L00004c1c               move.l  d2,d5
L00004c1e               swap.w  d5
L00004c20               and.w   #$e000,d5
L00004c24               addq.w  #$02,d3
L00004c26               asl.w   #$06,d4
L00004c28               move.w  d3,d5
L00004c2a               lsr.w   #$01,d5
L00004c2c               add.w   d5,d4
L00004c2e               sub.w   #$002a,d3
L00004c32               neg.w   d3
L00004c34               lea.l   $00dff000,a4
L00004c3a               move.l  #$00001c8c,d5
L00004c40               btst.b  #$0006,$00dff002
L00004c48               bne.b   L00004c40
L00004c4a               move.l  d6,$0044(a4)
L00004c4e               move.w  d3,$0064(a4)
L00004c52               move.w  d3,$0066(a4)
L00004c56               move.l  d2,$0040(a4)
L00004c5a               moveq   #$03,d7
L00004c5c               btst.b  #$0006,$00dff002
L00004c64               bne.b   L00004c5c
L00004c66               move.l  a1,$0050(a4)
L00004c6a               move.l  a0,$0054(a4)
L00004c6e               move.w  d4,$0058(a4)
L00004c72               adda.l  d5,a1
L00004c74               adda.l  d5,a0
L00004c76               dbf.w   d7,L00004c5c 
L00004c7a               rts 

                    ;-----------------------------------------------------------------
                    ; Player Move Commands
                    ;-----------------------------------------------------------------
                    ; Perform the player move command using the player_input_command
                    ; value read from the current joystick inputs.
                    ; Jump table into player input/movement commands
                    ;
                    ; IN:-
                    ;   - D0.w = L000067c2 - batman_x_offset
                    ;   - D1.w = L000067c4 - batman_y_offset
                    ; 
                    ; Code Checked 3/1/2025
                    ;
player_move_commands  
L00004c7c               clr.w   d2
L00004c7e               move.b  L00006350,d2
L00004c82               asl.w   #$02,d2
L00004c84               movea.l player_input_cmd_table(pc,d2.w),a0      ; $00004c8a
L00004c88               jmp     (a0)

                    ; ------------- player input jump table ------------
                    ; the player_input_command byte is used as an index
                    ; into the table to execute the command associated
                    ; with the jotstick input.
                    ;
                    ; Code Checked 3/1/2025
                    ;
player_input_cmd_table 

L00004C8A           dc.l $000052B6  
                    dc.l $0000526C 
                    dc.l $000052C2 
                    dc.l $000052B6  
L00004C9A           dc.l $0000542C 
                    dc.l $00005266 
                    dc.l $000052B8 
                    dc.l $000052B6  
L00004CAA           dc.l $00005236 
                    dc.l $0000526A 
                    dc.l $000052BE 
                    dc.l $000052B6  
L00004CBA           dc.l $000052B6 
                    dc.l $000052B6 
                    dc.l $000052B6 
                    dc.l $000052B6  
L00004CCA           dc.l $0000501E 
                    dc.l $0000501E 
                    dc.l $0000501E 
                    dc.l $0000501E  
L00004CDA           dc.l $0000540E 
                    dc.l $0000540E 
                    dc.l $0000540E 
                    dc.l $0000540E  
L00004CEA           dc.l $00005136 
                    dc.l $00005124 
                    dc.l $0000512C 
                    dc.l $000052B6  
L00004CFA           dc.l $000052B6 
                    dc.l $000052B6 
                    dc.l $000052B6 
                    dc.l $000052B6 

00004d0a 4a39 0007 c874           tst.b $0007c874 [00]
00004d10 6662                     bne.b #$62 == $00004d74 (T)
00004d12 48e7 ff06                movem.l d0-d7/a5-a6,-(a7)
00004d16 3006                     move.w d6,d0
00004d18 4eb9 0007 c870           jsr $0007c870
00004d1e 4cdf 60ff                movem.l (a7)+,d0-d7/a5-a6
00004d22 3438 3c7c                move.w $3c7c [4c7c],d2
00004d26 0c42 54ba                cmp.w #$54ba,d2
00004d2a 6748                     beq.b #$48 == $00004d74 (F)
00004d2c 363c 4e78                move.w #$4e78,d3

00004d30 b443                     cmp.w d3,d2
00004d32 6726                     beq.b #$26 == $00004d5a (F)
00004d34 0c42 4ea2                cmp.w #$4ea2,d2
00004d38 6720                     beq.b #$20 == $00004d5a (F)
00004d3a 0c42 5096                cmp.w #$5096,d2
00004d3e 6736                     beq.b #$36 == $00004d76 (F)
00004d40 363c 4d86                move.w #$4d86,d3
00004d44 0c42 532e                cmp.w #$532e,d2
00004d48 6710                     beq.b #$10 == $00004d5a (F)
00004d4a b642                     cmp.w d2,d3
>d
00004d4c 670c                     beq.b #$0c == $00004d5a (F)
00004d4e 41f8 548f                lea.l $548f,a0
00004d52 6100 071c                bsr.w #$071c == $00005470
00004d56 363c 4d94                move.w #$4d94,d3
00004d5a 31c3 3c7c                move.w d3,$3c7c [4c7c]
00004d5e 3438 634e                move.w $634e [0000],d2
00004d62 dc46                     add.w d6,d6
00004d64 dc46                     add.w d6,d6
00004d66 d446                     add.w d6,d2
00004d68 0c42 000c                cmp.w #$000c,d2
>d
00004d6c 6502                     bcs.b #$02 == $00004d70 (F)
00004d6e 740c                     moveq #$0c,d2
00004d70 31c2 634e                move.w d2,$634e [0000]
00004d74 4e75                     rts  == $6000001a
00004d76 3438 633a                move.w $633a [0000],d2
00004d7a d446                     add.w d6,d2
00004d7c d446                     add.w d6,d2
00004d7e d446                     add.w d6,d2
00004d80 31c2 633a                move.w d2,$633a [0000]
00004d84 4e75                     rts  == $6000001a
>d
00004d86 5378 634e                subq.w #$01,$634e [0000]
00004d8a 66e8                     bne.b #$e8 == $00004d74 (T)
00004d8c 31fc 532e 3c7c           move.w #$532e,$3c7c [4c7c]
00004d92 6024                     bra.b #$24 == $00004db8 (T)
00004d94 4a78 6360                tst.w $6360 [0000]
00004d98 6704                     beq.b #$04 == $00004d9e (F)
00004d9a 6100 0452                bsr.w #$0452 == $000051ee
00004d9e 5378 634e                subq.w #$01,$634e [0000]
00004da2 66d0                     bne.b #$d0 == $00004d74 (T)
00004da4 31fc 4c7c 3c7c           move.w #$4c7c,$3c7c [4c7c]

00004daa 4a78 6360                tst.w $6360 [0000]
00004dae 6704                     beq.b #$04 == $00004db4 (F)
00004db0 6100 0434                bsr.w #$0434 == $000051e6
00004db4 6100 06b2                bsr.w #$06b2 == $00005468
00004db8 4a39 0007 c874           tst.b $0007c874 [00]
00004dbe 67b4                     beq.b #$b4 == $00004d74 (F)
00004dc0 4eb9 0004 8004           jsr $00048004
00004dc6 4278 6360                clr.w $6360 [0000]
00004dca 7003                     moveq #$03,d0
00004dcc 4eb9 0004 8010           jsr $00048010
>d
00004dd2 31fc 4de0 3c7c           move.w #$4de0,$3c7c [4c7c]
00004dd8 31fc 6424 636e           move.w #$6424,$636e [0000]
00004dde 4e75                     rts  == $6000001a
00004de0 3078 636e                movea.w $636e [0000],a0
00004de4 6100 068a                bsr.w #$068a == $00005470
00004de8 31c8 636e                move.w a0,$636e [0000]
00004dec 4a10                     tst.b (a0) [00]
00004dee 6684                     bne.b #$84 == $00004d74 (T)
00004df0 4eb9 0004 800c           jsr $0004800c
00004df6 303c 0032                move.w #$0032,d0
>d
00004dfa 6100 10d8                bsr.w #$10d8 == $00005ed4
00004dfe 6100 0066                bsr.w #$0066 == $00004e66
00004e02 0839 0000 0007 c874      btst.b #$0000,$0007c874 [00]
00004e0a 6708                     beq.b #$08 == $00004e14 (F)
00004e0c 41f8 4e5a                lea.l $4e5a,a0
00004e10 6100 1be8                bsr.w #$1be8 == $000069fa
00004e14 0839 0001 0007 c874      btst.b #$0001,$0007c874 [00]
00004e1c 6708                     beq.b #$08 == $00004e26 (F)
00004e1e 41f8 4e4c                lea.l $4e4c,a0
00004e22 6100 1bd6                bsr.w #$1bd6 == $000069fa
>d
00004e26 6100 ee82                bsr.w #$ee82 == $00003caa
00004e2a 303c 001e                move.w #$001e,d0
00004e2e 6100 10a4                bsr.w #$10a4 == $00005ed4
00004e32 0839 0001 0007 c874      btst.b #$0001,$0007c874 [00]
00004e3a 6700 ecb0                beq.w #$ecb0 == $00003aec (F)
00004e3e 4eb9 0004 8004           jsr $00048004
00004e44 6100 ef30                bsr.w #$ef30 == $00003d76
00004e48 6000 b9d6                bra.w #$b9d6 == $00000820 (T)

00004E4C 5F0F 4741 4D45 2020 4F56 4552 00FF 4310  ;_.GAME  OVER..C.
00004E5C 5449 4D45 2020 5550 00FF                 ;TIME  UP.. y..6.

>d 4e66
00004e66 2079 0000 36ea           movea.l $000036ea [00061b9c],a0
00004e6c 3e3c 1c8b                move.w #$1c8b,d7
00004e70 4298                     clr.l (a0)+ [003c004a]
00004e72 51cf fffc                dbf .w d7,#$fffc == $00004e70 (F)
00004e76 4e75                     rts  == $6000001a
00004e78 7610                     moveq #$10,d3
00004e7a 4a39 0007 c874           tst.b $0007c874 [00]
00004e80 661c                     bne.b #$1c == $00004e9e (T)
00004e82 41f8 6360                lea.l $6360,a0
00004e86 3410                     move.w (a0) [003c],d2

>d
00004e88 0c42 0050                cmp.w #$0050,d2
00004e8c 6410                     bcc.b #$10 == $00004e9e (T)
00004e8e 5250                     addq.w #$01,(a0) [003c]
00004e90 4243                     clr.w d3
00004e92 5378 634e                subq.w #$01,$634e [0000]
00004e96 6606                     bne.b #$06 == $00004e9e (T)
00004e98 31fc 4ea2 3c7c           move.w #$4ea2,$3c7c [4c7c]
00004e9e 11c3 6350                move.b d3,$6350 [00]
00004ea2 41f8 6360                lea.l $6360,a0
00004ea6 3a10                     move.w (a0) [003c],d5
>d
00004ea8 1838 6350                move.b $6350 [00],d4
00004eac 0804 0003                btst.l #$0003,d4
00004eb0 6734                     beq.b #$34 == $00004ee6 (F)
00004eb2 31fc 0048 69f6           move.w #$0048,$69f6 [0048]
00004eb8 5345                     subq.w #$01,d5
00004eba 6228                     bhi.b #$28 == $00004ee4 (T)
00004ebc 4250                     clr.w (a0) [003c]
00004ebe 31fc 5096 3c7c           move.w #$5096,$3c7c [4c7c]
00004ec4 31fc 0005 633a           move.w #$0005,$633a [0000]
00004eca 31fc 646e 636e           move.w #$646e,$636e [0000]
>d
00004ed0 3401                     move.w d1,d2
00004ed2 d478 69ee                add.w $69ee [00f0],d2
00004ed6 5542                     subq.w #$02,d2
00004ed8 0242 0007                and.w #$0007,d2
00004edc 9242                     sub.w d2,d1
00004ede 31c1 69f4                move.w d1,$69f4 [0048]
00004ee2 4e75                     rts  == $6000001a
00004ee4 3085                     move.w d5,(a0) [003c]
00004ee6 0804 0002                btst.l #$0002,d4
00004eea 6700 0012                beq.w #$0012 == $00004efe (F)
>d
00004eee 31fc 0028 69f6           move.w #$0028,$69f6 [0048]
00004ef4 5245                     addq.w #$01,d5
00004ef6 0c45 0050                cmp.w #$0050,d5
00004efa 6402                     bcc.b #$02 == $00004efe (T)
00004efc 3085                     move.w d5,(a0) [003c]
00004efe 41f8 635c                lea.l $635c,a0
00004f02 4c90 000c                movem.w (a0),d2-d3
00004f06 4247                     clr.w d7
00004f08 7c07                     moveq #$07,d6
00004f0a 0c45 0028                cmp.w #$0028,d5


00004f0e 640a                     bcc.b #$0a == $00004f1a (T)
00004f10 7c03                     moveq #$03,d6
00004f12 0c46 0014                cmp.w #$0014,d6
00004f16 6402                     bcc.b #$02 == $00004f1a (T)
00004f18 7c01                     moveq #$01,d6
00004f1a cc78 6374                and.w $6374 [0000],d6
00004f1e 660a                     bne.b #$0a == $00004f2a (T)
00004f20 0244 0003                and.w #$0003,d4
00004f24 e244                     asr.w #$01,d4
00004f26 9947                     subx.w d7,d4
>d
00004f28 3e04                     move.w d4,d7
00004f2a 3802                     move.w d2,d4
00004f2c 48c4                     ext.l d4
00004f2e 89c5                     divs.w d5,d4
00004f30 9847                     sub.w d7,d4
00004f32 d644                     add.w d4,d3
00004f34 9443                     sub.w d3,d2
00004f36 0642 0080                add.w #$0080,d2
00004f3a 0c42 0100                cmp.w #$0100,d2
00004f3e 6406                     bcc.b #$06 == $00004f46 (T)
>d
00004f40 0442 0080                sub.w #$0080,d2
00004f44 600e                     bra.b #$0e == $00004f54 (T)
00004f46 4243                     clr.w d3
00004f48 0442 0080                sub.w #$0080,d2
00004f4c 6a04                     bpl.b #$04 == $00004f52 (T)
00004f4e 7481                     moveq #$81,d2
00004f50 6002                     bra.b #$02 == $00004f54 (T)
00004f52 747f                     moveq #$7f,d2
00004f54 4890 000c                movem.w d2-d3,(a0)
00004f58 41f8 635c                lea.l $635c,a0
>d
00004f5c 45f8 69f2                lea.l $69f2,a2
00004f60 6100 0186                bsr.w #$0186 == $000050e8
00004f64 4cb8 0003 69f2           movem.w $69f2,d0-d1
00004f6a 4cb8 0060 6370           movem.w $6370,d5-d6
00004f70 9a43                     sub.w d3,d5
00004f72 31c5 633c                move.w d5,$633c [0000]
00004f76 31c5 6356                move.w d5,$6356 [0000]
00004f7a 9846                     sub.w d6,d4
00004f7c 31c4 633e                move.w d4,$633e [0000]
00004f80 d244                     add.w d4,d1


>d
00004f82 d045                     add.w d5,d0
00004f84 5941                     subq.w #$04,d1
00004f86 5b40                     subq.w #$05,d0
00004f88 6100 0656                bsr.w #$0656 == $000055e0
00004f8c 7e02                     moveq #$02,d7
00004f8e 1430 3000                move.b (a0,d3.W,$00) == $00000c77 [00],d2
00004f92 0c02 0003                cmp.b #$03,d2
00004f96 6534                     bcs.b #$34 == $00004fcc (F)
00004f98 1430 3001                move.b (a0,d3.W,$01) == $00000c78 [00],d2
00004f9c 0c02 0003                cmp.b #$03,d2
>d
00004fa0 652a                     bcs.b #$2a == $00004fcc (F)
00004fa2 9679 0000 8002           sub.w $00008002 [0058],d3
00004fa8 51cf ffe4                dbf .w d7,#$ffe4 == $00004f8e (F)
00004fac 4cb8 0003 69f2           movem.w $69f2,d0-d1
00004fb2 d244                     add.w d4,d1
00004fb4 d045                     add.w d5,d0
00004fb6 48b8 0003 69f2           movem.w d0-d1,$69f2
00004fbc 21f8 6362 6370           move.l $6362 [00000034],$6370 [00000000]
00004fc2 0838 0004 6350           btst.b #$0004,$6350 [00]
00004fc8 6622                     bne.b #$22 == $00004fec (T)
>d
00004fca 4e75                     rts  == $6000001a
00004fcc 4a44                     tst.w d4
00004fce 6b08                     bmi.b #$08 == $00004fd8 (F)
00004fd0 5578 6360                subq.w #$02,$6360 [0000]
00004fd4 6000 ff82                bra.w #$ff82 == $00004f58 (T)
00004fd8 48a7 ff00                movem.w d0-d7,-(a7)
00004fdc 7c02                     moveq #$02,d6
00004fde 6100 fd2a                bsr.w #$fd2a == $00004d0a
00004fe2 4c9f 00ff                movem.w (a7)+,d0-d7
00004fe6 4244                     clr.w d4
>d
00004fe8 4245                     clr.w d5
00004fea 601e                     bra.b #$1e == $0000500a (T)
00004fec 4cb8 0030 633c           movem.w $633c,d4-d5
00004ff2 5745                     subq.w #$03,d5
00004ff4 0c45 fffa                cmp.w #$fffa,d5
00004ff8 6a02                     bpl.b #$02 == $00004ffc (T)
00004ffa 7afa                     moveq #$fa,d5
00004ffc 5544                     subq.w #$02,d4
00004ffe 0c44 fffc                cmp.w #$fffc,d4
00005002 6404                     bcc.b #$04 == $00005008 (T)



>d
00005004 5bc4                     smi.b d4 (F)
00005006 e544                     asl.w #$02,d4
00005008 5444                     addq.w #$02,d4
0000500a 48b8 0030 633c           movem.w d4-d5,$633c
00005010 4278 6360                clr.w $6360 [0000]
00005014 4cb8 0003 69f2           movem.w $69f2,d0-d1
0000501a 6000 0480                bra.w #$0480 == $0000549c (T)
0000501e 33fc 6461 0000 636e      move.w #$6461,$0000636e [0000]
00005026 31fc 5034 3c7c           move.w #$5034,$3c7c [4c7c]
0000502c 7008                     moveq #$08,d0
>d
0000502e 4eb9 0004 8014           jsr $00048014
00005034 3078 636e                movea.w $636e [0000],a0
00005038 6100 0436                bsr.w #$0436 == $00005470
0000503c 31c8 636e                move.w a0,$636e [0000]
00005040 4a10                     tst.b (a0) [00]
00005042 662e                     bne.b #$2e == $00005072 (T)
00005044 31fc 0008 633a           move.w #$0008,$633a [0000]
0000504a 31fc 5074 3c7c           move.w #$5074,$3c7c [4c7c]
00005050 6100 f62a                bsr.w #$f62a == $0000467c
00005054 0440 0007                sub.w #$0007,d0
>d
00005058 3438 6336                move.w $6336 [0001],d2
0000505c 5ac2                     spl.b d2 (T)
0000505e 4882                     ext.w d2
00005060 6a04                     bpl.b #$04 == $00005066 (T)
00005062 0640 000e                add.w #$000e,d0
00005066 5642                     addq.w #$03,d2
00005068 30c2                     move.w d2,(a0)+ [003c]
0000506a 0441 0010                sub.w #$0010,d1
0000506e 4890 0003                movem.w d0-d1,(a0)
00005072 4e75                     rts  == $6000001a
>d
00005074 1839 0000 6350           move.b $00006350 [00],d4
0000507a 6600 0010                bne.w #$0010 == $0000508c (T)
0000507e 5378 633a                subq.w #$01,$633a [0000]
00005082 66ee                     bne.b #$ee == $00005072 (T)
00005084 41f8 641b                lea.l $641b,a0
00005088 6000 03e6                bra.w #$03e6 == $00005470 (T)
0000508c 31fc 4c7c 3c7c           move.w #$4c7c,$3c7c [4c7c]
00005092 6000 fbe8                bra.w #$fbe8 == $00004c7c (T)
00005096 5378 633a                subq.w #$01,$633a [0000]
0000509a 66d6                     bne.b #$d6 == $00005072 (T)


>d
0000509c 31fc 0006 633a           move.w #$0006,$633a [0000]
000050a2 5b78 69f4                subq.w #$05,$69f4 [0048]
000050a6 5941                     subq.w #$04,d1
000050a8 3438 6336                move.w $6336 [0001],d2
000050ac 6b12                     bmi.b #$12 == $000050c0 (F)
000050ae 5e40                     addq.w #$07,d0
000050b0 6100 052e                bsr.w #$052e == $000055e0
000050b4 0c02 0003                cmp.b #$03,d2
000050b8 6516                     bcs.b #$16 == $000050d0 (F)
000050ba 5278 69f2                addq.w #$01,$69f2 [0050]
>d
000050be 6010                     bra.b #$10 == $000050d0 (T)
000050c0 5d40                     subq.w #$06,d0
000050c2 6100 051c                bsr.w #$051c == $000055e0
000050c6 0c02 0003                cmp.b #$03,d2
000050ca 6504                     bcs.b #$04 == $000050d0 (F)
000050cc 5378 69f2                subq.w #$01,$69f2 [0050]
000050d0 3078 636e                movea.w $636e [0000],a0
000050d4 6100 039a                bsr.w #$039a == $00005470
000050d8 31c8 636e                move.w a0,$636e [0000]
000050dc 1e10                     move.b (a0) [00],d7
>d
000050de 6606                     bne.b #$06 == $000050e6 (T)
000050e0 31fc 544c 3c7c           move.w #$544c,$3c7c [4c7c]
000050e6 4e75                     rts  == $6000001a
000050e8 43e8 007c                lea.l (a0,$007c) == $00000cf4,a1
000050ec 3410                     move.w (a0) [003c],d2
000050ee e242                     asr.w #$01,d2
000050f0 3802                     move.w d2,d4
000050f2 6a02                     bpl.b #$02 == $000050f6 (T)
000050f4 4444                     neg.w d4
000050f6 4243                     clr.w d3
>d
000050f8 1631 40c0                move.b (a1,d4.W,$c0) == $00003281 [98],d3
000050fc c6e8 0004                mulu.w (a0,$0004) == $00000c7c [0000],d3
00005100 0802 000f                btst.l #$000f,d2
00005104 6702                     beq.b #$02 == $00005108 (F)
00005106 4443                     neg.w d3
00005108 e043                     asr.w #$08,d3
0000510a 3143 0006                move.w d3,(a0,$0006) == $00000c7e [2ffc]
0000510e 3404                     move.w d4,d2
00005110 4442                     neg.w d2
00005112 4244                     clr.w d4


>d
00005114 1831 203f                move.b (a1,d2.W,$3f) == $0000328f [00],d4
00005118 c8e8 0004                mulu.w (a0,$0004) == $00000c7c [0000],d4
0000511c e04c                     lsr.w #$08,d4
0000511e 3144 0008                move.w d4,(a0,$0008) == $00000c80 [0000]
00005122 4e75                     rts  == $6000001a
00005124 4278 6336                clr.w $6336 [0001]
00005128 707f                     moveq #$7f,d0
0000512a 600c                     bra.b #$0c == $00005138 (T)
0000512c 31fc e000 6336           move.w #$e000,$6336 [0001]
00005132 7081                     moveq #$81,d0
>d
00005134 6002                     bra.b #$02 == $00005138 (T)
00005136 4240                     clr.w d0
00005138 31fc 0048 69f6           move.w #$0048,$69f6 [0048]
0000513e 41f8 635c                lea.l $635c,a0
00005142 30c0                     move.w d0,(a0)+ [003c]
00005144 4298                     clr.l (a0)+ [003c004a]
00005146 6100 f534                bsr.w #$f534 == $0000467c
0000514a 30bc 0001                move.w #$0001,(a0) [003c]
0000514e 31fc 5170 3c7c           move.w #$5170,$3c7c [4c7c]
00005154 41f8 6418                lea.l $6418,a0
>d
00005158 6100 0316                bsr.w #$0316 == $00005470
0000515c 7007                     moveq #$07,d0
0000515e 4eb9 0004 8014           jsr $00048014
00005164 4cb8 0003 69f2           movem.w $69f2,d0-d1
0000516a 08b8 0004 6350           bclr.b #$0004,$6350 [00]
00005170 41f8 635c                lea.l $635c,a0
00005174 0839 0004 0000 6350      btst.b #$0004,$00006350 [00]
0000517c 667e                     bne.b #$7e == $000051fc (T)
0000517e 3428 0004                move.w (a0,$0004) == $00000c7c [0000],d2
00005182 5442                     addq.w #$02,d2
>d
00005184 0c42 0028                cmp.w #$0028,d2
00005188 640a                     bcc.b #$0a == $00005194 (T)
0000518a 5242                     addq.w #$01,d2
0000518c 0c42 0014                cmp.w #$0014,d2
00005190 6402                     bcc.b #$02 == $00005194 (T)
00005192 5242                     addq.w #$01,d2
00005194 3142 0004                move.w d2,(a0,$0004) == $00000c7c [0000]
00005198 6100 ff4e                bsr.w #$ff4e == $000050e8
0000519c 5643                     addq.w #$03,d3
0000519e 3e38 6336                move.w $6336 [0001],d7



>d
000051a2 6a02                     bpl.b #$02 == $000051a6 (T)
000051a4 5f43                     subq.w #$07,d3
000051a6 0644 000a                add.w #$000a,d4
000051aa 9244                     sub.w d4,d1
000051ac 6538                     bcs.b #$38 == $000051e6 (F)
000051ae 3a38 69ee                move.w $69ee [00f0],d5
000051b2 da41                     add.w d1,d5
000051b4 0805 0002                btst.l #$0002,d5
000051b8 6632                     bne.b #$32 == $000051ec (T)
000051ba d043                     add.w d3,d0
>d
000051bc 6100 0422                bsr.w #$0422 == $000055e0
000051c0 0c02 0003                cmp.b #$03,d2
000051c4 6520                     bcs.b #$20 == $000051e6 (F)
000051c6 0c02 005f                cmp.b #$5f,d2
000051ca 641a                     bcc.b #$1a == $000051e6 (T)
000051cc 0c02 0051                cmp.b #$51,d2
000051d0 651a                     bcs.b #$1a == $000051ec (F)
000051d2 31fc 4ea2 3c7c           move.w #$4ea2,$3c7c [4c7c]
000051d8 21f8 6362 6370           move.l $6362 [00000034],$6370 [00000000]
000051de 41f8 645e                lea.l $645e,a0
>d
000051e2 6000 028c                bra.w #$028c == $00005470 (T)
000051e6 31fc 51ee 3c7c           move.w #$51ee,$3c7c [4c7c]
000051ec 4e75                     rts  == $6000001a
000051ee 41f8 635c                lea.l $635c,a0
000051f2 0839 0004 0000 6350      btst.b #$0004,$00006350 [00]
000051fa 6706                     beq.b #$06 == $00005202 (F)
000051fc 317c 0002 0004           move.w #$0002,(a0,$0004) == $00000c7c [0000]
00005202 5768 0004                subq.w #$03,(a0,$0004) == $00000c7c [0000]
00005206 6304                     bls.b #$04 == $0000520c (F)
00005208 6000 fede                bra.w #$fede == $000050e8 (T)
>d
0000520c 4268 0004                clr.w (a0,$0004) == $00000c7c [0000]
00005210 31fc 4c7c 3c7c           move.w #$4c7c,$3c7c [4c7c]
00005216 41f8 641b                lea.l $641b,a0
0000521a 6000 0254                bra.w #$0254 == $00005470 (T)
0000521e 4e75                     rts  == $6000001a
00005220 31fc 0028 69f6           move.w #$0028,$69f6 [0048]
00005226 5840                     addq.w #$04,d0
00005228 6100 03b6                bsr.w #$03b6 == $000055e0
0000522c 5940                     subq.w #$04,d0
0000522e 0c02 005f                cmp.b #$5f,d2


>d
00005232 66ea                     bne.b #$ea == $0000521e (T)
00005234 601e                     bra.b #$1e == $00005254 (T)
00005236 6104                     bsr.b #$04 == $0000523c
00005238 6000 022e                bra.w #$022e == $00005468 (T)
0000523c 31fc 0048 69f6           move.w #$0048,$69f6 [0048]
00005242 5840                     addq.w #$04,d0
00005244 5941                     subq.w #$04,d1
00005246 6100 0398                bsr.w #$0398 == $000055e0
0000524a 5841                     addq.w #$04,d1
0000524c 5940                     subq.w #$04,d0
>d
0000524e 0c02 0062                cmp.b #$62,d2
00005252 66ca                     bne.b #$ca == $0000521e (T)
00005254 584f                     addaq.w #$04,a7
00005256 0238 000c 6350           and.b #$0c,$6350 [00]
0000525c 31fc 532e 3c7c           move.w #$532e,$3c7c [4c7c]
00005262 6000 00ca                bra.w #$00ca == $0000532e (T)
00005266 61b8                     bsr.b #$b8 == $00005220
00005268 6002                     bra.b #$02 == $0000526c (T)
0000526a 61d0                     bsr.b #$d0 == $0000523c
0000526c 5840                     addq.w #$04,d0
>d
0000526e 5541                     subq.w #$02,d1
00005270 6100 036e                bsr.w #$036e == $000055e0
00005274 0c02 0003                cmp.b #$03,d2
00005278 653c                     bcs.b #$3c == $000052b6 (F)
0000527a 5278 69f2                addq.w #$01,$69f2 [0050]
0000527e 5e41                     addq.w #$07,d1
00005280 5b40                     subq.w #$05,d0
00005282 6100 035c                bsr.w #$035c == $000055e0
00005286 0402 0051                sub.b #$51,d2
0000528a 0c02 0010                cmp.b #$10,d2
>d
0000528e 6400 0202                bcc.w #$0202 == $00005492 (T)
00005292 41f8 6332                lea.l $6332,a0
00005296 d078 69ec                add.w $69ec [0000],d0
0000529a e248                     lsr.w #$01,d0
0000529c 0240 0007                and.w #$0007,d0
000052a0 5a40                     addq.w #$05,d0
000052a2 30c0                     move.w d0,(a0)+ [003c]
000052a4 0240 0006                and.w #$0006,d0
000052a8 e248                     lsr.w #$01,d0
000052aa 6602                     bne.b #$02 == $000052ae (T)



>d
000052ac 7002                     moveq #$02,d0
000052ae 5240                     addq.w #$01,d0
000052b0 30c0                     move.w d0,(a0)+ [003c]
000052b2 30bc 0001                move.w #$0001,(a0) [003c]
000052b6 4e75                     rts  == $6000001a
000052b8 6100 ff66                bsr.w #$ff66 == $00005220
000052bc 6004                     bra.b #$04 == $000052c2 (T)
000052be 6100 ff7c                bsr.w #$ff7c == $0000523c
000052c2 5b40                     subq.w #$05,d0
000052c4 5541                     subq.w #$02,d1
>d
000052c6 6100 0318                bsr.w #$0318 == $000055e0
000052ca 0c02 0003                cmp.b #$03,d2
000052ce 65e6                     bcs.b #$e6 == $000052b6 (F)
000052d0 5378 69f2                subq.w #$01,$69f2 [0050]
000052d4 5e41                     addq.w #$07,d1
000052d6 5a40                     addq.w #$05,d0
000052d8 6100 0306                bsr.w #$0306 == $000055e0
000052dc 0402 0051                sub.b #$51,d2
000052e0 0c02 0010                cmp.b #$10,d2
000052e4 6400 01ac                bcc.w #$01ac == $00005492 (T)
>d
000052e8 41f8 6332                lea.l $6332,a0
000052ec d078 69ec                add.w $69ec [0000],d0
000052f0 4640                     not.w d0
000052f2 e248                     lsr.w #$01,d0
000052f4 0240 0007                and.w #$0007,d0
000052f8 0640 e005                add.w #$e005,d0
000052fc 30c0                     move.w d0,(a0)+ [003c]
000052fe 0240 e006                and.w #$e006,d0
00005302 e208                     lsr.b #$01,d0
00005304 6604                     bne.b #$04 == $0000530a (T)
>d
00005306 303c e002                move.w #$e002,d0
0000530a 5240                     addq.w #$01,d0
0000530c 30c0                     move.w d0,(a0)+ [003c]
0000530e 30bc e001                move.w #$e001,(a0) [003c]
00005312 4e75                     rts  == $6000001a
00005314 d645                     add.w d5,d3
00005316 1430 3000                move.b (a0,d3.W,$00) == $00000c77 [00],d2
0000531a 0402 0051                sub.b #$51,d2
0000531e 0c02 0010                cmp.b #$10,d2
00005322 646a                     bcc.b #$6a == $0000538e (T)



>d
00005324 31fc 4c7c 3c7c           move.w #$4c7c,$3c7c [4c7c]
0000532a 6000 f950                bra.w #$f950 == $00004c7c (T)
0000532e 0838 0004 6350           btst.b #$0004,$6350 [00]
00005334 6600 015c                bne.w #$015c == $00005492 (T)
00005338 0838 0000 6375           btst.b #$0000,$6375 [00]
0000533e 66d2                     bne.b #$d2 == $00005312 (T)
00005340 4244                     clr.w d4
00005342 1838 6350                move.b $6350 [00],d4
00005346 3438 69ee                move.w $69ee [00f0],d2
0000534a d441                     add.w d1,d2
>d
0000534c 0242 0007                and.w #$0007,d2
00005350 6722                     beq.b #$22 == $00005374 (F)
00005352 0804 0002                btst.l #$0002,d4
00005356 6708                     beq.b #$08 == $00005360 (F)
00005358 5241                     addq.w #$01,d1
0000535a 31fc 0028 69f6           move.w #$0028,$69f6 [0048]
00005360 0804 0003                btst.l #$0003,d4
00005364 6708                     beq.b #$08 == $0000536e (F)
00005366 5341                     subq.w #$01,d1
00005368 31fc 0048 69f6           move.w #$0048,$69f6 [0048]
>d
0000536e 31c1 69f4                move.w d1,$69f4 [0048]
00005372 6054                     bra.b #$54 == $000053c8 (T)
00005374 6100 026a                bsr.w #$026a == $000055e0
00005378 3a04                     move.w d4,d5
0000537a 0205 0003                and.b #$03,d5
0000537e 11c5 6350                move.b d5,$6350 [00]
00005382 7a01                     moveq #$01,d5
00005384 e244                     asr.w #$01,d4
00005386 658c                     bcs.b #$8c == $00005314 (F)
00005388 7aff                     moveq #$ff,d5
>d
0000538a e244                     asr.w #$01,d4
0000538c 6586                     bcs.b #$86 == $00005314 (F)
0000538e e244                     asr.w #$01,d4
00005390 6414                     bcc.b #$14 == $000053a6 (T)
00005392 31fc 0028 69f6           move.w #$0028,$69f6 [0048]
00005398 0c02 005f                cmp.b #$5f,d2
0000539c 6500 0068                bcs.w #$0068 == $00005406 (F)
000053a0 5278 69f4                addq.w #$01,$69f4 [0048]
000053a4 6022                     bra.b #$22 == $000053c8 (T)
000053a6 e244                     asr.w #$01,d4

>d
000053a8 645a                     bcc.b #$5a == $00005404 (T)
000053aa 31fc 0048 69f6           move.w #$0048,$69f6 [0048]
000053b0 3a39 0000 8002           move.w $00008002 [0058],d5
000053b6 9645                     sub.w d5,d3
000053b8 1430 3000                move.b (a0,d3.W,$00) == $00000c77 [00],d2
000053bc 0c02 005f                cmp.b #$5f,d2
000053c0 6544                     bcs.b #$44 == $00005406 (F)
000053c2 5341                     subq.w #$01,d1
000053c4 31c1 69f4                move.w d1,$69f4 [0048]
000053c8 7631                     moveq #$31,d3
>d
000053ca 0838 0003 6350           btst.b #$0003,$6350 [00]
000053d0 660a                     bne.b #$0a == $000053dc (T)
000053d2 5a43                     addq.w #$05,d3
000053d4 0838 0002 6350           btst.b #$0002,$6350 [00]
000053da 6728                     beq.b #$28 == $00005404 (F)
000053dc 3438 69ee                move.w $69ee [00f0],d2
000053e0 d478 69f4                add.w $69f4 [0048],d2
000053e4 5442                     addq.w #$02,d2
000053e6 4642                     not.w d2
000053e8 0242 0007                and.w #$0007,d2
>d
000053ec 0882 0002                bclr.l #$0002,d2
000053f0 6704                     beq.b #$04 == $000053f6 (F)
000053f2 0643 e000                add.w #$e000,d3
000053f6 5242                     addq.w #$01,d2
000053f8 d443                     add.w d3,d2
000053fa 41f8 6332                lea.l $6332,a0
000053fe 4258                     clr.w (a0)+ [003c]
00005400 30c2                     move.w d2,(a0)+ [003c]
00005402 3083                     move.w d3,(a0) [003c]
00005404 4e75                     rts  == $6000001a
>d
00005406 31fc 4c7c 3c7c           move.w #$4c7c,$3c7c [4c7c]
0000540c 4e75                     rts  == $6000001a
0000540e 0641 0008                add.w #$0008,d1
00005412 6100 01cc                bsr.w #$01cc == $000055e0
00005416 4cb8 0003 69f2           movem.w $69f2,d0-d1
0000541c 0c02 0003                cmp.b #$03,d2
00005420 650a                     bcs.b #$0a == $0000542c (F)
00005422 31fc 8000 5546           move.w #$8000,$5546 [4e71]
00005428 6000 0068                bra.w #$0068 == $00005492 (T)
0000542c 6100 fdf2                bsr.w #$fdf2 == $00005220


>d
00005430 41f8 641e                lea.l $641e,a0
00005434 613a                     bsr.b #$3a == $00005470
00005436 31fc 543e 3c7c           move.w #$543e,$3c7c [4c7c]
0000543c 4e75                     rts  == $6000001a
0000543e 41f8 6421                lea.l $6421,a0
00005442 612c                     bsr.b #$2c == $00005470
00005444 0838 0002 6350           btst.b #$0002,$6350 [00]
0000544a 660c                     bne.b #$0c == $00005458 (T)
0000544c 31fc 5462 3c7c           move.w #$5462,$3c7c [4c7c]
00005452 41f8 641e                lea.l $641e,a0
>d
00005456 6018                     bra.b #$18 == $00005470 (T)
00005458 0838 0004 6350           btst.b #$0004,$6350 [00]
0000545e 66ae                     bne.b #$ae == $0000540e (T)
00005460 4e75                     rts  == $6000001a
00005462 31fc 4c7c 3c7c           move.w #$4c7c,$3c7c [4c7c]
00005468 41f8 641b                lea.l $641b,a0
0000546c 6000 0002                bra.w #$0002 == $00005470 (T)
00005470 3f07                     move.w d7,-(a7) [0c64]
00005472 43f8 6336                lea.l $6336,a1
00005476 3e11                     move.w (a1) [661e],d7
>d
00005478 0247 e000                and.w #$e000,d7
0000547c de18                     add.b (a0)+ [00],d7
0000547e 3287                     move.w d7,(a1) [661e]
00005480 de18                     add.b (a0)+ [00],d7
00005482 3307                     move.w d7,-(a1) [0002]
00005484 de18                     add.b (a0)+ [00],d7
00005486 3307                     move.w d7,-(a1) [0002]
00005488 3e1f                     move.w (a7)+ [6000],d7
0000548a 4e75                     rts  == $6000001a


0000548c 0d01                     btst.l d6,d1
0000548e 0111                     btst.b d0,(a1) [66]
00005490 ff02                     illegal


00005492 4cb8 0003 69f2           movem.w $69f2,d0-d1
00005498 42b8 633c                clr.l $633c [00000000]
0000549c 31f8 69f4 69f6           move.w $69f4 [0048],$69f6 [0048]
000054a2 41fa ffe8                lea.l (pc,$ffe8) == $0000548c,a0
000054a6 6100 ffc8                bsr.w #$ffc8 == $00005470
000054aa 31fc 54ba 3c7c           move.w #$54ba,$3c7c [4c7c]
000054b0 31fc ffff 6342           move.w #$ffff,$6342 [0001]
000054b6 4278 6340                clr.w $6340 [0000]

>d
000054ba 4cb8 0030 633c           movem.w $633c,d4-d5
000054c0 31c4 6356                move.w d4,$6356 [0000]
000054c4 673e                     beq.b #$3e == $00005504 (F)
000054c6 0441 0010                sub.w #$0010,d1
000054ca 5940                     subq.w #$04,d0
000054cc d044                     add.w d4,d0
000054ce 6100 0110                bsr.w #$0110 == $000055e0
000054d2 4cb8 0003 69f2           movem.w $69f2,d0-d1
000054d8 7e01                     moveq #$01,d7
000054da 0c02 0003                cmp.b #$03,d2
>d
000054de 6520                     bcs.b #$20 == $00005500 (F)
000054e0 1430 3001                move.b (a0,d3.W,$01) == $00000c78 [00],d2
000054e4 0c02 0003                cmp.b #$03,d2
000054e8 6516                     bcs.b #$16 == $00005500 (F)
000054ea d679 0000 8002           add.w $00008002 [0058],d3
000054f0 1430 3000                move.b (a0,d3.W,$00) == $00000c77 [00],d2
000054f4 51cf ffe4                dbf .w d7,#$ffe4 == $000054da (F)
000054f8 d840                     add.w d0,d4
000054fa 31c4 69f2                move.w d4,$69f2 [0050]
000054fe 6004                     bra.b #$04 == $00005504 (T)
>d
00005500 4278 633c                clr.w $633c [0000]
00005504 0c45 0010                cmp.w #$0010,d5
00005508 6a02                     bpl.b #$02 == $0000550c (T)
0000550a 5245                     addq.w #$01,d5
0000550c 31c5 633e                move.w d5,$633e [0000]
00005510 e445                     asr.w #$02,d5
00005512 d245                     add.w d5,d1
00005514 31c1 69f4                move.w d1,$69f4 [0048]
00005518 0801 000f                btst.l #$000f,d1
0000551c 6702                     beq.b #$02 == $00005520 (F)
>d
0000551e 4e75                     rts  == $6000001a
00005520 6100 00be                bsr.w #$00be == $000055e0
00005524 0c02 0003                cmp.b #$03,d2
00005528 640c                     bcc.b #$0c == $00005536 (T)
0000552a 5f78 69f4                subq.w #$07,$69f4 [0048]
0000552e 4cb8 0003 69f2           movem.w $69f2,d0-d1
00005534 6084                     bra.b #$84 == $000054ba (T)
00005536 0402 0050                sub.b #$50,d2
0000553a 6606                     bne.b #$06 == $00005542 (T)
0000553c 31fc 0070 6340           move.w #$0070,$6340 [0000]

>d
00005542 0c02 0011                cmp.b #$11,d2
00005546 4e71                     nop
00005548 40c6                     move.w sr,d6
0000554a da78 6340                add.w $6340 [0000],d5
0000554e 31c5 6340                move.w d5,$6340 [0000]
00005552 0c45 0008                cmp.w #$0008,d5
00005556 6506                     bcs.b #$06 == $0000555e (F)
00005558 31fc 4e71 5546           move.w #$4e71,$5546 [4e71]
0000555e 46c6                     move.w d6,sr
00005560 64bc                     bcc.b #$bc == $0000551e (T)
>d
00005562 31fc 0028 69f6           move.w #$0028,$69f6 [0048]
00005568 41f8 548f                lea.l $548f,a0
0000556c 6100 ff02                bsr.w #$ff02 == $00005470
00005570 21fc 0000 559a 3c7a      move.l #$0000559a,$3c7a [00004c7c]
00005578 4278 633e                clr.w $633e [0000]
0000557c 31fc 0001 6342           move.w #$0001,$6342 [0001]
00005582 31fc 0002 633a           move.w #$0002,$633a [0000]
00005588 3038 69ee                move.w $69ee [00f0],d0
0000558c d041                     add.w d1,d0
0000558e 0240 0007                and.w #$0007,d0
>d
00005592 9240                     sub.w d0,d1
00005594 31c1 69f4                move.w d1,$69f4 [0048]
00005598 4e75                     rts  == $6000001a
0000559a 5378 633a                subq.w #$01,$633a [0000]
0000559e 66f8                     bne.b #$f8 == $00005598 (T)
000055a0 4a39 0007 c874           tst.b $0007c874 [00]
000055a6 6600 f818                bne.w #$f818 == $00004dc0 (T)
000055aa 21fc 0000 4c7c 3c7a      move.l #$00004c7c,$3c7a [00004c7c]
000055b2 41f8 641b                lea.l $641b,a0
000055b6 0c78 0050 6340           cmp.w #$0050,$6340 [0000]
>d
000055bc 6b00 feb2                bmi.w #$feb2 == $00005470 (F)
000055c0 7c5a                     moveq #$5a,d6
000055c2 6100 f746                bsr.w #$f746 == $00004d0a
000055c6 13fc 0004 0007 c874      move.b #$04,$0007c874 [00]
000055ce 0839 0007 0007 c875      btst.b #$0007,$0007c875 [00]
000055d6 6606                     bne.b #$06 == $000055de (T)
000055d8 4ef9 0007 c862           jmp $0007c862
000055de 4e75                     rts  == $6000001a
000055e0 4cb8 000c 69ec           movem.w $69ec,d2-d3
000055e6 d440                     add.w d0,d2

>d
000055e8 d641                     add.w d1,d3
000055ea e64a                     lsr.w #$03,d2
000055ec e64b                     lsr.w #$03,d3
000055ee c6f9 0000 8002           mulu.w $00008002 [0058],d3
000055f4 d642                     add.w d2,d3
000055f6 41f9 0000 807c           lea.l $0000807c,a0
000055fc 4242                     clr.w d2
000055fe 1430 3000                move.b (a0,d3.W,$00) == $00000c77 [00],d2
00005602 4e75                     rts  == $6000001a
00005604 3438 6360                move.w $6360 [0000],d2
>d
00005608 6700 00dc                beq.w #$00dc == $000056e6 (F)
0000560c 4cb8 0003 69f2           movem.w $69f2,d0-d1
00005612 0441 000c                sub.w #$000c,d1
00005616 5640                     addq.w #$03,d0
00005618 3438 6336                move.w $6336 [0001],d2
0000561c 6a02                     bpl.b #$02 == $00005620 (T)
0000561e 5f40                     subq.w #$07,d0
00005620 d241                     add.w d1,d1
00005622 3e01                     move.w d1,d7
00005624 c2fc 002a                mulu.w #$002a,d1
>d
00005628 e658                     ror.w #$03,d0
0000562a 3400                     move.w d0,d2
0000562c 0242 0fff                and.w #$0fff,d2
00005630 d442                     add.w d2,d2
00005632 d242                     add.w d2,d1
00005634 48c1                     ext.l d1
00005636 d2b8 36ea                add.l $36ea [00061b9c],d1
0000563a 4cb8 000c 6362           movem.w $6362,d2-d3
00005640 d442                     add.w d2,d2
00005642 d643                     add.w d3,d3
>d
00005644 6700 00a0                beq.w #$00a0 == $000056e6 (F)
00005648 0240 e000                and.w #$e000,d0
0000564c 7805                     moveq #$05,d4
0000564e 8840                     or.w d0,d4
00005650 0802 000f                btst.l #$000f,d2
00005654 6706                     beq.b #$06 == $0000565c (F)
00005656 4442                     neg.w d2
00005658 08c4 0003                bset.l #$0003,d4
0000565c d442                     add.w d2,d2
0000565e 3a02                     move.w d2,d5


>d
00005660 9a43                     sub.w d3,d5
00005662 6a04                     bpl.b #$04 == $00005668 (T)
00005664 08c4 0006                bset.l #$0006,d4
00005668 3c05                     move.w d5,d6
0000566a 9c43                     sub.w d3,d6
0000566c 9e43                     sub.w d3,d7
0000566e 5747                     subq.w #$03,d7
00005670 6a02                     bpl.b #$02 == $00005674 (T)
00005672 d647                     add.w d7,d3
00005674 ed43                     asl.w #$06,d3
>d
00005676 5443                     addq.w #$02,d3
00005678 0040 0bca                or.w #$0bca,d0
0000567c 4840                     swap.w d0
0000567e 3004                     move.w d4,d0
00005680 4bf9 00df f000           lea.l $00dff000,a5
00005686 0839 0006 00df f002      btst.b #$0006,$00dff002
0000568e 66f6                     bne.b #$f6 == $00005686 (T)
00005690 3b42 0062                move.w d2,(a5,$0062) == $00bfd162
00005694 3b46 0064                move.w d6,(a5,$0064) == $00bfd164
00005698 3b7c 002a 0066           move.w #$002a,(a5,$0066) == $00bfd166
>d
0000569e 3b7c 002a 0060           move.w #$002a,(a5,$0060) == $00bfd160
000056a4 3b7c c000 0074           move.w #$c000,(a5,$0074) == $00bfd174
000056aa 2b7c ffff ffff 0044      move.l #$ffffffff,(a5,$0044) == $00bfd144
000056b2 3c3c eeee                move.w #$eeee,d6
000056b6 7e03                     moveq #$03,d7
000056b8 0839 0006 00df f002      btst.b #$0006,$00dff002
000056c0 66f6                     bne.b #$f6 == $000056b8 (T)
000056c2 3b45 0052                move.w d5,(a5,$0052) == $00bfd152
000056c6 2b40 0040                move.l d0,(a5,$0040) == $00bfd140
000056ca 2b41 0048                move.l d1,(a5,$0048) == $00bfd148
>d
000056ce 2b41 0054                move.l d1,(a5,$0054) == $00bfd154
000056d2 3b46 0072                move.w d6,(a5,$0072) == $00bfd172
000056d6 3b43 0058                move.w d3,(a5,$0058) == $00bfd158
000056da 0681 0000 1c8c           add.l #$00001c8c,d1
000056e0 4646                     not.w d6
000056e2 51cf ffd4                dbf .w d7,#$ffd4 == $000056b8 (F)
000056e6 4cb8 0003 69f2           movem.w $69f2,d0-d1
000056ec 3438 6336                move.w $6336 [0001],d2
000056f0 4244                     clr.w d4
000056f2 1802                     move.b d2,d4

>d
000056f4 6700 003c                beq.w #$003c == $00005732 (F)
000056f8 3601                     move.w d1,d3
000056fa 41f8 60c4                lea.l $60c4,a0
000056fe d844                     add.w d4,d4
00005700 d643                     add.w d3,d3
00005702 9630 40fe                sub.b (a0,d4.W,$fe) == $00000c77 [00],d3
00005706 e243                     asr.w #$01,d3
00005708 31c3 6338                move.w d3,$6338 [0000]
0000570c 6126                     bsr.b #$26 == $00005734
0000570e 4cb8 0003 69f2           movem.w $69f2,d0-d1
>d
00005714 3438 6334                move.w $6334 [0002],d2
00005718 1402                     move.b d2,d2
0000571a 6700 0016                beq.w #$0016 == $00005732 (F)
0000571e 6114                     bsr.b #$14 == $00005734
00005720 4cb8 0003 69f2           movem.w $69f2,d0-d1
00005726 3438 6332                move.w $6332 [0005],d2
0000572a 1402                     move.b d2,d2
0000572c 6700 0004                beq.w #$0004 == $00005732 (F)
00005730 6102                     bsr.b #$02 == $00005734
00005732 4e75                     rts  == $6000001a
>d
00005734 2278 6346                movea.l $6346 [00010000],a1
00005738 d241                     add.w d1,d1
0000573a e742                     asl.w #$03,d2
0000573c 43f1 20f8                lea.l (a1,d2.W,$f8) == $00003248,a1
00005740 6422                     bcc.b #$22 == $00005764 (T)
00005742 1819                     move.b (a1)+ [66],d4
00005744 4884                     ext.w d4
00005746 9244                     sub.w d4,d1
00005748 1819                     move.b (a1)+ [66],d4
0000574a 4884                     ext.w d4
>d
0000574c d044                     add.w d4,d0
0000574e 4242                     clr.w d2
00005750 1419                     move.b (a1)+ [66],d2
00005752 3802                     move.w d2,d4
00005754 e74c                     lsl.w #$03,d4
00005756 9044                     sub.w d4,d0
00005758 4243                     clr.w d3
0000575a 1619                     move.b (a1)+ [66],d3
0000575c 2059                     movea.l (a1)+ [661e0800],a0
0000575e d1f8 634a                adda.l $634a [00000000],a0

>d
00005762 6016                     bra.b #$16 == $0000577a (T)
00005764 1819                     move.b (a1)+ [66],d4
00005766 4884                     ext.w d4
00005768 9244                     sub.w d4,d1
0000576a 1819                     move.b (a1)+ [66],d4
0000576c 4884                     ext.w d4
0000576e 9044                     sub.w d4,d0
00005770 4242                     clr.w d2
00005772 1419                     move.b (a1)+ [66],d2
00005774 4243                     clr.w d3
>d
00005776 1619                     move.b (a1)+ [66],d3
00005778 2059                     movea.l (a1)+ [661e0800],a0
0000577a 3803                     move.w d3,d4
0000577c c8c2                     mulu.w d2,d4
0000577e d884                     add.l d4,d4
00005780 2244                     movea.l d4,a1
00005782 3201                     move.w d1,d1
00005784 6a12                     bpl.b #$12 == $00005798 (T)
00005786 4441                     neg.w d1
00005788 9641                     sub.w d1,d3
>d
0000578a 6300 0106                bls.w #$0106 == $00005892 (F)
0000578e c2c2                     mulu.w d2,d1
00005790 d1c1                     adda.l d1,a0
00005792 d1c1                     adda.l d1,a0
00005794 7200                     moveq #$00,d1
00005796 6010                     bra.b #$10 == $000057a8 (T)
00005798 3c3c 00ad                move.w #$00ad,d6
0000579c 9c41                     sub.w d1,d6
0000579e 6300 00f2                bls.w #$00f2 == $00005892 (F)
000057a2 bc43                     cmp.w d3,d6
>d
000057a4 6a02                     bpl.b #$02 == $000057a8 (T)
000057a6 3606                     move.w d6,d3
000057a8 7eff                     moveq #$ff,d7
000057aa 3a02                     move.w d2,d5
000057ac 7c07                     moveq #$07,d6
000057ae cc40                     and.w d0,d6
000057b0 6622                     bne.b #$22 == $000057d4 (T)
000057b2 e640                     asr.w #$03,d0
000057b4 6a0e                     bpl.b #$0e == $000057c4 (T)
000057b6 4440                     neg.w d0


>d
000057b8 9a40                     sub.w d0,d5
000057ba 6300 00d6                bls.w #$00d6 == $00005892 (F)
000057be d0c0                     adda.w d0,a0
000057c0 d0c0                     adda.w d0,a0
000057c2 7000                     moveq #$00,d0
000057c4 7814                     moveq #$14,d4
000057c6 9840                     sub.w d0,d4
000057c8 6f00 00c8                ble.w #$00c8 == $00005892 (F)
000057cc ba44                     cmp.w d4,d5
000057ce 633e                     bls.b #$3e == $0000580e (F)
>d
000057d0 3a04                     move.w d4,d5
000057d2 603a                     bra.b #$3a == $0000580e (T)
000057d4 4247                     clr.w d7
000057d6 5245                     addq.w #$01,d5
000057d8 e640                     asr.w #$03,d0
000057da 6a1c                     bpl.b #$1c == $000057f8 (T)
000057dc 4440                     neg.w d0
000057de 5340                     subq.w #$01,d0
000057e0 9a40                     sub.w d0,d5
000057e2 6300 00ae                bls.w #$00ae == $00005892 (F)
>d
000057e6 d0c0                     adda.w d0,a0
000057e8 d0c0                     adda.w d0,a0
000057ea 70ff                     moveq #$ff,d0
000057ec 7808                     moveq #$08,d4
000057ee 9846                     sub.w d6,d4
000057f0 d844                     add.w d4,d4
000057f2 e868                     lsr.w d4,d0
000057f4 4840                     swap.w d0
000057f6 ce80                     and.l d0,d7
000057f8 7814                     moveq #$14,d4
>d
000057fa 9840                     sub.w d0,d4
000057fc 6f00 0094                ble.w #$0094 == $00005892 (F)
00005800 ba44                     cmp.w d4,d5
00005802 630a                     bls.b #$0a == $0000580e (F)
00005804 3a04                     move.w d4,d5
00005806 78ff                     moveq #$ff,d4
00005808 ed6c                     lsl.w d6,d4
0000580a ed6c                     lsl.w d6,d4
0000580c 3e04                     move.w d4,d7
0000580e ed43                     asl.w #$06,d3

>d
00005810 d645                     add.w d5,d3
00005812 9445                     sub.w d5,d2
00005814 d442                     add.w d2,d2
00005816 7815                     moveq #$15,d4
00005818 9845                     sub.w d5,d4
0000581a d844                     add.w d4,d4
0000581c 2479 0000 36ea           movea.l $000036ea [00061b9c],a2
00005822 d040                     add.w d0,d0
00005824 d4c0                     adda.w d0,a2
00005826 c2fc 002a                mulu.w #$002a,d1
>d
0000582a d5c1                     adda.l d1,a2
0000582c 48c6                     ext.l d6
0000582e e69e                     ror.l #$03,d6
00005830 2006                     move.l d6,d0
00005832 4840                     swap.w d0
00005834 8c80                     or.l d0,d6
00005836 2a7c 00df f000           movea.l #$00dff000,a5
0000583c 0086 0fca 0000           or.l #$0fca0000,d6
00005842 0839 0006 00df f002      btst.b #$0006,$00dff002
0000584a 66f6                     bne.b #$f6 == $00005842 (T)
>d
0000584c 3b42 0064                move.w d2,(a5,$0064) == $00bfd164
00005850 3b42 0062                move.w d2,(a5,$0062) == $00bfd162
00005854 2b47 0044                move.l d7,(a5,$0044) == $00bfd144
00005858 3b44 0060                move.w d4,(a5,$0060) == $00bfd160
0000585c 3b44 0066                move.w d4,(a5,$0066) == $00bfd166
00005860 2b46 0040                move.l d6,(a5,$0040) == $00bfd140
00005864 47d0                     lea.l (a0),a3
00005866 7e03                     moveq #$03,d7
00005868 0839 0006 00df f002      btst.b #$0006,$00dff002
00005870 66f6                     bne.b #$f6 == $00005868 (T)
>d
00005872 41f0 9800                lea.l (a0,a1.L,$00) == $00003f38,a0
00005876 2b4b 0050                move.l a3,(a5,$0050) == $00bfd150
0000587a 2b48 004c                move.l a0,(a5,$004c) == $00bfd14c
0000587e 2b4a 0048                move.l a2,(a5,$0048) == $00bfd148
00005882 2b4a 0054                move.l a2,(a5,$0054) == $00bfd154
00005886 3b43 0058                move.w d3,(a5,$0058) == $00bfd158
0000588a 45ea 1c8c                lea.l (a2,$1c8c) == $00063948,a2
0000588e 51cf ffd8                dbf .w d7,#$ffd8 == $00005868 (F)
00005892 4e75                     rts  == $6000001a
00005894 3039 00df f00c           move.w $00dff00c,d0

>d
0000589a 4202                     clr.b d2
0000589c 0800 0001                btst.l #$0001,d0
000058a0 6704                     beq.b #$04 == $000058a6 (F)
000058a2 08c2 0000                bset.l #$0000,d2
000058a6 0800 0009                btst.l #$0009,d0
000058aa 6704                     beq.b #$04 == $000058b0 (F)
000058ac 08c2 0001                bset.l #$0001,d2
000058b0 3200                     move.w d0,d1
000058b2 e249                     lsr.w #$01,d1
000058b4 b141                     eor.w d0,d1
>d
000058b6 0801 0000                btst.l #$0000,d1
000058ba 6704                     beq.b #$04 == $000058c0 (F)
000058bc 08c2 0002                bset.l #$0002,d2
000058c0 0801 0008                btst.l #$0008,d1
000058c4 6704                     beq.b #$04 == $000058ca (F)
000058c6 08c2 0003                bset.l #$0003,d2
000058ca 0839 0007 00bf e001      btst.b #$0007,$00bfe001
000058d2 57c0                     seq.b d0 (F)
000058d4 1238 6351                move.b $6351 [00],d1
000058d8 6606                     bne.b #$06 == $000058e0 (T)
>d
000058da 0240 0010                and.w #$0010,d0
000058de 8440                     or.w d0,d2
000058e0 11c0 6351                move.b d0,$6351 [00]
000058e4 11c2 6350                move.b d2,$6350 [00]
000058e8 4e75                     rts  == $6000001a
000058ea 4280                     clr.l d0
000058ec 3038 69ec                move.w $69ec [0000],d0
000058f0 e648                     lsr.w #$03,d0
000058f2 d040                     add.w d0,d0
000058f4 287c 0005 a36c           movea.l #$0005a36c,a4
>d
000058fa d9c0                     adda.l d0,a4
000058fc 21cc 6366                move.l a4,$6366 [0005a36c]
00005900 4278 635a                clr.w $635a [0000]
00005904 4281                     clr.l d1
00005906 3238 69ec                move.w $69ec [0000],d1
0000590a 7e14                     moveq #$14,d7
0000590c 48e7 4108                movem.l d1/d7/a4,-(a7)
00005910 6100 f202                bsr.w #$f202 == $00004b14
00005914 4cdf 1082                movem.l (a7)+,d1/d7/a4
00005918 5041                     addq.w #$08,d1

>d
0000591a 548c                     addaq.l #$02,a4
0000591c 51cf ffee                dbf .w d7,#$ffee == $0000590c (F)
00005920 4e75                     rts  == $6000001a
00005922 3e3c 013f                move.w #$013f,d7
00005926 41f8 6ad0                lea.l $6ad0,a0
0000592a 1028 0004                move.b (a0,$0004) == $00000c7c [00],d0
0000592e c028 0001                and.b (a0,$0001) == $00000c79 [3c],d0
00005932 4600                     not.b d0
00005934 c028 0002                and.b (a0,$0002) == $00000c7a [00],d0
00005938 c028 0003                and.b (a0,$0003) == $00000c7b [4a],d0
>d
0000593c b128 0001                eor.b d0,(a0,$0001) == $00000c79 [3c]
00005940 5a48                     addaq.w #$05,a0
00005942 51cf ffe6                dbf .w d7,#$ffe6 == $0000592a (F)
00005946 41f9 0000 8002           lea.l $00008002,a0
0000594c 3a18                     move.w (a0)+ [003c],d5
0000594e 3c18                     move.w (a0)+ [003c],d6
00005950 41e8 0076                lea.l (a0,$0076) == $00000cee,a0
00005954 1028 0028                move.b (a0,$0028) == $00000ca0 [00],d0
00005958 0c00 0003                cmp.b #$03,d0
0000595c 6424                     bcc.b #$24 == $00005982 (T)
>d
0000595e 3006                     move.w d6,d0
00005960 5340                     subq.w #$01,d0
00005962 c0c5                     mulu.w d5,d0
00005964 43f0 0800                lea.l (a0,d0.L,$00) == $ffffec08,a1
00005968 e24e                     lsr.w #$01,d6
0000596a 5346                     subq.w #$01,d6
0000596c 3805                     move.w d5,d4
0000596e 5344                     subq.w #$01,d4
00005970 1010                     move.b (a0) [00],d0
00005972 10d1                     move.b (a1) [66],(a0)+ [00]
>d
00005974 12c0                     move.b d0,(a1)+ [66]
00005976 51cc fff8                dbf .w d4,#$fff8 == $00005970 (F)
0000597a 92c5                     suba.w d5,a1
0000597c 92c5                     suba.w d5,a1
0000597e 51ce ffec                dbf .w d6,#$ffec == $0000596c (F)
00005982 2278 6346                movea.l $6346 [00010000],a1
00005986 207c 0001 1002           movea.l #$00011002,a0
0000598c 45f9 0000 60c4           lea.l $000060c4,a2
00005992 3e18                     move.w (a0)+ [003c],d7
00005994 4280                     clr.l d0

>d
00005996 3007                     move.w d7,d0
00005998 5347                     subq.w #$01,d7
0000599a 3c07                     move.w d7,d6
0000599c e740                     asl.w #$03,d0
0000599e d088                     add.l a0,d0
000059a0 2a40                     movea.l d0,a5
000059a2 41e8 0002                lea.l (a0,$0002) == $00000c7a,a0
000059a6 32da                     move.w (a2)+ [6476],(a1)+ [661e]
000059a8 1018                     move.b (a0)+ [00],d0
000059aa e808                     lsr.b #$04,d0
>d
000059ac 5240                     addq.w #$01,d0
000059ae 12c0                     move.b d0,(a1)+ [66]
000059b0 1018                     move.b (a0)+ [00],d0
000059b2 5240                     addq.w #$01,d0
000059b4 12c0                     move.b d0,(a1)+ [66]
000059b6 2018                     move.l (a0)+ [003c004a],d0
000059b8 d08d                     add.l a5,d0
000059ba 22c0                     move.l d0,(a1)+ [661e0800]
000059bc 51cf ffe4                dbf .w d7,#$ffe4 == $000059a2 (F)
000059c0 3e06                     move.w d6,d7
>d
000059c2 2478 6346                movea.l $6346 [00010000],a2
000059c6 4282                     clr.l d2
000059c8 544a                     addaq.w #$02,a2
000059ca 4240                     clr.w d0
000059cc 101a                     move.b (a2)+ [64],d0
000059ce 4241                     clr.w d1
000059d0 121a                     move.b (a2)+ [64],d1
000059d2 c0c1                     mulu.w d1,d0
000059d4 d440                     add.w d0,d2
000059d6 5c4a                     addaq.w #$06,a2
>d
000059d8 51cf fff0                dbf .w d7,#$fff0 == $000059ca (F)
000059dc c4fc 000a                mulu.w #$000a,d2
000059e0 21c2 634a                move.l d2,$634a [00000000]
000059e4 2278 6346                movea.l $6346 [00010000],a1
000059e8 2269 0004                movea.l (a1,$0004) == $000032c4 [0001660c],a1
000059ec 5249                     addaq.w #$01,a1
000059ee 0811 0000                btst.b #$0000,(a1) [66]
000059f2 6600 0004                bne.w #$0004 == $000059f8 (T)
000059f6 4e75                     rts  == $6000001a
000059f8 3e06                     move.w d6,d7

>d
000059fa 2278 6346                movea.l $6346 [00010000],a1
000059fe 5449                     addaq.w #$02,a1
00005a00 2a48                     movea.l a0,a5
00005a02 2648                     movea.l a0,a3
00005a04 4285                     clr.l d5
00005a06 4280                     clr.l d0
00005a08 1019                     move.b (a1)+ [66],d0
00005a0a 1a11                     move.b (a1) [66],d5
00005a0c cac0                     mulu.w d0,d5
00005a0e 2805                     move.l d5,d4
>d
00005a10 d844                     add.w d4,d4
00005a12 2604                     move.l d4,d3
00005a14 d644                     add.w d4,d3
00005a16 2403                     move.l d3,d2
00005a18 d444                     add.w d4,d2
00005a1a 2202                     move.l d2,d1
00005a1c d244                     add.w d4,d1
00005a1e 5345                     subq.w #$01,d5
00005a20 247c 0006 1b9c           movea.l #$00061b9c,a2
00005a26 3498                     move.w (a0)+ [003c],(a2) [6476]
>d
00005a28 4652                     not.w (a2) [6476]
00005a2a 3598 4000                move.w (a0)+ [003c],(a2,d4.W,$00) == $00061cbd [7680]
00005a2e 3598 3000                move.w (a0)+ [003c],(a2,d3.W,$00) == $00061cbb [fe64]
00005a32 3598 2000                move.w (a0)+ [003c],(a2,d2.W,$00) == $00061c4c [6799]
00005a36 3598 1000                move.w (a0)+ [003c],(a2,d1.W,$00) == $00061cbb [fe64]
00005a3a 544a                     addaq.w #$02,a2
00005a3c 51cd ffe8                dbf .w d5,#$ffe8 == $00005a26 (F)
00005a40 383c 0004                move.w #$0004,d4
00005a44 4245                     clr.w d5
00005a46 1a11                     move.b (a1) [66],d5
>d
00005a48 5345                     subq.w #$01,d5
00005a4a 3400                     move.w d0,d2
00005a4c 5342                     subq.w #$01,d2
00005a4e 95c0                     suba.l d0,a2
00005a50 95c0                     suba.l d0,a2
00005a52 36da                     move.w (a2)+ [6476],(a3)+ [0000]
00005a54 51ca fffc                dbf .w d2,#$fffc == $00005a52 (F)
00005a58 95c0                     suba.l d0,a2
00005a5a 95c0                     suba.l d0,a2
00005a5c 51cd ffec                dbf .w d5,#$ffec == $00005a4a (F)

>d
00005a60 d5c3                     adda.l d3,a2
00005a62 51cc ffe0                dbf .w d4,#$ffe0 == $00005a44 (F)
00005a66 43e9 0007                lea.l (a1,$0007) == $000032c7,a1
00005a6a 51cf ff98                dbf .w d7,#$ff98 == $00005a04 (F)
00005a6e 284b                     movea.l a3,a4
00005a70 2278 6346                movea.l $6346 [00010000],a1
00005a74 3e06                     move.w d6,d7
00005a76 7c04                     moveq #$04,d6
00005a78 2069 0004                movea.l (a1,$0004) == $000032c4 [0001660c],a0
00005a7c 4285                     clr.l d5
>d
00005a7e 4284                     clr.l d4
00005a80 1829 0002                move.b (a1,$0002) == $000032c2 [08],d4
00005a84 1a29 0003                move.b (a1,$0003) == $000032c3 [00],d5
00005a88 5345                     subq.w #$01,d5
00005a8a 3604                     move.w d4,d3
00005a8c d643                     add.w d3,d3
00005a8e 5343                     subq.w #$01,d3
00005a90 1030 3000                move.b (a0,d3.W,$00) == $00000c77 [00],d0
00005a94 7407                     moveq #$07,d2
00005a96 e210                     roxr.b #$01,d0
>d
00005a98 e311                     roxl.b #$01,d1
00005a9a 51ca fffa                dbf .w d2,#$fffa == $00005a96 (F)
00005a9e 16c1                     move.b d1,(a3)+ [00]
00005aa0 51cb ffee                dbf .w d3,#$ffee == $00005a90 (F)
00005aa4 d1c4                     adda.l d4,a0
00005aa6 d1c4                     adda.l d4,a0
00005aa8 51cd ffe0                dbf .w d5,#$ffe0 == $00005a8a (F)
00005aac 51ce ffce                dbf .w d6,#$ffce == $00005a7c (F)
00005ab0 43e9 0008                lea.l (a1,$0008) == $000032c8,a1
00005ab4 51cf ffc0                dbf .w d7,#$ffc0 == $00005a76 (F)
>d
00005ab8 4e75                     rts  == $6000001a


actor_init_data
00005ABA 0004 00E8 0012 00C5 0015 0097 0017 0064  ;...............d
00005ACA 0018 0085 001B 00BC 001F 00C1 0020 0103  ;............. ..
00005ADA 0021 00FF 00FF 0000 52B6 460C 40F8 404C  ;.!......R.F.@.@L
00005AEA 40A6 3FFA 40DE 4032 52B6 52B6 52B6 52B6  ;@.?.@.@2R.R.R.R.
00005AFA 43E2 438C 41AE 4278 446E 4482 44BC 0000  ;C.C.A.BxDnD.D...
00005B0A 5CB6 5C32 5C4A 4278 5BA4 5B4E 5F00 5F14  ;\.\2\JBx[.[N_._.
00005B1A 5F8A 6014 6068 5D4C 5D84 5DF8 5B2C 5B36  ;_.`.`h]L].].[,[6
00005B2A 5B40 


00005b2c 7001                     moveq #$01,d0
00005b2e b078 6344                cmp.w $6344 [0000],d0
00005b32 6516                     bcs.b #$16 == $00005b4a (F)
00005b34 6010                     bra.b #$10 == $00005b46 (T)

00005b36 7002                     moveq #$02,d0
00005b38 b078 6344                cmp.w $6344 [0000],d0
00005b3c 650c                     bcs.b #$0c == $00005b4a (F)
00005b3e 6006                     bra.b #$06 == $00005b46 (T)

00005b40 7003                     moveq #$03,d0
00005b42 b078 6344                cmp.w $6344 [0000],d0
00005b46 31c0 6344                move.w d0,$6344 [0000]
00005b4a 4256                     clr.w (a6)
00005b4c 4e75                     rts  == $6000001a


00005b4e 303c 0590                move.w #$0590,d0
00005b52 9078 69ec                sub.w $69ec [0000],d0
00005b56 546e 000a                addq.w #$02,(a6,$000a) == $00dff00a
00005b5a 2a6e 0008                movea.l (a6,$0008) == $00dff008,a5
00005b5e 3415                     move.w (a5),d2
00005b60 6a00 ea98                bpl.w #$ea98 == $000045fa (T)
00005b64 6100 db88                bsr.w #$db88 == $000036ee
00005b68 7032                     moveq #$32,d0
00005b6a 6100 0368                bsr.w #$0368 == $00005ed4
00005b6e 6000 0312                bra.w #$0312 == $00005e82 (T)

00005B72 0001 0001 0001 0001 0002 0002 0002 0002  ................
00005B82 0003 0003 0003 0003 0004 0004 0004 0004  ................
00005B92 0002 0002 0002 0002 0001 0001 0001 0001  ................
00005BA2 FFFF

; line 7117 - Code1.s

>d 5ba4
00005ba4 3d7c 0098 0004           move.w #$0098,(a6,$0004) == $00dff004
00005baa 4bf8 39bc                lea.l $39bc,a5
00005bae 343c 0085                move.w #$0085,d2
00005bb2 7e09                     moveq #$09,d7
00005bb4 b46d 0006                cmp.w (a5,$0006) == $00bfd106,d2
00005bb8 670a                     beq.b #$0a == $00005bc4 (F)
00005bba 4bed 0016                lea.l (a5,$0016) == $00bfd116,a5
00005bbe 51cf fff4                dbf .w d7,#$fff4 == $00005bb4 (F)
00005bc2 6004                     bra.b #$04 == $00005bc8 (T)
00005bc4 3415                     move.w (a5),d2

>d
00005bc6 660c                     bne.b #$0c == $00005bd4 (T)
00005bc8 08b9 0007 0000 6476      bclr.b #$0007,$00006476 [00]
00005bd0 4256                     clr.w (a6)
00005bd2 4e75                     rts  == $6000001a
00005bd4 5342                     subq.w #$01,d2
00005bd6 66fa                     bne.b #$fa == $00005bd2 (T)
00005bd8 4eb9 0004 8008           jsr $00048008
00005bde 08f9 0000 0007 c874      bset.b #$0000,$0007c874 [00]
00005be6 31fc 52b6 3c7c           move.w #$52b6,$3c7c [4c7c]
00005bec 4278 6342                clr.w $6342 [0001]
>d
00005bf0 4278 6360                clr.w $6360 [0000]
00005bf4 302d 0004                move.w (a5,$0004) == $00bfd104,d0
00005bf8 0c40 00d4                cmp.w #$00d4,d0
00005bfc 651c                     bcs.b #$1c == $00005c1a (F)
00005bfe 3b7c 0081 0006           move.w #$0081,(a5,$0006) == $00bfd106
00005c04 2b7c 0000 5b70 0008      move.l #$00005b70,(a5,$0008) == $00bfd108
00005c0c 3abc 0019                move.w #$0019,(a5)
00005c10 4256                     clr.w (a6)
00005c12 700b                     moveq #$0b,d0
00005c14 4ef9 0004 8014           jmp $00048014
>d
00005c1a 5378 69f8                subq.w #$01,$69f8 [0050]
00005c1e 0440 0018                sub.w #$0018,d0
00005c22 9078 69ee                sub.w $69ee [00f0],d0
00005c26 4440                     neg.w d0
00005c28 d078 69f4                add.w $69f4 [0048],d0
00005c2c 31c0 69f6                move.w d0,$69f6 [0048]
00005c30 4e75                     rts  == $6000001a
00005c32 6134                     bsr.b #$34 == $00005c68
00005c34 0c42 0008                cmp.w #$0008,d2
00005c38 64f6                     bcc.b #$f6 == $00005c30 (T)
>d
00005c3a 0c42 0004                cmp.w #$0004,d2
00005c3e 6600 e9ba                bne.w #$e9ba == $000045fa (T)
00005c42 6152                     bsr.b #$52 == $00005c96
00005c44 7404                     moveq #$04,d2
00005c46 6000 e9b2                bra.w #$e9b2 == $000045fa (T)
00005c4a 611c                     bsr.b #$1c == $00005c68
00005c4c 0042 e000                or.w #$e000,d2
00005c50 0c42 e008                cmp.w #$e008,d2
00005c54 64da                     bcc.b #$da == $00005c30 (T)
00005c56 0c42 e004                cmp.w #$e004,d2

>d
00005c5a 6600 e99e                bne.w #$e99e == $000045fa (T)
00005c5e 612a                     bsr.b #$2a == $00005c8a
00005c60 343c e004                move.w #$e004,d2
00005c64 6000 e994                bra.w #$e994 == $000045fa (T)
00005c68 4242                     clr.w d2
00005c6a 342e 0008                move.w (a6,$0008) == $00dff008,d2
00005c6e 5802                     addq.b #$04,d2
00005c70 6408                     bcc.b #$08 == $00005c7a (T)
00005c72 7406                     moveq #$06,d2
00005c74 6100 e87e                bsr.w #$e87e == $000044f4
>d
00005c78 4242                     clr.w d2
00005c7a 3d42 0008                move.w d2,(a6,$0008) == $00dff008
00005c7e 0c42 0037                cmp.w #$0037,d2
00005c82 6404                     bcc.b #$04 == $00005c88 (T)
00005c84 e64a                     lsr.w #$03,d2
00005c86 5242                     addq.w #$01,d2
00005c88 4e75                     rts  == $6000001a
00005c8a 4cb8 0018 69f2           movem.w $69f2,d3-d4
00005c90 0643 0010                add.w #$0010,d3
00005c94 6008                     bra.b #$08 == $00005c9e (T)
>d
00005c96 4cb8 0018 69f2           movem.w $69f2,d3-d4
00005c9c 5843                     addq.w #$04,d3
00005c9e 9640                     sub.w d0,d3
00005ca0 0c43 0016                cmp.w #$0016,d3
00005ca4 64e2                     bcc.b #$e2 == $00005c88 (T)
00005ca6 b841                     cmp.w d1,d4
00005ca8 6bde                     bmi.b #$de == $00005c88 (F)
00005caa b278 6338                cmp.w $6338 [0000],d1
00005cae 6bd8                     bmi.b #$d8 == $00005c88 (F)
00005cb0 7c03                     moveq #$03,d6
>d
00005cb2 6000 f056                bra.w #$f056 == $00004d0a (T)
00005cb6 362e 000c                move.w (a6,$000c) == $00dff00c,d3
00005cba 5c03                     addq.b #$06,d3
00005cbc 3d43 000c                move.w d3,(a6,$000c) == $00dff00c
00005cc0 0c03 0020                cmp.b #$20,d3
00005cc4 65c2                     bcs.b #$c2 == $00005c88 (F)
00005cc6 7401                     moveq #$01,d2
00005cc8 0c03 0040                cmp.b #$40,d3
00005ccc 6500 e92c                bcs.w #$e92c == $000045fa (F)
00005cd0 3a2e 000a                move.w (a6,$000a) == $00dff00a,d5






>d
00005cd4 0c45 0010                cmp.w #$0010,d5
00005cd8 6400 0004                bcc.w #$0004 == $00005cde (T)
00005cdc 5245                     addq.w #$01,d5
00005cde 3d45 000a                move.w d5,(a6,$000a) == $00dff00a
00005ce2 e24d                     lsr.w #$01,d5
00005ce4 da6e 0008                add.w (a6,$0008) == $00dff008,d5
00005ce8 3d45 0008                move.w d5,(a6,$0008) == $00dff008
00005cec d245                     add.w d5,d1
00005cee 6100 f8f0                bsr.w #$f8f0 == $000055e0
00005cf2 0c02 0051                cmp.b #$51,d2
>d
00005cf6 6528                     bcs.b #$28 == $00005d20 (F)
00005cf8 3638 69ee                move.w $69ee [00f0],d3
00005cfc d641                     add.w d1,d3
00005cfe 0243 0007                and.w #$0007,d3
00005d02 4643                     not.w d3
00005d04 d243                     add.w d3,d1
00005d06 7404                     moveq #$04,d2
00005d08 b56e 0002                eor.w d2,(a6,$0002) == $00dff002
00005d0c 42ae 0008                clr.l (a6,$0008) == $00dff008
00005d10 426e 000c                clr.w (a6,$000c) == $00dff00c
>d
00005d14 7405                     moveq #$05,d2
00005d16 6100 e7dc                bsr.w #$e7dc == $000044f4
00005d1a 7402                     moveq #$02,d2
00005d1c 6000 e8dc                bra.w #$e8dc == $000045fa (T)
00005d20 7401                     moveq #$01,d2
00005d22 3638 69f2                move.w $69f2 [0050],d3
00005d26 9640                     sub.w d0,d3
00005d28 5643                     addq.w #$03,d3
00005d2a 0c43 0007                cmp.w #$0007,d3
00005d2e 6400 e8ca                bcc.w #$e8ca == $000045fa (T)
>d
00005d32 b278 6338                cmp.w $6338 [0000],d1
00005d36 6b00 e8c2                bmi.w #$e8c2 == $000045fa (F)
00005d3a b278 69f4                cmp.w $69f4 [0048],d1
00005d3e 6a00 e8ba                bpl.w #$e8ba == $000045fa (T)
00005d42 7c02                     moveq #$02,d6
00005d44 6100 efc4                bsr.w #$efc4 == $00004d0a
00005d48 60bc                     bra.b #$bc == $00005d06 (T)
00005d4a 4e75                     rts  == $6000001a
00005d4c 342e 0004                move.w (a6,$0004) == $00dff004,d2
00005d50 4642                     not.w d2


>d
00005d52 0242 0007                and.w #$0007,d2
00005d56 0882 0002                bclr.l #$0002,d2
00005d5a 6604                     bne.b #$04 == $00005d60 (T)
00005d5c 0642 e000                add.w #$e000,d2
00005d60 3f02                     move.w d2,-(a7) [0c64]
00005d62 5442                     addq.w #$02,d2
00005d64 6100 e894                bsr.w #$e894 == $000045fa
00005d68 341f                     move.w (a7)+ [6000],d2
00005d6a 0242 e000                and.w #$e000,d2
00005d6e 5242                     addq.w #$01,d2
>d
00005d70 6100 e856                bsr.w #$e856 == $000045c8
00005d74 0838 0000 6375           btst.b #$0000,$6375 [00]
00005d7a 67ce                     beq.b #$ce == $00005d4a (F)
00005d7c 536e 0004                subq.w #$01,(a6,$0004) == $00dff004
00005d80 6b48                     bmi.b #$48 == $00005dca (F)
00005d82 4e75                     rts  == $6000001a
00005d84 0838 0000 6375           btst.b #$0000,$6375 [00]
00005d8a 6710                     beq.b #$10 == $00005d9c (F)
00005d8c 48e7 c002                movem.l d0-d1/a6,-(a7)
00005d90 700b                     moveq #$0b,d0
>d
00005d92 4eb9 0004 8014           jsr $00048014
00005d98 4cdf 4003                movem.l (a7)+,d0-d1/a6
00005d9c 3438 6374                move.w $6374 [0000],d2
00005da0 e44a                     lsr.w #$02,d2
00005da2 0242 0003                and.w #$0003,d2
00005da6 5242                     addq.w #$01,d2
00005da8 6100 e850                bsr.w #$e850 == $000045fa
00005dac 0441 0010                sub.w #$0010,d1
00005db0 6aea                     bpl.b #$ea == $00005d9c (T)
00005db2 4bf8 39bc                lea.l $39bc,a5
>d
00005db6 343c 0103                move.w #$0103,d2
00005dba 7e09                     moveq #$09,d7
00005dbc b46d 0006                cmp.w (a5,$0006) == $00bfd106,d2
00005dc0 670e                     beq.b #$0e == $00005dd0 (F)
00005dc2 4bed 0016                lea.l (a5,$0016) == $00bfd116,a5
00005dc6 51cf fff4                dbf .w d7,#$fff4 == $00005dbc (F)
00005dca 7c5a                     moveq #$5a,d6
00005dcc 6000 ef3c                bra.w #$ef3c == $00004d0a (T)
00005dd0 3415                     move.w (a5),d2
00005dd2 67f6                     beq.b #$f6 == $00005dca (F)

>d
00005dd4 5342                     subq.w #$01,d2
00005dd6 6600 ff72                bne.w #$ff72 == $00005d4a (T)
00005dda 31fc 52b6 3c7c           move.w #$52b6,$3c7c [4c7c]
00005de0 3abc 0021                move.w #$0021,(a5)
00005de4 4278 6360                clr.w $6360 [0000]
00005de8 31fc ffff 6342           move.w #$ffff,$6342 [0001]
00005dee 13fc 0001 0007 c874      move.b #$01,$0007c874 [00]
00005df6 4e75                     rts  == $6000001a
00005df8 3438 69ec                move.w $69ec [0000],d2
00005dfc 0c42 0230                cmp.w #$0230,d2
>d
00005e00 6714                     beq.b #$14 == $00005e16 (F)
00005e02 546e 0002                addq.w #$02,(a6,$0002) == $00dff002
00005e06 7470                     moveq #$70,d2
00005e08 9440                     sub.w d0,d2
00005e0a 0c42 fffd                cmp.w #$fffd,d2
00005e0e 6402                     bcc.b #$02 == $00005e12 (T)
00005e10 74fe                     moveq #$fe,d2
00005e12 d578 69f8                add.w d2,$69f8 [0050]
00005e16 0c41 0048                cmp.w #$0048,d1
00005e1a 6452                     bcc.b #$52 == $00005e6e (T)
>d
00005e1c 362e 000a                move.w (a6,$000a) == $00dff00a,d3
00005e20 0c43 000e                cmp.w #$000e,d3
00005e24 6a06                     bpl.b #$06 == $00005e2c (T)
00005e26 5243                     addq.w #$01,d3
00005e28 3d43 000a                move.w d3,(a6,$000a) == $00dff00a
00005e2c e243                     asr.w #$01,d3
00005e2e d76e 0004                add.w d3,(a6,$0004) == $00dff004
00005e32 7418                     moveq #$18,d2
00005e34 9441                     sub.w d1,d2
00005e36 d578 69f6                add.w d2,$69f6 [0048]
>d
00005e3a 7406                     moveq #$06,d2
00005e3c 0c43 0004                cmp.w #$0004,d3
00005e40 6b16                     bmi.b #$16 == $00005e58 (F)
00005e42 7407                     moveq #$07,d2
00005e44 0c42 0007                cmp.w #$0007,d2
00005e48 6b0e                     bmi.b #$0e == $00005e58 (F)
00005e4a 740c                     moveq #$0c,d2
00005e4c c478 6374                and.w $6374 [0000],d2
00005e50 e44a                     lsr.w #$02,d2
00005e52 6602                     bne.b #$02 == $00005e56 (T)


>d
00005e54 7402                     moveq #$02,d2
00005e56 5e42                     addq.w #$07,d2
00005e58 6100 e7a0                bsr.w #$e7a0 == $000045fa
00005e5c 4eb9 0004 8004           jsr $00048004
00005e62 203c 0000 0210           move.l #$00000210,d0
00005e68 4ef9 0007 c82a           jmp $0007c82a
00005e6e 7250                     moveq #$50,d1
00005e70 740b                     moveq #$0b,d2
00005e72 6100 e786                bsr.w #$e786 == $000045fa
00005e76 6100 d876                bsr.w #$d876 == $000036ee
>d
00005e7a 08f9 0006 0007 c875      bset.b #$0006,$0007c875 [00]
00005e82 4eb9 0004 8004           jsr $00048004
00005e88 7002                     moveq #$02,d0
00005e8a 4eb9 0004 8010           jsr $00048010
00005e90 303c 00fa                move.w #$00fa,d0
00005e94 613e                     bsr.b #$3e == $00005ed4
00005e96 7064                     moveq #$64,d0
00005e98 6100 003a                bsr.w #$003a == $00005ed4
00005e9c 6100 efc8                bsr.w #$efc8 == $00004e66
00005ea0 41f8 3ab1                lea.l $3ab1,a0
>d
00005ea4 6100 0b54                bsr.w #$0b54 == $000069fa
00005ea8 6100 de00                bsr.w #$de00 == $00003caa
00005eac 7064                     moveq #$64,d0
00005eae 6100 0024                bsr.w #$0024 == $00005ed4
00005eb2 6100 efb2                bsr.w #$efb2 == $00004e66
00005eb6 41f8 3abd                lea.l $3abd,a0
00005eba 6100 0b3e                bsr.w #$0b3e == $000069fa
00005ebe 6100 ddea                bsr.w #$ddea == $00003caa
00005ec2 7064                     moveq #$64,d0
00005ec4 6100 000e                bsr.w #$000e == $00005ed4
>d
00005ec8 6100 dddc                bsr.w #$dddc == $00003ca6
00005ecc 6100 dea8                bsr.w #$dea8 == $00003d76
00005ed0 6000 a94e                bra.w #$a94e == $00000820 (T)
00005ed4 d078 36e2                add.w $36e2 [0000],d0
00005ed8 b078 36e2                cmp.w $36e2 [0000],d0
00005edc 6afa                     bpl.b #$fa == $00005ed8 (T)
00005ede 4e75                     rts  == $6000001a
00005ee0 4cb8 000c 69f2           movem.w $69f2,d2-d3
00005ee6 9641                     sub.w d1,d3
00005ee8 0c43 0001                cmp.w #$0001,d3

>d
00005eec 6424                     bcc.b #$24 == $00005f12 (T)
00005eee 9440                     sub.w d0,d2
00005ef0 0c42 0020                cmp.w #$0020,d2
00005ef4 641c                     bcc.b #$1c == $00005f12 (T)
00005ef6 1438 6337                move.b $6337 [01],d2
00005efa 0c02 0024                cmp.b #$24,d2
00005efe 4e75                     rts  == $6000001a
00005f00 61de                     bsr.b #$de == $00005ee0
00005f02 640e                     bcc.b #$0e == $00005f12 (T)
00005f04 31fc 0018 69f6           move.w #$0018,$69f6 [0048]
>d
00005f0a 5256                     addq.w #$01,(a6)
00005f0c 3d7c 0020 0008           move.w #$0020,(a6,$0008) == $00dff008
00005f12 4e75                     rts  == $6000001a
00005f14 536e 0008                subq.w #$01,(a6,$0008) == $00dff008
00005f18 6726                     beq.b #$26 == $00005f40 (F)
00005f1a 7427                     moveq #$27,d2
00005f1c 946e 0008                sub.w (a6,$0008) == $00dff008,d2
00005f20 e64a                     lsr.w #$03,d2
00005f22 3f02                     move.w d2,-(a7) [0c64]
00005f24 6100 e6d4                bsr.w #$e6d4 == $000045fa
>d
00005f28 5040                     addq.w #$08,d0
00005f2a 3417                     move.w (a7) [6000],d2
00005f2c 6100 e6cc                bsr.w #$e6cc == $000045fa
00005f30 5040                     addq.w #$08,d0
00005f32 3417                     move.w (a7) [6000],d2
00005f34 6100 e6c4                bsr.w #$e6c4 == $000045fa
00005f38 5040                     addq.w #$08,d0
00005f3a 341f                     move.w (a7)+ [6000],d2
00005f3c 6000 e6bc                bra.w #$e6bc == $000045fa (T)
00005f40 4256                     clr.w (a6)
>d
00005f42 6100 f69c                bsr.w #$f69c == $000055e0
00005f46 e14a                     lsl.w #$08,d2
00005f48 1430 3001                move.b (a0,d3.W,$01) == $00000c78 [00],d2
00005f4c 1830 3002                move.b (a0,d3.W,$02) == $00000c79 [3c],d4
00005f50 e14c                     lsl.w #$08,d4
00005f52 1830 3003                move.b (a0,d3.W,$03) == $00000c7a [00],d4
00005f56 2a78 5fac                movea.l $5fac [0000600c],a5
00005f5a 48a5 3800                movem.w d2-d4,-(a5)
00005f5e 21cd 5fac                move.l a5,$5fac [0000600c]
00005f62 11bc 004f 3000           move.b #$4f,(a0,d3.W,$00) == $00000c77 [00]


>d
00005f68 11bc 004f 3001           move.b #$4f,(a0,d3.W,$01) == $00000c78 [00]
00005f6e 11bc 004f 3002           move.b #$4f,(a0,d3.W,$02) == $00000c79 [3c]
00005f74 11bc 004f 3003           move.b #$4f,(a0,d3.W,$03) == $00000c7a [00]
00005f7a 6100 ff64                bsr.w #$ff64 == $00005ee0
00005f7e 640a                     bcc.b #$0a == $00005f8a (T)
00005f80 31fc 540e 3c7c           move.w #$540e,$3c7c [4c7c]
00005f86 4278 6360                clr.w $6360 [0000]
00005f8a 7405                     moveq #$05,d2
00005f8c 6100 e66c                bsr.w #$e66c == $000045fa
00005f90 7405                     moveq #$05,d2
>d
00005f92 5040                     addq.w #$08,d0
00005f94 6100 e664                bsr.w #$e664 == $000045fa
00005f98 7405                     moveq #$05,d2
00005f9a 5040                     addq.w #$08,d0
00005f9c 6100 e65c                bsr.w #$e65c == $000045fa
00005fa0 7405                     moveq #$05,d2
00005fa2 5040                     addq.w #$08,d0
00005fa4 6100 e654                bsr.w #$e654 == $000045fa
00005fa8 6000 f940                bra.w #$f940 == $000058ea (T)

>m 5fac
00005FAC 0000 600C 0000 0000 0000 0000 0000 0000  ..`.............
00005FBC 0000 0000 0000 0000 0000 0000 0000 0000  ................
00005FCC 0000 0000 0000 0000 0000 0000 0000 0000  ................
00005FDC 0000 0000 0000 0000 0000 0000 0000 0000  ................
00005FEC 0000 0000 0000 0000 0000 0000 0000 0000  ................
00005FFC 0000 0000 0000 0000 0000 0000 0000 0000  ................
0000600C 0000 0000 0000 0000


; line 7616 - code1.s

>d 6014
00006014 0c40 00c0                cmp.w #$00c0,d0
00006018 6a40                     bpl.b #$40 == $0000605a (T)
0000601a 0244 0007                and.w #$0007,d4
0000601e 660e                     bne.b #$0e == $0000602e (T)
00006020 5040                     addq.w #$08,d0
00006022 6100 f5bc                bsr.w #$f5bc == $000055e0
00006026 5140                     subq.w #$08,d0
00006028 0c02 0051                cmp.b #$51,d2
0000602c 652c                     bcs.b #$2c == $0000605a (F)
0000602e 526e 0002                addq.w #$01,(a6,$0002) == $00dff002
>d
00006032 536e 0008                subq.w #$01,(a6,$0008) == $00dff008
00006036 6a26                     bpl.b #$26 == $0000605e (T)
00006038 4cb8 000c 69f2           movem.w $69f2,d2-d3
0000603e 9440                     sub.w d0,d2
00006040 0c42 0008                cmp.w #$0008,d2
00006044 6418                     bcc.b #$18 == $0000605e (T)
00006046 9641                     sub.w d1,d3
00006048 0c43 0013                cmp.w #$0013,d3
0000604c 6410                     bcc.b #$10 == $0000605e (T)
0000604e 3d7c 0019 0008           move.w #$0019,(a6,$0008) == $00dff008
>d
00006054 7c02                     moveq #$02,d6
00006056 6100 ecb2                bsr.w #$ecb2 == $00004d0a
0000605a 3cbc 001e                move.w #$001e,(a6)
0000605e 3404                     move.w d4,d2
00006060 e24a                     lsr.w #$01,d2
00006062 5242                     addq.w #$01,d2
00006064 6000 e594                bra.w #$e594 == $000045fa (T)
00006068 0c40 ffc0                cmp.w #$ffc0,d0
0000606c 6b44                     bmi.b #$44 == $000060b2 (F)
0000606e 0244 0007                and.w #$0007,d4
>d
00006072 6612                     bne.b #$12 == $00006086 (T)
00006074 0440 0010                sub.w #$0010,d0
00006078 6100 f566                bsr.w #$f566 == $000055e0
0000607c 0640 0010                add.w #$0010,d0
00006080 0c02 0051                cmp.b #$51,d2
00006084 652c                     bcs.b #$2c == $000060b2 (F)
00006086 536e 0002                subq.w #$01,(a6,$0002) == $00dff002
0000608a 536e 0008                subq.w #$01,(a6,$0008) == $00dff008
0000608e 6a26                     bpl.b #$26 == $000060b6 (T)
00006090 4cb8 000c 69f2           movem.w $69f2,d2-d3
>d
00006096 9440                     sub.w d0,d2
00006098 0642 000a                add.w #$000a,d2
0000609c 6418                     bcc.b #$18 == $000060b6 (T)
0000609e 9641                     sub.w d1,d3
000060a0 0c43 0013                cmp.w #$0013,d3
000060a4 6410                     bcc.b #$10 == $000060b6 (T)
000060a6 3d7c 0019 0008           move.w #$0019,(a6,$0008) == $00dff008
000060ac 7c02                     moveq #$02,d6
000060ae 6100 ec5a                bsr.w #$ec5a == $00004d0a
000060b2 3cbc 001d                move.w #$001d,(a6)

>d
000060b6 343c e003                move.w #$e003,d2
000060ba e24c                     lsr.w #$01,d4
000060bc b942                     eor.w d4,d2
000060be 5242                     addq.w #$01,d2
000060c0 6000 e538                bra.w #$e538 == $000045fa (T)


                    ; ---------------- display object co-ordinates ---------------
                    ; Start of 305 (sprite x & y positions - initialisation data)
display_object_coords 
>m 60c4
000060C4 2A02 2005 2005 2004 1505 1506 1506 1507  *. . . .........
000060D4 1507 1506 1507 1507 2C10 2C08 1402 210D  ........,.,...!.
000060E4 2B05 1905 2504 1706 1702 2005 0F06 0006  +...%..... .....
000060F4 2405 1507 1C05 1007 1207 1B03 1308 2C07  $.............,.
00006104 2C07 2C07 2C07 2904 1A06 03FE 2902 2008  ,.,.,.).....). .
00006114 1306 2A08 2007 2A04 2A02 24FA 1405 2A03  ..*. .*.*.$...*.
00006124 2A08 0F05 0F05 0F05 0F05 2A07 1507 1508  *.........*.....
00006134 1507 1508 0200 0201 0202 0000 0100 0100  ................
00006144 0101 0604 0B07 0F07 0C07 0B06 2005 1208  ............ ...
00006154 1200 2903 2206 2205 2204 1506 1507 1508  ..).".".".......
00006164 1504 1504 1506 1507 1504 2904 25FD 1305  ..........).%...
00006174 2904 2CFD 2904 1BFD 2004 1CFD 0C07 2805  ).,.)... .....(.
00006184 1503 1503 1503 1503 0301 0301 0601 0401  ................
00006194 0400 04FD 04FA 1D05 1108 0809 2903 2006  ............). .
000061A4 2005 2004 1506 1507 1508 1504 1504 1506   . .............
000061B4 1507 1504 2906 1306 2A07 2904 2EFC 2904  ....)...*.)...).
000061C4 25FB 0C0F 2211 3416 2C16 2009 1208 0B08  %...".4.,. .....
000061D4 2903 2005 2004 2004 1505 1506 1507 1503  ). . . .........
000061E4 1504 1505 1506 1503 2903 25FC 1405 0800  ........).%.....
000061F4 0303 2904 1BFD 2004 1CFD 0C07 2004 1207  ..)... ..... ...
>m
00006204 0B07 2904 2006 2005 2004 1506 1507 1508  ..). . . .......
00006214 1504 1504 1506 1507 1504 2904 25FD 1405  ..........).%...
00006224 2B04 2FFD 2904 18FC 2004 1CFD 0C07 2806  +./.)... .....(.
00006234 1803 1803 1803 1803 0000 0000 0000 0000  ................
00006244 0000 0908 0908 0908 0808 1D05 1308 0809  ................
00006254 2904 2006 2005 2004 1506 1507 1508 1504  ). . . .........
00006264 1504 1506 1507 1503 2904 25FD 1505 2B04  ........).%...+.
00006274 2FFE 2904 19FD 2202 1EFC 1005 2805 1504  /.)...".....(...
00006284 1504 1504 1504 2906 1503 1503 1503 1503  ......).........
00006294 1505 0A08 0009 2903 2005 2004 2004 1405  ......). . . ...
000062A4 1406 1407 1404 1404 1405 1406 1402 2906  ..............).
000062B4 1506 2906 2A07 2903 2EFC 2903 24FC 2004  ..).*.)...).$. .
000062C4 2004 2004 2004 2706 1304 1304 1304 1303   . . .'.........
000062D4 190B 0F09 120D 130D 1309 0B0F 1D05 1208  ................
000062E4 0808 2903 2005 2004 2004 1405 1406 1407  ..). . . .......
000062F4 1404 1404 1405 1406 1402 2903 25FD 1306  ..........).%...
00006304 2B04 2FFD 2903 18FC 2202 1EFC 1005 2805  +./.)...".....(.
00006314 1504 1504 1504 1504 2906 1503 1503 1503  ........).......
00006324 1503 

00006326 0001 0002 0003 0004 0005 0007 

batman_sprite3_id
00006332 0005 
batman_sprite2_id
00006334 0002
batman_sprite1_id
00006336 0001 

batman_y_bottom
00006338 0000 

state_parameter
0000633A 0000 

batman_swing_fall_speed
batman_swing_speed
0000633C 0000 

batman_fall_speed
0000633E 0000 

batman_fall_distance
00006340 0000   

00006342 0001

level_spawn_point_index
00006344 0000 0001 0000 0000 0000 0000 0000 0000  
00006354 C77C 0000 0000 0000 0000 0000 0000 0000  
00006364 0034 0005 A36C 0000 3DEC 0000 0000 0000  
00006374 0000 

00006376 2221 201F 1E1D 1C1B 1A19 1817 1615  
00006384 1413 1211 100F 0E0D 0C0B 0A09 0807 0605  
00006394 0403 0201 0003 0609 0D10 1316 191C 1F22  
000063A4 2529 2C2F 3235 383B 3E41 4447 4A4D 5053  
000063B4 5659 5C5F 6264 676A 6D70 7375 787B 7E80  
00006344 0000 

sprite_array_ptr
00006346 0001 0000 

sprite_gfx_left_offset
0000634A 0000 0000 

0000634E 0000 
00006350 0000 

player_input_command
00006352 00 
player_button_pressed
00006353 00

background_gfx_base
00006354 C77C 

00006356 0000 
00006358 0000 
0000635A 0000

grappling_hook_params
0000635C 0000 
0000635E 0000 
grappling_hook_height
00006360 0000 
00006362 0000 
00006364 0034 

offscreen_display_buffer_ptr
00006366 0005 A36C 

0000636A 0000 3DEC      ; trigger_new_actors

batman_sprite_anim_ptr
0000636E 0000 

00006370 0000 
00006372 0000 

playfield_swap_count
00006374 0000

00006376 2221 201F 1E1D 1C1B 1A19 1817 1615 
00006384 1413 1211 100F 0E0D 0C0B 0A09 0807 0605 
00006394 0403 0201 

00006398 0003 0609 0D10 1316 191C 1F22 
000063A4 2529 2C2F 3235 383B 3E41 4447 4A4D 5053 
000063B4 5659 5C5F 6264 676A 6D70 7375 787B 7E80 
000063C4 8386 888B 8E90 9395 989A 9D9F A2A4 A7A9 
000063D4 ABAE B0B2 
000063D8 B4B7 B9BB BDBF C1C3 C5C7 C9CB 
000063E4 CDCF D0D2 D4D6 D7D9 DBDC DEDF E1E2 E4E5 
000063F4 E7E8 E9EA ECED EEEF F0F1 F2F3 F4F5 F6F7 
00006404 F7F8 F9F9 FAFB FBFC FCFD FDFD FEFE FEFF 
00006414 FFFF FFFF 

batman_sprite_anim_fire_hook
00006418    30 D2 04

batman_sprite_anim_standing
0000641B    01 02 07 

batman_sprite_anim_ducking
0000641e    19 01 E6

batman_sprite_anim_ducked
00006421    1E 01 E1  

batman_sprite_anim_life_lost
00006424    19 01 E6
            19 01 E6 
            19 01 E6
            1B 01 E4 
            1B 01 E4
            1B 01 E4 
            1B 01 E4
            1B 01 E4 
            1B 01 E4
            1B 01 E4 
            1B 01 E4
            1D E3 00 
            1D E3 00
            1D E3 00 
            1D E3 00
            1D E3 00  
00006454    1D E3 00
            1D E3 00 
            1D E3 00
            00 

batman_sprite_anim_07
0000645E    24 01 01

batman_sprite_anim_firing
00006461    27 01 01  
00006464    2A 01 FE
            2C FD D7 
            2D 01 01
            00 

0000646E    13 01 01 
            16 01 01 
00006474    00

00006475    E4 

00006476    0050 041E 0001 0022 0080 0400 
            0190 0260 0001 0023 0160 0260
            0040 0610 0003 0003 00A8 0628 000F 00A8 0648 000F 00B8 0648 
            0080 05F0 0003 000E 0040 05E8 000F 00C0 05E8 000F 00C0 05A8 
            00E0 0580 0002 0002 0040 05A8 0003 00F0 05A8 
            0130 05D2 0002 000E 0128 05E8 0002 00A4 05A8 
            0130 0612 0001 000F 0140 0648 
            01A6 0640 0002 000F 01C0 0648 000E 0100 0648 
            0144 0580 0002 000E 00A2 05A8 000F 00A0 05A8 
            01FA 0640 0003 000E 0160 0628 000F 0208 0628 0002 0240 0648 
            0220 0600 0002 000F 0240 05E8 0003 0260 0648 
            02B0 057A 0001 000F 0230 05E8 
            0070 04F0 0001 0002 0110 0548  
            0050 04CE 0003 000F 0110 04E8 000F 0108 04E8 000F 0118 04E8
            0150 04CE 0002 000F 0160 04E8 000F 0060 04E8
            0180 04FF 0001 0003 019F 0528
            01A0 0500 0001 0003 01D0 0548 
            01F8 0530 0002 000E 0150 0528 0002 0150 0548
            01A0 05C5 0001 000F 01B8 05E8  
000065B4    01E0 0583 0001 0003 0200 05A8 
            0201 0580 0003 000F 0220 05A8 000F 022C 05A8 000F 0238 05A8 
            0218 0570 0002 000F 0240 0568 000F 0260 05A8 
            0218 0549 0002 000F 0230 0548 000F 0210 0528 
            0240 051F 0002 000F 01F8 0508 000F 01E0 0508 
            0240 04F0 0003 000F 0250 04E8 000F 0238 04E8 000F 0220 04E8 
            01AB 04A0 0001 0003 0258 04E8 
            0130 0440 0002 000F 0148 04A8 000E 01A0 04A8  
00006644    00E0 0468 0002 000F 00D0 0468 000E 0068 04A8 
            0088 0481 0002 000F 0068 04A8 000F 0088 0468 
            0080 03C0 0001 0003 0120 0408  
00006674    0159 03E0 0003 000E 0188 03E8 000E 0180 0408 0002 01A0 03E8 
            01B4 03E0 0002 000E 00F4 0408 000E 00E8 0408 
            01F8 0411 0001 000F 0238 0448 
            0240 03E4 0003 000E 0200 03E8 000E 0210 03E8 000E 0220 03E8 
            0240 03C0 0003 000F 0240 03A8 000F 0230 03A8 000F 0220 03A8
            01E0 0390 0006 0002 01F0 0388 000E 01A0 03A8 000E 01F0 0348 000E 0200 0348 000E 01F0 03A8 000E 01F8 03A8  
00006704    01A0 02A8 0001 0002 01A0 0288 
            015E 0250 0002 000F 0218 0288 000F 020C 0288 
            010C 02C0 0002 0002 00E0 02E8 0002 00F0 02E8 
            00EA 03AA 0003 000F 0110 03A8 000F 0100 03A8 0003 01C0 03A8
            00EA 0398 0002 000F 013C 0408 000F 014C 0408 
            00D0 0330 0002 000F 01AC 0348 000F 01A0 0348 
            00B0 0380 0002 0003 015C 03A8 000E 0088 019E 
            0070 0380 0002 000F 0128 03A8 000F 0138 03A8 
00006794    0126 0350 0001 0003 0158 0348 
            0189 0350 0002 000E 00E8 0348 000F 0198 0348
            00C0 029B 0002 000E 0120 0288 000E 0140 0268 
000067C4    00C0 025E 0003 0003 0150 0268 000F 00F0 0248 000E 00F0 0248
            00CC 021F 0002 000F 00F0 0208 000E 00F0 0208 
            00CC 01D0 0001 000F 00F0 01C8 
            0146 01A0 0001 0003 0160 01C8
            018A 0190 0001 000F 01A0 01A8 
            01B3 0180 0001 000F 01D8 01C8 
            0210 018C 0003 000E 00A8 0288 000F 0198 0248 0002 01C8 0228
            01C0 01F1 0002 000E 01C8 01E8 000E 01D8 01E8 
            0235 01F8 0002 000E 01C8 01E8 000E 01D8 01E8 
            0235 01CE 0002 000E 0180 01A8 000E 0188 01A8
            0200 019F 0001 0003 0160 01A8 
            014C 0170 0002 000F 0120 0168 0003 0130 0168
            018A 0100 0002 0002 00E8 0128 0003 01A0 0128 
            0124 0120 0003 0002 00E8 0128 000F 0124 0128 000F 01A0 01A8 
000068B4    01B0 0100 0002 000E 01D0 0108 0003 01D0 0148 
            0194 00C8 0001 0002 0140 00C8 
            0180 0080 0004 000E 0120 00C8 000E 0114 00C8 000E 0108 00C8 0002 00F0 00A8 
            0107 00A0 0003 000E 00E8 00C8 000E 00E8 00A8 0003 01C0 00C8 
            0140 000F 0002 0003 0168 0048 0003 0178 0048 
            0184 0020 0003 000F 01B0 0048 000F 01A0 0048 000E 00E8 0048 
            01A6 0020 0002 0020 01C0 0048 001F 01C0 0038 
end_of_trigger_list     ; 00006944

00006944    001D 0120 0088 
            001D 0120 00A8 
            001D 0180 0248 
            001D 01B0 01C8 
            001E 0190 0348 
            001E 0180 02A8 
            001E 01F0 02C8 
            001E 0220 0648  
00006974    001D 0200 0628
            001D 0220 05E8 
            001E 0140 04E8 
            001A 00A0 0548 
            001A 00A0 0568 
            001A 0120 0588 
            001A 01C0 03E8 
            001A 01C0 0408  
000069A4    001A 01C0 0428 
            001A 01C0 0308 
            001A 0160 01C8 
            001D 0240 0488 
            001D 0120 04A8 
end_of_actors       ; 000069C2

default_level_parameters
000069C2    0000 
000069C4    0600 
            0648 
            0050 
            0048 
            0048 
            0050 

spawn_point_parameters_1           
000069D0    0040 
            0440  
000069D4    0468 
            0050 
            0028 
            0028 
            0050 

spawn_point_parameters_2            
000069DE    01A0 
            0260 
            0288 
000069E4    0050 
            0028 
            0028 
            0050 


level_parameters
scroll_window_xy_coords
scroll_window_x_coord
000069EC    0000 

scroll_window_y_coord
000069EE    00F0 

scroll_window_max_x_coord
000069F0    0000 

batman_xy_offset
batman_x_offset
000069F2    0050 

batman_y_offset
000069F4    0048 

target_window_y_offset
000069F6    0048 

target_window_x_offset
000069F8    0050 

>d 69fa
000069fa 1018                     move.b (a0)+ [00],d0
000069fc 6b00 00d0                bmi.w #$00d0 == $00006ace (F)
00006a00 0240 00ff                and.w #$00ff,d0
00006a04 c0fc 002a                mulu.w #$002a,d0
00006a08 1218                     move.b (a0)+ [00],d1
00006a0a 4881                     ext.w d1
00006a0c d041                     add.w d1,d0
00006a0e 2279 0000 36ea           movea.l $000036ea [00061b9c],a1
00006a14 43f1 0000                lea.l (a1,d0.W,$00) == $00001250,a1
00006a18 7000                     moveq #$00,d0

>d
00006a1a 1018                     move.b (a0)+ [00],d0
00006a1c 67dc                     beq.b #$dc == $000069fa (F)
00006a1e 0c00 0020                cmp.b #$20,d0
00006a22 6700 00a2                beq.w #$00a2 == $00006ac6 (F)
00006a26 72cd                     moveq #$cd,d1
00006a28 0c00 0041                cmp.b #$41,d0
00006a2c 6424                     bcc.b #$24 == $00006a52 (T)
00006a2e 72d4                     moveq #$d4,d1
00006a30 0c00 0030                cmp.b #$30,d0
00006a34 641c                     bcc.b #$1c == $00006a52 (T)
>d
00006a36 7200                     moveq #$00,d1
00006a38 0c00 0021                cmp.b #$21,d0
00006a3c 671a                     beq.b #$1a == $00006a58 (F)
00006a3e 7201                     moveq #$01,d1
00006a40 0c00 0028                cmp.b #$28,d0
00006a44 6712                     beq.b #$12 == $00006a58 (F)
00006a46 7202                     moveq #$02,d1
00006a48 0c00 0029                cmp.b #$29,d0
00006a4c 670a                     beq.b #$0a == $00006a58 (F)
00006a4e 7203                     moveq #$03,d1
>d
00006a50 6006                     bra.b #$06 == $00006a58 (T)
00006a52 d200                     add.b d0,d1
00006a54 0241 00ff                and.w #$00ff,d1
00006a58 c2fc 0028                mulu.w #$0028,d1
00006a5c 45f9 0000 6ad0           lea.l $00006ad0,a2
00006a62 45f2 1000                lea.l (a2,d1.W,$00) == $00061cbb,a2
00006a66 7e07                     moveq #$07,d7
00006a68 2649                     movea.l a1,a3
00006a6a 121a                     move.b (a2)+ [64],d1
00006a6c c313                     and.b d1,(a3) [00]
>d
00006a6e 141a                     move.b (a2)+ [64],d2
00006a70 8513                     or.b d2,(a3) [00]
00006a72 c32b 1c8c                and.b d1,(a3,$1c8c) == $000415f4 [80]
00006a76 141a                     move.b (a2)+ [64],d2
00006a78 852b 1c8c                or.b d2,(a3,$1c8c) == $000415f4 [80]
00006a7c c32b 3918                and.b d1,(a3,$3918) == $00043280 [70]
00006a80 141a                     move.b (a2)+ [64],d2
00006a82 852b 3918                or.b d2,(a3,$3918) == $00043280 [70]
00006a86 c32b 55a4                and.b d1,(a3,$55a4) == $00044f0c [ce]
00006a8a 141a                     move.b (a2)+ [64],d2


>d
00006a8c 852b 55a4                or.b d2,(a3,$55a4) == $00044f0c [ce]
00006a90 47eb 002a                lea.l (a3,$002a) == $0003f992,a3
00006a94 45ea fffb                lea.l (a2,-$0005) == $00061cb7,a2
00006a98 121a                     move.b (a2)+ [64],d1
00006a9a c313                     and.b d1,(a3) [00]
00006a9c 141a                     move.b (a2)+ [64],d2
00006a9e 8513                     or.b d2,(a3) [00]
00006aa0 c32b 1c8c                and.b d1,(a3,$1c8c) == $000415f4 [80]
00006aa4 141a                     move.b (a2)+ [64],d2
00006aa6 852b 1c8c                or.b d2,(a3,$1c8c) == $000415f4 [80]
>d
00006aaa c32b 3918                and.b d1,(a3,$3918) == $00043280 [70]
00006aae 141a                     move.b (a2)+ [64],d2
00006ab0 852b 3918                or.b d2,(a3,$3918) == $00043280 [70]
00006ab4 c32b 55a4                and.b d1,(a3,$55a4) == $00044f0c [ce]
00006ab8 141a                     move.b (a2)+ [64],d2
00006aba 852b 55a4                or.b d2,(a3,$55a4) == $00044f0c [ce]
00006abe 47eb 002a                lea.l (a3,$002a) == $0003f992,a3
00006ac2 51cf ffa6                dbf .w d7,#$ffa6 == $00006a6a (F)
00006ac6 43e9 0001                lea.l (a1,$0001) == $000032c1,a1
00006aca 6000 ff4c                bra.w #$ff4c == $00006a18 (T)
>d
00006ace 4e75                     rts  == $6000001a

large_character_gfx
                ; include font8x8x4.s

>m 6ad0
00006AD0 CF30 3000 00C7 3038 0800 C730 3808 00C7  .00...08...08...
00006AE0 3038 0800 C730 3808 00E7 0018 1800 CF30  08...08........0
00006AF0 3000 00E7 0018 1800 F30C 0C00 00E1 181E  0...............
00006B00 0600 E318 1C04 00E3 181C 0400 E318 1C04  ................
00006B10 00E3 181C 0400 F30C 0C00 00F9 0006 0600  ................
00006B20 9F60 6000 00CF 3030 0000 C730 3808 00C7  .``...00...08...
00006B30 3038 0800 C730 3808 00C7 3038 0800 8760  08...08...08...`
00006B40 7818 00CF 0030 3000 FF00 0000 00FF 0000  x....00.........
00006B50 0000 FF00 0000 00FF 0000 0000 FF00 0000  ................
00006B60 009F 6060 0000 8F60 7010 00CF 0030 3000  ..``...`p....00.
00006B70 837C 7C00 0001 C6FE 3800 10CE EF21 0000  .||.....8....!..
00006B80 D6FF 2900 08E6 F711 0018 C6E7 2100 807C  ..).........!..|
00006B90 7F03 00C1 003E 3E00 C738 3800 00C3 383C  .....>>..88...8<
00006BA0 0400 E318 1C04 00E3 181C 0400 E318 1C04  ................
00006BB0 00E3 181C 0400 E318 1C04 00F3 000C 0C00  ................
00006BC0 837C 7C00 0001 C6FE 3800 900C 6F63 00E1  .||.....8...oc..
00006BD0 181E 0600 C330 3C0C 0087 6078 1800 00FE  .....0<...`x....
00006BE0 FF01 0080 007F 7F00 837C 7C00 0001 C6FE  .........||.....
00006BF0 3800 9806 6761 00C0 3C3F 0300 E106 1E18  8...ga..<?......
00006C00 0038 C6C7 0100 807C 7F03 00C1 003E 3E00  .8.....|.....>>.
>m
00006C10 E31C 1C00 00C1 3C3E 0200 816C 7E12 0001  ......<>...l~...
00006C20 CCFE 3200 01FE FE00 0080 0C7F 7300 F10C  ..2.........s...
00006C30 0E02 00F9 0006 0600 00FE FF00 0000 C0FF  ................
00006C40 3F00 1FC0 E020 0003 FCFC 0000 8006 7F79  ?.... .........y
00006C50 0038 C6C7 0100 807C 7F03 00C1 003E 3E00  .8.....|.....>>.
00006C60 837C 7C00 0001 C6FE 3800 1CC0 E323 0003  .||.....8....#..
00006C70 FCFC 0000 01C6 FE38 0018 C6E7 2100 807C  .......8....!..|
00006C80 7F03 00C1 003E 3E00 01FE FE00 0080 067F  .....>>.........
00006C90 7900 F00C 0F03 00E1 181E 0600 E318 1C04  y...............
00006CA0 00C7 3038 0800 C730 3808 00E7 0018 1800  ..08...08.......
00006CB0 837C 7C00 0001 C6FE 3800 18C6 E721 0080  .||.....8....!..
00006CC0 7C7F 0300 01C6 FE38 0018 C6E7 2100 807C  |......8....!..|
00006CD0 7F03 00C1 003E 3E00 837C 7C00 0001 C6FE  .....>>..||.....
00006CE0 3800 18C6 E721 0080 7E7F 0100 C006 3F39  8....!..~.....?9
00006CF0 0038 C6C7 0100 807C 7F03 00C1 003E 3E00  .8.....|.....>>.
00006D00 EF10 1000 00C7 3838 0000 C338 3C04 0083  ......88...8<...
00006D10 6C7C 1000 817C 7E02 0001 C6FE 3800 18C6  l|...|~.....8...
00006D20 E721 009C 0063 6300 03FC FC00 0001 C6FE  .!...cc.........
00006D30 3800 18C6 E721 0000 FCFF 0300 01C6 FE38  8....!.........8
00006D40 0018 C6E7 2100 00FC FF03 0081 007E 7E00  ....!........~~.
>m
00006D50 837C 7C00 0001 C6FE 3800 1CC0 E323 001F  .||.....8....#..
00006D60 C0E0 2000 1FC0 E020 0019 C6E6 2000 807C  .. .... .... ..|
00006D70 7F03 00C1 003E 3E00 07F8 F800 0003 CCFC  .....>>.........
00006D80 3000 19C6 E620 0018 C6E7 2100 18C6 E721  0.... ....!....!
00006D90 0010 CCEF 2300 01F8 FE06 0083 007C 7C00  ....#........||.
00006DA0 01FE FE00 0000 C0FF 3F00 1FC0 E020 0007  ........?.... ..
00006DB0 F8F8 0000 03C0 FC3C 001F C0E0 2000 01FE  .......<.... ...
00006DC0 FE00 0080 007F 7F00 01FE FE00 0000 C0FF  ................
00006DD0 3F00 1FC0 E020 0007 F8F8 0000 03C0 FC3C  ?.... .........<
00006DE0 001F C0E0 2000 1FC0 E020 009F 0060 6000  .... .... ...``.
00006DF0 837C 7C00 0001 C6FE 3800 1CC0 E323 0001  .||.....8....#..
00006E00 DEFE 2000 10C6 EF29 0018 C6E7 2100 807E  .. ....)....!..~
00006E10 7F01 00C0 003F 3F00 39C6 C600 0018 C6E7  .....??.9.......
00006E20 2100 18C6 E721 0000 FEFF 0100 00C6 FF39  !....!.........9
00006E30 0018 C6E7 2100 18C6 E721 009C 0063 6300  ....!....!...cc.
00006E40 8778 7800 00C3 303C 0C00 C730 3808 00C7  .xx...0<...08...
00006E50 3038 0800 C730 3808 00C7 3038 0800 8778  08...08...08...x
00006E60 7800 00C3 003C 3C00 F906 0600 00F8 0607  x....<<.........
00006E70 0100 F806 0701 00F8 0607 0100 38C6 C701  ............8...
00006E80 0018 C6E7 2100 807C 7F03 00C1 003E 3E00  ....!..|.....>>.
>m
00006E90 39C6 C600 0010 CCEF 2300 01D8 FE26 0003  9.......#....&..
00006EA0 F0FC 0C00 07D8 F820 0013 CCEC 2000 19C6  ....... .... ...
00006EB0 E620 009C 0063 6300 3FC0 C000 001F C0E0  . ...cc.?.......
00006EC0 2000 1FC0 E020 001F C0E0 2000 1FC0 E020   .... .... ....
00006ED0 0019 C6E6 2000 00FE FF01 0080 007F 7F00  .... ...........
00006EE0 39C6 C600 0010 EEEF 0100 00FE FF01 0000  9...............
00006EF0 D6FF 2900 10C6 EF29 0018 C6E7 2100 18C6  ..)....)....!...
00006F00 E721 009C 0063 6300 39C6 C600 0018 E6E7  .!...cc.9.......
00006F10 0100 08F6 F701 0000 DEFF 2100 10CE EF21  ..........!....!
00006F20 0018 C6E7 2100 18C6 E721 009C 0063 6300  ....!....!...cc.
00006F30 837C 7C00 0001 C6FE 3800 18C6 E721 0018  .||.....8....!..
00006F40 C6E7 2100 18C6 E721 0018 C6E7 2100 807C  ..!....!....!..|
00006F50 7F03 00C1 003E 3E00 03FC FC00 0001 C6FE  .....>>.........
00006F60 3800 18C6 E721 0000 FCFF 0300 01C0 FE3E  8....!.........>
00006F70 001F C0E0 2000 1FC0 E020 009F 0060 6000  .... .... ...``.
00006F80 837C 7C00 0001 C6FE 3800 18C6 E721 0018  .||.....8....!..
00006F90 C6E7 2100 00DA FF25 0000 CCFF 3300 8176  ..!....%....3..v
00006FA0 7E08 00C4 003B 3B00 03FC FC00 0001 C6FE  ~....;;.........
00006FB0 3800 18C6 E721 0000 FCFF 0300 01CC FE32  8....!.........2
00006FC0 0018 C6E7 2100 18C6 E721 009C 0063 6300  ....!....!...cc.

>m
00007110 11EE EE22 0081 7E7E 0600 C33C 3C0C 00C7  ..."..~~...<<...
00007120 3838 0800 C738 3808 00E7 1818 1800 03FC  88...88.........
00007130 FC00 0001 FEFE 3200 817E 7E66 00C3 3C3C  ......2..~~f..<<
00007140 0C00 8778 7818 0003 FCFC 3000 01FE FE02  ...xx.....0.....
00007150 0081 7E7E 7E00 0404 0505 0505 0505 0404  ..~~~...........
00007160 0404 0405 0504 0505 0404 0404 0404 0404  ................
00007170 0301 0100 00FF 0001 0101 0000 0102 0302  ................
00007180 0202 0304 0505 0504 0404 0302 01FF FDFD  ................
00007190 FCFC FCFB F9FA FAFC FDFD FDFC FDFD FF00  ................
000071A0 0101 0101 0000 FFFE FEFD FEFD FCFB FCFC  ................
000071B0 FBFC FDFC FEFE FEFE FFFE FEFF FFFE FEFF  ................
000071C0 FFFF 00FF 0000 0000 FF00 FF00 FFFE FFFE  ................
000071D0 FFFD FEFE FEFD FDFD FDFD FDFD FEFE FEFD  ................
000071E0 FDFE FF00 0000 0000 0100 0001 0001 FFFF  ................
000071F0 FFFE FEFE FEFE FEFD FDFC FCFC FCFC FCFD  ................
00007200 FCFC FDFD FEFF FFFF 00FF FFFE FFFE FF00  ................
00007210 0000 0001 0203 0201 0202 0200 FFFD FEFF  ................
00007220 FFFF FEFE 0000 0000 0101 0000 0102 0202  ................
00007230 0203 0404 0303 0505 0504 0303 0301 FDFD  ................
00007240 FEFF FDFD FCFD FEFE FFFF 0202 0201 0304  ................

>m
00007250 0404 0304 0404 0302 0302 0100 FEFF FEFE  ................
00007260 FCFC FDFD FDFD FCFC FCFD FEFF 0001 0000  ................
00007270 0101 0100 0101 0201 FF00 00FF 00FE FEFF  ................
00007280 FEFF FEFF 00FF FEFF FFFF 0000 0000 0101  ................
00007290 0101 0203 0203 0303 0303 0303 0304 0403  ................
000072A0 0302 0100 FFFF FEFF 0001 0101 0303 0303  ................
000072B0 0203 0203 0404 0404 0506 0504 0303 0203  ................
000072C0 0201 0100 FEFE FFFF FF00 0001 0202 0100  ................
000072D0 FF00 FFFF FEFE FEFD FEFF 0100 0000 0102  ................
000072E0 0100 00FF FEFC FDFE FF00 FFFC FCFC FCFC  ................
000072F0 FCFD FFFF 0101 0101 0203 0303 0405 0506  ................




                    ;-------------------------------------------------------------------------------------------
                    ; My Debug Routines
                    ;-------------------------------------------------------------------------------------------
                    ; I added the following routines to allow 'signals' to be flashed on screen, and/or
                    ; the game to be paused as required.
                    ;
                    ; The routines are used to modify routines so that I can flash the screen, pause the
                    ; game when certain code is executed.
                    ;

_DEBUG_COLOURS
            move.w  d0,$dff180
            add.w   #$1,d0
            btst    #6,$bfe001
            bne.s   _DEBUG_COLOURS
            rts
            
_DEBUG_RED_PAUSE
                    move.w  #$f00,$dff180
                    btst    #6,$bfe001
                    bne.s   _DEBUG_RED_PAUSE
                    rts

_MOUSE_WAIT
            btst    #6,$bfe001
            bne.s   _MOUSE_WAIT
            rts


                    ;-------------------------------------------------------------------------------------------
                    ; End of My Debug Routines
                    ;-------------------------------------------------------------------------------------------




                    ;-------------------------------------------------------------------------------------------
                    ;
                    ;   TEST BUILD - Additional Code & Data
                    ;
                    ;-------------------------------------------------------------------------------------------
                    ; If running a test build then we need the following resources:-
                    ;
                    ;   - Screen Memory Buffers
                    ;       - Offscreen Scroll Buffer memory (29232 bytes)
                    ;       - Double Buffered screen memory (58464 bytes)
                    ;
                    ;   - Music Player Code & Data
                    ;       - chem1.s
                    ;
                    ;   - Panel Code & GFX (Bottom of screen lives/score/energy display)
                    ;       - panel.s
                    ;
                    ;   - Level 1 - Background Tile Map Data & GFX
                    ;       - mapgr.s
                    ;
                    ;   - Level 1 - Sprites (Batman, Bad guys, projectiles, Drips, Gasleak)
                    ;       - batspr1.s
                    ;       - buffer for mirrored sprites (calculated on level initialisation)
                    ;
                    ;   - Sprite List Buffer - Dynamically created list of Sprite Object
                    ;       - sprite_list
                    ;

            ; if test build, allocate backbuffers in chip memory
                                IFD TEST_BUILD_LEVEL
chipmem_buffer                  dcb.b   CODE1_DISPLAY_BUFFER_BYTESIZE,$01
                                dcb.B   40*10,0     ; padding fixed scroll corruption
                                even
chipmem_doublebuffer            dcb.b   CODE1_DOUBLE_BUFFER_BYTESIZE,$55
                                dcb.b   40*10,0     ; padding fixed scroll corruption
                                ENDC

            ; padding - see if it fixes map data corruption
            dcb.B   1024,0

            ; If Test Build - Include the Level Music and SFX
            IFD TEST_BUILD_LEVEL
                incdir      "../chem/"
                include     "chem.s"
            ENDC

            ; padding - see if it fixes map data corruption
            dcb.B   1024,0

            ; If Test Build - Include the Bottom Panel (Score, Energy, Lives, Timer etc)
            IFD TEST_BUILD_LEVEL
                incdir      "../panel/"
                include     "panel.s"                                           ; original load address $2FFC
            ENDC

            ; padding - see if it fixes map data corruption
            dcb.B   1024,0

            ; If Test Build - Include the level map data and graphics
            IFD TEST_BUILD_LEVEL
                incdir      "../mapgr/"
                include     "mapgr.s"
            ENDC

            ; padding - see if it fixes map data corruption
            dcb.B   1024,0

            ; If Test Build - Include Batman Sprites File 1n( also allocate memory for mirrored sprites)
            IFD TEST_BUILD_LEVEL
                incdir      "../batspr1/"
                include     "batspr1.s"
                dcb.b       98856,0
            ENDC

            ; padding - see if it fixes map data corruption
            dcb.B   1024,0

            IFD TEST_BUILD_LEVEL
                even
sprite_list     dcb.b       305*8,0
            ENDC


