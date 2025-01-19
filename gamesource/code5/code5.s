


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

00004974 4cb8 0006 69f4           movem.w $69f4,d1-d2
0000497a 3001                     move.w d1,d0
0000497c 9042                     sub.w d2,d0
0000497e 31f8 6358 4972           move.w $6358 [0000],$4972 [0000]
00004984 31c0 6358                move.w d0,$6358 [0000]
00004988 6700 00a0                beq.w #$00a0 == $00004a2a (F)

0000498c 4a78 6342                tst.w $6342 [0001]
00004990 6b18                     bmi.b #$18 == $000049aa (F)
00004992 672a                     beq.b #$2a == $000049be (F)
00004994 0c40 0004                cmp.w #$0004,d0
00004998 6524                     bcs.b #$24 == $000049be (F)
0000499a 0c40 fffd                cmp.w #$fffd,d0
0000499e 641e                     bcc.b #$1e == $000049be (T)
000049a0 6a04                     bpl.b #$04 == $000049a6 (T)
000049a2 70fe                     moveq #$fe,d0
000049a4 6018                     bra.b #$18 == $000049be (T)
000049a6 7002                     moveq #$02,d0
000049a8 6014                     bra.b #$14 == $000049be (T)
000049aa 0c40 0008                cmp.w #$0008,d0
000049ae 650e                     bcs.b #$0e == $000049be (F)
000049b0 0c40 fffd                cmp.w #$fffd,d0
000049b4 6408                     bcc.b #$08 == $000049be (T)
000049b6 6b04                     bmi.b #$04 == $000049bc (F)
000049b8 7007                     moveq #$07,d0
000049ba 6002                     bra.b #$02 == $000049be (T)
000049bc 70fd                     moveq #$fd,d0
000049be 3238 69ee                move.w $69ee [00f0],d1
000049c2 3601                     move.w d1,d3
000049c4 d240                     add.w d0,d1
000049c6 0c41 0601                cmp.w #$0601,d1
000049ca 6512                     bcs.b #$12 == $000049de (F)
000049cc 6b0c                     bmi.b #$0c == $000049da (F)
000049ce 343c 0600                move.w #$0600,d2
000049d2 9242                     sub.w d2,d1
000049d4 9041                     sub.w d1,d0
000049d6 3202                     move.w d2,d1
000049d8 6004                     bra.b #$04 == $000049de (T)
000049da 9041                     sub.w d1,d0
000049dc 4241                     clr.w d1
000049de 9178 69f4                sub.w d0,$69f4 [0048]
000049e2 31c1 69ee                move.w d1,$69ee [00f0]
000049e6 9243                     sub.w d3,d1
000049e8 31c1 6358                move.w d1,$6358 [0000]
000049ec 673c                     beq.b #$3c == $00004a2a (F)
000049ee 6b22                     bmi.b #$22 == $00004a12 (F)
000049f0 0643 0057                add.w #$0057,d3
000049f4 3438 635a                move.w $635a [0000],d2
000049f8 3801                     move.w d1,d4
000049fa d842                     add.w d2,d4
000049fc 0c44 0057                cmp.w #$0057,d4
00004a00 6504                     bcs.b #$04 == $00004a06 (F)
00004a02 0444 0057                sub.w #$0057,d4
00004a06 31c4 635a                move.w d4,$635a [0000]
00004a0a 6100 0090                bsr.w #$0090 == $00004a9c
00004a0e 6000 001a                bra.w #$001a == $00004a2a (T)
00004a12 3438 635a                move.w $635a [0000],d2
00004a16 d441                     add.w d1,d2
00004a18 6a04                     bpl.b #$04 == $00004a1e (T)
00004a1a 0642 0057                add.w #$0057,d2
00004a1e 31c2 635a                move.w d2,$635a [0000]
00004a22 d641                     add.w d1,d3
00004a24 4441                     neg.w d1
00004a26 6100 0074                bsr.w #$0074 == $00004a9c
00004a2a 3038 69f2                move.w $69f2 [0050],d0
00004a2e 9078 69f8                sub.w $69f8 [0050],d0
00004a32 31c0 6356                move.w d0,$6356 [0000]
00004a36 6700 0062                beq.w #$0062 == $00004a9a (F)
00004a3a 3238 69ec                move.w $69ec [0000],d1
00004a3e 3401                     move.w d1,d2
00004a40 d240                     add.w d0,d1
00004a42 6a06                     bpl.b #$06 == $00004a4a (T)
00004a44 3001                     move.w d1,d0
00004a46 4241                     clr.w d1
00004a48 6010                     bra.b #$10 == $00004a5a (T)
00004a4a 4240                     clr.w d0
00004a4c 0c41 0230                cmp.w #$0230,d1
00004a50 6308                     bls.b #$08 == $00004a5a (F)
00004a52 303c 0230                move.w #$0230,d0
00004a56 9240                     sub.w d0,d1
00004a58 c340                     exg.l d1,d0
00004a5a d078 69f8                add.w $69f8 [0050],d0
00004a5e 31c0 69f2                move.w d0,$69f2 [0050]
00004a62 31c1 69ec                move.w d1,$69ec [0000]
00004a66 3601                     move.w d1,d3
00004a68 9642                     sub.w d2,d3
00004a6a 31c3 6356                move.w d3,$6356 [0000]
00004a6e 672a                     beq.b #$2a == $00004a9a (F)
00004a70 b342                     eor.w d1,d2
00004a72 0802 0003                btst.l #$0003,d2
00004a76 6722                     beq.b #$22 == $00004a9a (F)
00004a78 2878 6366                movea.l $6366 [0005a36c],a4
00004a7c 4a43                     tst.w d3
00004a7e 6b10                     bmi.b #$10 == $00004a90 (F)
00004a80 0641 00a0                add.w #$00a0,d1
00004a84 544c                     addaq.w #$02,a4
00004a86 21cc 6366                move.l a4,$6366 [0005a36c]
00004a8a 49ec 0028                lea.l (a4,$0028) == $00bfe129,a4
00004a8e 6006                     bra.b #$06 == $00004a96 (T)
00004a90 554c                     subaq.w #$02,a4
00004a92 21cc 6366                move.l a4,$6366 [0005a36c]
00004a96 6100 007c                bsr.w #$007c == $00004b14
00004a9a 4e75                     rts  == $6000001a



00004a9c 5341                     subq.w #$01,d1
00004a9e 3803                     move.w d3,d4
00004aa0 0244 0007                and.w #$0007,d4
00004aa4 e944                     asl.w #$04,d4
00004aa6 13c4 0000 4adf           move.b d4,$00004adf [00]
00004aac 3803                     move.w d3,d4
00004aae e64c                     lsr.w #$03,d4
00004ab0 41f9 0000 8002           lea.l $00008002,a0
00004ab6 c8d0                     mulu.w (a0) [003c],d4
00004ab8 3038 69ec                move.w $69ec [0000],d0
00004abc e648                     lsr.w #$03,d0
00004abe d840                     add.w d0,d4
00004ac0 41f0 407a                lea.l (a0,d4.W,$7a) == $00000df3,a0
00004ac4 3802                     move.w d2,d4
00004ac6 c8fc 0054                mulu.w #$0054,d4
00004aca d8b8 6366                add.l $6366 [0005a36c],d4
00004ace 2244                     movea.l d4,a1
00004ad0 7e14                     moveq #$14,d7
00004ad2 2478 6352                movea.l $6352 [0000c77c],a2
00004ad6 4240                     clr.w d0
00004ad8 1018                     move.b (a0)+ [00],d0
00004ada ef40                     asl.w #$07,d0
00004adc 47f2 0000                lea.l (a2,d0.W,$00) == $000622a7,a3
00004ae0 32db                     move.w (a3)+ [62f9],(a1)+ [0000]
00004ae2 335b 1c8a                move.w (a3)+ [62f9],(a1,$1c8a) == $00040fb4 [0000]
00004ae6 335b 3916                move.w (a3)+ [62f9],(a1,$3916) == $00042c40 [3844]
00004aea 335b 55a2                move.w (a3)+ [62f9],(a1,$55a2) == $000448cc [eae1]
00004aee 335b 0028                move.w (a3)+ [62f9],(a1,$0028) == $0003f352 [ee00]
00004af2 335b 1cb4                move.w (a3)+ [62f9],(a1,$1cb4) == $00040fde [0000]
00004af6 335b 3940                move.w (a3)+ [62f9],(a1,$3940) == $00042c6a [0060]
00004afa 335b 55cc                move.w (a3)+ [62f9],(a1,$55cc) == $000448f6 [7000]
00004afe 51cf ffd6                dbf .w d7,#$ffd6 == $00004ad6 (F)
00004b02 5243                     addq.w #$01,d3
00004b04 5242                     addq.w #$01,d2
00004b06 0c42 0057                cmp.w #$0057,d2
00004b0a 6502                     bcs.b #$02 == $00004b0e (F)
00004b0c 4242                     clr.w d2
00004b0e 51c9 ff8e                dbf .w d1,#$ff8e == $00004a9e (F)
00004b12 4e75                     rts  == $6000001a



00004b14 2478 6352                movea.l $6352 [0000c77c],a2
00004b18 3401                     move.w d1,d2
00004b1a e64a                     lsr.w #$03,d2
00004b1c 3238 69ee                move.w $69ee [00f0],d1
00004b20 3001                     move.w d1,d0
00004b22 0240 0007                and.w #$0007,d0
00004b26 3a00                     move.w d0,d5
00004b28 4645                     not.w d5
00004b2a 0245 0007                and.w #$0007,d5
00004b2e e948                     lsl.w #$04,d0
00004b30 e649                     lsr.w #$03,d1
00004b32 41f9 0000 8002           lea.l $00008002,a0
00004b38 3810                     move.w (a0) [003c],d4
00004b3a c2c4                     mulu.w d4,d1
00004b3c d242                     add.w d2,d1
00004b3e 41f0 107a                lea.l (a0,d1.W,$7a) == $00000cf1,a0
00004b42 7e56                     moveq #$56,d7
00004b44 3238 635a                move.w $635a [0000],d1
00004b48 7c56                     moveq #$56,d6
00004b4a 9c41                     sub.w d1,d6
00004b4c c2fc 0054                mulu.w #$0054,d1
00004b50 43f4 1800                lea.l (a4,d1.L,$00) == $00c0e100,a1
00004b54 4241                     clr.w d1
00004b56 1210                     move.b (a0) [00],d1
00004b58 ef41                     asl.w #$07,d1
00004b5a d041                     add.w d1,d0
00004b5c 600c                     bra.b #$0c == $00004b6a (T)
00004b5e 51cd 0010                dbf .w d5,#$0010 == $00004b70 (F)
00004b62 7a07                     moveq #$07,d5
00004b64 4240                     clr.w d0
00004b66 1010                     move.b (a0) [00],d0
00004b68 ef40                     asl.w #$07,d0
00004b6a 47f2 0000                lea.l (a2,d0.W,$00) == $000622a7,a3
00004b6e d0c4                     adda.w d4,a0
00004b70 329b                     move.w (a3)+ [62f9],(a1) [0000]
00004b72 335b 1c8c                move.w (a3)+ [62f9],(a1,$1c8c) == $00040fb6 [0000]
00004b76 335b 3918                move.w (a3)+ [62f9],(a1,$3918) == $00042c42 [0120]
00004b7a 335b 55a4                move.w (a3)+ [62f9],(a1,$55a4) == $000448ce [f000]
00004b7e 335b 002a                move.w (a3)+ [62f9],(a1,$002a) == $0003f354 [ce00]
00004b82 335b 1cb6                move.w (a3)+ [62f9],(a1,$1cb6) == $00040fe0 [0000]
00004b86 335b 3942                move.w (a3)+ [62f9],(a1,$3942) == $00042c6c [0000]
00004b8a 335b 55ce                move.w (a3)+ [62f9],(a1,$55ce) == $000448f8 [0000]
00004b8e 43e9 0054                lea.l (a1,$0054) == $0003f37e,a1
00004b92 51ce 0006                dbf .w d6,#$0006 == $00004b9a (F)
00004b96 43e9 e374                lea.l (a1,-$1c8c) == $0003d69e,a1
00004b9a 51cf ffc2                dbf .w d7,#$ffc2 == $00004b5e (F)
00004b9e 4e75                     rts  == $6000001a



00004ba0 33fc 8400 00df f096      move.w #$8400,$00dff096
00004ba8 2c78 36ea                movea.l $36ea [00061b9c],a6
00004bac 554e                     subaq.w #$02,a6
00004bae 2a78 6366                movea.l $6366 [0005a36c],a5
00004bb2 3238 635a                move.w $635a [0000],d1
00004bb6 4286                     clr.l d6
00004bb8 5346                     subq.w #$01,d6
00004bba 4846                     swap.w d6
00004bbc 3438 69ec                move.w $69ec [0000],d2
00004bc0 0242 0007                and.w #$0007,d2
00004bc4 6704                     beq.b #$04 == $00004bca (F)
00004bc6 e4be                     ror.l d2,d6
00004bc8 e4be                     ror.l d2,d6
00004bca 4442                     neg.w d2
00004bcc e65a                     ror.w #$03,d2
00004bce 0282 0000 e000           and.l #$0000e000,d2
00004bd4 6602                     bne.b #$02 == $00004bd8 (T)
00004bd6 544e                     addaq.w #$02,a6
00004bd8 0042 09f0                or.w #$09f0,d2
00004bdc 4842                     swap.w d2
00004bde 3801                     move.w d1,d4
00004be0 c8fc 0054                mulu.w #$0054,d4
00004be4 43f5 4800                lea.l (a5,d4.L,$00) == $1022d201,a1
00004be8 204e                     movea.l a6,a0
00004bea 7628                     moveq #$28,d3
00004bec 383c 00ae                move.w #$00ae,d4
00004bf0 9841                     sub.w d1,d4
00004bf2 9841                     sub.w d1,d4
00004bf4 6100 0026                bsr.w #$0026 == $00004c1c
00004bf8 3801                     move.w d1,d4
00004bfa 6716                     beq.b #$16 == $00004c12 (F)
00004bfc 7657                     moveq #$57,d3
00004bfe 9644                     sub.w d4,d3
00004c00 c6fc 0054                mulu.w #$0054,d3
00004c04 41f6 3800                lea.l (a6,d3.L,$00) == $04f3f313,a0
00004c08 d844                     add.w d4,d4
00004c0a 7628                     moveq #$28,d3
00004c0c 43d5                     lea.l (a5),a1
00004c0e 6100 000c                bsr.w #$000c == $00004c1c
00004c12 33fc 0400 00df f096      move.w #$0400,$00dff096
00004c1a 4e75                     rts  == $6000001a


00004c1c 2a02                     move.l d2,d5
00004c1e 4845                     swap.w d5
00004c20 0245 e000                and.w #$e000,d5
00004c24 5443                     addq.w #$02,d3
00004c26 ed44                     asl.w #$06,d4
00004c28 3a03                     move.w d3,d5
00004c2a e24d                     lsr.w #$01,d5
00004c2c d845                     add.w d5,d4
00004c2e 0443 002a                sub.w #$002a,d3
00004c32 4443                     neg.w d3
00004c34 49f9 00df f000           lea.l $00dff000,a4
00004c3a 2a3c 0000 1c8c           move.l #$00001c8c,d5
00004c40 0839 0006 00df f002      btst.b #$0006,$00dff002
00004c48 66f6                     bne.b #$f6 == $00004c40 (T)
00004c4a 2946 0044                move.l d6,(a4,$0044) == $00bfe145
00004c4e 3943 0064                move.w d3,(a4,$0064) == $00bfe165
00004c52 3943 0066                move.w d3,(a4,$0066) == $00bfe167
00004c56 2942 0040                move.l d2,(a4,$0040) == $00bfe141
00004c5a 7e03                     moveq #$03,d7
00004c5c 0839 0006 00df f002      btst.b #$0006,$00dff002
00004c64 66f6                     bne.b #$f6 == $00004c5c (T)
00004c66 2949 0050                move.l a1,(a4,$0050) == $00bfe151
00004c6a 2948 0054                move.l a0,(a4,$0054) == $00bfe155
00004c6e 3944 0058                move.w d4,(a4,$0058) == $00bfe159
00004c72 d3c5                     adda.l d5,a1
00004c74 d1c5                     adda.l d5,a0
00004c76 51cf ffe4                dbf .w d7,#$ffe4 == $00004c5c (F)
00004c7a 4e75                     rts  == $6000001a


00004c7c 4242                     clr.w d2
00004c7e 1438 6350                move.b $6350 [00],d2
00004c82 e542                     asl.w #$02,d2
00004c84 207b 2004                movea.l (pc,d2.W,$04=$00004c8a) == $00005691 [4200623b],a0
00004c88 4ed0                     jmp (a0)









