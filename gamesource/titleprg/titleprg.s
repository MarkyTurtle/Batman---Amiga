
                
                ;
                ; Title Screen
                ; ------------
                ; Title_Screen_Start            - $0001c000   - First Game Title Screen Start
                ;                               - $0001c004   - End Game Title Screen Start (Game Over/Game Completion)
                ;
                ;
                ; Music Player
                ; ------------
                ; Initialise_Music_Player       - $00004000
                ; Silence_All_Audio             - $00004004
                ; Init_Song                     - $00004010 - D0.l = Song Number to play (0-3, 0 = stop playing)
                ; Play_Song                     - $00004018 - Call every frame/cycle to play song
                ;

                section panel,code_c
                ;org     $3ffc                                   ; original load address


                ;--------------------- includes and constants ---------------------------
                INCDIR  "include"
                INCLUDE "hw.i"


ASSET_CHARSET_BASE              EQU     $3f1ea                          ; address of charset in memory
DISPLAY_BITPLANE_ADDRESS        EQU     $63190                          ; address of display bitplanes in memory



TEST_TITLEPRG SET 1                                             ; Comment this to remove 'test'

        IFD TEST_TITLEPRG  

                jmp     title_screen_start                      ; Entry point $0001c000

        ENDC


                ;-------------------------- title prg start -----------------------------
                ; The original binaries of the game start with a long word that provide
                ; the load/address of the file.
titleprg_start
        dc.l    $00004000                                       ; original start address $00004000






                ;****************************************************************************************************************
                ;****************************************************************************************************************
                ;****************************************************************************************************************
                ;
                ;
                ;
                ;               MUSIC/SOUND Player Routines
                ;
                ;
                ;
                ;****************************************************************************************************************
                ;****************************************************************************************************************
                ;****************************************************************************************************************




                ;----------------------------- Music Player Jump Table ------------------------------
Initialise_Music_Player                                         ; original routine address $00004000
                bra.w   do_initialise_music_player              ; jmp $00004180

Silence_All_Audio                                               ; original routine address $00004004
                bra.w   do_silence_all_audio                    ; calls $00004194

Stop_Audio                                                      ; original address $00004008
                bra.w   do_stop_audio                           ; $000041e0 ; appears to expect d0 to be a song number.

Stop_Audio_2                                                    ; original address $0000400c
                bra.w   do_stop_audio                           ; $000041e0

                ; IN: D0.l (song/sound to play)
Init_Song                                                       ; original routine address $00004010
                bra.w   do_init_song                            ; calls $0000423e, init/play song


L00004014       bra.w   L00004222


Play_Song                                                       ; original routin address $00004018
                bra.w   do_play_song                            ; $000042f6


L0000401c       dc.w    $ffff
L0000401e       dc.w    $ffff
L00004020       dc.w    $8000


song_number                                                     ; original address $00004022
L00004022       dc.b    $01                                     ; sound/song to play - initialised to $00
L00004023       dc.W    $00                                     ; initialised to $00




                ; ------ channel/voice data structs --------
                ; offset | desc
                ; 0x0000 | channel volume
                ; 0x004a | unsure (set to 0x0001 when silenced)
                ; 0x004c | unsure (set to 0x0000 when silenced)
                ;
channel_1_status
L00004024       dc.w    $8080, $0001, $ba1b, $0001
                dc.w    $ba1e, $0000, $0000, $0001
                dc.w    $ba41, $0500, $0001, $b9a6
                dc.w    $0001, $b9aa, $0101, $0004
                dc.w    $fd00, $0000, $0000, $0000
                dc.w    $0000, $0000, $0000, $0000
                dc.w    $0000, $0000, $0000, $0000
                dc.w    $0000, $0000, $0038, $0000
                dc.w    $fb6c, $0666, $0000, $4d3a
                dc.w    $0001, $018f, $0000, $003a
                dc.w    $3a06, $0018, $0001 

channel_2_status
L0000407a       dc.w    $8050, $0001, $ba27, $0001
                dc.w    $ba28, $0000, $0000, $0001
                dc.w    $bb55, $0100, $0001, $b9ac
                dc.w    $0001, $b9ae, $0101, $0001
                dc.w    $1e00, $0000, $0000, $0000
                dc.w    $0000, $0000, $0000, $0000
                dc.w    $0000, $0000, $0000, $0000
                dc.w    $0000, $0000, $0018, $0000
                dc.w    $ca18, $0a28, $0000, $4d3a
                dc.w    $0001, $01bf, $001e, $0018
                dc.w    $1800, $0006, $0002

channel_3_status
L000040d0       dc.w    $8010, $0001, $ba2a, $0001
                dc.w    $ba2b, $0000, $0000, $0001
                dc.w    $bbae, $0100, $0001, $b9ac
                dc.w    $0001, $b9ae, $0101, $0001
                dc.W    $1e00, $0000, $0000, $0000
                dc.W    $0000, $0000, $0000, $0000
                dc.w    $0000, $0000, $0000, $0000
                dc.w    $0000, $0000, $0011, $0000
                dc.w    $ed94, $06b8, $0000, $4d3a
                dc.w    $0001, $00d3, $001e, $001e
                dc.w    $1e00, $000c, $0004

channel_4_status
L00004126       dc.w    $8084, $0001, $ba34, $0001
                dc.w    $ba37, $0000, $0000, $0001
                dc.w    $ba41, $0500, $0001, $b9b4
                dc.w    $0001, $b9bb, $0101, $0001
                dc.w    $ff00, $0000, $0000, $0000
                dc.w    $0000, $0000, $0000, $0000
                dc.w    $0000, $0000, $0103, $1400
                dc.w    $0605, $0006, $003e, $0001
                dc.w    $14ca, $11d6, $0001, $2de0
                dc.w    $054b, $0279, $0000, $0038
                dc.w    $3800, $0018, $0008

.other_data
L0000417c       dc.w    $0000 
L0000417e       dc.W    $0d69                           ; referenced as a word - cleared when playing new song/sound



                ;----------------------------- intitialise music player ------------------------------
do_initialise_music_player                                      ; original routine address $00004180                                                        
                lea.l   default_sample_data,a0                  ; L00004d52,a0
                lea.l   instrument_data,a1                      ; L00004bfa,a1
                bsr.w   initialise_music                        ; calls L000049cc
                bra.w   do_silence_all_audio                    ; jmp $00004194



                ;---------------------------- do silence all audio ----------------------------------
                ; sets all audio channels to 0 volume, probably also stops any playing tracks
                ; by setting values in channel structure and/or values in 4022, 4023
                ;
do_silence_all_audio                                            ; original routine address $00004194
                movem.l d0/a0-a1,-(a7)

                move.b  #$00,song_number                        ; $00004022 - initialising unknown
                move.b  #$00,L00004023                          ; initialising unknown

                lea.l   channel_1_status,a0                     ; $4024,a0
                lea.l   $00dff0a8,a1                            ; a1 = audio volume
                bsr.b   silence_channel_volume                  ; calls $000041c2
                bsr.b   silence_channel_volume                  ; calls $000041c2
                bsr.b   silence_channel_volume                  ; calls $000041c2
                bsr.b   silence_channel_volume                  ; calls $000041c2
                move.w  #$0000,L00004020
                movem.l (a7)+,d0/a0-a1
                rts                                             ; Where does this go? whats on the stack?



                ;------------ silence channel volume -------------
                ; IN: A0 - channel/voice status data
                ; IN: A1 - AUDxVOL custom register
                ;
silence_channel_volume
                move.w  #$0000,(a0)                             ; set volume in struct
                move.w  #$0001,$004a(a0)                        ; set unknown in struct
                move.w  #$0000,$004c(a0)                        ; set unknown in struct
                move.w  #$0000,(a1)                             ; Volume custom reg = 0
                adda.w  #$0056,a0                               ; update ptr to next channel struct (86 bytes)
                adda.w  #$0010,a1                               ; update to next channel volume register
                rts




                ;----------------------------- xxxxxxxxxx -----------------------------
                ; Stop Playing Audio, this appears to be another routine that
                ; silences the audio. It looks buggy in the main loop as I can't
                ; see it updating the ptrs in the loop. I may be tired.
                ;
                ; If song number (d0) is not in range 1-3 then silence audio and exit.
                ;
                ; Called from:
                ;        - do_title_screen_start
                ;
                ; IN: D0.w      - Song Number
                ;
do_stop_audio                                                   ; original routine address $000041e0
                movem.l d0/d7/a0-a2,-(a7)
                subq.w  #$01,d0
                bmi.b   .silence_audio                          ; jmp $000041ee
                cmp.w   #$0003,d0
                bcs.b   .silence_channels                       ; jmp $000041f2
.silence_audio
                bsr.b   do_silence_all_audio                    ; calls $00004194
                bra.b   .exit
.silence_channels
                lea.l   song_table,a2                           ; L0001b9dc,a2
                asl.w   #$03,d0
                adda.w  d0,a2
                lea.l   channel_1_status,a0                     ; L00004024,a0
                lea.l   $00dff0a8,a1                            ; a1 = AUD0VOL
                moveq   #$03,d7                                 ; d7 = 3 + 1 ; 4 sound channels
.audio_channel_loop
                tst.w   (a2)+                                   ; Test Song Structure Volume - $00004208
                bne.b   .silence_audio_channel                  ; if volume !=0 then silence the channel
                adda.w  #$0056,a0                               ; offset into channel status
                adda.w  #$0010,a1                               ; increment to next AUDxVOL register
                bra.b   .continue                               ; continue loop processing - $00004218
.silence_audio_channel
                bsr.b   silence_channel_volume                  ; calls $000041c2       - L00004216
.continue
                dbf.w   d7,.audio_channel_loop                  ; jmp $00004208         - L00004218
.exit
                movem.l (a7)+,d0/d7/a0-a2
                rts



L00004222       tst.w   L00004126
L00004226       beq.b   L0000422e
L00004228       cmp.b   L00004023,d0
L0000422c       bcs.b   L0000423c
L0000422e       movem.l d0/d7/a0-a2,-(a7)
L00004232       move.w  #$4000,d1
L00004236       move.b  d0,L00004023
L0000423a       bra.b   L0000424a
L0000423c       rts





                ;----------------------- do init song ------------------------
                ; set the current song number, and initialise for playing
                ;
                ; IN: D0.l - sound/song to play?
                ;               - 0 = play nothing/stop
                ;               - >3 = play nothing/stop
do_init_song                                                    ; original routine address $0000423e
                movem.l d0/d7/a0-a2,-(a7)
                move.w  #$8000,d1
                move.b  d0,song_number                          ; $00004022
                clr.w   L0000417e                               ; clear timer/counter?
.validate_song_number
                subq.w  #$01,d0
                bmi.b   .stop_playing                           ; L00004258
                cmp.w   #$0003,d0                               ; check song number in range 1-3
                bcs.b   .init_song

.stop_playing
                bsr.w   do_silence_all_audio                       ; calls $00004194
                bra.w   .exit

.init_song
                lea.l   song_table,a0                           ; $0001b9dc - a0 = base ptr
                asl.w   #$03,d0                                 ; d0 = song no x 8
                adda.w  d0,a0                                   ; a0 = updated base ptr to song table entry

.init_channels
                lea.l   channel_1_status,a1                     ; L00004024,a1
                moveq   #$03,d7                                 ; d7 = channel count + 1
.channel_loop
                move.w  (a0)+,d0                                ; d0 = channel offset value (from value address) 
                beq.b   .skip_to_next_channel                   ; if value = 0, jmp $000042e4
                lea.l   $fe(a0,d0),a2                           ; a2 = song channel data

                moveq   #$00,d0
                move.w  d0,$004c(a1)                            ; initialise unknown channel status values
                move.l  d0,$0002(a1)                            ; initialise unknown channel status values
                move.l  d0,$000a(a1)                            ; initialise unknown channel status values
                move.b  d0,$0013(a1)                            ; initialise unknown channel status values
                move.b  #$01,$0012(a1)                          ; initialise unknown channel status values
                move.w  d1,(a1)                                 ; (8000) initialise unknown channel status values

.get_next_byte
                move.b  (a2)+,d0                        ; d0 = song channel data byte  
.chk_code_0x
                bpl.b   .is_code_0x                     ; code is '0x', bit 7 = 0, Play Sample?
.chk_code_80
                sub.b   #$80,d0
                bne.b   .chk_code_81
.is_code_80
                movea.l $0002(a1),a2
                cmpa.w  #$0000,a2
                bne.b   .get_next_byte
                clr.w   (a1)
                bra.b   .skip_to_next_channel                   ; jmp $000042e4
.chk_code_81
                subq.b  #$01,d0
                bne.b   .chk_code_82
.is_code_81
                move.l  a2,$0002(a1)                            ; store current channel data ptr
                bra.b   .get_next_byte
.chk_code_82
                subq.b  #$01,d0
                bne.b   .chk_code_83
.is_code_82
                move.b  (a2)+,$0013(a1)                         ; initialise unknown channel status values
                bra.b   L00004292
.chk_code_83
                subq.b  #$01,d0
                bne.b   .get_next_byte
.is_code_83
                move.b  (a2)+,(a1,$0012)                        ; initialise unknown channel status values
                bra.b   .get_next_byte
.is_code_0x                                                   ; these values for 'Laugh' & 'IWanna'
                move.l  a2,$0006(a1)                            ; store song channel data ptr
                lea.l   L0001ba06,a2
                ext.w   d0
                add.w   d0,d0
                adda.w  d0,a2
                adda.w  (a2),a2
                move.l  a2,$000e(a1)                            ; ($90,$0B - $90,$0C) - initialise unknown channel status values
                move.w  #$0001,$0052(a1)                        ; initialise unknown channel status values
.skip_to_next_channel
                lea.l   $0056(a1),a1
                dbf.w   d7,.channel_loop                        ; loop, jmp $00004270
                or.w    d1,L00004020
.exit
                movem.l (a7)+,d0/d7/a0-a2
                rts





                ;--------------------------- do play song -----------------------
                ;
do_play_song
L000042f6       lea.l   $00dff000,a6
L000042fc       lea.l   $00004bba,a5
L00004302       clr.w   L0000417c
L00004306       tst.w   L00004020
L0000430a       beq.b   L00004354
L0000430c       addq.w  #$01,$417e
L00004310       clr.w   L00004020
L00004314       lea.l   channel_1_status,a4                             ; L00004024,a4
L00004318       move.w  (a4),d7
L0000431a       beq.b   L00004324
L0000431c       bsr.b   L00004360
L0000431e       move.w  d7,(a4)
L00004320       or.w    d7,L00004020
L00004324       lea.l   L0000407a,a4
L00004328       move.w  (a4),d7
L0000432a       beq.b   L00004334
L0000432c       bsr.b   L00004360
L0000432e       move.w  d7,(a4)
L00004330       or.w    d7,L00004020
L00004334       lea.l   L000040d0,a4
L00004338       move.w  (a4),d7
L0000433a       beq.b   L00004344
L0000433c       bsr.b   L00004360
L0000433e       move.w  d7,(a4)
L00004340       or.w    d7,L00004020
L00004344       lea.l   L00004126,a4
L00004348       move.w  (a4),d7
L0000434a       beq.b   L00004354
L0000434c       bsr.b   L00004360
L0000434e       move.w  d7,(a4)
L00004350       or.w    d7,L00004020
L00004354       and.w   #$c000,L00004020
L0000435a       bsr.w   L00004852
L0000435e       rts


L00004360       tst.w   (a4,$0052)
L00004364       beq.w   L000046b2
L00004368       subq.w  #$01,(a4,$0052)
L0000436c       bne.w   L000046b2
L00004370       movea.l (a4,$000e),a3
L00004374       bclr.l  #$0007,d7
L00004378       move.b  (a3)+,d0
L0000437a       bpl.w   L00004560
L0000437e       bclr.l  #$0003,d7
L00004382       cmp.b   #$a0,d0
L00004386       bcc.b   L00004378
L00004388       lea.l   (pc,$0014),a0
L0000438c       sub.b   #$80,d0
L00004390       ext.w   d0
L00004392       add.w   d0,d0
L00004394       adda.w  d0,a0
L00004396       move.w  (a0),d0
L00004398       beq.b   L00004378
L0000439a       jmp     (a0,d0,$00)


L0000439e       dc.w $0040
L000043a0       dc.w $00ba 
L000043a2       dc.w $00c0        
L000043a4       dc.w $00c2        
L000043a6       dc.w $00c4        
L000043a8       dc.w $00ce        
L000043aa       dc.w $00d4
L000043ac       dc.w $00dc        
L000043ae       dc.w $00ea
L000043b0       dc.w $00f8
L000043b2       dc.w $010a
L000043b4       dc.w $0140
L000043b6       dc.w $0156
L000043b8       dc.w $010c
L000043ba       dc.w $0132
L000043bc       dc.w $0158
L000043be       dc.w $016e
L000043c0       dc.w $0000
L000043c2       dc.w $0000
L000043c4       dc.w $0000
L000043c6       dc.w $0000
L000043c8       dc.w $0000
L000043ca       dc.w $0000
L000043cc       dc.w $0000
L000043ce       dc.w $0000
L000043d0       dc.w $0000
L000043d2       dc.w $0000
L000043d4       dc.w $0000
L000043d6       dc.w $0000
L000043d8       dc.w $0000
L000043da       dc.w $0000
L000043dc       dc.w $0000




L000043de       movea.l $000a(a4),a3
L000043e2       cmpa.w  #$0000,a3
L000043e6       bne.b   L00004378
L000043e8       movea.l $0006(a4),a3
L000043ec       move.b  -$0001(a3),d0
L000043f0       subq.b  #$01,(a4,$0012)
L000043f4       bne.b   L00004444
L000043f6       move.b  #$01,$0012(a4)
L000043fc       move.b  #$00,$0013(a4)
L00004402       move.b  (a3)+,d0
L00004404       bpl.b   L00004444
L00004406       sub.b   #$80,d0
L0000440a       bne.b   L00004426
L0000440c       movea.l $0002(a4),a3
L00004410       cmpa.w  #$0000,a3
L00004414       bne.b   L00004402
L00004416       move.w  #$0001,$004a(a4)
L0000441c       move.w  #$0000,$004c(a4)
L00004422       moveq   #$00,d7
L00004424       rts  

L00004426       subq.b  #$01,d0
L00004428       bne.b   L00004430
L0000442a       move.l  a3,$0002(a4)
L0000442e       bra.b   $00004402

L00004430       subq.b  #$01,d0
L00004432       bne.b   L0000443a
L00004434       move.b  (a3)+,$0013(a4)
L00004438       bra.b   L00004402
L0000443a       subq.b  #$01,d0
L0000443c       bne.b   L00004402
L0000443e       move.b  (a3)+,$0012(a4)
L00004442       bra.b   L00004402

L00004444       move.l  a3,$0006(a4)
L00004448       lea.l   $0001ba06,a3
L0000444e       ext.w   d0
L00004450       add.w   d0,d0
L00004452       adda.w  d0,a3
L00004454       adda.w  (a3),a3
L00004456       bra.w   L00004378
L0000445a       move.l  a3,$000a(a4)
L0000445e       bra.w   L00004378
L00004462       bra.w   L00004378
L00004466       bra.w   L00004378
L0000446a       bset.l  #$0005,d7
L0000446e       move.b  (a3)+,$0051(a4)
                bra.w   L00004378


L00004476       bclr.l  #$0005,d7
L0000447a       bra.w   L00004378
L0000447e       add.w   #$0100,$0052(a4)
L00004484       bra.w   L00004378
L00004488       bclr.l  #$0004,d7
L0000448c       bset.l  #$0007,d7
L00004490       clr.w   $004c(a4)
L00004494       bra.w   L0000469c
L00004498       bset.l  #$0003,d7
L0000449c       move.b  (a3)+,$0024(a4)
L000044a0       move.b  (a3)+,$0025(a4)
L000044a4       bra.w   L00004378
L000044a8       and.w   #$fff8,d7
L000044ac       bset.l  #$0000,d7
L000044b0       move.b  (a3)+,$0021(a4)
L000044b4       move.b  (a3)+,$0022(a4)
L000044b8       bra.w   L00004378
L000044bc       bclr.l  #$0000,d7
L000044c0       bra.w   L00004378
L000044c4       and.w   #$fff8,d7
L000044c8       bset.l  #$0001,d7
L000044cc       lea.l   $0001b986,a0
L000044d2       moveq   #$00,d0
L000044d4       move.b  (a3)+,d0
L000044d6       add.w   d0,d0
L000044d8       adda.w  d0,a0
L000044da       adda.w  (a0),a0
L000044dc       move.b  (a0)+,$0032(a4)
L000044e0       move.b  (a0)+,$0030(a4)
L000044e4       move.l  a0,$0028(a4)
L000044e8       bra.w   L00004378

L000044ec       bclr.l #$0001,d7
L000044f0       bra.w #$fe86 == $00004378 (T)
L000044f4       and.w #$fff8,d7
L000044f8       bset.l #$0002,d7
L000044fc       move.b (a3)+ [4e],(a4,$0036) == $0000158e [00]
L00004500       move.b (a3)+ [4e],(a4,$0034) == $0000158c [00]
L00004504       move.b (a3)+ [4e],(a4,$0035) == $0000158d [00]
L00004508       bra.w #$fe6e == $00004378 (T)

L0000450c       bclr.l #$0002,d7
L00004510       bra.w #$fe66 == $00004378 (T)
L00004514       lea.l $0001b98c,a0
L0000451a       moveq #$00,d0
L0000451c       move.b (a3)+,d0
L0000451e       add.w d0,d0
L00004520       adda.w d0,a0
L00004522       adda.w (a0),a0
L00004524       move.l a0,(a4,$0014) 
L00004528       bra.w #$fe4e == $00004378 (T)

L0000452c       lea.l $00004bea,a0
L00004532       moveq #$00,d0
L00004534       move.b (a3)+ [4e],d0
L00004536       asl.w #$04,d0
L00004538       adda.w d0,a0
L0000453a       move.w (a0)+ [236b],(a4,$003c) == $00001594 [0000]
L0000453e       move.l (a0)+ [236b0126],(a4,$003e) == $00001596 [00000000]
L00004542       move.w (a0)+ [236b],(a4,$0042) == $0000159a [0000]
L00004546       move.l (a0)+ [236b0126],(a4,$0044) == $0000159c [00000000]
L0000454a       move.w (a0)+ [236b],(a4,$0048) == $000015a0 [0000]
L0000454e       bclr.l #$0006,d7
L00004552       tst.w (a0) [236b]
L00004554       beq.w #$fe22 == $00004378 (T)
L00004558       bset.l #$0006,d7
L0000455c       bra.w #$fe1a == $00004378 (T)
L00004560       btst.l #$0006,d7
L00004564       bne.b #$04 == $0000456a (F)
L00004566       add.b (a4,$0013) == $0000156b [00],d0
L0000456a       move.b d0,(a4,$004f) == $000015a7 [00]
L0000456e       btst.l #$0000,d7
L00004572       beq.b #$0a == $0000457e (T)
L00004574       add.b (a4,$0021) == $00001579 [00],d0
L00004578       move.b (a4,$0022) == $0000157a [00],(a4,$0023) == $0000157b [00]
L0000457e       move.b d0,(a4,$0050) == $000015a8 [00]
L00004582       ext.w d0
L00004584       sub.w (a4,$003c) == $00001594 [0000],d0
L00004588       add.w d0,d0
L0000458a       cmp.w #$ffd0,d0
L0000458e       blt.b #$06 == $00004596 (F)
L00004590       cmp.w #$002c,d0
L00004594       ble.b #$16 == $000045ac (T)
L00004596       move.b (a4,$004f) == $000015a7 [00],d1
L0000459a       move.b (a4,$0050) == $000015a8 [00],d2
L0000459e       move.w (a4,$003c) == $00001594 [0000],d3
L000045a2       move.w (a4,$0054) == $000015ac [0000],d4
L000045a6       movea.l (a4,$0006) == $0000155e [00000000],a2
L000045aa       illegal
L000045ac       move.w (a5,d0.W,$00) == $00c014b6 [00c0],(a4,$004a) == $000015a2 [0000]
L000045b2       btst.l #$0002,d7
L000045b6       beq.b #$5a == $00004612 (T)
L000045b8       move.b (a4,$0050) == $000015a8 [00],d0


L000045bc       add.b (a4,$0034) == $0000158c [00],d0
L000045c0       ext.w d0
L000045c2       sub.w (a4,$003c) == $00001594 [0000],d0
L000045c6       add.w d0,d0
L000045c8       cmp.w #$ffd0,d0
L000045cc       blt.b #$06 == $000045d4 (F)
L000045ce       cmp.w #$002c,d0
L000045d2       ble.b #$16 == $000045ea (T)
L000045d4       move.b (a4,$004f) == $000015a7 [00],d1
L000045d8       move.b (a4,$0050) == $000015a8 [00],d2

L000045dc       move.w (a4,$003c) == $00001594 [0000],d3
L000045e0       move.w (a4,$0054) == $000015ac [0000],d4
L000045e4       movea.l (a4,$0006) == $0000155e [00000000],a2
L000045e8       illegal
L000045ea       move.w (a5,d0.W,$00) == $00c014b6 [00c0],d0
L000045ee       sub.w (a4,$004a) == $000015a2 [0000],d0
L000045f2       asr.w #$01,d0
L000045f4       ext.l d0
L000045f6       move.b (a4,$0035) == $0000158d [00],d1
L000045fa       ext.w d1

L000045fc       divs.w d1,d0
L000045fe       move.w d0,(a4,$003a) == $00001592 [0000]
L00004602       move.b d1,(a4,$0039) == $00001591 [00]
L00004606       add.b d1,d1
L00004608       move.b d1,(a4,$0038) == $00001590 [00]
L0000460c       move.b (a4,$0036) == $0000158e [00],(a4,$0037) == $0000158f [00]
L00004612       btst.l #$0003,d7
L00004616       beq.b #$50 == $00004668 (T)
L00004618       move.b (a4,$0050) == $000015a8 [00],d0
L0000461c       add.b (a4,$0024) == $0000157c [00],d0

L00004620       ext.w d0
L00004622       sub.w (a4,$003c) == $00001594 [0000],d0
L00004626       add.w d0,d0
L00004628       cmp.w #$ffd0,d0
L0000462c       blt.b #$06 == $00004634 (F)
L0000462e       cmp.w #$002c,d0
L00004632       ble.b #$16 == $0000464a (T)
L00004634       move.b (a4,$004f) == $000015a7 [00],d1
L00004638       move.b (a4,$0050) == $000015a8 [00],d2
L0000463c       move.w (a4,$003c) == $00001594 [0000],d3

L00004640       move.w (a4,$0054) == $000015ac [0000],d4
L00004644       movea.l (a4,$0006) == $0000155e [00000000],a2
L00004648       illegal
L0000464a       move.w (a5,d0.W,$00) == $00c014b6 [00c0],d0
L0000464e       sub.w (a4,$004a) == $000015a2 [0000],d0
L00004652       ext.l d0
L00004654       moveq #$00,d1
L00004656       move.b (a4,$0025) == $0000157d [00],d1
L0000465a       divs.w d1,d0
L0000465c       move.w d0,(a4,$0026) == $0000157e [0000]

L00004660       neg.w d0
L00004662       muls.w d1,d0
L00004664       sub.w d0,(a4,$004a) == $000015a2 [0000]
L00004668       btst.l #$0001,d7
L0000466c       beq.b #$12 == $00004680 (T)
L0000466e       move.b #$01,(a4,$0033) == $0000158b [00]
L00004674       move.l (a4,$0028) == $00001580 [00000000],(a4,$002c) == $00001584 [00000000]
L0000467a       move.b (a4,$0030) == $00001588 [00],(a4,$0031) == $00001589 [00]
L00004680       bset.l #$0004,d7
L00004684       move.l (a4,$0014) == $0000156c [00000000],(a4,$0018) == $00001570 [00000000]
L0000468a       move.w #$0001,(a4,$001e) == $00001576 [0000]
L00004690       clr.w (a4,$004c) == $000015a4 [0000]
L00004694       move.w (a4,$0054) == $000015ac [0000],d0
L00004698       or.w d0,$417c [0000]
L0000469c       moveq #$00,d0
L0000469e       move.b (a4,$0051) == $000015a9 [00],d0
L000046a2       btst.l #$0005,d7
L000046a6       bne.b #$02 == $000046aa (F)
L000046a8       move.b (a3)+ [4e],d0
L000046aa       add.w d0,(a4,$0052) == $000015aa [0000]
L000046ae       move.l a3,(a4,$000e) == $00001566 [00000000]
L000046b2       btst.l #$0007,d7
L000046b6       bne.w #$0198 == $00004850 (F)
L000046ba       move.w (a4,$004a) == $000015a2 [0000],d0
L000046be       btst.l #$0003,d7
L000046c2       beq.b #$12 == $000046d6 (T)
L000046c4       subq.b #$01,(a4,$0025) == $0000157d [00]
L000046c8       bne.b #$04 == $000046ce (F)
L000046ca       bclr.l #$0003,d7
L000046ce       sub.w (a4,$0026) == $0000157e [0000],d0
L000046d2       bra.w #$00d4 == $000047a8 (T)


L000046d6       btst.l #$0000,d7
L000046da       beq.b #$46 == $00004722 (T)
L000046dc       subq.b #$01,(a4,$0023) == $0000157b [00]
L000046e0       bcc.w #$00c6 == $000047a8 (T)
L000046e4       move.b (a4,$004f) == $000015a7 [00],d0
L000046e8       move.b (a4,$0050) == $000015a8 [00],d1
L000046ec       move.b d0,(a4,$0050) == $000015a8 [00]
L000046f0       ext.w d0
L000046f2       sub.w (a4,$003c) == $00001594 [0000],d0

L000046f6       add.w d0,d0
L000046f8       cmp.w #$ffd0,d0
L000046fc       blt.b #$06 == $00004704 (F)
L000046fe       cmp.w #$002c,d0
L00004702       ble.b #$16 == $0000471a (T)
L00004704       move.b (a4,$004f) == $000015a7 [00],d1
L00004708       move.b (a4,$0050) == $000015a8 [00],d2
L0000470c       move.w (a4,$003c) == $00001594 [0000],d3
L00004710       move.w (a4,$0054) == $000015ac [0000],d4
L00004714       movea.l (a4,$0006) == $0000155e [00000000],a2

L00004718       illegal
L0000471a       move.w (a5,d0.W,$00) == $00c014b6 [00c0],d0
L0000471e       bra.w #$0088 == $000047a8 (T)
L00004722       btst.l #$0001,d7
L00004726       beq.b #$5c == $00004784 (T)
L00004728       subq.b #$01,(a4,$0033) == $0000158b [00]
L0000472c       bne.b #$7a == $000047a8 (F)
L0000472e       movea.l (a4,$002c) == $00001584 [00000000],a0
L00004732       move.b (a0)+ [23],d0
L00004734       subq.b #$01,(a4,$0031) == $00001589 [00]

L00004738       bne.b #$0a == $00004744 (F)
L0000473a       movea.l (a4,$0028) == $00001580 [00000000],a0
L0000473e       move.b (a4,$0030) == $00001588 [00],(a4,$0031) == $00001589 [00]
L00004744       move.l a0,(a4,$002c) == $00001584 [00000000]
L00004748       move.b (a4,$0032) == $0000158a [00],(a4,$0033) == $0000158b [00]
L0000474e       add.b (a4,$0050) == $000015a8 [00],d0
L00004752       ext.w d0
L00004754       sub.w (a4,$003c) == $00001594 [0000],d0
L00004758       add.w d0,d0
L0000475a       cmp.w #$ffd0,d0

L0000475e       blt.b #$06 == $00004766 (F)
L00004760       cmp.w #$002c,d0
L00004764       ble.b #$16 == $0000477c (T)
L00004766       move.b (a4,$004f) == $000015a7 [00],d1
L0000476a       move.b (a4,$0050) == $000015a8 [00],d2
L0000476e       move.w (a4,$003c) == $00001594 [0000],d3
L00004772       move.w (a4,$0054) == $000015ac [0000],d4
L00004776       movea.l (a4,$0006) == $0000155e [00000000],a2
L0000477a       illegal
L0000477c       move.w (a5,d0.W,$00) == $00c014b6 [00c0],d0

L00004780       bra.w #$0026 == $000047a8 (T)
L00004784       btst.l #$0002,d7
L00004788       beq.b #$1e == $000047a8 (T)
L0000478a       subq.b #$01,(a4,$0037) == $0000158f [00]
L0000478e       bcc.b #$18 == $000047a8 (T)
L00004790       addq.b #$01,(a4,$0037) == $0000158f [00]
L00004794       subq.b #$01,(a4,$0039) == $00001591 [00]
L00004798       bne.b #$0a == $000047a4 (F)
L0000479a       neg.w (a4,$003a) == $00001592 [0000]
L0000479e       move.b (a4,$0038) == $00001590 [00],(a4,$0039) == $00001591 [00]
L000047a4       add.w (a4,$003a) == $00001592 [0000],d0
L000047a8       move.w d0,(a4,$004a) == $000015a2 [0000]
L000047ac       btst.l #$0004,d7
L000047b0       beq.w #$009e == $00004850 (T)
L000047b4       subq.w #$01,(a4,$001e) == $00001576 [0000]
L000047b8       bne.w #$0080 == $0000483a (F)
L000047bc       movea.l (a4,$0018) == $00001570 [00000000],a0
L000047c0       moveq #$00,d0
L000047c2       move.b (a0)+ [23],d0
L000047c4       beq.b #$42 == $00004808 (T)
L000047c6       bmi.b #$1a == $000047e2 (F)
L000047c8       move.w d0,(a4,$001e) == $00001576 [0000]
L000047cc       move.b #$01,(a4,$001c) == $00001574 [00]
L000047d2       move.b #$01,(a4,$001d) == $00001575 [00]
L000047d8       move.b (a0)+ [23],(a4,$0020) == $00001578 [00]
L000047dc       move.l a0,(a4,$0018) == $00001570 [00000000]
L000047e0       bra.b #$58 == $0000483a (T)
L000047e2       neg.b d0
L000047e4       move.w d0,(a4,$001e) == $00001576 [0000]
L000047e8       move.b #$01,(a4,$0020) == $00001578 [00]
L000047ee       move.b (a0)+ [23],d0
L000047f0       bpl.b #$06 == $000047f8 (T)
L000047f2       neg.b d0
L000047f4       neg.b (a4,$0020) == $00001578 [00]
L000047f8       move.b d0,(a4,$001c) == $00001574 [00]
L000047fc       move.b #$01,(a4,$001d) == $00001575 [00]
L00004802       move.l a0,(a4,$0018) == $00001570 [00000000]
L00004806       bra.b #$32 == $0000483a (T)
L00004808       move.b (a0) [23],d0
L0000480a       beq.b #$0a == $00004816 (T)
L0000480c       bpl.b #$02 == $00004810 (T)
L0000480e       neg.b d0
L00004810       sub.w (a4,$0052) == $000015aa [0000],d0
L00004814       bmi.b #$06 == $0000481c (F)
L00004816       bclr.l #$0004,d7
L0000481a       bra.b #$34 == $00004850 (T)
L0000481c       neg.w d0
L0000481e       move.w d0,(a4,$001e) == $00001576 [0000]
L00004822       move.b #$00,(a4,$001c) == $00001574 [00]
L00004828       move.b #$00,(a4,$001d) == $00001575 [00]
L0000482e       move.b #$00,(a4,$0020) == $00001578 [00]
L00004834       move.l a0,(a4,$0018) == $00001570 [00000000]
L00004838       bra.b #$16 == $00004850 (T)
L0000483a       subq.b #$01,(a4,$001d) == $00001575 [00]
L0000483e       bne.b #$10 == $00004850 (F)
L00004840       move.b (a4,$001c) == $00001574 [00],(a4,$001d) == $00001575 [00]
L00004846       move.b (a4,$0020) == $00001578 [00],d0
L0000484a       ext.w d0
L0000484c       add.w d0,(a4,$004c) == $000015a4 [0000]
L00004850       rts  == $00fc072a




L00004852       move.w $417c [0000],d0
L00004856       beq.b #$6e == $000048c6 (T)
L00004858       move.w d0,(a6,$0096) == $00c03b3a [0100]
L0000485c       move.w d0,d1
L0000485e       lsl.w #$07,d1
L00004860       move.w d1,(a6,$009c) == $00c03b40 [0000]
L00004864       moveq #$00,d2
L00004866       moveq #$01,d3
L00004868       btst.l #$0000,d0
L0000486c       beq.b #$08 == $00004876 (T)
L0000486e       move.w d3,(a6,$00a6) == $00c03b4a [0000]
L00004872       move.w d2,(a6,$00aa) == $00c03b4e [0000]
L00004876       btst.l #$0001,d0
L0000487a       beq.b #$08 == $00004884 (T)
L0000487c       move.w d3,(a6,$00b6) == $00c03b5a [ff3e]
L00004880       move.w d2,(a6,$00ba) == $00c03b5e [00fd]
L00004884       btst.l #$0002,d0
L00004888       beq.b #$08 == $00004892 (T)
L0000488a       move.w d3,(a6,$00c6) == $00c03b6a [00fd]
L0000488e       move.w d2,(a6,$00ca) == $00c03b6e [4ef9]
L00004892       btst.l #$0003,d0
L00004896       beq.b #$08 == $000048a0 (T)
L00004898       move.w d3,(a6,$00d6) == $00c03b7a [4ef9]
L0000489c       move.w d2,(a6,$00da) == $00c03b7e [fedc]
L000048a0       move.w (a6,$001e) == $00c03ac2 [0000],d2
L000048a4       and.w d1,d2
L000048a6       cmp.w d1,d2
L000048a8       bne.b #$f6 == $000048a0 (F)
L000048aa       moveq #$02,d2
L000048ac       move.w (a6,$0006) == $00c03aaa [39c8],d3
L000048b0       and.w #$ff00,d3
L000048b4       move.w (a6,$0006) == $00c03aaa [39c8],d4
L000048b8       and.w #$ff00,d4
L000048bc       cmp.w d4,d3
L000048be       beq.b #$f4 == $000048b4 (T)
L000048c0       move.w d4,d3
L000048c2       dbf .w d2,#$fff0 == $000048b4 (F)
L000048c6       move.w $401c [ffff],d1
L000048ca       move.w $401e [ffff],d2
L000048ce       lea.l  channel_1_status,a0                            ;$4024,a0
L000048d2       move.w d1,d3
L000048d4       btst.b #$0006,(a0) [23]
L000048d8       beq.b #$02 == $000048dc (T)
L000048da       move.w d2,d3
L000048dc       and.w (a0,$004c) == $00fe9762 [2269],d3
L000048e0       move.w d3,(a6,$00a8) == $00c03b4c [0000]
L000048e4       move.w (a0,$004a) == $00fe9760 [2051],(a6,$00a6) == $00c03b4a [0000]
L000048ea       btst.l #$0000,d0
L000048ee       beq.b #$0e == $000048fe (T)
L000048f0       move.w (a0,$0042) == $00fe9758 [2040],(a6,$00a4) == $00c03b48 [0000]
L000048f6       move.l (a0,$003e) == $00fe9754 [23400004],(a6,$00a0) == $00c03b44 [00c03b06]
L000048fc       bra.b #$0c == $0000490a (T)

L000048fe       move.w (a0,$0048) == $00fe975e [2209],(a6,$00a4) == $00c03b48 [0000]
L00004904       move.l (a0,$0044) == $00fe975a [20894e75],(a6,$00a0) == $00c03b44 [00c03b06]
L0000490a       lea.l $407a,a0
L0000490e       move.w d1,d3
L00004910       btst.b #$0006,(a0) [23]
L00004914       beq.b #$02 == $00004918 (T)
L00004916       move.w d2,d3
L00004918       and.w (a0,$004c) == $00fe9762 [2269],d3
L0000491c       move.w d3,(a6,$00b8) == $00c03b5c [4ef9]
L00004920       move.w (a0,$004a) == $00fe9760 [2051],(a6,$00b6) == $00c03b5a [ff3e]
L00004926       btst.l #$0001,d0
L0000492a       beq.b #$0e == $0000493a (T)
L0000492c       move.w (a0,$0042) == $00fe9758 [2040],(a6,$00b4) == $00c03b58 [00fd]
L00004932       move.l (a0,$003e) == $00fe9754 [23400004],(a6,$00b0) == $00c03b54 [fc6a4ef9]
L00004938       bra.b #$0c == $00004946 (T)
L0000493a       move.w (a0,$0048) == $00fe975e [2209],(a6,$00b4) == $00c03b58 [00fd]
L00004940       move.l (a0,$0044) == $00fe975a [20894e75],(a6,$00b0) == $00c03b54 [fc6a4ef9]
L00004946       lea.l $40d0,a0
L0000494a       move.w d1,d3
L0000494c       btst.b #$0006,(a0) [23]
L00004950       beq.b #$02 == $00004954 (T)
L00004952       move.w d2,d3
L00004954       and.w (a0,$004c) == $00fe9762 [2269],d3
L00004958       move.w d3,(a6,$00c8) == $00c03b6c [ff14]
L0000495c       move.w (a0,$004a) == $00fe9760 [2051],(a6,$00c6) == $00c03b6a [00fd]
L00004962       btst.l #$0002,d0
L00004966       beq.b #$0e == $00004976 (T)
L00004968       move.w (a0,$0042) == $00fe9758 [2040],(a6,$00c4) == $00c03b68 [4ef9]
L0000496e       move.l (a0,$003e) == $00fe9754 [23400004],(a6,$00c0) == $00c03b64 [00fdff26]
L00004974       bra.b #$0c == $00004982 (T)
L00004976       move.w (a0,$0048) == $00fe975e [2209],(a6,$00c4) == $00c03b68 [4ef9]
L0000497c       move.l (a0,$0044) == $00fe975a [20894e75],(a6,$00c0) == $00c03b64 [00fdff26]
L00004982       lea.l $4126,a0
L00004986       move.w d1,d3
L00004988       btst.b #$0006,(a0) [23]
L0000498c       beq.b #$02 == $00004990 (T)
L0000498e       move.w d2,d3
L00004990       and.w (a0,$004c) == $00fe9762 [2269],d3
L00004994       move.w d3,(a6,$00d8) == $00c03b7c [00fd]
L00004998       move.w (a0,$004a) == $00fe9760 [2051],(a6,$00d6) == $00c03b7a [4ef9]
L0000499e       btst.l #$0003,d0
L000049a2       beq.b #$0e == $000049b2 (T)
L000049a4       move.w (a0,$0042) == $00fe9758 [2040],(a6,$00d4) == $00c03b78 [feee]
L000049aa       move.l (a0,$003e) == $00fe9754 [23400004],(a6,$00d0) == $00c03b74 [4ef900fd]
L000049b0       bra.b #$0c == $000049be (T)
L000049b2       move.w (a0,$0048) == $00fe975e [2209],(a6,$00d4) == $00c03b78 [feee]
L000049b8       move.l (a0,$0044) == $00fe975a [20894e75],(a6,$00d0) == $00c03b74 [4ef900fd]
L000049be       or.w #$8000,d0
L000049c2       move.w d0,(a6,$0096) == $00c03b3a [0100]
L000049c6       clr.w $417c [0000]
L000049ca       rts  == $00fc072a



                ;------------------- initislise music samples --------------------
                ; extract sample data ptrs and lengths from the IFF sample
                ; data.
                ;
                ; IN: a0    - music sample table address $4D52 - default_sample_data
                ; IN: a1    - music/song instrument data $4BFA - instrument_data
                ;
initialise_music                                        ; original routine address L000049cc
                move.l  (a0)+,d0                        ; d0 = sound sample byte offset
                beq.b   .exit                           ; if d0 == 0 then exit
                move.w  (a0)+,(a1)                      ; copy sample volume
                move.w  (a0)+,$000e(a1)                 ; copy param value2 (unknown, 0 or -1)
                move.l  a0,-(a7)                        ; save a0 - incremented ptr to stack
                                                        ; d0 is offset to data within the structure
                lea.l   $f8(a0,d0.l),a0                 ; a0 = ptr to start of iff sample 'FORM' structure.
                move.l  $0004(a0),d0                    ; d0 = Length of 'FORM' data structure (sample data)
                addq.l  #$08,d0                         ; d0 = alter length to include 'FORM' and length header value, d0 = total file len from A0.
                bsr.w   process_instrument              ; calls L000049ec
                movea.l (a7)+,a0                        ; a0 = next sample table entry
                bra.b   initialise_music                ; jmp L000049cc ; loop for next sample data.
.exit
                rts     



                ; ------------------ process instrument  ----------------
                ; IN: A0 = ptr to start of 'FORM' block of sample data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of sample including headers.
                ;
process_instrument                                      ; original routine address L000049ec
                move.l  a1,-(a7)                        ; Save ptr to Instrument Details
                bsr.w   process_sample_data             ; calls L00004a30
                movea.l (a7)+,a1                        ; Restore ptr to Instrument Details
                addaq.l #$02,a1                         ; a1 = skip first param value (volume) offset 0-1
                movea.l sample_vhdl_ptr,a0              ; L00004b3e,a0
                move.l  (a0)+,d0                        ; d0 = sample length length
                bclr.l  #$0000,d0                       ; d0 = make length even
                move.l  (a0)+,d1                        ; d1 = sample repeat length 
                bclr.l  #$0000,d1                       ; d1 = make repeat length even
                movea.l sample_body_ptr,a0              ; a0 = start of sample data, $00004b64,a0
                move.l  a0,(a1)+                        ; store sample start address in instrument table offset 2-5
                adda.l  d0,a0                           ; a0 = start of repeat section of sample
                add.l   d1,d0                           ; d0 = total length of sample + repeat
                lsr.l   #$01,d0                         ; d0 = count of word length
                move.w  d0,(a1)+                        ; store sample length (words) in table offset 6-7
                tst.l   d1                              ; test repeat length
                bne.b   .set_repeat
.no_repeat
                lea.l   silient_repeat,a0               ; $00004d3a,a0 ; set default 0 value for silent repeat
                moveq   #$02,d1                         ; set single word length for silent repeat.
.set_repeat
                move.l  a0,(a1)+                        ; set repeat start address in table offset 8 - 11
                lsr.l   #$01,d1                         ; d1 = repeat length (words)
                move.w  d1,(a1)+                        ; set repeat length (words) in table offset 12-13
                addaq.l #$02,a1                         ; update instrument table ptr (skip param 2 - unknown 0 or -1 value) - 14-15
                rts  



                ;------------------ process sample data --------------------------
                ; Walks through the IFF 8SVX file format, storing the pointers to
                ; the BODY and VHDL chunks in the variables.
                ;
                ; Also, sets the error/status 'sample_status' - 0 = success
                ;
                ; IN: A0 = ptr to start of 'FORM' or 'CAT ' block of sample data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of sample including headers.
                ;
sample_status                                   ; original variable address L00004a2e
                dc.w    $0000                   ; error/status flag
                                                ; 1 = missing FORM/CAT chunk
                                                ; 2 = missing 8SVX chunk

process_sample_data                             ; original routine address L00004a30
                clr.w   sample_status           ; L00004a2e 
                movem.l d0/a0,-(a7)
                bra.w   process_inner_chunk
process_inner_chunk
                tst.l   d0                      ; test sample length
                beq.b   .exit
                move.l  (a0)+,d1                ; d1 = Chunk Name
                subq.l  #$04,d0                 ; d0 = remaining bytes
                bsr.w   process_sample_chunk    ; calls L00004a50 ; process iff chunks
                bra.b   process_inner_chunk     ; jmp L00004a3c ; loop while data remaining
.exit
                movem.l (a7)+,d0/a0
                rts



                ;------------------ process sample chunk ------------------
                ; process IFF sample data, top level of file structure.
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of sample including headers.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
process_sample_chunk                            ; original routine address L00004a50
                cmp.l   'FORM',d1               ; #$464f524d,d1
                beq.w   process_form_chunk      ; jmp L00004aac ; process FORM chunk
                cmp.l   'CAT ',d1               ; #$43415420,d1
                beq.w   process_cat_chunk       ; jmp L00004a6e ; process CAT chunk
                move.w  #$0001,sample_status    ; L00004a2e ; error status flag?
                clr.l   d0                      ; clear remaining byte length
                rts



                ;--------------------- process CAT chunk --------------------------
                ; skips header and continues processing inner chunk data.
                ;
                ; IN: A0 = ptr to length of chunk data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of outer chunk.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
process_cat_chunk                               ; original routine address L00004a6e
                movem.l d0/a0,-(a7)
                move.l  (a0)+,d0                ; d0 = chunk length
                move.l  d0,d1                   ; d1 = chunk length
                btst.l  #$0000,d1               ; test odd/even length
                beq.b   .no_pad_byte            ; is even, no pad byte
.add_pad_byte
                addq.l  #$01,d1                 ; is odd, add pad byte
.no_pad_byte
                addq.l  #$04,d1                 ; add length field to chunk len
                add.l   d1,$0004(a7)            ; update address ptr on stack (end of chunk)
                sub.l   d1,(a7)                 ; subtract chunk length from remaining bytes on stack
                addq.l  #$04,(a0)
                subq.l  #$04,d0                 ; subtract remaining bytes
                bra.b   process_inner_chunk     ; jmp L00004a3c



                ;------------------- process LIST chunk -----------------
                ; skip the list chunk, and continue processing
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of remaining data.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
process_list_chunk
                movem.l d0/a0,-(a7)
                move.l  (a0)+,d0
                move.l  d0,d1
                btst.l  #$0000,d1
                beq.b   .no_pad_byte
.add_pad_byte
                addq.l  #$01,d1
.no_pad_byte
                addq.l  #$04,d1
                add.l   d1,$0004(a7)
                sub.l   d1,(a7)
                nop
                movem.l (a7)+,d0/a0
                rts



                ;---------------- process FORM chunk ------------------
                ; Expects to find an '8SVX' inner chunk of data.
                ; If not, then sets error/status flag = $0002
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of sample including headers.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
process_form_chunk                              ; original routine address L00004aac
                movem.l d0/a0,-(a7)
                move.l  (a0)+,d0                ; d0 = length of FORM data
                move.l  d0,d1                   ; d1 = length of FORM data
                btst.l  #$0000,d1               ; check of length is odd
                beq.b   .n o_pad_byte           ; even length (no pad byte required)
.add_pad_byte
                addq.l  #$01,d1                 ; odd length (add pad byte)
.no_pad_byte
                addq.l  #$04,d1                 ; add length field to chunk len
                add.l   d1,,$0004(a7)           ; update address ptr on stack (end of chunk)
                sub.l   d1,(a7)                 ; subtract chunk length from remaining bytes on stack
                move.l  (a0)+,d1                ; d1 = inner chunk identifer
                subq.l  #$04,d0                 ; d0 = updated remaining bytes
                cmp.l   '8SVX',d1               ; #$38535658,d1
                beq.w   process_8svx_chunk      ; jmp L00004ade ; process 8SVX chunk
                move.w  #$0002,sample_status    ; L00004a2e ; error/status flag
                movem.l (a7)+,d0/a0
                rts



                ;------------------ process 8SVX chunk ---------------------
                ; loops through sample data until no bytes remaining.
                ; processes inner chunks of 8SVX chunk, including:-
                ;  - VHDL, BODY, NAME, ANNO
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of remaining data.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
process_8svx_chunk
                tst.l   d0                              ; test end of sample data
                beq.b   .exit                           ; if so, then exit
                move.l  (a0)+,d1                        ; d1 = inner chunk identifier
                subq.l  #$04,d0                         ; d0 = updated remaining bytes
                bsr.w   process_inner_8svx_chunk        ; calls $00004af2
                bra.b   process_8svx_chunk              ; jmp L00004ade ; loop until no bytes remaining.
.exit
                movem.l (a7)+,d0/a0                     ; exit
                rts



                ;---------------- process inner 8SVX chunk --------------
                ; process data held inside the 8SVX chunk, this is only
                ; concerned with the VHDL and BODY chunks. it skips
                ; other chunks such as the NAME, ANNO meta data chunks.
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of remaining data.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
process_inner_8svx_chunk                                ; original routine address L00004af2
                cmp.l   'FORM',d1                       ;#$464f524d,d1
                beq.b   process_form_chunk              ; jmp L00004aac
                cmp.l   'LIST',d1                       ;#$4c495354,d1
                beq.b   process_list_chunk              ; jmp L00004a8c
                cmp.l   'CAT ',d1                       ;#$43415420,d1
                beq.w   process_cat_chunk               ; jmp L00004a6e
                cmp.l   'VHDL',d1                       ;#$56484452,d1
                beq.w   process_vhdl_chunk              ; jmp L00004b42
                cmp.l   'BODY',d1                       ;#$424f4459,d1
                beq.w   process_body_chunk              ; L00004b68
.skip_unused_chunks
                movem.l d0/a0,-(a7)
                move.l  (a0)+,d0
                move.l  d0,d1
                btst.l  #$0000,d1
                beq.b   .no_pad_byte
.add_pad_byte
                addq.l  #$01,d1
.no_pad_byte
                addq.l  #$04,d1
                add.l   d1,$0004(a7)
                sub.l   d1,(a7)
                movem.l (a7)+,d0/a0
                rts



                ;-------------------- process VHDL chunk ----------------------
                ; stores address of VHDL chunk in variable 'sample_vhdl_ptr'
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of remaining data.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
sample_vhdl_ptr                                 ; original var address L00004b3e
                dc.l    $00017F66               ; original address L00004b3e

process_vhdl_chunk                              ; original address L00004b42
                movem.l d0/a0,-(a7)
                move.l  (a0)+,d0                ; d0 = length of chunk
                move.l  d0,d1                   ; d1 = length of chunk
                btst.l  #$0000,d1               ; is pad byte required (odd length)
                beq.b   .no_pad_byte            ; no pad byte (length is even)
.add_pad_byte
                addq.l  #$01,d1                 ; add pad byte (make length even)
.no_pad_byte
                addq.l  #$04,d1                 ; update chunk length (include length field)
                add.l   d1,$0004(a7)            ; update A0 data ptr on stack (end of chunk)
                sub.l   d1,(a7)                 ; update d0 remaining data on stack
                move.l  a0,sample_vhdl_ptr      ; L00004b3e ; store address of VHDL chunk
                movem.l (a7)+,d0/a0
                rts



                ;------------------------- process body chunk ------------------------
                ; store address of the raw sample data in variable 'sample_body_ptr'
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of remaining data.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
sample_body_ptr                                 ; original var address L0004b64
                dc.l    $00017FBA               ; body data ptr (raw sample data)

process_body_chunk                              ; original routine address L0004b68
                movem.l d0/a0,-(a7)
                move.l  (a0)+,d0                ; d0 = body length
                move.l  d0,d1                   ; d1 = body length
                btst.l  #$0000,d1               ; check for odd length
                beq.b   .no_pad_byte            ; even length (no pad byte)
.add_pad_byte
                addq.l  #$01,d1
.no_pad_byte
                addq.l  #$04,d1                 ; update chunk length (include length field)
                add.l   d1,$0004(a7)            ; update A0 data ptr on stack (end of chunk)
                sub.l   d1,(a7)                 ; update d0 remaining data on stack
                move.l  a0,sample_body_ptr      ; L0004b64 ; store address of raw sample data
                movem.l (a7)+,d0/a0
                rts



                ; unknown data
L00004B8A       dc.w  $06FE, $0699, $063B, $05E1, $058D, $053D, $04F2, $04AB          ;.....;.....=....
L00004B9A       dc.w  $0467, $0428, $03EC, $03B4, $037F, $034D, $031D, $02F1          ;.g.(.......M....
L00004BAA       dc.w  $02C6, $029E, $0279, $0255, $0234, $0214, $01F6, $01DA          ;.....y.U.4......
L00004BBA       dc.w  $01BF, $01A6, $018F, $0178, $0163, $014F, $013C, $012B        ;.......x.c.O.<.+
L00004BCA       dc.w  $011A, $010A, $00FB, $00ED, $00E0, $00D3, $00C7, $00BC          ;................
L00004BDA       dc.w  $00B2, $00A8, $009E, $0095, $008D, $0085, $007E, $0077          ;.............~.w
L00004BEA       dc.w  $0021, $0000, $4D3C, $000B, $0000, $4D3C, $000B, $0000          ;.!..M<....M<....



                ;---------------- music data, maybe instrument data ------------------
                ; I think each 16 bytes represents data describing a sound/instrument.
                ; There are 12 samples in the Sample Data and 12 entries below.
                ; THe table below could have room for 20 or 21 entries (only 12 in use)
                ; the parameters from the SampleTable below @ $00004D52 'default_sample_data' 
                ; are copied into this table.
                ;
                ;       - The 16bit value offset 4 of each sample is copied to offset 0 of this table.
                ;       - The 16bit value offset 6 of each sample is copied to offset $e (14) of this table.
                ;
                ; I guess that this may be reseting values for the insrument volume (param 1)
                ; and a second param (unsure, values either 0, or -1). could be a repeat value 
                ; or something similar.
                ;
                ; I think the following table is used during the playing of the song(s),
                ; and keeps track of the instrument settings for each sample 
                ; (which may change during the playhing of the song?)
                ;
                ; I think the following format.
                ;
                ; Offset        | Size          | Description
                ;---------------+---------------+-----------------------------------------
                ; 0             | 2             | I think default sample volume
                ; 2             | 4             | Sample Data Start Address
                ; 6             | 2             | Sample Length in Words
                ; 8             | 4             | Sample Repeat Start Address
                ; 12            | 2             | Sample Repeat Length in Words
                ; 14            | 2             | Unknown Parameter, values either 0 or -1
                ;
instrument_data                                                                 ; original address L00004BFA
.instrument_01  dc.w  $0018, $0000, $4E1E, $1C5C, $0000, $4D3A, $0001, $0000    ; original address L00004BFA
.instrument_02  dc.w  $0018, $0000, $873E, $1703, $0000, $4D3A, $0001, $0000    ; original address L00004C0A
.instrument_03  dc.w  $000C, $0000, $B5AC, $0A02, $0000, $4D3A, $0001, $FFFF    ; original address L00004C1A
.instrument_04  dc.w  $0018, $0000, $CA18, $0A28, $0000, $4D3A, $0001, $FFFF    ; original address L00004C2A
.instrument_05  dc.w  $0030, $0000, $DED0, $012B, $0000, $4D3A, $0001, $FFFF    ; original address L00004C3A
.instrument_06  dc.w  $0032, $0000, $E18E, $05CF, $0000, $4D3A, $0001, $FFFF  ; original address L00004C4A
.instrument_07  dc.w  $0011, $0000, $ED94, $06B8, $0000, $4D3A, $0001, $0000    ; original address L00004C5A
.instrument_08  dc.w  $0038, $0000, $FB6C, $0666, $0000, $4D3A, $0001, $0000    ; original address L00004C6A
.instrument_09  dc.w  $0014, $0001, $08A0, $05E1, $0000, $4D3A, $0001, $0000    ; original address L00004C7A
.instrument_10  dc.w  $003E, $0001, $14CA, $11D6, $0001, $2DE0, $054B, $0000    ; original address L00004C8A
.instrument_11  dc.w  $0018, $0001, $38DE, $233A, $0000, $4D3A, $0001, $0000    ; original address L00004C9A
.instrument_12  dc.w  $0018, $0001, $7FBA, $1CE6, $0000, $4D3A, $0001, $0000    ; original address L00004CAA
.instrument_13  dc.w  $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000    ; original address L00004CBA
.instrument_14  dc.w  $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000    ; original address L00004CCA
.instrument_15  dc.w  $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000    ; original address L00004CDA
.instrument_16  dc.w  $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000    ; original address L00004CEA
.instrument_17  dc.w  $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000    ; original address L00004CFA
.instrument_18  dc.w  $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000    ; original address L00004D0A
.instrument_19  dc.w  $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000    ; original address L00004D1A
.instrument_20  dc.w  $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000    ; original address L00004D2A

silient_repeat                                                                  ; original address L00004D3A
                dc.w  $0000                                                     ; repeat data for end of non-repeating samples (2 bytes)

                ; -- unknown data values (11 words/22 bytes)
L00004D3C       dc.w  $0074, $60DC, $82BB, $457E, $24A0, $8C00, $7460
L00004D4A       dc.w  $DC82, $BB45, $7E24, $A08C



                ; ------ music sample data table (12 sample offsets & 2 word params) ------
                ; 12 sound samples in IFF 8SVX format.
                ; Table of address offsets below, not sure what the additional two 16 bit 
                ; parameters that follow the offset represent yet. maybe volume and something else.
                ;
                                                                                ; Offset Calc   | Start       | Name           | End
default_sample_data                                                             ;---------------+-------------+----------------+----------
.data_01        dc.w  $0000, $0064, $0018, $0000                                ; $4D52 + $0064 = $00004DB6   - WHATRU         - $000086D6
.data_02        dc.w  $0000, $397C, $0018, $0000                                ; $4D5A + $3972 = $000086D6   - IMBATMAN       - $0000B544 
.data_03        dc.w  $0000, $67E2, $000C, $FFFF                                ; $4D62 + $67E2 = $0000B544   - HITBASS-C1     - $0000C9B0
.data_04        dc.w  $0000, $7C46, $0018, $FFFF                                ; $4D6A + $7C46 = $0000C9B0   - HITSNARE-C2    - $0000DE68 
.data_05        dc.w  $0000, $90F6, $0030, $FFFF                                ; $4D72 + $90F6 = $0000DE68   - KIT-HIHAT-C4   - $0000E126
.data_06        dc.w  $0000, $93AC, $0032, $FFFF                                ; $4D7A + $93AC = $0000E126   - KIT-OPENHAT-D4 - $0000ED2C
.data_07        dc.w  $0000, $9FAA, $0011, $0000                                ; $4D82 + $9FAA = $0000ED2C   - BASS2-F        - $0000FB04
.data_08        dc.w  $0000, $AD7A, $0038, $0000                                ; $4D8A + $AD7A = $0000FB04   - TIMELESS-GS    - $00010838
.data_09        dc.w  $0000, $BAA6, $0014, $0000                                ; $4D92 + $BAA6 = $00010838   - TIMEBASS-GS    - $00011462
.data_10        dc.w  $0000, $C6C8, $003E, $0000                                ; $4D9A + $C6C8 = $00011462   - CRUNCHGUITAR-C4- $00013876
.data_11        dc.w  $0000, $EAD4, $0018, $0000                                ; $4DA2 + $EAD4 = $00013876   - LAUGH          - $00017F52
.data_12        dc.w  $0001, $31A8, $0018, $0000                              ; $4DAA + $131A8 = $00017F52  - IWANNA         - $0001B986
.data_end       dc.w  $0000, $0000                                              ; 0 marks the end of sample table data



                ; --------------------- Sound Sample 1 -------------------
                ; Start Address: $00004DB6
                ; End Address:   $000086D5
                ; Name:          WHATRU 
                ; sample_01:     original address $00004DB6
                include "./music/sample_01.s"


                ; --------------------- Sound Sample 2 -------------------
                ; Start Address: $000086D6
                ; End Address:   $0000B543
                ; Name:          IMBATMAN 
                ; sample_02:     ; original address $000086D6
                include "./music/sample_02.s"


                ; --------------------- Sound Sample 3 -------------------
                ; Start Address: $0000B544
                ; End Address:   $0000C9AF
                ; Name:          HITBASS-C1
                ; sample_03      ; original address $0000B544
                include "./music/sample_03.s"


                ; --------------------- Sound Sample 4 -------------------
                ; Start Address: $0000C9B0
                ; End Address:   $0000DE67
                ; Name:          HITSNARE-C2
                ; sample_04     ; original address $0000C9B0
                include "./music/sample_04.s"


                ; --------------------- Sound Sample 5 -------------------
                ; Start Address: $0000DE68
                ; End Address:   $0000E125
                ; Name:          KIT-HIHAT-C4 
                ; sample_05      ; original address $0000DE68
                include "./music/sample_05.s"
                
                
                ; --------------------- Sound Sample 6 -------------------
                ; Start Address: $0000E126
                ; End Address:   $0000ED2B
                ; Name:          KIT-OPENHAT-D4
                ; sample_06      ; original address $0000E126
                include "./music/sample_06.s"

                

                ; --------------------- Sound Sample 7 -------------------
                ; Start Address: $0000ED2C
                ; End Address:   $0000FB04
                ; Name:          BASS2-F
                ; sample_07      ; original address $0000ED2C
                include "./music/sample_07.s"

                
                ; --------------------- Sound Sample 8 -------------------
                ; Start Address: $0000FB04
                ; End Address:   $00010837
                ; Name:          TIMELESS-GS
                ; sample_08      ; original address $0000FB04
                include "./music/sample_08.s"


                ; --------------------- Sound Sample 9 -------------------
                ; Start Address: $00010838
                ; End Address:   $00011461
                ; Name:          TIMEBASS-GS
                ; sample_09      ; original address $00010838
                include "./music/sample_09.s"
                
                
                ; --------------------- Sound Sample 10 -------------------
                ; Start Address: $00011462
                ; End Address:   $00013875
                ; Name:          CRUNCHGUITAR-C4
                ; sample_10      ; original address $00011462
                include "./music/sample_10.s"


                ; --------------------- Sound Sample 11 -------------------
                ; Start Address: $00013876
                ; End Address:   $00017F51
                ; Name:          LAUGH
                ; sample_11      ; original address $00013876
                include "./music/sample_11.s"


                ; --------------------- Sound Sample 12 -------------------
                ; Start Address: $00017F52
                ; End Address:   $0001B985
                ; Name:          IWANNA
                ; sample_12      ; original address $00017F52
                include "./music/sample_12.s"

                ; ------------- end of sample data ---------------



L0001B986 dc.w $0002, $0202                                                     ;................
L0001B98A dc.w $000C, $0014, $0018, $001C, $001E, $0020, $0025, $002B           ;........... .%.+
L0001B99A dc.w $0031, $0037, $0039, $013C, $1EFE, $0000, $0119, $08FD           ;.1.7.9.<........
L0001B9AA dc.w $0000, $011E, $0000, $013E, $0000, $020F, $07FF, $000A           ;.......>........
L0001B9BA dc.w $FF01, $1902, $F605, $FF00, $0001, $190B, $FE01, $FE00           ;................
L0001B9CA dc.w $0001, $2A14, $FE01, $FE00, $0001, $3E00, $0001, $3200           ;..*.......>...2.

L0001B9DA dc.w $0000 

                ; 4 values per song entry (channel settings)
                ; each value is an offset to the channel data below it.
                ; song1:
                ;       channel1: 3e + 1b9dc = 1ba1a
                ;       channel2: 48 + 1b9de = 1ba26
                ;       channel3: 49 + 1b9e0 = 1ba29
                ;       channel4: 51 + 1b9e2 = 1ba33
                ; song2:
                ;       channel1: off
                ;       channel2: off
                ;       channel3: off
                ;       channel4: 0a + 1b9ea = 1b9f4
                ;
                ; song3:
                ;       channel1: off
                ;       channel2: off
                ;       channel3: off
                ;       channel4: 04 + 1b9f2 = 
song_table                                      ; original address $0001b9dc
L0001b9dc       dc.w $003E, $0048, $0049, $0051         ; 00
L0001b9e4       dc.w $0000, $0000, $0000, $000A         ; 08
L0001b9ec       dc.w $0000, $0000, $0000, $0004         ; 16

song2_channel_4       
L0001B9F4       dc.b $07, $80 
song3_channel_4
L0001B9F6       dc.b $08, $80 

L0001B9F8       dc.b $90, $0B   

L0001B9FA       dc.b $8F, $03, $18, $96, $80

L0001B9FF       dc.b $90, $0C, $8F, $03, $18, $96, $80

L0001BA06       dc.w $0038, $003A

L0001BA0A       dc.w $0081, $0156, $01A3, $01BC, $01CF, $FFE4, $FFE9, $0222



song1_channel_1  ; 1b9dc + 3e = 1ba1a
L0001BA1A       dc.b $81, $83, $08, $00, $01, $01, $01, $01, $83, $08, $00, $80
song1_channel_2 
L0001BA26       dc.b $81, $02, $80
song1_channel_3
L0001BA29       dc.b $81, $03, $03, $03, $03, $03, $03, $06, $06, $80
song1_channel_4
L0001BA33       dc.b $81, $83, $08, $00, $04, $05, $05    


L0001BA3A dc.w $8308, $0080, $8587, $6080, $8F01, $9008, $8E8C, $8406           ;......`.........
L0001BA4A dc.w $383A, $3F38, $3A3F, $383A, $3F38, $3A3F, $383A, $3F38           ;8:?8:?8:?8:?8:?8
L0001BA5A dc.w $3A3F, $383A, $3F38, $3A3F, $383A, $3F38, $3A3F, $383A           ;:?8:?8:?8:?8:?8:
L0001BA6A dc.w $3F38, $3A3F, $383A, $3F38, $3A3F, $383A, $3F38, $3A3F           ;?8:?8:?8:?8:?8:?
L0001BA7A dc.w $383A, $3F38, $3A3F, $383A, $3F38, $3A3F, $383A, $3F3A           ;8:?8:?8:?8:?8:?:
L0001BA8A dc.w $808F, $0290, $030C, $0690, $0540, $0690, $0641, $0690           ;.........@...A..
L0001BA9A dc.w $0540, $0690, $0418, $0C90, $0641, $0C90, $030C, $0690           ;.@.......A......
L0001BAAA dc.w $0540, $0690, $0641, $0690, $0540, $0690, $0418, $0C90           ;.@...A...@......
L0001BABA dc.w $0641, $0690, $0540, $0690, $030C, $0690, $0540, $0690           ;.A...@.......@..
L0001BACA dc.w $0641, $0690, $0540, $0690, $0418, $0C90, $0641, $0C90           ;.A...@.......A..
L0001BADA dc.w $030C, $0690, $0540, $0690, $0641, $0690, $0540, $0690           ;.....@...A...@..
L0001BAEA dc.w $0418, $0C90, $0641, $0690, $0418, $0690, $030C, $0690           ;.....A..........
L0001BAFA dc.w $0540, $0690, $0641, $0690, $0540, $0690, $0418, $0C90           ;.@...A...@......
L0001BB0A dc.w $0641, $0C90, $030C, $0690, $0540, $0690, $0641, $0690           ;.A.......@...A..
L0001BB1A dc.w $0540, $0690, $0418, $0C90, $0641, $0690, $0540, $0690           ;.@.......A...@..
L0001BB2A dc.w $030C, $0690, $0540, $0690, $0641, $0690, $0540, $0690           ;.....@...A...@..
L0001BB3A dc.w $0418, $0C90, $0641, $0C90, $030C, $0690, $0540, $0690           ;.....A.......@..
L0001BB4A dc.w $0641, $0690, $0540, $0690, $0418, $0690, $0418, $0690           ;.A...@..........
L0001BB5A dc.w $0418, $0690, $0418, $0680, $9007, $8F02, $8E8C, $140C           ;................
L0001BB6A dc.w $200C, $200C, $1406, $1E0C, $1406, $200C, $1E0C, $200C           ; . ....... ... .
L0001BB7A dc.w $0F0C, $1B0C, $1B0C, $0F06, $190C, $0F06, $1B0C, $190C           ;................
L0001BB8A dc.w $1B0C, $120C, $1E0C, $1E0C, $1206, $1E0C, $1206, $1E0C           ;................
L0001BB9A dc.w $200C, $220C, $0D0C, $190C, $190C, $0D06, $190C, $0D06           ; .".............
L0001BBAA dc.w $190C, $1E0C, $200C, $808F, $0390, $0187, $5423, $9090           ;.... .......T#..
L0001BBBA dc.w $0223, $0623, $9690, $0187, $5423, $0623, $8A90, $0223           ;.#.#....T#.#...#
L0001BBCA dc.w $9C80, $900A, $8F04, $8B14, $0103, $3D48, $3F18, $3A60           ;..........=H?.:`
L0001BBDA dc.w $3A48, $3D18, $3860, $8090, $098F, $0214, $0C20, $0C20           ;:H=.8`....... .
L0001BBEA dc.w $0C14, $061E, $0C14, $0620, $0C1E, $0C20, $0C14, $0C20           ;....... ... ...
L0001BBFA dc.w $0C20, $0C14, $061E, $0C14, $0620, $0614, $061E, $0614           ;. ....... ......
L0001BC0A dc.w $0620, $0614, $060F, $0C1B, $0C1B, $0C0F, $0619, $0C0F           ;. ..............
L0001BC1A dc.w $061B, $0C19, $0C1B, $0C0F, $0C1B, $0C1B, $0C0F, $0619           ;................
L0001BC2A dc.w $0C0F, $061B, $060F, $0619, $060F, $061B, $060F, $0680           ;................
L0001BC3A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BC4A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BC5A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BC6A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BC7A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BC8A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BC9A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BCAA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BCBA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BCCA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BCDA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BCEA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BCFA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BD0A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BD1A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BD2A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BD3A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BD4A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BD5A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BD6A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BD7A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BD8A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BD9A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BDAA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BDBA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BDCA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BDDA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BDEA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BDFA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BE0A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BE1A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BE2A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BE3A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BE4A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BE5A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BE6A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BE7A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BE8A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BE9A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BEAA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BEBA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BECA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BEDA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BEEA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BEFA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BF0A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BF1A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BF2A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BF3A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BF4A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BF5A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BF6A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BF7A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BF8A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BF9A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BFAA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BFBA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BFCA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BFDA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BFEA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001BFFA dc.w $0000, $0000, $0000                                              ;......




                ;------------------------ TITLE SCREEN ENTRY POINT ---------------------------
title_screen_start                                              ; original routine address $0001c000
                bra.w   do_title_screen_start                   ; jmp $0001c008 



                ;-------------------- GAME OVER/COMPLETION ENTRY POINT -----------------------
end_game_start                                                  ; original routine address $0001c004
                bra.w   do_return_to_title_screen               ; jmp $0001d450




PANEL_INITIALISE_PLAYER_SCORE   EQU     $0007c81c               ; address of Panel.Initialise_Player_Score
PANEL_INITIALISE_PLAYER_LIVES   EQU     $0007c838               ; address of Panel.Initialise_Player_Lives
PANEL_STATUS_1                  EQU     $0007c874               ; address of Panel.Panel_Status_1  
PANEL_STATUS_2                  EQU     $0007c875               ; address of Panel.Panel_Status_2 
PANEL_HIGHSCORE                 EQU     $0007c878               ; address of Panel.High_Score 
PANEL_PLAYERSCORE               EQU     $0007c87c               ; address of Panel.Player_Score
LOADER_LOAD_LEVEL_1             EQU     $824                    ; address of Loader.Load_Level_1()

PANEL_STATUS_2_INFINITE_LIVES   EQU     $7                      ; panel status 2: bit 7 = 1 (infinite lives on)
PANEL_STATUS_2_GAME_COMPLETED   EQU     $6                      ; game completed = 1
PANEL_STATUS_2_GAME_OVER        EQU     $5                      ; game over/completion  - return from game
PANEL_STATUS_2_MUSIC_SFX        EQU     $0                      ; Music/SFX (0 = music, 1 = sfx)



                ;---------------------------- do title screenn start ----------------------------
                ; Routine to set up & run the title screen the first time the game is started.
                ; the routine 'return_to_title_screen' is called after game over/completion. 
                ;
                ; Sets Window start to bottom of screen (probably for scroll up routine)
                ; H/w Ref, standard DIWSRT & DIWSTOP
                ; PAL - $2c81, $2cc1
                ; NTSC- $2c81, $f4c1
                ;
do_title_screen_start                                           ; original routine address $0001c008
                clr.l   PANEL_HIGHSCORE                         ; clear Panel.HighScore
                move.l  highscore_table,PANEL_HIGHSCORE         ; set Panel.HighScore to top high-score
                ; continue as 'return_to_title_screen' below




                ;------------------------- return to title screen ----------------------------
                ; called after game over/compltion to return to the title screen.
                ;
return_to_title_screen                                          ; original address $0001c018
                lea.l   temp_stack_top,a7                       ; set temp stack space - $0001d6de,a7

.init_display_window                                            ; Initialise Window Scroll (start window = bottom of NTSC display)
                move.b  #$f4,copper_diwstrt                     ; reset window start line (usually $2c) - $0001d6e8
                move.b  #$f4,copper_diwstop                     ; reset widndow stop line (usually $2c or $f4 PAL/NTSC ) - $0001d6ec
.wait_frame
                moveq   #$01,d0                                 ; d0 = frames to wait + 1
                bsr.w   raster_wait_161                         ; wait for raster 161 - $0001c2f8
.init_system
                bsr.w   initialise_title_screen                 ; calls $0001c0d8
.init_display
                move.w  #$5000,$00dff100                        ; set 5 bitplane screen - BPLCON0
                lea.l   title_screen_colors,a0                  ; $0001d79a - screen colours
                bsr.w   copper_copy                             ; calls $0001d3a0
.init_game_status
                and.w   #$f89f,PANEL_STATUS_1                   ; clear panel status bits (panel status 1 & 2)
                                                                ; low 3 bits of status 1 (game over, life lost, timer expired)
                                                                ; bits 6 & 5 of status 2 (don't know what these do yet) - Think it's end game flags (success/fail etc)
.init_music
                bsr.w   init_title_music                        ; calls $0001c1a0 ; Play Song 01 (Title Tune)
.init_background
                bsr.w   copy_title_screen_bitplanes             ; calls $0001ca34 - copy title screen bitplanes to display memory (copper list display)


                ;************ TITLE SCREEN WAIT LOOP *****************
                ; Manage hi-score entry and text typer display.
                ; The text typer controls the main title-screen wait
                ; loop, waits for joystick button press to jump
                ; to 'start_game' below.
.title_screen_loop
                bsr.w   hi_score_and_text_typer                 ; calls $0001c586


                ;************* START GAME - LOAD LEVEL 1 *************
                ;text typer jumps out to here when start button pressed
start_game                                                      ; original address $0001c05e
                not.w   start_game_flag                         ; invert bits, value not used anywhere else in the title screen. $0001c09c
.wait_diwstrt
                cmp.b   #$f4,copper_diwstrt                     ; L0001d6e8
                bne.b    .wait_diwstrt                          ; if starting before title screen has openned, then wait 
.wait_frame
                moveq   #$01,d0                                 ; d0 = frames to wait + 1
                bsr.w   raster_wait_161                         ; wait for raster 161 - $0001c2f8
.init_game
                move.l  highscore_table,PANEL_PLAYERSCORE       ; set player score in panel to high score (reset next)
                jsr     PANEL_INITIALISE_PLAYER_SCORE           ; calls Panel.Initialise_Player_Score
                jsr     PANEL_INITIALISE_PLAYER_LIVES           ; calls Panel.Initialise_Player_Lives
                jsr     Stop_Audio                              ; calls $00004008
.load_level_1
                jmp     LOADER_LOAD_LEVEL_1                     ; jmp $00000824 - Loader.Load_Level_1




                ;---------------------- fatal error --------------------
                ; loop forever increment backgounr colour in tight loop
                ; UNUSED CODE
fatal_error
                jmp     do_fatal_error                          ; jmp $0001d542 



start_game_flag                                                 ; original address $0001c09c
                dc.w $0000                                      ; bits are inverted (not.w) on game_start 





                ;------------------------- do window scroll -------------------------
                ; called from level 3 interrupt handler, manages the title screen
                ; window scroll up (on title screen start) and the scroll down
                ; (on game start).
                ;
                ; The window scrolls in at 1 raster per call.
                ; The window scrolls out at 4 rasters per call.
                ;
do_window_scroll
                tst.w   start_game_flag                         ; test if game has started, $0001c09c
                bne.b   $0001c0ba
.do_scroll_up                                                   ; original address $0001c0a6
                cmp.b   #$2c,copper_diwstrt                     ; test window start position byte, $0001d6e8 
                beq.b   .exit                                   ; if window is fully 'open' (scrolled to top), jmp $0001c0b8
                sub.w   #$0100,copper_diwstrt                   ; else, scrol window top up by 1 raster line, $0001d6e8
.exit
                rts  

.do_scroll_down                                                 ; original address $0001c0ba
                cmp.b   #$f4,copper_diwstrt                     ; test if window top is at bottom of display, $0001d6e8
                beq.b   .exit                                   ; if yes, then exit
                bcs.b   .scroll_down                            ; if no, then scroll down
.already_down
                move.b  #$f0,copper_diwstrt                     ; if somewhere near, set at the bottom
.scroll_down
                add.w   #$0400,copper_diwstrt                   ; scroll window top down by 4 raster lines, $0001d6e8
.exit
                rts 




                ;--------------------------- initialise title screen ----------------------------
                ; set up the system, interrupts annd display.
                ; NB: Level 6 interrupt enabled, but no handler (set previously in disk loader)
                ;
initialise_title_screen                                         ; original routine address $0001c0d8
                move.l  #$f481f4c1,$00dff08e                    ; DIWSTRT/DIWSTOP - Initialise
                move.w  #$7fff,d0       
                move.w  d0,$00dff096                            ; DMACON - DMA off
                move.w  d0,$00dff09a                            ; INTENA - Interrupts off
                move.w  d0,$00dff09c                            ; INTREQ - Clear Interrupt Requests
                move.l  #level_1_interrupt_handler,$00000064    ; Level 1 Interrupt Vector
                move.l  #level_2_interrupt_handler,$00000068    ; Level 2 Interrupt Vector           
                move.l  #level_3_interrupt_handler,$0000006c    ; Level 3 Interrupt Vector   
                move.l  #level_4_interrupt_handler,$00000070    ; Level 4 Interrupt Vector        
                move.l  #level_5_interrupt_handler,$00000074    ; Level 5 Interrupt Vector
                move.w  #$e028,$00dff09a                        ; PORTS/TIMERS(2),VERTB(3),EXTER(6),INTEN,SET/CLR (no level 1,4,5) !No Level 6 handler
                move.w  #$83c0,$00dff096
                move.l  #copper_list,$dff080                     ;#$0001d6e2,$00dff080
                move.w  d0,$00dff088
                move.b  #$7f,$00bfed01
                move.b  #$7f,$00bfed01
                jsr     Initialise_Music_Player                 ; calls $00004000
                move.l  #$00001f40,d0                           ; d0 = bitplane size in bytes (8000)
                bra.w   reset_title_screen_display              ; calls $0001d2de

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
do_title_screen_menu_options                                            ; original routine address $0001c172
                btst.b  #$0000,raw_keyboard_serial_data_byte            ; is last key code - key up? $0001c2ed
                bne.w   clear_menu_flag_and_exit                        ; no, clear menu flag and exit, $0001c1b8
                tst.w   menu_keypress_flag                              ; $0001c2f2
                bne.w   global_rts                                      ; jmp $0001c170
.check_f2                                                               ; original address $0001c188
                cmp.w   #$005c,raw_keyboard_serial_data_word            ; compare 'F2' key press, $0001c2ec 
                bne.b   clear_menu_flag_and_exit                        ; no, clear menu flag and exit, $0001c1b8
 .is_f2               
                not.w   menu_keypress_flag                              ; toggle flag. $0001c2f2
                bchg.b  #PANEL_STATUS_2_MUSIC_SFX,PANEL_STATUS_2        ; $0007c875

                ; fall through to init_title_music (toggle on/off)




                ;------------------- Init Title Music -----------------
init_title_music                                                ; original routine address $0001c1a0
                btst.b  PANEL_STATUS_2_MUSIC_SFX,PANEL_STATUS_2 ; music or sfx bit of panel_status_2 
                beq.b   .init_song_01 
                jmp     Silence_All_Audio                       ; calls $00004004 - end music
.init_song_01
                moveq   #$01,d0                                 ; set tune to play? 
                jmp     Init_Song                               ; jmp $00004010
                ; uses rts in Play_Song to return to caller.




                ;------------------ clear menu flag and exit ----------------
                ; used by the do_title_screen_menu_options routine above.
                ; clears keypress flag and exit, used to detect single
                ; keypress.
clear_menu_flag_and_exit
                clr.w menu_keypress_flag                        ; L0001c2f2
                rts




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
                lea.l   raw_key_code_table                              ; $0001c258 ; raw keycode table (ends with $FFxx)

.match_keycodes_loop                                                    ; original address $0001c1ea
                cmp.b   (a0),d0
                beq.w   .enqueue_key_code                               ; $0001c1fe ; key code is in the list, pop it in the queue

.unmatched_keycode                                                      ; original address $0001c1f0
                cmp.b   #$ff,(a0)                                       ; continue checking until the end of list ($ff value is part of code - dodgy/bug)
                beq.w   .exit                                           ; then exit - jmp $0001c24a

                addaq.l #$02,a0                                         ; match next value with keycode
                bra.w   .match_keycodes_loop                            ; jmp $0001c1ea ; loop


                ; this is a queue of entered valid keycodes
                ; valid key codes are added to the end of the queue
.enqueue_key_code                                                       ; original address $0001c1fe
                move.b  $0001(a0),d1                                    ; d1 = key code table second byte match
                lea.l   keyboard_buffer_start+1,a0                        ; $0001c24d
                moveq   #$05,d0                                         ; d0 = loop counter (6 times)

.shift_chars_loop                                                       ; original address $0001c20a
                move.b  (a0),-$0001(a0)                                 ; shift bytes down in memory by 1 character
                addaq.l #$01,a0                                         
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
                move.l  #$00001f40,d0                                           ; bitplane size in bytes (8000)
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
                dc.b $49,$58,$4c,$4c,$4c,4c             ; IXLLLL 'JAMMMM'


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
                ; This interrupt is enabled in 'initialise_title_screen' (PORTS - LVL2)
                ;
level_2_interrupt_handler                                                       ; original routine address $0001c26e
                movem.l d0-d7/a0-a6,-(a7)
                move.b  $00bfec01,raw_keyboard_serial_data_byte                 ; SDR - $0001c2ed ; keyboard serial data
                move.b  $00bfed01,$00bfed01                                     ; ICR - WTF-1!, clear the interrupt control if not a CIAA/Set Interrupts if is CIAA
                move.w  #$0808,$00dff09c                                        ; INTREQ - Clear PORTS(2), 
                                                                                ; WTF-2! - Clear RBF(5) (keyboard serial) - Level 5 Interrupt!
                move.b  #$08,$00bfed01                                          ; ICR - Mask SP bit = 0 (keyboard serial)
                move.b  #$60,$00bfee01                                          ; CRA - Timer A Control - LOAD=1, SPMODE=1
                bsr.w   do_infinite_live_cheat_code                             ; calls $0001c1c0
                movem.l (a7)+,d0-d7/a0-a6
                rte




                ;---------------------- level 3 interrupt handler -------------------
                ; Vertical blank interrupt handler.
                ;   - plays current song
                ;   - scrolls window up/down
                ;   - does hacky stuff with CIAA and keyboard port
                ;
                ; This interrupt is enabled in 'initialise_title_screen' (VERTB)
                ;
level_3_interrupt_handler
                movem.l d0-d7/a0-a6,-(a7)
                jsr     Play_Song                               ; $00004018 ; play song
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




vertical_blank_toggle                                   ; original address $0001C2E8
                dc.w $0000                              ; value appears unused by the title screen (toggled every frame)

unused_002                                              ; original address $0001C2EA
                dc.w $0000



raw_keyboard_serial_data_word                                           ; original address $0001C2EC
                dc.b $00                                                ; keyboard raw key code word (high byte always 0)
raw_keyboard_serial_data_byte                                           ; original address $0001c2ed
                dc.b $00                                                ; keyboard raw key code byte

                dc.w $0000 

raw_key_code_store                                                      ; original address $0001c2f0
                dc.w $0000                                              ; keyboard reading data/flags

menu_keypress_flag                                                      ; original address $0001c2f2
                dc.w $0000                                              ; 0 = music, $ffff = sfx

                dc.w $0000, $0000




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
                cmp.b   #$a1,$00dff006                          ; compare VHPOSR with #$a1 (161)
                bne.b   raster_wait_161
                move.w  #$001e,d1
.processor_wait
                dbf.w  d1,.processor_wait
                dbf.w  d0,raster_wait_161
return_rts      rts





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




                ;----------------------- text typer ------------------------
                ; type out screen of text, also process control codes for
                ; special chars and inserting hi score table etc.
                ;
                ; IN: a6 - text structure for display
                ;          1 word - display co-ords (x,y bytes)
                ;          x bytes - text & display codes
                ;          1 byte  - #$ff - end text display
                ;
text_typer                                                      ; original routine address $0001c324
                move.l  a6,current_text_ptr                     ; $0001c314 ; store a6 address (used for looping when CODE #$00)
                move.b  (a6)+,x_coord+1                         ; store x coord - $0001c311
                move.b  (a6)+,y_coord+1                         ; store y coord - $0001c313

resume_text_start_line
                moveq   #$00,d0
                move.w  y_coord,d0                              ; $0001c312 ; d0 = y co-ord
                mulu.w  #$0028,d0                               ; d0 = d0 * 40 (bytes per scan line)
                add.w   x_coord,d0                              ; $0001c310 ; d0 = d0 + x co-ord
                add.l   #DISPLAY_BITPLANE_ADDRESS               ; #$00063190,d0 ; add bitplane base address
                exg.l   d0,a2                                   ; a2 = display destination address
                movea.l a2,a3                                   ; a3 = display destination address

resume_text_current_position
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
                addaq.l #$01,a3
                bra.w   resume_text_current_position            ; jmp $0001c352

.plot_character
                mulu.w  #$0050,d0
                add.l   #ASSET_CHARSET_BASE,d0                  ; #$0003f1ea,d0
                exg.l   d0,a1
                moveq   #$04,d7                                 ; d7 = 4 + 1 = 5 bitplanes
                moveq   #$00,d1
                movea.l a3,a2
.copy_loop
                move.b  (a1),(a2)                               ; copy char data - line 1
                move.b  $0002(a1),$0028(a2)                     ; copy char data - line 2
                move.b  $0004(a1),$0050(a2)                     ; copy char data - line 3
                move.b  $0006(a1),$0078(a2)                     ; copy char data - line 4
                move.b  $0008(a1),$00a0(a2)                     ; copy char data - line 5
                move.b  $000a(a1),$00c8(a2)                     ; copy char data - line 6
                move.b  $000c(a1),$00f0(a2)                     ; copy char data - line 7
                move.b  $000e(a1),$0118(a2)                     ; copy char data - line 8

                adda.l  #$00000010,a1                           ; add 16 bytes to source (next bitplane of character)
                adda.l  bitplane_size,a2                        ; increment dest to next bitplane.
                dbf.w   d7,.copy_loop                           ; bitplane loop, jmp $0001c416
                
                addaq.l #$01,a3                                 ; increment x position
                bra.w   resume_text_current_position            ; loop next char, $0001c352
                rts  




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
                move.w  char_plot_y_coord,d2            ; L0001c45c,d3 ; y co-ordinate
                move.w  char_plot_x_coord,d2            ; L0001c45a,d2 ; x co-ordinate
                mulu.w  #$0028,d3                       ; d3 = d3 * 40 (raster line)
                add.w   d3,d2                           ; d2 = x & y co-ords byte offset
                add.l   #DISPLAY_BITPLANE_ADDRESS,d2    ; #$00063190 ; add bitplane 1 base address
                exg.l   d2,a2                           ; a2 = dest address, d1 = prev value of a2
                and.l   #$0000003f,d0                   ; clamp d0 to 0-63
                mulu.w  #$0050,d0                       ; 80 bytes per char (16 bytes per bitplane) 8*8
                add.l   #ASSET_CHARSET_BASE,d0           ; #$0003f1ea ; character set gfx base address
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
                bra.w   resume_text_start_line          ; jmp $0001c336



                ;---------------- line feed -----------------
                ; continue typing one line down without
                ; returning to the start of the line.
lf                                                      ; original address $0001c4dc
                adda.l  #$00000140,a3                   ; add 320 to raster line (next page)
                movea.l a3,a2                           ; update dest display ptrs
                bra.w   resume_text_current_position    ; jmp $0001c352



                ;--------------- clear screen --------------
                ; clear screen bitplanes and reset x,y
                ; coords.
cls
                bsr.w   copy_title_screen_bitplanes     ; calls $0001ca34
                move.w  #$0007,x_coord                  ; $0001c310
                clr.w   y_coord                         ; $0001c312 
                bra.w   resume_text_start_line          ; $0001c336 



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
                bra.w   resume_text_current_position    ; jmp $0001c352

.firebutton_pressed
                jmp     start_game                      ; jmp $0001c05e



                ;--------------- loop text typer -----------------
                ; CODE #$00 - restart text typer from initial
                ;             saved text prt
loop_text_typer                                                 ; original address $0001c534
                movea.l current_text_ptr,a6                     ; $0001c314 [00000000],a6
                bra.w   text_typer                              ; calls $0001c324 - display text
                ; use text_typer rts to return



                ;--------------------- hi scores -------------------
                ; CODE: #$03 - start displaying Hi Score Table
                ;
hi_scores                                                       ; original routine address $0001c53e
                move.l  a6,temp_typer_text_ptr                  ; $0001c77e ; store current text typer ptr position
                movea.l #high_score_display_text,a6             ; #$0001c974 ; resume text from this location (HI SCORE TABLE)
                bra.w   resume_text_current_position            ; jmp $0001c352



                ;-------------------end hi scores ------------------
                ; CODE: #$04 - resume typing text after hi scores
                ;
end_hi_scores                                                   ; original routine address $0001c54e
                movea.l temp_typer_text_ptr,a6                  ; $0001c77e ; restore text typer source ptr from saved location
                bra.w   resume_text_current_position            ; jmp $0001c352



maybe_backspace                                                 ; original routine address $0001c558
                move.w  x_coord,char_plot_x_coord               ; $0001c45a
                move.w  y_coord,char_plot_y_coord               ; $0001c45c
                move.b  #$20,d0
                bsr.w   plot_character                          ; calls $0001c45e
                sub.w   #$0001,x_coord                          ; $0001c310
                bra.w   resume_text_current_position            ; jmp $0001c352



                ;-------------------- nop -----------------------
                ; do nothing, just resume text typing
_nop                                                            ; original address $0001c580
                bra.w   resume_text_current_position            ; jmp $0001c352



                ;-------- dangling rts instruction --------------
                rts







                ;------------------------ hi score and text typer -------------------------
                ; If Player score is a high score then insert is into the 
                ; highscore table.
                ; enter intials.
                ; start title screen text typer loop.
                ;
hi_score_and_text_typer                                                 ; original routine address $0001c586
                lea.l   highscore_table+16,a5                           ; L0001ca28,a5 ; Lowest Hi Score (5th)
                lea.l   end_highscore_display_text,a4                   ; L0001c9fc,a4 ; end of score table display text
                moveq   #$00,d0
.score_check_loop
                move.l  (a5),d6                                         ; d6 = next lowest high score
                cmp.l   PANEL_HIGHSCORE,d6                              ; High Score/Player Score
                bgt.w   .not_high_score                                 ; jmp $0001c5ec
.is_higher_score
                ; copy score display text down the list one entry
                move.l  (a5),$0004(a5)                                  ; shift lowest high score down the table
                subaq.l #$04,a5                                         ; update pointer to next highest score
                suba.l  #$00000017,a4                                   ; #$17 (23) update pointer to next highest score (display text)
                move.b  $000a(a4),$0021(a4)                             ; copy display test down the table.
                move.b  $000b(a4),$0022(a4)
                move.b  $000c(a4),$0023(a4)
                move.b  $000f(a4),$0026(a4)
                move.b  $0010(a4),$0027(a4)
                move.b  $0011(a4),$0028(a4)
                move.b  $0012(a4),$0029(a4)
                move.b  $0013(a4),$002a(a4)
                move.b  $0014(a4),$002b(a4)
                addq.w  #$01,d0                                         ; increase index counter
                cmp.w   #$0005,d0                                       ; 5 high scores to check against
                bne.w   .score_check_loop

                ; d0 = high score entry counting from bottom of the table 1-5
.not_high_score
                tst.w   d0
                beq.w   display_title_screen_text                       ; if d0 = 0 then not an high score, jmp $0001c760

                ; a4 = text display
                ; a5 = score table
                ; d0 = score index
.is_an_high_score                                                       ; original address $0001c5f2
                move.l  (a5),$0004(a5)
                move.l  PANEL_HIGHSCORE,(a5)                            ; set high score in score table
                move.b  #$20,$000a(a4)                                  ; insert space at text display index 10 - initial 1
                move.b  #$20,$000b(a4)                                  ; insert space at text display index 11 - initial 2
                move.b  #$20,$000c(a4)                                  ; insert space at text display index 12 - initial 3

.add_score_to_table_bcd
.digits_1_and_2                                                         ; original address $0001c60e
                movem.l d0,-(a7)                                        ; save d0 (score entry index)
                move.b  $0003(a5),d0                                    ; d0 = score byte (BCD)
                move.b  d0,d1                                           ; d1 = copy score byte (BCD)
                and.b   #$0f,d0                                         ; d0 = low digit
                add.w   #$0030,d0                                       ; d0 = add Ascii base for '0'
                lsr.b   #$04,d1                                         ; d1 = second score digit
                add.w   #$0030,d1                                       ; d1 = add Ascii base for '0'
                move.b  d0,$0014(a4)                                    ; store score digit 1 - least significant
                move.b  d1,$0013(a4)                                    ; store score digit 2 - second digit

.digits_3_and_4                                                         ; original address $0001c62e
                move.b  $0002(a5),d0                                    ; d0 = score byte (BCD)
                move.b  d0,d1                                           ; d1 = copy score byte (BCD)
                and.b   #$0f,d0                                         ; d0 = low digit
                add.w   #$0030,d0                                       ; d0 = add Ascii base for '0'
                lsr.b   #$04,d1                                         ; d1 = second score digit
                add.w   #$0030,d1                                       ; d1 = add Ascii base for '0'
                move.b  d0,$0012(a4)                                    ; store score digit 1 - least significant
                move.b  d1,$0011(a4)                                    ; store score digit 2 - second digit

.digits_5_and_6                                                         ; original address $0001c64a
                move.b  $0001(a5),d0                                    ; d0 = score byte (BCD)
                move.b  d0,d1                                           ; d1 = copy score byte (BCD)
                and.b   #$0f,d0                                         ; d0 = low digit
                add.w   #$0030,d0                                       ; d0 = add Ascii base for '0'
                lsr.b   #$04,d1                                         ; d1 = second score digit
                add.w   #$0030,d1                                       ; d1 = add Ascii base for '0'
                move.b  d0,$0010(a4)                                    ; store score digit 1 - least significant
                move.b  d1,$000f(a4)                                    ; store score digit 2 - second digit

.init_enter_initials
                adda.l  #$0000000a,a4                                   ; increase text display ptr by 10 chars
                lea.l   score_y_coord_table,a0                          ; L0001c76a,a0
                movem.l (a7)+,d0                                        ; d0 = restored table entry index
                asl.w   #$01,d0                                         ; d0 = d0 * 2 (index to a0 table)
                move.w  $00(a0,d0.w),char_plot_y_coord                  ; L0001c45c - set y co-ord 
                move.w  #$0011,char_plot_x_coord                        ; L0001c45a - set x co-ord first char
                move.w  #$0003,name_initials_count                      ; L0001c776 - number of letters to enter
                move.b  #$04,high_score_6th_entry                       ; $0001C9FC - insert text typer code to not display last entry
                                                                        ; CODE #$04 makes typer End HighScore table
.display_hiscore_table
                lea.l   display_hiscores,a6                             ; L0001c96e ; (a6) = $0c30 - x,y display co-ords
                bsr.w   text_typer                                      ; $0001c324 ; type text

                moveq   #$01,d6                                         ; d6 = initialise the current displayed character(initials entry)
                bsr.w   .draw_current_character                         ; calls $0001c710 
                *** This never returns (looks like it should be a bra?) ***
                *** Enters the .initials_entry_loop ***
                *** Eventually jumps out at .end_intial_entry

.initials_entry_loop                                                    ; original address $0001c6a8
                moveq   #$04,d0
                bsr.w   raster_wait_161                                 ; calls $0001c2f8 - wait 4 frames
                clr.l   joystick_left                                   ; clear both joystick left & right flags - $0001c778
                clr.w   unused_var_flag                                 ; clear the 16 bit word - appears unused else where - $0001c77c
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
                cmp.w   #$001b,d6                                       ; check last character index
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
                move.w  #$ffe0,                                         ; insert -32 (equals a space char when #$40 is added back to it below)
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
                ; start the text typer routine that cycles through the text displayyed over
                ; the title screen as a set of text pages. Includes the display of the 
                ; high score table etc. 
                ; strangely the typer routine also waits for the joystick button to be
                ; pressed for the start game.
                ;
display_title_screen_text                                               ; original address $0001c760
                lea.l   title_screen_text,a6                            ; $0001c784 - a6 = title screen text for display
                bra.w   text_typer                                      ; jmp $0001c324 - display text
                ; uses text_typer rts to return?




score_y_coord_table                                             ; original address $0001C76A
                dc.w $0058, $0060, $0050, $0040, $0030, $0020   ; table of y co-ord values for each line of the hi-score table on the screen, bottom to top (not sure if 1st entry is used)

name_initials_count                                             ; original address $0001C776
                dc.w $0000                                      ; count of hi-score initials entered during the entry loop. initialised to 3, exits loop when 0

; used during enter high score initial loop
joystick_left                                                   ; original address $0001C778
                dc.w $0000                                      ; joystick left (SET TRUE)
joystick_right
                dc.w $0000                                      ; joystick right (SET TRUE)

unused_var_flag                                                 ; original address $0001C77C
                dc.w $0000                                      ; cleared when joystick values are read during hi-score initials entry loop - appears unused apart from being cleared in the loop.

temp_typer_text_ptr                                             ; original address $0001c77e
                dc.l $00000000                                  ; store ptr to typer text while command types hi-score table

typer_extended_command_1                                        ; original address $0001C782
                dc.b $00
typer_extended_command_2                                        ; original address $0001C783
                dc.b $00 


title_screen_text                                               ; original address $0001c784
                dc.b $01,$01                                    ; display co-ords (x,y)
                dc.b $01                                        ; clear screen command
                dc.b $0D,$0D,$0D,$0D,$0D,$0D                    ; #$0D = carriage return
                dc.b '      OCEAN SOFTWARE',$0D,$0D                   
                dc.b '         PRESENTS   ',$0D                       
                dc.b $02,$00,$80                                ; #$02 = wait for 2.5 seconds (128 frames)

                dc.b $01                                        ; #$01 = clear the screen
                dc.b $06                                        ; #$06 = No Operation (nop)
                dc.b $0D,$0D,$0D,$0D,$0D,$0D
                dc.b '          BATMAN',$0D,$0D
                dc.b '        THE MOVIE',
                dc.b $02,$00,$80                                ; #$02 = wait for 2.5 seconds (128 frames)

                dc.b $01                                        ; #$01 = clear the screen
                dc.b $0D,$0D
                dc.b '   TM & @ DC COMICS INC',$2E,$0D          ; #$2E = full stop symbol
                dc.b '           1989 ',$0D,$0D,$0D
                dc.b '   @ OCEAN SOFTWARE 1989',$0D,$0D
                dc.b '     ESC',$2E,$2E,'ABORT GAME',$0D,$0D    ; #$2E = full stop symbol
                dc.b '      F1',$2E,$2E,'PAUSE GAME',$0D,$0D
                dc.b '      F2',$2E,$2E,'TOGGLE MUSIC',$0D
                dc.b $02,$01,$00                                ; #$02 = wait for 5 (256) seconds

                dc.b $01                                        ; #$01 = clear screen
                dc.b $0D
                dc.b '   CODING BY',$0D
                dc.b '            MIKE LAMB',$0D 
                dc.b '            JOBBEEEE',$0D
                dc.b '            SHORTY',$0D,$0D
                dc.b '   GRAPHICS BY',$0D
                dc.b '            DAWN DRAKE',$0D
                dc.b '            BILL HARBISON',$0D
                dc.b '            JOHN PALMER',$0D,$0D
                dc.b '   MUSIC AND FX BY',$0D
                dc.b '            JON DUNN',$0D
                dc.b '            MATTHEW CANNON' 
                dc.b $02,$01,$00                        ; #$02 = wait for 5 (256) seconds
                
                dc.b $01                                ; #$01 = clear screen
                dc.b $03                                ; #$03 = display hi score table
                dc.b $02,$00,$f0                        ; #$02 = wait for 2.5 seconds

                dc.w $01                                ; #$01 - clear screen
                dc.b $00                                ; #$00 - loop text to start
                dc.b $FF                                ; #$ff - end typer (never reaches here)                                                     




display_hiscores                                        ; original address $0001C96E
                dc.b $0C,$30                            ; x, y               
                dc.b $01                                ; $01 - clear screen
                dc.b $0D                                ; $0D - carriage return
                dc.b $03                                ; $03 - display hi scores
                dc.b $FF                                ; $ff - end typer




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
high_score_display_text                                                                                            ; original address $0001C974
                dc.b $20,$20,$20,$20,$20,$20,$20,$20,$20,$48,$49,$20,$53,$43,$4F,$52,$45,$53,$0D,$0D,$0D           ;         HI SCORES
                dc.b $20,$20,$20,$20,$20,$31,$53,$54,$20,$20,$41,$4A,$53,$20,$20,$31,$32,$35,$30,$30,$30,$0D,$0D   ;     1ST  AJS  125000
                dc.b $20,$20,$20,$20,$20,$32,$4E,$44,$20,$20,$4D,$49,$4B,$20,$20,$31,$30,$30,$30,$30,$30,$0D,$0D   ;     2ND  MIK  100000
                dc.b $20,$20,$20,$20,$20,$33,$52,$44,$20,$20,$4A,$4F,$42,$20,$20,$30,$37,$35,$30,$30,$30,$0D,$0D   ;     3RD  JOB  075000
                dc.b $20,$20,$20,$20,$20,$34,$54,$48,$20,$20,$42,$49,$4C,$20,$20,$30,$35,$30,$30,$30,$30,$0D,$0D   ;     4TH  BIL  050000
                dc.b $20,$20,$20,$20,$20,$35,$54,$48,$20,$20,$4A,$4F,$4E,$20,$20,$30,$32,$35,$30,$30,$30,$0D,$0D   ;     5TH  JON  025000
end_highscore_display_text                                                                                         ; original address $0001C9FC
high_score_6th_entry                                                                                               ; original address $0001C9FC - not displayed, buffer to roll last entry into
                dc.b $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$0D,$0D
                dc.b $04                        ; #$04 - typer code - resume typer after high score table




L0001CA14       dc.b $00, $00, $00, $00 




                ;--------------- High Score Table -------------
                ; High score table where the top 5 scores are
                ; stored in BCD format.
                ; The 6th entry is only used to roll the
                ; last score into when inserting a new
                ; hi-score into the table.
                ;
highscore_table                                         ; original address $0001CA18
                dc.l $00125000
                dc.l $00100000
                dc.l $00075000
                dc.l $00050000
                dc.l $00025000                          ; highscore_table+16 ; original address $0001CA28                              
                dc.l $00000000                          ; highscore_table+20 ; original address $0001CA2c - not displayed, used to roll last entry into




                ; -------------- other data 1 ----------------------
                ; currently unknown/unused data
.other_data1                                            ; original address $0001CA2E
L0001CA2E       dc.w $0000, $0000                       ; **** UNUSED??? ****




                ; --------------- Copy Title Screen Bitplanes ----------------
copy_title_screen_bitplanes
                lea.l $00040000,a0
                bra.w copy_bitplanes_to_display                 ; calls $0001d3da
                ; uses routine rts to return to caller




bitplane_size                                   ; original address $0001ca3e
                dc.l $00000000                  ; The size of the current display bitplane in bytes          




                ; -------------- other data 2 ----------------------
                ; currently unknown/unused data
.other_data2
L0001ca42       dc.w $0000, $0000                ;or.b #$00,d0







                ;-------------------------------- UNUSED CODE -----------------------------
                ;-------------------------------- UNUSED CODE -----------------------------
                ;-------------------------------- UNUSED CODE -----------------------------
                ;-------------------------------- UNUSED CODE -----------------------------
                ;-------------------------------- UNUSED CODE -----------------------------
                ;-------------------------------- UNUSED CODE -----------------------------  


                ; l0001cd0e = $7e (126) - reset_title_screen_display
                ; l0001cd12 = $3c (60)  - reset title screen display (L0001cd0e+4)          
L0001ca46       lea.l   L0001cd0e,a0
L0001ca4c       lea.l   L0001cd2e,a2
L0001ca52       lea.l   L0001cd16,a3
L0001ca58       lea.l   L0001cd34,a4
L0001ca5e       lea.l   L0001cd3a,a5
L0001ca64       lea.l   L0001cd40,a6

L0001ca6a       moveq   #$00,d7
L0001ca6c       bsr.w   L0001cb94

L0001ca70       move.w  #$0fca,d1
L0001ca74       or.w    L0001cd8c,d1
L0001ca7a       move.w  d1,$00dff040
L0001ca80       move.w  $0001cd8c,$00dff042
L0001ca8a       move.l  $0001cd86,d0
L0001ca90       beq.w   L0001cb92
L0001ca94       move.l  $0001cd6e,$00dff04c
L0001ca9e       move.l  $0001cd82,$00dff050
L0001caa8       move.l  d0,$00dff048
L0001caae       move.l  d0,$00dff054
L0001cab4       clr.w   $00dff064
L0001caba       clr.w   $00dff062
L0001cac0       move.w  (a4),$00dff060
L0001cac6       move.w  (a4),$00dff066
L0001cacc       move.w  (a2),$00dff058
L0001cad2       add.l   bitplane_size,d0                        ;$0001ca3e,d0
L0001cad8       bsr.w   wait_blitter                            ; calls $0001d442
L0001cadc       move.l  $0001cd72,$00dff04c
L0001cae6       move.l  $0001cd82,$00dff050
L0001caf0       move.l  d0,$00dff048
L0001caf6       move.l  d0,$00dff054
L0001cafc       move.w  (a2),$00dff058
L0001cb02       add.l   bitplane_size,d0                        ;$0001ca3e,d0
L0001cb08       bsr.w   wait_blitter                            ; calls $0001d442
L0001cb0c       move.l  $0001cd76,$00dff04c
L0001cb16       move.l  $0001cd82,$00dff050
L0001cb20       move.l  d0,$00dff048
L0001cb26       move.l  d0,$00dff054
L0001cb2c       move.w  (a2),$00dff058
L0001cb32       add.l   bitplane_size,d0                        ; $0001ca3e,d0
L0001cb38       bsr.w   wait_blitter                            ; calls $0001d442
L0001cb3c       move.l  $0001cd7a,$00dff04c
L0001cb46       move.l  $0001cd82,$00dff050
L0001cb50       move.l  d0,$00dff048
L0001cb56       move.l  d0,$00dff054
L0001cb5c       move.w  (a2),$00dff058
L0001cb62       add.l   bitplane_size,d0                        ; $0001ca3e,d0
L0001cb68       bsr.w   wait_blitter                            ; calls $0001d442
L0001cb6c       move.l  $0001cd7e,$00dff04c
L0001cb76       move.l  $0001cd82,$00dff050
L0001cb80       move.l  d0,$00dff048
L0001cb86       move.l  d0,$00dff054
L0001cb8c       move.w  (a2),$00dff058
L0001cb92       rts


                ; L0001cd0e,a0
                ; L0001cd2e,a2
                ; L0001cd16,a3
                ; L0001cd34,a4
                ; L0001cd3a,a5
                ; L0001cd40,a6                  ; index for source copy
                ; d7 = 0
L0001cb94       moveq   #$00,d0
L0001cb96       move.w  #$0028,(a4)

L0001cb9a       movem.l a0,-(a7)
L0001cb9e       move.w  (a6),d0
L0001cba0       mulu.w  #$001c,d0
L0001cba4       lea.l   L0001cd44,a0
L0001cbaa       move.l  $00(a0,d0.l),L0001cd66
L0001cbb2       move.l  $04(a0,d0.l),L0001cd66+8                ; L0001cd6e
L0001cbba       move.l  $08(a0,d0.l),L0001cd66+12               ; L0001cd72
L0001cbc2       move.l  $0c(a0,d0.l),L0001cd66+16               ; L0001cd76
L0001cbca       move.l  $10(a0,d0.l),L0001cd66+20               ; L0001cd7a
L0001cbd2       move.l  $14(a0,d0.l),L0001cd66+24               ; L0001cd7e
L0001cbda       move.l  $18(a0,d0.l),L0001cd66+28               ; L0001cd82
L0001cbe2       movem.l (a7)+,a0

L0001cbe6       move.w  (a0),d0                 ; d0 = 1st word
L0001cbe8       move.w  d0,d2                   ; d2 = 1st word
L0001cbea       and.w   #$000f,d2               ; mask to 8 bits
L0001cbee       lsr.w   #$03,d0                 ; d0 = d0 * 8
L0001cbf0       move.w  $0004(a0),d1            ; d1 = 2nd word
L0001cbf4       add.w   #$0100,d1               ; d1 = d1 + 256
L0001cbf8       ext.w   d0                      ; sign extend byte to word
L0001cbfa       add.w   #$0100,d0               ; d0 = d0 + 256
L0001cbfe       move.w  L0001cd66+2,d4          ; L0001cd68,d4
L0001cc04       move.w  d1,d3                   ; d3 = d1
L0001cc06       cmp.w   #$01c7,d3       
L0001cc0a       bgt.w   clear_and_exit          ; L0001cc22
L0001cc0e       add.w   d4,d3
L0001cc10       cmp.w   #$01c7,d3
L0001cc14       blt.w   L0001cc2a
L0001cc18       sub.w   #$01c7,d3
L0001cc1c       sub.w   d3,d4
L0001cc1e       beq.b   clear_and_exit          ; L0001cc22
L0001cc20       bpl.b   L0001cc2a
clear_and_exit
L0001cc22       clr.l   L0001cd86
L0001cc28       rts  


L0001cc2a       cmp.w   #$0100,d1
L0001cc2e       bgt.w   L0001cc7a
L0001cc32       move.w  d1,d3
L0001cc34       add.w   d4,d3
L0001cc36       sub.w   #$0100,d3
L0001cc3a       bmi.w   L0001cc22
L0001cc3e       move.w  d3,d4
L0001cc40       beq.w   L0001cc22
L0001cc44       sub.w   L0001cd68,d3
L0001cc4a       neg.w   d3
L0001cc4c       mulu.w  L0001cd66,d3
L0001cc52       add.l   d3,$0001cd6e
L0001cc58       add.l   d3,$0001cd72
L0001cc5e       add.l   d3,$0001cd76
L0001cc64       add.l   d3,$0001cd7a
L0001cc6a       add.l   d3,$0001cd7e
L0001cc70       add.l   d3,$0001cd82
L0001cc76       move.w  #$0100,d1
L0001cc7a       clr.w   (a5)
L0001cc7c       cmp.w   #$0128,d0
L0001cc80       bgt.w   L0001cc22
L0001cc84       cmp.w   #$0100,d0
L0001cc88       bgt.w   L0001cc9c
L0001cc8c       move.w  d0,d3
L0001cc8e       sub.w   #$0100,d3
L0001cc92       bmi.w   L0001cc22
L0001cc96       nop
L0001cc98       move.w  #$0100,d0
L0001cc9c       move.w  d0,d3
L0001cc9e       add.w   L0001cd66,d3
L0001cca4       cmp.w   #$0128,d3
L0001cca8       blt.w   L0001ccb0
L0001ccac       bra.w   L0001cc22
L0001ccb0       move.w  L0001cd66,d6
L0001ccb6       sub.w   d6,(a4)
L0001ccb8       sub.w   #$0100,d0
L0001ccbc       sub.w   #$0100,d1
L0001ccc0       mulu.w  #$0028,d1
L0001ccc4       add.l   d1,d0
L0001ccc6       move.l  $0001ca42,d1
L0001cccc       add.l   d0,d1
L0001ccce       move.l  d1,$0001cd86
L0001ccd4       asl.w   #$08,d2
L0001ccd6       asl.w   #$04,d2
L0001ccd8       move.w  d2,$0001cd8c
L0001ccde       move.w  $0001cd66,d5
L0001cce4       mulu.w  d4,d5
L0001cce6       move.l  d5,$0001cd6a
L0001ccec       move.w  $0001cd66,d5
L0001ccf2       lsr.w   #$01,d5
L0001ccf4       asl.w   #$06,d4
L0001ccf6       or.w    d4,d5
L0001ccf8       move.w  d5,(a2)
L0001ccfa       rts

L0001ccfc       lea.l   L0001cd2e,a0
L0001cd02       move.w  #$0002,d7
L0001cd06       clr.w   (a0)+
L0001cd08       dbf.w   d7,L0001cd06
L0001cd0c       rts



                ;-------------------------------- UNUSED CODE -----------------------------
                ;-------------------------------- UNUSED CODE -----------------------------
                ;-------------------------------- UNUSED CODE -----------------------------
                ;-------------------------------- UNUSED CODE -----------------------------
                ;-------------------------------- UNUSED CODE -----------------------------




                ; l0001cd0e = $7e (126) - reset_title_screen_display
                ; l0001cd12 = $3c (60)  - reset title screen display (L0001cd0e+4)
L0001CD0E       dc.w $0000, $0018, $0000, $0012 
L0001CD16       dc.w $0000, $0000, $0000, $0000
                dc.w $0000, $0000, $0000, $0000
                dc.w $0000, $0000
                
L0001CD2A       dc.w $0000, $0000       ;unused? 

L0001CD2E       dc.w $0000, $0000, $0000
L0001CD34       dc.w $0000, $0000, $0000
L0001CD3A       dc.w $0000, $0000, $0000
L0001CD40       dc.w $0000              ; index for copy above L0001CD0E -> L0001CD66
                dc.w $0000, $000C

L0001CD46 dc.w $001C, $0005, $0000, $0005
L0001CD4E dc.w $0150, $0005, $02A0, $0005, $03F0, $0005, $0540, $0001           ;.P...........@..
L0001CD5E dc.w $CD8E, $0000, $0000, $0000, 

                ; Values from L0001CD0E - is copied to these values here.
L0001CD66       dc.l $00000000
L0001CD6A       dc.l $00000000          ; skipped by data copy
L0001CD6E       dc.l $00000000, $00000000
L0001CD76       dc.l $00000000, $00000000 
                dc.l $00000000, $00000000



L0001cd86 dc.w $0000, $0000, $0000, $0000           
L0001CD8E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CD9E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CDAE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CDBE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CDCE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CDDE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CDEE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CDFE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CE0E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CE1E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CE2E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CE3E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CE4E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CE5E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CE6E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CE7E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CE8E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CE9E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CEAE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CEBE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CECE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CEDE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CEEE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CEFE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CF0E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CF1E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CF2E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CF3E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CF4E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CF5E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CF6E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CF7E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CF8E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CF9E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CFAE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CFBE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CFCE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CFDE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CFEE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CFFE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001D00E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001D01E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001D02E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $0000, $0000, $0000, $0000           ;................
L0001D03E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D04E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D05E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D06E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D07E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D08E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D09E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D0AE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D0BE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D0CE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D0DE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D0EE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D0FE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D10E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D11E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D12E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D13E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D14E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D15E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D16E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D17E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D18E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D19E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D1AE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D1BE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D1CE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D1DE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D1EE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D1FE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D20E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D21E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D22E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D23E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D24E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D25E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D26E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D27E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D28E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D29E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D2AE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D2BE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D2CE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................




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
                move.l  #DISPLAY_BITPLANE_ADDRESS,$0001ca42             ; #$00063190,$0001ca42 [00000000]
                move.w  #$007e,L0001cd0e                                ; #$7e (126)
                move.w  #$003c,L0001cd0e+4                              ; #$3c (60)
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
                addaq.l #$04,a0                                         ; increment to next bitplane ptr in copper list
                addaq.l #$04,a1                                         ; increment to next bitplane ptr in copper list
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
                addaq.l #$04,a1                                 ; update dest ptr to next colour value
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
                ;  - 8000 x5 = 40,0000
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
                adda.l  #$0000001c,a1                   ;  #$1c = 28 (28 bytes to dest ptr) 
                dbf.w   d0,.copy_loop                    ; copy loop (477 times x 28 bytes = 40,068)
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



                ;--------------------- do return to title screen ----------------
                ; perform game over/game completion checks, display correct
                ; screens on return from the game back to the title screen.
                ;
do_return_to_title_screen                                                       ; original routine address $0001d450
                lea.l   temp_stack_top,a7                                       ; set temp stack, $0001d6de,a7
                bsr.w   initialise_title_screen                                 ; calls $0001c0d8
                btst.b  #PANEL_STATUS_2_GAME_OVER,PANEL_STATUS_2                ; #$0005,$0007c875 
                beq.b   do_gameover_completion                                  ; calls $0001d46e
                clr.l   PANEL_HIGHSCORE                                         ; $0007c87c
                bra.w   return_to_title_screen                                  ; $0001c018



                ;------------------- do game over/completion -------------------
                ; check panel_status_2 bit to see if the game was completed
                ; or whether it's a game over.
do_gameover_completion                                                          ; original routine address $0001d46e
                btst.b  #PANEL_STATUS_2_GAME_COMPLETED,PANEL_STATUS_2           ; #$0006,$0007c875 
                beq.w   display_endgame_joker                                   ; jmp $0001d4ec



                ;---------------------- display completion screen -----------------------
                ; displays the game completion screen, plays the batman voice (song 3)
                ; waits for ~15 seconds, returns to title screen.
display_completion_screen                                                       ; original routine address $0001d47a
                move.l  #$00001f40,d0                                           ; d0 = bitplane size (bytes) (8000)
                bsr.w   reset_title_screen_display                              ; calls $0001d2de
                move.w  #$4000,$00dff100                                        ; set 4 bitplane screen
                lea.l   palette_16_colours,a0                                   ; L0001d4cc ; 16 colour palette address
                bsr.w   copper_copy                                             ; calls $0001d3a0
                lea.l   $00056460,a0                                            ; a0 = source gfx
                bsr.w   copy_bitplanes_to_display                               ; calls $0001d3da
                move.b  #$2c,copper_diwstrt                                     ; $0001d6e8 - set window open
                move.b  #$f4,copper_diwstop                                     ; $0001d6ec 
                move.w  #$0064,d0                                               ; d0 = 100
                bsr.w   raster_wait_161                                         ; wait for 100 frames (2 seconds) - calls $0001c2f8
                moveq   #$03,d0                                                 ; d0 = song 3
                jsr     Init_Song                                               ; init play song 4 - calls $00004010
                move.w  #$0600,d0                                               ; d0 = 1536 
                bsr.w   raster_wait_161                                         ; wait for 1536 frames (15 seconds) - calls $0001c2f8
                bra.w   return_to_title_screen                                  ; jmp $0001c018




                ;------------------- 16 colour palette -----------------------
                ; 16 colour palatte for the above.
palette_16_colours                                                              ; original address $0001d4cc
                dc.w $0000, $0ec2, $0e80, $0a40, $0820, $0e60, $0ea8, $0eca 
                dc.w $0ea0, $0eee, $0222, $0444, $0666, $0888, $0AAA, $0CCC




                ;---------------------- display end game joker -----------------------
                ; displays the game over screen, plays the joker laugh (song 2)
                ; waits for ~10 seconds, returns to title screen.
display_endgame_joker                                                   ; original address $0001d4f0
                move.l  #$2800,d0                                       ; d0,d4 = bitplane size (bytes)
                bsr.w   reset_title_screen_display                      ; calls $0001d2de
                lea.l   $00049c40,a0                                    ; a0 = display palette colour table
                bsr.w   copper_copy                                     ; calls $0001d3a0
                lea.l   $00049c80,a0                                    ; a0 = display screen gfx
                bsr.w   copy_gfx_to_display                             ; calls $0001d41c
                move.b  #$2c,copper_diwstrt                             ; $0001d6e8
                move.b  #$2b,copper_diwstop                             ; $0001d6ec
                move.w  #$0014,d0
                bsr.w   raster_wait_161                                 ; calls $0001c2f8
                moveq   #$02,d0
                jsr     Init_Song                                       ; calls $00004010
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




                ;-----------------------do  fatal error ------------------
                ; Takes back ground colour and sets it, then increments the value
                ; loops forever.
                ;
do_fatal_error                                                          ; original routine address $0001d542
                move.w  d0,$00dff180
                addq.w  #$01,d0
                bra.w   do_fatal_error



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
                dc.w $F381, 
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




                ;------------------------ title screen colours ---------------------
                ; table of colours copied into the copper list colour registers.
                ; the palette used for the title screen display.
                ;
title_screen_colors                                                     ; original address $0001D79A       
                dc.w $0000, $0521, $0310, $0731, $0831, $0A41, $0B51, $0D61
                dc.w $0E70, $0F80, $0F90, $0FA0, $0FB0, $0FC0, $0FE0, $0FF0
                dc.w $0045, $0900, $0FFF, $0033, $0067, $0222, $0333, $0444
                dc.w $0F99, $0666, $0706, $0504, $099A, $0403, $0302, $0DDE



