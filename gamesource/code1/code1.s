

                ;
                ; Level 1 - Memory Map
                ; ------------------------------
                ; The following files are loaded and decrunched into the following locations
                ; by the game loader
                ;
                ; NOTES:
                ; ------
                ; 1) If 'JAMMMM' cheat mode active then 'F10' skip to next level (Enter text 'JAMMMM' on title screen)
                ;
                ;
                ; Filename/Area     Start   End         Additional Info
                ;---------------------------------------------------------------------------------------------
                ; BATMAN            $800                - Game Loader (always resident across loads)
                ; CODE1             $2FFC   $6FFE       - $3000 = entry point for level code. (16Kb)
                ; MAPGR             $7FFC
                ;
                ;                   $10000              - Display Object List
                ;                                           - 305 - game display objects
                ;                                                   initialised from data in BATSPR1.IFF file.
                ;
                ; BATSPR1           $10FFC              - Display Objects & Graphics
                ;                                       - $11002 = 16 bit - number of display object
                ;                                       - $11004 = start of display object data
                ;                                                   - 8 byte structure per object
                ;                                                       - 1 word (unused $800f)
                ;                                                       - 1 byte pixel width
                ;                                                       - 1 byte pixel height
                ;                                                       - 4 bytes gfx start offset
                ;                                                           gfx base starts at end of list of objects
                ;                                                           (No of objects * 8) + $11004 = $1198C
                ;
                ; CHEM              $47FE4              - Level Music Player, Music & SFX
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
LOADER_TITLE_SCREEN             EQU $00000820                       ; Load Title Screen 
LOADER_LEVEL_1                  EQU $00000824                       ; Load Level 1
LOADER_LEVEL_2                  EQU $00000828                       ; Load Level 2
LOADER_LEVEL_3                  EQU $0000082c                       ; Load Level 3
LOADER_LEVEL_4                  EQU $00000830                       ; Load Level 4
LOADER_LEVEL_5                  EQU $00000834                       ; Load Level 5



; Music Player Constants
AUDIO_PLAYER_INIT               EQU $00048000                       ; initialise music/sfx player
AUDIO_PLAYER_SILENCE            EQU $00048004                       ; Silence all audio
AUDIO_PLAYER_INIT_SFX_1         EQU $00048008                       ; Initialise SFX Audio Channnel
AUDIO_PLAYER_INIT_SFX_2         EQU $0004800c                       ; same as init_sfx_1 above
AUDIO_PLAYER_INIT_SONG          EQU $00048010                       ; initialise song to play - D0.l = song/sound 1 to 13
AUDIO_PLAYER_INIT_SFX           EQU $00048014                       ; initialise sfx to play - d0.l = sfx 5 to 13
AUDIO_PLAYER_UPDATE             EQU $00048018                       ; regular update (vblank to keep sounds/music playing)



; Panel Constants - original function addresses
PANEL_UPDATE                    EQU $0007c800                       ; called on VBL to update panel display
PANEL_INIT_TIMER                EQU $0007c80e                       ; initialise level timer (D0.w = BCD encoded MIN:SEC)
PANEL_INIT_SCORE                EQU $0007c81c                       ; initialise player score
PANEL_ADD_SCORE                 EQU $0007c82a                       ; add value to player score (D0.l = BCD encoded value)
PANEL_INIT_LIVES                EQU $0007c838                       ; initialise player lives
PANEL_ADD_LIFE                  EQU $0007c846                       ; add 1 to player lives
PANEL_INIT_ENERGY               EQU $0007c854                       ; initialise player energy to full value
PANEL_LOSE_LIFE                 EQU $0007c862                       ; sub 1 from player lives, check end game, set status bytes
PANEL_LOSE_ENERGY               EQU $0007c870                       ; reduce player energy (increase hit damage) D0.w = amount to lose
; Panel Constants - original data value addresses
PANEL_STATUS_1                  EQU $0007c874                       ; Game Status Bits
PANEL_STATUS_2                  EQU $0007c875                       ; Game Status Bits
PANEL_LIVES_COUNT               EQU $0007c876                       ; player lives left
PANEL_HISCORE                   EQU $0007c878                       ; hi-score BCD value
PANEL_SCORE                     EQU $0007c87c                       ; player score BCD value
PANEL_FRAMETICK                 EQU $0007c880                       ; counts down from 50 to 0 on each update
PANEL_TIMER_UPDATE_VALUE        EQU $0007c882                       ; Timer BCD update value
PANEL_TIMER_VALUE               EQU $0007c884                       ; Timer BCD value Min:Sec (word)
PANEL_TIMER_SECONDS             EQU $0007c885                       ; Timer BCD seconds value
PANEL_SCORE_UPDATE_VALUE        EQU $0007c886                       ; player score update value
PANEL_SCORE_DISPLAY_VALUE       EQU $0007c88a                       ; player score copy BCD value used for display
PANEL_ENERGY_VALUE              EQU $0007c88e                       ; player energy value (40 max value)
PANEL_HIT_DAMAGE                EQU $0007c890                       ; player hit damge (subtracted from player energy on each panel update)
; Panel Constants - resources
PANEL_GFX                       EQU $0007c89a                                                   ; main bottom display panel gfx
PANEL_BATMAN_GFX                EQU $0007e69a                                                   ; batman energy image
PANEL_JOKER_GFX                 EQU $0007ebba                                                   ; joker energy image
PANEL_SCORE_GFX                 EQU $0007f30a                                                   ; score digits gfx
PANEL_LIVES_ON_GFX              EQU $0007f374                                                   ; batman symbol - lives icon 'on'
PANEL_LIVES_OFF_GFX             EQU $0007f838                                                   ; batman symbol - lives icon 'off'
PANEL_DISPLAY_PIXELWIDTH        EQU $140                                                        ; 320 pixels wide
PANEL_DISPLAY_BYTEWIDTH         EQU PANEL_DISPLAY_PIXELWIDTH/8;                                 ; 40 bytes wide
PANEL_DISPLAY_LINEHEIGHT        EQU $30                                                         ; 48 Raster Lines High
PANEL_DISPLAY_BITPLANEBYTES     EQU PANEL_DISPLAY_BYTEWIDTH*PANEL_DISPLAY_LINEHEIGHT            ; 1920 bytes per bitplane
PANEL_DISPLAY_BITPLANEDEPTH     EQU $4                                                          ; 4 bitplanes - 16 colours
PANEL_DISPLAY_BYTESIZE          EQU PANEL_DISPLAY_BITPLANEBYTES*PANEL_DISPLAY_BITPLANEDEPTH
; Panel Status1 Bit Numbers
PANEL_ST1_TIMER_EXPIRED         EQU $0                                                          ; panel status 1 - bit 0 - Timer Expired
PANEL_ST1_NO_LIVES_LEFT         EQU $1                                                          ; panel status 1 - bit 1 - No Lives Remaining
PANEL_ST1_LIFE_LOST             EQU $2                                                          ; panel status 1 - bit 2 - Player Life Lost
; Panel Status1 Bit Values
PANEL_ST1_VAL_TIMER_EXPIRED     EQU 2^PANEL_ST1_TIMER_EXPIRED                                   ; panel status 1 - bit value/mask for Timer Expired
PANEL_ST2_VAL_NO_LIVES_LEFT     EQU 2^PANEL_ST1_NO_LIVES_LEFT                                   ; panel status 1 - bit value/mask for No Lives Left 
PANEL_ST2_VAL_LIFE_LOST         EQU 2^PANEL_ST1_LIFE_LOST                                       ; panel status 1 - bit value/mask for Life Lost 
; Panel_Status2 Bit Numbers
PANEL_ST2_MUSIC_SFX             EQU $0                                                          ; panel status 2 - bit 0 - Music/SFX selector bit
PANEL_ST2_GAME_OVER             EQU $5                                                          ; panel status 2 - bit 5 - Is Game Over
PANEL_ST2_LEVEL_COMPLETE        EQU $6                                                          ; panel status 2 - bit 6 - Is Level Complete
PANEL_ST2_CHEAT_ACTIVE          EQU $7                                                          ; panel status 2 - bit 7 - Is Cheat Active



; Code1 - Constants
;-------------------
STACK_ADDRESS                   EQU $0005a36c


CODE1_INITIAL_TIMER_BCD         EQU $0800                                                       ; BCD Vaue for 08:00 minutes
CODE1_DISPLAY_PIXELSWIDE        EQU $150                                                        ; 336 pixels wide
CODE1_DISPLAY_BYTESWIDE         EQU (CODE1_DISPLAY_PIXELSWIDE/8)                                ; 42 bytes wide
CODE1_DISPLAY_LINESHIGH         EQU $ae                                                         ; 174 raster lines high
CODE1_DISPLAY_BITPLANEBYTES     EQU (CODE1_DISPLAY_BYTESWIDE*CODE1_DISPLAY_LINESHIGH)           ; 7308 bytes per bitplane
CODE1_DISPLAY_BITPLANEDEPTH     EQU $4                                                          ; 4 bitplanes (16 colour display)

                                ; screen display double buffer
CODE1_DOUBLE_BUFFER_ADDRESS     EQU $00061b9c                                                   ; original address - start of double buffer display in memory
CODE1_DISPLAY_BUFFER_BYTESIZE   EQU CODE1_DISPLAY_BITPLANEBYTES*CODE1_DISPLAY_BITPLANEDEPTH;    ; size of each display buffer in bytes
CODE1_DOUBLE_BUFFER_BYTESIZE    EQU CODE1_DISPLAY_BUFFER_BYTESIZE*2                             ; size of double buffer display in bytes
CODE1_DISPLAY_BUFFER1_ADDRESS   EQU CODE1_DOUBLE_BUFFER_ADDRESS                                 ; Address $61b9c
CODE1_DISPLAY_BUFFER2_ADDRESS   EQU CODE1_DOUBLE_BUFFER_ADDRESS+CODE1_DISPLAY_BUFFER_BYTESIZE   ; Address $68dcc

                                ; off-screen display buffer (maybe used for composing the back buffer display)
CODE1_CHIPMEM_BUFFER            EQU $0005a36c                                                   ; original address  $5a36c - $6159c - (size = $7230 - 29,232 bytes)
CODE1_CHIPMEM_BUFFER_BYTESIZE   EQU CODE1_DISPLAY_BUFFER_BYTESIZE           

; Code1 - debug_print_word_value constants
FONT_8x8_HEIGHT     EQU         $8
ASCII_SPACE         EQU         $20

KEY_F1              EQU         $0081
KEY_F2              EQU         $0082
KEY_F10             EQU         $008a
KEY_ESC             EQU         $001b


;Chem.iff - Level Music - Constants
;----------------------------------
SFX_LEVEL_MUSIC     EQU         $01
SFX_LEVEL_COMPLETE  EQU         $02
SFX_LIFE_LOST       EQU         $03
SFX_TIMER_EXPIRED   EQU         $04
SFX_DRIP            EQU         $05
SFX_GASLEAK         EQU         $06
SFX_BATROPE         EQU         $07
SFX_BATARANG        EQU         $08
SFX_GRENADE         EQU         $09
SFX_GUYHIT          EQU         $0a
SFX_SPLASH          EQU         $0b
SFX_Ricochet        EQU         $0c
SFX_EXPLOSION       EQU         $0d


; MAPPGR.IFF
MAPGR_ADDRESS                   EQU $7FFC                                                       ; $7ffc - physical load address of MAPGR.IFF
MAPGR_START                     EQU MAPGR_ADDRESS+4                                             ; $8000 - data start address                                      
MAPGR_BASE                      EQU MAPGR_ADDRESS+6                                             ; $8002                                         ; 
MAPGR_BLOCK_PARAMS              EQU MAPGR_ADDRESS+6                                             ; $8002 - physical address of 'block size' and 'number of blocks' parameters
MAPGR_INIT                      EQU $0000807c

MAPGR_PREPROC_BLOCK_OFFSET      EQU $76                                                         ; 1st data block offset (data preprocessing step)


; BATSPR1.IFF
BATSPR1_ADDRESS                 EQU $10FFC                                                      ; $10FFC - physical load address of BATSPR1.IFF
BATSPR1_START                   EQU BATSPR1_ADDRESS+4                                           ; $11000 - data start address
BATSPR1_BASE                    EQU BATSPR1_ADDRESS+6                                           ; $11002 - 


                section code1,code_c
                ;org     $0                                          ; original load address


                ;--------------------- includes and constants ---------------------------
                INCDIR      "include"
                INCLUDE     "hw.i"
                opt         o-


start               ; added for testing (doesn't run yet!!!)
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
                    ; set initial level timer value
                    move.w  #CODE1_INITIAL_TIMER_BCD,d0
                    jsr     PANEL_INIT_TIMER
                    
                    bsr.w   clear_display_memory
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
                    ; ---- playfield display (scroll area) ---
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

                    ; ---- panel display (bottom score/energy etc) ----
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
L000034d0           dc.b    $00, $00, $00, $00, $00, $00, $00, $00
                    dc.b    $00, $00, $00, $00, $00, $00, $00, $00
                    dc.b    $00, $00, $00, $00, $00, $00, $00, $00
                    dc.b    $00, $00, $00, $00, $00, $00, $00, $00

                    even

                    ; Keyboard buffer index (where new keycodes are queued into)
keyboard_queue_head                     ; original address L000034f0
                    dc.w    $0000
                    ; Keyboard buffer index (where keycodes are dequeued from)
keyboard_queue_tail                     ; original address L000034f0                 
                    dc.w    $0000


                    ; A bitmap of the keys currently pressed on the keyboard
                    ; each bit records the key press or release status of the key.
                    ; range = $00 - $7f (16 bytes of bitmap data)
keyboard_bitmap                         ; original address $000034f4
                    dc.w    $0000, $0000, $0000, $0000
                    dc.w    $0000, $0000, $0000, $0000

                    ; extended bitmap for control keys (Function keys etc)
                    ; ascii codes $80-$ff
                    dc.w    $0000, $0000, $0000, $0000
                    dc.w    $0000, $0000, $0000, $0000





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
lvl_3_update_sound_player                                   ; original address $00003526
                    movem.l d1-d7/a0-a6,-(a7)
                    addq.w  #$01,frame_counter              ; increment frame counter - $000036ee 
                    jsr     AUDIO_PLAYER_UPDATE                   ; External Address - CHEM.IFF (music player) - $00048018 
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
                    movem.l d0-d7/a0-a6,-(a7)
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
                    seq.b   joy0_button1b           ; L00003645 ; Set Button 1 flag

                    ; joystick 1 counters
                    move.w  $00dff00c,d0            ; d0 = JOY1DAT
                    move.w  Joystick_1,d1           ; L00003632 ; d1 = last JOY1DAT
                    move.w  d0,Joystick_1           ; L00003632 ; store new JOY1DAT
                    bsr.b   calc_counter_deltas     ; L000035fa
                    move.b  d0,joy1_random          ; L0000363b ; d0 = random number $00 - $0f
                    add.w   d1,pot1_horizontal      ; L0000364c ; d1 = horizontal count delta
                    add.w   d2,pot1_vertical        ; 0000364e  ; d2 = vertical count delts
                    btst.b  #$0007,$00bfe001        ; Test Button 0
                    seq.b   joy1_button0            ; L0000363a ; Set Button 0 flag
                    seq.b   joy1_button0b           ; L0000364a ; Set Button 0 flag
                    btst.b  #$0006,$00dff016        ; test Button 1
                    seq.b   joy1_button1b           ; L0000364b ; Set Button 1 flag
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
random_lookup                                       ; original address L00003620
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

L00003638           dc.w $0000                      ; unreferenced word

joy1_button0                                        ; original address L0000363a
                    dc.b $00
joy1_random
                    dc.b $00   

L0000363c           dc.w $0000                      ; unreferenced word
L0000363e           dc.w $0000                      ; unreferenced word               
L00003640           dc.w $0000                      ; unreferenced word
L00003642           dc.w $0000                      ; unreferenced word

joy0_button0b                                       ; original address $00003644
                    dc.b $00
joy0_button1b
                    dc.b $00                        ; original address $00003645
pot0_horizontal
                    dc.w $0000                      ; original address $00003646 
pot0_vertical           
                    dc.w $0000                      ; original address $00003648
joy1_button0b
                    dc.b $00                        ; original address $0000364a
joy1_button1b
                    dc.b $00                        ; original address $0000364b
pot1_horizontal             
                    dc.w $0000
pot1_vertical
                    dc.w $0000              




                    ; -------------------- wait key --------------------
                    ; wait/loop until a key is pressed
                    ;
waitkey                                                 ; Address L00003650 not called directly from this code.
                    move.l  d0,-(a7)
.getkey             bsr.b   getkey                      ; d0 = ascii code (z = 1 if no key) L0000365a
                    bne.b   .getkey                     ; loop until a key is pressed
                    move.l  (a7)+,d0
                    rts



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
reset_display                                               ; original address $0000368a
                    move.w  #$0080,$00dff096                ; Disable Copper DMA
                    move.l  a0,$00dff080                    ; Set Copper List COP1LC
                    move.w  a0,$00dff088                    ; Strobe Copper (force start COPJMP1)
                    move.w  #$0000,$00dff10a                ; BPL2MOD - modulo
                    move.w  #$0000,$00dff108                ; BPL1MOD - modulp
                    move.w  #$0038,$00dff092                ; DDFSTRT - DMA Fetch Start
                    move.w  #$00d0,$00dff094                ; DDFSTOP - DMA Fetch Stop
                    move.w  #$3080,$00dff08e                ; DIWSTRT - Display Window Start Vertical Start = $30, Horizontal Start = $80 (320x218 window)
                    move.w  #$0ac0,$00dff090                ; DIWSTOP - Display Window Stop Vertical Stop = $10a, Horizontal Stop = $1c0
                    move.w  #$4200,$00dff100                ; BPLCON0 - 4 bitplane, colour display 
                    clr.w   frame_counter                   ; L000036ee
.wait_vbl
                    tst.w   frame_counter                   ; L000036ee
                    beq.b   .wait_vbl                       ; L000036dc ; wait for next vertb
                    move.w  #$8180,$00dff096              ; Enable - Copper DMA
                    rts 


frame_counter                                                       ; original address $000036ee
                    dc.w    $0000                                   ; incremeted every VERTB interrupt (level 3 interrupt handler)

target_frame_count                                                  ; original address $000036f0
                    dc.w    $0000                                   ; target frame count - (can be used to delay and wait for specific frame counter value)     

playfield_buffer_ptrs                                               ; original address $000036f2
playfield_buffer_1                                                  ; original address $000036f2
                    dc.l    CODE1_DISPLAY_BUFFER2_ADDRESS           ; double buffered playfield ptr 1 (current display by copper)
playfield_buffer_2                                                  ; original address $000036f6
                    dc.l    CODE1_DISPLAY_BUFFER1_ADDRESS           ; double buffered playfield ptr 2 (back buffer)




                    ; ----------------------- double buffer display playfield --------------------------
                    ; swap display buffer pointers and update the copper list display.
                    ; can wait for future frame count, typically waits for top of next frame.
                    ;
double_buffer_playfield                                             ; original addr: $000036fa
.wait_target_frame
                    move.w  frame_counter,d0
.wait_raster_tof   
                        cmp.w   frame_counter,d0
                        beq.b   .wait_raster_tof                    ; wait for top of next display frame
.chk_target_frame   
                    move.w  target_frame_count,d1
                    cmp.w   d0,d1
                    bpl.b   .wait_target_frame                      ; wait for target frame count (normally the next frame)

                    ; set target frame to current + 1
                    add.w   #$0001,d0
                    move.w  d0,target_frame_count

                    ; swap display buffer pointers                  ; original addr: $00003714
                    movem.l playfield_buffer_ptrs,d0-d1
                    exg.l   d0,d1
                    movem.l d0-d1,playfield_buffer_ptrs

                    ; set copper bitplane ptrs                      ; original address L00003722
                    lea.l   copper_playfield_planes+2,a0
                    move.l  #CODE1_DISPLAY_BITPLANEBYTES,d1 
                    moveq   #CODE1_DISPLAY_BITPLANEDEPTH-1,d7 
.next_bitplane
                    move.w  d0,(a0)                                 ; set copper bpl(x)ptl low word
                    addq.w  #$04,a0                                 ; increment copper ptr to bpl(x)pt high word
                    swap.w  d0
                    move.w  d0,(a0)                                 ; set copprt bpl(x)pth high word
                    addq.w  #$04,a0                                 ; increment copper ptr to next bpl(x)pt low word
                    swap.w  d0
                    add.l   d1,d0                                   ; calc next bitplane start address
                    dbf.w   d7,.next_bitplane

                    ; increment swap count
                    addq.w  #$01,playfield_swap_count
                    rts




                    ; ----------------------- clear display memory ---------------------------
                    ; Clear Double Buffer Display (back & front)
                    ; Clear Off-Screen Displaty Buffer
                    ;
clear_display_memory                                                        ; original address L00003746
                    ; clear double buffer display memory
                    lea.l   CODE1_DOUBLE_BUFFER_ADDRESS,a0
                    move.w  #(CODE1_DOUBLE_BUFFER_BYTESIZE/4)-1,d7       
.clr_loop_1
                    clr.l   (a0)+                                   ; clear 4 bytes
                    dbf.w   d7,.clr_loop_1

                    ; clear off-screen display buffer
                    lea.l   CODE1_CHIPMEM_BUFFER,a0
                    move.w  #CODE1_DISPLAY_BUFFER_BYTESIZE/4,d7
.clr_loop_2
                    clr.l   (a0)+                                   ; clear 4 bytes
                    dbf.w   d7,.clr_loop_2
                    rts 





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
debug_display_params                                                        ; original address L00003768
dp_xy_coords                                                                
                    dc.w $0a0a                                      ; location y,x (bytes) 
dp_ascii_string        
                    dc.b '0000',$00,$ff                             ; decoded ASCII string to display             

debug_print_word_value                                                      ; original address L00003770
                    lea.l   debug_display_params,a0
                    move.w  d1,(a0)                                 ; store display Y,X location.
                    moveq   #$03,d2                                 ; loop counter 3 + 1 (4 hex characters to decode for 16bit value)

.nibble_to_ascii    ; decode 4 nibbles to ASCII chars
                        clr.w   d1
                        move.w  d0,d1
                        and.w   #$000f,d1                           ; mask 4 bit value to decode (0-15)
                        cmp.w   #$000a,d1                           ; check d1 value
                        bcs.b   .digit0_9                           ; value < 10
.digit_a_f
                            addq.w  #$07,d1                         ; add ascii offset to char 'A' for value in range $a-$f
.digit0_9
                        add.b   #$30,d1                             ; add ascii offset to char '0' for all digits $0-$f
                        move.b  d1,$02(a0,d2.W)                     ; store ascii character for decoded hex digit
                        lsr.w   #$04,d0                             ; shift in next nibble to decode.
                    dbf.w   d2,.nibble_to_ascii
         
.calc_print_location ; calc destination display ptr                 ; original address - $00003798
                    move.b  (a0)+,d0                                ; get y co-ord value.
                    cmp.b   #$ff,d0                                 ; $ff = terminator value for exit.
                    beq.b   .exit                       

                    and.w   #$00ff,d0                               ; mask low byte value.
                    mulu.w  #PANEL_DISPLAY_BYTEWIDTH,d0
                    moveq   #$00,d1 
                    move.b  (a0)+,d1                                ; get x co-ord value (byte value)

                    add.w   d1,d0                                   ; d0 = x + y (print offset)
                    movea.l #PANEL_GFX,a1                           ; Panel GFX Address - $0007c89a.
                    lea.l   $02(a1,d0.w),a1                         ; a1 = display location.

.display_char       ; get char for display                          ; original address L000037b8
                    moveq   #$00,d0
                    move.b  (a0)+,d0
                    beq.b   .calc_print_location                    ; null terminator, could have exited here.
                    
                    ; calc source gfx ptr 
                    sub.w   #ASCII_SPACE,d0
                    lsl.w   #$03,d0                                 ; calc character GFX offset
                    lea.l   font8x8,a2                              ; 8x8 Character Font start address
                    lea.l   $00(a2,d0.w),a2                         ; source character GFX ptr

                    ; initialise print char loop
                    moveq   #FONT_8x8_HEIGHT-1,d7                   ; print_char_loop counter
                    movea.l a1,a3                                   ; gfx dest ptr copy

.print_char_loop    ; write gfx char to display - one raster line at a time
                    move.b  (a2),(a3)
                    move.b  (a2),PANEL_DISPLAY_BITPLANEBYTES(a3)
                    move.b  (a2),2*PANEL_DISPLAY_BITPLANEBYTES(a3)
                    move.b  (a2)+,3*PANEL_DISPLAY_BITPLANEBYTES(a3)
                    lea.l   PANEL_DISPLAY_BYTEWIDTH(a3),a3
                    dbf.w   d7,.print_char_loop

.next_char          ; set up next char for display                  ; original address L000037e8
                    lea.l   $0001(a1),a1                            ; increment destination ptr for display of next character
                    bra.b   .display_char                           ; display next char - L000037b8
.exit                                                               ; original address L000037ee
                    rts



                    ; -------------------------- 8x8 pixel font ----------------------
                    ; This font is used by the routine above.
                    incdir  ./gfx/
                    include font8x8.s
                    







                    ; 110 words, 220 bytes structure - cleared at game_start
                    ; there are values in here which are clears at game_start
L000039c8           dc.w    $0000
                    dc.w    $0119
                    dc.w    $003a
                    dc.w    $0097
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $00a0
                    dc.w    $0038
                    dc.w    $0046
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $00a0
                    dc.w    $0038
                    dc.w    $0046
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $00a0
                    dc.w    $0038
                    dc.w    $0046
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $00a0
                    dc.w    $0038
                    dc.w    $0046
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $00a0
                    dc.w    $0038
                    dc.w    $0046
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $00a0
                    dc.w    $0038
                    dc.w    $0046
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $00a0
                    dc.w    $0038
                    dc.w    $0046
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $00a0
                    dc.w    $0038
                    dc.w    $0046
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
L00003a8e           dc.w    $0000
                    dc.w    $00a0
                    dc.w    $0038
                    dc.w    $0046
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000


                    ; AXIS CHEMICAL FACTORY - Original Address L00003aa4
text_axis_chemicals
L00003aa4           dc.b    $50, $09                                    ; raster line (Y), byte offset (X)
                    dc.b    'AXIS '                                     ; $41, $58, $49, $53, $20
                    dc.b    'CHEMICAL '                                 ; $43, $48, $45, $4d, $49, $43, $41,$4c, $20
                    dc.b    'FACTORY'                                   ; $46, $41, $43, $54, $4f, $52, $59
                    dc.b    $00,$ff                                     ; Message Terminator

                    ; JACK IS DEAD - Original Address L00003abd
text_jack_is_dead
L00003abd           dc.b    $40, $0e                                    ; raster line (Y), byte offset (X)
                    dc.b    'JACK '                                     ; $4a, $41, $43, $4b, $20
                    dc.b    'IS '                                       ; $49, $53, $20
                    dc.b    'DEAD'                                      ; $44, $45, $41, $44 
                    dc.b    $00, $ff                                    ; Message Terminator

                    ; THE JOKER LIVES - Original Address L00003acd
text_the_joker_lives
L00003acd           dc.b    $60, $0b                                    ; raster line (Y), byte offset (X)
                    dc.b    'THE '                                      ; $54, $48, $45, $20
                    dc.b    'JOKER '                                    ; $4a, $4f, $4b, $45, $52, $20
                    dc.b    'LIVES... '                                 ; $4c, $49, $56, $45, $53, $2e, $2e, $2e
                    dc.b    $00, $ff                                    ; Message Terminator

                    even







                    ; ----------------------- start game ------------------------
                    ; Called after the system is initialised, initialise the
                    ; game level & play the game loop
                    ;
start_game                                                          ; original address $00003ae4
                    clr.l   frame_counter                           ; clear target_frame_count also
                    bsr.w   double_buffer_playfield 

                    bsr.w   preprocess_data                         ; preprocess level data

                    jsr     AUDIO_PLAYER_INIT
                    clr.w   L000062fc
                    jsr     PANEL_INIT_LIVES

                    ; restart point after batman dies
restart_level                                                       ; original address L00003b02
                    clr.w   L00006318
                    clr.l   frame_counter                           ; clear target_frame_count also
                    bsr.w   clear_display_memory
                    move.w  #CODE1_INITIAL_TIMER_BCD,d0
                    jsr     PANEL_INIT_TIMER 
                    jsr     PANEL_INIT_ENERGY

                    bsr.w   panel_fade_in

                    ; Some sort of map initialisaiton               ; original address L00003b24
                    lea.l   MAPGR_INIT,a0                           ; $0000807c,a0 - MAPGR.IFF
                    movea.l L00005f64,a5
L00003b30           movem.w (a5)+,d2-d4                             ; d2, d3 d4 (6 bytes), d3 = word index to $807c
                    tst.w   d3
                    beq.b   L00003b4e                               ; if d3 == 0 then exit loop
                    move.b  d2,$01(a0,d3.W)
                    lsr.w   #$08,d2
                    move.b  d2,$00(a0,d3.W)
                    move.b  d4,$03(a0,d3.W)
                    lsr.w   #$08,d4
                    move.b  d4,$02(a0,d3.W)
                    bra.b   L00003b30                               ; loop again

                    ; clear 40 longs (160 bytes)
                    ; data referenced by projectiles
                                                                    ; original address L00003b4e
L00003b4e           move.l  #$00005fc4,L00005f64
                    lea.l   L00004894,a0
                    moveq   #$27,d7                                 ; loop counter = #$27 + 1 = #$28 (40 in decimal)
.loop               clr.l   (a0)+                   
                    dbf.w   d7,.loop


                    ; clear MSB flag of each data structure
                                                                    ; original address L00003b64
clear_msb           lea.l   L0000642e,a0                
.loop               bclr.b  #$0007,(a0)                             ; clear MSB
                    move.w  $0004(a0),d0                            ; word at 4(a0) offset to next structure
                    mulu.w  #$0006,d0 
                    lea.l   $06(a0,d0.W),a0
                    cmpa.l  L00006722,a0
                    bcs.b   .loop


                    ; clear MSB flag of each data structure
L00003b7e                                                           ; original address                    
.loop               bclr.b  #$0007,$0004(a0)
                    addq.w  #$06,a0                                 ; start of next data structure
                    cmpa.l  default_level_parameters,a0
                    bcs.b   .loop


                    ; clear 110 words (220 bytes) starting @ L000039c8
                                                                    ; original address L00003b8c
L00003b8c           lea.l   L000039c8,a0
                    moveq   #$6d,d7                                 ; counter = #$6d + 1 = #$6e (110 decimal) (220 bytes)
.loop
                    clr.w   (a0)+
                    dbf.w   d7,.loop


                    ; Set initial batman sprite ids
                                                                    ; original address L00003b98
L00003b98           clr.w   batman_sprite1_id
                    lea.l   L000063d3,a0
                    bsr.w   set_batman_sprites


                    ; copy 7 words init data
                    ; L000062fc has to be 0, or the routine will overwrite code.
                                                                    ; original address L00003ba4
L00003ba4           move.l  #player_move_commands,gl_jsr_address    ; L00003c90 ; Set Self Modifying code - GameLoop JSR - L00003c92                                                      
                    lea.l   default_level_parameters,a0             ; L000067a0,a0
                    move.w  L000062fc,d6                            ; cleared above on line number L00003af8
.outer_loop                                                         ; original address L00003bb2
                    moveq   #$06,d7                                 ; counter #$6 + 1 = #$7
                    lea.l   level_parameters,a1                     ; L000067bc,a1
.inner_loop                                                         ; original address L00003bb8
                    move.w  (a0)+,(a1)+
                    dbf.w   d7,.inner_loop                          ; loop 7 times
                    dbf.w   d6,.outer_loop                          ; loop 0 times (d6 has to be 0, or code is overwritten) 

                    ; display level title 'Axis Chemical Factory'
L00003bc2           lea.l   text_axis_chemicals,a0
L00003bc6           bsr.w   large_text_plotter
L00003bca           bsr.w   double_buffer_playfield   

L00003bce           bsr.w   L000058aa                               ; display 'Axis Chemicals'

L00003bd2           bsr.w   draw_level_and_actors                   ; L00004b62                               

L00003bd6           bsr.w   draw_batman_and_rope                    ; L000055c4

L00003bda           moveq   #$32,d0
L00003bdc           bsr.w   wait_for_frame_count                    ; L00005e8c

L00003be0           btst.b  #PANEL_ST2_MUSIC_SFX,PANEL_STATUS_2     ; Panel - Status 2 Bytes - bit #$0000 of $0007c875 
L00003be8           bne.b   sfx_only                                ; L00003bf2
L00003bea           moveq   #$01,d0                                 ; song number - 01 = level music
L00003bec           jsr     AUDIO_PLAYER_INIT_SONG                        ; chem.iff - music/sfx - initialise song (d0 = song number) $00048010 ; External Address $48010 - CHEM.IFF

sfx_only                                                            ; original address L00003bf2
                    bsr.w   screen_wipe_to_backbuffer               ; L00003cc0 ; Wipe 'Axis Chemical' -> Show Playfield


L00003bf6           clr.l   frame_counter                           ; NB: Long Clear - clears next word also -L000036ee





                    ; -----------------------------------------------------------------------------------------------------------
                    ;
                    ; Game Loop
                    ;
                    ; -----------------------------------------------------------------------------------------------------------
game_loop                                                               ; original address $00003bfa


                    ; ---------- Start Key press checks -----------
                    ;
                    ; 'F1'  -  Pause Game
                    ;           1) when paused 'ESC' = exit game
                    ;           2) any other key resumes the game
                    ; 'F2'  - Toggle Music/SFX
                    ; 'F10' - Skip Level (if cheat mode is active)
                    ;
start_of_key_checks
                    bsr.w   getkey                                      ; d0 = ascii code (0 =  no key pressed)
                    beq.b   end_of_key_checks
.test_pause_game_f1
                        cmp.w   #KEY_F1,d0                              ; Test for Key = 'F1'
                        bne.b   .test_toggle_music_f2                    
.gl_pause_game_loop
                            bsr.w   getkey                  
                            beq.b   .gl_pause_game_loop 

                            cmp.w   #KEY_ESC,d0                         ; Test for Key = 'ESC'
                            bne.b   .test_toggle_music_f2
.exit_game
                                bsr.w   screen_wipe_to_black
                                bset.b  #PANEL_ST2_GAME_OVER,PANEL_STATUS_2
                                bra.w   return_to_title_screen 
                                ; ***************************                 
                                ; ****** NEVER RETURNS ******
                                ; **** LOAD TITLE SCREEN ****
                                ; ***************************

.test_toggle_music_f2
                        cmp.w   #KEY_F2,d0                              ; Test for Key = 'F2'
                        bne.b   .test_level_skip_f10
.toggle_music_sfx
                            bchg.b  #PANEL_ST2_MUSIC_SFX,PANEL_STATUS_2
                            bne.b   .init_music
.init_sfx
                                jsr     AUDIO_PLAYER_INIT_SFX_1
                                bra.w   end_of_key_checks
.init_music
                                moveq   #SFX_LEVEL_MUSIC,d0
                                jsr     AUDIO_PLAYER_INIT_SONG
                                bra.w   end_of_key_checks

.test_level_skip_f10
                        cmp.w   #KEY_F10,d0                              ; Test for key = 'F10'
                        bne.b   end_of_key_checks
.skip_level
                            btst.b  #PANEL_ST2_CHEAT_ACTIVE,PANEL_STATUS_2
                            bne.w   Load_level_2
                            ; ***************************                 
                            ; ****** NEVER RETURNS ******
                            ; ****** LOAD LEVEL 02 ******
                            ; ***************************

                    ; --------- End of Key Press Checks ---------
end_of_key_checks



gl_update_state_machine
                    btst.b  #PANEL_ST1_TIMER_EXPIRED,PANEL_STATUS_1         ; Test Timer has expired
                    bne.b   L00003c80
.timer_not_expired
                        jsr     PANEL_UPDATE
                        jsr     PANEL_UPDATE
                        btst.b  #PANEL_ST1_TIMER_EXPIRED,PANEL_STATUS_1     ; Test Timer has expired 
                        beq.b   L00003c80
.timer_still_not_expired
                            moveq   #$01,d6
                            bsr.w   update_self_modified_code_ptr           ; update state machine?


L00003c80           clr.l   d0
L00003c82           clr.l   d1
L00003c84           bsr.w   L00005854
L00003c88           movem.w L000067c2,d0-d1


                    ; ----- SELF MODIFYING CODE -----
                    ; updated all over the place to run an alternative routine.
                    ; a bit of a state machine kinda update routine.
L00003c8e           dc.w    $4eb9                           ; jsr - opcode (jsr     L00004c3e)
gl_jsr_address                                              ; original address L00003c90
L00003c90           dc.l    $00004c3e                       ; Self Modified Address  
                    ; ----- END OF SELF MODIFYING CODE -----

L00003c94           bsr.w   update_view_window                      ; L00004936 ; Scroll Background Window (not draw that's later)
L00003c98           bsr.w   update_score_by_distance_walked         ; L00003dd4 ; Update Scre based upon comparison of $67bc.w and $67c0.w 
L00003c9c           bsr.w   update_level_actors_01                  ; L00003dfe ; Update Level Actors 01
L00003ca0           bsr.w   draw_level_and_actors                   ; L00004b62 ; Draw/Update Screen
L00003ca4           bsr.w   draw_batman_and_rope                    ; L000055c4 ; Draw Batman and Rope Swing
L00003ca8           bsr.w   update_level_actor_02                   ; L00003ee6 ; Update Level Actors 02
L00003cac           bsr.w   update_projectiles                      ; L00004658 ; Update Projectiles (Bombs, Bullets, Batarang)
L00003cb0           bsr.w   draw_projectiles                        ; L000045fe ; Draw Projectiles (Bombs, Buttles, Batarang)
L00003cb4           bsr.w   double_buffer_playfield                 ; L000036fa

L00003cb8           bra.w   game_loop                               ; L00003bfa ; jump back to main loop

                    ;-----------------------------------------------------
                    ;------------------ End of Game Loop -----------------
                    ;-----------------------------------------------------




                    ; Wipe Screen to Black
screen_wipe_to_black                                        ; original address L00003cbc
L00003cbc           bsr.w   clear_backbuffer_playfield      ; L00004e28
                    ; Wipe Screen to Back buffer?
screen_wipe_to_backbuffer                                   ; original address L00003cc0
L00003cc0           move.w  #$002a,d0
L00003cc4           move.w  #$00ae,d1
L00003cc8           movem.l playfield_buffer_ptrs,a0-a1     ; L000036f2,a0-a1
L00003cce           clr.w   d2
wipe_outer_loop
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
wipe_middle_loop                                                 ; original address L00003cf8
L00003cf8           move.w  d4,-(a7)
L00003cfa           moveq   #$03,d2
L00003cfc           move.w  $0002(a7),d6
L00003d00           cmp.w   #$1580,d6
L00003d04           bcs.b   L00003d08
L00003d06           moveq   #$01,d2
wipe_inner_loop                                                 ; original address L00003d08
L00003d08           move.b  d5,d6
L00003d0a           not.w   d6
L00003d0c           and.b   $00(a0,d4.W),d6
L00003d10           move.b  d6,$00(a0,d4.W)
L00003d14           move.b  d5,d6
L00003d16           and.b   $00(a1,d4.W),d6
L00003d1a           or.b    $00(a0,d4.W),d6
L00003d1e           move.b  d6,$00(a0,d4.W)
L00003d22           add.w   d0,d4
L00003d24           dbf.w   d2,wipe_inner_loop                  ; L00003d08

L00003d28           move.w  (a7)+,d4
L00003d2a           add.w   d3,d4
L00003d2c           dbf.w   d7,wipe_middle_loop                  ; L00003cf8

L00003d30           move.w  (a7)+,d2
L00003d32           mulu.w  #$5555,d2
L00003d36           addq.w  #$01,d2
L00003d38           and.w   #$1fff,d2
L00003d3c           bne.b   wipe_outer_loop                     ; L00003cd0
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




panel_fade_out                                              ; original address L00003d8c
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



                    ;--------------------------------------------------------------------------------------------------------
                    ;  update score by distance walked
                    ;--------------------------------------------------------------------------------------------------------     
                    ; Updated the score based on the distance travelled through the level.
                    ;
                    ;
                    ; called from game_loop every cycle.
                    ; Adding a value to the score based upon the value held in $67bc compared with $67c0 (batman_distance_walked).
                    ;
                    ; when $67bc.w is greater than $67bc.w then no score is added.
                    ; else
                    ;       take the value ($67bc.w * 16)
                    ;       Add 100 to the score for every multiple of #$64
                    ;
update_score_by_distance_walked                                     ; original address $00003dd4
                    clr.l   d0                                      ; clear score update value
                    move.w  updated_batman_distance_walked,d1
                    sub.w   batman_distance_walked,d1               ; L000067c0,d1
                    bls.b   .exit                                   ; if ($67c0 > $67bc) then exit

.do_update_score                                                    ; original address L00003de0
                    move.w  updated_batman_distance_walked,batman_distance_walked        ; else ($67c0 <= $67bc) so, copy $67bc into $67c0
                    lsl.w   #$04,d1                                 ; d1 = d1 * 16 (multiple difference in distance by 16)
                    move.b  d1,d0                                   ; copy d1 into d0 (low byte) - set initial score update value
                    bra.b   .do_increase_score                       

.increase_score_loop                                                ; original address L00003dec
                    add.w   #$0100,d0
.do_increase_score                                                  ; original address L00003df0
                    sub.w   #$0064,d1                               ; subtract 64 from d1 (distance * 16)
                    bcc.b   .increase_score_loop                    ; for every multiple of #$64, add 100 to the score.
.update_score_value                                                 ; original address L00003df6
                    jmp     PANEL_ADD_SCORE                         ; Panel Add Player Score (D0.l BCD value to add)- $0007c82a
.exit                                                               ; original address L00003dfc
                    rts     



                    ;---------------------------------------------------------------------------------------
                    ; -- Update Level Actors - Routine 01
                    ;---------------------------------------------------------------------------------------
                    ; If this routine is not executed then the level has not active actors displayed on it.
                    ;---------------------------------------------------------------------------------------
update_level_actors_01                                              ; original address L00003dfe
L00003dfe           movem.w level_parameters,d0-d1                  ;  L000067bc,d0-d1 (updated_batman_distance_walked,unknown)
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




                    ;-----------------------------------------------------------------------------------------------
                    ; -- Update Level Actors 02
                    ;-----------------------------------------------------------------------------------------------
                    ; If this routine is skipped then the level is empty of any actors.
                    ;
update_level_actor_02                                       ; original address L00003ee6
L00003ee6           lea.l   L000039c8,a6
L00003eea           moveq   #$09,d7
L00003eec           move.w  (a6),d6
L00003eee           beq.w   L00003fa8
L00003ef2           movem.w $0002(a6),d0-d1
L00003ef8           move.w  d0,d4
L00003efa           movem.w level_parameters,d2-d3          ; L000067bc,d2-d3 (updated_batman_distance_walked,unknown)
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
L00003f80           moveq   #SFX_GUYHIT,d0
L00003f82           jsr     AUDIO_PLAYER_INIT_SFX
L00003f88           move.w  #$fffe,$000a(a6)
L00003f8e           tst.w   L000062fa
L00003f92           bmi.b   L00003fa6
L00003f94           tst.w   L00006318
L00003f98           beq.b   L00003fa0
L00003f9a           tst.w   L000062f4
L00003f9e           bne.b   L00003fa6
L00003fa0           moveq   #$05,d6                         ; Value of Energy to Lose (5 of 48)
L00003fa2           bsr.w   batman_lose_energy
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
L00003ffe           moveq   #SFX_GRENADE,d0
L00004000           jsr     AUDIO_PLAYER_INIT_SFX
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
L00004172           move.w  MAPGR_BASE,d2        ; MAPGR.IFF (Value = $00c0)
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
L00004384           btst.b  #$0000,playfield_swap_count+1           ; test even/odd playfield buffer swap value
L0000438a           bne.b   L000043ce
L0000438c           addq.w  #$01,d4
L0000438e           move.w  d4,$0004(a6)
L00004392           addq.w  #$01,d1
L00004394           and.w   #$0007,d4
L00004398           bne.b   L000043ce
L0000439a           bsr.w   L000055a0
L0000439e           bra.b   L000043c6
L000043a0           move.w  $0004(a6),d4
L000043a4           btst.b  #$0000,playfield_swap_count+1           ; test even/odd playfield buffer swap value
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
L00004448           btst.b  #$0000,playfield_swap_count+1           ; test even/odd playfield buffer swap value
L00004450           bne.b   L00004442
L00004452           bsr.w   L0000463e
L00004456           sub.w   (a5)+,d1
L00004458           add.w   L00006310,d1
L0000445c           add.w   (a5)+,d0
L0000445e           add.w   L0000630e,d0
L00004462           move.w  (a5),(a0)+
L00004464           movem.w d0-d1,(a0)
L00004468           moveq   #SFX_Ricochet,d2
L0000446a           bsr.w   play_proximity_sfx                      ; play sfx if d0 < 160 & d1 < 89
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


                    ; ------------------- play proximity sfx ---------------------
                    ; Play SFX if X & Y co-ordinates within range
                    ; IN:-
                    ;   d0.w = probably X distance
                    ;   d1.w = probably Y distance
                    ;   d2 = sfx number to play 5 - 13
play_proximity_sfx                                                  ; original address L000044b6
                    cmp.w   #$00a0,d0
                    bcc.b   .exit
                    cmp.w   #$0059,d1
                    bcc.b   .exit
                    movem.w d0-d1,-(a7)
                    move.w  d2,d0                                   ; d0 = sfx number to play
                    jsr     AUDIO_PLAYER_INIT_SFX       
                    movem.w (a7)+,d0-d1
.exit           
                    rts


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


; core to game object updates
; when not executed, the game does not run.
L00004570           move.w  $000a(a6),d2        ; $00dff00a
L00004574           mulu.w  #$000c,d2
L00004578           lea.l   L00004510(pc,d2.W),a5        ; $00004510     (warning 2069: encoding absolute displacement directly)
L0000457c           move.w  (a5)+,d2
L0000457e           bsr.b   L0000458a
L00004580           move.w  (a5)+,d2
L00004582           bsr.b   L000045bc
L00004584           move.w  (a5)+,d2
L00004586           bne.b   L000045bc
L00004588           rts 


; draw bad guy head/sprite 1
L0000458a           add.w   $0006(a6),d2        ; $00dff006
L0000458e           move.w  d2,d3
L00004590           and.w   #$1fff,d3           ; clamp value to max $1fff
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
L000045b2           bsr.w   draw_sprite         ; draw top/head of bad guy  ; L000056f4
L000045b6           movem.w (a7)+,d0-d1/a5-a6
L000045ba           rts 


L000045bc           add.w   $0006(a6),d2        ; $00dff006
L000045c0           movem.w d0-d1/a5-a6,-(a7)
L000045c4           bsr.w   draw_sprite
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




                    ;----------------------------------------------------------------------------------------------
                    ; Draw Projectiles (bombs, bullets, batarang)
                    ;----------------------------------------------------------------------------------------------
                    ; draws the projectiles on the screen 
                    ;  - bombs
                    ;  - bullets
                    ;  - player's batarang 
                    ;  - end of bat-rope
                    ;
                    ; L00004894 - 8 byte structure (20 active projectiles?)
                    ;
draw_projectiles                                    ; original address L000045fe
L000045fe           lea.l   L00004866,a5
                    lea.l   L00004894,a6            ; list cleared at game_start
                    moveq   #$13,d7                 ; d7 = 19 + 1 - counter
.loop                                               ;                   original address L00004608
                    move.w  (a6)+,d2                ; get 2 bytes - active projectile?
                    beq.b   .skip_to_next           ; if d2 == 0 then skip_to_next - L00004636

                    movem.w (a6),d0-d1              ; get next 4 bytes from data struct.
                    move.l  a6,-(a7)                ; store data ptr - a6   
                    move.w  d7,-(a7)                ; store counter
                    btst.l  #$000f,d2               ;   test is d2 -ve?
                    beq.b   .is_pos_01              ; L00004622               ;     is +ve then jmp L00004622
.is_neg_01                                          ;   else -ve
                    ext.w   d2                      ;     sign extend byte to word
                    move.w  d2,-$0002(a6)           ;     overwrite word back in data structure
                    moveq   #$04,d2                 ;     set d2 = #$04
.is_pos_01
                    ror.w   #$01,d2                 ;   rotate bits right by 1
                    bpl.b   .not_neg_02             ;   L0000462a               ;   test is d2 +ve                                                  
                    or.w    #$e000,d2               ;     is -ve set top 3 bits.
.not_neg_02
                    add.w   #$003b,d2               ;     is +ve, add 59 to d2
                    bsr.w   draw_sprite             ; Draw projectile sprite - L000056f4
                                                    ; bullets, bombs, batarang, grappling hook
                    move.w  (a7)+,d7                ; restore counter - d7
                    movea.l (a7)+,a6                ; restore data ptr - a6
.skip_to_next
                    addq.w  #$06,a6                 ; a6 + 6 (start next structure in list)     
                    dbf.w   d7,.loop                ; L00004608
                    rts


L0000463e           lea.l   L00004894,a0
L00004642           moveq   #$13,d7
L00004644           tst.w   (a0)
L00004646           beq.b   L00004656
L00004648           lea.l   $0008(a0),a0        ; $00000a08
L0000464c           dbf.w   d7,L00004644
L00004650           movea.l #$fffffff8,a0
L00004656           rts



                    ;-------------------------------------------------------------------------------------
                    ; -- Update the Projectiles (bombs, bullets, player's batarang)
                    ;-------------------------------------------------------------------------------------
                    ; update projectiles on the level, including the player's projectiles
                    ; it does not draw them..
                    ;
update_projectiles                                  ; original address L00004658
                    lea.l   L00004866,a5
                    lea.l   L00004894,a6
                    moveq   #$13,d7                 ; 19 + 1 - loop counter
.update_loop
                    move.w  (a6)+,d6                ; d6 = 1 based index into address jmp table L00004866
                    beq.b   .L0000467e
                    movem.w (a6),d0-d1
                    sub.w   L0000630e,d0
                    sub.w   L00006310,d1
                    ;asl.w   #$01,d6                ; multiply d6 * 2
                    asl.w   #$02,d6                 ; multiply d6 * 4 (modified address table to 32 bit addresses)
                    clr.l   d2                      ; clear d2
                    movea.l d2,a0                   ; clear a0
                    ;movea.w -$2(a5,d6.W),a0        ; $fe(a5,d6.W),a0
                    movea.l -$4(a5,d6.W),a0         ; $fe(a5,d6.W),a0 (modified address table to 32 bit addresses)
                    jsr     (a0)
.L0000467e          addq.w  #$06,a6                 ; addaq.w
                    dbf.w   d7,.update_loop         ; L00004662
                    rts


badguy_shooting
L00004686           movem.w d0-d1,(a6)
L0000468a           bsr.w   L000055a0
L0000468e           cmp.b   #$17,d2
L00004692           bcs.b   L000046ba
L00004694           sub.w   L000067c2,d0
L00004698           addq.w  #$04,d0
L0000469a           cmp.w   #$0009,d0
L0000469e           bcc.b   exit_badguy_shooting            ; L000046c0
L000046a0           cmp.w   L000067c4,d1
L000046a4           bpl.b   exit_badguy_shooting            ; L000046c0
L000046a6           cmp.w   L000062f0,d1
L000046aa           bmi.b   exit_badguy_shooting            ; L000046c0
batman_shot
L000046ac           moveq   #$01,d6                         ; Value of Energy to Lose (1 of 48)
L000046ae           bsr.w   batman_lose_energy
L000046b2           moveq   #SFX_GUYHIT,d0
L000046b4           jsr     AUDIO_PLAYER_INIT_SFX
L000046ba           move.w  #$0004,-$0002(a6)
exit_badguy_shooting   
L000046c0           rts



L000046c2           subq.w  #$03,d0
L000046c4           cmp.w   #$fff6,d0
L000046c8           bmi.b   L00004722
L000046ca           subq.w  #$03,d1
L000046cc           cmp.w   #$0058,d1
L000046d0           bcs.b   badguy_shooting                 ; L00004686
L000046d2           bra.b   L00004722

L000046d4           addq.w  #$03,d0
L000046d6           cmp.w   #$00a8,d0
L000046da           bpl.b   L00004722
L000046dc           subq.w  #$03,d1
L000046de           cmp.w   #$0058,d1
L000046e2           bcs.b   badguy_shooting                 ; L00004686
L000046e4           bra.b   L00004722

L000046e6           subq.w  #$03,d0
L000046e8           cmp.w   #$fff6,d0
L000046ec           bmi.b   L00004722
L000046ee           addq.w  #$03,d1
L000046f0           cmp.w   #$0058,d1
L000046f4           bcs.b   badguy_shooting                 ; L00004686
L000046f6           bra.b   L00004722

L000046f8           addq.w  #$03,d0
L000046fa           cmp.w   #$00a8,d0
L000046fe           bpl.b   L00004722
L00004700           addq.w  #$03,d1
L00004702           cmp.w   #$0058,d1
L00004706           bcs.w   badguy_shooting                 ; L00004686
L0000470a           bra.b   L00004722

L0000470c           subq.w  #$05,d0
L0000470e           cmp.w   #$fff6,d0
L00004712           bpl.w   badguy_shooting                 ; L00004686
L00004716           bra.b   L00004722

L00004718           addq.w  #$05,d0
L0000471a           cmp.w   #$00a8,d0
L0000471e           bmi.w   badguy_shooting                 ; L00004686
L00004722           clr.w   -$0002(a6)
L00004726           rts


L00004728           addq.w  #$04,d0                     ; batman fire right
L0000472a           cmp.w   #$00a8,d0
L0000472e           bpl.b   L00004722
L00004730           bsr.w   L000055a0
L00004734           cmp.b   #$17,d2
L00004738           movem.w d0-d1,(a6)
L0000473c           bcc.b   L0000477e
L0000473e           bcs.b   L00004722

L00004740           subq.w  #$04,d0                     ; batman fire left
L00004742           cmp.w   #$fff6,d0
L00004746           bmi.b   L00004722
L00004748           bsr.w   L000055a0
L0000474c           cmp.b   #$17,d2
L00004750           movem.w d0-d1,(a6)
L00004754           bcc.b   L0000477e
L00004756           bra.b   L00004722

L00004758           move.w  L00006318,d0                ; batman grappling hook
L0000475c           beq.b   L00004722
L0000475e           movem.w L000067c2,d0-d1
L00004764           add.w   L0000631a,d0
L00004768           sub.w   L0000631c,d1
L0000476c           sub.w   #$000c,d1
L00004770           addq.w  #$05,d0
L00004772           tst.w   batman_sprite1_id           ; L000062ee
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
L000047bc           moveq   #SFX_GUYHIT,d0
L000047be           jmp     AUDIO_PLAYER_INIT_SFX
                    ; use rts in audio player to return


L000047c4           addq.w  #$02,d0                     ; badguy - grenade right
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
L0000481a           moveq   #SFX_EXPLOSION,d2
L0000481c           bra.w   play_proximity_sfx              ; play sfx if d0 > 160 & d1 >89 
L00004820           rts



L00004822           subq.w  #$02,d0                         ; bad guy - grenade left
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
L00004848           btst.b  #$0000,playfield_swap_count+1   ; test even/odd playfield buffer swap value
L0000484e           bne.b   L00004864
L00004850           move.w  -$0002(a6),d2                   ; get projectile handler index
L00004854           addq.w  #$01,d2                         ; increment projectile handler index
L00004856           cmp.w   #$0018,d2                       ; compare 24 with projectile handler index
L0000485a           bne.w   L00004860
L0000485e           clr.w   d2                              ; clear projectile handler index
L00004860           move.w  d2,-$0002(a6)                   ; store handler index
L00004864           rts



                    ; addresses for Projectile processing JMP Table
                    ; referenced by draw_projectiles
                    ; modified for 32 bit addresses -  24 entries
L00004866           dc.l    L00004758               ; batman grappling hook
                    dc.l    L00004728               ; batman fire right
                    dc.l    L00004740               ; batman fire left
                    dc.l    L00004740               ; batman fire left
                    dc.l    L00004722               ; clr.w   -$0002(a6), RTS
                    dc.l    L00004722               ; clr.w   -$0002(a6), RTS
                    dc.l    L00004718               ; Bad Guy Shooting
                    dc.l    L0000470c               ; Bad Guy Shooting
                    dc.l    L000046f8               ; Bad Guy Shooting
                    dc.l    L000046e6               ; Bad Guy Shooting
                    dc.l    L000046d4               ; Bad Guy Shooting
                    dc.l    L000046c2               ; Bad Guy Shooting
                    dc.l    L000047c4               ; Grenade Right
                    dc.l    L00004822               ; Grenade Left
                    dc.l    L00004844               ; runs while grenade explosion is displayed?
                    dc.l    L00004844               ; runs while grenade explosion is displayed?
                    dc.l    L00004844               ; runs while grenade explosion is displayed?
                    dc.l    L00004844               ; runs while grenade explosion is displayed?
                    dc.l    L00004844               ; runs while grenade explosion is displayed?
                    dc.l    L00004844               ; runs while grenade explosion is displayed?
                    dc.l    L00004844               ; runs while grenade explosion is displayed?
                    dc.l    L00004844               ; runs while grenade explosion is displayed?
                    dc.l    L00004844               ; runs while grenade explosion is displayed?
                    dc.l    L00004844               ; runs while grenade explosion is displayed?

                    ; original data (16 bit address pointers) - 24 entries
;L00004866           dc.w    $4758, $4728, $4740, $4740, $4722, $4722, $4718, $470c
;                    dc.w    $46f8, $46e6, $46d4, $46c2, $47c4, $4822, $4844, $4844
;                    dc.w    $4844, $4844, $4844, $4844, $4844, $4844, $4844, $4844


                    ; referenced by L0000463e
                    ; referenced by update_projectiles
                    ; referenced by draw_projectiles
                    ; referenced & (40 longs cleared) during game_start / level initialisation 
                    ; 4 word structure.
                    ;
L00004894           
.entry_01           dc.w    $0000           ; Jmp Table Index (1-24)
                    dc.w    $0000           ; D0 - Parameter 1
                    dc.w    $0000           ; D1 - Parameter 2
                    dc.w    $0000           ; Unused

.entry_02           dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000

.entry_03           dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000

.entry_04           dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000

.entry_05           dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000

.entry_06           dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000

.entry_07           dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000

.entry_08           dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000

.entry_09           dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000

.entry_10           dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000

.entry_11           dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000

.entry_12           dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000

.entry_13           dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000

.entry_14           dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000

.entry_15           dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000

.entry_16           dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000

.entry_17           dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000

.entry_18           dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000

.entry_19           dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000

.entry_20           dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000
                    dc.w    $0000



                    ; -------------------------------------------------------------------------------------------
                    ; -- Update the View Window
                    ;--------------------------------------------------------------------------------------------
                    ; This routine updates the view into the background level.
                    ; It does not draw the background graphics.
                    ; It scrolls the view window around, following the player (i.e. the view camera)
                    ; It may do other things also, haven't analysed in depth yet.
                    ;--------------------------------------------------------------------------------------------
L00004934           dc.w    $0000                       ; referenced as word below

update_view_window                                      ; original address $00004936
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
L0000495c           cmp.w   #$fffd,d0               ; -3
L00004960           bcc.b   L00004980
L00004962           bpl.b   L00004968
L00004964           MOVE.L  #$fffffffe,D0           ; d0 = -2
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
L0000497e           MOVE.L  #$fffffffd,D0           ; d0 = -3

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
L000049cc           bsr.w   draw_background_screen_vertical         ; L00004a5e
L000049d0           bra.w   L000049ec
L000049d4           move.w  L00006312,d2
L000049d8           add.w   d1,d2
L000049da           bpl.b   L000049e0
L000049dc           add.w   #$0057,d2
L000049e0           move.w  d2,L00006312
L000049e4           add.w   d1,d3
L000049e6           neg.w   d1
L000049e8           bsr.w   draw_background_screen_vertical         ; L00004a5e

L000049ec           move.w  L000067c2,d0
L000049f0           sub.w   L000067c8,d0
L000049f4           move.w  d0,L0000630e
L000049f8           beq.w   L00004a5c
L000049fc           move.w  L000067bc,d1                            ; updated_batman_distance_walked
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
L00004a24           move.w  d1,L000067bc                        ; updated_batman_distance_walked
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
L00004a58           bsr.w   draw_background_screen_horizontal   ; L00004ad6
L00004a5c           rts  


; draw background screen blocks for Vertical Scroll
draw_background_screen_vertical
L00004a5e           subq.w  #$01,d1
L00004a60           move.w  d3,d4
L00004a62           and.w   #$0007,d4
L00004a66           asl.w   #$04,d4
L00004a68           move.b  d4,L00004aa1
L00004a6e           move.w  d3,d4
L00004a70           lsr.w   #$03,d4
L00004a72           lea.l   MAPGR_BASE,a0            ;  MAPGR.IFF (addr $8002)
L00004a78           mulu.w  (a0),d4
L00004a7a           move.w  L000067bc,d0                        ; updated_batman_distance_walked
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



; draw background screen blocks for Horizonal Scroll
; a4 = destination chipmemptr, 
; d1 = source pixel offset, d7 = counter
; L0000630a = base gfx ptr $0000A07C 
draw_background_screen_horizontal
L00004ad6           movea.l L0000630a,a2        ; a2 = src gfx address (sprite sheet?)

                    ; d1 = source gfx offset value
L00004ada           move.w  d1,d2               ; d1, d2 = source gfx offset value 
L00004adc           lsr.w   #$03,d2             ; d2 = source gfx byte offset

L00004ade           move.w  L000067be,d1        ; d1 = $00f0            - source x/y of gfx?
L00004ae2           move.w  d1,d0               ; d0 = $00f0
L00004ae4           and.w   #$0007,d0           ; mask low 3 bits (0-7)
L00004ae8           move.w  d0,d5               ; d0, d5 = low 3 bits
L00004aea           not.w   d5
L00004aec           and.w   #$0007,d5

                    
L00004af0           lsl.w   #$04,d0             ; d0 = multiply by 16

                    ; d1 = Y source co-ord (source gfx)
                    ; d2 = X byte co-ord (source gfx)
L00004af2           lsr.w   #$03,d1             ; d1 = divide by 8 (d1 = $0f)
L00004af4           lea.l   MAPGR_BASE,a0       ; MAPGR.IFF (addr $8002)
L00004afa           move.w  (a0),d4             ; d4 = source gfx width (192 bytes? 48 bytes per plane interleaved? 384 pixels wide)
L00004afc           mulu.w  d4,d1               ; d1 = d1 * width
L00004afe           add.w   d2,d1               ; d1 = d1 + byte offset
L00004b00           lea.l   $7a(a0,d1.W),a0     ; Source GFX PTR

L00004b04           moveq   #$56,d7             ; d7 = outer counter $57 = 87 dec (*2 = 174 - height of display)
L00004b06           move.w  L00006312,d1        ; d1 = Destination Offset Y
L00004b0a           moveq   #$56,d6             ; d6 = inner counter $57 = 87 dec (*2 = 174 - height of display)
L00004b0c           sub.w   d1,d6               ; (start y / gfx height)
L00004b0e           mulu.w  #$0054,d1           ; $54 = 84 dec
L00004b12           lea.l   $00(a4,d1.L),a1     ; a1 = DESTINATION PTR   

calc_gfx_offset
L00004b16           clr.w   d1
L00004b18           move.b  (a0),d1             ; d1 = source byte
L00004b1a           asl.w   #$07,d1             ; d1 = d1 * 128
L00004b1c           add.w   d1,d0               ; d0 = gfx offet
L00004b1e           bra.b   start_gfx_copy      ; L00004b2c
                    ;---------------------

L00004b20           dbf.w   d5,copy_2_rasters   ; L00004b32
L00004b24           moveq   #$07,d5
L00004b26           clr.w   d0
L00004b28           move.b  (a0),d0
L00004b2a           asl.w   #$07,d0

start_gfx_copy
L00004b2c           lea.l   $00(a2,d0.W),a3     ; D0 = gfx start offset, a2 = gfx base address
L00004b30           adda.w  d4,a0

                    ; copy 16 bits to 4 bitplanes
                    ; do 2 scan lines per loop iteration
                    ; source data is interleaved bitmap data
                    ; $1c81 = 7308 bytes
                    ; 7308 / 42 = 174 rasters high
copy_2_rasters
L00004b32           move.w  (a3)+,(a1)           ; line 0, bpl0 (42 byte wide display?)
L00004b34           move.w  (a3)+,$1c8c(a1)      ; line 0, bpl1 
L00004b38           move.w  (a3)+,$3918(a1)      ; line 0, bpl2
L00004b3c           move.w  (a3)+,$55a4(a1)      ; line 0, bpl3
L00004b40           move.w  (a3)+,$002a(a1)      ; line 1, bpl0 + 42(a1)
L00004b44           move.w  (a3)+,$1cb6(a1)      ; line 1, bpl1 + 42(a1)
L00004b48           move.w  (a3)+,$3942(a1)      ; line 1, bpl2 + 42(a1)
L00004b4c           move.w  (a3)+,$55ce(a1)      ; line 1, bpl3 + 42(a1)
L00004b50           lea.l   $0054(a1),a1         ; A1 = a1 + 84 bytes (skip 2 rasters)
L00004b54           dbf.w   d6,L00004b5c
L00004b58           lea.l   -$1c8c(a1),a1        ; subtract 1 bitplane from the destination.
L00004b5c           dbf.w   d7,L00004b20            ; Loop 87 times
L00004b60           rts 


                    ;-------------------------------------------------------------------------------------------------------
                    ; -- Draw the Background Level and Actors
                    ;-------------------------------------------------------------------------------------------------------
                    ; This routine draws the level background and the actors
                    ; It does not draw the player.
                    ;
draw_level_and_actors                                       ; original address L00004b62
L00004b62           move.w  #$8400,$00dff096
L00004b6a           movea.l playfield_buffer_2,a6           ; L000036f6,a6            ; playfield buffer 2
L00004b6e           subq.w #$02,a6                          ; subaq.w
L00004b70           movea.l L0000631e,a5                    ; [0005a36c] CODE1_CHIPMEM_BUFFER
L00004b74           move.w  L00006312,d1
L00004b78           clr.l   d6
L00004b7a           subq.w  #$01,d6
L00004b7c           swap.w  d6
L00004b7e           move.w  L000067bc,d2                        ; updated_batman_distance_walked
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




                    ;--------------------------------------------------
                    ; Player Move Commands
                    ;--------------------------------------------------
                    ; Jump table into player input/movement commands
                    ;
player_move_commands                                                ; original address $00004c3e
L00004c3e           clr.w   d2
L00004c40           move.b  player_input_command,d2                 ; L00006308,d2 ; Player Movement Command Index
L00004c44           asl.w   #$02,d2
L00004c46           movea.l player_input_cmd_table(pc,d2.W),a0      ; get input command address.
L00004c4a           jmp (a0)                                        ; execute input command


                    ; Jump Table (for above) - 32 Commands
player_input_cmd_table                                  ; original address $00004c4c
L00004c4c           dc.l    cmd_nop                     ; CMD00 - NOP 
L00004c50           dc.l    input_right                 ; CMD01 - $00005246 - Batman Walk Right
L00004c54           dc.l    input_left                  ; CMD02 - $0000529c - Batman Walk Left
L00004c58           dc.l    cmd_nop                     ; CMD03 - NOP
L00004c5c           dc.l    input_down                  ; CMD04 - $000053f4 - Batman Down (duck, scroll window)) - Not Ladder, Not Jump Down
L00004c60           dc.l    input_down_right            ; CMD05 - $00005240 - Batman Down + Right
L00004c64           dc.l    input_down_left             ; CMD06 - $00005292 - Batman Down + Left
L00004c68           dc.l    cmd_nop                     ; CMD07 - NOP
L00004c6c           dc.l    input_up                    ; CMD08 - $00005202 - Batman Up (scroll window) - Not Ladder, Not Batrope
L00004c70           dc.l    input_up_right              ; CMD09 - $00005244 - Batman Up + Right
L00004c74           dc.l    input_up_left               ; CMD10 - $00005298 - Batman Up + Left
L00004c78           dc.l    cmd_nop                     ; CMD11 - NOP
L00004c7c           dc.l    cmd_nop                     ; CMD12 - NOP 
L00004c80           dc.l    cmd_nop                     ; CMD13 - NOP
L00004c84           dc.l    cmd_nop                     ; CMD14 - NOP
L00004c88           dc.l    cmd_nop                     ; CMD15 - NOP
L00004c8c           dc.l    input_fire                  ; CMD16 - $00004fe0 - Fire + no direction
L00004c90           dc.l    input_fire                  ; CMD17 - $00004fe0 - Fire + Right
L00004c94           dc.l    input_fire                  ; CMD18 - $00004fe0 - Fire + Left
L00004c98           dc.l    input_fire                  ; CMD19 - $00004fe0 - Fire + Unknown
L00004c9c           dc.l    input_fire_down             ; CMD20 - $000053d6 - Fire + Down
L00004ca0           dc.l    input_fire_down             ; CMD21 - $000053d6 - Fire + Down + Right
L00004ca4           dc.l    input_fire_down             ; CMD22 - $000053d6 - fire + Down + Left
L00004ca8           dc.l    input_fire_down             ; CMD23 - $000053d6 - Fire + Unknown
L00004cac           dc.l    input_fire_up               ; CMD24 - $000050f8 - Fire + Up
L00004cb0           dc.l    input_fire_up_right         ; CMD25 - $000050e6 - Fire + Up + Right
L00004cb4           dc.l    input_fire_up_left          ; CMD26 - $000050ee - Fire + Up + Left
L00004cb8           dc.l    cmd_nop                     ; CMD27 - NOP
L00004cbc           dc.l    cmd_nop                     ; CMD28 - NOP
L00004cc0           dc.l    cmd_nop                     ; CMD29 - NOP
L00004cc4           dc.l    cmd_nop                     ; CMD30 - NOP
L00004cc8           dc.l    cmd_nop                     ; CMD31 - NOP



                    ; ------------------------- batman lose energy ---------------------------
                    ; IN: 
                    ;   d6.w - amount of energy to lose.
                    ;
batman_lose_energy                                                  ; original address L00004ccc
L00004ccc           tst.b   PANEL_STATUS_1                          ; Test if Time UP, Life Lost, No Lives
L00004cd2           bne.b   exit_rts                                ; exit if 'Timer Expired', 'Life Lost', 'No Lives Remaining'

L00004cd4           movem.l d0-d7/a5-a6,-(a7)
L00004cd8           move.w  d6,d0
L00004cda           jsr     PANEL_LOSE_ENERGY                       ; Panel - Lose Energy (D0.w) - $0007c870
L00004ce0           movem.l (a7)+,d0-d7/a5-a6
                    ; falls though to updating state below


                    ; --------------- update 'self modified code pointer' --------------------
                    ; appears to be a kind-of state machine, updated in the game loop
                    ; updates occur as long as the level timer has not expired.
                    ; IN;
                    ;   D6.w = #$01 (from main loop) - new state?
update_self_modified_code_ptr
L00004ce4           move.l  gl_jsr_address,d2                       ; L00003c90,d2 ; Self Modified Code JSR - game_loop - JSR address

L00004ce8               cmp.l   #L00005482,d2                           ; compare state with #$5482
L00004cec               beq.b   exit_rts                                ; exit if already in state #$5482

L00004cee               move.l  #L00004e3a,d3                           ; get new state
L00004cf2               cmp.l   d3,d2                                   ; compate state with #$4e3a
L00004cf4               beq.b   L00004d1c                               ; set state to (d3)

L00004cf6                   cmp.l   #L00004e64,d2                           ; Address
L00004cfa                   beq.b   L00004d1c

L00004cfc                       cmp.l   #L00005058,d2                           ; Address
L00004d00                       beq.b   L00004d38

L00004d02                           move.l  #L00004d48,d3                           ; Address
L00004d06                           cmp.l   #L00005308,d2                           ; Address
L00004d0a                           beq.b   L00004d1c

L00004d0c                               cmp.l   d2,d3
L00004d0e                               beq.b   L00004d1c

L00004d10                                   lea.l   L00005457,a0
L00004d14                                   bsr.w   set_batman_sprites
L00004d18                                   move.l  #L00004d56,d3                           ; Address

L00004d1c               move.l  d3,gl_jsr_address                       ; L00003c90  ; UPDATE game_loop JSR address

                        ; update value held in L00006306
                        ; by value passed in d6
                        ; clamp value in range (0 - 12)
L00004d20               move.w  L00006306,d2                            ; d2 = current state?
L00004d24               add.w   d6,d6                                   ; multiple d6 by 4
L00004d26               add.w   d6,d6                                   
L00004d28               add.w   d6,d2                   
L00004d2a               cmp.w   #$000c,d2                               ; compare d2 with 12
L00004d2e               bcs.b   L00004d32
.clamp_d2
L00004d30               moveq   #$0c,d2                                 ; clamp d2 to max of 12
L00004d32               move.w  d2,L00006306
exit_rts    
L00004d36           rts 


L00004d38           move.w  L000062f2,d2
L00004d3c           add.w   d6,d2
L00004d3e           add.w   d6,d2
L00004d40           add.w   d6,d2
L00004d42           move.w  d2,L000062f2
L00004d46           rts 


L00004d48           subq.w  #$01,L00006306
L00004d4c           bne.b   exit_rts                        ; L00004d36
L00004d4e           move.l  #L00005308,gl_jsr_address       ;L00003c90 ; Set Self Modifying Code JSR in game_loop
L00004d54           bra.b   L00004d7a

L00004d56           tst.w   L00006318
L00004d5a           beq.b   L00004d60
L00004d5c           bsr.w   L000051b0
L00004d60           subq.w  #$01,L00006306
L00004d64           bne.b   exit_rts                                ; L00004d36
L00004d66           move.l  #player_move_commands,gl_jsr_address    ; L00003c90 ; Set Self Modifying code - GameLoop JSR - L00003c92 = jsr address (low word) - Default Value = $4c3e (run command loop)
L00004d6c           tst.w   L00006318
L00004d70           beq.b   L00004d76
L00004d72           bsr.w   L000051a8
L00004d76           bsr.w   L00005430
L00004d7a           tst.b   PANEL_STATUS_1              ; Panel - Status Byte 1 - $0007c874
L00004d80           beq.b   exit_rts                                ; L00004d36

                    ; lose a life - audio & animation?
L00004d82           jsr     AUDIO_PLAYER_SILENCE              
L00004d88           clr.w   L00006318
L00004d8c           moveq   #$03,d0                             ; song/sound number - 03 = player life lost
L00004d8e           jsr     AUDIO_PLAYER_INIT_SONG            
L00004d94           move.l  #L00004da2,gl_jsr_address           
L00004d9a           move.w  #$63dc,L00006326
L00004da0           rts 


                    ; ----------------- PLAYER STATE: player dead ------------------
                    ; routine inserted into game_loop self modified code routine.
                    ;  - installed be rouine L00004d82 above.
                    ;
player_state_dead                                                       ; original address L00004da2
                    ; player dead animation
L00004da2            movea.w L00006326,a0                               
L00004da6            bsr.w   set_batman_sprites
L00004daa            move.w  a0,L00006326
L00004dae            tst.b   (a0)
L00004db0            bne     exit_rts                                   ;  L00004d36  ; Exit (JMP to RTS)

L00004db2            jsr     AUDIO_PLAYER_INIT_SFX_2                    ; stop audio
L00004db8            move.w  #$0032,d0
L00004dbc            bsr.w   wait_for_frame_count                       ; L00005e8c
L00004dc0            bsr.w   clear_backbuffer_playfield                 ; L00004e28
L00004dc4            btst.b  #PANEL_ST1_TIMER_EXPIRED,PANEL_STATUS_1     ; Panel - Status Byte 1 bit #$0000 of $0007c874
L00004dcc            beq.b   L00004dd6

L00004dce            lea.l   text_time_up,a0                            ; L00004e1c,a0
L00004dd2            bsr.w   large_text_plotter                         ; L000067ca

L00004dd6            btst.b  #PANEL_ST1_NO_LIVES_LEFT,PANEL_STATUS_1     ; Panel - Status Byte 1 - bit #$0001 of $0007c874
L00004dde            beq.b   L00004de8
L00004de0            lea.l   text_game_over,a0                          ; L00004e0e,a0
L00004de4            bsr.w   large_text_plotter                         ; L000067ca

L00004de8            bsr.w   screen_wipe_to_backbuffer                  ; L00003cc0
L00004dec            move.w  #$001e,d0
L00004df0            bsr.w   wait_for_frame_count                       ; L00005e8c
L00004df4            btst.b  #PANEL_ST1_NO_LIVES_LEFT,PANEL_STATUS_1     ; Panel - Status Byte 1 - bit #$0001 of $0007c874
L00004dfc            beq.w   restart_level                              ; L00003b02


                    ; ------------------- return to title screen ------------------------

return_to_title_screen                                                  ; original address L00004e00
L00004e00            jsr     AUDIO_PLAYER_SILENCE                             ; Chem.iff - Music/SFX player - Silence Audio- $00048004           ; External Address - CHEM.IFF
L00004e06            bsr.w   panel_fade_out                             ; L00003d8c
L00004e0a            bra.w   LOADER_TITLE_SCREEN                        ; $00000820 ; **** LOADER ****


                    ; GAME OVER - original address L00004e0e
text_game_over
                     dc.b    $5f, $0f
                     dc.b    'GAME  '                   ; $47, $41, $4d, $45, $20, $20
                     dc.b    'OVER'                     ; $4f, $56, $45, $52
                     dc.b    $00, $ff

                    ; TIME UP - original address L00004e1c
text_time_up
                     dc.b    $43, $10
                     dc.b    'TIME  '                   ; $54, $49, $4d, $45, $20, $20 
                     dc.b    'UP'                       ; $55, $50
                     dc.b    $00, $ff

                    even
                    
clear_backbuffer_playfield                              ; original address $00004e28
L00004e28           movea.l playfield_buffer_2,a0      ; 
                    move.w  #$1c8b,d7                  ; loop 7308 times / 42 = 174 rasters
.clear_loop                                             ; original address L00004e32
                    clr.l   (a0)+                      ; clear 29232 bytes = 4 bitplanes
                    dbf.w   d7,.clear_loop             ; loop to $00004e32
                    rts                                ; original address $00004e38




                    ; game_loop - Self Modified JSR Address
                    ; set at line of code L00004cee
L00004e3a            moveq   #$10,d3                    ; CMD16 - Fire - No Direction
L00004e3c            tst.b   PANEL_STATUS_1             ; Panel - Status Byte 1 - (Clock Timer Expired, No Lives, Life Lost bits)
L00004e42            bne.b   L00004e60

L00004e44            lea.l   L00006318,a0
L00004e48            move.w  (a0),d2
L00004e4a            cmp.w   #$0050,d2                  ; compare 80 with d2
L00004e4e            bcc.b   L00004e60                  ;   if d2 > 80 jmp $4e60
L00004e50            addq.w  #$01,(a0)
L00004e52            clr.w   d3                         ; Player Movement Command 00 - NOP
L00004e54            subq.w  #$01,L00006306
L00004e58            bne.b   L00004e60
L00004e5a            move.l  #L00004e64,gl_jsr_address  ; L00003c90        ; Set Self MOdified Code JSR in game_loop


                    ; one of the following has occurred
                    ; Panel Status 1
                    ;  - Clock Timer Expired
                    ;  - No Lives Left
                    ;  - Life has been Lost
                    ; Contents of $00006318
                    ;  - is less than 80 (decimal) #$50
                    ; Contents of $00006305
                    ;  - is more than 0
                    ;
L00004e60            move.b  d3,player_input_command    ; CMD00 (rts) or (CMD16) Fire no Direction

                    ; Updated Self Modified JSR (game_loop) when ($00006306).w is zero
L00004e64            lea.l   L00006318,a0                
L00004e68            move.w  (a0),d5
L00004e6a            move.b  player_input_command,d4    ; L00006308,d4
L00004e6e            btst.l  #$0003,d4
L00004e72            beq.b   L00004ea8
L00004e74            move.w  #$0048,L000067c6
L00004e7a            subq.w  #$01,d5
L00004e7c            bhi.b   L00004ea6
L00004e7e            clr.w   (a0)
L00004e80            move.l  #L00005058,gl_jsr_address  ; L00003c90 ; Self modified code JSR game_loop
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
L00004edc            and.w   playfield_swap_count,d6            ;  d6 = 1 or 0, even/odd playfield swap value
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
L00004f64            sub.w   MAPGR_BASE,d3            ; MAPGR.IFF (value $00c0)
L00004f6a            dbf.w   d7,L00004f50
L00004f6e            movem.w L000067c2,d0-d1
L00004f74            add.w   d4,d1
L00004f76            add.w   d5,d0
L00004f78            movem.w d0-d1,L000067c2
L00004f7e            move.l  L0000631a,L00006328
L00004f84            btst.b  #$0004,player_input_command            ; L00006308
L00004f8a            bne.b   L00004fae
L00004f8c            rts 


L00004f8e           tst.w   d4
L00004f90           bmi.b   L00004f9a
L00004f92           subq.w  #$02,L00006318
L00004f96           bra.w   L00004f1a

L00004f9a           movem.w d0-d7,-(a7)
L00004f9e           moveq   #$02,d6                                 ; Value of Energy to Lose
L00004fa0           bsr.w   batman_lose_energy                      ; L00004ccc
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




                    ; -------- input fire - Jump Table CMD9 ---------
input_fire                                              ; original address L00004fe0
L00004fe0           move.w  #$6419,L00003626            
L00004fe8           move.l  #L00004ff6,gl_jsr_address   ; Set game_loop Self Modified Code JSR 
L00004fee           moveq   #SFX_BATARANG,d0
L00004ff0           jsr     AUDIO_PLAYER_INIT_SFX

L00004ff6           movea.w L00006326,a0
L00004ffa           bsr.w   set_batman_sprites
L00004ffe           move.w  a0,L00006326
L00005002           tst.b   (a0)
L00005004           bne.b   L00005034
L00005006           move.w  #$0008,L000062f2
L0000500c           move.l  #L00005036,gl_jsr_address   ; Set game_loop Self Modified Code JSR
L00005012           bsr.w   L0000463e
L00005016           sub.w   #$0007,d0
L0000501a           move.w  batman_sprite1_id,d2
L0000501e           spl.b   d2
L00005020           ext.w   d2
L00005022           bpl.b   L00005028
L00005024           add.w   #$000e,d0
L00005028           addq.w  #$03,d2
L0000502a           move.w  d2,(a0)+
L0000502c           sub.w   #$0010,d1
L00005030           movem.w d0-d1,(a0)
L00005034           rts  


L00005036           move.b  player_input_command,d4                 ; L00006308,d4
L0000503c           bne.w   L0000504e
L00005040           subq.w  #$01,L000062f2
L00005044           bne.b   L00005034
L00005046           lea.l   L000063d3,a0
L0000504a           bra.w   set_batman_sprites                      ; L00004538

L0000504e           move.l  #player_move_commands,gl_jsr_address    ; L00003c90 ; Set Self Modifying code - GameLoop JSR - L00003c92 = jsr address (low word) - Default Value = $4c3e (run command loop)
L00005054           bra.w   player_move_commands                ; L00004c3e



                    ; routine inserted into self modified JSR
                    ; in game_loop by code line L00004e80
                    ;
L00005058           subq.w  #$01,L000062f2
L0000505c           bne.b   L00005034
L0000505e           move.w  #$0006,L000062f2
L00005064           subq.w  #$05,L000067c4
L00005068           subq.w  #$04,d1
L0000506a           move.w  batman_sprite1_id,d2                     ; L000062ee,d2
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
L00005096           bsr.w   set_batman_sprites
L0000509a           move.w  a0,L00006326
L0000509e           move.b  (a0),d7
L000050a0           bne.b   L000050a8
L000050a2           move.l  #$00005414,gl_jsr_address   ; L00003c90  ; update self modified code JSR game_loop
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




                    ; ------- batrope up-right - Jump Table CMD12 --------
input_fire_up_right                                                 ; original address L000050e6
L000050e6           clr.w   batman_sprite1_id                       ; set right facing sprite
L000050ea           moveq   #$7f,d0                                 ; d0 = +127
L000050ec           bra.b   L000050fa


                    ; -------- batrope up-left - Jump Table CMD13 --------
input_fire_up_left                                                  ; original address L000050ee
L000050ee           move.w  #$e000,batman_sprite1_id                ; set left facing sprite
L000050f4           MOVE.L  #$ffffff81,D0                           ; d0 = -127
L000050f6           bra.b   L000050fa


                    ; ---------- batrope up - Jump Table CMD11 -----------
input_fire_up                                                       ; original address L000050f8
L000050f8           clr.w   d0                                      ; d0 = 0
L000050fa           move.w  #$0048,L000067c6
L00005100           lea.l   $6314,a0
L00005104           move.w  d0,(a0)+
L00005106           clr.l   (a0)+
L00005108           bsr.w   L0000463e
L0000510c           move.w  #$0001,(a0)
L00005110           move.l  #L00005132,gl_jsr_address               ; Set game_loop Self Modified Code JSR
L00005116           lea.l   L000063d0,a0
L0000511a           bsr.w   set_batman_sprites
L0000511e           moveq   #SFX_BATROPE,d0
L00005120           jsr     AUDIO_PLAYER_INIT_SFX
L00005126           movem.w L000067c2,d0-d1
L0000512c           bclr.b  #$0004,player_input_command
L00005132           lea.l   L00006314,a0
L00005136           btst.b  #$0004,player_input_command
L0000513e           bne     L000051be
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
L00005160           move.w  batman_sprite1_id,d7
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
L00005194           move.l  #L00004e64,gl_jsr_address               ; Set game_loop Self Modified Code JSR
L0000519a           move.l  L0000631a,L00006328
L000051a0           lea.l   L00006416,a0
L000051a4           bra.w   set_batman_sprites
L000051a8           move.l  #L000051b0,gl_jsr_address               ; Set game_loop Self Modified Code JSR
L000051ae           rts


L000051b0           lea.l   L00006314,a0
L000051b4           btst.b  #$0004,player_input_command             ; L00006308
L000051bc           beq.b   L000051c4
L000051be           move.w  #$0002,$0004(a0)
L000051c4           subq.w  #$03,$0004(a0)
L000051c8           bls.b   L000051ce
L000051ca           bra.w   L000050aa
L000051ce           clr.w   $0004(a0)
L000051d2           move.l  #player_move_commands,gl_jsr_address    ; L00003c90 ; Set Self Modifying code - GameLoop JSR - L00003c92 = jsr address (low word) - Default Value = $4c3e (run command loop)
L000051d8           lea.l   L000063d3,a0
L000051dc           bra.w   set_batman_sprites
L000051e0           rts 


L000051e2           move.w  #$0028,L000067c6
L000051e8           move.w  L000067bc,d2                    ; updated_batman_distance_walked
L000051ec           add.w   d0,d2
L000051ee           and.w   #$0007,d2
L000051f2           subq.w  #$04,d2
L000051f4           bne.b   L000051e0
L000051f6           bsr.w   L000055a0
L000051fa           cmp.b   #$85,d2
L000051fe           bcs.b   L000051e0
L00005200           bra.b   L0000522e


input_up
L00005202           bsr.b   L00005208                               ; Jmp Table CMD6
L00005204           bra.w   L00005430
L00005208           move.w  #$0048,L000067c6
L0000520e           move.w  L000067bc,d2                            ; updated_batman_distance_walked
L00005212           add.w   d0,d2
L00005214           and.w   #$0007,d2
L00005218           subq.w  #$04,d2
L0000521a           bne.b   L000051e0
L0000521c           sub.w   #$000c,d1
L00005220           bsr.w   L000055a0
L00005224           add.w   #$000c,d1
L00005228           cmp.b   #$85,d2
L0000522c           bcs.b   L000051e0
L0000522e           addq.w  #$04,a7                                 ; addaq.w
L00005230           and.b   #$0c,player_input_command               ; L00006308
L00005236           move.l  #L00005308,gl_jsr_address               ; L00003c90 ; Self Modified Code JSR - game_loop
L0000523c           bra.w   L00005308


input_down_right
L00005240           bsr.b   L000051e2           ; jmp table CMD4
L00005242           bra.b   input_right         ; L00005246 

input_up_right
L00005244           bsr.b   L00005208           ; jmp table CMD7

input_right
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
L0000526c           lea.l   batman_sprite3_id,a0            ; L000062ea,a0
L00005270           add.w   L000067bc,d0                    ; updated_batman_distance_walked
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
cmd_exit
cmd_nop
L00005290           rts                      


input_down_left
L00005292           bsr.w   L000051e2               ; Jump Table CMD5
L00005296           bra.w   input_left              ; L0000592c     ; bra.b 

input_up_left
L00005298           bsr.w   L00005208               ; Jump Table CMD8


input_left
L0000529c           subq.w  #$05,d0                 ; Jump Table CMD2
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
L000052c2           lea.l   batman_sprite3_id,a0        ; L000062ea,a0
L000052c6           add.w   L000067bc,d0                ; updated_batman_distance_walked
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
L000052f0           move.b  $00(a0,d3.W),d2                         ; $00000d13 [d6],d2
L000052f4           sub.b   #$79,d2
L000052f8           cmp.b   #$0d,d2
L000052fc           bcc.w   L00005368                               ; bcc.b
L000052fe           move.l  #player_move_commands,gl_jsr_address    ; L00003c90 ; Set Self Modifying code - GameLoop JSR - L00003c92 = jsr address (low word) - Default Value = $4c3e (run command loop)
L00005304           bra.w   player_move_commands                    ; L00004c3e

L00005308           btst.b  #$0004,player_input_command             ; L00006308
L0000530e           bne.w   L0000545a
L00005312           btst.b  #$0000,playfield_swap_count+1           ; test even/odd playfield buffer swap value
L00005318           bne.b   L000052ec
L0000531a           clr.w   d4
L0000531c           move.b  player_input_command,d4                 ; L00006308,d4
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
L00005358           move.b  d5,player_input_command                 ; L00006308
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
L0000538a           move.w  MAPGR_BASE,d5           ; MAPGR.IFF (value = $00c0)
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
L000053c4           lea.l   batman_sprite3_id,a0     ; L000062ea,a0
L000053c8           clr.l   (a0)+
L000053ca           move.w  d2,(a0)
L000053cc           rts 

L000053ce           move.l  #player_move_commands,gl_jsr_address    ; L00003c90 ; Set Self Modifying code - GameLoop JSR - L00003c92 = jsr address (low word) - Default Value = $4c3e (run command loop)
L000053d4           rts


input_fire_down
L000053d6            add.w   #$0008,d1                              ; Jump Table CMD10
L000053da            bsr.w   L000055a0
L000053de            movem.w L000067c2,d0-d1
L000053e4            cmp.b   #$17,d2
L000053e8            bcs.b   input_down                             ; L000053f4
L000053ea            move.w  #$8000,L00005506
L000053f0            bra.w   L0000545a


input_down
L000053f4           bsr.w   L000051e2                               ; Jump table CMD3
L000053f8           lea.l   L000063d6,a0
L000053fc           bsr.b   set_batman_sprites
L000053fe           move.l  #L00005406,gl_jsr_address               ; L00003c90 ; Set Self Modifying Code - game_loop JSR
L00005404           rts



                    ; address moved into self modified JSR
                    ; by code line L000053fe
L00005406           lea.l   L000063d9,a0
L0000540a           bsr.b   set_batman_sprites
L0000540c           btst.b  #$0002,player_input_command             ; L00006308
L00005412           bne.b   L00005420



                    ; address moved into self modified JSR
                    ; by code line L000050a2
L00005414           move.l  #set_default_gl_jsr,gl_jsr_address      ; L00003c90 ; Set game_loop JSR self modified code
L0000541a           lea.l   L000063d6,a0
L0000541e           bra.b   set_batman_sprites
L00005420           btst.b  #$0004,player_input_command             ; L00006308
L00005426           bne.b   input_fire_down                         ; L000053d6
L00005428           rts 



                    ; code inserted into game_loop JSR self modified code
                    ; by line L00005414
                    ; reset self modified code JSR to default routine.
set_default_gl_jsr
L0000542a           move.l  #player_move_commands,gl_jsr_address    ; L00003c90 ; Set Self Modifying code - GameLoop JSR - L00003c92 = jsr address (low word) - Default Value = $4c3e (run command loop)
L00005430           lea.l   L000063d3,a0
L00005434           bra.w   set_batman_sprites


                    ; ----------------- set batman sprites --------------------
                    ; Sets batman sprites 1, 2 & 3 from the vales passed in 
                    ; the 3 byte array.
                    ;
                    ; IN: 
                    ;   A0.l = ptr to 3 byte array of sprite id's
                    ; 
set_batman_sprites                                                  ; original address L00005438
                    move.w  d7,-(a7)                        ; save d7
                    lea.l   batman_sprite1_id,a1
                    ; preserve left/right facing directions
                    move.w  (a1),d7
                    and.w   #$e000,d7
                    ; set first sprite id
                    add.b   (a0)+,d7
                    move.w  d7,(a1)
                    ; add second sprite id offset
                    add.b   (a0)+,d7
                    move.w  d7,-(a1)
                    ; add thrid sprite id offset
                    add.b   (a0)+,d7
                    move.w  d7,-(a1)
                    ; restore registers & exit
                    move.w  (a7)+,d7                        ; restore d7
                    rts 


batman_sprite_anim_06
L00005454           dc.b    $0d,$01,$01                     ; 13, 14, 15
batman_sprite_anim_05
L00005457           dc.b    $11,$ff,$02                     ; 11, 10, 12


L0000545a           movem.w L000067c2,d0-d1
L00005460           clr.l   L000062f4
L00005464           move.w  L000067c4,L000067c6
L0000546a           lea.l   L00005454(pc),a0                        ; 3 sprite id array
L0000546e           bsr.w   set_batman_sprites
L00005472           move.l  #L00005482,gl_jsr_address               ; Set game_loop Self Modifying Code JSR 
L00005478           move.w  #$ffff,L000062fa
L0000547e           clr.w   L000062f8

                    ; ----------- default game loop state? -------------
                    ; appears to be the default routine called by the
                    ; game loop's self modified code.
default_gl_state
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
L000054b2           add.w   MAPGR_BASE,d3                   ; MAPGR.IFF (value = $00c0)
L000054b8           move.b  $00(a0,d3.W),d2                 ; $00000d13 [d6],d2
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
L0000552c           bsr.w   set_batman_sprites                  
L00005530           move.l  #$0000555a,gl_jsr_address           ; Set game_loop Self Modified Command JSR
L00005538           clr.w   L000062f6
L0000553c           move.w  #$0001,L000062fa
L00005542           move.w  #$0002,L000062f2
L00005548           move.w  L000067be,d0
L0000554c           add.w   d1,d0
L0000554e           and.w   #$0007,d0
L00005552           sub.w   d0,d1
L00005554           move.w  d1,L000067c4
L00005558           rts




                    ; Called from GameLoop - Self Modifying code.
L0000555a           subq.w  #$01,L000062f2
L0000555e           bne.b   exit_routine

L00005560           tst.b   PANEL_STATUS_1                                  ; Panel - Status Byte 1 - $0007c874
L00005566           bne.w   L00004d82

L0000556a           move.l  #player_move_commands,gl_jsr_address            ; Set game_loop Self Modified Code JSR
L00005572           lea.l   L000063d3,a0
L00005576           cmp.w   #$0050,L000062f8
L0000557c           bmi.w   set_batman_sprites                              ; a0 = 3 sprite array
L00005580           moveq   #$5a,d6                                         ; Value of Energy to Lose (90) - DEAD! (max is 48?)
L00005582           bsr.w   batman_lose_energy
L00005586           move.b  #PANEL_ST2_VAL_LIFE_LOST,PANEL_STATUS_1         ; Set - LIFE LOST
L0000558e           btst.b  #PANEL_ST2_CHEAT_ACTIVE,PANEL_STATUS_2          ; Check - CHEAT ACTIVE
L00005596           bne.b   L0000559e
L00005598           jmp     PANEL_LOSE_LIFE                                 ; Panel - Lose a Life - $0007c862
                    ; never return (use panel rts)
exit_routine
L0000559e           rts




L000055a0           movem.w level_parameters,d2-d3                  ; L000067bc,d2-d3 ; level parameters (updated_batman_distance_walked, unknown)
L000055a6           add.w   d0,d2
L000055a8           add.w   d1,d3
L000055aa           lsr.w   #$03,d2
L000055ac           lsr.w   #$03,d3
L000055ae           mulu.w  MAPGR_BASE,d3           ; MAPGR.IFF (value = $00c0)
L000055b4           add.w   d2,d3
L000055b6           lea.l   MAPGR_INIT,a0           ; $0000807c,a0            ; External Address - MAPGR.IFF
L000055bc           clr.w   d2
L000055be           move.b  $00(a0,d3.W),d2
L000055c2           rts



                    ;------------------------------------------------------------------------------------------
                    ; -- Draw Batman and Rope
                    ;------------------------------------------------------------------------------------------
                    ; This routine draws the Batman Player and the Rope Swing
                    ;
draw_batman_and_rope                                ; original address L000055c4
L000055c4           move.w  L00006318,d2
L000055c8           beq.w   L000056a6
L000055cc           movem.w L000067c2,d0-d1
L000055d2           sub.w   #$000c,d1
L000055d6           addq.w  #$03,d0
L000055d8           move.w  batman_sprite1_id,d2        ; L000062ee,d2
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
L00005604           beq.w   L000056a6                   ; Jmp Draw Batman Sprite
                    ; Draw BatRope as blitter line draw
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
                    ; blit wait
L00005646           btst.b  #$0006,$00dff002
L0000564e           bne.b   L00005646
                    ; set blitter for line draw
L00005650           move.w  d2,$0062(a5)            ; Channel B modulo
L00005654           move.w  d6,$0064(a5)            ; Channel A modulo
L00005658           move.w  #$002a,$0066(a5)        ; Channel D modulo
L0000565e           move.w  #$002a,$0060(a5)        ; Channel C modulo
L00005664           move.w  #$c000,$0074(a5)        ; A Data Register
L0000566a           move.l  #$ffffffff,$0044(a5)    ; Channel A First/Last word mask
L00005672           move.w  #$eeee,d6               ; Line Pattern Data
L00005676           moveq   #$03,d7                 ; bitplane count
                    ; blit wait
L00005678           btst.b  #$0006,$00dff002
L00005680           bne.b   L00005678
                    ; draw rope (Line Draw)
L00005682           move.w  d5,$0052(a5)            ; A Channel
L00005686           move.l  d0,$0040(a5)            ; BLTCON0
L0000568a           move.l  d1,$0048(a5)            ; C Channel
L0000568e           move.l  d1,$0054(a5)            ; D Channel
L00005692           move.w  d6,$0072(a5)            ; B Data Register (line pattern)
L00005696           move.w  d3,$0058(a5)            ; Blit Size
L0000569a           add.l   #$00001c8c,d1           ; next bitplane dest offset
L000056a0           not.w   d6                      ; invert mask/line pattern?
L000056a2           dbf.w   d7,L00005678            ; loop next bitplane

                    ; draw first Batman Sprite
L000056a6           movem.w L000067c2,d0-d1         ; batman object X & Y co-ords
L000056ac           move.w  batman_sprite1_id,d2    ; sprite id
L000056b0           clr.w   d4
L000056b2           move.b  d2,d4
L000056b4           beq.w   exit_draw_batman        ; if (sprite id) == 0 then exit
L000056b8           move.w  d1,d3                   ; d1 = Y co-ord
L000056ba           lea.l   L0000607c,a0            ; unknown table 
L000056be           add.w   d4,d4                   ; sprite id * 2
L000056c0           add.w   d3,d3                   ; Y co-ord * 2
L000056c2           sub.b   -2(a0,d4.W),d3          ; modify Y co-ord
L000056c6           asr.w   #$01,d3                 ; divide y by 2 (X & Y stored as halved values)
L000056c8           move.w  d3,L000062f0            ; store update Y co-ord
L000056cc           bsr.b   draw_sprite             ; Draw Batman Part - L000056f4

                    ; draw second Batman Sprite
L000056ce           movem.w L000067c2,d0-d1         ; batman object X & Y co-ords
L000056d4           move.w  batman_sprite2_id,d2    ; sprite id            
L000056d8           move.b  d2,d2
L000056da           beq.w   exit_draw_batman        ; if (sprite id) == 0 then exit
L000056de           bsr.b   draw_sprite

                    ; draw third Batman Sprite
L000056e0           movem.w L000067c2,d0-d1         ; batman object X & Y co-ords
L000056e6           move.w  batman_sprite3_id,d2    ; sprite id
L000056ea           move.b  d2,d2
L000056ec           beq.w   exit_draw_batman        ; if (sprite id == 0) then exit
L000056f0           bsr.b   draw_sprite

exit_draw_batman
L000056f2           rts 



                    ;------------------------------------------------------------------------
                    ; -- Draw Sprite
                    ;------------------------------------------------------------------------
                    ; This routine blits a sprite to the destination using a cookie cut blit.
                    ; There's a lot of faf around clipping sprites and working out shift, mask
                    ; and blit sizes for clipping around the screen edges.
                    ; This might be fine for a general sprite blit routine.
                    ; Could have avoided a lot of the faf by giving sprites a max size and
                    ; adding a bit of buffer around the screen edge -- maybe???
                    ;
                    ; Sprite X & Y is held in a byte value and multipled by 2 to give actual screen position.
                    ;           Sprites have a position resolution of 2 pixels.
                    ;
                    ;   sprite_array_ptr ($62FE) holds a sprite draw structure
                    ;       Byte 0 - Y Offset (2 pixel resolution)
                    ;       Byte 1 - X Offset (2 pixel resolution)
                    ;       Byte 2 - Sprite Width in Words
                    ;       Byte 3 - Sprite Height in Lines
                    ;       Long 4-7 - Sprite Data Memory Pointer (Mask, bpl0, bpl1, bpl2, bpl3)
                    ;
                    ; in:
                    ;   d0.w - Sprite X Position 
                    ;   d1.w - Sprite Y Position
                    ;   d2.w - Sprite id (1 based array index) - index into table $63fe (8 byte structure)
                    ;
draw_sprite                                         ; original address $L000056f4
L000056f4           movea.l sprite_array_ptr,a1     ; L000062fe,a1        ; Sprite Structure Data Pointer
                    add.w   d1,d1                   ; d1 = d1 * 2
                    asl.w   #$03,d2                 ; d2 = d2 * 8 (sprite structure 8 bytes?)

                    lea.l   -8(a1,d2.W),a1          ; a1 = sprite data structure.
                    bcc.b   right_facing_sprite     ; L00005724 ; if d2 < 8192 (8k) then JMP 5724

                    ; Left Facing Sprite     
left_facing_sprite                                  ; original address L00005702
                    ; update X & Y with sprite offset            
                    move.b  (a1)+,d4                ; get sprite y offset
                    ext.w   d4                      ; extend to word length
                    sub.w   d4,d1                   ; subtract y offset from Y position
                    move.b  (a1)+,d4                ; get sprite x offset
                    ext.w   d4                      ; extend to word length
                    add.w   d4,d0                   ; add x offset to X position
                    clr.w   d2

                    ; get sprite width, height and gfx address ptr
                    move.b  (a1)+,d2                ; get sprite width in words
                    move.w  d2,d4                   ; d4 = copy of sprite width in words
                    lsl.w   #$03,d4                 ; multiply width by 8
                    sub.w   d4,d0                   ; subtract width from X position value
                    clr.w   d3
                    move.b  (a1)+,d3                ; get sprite height in lines
                    movea.l (a1)+,a0                ; get sprite gfx ptr (mask,bpl0,bpl1,bpl2,bpl3) ; a0 = start of gfx mask data
                    adda.l  sprite_gfx_offset,a0    ; L00006302,a0            ; additional code for left facing sprite
                    bra.b   calc_sprite_size        ; L0000573a

                    ; Right Facing Sprite
right_facing_sprite                                 ; original address L00005724
                    move.b  (a1)+,d4                ; get sprite y ofset - d4 = offset value.b
                    ext.w   d4                      ; d4 = offset value.w
                    sub.w   d4,d1                   ; Subtract d4 from Y co-ordinate value
                    move.b  (a1)+,d4                ; get sprite x offset - d4 = offset value.b
                    ext.w   d4                      ; d4 = offset value.w
                    sub.w   d4,d0                   ; Subtract d4 from X co-ordinate value
                    clr.w   d2                      ; init d2 = #$0.w
                    move.b  (a1)+,d2                ; sprite width in words- d2 = value.b
                    clr.w   d3                      ; init d3 = #$0.w
                    move.b  (a1)+,d3                ; sprite height in lines
                    movea.l (a1)+,a0                ; get sprite gfx ptr (mask,bpl0,bpl1,bpl2,bpl3) ; a0 = start of gfx mask data

                    ; left/right facing common processing
calc_sprite_size                                    ; original address L0000573a
                    move.w  d3,d4
                    mulu.w  d2,d4                   ; d4 = d3 * d2
                    add.l   d4,d4                   ; d4 = d4 * 2
                    movea.l d4,a1                   ; a1 = size of sprite bitplane (bytes)

                    ; sprite Y display clipping
sprite_y_clipping
                    ; check top of sprite on screen
                    move.w  d1,d1
                    bpl.b   clip_bottom_display     ; L00005758 ; top of sprite Y is +ve
                    ; top of sprite is -ve (i.e. off screen)
                    neg.w   d1                      ; y = y * -1
                    sub.w   d1,d3                   ; subtract sprite top from bottom
                    bls.w   exit_draw_sprite        ; L00005852 ; exit if whole sprite is off top of display

                    ; adjust gfx ptr 
                    ; clip top of sprite by the amount off top of display
                    ; d1 = number of lines to clip
                    ; d2 = sprite width
                    mulu.w  d2,d1
                    adda.l  d1,a0                           ; a0 = start of gfx mask data
                    adda.l  d1,a0                           ; a0 = start of gfx mask data
                    moveq   #$00,d1
                    bra.b   sprite_x_clipping               ; L00005768

                    ; check sprite top co-ord is off bottom of screen
clip_bottom_display
                    move.w  #$00ad,d6               ; #$ad = 173 (display window height)
                    sub.w   d1,d6                   ; subtract Y position from screen height
                    bls.w   exit_draw_sprite        ; L00005852 ; exit if sprite is off bottom of screen

                    ; check sprite bottom co-ord is off bottom of screen
                    ; if so, set bottom to display window size
                    cmp.w   d3,d6                   ; d3 = bottom of sprite
                    bpl.b   sprite_x_clipping       ; L00005768
                    move.w  d6,d3                   ; bottom  of sprite = end of display

                    ; Clip Sprite X Axis to the Display Size
                    ; d0 = X Position
                    ; d2 = width of sprite (words)
                    ; d1 = start raster of sprite display - Y co-ord
                    ; d3 = last raster of sprite display  - Y + height
                    ; a0 = start address offset of gfx mask data
sprite_x_clipping
                    MOVE.L  #$ffffffff,D7                   ; d7 = first word mask & last word mask (no mask)
                    move.w  d2,d5

                    moveq   #$07,d6                         ; d6 = bit shift (src gfx)
                    and.w   d0,d6                           ; d6 = shift value. d6 = bit shift (src gfx)
                    bne.b   calc_shifts_and_masks           ; L00005794 ; shift is > 0

                    ; 
                    ; shift value = 0 (on a byte boundary)
                    asr.w   #$03,d0                         ; divide x by 8 to get byte offset
                    bpl.b   clip_right_display              ; L00005784
                    ; byte offset is -ve
clip_left_display
                    neg.w   d0
                    sub.w   d0,d5                           ; subtract width from sprite
                    bls.w   exit_draw_sprite                ; sprite is off the left hand side of thhe screen
                    ; clip sprite left ptr
                    adda.w  d0,a0                           ; a0 = start of gfx mask data
                    adda.w  d0,a0                           ; a0 = start of gfx mask data
                    moveq   #$00,d0
                    ; byte offset is +ve
clip_right_display
                    moveq   #$14,d4                         ; d4 = #$14 (20 decimal #of words screen width?)
                    sub.w   d0,d4                           ; 
                    ble.w   exit_draw_sprite                ; sprite is off screen right hand side
                    cmp.w   d4,d5
                    bls.b   calc_bltsize_and_modulos        ; L000057ce
                    move.w  d4,d5                           ; trim sprite width (clip right)
                    bra.b   calc_bltsize_and_modulos        ; L000057ce

                    ; shift value is > 0
                    ; d0 = X Position
                    ; d2 = width of sprite (words)
                    ; d1 = start raster of sprite display - Y co-ord
                    ; d3 = last raster of sprite display  - Y + height
                    ; d5 = copy of sprite width (words)
                    ; a0 = start address offset of gfx mask data
calc_shifts_and_masks
                    clr.w   d7                              ; d7 = first word mask & last word mask
                    addq.w  #$01,d5                         ; add 1 to copy of width (words) - shifted bob needs area to shift into
                    asr.w   #$03,d0                         ; divide x by 8 - d0 - X word offset
                    bpl.b   x_co_ord_positive               ; L000057b8
                    ; x co-ord is -ve (off screen left)
x_co_ord_negative
                    neg.w   d0
                    subq.w  #$01,d0                         ; make x offset +ve
                    sub.w   d0,d5                           ; subtract from the sprite width
                    bls.w   exit_draw_sprite                ; sprite is off the screen (left hand side) - L00005852
                    ; sprite is on screen
                    adda.w  d0,a0                           ; a0 = start of gfx mask data
                    adda.w  d0,a0                           ; a0 = start of gfx mask data
                    move.l  #$ffffffff,D0                   ; first word & last word mask
                    moveq   #$08,d4
                    sub.w   d6,d4                           ; d4 = shift value - d6 = scroll value bit shift (src gfx)
                    add.w   d4,d4                           ; multiply shift by 2 (co-ords stored halved in a byte)
                    lsr.w   d4,d0                           ; shift mask by sprite shift value
                    swap.w  d0                              ; swap to high word (first word mask)
                    and.l   d0,d7                           ; d7 = first word mask, last word mask = #$ffff
                    ; x co-ord is +ve (on screen)
x_co_ord_positive
                    moveq   #$14,d4                         ; d4 = #$14 (20 decimal, width of display in words)
                    sub.w   d0,d4
                    ble.w   exit_draw_sprite                ; sprite is off screen (right hand side)
                    ; is sprite fully on screen (x axis) 
                    cmp.w   d4,d5
                    bls.b   calc_bltsize_and_modulos        ; L000057ce                       ; sprite is all on screen
                    ; clip sprite right hand side
                    move.w  d4,d5                           ; update sprite width
                    move.l  #$ffffffff,D4                   ; firat word & last word mask
                    lsl.w   d6,d4                           ; d6 = bit shift (src gfx)
                    lsl.w   d6,d4                           ; d6 = bit shift (src gfx)
                    move.w  d4,d7                           ; set last word mask - d7 = first word mask & last word mask


                    ; plot sprite positions
                    ; d0 = X Position
                    ; d2 = width of sprite (bytes)
                    ; d1 = start raster of sprite display - Y co-ord
                    ; d3 = last raster of sprite display  - Y + height
                    ; a0 = start address offset of gfx mask data
                    ; d6 = shift value / 2
                    ; d5 = sprite width (clipped)
                    ; d7 = Firstword & Lastword mask
calc_bltsize_and_modulos                            ; original address L000057ce
                    asl.w   #$06,d3                 ; shift sprite height << 6 (blitsize)
                    add.w   d5,d3                   ; d3 = bltsize - add blit with to bltsize
                    sub.w   d5,d2                   ; d2 = subtract blit width from sprite width
                    add.w   d2,d2                   ; d2 = source sprite modulo
                    moveq   #$15,d4                 ; screen buffer width (21 words)
                    sub.w   d5,d4                   ; subtract blit width (words)
                    add.w   d4,d4                   ; d4 = screen width modulo (words * 2)

                    ; d3 = blit size
                    ; d2 = source modulo
                    ; d4 = destination modulo
                    ; d0 = x word offset
                    ; d1 = y line offset
                    ; Calc destination Ptr
calc_dest_ptr                                               ; original address L000057dc
                    movea.l playfield_buffer_2,a2           ; L000036f6,a2
                    add.w   d0,d0                           ; d0 = d2 * 2 (x byte value)
                    adda.w  d0,a2
                    mulu.w  #$002a,d1                       ; d2 = d2 * 42 (y value)
                    adda.l  d1,a2                           ; a2 = destination address for blit.
calc_bltcons_shifts
                    ext.l   d6                              ; d6 = shift value - sign extend to long
                    ror.l   #$03,d6                         ; d6 = bit shift value (move shift value to top 3 bits of long word)
                    move.l  d6,d0                           ; copy d6 -> d0
                    swap.w  d0                              ; swap high/low words
                    or.l    d0,d6                           ; copy shift bits to top 3 bits of low word - bits 15-12 src b shift

                    ; d2 = source data modulo
                    ; d4 = dest data modulo
                    ; d6 = bltcon0 & bltcon1 (shift A & B) (top 3 bits of high word and low word)
                    ; d7 = first word mask & last word mask
                    ; a0 = gfx data ptr (starts with mask data)
                    ; a1 = offset to gfx data (size of mask data)
blit_sprite                                                 ; original address
                    movea.l #$00dff000,a5
                    or.l    #$0fca0000,d6                   ; D6 = BLTCON0 & BLTCON1 - apply minterms and chanel enable to shift bits
                                                            ;; No src A shift, use all DMA channels, Logic = $ca (cookie cutter)
                                                            ; use ABCD, D=AB+/AC
                                                            ; A = Mask
                                                            ; B = Source GFX
                                                            ; C = Dest GFX
                                                            ; D = Combined SRC & Dest
.initial_blit_wait                                                   
                    btst.b  #$0006,$00dff002                ; blit wait
                    bne.b   .initial_blit_wait              ; L00005802

                    move.w  d2,BLTAMOD(a5)                  ; $0064(a5)
                    move.w  d2,BLTBMOD(a5)                  ; $0062(a5)
                    move.l  d7,BLTAFWM(a5)                  ; $0044(a5)
                    move.w  d4,BLTCMOD(a5)                  ; $0060(a5)
                    move.w  d4,BLTDMOD(a5)                  ; $0066(a5)
                    move.l  d6,BLTCON0(a5)                  ; $0040(a5) & $0042(a5)
                    lea.l   (a0),a3                         ; copy a0 -> a3, a0 & a3 = gfx mask data

                    moveq   #$03,d7                         ; d7 = 4 bitplanes
                    ; bitplane blit loop
sprite_blit_loop                                            ; original address L00005828
.blit_loop_wait                                             ; original address L00005828
                    btst.b  #$0006,$00dff002
                    bne.b   .blit_loop_wait                 ; L00005828

                    lea.l   $00(a0,a1.L),a0                 ; a0 = gfx data (increase source gfx by sprite size)
                    move.l  a3,BLTAPT(a5)                   ;  $0050(a5) - A Channel = MASK GFX                  
                    move.l  a0,BLTBPT(a5)                   ;  $004c(a5) - B Channel = SPRTIE GFX
                    move.l  a2,BLTCPT(a5)                   ;  $0048(a5) ; C Channel = Dest GFX
                    move.l  a2,BLTDPT(a5)                   ;  $0054(a5) - D Channel = Dest GFX
                    move.w  d3,BLTSIZE(a5)                  ;  $0058(a5) - Start Blit
                    lea.l   $1c8c(a2),a2                    ; Increase Dest GFX prt for next bitplane.
                    dbf.w   d7,sprite_blit_loop             ; L00005828
exit_draw_sprite                                            ; original address L00005852
                    rts





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
L000058a4           move.b  d2,player_input_command                 ; L00006308
L000058a8           rts





L000058aa           clr.l   d0
L000058ac           move.w  L000067bc,d0                ; Pixel Offset Value? (updated_batman_distance_walked)
L000058b0           lsr.w   #$03,d0                     ; D0.w divide by 8 (d0 = byte offset)
L000058b2           add.w   d0,d0                       ; D0.w multiply by 2 (word offset)
L000058b4           movea.l #CODE1_CHIPMEM_BUFFER,a4          ; #$0005a36c,a4 ; External Address 
L000058ba           adda.l  d0,a4                       ; a4 = location in chip mem buffer (gfx base address?)
L000058bc           move.l  a4,L0000631e                ; SRC or DEST address

L000058c0           clr.w   L00006312
L000058c4           clr.l   d1
L000058c6           move.w  L000067bc,d1                ; Pixel Offset Value? (updated_batman_distance_walked)
L000058ca           moveq   #$14,d7                     ; counter = $15 + $1 = $16 (22 dec)
L000058cc           movem.l d1/d7/a4,-(a7)
L000058d0           bsr.w   draw_background_screen_horizontal ; L00004ad6                   ; a4 = chipmemptr, d1 = pixel offset, d7 = counter
L000058d4           movem.l (a7)+,d1/d7/a4
L000058d8           addq.w  #$08,d1                     ; increase Pixel Offset by 8 bits?
L000058da           addq.l  #$02,a4                     ; increase gfx ptr by 16 bits
L000058dc           dbf.w   d7,L000058cc
L000058e0           rts 



                    rsreset
char884_mask        rs.b    1
char884_bpl0        rs.b    1
char884_bpl1        rs.b    1
char884_bpl2        rs.b    1
char884_bpl3        rs.b    1


                    ; ----------------------- preprocess data ------------------------
                    ; various data preprocessing routines.
                    ;
preprocess_data                                         ; original address L000058e2
                    
                    ; --------------- preprocess font gfx ---------------
                    ; when this routine is skipped it doesn't make any
                    ; difference to the display of the 'AXIS CHEMICAL FACTORY'
                    ; display which this font is used to display.
preproc_font                                            ; original address L000058e2
                    move.w  #$013f,d7                   ; $140 (320 decimal) - total number of font raster lines
                    lea.l   large_character_gfx,a0
.loop
                    move.b  char884_bpl3(a0),d0
                    and.b   char884_bpl0(a0),d0
                    not.b   d0
                    and.b   char884_bpl1(a0),d0
                    and.b   char884_bpl3(a0),d0
                    eor.b   d0,char884_bpl0(a0)
                    addq.w  #$05,a0                     ; 5 byte structure.
                    dbf.w   d7,.loop                    ; 

                    ; ------ init map data ------
                    ; swaps 20 blocks of level data (192 bytes)
                    ; outermost to inner most blocks are swapped (41 blocks in total)
                    ; effewctively the blocks are reversed in order in memory.
                    ; e.g.
                    ;       A  -----> E
                    ;       B  -----> D
                    ;       C  -----> C (middle block not swapped)
                    ;       D  -----> B
                    ;       E  -----> A
                    ;
                    ; if there is an odd number of blocks (which there are here)
                    ; then the last block is not swapped (its the middle block)
                    ;
                    ; Block No  | Block A       | Block B
                    ;   1       | 807c - 813c   | 9e7c - 9f3c
                    ;   2       | 813c - 81fc   | 9dbc - 9e7c
                    ;   3       | 81fc - 82bc   | 9cfc - 9dbc
                    ;   4       | 82bc - 837c   | 9c3c - 9cfc
                    ;   5       | 837c - 843c   | 9b7c - 9c3c
                    ;   6       | 843c - 84fc   | 9abc - 9b7c
                    ;   7       | 84fc - 85bc   | 99fc - 9abc
                    ;   8       | 85bc - 867c   | 993c - 99fc
                    ;   9       | 867c - 873c   | 987c - 993c
                    ;   10      | 873c - 87fc   | 97bc - 987c
                    ;   11      | 87fc - 88bc   | 96fc - 97bc
                    ;   12      | 88bc - 897c   | 963c - 96fc
                    ;   13      | 897c - 8a3c   | 957c - 963c
                    ;   14      | 8a3c - 8afc   | 94bc - 957c
                    ;   15      | 8afc - 8bbc   | 93fc - 94bc
                    ;   16      | 8bbc - 8c7c   | 933c - 9efc
                    ;   17      | 8c7c - 8d3c   | 927c - 933c
                    ;   18      | 8d3c - 8dfc   | 91bc - 927c
                    ;   19      | 8dfc - 8ebc   | 90fc - 91bc
                    ;   20      | 8ebc - 8f7c   | 903c - 90fc
                    ;
                    ;middle data block
                    ;   21      | 8f7c - 903d - NOT SWAPPED (Middle Data Block)
                    ;
                    ; These blocks of data are level map blocks,
                    ; If this code does not run then the level map data is
                    ; foobar. Maybe the data is in a format suitable
                    ; for a different platform (atari st maybe?)
                    ;
preproc_mapdata                                                         ; original address L00005906
                    lea.l   MAPGR_BLOCK_PARAMS,a0                       ; $8002 - physical address inside MAPGR.IFF
                    move.w  (a0)+,d5                                    ; Data Block Size
                    move.w  (a0)+,d6                                    ; Total Number of Data Blocks
                    lea.l   MAPGR_PREPROC_BLOCK_OFFSET(a0),a0           ; $807c - physical address of data block params
                    move.b  $0028(a0),d0                                ; d0 = (80a4)
                    cmp.b   #$17,d0                                     ; test byte value (in data block)
                    bcc.b   preproc_display_object_data                 ; Has data already been swapped? - skip swap if d0 > #$17 (23)

                    move.w  d6,d0                                       ; d0 = Total Number of Level Data Blocks
                    subq.w  #$01,d0
                    mulu.w  d5,d0                                       ; Offset to last Data Block in file
                    lea.l   $00(a0,d0.L),a1                             ; a1 = $9e7c
                    lsr.w   #$01,d6                                     ; d6 = Number of Data Blocks / 2
                    subq.w  #$01,d6                                     ; d6 = loop counter (20)
.swap_data_block
                        move.w  d5,d4                                   ; d4 = Data Block Size
                        subq.w  #$01,d4                                 ; d4 = loop counter (192)
.swap_data_loop 
                            move.b  (a0),d0                             ; 
                            move.b  (a1),(a0)+                          ; Swap Bytes between Low Block & High Block
                            move.b  d0,(a1)+                            ; 
                        dbf.w   d4,.swap_data_loop 

                        suba.w  d5,a1                                   ; next block ptr
                        suba.w  d5,a1
                    dbf.w   d6,.swap_data_block                         ; swap next data block


                    ; Initialise list of 305 display objects
                    ; Create list at $10000 in physical memory
preproc_display_object_data                                             ; original address L00005942
                    movea.l sprite_array_ptr,a1                         ; a1 = $10000
                    movea.l #BATSPR1_BASE,a0                            ; a0 = $11002 - physical address in BATSPR1.IFF 
                    lea.l   display_object_coords,a2                    ; a2 = L0000607c

                    move.w  (a0)+,d7                                    ; d7 = $0131 (305), a0 = $11004
                    clr.l   d0
                    move.w  d7,d0                                       ; d0 = $0131 (305)
                    subq.w  #$01,d7                                     ; adjust loop counter ($130)
                    move.w  d7,d6                                       ; store loop counter for 2nd preprocess below ($130)

                    ; calc start of sprite gfx
                    asl.w   #$03,d0                                     ; d0 = $0131 * 8 = $988 (2440)
                    add.l   a0,d0                                       ; d0 = $11004 + $988 = $1198C
                    movea.l d0,a5                                       ; A5 = $1198C - start of gfx offset

                    ; loop through 10 byte struct
                    ; first 2 bytes ignored ($800f)
                    ; next 2 bytes X & Y co-ords
                    ; next 2 bytes width (words) & height (lines)
                    ; next 4 bytes gfx start offset from $1198c ($98c in file)
                    ;
.sprite_list_loop                                               ; original address $00005962
                        ; skip first 2 bytes ($800f)
                        lea.l   $0002(a0),a0                                ; skip first 2 bytes (#$800f) A0 = $11004 + $2 = $11006
                        ; store inital X 7 Y co-ords
                        move.w  (a2)+,(a1)+                                 ; store X & Y co-ords - copy words from $607c -> $10000 (byte 0-1) 
                        ; calc sprite width
                        move.b  (a0)+,d0                                    ; ($11006)+   d0 = $09
                        lsr.b   #$04,d0                                     ; d0 = d0 / 16
                        addq.w  #$01,d0                                     ; d0 = d0 + 1
                        move.b  d0,(a1)+                                    ; sprite width - store d0.b -> $10000 (byte 2)
                        ; calc sprite height
                        move.b  (a0)+,d0                                    ; ($11007)+  d0 = $09
                        addq.w  #$01,d0                                     ; d0 = d0 + 1
                        move.b  d0,(a1)+                                    ; sprite height - store d0.b -> $10000 (byte 3)
                        ; calc sprite gfx ptr
                        move.l  (a0)+,d0                                    ; ($11008)+  d0 = $00000000
                        add.l   a5,d0                                       ; $0001198c + $00000000
                        move.l  d0,(a1)+
                        ; do next display object
                    dbf.w   d7,.sprite_list_loop 


                    ; ------- another display object preprocessor loop --------
                    ; calculate the size of the sprite gfx data.
preproc_display_object_data_2
L00005980           move.w  d6,d7                       ; loop counter
L00005982           movea.l sprite_array_ptr,a2         ; a2 = display object array list
L00005986           clr.l   d2
L00005988           addq.w  #$02,a2                     ; skip X & Y co-ords
L0000598a           clr.w   d0
L0000598c           move.b  (a2)+,d0                    ; d0 = object width
L0000598e           clr.w   d1
L00005990           move.b  (a2)+,d1                    ; d1 = object height
L00005992           mulu.w  d1,d0                       ; d0 = number of words for bitplane?
L00005994           add.w   d0,d2                       ; d2 = accumulator of bitplane size?
L00005996           addq.w  #$06,a2                     ; next display object               
L00005998           dbf.w   d7,L0000598a

                    ; calc start of left facing sprite sheet
L0000599c           mulu.w  #$000a,d2                   ; d2 = size of display object gfx - Multiply by 10 (5 bitplanes, 2 bytes per word)
L000059a0           move.l  d2,sprite_gfx_offset        ; byte offset to be added to base sprite gfx ptr (for right facing sprites?)

L000059a4           movea.l sprite_array_ptr,a1         ; a1 = display object array list
L000059a8           movea.l $0004(a1),a1                ; get sprite gfx ptr of fisrt display object.
L000059ac           addq.w  #$01,a1     
L000059ae           btst.b  #$0000,(a1)                 ; test lsb of mask 1st word.
L000059b2           bne.w   L000059b8                   ; create right facing sprite sheet?
L000059b6           rts




                    ; create right facing sprite sheet?
L000059b8           move.w  d6,d7
L000059ba           movea.l sprite_array_ptr,a1     ; L000062fe,a1
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
L000059e0           movea.l #CODE1_DOUBLE_BUFFER_ADDRESS,a2
L000059e6           move.w  (a0)+,(a2)
L000059e8           not.w   (a2)
L000059ea           move.w  (a0)+,$00(a2,d4.W)
L000059ee           move.w  (a0)+,$00(a2,d3.W)
L000059f2           move.w  (a0)+,$00(a2,d2.W)
L000059f6           move.w  (a0)+,$00(a2,d1.W)
L000059fa           addq.w  #$02,a2                                 ; addaq.w
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
L00005a30           movea.l sprite_array_ptr,a1                     ; L000062fe,a1
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
L00005b0a           sub.w   L000067bc,d0                            ; updated_batman_distance_walked
L00005b0e           addq.w  #$02,$000a(a6)
L00005b12           movea.l $0008(a6),a5
L00005b16           move.w  (a5),d2
L00005b18           bpl.w   L000045bc
L00005b1c           bsr.w   double_buffer_playfield                 ; L000036fa
L00005b20           moveq   #$32,d0
L00005b22           bsr.w   wait_for_frame_count                    ; L00005e8c
L00005b26           bra.w   L00005e3a


L00005b2a           dc.w    $0001, $0001                            ; or.b #$01,d1
L00005b2e           dc.w    $0001, $0001                            ; or.b #$01,d1
L00005b32           dc.w    $0002, $0002                            ; or.b #$02,d2
L00005b36           dc.w    $0002, $0002                            ; or.b #$02,d2
L00005b3a           dc.w    $0003, $0003                            ; or.b #$03,d3
L00005b3e           dc.w    $0003, $0003                            ; or.b #$03,d3
L00005b42           dc.w    $0004, $0004                            ; or.b #$04,d4
L00005b46           dc.w    $0004, $0004                            ; or.b #$04,d4
L00005b4a           dc.w    $0002, $0002                            ; or.b #$02,d2
L00005b4e           dc.w    $0002, $0002                            ; or.b #$02,d2
L00005b52           dc.w    $0001, $0001                            ; or.b #$01,d1
L00005b56           dc.w    $0001, $0001                            ; or.b #$01,d1
L00005b5a           dc.w    $ffff                                   ; illegal


L00005b5c           move.w  #$0098,$0004(a6)                        ; $00dff004
L00005b62           lea.l   L000039c8,a5
L00005b66           move.w  #$0085,d2
L00005b6a           moveq   #$09,d7
L00005b6c           cmp.w   $0006(a5),d2                            ; $00bfd106,d2
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
L00005b8e           bne.b   L00005b8a                               ; jmp to rts above
L00005b90           jsr     AUDIO_PLAYER_INIT_SFX_1
L00005b96           bset.b  #PANEL_ST1_TIMER_EXPIRED,PANEL_STATUS_1 
L00005b9e           move.l  #L00005290,gl_jsr_address               ; Set game_loop Self Modifying Code JSR 
L00005ba4           clr.w   L000062fa
L00005ba8           clr.w   L00006318
L00005bac           move.w  $0004(a5),d0                            ; $00bfd104,d0
L00005bb0           cmp.w   #$00d4,d0
L00005bb4           bcs.b   L00005bd2
L00005bb6           move.w  #$0081,$0006(a5)                        ; $00bfd106
L00005bbc           move.l  #$00005b28,$0008(a5)                    ; $00bfd108
L00005bc4           move.w  #$0019,(a5)
L00005bc8           clr.w   (a6)
L00005bca           moveq   #SFX_SPLASH,d0
L00005bcc           jmp     AUDIO_PLAYER_INIT_SFX
                    ; uses rts in audio player


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
L00005c22           move.w  $0008(a6),d2
L00005c26           addq.b  #$04,d2
L00005c28           bcc.b   L00005c32
L00005c2a           moveq   #SFX_GASLEAK,d2
L00005c2c           bsr.w   play_proximity_sfx                      ; play sfx if d0 < 160 & d1 < 89
L00005c30           clr.w   d2
L00005c32           move.w  d2,$0008(a6)
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
L00005c68           moveq   #$03,d6                         ; Value of Energy to Lose (3 of 48)
L00005c6a           bra.w   batman_lose_energy              ; L00004ccc

L00005c6e           move.w  $000c(a6),d3            ; $00dff00c,d3
L00005c72           addq.b  #$06,d3
L00005c74           move.w  d3,$000c(a6)            ; $00dff00c
L00005c78           cmp.b   #$20,d3
L00005c7c           bcs.b   L00005c40
L00005c7e           moveq   #$01,d2
L00005c80           cmp.b   #$40,d3
L00005c84           bcs.w   L000045bc
L00005c88           move.w  $000a(a6),d5
L00005c8c           cmp.w   #$0010,d5
L00005c90           bcc.w   L00005c96
L00005c94           addq.w  #$01,d5
L00005c96           move.w  d5,$000a(a6)
L00005c9a           lsr.w   #$01,d5
L00005c9c           add.w   $0008(a6),d5
L00005ca0           move.w  d5,$0008(a6)
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
L00005cc0           eor.w   d2,$0002(a6)
L00005cc4           clr.l   $0008(a6)
L00005cc8           clr.w   $000c(a6)
L00005ccc           moveq   #SFX_DRIP,d2
L00005cce           bsr.w   play_proximity_sfx                      ; play sfx if d0 < 160 & d1 < 89
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
L00005cfa           moveq   #$02,d6                                 ; Value of Energy to Lose (2 of 48)
L00005cfc           bsr.w   batman_lose_energy
L00005d00           bra.b   L00005cbe
L00005d02           rts 


L00005d04           move.w  $0004(a6),d2
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
L00005d2c           btst.b  #$0000,playfield_swap_count+1           ; test even/odd playfield buffer swap value
L00005d32           beq.b   L00005d02
L00005d34           subq.w  #$01,$0004(a6)
L00005d38           bmi.b   L00005d82
L00005d3a           rts 


                    ; jack falls hits the vat?
L00005d3c           btst.b  #$0000,playfield_swap_count+1           ; test even/odd playfield buffer swap value
L00005d42           beq.b   L00005d54
L00005d44           movem.l d0-d1/a6,-(a7)
L00005d48           moveq   #SFX_SPLASH,d0
L00005d4a           jsr     AUDIO_PLAYER_INIT_SFX
L00005d50           movem.l (a7)+,d0-d1/a6
L00005d54           move.w  playfield_swap_count,d2
L00005d58           lsr.w   #$02,d2
L00005d5a           and.w   #$0003,d2
L00005d5e           addq.w  #$01,d2
L00005d60           bsr.w   L000045bc
L00005d64           sub.w   #$0010,d1
L00005d68           bpl.b   L00005d54
L00005d6a           lea.l   L000039c8,a5
L00005d6e           move.w  #$0103,d2
L00005d72           moveq   #$09,d7
L00005d74           cmp.w   $0006(a5),d2
L00005d78           beq.b   L00005d88
L00005d7a           lea.l   $0016(a5),a5
L00005d7e           dbf.w   d7,L00005d74
L00005d82           moveq   #$5a,d6                                 ; Value of Energy to Lose (90 of 48) - DEAD!
L00005d84           bra.w   batman_lose_energy


L00005d88           move.w  (a5),d2
L00005d8a           beq.b   L00005d82
L00005d8c           subq.w  #$01,d2
L00005d8e           bne.w   L00005d02
L00005d92           move.l  #L00005290,gl_jsr_address               ; L00003c90 ; Set Self Modifying Code JSR in game_loop
L00005d98           move.w  #$0021,(a5)
L00005d9c           clr.w   L00006318
L00005da0           move.w  #$ffff,L000062fa
L00005da6           move.b  #PANEL_ST1_VAL_TIMER_EXPIRED,PANEL_STATUS_1    ; Set TIMER EXPIRED 
L00005dae           rts


L00005db0           move.w  L000067bc,d2                                    ; updated_batman_distance_walked
L00005db4           cmp.w   #$0540,d2
L00005db8           beq.b   L00005dce
L00005dba               addq.w  #$02,$0002(a6)          ; $00dff002
L00005dbe               moveq   #$70,d2
L00005dc0               sub.w   d0,d2
L00005dc2               cmp.w   #$fffd,d2
L00005dc6               bcc.b   L00005dca
L00005dc8                   move.l  #$fffffffe,D2
L00005dca               add.w   d2,L000067c8

                    ; check level complete
L00005dce           cmp.w   #$0048,d1
L00005dd2           bcc.b   level_completed                                 ; d1 <= #$48 (72 dec) then Level Is Completed - L00005e26 

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
L00005e04           and.w   playfield_swap_count,d2
L00005e08           lsr.w   #$02,d2                     ; divide swap count by 4
L00005e0a           bne.b   L00005e0e                   ; frame swaps 4-7 - jmp $5e0e
L00005e0c           moveq   #$02,d2                     ; frame swaps 0-3 - do this
L00005e0e           addq.w  #$07,d2
L00005e10           bsr.w   L000045bc
L00005e14           jsr     AUDIO_PLAYER_SILENCE              ; Chem.iff - Music/SFX player - silence all audio - $00048004 ; External Address - CHEM.IFF
L00005e1a           move.l  #$00000210,d0
L00005e20           jmp     PANEL_ADD_SCORE             ; Panel Add Player Score (D0.l BCD value to add)- $0007c82a



                    ; ------------------------ level completed ------------------------
level_completed                                                     ; Original Address L00005e26
L00005e26           moveq   #$50,d1
L00005e28           moveq   #$0b,d2
L00005e2a           bsr.w   L000045bc
L00005e2e           bsr.w   double_buffer_playfield     ; L000036fa
L00005e32           bset.b  #PANEL_ST2_LEVEL_COMPLETE,PANEL_STATUS_2  ; Panel - Status 2 Bytes - bit #$0006 of $0007c875
                    ; ------ load level 2 ------
Load_level_2                                            ; original address L00005e3a
L00005e3a           jsr     AUDIO_PLAYER_SILENCE              ; Chem.iff - Music/SFX player - Silence all audio - $00048004
L00005e40           moveq   #$02,d0                     ; song number - 02 = Level completed
L00005e42           jsr     AUDIO_PLAYER_INIT_SONG            ; chem.iff - music/sfx - init sonng - d0.l = song number - $00048010 ; External Address - CHEM.IFF
L00005e48           move.w  #$00fa,d0
L00005e4c           bsr.b   wait_for_frame_count        ; L00005e8c
L00005e4e           moveq   #$64,d0
L00005e50           bsr.w   wait_for_frame_count        ; L00005e8c
L00005e54           bsr.w   clear_backbuffer_playfield  ; L00004e28
L00005e58           lea.l   text_jack_is_dead,a0        ; L00003abd,a0
L00005e5c           bsr.w   large_text_plotter          ; L000067ca 
L00005e60           bsr.w   screen_wipe_to_backbuffer   ; L00003cc0
L00005e64           moveq   #$64,d0
L00005e66           bsr.w   wait_for_frame_count        ; L00005e8c
L00005e6a           bsr.w   clear_backbuffer_playfield  ; L00004e28
L00005e6e           lea.l   text_the_joker_lives,a0     ; L00003acd,a0
L00005e72           bsr.w   large_text_plotter          ; L000067ca
L00005e76           bsr.w   screen_wipe_to_backbuffer   ; L00003cc0
L00005e7a           moveq   #$64,d0
L00005e7c           bsr.w   wait_for_frame_count        ; L00005e8c
L00005e80           bsr.w   screen_wipe_to_black        ; L00003cbc
L00005e84           bsr.w   panel_fade_out              ; L00003d8c
L00005e88           bra.w   LOADER_LEVEL_2              ; External Address - Loader $00000828 


                    ; wait for frame count
wait_for_frame_count
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
L00005eae           move.b  batman_sprite1_id+1,d2      ; L000062ee+1,d2
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
L00005f38           move.l  #L000053d6,gl_jsr_address           ; L00003c90 ; Set Self Modifying Code JSR in game_loop
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
L0000600c           moveq   #$02,d6                                 ; Value of Energy to Lose (2 of 48)
L0000600e           bsr.w   batman_lose_energy                      ; L00004ccc
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
L00006064           moveq   #$02,d6                             ; Value of Enegy to Lose (2 of 48)
L00006066           bsr.w   batman_lose_energy                  ; L00004ccc
L0000606a           move.w  #$001d,(a6)
L0000606e           move.w  #$e003,d2
L00006072           lsr.w   #$01,d4
L00006074           eor.w   d4,d2
L00006076           addq.w  #$01,d2
L00006078           bra.w   L000045bc

                    even


; Start of 305 (sprite x & y positions - initialisation data)
display_object_coords                                                               ; original address L0000607c
L0000607c           dc.w $2A02, $2005, $2005, $2004, $1505, $1506, $1506, $1507
L0000608C           dc.w $1507, $1506, $1507, $1507, $2C10, $2C08, $1402, $210D
L0000609C           dc.w $2B05, $1905, $2504, $1706, $1702, $2005, $0F06, $0006
L000060AC           dc.w $2405, $1507, $1C05, $1007, $1207, $1B03, $1308, $2C07
L000060BC           dc.w $2C07, $2C07, $2C07, $2904, $1A06, $03FE, $2902, $2008
L000060CC           dc.w $1306, $2A08, $2007, $2A04, $2A02, $24FA, $1405, $2A03
L000060DC           dc.w $2A08, $0F05, $0F05, $0F05, $0F05, $2A07, $1507, $1508
L000060EC           dc.w $1507, $1508, $0200, $0201, $0202, $0000, $0100, $0100
L000060FC           dc.w $0101, $0604, $0B07, $0F07, $0C07, $0B06, $2005, $1208
L0000610C           dc.w $1200, $2903, $2206, $2205, $2204, $1506, $1507, $1508
L0000611C           dc.w $1504, $1504, $1506, $1507, $1504, $2904, $25FD, $1305
L0000612C           dc.w $2904, $2CFD, $2904, $1BFD, $2004, $1CFD, $0C07, $2805
L0000613C           dc.w $1503, $1503, $1503, $1503, $0301, $0301, $0601, $0401
L0000614C           dc.w $0400, $04FD, $04FA, $1D05, $1108, $0809, $2903, $2006
L0000615C           dc.w $2005, $2004, $1506, $1507, $1508, $1504, $1504, $1506
L0000616C           dc.w $1507, $1504, $2906, $1306, $2A07, $2904, $2EFC, $2904
L0000617C           dc.w $25FB, $0C0F, $2211, $3416, $2C16, $2009, $1208, $0B08
L0000618C           dc.w $2903, $2005, $2004, $2004, $1505, $1506, $1507, $1503
L0000619C           dc.w $1504, $1505, $1506, $1503, $2903, $25FC, $1405, $0800
L000061AC           dc.w $0303, $2904, $1BFD, $2004, $1CFD, $0C07, $2004, $1207
L000061BC           dc.w $0B07, $2904, $2006, $2005, $2004, $1506, $1507, $1508
L000061CC           dc.w $1504, $1504, $1506, $1507, $1504, $2904, $25FD, $1405
L000061DC           dc.w $2B04, $2FFD, $2904, $18FC, $2004, $1CFD, $0C07, $2806
L000061EC           dc.w $1803, $1803, $1803, $1803, $0000, $0000, $0000, $0000
L000061FC           dc.w $0000, $0908, $0908, $0908, $0808, $1D05, $1308, $0809
L0000620C           dc.w $2904, $2006, $2005, $2004, $1506, $1507, $1508, $1504
L0000621C           dc.w $1504, $1506, $1507, $1503, $2904, $25FD, $1505, $2B04
L0000622C           dc.w $2FFE, $2904, $19FD, $2202, $1EFC, $1005, $2805, $1504
L0000623C           dc.w $1504, $1504, $1504, $2906, $1503, $1503, $1503, $1503
L0000624C           dc.w $1505, $0A08, $0009, $2903, $2005, $2004, $2004, $1405
L0000625C           dc.w $1406, $1407, $1404, $1404, $1405, $1406, $1402, $2906
L0000626C           dc.w $1506, $2906, $2A07, $2903, $2EFC, $2903, $24FC, $2004
L0000627C           dc.w $2004, $2004, $2004, $2706, $1304, $1304, $1304, $1303
L0000628C           dc.w $190B, $0F09, $120D, $130D, $1309, $0B0F, $1D05, $1208
L0000629C           dc.w $0808, $2903, $2005, $2004, $2004, $1405, $1406, $1407
L000062AC           dc.w $1404, $1404, $1405, $1406, $1402, $2903, $25FD, $1306
L000062BC           dc.w $2B04, $2FFD, $2903, $18FC, $2202, $1EFC, $1005, $2805
L000062CC           dc.w $1504, $1504, $1504, $1504, $2906, $1503, $1503, $1503 
L000062dc           dc.w $1503
; End of 305 (sprite x & y positions - initialisation data)

L000062de           dc.w $0001, $0002, $0003, $0004, $0005, $0007



batman_sprite3_id                                       ; original address L000062ea
L000062ea           dc.w $0005                          ; batman sprite id 3 (0 = do not display 3)
batman_sprite2_id                                       ; original address L000062ec
L000062ec           dc.w $0002                          ; batman sprite id 2 (0 = do not display 2,3)
batman_sprite1_id                                       ; original address L000062ee
L000062ee           dc.w $0001                          ; batman sprite id 1 (0 = do not display 1,2,3)

L000062f0           dc.w $0000                          ; batman (some kind of updated Y co-ordinate? set in draw_batman_and_rope routine)
                    

L000062f2           dc.w $0000
L000062f4           dc.w $0000
L000062f6           dc.w $0000
L000062f8           dc.w $0000
L000062fa           dc.w $0001      

L000062fc           dc.w $0000


                    ; refernced by draw_sprite
sprite_array_ptr                        ; original address L000062fe
L000062fe           dc.l $00010000      ; ptr to an array of sprite definition data structures
                                        ; structure def:
                                        ;  byte offset | description
                                        ;           0  | Y Offset
                                        ;           1  | X Offset
                                        ;           2  | Width in Words
                                        ;           3  | Height in Lines
                                        ;         4-7  | Long Pointer to GFX Data (Mask, BPL0, BPL1, BPL2, BPL3)

sprite_gfx_offset                       ; original address
L00006302           dc.l $00000000      ; appears to be an address offset value added to the base sprite data for left had facing sprites
                                        ; used in draw_sprite
L00006304           dc.w $0000
L00006306           dc.w $0000

player_input_command
L00006308           dc.b $00                        ; value range 0 - 31 used by player_move_commands (main game loop)
                                                    ; to identify commad to process.

L00006309           dc.b $00

L0000630a           dc.l $0000A07C                  ; base level gfx ptr?

L0000630e           dc.w $0000
L00006310           dc.w $0000
L00006312           dc.w $0000                      ; Y co-ord
L00006314           dc.w $0000
L00006316           dc.w $0000
L00006318           dc.w $0000
L0000631a           dc.w $0000 
L0000631c           dc.w $0034
L0000631e           dc.w $0005
L00006320           dc.w $A36C
L00006322           dc.w $0000
L00006324           dc.w $3DFE
batman_sprite_anim_00                                               ; a 3 byte batman sprite array
L00006326           dc.w $0000
L00006328           dc.w $0000
L0000632a           dc.w $0000   

playfield_swap_count                                                ; original address L0000632c
                    dc.w $0000                                      ; word value incremented when playfield buffers are swapped


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

                    ; sprite 3 array structure
                    ; byte 0 = initial sprite id
                    ; byte 1 = second sprite offset
                    ; byte 2 = third sprite offset
batman_sprite_anim_01
L000063d0           dc.b $30,$D2,$04                        ; 48, 02, 06
batman_sprite_anim_02
L000063d3           dc.b $01,$02,$07                        ; 01, 03, 10
batman_sprite_anim_03
L000063d6           dc.b $19,$01,$E6                        ; 25, 26, 00
batman_sprite_anim_04
L000063d9           dc.b $1E,$01,$E1                        ; 30, 31, 00

L000063DC           dc.w $1901
L000063de           dc.w $E619, $01E6, $1901, $E61B, $01E4, $1B01 ,$E41B         ;................
L000063EC           dc.w $01E4, $1B01, $E41B, $01E4, $1B01, $E41B, $01E4 ,$1B01         ;................
L000063FC           dc.w $E41D, $E300, $1DE3, $001D, $E300, $1DE3, $001D ,$E300         ;................
L0000640C           dc.w $1DE3, $001D
L00006410           dc.w $E300, $1DE3, $0000

batman_sprite_anim_07
L00006416           dc.b $24, $01, $01                      ; 36, 37, 38
batman_sprite_anim_08
                    dc.b $27, $01, $01                      ; 39, 40, 41
                    
L0000641C           dc.w $2A01, $FE2C, $FDD7, $2D01, $0100, $1301, $0116 ,$0101         ;*..,..-.........
L0000642C           dc.w $001B

                    ; referenced during game_start
                    ; appears to be a data structure where word at offet 4 is a multiple of 6 bytes to start of next structure.
                    ; each line of data below appears to be the start of a variable length data structure.
                    ; 
                    ; The MSB of byte offset 0 is a flag which is reset at level start.
                    ;
                    ;    0      2      4      6
                    ;                  offset
                    ;                   x 6
L0000642e           dc.w $02C1, $0081, $0001, $0022, $0240, $00C0 
                    dc.w $0040, $00F0, $0002, $0003, $00C0, $0118, $000F, $00A0 ,$0118
                    dc.w $0040, $00E2, $0001, $0002, $0008, $00D8
                    dc.w $00A8 ,$00F0, $0003, $000E, $0010, $0118, $000F, $00C8, $0118 ,$000F, $00C8, $0138
                    dc.w $00E0, $00F0, $0001, $000F, $00F0 ,$00D8
                    dc.w $00E0, $00A7, $0001, $0003, $0080, $0098
                    dc.w $0038 ,$0078, $0001, $000E, $0008, $0098
                    dc.w $0024, $0078, $0001 ,$000F, $00C8, $0098
                    dc.w $0040, $001F, $0001, $0003, $00B0 ,$0018
                    dc.w $00A8, $0010, $0003, $000E, $0008, $0018, $000F ,$00D0, $0018, $000F, $00D0, $0038
                    dc.w $00D8, $0040, $0003 ,$000E, $0008, $0018, $000F, $00F0, $0018, $000F, $00F0 ,$0058
                    dc.w $0128, $0040, $0002, $000E, $0140, $0078, $000E ,$0088, $0018
                    dc.w $0178, $0040, $0002, $0003, $0190, $0038 ,$000F, $01B0, $0018
                    dc.w $01BC, $0011, $0002, $000F, $01D0 ,$0018, $000F, $01B0, $0078
                    dc.w $0168, $00B0, $0002, $000F ,$0160, $00F8, $0003, $0150, $0118
                    dc.w $0190, $0111, $0002 ,$000E, $0138, $0138, $000F, $0178, $0138
                    dc.w $01E8, $0100 ,$0004, $000F, $0150, $0118, $000F, $0140, $0138, $000E ,$0200, $0138, $0003, $0220, $0118
                    dc.w $0220, $00EF, $0002 ,$000F, $0188, $00B8, $000F, $0200, $00D8
                    dc.w $0240, $003B ,$0001, $000F, $0250, $0038
                    dc.w $0280, $007B, $0001, $000E ,$0250, $0098
                    dc.w $02B0, $0071, $0001, $000F, $02D0, $00B8
                    dc.w $02F0, $0071, $0002, $000E, $0258, $0098, $000F, $0300 ,$0078
                    dc.w $02E0, $00C2, $0003, $000E, $0250, $00D8, $000F, $0250, $00F8, $000F, $0300, $00D8
                    dc.w $025C, $00CF, $0003, $000F, $0300, $00D8, $000F, $02E8, $0118, $000F, $0230, $00D8
                    dc.w $02F8, $0120, $0003, $000E, $0250, $0118, $000E, $0250, $0138, $000F, $0320, $0138
                    dc.w $0318, $0120, $0003, $000E, $0340, $0138, $0003, $0260, $0118, $000F, $0260, $0138
                    dc.w $0360, $0118, $0002, $000F, $0378, $00F8, $000F, $0378, $0118
                    dc.w $02F0, $0048, $0003, $000F, $0288, $0038, $000E, $0310, $0038, $000F, $0288, $0018
                    dc.w $0360, $0038, $0001, $0003, $0370, $0018
                    dc.w $03B0, $00B0, $0002, $0003, $03C0, $00B8, $000F, $03E0, $00D8
                    dc.w $03F0, $0102, $0001, $000E, $03C0, $0138
                    dc.w $0450, $00F2, $0003, $000E, $03B8, $0138, $000F, $0460, $0138, $0003, $0470, $00F8
                    dc.w $0468, $00C6, $0001, $0003, $0470, $00B8
                    dc.w $0468, $00A6, $0001, $000E, $0400, $0078
                    dc.w $03A0, $0050, $0001, $000F, $0440, $0098
                    dc.w $03D0, $0020, $0001, $000F, $0420, $0018
                    dc.w $0430, $0001, $0002, $000F, $0450, $0018, $000F, $0440, $0038
                    dc.w $0480, $0012, $0002, $0003, $0490, $0058, $000E, $03E0, $0018
                    dc.w $04B8, $0093, $0001, $0002, $04A4, $00B8
                    dc.w $04D8, $0110, $0002, $000E, $04A4, $0138, $000F, $0500, $0118
                    dc.w $0530, $00F0, $0001, $0003, $0580, $00F0
                    dc.w $05B0, $00C8, $0002, $000F, $0540, $00B8, $000F, $0580, $00B8
                    dc.w $0580, $0090, $0002, $000E, $0568, $0078, $000F, $0568, $0078
L0000670a           dc.w $0574, $0030, $0003, $0018, $0520, $0018, $0017, $0580, $0018, $0002, $0530, $0018

                    ; 3 word/ 6 byte data structure list
                    ; MSB of byte 0 is cleared on game_start
L00006722           dc.w $0014, $0118, $0038
                    dc.w $0015, $00D0, $0028
                    dc.w $0014, $0070, $0068
                    dc.w $0014, $01B0, $0110
                    dc.w $0014, $01F0, $0038
                    dc.w $0015, $01EF, $0078
                    dc.w $0015, $0217, $0028
                    dc.w $0014, $0270, $0060
                    dc.w $0016, $0298, $0090
                    dc.w $0014, $0310, $0120
                    dc.w $0016, $0378, $0038
                    dc.w $0014, $0378, $0098
                    dc.w $0014, $0398, $0090
                    dc.w $0015, $0400, $0130
                    dc.w $0014, $0458, $0078
                    dc.w $0015, $04EC, $0064
                    dc.w $0014, $03C8, $0030
                    dc.w $0014, $03D8, $0030
                    dc.w $0014, $0510, $0100
                    dc.w $0014, $0570, $0108
                    dc.w $0014, $0578, $0108

                    ; 7 words copied into L000067bc (level_parameters) on game_start
default_level_parameters                                                        ; original address L000067a0
L000067a0           dc.w $0000, $00F0, $0000, $0050, $0048, $0048

L000067AC           dc.w $0050, $0200, $0000, $0200, $0050, $0038, $0038, $0050         ;.P.......P.8.8.P


                    ; 7 words from L000067a0 (default_level_parameters) copied here on game_start
level_parameters                            ;               original address L000067bc
updated_batman_distance_walked              ;               original address L000067bc
L000067bc           dc.w $0000
L000067be           dc.w $00F0
batman_distance_walked                      ;               original address L000067c0
L000067c0           dc.w $0000              ; value that keep track of Batman's distance walked through the level

L000067c2           dc.w $0050              ; 
L000067c4           dc.w $0048
L000067c6           dc.w $0048
L000067c8           dc.w $0050



                    even




                ; -------------------------- Large Text Plotter --------------------------
                ; Use to display large text on black background at:-
                ; - Start Level
                ; - Game Over
                ; - Time Up
                ; - Level Completed
                ; 
                ; Uses an 8*8 font to display 8*16 font by doubling the font height.
                ;
                ; Data structure:
                ; raster line (y co-ord), byte offset (x co-ord), null terminated string
                ; raster line, byte offset, null terminated string
                ; ...
                ; terminate print loop
                ;
                ;   e.g
                ;   dc.b $50,$10        -- (Y,X co-ords)
                ;   dc.b 'DISPLAY STRING'
                ;   dc.b $00,$ff        -- Terminator
                ;
large_text_plotter                                                  ; original address L000067ca
.lpt_new_line                                                       ; original address L000067ca
                    move.b  (a0)+,d0                                ; Get raster/display line
                    bmi.w   .exit                                   ; L0000689e ; if negative then exit routine
                    and.w   #$00ff,d0
                    mulu.w  #$002a,d0                               ; d0 = byte offset for display line
                    move.b  (a0)+,d1                                ; d1 = raster/line byte offset
                    ext.w   d1
                    add.w   d1,d0                                   ; d0 = total display location byte offset
                    movea.l playfield_buffer_2,a1                   ; a1 = back buffer
                    lea.l   $00(a1,d0.W),a1                         ; a1 = address of display offset.
                    ; plot next character
.plot_loop                                                          ; original address
                    moveq   #$00,d0
                    move.b  (a0)+,d0                                ; d0 = ascii value?
                    beq.b   .lpt_new_line                           ; L000067ca ; if 0 then get new x & y position
                    cmp.b   #$20,d0                                 ; #$20 (32 decimal) - ASCII Space?
                    beq.w   .increase_cursor                        ; L00006896
                    move.l  #$ffffffcd,D1                           ; #$cd (-51 decimal)
                    cmp.b   #$41,d0                                 ; #$41 (65 decimal) - ASCII 'A'
                    bcc.b   .calc_src_gfx_ptr_1                     ; L00006822
                    move.l  #$ffffffd4,D1                           ; #$d4 (-44 decimal)
                    cmp.b   #$30,d0                                 ; #$30 (48 decimal) - ASCII '0'
                    bcc.b   .calc_src_gfx_ptr_1                     ; L00006822
                    moveq   #$00,d1
                    cmp.b   #$21,d0                                 ; #$21 (33 decimal) - ASCII '!'
                    beq.b   .calc_src_gfx_ptr_2                     ; L00006828
                    moveq   #$01,d1
                    cmp.b   #$28,d0                                 ; #$28 (40 decimal) - ASCII '('
                    beq.b   .calc_src_gfx_ptr_2                     ; L00006828
                    moveq   #$02,d1
                    cmp.b   #$29,d0                                 ; #$29 (41 decimal) - ASCII ')'
                    beq.b   .calc_src_gfx_ptr_2                     ; L00006828
                    moveq   #$03,d1
                    bra.b   .calc_src_gfx_ptr_2                     ;L00006828

                    ; adjust char index by value in d1
.calc_src_gfx_ptr_1                                                 ; original address L00006822
                    add.b   d0,d1                                   ; adjust initial char id (sub 51 for alph, sub 44 for numeric)
                    and.w   #$00ff,d1

                    ; muliply char index by size of char
                    ; add to base to get src gfx ptr
.calc_src_gfx_ptr_2                                                 ; original address L00006828
                    mulu.w  #$0028,d1                               ; #$28 (40 decimal) (source gfx size)
                    lea.l   large_character_gfx,a2                  ; L000068a0,a2 ; source gfx ptr
                    lea.l   $00(a2,d1.W),a2                         ;  == $0006d7e7,a2

                    ; a1 = gfx src ptr
                    ; a3 = display dest ptr
.draw_character                                                     ; original address L00006836
                    moveq   #$07,d7                                 ; loop count 7+1 = 8
                    movea.l a1,a3
.draw_loop                                                          ; original address L0000683a
                    ; print character line
                    ; mask
                    move.b  (a2)+,d1                                ; d1 = mask byte
                    ; bpl0
                    and.b   d1,(a3)
                    move.b  (a2)+,d2                                ; bpl0 = char data
                    or.b    d2,(a3)
                    ; bpl1
                    and.b   d1,$1c8c(a3)        
                    move.b  (a2)+,d2
                    or.b    d2,$1c8c(a3) 
                    ; bpl2
                    and.b   d1,$3918(a3)
                    move.b  (a2)+,d2
                    or.b    d2,$3918(a3)
                    ; bpl3
                    and.b   d1,$55a4(a3)
                    move.b  (a2)+,d2
                    or.b    d2,$55a4(a3)

                    ; repeat character line
                    ; double size of character to 16 rasters high
                    lea.l   $002a(a3),a3                            ; increase display ptr 1 line (42 bytes)
                    lea.l   -$0005(a2),a2                           ; reset gfx ptr to start of src gfx data
                    
                    ; mask
                    move.b  (a2)+,d1
                    ; bpl0
                    and.b   d1,(a3)
                    move.b  (a2)+,d2
                    or.b    d2,(a3)
                    ; bpl1
                    and.b   d1,$1c8c(a3)
                    move.b  (a2)+,d2
                    or.b    d2,$1c8c(a3)
                    ; bpl2
                    and.b   d1,$3918(a3)
                    move.b  (a2)+,d2
                    or.b    d2,$3918(a3)
                    ; bpl3
                    and.b   d1,$55a4(a3)
                    move.b  (a2)+,d2
                    or.b    d2,$55a4(a3)

                    lea.l   $002a(a3),a3                            ; increase display ptr 1 line (42 bytes)
                    dbf.w   d7,.draw_loop 
.increase_cursor 
                    lea.l   $0001(a1),a1                
                    bra.w   .plot_loop                              ; L000067e8
.exit 
                    rts 



                    ;----------------------------- large character font --------------------------------
                    ; Its actually an 8x8 pixel interleaved font in 4 bitplanes and a mask.
                    ; The large_text_plotter expands the font in the Y direction to double its height.
                    ; 
                    ; Source gfx for font data
                    ; Interleaved gfx 
                    ; 5 byte sequences of data (mask, bpl0, bpl2, bpl3, bpl4)
                    ;
large_character_gfx                                     ; original address L000068a0
                    include font8x8x4.s

