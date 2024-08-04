                ; This is music and player routine for Level 1 - Axis Chemicals


                ;--------------------- includes and constants ---------------------------
                INCDIR      "include"
                INCLUDE     "hw.i"


                section chem,code_c


TEST_TITLEPRG SET 1             ; run a test build with imported GFX

        IFND TEST_TITLEPRG
                org     $47fe4                                         ; original load address
        ELSE

                ;--------------------------------------------------
                ; TEST PROGRAM
                ;--------------------------------------------------
start
                Add.w   #$1,d0
                move.w  d0,$dff180
                jmp start     

        ENDC    
   

L00047fe4               bra.b L00048000

L00047fe6               dc.w  $0001, $091a                      ; or.b #$1a,d1
L00047fea               dc.w  $0000, $0000                      ; or.b #$00,d0
L00047fee               dc.w  $0000, $0000                      ; or.b #$00,d0
L00047ff2               dc.w  $0000, $0000                      ; or.b #$00,d0
L00047ff6               dc.w  $0000, $0000                      ; or.b #$00,d0
L00047ffa               dc.w  $0000, $0000                      ; or.b #$00,d0
L00047ffe               dc.w  $0000


L00048000               bra.w do_initialise_music_player        ; jmp $00048180
L00048004               bra.w do_silence_all_audio              ; jmp $00048194
L00048008               bra.w do_stop_audio                     ; jmp $000481e8
L0004800c               bra.w do_stop_audio                     ; jmp $000481e8
L00048010               bra.w do_init_song                      ; jmp $0004824e
L00048014               bra.w L0004822c
L00048018               bra.w do_play_song                      ; jmp $0004830e


L0004801c               dc.w  $ffff                             ; illegal
L0004801e               dc.w  $ffff                             ; illegal

channel_dma
L00048020               dc.w  $0000

song_no_1
L00048022               dc.b  $01
song_no_2
L00048023               dc.b  $01   

channel_00_status
L00048024               dc.w  $0000
L00048026               dc.w  $0000
L00048028               dc.w  $0000
                        dc.w  $0000
L0004802c               dc.w  $0000
                        dc.w  $0000
L00048030               dc.w  $0000
                        dc.w  $0000
L00048034               dc.w  $0000
                        dc.w  $0000
L00048038               dc.w  $0000
                        dc.w  $0000
L0004803c               dc.w  $0000
                        dc.w  $0000
L00048040               dc.w  $0000
                        dc.w  $0000
L00048044               dc.w  $0000
                        dc.w  $0000
L00048048               dc.w  $0000
                        dc.w  $0000
L0004804c               dc.w  $0000
                        dc.w  $0000
L00048050               dc.w  $0000
                        dc.w  $0000
L00048054               dc.w  $0000
                        dc.w  $0000
L00048058               dc.w  $0000
                        dc.w  $0000
L0004805c               dc.w  $0000
                        dc.w  $0000
L00048060               dc.w  $0000
                        dc.w  $0000
L00048064               dc.w  $0000
                        dc.w  $0000
L00048068               dc.w  $0000
                        dc.w  $0000
L0004806c               dc.w  $0000
                        dc.w  $0000
L00048070               dc.w  $0000
                        dc.w  $0000
L00048074               dc.w  $0000
                        dc.w  $0000
L00048078               dc.w  $0001                     ; channel bit? 8 (2^0)  

channel_01_status
L0004707a               dc.w  $0000                             
L0004807c               dc.w  $0000
                        dc.w  $0000                      
L00048080               dc.w  $0000
                        dc.w  $0000                      
L00048084               dc.w  $0000
                        dc.w  $0000                      
L00048088               dc.w  $0000
                        dc.w  $0000                      
L0004808c               dc.w  $0000
                        dc.w  $0000                      
L00048090               dc.w  $0000
                        dc.w  $0000                      
L00048094               dc.w  $0000
                        dc.w  $0000                      
L00048098               dc.w  $0000
                        dc.w  $0000                      
L0004809c               dc.w  $0000
                        dc.w  $0000                      
L000480a0               dc.w  $0000
                        dc.w  $0000                      
L000480a4               dc.w  $0000
                        dc.w  $0000                      
L000480a8               dc.w  $0000
                        dc.w  $0000                      
L000480ac               dc.w  $0000
                        dc.w  $0000                      
L000480b0               dc.w  $0000
                        dc.w  $0000                      
L000480b4               dc.w  $0000
                        dc.w  $0000                      
L000480b8               dc.w  $0000
                        dc.w  $0000                      
L000480bc               dc.w  $0000
                        dc.w  $0000                      
L000480c0               dc.w  $0000
                        dc.w  $0000                      
L000480c4               dc.w  $0000
                        dc.w  $0000                      
L000480c8               dc.w  $0000
                        dc.w  $0000                      
L000480cc               dc.w  $0000
                        dc.w  $0002                     ; channel bit? 8 (2^1)                        

channel_02_status
L000480d0               dc.w  $0000
                        dc.w  $0000                      
L000480d4               dc.w  $0000
                        dc.w  $0000                      
L000480d8               dc.w  $0000
                        dc.w  $0000                      
L000480dc               dc.w  $0000
                        dc.w  $0000                      
L000480e0               dc.w  $0000
                        dc.w  $0000                      
L000480e4               dc.w  $0000
                        dc.w  $0000                      
L000480e8               dc.w  $0000
                        dc.w  $0000                      
L000480ec               dc.w  $0000
                        dc.w  $0000                      
L000480f0               dc.w  $0000
                        dc.w  $0000                      
L000480f4               dc.w  $0000
                        dc.w  $0000                      
L000480f8               dc.w  $0000
                        dc.w  $0000                      
L000480fc               dc.w  $0000
                        dc.w  $0000                      
L00048100               dc.w  $0000
                        dc.w  $0000                      
L00048104               dc.w  $0000
                        dc.w  $0000                      
L00048108               dc.w  $0000
                        dc.w  $0000                      
L0004810c               dc.w  $0000
                        dc.w  $0000                      
L00048110               dc.w  $0000
                        dc.w  $0000                      
L00048114               dc.w  $0000
                        dc.w  $0000                      
L00048118               dc.w  $0000
                        dc.w  $0000                      
L0004811c               dc.w  $0000
                        dc.w  $0000                      
L00048120               dc.w  $0000
                        dc.w  $0000                      
L00048124               dc.w  $0004                     ; channel bit? 8 (2^2)  

channel_03_status
L00048126               dc.w  $0000                             
L00048128               dc.w  $0000
                        dc.w  $0000                      
L0004812c               dc.w  $0000
                        dc.w  $0000                      
L00048130               dc.w  $0000
                        dc.w  $0000                      
L00048134               dc.w  $0000
                        dc.w  $0000                      
L00048138               dc.w  $0000
                        dc.w  $0000                      
L0004813c               dc.w  $0000
                        dc.w  $0000                      
L00048140               dc.w  $0000
                        dc.w  $0000                      
L00048144               dc.w  $0000
                        dc.w  $0000                      
L00048148               dc.w  $0000
                        dc.w  $0000                      
L0004814c               dc.w  $0000
                        dc.w  $0000                      
L00048150               dc.w  $0000
                        dc.w  $0000                      
L00048154               dc.w  $0000
                        dc.w  $0000                      
L00048158               dc.w  $0000
                        dc.w  $0000                      
L0004815c               dc.w  $0000
                        dc.w  $0000                      
L00048160               dc.w  $0000
                        dc.w  $0000                      
L00048164               dc.w  $0000
                        dc.w  $0000                      
L00048168               dc.w  $0000
                        dc.w  $0000                      
L0004816c               dc.w  $0000
                        dc.w  $0000                      
L00048170               dc.w  $0000
                        dc.w  $0000                      
L00048174               dc.w  $0000
                        dc.w  $0000                      
L00048178               dc.w  $0000
                        dc.w  $0008                     ; channel bit? 8 (2^3)                     


L0004817c               dc.w  $0000, $0000                      


do_initialise_music_player                                      ; original address $00048180
L00048180               lea.l   L00048d98,a0
L00048186               lea.l   L00048c40,a1
L0004818c               bsr.w   L00048a08
L00048190               bra.w   do_silence_all_audio            ; L00048194

do_silence_all_audio                                            ; original address $00048194
L00048194               movem.l d0/a0-a1,-(a7)
L00048198               move.b  #$00,song_no_1                  ; L00048022
L000481a0               move.b  #$00,song_no_2                  ; L00048023
L000481a8               lea.l   channel_00_status,a0            ; L00048024,a0 
L000481ae               lea.l   $00dff0a8,a1                    ; a1 = AUD0VOL
L000481b4               bsr.b   init_audio_channel              ; L000481ca
L000481b6               bsr.b   init_audio_channel              ; L000481ca
L000481b8               bsr.b   init_audio_channel              ; L000481ca
L000481ba               bsr.b   init_audio_channel              ; L000481ca
L000481bc               move.w  #$0000,channel_dma              ; L00048020 ; channel dma enable bits (all channels)
L000481c4               movem.l (a7)+,d0/a0-a1
L000481c8               rts


                        ; Set Audio Channel Volume to Zero, also init other channel structure values
init_audio_channel                                              ; original address $000481ca
L000481ca               move.w  #$0000,(a0)
L000481ce               move.w  #$0001,$004a(a0)
L000481d4               move.w  #$0000,$004c(a0)
L000481da               move.w  #$0000,(a1)                     ; AUDxVOL
L000481de               adda.w  #$0056,a0                       ; a0 = next audio channel structure
L000481e2               adda.w  #$0010,a1                       ; a1 = next audo channel AUDxVOL h/w/ register
L000481e6               rts

do_stop_audio                                                   ; original address
L000481e8               movem.l d0/d7/a0-a2,-(a7)
L000481ec               subq.w  #$01,d0
L000481ee               bmi.b   L000481f6                       ; d0 <= 0
L000481f0               cmp.w   #$000d,d0                       ; 13
L000481f4               bcs.b   L000481fa                       ; d0 < 13
L000481f6               bsr.b   do_silence_all_audio            ; d0 >= 13 ; jmp $00048194                       
L000481f8               bra.b   L00048226

L000481fa               lea.l   L0005847e,a2
L00048200               asl.w   #$03,d0
L00048202               adda.w  d0,a2
L00048204               lea.l   channel_00_status,a0            ; L00048024,a0
L0004820a               lea.l   $00dff0a8,a1                    ; AUD0VOL
L00048210               moveq   #$03,d7
L00048212               tst.w   (a2)+
L00048214               bne.b   L00048220
L00048216               adda.w  #$0056,a0
L0004821a               adda.w  #$0010,a1
L0004821e               bra.b   L00048222
L00048220               bsr.b   L000481ca
L00048222               dbf.w   d7,L00048212
L00048226               movem.l (a7)+,d0/d7/a0-a2
L0004822a               rts 

L0004822c               tst.w   L00048126
L00048232               beq.b   L0004823c
L00048234               cmp.b   song_no_2,d0                    ; L00048023,d0
L0004823a               bcs.b   L0004824c
L0004823c               movem.l d0/d7/a0-a2,-(a7)
L00048240               move.w  #$4000,d1
L00048244               move.b  d0,song_no_2                    ; L00048023
L0004824a               bra.b   L0004825c
L0004824c               rts  


do_init_song                                                    ; original address $0004824e
L0004824e               movem.l d0/d7/a0-a2,-(a7)
L00048252               move.w  #$8000,d1
L00048256               move.b  d0,song_no_1                    ; L00048022
L0004825c               clr.w   L0004817e
L00048262               subq.w  #$01,d0
L00048264               bmi.b   L0004826c
L00048266               cmp.w   #$000d,d0
L0004826a               bcs.b   L00048274
L0004826c               bsr.w   do_silence_all_audio            ; bsr $00048194
L00048270               bra.w   L00048308
L00048274               lea.l   L0005847e,a0
L0004827a               asl.w   #$03,d0
L0004827c               adda.w  d0,a0
L0004827e               lea.l   channel_00_status,a1            ;L00048024,a1
L00048284               moveq   #$03,d7
L00048286               move.w  (a0)+,d0
L00048288               beq.b   L000482fa
L0004828a               lea.l   -2(a0,d0.W),a2                 ; $fe(a0,d0.W),a2
L0004828e               moveq   #$00,d0
L00048290               move.w  d0,$004c(a1)
L00048294               move.l  d0,$0002(a1)
L00048298               move.l  d0,$000a(a1)
L0004829c               move.b  d0,$0013(a1)
L000482a0               move.b  #$01,$0012(a1)
L000482a6               move.w  d1,(a1)

L000482a8               move.b  (a2)+,d0
L000482aa               bpl.b   L000482de
L000482ac               sub.b   #$80,d0
L000482b0               bne.b   L000482c0
L000482b2               movea.l $0002(a1),a2
L000482b6               cmpa.w  #$0000,a2
L000482ba               bne.b   L000482a8
L000482bc               clr.w   (a1)
L000482be               bra.b   L000482fa
L000482c0               subq.b  #$01,d0
L000482c2               bne.b   L000482ca
L000482c4               move.l  a2,$0002(a1) 
L000482c8               bra.b   L000482a8
L000482ca               subq.b  #$01,d0
L000482cc               bne.b   L000482d4
L000482ce               move.b  (a2)+,$0013(a1)
L000482d2               bra.b   L000482a8
L000482d4               subq.b  #$01,d0
L000482d6               bne.b   L000482a8
L000482d8               move.b  (a2)+,$0012(a1)
L000482dc               bra.b   L000482a8
L000482de               move.l  a2,$0006(a1)
L000482e2               lea.l   L000584e6,a2
L000482e8               ext.w   d0
L000482ea               add.w   d0,d0
L000482ec               adda.w  d0,a2
L000482ee               adda.w  (a2),a2
L000482f0               move.l  a2,$000e(a1)
L000482f4               move.w  #$0001,$0052(a1)
L000482fa               lea.l   $0056(a1),a1                    ; next channel struct (86 bytes)
L000482fe               dbf.w   d7,L00048286

L00048302               or.w    d1,channel_dma                  ; L00048020 ; channel dma enable bits (all channels)
L00048308               movem.l (a7)+,d0/d7/a0-a2
L0004830c               rts 


do_play_song
L0004830e               lea.l   $00dff000,a6
L00048314               lea.l   L00048c00,a5
L0004831a               clr.w   L0004817c
L00048320               tst.w   channel_dma                     ; L00048020 ; channel dma enable bits (all channels)
L00048326               beq.b   L00048384
L00048328               addq.w  #$01,L0004817e
L0004832e               clr.w   channel_dma                     ; L00048020 ; channel dma enable bits (all channels)
L00048334               lea.l   channel_00_status,a4            ; L00048024,a4
L0004833a               move.w  (a4),d7
L0004833c               beq.b   L00048348
L0004833e               bsr.b   L00048392
L00048340               move.w  d7,(a4)
L00048342               or.w    d7,channel_dma                  ; L00048020 ; channel dma enable bits (all channels)
L00048348               lea.l   L0004807a,a4
L0004834e               move.w  (a4),d7
L00048350               beq.b   L$0004835c
L00048352               bsr.b   L$00048392
L00048354               move.w  d7,(a4)
L00048356               or.w    d7,channel_dma                  ; L00048020 ; channel dma enable bits (all channels)
L0004835c               lea.l   L000480d0,a4
L00048362               move.w  (a4),d7
L00048364               beq.b   L00048370
L00048366               bsr.b   L00048392
L00048368               move.w  d7,(a4)
L0004836a               or.w    d7,channel_dma                  ; L00048020 ; channel dma enable bits (all channels)
L00048370               lea.l   L00048126,a4
L00048376               move.w  (a4),d7
L00048378               beq.b   L00048384
L0004837a               bsr.b   L00048392
L0004837c               move.w  d7,(a4)
L0004837e               or.w    d7,channel_dma                  ; L00048020 ; channel dma enable bits (all channels)
L00048384               and.w   #$c000,channel_dma              ; L00048020 ; channel dma enable bits (all channels)
L0004838c               bsr.w   L0004887e
L00048390               rts 


L00048392               subq.w  #$01,$0052(a4)
L00048396               bne.w   L000486de
L0004839a               movea.l $000e(a4),a3
L0004839e               bclr.l  #$0007,d7
cmd_loop
L000483a2               move.b  (a3)+,d0                        ; Music Command Loop
L000483a4               bpl.w   L0004858a
L000483a8               bclr.l  #$0003,d7
L000483ac               cmp.b   #$a0,d0
L000483b0               bcc.b   cmd_loop                        ; do next command - jmp $000483a2
L000483b2               lea.l   cmd_jump_table(pc),a0          
L000483b6               sub.b   #$80,d0
L000483ba               ext.w   d0
L000483bc               add.w   d0,d0
L000483be               adda.w  d0,a0
L000483c0               move.w  (a0),d0
L000483c2               beq.b   cmd_loop                        ; do next command - jmp $000483a2
L000483c4               jmp     $00(a0,d0.W)


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

; L00048408 - CMD 01
music_command_01                                        ; original address $00048408
L00048408               movea.l $000a(a4),a3
L0004840c               cmpa.w  #$0000,a3
L00048410               bne.b   L00483a2
L00048412               movea.l $0006(a4),a3
L00048416               move.b  -$0001(a3),d0
L0004841a               subq.b  #$01,$0012(a4)
L0004841e               bne.b   L0004846e
L00048420               move.b  #$01,$0012(a4)
L00048426               move.b  #$00,$0013(a4)
L0004842c               move.b  (a3)+,d0
L0004842e               bpl.b   L0004846e
L00048430               sub.b   #$80,d0
L00048434               bne.b   L00048450
L00048436               movea.l $0002(a4),a3
L0004843a               cmpa.w  #$0000,a3
L0004843e               bne.b   L0004842c
L00048440               move.w  #$0001,$004a(a4)
L00048446               move.w  #$0000,$004c(a4)
L0004844c               moveq   #$00,d7
L0004844e               rts 

L00048450               subq.b  #$01,d0
L00048452               bne.b   L0004845a
L00048454               move.l  a3,($0002a4)
L00048458               bra.b   L0004842c
L0004845a               subq.b  #$01,d0
L0004845c               bne.b   L00048464
L0004845e               move.b  (a3)+,$0013(a4)
L00048462               bra.b   L0004842c
L00048464               subq.b  #$01,d0
L00048466               bne.b   L0004842c
L00048468               move.b  (a3)+,$0012(a4)
L0004846c               bra.b   L0004842c
L0004846e               move.l  a3,$0006(a4)
L00048472               lea.l   L000584e6,a3
L00048478               ext.w   d0
L0004847a               add.w   d0,d0
L0004847c               adda.w  d0,a3
L0004847e               adda.w  (a3),a3
L00048480               bra.w   cmd_loop                ; do next command - jmp $000483a2

; L00048484 - CMD 02
music_command_02                                        ; original address $00048484
L00048484               move.l  a3,$000a(a4)
L00048488               bra.w   cmd_loop                ; do next command - jmp $000483a2

; L0004848c - CMD 03
music_command_03                                        ; original address $0004848c
L0004848c               bra.w   cmd_loop                ; do next command - jmp $000483a2

; L00048490 - CMD 04
music_command_04                                        ; original address $00048490
L00048490               bra.w   cmd_loop                ; do next command - jmp $000483a2

; L00048494 - CMD 05
music_command_05                                        ; original address $00048494
L00048494               bset.l  #$0005,d7
L00048498               move.b  (a3)+,$0051(a4)
L0004849c               bra.w   cmd_loop                ; do next command - jmp $000483a2

; L000484a0 - CMD 06
music_command_06                                        ; original address $000484a0
L000484a0               bclr.l  #$0005,d7
L000484a4               bra.w   cmd_loop                ; do next command - jmp $000483a2

; L000484a8 - CMD 07
music_command_07                                        ; original address $000484a8
L000484a8               add.w   #$0100,$0052(a4)
L000484ae               bra.w   cmd_loop                ; do next command - jmp $000483a2

; L000484b2 - CMD 08
music_command_08                                        ; original address $000484b2
L000484b2               bclr.l  #$0004,d7
L000484b6               bset.l  #$0007,d7
L000484ba               clr.w   $004c(a4)
L000484be               bra.w   L000486c8

; L000484c2 - CMD 09
music_command_09                                        ; original address $000484c2
L000484c2               bset.l  #$0003,d7
L000484c6               move.b  (a3)+,$0024(a4)
L000484ca               move.b  (a3)+,$0025(a4)
L000484ce               bra.w   cmd_loop                ; do next command - jmp $000483a2

; L000484d2 - CMD 10
music_command_10                                        ; original address $000484d2
L000484d2               and.w   #$fff8,d7
L000484d6               bset.l  #$0000,d7
L000484da               move.b  (a3)+,$0021(a4)
L000484de               move.b  (a3)+,$0022(a4)
L000484e2               bra.w   cmd_loop                ; do next command - jmp $000483a2

; L000484e6 - CMD 11
music_command_11                                        ; original address $000484e6
L000484e6               bclr.l  #$0000,d7
L000484ea               bra.w   cmd_loop                ; do next command - jmp $000483a2

; L000484ee - CMD 14
music_command_14                                        ; original address $000484ee
L000484ee               and.w   #$fff8,d7
L000484f2               bset.l  #$0001,d7
L000484f6               lea.l   L00058378,a0
L000484fc               moveq   #$00,d0
L000484fe               move.b  (a3)+,d0
L00048500               add.w   d0,d0
L00048502               adda.w  d0,a0
L00048504               adda.w  (a0),a0
L00048506               move.b  (a0)+,$0032(a4)
L0004850a               move.b  (a0)+,$0030(a4)
L0004850e               move.l  a0,$0028(a4)
L00048512               bra.w   cmd_loop                ; do next command - jmp $000483a2

; L00048516 - CMD 15
music_command_15                                        ; original address $00048516
L00048516               bclr.l  #$0001,d7
L0004851a               bra.w   cmd_loop                ; do next command - jmp $000483a2

; L0004851e - CMD 12
music_command_12                                        ; original address $0004851e
L0004851e               and.w   #$fff8,d7
L00048522               bset.l  #$0002,d7
L00048526               move.b  (a3)+,$0036(a4)
L0004852a               move.b  (a3)+,$0034(a4)
L0004852e               move.b  (a3)+,$0035(a4)
L00048532               bra.w   cmd_loop                ; do next command - jmp $000483a2

; L00048536 - CMD 13
music_command_13
L00048536               bclr.l  #$0002,d7
L0004853a               bra.w   cmd_loop                ; do next command - jmp $000483a2

; L0004853e - CMD 16
music_command_16                                        ; original address $0004853e
L0004853e               lea.l   L0005842a,a0
L00048544               moveq   #$00,d0
L00048546               move.b  (a3)+,d0
L00048548               add.w   d0,d0
L0004854a               adda.w  d0,a0
L0004854c               adda.w  (a0),a0
L0004854e               move.l  a0,$0014(a4)
L00048552               bra.w   cmd_loop                ; do next command - jmp $000483a2

; L00048556 - CMD 17
music_command_17                                        ; original address $00048556
L00048556               lea.l   L00048c30,a0
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
L0004857e               beq.w   cmd_loop                ; do next command - jmp $000483a2
L00048582               bset.l  #$0006,d7
L00048586               bra.w   cmd_loop                ; do next command - jmp $000483a2





