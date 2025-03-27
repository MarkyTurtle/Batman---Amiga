                ; Load Address: $3ffc
                ; Length bytes: $18005 (98309)
                ; End Address:  $1c001
                ; Code Entry:   $d000
                ;
                section panel,code_c
                org     $0                                          ; original load address


                ;--------------------- includes and constants ---------------------------
                INCDIR      "include"
                INCLUDE     "hw.i"


TEST_BUILD_LEVEL        EQU     1



            IFD TEST_BUILD_LEVEL 
start
                jmp code_entry_point                ; original address $0000d000 

            ELSE
                org $3ffc

                dc.l    $00004000
            ENDC    

L00004000           rts
L00004004           rts          
L00004008           rts
L00004010           rts          
L00004014           rts
L00004018           rts

stack_memory        ; original address L0000EF96
L0000EF96

                    ;------------------------- code entry point on load ---------------------------
                    ;
code_entry_point
L0000D000               LEA.L   L0000EF96,A7                ; stack
L0000D006               JSR     L00004000                   ; music?

                    ; init font - 320 lines of 5 byte struct (4bpl + mask)
L0000D00C               MOVE.W  #$013f,D7                   ; d7 = 320
L0000D010               LEA.L   font8x8x5,a0                ; L0000E7BC,A0
L0000D016_loop          MOVE.B  $0004(A0),D0
L0000D01A               AND.B   $0001(A0),D0
L0000D01E               NOT.B   D0
L0000D020               AND.B   $0002(A0),D0
L0000D024               AND.B   $0003(A0),D0
L0000D028               EOR.B   D0,$0004(A0)
L0000D02C               MOVE.B  $0004(A0),D0
L0000D030               AND.B   $0003(A0),D0
L0000D034               NOT.B   D0
L0000D036               AND.B   $0001(A0),D0
L0000D03A               AND.B   $0002(A0),D0
L0000D03E               EOR.B   D0,$0001(A0)
L0000D042               EOR.B   D0,$0003(A0)
L0000D046               ADDA.L  #$00000005,A0           ; next struct (5 bytes)
L0000D048               DBF.W   D7,L0000D016_loop 

L0000D04C               MOVE.W  #$7fff,D0
L0000D050               MOVE.W  D0,CUSTOM+DMACONR                   ; $00dff002; writing to RO register = BAD NEWS
L0000D056               MOVE.W  D0,CUSTOM+INTENA                    ; $00dff09a - disable interrupts
L0000D05C               MOVE.W  D0,CUSTOM+INTREQ                    ; $00dff09c - clear current interrupt flags
L0000D062               MOVE.W  #$e028,CUSTOM+INTENA                ; $00dff09a - SET|INTEN|EXTER|COPER|VERTB|PORTS
L0000D06A               MOVE.W  #$83c0,CUSTOM+DMACON                ; $00dff096 - SET|DMAEN|BPLEN|COPEN|BLTEN
L0000D072               MOVE.L  #copper_list,CUSTOM+COP1LC          ; $00dff080 - copper list
L0000D07C               MOVE.W  CUSTOM+COPJMP1,D0                   ; $00dff088,D0 - reading from WO register - BAD NEWS

L0000D082               MOVE.L  #level1_interrupt_handler,$00000064             ; exception vector - Level 1
L0000D08C               MOVE.L  #level2_interrupt_handler,$00000068             ; exception vector - Level 2
L0000D096               MOVE.L  #level3_interrupt_handler,$0000006c             ; exception vector - Level 3
L0000D0A0               MOVE.L  #level4_interrupt_handler,$00000070             ; exception vector - Level 4
L0000D0AA               MOVE.L  #level5_interrupt_handler,$00000074             ; exception vector - Level 5

L0000D0B4               MOVE.B  #$7f,$00bfed01
L0000D0BC               MOVE.B  #$7f,$00bfed01
L0000D0C4               BRA.W   L0000D10C 
                            ;-------------------------------------

level_status        ; original address L0000D0C8 ( > 0 = level completed )
L0000D0C8               dc.w    $0000 


                    ;----------------- return to title screen --------------
return_to_title_screen  ; original address L0000D0CA
L0000D0CA               MOVE.W  #$0064,D0                       ; frames to wait/skip
L0000D0CE               BSR.W   wait_frame                      ; L0000D1EE
L0000D0D2               BSR.W   fade_panel_out                  ; L0000E630
L0000D0D6               JMP     $00000820                       ; loader - load title screen
                    ; ---------------------------------------------
                    ; NEVER RETURNS
                    ;----------------------------------------------



                    ;-------------------- level completed ------------------
level_completed     ; original address L0000D0DC
L0000D0DC               MOVE.W  #$9999,PANEL_TIMER_UPDATE_VALUE     ;$0007c882 ; panel
L0000D0E4               MOVE.L  #$0005ed00,L0000E55A            ; external address (display?)
L0000D0EE               MOVE.L  #$00067680,L0000E55E            ; external address (display?)
L0000D0F8               BSR.W   L0000E562
L0000D0FC               BSR.W   fade_panel_out                  ; L0000E630
L0000D100               JSR     L00004008                       ; music ?
L0000D106               JMP     $00000830                       ; loader - load batwing level 4
                    ; ---------------------------------------------
                    ; NEVER RETURNS
                    ;----------------------------------------------




                    ;-------------------- continue game start --------------------
L0000D10C               JSR     L00004008                                   ; music ?
L0000D112               BTST.B  #PANEL_ST1_NO_LIVES_LEFT,PANEL_STATUS_1     ; #$0001,$0007c874 ; panel 
L0000D11A               BNE.W   return_to_title_screen                      ; L0000D0CA

L0000D11E               TST.W   level_status                                ; L0000D0C8
L0000D124               BNE.W   level_completed                             ; L0000D0DC

L0000D128               JSR     L00004008                       ; music ?
L0000D12E               LEA.L   L0000EF96,A7
L0000D134               BSR.W   L0000D38C
L0000D138               BSR.W   panel_fade_in                   ; L0000E5EA
L0000D13C               BSR.W   L0000E4F2
L0000D140               CLR.W   PANEL_TIMER_UPDATE_VALUE        ; $0007c882                       ; panel
L0000D146               MOVE.L  #$00000001,D0
L0000D148               BSR.W   L0000D26E
L0000D14C               CLR.W   L0000D1E6
L0000D152               MOVE.L  #$00000000,D0                   ; number of frames to wait/skip
L0000D154               BSR.W   wait_frame                      ; L0000D1EE
L0000D158               BSR.W   L0000DC1C
L0000D15C               BSR.W   L0000D56A
L0000D160               JSR     L0000D222
L0000D166               BTST.B  #PANEL_ST1_TIMER_EXPIRED,PANEL_STATUS_1           ; #$0000,$0007c874               ; panel
L0000D16E               BEQ.B   L0000D152 
L0000D170               BRA.W   L0000D9E6 



                ; ------------ level 1 interrupt handler ------------------
                ; do nothing, unused
                ;
level1_interrupt_handler    ; original address L0000D174
L0000D174               RTE 


                ; ------------ level 2 interrupt handler ------------------
                ; PORTS interrupt
                ;  - reading raw keycodes and twiddling bits on CIAA
                ;  - not the recommended way of reading the keyboard and ack'ing the code, as far as I can see.
                ;
level2_interrupt_handler    ; original address L0000D176
L0000D176               MOVE.B  $00bfec01,L0000D1E7             ; raw key code from keyboard
L0000D180               MOVE.B  $00bfed01,$00bfed01             ; ICR - unless a CIAA interrupt will clear CIA interrupts?
L0000D18A               MOVE.W  #$0808,CUSTOM+INTREQ            ; Clear PORTS | RBF? - $00dff09c
L0000D192               MOVE.B  #$08,$00bfed01                  ; ICR - Clear SP FLAG
L0000D19A               MOVE.B  #$60,$00bfee01                  ; CRA - INMODE=1, SPMODE=1
L0000D1A2               RTE 


                ;-------------- level 3 interrupt handler -----------------
                ; COPER & VERTB interrupts
                ;   - Update Music
                ;   - Update Score Panel
                ;   - CIAA Bit twiddling, maybe a keyboard ack, not the recommended way of reading the keyboard and ack'ing the code, as far as I can see.
                ;
level3_interrupt_handler    ; original address L0000D1A4
L0000D1A4               MOVEM.L D0-D7/A0-A6,-(A7)
L0000D1A8               MOVE.W  #$0020,CUSTOM+INTREQ            ; Clear VERTB interrupt - $00dff09c
L0000D1B0               MOVE.B  $00bfed01,$00bfed01             ; ICR - interrupt control register (reading clears it, msb is set/clear so unless cia interrupt has occurred then it will disable ciaa interrupts)
L0000D1BA               MOVE.B  #$08,$00bfee01                  ; CRA, Set timer A one-shot mode
L0000D1C2               MOVE.B  #$88,$00bfed01                  ; ICR, Set, SP FLAG (Enable SP Interrupt)
L0000D1CA               NOT.W   frame_toggle                    ; Frame Toggle (odd/even frame toggle) - unreferenced by game code
L0000D1D0               JSR     L00004018                       ; music - update
L0000D1D6               JSR     PANEL_UPDATE                    ; panel - update $0007c800
L0000D1DC               MOVEM.L (A7)+,D0-D7/A0-A6
L0000D1E0               RTE 


                ; --------------- level 4 interrupt handler ---------------
                ; unused
                ;
level4_interrupt_handler    ; original address L0000D1E2
L0000D1E2               RTE 


                ; --------------- level 5  interrupt handler ---------------
                ; unused
                ;
level5_interrupt_handler    ; original address L0000D1E4
L0000D1E4               RTE 



L0000D1E6               dc.b    $00
raw_keycode
L0000D1E7               dc.b    $00                 ; raw keycode.
L0000D1E8               dc.w    $0000 
L0000D1EA               dc.w    $0000
L0000D1EC               dc.w    $0000


                    ; ------------- wait frame count -------------
                    ; Wait for number of specified frames.
                    ; Contains a dodgy processor loop to wait for beam to end the current raster.
                    ; IN:
                    ;   D0.w = frame count
                    ;
wait_frame          ; original address $0000D1EE
L0000D1EE_loop          CMP.B   #$c1,CUSTOM+VHPOSR       ; $00dff006
L0000D1F6               BNE.B   L0000D1EE_loop 
L0000D1F8               MOVE.W  #$0064,D1
L0000D1FC_loop          DBF.W   D1,L0000D1FC_loop
L0000D200               DBF.W   D0,L0000D1EE_loop
L0000D204               RTS 


                    ; copy word value from (a0)+
                    ; place that word into last word of 2 word struct (a1)+
                    ; e.g
                    ;   - A0 = $1111,$2222,$3333
                    ;   - a1 = xxxx,$1111,xxxx,$2222,xxxx,$3333
                    ;   where xxxx is untouched b this routine
                    ;
                    ; IN:
                    ;   A0 = source data words
                    ;   A1 = dest data structure
                    ;
                    ; OUT:
                    ;   D0.l = $00000001
                    ;
L0000D206               MOVE.W  #$000f,D0
L0000D20A               ADDA.L  #$00000002,A1
L0000D20C_loop          MOVE.W  (A0)+,(A1)+
L0000D20E               ADDA.L  #$00000002,A1
L0000D210               DBF.W   D0,L0000D20C_loop 
L0000D214               MOVE.L  #$00000001,D0           ; frames to wait/skip
L0000D216               BRA.W   wait_frame              ; L0000D1EE_loop 

L0000D21A               CLR.W   L0000D1EC
L0000D220               RTS 



L0000D222               BTST.B  #$0000,raw_keycode      ; test key up/down flag - L0000D1E7
L0000D22A               BNE.W   L0000D21A 
L0000D22E               TST.W   L0000D1EC
L0000D234               BNE.W   L0000D220 
L0000D238               CMP.W   #$004c,L0000D1E6        ; $4c = 76 (cursor up keycode)
L0000D240               BEQ.W   L0000D2D8               ; skip level
L0000D244               CMP.W   #$005c,L0000D1E6        ; $5c = 92 
L0000D24C               BEQ.W   L0000D260               ; toggle music (forward slash keypad)
L0000D250               CMP.W   #$0074,L0000D1E6        ; $74 = 116
L0000D258               BEQ.W   L0000D2C2               ; end the game ()
L0000D25C               BRA.W   L0000D21A 


L0000D260               NOT.W   L0000D1EC
L0000D266               BCHG.B  #PANEL_ST2_MUSIC_SFX,PANEL_STATUS_2       ; #$0000,$0007c875            ; panel
L0000D26E               BTST.B  #PANEL_ST2_MUSIC_SFX,PANEL_STATUS_2       ; #$0000,$0007c875            ; panel
L0000D276               BEQ.B   L0000D27E 
L0000D278               JMP     L00004004                   ; music ?
L0000D27E               MOVE.L  #$00000001,D0
L0000D280               JMP     L00004010                   ; music?
L0000D286               CLR.W   L0000D1EC
L0000D28C               RTS 


L0000D28E               MOVE.W  #$9999,PANEL_TIMER_UPDATE_VALUE     ; $0007c882           ; panel
L0000D296               NOT.W   L0000D2C0
L0000D29C               CLR.W   L0000D1E6
L0000D2A2               CMP.W   #$005e,L0000D1E6
L0000D2AA               BNE.B   L0000D2A2 
L0000D2AC               CLR.W   L0000D1E6
L0000D2B2               CLR.W   PANEL_TIMER_UPDATE_VALUE            ; $0007c882           ; panel
L0000D2B8               CLR.W   L0000D2C0
L0000D2BE               RTS 



L0000D2C0                dc.w    $0000 


                    ; -------------- no lives left/end level -------------
L0000D2C2               MOVE.W  #$9999,PANEL_TIMER_UPDATE_VALUE             ; $0007c882            ; panel
L0000D2CA               BSET.B  #PANEL_ST1_NO_LIVES_LEFT,PANEL_STATUS_1     ; #$0001,$0007c874     ; panel
L0000D2D2               JMP     L0000DA10 

                    ; ------------- skip level -------------
L0000D2D8               BTST.B  #PANEL_ST2_CHEAT_ACTIVE,PANEL_STATUS_2      ; #$0007,$0007c875     ;panel
L0000D2E0               BEQ.B   L0000D2EE 
L0000D2E2               NOT.W   level_status                                ; L0000D0C8
L0000D2E8               JMP     L0000DA10
L0000D2EE               RTS 


L0000D2F0               LEA.L   L0000D36C,A0
L0000D2F6               LEA.L   L0000D37C,A1
L0000D2FC               MOVE.W  #$0001,D0
L0000D300               MOVE.L  #$00000000,D1
L0000D302               BSR.W   L0000D344
L0000D306               ADD.W   #$00000001,D1
L0000D308               ADD.W   #$00000001,D0
L0000D30A               CMP.W   #$0009,D0
L0000D30E               BNE.B   L0000D302 
L0000D310               CLR.W   L0000DC0E
L0000D316               RTS 


L0000D318               LEA.L   L0000D36C,A0
L0000D31E               LEA.L   L0000D37C,A1
L0000D324               MOVE.W  L0000D84A,D0
L0000D32A               BSR.W   L0000D33E
L0000D32E               MOVE.W  L0000D848,D0
L0000D334               BSR.W   L0000D33E
L0000D338               MOVE.W  L0000D846,D0
L0000D33E               MOVE.W  D0,D1
L0000D340               SUB.W   #$0001,D1
L0000D344               ASL.W   #$00000001,D1
L0000D346               MOVE.W  $00(A0,D1.w),L0000E122
L0000D34E               MOVE.W  $00(A1,D1.w),L0000E126
L0000D356               MOVE.W  D0,L0000E154
L0000D35C               MOVEM.L D0-D1/A0-A1,-(A7)
L0000D360               BSR.W   L0000DE94
L0000D364               MOVEM.L (A7)+,D0-D1/A0-A1
L0000D368               LSR.W   #$00000001,D1
L0000D36A               RTS 



L0000D36C               dc.w    $001C,$001C,$001C,$001C,$0126,$0126,$0126,$0127  
L0000D37C               dc.w    $0005,$002A,$004E,$0074,$0005,$002A,$004F,$0073  
L0000D38C               dc.w    $33FC,$4180,$00DF,$F100 



L0000D394               MOVE.W  #$0040,$00dff104
L0000D39C               MOVE.L  #$003800d0,$00dff092
L0000D3A6               MOVE.L  #$2c81f4c1,$00dff08e
L0000D3B0               MOVE.L  #$ffffffff,$00dff044
L0000D3BA               CLR.L   L0000DBFC
L0000D3C0               CLR.W   L0000DC00
L0000D3C6               CLR.L   L0000DC02
L0000D3CC               CLR.W   L0000EE04
L0000D3D2               MOVE.W  #$0003,L0000DBFA
L0000D3DA               MOVE.W  #$0001,L0000DC06
L0000D3E2               MOVE.W  #$0073,L0000D8D8
L0000D3EA               MOVE.W  #$0006,L0000DC00
L0000D3F2               MOVE.W  #$0018,L0000E124
L0000D3FA               MOVE.W  #$0012,L0000E128
L0000D402               LEA.L   game_screen_palette,a0          ; L0000F6CE,A0
L0000D408               LEA.L   copper_screen_palette,A1        ; L0000FBE6,A1
L0000D40E               BSR.W   L0000D206
L0000D412               MOVE.L  #$00001a20,L0000DC14            ; offset/address?
L0000D41C               MOVE.L  #$0005ed00,L0000DC18            ; external address (display?)
L0000D426               MOVE.W  #$002c,L0000EE00
L0000D42E               BSR.W   L0000D4F4
L0000D432               BSR.W   L0000D2F0
L0000D436               BSR.W   L0000D462
L0000D43A               MOVE.W  #$0059,D0
L0000D43E               JSR     PANEL_INIT_TIMER                    ; $0007c80e ; panel
L0000D444               MOVE.W  #$9999,PANEL_TIMER_UPDATE_VALUE     ; $0007c882 ; panel
L0000D44C               JSR     PANEL_INIT_ENERGY                   ; $0007c854 ; panel
L0000D452               CLR.L   L0000D846
L0000D458               CLR.W   L0000D84A
L0000D45E               BRA.W   L0000E110 
                            ;------------------------------------

L0000D462               CLR.L   L0000D840
L0000D468               CLR.W   L0000D844
L0000D46E               BSR.W   L0000D48E
L0000D472               MOVE.W  D0,L0000D840
L0000D478               BSR.W   L0000D48E
L0000D47C               MOVE.W  D0,L0000D842
L0000D482               BSR.W   L0000D48E
L0000D486               MOVE.W  D0,L0000D844
L0000D48C               RTS 


L0000D48E               BSR.W   L0000D516
L0000D492               MOVE.W  L0000D54A,D0
L0000D498               AND.W   #$0007,D0
L0000D49C               MOVE.L  #$00000000,D7
L0000D49E               BSR.W   L0000D8F4
L0000D4A2               TST.W   D7
L0000D4A4               BNE.B   L0000D48E 
L0000D4A6               RTS 


                ; ------------ unreferenced code? --------------
                ; some unknown address ranges accessed in here
L0000D4A8               LEA.L   $0001fffa,A0                ; gfx?
L0000D4AE               LEA.L   $0005ed00,A1                ; display buffer?
L0000D4B4               LEA.L   $000231d2,A2
L0000D4BA               LEA.L   $00060720,A3
L0000D4C0               LEA.L   $000263aa,A4
L0000D4C6               LEA.L   $00062140,A5
L0000D4CC               MOVE.W  #$1a20,D0
L0000D4D0_loop          MOVE.B  (A0)+,(A1)+
L0000D4D2               MOVE.B  (A2)+,(A3)+
L0000D4D4               MOVE.B  (A4)+,(A5)+
L0000D4D6               DBF.W   D0,L0000D4D0_loop 
L0000D4DA               RTS 


                ; ------------ unreferenced code? --------------
                ; some unknown address ranges accessed in here
L0000D4DC               LEA.L   $00019588,A0                ; external address
L0000D4E2               LEA.L   $00063b66,A1                ; external address
L0000D4E8               MOVE.W  #$1a20,D0
L0000D4EC_loop          MOVE.B  (A0)+,(A1)+
L0000D4EE               DBF.W   D0,L0000D4EC_loop 
L0000D4F2               RTS 






L0000D4F4               LEA.L   L00010000,A0
L0000D4FA               LEA.L   $0005ed00,A1                ; external address
L0000D500               MOVE.W  #$1398,D0                   ; 5017*4 = 20068 bytes
L0000D504_loop          MOVE.L  (A0)+,(A1)+
L0000D506               DBF.W   D0,L0000D504_loop 
L0000D50A               MOVE.W  #$0688,D0
L0000D50E               CLR.L   (A1)+
L0000D510               DBF.W   D0,L0000D50E 
L0000D514               RTS 


L0000D516               MOVEM.L D0-D1/A0,-(A7)
L0000D51A               LEA.L   L0000D54C,A0
L0000D520               MOVE.B  $00bfe801,D0
L0000D526               MOVE.B  $00bfe901,D1
L0000D52C               EOR.W   D1,D0
L0000D52E               MOVE.W  D0,D1
L0000D530               AND.W   #$0007,D0
L0000D534               ASL.W   #$00000001,D0
L0000D536               EOR.W   D1,$00(A0,D0.w)
L0000D53A               MOVE.W  $00(A0,D0.w),D0
L0000D53E               MOVE.W  D0,L0000D54A
L0000D544               MOVEM.L (A7)+,D0-D1/A0
L0000D548               RTS 


L0000D54A               dc.w    $1164
L0000D54C               dc.w    $F051,$FFE0,$CF01,$337F,$FEEF,$0506,$0838
L0000D55A               dc.w    $0012



L0000D55C               BTST.B  #$0006,$00dff002
L0000D564               BNE.W   L0000D55C
L0000D568               RTS 



L0000D56A               TST.W   L0000DC02
L0000D570               BEQ.W   L0000D588 
L0000D574               MOVE.W  L0000DC0A,D0
L0000D57A               ADD.W   D0,L0000E128
L0000D580               SUB.W   #$0001,L0000DC02
L0000D588               TST.W   L0000DC04
L0000D58E               BEQ.W   L0000D5A6 
L0000D592               MOVE.W  L0000DC08,D0
L0000D598               ADD.W   D0,L0000E124
L0000D59E               SUB.W   #$0001,L0000DC04
L0000D5A6               RTS 



L0000D5A8               CLR.L   L0000DC10
L0000D5AE               CLR.W   L0000DC0C
L0000D5B4               MOVE.W  $00dff00c,D0
L0000D5BA               BTST.L  #$0001,D0
L0000D5BE               SNE.B   L0000DC10 
L0000D5C4               BTST.L  #$0009,D0
L0000D5C8               SNE.B   L0000DC11 
L0000D5CE               BTST.L  #$0000,D0
L0000D5D2               SNE.B   L0000DC12 
L0000D5D8               BTST.L  #$0008,D0
L0000D5DC               SNE.B   L0000DC13 
L0000D5E2               MOVE.B  L0000DC10,D1
L0000D5E8               EOR.B   D1,L0000DC12
L0000D5EE               MOVE.B  L0000DC11,D1
L0000D5F4               EOR.B   D1,L0000DC13
L0000D5FA               BTST.B  #$0007,$00bfe001
L0000D602               SEQ.B   L0000DC0C 
L0000D608               TST.W   L0000DC04
L0000D60E               BNE.B   L0000D636 
L0000D610               CLR.W   L0000DC08
L0000D616               TST.B   L0000DC10
L0000D61C               BEQ.B   L0000D626 
L0000D61E               MOVE.W  #$000a,L0000DC08
L0000D626               TST.B   L0000DC11
L0000D62C               BEQ.B   L0000D636 
L0000D62E               MOVE.W  #$fff6,L0000DC08
L0000D636               TST.W   L0000DC02
L0000D63C               BNE.B   L0000D664 
L0000D63E               CLR.W   L0000DC0A
L0000D644               TST.B   L0000DC12
L0000D64A               BEQ.B   L0000D654 
L0000D64C               MOVE.W  #$0004,L0000DC0A
L0000D654               TST.B   L0000DC13
L0000D65A               BEQ.B   L0000D664 
L0000D65C               MOVE.W  #$fffc,L0000DC0A
L0000D664               TST.W   L0000DC04
L0000D66A               BNE.B   L0000D6A4 
L0000D66C               TST.W   L0000DC08
L0000D672               BEQ.B   L0000D6A4 
L0000D674               BPL.W   L0000D690 
L0000D678               CMP.W   #$0080,L0000E124
L0000D680               BLT.W   L0000D6A4 
L0000D684               MOVE.W  #$001b,L0000DC04
L0000D68C               BRA.W   L0000D6A4 

L0000D690               CMP.W   #$0080,L0000E124
L0000D698               BGT.W   L0000D6A4 
L0000D69C               MOVE.W  #$001b,L0000DC04
L0000D6A4               TST.W   L0000DC02
L0000D6AA               BNE.B   L0000D6EE 
L0000D6AC               TST.W   L0000DC0A
L0000D6B2               BEQ.B   L0000D6EE 
L0000D6B4               BPL.W   L0000D6D0 
L0000D6B8               CMP.W   #$0020,L0000E128
L0000D6C0               BLT.W   L0000D6EE 
L0000D6C4               SUB.W   #$0001,L0000DC06
L0000D6CC               BRA.W   L0000D6E4 

L0000D6D0               CMP.W   #$0071,L0000E128
L0000D6D8               BGT.W   L0000D6EE 
L0000D6DC               ADD.W   #$0001,L0000DC06
L0000D6E4               MOVE.W  #$0009,L0000DC02
L0000D6EC               RTS 




L0000D6EE               MOVE.W  L0000DC08,D0
L0000D6F4               OR.W    L0000DC0A,D0
L0000D6FA               OR.W    L0000DC04,D0
L0000D700               OR.W    L0000DC02,D0
L0000D706               BNE.W   L0000DBA4 
L0000D70A               TST.W   L0000DC0C
L0000D710               BEQ.W   L0000DBEA 
L0000D714               TST.W   L0000DC0E
L0000D71A               BNE.W   L0000DBA4 
L0000D71E               LEA.L   L0000D846,A2
L0000D724               LEA.L   L0000D7EC,A0
L0000D72A               LEA.L   L0000D816,A1
L0000D730               MOVE.W  L0000DBFC,D2
L0000D736               MOVE.W  L0000DBFE,D1
L0000D73C               BSR.W   L0000D84C
L0000D740               MOVE.L  #$00000000,D7
L0000D742               MOVE.W  L0000E154,D0
L0000D748               BSR.W   L0000D912
L0000D74C               TST.W   D7
L0000D74E               BNE.W   L0000D7EA 
L0000D752               MOVE.W  L0000E154,$00(A2,D1.w)
L0000D75A               MOVE.W  $00(A0,D2.w),L0000E122
L0000D762               MOVE.W  $00(A1,D2.w),L0000E126
L0000D76A               BSR.W   L0000DE94
L0000D76E               MOVE.L  #$00000005,D0
L0000D770               JSR     L00004014
L0000D776               BSR.W   L0000DBA6
L0000D77A               SUB.W   #$0001,L0000DBFA
L0000D782               BNE.W   L0000D7D4 
L0000D786               BSR.W   L0000D86A
L0000D78A               CMP.B   #$33,L0000D8D6          ; display char
L0000D792               BNE.B   L0000D798 
L0000D794               BRA.W   L0000D930 


L0000D798               MOVE.L  #$00000006,D0
L0000D79A               JSR     L00004014
L0000D7A0               SUB.W   #$0001,L0000DC00
L0000D7A8               BPL.W   L0000D7B0 
L0000D7AC               BRA.W   L0000D9E6 


L0000D7B0               MOVE.L  #$00000006,D0
L0000D7B2               JSR     PANEL_LOSE_ENERGY       ; $0007c870 ; Panel
L0000D7B8               MOVE.W  #$0003,L0000DBFA
L0000D7C0               MOVE.W  #$fffe,L0000DBFE
L0000D7C8               CLR.L   L0000D846
L0000D7CE               CLR.W   L0000D84A
L0000D7D4               NOT.W   L0000DC0E
L0000D7DA               ADD.W   #$0002,L0000DBFC
L0000D7E2               ADD.W   #$0002,L0000DBFE
L0000D7EA               RTS 



L0000D7EC               dc.w    $0068,$0068,$0068,$007B,$007B,$007B,$008E,$008E
L0000D7FC               dc.w    $008E,$00A1,$00A1,$00A1,$00B4,$00B4,$00B4,$00C7
L0000D80C               dc.w    $00C7,$00C7,$00DA,$00DA,$00DA

L0000D816               dc.w    $0013,$0031,$004F
L0000D81C               dc.w    $0013,$0031,$004F,$0013,$0031,$004F,$0013,$0031
L0000D82C               dc.w    $004F,$0013,$0031,$004F,$0013,$0031,$004F,$0013
L0000D83C               dc.w    $0031,$004F
L0000D840               dc.w    $0001
L0000D842               dc.w    $0002
L0000D844               dc.w    $0003
L0000D846               dc.w    $0000
L0000D848               dc.w    $0000
L0000D84A               dc.w    $0000




L0000D84C               MOVE.W  L0000DC06,L0000E154
L0000D856               CMP.W   #$0080,L0000E124
L0000D85E               BLT.B   L0000D868 
L0000D860               ADD.W   #$0004,L0000E154
L0000D868               RTS 



L0000D86A               BSR.W   L0000D318
L0000D86E               CLR.W   L0000DC0E
L0000D874               MOVE.B  #$30,D7
L0000D878               BSR.W   L0000D8DA
L0000D87C               MOVE.B  D7,L0000D8D6            ; display char
L0000D882               MOVE.L  #$00000000,D0
L0000D884               MOVE.B  D7,D0
L0000D886               SUB.B   #$30,D0
L0000D88A               ASL.L   #$00000008,D0
L0000D88C               JSR     PANEL_ADD_SCORE         ; $0007c82a ; Panel
L0000D892               NOT.W   L0000EE04
L0000D898               MOVE.L  #debug_typer_buffer,debug_display_buffer_ptr     ; #L0000F68E,L0000EDFC
L0000D8A2               LEA.L   L0000D8D4,A6
L0000D8A8               BSR.W   debug_text_typer        ; L0000E382 
L0000D8AC               MOVE.W  #$0009,L0000E154
L0000D8B4               MOVE.W  L0000D8D8,L0000E122
L0000D8BE               MOVE.W  #$006e,L0000E126
L0000D8C6               BSR.W   L0000DE94
L0000D8CA               ADD.W   #$0013,L0000D8D8
L0000D8D2               RTS 

                        ; display characters (x,y,char,$ff)
L0000D8D4               dc.w    $0000
L0000D8D6               dc.w    $30ff
L0000D8D8               dc.w    $0073 


L0000D8DA               MOVE.W  L0000D846,D0
L0000D8E0               BSR.W   L0000D8F4
L0000D8E4               MOVE.W  L0000D848,D0
L0000D8EA               BSR.W   L0000D8F4
L0000D8EE               MOVE.W  L0000D84A,D0
L0000D8F4               CMP.W   L0000D840,D0
L0000D8FA               BEQ.B   L0000D90E 
L0000D8FC               CMP.W   L0000D842,D0
L0000D902               BEQ.B   L0000D90E 
L0000D904               CMP.W   L0000D844,D0
L0000D90A               BEQ.B   L0000D90E 
L0000D90C               RTS 


L0000D90E               ADD.W   #$00000001,D7
L0000D910               RTS 


L0000D912               CMP.W   L0000D846,D0
L0000D918               BEQ.B   L0000D92C 
L0000D91A               CMP.W   L0000D848,D0
L0000D920               BEQ.B   L0000D92C 
L0000D922               CMP.W   L0000D84A,D0
L0000D928               BEQ.B   L0000D92C 
L0000D92A               RTS 
L0000D92C               ADD.W   #$00000001,D7
L0000D92E               RTS 


L0000D930               MOVE.W  #$000d,D3
L0000D934               BSR.W   L0000DAAA
L0000D938               MOVE.L  #$00000002,D0
L0000D93A               JSR     L00004010
L0000D940               MOVE.L  #$00000000,D0
L0000D942               MOVE.W  PANEL_TIMER_VALUE,D0                ; $0007c884,D0 ; Panel
L0000D948               ASL.L   #$00000008,D0
L0000D94A               ASL.L   #$00000004,D0
L0000D94C               JSR     PANEL_ADD_SCORE                     ; $0007c82a ; Panel
L0000D952               MOVE.W  #$ffff,level_status                 ; L0000D0C8 - level completed

L0000D95A               MOVE.W  #$9999,PANEL_TIMER_UPDATE_VALUE     ; $0007c882 ; Panel
L0000D962               MOVE.W  #$00c8,D0               ; frames to wait/skip
L0000D966               BSR.W   wait_frame              ; L0000D1EE_loop
L0000D96A               MOVE.W  #$2260,D0
L0000D96E               LEA.L   $00067680,A0            ; external address
L0000D974               CLR.L   (A0)+
L0000D976               DBF.W   D0,L0000D974 
L0000D97A               MOVE.L  #$00067680,L0000E55E    ; external address
L0000D984               LEA.L   text_simlex_success,a0  ; L0000E680,A0
L0000D98A               BSR.W   game_text_typer         ; L0000E6E4
L0000D98E               MOVE.L  #$0005ed00,L0000E55A    ; external address
L0000D998               MOVE.L  #$00067680,L0000E55E    ; external address
L0000D9A2               BSR.W   L0000E572
L0000D9A6               MOVE.W  #$00c8,D0               ; frames to wait/skip
L0000D9AA               BSR.W   wait_frame              ; L0000D1EE_loop
L0000D9AE               MOVE.L  #$0005ed00,L0000E55A    ; external address
L0000D9B8               MOVE.L  #$00067680,L0000E55A    ; external address
L0000D9C2               BSR.W   L0000E562
L0000D9C6               LEA.L   game_screen_palette,A0      ; L0000F6CE,A0
L0000D9CC               LEA.L   copper_screen_palette,a1    ; L0000FBE6,A1
L0000D9D2               BSR.W   L0000D206
L0000D9D6               BRA.W   L0000D112 


L0000D9DA               MOVE.W  #$0001,level_status     ; L0000D0C8 - level completed
L0000D9E2               BRA.W   L0000DA00 


L0000D9E6               MOVE.W  #$0080,D0
L0000D9EA               JSR     PANEL_LOSE_ENERGY       ; $0007c870 ; Panel
L0000D9F0               MOVE.W  #$000b,D3
L0000D9F4               BSR.W   L0000DAAA
L0000D9F8               MOVE.L  #$00000003,D0
L0000D9FA               JSR     L00004010
L0000DA00               MOVE.W  #$9999,PANEL_TIMER_UPDATE_VALUE     ; $0007c882 ; Panel
L0000DA08               MOVE.W  #$00c8,D0               ; frames to wait/skip
L0000DA0C               BSR.W   wait_frame              ; L0000D1EE_loop

L0000DA10               MOVE.W  #$2260,D0
L0000DA14               LEA.L   $00067680,A0            ; External Address
L0000DA1A               CLR.L   (A0)+
L0000DA1C               DBF.W   D0,L0000DA1A 
L0000DA20               MOVE.L  #$00067680,L0000E55E    ; external address
L0000DA2A               BTST.B  #PANEL_ST1_TIMER_EXPIRED,PANEL_STATUS_1   ; #$0000,$0007c874        ; Panel
L0000DA32               BNE.B   L0000DA54 
L0000DA34               BTST.B  #PANEL_ST1_NO_LIVES_LEFT,PANEL_STATUS_1   ; #$0001,$0007c874        ; Panel
L0000DA3C               BNE.B   L0000DA42 
L0000DA3E               BRA.W   L0000DA7E 

L0000DA42               MOVE.L  #$00000004,D0
L0000DA44               JSR     L00004010               ; Panel
L0000DA4A               LEA.L   text_game_over,a0       ; L0000E6D6,A0
L0000DA50               BRA.W   L0000DA5A 


L0000DA54               LEA.L   text_time_out,a0        ; L0000E6CA,A0
L0000DA5A               BSR.W   game_text_typer         ; L0000E6E4
L0000DA5E               MOVE.L  #$0005ed00,L0000E55A    ; external address
L0000DA68               MOVE.L  #$00067680,L0000E55E    ; external address
L0000DA72               BSR.W   L0000E572
L0000DA76               MOVE.W  #$00c8,D0               ; frames to wait/skip
L0000DA7A               BSR.W   wait_frame              ; L0000D1EE_loop
L0000DA7E               MOVE.L  #$0005ed00,L0000E55A    ; external address
L0000DA88               MOVE.L  #$00067680,L0000E55E    ; external address
L0000DA92               BSR.W   L0000E562
L0000DA96               LEA.L   game_screen_palette,A0      ; L0000F6CE,A0
L0000DA9C               LEA.L   copper_screen_palette,A1    ; L0000FBE6,A1
L0000DAA2               BSR.W   L0000D206
L0000DAA6               BRA.W   L0000D112 


L0000DAAA               MOVE.W  #$9999,PANEL_TIMER_UPDATE_VALUE     ; $0007c882 ; Panel
L0000DAB2               BSR.W   L0000E110
L0000DAB6               MOVE.W  #$0025,D0               ; frames to wait/skip
L0000DABA               BSR.W   wait_frame              ; L0000D1EE_loop
L0000DABE               BSR.W   L0000D4F4
L0000DAC2               LEA.L   L0000D36C,A0
L0000DAC8               LEA.L   L0000DB52,A1
L0000DACE               MOVE.L  #$00000000,D2
L0000DAD0               MOVE.W  #$0005,D0               ; frames to wait/skip
L0000DAD4               BSR.W   wait_frame              ; L0000D1EE_loop
L0000DAD8               BSR.W   L0000DB2E
L0000DADC               ADD.W   #$00000002,D2
L0000DADE               CMP.W   #$0012,D2
L0000DAE2               BNE.B   L0000DAD0 
L0000DAE4               MOVE.W  #$0004,D0               ; frames to wait/skip
L0000DAE8               BSR.W   wait_frame              ; L0000D1EE_loop
L0000DAEC               ADD.W   #$0001,D3
L0000DAF0               CMP.W   #$000c,D3
L0000DAF4               BNE.B   L0000DB0A 
L0000DAF6               MOVE.W  #$008e,L0000E122
L0000DAFE               MOVE.W  #$0010,L0000E126
L0000DB06               BRA.W   L0000DB1A 


L0000DB0A               MOVE.W  #$007d,L0000E122
L0000DB12               MOVE.W  #$002d,L0000E126
L0000DB1A               MOVE.W  D3,L0000E154
L0000DB20               BSR.W   L0000DE94
L0000DB24               RTS 


L0000DB26               MOVE.W  #$0060,D0               ; frames to wait/skip
L0000DB2A               BRA.W   wait_frame              ; L0000D1EE_loop 
L0000DB2E               MOVE.W  $00(A0,D2.w),L0000E122
L0000DB36               MOVE.W  $00(A1,D2.w),L0000E126
L0000DB3E               MOVE.W  D3,L0000E154
L0000DB44               MOVEM.L D2-D3/A0-A1,-(A7)
L0000DB48               BSR.W   L0000DE94
L0000DB4C               MOVEM.L (A7)+,D2-D3/A0-A1
L0000DB50               RTS


L0000DB52               dc.w    $0005,$002A,$004E,$0074,$0073,$004F,$002A,$0005
L0000DB62               dc.w    $3039,$0000,$DC06


L0000DB68               MOVE.W  D0,D1
L0000DB6A               LEA.L   L0000DBF2,A0
L0000DB70               ADD.W   D0,D0
L0000DB72               MOVE.W  -2(A0,D0.W),L0000E126
L0000DB7A               MOVE.W  L0000E124,L0000E122
L0000DB84               ADD.W   #$0003,L0000E122
L0000DB8C               CMP.W   #$0080,L0000E124
L0000DB94               BLT.W   L0000DB9A 
L0000DB98               ADD.W   #$00000004,D1
L0000DB9A               MOVE.W  D1,L0000E154
L0000DBA0               BSR.W   L0000DE94
L0000DBA4               RTS 


L0000DBA6               MOVE.W  L0000DC06,D0
L0000DBAC               MOVE.W  D0,D1
L0000DBAE               LEA.L   L0000DBF2,A0
L0000DBB4               ADD.W   D0,D0
L0000DBB6               MOVE.W  -2(A0,D0.w),L0000E126
L0000DBBE               MOVE.W  L0000E124,L0000E122
L0000DBC8               ADD.W   #$0001,L0000E122
L0000DBD0               CMP.W   #$0080,L0000E124
L0000DBD8               BLT.W   L0000DBDE 
L0000DBDC               ADD.W   #$00000004,D1
L0000DBDE               MOVE.W  #$000a,L0000E154
L0000DBE6               BRA.W   L0000DE94 
L0000DBEA               CLR.W   L0000DC0E
L0000DBF0               RTS 


L0000DBF2               dc.w    $0005,$002A,$004F,$0074
L0000DBFA               dc.w    $0003
L0000DBFC               dc.w    $0000
L0000DBFE               dc.w    $0000
L0000DC00               dc.w    $0000
L0000DC02               dc.w    $0000
L0000DC04               dc.w    $0000
L0000DC06               dc.w    $0001
L0000DC08               dc.w    $0000
L0000DC0A               dc.w    $0000
L0000DC0C               dc.w    $0000
L0000DC0E               dc.w    $0000
L0000DC10               dc.b    $00
L0000DC11               dc.b    $00
L0000DC12               dc.b    $00
L0000DC13               dc.b    $00
L0000DC14               dc.w    $0000,$0000
L0000DC18               dc.w    $0000,$0000


L0000DC1C               MOVE.L  #$00001a20,L0000DC14        ; external address?
L0000DC26               MOVE.L  #$0005ed00,L0000DC18        ; external address?
L0000DC30               MOVE.W  #$002c,L0000EE00
L0000DC38               BSR.W   L0000DC46
L0000DC3C               BSR.W   L0000D5A8
L0000DC40               BSR.W   L0000DCDE
L0000DC44               RTS 




L0000DC46               LEA.L   L0000E13E,A1
L0000DC4C               LEA.L   L0000E146,A2
L0000DC52               LEA.L   L0000E132,A3
L0000DC58               LEA.L   L0000E14C,A4
L0000DC5E               LEA.L   L0000E152,A5
L0000DC64               CLR.W   L0000E142
L0000DC6A               CLR.L   L0000E136
L0000DC70               BSR.W   L0000D55C
L0000DC74               CLR.W   $00dff042
L0000DC7A               MOVE.W  #$09f0,$00dff040
L0000DC82               MOVE.W  #$0002,D7
L0000DC86_loop          MOVE.L  (A1),D2
L0000DC88               BEQ.W   L0000DCCE 
L0000DC8C               MOVE.W  (A2),D0
L0000DC8E               BEQ.B   L0000DCCE 
L0000DC90               MOVE.W  D0,D1
L0000DC92               AND.W   #$003f,D0
L0000DC96               ASL.W   #$00000001,D0
L0000DC98               LSR.W   #$00000006,D1
L0000DC9A               MULU.W  D1,D0
L0000DC9C               MOVE.L  (A3),D3
L0000DC9E               MOVE.L  #$00000003,D6
L0000DCA0_loop          BSR.W   L0000D55C
L0000DCA4               MOVE.L  D2,$00dff054
L0000DCAA               MOVE.L  D3,$00dff050
L0000DCB0               MOVE.W  (A4),$00dff066
L0000DCB6               MOVE.W  (A5),$00dff064
L0000DCBC               MOVE.W  (A2),$00dff058
L0000DCC2               ADD.L   D0,D3
L0000DCC4               ADD.L   L0000DC14,D2
L0000DCCA               DBF.W   D6,L0000DCA0_loop 
L0000DCCE               SUBA.L  #$00000004,A1
L0000DCD0               SUBA.L  #$00000002,A2
L0000DCD2               SUBA.L  #$00000004,A3
L0000DCD4               SUBA.L  #$00000002,A4
L0000DCD6               SUBA.L  #$00000002,A5
L0000DCD8               DBF.W   D7,L0000DC86_loop 
L0000DCDC               RTS 


L0000DCDE               BSR.W   L0000E110
L0000DCE2               MOVE.L  #$00073000,L0000E2C0        ; external address?
L0000DCEC               LEA.L   L0000E122,A0
L0000DCF2               LEA.L   L0000E136,A1
L0000DCF8               LEA.L   L0000E142,A2
L0000DCFE               LEA.L   L0000E12A,A3
L0000DD04               LEA.L   L0000E148,A4
L0000DD0A               LEA.L   L0000E14E,A5
L0000DD10               LEA.L   L0000E154,A6
L0000DD16               MOVE.W  #$0001,D7
L0000DD1A_loop          CLR.L   L0000E2E2
L0000DD20               CMP.W   #$0001,D7
L0000DD24               BEQ.W   L0000DE80 
L0000DD28               BSR.W   L0000DFB2
L0000DD2C               TST.W   (A2)
L0000DD2E               BEQ.W   L0000DE80 
L0000DD32               BSR.W   L0000D55C
L0000DD36               MOVE.W  #$09f0,$00dff040
L0000DD3E               CLR.W   $00dff066
L0000DD44               MOVE.W  (A4),$00dff064
L0000DD4A               MOVE.L  L0000E2C0,(A3)
L0000DD50               MOVE.L  L0000E2E2,D0
L0000DD56               BEQ.W   L0000DE80 
L0000DD5A               MOVE.L  D0,(A1)
L0000DD5C               MOVE.L  L0000E2CA,D2
L0000DD62               MOVE.L  #$00000003,D6
L0000DD64               BSR.W   L0000D55C
L0000DD68               MOVE.L  L0000E2C0,$00dff054
L0000DD72               MOVE.L  D0,$00dff050
L0000DD78               MOVE.W  (A2),$00dff058
L0000DD7E               ADD.L   D2,L0000E2C0
L0000DD84               ADD.L   L0000DC14,D0
L0000DD8A               DBF.W   D6,L0000DD64 
L0000DD8E               MOVE.W  #$0fca,D1
L0000DD92               OR.W    L0000E2E8,D1
L0000DD98               BSR.W   L0000D55C
L0000DD9C               MOVE.W  D1,$00dff040
L0000DDA2               MOVE.W  L0000E2E8,$00dff042
L0000DDAC               MOVE.L  L0000E2E2,D0
L0000DDB2               MOVE.L  L0000E2CE,$00dff04c
L0000DDBC               MOVE.L  L0000E2DE,$00dff050
L0000DDC6               MOVE.L  D0,$00dff048
L0000DDCC               MOVE.L  D0,$00dff054
L0000DDD2               CLR.W   $00dff064
L0000DDD8               CLR.W   $00dff062
L0000DDDE               MOVE.W  (A4),$00dff060
L0000DDE4               MOVE.W  (A4),$00dff066
L0000DDEA               MOVE.W  (A2),$00dff058
L0000DDF0               ADD.L   L0000DC14,D0
L0000DDF6               BSR.W   L0000D55C
L0000DDFA               MOVE.L  L0000E2D2,$00dff04c
L0000DE04               MOVE.L  L0000E2DE,$00dff050
L0000DE0E               MOVE.L  D0,$00dff048
L0000DE14               MOVE.L  D0,$00dff054
L0000DE1A_loop          MOVE.W  (A2),$00dff058
L0000DE20               ADD.L   L0000DC14,D0
L0000DE26               BSR.W   L0000D55C
L0000DE2A               MOVE.L  L0000E2D6,$00dff04c
L0000DE34               MOVE.L  L0000E2DE,$00dff050
L0000DE3E               MOVE.L  D0,$00dff048
L0000DE44               MOVE.L  D0,$00dff054
L0000DE4A               MOVE.W  (A2),$00dff058
L0000DE50               ADD.L   L0000DC14,D0
L0000DE56               BSR.W   L0000D55C
L0000DE5A               MOVE.L  L0000E2DA,$00dff04c
L0000DE64               MOVE.L  L0000E2DE,$00dff050
L0000DE6E               MOVE.L  D0,$00dff048
L0000DE74               MOVE.L  D0,$00dff054
L0000DE7A               MOVE.W  (A2),$00dff058
L0000DE80               ADDA.L  #$00000002,A0
L0000DE82               ADDA.L  #$00000004,A1
L0000DE84               ADDA.L  #$00000002,A2
L0000DE86               ADDA.L  #$00000004,A3
L0000DE88               ADDA.L  #$00000002,A4
L0000DE8A               ADDA.L  #$00000002,A5
L0000DE8C               ADDA.L  #$00000002,A6
L0000DE8E               DBF.W   D7,L0000DD1A_loop 
L0000DE92               RTS 



L0000DE94               LEA.L   L0000E122,A0
L0000DE9A               LEA.L   L0000E142,A2
L0000DEA0               LEA.L   L0000E12A,A3
L0000DEA6               LEA.L   L0000E148,A4
L0000DEAC               LEA.L   L0000E14E,A5
L0000DEB2               LEA.L   L0000E154,A6
L0000DEB8               MOVE.L  #$00000000,D7
L0000DEBA               BSR.W   L0000DFB2
L0000DEBE               MOVE.W  #$0fca,D1
L0000DEC2               OR.W    L0000E2E8,D1
L0000DEC8               MOVE.W  D1,$00dff040
L0000DECE               MOVE.W  L0000E2E8,$00dff042
L0000DED8               MOVE.L  L0000E2E2,D0
L0000DEDE               BEQ.W   L0000DE92 
L0000DEE2               MOVE.L  L0000E2CE,$00dff04c
L0000DEEC               MOVE.L  L0000E2DE,$00dff050
L0000DEF6               MOVE.L  D0,$00dff048
L0000DEFC               MOVE.L  D0,$00dff054
L0000DF02               CLR.W   $00dff064
L0000DF08               CLR.W   $00dff062
L0000DF0E               MOVE.W  (A4),$00dff060
L0000DF14               MOVE.W  (A4),$00dff066
L0000DF1A               MOVE.W  (A2),$00dff058
L0000DF20               ADD.L   L0000DC14,D0
L0000DF26               BSR.W   L0000D55C
L0000DF2A               MOVE.L  L0000E2D2,$00dff04c
L0000DF34               MOVE.L  L0000E2DE,$00dff050
L0000DF3E               MOVE.L  D0,$00dff048
L0000DF44               MOVE.L  D0,$00dff054
L0000DF4A               MOVE.W  (A2),$00dff058
L0000DF50               ADD.L   L0000DC14,D0
L0000DF56               BSR.W   L0000D55C
L0000DF5A               MOVE.L  L0000E2D6,$00dff04c
L0000DF64               MOVE.L  L0000E2DE,$00dff050
L0000DF6E               MOVE.L  D0,$00dff048
L0000DF74               MOVE.L  D0,$00dff054
L0000DF7A               MOVE.W  (A2),$00dff058
L0000DF80               ADD.L   L0000DC14,D0
L0000DF86               BSR.W   L0000D55C
L0000DF8A               MOVE.L  L0000E2DA,$00dff04c
L0000DF94               MOVE.L  L0000E2DE,$00dff050
L0000DF9E               MOVE.L  D0,$00dff048
L0000DFA4               MOVE.L  D0,$00dff054
L0000DFAA               MOVE.W  (A2),$00dff058
L0000DFB0               RTS 



L0000DFB2               MOVE.L  #$00000000,D0
L0000DFB4               MOVE.W  L0000EE00,(A4)
L0000DFBA               MOVEM.L A0,-(A7)
L0000DFBE               MOVE.W (A6),D0
L0000DFC0               MULU.W  #$0018,D0
L0000DFC4               LEA.L   L0000E158,A0            ; 24 bytes struct (6 longs)
L0000DFCA               MOVE.L  $00(A0,D0.l),L0000E2C6
L0000DFD2               MOVE.L  $04(A0,D0.l),L0000E2CE
L0000DFDA               MOVE.L  $08(A0,D0.l),L0000E2D2
L0000DFE2               MOVE.L  $0c(A0,D0.l),L0000E2D6
L0000DFEA               MOVE.L  $10(A0,D0.l),L0000E2DA
L0000DFF2               MOVE.L  $14(A0,D0.l),L0000E2DE
L0000DFFA               MOVEM.L (A7)+,A0
L0000DFFE               MOVE.W  (A0),D0
L0000E000               MOVE.W  D0,D2
L0000E002               AND.W   #$000f,D2
L0000E006               LSR.W   #$00000003,D0
L0000E008               MOVE.W  $0004(A0),D1
L0000E00C               ADD.W   #$0100,D1
L0000E010               EXT.W   D0
L0000E012               ADD.W   #$0100,D0
L0000E016               MOVE.W  L0000E2C8,D4
L0000E01C               MOVE.W  D1,D3
L0000E01E               CMP.W   #$0197,D3
L0000E022               BGT.W   L0000E03A 
L0000E026               ADD.W   D4,D3
L0000E028               CMP.W   #$0197,D3
L0000E02C               BLT.W   L0000E042 
L0000E030               SUB.W   #$0197,D3
L0000E034               SUB.W   D3,D4
L0000E036               BEQ.B   L0000E03A 
L0000E038               BPL.B   L0000E042 
L0000E03A               CLR.L   L0000E2E2
L0000E040               RTS 



L0000E042               CMP.W   #$0100,D1
L0000E046               BGT.W   L0000E08C 
L0000E04A               MOVE.W  D1,D3
L0000E04C               ADD.W   D4,D3
L0000E04E               SUB.W   #$0100,D3
L0000E052               BMI.W   L0000E03A 
L0000E056               MOVE.W  D3,D4
L0000E058               BEQ.W   L0000E03A 
L0000E05C               SUB.W   L0000E2C8,D3
L0000E062               NEG.W   D3
L0000E064               MULU.W  L0000E2C6,D3
L0000E06A               ADD.L   D3,L0000E2CE
L0000E070               ADD.L   D3,L0000E2D2
L0000E076               ADD.L   D3,L0000E2D6
L0000E07C               ADD.L   D3,L0000E2DA
L0000E082               ADD.L   D3,L0000E2DE
L0000E088               MOVE.W  #$0100,D1
L0000E08C               CLR.W   (A5)
L0000E08E               CMP.W   #$0130,D0
L0000E092               BGT.W   L0000E03A 
L0000E096               CMP.W   #$0100,D0
L0000E09A               BGT.W   L0000E0AE 
L0000E09E               MOVE.W  D0,D3
L0000E0A0               SUB.W   #$0100,D3
L0000E0A4               BMI.W   L0000E03A 
L0000E0A8               NOP 
L0000E0AA               MOVE.W  #$0100,D0
L0000E0AE               MOVE.W  D0,D3
L0000E0B0               ADD.W   L0000E2C6,D3
L0000E0B6               CMP.W   #$0130,D3
L0000E0BA               BLT.W   L0000E0C2 
L0000E0BE               BRA.W   L0000E03A 


L0000E0C2               MOVE.W  L0000E2C6,D6
L0000E0C8               SUB.W   D6,(A4)
L0000E0CA               SUB.W   #$0100,D0
L0000E0CE               SUB.W   #$0100,D1
L0000E0D2               MULU.W  L0000EE00,D1
L0000E0D8               ADD.L   D1,D0
L0000E0DA               MOVE.L  L0000DC18,D1
L0000E0E0               ADD.L   D0,D1
L0000E0E2               MOVE.L  D1,L0000E2E2
L0000E0E8               ASL.W   #$00000008,D2
L0000E0EA               ASL.W   #$00000004,D2
L0000E0EC               MOVE.W  D2,L0000E2E8
L0000E0F2               MOVE.W  L0000E2C6,D5
L0000E0F8               MULU.W  D4,D5
L0000E0FA               MOVE.L  D5,L0000E2CA
L0000E100               MOVE.W  L0000E2C6,D5
L0000E106               LSR.W   #$00000001,D5
L0000E108               ASL.W   #$00000006,D4
L0000E10A               OR.W    D4,D5
L0000E10C               MOVE.W  D5,(A2)
L0000E10E               RTS 


                    ; ------ clear 3 words @ $E142 -----
L0000E110               LEA.L   L0000E142,A0
L0000E116               MOVE.W  #$0002,D7
L0000E11A_loop          CLR.W   (A0)+
L0000E11C               DBF.W   D7,L0000E11A_loop 
L0000E120               RTS 



L0000E122               dc.w    $0000
L0000E124               dc.w    $0018
L0000E126               dc.w    $0000
L0000E128               dc.w    $0012

L0000E12A               dc.w    $0000,$0000
L0000E12E               dc.w    $0000,$0000
L0000E132               dc.w    $0000,$0000
L0000E136               dc.w    $0000,$0000,$0000,$0000
L0000E13E               dc.w    $0000,$0000

L0000E142               dc.w    $0000,$0000
L0000E146               dc.w    $0000

L0000E148               dc.w    $0000,$0000
L0000E14C               dc.w    $0000
L0000E14E               dc.w    $0000,$0000
L0000E152               dc.w    $0000
L0000E154               dc.w    $0000,$0000

                        ; ; 24 bytes struct (6 longs)
L0000E158               dc.w    $0008,$0055
                        dc.w    $0001,$64C0
                        dc.w    $0001,$6770
                        dc.w    $0001,$6A20
                        dc.w    $0001,$6CD0
                        dc.w    $0001,$6F80

L0000E170                dc.w    $0006
L0000E172                dc.w    $001E,$0001,$4E40,$0001,$4EF4,$0001,$4FA8,$0001
L0000E182                dc.w    $505C,$0000,$F5DA,$0006,$001E,$0001,$5110,$0001
L0000E192                dc.w    $51C4,$0001,$5278,$0001,$532C,$0000,$F5DA,$0006
L0000E1A2                dc.w    $001E,$0001,$53E0,$0001,$5494,$0001,$5548,$0001
L0000E1B2                dc.w    $55FC,$0000,$F5DA,$0006,$001E,$0001,$56B0,$0001
L0000E1C2                dc.w    $5764,$0001,$5818,$0001,$58CC,$0000,$F5DA,$0006
L0000E1D2                dc.w    $001E,$0001,$5980,$0001,$5A34,$0001,$5AE8,$0001
L0000E1E2                dc.w    $5B9C,$0000,$F5DA,$0006,$001E,$0001,$5C50,$0001
L0000E1F2                dc.w    $5D04,$0001,$5DB8,$0001,$5E6C,$0000,$F5DA,$0006
L0000E202                dc.w    $001E,$0001,$5F20,$0001,$5FD4,$0001,$6088,$0001
L0000E212                dc.w    $613C,$0000,$F5DA,$0006,$001E,$0001,$61F0,$0001
L0000E222                dc.w    $62A4,$0001,$6358,$0001,$640C,$0000,$F5DA,$0004
L0000E232                dc.w    $0008,$0000,$F6CE,$0000,$F68E,$0000,$F68E,$0000
L0000E242                dc.w    $F6CE,$0000,$F6AE,$0006,$001E,$0000,$F6CE,$0000
L0000E252                dc.w    $F6CE,$0000,$F6CE,$0000,$F6CE,$0000,$F5DA,$0006
L0000E262                dc.w    $001E,$0001,$7230,$0001,$72E4,$0001,$7398,$0001
L0000E272                dc.w    $744C,$0000,$F5DA,$000C,$0068,$0001,$7500,$0001
L0000E282                dc.w    $79EC,$0001,$7ED8,$0001,$83C4,$0000,$EF9A,$0006
L0000E292                dc.w    $001E,$0001,$88B0,$0001,$8964,$0001,$8A18,$0001
L0000E2A2                dc.w    $8ACC,$0000,$F5DA,$000C,$0027,$0001,$8B80,$0001
L0000E2B2                dc.w    $8D60,$0001,$8F40,$0001,$9120,$0000,$EF9A

L0000E2C0               dc.w    $0000
L0000E2C2               dc.w    $0000,$0000
L0000E2C6               dc.w    $0000
L0000E2C8               dc.w    $0000
L0000E2CA               dc.w    $0000,$0000
L0000E2CE               dc.w    $0000,$0000
L0000E2D2               dc.w    $0000,$0000
L0000E2D6               dc.w    $0000,$0000
L0000E2DA               dc.w    $0000,$0000
L0000E2DE               dc.w    $0000,$0000

L0000E2E2               dc.w    $0000,$0000,$0000
L0000E2E8               dc.w    $0000  

L0000E2EA               RTS     ; 4e75


L0000E2EC               MOVEM.L D0-D7/A0-A6,-(A7)
L0000E2F0               BSR.W   L0000E312
L0000E2F4               MOVEM.L (A7)+,D0-D7/A0-A6
L0000E2F8               RTS 


L0000E2FA               ADD.W   #$0001,D0
L0000E2FE               BRA.W   L0000E2FA 

                        ; text to type
L0000E302               dc.w    $0000                       ; x,y co-ords
L0000E304               dc.w    $3030,$3030,$FF00           ; debug value to print '0000' - last $00 maybe pad byte
L0000E30A               dc.w    $0000 


                ; ----------- debug text display ------------
                ; write a debug value into the panel area
                ;
L0000E30C               CLR.W   L0000E30A
L0000E312               MOVE.L  #PANEL_GFX,L0000EDFC        ; $0007c89a panel
L0000E31C               LEA.L   L0000E304,A6
L0000E322               LEA.L   L0000E36E,A5                ; array of characters 0-9A-F
L0000E328               MOVE.W  D1,L0000E302
L0000E32E               MOVE.W  D0,D1
L0000E330               LSR.W   #$00000008,D0
L0000E332               LSR.W   #$00000004,D0
L0000E334               MOVE.B  $00(A5,D0.w),D2
L0000E338               MOVE.B  D2,(A6)+
L0000E33A               MOVE.W  D1,D0
L0000E33C               LSR.W   #$00000008,D0
L0000E33E               AND.W   #$000f,D0
L0000E342               MOVE.B  $00(A5,D0.w),D2
L0000E346               MOVE.B  D2,(A6)+
L0000E348               MOVE.W  D1,D0
L0000E34A               LSR.W   #$00000004,D0
L0000E34C               AND.W   #$000f,D0
L0000E350               MOVE.B  $00(A5,D0.w),D2
L0000E354               MOVE.B  D2,(A6)+
L0000E356               MOVE.W  D1,D0
L0000E358               AND.W   #$000f,D0
L0000E35C               MOVE.B  $00(A5,D0.w),D2
L0000E360               MOVE.B  D2,(A6)+
L0000E362               LEA.L   L0000E302,A6
L0000E368               BRA.W   debug_text_typer            ; L0000E382
L0000E36C               RTS 

                        ; convert hex to ascii routine above
L0000E36E               dc.w    $3031,$3233,$3435,$3637,$3839,$4142,$4344,$4546     ;0123456789ABCDEF
                        even
                        ; text typer co-ords
L0000E37E               dc.b    $00     ; x co-ord word (combined with below byte)
L0000E37F               dc.b    $00     ; x co-ord byte (char 8 pixel resolution)
L0000E380               dc.b    $00     ; y co-ord byte (line 1 pixel resolution) 
                        dc.b    $00     ; unused/pad byte



                    ; IN:-
                    ;   A6.l = ptr to x,y co-ords as bytes
                    ;
debug_text_typer
L0000E382               MOVE.B  (A6)+,L0000E37F     ; byte x co-ord (byte resolution) - 8 pixels
L0000E388               MOVE.B  (A6)+,L0000E380     ; byte y co-ord (line resolution) - 1 pixel
L0000E38E               MOVE.L  #$00000000,D0
L0000E390               MOVE.L  #$00000000,D1
L0000E392               MOVE.B  L0000E380,D1
L0000E398               MULU.W  #$002c,D1           ; y co-ord? mult by 40
L0000E39C               ADD.W   L0000E37E,D1
L0000E3A2_loop          MOVE.B  (A6)+,D0
L0000E3A4               AND.W   #$00ff,D0
L0000E3A8               CMP.B   #$ff,D0
L0000E3AC               BEQ.W   L0000E4E0 
L0000E3B0               AND.W   #$00ff,D0
L0000E3B4               CMP.B   #$20,D0             ; space
L0000E3B8               BEQ.W   L0000E3F4 
L0000E3BC               CMP.B   #$2f,D0             ; /
L0000E3C0               BLE.W   L0000E408 
L0000E3C4               CMP.B   #$39,D0             ; 9
L0000E3C8               BLE.W   L0000E3F4 
L0000E3CC               CMP.B   #$40,D0             ; @
L0000E3D0               BLE.W   L0000E3F4 
L0000E3D4               CMP.B   #$5c,D0             ; \
L0000E3D8               BLE.W   L0000E3FC 
L0000E3DC               CMP.B   #$60,D0             ; ` (61 = a)
L0000E3E0               BLE.W   L0000E408 
L0000E3E4               CMP.B   #$7a,D0             ; z
L0000E3E8               BGT.W   L0000E408 
L0000E3EC               SUB.B   #$60,D0             ; ` (61 = a)
L0000E3F0               BRA.W   L0000E40C 

L0000E3F4               AND.W   #$003f,D0           
L0000E3F8               BRA.W   L0000E40C 

L0000E3FC               AND.W   #$003f,D0
L0000E400               ADD.W   #$0040,D0
L0000E404               BRA.W   L0000E40C 

L0000E408               MOVE.B  #$00,D0             ; '/' = first character

L0000E40C               ASL.W   #$00000003,D0       ; divide by 8
L0000E40E               LEA.L   L00019300,A0        ; font gfx address?
L0000E414               ADDA.W  D0,A0
L0000E416               MOVEA.L L0000EDFC,A1        ; destination display buffer 
L0000E41C               TST.W   L0000EE04           ; 1 = 4 byte per line buffer, 0 = 40 byte per line buffer
L0000E422               BNE.B   L0000E482 
                        ; do 40 bytes per line destination buffer
L0000E424               MOVE.B  (A0),$00(A1,D1.w)
L0000E428               ADDA.L  #$0000002c,A1
L0000E42E               MOVE.B  $01(A0),$00(A1,D1.w)
L0000E434               ADDA.L  #$0000002c,A1
L0000E43A               MOVE.B  $02(A0),$00(A1,D1.w)
L0000E440               ADDA.L  #$0000002c,A1
L0000E446               MOVE.B  $03(A0),$00(A1,D1.w)
L0000E44C               ADDA.L  #$0000002c,A1
L0000E452               MOVE.B  $04(A0),$00(A1,D1.w)
L0000E458               ADDA.L  #$0000002c,A1
L0000E45E               MOVE.B  $05(A0),$00(A1,D1.w)
L0000E464               ADDA.L  #$0000002c,A1
L0000E46A               MOVE.B  $06(A0),$00(A1,D1.w)
L0000E470               ADDA.L  #$0000002c,A1
L0000E476               MOVE.B  $07(A0),$00(A1,D1.w)
L0000E47C               ADD.L   #$00000001,D1
L0000E47E               BRA.W   L0000E3A2_loop              ; next char

                        ; do 4 bytes per line destination buffer
L0000E482               MOVE.B  (A0),$00(A1,D1.w)
L0000E486               ADDA.L  #$00000004,A1
L0000E48C               MOVE.B  $01(A0),$00(A1,D1.w)
L0000E492               ADDA.L  #$00000004,A1
L0000E498               MOVE.B  $02(A0),$00(A1,D1.w)
L0000E49E               ADDA.L  #$00000004,A1
L0000E4A4               MOVE.B  $03(A0),$00(A1,D1.w)
L0000E4AA               ADDA.L  #$00000004,A1
L0000E4B0               MOVE.B  $04(A0),$00(A1,D1.w)
L0000E4B6               ADDA.L  #$00000004,A1
L0000E4BC               MOVE.B  $05(A0),$00(A1,D1.w)
L0000E4C2               ADDA.L  #$00000004,A1
L0000E4C8               MOVE.B  $06(A0),$00(A1,D1.w)
L0000E4CE               ADDA.L  #$00000004,A1
L0000E4D4               MOVE.B  $07(A0),$00(A1,D1.w)
L0000E4DA               ADD.L   #$00000001,D1
L0000E4DC               BRA.W   L0000E3A2_loop              ; next_char



L0000E4E0               MOVE.L  #PANEL_GFX,L0000EDFC        ; $0007c89a panel
L0000E4EA               CLR.W   L0000EE04
L0000E4F0               RTS 



L0000E4F2               LEA.L   $0005ed00,A0                ; external address
L0000E4F8               LEA.L   $00067680,A1                ; external address
L0000E4FE               MOVE.W  #$1a20,D0
L0000E502               MOVE.L  (A0),(A1)+
L0000E504               CLR.L   (A0)+
L0000E506               DBF.W   D0,L0000E502 
L0000E50A               MOVE.W  #$0688,D0
L0000E50E               CLR.L   (A0)+
L0000E510               DBF.W   D0,L0000E50E 
L0000E514               MOVE.L  #$00000000,D0
L0000E516               MOVE.L  #$0005ed00,L0000E55E        ; external address
L0000E520               LEA.L   text_bat_cave,A0            ; L0000E670,A0
L0000E526               BSR.W   game_text_typer             ; L0000E6E4
L0000E52A               LEA.L   L0000FCBE,A0
L0000E530               LEA.L   copper_screen_palette,A1    ; L0000FBE6,A1
L0000E536               BSR.W   L0000D206
L0000E53A               MOVE.W  #$00b4,D0
L0000E53E               BSR.W   wait_frame                  ; $0000d1ee
L0000E542               MOVE.L  #$0005ed00,L0000E55A        ; external address
L0000E54C               MOVE.L  #$00067680,L0000E55E        ; external address
L0000E556               BRA.W   L0000E572 

L0000E55A               dc.l    $00000000                   ; address ptr
L0000E55E               dc.l    $00000000                   ; address ptr



L0000E562               MOVE.W  #$225f,D7
L0000E566               MOVEA.L L0000E55E,A1
L0000E56C               CLR.L   (A1)+
L0000E56E               DBF.W   D7,L0000E56C 
L0000E572               MOVE.W  #$002c,D0
L0000E576               MOVE.W  #$0098,D1

L0000E57A               MOVEM.L L0000E55A,A0-A1
L0000E582               CLR.W   D2
L0000E584               MULU.W  #$0555,D2
L0000E588               ADD.W   #$00000001,D2
L0000E58A               AND.W   #$1fff,D2
L0000E58E               BEQ.B   L0000E5E8 
L0000E590               MOVE.L  #$0000007f,D3
L0000E592               AND.W   D2,D3
L0000E594               MOVE.L  #$0000000f,D5
L0000E596               LSR.W   #$00000001,D3
L0000E598               BCC.B   L0000E59C 
L0000E59A               MOVE.L  #$fffffff0,D5
L0000E59C               CMP.W   D0,D3
L0000E59E               BCC.B   L0000E584 
L0000E5A0               MOVE.W  D2,D4
L0000E5A2               LSR.W   #$00000005,D4
L0000E5A4               AND.W   #$00fc,D4
L0000E5A8               CMP.W   D1,D4
L0000E5AA               BCC.B   L0000E584 
L0000E5AC               MULU.W  D0,D4
L0000E5AE               ADD.W   D3,D4
L0000E5B0               MOVE.W  D2,-(A7)
L0000E5B2               MOVE.W  D0,D3
L0000E5B4               MULU.W  D1,D3
L0000E5B6               MOVE.L  #$00000003,D7
L0000E5B8               MOVE.W  D4,-(A7)
L0000E5BA               MOVE.L  #$00000003,D2
L0000E5BC               MOVE.B  D5,D6
L0000E5BE               NOT.W   D6
L0000E5C0               AND.B   $00(A0,D4.w),D6
L0000E5C4               MOVE.B  D6,$00(A0,D4.w)
L0000E5C8               MOVE.B  D5,D6
L0000E5CA               AND.B   $00(A1,D4.w),D6
L0000E5CE               OR.B    $00(A0,D4.w),D6
L0000E5D2               MOVE.B  D6,$00(A0,D4.w)
L0000E5D6               ADD.W   D0,D4
L0000E5D8               DBF.W   D2,L0000E5BC 
L0000E5DC               MOVE.W  (A7)+,D4
L0000E5DE               ADD.W   D3,D4
L0000E5E0               DBF.W   D7,L0000E5B8 
L0000E5E4               MOVE.W  (A7)+,D2
L0000E5E6               BRA.B   L0000E584 
L0000E5E8               RTS 



                ; ---------------- fade panel in (to palette) --------------
panel_fade_in
L0000E5EA               MOVE.L  #$0000000f,D7
L0000E5EC_loop          LEA.L   copper_panel_palette+2,a0       ;L0000FC54,A0
L0000E5F2               LEA.L   panel_colour_palette,a1         ;L0000FC9E,A1
L0000E5F8               MOVE.L  #$0000000f,D6
L0000E5FA_loop          MOVE.W  (A0),D0
L0000E5FC               MOVE.W  (A1)+,D1
L0000E5FE               EOR.W   D0,D1
L0000E600               MOVE.L  #$0000000f,D2
L0000E602               AND.W   D1,D2
L0000E604               BEQ.B   L0000E608 
L0000E606               ADD.W   #$00000001,D0
L0000E608               MOVE.L  #$fffffff0,D2
L0000E60A               AND.B   D1,D2
L0000E60C               BEQ.B   L0000E612 
L0000E60E               ADD.W   #$0010,D0
L0000E612               AND.W   #$0f00,D1
L0000E616               BEQ.B   L0000E61C 
L0000E618               ADD.W   #$0100,D0
L0000E61C               MOVE.W  D0,(A0)
L0000E61E               ADDA.W  #$00000004,A0
L0000E620               DBF.W   D6,L0000E5FA_loop 
L0000E624               MOVE.L  #$00000003,D0               ; frames to wait/skip
L0000E626               BSR.W   wait_frame                  ;L0000D1EE_loop
L0000E62A               DBF.W   D7,L0000E5EC_loop
L0000E62E               RTS 



                ; ---------------- fade panel out (to black) --------------
fade_panel_out
L0000E630               MOVE.L  #$0000000f,D7
L0000E632_loop          LEA.L   copper_panel_palette+2,a0   ;L0000FC54,A0
L0000E638               MOVE.L  #$0000000f,D6
L0000E63A_loop          MOVE.W  (A0),D0                 ; get colour value from copper 
L0000E63C               MOVE.L  #$0000000f,D1           ; fade blue component
L0000E63E               AND.W   D0,D1
L0000E640               BEQ.B   L0000E644 
L0000E642               SUB.W   #$00000001,D0           ; fade blue towards black
L0000E644               MOVE.W  #$00f0,D1               ; fade green component
L0000E648               AND.W   D0,D1
L0000E64A               BEQ.B   L0000E650 
L0000E64C               SUB.W   #$0010,D0               ; fade green towards black
L0000E650               MOVE.W  #$0f00,D1               ; fade red component
L0000E654               AND.W   D0,D1
L0000E656               BEQ.B   L0000E65C 
L0000E658               SUB.W   #$0100,D0               ; fade red to black
L0000E65C               MOVE.W  D0,(A0)                 ; store faded colour back into copper
L0000E65E               ADDA.W  #$00000004,A0           ; next colour 
L0000E660               DBF.W   D6,L0000E63A_loop       ; next colour loop
L0000E664               MOVE.L  #$00000003,D0           ; frames to wait/skip
L0000E666               BSR.W   wait_frame              ; L0000D1EE_loop
L0000E66A               DBF.W   D7,L0000E632_loop       ; fade all again.
L0000E66E               RTS 



text_bat_cave
L0000E670               dc.b    $46,$10
L0000E672               dc.b    'THE BATCAVE',$00,$ff
L0000E67F               dc.b    $41

text_simlex_success
L0000E680               dc.b    $14,$08
L0000E682               dc.b    'SMILEX SUCCESSFULLY ANALYSED',$00
L0000E69F               dc.b    $3C,$0C     
L0000E6A1               dc.b    'NOW THWART THE JOKERS',$00
L0000E6B7               dc.b    $50,$10
L0000E6B9               dc.b    'CARNIVAL PLOT.',$00,$ff
L0000E6C9               dc.b    $20 ; pad byte 

text_time_out
L0000E6CA               dc.b    $46,$13
L0000E6CC               dc.b    'TIME OUT',$00,$ff

text_game_over
L0000E6D6               dc.b    $46,$12
L0000E6D8               dc.b    'GAME OVER',$00,$ff
L0000E6E3               dc.b    $45 ; pad byte 



                    ; ------------------- game text typer -------------------
                    ; routine displays text (see above)
                    ; Each line of text starts with 2 bytes (y co-ord, x co-ord)
                    ; followed by null terminated text ($00)
                    ; a final terminator ($ff) or another line of text starting with x,y co-ords
                    ; can follow the previous line.
                    ;
game_text_typer     ; original address L0000E6E4
L0000E6E4               MOVE.B  (A0)+,D0
L0000E6E6               BMI.W   L0000E7BA           ; $ff = exit
L0000E6EA               AND.W   #$00ff,D0           ; d0 = y co-ord
L0000E6EE               MULU.W  #$002c,D0
L0000E6F2               MOVE.B  (A0)+,D1            ; d1 = x co-ord
L0000E6F4               EXT.W   D1
L0000E6F6               ADD.W   D1,D0               ; d0 = x & y byte offset for display
L0000E6F8               MOVEA.L L0000E55E,A1        ; destination display ptr
L0000E6FE               LEA.L   $00(A1,D0.w),A1     ; a1 = dest gfx buffer

                    ; do next character
L0000E702_loop          MOVE.L  #$00000000,D0
L0000E704               MOVE.B  (A0)+,D0
L0000E706               BEQ.B   L0000E6E4           ; $00 = end of line

L0000E708               CMP.B   #$20,D0
L0000E70C               BEQ.W   L0000E7B2 
L0000E710               MOVE.L  #$ffffffcd,D1
L0000E712               CMP.B   #$41,D0
L0000E716               BCC.B   L0000E73E 
L0000E718               MOVE.L  #$ffffffd4,D1
L0000E71A               CMP.B   #$30,D0
L0000E71E               BCC.B   L0000E73E 
L0000E720               MOVE.L  #$00000000,D1
L0000E722               CMP.B   #$21,D0
L0000E726               BEQ.B   L0000E744 
L0000E728               MOVE.L  #$00000001,D1
L0000E72A               CMP.B   #$28,D0
L0000E72E               BEQ.B   L0000E744 
L0000E730               MOVE.L  #$00000002,D1
L0000E732               CMP.B   #$29,D0
L0000E736               BEQ.B   L0000E744 
L0000E738               MOVE.L  #$00000003,D1
L0000E73A               BRA.W   L0000E744 

L0000E73E               ADD.B   D0,D1
L0000E740               AND.W   #$00ff,D1
L0000E744               MULU.W  #$0028,D1
L0000E748               LEA.L   font8x8x5,a2            ; L0000E7BC,A2            ; font gfx address
L0000E74E               LEA.L   $00(A2,D1.w),A2
L0000E752               MOVE.L  #$00000007,D7           ; 8 pixel font
L0000E754               MOVEA.L A1,A3
L0000E756_loop          MOVE.B  (A2)+,D1
L0000E758               AND.B   D1,(A3)
L0000E75A               MOVE.B  (A2)+,D2
L0000E75C               OR.B    D2,(A3)

L0000E75E               AND.B   D1,$1a20(A3)
L0000E762               MOVE.B  (A2)+,D2
L0000E764               OR.B    D2,$1a20(A3)

L0000E768               AND.B   D1,$3440(A3)
L0000E76C               MOVE.B  (A2)+,D2
L0000E76E               OR.B    D2,$3440(A3)

L0000E772               AND.B   D1,$4e60(A3)
L0000E776               MOVE.B  (A2)+,D2
L0000E778               OR.B    D2,$4e60(A3)

L0000E77C               LEA.L   $002c(A3),A3
L0000E780               LEA.L   -$0005(A2),A2
L0000E784               MOVE.B  (A2)+,D1
L0000E786               AND.B   D1,(A3)
L0000E788               MOVE.B  (A2)+,D2
L0000E78A               OR.B    D2,(A3)
L0000E78C               AND.B   D1,$1a20(A3)
L0000E790               MOVE.B  (A2)+,D2
L0000E792               OR.B    D2,$1a20(A3)
L0000E796               AND.B   D1,$3440(A3)
L0000E79A               MOVE.B  (A2)+,D2
L0000E79C               OR.B    D2,$3440(A3)
L0000E7A0               AND.B   D1,$4e60(A3)
L0000E7A4               MOVE.B  (A2)+,D2
L0000E7A6               OR.B    D2,$4e60(A3)
L0000E7AA               LEA.L   $002c(A3),A3
L0000E7AE               DBF.W   D7,L0000E756_loop 

L0000E7B2               LEA.L   $0001(A1),A1
L0000E7B6               BRA.W   L0000E702_loop 
L0000E7BA               RTS 


                ; multi-colour 4 bpl 8x8 pixel font - used by game text typer
                ; 320 rasters (4bpl + mask)

                ; char '!'
                ; ..11....      ; bpl0
                ; ..11....
                ; ..11....
                ; ..11....
                ; ..11....
                ; ........
                ; ..11....
                ; ........
font8x8x5
L0000E7BC       dc.b    $CF     ; 11..1111      ; mask
                dc.b    $30     ; ..11....      ; bpl0
                dc.b    $30     ; ..11....      ; bpl1
                dc.b    $00     ; ........      ; bpl2
                dc.b    $00     ; ........      ; bpl3

                dc.b    $C7     ; 11...111
                dc.b    $30     ; ..11....
                dc.b    $38     ; ..111...
                dc.b    $08     ; ....1...
                dc.b    $00     ; ........

                dc.b    $C7     ; 11...111
                dc.b    $30     ; ..11....
                dc.b    $38     ; ..111...
                dc.b    $08     ; ....1...
                dc.b    $00     ; ........

                dc.b    $C7     ; 11...111
L0000E7CC       dc.b    $30     ; ..11....
                dc.b    $38     ; ..111...
                dc.b    $08     ; ....1...
                dc.b    $00     ; ........

                dc.b    $C7     ; 11...111
                dc.b    $30     ; ..11....
                dc.b    $38     ; ..111...
                dc.b    $08     ; ....1...
                dc.b    $00     ; ........

                dc.b    $E7     ; 111..111
                dc.b    $00     ; ........
                dc.b    $18     ; ...11...
                dc.b    $18     ; ...11...
                dc.b    $00     ; ........

                dc.b    $CF     ; 11..1111
                dc.b    $30     ; ..11....
L0000E7DC       dc.b    $30     ; ..11....
                dc.b    $00     ; ........
                dc.b    $00     ; ........

                dc.b    $E7     ; 111..111
                dc.b    $00     ; ........
                dc.b    $18     ; ...11...
                dc.b    $18     ; ...11...
                dc.b    $00     ; ........



                dc.b    $F3
                dc.b    $0C
                dc.b    $0C
                dc.b    $00
                dc.b    $00
                dc.b    $E1
                dc.b    $18
                dc.b    $1E
L0000E7EC       dc.w    $0600,$E318,$1C04,$00E3,$181C,$0400,$E318,$1C04
L0000E7FC       dc.w    $00E3,$181C,$0400,$F30C,$0C00,$00F9,$0006,$0600
L0000E80C       dc.w    $9F60,$6000,$00CF,$3030,$0000,$C730,$3808,$00C7
L0000E81C       dc.w    $3038,$0800,$C730,$3808,$00C7,$3038,$0800,$8760
L0000E82C       dc.w    $7818,$00CF,$0030,$3000,$FF00,$0000,$00FF,$0000
L0000E83C       dc.w    $0000,$FF00,$0000,$00FF,$0000,$0000,$FF00,$0000
L0000E84C       dc.w    $009F,$6060,$0000,$8F60,$7010,$00CF,$0030,$3000
L0000E85C       dc.w    $837C,$7C00,$0001,$C6FE,$3800,$10CE,$EF21,$0000
L0000E86C       dc.w    $D6FF,$2900,$08E6,$F711,$0018,$C6E7,$2100,$807C
L0000E87C       dc.w    $7F03,$00C1,$003E,$3E00,$C738,$3800,$00C3,$383C
L0000E88C       dc.w    $0400,$E318,$1C04,$00E3,$181C,$0400,$E318,$1C04
L0000E89C       dc.w    $00E3,$181C,$0400,$E318,$1C04,$00F3,$000C,$0C00
L0000E8AC       dc.w    $837C,$7C00,$0001,$C6FE,$3800,$900C,$6F63,$00E1
L0000E8BC       dc.w    $181E,$0600,$C330,$3C0C,$0087,$6078,$1800,$00FE
L0000E8CC       dc.w    $FF01,$0080,$007F,$7F00,$837C,$7C00,$0001,$C6FE
L0000E8DC       dc.w    $3800,$9806,$6761,$00C0,$3C3F,$0300,$E106,$1E18
L0000E8EC       dc.w    $0038,$C6C7,$0100,$807C,$7F03,$00C1,$003E,$3E00
L0000E8FC       dc.w    $E31C,$1C00,$00C1,$3C3E,$0200,$816C,$7E12,$0001
L0000E90C       dc.w    $CCFE,$3200,$01FE,$FE00,$0080,$0C7F,$7300,$F10C
L0000E91C       dc.w    $0E02,$00F9,$0006,$0600,$00FE,$FF00,$0000,$C0FF
L0000E92C       dc.w    $3F00,$1FC0,$E020,$0003,$FCFC,$0000,$8006,$7F79
L0000E93C       dc.w    $0038,$C6C7,$0100,$807C,$7F03,$00C1,$003E,$3E00
L0000E94C       dc.w    $837C,$7C00,$0001,$C6FE,$3800,$1CC0,$E323,$0003
L0000E95C       dc.w    $FCFC,$0000,$01C6,$FE38,$0018,$C6E7,$2100,$807C
L0000E96C       dc.w    $7F03,$00C1,$003E,$3E00,$01FE,$FE00,$0080,$067F
L0000E97C       dc.w    $7900,$F00C,$0F03,$00E1,$181E,$0600,$E318,$1C04
L0000E98C       dc.w    $00C7,$3038,$0800,$C730,$3808,$00E7,$0018,$1800
L0000E99C       dc.w    $837C,$7C00,$0001,$C6FE,$3800,$18C6,$E721,$0080
L0000E9AC       dc.w    $7C7F,$0300,$01C6,$FE38,$0018,$C6E7,$2100,$807C
L0000E9BC       dc.w    $7F03,$00C1,$003E,$3E00,$837C,$7C00,$0001,$C6FE
L0000E9CC       dc.w    $3800,$18C6,$E721,$0080,$7E7F,$0100,$C006,$3F39
L0000E9DC       dc.w    $0038,$C6C7,$0100,$807C,$7F03,$00C1,$003E,$3E00
L0000E9EC       dc.w    $EF10,$1000,$00C7,$3838,$0000,$C338,$3C04,$0083
L0000E9FC       dc.w    $6C7C,$1000,$817C,$7E02,$0001,$C6FE,$3800,$18C6
L0000EA0C       dc.w    $E721,$009C,$0063,$6300,$03FC,$FC00,$0001,$C6FE
L0000EA1C       dc.w    $3800,$18C6,$E721,$0000,$FCFF,$0300,$01C6,$FE38
L0000EA2C       dc.w    $0018,$C6E7,$2100,$00FC,$FF03,$0081,$007E,$7E00
L0000EA3C       dc.w    $837C,$7C00,$0001,$C6FE,$3800,$1CC0,$E323,$001F
L0000EA4C       dc.w    $C0E0,$2000,$1FC0,$E020,$0019,$C6E6,$2000,$807C
L0000EA5C       dc.w    $7F03,$00C1,$003E,$3E00,$07F8,$F800,$0003,$CCFC
L0000EA6C       dc.w    $3000,$19C6,$E620,$0018,$C6E7,$2100,$18C6,$E721
L0000EA7C       dc.w    $0010,$CCEF,$2300,$01F8,$FE06,$0083,$007C,$7C00
L0000EA8C       dc.w    $01FE,$FE00,$0000,$C0FF,$3F00,$1FC0,$E020,$0007
L0000EA9C       dc.w    $F8F8,$0000,$03C0,$FC3C,$001F,$C0E0,$2000,$01FE
L0000EAAC       dc.w    $FE00,$0080,$007F,$7F00,$01FE,$FE00,$0000,$C0FF
L0000EABC       dc.w    $3F00,$1FC0,$E020,$0007,$F8F8,$0000,$03C0,$FC3C
L0000EACC       dc.w    $001F,$C0E0,$2000,$1FC0,$E020,$009F,$0060,$6000
L0000EADC       dc.w    $837C,$7C00,$0001,$C6FE,$3800,$1CC0,$E323,$0001
L0000EAEC       dc.w    $DEFE,$2000,$10C6,$EF29,$0018,$C6E7,$2100,$807E
L0000EAFC       dc.w    $7F01,$00C0,$003F,$3F00,$39C6,$C600,$0018,$C6E7
L0000EB0C       dc.w    $2100,$18C6,$E721,$0000,$FEFF,$0100,$00C6,$FF39
L0000EB1C       dc.w    $0018,$C6E7,$2100,$18C6,$E721,$009C,$0063,$6300
L0000EB2C       dc.w    $8778,$7800,$00C3,$303C,$0C00,$C730,$3808,$00C7
L0000EB3C       dc.w    $3038,$0800,$C730,$3808,$00C7,$3038,$0800,$8778
L0000EB4C       dc.w    $7800,$00C3,$003C,$3C00,$F906,$0600,$00F8,$0607
L0000EB5C       dc.w    $0100,$F806,$0701,$00F8,$0607,$0100,$38C6,$C701
L0000EB6C       dc.w    $0018,$C6E7,$2100,$807C,$7F03,$00C1,$003E,$3E00
L0000EB7C       dc.w    $39C6,$C600,$0010,$CCEF,$2300,$01D8,$FE26,$0003
L0000EB8C       dc.w    $F0FC,$0C00,$07D8,$F820,$0013,$CCEC,$2000,$19C6
L0000EB9C       dc.w    $E620,$009C,$0063,$6300,$3FC0,$C000,$001F,$C0E0
L0000EBAC       dc.w    $2000,$1FC0,$E020,$001F,$C0E0,$2000,$1FC0,$E020
L0000EBBC       dc.w    $0019,$C6E6,$2000,$00FE,$FF01,$0080,$007F,$7F00
L0000EBCC       dc.w    $39C6,$C600,$0010,$EEEF,$0100,$00FE,$FF01,$0000
L0000EBDC       dc.w    $D6FF,$2900,$10C6,$EF29,$0018,$C6E7,$2100,$18C6
L0000EBEC       dc.w    $E721,$009C,$0063,$6300,$39C6,$C600,$0018,$E6E7
L0000EBFC       dc.w    $0100,$08F6,$F701,$0000,$DEFF,$2100,$10CE,$EF21
L0000EC0C       dc.w    $0018,$C6E7,$2100,$18C6,$E721,$009C,$0063,$6300
L0000EC1C       dc.w    $837C,$7C00,$0001,$C6FE,$3800,$18C6,$E721,$0018
L0000EC2C       dc.w    $C6E7,$2100,$18C6,$E721,$0018,$C6E7,$2100,$807C
L0000EC3C       dc.w    $7F03,$00C1,$003E,$3E00,$03FC,$FC00,$0001,$C6FE
L0000EC4C       dc.w    $3800,$18C6,$E721,$0000,$FCFF,$0300,$01C0,$FE3E
L0000EC5C       dc.w    $001F,$C0E0,$2000,$1FC0,$E020,$009F,$0060,$6000
L0000EC6C       dc.w    $837C,$7C00,$0001,$C6FE,$3800,$18C6,$E721,$0018
L0000EC7C       dc.w    $C6E7,$2100,$00DA,$FF25,$0000,$CCFF,$3300,$8176
L0000EC8C       dc.w    $7E08,$00C4,$003B,$3B00,$03FC,$FC00,$0001,$C6FE
L0000EC9C       dc.w    $3800,$18C6,$E721,$0000,$FCFF,$0300,$01CC,$FE32
L0000ECAC       dc.w    $0018,$C6E7,$2100,$18C6,$E721,$009C,$0063,$6300
L0000ECBC       dc.w    $837C,$7C00,$0001,$C6FE,$3800,$1CC0,$E323,$0083
L0000ECCC       dc.w    $7C7C,$0000,$C106,$3E38,$0038,$C6C7,$0100,$807C
L0000ECDC       dc.w    $7F03,$00C1,$003E,$3E00,$03FC,$FC00,$0081,$307E
L0000ECEC       dc.w    $4E00,$C730,$3808,$00C7,$3038,$0800,$C730,$3808
L0000ECFC       dc.w    $00C7,$3038,$0800,$C730,$3808,$00E7,$0018,$1800
L0000ED0C       dc.w    $39C6,$C600,$0018,$C6E7,$2100,$18C6,$E721,$0018
L0000ED1C       dc.w    $C6E7,$2100,$18C6,$E721,$0018,$C6E7,$2100,$807C
L0000ED2C       dc.w    $7F03,$00C1,$003E,$3E00,$39C6,$C600,$0018,$C6E7
L0000ED3C       dc.w    $2100,$18C6,$E721,$0080,$6C7F,$1300,$817C,$7E02
L0000ED4C       dc.w    $00C1,$383E,$0600,$E310,$1C0C,$00F7,$0008,$0800
L0000ED5C       dc.w    $39C6,$C600,$0018,$C6E7,$2100,$08D6,$F721,$0000
L0000ED6C       dc.w    $D6FF,$2900,$00FE,$FF01,$0080,$7C7F,$0300,$816C
L0000ED7C       dc.w    $7E12,$00C9,$0036,$3600,$39C6,$C600,$0018,$C6E7
L0000ED8C       dc.w    $2100,$10EE,$EF01,$0080,$7C7F,$0300,$01EE,$FE10
L0000ED9C       dc.w    $0018,$C6E7,$2100,$18C6,$E721,$009C,$0063,$6300
L0000EDAC       dc.w    $33CC,$CC00,$0011,$CCEE,$2200,$11CC,$EE22,$0081
L0000EDBC       dc.w    $787E,$0600,$C330,$3C0C,$00C7,$3038,$0800,$C730
L0000EDCC       dc.w    $3808,$00E7,$0018,$1800,$03FC,$FC00,$0001,$CCFE
L0000EDDC       dc.w    $3200,$8118,$7E66,$00C3,$303C,$0C00,$8760,$7818
L0000EDEC       dc.w    $0003,$CCFC,$3000,$01FC,$FE02,$0081,$007E,$7E00
                ; ----------- end of font data -------


debug_display_buffer_ptr
L0000EDFC       dc.l    $0007C89A               ; address of panel gfx

L0000EE00       dc.w    $0000

frame_toggle    ; original address L0000EE02
L0000EE02       dc.w    $0000                   ; frame toggle (NOT.W every VERTB) - unreferenced by code

L0000EE04       dc.w    $0000

L0000EE06       dc.w    $C89A,$002C,$FFFF
L0000EE0C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000EE1C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000EE2C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000EE3C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000EE4C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000EE5C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000EE6C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000EE7C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000EE8C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000EE9C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000EEAC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000EEBC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000EECC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000EEDC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000EEEC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000EEFC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000EF0C       dc.w    $0000,$0000,$0000,$0000,$0007,$FC92,$0007,$C808
L0000EF1C       dc.w    $0007,$FC92,$0007,$C808,$0000,$8000,$0000,$FFFF
L0000EF2C       dc.w    $0055,$FFFF,$0000,$0000,$0000,$7E81,$FFFF,$FFF0
L0000EF3C       dc.w    $0000,$FFFF,$0000,$FFFF,$0000,$4126,$0006,$7680
L0000EF4C       dc.w    $0000,$E864,$0000,$D1E4,$0000,$FFFF,$0000,$FFFF
L0000EF5C       dc.w    $0055,$0000,$0000,$1A20,$0000,$7E81,$FFFF,$FFF0
L0000EF6C       dc.w    $0000,$FFFF,$0000,$FFFF,$0000,$FC9C,$0006,$7680
L0000EF7C       dc.w    $0000,$E864,$0006,$871D,$0000,$E150,$0000,$00C7
L0000EF8C       dc.w    $848C,$00C7,$871E,$00C7,$8104,$0000,$0000,$FFFF
L0000EF9C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000EFAC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000EFBC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000EFCC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000EFDC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000EFEC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000EFFC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F00C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F01C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F02C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F03C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F04C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F05C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F06C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F07C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F08C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F09C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F0AC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F0BC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F0CC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F0DC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F0EC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F0FC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F10C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F11C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F12C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F13C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F14C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F15C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F16C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F17C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F18C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F19C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F1AC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F1BC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F1CC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F1DC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F1EC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F1FC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F20C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F21C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F22C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F23C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F24C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F25C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F26C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F27C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F28C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F29C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F2AC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F2BC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F2CC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F2DC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F2EC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F2FC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F30C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F31C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F32C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F33C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F34C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F35C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F36C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F37C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F38C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F39C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F3AC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F3BC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F3CC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F3DC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F3EC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F3FC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F40C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F41C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F42C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F43C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F44C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F45C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F46C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F47C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F48C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F49C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F4AC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F4BC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F4CC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F4DC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F4EC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F4FC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F50C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F51C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F52C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F53C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F54C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F55C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F56C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F57C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F58C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F59C       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F5AC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F5BC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0000F5CC       dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$07FF
L0000F5DC       dc.w    $FFE0,$0000,$07FF,$FFE0,$0000,$07FF,$FFE0,$0000
L0000F5EC       dc.w    $07FF,$FFE0,$0000,$07FF,$FFE0,$0000,$07FF,$FFE0
L0000F5FC       dc.w    $0000,$07FF,$FFE0,$0000,$07FF,$FFE0,$0000,$07FF
L0000F60C       dc.w    $FFE0,$0000,$07FF,$FFE0,$0000,$07FF,$FFE0,$0000
L0000F61C       dc.w    $07FF,$FFE0,$0000,$07FF,$FFE0,$0000,$07FF,$FFE0
L0000F62C       dc.w    $0000,$07FF,$FFE0,$0000,$07FF,$FFE0,$0000,$07FF
L0000F63C       dc.w    $FFE0,$0000,$07FF,$FFE0,$0000,$07FF,$FFE0,$0000
L0000F64C       dc.w    $07FF,$FFE0,$0000,$07FF,$FFE0,$0000,$07FF,$FFE0
L0000F65C       dc.w    $0000,$07FF,$FFE0,$0000,$07FF,$FFE0,$0000,$07FF
L0000F66C       dc.w    $FFE0,$0000,$07FF,$FFE0,$0000,$07FF,$FFE0,$0000
L0000F67C       dc.w    $07FF,$FFE0,$0000,$0000,$0000,$0000,$0000,$0000
L0000F68C       dc.w    $0000

            ; debug typer buffer (64 bytes)
debug_typer_buffer  ; original address L0000F68E
L0000F68E       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F69C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F6AC       dc.w    $0000,$FF00,$0000,$FF00,$0000,$FF00,$0000,$FF00
L0000F6BC       dc.w    $0000,$FF00,$0000,$FF00,$0000,$FF00,$0000,$FF00
L0000F6CC       dc.w    $0000

game_screen_palette
L0000F6CE       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F6DC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F6EC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F6FC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F70C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F71C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F72C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F73C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F74C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F75C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F76C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F77C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F78C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F79C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F7AC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F7BC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F7CC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F7DC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F7EC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F7FC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F80C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F81C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F82C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F83C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F84C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F85C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F86C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F87C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F88C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F89C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F8AC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F8BC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F8CC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F8DC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F8EC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F8FC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F90C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F91C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F92C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F93C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F94C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F95C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F96C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F97C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F98C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F99C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F9AC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F9BC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F9CC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F9DC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F9EC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000F9FC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FA0C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FA1C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FA2C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FA3C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FA4C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FA5C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FA6C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FA7C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FA8C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FA9C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FAAC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FABC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FACC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FADC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FAEC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FAFC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FB0C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FB1C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FB2C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FB3C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FB4C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FB5C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FB6C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FB7C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FB8C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FB9C       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0000FBAC       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000 



            ; ----------------- copper list -----------------
copper_list ; original address $000fbba
L0000FBBA   ; original address $000fbba
                ; game screen display
                dc.w    $00FF,$FF00
                dc.w    $0108,$0004
                dc.w    $010A,$0004
                dc.w    $00E0,$0005
                dc.w    $00E2,$ED02     ; $5ED02 - bpl0
                dc.w    $00E4,$0006
                dc.w    $00E6,$0722     ; $60722 - bpl1
                dc.w    $00E8,$0006
                dc.w    $00EA,$2142     ; $62142 - bpl2
                dc.w    $00EC,$0006
                dc.w    $00EE,$3B62     ; $63B63 - bpl3

                ; game screen palette (4 bitplanes/16 colours)
copper_screen_palette
L0000FBE6       dc.w    $0180,$0000
                dc.w    $0182,$0000
                dc.w    $0184,$0000
                dc.w    $0186,$0000
                dc.w    $0188,$0000
                dc.w    $018A,$0000
                dc.w    $018C,$0000
                dc.w    $018E,$0000
                dc.w    $0190,$0000
                dc.w    $0192,$0000
                dc.w    $0194,$0000
                dc.w    $0196,$0000
                dc.w    $0198,$0000
                dc.w    $019A,$0000
                dc.w    $019C,$0000
                dc.w    $019E,$0000
                ; panel display start
L0000FC26       dc.w    $C401,$FF00
                dc.w    $00E0,$0007
                dc.w    $00E2,$C89A     ; $7C89A - bpl0
                dc.w    $00E4,$0007
                dc.w    $00E6,$D01A     ; $7D01A - bpl1
                dc.w    $00E8,$0007
                dc.w    $00EA,$D79A     ; $7D79A - bpl2
                dc.w    $00EC,$0007
                dc.w    $00EE,$DF1A     ; $7DF1A - bpl3
                dc.w    $0108,$0000
                dc.w    $010A,$0000
                ; panel palette (4 bitplanes/16 colours)
copper_panel_palette
L0000FC52       dc.w    $0180,$0000
                dc.w    $0182,$0000
                dc.w    $0184,$0000
                dc.w    $0186,$0000
                dc.w    $0188,$0000
                dc.w    $018A,$0000
                dc.w    $018C,$0000
                dc.w    $018E,$0000
                dc.w    $0190,$0000
                dc.w    $0192,$0000
                dc.w    $0194,$0000
                dc.w    $0196,$0000
                dc.w    $0198,$0000
                dc.w    $019A,$0000
                dc.w    $019C,$0000
                dc.w    $019E,$0000
                ; end of the display
                dc.w    $F301,$FFFE
                dc.w    $0180,$0000
                dc.w    $FFFF,$FFFE 


; colour table (panel?)
panel_colour_palette
L0000FC9E       dc.w    $0000,$0060,$0FFF,$0008,$0A22,$0444,$0862
L0000FCAC       dc.w    $0666,$0888,$0AAA,$0A40,$0C60,$0E80,$0EA0,$0EC0
L0000FCBC       dc.w    $0EEE

L0000FCBE       dc.w    $0000,$0130,$0111,$0333,$0555,$0777,$0BBB
L0000FCCC       dc.w    $0008,$0A04,$0703,$0000,$0B50,$0F70,$0250,$0F00
L0000FCDC       dc.w    $0005,$0F70,$0250,$0F00,$0005,$0000,$0000,$0000


L0000FCEC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FCFC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FD0C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FD1C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FD2C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FD3C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FD4C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FD5C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FD6C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FD7C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FD8C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FD9C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FDAC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FDBC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FDCC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FDDC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FDEC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FDFC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FE0C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FE1C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FE2C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FE3C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FE4C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FE5C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FE6C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FE7C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FE8C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FE9C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FEAC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FEBC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FECC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FEDC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FEEC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FEFC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FF0C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FF1C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FF2C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FF3C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FF4C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FF5C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FF6C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FF7C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FF8C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FF9C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FFAC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FFBC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FFCC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FFDC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FFEC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0000FFFC   dc.w    $0000,$0000



L00010000   dc.w    $0000,$0000,$0000,$005D,$0000,$0000  
L0001000C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0001001C   dc.w    $0000,$0000,$0000,$0000,$BA0B,$40A8,$01C0,$0000  
L0001002C   dc.w    $0000,$0680,$0000,$0001,$82FF,$FFFF,$FE00,$0000  
L0001003C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$007F  
L0001004C   dc.w    $FFFF,$FF41,$8000,$0000,$0160,$0000,$0000,$0D1C  
L0001005C   dc.w    $98FF,$FFE0,$8500,$0000,$0000,$0000,$0000,$0000  
L0001006C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$00A1  
L0001007C   dc.w    $07FF,$FF19,$38B0,$0000,$0000,$0A30,$0000,$0031  
L0001008C   dc.w    $4400,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0001009C   dc.w    $0000,$0000,$0000,$0000,$0000,$0022,$8C00,$0000  
L000100AC   dc.w    $0C50,$0000,$0000,$0A00,$E800,$0001,$4400,$0000  
L000100BC   dc.w    $03FF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF  
L000100CC   dc.w    $FFFF,$FFC0,$0000,$0022,$8000,$0017,$0050,$0000  
L000100DC   dc.w    $0000,$0A21,$0000,$0011,$447F,$FFFF,$FFFF,$FFFF  
L000100EC   dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF  
L000100FC   dc.w    $FFFF,$FE22,$8800,$0000,$0450,$0000,$0000,$0A24  
L0001010C   dc.w    $0000,$0011,$44FF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF  
L0001011C   dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FF22  
L0001012C   dc.w    $8800,$0000,$2450,$0000,$0000,$0A22,$0000,$0011  
L0001013C   dc.w    $4500,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0001014C   dc.w    $0000,$0000,$0000,$0000,$0000,$00A2,$8800,$0000  
L0001015C   dc.w    $4450,$0000,$0000,$0A20,$0000,$0011,$4600,$0000  
L0001016C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0001017C   dc.w    $0000,$0000,$0000,$0062,$8800,$0000,$0450,$0000  
L0001018C   dc.w    $0000,$0A2C,$0000,$0011,$4000,$0000,$0000,$0000  
L0001019C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L000101AC   dc.w    $0000,$0002,$8800,$0000,$3450,$0000,$0000,$0A20  
L000101BC   dc.w    $0000,$0011,$4000,$0000,$0000,$0000,$0000,$0000  
L000101CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0002  
L000101DC   dc.w    $8800,$0000,$0450,$0000,$0000,$0A28,$0000,$0011  
L000101EC   dc.w    $4060,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L000101FC   dc.w    $0000,$0000,$0000,$0000,$0000,$0602,$8800,$0000  
L0001020C   dc.w    $1450,$0000,$0000,$0A20,$0000,$0011,$4089,$7FB1  
L0001021C   dc.w    $F81F,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF  
L0001022C   dc.w    $FFFF,$F81F,$8DFE,$9102,$8800,$0000,$0450,$0000  
L0001023C   dc.w    $0000,$0A20,$0000,$0011,$4080,$0000,$3524,$17FF  
L0001024C   dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFE8,$24AC  
L0001025C   dc.w    $0000,$0102,$8800,$0000,$0450,$0000,$0000,$0E24  
L0001026C   dc.w    $0000,$0012,$2080,$0000,$0A50,$0000,$0000,$0000  
L0001027C   dc.w    $0000,$0000,$0000,$0000,$0000,$0A50,$0000,$0104  
L0001028C   dc.w    $4800,$0000,$2470,$0000,$0000,$1E20,$0000,$0010  
L0001029C   dc.w    $0080,$0000,$0AA4,$0000,$0000,$0000,$0000,$0000  
L000102AC   dc.w    $0000,$0000,$0000,$2550,$0000,$0100,$0800,$0000  
L000102BC   dc.w    $0478,$0000,$0000,$1420,$0000,$0011,$C080,$0000  
L000102CC   dc.w    $04A8,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L000102DC   dc.w    $0000,$1520,$0000,$0103,$8800,$0000,$0428,$0000  
L000102EC   dc.w    $0000,$D4A0,$0000,$0011,$4080,$0000,$04D0,$3A00  
L000102FC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$005C,$0B20  
L0001030C   dc.w    $0000,$0102,$8800,$0000,$052B,$0000,$0000,$1420  
L0001031C   dc.w    $0000,$0015,$4C80,$0000,$04F0,$5000,$0000,$0000  
L0001032C   dc.w    $0000,$0000,$0000,$0000,$000A,$0F20,$0000,$0132  
L0001033C   dc.w    $A800,$0000,$0428,$0000,$0000,$D4A0,$0000,$0015  
L0001034C   dc.w    $4C80,$0000,$02E1,$0000,$0000,$0000,$0000,$0000  
L0001035C   dc.w    $0000,$0000,$0000,$8740,$0000,$0132,$A800,$0000  
L0001036C   dc.w    $052B,$0000,$0000,$1420,$0000,$0011,$4080,$0000  
L0001037C   dc.w    $02A0,$8000,$0000,$0000,$0000,$0000,$0000,$0000  
L0001038C   dc.w    $0001,$0540,$0000,$0102,$8800,$0000,$0428,$0000  
L0001039C   dc.w    $0000,$D4A0,$0000,$0015,$4C80,$0000,$02E0,$0000  
L000103AC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0740  
L000103BC   dc.w    $0000,$0132,$A800,$0000,$052B,$0000,$0000,$1420  
L000103CC   dc.w    $0000,$0011,$4080,$0000,$00A3,$0000,$0000,$0000  
L000103DC   dc.w    $0000,$0000,$0000,$0000,$0000,$C500,$0000,$0102  
L000103EC   dc.w    $8800,$0000,$0428,$0000,$0000,$1420,$0000,$0051  
L000103FC   dc.w    $4080,$0000,$02A0,$0000,$0000,$0000,$0000,$0000  
L0001040C   dc.w    $0000,$0000,$0000,$0540,$0000,$0102,$8A00,$0000  
L0001041C   dc.w    $0428,$0000,$0000,$1E20,$0000,$0012,$0080,$0000  
L0001042C   dc.w    $00A2,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0001043C   dc.w    $0000,$4500,$0000,$0100,$4800,$0000,$0478,$0000  
L0001044C   dc.w    $0000,$0A20,$0000,$0011,$4080,$0000,$00A0,$0000  
L0001045C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0500  
L0001046C   dc.w    $0000,$0102,$8800,$0000,$0450,$0000,$0000,$0A20  
L0001047C   dc.w    $0000,$0031,$4080,$0000,$02A0,$0000,$0000,$0000  
L0001048C   dc.w    $0000,$0000,$0000,$0000,$0000,$0540,$0000,$0102  
L0001049C   dc.w    $8C00,$0000,$0450,$0000,$0000,$0A20,$0000,$0011  
L000104AC   dc.w    $4080,$0000,$00A1,$0000,$0000,$0000,$0000,$0000  
L000104BC   dc.w    $0000,$0000,$0000,$8500,$0000,$0102,$8800,$0000  
L000104CC   dc.w    $0450,$0000,$0000,$0A20,$0000,$0071,$4080,$0000  
L000104DC   dc.w    $00A0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L000104EC   dc.w    $0000,$0500,$0000,$0102,$8E00,$0000,$0450,$0000  
L000104FC   dc.w    $0000,$0A20,$0000,$0011,$5080,$0000,$00A0,$0000  
L0001050C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0500  
L0001051C   dc.w    $0000,$010A,$8800,$0000,$0450,$0000,$0000,$0A20  
L0001052C   dc.w    $0000,$0091,$4080,$0000,$00A0,$0000,$0000,$0000  
L0001053C   dc.w    $0000,$0000,$0000,$0000,$0000,$0500,$0000,$0102  
L0001054C   dc.w    $8900,$0000,$0450,$0000,$0000,$0A20,$0000,$0051  
L0001055C   dc.w    $4880,$0000,$00A0,$0000,$0000,$0000,$0000,$0000  
L0001056C   dc.w    $0000,$0000,$0000,$0500,$0000,$0112,$8A00,$0000  
L0001057C   dc.w    $0450,$0000,$0000,$0A20,$0000,$0111,$4080,$0000  
L0001058C   dc.w    $00A0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0001059C   dc.w    $0000,$0500,$0000,$0102,$88A0,$0000,$0450,$0000  
L000105AC   dc.w    $0000,$0C00,$0000,$2E01,$4480,$0040,$00A0,$0000  
L000105BC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0500  
L000105CC   dc.w    $0200,$0122,$8074,$0000,$0030,$0000,$0000,$0930  
L000105DC   dc.w    $0000,$0033,$8080,$0060,$00A0,$0000,$0000,$0000  
L000105EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0500,$0600,$0101  
L000105FC   dc.w    $CC00,$0000,$0C90,$0000,$0000,$0A90,$017D,$0025  
L0001060C   dc.w    $4080,$0018,$00A0,$0000,$0000,$0000,$0000,$0000  
L0001061C   dc.w    $0000,$0000,$0000,$0500,$1800,$0102,$A400,$BE80  
L0001062C   dc.w    $0950,$0000,$0000,$156A,$AA00,$2A82,$A080,$0008  
L0001063C   dc.w    $00A0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0001064C   dc.w    $0000,$0500,$1000,$0105,$4154,$0055,$56A8,$0000  
L0001065C   dc.w    $0000,$147F,$FA0A,$FF18,$A080,$0400,$00A0,$0000  
L0001066C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0500  
L0001067C   dc.w    $0020,$0105,$18FF,$505F,$FE28,$0000,$0000,$0A80  
L0001068C   dc.w    $0000,$000D,$2080,$0800,$00A0,$0000,$0000,$0000  
L0001069C   dc.w    $0000,$0000,$0000,$0000,$0000,$0500,$0010,$0104  
L000106AC   dc.w    $B000,$0000,$0150,$0000,$0000,$0917,$FFFF,$FFA6  
L000106BC   dc.w    $4080,$0100,$00A0,$0000,$0000,$0000,$0000,$0000  
L000106CC   dc.w    $0000,$0000,$0000,$0500,$0080,$0102,$65FF,$FFFF  
L000106DC   dc.w    $E890,$0000,$0000,$0C30,$0000,$0033,$8080,$0280  
L000106EC   dc.w    $00A0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L000106FC   dc.w    $0000,$0500,$0140,$0101,$CC00,$0000,$0C30,$0000  
L0001070C   dc.w    $0000,$0A00,$E800,$0001,$4080,$0000,$00A0,$0000  
L0001071C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0500  
L0001072C   dc.w    $0000,$0102,$8000,$0017,$0050,$0000,$0000,$0A21  
L0001073C   dc.w    $0000,$0011,$4080,$0080,$00A0,$0000,$0000,$0000  
L0001074C   dc.w    $0000,$0000,$0000,$0000,$0000,$0500,$0100,$0102  
L0001075C   dc.w    $8800,$0000,$0450,$0000,$0000,$0A24,$0000,$0011  
L0001076C   dc.w    $4880,$0000,$00A0,$0000,$0000,$0000,$0000,$0000  
L0001077C   dc.w    $0000,$0000,$0000,$0500,$0000,$0112,$8800,$0000  
L0001078C   dc.w    $2450,$0000,$0000,$0A22,$0000,$0011,$4080,$0000  
L0001079C   dc.w    $00A0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L000107AC   dc.w    $0000,$0500,$0000,$0102,$8800,$0000,$4450,$0000  
L000107BC   dc.w    $0000,$0A20,$0000,$0011,$4480,$0000,$00A0,$0000  
L000107CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0500  
L000107DC   dc.w    $0000,$0122,$8800,$0000,$0450,$0000,$0000,$0A2C  
L000107EC   dc.w    $0000,$0011,$4280,$0000,$00A0,$0000,$0000,$0000  
L000107FC   dc.w    $0000,$0000,$0000,$0000,$0000,$0500,$0000,$0142  
L0001080C   dc.w    $8800,$0000,$3450,$0000,$0000,$0A20,$0000,$0011  
L0001081C   dc.w    $4080,$0000,$00A0,$0000,$0000,$0000,$0000,$0000  
L0001082C   dc.w    $0000,$0000,$0000,$0500,$0000,$0102,$8800,$0000  
L0001083C   dc.w    $0450,$0000,$0000,$0A28,$0000,$0011,$4080,$0000  
L0001084C   dc.w    $00A0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0001085C   dc.w    $0000,$0500,$0000,$0102,$8800,$0000,$1450,$0000  
L0001086C   dc.w    $0000,$0A20,$0000,$0011,$4080,$0000,$00A0,$0000  
L0001087C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0500  
L0001088C   dc.w    $0000,$0102,$8800,$0000,$0450,$0000,$0000,$0A20  
L0001089C   dc.w    $0000,$0011,$4080,$0000,$00A0,$0000,$0000,$0000  
L000108AC   dc.w    $0000,$0000,$0000,$0000,$0000,$0500,$0000,$0102  
L000108BC   dc.w    $8800,$0000,$0450,$0000,$0000,$0E24,$0000,$0012  
L000108CC   dc.w    $2080,$0000,$00A0,$0000,$0000,$0000,$0000,$0000  
L000108DC   dc.w    $0000,$0000,$0000,$0500,$0000,$0104,$4800,$0000  
L000108EC   dc.w    $2470,$0000,$0000,$1E20,$0000,$0010,$0080,$0000  
L000108FC   dc.w    $00A0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0001090C   dc.w    $0000,$0500,$0000,$0100,$0800,$0000,$0478,$0000  
L0001091C   dc.w    $0000,$1420,$0000,$0011,$C080,$0000,$00A0,$0000  
L0001092C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0500  
L0001093C   dc.w    $0000,$0103,$8800,$0000,$0428,$0000,$0000,$D4A0  
L0001094C   dc.w    $0000,$0011,$4C80,$0000,$00A0,$0000,$0000,$0000  
L0001095C   dc.w    $0000,$0000,$0000,$0000,$0000,$0500,$0000,$0132  
L0001096C   dc.w    $8800,$0000,$052B,$0000,$0000,$1420,$0000,$0015  
L0001097C   dc.w    $4080,$0000,$00A0,$0000,$0000,$0000,$0000,$0000  
L0001098C   dc.w    $0000,$0000,$0000,$0500,$0000,$0102,$A800,$0000  
L0001099C   dc.w    $0428,$0000,$0000,$D4A0,$0000,$0015,$4C80,$0000  
L000109AC   dc.w    $00A0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L000109BC   dc.w    $0000,$0500,$0000,$0132,$A800,$0000,$052B,$0000  
L000109CC   dc.w    $0000,$14A0,$0000,$0011,$4080,$0000,$00A0,$0000  
L000109DC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0500  
L000109EC   dc.w    $0000,$0102,$8800,$0000,$0528,$0000,$0000,$D4A0  
L000109FC   dc.w    $0000,$0015,$4C80,$0000,$00A0,$0000,$0000,$0000  
L00010A0C   dc.w    $0000,$0000,$0000,$0000,$0000,$0500,$0000,$0132  
L00010A1C   dc.w    $A800,$0000,$052B,$0000,$0000,$1420,$0000,$0011  
L00010A2C   dc.w    $4080,$0000,$00A0,$0000,$0000,$0000,$0000,$0000  
L00010A3C   dc.w    $0000,$0000,$0000,$0500,$0000,$0102,$8800,$0000  
L00010A4C   dc.w    $0428,$0000,$0000,$1420,$0000,$0051,$4080,$0000  
L00010A5C   dc.w    $00A0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L00010A6C   dc.w    $0000,$0500,$0000,$0102,$8A00,$0000,$0428,$0000  
L00010A7C   dc.w    $0000,$1E20,$0000,$0012,$0080,$0000,$00A0,$0000  
L00010A8C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0500  
L00010A9C   dc.w    $0000,$0100,$4800,$0000,$0478,$0000,$0000,$0A20  
L00010AAC   dc.w    $0000,$0011,$4080,$0000,$00A0,$0000,$0000,$0000  
L00010ABC   dc.w    $0000,$0000,$0000,$0000,$0000,$0500,$0000,$0102  
L00010ACC   dc.w    $8800,$0000,$0450,$0000,$0000,$0A20,$0000,$0031  
L00010ADC   dc.w    $4080,$0000,$80A0,$0000,$0000,$0000,$0000,$0000  
L00010AEC   dc.w    $0000,$0000,$0000,$0501,$0000,$0102,$8C00,$0000  
L00010AFC   dc.w    $0450,$0000,$0000,$0A20,$0000,$0011,$4080,$0000  
L00010B0C   dc.w    $40A0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L00010B1C   dc.w    $0000,$0502,$0000,$0102,$8800,$0000,$0450,$0000  
L00010B2C   dc.w    $0000,$0A20,$0000,$0071,$4080,$0000,$00A0,$0000  
L00010B3C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0500  
L00010B4C   dc.w    $0000,$0102,$8E00,$0000,$0450,$0000,$0000,$0A20  
L00010B5C   dc.w    $0000,$0011,$4080,$0000,$00A0,$0000,$0000,$0000  
L00010B6C   dc.w    $0000,$0000,$0000,$0000,$0000,$0500,$0000,$0102  
L00010B7C   dc.w    $8800,$0000,$0450,$0000,$0000,$0A20,$0000,$0091  
L00010B8C   dc.w    $4880,$0000,$00A0,$0000,$0000,$0000,$0000,$0000  
L00010B9C   dc.w    $0000,$0000,$0000,$0500,$0000,$0112,$8900,$0000  
L00010BAC   dc.w    $0450,$0000,$0000,$0A20,$0000,$0051,$4080,$0000  
L00010BBC   dc.w    $00A0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L00010BCC   dc.w    $0000,$0500,$0000,$0102,$8A00,$0000,$0450,$0000  
L00010BDC   dc.w    $0000,$0A20,$0000,$0111,$4080,$2000,$00A0,$0000  
L00010BEC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0500  
L00010BFC   dc.w    $0004,$0102,$88A0,$0000,$0450,$0000,$0000,$0C00  
L00010C0C   dc.w    $0000,$2E01,$4680,$2030,$00A0,$0000,$0000,$0000  
L00010C1C   dc.w    $0000,$0000,$0000,$0000,$0000,$0500,$0C04,$0162  
L00010C2C   dc.w    $8074,$0000,$0030,$0000,$0000,$0930,$0000,$0033  
L00010C3C   dc.w    $8280,$3048,$00A0,$0000,$0000,$0000,$0000,$0000  
L00010C4C   dc.w    $0000,$0000,$0000,$0500,$120C,$0141,$CC00,$0000  
L00010C5C   dc.w    $0C90,$0000,$0000,$0A90,$017D,$0025,$4080,$2028  
L00010C6C   dc.w    $00A0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L00010C7C   dc.w    $0000,$0500,$1404,$0102,$A400,$BE80,$0950,$0000  
L00010C8C   dc.w    $0000,$156A,$AA00,$2A82,$A080,$1000,$00A0,$0000  
L00010C9C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0500  
L00010CAC   dc.w    $0008,$0105,$4154,$0055,$56A8,$0000,$0000,$147F  
L00010CBC   dc.w    $FA0A,$FF18,$A080,$2800,$00A0,$0000,$0000,$0000  
L00010CCC   dc.w    $0000,$0000,$0000,$0000,$0000,$0500,$0014,$0105  
L00010CDC   dc.w    $18FF,$505F,$FE28,$0000,$0000,$0A80,$0000,$000D  
L00010CEC   dc.w    $2080,$3000,$00A0,$0000,$0000,$0000,$0000,$0000  
L00010CFC   dc.w    $0000,$0000,$0000,$0500,$000C,$0104,$B000,$0000  
L00010D0C   dc.w    $0150,$0000,$0000,$0917,$FFFF,$FFA6,$4080,$1000  
L00010D1C   dc.w    $00E0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L00010D2C   dc.w    $0000,$0700,$0008,$0102,$65FF,$FFFF,$E890,$0000  
L00010D3C   dc.w    $0000,$0C30,$0000,$0033,$8080,$1000,$00A0,$0000  
L00010D4C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0500  
L00010D5C   dc.w    $0008,$0101,$CC00,$0000,$0C30,$0000,$0000,$0A00  
L00010D6C   dc.w    $8000,$0001,$4080,$4800,$00E0,$0000,$0000,$0000  
L00010D7C   dc.w    $0000,$0000,$0000,$0000,$0000,$0700,$0012,$0102  
L00010D8C   dc.w    $8000,$0017,$0050,$0000,$0000,$0A21,$0000,$0011  
L00010D9C   dc.w    $4080,$2400,$00E0,$0000,$0000,$0000,$0000,$0000  
L00010DAC   dc.w    $0000,$0000,$0000,$0700,$0024,$0102,$8800,$0000  
L00010DBC   dc.w    $0450,$0000,$0000,$0A24,$0000,$0011,$4080,$1000  
L00010DCC   dc.w    $00A0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L00010DDC   dc.w    $0000,$0500,$0008,$0102,$8800,$0000,$2450,$0000  
L00010DEC   dc.w    $0000,$0A22,$0000,$0011,$4080,$0800,$00A0,$0000  
L00010DFC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0500  
L00010E0C   dc.w    $0010,$0102,$8800,$0000,$4450,$0000,$0000,$0A20  
L00010E1C   dc.w    $0000,$0011,$4080,$0000,$00A0,$0000,$0000,$0000  
L00010E2C   dc.w    $0000,$0000,$0000,$0000,$0000,$0500,$0000,$0102  
L00010E3C   dc.w    $8800,$0000,$0450,$0000,$0000,$0A2C,$0000,$0011  
L00010E4C   dc.w    $4080,$0000,$00E0,$0000,$0000,$0000,$0000,$0000  
L00010E5C   dc.w    $0000,$0000,$0000,$0700,$0000,$0102,$8800,$0000  
L00010E6C   dc.w    $3450,$0000,$0000,$0A20,$0000,$0011,$4080,$0000  
L00010E7C   dc.w    $00E0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L00010E8C   dc.w    $0000,$0700,$0000,$0102,$8800,$0000,$0450,$0000  
L00010E9C   dc.w    $0000,$0A28,$0000,$0011,$4080,$0000,$00A0,$0000  
L00010EAC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0500  
L00010EBC   dc.w    $0000,$0102,$8800,$0000,$1450,$0000,$0000,$0A20  
L00010ECC   dc.w    $0000,$0011,$4080,$0000,$00A0,$0000,$0000,$0000  
L00010EDC   dc.w    $0000,$0000,$0000,$0000,$0000,$0500,$0000,$0102  
L00010EEC   dc.w    $8800,$0000,$0450,$0000,$0000,$0A20,$0000,$0011  
L00010EFC   dc.w    $4080,$0000,$00E0,$0000,$0000,$0000,$0000,$0000  
L00010F0C   dc.w    $0000,$0000,$0000,$0700,$0000,$0102,$8800,$0000  
L00010F1C   dc.w    $0450,$0000,$0000,$0A24,$0000,$0011,$4080,$0000  
L00010F2C   dc.w    $00A0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L00010F3C   dc.w    $0000,$0500,$0000,$0102,$8800,$0000,$2450,$0000  
L00010F4C   dc.w    $0000,$0E20,$0000,$0012,$2084,$BF40,$08A0,$0000  
L00010F5C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0510  
L00010F6C   dc.w    $02FD,$2104,$4800,$0000,$0470,$0000,$0000,$1E20  
L00010F7C   dc.w    $0000,$0010,$0080,$0000,$24A0,$0000,$0000,$0000  
L00010F8C   dc.w    $0000,$0000,$0000,$0000,$0000,$0524,$0000,$0100  
L00010F9C   dc.w    $0800,$0000,$0478,$0000,$0000,$1420,$0000,$0011  
L00010FAC   dc.w    $C080,$0000,$1AA0,$0000,$0000,$0000,$0000,$0000  
L00010FBC   dc.w    $0000,$0000,$0000,$0558,$0000,$0103,$8800,$0000  
L00010FCC   dc.w    $0428,$0000,$0000,$D4A0,$0000,$0011,$4C80,$0000  
L00010FDC   dc.w    $08A0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L00010FEC   dc.w    $0000,$0510,$0000,$0132,$8800,$0000,$052B,$0000  
L00010FFC   dc.w    $0000,$1420,$0000,$0015,$4080,$0000,$04A0,$0000  
L0001100C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0520  
L0001101C   dc.w    $0000,$0102,$A800,$0000,$0428,$0000,$0000,$D4A0  
L0001102C   dc.w    $0000,$0015,$4C80,$0000,$04A0,$0000,$0000,$0000  
L0001103C   dc.w    $0000,$0000,$0000,$0000,$0000,$0520,$0000,$0132  
L0001104C   dc.w    $A800,$0000,$052B,$0000,$0000,$14A0,$0000,$0011  
L0001105C   dc.w    $4080,$0000,$00A0,$0000,$0000,$0000,$0000,$0000  
L0001106C   dc.w    $0000,$0000,$0000,$0500,$0000,$0102,$8800,$0000  
L0001107C   dc.w    $0528,$0000,$0000,$D4A0,$0000,$0015,$4C80,$0000  
L0001108C   dc.w    $00A0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0001109C   dc.w    $0000,$0500,$0000,$0132,$A800,$0000,$052B,$0000  
L000110AC   dc.w    $0000,$1420,$0000,$0051,$4080,$0000,$02A0,$0000  
L000110BC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0540  
L000110CC   dc.w    $0000,$0102,$8A00,$0000,$0428,$0000,$0000,$1420  
L000110DC   dc.w    $0000,$0011,$4080,$0000,$02A0,$0000,$0000,$0000  
L000110EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0540,$0000,$0102  
L000110FC   dc.w    $8800,$0000,$0428,$0000,$0000,$1E20,$0000,$0012  
L0001110C   dc.w    $0080,$0000,$02A0,$0000,$0000,$0000,$0000,$0000  
L0001111C   dc.w    $0000,$0000,$0000,$0540,$0000,$0100,$4800,$0000  
L0001112C   dc.w    $0478,$0000,$0000,$0A20,$0000,$0031,$4080,$0000  
L0001113C   dc.w    $00A0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0001114C   dc.w    $0000,$0500,$0000,$0102,$8C00,$0000,$0450,$0000  
L0001115C   dc.w    $0000,$0A20,$0000,$0011,$4080,$0000,$02A0,$0000  
L0001116C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0540  
L0001117C   dc.w    $0000,$0102,$8800,$0000,$0450,$0000,$0000,$0A20  
L0001118C   dc.w    $0000,$0071,$4080,$0001,$00A0,$0000,$0000,$0000  
L0001119C   dc.w    $0000,$0000,$0000,$0000,$0000,$0500,$0000,$0102  
L000111AC   dc.w    $8E00,$0000,$0450,$0000,$0000,$0A20,$0000,$0011  
L000111BC   dc.w    $4080,$0070,$00A0,$0000,$0000,$0000,$0000,$0000  
L000111CC   dc.w    $0000,$0000,$0000,$0500,$0000,$0102,$8800,$0000  
L000111DC   dc.w    $0450,$0000,$0000,$0A20,$0000,$0091,$4080,$1800  
L000111EC   dc.w    $82A0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L000111FC   dc.w    $0000,$0540,$0200,$0102,$8900,$0000,$0450,$0000  
L0001120C   dc.w    $0000,$0A20,$0000,$0051,$4080,$1489,$40A0,$0000  
L0001121C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0500  
L0001122C   dc.w    $0100,$0102,$8A00,$0000,$0450,$0000,$0000,$0A20  
L0001123C   dc.w    $0000,$0511,$4080,$2000,$20A0,$0000,$0000,$0000  
L0001124C   dc.w    $0000,$0000,$0000,$0000,$0000,$0500,$0080,$0102  
L0001125C   dc.w    $88A0,$0000,$0450,$0000,$0000,$0C00,$0000,$2E01  
L0001126C   dc.w    $4080,$2000,$20A0,$0000,$0000,$0000,$0000,$0000  
L0001127C   dc.w    $0000,$0000,$0000,$0500,$0040,$0102,$8074,$0000  
L0001128C   dc.w    $0030,$0000,$0000,$0930,$0000,$0033,$8080,$0000  
L0001129C   dc.w    $00A0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L000112AC   dc.w    $0000,$0500,$0000,$0101,$CC00,$0000,$0C90,$0000  
L000112BC   dc.w    $0000,$0A90,$017D,$0025,$4080,$2000,$20A0,$0000  
L000112CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0500  
L000112DC   dc.w    $0000,$0102,$A400,$BE80,$0950,$0000,$0000,$156A  
L000112EC   dc.w    $AA00,$2A82,$A080,$1408,$40A0,$0000,$0000,$0000  
L000112FC   dc.w    $0000,$0000,$0000,$0000,$0000,$0500,$0000,$0105  
L0001130C   dc.w    $4154,$0055,$56A8,$0000,$0000,$147F,$FA0A,$FF18  
L0001131C   dc.w    $A080,$0010,$00A1,$0000,$0000,$0000,$0000,$0000  
L0001132C   dc.w    $0000,$0000,$0000,$8500,$0000,$0105,$18FF,$505F  
L0001133C   dc.w    $FE28,$0000,$0000,$0A80,$0000,$000D,$2080,$0000  
L0001134C   dc.w    $00A0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0001135C   dc.w    $0000,$0500,$0000,$0104,$B000,$0000,$0150,$0000  
L0001136C   dc.w    $0000,$0917,$FFFF,$FFA6,$4080,$0000,$00E0,$0000  
L0001137C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0700  
L0001138C   dc.w    $0000,$0102,$65FF,$FFFF,$E890,$0000,$0000,$0C30  
L0001139C   dc.w    $0000,$0033,$8280,$0000,$00A0,$0000,$0000,$0000  
L000113AC   dc.w    $0000,$0000,$0000,$0000,$0000,$0500,$0000,$0141  
L000113BC   dc.w    $CC00,$0000,$0C30,$0000,$0000,$0A00,$E800,$0001  
L000113CC   dc.w    $4480,$0000,$00E1,$0000,$0000,$0000,$0000,$0000  
L000113DC   dc.w    $0000,$0000,$0000,$8700,$0000,$0122,$8000,$0000  
L000113EC   dc.w    $0050,$0000,$0000,$0A21,$0000,$0011,$4080,$0000  
L000113FC   dc.w    $00E0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0001140C   dc.w    $0000,$0700,$0000,$0102,$8800,$0000,$0450,$0000  
L0001141C   dc.w    $0000,$0A24,$0000,$0011,$4080,$0000,$00E0,$8000  
L0001142C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0001,$0700  
L0001143C   dc.w    $0000,$0102,$8800,$0000,$2450,$0000,$0000,$0A22  
L0001144C   dc.w    $0000,$0011,$48C0,$0000,$00F1,$8000,$0000,$0000  
L0001145C   dc.w    $0000,$0000,$0000,$0000,$0001,$8F00,$0000,$0312  
L0001146C   dc.w    $8800,$0000,$0450,$0000,$0000,$0A20,$0000,$0011  
L0001147C   dc.w    $4080,$0000,$00D8,$8000,$0000,$0000,$0000,$0000  
L0001148C   dc.w    $0000,$0000,$0001,$1B00,$0000,$0102,$8800,$0000  
L0001149C   dc.w    $0450,$0000,$0000,$0A2C,$0000,$0011,$40C0,$0000  
L000114AC   dc.w    $00E8,$2000,$0000,$0000,$0000,$0000,$0000,$0000  
L000114BC   dc.w    $0004,$1700,$0000,$0302,$8800,$0000,$3450,$0000  
L000114CC   dc.w    $0000,$0A20,$0000,$0011,$40E0,$0000,$0068,$0400  
L000114DC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0020,$1600  
L000114EC   dc.w    $0000,$0702,$8800,$0000,$0450,$0000,$0000,$0A28  
L000114FC   dc.w    $0000,$0011,$40B0,$0000,$0068,$0000,$0000,$0000  
L0001150C   dc.w    $0000,$0000,$0000,$0000,$0000,$1600,$0000,$0D02  
L0001151C   dc.w    $8800,$0000,$1450,$0000,$0000,$0A20,$0000,$0011  
L0001152C   dc.w    $4117,$E800,$01D0,$0000,$0000,$0000,$0000,$0000  
L0001153C   dc.w    $0000,$0000,$0000,$0B80,$0017,$E882,$8800,$0000  
L0001154C   dc.w    $0450,$0000,$0000,$0A20,$0000,$0011,$4000,$0000  
L0001155C   dc.w    $0000,$1FFF,$D001,$17FF,$FFFF,$FFFD,$2002,$FFFF  
L0001156C   dc.w    $FFF8,$0000,$0000,$0002,$8800,$0000,$0450,$0000  
L0001157C   dc.w    $0000,$0A24,$0000,$0011,$43FF,$FFFF,$FFFF,$FC00  
L0001158C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$003F,$FFFF  
L0001159C   dc.w    $FFFF,$FFC2,$8800,$0000,$2450,$0000,$0000,$0E20  
L000115AC   dc.w    $0000,$0012,$2604,$5F2B,$FFF8,$1400,$0000,$0000  
L000115BC   dc.w    $0000,$0000,$0000,$0000,$0028,$1FFF,$D4FA,$2064  
L000115CC   dc.w    $4800,$0000,$0470,$0000,$0000,$1E20,$0000,$0010  
L000115DC   dc.w    $05FF,$FFFF,$FFFF,$9800,$0000,$0000,$0000,$0000  
L000115EC   dc.w    $0000,$0000,$0019,$FFFF,$FFFF,$FFA0,$0800,$0000  
L000115FC   dc.w    $0478,$0000,$0000,$1420,$0000,$0011,$C600,$0000  
L0001160C   dc.w    $0000,$6000,$0000,$0000,$0000,$0000,$0000,$0000  
L0001161C   dc.w    $0006,$0000,$0000,$0063,$8800,$0000,$0428,$0000  
L0001162C   dc.w    $0000,$D4A0,$0000,$0011,$4400,$0000,$0000,$201E  
L0001163C   dc.w    $8000,$0000,$0000,$0000,$0000,$0000,$1804,$0000  
L0001164C   dc.w    $0000,$0022,$8800,$0000,$052B,$0000,$0000,$1420  
L0001165C   dc.w    $0000,$0015,$4400,$0000,$0000,$203F,$FFFF,$FFFF  
L0001166C   dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FC04,$0000,$0000,$0022  
L0001167C   dc.w    $A800,$0000,$0428,$0000,$0000,$D4A0,$0000,$0015  
L0001168C   dc.w    $4000,$0000,$0000,$2060,$0000,$0000,$0000,$0000  
L0001169C   dc.w    $0000,$0000,$0604,$0000,$0000,$0002,$A800,$0000  
L000116AC   dc.w    $052B,$0000,$0000,$14A0,$0000,$0011,$45FF,$EC5F  
L000116BC   dc.w    $FFA1,$A040,$0000,$0000,$0000,$0000,$0000,$0000  
L000116CC   dc.w    $0205,$85FF,$FA37,$FFA2,$8800,$0000,$0528,$0000  
L000116DC   dc.w    $0000,$D4A0,$0000,$0015,$4000,$0000,$0000,$0040  
L000116EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0200,$0000  
L000116FC   dc.w    $0000,$0002,$A800,$0000,$052B,$0000,$0000,$1420  
L0001170C   dc.w    $0000,$0051,$4000,$0000,$0000,$2040,$80FF,$FFFF  
L0001171C   dc.w    $FFFF,$FFFF,$FFFE,$0000,$0204,$0000,$0000,$0002  
L0001172C   dc.w    $8A00,$0000,$0428,$0000,$0000,$1420,$0000,$0011  
L0001173C   dc.w    $4400,$0000,$0000,$0040,$0000,$0000,$0000,$0000  
L0001174C   dc.w    $0000,$0000,$0200,$0000,$0000,$0022,$8800,$0000  
L0001175C   dc.w    $0428,$0000,$0000,$1E20,$0000,$0012,$01FF,$FF1F  
L0001176C   dc.w    $FFE8,$8001,$0000,$0000,$0000,$0000,$0000,$0000  
L0001177C   dc.w    $0001,$17FF,$F8FF,$FF80,$4800,$0000,$0478,$0000  
L0001178C   dc.w    $0000,$0A20,$0000,$0031,$4000,$0000,$0000,$0000  
L0001179C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L000117AC   dc.w    $0000,$0002,$8C00,$0000,$0450,$0000,$0000,$0A20  
L000117BC   dc.w    $0000,$0011,$4000,$0000,$0000,$0000,$0000,$001C  
L000117CC   dc.w    $0000,$E000,$0380,$0000,$0000,$0000,$0000,$0002  
L000117DC   dc.w    $8800,$0000,$0450,$0000,$0000,$0A20,$0000,$0071  
L000117EC   dc.w    $4000,$0000,$0000,$0000,$0000,$0041,$0002,$0800  
L000117FC   dc.w    $0820,$0000,$0000,$0000,$0000,$0002,$8E00,$0000  
L0001180C   dc.w    $0450,$0000,$0000,$0A20,$0000,$0011,$41FF,$FFEF  
L0001181C   dc.w    $FFFA,$8000,$0000,$001C,$0000,$E000,$0380,$000A  
L0001182C   dc.w    $0001,$5FFF,$F7FF,$FF82,$8800,$0000,$0450,$0000  
L0001183C   dc.w    $0000,$0A20,$0000,$0091,$4000,$0000,$0000,$2000  
L0001184C   dc.w    $0000,$0422,$0021,$1080,$0442,$0004,$0004,$0000  
L0001185C   dc.w    $0000,$0002,$8900,$0000,$0450,$0000,$0000,$0A20  
L0001186C   dc.w    $0000,$0051,$4000,$0000,$0000,$2000,$0000,$0000  
L0001187C   dc.w    $0000,$0000,$0000,$0000,$0004,$0000,$0000,$0002  
L0001188C   dc.w    $8A00,$0000,$0450,$0000,$0000,$0A20,$0000,$0111  
L0001189C   dc.w    $4000,$0000,$0000,$2000,$0000,$0041,$0002,$0800  
L000118AC   dc.w    $0820,$0000,$0004,$0000,$0000,$0002,$88A0,$0000  
L000118BC   dc.w    $0450,$0000,$0000,$0C00,$0000,$2E01,$40FF,$FF4B  
L000118CC   dc.w    $FFFE,$C000,$0000,$0022,$0001,$1000,$0440,$0000  
L000118DC   dc.w    $0003,$7FFF,$D2FF,$FF02,$8074,$0000,$0030,$0000  
L000118EC   dc.w    $0000,$0930,$0000,$0033,$8000,$0000,$0000,$2000  
L000118FC   dc.w    $0000,$001C,$0000,$E000,$0380,$0000,$0004,$0000  
L0001190C   dc.w    $0000,$0001,$CC00,$0000,$0C90,$0000,$0000,$0A90  
L0001191C   dc.w    $017D,$0025,$4000,$0000,$0000,$2000,$0000,$0000  
L0001192C   dc.w    $0000,$0000,$0000,$0000,$0004,$0000,$0000,$0002  
L0001193C   dc.w    $A400,$BE80,$0950,$0000,$0000,$156A,$AA00,$2A82  
L0001194C   dc.w    $8000,$0000,$0000,$2000,$0000,$0000,$0000,$0000  
L0001195C   dc.w    $0000,$0000,$0004,$0000,$0000,$0001,$4154,$0055  
L0001196C   dc.w    $56A8,$0000,$0000,$147F,$FA0A,$FF18,$8000,$0000  
L0001197C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0001198C   dc.w    $0000,$0000,$0000,$0001,$18FF,$505F,$FE28,$0000  
L0001199C   dc.w    $0000,$0AFF,$FFFF,$FFFD,$0000,$0000,$0000,$0000  
L000119AC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L000119BC   dc.w    $0000,$0000,$BFFF,$FFFF,$FF50,$0000,$0000,$0000  
L000119CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L000119DC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L000119EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L000119FC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L00011A0C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L00011A1C   dc.w    $0000,$0000,$0000,$0200,$02FD,$0003,$0300,$0000  
L00011A2C   dc.w    $0200,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L00011A3C   dc.w    $0000,$0040,$0000,$00C0,$C000,$BF40,$0040,$0000  
L00011A4C   dc.w    $0000,$04FF,$FFFF,$FFFC,$8600,$0000,$0000,$0000  
L00011A5C   dc.w    $0003,$FFFF,$FFFF,$FFFF,$FFFC,$1FFB,$F800,$0000  
L00011A6C   dc.w    $0000,$0061,$3FFF,$FFFF,$FF20,$0000,$0000,$09BC  
L00011A7C   dc.w    $60FF,$FFFE,$4CFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF  
L00011A8C   dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FF32  
L00011A9C   dc.w    $7FFF,$FF06,$3D90,$0000,$0000,$1B60,$0000,$001B  
L00011AAC   dc.w    $6DFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF  
L00011ABC   dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFB6,$D800,$0000  
L00011ACC   dc.w    $06D8,$0000,$0000,$1B40,$FF00,$000B,$6D00,$0000  
L00011ADC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L00011AEC   dc.w    $0000,$0000,$0000,$00B6,$D000,$00FF,$02D8,$0000  
L00011AFC   dc.w    $0000,$1B67,$0000,$001B,$6C7F,$FFFF,$FFFF,$FFFF  
L00011B0C   dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF  
L00011B1C   dc.w    $FFFF,$FE36,$D800,$0000,$66D8,$0000,$0000,$1B68  
L00011B2C   dc.w    $8000,$001B,$6CFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF  
L00011B3C   dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FF36  
L00011B4C   dc.w    $D800,$0000,$16D8,$0000,$0000,$1B6B,$0000,$001B  
L00011B5C   dc.w    $6DFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF  
L00011B6C   dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFB6,$D800,$0000  
L00011B7C   dc.w    $56D8,$0000,$0000,$1B6A,$0000,$001B,$6F55,$5555  
L00011B8C   dc.w    $57FF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF  
L00011B9C   dc.w    $FFFF,$FFEA,$AAAA,$AAF6,$D800,$0000,$56D8,$0000  
L00011BAC   dc.w    $0000,$1B6D,$0000,$001B,$6E00,$0000,$03FF,$FFFF  
L00011BBC   dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFC0  
L00011BCC   dc.w    $0000,$0076,$D800,$0000,$36D8,$0000,$0000,$1B6A  
L00011BDC   dc.w    $0000,$001B,$601F,$FFFF,$FE00,$0000,$0000,$0000  
L00011BEC   dc.w    $0000,$0000,$0000,$0000,$0000,$007F,$FFFF,$F806  
L00011BFC   dc.w    $D800,$0000,$56D8,$0000,$0000,$1B6D,$0000,$001B  
L00011C0C   dc.w    $6078,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L00011C1C   dc.w    $0000,$0000,$0000,$0000,$0000,$1E06,$D800,$0000  
L00011C2C   dc.w    $36D8,$0000,$0000,$1B6A,$0000,$001B,$61BF,$FFB0  
L00011C3C   dc.w    $07FF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF  
L00011C4C   dc.w    $FFFF,$FFE0,$0DFF,$FD86,$D800,$0000,$56D8,$0000  
L00011C5C   dc.w    $0000,$1B65,$0000,$001B,$61A8,$0000,$F2E3,$E800  
L00011C6C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0017,$C74F  
L00011C7C   dc.w    $0000,$1586,$D800,$0000,$26D8,$0000,$0000,$2E6E  
L00011C8C   dc.w    $0000,$001B,$F1A8,$0000,$39C8,$0000,$0000,$0000  
L00011C9C   dc.w    $0000,$0000,$0000,$0000,$0000,$139C,$0000,$158F  
L00011CAC   dc.w    $D800,$0000,$7674,$0000,$0000,$3164,$0000,$001A  
L00011CBC   dc.w    $B1A8,$0000,$1994,$0000,$0000,$0000,$0000,$0000  
L00011CCC   dc.w    $0000,$0000,$0000,$2998,$0000,$158D,$5800,$0000  
L00011CDC   dc.w    $268C,$0000,$0000,$F1EA,$0000,$001F,$6DA8,$0000  
L00011CEC   dc.w    $0D8C,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L00011CFC   dc.w    $0800,$31B0,$0000,$15B6,$F800,$0000,$578F,$0000  
L00011D0C   dc.w    $0000,$3164,$0000,$0019,$61A8,$0000,$0D98,$3FD4  
L00011D1C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$2BFC,$19B0  
L00011D2C   dc.w    $0000,$1586,$9800,$0000,$268C,$0000,$0000,$F1E0  
L00011D3C   dc.w    $0000,$0059,$61A8,$0000,$0DB9,$D000,$0000,$0000  
L00011D4C   dc.w    $0000,$0000,$0000,$0000,$000B,$9DB0,$0000,$1586  
L00011D5C   dc.w    $9A00,$0000,$078F,$0000,$0000,$3164,$0000,$0019  
L00011D6C   dc.w    $61A8,$0000,$07B2,$2000,$0000,$0000,$0000,$0000  
L00011D7C   dc.w    $0000,$0000,$0004,$4DE0,$0000,$1586,$9800,$0000  
L00011D8C   dc.w    $268C,$0000,$0000,$3160,$0000,$0059,$61A8,$0000  
L00011D9C   dc.w    $07B2,$C000,$0000,$0000,$0000,$0000,$0000,$0000  
L00011DAC   dc.w    $0003,$4DE0,$0000,$1586,$9A00,$0000,$068C,$0000  
L00011DBC   dc.w    $0000,$F1E0,$0000,$00BD,$6DA8,$0000,$03B2,$8000  
L00011DCC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0001,$4DC0  
L00011DDC   dc.w    $0000,$15B6,$BD00,$0000,$078F,$0000,$0000,$F1E0  
L00011DEC   dc.w    $0000,$0059,$6DA8,$0000,$03B3,$4000,$0000,$0000  
L00011DFC   dc.w    $0000,$0000,$0000,$0000,$0002,$CDC0,$0000,$15B6  
L00011E0C   dc.w    $9A00,$0000,$078F,$0000,$0000,$31E0,$0000,$00FF  
L00011E1C   dc.w    $71A8,$0000,$03B2,$8000,$0000,$0000,$0000,$0000  
L00011E2C   dc.w    $0000,$0000,$0001,$4DC0,$0000,$158E,$FF00,$0000  
L00011E3C   dc.w    $078C,$0000,$0000,$3E60,$0000,$015B,$F1A8,$0000  
L00011E4C   dc.w    $03B3,$4000,$0000,$0000,$0000,$0000,$0000,$0000  
L00011E5C   dc.w    $0002,$CDC0,$0000,$158F,$DA80,$0000,$067C,$0000  
L00011E6C   dc.w    $0000,$1B60,$0000,$00BB,$61A8,$0000,$03B2,$8000  
L00011E7C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0001,$4DC0  
L00011E8C   dc.w    $0000,$1586,$DD00,$0000,$06D8,$0000,$0000,$1B60  
L00011E9C   dc.w    $0000,$017B,$61A8,$0000,$03B1,$4000,$0000,$0000  
L00011EAC   dc.w    $0000,$0000,$0000,$0000,$0002,$8DC0,$0000,$1586  
L00011EBC   dc.w    $DE80,$0000,$06D8,$0000,$0000,$1B60,$0000,$00BB  
L00011ECC   dc.w    $61A8,$0000,$03B3,$8000,$0000,$0000,$0000,$0000  
L00011EDC   dc.w    $0000,$0000,$0001,$CDC0,$0000,$1586,$DD00,$0000  
L00011EEC   dc.w    $06D8,$0000,$0000,$1B60,$0000,$017B,$61A8,$0000  
L00011EFC   dc.w    $01B1,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L00011F0C   dc.w    $0000,$8D80,$0000,$1586,$DE80,$0000,$06D8,$0000  
L00011F1C   dc.w    $0000,$1B60,$0000,$00BB,$71A8,$00F0,$01B2,$8000  
L00011F2C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0001,$4D80  
L00011F3C   dc.w    $0F00,$158E,$DD00,$0000,$06D8,$0000,$0000,$1B60  
L00011F4C   dc.w    $0000,$01BB,$61A8,$0108,$01B1,$0000,$0000,$0000  
L00011F5C   dc.w    $0000,$0000,$0000,$0000,$0000,$8D80,$1080,$1586  
L00011F6C   dc.w    $DD80,$0000,$06D8,$0000,$0000,$1B60,$0000,$003B  
L00011F7C   dc.w    $69A8,$02F4,$01B0,$0000,$0000,$0000,$0000,$0000  
L00011F8C   dc.w    $0000,$0000,$0000,$0D80,$2F40,$1596,$DC40,$0000  
L00011F9C   dc.w    $06D8,$0000,$0000,$1B60,$0000,$01DB,$69A8,$050A  
L00011FAC   dc.w    $01B1,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L00011FBC   dc.w    $0000,$8D80,$50A0,$1596,$DBA0,$0000,$06D8,$0000  
L00011FCC   dc.w    $0000,$1FC0,$0001,$FE0F,$65A8,$0AE5,$01B0,$0000  
L00011FDC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0D80  
L00011FEC   dc.w    $A750,$15A6,$F07F,$8000,$03F8,$0000,$0000,$19E0  
L00011FFC   dc.w    $03FC,$001F,$E5A8,$05F2,$01B0,$0000,$0000,$0000  
L0001200C   dc.w    $0000,$0000,$0000,$0000,$0000,$0D80,$4FA0,$15A7  
L0001201C   dc.w    $F800,$3FC0,$0798,$0000,$0000,$18F0,$0000,$003C  
L0001202C   dc.w    $73A8,$147A,$81B0,$0000,$0000,$0000,$0000,$0000  
L0001203C   dc.w    $0000,$0000,$0000,$0D81,$5E28,$15CE,$3C00,$0000  
L0001204C   dc.w    $0F18,$0000,$0000,$327F,$FF55,$7FF1,$31A8,$151A  
L0001205C   dc.w    $81B0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0001206C   dc.w    $0000,$0D81,$58A8,$158C,$8FFE,$AAFF,$FE4C,$0000  
L0001207C   dc.w    $0000,$3380,$05F5,$001F,$31A8,$05C2,$01B0,$0000  
L0001208C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0D80  
L0001209C   dc.w    $43A0,$158C,$F800,$AFA0,$01CC,$0000,$0000,$18FF  
L000120AC   dc.w    $FFFF,$FFFC,$31A8,$09FD,$01B0,$0000,$0000,$0000  
L000120BC   dc.w    $0000,$0000,$0000,$0000,$0000,$0D80,$BF90,$158C  
L000120CC   dc.w    $3FFF,$FFFF,$FF18,$0000,$0000,$19F7,$FFFF,$FFBE  
L000120DC   dc.w    $61A8,$00FA,$01B0,$0000,$0000,$0000,$0000,$0000  
L000120EC   dc.w    $0000,$0000,$0000,$0D80,$5F00,$1586,$7DFF,$FFFF  
L000120FC   dc.w    $EF98,$0000,$0000,$1FE0,$0000,$001F,$E1A8,$00F4  
L0001210C   dc.w    $01B0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0001211C   dc.w    $0000,$0D80,$2F00,$1587,$F800,$0000,$07F8,$0000  
L0001212C   dc.w    $0000,$1B40,$FF00,$000B,$61A8,$0008,$01B0,$0000  
L0001213C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0D80  
L0001214C   dc.w    $1000,$1586,$D000,$00FF,$02D8,$0000,$0000,$1B67  
L0001215C   dc.w    $0000,$001B,$61A8,$00F0,$01B0,$0000,$0000,$0000  
L0001216C   dc.w    $0000,$0000,$0000,$0000,$0000,$0D80,$0F00,$1586  
L0001217C   dc.w    $D800,$0000,$66D8,$0000,$0000,$1B68,$8000,$001B  
L0001218C   dc.w    $71A8,$0000,$01B0,$0000,$0000,$0000,$0000,$0000  
L0001219C   dc.w    $0000,$0000,$0000,$0D80,$0000,$158E,$D800,$0000  
L000121AC   dc.w    $16D8,$0000,$0000,$1B6B,$0000,$001B,$69A8,$0000  
L000121BC   dc.w    $01B0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L000121CC   dc.w    $0000,$0D80,$0000,$1596,$D800,$0000,$56D8,$0000  
L000121DC   dc.w    $0000,$1B6A,$0000,$001B,$6DA8,$0000,$01B0,$0000  
L000121EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0D80  
L000121FC   dc.w    $0000,$15B6,$D800,$0000,$56D8,$0000,$0000,$1B6D  
L0001220C   dc.w    $0000,$001B,$67A8,$0000,$01B0,$0000,$0000,$0000  
L0001221C   dc.w    $0000,$0000,$0000,$0000,$0000,$0D80,$0000,$15E6  
L0001222C   dc.w    $D800,$0000,$36D8,$0000,$0000,$1B6A,$0000,$001B  
L0001223C   dc.w    $67A8,$0000,$01B0,$0000,$0000,$0000,$0000,$0000  
L0001224C   dc.w    $0000,$0000,$0000,$0D80,$0000,$15E6,$D800,$0000  
L0001225C   dc.w    $56D8,$0000,$0000,$1B6D,$0000,$001B,$61A8,$0000  
L0001226C   dc.w    $01B0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0001227C   dc.w    $0000,$0D80,$0000,$1586,$D800,$0000,$36D8,$0000  
L0001228C   dc.w    $0000,$1B6A,$0000,$001B,$61A8,$0000,$01B0,$0000  
L0001229C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0D80  
L000122AC   dc.w    $0000,$1586,$D800,$0000,$56D8,$0000,$0000,$1B65  
L000122BC   dc.w    $0000,$001B,$61A8,$0000,$01B0,$0000,$0000,$0000  
L000122CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0D80,$0000,$1586  
L000122DC   dc.w    $D800,$0000,$26D8,$0000,$0000,$2E6E,$0000,$001B  
L000122EC   dc.w    $F1A8,$0000,$01B0,$0000,$0000,$0000,$0000,$0000  
L000122FC   dc.w    $0000,$0000,$0000,$0D80,$0000,$158F,$D800,$0000  
L0001230C   dc.w    $7674,$0000,$0000,$3164,$0000,$001A,$B1A8,$0000  
L0001231C   dc.w    $01B0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0001232C   dc.w    $0000,$0D80,$0000,$158D,$5800,$0000,$268C,$0000  
L0001233C   dc.w    $0000,$F1EA,$0000,$001F,$7DA8,$0000,$01B0,$0000  
L0001234C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0D80  
L0001235C   dc.w    $0000,$15BE,$F800,$0000,$578F,$0000,$0000,$3164  
L0001236C   dc.w    $0000,$001B,$71A8,$0000,$01B0,$0000,$0000,$0000  
L0001237C   dc.w    $0000,$0000,$0000,$0000,$0000,$0D80,$0000,$158E  
L0001238C   dc.w    $D800,$0000,$268C,$0000,$0000,$F1E0,$0000,$005B  
L0001239C   dc.w    $7DA8,$0000,$01B0,$0000,$0000,$0000,$0000,$0000  
L000123AC   dc.w    $0000,$0000,$0000,$0D80,$0000,$15BE,$DA00,$0000  
L000123BC   dc.w    $078F,$0000,$0000,$3164,$0000,$001B,$71A8,$0000  
L000123CC   dc.w    $01B0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L000123DC   dc.w    $0000,$0D80,$0000,$158E,$D800,$0000,$268C,$0000  
L000123EC   dc.w    $0000,$31E0,$0000,$005B,$71A8,$0000,$01B0,$0000  
L000123FC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0D80  
L0001240C   dc.w    $0000,$158E,$DA00,$0000,$078C,$0000,$0000,$F1E0  
L0001241C   dc.w    $0000,$00BF,$7DA8,$0000,$01B0,$0000,$0000,$0000  
L0001242C   dc.w    $0000,$0000,$0000,$0000,$0000,$0D80,$0000,$15BE  
L0001243C   dc.w    $FD00,$0000,$078F,$0000,$0000,$F1E0,$0000,$005F  
L0001244C   dc.w    $7DA8,$0000,$01B0,$0000,$0000,$0000,$0000,$0000  
L0001245C   dc.w    $0000,$0000,$0000,$0D80,$0000,$15BE,$FA00,$0000  
L0001246C   dc.w    $078F,$0000,$0000,$31E0,$0000,$00FF,$71A8,$0000  
L0001247C   dc.w    $01B0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0001248C   dc.w    $0000,$0D80,$0000,$158E,$FF00,$0000,$078C,$0000  
L0001249C   dc.w    $0000,$3E60,$0000,$015B,$F1A8,$01FC,$01B0,$0000  
L000124AC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0D80  
L000124BC   dc.w    $3F80,$158F,$DA80,$0000,$067C,$0000,$0000,$1B60  
L000124CC   dc.w    $0000,$00BB,$61A8,$0603,$01B0,$0000,$0000,$0000  
L000124DC   dc.w    $0000,$0000,$0000,$0000,$0000,$0D80,$C060,$1586  
L000124EC   dc.w    $DD00,$0000,$06D8,$0000,$0000,$1B60,$0000,$017B  
L000124FC   dc.w    $61A8,$0800,$81B0,$0000,$0000,$0000,$0000,$0000  
L0001250C   dc.w    $0000,$0000,$0000,$0D81,$0010,$1586,$DE80,$0000  
L0001251C   dc.w    $06D8,$0000,$0000,$1B60,$0000,$00BB,$61A8,$1000  
L0001252C   dc.w    $41B0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0001253C   dc.w    $0000,$0D82,$0008,$1586,$DD00,$0000,$06D8,$0000  
L0001254C   dc.w    $0000,$1B60,$0000,$017B,$61A8,$2400,$21B0,$0000  
L0001255C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0D84  
L0001256C   dc.w    $0024,$1586,$DE80,$0000,$06D8,$0000,$0000,$1B60  
L0001257C   dc.w    $0000,$00BB,$79A8,$4800,$11B0,$0000,$0000,$0000  
L0001258C   dc.w    $0000,$0000,$0000,$0000,$0000,$0D88,$0012,$159E  
L0001259C   dc.w    $DD00,$0000,$06D8,$0000,$0000,$1B60,$0000,$01BB  
L000125AC   dc.w    $7DA8,$9500,$09B0,$0000,$0000,$0000,$0000,$0000  
L000125BC   dc.w    $0000,$0000,$0000,$0D90,$00A9,$15BE,$DD80,$0000  
L000125CC   dc.w    $06D8,$0000,$0000,$1B60,$0000,$003B,$75A8,$BA00  
L000125DC   dc.w    $09B0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L000125EC   dc.w    $0000,$0D90,$005D,$15AE,$DC40,$0000,$06D8,$0000  
L000125FC   dc.w    $0000,$1B60,$0000,$01DB,$6BA9,$7F00,$05B0,$0000  
L0001260C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0DA0  
L0001261C   dc.w    $00FE,$95D6,$DBA0,$0000,$06D8,$0000,$0000,$1FC0  
L0001262C   dc.w    $0000,$7E0F,$6FA9,$7E40,$05B0,$0000,$0000,$0000  
L0001263C   dc.w    $0000,$0000,$0000,$0000,$0000,$0DA0,$027E,$95F6  
L0001264C   dc.w    $F07E,$0000,$03F8,$0000,$0000,$19E0,$0000,$001F  
L0001265C   dc.w    $EFA9,$7CD0,$05B0,$0000,$0000,$0000,$0000,$0000  
L0001266C   dc.w    $0000,$0000,$0000,$0DA0,$0B3E,$95F7,$F800,$0000  
L0001267C   dc.w    $0798,$0000,$0000,$18F0,$0000,$003C,$77A9,$7CA0  
L0001268C   dc.w    $05B0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0001269C   dc.w    $0000,$0DA0,$053E,$95EE,$3C00,$0000,$0F18,$0000  
L000126AC   dc.w    $0000,$327F,$FF55,$7FF9,$33A9,$5CC8,$05B0,$0000  
L000126BC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0DA0  
L000126CC   dc.w    $133A,$95CC,$9FFE,$AAFF,$FE4C,$0000,$0000,$3380  
L000126DC   dc.w    $05F5,$001F,$33A9,$6C70,$05B0,$0000,$0000,$0000  
L000126EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0DA0,$0E36,$95CC  
L000126FC   dc.w    $F800,$AFA0,$01CC,$0000,$0000,$18FF,$FFFF,$FFFC  
L0001270C   dc.w    $33A9,$6C00,$05B0,$0000,$0000,$0000,$0000,$0000  
L0001271C   dc.w    $0000,$0000,$0000,$0DA0,$0036,$95CC,$3FFF,$FFFF  
L0001272C   dc.w    $FF18,$0000,$0000,$19F7,$FFFF,$FFBE,$61A8,$B600  
L0001273C   dc.w    $09B0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0001274C   dc.w    $0000,$0D90,$006D,$1586,$7DFF,$FFFF,$EF98,$0000  
L0001275C   dc.w    $0000,$1FE0,$0000,$001F,$E1A8,$BF00,$09B0,$0000  
L0001276C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0D90  
L0001277C   dc.w    $00FD,$1587,$F800,$0000,$07F8,$0000,$0000,$1B40  
L0001278C   dc.w    $8000,$000B,$61A8,$5E00,$11B0,$0000,$0000,$0000  
L0001279C   dc.w    $0000,$0000,$0000,$0000,$0000,$0D88,$007A,$1586  
L000127AC   dc.w    $D000,$0AFF,$02D8,$0000,$0000,$1B67,$0000,$001B  
L000127BC   dc.w    $61A8,$2F00,$21B0,$0000,$0000,$0000,$0000,$0000  
L000127CC   dc.w    $0000,$0000,$0000,$0D84,$00F4,$1586,$D800,$0000  
L000127DC   dc.w    $66D8,$0000,$0000,$1B68,$8000,$001B,$61A8,$1600  
L000127EC   dc.w    $41F0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L000127FC   dc.w    $0000,$0F82,$0068,$1586,$D800,$0000,$16D8,$0000  
L0001280C   dc.w    $0000,$1B6B,$0000,$001B,$61A8,$09C0,$81F0,$0000  
L0001281C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0F81  
L0001282C   dc.w    $0390,$1586,$D800,$0000,$56D8,$0000,$0000,$1B6A  
L0001283C   dc.w    $0000,$001B,$61A8,$0603,$01F0,$0000,$0000,$0000  
L0001284C   dc.w    $0000,$0000,$0000,$0000,$0000,$0F80,$C060,$1586  
L0001285C   dc.w    $D800,$0000,$56D8,$0000,$0000,$1B6D,$0000,$001B  
L0001286C   dc.w    $61A8,$01FC,$01B0,$0000,$0000,$0000,$0000,$0000  
L0001287C   dc.w    $0000,$0000,$0000,$0D80,$3F80,$1586,$D800,$0000  
L0001288C   dc.w    $36D8,$0000,$0000,$1B6A,$0000,$001B,$61A8,$0000  
L0001289C   dc.w    $01B0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L000128AC   dc.w    $0000,$0D80,$0000,$1586,$D800,$0000,$56D8,$0000  
L000128BC   dc.w    $0000,$1B6D,$0000,$001B,$61A8,$0000,$01B0,$0000  
L000128CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0D80  
L000128DC   dc.w    $0000,$1586,$D800,$0000,$36D8,$0000,$0000,$1B6A  
L000128EC   dc.w    $0000,$001B,$61A8,$0000,$01B0,$0000,$0000,$0000  
L000128FC   dc.w    $0000,$0000,$0000,$0000,$0000,$0D80,$0000,$1586  
L0001290C   dc.w    $D800,$0000,$56D8,$0000,$0000,$1B65,$0000,$001B  
L0001291C   dc.w    $61A8,$0000,$03B0,$0000,$0000,$0000,$0000,$0000  
L0001292C   dc.w    $0000,$0000,$0000,$0DC0,$0000,$1586,$D800,$0000  
L0001293C   dc.w    $26D8,$0000,$0000,$1B6E,$0000,$001B,$61BF,$FFFF  
L0001294C   dc.w    $FFB0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L0001295C   dc.w    $0000,$0DFF,$FFFF,$FD86,$D800,$0000,$76D8,$0000  
L0001296C   dc.w    $0000,$2E64,$0000,$001B,$F1BF,$FF40,$07B0,$0000  
L0001297C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0DE0  
L0001298C   dc.w    $02FF,$FD8F,$D800,$0000,$2674,$0000,$0000,$316A  
L0001299C   dc.w    $0000,$001A,$B1A8,$0000,$E3B0,$0000,$0000,$0000  
L000129AC   dc.w    $0000,$0000,$0000,$0000,$0000,$0DC7,$0000,$158D  
L000129BC   dc.w    $5800,$0000,$568C,$0000,$0000,$F1E4,$0000,$001F  
L000129CC   dc.w    $7DA8,$0000,$79B0,$0000,$0000,$0000,$0000,$0000  
L000129DC   dc.w    $0000,$0000,$0000,$0D9E,$0000,$15BE,$F800,$0000  
L000129EC   dc.w    $278F,$0000,$0000,$3160,$0000,$005B,$71A8,$0000  
L000129FC   dc.w    $39B0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L00012A0C   dc.w    $0000,$0D9C,$0000,$158E,$DA00,$0000,$068C,$0000  
L00012A1C   dc.w    $0000,$F1E4,$0000,$001B,$7DA8,$0000,$1DB0,$0000  
L00012A2C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0DB8  
L00012A3C   dc.w    $0000,$15BE,$D800,$0000,$278F,$0000,$0000,$3160  
L00012A4C   dc.w    $0000,$005B,$71A8,$0000,$0DB0,$0000,$0000,$0000  
L00012A5C   dc.w    $0000,$0000,$0000,$0000,$0000,$0DB0,$0000,$158E  
L00012A6C   dc.w    $DA00,$0000,$068C,$0000,$0000,$31E0,$0000,$00BB  
L00012A7C   dc.w    $71A8,$0000,$05B0,$0000,$0000,$0000,$0000,$0000  
L00012A8C   dc.w    $0000,$0000,$0000,$0DA0,$0000,$158E,$DD00,$0000  
L00012A9C   dc.w    $078C,$0000,$0000,$F1E0,$0000,$005F,$7DA8,$0000  
L00012AAC   dc.w    $05B0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L00012ABC   dc.w    $0000,$0DA0,$0000,$15BE,$FA00,$0000,$078F,$0000  
L00012ACC   dc.w    $0000,$F1E0,$0000,$00FF,$7DA8,$0000,$03B0,$0000  
L00012ADC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0DC0  
L00012AEC   dc.w    $0000,$15BE,$FF00,$0000,$078F,$0000,$0000,$31E0  
L00012AFC   dc.w    $0000,$015F,$71A8,$0000,$03B0,$0000,$0000,$0000  
L00012B0C   dc.w    $0000,$0000,$0000,$0000,$0000,$0DC0,$0000,$158E  
L00012B1C   dc.w    $FA80,$0000,$078C,$0000,$0000,$3E60,$0000,$00BB  
L00012B2C   dc.w    $F1A8,$0000,$03B0,$0000,$0000,$0000,$0000,$0000  
L00012B3C   dc.w    $0000,$0000,$0000,$0DC0,$0000,$158F,$DD00,$0000  
L00012B4C   dc.w    $067C,$0000,$0000,$1B60,$0000,$017B,$61A8,$0000  
L00012B5C   dc.w    $03B0,$0000,$0000,$0000,$0000,$0000,$0000,$0000  
L00012B6C   dc.w    $0000,$0DC0,$0000,$1586,$DE80,$0000,$06D8,$0000  
L00012B7C   dc.w    $0000,$1B60,$0000,$00BB,$61A8,$0000,$03B0,$0000  
L00012B8C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0DC0  
L00012B9C   dc.w    $0000,$1586,$DD00,$0000,$06D8,$0000,$0000,$1B60  
L00012BAC   dc.w    $0000,$017B,$61A8,$0450,$03B0,$0000,$0000,$0000
L00012BBC   dc.w    $0000,$0000,$0000,$0000,$0000,$0DC0,$0000,$1586
L00012BCC   dc.w    $DE80,$0000,$06D8,$0000,$0000,$1B60,$0000,$00BB
L00012BDC   dc.w    $61A8,$0800,$83B0,$0000,$0000,$0000,$0000,$0000
L00012BEC   dc.w    $0000,$0000,$0000,$0DC0,$0000,$1586,$DD00,$0000
L00012BFC   dc.w    $06D8,$0000,$0000,$1B60,$0000,$01BB,$61A8,$0800
L00012C0C   dc.w    $C3B0,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00012C1C   dc.w    $0000,$0DC0,$0600,$1586,$DD80,$0000,$06D8,$0000
L00012C2C   dc.w    $0000,$1B60,$0000,$003B,$61A8,$0489,$03B0,$0000
L00012C3C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0DC0
L00012C4C   dc.w    $0F80,$1586,$DC40,$0000,$06D8,$0000,$0000,$1B60
L00012C5C   dc.w    $0000,$05DB,$61A8,$0306,$03B1,$0000,$0000,$0000
L00012C6C   dc.w    $0000,$0000,$0000,$0000,$0000,$8DC0,$0B80,$1586
L00012C7C   dc.w    $DBA0,$0000,$06D8,$0000,$0000,$1FC0,$0015,$FE0F
L00012C8C   dc.w    $61A8,$0000,$03B0,$0000,$0000,$0000,$0000,$0000
L00012C9C   dc.w    $0000,$0000,$0000,$0DC0,$0CC0,$1586,$F07F,$A800
L00012CAC   dc.w    $03F8,$0000,$0000,$19E0,$0000,$001F,$E1A8,$0000
L00012CBC   dc.w    $03B1,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00012CCC   dc.w    $0000,$8DC0,$0F40,$1587,$F800,$0000,$0798,$0000
L00012CDC   dc.w    $0000,$18F0,$0000,$003C,$71A8,$2206,$23B2,$8000
L00012CEC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0001,$4DC0
L00012CFC   dc.w    $0FC0,$158E,$3C00,$0000,$0F18,$0000,$0000,$327F
L00012D0C   dc.w    $FF55,$7FF9,$31A8,$158D,$43B1,$0000,$0000,$0000
L00012D1C   dc.w    $0000,$0000,$0000,$0000,$0000,$8DC0,$0780,$158C
L00012D2C   dc.w    $9FFE,$AAFF,$FE4C,$0000,$0000,$3380,$05F5,$001F
L00012D3C   dc.w    $31A8,$19D4,$C3B3,$8000,$0000,$0000,$0000,$0000
L00012D4C   dc.w    $0000,$0000,$0001,$CDC0,$0000,$158C,$F800,$AFA0
L00012D5C   dc.w    $01CC,$0000,$0000,$18FF,$FFFF,$FFFC,$31A8,$0820
L00012D6C   dc.w    $81B1,$4000,$0000,$0000,$0000,$0000,$0000,$0000
L00012D7C   dc.w    $0002,$8DC0,$0000,$158C,$3FFF,$FFFF,$FF18,$0000
L00012D8C   dc.w    $0000,$19F7,$FFFF,$FFBE,$63A8,$0421,$01B2,$8000
L00012D9C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0001,$4DC0
L00012DAC   dc.w    $0000,$15C6,$7DFF,$FFFF,$EF98,$0000,$0000,$1FE0
L00012DBC   dc.w    $0000,$001F,$E3A8,$0000,$01B3,$4000,$0000,$0000
L00012DCC   dc.w    $0000,$0000,$0000,$0000,$0002,$CDC0,$0000,$15C7
L00012DDC   dc.w    $F800,$0000,$07F8,$0000,$0000,$1B40,$FF50,$000B
L00012DEC   dc.w    $61A8,$0000,$01B3,$8000,$0000,$0000,$0000,$0000
L00012DFC   dc.w    $0000,$0000,$0001,$CDC0,$0000,$1586,$D000,$0000
L00012E0C   dc.w    $02D8,$0000,$0000,$1B67,$0000,$001B,$61A8,$0000
L00012E1C   dc.w    $01B2,$4000,$0000,$0000,$0000,$0000,$0000,$0000
L00012E2C   dc.w    $0002,$4DC0,$0000,$1586,$D800,$0000,$26D8,$0000
L00012E3C   dc.w    $0000,$1B68,$8000,$001B,$61A8,$0000,$01B8,$8000
L00012E4C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0001,$1DC0
L00012E5C   dc.w    $0000,$1586,$D800,$0000,$16D8,$0000,$0000,$1B6B
L00012E6C   dc.w    $0000,$001B,$6BA8,$0000,$01D9,$C000,$0000,$0000
L00012E7C   dc.w    $0000,$0000,$0000,$0000,$0003,$9BC0,$0000,$15D6
L00012E8C   dc.w    $D800,$0000,$16D8,$0000,$0000,$1B6A,$0000,$001B
L00012E9C   dc.w    $6FA8,$0000,$01CD,$A804,$0000,$0000,$0000,$0000
L00012EAC   dc.w    $0000,$0000,$0015,$B380,$0000,$15F6,$D800,$0000
L00012EBC   dc.w    $16D8,$0000,$0000,$1B6D,$0000,$001B,$6DA8,$0000
L00012ECC   dc.w    $01E1,$F7F8,$0000,$0000,$0000,$0000,$0000,$0000
L00012EDC   dc.w    $1FEF,$8780,$0000,$15B6,$D800,$0000,$36D8,$0000
L00012EEC   dc.w    $0000,$1B6A,$0000,$001B,$79B8,$0000,$01E4,$7FD4
L00012EFC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$2BFE,$2780
L00012F0C   dc.w    $0000,$1D9E,$D800,$0000,$16D8,$0000,$0000,$1B6D
L00012F1C   dc.w    $0000,$001B,$719F,$FFFF,$FFE6,$0000,$0000,$0000
L00012F2C   dc.w    $0000,$0000,$0000,$0000,$0000,$67FF,$FFFF,$F98E
L00012F3C   dc.w    $D800,$0000,$36D8,$0000,$0000,$1B6A,$0000,$001B
L00012F4C   dc.w    $6107,$E800,$01CF,$8000,$0000,$0000,$0000,$0000
L00012F5C   dc.w    $0000,$0000,$0001,$F380,$0017,$E086,$D800,$0000
L00012F6C   dc.w    $16D8,$0000,$0000,$1B65,$0000,$001B,$67FF,$FFFF
L00012F7C   dc.w    $FFFE,$1FFF,$D000,$0000,$0000,$0000,$0002,$FFFF
L00012F8C   dc.w    $FFF8,$7FFF,$FFFF,$FFE6,$D800,$0000,$26D8,$0000
L00012F9C   dc.w    $0000,$1B6E,$0000,$001B,$6FFF,$FFFF,$FFFF,$FFFF
L00012FAC   dc.w    $FFFF,$FC00,$7FFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L00012FBC   dc.w    $FFFF,$FFF6,$D800,$0000,$36D8,$0000,$0000,$2E64
L00012FCC   dc.w    $0000,$001B,$EE00,$0000,$0007,$E400,$0000,$0000
L00012FDC   dc.w    $0000,$0000,$0000,$0000,$0027,$E000,$0000,$0077
L00012FEC   dc.w    $D800,$0000,$2674,$0000,$0000,$316A,$0000,$001A
L00012FFC   dc.w    $ADFF,$FFFF,$FFC0,$6E00,$0000,$0000,$0000,$0000
L0001300C   dc.w    $0000,$0000,$0076,$03FF,$FFFF,$FFB5,$5800,$0000
L0001301C   dc.w    $168C,$0000,$0000,$F1E4,$0000,$001F,$6FFF,$FFFF
L0001302C   dc.w    $FFFF,$8A40,$0000,$0000,$0000,$0000,$0000,$0000
L0001303C   dc.w    $0251,$FFFF,$FFFF,$FFF6,$F800,$0000,$278F,$0000
L0001304C   dc.w    $0000,$3160,$0000,$0059,$6FFF,$FFFF,$FFFF,$CA01
L0001305C   dc.w    $7FFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$E053,$FFFF
L0001306C   dc.w    $FFFF,$FFF6,$9A00,$0000,$068C,$0000,$0000,$F1E4
L0001307C   dc.w    $0000,$0019,$6E00,$0000,$0000,$483F,$FFFF,$FFFF
L0001308C   dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FC12,$0000,$0000,$0076
L0001309C   dc.w    $9800,$0000,$278F,$0000,$0000,$3160,$0000,$0059
L000130AC   dc.w    $6E00,$0000,$0000,$4A7F,$FFFF,$FFFF,$FFFF,$FFFF
L000130BC   dc.w    $FFFF,$FFFF,$FE52,$0000,$0000,$0076,$9A00,$0000
L000130CC   dc.w    $068C,$0000,$0000,$31E0,$0000,$00B9,$6FFF,$EC5F
L000130DC   dc.w    $FFA0,$487F,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L000130EC   dc.w    $FE12,$05FF,$FA37,$FFF6,$9D00,$0000,$078C,$0000
L000130FC   dc.w    $0000,$F1E0,$0000,$005D,$6FFF,$FFFF,$FFFF,$CA7E
L0001310C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$3E53,$FFFF
L0001311C   dc.w    $FFFF,$FFF6,$BA00,$0000,$078F,$0000,$0000,$F1E0
L0001312C   dc.w    $0000,$00F9,$6E00,$0000,$0000,$687C,$0000,$0000
L0001313C   dc.w    $0000,$0000,$0000,$0000,$1E16,$0000,$0000,$0076
L0001314C   dc.w    $9F00,$0000,$078F,$0000,$0000,$31E0,$0000,$015F
L0001315C   dc.w    $6E00,$0000,$0000,$487C,$0000,$0000,$0000,$0000
L0001316C   dc.w    $0000,$0000,$3E12,$0000,$0000,$0076,$FA80,$0000
L0001317C   dc.w    $078C,$0000,$0000,$3E60,$0000,$00BB,$EFFF,$FF1F
L0001318C   dc.w    $FFE8,$487D,$0000,$0000,$0000,$0000,$0000,$0000
L0001319C   dc.w    $3E12,$17FF,$F8FF,$FFF7,$DD00,$0000,$067C,$0000
L000131AC   dc.w    $0000,$1B60,$0000,$017B,$6FFF,$FFFF,$FFFF,$C87D
L000131BC   dc.w    $0000,$001C,$0000,$E000,$0380,$0000,$3E13,$FFFF
L000131CC   dc.w    $FFFF,$FFF6,$DE80,$0000,$06D8,$0000,$0000,$1B60
L000131DC   dc.w    $0000,$00BB,$6E00,$0000,$0000,$487D,$0000,$0063
L000131EC   dc.w    $0003,$1800,$0C60,$0000,$3E12,$0000,$0000,$0076
L000131FC   dc.w    $DD00,$0000,$06D8,$0000,$0000,$1B60,$0000,$017B
L0001320C   dc.w    $6E00,$0000,$0000,$487D,$0000,$0000,$0000,$0000
L0001321C   dc.w    $0000,$0004,$3E12,$0000,$0000,$0076,$DE80,$0000
L0001322C   dc.w    $06D8,$0000,$0000,$1B60,$0000,$00BB,$6FFF,$FFEF
L0001323C   dc.w    $FFFA,$487D,$0000,$009C,$8004,$E400,$1390,$0004
L0001324C   dc.w    $3E12,$5FFF,$F7FF,$FFF6,$DD00,$0000,$06D8,$0000
L0001325C   dc.w    $0000,$1B60,$0000,$01BB,$6FFF,$FFFF,$FFFF,$E87D
L0001326C   dc.w    $0000,$0CBE,$8065,$F4C0,$17D3,$0000,$3E17,$FFFF
L0001327C   dc.w    $FFFF,$FFF6,$DD80,$0000,$06D8,$0000,$0000,$1B60
L0001328C   dc.w    $0000,$003B,$6E00,$0000,$0000,$687D,$0000,$00BE
L0001329C   dc.w    $8005,$F400,$1450,$0000,$3E16,$0000,$0000,$0076
L000132AC   dc.w    $DC40,$0000,$06D8,$0000,$0000,$1B60,$0000,$01DB
L000132BC   dc.w    $6E00,$0000,$0000,$687D,$0000,$0041,$0002,$0800
L000132CC   dc.w    $0C60,$0000,$3E16,$0000,$0000,$0076,$DBA0,$0000
L000132DC   dc.w    $06D8,$0000,$0000,$1FC0,$0015,$FE0F,$6FFF,$FF4B
L000132EC   dc.w    $FFFE,$887D,$0000,$0063,$0003,$1800,$0FE0,$0000
L000132FC   dc.w    $3E11,$7FFF,$D2FF,$FFF6,$F07F,$A800,$03F8,$0000
L0001330C   dc.w    $0000,$19E0,$0000,$001F,$EFFF,$FFFF,$FFFF,$E87D
L0001331C   dc.w    $0000,$001C,$0000,$E000,$0380,$0000,$3E17,$FFFF
L0001332C   dc.w    $FFFF,$FFF7,$F800,$0000,$0798,$0000,$0000,$18F0
L0001333C   dc.w    $0000,$003C,$6E00,$0000,$0000,$687D,$0000,$0000
L0001334C   dc.w    $0000,$0000,$0000,$0000,$3E16,$0000,$0000,$0076
L0001335C   dc.w    $3C00,$0000,$0F18,$0000,$0000,$327F,$FF55,$7FF9
L0001336C   dc.w    $2FFF,$FFFF,$FFFF,$E87C,$FFFF,$FFFF,$FFFF,$FFFF
L0001337C   dc.w    $FFFF,$FFFF,$FE17,$FFFF,$FFFF,$FFF4,$9FFE,$AAFF
L0001338C   dc.w    $FE4C,$0000,$0000,$3380,$05F5,$001F,$2FFF,$FFFF
L0001339C   dc.w    $FFFF,$F800,$0000,$0000,$0000,$0000,$0000,$0000
L000133AC   dc.w    $001F,$FFFF,$FFFF,$FFF4,$F800,$AFA0,$01CC,$0000
L000133BC   dc.w    $0000,$18FF,$FFFF,$FFFC,$2000,$0000,$0000,$0000
L000133CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000133DC   dc.w    $0000,$0004,$3FFF,$FFFF,$FF18,$0000,$0000,$1FFF
L000133EC   dc.w    $FFFF,$FFFF,$E000,$0000,$0000,$0000,$0000,$0000
L000133FC   dc.w    $4000,$0000,$0000,$0000,$0000,$0000,$0000,$0007
L0001340C   dc.w    $FFFF,$FFFF,$FFF8,$0000,$0000,$0000,$0000,$0000
L0001341C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001342C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001343C   dc.w    $0000,$0000,$0000,$01FF,$FFFF,$FFFE,$00FF,$FFFF
L0001344C   dc.w    $FC00,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001345C   dc.w    $0000,$003F,$FFFF,$FF00,$7FFF,$FFFF,$FF80,$0000
L0001346C   dc.w    $0000,$0300,$0000,$0003,$01FF,$FFFF,$FE00,$0000
L0001347C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$007F
L0001348C   dc.w    $FFFF,$FF80,$C000,$0000,$00C0,$0000,$0000,$0603
L0001349C   dc.w    $FF00,$0001,$83FF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L000134AC   dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFC1
L000134BC   dc.w    $8000,$00FF,$C060,$0000,$0000,$0410,$0000,$0020
L000134CC   dc.w    $83FF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L000134DC   dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFC1,$0400,$0000
L000134EC   dc.w    $0820,$0000,$0000,$0421,$0000,$0010,$83FF,$FFFF
L000134FC   dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L0001350C   dc.w    $FFFF,$FFFF,$FFFF,$FFC1,$0800,$0000,$8420,$0000
L0001351C   dc.w    $0000,$0402,$0000,$0000,$8380,$0000,$0000,$0000
L0001352C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001353C   dc.w    $0000,$01C1,$0000,$0000,$4020,$0000,$0000,$0406
L0001354C   dc.w    $0000,$0000,$8300,$0000,$0000,$0000,$0000,$0000
L0001355C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$00C1
L0001356C   dc.w    $0000,$0000,$6020,$0000,$0000,$0404,$0000,$0000
L0001357C   dc.w    $8200,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001358C   dc.w    $0000,$0000,$0000,$0000,$0000,$0041,$0000,$0000
L0001359C   dc.w    $2020,$0000,$0000,$0404,$0000,$0000,$8000,$0000
L000135AC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000135BC   dc.w    $0000,$0000,$0000,$0001,$0000,$0000,$2020,$0000
L000135CC   dc.w    $0000,$0400,$0000,$0000,$8000,$0000,$0000,$0000
L000135DC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000135EC   dc.w    $0000,$0001,$0000,$0000,$0020,$0000,$0000,$0404
L000135FC   dc.w    $0000,$0000,$8000,$0000,$0000,$0000,$0000,$0000
L0001360C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0001
L0001361C   dc.w    $0000,$0000,$2020,$0000,$0000,$0400,$0000,$0000
L0001362C   dc.w    $8000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001363C   dc.w    $0000,$0000,$0000,$0000,$0000,$0001,$0000,$0000
L0001364C   dc.w    $0020,$0000,$0000,$0404,$0000,$0000,$8040,$004F
L0001365C   dc.w    $FF80,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001366C   dc.w    $0000,$01FF,$F200,$0201,$0000,$0000,$2020,$0000
L0001367C   dc.w    $0000,$0400,$0000,$0000,$8040,$0000,$0F1F,$FFFF
L0001368C   dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$F8F0
L0001369C   dc.w    $0000,$0201,$0000,$0000,$0020,$0000,$0000,$1100
L000136AC   dc.w    $0000,$0000,$0040,$0000,$063F,$FFFF,$FFFF,$FFFF
L000136BC   dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FC60,$0000,$0200
L000136CC   dc.w    $0000,$0000,$0088,$0000,$0000,$0E00,$0000,$0001
L000136DC   dc.w    $C040,$0000,$0678,$0000,$0000,$0000,$0000,$0000
L000136EC   dc.w    $0000,$0000,$0000,$1E60,$0000,$0203,$8000,$0000
L000136FC   dc.w    $0070,$0000,$0000,$0E00,$0000,$0000,$8040,$0000
L0001370C   dc.w    $0270,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001371C   dc.w    $0000,$0E40,$0000,$0201,$0000,$0000,$0070,$0000
L0001372C   dc.w    $0000,$CE80,$0000,$0004,$8C40,$0000,$0260,$4000
L0001373C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0002,$0640
L0001374C   dc.w    $0000,$0231,$2000,$0000,$0173,$0000,$0000,$CE80
L0001375C   dc.w    $0000,$0004,$8C40,$0000,$0240,$8000,$0000,$0000
L0001376C   dc.w    $0000,$0000,$0000,$0000,$0001,$0240,$0000,$0231
L0001377C   dc.w    $2000,$0000,$0173,$0000,$0000,$CE80,$0000,$0004
L0001378C   dc.w    $8C40,$0000,$0041,$8000,$0000,$0000,$0000,$0000
L0001379C   dc.w    $0000,$0000,$0001,$8200,$0000,$0231,$2000,$0000
L000137AC   dc.w    $0173,$0000,$0000,$CE80,$0000,$0004,$8C40,$0000
L000137BC   dc.w    $0041,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000137CC   dc.w    $0000,$8200,$0000,$0231,$2000,$0000,$0173,$0000
L000137DC   dc.w    $0000,$0E00,$0000,$0000,$8040,$0000,$0041,$0000
L000137EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$8200
L000137FC   dc.w    $0000,$0201,$0000,$0000,$0070,$0000,$0000,$0E00
L0001380C   dc.w    $0000,$0000,$8040,$0000,$0040,$0000,$0000,$0000
L0001381C   dc.w    $0000,$0000,$0000,$0000,$0000,$0200,$0000,$0201
L0001382C   dc.w    $0000,$0000,$0070,$0000,$0000,$0E00,$0000,$0000
L0001383C   dc.w    $8040,$0000,$0041,$0000,$0000,$0000,$0000,$0000
L0001384C   dc.w    $0000,$0000,$0000,$8200,$0000,$0201,$0000,$0000
L0001385C   dc.w    $0070,$0000,$0000,$0100,$0000,$0000,$0040,$0000
L0001386C   dc.w    $0040,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001387C   dc.w    $0000,$0200,$0000,$0200,$0000,$0000,$0080,$0000
L0001388C   dc.w    $0000,$0400,$0000,$0040,$8040,$0000,$0041,$0000
L0001389C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$8200
L000138AC   dc.w    $0000,$0201,$0200,$0000,$0020,$0000,$0000,$0400
L000138BC   dc.w    $0000,$0000,$8040,$0000,$0040,$0000,$0000,$0000
L000138CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0200,$0000,$0201
L000138DC   dc.w    $0000,$0000,$0020,$0000,$0000,$0400,$0000,$0040
L000138EC   dc.w    $8040,$0000,$0040,$0000,$0000,$0000,$0000,$0000
L000138FC   dc.w    $0000,$0000,$0000,$0200,$0000,$0201,$0200,$0000
L0001390C   dc.w    $0020,$0000,$0000,$0400,$0000,$0000,$8040,$0000
L0001391C   dc.w    $0040,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001392C   dc.w    $0000,$0200,$0000,$0201,$0000,$0000,$0020,$0000
L0001393C   dc.w    $0000,$0400,$0000,$0040,$8040,$0000,$0040,$0000
L0001394C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0200
L0001395C   dc.w    $0000,$0201,$0200,$0000,$0020,$0000,$0000,$0400
L0001396C   dc.w    $0000,$0040,$8840,$0000,$0040,$0000,$0000,$0000
L0001397C   dc.w    $0000,$0000,$0000,$0000,$0000,$0200,$0000,$0211
L0001398C   dc.w    $0200,$0000,$0020,$0000,$0000,$0400,$0000,$00C0
L0001399C   dc.w    $8040,$0000,$0040,$0000,$0000,$0000,$0000,$0000
L000139AC   dc.w    $0000,$0000,$0000,$0200,$0000,$0201,$0300,$0000
L000139BC   dc.w    $0020,$0000,$0000,$0400,$0000,$0080,$8040,$0000
L000139CC   dc.w    $0040,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000139DC   dc.w    $0000,$0200,$0000,$0201,$0100,$0000,$0020,$0000
L000139EC   dc.w    $0000,$0020,$0000,$0110,$8040,$0030,$0040,$0000
L000139FC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0200
L00013A0C   dc.w    $0C00,$0201,$0880,$0000,$0400,$0000,$0000,$0610
L00013A1C   dc.w    $0000,$0020,$0040,$0018,$0040,$0000,$0000,$0000
L00013A2C   dc.w    $0000,$0000,$0000,$0000,$0000,$0200,$1800,$0200
L00013A3C   dc.w    $0400,$0000,$0860,$0000,$0000,$070F,$FFFF,$FFC3
L00013A4C   dc.w    $8040,$0000,$0040,$0000,$0000,$0000,$0000,$0000
L00013A5C   dc.w    $0000,$0000,$0000,$0200,$0000,$0201,$C3FF,$FFFF
L00013A6C   dc.w    $F0E0,$0000,$0000,$0F80,$00AA,$8007,$C040,$0000
L00013A7C   dc.w    $0040,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00013A8C   dc.w    $0000,$0200,$0000,$0203,$E001,$5500,$01F0,$0000
L00013A9C   dc.w    $0000,$0FFF,$FFFF,$FFE7,$C040,$0000,$0040,$0000
L00013AAC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0200
L00013ABC   dc.w    $0000,$0203,$E7FF,$FFFF,$FFF0,$0000,$0000,$0700
L00013ACC   dc.w    $0000,$0003,$C040,$0200,$0040,$0000,$0000,$0000
L00013ADC   dc.w    $0000,$0000,$0000,$0000,$0000,$0200,$0040,$0203
L00013AEC   dc.w    $C000,$0000,$00E0,$0000,$0000,$0608,$0000,$0041
L00013AFC   dc.w    $8040,$0500,$0040,$0000,$0000,$0000,$0000,$0000
L00013B0C   dc.w    $0000,$0000,$0000,$0200,$00A0,$0201,$8200,$0000
L00013B1C   dc.w    $1060,$0000,$0000,$0010,$0000,$0020,$0040,$0200
L00013B2C   dc.w    $0040,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00013B3C   dc.w    $0000,$0200,$0040,$0200,$0400,$0000,$0800,$0000
L00013B4C   dc.w    $0000,$0421,$0000,$0010,$8040,$0100,$0040,$0000
L00013B5C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0200
L00013B6C   dc.w    $0080,$0201,$0800,$0000,$8420,$0000,$0000,$0402
L00013B7C   dc.w    $0000,$0000,$9040,$0000,$0040,$0000,$0000,$0000
L00013B8C   dc.w    $0000,$0000,$0000,$0000,$0000,$0200,$0000,$0209
L00013B9C   dc.w    $0000,$0000,$4020,$0000,$0000,$0406,$0000,$0000
L00013BAC   dc.w    $8840,$0000,$0040,$0000,$0000,$0000,$0000,$0000
L00013BBC   dc.w    $0000,$0000,$0000,$0200,$0000,$0211,$0000,$0000
L00013BCC   dc.w    $6020,$0000,$0000,$0404,$0000,$0000,$8440,$0000
L00013BDC   dc.w    $0040,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00013BEC   dc.w    $0000,$0200,$0000,$0221,$0000,$0000,$2020,$0000
L00013BFC   dc.w    $0000,$0404,$0000,$0000,$8040,$0000,$0040,$0000
L00013C0C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0200
L00013C1C   dc.w    $0000,$0201,$0000,$0000,$2020,$0000,$0000,$0400
L00013C2C   dc.w    $0000,$0000,$8040,$0000,$0040,$0000,$0000,$0000
L00013C3C   dc.w    $0000,$0000,$0000,$0000,$0000,$0200,$0000,$0201
L00013C4C   dc.w    $0000,$0000,$0020,$0000,$0000,$0404,$0000,$0000
L00013C5C   dc.w    $8040,$0000,$0040,$0000,$0000,$0000,$0000,$0000
L00013C6C   dc.w    $0000,$0000,$0000,$0200,$0000,$0201,$0000,$0000
L00013C7C   dc.w    $2020,$0000,$0000,$0400,$0000,$0000,$8040,$0000
L00013C8C   dc.w    $0040,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00013C9C   dc.w    $0000,$0200,$0000,$0201,$0000,$0000,$0020,$0000
L00013CAC   dc.w    $0000,$0404,$0000,$0000,$8040,$0000,$0040,$0000
L00013CBC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0200
L00013CCC   dc.w    $0000,$0201,$0000,$0000,$2020,$0000,$0000,$0400
L00013CDC   dc.w    $0000,$0000,$8040,$0000,$0040,$0000,$0000,$0000
L00013CEC   dc.w    $0000,$0000,$0000,$0000,$0000,$0200,$0000,$0201
L00013CFC   dc.w    $0000,$0000,$0020,$0000,$0000,$1100,$0000,$0000
L00013D0C   dc.w    $0040,$0000,$0040,$0000,$0000,$0000,$0000,$0000
L00013D1C   dc.w    $0000,$0000,$0000,$0200,$0000,$0200,$0000,$0000
L00013D2C   dc.w    $0088,$0000,$0000,$0E00,$0000,$0001,$C040,$0000
L00013D3C   dc.w    $0040,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00013D4C   dc.w    $0000,$0200,$0000,$0203,$8000,$0000,$0070,$0000
L00013D5C   dc.w    $0000,$0E00,$0000,$0000,$8040,$0000,$0040,$0000
L00013D6C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0200
L00013D7C   dc.w    $0000,$0201,$0000,$0000,$0070,$0000,$0000,$CE80
L00013D8C   dc.w    $0000,$0004,$8C40,$0000,$0040,$0000,$0000,$0000
L00013D9C   dc.w    $0000,$0000,$0000,$0000,$0000,$0200,$0000,$0231
L00013DAC   dc.w    $2000,$0000,$0173,$0000,$0000,$CE80,$0000,$0004
L00013DBC   dc.w    $8C40,$0000,$0040,$0000,$0000,$0000,$0000,$0000
L00013DCC   dc.w    $0000,$0000,$0000,$0200,$0000,$0231,$2000,$0000
L00013DDC   dc.w    $0173,$0000,$0000,$CE80,$0000,$0004,$8C40,$0000
L00013DEC   dc.w    $0040,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00013DFC   dc.w    $0000,$0200,$0000,$0231,$2000,$0000,$0173,$0000
L00013E0C   dc.w    $0000,$CE00,$0000,$0004,$8C40,$0000,$0040,$0000
L00013E1C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0200
L00013E2C   dc.w    $0000,$0231,$2000,$0000,$0073,$0000,$0000,$0E00
L00013E3C   dc.w    $0000,$0000,$8040,$0000,$0040,$0000,$0000,$0000
L00013E4C   dc.w    $0000,$0000,$0000,$0000,$0000,$0200,$0000,$0201
L00013E5C   dc.w    $0000,$0000,$0070,$0000,$0000,$0E00,$0000,$0000
L00013E6C   dc.w    $8040,$0000,$0040,$0000,$0000,$0000,$0000,$0000
L00013E7C   dc.w    $0000,$0000,$0000,$0200,$0000,$0201,$0000,$0000
L00013E8C   dc.w    $0070,$0000,$0000,$0E00,$0000,$0000,$8040,$0000
L00013E9C   dc.w    $0040,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00013EAC   dc.w    $0000,$0200,$0000,$0201,$0000,$0000,$0070,$0000
L00013EBC   dc.w    $0000,$0100,$0000,$0000,$0040,$0000,$0040,$0000
L00013ECC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0200
L00013EDC   dc.w    $0000,$0200,$0000,$0000,$0080,$0000,$0000,$0400
L00013EEC   dc.w    $0000,$0040,$8040,$0000,$0040,$0000,$0000,$0000
L00013EFC   dc.w    $0000,$0000,$0000,$0000,$0000,$0200,$0000,$0201
L00013F0C   dc.w    $0200,$0000,$0020,$0000,$0000,$0400,$0000,$0000
L00013F1C   dc.w    $8040,$0000,$0040,$0000,$0000,$0000,$0000,$0000
L00013F2C   dc.w    $0000,$0000,$0000,$0200,$0000,$0201,$0000,$0000
L00013F3C   dc.w    $0020,$0000,$0000,$0400,$0000,$0040,$8040,$0000
L00013F4C   dc.w    $0040,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00013F5C   dc.w    $0000,$0200,$0000,$0201,$0200,$0000,$0020,$0000
L00013F6C   dc.w    $0000,$0400,$0000,$0000,$8040,$0000,$0040,$0000
L00013F7C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0200
L00013F8C   dc.w    $0000,$0201,$0000,$0000,$0020,$0000,$0000,$0400
L00013F9C   dc.w    $0000,$0040,$8040,$0000,$0040,$0000,$0000,$0000
L00013FAC   dc.w    $0000,$0000,$0000,$0000,$0000,$0200,$0000,$0201
L00013FBC   dc.w    $0200,$0000,$0020,$0000,$0000,$0400,$0000,$0040
L00013FCC   dc.w    $8040,$0000,$0040,$0000,$0000,$0000,$0000,$0000
L00013FDC   dc.w    $0000,$0000,$0000,$0200,$0000,$0201,$0200,$0000
L00013FEC   dc.w    $0020,$0000,$0000,$0400,$0000,$00C0,$8840,$0000
L00013FFC   dc.w    $0040,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001400C   dc.w    $0000,$0200,$0000,$0211,$0300,$0000,$0020,$0000
L0001401C   dc.w    $0000,$0400,$0000,$0080,$8440,$0000,$0040,$0000
L0001402C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0200
L0001403C   dc.w    $0000,$0221,$0100,$0000,$0020,$0000,$0000,$0020
L0001404C   dc.w    $0000,$0110,$8040,$0030,$0040,$0000,$0000,$0000
L0001405C   dc.w    $0000,$0000,$0000,$0000,$0000,$0200,$0C00,$0201
L0001406C   dc.w    $0880,$0000,$0400,$0000,$0000,$0610,$0000,$0020
L0001407C   dc.w    $0040,$0038,$0040,$0000,$0000,$0000,$0000,$0000
L0001408C   dc.w    $0000,$0000,$0000,$0200,$1C00,$0200,$0400,$0000
L0001409C   dc.w    $0860,$0000,$0000,$070F,$FFFF,$FFC3,$8040,$0018
L000140AC   dc.w    $0040,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000140BC   dc.w    $0000,$0200,$1800,$0201,$C3FF,$FFFF,$F0E0,$0000
L000140CC   dc.w    $0000,$0F80,$00AA,$8007,$C040,$2000,$0040,$0000
L000140DC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0200
L000140EC   dc.w    $0004,$0203,$E001,$5500,$01F0,$0000,$0000,$0FFF
L000140FC   dc.w    $FFFF,$FFE7,$C040,$1000,$0040,$0000,$0000,$0000
L0001410C   dc.w    $0000,$0000,$0000,$0000,$0000,$0200,$0008,$0203
L0001411C   dc.w    $E7FF,$FFFF,$FFF0,$0000,$0000,$0700,$0000,$0003
L0001412C   dc.w    $C040,$1000,$0040,$0000,$0000,$0000,$0000,$0000
L0001413C   dc.w    $0000,$0000,$0000,$0200,$0008,$0203,$C000,$0000
L0001414C   dc.w    $00E0,$0000,$0000,$0608,$0000,$0041,$8040,$0800
L0001415C   dc.w    $0040,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001416C   dc.w    $0000,$0200,$0010,$0201,$8200,$0000,$1060,$0000
L0001417C   dc.w    $0000,$0010,$0000,$0020,$0040,$0000,$0040,$0000
L0001418C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0200
L0001419C   dc.w    $0000,$0200,$0400,$0000,$0800,$0000,$0000,$0421
L000141AC   dc.w    $0000,$0010,$8040,$0000,$0040,$0000,$0000,$0000
L000141BC   dc.w    $0000,$0000,$0000,$0000,$0000,$0200,$0000,$0201
L000141CC   dc.w    $0800,$0000,$8420,$0000,$0000,$0402,$0000,$0000
L000141DC   dc.w    $8040,$0000,$0040,$0000,$0000,$0000,$0000,$0000
L000141EC   dc.w    $0000,$0000,$0000,$0200,$0000,$0201,$0000,$0000
L000141FC   dc.w    $4020,$0000,$0000,$0406,$0000,$0000,$8040,$0000
L0001420C   dc.w    $0040,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001421C   dc.w    $0000,$0200,$0000,$0201,$0000,$0000,$6020,$0000
L0001422C   dc.w    $0000,$0404,$0000,$0000,$8040,$0000,$0040,$0000
L0001423C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0200
L0001424C   dc.w    $0000,$0201,$0000,$0000,$2020,$0000,$0000,$0404
L0001425C   dc.w    $0000,$0000,$8040,$0000,$0040,$0000,$0000,$0000
L0001426C   dc.w    $0000,$0000,$0000,$0000,$0000,$0200,$0000,$0201
L0001427C   dc.w    $0000,$0000,$2020,$0000,$0000,$0400,$0000,$0000
L0001428C   dc.w    $8040,$0000,$0040,$0000,$0000,$0000,$0000,$0000
L0001429C   dc.w    $0000,$0000,$0000,$0200,$0000,$0201,$0000,$0000
L000142AC   dc.w    $0020,$0000,$0000,$0404,$0000,$0000,$8040,$0000
L000142BC   dc.w    $0040,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000142CC   dc.w    $0000,$0200,$0000,$0201,$0000,$0000,$2020,$0000
L000142DC   dc.w    $0000,$0400,$0000,$0000,$8040,$0000,$0040,$0000
L000142EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0200
L000142FC   dc.w    $0000,$0201,$0000,$0000,$0020,$0000,$0000,$0404
L0001430C   dc.w    $0000,$0000,$8040,$0000,$0040,$0000,$0000,$0000
L0001431C   dc.w    $0000,$0000,$0000,$0000,$0000,$0200,$0000,$0201
L0001432C   dc.w    $0000,$0000,$2020,$0000,$0000,$0400,$0000,$0000
L0001433C   dc.w    $8040,$0000,$0040,$0000,$0000,$0000,$0000,$0000
L0001434C   dc.w    $0000,$0000,$0000,$0200,$0000,$0201,$0000,$0000
L0001435C   dc.w    $0020,$0000,$0000,$0400,$0000,$0000,$8040,$0000
L0001436C   dc.w    $0040,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001437C   dc.w    $0000,$0200,$0000,$0201,$0000,$0000,$0020,$0000
L0001438C   dc.w    $0000,$1100,$0000,$0000,$0040,$00BF,$FE40,$0000
L0001439C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$027F
L000143AC   dc.w    $FD00,$0200,$0000,$0000,$0088,$0000,$0000,$0E00
L000143BC   dc.w    $0000,$0001,$C040,$0000,$1E40,$0000,$0000,$0000
L000143CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0278,$0000,$0203
L000143DC   dc.w    $8000,$0000,$0070,$0000,$0000,$0E00,$0000,$0000
L000143EC   dc.w    $8040,$0000,$0640,$0000,$0000,$0000,$0000,$0000
L000143FC   dc.w    $0000,$0000,$0000,$0260,$0000,$0201,$0000,$0000
L0001440C   dc.w    $0070,$0000,$0000,$CE80,$0000,$0004,$8C40,$0000
L0001441C   dc.w    $0640,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001442C   dc.w    $0000,$0260,$0000,$0231,$2000,$0000,$0173,$0000
L0001443C   dc.w    $0000,$CE80,$0000,$0004,$8C40,$0000,$0240,$0000
L0001444C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0240
L0001445C   dc.w    $0000,$0231,$2000,$0000,$0173,$0000,$0000,$CE80
L0001446C   dc.w    $0000,$0004,$8C40,$0000,$0240,$0000,$0000,$0000
L0001447C   dc.w    $0000,$0000,$0000,$0000,$0000,$0240,$0000,$0231
L0001448C   dc.w    $2000,$0000,$0173,$0000,$0000,$CE00,$0000,$0004
L0001449C   dc.w    $8C40,$0000,$0240,$0000,$0000,$0000,$0000,$0000
L000144AC   dc.w    $0000,$0000,$0000,$0240,$0000,$0231,$2000,$0000
L000144BC   dc.w    $0073,$0000,$0000,$0E00,$0000,$0000,$8040,$0000
L000144CC   dc.w    $0240,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000144DC   dc.w    $0000,$0240,$0000,$0201,$0000,$0000,$0070,$0000
L000144EC   dc.w    $0000,$0E00,$0000,$0000,$8040,$0000,$0040,$0000
L000144FC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0200
L0001450C   dc.w    $0000,$0201,$0000,$0000,$0070,$0000,$0000,$0E00
L0001451C   dc.w    $0000,$0000,$8040,$0000,$0040,$0000,$0000,$0000
L0001452C   dc.w    $0000,$0000,$0000,$0000,$0000,$0200,$0000,$0201
L0001453C   dc.w    $0000,$0000,$0070,$0000,$0000,$0100,$0000,$0040
L0001454C   dc.w    $0040,$0000,$0040,$0000,$0000,$0000,$0000,$0000
L0001455C   dc.w    $0000,$0000,$0000,$0200,$0000,$0200,$0200,$0000
L0001456C   dc.w    $0080,$0000,$0000,$0400,$0000,$0000,$8040,$0000
L0001457C   dc.w    $0040,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001458C   dc.w    $0000,$0200,$0000,$0201,$0000,$0000,$0020,$0000
L0001459C   dc.w    $0000,$0400,$0000,$0040,$8040,$0000,$0040,$0000
L000145AC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0200
L000145BC   dc.w    $0000,$0201,$0200,$0000,$0020,$0000,$0000,$0400
L000145CC   dc.w    $0000,$0000,$8040,$0451,$0040,$0000,$0000,$0000
L000145DC   dc.w    $0000,$0000,$0000,$0000,$0000,$0200,$0000,$0201
L000145EC   dc.w    $0000,$0000,$0020,$0000,$0000,$0400,$0000,$0040
L000145FC   dc.w    $8040,$0870,$8040,$0000,$0000,$0000,$0000,$0000
L0001460C   dc.w    $0000,$0000,$0000,$0200,$0000,$0201,$0200,$0000
L0001461C   dc.w    $0020,$0000,$0000,$0400,$0000,$0040,$8040,$1050
L0001462C   dc.w    $4040,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001463C   dc.w    $0000,$0200,$0180,$0201,$0200,$0000,$0020,$0000
L0001464C   dc.w    $0000,$0400,$0000,$00C0,$8040,$1000,$4040,$0000
L0001465C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0200
L0001466C   dc.w    $00C0,$0201,$0300,$0000,$0020,$0000,$0000,$0400
L0001467C   dc.w    $0000,$0080,$8040,$2000,$2040,$0000,$0000,$0000
L0001468C   dc.w    $0000,$0000,$0000,$0000,$0000,$0200,$0040,$0201
L0001469C   dc.w    $0100,$0000,$0020,$0000,$0000,$0020,$0000,$0110
L000146AC   dc.w    $8040,$2000,$2040,$0000,$0000,$0000,$0000,$0000
L000146BC   dc.w    $0000,$0000,$0000,$0200,$0000,$0201,$0880,$0000
L000146CC   dc.w    $0400,$0000,$0000,$0610,$0000,$0020,$0040,$2000
L000146DC   dc.w    $2040,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000146EC   dc.w    $0000,$0200,$0000,$0200,$0400,$0000,$0860,$0000
L000146FC   dc.w    $0000,$070F,$FFFF,$FFC3,$8040,$0000,$0040,$0000
L0001470C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0200
L0001471C   dc.w    $0000,$0201,$C3FF,$FFFF,$F0E0,$0000,$0000,$0F80
L0001472C   dc.w    $00AA,$8007,$C040,$0000,$0040,$0000,$0000,$0000
L0001473C   dc.w    $0000,$0000,$0000,$0000,$0000,$0200,$0000,$0203
L0001474C   dc.w    $E001,$5500,$01F0,$0000,$0000,$0FFF,$FFFF,$FFE7
L0001475C   dc.w    $C040,$0000,$0040,$0000,$0000,$0000,$0000,$0000
L0001476C   dc.w    $0000,$0000,$0000,$0200,$0000,$0203,$E7FF,$FFFF
L0001477C   dc.w    $FFF0,$0000,$0000,$0700,$0000,$0003,$C040,$0000
L0001478C   dc.w    $0040,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001479C   dc.w    $0000,$0200,$0000,$0203,$C000,$0000,$00E0,$0000
L000147AC   dc.w    $0000,$0608,$0000,$0041,$8040,$0000,$0040,$0000
L000147BC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0200
L000147CC   dc.w    $0000,$0201,$8200,$0000,$1060,$0000,$0000,$0010
L000147DC   dc.w    $0000,$0020,$0040,$0000,$0040,$0000,$0000,$0000
L000147EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0200,$0000,$0200
L000147FC   dc.w    $0400,$0000,$0800,$0000,$0000,$0421,$0000,$0010
L0001480C   dc.w    $8440,$0000,$0040,$0000,$0000,$0000,$0000,$0000
L0001481C   dc.w    $0000,$0000,$0000,$0200,$0000,$0221,$0800,$0000
L0001482C   dc.w    $0420,$0000,$0000,$0402,$0000,$0000,$8440,$0000
L0001483C   dc.w    $0041,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001484C   dc.w    $0000,$8200,$0000,$0221,$0000,$0000,$0020,$0000
L0001485C   dc.w    $0000,$0406,$0000,$0000,$8840,$0000,$0041,$0000
L0001486C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$8200
L0001487C   dc.w    $0000,$0211,$0000,$0000,$2020,$0000,$0000,$0404
L0001488C   dc.w    $0000,$0000,$8040,$0000,$0020,$0000,$0000,$0000
L0001489C   dc.w    $0000,$0000,$0000,$0000,$0000,$0400,$0000,$0201
L000148AC   dc.w    $0000,$0000,$2020,$0000,$0000,$0404,$0000,$0000
L000148BC   dc.w    $8040,$0000,$0030,$0000,$0000,$0000,$0000,$0000
L000148CC   dc.w    $0000,$0000,$0000,$0C00,$0000,$0201,$0000,$0000
L000148DC   dc.w    $2020,$0000,$0000,$0400,$0000,$0000,$8040,$0000
L000148EC   dc.w    $001C,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000148FC   dc.w    $0000,$3800,$0000,$0201,$0000,$0000,$0020,$0000
L0001490C   dc.w    $0000,$0404,$0000,$0000,$8040,$0000,$001E,$0000
L0001491C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$7800
L0001492C   dc.w    $0000,$0201,$0000,$0000,$2020,$0000,$0000,$0400
L0001493C   dc.w    $0000,$0000,$8060,$0000,$001F,$8000,$0000,$0000
L0001494C   dc.w    $0000,$0000,$0000,$0000,$0001,$F800,$0000,$0601
L0001495C   dc.w    $0000,$0000,$0020,$0000,$0000,$0404,$0000,$0000
L0001496C   dc.w    $80F8,$0000,$003F,$E000,$0000,$0000,$0000,$0000
L0001497C   dc.w    $0000,$0000,$0007,$FC00,$0000,$1F01,$0000,$0000
L0001498C   dc.w    $2020,$0000,$0000,$0400,$0000,$0000,$8000,$0000
L0001499C   dc.w    $0000,$0000,$2FFF,$FFFF,$FFFF,$FFFF,$FFFD,$0000
L000149AC   dc.w    $0000,$0000,$0000,$0001,$0000,$0000,$0020,$0000
L000149BC   dc.w    $0000,$0400,$0000,$0000,$8000,$0000,$0000,$0000
L000149CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000149DC   dc.w    $0000,$0001,$0000,$0000,$0020,$0000,$0000,$1100
L000149EC   dc.w    $0000,$0000,$01FF,$FFFF,$FFFF,$F800,$0000,$0000
L000149FC   dc.w    $0000,$0000,$0000,$0000,$001F,$FFFF,$FFFF,$FF80
L00014A0C   dc.w    $0000,$0000,$0088,$0000,$0000,$0E00,$0000,$0001
L00014A1C   dc.w    $C200,$0000,$003F,$F000,$0000,$0000,$0000,$0000
L00014A2C   dc.w    $0000,$0000,$000F,$FC00,$0000,$0043,$8000,$0000
L00014A3C   dc.w    $0070,$0000,$0000,$0E00,$0000,$0000,$8000,$0000
L00014A4C   dc.w    $0000,$703F,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
L00014A5C   dc.w    $FC0E,$0000,$0000,$0001,$0000,$0000,$0070,$0000
L00014A6C   dc.w    $0000,$CE80,$0000,$0004,$8000,$0000,$0000,$307F
L00014A7C   dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FE0C,$0000
L00014A8C   dc.w    $0000,$0001,$2000,$0000,$0173,$0000,$0000,$CE80
L00014A9C   dc.w    $0000,$0004,$8000,$0000,$0000,$3040,$0000,$0000
L00014AAC   dc.w    $0000,$0000,$0000,$0000,$020C,$0000,$0000,$0001
L00014ABC   dc.w    $2000,$0000,$0173,$0000,$0000,$CE80,$0000,$0004
L00014ACC   dc.w    $8000,$0000,$0000,$3000,$0000,$0000,$0000,$0000
L00014ADC   dc.w    $0000,$0000,$000C,$0000,$0000,$0001,$2000,$0000
L00014AEC   dc.w    $0173,$0000,$0000,$CE00,$0000,$0004,$8000,$13A0
L00014AFC   dc.w    $005F,$F000,$0000,$0000,$0000,$0000,$0000,$0000
L00014B0C   dc.w    $000F,$FA00,$05C8,$0001,$2000,$0000,$0073,$0000
L00014B1C   dc.w    $0000,$0E00,$0000,$0000,$8000,$0000,$0000,$3000
L00014B2C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$000C,$0000
L00014B3C   dc.w    $0000,$0001,$0000,$0000,$0070,$0000,$0000,$0E00
L00014B4C   dc.w    $0000,$0000,$8000,$0000,$0000,$1000,$FFFF,$FFFF
L00014B5C   dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$E008,$0000,$0000,$0001
L00014B6C   dc.w    $0000,$0000,$0070,$0000,$0000,$0E00,$0000,$0000
L00014B7C   dc.w    $8000,$0000,$0000,$3001,$0000,$0000,$0000,$0000
L00014B8C   dc.w    $0000,$0000,$000C,$0000,$0000,$0001,$0000,$0000
L00014B9C   dc.w    $0070,$0000,$0000,$0100,$0000,$0040,$0000,$00E0
L00014BAC   dc.w    $0017,$F000,$0000,$0000,$0000,$0000,$0000,$0000
L00014BBC   dc.w    $000F,$E800,$0700,$0000,$0200,$0000,$0080,$0000
L00014BCC   dc.w    $0000,$0400,$0000,$0000,$8000,$0000,$0000,$3000
L00014BDC   dc.w    $0000,$001C,$0000,$E000,$0380,$0000,$000C,$0000
L00014BEC   dc.w    $0000,$0001,$0000,$0000,$0020,$0000,$0000,$0400
L00014BFC   dc.w    $0000,$0040,$8000,$0000,$0000,$3000,$0000,$003E
L00014C0C   dc.w    $0001,$F000,$07C0,$0000,$000C,$0000,$0000,$0001
L00014C1C   dc.w    $0200,$0000,$0020,$0000,$0000,$0400,$0000,$0000
L00014C2C   dc.w    $8000,$0000,$0000,$3000,$0000,$007F,$0003,$F800
L00014C3C   dc.w    $0FE0,$0004,$000C,$0000,$0000,$0001,$0000,$0000
L00014C4C   dc.w    $0020,$0000,$0000,$0400,$0000,$0040,$8000,$0010
L00014C5C   dc.w    $0005,$F000,$0000,$0063,$0003,$1800,$0C60,$0004
L00014C6C   dc.w    $000F,$A000,$0800,$0001,$0200,$0000,$0020,$0000
L00014C7C   dc.w    $0000,$0400,$0000,$0040,$8000,$0000,$0000,$1000
L00014C8C   dc.w    $0000,$0241,$0012,$0900,$0824,$0000,$0008,$0000
L00014C9C   dc.w    $0000,$0001,$0200,$0000,$0020,$0000,$0000,$0400
L00014CAC   dc.w    $0000,$00C0,$8000,$0000,$0000,$1000,$0000,$0041
L00014CBC   dc.w    $0002,$0800,$0820,$0000,$0008,$0000,$0000,$0001
L00014CCC   dc.w    $0300,$0000,$0020,$0000,$0000,$0400,$0000,$0080
L00014CDC   dc.w    $8000,$0000,$0000,$1000,$0000,$0000,$0000,$0000
L00014CEC   dc.w    $0000,$0000,$0008,$0000,$0000,$0001,$0100,$0000
L00014CFC   dc.w    $0020,$0000,$0000,$0020,$0000,$0110,$8000,$00B4
L00014D0C   dc.w    $0001,$7000,$0000,$0000,$0000,$0000,$0000,$0000
L00014D1C   dc.w    $000E,$8000,$2D00,$0001,$0880,$0000,$0400,$0000
L00014D2C   dc.w    $0000,$0610,$0000,$0020,$0000,$0000,$0000,$1000
L00014D3C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0008,$0000
L00014D4C   dc.w    $0000,$0000,$0400,$0000,$0860,$0000,$0000,$070F
L00014D5C   dc.w    $FFFF,$FFC3,$8000,$0000,$0000,$1000,$0000,$0000
L00014D6C   dc.w    $0000,$0000,$0000,$0000,$0008,$0000,$0000,$0001
L00014D7C   dc.w    $C3FF,$FFFF,$F0E0,$0000,$0000,$0F80,$00AA,$8007
L00014D8C   dc.w    $C000,$0000,$0000,$1000,$0000,$0000,$0000,$0000
L00014D9C   dc.w    $0000,$0000,$0008,$0000,$0000,$0003,$E001,$5500
L00014DAC   dc.w    $01F0,$0000,$0000,$0FFF,$FFFF,$FFE7,$C000,$0000
L00014DBC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00014DCC   dc.w    $0000,$0000,$0000,$0003,$E7FF,$FFFF,$FFF0,$0000
L00014DDC   dc.w    $0000,$0700,$0000,$0003,$C000,$0000,$0000,$0000
L00014DEC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00014DFC   dc.w    $0000,$0003,$C000,$0000,$00E0,$0000,$0000,$0000
L00014E0C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00014E1C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00014E2C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00014E3C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00014E4C   dc.w    $0000,$0000,$0000,$000A,$0000,$0000,$000A,$0000
L00014E5C   dc.w    $0000,$000E,$0000,$0000,$000A,$0000,$0000,$0000
L00014E6C   dc.w    $0000,$0000,$0000,$0000,$0000,$000D,$8000,$0000
L00014E7C   dc.w    $0021,$8000,$0000,$00A4,$8000,$0000,$00A9,$0800
L00014E8C   dc.w    $0000,$00A2,$0800,$0000,$0024,$0800,$0000,$0028
L00014E9C   dc.w    $0800,$0000,$0030,$0800,$0000,$00FF,$F800,$0000
L00014EAC   dc.w    $00FF,$F800,$0000,$00FF,$F800,$0000,$00FF,$F800
L00014EBC   dc.w    $0000,$00FF,$F800,$0000,$00FF,$F800,$0000,$00FF
L00014ECC   dc.w    $F800,$0000,$00FF,$F800,$0000,$007F,$F000,$0000
L00014EDC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00014EEC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00014EFC   dc.w    $0000,$0000,$001F,$C000,$0000,$001F,$4000,$0000
L00014F0C   dc.w    $001F,$4000,$0000,$001B,$4000,$0000,$001B,$4000
L00014F1C   dc.w    $0000,$000F,$8000,$0000,$0000,$0000,$0000,$0009
L00014F2C   dc.w    $8000,$0000,$005E,$0000,$0000,$0068,$F000,$0000
L00014F3C   dc.w    $0061,$F800,$0000,$0063,$F800,$0000,$0067,$F800
L00014F4C   dc.w    $0000,$006F,$F800,$0000,$007F,$F800,$0000,$00FF
L00014F5C   dc.w    $F800,$0000,$00FF,$F800,$0000,$00FF,$F800,$0000
L00014F6C   dc.w    $00FF,$F800,$0000,$00FF,$F800,$0000,$00FF,$F800
L00014F7C   dc.w    $0000,$00FF,$F800,$0000,$00FF,$F800,$0000,$007F
L00014F8C   dc.w    $F000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00014F9C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00014FAC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0006
L00014FBC   dc.w    $0000,$0000,$0006,$0000,$0000,$0006,$0000,$0000
L00014FCC   dc.w    $0006,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00014FDC   dc.w    $0000,$0006,$0000,$0000,$007F,$F000,$0000,$009F
L00014FEC   dc.w    $0800,$0000,$009E,$0000,$0000,$009C,$0000,$0000
L00014FFC   dc.w    $0098,$0000,$0000,$0090,$0000,$0000,$0080,$0000
L0001500C   dc.w    $0000,$005F,$F000,$0000,$007F,$F000,$0000,$007F
L0001501C   dc.w    $F000,$0000,$007F,$F000,$0000,$007F,$F000,$0000
L0001502C   dc.w    $007F,$F000,$0000,$007F,$F000,$0000,$007F,$F000
L0001503C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001504C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001505C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001506C   dc.w    $0000,$0002,$0000,$0000,$0002,$0000,$0000,$0002
L0001507C   dc.w    $0000,$0000,$0002,$0000,$0000,$0000,$0000,$0000
L0001508C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001509C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000150AC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000150BC   dc.w    $0000,$0000,$0000,$005F,$F000,$0000,$0000,$0000
L000150CC   dc.w    $0000,$007F,$F000,$0000,$007F,$F000,$0000,$007F
L000150DC   dc.w    $F000,$0000,$007F,$F000,$0000,$007F,$F000,$0000
L000150EC   dc.w    $007F,$F000,$0000,$0000,$0000,$0000,$0000,$0000
L000150FC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001510C   dc.w    $0130,$0000,$000D,$8000,$0000,$0000,$0000,$0000
L0001511C   dc.w    $000D,$8000,$0000,$0009,$8000,$0000,$0009,$8000
L0001512C   dc.w    $0000,$0009,$8000,$0000,$0009,$8000,$0000,$0009
L0001513C   dc.w    $8000,$0000,$0009,$8000,$0000,$0009,$8000,$0000
L0001514C   dc.w    $000C,$8000,$0000,$000E,$8000,$0000,$0015,$8000
L0001515C   dc.w    $0000,$0023,$4000,$0000,$0046,$2000,$0000,$0048
L0001516C   dc.w    $1000,$0000,$009F,$D000,$0000,$00B0,$7800,$0000
L0001517C   dc.w    $00B3,$3800,$0000,$00B7,$3800,$0000,$00B7,$3800
L0001518C   dc.w    $0000,$0097,$3800,$0000,$0091,$B800,$0000,$0093
L0001519C   dc.w    $F800,$0000,$0093,$F800,$0000,$0097,$F800,$0000
L000151AC   dc.w    $009F,$F800,$0000,$0080,$3800,$0000,$007F,$F000
L000151BC   dc.w    $0000,$000A,$C000,$0000,$000A,$C000,$0000,$000F
L000151CC   dc.w    $C000,$0000,$000A,$C000,$0000,$000E,$C000,$0000
L000151DC   dc.w    $000E,$C000,$0000,$000E,$C000,$0000,$000E,$C000
L000151EC   dc.w    $0000,$000E,$C000,$0000,$000E,$C000,$0000,$000E
L000151FC   dc.w    $C000,$0000,$000A,$C000,$0000,$0008,$C000,$0000
L0001520C   dc.w    $0019,$C000,$0000,$003C,$6000,$0000,$0078,$3000
L0001521C   dc.w    $0000,$0070,$1800,$0000,$00EF,$D800,$0000,$00D0
L0001522C   dc.w    $5C00,$0000,$00D3,$1C00,$0000,$00D7,$1C00,$0000
L0001523C   dc.w    $00D7,$1C00,$0000,$00D7,$1C00,$0000,$00D1,$9C00
L0001524C   dc.w    $0000,$00D3,$DC00,$0000,$00D3,$DC00,$0000,$00D7
L0001525C   dc.w    $DC00,$0000,$00C0,$1C00,$0000,$00C0,$3C00,$0000
L0001526C   dc.w    $007F,$F800,$0000,$0007,$0000,$0000,$0007,$0000
L0001527C   dc.w    $0000,$0000,$0000,$0000,$0007,$0000,$0000,$0007
L0001528C   dc.w    $0000,$0000,$0007,$0000,$0000,$0007,$0000,$0000
L0001529C   dc.w    $0007,$0000,$0000,$0007,$0000,$0000,$0007,$0000
L000152AC   dc.w    $0000,$0007,$0000,$0000,$0007,$0000,$0000,$0007
L000152BC   dc.w    $0000,$0000,$000E,$0000,$0000,$001F,$8000,$0000
L000152CC   dc.w    $003F,$C000,$0000,$003F,$E000,$0000,$0070,$2000
L000152DC   dc.w    $0000,$006F,$8000,$0000,$006C,$C000,$0000,$0068
L000152EC   dc.w    $C000,$0000,$0068,$C000,$0000,$0068,$C000,$0000
L000152FC   dc.w    $006E,$4000,$0000,$006C,$0000,$0000,$006C,$0000
L0001530C   dc.w    $0000,$0068,$0000,$0000,$0060,$0000,$0000,$007F
L0001531C   dc.w    $C000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001532C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001533C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001534C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001535C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001536C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001537C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001538C   dc.w    $000F,$C000,$0000,$001F,$C000,$0000,$001F,$C000
L0001539C   dc.w    $0000,$001F,$C000,$0000,$001F,$C000,$0000,$001F
L000153AC   dc.w    $C000,$0000,$001F,$C000,$0000,$001F,$C000,$0000
L000153BC   dc.w    $001F,$C000,$0000,$001F,$C000,$0000,$0000,$0000
L000153CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000153DC   dc.w    $0130,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000153EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000153FC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001540C   dc.w    $0000,$0000,$0000,$0000,$0000,$002A,$D800,$0000
L0001541C   dc.w    $002A,$D800,$0000,$0000,$0000,$0000,$003F,$F800
L0001542C   dc.w    $0000,$003B,$F800,$0000,$003B,$F800,$0000,$003B
L0001543C   dc.w    $F800,$0000,$003F,$F800,$0000,$003B,$F800,$0000
L0001544C   dc.w    $003F,$F800,$0000,$003F,$F800,$0000,$003F,$F800
L0001545C   dc.w    $0000,$001F,$F000,$0000,$0000,$0000,$0000,$0000
L0001546C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001547C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001548C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001549C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000154AC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000154BC   dc.w    $0000,$0000,$0000,$0000,$003F,$F800,$0000,$0064
L000154CC   dc.w    $A400,$0000,$0064,$A400,$0000,$003F,$F800,$0000
L000154DC   dc.w    $007F,$FC00,$0000,$0044,$0400,$0000,$0044,$0400
L000154EC   dc.w    $0000,$0044,$0400,$0000,$0040,$0400,$0000,$0040
L000154FC   dc.w    $0400,$0000,$0040,$0400,$0000,$0040,$0400,$0000
L0001550C   dc.w    $0040,$0400,$0000,$0060,$0C00,$0000,$003F,$F800
L0001551C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001552C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001553C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001554C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001555C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001556C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001557C   dc.w    $0000,$001F,$0000,$0000,$001F,$0000,$0000,$0000
L0001558C   dc.w    $0000,$0000,$0000,$0000,$0000,$001F,$8000,$0000
L0001559C   dc.w    $001F,$8000,$0000,$001F,$8000,$0000,$001F,$8000
L000155AC   dc.w    $0000,$001F,$8000,$0000,$001F,$8000,$0000,$001F
L000155BC   dc.w    $8000,$0000,$000F,$0000,$0000,$0000,$0000,$0000
L000155CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000155DC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000155EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000155FC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001560C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001561C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001562C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001563C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$001B
L0001564C   dc.w    $8000,$0000,$001B,$8000,$0000,$001B,$8000,$0000
L0001565C   dc.w    $001B,$8000,$0000,$001B,$8000,$0000,$001F,$8000
L0001566C   dc.w    $0000,$001F,$8000,$0000,$000F,$0000,$0000,$0000
L0001567C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001568C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001569C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000156AC   dc.w    $0130,$0000,$0003,$0000,$0000,$0003,$0000,$0000
L000156BC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$000A,$8000
L000156CC   dc.w    $0000,$0011,$4000,$0000,$000E,$0000,$0000,$0007
L000156DC   dc.w    $8000,$0000,$000C,$8000,$0000,$0008,$8000,$0000
L000156EC   dc.w    $0000,$8000,$0000,$0002,$8000,$0000,$0002,$8000
L000156FC   dc.w    $0000,$0003,$8000,$0000,$0013,$8000,$0000,$0013
L0001570C   dc.w    $8000,$0000,$001B,$8000,$0000,$001B,$8000,$0000
L0001571C   dc.w    $001A,$8000,$0000,$0018,$8000,$0000,$0018,$8000
L0001572C   dc.w    $0000,$0019,$8000,$0000,$0012,$8000,$0000,$000E
L0001573C   dc.w    $8000,$0000,$000D,$0000,$0000,$0009,$0000,$0000
L0001574C   dc.w    $0006,$0000,$0000,$003F,$C000,$0000,$0024,$C000
L0001575C   dc.w    $0000,$0005,$0000,$0000,$0005,$0000,$0000,$0005
L0001576C   dc.w    $0000,$0000,$0007,$0000,$0000,$0007,$0000,$0000
L0001577C   dc.w    $0004,$8000,$0000,$000E,$4000,$0000,$0007,$C000
L0001578C   dc.w    $0000,$0000,$C000,$0000,$0003,$C000,$0000,$0007
L0001579C   dc.w    $4000,$0000,$000F,$4000,$0000,$000D,$4000,$0000
L000157AC   dc.w    $000D,$4000,$0000,$000C,$4000,$0000,$000C,$4000
L000157BC   dc.w    $0000,$000C,$C000,$0000,$0005,$C000,$0000,$0005
L000157CC   dc.w    $C000,$0000,$0005,$C000,$0000,$000F,$C000,$0000
L000157DC   dc.w    $001F,$C000,$0000,$001E,$C000,$0000,$001C,$C000
L000157EC   dc.w    $0000,$0000,$C000,$0000,$0001,$C000,$0000,$0001
L000157FC   dc.w    $C000,$0000,$0007,$C000,$0000,$003F,$C000,$0000
L0001580C   dc.w    $0018,$0000,$0000,$0006,$0000,$0000,$0006,$0000
L0001581C   dc.w    $0000,$0006,$0000,$0000,$0000,$0000,$0000,$0000
L0001582C   dc.w    $0000,$0000,$000F,$0000,$0000,$001F,$8000,$0000
L0001583C   dc.w    $0018,$0000,$0000,$001F,$0000,$0000,$001F,$0000
L0001584C   dc.w    $0000,$001F,$0000,$0000,$001F,$0000,$0000,$001F
L0001585C   dc.w    $0000,$0000,$001F,$0000,$0000,$001F,$0000,$0000
L0001586C   dc.w    $000F,$0000,$0000,$000F,$8000,$0000,$000F,$8000
L0001587C   dc.w    $0000,$000F,$0000,$0000,$000F,$0000,$0000,$000F
L0001588C   dc.w    $0000,$0000,$001F,$0000,$0000,$001F,$0000,$0000
L0001589C   dc.w    $001F,$0000,$0000,$001F,$0000,$0000,$001E,$0000
L000158AC   dc.w    $0000,$001E,$0000,$0000,$0018,$0000,$0000,$0000
L000158BC   dc.w    $0000,$0000,$003F,$C000,$0000,$0000,$0000,$0000
L000158CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000158DC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000158EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000158FC   dc.w    $0000,$0000,$0000,$0000,$8000,$0000,$0001,$8000
L0001590C   dc.w    $0000,$0001,$8000,$0000,$0001,$8000,$0000,$0009
L0001591C   dc.w    $0000,$0000,$0019,$0000,$0000,$0019,$8000,$0000
L0001592C   dc.w    $0018,$8000,$0000,$0008,$0000,$0000,$0008,$0000
L0001593C   dc.w    $0000,$0000,$0000,$0000,$0010,$0000,$0000,$0010
L0001594C   dc.w    $0000,$0000,$0010,$0000,$0000,$0000,$0000,$0000
L0001595C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001596C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001597C   dc.w    $0130,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001598C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$8000
L0001599C   dc.w    $0000,$0000,$8000,$0000,$0000,$8000,$0000,$0004
L000159AC   dc.w    $8000,$0000,$0004,$8000,$0000,$0004,$8000,$0000
L000159BC   dc.w    $0004,$8000,$0000,$0004,$8000,$0000,$0004,$8000
L000159CC   dc.w    $0000,$0004,$8000,$0000,$0004,$8000,$0000,$0004
L000159DC   dc.w    $8000,$0000,$0000,$0000,$0000,$0004,$8000,$0000
L000159EC   dc.w    $0004,$8000,$0000,$0004,$8000,$0000,$0004,$8000
L000159FC   dc.w    $0000,$0004,$8000,$0000,$0004,$8000,$0000,$0004
L00015A0C   dc.w    $8000,$0000,$0004,$8000,$0000,$0004,$8000,$0000
L00015A1C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00015A2C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00015A3C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00015A4C   dc.w    $0000,$0000,$0000,$0001,$0000,$0000,$0001,$0000
L00015A5C   dc.w    $0000,$0001,$0000,$0000,$0001,$0000,$0000,$0001
L00015A6C   dc.w    $0000,$0000,$0001,$0000,$0000,$0001,$0000,$0000
L00015A7C   dc.w    $0001,$0000,$0000,$0006,$8000,$0000,$0006,$8000
L00015A8C   dc.w    $0000,$0006,$8000,$0000,$0000,$0000,$0000,$0006
L00015A9C   dc.w    $8000,$0000,$0006,$8000,$0000,$0006,$8000,$0000
L00015AAC   dc.w    $0006,$8000,$0000,$0006,$8000,$0000,$0006,$8000
L00015ABC   dc.w    $0000,$0006,$8000,$0000,$0006,$8000,$0000,$0006
L00015ACC   dc.w    $8000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00015ADC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00015AEC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00015AFC   dc.w    $0000,$0000,$0000,$0000,$0000,$0001,$0000,$0000
L00015B0C   dc.w    $0001,$0000,$0000,$0001,$0000,$0000,$0001,$0000
L00015B1C   dc.w    $0000,$0001,$0000,$0000,$0001,$0000,$0000,$0001
L00015B2C   dc.w    $0000,$0000,$0001,$0000,$0000,$0003,$0000,$0000
L00015B3C   dc.w    $0003,$0000,$0000,$0003,$0000,$0000,$0000,$0000
L00015B4C   dc.w    $0000,$0003,$0000,$0000,$0003,$0000,$0000,$0003
L00015B5C   dc.w    $0000,$0000,$0003,$0000,$0000,$0003,$0000,$0000
L00015B6C   dc.w    $0003,$0000,$0000,$0003,$0000,$0000,$0003,$0000
L00015B7C   dc.w    $0000,$0003,$0000,$0000,$0000,$0000,$0000,$0000
L00015B8C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00015B9C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00015BAC   dc.w    $0000,$0000,$0000,$0000,$0000,$8000,$0000,$0001
L00015BBC   dc.w    $8000,$0000,$0003,$8000,$0000,$0007,$8000,$0000
L00015BCC   dc.w    $0007,$8000,$0000,$0007,$8000,$0000,$0007,$8000
L00015BDC   dc.w    $0000,$0007,$8000,$0000,$0007,$8000,$0000,$0000
L00015BEC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00015BFC   dc.w    $0000,$0000,$0000,$0005,$8000,$0000,$0005,$8000
L00015C0C   dc.w    $0000,$0005,$8000,$0000,$0005,$8000,$0000,$0005
L00015C1C   dc.w    $8000,$0000,$0005,$8000,$0000,$0005,$8000,$0000
L00015C2C   dc.w    $0005,$8000,$0000,$0005,$8000,$0000,$0000,$0000
L00015C3C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00015C4C   dc.w    $0130,$0000,$0000,$8000,$0000,$0001,$8000,$0000
L00015C5C   dc.w    $0000,$0000,$0000,$0000,$C000,$0000,$0001,$A000
L00015C6C   dc.w    $0000,$0000,$D000,$0000,$001F,$1000,$0000,$0015
L00015C7C   dc.w    $9000,$0000,$0015,$9000,$0000,$0015,$9000,$0000
L00015C8C   dc.w    $0015,$9000,$0000,$001F,$F000,$0000,$001F,$F000
L00015C9C   dc.w    $0000,$001F,$F000,$0000,$001F,$F000,$0000,$001F
L00015CAC   dc.w    $F000,$0000,$001F,$F000,$0000,$001F,$F000,$0000
L00015CBC   dc.w    $001F,$F000,$0000,$001F,$F000,$0000,$001F,$F000
L00015CCC   dc.w    $0000,$001F,$F000,$0000,$001F,$F000,$0000,$0015
L00015CDC   dc.w    $9000,$0000,$0015,$9000,$0000,$0015,$9000,$0000
L00015CEC   dc.w    $0015,$9000,$0000,$0005,$8000,$0000,$0000,$0000
L00015CFC   dc.w    $0000,$0001,$0000,$0000,$0001,$0000,$0000,$0001
L00015D0C   dc.w    $8000,$0000,$0001,$8000,$0000,$0000,$E000,$0000
L00015D1C   dc.w    $0006,$3000,$0000,$000F,$1800,$0000,$001F,$F800
L00015D2C   dc.w    $0000,$0012,$1800,$0000,$0012,$1800,$0000,$0012
L00015D3C   dc.w    $1800,$0000,$0012,$1800,$0000,$0010,$0800,$0000
L00015D4C   dc.w    $001F,$F800,$0000,$0000,$0800,$0000,$0000,$0800
L00015D5C   dc.w    $0000,$0000,$0800,$0000,$0000,$0800,$0000,$0000
L00015D6C   dc.w    $0800,$0000,$0000,$0800,$0000,$0000,$0800,$0000
L00015D7C   dc.w    $0010,$0800,$0000,$001F,$F800,$0000,$0010,$0800
L00015D8C   dc.w    $0000,$0012,$1800,$0000,$0012,$1800,$0000,$0012
L00015D9C   dc.w    $1800,$0000,$0012,$1800,$0000,$0012,$1800,$0000
L00015DAC   dc.w    $000F,$F000,$0000,$0001,$8000,$0000,$0001,$8000
L00015DBC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0007
L00015DCC   dc.w    $0000,$0000,$000F,$C000,$0000,$001F,$E000,$0000
L00015DDC   dc.w    $0000,$0000,$0000,$000F,$E000,$0000,$000F,$E000
L00015DEC   dc.w    $0000,$000F,$E000,$0000,$000F,$E000,$0000,$0007
L00015DFC   dc.w    $4000,$0000,$0000,$0000,$0000,$0007,$4000,$0000
L00015E0C   dc.w    $0007,$4000,$0000,$0007,$4000,$0000,$0007,$4000
L00015E1C   dc.w    $0000,$0007,$4000,$0000,$0007,$4000,$0000,$0007
L00015E2C   dc.w    $4000,$0000,$0007,$4000,$0000,$0000,$0000,$0000
L00015E3C   dc.w    $0007,$4000,$0000,$000F,$E000,$0000,$000F,$E000
L00015E4C   dc.w    $0000,$000F,$E000,$0000,$000F,$E000,$0000,$000F
L00015E5C   dc.w    $E000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00015E6C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00015E7C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00015E8C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00015E9C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00015EAC   dc.w    $0000,$0007,$4000,$0000,$0000,$0000,$0000,$0007
L00015EBC   dc.w    $4000,$0000,$0007,$4000,$0000,$0007,$4000,$0000
L00015ECC   dc.w    $0007,$4000,$0000,$0007,$4000,$0000,$0007,$4000
L00015EDC   dc.w    $0000,$0007,$4000,$0000,$0007,$4000,$0000,$0000
L00015EEC   dc.w    $0000,$0000,$0007,$4000,$0000,$0000,$0000,$0000
L00015EFC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00015F0C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00015F1C   dc.w    $0130,$0000,$001B,$4000,$0000,$0018,$4000,$0000
L00015F2C   dc.w    $0019,$4000,$0000,$0019,$4000,$0000,$0000,$0000
L00015F3C   dc.w    $0000,$0019,$4000,$0000,$0019,$4000,$0000,$0019
L00015F4C   dc.w    $4000,$0000,$0019,$4000,$0000,$0019,$4000,$0000
L00015F5C   dc.w    $0008,$A000,$0000,$0008,$A000,$0000,$0008,$A000
L00015F6C   dc.w    $0000,$0008,$A000,$0000,$0008,$A000,$0000,$0008
L00015F7C   dc.w    $A000,$0000,$0008,$A000,$0000,$0008,$A000,$0000
L00015F8C   dc.w    $0008,$A000,$0000,$0008,$A000,$0000,$0008,$A000
L00015F9C   dc.w    $0000,$0008,$A000,$0000,$0019,$4000,$0000,$0019
L00015FAC   dc.w    $4000,$0000,$0019,$4000,$0000,$0019,$4000,$0000
L00015FBC   dc.w    $0019,$4000,$0000,$001F,$C000,$0000,$0000,$0000
L00015FCC   dc.w    $0000,$0000,$2000,$0000,$0000,$2000,$0000,$0000
L00015FDC   dc.w    $2000,$0000,$0002,$2000,$0000,$0002,$2000,$0000
L00015FEC   dc.w    $001F,$E000,$0000,$0002,$2000,$0000,$0002,$2000
L00015FFC   dc.w    $0000,$0002,$2000,$0000,$0002,$2000,$0000,$0002
L0001600C   dc.w    $2000,$0000,$0007,$2000,$0000,$0007,$2000,$0000
L0001601C   dc.w    $0007,$2000,$0000,$0007,$2000,$0000,$0007,$2000
L0001602C   dc.w    $0000,$0007,$2000,$0000,$0007,$2000,$0000,$0007
L0001603C   dc.w    $2000,$0000,$0007,$2000,$0000,$0007,$2000,$0000
L0001604C   dc.w    $0007,$2000,$0000,$0007,$2000,$0000,$0002,$2000
L0001605C   dc.w    $0000,$0002,$2000,$0000,$0002,$2000,$0000,$0002
L0001606C   dc.w    $2000,$0000,$0000,$2000,$0000,$001F,$E000,$0000
L0001607C   dc.w    $001F,$E000,$0000,$0000,$0000,$0000,$0000,$0000
L0001608C   dc.w    $0000,$0000,$0000,$0000,$0003,$0000,$0000,$0003
L0001609C   dc.w    $0000,$0000,$0000,$0000,$0000,$0003,$0000,$0000
L000160AC   dc.w    $0003,$0000,$0000,$0003,$0000,$0000,$0003,$0000
L000160BC   dc.w    $0000,$0003,$0000,$0000,$001F,$C000,$0000,$001F
L000160CC   dc.w    $C000,$0000,$001F,$C000,$0000,$001F,$C000,$0000
L000160DC   dc.w    $001F,$C000,$0000,$001F,$C000,$0000,$001F,$C000
L000160EC   dc.w    $0000,$001F,$C000,$0000,$001F,$C000,$0000,$001F
L000160FC   dc.w    $C000,$0000,$001F,$C000,$0000,$001F,$C000,$0000
L0001610C   dc.w    $0003,$0000,$0000,$0003,$0000,$0000,$0003,$0000
L0001611C   dc.w    $0000,$0003,$0000,$0000,$0003,$8000,$0000,$0000
L0001612C   dc.w    $0000,$0000,$0000,$0000,$0000,$001F,$C000,$0000
L0001613C   dc.w    $001F,$C000,$0000,$001F,$C000,$0000,$001C,$C000
L0001614C   dc.w    $0000,$001C,$C000,$0000,$0000,$0000,$0000,$001C
L0001615C   dc.w    $C000,$0000,$001C,$C000,$0000,$001C,$C000,$0000
L0001616C   dc.w    $001C,$C000,$0000,$001C,$C000,$0000,$0000,$0000
L0001617C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001618C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001619C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000161AC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000161BC   dc.w    $0000,$0000,$001C,$C000,$0000,$001C,$C000,$0000
L000161CC   dc.w    $001C,$C000,$0000,$001C,$C000,$0000,$001C,$4000
L000161DC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000161EC   dc.w    $0130,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000161FC   dc.w    $0000,$0180,$0000,$0000,$0340,$0000,$0000,$0420
L0001620C   dc.w    $0000,$0000,$0620,$0000,$00C7,$0420,$0000,$012B
L0001621C   dc.w    $C240,$0000,$01FC,$7180,$0000,$0300,$0C00,$0000
L0001622C   dc.w    $0400,$0300,$0000,$01D5,$D880,$0000,$07FD,$FD80
L0001623C   dc.w    $0000,$0115,$5500,$0000,$0515,$5500,$0000,$01D7
L0001624C   dc.w    $DD00,$0000,$0455,$5100,$0000,$0455,$5100,$0000
L0001625C   dc.w    $05DD,$5100,$0000,$0400,$0100,$0000,$0200,$0200
L0001626C   dc.w    $0000,$03FF,$FE00,$0000,$01FF,$FC00,$0000,$0000
L0001627C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001628C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001629C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000162AC   dc.w    $0000,$0000,$0000,$0180,$0000,$0000,$0240,$0000
L000162BC   dc.w    $0000,$0620,$0000,$0000,$0420,$0000,$00C0,$0420
L000162CC   dc.w    $0000,$01A4,$0240,$0000,$0003,$8180,$0000,$00FF
L000162DC   dc.w    $F000,$0000,$03FF,$FC00,$0000,$062A,$2700,$0000
L000162EC   dc.w    $05DF,$DF00,$0000,$0717,$7700,$0000,$05D7,$DF00
L000162FC   dc.w    $0000,$05D5,$DF00,$0000,$0455,$5300,$0000,$05DD
L0001630C   dc.w    $5100,$0000,$05DD,$5300,$0000,$0400,$0100,$0000
L0001631C   dc.w    $03DF,$D200,$0000,$01FF,$FC00,$0000,$0000,$0000
L0001632C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001633C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001634C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001635C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001636C   dc.w    $0100,$0000,$0000,$0200,$0000,$0000,$0200,$0000
L0001637C   dc.w    $0007,$0040,$0000,$008F,$C080,$0000,$01FF,$F000
L0001638C   dc.w    $0000,$03FF,$FC00,$0000,$07FF,$FF00,$0000,$07FF
L0001639C   dc.w    $FF80,$0000,$0222,$2280,$0000,$06EA,$AA00,$0000
L000163AC   dc.w    $02EA,$AA00,$0000,$062A,$2200,$0000,$03AA,$AE00
L000163BC   dc.w    $0000,$03AA,$AE00,$0000,$0222,$AE00,$0000,$03FF
L000163CC   dc.w    $FE00,$0000,$01FF,$FC00,$0000,$0000,$0000,$0000
L000163DC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000163EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000163FC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001640C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001641C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001642C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001643C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001644C   dc.w    $0000,$0000,$0000,$0000,$05DD,$DD00,$0000,$01FD
L0001645C   dc.w    $DD00,$0000,$073D,$5500,$0000,$03FD,$FD00,$0000
L0001646C   dc.w    $07FF,$FD00,$0000,$0677,$FF00,$0000,$07FF,$FD00
L0001647C   dc.w    $0000,$07FF,$FF00,$0000,$0220,$2E00,$0000,$03FF
L0001648C   dc.w    $FE00,$0000,$01FF,$FC00,$0000,$0000,$0000,$0000
L0001649C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000164AC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000164BC   dc.w    $0000,$0000,$0000,$8000,$0000,$0000,$0001,$4000
L000164CC   dc.w    $0000,$0000,$0001,$4000,$0000,$0000,$0002,$0000
L000164DC   dc.w    $0000,$0000,$0003,$8000,$0000,$0000,$0004,$8000
L000164EC   dc.w    $0000,$0000,$0007,$0000,$0000,$0000,$000C,$0000
L000164FC   dc.w    $0000,$0000,$0007,$0000,$0000,$0000,$000C,$0000
L0001650C   dc.w    $0000,$0000,$000A,$0000,$0000,$0000,$0010,$0000
L0001651C   dc.w    $0000,$0000,$0004,$0000,$0000,$0000,$0030,$4000
L0001652C   dc.w    $0000,$0000,$0000,$9000,$0000,$0000,$0040,$6200
L0001653C   dc.w    $0000,$0000,$0009,$1480,$0000,$0000,$0002,$4600
L0001654C   dc.w    $0000,$0000,$0231,$A910,$0000,$0000,$0468,$0028
L0001655C   dc.w    $0000,$0000,$0034,$1110,$0000,$0000,$0406,$0248
L0001656C   dc.w    $0000,$0000,$04E1,$E080,$0000,$0000,$0438,$6028
L0001657C   dc.w    $0000,$0000,$00CA,$1610,$0000,$0000,$0033,$81C0
L0001658C   dc.w    $0000,$0000,$004C,$4820,$0000,$0000,$0011,$1B00
L0001659C   dc.w    $0000,$0000,$000C,$2380,$0000,$0000,$0007,$0CC0
L000165AC   dc.w    $0000,$0000,$000B,$6120,$0000,$0000,$0012,$FCC0
L000165BC   dc.w    $0000,$0000,$0004,$A800,$0000,$0000,$0001,$ABC0
L000165CC   dc.w    $0000,$0000,$0002,$5780,$0000,$0000,$0000,$1400
L000165DC   dc.w    $0000,$0000,$0000,$0A00,$0000,$0000,$0000,$0000
L000165EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000165FC   dc.w    $0000,$0000,$0005,$A000,$0000,$0000,$0000,$0400
L0001660C   dc.w    $0000,$0000,$000B,$2200,$0000,$0000,$0020,$6A00
L0001661C   dc.w    $0000,$0000,$0000,$1100,$0000,$0000,$000B,$4200
L0001662C   dc.w    $0000,$0000,$0020,$0900,$0000,$0000,$0000,$0200
L0001663C   dc.w    $0000,$0000,$0000,$0600,$0000,$0000,$001F,$E000
L0001664C   dc.w    $0000,$0000,$0030,$1200,$0000,$0000,$0025,$8B00
L0001665C   dc.w    $0000,$0000,$0070,$EB00,$0000,$0000,$0071,$6A00
L0001666C   dc.w    $0000,$0000,$0076,$6840,$0000,$0000,$00E6,$7830
L0001667C   dc.w    $0000,$0000,$00E6,$740C,$0000,$0000,$00E4,$B413
L0001668C   dc.w    $0000,$0000,$00A4,$B274,$C000,$0000,$00A4,$B30F
L0001669C   dc.w    $1000,$0000,$01A4,$B700,$7000,$0000,$01CC,$B600
L000166AC   dc.w    $0C00,$0000,$014C,$B000,$0000,$0000,$014C,$B040
L000166BC   dc.w    $0000,$0000,$0148,$B0B0,$0000,$0000,$0149,$706E
L000166CC   dc.w    $0000,$0000,$0081,$70C5,$8000,$0000,$0289,$4C3C
L000166DC   dc.w    $E000,$0000,$0281,$4E01,$D000,$0000,$0291,$4E00
L000166EC   dc.w    $1800,$0000,$0299,$6A00,$0000,$0000,$0299,$6A00
L000166FC   dc.w    $0000,$0000,$0639,$6C00,$0000,$0000,$0632,$E800
L0001670C   dc.w    $0000,$0000,$0372,$A9E0,$0000,$0000,$03F2,$E89C
L0001671C   dc.w    $0000,$0000,$0132,$69EB,$0000,$0000,$0008,$C81C
L0001672C   dc.w    $C000,$0000,$2000,$1800,$A000,$0000,$1600,$2800
L0001673C   dc.w    $1000,$0000,$01CF,$DD00,$0000,$0000,$0033,$8200
L0001674C   dc.w    $0000,$0000,$00C0,$0C00,$0000,$0000,$004D,$B000
L0001675C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0001,$8000
L0001676C   dc.w    $0000,$0000,$0003,$C000,$0000,$0000,$0007,$6000
L0001677C   dc.w    $0000,$0000,$0007,$6000,$0000,$0000,$0006,$6000
L0001678C   dc.w    $0000,$0000,$000F,$C000,$0000,$0000,$000C,$C000
L0001679C   dc.w    $0000,$0000,$000F,$8000,$0000,$0000,$001D,$8000
L000167AC   dc.w    $0000,$0000,$001F,$8000,$0000,$0000,$001F,$0000
L000167BC   dc.w    $0000,$0000,$003F,$0000,$0000,$0000,$003F,$0000
L000167CC   dc.w    $0000,$0000,$007F,$7000,$0000,$0000,$006F,$D800
L000167DC   dc.w    $0000,$0000,$00F7,$8B80,$0000,$0000,$01DF,$EEC0
L000167EC   dc.w    $0000,$0000,$03EF,$7C40,$0000,$0000,$07FF,$BE78
L000167FC   dc.w    $0000,$0000,$07FF,$7FF4,$0000,$0000,$0BEF,$B9E2
L0001680C   dc.w    $0000,$0000,$0BE7,$F7F2,$0000,$0000,$0FFE,$FBDE
L0001681C   dc.w    $0000,$0000,$0F1E,$7FEC,$0000,$0000,$0FE7,$CF9C
L0001682C   dc.w    $0000,$0000,$0FF9,$E7FC,$0000,$0000,$07EF,$7E7C
L0001683C   dc.w    $0000,$0000,$07F3,$F7F8,$0000,$0000,$07CC,$5CF8
L0001684C   dc.w    $0000,$0000,$07E3,$9F38,$0000,$0000,$03E0,$E3D8
L0001685C   dc.w    $0000,$0000,$03E8,$9CF8,$0000,$0000,$03F8,$0330
L0001686C   dc.w    $0000,$0000,$01FC,$00F0,$0000,$0000,$01FD,$03F0
L0001687C   dc.w    $0000,$0000,$00FF,$57F0,$0000,$0000,$00FF,$D7F0
L0001688C   dc.w    $0000,$0000,$00FF,$FFF0,$0000,$0000,$007F,$FFE0
L0001689C   dc.w    $0000,$0000,$007F,$FFE0,$0000,$0000,$007F,$FFC0
L000168AC   dc.w    $0000,$0000,$00FF,$9FC0,$0000,$0000,$00FF,$F780
L000168BC   dc.w    $0000,$0000,$00FF,$1B00,$0000,$0000,$00FF,$FF80
L000168CC   dc.w    $0000,$0000,$00FF,$FBC0,$0000,$0000,$00FF,$3BC0
L000168DC   dc.w    $0000,$0000,$00FF,$FFC0,$0000,$0000,$00FF,$F3C0
L000168EC   dc.w    $0000,$0000,$00FF,$FFC0,$0000,$0000,$01FF,$FF80
L000168FC   dc.w    $0000,$0000,$01F3,$9F00,$0000,$0000,$01E2,$6F80
L0001690C   dc.w    $0000,$0000,$01EA,$9F80,$0000,$0000,$03EA,$DFC0
L0001691C   dc.w    $0000,$0000,$03E8,$DFF0,$0000,$0000,$03D0,$CFBC
L0001692C   dc.w    $0000,$0000,$07D0,$DFCF,$0000,$0000,$07D1,$9F83
L0001693C   dc.w    $C000,$0000,$0791,$9BF0,$F000,$0000,$0791,$9BFF
L0001694C   dc.w    $1800,$0000,$0791,$9B8F,$F400,$0000,$0FA1,$9B80
L0001695C   dc.w    $7E00,$0000,$0F21,$9FC0,$0C00,$0000,$0F21,$9FF0
L0001696C   dc.w    $0000,$0000,$0F21,$9FBE,$0000,$0000,$0F23,$1F0F
L0001697C   dc.w    $8000,$0000,$0E43,$1FC1,$E000,$0000,$0E43,$1BFC
L0001698C   dc.w    $7000,$0000,$1E43,$1BBF,$D800,$0000,$1E53,$1B81
L0001699C   dc.w    $FC00,$0000,$1E5B,$3B80,$1800,$0000,$1E5B,$3B80
L000169AC   dc.w    $0000,$0000,$3EBB,$3F00,$0000,$0000,$3EB6,$3FE0
L000169BC   dc.w    $0000,$0000,$3BF6,$3FFC,$0000,$0000,$3DF6,$7E1F
L000169CC   dc.w    $0000,$0000,$3E36,$7FE3,$C000,$0000,$7F88,$DFFC
L000169DC   dc.w    $E000,$0000,$7FF0,$3F1F,$B000,$0000,$3FFF,$EF00
L000169EC   dc.w    $F800,$0000,$17FF,$CF00,$1000,$0000,$09F0,$6F00
L000169FC   dc.w    $0000,$0000,$063F,$F600,$0000,$0000,$01B1,$4C00
L00016A0C   dc.w    $0000,$0000,$003F,$F000,$0000,$0000,$0000,$0000
L00016A1C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$8000
L00016A2C   dc.w    $0000,$0000,$0000,$8000,$0000,$0000,$0001,$8000
L00016A3C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0003,$0000
L00016A4C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0002,$0000
L00016A5C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00016A6C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00016A7C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0010,$2000
L00016A8C   dc.w    $0000,$0000,$0008,$7000,$0000,$0000,$0020,$1100
L00016A9C   dc.w    $0000,$0000,$0010,$8380,$0000,$0000,$0000,$4180
L00016AAC   dc.w    $0000,$0000,$0000,$8008,$0000,$0000,$0410,$461C
L00016ABC   dc.w    $0000,$0000,$0418,$080C,$0000,$0000,$0001,$0420
L00016ACC   dc.w    $0000,$0000,$00E1,$8010,$0000,$0000,$0018,$3060
L00016ADC   dc.w    $0000,$0000,$0007,$1800,$0000,$0000,$0010,$C180
L00016AEC   dc.w    $0000,$0000,$000C,$3800,$0000,$0000,$0033,$A700
L00016AFC   dc.w    $0000,$0000,$001C,$60C0,$0000,$0000,$001F,$9C20
L00016B0C   dc.w    $0000,$0000,$0017,$E300,$0000,$0000,$0007,$FCC0
L00016B1C   dc.w    $0000,$0000,$0003,$FF00,$0000,$0000,$0002,$FC00
L00016B2C   dc.w    $0000,$0000,$0000,$A800,$0000,$0000,$0000,$2800
L00016B3C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00016B4C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00016B5C   dc.w    $0000,$0000,$0000,$6000,$0000,$0000,$0000,$1800
L00016B6C   dc.w    $0000,$0000,$0000,$E400,$0000,$0000,$0000,$1000
L00016B7C   dc.w    $0000,$0000,$0000,$0C00,$0000,$0000,$0000,$C400
L00016B8C   dc.w    $0000,$0000,$0000,$3000,$0000,$0000,$0000,$0C00
L00016B9C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00016BAC   dc.w    $0000,$0000,$000F,$E000,$0000,$0000,$001F,$F000
L00016BBC   dc.w    $0000,$0000,$0017,$7000,$0000,$0000,$0017,$3000
L00016BCC   dc.w    $0000,$0000,$0017,$3000,$0000,$0000,$002F,$3040
L00016BDC   dc.w    $0000,$0000,$002F,$2070,$0000,$0000,$002E,$607C
L00016BEC   dc.w    $0000,$0000,$006E,$640F,$0000,$0000,$006E,$6400
L00016BFC   dc.w    $E000,$0000,$006E,$6400,$0800,$0000,$005E,$6400
L00016C0C   dc.w    $0000,$0000,$00DE,$6400,$0000,$0000,$00DE,$6400
L00016C1C   dc.w    $0000,$0000,$00DE,$6440,$0000,$0000,$00DC,$E4F0
L00016C2C   dc.w    $0000,$0000,$01BC,$E43E,$0000,$0000,$01BC,$E403
L00016C3C   dc.w    $8000,$0000,$01BC,$E400,$2000,$0000,$01AC,$E400
L00016C4C   dc.w    $0000,$0000,$01A4,$C400,$0000,$0000,$01A4,$C400
L00016C5C   dc.w    $0000,$0000,$0144,$C000,$0000,$0000,$0149,$C000
L00016C6C   dc.w    $0000,$0000,$0409,$C000,$0000,$0000,$0209,$81E0
L00016C7C   dc.w    $0000,$0000,$01C9,$801C,$0000,$0000,$0077,$2003
L00016C8C   dc.w    $0000,$0000,$000F,$C000,$4000,$0000,$0000,$1000
L00016C9C   dc.w    $0000,$0000,$0800,$3000,$0000,$0000,$060F,$F000
L00016CAC   dc.w    $0000,$0000,$01C0,$0800,$0000,$0000,$007E,$F000
L00016CBC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00016CCC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00016CDC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00016CEC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00016CFC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00016D0C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00016D1C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00016D2C   dc.w    $0000,$0000,$0001,$0000,$0000,$0000,$0001,$0000
L00016D3C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0080,$0000
L00016D4C   dc.w    $0000,$0000,$0180,$0000,$0000,$0000,$0100,$0000
L00016D5C   dc.w    $0000,$0000,$0102,$0000,$0000,$0000,$0201,$8800
L00016D6C   dc.w    $0000,$0000,$0200,$4600,$0000,$0000,$0200,$1800
L00016D7C   dc.w    $0000,$0000,$0200,$0600,$0000,$0000,$0040,$0080
L00016D8C   dc.w    $0000,$0000,$0430,$00E0,$0000,$0000,$0108,$0004
L00016D9C   dc.w    $0000,$0000,$0100,$0000,$0000,$0000,$0100,$0000
L00016DAC   dc.w    $0000,$0000,$0180,$0000,$0000,$0000,$0180,$0000
L00016DBC   dc.w    $0000,$0000,$0180,$0008,$0000,$0000,$01C0,$0000
L00016DCC   dc.w    $0000,$0000,$00C0,$0000,$0000,$0000,$00E0,$0000
L00016DDC   dc.w    $0000,$0000,$0070,$0000,$0000,$0000,$0078,$0000
L00016DEC   dc.w    $0000,$0000,$0078,$0010,$0000,$0000,$003E,$0040
L00016DFC   dc.w    $0000,$0000,$003F,$FF80,$0000,$0000,$0021,$FF00
L00016E0C   dc.w    $0000,$0000,$0070,$1E00,$0000,$0000,$007F,$8000
L00016E1C   dc.w    $0000,$0000,$0040,$1900,$0000,$0000,$0010,$0400
L00016E2C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0014,$0000
L00016E3C   dc.w    $0000,$0000,$0007,$C000,$0000,$0000,$0078,$0000
L00016E4C   dc.w    $0000,$0000,$0047,$E000,$0000,$0000,$0080,$1800
L00016E5C   dc.w    $0000,$0000,$0080,$0800,$0000,$0000,$0080,$0400
L00016E6C   dc.w    $0000,$0000,$0080,$0400,$0000,$0000,$0100,$0480
L00016E7C   dc.w    $0000,$0000,$0100,$0500,$0000,$0000,$0100,$0500
L00016E8C   dc.w    $0000,$0000,$0200,$0900,$0000,$0000,$0200,$0900
L00016E9C   dc.w    $0000,$0000,$0200,$0880,$0000,$0000,$0200,$0800
L00016EAC   dc.w    $0000,$0000,$0200,$0800,$0000,$0000,$0200,$0880
L00016EBC   dc.w    $0000,$0000,$0400,$0900,$0000,$0000,$0400,$0900
L00016ECC   dc.w    $0000,$0000,$0400,$0900,$0000,$0000,$0400,$0900
L00016EDC   dc.w    $0000,$0000,$0400,$0900,$0000,$0000,$0400,$0000
L00016EEC   dc.w    $0000,$0000,$0800,$0080,$0000,$0000,$0800,$0080
L00016EFC   dc.w    $0000,$0000,$0800,$0080,$0000,$0000,$0800,$1080
L00016F0C   dc.w    $0000,$0000,$1000,$1100,$0000,$0000,$1000,$1200
L00016F1C   dc.w    $0000,$0000,$1000,$1200,$0000,$0000,$1000,$1200
L00016F2C   dc.w    $0000,$0000,$0800,$1200,$0000,$0000,$2600,$1000
L00016F3C   dc.w    $0000,$0000,$11C0,$2100,$0000,$0000,$083F,$C100
L00016F4C   dc.w    $0000,$0000,$0600,$0200,$0000,$0000,$01C0,$0C00
L00016F5C   dc.w    $0000,$0000,$003F,$F000,$0000,$0000,$0000,$0000
L00016F6C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0130
L00016F7C   dc.w    $0000,$0000,$0003,$C000,$0000,$0000,$0007,$E000
L00016F8C   dc.w    $0000,$0000,$0007,$E000,$0000,$0000,$0007,$E000
L00016F9C   dc.w    $0000,$0000,$000F,$C000,$0000,$0000,$000F,$C000
L00016FAC   dc.w    $0000,$0000,$000F,$8000,$0000,$0000,$001F,$8000
L00016FBC   dc.w    $0000,$0000,$001F,$8000,$0000,$0000,$001F,$0000
L00016FCC   dc.w    $0000,$0000,$003F,$0000,$0000,$0000,$003F,$0000
L00016FDC   dc.w    $0000,$0000,$007F,$7000,$0000,$0000,$007F,$F800
L00016FEC   dc.w    $0000,$0000,$00FF,$FB80,$0000,$0000,$01FF,$FFC0
L00016FFC   dc.w    $0000,$0000,$03FF,$FFC0,$0000,$0000,$07FF,$FFF8
L0001700C   dc.w    $0000,$0000,$07FF,$FFFC,$0000,$0000,$0FFF,$FFFE
L0001701C   dc.w    $0000,$0000,$0FFF,$FFFE,$0000,$0000,$0FFF,$FFFE
L0001702C   dc.w    $0000,$0000,$0FFF,$FFFC,$0000,$0000,$0FFF,$FFFC
L0001703C   dc.w    $0000,$0000,$0FFF,$FFFC,$0000,$0000,$07FF,$FFFC
L0001704C   dc.w    $0000,$0000,$07FF,$FFF8,$0000,$0000,$07FF,$FFF8
L0001705C   dc.w    $0000,$0000,$07FF,$FFF8,$0000,$0000,$03FF,$FFF8
L0001706C   dc.w    $0000,$0000,$03FF,$FFF8,$0000,$0000,$03FF,$FFF0
L0001707C   dc.w    $0000,$0000,$01FF,$FFF0,$0000,$0000,$01FF,$FFF0
L0001708C   dc.w    $0000,$0000,$00FF,$FFF0,$0000,$0000,$00FF,$FFF0
L0001709C   dc.w    $0000,$0000,$00FF,$FFF0,$0000,$0000,$007F,$FFE0
L000170AC   dc.w    $0000,$0000,$007F,$FFE0,$0000,$0000,$007F,$FFC0
L000170BC   dc.w    $0000,$0000,$00FF,$FFC0,$0000,$0000,$00FF,$FF80
L000170CC   dc.w    $0000,$0000,$00FF,$FF00,$0000,$0000,$00FF,$FF80
L000170DC   dc.w    $0000,$0000,$00FF,$FFC0,$0000,$0000,$00FF,$FFC0
L000170EC   dc.w    $0000,$0000,$00FF,$FFC0,$0000,$0000,$00FF,$FFC0
L000170FC   dc.w    $0000,$0000,$00FF,$FFC0,$0000,$0000,$01FF,$FF80
L0001710C   dc.w    $0000,$0000,$01FF,$FF00,$0000,$0000,$01FF,$FF80
L0001711C   dc.w    $0000,$0000,$01FF,$FF80,$0000,$0000,$03FF,$FFC0
L0001712C   dc.w    $0000,$0000,$03FF,$FFF0,$0000,$0000,$03FF,$FFFC
L0001713C   dc.w    $0000,$0000,$07FF,$FFFF,$0000,$0000,$07FF,$FFFF
L0001714C   dc.w    $C000,$0000,$07FF,$FFFF,$F000,$0000,$07FF,$FFFF
L0001715C   dc.w    $F800,$0000,$07FF,$FF8F,$FC00,$0000,$0FFF,$FF80
L0001716C   dc.w    $7E00,$0000,$0FFF,$FFC0,$0C00,$0000,$0FFF,$FFF0
L0001717C   dc.w    $0000,$0000,$0FFF,$FFFE,$0000,$0000,$0FFF,$FFFF
L0001718C   dc.w    $8000,$0000,$0FFF,$FFFF,$E000,$0000,$0FFF,$FFFF
L0001719C   dc.w    $F000,$0000,$1FFF,$FFBF,$F800,$0000,$1FFF,$FF81
L000171AC   dc.w    $FC00,$0000,$1FFF,$FF80,$1800,$0000,$1FFF,$FF80
L000171BC   dc.w    $0000,$0000,$3FFF,$FF00,$0000,$0000,$3FFF,$FFE0
L000171CC   dc.w    $0000,$0000,$3FFF,$FFFC,$0000,$0000,$3FFF,$FFFF
L000171DC   dc.w    $0000,$0000,$3FFF,$FFFF,$C000,$0000,$7FFF,$FFFF
L000171EC   dc.w    $E000,$0000,$7FFF,$FF1F,$F000,$0000,$3FFF,$FF00
L000171FC   dc.w    $F800,$0000,$1FFF,$FF00,$1000,$0000,$0FFF,$FF00
L0001720C   dc.w    $0000,$0000,$07FF,$FE00,$0000,$0000,$01FF,$FC00
L0001721C   dc.w    $0000,$0000,$003F,$F000,$0000,$0000,$0000,$0000
L0001722C   dc.w    $0000,$0000,$0003,$0000,$0000,$0000,$8000,$0000
L0001723C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$3000
L0001724C   dc.w    $0000,$0000,$0400,$0000,$0000,$0100,$0000,$0000
L0001725C   dc.w    $0000,$0000,$0019,$C000,$0000,$007F,$F000,$0000
L0001726C   dc.w    $0040,$7000,$0000,$0041,$6000,$0000,$0020,$0000
L0001727C   dc.w    $0000,$00B9,$F800,$0000,$00C4,$3800,$0000,$0002
L0001728C   dc.w    $9C00,$0000,$00D8,$5800,$0000,$0024,$0C00,$0000
L0001729C   dc.w    $0097,$5000,$0000,$005C,$D000,$0000,$006F,$9000
L000172AC   dc.w    $0000,$0007,$2000,$0000,$0010,$6000,$0000,$0038
L000172BC   dc.w    $A000,$0000,$0036,$A000,$0000,$0007,$C000,$0000
L000172CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000172DC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000172EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000172FC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001730C   dc.w    $0000,$0000,$0000,$0000,$0019,$C000,$0000,$0060
L0001731C   dc.w    $3000,$0000,$007F,$9000,$0000,$002E,$0000,$0000
L0001732C   dc.w    $0053,$4000,$0000,$00C6,$0800,$0000,$00BA,$C800
L0001733C   dc.w    $0000,$00F8,$6000,$0000,$0027,$A400,$0000,$00D8
L0001734C   dc.w    $D000,$0000,$0060,$A800,$0000,$0020,$2000,$0000
L0001735C   dc.w    $0050,$6000,$0000,$0038,$C000,$0000,$000F,$A000
L0001736C   dc.w    $0000,$0007,$0000,$0000,$002A,$2000,$0000,$0000
L0001737C   dc.w    $4000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001738C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001739C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000173AC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000173BC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0006,$0000
L000173CC   dc.w    $0000,$001F,$C000,$0000,$003F,$E000,$0000,$0077
L000173DC   dc.w    $F000,$0000,$006E,$B000,$0000,$007F,$F000,$0000
L000173EC   dc.w    $007F,$F000,$0000,$007A,$FC00,$0000,$00FF,$FC00
L000173FC   dc.w    $0000,$00D8,$FC00,$0000,$00E7,$3800,$0000,$00F1
L0001740C   dc.w    $7000,$0000,$0038,$F000,$0000,$003F,$F000,$0000
L0001741C   dc.w    $003F,$D000,$0000,$003F,$E000,$0000,$001D,$C000
L0001742C   dc.w    $0000,$000F,$8000,$0000,$0000,$0000,$0000,$0000
L0001743C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001744C   dc.w    $0003,$0000,$0000,$0000,$C000,$0000,$0000,$6000
L0001745C   dc.w    $0000,$0000,$2000,$0000,$0000,$3000,$0000,$0000
L0001746C   dc.w    $0600,$0000,$0000,$0100,$0000,$0000,$0000,$0000
L0001747C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001748C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001749C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000174AC   dc.w    $0000,$0000,$0000,$0027,$0000,$0000,$0010,$4000
L000174BC   dc.w    $0000,$000E,$8000,$0000,$0007,$0000,$0000,$0000
L000174CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000174DC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000174EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000174FC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001750C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001751C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001752C   dc.w    $0000,$0000,$0000,$0000,$00C0,$0000,$0000,$0000
L0001753C   dc.w    $0000,$0000,$0060,$0000,$0000,$0000,$0000,$0000
L0001754C   dc.w    $0030,$0000,$0000,$0000,$0000,$0000,$0018,$0000
L0001755C   dc.w    $0000,$0000,$0000,$0000,$000C,$0000,$0000,$0000
L0001756C   dc.w    $0000,$0000,$0006,$0000,$0000,$0000,$0000,$0000
L0001757C   dc.w    $0003,$0000,$0000,$0000,$0000,$0000,$0003,$8000
L0001758C   dc.w    $0000,$0000,$0000,$0000,$0001,$C000,$0000,$0000
L0001759C   dc.w    $0000,$0000,$0001,$C000,$0000,$0000,$0000,$0000
L000175AC   dc.w    $0000,$E000,$0000,$0000,$0000,$0000,$0000,$F000
L000175BC   dc.w    $0000,$0000,$0000,$0000,$0000,$7000,$0000,$0000
L000175CC   dc.w    $0000,$0000,$0000,$7800,$0000,$0000,$0000,$0000
L000175DC   dc.w    $0000,$3800,$0000,$0000,$0000,$0000,$0000,$0C00
L000175EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000175FC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001760C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001761C   dc.w    $7000,$0000,$0000,$0000,$0000,$0000,$0800,$0000
L0001762C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001763C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001764C   dc.w    $0020,$0000,$0000,$0007,$F800,$0000,$0010,$0000
L0001765C   dc.w    $0000,$01F8,$07C0,$0000,$0008,$0000,$0000,$1E07
L0001766C   dc.w    $F838,$0000,$0004,$0000,$0000,$63FF,$FFC6,$0000
L0001767C   dc.w    $0000,$0000,$0000,$9F00,$1E39,$8000,$0000,$0000
L0001768C   dc.w    $0000,$3800,$01CE,$4000,$0000,$0000,$0002,$6700
L0001769C   dc.w    $0023,$2000,$0000,$0000,$0004,$7000,$0019,$1000
L000176AC   dc.w    $0000,$0000,$0008,$C000,$0000,$9800,$0000,$0000
L000176BC   dc.w    $0011,$8000,$0004,$8C00,$0000,$0000,$0053,$1C00
L000176CC   dc.w    $0002,$C800,$0000,$0000,$0052,$C000,$0402,$4A00
L000176DC   dc.w    $0000,$0000,$00A5,$0000,$0000,$4D00,$0000,$0000
L000176EC   dc.w    $00A5,$F000,$039E,$6500,$0000,$0000,$002B,$FF20
L000176FC   dc.w    $027F,$2640,$0000,$0000,$002B,$2850,$029F,$9280
L0001770C   dc.w    $0000,$0000,$002A,$E411,$C490,$CA80,$0000,$0000
L0001771C   dc.w    $0053,$82FE,$2800,$C140,$0000,$0000,$0051,$00CC
L0001772C   dc.w    $1879,$D100,$0000,$0000,$0053,$9C82,$15A5,$2900
L0001773C   dc.w    $0000,$0000,$0057,$8072,$3300,$9D00,$0000,$0000
L0001774C   dc.w    $0063,$4C58,$0A42,$7200,$0000,$0000,$0065,$C52C
L0001775C   dc.w    $1E16,$7880,$0000,$0000,$00E0,$10D0,$0D8C,$CD00
L0001776C   dc.w    $0000,$0000,$00C1,$4600,$0A35,$76C0,$0000,$0000
L0001777C   dc.w    $00C4,$6070,$1501,$1A00,$0000,$0000,$00E8,$18E6
L0001778C   dc.w    $3BC4,$44C0,$0000,$0000,$00C9,$00C4,$11A0,$0A40
L0001779C   dc.w    $0000,$0000,$00A8,$0108,$1C5C,$2540,$0000,$0000
L000177AC   dc.w    $0082,$0018,$160A,$9200,$0000,$0000,$0062,$000C
L000177BC   dc.w    $110B,$3B08,$0000,$0000,$0054,$8046,$3080,$FB1C
L000177CC   dc.w    $0000,$0000,$006D,$0081,$E083,$6784,$0000,$0000
L000177DC   dc.w    $001A,$0181,$1D41,$B19A,$0000,$0000,$02CA,$0151
L000177EC   dc.w    $4ED0,$5B4A,$0000,$0000,$0074,$0360,$2388,$3CEA
L000177FC   dc.w    $0000,$0000,$0934,$0E00,$2000,$1572,$0000,$0000
L0001780C   dc.w    $0994,$6805,$6003,$07D0,$0000,$0000,$09D4,$C00D
L0001781C   dc.w    $F402,$CAB8,$0000,$0000,$09CC,$201B,$FB01,$21F6
L0001782C   dc.w    $0000,$0000,$0ACC,$381C,$0781,$A346,$0000,$0000
L0001783C   dc.w    $0AF2,$1EFB,$BBE3,$4104,$0000,$0000,$0232,$1F76
L0001784C   dc.w    $4D1F,$0508,$0000,$0000,$0266,$0800,$0002,$0AB0
L0001785C   dc.w    $0000,$0000,$0506,$143F,$FF86,$9EF8,$0000,$0000
L0001786C   dc.w    $0521,$0C5C,$6344,$3EC0,$0000,$0000,$02D9,$123F
L0001787C   dc.w    $0F8A,$29C4,$0000,$0000,$019B,$0C10,$5114,$73C0
L0001788C   dc.w    $0000,$0000,$0019,$0ABD,$57EC,$2298,$0000,$0000
L0001789C   dc.w    $0019,$057F,$FFD8,$C290,$0000,$0000,$0049,$059F
L000178AC   dc.w    $FF38,$C6A0,$0000,$0000,$0005,$C4E3,$F8F0,$8C80
L000178BC   dc.w    $0000,$0000,$002D,$C2B0,$07B1,$8880,$0000,$0000
L000178CC   dc.w    $000C,$E2C0,$0159,$5180,$0000,$0000,$0002,$D120
L000178DC   dc.w    $0030,$3580,$0000,$0000,$0006,$50A1,$0052,$A980
L000178EC   dc.w    $0000,$0000,$0001,$5060,$00A6,$7900,$0000,$0000
L000178FC   dc.w    $0001,$2830,$0065,$7900,$0000,$0000,$0003,$9808
L0001790C   dc.w    $0044,$BB00,$0000,$0000,$0003,$C000,$00CB,$7200
L0001791C   dc.w    $0000,$0000,$0002,$6400,$019E,$7200,$0000,$0000
L0001792C   dc.w    $0002,$3600,$0331,$E600,$0000,$0000,$0000,$9900
L0001793C   dc.w    $0023,$4400,$0000,$0000,$0001,$C780,$004F,$1C00
L0001794C   dc.w    $0000,$0000,$0001,$F6E0,$00DE,$6800,$0000,$0000
L0001795C   dc.w    $0001,$F538,$071E,$9000,$0000,$0000,$0001,$68CF
L0001796C   dc.w    $FFD5,$1000,$0000,$0000,$0001,$3430,$06A8,$2000
L0001797C   dc.w    $0000,$0000,$0000,$985F,$F550,$4000,$0000,$0000
L0001798C   dc.w    $0000,$461F,$8AE0,$8000,$0000,$0000,$0000,$2181
L0001799C   dc.w    $FFC1,$0000,$0000,$0000,$0000,$1878,$5796,$0000
L000179AC   dc.w    $0000,$0000,$0000,$0706,$AFCC,$0000,$0000,$0000
L000179BC   dc.w    $0000,$00C7,$FE30,$0000,$0000,$0000,$0000,$0038
L000179CC   dc.w    $01C0,$0000,$0000,$0000,$0000,$0007,$FE00,$0000
L000179DC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000179EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L000179FC   dc.w    $0000,$0000,$0000,$0000,$0000,$0100,$7000,$0000
L00017A0C   dc.w    $0000,$0000,$0000,$0800,$0E00,$0000,$0000,$0000
L00017A1C   dc.w    $0000,$4000,$0300,$0000,$0000,$0000,$0000,$0000
L00017A2C   dc.w    $0080,$0000,$0000,$0000,$0002,$0000,$0040,$0000
L00017A3C   dc.w    $0000,$0000,$0000,$0000,$0020,$0000,$0000,$0000
L00017A4C   dc.w    $0000,$0000,$0010,$0000,$0000,$0000,$0000,$0000
L00017A5C   dc.w    $0008,$0000,$0000,$0000,$0020,$0000,$0004,$0000
L00017A6C   dc.w    $0000,$0000,$0000,$0000,$0004,$0000,$0000,$0000
L00017A7C   dc.w    $0000,$0000,$0002,$0000,$0000,$0000,$0000,$0000
L00017A8C   dc.w    $0002,$0000,$0000,$0000,$0080,$0000,$0003,$0000
L00017A9C   dc.w    $0000,$0000,$0000,$0000,$0003,$0000,$0000,$0000
L00017AAC   dc.w    $0000,$0000,$0001,$8000,$0000,$0000,$0000,$0000
L00017ABC   dc.w    $0001,$8000,$0000,$0000,$0000,$0000,$0001,$C000
L00017ACC   dc.w    $0000,$0000,$0000,$0000,$0007,$F000,$0000,$0000
L00017ADC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00017AEC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0007
L00017AFC   dc.w    $8000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00017B0C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00017B1C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00017B2C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00017B3C   dc.w    $0000,$0007,$F800,$0000,$0000,$0000,$0000,$01F8
L00017B4C   dc.w    $07C0,$0000,$0000,$0000,$0000,$1E00,$003E,$0000
L00017B5C   dc.w    $0000,$0000,$0000,$6000,$0007,$0000,$0002,$0000
L00017B6C   dc.w    $0000,$80FF,$E001,$C000,$0002,$0000,$0000,$07FF
L00017B7C   dc.w    $FE00,$7000,$0001,$0000,$0002,$18FF,$FFC0,$3800
L00017B8C   dc.w    $0001,$0000,$0004,$0FFF,$FFE0,$1E00,$0000,$0000
L00017B9C   dc.w    $0008,$3FFF,$FFF8,$1F00,$0000,$0000,$0010,$7FFF
L00017BAC   dc.w    $FFF8,$0E80,$0000,$0000,$0050,$E3FF,$FFFE,$0F00
L00017BBC   dc.w    $0000,$0000,$0011,$3FFF,$FBFE,$0F00,$0000,$0000
L00017BCC   dc.w    $00A2,$FFFF,$FBF8,$0F80,$0000,$0000,$00A2,$0FFF
L00017BDC   dc.w    $F806,$0740,$0000,$0000,$0024,$F91F,$FC7F,$0760
L00017BEC   dc.w    $0000,$0000,$0025,$2FCF,$FC98,$03C0,$0000,$0000
L00017BFC   dc.w    $0024,$078E,$380F,$03E0,$0000,$0000,$004C,$7C01
L00017C0C   dc.w    $D1FF,$01F0,$0000,$0000,$004E,$FF03,$EB86,$11B0
L00017C1C   dc.w    $0000,$0000,$004C,$7001,$EE3C,$2198,$0000,$0000
L00017C2C   dc.w    $0048,$50B1,$CCFE,$8188,$0000,$0000,$005C,$EDAB
L00017C3C   dc.w    $EDDD,$00C0,$0000,$0000,$005A,$7DDB,$EB99,$00C0
L00017C4C   dc.w    $0000,$0000,$009F,$4C27,$F642,$31C0,$0000,$0000
L00017C5C   dc.w    $00BE,$A2EF,$F1C4,$88C0,$0000,$0000,$00BB,$9F8F
L00017C6C   dc.w    $E8FE,$E460,$0000,$0000,$0097,$E719,$C43B,$B8D0
L00017C7C   dc.w    $0000,$0000,$00B6,$FF3B,$EE1F,$F440,$0000,$0000
L00017C8C   dc.w    $0097,$FEF7,$E383,$DA40,$0000,$0000,$00BD,$FFE7
L00017C9C   dc.w    $E1E5,$6C60,$0000,$0000,$005D,$FFE3,$E2F4,$C440
L00017CAC   dc.w    $0000,$0000,$004B,$7F91,$DF7E,$0440,$0000,$0000
L00017CBC   dc.w    $00D0,$FF30,$037C,$0018,$0000,$0000,$00C1,$FE32
L00017CCC   dc.w    $023E,$0004,$0000,$0000,$0151,$FE0E,$B02F,$80C4
L00017CDC   dc.w    $0000,$0000,$03E3,$FC9F,$DC77,$C164,$0000,$0000
L00017CEC   dc.w    $0A83,$F1FF,$DFFF,$E0EC,$0000,$0000,$0A03,$87FA
L00017CFC   dc.w    $9FFC,$F24C,$0000,$0000,$0A03,$3FF0,$03FC,$3204
L00017D0C   dc.w    $0000,$0000,$0A13,$9FE0,$00FE,$180A,$0000,$0000
L00017D1C   dc.w    $0913,$87C0,$007E,$183A,$0000,$0000,$0909,$C108
L00017D2C   dc.w    $021C,$B87C,$0000,$0000,$01C9,$C011,$B1C0,$7070
L00017D3C   dc.w    $0000,$0000,$0189,$D0FF,$FFE1,$7100,$0000,$0000
L00017D4C   dc.w    $04E9,$E800,$6061,$6978,$0000,$0000,$04CC,$E020
L00017D5C   dc.w    $0082,$D1E4,$0000,$0000,$0214,$E400,$0004,$C4CC
L00017D6C   dc.w    $0000,$0000,$01B4,$F211,$0109,$A8CC,$0000,$0000
L00017D7C   dc.w    $00F6,$7100,$0011,$98DC,$0000,$0000,$00B6,$7880
L00017D8C   dc.w    $0023,$78DC,$0000,$0000,$00F6,$7860,$00C3,$30F8
L00017D9C   dc.w    $0000,$0000,$00F2,$381C,$0703,$F0F8,$0000,$0000
L00017DAC   dc.w    $007A,$3C4F,$F846,$60B0,$0000,$0000,$003B,$1C3F
L00017DBC   dc.w    $FEA6,$A180,$0000,$0000,$0019,$0E5F,$FFCF,$C180
L00017DCC   dc.w    $0000,$0000,$000D,$8F1E,$FFAD,$4180,$0000,$0000
L00017DDC   dc.w    $0000,$8F9F,$FF59,$9100,$0000,$0000,$0000,$C7CF
L00017DEC   dc.w    $FF9A,$A100,$0000,$0000,$0002,$67F7,$FFBB,$2300
L00017DFC   dc.w    $0000,$0000,$0003,$37FF,$FF34,$4200,$0000,$0000
L00017E0C   dc.w    $0002,$13FF,$FE60,$4200,$0000,$0000,$0002,$09FF
L00017E1C   dc.w    $FCC1,$8600,$0000,$0000,$0000,$04FF,$FFC3,$0400
L00017E2C   dc.w    $0000,$0000,$0001,$007F,$FF8E,$2C00,$0000,$0000
L00017E3C   dc.w    $0001,$001F,$FF1C,$0800,$0000,$0000,$0001,$0A07
L00017E4C   dc.w    $F810,$5000,$0000,$0000,$0001,$1700,$00C0,$9000
L00017E5C   dc.w    $0000,$0000,$0001,$4BC0,$0601,$A000,$0000,$0000
L00017E6C   dc.w    $0000,$A7A3,$F003,$4000,$0000,$0000,$0000,$59E0
L00017E7C   dc.w    $0006,$8000,$0000,$0000,$0000,$267E,$0009,$0000
L00017E8C   dc.w    $0000,$0000,$0000,$1887,$A806,$0000,$0000,$0000
L00017E9C   dc.w    $0000,$0739,$500C,$0000,$0000,$0000,$0000,$00C0
L00017EAC   dc.w    $0030,$0000,$0000,$0000,$0000,$0038,$01C0,$0000
L00017EBC   dc.w    $0000,$0000,$0000,$0007,$FE00,$0000,$0000,$0000
L00017ECC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00017EDC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00017EEC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00017EFC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00017F0C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00017F1C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00017F2C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00017F3C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00017F4C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00017F5C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00017F6C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00017F7C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00017F8C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00017F9C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00017FAC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00017FBC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00017FCC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00017FDC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00017FEC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L00017FFC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001800C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001801C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001802C   dc.w    $0000,$0000,$0000,$0000,$0000,$0007,$F800,$0000
L0001803C   dc.w    $0000,$0000,$0000,$01FF,$FFC0,$0000,$0000,$0000
L0001804C   dc.w    $0000,$1FFF,$FFF8,$0000,$0000,$0000,$0000,$7FFF
L0001805C   dc.w    $FFFE,$0000,$0000,$0000,$0001,$FFFF,$FFFF,$8000
L0001806C   dc.w    $0000,$0000,$0001,$FFFF,$FFFF,$C000,$0000,$0000
L0001807C   dc.w    $0003,$FFFF,$FFFF,$E000,$0000,$0000,$0007,$FFFF
L0001808C   dc.w    $FFFF,$E000,$0000,$0000,$002F,$FFFF,$FFFF,$F000
L0001809C   dc.w    $0000,$0000,$002F,$FFFF,$FFFD,$F000,$0000,$0000
L000180AC   dc.w    $004F,$FFFF,$FFFD,$F000,$0000,$0000,$001F,$FFFF
L000180BC   dc.w    $FFFF,$F000,$0000,$0000,$001F,$FFFF,$FFF9,$F880
L000180CC   dc.w    $0000,$0000,$001F,$06FF,$FF80,$F880,$0000,$0000
L000180DC   dc.w    $001E,$D03F,$FF67,$FC00,$0000,$0000,$001F,$F87F
L000180EC   dc.w    $FFFF,$FC00,$0000,$0000,$003F,$FFFF,$FFFF,$FE00
L000180FC   dc.w    $0000,$0000,$003F,$FFFF,$F7FF,$EE00,$0000,$0000
L0001810C   dc.w    $003F,$E1FF,$F3C3,$DE00,$0000,$0000,$003F,$904F
L0001811C   dc.w    $F68D,$7E00,$0000,$0000,$003F,$22B7,$F126,$FF00
L0001812C   dc.w    $0000,$0000,$003F,$A0F7,$F106,$FF00,$0000,$0000
L0001813C   dc.w    $007F,$B03F,$FA0D,$FE00,$0000,$0000,$007F,$FCFF     
L0001814C   dc.w    $FFCB,$FF00,$0000,$0000,$007F,$FFFF,$FFFF,$FF80     
L0001815C   dc.w    $0000,$0000,$007F,$FFFF,$FFFF,$FF00,$0000,$0000     
L0001816C   dc.w    $007F,$FFFF,$FFFF,$FF80,$0000,$0000,$007F,$FFFF     
L0001817C   dc.w    $FFFF,$FF80,$0000,$0000,$007F,$FFFF,$FFFF,$FF80     
L0001818C   dc.w    $0000,$0000,$003F,$FFFF,$FFFF,$FF98,$0000,$0000     
L0001819C   dc.w    $003F,$FFFF,$E3FF,$FF9C,$0000,$0000,$033F,$FFF1     
L000181AC   dc.w    $E1FF,$FFDC,$0000,$0000,$073F,$FFF3,$FFFF,$FFFE     
L000181BC   dc.w    $0000,$0000,$07BF,$FFFF,$FFFF,$FFBE,$0000,$0000     
L000181CC   dc.w    $079F,$FFFF,$FFFF,$FF9E,$0000,$0000,$07FF,$FFFF     
L000181DC   dc.w    $FFFF,$FF9E,$0000,$0000,$07FF,$FFFF,$FFFF,$FDBE     
L000181EC   dc.w    $0000,$0000,$07FF,$FFF8,$E3FF,$FDFE,$0000,$0000     
L000181FC   dc.w    $07FF,$FFE0,$00FF,$FFFC,$0000,$0000,$07FF,$DFC0     
L0001820C   dc.w    $007F,$7FFC,$0000,$0000,$07FF,$E703,$B81C,$FFF8     
L0001821C   dc.w    $0000,$0000,$07FF,$E00F,$FE00,$FFFC,$0000,$0000     
L0001822C   dc.w    $07FF,$F000,$0001,$FFF8,$0000,$0000,$03FF,$F800     
L0001823C   dc.w    $0001,$F780,$0000,$0000,$03FF,$F800,$0003,$EF00     
L0001824C   dc.w    $0000,$0000,$01EF,$FC00,$0007,$FF00,$0000,$0000     
L0001825C   dc.w    $004F,$FE0F,$FE0F,$DF00,$0000,$0000,$000F,$FF01     
L0001826C   dc.w    $581F,$FF00,$0000,$0000,$004F,$FF80,$003F,$BF00     
L0001827C   dc.w    $0000,$0000,$000F,$FFE0,$00FF,$FF00,$0000,$0000     
L0001828C   dc.w    $000F,$FFFC,$07FF,$7F00,$0000,$0000,$0007,$FFFF     
L0001829C   dc.w    $FFFF,$FF00,$0000,$0000,$0007,$FFFF,$FFFF,$FE00     
L000182AC   dc.w    $0000,$0000,$0007,$FFFF,$FFFF,$FE00,$0000,$0000     
L000182BC   dc.w    $0003,$FFFF,$FFFF,$FE00,$0000,$0000,$0003,$FFFF     
L000182CC   dc.w    $FFFF,$EE00,$0000,$0000,$0003,$FFFF,$FFFF,$DE00     
L000182DC   dc.w    $0000,$0000,$0001,$FFFF,$FFFF,$DC00,$0000,$0000     
L000182EC   dc.w    $0000,$FFFF,$FFFF,$BC00,$0000,$0000,$0001,$FFFF     
L000182FC   dc.w    $FFFF,$BC00,$0000,$0000,$0001,$FFFF,$FFFE,$7800     
L0001830C   dc.w    $0000,$0000,$0001,$FFFF,$FFFC,$F800,$0000,$0000     
L0001831C   dc.w    $0000,$FFFF,$FFF1,$F000,$0000,$0000,$0000,$FFFF     
L0001832C   dc.w    $FFE3,$F000,$0000,$0000,$0000,$FFFF,$FFEF,$E000     
L0001833C   dc.w    $0000,$0000,$0000,$FFFF,$FF3F,$E000,$0000,$0000     
L0001834C   dc.w    $0000,$FFFF,$F9FF,$C000,$0000,$0000,$0000,$7FFC     
L0001835C   dc.w    $0FFF,$8000,$0000,$0000,$0000,$3FFF,$FFFF,$0000     
L0001836C   dc.w    $0000,$0000,$0000,$1FFF,$FFFE,$0000,$0000,$0000     
L0001837C   dc.w    $0000,$07FF,$FFF8,$0000,$0000,$0000,$0000,$00FF     
L0001838C   dc.w    $FFF0,$0000,$0000,$0000,$0000,$003F,$FFC0,$0000     
L0001839C   dc.w    $0000,$0000,$0000,$0007,$FE00,$0000,$0000,$0000     
L000183AC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000183BC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000183CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000183DC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000183EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$00C0,$0000     
L000183FC   dc.w    $0000,$0000,$0000,$0000,$0070,$0000,$0000,$0000     
L0001840C   dc.w    $0000,$0000,$003C,$0000,$0000,$0000,$0000,$0000     
L0001841C   dc.w    $001F,$0000,$0000,$0000,$0000,$0000,$000F,$8000     
L0001842C   dc.w    $0000,$0000,$0000,$0000,$0007,$C000,$0000,$0000     
L0001843C   dc.w    $0000,$0000,$0003,$E000,$0000,$0000,$0000,$0000     
L0001844C   dc.w    $0003,$F000,$0000,$0000,$0000,$0000,$0001,$F800     
L0001845C   dc.w    $0000,$0000,$0000,$0000,$0001,$FC00,$0000,$0000     
L0001846C   dc.w    $0000,$0000,$0000,$FC00,$0000,$0000,$0000,$0000     
L0001847C   dc.w    $0000,$FE00,$0000,$0000,$0000,$0000,$0000,$7E00     
L0001848C   dc.w    $0000,$0000,$0000,$0000,$0000,$7F00,$0000,$0000     
L0001849C   dc.w    $0000,$0000,$0000,$3F00,$0000,$0000,$0000,$0000     
L000184AC   dc.w    $0000,$0F00,$0000,$0000,$0000,$0000,$0000,$0000     
L000184BC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000184CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000184DC   dc.w    $0000,$0000,$7000,$0000,$0000,$0000,$0000,$0000     
L000184EC   dc.w    $0C00,$0000,$0000,$0000,$0000,$0000,$0300,$0000     
L000184FC   dc.w    $0000,$0000,$0000,$0000,$00C0,$0000,$0000,$0000     
L0001850C   dc.w    $0000,$0000,$0020,$0000,$0000,$0000,$0000,$0000     
L0001851C   dc.w    $0010,$0000,$0000,$0000,$0000,$0000,$0008,$0000     
L0001852C   dc.w    $0000,$0000,$0000,$0000,$0004,$0000,$0000,$0000     
L0001853C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001854C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001855C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001856C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001857C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001858C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001859C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000185AC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000185BC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000185CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000185DC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000185EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$1C00     
L000185FC   dc.w    $0000,$0000,$0000,$0000,$0000,$2000,$0100,$0000     
L0001860C   dc.w    $0000,$0000,$0000,$0040,$0200,$0000,$0000,$0000     
L0001861C   dc.w    $0000,$0000,$0600,$0000,$0000,$0000,$0000,$00C0     
L0001862C   dc.w    $0180,$0000,$0000,$0000,$0000,$0300,$0030,$0000     
L0001863C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001864C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001865C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001866C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001867C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001868C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001869C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000186AC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000186BC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000186CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000186DC   dc.w    $0000,$0007,$1C00,$0000,$0000,$0000,$0000,$001F     
L000186EC   dc.w    $FF00,$0000,$0000,$0000,$0000,$203F,$FF80,$8000     
L000186FC   dc.w    $0000,$0000,$0000,$18F4,$45E3,$0000,$0000,$0000     
L0001870C   dc.w    $0000,$1FE0,$003F,$0000,$0000,$0000,$0000,$0800     
L0001871C   dc.w    $0002,$0000,$0000,$0000,$0000,$043F,$9F86,$0000     
L0001872C   dc.w    $0000,$0000,$0000,$065F,$FF4C,$0000,$0000,$0000     
L0001873C   dc.w    $0000,$033F,$FF98,$0000,$0000,$0000,$0000,$0180     
L0001874C   dc.w    $0030,$0000,$0000,$0000,$0000,$00FE,$A7E0,$0000     
L0001875C   dc.w    $0000,$0000,$0000,$007F,$FFC0,$0000,$0000,$0000     
L0001876C   dc.w    $0000,$001F,$FF00,$0000,$0000,$0000,$0000,$0003     
L0001877C   dc.w    $F800,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001878C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001879C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000187AC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000187BC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000187CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000187DC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000187EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000187FC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001880C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001881C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001882C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001883C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001884C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001885C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001886C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001887C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001888C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001889C   dc.w    $0000,$0000,$0000,$0000,$0000,$0130,$0111,$0333     
L000188AC   dc.w    $0555,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000188BC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000188CC   dc.w    $0000,$0000,$0000,$0000,$001E,$F800,$0000,$00F9     
L000188DC   dc.w    $7E00,$0000,$005A,$4F00,$0000,$0110,$4380,$0000     
L000188EC   dc.w    $0618,$00C0,$0000,$0800,$6080,$0000,$0400,$0080     
L000188FC   dc.w    $0000,$0000,$0080,$0000,$0E00,$00C0,$0000,$0B70     
L0001890C   dc.w    $11C0,$0000,$0631,$4180,$0000,$028D,$3E00,$0000     
L0001891C   dc.w    $01ED,$E800,$0000,$003F,$E000,$0000,$0002,$0000     
L0001892C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001893C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001894C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001895C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001896C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001897C   dc.w    $0018,$6000,$0000,$00C0,$3800,$0000,$001C,$9E00     
L0001898C   dc.w    $0000,$02E5,$0700,$0000,$0405,$2380,$0000,$0F0C     
L0001899C   dc.w    $11C0,$0000,$1E04,$D140,$0000,$1A08,$6000,$0000     
L000189AC   dc.w    $1200,$0000,$0000,$1200,$0080,$0000,$1600,$01C0     
L000189BC   dc.w    $0000,$1350,$01C0,$0000,$1840,$A180,$0000,$05EC     
L000189CC   dc.w    $2800,$0000,$03ED,$F500,$0000,$00DF,$F200,$0000     
L000189DC   dc.w    $00F9,$8800,$0000,$0018,$6000,$0000,$0000,$0000     
L000189EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000189FC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L00018A0C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L00018A1C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L00018A2C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L00018A3C   dc.w    $0003,$6000,$0000,$001A,$7800,$0000,$00DB,$4C00     
L00018A4C   dc.w    $0000,$0018,$6200,$0000,$0018,$6180,$0000,$0408     
L00018A5C   dc.w    $00C0,$0000,$0E00,$00C0,$0000,$0C00,$0040,$0000     
L00018A6C   dc.w    $0800,$0000,$0000,$0C20,$1000,$0000,$0775,$F000     
L00018A7C   dc.w    $0000,$0331,$D600,$0000,$0010,$0C00,$0000,$0020     
L00018A8C   dc.w    $1000,$0000,$0007,$8000,$0000,$0000,$0000,$0000     
L00018A9C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L00018AAC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L00018ABC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L00018ACC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L00018ADC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L00018AEC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L00018AFC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L00018B0C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L00018B1C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L00018B2C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L00018B3C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L00018B4C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L00018B5C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L00018B6C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L00018B7C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L00018B8C   dc.w    $0000,$0000,$0000,$0057,$0000,$0000,$0000,$0000     
L00018B9C   dc.w    $0000,$000B,$E000,$0000,$0000,$0000,$0006,$7606     
L00018BAC   dc.w    $1800,$0000,$0000,$0000,$01FF,$EFFF,$3E00,$0000     
L00018BBC   dc.w    $0000,$0000,$0FD9,$D9FF,$7D80,$0000,$0000,$0000     
L00018BCC   dc.w    $7FE8,$B9FC,$E2E0,$0000,$0000,$0001,$FF59,$73CE     
L00018BDC   dc.w    $FA30,$0000,$0000,$0007,$B970,$43C1,$FE58,$0000     
L00018BEC   dc.w    $0000,$001F,$41E8,$01E0,$2FAC,$0000,$0000,$003F     
L00018BFC   dc.w    $0398,$01D0,$0FD2,$0000,$0000,$0078,$027C,$03B0     
L00018C0C   dc.w    $03E0,$0000,$0000,$00F0,$03FC,$03F0,$0070,$0000     
L00018C1C   dc.w    $0000,$01E0,$03FC,$03F0,$0018,$0000,$0000,$03C0     
L00018C2C   dc.w    $03F0,$00E0,$009C,$0000,$0000,$03C0,$00F0,$0260     
L00018C3C   dc.w    $014C,$0000,$0000,$0480,$0000,$0110,$0038,$0000     
L00018C4C   dc.w    $0000,$0540,$0000,$0080,$003B,$0000,$0000,$0320     
L00018C5C   dc.w    $0000,$0000,$0013,$0000,$0000,$0B40,$0000,$0000     
L00018C6C   dc.w    $0033,$0000,$0000,$0880,$0000,$0000,$003B,$0000     
L00018C7C   dc.w    $0000,$0380,$0000,$0000,$000F,$0000,$0000,$07C0     
L00018C8C   dc.w    $0000,$0000,$001E,$0000,$0000,$05C0,$0E00,$0807     
L00018C9C   dc.w    $003E,$0000,$0000,$04F0,$1F00,$0A0F,$80FE,$0000     
L00018CAC   dc.w    $0000,$0210,$0F8C,$2813,$80F8,$0000,$0000,$01E0     
L00018CBC   dc.w    $0FB8,$1381,$80F0,$0000,$0000,$00FC,$1FF1,$03D1     
L00018CCC   dc.w    $83D0,$0000,$0000,$033B,$0FDF,$0C01,$0F80,$0000     
L00018CDC   dc.w    $0000,$019E,$073F,$8822,$3F00,$0000,$0000,$00E4     
L00018CEC   dc.w    $C27F,$9074,$7E00,$0000,$0000,$0061,$F2FF,$23F8     
L00018CFC   dc.w    $FE00,$0000,$0000,$0019,$FCFF,$9FFB,$E800,$0000     
L00018D0C   dc.w    $0000,$000E,$7FFF,$FFFE,$E000,$0000,$0000,$0001     
L00018D1C   dc.w    $0FFF,$FFF3,$0000,$0000,$0000,$0000,$0007,$E770     
L00018D2C   dc.w    $0000,$0000,$0000,$0000,$0000,$C200,$0000,$0000     
L00018D3C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L00018D4C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0007,$FE00     
L00018D5C   dc.w    $0000,$0000,$0000,$0000,$01F8,$01F8,$0000,$0000     
L00018D6C   dc.w    $0000,$0000,$0E00,$007F,$0000,$0000,$0000,$0000     
L00018D7C   dc.w    $7000,$007F,$E000,$0000,$0000,$0001,$8001,$86FE     
L00018D8C   dc.w    $1800,$0000,$0000,$0006,$01FC,$0E07,$0600,$0000     
L00018D9C   dc.w    $0000,$0018,$0FDC,$1801,$0180,$0000,$0000,$0060     
L00018DAC   dc.w    $7EA5,$3803,$1CE0,$0000,$0000,$0081,$FFC4,$783F     
L00018DBC   dc.w    $0430,$0000,$0000,$0107,$888C,$3031,$0678,$0000     
L00018DCC   dc.w    $0000,$02DF,$8114,$0218,$13BC,$0000,$0000,$07FC     
L00018DDC   dc.w    $0264,$022C,$03FE,$0000,$0000,$0FF8,$0384,$0044     
L00018DEC   dc.w    $03FF,$0000,$0000,$1FF8,$0004,$000C,$01EF,$8000     
L00018DFC   dc.w    $0000,$1FF0,$000C,$0204,$00FF,$8000,$0000,$3FE0     
L00018E0C   dc.w    $0006,$070C,$006F,$C000,$0000,$3FE0,$010C,$0388     
L00018E1C   dc.w    $001F,$C000,$0000,$7CC0,$00F8,$01D0,$0003,$E000     
L00018E2C   dc.w    $0000,$7C20,$0010,$0080,$0003,$6000,$0000,$7840     
L00018E3C   dc.w    $0000,$0000,$0003,$2000,$0000,$7820,$0000,$0000     
L00018E4C   dc.w    $0033,$2000,$0000,$78C0,$0000,$0000,$003B,$2000     
L00018E5C   dc.w    $0000,$73C0,$0000,$0000,$002F,$2000,$0000,$63E0     
L00018E6C   dc.w    $0000,$0000,$005E,$2000,$0000,$29E0,$0E00,$0807     
L00018E7C   dc.w    $007E,$4000,$0000,$30F0,$1100,$0A01,$80FE,$4000     
L00018E8C   dc.w    $0000,$1C10,$108C,$2780,$80F8,$8000,$0000,$1A00     
L00018E9C   dc.w    $1080,$0C50,$80F0,$8000,$0000,$0908,$0041,$0C30     
L00018EAC   dc.w    $81C1,$0000,$0000,$06C0,$001F,$0800,$0082,$0000     
L00018EBC   dc.w    $0000,$0360,$003F,$8020,$2104,$0000,$0000,$0198     
L00018ECC   dc.w    $D47F,$8072,$C008,$0000,$0000,$00E7,$FCFF,$03FF     
L00018EDC   dc.w    $0010,$0000,$0000,$0078,$7EFF,$BFFF,$1060,$0000     
L00018EEC   dc.w    $0000,$001F,$8FFF,$FFFE,$0180,$0000,$0000,$0007     
L00018EFC   dc.w    $F1FF,$FFF4,$0600,$0000,$0000,$0001,$FE07,$E700     
L00018F0C   dc.w    $1800,$0000,$0000,$0000,$7FC0,$3C00,$E000,$0000     
L00018F1C   dc.w    $0000,$0000,$0F80,$0007,$0000,$0000,$0000,$0000     
L00018F2C   dc.w    $01F8,$01F8,$0000,$0000,$0000,$0000,$0000,$0000     
L00018F3C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L00018F4C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L00018F5C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0007,$F801     
L00018F6C   dc.w    $E000,$0000,$0000,$0000,$0003,$F1F8,$F800,$0000     
L00018F7C   dc.w    $0000,$0000,$0023,$E3FE,$FE00,$0000,$0000,$0000     
L00018F8C   dc.w    $0159,$C3FF,$FF00,$0000,$0000,$0000,$00B9,$83E1     
L00018F9C   dc.w    $FFC0,$0000,$0000,$0000,$7178,$F3E0,$F980,$0000     
L00018FAC   dc.w    $0000,$0000,$C0F8,$03F0,$3C40,$0000,$0000,$0003     
L00018FBC   dc.w    $01F8,$03F8,$0C00,$0000,$0000,$0004,$01F8,$03F8     
L00018FCC   dc.w    $0000,$0000,$0000,$0000,$03F8,$03F8,$0090,$0000     
L00018FDC   dc.w    $0000,$0000,$03F0,$01F8,$0060,$0000,$0000,$0000     
L00018FEC   dc.w    $03F8,$01F0,$00F0,$0000,$0000,$0000,$01F0,$01F0     
L00018FFC   dc.w    $0170,$0000,$0000,$0300,$00E0,$00E0,$003C,$0000     
L0001900C   dc.w    $0000,$03C0,$0000,$0000,$003C,$0000,$0000,$07E0     
L0001901C   dc.w    $0000,$0000,$003C,$0000,$0000,$07C0,$0000,$0000     
L0001902C   dc.w    $000C,$0000,$0000,$0700,$0000,$0000,$0004,$0000     
L0001903C   dc.w    $0000,$0C00,$0000,$0000,$0010,$0000,$0000,$1C00     
L0001904C   dc.w    $0000,$0000,$0020,$0000,$0000,$1600,$0000,$0000     
L0001905C   dc.w    $0000,$0000,$0000,$0F00,$0E00,$000E,$0000,$0000     
L0001906C   dc.w    $0000,$07E0,$1F10,$0C1F,$0004,$0000,$0000,$07F8     
L0001907C   dc.w    $1F3E,$1F9F,$0108,$0000,$0000,$07F4,$1FBE,$0FCF     
L0001908C   dc.w    $0230,$0000,$0000,$01FF,$0FE0,$07FF,$0F60,$0000     
L0001909C   dc.w    $0000,$00FF,$C7C0,$1FDE,$1EC0,$0000,$0000,$007F     
L000190AC   dc.w    $2780,$1F8E,$3F80,$0000,$0000,$001E,$0300,$BC04     
L000190BC   dc.w    $FE00,$0000,$0000,$0007,$8100,$2000,$F800,$0000     
L000190CC   dc.w    $0000,$0000,$7000,$0001,$E000,$0000,$0000,$0000     
L000190DC   dc.w    $0E00,$000F,$0000,$0000,$0000,$0000,$01F8,$18F8     
L000190EC   dc.w    $0000,$0000,$0000,$0000,$0007,$FE00,$0000,$0000     
L000190FC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001910C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001911C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001912C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001913C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001914C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001915C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001916C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001917C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001918C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001919C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000191AC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000191BC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000191CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000191DC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000191EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000191FC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001920C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001921C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001922C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001923C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001924C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001925C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001926C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001927C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001928C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001929C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000192AC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000192BC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000192CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000192DC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L000192EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0130,$0111     
L000192FC   dc.w    $0333,$0555

            ; font 8x8
L00019300   dc.b    $3C,$66,$6E,$6E,$60,$62,$3C,$00
            dc.b    $00,$00,$3C,$06     
L0001930C   dc.w    $3E66,$3E00,$0060,$607C,$6666,$7C00,$0000,$3C60     
L0001931C   dc.w    $6060,$3C00,$0006,$063E,$6666,$3E00,$0000,$3C66     
L0001932C   dc.w    $7E60,$3C00,$000E,$183E,$1818,$1800,$0000,$3E66     
L0001933C   dc.w    $663E,$067C,$0060,$607C,$6666,$6600,$0018,$0038     
L0001934C   dc.w    $1818,$3C00,$0006,$0006,$0606,$063C,$0060,$606C     
L0001935C   dc.w    $786C,$6600,$0038,$1818,$1818,$3C00,$0000,$667F     
L0001936C   dc.w    $7F6B,$6300,$0000,$7C66,$6666,$6600,$0000,$3C66     
L0001937C   dc.w    $6666,$3C00,$0000,$7C66,$667C,$6060,$0000,$3E66     
L0001938C   dc.w    $663E,$0606,$0000,$7C66,$6060,$6000,$0000,$3E60     
L0001939C   dc.w    $3C06,$7C00,$0018,$7E18,$1818,$0E00,$0000,$6666     
L000193AC   dc.w    $6666,$3E00,$0000,$6666,$663C,$1800,$0000,$636B     
L000193BC   dc.w    $7F3E,$3600,$0000,$663C,$183C,$6600,$0000,$6666     
L000193CC   dc.w    $663E,$0C78,$0000,$7E0C,$1830,$7E00,$3C30,$3030     
L000193DC   dc.w    $3030,$3C00,$0C12,$307C,$3062,$FC00,$3C0C,$0C0C     
L000193EC   dc.w    $0C0C,$3C00,$0018,$3C7E,$1818,$1818,$0010,$307F     
L000193FC   dc.w    $7F30,$1000,$0000,$0000,$0000,$0000,$1818,$1818     
L0001940C   dc.w    $0000,$1800,$6666,$6600,$0000,$0000,$6666,$FF66     
L0001941C   dc.w    $FF66,$6600,$183E,$603C,$067C,$1800,$6266,$0C18     
L0001942C   dc.w    $3066,$4600,$3C66,$3C38,$6766,$3F00,$060C,$1800     
L0001943C   dc.w    $0000,$0000,$0C18,$3030,$3018,$0C00,$3018,$0C0C     
L0001944C   dc.w    $0C18,$3000,$0066,$3CFF,$3C66,$0000,$0018,$187E     
L0001945C   dc.w    $1818,$0000,$0000,$0000,$0018,$1830,$0000,$007E     
L0001946C   dc.w    $0000,$0000,$0000,$0000,$0018,$1800,$0003,$060C     
L0001947C   dc.w    $1830,$6000,$3C66,$6E76,$6666,$3C00,$1818,$3818     
L0001948C   dc.w    $1818,$7E00,$3C66,$060C,$3060,$7E00,$3C66,$061C     
L0001949C   dc.w    $0666,$3C00,$060E,$1E66,$7F06,$0600,$7E60,$7C06     
L000194AC   dc.w    $0666,$3C00,$3C66,$607C,$6666,$3C00,$7E66,$0C18     
L000194BC   dc.w    $1818,$1800,$3C66,$663C,$6666,$3C00,$3C66,$663E     
L000194CC   dc.w    $0666,$3C00,$0000,$1800,$0018,$0000,$0000,$1800     
L000194DC   dc.w    $0018,$1830,$0E18,$3060,$3018,$0E00,$0000,$7E00     
L000194EC   dc.w    $7E00,$0000,$7018,$0C06,$0C18,$7000,$3C66,$060C     
L000194FC   dc.w    $1800,$1800,$0000,$00FF,$FF00,$0000,$183C,$667E     
L0001950C   dc.w    $6666,$6600,$7C66,$667C,$6666,$7C00,$3C66,$6060     
L0001951C   dc.w    $6066,$3C00,$786C,$6666,$666C,$7800,$7E60,$6078     
L0001952C   dc.w    $6060,$7E00,$7E60,$6078,$6060,$6000,$3C66,$606E     
L0001953C   dc.w    $6666,$3C00,$6666,$667E,$6666,$6600,$3C18,$1818     
L0001954C   dc.w    $1818,$3C00,$1E0C,$0C0C,$0C6C,$3800,$666C,$7870     
L0001955C   dc.w    $786C,$6600,$6060,$6060,$6060,$7E00,$6377,$7F6B     
L0001956C   dc.w    $6363,$6300,$6676,$7E7E,$6E66,$6600,$3C66,$6666     
L0001957C   dc.w    $6666,$3C00,$7C66,$667C,$6060,$6000,$3C66,$6666     
L0001958C   dc.w    $663C,$0E00,$7C66,$667C,$786C,$6600,$3C66,$603C     
L0001959C   dc.w    $0666,$3C00,$7E18,$1818,$1818,$1800,$6666,$6666     
L000195AC   dc.w    $6666,$3C00,$6666,$6666,$663C,$1800,$6363,$636B     
L000195BC   dc.w    $7F77,$6300,$6666,$3C18,$3C66,$6600,$6666,$663C     
L000195CC   dc.w    $1818,$1800,$7E06,$0C18,$3060,$7E00,$1818,$18FF     
L000195DC   dc.w    $FF18,$1818,$C0C0,$3030,$C0C0,$3030,$1818,$1818     
L000195EC   dc.w    $1818,$1818,$3333,$CCCC,$3333,$CCCC,$3399,$CC66     
L000195FC   dc.w    $3399,$CC66,$0000,$0000,$0000,$0000,$F0F0,$F0F0     
L0001960C   dc.w    $F0F0,$F0F0,$0000,$0000,$FFFF,$FFFF,$FF00,$0000     
L0001961C   dc.w    $0000,$0000,$0000,$0000,$0000,$00FF,$C0C0,$C0C0     
L0001962C   dc.w    $C0C0,$C0C0,$CCCC,$3333,$CCCC,$3333,$0303,$0303     
L0001963C   dc.w    $0303,$0303,$0000,$0000,$CCCC,$3333,$CC99,$3366     
L0001964C   dc.w    $CC99,$3366,$0303,$0303,$0303,$0303,$1818,$181F     
L0001965C   dc.w    $1F18,$1818,$0000,$0000,$0F0F,$0F0F,$1818,$181F     
L0001966C   dc.w    $1F00,$0000,$0000,$00F8,$F818,$1818,$0000,$0000     
L0001967C   dc.w    $0000,$FFFF,$0000,$001F,$1F18,$1818,$1818,$18FF     
L0001968C   dc.w    $FF00,$0000,$0000,$00FF,$FF18,$1818,$1818,$18F8     
L0001969C   dc.w    $F818,$1818,$C0C0,$C0C0,$C0C0,$C0C0,$E0E0,$E0E0     
L000196AC   dc.w    $E0E0,$E0E0,$0707,$0707,$0707,$0707,$FFFF,$0000     
L000196BC   dc.w    $0000,$0000,$FFFF,$FF00,$0000,$0000,$0000,$0000     
L000196CC   dc.w    $00FF,$FFFF,$0103,$066C,$7870,$6000,$0000,$0000     
L000196DC   dc.w    $F0F0,$F0F0,$0F0F,$0F0F,$0000,$0000,$1818,$18F8     
L000196EC   dc.w    $F800,$0000,$F0F0,$F0F0,$0000,$0000,$F0F0,$F0F0     
L000196FC   dc.w    $0F0F,$0F0F,$C399,$9191,$9F99,$C3FF,$FFFF,$C3F9     
L0001970C   dc.w    $C199,$C1FF,$FF9F,$9F83,$9999,$83FF,$FFFF,$C39F     
L0001971C   dc.w    $9F9F,$C3FF,$FFF9,$F9C1,$9999,$C1FF,$FFFF,$C399     
L0001972C   dc.w    $819F,$C3FF,$FFF1,$E7C1,$E7E7,$E7FF,$FFFF,$C199     
L0001973C   dc.w    $99C1,$F983,$FF9F,$9F83,$9999,$99FF,$FFE7,$FFC7     
L0001974C   dc.w    $E7E7,$C3FF,$FFF9,$FFF9,$F9F9,$F9C3,$FF9F,$9F93     
L0001975C   dc.w    $8793,$99FF,$FFC7,$E7E7,$E7E7,$C3FF,$FFFF,$9980     
L0001976C   dc.w    $8094,$9CFF,$FFFF,$8399,$9999,$99FF,$FFFF,$C399     
L0001977C   dc.w    $9999,$C3FF,$FFFF,$8399,$9983,$9F9F,$FFFF,$C199     
L0001978C   dc.w    $99C1,$F9F9,$FFFF,$8399,$9F9F,$9FFF,$FFFF,$C19F     
L0001979C   dc.w    $C3F9,$83FF,$FFE7,$81E7,$E7E7,$F1FF,$FFFF,$9999     
L000197AC   dc.w    $9999,$C1FF,$FFFF,$9999,$99C3,$E7FF,$FFFF,$9C94     
L000197BC   dc.w    $80C1,$C9FF,$FFFF,$99C3,$E7C3,$99FF,$FFFF,$9999     
L000197CC   dc.w    $99C1,$F387,$FFFF,$81F3,$E7CF,$81FF,$C3CF,$CFCF     
L000197DC   dc.w    $CFCF,$C3FF,$F3ED,$CF83,$CF9D,$03FF,$C3F3,$F3F3     
L000197EC   dc.w    $F3F3,$C3FF,$FFE7,$C381,$E7E7,$E7E7,$FFEF,$CF80     
L000197FC   dc.w    $80CF,$EFFF,$FFFF,$FFFF,$FFFF,$FFFF,$E7E7,$E7E7     
L0001980C   dc.w    $FFFF,$E7FF,$9999,$99FF,$FFFF,$FFFF,$9999,$0099     
L0001981C   dc.w    $0099,$99FF,$E7C1,$9FC3,$F983,$E7FF,$9D99,$F3E7     
L0001982C   dc.w    $CF99,$B9FF,$C399,$C3C7,$9899,$C0FF,$F9F3,$E7FF     
L0001983C   dc.w    $FFFF,$FFFF,$F3E7,$CFCF,$CFE7,$F3FF,$CFE7,$F3F3     
L0001984C   dc.w    $F3E7,$CFFF,$FF99,$C300,$C399,$FFFF,$FFE7,$E781     
L0001985C   dc.w    $E7E7,$FFFF,$FFFF,$FFFF,$FFE7,$E7CF,$FFFF,$FF81     
L0001986C   dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFE7,$E7FF,$FFFC,$F9F3     
L0001987C   dc.w    $E7CF,$9FFF,$C399,$9189,$9999,$C3FF,$E7E7,$C7E7     
L0001988C   dc.w    $E7E7,$81FF,$C399,$F9F3,$CF9F,$81FF,$C399,$F9E3     
L0001989C   dc.w    $F999,$C3FF,$F9F1,$E199,$80F9,$F9FF,$819F,$83F9     
L000198AC   dc.w    $F999,$C3FF,$C399,$9F83,$9999,$C3FF,$8199,$F3E7     
L000198BC   dc.w    $E7E7,$E7FF,$C399,$99C3,$9999,$C3FF,$C399,$99C1     
L000198CC   dc.w    $F999,$C3FF,$FFFF,$E7FF,$FFE7,$FFFF,$FFFF,$E7FF     
L000198DC   dc.w    $FFE7,$E7CF,$F1E7,$CF9F,$CFE7,$F1FF,$FFFF,$81FF     
L000198EC   dc.w    $81FF,$FFFF,$8FE7,$F3F9,$F3E7,$8FFF,$C399,$F9F3     
L000198FC   dc.w    $E7FF,$E7FF,$FFFF,$FF00,$00FF,$FFFF,$E7C3,$9981     
L0001990C   dc.w    $9999,$99FF,$8399,$9983,$9999,$83FF,$C399,$9F9F     
L0001991C   dc.w    $9F99,$C3FF,$8793,$9999,$9993,$87FF,$819F,$9F87     
L0001992C   dc.w    $9F9F,$81FF,$819F,$9F87,$9F9F,$9FFF,$C399,$9F91     
L0001993C   dc.w    $9999,$C3FF,$9999,$9981,$9999,$99FF,$C3E7,$E7E7     
L0001994C   dc.w    $E7E7,$C3FF,$E1F3,$F3F3,$F393,$C7FF,$9993,$878F     
L0001995C   dc.w    $8793,$99FF,$9F9F,$9F9F,$9F9F,$81FF,$9C88,$8094     
L0001996C   dc.w    $9C9C,$9CFF,$9989,$8181,$9199,$99FF,$C399,$9999     
L0001997C   dc.w    $9999,$C3FF,$8399,$9983,$9F9F,$9FFF,$C399,$9999     
L0001998C   dc.w    $99C3,$F1FF,$8399,$9983,$8793,$99FF,$C399,$9FC3     
L0001999C   dc.w    $F999,$C3FF,$81E7,$E7E7,$E7E7,$E7FF,$9999,$9999     
L000199AC   dc.w    $9999,$C3FF,$9999,$9999,$99C3,$E7FF,$9C9C,$9C94     
L000199BC   dc.w    $8088,$9CFF,$9999,$C3E7,$C399,$99FF,$9999,$99C3     
L000199CC   dc.w    $E7E7,$E7FF,$81F9,$F3E7,$CF9F,$81FF,$E7E7,$E700     
L000199DC   dc.w    $00E7,$E7E7,$3F3F,$CFCF,$3F3F,$CFCF,$E7E7,$E7E7     
L000199EC   dc.w    $E7E7,$E7E7,$CCCC,$3333,$CCCC,$3333,$CC66,$3399     
L000199FC   dc.w    $CC66,$3399,$FFFF,$FFFF,$FFFF,$FFFF,$0F0F,$0F0F     
L00019A0C   dc.w    $0F0F,$0F0F,$FFFF,$FFFF,$0000,$0000,$00FF,$FFFF     
L00019A1C   dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FF00,$3F3F,$3F3F     
L00019A2C   dc.w    $3F3F,$3F3F,$3333,$CCCC,$3333,$CCCC,$FCFC,$FCFC     
L00019A3C   dc.w    $FCFC,$FCFC,$FFFF,$FFFF,$3333,$CCCC,$3366,$CC99     
L00019A4C   dc.w    $3366,$CC99,$FCFC,$FCFC,$FCFC,$FCFC,$E7E7,$E7E0     
L00019A5C   dc.w    $E0E7,$E7E7,$FFFF,$FFFF,$F0F0,$F0F0,$E7E7,$E7E0     
L00019A6C   dc.w    $E0FF,$FFFF,$FFFF,$FF07,$07E7,$E7E7,$FFFF,$FFFF     
L00019A7C   dc.w    $FFFF,$0000,$FFFF,$FFE0,$E0E7,$E7E7,$E7E7,$E700     
L00019A8C   dc.w    $00FF,$FFFF,$FFFF,$FF00,$00E7,$E7E7,$E7E7,$E707     
L00019A9C   dc.w    $07E7,$E7E7,$3F3F,$3F3F,$3F3F,$3F3F,$1F1F,$1F1F     
L00019AAC   dc.w    $1F1F,$1F1F,$F8F8,$F8F8,$F8F8,$F8F8,$0000,$FFFF     
L00019ABC   dc.w    $FFFF,$FFFF,$0000,$00FF,$FFFF,$FFFF,$FFFF,$FFFF     
L00019ACC   dc.w    $FF00,$0000,$FEFC,$F993,$878F,$9FFF,$FFFF,$FFFF     
L00019ADC   dc.w    $0F0F,$0F0F,$F0F0,$F0F0,$FFFF,$FFFF,$E7E7,$E707     
L00019AEC   dc.w    $07FF,$FFFF,$0F0F,$0F0F,$FFFF,$FFFF,$0F00,$006C     
L00019AFC   dc.w    $0000,$0069,$0000,$0000,$0000,$0041,$C000,$0FD7     
L00019B0C   dc.w    $8000,$0000,$0000,$0000,$0000,$0B90,$0000,$0DE0     
L00019B1C   dc.w    $0000,$09EC,$0000,$0D74,$0000,$1F74,$0000,$1A78     
L00019B2C   dc.w    $4000,$3820,$E000,$3203,$A000,$1EC6,$0000,$0FC0     
L00019B3C   dc.w    $0000,$0000,$0000,$0000,$0000,$7FE0,$0000,$7FF0     
L00019B4C   dc.w    $0000,$FFF8,$0000,$FFF8,$0000,$FFF8,$4000,$FFF9     
L00019B5C   dc.w    $E000,$7FFB,$F000,$7FFF,$F000,$7FFF,$E000,$3FFF     
L00019B6C   dc.w    $C000,$3FFF,$8000,$5FC0,$0000,$2740,$0000,$73F0     
L00019B7C   dc.w    $0000,$7170,$0000,$71F0,$0000,$69B0,$0000,$31F0     
L00019B8C   dc.w    $0000,$3403,$A000,$3816,$4000,$1FD0,$8000,$0000     
L00019B9C   dc.w    $0000,$2000,$0000,$1800,$0000,$0C00,$0000,$0880     
L00019BAC   dc.w    $0000,$0C00,$0000,$1440,$0000,$0800,$4000,$0803     
L00019BBC   dc.w    $8000,$0357,$C000,$0007,$8000,$0000,$0000,$2C40     
L00019BCC   dc.w    $0000,$1700,$0000,$3BB0,$0000,$31D0,$0000,$38C0     
L00019BDC   dc.w    $0000,$3CE0,$0000,$1860,$0000,$1400,$2000,$1A41     
L00019BEC   dc.w    $C000,$0FD7,$8000,$0000,$0000,$2C40,$0000,$1700     
L00019BFC   dc.w    $0000,$3BB0,$0000,$35D0,$0000,$38C0,$0000,$3CE0     
L00019C0C   dc.w    $4000,$1860,$E000,$1403,$A000,$1AC6,$0000,$0FC0     
L00019C1C   dc.w    $0000,$0000,$0000,$03FF,$0000,$07FF,$0000,$07FF     
L00019C2C   dc.w    $0000,$07FF,$8000,$0FFF,$8000,$0FFF,$C000,$1FFF     
L00019C3C   dc.w    $C000,$1FFF,$E000,$3FFF,$E000,$3FFF,$E000,$3FFF     
L00019C4C   dc.w    $E000,$1FFF,$E000,$1FC7,$E000,$3F87,$E000,$3F87     
L00019C5C   dc.w    $E000,$3F07,$E000,$3F07,$E000,$7E07,$E000,$7E03     
L00019C6C   dc.w    $C000,$7F07,$F000,$7FC7,$FC00,$7FC7,$FC00,$0180     
L00019C7C   dc.w    $0000,$03FC,$0000,$03FC,$0000,$03F6,$0000,$07FE     
L00019C8C   dc.w    $0000,$07F6,$8000,$0FFE,$8000,$0EEE,$8000,$1FEE     
L00019C9C   dc.w    $8000,$1FFE,$8000,$1F2A,$C000,$0000,$8000,$0F83     
L00019CAC   dc.w    $C000,$1F03,$C000,$1D03,$C000,$1A00,$0000,$0003     
L00019CBC   dc.w    $8000,$3800,$0000,$0000,$0000,$0400,$4000,$1801     
L00019CCC   dc.w    $8000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L00019CDC   dc.w    $0000,$0008,$0000,$0000,$0000,$0008,$0000,$0000     
L00019CEC   dc.w    $0000,$0110,$4000,$0010,$4000,$0000,$4000,$0014     
L00019CFC   dc.w    $0000,$0000,$4000,$0000,$0000,$0000,$0000,$0200     
L00019D0C   dc.w    $0000,$0400,$0000,$0000,$4000,$0400,$0000,$0000     
L00019D1C   dc.w    $0000,$2C02,$C000,$1981,$9800,$0000,$0000,$0000     
L00019D2C   dc.w    $0000,$0300,$0000,$03FC,$0000,$03FC,$0000,$03FC     
L00019D3C   dc.w    $0000,$03FC,$0000,$03BC,$0000,$07FC,$4000,$07B8     
L00019D4C   dc.w    $4000,$073A,$4000,$001E,$0000,$0000,$4000,$0000     
L00019D5C   dc.w    $0000,$0000,$0000,$0200,$0000,$0400,$0000,$0000     
L00019D6C   dc.w    $4000,$0400,$0000,$0000,$0000,$0000,$0000,$0100     
L00019D7C   dc.w    $1000,$0000,$0000,$0000,$0000,$0300,$0000,$03FC     
L00019D8C   dc.w    $0000,$03FC,$0000,$03FC,$0000,$03FC,$0000,$03BC     
L00019D9C   dc.w    $0000,$07FC,$4000,$07B8,$4000,$073A,$4000,$001E     
L00019DAC   dc.w    $0000,$0000,$4000,$0000,$0000,$0000,$0000,$0200     
L00019DBC   dc.w    $0000,$0400,$0000,$0000,$4000,$0400,$0000,$0000     
L00019DCC   dc.w    $0000,$0000,$0000,$0100,$1000,$0000,$0000,$00FF     
L00019DDC   dc.w    $C000,$00FF,$C000,$01FF,$C000,$01FF,$C000,$01FF     
L00019DEC   dc.w    $E000,$03FF,$E000,$03FF,$F000,$07FF,$F800,$07FF     
L00019DFC   dc.w    $FC00,$0FFF,$FC00,$0FFF,$FC00,$0FFF,$FC00,$1FC0     
L00019E0C   dc.w    $FC00,$1F80,$FC00,$3F80,$7E00,$3F00,$7E00,$3F00     
L00019E1C   dc.w    $7F00,$3F00,$3F80,$7E00,$3F80,$7F00,$1FC0,$1F80     
L00019E2C   dc.w    $1FF0,$0780,$1FF0,$0060,$0000,$007F,$0000,$00FF     
L00019E3C   dc.w    $0000,$00FE,$8000,$00FF,$C000,$01FE,$C000,$01FE     
L00019E4C   dc.w    $C000,$03BD,$C000,$03FD,$C000,$07FB,$8000,$07CF     
L00019E5C   dc.w    $9000,$0000,$1000,$0F80,$7000,$0E00,$7000,$0600     
L00019E6C   dc.w    $3800,$1200,$1800,$0C00,$0000,$1000,$1800,$1000     
L00019E7C   dc.w    $0000,$0C00,$0100,$0000,$0600,$0000,$0000,$0000     
L00019E8C   dc.w    $0000,$0000,$0000,$0000,$0000,$0001,$0000,$0000     
L00019E9C   dc.w    $0000,$0001,$0000,$0001,$0000,$0042,$1000,$0002     
L00019EAC   dc.w    $1800,$0004,$5800,$0000,$4800,$0000,$0800,$0000     
L00019EBC   dc.w    $0800,$0100,$0800,$0100,$0400,$0000,$0400,$0200     
L00019ECC   dc.w    $0000,$0000,$0700,$1400,$0000,$0E00,$0B00,$0300     
L00019EDC   dc.w    $0660,$0000,$0000,$0000,$0000,$0040,$0000,$00FF     
L00019EEC   dc.w    $0000,$007F,$0000,$007F,$8000,$00FF,$8000,$00EF     
L00019EFC   dc.w    $8000,$00FF,$8000,$01EF,$1000,$01CF,$5800,$0007     
L00019F0C   dc.w    $C800,$0000,$0800,$0000,$0800,$0100,$0800,$0100     
L00019F1C   dc.w    $0400,$0000,$0400,$0200,$0000,$0000,$0600,$0000     
L00019F2C   dc.w    $0000,$0000,$0000,$0200,$0040,$0000,$0000,$0000     
L00019F3C   dc.w    $0000,$0040,$0000,$00FF,$0000,$007F,$0000,$007F     
L00019F4C   dc.w    $8000,$00FF,$8000,$00EF,$8000,$00FF,$8000,$01EF     
L00019F5C   dc.w    $1000,$01CF,$5800,$0007,$C800,$0000,$0800,$0000     
L00019F6C   dc.w    $0800,$0100,$0800,$0100,$0400,$0000,$0400,$0200     
L00019F7C   dc.w    $0000,$0000,$0600,$0000,$0000,$0000,$0000,$0200     
L00019F8C   dc.w    $0040,$0000,$0000,$003F,$F000,$003F,$F000,$003F     
L00019F9C   dc.w    $F000,$007F,$F000,$007F,$F800,$00FF,$F800,$00FF     
L00019FAC   dc.w    $FC00,$01FF,$FC00,$01FF,$FE00,$01FF,$FE00,$03FF     
L00019FBC   dc.w    $FE00,$07FF,$FE00,$0FF0,$FC00,$0FE0,$FC00,$3FC0     
L00019FCC   dc.w    $FC00,$7F80,$FC00,$7F00,$FC00,$3E00,$FC00,$1E00     
L00019FDC   dc.w    $FC00,$0F00,$7F00,$0700,$7FC0,$0000,$7FC0,$0018     
L00019FEC   dc.w    $0000,$001F,$E000,$001F,$E000,$003F,$E000,$003F     
L00019FFC   dc.w    $B000,$007F,$F000,$007F,$B000,$00FF,$B000,$007E     
L0001A00C   dc.w    $B000,$001F,$6000,$01E7,$4800,$03B0,$0800,$03C0     
L0001A01C   dc.w    $7000,$0500,$7000,$0640,$7000,$0200,$7000,$0000     
L0001A02C   dc.w    $0000,$0800,$7000,$0000,$0000,$0000,$0400,$0000     
L0001A03C   dc.w    $1800,$0000,$0000,$0000,$0000,$0000,$0000,$0000     
L0001A04C   dc.w    $0000,$0000,$0000,$0000,$4000,$0000,$0000,$0000     
L0001A05C   dc.w    $4000,$0000,$4000,$0001,$4400,$0000,$8C00,$0000     
L0001A06C   dc.w    $A400,$0040,$0400,$0020,$0800,$00C0,$0800,$0080     
L0001A07C   dc.w    $0800,$1100,$0800,$0800,$0000,$1C00,$0800,$0200     
L0001A08C   dc.w    $0000,$0200,$2C00,$0000,$1980,$0000,$0000,$0000     
L0001A09C   dc.w    $0000,$0018,$0000,$001F,$C000,$001F,$C000,$001F     
L0001A0AC   dc.w    $E000,$0037,$E000,$003F,$E000,$006B,$E000,$004F     
L0001A0BC   dc.w    $C000,$000B,$A800,$0001,$E400,$0040,$0400,$0020     
L0001A0CC   dc.w    $0800,$00C0,$0800,$0000,$0800,$0100,$0800,$0000     
L0001A0DC   dc.w    $0000,$0000,$0800,$0200,$0000,$0000,$0000,$0000     
L0001A0EC   dc.w    $0100,$0000,$0000,$0000,$0000,$0018,$0000,$001F     
L0001A0FC   dc.w    $C000,$001F,$C000,$001F,$E000,$0037,$E000,$003F     
L0001A10C   dc.w    $E000,$006B,$E000,$004F,$C000,$000B,$A800,$0001     
L0001A11C   dc.w    $E400,$0040,$0400,$0020,$0800,$00C0,$0800,$0000     
L0001A12C   dc.w    $0800,$0100,$0800,$0000,$0000,$0000,$0800,$0200     
L0001A13C   dc.w    $0000,$0000,$0000,$0000,$0100,$0000,$0000,$3FF0     
L0001A14C   dc.w    $3FF0,$3FF0,$3FF0,$3FF8,$3FF8,$7FF8,$7FFC,$7FFE     
L0001A15C   dc.w    $7FFE,$7FFE,$3FFC,$0FF8,$0FF0,$0FE0,$3FC0,$7FC0     
L0001A16C   dc.w    $3FC0,$1FC0,$0FF0,$07FC,$07FC,$1800,$1FE0,$1FE0     
L0001A17C   dc.w    $1FA0,$1FF0,$1FB0,$3FB0,$3EB0,$3EF0,$3FF0,$3370     
L0001A18C   dc.w    $0008,$0720,$0720,$0700,$0700,$0000,$0700,$0000     
L0001A19C   dc.w    $0040,$0180,$0000,$0000,$0000,$0000,$0040,$0000     
L0001A1AC   dc.w    $0040,$0040,$0140,$0104,$0004,$0084,$0000,$0090     
L0001A1BC   dc.w    $0080,$0080,$0080,$1000,$0080,$0000,$02C0,$0198     
L0001A1CC   dc.w    $0000,$0000,$1800,$1FC0,$1FC0,$1FC0,$17E0,$1FE0     
L0001A1DC   dc.w    $0FE0,$0BC4,$1BC4,$01E4,$0000,$0090,$0080,$0080     
L0001A1EC   dc.w    $0080,$1000,$0080,$0000,$0000,$0010,$0000,$0000     
L0001A1FC   dc.w    $1800,$1FC0,$1FC0,$1FC0,$17E0,$1FE0,$0FE0,$0BC4     
L0001A20C   dc.w    $1BC4,$01E4,$0000,$0090,$0080,$0080,$0080,$1000     
L0001A21C   dc.w    $0080,$0000,$0000,$0010,$0000,$3FF0,$0000,$3FF0     
L0001A22C   dc.w    $0000,$3FF0,$0000,$3FF8,$0000,$7FF8,$0000,$7FFC     
L0001A23C   dc.w    $0000,$7FFE,$0000,$7FFF,$0000,$FFFF,$8000,$FFFF     
L0001A24C   dc.w    $8000,$FFFF,$8000,$FFFF,$8000,$FE3F,$8000,$FE1F     
L0001A25C   dc.w    $8000,$FC1F,$8000,$FC1F,$8000,$FC1F,$8000,$FC0F     
L0001A26C   dc.w    $0000,$FC1F,$C000,$7F1F,$F000,$7FDF,$F000,$1FC0     
L0001A27C   dc.w    $0000,$1800,$0000,$1FE0,$0000,$1FE0,$0000,$1FD0     
L0001A28C   dc.w    $0000,$3FF0,$0000,$3FD0,$0000,$3FD8,$0000,$3FF8     
L0001A29C   dc.w    $0000,$7F68,$0000,$7F6A,$0000,$67A2,$0000,$001E     
L0001A2AC   dc.w    $0000,$7C1E,$0000,$7C0E,$0000,$7000,$0000,$700E     
L0001A2BC   dc.w    $0000,$0000,$0000,$7000,$0000,$0001,$0000,$0406     
L0001A2CC   dc.w    $0000,$0800,$0000,$0000,$0000,$0000,$0000,$0000     
L0001A2DC   dc.w    $0000,$0000,$0000,$0020,$0000,$0000,$0000,$0020     
L0001A2EC   dc.w    $0000,$0020,$0000,$0002,$0000,$0093,$0000,$0091     
L0001A2FC   dc.w    $0000,$0041,$0000,$0001,$0000,$0001,$0000,$0001     
L0001A30C   dc.w    $0000,$0800,$0000,$0801,$0000,$0000,$0000,$0800     
L0001A31C   dc.w    $0000,$000B,$0000,$2C06,$6000,$1980,$0000,$0000     
L0001A32C   dc.w    $0000,$0000,$0000,$1800,$0000,$1FE0,$0000,$1FF0     
L0001A33C   dc.w    $0000,$1FF0,$0000,$0FF0,$0000,$1FF0,$0000,$1FF2     
L0001A34C   dc.w    $0000,$17F3,$0000,$37F9,$0000,$01E1,$0000,$0001     
L0001A35C   dc.w    $0000,$0001,$0000,$0001,$0000,$0800,$0000,$0801     
L0001A36C   dc.w    $0000,$0000,$0000,$0800,$0000,$0000,$0000,$0000     
L0001A37C   dc.w    $4000,$0100,$0000,$0000,$0000,$0000,$0000,$1800     
L0001A38C   dc.w    $0000,$1FE0,$0000,$1FF0,$0000,$1FF0,$0000,$0FF0     
L0001A39C   dc.w    $0000,$1FF0,$0000,$1FF2,$0000,$17F3,$0000,$37F9     
L0001A3AC   dc.w    $0000,$01E1,$0000,$0001,$0000,$0001,$0000,$0001     
L0001A3BC   dc.w    $0000,$0800,$0000,$0801,$0000,$0000,$0000,$0800     
L0001A3CC   dc.w    $0000,$0000,$0000,$0000,$4000,$0100,$0000,$0000     
L0001A3DC   dc.w    $0000,$03FF,$0000,$03FF,$0000,$07FF,$8000,$07FF     
L0001A3EC   dc.w    $8000,$0FFF,$C000,$0FFF,$C000,$1FFF,$E000,$1FFF     
L0001A3FC   dc.w    $F000,$3FFF,$F800,$3FFF,$F800,$1FFF,$F800,$0FFF     
L0001A40C   dc.w    $F800,$1FC1,$F800,$1F80,$FC00,$3F00,$FC00,$3F00     
L0001A41C   dc.w    $FE00,$3E00,$7F00,$3E00,$7F00,$7E00,$3F80,$7F00     
L0001A42C   dc.w    $3FE0,$1FC0,$3FE0,$0FC0,$0000,$0180,$0000,$01FE     
L0001A43C   dc.w    $0000,$03FE,$0000,$03FA,$0000,$07FE,$0000,$07FA     
L0001A44C   dc.w    $0000,$0FFB,$0000,$0EFF,$0000,$1FDD,$4000,$1FDD     
L0001A45C   dc.w    $4000,$07BC,$6000,$0000,$E000,$0F80,$E000,$0E00     
L0001A46C   dc.w    $7000,$1C00,$3000,$0400,$0000,$1000,$3000,$0000     
L0001A47C   dc.w    $0000,$0400,$0200,$0600,$0C00,$0000,$0000,$0000     
L0001A48C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0004     
L0001A49C   dc.w    $0000,$0000,$0000,$0004,$0000,$0004,$4000,$0100     
L0001A4AC   dc.w    $6000,$0022,$3000,$0022,$3000,$0000,$1000,$0000     
L0001A4BC   dc.w    $1000,$0000,$1000,$0100,$0800,$0200,$0800,$0200     
L0001A4CC   dc.w    $0000,$0800,$0E00,$0400,$0000,$2C00,$1600,$1E00     
L0001A4DC   dc.w    $0CC0,$0180,$0000,$0000,$0000,$0000,$0000,$0180     
L0001A4EC   dc.w    $0000,$01FC,$0000,$01FE,$0000,$03FE,$0000,$03FE     
L0001A4FC   dc.w    $0000,$07BE,$4000,$07FE,$4000,$0BBE,$2000,$033F     
L0001A50C   dc.w    $2000,$001C,$1000,$0000,$1000,$0000,$1000,$0100     
L0001A51C   dc.w    $0800,$0200,$0800,$0200,$0000,$0800,$0C00,$0400     
L0001A52C   dc.w    $0000,$0000,$0000,$0000,$0080,$0100,$0000,$0000     
L0001A53C   dc.w    $0000,$0000,$0000,$0180,$0000,$01FC,$0000,$01FE     
L0001A54C   dc.w    $0000,$03FE,$0000,$03FE,$0000,$07BE,$4000,$07FE     
L0001A55C   dc.w    $4000,$0BBE,$2000,$033F,$2000,$001C,$1000,$0000     
L0001A56C   dc.w    $1000,$0000,$1000,$0100,$0800,$0200,$0800,$0200     
L0001A57C   dc.w    $0000,$0800,$0C00,$0400,$0000,$0000,$0000,$0000     
L0001A58C   dc.w    $0080,$0100,$0000,$0000,$0000,$00FF,$C000,$00FF     
L0001A59C   dc.w    $C000,$00FF,$E000,$00FF,$E000,$01FF,$E000,$01FF     
L0001A5AC   dc.w    $F000,$01FF,$F000,$03FF,$F800,$03FF,$F800,$03FF     
L0001A5BC   dc.w    $FC00,$03FF,$FC00,$07FF,$FC00,$0FF1,$F800,$0FE1     
L0001A5CC   dc.w    $F800,$3FC1,$F800,$7F81,$F800,$7F01,$F800,$3E01     
L0001A5DC   dc.w    $F800,$1E01,$F800,$0F00,$FE00,$0700,$FF80,$0000     
L0001A5EC   dc.w    $FF80,$0060,$0000,$007F,$8000,$007F,$8000,$00FD     
L0001A5FC   dc.w    $8000,$00FF,$8000,$00FD,$8000,$00FD,$A000,$01FD     
L0001A60C   dc.w    $A000,$01FF,$A000,$007B,$B000,$010F,$3000,$0270     
L0001A61C   dc.w    $3000,$00E0,$E000,$01C0,$E000,$0400,$E000,$0300     
L0001A62C   dc.w    $E000,$0000,$0000,$0800,$E000,$0000,$0000,$0000     
L0001A63C   dc.w    $0800,$0000,$3000,$0000,$0000,$0000,$0000,$0000     
L0001A64C   dc.w    $0000,$0000,$0000,$0002,$0000,$0000,$0000,$0002     
L0001A65C   dc.w    $0000,$0002,$0000,$0002,$1000,$0000,$1000,$0004     
L0001A66C   dc.w    $0800,$0080,$8800,$0180,$0800,$0300,$1000,$0400     
L0001A67C   dc.w    $1000,$0200,$1000,$1000,$1000,$0800,$0000,$1C00     
L0001A68C   dc.w    $1000,$0200,$0000,$0200,$5800,$0000,$3300,$0000     
L0001A69C   dc.w    $0000,$0000,$0000,$0060,$0000,$007F,$0000,$007F     
L0001A6AC   dc.w    $0000,$007F,$0000,$00FF,$0000,$006F,$0000,$005F     
L0001A6BC   dc.w    $1000,$001E,$1000,$0016,$8800,$0083,$8800,$0080     
L0001A6CC   dc.w    $0800,$0300,$1000,$0400,$1000,$0200,$1000,$0000     
L0001A6DC   dc.w    $1000,$0000,$0000,$0000,$1000,$0200,$0000,$0000     
L0001A6EC   dc.w    $0000,$0000,$0200,$0000,$0000,$0000,$0000,$0060     
L0001A6FC   dc.w    $0000,$007F,$0000,$007F,$0000,$007F,$0000,$00FF     
L0001A70C   dc.w    $0000,$006F,$0000,$005F,$1000,$001E,$1000,$0016     
L0001A71C   dc.w    $8800,$0083,$8800,$0080,$0800,$0300,$1000,$0400     
L0001A72C   dc.w    $1000,$0200,$1000,$0000,$1000,$0000,$0000,$0000     
L0001A73C   dc.w    $1000,$0200,$0000,$0000,$0000,$0000,$0200,$0000     
L0001A74C   dc.w    $0000,$3FF0,$0000,$3FF8,$0000,$3FF8,$0000,$3FF8     
L0001A75C   dc.w    $0000,$3FFC,$0000,$3FFE,$0000,$7FFF,$0000,$7FFF     
L0001A76C   dc.w    $8000,$7FFF,$8000,$7FFF,$8000,$7FFF,$0000,$3FFE     
L0001A77C   dc.w    $0000,$07FC,$0000,$07F8,$0000,$07F0,$0000,$07E0     
L0001A78C   dc.w    $0000,$0FE0,$0000,$1FE0,$0000,$0FE0,$0000,$07F8     
L0001A79C   dc.w    $0000,$03FE,$0000,$03FE,$0000,$1800,$0000,$1FE0     
L0001A7AC   dc.w    $0000,$1FE0,$0000,$1F60,$0000,$1FE0,$0000,$1F60     
L0001A7BC   dc.w    $0000,$3F68,$0000,$3F6C,$0000,$3E6C,$0000,$3E69     
L0001A7CC   dc.w    $0000,$334C,$0000,$0008,$0000,$02F8,$0000,$01E0     
L0001A7DC   dc.w    $0000,$0260,$0000,$0180,$0000,$0000,$0000,$0140     
L0001A7EC   dc.w    $0000,$0300,$0000,$0020,$0000,$0000,$0000,$0000     
L0001A7FC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0080     
L0001A80C   dc.w    $0000,$0008,$0000,$008C,$0000,$0086,$0000,$0083     
L0001A81C   dc.w    $0000,$0183,$0000,$0186,$0000,$00A2,$0000,$0004     
L0001A82C   dc.w    $0000,$0000,$0000,$0010,$0000,$0000,$0000,$0040     
L0001A83C   dc.w    $0000,$0400,$0000,$0B00,$0000,$0700,$0000,$01A0     
L0001A84C   dc.w    $0000,$0018,$0000,$0000,$0000,$0000,$0000,$1800     
L0001A85C   dc.w    $0000,$1FC0,$0000,$1FC0,$0000,$1FC8,$0000,$1FCC     
L0001A86C   dc.w    $0000,$1BC6,$0000,$0FC3,$0000,$0B83,$0000,$13A6     
L0001A87C   dc.w    $0000,$01E2,$0000,$0004,$0000,$0000,$0000,$0010     
L0001A88C   dc.w    $0000,$0000,$0000,$0040,$0000,$0000,$0000,$0000     
L0001A89C   dc.w    $0000,$0000,$0000,$0100,$0000,$0010,$0000,$0000     
L0001A8AC   dc.w    $0000,$0000,$0000,$1800,$0000,$1FC0,$0000,$1FC0     
L0001A8BC   dc.w    $0000,$1FC8,$0000,$1FCC,$0000,$1BC6,$0000,$0FC3     
L0001A8CC   dc.w    $0000,$0B83,$0000,$13A6,$0000,$01E2,$0000,$0004     
L0001A8DC   dc.w    $0000,$0000,$0000,$0010,$0000,$0000,$0000,$0040     
L0001A8EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0100     
L0001A8FC   dc.w    $0000,$0010,$0000,$0000,$0000,$00FF,$0000,$00FF     
L0001A90C   dc.w    $0000,$00FF,$0000,$03FF,$C000,$01FF,$0000,$01FF     
L0001A91C   dc.w    $0000,$01FF,$0000,$03FF,$0000,$07FF,$0000,$1FFF     
L0001A92C   dc.w    $0000,$7FFF,$8000,$FFFF,$C000,$FFFF,$C000,$FFFF     
L0001A93C   dc.w    $C000,$7FFF,$C000,$1FFF,$E000,$03FF,$F000,$03FF     
L0001A94C   dc.w    $F000,$03FF,$E000,$03FF,$C000,$07FF,$8000,$07FF     
L0001A95C   dc.w    $8000,$0000,$0000,$007E,$0000,$0000,$0000,$0000     
L0001A96C   dc.w    $0000,$0124,$0000,$0174,$0000,$01BC,$0000,$021C     
L0001A97C   dc.w    $0000,$001A,$0000,$00E8,$0000,$15F1,$0000,$62E2     
L0001A98C   dc.w    $8000,$7040,$8000,$7D1A,$8000,$1D64,$8000,$004A     
L0001A99C   dc.w    $8000,$0186,$A000,$01FE,$4000,$01FE,$4000,$01FE     
L0001A9AC   dc.w    $0000,$03FE,$0000,$03FE,$0000,$0000,$0000,$0000     
L0001A9BC   dc.w    $0000,$007E,$0000,$0000,$0000,$00A0,$0000,$00FE     
L0001A9CC   dc.w    $0000,$00FE,$0000,$019D,$0000,$0049,$0000,$0700     
L0001A9DC   dc.w    $0000,$0A00,$0000,$1000,$0000,$0C0C,$0000,$0134     
L0001A9EC   dc.w    $0000,$007C,$0000,$0078,$0000,$0000,$2000,$0000     
L0001A9FC   dc.w    $6000,$0000,$4000,$0000,$0000,$0000,$0000,$0000     
L0001AA0C   dc.w    $0000,$0000,$0000,$0000,$0000,$0066,$0000,$0000     
L0001AA1C   dc.w    $0000,$008A,$0000,$00CA,$0000,$006E,$0000,$0113     
L0001AA2C   dc.w    $0000,$0018,$0000,$05C8,$0000,$1F60,$0000,$3062     
L0001AA3C   dc.w    $0000,$3448,$0000,$1C24,$0000,$011C,$0000,$0078 
L0001AA4C   dc.w    $0000,$0000,$0000,$0000,$6000,$0028,$4000,$00B0
L0001AA5C   dc.w    $0000,$01B8,$0000,$0138,$0000,$0000,$0000,$0000
L0001AA6C   dc.w    $0000,$0066,$0000,$0000,$0000,$00A0,$0000,$0034
L0001AA7C   dc.w    $0000,$0090,$0000,$008E,$0000,$0051,$0000,$05C8
L0001AA8C   dc.w    $0000,$1F60,$0000,$306E,$0000,$344E,$0000,$1C14
L0001AA9C   dc.w    $0000,$0060,$0000,$0000,$0000,$0000,$2000,$0000
L0001AAAC   dc.w    $0000,$0028,$0000,$00B0,$0000,$01B8,$0000,$0138
L0001AABC   dc.w    $0000,$07FF,$8000,$07FF,$8000,$0FFF,$8000,$0FFF
L0001AACC   dc.w    $C000,$1FFF,$C000,$1FFF,$E000,$3FFF,$E000,$3FFF
L0001AADC   dc.w    $E000,$3FFF,$E000,$1FFF,$E000,$1FC7,$E000,$3F87
L0001AAEC   dc.w    $E000,$3F87,$E000,$3F07,$E000,$3F07,$E000,$7E07
L0001AAFC   dc.w    $E000,$7E03,$C000,$7F07,$F000,$7FC7,$FC00,$7FC7
L0001AB0C   dc.w    $FC00,$03FE,$0000,$03F6,$0000,$07FE,$0000,$07F6
L0001AB1C   dc.w    $8000,$0FFE,$8000,$0EEE,$8000,$1FEE,$8000,$1FFE
L0001AB2C   dc.w    $8000,$1F2A,$C000,$0000,$8000,$0F83,$C000,$1F03
L0001AB3C   dc.w    $C000,$1D03,$C000,$1A00,$0000,$0003,$8000,$3800
L0001AB4C   dc.w    $0000,$0000,$0000,$0400,$4000,$1801,$8000,$0000
L0001AB5C   dc.w    $0000,$0000,$0000,$0008,$0000,$0000,$0000,$0008
L0001AB6C   dc.w    $0000,$0000,$0000,$0110,$4000,$0010,$4000,$0000
L0001AB7C   dc.w    $4000,$0014,$0000,$0000,$4000,$0000,$0000,$0000
L0001AB8C   dc.w    $0000,$0200,$0000,$0400,$0000,$0000,$4000,$0400
L0001AB9C   dc.w    $0000,$0000,$0000,$2C02,$C000,$1981,$9800,$0000
L0001ABAC   dc.w    $0000,$017C,$0000,$03FC,$0000,$03FC,$0000,$03FC
L0001ABBC   dc.w    $0000,$03BC,$0000,$07FC,$4000,$07B8,$4000,$073A
L0001ABCC   dc.w    $4000,$001E,$0000,$0000,$4000,$0000,$0000,$0000
L0001ABDC   dc.w    $0000,$0200,$0000,$0400,$0000,$0000,$4000,$0400
L0001ABEC   dc.w    $0000,$0000,$0000,$0000,$0000,$0100,$1000,$0000
L0001ABFC   dc.w    $0000,$017C,$0000,$03FC,$0000,$03FC,$0000,$03FC
L0001AC0C   dc.w    $0000,$03BC,$0000,$07FC,$4000,$07B8,$4000,$073A
L0001AC1C   dc.w    $4000,$001E,$0000,$0000,$4000,$0000,$0000,$0000
L0001AC2C   dc.w    $0000,$0200,$0000,$0400,$0000,$0000,$4000,$0400
L0001AC3C   dc.w    $0000,$0000,$0000,$0000,$0000,$0100,$1000,$0000
L0001AC4C   dc.w    $0000,$1000,$0000,$383F,$C000,$7C3F,$C000,$FC3F
L0001AC5C   dc.w    $C000,$FCFF,$F000,$7C7F,$E000,$3E7F,$C000,$3F7F
L0001AC6C   dc.w    $C000,$3FFF,$C000,$3FFF,$8000,$1FFF,$8000,$1FFF
L0001AC7C   dc.w    $C000,$0FFF,$E000,$07FF,$E000,$01FF,$E000,$01FF
L0001AC8C   dc.w    $E000,$01FF,$F000,$00FF,$F800,$00FF,$FE00,$00FF
L0001AC9C   dc.w    $FF00,$00FF,$FF00,$01FF,$FE00,$01FF,$EC00,$0000
L0001ACAC   dc.w    $0000,$0000,$0000,$301F,$8000,$5000,$0000,$1800
L0001ACBC   dc.w    $0000,$1064,$0000,$0046,$8000,$126B,$8000,$1903
L0001ACCC   dc.w    $8000,$1D82,$8000,$0EDB,$0000,$0FF5,$0000,$07F2
L0001ACDC   dc.w    $C000,$01F9,$C000,$007B,$4000,$007E,$4000,$0077
L0001ACEC   dc.w    $8000,$007D,$8000,$0079,$9000,$007B,$8A00,$007D
L0001ACFC   dc.w    $8000,$00FF,$8C00,$00FF,$8000,$0000,$0000,$0000
L0001AD0C   dc.w    $0000,$0000,$0000,$701F,$8000,$4800,$0000,$0014
L0001AD1C   dc.w    $0000,$0C3F,$8000,$0C2F,$8000,$0673,$8000,$0214
L0001AD2C   dc.w    $0000,$0120,$0000,$0008,$0000,$000C,$0000,$0006
L0001AD3C   dc.w    $0000,$0004,$0000,$0001,$0000,$0008,$0000,$0002
L0001AD4C   dc.w    $0000,$0006,$0000,$0004,$0A00,$0002,$0600,$0000
L0001AD5C   dc.w    $0C00,$0000,$0000,$0000,$0000,$0000,$0000,$3000
L0001AD6C   dc.w    $0000,$201D,$8000,$4000,$0000,$1001,$8000,$0C29
L0001AD7C   dc.w    $0000,$1A1D,$8000,$1F50,$0000,$0F16,$0000,$0F71
L0001AD8C   dc.w    $0000,$07F8,$0000,$00BE,$C000,$001B,$4000,$003F
L0001AD9C   dc.w    $0000,$001F,$0000,$000F,$0000,$0017,$0000,$0007
L0001ADAC   dc.w    $1000,$000E,$0000,$0027,$0600,$006E,$0C00,$004E
L0001ADBC   dc.w    $0000,$0000,$0000,$3000,$0000,$3800,$0000,$501D
L0001ADCC   dc.w    $8000,$0000,$0000,$0004,$0000,$0C06,$8000,$1A32
L0001ADDC   dc.w    $0000,$1F23,$8000,$0F02,$0000,$0F71,$0000,$07F8
L0001ADEC   dc.w    $0000,$00BE,$C000,$001B,$4000,$003F,$0000,$001F
L0001ADFC   dc.w    $0000,$000F,$0000,$0017,$0000,$0007,$1000,$000E
L0001AE0C   dc.w    $0A00,$0027,$0000,$006E,$0000,$004E,$0000,$03FF
L0001AE1C   dc.w    $03FF,$03FF,$0FFF,$07FF,$07FF,$07FE,$0FFC,$1FF8
L0001AE2C   dc.w    $1FF8,$1FFC,$1FFC,$1FFC,$1FFC,$3FFC,$3FFF,$3FFF
L0001AE3C   dc.w    $3FFF,$3FFE,$3FFC,$7FF8,$7FF8,$0000,$01F2,$0004
L0001AE4C   dc.w    $000B,$0617,$051E,$067C,$0838,$0930,$07E0,$0CE0
L0001AE5C   dc.w    $0CC8,$0F28,$0FE8,$1FE0,$1FD0,$1ECA,$1F64,$1FC4
L0001AE6C   dc.w    $1FE0,$3FE0,$3FE0,$0000,$0001,$01F2,$0004,$0188
L0001AE7C   dc.w    $0380,$0300,$06C0,$0CC0,$0000,$0300,$0300,$0000
L0001AE8C   dc.w    $0000,$0000,$0000,$0002,$0086,$0004,$0000,$0000
L0001AE9C   dc.w    $0000,$0000,$0002,$01E6,$0009,$011B,$0206,$007C
L0001AEAC   dc.w    $04B8,$04F0,$00E0,$03C0,$0B00,$0D08,$0F80,$0600
L0001AEBC   dc.w    $0D00,$0C40,$0686,$0F84,$0D00,$1B80,$1380,$0000
L0001AECC   dc.w    $0002,$01E6,$0009,$001B,$0106,$037C,$02B8,$08F0
L0001AEDC   dc.w    $00E0,$03C0,$0B00,$0D08,$0F80,$0600,$0D00,$0C42
L0001AEEC   dc.w    $0680,$0F80,$0D00,$1B80,$1380,$1800,$3C00,$7E00
L0001AEFC   dc.w    $FE00,$FC00,$F800,$F000,$C000,$8000,$8000,$0000
L0001AF0C   dc.w    $0800,$0400,$7000,$C800,$9000,$0000,$0000,$0000
L0001AF1C   dc.w    $0000,$0000,$0000,$1000,$7800,$F800,$F000,$0000
L0001AF2C   dc.w    $8000,$0000,$0000,$0000,$0800,$1000,$0800,$3800
L0001AF3C   dc.w    $7000,$0000,$8000,$0000,$0000,$0000,$1800,$1800
L0001AF4C   dc.w    $7800,$C000,$8000,$0000,$8000,$0000,$0000,$01FE
L0001AF5C   dc.w    $0000,$01FE,$0000,$01FE,$0000,$07FF,$8000,$03FF
L0001AF6C   dc.w    $0000,$03FF,$0000,$03FE,$0000,$07FE,$C000,$0FFF
L0001AF7C   dc.w    $C000,$0FFF,$C000,$0FFF,$C000,$1FFF,$C000,$1FFF
L0001AF8C   dc.w    $0000,$1FFE,$0000,$1FFE,$0000,$1FFC,$0000,$1FFC
L0001AF9C   dc.w    $0000,$3FF8,$0000,$3FF8,$0000,$3FF8,$0000,$7FF8
L0001AFAC   dc.w    $0000,$7FF8,$0000,$0000,$0000,$00FC,$0000,$0000
L0001AFBC   dc.w    $0000,$0000,$0000,$0310,$0000,$029A,$0000,$032C
L0001AFCC   dc.w    $0000,$040C,$0000,$0470,$0000,$0611,$8000,$04A1
L0001AFDC   dc.w    $C000,$0E0F,$0000,$0FFC,$0000,$0FE0,$0000,$0FF0
L0001AFEC   dc.w    $0000,$0FD0,$0000,$0F60,$0000,$1F60,$0000,$1EC0
L0001AFFC   dc.w    $0000,$1FE0,$0000,$3FE0,$0000,$3FE0,$0000,$0000
L0001B00C   dc.w    $0000,$0000,$0000,$00FC,$0000,$0000,$0000,$00D0
L0001B01C   dc.w    $0000,$01FE,$0000,$01BC,$0000,$03CC,$0000,$0600
L0001B02C   dc.w    $C000,$01AE,$4000,$035E,$0000,$01F0,$0000,$0000
L0001B03C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001B04C   dc.w    $0000,$0080,$0000,$0100,$0000,$0000,$0000,$0000
L0001B05C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$00F4
L0001B06C   dc.w    $0000,$0000,$0000,$0084,$0000,$0124,$0000,$0074
L0001B07C   dc.w    $0000,$0240,$0000,$0030,$8000,$0304,$C000,$02FF
L0001B08C   dc.w    $C000,$07FC,$0000,$07F0,$0000,$07C0,$0000,$0700
L0001B09C   dc.w    $0000,$0500,$0000,$0420,$0000,$0080,$0000,$0580
L0001B0AC   dc.w    $0000,$0D00,$0000,$1B80,$0000,$1380,$0000,$0000
L0001B0BC   dc.w    $0000,$0000,$0000,$00F4,$0000,$0000,$0000,$0010
L0001B0CC   dc.w    $0000,$009A,$0000,$01C8,$0000,$018C,$0000,$0630
L0001B0DC   dc.w    $8000,$0344,$C000,$02FF,$C000,$07FC,$0000,$07F0
L0001B0EC   dc.w    $0000,$07C0,$0000,$0700,$0000,$0500,$0000,$0420
L0001B0FC   dc.w    $0000,$0080,$0000,$0580,$0000,$0D00,$0000,$1B80
L0001B10C   dc.w    $0000,$1380,$0000,$0070,$01E0,$1FF0,$FFC0,$FFE0
L0001B11C   dc.w    $FC00,$F000,$8000,$0000,$0000,$0100,$1280,$3000
L0001B12C   dc.w    $E000,$8000,$0000,$0000,$0040,$0180,$1380,$C000
L0001B13C   dc.w    $0000,$0000,$0000,$0000,$0040,$0080,$0180,$9000
L0001B14C   dc.w    $E000,$0000,$0000,$0000,$0000,$0100,$0200,$8000
L0001B15C   dc.w    $E000,$0000,$0000,$1001,$0000,$0000,$0000,$0801
L0001B16C   dc.w    $0000,$0000,$0000,$5401,$0000,$6901,$0020,$3703
L0001B17C   dc.w    $0040,$1F83,$8080,$0F92,$C094,$77EA,$C1A8,$3BFB
L0001B18C   dc.w    $C5F0,$1001,$0000,$0000,$0000,$0801,$0000,$0000
L0001B19C   dc.w    $0000,$4401,$0000,$6001,$0020,$0202,$0040,$0182
L0001B1AC   dc.w    $8080,$0492,$4000,$21CA,$C080,$184A,$4440,$0000
L0001B1BC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001B1CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001B1DC   dc.w    $0010,$0000,$8000,$0000,$0040,$1001,$0000,$0000
L0001B1EC   dc.w    $0000,$0801,$0000,$0000,$0000,$4401,$0000,$6001
L0001B1FC   dc.w    $0020,$0202,$0040,$0182,$8080,$0492,$4000,$21CA
L0001B20C   dc.w    $4080,$184A,$4400,$0001,$0000,$0000,$0000,$0001
L0001B21C   dc.w    $0000,$0000,$0000,$5001,$0000,$6801,$0000,$0403
L0001B22C   dc.w    $0000,$0703,$8000,$0712,$C090,$332A,$41A0,$123B
L0001B23C   dc.w    $C1A0,$0008,$0000,$0000,$0008,$0000,$0000,$0000
L0001B24C   dc.w    $0000,$0000,$0008,$0000,$0000,$0000,$0000,$0000
L0001B25C   dc.w    $0008,$0800,$0000,$0008,$0800,$0000,$0008,$0000
L0001B26C   dc.w    $0000,$0018,$0800,$0000,$001C,$8800,$0000,$001C
L0001B27C   dc.w    $8800,$0000,$001C,$9000,$0000,$001C,$DC80,$0000
L0001B28C   dc.w    $001C,$DC80,$8000,$001C,$C481,$8000,$001D,$C583
L0001B29C   dc.w    $0000,$001D,$C587,$0000,$043D,$EB0E,$0000,$043F
L0001B2AC   dc.w    $EB0E,$0000,$073D,$EB9E,$0000,$07BF,$EBBC,$0000
L0001B2BC   dc.w    $03BF,$EBFC,$0000,$03FF,$EBF8,$0000,$07FF,$EBF8
L0001B2CC   dc.w    $0000,$03FF,$EFF8,$4000,$03FF,$FFF1,$8000,$0FFF
L0001B2DC   dc.w    $FFF7,$8000,$03FF,$FFFF,$0000,$1BFF,$FFFE,$5200
L0001B2EC   dc.w    $0DFF,$FFFF,$0C00,$23FF,$FFFE,$1000,$0B7F,$FFFC
L0001B2FC   dc.w    $4000,$E3FF,$FFFD,$FE00,$0008,$0000,$0000,$0008
L0001B30C   dc.w    $0000,$0000,$0000,$0000,$0000,$0008,$0000,$0000
L0001B31C   dc.w    $0000,$0000,$0000,$0008,$0800,$0000,$0008,$0800
L0001B32C   dc.w    $0000,$0008,$0000,$0000,$0008,$0800,$0000,$000C
L0001B33C   dc.w    $8800,$0000,$000C,$8000,$0000,$000C,$9000,$0000
L0001B34C   dc.w    $0004,$D400,$0000,$000C,$5480,$8000,$0004,$C481
L0001B35C   dc.w    $8000,$000D,$4583,$0000,$0005,$4505,$0000,$0415
L0001B36C   dc.w    $230A,$0000,$0415,$210A,$0000,$0315,$2294,$0000
L0001B37C   dc.w    $0315,$21B4,$0000,$0195,$61C8,$0000,$018D,$20A8
L0001B38C   dc.w    $0000,$07CD,$6110,$0000,$0245,$6D50,$4000,$0061
L0001B39C   dc.w    $1591,$8000,$0767,$65A7,$0000,$0261,$152A,$0000
L0001B3AC   dc.w    $1B67,$6574,$5000,$0D37,$6CCB,$0000,$23B0,$689C
L0001B3BC   dc.w    $0000,$0B12,$69E0,$0000,$219F,$E354,$0E00,$0000
L0001B3CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001B3DC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001B3EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001B3FC   dc.w    $0000,$0000,$0000,$0000,$0000,$0008,$0000,$0000
L0001B40C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001B41C   dc.w    $0000,$0000,$0080,$0000,$0000,$0000,$0000,$0000
L0001B42C   dc.w    $0080,$0000,$0008,$0000,$0000,$0000,$0000,$0000
L0001B43C   dc.w    $0008,$0000,$0000,$0000,$0010,$0000,$0000,$4000
L0001B44C   dc.w    $0000,$0008,$0020,$0000,$0008,$4000,$0000,$0000
L0001B45C   dc.w    $4040,$0000,$0000,$0180,$0000,$0000,$4180,$0000
L0001B46C   dc.w    $0000,$0100,$0000,$0000,$4100,$0000,$0000,$4000
L0001B47C   dc.w    $0000,$0000,$4000,$0000,$0000,$4000,$0000,$0000
L0001B48C   dc.w    $4020,$7000,$0008,$0000,$0000,$0008,$0000,$0000
L0001B49C   dc.w    $0000,$0000,$0000,$0008,$0000,$0000,$0000,$0000
L0001B4AC   dc.w    $0000,$0008,$0800,$0000,$0008,$0800,$0000,$0008
L0001B4BC   dc.w    $0000,$0000,$0008,$0800,$0000,$000C,$8800,$0000
L0001B4CC   dc.w    $0004,$8000,$0000,$000C,$9000,$0000,$0004,$D400
L0001B4DC   dc.w    $0000,$000C,$5480,$8000,$0004,$C401,$8000,$000D
L0001B4EC   dc.w    $4583,$0000,$0005,$4505,$0000,$0415,$230A,$0000
L0001B4FC   dc.w    $0415,$210A,$0000,$0315,$2294,$0000,$0315,$21A4
L0001B50C   dc.w    $0000,$0195,$21C8,$0000,$0185,$2088,$0000,$07C5
L0001B51C   dc.w    $2110,$0000,$0245,$2D10,$4000,$0061,$1411,$8000
L0001B52C   dc.w    $0767,$2427,$0000,$0261,$142A,$0000,$1B67,$2474
L0001B53C   dc.w    $5000,$0D37,$2CCB,$0000,$23B0,$289C,$0000,$0B12
L0001B54C   dc.w    $29E0,$0000,$219F,$A354,$1E00,$0008,$0000,$0000
L0001B55C   dc.w    $0008,$0000,$0000,$0000,$0000,$0000,$0008,$0000
L0001B56C   dc.w    $0000,$0000,$0000,$0000,$0008,$0800,$0000,$0008
L0001B57C   dc.w    $0800,$0000,$0008,$0000,$0000,$0008,$0800,$0000
L0001B58C   dc.w    $000C,$8800,$0000,$0004,$8800,$0000,$000C,$9000
L0001B59C   dc.w    $0000,$000C,$DC80,$0000,$000C,$DC80,$8000,$000C
L0001B5AC   dc.w    $C401,$8000,$000D,$C583,$0000,$000D,$C587,$0000
L0001B5BC   dc.w    $041D,$EB0E,$0000,$041D,$EB0E,$0000,$031D,$EB9C
L0001B5CC   dc.w    $0000,$031D,$EBAC,$0000,$009D,$ABF8,$0000,$0285
L0001B5DC   dc.w    $EBD8,$0000,$07C5,$ABF0,$0000,$03CD,$ABB0,$4000
L0001B5EC   dc.w    $03AD,$FA71,$8000,$07AB,$9A67,$0000,$03AD,$FACE
L0001B5FC   dc.w    $0000,$1BAB,$9ABC,$5000,$0DDB,$973B,$0000,$23EF
L0001B60C   dc.w    $977E,$0000,$017D,$967C,$0000,$E2F4,$9EFC,$1E00
L0001B61C   dc.w    $0000,$1000,$0000,$0000,$1000,$0000,$0000,$0000
L0001B62C   dc.w    $0000,$0000,$1000,$0000,$0000,$3000,$0000,$0000
L0001B63C   dc.w    $3001,$0000,$0000,$1001,$0000,$0000,$2000,$0000
L0001B64C   dc.w    $0000,$3001,$0000,$0308,$3001,$0000,$0182,$3801
L0001B65C   dc.w    $0000,$00C8,$3901,$0000,$0048,$2900,$0000,$0162
L0001B66C   dc.w    $2901,$8000,$0061,$3101,$8000,$0315,$3901,$8040
L0001B67C   dc.w    $0077,$3903,$9008,$0139,$BB03,$A4A0,$00CB,$BB83
L0001B68C   dc.w    $C020,$000A,$BAC7,$1A60,$107D,$FAC6,$9A40,$187F
L0001B69C   dc.w    $7BD6,$BCC0,$4C3F,$FAD7,$3548,$271F,$FFD7,$AF80
L0001B6AC   dc.w    $01BF,$FFDE,$B300,$60CF,$FEFE,$7690,$002F,$FEE6
L0001B6BC   dc.w    $F784,$007F,$FFFF,$EF0C,$0037,$FEFF,$FF5C,$000F
L0001B6CC   dc.w    $FEFF,$FEFC,$000F,$FFFF,$FEFC,$0007,$FFFF,$FFD8
L0001B6DC   dc.w    $00DF,$FFFF,$FFE0,$006F,$FFFF,$FFC0,$0017,$FFFF
L0001B6EC   dc.w    $FF00,$000B,$FFFF,$FF00,$0009,$FFFF,$E610,$0007
L0001B6FC   dc.w    $FFFF,$CA00,$0003,$FFFF,$FC80,$0001,$FFFF,$ED80
L0001B70C   dc.w    $0001,$FFFF,$FB00,$0007,$FFFF,$FE00,$0003,$FFFF
L0001B71C   dc.w    $FE00,$0001,$FFFF,$ED80,$0001,$FFFF,$FB00,$0007
L0001B72C   dc.w    $FFFF,$FE00,$0003,$FFFF,$FE00,$0007,$FFFF,$FE00
L0001B73C   dc.w    $0003,$FFFF,$FE00,$008B,$FFFF,$FF80,$03FF,$FFFF
L0001B74C   dc.w    $FFFC,$0000,$1000,$0000,$0000,$1000,$0000,$0000
L0001B75C   dc.w    $0000,$0000,$0000,$1000,$0000,$0000,$0000,$0000
L0001B76C   dc.w    $0000,$1001,$0000,$0000,$1001,$0000,$0000,$0000
L0001B77C   dc.w    $0000,$0000,$1001,$0000,$0200,$0001,$0000,$0100
L0001B78C   dc.w    $0800,$0000,$0080,$1901,$0000,$0008,$0900,$0000
L0001B79C   dc.w    $0040,$0901,$8000,$0060,$0101,$8000,$0300,$1901
L0001B7AC   dc.w    $8000,$0077,$0903,$8000,$0121,$0A03,$A020,$0088
L0001B7BC   dc.w    $1A83,$C020,$0002,$1A45,$1000,$1059,$0AC6,$9040
L0001B7CC   dc.w    $0049,$1A54,$A8C0,$4435,$8AD5,$2140,$071D,$BA13
L0001B7DC   dc.w    $A680,$01BA,$9A9A,$A300,$00CE,$C238,$4600,$000E
L0001B7EC   dc.w    $5222,$C684,$007E,$44AA,$0D0C,$0037,$2C3C,$1D18
L0001B7FC   dc.w    $000D,$AEA9,$2E24,$000D,$C0EA,$66F8,$0007,$226E
L0001B80C   dc.w    $7E40,$00CA,$8668,$7B80,$0067,$58F9,$2800,$0013
L0001B81C   dc.w    $3CE9,$2800,$0008,$D26B,$6600,$0008,$DA28,$4400
L0001B82C   dc.w    $0005,$6232,$0800,$0002,$FABD,$1880,$0001,$F85C
L0001B83C   dc.w    $2000,$0001,$68D5,$D200,$0003,$E851,$D800,$0003
L0001B84C   dc.w    $6613,$9000,$0001,$FC5C,$2000,$0001,$60D5,$D200
L0001B85C   dc.w    $0003,$EC51,$D800,$0003,$4613,$9000,$0003,$E451
L0001B86C   dc.w    $D800,$0003,$6613,$9000,$0001,$E421,$CA00,$02C5
L0001B87C   dc.w    $F292,$DB5C,$0000,$0000,$0000,$0000,$0000,$0000
L0001B88C   dc.w    $0000,$0000,$0000,$0000,$1000,$0000,$0000,$0000
L0001B89C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001B8AC   dc.w    $0000,$0000,$0000,$0001,$0000,$0000,$0000,$0000
L0001B8BC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001B8CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001B8DC   dc.w    $1000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001B8EC   dc.w    $0000,$0000,$0000,$0000,$1000,$0000,$0000,$0080
L0001B8FC   dc.w    $0000,$0000,$1002,$0000,$0000,$0080,$0000,$0000
L0001B90C   dc.w    $0080,$0000,$0000,$1082,$0000,$0000,$0880,$0000
L0001B91C   dc.w    $0000,$1802,$0000,$0010,$0082,$0000,$0000,$0000
L0001B92C   dc.w    $0000,$0000,$0280,$0000,$0000,$0082,$0080,$0000
L0001B93C   dc.w    $0202,$0000,$0000,$0200,$0100,$0000,$0082,$0000
L0001B94C   dc.w    $0000,$0080,$0000,$0000,$0202,$0000,$0000,$0281
L0001B95C   dc.w    $0000,$0000,$000A,$0000,$0000,$0080,$0080,$0000
L0001B96C   dc.w    $0000,$0000,$0000,$0280,$0000,$0000,$0000,$0000
L0001B97C   dc.w    $0000,$0200,$0000,$0000,$0000,$0000,$0000,$0280
L0001B98C   dc.w    $0000,$0000,$0000,$0000,$0000,$2200,$0000,$0000
L0001B99C   dc.w    $0000,$0000,$0000,$0200,$0000,$0000,$0000,$0000
L0001B9AC   dc.w    $0008,$0000,$0080,$0000,$1000,$0000,$0000,$1000
L0001B9BC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001B9CC   dc.w    $0000,$0000,$0000,$1001,$0000,$0000,$1001,$0000
L0001B9DC   dc.w    $0000,$0000,$0000,$0000,$1000,$0000,$0200,$0001
L0001B9EC   dc.w    $0000,$0100,$0800,$0000,$0080,$1901,$0000,$0008
L0001B9FC   dc.w    $0900,$0000,$0040,$0901,$8000,$0060,$0101,$8000
L0001BA0C   dc.w    $0300,$0901,$8000,$0077,$0903,$8000,$0121,$0A03
L0001BA1C   dc.w    $A020,$0088,$1A83,$C020,$0002,$0A45,$1000,$1059
L0001BA2C   dc.w    $0A46,$9040,$0049,$0A54,$A8C0,$4435,$8A55,$2140
L0001BA3C   dc.w    $071D,$BA13,$A680,$01BA,$8A18,$A300,$00CE,$C238
L0001BA4C   dc.w    $4600,$000E,$4220,$C684,$006E,$4428,$0D0C,$0037
L0001BA5C   dc.w    $2C3C,$1D18,$000D,$AC29,$2E24,$000D,$C068,$6678
L0001BA6C   dc.w    $0007,$206C,$7E40,$00CA,$8468,$7A80,$0067,$5879
L0001BA7C   dc.w    $2800,$0013,$3C69,$2800,$0008,$D069,$6600,$0008
L0001BA8C   dc.w    $D828,$4400,$0005,$6230,$0800,$0002,$FA3D,$1800
L0001BA9C   dc.w    $0001,$F85C,$2000,$0001,$6855,$D200,$0003,$E851
L0001BAAC   dc.w    $D800,$0003,$6413,$9000,$0001,$FC5C,$2000,$0001
L0001BABC   dc.w    $6055,$D200,$0003,$EC51,$D800,$0003,$4413,$9000
L0001BACC   dc.w    $0003,$E451,$D800,$0003,$6413,$9000,$0001,$E421
L0001BADC   dc.w    $CA00,$02C5,$F292,$DB5C,$0000,$1000,$0000,$0000
L0001BAEC   dc.w    $1000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001BAFC   dc.w    $0000,$1000,$0000,$0000,$1001,$0000,$0000,$1001
L0001BB0C   dc.w    $0000,$0000,$0000,$0000,$0000,$1000,$0000,$0308
L0001BB1C   dc.w    $1001,$0000,$0182,$1801,$0000,$00C8,$1901,$0000
L0001BB2C   dc.w    $0048,$0900,$0000,$0162,$0901,$8000,$0041,$1101
L0001BB3C   dc.w    $8000,$0315,$0901,$8040,$0044,$1903,$9008,$0138
L0001BB4C   dc.w    $9B03,$A4A0,$00C3,$9B83,$C020,$000A,$8AC7,$1A60
L0001BB5C   dc.w    $0074,$DA46,$9A40,$1857,$4BD4,$BCC0,$4C3F,$5A57
L0001BB6C   dc.w    $3548,$061B,$7BD5,$AF80,$019F,$EB5C,$B200,$60CD
L0001BB7C   dc.w    $B2FE,$7690,$002D,$A2E4,$F584,$006D,$BD6D,$EF0C
L0001BB8C   dc.w    $0034,$F4FE,$FB5C,$000E,$FC6F,$F6DC,$000C,$BB6D
L0001BB9C   dc.w    $DE78,$0004,$F9ED,$EDC0,$00CF,$7DAF,$DCC0,$0064
L0001BBAC   dc.w    $B73E,$DF00,$0012,$DB3F,$DE00,$0008,$7DBD,$9600
L0001BBBC   dc.w    $0008,$7DFE,$E400,$0005,$3DF5,$C800,$0002,$BD7E
L0001BBCC   dc.w    $B800,$0001,$BFBF,$8900,$0001,$773E,$F200,$0003
L0001BBDC   dc.w    $BFBE,$FC00,$0003,$B9FE,$FC00,$0001,$BFBF,$8900
L0001BBEC   dc.w    $0001,$7F3E,$F200,$0003,$BBBE,$FC00,$0003,$99FE
L0001BBFC   dc.w    $FC00,$0003,$BBBE,$FC00,$0003,$B9FE,$FC00,$0001
L0001BC0C   dc.w    $BBFE,$F600,$03DD,$FFFF,$FFDC,$0000,$0001,$0000
L0001BC1C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001BC2C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001BC3C   dc.w    $0000,$0000,$0001,$0000,$0000,$0000,$0000,$0000
L0001BC4C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$1021,$0000
L0001BC5C   dc.w    $0000,$0400,$0000,$0000,$0000,$0100,$1020,$0000
L0001BC6C   dc.w    $0000,$0000,$1020,$0000,$0000,$0040,$1201,$0000
L0001BC7C   dc.w    $0000,$0000,$0025,$0000,$0000,$0020,$0220,$0000
L0001BC8C   dc.w    $0000,$0008,$0024,$0000,$0000,$0000,$8221,$0000
L0001BC9C   dc.w    $0000,$0504,$0301,$0000,$0000,$0080,$C265,$0000
L0001BCAC   dc.w    $0000,$0032,$4265,$0080,$0000,$0038,$A371,$0100
L0001BCBC   dc.w    $0000,$05F4,$1A71,$0000,$0000,$007F,$9A57,$0200
L0001BCCC   dc.w    $0000,$01FF,$EAD3,$1480,$8000,$07FF,$FEF7,$9809
L0001BCDC   dc.w    $0000,$0FFF,$7EEF,$8AEE,$0000,$12FF,$FCFF,$9CFF
L0001BCEC   dc.w    $0000,$101F,$FDFF,$F3FC,$A400,$2047,$FFFF,$EFF4
L0001BCFC   dc.w    $1000,$037F,$FFFF,$F7F9,$2000,$21FF,$FF7F,$F7F0
L0001BD0C   dc.w    $8000,$AFFF,$FFFE,$FFE7,$D000,$1FFF,$FFF7,$BFDF
L0001BD1C   dc.w    $0000,$13FF,$FFF7,$7FBC,$0000,$07FF,$FFFF,$FFF8
L0001BD2C   dc.w    $0000,$03FF,$FFFF,$BEE4,$0000,$17FF,$FFFF,$7FF9
L0001BD3C   dc.w    $8000,$27FF,$FFF6,$FFCA,$0000,$4FFF,$FFFF,$FFF0
L0001BD4C   dc.w    $0000,$077F,$FFFF,$FFE0,$0000,$087D,$FFFF,$FFFF
L0001BD5C   dc.w    $0000,$62FD,$FFFF,$FF80,$0000,$0FFF,$FFFF,$FFFC
L0001BD6C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001BD7C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001BD8C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001BD9C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001BDAC   dc.w    $0000,$0000,$1000,$0000,$0000,$0000,$0000,$0000
L0001BDBC   dc.w    $0000,$0000,$1000,$0000,$0000,$0000,$1000,$0000
L0001BDCC   dc.w    $0000,$0000,$1000,$0000,$0000,$0000,$0001,$0000
L0001BDDC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001BDEC   dc.w    $0000,$0000,$0201,$0000,$0000,$0000,$0200,$0000
L0001BDFC   dc.w    $0000,$0000,$0241,$0000,$0000,$0000,$0040,$0000
L0001BE0C   dc.w    $0000,$0000,$0250,$0000,$0000,$05E0,$0A11,$0000
L0001BE1C   dc.w    $0000,$005A,$0811,$0000,$0000,$01FB,$0A13,$0080
L0001BE2C   dc.w    $0000,$061D,$8211,$8008,$0000,$0BCE,$0E09,$826A
L0001BE3C   dc.w    $0000,$10FF,$1829,$8CB0,$0000,$001F,$8C39,$D110
L0001BE4C   dc.w    $A000,$2047,$F421,$E060,$0000,$001F,$7469,$E1C0
L0001BE5C   dc.w    $0000,$0092,$F06D,$7300,$0000,$05DF,$6A6E,$7FC1
L0001BE6C   dc.w    $D000,$1F77,$DCF4,$1F83,$0000,$13CF,$E8E4,$2F28
L0001BE7C   dc.w    $0000,$0794,$DE60,$7A10,$0000,$0201,$7A20,$A420
L0001BE8C   dc.w    $0000,$14FE,$5E38,$7C00,$0000,$2751,$7FB0,$F000
L0001BE9C   dc.w    $0000,$4D0F,$8EF8,$6000,$0000,$001C,$2FAC,$6000
L0001BEAC   dc.w    $0000,$0031,$7D13,$F0D7,$0000,$006D,$9FA1,$C800
L0001BEBC   dc.w    $0000,$0BD4,$BD82,$DB5C,$0000,$0000,$0000,$0000
L0001BECC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001BEDC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001BEEC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001BEFC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001BF0C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001BF1C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001BF2C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001BF3C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001BF4C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0001,$0000
L0001BF5C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001BF6C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001BF7C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001BF8C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001BF9C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001BFAC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001BFBC   dc.w    $0000,$0000,$0200,$0000,$0000,$0000,$0082,$0000
L0001BFCC   dc.w    $0000,$0000,$0080,$0000,$0000,$0000,$0200,$0000
L0001BFDC   dc.w    $0000,$0000,$0280,$0020,$0000,$0000,$0000,$0000
L0001BFEC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
L0001BFFC   dc.w    $0000,$0000,$0000



            ; If Test Build - Include the Bottom Panel (Score, Energy, Lives, Timer etc)
            IFD TEST_BUILD_LEVEL
                incdir      "../panel/"
                include     "panel.s" 
                even
            ENDC


                    ;-------------------------------------------------------------------------------------------
                    ; My Debug Routines
                    ;-------------------------------------------------------------------------------------------
                    ; I added the following routines to allow 'signals' to be flashed on screen, and/or
                    ; the game to be paused as required.
                    ;
                    ; The routines are used to modify routines so that I can flash the screen, pause the
                    ; game when certain code is executed.
                    ;

_DEBUG_COLOUR_RED
            move.w  #$f00,$dff180
            rts

_DEBUG_COLOUR_GREEN
            move.w  #$0f0,$dff180
            rts

_DEBUG_COLOUR_BLUE
            move.w  #$00f,$dff180
            rts                    

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

