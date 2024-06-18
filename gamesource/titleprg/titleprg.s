
                
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
                ; Play_Song                     - $00004010 - D0.l = Song Number to play (0-3, 0 = stop playing)
                ;
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


                ;----------------------------- Music Player Jump Table ------------------------------
Initialise_Music_Player                                         ; original routine address $00004000
L00004000       bra.w   do_initialise_music_player              ; jmp $00004180

Silence_All_Audio                                               ; original routine address $00004004
L00004004       bra.w   do_silence_all_audio                    ; calls $00004194

L00004008       bra.w   L000041e0

L0000400c       bra.w   L000041e0

                ; IN: D0.l (song/sound to play)
Play_Song                                                       ; original routine address $00004010
L00004010       bra.w   do_play_song                            ; calls $0000423e, init/play song


L00004014       bra.w   L00004222
L00004018       bra.w   L000042f6


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
silence_channel_volume
                move.w  #$0000,(a0)                             ; set volume in struct
                move.w  #$0001,$004a(a0)                        ; set unknown in struct
                move.w  #$0000,$004c(a0)                        ; set unknown in struct
                move.w  #$0000,(a1)                             ; Volume custom reg = 0
                adda.w  #$0056,a0                               ; update ptr to next channel struct (86 bytes)
                adda.w  #$0010,a1                               ; update to next channel volume register
                rts




                ;------------------------- xxxxxxxxxx -------------------------
                ; Called from:
                ;        - do_title_screen_start
                ;
L000041e0       movem.l d0/d7/a0-a2,-(a7)
L000041e4       subq.w  #$01,d0
L000041e6       bmi.b   L000041ee
L000041e8       cmp.w   #$0003,d0
L000041ec       bcs.b   L000041f2
L000041ee       bsr.b   do_silence_all_audio                    ; calls $00004194
L000041f0       bra.b   L0000421c
L000041f2       lea.l   song_table,a2                           ; L0001b9dc,a2
L000041f8       asl.w   #$03,d0
L000041fa       adda.w  d0,a2
L000041fc       lea.l   channel_1_status,a0                     ; L00004024,a0
L00004200       lea.l   $00dff0a8,a1
L00004206       moveq   #$03,d7
L00004208       tst.w   (a2)+
L0000420a       bne.b   L00004216
L0000420c       adda.w  #$0056,a0
L00004210       adda.w  #$0010,a1
L00004214       bra.b   L00004218
L00004216       bsr.b   silence_channel_volume                  ; calls $000041c2
L00004218       dbf.w   d7,L00004208
L0000421c       movem.l (a7)+,d0/d7/a0-a2
L00004220       rts


L00004222       tst.w   L00004126
L00004226       beq.b   L0000422e
L00004228       cmp.b   L00004023,d0
L0000422c       bcs.b   L0000423c
L0000422e       movem.l d0/d7/a0-a2,-(a7)
L00004232       move.w  #$4000,d1
L00004236       move.b  d0,L00004023
L0000423a       bra.b   L0000424a
L0000423c       rts





                ; IN: D0.l - sound/song to play?
                ;               - 0 = play nothing/stop
                ;               - >3 = play nothing/stop
do_play_song                                                    ; original routine address $0000423e
                movem.l d0/d7/a0-a2,-(a7)
                move.w  #$8000,d1
                move.b  d0,song_number                          ; $00004022
                clr.w   L0000417e                               ; clear timer/counter?
.validate_song_number
                subq.w  #$01,d0
                bmi.b   .stop_playing                           ; L00004258
                cmp.w   #$0003,d0                               ; check song number in range 1-3
                bcs.b   .play_song

.stop_playing
                bsr.w   do_silence_all_audio                       ; calls $00004194
                bra.w   .exit

.play_song
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



00004426 5300                     subq.b #$01,d0
00004428 6606                     bne.b #$06 == $00004430 (F)
0000442a 294b 0002                move.l a3,(a4,$0002) == $0000155a [00000000]
0000442e 60d2                     bra.b #$d2 == $00004402 (T)
00004430 5300                     subq.b #$01,d0
00004432 6606                     bne.b #$06 == $0000443a (F)
00004434 195b 0013                move.b (a3)+ [4e],(a4,$0013) == $0000156b [00]
00004438 60c8                     bra.b #$c8 == $00004402 (T)
0000443a 5300                     subq.b #$01,d0
0000443c 66c4                     bne.b #$c4 == $00004402 (F)
0000443e 195b 0012                move.b (a3)+ [4e],(a4,$0012) == $0000156a [00]
00004442 60be                     bra.b #$be == $00004402 (T)
00004444 294b 0006                move.l a3,(a4,$0006) == $0000155e [00000000]
00004448 47f9 0001 ba06           lea.l $0001ba06,a3
0000444e 4880                     ext.w d0
00004450 d040                     add.w d0,d0
00004452 d6c0                     adda.w d0,a3
00004454 d6d3                     adda.w (a3) [4e75],a3
00004456 6000 ff20                bra.w #$ff20 == $00004378 (T)
0000445a 294b 000a                move.l a3,(a4,$000a) == $00001562 [00000000]
0000445e 6000 ff18                bra.w #$ff18 == $00004378 (T)
00004462 6000 ff14                bra.w #$ff14 == $00004378 (T)
00004466 6000 ff10                bra.w #$ff10 == $00004378 (T)
0000446a 08c7 0005                bset.l #$0005,d7
0000446e 195b 0051                move.b (a3)+ [4e],(a4,$0051) == $000015a9 [00]
00004472 6000 ff04                bra.w #$ff04 == $00004378 (T)


00004476 0887 0005                bclr.l #$0005,d7
0000447a 6000 fefc                bra.w #$fefc == $00004378 (T)
0000447e 066c 0100 0052           add.w #$0100,(a4,$0052) == $000015aa [0000]
00004484 6000 fef2                bra.w #$fef2 == $00004378 (T)
00004488 0887 0004                bclr.l #$0004,d7
0000448c 08c7 0007                bset.l #$0007,d7
00004490 426c 004c                clr.w (a4,$004c) == $000015a4 [0000]
00004494 6000 0206                bra.w #$0206 == $0000469c (T)
00004498 08c7 0003                bset.l #$0003,d7
0000449c 195b 0024                move.b (a3)+ [4e],(a4,$0024) == $0000157c [00]
000044a0 195b 0025                move.b (a3)+ [4e],(a4,$0025) == $0000157d [00]
000044a4 6000 fed2                bra.w #$fed2 == $00004378 (T)
000044a8 0247 fff8                and.w #$fff8,d7
000044ac 08c7 0000                bset.l #$0000,d7
000044b0 195b 0021                move.b (a3)+ [4e],(a4,$0021) == $00001579 [00]
000044b4 195b 0022                move.b (a3)+ [4e],(a4,$0022) == $0000157a [00]
000044b8 6000 febe                bra.w #$febe == $00004378 (T)
000044bc 0887 0000                bclr.l #$0000,d7
000044c0 6000 feb6                bra.w #$feb6 == $00004378 (T)
000044c4 0247 fff8                and.w #$fff8,d7
000044c8 08c7 0001                bset.l #$0001,d7
000044cc 41f9 0001 b986           lea.l $0001b986,a0
000044d2 7000                     moveq #$00,d0
000044d4 101b                     move.b (a3)+ [4e],d0
000044d6 d040                     add.w d0,d0
000044d8 d0c0                     adda.w d0,a0
000044da d0d0                     adda.w (a0) [236b],a0
000044dc 1958 0032                move.b (a0)+ [23],(a4,$0032) == $0000158a [00]
000044e0 1958 0030                move.b (a0)+ [23],(a4,$0030) == $00001588 [00]
000044e4 2948 0028                move.l a0,(a4,$0028) == $00001580 [00000000]
000044e8 6000 fe8e                bra.w #$fe8e == $00004378 (T)

000044ec 0887 0001                bclr.l #$0001,d7
000044f0 6000 fe86                bra.w #$fe86 == $00004378 (T)
000044f4 0247 fff8                and.w #$fff8,d7
000044f8 08c7 0002                bset.l #$0002,d7
000044fc 195b 0036                move.b (a3)+ [4e],(a4,$0036) == $0000158e [00]
00004500 195b 0034                move.b (a3)+ [4e],(a4,$0034) == $0000158c [00]
00004504 195b 0035                move.b (a3)+ [4e],(a4,$0035) == $0000158d [00]
00004508 6000 fe6e                bra.w #$fe6e == $00004378 (T)

0000450c 0887 0002                bclr.l #$0002,d7
00004510 6000 fe66                bra.w #$fe66 == $00004378 (T)
00004514 41f9 0001 b98c           lea.l $0001b98c,a0
0000451a 7000                     moveq #$00,d0
0000451c 101b                     move.b (a3)+,d0
0000451e d040                     add.w d0,d0
00004520 d0c0                     adda.w d0,a0
00004522 d0d0                     adda.w (a0),a0
00004524 2948 0014                move.l a0,(a4,$0014) 
00004528 6000 fe4e                bra.w #$fe4e == $00004378 (T)

0000452c 41f9 0000 4bea           lea.l $00004bea,a0
00004532 7000                     moveq #$00,d0
00004534 101b                     move.b (a3)+ [4e],d0
00004536 e940                     asl.w #$04,d0
00004538 d0c0                     adda.w d0,a0
0000453a 3958 003c                move.w (a0)+ [236b],(a4,$003c) == $00001594 [0000]
0000453e 2958 003e                move.l (a0)+ [236b0126],(a4,$003e) == $00001596 [00000000]
00004542 3958 0042                move.w (a0)+ [236b],(a4,$0042) == $0000159a [0000]
00004546 2958 0044                move.l (a0)+ [236b0126],(a4,$0044) == $0000159c [00000000]
0000454a 3958 0048                move.w (a0)+ [236b],(a4,$0048) == $000015a0 [0000]
0000454e 0887 0006                bclr.l #$0006,d7
00004552 4a50                     tst.w (a0) [236b]
00004554 6700 fe22                beq.w #$fe22 == $00004378 (T)
00004558 08c7 0006                bset.l #$0006,d7
0000455c 6000 fe1a                bra.w #$fe1a == $00004378 (T)
00004560 0807 0006                btst.l #$0006,d7
00004564 6604                     bne.b #$04 == $0000456a (F)
00004566 d02c 0013                add.b (a4,$0013) == $0000156b [00],d0
0000456a 1940 004f                move.b d0,(a4,$004f) == $000015a7 [00]
0000456e 0807 0000                btst.l #$0000,d7
00004572 670a                     beq.b #$0a == $0000457e (T)
00004574 d02c 0021                add.b (a4,$0021) == $00001579 [00],d0
00004578 196c 0022 0023           move.b (a4,$0022) == $0000157a [00],(a4,$0023) == $0000157b [00]
0000457e 1940 0050                move.b d0,(a4,$0050) == $000015a8 [00]
00004582 4880                     ext.w d0
00004584 906c 003c                sub.w (a4,$003c) == $00001594 [0000],d0
00004588 d040                     add.w d0,d0
0000458a b07c ffd0                cmp.w #$ffd0,d0
0000458e 6d06                     blt.b #$06 == $00004596 (F)
00004590 b07c 002c                cmp.w #$002c,d0
00004594 6f16                     ble.b #$16 == $000045ac (T)
00004596 122c 004f                move.b (a4,$004f) == $000015a7 [00],d1
0000459a 142c 0050                move.b (a4,$0050) == $000015a8 [00],d2
0000459e 362c 003c                move.w (a4,$003c) == $00001594 [0000],d3
000045a2 382c 0054                move.w (a4,$0054) == $000015ac [0000],d4
000045a6 246c 0006                movea.l (a4,$0006) == $0000155e [00000000],a2
000045aa 4afc                     illegal
000045ac 3975 0000 004a           move.w (a5,d0.W,$00) == $00c014b6 [00c0],(a4,$004a) == $000015a2 [0000]
000045b2 0807 0002                btst.l #$0002,d7
000045b6 675a                     beq.b #$5a == $00004612 (T)
000045b8 102c 0050                move.b (a4,$0050) == $000015a8 [00],d0


000045bc d02c 0034                add.b (a4,$0034) == $0000158c [00],d0
000045c0 4880                     ext.w d0
000045c2 906c 003c                sub.w (a4,$003c) == $00001594 [0000],d0
000045c6 d040                     add.w d0,d0
000045c8 b07c ffd0                cmp.w #$ffd0,d0
000045cc 6d06                     blt.b #$06 == $000045d4 (F)
000045ce b07c 002c                cmp.w #$002c,d0
000045d2 6f16                     ble.b #$16 == $000045ea (T)
000045d4 122c 004f                move.b (a4,$004f) == $000015a7 [00],d1
000045d8 142c 0050                move.b (a4,$0050) == $000015a8 [00],d2
>d
000045dc 362c 003c                move.w (a4,$003c) == $00001594 [0000],d3
000045e0 382c 0054                move.w (a4,$0054) == $000015ac [0000],d4
000045e4 246c 0006                movea.l (a4,$0006) == $0000155e [00000000],a2
000045e8 4afc                     illegal
000045ea 3035 0000                move.w (a5,d0.W,$00) == $00c014b6 [00c0],d0
000045ee 906c 004a                sub.w (a4,$004a) == $000015a2 [0000],d0
000045f2 e240                     asr.w #$01,d0
000045f4 48c0                     ext.l d0
000045f6 122c 0035                move.b (a4,$0035) == $0000158d [00],d1
000045fa 4881                     ext.w d1
>d
000045fc 81c1                     divs.w d1,d0
000045fe 3940 003a                move.w d0,(a4,$003a) == $00001592 [0000]
00004602 1941 0039                move.b d1,(a4,$0039) == $00001591 [00]
00004606 d201                     add.b d1,d1
00004608 1941 0038                move.b d1,(a4,$0038) == $00001590 [00]
0000460c 196c 0036 0037           move.b (a4,$0036) == $0000158e [00],(a4,$0037) == $0000158f [00]
00004612 0807 0003                btst.l #$0003,d7
00004616 6750                     beq.b #$50 == $00004668 (T)
00004618 102c 0050                move.b (a4,$0050) == $000015a8 [00],d0
0000461c d02c 0024                add.b (a4,$0024) == $0000157c [00],d0
>d
00004620 4880                     ext.w d0
00004622 906c 003c                sub.w (a4,$003c) == $00001594 [0000],d0
00004626 d040                     add.w d0,d0
00004628 b07c ffd0                cmp.w #$ffd0,d0
0000462c 6d06                     blt.b #$06 == $00004634 (F)
0000462e b07c 002c                cmp.w #$002c,d0
00004632 6f16                     ble.b #$16 == $0000464a (T)
00004634 122c 004f                move.b (a4,$004f) == $000015a7 [00],d1
00004638 142c 0050                move.b (a4,$0050) == $000015a8 [00],d2
0000463c 362c 003c                move.w (a4,$003c) == $00001594 [0000],d3
>d
00004640 382c 0054                move.w (a4,$0054) == $000015ac [0000],d4
00004644 246c 0006                movea.l (a4,$0006) == $0000155e [00000000],a2
00004648 4afc                     illegal
0000464a 3035 0000                move.w (a5,d0.W,$00) == $00c014b6 [00c0],d0
0000464e 906c 004a                sub.w (a4,$004a) == $000015a2 [0000],d0
00004652 48c0                     ext.l d0
00004654 7200                     moveq #$00,d1
00004656 122c 0025                move.b (a4,$0025) == $0000157d [00],d1
0000465a 81c1                     divs.w d1,d0
0000465c 3940 0026                move.w d0,(a4,$0026) == $0000157e [0000]


00004660 4440                     neg.w d0
00004662 c1c1                     muls.w d1,d0
00004664 916c 004a                sub.w d0,(a4,$004a) == $000015a2 [0000]
00004668 0807 0001                btst.l #$0001,d7
0000466c 6712                     beq.b #$12 == $00004680 (T)
0000466e 197c 0001 0033           move.b #$01,(a4,$0033) == $0000158b [00]
00004674 296c 0028 002c           move.l (a4,$0028) == $00001580 [00000000],(a4,$002c) == $00001584 [00000000]
0000467a 196c 0030 0031           move.b (a4,$0030) == $00001588 [00],(a4,$0031) == $00001589 [00]
00004680 08c7 0004                bset.l #$0004,d7
00004684 296c 0014 0018           move.l (a4,$0014) == $0000156c [00000000],(a4,$0018) == $00001570 [00000000]
>d
0000468a 397c 0001 001e           move.w #$0001,(a4,$001e) == $00001576 [0000]
00004690 426c 004c                clr.w (a4,$004c) == $000015a4 [0000]
00004694 302c 0054                move.w (a4,$0054) == $000015ac [0000],d0
00004698 8178 417c                or.w d0,$417c [0000]
0000469c 7000                     moveq #$00,d0
0000469e 102c 0051                move.b (a4,$0051) == $000015a9 [00],d0
000046a2 0807 0005                btst.l #$0005,d7
000046a6 6602                     bne.b #$02 == $000046aa (F)
000046a8 101b                     move.b (a3)+ [4e],d0
000046aa d16c 0052                add.w d0,(a4,$0052) == $000015aa [0000]
>d
000046ae 294b 000e                move.l a3,(a4,$000e) == $00001566 [00000000]
000046b2 0807 0007                btst.l #$0007,d7
000046b6 6600 0198                bne.w #$0198 == $00004850 (F)
000046ba 302c 004a                move.w (a4,$004a) == $000015a2 [0000],d0
000046be 0807 0003                btst.l #$0003,d7
000046c2 6712                     beq.b #$12 == $000046d6 (T)
000046c4 532c 0025                subq.b #$01,(a4,$0025) == $0000157d [00]
000046c8 6604                     bne.b #$04 == $000046ce (F)
000046ca 0887 0003                bclr.l #$0003,d7
000046ce 906c 0026                sub.w (a4,$0026) == $0000157e [0000],d0
>d
000046d2 6000 00d4                bra.w #$00d4 == $000047a8 (T)


000046d6 0807 0000                btst.l #$0000,d7
000046da 6746                     beq.b #$46 == $00004722 (T)
000046dc 532c 0023                subq.b #$01,(a4,$0023) == $0000157b [00]
000046e0 6400 00c6                bcc.w #$00c6 == $000047a8 (T)
000046e4 102c 004f                move.b (a4,$004f) == $000015a7 [00],d0
000046e8 122c 0050                move.b (a4,$0050) == $000015a8 [00],d1
000046ec 1940 0050                move.b d0,(a4,$0050) == $000015a8 [00]
000046f0 4880                     ext.w d0
000046f2 906c 003c                sub.w (a4,$003c) == $00001594 [0000],d0
>d
000046f6 d040                     add.w d0,d0
000046f8 b07c ffd0                cmp.w #$ffd0,d0
000046fc 6d06                     blt.b #$06 == $00004704 (F)
000046fe b07c 002c                cmp.w #$002c,d0
00004702 6f16                     ble.b #$16 == $0000471a (T)
00004704 122c 004f                move.b (a4,$004f) == $000015a7 [00],d1
00004708 142c 0050                move.b (a4,$0050) == $000015a8 [00],d2
0000470c 362c 003c                move.w (a4,$003c) == $00001594 [0000],d3
00004710 382c 0054                move.w (a4,$0054) == $000015ac [0000],d4
00004714 246c 0006                movea.l (a4,$0006) == $0000155e [00000000],a2



00004718 4afc                     illegal
0000471a 3035 0000                move.w (a5,d0.W,$00) == $00c014b6 [00c0],d0
0000471e 6000 0088                bra.w #$0088 == $000047a8 (T)
00004722 0807 0001                btst.l #$0001,d7
00004726 675c                     beq.b #$5c == $00004784 (T)
00004728 532c 0033                subq.b #$01,(a4,$0033) == $0000158b [00]
0000472c 667a                     bne.b #$7a == $000047a8 (F)
0000472e 206c 002c                movea.l (a4,$002c) == $00001584 [00000000],a0
00004732 1018                     move.b (a0)+ [23],d0
00004734 532c 0031                subq.b #$01,(a4,$0031) == $00001589 [00]
>d
00004738 660a                     bne.b #$0a == $00004744 (F)
0000473a 206c 0028                movea.l (a4,$0028) == $00001580 [00000000],a0
0000473e 196c 0030 0031           move.b (a4,$0030) == $00001588 [00],(a4,$0031) == $00001589 [00]
00004744 2948 002c                move.l a0,(a4,$002c) == $00001584 [00000000]
00004748 196c 0032 0033           move.b (a4,$0032) == $0000158a [00],(a4,$0033) == $0000158b [00]
0000474e d02c 0050                add.b (a4,$0050) == $000015a8 [00],d0
00004752 4880                     ext.w d0
00004754 906c 003c                sub.w (a4,$003c) == $00001594 [0000],d0
00004758 d040                     add.w d0,d0
0000475a b07c ffd0                cmp.w #$ffd0,d0
>d
0000475e 6d06                     blt.b #$06 == $00004766 (F)
00004760 b07c 002c                cmp.w #$002c,d0
00004764 6f16                     ble.b #$16 == $0000477c (T)
00004766 122c 004f                move.b (a4,$004f) == $000015a7 [00],d1
0000476a 142c 0050                move.b (a4,$0050) == $000015a8 [00],d2
0000476e 362c 003c                move.w (a4,$003c) == $00001594 [0000],d3
00004772 382c 0054                move.w (a4,$0054) == $000015ac [0000],d4
00004776 246c 0006                movea.l (a4,$0006) == $0000155e [00000000],a2
0000477a 4afc                     illegal
0000477c 3035 0000                move.w (a5,d0.W,$00) == $00c014b6 [00c0],d0
>d
00004780 6000 0026                bra.w #$0026 == $000047a8 (T)
00004784 0807 0002                btst.l #$0002,d7
00004788 671e                     beq.b #$1e == $000047a8 (T)
0000478a 532c 0037                subq.b #$01,(a4,$0037) == $0000158f [00]
0000478e 6418                     bcc.b #$18 == $000047a8 (T)
00004790 522c 0037                addq.b #$01,(a4,$0037) == $0000158f [00]
00004794 532c 0039                subq.b #$01,(a4,$0039) == $00001591 [00]
00004798 660a                     bne.b #$0a == $000047a4 (F)
0000479a 446c 003a                neg.w (a4,$003a) == $00001592 [0000]
0000479e 196c 0038 0039           move.b (a4,$0038) == $00001590 [00],(a4,$0039) == $00001591 [00]
000047a4 d06c 003a                add.w (a4,$003a) == $00001592 [0000],d0
000047a8 3940 004a                move.w d0,(a4,$004a) == $000015a2 [0000]
000047ac 0807 0004                btst.l #$0004,d7
000047b0 6700 009e                beq.w #$009e == $00004850 (T)
000047b4 536c 001e                subq.w #$01,(a4,$001e) == $00001576 [0000]
000047b8 6600 0080                bne.w #$0080 == $0000483a (F)
000047bc 206c 0018                movea.l (a4,$0018) == $00001570 [00000000],a0
000047c0 7000                     moveq #$00,d0
000047c2 1018                     move.b (a0)+ [23],d0
000047c4 6742                     beq.b #$42 == $00004808 (T)
000047c6 6b1a                     bmi.b #$1a == $000047e2 (F)
000047c8 3940 001e                move.w d0,(a4,$001e) == $00001576 [0000]
000047cc 197c 0001 001c           move.b #$01,(a4,$001c) == $00001574 [00]
000047d2 197c 0001 001d           move.b #$01,(a4,$001d) == $00001575 [00]
000047d8 1958 0020                move.b (a0)+ [23],(a4,$0020) == $00001578 [00]
000047dc 2948 0018                move.l a0,(a4,$0018) == $00001570 [00000000]
000047e0 6058                     bra.b #$58 == $0000483a (T)
000047e2 4400                     neg.b d0
000047e4 3940 001e                move.w d0,(a4,$001e) == $00001576 [0000]
000047e8 197c 0001 0020           move.b #$01,(a4,$0020) == $00001578 [00]
000047ee 1018                     move.b (a0)+ [23],d0
000047f0 6a06                     bpl.b #$06 == $000047f8 (T)
000047f2 4400                     neg.b d0
000047f4 442c 0020                neg.b (a4,$0020) == $00001578 [00]
000047f8 1940 001c                move.b d0,(a4,$001c) == $00001574 [00]
000047fc 197c 0001 001d           move.b #$01,(a4,$001d) == $00001575 [00]
00004802 2948 0018                move.l a0,(a4,$0018) == $00001570 [00000000]
00004806 6032                     bra.b #$32 == $0000483a (T)
00004808 1010                     move.b (a0) [23],d0
0000480a 670a                     beq.b #$0a == $00004816 (T)
0000480c 6a02                     bpl.b #$02 == $00004810 (T)
0000480e 4400                     neg.b d0
00004810 906c 0052                sub.w (a4,$0052) == $000015aa [0000],d0
00004814 6b06                     bmi.b #$06 == $0000481c (F)
00004816 0887 0004                bclr.l #$0004,d7
0000481a 6034                     bra.b #$34 == $00004850 (T)
0000481c 4440                     neg.w d0
0000481e 3940 001e                move.w d0,(a4,$001e) == $00001576 [0000]
00004822 197c 0000 001c           move.b #$00,(a4,$001c) == $00001574 [00]
00004828 197c 0000 001d           move.b #$00,(a4,$001d) == $00001575 [00]
0000482e 197c 0000 0020           move.b #$00,(a4,$0020) == $00001578 [00]
00004834 2948 0018                move.l a0,(a4,$0018) == $00001570 [00000000]
00004838 6016                     bra.b #$16 == $00004850 (T)
0000483a 532c 001d                subq.b #$01,(a4,$001d) == $00001575 [00]
0000483e 6610                     bne.b #$10 == $00004850 (F)
00004840 196c 001c 001d           move.b (a4,$001c) == $00001574 [00],(a4,$001d) == $00001575 [00]
00004846 102c 0020                move.b (a4,$0020) == $00001578 [00],d0
0000484a 4880                     ext.w d0
0000484c d16c 004c                add.w d0,(a4,$004c) == $000015a4 [0000]
00004850 4e75                     rts  == $00fc072a




00004852 3038 417c                move.w $417c [0000],d0
00004856 676e                     beq.b #$6e == $000048c6 (T)
00004858 3d40 0096                move.w d0,(a6,$0096) == $00c03b3a [0100]
0000485c 3200                     move.w d0,d1
0000485e ef49                     lsl.w #$07,d1
00004860 3d41 009c                move.w d1,(a6,$009c) == $00c03b40 [0000]
00004864 7400                     moveq #$00,d2
00004866 7601                     moveq #$01,d3
00004868 0800 0000                btst.l #$0000,d0
0000486c 6708                     beq.b #$08 == $00004876 (T)
0000486e 3d43 00a6                move.w d3,(a6,$00a6) == $00c03b4a [0000]
00004872 3d42 00aa                move.w d2,(a6,$00aa) == $00c03b4e [0000]
00004876 0800 0001                btst.l #$0001,d0
0000487a 6708                     beq.b #$08 == $00004884 (T)
0000487c 3d43 00b6                move.w d3,(a6,$00b6) == $00c03b5a [ff3e]
00004880 3d42 00ba                move.w d2,(a6,$00ba) == $00c03b5e [00fd]
00004884 0800 0002                btst.l #$0002,d0
00004888 6708                     beq.b #$08 == $00004892 (T)
0000488a 3d43 00c6                move.w d3,(a6,$00c6) == $00c03b6a [00fd]
0000488e 3d42 00ca                move.w d2,(a6,$00ca) == $00c03b6e [4ef9]
00004892 0800 0003                btst.l #$0003,d0
00004896 6708                     beq.b #$08 == $000048a0 (T)
00004898 3d43 00d6                move.w d3,(a6,$00d6) == $00c03b7a [4ef9]
0000489c 3d42 00da                move.w d2,(a6,$00da) == $00c03b7e [fedc]
000048a0 342e 001e                move.w (a6,$001e) == $00c03ac2 [0000],d2
000048a4 c441                     and.w d1,d2
000048a6 b441                     cmp.w d1,d2
000048a8 66f6                     bne.b #$f6 == $000048a0 (F)
000048aa 7402                     moveq #$02,d2
000048ac 362e 0006                move.w (a6,$0006) == $00c03aaa [39c8],d3
000048b0 0243 ff00                and.w #$ff00,d3
000048b4 382e 0006                move.w (a6,$0006) == $00c03aaa [39c8],d4
000048b8 0244 ff00                and.w #$ff00,d4
000048bc b644                     cmp.w d4,d3
000048be 67f4                     beq.b #$f4 == $000048b4 (T)
000048c0 3604                     move.w d4,d3
000048c2 51ca fff0                dbf .w d2,#$fff0 == $000048b4 (F)
000048c6 3238 401c                move.w $401c [ffff],d1
000048ca 3438 401e                move.w $401e [ffff],d2
000048ce 41f8 4024                lea.l  channel_1_status,a0                            ;$4024,a0
000048d2 3601                     move.w d1,d3
000048d4 0810 0006                btst.b #$0006,(a0) [23]
000048d8 6702                     beq.b #$02 == $000048dc (T)
000048da 3602                     move.w d2,d3
000048dc c668 004c                and.w (a0,$004c) == $00fe9762 [2269],d3
000048e0 3d43 00a8                move.w d3,(a6,$00a8) == $00c03b4c [0000]
000048e4 3d68 004a 00a6           move.w (a0,$004a) == $00fe9760 [2051],(a6,$00a6) == $00c03b4a [0000]
000048ea 0800 0000                btst.l #$0000,d0
000048ee 670e                     beq.b #$0e == $000048fe (T)
000048f0 3d68 0042 00a4           move.w (a0,$0042) == $00fe9758 [2040],(a6,$00a4) == $00c03b48 [0000]
000048f6 2d68 003e 00a0           move.l (a0,$003e) == $00fe9754 [23400004],(a6,$00a0) == $00c03b44 [00c03b06]
000048fc 600c                     bra.b #$0c == $0000490a (T)

000048fe 3d68 0048 00a4           move.w (a0,$0048) == $00fe975e [2209],(a6,$00a4) == $00c03b48 [0000]
00004904 2d68 0044 00a0           move.l (a0,$0044) == $00fe975a [20894e75],(a6,$00a0) == $00c03b44 [00c03b06]
0000490a 41f8 407a                lea.l $407a,a0
0000490e 3601                     move.w d1,d3
00004910 0810 0006                btst.b #$0006,(a0) [23]
00004914 6702                     beq.b #$02 == $00004918 (T)
00004916 3602                     move.w d2,d3
00004918 c668 004c                and.w (a0,$004c) == $00fe9762 [2269],d3
0000491c 3d43 00b8                move.w d3,(a6,$00b8) == $00c03b5c [4ef9]
00004920 3d68 004a 00b6           move.w (a0,$004a) == $00fe9760 [2051],(a6,$00b6) == $00c03b5a [ff3e]
00004926 0800 0001                btst.l #$0001,d0
0000492a 670e                     beq.b #$0e == $0000493a (T)
0000492c 3d68 0042 00b4           move.w (a0,$0042) == $00fe9758 [2040],(a6,$00b4) == $00c03b58 [00fd]
00004932 2d68 003e 00b0           move.l (a0,$003e) == $00fe9754 [23400004],(a6,$00b0) == $00c03b54 [fc6a4ef9]
00004938 600c                     bra.b #$0c == $00004946 (T)
0000493a 3d68 0048 00b4           move.w (a0,$0048) == $00fe975e [2209],(a6,$00b4) == $00c03b58 [00fd]
00004940 2d68 0044 00b0           move.l (a0,$0044) == $00fe975a [20894e75],(a6,$00b0) == $00c03b54 [fc6a4ef9]
00004946 41f8 40d0                lea.l $40d0,a0
0000494a 3601                     move.w d1,d3
0000494c 0810 0006                btst.b #$0006,(a0) [23]
00004950 6702                     beq.b #$02 == $00004954 (T)
00004952 3602                     move.w d2,d3
00004954 c668 004c                and.w (a0,$004c) == $00fe9762 [2269],d3
00004958 3d43 00c8                move.w d3,(a6,$00c8) == $00c03b6c [ff14]
0000495c 3d68 004a 00c6           move.w (a0,$004a) == $00fe9760 [2051],(a6,$00c6) == $00c03b6a [00fd]
00004962 0800 0002                btst.l #$0002,d0
00004966 670e                     beq.b #$0e == $00004976 (T)
00004968 3d68 0042 00c4           move.w (a0,$0042) == $00fe9758 [2040],(a6,$00c4) == $00c03b68 [4ef9]
0000496e 2d68 003e 00c0           move.l (a0,$003e) == $00fe9754 [23400004],(a6,$00c0) == $00c03b64 [00fdff26]
00004974 600c                     bra.b #$0c == $00004982 (T)
00004976 3d68 0048 00c4           move.w (a0,$0048) == $00fe975e [2209],(a6,$00c4) == $00c03b68 [4ef9]
0000497c 2d68 0044 00c0           move.l (a0,$0044) == $00fe975a [20894e75],(a6,$00c0) == $00c03b64 [00fdff26]
00004982 41f8 4126                lea.l $4126,a0
00004986 3601                     move.w d1,d3
00004988 0810 0006                btst.b #$0006,(a0) [23]
0000498c 6702                     beq.b #$02 == $00004990 (T)
0000498e 3602                     move.w d2,d3
00004990 c668 004c                and.w (a0,$004c) == $00fe9762 [2269],d3
00004994 3d43 00d8                move.w d3,(a6,$00d8) == $00c03b7c [00fd]
00004998 3d68 004a 00d6           move.w (a0,$004a) == $00fe9760 [2051],(a6,$00d6) == $00c03b7a [4ef9]
0000499e 0800 0003                btst.l #$0003,d0
000049a2 670e                     beq.b #$0e == $000049b2 (T)
000049a4 3d68 0042 00d4           move.w (a0,$0042) == $00fe9758 [2040],(a6,$00d4) == $00c03b78 [feee]
000049aa 2d68 003e 00d0           move.l (a0,$003e) == $00fe9754 [23400004],(a6,$00d0) == $00c03b74 [4ef900fd]
000049b0 600c                     bra.b #$0c == $000049be (T)
000049b2 3d68 0048 00d4           move.w (a0,$0048) == $00fe975e [2209],(a6,$00d4) == $00c03b78 [feee]
000049b8 2d68 0044 00d0           move.l (a0,$0044) == $00fe975a [20894e75],(a6,$00d0) == $00c03b74 [4ef900fd]
000049be 0040 8000                or.w #$8000,d0
000049c2 3d40 0096                move.w d0,(a6,$0096) == $00c03b3a [0100]
000049c6 4278 417c                clr.w $417c [0000]
000049ca 4e75                     rts  == $00fc072a



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
L0001b9dc       dc.w $003E, $0048, $0049, $0051 
L0001b9e4       dc.w $0000, $0000, $0000, $000A
L0001b9ec       dc.w $0000, $0000, $0000, $0004

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
Title_Screen_Start                                              ; original routine address $0001c000
                bra.w   do_title_screen_start                   ; jmp $0001c008 



                ;-------------------- GAME OVER/COMPLETION ENTRY POINT -----------------------
end_game_start                                                   ; original routine address $0001c004
                bra.w $0001d450




PANEL_INITIALISE_PLAYER_SCORE   EQU     $0007c81c               ; address of Panel.Initialise_Player_Score
PANEL_INITIALISE_PLAYER_LIVES   EQU     $0007c838               ; address of Panel.Initialise_Player_Lives
PANEL_STATUS_1                  EQU     $0007c874               ; address of Panel.Panel_Status_1  
PANEL_PLAYERSCORE               EQU     $0007c878               ; address of Panel.Player_Score
PANEL_HIGHSCORE                 EQU     $0007c87c               ; address of Panel.High_Score
LOADER_LOAD_LEVEL_1             EQU     $824                    ; address of Loader.Load_Level_1()




                ;---------------------------- DO TITLE SCREEN START ----------------------------
                ; Routine to set up & run the title screen.
                ;
                ; Initialised Window start to bottom of screen (probably for scroll up routine)
                ; H/w Ref, standard DIWSRT & DIWSTOP
                ; PAL - $2c81, $2cc1
                ; NTSC- $2c81, $f4c1
                ;
do_title_screen_start                                           ; original routine address $0001c008
L0001c008       clr.l   PANEL_HIGHSCORE                         ; clear Panel.HighScore
L0001c00e       move.l  highscore_table,PANEL_HIGHSCORE         ; set Panel.HighScore
L0001c018       lea.l   temp_stack_top,a7                       ; set temp stack space - $0001d6de,a7

                                                                ; Initialise Window Scroll (start window = bottom of NTSC display)
L0001c01e       move.b  #$f4,copper_diwstrt                     ; reset window start line (usually $2c) - $0001d6e8
L0001c026       move.b  #$f4,copper_diwstop                     ; reset widndow stop line (usually $2c or $f4 PAL/NTSC ) - $0001d6ec

L0001c02e       moveq   #$01,d0                                 ; d0 = frames to wait + 1
L0001c030       bsr.w   raster_wait_161                         ; wait for raster 161 - $0001c2f8

L0001c034       bsr.w   initialise_title_screen                 ; calls $0001c0d8
L0001c038       move.w  #$5000,$00dff100                        ; set 5 bitplane screen - BPLCON0

L0001c040       lea.l   title_screen_colors,a0                  ; $0001d79a - screen colours
L0001c046       bsr.w   copper_copy                             ; calls $0001d3a0

L0001c04a       and.w   #$f89f,PANEL_STATUS_1                   ; clear panel status bits (panel status 1 & 2)
                                                                ; low 3 bits of status 1 (game over, life lost, timer expired)
                                                                ; bits 6 & 5 of status 2 (don't know what these do yet) - Think it's end game flags (success/fail etc)

L0001c052       bsr.w   init_title_music                        ; calls $0001c1a0 ; Play Song 01 (Title Tune)
L0001c056       bsr.w   copy_title_screen_bitplanes             ; calls $0001ca34 - copy title screen bitplanes to display memory (copper list display)
L0001c05a       bsr.w   L0001c586

start_game                                                      ; original address $0001c05e
L0001c05e       not.w   L0001c09c
L0001c064       cmp.b   #$f4,copper_diwstrt                     ; L0001d6e8
L0001c06c       bne.b    L0001c064

L0001c06e       moveq   #$01,d0                                 ; d0 = frames to wait + 1
L0001c070       bsr.w   raster_wait_161                         ; wait for raster 161 - $0001c2f8

L0001c074       move.l  highscore_table,PANEL_PLAYERSCORE       ; set player score in panel to high score (reset next)
L0001c07e       jsr     PANEL_INITIALISE_PLAYER_SCORE           ; calls Panel.Initialise_Player_Score
L0001c084       jsr     PANEL_INITIALISE_PLAYER_LIVES           ; calls Panel.Initialise_Player_Lives
L0001c08a       jsr     L00004008
L0001c090       jmp     LOADER_LOAD_LEVEL_1                     ; jmp $00000824 - Loader.Load_Level_1

L0001c096       jmp $0001d542

L0001c09c       or.b #$79,d0
L0001c0a0       or.b #$9c,d1

L0001c0a4       bne.b #$14 == $0001c0ba (T)
L0001c0a6       cmp.b #$2c,copper_diwstrt                       ; $0001d6e8 
L0001c0ae       beq.b #$08 == $0001c0b8 (F)
L0001c0b0       sub.w #$0100,copper_diwstrt                     ; $0001d6e8
L0001c0b8       rts  == $00c00276

L0001c0ba       cmp.b #$f4,copper_diwstrt                       ; $0001d6e8
L0001c0c2       beq.b #$12 == $0001c0d6 (F)
L0001c0c4       bcs.b #$08 == $0001c0ce (F)
L0001c0c6       move.b #$f0,copper_diwstrt                      ; $0001d6e8
L0001c0ce       add.w #$0400,copper_diwstrt                     ; $0001d6e8
L0001c0d6       rts  == $00c00276



                ;--------------------------- initialise title screen ----------------------------
                ; set up the system, interrupts annd display.
                ; NB: Level 6 interrupt enabled, but no handler (set previously in disk loader)
                ;
initialise_title_screen                                         ; original routine address $0001c0d8
L0001c0d8       move.l  #$f481f4c1,$00dff08e                    ; DIWSTRT/DIWSTOP - Initialise
L0001c0e2       move.w  #$7fff,d0       
L0001c0e6       move.w  d0,$00dff096                            ; DMACON - DMA off
L0001c0ec       move.w  d0,$00dff09a                            ; INTENA - Interrupts off
L0001c0f2       move.w  d0,$00dff09c                            ; INTREQ - Clear Interrupt Requests
L0001c0f8       move.l  #level_1_interrupt_handler,$00000064    ; Level 1 Interrupt Vector
L0001c102       move.l  #level_2_interrupt_handler,$00000068    ; Level 2 Interrupt Vector           
L0001c10c       move.l  #level_3_interrupt_handler,$0000006c    ; Level 3 Interrupt Vector   
L0001c116       move.l  #level_4_interrupt_handler,$00000070    ; Level 4 Interrupt Vector        
L0001c120       move.l  #level_5_interrupt_handler,$00000074    ; Level 5 Interrupt Vector
L0001c12a       move.w  #$e028,$00dff09a                        ; PORTS/TIMERS(2),VERTB(3),EXTER(6),INTEN,SET/CLR (no level 1,4,5) !No Level 6 handler
L0001c132       move.w  #$83c0,$00dff096
L0001c13a       move.l  #copper_list,$dff080                     ;#$0001d6e2,$00dff080
L0001c144       move.w  d0,$00dff088
L0001c14a       move.b  #$7f,$00bfed01
L0001c152       move.b  #$7f,$00bfed01
L0001c15a       jsr     $00004000
L0001c160       move.l  #$00001f40,d0
L0001c166       bra.w   #$1176 == $0001d2de (T)
L0001c16a       clr.w   $0001c2f0 [0000]
L0001c170       rts




L0001c172       btst.b  #$0000,raw_keyboard_serial_data          ; L0001c2ed
L0001c17a       bne.w   L0001c1b8
L0001c17e       tst.w   L0001c2f2
L0001c184       bne.w   L0001c170
L0001c188       cmp.w   #$005c,L0001c2ec
L0001c190       bne.b   L0001c1b8
L0001c192       not.w   L0001c2f2
L0001c198       bchg.b  #$0000,panel_status_2                   ; $0007c875


                ;------------------- Init Title Music -----------------
init_title_music                                                ; original routine address $0001c1a0
                btst.b  #$0000,$0007c875                        ; test bit 0 of panel_status_2 (no idea?)
                beq.b   .init_song_01 
                jmp     Silence_All_Audio                       ; calls $00004004 - end music
.init_song_01
                moveq   #$01,d0                                 ; set tune to play? 
                jmp     Play_Song                               ; jmp $00004010
                ; uses rts in Play_Song to return to caller.



L0001c1b8       clr.w L0001c2f2
L0001c1be       rts



                ;----------------------- handle level 2 interrupt ----------------------
                ; Called from:
                ;       level_2_interrupt_handler
                ;
handle_level_2_interrupt
L0001c1c0       btst.b  #$0000,raw_keyboard_serial_data                  ; $0001c2ed
L0001c1c8       bne.w   L0001c16a
L0001c1cc       tst.w   L0001c2f0
L0001c1d2       bne.b   L0001c24a
L0001c1d4       move.w  L0001c2ec,d0
L0001c1da       and.b   #$fe,d0
L0001c1de       move.w  d0,L0001c2f0
L0001c1e4       lea.l   L0001c258,a0
L0001c1ea       cmp.b   (a0),d0
L0001c1ec       beq.w   L0001c1fe
L0001c1f0       cmp.b   #$ff,(a0)
L0001c1f4       beq.w   L0001c24a
L0001c1f8       addaq.l #$02,a0
L0001c1fa       bra.w   L0001c1ea
L0001c1fe       move.b  $0001(a0),d1
L0001c202       lea.l   L0001c24d,a0
L0001c208       moveq   #$05,d0
L0001c20a       move.b  (a0),-$0001(a0)
L0001c20e       addaq.l #$01,a0
L0001c210       dbf.w   d0,L0001c20a
L0001c214       move.b  d1,L0001c251
L0001c21a       lea.l   L0001c24c,a0
L0001c220       lea.l   L0001c252,a1
L0001c226       moveq   #$05,d0
L0001c228       cmpm.b  (a0)+,(a1)+
L0001c22a       bne.b   L0001c24a
L0001c22c       dbf.w   d0,L0001c228
L0001c230       bchg.b  #$0007,$0007c875                        ; Enable CHEAT?
L0001c238       move.b  #$f4,copper_diwstrt                     ; $0001d6e8
L0001c240       move.l  #$00001f40,d0
L0001c246       bsr.w   L0001d2de
L0001c24a       rts 


L0001c24c       dc.w $2020                     ;move.l -(a0) [40044e75],d0
L0001c24e       dc.w $2020                     ;move.l -(a0) [40044e75],d0
L0001c250       dc.w $2020                     ;move.l -(a0) [40044e75],d0
L0001c252       dc.w $4958                     ;illegal
L0001c254       dc.w $4c4c                     ;illegal
L0001c256       dc.w $4c4c                     ;illegal
L0001c258       dc.w $be58                     ;cmp.w (a0)+ [236b],d7
L0001c25a       dc.w $ae31                     ;illegal

L0001c25c       sub.w (a1) [00c0],d1
L0001c25e       sub.w a4,d0
L0001c260       add.b -(a0) [75],d0
L0001c262       cmp.b (a0,a5.L[*2],$4a) == $01beac16 (68020+),d0
L0001c266       cmp.w a1,d1
L0001c268       and.w d6,d7
L0001c26a       sub.w (a6) [00c0],d2

level_1_interrupt_handler
L0001c26c       rte

                ;---------------------- level 2 interrupt handler -------------------
                ; PORTS/TIMERS - Level 2 Interrupt Handler
                ; CIA-A Timers & Ports
                ;
                ; The ICR Register is cleared by reading the register, but this
                ; code immediately sets it back to the value it just read.
                ; The implications of this are that if this inteerrupt was not
                ; raised by the CIAA then bit 7 will = 0, this means that when
                ; that value is written back to the register then it will
                ; mask the interrupts tht just occurred.
                ; Conversly if the interrupt was raised by the CIAA then Bit 7 
                ; will be 1, this set the interrupt enable for the interrupts
                ; that were raised. This code looks dodgy/hacky
                ;
                ; later the ICR is then set to #$08 which masks the SP bit
                ; this sets the SP bit to 0, which is the keyboard interrupt
                ; serial register bit. So this interrupt is being disabled here
                ; as far as I can make out.
                ;
level_2_interrupt_handler
L0001c26e       movem.l d0-d7/a0-a6,-(a7)
L0001c272       move.b  $00bfec01,raw_keyboard_serial_data                      ; SDR - $0001c2ed ; keyboard serial data
L0001c27c       move.b  $00bfed01,$00bfed01                                     ; ICR - WTF-1!, clear the interrupt control if not a CIAA/Set Interrupts if is CIAA
L0001c286       move.w  #$0808,$00dff09c                                        ; INTREQ - Clear PORTS(2), 
                                                                                ; WTF-2! - Clear RBF(5) (keyboard serial) - Level 5 Interrupt!
L0001c28e       move.b  #$08,$00bfed01                                          ; ICR - Mask SP bit = 0 (keyboard serial)
L0001c296       move.b  #$60,$00bfee01                                          ; CRA - Timer A Control - LOAD=1, SPMODE=1
L0001c29e       bsr.w   handle_level_2_interrupt                                ; calls $0001c1c0
L0001c2a2       movem.l (a7)+,d0-d7/a0-a6
L0001c2a6       rte



level_3_interrupt_handler
L0001c2a8       movem.l d0-d7/a0-a6,-(a7)
L0001c2ac       jsr $00004018
L0001c2b2       bsr.w #$fdea == $0001c09e
L0001c2b6       move.b $00bfed01,$00bfed01
L0001c2c0       move.b #$08,$00bfee01
L0001c2c8       move.b #$88,$00bfed01
L0001c2d0       move.w #$0020,$00dff09c
L0001c2d8       not.w $0001c2e8 [0000]
L0001c2de       movem.l (a7)+,d0-d7/a0-a6
L0001c2e2       rte  == $027600c0

level_4_interrupt_handler
L0001c2e4       rte

level_5_interrupt_handler
L0001c2e6       rte


L0001C2E8       dc.w $0000
L0001C2EA       dc.w $0000
                dc.b $00
raw_keyboard_serial_data                                                ; original address $0001c2ed
L0001c2ed       dc.b $00
                dc.w $0000, $0000, 
L0001c2f2       dc.w $0000
L0001c2f4       dc.w $0000, $0000



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
                dc.W    $0000                           ; y co-ord (line value)

start_coords_ptr                                        ; original address L0001c314
                dc.l    $00000000                       ; $0001c784 - address containing x,y co-ordinates


L0001c318       add.w #$0001,d7
L0001c31c       move.w d7,$00dff180
L0001c322       rts  == $00c00276



                ; IN: a6 - display co-ords (x,y bytes)
                ;       - L0001c96e,a6 ; (a6) = $0c30
                ;
L0001c324       move.l  a6,start_coords_ptr                     ; $0001c314 ; store a6 address
L0001c32a       move.b  (a6)+,x_coord+1                         ; store x coord - $0001c311
L0001c330       move.b  (a6)+,y_coord+1                         ; store y coord - $0001c313
resume_text_start_line
L0001c336       moveq   #$00,d0
L0001c338       move.w  y_coord,d0                              ; $0001c312 ; d0 = y co-ord
L0001c33e       mulu.w  #$0028,d0                               ; d0 = d0 * 40 (bytes per scan line)
L0001c342       add.w   x_coord,d0                              ; $0001c310 ; d0 = d0 + x co-ord
L0001c348       add.l   #DISPLAY_BITPLANE_ADDRESS               ; #$00063190,d0 ; add bitplane base address
L0001c34e       exg.l   d0,a2                                   ; a2 = display destination address
L0001c350       movea.l a2,a3                                   ; a3 = display destination address
resume_text_current_position
L0001c352       tst.w   typer_extended_command_1                ; $0001c782 - exension command/params (for commands #$02)
L0001c358       bne.w   wait_or_start_game                      ; jmp $0001c50e
L0001c35c       move.b  (a6)+,d0                                ; get display param
L0001c35e       cmp.b   #$ff,d0
L0001c362       beq.w   return_rts                              ; $0001c30e
L0001c366       cmp.b   #$0d,d0
L0001c36a       beq.w   crlf                                    ; jmp $0001c4d0 - crlf - carriage return plus line feed
L0001c36e       cmp.b   #$0e,d0
L0001c372       beq.w   lf                                      ; jmp $0001c4dc - lf, line feed
L0001c376       cmp.b   #$01,d0
L0001c37a       beq.w   cls                                     ; jmp $0001c4e8
L0001c37e       cmp.b   #$06,d0
L0001c382       beq.w   _nop                                    ; jmp $0001c580
L0001c386       cmp.b   #$02,d0
L0001c38a       beq.w   L0001c4fe                               ; check fire button/start game?
L0001c38e       cmp.b   #$03,d0
L0001c392       beq.w   L0001c53e
L0001c396       cmp.b   #$04,d0
L0001c39a       beq.w   #$01b2 == $0001c54e (F)
L0001c39e       cmp.b   #$05,d0
L0001c3a2       beq.w   #$01e2 == $0001c586 (F)
L0001c3a6       cmp.b   #$40,d0
L0001c3aa       beq.w   #$004a == $0001c3f6 (F)
L0001c3ae       cmp.b   #$26,d0
L0001c3b2       beq.w   #$0032 == $0001c3e6 (F)
L0001c3b6       cmp.b   #$23,d0
L0001c3ba       beq.w   #$019c == $0001c558 (F)
L0001c3be       cmp.b   #$2e,d0
L0001c3c2       beq.w   #$002a == $0001c3ee (F)
L0001c3c6       and.w   #$003f,d0
L0001c3ca       beq.w   #$0168 == $0001c534 (F)
L0001c3ce       cmp.b   #$20,d0
L0001c3d2       beq.w   #$002a == $0001c3fe (F)
L0001c3d6       cmp.b   #$30,d0
L0001c3da       blt.w   #$0028 == $0001c404 (F)
L0001c3de       sub.w   #$0014,d0
L0001c3e2       bra.w   #$0020 == $0001c404 (T)
L0001c3e6       move.w  #$002c,d0
L0001c3ea       bra.w   #$0018 == $0001c404 (T)
L0001c3ee       move.w  #$002a,d0
L0001c3f2       bra.w   #$0010 == $0001c404 (T)
L0001c3f6       move.b  #$2b,d0
L0001c3fa       bra.w   #$0008 == $0001c404 (T)
L0001c3fe       addaq.l #$01,a3
L0001c400       bra.w   resume_text_current_position                    ; jmp $0001c352
L0001c404       mulu.w  #$0050,d0
L0001c408       add.l   #ASSET_CHARSET_BASE,d0                          ; #$0003f1ea,d0
L0001c40e       exg.l   d0,a1
L0001c410       moveq   #$04,d7
L0001c412       moveq   #$00,d1
L0001c414       movea.l a3,a2
L0001c416       move.b  (a1),(a2)
L0001c418       move.b  $0002(a1),$0028(a2)
L0001c41e       move.b  $0004(a1),$0050(a2)
L0001c424       move.b  $0006(a1),$0078(a2)
L0001c42a       move.b  $0008(a1),$00a0(a2)
L0001c430       move.b  $000a(a1),$00c8(a2)
L0001c436       move.b  $000c(a1),$00f0(a2)
L0001c43c       move.b  $000e(a1),$0118(a2)
L0001c442       adda.l  #$00000010,a1
L0001c448       adda.l  bitplane_size,a2                                ; $0001ca3e,a2
L0001c44e       dbf.w   d7,L0001c416
L0001c452       addaq.l #$01,a3
L0001c454       bra.w   resume_text_current_position                    ; loop next char, $0001c352
L0001c458       rts  



                ;--------------------- plot character x & y ----------------------
                ; plot character at x and y co-ords
char_plot_x_coord                               ; original address $0001c45a
L0001c45a       dc.w $0000                      ; x co-ord (byte value)
char_plot_y_coord                               ; original address $0001c45c
L0001c45c       dc.w $0000                      ; y co-ord (line value)

plot_character
L0001c45e       moveq   #$00,d3
L0001c460       moveq   #$00,d2
L0001c462       move.w  char_plot_y_coord,d2            ; L0001c45c,d3 ; y co-ordinate
L0001c468       move.w  char_plot_x_coord,d2            ; L0001c45a,d2 ; x co-ordinate
L0001c46e       mulu.w  #$0028,d3                       ; d3 = d3 * 40 (raster line)
L0001c472       add.w   d3,d2                           ; d2 = x & y co-ords byte offset
L0001c474       add.l   #DISPLAY_BITPLANE_ADDRESS,d2    ; #$00063190 ; add bitplane 1 base address
L0001c47a       exg.l   d2,a2                           ; a2 = dest address, d1 = prev value of a2
L0001c47c       and.l   #$0000003f,d0                   ; clamp d0 to 0-63
L0001c482       mulu.w  #$0050,d0                       ; 80 bytes per char (16 bytes per bitplane) 8*8
L0001c486       add.l   #ASSET_CHARSET_BASE,d0           ; #$0003f1ea ; character set gfx base address
L0001c48c       exg.l   d0,a1                           ; a1 = character source address
L0001c48e       moveq   #$04,d7                         ; d7 = 4 + 1 - bitplane loop count
L0001c490       moveq   #$00,d1                         ; d1 = 0
.copy_loop
L0001c492       move.b  (a1),(a2)                       ; copy character data line 1
L0001c494       move.b  $0002(a1),$0028(a2)             ; copy character data line 2
L0001c49a       move.b  $0004(a1),$0050(a2)             ; copy character data line 3
L0001c4a0       move.b  $0006(a1),$0078(a2)             ; copy character data line 4
L0001c4a6       move.b  $0008(a1),$00a0(a2)             ; copy character data line 5
L0001c4ac       move.b  $000a(a1),$00c8(a2)             ; copy character data line 6
L0001c4b2       move.b  $000c(a1),$00f0(a2)             ; copy character data line 7
L0001c4b8       move.b  $000e(a1),$0118(a2)             ; copy character data line 8
L0001c4be       adda.l  #$00000010,a1                   ; a1 = start next bitplane of char
L0001c4c4       adda.l  bitplane_size,a2                ; L0001ca3e,a2
L0001c4ca       dbf.w   d7,.copy_loop
L0001c4ce       rts



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
L0001c4fe       move.b  (a6)+,d0
L0001c500       move.b  d0,typer_extended_command_1     ; $0001c782
L0001c506       move.b  (a6)+,d0
L0001c508       move.b  d0,typer_extended_command_2     ; $0001c783
                ; falls through to 'wait_or_start_game'


                ;------------ wait or start game ----------
                ; when called directly the value in
                ; 'typer_extended_command_1' holds the
                ; number of frames to wait and display 
                ; the current page of text.
                ; if joystick button is pressed (port 2)
                ; then jumps to start game code.
                ;
wait_or_start_game
L0001c50e       moveq   #$00,d0
L0001c510       bsr.w   raster_wait_161                 ; calls $0001c2f8
L0001c514       bsr.w   L0001c172
L0001c518       btst.b  #$0007,$00bfe001                ; Port 2 Fire Button (Joystick)
L0001c520       beq.b   .firebutton_pressed             ; $0001c52e ; if button pressed
L0001c522       sub.w   #$0001,typer_extended_command_1 ; $0001c782 - decrement fame wait time
L0001c52a       bra.w   resume_text_current_position    ; jmp $0001c352

.firebutton_pressed
                jmp     $0001c05e




L0001c534       movea.l start_coords_ptr,a6                     ; $0001c314 [00000000],a6
L0001c53a       bra.w #$fde8 == $0001c324 (T)



L0001c53e       move.l a6,$0001c77e [00000000]
L0001c544       movea.l #$0001c974,a6
L0001c54a       bra.w   resume_text_current_position            ; jmp $0001c352


L0001c54e       movea.l $0001c77e [00000000],a6
L0001c554       bra.w   resume_text_current_position            ; jmp $0001c352


L0001c558       move.w  x_coord,char_plot_x_coord              ; $0001c45a
L0001c562       move.w  y_coord,char_plot_y_coord              ; $0001c45c
L0001c56c       move.b #$20,d0
L0001c570       bsr.w #$feec == $0001c45e
L0001c574       sub.w #$0001,x_coord                            ; $0001c310
L0001c57c       bra.w   resume_text_current_position            ; jmp $0001c352


                ;-------------------- nop -----------------------
                ; do nothing, just resume text typing
_nop                                                            ; original address $0001c580
L0001c580       bra.w   resume_text_current_position            ; jmp $0001c352

L0001c584       rts







                ;-------------------- WORKING ON ---------------------

L0001c586       lea.l   lowest_high_score,a5                            ; L0001ca28,a5 ; Player Score
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
                beq.w   .exit                           ; if d0 = 0 then not an high score, jmp $0001c760

                ; a4 = text display
                ; a5 = score table
                ; d0 = score index
.is_an_high_score
L0001c5f2       move.l  (a5),$0004(a5)
L0001c5f6       move.l  PANEL_HIGHSCORE,(a5)            ; set high score in score table
L0001c5fc       move.b  #$20,$000a(a4)                  ; insert space at text display index 10 - initial 1
L0001c602       move.b  #$20,$000b(a4)                  ; insert space at text display index 11 - initial 2
L0001c608       move.b  #$20,$000c(a4)                  ; insert space at text display index 12 - initial 3

.add_score_to_table_bcd
.digits_1_and_2
L0001c60e       movem.l d0,-(a7)                        ; save d0 (score entry index)
L0001c612       move.b  $0003(a5),d0                    ; d0 = score byte (BCD)
L0001c616       move.b  d0,d1                           ; d1 = copy score byte (BCD)
L0001c618       and.b   #$0f,d0                         ; d0 = low digit
L0001c61c       add.w   #$0030,d0                       ; d0 = add Ascii base for '0'
L0001c620       lsr.b   #$04,d1                         ; d1 = second score digit
L0001c622       add.w   #$0030,d1                       ; d1 = add Ascii base for '0'
L0001c626       move.b  d0,$0014(a4)                    ; store score digit 1 - least significant
L0001c62a       move.b  d1,$0013(a4)                    ; store score digit 2 - second digit
.digits_3_and_4
L0001c62e       move.b  $0002(a5),d0
L0001c632       move.b  d0,d1
L0001c634       and.b   #$0f,d0
L0001c638       add.w   #$0030,d0
L0001c63c       lsr.b   #$04,d1
L0001c63e       add.w   #$0030,d1
L0001c642       move.b  d0,$0012(a4)
L0001c646       move.b  d1,$0011(a4)
.digits_5_and_6
L0001c64a       move.b  $0001(a5),d0
L0001c64e       move.b  d0,d1
L0001c650       and.b   #$0f,d0
L0001c654       add.w   #$0030,d0
L0001c658       lsr.b   #$04,d1
L0001c65a       add.w   #$0030,d1
L0001c65e       move.b  d0,$0010(a4)
L0001c662       move.b  d1,$000f(a4)

L0001c666       adda.l  #$0000000a,a4                           ; increase text display ptr by 10 chars
L0001c66c       lea.l   score_y_coord_table,a0                  ; L0001c76a,a0
L0001c672       movem.l (a7)+,d0                                ; d0 = restored table entry index
L0001c676       asl.w   #$01,d0                                 ; d0 = d0 * 2 (index to a0 table)
L0001c678       move.w  $00(a0,d0.w),char_plot_y_coord          ; L0001c45c - set y co-ord 
L0001c680       move.w  #$0011,char_plot_x_coord                ; L0001c45a - set x co-ord first char
L0001c688       move.w  #$0003,name_initial_index               ; L0001c776

L0001c690       move.b  #$04,L0001C9FC                          ; L0001c9fc
L0001c698       lea.l   L0001c96e,a6                            ; (a6) = $0c30 - x,y display co-ords
L0001c69e       bsr.w   L0001c324

L0001c6a2       moveq   #$01,d6
L0001c6a4       bsr.w   L0001c710
L0001c6a8       moveq   #$04,d0
L0001c6aa       bsr.w   raster_wait_161                         ; calls $0001c2f8
L0001c6ae       clr.l   L0001c778
L0001c6b4       clr.w   L0001c77c
L0001c6ba       move.w  $00dff00c,d0
L0001c6c0       btst.l  #$0001,d0
L0001c6c4       sne.b   L0001c77a
L0001c6ca       btst.l  #$0008,d0
L0001c6ce       sne.b   L0001c778
L0001c6d4       btst.b  #$0007,$00bfe001
L0001c6dc       beq.w   L0001c71a
L0001c6e0       move.w  L0001c778,d0
L0001c6e6       or.w    L0001c77a,d0
L0001c6ec       beq.b   L0001c6a8
L0001c6ee       tst.w   L0001c778
L0001c6f4       bne.w   L0001c706
L0001c6f8       cmp.w   #$001b,d6
L0001c6fc       beq.w   L0001c6a8
L0001c700       addq.w  #$01,d6
L0001c702       bra.w   L0001c710
L0001c706       cmp.w   #$0001,d6
L0001c70a       beq.w   L0001c6a8
L0001c70e       subq.w  #$01,d6
L0001c710       move.b  d6,d0
L0001c712       bsr.w   L0001c45e
L0001c716       bra.w   L0001c6a8
L0001c71a       btst.b  #$0007,$00bfe001
L0001c722       beq.w   L0001c71a
L0001c726       add.w   char_plot_x_coord                       ; L0001c45a
L0001c72e       move.b  d6,d0
L0001c730       cmp.b   #$1c,d0
L0001c734       bne.w   L0001c73c
L0001c738       move.w  #$ffe0,d0
L0001c73c       add.b   #$40,d0
L0001c740       move.b  d0,(a4)+
L0001c742       sub.w   #$0001,name_initial_index               ; update next name initial index, L0001c776
L0001c74a       beq.w   .end_intial_entry                       ; L0001c758
L0001c74e       move.b  d6,d0
L0001c750       bsr.w   L0001c45e
L0001c754       bra.w   L0001c6a8 (T)

.end_intial_entry                                               ; original address $0001c758
                move.w  #$0060,typer_extended_command_1         ; $0001c782

.exit                                                           ; original address $0001c760
L0001c760       lea.l   L0001c784,a6
L0001c766       bra.w   L0001c324


score_y_coord_table                                             ; original address $0001C76A
L0001C76A       dc.w $0058, $0060, $0050, $0040, $0030, $0020
name_initial_index                                              ; original address $0001C776
L0001C776       dc.w $0000
L0001C778       dc.w $0000 


L0001C77A dc.w $0000, $0000, $0000, $0000

typer_extended_command_1                                        ; original address $0001C782
                dc.b $00
typer_extended_command_2                                        ; original address $0001C783
                dc.b $00 


L0001c784 dc.w $0101, $010D, $0D0D                                              ;................
L0001C78A dc.w $0D0D, $0D20, $2020, $2020, $204F, $4345, $414E, $2053           ;...      OCEAN S
L0001C79A dc.w $4F46, $5457, $4152, $450D, $0D20, $2020, $2020, $2020           ;OFTWARE..
L0001C7AA dc.w $2020, $5052, $4553, $454E, $5453, $2020, $200D, $0200           ;  PRESENTS   ...
L0001C7BA dc.w $8001, $060D, $0D0D, $0D0D, $0D20, $2020, $2020, $2020           ;.........
L0001C7CA dc.w $2020, $2042, $4154, $4D41, $4E0D, $0D20, $2020, $2020           ;   BATMAN..
L0001C7DA dc.w $2020, $2054, $4845, $204D, $4F56, $4945, $2E02, $0080           ;   THE MOVIE....
L0001C7EA dc.w $010D, $0D20, $2020, $544D, $2026, $2040, $2044, $4320           ;...   TM & @ DC
L0001C7FA dc.w $434F, $4D49, $4353, $2049, $4E43, $2E0D, $2020, $2020           ;COMICS INC..
L0001C80A dc.w $2020, $2020, $2020, $2031, $3938, $3920, $0D0D, $0D20           ;       1989 ...
L0001C81A dc.w $2020, $4020, $4F43, $4541, $4E20, $534F, $4654, $5741           ;  @ OCEAN SOFTWA
L0001C82A dc.w $5245, $2031, $3938, $390D, $0D0D, $2020, $2020, $2045           ;RE 1989...     E
L0001C83A dc.w $5343, $2E2E, $4142, $4F52, $5420, $4741, $4D45, $0D0D           ;SC..ABORT GAME..
L0001C84A dc.w $2020, $2020, $2020, $4631, $2E2E, $5041, $5553, $4520           ;      F1..PAUSE
L0001C85A dc.w $4741, $4D45, $0D0D, $2020, $2020, $2020, $4632, $2E2E           ;GAME..      F2..
L0001C86A dc.w $544F, $4747, $4C45, $204D, $5553, $4943, $0D02, $0100           ;TOGGLE MUSIC....
L0001C87A dc.w $010D, $2020, $2043, $4F44, $494E, $4720, $4259, $0D20           ;..   CODING BY.
L0001C88A dc.w $2020, $2020, $2020, $2020, $2020, $204D, $494B, $4520           ;           MIKE
L0001C89A dc.w $4C41, $4D42, $0D20, $2020, $2020, $2020, $2020, $2020           ;LAMB.
L0001C8AA dc.w $204A, $4F42, $4245, $4545, $450D, $2020, $2020, $2020           ; JOBBEEEE.
L0001C8BA dc.w $2020, $2020, $2020, $5348, $4F52, $5459, $0D0D, $2020           ;      SHORTY..
L0001C8CA dc.w $2047, $5241, $5048, $4943, $5320, $4259, $0D20, $2020           ; GRAPHICS BY.
L0001C8DA dc.w $2020, $2020, $2020, $2020, $2044, $4157, $4E20, $4452           ;         DAWN DR
L0001C8EA dc.w $414B, $450D, $2020, $2020, $2020, $2020, $2020, $2020           ;AKE.
L0001C8FA dc.w $4249, $4C4C, $2048, $4152, $4249, $534F, $4E0D, $2020           ;BILL HARBISON.
L0001C90A dc.w $2020, $2020, $2020, $2020, $2020, $4A4F, $484E, $2050           ;          JOHN P
L0001C91A dc.w $414C, $4D45, $520D, $0D20, $2020, $4D55, $5349, $4320           ;ALMER..   MUSIC
L0001C92A dc.w $414E, $4420, $4658, $2042, $590D, $2020, $2020, $2020           ;AND FX BY.
L0001C93A dc.w $2020, $2020, $2020, $4A4F, $4E20, $4455, $4E4E, $0D20           ;      JON DUNN.
L0001C94A dc.w $2020, $2020, $2020, $2020, $2020, $204D, $4154, $5448           ;           MATTH
L0001C95A dc.w $4557, $2043, $414E, $4E4F, $4E02, $0100, $0103, $0200           ;EW CANNON.......
L0001C96A dc.w $F001, $00FF                                                     ;....

display_coords
L0001C96E       dc.w $0C30                              ; x, y
display_params
L0001C970       dc.w $010D, $03FF

high_score_display_text
L0001C974       dc.b $20,$20,$20,$20,$20,$20,$20,$20,$20,$48,$49,$20,$53,$43,$4F,$52,$45,$53,$0D,$0D,$0D           ;         HI SCORES
L0001C989       dc.b $20,$20,$20,$20,$20,$31,$53,$54,$20,$20,$41,$4A,$53,$20,$20,$31,$32,$35,$30,$30,$30,$0D,$0D   ;     1ST  AJS  125000
L0001C9A0       dc.b $20,$20,$20,$20,$20,$32,$4E,$44,$20,$20,$4D,$49,$4B,$20,$20,$31,$30,$30,$30,$30,$30,$0D,$0D   ;     2ND  MIK  100000
L0001C9B7       dc.b $20,$20,$20,$20,$20,$33,$52,$44,$20,$20,$4A,$4F,$42,$20,$20,$30,$37,$35,$30,$30,$30,$0D,$0D   ;     3RD  JOB  075000
L0001C9CE       dc.b $20,$20,$20,$20,$20,$34,$54,$48,$20,$20,$42,$49,$4C,$20,$20,$30,$35,$30,$30,$30,$30,$0D,$0D   ;     4TH  BIL  050000
L0001C9E5       dc.b $20,$20,$20,$20,$20,$35,$54,$48,$20,$20,$4A,$4F,$4E,$20,$20,$30,$32,$35,$30,$30,$30,$0D,$0D   ;     5TH  JON  025000
end_highscore_display_text                      ; original address $0001C9FC

high_score_6th_entry                            ; original address $0001C9FC - not displayed, buffer to roll last entry into
L0001C9FC       dc.b $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$0D,$0D

.other_data
L0001CA13       dc.b $04, $00, $00, $00, $00 

highscore_table                                         ; original address $0001CA18
L0001CA18       dc.l $00125000
L0001CA1C       dc.l $00100000
L0001CA20       dc.l $00075000
L0001CA24       dc.l $00050000
lowest_high_score                                       ; original address $0001CA28
L0001CA28       dc.l $00025000
highscore_table_6th_entry                               ; original address $0001CA2c - not displayed, used to roll last entry into
L0001CA2c       dc.l $00000000

.other_data
L0001CA2E       dc.w $0000, $0000


                ; --------------- Copy Title Screen Bitplanes ----------------
copy_title_screen_bitplanes
                lea.l $00040000,a0
                bra.w copy_bitplanes_to_display                 ; calls $0001d3da
                ; uses routine rts to return to caller



bitplane_size                                   ; original address $0001ca3e
L0001ca3e       dc.l $00000000                
L0001ca42       dc.w $0000, $0000                ;or.b #$00,d0

L0001ca46       lea.l $0001cd0e,a0
L0001ca4c       lea.l $0001cd2e,a2
L0001ca52       lea.l $0001cd16,a3
L0001ca58       lea.l $0001cd34,a4
L0001ca5e       lea.l $0001cd3a,a5
L0001ca64       lea.l $0001cd40,a6
L0001ca6a       moveq #$00,d7
L0001ca6c       bsr.w #$0126 == $0001cb94
L0001ca70       move.w #$0fca,d1
L0001ca74       or.w $0001cd8c [0000],d1
L0001ca7a       move.w d1,$00dff040
L0001ca80       move.w $0001cd8c [0000],$00dff042
L0001ca8a       move.l $0001cd86 [00000000],d0
L0001ca90       beq.w #$0100 == $0001cb92 (F)
L0001ca94       move.l $0001cd6e [00000000],$00dff04c
L0001ca9e       move.l $0001cd82 [00000000],$00dff050
L0001caa8       move.l d0,$00dff048
L0001caae       move.l d0,$00dff054
L0001cab4       clr.w $00dff064
L0001caba       clr.w $00dff062
L0001cac0       move.w (a4) [0000],$00dff060
L0001cac6       move.w (a4) [0000],$00dff066
L0001cacc       move.w (a2) [0000],$00dff058
L0001cad2       add.l   bitplane_size,d0                        ;$0001ca3e,d0
L0001cad8       bsr.w #$0968 == $0001d442
L0001cadc       move.l $0001cd72 [00000000],$00dff04c
L0001cae6       move.l $0001cd82 [00000000],$00dff050
L0001caf0       move.l d0,$00dff048
L0001caf6       move.l d0,$00dff054
L0001cafc       move.w (a2) [0000],$00dff058
L0001cb02       add.l   bitplane_size,d0                        ;$0001ca3e,d0
L0001cb08       bsr.w #$0938 == $0001d442
L0001cb0c       move.l $0001cd76 [00000000],$00dff04c
L0001cb16       move.l $0001cd82 [00000000],$00dff050
L0001cb20       move.l d0,$00dff048
L0001cb26       move.l d0,$00dff054
L0001cb2c       move.w (a2) [0000],$00dff058
L0001cb32       add.l   bitplane_size,d0                        ; $0001ca3e,d0
L0001cb38       bsr.w #$0908 == $0001d442
L0001cb3c       move.l $0001cd7a [00000000],$00dff04c
L0001cb46       move.l $0001cd82 [00000000],$00dff050
L0001cb50       move.l d0,$00dff048
L0001cb56       move.l d0,$00dff054
L0001cb5c       move.w (a2) [0000],$00dff058
L0001cb62       add.l   bitplane_size,d0                        ; $0001ca3e,d0
L0001cb68       bsr.w #$08d8 == $0001d442
L0001cb6c       move.l $0001cd7e [00000000],$00dff04c
L0001cb76       move.l $0001cd82 [00000000],$00dff050
L0001cb80       move.l d0,$00dff048
L0001cb86       move.l d0,$00dff054
L0001cb8c       move.w (a2) [0000],$00dff058
L0001cb92       rts  == $000000fe

L0001cb94       moveq #$00,d0
L0001cb96       move.w #$0028,(a4) [0000]
L0001cb9a       movem.l a0,-(a7)
L0001cb9e       move.w (a6) [00c0],d0
L0001cba0       mulu.w #$001c,d0
L0001cba4       lea.l $0001cd44,a0
L0001cbaa       move.l (a0,d0.L,$00) == $00c0473d [7e000900],$0001cd66 [00000000]
L0001cbb2       move.l (a0,d0.L,$04) == $00c04741 [c0485e00],$0001cd6e [00000000]
L0001cbba       move.l (a0,d0.L,$08) == $00c04745 [c0474800],$0001cd72 [00000000]
L0001cbc2       move.l (a0,d0.L,$0c) == $00c04749 [00000000],$0001cd76 [00000000]
L0001cbca       move.l (a0,d0.L,$10) == $00c0474d [c0474405],$0001cd7a [00000000]
L0001cbd2       move.l (a0,d0.L,$14) == $00c04751 [00000000],$0001cd7e [00000000]
L0001cbda       move.l (a0,d0.L,$18) == $00c04755 [010050ff],$0001cd82 [00000000]
L0001cbe2       movem.l (a7)+,a0
L0001cbe6       move.w (a0) [0000],d0
L0001cbe8       move.w d0,d2
L0001cbea       and.w #$000f,d2
L0001cbee       lsr.w #$03,d0
L0001cbf0       move.w (a0,$0004) == $00c04734 [0000],d1
L0001cbf4       add.w #$0100,d1
L0001cbf8       ext.w d0
L0001cbfa       add.w #$0100,d0
L0001cbfe       move.w $0001cd68 [0000],d4
L0001cc04       move.w d1,d3
L0001cc06       cmp.w #$01c7,d3
L0001cc0a       bgt.w #$0016 == $0001cc22 (T)
L0001cc0e       add.w d4,d3
L0001cc10       cmp.w #$01c7,d3
L0001cc14       blt.w #$0014 == $0001cc2a (F)
L0001cc18       sub.w #$01c7,d3
L0001cc1c       sub.w d3,d4
L0001cc1e       beq.b #$02 == $0001cc22 (F)
L0001cc20       bpl.b #$08 == $0001cc2a (T)
L0001cc22       clr.l $0001cd86 [00000000]
L0001cc28       rts  == $000000fe

L0001cc2a       cmp.w #$0100,d1
L0001cc2e       bgt.w #$004a == $0001cc7a (T)
L0001cc32       move.w d1,d3
L0001cc34       add.w d4,d3
L0001cc36       sub.w #$0100,d3
L0001cc3a       bmi.w #$ffe6 == $0001cc22 (F)
L0001cc3e       move.w d3,d4
L0001cc40       beq.w #$ffe0 == $0001cc22 (F)
L0001cc44       sub.w $0001cd68 [0000],d3
L0001cc4a       neg.w d3
L0001cc4c       mulu.w $0001cd66 [0000],d3
L0001cc52       add.l d3,$0001cd6e [00000000]
L0001cc58       add.l d3,$0001cd72 [00000000]
L0001cc5e       add.l d3,$0001cd76 [00000000]
L0001cc64       add.l d3,$0001cd7a [00000000]
L0001cc6a       add.l d3,$0001cd7e [00000000]
L0001cc70       add.l d3,$0001cd82 [00000000]
L0001cc76       move.w #$0100,d1
L0001cc7a       clr.w (a5) [00c0]
L0001cc7c       cmp.w #$0128,d0
L0001cc80       bgt.w #$ffa0 == $0001cc22 (T)
L0001cc84       cmp.w #$0100,d0
L0001cc88       bgt.w #$0012 == $0001cc9c (T)
L0001cc8c       move.w d0,d3
L0001cc8e       sub.w #$0100,d3
L0001cc92       bmi.w #$ff8e == $0001cc22 (F)
L0001cc96       nop
L0001cc98       move.w #$0100,d0
L0001cc9c       move.w d0,d3
L0001cc9e       add.w $0001cd66 [0000],d3
L0001cca4       cmp.w #$0128,d3
L0001cca8       blt.w #$0006 == $0001ccb0 (F)
L0001ccac       bra.w #$ff74 == $0001cc22 (T)
L0001ccb0       move.w $0001cd66 [0000],d6
L0001ccb6       sub.w d6,(a4) [0000]
L0001ccb8       sub.w #$0100,d0
L0001ccbc       sub.w #$0100,d1
L0001ccc0       mulu.w #$0028,d1
L0001ccc4       add.l d1,d0
L0001ccc6       move.l $0001ca42 [00000000],d1
L0001cccc       add.l d0,d1
L0001ccce       move.l d1,$0001cd86 [00000000]
L0001ccd4       asl.w #$08,d2
L0001ccd6       asl.w #$04,d2
L0001ccd8       move.w d2,$0001cd8c [0000]
L0001ccde       move.w $0001cd66 [0000],d5
L0001cce4       mulu.w d4,d5
L0001cce6       move.l d5,$0001cd6a [00000000]
L0001ccec       move.w $0001cd66 [0000],d5
L0001ccf2       lsr.w #$01,d5
L0001ccf4       asl.w #$06,d4
L0001ccf6       or.w d4,d5
L0001ccf8       move.w d5,(a2) [0000]
L0001ccfa       rts  == $000000fe

L0001ccfc       lea.l $0001cd2e,a0
L0001cd02       move.w #$0002,d7
L0001cd06       clr.w (a0)+ [0000]
L0001cd08       dbf .w d7,#$fffc == $0001cd06 (F)
L0001cd0c       rts  == $000000fe


L0001CD0E dc.w $0000, $0018, $0000, $0012, $0000, $0000, $0000, $0000           ;................
L0001CD1E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001CD2E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001CD3E dc.w $0000, $0000, $0000, $000C, $001C, $0005, $0000, $0005           ;................
L0001CD4E dc.w $0150, $0005, $02A0, $0005, $03F0, $0005, $0540, $0001           ;.P...........@..
L0001CD5E dc.w $CD8E, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001CD6E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001CD7E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
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


                ; Called from:
                ;       handle_level_2_interrupt
L0001d2de       move.l  d0,bitplane_size                                ; $0001ca3e
L0001d2e4       move.b  #$f4,$00dff08e
L0001d2ec       moveq   #$01,d0
L0001d2ee       bsr.w   raster_wait_161                                 ; calls $0001c2f8
L0001d2f2       move.w  #$5000,$00dff100
L0001d2fa       move.w  #$0040,$00dff104
L0001d302       move.w  #$0000,$00dff102
L0001d30a       move.l  #DISPLAY_BITPLANE_ADDRESS,$0001ca42             ; #$00063190,$0001ca42 [00000000]
L0001d314       move.w  #$007e,L0001cd0e
L0001d31c       move.w  #$003c,L0001cd12
L0001d324       move.l  #$003800d0,$00dff092
L0001d32e       clr.w   $00dff108
L0001d334       clr.w   $00dff10a
L0001d33a       move.l  #$ffffffff,$00dff044
L0001d344       move.l  #DISPLAY_BITPLANE_ADDRESS,d0                    ; #$00063190,d0
L0001d34a       btst.b  #$0007,L0007c875
L0001d352       beq.b   L0001d372
L0001d354       move.w  #$ffb0,$00dff108
L0001d35c       move.w  #$ffb0,$00dff10a
L0001d364       move.l  bitplane_size,d1                                ; $0001ca3e,d1
L0001d36a       sub.l   #$00000028,d1
L0001d370       add.l   d1,d0
L0001d372       moveq   #$04,d7
L0001d374       lea.l   L0001d6ee,a0
L0001d37a       lea.l   L0001d702,a1
L0001d380       move.w  d0,$0002(a1)
L0001d384       swap.w  d0
L0001d386       move.w  d0,$0002(a0)
L0001d38a       swap.w  d0
L0001d38c       addaq.l #$04,a0
L0001d38e       addaq.l #$04,a1
L0001d390       add.l   bitplane_size,d0                        ; $0001ca3e,d0
L0001d396       dbf.w   d7,L0001d380
L0001d39a       rts

L0001d39c       bra.w   L0001d3b4



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



L0001d3b4       clr.l DISPLAY_BITPLANE_ADDRESS                  ; $00063190 [00000000]
L0001d3ba       lea.l $00020000,a0
L0001d3c0       lea.l $00063194,a1
L0001d3c6       movea.l a0,a2
L0001d3c8       moveq #$04,d1
L0001d3ca       move.w #$1f40,d0
L0001d3ce       move.b (a0)+ [00],(a1)+ [00]
L0001d3d0       dbf .w d0,#$fffc == $0001d3ce (F)
L0001d3d4       dbf .w d1,#$fff4 == $0001d3ca (F)
L0001d3d8       rts  == $000000fe


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


L0001d41c       movem.l d0/a1,-(a7)
L0001d420       lea.l   DISPLAY_BITPLANE_ADDRESS,a1     ; $00063190,a1
L0001d426       move.w #$0724,d0
L0001d42a       movem.l (a0)+,d1-d7
L0001d42e       movem.l d1-d7,(a1)
L0001d432       adda.l #$0000001c,a1
L0001d438       dbf .w d0,#$fff0 == $0001d42a (F)
L0001d43c       movem.l (a7)+,d0/a1
L0001d440       rts  == $000000fe

L0001d442       btst.b #$0006,$00dff002
L0001d44a       bne.w #$fff6 == $0001d442 (T)
L0001d44e       rts  == $000000fe

L0001d450       lea.l   temp_stack_top,a7                               ; set temp stack, $0001d6de,a7
L0001d456       bsr.w   initialise_title_screen                         ; calls $0001c0d8
L0001d45a       btst.b  #$0005,$0007c875 [00]
L0001d462       beq.b   #$0a == $0001d46e (F)
L0001d464       clr.l   $0007c87c [00000000]
L0001d46a       bra.w   #$ebac == $0001c018 (T)
L0001d46e       btst.b  #$0006,$0007c875 [00]
L0001d476       beq.w   #$0074 == $0001d4ec (F)
L0001d47a       move.l  #$00001f40,d0
L0001d480       bsr.w   #$fe5c == $0001d2de
L0001d484       move.w  #$4000,$00dff100
L0001d48c       lea.l   $0001d4cc,a0
L0001d492       bsr.w   copper_copy                                     ; calls $0001d3a0
L0001d496       lea.l   $00056460,a0
L0001d49c       bsr.w   copy_bitplanes_to_display                       ; calls $0001d3da
L0001d4a0       move.b  #$2c,copper_diwstrt                              ; $0001d6e8 [f3]
L0001d4a8       move.b  #$f4,$0001d6ec [f4]
L0001d4b0       move.w  #$0064,d0
L0001d4b4       bsr.w   raster_wait_161                                 ; calls $0001c2f8
L0001d4b8       moveq   #$03,d0
L0001d4ba       jsr     Play_Song                                       ; calls $00004010
L0001d4c0       move.w  #$0600,d0
L0001d4c4       bsr.w   raster_wait_161                                 ; calls $0001c2f8
L0001d4c8       bra.w   #$eb4e == $0001c018 (T)


L0001d4cc dc.w $0000, $0ec2            
L0001d4d0 dc.w $0e80  
L0001d4d2 dc.w $0a40, $0820 
L0001d4d6 dc.w $0e60 
L0001d4d8 dc.w $0ea8 
L0001d4da dc.w $0eca 
L0001d4dc dc.w $0ea0  
L0001d4de dc.w $0eee, $0222, $0444 

L0001d4e0       and.b #$44,-(a2) [00]
L0001d4e4       add.w #$0888,-(a6) [9bc2]
L0001d4e8       eor.l #$0ccc203c,(a2,$0000) == $00000001 [00000000]
L0001d4f0       move.l d0,d4
L0001d4f2       bsr.w #$fdea == $0001d2de
L0001d4f6       lea.l $00049c40,a0
L0001d4fc       bsr.w   copper_copy                                     ; calls $0001d3a0
L0001d500       lea.l $00049c80,a0
L0001d506       bsr.w #$ff14 == $0001d41c
L0001d50a       move.b #$2c,copper_diwstrt                              ; $0001d6e8
L0001d512       move.b #$2b,$0001d6ec [f4]
L0001d51a       move.w #$0014,d0
L0001d51e       bsr.w   raster_wait_161                                 ; calls $0001c2f8
L0001d522       moveq #$02,d0
L0001d524       jsr     Play_Song                                       ; calls $00004010
L0001d52a       move.w #$0200,d0
L0001d52e       bsr.w   raster_wait_161                                 ; calls $0001c2f8
L0001d532       bra.w #$eae4 == $0001c018 (T)
L0001d536       move.w #$0200,d0
L0001d53a       bsr.w   raster_wait_161                                 ; calls $0001c2f8
L0001d53e       bra.w #$ead8 == $0001c018 (T)
L0001d542       move.w d0,$00dff180
L0001d548       addq.w #$01,d0
L0001d54a       bra.w #$fff6 == $0001d542 (T)


L0001D54E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
L0001D55E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
L0001D56E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
L0001D57E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
L0001D58E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
L0001D59E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
L0001D5AE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
L0001D5BE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
L0001D5CE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
L0001D5DE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
L0001D5EE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
L0001D5FE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
L0001D60E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
L0001D61E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
L0001D62E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
L0001D63E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
L0001D64E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
L0001D65E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
L0001D66E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
L0001D67E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
L0001D68E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
L0001D69E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
L0001D6AE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
L0001D6BE dc.w $0000, $0000, $00C7, $8978, $00C7, $8978, $00C7, $848C   
L0001D6CE dc.w $00C7, $871E, $00C7, $8104, $0000, $0000, $0000, $0000   
temp_stack_top                                                          ; original address $0001D6DE

L0001D6DE dc.w $0000
L0001D6E0 dc.w $0000



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
L0001D6EE       dc.w BPL1PTH            ; $00E0
                dc.W $0006
                dc.w BPL2PTH            ; $00E4
                dc.w $0006
                dc.w BPL3PTH            ; $00E8
                dc.w $0006
                dc.w BPL4PTH            ; $00EC
                dc.w $0006
L0001D6FE       dc.w BPL5PTH            ; $00F0
                dc.w $0006
                dc.w BPL1PTL            ; $00E2
                dc.w $3190
                dc.w BPL2PTL            ; $00E6
                dc.w $50D0
                dc.w BPL3PTL            ; $00EA
                dc.w $7010
L0001D70E       dc.w BPL4PTL            ; $00EE
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

title_screen_colors                                                     ; original address $0001D79A       
                dc.w $0000, $0521, $0310, $0731, $0831, $0A41, $0B51, $0D61
                dc.w $0E70, $0F80, $0F90, $0FA0, $0FB0, $0FC0, $0FE0, $0FF0
                dc.w $0045, $0900, $0FFF, $0033, $0067, $0222, $0333, $0444
                dc.w $0F99, $0666, $0706, $0504, $099A, $0403, $0302, $0DDE


  