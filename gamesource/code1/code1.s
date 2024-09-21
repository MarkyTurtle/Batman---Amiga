

                ;
                ; Level 1 - Memory Map
                ; ------------------------------
                ; The following files are loaded and decrunched into the following locations
                ; by the game loader
                ;
                ;
                ; Filename/Area     Start   End         Additional Info
                ;---------------------------------------------------------------------------------------------
                ; BATMAN            $800                - Game Loader (always resident across loads)
                ; CODE1             $2FFC   $6FFE       - $3000 = entry point for level code. (16Kb)
                ; MAPGR             $7FFC
                ; BATSPR1           $10FFC
                ; CHEM              $47FE4
                ; STACK             $5a36c              - Address of program stack - not a file load.
                ;
                ; CHIP MEM BUFFER   $5a36c  ; - $5a36c - $6159c - (size = $7230 - 29,232 bytes)
                ;
                ; DISPLAY BUFFER (Double Buffered Display)  
                ;    display buffer 1 - $61b9c - $68dcc 
                ;                       - Bitplane 1 = $61b9c ($1c8c - 7308 bytes) (174 rasters @ 42 bytes)
                ;                       - Bitplane 2 = $63828 ($1c8c - 7308 bytes) (174 rasters @ 42 bytes)
                ;                       - Bitplane 3 = $654b4 ($1c8c - 7308 bytes) (174 rasters @ 42 bytes)
                ;                       - Bitplane 4 = $67140 ($1c8c - 7308 bytes) (174 rasters @ 42 bytes)
                ;    display buffer 2 - $68dce - $6fffe
                ;                       - Bitplane 1 = $68dce ($1c8c - 7308 bytes) (174 rasters @ 42 bytes)
                ;                       - Bitplane 2 = $6aa5a ($1c8c - 7308 bytes) (174 rasters @ 42 bytes)
                ;                       - Bitplane 3 = $6c6e6 ($1c8c - 7308 bytes) (174 rasters @ 42 bytes)
                ;                       - Bitplane 4 = $6e372 ($1c8c - 7308 bytes) (174 rasters @ 42 bytes)
                ;
                ;
                ; LOADBUFFER        $5a36C  $7C7FC      - File Load Area (files loaded here before depacked/relocated)
                ; PANEL             $7C7FC  $80000      - Game State/Lives manager (always resident across loads)
                ;
                ;
                ;



; Loader Constants
;------------------
LOADER_TITLE_SCREEN         EQU $00000820                           ; Load Title Screen 
LOADER_LEVEL_1              EQU $00000824                           ; Load Level 1
LOADER_LEVEL_2              EQU $00000828                           ; Load Level 2
LOADER_LEVEL_3              EQU $0000082c                           ; Load Level 3
LOADER_LEVEL_4              EQU $00000830                           ; Load Level 4
LOADER_LEVEL_5              EQU $00000834                           ; Load Level 5



; Music Player Constants
PLAYER_INIT                 EQU $00048000                           ; initialise music/sfx player
PLAYER_SILENCE              EQU $00048004                           ; Silence all audio
PLAYER_INIT_SFX_1           EQU $00048008                           ; Initialise SFX Audio Channnel
PLAYER_INIT_SFX_2           EQU $0004800c                           ; same as init_sfx_1 above
PLAYER_INIT_SONG            EQU $00048010                           ; initialise song to play - D0.l = song/sound 1 to 13
PLAYER_INIT_SFX             EQU $00048014                           ; initialise sfx to play - d0.l = sfx 5 to 13
PLAYER_UPDATE               EQU $00048018                           ; regular update (vblank to keep sounds/music playing)



; Panel Constants - original function addresses
PANEL_UPDATE                EQU $0007c800                           ; called on VBL to update panel display
PANEL_INIT_TIMER            EQU $0007c80e                           ; initialise level timer (D0.w = BCD encoded MIN:SEC)
PANEL_INIT_SCORE            EQU $0007c81c                           ; initialise player score
PANEL_ADD_SCORE             EQU $0007c82a                           ; add value to player score (D0.l = BCD encoded value)
PANEL_INIT_LIVES            EQU $0007c838                           ; initialise player lives
PANEL_ADD_LIFE              EQU $0007c846                           ; add 1 to player lives
PANEL_INIT_ENERGY           EQU $0007c854                           ; initialise player energy to full value
PANEL_LOSE_LIFE             EQU $0007c862                           ; sub 1 from player lives, check end game, set status bytes
PANEL_LOSE_ENERGY           EQU $0007c870                           ; reduce player energy (increase hit damage) D0.w = amount to lose
; Panel Constants - original data value addresses
PANEL_STATUS_1              EQU $0007c874                           ; Game Status Bits
PANEL_STATUS_2              EQU $0007c875                           ; Game Status Bits
PANEL_LIVES_COUNT           EQU $0007c876                           ; player lives left
PANEL_HISCORE               EQU $0007c878                           ; hi-score BCD value
PANEL_SCORE                 EQU $0007c87c                           ; player score BCD value
PANEL_FRAMETICK             EQU $0007c880                           ; counts down from 50 to 0 on each update
PANEL_TIMER_UPDATE_VALUE    EQU $0007c882                           ; Timer BCD update value
PANEL_TIMER_VALUE           EQU $0007c884                           ; Timer BCD value Min:Sec (word)
PANEL_TIMER_SECONDS         EQU $0007c885                           ; Timer BCD seconds value
PANEL_SCORE_UPDATE_VALUE    EQU $0007c886                           ; player score update value
PANEL_SCORE_DISPLAY_VALUE   EQU $0007c88a                           ; player score copy BCD value used for display
PANEL_ENERGY_VALUE          EQU $0007c88e                           ; player energy value (40 max value)
PANEL_HIT_DAMAGE            EQU $0007c890                           ; player hit damge (subtracted from player energy on each panel update)
; Panel Constants - resources
PANEL_GFX                   EQU $0007c89a                           ; main bottom display panel gfx
PANEL_BATMAN_GFX            EQU $0007e69a                           ; batman energy image
PANEL_JOKER_GFX             EQU $0007ebba                           ; joker energy image
PANEL_SCORE_GFX             EQU $0007f30a                           ; score digits gfx
PANEL_LIVES_ON_GFX          EQU $0007f374                           ; batman symbol - lives icon 'on'
PANEL_LIVES_OFF_GFX         EQU $0007f838                           ; batman symbol - lives icon 'off'
; Panel Status1 Bit Numbers
PANELST1_TIMER_EXPIRED      EQU $0
PANELST1_NO_LIVES_LEFT      EQU $1
PANELST1_LIFE_LOST          EQU $2
; Panel Status1 Bit Values
PANELST1_VAL_TIMER_EXPIRED  EQU $1
PANELST2_VAL_NO_LIVES_LEFT  EQU $2
PANELST2_VAL_LIFE_LOST      EQU $4
; Panel_Status2 Bit Numbers
PANELST2_MUSIC_SFX          EQU $0
PANELST2_GAME_OVER          EQU $5
PANELST2_GAME_COMPLETE      EQU $6
PANELST2_CHEAT_ACTIVE       EQU $7



; Code1 - Constants
;-------------------
STACK_ADDRESS               EQU $0005a36c
CHIPMEM_BUFFER              EQU $0005a36c   ; - $5a36c - $6159c - (size = $7230 - 29,232 bytes)
DISPLAY_BUFFER              EQU $00061b9c   ; - $61b9c - $6fffc - (size = $e460 - 58,464 bytes)






                section code1,code_c
                ;org     $0                                          ; original load address


                ;--------------------- includes and constants ---------------------------
                INCDIR      "include"
                INCLUDE     "hw.i"
                opt         o-


start
                    jmp game_start     
           


original_start:                                             ; original address $2FFC
                    dc.l    $00003000                       ; long word of start address



game_start                                                  ; original address $00003000
init_system
                    ; kill the system & initialise h/w
                    moveq   #$00,d0
                    move.w  #$1fff,$00dff09a                ; DMACON - Disable DMA (All DMA Channels)
                    move.w  #$1fff,$00dff096                ; INTENA - Disable Interrupts (apart from EXTER, INTEN) level 6 still active
                    move.w  #$0200,$00dff100                ; BPLCON0 - 0 bitplane display
                    move.l  d0,$00dff102                    ; BPLCON1 - Bitplane Scroll
                    move.w  #$4000,$00dff024                ; DSKLEN - Disable Disk DMA (as per h/w ref)
                    move.l  d0,$00dff040                    ; BLTCON0 - Clear minterms an DMA channels
                    move.w  #$0041,$00dff058                ; BLTSIZE - 1 word blit 
    
                    move.w  #$8340,$00dff096                ; DMACON - Enable Bitplane, Blitter, Master
                    move.w  #$7fff,$00dff09e                ; ADKCON - Clear Disk & Audio modulaton bits

                    ; clear all sprite postions
                    moveq   #$07,d7                         ; counter = 7 + 1
                    lea.l   $00dff140,a0                    ; SPR0POS - first sprite position
.sprite_loop
                    move.w  d0,(a0)                         ; clear sprite pos
                    addq.w #$08,a0                          ; next sprite pos address
                    dbf.w   d7,.sprite_loop                 ; L0000304e - loop for 8 sprites.

                    ; clear all audio volume
                    moveq   #$03,d7                         ; counter = 3 + 1
                    lea.l   $00dff0a8,a0                    ; AUD0VOL
.audio_loop
                    move.w  d0,(a0)                         ; clear volume level
                    lea.l   $0010(a0),a0                    ; next channel audio volume
                    dbf.w   d7,.audio_loop                  ; L0000305e - loop for 4 channels

                    ; all colour regs to black
                    lea.l   $00dff180,a0                    ; COLOR00
                    moveq   #$1f,d7                         ; counter 31 + 1
.color_loop
                    move.w  d0,(a0)+                        ; clear colour and move to next
                    dbf.w   d7,.color_loop                  ; L00003070 - loop for 32 colour registers

                    ; reset CIAA
                    move.b  #$7f,$00bfed01                  ; CIAA-ICR - clear interrupt enable bits
                    move.b  d0,$00bfee01                    ; CIAA-CRA - timer a control
                    move.b  d0,$00bfef01                    ; CIAA-CRB - timer b control
                    move.b  d0,$00bfe001                    ; CIAA-PRA - LED, OVL
                    move.b  #$03,$00bfe201                  ; CIAA-DDRA - LED, OVL output, remaining as inputs (disk/joybuttons)
                    move.b  d0,$00bfe101                    ; CIAA-PRB - Parallel port data
                    move.b  #$ff,$00bfe301                  ; CIAA-DDRB - Parallel port dir = output all bits

                    ; reset CIAB
                    move.b  #$7f,$00bfdd00                  ; CIAB-ICR - clear interrupt enable bits 
                    move.b  d0,$00bfde00                    ; CIAB-CRA - timer a control
                    move.b  d0,$00bfdf00                    ; CIAB-CRB - timer b control
                    move.b  #$c0,$00bfd000                  ; CIAB-PRA - PORT A (Keybboard serial data) (deselect DTR,RTS)
                    move.b  #$c0,$00bfd200                  ; CIAB-DDRA - PORT A dir = DTR,RTS pins/lines = output
                    move.b  #$ff,$00bfd100                  ; CIAB-PRB - PORT B (Disk ctrl) deselect all (active low)
                    move.b  #$ff,$00bfd300                  ; CIAB-DDRB - PORT B dir = all pins/lines = output


                    ; set stack address
                    lea.l   STACK_ADDRESS,a7                ; External Address - Stack = $0005a36c

                    ; set interrupt handlers (only level 1,2 & 3)
                    ; odd as additional handlers exist
                    moveq   #$02,d7                         ; count 2 + 1 
                    lea.l   interrupt_handlers_table,a0     ; L000031b0,a0
                    lea.l   $00000064,a1                    ; Level 1 Autovector Address
.int_loop
                    move.l  (a0)+,(a1)+                     ; Set autovectors for level 1,2 & 3
                    dbf.w   d7,.int_loop                    ; L000030ee


                    ; Initialise CIA Timers & 
                    move.w  #$ff00,$00dff034                ; POTGO
                    move.w  d0,$00dff036                    ; JOYTEST = $00 (reset counters)
                    or.b    #$ff,$00bfd100                  ; CIAB - PRB - deselect all drive bits
                    and.b   #$87,$00bfd100                  ; CIAB - PRB - latch motor off, deselect all drives
                    and.b   #$87,$00bfd100                  ; CIAB - PRB - latch motor off, deselect all drives
                    or.b    #$ff,$00bfd100                  ; CIAB - PRB - deselect all drive bits
                    move.b  #$f0,$00bfe601                  ; CIAA - TBLO - Timer B Low Byte
                    move.b  #$37,$00bfeb01                  ; CIAA - UNUSED - according to H/W Ref (BUG? )
                    move.b  #$11,$00bfef01                  ; CIAA - CRB - Force Load & Start Timer B

                    ; CIAA - Timer B Low = $f0      ; 0.33 second

                    move.b  #$91,$00bfd600                  ; CIAB - TBLO - Timer B Low Byte
                    move.b  d0,$00bfdb00                    ; CIAB - TBLO - Timer B Low Byte = $00
                    move.b  d0,$00bfdf00                    ; CIAB - CRB = $00

                    ; CIAB - Timer B Low = $00

                    move.w  #$7fff,$00dff09c                ; INTREQ - clear all interrupt request bits
                    tst.b   $00bfed01                       ; CIAA - ICR - Clear by reading (interrupt control)
                    move.b  #$8a,$00bfed01                  ; CIAA - ICR - Enable SP & Timer A & B Interrupts
                    tst.b   $00bfdd00                       ; CIAB - ICR - Clear by reading (interrupt control)
                    move.b  #$93,$00bfdd00                  ; CIAB - ICR - Enable FLG & Timer A & B Interrupts
                    move.w  #$e078,$00dff09a                ; INTENA - Enable - EXTER (disk sync), BLIT, VERTB, COPER, PORTS (keyboard & Timers)                
                                                            ;        - Level 2,3,6

                    ; start initialising the game           ; original address $0000317a
                    jsr     PANEL_INIT_LIVES                ; Panel - Initialise Player Lives - $0007c838
                    jsr     PANEL_INIT_SCORE                ; Panel - Initialise Player Score to 0 - $0007c81c
                    jsr     PANEL_INIT_ENERGY               ; Panel - Initialise Player Energy - $0007c854
                    move.w  #$0800,d0                       ; BCD Encoding of Level Timer MM:SS
                    jsr     PANEL_INIT_TIMER                ; Panel - Initalise the Level Timer - $0007c80e 
                    bsr.w   clear_display_memory            ; Clear display buffers - $00003746
                    lea.l   copper_list,a0                  ; L000031c8,a0
                    bsr.w   reset_display                   ; reset display (320x218) 4 bitplanes - L0000368a
                    bsr.w   double_buffer_playfield         ; L000036fa
                    bra.w   start_game                      ; L00003ae4


                    ; maybe intended as a second copper list
L000031ac           dc.w $ffff                      ; not referenced by this code
L000031ae           dc.w $fffe                      ; not referenced by this code


interrupt_handlers_table
L000031b0           dc.l level1_interrupt_handler   ; $000032c0 - disabled
L000031b4           dc.l level2_interrupt_handler   ; $000032f8 - enabled
L000031b8           dc.l level3_interrupt_handler   ; $0000331e - enabled
L000031bc           dc.l level4_interrupt_handler   ; $0000335a - disabled - unused by game init above
L000031c0           dc.l level5_interrupt_handler   ; $00003370 - disabled - unused by game init above
L000031c4           dc.l level6_interrupt_handler   ; $00003396 - enabled  - unused by game init above




                    ; -------------------- copper list -------------------
                    ; Playfield Display
                    ; ($67680) - Bitplane1 size = $2260 (8800) (336*209 @ 42 bytes per raster)
                    ; ($698e0) - Bitplane2 size = $2260 (8800) (336*209 @ 42 bytes per raster)  
                    ; ($6bb40) - Bitplane3 size = $2260 (8800) (336*209 @ 42 bytes per raster) 
                    ; ($6dda0) - Bitplane4 size = $2260 (8800) (336*209 @ 42 bytes per raster) 
                    ;
                    ; Panel Display
                    ; ($67680) - Bitplane size = $2260 (8800) (336*209 @ 42 bytes per raster)  
                    ; ($698e0) - Bitplane size = $2260 (8800) (336*209 @ 42 bytes per raster)  
                    ; ($6bb40) - Bitplane size = $2260 (8800) (336*209 @ 42 bytes per raster)   
                    ; ($6dda0) - Bitplane size = $2260 (8800) (336*209 @ 42 bytes per raster)
                    ; 
copper_list                                         ; original address $000031c8
                    ; playfield display
                    dc.w $2c01,$fffe                ; $da - $2c = $ae (174 + 32 = 206) - aaauming 32 pixels for vertical scroll off-screen
                    dc.w BPL2MOD,$0002              ; BPL2MOD (extra 16 bits bitplane width)
                    dc.w BPL1MOD,$0002              ; BPL1MOD (extra 16 bits bitplane width)
copper_playfield_planes                             ; original address $000031d4
                    dc.w BPL1PTL                    ; $00e2                     
                    dc.w $7680                      
                    dc.w BPL1PTH                    ; $00e0 ($67680) - These ptrs are nonsense (set by swap buffers)                 
                    dc.w $0006
                    dc.w BPL2PTL                    ; $00e6               
                    dc.w $98e0                      
                    dc.w BPL2PTH                    ; $00e4 ($698e0) - These ptrs are nonsense (set by swap buffers)                     
                    dc.w $0006
                    dc.w BPL3PTL                    ; $00ea               
                    dc.w $bb40                      
                    dc.w BPL3PTH                    ; $00e8 ($6bb40) - These ptrs are nonsense (set by swap buffers)                        
                    dc.w $0006
                    dc.w BPL4PTL                    ; $00ee               
                    dc.w $dda0                      
                    dc.w BPL4PTH                    ; $00ec ($6dda0) - These ptrs are nonsense (set by swap buffers)                  
                    dc.w $0006
                    dc.w COLOR01,$0446
                    dc.w COLOR02,$088a                      
                    dc.w COLOR03,$0cce                      
                    dc.w COLOR04,$0048             
                    dc.w COLOR05,$028c
                    dc.w COLOR06,$0c64
                    dc.w COLOR07,$0a22
                    dc.w COLOR08,$06a6
                    dc.w COLOR09,$0c4a
                    dc.w COLOR10,$0ec6
                    dc.w COLOR11,$0e88
                    dc.w COLOR12,$0600
                    dc.w COLOR13,$0262
                    dc.w COLOR14,$0668
                    dc.w COLOR15,$06ae
                    ; panel display
                    dc.w $da01,$fffe
                    dc.w BPL2MOD,$0000              ; Modulo = 0
                    dc.w BPL1MOD,$0000              ; Modulo = 0
                    dc.w BPL1PTL                    ; $00e2                     
                    dc.w $c89a                      ; Bitplane 1 - $7C89A = $780 (1920) bytes (48 Rasters @ 40 bytes per line (320 pixels))
                    dc.w BPL1PTH                    ; $00e0                      
                    dc.w $0007
                    dc.w BPL2PTL                    ; $00e6              
                    dc.w $d01a                      ; Bitplane 2 = $7D10A = $780 (1920) bytes (48 Rasters @ 40 bytes per line (320 pixels))
                    dc.w BPL2PTH                    ; $00e4                   
                    dc.w $0007
                    dc.w BPL3PTL                    ; $00ea             
                    dc.w $d79a                      ; Bitplane 3 = $7D79A = $780 (1920) bytes (48 Rasters @ 40 bytes per line (320 pixels))
                    dc.w BPL3PTH                    ; $00e8                  
                    dc.w $0007
                    dc.w BPL4PTL                    ; $00ee             
                    dc.w $df1a                      ; Bitplane 4 = $7DF1A = $780 (1920) bytes (48 Rasters @ 40 bytes per line (320 pixels))
                    dc.w BPL4PTH                    ; $00ec                     
                    dc.w $0007
copper_panel_colors                                 ; original address $0000325c
                    dc.w COLOR00,$0000
                    dc.w COLOR01,$0000
                    dc.w COLOR02,$0000
                    dc.w COLOR03,$0000
                    dc.w COLOR04,$0000
                    dc.w COLOR05,$0000
                    dc.w COLOR06,$0000
                    dc.w COLOR07,$0000
                    dc.w COLOR08,$0000
                    dc.w COLOR09,$0000
                    dc.w COLOR10,$0000
                    dc.w COLOR11,$0000
                    dc.w COLOR12,$0000
                    dc.w COLOR13,$0000
                    dc.w COLOR14,$0000
                    dc.w COLOR15,$0000
                    dc.w $ffff,$fffe


                    ;------------------- 16 colours for the Panel ---------------------
panel_colours                                       ; original address $000032a0
L000032a0           dc.w $0000,$0060,$0fff,$0008                      
                    dc.w $0a22,$0444,$0862,$0666               
                    dc.w $0888,$0aaa,$0a40,$0c60
                    dc.w $0e80,$0ea0,$0ec0,$0eee                      




                    ; -------------------- level 1 - interrupt handler --------------------
                    ; TBE, DSKBLK, SOFT - Interrupts, just clear the bits from INTREQ
                    ;  NB: not enabled by init_system above
                    ;
level1_interrupt_handler                            ; original addr: $000032c0
                    move.l  d0,-(a7)
                    move.w  $00dff01e,d0            ; INTREQR
                    btst.l  #$0002,d0               ; test SOFT 
                    bne.b   lvl1_clear_SOFT         ; .... yes - L000032ec
                    btst.l  #$0001,d0               ; test DSKBLK
                    bne.b   lvl1_clear_DSKBLK       ; .... yes - L000032e0
                    move.w  #$0001,$00dff09c        ; clear TBE (bit 0) - Transmit buffer empty
                    move.l  (a7)+,d0
                    rte

lvl1_clear_DSKBLK                                   ; original addr: $000032e0
                    move.w  #$0002,$00dff09c        ; Clear INTREQ - DSKBLK (bit 1)
                    move.l  (a7)+,d0
                    rte

lvl1_clear_SOFT                                     ; original addr: $000032ec
                    move.w  #$0004,$00dff09c        ; Clear INTREQ - SOFT (bit 2)
                    move.l  (a7)+,d0
                    rte




                    ; -------------------- level 2 - interrupt handler --------------------
                    ; CIA Ports & Timers
                    ; - Enabled by 'init_system' above
                    ;  
level2_interrupt_handler                            ; original address $000032f8
                    move.l  d0,-(a7)
                    move.b  $00bfed01,d0            ; CIAA - ICR - Clear by reading
                    bpl.b   lvl2_not_CIAA           ;   - No CIAA - Interrupt - $00003312
                    bsr.w   lvl2_CIAA_Interrupt     ;   - yes - $000033d4
                    move.w  #$0008,$00dff09c        ; Clear PORTS (bit 3)
                    move.l  (a7)+,d0
                    rte

lvl2_not_CIAA                                       ; original address $00003312
                    move.w #$0008,$00dff09c         ; Clear PORTS (bit 3)
                    move.l (a7)+,d0
                    rte




                    ; -------------------- level 3 - interrupt handler --------------------
                    ; COPER, VERTB, BLIT - interrupts
                    ; - Enabled by 'init_system' above
                    ;
level3_interrupt_handler                                    ; original addr: $0000331e
                    move.l  d0,-(a7) 
                    move.w  $00dff01e,d0                    ; d0 = INTREQR
                    btst.l  #$0004,d0                       ; Copper Interrupt?
                    bne.b   lvl3_coper                      ; .... yes - L0000334e
                    btst.l  #$0005,d0                       ; Vertical Blank
                    bne.b   lvl3_vertb                      ; .... yes - L0000333e
                    move.w  #$0040,$00dff09c                ; clear BLIT - INTREQ
                    move.l  (a7)+,d0
                    rte 



                    ; ------------------- Level 3 - VERTB - Handler --------------------
                    ; update music player.
                    ; level 3 vertical blank interrupt handler
lvl3_vertb                                                  ; original addr: $0000333e
                    bsr.w   lvl_3_update_sound_player       ; L00003526
                    move.w  #$0020,$00dff09c                ; clear VERTB - INTREQ
                    move.l  (a7)+,d0
                    rte 


                    ; ------------------- Level 3 - COPER - Handler -------------------
                    ; copper interrupt - do nothing
lvl3_coper                                                  ; original addr: $0000334e
                    move.w  #$0010,$00dff09c                ; clear COPER - INTREQ
                    move.l  (a7)+,d0
                    rte 





                    ; ------------------------ level 4 - interrupt handler ------------------------- 
                    ; not installed to autovector by the game init
                    ; unused handler
                    ; if used would clear raised audio interrupts.
level4_interrupt_handler                                    ; original address $0000335a
                    move.l  d0,-(a7)
                    move.w  $00dff01e,d0                    ; d0 = INTREQR
                    and.w   #$0780,d0                       ; Preserve Raised Audio Interrupts (level 4 for audio 0 - 3)
                    move.w  d0,$00dff09a                    ; clear raised audio interrupts
                    move.l  (a7)+,d0
                    rte





                    ; ----------------------- level 5 - interrupt handler -------------------------- 
                    ; not installed to autovector by the game init
                    ; unused handler
                    ; if usewd, then it would clear the disk sync interrupt & serial port interrupt
                    ;
level5_interrupt_handler                                    ; original address $00003370
                    move.l  d0,-(a7)
                    move.w  $00dff01e,d0                    ; d0 = INTREQR
                    btst.l  #$000c,d0                       ; Test DSKSYN bit?
                    bne.b   lvl5_clear_dsksyn               ; .... yes - L0000338a                   
                    move.w  #$0800,$00dff09c                ;  Clear RBF - Serial port buffer full (keyboard)
                    move.l  (a7)+,d0
                    rte 

lvl5_clear_dsksyn                                           ; original address $0000338a
                    move.w  #$1000,$00dff09c                ; Clear DSKSYN bit
                    move.l  (a7)+,d0
                    rte 





                    ; -------------------- level 6 - interrupt handler -------------------- 
                    ; not installed to autovector by the game init
                    ; NB: level 6 is enabled by 'init_system' but is not raised during 
                    ;     level 1 play.
                    ;
                    ; The Vector is still pointing to $2182 (the loader level6 handler)
                    ; a bug or intentional?
                    ;
                    ; unused handler
                    ;
level6_interrupt_handler                            ; original addres $00003396
                    move.l  d0,-(a7)
                    move.w  $00dff01e,d0            ; d0 = INTREQR
                    btst.l  #$000e,d0               ; INTEN - Master Interrupt - set only (bug?)
                    bne.b   lvl6_clear_INTEN
                    move.b  $00bfdd00,d0            ; CIAB - ICR - read also clears
                    bpl.b   lvl6_clear_EXTER        ; MSB = 0, no CIAB interrupt
                    bsr.w   lvl6_timerb_interrupt
                    move.w  #$2000,$00dff09c        ; INTREQ - Clear EXTER - Level 6 CIAB - Disk Index
                    move.l  (a7)+,d0
                    rte 

lvl6_clear_EXTER                                ; original address $000033bc
                    move.w  #$2000,$00dff09c    ; INTREQ - Clear EXTER - Level 6 CIAB - Disk Index
                    move.l  (a7)+,d0
                    rte  

lvl6_clear_INTEN                                ; original address $000033c8
                    move.w  #$4000,$00dff09c    ; INTREQ - Clear INTEN (never set on read) - never called
                    move.l  (a7)+,d0
                    rte




                    ; ------------------ level 2 - CIAA - Interrupt Handler ------------------
                    ; Handles:
                    ;   CIAA - Timer B
                    ;   Reading the keybaord (adding ascii codes to the keyboard queue)
                    ;
                    ; IN:
                    ;  - D0 - CIAA - ICR
                    ;
lvl2_CIAA_Interrupt                                         ; original addr: $000033d4
lvl2_chk_TB                                                 ; original addr: $000033d4
                    lsr.b   #$02,d0                         ; chk for Timer B
                    bcc.b   lvl2_chk_SP                     ;   no  - not Timer B - $000033dc
                    bsr.w   lvl2_CIAB_TimerB_Handler        ;   yes - is Timer B Interrupt - $00003544
lvl2_chk_SP                                                 ; original addr: $000033dc
                    lsr.b   #$02,d0                         ; chk for SP 
                    bcc.b   lvl2_exit_handler               ;   no  - not SP - $0000344e

lvl2_SP             ; keyboard interrupt                    ; original address L000033e0
                    movem.l d1-d2/a0,-(a7)                  ;   yes - is SP
                    move.b  $00bfec01,d1                    ; CIAA - SDR - Serial Data Register (Keyboard)
                    not.b   d1                              ; d1 = inverted keycode
                    lsr.b   #$01,d1                         ; rotate out key down/up bit (1 = key up)
                    bcc.b   .not_key_up                     ; Not Key up? - L00003406

.is_key_up          ; key released (d1 = keycode)           ; original address L000033f0
                    ; get ascii code and clear key pressed in bitmap table
                    lea.l   keyboard_bitmap,a0              ; L000034f4,a0
                    ext.w   d1                              ; extend keycode to 16 bits from byte
                    move.b  acsii_lookup_table(pc,d1.w),d1  ; d1 = translated keycode ($00003450 = lookup table)
                    move.w  d1,d2
                    lsr.w   #$03,d2                         ; divide ascii code by 8 (d2 = get bitmap byte offset)
                    bclr.b  d1,$00(a0,d2.W)                 ; clear key pressed bit in the bitmap table 
                    bra.b   .set_ciaa_cra                    ; L00003442

.not_key_up         ; key pressed (d1 = keycode)            ; original address $00003406
                    lea.l   keyboard_bitmap,a0              ; L000034f4,a0
                    ext.w   d1
                    move.b  acsii_lookup_table(pc,d1.w),d1  ; d1 = translated keycode ($00003450 = lookup table)        
                    move.w  d1,d2
                    lsr.w   #$03,d2                         ; divide ascii code by 8 (d2 = get bitmap byte offset)
                    bset.b  d1,$00(a0,d2.W)                 ; set key pressed bit in the bitmap table
                    tst.b   d1                              ; test for NUL ascii code
                    beq.b   .set_ciaa_cra                    ; L00003442 ; is NUL key

                    ; enqueue the pressed key
.enqueue_key                                                ; original address L0000341e
                    lea.l   keyboard_buffer,a0              ; L000034d0,a0 ; keyboard queue.
                    move.w  keyboard_queue_head,d2          ; L000034f0,d2                    ; 
                    move.b  d1,$00(a0,d2.W)                 ; store ascii code in the queue
                    addq.w  #$01,d2                         ; increment queue head
                    and.w   #$001f,d2                       ; clamp head to end of buffer
                    cmp.w   keyboard_queue_tail,d2          ; is the queue full? L000034f2,d2
                    beq.b   .set_ciaa_cra                   ; yes, do not increment the queue head
                    move.w  d2,keyboard_queue_head          ; no, increment the queue head L000034f0

.set_ciaa_cra                                           ; original address $00003442
                    move.b  #$40,$00bfee01              ; CIAA - CRA - SPMODE = CNT, Stop Timer A
                    movem.l (a7)+,d1-d2/a0
lvl2_exit_handler                                       ; original address L0000344e
                    rts 


                    ; raw key code translation table (raw keycode index into the table, ascii lookup)
                    ; keycode in range $00 - $7f
acsii_lookup_table                          ; original address $00003450
                                            ; Offset |  Value
                    dc.b    $27             ; $00       ' - single quote
                    dc.b    $31             ; $01       '1'
                    dc.b    $32             ; $02       '2'
                    dc.b    $33             ; $03       '3'
                    dc.b    $34             ; $04       '4'
                    dc.b    $35             ; $05       '5'
                    dc.b    $36             ; $06       '6'
                    dc.b    $37             ; $07       '7'      
                    dc.b    $38             ; $08       '8'
                    dc.b    $39             ; $09       '9'
                    dc.b    $30             ; $0a       '0'
                    dc.b    $2d             ; $0b       '-'
                    dc.b    $3d             ; $0c       '='
                    dc.b    $5c             ; $0d       '\'   
                    dc.b    $00             ; $0e       NUL
                    dc.b    $30             ; $0f       0
                    dc.b    $51             ; $10       'Q'
                    dc.b    $57             ; $11       'W'
                    dc.b    $45             ; $12       'E'
                    dc.b    $52             ; $13       'R'   
                    dc.b    $54             ; $14       'T'
                    dc.b    $59             ; $15       'Y'             
                    dc.b    $55             ; $16       'U'
                    dc.b    $49             ; $17       'I'             
                    dc.b    $4f             ; $18       'O'
                    dc.b    $50             ; $19       'P'
                    dc.b    $5b             ; $1a       '['      
                    dc.b    $5d             ; $1b       ']'               
                    dc.b    $00             ; $1c       NUL
                    dc.b    $31             ; $1d       '1'
                    dc.b    $32             ; $1e       '2'
                    dc.b    $33             ; $1f       '3'
                    dc.b    $41             ; $20       'A'
                    dc.b    $53             ; $21       'S'    
                    dc.b    $44             ; $22       'D'     
                    dc.b    $46             ; $23       'F'                
                    dc.b    $47             ; $24       'G'
                    dc.b    $48             ; $25       'H'                
                    dc.b    $4a             ; $26       'J'
                    dc.b    $4b             ; $27       'K'                
                    dc.b    $4c             ; $28       'L'
                    dc.b    $3b             ; $29       ';'                
                    dc.b    $23             ; $2a       '#'
                    dc.b    $00             ; $2b       NUL                
                    dc.b    $00             ; $2c       NUL
                    dc.b    $34             ; $2d       '4'
                    dc.b    $35             ; $2e       '5'
                    dc.b    $36             ; $2f       '6'
                    dc.b    $00             ; $30       NUL
                    dc.b    $5a             ; $31       'Z'    
                    dc.b    $58             ; $32       'X'
                    dc.b    $43             ; $33       'C'              
                    dc.b    $56             ; $34       'V'
                    dc.b    $42             ; $35       'B'              
                    dc.b    $4e             ; $36       'N'
                    dc.b    $4d             ; $37       'M'                
                    dc.b    $2c             ; $38       ','
                    dc.b    $2e             ; $39       '.'
                    dc.b    $2f             ; $3a       '/'
                    dc.b    $00             ; $3b       NUL        
                    dc.b    $00             ; $3c       NUL
                    dc.b    $37             ; $3d       '7'
                    dc.b    $38             ; $3e       '8'
                    dc.b    $39             ; $3f       '9'
                    dc.b    $20             ; $40       ' ' (space)
                    dc.b    $08             ; $41       BS  (back space)     
                    dc.b    $09             ; $42       TAB (horizontal tab)
                    dc.b    $0d             ; $43       CR  (carriage return)
                    dc.b    $0d             ; $44       CR  (carriage return)
                    dc.b    $1b             ; $45       ESC (escape)   
                    dc.b    $7f             ; $46       DEL
                    dc.b    $00             ; $47                       
                    dc.b    $00             ; $48
                    dc.b    $00             ; $49
                    dc.b    $2d             ; $4a       '-'
                    dc.b    $00             ; $4b
                    dc.b    $8c             ; $4c
                    dc.b    $8d             ; $4d
                    dc.b    $8e             ; $4e
                    dc.b    $8f             ; $4f             
                    dc.b    $81             ; $50       F1
                    dc.b    $82             ; $51       F2       
                    dc.b    $83             ; $52       F3
                    dc.b    $84             ; $53       F4       
                    dc.b    $85             ; $54       F5
                    dc.b    $86             ; $55       F6    
                    dc.b    $87             ; $56       F7
                    dc.b    $88             ; $57       F8         
                    dc.b    $89             ; $58       F9
                    dc.b    $8a             ; $59       F10           
                    dc.b    $28             ; $5a       '('
                    dc.b    $29             ; $5b       ')'
                    dc.b    $2f             ; $5c       '/'
                    dc.b    $2a             ; $5d       '*'
                    dc.b    $2b             ; $5e       '+'
                    dc.b    $8b             ; $5f
                    dc.b    $00             ; $60       NUL
                    dc.b    $00             ; $61       NUL             
                    dc.b    $00             ; $62       NUL
                    dc.b    $00             ; $63       NUL
                    dc.b    $00             ; $64       NUL
                    dc.b    $00             ; $65       NUL 
                    dc.b    $00             ; $66       NUL
                    dc.b    $00             ; $67       NUL
                    dc.b    $00             ; $68       NUL
                    dc.b    $00             ; $69       NUL
                    dc.b    $00             ; $6a       NUL
                    dc.b    $00             ; $6b       NUL
                    dc.b    $00             ; $6c       NUL
                    dc.b    $00             ; $6d       NUL
                    dc.b    $00             ; $6e       NUL
                    dc.b    $00             ; $6f       NUL
                    dc.b    $00             ; $70       NUL
                    dc.b    $00             ; $71       NUL 
                    dc.b    $00             ; $72       NUL
                    dc.b    $00             ; $73       NUL
                    dc.b    $00             ; $74       NUL
                    dc.b    $00             ; $75       NUL
                    dc.b    $00             ; $76       NUL
                    dc.b    $00             ; $77       NUL
                    dc.b    $00             ; $78       NUL
                    dc.b    $00             ; $79       NUL
                    dc.b    $00             ; $7a       NUL 
                    dc.b    $00             ; $7b       NUL
                    dc.b    $00             ; $7c       NUL
                    dc.b    $00             ; $7d       NUL 
                    dc.b    $00             ; $7e       NUL
                    dc.b    $00             ; $7f       NUL
                    ; End of Keycode - Ascii lookup table



                    ; --------------- keyboard buffer ------------------
                    ; 32 byte keyboard buffer queue.
                    ;
keyboard_buffer                         ; original address L000034d0
L000034d0           dc.b    $00
                    dc.b    $00                
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00
                    dc.b    $00

                    even
                    ; Keyboard buffer offset (where new keys are queued into)
keyboard_queue_head                     ; original address L000034f0
                    dc.w    $0000
                    ; Keyboard buffer offset (where keycodes are dequeued from)
keyboard_queue_tail                     ; original address L000034f0                 
                    dc.w    $0000


                    ; Table contained a bitmap of the keys currently pressed on the keyboard
                    ; each bit records the key press or release status of the key.
                    ; range = $00 - $7f (16 bytes of bitmap data)
keyboard_bitmap                         ; original address $000034f4
L000034f4           dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000

                    ; extended bitmap for control keys (Function keys etc)
                    ; ascii codes $80-$ff
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000



                    ;----------------------------------------------------------------------------
                    ; never called because a level 6 interrupt never genrated by level 1 code
                    ; IN:
                    ;   d0.b = CIAB - ICR
                    ;
lvl6_timerb_interrupt                           ; original address: $00003514
                    lsr.b   #$00000002,D0       ; test for TB interrupt
                    bcc.b   .exit               ; no Timer B Interrupt
                    move.b  #$00,$00bfee01      ; CIAA - CRA - Stop Timer A 
.exit               rts                     




                    ; unreferenced ptr?
L00003522           dc.l    lvl_3_sfx_exit      ; L00003542 ; unused ptr to 'rts' below




                    ; ---------------------- update music/sfx player ---------------------------
                    ; called from lvl3 vertb handler
                    ;   - increments the frame counter
                    ;   - play's current sfx/music
                    ;   - writes '$00' to CIAA CRA (this does nothing due to bit 7 being set/clr)
                    ;       - so it doesn't actuall clear any bits?
                    ;
lvl_3_update_sound_player                                    ; original address $00003526
                    movem.l d1-d7/a0-a6,-(a7)
                    addq.w  #$01,frame_counter              ; increment frame counter - $000036ee 
                    jsr     PLAYER_UPDATE                   ; External Address - CHEM.IFF (music player) - $00048018 
                    move.b  #$00,$00bfee01
                    movem.l (a7)+,d1-d7/a0-a6
lvl_3_sfx_exit                                              ; original address L00003542
                    rts






                    ; --------------------- Level 2 - CIAB Timer B Handler -------------------
                    ; CIAB - Timer B underflow handler (read joystick/mouse counters)
                    ;       - calls function ptr set at 'ciab_timerb_function_ptr'
                    ;       - default this is rts.
                    ;
lvl2_CIAB_TimerB_Handler                                    ; original address $00003544
L00003544           movem.l d0-d7/a0-a6,-(a7)
                    bsr.w   ciab_timerb_function
                    addq.w  #$01,ciab_timerb_ticker
                    movea.l ciab_timerb_function_ptr,a0
                    jsr     (a0)
                    movem.l (a7)+,d0-d7/a0-a6
                    rts



ciab_timerb_function_ptr                    ; original address $00003560
                    dc.l    lvl_3_sfx_exit  ; L00003542 ; CIAB - Timer B - Handler Routine - Default ptr to 'rts' @ $00003542
ciab_timerb_ticker                          ; original address $00003564
                    dc.w    $0000           ; CIAB - Timer B - Ticker Count




                    ; --------------------- level 2 - Timer B - read ports -----------------------
                    ; read buttons and pot counters for joystick ports 0 and 1
                    ;
ciab_timerb_function                                ; original address $00003566
                    ; joystick 1 counters
                    move.w  $00dff00a,d0            ; d0 = JOY0DAT
                    move.w  Joystick_0,d1           ; L00003630 ; d1 = last JOY0DAT
                    move.w  d0,Joystick_0           ; L00003630 ; store new JOY0DAT
                    bsr.w   calc_counter_deltas     ; L000035fa
                    move.b  d0,joy0_random          ; L00003637 ; d0 = random number $00 - $0f
                    add.w   d1,pot0_horizontal      ; L00003646 ; d1 = horizontal count delta
                    add.w   d2,pot0_vertical        ; L00003648 ; d2 = vertical count delta
                    btst.b  #$0006,$00bfe001        ; Test Button 0
                    seq.b   joy0_button0            ; L00003636 ; Set Button 0 flag
                    seq.b   joy0_button0b           ; L00003644 ; Set Button 0 flag
                    btst.b  #$0002,$00dff016        ; test Button 1
                    seq.b   joy0_button1b           ; L00003645 Set Button 1 flag

                    ; joystick 1 counters
                    move.w  $00dff00c,d0            ; d0 = JOY1DAT
                    move.w  Joystick_1,d1           ; L00003632 ; d1 = last JOY1DAT
                    move.w  d0,Joystick_1           ; L00003632 ; store new JOY1DAT
                    bsr.b   calc_counter_deltas     ; L000035fa
                    move.b  d0,joy1_random          ; L0000363b ; d0 = random number $00 - $0f
                    add.w   d1,pot1_horizontal      ; L0000364c ; d1 = horizontal count delta
                    add.w   d2,pot1_vertical       ; 0000364e  ; d2 = vertical count delts
                    btst.b  #$0007,$00bfe001        ; Test Button 0
                    seq.b   joy1_button0            ; L0000363a ; Set Button 0 flag
                    seq.b   joy1_button0b           ; L0000364a ; Set Button 0 flag
                    btst.b  #$0006,$00dff016        ; test Button 1
                    seq.b   L0000364b               ; Set Button 1 flag
                    rts 



                    ; --------------------- calculate mouse counter deltas --------------------
                    ; calculate delta differences for x,y pot counters.
                    ; also generate a pseudo random number $00 - $0f 
                    ;
                    ; IN:
                    ; d0.w = JOYxDAT - h/w register read value (current value)
                    ; d1.w = JOYxDAT - h/w register read value (previous value)
                    ; OUT:
                    ;   d0.b    = lookup table value (random number lookup?)
                    ;   d1.w    = Horizontal Counter Difference#
                    ;   d2.w    = Vertical Counter Difference
                    ; 
calc_counter_deltas                                     ; original address $000035fa
                    move.w  d0,d3                       ; d0,d3 = current value
                    move.w  d1,d2                       ; d1,d2 = previous value
                    sub.b   d3,d1                       ; subtract (horizontal) new value from old value
                    neg.b   d1                          ; negate the result
                    ext.w   d1                          ; sign extend to 16 bits
                    lsr.w   #$08,d2
                    lsr.w   #$08,d3
                    sub.b   d3,d2                       ; subtract (vertical) new value fro mold value
                    neg.b   d2                          ; negate the result
                    ext.w   d2                          ; sign extend to 16 bits

                    ; random number $00 - $0f
                    moveq   #$03,d3
                    and.w   d0,d3                       ; d3 = masked low 2 bits
                    lsr.w   #$06,d0
                    and.w   #$000c,d0                   ; d0 = 2 MSB bits, d3 = 2 LSB bits
                    or.w    d3,d0                       ; combine 2 MSB & 2 LB bits
                    move.b  random_lookup(pc,d0.W),d0   ; L00003620
                    rts 


                    ; ----------- 16 byte lookup table above ------------
                    ; used by above routine to return a value beteen
                    ; $00 - $0f depending on mouse counter values.
                    ; could be a randomnumber seed or similar.
                    ; 
random_lookup                                  ; original address L00003620
                    dc.b $00
                    dc.b $04
                    dc.b $05
                    dc.b $01               
                    dc.b $08
                    dc.b $0c                      
L00003626           dc.b $0d
                    dc.b $09
                    dc.b $0a
                    dc.b $0e               
                    dc.b $0f
                    dc.b $0b
                    dc.b $02
                    dc.b $06               
                    dc.b $07
                    dc.b $03                      

Joystick_0                                          ; original address $00003630
                    dc.w $0000                      ; H/W register value read from JOY0DAT

Joystick_1                                          ; original address $00003632
                    dc.w $0000                      ; H/W register value read from JOY1DAT    

L00003634           dc.w $0000                      ; unreferenced word

joy0_button0
                    dc.b $00
joy0_random
                    dc.b $00   

L00003638           dc.w $0000                                            ; unreferenced word

joy1_button0                                        ; original address L0000363a
L0000363a           dc.b $00
joy1_random
L0000363b           dc.b $00   

L0000363c           dc.w $0000                                            ; unreferenced word
L0000363e           dc.w $0000                                            ; unreferenced word               
L00003640           dc.w $0000                                            ; unreferenced word
L00003642           dc.w $0000                                            ; unreferenced word

joy0_button0b              
L00003644           dc.b $00
joy0_button1b
L00003645           dc.b $00
pot0_horizontal
L00003646           dc.w $0000    
pot0_vertical           
L00003648           dc.w $0000
joy1_button0b
L0000364a           dc.b $00
joy1_button1b
L0000364b           dc.b $00 
pot1_horizontal             
L0000364c           dc.w $0000
pot1_vertical
L0000364e           dc.w $0000              




                    ; -------------------- wait key --------------------
                    ; wait/loop until a key is pressed
                    ;
waitkey                                                 ; Address L00003650 not called directly from this code.
L00003650           move.l  d0,-(a7)
L00003652           bsr.b   getkey                      ; d0 = ascii code (z = 1 if no key) L0000365a
L00003654           bne.b   L00003652                   ; loop until a key is pressed
L00003656           move.l  (a7)+,d0
L00003658           rts



                    ; -------------------- get key --------------------
                    ; dequeue an ascii code from the keybaord queue
                    ;
                    ; OUT:
                    ;   d0.b    - Ascii code (0 if queue empty)
                    ;           - Z = 1 if queue is empty
                    ;
getkey                                                  ; original address L0000365a
                    movem.l d1-d2/a0,-(a7)
                    lea.l   keyboard_buffer,a0          ; L000034d0,a0 ; a0 = keyboard buffer
                    moveq   #$00,d0
                    movem.w keyboard_queue_head,d1-d2   ; L000034f0,d1-d2 ; d1 = queue head, d2 = queue tail
                    cmp.w   d1,d2                       ; check queue full/empty
                    beq.b   .exit                       ; if queue is full/empty - jmp $00003682  
.dequeue                                                ; original address L00003672
                    move.b  $00(a0,d2.W),d0             ; d0 = get ascii code
                    addq.w  #$01,d2                     ; increment keyboard tail
                    and.w   #$001f,d2                   ; clamp queue size 32 bytes
                    move.w  d2,keyboard_queue_tail      ; store updated queue tail
.exit                                                   ; original address L00003682
                    tst.b   d0
                    movem.l (a7)+,d1-d2/a0
                    rts 


                    ;--------------- reset display -------------------
                    ; Set the copper list and 4 bitplane display,
                    ; reset bitplane modulos.
                    ; reset display fetch and window size (320x218)
                    ;
                    ; IN:
                    ;   a0 = copper list address
                    ;
reset_display
L0000368a           move.w  #$0080,$00dff096                ; Disable Copper DMA
L00003692           move.l  a0,$00dff080                    ; Set Copper List COP1LC
L00003698           move.w  a0,$00dff088                    ; Strobe Copper (force start COPJMP1)
L0000369e           move.w  #$0000,$00dff10a                ; BPL2MOD - modulo
L000036a6           move.w  #$0000,$00dff108                ; BPL1MOD - modulp
L000036ae           move.w  #$0038,$00dff092                ; DDFSTRT - DMA Fetch Start
L000036b6           move.w  #$00d0,$00dff094                ; DDFSTOP - DMA Fetch Stop
L000036be           move.w  #$3080,$00dff08e                ; DIWSTRT - Display Window Start Vertical Start = $30, Horizontal Start = $80 (320x218 window)
L000036c6           move.w  #$0ac0,$00dff090                ; DIWSTOP - Display Window Stop Vertical Stop = $10a, Horizontal Stop = $1c0
L000036ce           move.w  #$4200,$00dff100                ; BPLCON0 - 4 bitplane, colour display 
L000036d6           clr.w   frame_counter                   ; L000036ee
L000036dc           tst.w   frame_counter                   ; L000036ee
L000036e2           beq.b   L000036dc                       ; wait for next vertb
L000036e4           move.w  #$8180,$00dff096            ; Enable - Copper DMA
L000036ec           rts 


frame_counter                                           ; original address $000036ee
                    dc.w    $0000                       ; incremeted every VERTB interrupt

target_frame_count                                      ; original address $000036f0
                    dc.w    $0000                       ; target frame count - (used to delay and wait for frame counter value)     

playfield_buffer_ptrs                                   ; original address $000036f2
playfield_buffer_1                                      ; original address $000036f2
                    dc.l    $00068dce                   ; double buffered playfield ptr 1
playfield_buffer_2                                      ; original address $000036f6
                    dc.l    $00061b9c                   ; double buffered playfield ptr 2            




                    ; ---------------- double buffer playfield --------------------
                    ; swap buffered playfield ptrs in copper list.
                    ;  - waits for VERTB (updated frame count - next frame)
                    ;  - checks if waited long enough (target_frame_count)
                    ;  - sets frame number of next frame to wait for
                    ;  - swaps buffer ptrs
                    ;  - sets copper list bitplane addresses
                    ;
double_buffer_playfield                                         ; original addr: $000036fa
.wait_again
                    move.w  frame_counter,d0                    ; L000036ee,d0
.vbwait                                                         ; original addr: $000036fe
                    cmp.w   frame_counter,d0                    ; L000036ee,d0
                    beq.b   .vbwait                             ; L000036fe
.chk_wait_again                                                 ; original addr: $00003704
                    move.w  target_frame_count,d1               ; L000036f0,d1
                    cmp.w   d0,d1
                    bpl.b   .wait_again                         ; jmp $000036fa

                    add.w   #$0001,d0                           ; d0 = next frame to wait for
                    move.w  d0,target_frame_count               ; store next frame counter to wait for

                    ; double buffer screen display
.swap_buffer_ptrs                                               ; original addr: $00003714
                    movem.l playfield_buffer_ptrs,d0-d1         ; d0 - d1 = double buffer bitplane ptrs?
                    exg.l   d0,d1                               ; swap buffer ptrs
                    movem.l d0-d1,playfield_buffer_ptrs         ; store swapped buffer ptrs

                    ; set bitplane ptrs
.update_copper_list
L00003722           lea.l   copper_playfield_planes+2,a0        ; L000031d6,a0
L00003726           move.l  #$00001c8c,d1                       ; d1 = #$1c8c (7308) (7308 / 42 = 174 rasters per plane)
L0000372c           moveq   #$03,d7                             ; d7 = 3 + 1 (4 bitplanes)
L0000372e           move.w  d0,(a0)                             ; set bitplane low word
L00003730           addq.w #$04,a0                              ; increment ptr to high word (in copper list)
L00003732           swap.w  d0                                  ; d0.w = high word
L00003734           move.w  d0,(a0)                             ; set bitplane high word
L00003736           addq.w #$04,a0                              ; increment ptr to low word of next bitplane (in copper list)
L00003738           swap.w  d0                                  ; correct address in d0.l
L0000373a           add.l   d1,d0                               ; add bitplane size ($1c8c = 7308 bytes)
L0000373c           dbf.w   d7,L0000372e                        ; loop for next bitplane
L00003740           addq.w  #$01,playfield_swap_count           ; L0000632c ; add 1 to buffer swap count (maybe used to test which buffer is back buffer?)
L00003744           rts



                    ; -------------- clear display memory ----------------
                    ; clear buffers located at:-
                    ;   - $61b9c - $6fffc - (size = $e460 - 58,464 bytes)
                    ;   - $5a36c - $6159c - (size = $7230 - 29,232 bytes)
                    ;
clear_display_memory
L00003746           lea.l   DISPLAY_BUFFER,a0         ; $00061b9c,a0  ; External Address (screen ram?)
L0000374c           move.w  #$3917,d7
L00003750           clr.l   (a0)+
L00003752           dbf.w   d7,L00003750
L00003756           lea.l   CHIPMEM_BUFFER,a0           ; $0005a36c,a0  ; External Address (screen ram?)
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
L000037ae           movea.l #PANEL_GFX,a1               ; Panel GFX Address - $0007c89a
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
L00003a8c           dc.w    $0000
L00003a8e           dc.w    $0000                       ; or.b #$00,d0
L00003a90           dc.w    $00a0, $0038, $0046         ; or.l #$00380046,-(a0) [4ef83000]
L00003a96           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a9a           dc.w    $0000, $0000                ; or.b #$00,d0
L00003a9e           dc.w    $0000, $0000                ; or.b #$00,d0
L00003aa2           dc.w    $0000
L00003aa4           dc.w    $5009                       ; or.b #$09,d0
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
L00003abc           dc.b    $ff
L00003abd           dc.b    $40                         ; illegal
L00003abe           dc.w    $0e4a                       ; illegal
L00003ac0           dc.w    $4143                       ; illegal
L00003ac2           dc.w    $4b20                       ; [ chk.l -(a0),d5 ]
L00003ac4           dc.w    $4953                       ; illegal
L00003ac6           dc.w    $2044                       ; movea.l d4,a0
L00003ac8           dc.w    $4541                       ; illegal
L00003aca           dc.w    $4400                       ; neg.b d0
L00003acc           dc.b    $ff
L00003acd           dc.b    $60                         ; illegal
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






                    ; ----------------------- start game ------------------------
                    ; Called after the system is initialised, initialise the
                    ; game level & play the game loop
                    ;
start_game                                          ; original address $00003ae4
L00003ae4           clr.l   frame_counter           ; Long Clear - clears target_frame_count also - L000036ee
L00003aea           bsr.w   double_buffer_playfield ; L000036fa
L00003aee           bsr.w   L000058e2
L00003af2           jsr     PLAYER_INIT             ;  $00048000 - Initialise Music Player ; External Address $48000- CHEM.IFF
L00003af8           clr.w   L000062fc
L00003afc           jsr     PANEL_INIT_LIVES        ; Panel - Initialise Player Lives - $0007c838
L00003b02           clr.w   L00006318
L00003b06           clr.l   frame_counter           ; Long Clear - clears target_frame_count also - L000036ee
L00003b0c           bsr.w   clear_display_memory    ; L00003746
L00003b10           move.w  #$0800,d0               ; Level Time as BCD mm:ss
L00003b14           jsr     PANEL_INIT_TIMER        ; Panel - Initialise Level Timer - $0007c80e
L00003b1a           jsr     PANEL_INIT_ENERGY       ; Panel - Initialise Player Energy - $0007c854

L00003b20           bsr.w   panel_fade_in           ; L00003d40

L00003b24           lea.l   $0000807c,a0            ; External Address $807c - MAPGR.IFF
L00003b2a           movea.l L00005f64,a5
L00003b30           movem.w (a5)+,d2-d4             ; d2, d3 d4 (6 bytes), d3 = word index to $807c
L00003b34           tst.w   d3
L00003b36           beq.b   L00003b4e               ; if d3 == 0 then exist loop
L00003b38           move.b  d2,$01(a0,d3.W)
L00003b3c           lsr.w   #$08,d2
L00003b3e           move.b  d2,$00(a0,d3.W)
L00003b42           move.b  d4,$03(a0,d3.W)
L00003b46           lsr.w   #$08,d4
L00003b48           move.b  d4,$02(a0,d3.W)
L00003b4c           bra.b   L00003b30

L00003b4e           move.l  #$00005fc4,L00005f64
L00003b58           lea.l   L00004894,a0
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
L00003bca           bsr.w   double_buffer_playfield                 ; L000036fa                               
L00003bce           bsr.w   L000058aa                               ; display 'Axis Chemicals'

L00003bd2           bsr.w   L00004b62                               

L00003bd6           bsr.w   L000055c4

L00003bda           moveq   #$32,d0
L00003bdc           bsr.w   L00005e8c

L00003be0           btst.b  #PANELST2_MUSIC_SFX,PANEL_STATUS_2       ; Panel - Status 2 Bytes - bit #$0000 of $0007c875 
L00003be8           bne.b   L00003bf2
L00003bea           moveq   #$01,d0                                 ; song number - 01 = level music
L00003bec           jsr     PLAYER_INIT_SONG                        ; chem.iff - music/sfx - initialise song (d0 = song number) $00048010 ; External Address $48010 - CHEM.IFF


L00003bf2           bsr.w   L00003cc0                               ; Wipe 'Axis Chemical' -> Show Playfield


L00003bf6           clr.l   frame_counter                           ; NB: Long Clear - clears next word also -L000036ee

                    ; ----------------- Game Loop -----------------
game_loop
L00003bfa           bsr.w   getkey                      ; d0 = ascii code (z = 1 if no key)- L0000365a
L00003bfe           beq.b   L00003c5a                   ; no key pressed, jmp $00003c5a
L00003c00           cmp.w   #$0081,d0
L00003c04           bne.b   L00003c22
L00003c06           bsr.w   getkey                      ; d0 = ascii code (z = 1 if no key) - L0000365a
L00003c0a           beq.b   L00003c06                   ; no key pressed, jmp $00003c06
L00003c0c           cmp.w   #$001b,d0
L00003c10           bne.b   L00003c22
L00003c12           bsr.w   L00003cbc
L00003c16           bset.b  #PANELST2_GAME_OVER,PANEL_STATUS_2      ; Panel - Status 2 Bytes - bit #$0005 of $0007c875 
L00003c1e           bra.w   L00004e00
L00003c22           cmp.w   #$0082,d0
L00003c26           bne.b   L00003c48
L00003c28           bchg.b  #PANELST2_MUSIC_SFX,PANEL_STATUS_2       ; Panel - Status 2 Bytes - bit #$0000 of $0007c875 
L00003c30           bne.b   L00003c3c
L00003c32           jsr     PLAYER_INIT_SFX_1                       ; chem.iff - Music/SFX player - Init SFX audio channel - $00048008  ; External Address $48008 - CHEM.IFF
L00003c38           bra.w   L00003c5a
L00003c3c           moveq   #$01,d0                                 ; song number - 01 = level music
L00003c3e           jsr     PLAYER_INIT_SONG                        ; chem.iff - music/sfx - init song - d0.l = song number - $00048010  ; External Address $48010- CHEM.IFF
L00003c44           bra.w   L00003c5a

L00003c48           cmp.w   #$008a,d0
L00003c4c           bne.b   L00003c5a
L00003c4e           btst.b  #PANELST2_CHEAT_ACTIVE,PANEL_STATUS_2   ; Panel - Status 2 Bytes - bit #$0007 of $0007c875 
L00003c56           bne.w   L00005e3a
L00003c5a           btst.b  #PANELST1_TIMER_EXPIRED,PANEL_STATUS_1  ; Panel - Status Byte 1 - bit #$0000 of $0007c874 
L00003c62           bne.b   L00003c80
L00003c64           jsr     PANEL_UPDATE                            ; Panel Update - $0007c800
L00003c6a           jsr     PANEL_UPDATE                            ; Panel Update - $0007c800
L00003c70           btst.b  #PANELST1_TIMER_EXPIRED,PANEL_STATUS_1  ; Panel - Status Byte 1 - bit #$0000 of $0007c874 
L00003c78           beq.b   L00003c80
L00003c7a           moveq   #$01,d6
L00003c7c           bsr.w   L00004ce4
L00003c80           clr.l   d0
L00003c82           clr.l   d1
L00003c84           bsr.w   L00005854
L00003c88           movem.w L000067c2,d0-d1

;L00003c8e           jsr     L00004c3e                   ; 4eb9 0000 4c3e (self modifying code $3c92)
L00003c8e           dc.w    $4eb9       ; jsr
L00003c90           dc.w    $0000       ; high word of jsr address
L00003c92           dc.w    $4c3e       ; low word of jsr address

L00003c94           bsr.w   L00004936
L00003c98           bsr.w   L00003dd4
L00003c9c           bsr.w   L00003dfe
L00003ca0           bsr.w   L00004b62
L00003ca4           bsr.w   L000055c4
L00003ca8           bsr.w   L00003ee6
L00003cac           bsr.w   L00004658
L00003cb0           bsr.w   L000045fe
L00003cb4           bsr.w   double_buffer_playfield         ; L000036fa
L00003cb8           bra.w   L00003bfa                       ; jump back to main loop
                    ; ----------------- End of Game Loop -----------------



L00003cbc           bsr.w   L00004e28
L00003cc0           move.w  #$002a,d0
L00003cc4           move.w  #$00ae,d1
L00003cc8           movem.l playfield_buffer_ptrs,a0-a1     ; L000036f2,a0-a1
L00003cce           clr.w   d2
L00003cd0           moveq   #$7f,d3
L00003cd2           and.w   d2,d3
L00003cd4           moveq   #$0f,d5
L00003cd6           lsr.w   #$01,d3
L00003cd8           bcc.b   L00003cdc
L00003cda           MOVE.L  #$fffffff0,D5                    
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



                    ;---------------------- panel fade in -----------------------
                    ; fades the panel colours from blank to expected colours.
                    ; waits 4 frames between each fade loop.
                    ; loops 16 times, 64 frames fade in. approx 1 seconds.
                    ;
panel_fade_in                                               ; original address $00003d40
                    moveq   #$0f,d7                         ; d7 = 15+1 - outer loop
.fade_loop                                                  ; original address $00003d42
                    lea.l   copper_panel_colors+2,a0 
                    lea.l   panel_colours,a1                ; $000032a0   
                    moveq   #$0f,d6
.next_colour                                                ; original address $00003d4c
                    move.w  (a0),d0                         ; d0 = current display colour
                    move.w  (a1)+,d1                        ; d1 = panel colour
                    eor.w   d0,d1                           ; XOR will result in 000 copper value = expected value
.fade_blue                                                  ; original address $00003d52
                    moveq   #$0f,d2                         ; blue bits mask
                    and.w   d1,d2                           ; d2 = blue bits
                    beq.b   .fade_green                     ; L00003d5a ; if blue bits == 0 then equals target colour
                    addq.w  #$01,d0                         ; else increment blue colour
.fade_green                                                 ; original address $00003d5a
                    move.l  #$fffffff0,D2                   ; d2 = green bits mask
                    and.b   d1,d2                           ; mask out blue bits, leaving green bits
                    beq.b   .fade_red                       ; L00003d64 ; if green bits == 0 then equals target colour
                    add.w   #$0010,d0                       ; else increment green bits
.fade_red                                                   ; original address $00003d64
                    and.w   #$0f00,d1                       ; mask out green & blue bits
                    beq.b   .end_fade                       ; L00003d6e ; if red bits == 0 then equals target colour
                    add.w   #$0100,d0                       ; else increment red bits
.end_fade                                                   ; original address $00003d6e
                    move.w  d0,(a0)                         ; store new colour in copper list
                    addq.w  #$04,a0                         ; next copper colour address ptr
                    dbf.w   d6,.next_colour                 ; L00003d4c ; fade next colour

                    ; wait for 4 frame counts
.wait_4_frames                                              ; original address $00003d76
                    move.w  frame_counter,d0                ; L000036ee,d0
                    addq.w  #$04,d0
.wait_frame_count                                           ; original address $00003d7e
                    cmp.w   frame_counter,d0                ; L000036ee,d0
                    bne.b   .wait_frame_count               ; L00003d7e
                    dbf.w   d7,.fade_loop                   ; L00003d42
                    rts





L00003d8c           moveq   #$0f,d7
L00003d8e           lea.l   copper_panel_colors+2,a0    ; L0000325e,a0
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

                    ; wait for 4 frame counts
L00003dbe           move.w  frame_counter,d0        ; L000036ee,d0
L00003dc4           addq.w  #$04,d0
L00003dc6           cmp.w   frame_counter,d0        ; L000036ee,d0
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
L00003df6           jmp     PANEL_ADD_SCORE         ; Panel Add Player Score (D0.l BCD value to add)- $0007c82a
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
L00003f80           moveq   #$0a,d0                 ; sfx number - $0a = Bad Guy Hit
L00003f82           jsr     PLAYER_INIT_SFX         ; chem.iff - music/sfx - init sfx to play - d0 = sfx number - $00048014 ; External Address $48014 - CHEM.IFF
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
L00003fee           MOVE.L  #$ffffffe8,D3
L00003ff0           move.w  d3,$0006(a0)
L00003ff4           cmp.w   #$0073,d1
L00003ff8           bpl.b   L0000400a
L00003ffa           movem.w d0-d1,-(a7)
L00003ffe           moveq   #$09,d0                 ; sfx number = 09 = Grenade Throw
L00004000           jsr     PLAYER_INIT_SFX         ; chem.iff - music/sfx - init sfx to play - d0.l = sound number - $00048014 ; External Address $48014 - CHEM.IFF
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
L00004172           move.w  $00008002,d2        ; External Address - MAPGR.IFF
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
L0000421a           move.l  #$00050010,$000a(a6)        ; External Address? - CHEM.IFF
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
L00004384           btst.b  #$0000,L0000632d                    ; test even/odd playfield buffer swap value
L0000438a           bne.b   L000043ce
L0000438c           addq.w  #$01,d4
L0000438e           move.w  d4,$0004(a6)
L00004392           addq.w  #$01,d1
L00004394           and.w   #$0007,d4
L00004398           bne.b   L000043ce
L0000439a           bsr.w   L000055a0
L0000439e           bra.b   L000043c6
L000043a0           move.w  $0004(a6),d4
L000043a4           btst.b  #$0000,L0000632d                    ; test even/odd playfield buffer swap value
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
L00004448           btst.b  #$0000,L0000632d                    ; test even/odd playfield buffer swap value
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


                    ; play sfx - d0 = sfx number to play 5 - 13
L000044b6           cmp.w   #$00a0,d0
L000044ba           bcc.b   L000044b4
L000044bc           cmp.w   #$0059,d1
L000044c0           bcc.b   L000044b4
L000044c2           movem.w d0-d1,-(a7)
L000044c6           move.w  d2,d0                       ; d0 = sfx number to play
L000044c8           jsr     PLAYER_INIT_SFX             ; chem.iff - music/sfx - init sfx to play - d0 = sfx number $00048014 ; External Address - CHEM.IFF
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
L00004508           dc.w    $0011
L0000450a           dc.w    $0015                ; or.b #$15,(a1) [04]
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
L00004578           lea.l   L00004578(pc,d2.W),a5        ; $00004510     (warning 2069: encoding absolute displacement directly)
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
L0000459e           move.b  -$2(a0,d3.W),d5     ; $00000d11
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
L000045f8           jmp     PANEL_ADD_SCORE         ; ; Panel Add Player Score (D0.l BCD value to add)- $0007c82a


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
L00004678           movea.w -$2(a5,d6.W),a0         ; $fe(a5,d6.W),a0
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
L000046b2           moveq   #$0a,d0                 ; sfx number - $0a = Bad guy hit
L000046b4           jsr     PLAYER_INIT_SFX         ; chem.iff - music/sfx - init sfx to play - d0 = sfx number - $00048014           ; External Address - CHEM.IFF
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
L000047bc           moveq   #$0a,d0                     ; sfx number - $0a = bad guy hit
L000047be           jmp     PLAYER_INIT_SFX             ; chem.iff - music/sfx - init sfx to play - d0 = sfx number $00048014 ; External Address -CHEM.IFF
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
L00004848           btst.b  #$0000,L0000632d                ; test even/odd playfield buffer swap value
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
L00004964           MOVE.L  #$fffffffe,D0
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
L0000497e           MOVE.L  #$fffffffd,D0
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
L00004a72           lea.l   $00008002,a0            ; External Address - MAPGR.IFF
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

;L00004a9e           lea.l   $00(a2,d0.W),a3         ; $0006b778,a3 - Self Modified Code
L00004a9e           dc.w    $47f2
L00004aa0           dc.b    $00
L00004aa1           dc.b    $00

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


L00004ad6           movea.l L0000630a,a2         ; [0000a07c]
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
L00004af4           lea.l   $00008002,a0        ; External Address - MAPGR.IFF
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
L00004b6a           movea.l playfield_buffer_2,a6           ; L000036f6,a6            ; playfield buffer 2
L00004b6e           subq.w #$02,a6                          ; subaq.w
L00004b70           movea.l L0000631e,a5                    ; [0005a36c] CHIPMEM_BUFFER
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
L00004c46           movea.l L00004c4c(pc,d2.W),a0        ; $04=$00004c4c
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



L00004ccc           tst.b   PANEL_STATUS_1              ; Panel - Status Byte 1 - $0007c874
L00004cd2           bne.b   L00004d36

L00004cd4           movem.l d0-d7/a5-a6,-(a7)
L00004cd8           move.w  d6,d0
L00004cda           jsr     PANEL_LOSE_ENERGY           ; Panel - Lose Energy (D0.w) - $0007c870
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
L00004d7a           tst.b   PANEL_STATUS_1      ; Panel - Status Byte 1 - $0007c874
L00004d80           beq.b   L00004d36
L00004d82           jsr     PLAYER_SILENCE      ; Chem1.iff - Silence all Audio - $00048004
L00004d88           clr.w   L00006318
L00004d8c           moveq   #$03,d0             ; song/sound number - 03 = player life lost
L00004d8e           jsr     PLAYER_INIT_SONG    ; chem.iff - music/sfx - init song - d0.l = song number - $00048010           ; External Address - CHEM.IFF
L00004d94           move.w  #$4da2,L00003c92
L00004d9a           move.w  #$63dc,L00006326
L00004da0           rts 


L00004da2            movea.w L00006326,a0
L00004da6            bsr.w   L00005438
L00004daa            move.w  a0,L00006326
L00004dae            tst.b   (a0)
L00004db0            bne     L00004d36                                  ; bne.b
L00004db2            jsr     PLAYER_INIT_SFX_2                          ; chem.iff - music/sfx - init sfx audio channel - $0004800c  ; External Address - CHEM.IFF
L00004db8            move.w  #$0032,d0
L00004dbc            bsr.w   L00005e8c
L00004dc0            bsr.w   L00004e28
L00004dc4            btst.b  #PANELST1_TIMER_EXPIRED,PANEL_STATUS_1     ; Panel - Status Byte 1 bit #$0000 of $0007c874
L00004dcc            beq.b   L00004dd6
L00004dce            lea.l   L00004e1c,a0
L00004dd2            bsr.w   L000067ca
L00004dd6            btst.b  #PANELST1_NO_LIVES_LEFT,PANEL_STATUS_1     ; Panel - Status Byte 1 - bit #$0001 of $0007c874
L00004dde            beq.b   L00004de8
L00004de0            lea.l   L00004e0e,a0
L00004de4            bsr.w   L000067ca
L00004de8            bsr.w   L00003cc0
L00004dec            move.w  #$001e,d0
L00004df0            bsr.w   L00005e8c
L00004df4            btst.b  #PANELST1_NO_LIVES_LEFT,PANEL_STATUS_1      ; Panel - Status Byte 1 - bit #$0001 of $0007c874
L00004dfc            beq.w   L00003b02
L00004e00            jsr     PLAYER_SILENCE         ; Chem.iff - Music/SFX player - Silence Audio- $00048004           ; External Address - CHEM.IFF
L00004e06            bsr.w   L00003d8c
L00004e0a            bra.w   LOADER_TITLE_SCREEN    ; $00000820 ; **** LOADER ****


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


L00004e28            movea.l playfield_buffer_2,a0      ; L000036f6,a0                ; [00061b9c]
L00004e2e            move.w  #$1c8b,d7
L00004e32            clr.l   (a0)+
L00004e34            dbf.w   d7,L00004e32
L00004e38            rts 


L00004e3a            moveq   #$10,d3
L00004e3c            tst.b   PANEL_STATUS_1             ; Panel - Status Byte 1 - $0007c874
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
L00004e64            lea.l   L00006318,a0                
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
L00004edc            and.w   playfield_swap_count,d6            ;  d6 = 1 or 0, even/odd playfield swap value - L0000632c,d6
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
L00004f10            MOVE.L  #$ffffff81,D2
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
L00004f64            sub.w   $00008002,d3            ; External Address - MAPGR.IFF
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
L00004fbc           MOVE.L #$fffffffa,D5
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

                    ; bat rope?
L00004fe0           move.w  #$6419,L00003626        ; Jump Table CMD9
L00004fe8           move.w  #$4ff6,L00003c92
L00004fee           moveq   #$08,d0                 ; sfx number - 08 = Bat Rope
L00004ff0           jsr     PLAYER_INIT_SFX         ; chem.iff - music/sfx - init sfx to play - d0 = sfx number - $00048014 ; External Address - CHEM.IFF
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
L000050ba           move.b  -64(a1,d4.W),d3         ; $c0(a1,d4.W),d3
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
L000050f4           MOVE.L #$ffffff81,D0
L000050f6           bra.b   L000050fa

                    ; bat-a-rang?
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
L0000511e           moveq   #$07,d0                 ; sfx number - 07 = Batarang
L00005120           jsr     PLAYER_INIT_SFX         ; chem.iff - music/sfx - init sfx to play - d0 = sfx number - $00048014 ; External Address - CHEM.IFF
L00005126           movem.w L000067c2,d0-d1
L0000512c           bclr.b  #$0004,L00006308
L00005132           lea.l   L00006314,a0
L00005136           btst.b  #$0004,L00006308
L0000513e           bne     L000051be               ; bne.b 
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
L00005296           bra.w   L0000592c     ; bra.b 


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
L000052f0           move.b  $00(a0,d3.W),d2             ; $00000d13 [d6],d2
L000052f4           sub.b   #$79,d2
L000052f8           cmp.b   #$0d,d2
L000052fc           bcc.w   L00005368                   ; bcc.b
L000052fe           move.w  #$4c3e,L00003c92
L00005304           bra.w   L00004c3e
L00005308           btst.b  #$0004,L00006308
L0000530e           bne.w   L0000545a
L00005312           btst.b  #$0000,L0000632d            ; test even/odd playfield buffer swap value
L00005318           bne.b   L000052ec
L0000531a           clr.w   d4
L0000531c           move.b  L00006308,d4
L00005320           move.w  L000067be,d2
L00005324           add.w   d1,d2
L00005326           and.w   #$0007,d2
L0000532a           beq.b   L0000534e
L0000532c           btst.l  #$0002,d4
L00005330           beq.b   L0000533a
L00005332           addq.w  #$01,d1
L00005334           move.w  #$0028,L000067c6
L0000533a           btst.l  #$0003,d4
L0000533e           beq.b   L00005348
L00005340           subq.w  #$01,d1
L00005342           move.w  #$0048,L000067c6
L00005348           move.w  d1,L000067c4
L0000534c           bra.b   L000053a6
L0000534e           bsr.w   L000055a0
L00005352           move.w  d4,d5
L00005354           and.b   #$03,d5
L00005358           move.b  d5,L00006308
L0000535c           moveq   #$01,d5
L0000535e           asr.w   #$01,d4
L00005360           bcs.w   L000052ee               ; bcs.b 
L00005362           MOVE.L #$ffffffff,D5
L00005364           asr.w   #$01,d4
L00005366           bcs.w   L000052ee               ; bcs.b
L00005368           asr.w   #$01,d4
L0000536a           bcc.b   L00005380
L0000536c           move.w  #$0028,L000067c6
L00005372           cmp.b   #$85,d2
L00005376           bcs.w   L000053ce
L0000537a           addq.w  #$01,L000067c4
L0000537e           bra.b   L000053a6
L00005380           asr.w   #$01,d4
L00005382           bcc.b   L000053cc
L00005384           move.w  #$0048,L000067c6
L0000538a           move.w  $00008002,d5            ; External Address - MAPGR.IFF
L00005390           sub.w   d5,d3
L00005392           sub.w   d5,d3
L00005394           sub.w   d5,d3
L00005396           move.b  $00(a0,d3.W),d2         ; $00000d13 [d6],d2
L0000539a           cmp.b   #$85,d2
L0000539e           bcs.b   L000053ce
L000053a0           subq.w  #$01,d1
L000053a2           move.w  d1,L000067c4
L000053a6           move.w  L000067be,d2
L000053aa           add.w   L000067c4,d2
L000053ae           addq.w  #$02,d2
L000053b0           not.w   d2
L000053b2           and.w   #$0007,d2
L000053b6           bclr.l  #$0002,d2
L000053ba           beq.b   L000053c0
L000053bc           add.w   #$e000,d2
L000053c0           add.w   #$0020,d2
L000053c4           lea.l   L000062ea,a0
L000053c8           clr.l   (a0)+
L000053ca           move.w  d2,(a0)
L000053cc           rts 


L000053ce           move.w #$4c3e,L00003c92
L000053d4           rts


L000053d6            add.w   #$0008,d1                   ; Jump Table CMD10
L000053da            bsr.w   L000055a0
L000053de            movem.w L000067c2,d0-d1
L000053e4            cmp.b   #$17,d2
L000053e8            bcs.b   L000053f4
L000053ea            move.w  #$8000,L00005506
L000053f0            bra.w   L0000545a


L000053f4           bsr.w   L000051e2         ; Jump table CMD3
L000053f8           lea.l   L000063d6,a0
L000053fc           bsr.b   L00005438
L000053fe           move.w  #$5406,L00003c92
L00005404           rts


L00005406           lea.l   L000063d9,a0
L0000540a           bsr.b   L00005438
L0000540c           btst.b  #$0002,L00006308
L00005412           bne.b   L00005420
L00005414           move.w  #$542a,L00003c92
L0000541a           lea.l   L000063d6,a0
L0000541e           bra.b   L00005438
L00005420           btst.b  #$0004,L00006308
L00005426           bne.b   L000053d6
L00005428           rts 


L0000542a           move.w  #$4c3e,L00003c92
L00005430           lea.l   L000063d3,a0
L00005434           bra.w   L00005438
L00005438           move.w  d7,-(a7)
L0000543a           lea.l   L000062ee,a1
L0000543e           move.w  (a1),d7
L00005440           and.w   #$e000,d7
L00005444           add.b   (a0)+,d7
L00005446           move.w  d7,(a1)
L00005448           add.b   (a0)+,d7
L0000544a           move.w  d7,-(a1)
L0000544c           add.b   (a0)+,d7
L0000544e           move.w  d7,-(a1)
L00005450           move.w  (a7)+,d7
L00005452           rts 


L00005454           dc.w    $0d01                       ; btst.l d6,d1
L00005456           dc.b    $01
L00005457           dc.b    $11                       ; btst.b d0,(a1) [04]
L00005458           dc.w    $ff02                       ; illegal


L0000545a           movem.w L000067c2,d0-d1
L00005460           clr.l   L000062f4
L00005464           move.w  L000067c4,L000067c6
L0000546a           lea.l   L00005454(pc),a0             ; $00005454 -$ffe8(pc),a0 
L0000546e           bsr.w   L00005438
L00005472           move.w  #$5482,L00003c92            ; Self Modifying Code? 
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
L000054b0           bcs.b   L000054c8
L000054b2           add.w   $00008002,d3                ; External Address - MAPGR.IFF
L000054b8           move.b  $00(a0,d3.W),d2             ; $00000d13 [d6],d2
L000054bc           dbf.w   d7,L000054a2
L000054c0           add.w   d0,d4
L000054c2           move.w  d4,L000067c2
L000054c6           bra.b   L000054cc
L000054c8           clr.w   L000062f4 
L000054cc           cmp.w   #$0010,d5
L000054d0           bpl.b   L000054d4
L000054d2           addq.w  #$01,d5
L000054d4           move.w  d5,L000062f6
L000054d8           asr.w   #$02,d5
L000054da           add.w   d5,d1
L000054dc           move.w  d1,L000067c4
L000054e0           btst.l  #$000f,d1
L000054e4           beq.b   L000054e8
L000054e6           rts 





L000054e8           bsr.w   L000055a0
L000054ec           cmp.b   #$17,d2
L000054f0           bcc.b   L000054fe
L000054f2           subq.w  #$07,L000067c4
L000054f6           movem.w L000067c2,d0-d1
L000054fc           bra.w   L00005482           ; bra.b
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
L00005560           tst.b   PANEL_STATUS_1                          ; Panel - Status Byte 1 - $0007c874
L00005566           bne.w   L00004d82
L0000556a           move.l  #$00004c3e,L00003c90
L00005572           lea.l   L000063d3,a0
L00005576           cmp.w   #$0050,L000062f8
L0000557c           bmi.w   L00005438
L00005580           moveq   #$5a,d6
L00005582           bsr.w   L00004ccc
L00005586           move.b  #2^PANELST1_LIFE_LOST,PANEL_STATUS_1    ; Panel - Status Byte 1 - #$04 -> $0007c874
L0000558e           btst.b  #PANELST2_CHEAT_ACTIVE,PANEL_STATUS_2   ; Panel - Status 2 Bytes - bit #$0007 of $0007c875
L00005596           bne.b   L0000559e
L00005598           jmp     PANEL_LOSE_LIFE                         ; Panel - Lose a Life - $0007c862
L0000559e           rts




L000055a0           movem.w L000067bc,d2-d3
L000055a6           add.w   d0,d2
L000055a8           add.w   d1,d3
L000055aa           lsr.w   #$03,d2
L000055ac           lsr.w   #$03,d3
L000055ae           mulu.w  $00008002,d3            ; External Address - MAPGR.IFF
L000055b4           add.w   d2,d3
L000055b6           lea.l   $0000807c,a0            ; External Address - MAPGR.IFF
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
L000055f6           add.l   playfield_buffer_2,d1       ;  L000036f6,d1
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
L000056c2           sub.b   -2(a0,d4.W),d3         ; $fe(a0,d4.W),d3
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
L000056fc           lea.l   -8(a1,d2.W),a1     ; $f8(a1,d2.W),a1
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
L00005768           MOVE.L #$ffffffff,D7
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
L000057aa           MOVE.L #$ffffffff,D0
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
L000057c6           MOVE.L #$ffffffff,D4
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
L000057dc           movea.l playfield_buffer_2,a2           ; L000036f6,a2
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
L000058b4           movea.l #CHIPMEM_BUFFER,a4        ; #$0005a36c,a4 ; External Address 
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





L000058e2           move.w  #$013f,d7                   ; $13f + 1 = $140 (320)  [$140*5 = $640 (1600)]
L000058e6           lea.l   L000068a0,a0                ; $6a80 + $640 = $6ee0
L000058ea           move.b  $0004(a0),d0
L000058ee           and.b   $0001(a0),d0
L000058f2           not.b   d0
L000058f4           and.b   $0002(a0),d0
L000058f8           and.b   $0003(a0),d0
L000058fc           eor.b   d0,$0001(a0)
L00005900           addq.w  #$05,a0                     ; 5 byte structure.
L00005902           dbf.w   d7,L000058ea

                    ; init map data?
L00005906           lea.l   $00008002,a0                ; External Address - MAPGR.IFF
L0000590c           move.w  (a0)+,d5                    ; a0 = 8004
L0000590e           move.w  (a0)+,d6                    ; a0 = 8006
L00005910           lea.l   $0076(a0),a0                ; a0 = 807c
L00005914           move.b  $0028(a0),d0                ; d0 = (80a4)
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

                    ; init some bat sprite data?
L00005942           movea.l L000062fe,a1
L00005946           movea.l #$00011002,a0           ; External Address - BATSPR1.IFF
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
L000059e0           movea.l #DISPLAY_BUFFER,a2        ; #$00061b9c,a2  ; External Address - (Screen Ram?)
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



L00005a7a           dc.w    $0004, $006b                ; or.b #$6b,d4
L00005a7e           dc.w    $0012, $0046                ; or.b #$46,(a2) [12]
L00005a82           dc.w    $0015, $0097                ; or.b #$97,(a5)
L00005a86           dc.w    $0017, $0064                ; or.b #$64,(a7) [60]
L00005a8a           dc.w    $0018, $0085                ; or.b #$85,(a0)+ [00]
L00005a8e           dc.w    $001b, $00bc                ; or.b #$bc,(a3)+ [71]
L00005a92           dc.w    $001f, $00c1                ; or.b #$c1,(a7)+ [60]
L00005a96           dc.w    $00ff                       ; illegal
L00005a98           dc.w    $0000
L00005a9a           dc.w    $5290                ; or.b #$90,d0
L00005a9c           dc.w    $45ce                       ; illegal
L00005a9e           dc.w    $410a                       ; illegal
L00005aa0           dc.w    $405e                       ; negx.w (a6)+
L00005aa2           dc.w    $40b8, $400c                ; negx.l $400c [342e0008]
L00005aa6           dc.w    $40f0, $4044                ; move.w sr,(a0,d4.W,$44) == $00000b45
L00005aaa           dc.w    $5290                       ; addq.l #$01,(a0) [003c004a]
L00005aac           dc.w    $5290                       ; addq.l #$01,(a0) [003c004a]
L00005aae           dc.w    $5290                       ; addq.l #$01,(a0) [003c004a]
L00005ab0           dc.w    $5290                       ; addq.l #$01,(a0) [003c004a]
L00005ab2           dc.w    $43a0                       ; chk.w -(a0),d1
L00005ab4           dc.w    $4380                       ; chk.w d0,d1
L00005ab6           dc.w    $41a2                       ; chk.w -(a2),d0
L00005ab8           dc.w    $426c, $4430                ; clr.w (a4,$4430) == $00c02531 [0000]
L00005abc           dc.w    $4444                       ; neg.w d4
L00005abe           dc.w    $447e                       ; illegal
L00005ac0           dc.w    $0000, $5c6e                ; or.b #$6e,d0
L00005ac4           dc.w    $5bea, $5c02                ; smi.b (a2,$5c02) == $000733ea [d5] (F)
L00005ac8           dc.w    $426c, $5b5c                ; clr.w (a4,$5b5c) == $00c03c5d [f44e]
L00005acc           dc.w    $5b06                       ; subq.b #$05,d6
L00005ace           dc.w    $5eb8, $5ecc                ; addq.l #$07,$5ecc [536e0008]
L00005ad2           dc.w    $5f42                       ; subq.w #$07,d2
L00005ad4           dc.w    $5fcc, $6020                ; dble.w d4,#$6020 == $0000baf6 (F)
L00005ad8           dc.w    $5d04                       ; subq.b #$06,d4
L00005ada           dc.w    $5d3c                       ; illegal
L00005adc           dc.w    $5db0, $5ae4                ; subq.l #$06,(a0,d5.L[*2],$e4) == $02120e17 (68020+) [43003800]
L00005ae0           dc.w    $5aee, $5af8                ; spl.b (a6,$5af8) == $00e04af8 [4c] (T)

; could be data but looks too much like code not to be (doesn't appear to be called)
L00005ae4           moveq   #$01,d0
L00005ae6           cmp.w   L000062fc,d0
L00005aea           bcs.b   L00005b02
L00005aec           bra.b   L00005afe
L00005aee           moveq   #$02,d0
L00005af0           cmp.w   L000062fc,d0
L00005af4           bcs.b   L00005b02
L00005af6           bra.b   L00005afe
L00005af8           moveq   #$03,d0
L00005afa           cmp.w   L000062fc,d0
L00005afe           move.w  d0,L000062fc
L00005b02           clr.w   (a6)
L00005b04           rts 

L00005b06           move.w  #$0590,d0
L00005b0a           sub.w   L000067bc,d0
L00005b0e           addq.w  #$02,$000a(a6)
L00005b12           movea.l $0008(a6),a5
L00005b16           move.w  (a5),d2
L00005b18           bpl.w   L000045bc
L00005b1c           bsr.w   double_buffer_playfield         ; L000036fa
L00005b20           moveq   #$32,d0
L00005b22           bsr.w   L00005e8c
L00005b26           bra.w   L00005e3a


L00005b2a           dc.w    $0001, $0001                    ; or.b #$01,d1
L00005b2e           dc.w    $0001, $0001                    ; or.b #$01,d1
L00005b32           dc.w    $0002, $0002                    ; or.b #$02,d2
L00005b36           dc.w    $0002, $0002                    ; or.b #$02,d2
L00005b3a           dc.w    $0003, $0003                    ; or.b #$03,d3
L00005b3e           dc.w    $0003, $0003                    ; or.b #$03,d3
L00005b42           dc.w    $0004, $0004                    ; or.b #$04,d4
L00005b46           dc.w    $0004, $0004                    ; or.b #$04,d4
L00005b4a           dc.w    $0002, $0002                    ; or.b #$02,d2
L00005b4e           dc.w    $0002, $0002                    ; or.b #$02,d2
L00005b52           dc.w    $0001, $0001                    ; or.b #$01,d1
L00005b56           dc.w    $0001, $0001                    ; or.b #$01,d1
L00005b5a           dc.w    $ffff                           ; illegal


L00005b5c           move.w  #$0098,$0004(a6)                ; $00dff004
L00005b62           lea.l   L000039c8,a5
L00005b66           move.w  #$0085,d2
L00005b6a           moveq   #$09,d7
L00005b6c           cmp.w   $0006(a5),d2                    ; $00bfd106,d2
L00005b70           beq.b   L00005b7c
L00005b72           lea.l   $0016(a5),a5
L00005b76           dbf.w   d7,L00005b6c
L00005b7a           bra.b   L00005b80
L00005b7c           move.w  (a5),d2
L00005b7e           bne.b   L00005b8c
L00005b80           bclr.b  #$0007,L0000670a
L00005b88           clr.w   (a6)
L00005b8a           rts


                    ; jack falls & hits the vat?
L00005b8c           subq.w  #$01,d2
L00005b8e           bne.b   L00005b8a
L00005b90           jsr     PLAYER_INIT_SFX_1                       ; chem.iff - Music/SFX player - init fsx audio channel - $00048008                               ; External Address - CHEM.IFF
L00005b96           bset.b  #PANELST1_TIMER_EXPIRED,PANEL_STATUS_1  ; Panel - Status Byte 1 - bit #$0000 of $0007c874
L00005b9e           move.w  #$5290,L00003c92
L00005ba4           clr.w   L000062fa
L00005ba8           clr.w   L00006318
L00005bac           move.w  $0004(a5),d0                            ; $00bfd104,d0
L00005bb0           cmp.w   #$00d4,d0
L00005bb4           bcs.b   L00005bd2
L00005bb6           move.w  #$0081,$0006(a5)                        ; $00bfd106
L00005bbc           move.l  #$00005b28,$0008(a5)                    ; $00bfd108
L00005bc4           move.w  #$0019,(a5)
L00005bc8           clr.w   (a6)
L00005bca           moveq   #$0b,d0                                 ; sfx number = $0b = Splash (jack in the vat)
L00005bcc           jmp     PLAYER_INIT_SFX                         ; chem.iff - music/sfx - init sfx to play - d0 = sfx number - $00048014 ; External Address - CHEM.IFF


L00005bd2           subq.w  #$01,L000067c8
L00005bd6           sub.w   #$0018,d0
L00005bda           sub.w   L000067be,d0
L00005bde           neg.w   d0
L00005be0           add.w   L000067c4,d0
L00005be4           move.w  d0,L000067c6
L00005be8           rts


L00005bea           bsr.b   L00005c20
L00005bec           cmp.w   #$0008,d2
L00005bf0           bcc.b   L00005be8
L00005bf2           cmp.w   #$0004,d2
L00005bf6           bne.w   L000045bc
L00005bfa           bsr.b   L00005c4e
L00005bfc           moveq   #$04,d2
L00005bfe           bra.w   L000045bc
L00005c02           bsr.b   L00005c20
L00005c04           or.w    #$e000,d2
L00005c08           cmp.w   #$e008,d2
L00005c0c           bcc.b   L00005be8
L00005c0e           cmp.w   #$e004,d2
L00005c12           bne.w   L000045bc
L00005c16           bsr.b   L00005c42
L00005c18           move.w  #$e004,d2
L00005c1c           bra.w   L000045bc
L00005c20           clr.w   d2
L00005c22           move.w  $0008(a6),d2            ; $00dff008,d2
L00005c26           addq.b  #$04,d2
L00005c28           bcc.b   L00005c32
L00005c2a           moveq   #$06,d2
L00005c2c           bsr.w   L000044b6
L00005c30           clr.w   d2
L00005c32           move.w  d2,$0008(a6)            ; $00dff008
L00005c36           cmp.w   #$0037,d2
L00005c3a           bcc.b   L00005c40
L00005c3c           lsr.w   #$03,d2
L00005c3e           addq.w  #$01,d2
L00005c40           rts 


L00005c42           movem.w L000067c2,d3-d4
L00005c48           add.w   #$0010,d3
L00005c4c           bra.b   L00005c56
L00005c4e           movem.w L000067c2,d3-d4
L00005c54           addq.w  #$04,d3
L00005c56           sub.w   d0,d3
L00005c58           cmp.w   #$0016,d3
L00005c5c           bcc.b   L00005c40
L00005c5e           cmp.w   d1,d4
L00005c60           bmi.b   L00005c40
L00005c62           cmp.w   L000062f0,d1
L00005c66           bmi.b   L00005c40
L00005c68           moveq   #$03,d6
L00005c6a           bra.w   L00004ccc
L00005c6e           move.w  $000c(a6),d3            ; $00dff00c,d3
L00005c72           addq.b  #$06,d3
L00005c74           move.w  d3,$000c(a6)            ; $00dff00c
L00005c78           cmp.b   #$20,d3
L00005c7c           bcs.b   L00005c40
L00005c7e           moveq   #$01,d2
L00005c80           cmp.b   #$40,d3
L00005c84           bcs.w   L000045bc
L00005c88           move.w  $000a(a6),d5            ; $00dff00a,d5
L00005c8c           cmp.w   #$0010,d5
L00005c90           bcc.w   L00005c96
L00005c94           addq.w  #$01,d5
L00005c96           move.w  d5,$000a(a6)            ; $00dff00a
L00005c9a           lsr.w   #$01,d5
L00005c9c           add.w   $0008(a6),d5            ; $00dff008,d5
L00005ca0           move.w  d5,$0008(a6)            ; $00dff008
L00005ca4           add.w   d5,d1
L00005ca6           bsr.w   L000055a0
L00005caa           cmp.b   #$79,d2
L00005cae           bcs.b   L00005cd8
L00005cb0           move.w  L000067be,d3
L00005cb4           add.w   d1,d3
L00005cb6           and.w   #$0007,d3
L00005cba           not.w   d3
L00005cbc           add.w   d3,d1
L00005cbe           moveq   #$04,d2
L00005cc0           eor.w   d2,$0002(a6)            ; $00dff002
L00005cc4           clr.l   $0008(a6)               ; $00dff008
L00005cc8           clr.w   $000c(a6)               ; $00dff00c
L00005ccc           moveq   #$05,d2
L00005cce           bsr.w   L000044b6
L00005cd2           moveq   #$02,d2
L00005cd4           bra.w   L000045bc
L00005cd8           moveq   #$01,d2
L00005cda           move.w  L000067c2,d3
L00005cde           sub.w   d0,d3
L00005ce0           addq.w  #$03,d3
L00005ce2           cmp.w   #$0007,d3
L00005ce6           bcc.w   L000045bc
L00005cea           cmp.w   L000062f0,d1
L00005cee           bmi.w   L000045bc
L00005cf2           cmp.w   L000067c4,d1
L00005cf6           bpl.w   L000045bc
L00005cfa           moveq   #$02,d6
L00005cfc           bsr.w   L00004ccc
L00005d00           bra.b   L00005cbe
L00005d02           rts 


L00005d04           move.w  $0004(a6),d2            ; $00dff004,d2
L00005d08           not.w   d2
L00005d0a           and.w   #$0007,d2
L00005d0e           bclr.l  #$0002,d2
L00005d12           bne.b   L00005d18
L00005d14           add.w   #$e000,d2
L00005d18           move.w  d2,-(a7)
L00005d1a           addq.w  #$02,d2
L00005d1c           bsr.w   L000045bc
L00005d20           move.w  (a7)+,d2
L00005d22           and.w   #$e000,d2
L00005d26           addq.w  #$01,d2
L00005d28           bsr.w   L0000458a
L00005d2c           btst.b  #$0000,L0000632d        ; test even/odd playfield buffer swap value
L00005d32           beq.b   L00005d02
L00005d34           subq.w  #$01,$0004(a6)          ;$00dff004
L00005d38           bmi.b   L00005d82
L00005d3a           rts 


                    ; jack falls hits the vat?
L00005d3c           btst.b  #$0000,L0000632d                ; test even/odd playfield buffer swap value
L00005d42           beq.b   L00005d54
L00005d44           movem.l d0-d1/a6,-(a7)
L00005d48           moveq   #$0b,d0                         ; song number - $0b = Splash (jack in the vat)
L00005d4a           jsr     PLAYER_INIT_SFX                 ; chem.iff - music/sfx - init sfx to play - d0 = sfx number $00048014 ; External Address - CHEM.IFF
L00005d50           movem.l (a7)+,d0-d1/a6
L00005d54           move.w  playfield_swap_count,d2         ; L0000632c,d2
L00005d58           lsr.w   #$02,d2
L00005d5a           and.w   #$0003,d2
L00005d5e           addq.w  #$01,d2
L00005d60           bsr.w   L000045bc
L00005d64           sub.w   #$0010,d1
L00005d68           bpl.b   L00005d54
L00005d6a           lea.l   L000039c8,a5
L00005d6e           move.w  #$0103,d2
L00005d72           moveq   #$09,d7
L00005d74           cmp.w   $0006(a5),d2            ; $00bfd106,d2
L00005d78           beq.b   L00005d88
L00005d7a           lea.l   $0016(a5),a5
L00005d7e           dbf.w   d7,L00005d74
L00005d82           moveq   #$5a,d6
L00005d84           bra.w   L00004ccc
L00005d88           move.w  (a5),d2
L00005d8a           beq.b   L00005d82
L00005d8c           subq.w  #$01,d2
L00005d8e           bne.w   L00005d02
L00005d92           move.w  #$5290,L00003c92
L00005d98           move.w  #$0021,(a5)
L00005d9c           clr.w   L00006318
L00005da0           move.w  #$ffff,L000062fa
L00005da6           move.b  #2^PANELST1_TIMER_EXPIRED,PANEL_STATUS_1         ; Panel - Status Byte 1 - #$01 -> $0007c874
L00005dae           rts


L00005db0           move.w  L000067bc,d2
L00005db4           cmp.w   #$0540,d2
L00005db8           beq.b   L00005dce
L00005dba           addq.w  #$02,$0002(a6)          ; $00dff002
L00005dbe           moveq   #$70,d2
L00005dc0           sub.w   d0,d2
L00005dc2           cmp.w   #$fffd,d2
L00005dc6           bcc.b   L00005dca
L00005dc8           MOVE.L #$fffffffe,D2
L00005dca           add.w   d2,L000067c8
L00005dce           cmp.w   #$0048,d1
L00005dd2           bcc.b   L00005e26
L00005dd4           move.w  $000a(a6),d3            ; $00dff00a,d3
L00005dd8           cmp.w   #$000e,d3
L00005ddc           bpl.b   L00005de4
L00005dde           addq.w  #$01,d3
L00005de0           move.w  d3,$000a(a6)
L00005de4           asr.w   #$01,d3
L00005de6           add.w   d3,$0004(a6)
L00005dea           moveq   #$18,d2
L00005dec           sub.w   d1,d2
L00005dee           add.w   d2,L000067c6
L00005df2           moveq   #$06,d2
L00005df4           cmp.w   #$0004,d3
L00005df8           bmi.b   L00005e10
L00005dfa           moveq   #$07,d2
L00005dfc           cmp.w   #$0007,d2
L00005e00           bmi.b   L00005e10
L00005e02           moveq   #$0c,d2
L00005e04           and.w   playfield_swap_count,d2     ; L0000632c,d2
L00005e08           lsr.w   #$02,d2                     ; divide swap count by 4
L00005e0a           bne.b   L00005e0e                   ; frame swaps 4-7 - jmp $5e0e
L00005e0c           moveq   #$02,d2                     ; frame swaps 0-3 - do this
L00005e0e           addq.w  #$07,d2
L00005e10           bsr.w   L000045bc
L00005e14           jsr     PLAYER_SILENCE              ; Chem.iff - Music/SFX player - silence all audio - $00048004 ; External Address - CHEM.IFF
L00005e1a           move.l  #$00000210,d0
L00005e20           jmp     PANEL_ADD_SCORE             ; Panel Add Player Score (D0.l BCD value to add)- $0007c82a


                    ; level completed ?
L00005e26           moveq   #$50,d1
L00005e28           moveq   #$0b,d2
L00005e2a           bsr.w   L000045bc
L00005e2e           bsr.w   double_buffer_playfield     ; L000036fa
L00005e32           bset.b  #PANELST2_GAME_COMPLETE,PANEL_STATUS_2  ; Panel - Status 2 Bytes - bit #$0006 of $0007c875
L00005e3a           jsr     PLAYER_SILENCE              ; Chem.iff - Music/SFX player - Silence all audio - $00048004
L00005e40           moveq   #$02,d0                     ; song number - 02 = Level completed
L00005e42           jsr     PLAYER_INIT_SONG            ; chem.iff - music/sfx - init sonng - d0.l = song number - $00048010 ; External Address - CHEM.IFF
L00005e48           move.w  #$00fa,d0
L00005e4c           bsr.b   L00005e8c
L00005e4e           moveq   #$64,d0
L00005e50           bsr.w   L00005e8c
L00005e54           bsr.w   L00004e28
L00005e58           lea.l   L00003abd,a0
L00005e5c           bsr.w   L000067ca
L00005e60           bsr.w   L00003cc0
L00005e64           moveq   #$64,d0
L00005e66           bsr.w   L00005e8c
L00005e6a           bsr.w   L00004e28
L00005e6e           lea.l   L00003acd,a0
L00005e72           bsr.w   L000067ca
L00005e76           bsr.w   L00003cc0
L00005e7a           moveq   #$64,d0
L00005e7c           bsr.w   L00005e8c
L00005e80           bsr.w   L00003cbc
L00005e84           bsr.w   L00003d8c
L00005e88           bra.w   LOADER_LEVEL_2              ; External Address - Loader $00000828 


                    ; wait for 1 frame count
L00005e8c           add.w   frame_counter,d0            ; L000036ee,d0
L00005e90           cmp.w   frame_counter,d0            ; L000036ee,d0
L00005e94           bpl.b   L00005e90
L00005e96           rts 


L00005e98           movem.w L000067c2,d2-d3
L00005e9e           sub.w   d1,d3
L00005ea0           cmp.w   #$0001,d3
L00005ea4           bcc.b   L00005eca
L00005ea6           sub.w   d0,d2
L00005ea8           cmp.w   #$0020,d2
L00005eac           bcc.b   L00005eca
L00005eae           move.b  L000062ef,d2
L00005eb2           cmp.b   #$24,d2
L00005eb6           rts


L00005eb8           bsr.b   L00005e98
L00005eba           bcc.b   L00005eca
L00005ebc           move.w  #$0018,L000067c6
L00005ec2           addq.w  #$01,(a6)
L00005ec4           move.w  #$0020,$0008(a6)
L00005eca           rts  


L00005ecc           subq.w  #$01,$0008(a6)
L00005ed0           beq.b   L00005ef8
L00005ed2           moveq   #$27,d2
L00005ed4           sub.w   $0008(a6),d2
L00005ed8           lsr.w   #$03,d2
L00005eda           move.w  d2,-(a7)
L00005edc           bsr.w   L000045bc
L00005ee0           addq.w  #$08,d0
L00005ee2           move.w  (a7),d2
L00005ee4           bsr.w   L000045bc
L00005ee8           addq.w  #$08,d0
L00005eea           move.w  (a7),d2
L00005eec           bsr.w   L000045bc
L00005ef0           addq.w  #$08,d0
L00005ef2           move.w  (a7)+,d2
L00005ef4           bra.w   L000045bc


L00005ef8           clr.w   (a6)
L00005efa           bsr.w   L000055a0
L00005efe           lsl.w   #$08,d2
L00005f00           move.b  $01(a0,d3.W),d2
L00005f04           move.b  $02(a0,d3.W),d4
L00005f08           lsl.w   #$08,d4
L00005f0a           move.b  $03(a0,d3.W),d4
L00005f0e           movea.l L00005f64,a5
L00005f12           movem.w d2-d4,-(a5)
L00005f16           move.l  a5,L00005f64
L00005f1a           move.b  #$4f,$00(a0,d3.W)
L00005f20           move.b  #$4f,$01(a0,d3.W)
L00005f26           move.b  #$4f,$02(a0,d3.W)
L00005f2c           move.b  #$4f,$03(a0,d3.W)
L00005f32           bsr.w   L00005e98
L00005f36           bcc.b   L00005f42
L00005f38           move.w  #$53d6,L00003c92
L00005f3e           clr.w   L00006318
L00005f42           moveq   #$05,d2
L00005f44           bsr.w   L000045bc
L00005f48           moveq   #$05,d2
L00005f4a           addq.w  #$08,d0
L00005f4c           bsr.w   L000045bc
L00005f50           moveq   #$05,d2
L00005f52           addq.w  #$08,d0
L00005f54           bsr.w   L000045bc
L00005f58           moveq   #$05,d2
L00005f5a           addq.w  #$08,d0
L00005f5c           bsr.w   L000045bc
L00005f60           bra.w   L000058aa


L00005f64            dc.w $0000, $5fc4                   ; or.b #$c4,d0
L00005f68            dc.w $0000, $0000                   ; or.b #$00,d0
L00005f6c            dc.w $0000, $0000                   ; or.b #$00,d0
L00005f70            dc.w $0000, $0000                   ; or.b #$00,d0
L00005f74            dc.w $0000, $0000                   ; or.b #$00,d0
L00005f78            dc.w $0000, $0000                   ; or.b #$00,d0
L00005f7c            dc.w $0000, $0000                   ; or.b #$00,d0
L00005f80            dc.w $0000, $0000                   ; or.b #$00,d0
L00005f84            dc.w $0000, $0000                   ; or.b #$00,d0
L00005f88            dc.w $0000, $0000                   ; or.b #$00,d0
L00005f8c            dc.w $0000, $0000                   ; or.b #$00,d0
L00005f90            dc.w $0000, $0000                   ; or.b #$00,d0
L00005f94            dc.w $0000, $0000                   ; or.b #$00,d0
L00005f98            dc.w $0000, $0000                   ; or.b #$00,d0
L00005f9c            dc.w $0000, $0000                   ; or.b #$00,d0
L00005fa0            dc.w $0000, $0000                   ; or.b #$00,d0
L00005fa4            dc.w $0000, $0000                   ; or.b #$00,d0
L00005fa8            dc.w $0000, $0000                   ; or.b #$00,d0
L00005fac            dc.w $0000, $0000                   ; or.b #$00,d0
L00005fb0            dc.w $0000, $0000                   ; or.b #$00,d0
L00005fb4            dc.w $0000, $0000                   ; or.b #$00,d0
L00005fb8            dc.w $0000, $0000                   ; or.b #$00,d0
L00005fbc            dc.w $0000, $0000                   ; or.b #$00,d0
L00005fc0            dc.w $0000, $0000                   ; or.b #$00,d0
L00005fc4            dc.w $0000, $0000                   ; or.b #$00,d0
L00005fc8            dc.w $0000, $0000                   ; or.b #$00,d0



L00005fcc           cmp.w   #$00c0,d0
L00005fd0           bpl.b   L00006012
L00005fd2           and.w   #$0007,d4
L00005fd6           bne.b   L00005fe6
L00005fd8           addq.w  #$08,d0
L00005fda           bsr.w   L000055a0
L00005fde           subq.w  #$08,d0
L00005fe0           cmp.b   #$79,d2
L00005fe4           bcs.b   L00006012
L00005fe6           addq.w  #$01,$0002(a6)
L00005fea           subq.w  #$01,$0008(a6)
L00005fee           bpl.b   L00006016
L00005ff0           movem.w L000067c2,d2-d3
L00005ff6           sub.w   d0,d2
L00005ff8           cmp.w   #$0008,d2
L00005ffc           bcc.b   L00006016
L00005ffe           sub.w   d1,d3
L00006000           cmp.w   #$0013,d3
L00006004           bcc.b   L00006016
L00006006           move.w  #$0019,$0008(a6)
L0000600c           moveq   #$02,d6
L0000600e           bsr.w   L00004ccc
L00006012           move.w  #$001e,(a6)
L00006016           move.w  d4,d2
L00006018           lsr.w   #$01,d2
L0000601a           addq.w  #$01,d2
L0000601c           bra.w   L000045bc
L00006020           cmp.w   #$ffc0,d0
L00006024           bmi.b   L0000606a
L00006026           and.w   #$0007,d4
L0000602a           bne.b   L0000603e
L0000602c           sub.w   #$0010,d0
L00006030           bsr.w   L000055a0
L00006034           add.w   #$0010,d0
L00006038           cmp.b   #$79,d2
L0000603c           bcs.b   L0000606a
L0000603e           subq.w  #$01,$0002(a6)
L00006042           subq.w  #$01,$0008(a6)
L00006046           bpl.b   L0000606e
L00006048           movem.w L000067c2,d2-d3
L0000604e           sub.w   d0,d2
L00006050           add.w   #$000a,d2
L00006054           bcc.b   L0000606e
L00006056           sub.w   d1,d3
L00006058           cmp.w   #$0013,d3
L0000605c           bcc.b   L0000606e
L0000605e           move.w  #$0019,$0008(a6)
L00006064           moveq   #$02,d6
L00006066           bsr.w   L00004ccc
L0000606a           move.w  #$001d,(a6)
L0000606e           move.w  #$e003,d2
L00006072           lsr.w   #$01,d4
L00006074           eor.w   d4,d2
L00006076           addq.w  #$01,d2
L00006078           bra.w   L000045bc

                    even
L0000607c           dc.w $2A02, $2005, $2005, $2004, $1505, $1506, $1506, $1507         ;*. . . .........
L0000608C           dc.w $1507, $1506, $1507, $1507, $2C10, $2C08, $1402, $210D         ;........,.,...!.
L0000609C           dc.w $2B05, $1905, $2504, $1706, $1702, $2005, $0F06, $0006         ;+...%..... .....
L000060AC           dc.w $2405, $1507, $1C05, $1007, $1207, $1B03, $1308, $2C07         ;$.............,.
L000060BC           dc.w $2C07, $2C07, $2C07, $2904, $1A06, $03FE, $2902, $2008         ;,.,.,.).....). .
L000060CC           dc.w $1306, $2A08, $2007, $2A04, $2A02, $24FA, $1405, $2A03         ;..*. .*.*.$...*.
L000060DC           dc.w $2A08, $0F05, $0F05, $0F05, $0F05, $2A07, $1507, $1508         ;*.........*.....
L000060EC           dc.w $1507, $1508, $0200, $0201, $0202, $0000, $0100, $0100         ;................
L000060FC           dc.w $0101, $0604, $0B07, $0F07, $0C07, $0B06, $2005, $1208         ;............ ...
L0000610C           dc.w $1200, $2903, $2206, $2205, $2204, $1506, $1507, $1508         ;..).".".".......
L0000611C           dc.w $1504, $1504, $1506, $1507, $1504, $2904, $25FD, $1305         ;..........).%...
L0000612C           dc.w $2904, $2CFD, $2904, $1BFD, $2004, $1CFD, $0C07, $2805         ;).,.)... .....(.
L0000613C           dc.w $1503, $1503, $1503, $1503, $0301, $0301, $0601, $0401         ;................
L0000614C           dc.w $0400, $04FD, $04FA, $1D05, $1108, $0809, $2903, $2006         ;............). .
L0000615C           dc.w $2005, $2004, $1506, $1507, $1508, $1504, $1504, $1506         ; . .............
L0000616C           dc.w $1507, $1504, $2906, $1306, $2A07, $2904, $2EFC, $2904         ;....)...*.)...).
L0000617C           dc.w $25FB, $0C0F, $2211, $3416, $2C16, $2009, $1208, $0B08         ;%...".4.,. .....
L0000618C           dc.w $2903, $2005, $2004, $2004, $1505, $1506, $1507, $1503         ;). . . .........
L0000619C           dc.w $1504, $1505, $1506, $1503, $2903, $25FC, $1405, $0800         ;........).%.....
L000061AC           dc.w $0303, $2904, $1BFD, $2004, $1CFD, $0C07, $2004, $1207         ;..)... ..... ...
L000061BC           dc.w $0B07, $2904, $2006, $2005, $2004, $1506, $1507, $1508         ;..). . . .......
L000061CC           dc.w $1504, $1504, $1506, $1507, $1504, $2904, $25FD, $1405         ;..........).%...
L000061DC           dc.w $2B04, $2FFD, $2904, $18FC, $2004, $1CFD, $0C07, $2806         ;+./.)... .....(.
L000061EC           dc.w $1803, $1803, $1803, $1803, $0000, $0000, $0000, $0000         ;................
L000061FC           dc.w $0000, $0908, $0908, $0908, $0808, $1D05, $1308, $0809         ;................
L0000620C           dc.w $2904, $2006, $2005, $2004, $1506, $1507, $1508, $1504         ;). . . .........
L0000621C           dc.w $1504, $1506, $1507, $1503, $2904, $25FD, $1505, $2B04         ;........).%...+.
L0000622C           dc.w $2FFE, $2904, $19FD, $2202, $1EFC, $1005, $2805, $1504         ;/.)...".....(...
L0000623C           dc.w $1504, $1504, $1504, $2906, $1503, $1503, $1503, $1503         ;......).........
L0000624C           dc.w $1505, $0A08, $0009, $2903, $2005, $2004, $2004, $1405         ;......). . . ...
L0000625C           dc.w $1406, $1407, $1404, $1404, $1405, $1406, $1402, $2906         ;..............).
L0000626C           dc.w $1506, $2906, $2A07, $2903, $2EFC, $2903, $24FC, $2004         ;..).*.)...).$. .
L0000627C           dc.w $2004, $2004, $2004, $2706, $1304, $1304, $1304, $1303         ; . . .'.........
L0000628C           dc.w $190B, $0F09, $120D, $130D, $1309, $0B0F, $1D05, $1208         ;................
L0000629C           dc.w $0808, $2903, $2005, $2004, $2004, $1405, $1406, $1407         ;..). . . .......
L000062AC           dc.w $1404, $1404, $1405, $1406, $1402, $2903, $25FD, $1306         ;..........).%...
L000062BC           dc.w $2B04, $2FFD, $2903, $18FC, $2202, $1EFC, $1005, $2805         ;+./.)...".....(.
L000062CC           dc.w $1504, $1504
L000062d0           dc.w $1504
L000062d2           dc.w $1504
L000062d4           dc.w $2906
L000062d6           dc.w $1503
L000062d8           dc.w $1503
L000062da           dc.w $1503 
L000062dc           dc.w $1503
L000062de           dc.w $0001, $0002, $0003, $0004, $0005, $0007
L000062ea           dc.w $0005
L000062ec           dc.w $0002
L000062ee           dc.b $00
L000062ef           dc.b $01
L000062f0           dc.w $0000
L000062f2           dc.w $0000
L000062f4           dc.w $0000
L000062f6           dc.w $0000
L000062f8           dc.w $0000
L000062fa           dc.w $0001         
L000062fc           dc.w $0000
L000062fe           dc.w $0001
L00006300           dc.w $0000
L00006302           dc.w $0000
L00006304           dc.w $0000
L00006306           dc.w $0000
L00006308           dc.b $00
L00006309           dc.b $00
L0000630a           dc.w $0000        
L0000630C           dc.w $A07C
L0000630e           dc.w $0000
L00006310           dc.w $0000
L00006312           dc.w $0000
L00006314           dc.w $0000
L00006316           dc.w $0000
L00006318           dc.w $0000
L0000631a           dc.w $0000 
L0000631c           dc.w $0034
L0000631e           dc.w $0005
L00006320           dc.w $A36C
L00006322           dc.w $0000
L00006324           dc.w $3DFE
L00006326           dc.w $0000
L00006328           dc.w $0000
L0000632a           dc.w $0000   

playfield_swap_count
L0000632c           dc.b $00                    ; word value incremented when playfield buffers are swapped
L0000632d           dc.b $00

L0000632e           dc.w $2221, $201F, $1E1D, $1C1B, $1A19, $1817, $1615         ;.."! ...........
L0000633C           dc.w $1413, $1211, $100F, $0E0D, $0C0B, $0A09, $0807, $0605         ;................
L0000634C           dc.w $0403, $0201, $0003, $0609, $0D10, $1316, $191C, $1F22         ;..............."
L0000635C           dc.w $2529, $2C2F, $3235, $383B, $3E41, $4447, $4A4D, $5053         ;%),/258;>ADGJMPS
L0000636C           dc.w $5659, $5C5F, $6264, $676A, $6D70, $7375, $787B, $7E80         ;VY\_bdgjmpsux{~.
L0000637C           dc.w $8386, $888B, $8E90, $9395, $989A, $9D9F, $A2A4, $A7A9         ;................
L0000638C           dc.w $ABAE, $B0B2, $B4B7, $B9BB, $BDBF, $C1C3, $C5C7, $C9CB         ;................
L0000639C           dc.w $CDCF, $D0D2, $D4D6, $D7D9, $DBDC, $DEDF, $E1E2, $E4E5         ;................
L000063AC           dc.w $E7E8, $E9EA, $ECED, $EEEF, $F0F1, $F2F3, $F4F5, $F6F7         ;................
L000063BC           dc.w $F7F8, $F9F9, $FAFB, $FBFC, $FCFD, $FDFD, $FEFE, $FEFF         ;................
L000063CC           dc.w $FFFF, $FFFF
L000063d0           dc.w $30D2
L000063d2           dc.b $04
L000063d3           dc.b $01
L000063d4           dc.w $0207
L000063d6           dc.w $1901
L000063d8           dc.b $E6
L000063d9           dc.b $1E
L000063da           dc.w $01E1 
L000063DC           dc.w $1901
L000063de           dc.w $E619, $01E6, $1901, $E61B, $01E4, $1B01 ,$E41B         ;................
L000063EC           dc.w $01E4, $1B01, $E41B, $01E4, $1B01, $E41B, $01E4 ,$1B01         ;................
L000063FC           dc.w $E41D, $E300, $1DE3, $001D, $E300, $1DE3, $001D ,$E300         ;................
L0000640C           dc.w $1DE3, $001D
L00006410           dc.w $E300, $1DE3, $0000
L00006416           dc.w $2401, $0127 ,$0101  
L0000641C           dc.w $2A01, $FE2C, $FDD7, $2D01, $0100, $1301, $0116 ,$0101         ;*..,..-.........
L0000642C           dc.w $001B
L0000642e           dc.w $02C1, $0081, $0001, $0022, $0240, $00C0 ,$0040         ;.........".@...@
L0000643C           dc.w $00F0, $0002, $0003, $00C0, $0118, $000F, $00A0 ,$0118         ;................
L0000644C           dc.w $0040, $00E2, $0001, $0002, $0008, $00D8, $00A8 ,$00F0         ;.@..............
L0000645C           dc.w $0003, $000E, $0010, $0118, $000F, $00C8, $0118 ,$000F         ;................
L0000646C           dc.w $00C8, $0138, $00E0, $00F0, $0001, $000F, $00F0 ,$00D8         ;...8............
L0000647C           dc.w $00E0, $00A7, $0001, $0003, $0080, $0098, $0038 ,$0078         ;.............8.x
L0000648C           dc.w $0001, $000E, $0008, $0098, $0024, $0078, $0001 ,$000F         ;.........$.x....
L0000649C           dc.w $00C8, $0098, $0040, $001F, $0001, $0003, $00B0 ,$0018         ;.....@..........
L000064AC           dc.w $00A8, $0010, $0003, $000E, $0008, $0018, $000F ,$00D0         ;................
L000064BC           dc.w $0018, $000F, $00D0, $0038, $00D8, $0040, $0003 ,$000E         ;.......8...@....
L000064CC           dc.w $0008, $0018, $000F, $00F0, $0018, $000F, $00F0 ,$0058         ;...............X
L000064DC           dc.w $0128, $0040, $0002, $000E, $0140, $0078, $000E ,$0088         ;.(.@.....@.x....
L000064EC           dc.w $0018, $0178, $0040, $0002, $0003, $0190, $0038 ,$000F         ;...x.@.......8..
L000064FC           dc.w $01B0, $0018, $01BC, $0011, $0002, $000F, $01D0 ,$0018         ;................
L0000650C           dc.w $000F, $01B0, $0078, $0168, $00B0, $0002, $000F ,$0160         ;.....x.h.......`
L0000651C           dc.w $00F8, $0003, $0150, $0118, $0190, $0111, $0002 ,$000E         ;.....P..........
L0000652C           dc.w $0138, $0138, $000F, $0178, $0138, $01E8, $0100 ,$0004         ;.8.8...x.8......
L0000653C           dc.w $000F, $0150, $0118, $000F, $0140, $0138, $000E ,$0200         ;...P.....@.8....
L0000654C           dc.w $0138, $0003, $0220, $0118, $0220, $00EF, $0002 ,$000F         ;.8... ... ......
L0000655C           dc.w $0188, $00B8, $000F, $0200, $00D8, $0240, $003B ,$0001         ;...........@.;..
L0000656C           dc.w $000F, $0250, $0038, $0280, $007B, $0001, $000E ,$0250         ;...P.8...{.....P
L0000657C           dc.w $0098, $02B0, $0071, $0001, $000F, $02D0, $00B8 ,$02F0         ;.....q..........
L0000658C           dc.w $0071, $0002, $000E, $0258, $0098, $000F, $0300 ,$0078         ;.q.....X.......x
L0000659C           dc.w $02E0, $00C2, $0003, $000E, $0250, $00D8, $000F, $0250         ;.........P.....P
L000065AC           dc.w $00F8, $000F, $0300, $00D8, $025C, $00CF, $0003, $000F         ;.........\......
L000065BC           dc.w $0300, $00D8, $000F, $02E8, $0118, $000F, $0230, $00D8         ;.............0..
L000065CC           dc.w $02F8, $0120, $0003, $000E, $0250, $0118, $000E, $0250         ;... .....P.....P
L000065DC           dc.w $0138, $000F, $0320, $0138, $0318, $0120, $0003, $000E         ;.8... .8... ....
L000065EC           dc.w $0340, $0138, $0003, $0260, $0118, $000F, $0260, $0138         ;.@.8...`.....`.8
L000065FC           dc.w $0360, $0118, $0002, $000F, $0378, $00F8, $000F, $0378         ;.`.......x.....x
L0000660C           dc.w $0118, $02F0, $0048, $0003, $000F, $0288, $0038, $000E         ;.....H.......8..
L0000661C           dc.w $0310, $0038, $000F, $0288, $0018, $0360, $0038, $0001         ;...8.......`.8..
L0000662C           dc.w $0003, $0370, $0018, $03B0, $00B0, $0002, $0003, $03C0         ;...p............
L0000663C           dc.w $00B8, $000F, $03E0, $00D8, $03F0, $0102, $0001, $000E         ;................
L0000664C           dc.w $03C0, $0138, $0450, $00F2, $0003, $000E, $03B8, $0138         ;...8.P.........8
L0000665C           dc.w $000F, $0460, $0138, $0003, $0470, $00F8, $0468, $00C6         ;...`.8...p...h..
L0000666C           dc.w $0001, $0003, $0470, $00B8, $0468, $00A6, $0001, $000E         ;.....p...h......
L0000667C           dc.w $0400, $0078, $03A0, $0050, $0001, $000F, $0440, $0098         ;...x...P.....@..
L0000668C           dc.w $03D0, $0020, $0001, $000F, $0420, $0018, $0430, $0001         ;... ..... ...0..
L0000669C           dc.w $0002, $000F, $0450, $0018, $000F, $0440, $0038, $0480         ;.....P.....@.8..
L000066AC           dc.w $0012, $0002, $0003, $0490, $0058, $000E, $03E0, $0018         ;.........X......
L000066BC           dc.w $04B8, $0093, $0001, $0002, $04A4, $00B8, $04D8, $0110         ;................
L000066CC           dc.w $0002, $000E, $04A4, $0138, $000F, $0500, $0118, $0530         ;.......8.......0
L000066DC           dc.w $00F0, $0001, $0003, $0580, $00F0, $05B0, $00C8, $0002         ;................
L000066EC           dc.w $000F, $0540, $00B8, $000F, $0580, $00B8, $0580, $0090         ;...@............
L000066FC           dc.w $0002, $000E, $0568, $0078, $000F, $0568, $0078
L0000670a           dc.w $0574
L0000670c           dc.w $0030, $0003, $0018, $0520, $0018, $0017, $0580, $0018         ;.0..... ........
L0000671C           dc.w $0002, $0530, $0018, $0014, $0118, $0038, $0015, $00D0         ;...0.......8....
L0000672C           dc.w $0028, $0014, $0070, $0068, $0014, $01B0, $0110, $0014         ;.(...p.h........
L0000673C           dc.w $01F0, $0038, $0015, $01EF, $0078, $0015, $0217, $0028         ;...8.....x.....(
L0000674C           dc.w $0014, $0270, $0060, $0016, $0298, $0090, $0014, $0310         ;...p.`..........
L0000675C           dc.w $0120, $0016, $0378, $0038, $0014, $0378, $0098, $0014         ;. ...x.8...x....
L0000676C           dc.w $0398, $0090, $0015, $0400, $0130, $0014, $0458, $0078         ;.........0...X.x
L0000677C           dc.w $0015, $04EC, $0064, $0014, $03C8, $0030, $0014, $03D8         ;.....d.....0....
L0000678C           dc.w $0030, $0014, $0510, $0100, $0014, $0570, $0108, $0014         ;.0.........p....
L0000679C           dc.w $0578, $0108
L000067a0           dc.w $0000, $00F0, $0000, $0050, $0048, $0048                       ;.x.........P.H.H
L000067AC           dc.w $0050, $0200, $0000, $0200, $0050, $0038, $0038, $0050         ;.P.......P.8.8.P
L000067bc           dc.w $0000
L000067be           dc.w $00F0
L000067c0           dc.w $0000
L000067c2           dc.w $0050
L000067c4           dc.w $0048
L000067c6           dc.w $0048
L000067c8           dc.w $0050                 ;.......P.H.H.P



                    even
L000067ca           move.b  (a0)+,d0
L000067cc           bmi.w   L0000689e
L000067d0           and.w   #$00ff,d0
L000067d4           mulu.w  #$002a,d0
L000067d8           move.b  (a0)+,d1
L000067da           ext.w   d1
L000067dc           add.w   d1,d0
L000067de           movea.l playfield_buffer_2,a1       ; L000036f6,a1
L000067e4           lea.l   $00(a1,d0.W),a1             ; == $0003d7ba,a1


L000067e8           moveq   #$00,d0
L000067ea           move.b  (a0)+,d0
L000067ec           beq.b   L000067ca
L000067ee           cmp.b   #$20,d0
L000067f2           beq.w   L00006896
L000067f6           MOVE.L #$ffffffcd,D1
L000067f8           cmp.b   #$41,d0
L000067fc           bcc.b   L00006822
L000067fe           MOVE.L #$ffffffd4,D1
L00006800           cmp.b   #$30,d0
L00006804           bcc.b   L00006822
L00006806           moveq   #$00,d1
L00006808           cmp.b   #$21,d0
L0000680c           beq.b   L00006828
L0000680e           moveq   #$01,d1
L00006810           cmp.b   #$28,d0
L00006814           beq.b   L00006828
L00006816           moveq   #$02,d1
L00006818           cmp.b   #$29,d0
L0000681c           beq.b   L00006828
L0000681e           moveq   #$03,d1
L00006820           bra.b   L00006828
L00006822           add.b   d0,d1
L00006824           and.w   #$00ff,d1
L00006828           mulu.w  #$0028,d1
L0000682c           lea.l   L000068a0,a2
L00006832           lea.l   $00(a2,d1.W),a2             ;  == $0006d7e7,a2
L00006836           moveq   #$07,d7
L00006838           movea.l a1,a3
L0000683a           move.b  (a2)+,d1
L0000683c           and.b   d1,(a3)
L0000683e           move.b  (a2)+,d2
L00006840           or.b    d2,(a3)
L00006842           and.b   d1,$1c8c(a3);               ; == $00065835 [4e]
L00006846           move.b  (a2)+,d2
L00006848           or.b    d2,$1c8c(a3)                ; == $00065835 [4e]
L0000684c           and.b   d1,$3918(a3)                ; == $000674c1 [b0]
L00006850           move.b  (a2)+,d2
L00006852           or.b    d2,$3918(a3)                ; == $000674c1 [b0]
L00006856           and.b   d1,$55a4(a3)                ; == $0006914d [ec]
L0000685a           move.b  (a2)+,d2
L0000685c           or.b    d2,$55a4(a3)                ; == $0006914d [ec]
L00006860           lea.l   $002a(a3),a3                ; == $00063bd3,a3
L00006864           lea.l   -$0005(a2),a2               ; == $0006d7e3,a2
L00006868           move.b  (a2)+,d1
L0000686a           and.b   d1,(a3)
L0000686c           move.b  (a2)+,d2
L0000686e           or.b    d2,(a3)
L00006870           and.b   d1,$1c8c(a3)                ; == $00065835 [4e]
L00006874           move.b  (a2)+,d2
L00006876           or.b    d2,$1c8c(a3)                ; == $00065835 [4e]
L0000687a           and.b   d1,$3918(a3)                ; == $000674c1 [b0]
L0000687e           move.b  (a2)+,d2
L00006880           or.b    d2,$3918(a3)                ; == $000674c1 [b0]
L00006884           and.b   d1,$55a4(a3)                ; == $0006914d [ec]
L00006888           move.b  (a2)+,d2
L0000688a           or.b    d2,$55a4(a3)                ; == $0006914d [ec]
L0000688e           lea.l   $002a(a3),a3                ; == $00063bd3,a3
L00006892           dbf.w   d7,L0000683a
L00006896           lea.l   $0001(a1),a1                ; == $0003ff5b,a1
L0000689a           bra.w   L000067e8
L0000689e           rts 





                    ; 5 byte sequences of data
L000068a0           dc.w $CF30, $3000, $00C7, $3038, $0800, $C730, $3808, $00C7  ;.00...08...08...
L000068B0           dc.w $3038, $0800, $C730, $3808, $00E7, $0018, $1800, $CF30  ;08...08........0
L000068C0           dc.w $3000, $00E7, $0018, $1800, $F30C, $0C00, $00E1, $181E  ;0...............
L000068D0           dc.w $0600, $E318, $1C04, $00E3, $181C, $0400, $E318, $1C04  ;................
L000068E0           dc.w $00E3, $181C, $0400, $F30C, $0C00, $00F9, $0006, $0600  ;................
L000068F0           dc.w $9F60, $6000, $00CF, $3030, $0000, $C730, $3808, $00C7  ;.``...00...08...
L00006900           dc.w $3038, $0800, $C730, $3808, $00C7, $3038, $0800, $8760  ;08...08...08...`
L00006910           dc.w $7818, $00CF, $0030, $3000, $FF00, $0000, $00FF, $0000  ;x....00.........
L00006920           dc.w $0000, $FF00, $0000, $00FF, $0000, $0000, $FF00, $0000  ;................
L00006930           dc.w $009F, $6060, $0000, $8F60, $7010, $00CF, $0030, $3000  ;..``...`p....00.
L00006940           dc.w $837C, $7C00, $0001, $C6FE, $3800, $10CE, $EF21, $0000  ;.||.....8....!..
L00006950           dc.w $D6FF, $2900, $08E6, $F711, $0018, $C6E7, $2100, $807C  ;..).........!..|
L00006960           dc.w $7F03, $00C1, $003E, $3E00, $C738, $3800, $00C3, $383C  ;.....>>..88...8<
L00006970           dc.w $0400, $E318, $1C04, $00E3, $181C, $0400, $E318, $1C04  ;................
L00006980           dc.w $00E3, $181C, $0400, $E318, $1C04, $00F3, $000C, $0C00  ;................
L00006990           dc.w $837C, $7C00, $0001, $C6FE, $3800, $900C, $6F63, $00E1  ;.||.....8...oc..
L000069A0           dc.w $181E, $0600, $C330, $3C0C, $0087, $6078, $1800, $00FE  ;.....0<...`x....
L000069B0           dc.w $FF01, $0080, $007F, $7F00, $837C, $7C00, $0001, $C6FE  ;.........||.....
L000069C0           dc.w $3800, $9806, $6761, $00C0, $3C3F, $0300, $E106, $1E18  ;8...ga..<?......
L000069D0           dc.w $0038, $C6C7, $0100, $807C, $7F03, $00C1, $003E, $3E00  ;.8.....|.....>>.
L000069E0           dc.w $E31C, $1C00, $00C1, $3C3E, $0200, $816C, $7E12, $0001  ;......<>...l~...
L000069F0           dc.w $CCFE, $3200, $01FE, $FE00, $0080, $0C7F, $7300, $F10C  ;..2.........s...
L00006A00           dc.w $0E02, $00F9, $0006, $0600, $00FE, $FF00, $0000, $C0FF  ;................
L00006A10           dc.w $3F00, $1FC0, $E020, $0003, $FCFC, $0000, $8006, $7F79  ;?.... .........y
L00006A20           dc.w $0038, $C6C7, $0100, $807C, $7F03, $00C1, $003E, $3E00  ;.8.....|.....>>.
L00006A30           dc.w $837C, $7C00, $0001, $C6FE, $3800, $1CC0, $E323, $0003  ;.||.....8....#..
L00006A40           dc.w $FCFC, $0000, $01C6, $FE38, $0018, $C6E7, $2100, $807C  ;.......8....!..|
L00006A50           dc.w $7F03, $00C1, $003E, $3E00, $01FE, $FE00, $0080, $067F  ;.....>>.........
L00006A60           dc.w $7900, $F00C, $0F03, $00E1, $181E, $0600, $E318, $1C04  ;y...............
L00006A70           dc.w $00C7, $3038, $0800, $C730, $3808, $00E7, $0018, $1800  ;..08...08.......
L00006A80           dc.w $837C, $7C00, $0001, $C6FE, $3800, $18C6, $E721, $0080  ;.||.....8....!..
L00006A90           dc.w $7C7F, $0300, $01C6, $FE38, $0018, $C6E7, $2100, $807C  ;|......8....!..|
L00006AA0           dc.w $7F03, $00C1, $003E, $3E00, $837C, $7C00, $0001, $C6FE  ;.....>>..||.....
L00006AB0           dc.w $3800, $18C6, $E721, $0080, $7E7F, $0100, $C006, $3F39  ;8....!..~.....?9
L00006AC0           dc.w $0038, $C6C7, $0100, $807C, $7F03, $00C1, $003E, $3E00  ;.8.....|.....>>.
L00006AD0           dc.w $EF10, $1000, $00C7, $3838, $0000, $C338, $3C04, $0083  ;......88...8<...
L00006AE0           dc.w $6C7C, $1000, $817C, $7E02, $0001, $C6FE, $3800, $18C6  ;l|...|~.....8...
L00006AF0           dc.w $E721, $009C, $0063, $6300, $03FC, $FC00, $0001, $C6FE  ;.!...cc.........
L00006B00           dc.w $3800, $18C6, $E721, $0000, $FCFF, $0300, $01C6, $FE38  ;8....!.........8
L00006B10           dc.w $0018, $C6E7, $2100, $00FC, $FF03, $0081, $007E, $7E00  ;....!........~~.
L00006B20           dc.w $837C, $7C00, $0001, $C6FE, $3800, $1CC0, $E323, $001F  ;.||.....8....#..
L00006B30           dc.w $C0E0, $2000, $1FC0, $E020, $0019, $C6E6, $2000, $807C  ;.. .... .... ..|
L00006B40           dc.w $7F03, $00C1, $003E, $3E00, $07F8, $F800, $0003, $CCFC  ;.....>>.........
L00006B50           dc.w $3000, $19C6, $E620, $0018, $C6E7, $2100, $18C6, $E721  ;0.... ....!....!
L00006B60           dc.w $0010, $CCEF, $2300, $01F8, $FE06, $0083, $007C, $7C00  ;....#........||.
L00006B70           dc.w $01FE, $FE00, $0000, $C0FF, $3F00, $1FC0, $E020, $0007  ;........?.... ..
L00006B80           dc.w $F8F8, $0000, $03C0, $FC3C, $001F, $C0E0, $2000, $01FE  ;.......<.... ...
L00006B90           dc.w $FE00, $0080, $007F, $7F00, $01FE, $FE00, $0000, $C0FF  ;................
L00006BA0           dc.w $3F00, $1FC0, $E020, $0007, $F8F8, $0000, $03C0, $FC3C  ;?.... .........<
L00006BB0           dc.w $001F, $C0E0, $2000, $1FC0, $E020, $009F, $0060, $6000  ;.... .... ...``.
L00006BC0           dc.w $837C, $7C00, $0001, $C6FE, $3800, $1CC0, $E323, $0001  ;.||.....8....#..
L00006BD0           dc.w $DEFE, $2000, $10C6, $EF29, $0018, $C6E7, $2100, $807E  ;.. ....)....!..~
L00006BE0           dc.w $7F01, $00C0, $003F, $3F00, $39C6, $C600, $0018, $C6E7  ;.....??.9.......
L00006BF0           dc.w $2100, $18C6, $E721, $0000, $FEFF, $0100, $00C6, $FF39  ;!....!.........9
L00006C00           dc.w $0018, $C6E7, $2100, $18C6, $E721, $009C, $0063, $6300  ;....!....!...cc.
L00006C10           dc.w $8778, $7800, $00C3, $303C, $0C00, $C730, $3808, $00C7  ;.xx...0<...08...
L00006C20           dc.w $3038, $0800, $C730, $3808, $00C7, $3038, $0800, $8778  ;08...08...08...x
L00006C30           dc.w $7800, $00C3, $003C, $3C00, $F906, $0600, $00F8, $0607  ;x....<<.........
L00006C40           dc.w $0100, $F806, $0701, $00F8, $0607, $0100, $38C6, $C701  ;............8...
L00006C50           dc.w $0018, $C6E7, $2100, $807C, $7F03, $00C1, $003E, $3E00  ;....!..|.....>>.
L00006C60           dc.w $39C6, $C600, $0010, $CCEF, $2300, $01D8, $FE26, $0003  ;9.......#....&..
L00006C70           dc.w $F0FC, $0C00, $07D8, $F820, $0013, $CCEC, $2000, $19C6  ;....... .... ...
L00006C80           dc.w $E620, $009C, $0063, $6300, $3FC0, $C000, $001F, $C0E0  ;. ...cc.?.......
L00006C90           dc.w $2000, $1FC0, $E020, $001F, $C0E0, $2000, $1FC0, $E020  ; .... .... ....
L00006CA0           dc.w $0019, $C6E6, $2000, $00FE, $FF01, $0080, $007F, $7F00  ;.... ...........
L00006CB0           dc.w $39C6, $C600, $0010, $EEEF, $0100, $00FE, $FF01, $0000  ;9...............
L00006CC0           dc.w $D6FF, $2900, $10C6, $EF29, $0018, $C6E7, $2100, $18C6  ;..)....)....!...
L00006CD0           dc.w $E721, $009C, $0063, $6300, $39C6, $C600, $0018, $E6E7  ;.!...cc.9.......
L00006CE0           dc.w $0100, $08F6, $F701, $0000, $DEFF, $2100, $10CE, $EF21  ;..........!....!
L00006CF0           dc.w $0018, $C6E7, $2100, $18C6, $E721, $009C, $0063, $6300  ;....!....!...cc.
L00006D00           dc.w $837C, $7C00, $0001, $C6FE, $3800, $18C6, $E721, $0018  ;.||.....8....!..
L00006D10           dc.w $C6E7, $2100, $18C6, $E721, $0018, $C6E7, $2100, $807C  ;..!....!....!..|
L00006D20           dc.w $7F03, $00C1, $003E, $3E00, $03FC, $FC00, $0001, $C6FE  ;.....>>.........
L00006D30           dc.w $3800, $18C6, $E721, $0000, $FCFF, $0300, $01C0, $FE3E  ;8....!.........>
L00006D40           dc.w $001F, $C0E0, $2000, $1FC0, $E020, $009F, $0060, $6000  ;.... .... ...``.
L00006D50           dc.w $837C, $7C00, $0001, $C6FE, $3800, $18C6, $E721, $0018  ;.||.....8....!..
L00006D60           dc.w $C6E7, $2100, $00DA, $FF25, $0000, $CCFF, $3300, $8176  ;..!....%....3..v
L00006D70           dc.w $7E08, $00C4, $003B, $3B00, $03FC, $FC00, $0001, $C6FE  ;~....;;.........
L00006D80           dc.w $3800, $18C6, $E721, $0000, $FCFF, $0300, $01CC, $FE32  ;8....!.........2
L00006D90           dc.w $0018, $C6E7, $2100, $18C6, $E721, $009C, $0063, $6300  ;....!....!...cc.
L00006DA0           dc.w $837C, $7C00, $0001, $C6FE, $3800, $1CC0, $E323, $0083  ;.||.....8....#..
L00006DB0           dc.w $7C7C, $0000, $C106, $3E38, $0038, $C6C7, $0100, $807C  ;||....>8.8.....|
L00006DC0           dc.w $7F03, $00C1, $003E, $3E00, $03FC, $FC00, $0081, $307E  ;.....>>.......0~
L00006DD0           dc.w $4E00, $C730, $3808, $00C7, $3038, $0800, $C730, $3808  ;N..08...08...08.
L00006DE0           dc.w $00C7, $3038, $0800, $C730, $3808, $00E7, $0018, $1800  ;..08...08.......
L00006DF0           dc.w $39C6, $C600, $0018, $C6E7, $2100, $18C6, $E721, $0018  ;9.......!....!..
L00006E00           dc.w $C6E7, $2100, $18C6, $E721, $0018, $C6E7, $2100, $807C  ;..!....!....!..|
L00006E10           dc.w $7F03, $00C1, $003E, $3E00, $39C6, $C600, $0018, $C6E7  ;.....>>.9.......
L00006E20           dc.w $2100, $18C6, $E721, $0080, $6C7F, $1300, $817C, $7E02  ;!....!..l....|~.
L00006E30           dc.w $00C1, $383E, $0600, $E310, $1C0C, $00F7, $0008, $0800  ;..8>............
L00006E40           dc.w $39C6, $C600, $0018, $C6E7, $2100, $08D6, $F721, $0000  ;9.......!....!..
L00006E50           dc.w $D6FF, $2900, $00FE, $FF01, $0080, $7C7F, $0300, $816C  ;..).......|....l
L00006E60           dc.w $7E12, $00C9, $0036, $3600, $39C6, $C600, $0018, $C6E7  ;~....66.9.......
L00006E70           dc.w $2100, $10EE, $EF01, $0080, $7C7F, $0300, $01EE, $FE10  ;!.......|.......
L00006E80           dc.w $0018, $C6E7, $2100, $18C6, $E721, $009C, $0063, $6300  ;....!....!...cc.
L00006E90           dc.w $33CC, $CC00, $0011, $CCEE, $2200, $11CC, $EE22, $0081  ;3......."...."..
L00006EA0           dc.w $787E, $0600, $C330, $3C0C, $00C7, $3038, $0800, $C730  ;x~...0<...08...0
L00006EB0           dc.w $3808, $00E7, $0018, $1800, $03FC, $FC00, $0001, $CCFE  ;8...............
L00006EC0           dc.w $3200, $8118, $7E66, $00C3, $303C, $0C00, $8760, $7818  ;2...~f..0<...`x.
L00006ED0           dc.w $0003, $CCFC, $3000, $01FC, $FE02, $0081, $007E, $7E00  ;....0........~~.

L00006EE0           dc.w $39C6, $C600, $0010, $EEEF, $0100, $00FE, $FF01, $0000  ;9...............
L00006EF0           dc.w $D6FF, $2900, $10C6, $EF29, $0018, $C6E7, $2100, $18C6  ;..)....)....!...
L00006F00           dc.w $E721, $009C, $0063, $6300, $39C6, $C600, $0018, $E6E7  ;.!...cc.9.......
L00006F10           dc.w $0100, $08F6, $F701, $0000, $DEFF, $2100, $10CE, $EF21  ;..........!....!
L00006F20           dc.w $0018, $C6E7, $2100, $18C6, $E721, $009C, $0063, $6300  ;....!....!...cc.
L00006F30           dc.w $837C, $7C00, $0001, $C6FE, $3800, $18C6, $E721, $0018  ;.||.....8....!..
L00006F40           dc.w $C6E7, $2100, $18C6, $E721, $0018, $C6E7, $2100, $807C  ;..!....!....!..|
L00006F50           dc.w $7F03, $00C1, $003E, $3E00, $03FC, $FC00, $0001, $C6FE  ;.....>>.........
L00006F60           dc.w $3800, $18C6, $E721, $0000, $FCFF, $0300, $01C0, $FE3E  ;8....!.........>
L00006F70           dc.w $001F, $C0E0, $2000, $1FC0, $E020, $009F, $0060, $6000  ;.... .... ...``.
L00006F80           dc.w $837C, $7C00, $0001, $C6FE, $3800, $18C6, $E721, $0018  ;.||.....8....!..
L00006F90           dc.w $C6E7, $2100, $00DA, $FF25, $0000, $CCFF, $3300, $8176  ;..!....%....3..v
L00006FA0           dc.w $7E08, $00C4, $003B, $3B00, $03FC, $FC00, $0001, $C6FE  ;~....;;.........
L00006FB0           dc.w $3800, $18C6, $E721, $0000, $FCFF, $0300, $01CC, $FE32  ;8....!.........2
L00006FC0           dc.w $0018, $C6E7, $2100, $18C6, $E721, $009C, $0063, $6300  ;....!....!...cc.
L00006FD0           dc.w $837C, $7C00, $0001, $C6FE, $3800, $1CC0, $E323, $0083  ;.||.....8....#..
L00006FE0           dc.w $7C7C, $0000, $C106, $3E38, $0038, $C6C7, $0100, $807C  ;||....>8.8.....|
L00006FF0           dc.w $7F03, $00C1, $003E, $3E00, $03FC, $FC00, $0081, $307E  ;.....>>.......0~


;00007000 4E4A A4AA 5294 4525 4492 52A9 2AA9 5445  NJ..R.E%D.R.*.TE
;00007010 5245 4552 52AA 4944 AA44 AAAA 4A49 2AA4  REERR.ID.D..JI*.
;00007020 AAA4 544A 4552 AAAA AA44 9452 A951 1455  ..TJER...D.R.Q.U
;00007030 24A9 5111 4945 4AAA 5129 14A5 1491 54AA  $.Q.IEJ.Q)....T.
;00007040 4492 4494 AA54 4949 4911 4951 1549 4491  D.D..TIII.IQ.ID.
;00007050 4455 2AA4 4A95 14AA A454 9525 2954 A911  DU*.J....T.%)T..
;00007060 4452 5292 A911 4A94 A445 5554 9544 AA94  DRR...J..EUT.D..
;00007070 A52A AAAA 9295 5492 A454 A549 1254 444A  .*....T..T.I.TDJ
;00007080 9492 9112 4514 AA95 154A 9244 5255 44A5  ....E....J.DRUD.
;00007090 514A A4AA 52A4 5529 4492 AA92 9294 AA4A  QJ..R.U)D......J
;000070A0 A492 A449 1292 4A92 4491 52AA 4515 2452  ...I..J.D.R.E.$R
;000070B0 9114 5544 A912 5255 1152 4524 444A 9514  ..UD..RU.RE$DJ..
;000070C0 5154 544A 4A54 5252 524A 4A92 AAAA 5255  QTTJJTRRRJJ...RU
;000070D0 2454 A955 14A4 9444 9554 4A92 4955 2A4A  $T.U...D.TJ.IU*J
;000070E0 A924 492A 5125 2A49 2A55 2512 92A4 5552  .$I*Q%*I*U%...UR
;000070F0 A54A A4A5 2A92 4445 2AAA 5125 1125 5154  .J..*.DE*.Q%.%QT
;00007100 9452 4549 2A45 2A51 5492 94A4 9514 4952  .REI*E*QT.....IR
;00007110 9125 4525 14A9 1152 AA92 4492 A494 5514  .%E%...R..D...U.
;00007120 A524 5129 1525 1114 4449 2A4A AA94 4AAA  .$Q).%..DI*J..J.
;00007130 A912 9249 1129 4929 4549 4924 9495 5555  ...I.)I)EII$..UU
;00007140 2AA5 14A9 4524 AA95 2454 494A 4AA9 2451  *...E$..$TIJJ.$Q
;00007150 2A44 4492 9491 2925 24AA 9255 5515 294A  *DD...)%$..UU.)J
;00007160 5555 14A9 5515 2445 154A A4A9 1291 4AAA  UU..U.$E.J....J.
;00007170 52AA A495 2451 292A AA45 1454 AA51 4555  R...$Q)*.E.T.QEU
;00007180 4451 14A9 4A44 AAA9 1151 44A5 454A AA51  DQ..JD...QD.EJ.Q
;00007190 2952 A494 AA4A AA4A A914 554A 512A 5149  )R...J.J..UJQ*QI
;000071A0 1112 A914 AAA5 5245 452A A954 4449 5149  ......REE*.TDIQI
;000071B0 4A55 12A4 9255 2552 AA4A A944 954A 5491  JU...U%R.J.D.JT.
;000071C0 5115 14A9 2AA5 1549 2945 454A 9555 1515  Q...*..I)EEJ.U..
;000071D0 2514 524A 5451 1451 4555 1145 5529 54AA  %.RJTQ.QEU.EU)T.
;000071E0 5515 54A4 A94A A925 4525 2492 5512 A955  U.T..J.%E%$.U..U
;000071F0 2912 4AA9 1545 12AA 494A 4A92 AA92 5495  ).J..E..IJJ...T.
;00007200 2912 5124 A555 294A 554A 4492 5552 5255  ).Q$.U)JUJD.URRU
;00007210 24AA 4914 A944 A924 4915 5512 5551 4552  $.I..D.$I.U.UQER
;00007220 9155 2549 4AA5 5295 5444 5251 52AA A445  .U%IJ.R.TDRQR..E
;00007230 5552 A449 452A 9444 9245 1529 112A 4929  UR.IE*.D.E.).*I)
;00007240 24A9 1295 2525 5115 2449 1551 1255 1524  $...%%Q.$I.Q.U.$
;00007250 A552 A944 44A9 1514 4514 914A 4A95 1151  .R.DD...E..JJ..Q
;00007260 154A 4514 5295 52AA 4A54 A455 4AA9 24A9  .JE.R.R.JT.UJ.$.
;00007270 12A9 2A4A A4AA 4929 4A49 2952 AA44 5151  ..*J..I)JI)R.DQQ
;00007280 4452 5444 9124 524A 94A5 4515 514A 4A54  DRTD.$RJ..E.QJJT
;00007290 92A5 52A9 2555 2AA4 9515 1554 A924 4954  ..R.%U*....T.$IT
;000072A0 94A9 5154 9152 A554 514A A511 44A4 5129  ..QT.R.TQJ..D.Q)
;000072B0 4554 9124 454A 9512 5252 4512 AA49 4952  ET.$EJ..RRE..IIR
;000072C0 A4AA 9244 5555 2A49 4A49 5154 A555 5115  ...DUU*IJIQT.UQ.
;000072D0 5145 54A9 554A 4951 4492 9514 4AA9 1555  QET.UJIQD...J..U
;000072E0 2512 AA45 5149 5451 54AA A491 5544 9444  %..EQITQT...UD.D
;000072F0 9545 1295 1555 2451 4A55 2455 52A5 4A95  .E...U$QJU$UR.J.
;00007300 44AA 4A45 2A4A AA51 2551 4945 2451 1545  D.JE*J.Q%QIE$Q.E
;00007310 5294 A924 4555 12A5 5251 2A51 54A5 4AAA  R..$EU..RQ*QT.J.
;00007320 4491 1152 9555 4951 2524 4AA4 A452 9154  D..R.UIQ%$J..R.T
;00007330 4912 4912 AA91 44A4 4549 2552 5252 94A5  I.I...D.EI%RRR..
;00007340 1452 5552 5512 9529 4AAA A444 4A52 5524  .RURU..)J..DJRU$
;00007350 5455 4455 4929 4444 A552 4445 1495 4AAA  TUDUI)DD.RDE..J.
;00007360 AA95 2452 4AAA 5294 AA51 5155 44A9 2954  ..$RJ.R..QQUD.)T
;00007370 5455 1292 5512 912A 4454 A955 1294 492A  TU..U..*DT.U..I*
;00007380 A929 552A A515 4514 AAAA 492A 44AA 4A92  .)U*..E...I*D.J.
;00007390 AAA5 554A 5145 52A9 1152 A452 AA52 9154  ..UJQER..R.R.R.T
;000073A0 9124 4A55 4551 4912 AA95 24A5 54A5 2A49  .$JUEQI...$.T.*I
;000073B0 1511 2952 A4AA A4AA A952 A515 4915 1449  ..)R.....R..I..I
;000073C0 5451 2AAA AAAA 4489 4489 5514 A92A 552A  TQ*...D.D.U..*U*
;000073D0 AAA5 2AAA AAAA AAAA AAAA AAAA AAAA AAAA  ..*.............
;000073E0 AAAA AAAA AAAA AAAA AAAA AAAA AAAA AAAA  ................
;000073F0 AAAA AAAA AAAA AA94 A925 2AAA AAAA 4954  .........%*...IT
;00007400 A452 AA51 1495 2925 454A 4A4A A4AA A525  .R.Q..)%EJJJ...%
;00007410 14AA 4A49 1291 4955 52A9 4495 4A44 A52A  ..JI..IUR.D.JD.*
;00007420 5154 9254 9114 952A A452 9125 4512 5252  QT.T...*.R.%E.RR
;00007430 A524 4452 A912 5112 9129 2952 9249 54A5  .$DR..Q..))R.IT.
;00007440 2552 5252 9291 114A 94A9 24A5 5252 5252  %RRR...J..$.RRRR
;00007450 4954 A52A 4949 4AA4 A495 1154 AA4A 4A44  IT.*IIJ....T.JJD
;00007460 5514 544A 5514 5514 952A AAA4 4951 152A  U.TJU.U..*..IQ.*
;00007470 A495 2915 554A 4954 5455 1455 4952 9512  ..).UJITTU.UIR..
;00007480 94AA 5255 2954 AA95 5551 5491 2515 52AA  ..RU)T..UQT.%.R.
;00007490 92A5 5451 24AA A951 5544 5251 2AA4 4545  ..TQ$..QUDRQ*.EE
;000074A0 5524 A44A A949 54A9 5129 5544 9255 2949  U$.J.IT.Q)UD.U)I
;000074B0 2955 4492 5529 2929 5545 1544 9554 A4A9  )UD.U)))UE.D.T..
;000074C0 2949 2A94 9152 A524 5149 4912 9451 2524  )I*..R.$QII..Q%$
;000074D0 9445 254A 9554 4AA9 1544 AA49 2A49 4954  .E%J.TJ..D.I*IIT
;000074E0 A4A9 4525 5292 A552 5244 9449 1149 54A4  ..E%R..RRD.I.IT.
;000074F0 A945 2524 9292 AAA5 2952 5129 2545 5445  .E%$....)RQ)%ETE
;00007500 4A52 A912 A952 94A4 A529 12AA 4A52 9294  JR...R...)..JR..
;00007510 A449 4529 4A4A 5291 2A91 5452 514A 9155  .IE)JJR.*.TRQJ.U
;00007520 5555 5555 5555 5555 5555 5555 5555 5555  UUUUUUUUUUUUUUUU
;00007530 5555 5555 5555 5555 52A5 512A 4544 9145  UUUUUUUUR.Q*ED.E
;00007540 1511 294A 4A94 4AA9 1514 4525 494A A955  ..)JJ.J...E%IJ.U
;00007550 494A A494 5251 4445 2AAA 52AA 52AA 4955  IJ..RQDE*.R.R.IU
;00007560 2445 2AA5 1525 5549 2954 4952 5452 524A  $E*..%UI)TIRTRRJ
;00007570 9129 5494 5524 AA45 52A5 52A5 2A4A A524  .)T.U$.ER.R.*J.$
;00007580 4A44 5445 5549 4515 4515 292A 5154 4955  JDTEUIE.E.)*QTIU
;00007590 1451 1495 2525 4555 252A 9251 4945 1114  .Q..%%EU%*.QIE..
;000075A0 AAA9 4AA9 4A55 2AA4 4529 254A 44AA 9254  ..J.JU*.E)%JD..T
;000075B0 A554 9449 554A 924A 9244 9125 4944 5244  .T.IUJ.J.D.%IDRD
;000075C0 4AA4 94A9 52A5 52A5 5451 4529 2514 9454  J...R.R.TQE)%..T
;000075D0 A492 A511 54AA 9145 554A 5115 5529 14A5  ....T..EUJQ.U)..
;000075E0 54A5 14A5 5112 AA92 A4A5 14AA 454A 52AA  T...Q.......EJR.
;000075F0 5114 5245 2944 A914 9555 24A4 9554 5252  Q.RE)D...U$..TRR
;00007600 A491 2A91 5454 52AA A492 A914 9549 24A4  ..*.TTR......I$.
;00007610 9125 5494 5115 454A 92A5 1549 1514 52AA  .%T.Q.EJ...I..R.
;00007620 5125 5144 9492 4925 1449 54A5 2A4A 494A  Q%QD..I%.IT.*JIJ
;00007630 5529 12A4 AAAA 492A 5525 2529 294A 4495  U)....I*U%%))JD.
;00007640 292A 4949 54A4 4A92 A525 1129 2A4A 5511  )*IIT.J..%.)*JU.
;00007650 4A44 9551 2929 5144 9524 A924 A94A 9245  JD.Q))QD.$.$.J.E
;00007660 1249 12A5 1249 12AA 4929 5544 452A AA51  .I...I..I)UDE*.Q
;00007670 14AA 9451 24A5 4AA9 4AA9 5292 9295 2A52  ...Q$.J.J.R...*R
;00007680 5145 1292 AAA4 9252 92AA A525 14A9 1549  QE.....R...%...I
;00007690 5129 5545 44A5 514A A492 A912 92A4 AAAA  Q)UED.QJ........
;000076A0 9254 94A5 54A9 12A5 2551 2529 4A44 A545  .T..T...%Q%)JD.E
;000076B0 5125 294A 44A4 A551 2512 9254 912A 5525  Q%)JD..Q%..T.*U%
;000076C0 14AA AA92 5295 2495 4949 254A 92A5 1494  ....R.$.II%J....
;000076D0 912A 5124 A925 E9E8 EDF6 FD01 0101 050B  .*Q$.%..........
;000076E0 1317 1511 0D0C 0E10 0E06 FBF3 EFF1 F4F6  ................
;000076F0 F2EC E9E9 EFF8 FDFF FEFF 030A 1113 0F0A  ................
;00007700 0606 090A 07FD F2EC EAEE F2F4 EFEA E7EB  ................
;00007710 F3FD 0303 0306 0B14 1A1C 1812 0E0E 100F  ................
;00007720 07FC F2EE F0F5 F7F3 EEEB ECF2 FC02 0505  ................
;00007730 070B 1118 1A17 110D 0B0D 0E0B 02F8 EEEA  ................
;00007740 EBF0 F4F2 ECE7 E8EF FB01 0301 0207 0F17  ................
;00007750 1814 0F0B 0B0E 0F09 FEF3 EBEB F0F4 F6F1  ................
;00007760 EBE9 EDF8 0308 0808 0B11 1A1F 1F1B 1612  ................
;00007770 1213 120D 02F8 F1EF F3F7 F8F4 EDEB EEF9  ................
;00007780 030A 0B0A 0B10 161B 1C19 140E 0D0E 0D06  ................
;00007790 FCF2 ECEA EDF2 F4F0 ECEB EFF8 030A 0C0D  ................
;000077A0 0F14 191D 1E1B 1610 0E0C 0902 F7EE E8E6  ................
;000077B0 EAED EEEB E8E7 EBF5 FF05 0809 0C10 161B  ................
;000077C0 1C19 140F 0C0B 0800 F4EB E5E3 E7EB ECEB  ................
;000077D0 E7E6 EAF5 0008 0C0D 0F16 1C20 201B 1510  ...........  ...
;000077E0 0D0B 04FA EFE6 E1E1 E3E6 E5E2 E1E2 E9F3  ................
;000077F0 FD03 070A 0D12 1819 1813 0D09 0604 FEF4  ................
;00007800 E9E0 DCDE E3E6 E4E0 DFE4 F0FC 060C 1012  ................
;00007810 171C 2021 1D17 110C 0904 FBF0 E7E1 DEE2  .. !............
;00007820 E4E8 E7E6 E6EB F702 0B0F 1114 181D 211F  ..............!.
;00007830 1B16 0F0C 0904 F9EC E3DE DFE4 E8E8 E6E4  ................
;00007840 E7EF FC08 1013 1517 1C21 2524 211A 1511  .........!%$!...
;00007850 0F0A 01F4 EAE3 E1E5 EBEE EEEB EAF0 FA09  ................
;00007860 1317 1919 1C21 2423 1F19 140F 0A02 F6EB  .....!$#........
;00007870 E3E0 E1E5 E9E8 E7E6 EAF3 FF0B 1216 191B  ................
;00007880 1E20 211F 1A13 0D08 03FA EEE5 DDDA DBDF  . !.............
;00007890 E2E4 E3E4 E9F2 FD0A 1116 181A 1E21 221F  .............!".
;000078A0 1811 0C07 01F6 E9DE D8D7 DAE0 E3E4 E4E6  ................
;000078B0 EBF5 020F 181E 2123 2526 2724 1D15 0E07  ......!#%&'$....
;000078C0 01F7 EBE2 DBD9 DCDF E2E4 E4E6 EBF5 010B  ................
;000078D0 1318 1C1F 2224 2421 1D15 0E09 00F6 E9DE  ...."$$!........
;000078E0 D7D5 D9DF E4E6 E7E7 ECF8 0513 1D23 2527  .............#%'
;000078F0 282A 2A28 221A 130B 03F9 EDE4 DDDB DEE2  (**("...........
;00007900 E7EA EBEE F5FE 0914 1B20 2223 2424 221E  ......... "#$$".
;00007910 1811 0B03 FCF1 E5DB D5D5 D8DE E1E3 E3E4  ................
;00007920 EDF8 0714 1D23 2427 2726 241F 160C 03FA  .....#$''&$.....
;00007930 F2E9 DED5 CFCF D4DD E3E7 EAED F2FC 0712  ................
;00007940 1A20 2223 2323 211C 160E 06FE F7EB E0D7  . "###!.........
;00007950 D1D0 D3DA E2E7 ECEF F4FC 0918 2228 2B2A  ............"(+*
;00007960 2826 2522 1D15 0D04 F9EE E4DC D7D5 D7DB  (&%"............
;00007970 E0E6 EBF0 F4FC 0610 1920 2527 2927 2520  ......... %')'%
;00007980 1B15 0E07 FEF4 E9DF D9D6 D9DF E6EE F2F6  ................
;00007990 FA00 0915 1E27 2B2C 2C2A 2723 1D16 0E05  .....'+,,*'#....
;000079A0 FDF3 E9DE D7D4 D5DA E0E8 EDF0 F2F7 FE08  ................
;000079B0 121A 2021 221F 1D19 130D 05FD F5EE E4DB  .. !"...........
;000079C0 D3CD CCCF D7DF E7EC F0F3 F903 0F1A 2126  ..............!&
;000079D0 2726 221C 1813 0D07 01F8 F0E4 DAD4 D2D4  '&".............
;000079E0 D9E2 EAEF F3F5 F800 0913 1C22 2525 2420  ..........."%%$
;000079F0 1A16 100A 03FD F6ED E4DB D5D4 D8DF E8F0  ................
;00007A00 F5F8 FD03 0C17 2229 2E2F 2C28 221C 1812  ......")./,("...
;00007A10 0B04 FCF2 E9E0 DAD7 D8DE E7EF F8FD 0003  ................
;00007A20 070F 1720 272B 2C2A 241E 1711 0B05 FFF9  ... '+,*$.......
;00007A30 F1E7 E0DB DADE E6F1 FB01 0406 090E 1722  ..............."
;00007A40 2B31 3431 2C22 1912 0A03 FFF8 F2E9 DFD7  +141,"..........
;00007A50 D3D4 DAE4 EDF4 FAFC FE01 080F 1A22 2628  ............."&(
;00007A60 231B 1008 01FC F9F6 F1EA E1D7 D1D0 D5E0  #...............
;00007A70 ECF8 FF03 0203 060F 1922 2A2D 2B23 180D  ........."*-+#..
;00007A80 04FE FAF8 F7F3 ECE5 DCD6 D5DB E6F1 FB02  ................
;00007A90 0507 080B 111A 2228 2B27 1F14 08FD F6F1  ......"(+'......
;00007AA0 F0EF EEE9 E1DA D4D3 D8E2 EFFB 0409 0A08  ................
;00007AB0 080B 111A 2125 241E 1408 FEF6 F1F0 F1F2  ....!%$.........
;00007AC0 F0EB E4DD DADD E6F3 000B 1012 100E 0F14  ................
;00007AD0 1B22 2827 2114 06F7 ECE6 E6EA EFF0 EDE6  ."('!...........
;00007AE0 DDD8 D8E1 EEFD 0912 1411 0D09 0A0F 181F  ................
;00007AF0 2320 1808 F9EC E3E2 E6EC F1F1 EDE5 DEDA  # ..............
;00007B00 DDE7 F605 1219 1915 0F0D 0E14 1B21 221C  .............!".
;00007B10 10FE EEE3 DEE0 E8F0 F5F5 F1EB E6E7 EEFB  ................
;00007B20 0A16 1F22 1F17 100C 0C12 191C 1C15 0BFD  ..."............
;00007B30 EFE8 E4E7 EEF4 F7F6 F2ED EAEC F4FF 0D18  ................
;00007B40 2022 1F1A 140F 0E10 1314 130C 04F8 EEE8   "..............
;00007B50 E7EA F0F7 FBFD FCFA F9FA FF07 111A 1F21  ...............!
;00007B60 1E1A 1511 0F0F 1011 0E0A 03FC F5EE EBED  ................
;00007B70 F1F6 FAFD FEFE FFFF 0104 0A0F 1316 1715  ................
;00007B80 1210 0D0B 0A08 0500 FCF6 F1EE ECED EFF1  ................
;00007B90 F4F6 F7F8 F9FB FE01 0508 0A09 0703 0100  ................
;00007BA0 0102 0304 02FF FBF5 F0EE ECED EFF1 F3F4  ................
;00007BB0 F4F4 F4F6 FAFD 0205 0708 0606 0402 0202  ................
;00007BC0 0304 0301 FEFA F5F1 EFEE EFF1 F2F2 F2F3  ................
;00007BD0 F4F7 FBFF 0204 0404 0302 0202 0405 0709  ................
;00007BE0 0806 02FE FAF6 F3F3 F2F4 F6F8 FAFB FCFD  ................
;00007BF0 FF02 0508 0B0D 0E0E 0E0E 0E0D 0D0D 0D0C  ................
;00007C00 0A07 0300 FDFB F9F8 F9F9 FAFC FEFF 0002  ................
;00007C10 0405 0607 0707 0607 0708 0909 0806 03FF  ................
;00007C20 FBF7 F3F0 EFEE EEF0 F0F2 F3F5 F8FB FE00  ................
;00007C30 0203 0403 0404 0506 0707 0604 01FE FCF9  ................
;00007C40 F7F5 F3F2 F2F3 F4F6 F8FA FDFF 0103 0506  ................
;00007C50 0809 0A0B 0C0D 0E0E 0C0B 0907 0401 FEFB  ................
;00007C60 F8F5 F3F2 F2F4 F5F7 F9FC FE01 0407 0A0C  ................
;00007C70 0D0D 0D0D 0D0D 0C0C 0C0C 0C0B 0905 01FC  ................
;00007C80 F9F7 F7F7 F9FD 0003 0608 090B 0C0C 0D0E  ................
;00007C90 0E0E 0E0D 0C0B 0B0B 0908 0504 0200 FDFC  ................
;00007CA0 FAF9 F9F9 FBFC FEFF 0203 0506 0606 0505  ................
;00007CB0 0403 0302 0101 0101 0100 01FF FDFA F8F6  ................
;00007CC0 F5F4 F5F6 F7F9 FBFB FCFD FDFD FDFD FDFD  ................
;00007CD0 FDFD FDFD FEFF 0001 0101 00FE FCFB F8F7  ................
;00007CE0 F5F5 F7F9 FAFD FE00 0000 0101 0100 0000  ................
;00007CF0 0102 0404 0505 0504 0402 0100 FFFE FEFD  ................
;00007D00 FCFA F9F7 F8F8 F9F9 FAFB FAFB FBFC FDFE  ................
;00007D10 FF00 0001 0203 0506 0707 0604 01FF FCF8  ................
;00007D20 F5F4 F3F3 F5F7 FAFC FF00 0203 0303 0303  ................
;00007D30 0404 0607 0809 0B0B 0B0A 0806 0300 FEFC  ................
;00007D40 FAF9 F8F8 FAFA FBFC FE00 0102 0302 0304  ................
;00007D50 0506 0609 090A 0A09 0806 0503 01FF FDFB  ................
;00007D60 F9F7 F6F5 F6F7 F8FA FCFD FF00 0203 0407  ................
;00007D70 0708 0807 0606 0504 0403 0403 0200 FDFB  ................
;00007D80 FAF9 F8F9 FAFB FCFD FF01 0204 0506 0607  ................
;00007D90 0606 0505 0504 0506 0505 0403 0200 FEFC  ................
;00007DA0 FBFA F8F8 F8F8 FAFB FDFE 0001 0101 0000  ................
;00007DB0 0000 0102 0306 0708 0808 0807 0605 0403  ................
;00007DC0 0201 00FF FEFF FFFF 0001 0103 0305 0607  ................
;00007DD0 0708 0809 0808 0707 0606 0607 0708 0808  ................
;00007DE0 0707 0504 0201 00FF FEFD FDFD FDFF FF00  ................
;00007DF0 0101 0100 FFFF FFFF 0001 0102 0303 0303  ................
;00007E00 0302 0100 FEFC FBF9 F7F5 F4F4 F5F6 F9FA  ................
;00007E10 FBFC FDFD FDFE FDFD FCFD FDFD FEFE FEFF  ................
;00007E20 FEFE FEFD FDFC FBFA FAF9 F9F9 F9F9 F8F7  ................
;00007E30 F7F6 F6F6 F7F7 F8F9 FAFB FCFD FDFE FEFF  ................
;00007E40 FFFF FEFE FEFE FFFF FFFF FEFF FEFD FDFC  ................
;00007E50 FBFA FAFA FBFC FDFE FF00 0204 0506 0708  ................
;00007E60 0807 0707 0606 0605 0505 0505 0504 0404  ................
;00007E70 0301 0100 00FF 0000 0001 0002 0204 0505  ................
;00007E80 0606 0606 0504 0403 0303 0303 0404 0505  ................
;00007E90 0505 0604 0302 00FF FFFE FDFD FDFD FEFE  ................
;00007EA0 FEFF 0101 0203 0203 0303 0201 0101 0101  ................
;00007EB0 0101 0101 0101 0101 0100 FFFF FEFD FCFC  ................
;00007EC0 FCFC FCFC FCFD FDFD FEFE FF00 0001 0101  ................
;00007ED0 0000 0000 0000 0101 0101 0101 0000 FFFE  ................
;00007EE0 FEFD FCFC FBFB FBFB FDFD FF01 0203 0405  ................
;00007EF0 0404 0404 0504 0404 0303 0303 0505 0606  ................
;00007F00 0606 0404 0302 0101 0001 00FF FEFE FEFE  ................
;00007F10 FF00 0000 0101 0202 0203 0303 0303 0202  ................
;00007F20 0101 0102 0303 0303 0301 0100 00FE FDFC  ................
;00007F30 FBFB FBFC FDFE FF01 0204 0404 0404 0303  ................
;00007F40 0302 0201 0100 0001 0201 0100 00FF FDFD  ................
;00007F50 FBFA F8F8 F8F8 F9F9 FAFB FCFD FEFE FF00  ................
;00007F60 0100 0000 0000 0000 0000 0000 00FF FFFF  ................
;00007F70 FEFD FDFD FCFA FAFA F9FA FAFA FAFB FAFB  ................
;00007F80 FCFE FEFF FF00 FF00 0001 0102 0202 0102  ................
;00007F90 0102 0202 0304 0404 0403 0303 0201 0100  ................
;00007FA0 0001 0001 0102 0203 0304 0404 0405 0505  ................
;00007FB0 0505 0505 0505 0505 0405 0303 0201 0000  ................
;00007FC0 FFFE FEFD FCFC FCFC FCFC FCFC FDFE FF00  ................
;00007FD0 0001 0102 0202 0202 0100 0000 0000 FFFF  ................
;00007FE0 FEFE FDFD FDFC FCFB FAFA F9F9 F9FA FAFA  ................
;00007FF0 FBFC FDFE FFFF 0001 0101 0100 0000 8000  ................
;00008000 0029 00C0 0029 0000 0000 0014 0000 0000  .)...)..........
;00008010 0000 0000 0000 0000 0000 0000 0000 0000  ................
;00008020 0000 0000 0000 0000 0000 0000 0000 0000  ................
;00008030 0000 0000 0000 0000 0000 0000 0000 0000  ................
;00008040 0000 0000 0000 0000 0000 0000 0000 0000  ................
;00008050 0000 0000 0000 0000 0000 0000 0000 0000  ................
;
;
;
;
;