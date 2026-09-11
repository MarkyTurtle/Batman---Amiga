             
                ; Title Screen
                ; ------------
                ; Title_Screen_Start            - $0001c000   - First Game Title Screen Start
                ;                               - $0001c004   - End Game Title Screen Start (Game Over/Game Completion)
                ;
                ;
                ; Music Player
                ; ------------
                ; SoundDriver_Initialise        - $00004000
                ; SoundDriver_Stop_All          - $00004004
                ; SoundDriver_Init_Song         - $00004010 - D0.l = Song Number to play (0-3, 0 = stop playing)
                ; SoundDriver_VBlankUpdate      - $00004018 - Call every frame/cycle to play song
                ;
                ;
                ; VSCode Plugins
                ;----------------
                ; Requires the 'amiga assembly' plugin in order to build and run.
                ;
                ;
                ; VSCode Test Build
                ;-------------------
                ; - 1) Ensure that the 'TEST_TITLEPRG' defintion below is defined.
                ;
                ; - 2) Select the 'Run/Start Debugging' or 'Run/Start without debugging' option from the menu.
                ;
                ;
                ; Absolute Build
                ;----------------
                ; - 1) Comment out the 'TEST_TITLEPRG' definition below.
                ;
                ; - 2) Run the Task 'amigaassembly: build-absolute'
                ;       - This will create an absolte file org $3FFC called 'titleprg.o' in the /build folder
                ;
                ; - 3) This binary file can then be crunched with shrinkler or zxo and copied to the rellevent .adf fr testing.
                ; 


                section titleprg_iff,code_c
                ;opt     o-

               incdir    "include/"
               incdir    "libs/"
               incdir    "libs/sound/"
               incdir    "music/"
               incdir    'gfx/'
               include   "hw.i"                             ; hardware custom register includes
               

SOUND_TITLE_TUNE    EQU  $1
SOUND_JOKER_LAUGH   EQU  $2
SOUND_BATMAN_SPEACH EQU  $3



TEST_TITLEPRG            SET 1     ; run a test buildin VSCode, else build to absolute address

TEST_TITLESCREEN_START   SET 1     ; When defined starts the title screen same as first load.
                                   ; comment out to test JOKER, BATMAN return screens.
;TEST_JOKER               SET 1     ; start with joker screen, comment out to start with batman screen

DEBUG_TYPER              SET 1     ; when set - updated text type on the title screen.
VBLANK_FIX               SET 1     ; Implement VBLANK FIX (remove processor wait from raster wait routine) 

TEST_PLAYER_SCORE   EQU  $00000000 ; BCD Score to start the title screen with
;TEST_PLAYER_SCORE   EQU  $00130000 ; for testing player initials entry.



           ;--------------------------- conditional start-up code ----------------------------
          ; if TEST_TITLEPRG is defined then can build an execute in VSCode
          ;
          IFD TEST_TITLEPRG  
               ; RELATIVE ADDRESSING BUILD
               ; When testing in VSCode, set resource address consstants and
               ; include code to take over the system and start the title screen.
DISPLAY_BITPLANE_ADDRESS      EQU  display_buffer                ; address of display buffer
ASSET_CHARSET_BASE            EQU  character_set_gfx             ; test_bitplanes-$4c            ; address of charset in memory (76 bytes into charset)
JOKER_GFX                     EQU  joker_gfx                     ; test_bitplanes+$AA06 - address of JOKER Game Over Screen
JOKER_PALETTE                 EQU  joker_background_palette      ; test_bitplanes+$AA06+$40         ; address of JOKER Game Over Screen Palette
BATMAN_GFX                    EQU  batman_gfx                    ; test_bitplanes+$1722A         ; address of BATMAN Game Completion Screen
TITLE_SCREEN_GFX              EQU  titlescreen_gfx               ; test_bitplanes+(40*88)+10     ; 
PANEL_STATUS_1                EQU  PANEL_StatusByte_01           ; mock address of Panel.Panel_Status_1  
PANEL_STATUS_2                EQU  PANEL_StatusByte_02           ; mock address of Panel.Panel_Status_2 
PANEL_HIGHSCORE               EQU  PANEL_HighScore_BCD           ; mock address of Panel.High_Score 
PANEL_PLAYERSCORE             EQU  PANEL_PlayerScore_BCD         ; mock address of Panel.Player_Score
PANEL_INITIALISE_PLAYER_SCORE   EQU     test_nop                 ; address of Panel.Initialise_Player_Score
PANEL_INITIALISE_PLAYER_LIVES   EQU     test_nop                 ; address of Panel.Initialise_Player_Lives
LOADER_LOAD_LEVEL_1             EQU     test_load_level_1        ; address of Loader.Load_Level_1()

kill_system
               lea     $dff000,a6
               move.w  #$7fff,INTENA(a6)
               move.w  #$7fff,DMACON(a6)
               move.w  #$7fff,INTREQ(a6)   
               lea     kill_system,a7                              ; initialise stack 
               bsr     init_system

.start_title_screen
          IFD TEST_TITLESCREEN_START
               jmp     title_screen_start                      ; Entry point $0001c000
          ELSE
               jmp     end_game_return_to_title_screen
          ENDC

               include "initsystem.s"

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
PANEL_StatusByte_02                          ; original address $0007c875
               dc.b    $00          

               even
PANEL_HighScore_BCD                          ; original address $0007c878
               dc.l    $00000000             ; High Score Value value (BCD 6 digits, first byte unused 000,000)

PANEL_PlayerScore_BCD                        ; original address 0007c87c 
               dc.l    TEST_PLAYER_SCORE     ; Player Score Value (BCD 6 digits, first byte unused 000,000)

          ELSE
               ; ABSOLUTE ADDDRESSSING BUILD
               ; The original binaries of the game start with a long word that provide
               ; the start address of the file.
               ; Original Address $00003FFC        
DISPLAY_BITPLANE_ADDRESS        EQU     $00003190                        ; address of display bitplanes in memory
ASSET_CHARSET_BASE              EQU     $0003f1ea                        ; address of charset in memory
JOKER_GFX                       EQU     $00049C40                        ; address of Joker Game Over Screen (starts with palette)
JOKER_PALETTE                   EQU     $00049C40+$40                    ; 
BATMAN_GFX                      EQU     $00056460                        ; address of Batman Energy Panel GFX
TITLE_SCREEN_GFX                EQU     $00040000
PANEL_STATUS_1                  EQU     $0007c874                     ; address of Panel.Panel_Status_1  
PANEL_STATUS_2                  EQU     $0007c875                     ; address of Panel.Panel_Status_2 
PANEL_HIGHSCORE                 EQU     $0007c878                     ; address of Panel.High_Score 
PANEL_PLAYERSCORE               EQU     $0007c87c                     ; address of Panel.Player_Score
PANEL_INITIALISE_PLAYER_SCORE   EQU     $0007c81c               ; address of Panel.Initialise_Player_Score
PANEL_INITIALISE_PLAYER_LIVES   EQU     $0007c838               ; address of Panel.Initialise_Player_Lives
LOADER_LOAD_LEVEL_1             EQU     $824                    ; address of Loader.Load_Level_1()


               org     $3ffc       ; absolute compilation address

titleprg_start
               dc.l $00004000      ; perhaps an artifact of the original 'absolute addressing' build system (most files contain this initial address)                                  


          ENDC


  



               ;------------------------ TITLE SCREEN ENTRY POINTS ---------------------------
               ; Original Address $0001c000
               ;
title_screen_start                                              
               bra.w   do_title_screen_start



               ;-------------------- GAME OVER/COMPLETION ENTRY POINT -----------------------
               ; Original Address $0001c004
end_game_return_to_title_screen                                                 
               bra.w   do_end_game_return_to_title_screen






PANEL_STATUS_2_INFINITE_LIVES   EQU     $7                      ; panel status 2: bit 7 = 1 (infinite lives on)
PANEL_STATUS_2_GAME_COMPLETED   EQU     $6                      ; game completed = 1
PANEL_STATUS_2_GAME_OVER        EQU     $5                      ; game over/completion  - return from game
PANEL_STATUS_2_SFX_ONLY         EQU     $0                      ; Music/SFX (0 = music, 1 = sfx)



               ;---------------------------- do title screen start ----------------------------
               ; Routine to set up & run the title screen the first time the game is started.
               ; the routine 'return_to_title_screen' is called after game over/completion. 
               ;
               ; Sets Window start to bottom of screen (probably for scroll up routine)
               ; H/w Ref, standard DIWSRT & DIWSTOP
               ; PAL - $2c81, $2cc1
               ; NTSC- $2c81, $f4c1
               ;
               ; Original Address $0001c008
               ;
do_title_screen_start   
               ; set Panel.HighScore to top high-score                                        
               clr.l   PANEL_HIGHSCORE
               move.l  highscore_table_BCD_format,PANEL_HIGHSCORE  
               ; continue to 'return_to_title_screen' below




               ;------------------------- return to title screen ----------------------------
               ; called after game over/compltion to return to the title screen.
               ;
               ; Original Address $0001c018
               ;
DISPLAY_MAX_WINDOW_START EQU  $f4            ; Display Window starts at bottom of line 200
DISPLAY_MIN_WINDOW_START EQU  $2c            ; Display Window top, starts at PAL/NTSC line 0
DISPLAY_5_BITPLANES      EQU  $5000          ; BPLCON0 setting for 5 bitplanes
DISPLAY_320_200_BYTES    EQU  $00001f40      ; Bitplane size for 320x200 display

return_to_title_screen        
               ; initialise the stack                                  
               lea.l   temp_stack_top,a7                       

               ; initialise window (ready for start transition)
               move.b  #DISPLAY_MAX_WINDOW_START,copper_diwstrt   
               move.b  #DISPLAY_MAX_WINDOW_START,copper_diwstop  

               ; wait for 2 display frames
               moveq   #$01,d0
               bsr.w   raster_wait_161

               ; initialise hardware state
               bsr.w   initialise_hardware_state

               ; initialise display & colour palette
               move.w  #DISPLAY_5_BITPLANES,CUSTOM+BPLCON0
               lea.l   title_screen_palette,a0
               bsr.w   copper_copy

               ; clear 'timer expired', 'life lost', 'no lives' - flags from status byte 1
               ; clear 'game over', 'game complete' - flags from status byte 2
               and.w   #$f89f,PANEL_STATUS_1
                                                      
               ; initialise music/sfx depending on status flags
               bsr.w   init_title_music

               ; refresh display buffer
               bsr.w   copy_title_screen_bitplanes           


               ;************ TITLE SCREEN TEXT TYPER WAIT LOOP *****************
               ; Manage hi-score entry and text typer display.
               ; The text typer controls the main title-screen wait
               ; loop, waits for joystick button press to jump
               ; to return to 'start_game' below.
               ;
               ; was originally a bsr.w, changed to bra.w to honor
               ; return jump and the stack.
.title_screen_loop           
               bra.w   hi_score_and_text_typer





               ;------------------------- START GAME - LOAD LEVEL 1 ----------------------
               ; The Text Typer jumps to here when start button pressed, instead of
               ; using 'rts'
               ;
               ; Original Address $0001c05e
               ;
start_game                                                      
               ; set flag to start transition of end title screen
               ; i.e. scroll title screen to bottom of display.
               not.w     screen_transision_direction_flag       

               ; wait for screen transition out (scroll down to bottom)
.wait_diwstrt
               cmp.b     #DISPLAY_MAX_WINDOW_START,copper_diwstrt
               bne.b     .wait_diwstrt 

               ; wait for a 2 frames for good luck
               moveq     #$01,d0                                 
               bsr.w     raster_wait_161

               ; initialise player score, lives, energy for new game
               move.l    highscore_table_BCD_format,PANEL_PLAYERSCORE
               jsr       PANEL_INITIALISE_PLAYER_SCORE           
               jsr       PANEL_INITIALISE_PLAYER_LIVES  

               ; stop title screen music         
               jsr       SoundDriver_StopSound                    

               ; load and execute level 1
               jmp       LOADER_LOAD_LEVEL_1






          ; --------------------------------------------------
          ; Test patch routines for the PANEL and LOADER
          ; to prevent crashes when executing in VSCODE
          ;
          IFD TEST_TITLEPRG
test_nop  
               rts

test_load_level_1
               move.w    d0,CUSTOM+COLOR00
               add.w     #1,d0
               bra.s     test_load_level_1

          ENDC





               ;------------------------- do window scroll -------------------------
               ; called from level 3 interrupt handler, manages the title screen
               ; window scroll up (on title screen start) and the scroll down
               ; (on game start).
               ;
               ; The window scrolls in at 1 raster per call.
               ; The window scrolls out at 4 rasters per call.
               ;
               ;
               ; flag inverted on game start to signal title screen transition. 
screen_transision_direction_flag                                                
               dc.w $0000   


do_window_scroll
               ; check scroll up/down flag
               tst.w     screen_transision_direction_flag 
               bne.b     do_scroll_down 

               ; title screen start transistion (scroll up from bottom)
.do_scroll_up  
               ; check scroll up limit
               cmp.b     #DISPLAY_MIN_WINDOW_START,copper_diwstrt  
               beq.b     .exit
               ; scroll window top up by 1 raster line
               sub.w     #$0100,copper_diwstrt 
.exit
               rts  


               ; title screen end transition (scroll down to bottom)
do_scroll_down 
               ; check scroll down limit
               cmp.b     #DISPLAY_MAX_WINDOW_START,copper_diwstrt
               beq.b     .exit
               bcs.b     .scroll_down 
.overshot_limit
               ; set to max (when combined with following add.w)
               move.b    #$f0,copper_diwstrt                    

               ; scroll window top down by 4 pixels (faster then scroll in)
.scroll_down
               add.w     #$0400,copper_diwstrt                  
.exit
               rts 





               ;--------------------------- initialise title screen ----------------------------
               ; set up the system, interrupts annd display.
               ; NB: Level 6 interrupt enabled, but no handler (set previously in disk loader)
               ;
               ; original routine address $0001c0d8
               ;
initialise_hardware_state         
               ; set window start and stop to line 200                               
                move.l  #$f481f4c1,CUSTOM+DIWSTRT

               ; disable dma & interrupts
               move.w  #$7fff,d0       
               move.w  d0,CUSTOM+DMACON
               move.w  d0,CUSTOM+INTENA
               move.w  d0,CUSTOM+INTREQ

               ; set interrupt handlers
               move.l  #level_1_interrupt_handler,$00000064    ; Level 1 Interrupt Vector
               move.l  #level_2_interrupt_handler,$00000068    ; Level 2 Interrupt Vector           
               move.l  #level_3_interrupt_handler,$0000006c    ; Level 3 Interrupt Vector   
               move.l  #level_4_interrupt_handler,$00000070    ; Level 4 Interrupt Vector        
               move.l  #level_5_interrupt_handler,$00000074    ; Level 5 Interrupt Vector

               ; enable interrupts
               ; PORTS/TIMERS(2),VERTB(3),EXTER(6),INTEN,SET/CLR (no level 1,4,5) !No Level 6 handler
               move.w  #$e028,CUSTOM+INTENA 

               ; enable DMA
               move.w  #$83c0,CUSTOM+DMACON 

               ; set copper list
               move.l  #copper_list,CUSTOM+COP1LC
               move.w  d0,CUSTOM+COPJMP1

               ; clear interrupt control register CIAA
               move.b  #$7f,$00bfed01
               move.b  #$7f,$00bfed01

               ; initialise music
               lea      MUSIC_MODULE_DATA,a0
               jsr      SoundDriver_Initialise
                
               ; set display initial display parameters
               move.l  #DISPLAY_320_200_BYTES,d0
               bra.w   reset_title_screen_display

clear_keycode_and_exit                                          ; original address $0001c16a
                clr.w   raw_key_code_store                      ;$L0001c2f0 - clear raw keycode store
global_rts                                                      ; original address $0001c170
                rts                                             ; called from elsewhere.




               ;------------------- Do Title Screen Menu Options --------------------
               ; check for key presses and do menu screen menu options.
               ; called from typer main loop when waiting for start game.
               ;
               ;       F2 = Music/SFX toggle 
               ;       
               ; original routine address $0001c172
               ;
KEY_CODE_F2    EQU  $005c

do_title_screen_menu_options       
               ; check key up
               btst.b    #$0,raw_keyboard_serial_data_byte
               bne.w     .clear_menu_flag_and_exit
 
               ; test if F2 key already pressed, then deduplicate and exit
               tst.w     deduplicate_keypress_flag
               bne.w     global_rts

               ; check if F2 key is pressed                                                        
               cmp.w     #KEY_CODE_F2,raw_keyboard_serial_data_word 
               beq.s     .f2_pressed
               ;bne.b   clear_menu_flag_and_exit

               ; other keypressed, clear dedup flag and exit
.clear_menu_flag_and_exit
               clr.w deduplicate_keypress_flag
               rts

.f2_pressed             
                    ; F2 is pressed,
                    ; set deduplicate keypress flag (prevent multiple key strokes processed)
                    not.w   deduplicate_keypress_flag
                    ; flip sfx/music enabled bit                              
                    bchg.b  #PANEL_STATUS_2_SFX_ONLY,PANEL_STATUS_2 
                    ; fall through to init_title_music (toggle on/off)




               ;------------------- Init Title Music -----------------
               ; original routine address $0001c1a0
init_title_music                                                        
               btst.b  #PANEL_STATUS_2_SFX_ONLY,PANEL_STATUS_2      
               beq.b   .init_song_01 
               ; stop playing title music
               jmp     SoundDriver_Stop_All
               ; use rts from jmp above to exit
.init_song_01
               ; start playing title music
               moveq   #SOUND_TITLE_TUNE,d0 
               jmp     SoundDriver_Play_Song
               ; uses rts in Init_Song to return to caller.




               ;------------------ clear menu flag and exit ----------------
               ; used by the do_title_screen_menu_options routine above.
               ; clears keypress flag and exit, used to detect single
               ; keypress.
;clear_menu_flag_and_exit
;               clr.w deduplicate_keypress_flag
;               rts




                ;----------------------- do infinite lives cheat code ----------------------
                ; This routine handles the cheat code entry, matching and toggling.
                ; It's a bit heavy for an ISR.      
                ;
                ; Called from:
                ;       level_2_interrupt_handler
                ;
do_infinite_live_cheat_code                                             ; original routine address $0001c1c0
                btst.b  #$0000,raw_keyboard_serial_data_byte            ; test lsb of raw keyboard data - $0001c2ed
                bne.w   clear_keycode_and_exit                          ; if lsb = 1 then clear $0001c2f0.w and exit (key up) - jmp $0001c16a

                tst.w   raw_key_code_store                              ; test raw keycode store - $0001c2f0
                bne.b   .exit                                           ; if keycode store is not empty, exit - jmp $0001c24a

                ; check if keycode is an expected code
                ; if so enqueue it
                ; if not then exit
.process_raw_key_code
                move.w  raw_keyboard_serial_data_word,d0                ; d0 = raw keyboard key code - $0001c2ec
                and.b   #$fe,d0                                         ; d0 = mask lsb and high byte
                move.w  d0,raw_key_code_store                           ; $0001c2f0 ; store raw key code
                lea.l   raw_key_code_table,a0                           ; $0001c258 ; raw keycode table (ends with $FFxx)

.match_keycodes_loop                                                    ; original address $0001c1ea
                cmp.b   (a0),d0
                beq.w   .enqueue_key_code                               ; $0001c1fe ; key code is in the list, pop it in the queue

.unmatched_keycode                                                      ; original address $0001c1f0
                cmp.b   #$ff,(a0)                                       ; continue checking until the end of list ($ff value is part of code - dodgy/bug)
                beq.w   .exit                                           ; then exit - jmp $0001c24a

                addq.l  #$02,a0                                         ; match next value with keycode
                bra.w   .match_keycodes_loop                            ; jmp $0001c1ea ; loop


                ; this is a queue of entered valid keycodes
                ; valid key codes are added to the end of the queue
.enqueue_key_code                                                       ; original address $0001c1fe
                move.b  $0001(a0),d1                                    ; d1 = key code table second byte match
                lea.l   keyboard_buffer_start+1,a0                        ; $0001c24d
                moveq   #$05,d0                                         ; d0 = loop counter (6 times)

.shift_chars_loop                                                       ; original address $0001c20a
                move.b  (a0),-$0001(a0)                                 ; shift bytes down in memory by 1 character
                addq.l  #$01,a0                                         
                dbf.w   d0,.shift_chars_loop                            ; $0001c20a ; Loop for all characters
                move.b  d1,keyboard_buffer_start+5                      ; $0001c251 ; d1 = key code table second byte match. add to end of queue


                ; check if cheat code has been entered 
                ; in the queue, compares against
                ; stored values.
.check_cheat_code
                lea.l   keyboard_buffer_start,a0                        ; $0001c24c
                lea.l   cheat_code,a1                                   ; $0001c252
                moveq   #$05,d0                                         ; d0 = 5 + 1 (loop counter)
.compare_loop
                cmpm.b  (a0)+,(a1)+
                bne.b   .exit                                           ; jmp $0001c24a
                dbf.w   d0,.compare_loop                                ; loop 6 times, jmp $0001c228
                ; if we get here then the secret cheat code has been entered.
                ; 'IXLLLL' - 'jammmm' - 6 char code
.toggle_infinite_lives
                bchg.b  #PANEL_STATUS_2_INFINITE_LIVES,PANEL_STATUS_2           ; #$0007,$0007c875 ; Enable CHEAT?
                move.b  #$f4,copper_diwstrt                                     ; reset title screen window (closed) $0001d6e8
                move.l  #DISPLAY_320_200_BYTES,d0                                           ; bitplane size in bytes (8000)
                bsr.w   reset_title_screen_display                              ; calls $0001d2de ; reset title screen display
.exit
                rts 




                ;------------------------ keyboard buffer --------------------------
                ; contains values looked up from 'raw_key_code_table' when
                ; matched with raw keycodes.
                ; it is a queue, so new data enters at the end and old data is
                ; shifted towards the front.
                ; FIFO Queue structure.
                ;
keyboard_buffer_start                                   ; original address $0001c24c
                dc.b $20,$20,$20,$20,$20,$20


                ; ------------------------ cheat code----------------------------------
                ; This is an obfuscated cheat code string. 'IXLLLL' which is compared
                ; against the keyboard buffer above when a new acceptable key is
                ; entered into the buffer. 
cheat_code                                              ; original address $0001c252
                dc.b $49,$58,$4c,$4c,$4c,$4c            ; IXLLLL 'JAMMMM'


                ;-------------------- cheat - raw key codes ----------------------
                ; key code table - used to match keys pressed with expected
                ; cheat code values.
                ; - the second byte is 
                ;
                ; - the cheat keycodes are mapped to other characters (i presume to obsuscate)
                ; - J - maps to 'I'
                ; - A - maps to 'X'
                ; - M - maps to 'L'
                ;
                ; - the cheat code matched against is then 'IXLLL'
                ;
                ; - why bother doing this is anyones guess, does anyone really care that much 
                ; - about hiding cheat codes?
                ;
raw_key_code_table
                dc.b $be,$58        ; X
                dc.b $ae,$31        ; 1            
                dc.b $92,$51        ; Q
                dc.b $90,$4C        ; L
                dc.b $D0,$20        ; ' '
                dc.b $B0,$30        ; 0
                dc.b $DA,$4A        ; J
                dc.b $B2,$49        ; I
                dc.b $CE,$46        ; F
                dc.b $94,$56        ; V
                dc.b $ff,$fe            ; inserted my own end of table loop code

;L0001c26c       dc.b $4E,$73                   ; back to code (below)
;L0001c26e       dc.b $48,$E7                   ; back to code (below)
;L0001c270       dc.b $FF,$FE                   ; back to code (below) (ends with $FFxx)













                even
                ;*********************************************************************************************************************
                ;*********************************************************************************************************************
                ;*********************************************************************************************************************
                ;
                ;
                ;       Interrupt Service Routines (ISRs)
                ;
                ;
                ;*********************************************************************************************************************
                ;*********************************************************************************************************************
                ;*********************************************************************************************************************




                ;---------------------- level 1 interrupt handler -------------------
                ; Do nothing. This should probably clear the INTREQ bits for
                ; Level 1 interrupts
                ;
                ; *** This interrupt is not enabled in the title screen ***f
                ;
level_1_interrupt_handler                                       ; original address $0001c26c
                rte




                ;---------------------- level 2 interrupt handler -------------------
                ; PORTS/TIMERS - Level 2 Interrupt Handler
                ; CIA-A Timers & Ports
                ;
                ; The ICR Register is cleared by reading the register, but this
                ; code immediately sets it back to the value it just read.
                ; The implications of this are that if this interrupt was not
                ; raised by the CIAA then bit 7 will = 0, this means that when
                ; that value is written back to the register then it will
                ; mask the interrupts that just occurred, and prevent them
                ; from occurring again.
                ;
                ; Conversly if the interrupt was raised by the CIAA then Bit 7 
                ; will be 1, this will enable the interrupt enable bit for the 
                ; interrupts that were raised. This code looks dodgy/hacky
                ;
                ; later the ICR is then set to #$08 which masks the SP bit
                ; this sets the SP bit to 0, which is the keyboard interrupt
                ; serial register bit. So this interrupt is being disabled here
                ; as far as I can make out.
                ;
                ; Obviously this works for reading the keyboard etc, but...
                ; it doesn't appear correct as per the h/w refs that I've read.
                ;
                ; This interrupt is enabled in 'initialise_hardware_state' (PORTS - LVL2)
                ;
level_2_interrupt_handler                                                       ; original routine address $0001c26e
                movem.l d0-d7/a0-a6,-(a7)
                move.b  $00bfec01,raw_keyboard_serial_data_byte                 ; SDR - $0001c2ed ; keyboard serial data
                move.b  $00bfed01,$00bfed01                                     ; ICR - WTF-1!, clear the interrupt control if not a CIAA/Set Interrupts if is CIAA
                move.w  #$0808,$00dff09c                                        ; INTREQ - Clear PORTS(2), 
                                                                                ; WTF-2! - Clear RBF(5) (keyboard serial) - Level 5 Interrupt!
                move.b  #$08,$00bfed01                                          ; ICR - Mask SP bit = 0 (keyboard serial)
                move.b  #$60,$00bfee01                                          ; CRA - Timer A Control - INMODE=1, SPMODE=1
                bsr.w   do_infinite_live_cheat_code                             ; calls $0001c1c0
                movem.l (a7)+,d0-d7/a0-a6
                rte




                ;---------------------- level 3 interrupt handler -------------------
                ; Vertical blank interrupt handler.
                ;   - plays current song
                ;   - scrolls window up/down
                ;   - does hacky stuff with CIAA and keyboard port 
                ;      - reset for serial register input (end of keyboard ACK)
                ;
                ; This interrupt is enabled in 'initialise_hardware_state' (VERTB)
                ;
level_3_interrupt_handler
                movem.l d0-d7/a0-a6,-(a7)
                jsr     SoundDriver_VBlankUpdate                ; $00004018 ; play song
                bsr.w   do_window_scroll                        ; calls $0001c09e
                move.b  $00bfed01,$00bfed01                     ; ICR -> ICR (why?) CIAA nothing to do with level 3 interrupts, also just looks like nonsence
                move.b  #$08,$00bfee01                          ; CIAA - CRA - one shot timer A, stop timer A, SPMODE = input (keyboard)
                move.b  #$88,$00bfed01                          ; CIAA - ICR - enable SP interrupt LVL 2 (keyboard())
                move.w  #$0020,$00dff09c                        ; Clear VERTB interrupt
                not.w   vertical_blank_toggle                   ; toggle vertical blank flag, $0001c2e8
                movem.l (a7)+,d0-d7/a0-a6
                rte  




                ;---------------------- level 4 interrupt handler -------------------
                ; Do nothing. This should probably clear the INTREQ bits for
                ; Level 4 interrupts
                ;
                ; *** This interrupt is not enabled in the title screen ***f
                ; 
level_4_interrupt_handler                                       ; original address $0001c2e4
                rte




                ;---------------------- level 5 interrupt handler -------------------
                ; Do nothing. This should probably clear the INTREQ bits for
                ; Level 5 interrupts
                ;
                ; *** This interrupt is not enabled in the title screen ***f
                ;
level_5_interrupt_handler                                       ; original address $0001c2e6
                rte




                ;---------------------- level 6 interrupt handler --------------------
                ; ***** MISSING ALTOGETHER, BUT INTERRUPTS ARE ENABLED FOR THIS *****
                ; TODO: Add a handler once i've got this assembling as is.



                even
vertical_blank_toggle                                   ; original address $0001C2E8
                dc.w $0000                              ; value appears unused by the title screen (toggled every frame)

unused_002                                              ; original address $0001C2EA
                dc.w $0000



raw_keyboard_serial_data_word                                           ; original address $0001C2EC
                dc.b $00                                                ; keyboard raw key code word (high byte always 0)
raw_keyboard_serial_data_byte                                           ; original address $0001c2ed
                dc.b $00                                                ; keyboard raw key code byte

                even
                dc.w $0000 

raw_key_code_store                                                      ; original address $0001c2f0
                dc.w $0000                                              ; keyboard reading data/flags

deduplicate_keypress_flag                                                      ; original address $0001c2f2
               dc.w $0000                                              ; 0 = music, $ffff = sfx

                ;dc.w $0000, $0000




                ;------------------------- wait raster 161 -------------------------
                ; Waits for raster 161 (#$a1) in a busy loop, it will also
                ; wait for multiple frames for the value set in d0.l
                ;
                ; It has a dodgy processor wait loop which prevents false +ve's
                ; with the vertical check on the same raster line (it's a bit shit) 
                ;
                ; reading and comparing a byte value might not be the best approach
                ; on a custom register.
                ;
                ; IN: D0.l = number of frames to wait + 1
                ;
raster_wait_161                                                 ; original routine address $0001c2f8

        IFND VBLANK_FIX
.vwait 
                cmp.b   #$a1,$00dff006                          ; compare VHPOSR with #$a1 (161)
                bne.b   .vwait
                move.w  #$001e,d1
.processor_wait
                dbf.w  d1,.processor_wait
                dbf.w  d0,raster_wait_161
        ELSE
.vwait1 
                cmp.b   #$a1,$00dff006                          ; compare VHPOSR with #$a1 (161)
                bne.b   .vwait1
.vwait2 
                cmp.b   #$a2,$00dff006                          ; compare VHPOSR with #$a2 (162)
                bne.b   .vwait2
                dbf.w  d0,.vwait1
        ENDC

return_rts      rts





                even
xy_coords
x_coord                                                 ; original address L0001c310
                dc.w    $0000                           ; x co-ord (byte value)
y_coord                                                 ; original address L0001c312
                dc.w    $0000                           ; y co-ord (line value)
current_text_ptr                                        ; original address L0001c314
                dc.l    $00000000                       ; $0001c784 - address of start of text being displayed (used for looping back to start)




unused_background_flash                                 ; original routine address $0001c318
                add.w #$0001,d7
                move.w d7,$00dff180
                rts 


DISPLAY_WIDTH_BYTES      EQU $28        ; display width = 40 bytes per scan line
TYPERCHAR_BITPLANE_SIZE  EQU $10        ; character set = 16 bytes per bitplane
TYPERCHAR_WIDTH_BYTES    EQU $2         ; character is 2 bytes wide (16 pixels)

                ;----------------------- text typer ------------------------
                ; type out screen of text, also process control codes for
                ; special chars and inserting hi score table etc.
                ;
                ; IN: a6 - text structure for display
                ;          1 word - display co-ords (x,y bytes)
                ;          x bytes - text & display codes
                ;          1 byte  - #$ff - end text display
                ;
_run_text_typer                                                      ; original routine address $0001c324
                move.l  a6,current_text_ptr                     ; $0001c314 ; store a6 address (used for looping when CODE #$00)
                move.b  (a6)+,x_coord+1                         ; store x coord - $0001c311
                move.b  (a6)+,y_coord+1                         ; store y coord - $0001c313

resume_text_typer_start_line
                moveq   #$00,d0
                move.w  y_coord,d0                              ; $0001c312 ; d0 = y co-ord
                mulu.w  #$0028,d0                               ; d0 = d0 * 40 (bytes per scan line)
                add.w   x_coord,d0                              ; $0001c310 ; d0 = d0 + x co-ord
                add.l   #DISPLAY_BITPLANE_ADDRESS,d0            ; #$00063190,d0 ; add bitplane base address
                exg.l   d0,a2                                   ; a2 = display destination address
                movea.l a2,a3                                   ; a3 = display destination address

resume_text_typer_current_position
                tst.w   typer_extended_command_1                ; $0001c782 - exension command/params (for commands #$02)
                bne.w   continue_wait_or_start_game             ; jmp $0001c50e
                move.b  (a6)+,d0                                ; get display param
                cmp.b   #$ff,d0
                beq.w   return_rts                              ; $0001c30e
                cmp.b   #$0d,d0
                beq.w   crlf                                    ; jmp $0001c4d0 - crlf - carriage return plus line feed
                cmp.b   #$0e,d0
                beq.w   lf                                      ; jmp $0001c4dc - lf, line feed
                cmp.b   #$01,d0
                beq.w   cls                                     ; jmp $0001c4e8 - clear screen
                cmp.b   #$06,d0
                beq.w   _nop                                    ; jmp $0001c580 - no operation
                cmp.b   #$02,d0
                beq.w   wait_or_start_game                      ; jmp $0001c4fe - check fire button/start game?
                cmp.b   #$03,d0
                beq.w   hi_scores                               ; jmp $0001c53e - start displaying hi score table
                cmp.b   #$04,d0
                beq.w   end_hi_scores                           ; jmp $0001c54e - resume typer after hi score table
                cmp.b   #$05,d0
                beq.w   hi_score_and_text_typer                 ; jmp $0001c586 - name up/enter initials
                cmp.b   #$40,d0
                beq.w   .copyright_symbol                       ; jmp $0001c3f6 '@' convert to 2nd character after 'Z' - (c) symbol 
                cmp.b   #$26,d0
                beq.w   .ampersand_symbol                       ; JMP $0001c3e6 '&' convert to 3rd character after 'Z' - '&' symbol
                cmp.b   #$23,d0
                beq.w   maybe_backspace                         ; jmp $0001c558 '#' symbol - unsure, decrements x offset
                cmp.b   #$2e,d0
                beq.w   .fullstop_symbol                        ; jmp $0001c3ee '.' convert to 1st character after 'Z'
                and.w   #$003f,d0
                beq.w   loop_text_typer                      ; jmp $0001c534 - #$00 = ***** Loop Text Typer ***** 
                cmp.b   #$20,d0
                beq.w   .space_symbol                           ; jmp $0001c3fe ' ' - increment x position.       
                cmp.b   #$30,d0
                blt.w   .plot_character                         ; jmp $0001c404 - plot raw char code from offset
                sub.w   #$0014,d0
                bra.w   .plot_character                         ; jmp $0001c404 - subtract ' ' char and plot raw char code

.ampersand_symbol
                move.w  #$002c,d0
                bra.w   .plot_character                         ; jmp $0001c404

.fullstop_symbol
                move.w  #$002a,d0
                bra.w   .plot_character                         ; jmp $0001c404

.copyright_symbol
                move.b  #$002b,d0                               ; d0 = 43 - character offset (plus #$30)
                bra.w   .plot_character                         ; jmp $0001c404 - 

.space_symbol
                addq.l  #$01,a3
                bra.w   resume_text_typer_current_position            ; jmp $0001c352

.plot_character
               ; decrement character offset by 1, to match gfx data
               subq.w   #1,d0

               ; calculate the character gfx data address from the character offset
               ; 80 bytes per char (16 bytes per bitplane * 5 bitplanes)
               mulu.w  #$0050,d0
               add.l   #ASSET_CHARSET_BASE,d0
               exg.l   d0,a1

               ; set up bitplane loop counter
               moveq   #$04,d7                                 

               ; set gfx destination address for plotting character
               movea.l a3,a2
.copy_loop
                    ; plot the bitplane bytes
                    move.b  TYPERCHAR_WIDTH_BYTES*0(a1),DISPLAY_WIDTH_BYTES*0(a2)
                    move.b  TYPERCHAR_WIDTH_BYTES*1(a1),DISPLAY_WIDTH_BYTES*1(a2)
                    move.b  TYPERCHAR_WIDTH_BYTES*2(a1),DISPLAY_WIDTH_BYTES*2(a2)
                    move.b  TYPERCHAR_WIDTH_BYTES*3(a1),DISPLAY_WIDTH_BYTES*3(a2)
                    move.b  TYPERCHAR_WIDTH_BYTES*4(a1),DISPLAY_WIDTH_BYTES*4(a2)
                    move.b  TYPERCHAR_WIDTH_BYTES*5(a1),DISPLAY_WIDTH_BYTES*5(a2)
                    move.b  TYPERCHAR_WIDTH_BYTES*6(a1),DISPLAY_WIDTH_BYTES*6(a2)
                    move.b  TYPERCHAR_WIDTH_BYTES*7(a1),DISPLAY_WIDTH_BYTES*7(a2)

                    ; update source and destination addresses for next bitplane
                    adda.l  #TYPERCHAR_BITPLANE_SIZE,a1  
                    adda.l  bitplane_size,a2  

               ; draw next bitplane   
               dbf.w   d7,.copy_loop         
               
               ; move cursor to next x position for next character
               addq.l  #$01,a3

               ; continue typing at the current position on the screen
               bra.w   resume_text_typer_current_position
               ;rts  




                ;--------------------- plot character x & y ----------------------
                ; plot character at x and y co-ords
                ; IN: d0 = character offset to plot starts at character '0'
                ;
char_plot_x_coord                               ; original address $0001c45a
                dc.w $0000                      ; x co-ord (byte value)
char_plot_y_coord                               ; original address $0001c45c
                dc.w $0000                      ; y co-ord (line value)

plot_character
                moveq   #$00,d3
                moveq   #$00,d2
                move.w  char_plot_y_coord,d3            ; L0001c45c,d3 ; y co-ordinate
                move.w  char_plot_x_coord,d2            ; L0001c45a,d2 ; x co-ordinate
                mulu.w  #$0028,d3                       ; d3 = d3 * 40 (raster line)
                add.w   d3,d2                           ; d2 = x & y co-ords byte offset
                add.l   #DISPLAY_BITPLANE_ADDRESS,d2    ; #$00063190 ; add bitplane 1 base address
                exg.l   d2,a2                           ; a2 = dest address, d1 = prev value of a2
                and.l   #$0000003f,d0                   ; clamp d0 to 0-63
                subq.w  #$0001,d0                       ; decrement character offset by 1, to match gfx data
                mulu.w  #$0050,d0                       ; 80 bytes per char (16 bytes per bitplane) 8*8
                add.l   #ASSET_CHARSET_BASE,d0          ; #$0003f1ea ; character set gfx base address
                exg.l   d0,a1                           ; a1 = character source address
                moveq   #$04,d7                         ; d7 = 4 + 1 - bitplane loop count
                moveq   #$00,d1                         ; d1 = 0
.copy_loop
                move.b  (a1),(a2)                       ; copy character data line 1
                move.b  $0002(a1),$0028(a2)             ; copy character data line 2
                move.b  $0004(a1),$0050(a2)             ; copy character data line 3
                move.b  $0006(a1),$0078(a2)             ; copy character data line 4
                move.b  $0008(a1),$00a0(a2)             ; copy character data line 5
                move.b  $000a(a1),$00c8(a2)             ; copy character data line 6
                move.b  $000c(a1),$00f0(a2)             ; copy character data line 7
                move.b  $000e(a1),$0118(a2)             ; copy character data line 8
                adda.l  #$00000010,a1                   ; a1 = start next bitplane of char
                adda.l  bitplane_size,a2                ; L0001ca3e,a2
                dbf.w   d7,.copy_loop
                rts



                ;----------------- crlf ---------------------
                ; carriage return plus line feed.
                ; continue typing at the start of the next
                ; line on the screen.
crlf                                                    ; original address $0001c4d0
                add.w   #$0008,y_coord                  ; $0001c312, add 8 scan lines to y coord
                bra.w   resume_text_typer_start_line          ; jmp $0001c336



                ;---------------- line feed -----------------
                ; continue typing one line down without
                ; returning to the start of the line.
lf                                                      ; original address $0001c4dc
                adda.l  #$00000140,a3                   ; add 320 to raster line (next page)
                movea.l a3,a2                           ; update dest display ptrs
                bra.w   resume_text_typer_current_position    ; jmp $0001c352



                ;--------------- clear screen --------------
                ; clear screen bitplanes and reset x,y
                ; coords.
cls
                bsr.w   copy_title_screen_bitplanes     ; calls $0001ca34
                move.w  #$0007,x_coord                  ; $0001c310
                clr.w   y_coord                         ; $0001c312 
                bra.w   resume_text_typer_start_line          ; $0001c336 



                ;-------------- code #$02 -----------------
                ; code: #$02 - 
                ; initialise 'wait_or_start_game'
                ; get the number of frames to wait for
                ; displaying the current page of text.
wait_or_start_game                                      ; original routine address $0001c4fe
                move.b  (a6)+,d0
                move.b  d0,typer_extended_command_1     ; $0001c782
                move.b  (a6)+,d0
                move.b  d0,typer_extended_command_2     ; $0001c783
                ; falls through to 'wait_or_start_game'


                ;------------------ wait or start game ---------------
                ; continuation of the the wait_or_start_game command/
                ; decrements the counter, waits for the required number
                ; of frames.
                ;
                ; if joystick button is pressed (port 2)
                ; then jumps to start game code.
                ;
continue_wait_or_start_game
                moveq   #$00,d0
                bsr.w   raster_wait_161                 ; calls $0001c2f8
                bsr.w   do_title_screen_menu_options    ; calls $0001c172
                btst.b  #$0007,$00bfe001                ; Port 2 Fire Button (Joystick)
                beq.b   .firebutton_pressed             ; $0001c52e ; if button pressed, start game?
                sub.w   #$0001,typer_extended_command_1 ; $0001c782 - decrement fame wait time
                bra.w   resume_text_typer_current_position    ; jmp $0001c352

.firebutton_pressed
                jmp     start_game                      ; jmp $0001c05e



                ;--------------- loop text typer -----------------
                ; CODE #$00 - restart text typer from initial
                ;             saved text prt
loop_text_typer                                                 ; original address $0001c534
                movea.l current_text_ptr,a6                     ; $0001c314 [00000000],a6
                bra.w   _run_text_typer                              ; calls $0001c324 - display text
                ; use _run_text_typer rts to return



                ;--------------------- hi scores -------------------
                ; CODE: #$03 - start displaying Hi Score Table
                ;
hi_scores                                                       ; original routine address $0001c53e
                move.l  a6,temp_typer_text_ptr                  ; $0001c77e ; store current text typer ptr position
                movea.l #high_score_display_text,a6             ; #$0001c974 ; resume text from this location (HI SCORE TABLE)
                bra.w   resume_text_typer_current_position            ; jmp $0001c352



                ;-------------------end hi scores ------------------
                ; CODE: #$04 - resume typing text after hi scores
                ;
end_hi_scores                                                   ; original routine address $0001c54e
                movea.l temp_typer_text_ptr,a6                  ; $0001c77e ; restore text typer source ptr from saved location
                bra.w   resume_text_typer_current_position            ; jmp $0001c352



maybe_backspace                                                 ; original routine address $0001c558
                move.w  x_coord,char_plot_x_coord               ; $0001c45a
                move.w  y_coord,char_plot_y_coord               ; $0001c45c
                move.b  #$20,d0
                bsr.w   plot_character                          ; calls $0001c45e
                sub.w   #$0001,x_coord                          ; $0001c310
                bra.w   resume_text_typer_current_position            ; jmp $0001c352



                ;-------------------- nop -----------------------
                ; do nothing, just resume text typing
_nop                                                            ; original address $0001c580
                bra.w   resume_text_typer_current_position            ; jmp $0001c352



                ;-------- dangling rts instruction --------------
                rts








               ;------------------------ hi score and text typer -------------------------
               ; This routine probably covers too much responsibility which make it
               ; hard to understand. It does the following:-
               ;
               ;    1) Checks if the player's score is a high score.
               ;         - As part of this check it manipulates 2 tables (if is a HiScore)
               ;              - a) highscore_table_BCD_format - a table of 32 bit BCD formatted HiScore entries
               ;              - b) highscore_table_text - the formatted display of the high scores for the title screen.
               ;         - It will have moved the lower scores down into their new positions.
               ;         - It will have calculated the Index into the tables for the new score and Initials to be entered.
               ;
               ;    2) IF is a HiScore THEN 
               ;         - Populates new HiScore into BCD Score table (using index above)
               ;         - Populates the Text Display ready for entering player initials (using index above)
               ;         - Displays the HiScore Text Display
               ;         - Enters a loop where Player Initials are entered
               ;         - Calls the main title screen text typer (which also detects start game)
               ;              - highscore_table_text
               ;
               ;       ELSE
               ;         - Calls the main title screen text typer (which also detects start game)
               ;              - highscore_table_text
               ;
               ;
               ; Additional Note:
               ;    The return from this routine is to the source of the BSR to hi_score_and_text_typer
               ;    made from the 'return_to_title_screen' procedure which then transistions out of the
               ;    title screen and calls the loader to load level 1.
               ;
               ; Original Address $0001c586
               ;

HISCORE_TEXT_LINE_LEN              EQU $17        ; 23 bytes per line of text for hi score table
HISCORE_TEXT_LINE_INITIALS_OFFSET  EQU $0a        ; 10 bytes into the line is where the initials are stored
HISCORE_ENTRIES_LIMIT              EQU $05        ; 5 entries in the hi score table
HISCORE_TEXT_SCORE_DIGIT_OFFSET    EQU $000f      ; index to the first character of the HiScore text within the text line.
HISCORE_TEXT_INITIALS_CHAR_OFFSET  EQU $0011      ; index to the first character of the Player Initials within the text line.

               ; The score is stored as a long (32 bit) value in the BCD format, 
               ; Only the lowest 24bits (3 bytes) are used to store 6 digits of the score.
               ;  - the lowest 2 digist (units and tens) are stored 3 bytes into the BCD score table
               ;  - the middle 2 digits (hundreds and thousands) are stored 1 byte into the BCD score table
               ;  - the highest 2 digits (ten thousands and hundred thousands) are stored 2 bytes into the BCD score table
               ;
BCD_SCORE_LSB_OFFSET          EQU $0003           ; 3 bytes into the BCD score table is where the lowest 2 digits of the score are stored
BCD_SCORE_MID_OFFSET          EQU $0002           ; 2 bytes into the BCD score table is where the middle 2 digits of the score are stored
BCD_SCORE_MSB_OFFSET          EQU $0001           ; 1 byte into the BCD score table is where the highest 2 digits of the score are stored
                                                  ; Byte at offset 0 is unused

ASCII_CHAR_0                  EQU $30             ; ASCII char '0' = #$30, used to convert BCD digit to ASCII char for display
ASCII_CHAR_SPACE              EQU $20             ; ASCII char ' ' = #$20, used to clear initials in hi score table text display

hi_score_and_text_typer                  
               ; a5.l = lowest highscore table entry (5th)                               
               lea.l   highscore_table_BCD_format+16,a5 

               ; a4.l = text display for highscore table (6th entry) not displayed, 
               ; used for rolling down the last entry making space for the new high score entry.
               lea.l   end_of_highscore_table_text,a4
                
               ; initialise d0.l (index into score_y_coord_table) to 0
                moveq   #$00,d0
.hiscore_check_loop
                    ; get high score entry from BCD table,
                    move.l  (a5),d6                        
                    ; compare high score entry with player score
                    cmp.l   PANEL_PLAYERSCORE,d6                 
                    ; if not higher than the current high score then exit loop
                    bgt.w   .exit_hiscore_check_loop

.is_higher_score
                    ; copy current hi-score text down one entry in the list
                    ; makes space for the new high score entry to be inserted into the table.

                    ; first move the entry down in the BCD score table
                    move.l  (a5),$0004(a5)
                    subq.l  #$04,a5
                    
                    ; second move the entry down in the text display table
                    ; get pointer to text display entry to move down - #$17 (23) characters 
                    suba.l  #HISCORE_TEXT_LINE_LEN,a4                 
                    move.b  HISCORE_TEXT_LINE_INITIALS_OFFSET(a4),HISCORE_TEXT_LINE_INITIALS_OFFSET+HISCORE_TEXT_LINE_LEN(a4)           ; copy display test down the table.
                    move.b  HISCORE_TEXT_LINE_INITIALS_OFFSET+1(a4),HISCORE_TEXT_LINE_INITIALS_OFFSET+HISCORE_TEXT_LINE_LEN+1(a4)
                    move.b  HISCORE_TEXT_LINE_INITIALS_OFFSET+2(a4),HISCORE_TEXT_LINE_INITIALS_OFFSET+HISCORE_TEXT_LINE_LEN+2(a4)
                    move.b  HISCORE_TEXT_LINE_INITIALS_OFFSET+5(a4),HISCORE_TEXT_LINE_INITIALS_OFFSET+HISCORE_TEXT_LINE_LEN+5(a4)
                    move.b  HISCORE_TEXT_LINE_INITIALS_OFFSET+6(a4),HISCORE_TEXT_LINE_INITIALS_OFFSET+HISCORE_TEXT_LINE_LEN+6(a4)
                    move.b  HISCORE_TEXT_LINE_INITIALS_OFFSET+7(a4),HISCORE_TEXT_LINE_INITIALS_OFFSET+HISCORE_TEXT_LINE_LEN+7(a4)
                    move.b  HISCORE_TEXT_LINE_INITIALS_OFFSET+8(a4),HISCORE_TEXT_LINE_INITIALS_OFFSET+HISCORE_TEXT_LINE_LEN+8(a4)
                    move.b  HISCORE_TEXT_LINE_INITIALS_OFFSET+9(a4),HISCORE_TEXT_LINE_INITIALS_OFFSET+HISCORE_TEXT_LINE_LEN+9(a4)
                    move.b  HISCORE_TEXT_LINE_INITIALS_OFFSET+10(a4),HISCORE_TEXT_LINE_INITIALS_OFFSET+HISCORE_TEXT_LINE_LEN+10(a4)

                    ; increase index counter for score_y_coord_table
                    addq.w  #$01,d0
               
               ; have we checked all 5 high score entries?
               cmp.w   #HISCORE_ENTRIES_LIMIT,d0                                       ; 5 high scores to check against
               bne.w   .hiscore_check_loop

                ; d0 = high score entry counting from bottom of the table 1-5
.exit_hiscore_check_loop
.check_hiscore_index
                tst.w   d0
                beq.w   display_title_screen_text                       ; if d0 = 0 then not an high score, jmp $0001c760

                ; a4 = text display
                ; a5 = score table
                ; d0 = score index
.is_an_high_score            
               ; move old BCD HiScore down in the BCD score table
                move.l  (a5),$0004(a5)
                ; insert new HiScore into DCB score table
                move.l  PANEL_PLAYERSCORE,(a5)                          ; set high score in score table
                
               ; clear the initials in the text display for the new high score entry
                move.b  #ASCII_CHAR_SPACE,HISCORE_TEXT_LINE_INITIALS_OFFSET(a4) 
                move.b  #ASCII_CHAR_SPACE,HISCORE_TEXT_LINE_INITIALS_OFFSET+1(a4) 
                move.b  #ASCII_CHAR_SPACE,HISCORE_TEXT_LINE_INITIALS_OFFSET+2(a4) 

               ; Add player score to text display score table as ASCII chars for display.
               ; Converts pairs of digits from BCD to ASCII and stores them 
               ; in the display text for the new high score entry.
               ; a5 = address of BCD format score (32 bit long word)
               ; a4 = address of line of text for the new high score entry (23 bytes)
.add_score_to_table_bcd              
               ; save d0.l (index of hi-score entry into score_y_coord_table)
                movem.l d0,-(a7)
.digits_5_and_6_to_ASCII                
                move.b  BCD_SCORE_LSB_OFFSET(a5),d0                     ; d0 = score byte (BCD)
                move.b  d0,d1                                           ; d1 = copy score byte (BCD)
                and.b   #$0f,d0                                         ; d0 = low digit
                add.w   #ASCII_CHAR_0,d0                                ; d0 = add Ascii base for '0'
                lsr.b   #$04,d1                                         ; d1 = second score digit
                add.w   #ASCII_CHAR_0,d1                                ; d1 = add Ascii base for '0'
                move.b  d0,HISCORE_TEXT_SCORE_DIGIT_OFFSET+5(a4)        ; store score digit 1 - least significant
                move.b  d1,HISCORE_TEXT_SCORE_DIGIT_OFFSET+4(a4)        ; store score digit 2 - second digit

.digits_3_and_4_to_ASCII                                                         ; original address $0001c62e
                move.b  BCD_SCORE_MID_OFFSET(a5),d0                     ; d0 = score byte (BCD)
                move.b  d0,d1                                           ; d1 = copy score byte (BCD)
                and.b   #$0f,d0                                         ; d0 = low digit
                add.w   #ASCII_CHAR_0,d0                                ; d0 = add Ascii base for '0'
                lsr.b   #$04,d1                                         ; d1 = second score digit
                add.w   #ASCII_CHAR_0,d1                                ; d1 = add Ascii base for '0'
                move.b  d0,HISCORE_TEXT_SCORE_DIGIT_OFFSET+3(a4)        ; store score digit 1 - least significant
                move.b  d1,HISCORE_TEXT_SCORE_DIGIT_OFFSET+2(a4)        ; store score digit 2 - second digit

.digits_1_and_2_to_ASCII                                                         ; original address $0001c64a
                move.b  BCD_SCORE_MSB_OFFSET(a5),d0                     ; d0 = score byte (BCD)
                move.b  d0,d1                                           ; d1 = copy score byte (BCD)
                and.b   #$0f,d0                                         ; d0 = low digit
                add.w   #ASCII_CHAR_0,d0                                ; d0 = add Ascii base for '0'
                lsr.b   #$04,d1                                         ; d1 = second score digit
                add.w   #ASCII_CHAR_0,d1                                ; d1 = add Ascii base for '0'
                move.b  d0,HISCORE_TEXT_SCORE_DIGIT_OFFSET+1(a4)        ; store score digit 1 - least significant
                move.b  d1,HISCORE_TEXT_SCORE_DIGIT_OFFSET(a4)          ; store score digit 2 - second digit

.init_enter_initials
               ; set text position to the correct address for 1st initial character
               adda.l  #HISCORE_TEXT_LINE_INITIALS_OFFSET,a4                                   ; increase text display ptr by 10 chars
         
               ; restore d0.l (index of hi-score entry into score_y_coord_table)
               movem.l (a7)+,d0

               ; look up starting y screen co-ord for ploting Player Initials
               lea.l   score_y_coord_table,a0 
               asl.w   #$01,d0                                         ; d0 = d0 * 2 (index to a0 table)
               move.w  $00(a0,d0.w),char_plot_y_coord                  ; L0001c45c - set y co-ord 
               
               ; set starting x screen co-ord for plotting Player Initials
               move.w  #HISCORE_TEXT_INITIALS_CHAR_OFFSET,char_plot_x_coord                        ; L0001c45a - set x co-ord first char
               
               move.w  #$0003,name_initials_count                      ; L0001c776 - number of letters to enter
               
               ; Insert text typer code to end display of last hidden entry
               ; CODE #$04 makes typer End HighScore table
               move.b  #$04,high_score_6th_entry   
             
.display_hiscore_table
               lea.l   display_hiscores,a6                             ; L0001c96e ; (a6) = $0c30 - x,y display co-ords
               bsr.w   _run_text_typer                                      ; $0001c324 ; type text

               moveq   #$01,d6                                         ; d6 = initialise the current displayed character(initials entry)
               bsr.w   .draw_current_character                         ; calls $0001c710 
                *** This never returns (looks like it should be a bra?) ***
                *** Enters the .initials_entry_loop ***
                *** Eventually jumps out at .end_intial_entry

.initials_entry_loop                                                    ; original address $0001c6a8
                moveq   #$04,d0
                bsr.w   raster_wait_161                                 ; calls $0001c2f8 - wait 4 frames
                clr.l   joystick_left                                   ; clear both joystick left & right flags - $0001c778
                ;clr.w   unused_var_flag                                 ; clear the 16 bit word - appears unused else where - $0001c77c
                move.w  $00dff00c,d0                                    ; d0 = JOT1DAT
                btst.l  #$0001,d0                                       ; joystick right (active high)
                sne.b   joystick_right                                  ; $0001c77a
                btst.l  #$0008,d0                                       ; joystick left (active high)
                sne.b   joystick_left                                   ; $0001c778

.test_joystick_button
                btst.b  #$0007,$00bfe001
                beq.w   .wait_joystick_button_released                  ; L0001c71a

                move.w  joystick_left,d0                                ; $0001c778,d0
                or.w    joystick_right,d0                               ; $0001c77a,d0
                beq.b   .initials_entry_loop                            ; no joystick input - loop, L0001c6a8

                tst.w   joystick_left                                   ; $0001c778
                bne.w   .stick_left                                     ; L0001c706

.stick_right
                ;cmp.w   #$001b,d6                                       ; check last character index
                cmp.w   #$0025,d6                                       ; check last character index
                beq.w   .initials_entry_loop                            ; if at last character then loop
                addq.w  #$01,d6                                         ; increment current character
                bra.w   .draw_current_character                         ; calls $0001c710

.stick_left
                cmp.w   #$0001,d6                                       ; check is at 1st character
                beq.w   .initials_entry_loop                            ; if is first character then don't update, just loop
                subq.w  #$01,d6                                         ; decrement current character

.draw_current_character                                                 ; original address $0001c710
                move.b  d6,d0
                bsr.w   plot_character                                  ; calls $0001c45e
                bra.w   .initials_entry_loop                            ; L0001c6a8

.wait_joystick_button_released
                btst.b  #$0007,$00bfe001
                beq.w   .wait_joystick_button_released                  ; L0001c71a

.increment_next_char
                add.w   #$0001,char_plot_x_coord                        ; L0001c45a - advance to next character entry
                move.b  d6,d0                                           ; d0,d6 = current character
                cmp.b   #$1c,d0                                         ; test current char = #$1c (28)
                bne.w   .not_end
                move.w  #$ffe0,d0                                       ; insert -32 (equals a space char when #$40 is added back to it below)
.not_end
                add.b   #$40,d0
                move.b  d0,(a4)+                                        ; update display text
                sub.w   #$0001,name_initials_count                      ; update next name initial index, L0001c776
                beq.w   .end_intial_entry                               ; L0001c758
                move.b  d6,d0
                bsr.w   plot_character                                  ; calls $0001c45e
                bra.w   .initials_entry_loop                            ; L0001c6a8 

.end_intial_entry                                                       ; original address $0001c758
                move.w  #$0060,typer_extended_command_1                 ; $0001c782
                ; fall through to 'display_title_screen_text' below




               ;--------------------- display title screen text -----------------------------
               ; start the text typer routine that cycles through the text displayed over
               ; the title screen as a set of text pages. Includes the display of the 
               ; high score table etc. 
               ; strangely the typer routine also waits for the joystick button to be
               ; pressed for the start game.
               ;
               ; Original Address $0001c760
               ;
display_title_screen_text         
               ; start displaying title screen text
               ; NB: typer returns when start button is pressed.
               lea.l     title_screen_text,a6
               bsr       _run_text_typer
               rts




               ; ookup table of y co-ordinates for each line of the hi-score table on the screen, bottom to top
               ; first entry is not used, 2nd entry is the bottom line of the hi-score table.
               ; Original Address $0001C76A
               ;
score_y_coord_table                                             
               dc.w $0058              ; unused entry as index always at least 1
               dc.w $0060
               dc.w $0050
               dc.w $0040
               dc.w $0030
               dc.w $0020

name_initials_count                                             ; original address $0001C776
                dc.w $0000                                      ; count of hi-score initials entered during the entry loop. initialised to 3, exits loop when 0

; used during enter high score initial loop
joystick_left                                                   ; original address $0001C778
                dc.w $0000                                      ; joystick left (SET TRUE)
joystick_right
                dc.w $0000                                      ; joystick right (SET TRUE)

;unused_var_flag                                                 ; original address $0001C77C
;                dc.w $0000                                      ; cleared when joystick values are read during hi-score initials entry loop - appears unused apart from being cleared in the loop.

temp_typer_text_ptr                                             ; original address $0001c77e
                dc.l $00000000                                  ; store ptr to typer text while command types hi-score table

typer_extended_command_1                                        ; original address $0001C782
                dc.b $00
typer_extended_command_2                                        ; original address $0001C783
                dc.b $00 




               ; -------------------------------- TITLE SCREEN TEXT ----------------------------
               ; The following data constructs the text displayed on the title screen as
               ; individual pages of text.
               ;
               ; There are vaious codes that control the display formatting definied in the
               ; equates below.
               ;
               ; Original Address $0001c784
               ; 
TEXT_TYPER_LOOP_TO_START           EQU  $00       ; 1 Byte Command - Restart Text Typer from the start
TEXT_TYPER_CLEAR_SCREEN            EQU  $01       ; 1 Byte Command - Clear Text Typer Screen (Restores Background GFX)
TEXT_TYPER_PAUSE                   EQU  $02       ; 3 byte Command - following 2 bytes are the wait time in screen frames (50 Hz)
TEXT_TYPER_HISCORES                EQU  $03       ; 1 byte Command - Display High Score Table
TEXT_TYPER_END_HISCORE_TABLE       EQU  $04       ; 1 Byte Command - CODE #$04 makes typer End HighScore table
TEXT_TYPER_NOP                     EQU  $06       ; 1 Byte Command - No Operation
TEXT_TYPER_CR                      EQU  $0d       ; 1 Byte Command - Carriage Return
TEXT_TYPER_TERMINATE               EQU  $ff       ; 1 Byte Command - Exit Typer (Used for Displaying hi-Scores then exiting for entering player initials) 


title_screen_text                                                                    
               ; Page 1
               dc.b $01,$01                                 ; display co-ords (x,y)
               dc.b TEXT_TYPER_CLEAR_SCREEN 
               dc.b TEXT_TYPER_CR
               dc.b TEXT_TYPER_CR
               dc.b TEXT_TYPER_CR
               dc.b TEXT_TYPER_CR
               dc.b TEXT_TYPER_CR
               dc.b TEXT_TYPER_CR
               dc.b '      OCEAN SOFTWARE',TEXT_TYPER_CR
               dc.b TEXT_TYPER_CR                   
               dc.b '         PRESENTS   ',TEXT_TYPER_CR                       
               dc.b TEXT_TYPER_PAUSE,$00,$80                ; wait for 2.5 seconds (128 frames)

               ; Page 2
               dc.b TEXT_TYPER_CLEAR_SCREEN
               dc.b TEXT_TYPER_NOP
               dc.b TEXT_TYPER_CR
               dc.b TEXT_TYPER_CR
               dc.b TEXT_TYPER_CR
               dc.b TEXT_TYPER_CR
               dc.b TEXT_TYPER_CR
               dc.b TEXT_TYPER_CR
               dc.b '          BATMAN',TEXT_TYPER_CR
               dc.b TEXT_TYPER_CR
               dc.b '        THE MOVIE'
               dc.b TEXT_TYPER_PAUSE,$00,$80                ; wait for 2.5 seconds (128 frames)

               ; Page 3
               dc.b TEXT_TYPER_CLEAR_SCREEN
               dc.b TEXT_TYPER_CR
               dc.b TEXT_TYPER_CR
               dc.b '   TM & @ DC COMICS INC.',TEXT_TYPER_CR 
               dc.b '           1989 ',TEXT_TYPER_CR
               dc.b TEXT_TYPER_CR
               dc.b TEXT_TYPER_CR
               dc.b '   @ OCEAN SOFTWARE 1989',TEXT_TYPER_CR
               dc.b TEXT_TYPER_CR
               dc.b '     ESC..ABORT GAME',TEXT_TYPER_CR
               dc.b TEXT_TYPER_CR 
               dc.b '      F1..PAUSE GAME',TEXT_TYPER_CR
               dc.b TEXT_TYPER_CR
               dc.b '      F2..TOGGLE MUSIC',TEXT_TYPER_CR
               dc.b TEXT_TYPER_PAUSE,$01,$00                ; wait for 5 (256) seconds

               ; Page 4
               dc.b TEXT_TYPER_CLEAR_SCREEN
               dc.b TEXT_TYPER_CR
               dc.b '   CODING BY',TEXT_TYPER_CR
               dc.b '            MIKE LAMB',TEXT_TYPER_CR 
               dc.b '            JOBBEEEE',TEXT_TYPER_CR
               dc.b '            SHORTY',TEXT_TYPER_CR
               dc.b TEXT_TYPER_CR
               dc.b '   GRAPHICS BY',TEXT_TYPER_CR
               dc.b '            DAWN DRAKE',TEXT_TYPER_CR
               dc.b '            BILL HARBISON',TEXT_TYPER_CR
               dc.b '            JOHN PALMER',TEXT_TYPER_CR
               dc.b TEXT_TYPER_CR
               dc.b '   MUSIC AND FX BY',TEXT_TYPER_CR
               dc.b '            JON DUNN',TEXT_TYPER_CR
               dc.b '            MATTHEW CANNON' 
               dc.b TEXT_TYPER_PAUSE,$01,$00                ; wait for 5 (256) seconds
                
               ; Page 5 (HiScore Table)
               dc.b TEXT_TYPER_CLEAR_SCREEN
               dc.b TEXT_TYPER_HISCORES
               dc.b TEXT_TYPER_PAUSE,$00,$f0                ; wait for 2.5 seconds

               ; Page 6 (non page)
               dc.w TEXT_TYPER_CLEAR_SCREEN
               dc.b TEXT_TYPER_LOOP_TO_START
               dc.b TEXT_TYPER_TERMINATE                    ; Exit Typer (never reaches here)                                                     



               ; Text Screen for Entering Hi-Score Player Initials
               ;
               ; Original Address $0001C96E
               ;
display_hiscores 
               dc.b $0C,$30                                ; display co-ords x, y               
               dc.b TEXT_TYPER_CLEAR_SCREEN
               dc.b TEXT_TYPER_CR
               dc.b TEXT_TYPER_HISCORES
               dc.b TEXT_TYPER_TERMINATE                   ; Exit Typer




               ;------------------------- HIGH SCORE DISPLAY TABLE ----------------------------
               ; The text typer displays this text when encountering CODE #$03, it ends
               ; and resumes where it left off when encountering CODE #$04.
               ; - title     = 21 chars (incl control codes)
               ; - lines 1-6 = 23 chars (incl control codes)
               ; - The 6th line entry is only used to roll the last entry into when inserting
               ;   a new high score into the table.
               ;   The insertion routine stuffs the code #$04 into the start of the 6th 
               ;   entry, preventing the text typer routine from displaying it on screen.
               ;
               ;  Contains Default Hi-Score Player Initials
               ;
high_score_display_text                                                                                            ; original address $0001C974
               dc.b '         HI SCORES',TEXT_TYPER_CR
               dc.b TEXT_TYPER_CR
               dc.b TEXT_TYPER_CR       
               dc.b '     1ST  AJS  125000',TEXT_TYPER_CR,TEXT_TYPER_CR
               dc.b '     2ND  MIK  100000',TEXT_TYPER_CR,TEXT_TYPER_CR
               dc.b '     3RD  JOB  075000',TEXT_TYPER_CR,TEXT_TYPER_CR
               dc.b '     4TH  BIL  050000',TEXT_TYPER_CR,TEXT_TYPER_CR
               dc.b '     5TH  JON  025000',TEXT_TYPER_CR,TEXT_TYPER_CR
end_of_highscore_table_text                                                                                         ; original address $0001C9FC
high_score_6th_entry                                                                                               ; original address $0001C9FC - not displayed, buffer to roll last entry into
               dc.b '                     ',TEXT_TYPER_CR,TEXT_TYPER_CR
               dc.b TEXT_TYPER_END_HISCORE_TABLE            ; resume typer after insertion of high score table







               ;--------------- High Score Table -------------
               ; High score table where the top 5 scores are
               ; stored in BCD format.
               ; The 6th entry is only used to roll the
               ; last score into when inserting a new
               ; hi-score into the table.
               ;
               ; Original Address $0001CA18
               ;
               even
highscore_table_BCD_format                                         
               dc.l $00125000
               dc.l $00100000
               dc.l $00075000
               dc.l $00050000
               dc.l $00025000     ; highscore_table+16                              
               dc.l $00000000     ; highscore_table+20 - not displayed, used to roll last entry into when processing hi-scores



               
               even
               ; --------------- Copy Title Screen Bitplanes ----------------
               ; A0 = Source Address
copy_title_screen_bitplanes
               lea.l     TITLE_SCREEN_GFX,a0
               bra.w     copy_bitplanes_to_display
               ; uses routine rts to return to caller




               ; The size of the current bitplane to copy 
               ; to the display_buffer_address
               ; Original Address $0001ca3e
bitplane_size                                  

               dc.l $00000000                  ; The size of the current display bitplane in bytes          



               ; The address of the Display buffer for the Title Screen
               ; Original Address $0001ca42
display_buffer_address
               dc.l $00000000





                ;---------------------- reset title screen display ------------------------
                ; 
                ;
                ; 1) resets the display window to closed, set general display parameters
                ; in custom registers.
                ; Checks if cheat is enabled, and if so flips the display.
                ;
                ; Called from:
                ;
                ; IN: D0.l = bitplane size (bytes)
                ;
reset_title_screen_display                                              ; original address $0001d2de
                move.l  d0,bitplane_size                                ; $0001ca3e
                move.b  #$f4,$00dff08e                                  ; DIWSTRT - reset window to closed
                moveq   #$01,d0
                bsr.w   raster_wait_161                                 ; wait for 2 frames ; calls $0001c2f8
                move.w  #$5000,$00dff100                                ; BPLCON0 - 5 bitplane screen
                move.w  #$0040,$00dff104                                ; BPLCON2 - Playfield 2 - priority (dual playfield?)
                move.w  #$0000,$00dff102                                ; BPLCON1 - Clear scroll delay
                move.l  #DISPLAY_BITPLANE_ADDRESS,display_buffer_address   ; #$00063190,$0001ca42 [00000000]
                move.l  #$003800d0,$00dff092                            ; DDFSTRT/DDFSTOP - DMA bitplane fetch
                clr.w   $00dff108                                       ; BPL1MOD - CLR not the best on custom regs
                clr.w   $00dff10a                                       ; BPL2MOD
                move.l  #$ffffffff,$00dff044                            ; BLTAFWM/BLTALWM - blitter word masks
                move.l  #DISPLAY_BITPLANE_ADDRESS,d0                    ; #$00063190,d0
                btst.b  #PANEL_STATUS_2_INFINITE_LIVES,PANEL_STATUS_2   ; $0007c875
                beq.b   .set_bitplane_ptrs                              ; $0001d372
.cheat_enabled
                move.w  #$ffb0,$00dff108                                ; BPL1MOD = -80 (flip screen)
                move.w  #$ffb0,$00dff10a                                ; BPL2MOD = -80 (flip screen)
                move.l  bitplane_size,d1                                ; $0001ca3e,d1
                sub.l   #$00000028,d1
                add.l   d1,d0                                           ; d0 last line of title screen bitplane

.set_bitplane_ptrs
                moveq   #$04,d7                                         ; d7 = 4 + 1 (5 bitplanes) set bitplane pointers for title screen
                lea.l   copper_bplh_ptrs,a0                             ; L0001d6ee,a0 - bitplane high 16bit ptrs
                lea.l   copper_bpll_ptrs,a1                             ; L0001d702,a1 - bitplane low  16bit ptrs
.bitplane_loop
                move.w  d0,$0002(a1)
                swap.w  d0
                move.w  d0,$0002(a0)
                swap.w  d0
                addq.l  #$04,a0                                         ; increment to next bitplane ptr in copper list
                addq.l  #$04,a1                                         ; increment to next bitplane ptr in copper list
                add.l   bitplane_size,d0                                ; $0001ca3e,d0 - calc next bitplane start address
                dbf.w   d7,.bitplane_loop                               ; loop 5 times, jmp $0001d380
                rts



                ;------------------- do copy bitplane memory -----------------
                ; copies memory to the display bitplanes from $20000
                ; appears to be unused code.
                ;
do_copy_bitplane_memory
                bra.w   copy_bitplane_memory                            ; jmp $0001d3b4




                ;--------------------- copper copy -------------------
                ; copies colours into the copper for the current
                ; screen display
                ; IN: A0 = ptr to screen colours
                ;
copper_copy                                                     ; original address $0001d3a0
                lea.l   copper_colors,a1                        ; 0001d718,a1
                move.w  #$001f,d0                               ; d0 = 31 + 1 - counter
.copy_loop
                move.w  (a0)+,(a1)
                addq.l  #$04,a1                                 ; update dest ptr to next colour value
                dbf.w   d0,.copy_loop
                rts




                ;------------------- copy bitplane memory -----------------
                ; copies memory to the display bitplanes from $20000
                ; appears to be unused code.
                ;
copy_bitplane_memory                                            ; original routine address
                clr.l   DISPLAY_BITPLANE_ADDRESS                ; $00063190 - clear first 32 bits?
                lea.l   $00020000,a0                            ; a0 = $20000 - source address
                lea.l   DISPLAY_BITPLANE_ADDRESS+4,a1           ; a1 = $63194 - destination address
                movea.l a0,a2                                   ; a2 = copy dest address
                moveq   #$04,d1                                 ; d1 = counter 4 + 1 (5 bitplanes)
.bitplane_copy_loop
                move.w  #$1f40,d0                               ; d0 = bitplane size (8000)
.byte_copy_loop
                move.b  (a0)+,(a1)+                             ; copy byte by byte from source to dest
                dbf.w   d0,.byte_copy_loop
                dbf.w   d1,.bitplane_copy_loop
                rts




                ; ----------------------------- Copy Bitplanes to Display  --------------------------------
                ; copy source gfx to display bitplanes.
                ;
                ; - address $63190 = Bitplane address for display - see copper list
                ;
                ; - 28 x 3 = 84 bytes per loop iteration
                ; - 84 x 477 = 40,068 bytes
                ;  - 320 x 200 screen = 8000 bytes per bitplane 
                ;  - 8000 x5 = 40,000
                ; - over copies 68 bytes?
                ;
                ; IN: A0 = ptr to src gfx
                ;
copy_bitplanes_to_display                               ; original routine address $0001d3da
                movem.l d0/a0-a1,-(a7)
                lea.l   DISPLAY_BITPLANE_ADDRESS,a1     ; $00063190,a1
                move.w  #$01dc,d0                       ; d0 = $1cd (476) + 1
.copy_loop
                movem.l (a0)+,d1-d7                     ; copy 28 bytes src -> registers
                movem.l d1-d7,(a1)                      ; copy 28 bytes reg -> dest (a1)
                adda.l  #$0000001c,a1                   ; #$1c = 28 (28 bytes to dest ptr)
                movem.l (a0)+,d1-d7                     ; copy 28 bytes src -> registers
                movem.l d1-d7,(a1)                      ; copy 28 bytes reg -> dest
                adda.l  #$0000001c,a1                   ; #$1c = 28 (28 bytes to dest ptr) 
                movem.l (a0)+,d1-d7                     ; copy 28 bytes src > registers
                movem.l d1-d7,(a1)                      ; copy 28 bytes reg -> dest
                adda.l  #$0000001c,a1                   ; #$1c = 28 (28 bytes to dest ptr) 
                dbf.w   d0,.copy_loop                   ; copy loop (477 times x 28 bytes = 40,068)

                movem.l (a7)+,d0/a0-a1
                rts



                ; --------------------- copy gfx to display ---------------------
                ; copies 51,212 bytes from source to dest.
                ; IN: a0 = source gfx ptr
copy_gfx_to_display                                     ; original address $0001d41c
                movem.l d0/a1,-(a7)
                lea.l   DISPLAY_BITPLANE_ADDRESS,a1     ; $00063190,a1
                move.w  #$0724,d0                       ; #$724 + 1 (1829) ; 1829 * 28 = 51,212
.copy_loop
                movem.l (a0)+,d1-d7                     ; get 28 source bytes (d1-d7)
                movem.l d1-d7,(a1)                      ; set 28 dest bytes (d1-d7)
                adda.l  #$0000001c,a1                   ; increment dest ptr by #$1c (28)
                dbf.w   d0,.copy_loop                   ; loop 1829 times
                movem.l (a7)+,d0/a1
                rts 




                ;--------------------- wait blitter ---------------------------
                ; wait for blitter to finish it's current operation.
                ; busy wait loop.
wait_blitter
                btst.b  #$0006,$00dff002                 ; test BBUSY bit of DMACONR
                bne.w   wait_blitter
                rts  



               ;--------------------- do end game return to title screen ----------------
               ; A previous game has ended, so this is a return to the title screen via
               ; either the Joker Laugh screen or the Game Completion Screen.
               ;
               ; Performs game over/game completion checks to display the correct
               ; screens on return from the game back to the title screen.
               ;
               ; original routine address $0001d450
               ;
do_end_game_return_to_title_screen   
               ; initialise the stack              
               lea.l   temp_stack_top,a7  
               bsr.w   initialise_hardware_state 

               ; unnecessary code - commented out
               ; check game over status
               ;btst.b  #PANEL_STATUS_2_GAME_OVER,PANEL_STATUS_2 
               ;beq.b   .chk_gameover_completion
               ;clr.l   PANEL_HIGHSCORE      
               ;bra.w   return_to_title_screen

                ; check panel_status_2 bit to see if the game was completed
                ; or whether it's a game over.
.chk_gameover_completion 
               btst.b  #PANEL_STATUS_2_GAME_COMPLETED,PANEL_STATUS_2 

               IFD TEST_JOKER
                    beq.w   display_endgame_joker                         
               ENDC



                ;---------------------- display completion screen -----------------------
                ; displays the game completion screen, plays the batman voice (song 3)
                ; waits for ~15 seconds, returns to title screen.
display_completion_screen                                                       ; original routine address $0001d47a
                move.l  #DISPLAY_320_200_BYTES,d0                                           ; d0 = bitplane size (bytes) (8000)
                bsr.w   reset_title_screen_display                              ; calls $0001d2de
                move.w  #$4000,$00dff100                                        ; set 4 bitplane screen
                lea.l   batman_background_palette,a0                            ; L0001d4cc ; 16 colour palette address
                bsr.w   copper_copy                                             ; calls $0001d3a0
                lea.l   BATMAN_GFX,a0                                            ; a0 = source gfx
                ;lea.l   $00056460,a0                                            ; a0 = source gfx
                bsr.w   copy_bitplanes_to_display                               ; calls $0001d3da
                move.b  #$2c,copper_diwstrt                                     ; $0001d6e8 - set window open
                move.b  #$f4,copper_diwstop                                     ; $0001d6ec 
                move.w  #$0064,d0                                               ; d0 = 100
                bsr.w   raster_wait_161                                         ; wait for 100 frames (2 seconds) - calls $0001c2f8
                moveq   #SOUND_BATMAN_SPEACH,d0                                                 ; d0 = song 3
                jsr     SoundDriver_Play_Song                                               ; init play song 4 - calls $00004010
                move.w  #$0600,d0                                               ; d0 = 1536 
                bsr.w   raster_wait_161                                         ; wait for 1536 frames (15 seconds) - calls $0001c2f8
                bra.w   return_to_title_screen                                  ; jmp $0001c018






                ;---------------------- display end game joker -----------------------
                ; displays the game over screen, plays the joker laugh (song 2)
                ; waits for ~10 seconds, returns to title screen.
display_endgame_joker                                                   ; original address $0001d4f0
                move.l  #$2800,d0                                       ; d0,d4 = bitplane size (bytes)
                bsr.w   reset_title_screen_display                      ; calls $0001d2de
        IFND     TEST_TITLEPRG
                ;lea.l   $00040000,a0
                lea.l   JOKER_PALETTE,a0                                ; a0 = display palette colour table
                bsr.w   copper_copy                                     ; calls $0001d3a0
                lea.l   JOKER_GFX+$40,a0                                ; a0 = display palette colour table
        ELSE
                ;lea.l   test_bitplanes,a0                              ; a0 = display palette colour table
                lea.l   JOKER_PALETTE+4,a0                              ; a0 = display palette colour table
                bsr.w   copper_copy                                     ; calls $0001d3a0
                lea.l   JOKER_GFX+$44,a0                                ; a0 = display palette colour table
        ENDC
                bsr.w   copy_gfx_to_display                             ; calls $0001d41c
                move.b  #$2c,copper_diwstrt                             ; $0001d6e8
                move.b  #$2b,copper_diwstop                             ; $0001d6ec
                move.w  #$0014,d0
                bsr.w   raster_wait_161                                 ; calls $0001c2f8
                moveq   #SOUND_JOKER_LAUGH,d0
                jsr     SoundDriver_Play_Song                                       ; calls $00004010
                move.w  #$0200,d0                                       ; d0 = wait 512 frames (10 seconds)
                bsr.w   raster_wait_161                                 ; calls $0001c2f8
                bra.w   return_to_title_screen                          ; jmp $0001c018




                ;--------------------- wait 10 seconds ---------------------
                ; waits for 512 frames to pass.
                ; *** unused code ***
wait_10_seconds
                move.w  #$0200,d0                                       ; d0 = wait 512 frames (10 seconds)
                bsr.w   raster_wait_161                                 ; calls $0001c2f8
                bra.w   return_to_title_screen                          ; jmp $0001c018





                ;----------------------- title screen stack ------------------
                ; memory area used for the title screen stack memory.
                ; sp/a7 is set to the address 'temp_stack_top' at the end of 
                ; this block of data.
                ;
temp_stack_bottom                                                       ; original address $0001D54E
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $00C7, $8978, $00C7, $8978, $00C7, $848C   
                dc.w $00C7, $871E, $00C7, $8104, $0000, $0000, $0000, $0000   
temp_stack_top                                                          ; original address $0001D6DE




L0001D6DE dc.w $0000                            ; ***** UNUSED? *****
L0001D6E0 dc.w $0000                            ; ***** UNUSED? *****




                ; ------------------- copper list -------------------
copper_list
                dc.w $00FF
                dc.w $FF00
                dc.w DIWSTRT            ; $008E 
copper_diwstrt                                                  ; original address $0001D6E8
                dc.w $F381
                dc.w DIWSTOP            ; $0090
copper_diwstop                                                  ; original address $0001D6EC
                dc.w $F4C1
copper_bplh_ptrs
                dc.w BPL1PTH            ; $00E0
                dc.W $0006
                dc.w BPL2PTH            ; $00E4
                dc.w $0006
                dc.w BPL3PTH            ; $00E8
                dc.w $0006
                dc.w BPL4PTH            ; $00EC
                dc.w $0006
                dc.w BPL5PTH            ; $00F0
                dc.w $0006
copper_bpll_ptrs
                dc.w BPL1PTL            ; $00E2
                dc.w $3190
                dc.w BPL2PTL            ; $00E6
                dc.w $50D0
                dc.w BPL3PTL            ; $00EA
                dc.w $7010
                dc.w BPL4PTL            ; $00EE
                dc.w $8F50
                dc.w BPL5PTL            ; $00F2
                dc.w $AE90
                dc.w COLOR00
copper_colors                                                   ; original address $0001d718
                dc.w $0000
                dc.w COLOR01, $0000
                dc.w COLOR02, $0000
                dc.w COLOR03, $0000
                dc.w COLOR04, $0000
                dc.w COLOR05, $0000
                dc.w COLOR06, $0B51
                dc.w COLOR07, $0D61
                dc.w COLOR08, $0E70
                dc.w COLOR09, $0F80 
                dc.w COLOR10, $0F90
                dc.w COLOR11, $0FA0
                dc.w COLOR12, $0FB0
                dc.w COLOR13, $0FC0
                dc.w COLOR14, $0FE0
                dc.w COLOR15, $0FF0
                dc.w COLOR16, $0045
                dc.w COLOR17, $0900
                dc.w COLOR18, $0FFF
                dc.w COLOR19, $0033
                dc.w COLOR20, $0067
                dc.w COLOR21, $0222
                dc.w COLOR22, $0333
                dc.w COLOR23, $0444
                dc.w COLOR24, $0F99
                dc.w COLOR25, $0666
                dc.w COLOR26, $0706
                dc.w COLOR27, $0504
                dc.w COLOR28, $099A
                dc.w COLOR29, $0403
                dc.w COLOR30, $0302
                dc.w COLOR31, $0DDE
                dc.w $FFFF, $FFFE






          ;*************************************************************************************
          ; DISPLAY BUFFER
          ;*************************************************************************************
          IFD TEST_TITLEPRG
               even
display_buffer    
               dcb.w   40000,$f0f0                ; 3200 x 200 display buffer, 5 bitplanes, 40000 bytes

          ENDC




          ;*************************************************************************************
          ; TITLE SCREEN GRAPHICS
          ;*************************************************************************************
          ; Normally loaded into the absolute address $0003F236 by 
          ; the game loader.
          ; 
          ; if test build, then:
          ;    - include gfx normally loaded into absolute address $0003F236
          ;         - Title Screen Character Set
          ;         - Title Screen Background GFX Joker, Batman and Batman Logo
          ;         - Game Over Screen (Joker Laughing)
          ;         - Game Completion Screen (Batman)
          

               ;------------------------ title screen colours ---------------------
               ; Title Screen Colour Pallette.
               ; Table of colours copied into the copper list colour registers.
               ; Original Address $0001D79A
               ;
title_screen_palette                                                            
               dc.w $0000,$0521,$0310,$0731,$0831,$0A41,$0B51,$0D61
               dc.w $0E70,$0F80,$0F90,$0FA0,$0FB0,$0FC0,$0FE0,$0FF0
               dc.w $0045,$0900,$0FFF,$0033,$0067,$0222,$0333,$0444
               dc.w $0F99,$0666,$0706,$0504,$099A,$0403,$0302,$0DDE


                ;------------------- 16 colour palette -----------------------
                ; 16 colour palatte for the game completion screen.
                ; Displays Batman and a message to the player.
                ;
                ; Notes:
                ; The code actually copies 32 colours into the copper list
                ; and originally overran the end of the table.
                ;
                ; Original Address $0001d4cc
                ;
batman_background_palette    
               dc.w $0000,$0ec2,$0e80,$0a40,$0820,$0e60,$0ea8,$0eca 
               dc.w $0ea0,$0eee,$0222,$0444,$0666,$0888,$0AAA,$0CCC
               dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
               dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

           
joker_background_palette
               incbin    'joker_palette.raw'

joker_gfx
               incbin    'joker_gfx.raw'

batman_gfx     
               incbin    'batman.raw'

titlescreen_gfx
               incbin    'titlescreen.raw'

               ; Each character is 16 bits wide (2 bytes)
               ; The character gfx only occupies the lower byte.
               ; The characters are 8 lines high.
               ; Each character is 2x8 = 16 bytes per bitplane.
               ; Each character is 5 bitplanes, so 16 x 5 = 80 bytes per character.
               ; 45 characters in total, including the initial blank character.
character_set_gfx
               incbin    'character_set.raw'





               ;********************************************************************************
               ;  AUDIO CODE & DATA
               ;********************************************************************************
               ; Audio code and data is grouped below.
               ;


               ;*****************************************************
               ;  SOUND DRIVER LIBRARY CODE
               ;*****************************************************
               ; Notes, I've rearranged the title screen memory map
               ; to include the sound driver and music module at
               ; the end of the title screen code.
               ; Original Address $00004000
               ;
               even
               include   "sounddriver.s"


               ;*****************************************************
               ;  MUSIC MODULE DATA
               ;*****************************************************
               ; Notes: I've rearranged the title screen memory map
               ; to 'modularise' the music to make it re-rusable and
               ; relocateable in memory. This would normally follow
               ; the sound driver code in memory at the start of
               ; the title screen code in the real game.
               ;
               even
MUSIC_MODULE_DATA
               include   "music/title_music_module.i"


