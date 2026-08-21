
               ; Original File Name:     PANEL.IFF
               ; Original Load Address: $7C7FC-$80000
               ;
               ; This is the program that controls the game status panel at the
               ; bottom of the game play area.
               ;
               ; It is loaded into memory along side the title screen and it remains
               ; memory resident for the life-time of the game.
               ;
               ; It exposes various 'public' methods/functions that enable the game/titles
               ; to keep track of the player lives, energy levels, score and high-score
               ;
               ; It also exposes various 'public' data values that enable the game/titles
               ; to extract and react to the player/game status bits and other values.
               ;
               ; Public Methods:
               ;    PUBLIC void PANEL_Update(void)
               ;    PUBLIC void PANEL_Init_Timer(d0.w = timerValueBCD)
               ;    PUBLIC void PANEL_Init_Player_Score(void)
               ;    PUBLIC void PANEL_Update_Player_Score(d0.l = scoreAmount)
               ;    PUBLIC void PANEL_Init_Player_Lives(void)
               ;    PUBLIC void PANEL_Add_Extra_Life(void)
               ;    PUBLIC void PANEL_Init_Player_Energy(void)
               ;    PUBLIC void PANEL_Player_Lose_Life(void)
               ;    PUBLIC void PANEL_Reduce_Player_Energy(d0.w = damageValue)
               ;
               ; Public Data:
               ;    PANEL_STATUS_1                - PANEL_StatusByte_01                   - Bit field game status byte
               ;    PANEL_STATUS_2                - PANEL_StatusByte_02                   - Bit field game status byte
               ;    PANEL_LIVES_COUNT             - PANEL_Player_Lives_Count              - Number of Player Lives      
               ;    PANEL_HISCORE                 - PANEL_HighScore_BCD                   - 4 bytes BCD representation of high-score
               ;    PANEL_SCORE                   - PANEL_PlayerScore_BCD                 - 4 bytes BCD representation of player score
               ;    PANEL_FRAMETICK               - PANEL_frame_tick_counter              - 50hz count down counter (50 to 0)     
               ;    PANEL_TIMER_UPDATE_VALUE      - PANEL_clock_timer_update_amount_BCD   - BCD value to subtract from the timer
               ;    PANEL_TIMER_VALUE             - PANEL_clock_timer_minutes_BCD         - BCD representation of current level timer value (also byte for timer minutes byte value)
               ;    PANEL_TIMER_SECONDS           - PANEL_clock_timer_seconds_BCD         - BCD byte representing the level timer seconds value 
               ;    PANEL_SCORE_UPDATE_VALUE      - PANEL_player_score_update_value_BCD   - BCD representation of value to add to the player score
               ;    PANEL_SCORE_DISPLAY_VALUE     - PANEL_player_score_display_value_BCD  - BCD representation of the player score
               ;    PANEL_ENERGY_VALUE            - PANEL_player_energy_level             - integer value of player energy (40 = full, 0 = empty)
               ;    PANEL_HIT_DAMAGE              - PANEL_player_hit_damage_amount        - accumulated value to be subtracted from player energy (amount still to be subracted)    
               ;
               ; Public Resources: (gfx, energy meter, lives icons)
               ;    PANEL_GFX                     - PANEL_background_gfx             - Address ptr to Panel Background GFX (320x48 - 4 bitplane panel background gfx)
               ;    PANEL_BATMAN_GFX              - PANEL_batman_energy_gfx          - Batman Energy GFX (64x41 pixels, 4 bitplanes. 1312 Bytes)
               ;    PANEL_JOKER_GFX               - PANEL_joker_energy_gfx           - Joker Energy GFX (64x41 pixels, 4 bitplanes. 1312 Bytes)
               ;    PANEL_SCORE_GFX               - PANEL_score_digits_gfx           - Score Numeric Character Set - 16 x 7 pixels, 4 bitplanes, 10 characters - 560 bytes     
               ;    PANEL_LIVES_ON_GFX            - PANEL_batman_lives_icon_on_mask  - mask: 32 x 13 = 56 byte, image: 32 x 13, 4 bitplanes = 208 bytes   
               ;    PANEL_LIVES_OFF_GFX           - PANEL_batman_lives_icon_off_mask - mask: 32 x 13 = 56 byte, image: 32 x 13, 4 bitplanes = 208 bytes


;INFINITE_ENERGY_CHEAT   SET 1                           ; if defined then the 'JAMMMM' cheat also gives infinite energy.


                section panel_iff,code_c

            IFND    TEST_BUILD_LEVEL
                org     $7C7FC                                      ; original load address
            ENDC

;-----------------------------------------
; Status Bytes 01 & 02 Bit Definitions
;-----------------------------------------
PANEL_SB01_TIMER_EXPIRED       equ  0              ; 1 = level timer has exprired
PANEL_SB01_NO_LIVES_REMAINING  equ  1              ; 1 = player has no lives left
PANEL_SB01_PLAYER_LIFE_LOST    equ  2              ; 1 = player life has been lost

PANEL_SB01_VAL_TIMER_EXPIRED       equ  2^PANEL_SB01_TIMER_EXPIRED
PANEL_SB01_VAL_NO_LIVES_REMAINING  equ  2^PANEL_SB01_NO_LIVES_REMAINING
PANEL_SB01_VAL_PLAYER_LIFE_LOST    equ  2^PANEL_SB01_PLAYER_LIFE_LOST

PANEL_SB02_MUSIC_SFX           equ  0              ; Music/FX selection
PANEL_SB02_GAME_OVER           equ  5              ; 1 = Game Over
PANEL_SB02_GAME_COMPLETED      equ  6              ; 1 = Game Successfully Completed
PANEL_SB02_CHEAT_ACTIVE        equ  7              ; 1 = Infinite Lives Cheat Active


;******************************************************
; TODO: Check use of the below through shared code
;       replace with the above and remove
;******************************************************
; PANEL_StatusByte_01 - Bit Numbers
PANEL_ST1_TIMER_EXPIRED         EQU $0                                                          ; panel status 1 - bit 0 - Timer Expired
PANEL_ST1_NO_LIVES_LEFT         EQU $1                                                          ; panel status 1 - bit 1 - No Lives Remaining
PANEL_ST1_LIFE_LOST             EQU $2                                                          ; panel status 1 - bit 2 - Player Life Lost
; Panel Status1 Bit Values
PANEL_ST1_VAL_TIMER_EXPIRED     EQU 2^PANEL_ST1_TIMER_EXPIRED                                   ; panel status 1 - bit value/mask for Timer Expired
PANEL_ST2_VAL_NO_LIVES_LEFT     EQU 2^PANEL_ST1_NO_LIVES_LEFT                                   ; panel status 1 - bit value/mask for No Lives Left 
PANEL_ST2_VAL_LIFE_LOST         EQU 2^PANEL_ST1_LIFE_LOST                                       ; panel status 1 - bit value/mask for Life Lost 

; PANEL_StatusByte_02 Bit Numbers
PANEL_ST2_MUSIC_SFX             EQU $0                                                          ; panel status 2 - bit 0 - Music/SFX selector bit
PANEL_ST2_GAME_OVER             EQU $5                                                          ; panel status 2 - bit 5 - Is Game Over
PANEL_ST2_LEVEL_COMPLETE        EQU $6                                                          ; panel status 2 - bit 6 - Is Level Complete
PANEL_ST2_CHEAT_ACTIVE          EQU $7  



;---------------------------------------------------------
; Panel function and data address constants
; used to define absolute addresss for production builds
;---------------------------------------------------------
                IFND TEST_BUILD_LEVEL
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
                    ENDC


;---------------------------------------------------------
; Panel function and data address constants
; used to define relative addresss for dev/test builds
;---------------------------------------------------------
                    IFD TEST_BUILD_LEVEL
; Panel Constants - original function addresses
PANEL_UPDATE                    EQU PANEL_Update                           ; called on VBL to update panel display
PANEL_INIT_TIMER                EQU PANEL_Init_Timer                       ; initialise level timer (D0.w = BCD encoded MIN:SEC)
PANEL_INIT_SCORE                EQU PANEL_Init_Player_Score                ; initialise player score
PANEL_ADD_SCORE                 EQU PANEL_Update_Player_Score              ; add value to player score (D0.l = BCD encoded value)
PANEL_INIT_LIVES                EQU PANEL_Init_Player_Lives                ; initialise player lives
PANEL_ADD_LIFE                  EQU PANEL_Add_Extra_Life                   ; add 1 to player lives
PANEL_INIT_ENERGY               EQU PANEL_Init_Player_Energy               ; initialise player energy to full value
PANEL_LOSE_LIFE                 EQU PANEL_Player_Lose_Life                 ; sub 1 from player lives, check end game, set status bytes
PANEL_LOSE_ENERGY               EQU PANEL_Reduce_Player_Energy             ; reduce player energy (increase hit damage) D0.w = amount to lose
; Panel Constants - original data value addresses
PANEL_STATUS_1                  EQU PANEL_StatusByte_01                    ; Game Status Bits
PANEL_STATUS_2                  EQU PANEL_StatusByte_02                    ; Game Status Bits
PANEL_LIVES_COUNT               EQU PANEL_Player_Lives_Count               ; player lives left
PANEL_HISCORE                   EQU PANEL_HighScore_BCD                    ; hi-score BCD value
PANEL_SCORE                     EQU PANEL_PlayerScore_BCD                  ; player score BCD value
PANEL_FRAMETICK                 EQU PANEL_frame_tick_counter               ; counts down from 50 to 0 on each update
PANEL_TIMER_UPDATE_VALUE        EQU PANEL_clock_timer_update_amount_BCD    ; Timer BCD update value
PANEL_TIMER_VALUE               EQU PANEL_clock_timer_minutes_BCD          ; Timer BCD value Min:Sec (word)
PANEL_TIMER_SECONDS             EQU PANEL_clock_timer_seconds_BCD          ; Timer BCD seconds value
PANEL_SCORE_UPDATE_VALUE        EQU PANEL_player_score_update_value_BCD    ; player score update value
PANEL_SCORE_DISPLAY_VALUE       EQU PANEL_player_score_display_value_BCD   ; player score copy BCD value used for display
PANEL_ENERGY_VALUE              EQU PANEL_player_energy_level              ; player energy value (40 max value)
PANEL_HIT_DAMAGE                EQU PANEL_player_hit_damage_amount         ; player hit damge (subtracted from player energy on each panel update)
; Panel Constants - resources
PANEL_GFX                       EQU PANEL_background_gfx                   ; 320x48 - 4 bitplane panel background gfx
PANEL_BATMAN_GFX                EQU PANEL_batman_energy_gfx                ; batman energy image
PANEL_JOKER_GFX                 EQU PANEL_joker_energy_gfx                 ; joker energy image
PANEL_SCORE_GFX                 EQU PANEL_score_digits_gfx                 ; score digits gfx
PANEL_LIVES_ON_GFX              EQU PANEL_batman_lives_icon_on_mask        ; batman symbol - lives icon 'on'
PANEL_LIVES_OFF_GFX             EQU PANEL_batman_lives_icon_off_mask             ; batman symbol - lives icon 'off'
                ENDC


;---------------------------------------------------------
; Panel display constants
;---------------------------------------------------------
PANEL_DISPLAY_PIXELWIDTH        EQU $140                                                        ; 320 pixels wide
PANEL_DISPLAY_BYTEWIDTH         EQU PANEL_DISPLAY_PIXELWIDTH/8;                                 ; 40 bytes wide
PANEL_DISPLAY_LINEHEIGHT        EQU $30                                                         ; 48 Raster Lines High
PANEL_DISPLAY_BITPLANEBYTES     EQU PANEL_DISPLAY_BYTEWIDTH*PANEL_DISPLAY_LINEHEIGHT            ; 1920 bytes per bitplane
PANEL_DISPLAY_BITPLANEDEPTH     EQU $4                                                          ; 4 bitplanes - 16 colours
PANEL_DISPLAY_BYTESIZE          EQU PANEL_DISPLAY_BITPLANEBYTES*PANEL_DISPLAY_BITPLANEDEPTH
                                                        ; panel status 2 - bit 7 - Is Cheat Active





               ;--------------------- includes and constants ---------------------------
               INCDIR      "include"
               INCLUDE     "hw.i"

               ;-------------------------------- PANEL START ---------------------------
               ; original load address $7C7FC-$80000
               ; The original program starts with a longword of the address of the
               ; PANEL_Update method (i.e. the start of the code)
               ;
PANEL_START
               dc.l    PANEL_Update                        ; original value $0007C800 ; entry point address




               ;----------------------- PANEL UPDATE - $0007c800 -----------------------
               ; This routine is called every frame (50hz) as a main panel update for
               ; each game loop cycle.
               ; 
               ;    Original Address $0007c800
               ;
               ;    PUBLIC void PANEL_Update(void)
               ;
               ;    NOTES:
               ; Somehow this gets called more frequently on my 'cracked' version of the 
               ; game after completion of level 1, Not sure why/how yet, as it seems to 
               ; be tied to the level 3 interrupt handlers called for ever vbl.
               ; Something else seems to be adding extra calls to this make make the 
               ; timer run down slightly quicker in the cracked version.
               ;
PANEL_Update                                                       
               movem.l d0-d7/a0-a2,-(a7)
               bsr.w   _do_panel_update          ; calls $0007fc98
               movem.l (a7)+,d0-d7/a0-a2
               rts



               ;----------------------- INITIALISE LEVEL TIMER - $0007c80e -----------------------
               ; initialise the level timer to the value set in d0.w, pause the timer by clearing
               ; the update value.
               ; 
               ;   Original Address $0007c80e
               ;
               ;   PUBLIC void PANEL_Init_Timer(d0.w = timerValueBCD)
               ;
               ;        IN: D0.w  - timerValueBCD = Game Level Timer Value (BCD Minutes:Seconds)
               ;                  - high byte = BCD minutes
               ;                  - low byte  = BCD seconds
               ;
PANEL_Init_Timer      
               movem.l d0-d7/a0-a2,-(a7)
               bsr.w   _do_init_timer            ; calls $0007fc78
               movem.l (a7)+,d0-d7/a0-a2
               rts  




               ;----------------- INITIALISE PLAYER SCORE - $0007c81c ------------------
               ; Initialise the Player's Score, and display initial score value.
               ;
               ;   Original Address $0007c81c
               ;
               ;   PUBLIC void PANEL_Init_Player_Score(void)
               ;
PANEL_Init_Player_Score                                                       
               movem.l d0-d7/a0-a2,-(a7)
               bsr.w   _do_init_player_score     ; calls $0007fb40
               movem.l (a7)+,d0-d7/a0-a2
               rts



               ;------------------- UPDATE PLAYER SCORE - $007c82a -------------------
               ; Update the player's score, do extra life at every 100,000 points.
               ;
               ;    Original Address $007c82a
               ;
               ;    PUBLIC void PANEL_Update_Player_Score(d0.l = scoreAmount)
               ;
               ;         IN: d0.l  - scoreAmount = BCD encoded value to add to the score by.
               ;
PANEL_Update_Player_Score      
               movem.l d0-d7/a0-a2,-(a7)
               bsr.w   _do_update_player_score    ; calls $0007fb7e
               movem.l (a7)+,d0-d7/a0-a2
               rts  



               ;------------------ INITIALISE PLAYER LIVES  -------------------
               ; sets player lives to 2
               ; update the player lives icons on the panel.
               ;
               ;    Original Address: $0007c838
               ;
               ;    PUBLIC void PANEL_Init_Player_Lives(void)
               ;
PANEL_Init_Player_Lives 
               movem.l d0-d7/a0-a2,-(a7) 
               bsr.w   _do_init_player_lives     ; calls $0007f978
               movem.l (a7)+,d0-d7/a0-a2
               rts 



               ;----------------------- ADD EXTRA LIFE - $0007f95a -----------------------
               ; adds extra life to player lives count and updates the display panel.
               ;
               ;    Original Address $0007c846
               ;
               ;    PUBLIC void PANEL_Add_Extra_Life(void)
               ;
PANEL_Add_Extra_Life                                        
               movem.l d0-d7/a0-a2,-(a7)
               bsr.w   _do_add_extra_life        ; calls $0007f95a
               movem.l (a7)+,d0-d7/a0-a2
               rts



               ;------------------ INTIALISE PLAYER ENERGY - $0007c854 ------------------
               ; reset the player's energy to 'full'
               ; restores the panel display graphics ptrs for the energy meter
               ;
               ;   Original Address $0007c854
               ;
               ;   PUBLIC void PANEL_Init_Player_Energy(void)
               ;
PANEL_Init_Player_Energy       
               movem.l d0-d7/a0-a2,-(a7)
               bsr.w   _do_init_player_energy    ; calls $0007fa00
               movem.l (a7)+,d0-d7/a0-a2
               rts



               ;----------------------- LOSE A LIFE - $0007c862 -------------------------
               ; reduce player lives, reset vars and check no lives remaining.
               ;
               ;   Original Address $0007c862
               ;
               ;   PUBLIC void PANEL_Player_Lose_Life(void)
               ;
PANEL_Player_Lose_Life                           
               movem.l d0-d7/a0-a2,-(a7)
               bsr.w   _do_player_lose_life            ; calls $0007fb00
               movem.l (a7)+,d0-d7/a0-a2
               rts



               ;----------------------- ADD HIT DAMAGE - $0007c870 -------------------------
               ; Add hit damage to the player, to be subtracted from their energy value.
               ;
               ;    Original Address $0007c870
               ;
               ;    PUBLIC void PANEL_Reduce_Player_Energy(d0.w = damageValue)
               ;
               ;         IN: D0.w - hit damage to add to player
               ;
PANEL_Reduce_Player_Energy       
               bra.w _do_reduce_player_energy     ; calls $0007fa66





                ;----------------------- DATA/STATUS VALUES -----------------------
                ; various variables for keeping state of panel status:-
                ;   1) Player Lives
                ;   2) Player Energy Levels (including hit damage)
                ;   3) Clock Timer (Minutes:Seconds)
                ;   4) Frame Tick Counter
                ;   5) Status Bytes 1 & 2  (bit array of flags)
                ;


                even


               ; Status Byte 1 bits (1 = active)
               ;   - 0 = Timer Has Expired
               ;   - 1 = No Player Lives Left
               ;   - 2 = Life has been lost
PANEL_StatusByte_01                     ; original address $0007c874
                dc.b    $00  

               ; Status Byte 2 Bits (1 = active)
               ;   - 0 = Music/FX
               ;   - 5 = Game Over
               ;   - 6 = Game Completed
               ;   - 7 = Cheat Active
PANEL_StatusByte_02                     ; original address $0007c875
                dc.b    $00          


                even
PANEL_Player_Lives_Count                ; original address $0007c876
                dc.w    $0000           ; Number of Player Lives

PANEL_HighScore_BCD                     ; original address $0007c878
                dc.l    $00000000       ; High Score Value value (BCD 6 digits, first byte unused 000,000)

PANEL_PlayerScore_BCD                   ; original address 0007c87c 
                dc.l    $00000000       ; Player Score Value (BCD 6 digits, first byte unused 000,000)

PANEL_frame_tick_counter                ; original address $0007c880
                dc.w    $0000           ; vbl ticker, ticks every frame from 50 to 0 (1 second at 50hz)

PANEL_clock_timer_update_amount_BCD     ; original address $0007c882
                dc.w    $0000           ; BCD value subtracted from clock_timer when frame_tick = 0

                even
PANEL_clock_timer_BCD                   ; original address $0007c884
PANEL_clock_timer_minutes_BCD           ; original address $0007c884
                dc.b    $00             ; Clock Timer Minutes value, held in BCD Format
PANEL_clock_timer_seconds_BCD           ; original address $0007c885
                dc.b    $00             ; Clock Timer Seconds Value, held in BCD Format

                even
PANEL_player_score_update_value_BCD     ; original address $0007c886
                dc.l    $00000000       ; BCD Value that the score should be updated by.

PANEL_player_score_display_value_BCD    ; original address $0007c88a
                dc.l    $ffffffff       ; BCD Value used to display the player score on the panel.

PANEL_player_energy_level               ; original address $0007c88e
                dc.w    $0000           ; player's remaining energy level, max/full level = #$28 (40)

PANEL_player_hit_damage_amount          ; original address $0007C890
                dc.w    $0000           ; Hit Damage value (accumulated by damage taken to the player) the value is gradually subtracted from the PANEL_player_energy_level during each update.


               ; The ptr into the Panel Display where the next
               ; line of Joker Face Energy Display is to be written.
               ;  - initialised to the top of the Batman Face on the display,
               ;  - gradually is incremented down the screen as the energy level reduces.
PANEL_energy_display_top_ptr                ; original address $0007c89
                dc.l    $00000000           ; source ptr to the joker energy graphics

               ; The source gfx ptr into to the Joker Face gfx
               ; the next GFX line to be written to the Panel energy display.
               ;  - gradually incremented down the Joker Face as the player energy decreases.
PANEL_joker_energy_gfx_ptr                   ; original address $0007C892
                dc.l    $00000000            ; ptr to the joker face gfx (next line to be written to Panel Display)






                ;---------------------- PANEL GRAPHICS -----------------------
                ; 40 bytes wide (320 pixels)
                ; 48 lines high 
                ; 1920 bytes per bitplane x 4 = 7680 bytes
                ;
PANEL_background_gfx     include ./gfx/panel_gfx.s         ; original address $0007c89a


                ;--------------------- BATMAN ENERGY GFX ---------------------
                ; batman image of energy display 64 x 41 pixels in size
                ; 64x41 pixels, 4 bitplanes. 1312 Bytes
                ;
PANEL_batman_energy_gfx  include ./gfx/batman_energy_gfx.s ; original address $0007E69A


                ;--------------------- JOKER ENERGY GFX ----------------------
                ; joker image of energy display 64 x 41 pixels in size
                ; 64x41 pixels, 4 bitplanes. 1312 Bytes
PANEL_joker_energy_gfx   include ./gfx/joker_energy_gfx.s  ; original address $0007EBBA


                ;--------------------- SCORE DIGITS GFX ----------------------
                ; 16 x 7 pixels, 4 bitplanes, 10 characters
                ; 560 bytes
PANEL_score_digits_gfx   include ./gfx/score_digits_gfx.s  ; original address $0007F0DA


                ;--------------------- TIMER DIGITS GFX ----------------------
                ; 16 x 11 pixels, 4 bitplanes, 12 characters (including separators)
                ; 1056 bytes
PANEL_timer_digit_gfx    include ./gfx/timer_digits_gfx.s  ; original address $0007F30A


                ;----------------- BATMAN LIVES ON ICON GFX ------------------
                ; mask: 32 x 13 = 56 bytes
                ; image: 32 x 13, 4 bitplanes = 208 bytes
PANEL_batman_lives_icon_on_mask
                include ./gfx/batman_lives_icon_on_mask.s  ; original address $0007f734
PANEL_batman_lives_icon_on_gfx
                include ./gfx/batman_lives_icon_on.s  ; original address $0007f734


                ;----------------- BATMAN LIVES OFF ICON GFX -----------------
                ; mask: 32 x 13 = 56 bytes
                ; image: 32 x 13, 4 bitplanes = 208 bytes
PANEL_batman_lives_icon_off_mask
                include ./gfx/batman_lives_icon_off_mask.s ; original address $0007f838
PANEL_batman_lives_icon_off
                include ./gfx/batman_lives_icon_off.s ; original address $0007f838






               ;---------------- do add extra life ----------------
               ; Add extra life to player_life_count
               ; if panel space available then display the extra life icon.
               ;
               ;    Original Address $0007f95a
               ;
               ;    PRIVATE void _do_add_extra_life(void)
               ;
MAX_LIFE_ICON_DISPLAY_COUNT   EQU  $0003
_do_add_extra_life     
                lea.l   PANEL_batman_lives_icon_on_gfx,a0
                move.w  PANEL_Player_Lives_Count,d0       
                add.w   #$0001,PANEL_Player_Lives_Count 
                cmp.w   #MAX_LIFE_ICON_DISPLAY_COUNT,d0          
                blt.w   _display_batman_life_icon                  ; display life icon if space on the display
                rts




               ;----------- do initialise player lives -----------
               ; Set player lives to 2 
               ; display player lives icons (2 on/lit, 1 off/unlit).
               ;
               ;    Original Address $0007f978
               ;
               ;    PRIVATE void _do_init_player_lives(void)
               ;
INITIAL_LIVES_COUNT      EQU  $0002
_do_init_player_lives                         
                move.w  #INITIAL_LIVES_COUNT,PANEL_Player_Lives_Count
                clr.b   PANEL_StatusByte_01
                ; display life icon 1
                moveq   #$00,d0
                lea.l   PANEL_batman_lives_icon_on_gfx,a0
                bsr.w   _display_batman_life_icon              
                ; display life icon 2
                moveq   #$01,d0                          
                lea.l   PANEL_batman_lives_icon_on_gfx,a0
                bsr.w   _display_batman_life_icon              
                ; display life icon 3
                moveq   #$02,d0                          
                lea.l   batman_lives_icon_off,a0         
                bsr.w   _display_batman_life_icon              
                rts



               ;------------------------------------------------------------
               ; Display player lives icon (of/off)
               ;
               ;   Original Address $0007f9ac
               ;
               ;   PRIVATE void  _display_batman_life_icon(
               ;                            d0.w = iconIndex,
               ;                            a0.l = iconGfxPointer)
               ;
               ; IN: d0.w = iconIndex - which lives image to update (0-2) desintation index
               ; IN: a0.l = iconGfxPointer - source gfx address (mask must be 52 bytes before this address)
               ;
               ; NOTES:
               ; panel gfx = 320 x 48 pixels (1920 bytes per bitplane)
               ; batman symbol = 32 x 13 pixels (52 bytes per bitplane)
               ;

; Panel Background Gfx Constants
PANEL_BITPLANE_1_OFFSET       EQU  $0
PANEL_BITPLANE_2_OFFSET       EQU  1*PANEL_DISPLAY_BITPLANEBYTES
PANEL_BITPLANE_3_OFFSET       EQU  2*PANEL_DISPLAY_BITPLANEBYTES
PANEL_BITPLANE_4_OFFSET       EQU  3*PANEL_DISPLAY_BITPLANEBYTES

; Batman Life Icon Constants
ICON_BITPLANE_BYTES           EQU  $34                           ; icon bitplane size = 4 *13 = 52 bytes
ICON_MASK_SIZE                EQU  ICON_BITPLANE_BYTES           ; mask size = 52 bytes
ICON_BYTE_WIDTH               EQU  $04                           ; Icon is 4 bytes wide (32 pixels)
ICON_PIXELS_HIGH              EQU  $0d                           ; Icon is 13 pixels high
ICON_BITPLANE_1_OFFSET        EQU  $0
ICON_BITPLANE_2_OFFSET        EQU  1*ICON_BITPLANE_BYTES
ICON_BITPLANE_3_OFFSET        EQU  2*ICON_BITPLANE_BYTES
ICON_BITPLANE_4_OFFSET        EQU  3*ICON_BITPLANE_BYTES

_display_batman_life_icon
               
               ; calc dest icon byte offset (d0)
               asl.w   #$02,d0                                     ; d0 = d0 * 4
               
               ; calc icon mask start address (a2)
               movea.l a0,a2                                       
               suba.l  #ICON_MASK_SIZE,a2                          ; a2 = subtract 52 from ptr = gfx mask start address (52 bytes before gfx data)
               
               ; calc dest icon address ptr (a1)
               lea.l   PANEL_background_gfx+((40*10)+26),a1        ; a1 = desintaion address = $0007ca44 (1st batman lives icon)
               adda.w  d0,a1                                       ; a1 = destination address + offset to area to update (lives icon)
               
               ; draw icon loop (one line at a time)
               move.w  #ICON_PIXELS_HIGH-1,d0                      ; d0 = 12 + 1 - loop counter 
.display_loop  
                    ; apply icon mask
                    move.l  (a2),d1                                ; d1 = 32 bit mask value
                    not.l   d1                                     ; d1 = invert bits
                    and.l   d1,PANEL_BITPLANE_1_OFFSET(a1)         ; mask d1.l with contents of      a1 = $7CA44 (start)
                    and.l   d1,PANEL_BITPLANE_2_OFFSET(a1)         ; mask d1.l with contents of a1+1920 = $7D1C4 (start)
                    and.l   d1,PANEL_BITPLANE_3_OFFSET(a1)         ; mask d1.l with contents of a1+3840 = $7D944 (start)
                    and.l   d1,PANEL_BITPLANE_4_OFFSET(a1)         ; mask d1.l with contents of a1+5769 = $7E0C4 (start) 
               
                    ; draw icon gfx
                    move.l  ICON_BITPLANE_1_OFFSET(a0),d2          ; d2 = 32 bits source gfx
                    or.l    d2,PANEL_BITPLANE_1_OFFSET(a1)         ; add source gfx to dest address (bitplane 1)
                    move.l  ICON_BITPLANE_2_OFFSET(a0),d2          ; d2 = 32 bit source gfx (52 byte offset) (52/4 = 13 - 32 pixels wide x 13 pixels high )
                    or.l    d2,PANEL_BITPLANE_2_OFFSET(a1)         ; add source gfx to dest address (bitplane 2)
                    move.l  ICON_BITPLANE_3_OFFSET(a0),d2          ; d2 = 32 bit source gfx (104 byte offset)
                    or.l    d2,PANEL_BITPLANE_3_OFFSET(a1)         ; add source gfx to dest address (bitplane 3)
                    move.l  ICON_BITPLANE_4_OFFSET(a0),d2          ; d2 = 32 bit source gfx (156 byte offset)
                    or.l    d2,PANEL_BITPLANE_4_OFFSET(a1)         ; add source gfx to dest address (biitplane 4)
               
                    ; set up gfx ptrs for next raster line
                    adda.l  #PANEL_DISPLAY_BYTEWIDTH,a1            ; a1 = add 40 bytes to destination address (next scanline bitplane 1)
                    addq.l  #ICON_BYTE_WIDTH,a2                    ; a2 = increase mask ptr
                    addq.l  #ICON_BYTE_WIDTH,a0                    ; a0 = increase source gfx ptr
 
               dbf.w   d0,.display_loop                            ; loop next display line
               rts




               ;---------------- DO INTIALISE PLAYER ENERGY - $0007fa00 ------------------
               ; Resets the player's energy to 'full' 
               ; Restores the bitplane ptrs for the panel display graphics for the energy meter
               ;
               ;   Original Address $0007fa00
               ;
               ;   PRIVATE void _do_init_player_energy(void)
               ;
MAX_PLAYER_ENERGY        EQU  $28                      ; Max Player Energy Value = 40
ENERGY_METER_BYTE_WIDTH  EQU  $08                      ; Energy Meter 8 bytes wide (64 pixels)
ENERGY_METER_PIXELS_HIGH EQU  $29                      ; Energy Meter 41 Pixels high

ENERGY_METER_BITPLANE_BYTES        EQU  ENERGY_METER_BYTE_WIDTH*ENERGY_METER_PIXELS_HIGH
ENERGY_METER_BITPLANE_1_OFFSET     EQU  $0
ENERGY_METER_BITPLANE_2_OFFSET     EQU  1*ENERGY_METER_BITPLANE_BYTES
ENERGY_METER_BITPLANE_3_OFFSET     EQU  2*ENERGY_METER_BITPLANE_BYTES
ENERGY_METER_BITPLANE_4_OFFSET     EQU  3*ENERGY_METER_BITPLANE_BYTES

_do_init_player_energy 
               ; init player energy
               move.w  #MAX_PLAYER_ENERGY,d0                                   ; D0 = 40 + 1 - loop counter (initial energy value)
               move.w  d0,PANEL_player_energy_level                  ; set player remaining energy level as address $0007c88e

               ; clear pending hit damage
               clr.w   PANEL_player_hit_damage_amount                           ; L0007C890

               ; set source and dest address pointers
               lea.l   PANEL_batman_energy_gfx,a0                        ; batman energy meter source gfx address
               lea.l   PANEL_background_gfx+((40*4)+16),a1                   ; destination bitplanes for player energy display (batman/joker energy meter)

               ; reset joker gfx to top of energy meter display
               move.l  a1,PANEL_joker_energy_gfx_ptr             ; store ptr to the energy meter location in the panel display.

               ; display whole batman image in energy meter 
               ; one line per loop iteration
.copy_loop     
                    ; draw one raster line of gfx
                    move.l  ENERGY_METER_BITPLANE_1_OFFSET(a0),PANEL_BITPLANE_1_OFFSET(a1)                                   ; bitplane 1 - copy 32bits gfx source to dest
                    move.l  ENERGY_METER_BITPLANE_1_OFFSET+4(a0),PANEL_BITPLANE_1_OFFSET+4(a1)                         ; bitplane 1 - copy 32bits gfx source to dest
                    move.l  ENERGY_METER_BITPLANE_2_OFFSET(a0),PANEL_BITPLANE_2_OFFSET(a1)                         ; bitplane 2 - copy 32bits gfx source to dest
                    move.l  ENERGY_METER_BITPLANE_2_OFFSET+4(a0),PANEL_BITPLANE_2_OFFSET+4(a1)                         ; bitplane 2 - copy 32bits gfx source to dest
                    move.l  ENERGY_METER_BITPLANE_3_OFFSET(a0),PANEL_BITPLANE_3_OFFSET(a1)                         ; bitplane 3 - copy 32bits gfx source to dest
                    move.l  ENERGY_METER_BITPLANE_3_OFFSET+4(a0),PANEL_BITPLANE_3_OFFSET+4(a1)                         ; bitplane 4 - copy 32bits gfx source to dest
                    move.l  ENERGY_METER_BITPLANE_4_OFFSET(a0),PANEL_BITPLANE_4_OFFSET(a1)                         ; bitplane 4 - copy 32bits gfx source to dest
                    move.l  ENERGY_METER_BITPLANE_4_OFFSET+4(a0),PANEL_BITPLANE_4_OFFSET+4(a1)                         ; bitplane 4 - copy 32bits gfx source to dest
               
                    ; update gfx ptrs for next raster line
                    addq.l  #ENERGY_METER_BYTE_WIDTH,a0                 ; increase source ptr by 64 bits
                    adda.l  #PANEL_DISPLAY_BYTEWIDTH,a1                 ; increase dest ptr by 320 pixels (40 bytes)
               
               dbf.w   d0,.copy_loop                               ; copy next scan line of gfx, jmp $0007fa22
               
               ; initialise top of joker gfx ptr
               move.l  #PANEL_joker_energy_gfx,PANEL_energy_display_top_ptr      ; initialise joker energy display gfx ptr in address $0007C896
               rts

; 
; shared return from subroutine - used by '_update_hit_damage'
; was shared with above rts, but re-written (maybe assembler optimisation)
Exit
               rts                                                 ; shared return with 'update_hit_damage'              - $L0007fa64.




                ;--------------------- do add hit damage -----------------------
                ; Add value in d0.w to player hit damage total. 
                ; The hit damage amount is gradually subtracted from the player energy
                ; during the regular PANEL_Update call.
                ;
                ;   Original Address $0007fa66
                ;
                ;   PRIVATE void _do_reduce_player_energy(d0.w - damageValue)
                ;
                ;        IN: d0.w = damageValue - the amount of damage to add to the hit damage amount
                ;
_do_reduce_player_energy    

               ; conditional build time infinite energy cheat.
            IFD INFINITE_ENERGY_CHEAT
                rts
            ENDC

.do_hit_damage
               ; is player energy level already 0?
               tst.w   PANEL_player_energy_level               
               bne.b   .increase_hit_damage                    
               
               ; yes - don't subtract any more hit damage
               clr.w   PANEL_player_hit_damage_amount                                     - 0007fa6e
               rts                                                                                                    - 0007fa74

               ; no - increase hit damage amount
.increase_hit_damage
               add.w   d0,PANEL_player_hit_damage_amount       
               rts                                                                                                    - 0007fa7c





               ;----------------------- update hit damage ----------------------
               ; Gradually decrement the _player_energy_level when the 
               ; _hit_damage_amount value is > 0.
               ; Gives a smooth enegy loss appearance over a number of updates
               ; that gradually reveal the jokers face over Batmans face.
               ;
               ;    Original Address $0007fa7e
               ;
               ;    PRIVATE void _update_hit_damage()
               ;
               ; NOTES:
               ; slightly modified (added .exit) to removed shared rts
               ;
_update_hit_damage                                        
                move.w  PANEL_player_hit_damage_amount,d0 
                bpl.w   .check_is_0     
                
.clamp_value_to_0   ; hit damage amount -ve, clamp to 0
                clr.w   PANEL_player_hit_damage_amount  
                moveq   #$00,d0   

.check_is_0         ; hit damage is 0, then exit
                beq.b   .exit   

.decrement_value    ; hit damage is +ve
                sub.w   #$0001,PANEL_player_hit_damage_amount                    ; reduce player hit/damage as address $0007C890         - 0007fa92

.reveal_joker_face
                ; copy bitplane graphics (32 pixels wide)
                ; update the batman energy display (one scanline)
                movea.l PANEL_energy_display_top_ptr,a0                     ; a0 = ptr to joker energy graphics                     - 0007fa9a
                movea.l PANEL_joker_energy_gfx_ptr,a1       ; a1 = dest ptr panel energy meter display,             - 0007faa0
                move.l  ENERGY_METER_BITPLANE_1_OFFSET(a0),PANEL_BITPLANE_1_OFFSET(a1)                                   ; copy 4 bytes source to dest,                          - 0007faa6
                move.l  ENERGY_METER_BITPLANE_1_OFFSET+4(a0),PANEL_BITPLANE_1_OFFSET+4(a1)                         ; copy 4 bytes source+4 to dest + 4                     - 0007faa8
                move.l  ENERGY_METER_BITPLANE_2_OFFSET(a0),PANEL_BITPLANE_2_OFFSET(a1)                         ; copy 4 bytes source+328 to dest+328                   - 0007faae
                move.l  ENERGY_METER_BITPLANE_2_OFFSET+4(a0),PANEL_BITPLANE_2_OFFSET+4(a1)                         ; copy 4 bytes source+332 to desc+332                   - 0007fab4
                move.l  ENERGY_METER_BITPLANE_3_OFFSET(a0),PANEL_BITPLANE_3_OFFSET(a1)                         ; copy 4 bytes source+656 to desc+656                   - 0007faba
                move.l  ENERGY_METER_BITPLANE_3_OFFSET+4(a0),PANEL_BITPLANE_3_OFFSET+4(a1)                         ; copy 4 bytes source+660 to dest+660                   - 0007fac0
                move.l  ENERGY_METER_BITPLANE_4_OFFSET(a0),PANEL_BITPLANE_4_OFFSET(a1)                         ; copy 4 bytes source+984 to dest+984                   - 0007fac6
                move.l  ENERGY_METER_BITPLANE_4_OFFSET+4(a0),PANEL_BITPLANE_4_OFFSET+4(a1)                         ; copy 4 bytes source+988 to dest+988                   - 0007facc
                addq.l  #ENERGY_METER_BYTE_WIDTH,a0                                     ; increment source by 8 bytes                           - 0007fad2
                adda.l  #PANEL_DISPLAY_BYTEWIDTH,a1                               ; increment dest by 40 bytes (320 pixel width)          - 0007fad4

               ; update energy meter gfx pointers
                move.l  a0,PANEL_energy_display_top_ptr                     ; store updated ptr to joker energy graphics            - 0007fada
                move.l  a1,PANEL_joker_energy_gfx_ptr       ; store updated dest ptr to panel energy meter          - 0007fae0

               ; decrement player energy value
                sub.w   #$0001,PANEL_player_energy_level              ; subtract 1 from total energy at $0007c88e             - 0007fae6
                bne.w   .exit                                        ; not equal to 0 then exit (jmp L0007fa64)              - 0007faee
                
               ; player energy is 0, do lose life
                bra.w   _do_player_lose_life                              ; is equal to 0 then jmp L0007fb00                      - 0007faf2

.exit          rts


               ;------------------------- SET NO LIVES LEFT -------------------------
               ; Player has no lives left, Set Status Byte 1 bit
               ;  - 1 = No Lives Left
               ;
               ;    Original Address $0007faf6
               ; 
               ;    PRIVATE void _set_no_lives_left(void)
               ;
_set_no_lives_left_and_exit
               bset.b  #PANEL_SB01_NO_LIVES_REMAINING,PANEL_StatusByte_01          ; set bit 1 of status byte 1,               L0007faf6
               rts  


               ;---------------------- DO LOSE A LIFE - $0007fb00 ---------------------
               ; player lost a life, reset variables, check no lives left.
               ; sets status bits in 'PANEL_StatusByte_01' 
               ;
               ;    Original Address $0007fb00
               ;
               ;    PRIVATE void _do_player_lose_life(void)
               ;
_do_player_lose_life              
               ; clear hit damage amount                                
               clr.w   PANEL_player_hit_damage_amount            
               
               ; check if out of lives
               tst.w   PANEL_Player_Lives_Count                                                 - 0007fb06
               beq.b   _set_no_lives_left_and_exit
                
.set_life_lost_status
               bset.b  #PANEL_SB01_PLAYER_LIFE_LOST,PANEL_StatusByte_01     

               ; if cheat active then exit
               btst.b  #PANEL_SB02_CHEAT_ACTIVE,PANEL_StatusByte_02   
               bne.b   .exit_do_lose_life                    

.reduce_player_count
                subq.w  #$01,PANEL_Player_Lives_Count        
                move.w  PANEL_Player_Lives_Count,d0          

.chk_update_display ; if lives > 2 then can't update icons on display
                cmp.w   #$0002,d0                        
                bgt.w   .exit_do_lose_life               

               ; lives left in range (0-2) update icons on the display
.update_display     ; d0.w = life icon index (0-2)
                lea.l   batman_lives_icon_off,a0               
                bra.w   _display_batman_life_icon              

.exit_do_lose_life
                rts                           





               ;---------------------- do init player score - $0007fb40 ---------------------
               ; Initialise Player score value and display 000000 on the Panel
               ;
               ;    Original Address $0007fb40
               ;
               ;    PRIVATE void _do_init_player_score(void)
               ;
               ; NOTES
               ; Clears player score, then displays the hi-score
               ; after, it falls through to displaying the player score.
               ;
_do_init_player_score  
                clr.l   PANEL_PlayerScore_BCD                                ; fill longword with $00000000
                move.l  #$ffffffff,PANEL_player_score_display_value_BCD       ; fill longword with $ffffffff
                moveq   #$00,d0                      

.display_hi_score   
                ; plot hi-score high 2 digits
                move.b  PANEL_HighScore_BCD+1,d0                             ; d0.b = byte value, $0007c879
                ; plot 2 digits at x=8, y=14
                move.w  #$080e,d1                                   ; d1.w = X,Y (08,0e)
                bsr.w   plot_digits                                 ; calls $0007fd66 (d0 = chars, d1 = x,y)
                
                ; plot hi-score mid 2 digits
                move.b  PANEL_HighScore_BCD+2,d0
                ; plot 2 digits at x=10, y=14
                move.w  #$0a0e,d1
                bsr.w   plot_digits                                 ; calls $0007fd66
                
                ; plot hi-score low 2 digits
                move.b  PANEL_HighScore_BCD+3,d0
                ; plot 2 digits at x=12, y=14
                move.w  #$0c0e,d1
                bsr.w   plot_digits                                 ; cllas $0007fd66
                
               ; set initial score update parameter value to 0 
               moveq   #$00,d0
               ; fall through to _do_update_player_score(valueToAdd = 0)


               ;---------------------- do update player score - $0007fb7e ---------------------
               ; Add update value to the player's score, check for extra life on every 100,000.
               ;
               ;   Original Address $0007fb7e
               ;
               ;   PRIVATE void __do_update_player_score(d0.l = amountToAdd)
               ;
               ;        IN: D0.l = amountToAdd - amount to increase score by.
               ;
_do_update_player_score       
                move.l  d0,PANEL_player_score_update_value_BCD                ; store update value in $7c886
                lea.l   PANEL_player_score_update_value_BCD+4,a0              ; value initialised to $ffffffff above (-1)
                lea.l   PANEL_PlayerScore_BCD+4,a1                           ; a1 = Player Score Value
                
                ; think this might as well be moveq #0,d0
                and.l   #$000000ff,d0       

.update_score
                movem.l d0-d1,-(a7)                                 ; Save Registers in Use

               ; save score high digit (for extra life check later)
                move.b  PANEL_PlayerScore_BCD+1,d0   
                and.b   #$f0,d0  

               ; add player score update value to player score using BCD addition
                move    #$00,ccr
                abcd.b  -(a0),-(a1)                                 ; Add Update Value to Player Score (BCD)
                abcd.b  -(a0),-(a1)                                 ; Add Update Value to Player Score (BCD)
                abcd.b  -(a0),-(a1)                                 ; Add Update Value to Player Score (BCD)

.check_extra_life
               ; check for extra life every 100,000
               ; checks if highest digit has increased
               ; if so, adds an extra life
                move.b  PANEL_PlayerScore_BCD+1,d1                           ; d1 = hi 2 digits of player score
                and.b   #$f0,d1                                     ; d1 = score's most significant digit (mask second digit)
                cmp.b   d0,d1                                       ; d0 = MSD of score (before add), d1 = MSD of score (after add)
                beq.b    .skip_extra_life
                bsr.w   _do_add_extra_life                           ; ticked over 100,000 points, calls $0007f95a

.skip_extra_life    
                movem.l (a7)+,d0-d1                                 ; Restore Registers used above.

                ; display player score (also keep copy in $7C88A)
.display_score_lo_digits ; update display digits only if changed
                move.b  PANEL_PlayerScore_BCD+3,d0
                cmp.b   PANEL_player_score_display_value_BCD+3,d0
                beq.b   .display_score_mid_digits
                move.b  d0,PANEL_player_score_display_value_BCD+3             ; d0 = 2 digits for display
                ; plot 2 digits, x=12, y=30
                move.w  #$0c1e,d1                                   ; d1 = x,y
                bsr.w   plot_digits                                 ; calls $0007fd66, d1=x,y, d0 = chars

.display_score_mid_digits ; update display digits only if changed
                move.b  PANEL_PlayerScore_BCD+2,d0
                cmp.b   PANEL_player_score_display_value_BCD+2,d0
                beq.b   .display_score_hi_digits
                move.b  d0,PANEL_player_score_display_value_BCD+2
                ; plot 2 digits, x=10, y=30
                move.w  #$0a1e,d1
                bsr.w   plot_digits                                 ; calls $0007fd66, d1=x,y, d0 = chars

.display_score_hi_digits ; update display digits only if changed
                move.b  PANEL_PlayerScore_BCD+1,d0
                cmp.b   PANEL_player_score_display_value_BCD+1,d0
                beq.b   .chk_high_score
                move.b  d0,PANEL_player_score_display_value_BCD+1
                ; plot 2 digits, x=8, y=30
                move.w  #$081e,d1
                bsr.w   plot_digits                                 ; calls $0007fd66, d1=x,y, d0 = chars

.chk_high_score ; check if player score is high score
                move.l  PANEL_HighScore_BCD,d0
                cmp.l   PANEL_PlayerScore_BCD,d0
                bhi.w   .exit_update_player_score                   ; player score is not the high score

               ; display updated high score
.plot_hiscore_lo_digits ; update display digits only if player score > hi-score
                moveq   #$00,d0
                move.b  PANEL_PlayerScore_BCD+3,d0
                cmp.b   PANEL_HighScore_BCD+3,d0
                beq.b   .plot_hiscore_mid_digits
                ; plot 2 digits, x=12, y=14
                move.w  #$0c0e,d1       
                bsr.w   plot_digits 

.plot_hiscore_mid_digits ; update display digits only if player score > hi-score
                move.b  PANEL_PlayerScore_BCD+2,d0
                cmp.b   PANEL_HighScore_BCD+2,d0
                beq.b   .plot_hiscore_hi_digits 
                ; plot 2 digits, x=10, y=14
                move.w  #$0a0e,d1
                bsr.w   plot_digits 

.plot_hiscore_hi_digits ; update display digits only if player score > hi-score
                move.b  PANEL_PlayerScore_BCD+1,d0
                cmp.b   PANEL_HighScore_BCD+1,d0
                beq.b   .store_high_score
                ; plot 2 digits, x=8, y=14
                move.w  #$080e,d1
                bsr.w   plot_digits  

.store_high_score  ; copy player score to hi-score
                move.l PANEL_PlayerScore_BCD,PANEL_HighScore_BCD

.exit_update_player_score 
                rts




               ;-------------------------- Initialise Level Timer ----------------------------
               ; reset PANEL_frame_tick_counter to 50
               ; clear level timer update value (assume pauses the level timer)
               ; clear PANEL_StatusByte_01 bit field (timer_expired,lost_life,game_over) flags
               ;
               ;    Original Address $0007fc78
               ;
               ;    PRIVATE void _do_init_timer(d0.w - timerValueBCD)
               ;
               ;         IN: D0.w = timerValueBCD - value to set clock timer (BCD Minutes:Seconds)
               ;
TICKS_PER_SECOND    EQU  $32       ; 50hz = 50 ticks per second
TICKS_PER_HALF_SECOND    EQU  $19  ; 25 ticks per half second

_do_init_timer ; initialise timer values                  
               move.w  d0,PANEL_clock_timer_BCD   
               move.w  #TICKS_PER_SECOND,PANEL_frame_tick_counter   

               ; display initial timer value on the panel 
               bsr.w   _display_level_timer                      

               ; pause timer by clearing update amount
               clr.w   PANEL_clock_timer_update_amount_BCD   

               ; reset timer expired, life lost, game over flags
               clr.b   PANEL_StatusByte_01                   
               rts                                           





               ;--------------------- update panel --------------------------
               ; Executed every frame from $7c800 update_panel
               ; House keeping of the panel display,
               ;   updating hit damage (energy level) 
               ;   also setting status flags for lost_life, timer_expired, no_lives_remaining
               ;
               ;    Original Address $0007fc98
               ;
               ;    PRIVATE void _do_panel_update(void)
               ;
_do_panel_update       
               ; process player health damage
               bsr.w   _update_hit_damage  

               ; pause timer update value?
               cmp.w   #$9999,PANEL_clock_timer_update_amount_BCD    
               beq.w   .exit_do_panel_update              

               ; progress 50hz tick counter
               sub.w   #$0001,PANEL_frame_tick_counter  

               ; if second not elapsed then skip timer arithmetic &
               ; animate minutes/seconds separator ':'     
               bpl.w   .animate_clock_timer_separator

.reset_frame_tick ; 1 second has elapsed
               move.w  #TICKS_PER_SECOND,PANEL_frame_tick_counter                           ; set tick to 50 $0007c880

               ; test for timer expired
               tst.w   PANEL_clock_timer_BCD                                 ; test clock timer = 0 (minutes and seconds) $0007c884
               beq.w   .clock_timer_expired                        ; if PANEL_clock_timer_BCD = 0, jmp $0007fd1c

               ; init BCD timer arithmetic
               lea.l   PANEL_clock_timer_update_amount_BCD+2,a0               ; clock timer update value address
               lea.l   PANEL_clock_timer_BCD+2,a1                            ; clock timer end address $0007c886
               move    #$10,ccr

               ; subtract timer update amount from timer value using BCD arithmetic
               sbcd.b  -(a0),-(a1)      
               sbcd.b  -(a0),-(a1)      

               ; if minutes decremented then seconds must be set to 59, not 99
.check_minutes_decremented
                move.b  PANEL_clock_timer_seconds_BCD,d0    
                and.b   #$f0,d0                             
                cmp.b   #$90,d0                                     ; if seconds value starts with '9' then minutes were decremented
                bne.b   .display_clock_timer_value                  ; else continue to display clock_timer value $0007fcf2
.minutes_decremented
                move.b  #$59,PANEL_clock_timer_seconds_BCD           ; set seconds from '99' to '59' for correct seconds value as BCD $7c885

.display_clock_timer_value
                bsr.w   _display_level_timer       


               ; animate clock minutes/seconds separator ':' character
               ; every half second, alternate between character #$000a and #$000b
.animate_clock_timer_separator
                move.w  #$000a,d0
                cmp.w   #TICKS_PER_HALF_SECOND,PANEL_frame_tick_counter  
                beq.b   .display_timer_seperator          
                
                cmp.w   #TICKS_PER_SECOND,PANEL_frame_tick_counter     
                bne.b   .exit_do_panel_update       
                move.w  #$000b,d0                   
                                                     
.display_timer_seperator
               ; plot character, x=29, y=25
                move.w  #$1d19,d1               
                bsr.w   display_timer_digit   

.exit_do_panel_update
                rts                     

.clock_timer_expired                         
                bset.b  #PANEL_SB01_TIMER_EXPIRED,PANEL_StatusByte_01   
                bra.w   .animate_clock_timer_separator    






                ;-------------------------- Display Level Timer --------------------------
                ; Displays 'minutes:seconds' (00:00) timer digits on the panel display.     
                ; uses:
                ; - d0  - lower 4 bts = BCD digit to display (0 - 9)
                ;
                ; - d1  - X,Y co-oord
                ;       - x = (8-15) byte, offset from the left
                ;       - y = (0-7)  byte, lines from top of display (320 wide assumed))
                ;
                ; - calls display_timer_digit - $0007c885
                ;       - display each timer digit in-turn
                ;
                
                ;
_display_level_timer                                                 ; original routine address $0007fd28
                moveq   #$00,d0                                     ; d0.l = 0 - holds BCD digit to disply
.disply_1st     move.b  PANEL_clock_timer_seconds_BCD,d0                      ; d0.b = clock timer seconds in BCD from location $0007c885
                move.w  #$1f19,d1                                   ; d1.w = #$1f19 (x = 31, y = 25 - display co-ords)
                bsr.w   display_timer_digit                         ; Display the digit in lower 4 bits of d0, calls $0007fde2
.display_2nd    move.b  PANEL_clock_timer_seconds_BCD,d0                      ; d0.b = clock timer seconds in BCD from location $0007c885
                lsr.b   #$04,d0                                     ; shift 2nd digit into low 4 bits for display
                move.w  #$1e19,d1                                   ; d1.w = #$1e19 (x = 30, y = 25 - display co-ords)
                bsr.w   display_timer_digit                         ; Display the digit in lower 4 bits of d0, calls $0007fde2
.display_3rd    move.b  PANEL_clock_timer_minutes_BCD,d0                      ; d0.b = clock timer minutes in BCD from location $0007c885
                move.w  #$1c19,d1                                   ; d1.w = #$1c19 (x = 28, y = 25 - display co-ords)
                bsr.w   display_timer_digit                         ; Display the digit in lower 4 bits of d0, calls $0007fde2
.display_4th    move.b  PANEL_clock_timer_minutes_BCD,d0                      ; d0.b = clock timer minutes in BCD from location $0007c885
                lsr.b   #$04,d0                                     ; shift 2nd digit into low 4 bits for display
                move.w  #$1b19,d1                                   ; d1.w = #$1b19 (x = 27, y = 25 - display co-ords)
                bra.w   display_timer_digit                         ; Display the digit in lower 4 bits of d0, calls $0007fde2
                ; uses rts in last call to return





                ;------------------------ plot digits -----------------------
                ; Plots score digits (2 digits at a time). Digits are passed
                ; in as BCD encoded digits in d0.w.
                ;
                ; plots a 8x7 pixel character into 4 bitplanes into a 
                ; location inside the PANEL_background_gfx
                ;
                ; IN: d0.w  - 2 BCD Characters to write
                ; IN: d1.w  - x,y characters as high/low bytes in word.
                ; 
plot_digits                                                         ; original routine address 0007fd66
                bsr.w   draw_digit                                  ; display first character, call $0007fd70
.display_2nd_digit
                lsr.b   #$04,d0                                     ; d0 = second bcd digit.
                sub.w   #$0100,d1                                   ; d1 = updated x co-ordinate
                ; fall through to display the second character




                ;------------------------ draw char -------------------------
                ; IN: d0.b  - low 4 bits = BCD Characters to write (digits)
                ; IN: d1.w  - X,Y plot co-ords (x = bytes offset, y = line count)
                ;
                ; NB: Source GFX address doesnot make sense, which is why this
                ;       is probably a debug routine, not in use by the game (TBD)
                ;
draw_digit                                                          ; original routine address $0007fd70
                movem.l d0-d1,-(a7)
                moveq   #$00,d2                                     ; d2.l = $0
                move.b  d1,d2                                       ; d2 = y (scan line offset)
                lsr.w   #$08,d1                                     ; d1 = x (byte offset)
                mulu.w  #$0028,d2                                   ; multiply y * 40 (320 pixels), d2 = scan line value
                add.l   #PANEL_background_gfx,d2                               ; d2 = start scan line into PANEL_background_gfx,         PANEL_background_gfx = $0007c89a
                add.b   d1,d2                                       ; d2 = add byte offset into scan line
                movea.l d2,a0                                       ; a0 = destination address.

                and.b   #$0f,d0                                     ; d0 = low 4 bits bcd character
                bne.b   .not_zero
.is_zero
                movea.l #PANEL_score_digits_gfx+(56*9),a1                     ; address of '0' character (at end of 1-9)
                bra.w   .do_plot 
.not_zero
                mulu.w  #$0038,d0                                   ; d0 = d0 * 56 (56 bytes, 28 words) ,28/4 = 7 pixels high
                add.l   #PANEL_score_digits_gfx-56,d0                         ; start of digit gfx - 56 bytes, original address $0007f0a2, gfx starts at '1' instead of '0'
                movea.l d0,a1                                       ; a1 = source gfx ptr of require digit
.do_plot
                moveq   #$03,d2                                     ; 3 + 1 - counter (4 lines of gfx, 4 bitplanes)
.plot_loop
                move.b  (a1),(a0)                                   ; copy src gfx -> dest line 1.
                move.b  $0002(a1),$0028(a0)                         ; copy src gfx -> dest line 2.
                move.b  $0004(a1),$0050(a0)                         ; copy src gfx -> dest line 3.
                move.b  $0006(a1),$0078(a0)                         ; copy src gfx -> dest line 4.
                move.b  $0008(a1),$00a0(a0)                         ; copy src gfx -> dest line 5.
                move.b  $000a(a1),$00c8(a0)                         ; copy src gfx -> dest line 6.
                move.b  $000c(a1),$00f0(a0)                         ; copy src gfx -> dest line 7.
                adda.l  #$00000780,a0                               ; dest next bitplane
                adda.l  #$0000000e,a1                               ; src next bitplane
                dbf.w   d2,.plot_loop                               ; plot loop,
                movem.l (a7)+,d0-d1
                rts




                ;--------------------- display timer digit  --------------------------
                ; The BCD digit to displayis passed in in the lower 4 bits of d0
                ; The co-ords passed in d1
                ;
                ; IN: d0.b = BCD value to display (byte)
                ;            - values 10 & 11 are animation for timer separator ':'
                ;
                ; IN: d1.w = x,y location to display the digits (x = horizontal bytes offest, y = scanline offset)
                ;
                ; called by:
                ;   - display_level_timer   - (display digits 'xx xx')
                ;   - do_panel_update       - (display separator ':')
                ;
display_timer_digit                                                 ; original routine address $0007fde2
                and.l   #$0000ffff,d0                               ; clamp d0.l to a 16bit word
                movem.l d0-d2,-(a7)                                 ; save registers
                moveq   #$00,d2                                     ; d2.l = 0
                move.b  d1,d2                                       ; d2.b = Y offset in bytes
                lsr.w   #$08,d1                                     ; d1.b = X offset in pixels
                mulu.w  #$0028,d2                                   ; d2 = Y offset in bytes (#$28 = 40 bytes per digit)
                add.l   #PANEL_background_gfx,d2                               ; PANEL_background_gfx address = $0007c89a
                add.w   d1,d2                                       ; d2 = start address in panel to draw the digit
                movea.l d2,a0                                       ; a0 = start address in panel to draw the digit
                and.w   #$000f,d0                                   ; d0 = first digit to draw
                add.w   d0,d0                                       ; d0 = word index to digit gfx
                lea.l   digit_gfx_offset_table,a2                   ; a2 = digit gfx offset lookup tablle
                move.w  (a2,d0),d0                                  ; d0 = digit byte offset into gfx data
                add.l   #PANEL_timer_digit_gfx,d0                         ; d0 = address of digit to draw
                movea.l d0,a1                                       ; a1 = address of digit to draw
                moveq   #$03,d2                                     ; d2 = 3 + 1 = 4 bitplanes
.bitplane_loop  move.b  (a1),(a0)                                   ; copy gfx data - src to dest - line 0
                move.b  $0002(a1),$0028(a0)                           ; copy gfx data - src to dest - line 1
                move.b  $0004(a1),$0050(a0)                         ; copy gfx data - src to dest - line 2
                move.b  $0006(a1),$0078(a0)                         ; copy gfx data - src to dest - line 3
                move.b  $0008(a1),$00a0(a0)                         ; copy gfx data - src to dest - line 4
                move.b  $000a(a1),$00c8(a0)                         ; copy gfx data - src to dest - line 5
                move.b  $000c(a1),$00f0(a0)                         ; copy gfx data - src to dest - line 6
                move.b  $000e(a1),$0118(a0)                         ; copy gfx data - src to dest - line 7
                move.b  $0010(a1),$0140(a0)                         ; copy gfx data - src to dest - line 8
                move.b  $0012(a1),$0168(a0)                         ; copy gfx data - src to dest - line 9
                move.b  $0014(a1),$0190(a0)                         ; copy gfx data - src to dest - line 10
                adda.l  #$00000780,a0                               ; increment to next bitplane #$780 = 1920 bytes (height = 48 scanlines)
                adda.l  #$00000016,a1                               ; next digit bitplane (16 x 16 pixels )
                dbf.w   d2,.bitplane_loop                           ; do next bitplane, loop to $0007fe1a
                movem.l (a7)+,d0-d2                                 ; restore saved registers
                rts                                                 ; return





                ;-------------------- more data ---------------------
                ; this is a table of byte offsets for the digits
                ; 0-9 into the charset gfx and 2 separators.
            even
digit_gfx_offset_table             ; original address $0007FE6E 
            dc.w    $0370          ; digit 0 - offset 
            dc.w    $0058          ; digit 1 - offset
            dc.w    $00B0          ; digit 2 - offset
            dc.w    $0108          ; digit 3 - offset
            dc.w    $0160          ; digit 4 - offset
            dc.w    $01B8          ; digit 5 - offset
            dc.w    $0210          ; digit 6 - offset
            dc.w    $0268          ; digit 7 - offset
            dc.w    $02C0          ; digit 8 - offset
            dc.w    $0318          ; digit 9 - offset
            dc.w    $0000          ; Timer Separator Animation 1 - offset
            dc.w    $03C8          ; Timer Seperator Animation 2 - offset

