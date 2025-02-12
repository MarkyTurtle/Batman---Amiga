                ; This is music and player routine for Level 1 - Axis Chemicals
                ; $00048000  Initialise Music Player    - Set up Player Samples & Instruments
                ; $00048004  Silence All Audio          - Stop Playing and Silence Audio
                ; $00048008  Stop Audio 
                ; $0004800c  Stop Audio
                ; $00048010  Init Song                  - Initialise Song to Play (D0 = song number)
                ; $00048014  Play SFX                   - Initialise & PLay SFX on 4th audio channel (if not already playing or is higher priority of one that is playing) - L0004822c
                ; $00048018  Play Song                  - Called every VBL to play music

                ;--------------------- includes and constants ---------------------------
                INCDIR      "include"
                INCLUDE     "hw.i"

;TEST_MUSIC_BUILD SET 1                 ; run a test build with imported GFX
;TEST_BUILD_LEVEL SET 1                 ; if enabling TEST_MUSIC_BUILD then also enable this

                section chem,code_c

                IFND TEST_BUILD_LEVEL
; Music Player Constants
AUDIO_PLAYER_INIT               EQU $00048000                       ; initialise music/sfx player
AUDIO_PLAYER_SILENCE            EQU $00048004                       ; Silence all audio
AUDIO_PLAYER_INIT_SFX_1         EQU $00048008                       ; Initialise SFX Audio Channnel
AUDIO_PLAYER_INIT_SFX_2         EQU $0004800c                       ; same as init_sfx_1 above
AUDIO_PLAYER_INIT_SONG          EQU $00048010                       ; initialise song to play - D0.l = song/sound 1 to 13
AUDIO_PLAYER_INIT_SFX           EQU $00048014                       ; initialise sfx to play - d0.l = sfx 5 to 13
AUDIO_PLAYER_UPDATE             EQU $00048018                       ; regular update (vblank to keep sounds/music playing)
                ENDC
                IFD TEST_BUILD_LEVEL
; Music Player Constants
AUDIO_PLAYER_INIT               EQU Init_Player                     ; initialise music/sfx player
AUDIO_PLAYER_SILENCE            EQU Stop_Playing                    ; Silence all audio
AUDIO_PLAYER_INIT_SFX_1         EQU Init_SFX_1                      ; Initialise SFX Audio Channnel
AUDIO_PLAYER_INIT_SFX_2         EQU Init_SFX_2                      ; same as init_sfx_1 above
AUDIO_PLAYER_INIT_SONG          EQU Init_Song                       ; initialise song to play - D0.l = song/sound 1 to 13
AUDIO_PLAYER_INIT_SFX           EQU Init_SFX                        ; initialise sfx to play - d0.l = sfx 5 to 13
AUDIO_PLAYER_UPDATE             EQU Play_Sounds                     ; regular update (vblank to keep sounds/music playing)
                ENDC    


;Church.iff - Level Music - Constants
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



        IFND TEST_MUSIC_BUILD
                IFND TEST_BUILD_LEVEL
                        org     $47fe4                                         ; original load address
                ENDC
        ELSE


kill_system
                lea     $dff000,a6
                move.w  #$7fff,INTENA(a6)
                move.w  #$7fff,DMACON(a6)
                move.w  #$7fff,INTREQ(a6)   
                lea     kill_system,a7                              ; initialise stack 
                bsr     init_system

                ;--------------------------------------------------------------
                ; TEST PROGRAM
                ; set song number below 'SOUND_TO_PLAY' for different songs/sfx
                ;   #$01 = Level 1 Music
                ;   #$02 = Level 1 Completed
                ;   #$03 = Player Live Lost
                ;   #$04 = Unknown/Unused Music - Level Timer Run out?
                ;   #$05 = Drip SFX
                ;   #$06 = Gas Leak
                ;   #$07 = Batrope
                ;   #$08 = Batarang
                ;   #$09 = Grenade
                ;   #$0a = Bad Guy Hit
                ;   #$0b = Splash (jack in the vat)
                ;   #$0c = Ricochet
                ;   #$0d = Explosion (grenade)
                ;--------------------------------------------------

SOUND_TO_PLAY   EQU     $01                                   ; valid range #$01 to #$0d

init_test_prg
                jsr     Init_Player                           ; init music routine/instruments

                lea     $dff000,a6
                lea     level_3_interrupt,a0
                move.l  a0,$6c.w
                move.W  #$c020,INTENA(a6)                       ; enable level 3 interrupt
                move.W  #$c020,INTENA(a6)                       ; enable level 3 interrupt

                moveq   #SOUND_TO_PLAY,d0                       ; song number to play
                jsr     Init_Song                               ; init song 1

loop
                jmp     loop     



                ;---------------- level 3 interrupt ----------------
                ; vertical blank interrupt handler.
                ; play the song at 25 frames per second.
                ;
level_3_interrupt
                movem.l d0-d7/a0-a6,-(a7)
                
                lea     $dff000,a6
                move.w  INTREQR(a6),d0
                and.w   #$0020,d0
                beq     .exit_isr

                jsr     check_change_sound

.play_music     ; play music @ 25 frames per second.
                eor.w   #$0001,frameskipper
                beq.s   .exit_isr
                jsr     Play_Sounds

.exit_isr
                ; clear level 3 interrut bits
                move.w  d0,INTREQ(a6)

                movem.l (a7)+,d0-d7/a0-a6
                rte


frameskipper:   dc.w    $0000                   ; used to only update music at 25 frames per second.
                                                ; otherwise it's too fast.


                ;--------------- check change sound ------------------
                ; check for mouse press and release, if so then
                ; increment the current sound.
                ; 
check_change_sound
                btst    #$6,$bfe001
                bne.s   .button_up
.button_down
                st.b    button_down
                bra.s   .end_button_check
.button_up
                cmp.b   #$ff,button_down
                bne.s   .end_button_check
.change_music
                sf.b    button_down
                addq.b  #$01,current_song
                cmp.b   #$0d,current_song
                ble.s   .change_song
.loop_id        
                move.b  #$01,current_song
.change_song       
                jsr     do_silence_all_audio
                moveq.l #$0,d0
                move.b  current_song,d0
                jsr     do_init_song
.end_button_check
                rts

                even
button_down     dc.b    $00
current_song    dc.b    SOUND_TO_PLAY
                even



                ; ------------------- kill system -----------------
                include "./lib/kill_system.s"

        ENDC    

L00047fe4               bra.b L00048000                         ; initialise music player.

L00047fe6               dc.w  $0001, $091a                      ; Length of file?
L00047fea               dc.w  $0000, $0000                      ; 
L00047fee               dc.w  $0000, $0000                      ; 
L00047ff2               dc.w  $0000, $0000                      ; 
L00047ff6               dc.w  $0000, $0000                      ; 
L00047ffa               dc.w  $0000, $0000                      ; 
L00047ffe               dc.w  $0000

Init_Player                                                     ; original address $00048000
L00048000               bra.w do_initialise_music_player        ; jmp $00048180
Stop_Playing                                                    ; original address $00048004
L00048004               bra.w do_silence_all_audio              ; jmp $00048194
Init_SFX_1                                                      ; original address $00048008
L00048008               bra.w do_init_sfx_channels              ; jmp $000481e8 - could also be reinit_active audio channel
Init_SFX_2                                                      ; original address $0004800c
L0004800c               bra.w do_init_sfx_channels              ; jmp $000481e8
Init_Song                                                       ; original address $00048010
L00048010               bra.w do_init_song                      ; jmp $0004824e
Init_SFX                                                        ; original address $00048014
L00048014               bra.w do_play_sfx                       ; jmp $0004822c
Play_Sounds                                                     ; original address $00048018
L00048018               bra.w do_play_sounds                      ; jmp $0004830e


master_audio_volume_mask_1                                      ; original address $0004801c
L0004801c               dc.w  $ffff
master_audio_volume_mask_2 
L0004801e               dc.w  $ffff                             ; original address $0004801e

song_ctrl_bits                                                  ; original address $00048020
L00048020               dc.w  $0000                             ; bit 15 = playing song,
                                                                ; bit 14 = playing sfx (4th channel)




 
song_no_1                                                       ; original address $00048022
L00048022               dc.b  $01
song_no_2                                                       ; original address $00048023
sfx_no
L00048023               dc.b  $01   

channel_00_status                                       ; original address $00048024
L00048024               dc.w  $0000                     ; $0000 - Channel Control Bits (active command bits)
                        dc.l  $00000000                 ; $0002 - Loop Back to previous Pattern Ptr
                        dc.l  $00000000                 ; $0006 - Next Pattern Ptr
                        dc.l  $00000000                 ; $000a - Loop Back Position Inside Current Pattern
                        dc.l  $00000000                 ; $000e - Next Pattern Data Ptr
                        dc.b  $00                       ; $0012 - Pattern Loop Count (1 = play once - default)
                        dc.b  $00                       ; $0013 - 
                        dc.l  $00000000                 ; $0014 - 
                        dc.l  $00000000                 ; $0018 - 
                        dc.w  $0000                     ; $001c - 
                        dc.w  $0000                     ; $001e - 
                        dc.b  $00                       ; $0020 - 
                        dc.b  $00                       ; $0021 - Pattern Command 10 - Parameter (byte) - ctrl clear bits (0,1,2,4,5,6,7)
                        dc.b  $00                       ; $0022 - Pattern Command 10 - Parameter (byte) - ctrl clear bits (0,1,2,4,5,6,7)
                        dc.b  $00                       ; $0023 - 
                        dc.b  $00                       ; $0024 - Pattern Command 09 - Parameter (byte) - ctrl bit 3
                        dc.b  $00                       ; $0025 - Pattern Command 09 - Parameter (byte) - ctrl bit 3
                        dc.b  $00                       ; $0026 -
                        dc.b  $00                       ; $0027 - 
                        dc.l  $00000000                 ; $0028 - ptr CMD 14
                        dc.l  $00000000                 ; $002c - ptr CMD 14 - working copy
                        dc.b  $00                       ; $0030 - 
                        dc.b  $00                       ; $0031 - 
                        dc.b  $00                       ; $0032 -
                        dc.b  $00                       ; $0033 - 
                        dc.b  $00                       ; $0034 - 
                        dc.b  $00                       ; $0035 -
                        dc.b  $00                       ; $0036 -
                        dc.b  $00                       ; $0037 -
                        dc.b  $00                       ; $0038 -
                        dc.b  $00                       ; $0039 - 
                        dc.w  $0000                     ; $003a -
                        dc.w  $0000                     ; $003c -
                        dc.l  $00000000                 ; $003e -
                        dc.w  $0000                     ; $0042 -
                        dc.l  $00000000                 ; $0044 - 
                        dc.w  $0000                     ; $0048 - 
                        dc.w  $0000                     ; $004a -
                        dc.w  $0000                     ; $004c -
                        dc.b  $00                       ; $004e -
                        dc.b  $00                       ; $004f -
                        dc.b  $00                       ; $0050 -
                        dc.b  $00                       ; $0051 - Pattern Command 05 Parameter - ctrl bit 5
                        dc.w  $0000                     ; $0052 - Pattern Command 08 Parameter - ctrl bit 7
                        dc.w  $0001                     ; $0054 - channel dma bit - channel bit? 8 (2^0)  

channel_01_status                                       ; original address $0004807a
L0004807a               dc.w  $0000                             
                        dc.l  $00000000                      
                        dc.l  $00000000                      
                        dc.l  $00000000                      
                        dc.l  $00000000                      
                        dc.b  $00
                        dc.b  $00
                        dc.l  $00000000
                        dc.l  $00000000
                        dc.w  $0000                      
                        dc.w  $0000
                        dc.b  $00
                        dc.b  $00                      
                        dc.b  $00
                        dc.b  $00
                        dc.b  $00
                        dc.b  $00                      
                        dc.b  $00
                        dc.b  $00
                        dc.l  $00000000
                        dc.l  $00000000
                        dc.b  $00
                        dc.b  $00                      
                        dc.b  $00
                        dc.b  $00
                        dc.b  $00
                        dc.b  $00                      
                        dc.b  $00
                        dc.b  $00
                        dc.b  $00
                        dc.b  $00                      
                        dc.w  $0000
                        dc.w  $0000                      
                        dc.l  $00000000                      
                        dc.w  $0000
                        dc.l  $00000000
                        dc.w  $0000                      
                        dc.w  $0000
                        dc.w  $0000                      
                        dc.b  $00
                        dc.b  $00
                        dc.b  $00
                        dc.b  $00                      
                        dc.w  $0000
                        dc.w  $0002                     ; $54 - channel dma bit - channel bit? 8 (2^1)                        

channel_02_status                                       ; original address $000480d0
L000480d0               dc.w  $0000
                        dc.l  $00000000
                        dc.l  $00000000
                        dc.l  $00000000
                        dc.l  $00000000
                        dc.b  $00
                        dc.b  $00                      
                        dc.l  $00000000                      
                        dc.l  $00000000  
                        dc.w  $0000
                        dc.w  $0000                     
                        dc.b  $00
                        dc.b  $00
                        dc.b  $00
                        dc.b  $00                      
                        dc.b  $00
                        dc.b  $00
                        dc.b  $00
                        dc.b  $00                      
                        dc.l  $00000000                      
                        dc.l  $00000000                      
                        dc.b  $00
                        dc.b  $00
                        dc.b  $00
                        dc.b  $00                      
                        dc.b  $00
                        dc.b  $00
                        dc.b  $00
                        dc.b  $00                      
                        dc.b  $00
                        dc.b  $00
                        dc.w  $0000                      
                        dc.w  $0000
                        dc.l  $00000000
                        dc.w  $0000                      
                        dc.l  $00000000                                      
                        dc.w  $0000
                        dc.w  $0000                      
                        dc.w  $0000
                        dc.b  $00
                        dc.b  $00                      
                        dc.b  $00
                        dc.b  $00
                        dc.w  $0000                      
                        dc.w  $0004                     ; $54 - channel dma bit - channel bit? 8 (2^2)  

channel_03_status                                       ; original address $00048126
L00048126               dc.w  $0000                             
                        dc.l  $00000000                      
                        dc.l  $00000000                      
                        dc.l  $00000000                      
                        dc.l  $00000000                      
                        dc.b  $00
                        dc.b  $00
                        dc.l  $00000000
                        dc.l  $00000000
                        dc.w  $0000                      
                        dc.w  $0000
                        dc.b  $00
                        dc.b  $00                      
                        dc.b  $00
                        dc.b  $00
                        dc.b  $00
                        dc.b  $00                      
                        dc.b  $00
                        dc.b  $00
                        dc.l  $00000000
                        dc.l  $00000000
                        dc.b  $00
                        dc.b  $00                      
                        dc.b  $00
                        dc.b  $00
                        dc.b  $00
                        dc.b  $00                      
                        dc.b  $00
                        dc.b  $00
                        dc.b  $00
                        dc.b  $00                      
                        dc.w  $0000
                        dc.w  $0000                      
                        dc.l  $00000000                      
                        dc.w  $0000
                        dc.l  $00000000
                        dc.w  $0000                      
                        dc.w  $0000
                        dc.w  $0000                      
                        dc.b  $00
                        dc.b  $00
                        dc.b  $00
                        dc.b  $00                      
                        dc.w  $0000
                        dc.w  $0008                     ; $54 - channel dma bit - channel bit? 8 (2^3)                     

audio_dma                                               ; original address $0004817c
L0004817c               dc.w  $0000                     ; Changes to DMACON (Active DMA Channels)
                                                        ; flag cleared on start of frame play routine
                                                        ; also it's or'ed with #$54 of channel status

play_counter                                            ; original address $0004817e
L0004817e               dc.w  $0000                     ; incremented when 'do_play_sounds' called with active sound
                                                        ; referenced as a word
                                                        ; cleared when playing new song/sound
                                                        ; incremented duting frame play routine every time 4020 is cleared
                


                        ; --------------- Initialise Music Player ----------------
                        ; No Parameters Required
do_initialise_music_player                                      ; original address $00048180
L00048180               lea.l   L00048d98,a0
                        lea.l   instrument_data,a1              ; L00048c40,a1
                        bsr.w   init_instruments                ; L00048a08
                        bra.w   do_silence_all_audio            ; L00048194



                        ;---------------------------- do silence all audio ----------------------------------
                        ; initialises all audio channels and sets song/sfx numbers to $00
                        ;
do_silence_all_audio                                            ; original address $00048194
L00048194               movem.l d0/a0-a1,-(a7)
                        move.b  #$00,song_no_1                  ; L00048022
                        move.b  #$00,sfx_no                     ; song_no_2 ; L00048023
                        lea.l   channel_00_status,a0            ; L00048024,a0 
                        lea.l   $00dff0a8,a1                    ; a1 = AUD0VOL
                        bsr.b   init_audio_channel              ; L000481ca
                        bsr.b   init_audio_channel              ; L000481ca
                        bsr.b   init_audio_channel              ; L000481ca
                        bsr.b   init_audio_channel              ; L000481ca
                        move.w  #$0000,song_ctrl_bits           ; L00048020 ; sound type bits & channel dma enable bits (all channels)
                        movem.l (a7)+,d0/a0-a1
                        rts



                        ;------------ silence channel volume -------------
                        ; Set Audio Channel Volume to Zero, also init other channel structure values
                        ; IN: A0 - channel/voice status data
                        ; IN: A1 - AUDxVOL custom register
                        ;
init_audio_channel                                              ; original address $000481ca
L000481ca               move.w  #$0000,(a0)
                        move.w  #$0001,$004a(a0)
                        move.w  #$0000,$004c(a0)
                        move.w  #$0000,(a1)                     ; AUDxVOL
                        adda.w  #$0056,a0                       ; a0 = next audio channel structure
                        adda.w  #$0010,a1                       ; a1 = next audo channel AUDxVOL h/w/ register
                        rts




                        ;----------------------------- do_init_sfx_channels -----------------------------
                        ; Reset active channels for specified sound. 
                        ; Maybe used to silence channels before playing sfx over existing sound.
                        ;
                        ; If song number (d0) is not in range 0-13 then silence audio and exit.
                        ; If song number (d0) is in range 0-13 then re-initialise the active channels only.
                        ;
                        ; IN: D0.w      - Song Number/SFX Number?
                        ;
do_init_sfx_channels                                            ; original address $000481e8
L000481e8               movem.l d0/d7/a0-a2,-(a7)
                        subq.w  #$01,d0
                        bmi.b   .unknown_song_number            ; d0 <= 0  ; jmp $000481f6
                        cmp.w   #$000d,d0                       ; 13
                        bcs.b   .reset_active_channels          ; d0 < 13  ; jmp $000481fa
.unknown_song_number
                        bsr.b   do_silence_all_audio            ; d0 >= 13 ; jmp $00048194                       
                        bra.b   .exit                           ; L00048226

                        ; reset any active audio channels in specified sound
                        ; maybe used to silence a channel when wanting to play a sfx over current sound.
                        ; d0.w index into table - L0005847e (active song channels?)
.reset_active_channels
                        lea.l   sounds_table,a2                 ; L0005847e,a2
                        asl.w   #$03,d0                         ; d0 = d0 * 8
                        adda.w  d0,a2                           ; add offset to a2
                        lea.l   channel_00_status,a0            ; L00048024,a0
                        lea.l   $00dff0a8,a1                    ; AUD0VOL
                        moveq   #$03,d7
.audio_channel_loop
                        tst.w   (a2)+
                        bne.b   .init_audio_channel             ; if channel active then - re-init active audio channel - L00048220
                        adda.w  #$0056,a0                       ; else - get next audio channel status
                        adda.w  #$0010,a1                       ;        get next audio channel volume register.
                        bra.b   .skip_init_audio_channel        ;        skip init audio channel - L00048222
.init_audio_channel
                        bsr.b   init_audio_channel              ; L000481ca ; init_audio_channel
.skip_init_audio_channel
                        dbf.w   d7,.audio_channel_loop          ; loop - L00048212 ; loop for next channel
.exit                                                           ; original address $00048226
                        movem.l (a7)+,d0/d7/a0-a2
                        rts 



                        ;--------------------------- do play sfx ------------------------
                        ; I think this is used to play a SFX sound on the 4th channel. 
                        ; Test is channel is active, 
                        ; IN:  D0.w - song number?
                        ;
do_play_sfx                                                     ; original address $0004822c
                        tst.w   channel_03_status               ; 00048126 - is channel 4 in use?
                        beq.b   .init_sfx                        ; 0004823c     - no, then initialise sfx
                        cmp.b   sfx_no,d0                       ; 00048023 - is requested sfx higher priority or already playing?
                        bcs.b   .exit                           ;              - yes, then exit L0004824c

.init_sfx                                                        ; original address $0004823c
                        movem.l d0/d7/a0-a2,-(a7)
                        move.w  #$4000,d1                       ; set sfx playing bit.
                        move.b  d0,sfx_no                       ; song_no_2 ; L00048023
                        bra.b   init_sound                      ; jmp $0004825c
.exit                                                           ; original address $0004824c
                        rts  




                        ;----------------------- do init song ------------------------
                        ; set the current song number, and initialise for playing.
                        ; if sound number is out of range then stop the audio.
                        ;
                        ; initialises each audio channel's data ptrs
                        ; sets cmd param 82/83
                        ; sets $00004020 
                        ;
                        ; IN: D0.l - sound/song to play?
                        ;               - 0 = play nothing/stop
                        ;               - >13 = play nothing/stop
                        ;
                        ; Init Commands:
                        ; $80 - Deactivate Audio Channel if unused (i.e. no data).
                        ; $81 - Set Channel Data ptr $0002(channelstatus)
                        ; $82 - Store next byte in $0013(channelstatus)
                        ; $83 - store next byte in $0012(channelstatus) 
                        ; $0x - +ve command, init channel data and skip to next channel
                        ;       - Set Channel Data ptr $0006(channelstatus)
                        ;       - value is index into song_channel_database
                        ;       - added to current ptr address as offset to pattern data?
                        ;       - address stored in $000e(channelstatus)
do_init_song                                                    ; original address $0004824e
L0004824e               movem.l d0/d7/a0-a2,-(a7)
                        move.w  #$8000,d1                       ; set song playing bit.
                        move.b  d0,song_no_1                    ; L00048022


                        ; if sfx, then enters here (d0 = sound number)
init_sound                                                      ; original address $0004825c
                        clr.w   play_counter                    ; L0004817e ; timer/counter
.validate_sound_no                                              ; original address $00048262
                        subq.w  #$01,d0                         ; is d0 < 0
                        bmi.b   .validation_failed              ;       yes - validation failed - L0004826c
                        cmp.w   #$000d,d0                       ; is d0 > 13
                        bcs.b   .validation_ok                  ;       no - validation is ok - L00048274
.validation_failed                                              ; original address $0004826c
                        bsr.w   do_silence_all_audio            ; bsr $00048194
                        bra.w   .exit                           ; exit after failure - L00048308

.validation_ok          ; init song/sound                       ; original address $00048274
                        lea.l   sounds_table,a0                 ; L0005847e,a0
                        asl.w   #$03,d0
                        adda.w  d0,a0                           ; a0 = sounds table entry to initialise
                        lea.l   channel_00_status,a1            ; L00048024,a1
                        moveq   #$03,d7                         ; loop counter 3 + 1 (number of channels to init)
.audio_channel_loop
                        move.w  (a0)+,d0                        ; get channel init data byte offset
                        beq.b   .init_next_channel              ; if = $0000 then init next channel - L000482fa
                        lea.l   -2(a0,d0.W),a2                  ; a2 = address of channel init data stream - $fe(a0,d0.W),a2
                        moveq   #$00,d0
                        move.w  d0,$004c(a1)                    ; Volume?
                        move.l  d0,$0002(a1)                    ; Music Data/Pattern ptr
                        move.l  d0,$000a(a1)                    ; Music Data/Pattern ptr
                        move.b  d0,$0013(a1)                    ; Unknown
                        move.b  #$01,$0012(a1)                  ; Unknown
                        move.w  d1,(a1)                         ; Channel ctrl bits

.command_loop           ; get and process init commands         ; original address $000482a8
                        move.b  (a2)+,d0
                        bpl.b   .init_channel_data_and_exit     ; L000482de

.chk_cmd_80             ; is it command 80?                     ; original address $000482ac
                        sub.b   #$80,d0
                        bne.b   .chk_cmd_81                     ; L000482c0

.do_cmd_80              ; is 80 - disable channel if no channel data    ; original address $000482b2
                        movea.l $0002(a1),a2
                        cmpa.w  #$0000,a2
                        bne.b   .command_loop                   ; L000482a8 - loop - next command
                        clr.w   (a1)                            ; disable channel, clear control bits
                        bra.b   .init_next_channel              ; L000482fa - do next channel

.chk_cmd_81             ; is it command 81?                     ; original address $000482c0
                        subq.b  #$01,d0
                        bne.b   .chk_cmd_82                     ; L000482ca

.do_cmd_81              ; is 81 - loop sequence pattern address ptr      ; original address $000482c4
                        move.l  a2,$0002(a1) 
                        bra.b   .command_loop                   ; L000482a8

.chk_cmd_82             ; is it command 82?                     ; original address $000482ca
                        subq.b  #$01,d0
                        bne.b   .chk_cmd_83                     ; L000482d4

.is_cmd_82              ; is 82 - store next byte in $0013(channelstatus)      ; original address $000482ce
                        move.b  (a2)+,$0013(a1)
                        bra.b   .command_loop                   ; L000482a8

.chk_cmd_83             ; is it command 83?                     ; original address $000482d4
                        subq.b  #$01,d0
                        bne.b   .command_loop                   ; L000482a8

.is_cmd_83              ; is 83 - pattern loop count byte in $0012(channelstatus) ; original address $000482d8
                        move.b  (a2)+,$0012(a1)
                        bra.b   .command_loop                   ; L000482a8

                        ; is MSB=0 - store ptr & set pattern data
.init_channel_data_and_exit                                     ; original address $000482de
                        move.l  a2,$0006(a1)                    ; next pattern ptr
                        lea.l   sound_pattern_data_base,a2      ; L000584e6,a2
                        ext.w   d0
                        add.w   d0,d0
                        adda.w  d0,a2
                        adda.w  (a2),a2
                        move.l  a2,$000e(a1)                    ; pattern data ptr
                        move.w  #$0001,$0052(a1)

.init_next_channel                                              ; original address $000482fa
                        lea.l   $0056(a1),a1                    ; next channel struct (86 bytes)
                        dbf.w   d7,.audio_channel_loop          ; init next audio channel - L00048286
                        or.w    d1,song_ctrl_bits               ; L00048020 ; update sound type bits & channel enable bits (all channels)

.exit                                                           ; original address $00048308
                        movem.l (a7)+,d0/d7/a0-a2
                        rts 




                ;--------------------------- do play sounds -----------------------
                ; Call this routine at regular intervals to play the current
                ; song/sfx combination. (e.g. during vbl)
                ; The game calls this at 25 frames per second to play current 
                ; songs/sfx
                ;
                ; IN:- no parameters
                ;
do_play_sounds                                                ; original address $0004830e
L0004830e               lea.l   $00dff000,a6                    ; customer chip base register.
                        lea.l   note_period_table+48,a5         ; L00048c00 ; mid point of the note period table
                        clr.w   audio_dma                       ; L0004817c
                        tst.w   song_ctrl_bits                  ; L00048020 ; sound type bits & channel enable bits (all channels)
                        beq.b   .set_hw_registers               ; L00048384 ; no active sound channels then branch

                        addq.w  #$01,play_counter               ; L0004817e ; increment play ticker counter
                        clr.w   song_ctrl_bits                  ; L00048020 ; sound type bits & channel enable bits (all channels)

.do_channel_0_cmds                                              ; original address $00048334
                        lea.l   channel_00_status,a4            ; L00048024,a4
                        move.w  (a4),d7                         ; d7 = channel ctrl bits
                        beq.b   .do_channel_1_cmds              ; L00048348
                        bsr.b   channel_command_loop            ; L00048392
                        move.w  d7,(a4)                         ; update channel ctrl bits
                        or.w    d7,song_ctrl_bits               ; L00048020 ; update sound type bits & channel enable bits (all channels)

.do_channel_1_cmds                                              ; original address $00048348
                        lea.l   channel_01_status,a4            ; L0004807a,a4
                        move.w  (a4),d7                         ; d7 = channel ctrl bits
                        beq.b   .do_channel_2_cmds              ; L0004835c
                        bsr.b   channel_command_loop            ; L00048392
                        move.w  d7,(a4)                         ; update channel ctrl bits
                        or.w    d7,song_ctrl_bits               ; L00048020 ; update sound type bits & channel enable bits (all channels)

.do_channel_2_cmds                                              ; original address $0004835c
                        lea.l   channel_02_status,a4            ; L000480d0,a4
                        move.w  (a4),d7                         ; d7 = channel ctrl bits
                        beq.b   .do_channel_3_cmds              ; L00048370
                        bsr.b   channel_command_loop            ; L00048392
                        move.w  d7,(a4)                         ; update ctrl bits
                        or.w    d7,song_ctrl_bits               ; L00048020 ; update sound type bits & channel enable bits (all channels)

.do_channel_3_cmds                                              ; original address $00048370
                        lea.l   channel_03_status,a4            ; L00048126,a4
                        move.w  (a4),d7                         ; d7 = channel ctrl bits
                        beq.b   .set_hw_registers               ; L00048384
                        bsr.b   channel_command_loop            ; L00048392
                        move.w  d7,(a4)                         ; update ctrl bits
                        or.w    d7,song_ctrl_bits               ; L00048020 ; update sound type bits & channel enable bits (all channels)

.set_hw_registers                                               ; original address $00048384
                        and.w   #$c000,song_ctrl_bits           ; L00048020 ; clear chanel enable bits, preserve sound/sfx type
                        bsr.w   update_audio_custom_registers   ; L0004887e ; set audio h/w registers.
                        rts 




                ; ------------------ channel command loop --------------------------
                ; Process channel audio commands for the current channel/sound/sfx
                ;
                ; IN:  a4 = channel status base address
                ; IN:  d7 = channel status CTRL word
                ; OUT: d7 = channel status CTRL word
                ;
channel_command_loop                                            ; original address $00048392
L00048392               subq.w  #$01,$0052(a4)
                        bne.w   L000486de

.get_pattern_data
                        movea.l $000e(a4),a3                    ; a3 = current pattern data ptr
                        bclr.l  #$0007,d7

channel_cmd_loop        ; Music Command Loop                    ; original address $000483a2
                        move.b  (a3)+,d0                        ; d0 = next pattern command
                        bpl.w   process_sound_commands          ; L0004858a - exit & process sound commands
                        bclr.l  #$0003,d7
.validate_cmd                                                   ; original address $000483ac
                        cmp.b   #$a0,d0                         ; max $20 (32) commands
                        bcc.b   channel_cmd_loop                ; is cmd < $a0 then do next command - jmp $000483a2
.valitation_ok                                                  ; original address L000483b2
                        lea.l   cmd_jump_table(pc),a0          
                        sub.b   #$80,d0                         ; d0 = jmp table index - subtract base value from command value
                        ext.w   d0                              ; d0 = word index into jump table
                        add.w   d0,d0                           ; d0 = address offset index into jump table
                        adda.w  d0,a0                           ; d0 = jump table entry address
                        move.w  (a0),d0                         ; d0 = offset to start of command routine
                        beq.b   channel_cmd_loop                ; if d0 = $0000 then NOP, do next command - jmp $000483a2
                        jmp     $00(a0,d0.W)                    ; jmp to command initialise routine.
                        ; some commands exit (rts)
                        ; others, jmp back to 'cmd_loop'


; jump table offsets from L000483c8 (32 music commands)
cmd_jump_table                                                          ; original address $000483c8
L000483c8               dc.w    music_command_01-(cmd_jump_table+0)     ; $000483c8 + $0040 = $00048408 - CMD 01
L000483ca               dc.w    music_command_02-(cmd_jump_table+2)     ; $000483ca + $00ba = $00048484 - CMD 02      
L000483cc               dc.w    music_command_03-(cmd_jump_table+4)     ; $000483cc + $00c0 = $0004848c - CMD 03              
L000483ce               dc.w    music_command_04-(cmd_jump_table+6)     ; $000483ce + $00c2 = $00048490 - CMD 04      
L000483d0               dc.w    music_command_05-(cmd_jump_table+8)     ; $000483d0 + $00c4 = $00048494 - CMD 05
L000483d2               dc.w    music_command_06-(cmd_jump_table+10)    ; $000483d2 + $00ce = $000484a0 - CMD 06     
L000483d4               dc.w    music_command_07-(cmd_jump_table+12)    ; $000483d4 + $00d4 = $000484a8 - CMD 07                      
L000483d6               dc.w    music_command_08-(cmd_jump_table+14)    ; $000483d6 + $00dc = $000484b2 - CMD 08
L000483d8               dc.w    music_command_09-(cmd_jump_table+16)    ; $000483d8 + $00ea = $000484c2 - CMD 09            
L000483da               dc.w    music_command_10-(cmd_jump_table+18)    ; $000483da + $00f8 = $000484d2 - CMD 10
L000483dc               dc.w    music_command_11-(cmd_jump_table+20)    ; $000483dc + $010a = $000484e6 - CMD 11
L000483de               dc.w    music_command_12-(cmd_jump_table+22)    ; $000483de + $0140 = $0004851e - CMD 12
L000483e0               dc.w    music_command_13-(cmd_jump_table+24)    ; $000483e0 + $0156 = $00048536 - CMD 13
L000483e2               dc.w    music_command_14-(cmd_jump_table+26)    ; $000483e2 + $010c = $000484ee - CMD 14
L000483e4               dc.w    music_command_15-(cmd_jump_table+28)    ; $000483e4 + $0132 = $00048516 - CMD 15
L000483e6               dc.w    music_command_16-(cmd_jump_table+30)    ; $000483e6 + $0158 = $0004853e - CMD 16
L000483e8               dc.w    music_command_17-(cmd_jump_table+32)    ; $000483e8 + $016e = $00048556 - CMD 17
L000483ea               dc.w    $0000                   
L000483ec               dc.w    $0000
L000483ee               dc.w    $0000                   
L000483f0               dc.w    $0000
L000483f2               dc.w    $0000                   
L000483f4               dc.w    $0000
L000483f6               dc.w    $0000                   
L000483f8               dc.w    $0000
L000483fa               dc.w    $0000                   
L000483fc               dc.w    $0000
L000483fe               dc.w    $0000                   
L00048400               dc.w    $0000
L00048402               dc.w    $0000                   
L00048404               dc.w    $0000
L00048406               dc.w    $0000                   


;
; L00048408 - CMD 01 - ($80) 
;       - Next Pattern/Loop current pattern/Loop back to start pattern or finish playing
;       - no loop if $0002(a4) not set.
music_command_01                                                ; original address $00048408
L00048408               movea.l $000a(a4),a3                    ; a3 = CMD2 saved pattern table ptr
                        cmpa.w  #$0000,a3                       ; check a3 is set
                        bne.b   channel_cmd_loop                ; if CMD2 pattern ptr != $0000 then exit, do next command - L00483a2
.do_cmd_01                                                      ; original address $00048412
                        movea.l $0006(a4),a3                    ; a3 = next pattern ptr
                        move.b  -$0001(a3),d0                   ; current pattern offset

                        subq.b  #$01,$0012(a4)                  ; decrement pattern loop counter - $0012(a4)
                        bne.b   .set_next_pattern_ptr           ; reset start of current pattern - $0004846e

                        move.b  #$01,$0012(a4)                  ; reset pattern loop counter (play once = 1) $0012(14) counter
                        move.b  #$00,$0013(a4)                  ; 

.cmd_loop               ; another command loop                  ; original address $0004842c
                        move.b  (a3)+,d0                        ; d0 = next pattern command/pattern offset
                        bpl.b   .set_next_pattern_ptr           ; L0004846e
.chk_80                                                         ; original address $00048430
                        sub.b   #$80,d0
                        bne.b   .chk_81                         ; L00048450
.is_80                  ; cmd 80                                ; original address $00048436
                        movea.l $0002(a4),a3                    ; a3 = back to start of pattern data ptr
                        cmpa.w  #$0000,a3                       ; is loop ptr set?
                        bne.b   .cmd_loop                       ;       yes, process next command - $0004842c 
                        ; disable channel & exit
                        move.w  #$0001,$004a(a4)                ;       no, disable audio channel
                        move.w  #$0000,$004c(a4)                ; volume = 0
                        moveq   #$00,d7                         ; channel ctrl bits = disabled
                        rts 
.chk_81                                                         ; original address
                        subq.b  #$01,d0
                        bne.b   .chk_82                         ; L0004845a
.is_81                  move.l  a3,$0002(a4)                    ; store pattern loop ptr
                        bra.b   .cmd_loop                       ; loop, process next command - L0004842c
.chk_82                                                         ; original address $0004845a
                        subq.b  #$01,d0
                        bne.b   .chk_83                         ; L00048464
.is_83                                                          ; original address $0004845e
                        move.b  (a3)+,$0013(a4)                 ; set $0013(a4) next pattern byte
                        bra.b   .cmd_loop                       ; loop, process next command - $0004842c
.chk_83
                        subq.b  #$01,d0
                        bne.b   .cmd_loop                       ; loop, process next command - $0004842c
                        move.b  (a3)+,$0012(a4)                 ; store pattern loop counter
                        bra.b   .cmd_loop                       ; loop, process next command - $0004842c

.set_next_pattern_ptr                                           ; original address $0004846e
                        move.l  a3,$0006(a4)
                        lea.l   sound_pattern_data_base,a3      ; pattern indirection table address
                        ext.w   d0                              ; d0 = byte extended to word  
                        add.w   d0,d0                           ; d0 = table address index
                        adda.w  d0,a3                           ; a3 = table entry ptr
                        adda.w  (a3),a3                         ; a3 = next pattern data address ptr
                        bra.w   channel_cmd_loop                        ; do next command - jmp $000483a2





;
; L00048484 - CMD 02 - ($81)
;       - store current pattern position ptr (loop back within current pattern)
music_command_02                                        ; original address $00048484
L00048484               move.l  a3,$000a(a4)
                        bra.w   channel_cmd_loop                ; do next command - jmp $000483a2






;
; L0004848c - CMD 03 - ($82)
;       - no operation
music_command_03                                        ; original address $0004848c
L0004848c               bra.w   channel_cmd_loop                ; do next command - jmp $000483a2


;
; L00048490 - CMD 04 - ($83)
;       - no operation
music_command_04                                        ; original address $00048490
L00048490               bra.w   channel_cmd_loop                ; do next command - jmp $000483a2






;
; L00048494 - CMD 05 - ($84)
;               - Set CRTL bit 5 
;               - Set Param byte $0051(s)
music_command_05                                        ; original address $00048494
L00048494               bset.l  #$0005,d7
                        move.b  (a3)+,$0051(a4)
                        bra.w   channel_cmd_loop                ; do next command - jmp $000483a2


;
; L000484a0 - CMD 06 - ($85)
;               - End/Cancel Command 05
music_command_06                                        ; original address $000484a0
L000484a0               bclr.l  #$0005,d7
                        bra.w   channel_cmd_loop                ; do next command - jmp $000483a2





;
; L000484a8 - CMD 07 - ($86)
;               - increase $0052(s) by $0100 (256)
music_command_07                                        ; original address $000484a8
L000484a8               add.w   #$0100,$0052(a4)
L000484ae               bra.w   channel_cmd_loop                ; do next command - jmp $000483a2




;
; L000484b2 - CMD 08 - $(87)
;               - clear bit 4 - channel ctrl
;               - set bit 7 - channel ctrl
;               - clear $004c(s)
;               - add $0052(s) with CMD 05 value (if active $0051(s)) or add next pattern byte 
;
music_command_08                                        ; original address $000484b2
L000484b2               bclr.l  #$0004,d7               ; clear bit 4 - channel ctrl
                        bset.l  #$0007,d7               ; set bit 7 - channel ctrl
                        clr.w   $004c(a4)       
                        bra.w   L000486c8




;
; L000484c2 - CMD 09 - ($88)
;               - set bit 3 - channel ctrl
;               - set command parameters from pattern data bytes
;
music_command_09                                        ; original address $000484c2
L000484c2               bset.l  #$0003,d7               ; set bit 3 - channel ctrl
                        move.b  (a3)+,$0024(a4)
                        move.b  (a3)+,$0025(a4)
                        bra.w   channel_cmd_loop                ; do next command - jmp $000483a2



;
; L000484d2 - CMD 10 - ($89)
;               - clear bits 0 - 2 (cmd 14)
;               - clear bits 4 -7 (cmd 5,8)
;               - preserve other bits (cmd 9)
;               - set parameter bytes
music_command_10                                        ; original address $000484d2
L000484d2               and.w   #$fff8,d7
                        bset.l  #$0000,d7
                        move.b  (a3)+,$0021(a4)
                        move.b  (a3)+,$0022(a4)
                        bra.w   channel_cmd_loop                ; do next command - jmp $000483a2



;
; L000484e6 - CMD 11 - ($8a)
;               - clear ctrl bit 0
music_command_11                                        ; original address $000484e6
L000484e6               bclr.l  #$0000,d7
                        bra.w   channel_cmd_loop                ; do next command - jmp $000483a2




; L000484ee - CMD 14 - ($8d)
;               - set bit 1
;               - clear bits 1 - 2
;               - clear bits 4 - 7
;               - preserve bit 3 (CMD 9)
music_command_14                                        ; original address $000484ee
L000484ee               and.w   #$fff8,d7
L000484f2               bset.l  #$0001,d7
L000484f6               lea.l   command_14_data,a0      ; $00058378,a0
L000484fc               moveq   #$00,d0
L000484fe               move.b  (a3)+,d0                ; d0 = next pattern byte
L00048500               add.w   d0,d0                   ; d0 = index into table
L00048502               adda.w  d0,a0                   ; a0 = table entry address
L00048504               adda.w  (a0),a0                 ; a0 = indirection address ptr
L00048506               move.b  (a0)+,$0032(a4)
L0004850a               move.b  (a0)+,$0030(a4)
L0004850e               move.l  a0,$0028(a4)
L00048512               bra.w   channel_cmd_loop                ; do next command - jmp $000483a2

; L00048516 - CMD 15
music_command_15                                        ; original address $00048516
L00048516               bclr.l  #$0001,d7
L0004851a               bra.w   channel_cmd_loop                ; do next command - jmp $000483a2





; L0004851e - CMD 12
music_command_12                                        ; original address $0004851e
L0004851e               and.w   #$fff8,d7
L00048522               bset.l  #$0002,d7
L00048526               move.b  (a3)+,$0036(a4)
L0004852a               move.b  (a3)+,$0034(a4)
L0004852e               move.b  (a3)+,$0035(a4)
L00048532               bra.w   channel_cmd_loop                ; do next command - jmp $000483a2

; L00048536 - CMD 13
music_command_13
L00048536               bclr.l  #$0002,d7
L0004853a               bra.w   channel_cmd_loop                ; do next command - jmp $000483a2

; L0004853e - CMD 16
music_command_16                                        ; original address $0004853e
L0004853e               lea.l   command_16_data,a0      ; L0005842a,a0
L00048544               moveq   #$00,d0
L00048546               move.b  (a3)+,d0
L00048548               add.w   d0,d0
L0004854a               adda.w  d0,a0
L0004854c               adda.w  (a0),a0
L0004854e               move.l  a0,$0014(a4)
L00048552               bra.w   channel_cmd_loop                ; do next command - jmp $000483a2

; L00048556 - CMD 17
music_command_17                                        ; original address $00048556
L00048556               lea.l   command_17_data,a0      ; L00048c30,a0
L0004855c               moveq   #$00,d0
L0004855e               move.b  (a3)+,d0
L00048560               asl.w   #$04,d0
L00048562               adda.w  d0,a0
L00048564               move.w  (a0)+,$003c(a4)
L00048568               move.l  (a0)+,$003e(a4)
L0004856c               move.w  (a0)+,$0042(a4)
L00048570               move.l  (a0)+,$0044(a4)
L00048574               move.w  (a0)+,$0048(a4)
L00048578               bclr.l  #$0006,d7
L0004857c               tst.w   (a0)
L0004857e               beq.w   channel_cmd_loop                ; do next command - jmp $000483a2
L00048582               bset.l  #$0006,d7
L00048586               bra.w   channel_cmd_loop                ; do next command - jmp $000483a2


                ; +ve pattern command data (end of pattern command loop)
                ; IN: A4 = Sound Channel Structure
                ; IN: A3 = Next Pattern Command Ptr
                ; IN: D0 = command data
                ; IN: D7 = Channel Ctrl Bits
process_sound_commands                                  ; original address $0004858a         
L0004858a       btst.l  #$0006,d7
L0004858e       bne.b   L00048594
L00048590       add.b   $0013(a4),d0
L00048594       move.b  d0,$004f(a4)
L00048598       btst.l  #$0000,d7
L0004859c       beq.b   L000485a8
L0004859e       add.b   $0021(a4),d0
L000485a2       move.b  $0022(a4),$0023(a4)
L000485a8       move.b  d0,$0050(a4)
L000485ac       ext.w   d0
L000485ae       sub.w   $003c(a4),d0
L000485b2       add.w   d0,d0
L000485b4       cmp.w   #$ffd0,d0
L000485b8       blt.b   L000485c0
L000485ba       cmp.w   #$002c,d0
L000485be       ble.b   L000485d6

L000485c0       move.b  $004f(a4),d1
L000485c4       move.b  $0050(a4),d2
L000485c8       move.w  $003c(a4),d3
L000485cc       move.w  $0054(a4),d4
L000485d0       movea.l $0006(a4),a2
L000485d4       illegal

L000485d6       move.w  $00(a5,d0.W),$004a(a4)
L000485dc       btst.l  #$0002,d7
L000485e0       beq.b   L0004863c
L000485e2       move.b  $0050(a4),d0
L000485e6       add.b   $0034(a4),d0
L000485ea       ext.w   d0
L000485ec       sub.w   $003c(a4),d0
L000485f0       add.w   d0,d0
L000485f2       cmp.w   #$ffd0,d0
L000485f6       blt.b   L000485fe
L000485f8       cmp.w   #$002c,d0
L000485fc       ble.b   L00048614

L000485fe       move.b  $004f(a4),d1
L00048602       move.b  $0050(a4),d2
L00048606       move.w  $003c(a4),d3
L0004860a       move.w  $0054(a4),d4
L0004860e       movea.l $0006(a4),a2
L00048612       illegal

L00048614       move.w  $00(a5,d0.W),d0
L00048618       sub.w   $004a(a4),d0
L0004861c       asr.w   #$01,d0
L0004861e       ext.l   d0
L00048620       move.b  $0035(a4),d1
L00048624       ext.w   d1
L00048626       divs.w  d1,d0
L00048628       move.w  d0,$003a(a4)
L0004862c       move.b  d1,$0039(a4)

L00048630       add.b   d1,d1
L00048632       move.b  d1,$0038(a4)
L00048636       move.b  $0036(a4),$0037(a4)
L0004863c       btst.l  #$0003,d7
L00048640       beq.b   L00048692
L00048642       move.b  $0050(a4),d0
L00048646       add.b   $0024(a4),d0
L0004864a       ext.w   d0
L0004864c       sub.w   $003c(a4),d0
L00048650       add.w   d0,d0
L00048652       cmp.w   #$ffd0,d0
L00048656       blt.b   L0004865e
L00048658       cmp.w   #$002c,d0
L0004865c       ble.b   L00048674

L0004865e       move.b  $004f(a4),d1
L00048662       move.b  $0050(a4),d2
L00048666       move.w  $003c(a4),d3
L0004866a       move.w  $0054(a4),d4
L0004866e       movea.l $0006(a4),a2
L00048672       illegal

L00048674       move.w  $00(a5,d0.W),d0
L00048678       sub.w   $004a(a4),d0
L0004867c       ext.l   d0
L0004867e       moveq   #$00,d1
L00048680       move.b  $0025(a4),d1
L00048684       divs.w  d1,d0
L00048686       move.w  d0,$0026(a4)
L0004868a       neg.w   d0
L0004868c       muls.w  d1,d0
L0004868e       sub.w   d0,$004a(a4)
L00048692       btst.l  #$0001,d7
L00048696       beq.b   L000486aa
L00048698       move.b  #$01,$0033(a4)
L0004869e       move.l  $0028(a4),$002c(a4)
L000486a4       move.b  $0030(a4),$0031(a4)
L000486aa       bset.l  #$0004,d7
L000486ae       move.l  $0014(a4),$0018(a4)
L000486b4       move.w  #$0001,$001e(a4)
L000486ba       clr.w   $004c(a4)
L000486be       move.w  $0054(a4),d0
L000486c2       or.w    d0,audio_dma                    ; L0004817c

; jmp destination from 'pattern command 08 ($87)'
L000486c8       moveq   #$00,d0
L000486ca       move.b  $0051(a4),d0                    ; Cmd 05 byte parameter
L000486ce       btst.l  #$0005,d7                       ; is CMD 05 is active?
L000486d2       bne.b   L000486d6                       ;       yes, use CMD 05 param value
L000486d4       move.b  (a3)+,d0                        ;       no, use next pattern param value
L000486d6       add.w   d0,$0052(a4)                    ; update $0052(s)
L000486da       move.l  a3,$000e(a4)                    ; store pattern position ptr. 


; jmp destination from 'process_command_loop' when $0052(s) is not $0000
L000486de       btst.l  #$0007,d7                       ; Is Command 8 Active?
L000486e2       bne.w   exit_process_sound_commands     ; L0004887c - yes, don't do the following and exit


L000486e6       move.w  $004a(a4),d0
L000486ea       btst.l  #$0003,d7
L000486ee       beq.b   L00048702
L000486f0       subq.b  #$01,$0025(a4)
L000486f4       bne.b   L000486fa
L000486f6       bclr.l  #$0003,d7
L000486fa       sub.w   $0026(a4),d0
L000486fe       bra.w   L000487d4
L00048702       btst.l  #$0000,d7
L00048706       beq.b   L0004874e
L00048708       subq.b  #$01,$0023(a4)
L0004870c       bcc.w   L000487d4
L00048710       move.b  $004f(a4),d0
L00048714       move.b  $0050(a4),d1
L00048718       move.b  d0,$0050(a4)
L0004871c       ext.w   d0
L0004871e       sub.w   $003c(a4),d0
L00048722       add.w   d0,d0
L00048724       cmp.w   #$ffd0,d0
L00048728       blt.b   L00048730
L0004872a       cmp.w   #$002c,d0
L0004872e       ble.b   L00048746

L00048730       move.b  $004f(a4),d1
L00048734       move.b  $0050(a4),d2
L00048738       move.w  $003c(a4),d3
L0004873c       move.w  $0054(a4),d4
L00048740       movea.l $0006(a4),a2
L00048744       illegal

L00048746       move.w  $00(a5,d0.W),d0
L0004874a       bra.w   L000487d4
L0004874e       btst.l  #$0001,d7
L00048752       beq.b   L000487b0
L00048754       subq.b  #$01,$0033(a4)
L00048758       bne.b   L000487d4
L0004875a       movea.l $002c(a4),a0
L0004875e       move.b  (a0)+,d0
L00048760       subq.b  #$01,$0031(a4)
L00048764       bne.b   L00048770
L00048766       movea.l $0028(a4),a0
L0004876a       move.b  $0030(a4),$0031(a4)
L00048770       move.l  a0,$002c(a4)
L00048774       move.b  $0032(a4),$0033(a4)
L0004877a       add.b   $0050(a4),d0
L0004877e       ext.w   d0
L00048780       sub.w   $003c(a4),d0
L00048784       add.w   d0,d0
L00048786       cmp.w   #$ffd0,d0
L0004878a       blt.b   L00048792
L0004878c       cmp.w   #$002c,d0
L00048790       ble.b   L000487a8

L00048792       move.b  $004f(a4),d1
L00048796       move.b  $0050(a4),d2
L0004879a       move.w  $003c(a4),d3
L0004879e       move.w  $0054(a4),d4
L000487a2       movea.l $0006(a4),a2
L000487a6       illegal

L000487a8       move.w  $00(a5,d0.W),d0
L000487ac       bra.w   L000487d4
L000487b0       btst.l  #$0002,d7
L000487b4       beq.b   L000487d4
L000487b6       subq.b  #$01,$0037(a4)
L000487ba       bcc.b   L000487d4
L000487bc       addq.b  #$01,$0037(a4)
L000487c0       subq.b  #$01,$0039(a4)
L000487c4       bne.b   L000487d0
L000487c6       neg.w   $003a(a4)
L000487ca       move.b  $0038(a4),$0039(a4)
L000487d0       add.w   $003a(a4),d0
L000487d4       move.w  d0,$004a(a4)
L000487d8       btst.l  #$0004,d7
L000487dc       beq.w   exit_process_sound_commands     ; L0004887c
L000487e0       subq.w  #$01,$001e(a4)
L000487e4       bne.w   L00048866
L000487e8       movea.l $0018(a4),a0
L000487ec       moveq   #$00,d0
L000487ee       move.b  (a0)+,d0
L000487f0       beq.b   L00048834
L000487f2       bmi.b   L0004880e
L000487f4       move.w  d0,$001e(a4)
L000487f8       move.b  #$01,$001c(a4)
L000487fe       move.b  #$01,$001d(a4)
L00048804       move.b  (a0)+,$0020(a4)
L00048808       move.l  a0,$0018(a4)
L0004880c       bra.b   L00048866
L0004880e       neg.b   d0
L00048810       move.w  d0,$001e(a4)
L00048814       move.b  #$01,$0020(a4)
L0004881a       move.b  (a0)+,d0
L0004881c       bpl.b   L00048824
L0004881e       neg.b   d0
L00048820       neg.b   $0020(a4)
L00048824       move.b  d0,$001c(a4)
L00048828       move.b  #$01,$001d(a4)
L0004882e       move.l  a0,$0018(a4)
L00048832       bra.b   L00048866
L00048834       move.b  (a0),d0
L00048836       beq.b   L00048842
L00048838       bpl.b   L0004883c
L0004883a       neg.b   d0
L0004883c       sub.w   $0052(a4),d0
L00048840       bmi.b   L00048848
L00048842       bclr.l  #$0004,d7
L00048846       bra.b   exit_process_sound_commands     ; L0004887c

L00048848       neg.w   d0
L0004884a       move.w  d0,$001e(a4)
L0004884e       move.b  #$00,$001c(a4)
L00048854       move.b  #$00,$001d(a4)
L0004885a       move.b  #$00,$0020(a4)
L00048860       move.l  a0,$0018(a4)
L00048864       bra.b   exit_process_sound_commands     ; L0004887c

L00048866       subq.b  #$01,$001d(a4)
L0004886a       bne.b   exit_process_sound_commands     ; L0004887c

L0004886c       move.b  $001c(a4),$001d(a4)
L00048872       move.b  $0020(a4),d0
L00048876       ext.w   d0
L00048878       add.w   d0,$004c(a4)

exit_process_sound_commands                             ; original address $0004887c
L0004887c       rts 




update_audio_custom_registers
L0004887e       move.w  audio_dma,d0                    ;L0004817c,d0
L00048884       beq.b   L000488f4
L00048886       move.w  d0,$0096(a6)
L0004888a       move.w  d0,d1
L0004888c       lsl.w   #$07,d1
L0004888e       move.w  d1,$009c(a6)
L00048892       moveq   #$00,d2
L00048894       moveq   #$01,d3
L00048896       btst.l  #$0000,d0
L0004889a       beq.b   L000488a4
L0004889c       move.w  d3,$00a6(a6)
L000488a0       move.w  d2,$00aa(a6)
L000488a4       btst.l  #$0001,d0
L000488a8       beq.b   L000488b2
L000488aa       move.w  d3,$00b6(a6)
L000488ae       move.w  d2,$00ba(a6)
L000488b2       btst.l  #$0002,d0
L000488b6       beq.b   L000488c0
L000488b8       move.w  d3,$00c6(a6)
L000488bc       move.w  d2,$00ca(a6)
L000488c0       btst.l  #$0003,d0
L000488c4       beq.b   L000488ce
L000488c6       move.w  d3,$00d6(a6)
L000488ca       move.w  d2,$00da(a6)
L000488ce       move.w  $001e(a6),d2
L000488d2       and.w   d1,d2
L000488d4       cmp.w   d1,d2
L000488d6       bne.b   L000488ce
L000488d8       moveq   #$02,d2
L000488da       move.w  $0006(a6),d3
L000488de       and.w   #$ff00,d3
L000488e2       move.w  $0006(a6),d4
L000488e6       and.w   #$ff00,d4
L000488ea       cmp.w   d4,d3
L000488ec       beq.b   L000488e2
L000488ee       move.w  d4,d3
L000488f0       dbf.w   d2,L000488e2

L000488f4       move.w  master_audio_volume_mask_1,d1           ; L0004801c,d1
L000488fa       move.w  master_audio_volume_mask_2,d2           ; L0004801e,d2
L00048900       lea.l   channel_00_status,a0                    ; L00048024,a0
L00048906       move.w  d1,d3
L00048908       btst.b  #$0006,(a0)
L0004890c       beq.b   L00048910
L0004890e       move.w  d2,d3
L00048910       and.w   $004c(a0),d3
L00048914       move.w  d3,$00a8(a6)
L00048918       move.w  $004a(a0),$00a6(a6)
L0004891e       btst.l  #$0000,d0
L00048922       beq.b   L00048932
L00048924       move.w  $0042(a0),$00a4(a6)
L0004892a       move.l  $003e(a0),$00a0(a6)
L00048930       bra.b   L0004893e
L00048932       move.w  $0048(a0),$00a4(a6)
L00048938       move.l  $0044(a0),$00a0(a6)
L0004893e       lea.l   channel_01_status,a0                    ; L0004807a,a0
L00048944       move.w  d1,d3
L00048946       btst.b  #$0006,(a0)
L0004894a       beq.b   L0004894e
L0004894c       move.w  d2,d3
L0004894e       and.w   $004c(a0),d3
L00048952       move.w  d3,$00b8(a6)
L00048956       move.w  $004a(a0),$00b6(a6)
L0004895c       btst.l  #$0001,d0
L00048960       beq.b   L00048970
L00048962       move.w  $0042(a0),$00b4(a6)
L00048968       move.l  $003e(a0),$00b0(a6)
L0004896e       bra.b   L0004897c
L00048970       move.w  $0048(a0),$00b4(a6)
L00048976       move.l  $0044(a0),$00b0(a6)
L0004897c       lea.l   channel_02_status,a0                    ; L000480d0,a0
L00048982       move.w  d1,d3
L00048984       btst.b  #$0006,(a0)
L00048988       beq.b   L0004898c
L0004898a       move.w  d2,d3
L0004898c       and.w   $004c(a0),d3
L00048990       move.w  d3,$00c8(a6)
L00048994       move.w  $004a(a0),$00c6(a6)
L0004899a       btst.l  #$0002,d0
L0004899e       beq.b   L000489ae
L000489a0       move.w  $0042(a0),$00c4(a6)
L000489a6       move.l  $003e(a0),$00c0(a6)
L000489ac       bra.b   L000489ba
L000489ae       move.w  $0048(a0),$00c4(a6)
L000489b4       move.l  $0044(a0),$00c0(a6)
L000489ba       lea.l   channel_03_status,a0                    ; L00048126,a0
L000489c0       move.w  d1,d3
L000489c2       btst.b  #$0006,(a0)
L000489c6       beq.b   L000489ca
L000489c8       move.w  d2,d3
L000489ca       and.w   $004c(a0),d3
L000489ce       move.w  d3,$00d8(a6)
L000489d2       move.w  $004a(a0),$00d6(a6)
L000489d8       btst.l  #$0003,d0
L000489dc       beq.b   L000489ec
L000489de       move.w  $0042(a0),$00d4(a6)
L000489e4       move.l  $003e(a0),$00d0(a6)
L000489ea       bra.b   L000489f8
L000489ec       move.w  $0048(a0),$00d4(a6)
L000489f2       move.l  $0044(a0),$00d0(a6)
L000489f8       or.w    #$8000,d0
L000489fc       move.w  d0,$0096(a6)
L00048a00       clr.w   audio_dma                               ; L0004817c
L00048a06       rts


                ;------------------- initialise music samples --------------------
                ; extract sample data ptrs and lengths from the IFF sample
                ; data.
                ;
                ; IN: a0    - music sample table address $4D52 - default_sample_data
                ; IN: a1    - music/song instrument data $4BFA - instrument_data
                ;
init_instruments                                                ; original address $00048a08
                move.l  (a0)+,d0
                beq.b   .exit
                move.w  (a0)+,(a1)
                move.w  (a0)+,$000e(a1)
                move.l  a0,-(a7)
                lea.l   -8(a0,d0.L),a0                          ; $f8(a0,d0.L),a0
                move.l  $0004(a0),d0
                addq.l  #$08,d0
                bsr.w   process_instrument                      ; L00048a28
                movea.l (a7)+,a0
                bra.b   init_instruments                        ; jmp L00048a08
.exit           rts 


                ; ------------------ process instrument  ----------------
                ; IN: A0 = ptr to start of 'FORM' block of sample data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of sample including headers.
                ;
process_instrument
                move.l  a1,-(a7)
                bsr.w   process_sample_data     ; L00048a6c - External Include 'process_sample_data.s'
                movea.l (a7)+,a1
                addq.l  #$02,a1                 ; addaq
                movea.l sample_vhdr_ptr,a0      ; L00048b80,a0
                move.l  (a0)+,d0                ; d0 = sample length length
                bclr.l  #$0000,d0               ; d0 = make length even
                move.l  (a0)+,d1                ; d1 = sample repeat length 
                bclr.l  #$0000,d1               ; d1 = make repeat length even
                movea.l sample_body_ptr,a0      ; L00048ba8,a0
                move.l  a0,(a1)+                ; store sample start address in instrument table offset 2-5
                adda.l  d0,a0                   ; a0 = start of repeat section of sample
                add.l   d1,d0                   ; d0 = total length of sample + repeat
                lsr.l   #$01,d0                 ; d0 = count of word length
                move.w  d0,(a1)+                ; store sample length (words) in table offset 6-7
                tst.l   d1                      ; test repeat length
                bne.b   .set_repeat             ; L00048a60
.no_repeat
                lea.l   silient_repeat,a0       ; L00048d80,a0 - silent repeat sample data
                moveq   #$02,d1                 ; set single word length for silent repeat length
.set_repeat
                move.l  a0,(a1)+                ; set repeat start address in table offset 8 - 11
                lsr.l   #$01,d1                 ; d1 = repeat length (words)
                move.w  d1,(a1)+                ; set repeat length (words) in table offset 12-13
                addq.l  #$02,a1                 ; update instrument table ptr (skip param 2 - unknown 0 or -1 value) - 14-15 ; addaq
                rts 









; FUNCTION:
; process_sample_data
;
; IN:
; A0 = ptr to start of 'FORM' or 'CAT ' block of sample data.
; A1 = ptr to Instrument Entry in Music Data.
; D0 = remaining length of sample file including headers.
;
; OUT:
; sample_status         ; 0 = success, 1 = missing FORM/CAT chunk, 2 = missing 8SVX chunk
; sample_vhdr_ptr       ; address ptr to sample vhdr data
; sample_body_ptr       ; address ptr to raw sample data
;
                include './lib/process_sample_data.s'





                ; --------------------- Note Period Table ------------------------
                ;       - audio channel period values - note frequenies
                ;       - indexes to $00004bba clamped to -48 bytes or +44 bytes to remain in table range
                ;       - I've got the table running B to B (may be I'm a semi-tone out C to C - most likely) 
note_period_table                                               ; original address $00048BD0
L00048BD0       dc.w    $06FE, $0699, $063B, $05E1, $058D, $053D, $04F2, $04AB          
L00048BE0       dc.w    $0467, $0428, $03EC, $03B4, $037F, $034D, $031D, $02F1          
L00048BF0       dc.w    $02C6, $029E, $0279, $0255, $0234, $0214, $01F6, $01DA  

L00048c00       dc.w    $01BF, $01A6, $018F, $0178, $0163, $014F, $013C, $012B          
L00048C10       dc.w    $011A, $010A, $00FB, $00ED, $00E0, $00D3, $00C7, $00BC          
L00048C20       dc.w    $00B2, $00A8, $009E, $0095, $008D, $0085, $007E, $0077          




command_17_data
L00048C30       dc.w    $0021, $0004, $8D82, $000B, $0004, $8D82, $000B, $0000          ;.!..............

instrument_data                                                 ; original address $00048C40
L00048C40       dc.w    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00048C50       dc.w    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00048C60       dc.w    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00048C70       dc.w    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00048C80       dc.w    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00048C90       dc.w    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00048CA0       dc.w    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00048CB0       dc.w    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00048CC0       dc.w    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00048CD0       dc.w    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00048CE0       dc.w    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00048CF0       dc.w    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00048D00       dc.w    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00048D10       dc.w    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00048D20       dc.w    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00048D30       dc.w    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00048D40       dc.w    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00048D50       dc.w    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00048D60       dc.w    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00048D70       dc.w    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   

silient_repeat                                  ; original address $00048D80
L00048D80       dc.w    $0000                   ; 2 bytes of silent sample repeat data (for samples that don't have a repeat section)


L00048D82       dc.w    $0074, $60DC, $82BB, $457E, $24A0, $8C00, $7460          ;...t`...E~$...t`
L00048D90       dc.w    $DC82, $BB45, $7E24, $A08C


                ; ------ music sample data table (12 sample offsets & 2 word params) ------
                ; 12 sound samples in IFF 8SVX format.
                ; Table of address offsets below, not sure what the additional two 16 bit 
                ; parameters that follow the offset represent yet. maybe volume and something else.
                ;
raw_sample_data_table                                   ; original address $00048d98
L00048d98       
.data_01        dc.l    sample_file_01-.data_01         ; $00048E0C - $00048d98 = $00000074
                dc.w    $0030, $0000                            
.data_02        dc.l    sample_file_02-.data_02         ; $0004AA74 - $00048dA0 = $00001CD4
                dc.w    $0030, $0000
.data_03        dc.l    sample_file_03-.data_03         ; $0004c5c8 - $00048dA0 = $00003820
                dc.w    $001D, $FFFF
.data_04        dc.l    sample_file_04-.data_04         ; $0004d090 - $00048DB0 = $000042E0
                dc.w    $0018, $FFFF
.data_05        dc.l    sample_file_05-.data_05         ; $0004e492 - $00048DB8 = $000056DA
                dc.w    $0018, $0000
.data_06        dc.l    sample_file_06-.data_06         ; $0004fcf0 - $00048DC0 = $00006F30
                dc.w    $0018, $0000
.data_07        dc.l    sample_file_07-.data_07         ; $00050c50 - $00048DC8 = $00007E88
                dc.w    $0018, $0000
.data_08        dc.l    sample_file_08-.data_08         ; $00051344 - $00048DD0 = $00008574
                dc.w    $0018, $0000
.data_09        dc.l    sample_file_09-.data_09         ; $000519de - $00048DD8 = $00008C06
                dc.w    $0018, $0000
.data_10        dc.l    sample_file_10-.data_10         ; $00052690 - $00048DE0 = $000098B0
                dc.w    $0018, $0000
.data_11        dc.l    sample_file_11-.data_11         ; $00052fa0 - $00048DE8 = $0000A1B8
                dc.w    $0018, $0000         
.data_12        dc.l    sample_file_12-.data_12         ; $00053676 - $00048DF0 = $0000A886 
                dc.w    $0018, $0000
.data_13        dc.l    sample_file_13-.data_13         ; $00053d7a - $00048DF8 = $0000AF82 
                dc.w    $0018, $0000          
.data_14        dc.l    sample_file_14-.data_14         ; $000549cc - $00048E00 = $0000BBCC 
                dc.w    $0018, $0000
                dc.w    $0000, $0000                    ; 0 marks the end of sample table data                    


 ; Sample 01
sample_file_01
                ; --------------------- Sound Sample 1 -------------------
                ; Start Address: $00048DFC
                ; Name:          PIPEORGAN-C4
                include "./music/sample_file_01.s"


; Sample 02
sample_file_02
                ; --------------------- Sound Sample 2 -------------------
                ; Start Address: $0004A7A8
                ; Name:          MOOGBASS-C2
                include "./music/sample_file_02.s"



; Sample 03
sample_file_03
                ; --------------------- Sound Sample 3 -------------------
                ; Start Address: $0004C8E8
                ; Name:          STRINGS-C4
                include "./music/sample_file_03.s"


; Sample 04
sample_file_04
                ; --------------------- Sound Sample 4 -------------------
                ; Start Address: $0004E43C
                ; Name:          HITSNARE-C2
                include "./music/sample_file_04.s"


; Sample 05
sample_file_05
                ; --------------------- Sound Sample 5 -------------------
                ; Start Address: $0004F8F4
                ; Name:          TIMELESS-A4        
                include "./music/sample_file_05.s"


; Sample 06
sample_file_06
                ; --------------------- Sound Sample 6 -------------------
                ; Start Address: $00050CC2
                ; Name:          GUNFIRE2
                include "./music/sample_file_06.s"



; Sample 07
sample_file_07
                ; --------------------- Sound Sample 7 -------------------
                ; Start Address: $00051C22
                ; Name:          HELICOPTER
                include "./music/sample_file_07.s"



; Sample 08
sample_file_08
                ; --------------------- Sound Sample 8 -------------------
                ; Start Address: $00052C74
                ; Name:          THROWGRENADE
                include "./music/sample_file_08.s"



; Sample 09
sample_file_09
                ; --------------------- Sound Sample 9 -------------------
                ; Start Address: $00053926
                ; Name:          BATARANG
                include "./music/sample_file_09.s"




; Sample 10
sample_file_10
                ; --------------------- Sound Sample 10 -------------------
                ; Start Address: $00054236
                ; Name:          BATROPE
                include "./music/sample_file_10.s"



; Sample 11
sample_file_11
                ; --------------------- Sound Sample 11 -------------------
                ; Start Address: $0005490C
                ; Name:          YOU-GETTIN-HIT
                include "./music/sample_file_11.s"



; Sample 12
sample_file_12
                ; --------------------- Sound Sample 12 -------------------
                ; Start Address: $00055010
                ; Name:          EXPLOSION
                include "./music/sample_file_12.s"


                          


L00055C62       dc.w    $002E,$002F,$0031,$0034,$0047,$004A,$004E,$004F         ;.../.1.4.G.J.N.O
L00055C72       dc.w    $0050,$0051,$0054,$0057,$005A,$005D,$0060,$0073         ;.P.Q.T.W.Z.].`.s
L00055C82       dc.w    $0076,$0079,$007C,$007F,$0082,$0084,$0087,$0101         ;.v.y.|..........
L00055C92       dc.w    $0001,$0200,$0C01,$0300,$0307,$0113,$000C,$010B         ;................
L00055CA2       dc.w    $020A,$0309,$0408,$0507,$0605,$0403,$0201,$0001         ;................
L00055CB2       dc.w    $0300,$0307,$0104,$000C,$0307,$0101,$0001,$0100         ;................
L00055CC2       dc.w    $0101,$0001,$0300,$0509,$0103,$0004,$0701,$0300         ;................
L00055CD2       dc.w    $0508,$0103,$0003,$0801,$0300,$0409,$0113,$0018         ;................
L00055CE2       dc.w    $020B,$020A,$0309,$0408,$0507,$0605,$0403,$0201         ;................
L00055CF2       dc.w    $0001,$0300,$0507,$0103,$0003,$0701,$0300,$0107         ;................
L00055D02       dc.w    $0103,$0005,$0901,$0300,$180C,$0102,$000C,$0103         ;................
L00055D12       dc.w    $0003,$0701,$0300,$0308,$0014,$0019,$001E,$0020         ;............... 
L00055D22       dc.w    $0024,$0028,$002C,$0032,$0038,$003E,$010F,$05FE         ;.$.(.,.2.8.>....
L00055D32       dc.w    $0005,$FF01,$0F0A,$FF00,$05FF,$010F,$0000,$0111         ;................
L00055D42       dc.w    $05FE,$0000,$010F,$07FF,$0000,$010E,$05FE,$0000         ;................
L00055D52       dc.w    $010A,$08FF,$01FE,$0000,$010F,$07FE,$01FF,$0000         ;................
L00055D62       dc.w    $010F,$05FE,$05FF,$0000,$013E,$0000,$0168,$011D         ;.........>...h..
L00055D72       dc.w    $00F0,$0000,$05A2,$05A2,$05A2,$0000,$0631,$0631         ;.............1.1
L00055D82       dc.w    $0631,$0000,$0658,$0654,$0656,$0000,$0000,$0000         ;.1...X.T.V......
L00055D92       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00055DA2       dc.w    $0000,$003A,$0000,$0000,$0000,$0030,$0000,$0000         ;...:.......0....
L00055DB2       dc.w    $0000,$0026,$0000,$0000,$0000,$0024,$0000,$0000         ;...&.......$....
L00055DC2       dc.w    $0000,$0014,$0000,$0000,$0000,$000A,$0000,$0000         ;................
L00055DD2       dc.w    $0000,$000E,$1F80,$2080,$2180,$2280,$2380,$2480         ;...... .!.".#.$.
L00055DE2       dc.w    $2580,$8F09,$9006,$0C32,$808F,$0990,$0781,$16FF         ;%......2........
L00055DF2       dc.w    $808F,$0990,$0816,$3280,$8F09,$9009,$1C1E,$808F         ;......2.........
L00055E02       dc.w    $0990,$0A18,$1E80,$8F09,$900B,$161E,$808F,$0990         ;................
L00055E12       dc.w    $0C07,$3280,$00FC,$011B,$0176,$01D8,$0209,$0231         ;..2......v.....1
L00055E22       dc.w    $024E,$025E,$02BC,$02F3,$032C,$0374,$03BA,$03C3         ;.N.^.....,.t....
L00055E32       dc.w    $03E9,$0406,$042B,$0452,$049E,$049F,$04B1,$04DE         ;.....+.R........
L00055E42       dc.w    $050B,$052E,$056F,$057B,$0587,$059D,$05C9,$05F8         ;.....o.{........
L00055E52       dc.w    $060D,$FF90,$FF95,$FF9B,$FFA0,$FFA5,$FFAA,$FFAF         ;................
L00055E62       dc.w    $8103,$0303,$8308,$0607,$0C83,$0312,$0783,$020F         ;................
L00055E72       dc.w    $82F9,$0F82,$F90F,$8200,$0F82,$F90F,$82FE,$0F82         ;................
L00055E82       dc.w    $020F,$82FD,$0F82,$040F,$1014,$8081,$0000,$0083         ;................
L00055E92       dc.w    $0404,$8203,$0482,$0304,$0404,$0404,$0A04,$040B         ;................
L00055EA2       dc.w    $8304,$0404,$040A,$0404,$0B83,$0204,$8203,$0404         ;................
L00055EB2       dc.w    $8304,$0D04,$040D,$0D82,$FE04,$82FE,$0482,$0204         ;................
L00055EC2       dc.w    $8202,$0482,$FD04,$82FD,$0482,$0404,$8204,$0483         ;................
L00055ED2       dc.w    $0204,$1380,$8101,$0211,$8308,$0505,$0508,$0505         ;................
L00055EE2       dc.w    $0983,$0405,$0505,$0805,$0509,$8304,$0583,$040E         ;................
L00055EF2       dc.w    $0505,$0E0E,$82FE,$0582,$FE05,$8202,$0582,$0205         ;................
L00055F02       dc.w    $82FD,$0582,$FD05,$8204,$0582,$0405,$8304,$0580         ;................
L00055F12       dc.w    $8F01,$9002,$8B18,$0103,$1860,$1D60,$1F60,$2030         ;.........`.`.` 0
L00055F22       dc.w    $1F30,$1B60,$1A60,$2360,$1F54,$9004,$1806,$1806         ;.0.`.`#`.T......
L00055F32       dc.w    $8090,$018F,$038B,$1001,$0330,$0C30,$1830,$1830         ;.........0.0.0.0
L00055F42       dc.w    $1830,$0C30,$0C30,$1830,$1830,$1830,$0C30,$0C2F         ;.0.0.0.0.0.0.0./
L00055F52       dc.w    $182F,$182F,$182F,$0C32,$0C33,$1833,$0C33,$0C32         ;./././.2.3.3.3.2
L00055F62       dc.w    $1832,$0C30,$0C30,$1830,$1830,$1830,$0C32,$0C32         ;.2.0.0.0.0.0.2.2
L00055F72       dc.w    $1832,$1832,$1832,$0C2F,$0C2F,$182F,$182F,$182F         ;.2.2.2./././././
L00055F82       dc.w    $0C2F,$0C2F,$182F,$182F,$182F,$062F,$0680,$9001         ;././././././....
L00055F92       dc.w    $8F03,$300C,$3018,$3C18,$3018,$3006,$3006,$300C         ;..0.0.<.0.0.0.0.
L00055FA2       dc.w    $3018,$3C18,$3018,$3006,$3006,$310C,$3218,$3E18         ;0.<.0.0.0.1.2.>.
L00055FB2       dc.w    $3218,$320C,$320C,$3318,$3318,$330C,$330C,$320C         ;2.2.2.3.3.3.3.2.
L00055FC2       dc.w    $300C,$3018,$3C18,$3018,$3006,$3006,$320C,$3218         ;0.0.<.0.0.0.2.2.
L00055FD2       dc.w    $3E18,$3218,$3206,$3206,$2F0C,$2F18,$3B18,$2F18         ;>.2.2.2././.;./.
L00055FE2       dc.w    $2F06,$2F06,$2B0C,$2B18,$2B18,$8E8B,$0C02,$0224         ;/./.+.+.+......$
L00055FF2       dc.w    $2480,$9003,$8F04,$8D04,$3048,$3018,$8D0B,$3048         ;$.......0H0...0H
L00056002       dc.w    $3018,$8D09,$3248,$3218,$3348,$3318,$8D0D,$3348         ;0...2H2.3H3...3H
L00056012       dc.w    $3318,$8D0A,$3248,$3218,$8D09,$3230,$8D0C,$3330         ;3...2H2...20..30
L00056022       dc.w    $8D09,$3260,$8090,$028F,$028E,$8B06,$0103,$1806         ;..2`............
L00056032       dc.w    $1806,$2406,$1806,$9004,$180C,$9002,$160C,$180C         ;..$.............
L00056042       dc.w    $2406,$1806,$9004,$180C,$9002,$1806,$2406,$8090         ;$...........$...
L00056052       dc.w    $038F,$058D,$0484,$0630,$3030,$3085,$300C,$8406         ;.......0000.0...
L00056062       dc.w    $3030,$3030,$3030,$8530,$0C30,$0630,$0680,$9005         ;000000.0.0.0....
L00056072       dc.w    $8F00,$8E8C,$870C,$8412,$3C3E,$413E,$853C,$0C80         ;........<>A>.<..
L00056082       dc.w    $9001,$8F01,$8B14,$0102,$840C,$302B,$3033,$3033         ;..........0+0303
L00056092       dc.w    $3733,$3A37,$3A85,$3A18,$3C24,$9005,$840C,$2B30         ;73:7:.:.<$....+0
L000560A2       dc.w    $3233,$8535,$1237,$1238,$0C37,$608E,$9001,$840C         ;23.5.7.8.7`.....
L000560B2       dc.w    $241F,$2427,$2427,$2B27,$2E2B,$2E85,$2E18,$300C         ;$.$'$'+'.+....0.
L000560C2       dc.w    $320C,$3324,$320C,$3030,$9005,$260C,$8406,$292C         ;2.3$2.00..&...),
L000560D2       dc.w    $3035,$3538,$3C41,$2B2F,$3237,$373B,$3E43,$8580         ;0558<A+/277;>C..
L000560E2       dc.w    $9003,$8F05,$8D04,$8406,$3030,$3030,$8530,$0C84         ;........0000.0..
L000560F2       dc.w    $0630,$3035,$3535,$3585,$350C,$3506,$3506,$8D0A         ;.005555.5.5.5...
L00056102       dc.w    $8406,$3737,$3737,$8537,$0C84,$0637,$3737,$3737         ;..7777.7...77777
L00056112       dc.w    $3785,$370C,$3706,$3706,$8090,$038F,$058D,$0C84         ;7.7.7.7.........
L00056122       dc.w    $0630,$3030,$3085,$300C,$8406,$3030,$3030,$3030         ;.0000.0...000000
L00056132       dc.w    $8530,$0C30,$0630,$068D,$0484,$0635,$3535,$3585         ;.0.0.0.....5555.
L00056142       dc.w    $350C,$8406,$3535,$8D0A,$3737,$3737,$8537,$0C37         ;5...55..7777.7.7
L00056152       dc.w    $0637,$0680,$8E8B,$0601,$0390,$028F,$0218,$0618         ;.7..............
L00056162       dc.w    $0618,$0618,$0690,$0418,$0C90,$0216,$0C18,$0C1D         ;................
L00056172       dc.w    $0C90,$0418,$0C90,$021D,$061D,$061F,$061F,$061F         ;................
L00056182       dc.w    $061F,$0690,$0418,$0C90,$021F,$0C1F,$0C1F,$0C90         ;................
L00056192       dc.w    $0418,$0690,$0213,$061D,$0690,$0418,$0680,$8E8B         ;................
L000561A2       dc.w    $0601,$0390,$028F,$0220,$0620,$0620,$0620,$0690         ;....... . . . ..
L000561B2       dc.w    $0418,$0C90,$021E,$0C20,$0C20,$0620,$0690,$0418         ;....... . . ....
L000561C2       dc.w    $0618,$0C18,$0690,$021D,$061D,$061D,$061D,$0690         ;................
L000561D2       dc.w    $0418,$0C90,$021B,$0C1D,$0C1F,$061F,$0690,$0418         ;................
L000561E2       dc.w    $0C18,$0618,$0680,$9005,$8F01,$8B30,$0104,$3060         ;...........0..0`
L000561F2       dc.w    $808E,$8B0C,$0103,$9002,$8F02,$1D06,$1D06,$1D06         ;................
L00056202       dc.w    $1D06,$9004,$180C,$9002,$160C,$1D0C,$1D06,$1D06         ;................
L00056212       dc.w    $9004,$180C,$9002,$1D0C,$8090,$038F,$058D,$0484         ;................
L00056222       dc.w    $0635,$3535,$3585,$350C,$8406,$3535,$3535,$3535         ;.5555.5...555555
L00056232       dc.w    $8535,$0C35,$0635,$0680,$8E90,$058F,$008C,$840C         ;.5.5.5..........
L00056242       dc.w    $3330,$3337,$3385,$3706,$330C,$3306,$300C,$840C         ;30373.7.3.3.0...
L00056252       dc.w    $3F3C,$3F43,$3F85,$4306,$3F0C,$3F06,$3C0C,$808E         ;?<?C?.C.?.?.<...
L00056262       dc.w    $9005,$8F00,$8406,$333C,$3C27,$4827,$333C,$3033         ;......3<<'H'3<03
L00056272       dc.w    $3C33,$483F,$303C,$3330,$3C33,$4827,$333C,$3033         ;<3H?0<30<3H'3<03
L00056282       dc.w    $3C33,$483F,$303C,$8580,$8E90,$018F,$018B,$1402         ;<3H?0<..........
L00056292       dc.w    $0284,$0C24,$2B30,$2B33,$3033,$3785,$88FF,$0C3C         ;...$+0+3037....<
L000562A2       dc.w    $483E,$0C3F,$0C3F,$183E,$0C3E,$303C,$063E,$063C         ;H>.?.?.>.>0<.>.<
L000562B2       dc.w    $0C38,$0C88,$FF0C,$350C,$3348,$840C,$3233,$3233         ;.8....5.3H..2323
L000562C2       dc.w    $3233,$302D,$3236,$8539,$2437,$0C36,$0C3B,$3036         ;230-26.9$7.6.;06
L000562D2       dc.w    $0C33,$1837,$6C80,$8760,$8090,$028F,$018B,$1801         ;.3.7l..`........
L000562E2       dc.w    $031B,$301A,$3018,$3C88,$FE1E,$1824,$808E,$9005         ;..0.0.<....$....
L000562F2       dc.w    $8F03,$8406,$333C,$3C48,$4827,$333C,$4833,$3C33         ;....3<<HH'3<H3<3
L00056302       dc.w    $373F,$303C,$3330,$3C48,$4827,$333C,$483C,$4348         ;7?0<30<HH'3<H<CH
L00056312       dc.w    $3037,$3C48,$8580,$1680,$1580,$1780,$9002,$8F01         ;07<H............
L00056322       dc.w    $1806,$2406,$1806,$180C,$1806,$1606,$1806,$2906         ;..$...........).
L00056332       dc.w    $2906,$1D06,$2912,$1D0C,$1806,$2406,$1806,$1D0C         ;)...).....$.....
L00056342       dc.w    $1D0C,$1D06,$240C,$1F0C,$180C,$8090,$018B,$1401         ;....$...........
L00056352       dc.w    $038F,$0187,$0C30,$0C33,$0C37,$0C38,$1237,$1235         ;.....0.3.7.8.7.5
L00056362       dc.w    $1287,$0630,$0C35,$0638,$063A,$0C3B,$033C,$2480         ;...0.5.8.:.;.<$.
L00056372       dc.w    $9003,$8F00,$8D04,$300C,$3006,$300C,$3006,$3006         ;......0.0.0.0.0.
L00056382       dc.w    $3006,$8D0B,$300C,$3006,$300C,$3006,$3006,$3006         ;0...0.0.0.0.0.0.
L00056392       dc.w    $8D04,$300C,$3006,$8D0B,$300C,$3006,$3006,$3006         ;..0.0...0.0.0.0.
L000563A2       dc.w    $8D0A,$300C,$8D0C,$2F0C,$8D0A,$300C,$8018,$801A         ;..0.../...0.....
L000563B2       dc.w    $8019,$8090,$028F,$0184,$061F,$1F1D,$1F85,$8718         ;................
L000563C2       dc.w    $8090,$058F,$0184,$0646,$4544,$4385,$8718,$8090         ;.......FEDC.....
L000563D2       dc.w    $048F,$0284,$0618,$1818,$1880,$1B80,$1C80,$1D82         ;................
L000563E2       dc.w    $FE1D,$8201,$1D1E,$8090,$058F,$0184,$0646,$453E         ;.............FE>
L000563F2       dc.w    $3F46,$4546,$453E,$3F46,$4544,$433C,$3D44,$4344         ;?FEFE>?FEDC<=DCD
L00056402       dc.w    $433C,$3D44,$4340,$3F37,$3840,$3F40,$3F37,$3840         ;C<=DC@?78@?@?78@
L00056412       dc.w    $3F85,$3C18,$8090,$038F,$008D,$0B32,$0C32,$0C32         ;?.<........2.2.2
L00056422       dc.w    $0C32,$0632,$0C32,$1230,$0C30,$0C30,$0C30,$0630         ;.2.2.2.0.0.0.0.0
L00056432       dc.w    $0C30,$128D,$0C30,$0C30,$0C30,$0C30,$0630,$0C30         ;.0...0.0.0.0.0.0
L00056442       dc.w    $128D,$1430,$1880,$9002,$8F01,$1F06,$1F06,$1F06         ;...0............
L00056452       dc.w    $1F06,$1F0C,$1F0C,$1F06,$1F06,$1F0C,$8090,$028F         ;................
L00056462       dc.w    $0118,$1880,$0000,$0000,$0000,$0000,$0000,$0000         ;................




L00056472       dc.w    $0000,$0000,$0000,$0031,$1C80,$0000,$000A,$8028         ;.......1.......(
L00056482       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00056492       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0022         ;..............."
L000564A2       dc.w    $2080,$0000,$000B,$8028,$0000,$0000,$0000,$0000         ; ......(........
L000564B2       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000564C2       dc.w    $0000,$0000,$0000,$0062,$5E80,$0000,$0015,$4014         ;.......b^.....@.
L000564D2       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000564E2       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0069         ;...............i
L000564F2       dc.w    $8140,$3FFF,$F850,$4014,$0000,$0000,$0000,$0000         ;.@?..P@.........
L00056502       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00056512       dc.w    $0000,$0000,$0000,$004C,$3CC7,$EFFE,$AFB1,$8014         ;.......L<.......
L00056522       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00056532       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$004E         ;...............N
L00056542       dc.w    $7F1D,$15FF,$6AE0,$8014,$0000,$0000,$0000,$0000         ;....j...........
L00056552       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00056562       dc.w    $0000,$0000,$0000,$0048,$7F8A,$83FF,$8552,$800A         ;.......H.....R..
L00056572       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00056582       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$00CC         ;................
L00056592       dc.w    $363F,$45FF,$42B5,$000A,$0000,$0000,$0000,$0000         ;6?E.B...........
L000565A2       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000565B2       dc.w    $0000,$0000,$0000,$00E7,$44FF,$A2FF,$A174,$000A         ;........D....t..
L000565C2       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000565D2       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$00D0         ;................
L000565E2       dc.w    $4DFF,$C17F,$42B4,$000A,$0000,$0000,$0000,$0000         ;M...B...........
L000565F2       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00056602       dc.w    $0000,$0000,$0000,$00EA,$8BE1,$A0BE,$A17A,$0005         ;.............z..
L00056612       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00056622       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$00D2         ;................
L00056632       dc.w    $8B80,$5055,$42BA,$0005,$0000,$0000,$0000,$0000         ;..PUB...........
L00056642       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00056652       dc.w    $0000,$0000,$0000,$00E4,$0A15,$2A0A,$07FA,$0005         ;..........*.....
L00056662       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00056672       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$00F3         ;................
L00056682       dc.w    $CAAE,$9F00,$0E1A,$0005,$0000,$0000,$0000,$0000         ;................
L00056692       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000566A2       dc.w    $0000,$0000,$0000,$00E4,$697F,$4681,$580E,$0002         ;........i.F.X...
L000566B2       dc.w    $8000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000566C2       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$00FA         ;................
L000566D2       dc.w    $90D5,$E1EB,$F01E,$0002,$8000,$0000,$0000,$0000         ;................
L000566E2       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L000566F2       dc.w    $0000,$0000,$0000,$00ED,$55AA,$D03F,$000E,$0002         ;........U..?....
L00056702       dc.w    $8000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00056712       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$01E7         ;................
L00056722       dc.w    $82C1,$7000,$0012,$0001,$0000,$0000,$0000,$0000         ;..p.............
L00056732       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00056742       dc.w    $0000,$0000,$0000,$01ED,$41AA,$AA02,$A80A,$0001         ;........A.......
L00056752       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00056762       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$01EB         ;................
L00056772       dc.w    $835D,$F557,$F416,$0001,$8000,$0000,$0000,$0000         ;.].W............
L00056782       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000         ;................
L00056792       dc.w    $0000,$0000,$0000,$01DD,$87FF,$FFBF,$FA0B,$0000         ;................






