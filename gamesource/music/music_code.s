
                ; Load Address and File Size
                ;   Memory Contents     Stsrt Address   End Address     Byte Size
                ;   --------------------------------------------------------------
                ;       Music           $00068f7c       $0007c60e       $00013692
                ;
                ;
                ; This is music and player routine for Level 2/4 - Batmobile & Batwing
                ;
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


                section music,code_c

                IFND TEST_BUILD_LEVEL
; Music Player Constants
AUDIO_PLAYER_INIT               EQU $00068f80                       ; initialise music/sfx player
AUDIO_PLAYER_SILENCE            EQU $00068f84                       ; Silence all audio
AUDIO_PLAYER_INIT_SFX_1         EQU $00068f88                       ; Initialise SFX Audio Channnel
AUDIO_PLAYER_INIT_SFX_2         EQU $00068f8c                       ; same as init_sfx_1 above
AUDIO_PLAYER_INIT_SONG          EQU $00068f90                       ; initialise song to play - D0.l = song/sound 1 to 13
AUDIO_PLAYER_INIT_SFX           EQU $00068f94                       ; initialise sfx to play - d0.l = sfx 5 to 13
AUDIO_PLAYER_UPDATE             EQU $00068f98                       ; regular update (vblank to keep sounds/music playing)
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


;TEST_MUSIC_BUILD SET 1             ; run a test build with imported GFX

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
   
original_start: ; original address $00068f7c
        dc.l    $00068F80


Init_Player
L00068f80           bra.w   do_initialise_music_player      ; $00069100
Stop_Player
L00068f84           bra.w   do_silence_all_audio            ; $00069114
Init_SFX_1
L00068f88           bra.w   do_init_sfx_channels            ; $00069168
Init_SFX_2
L00068f8c           bra.w   do_init_sfx_channels            ; $00069168
Init_Song
L00068f90           bra.w   do_init_song                    ; $000691ce
Init_SFX
L00068f94           bra.w   do_play_sfx                     ; $000691ac
Play_Sounds
L00068f98           bra.w   do_play_sounds                  ; $0006928e

L00068F9C   dc.w    $FFFF,$FFFF,$0000,$0101,$0000,$0000,$0000,$0000     ;................
L00068FAC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00068FBC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00068FCC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00068FDC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00068FEC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0001,$0000     ;................
L00068FFC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L0006900C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L0006901C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L0006902C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L0006903C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L0006904C   dc.w    $0000,$0002,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L0006905C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L0006906C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L0006907C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L0006908C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L0006909C   dc.w    $0000,$0000,$0000,$0000,$0004,$0000,$0000,$0000     ;................
L000690AC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L000690BC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L000690CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L000690DC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L000690EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0008     ;................
L000690FC   dc.w    $0000,$0000,$41F9,$0006,$9D20,$43F9,$0006,$9BC8     ;....A.... C.....


do_initialise_music_player
L00069100           lea.l   L00069d20,a0
L00069106           lea.l   L00069bc8,a1
L0006910c           bsr.w   L00069990
L00069110           bra.w   L00069114 


do_silence_all_audio
L00069114           movem.l d0/a0-a1,-(a7)
L00069118           move.b  #$00,L00068fa2
L00069120           move.b  #$00,L00068fa3
L00069128           lea.l   L00068fa4,a0
L0006912e           lea.l   L00dff0a8,a1
L00069134           bsr.b   L0006914a
L00069136           bsr.b   L0006914a
L00069138           bsr.b   L0006914a
L0006913a           bsr.b   L0006914a
L0006913c           move.w  #$0000,L00068fa0
L00069144           movem.l (a7)+,d0/a0-a1
L00069148           rts  


L0006914a           move.w  #$0000,(a0)
L0006914e           move.w  #$0001,$004a(a0)
L00069154           move.w  #$0000,$004c(a0)
L0006915a           move.w  #$0000,(a1)
L0006915e           adda.w  #$0056,a0
L00069162           adda.w  #$0010,a1
L00069166           rts 


do_init_sfx_channels
L00069168           movem.l d0/d7/a0-a2,-(a7)
L0006916c           subq.w  #$01,d0
L0006916e           bmi.b   L00069176
L00069170           cmp.w   #$000f,d0
L00069174           bcs.b   L0006917a
L00069176           bsr.b   L00069114
L00069178           bra.b   L000691a6


L0006917a           lea.l   L0007bf2c,a2
L00069180           asl.w   #$03,d0
L00069182           adda.w  d0,a2
L00069184           lea.l   L00068fa4,a0
L0006918a           lea.l   L00dff0a8,a1
L00069190           moveq   #$03,d7
L00069192           tst.w   (a2)+ 
L00069194           bne.b   L000691a0 
L00069196           adda.w  #$0056,a0
L0006919a           adda.w  #$0010,a1
L0006919e           bra.b   L000691a2 
L000691a0           bsr.b   L0006914a
L000691a2           dbf.w   d7,L00069192
L000691a6           movem.l (a7)+,d0/d7/a0-a2
L000691aa           rts  


do_play_sfx
L000691ac           tst.w   L000690a6 
L000691b2           beq.b   L000691bc a
L000691b4           cmp.b   L00068fa3,d0
L000691ba           bcs.b   L000691cc
L000691bc           movem.l d0/d7/a0-a2,-(a7)
L000691c0           move.w  #$4000,d1
L000691c4           move.b  d0,L00068fa3 
L000691ca           bra.b   L000691dc
L000691cc           rts  


do_init_song
L000691ce           movem.l d0/d7/a0-a2,-(a7)
L000691d2           move.w  #$8000,d1
L000691d6           move.b  d0,L00068fa2 
L000691dc           clr.w   L000690fe 
L000691e2           subq.w  #$01,d0
L000691e4           bmi.b   L000691ec
L000691e6           cmp.w   #$000f,d0
L000691ea           bcs.b   L000691f4
L000691ec           bsr.w   L00069114
L000691f0           bra.w   L00069288 
L000691f4           lea.l   L0007bf2c,a0
L000691fa           asl.w   #$03,d0
L000691fc           adda.w  d0,a0
L000691fe           lea.l   L00068fa4,a1
L00069204           moveq   #$03,d7
L00069206           move.w  (a0)+,d0
L00069208           beq.b   L0006927a
L0006920a           lea.l   -$02(a0,d0.w),a2        ;$fe
L0006920e           moveq   #$00,d0
L00069210           move.w  d0,$004c(a1)
L00069214           move.l  d0,$0002(a1)
L00069218           move.l  d0,$000a(a1)
L0006921c           move.b  d0,$0013(a1)
L00069220           move.b  #$01,$0012(a1)
L00069226           move.w  d1,(a1)
L00069228           move.b  (a2)+,d0
L0006922a           bpl.b   L0006925e
L0006922c           sub.b   #$80,d0
L00069230           bne.b   L00069240
L00069232           movea.l $0002(a1),a2
L00069236           cmpa.w  #$0000,a2
L0006923a           bne.b   L00069228
L0006923c           clr.w   (a1)
L0006923e           bra.b   L0006927a
L00069240           subq.b  #$01,d0
L00069242           bne.b   L0006924a
L00069244           move.l  a2,$0002(a1)
L00069248           bra.b   L00069228


L0006924a           subq.b  #$01,d0
L0006924c           bne.b   L00069254
L0006924e           move.b  (a2)+,$0013(a1)
L00069252           bra.b   L00069228 
L00069254           subq.b  #$01,d0
L00069256           bne.b   L00069228
L00069258           move.b  (a2)+,$0012(a1)
L0006925c           bra.b   L00069228 

L0006925e           move.l  a2,$0006(a1)
L00069262           lea.l   L0007c008,a2
L00069268           ext.w   d0
L0006926a           add.w   d0,d0
L0006926c           adda.w  d0,a2
L0006926e           adda.w  (a2),a2
L00069270           move.l  a2,$000e(a1)
L00069274           move.w  #$0001,$0052(a1)
L0006927a           lea.l   $0056(a1),a1
L0006927e           dbf.w   d7,L00069206
L00069282           or.w    d1,L00068fa0
L00069288           movem.l (a7)+,d0/d7/a0-a2
L0006928c           rts  


do_play_sounds
L0006928e           lea.l   $00dff000,a6
L00069294           lea.l   L00069b88,a5
L0006929a           clr.w   L000690fc
L000692a0           tst.w   L00068fa0
L000692a6           beq.b   L00069304
L000692a8           addq.w  #$01,L000690fe
L000692ae           clr.w   L00068fa0
L000692b4           lea.l   L00068fa4,a4
L000692ba           move.w  (a4),d7
L000692bc           beq.b   L000692c8
L000692be           bsr.b   L00069312
L000692c0           move.w  d7,(a4)
L000692c2           or.w    d7,L00068fa0
L000692c8           lea.l   L00068ffa,a4
L000692ce           move.w  (a4),d7
L000692d0           beq.b   L000692dc
L000692d2           bsr.b   L00069312
L000692d4           move.w  d7,(a4)
L000692d6           or.w    d7,L00068fa0
L000692dc           lea.l   L00069050,a4
L000692e2           move.w  (a4),d7
L000692e4           beq.b   L000692f0
L000692e6           bsr.b   L00069312
L000692e8           move.w  d7,(a4)
L000692ea           or.w    d7,L00068fa0
L000692f0           lea.l   L000690a6,a4
L000692f6           move.w  (a4),d7
L000692f8           beq.b   L00069304
L000692fa           bsr.b   L00069312
L000692fc           move.w  d7,(a4)
L000692fe           or.w    d7,L00068fa0
L00069304           and.w   #$c000,L00068fa0 
L0006930c           bsr.w   L00069806
L00069310           rts 


L00069312           tst.w   $0052(a4)
L00069316           beq.w   L00069666
L0006931a           subq.w  #$01,$0052(a4)
L0006931e           bne.w   L00069666
L00069322           movea.l $000e(a4),a3
L00069326           bclr.l  #$0007,d7

L0006932a           move.b  (a3)+,d0
L0006932c           bpl.w   L00069512
L00069330           bclr.l  #$0003,d7
L00069334           cmp.b   #$a0,d0
L00069338           bcc.b   L0006932a
L0006933a           lea.l   cmd_jump_table(pc),a0       ;L00069350(pc),a0
L0006933e           sub.b   #$80,d0
L00069342           ext.w   d0
L00069344           add.w   d0,d0
L00069346           adda.w  d0,a0
L00069348           move.w  (a0),d0
L0006934a           beq.b   L0006932a
L0006934c           jmp     $00(a0,d0.w)


; jump table offsets from L00069350 (32 music commands)
cmd_jump_table   
L00069350   dc.w    music_command_01-(cmd_jump_table+00)        ;$00069350 + $0040 = $00069390 - CMD 01   
L00069352   dc.w    music_command_02-(cmd_jump_table+02)        ;$00069352 + $00BA = $0006940C - CMD 02
L00069354   dc.w    music_command_03-(cmd_jump_table+04)        ;$00069354 + $00C0 = $00069414 - CMD 03   
L00069356   dc.w    music_command_04-(cmd_jump_table+06)        ;$00069356 + $00C2 = $00069418 - CMD 04   
L00069358   dc.w    music_command_05-(cmd_jump_table+08)        ;$00069358 + $00C4 = $0006941C - CMD 05   
L0006935a   dc.w    music_command_06-(cmd_jump_table+10)        ;$0006935a + $00CE = $00069428 - CMD 06   
L0006935c   dc.w    music_command_07-(cmd_jump_table+12)        ;$0006935c + $00D4 = $00069430 - CMD 07   
L0006935e   dc.w    music_command_08-(cmd_jump_table+14)        ;$0006935e + $00DC = $0006943A - CMD 08  
L00069360   dc.w    music_command_09-(cmd_jump_table+16)        ;$00069360 + $00EA = $0006944A - CMD 09   
L00069362   dc.w    music_command_10-(cmd_jump_table+18)        ;$00069362 + $00F8 = $0006945A - CMD 10   
L00069364   dc.w    music_command_11-(cmd_jump_table+20)        ;$00069364 + $010A = $0006946E - CMD 11   
L00069366   dc.w    music_command_12-(cmd_jump_table+22)        ;$00069366 + $0140 = $000694A6 - CMD 12   
L00069368   dc.w    music_command_13-(cmd_jump_table+24)        ;$00069368 + $0156 = $000694BE - CMD 13   
L0006936a   dc.w    music_command_14-(cmd_jump_table+26)        ;$0006936a + $010C = $00069476 - CMD 14   
L0006936c   dc.w    music_command_15-(cmd_jump_table+28)        ;$0006936c + $0132 = $0006949E - CMD 15   
L0006936e   dc.w    music_command_16-(cmd_jump_table+30)        ;$0006936e + $0158 = $000694C6 - CMD 16  
L00069370   dc.w    music_command_17-(cmd_jump_table+32)        ;$00069370 + $016E = $000694DE - CMD 17   
L00069372   dc.w    $0000                                       ;$00069372 + $0000 = $00000000 - CMD 18   
L00069374   dc.w    $0000                                       ;$00069374 + $0000 = $00000000 - CMD 19   
L00069376   dc.w    $0000                                       ;$00069376 + $0000 = $00000000 - CMD 20   
L00069378   dc.w    $0000                                       ;$00069378 + $0000 = $00000000 - CMD 21   
L0006937a   dc.w    $0000                                       ;$0006937a + $0000 = $00000000 - CMD 22   
L0006937c   dc.w    $0000                                       ;$0006937c + $0000 = $00000000 - CMD 23   
L0006937e   dc.w    $0000                                       ;$0006937e + $0000 = $00000000 - CMD 24  
L00069380   dc.w    $0000                                       ;$00069380 + $0000 = $00000000 - CMD 25   
L00069382   dc.w    $0000                                       ;$00069382 + $0000 = $00000000 - CMD 26   
L00069384   dc.w    $0000                                       ;$00069384 + $0000 = $00000000 - CMD 27   
L00069386   dc.w    $0000                                       ;$00069386 + $0000 = $00000000 - CMD 28   
L00069388   dc.w    $0000                                       ;$00069388 + $0000 = $00000000 - CMD 29   
L0006938a   dc.w    $0000                                       ;$0006938a + $0000 = $00000000 - CMD 30   
L0006938c   dc.w    $0000                                       ;$0006938c + $0000 = $00000000 - CMD 31  
L0006938e   dc.w    $0000                                       ;$0006938e + $0000 = $00000000 - CMD 32 



music_command_01
L00069390           movea.l $000a(a4),a3
L00069394           cmpa.w  #$0000,a3
L00069398           bne.b   L0006932a
L0006939a           movea.l $0006(a4),a3
L0006939e           move.b  -$0001(a3),d0
L000693a2           subq.b  #$01,$0012(a4)
L000693a6           bne.b   L000693f6
L000693a8           move.b  #$01,$0012(a4)
L000693ae           move.b  #$00,$0013(a4)
L000693b4           move.b  (a3)+,d0
L000693b6           bpl.b   L000693f6
L000693b8           sub.b   #$80,d0
L000693bc           bne.b   L000693d8
L000693be           movea.l $0002(a4),a3
L000693c2           cmpa.w  #$0000,a3
L000693c6           bne.b   L000693b4
L000693c8           move.w  #$0001,$004a(a4)
L000693ce           move.w  #$0000,$004c(a4)
L000693d4           moveq   #$00,d7
L000693d6           rts  


L000693d8           subq.b  #$01,d0
L000693da           bne.b   L000693e2
L000693dc           move.l  a3,$0002(a4)
L000693e0           bra.b   L000693b4
L000693e2           subq.b  #$01,d0
L000693e4           bne.b   L000693ec
L000693e6           move.b  (a3)+,$0013(a4)
L000693ea           bra.b   L000693b4

L000693ec           subq.b  #$01,d0
L000693ee           bne.b   L000693b4
L000693f0           move.b  (a3)+,$0012(a4)
L000693f4           bra.b   L000693b4

L000693f6           move.l  a3,$0006(a4)
L000693fa           lea.l   L0007c008,a3
L00069400           ext.w   d0
L00069402           add.w   d0,d0
L00069404           adda.w  d0,a3
L00069406           adda.w  (a3),a3
L00069408           bra.w   L0006932a


music_command_02
L0006940c           move.l  a3,$000a(a4)
L00069410           bra.w   L0006932a

music_command_03
L00069414           bra.w   L0006932a

music_command_04
L00069418           bra.w   L0006932a

music_command_05
L0006941c           bset.l  #$0005,d7
L00069420           move.b  (a3)+,$0051(a4)
L00069424           bra.w   L0006932a

music_command_06
L00069428           bclr.l  #$0005,d7
L0006942c           bra.w   L0006932a


music_command_07
L00069430           add.w   #$0100,$0052(a4)
L00069436           bra.w   L0006932a

music_command_08
L0006943a           bclr.l  #$0004,d7
L0006943e           bset.l  #$0007,d7
L00069442           clr.w   $004c(a4)
L00069446           bra.w   L00069650

music_command_09
L0006944a           bset.l  #$0003,d7
L0006944e           move.b  (a3)+,$0024(a4)
L00069452           move.b  (a3)+,$0025(a4)
L00069456           bra.w   L0006932a

music_command_10
L0006945a           and.w   #$fff8,d7
L0006945e           bset.l  #$0000,d7
L00069462           move.b  (a3)+,$0021(a4)
L00069466           move.b  (a3)+,$0022(a4)
L0006946a           bra.w   L0006932a

music_command_11
L0006946e           bclr.l  #$0000,d7
L00069472           bra.w   L0006932a

music_command_14
L00069476           and.w   #$fff8,d7
L0006947a           bset.l  #$0001,d7
L0006947e           lea.l   $0007be3a,a0
L00069484           moveq   #$00,d0
L00069486           move.b  (a3)+,d0
L00069488           add.w   d0,d0
L0006948a           adda.w  d0,a0
L0006948c           adda.w  (a0),a0
L0006948e           move.b  (a0)+,$0032(a4)
L00069492           move.b  (a0)+,$0030(a4)
L00069496           move.l  a0,$0028(a4)
L0006949a           bra.w   L0006932a

music_command_15
L0006949e           bclr.l  #$0001,d7
L000694a2           bra.w   L0006932a


music_command_12
L000694a6           and.w   #$fff8,d7
L000694aa           bset.l  #$0002,d7
L000694ae           move.b  (a3)+,$0036(a4)
L000694b2           move.b  (a3)+,$0034(a4)
L000694b6           move.b  (a3)+,$0035(a4)
L000694ba           bra.w   L0006932a

music_command_13
L000694be           bclr.l  #$0002,d7
L000694c2           bra.w   L0006932a

music_command_16
L000694c6           lea.l   L0007bedc,a0
L000694cc           moveq   #$00,d0
L000694ce           move.b  (a3)+,d0
L000694d0           add.w   d0,d0
L000694d2           adda.w  d0,a0
L000694d4           adda.w  (a0),a0
L000694d6           move.l  a0,$0014(a4)
L000694da           bra.w   L0006932a

music_command_17
L000694de           lea.l   $00069bb8,a0
L000694e4           moveq   #$00,d0
L000694e6           move.b  (a3)+,d0
L000694e8           asl.w   #$04,d0
L000694ea           adda.w  d0,a0
L000694ec           move.w  (a0)+,$003c(a4)
L000694f0           move.l  (a0)+,$003e(a4)
L000694f4           move.w  (a0)+,$0042(a4)
L000694f8           move.l  (a0)+,$0044(a4)
L000694fc           move.w  (a0)+,$0048(a4)
L00069500           bclr.l  #$0006,d7
L00069504           tst.w   (a0)
L00069506           beq.w   L0006932a
L0006950a           bset.l  #$0006,d7
L0006950e           bra.w   L0006932a




                ; +ve pattern command data (end of pattern command loop)
                ; IN: A4 = Sound Channel Structure
                ; IN: A3 = Next Pattern Command Ptr
                ; IN: D0 = command data
                ; IN: D7 = Channel Ctrl Bits
process_sound_commands       
L00069512           btst.l  #$0006,d7
L00069516           bne.b   L0006951c
L00069518           add.b   $0013(a4),d0
L0006951c           move.b  d0,$004f(a4)
L00069520           btst.l  #$0000,d7
L00069524           beq.b   L00069530
L00069526           add.b   $0021(a4),d0
L0006952a           move.b  $0022(a4),$0023(a4)
L00069530           move.b  d0,$0050(a4)
L00069534           ext.w   d0
L00069536           sub.w   $003c(a4),d0
L0006953a           add.w   d0,d0
L0006953c           cmp.w   #$ffd0,d0
L00069540           blt.b   L00069548
L00069542           cmp.w   #$002c,d0
L00069546           ble.b   L0006955e

L00069548           move.b  $004f(a4),d1
L0006954c           move.b  $0050(a4),d2
L00069550           move.w  $003c(a4),d3
L00069554           move.w  $0054(a4),d4
L00069558           movea.l $0006(a4),a2
L0006955c           illegal

L0006955e           move.w  $00(a5,d0.w),$004a(a4)
L00069564           btst.l  #$0002,d7
L00069568           beq.b   L000695c4 
L0006956a           move.b  $0050(a4),d0
L0006956e           add.b   $0034(a4),d0
L00069572           ext.w   d0
L00069574           sub.w   $003c(a4),d0
L00069578           add.w   d0,d0
L0006957a           cmp.w   #$ffd0,d0
L0006957e           blt.b   L00069586
L00069580           cmp.w   #$002c,d0
L00069584           ble.b   L0006959c 

L00069586           move.b  $004f(a4),d1
L0006958a           move.b  $0050(a4),d2
L0006958e           move.w  $003c(a4),d3
L00069592           move.w  $0054(a4),d4
L00069596           movea.l $0006(a4),a2
L0006959a           illegal

L0006959c           move.w  $00(a5,d0.w),d0
L000695a0           sub.w   $004a(a4),d0
L000695a4           asr.w   #$01,d0
L000695a6           ext.l   d0
L000695a8           move.b  $0035(a4),d1
L000695ac           ext.w   d1
L000695ae           divs.w  d1,d0
L000695b0           move.w  d0,$003a(a4)
L000695b4           move.b  d1,$0039(a4)

L000695b8           add.b   d1,d1
L000695ba           move.b  d1,$0038(a4)
L000695be           move.b  $0036(a4),$0037(a4)
L000695c4           btst.l  #$0003,d7
L000695c8           beq.b   L0006961a
L000695ca           move.b  $0050(a4),d0
L000695ce           add.b   $0024(a4),d0
L000695d2           ext.w   d0
L000695d4           sub.w   $003c(a4),d0
L000695d8           add.w   d0,d0
L000695da           cmp.w   #$ffd0,d0
L000695de           blt.b   L000695e6
L000695e0           cmp.w   #$002c,d0
L000695e4           ble.b   L000695fc

L000695e6           move.b  $004f(a4),d1
L000695ea           move.b  $0050(a4),d2
L000695ee           move.w  $003c(a4),d3
L000695f2           move.w  $0054(a4),d4
L000695f6           movea.l $0006(a4),a2
L000695fa           illegal


L000695fc           move.w  $00(a5,d0.w),d0
L00069600           sub.w   $004a(a4),d0
L00069604           ext.l   d0
L00069606           moveq   #$00,d1
L00069608           move.b  $0025(a4),d1
L0006960c           divs.w  d1,d0
L0006960e           move.w  d0,$0026(a4)
L00069612           neg.w   d0
L00069614           muls.w  d1,d0
L00069616           sub.w   d0,$004a(a4)
L0006961a           btst.l  #$0001,d7
L0006961e           beq.b   L00069632
L00069620           move.b  #$01,$0033(a4)
L00069626           move.l  $0028(a4),(a4,$002c)
L0006962c           move.b  $0030(a4),(a4,$0031)
L00069632           bset.l  #$0004,d7
L00069636           move.l  $0014(a4),$0018(a4)
L0006963c           move.w  #$0001,$001e(a4)
L00069642           clr.w   $004c(a4)
L00069646           move.w  $0054(a4),d0
L0006964a           or.w    d0,L000690fc

; jmp destination from 'pattern command 08 ($87)'
L00069650           moveq   #$00,d0
L00069652           move.b  $0051(a4),d0
L00069656           btst.l  #$0005,d7
L0006965a           bne.b   L0006965e
L0006965c           move.b  (a3)+,d0
L0006965e           add.w   d0,$0052(a4)
L00069662           move.l  a3,$000e(a4)

; jmp destination from 'process_command_loop' when $0052(s) is not $0000
L00069666           btst.l  #$0007,d7
L0006966a           bne.w   L00069804

L0006966e           move.w  $004a(a4),d0
L00069672           btst.l  #$0003,d7
L00069676           beq.b   L0006968a
L00069678           subq.b  #$01,$0025(a4)
L0006967c           bne.b   L00069682
L0006967e           bclr.l  #$0003,d7
L00069682           sub.w   $0026(a4),d0
L00069686           bra.w   L0006975c


L0006968a           btst.l  #$0000,d7
L0006968e           beq.b   L000696d6
L00069690           subq.b  #$01,$0023(a4)
L00069694           bcc.w   L0006975c
L00069698           move.b  $004f(a4),d0
L0006969c           move.b  $0050(a4),d1
L000696a0           move.b  d0,$0050(a4)
L000696a4           ext.w   d0
L000696a6           sub.w   $003c(a4),d0
L000696aa           add.w   d0,d0
L000696ac           cmp.w   #$ffd0,d0
L000696b0           blt.b   L000696b8
L000696b2           cmp.w   #$002c,d0
L000696b6           ble.b   L000696ce
L000696b8           move.b  $004f(a4),d1
L000696bc           move.b  $0050(a4),d2
L000696c0           move.w  $003c(a4),d3
L000696c4           move.w  $0054(a4),d4
L000696c8           movea.l $0006(a4),a2
L000696cc           illegal


L000696ce           move.w  $00(a5,d0.w),d0
L000696d2           bra.w   L0006975c
L000696d6           btst.l  #$0001,d7
L000696da           beq.b   L00069738
L000696dc           subq.b  #$01,$0033(a4)
L000696e0           bne.b   L0006975c
L000696e2           movea.l $002c(a4),a0
L000696e6           move.b  (a0)+,d0
L000696e8           subq.b  #$01,$0031(a4)
L000696ec           bne.b   L000696f8
L000696ee           movea.l $0028(a4),a0
L000696f2           move.b  $0030(a4),$0031(a4)
L000696f8           move.l  a0,$002c(a4)
L000696fc           move.b  $0032(a4),$0033(a4)
L00069702           add.b   $0050(a4),d0
L00069706           ext.w   d0
L00069708           sub.w   $003c(a4),d0
L0006970c           add.w   d0,d0
L0006970e           cmp.w   #$ffd0,d0
L00069712           blt.b   L0006971a
L00069714           cmp.w   #$002c,d0
L00069718           ble.b   L00069730
L0006971a           move.b  $004f(a4),d1
L0006971e           move.b  $0050(a4),d2
L00069722           move.w  $003c(a4),d3
L00069726           move.w  $0054(a4),d4
L0006972a           movea.l $0006(a4),a2
L0006972e           illegal


L00069730           move.w  $00(a5,d0.w),d0
L00069734           bra.w   L0006975c
L00069738           btst.l  #$0002,d7
L0006973c           beq.b   L0006975c
L0006973e           subq.b  #$01,$0037(a4)
L00069742           bcc.b   L0006975c
L00069744           addq.b  #$01,$0037(a4)
L00069748           subq.b  #$01,$0039(a4)
L0006974c           bne.b   L00069758
L0006974e           neg.w   $003a(a4)
L00069752           move.b  $0038(a4),$0039(a4)
L00069758           add.w   $003a(a4),d0
L0006975c           move.w  d0,$004a(a4)
L00069760           btst.l  #$0004,d7
L00069764           beq.w   L00069804
L00069768           subq.w  #$01,$001e(a4)
L0006976c           bne.w   L000697ee
L00069770           movea.l $0018(a4),a0
L00069774           moveq   #$00,d0
L00069776           move.b  (a0)+,d0
L00069778           beq.b   L000697bc
L0006977a           bmi.b   L00069796
L0006977c           move.w  d0,$001e(a4)
L00069780           move.b  #$01,$001c(a4)
L00069786           move.b  #$01,$001d(a4)
L0006978c           move.b  (a0)+,$0020(a4)
L00069790           move.l  a0,$0018(a4)
L00069794           bra.b   L000697ee
L00069796           neg.b   d0
L00069798           move.w  d0,$001e(a4)
L0006979c           move.b  #$01,$0020(a4)
L000697a2           move.b  (a0)+,d0
L000697a4           bpl.b   L000697ac
L000697a6           neg.b   d0
L000697a8           neg.b   $0020(a4)
L000697ac           move.b  d0,$001c(a4)
L000697b0           move.b  #$01,$001d(a4)
L000697b6           move.l  a0,$0018(a4)
L000697ba           bra.b   L000697ee
L000697bc           move.b  (a0),d0
L000697be           beq.b   L000697ca
L000697c0           bpl.b   L000697c4
L000697c2           neg.b   d0
L000697c4           sub.w   $0052(a4),d0
L000697c8           bmi.b   L000697d0
L000697ca           bclr.l  #$0004,d7
L000697ce           bra.b   L00069804
L000697d0           neg.w   d0
L000697d2           move.w  d0,$001e(a4)
L000697d6           move.b  #$00,$001c(a4)
L000697dc           move.b  #$00,$001d(a4)
L000697e2           move.b  #$00,$0020(a4)
L000697e8           move.l  a0,$0018(a4)
L000697ec           bra.b   L00069804
L000697ee           subq.b  #$01,$001d(a4)
L000697f2           bne.b   L00069804
L000697f4           move.b  $001c(a4),$001d(a4)
L000697fa           move.b  $0020(a4),d0
L000697fe           ext.w   d0
L00069800           add.w   d0,$004c(a4)
L00069804           rts     




update_audio_custom_registers
L00069806           move.w  L000690fc,d0
L0006980c           beq.b   L0006987c
L0006980e           move.w  d0,$0096(a6)
L00069812           move.w  d0,d1
L00069814           lsl.w   #$07,d1
L00069816           move.w  d1,$009c(a6)
L0006981a           moveq   #$00,d2
L0006981c           moveq   #$01,d3
L0006981e           btst.l  #$0000,d0
L00069822           beq.b   L0006982c
L00069824           move.w  d3,$00a6(a6)
L00069828           move.w  d2,$00aa(a6)
L0006982c           btst.l  #$0001,d0
L00069830           beq.b   L0006983a
L00069832           move.w  d3,$00b6(a6)
L00069836           move.w  d2,$00ba(a6)
L0006983a           btst.l  #$0002,d0
L0006983e           beq.b   L00069848
L00069840           move.w  d3,$00c6(a6)
L00069844           move.w  d2,$00ca(a6)
L00069848           btst.l  #$0003,d0
L0006984c           beq.b   L00069856
L0006984e           move.w  d3,$00d6(a6)
L00069852           move.w  d2,$00da(a6)
L00069856           move.w  $001e(a6),d2
L0006985a           and.w   d1,d2
L0006985c           cmp.w   d1,d2
L0006985e           bne.b   L00069856
L00069860           moveq   #$02,d2
L00069862           move.w  $0006(a6),d3
L00069866           and.w   #$ff00,d3
L0006986a           move.w  $0006(a6),d4
L0006986e           and.w   #$ff00,d4
L00069872           cmp.w   d4,d3
L00069874           beq.b   L0006986a
L00069876           move.w  d4,d3
L00069878           dbf.w   d2,L0006986a

L0006987c           move.w  L00068f9c,d1
L00069882           move.w  L00068f9e,d2
L00069888           lea.l   L00068fa4,a0
L0006988e           move.w  d1,d3
L00069890           btst.b  #$0006,(a0)
L00069894           beq.b   L00069898
L00069896           move.w  d2,d3
L00069898           and.w   $004c(a0),d3
L0006989c           move.w  d3,$00a8(a6) 
L000698a0           move.w  $004a(a0),$00a6(a6)
L000698a6           btst.l  #$0000,d0
L000698aa           beq.b   L000698ba
L000698ac           move.w  $0042(a0),$00a4(a6)
L000698b2           move.l  $003e(a0),$00a0(a6)
L000698b8           bra.b   L000698c6
L000698ba           move.w  $0048(a0),$00a4(a6)
L000698c0           move.l  $0044(a0),$00a0(a6)
L000698c6           lea.l   L00068ffa,a0
L000698cc           move.w  d1,d3
L000698ce           btst.b  #$0006,(a0)
L000698d2           beq.b   L000698d6
L000698d4           move.w  d2,d3
L000698d6           and.w   $004c(a0),d3
L000698da           move.w  d3,$00b8(a6)
L000698de           move.w  $004a(a0),$00b6(a6)
L000698e4           btst.l  #$0001,d0
L000698e8           beq.b   L000698f8
L000698ea           move.w  $0042(a0),$00b4(a6)
L000698f0           move.l  $003e(a0),$00b0(a6)
L000698f6           bra.b   L00069904
L000698f8           move.w  $0048(a0),$00b4(a6)
L000698fe           move.l  $0044(a0),$00b0(a6)
L00069904           lea.l   L00069050,a0
L0006990a           move.w  d1,d3
L0006990c           btst.b  #$0006,(a0)
L00069910           beq.b   L00069914
L00069912           move.w  d2,d3
L00069914           and.w   $004c(a0),d3
L00069918           move.w  d3,$00c8(a6)
L0006991c           move.w  $004a(a0),$00c6(a6)
L00069922           btst.l  #$0002,d0
L00069926           beq.b   L00069936
L00069928           move.w  $0042(a0),$00c4(a6)
L0006992e           move.l  $003e(a0),$00c0(a6)
L00069934           bra.b   L00069942
L00069936           move.w  $0048(a0),$00c4(a6)
L0006993c           move.l  $0044(a0),$00c0(a6)
L00069942           lea.l   L000690a6,a0
L00069948           move.w  d1,d3
L0006994a           btst.b  #$0006,(a0)
L0006994e           beq.b   L00069952
L00069950           move.w  d2,d3
L00069952           and.w   $004c(a0),d3
L00069956           move.w  d3,$00d8(a6)
L0006995a           move.w  $004a(a0),$00d6(a6)
L00069960           btst.l  #$0003,d0
L00069964           beq.b   L00069974
L00069966           move.w  $0042(a0),$00d4(a6)
L0006996c           move.l  $003e(a0),$00d0(a6)
L00069972           bra.b   L00069980
L00069974           move.w  $0048(a0),$00d4(a6)
L0006997a           move.l  $0044(a0),$00d0(a6)
L00069980           or.w    #$8000,d0
L00069984           move.w  d0,$0096(a6)
L00069988           clr.w   L000690fc
L0006998e           rts  


                ;------------------- initialise music samples --------------------
                ; extract sample data ptrs and lengths from the IFF sample
                ; data.
                ;
                ; IN: a0    - music sample table address $4D52 - default_sample_data
                ; IN: a1    - music/song instrument data $4BFA - instrument_data
                ;
L00069990           move.l  (a0)+,d0
L00069992           beq.b   L000699ae
L00069994           move.w  (a0)+,(a1) 
L00069996           move.w  (a0)+,$000e(a1)
L0006999a           move.l  a0,-(a7)
L0006999c           lea.l   -8(a0,d0.l),a0      ; $f8
L000699a0           move.l  $0004(a0),d0
L000699a4           addq.l  #$08,d0
L000699a6           bsr.w   L000699b0
L000699aa           movea.l (a7)+,a0
L000699ac           bra.b   L00069990
L000699ae           rts     


                ; ------------------ process instrument  ----------------
                ; IN: A0 = ptr to start of 'FORM' block of sample data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of sample including headers.
                ;
L000699b0           move.l  a1,-(a7)
L000699b2           bsr.w   L000699f4
L000699b6           movea.l (a7)+,a1
L000699b8           addq.l  #$02,a1
L000699ba           movea.l L00069b08,a0
L000699c0           move.l  (a0)+,d0
L000699c2           bclr.l  #$0000,d0
L000699c6           move.l  (a0)+,d1
L000699c8           bclr.l  #$0000,d1
L000699cc           movea.l L00069b30,a0
L000699d2           move.l  a0,(a1)+
L000699d4           adda.l  d0,a0
L000699d6           add.l   d1,d0
L000699d8           lsr.l   #$01,d0
L000699da           move.w  d0,(a1)+
L000699dc           tst.l   d1
L000699de           bne.b   L000699e8
L000699e0           lea.l   L00069d08,a0
L000699e6           moveq   #$02,d1
L000699e8           move.l  a0,(a1)+
L000699ea           lsr.l   #$01,d1
L000699ec           move.w  d1,(a1)+
L000699ee           addq.l  #$02,a1
L000699f0           rts  



; ************************************************************************************************************
; ************************************************************************************************************
; ************************************************************************************************************
;       START OF IFF '8SVX' FILE PROCESSING
; ************************************************************************************************************
; ************************************************************************************************************
; ************************************************************************************************************


                ;------------------ process sample data --------------------------
                ; Walks through the IFF 8SVX file format, storing the pointers to
                ; the BODY and VHDL chunks in the variables.
                ;
                ; Also, sets the error/status 'sample_status' - 0 = success
                ;
                ; IN: A0 = ptr to start of 'FORM' or 'CAT ' block of sample data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = remaining length of sample file including headers.
                ;
L000699f2           dc.w    $0000

L000699f4           clr.w   L000699f2
L000699fa           movem.l d0/a0,-(a7)
L000699fe           bra.w   L00069a02
L00069a02           tst.l   d0
L00069a04           beq.b   L00069a10
L00069a06           move.l  (a0)+,d1
L00069a08           subq.l  #$04,d0
L00069a0a           bsr.w   L00069a16
L00069a0e           bra.b   L00069a02
L00069a10           movem.l (a7)+,d0/a0
L00069a14           rts  


                ;------------------ process sample chunk ------------------
                ; process IFF sample data, top level of file structure.
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0.l = length of remaining data including length data.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
L00069a16           cmp.l   #'FORM',d1              ;#$464f524d,d1
L00069a1c           beq.w   L00069a74 
L00069a20           cmp.l   #'CAT ',d1              ;#$43415420,d1
L00069a26           beq.w   L00069a36
L00069a2a           move.w  #$0001,L000699f2
L00069a32           clr.l   d0
L00069a34           rts  



                ;--------------------- process CAT chunk --------------------------
                ; skips header and continues processing any further chunks 
                ; that are nested inside the CAT Chunk, data.
                ;
                ; IN: A0 = ptr to length of chunk data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0.l = length of remaining data including length data.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
L00069a36           movem.l d0/a0,-(a7)
L00069a3a           move.l  (a0)+,d0
L00069a3c           move.l  d0,d1
L00069a3e           btst.l  #$0000,d1
L00069a42           beq.b   L00069a46
L00069a44           addq.l  #$01,d1
L00069a46           addq.l  #$04,d1
L00069a48           add.l   d1,$0004(a7)
L00069a4c           sub.l   d1,(a7)
L00069a4e           addq.l  #$04,(a0)
L00069a50           subq.l  #$04,d0
L00069a52           bra.b   L00069a02


                ;------------------- process LIST chunk -----------------
                ; skip the list chunk, and continue processing
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0.l = length of remaining data.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
L00069a54           movem.l d0/a0,-(a7)
L00069a58           move.l  (a0)+,d0
L00069a5a           move.l  d0,d1
L00069a5c           btst.l  #$0000,d1
L00069a60           beq.b   L00069a64
L00069a62           addq.l  #$01,d1
L00069a64           addq.l  #$04,d1
L00069a66           add.l   d1,$0004(a7)
L00069a6a           sub.l   d1,(a7)
L00069a6c           nop
L00069a6e           movem.l (a7)+,d0/a0
L00069a72           rts  



                ;---------------- process FORM chunk ------------------
                ; Expects to find an '8SVX' inner chunk of data.
                ; If not, then sets error/status flag = $0002
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0.l = length of remaining data including length field.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
L00069a74           movem.l d0/a0,-(a7)
L00069a78           move.l  (a0)+,d0
L00069a7a           move.l  d0,d1
L00069a7c           btst.l  #$0000,d1
L00069a80           beq.b   L00069a84
L00069a82           addq.l  #$01,d1
L00069a84           addq.l  #$04,d1
L00069a86           add.l   d1,$0004(a7)
L00069a8a           sub.l   d1,(a7)
L00069a8c           move.l  (a0)+,d1
L00069a8e           subq.l  #$04,d0
L00069a90           cmp.l   #'8SVX',d1              ;#$38535658,d1
L00069a96           beq.w   L00069aa8
L00069a9a           move.w  #$0002,L000699f2
L00069aa2           movem.l (a7)+,d0/a0
L00069aa6           rts



                ;------------------ process 8SVX chunk ---------------------
                ; loops through sample data until no bytes remaining.
                ; processes inner chunks of 8SVX chunk, including:-
                ;  - VHDL, BODY, NAME, ANNO
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0.l = length of remaining data.
                ; IN: D1.l = chunk identifier, i.e '8SVX'
                ;
L00069aa8           tst.l   d0
L00069aaa           beq.b   L00069ab6
L00069aac           move.l  (a0)+,d1
L00069aae           subq.l  #$04,d0
L00069ab0           bsr.w   L00069abc
L00069ab4           bra.b   L00069aa8
L00069ab6           movem.l (a7)+,d0/a0
L00069aba           rts  


                ;---------------- process inner 8SVX chunk --------------
                ; process data held inside the 8SVX chunk, this is only
                ; concerned with the VHDR and BODY chunks. it skips
                ; other chunks such as the NAME, ANNO meta data chunks.
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of remaining data.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
L00069abc           cmp.l   #'FORM',d1          ;#$464f524d,d1
L00069ac2           beq.b   L00069a74 
L00069ac4           cmp.l   #'LIST',d1          ;#$4c495354,d1
L00069aca           beq.b   L00069a54
L00069acc           cmp.l   #'CAT ',d1          ;#$43415420,d1
L00069ad2           beq.w   L00069a36 
L00069ad6           cmp.l   #'VHDR',d1          ;#$56484452,d1
L00069adc           beq.w   L00069b0c 
L00069ae0           cmp.l   #'BODY',d1          ;#$424f4459,d1
L00069ae6           beq.w   L00069b34
L00069aea           movem.l d0/a0,-(a7)
L00069aee           move.l  (a0)+,d0
L00069af0           move.l  d0,d1
L00069af2           btst.l  #$0000,d1
L00069af6           beq.b   L00069afa
L00069af8           addq.l  #$01,d1
L00069afa           addq.l  #$04,d1
L00069afc           add.l   d1,$0004(a7)
L00069b00           sub.l   d1,(a7)
L00069b02           movem.l (a7)+,d0/a0
L00069b06           rts  



                ;-------------------- process VHDR chunk ----------------------
                ; stores address of VHDR chunk in variable 'sample_vhdr_ptr'
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of remaining data.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
L00069b08           dc.l    $00000000

L00069b0c           movem.l d0/a0,-(a7)
L00069b10           move.l  (a0)+,d0
L00069b12           move.l  d0,d1
L00069b14           btst.l  #$0000,d1
L00069b18           beq.b   L00069b1c
L00069b1a           addq.l  #$01,d1
L00069b1c           addq.l  #$04,d1
L00069b1e           add.l   d1,$0004(a7)
L00069b22           sub.l   d1,(a7)
L00069b24           move.l  a0,L00069b08
L00069b2a           movem.l (a7)+,d0/a0
L00069b2e           rts  



                ;------------------------- process body chunk ------------------------
                ; store address of the raw sample data in variable 'sample_body_ptr'
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of remaining data.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
L00069b30           dc.L    $00000000

L00069b34           movem.l d0/a0,-(a7)
L00069b38           move.l  (a0)+,d0
L00069b3a           move.l  d0,d1
L00069b3c           btst.l  #$0000,d1
L00069b40           beq.b   L00069b44
L00069b42           addq.l  #$01,d1
L00069b44           addq.l  #$04,d1
L00069b46           add.l   d1,$0004(a7)
L00069b4a           sub.l   d1,(a7)
L00069b4c           move.l  a0,L00069b30
L00069b52           movem.l (a7)+,d0/a0
L00069b56           rts  



; ************************************************************************************************************
; ************************************************************************************************************
; ************************************************************************************************************
;       END OF IFF '8SVX' FILE PROCESSING
; ************************************************************************************************************
; ************************************************************************************************************
; ************************************************************************************************************



                ; --------------------- Note Period Table ------------------------
                ;       - audio channel period values - note frequenies
                ;       - indexes to $00004bba clamped to -48 bytes or +44 bytes to remain in table range
                ;       - I've got the table running B to B (may be I'm a semi-tone out C to C - most likely) 
note_period_table      
L00069B58       dc.w    $06FE,$0699,$063B,$05E1,$058D,$053D,$04F2,$04AB     ;.....;.....=....
L00069B68       dc.w    $0467,$0428,$03EC,$03B4,$037F,$034D,$031D,$02F1     ;.g.(.......M....
L00069B78       dc.w    $02C6,$029E,$0279,$0255,$0234,$0214,$01F6,$01DA     ;.....y.U.4......

L00069B88       dc.w    $01BF,$01A6,$018F,$0178,$0163,$014F,$013C,$012B     ;.......x.c.O.<.+
L00069B98       dc.w    $011A,$010A,$00FB,$00ED,$00E0,$00D3,$00C7,$00BC     ;................
L00069BA8       dc.w    $00B2,$00A8,$009E,$0095,$008D,$0085,$007E,$0077     ;.............~.w


command_17_data
L00069BB8       dc.w    $0021,$0006,$9D0A,$000B,$0006,$9D0A,$000B,$0000     ;.!..............

instrument_data
L00069BC8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069BD8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069BE8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069BF8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069C08       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069C18       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069C28       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069C38       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069C48       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069C58       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069C68       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069C78       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069C88       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069C98       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069CA8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069CB8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069CC8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069CD8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069CE8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069CF8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................

silient_repeat
L00069D08       dc.w    $0000 

L00069D0A       dc.w    $0074,$60DC,$82BB,$457E,$24A0,$8C00,$7460           ;...t`...E~$...t`
L00069D18       dc.w    $DC82,$BB45,$7E24,$A08C 


                ; ------ music sample data table (12 sample offsets & 2 word params) ------
                ; 12 sound samples in IFF 8SVX format.
                ; Table of address offsets below, not sure what the additional two 16 bit 
                ; parameters that follow the offset represent yet. maybe volume and something else.
                ;
raw_sample_data_table
.data_01        dc.l    sample_file_01-.data_01                 ; $00069DBC - $00069D20 = $00000009C
                dc.w    $0030,$0000 
L00069D28       dc.l    sample_file_02-.data_02                 ; $0006C1D0 - $00069D28 = $000024A8
                dc.w    $0032,$0000
                dc.l    sample_file_03-.data_03                 ; $0006D38E - $00069D30 = $0000365E
                dc.w    $000C,$FFFF 
L00069D38       dc.l    sample_file_04-.data_04                 ; $0006E7FA - $00069D38 = $00004AC2
                dc.w    $0018,$FFFF
                dc.l    sample_file_05-.data_05                 ; $0006FCB2 - $00069D40 = $00005F72
                dc.w    $0021,$0000 
L00069D48       dc.l    sample_file_06-.data_06                 ; $000708AC - $00069D48 = $00006B64
                dc.w    $002D,$0000
                dc.l    sample_file_07-.data_07                 ; $00071C7A - $00069D50 = $00007F2A
                dc.w    $0035,$FFFF 
L00069D58       dc.l    sample_file_08-.data_08                 ; $00071F38 - $00069D58 = $000081E0
                dc.w    $0037,$FFFF
                dc.l    sample_file_09-.data_09                 ; $00072B3E - $00069D60 = $00008DDE
                dc.w    $0018,$0000 
L00069D68       dc.l    sample_file_10-.data_10                 ; $00073C9A - $00069D68 = $00009F32
                dc.w    $0018,$0000
                dc.l    sample_file_11-.data_11                 ; $00075E04 - $00069D70 = $0000C094
                dc.w    $0018,$0000 
L00069D78       dc.l    sample_file_12-.data_12                 ;  - $00069D78 = $0000C7EA
                dc.w    $0018,$0000
                dc.l    sample_file_13-.data_13                 ;  - $00069D80 = $0000D0F2
                dc.w    $0018,$0000 
L00069D88       dc.l    sample_file_14-.data_14                 ;  - $00069D88 = $0000DF42
                dc.w    $0018,$0000
                dc.l    sample_file_15-.data_15                 ;  - $00069D90 = $0000E480
                dc.w    $0018,$0000 
L00069D98       dc.l    sample_file_16-.data_16                 ;  - $00069D98 = $0000F0CA
                dc.w    $0018,$0000
                dc.l    sample_file_17-.data_17                 ;  - $00069DA0 = $000109E8
                dc.w    $0018,$0000 
L00069DA8       dc.l    sample_file_18-.data_18                 ;  - $00069DA8 = $00011364
                dc.w    $0018,$0000
                dc.l    sample_file_19-.data_19                 ;  - $00069DB0 = $00011CEE
                dc.w    $0018,$0000 
L00069DB8       dc.w    $0000,$0000 


; Sample 01
sample_file_01

                ; --------------------- Sound Sample 1 -------------------
                ; Start Address: $00069DBC
                ; Name:          CRUNCHGUITAR-C4
                include "./music/sample_file_01.s"


; Sample 02
sample_file_02
                ; --------------------- Sound Sample 2 -------------------
                ; Start Address: $0006C1D0
                ; Name:          ORCH-HIT-EMAX-D4
                include "./music/sample_file_02.s"


; Sample 03
sample_file_03
                ; --------------------- Sound Sample 3 -------------------
                ; Start Address: $0006D38E
                ; Name:          HITBASS-C1
                include "./music/sample_file_03.s"



; Sample 04
sample_file_04
                ; --------------------- Sound Sample 4 -------------------
                ; Start Address: $0006E7FA
                ; Name:          HITSNARE-C2
                include "./music/sample_file_04.s"


; Sample 05
sample_file_05
                ; --------------------- Sound Sample 5 -------------------
                ; Start Address: $0006FCB2
                ; Name:          CRUNCHBASS-A2
                include "./music/sample_file_05.s"



; Sample 06
sample_file_06
                ; --------------------- Sound Sample 6 -------------------
                ; Start Address: $000708AC
                ; Name:         TIMELESS-A4     
                include "./music/sample_file_06.s"



; Sample 07
sample_file_07
                ; --------------------- Sound Sample 7 -------------------
                ; Start Address: $00071C7A
                ; Name:          KIT-HIHAT-C4
                include "./music/sample_file_07.s"


; Sample 08
sample_file_08
                ; --------------------- Sound Sample 8 -------------------
                ; Start Address: $00071F38
                ; Name:          KIT-OPENHAT-D4         
                include "./music/sample_file_08.s"


; Sample 09
sample_file_09
                ; --------------------- Sound Sample 9 -------------------
                ; Start Address: $00072B3E
                ; Name:         BATMOBILE.......       
                include "./music/sample_file_09.s"


; Sample 10
sample_file_10
                ; --------------------- Sound Sample 10 -------------------
                ; Start Address: $00073C9A
                ; Name:          SKID2
                include "./music/sample_file_10.s"


; Sample 11
sample_file_11
                ; --------------------- Sound Sample 11 -------------------
                ; Start Address: $00075E04
                ; Name:          HITCAR
                include "./music/sample_file_11.s"

; Sample 12
sample_file_12
                ; --------------------- Sound Sample 12 -------------------
                ; Start Address: $00076562
                ; Name:          BATARANG
                include "./music/sample_file_12.s"


; Sample 13
sample_file_13
                ; --------------------- Sound Sample 13 -------------------
                ; Start Address: $00076E72
                ; Name:          CATCHPOLE
                include "./music/sample_file_13.s"


; Sample 14
sample_file_14
                ; --------------------- Sound Sample 14 -------------------
                ; Start Address: $00077CCA
                ; Name:          CARLANDS
                include "./music/sample_file_14.s"


; Sample 15
sample_file_15
                ; --------------------- Sound Sample 15 -------------------
                ; Start Address: $00078210
                ; Name:          EXPLOSION
                include "./music/sample_file_15.s"



; sample 16 - BATWING
>m78E62
00078E62 464F 524D 0000 191E 3853 5658 5648 4452  FORM....8SVXVHDR
00078E72 0000 0014 0000 0064 0000 185A 0000 0020  .......d...Z...
00078E82 22C8 0100 0001 0000 4E41 4D45 0000 0014  ".......NAME....
00078E92 4241 5457 494E 4700 0000 0000 0000 0000  BATWING.........
00078EA2 0000 0000 414E 4E4F 0000 0014 4175 6469  ....ANNO....Audi
00078EB2 6F20 4D61 7374 6572 2049 4900 0000 0000  o Master II.....
00078EC2 424F 4459 0000 18BE 06FC EFE0 DEDD D6CA  BODY............
00078ED2 B9AA A4B8 CBDE F100 FF01 0005 1C2F 475B  ............./G[
00078EE2 6970 705A 3510 F1D3 B9A4 9A94 9AAA BAC8  ippZ5...........
00078EF2 D9E0 DBD8 D2CC CBD3 E2F5 0611 1319 1614  ................
00078F02 2738 4F64 6F73 7360 4C38 2107 F0DF CECB  '8Odoss`L8!.....
00078F12 D7EB 0017 2838 3D38 2E16 FCEB DFD7 D6E2  ....(8=8........
00078F22 EEFD 0D1B 1F24 2417 0B08 FCF9 FCFF 040A  .....$$.........
00078F32 0F12 181C 2527 1E13 0A05 03FD F5F1 FB07  ....%'..........
00078F42 1013 0E0E 0A00 EAD3 BBA0 8981 8181 8181  ................
00078F52 8181 8090 BEF6 1F43 5F70 7B7C 7265 5645  .......C_p{|reVE
00078F62 3B2E 2220 2A38 4959 6164 5E4E 2D0C E9C6  ;." *8IYad^N-...
00078F72 AB90 8281 8181 828F AFD3 F71F 455B 676B  ............E[gk
00078F82 5C40 250C FDF0 EAEB F2FD 0A20 3149 575A  \@%........ 1IWZ
00078F92 4A32 0EE5 C3B1 A8AE C0D4 E1F0 F7FC F9F3  J2..............
00078FA2 F502 121F 2E30 2D29 1E0E F7DC C7B2 A28F  .....0-)........
00078FB2 8481 8DA2 BCCE DEF7 1531 4B68 6F7B 7F7F  .........1Kho{..
00078FC2 7F7F 7F67 472C 1203 F9F8 F6F6 FDF8 F3E2  ...gG,..........
00078FD2 CCAC 8E81 8181 8181 8AAD DD10 4058 6B6F  ............@Xko
00078FE2 6D65 5D54 5249 4737 260B F0D1 B5A1 8E84  me]TRIG7&.......
00078FF2 828B 9CB0 C4DB EDFB 03FF F8F0 E2D1 CBD5  ................
00079002 E4FB 1C41 687E 7F7F 7F7F 7F72 4211 E8CB  ...Ah~.....rB...
00079012 C3E2 FF22 4252 4E3A 10E0 AF87 8081 8180  ..."BRN:........
00079022 8181 8498 B2D3 F71E 3E4C 4C51 4D48 3D33  ........>LLQMH=3
00079032 2E32 3427 12F1 D8C3 BAB2 AFB7 BDCE D8DF  .24'............
00079042 E3E3 F815 364D 5C5D 4F41 2A13 0505 0809  ....6M\]OA*.....
00079052 0607 02F3 E2C9 B6AC A69E 9B9C A2AF BEC9  ................
00079062 D6E0 EBF7 1331 4F64 777F 7F7F 7F7F 7F7F  .....1Odw.......
00079072 7E68 4A27 09F2 E1D7 CDCA C6C0 B7A7 9384  ~hJ'............
00079082 8181 8181 849A C0E7 FF08 00F5 E6DE DAD7  ................
00079092 E611 4A75 7E7F 7F7F 7F7F 774E 1DF1 CDB7  ..Ju~.....wN....
000790A2 A9AC B5BC CEE7 072C 4245 361E 0AEE D3C3  .......,BE6.....
000790B2 BFBE C1D3 E3F3 0B1F 2923 1B19 273E 5866  ........)#..'>Xf
000790C2 7072 6144 18EE D2B8 ABA5 B5C3 D4DF E2E1  praD............
000790D2 E8ED FB0C 1209 06ED DDC6 BFB9 B5AA A8B1  ................
000790E2 C2D4 E6FE 172F 3C47 4536 2103 F0EE 0822  ...../<GE6!...."
000790F2 3736 3D31 1405 F9E5 C6C5 CBEC 1436 5B7B  76=1.........6[{
00079102 7F7F 7F6F 3603 D0B3 ACA6 ADB6 C0C6 C0C1  ...o6...........
00079112 CAD8 DBDA DCED F7FF 070C 1216 05EA D7CA  ................
00079122 BFBC C4D7 F20D 334F 606F 7477 6348 2A0E  ......3O`otwcH*.
00079132 FCE8 E1DE EEF6 F5FF 0F24 2312 FDE5 D9CD  .........$#.....
00079142 BEAA 9994 98B5 CCD8 E3F4 123C 535D 5252  ...........<S]RR
00079152 4F4F 4946 453B 3127 14F8 EADE CBBF BEC0  OOIFE;1'........
00079162 C4D6 E4D7 D3D6 D5CC B9A8 A39D 9796 A9BA  ................
00079172 D604 416F 7F7F 7F7F 7F7F 7F7F 7E59 26FA  ..Ao........~Y&.
00079182 DDCF CACF DBD6 D6D9 DADA DBEF 0724 333F  .............$3?
00079192 3928 11F6 DBC2 A595 9293 9CB0 C6DA FE28  9(.............(
000791A2 3A30 2D27 2119 1E15 0706 0C05 FD00 EBDB  :0-'!...........
000791B2 DBCF C2C7 DAF8 1D44 5C65 502F 1105 F2D2  .......D\eP/....
000791C2 BDA4 8D81 8281 83A2 CD00 3567 7E7F 7F7F  ..........5g~...
000791D2 7F7F 7F7D 5A31 03D6 B28B 8081 8081 839A  ...}Z1..........
000791E2 C3EB 173B 5065 7072 756E 5C47 1EEB BA93  ...;Peprun\G....
000791F2 8281 8181 97D1 0836 5D6A 6E70 6B61 604C  .......6]jnpka`L
00079202 2A0E F2D2 C4B5 ADAC AE9F 9EAD BFDB 0225  *..............%
00079212 4962 787E 7665 4C21 F1DA BDA5 A9B3 C0D5  Ibx~veL!........
00079222 F40F 273C 4F54 5143 3835 3224 0CF2 DBD9  ..'<OTQC852$....
00079232 C8B8 9F98 8F8A 8382 8A99 B2C7 E20B 355B  ..............5[
00079242 787F 7F7F 7F7F 7358 4035 14F7 DABE A9A8  x.....sX@5......
00079252 AFB2 C4CF D7D7 D5D0 BEA2 8B81 8181 8BB7  ................
00079262 DC01 305C 7A7F 7F7F 7F7F 7F7B 6245 23FE  ..0\z......{bE#.
00079272 E5DA D9DD D6D3 C4AF 9B8F 8481 828D A1BF  ................
00079282 DBF4 0B25 3A4A 5B65 6462 4A31 2315 0805  ...%:J[edbJ1#...
00079292 1421 2323 1908 F6EA DFD9 D2CC D0D7 DEE4  .!##............
000792A2 F000 0815 171E 2327 2D27 2F34 3F39 3231  ......#'-'/4?921
000792B2 2D2C 241D 2022 1D11 02ED D6C4 AD9A 9396  -,$. "..........
000792C2 A3BC DE0C 4B75 7E7F 7F70 4D21 EAB4 8D81  ....Ku~..pM!....
000792D2 8082 93B0 D1FA 1831 3529 1DFC DAC9 C4C7  .......15)......
000792E2 D4DF E1E7 ECF6 0200 F9EB DCD6 D0CE E000  ................
000792F2 1933 3D3F 3B3C 4347 453A 270E F8DA C2AF  .3=?;<CGE:'.....
00079302 ACBE E916 344E 5758 4E4F 442D 0CF5 DDCE  ....4NWXNOD-....
00079312 BBB3 AAA2 A9B9 D50A 4064 7F7F 7F7D 5F27  ........@d...}_'
00079322 03DA B19D 8F8C 8381 8181 8EA5 B3C1 CACD  ................
00079332 C8C4 C5DD 0129 4E64 6456 3C28 15FF FBFC  .....)NddV<(....
00079342 051F 4B78 7F7F 7F7F 7F7F 794F 1BE6 BDA8  ..Kx......yO....
00079352 9691 A2AC C0D2 D1C5 AF99 8581 818B ABD1  ................
00079362 001A 292A 3348 6068 7C72 644B 311F 1211  ..)*3H`h|rdK1...
00079372 1808 FAF1 ECE6 ECF6 051C 2722 1301 F2EC  ..........'"....
00079382 EAEA EAD8 CFC5 C1BF CAD0 D8DB EBF9 0B1F  ................
00079392 394A 5C54 4124 120D FEF1 F3EC E1D1 C2AF  9J\TA$..........
000793A2 A3A4 A8AB ABB0 BCC6 DAFB 2240 6A7C 7F7F  .........."@j|..
000793B2 7F7D 6F5E 5141 2F0F EDD7 C1B3 AAA1 9EA4  .}o^QA/.........
000793C2 A7B6 CAD9 EBFC 0A12 1D2A 2C43 5465 6E69  .........*,CTeni
000793D2 5535 11EF CFB8 A8A4 A9B4 C5E9 0A1D 302C  U5............0,
000793E2 2505 E5C3 A79D 9EAF D001 243A 4750 5258  %.........$:GPRX
000793F2 5A5A 676E 6D64 4D2C 0DE7 C79D 8581 8181  ZZgnmdM,........
00079402 8180 92AD CAE1 EAEA E5DA CFCF E109 2F58  ............../X
00079412 757E 7F70 563B 19F8 E9E6 E2EB F9F0 F201  u~.pV;..........
00079422 05FF 0816 202D 3E42 4E59 5451 4739 1B07  .... ->BNYTQG9..
00079432 F4DF DADE E0D8 E3EC EEE9 DDCF BEAC 9D97  ................
00079442 A9C9 EC13 2B2A 2915 FEEB DDDA E2EC FE0F  ....+*).........
00079452 2343 6071 7E7F 765E 3605 CF9B 8481 8181  #C`q~.v^6.......
00079462 8099 DD1A 4E6B 6243 0CCA 9080 8080 8181  ....NkbC........
00079472 8185 C021 617F 7F7F 7F7F 7F76 624A 3C3C  ...!a......vbJ<<
00079482 3B39 3932 2415 07F4 DAC4 B5A8 A3AF C2D3  ;992$...........
00079492 E6ED EDF4 FAED D9C2 A98D 8281 8198 CC08  ................
000794A2 426F 7E7F 7F7F 7F7D 6024 E9C1 A59F B0C5  Bo~....}`$......
000794B2 E0F6 0715 1A1E 2125 2932 3C43 443E 250D  ......!%)2<CD>%.
000794C2 FCE4 CCB3 A296 9698 A2AE C3E6 0B37 576A  .............7Wj
000794D2 7D7F 7D6F 562C 0BEA C9AD A099 9BA9 B9CF  }.}oV,..........
000794E2 E709 1F2D 3027 1C0C 00FC F0F3 FF0A 08FF  ...-0'..........
000794F2 EEDD D5D0 CECA D5E1 EDFB 010E 203C 576C  ............ <Wl
00079502 7A7F 7D69 5431 0CF2 DAC1 BEC0 D0D6 E7FA  z.}iT1..........
00079512 00FA F9FB 0510 1122 201B 14FB E4C9 AC92  ......." .......
00079522 8281 8181 8180 889F BCDC FF2A 5478 7F7F  ...........*Tx..
00079532 7F7C 6340 14F3 E4DE D7D8 DAD5 C9BA AD9F  .|c@............
00079542 9B9E 9FA3 B3C7 E508 3262 7D7F 7F7F 7F73  ........2b}....s
00079552 5A45 3626 1A1D 232E 3838 3A30 271F 0BF3  ZE6&..#.88:0'...
00079562 D3B6 9F8F 8884 879F BDE0 0A30 536C 787B  ...........0Slx{
00079572 684B 2C02 E0BC 9B8D 888E A4CA EB10 2C39  hK,...........,9
00079582 3E40 3529 11F8 E7D7 C9BD BDC6 DEFB 1227  >@5)...........'
00079592 3130 2826 1C0B FFF3 DFCE CBC9 C8D6 E7F6  10(&............
000795A2 040C 0F14 2232 4152 636E 7A7F 7D6B 4F26  ...."2ARcnz.}kO&
000795B2 F9CF A993 8695 B3D2 0537 5B6F 7270 675C  .........7[orpg\
000795C2 4422 FFDC BA9F 8D87 8C99 A8AF A59C 8F82  D"..............
000795D2 8181 8188 B2ED 2E6B 7E7F 7C64 3504 D4AE  .......k~.|d5...
000795E2 9790 8C91 A5C9 F837 667B 7F7F 7F78 5A3B  .......7f{...xZ;
000795F2 2E29 2830 3A3D 3E33 1B0A 01F5 F2F0 E9F2  .)(0:=>3........
00079602 0508 0607 F3DE D8C7 BCBA C0C2 C8C3 BBB9  ................
00079612 C6DA ED02 0A15 273A 4A57 5E5C 4D3A 20FD  ......':JW^\M: .
00079622 E2CC C1B6 B6C3 CCD5 E6ED F003 0907 0F1A  ................
00079632 1B21 2A2B 2828 1F0D 0000 F1E6 E2D4 C0BB  .!*+((..........
00079642 B7A9 B0C3 D4E9 FA00 FFF2 E5E5 E4F3 0B33  ...............3
00079652 5B70 7E7A 613C 13E3 B69E 999C B6D0 E4FD  [p~za<..........
00079662 2138 4755 5952 4F47 361F 0EFF F4ED E4DA  !8GUYROG6.......
00079672 E3E9 ED02 07FE F4E0 C1A9 9787 838D 99BA  ................
00079682 DF0F 415A 6E7B 756E 654E 423B 3230 2F21  ..AZn{uneNB;20/!
00079692 222D 251E 1F0A 040D 04FC F7F7 F8F2 E8D2  "-%.............
000796A2 BCB1 B2BD CCE4 F8FC F6EE DBCF CACB CACF  ................
000796B2 D9E6 F2F6 FF0B 1E2C 3F51 626E 7770 5635  .......,?QbnwpV5
000796C2 15F9 E8DC D3D4 D4DA DEE0 E3E7 E4E4 E5E0  ................
000796D2 E1ED FC0B 243B 494A 4030 16F8 E0D0 C6CD  ....$;IJ@0......
000796E2 D4DC EDE6 DFDD DAD1 CFD1 DEED F7FC FEFE  ................
000796F2 FF04 0203 0B11 1B36 5775 7E7F 7E69 491C  .......6Wu~.~iI.
00079702 F0CA B2AD B3C0 C6D0 D1CB C8C8 CFE3 FE0B  ................
00079712 0C0B 03EE DBC6 ACA1 A9C3 E313 436A 7C78  ............Cj|x
00079722 6745 1DFB DACA CCDB F00C 2336 4A58 5A54  gE........#6JXZT
00079732 432F 2010 F6E1 DDDB EA02 1B2E 3E49 4B48  C/ .........>IKH
00079742 2E11 F2D7 BFAE A3A1 AFC3 CDD3 E900 101C  ................
00079752 2528 2927 2107 ECDC BFA5 9184 8181 8081  %()'!...........
00079762 8593 ABC9 E9FC 1326 3549 5565 787F 7F7F  .......&5IUex...
00079772 765E 3D1C FFEC DBDB EF0A 1C26 2C38 4454  v^=........&,8DT
00079782 5B5C 6265 6B63 4726 FFD6 B291 8181 8181  [\bekcG&........
00079792 8081 8182 8EA1 B3D0 F211 1D1B 1915 1204  ................
000797A2 0109 1B27 2A2A 261D 1918 1E27 312F 271D  ...'**&....'1/'.
000797B2 0DF4 D9C9 BFBC C1CF E2E2 E8EF F80B 222B  .............."+
000797C2 2C2A 2623 1F15 0B03 0204 090C 0C06 FDF0  ,*&#............
000797D2 E0D9 DBD5 D3D3 D3DC ECF5 FD08 1A2E 3A40  ..............:@
000797E2 464D 463D 3111 FBF6 ECE6 DAD3 C8C5 CCDC  FMF=1...........
000797F2 F10C 2E62 7B7F 7F7F 7E6B 4C2B 0BF5 E1D2  ...b{...~kL+....
00079802 C9C8 CAD8 EAF4 F8F6 EFE5 DDCA AD9E 938B  ................
00079812 8BA0 B0BF CDDD EC00 010F 1C14 0E06 F6E4  ................
00079822 DAD1 CDD4 E4FF 132D 4968 7A7F 7766 513B  .......-Ihz.wfQ;
00079832 2107 F9F1 EEF9 08FE ECE0 D3C7 BBB6 B5B9  !...............
00079842 C8DB F004 0407 1004 0012 1D2A 3C39 220A  ...........*<9".
00079852 FCEB E7F0 F0F2 010A 0F22 2A23 160A F7EA  ........."*#....
00079862 DFD5 CFCE CED7 D7D9 DEEC 0021 4E6C 7B7F  ...........!Nl{.
00079872 7E68 4929 05ED E1DC D1C8 C4C1 C0CF DAE1  ~hI)............
00079882 EF04 1E38 444D 5958 4C40 2915 08FE E9D8  ...8DMYXL@).....
00079892 C1A3 8F85 8181 8498 B6DC 0D48 6D7D 7F7F  ...........Hm}..
000798A2 7F7F 7E68 4620 F9D5 B49B 8681 8180 8184  ..~hF ..........
000798B2 A2CC F416 2328 3E4D 5966 5944 2E1E FDEF  ....#(>MYfYD....
000798C2 E5D7 CECD BFA3 9488 8281 8182 818D A5C4  ................
000798D2 F32A 677E 7F7F 7F7F 7F7F 6E56 433B 290C  .*g~......nVC;).
000798E2 F8DD BEA3 8B82 8184 9ED0 062D 4458 574F  ...........-DXWO
000798F2 5161 6D77 746A 5231 14F9 DBCF B69E 8D82  QamwtjR1........
00079902 8181 8182 95B0 C9E7 FB07 1C2D 3642 5050  ...........-6BPP
00079912 4F4C 4436 2724 2320 283B 4855 595C 5644  OLD6'$# (;HUY\VD
00079922 2615 F7E2 CCBF AF9F 9897 8782 828C A1C1  &...............
00079932 E603 1D32 464E 3E2F 1906 FBFB F4F9 0104  ...2FN>/........
00079942 0B15 05FC F1E4 D4CE C2C6 CDE9 011A 2B32  ..............+2
00079952 241B 1007 F8F1 F2F7 0223 3647 4D4A 452F  $........#6GMJE/
00079962 1906 FFFD 101E 1914 09F5 F6F8 EDFF 0B06  ................
00079972 0E0E FFFA F9F7 0A16 140D 01F3 ECE4 D8D4  ................
00079982 D7E7 FD10 2428 211E 1F18 0F03 F7E6 D8C0  ....$(!.........
00079992 AD99 8D87 949E A1A1 AAAE ACB9 C1CE E0EB  ................
000799A2 FB05 1C30 465F 777E 7F7D 7466 6055 5543  ...0F_w~.}tf`UUC
000799B2 3B31 2419 12FC E1CF BFB0 AEB9 C0E2 FF0A  ;1$.............
000799C2 2342 4652 696B 5037 1AF5 D1B8 9D86 8081  #BFRikP7........
000799D2 8181 8DA7 CFF3 1E46 5A5C 4F37 16F5 DFD8  .......FZ\O7....
000799E2 CEC6 CEDC EE08 2C4C 6B7D 7F7F 7F7F 7862  ......,Lk}....xb
000799F2 4326 1D0B F5F7 EEDC CABB 9F8D 888A 94A4  C&..............
00079A02 B9CF D3E5 E7E3 DCDB CFC4 BEAC 9786 8697  ................
00079A12 C1FA 2E62 7D7F 7F7F 7F7F 7F7F 7F70 440F  ...b}........pD.
00079A22 EACD B6B0 AFB5 B7C8 D1DD EAF3 F8FF 0510  ................
00079A32 1921 1E20 1A16 1206 02F4 F4EE E0D7 CAC5  .!. ............
00079A42 C3C7 D4E3 ECFD 0C03 0505 01FA 000D 111C  ................
00079A52 3948 4A55 523F 2A11 F7D9 C2B1 A39C 9E8F  9HJUR?*.........
00079A62 8781 8181 8DAD D3EF 1228 3444 4946 4947  .........(4DIFIG
00079A72 454F 4C43 4F4E 4A55 524C 5B50 382A 08EF  EOLCONJURL[P8*..
00079A82 E0D8 C8D3 D9E2 E9EA E4E7 DBD5 C2B6 BFC8  ................
00079A92 D5E5 EF01 090D 1316 0B16 293D 4D66 6355  ..........)=MfcU
00079AA2 4829 10FE E8E3 E1D7 D4D1 CBD1 D3E7 FD13  H)..............
00079AB2 151D 1912 0E14 0F0C 1321 2A34 3330 2A27  .........!*430*'
00079AC2 1B03 ECDD D5DB E0ED F7FE 050A 0A0E 03E7  ................
00079AD2 D0BC 9B86 8181 89A6 CAF5 0C20 3738 2C26  ........... 78,&
00079AE2 1703 F1E6 D7C9 C7D4 F21C 496D 7677 7661  ..........Imvwva
00079AF2 4426 FED7 C2B2 A59C 9EA7 B6CE EE13 2C4C  D&............,L
00079B02 6979 7F7F 7F7A 612D FAC8 9780 8181 8081  iy...za-........
00079B12 8492 9CA8 B5BB BFD4 EE05 2741 5B77 7F7F  ..........'A[w..
00079B22 7F7F 7C64 4519 F7D4 B6AD A9B8 C8DD F611  ..|dE...........
00079B32 2129 2D2E 333D 4640 4E54 5342 2705 E5CB  !)-.3=F@NTSB'...
00079B42 BEB1 B3C0 D4EC FB00 0705 FDEC D7BF ADA0  ................
00079B52 9D9F B7CE DAE4 E7DF D4D1 D5E8 0F40 717E  .............@q~
00079B62 7F7F 7F7F 7B60 2FF6 CBB1 A096 949C A4A8  ....{`/.........
00079B72 B1C0 D0EB 0424 3B48 4C50 5B5D 5452 504E  .....$;HLP[]TRPN
00079B82 4135 1B0C 04F4 EEED DAD0 C6B4 A8A2 A6B1  A5..............
00079B92 B9C2 D9E7 E6F4 060E 1C35 424E 4E48 371B  .........5BNNH7.
00079BA2 F9DB CECB D0EC 0324 414C 4C40 3320 1817  .......$ALL@3 ..
00079BB2 100A 03F9 EAE0 D7C4 BAAA A39E 9999 9B98  ................
00079BC2 99AB BFD9 0123 435A 6869 6C52 3721 03F3  .....#CZhilR7!..
00079BD2 F2F4 FE0E 181D 1D1C 1310 03F9 F4E7 E8EE  ................
00079BE2 F1F1 EEE0 D1D0 CCD0 EB06 2542 575B 5D56  ..........%BW[]V
00079BF2 4A3F 2314 00FA FDF6 F2FE FBF0 E7E3 DBD5  J?#.............
00079C02 D8DC D8DF EAF2 F0F3 EAEE F0EE EBE1 D8D1  ................
00079C12 C1BB B4C0 D3F0 0621 262D 3230 272A 313E  .......!&-20'*1>
00079C22 5069 7B7F 7F7F 7F73 502C 02DF BDA4 9184  Pi{....sP,......
00079C32 8181 8181 8DAE D4F9 1320 251A 09F1 E0D6  ......... %.....
00079C42 D8DD F008 2036 4857 5E58 4C37 11F5 DDCD  .... 6HW^XL7....
00079C52 CECB D3D9 E3F1 FC04 0C0D 151A 1F24 303D  .............$0=
00079C62 4A52 5652 4B33 16FB E5CC C7CB D7E9 FBF7  JRVRK3..........
00079C72 F2E6 E2E1 F109 263A 505C 5C4D 3311 F1CD  ......&:P\\M3...
00079C82 AF90 8181 8180 8181 8181 8186 9EB4 D3E9  ................
00079C92 FC18 2939 4953 4F52 595D 5B62 605F 6056  ..)9ISORY][b`_`V
00079CA2 3B2D 2618 2731 2E2C 2E28 2B27 2B32 363F  ;-&.'1.,.(+'+26?
00079CB2 443B 2716 F7D0 BBAE A5A9 A89C 8B81 8181  D;'.............
00079CC2 8081 8181 8AB1 E40E 2F4C 5756 5344 2B15  ......../LWVSD+.
00079CD2 FDED EDFB 0C1C 2116 07EC D8D3 D1E6 FA02  ......!.........
00079CE2 2132 2E39 3528 2824 1E14 0F0B 0F1B 2C3F  !2.95(($......,?
00079CF2 4B57 5C53 4F40 3321 11FD E1C5 B1A0 8A93  KW\SO@3!........
00079D02 A7BC CFEE 0E2C 485F 6568 5D44 2A0C F0E3  .....,H_eh]D*...
00079D12 D5C8 C0C1 C0C6 C4C0 C8D1 D8F5 0210 2431  ..............$1
00079D22 2A20 0BEF D1AE 9284 8188 B4EC 2C5F 787E  * ..........,_x~
00079D32 7F79 5B39 1601 EDDB D2CD C3B7 A693 8581  .y[9............
00079D42 8181 8187 93B0 D5FB 2B56 777F 7F7F 7F7F  ........+Vw.....
00079D52 7951 2404 F2DF D8CC C0BF C1BC CBD2 D9E8  yQ$.............
00079D62 EEF2 0826 466A 7D7F 7F7F 6E54 3F33 3035  ...&Fj}...nT?305
00079D72 3E43 3E2F 11EC CEB7 A697 9FB2 C3CD DAD8  >C>/............
00079D82 D1C7 C9C7 BEBB BBBB C3D1 E7FE 1121 2723  .............!'#
00079D92 11FC F1E6 EF04 253D 5464 6E67 5130 19F7  ......%=TdngQ0..
00079DA2 D7CF D1CB DCFE 1019 221D 0A07 0606 1224  ........"......$
00079DB2 2F2F 2A15 EDCE BAA4 A4B1 C1D3 E2DD D8DE  //*.............
00079DC2 DEFA 2443 5A5C 4A26 FBDA C7C7 D3DF F1FD  ..$CZ\J&........
00079DD2 F6E1 E7D3 CCD8 DBD8 CDBD A492 9CA4 BFE7  ................
00079DE2 0722 2F2E 2119 0F0C 0E1F 3A55 6C7C 7F7F  ."/.!.....:Ul|..
00079DF2 7F7F 7A6D 7579 7B7F 7557 26F0 B88A 8081  ..zmuy{.uW&.....
00079E02 8181 8080 8181 818D C0FE 2338 4D52 4F5A  ..........#8MROZ
00079E12 5B53 4F33 1905 DDD3 D5D9 F007 110F F9EA  [SO3............
00079E22 D7CA B8AE B2B9 D7F2 0922 281E 190C F8F3  ........."(.....
00079E32 000F 273C 555C 5745 25FE DFBA 9983 8181  ..'<U\WE%.......
00079E42 8181 8295 B8EC 224F 6E7C 7F7B 694A 311A  ......"On|.{iJ1.
00079E52 1810 101E 1D16 1E1E 1E1F 1D11 FDE8 C6B0  ................
00079E62 ADB9 E016 4661 7170 6C51 3E2D 2125 2C28  ....FaqplQ>-!%,(
00079E72 1E05 DDB7 9382 8181 8C9A A5A9 A595 8B89  ................
00079E82 969F B2D0 E7FE 1029 3942 6060 606A 5140  .......)9B```jQ@
00079E92 3E33 394B 5664 6859 4224 07DE C8BD AFAD  >39KVdhYB$......
00079EA2 BAC3 CCC8 CBC0 AE97 96A1 A7CE F50F 3458  ..............4X
00079EB2 6A7B 7F7F 7F7F 7F74 604C 2408 ECD1 B9AD  j{.....t`L$.....
00079EC2 AA99 9394 9398 98A4 A3A1 B6CB DF17 4665  ..............Fe
00079ED2 7B7F 7F77 613F 18FC E3CB CBC6 C7D5 E1ED  {..wa?..........
00079EE2 EBF6 F3E9 E4E0 DDD8 D7EA F3FE 1D29 3042  .............)0B
00079EF2 4948 4335 1D13 0DF7 E9DE CDBD C6BF B9BB  IHC5............
00079F02 BCC8 DDE3 EAF9 FCF5 F0F5 EFED 061A 1B20  ...............
00079F12 261E 0BFC EACC BFD1 EA09 406D 7E7F 7F76  &.........@m~..v
00079F22 4D29 FACE BCB3 B0CC E701 2744 565B 5038  M)........'DV[P8
00079F32 15F6 E4E0 DBE6 F2E7 D3CB B39F A4B4 CBDD  ................
00079F42 FD1D 3E44 555E 585D 6E66 6E7D 7966 624A  ..>DU^X]nfn}yfbJ
00079F52 1BF9 DDB9 9D9B 9184 8281 8181 8CB1 DAF6  ................
00079F62 0C20 2014 1A1D 1C25 4544 2614 EAB2 8881  .  ....%ED&.....
00079F72 8181 8183 94C2 0026 425A 6367 5145 493E  .......&BZcgQEI>
00079F82 3736 2215 06E2 C3B7 B6C2 DF09 1E32 392F  76"..........29/
00079F92 1606 FBF8 0918 2030 3527 0FF9 D9BC C9DB  ...... 05'......
00079FA2 DE0B 3D66 797E 7E6A 4A22 F4C1 9F8E 888F  ..=fy~~jJ"......
00079FB2 97A1 ABB2 B4B3 C0C9 D7F7 1732 546B 757F  ...........2Tku.
00079FC2 735C 4C39 2116 1212 203C 5455 4D41 1CF7  s\L9!... <TUMA..
00079FD2 C6A4 9283 8191 A9BF D7E4 EFF2 F3FD FEF4  ................
00079FE2 0417 2C3B 5D6F 777C 7C72 4F2F 0AE0 C4AB  ..,;]ow||rO/....
00079FF2 9593 8E83 8887 8181 8081 859D B4D7 FD2A  ...............*
0007A002 4043 534D 4237 382D 0C07 E9CC BBBC BCCD  @CSMB78-........
0007A012 F507 2C5B 5753 6159 3C2D 17FC E5DA D6D4  ..,[WSaY<-......
0007A022 E0F7 171A 1915 04FD FEFE 1637 4C4D 4D3C  ...........7LMM<
0007A032 1AFD F4F1 EBF1 FF08 0C06 05F9 ECEC FD0F  ................
0007A042 1832 3021 1A04 F4F4 F4EF F200 1016 1A1C  .20!............
0007A052 1919 11FE E5CB B5A0 938D 95AF C4D9 E8EC  ................
0007A062 E7E7 F1FC 102F 4347 3E20 FAD6 BCA7 ACC1  ...../CG> ......
0007A072 DF05 1C2E 322D 2424 282C 3E4D 5041 3D34  ....2-$$(,>MPA=4
0007A082 211B 1F17 0E14 0AFC F3E8 E3EC FD0E 1C21  !..............!
0007A092 1D12 FFF0 D4C0 A98E 8281 8181 8081 8185  ................
0007A0A2 A3CB F00E 2A3A 4146 505C 5F6A 7579 7A7C  ....*:AFP\_juyz|
0007A0B2 7461 5347 4243 4B56 5B51 4225 FDD7 BDA9  taSGBCKV[QB%....
0007A0C2 9D9A A3B1 C3DD F91B 2C3A 4238 2317 FCE0  ........,:B8#...
0007A0D2 D0C3 C5CE D3DD E5EB F2F3 F8F7 EBF0 F6E9  ................
0007A0E2 E4DA CDCE CFCF DDD9 E0F2 F901 0308 0F10  ................
0007A0F2 120D 1118 0F15 1821 2F36 4448 3F36 291A  .......!/6DH?6).
0007A102 0B09 202B 2628 1F0E FFED D7CF CCD3 E7F2  .. +&(..........
0007A112 EEEB EEE9 E0DD D6D5 DDF1 FB11 2F44 434A  ............/DCJ
0007A122 3E23 13FD EEDC C4B1 A098 8B82 8181 8181  >#..............
0007A132 8291 B5DE 0023 3A49 4B47 5554 5F67 6260  .....#:IKGUT_gb`
0007A142 5954 584C 4745 3A24 09F3 E4DE E0E0 E5F0  YTXLGE:$........
0007A152 FF0C 171F 2C3E 5050 4C3B 1F02 E4D2 C5C3  ....,>PPL;......
0007A162 C5C8 C6C1 BCBD C1B5 ACA8 9A8F 8D96 A6C9  ................
0007A172 FB29 5C7E 7F7F 7F7F 7A62 4133 2F31 3A36  .)\~....zbA3/1:6
0007A182 2D21 0AF0 DBCB BEB7 B7C1 C7D3 E501 1C29  -!.............)
0007A192 3532 1900 E2C7 AD9C 9DB0 C7E1 FD17 272B  52............'+
0007A1A2 2D24 1611 02F9 F6F0 EDED DFD3 C6C1 CAD8  -$..............
0007A1B2 E9FC 152E 353F 4531 2614 FAE7 DED4 C6B7  ....5?E1&.......
0007A1C2 AEA9 AEC0 D4E2 FC0A 0904 F6E2 DEDB EE0B  ................
0007A1D2 172F 3F40 3D3B 4352 6A7A 7F7A 6752 3F2B  ./?@=;CRjz.zgR?+
0007A1E2 2024 2728 280E EDD3 B199 9AA7 BBE6 FF06   $'((...........
0007A1F2 0E14 1410 0200 00F4 F1EE D9C7 B6AD ACB1  ................
0007A202 C2E0 092C 4B61 747F 7F7F 7046 20F3 C59B  ...,Kat...pF ...
0007A212 8481 8181 8080 8180 8298 C705 416D 7E7F  ............Am~.
0007A222 7F7F 7051 3319 120E 0101 FDFD FE03 0300  ..pQ3...........
0007A232 0101 0606 0803 0203 0205 0511 1B14 0AF7  ................
0007A242 E9D7 CBC3 C2CA D1DB E3E9 EDEF EBE8 E8E5  ................
0007A252 E1E2 D3C8 CCCE CED5 E0E4 F708 1C3A 5C76  .............:\v
0007A262 7F7F 7F78 571E EBB8 9282 8185 9CB7 D5F0  ...xW...........
0007A272 0216 3041 607B 7F7F 7F7F 7F7D 6A4B 2B11  ..0A`{.....}jK+.
0007A282 F6CF A98B 8081 8181 8181 8C9F B1C6 E202  ................
0007A292 1D39 545E 6665 5542 2815 FEDF CEC0 A996  .9T^feUB(.......
0007A2A2 9496 A1BB DBF2 FF0D 0BFF F7F6 0314 2543  ..............%C
0007A2B2 525B 6767 635A 5044 392B 0DF2 D4B1 9C87  R[ggcZPD9+......
0007A2C2 8395 B0CF 0338 5973 7E6F 5339 15FC F1ED  .....8Ys~oS9....
0007A2D2 F402 161E 1518 0CFC F7EF ECE5 E6E2 D5D9  ................
0007A2E2 DDD5 D4DB E1EB F5ED DCCC B29C 9588 8081  ................
0007A2F2 8188 9FBD D1F3 1836 495B 6E73 7073 7571  .......6I[nspsuq
0007A302 6E69 5A47 3424 150B 0604 00F0 D9C9 BABA  niZG4$..........
0007A312 CBF0 1438 5F7A 7B6A 4A1B EAC2 ACA7 ACCA  ...8_z{jJ.......
0007A322 EE08 1517 1508 E7CB A995 95A5 D215 4B7F  ..............K.
0007A332 7F7F 7F7F 744E 2B0D E7CB B494 8181 8187  ....tN+.........
0007A342 B2D1 ED12 2133 3633 381A 0AF9 DDCB B6B3  ....!3638.......
0007A352 B6C4 DCEA F1F8 FAF5 0318 2235 3F44 4B4E  .........."5?DKN
0007A362 5260 706D 614E 2F0E F2D7 B19B 8B83 8181  R`pmaN/.........
0007A372 8181 8182 9AC2 F017 2C39 3B2B 1703 F1E1  ........,9;+....
0007A382 EDF1 F309 161C 2A4A 6879 7E7F 7E72 4D20  ......*Jhy~.~rM
0007A392 FDDA CBC7 C2C3 C4C2 BFC3 CDD7 F211 1E35  ...............5
0007A3A2 4947 4A45 3422 0F03 F9F0 EDDE CAB6 A493  IGJE4"..........
0007A3B2 9599 A2BF EE21 597C 7F7F 7F7F 704B 2F0D  .....!Y|....pK/.
0007A3C2 F4F2 F5F3 FE02 00FA F2E2 BE9B 8581 8181  ................
0007A3D2 93BB E006 2732 2926 1BFE F3ED EEFB 0204  ....'2)&........
0007A3E2 FDF4 E6D7 C9C3 D1E9 0320 2814 07F2 E6F5  ......... (.....
0007A3F2 0826 5170 716B 5427 FAE9 DBD1 DCE4 E8F1  .&QpqkT'........
0007A402 0522 4765 7A7F 745B 3C06 E8D9 D8DD DDE0  ."Gez.t[<.......
0007A412 CEC1 B59D 9094 969B AEB2 C1D1 DAF0 0115  ................
0007A422 3543 3C35 12EC EAF4 0112 2F35 3749 4940  5C<5....../57II@
0007A432 3524 170C 01F0 E0CF C3C4 C6D5 F71E 3F5F  5$............?_
0007A442 5F50 3810 EBD9 C4C7 E1FC 1C3E 5258 615F  _P8........>RXa_
0007A452 4C36 1CFB DED2 D5E1 F208 1405 E7C9 B3AA  L6..............
0007A462 B2C1 D2E6 EEEB E4CF C5C9 CFE0 F6FF FEFC  ................
0007A472 EED6 CDCA D2E2 F402 080E 141C 2C33 4049  ............,3@I
0007A482 4C51 5955 4F44 2608 E9C0 ADA0 97A6 BDD9  LQYUOD&.........
0007A492 F51B 3A42 413B 1D01 F6EF F305 171E 13F7  ..:BA;..........
0007A4A2 D6B8 A098 9CAD C7E4 0015 2125 2829 2F2C  ..........!%()/,
0007A4B2 2425 2B46 657A 7F7F 7F7F 5D35 06E0 C3A8  $%+Fez....]5....
0007A4C2 9FA0 A8BC D7F7 0E21 2003 DEB4 8E80 8181  .......! .......
0007A4D2 85A3 BFCF DDE2 DDDB E8FA 1635 4A5A 5C54  ...........5JZ\T
0007A4E2 5442 3333 2A26 2820 09F5 E9E0 ECF9 0710  TB33*&( ........
0007A4F2 06FC E1C8 B6AA AFBA CFE2 EFF8 FC07 1220  ...............
0007A502 2F39 4132 210D 0605 1426 3444 5053 5558  /9A2!....&4DPSUX
0007A512 5055 554C 472E 10F1 D1BB A7A4 AEBC CDD8  PUULG...........
0007A522 E0E1 E1E8 E4EC 0F21 435D 635D 4826 EDB8  .......!C]c]H&..
0007A532 9281 8081 8181 8080 8181 8297 D00F 4B78  ..............Kx
0007A542 7F7F 7F7F 7F7F 6D3B 19F6 D7C1 B2AF BAD3  ......m;........
0007A552 F211 2527 2319 05F7 F5FB FEFA FBF2 E5DB  ..%'#...........
0007A562 D0C3 C9DF FD29 5379 7F7F 7F7F 7F77 634E  .....)Sy.....wcN
0007A572 361E F7D7 B193 8480 818A A7C1 D4E5 E7E2  6...............
0007A582 E6EA EDF4 0312 2130 362F 1CFF E4C3 B1A7  ......!06/......
0007A592 98A0 B4BD D4EC FB0F 191B 231F 1714 1515  ..........#.....
0007A5A2 1212 150C 0905 FAF7 F5FD 081C 3654 6C7A  ............6Tlz
0007A5B2 7F7E 7359 401C F8E2 D0C4 BFBC BABD BEBF  .~sY@...........
0007A5C2 B9AB 968A 8280 8181 8185 ADE0 143D 555D  .............=U]
0007A5D2 5F5E 5C54 4E43 3525 170A FD03 1332 5470  _^\TNC5%.....2Tp
0007A5E2 7E7C 6A4D 20F8 DDC9 C1C6 D4DD DEE0 DED8  ~|jM ...........
0007A5F2 DFEF 0521 3B47 4232 19F6 D6BC B1AD B6D3  ...!;GB2........
0007A602 E4F8 1117 1512 01EF E5DE E0E5 EDED EBEA  ................
0007A612 E4DA DDE6 F714 2D38 3D3C 3529 2010 01FE  ......-8=<5) ...
0007A622 01FA F5F0 E9E1 DDDE DDDE EAF7 FF11 253B  ..............%;
0007A632 586A 6E6A 553A 1AFB E5D7 D2D4 DEE6 DFD4  XjnjU:..........
0007A642 C4AF A6AB C7F2 1637 4743 341F 01E3 CCBF  .......7GC4.....
0007A652 B6B8 C0CE D6D7 D5CA C1BF C4DB F414 2F40  ............../@
0007A662 4B52 564E 4231 1C0B 01F1 E8E7 DED5 C9C2  KRVNB1..........
0007A672 C4D5 F820 4974 7F7F 7F7F 7E63 3306 DBCA  ... It....~c3...
0007A682 C6D0 E2F4 040B 0806 FAEB D8BF AB9E 9A9D  ................
0007A692 A5AF BCCC D5DD EEF8 0B20 3140 4A54 5C65  ......... 1@JT\e
0007A6A2 747D 7F7F 6848 1AE4 C1A2 9BB1 D8FE 1B2D  t}..hH.........-
0007A6B2 3022 05DD B68E 8181 8183 95B6 DBF7 0102  0"..............
0007A6C2 FAE5 D0B4 9F9B AED7 0D4C 787F 7F7F 7F7F  .........Lx.....
0007A6D2 7F7F 7059 422B 13FF E4D3 C6C6 D5ED 0B25  ..pYB+.........%
0007A6E2 353C 3524 12FE E5D2 C4C7 DCEF FA01 F8E3  5<5$............
0007A6F2 CAB0 9684 8181 8395 B2CD E0E6 EAE2 DCD6  ................
0007A702 D8E9 0425 4A63 7279 6B52 2C02 D7BB B1B3  ...%JcrykR,.....
0007A712 C8DB F10F 252E 3A46 473D 2F26 1D23 3546  ....%.:FG=/&.#5F
0007A722 565B 513F 1BF6 D9C1 ADA2 9FAB C4E4 0723  V[Q?...........#
0007A732 383D 3226 160B 050B 1114 1317 1204 F3D1  8=2&............
0007A742 AA89 8081 8082 92B0 CAEB 1544 737F 7F7F  ...........Ds...
0007A752 7F7F 7F7F 7D57 331A 03FF 030B 00EE D5B7  ....}W3.........
0007A762 9988 8B98 A5AF B3B0 A99A 8A82 8181 879F  ................
0007A772 BBDD 0934 627D 7F7F 7F7F 7F7F 7F7C 6140  ...4b}.......|a@
0007A782 1E0C 0401 0A1A 




; sample 17 - BATWINGSCRAPE

>m7A788
0007A788 464F 524D 0000 097C 3853 5658 5648 4452  FORM...|8SVXVHDR
0007A798 0000 0014 0000 091C 0000 0000 0000 0020  ...............
0007A7A8 20AB 0100 0001 0000 4E41 4D45 0000 0014   .......NAME....
0007A7B8 4241 5457 494E 4753 4352 4150 4500 0000  BATWINGSCRAPE...
0007A7C8 0000 0000 414E 4E4F 0000 0014 4175 6469  ....ANNO....Audi
0007A7D8 6F20 4D61 7374 6572 2049 4900 0000 0000  o Master II.....
0007A7E8 424F 4459 0000 091C 0000 0000 0001 FF02  BODY............
0007A7F8 FF01 02FD 00FD 0401 03FD FE04 FAFF 0102  ................
0007A808 05FD FA07 04FA F90A 02F7 05FF 01F7 0AF7  ................
0007A818 FD05 0905 ED06 FAFF FF06 F600 01FC F71A  ................
0007A828 F6EB 03F8 1204 FC0C E90A EC1E FDF9 06ED  ................
0007A838 15E6 1007 F9FA 0009 F401 06F5 2002 F1FC  ............ ...
0007A848 0109 000C F4FE 17E7 1CFC 0213 E3F7 FE19  ................
0007A858 0504 E7EA 33DB FA12 11FE EE10 EB10 01ED  ....3...........
0007A868 10E5 120A E5F1 F821 FEF3 FBF3 16F9 23F8  .......!......#.
0007A878 F90C 0EF3 FA29 F4E6 F2F8 22D2 1800 ED26  .....)...."....&
0007A888 FF16 D303 E411 FA20 F1F1 0DF2 0805 28D1  ....... ......(.
0007A898 0AEA 0210 1BFD CE28 FA16 0AD0 FCD8 122E  .......(........
0007A8A8 28E6 D405 F921 F1D8 430D D706 2FF2 A15F  (....!..C.../.._
0007A8B8 1ECA 15F7 D847 00B3 FD37 EBF1 04F2 EC2F  .....G...7...../
0007A8C8 EE0D C90F EC0F 181A C5D8 111A 22DD F3F2  ............"...
0007A8D8 F71B E718 12CA 2FEE 17D6 E602 4B19 C336  ....../.....K..6
0007A8E8 BBCE 251C 4037 E1A3 1097 317B 3FA2 F218  ..%.@7....1{?...
0007A8F8 C522 1208 2CCC DB33 25D2 A74E 5FA5 0C14  ."..,..3%..N_...
0007A908 D50E FCF6 E34C 04EB 1ABC 2EF2 33C6 03F3  .....L......3...
0007A918 04F0 0454 EFC2 FD32 15B9 3412 1BE4 C009  ...T...2..4.....
0007A928 F5EF 1B4C 14C7 1AD1 D15A 1AF8 FBE2 ECEC  ...L.....Z......
0007A938 1349 E700 CF02 2E28 C839 E611 1400 04E4  .I.....(.9......
0007A948 CC2C F727 2413 1AAA F4CE 0616 0BEB FF10  .,.'$...........
0007A958 E4FD C10C 7FCB F7D0 539F 8C4D 7738 8070  ........S..Mw8.p
0007A968 8F3B DBC7 C92C 7FAB 092F F0B1 71D7 DB1F  .;...,.../..q...
0007A978 DC06 51E7 C2A2 2D31 EBEB 1121 C609 13AC  ..Q...-1...!....
0007A988 7019 0512 17D0 C2C3 63D6 26CC C07D A039  p.......c.&..}.9
0007A998 350D FC92 1445 2911 CB30 11F1 9347 30F7  5....E)..0...G0.
0007A9A8 D3B7 3EBC 5CB4 BB45 1342 B2EC FF1C 0600  ..>.\..E.B......
0007A9B8 32E7 2716 099B 1FFB 1421 F6FD E8E4 EE31  2.'......!.....1
0007A9C8 E111 2ECE F029 070A DD35 AA26 EF0A 22C7  .....)...5.&..".
0007A9D8 34DA 070E 2AF6 EF0E 11C9 DC17 0722 FDE6  4...*........"..
0007A9E8 47E2 00FD 1105 1CD0 D111 FC2F F8D1 CF7C  G........../...|
0007A9F8 E528 D5FE D3EC F921 67A9 0448 DCD3 28FE  .(.....!g..H..(.
0007AA08 2FF1 1FA8 D64F B24D 14CF 191D 2CB4 11DE  /....O.M....,...
0007AA18 D108 6E0B C3C9 21F5 39D1 38F2 30DB FA7E  ..n...!.9.8.0..~
0007AA28 B8D9 A336 2DB4 3C06 D854 F5F1 07D7 DC3A  ...6-.<..T.....:
0007AA38 0CF3 02D6 00EE 382F AB28 E6ED 1DD8 0CF0  ......8/.(......
0007AA48 BB1D F635 D038 A50E 4AB0 0E1F F6C5 3032  ...5.8..J.....02
0007AA58 AD23 D625 D4E2 27E3 30FA 20B4 EC48 F9CC  .#.%..'.0. ..H..
0007AA68 0D26 E1DC 0FE1 2D30 1CFE D7F1 EC0A 22F2  .&....-0......".
0007AA78 3FE6 DC24 EF2C CE23 DD22 01E4 022A F81F  ?..$.,.#."...*..
0007AA88 DD3A 12CB 03DC 1FF7 36DA F741 D1FA DA27  .:......6..A...'
0007AA98 F51C CF01 32E0 9A2F 2BE5 1FE5 2209 08D2  ....2../+..."...
0007AAA8 0707 F527 D636 DF1B 02D8 26D8 29F3 2CDE  ...'.6....&.).,.
0007AAB8 F8F4 08DA 3EB4 1EFA 4524 A729 E5F4 022D  ....>...E$.)...-
0007AAC8 03DA E900 3242 F0E1 EC37 BDE2 4F08 3BA4  ....2B...7..O.;.
0007AAD8 D938 11E9 0D08 21E5 F010 FE07 F7CF 1A10  .8....!.........
0007AAE8 FCDD F421 FE33 0008 D702 F406 0716 0E26  ...!.3.........&
0007AAF8 E5F6 E8FA FE1D 0EE0 F802 FC0E EC35 CCF4  .............5..
0007AB08 00DF 121E F511 FEFB FAE7 2AF2 0FD7 0011  ..........*.....
0007AB18 1BF3 F9FF EE26 E1D2 12FA 4FD9 0717 EDDD  .....&....O.....
0007AB28 D544 D91B 14E7 06DC 27F8 28EF F435 EDD2  .D......'.(..5..
0007AB38 D955 F6BE 084D 0EE8 B6FC 5AC1 FEEE 390F  .U...M....Z...9.
0007AB48 D7FE 0B3B AF05 3A05 0437 CDDC 50BB 163C  ...;..:..7..P..<
0007AB58 F5C0 4F19 B327 B53E 30C9 0100 2B81 4D39  ..O..'.>0...+.M9
0007AB68 B5F9 D612 DB5C E8CB F314 17D7 F72D 2E24  .....\.......-.$
0007AB78 B44C A343 BF09 4DCF FFA5 DC13 55B7 2FDE  .L.C..M.....U./.
0007AB88 D94A F70C D976 9506 EB0C 3603 FC22 41A0  .J...v....6.."A.
0007AB98 FB03 43F8 09FA F1FD BA38 1835 06F1 20A4  ..C......8.5.. .
0007ABA8 040E F806 F6F6 48E6 D7D5 F326 3AF9 D917  ......H....&:...
0007ABB8 D812 EAF3 3222 1006 E3BA 2F23 07C4 1D09  ....2"..../#....
0007ABC8 07E6 CB33 2BC9 14DD 2A1E F21B C832 E015  ...3+...*....2..
0007ABD8 F1FB 0819 E6DA F7E0 3C21 C94A 1BAB D6F8  ........<!.J....
0007ABE8 2C22 05DC 3AE2 E8E6 A162 F729 DD13 35A1  ,"..:....b.)..5.
0007ABF8 4B45 D1C7 1109 4DD7 C8ED E90C 200A E2F1  KE....M..... ...
0007AC08 FBFB 1C25 A93F 3504 F4AE 14FA 29FC E411  ...%.?5.....)...
0007AC18 02DD 1D09 F43C 9E0C 222D 2FD6 06F3 16AD  .....<.."-/.....
0007AC28 4DE0 F411 DE0E 1808 C5F3 5CDA 39FC F619  M.........\.9...
0007AC38 0BE5 B445 F559 F0C3 DDD1 5AD3 16FF 1DE7  ...E.Y....Z.....
0007AC48 CF01 EE28 06E9 0C2D EACB 1F0C 2AFF D9EA  ...(...-....*...
0007AC58 F1E4 2E05 0FF2 1DDA 0130 FE0C DC1E FCED  .........0......
0007AC68 F108 23F7 04FC 0607 ECDA 1F30 30D8 DC0E  ..#........00...
0007AC78 E9DA EC32 1F08 DCE3 6DCC E90C FA17 CC1A  ...2....m.......
0007AC88 02EA 4FCF 1C03 A551 2C8E F63C 40D7 C84E  ..O....Q,..<@..N
0007AC98 4AA7 F6C8 380D D427 0B0A BE4C E30F C2E3  J...8..'...L....
0007ACA8 07E5 1506 37D4 29E8 D541 03AC 0041 C804  ....7.)..A...A..
0007ACB8 2D0C E9FB DBED 3728 E72A E70C E5BF 53D4  -.....7(.*....S.
0007ACC8 1014 DC2C 12FE F3CC FE5A BDD7 1543 E6C1  ...,.....Z...C..
0007ACD8 25E8 4DD3 2DC3 1F35 C9FF D836 29A0 2A36  %.M.-..5...6).*6
0007ACE8 FBFD BE2E DCF3 F71B 14FE D5FA 3005 EFDA  ............0...
0007ACF8 FB32 ED20 F7EE E01B 01FE EEFC 1701 EA0C  .2. ............
0007AD08 DF0C 110F 1CCD E00F 0303 02E5 0C00 F9E6  ................
0007AD18 0E1D FA0B 38EF CBEB 01DD 210A 01C9 271C  ....8.....!...'.
0007AD28 FBDB EC4E 03EA AE38 6F81 410E DCBA FA6F  ...N...8o.A....o
0007AD38 9126 993E DFF5 33A6 588F 4E9F 34C9 D268  .&.>..3.X.N.4..h
0007AD48 CDE7 1113 06D0 F1F7 FCEA E812 FAF7 8E7F  ................
0007AD58 D5F9 FDB2 398B 7FC4 2B19 34CD B46E BD2E  ....9...+.4..n..
0007AD68 FB42 D6F5 9217 5BDA 3C9D FA6A CA0A 2744  .B....[.<..j..'D
0007AD78 C7DA 4729 3A8D 5ABE 45E5 DC38 BD68 20CB  ..G):.Z.E..8.h .
0007AD88 ECF3 43DB 33BF EC42 EC17 D81F 17C9 08E4  ..C.3..B........
0007AD98 00C8 FC18 C7F4 16FD 0000 F7EA 10F5 24F4  ..............$.
0007ADA8 FD23 E616 D532 B818 E938 23CE 39DB BC1B  .#...2...8#.9...
0007ADB8 111B BB09 19EA 2FE7 CF41 1BB4 EF35 DFC4  ....../..A...5..
0007ADC8 23FD 15F5 FFD1 0BF2 F2F1 0B34 E3F2 14EA  #..........4....
0007ADD8 0325 2FD7 CB41 E537 F2A3 39EA 0FBD 4E07  .%/..A.7..9...N.
0007ADE8 04ED 4609 F41B F3D9 E32C F3ED F724 DD4C  ..F......,...$.L
0007ADF8 CFFA D908 15FD FA3E 2393 B85B 4222 F2C8  .......>#..[B"..
0007AE08 4702 E8C5 2E2C 09F3 C049 03E8 977C 1993  G....,...I...|..
0007AE18 E211 5009 E5E8 2DCC 2DB2 1C1B 1AEB E926  ..P...-.-......&
0007AE28 AC71 BDEA 1FDE 1ED4 57DD 19CC D34B 25B4  .q......W....K%.
0007AE38 F917 F3CC 1DCD 58EF B94B E2F0 E003 2CF2  ......X..K....,.
0007AE48 DCD9 5B07 DCEF E612 34E9 CB2D 26A2 0010  ..[.....4..-&...
0007AE58 D84A F2EE FF16 C72F F4FF 41E0 FDCF 0D13  .J...../..A.....
0007AE68 2EFE BD42 E8FC 2CED F902 B206 3E09 24CF  ...B..,.....>.$.
0007AE78 0216 D743 C338 F4CD 19B8 76B5 43E2 20FF  ...C.8....v.C. .
0007AE88 FCFF 9E59 CB02 F5EB FA25 18C1 54C5 BBC8  ...Y.....%..T...
0007AE98 7F56 CFB9 B323 1936 C92C 58A7 C03C F6FE  .V...#.6.,X..<..
0007AEA8 D867 1DD5 0FD9 CD4B 08D1 31F8 0016 18DE  .g.....K..1.....
0007AEB8 D6CD 183A BC38 EDEC 62D2 20DF D014 46D8  ...:.8..b. ...F.
0007AEC8 E672 B9D0 2343 E0EC 0BF6 31EB 2BD3 0251  .r..#C....1.+..Q
0007AED8 E8E3 E641 C24A F4B3 25E2 19C3 3618 15D6  ...A.J..%...6...
0007AEE8 F910 E71D F019 00D2 19FF E6F1 050A 3608  ..............6.
0007AEF8 E3D3 EBFD 25DF 1C4B B905 0BFC 3002 F6C4  ....%..K....0...
0007AF08 1137 ED08 EA18 EFEA 53C9 21F3 08EC D73B  .7......S.!....;
0007AF18 F9EC FF1A E700 DB1F 0B3B D6E6 3ACD B12F  .........;..:../
0007AF28 2403 0031 E8A0 46F6 268A 54ED CB2D 857F  $..1..F.&.T..-..
0007AF38 9672 98D5 2991 13C4 3FA1 D93C DCE4 2B13  .r..)...?..<..+.
0007AF48 CC13 EECA 0F12 CE0D 4517 8731 E91E F675  ........E..1...u
0007AF58 CDDE DF1E 42EC 38AA BB4D B4F1 3A0A 0812  ....B.8..M..:...
0007AF68 A70D 2007 F4E1 4EDE EA4C B04E FF26 BE0B  .. ...N..L.N.&..
0007AF78 F1B8 5C27 211C 05FE A722 2107 090F F8EB  ..\'!...."!.....
0007AF88 42B0 A174 100E B410 0803 06FD 55E5 0EE6  B..t........U...
0007AF98 FFF1 26C5 3619 04D7 1511 DBFC F32B 071F  ..&.6........+..
0007AFA8 E6DE 320F F31D CCE6 29BA 222A 0EF3 DE1B  ..2.....)."*....
0007AFB8 07C0 1209 07E4 D71F 0A00 E30C 3DB5 20F0  ............=. .
0007AFC8 0AE2 0254 B714 BEEC 5C2D E6D6 60E5 1991  ...T....\-..`...
0007AFD8 2DF1 EB23 0B0F A235 DD39 4AE9 2ECE E724  -..#...5.9J....$
0007AFE8 F8EF C07F 00F3 E8DB 53DA 4794 1FC6 C047  ........S.G....G
0007AFF8 5DC6 AD35 0E08 EF0A F129 D937 E901 02BF  ]..5.....).7....
0007B008 3E3D C1DF 3FD7 3B1E 18C0 C5F5 340B 2122  >=..?.;.....4.!"
0007B018 B900 D719 35F0 03C3 0920 9B4B C023 13E6  ....5.... .K.#..
0007B028 BB3A 22B9 FF1C F9BD 1DCD F244 E8DD DF3F  .:"........D...?
0007B038 02FD E00F 20D8 0538 0AF0 E6C8 2A53 D0D1  .... ..8....*S..
0007B048 FFF7 1EF5 0F32 03E5 CE35 03EB EB1F 0C06  .....2...5......
0007B058 14CD F909 29E1 EF1C E828 FA13 11AC FEFC  ....)....(......
0007B068 3DBB 0727 DB1E D511 E533 C1EC 4ED0 B244  =..'.....3..N..D
0007B078 1916 1D07 00B9 35F3 1BEA E946 BC40 CA40  ......5....F.@.@
0007B088 02DA CFE6 1109 0B08 40D9 E900 25EB 0501  ........@...%...
0007B098 FFE6 2BE9 08F1 ED36 C81A E516 09DC 2213  ..+....6......".
0007B0A8 21E6 EB0D 1119 FCF3 D517 DD2E FB20 FDF1  !............ ..
0007B0B8 11FC 1C01 E606 FE18 DC13 FC08 EAF3 20DE  .............. .
0007B0C8 FFF8 0821 F2F8 E710 FCFA 0BFC 13E9 FF03  ...!............
0007B0D8 FA06 F806 0AFC F9FC 0400 FF01 F90F 00F3  ................
0007B0E8 04FB 08FD 09FE F802 FD07 01FD 03F7 0207  ................
0007B0F8 FD01 0004 00FD FE00 01FF 0400 00FF 0000  ................
0007B108 0000 0000 



; sample 18 - BALLOONPOP
>m7B10C
0007B10C 464F 524D 0000 098A 3853 5658 5648 4452  FORM....8SVXVHDR
0007B11C 0000 0014 0000 092A 0000 0000 0000 0020  .......*.......
0007B12C 1B5C 0100 0001 0000 4E41 4D45 0000 0014  .\......NAME....
0007B13C 4241 4C4C 4F4F 4E50 4F50 0000 0000 0000  BALLOONPOP......
0007B14C 0000 0000 414E 4E4F 0000 0014 4175 6469  ....ANNO....Audi
0007B15C 6F20 4D61 7374 6572 2049 4900 0000 0000  o Master II.....
0007B16C 424F 4459 0000 092A 0001 0104 1A3F 717F  BODY...*.....?q.
0007B17C 7F76 C795 8F81 8281 8800 7ED3 8A7F 77F8  .v........~...w.
0007B18C 8095 7401 BFF2 717F 7F7F 56B4 95E6 999C  ..t...q...V.....
0007B19C F77A C7CD 727F 56EC 8D91 8180 8181 81C3  .z..r.V.........
0007B1AC 1645 4971 6714 9FF9 E4C8 85BC 464A F92D  .EIqg.......FJ.-
0007B1BC 6E7B 501E 1521 8D91 92E2 3B39 657F 632C  n{P..!....;9e.c,
0007B1CC 7E5B 12A3 8094 9DDD EE18 DC9F C21F 04EE  ~[..............
0007B1DC 0B4D 352E 622C 0D8D 9882 9CD6 13D6 6C7F  .M5.b,........l.
0007B1EC 7F7F 6FB7 8999 2751 B5C4 6A68 F1A4 4F5C  ..o...'Q..jh..O\
0007B1FC AB80 D37A 411E 7674 9180 8081 8188 2135  ...zA.vt......!5
0007B20C 2263 7F7F 7F78 44DA 8080 8181 BD08 D4F9  "c...xD.........
0007B21C 5D7F 2FBC 888B A567 7F7F 56C1 B704 1860  ]./....g..V....`
0007B22C 7F15 AE80 B5F0 9085 E7F7 C2BE 5837 1ADC  ............X7..
0007B23C 083C 506E 4A23 BD84 8081 92DA C321 1DDD  .<PnJ#.......!..
0007B24C 6B6C AF8D 1FFC 0A7F 7F7F 35E5 5F7F 38A4  kl........5._.8.
0007B25C F133 28E9 082E 8080 B326 0596 2F3D AAAE  .3(......&../=..
0007B26C 4737 A9FF 6332 CBCC DD9A 2528 2F51 7A04  G7..c2....%(/Qz.
0007B27C CD11 E38D E97D 7F6F B581 88AF 959B 61DA  .....}.o......a.
0007B28C 8094 1BE5 808B D2DC 637F 7F7F 4140 7F7F  ........c...A@..
0007B29C 58D5 CAEA 0832 CD89 8081 8199 02D0 C840  X....2.........@
0007B2AC 7F7F 6547 06BE 4643 83B0 C69B C314 125A  ..eG..FC.......Z
0007B2BC 7F23 1FE3 A181 8281 C481 BE5D 7F7C 6F7F  .#.........].|o.
0007B2CC 56EA 2BE9 8CC0 A2A3 FF4F 1FFD A2AF C720  V.+......O.....
0007B2DC 22C6 5057 4F3B 102C 0BA6 B337 B0C3 05FE  ".PWO;.,...7....
0007B2EC 257F 7F6D 1115 63FC A2F7 ED85 E14B EB88  %..m..c......K..
0007B2FC 8083 B70E 5955 1950 270E 101A A682 BDFD  ....YU.P'.......
0007B30C 1C2E 2E3E E8A2 2F39 A280 8DF3 0905 325D  ...>../9......2]
0007B31C DABD 0F76 78CC EE63 38BB 3253 C7BD 3EAA  ...vx..c8.2S..>.
0007B32C C81C 13A1 EDCD EAF2 0141 1913 1058 3B08  .........A...X;.
0007B33C EADA 8E80 A640 7F7F 53FB BDA0 8ED7 CF46  .....@..S......F
0007B34C 1BCA 5265 EECC D6E5 E0DA 417F 18CF 3178  ..Re......A...1x
0007B35C D883 A2FC D0BE FBF4 F7CB C707 12F5 4369  ..............Ci
0007B36C 09B3 2340 DEC1 1B58 DE0F 1F10 EDDD A7C2  ..#@...X........
0007B37C 005E 4826 0416 3738 3628 33FD A311 12D0  .^H&..786(3.....
0007B38C C2E5 F6EE EDF4 CDA2 EC3C 24C4 2C3A BE9F  .........<$.,:..
0007B39C AFD3 B7F8 675D 6B68 4343 05F6 092B DE01  ....g]khCC...+..
0007B3AC 03B5 8D8D C3C4 C506 481F F811 D9BF 3B6E  ........H.....;n
0007B3BC 0544 725C 1901 F9C4 E2C7 D8F2 D2FC 5C1C  .Dr\..........\.
0007B3CC E91F 4C0B F513 35E5 A92C 2ED0 F040 0E20  ..L...5..,...@.
0007B3DC 11CB C8D1 ADBE 0C4A 44F5 D8D3 1435 1101  .......JD....5..
0007B3EC 265E 1D38 47EE 9B9C A189 94AB 9509 0C19  &^.8G...........
0007B3FC 3D64 7618 F902 F809 00FD 0A15 1E54 6B13  =dv..........Tk.
0007B40C FA57 09B0 DDE8 AE9A C60C 1819 BCDB F81E  .W..............
0007B41C 430B 1320 D8CA 1F18 D50B 4427 B9CA F51C  C.. ......D'....
0007B42C FD02 0920 F3BD C9EF 12FA 1C51 2AFD E1D1  ... .......Q*...
0007B43C 041B EEDC 477F 5AE3 FB48 0C8B D236 4420  ....G.Z..H...6D
0007B44C FEDE D8A0 87FC 0EB2 C33B 4A17 230B B09E  .........;J.#...
0007B45C C80B 2A4D 5168 59EF BFF7 EBE1 181D E3E2  ..*MQhY.........
0007B46C FF02 F6E3 002F 0ACA FC1B E3F9 0B19 05C6  ...../..........
0007B47C ED2E 2EEB A9D3 E4A6 CC05 ED04 5765 3136  ............We16
0007B48C 26FF 3620 F7E7 12F5 F61B 3BFD B6C3 F200  &.6 ......;.....
0007B49C DDF6 FE16 02D0 B803 FAC2 D6F6 F4F4 183A  ...............:
0007B4AC E5D3 073B 3B19 727A 42FD FCEA D90D 4400  ...;;.rzB.....D.
0007B4BC AFF9 10C5 B4ED 01E7 D6FD 2B1D CADB 372B  ..........+...7+
0007B4CC E7D6 0526 04F2 1000 E9DD DDFF FCD9 C21C  ...&............
0007B4DC 3626 2C16 101C 150D 2E08 EF12 FAF1 1A23  6&,............#
0007B4EC C8C0 E804 110D 12D3 9FA2 D3DF 224B 630A  ............"Kc.
0007B4FC F128 18AB B322 3EF4 2F56 4526 DD02 240A  .(...">./VE&..$.
0007B50C DFF2 E8D1 DC06 1BF9 DAFC F6FD 1A1D D7CF  ................
0007B51C C3E0 143C 040D 2A14 F4D4 D919 43FE F227  ...<..*.....C..'
0007B52C 3918 1D4C 481C E7DD E6C4 B3D9 F9E9 F90B  9..LH...........
0007B53C D7DF 0200 E6F5 060D 1834 0FE2 F6EB C2F6  .........4......
0007B54C 4A2C EC34 4600 A7D5 03F2 FBF9 2119 0A1E  J,.4F.......!...
0007B55C 35F0 F62C 3407 EDED B88D D730 0912 5103  5..,4......0..Q.
0007B56C C2F6 05F3 F2F9 0FFB E4F2 121F 2410 F6F7  ............$...
0007B57C 0A08 0D25 03CC D7D8 CB05 2A21 081F 382D  ...%......*!..8-
0007B58C 0E04 00E1 DAEE 1207 00FF 0EDC C6FF 16F5  ................
0007B59C 0128 1E35 4017 EFDC DDC9 DEFF FAEC 1F1D  .(.5@...........
0007B5AC EAE2 FE17 D8DD 1C26 E9E7 3449 14CB EF20  .......&..4I...
0007B5BC F6E0 F503 1009 FE0E 15ED CCE9 1E24 0608  .............$..
0007B5CC 2515 DDC0 C0EF F0F4 0E0D FF11 3206 140D  %...........2...
0007B5DC 1F13 0102 FEE2 E4F1 F5DA E522 3C10 E908  ..........."<...
0007B5EC 311F F5F5 03F3 EF19 3017 DEE8 F9F5 F30D  1.......0.......
0007B5FC EEDF 0C2A 15D9 1013 F4E4 F3F2 000C 1B22  ...*..........."
0007B60C 0FE4 E400 100F E8EE 0301 E8F6 F5EA 0727  ...............'
0007B61C 0B00 1403 0F28 0ED3 DD1D 1F14 0E00 E6CC  .....(..........
0007B62C E907 1F0B F3F3 FFFA E5D7 F9F5 EAFA 03FD  ................
0007B63C F2FA 1433 3236 1B04 0B0D 0AF6 F2EC F0EF  ...326..........
0007B64C EAED FDE4 DBEB FCF4 F504 040C 2209 0919  ............"...
0007B65C 16FB FAFD 0E0A FD25 1C0C FBEF DAE5 F8EF  .......%........
0007B66C E7F8 0711 0EFF EDF2 0316 181A 0603 0C06  ................
0007B67C 0F1C F2F5 0900 0901 ECDD F00C 1DFF F70F  ................
0007B68C 14F7 EDF4 E6C9 E918 1710 0D04 0801 F7FD  ................
0007B69C 0613 1917 1FF5 F003 FBE2 FD0A 03EB D4E1  ................
0007B6AC E6EA EB09 241B 1619 1C11 08EC E5FC 01E4  ....$...........
0007B6BC F80B FCEE F7FA 0DFF E8F6 1E2E 02F7 FCF5  ................
0007B6CC EF0F 15F2 071F 09F6 EDEB EBD7 E40C 0F09  ................
0007B6DC 04F3 E6F5 1120 111C 1B0D FF13 1AF4 EC09  ..... ..........
0007B6EC 08F3 FAF1 EDEB FE05 01F7 F8F9 FF0C F1E8  ................
0007B6FC 0723 331D 1B1F 18EC 01FF F3E1 DDD7 DF09  .#3.............
0007B70C 1F1F 0700 F9F2 EFF2 FE18 09E6 F80C 00E0  ................
0007B71C F112 0EFA 0113 FFF5 FFEB F60B F3F8 1B3A  ...............:
0007B72C 2606 FAF0 EFFC 0400 F8F9 E9FE 06EE DBE9  &...............
0007B73C 01FE F4F6 0F1C 1014 12FB EB0D 0A01 1B0F  ................
0007B74C FB0B 0FF5 DAD6 EAEE 0823 1809 0900 FBED  .........#......
0007B75C EFDD E500 1D18 0F1F 1905 FEFD FDE5 EA08  ................
0007B76C 0DF0 EC0E 11E6 0317 0411 1810 ECDA FBF3  ................
0007B77C CADB F9FD FF17 2414 131D 1B05 F0FE 0A15  ......$.........
0007B78C 1E13 F8EE EDE2 EAF1 EDEE FA03 F7FB F3F3  ................
0007B79C 0902 0407 0D0A 0904 0015 1EFB 1416 F4E3  ................
0007B7AC F2F4 ECFB 04FD F6FE F9FE 0306 FEF6 F80F  ................
0007B7BC 0DF9 EEFC FDEA FD0B 0AFF 04FF 0C15 130C  ................
0007B7CC 1010 06FD FDFA EBFB 0907 F905 F9EF F702  ................
0007B7DC F3F4 090E F4FE 05FF 000B 100A FDF4 E2ED  ................
0007B7EC 0304 F0FE 100A 0509 111D 1F0E 0101 FAE2  ................
0007B7FC E9F0 E2DD FC0E 03F3 F604 0B0D 0507 1305  ................
0007B80C F6F6 F7FE 1013 0908 06FF F806 FDEA EA06  ................
0007B81C 0AFB F900 F7F6 0A13 0AFC 0716 07F9 FAF4  ................
0007B82C F3FE 05F3 FC0D FAE9 F309 04F4 F405 F8F1  ................
0007B83C 00FE 051B 2114 0B0A 06FA F5F4 09FE ECFF  ....!...........
0007B84C 0E02 F702 1005 FEF7 ECEA EFEC EF06 0F0F  ................
0007B85C 040E 0AFE 0201 F6FE 0807 0110 0B04 FAF6  ................
0007B86C EEEC F902 091A 1801 050F F2E0 F501 F9F2  ................
0007B87C 0A0F 0204 06F4 F2F2 F9FD F905 1515 03F4  ................
0007B88C F7FF F5ED 0105 01FB 0114 00FA 0B0F 0105  ................
0007B89C 0502 0009 00F6 F6F1 01FD F0FF 0BF7 F308  ................
0007B8AC 0B06 03FA 0205 09FF 0905 0004 0916 1206  ................
0007B8BC F6EE EDF6 00FC FD02 FD01 060E 00F8 F7F6  ................
0007B8CC FB09 130B 01FC FFFC E8ED 0F0D FD0D 04F0  ................
0007B8DC F50C 0CFC F0FB 0505 0507 09F2 E8FC 0A05  ................
0007B8EC F8EE 040A 05FA F7FE FDFC FEFE 0009 0401  ................
0007B8FC FE03 FE03 050A 08FC 000C 05F0 F100 02F6  ................
0007B90C 0114 1309 01FB EEFC 04F0 F707 FEF9 020A  ................
0007B91C 07F9 F3FB FAFE FCFD 060F 06FC 0106 08FA  ................
0007B92C F903 01FF 080E 0803 0109 FFFB FC0B 0B0C  ................
0007B93C 0C06 00F5 F1F1 F2EC FB06 06F8 F50F 0DF3  ................
0007B94C F501 00FB 0204 FF05 0A00 0404 FC01 0703  ................
0007B95C 0801 F5FE 01F9 FC15 07F8 FD02 FEF4 F7FB  ................
0007B96C FCFE FAFB FBFB F9FF 0402 FDFE 06FD F905  ................
0007B97C 0C0C 0603 0301 FEFC 0608 FDF1 F900 0100  ................
0007B98C 00FD FBFD 02FD 0407 0702 0000 0000 FEFF  ................
0007B99C 0205 0405 0401 F8F5 FE00 F600 0902 0108  ................
0007B9AC 0B03 F5F5 0001 0001 0905 00FF 00FC F8FE  ................
0007B9BC 0404 0405 0C03 FB00 01F3 F904 06FF 0502  ................
0007B9CC FCFA F9F2 F3FC FBF9 060F 0907 0702 0101  ................
0007B9DC 01FD FF04 05FF FF05 FFF8 F9FF 01FF FE01  ................
0007B9EC 0805 FC00 01FD F9FD 0104 00F9 FE00 FBFD  ................
0007B9FC 0405 FF00 0201 0201 01FF 0305 01FD FBFE  ................
0007BA0C FF00 0202 02FF FB02 06FE F5F6 0202 FF00  ................
0007BA1C 0303 0001 0506 00FB FC02 0100 0204 0200  ................
0007BA2C FCFF FFFA FC02 0103 0202 0200 FF00 0000  ................
0007BA3C 0002 0301 00FF FFFF FEFD FF02 0403 0303  ................
0007BA4C FFFF 00FE FBFC FF00 FEFF 0202 0100 0100  ................
0007BA5C 0002 0302 FEFD 0002 01FF FF01 FEFD FC00  ................
0007BA6C FEFE 0002 0000 0102 0000 0101 FF00 0404  ................
0007BA7C 01FF FF01 00FF FEFF 0100 0001 01FE FD00  ................
0007BA8C 0100 FE00 0102 01FF 00FF FEFF 00FF FE00  ................
0007BA9C 0101 



; sample 19 - CUTROPE2
>m7BA9E
0007BA9E 464F 524D 0000 0394 3853 5658 5648 4452  FORM....8SVXVHDR
0007BAAE 0000 0014 0000 0334 0000 0000 0000 0020  .......4.......
0007BABE 20AB 0100 0001 0000 4E41 4D45 0000 0014   .......NAME....
0007BACE 4355 5452 4F50 4532 0000 0000 0000 0000  CUTROPE2........
0007BADE 0000 0000 414E 4E4F 0000 0014 4175 6469  ....ANNO....Audi
0007BAEE 6F20 4D61 7374 6572 2049 4900 0000 0000  o Master II.....
0007BAFE 424F 4459 0000 0334 0100 0000 0000 0000  BODY...4........
0007BB0E 0000 0001 020A 1C4B 787F 7F7F 7F7F 7F7F  .......Kx.......
0007BB1E 3499 8184 8484 8484 8484 8484 8484 8484  4...............
0007BB2E 89C4 0041 5B63 4A41 3E79 261C F6F9 F5FE  ...A[cJA>y&.....
0007BB3E 0503 0B16 162B 2951 5676 7F7F 7F47 D39A  .....+)QVv...G..
0007BB4E 8284 8384 8483 8A9E B1C4 D7EB FC0D 2142  ..............!B
0007BB5E 607F 7F7F 7F7F 7F43 F7A2 8285 8384 8384  `......C........
0007BB6E 8694 A7C5 E102 3C55 6463 5441 1DFE E4DB  ......<UdcTA....
0007BB7E D9DA DCDE E6EB F0F6 FAFF FCFB 020C 1528  ...............(
0007BB8E 394D 697F 7F7F 7F7F 7F7F 7F78 4C38 4827  9Mi........xL8H'
0007BB9E 1108 FDF8 FB02 FFE8 D3B4 9083 8483 8484  ................
0007BBAE 8384 909F ABB2 B8BD BFC1 C6C8 CED3 DCEB  ................
0007BBBE FD15 2F50 6D7F 7F7F 7F7F 7F7D 6C59 4231  ../Pm......}lYB1
0007BBCE 1E0F 00F3 EFEC F0EE ECE2 D3C7 BEBA BCBE  ................
0007BBDE C0C7 CFD9 E0E4 EAEF F1F1 F1EF EDEC EDF1  ................
0007BBEE F6FE 0917 2431 3C43 4746 3E34 2619 0CFF  ....$1<CGF>4&...
0007BBFE F1E6 DFD7 D0CA C6C5 C9D1 D9DE E1DF DBD3  ................
0007BC0E D1D6 E2ED FC07 121B 2125 2A2D 2E2D 2C28  ........!%*-.-,(
0007BC1E 241E 1915 1315 1E29 343D 3C3A 3229 1F12  $......)4=<:2)..
0007BC2E 06FB F5F0 EDE9 E5E0 DCD6 D2D0 D6E0 E7E7  ................
0007BC3E E4E0 DAD9 D8DB DEE4 E9ED F2F8 FD02 060A  ................
0007BC4E 0C0D 0F0E 0D0C 0B0B 0C10 1316 1719 1917  ................
0007BC5E 140D 06FF FAF9 F8F6 F4F3 F3F2 F1EF EFEF  ................
0007BC6E F0EE EDED EBEA E9E9 E8E8 EAEC F1F7 FD04  ................
0007BC7E 090E 1216 191B 1D1F 2020 2120 1F1D 1916  ........  ! ....
0007BC8E 110B 04FD F9F6 F4F4 F5F5 F4F4 F4F4 F2EF  ................
0007BC9E EDEC E9E5 E1DF DCDA DADB DEE3 EAF3 FC04  ................
0007BCAE 0D14 1A1F 2529 2C30 3335 3637 3839 3835  ....%),035678985
0007BCBE 322D 2821 1B13 0B04 FDF6 F0EC E8E5 DFDA  2-(!............
0007BCCE D4CE CAC8 C6C6 C7C8 CACC D0D5 DDE5 EDF5  ................
0007BCDE FD04 0A10 151A 1F23 282D 3034 383B 3D3F  .......#(-048;=?
0007BCEE 3E3E 3B38 352F 2922 1A11 0901 F9F2 EAE4  >>;85/)"........
0007BCFE DED7 D1CB C8C5 C3C2 C2C2 C2C4 C7CC D2DA  ................
0007BD0E E2EA F1F8 FE03 080D 1014 171B 1F24 282E  .............$(.
0007BD1E 3338 3B3D 3D3C 3935 3029 2119 1007 FFF7  38;==<950)!.....
0007BD2E F0EA E4DE D9D4 D0CE CDCD CFD0 D3D5 DADE  ................
0007BD3E E3E9 EEF3 F8FD 0104 080B 0D0F 1112 1415  ................
0007BD4E 171A 1C20 2325 2727 2421 1C17 120D 0701  ... #%''$!......
0007BD5E FCF7 F1EC E8E5 E2E0 DFDE DEDF E0E2 E4E6  ................
0007BD6E E9EC EFF3 F6F9 FD01 0406 090B 0C0E 1011  ................
0007BD7E 1213 1314 1515 1616 1615 1412 100D 0B08  ................
0007BD8E 0501 FEFA F7F3 F0EF EDEB E9E9 E9E9 EBEC  ................
0007BD9E EEF0 F2F3 F5F7 FAFC FE01 0406 080A 0B0C  ................
0007BDAE 0D0D 0D0D 0D0D 0C0B 0B0A 0909 0908 0809  ................
0007BDBE 0807 0605 0200 FEFB FAF9 F7F5 F4F3 F3F4  ................
0007BDCE F4F6 F7F8 F8FA FBFC FCFD FE00 0103 0506  ................
0007BDDE 0809 0A09 0908 0706 0503 0201 00FE FDFE  ................
0007BDEE FE00 0103 0404 0302 0001 00FF FEFD FCFB  ................
0007BDFE FAFA FAFA FAFB FBFC FDFD FEFF FF00 0102  ................
0007BE0E 0304 0505 0605 0403 0100 FEFE FCFB F9F9  ................
0007BE1E F8F9 FBFD FF02 0304 0405 0505 0505 0504  ................
0007BE2E 0302 0100 FFFF FEFF FFFF 



; data after samples
0007BE38 0001 002A 002B  .............*.+
0007BE3E 002E 0031 0034 0037 003A 0040 0044 0045  ...1.4.7.:.@.D.E
0007BE4E 0048 004B 004E 0051 0054 0067 006A 006D  .H.K.N.Q.T.g.j.m



