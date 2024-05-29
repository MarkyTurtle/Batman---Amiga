

                section bootblock,code



                ;--------------------- includes and constants ---------------------------
                INCDIR      "include"
                INCLUDE     "hw.i"
                
                                                                ; original load address $7C7FC-$80000
panel
                dc.l    $0007C800                               ; entry point address



                ;-------------------- panel update -------------------------
                ; This routine is called every frame (50hz) to 
                ; update the game timer.
                ; somehow this gets called more frequently on my 'cracked'
                ; version of the game after completion of level 1
                ; not sure why yet, as it seems to be tied to the level 3
                ; interrupt handlers called for ever vbl.
                ; something else seems to be adding extra calls to this
                ; make make the timer run down slightly quicker.
                ; this makes the batmobile and batwing levels impossible
                ; to complete without losing at least 1 life.
                ;
panel_update                                    ; $0007c800 called every fame by game code level 3 interrupt
                movem.l d0-d7/a0-a2,-(a7)       ; original routine address $0007c800
                bsr.w   do_panel_update         ; calls $0007fc98
                movem.l (a7)+,d0-d7/a0-a2
                rts

L0007c80e       
                movem.l d0-d7/a0-a2,-(a7)       ; original routine address $0007c80e
                bsr.w   L0007fc78
                movem.l (a7)+,d0-d7/a0-a2
                rts  

L0007c81c       
                movem.l d0-d7/a0-a2,-(a7)       ; original routine address $0007c81c
                bsr.w   L0007fb40
                movem.l (a7)+,d0-d7/a0-a2
                rts

L007c82a        
                movem.l d0-d7/a0-a2,-(a7)       ; original routine address $007c82a
                bsr.w   L0007fb7e
                movem.l (a7)+,d0-d7/a0-a2
                rts  

L0007c838       
                movem.l d0-d7/a0-a2,-(a7)       ; original routine address $0007c838 
                bsr.w   L0007f978
                movem.l (a7)+,d0-d7/a0-a2
                rts 

L0007c846       
                movem.l d0-d7/a0-a2,-(a7)       ; original routine address $0007c846
                bsr.w   L0007f95a
                movem.l (a7)+,d0-d7/a0-a2
                rts

L0007c854       
                movem.l d0-d7/a0-a2,-(a7)       ; original routine address $0007c854
                bsr.w   L0007fa00
                movem.l (a7)+,d0-d7/a0-a2
                rts

L0007c862       
                movem.l d0-d7/a0-a2,-(a7)       ; original routine address $0007c862
                bsr.w   L0007fb00
                movem.l (a7)+,d0-d7/a0-a2
                rts

L0007c870       
                bra.w L0007fa66                 ; original routine address $0007c870


                                ;---------------- data -------------------
L0007c874       dc.b    $00                 ; status byte 1 (bits 0-clock timer expired, 1-no lives left, bit 2-life lost)
L0007c875       dc.b    $00                 ; status byte 2 (bits 7 used for test if set - infinite lives?)
L0007c876       dc.w    $0000               ; possible lives counter

L0007c878       dc.w    $0000, $0000
L0007c87c       dc.w    $0000, $0000

frame_tick                                  ; original address $0007c880
L0007c880       dc.w    $0000               ; vbl ticker, ticks every frame from 50 to 0 (1 second at 50hz)



L0007c882       dc.w    $0000               ; BCD value subtracted from clock_timer when frame_tick = 0
clock_timer_update_value                    ; original address $0007c884 (subtract above value using address predecrement i.e. -(a1) )

clock_timer
clock_timer_minutes
L0007c884       dc.b    $00                 ; Clock Timer Minutes value, held in BCD Format
clock_timer_seconds
L0007c885       dc.b    $00                 ; Clock Timer Seconds Value, held in BCD Format 
clock_timer_end

L0007c886       dc.w $0000
L0007c888       dc.w $0000, $ffff
L0007c88c       dc.w $ffff       

player_remaining_energy                     ; original address $0007c88e
L0007c88e       dc.w    $0000               ; counter (count down - possible total energy value ) 

player_hit_damage                           ; original address $0007C890
L0007C890       dc.w    $0000               ; counter (count down, clamped at 0, possible energy hit/damage value)

L0007c892       dc.L    $00000000           ; dest ptr to something
L0007c896       dc.l    $00000000           ; source ptr to something


0007c89a 0000 0000                or.b #$00,d0
0007c89e 0000 0000                or.b #$00,d0
0007c8a2 0000 0000                or.b #$00,d0
0007c8a6 0000 0000                or.b #$00,d0
0007c8aa 0000 0000                or.b #$00,d0
0007c8ae 0000 0000                or.b #$00,d0
0007c8b2 0000 0000                or.b #$00,d0
0007c8b6 0000 0000                or.b #$00,d0
0007c8ba 0000 0000                or.b #$00,d0
0007c8be 0000 0000                or.b #$00,d0
0007c8c2 0e3f                     illegal
0007c8c4 e000                     asr.b #$08,d0
0007c8c6 003f                     illegal
0007c8c8 fc00                     illegal
0007c8ca 7065                     moveq #$65,d0
0007c8cc 12b6 4400                move.b (a6,d4.W[*4],$00) == $00c00276 (68020+) [00],(a1) [00]
0007c8d0 44ad 99ef                neg.l (a5,-$6611) == $00bfaea5
0007c8d4 869b                     or.l (a3)+ [4e756772],d3
0007c8d6 0643 eccd                add.w #$eccd,d3
0007c8da 8762                     or.w d3,-(a2) [1f11]
0007c8dc 4422                     neg.b -(a2) [00]
0007c8de 56c8 60e0                dbne.w d0,#$60e0 == $000829c0 (F)
0007c8e2 03ff                     illegal
0007c8e4 c000                     and.b d0,d0
0007c8e6 007f                     illegal
0007c8e8 fc70                     illegal

0007c8ea 1998 0000                move.b (a0)+ [23],(a4,d0.W,$00) == $00001558 [00]
0007c8ee 0000 0000                or.b #$00,d0
0007c8f2 0021 663c                or.b #$3c,-(a1) [42]
0007c8f6 8f10                     or.b d7,(a0) [23]
0007c8f8 d98f                     addx.l -(a7),-(a4)
0007c8fa a1f0                     illegal
0007c8fc 2de0                     illegal
0007c8fe 0ffc                     illegal
0007c900 1c2f d9fe                move.b (a7,-$2602) == $00bfeeb4,d6
0007c904 e52c                     lsl.b d2,d4
0007c906 c790                     and.l d3,(a0) [236b0126]
0007c908 4000                     negx.b d0
0007c90a 0000 0000                or.b #$00,d0
0007c90e 0000 1998                or.b #$98,d0
0007c912 3e1c                     move.w (a4)+ [0000],d7
0007c914 fbf7                     illegal
0007c916 dff8 def6                adda.l $def6 [00102229],a7
0007c91a 00c4                     illegal
0007c91c 29fc                     illegal
0007c91e 2906                     move.l d6,-(a4) [00000000]
0007c920 8a7f                     illegal
0007c922 1a02                     move.b d2,d5
0007c924 f800 001e                [ illg #$001e ]
0007c926 001e 82c7                or.b #$c7,(a6)+ [00]
0007c92a d1a8 2105                add.l d0,(a0,$2105) == $00feb81b [14202f00]
0007c92e 3f82 3006                move.w d2,(a7,d3.W,$06) == $00c014bc [1e1e]
0007c932 f7b1                     illegal
0007c934 ffbe                     illegal
0007c936 fdf3                     illegal
0007c938 f87c                     illegal
0007c93a 3558 0000                move.w (a0)+ [236b],(a2,$0000) == $00000001 [0000]
0007c93e 0000 0000                or.b #$00,d0
0007c942 0000 0000                or.b #$00,d0
0007c946 0000 0000                or.b #$00,d0
0007c94a 0024 8000                or.b #$00,-(a4) [00]
0007c94e 4002                     negx.b d2
0007c950 7800                     moveq #$00,d4
0007c952 0000 0000                or.b #$00,d0
0007c956 0000 0000                or.b #$00,d0
0007c95a 0000 0000                or.b #$00,d0


0007c95e 0000 1aac                or.b #$ac,d0
0007c962 7218                     moveq #$18,d1
0007c964 0000 0000                or.b #$00,d0
0007c968 0000 0000                or.b #$00,d0
0007c96c 0000 0000                or.b #$00,d0
0007c970 0000 0188                or.b #$88,d0
0007c974 0006 a7c0                or.b #$c0,d6
0007c978 2800                     move.l d0,d4
0007c97a 0000 0000                or.b #$00,d0
0007c97e 0000 0000                or.b #$00,d0
0007c982 0000 0000                or.b #$00,d0
0007c986 0000 184e                or.b #$4e,d0
0007c98a 5818                     addq.b #$04,(a0)+ [23]
0007c98c 0000 0000                or.b #$00,d0
0007c990 0000 0000                or.b #$00,d0
0007c994 0000 0000                or.b #$00,d0
0007c998 0000 0200                or.b #$00,d0
0007c99c 0008                     illegal
0007c99e 203c 0200 0000           move.l #$02000000,d0
0007c9a4 0000 0000                or.b #$00,d0
0007c9a8 0000 0000                or.b #$00,d0
0007c9ac 0000 0000                or.b #$00,d0
0007c9b0 181a                     move.b (a2)+ [00],d4
0007c9b2 2161 52a6                move.l -(a1) [00009942],(a0,$52a6) == $00fee9bc [00feda4e]
0007c9b6 9fdf                     suba.l (a7)+ [00c00276],a7
0007c9b8 e548                     lsl.w #$02,d0
0007c9ba 01cd 8008                movep.l d0,(a5,-$7ff8) == $00bf94be
0007c9be 9153                     sub.w d0,(a3) [4e75]
0007c9c0 ff41                     illegal
0007c9c2 6000 0004                bra.w #$0004 == $0007c9c8 (T)
0007c9c6 48bc                     illegal
0007c9c8 0026 17ff                or.b #$ff,-(a6) [1c]
0007c9cc 1291                     move.b (a1) [00],(a1) [00]
0007c9ce 001b 3801                or.b #$01,(a3)+ [4e]
0007c9d2 2a7f                     illegal
0007c9d4 bf96                     eor.l d7,(a6) [00c01916]
0007c9d6 54a9 4684                addq.l #$02,(a1,$4684) == $00c05b66 [00000000]
0007c9da 5260                     addq.w #$01,-(a0) [4e75]
0007c9dc 0000 0000                or.b #$00,d0
0007c9e0 0000 0000                or.b #$00,d0


0007c9e4 0000 0000                or.b #$00,d0
0007c9e8 0007 e000                or.b #$00,d7
0007c9ec 000e                     illegal
0007c9ee 10fc 003f                move.b #$3f,(a0)+ [23]
0007c9f2 0000 0000                or.b #$00,d0
0007c9f6 0000 0000                or.b #$00,d0
0007c9fa 0000 0000                or.b #$00,d0
0007c9fe 0000 064a                or.b #$4a,d0
0007ca02 6a60                     bpl.b #$60 == $0007ca64 (T)
0007ca04 0000 0000                or.b #$00,d0
0007ca08 0000 0000                or.b #$00,d0
0007ca0c 0000 0000                or.b #$00,d0
0007ca10 0022 0000                or.b #$00,-(a2) [00]
0007ca14 0507                     btst.l d2,d7
0007ca16 38b0 000e                move.w (a0,d0.W,$0e) == $00fe9724 [082b],(a4) [0000]
0007ca1a 2000                     move.l d0,d0
0007ca1c 0000 0000                or.b #$00,d0
0007ca20 0000 0000                or.b #$00,d0
0007ca24 0000 0000                or.b #$00,d0
0007ca28 0656 2662                add.w #$2662,(a6) [00c0]
0007ca2c 3c79 efe7 dc20           movea.w $efe7dc20 [2229],a6
0007ca32 0119                     btst.b d0,(a1)+ [00]
0007ca34 da2e be50                add.b (a6,-$41b0) == $00bfc0c6,d5
0007ca38 ffff                     illegal
0007ca3a c000                     and.b d0,d0
0007ca3c 00f2 3938 001f           [ chk2.b (a2,d0.W,$1f) == $00000020,d3 ]
0007ca3e 3938 001f                move.w $001f [2200],-(a4) [0000]
0007ca42 fff0                     illegal

batman_lives_dest                                                           ; start of batman lives icons display
0007ca44 3bd7                     illegal
0007ca46 fff9                     illegal
0007ca48 8807                     or.b d7,d4
0007ca4a fffe                     illegal
0007ca4c 7f7f                     illegal
0007ca4e ffc4                     illegal
0007ca50 0664 6061                add.w #$6061,-(a4) [0000]
0007ca54 af9f                     illegal
0007ca56 7ff3                     illegal
0007ca58 d0f7 0003                adda.w (a7,d0.W,$03) == $00c014b9 [7600],a0
0007ca5c 4900                     [ chk.l d0,d4 ]
0007ca5e 7c01                     moveq #$01,d6


0007ca60 dfa0                     add.l d7,-(a0) [40044e75]
0007ca62 1800                     move.b d0,d4
0007ca64 0037 8398 00c0           or.b #$98,(a7,d0.W,$c0) == $00c01476 [00]
0007ca6a 2ff8                     illegal
0007ca6c 1cfc 007c                move.b #$7c,(a6)+ [00]
0007ca70 001c 007c                or.b #$7c,(a4)+ [00]
0007ca74 fffc                     illegal
0007ca76 0078 2606 3c60           or.w #$2606,$3c60 [aaaa]
0007ca7c 0000 0049                or.b #$49,d0
0007ca80 ae00                     illegal
0007ca82 0000 0000                or.b #$00,d0
0007ca86 24ee 4000                move.l (a6,$4000) == $00c04276 [00000000],(a2)+ [00000000]
0007ca8a 4000                     negx.b d0
0007ca8c 001d 9818                or.b #$18,(a5)+ [00]
0007ca90 0010 0027                or.b #$27,(a0) [23]
0007ca94 4e70                     reset
0007ca96 0019 3030                or.b #$30,(a1)+ [00]
0007ca9a 001d 7ef0                or.b #$f0,(a5)+ [00]
0007ca9e 001c 863c                or.b #$3c,(a4)+ [00]
0007caa2 5260                     addq.w #$01,-(a0) [4e75]
0007caa4 f992                     illegal
0007caa6 2efb ee00                move.l (pc,a6.L[*8],$00=$0007caa8) == $00c7cd1e (68020+) [00000000],(a7)+ [00c00276]
0007caaa 0000 0000                or.b #$00,d0
0007caae 0046 c1e1                or.w #$c1e1,d6
0007cab2 e000                     asr.b #$08,d0
0007cab4 0001 0118                or.b #$18,d1
0007cab8 003c 3c36                or.b #$3c36,ccr
0007cabc 0c60 000c                cmp.w #$000c,-(a0) [4e75]
0007cac0 e060                     asr.w d0,d0
0007cac2 000f                     illegal
0007cac4 0fe0                     bset.b d7,-(a0) [75]
0007cac6 000d                     illegal
0007cac8 064a                     illegal
0007caca 0660 8141                add.w #$8141,-(a0) [4e75]
0007cace e7be                     rol.l d3,d6
0007cad0 5438 0c38                addq.b #$02,$0c38 [00]
0007cad4 3838 383b                move.w $383b [aaaa],d4
0007cad8 0000 1800                or.b #$00,d0
0007cadc 0000 0828                or.b #$28,d0
0007cae0 00c0                     illegal



0007cae2 000d                     illegal
0007cae4 fbc0                     illegal
0007cae6 0006 60c0                or.b #$c0,d6
0007caea 0006 ffc0                or.b #$c0,d6
0007caee 0007 e660                or.b #$60,d7
0007caf2 2660                     movea.l -(a0) [40044e75],a3
0007caf4 8111                     or.b d0,(a1) [00]
0007caf6 0ccd                     illegal
0007caf8 626c                     bhi.b #$6c == $0007cb66 (F)
0007cafa 1c6c                     illegal
0007cafc 6c60                     bge.b #$60 == $0007cb5e (T)
0007cafe 6c2a                     bge.b #$2a == $0007cb2a (T)
0007cb00 0000 0000                or.b #$00,d0
0007cb04 0000 072c                or.b #$2c,d0
0007cb08 0000 0005                or.b #$05,d0
0007cb0c 0c80 0003 8480           cmp.l #$00038480,d0
0007cb12 0002 8680                or.b #$80,d2
0007cb16 0003 0e64                or.b #$64,d3
0007cb1a 2660                     movea.l -(a0) [40044e75],a3
0007cb1c 8102                     sbcd.b d2,d0
0007cb1e 78c6                     moveq #$c6,d4
0007cb20 de00                     add.b d0,d7
0007cb22 0400 0000                sub.b #$00,d0
0007cb26 0052 ffff                or.w #$ffff,(a2) [0000]
0007cb2a 8000                     or.b d0,d0
0007cb2c 0000 595c                or.b #$5c,d0
0007cb30 000f                     illegal
0007cb32 fff4                     illegal
0007cb34 2880                     move.l d0,(a4) [00000000]
0007cb36 0002 1080                or.b #$80,d2
0007cb3a 0003 9380                or.b #$80,d3
0007cb3e 0002 1e64                or.b #$64,d2
0007cb42 6c64                     bge.b #$64 == $0007cba8 (T)
0007cb44 c002                     and.b d2,d0
0007cb46 040d                     illegal
0007cb48 6404                     bcc.b #$04 == $0007cb4e (T)
0007cb4a 0008                     illegal
0007cb4c 0408                     illegal
0007cb4e 0803 fa1f                btst.l #$fa1f,d3
0007cb52 8000                     or.b d0,d0


0007cb54 1900                     move.b d0,-(a4) [00]
0007cb56 5d2c 000f                subq.b #$06,(a4,$000f) == $00001567 [00]
0007cb5a c2fc 1880                mulu.w #$1880,d1
0007cb5e 0002 0880                or.b #$80,d2
0007cb62 0002 8f80                or.b #$80,d2
0007cb66 0002 8e36                or.b #$36,d2
0007cb6a 0064 8080                or.w #$8080,-(a4) [0000]
0007cb6e 00c1                     illegal
0007cb70 2c6c 0c6c                movea.l (a4,$0c6c) == $000021c4 [aaaaaaaa],a6
0007cb74 0c6c 0c11 c3c8           cmp.w #$0c11,(a4,-$3c38) == $ffffd920 [0010]
0007cb7a 0000 2ec0                or.b #$c0,d0
0007cb7e 2e5c                     movea.l (a4)+ [00000000],a7
0007cb80 0000 9e3a                or.b #$3a,d0
0007cb84 0cc0                     illegal
0007cb86 0007 81c0                or.b #$c0,d7
0007cb8a 0006 87c0                or.b #$c0,d6
0007cb8e 0007 8600                or.b #$00,d7
0007cb92 6260                     bhi.b #$60 == $0007cbf4 (F)
0007cb94 c003                     and.b d3,d0
0007cb96 04c7                     illegal
0007cb98 286c 0c6c                movea.l (a4,$0c6c) == $000021c4 [aaaaaaaa],a4
0007cb9c 0c6c 6c38 078e           cmp.w #$6c38,(a4,$078e) == $00001ce6 [aaaa]
0007cba2 0000 1100                or.b #$00,d0
0007cba6 24ec 0003                move.l (a4,$0003) == $0000155b [00000000],(a2)+ [00000000]
0007cbaa 8f01                     sbcd.b d1,d7
0007cbac ce60                     and.w -(a0) [4e75],d7
0007cbae 000c                     illegal
0007cbb0 a060                     illegal
0007cbb2 000e                     illegal
0007cbb4 ffe0                     illegal
0007cbb6 000e                     illegal
0007cbb8 c646                     and.w d6,d3
0007cbba 6660                     bne.b #$60 == $0007cc1c (F)
0007cbbc c22d ddbd                and.b (a5,-$2243) == $00bff273,d1
0007cbc0 0200 0000                and.b #$00,d0
0007cbc4 0000 003a                or.b #$3a,d0
0007cbc8 0014 0000                or.b #$00,(a4) [00]
0007cbcc 0c40 17dc                cmp.w #$17dc,d0
0007cbd0 0001 4005                or.b #$05,d1
0007cbd4 c070 001a                and.w (a0,d0.W,$1a) == $00fe9730 [6100],d0


0007cbd8 63b0                     bls.b #$b0 == $0007cb8a (T)
0007cbda 001d fdf0                or.b #$f0,(a5)+ [00]
0007cbde 001d 2666                or.b #$66,(a5)+ [00]
0007cbe2 2c64                     movea.l -(a4) [00000000],a6
0007cbe4 84cb                     illegal
0007cbe6 7f5b                     illegal
0007cbe8 4000                     negx.b d0
0007cbea 0000 0000                or.b #$00,d0
0007cbee 0003 7fec                or.b #$ec,d3
0007cbf2 0000 01c0                or.b #$c0,d0
0007cbf6 13fa 0001 bfec 187c      move.b (pc,$0001) == $0007cbf9 [01],$bfec187c
0007cbfe 0079 011c 007f 7fbc      or.w #$011c,$007f7fbc
0007cc06 007b                     illegal
0007cc08 6634                     bne.b #$34 == $0007cc3e (F)
0007cc0a 2a60                     movea.l -(a0) [40044e75],a5
0007cc0c ffff                     illegal
0007cc0e ffff                     illegal
0007cc10 5800                     addq.b #$04,d0
0007cc12 0000 0000                or.b #$00,d0
0007cc16 0003 fa14                or.b #$14,d3
0007cc1a 0000 1e80                or.b #$80,d0
0007cc1e 19f4                     illegal
0007cc20 0001 42fc                or.b #$fc,d1
0007cc24 5267                     addq.w #$01,-(a7) [8646]
0007cc26 ffde                     illegal
0007cc28 1147 ffd7                move.b d7,(a0,-$0029) == $00fe96ed [6e]
0007cc2c ffd7                     illegal
0007cc2e fff0                     illegal
0007cc30 e654                     roxr.w #$03,d4
0007cc32 4461                     neg.w -(a1) [9942]
0007cc34 b659                     cmp.w (a1)+ [00c0],d3
0007cc36 7ffd                     illegal
0007cc38 3804                     move.w d4,d4
0007cc3a 510f                     illegal
0007cc3c 6658                     bne.b #$58 == $0007cc96 (F)
0007cc3e 3e2d c7cc                move.w (a5,-$3834) == $00bfdc82,d7
0007cc42 0000 0100                or.b #$00,d0
0007cc46 0be8 0001                bset.b d5,(a0,$0001) == $00fe9717 [6b]
0007cc4a 9f3b                     illegal
0007cc4c 3800                     move.w d0,d4



0007cc4e 0000 0049                or.b #$49,d0
0007cc52 9cbf                     illegal
0007cc54 fe9a                     illegal
0007cc56 6d83                     blt.b #$83 == $0007cbdb (F)
0007cc58 2622                     move.l -(a2) [1e001f11],d3
0007cc5a 4860                     illegal
0007cc5c bbf7 dfff                cmpa.l (a7,a5.L[*8],$ff) == $0180296b (68020+),a5
0007cc60 b0c0                     cmpa.w d0,a0
0007cc62 08a3 b512                bclr.b #$b512,-(a3) [d0]
0007cc66 3c04                     move.w d4,d6
0007cc68 078c 0000                movep.w d3,(a4,$0000) == $00001558
0007cc6c 0000 0dd4                or.b #$d4,d0
0007cc70 0001 8f06                or.b #$06,d1
0007cc74 1800                     move.b d0,d4
0007cc76 0000 0000                or.b #$00,d0
0007cc7a 8dff                     illegal
0007cc7c fbef                     illegal
0007cc7e dd08                     addx.b -(a0),-(a6)
0007cc80 a612                     illegal
0007cc82 0064 cf36                or.w #$cf36,-(a4) [0000]
0007cc86 fffe                     illegal
0007cc88 af88                     illegal
0007cc8a 3021                     move.w -(a1) [9942],d0
0007cc8c a211                     illegal
0007cc8e 2a7e                     illegal
0007cc90 0014 0000                or.b #$00,(a4) [00]
0007cc94 0400 0e24                sub.b #$24,d0
0007cc98 0001 4003                or.b #$03,d1
0007cc9c 2800                     move.l d0,d4
0007cc9e 003c 3c00                or.b #$3c00,ccr
0007cca2 7400                     moveq #$00,d2
0007cca4 0000 024c                or.b #$4c,d0
0007cca8 e600                     asr.b #$03,d0
0007ccaa 2267                     movea.l -(a7) [00fe8646],a1
0007ccac 9ffe                     illegal
0007ccae ffff                     illegal
0007ccb0 c680                     and.l d0,d3
0007ccb2 211f                     move.l (a7)+ [00c00276],-(a0) [40044e75]
0007ccb4 6e34                     bgt.b #$34 == $0007ccea (F)
0007ccb6 432b 7fe0                [ chk.l (a3,$7fe0) == $00ff06ce,d1 ]



0007ccb8 7fe0                     illegal
0007ccba 0000 0000                or.b #$00,d0
0007ccbe 0644 0000                add.w #$0000,d4
0007ccc2 3fe9                     illegal
0007ccc4 6400 0042                bcc.w #$0042 == $0007cd08 (T)
0007ccc8 4000                     negx.b d0
0007ccca 61fd                     bsr.b #$fd == $0007ccc9
0007cccc b6b4 ab9c                cmp.l (a4,a2.L[*2],$9c) == $000014f5 (68020+) [fe000000],d3
0007ccd0 a644                     illegal
0007ccd2 3465                     movea.w -(a5) [8646],a2
0007ccd4 1fbe                     illegal
0007ccd6 ffff                     illegal
0007ccd8 4be0                     illegal
0007ccda 00aa c629 a87b fa14      or.l #$c629a87b,(a2,-$05ec) == $fffffa15 [384e9526]
0007cce2 0000 0000                or.b #$00,d0
0007cce6 06e4                     illegal
0007cce8 0001 42fd                or.b #$fd,d1
0007ccec 0800 0066                btst.l #$0066,d0
0007ccf0 6000 d118                bra.w #$d118 == $00079e0a (T)
0007ccf4 0010 dbb1                or.b #$b1,(a0) [23]
0007ccf8 862c 7066                or.b (a4,$7066) == $000085be [00],d3
0007ccfc 0000 0049                or.b #$49,d0
0007cd00 e400                     asr.b #$02,d0
0007cd02 0000 0000                or.b #$00,d0
0007cd06 24ed c3c8                move.l (a5,-$3c38) == $00bfd87e,(a2)+ [00000000]
0007cd0a 0001 ffb0                or.b #$b0,d1
0007cd0e 3bcc                     illegal
0007cd10 0000 9e3b                or.b #$3b,d0
0007cd14 2000                     move.l d0,d0
0007cd16 0066 6000                or.w #$6000,-(a6) [231c]
0007cd1a 2500                     move.l d0,-(a2) [1e001f11]
0007cd1c 009c 876a 460e           or.l #$876a460e,(a4)+ [00000000]
0007cd22 2a64                     movea.l -(a4) [00000000],a5
0007cd24 f995                     illegal
0007cd26 36cb                     move.w a3,(a3)+ [4e75]
0007cd28 b000                     cmp.b d0,d0
0007cd2a 0000 0000                or.b #$00,d0
0007cd2e 0044 078c                or.w #$078c,d4
0007cd32 0000 bef9                or.b #$f9,d0
0007cd36 5fc8 0001                dble.w d0,#$0001 == $0007cd39 (T)




0007cd3a 8f02                     sbcd.b d2,d7
0007cd3c 0400 0042                sub.b #$42,d0
0007cd40 4000                     negx.b d0
0007cd42 0d04                     btst.l d6,d4
0007cd44 1008                     illegal
0007cd46 993d                     illegal
0007cd48 4654                     not.w (a4) [0000]
0007cd4a 5462                     addq.w #$02,-(a2) [1f11]
0007cd4c a21a                     illegal
0007cd4e 69de                     bvs.b #$de == $0007cd2e (F)
0007cd50 7a38                     moveq #$38,d5
0007cd52 0c38 3838 382a           cmp.b #$38,$382a [aa]
0007cd58 0014 0000                or.b #$00,(a4) [00]
0007cd5c 1ffd                     illegal
0007cd5e fffc                     illegal
0007cd60 0001 4005                or.b #$05,d1
0007cd64 fc3c                     illegal
0007cd66 3c3c 3c00                move.w #$3c00,d6
0007cd6a 5d81                     subq.l #$06,d1
0007cd6c 9c80                     sub.l d0,d6
0007cd6e 8468 462a                or.w (a0,$462a) == $00fedd40 [30a4],d2
0007cd72 1a66                     illegal
0007cd74 8080                     or.l d0,d0
0007cd76 1041                     illegal
0007cd78 406c 1c6c                negx.w (a4,$1c6c) == $000031c4 [aaaa]
0007cd7c 6c60                     bge.b #$60 == $0007cdde (T)
0007cd7e 6c2b                     bge.b #$2b == $0007cdab (T)
0007cd80 7fff                     illegal
0007cd82 8000                     or.b d0,d0
0007cd84 0fbf                     illegal
0007cd86 7ff8                     illegal
0007cd88 000f                     illegal
0007cd8a ffed                     illegal
0007cd8c 9400                     sub.b d0,d2
0007cd8e 0042 4000                or.w #$4000,d2
0007cd92 010b 1000                movep.w (a3,$1000) == $00fe96ee,d0
0007cd96 9b09                     subx.b -(a1),-(a5)
0007cd98 e658                     ror.w #$03,d0
0007cd9a 1260                     illegal
0007cd9c 8639 8007 ea00           or.b $8007ea00 [00],d3





0007cda2 0400 0000                sub.b #$00,d0
0007cda6 0050 ffff                or.w #$ffff,(a0) [236b]
0007cdaa c000                     and.b d0,d0
0007cdac 0fb1 bff0                bclr.b d7,(a1,a3.L[*8],$f0) == $01be9bc0 (68020+)
0007cdb0 001f fff0                or.b #$f0,(a7)+ [00]
0007cdb4 f000 0066                [ F-LINE (MMU 68030) ]
0007cdb6 0066 6000                or.w #$6000,-(a6) [231c]
0007cdba 5581                     subq.l #$02,d1
0007cdbc 1008                     illegal
0007cdbe 8258                     or.w (a0)+ [236b],d1
0007cdc0 e648                     lsr.w #$03,d0
0007cdc2 4e60                     move.l a0,usp
0007cdc4 c130 9041                and.b d0,(a0,a1.W,$41) == $00feac39 [28]
0007cdc8 5004                     addq.b #$08,d4
0007cdca 0008                     illegal
0007cdcc 0408                     illegal
0007cdce 0801 c000                btst.l #$c000,d1
0007cdd2 1000                     move.b d0,d0
0007cdd4 0fc7                     bset.l d7,d7
0007cdd6 d7b8 0040                add.l d3,$0040 [00fc0834]
0007cdda 0038 7800 0066           or.b #$00,$0066 [0c]
0007cde0 6000 09aa                bra.w #$09aa == $0007d78c (T)
0007cde4 cb6b fcca                and.w d5,(a3,-$0336) == $00fe83b8 [9b37]
0007cde8 4672 1e60                not.w (a2,d1.L[*8],$60) == $000c6223 (68020+)
0007cdec 8929 8007                or.b d4,(a1,-$7ff9) == $00bf94e9
0007cdf0 526c 0c6c                addq.w #$01,(a4,$0c6c) == $000021c4 [aaaa]
0007cdf4 0c6c 0c2e 4000           cmp.w #$0c2e,(a4,$4000) == $00005558 [aaaa]
0007cdfa 4000                     negx.b d0
0007cdfc 07e8 11a0                bset.b d3,(a0,$11a0) == $00fea8b6 [00]
0007ce00 0010 0027                or.b #$27,(a0) [23]
0007ce04 2c00                     move.l d0,d6
0007ce06 0042 4000                or.w #$4000,d2
0007ce0a 491c                     [ chk.l (a4)+,d4 ]
0007ce0c f3b3                     illegal
0007ce0e bbf9 0678 1462           cmpa.l $06781462,a5
0007ce14 c108                     abcd.b -(a0),-(a0)
0007ce16 1001                     move.b d1,d0
0007ce18 706c                     moveq #$6c,d0
0007ce1a 0c6c 0c6c 6c16           cmp.w #$0c6c,(a4,$6c16) == $0000816e [0000]
0007ce20 c1e1                     muls.w -(a1) [9942],d0




0007ce22 e000                     asr.b #$08,d0
0007ce24 01c0                     bset.l d0,d0
0007ce26 4bc0                     illegal
0007ce28 003c 3c36                or.b #$3c36,ccr
0007ce2c 0400 003c                sub.b #$3c,d0
0007ce30 3c00                     move.w d0,d6
0007ce32 0dff                     illegal
0007ce34 ffff                     illegal
0007ce36 fff9                     illegal
0007ce38 e628                     lsr.b d3,d0
0007ce3a 5262                     addq.w #$01,-(a2) [1f11]
0007ce3c cd3b                     illegal
0007ce3e befe                     illegal
0007ce40 7200                     moveq #$00,d1
0007ce42 0000 0000                or.b #$00,d0
0007ce46 0013 0000                or.b #$00,(a3) [4e]
0007ce4a 1800                     move.b d0,d4
0007ce4c 0141                     bchg.l d0,d1
0007ce4e efe0                     illegal
0007ce50 00c0                     illegal
0007ce52 000c                     illegal
0007ce54 6c00 0000                bge.w #$0000 == $0007ce56 (T)
0007ce58 0000 4ee7                or.b #$e7,d0
0007ce5c fdf7                     illegal
0007ce5e efc4 664a                [ bfins d6,d4 {25:10} ]
0007ce60 664a                     bne.b #$4a == $0007ceac (F)
0007ce62 5464                     addq.w #$02,-(a4) [0000]
0007ce64 85fb bfd9                divs.w (pc,a3.L[*8],$d9=$0007ce3f) == $0106552d (68020+) [0000],d2
0007ce68 0200 0000                and.b #$00,d0
0007ce6c 0000 0002                or.b #$02,d0
0007ce70 0000 0000                or.b #$00,d0
0007ce74 0001 ffe0                or.b #$e0,d1
0007ce78 0000 0004                or.b #$04,d0
0007ce7c 3000                     move.w d0,d0
0007ce7e 0000 0000                or.b #$00,d0
0007ce82 40bf                     illegal
0007ce84 feba                     illegal
0007ce86 f7a8                     illegal
0007ce88 662a                     bne.b #$2a == $0007ceb4 (F)
0007ce8a 1860                     illegal




0007ce8c ffff                     illegal
0007ce8e ffff                     illegal
0007ce90 6000 0000                bra.w #$0000 == $0007ce92 (T)
0007ce94 0000 0029                or.b #$29,d0
0007ce98 ffff                     illegal
0007ce9a 8000                     or.b d0,d0
0007ce9c 0000 0f60                or.b #$60,d0
0007cea0 000f                     illegal
0007cea2 fff9                     illegal
0007cea4 2000                     move.l d0,d0
0007cea6 0000 0000                or.b #$00,d0
0007ceaa 06e7                     illegal
0007ceac fe7a                     illegal
0007ceae f386                     illegal
0007ceb0 e618                     ror.b #$03,d0
0007ceb2 2060                     movea.l -(a0) [40044e75],a0
0007ceb4 0000 0000                or.b #$00,d0
0007ceb8 0000 0000                or.b #$00,d0
0007cebc 0000 0000                or.b #$00,d0
0007cec0 0024 0000                or.b #$00,-(a4) [00]
0007cec4 001d bfc0                or.b #$c0,(a5)+ [00]
0007cec8 0004 2000                or.b #$00,d4
0007cecc 0000 0000                or.b #$00,d0
0007ced0 0000 0000                or.b #$00,d0
0007ced4 0000 0000                or.b #$00,d0
0007ced8 0604 2860                add.b #$60,d4
0007cedc 0000 0000                or.b #$00,d0
0007cee0 0000 0000                or.b #$00,d0
0007cee4 0000 0000                or.b #$00,d0
0007cee8 0003 5000                or.b #$00,d3
0007ceec 0019 7f80                or.b #$80,(a1)+ [00]
0007cef0 005b 0000                or.w #$0000,(a3)+ [4e75]
0007cef4 0000 0000                or.b #$00,d0
0007cef8 0000 0000                or.b #$00,d0
0007cefc 0000 0000                or.b #$00,d0
0007cf00 0614 2862                add.b #$62,(a4) [00]
0007cf04 3e7d                     illegal
0007cf06 fffe                     illegal
0007cf08 ff80                     illegal
0007cf0a 0020 9200                or.b #$00,-(a0) [75]




0007cf0e 8413                     or.b (a3) [4e],d2
0007cf10 fd40                     illegal
0007cf12 0d00                     btst.l d6,d0
0007cf14 0001 7f80                or.b #$80,d1
0007cf18 064e                     illegal
0007cf1a 15ff                     illegal
0007cf1c 4200                     clr.b d0
0007cf1e 9208                     illegal
0007cf20 0003 ff7f                or.b #$7f,d3
0007cf24 ffbe                     illegal
0007cf26 7c4a                     moveq #$4a,d6
0007cf28 0614 2838                add.b #$38,(a4) [00]
0007cf2c 0000 0000                or.b #$00,d0
0007cf30 0000 0000                or.b #$00,d0
0007cf34 0000 0000                or.b #$00,d0
0007cf38 0000 00d0                or.b #$d0,d0
0007cf3c 8003                     or.b d3,d0
0007cf3e bb00                     eor.b d5,d0
0007cf40 1c80                     move.b d0,(a6) [00]
0007cf42 0000 0000                or.b #$00,d0
0007cf46 0000 0000                or.b #$00,d0
0007cf4a 0000 0000                or.b #$00,d0
0007cf4e 0000 1c14                or.b #$14,d0
0007cf52 2838 0000                move.l $0000 [00000000],d4
0007cf56 0000 0000                or.b #$00,d0
0007cf5a 0000 0000                or.b #$00,d0
0007cf5e 0000 0000                or.b #$00,d0
0007cf62 002d 0000 c601           or.b #$00,(a5,-$39ff) == $00bfdab7
0007cf68 6800 0000                bvc.w #$0000 == $0007cf6a (T)
0007cf6c 0000 0000                or.b #$00,d0
0007cf70 0000 0000                or.b #$00,d0
0007cf74 0000 0000                or.b #$00,d0
0007cf78 1c14                     move.b (a4) [00],d6
0007cf7a 0818 0000                btst.b #$0000,(a0)+ [23]
0007cf7e 0000 0000                or.b #$00,d0
0007cf82 0000 0000                or.b #$00,d0
0007cf86 0000 0000                or.b #$00,d0
0007cf8a 000a                     illegal
0007cf8c d803                     add.b d3,d4
0007cf8e f036 d000                [ f-line (mmu 68030) ]




0007cf90 d000                     add.b d0,d0
0007cf92 0000 0000                or.b #$00,d0
0007cf96 0000 0000                or.b #$00,d0
0007cf9a 0000 0000                or.b #$00,d0
0007cf9e 0000 1810                or.b #$10,d0
0007cfa2 121c                     move.b (a4)+ [00],d1
0007cfa4 fbf7                     illegal
0007cfa6 dff8 def6                adda.l $def6 [00102229],a7
0007cfaa 00c0                     illegal
0007cfac 53f8 2901                sls.b $2901 [aa] (T)
0007cfb0 fffc                     illegal
0007cfb2 f800 5760                [ illg #$5760 ]
0007cfb4 5760                     subq.w #$03,-(a0) [4e75]
0007cfb6 0fdd                     bset.b d7,(a5)+ [00]
0007cfb8 00f9 f3ec 20a7 f046      [ cmp2.b $20a7f046,a7 ]
0007cfba f3ec                     illegal
0007cfbc 20a7                     move.l -(a7) [00fe8646],(a0) [236b0126]
0007cfbe f046                     illegal
0007cfc0 00de                     illegal
0007cfc2 7b1f                     illegal
0007cfc4 fbef                     illegal
0007cfc6 df38 f848                add.b d7,$f848 [23]
0007cfca 101b                     move.b (a3)+ [4e],d0
0007cfcc d4b0 a7fb                add.l (a0,a2.W[*8],$fb) == $00fe9712 (68020+) [40044e75],d2
0007cfd0 9148                     subx.w -(a0),-(a0)
0007cfd2 0022 cc79                or.b #$79,-(a2) [00]
0007cfd6 0f00                     btst.l d7,d0
0007cfd8 596b 5480                subq.w #$04,(a3,$5480) == $00fedb6e [200b]
0007cfdc 04bd                     illegal
0007cfde dcd8                     adda.w (a0)+ [236b],a6
0007cfe0 0156                     bchg.b d0,(a6) [00]
0007cfe2 bff0 e598                cmpa.l (a0,a6.W[*4],$98) == $00fe9924 (68020+) [00fe9b6e],a7
0007cfe6 f208 0025                [ frem.x fp0 ]
0007cfe8 0025 89df                or.b #$df,-(a5) [46]
0007cfec e50d                     lsl.b #$02,d5
0007cfee 2ad6                     move.l (a6) [00c01916],(a5)+ [00c00276]
0007cff0 d808                     illegal
0007cff2 04bf                     illegal
0007cff4 9478 0800                sub.w $0800 [0000],d2
0007cff8 0020 2062                or.b #$62,-(a0) [75]




0007cffc 256c 8450 07c6           move.l (a4,-$7bb0) == $ffff99a8 [b28267a0],(a2,$07c6) == $000007c7 [00000000]
0007d002 00f8 0005 25c0           [ cmp2.b $25c0,d0 ]
0007d004 0005 25c0                or.b #$c0,d5
0007d008 3803                     move.w d3,d4
0007d00a 0f91                     bclr.b d7,(a1) [00]
0007d00c 444a                     illegal
0007d00e d90c                     addx.b -(a4),-(a4)
0007d010 0808                     illegal
0007d012 0000 0013                or.b #$13,d0
0007d016 3fc4                     illegal
0007d018 7d20                     illegal
0007d01a 0000 0000                or.b #$00,d0
0007d01e 0000 0000                or.b #$00,d0
0007d022 0000 0000                or.b #$00,d0
0007d026 0000 0000                or.b #$00,d0
0007d02a 0000 0000                or.b #$00,d0
0007d02e 0000 0000                or.b #$00,d0
0007d032 0000 0000                or.b #$00,d0
0007d036 0000 0000                or.b #$00,d0
0007d03a 0000 0000                or.b #$00,d0
0007d03e 0000 0000                or.b #$00,d0
0007d042 3830 1fff                move.w (a0,d1.L[*8],$ff) == $010af8d7 (68020+),d4
0007d046 ffc0                     illegal
0007d048 03ff                     illegal
0007d04a 8000                     or.b d0,d0
0007d04c 4941                     illegal
0007d04e 01ff                     illegal
0007d050 1250                     illegal
0007d052 4613                     not.b (a3) [4e]
0007d054 fe00                     illegal
0007d056 f87f                     illegal
0007d058 9310                     sub.b d1,(a0) [23]
0007d05a 1001                     move.b d1,d0
0007d05c 0009                     illegal
0007d05e 2820                     move.l -(a0) [40044e75],d4
0007d060 001f fc00                or.b #$00,(a7)+ [00]
0007d064 3fff                     illegal
0007d066 ff80                     illegal
0007d068 0c1c 77d0                cmp.b #$d0,(a4)+ [00]
0007d06c 0000 0000                or.b #$00,d0


0007d070 0000 0000                or.b #$00,d0
0007d074 b5f0 0004                cmpa.l (a0,d0.W,$04) == $00fe971a [00206100],a2
0007d078 2d7c 097f e1ff ff97      move.l #$097fe1ff,(a6,-$0069) == $00c0020d [fc30124e]
0007d080 fc81                     illegal
0007d082 2600                     move.l d0,d3
0007d084 0216 be00                and.b #$00,(a6) [00]
0007d088 0000 0000                or.b #$00,d0
0007d08c 0000 0000                or.b #$00,d0
0007d090 0bee ee57                bset.b d5,(a6,-$11a9) == $00bff0cd
0007d094 ffff                     illegal
0007d096 fff8                     illegal
0007d098 def6 0003                adda.w (a6,d0.W,$03) == $00c00279 [1600],a7
0007d09c bfff                     illegal
0007d09e 8001                     or.b d1,d0
0007d0a0 6fff                     ble.l #$ff == $0007d0a1 (T)
0007d0a2 e1fe                     illegal
0007d0a4 3fff                     illegal
0007d0a6 fff9                     illegal
0007d0a8 7c3f                     moveq #$3f,d6
0007d0aa ea46                     asr.w #$05,d6
0007d0ac 0e77 fff0 0006           [ moves.w a7,(a7,d0.W,$06) == $00c014bc [1e1e] ]
0007d0ae fff0                     illegal
0007d0b0 0006 f7b1                or.b #$b1,d6
0007d0b4 ffff                     illegal
0007d0b6 ffff                     illegal
0007d0b8 ea77                     roxr.w d5,d7
0007d0ba 9dd7                     suba.l (a7) [00c00276],a6
0007d0bc ffff                     illegal
0007d0be ffff                     illegal
0007d0c0 ffff                     illegal
0007d0c2 ffff                     illegal
0007d0c4 ffff                     illegal
0007d0c6 ffff                     illegal
0007d0c8 ffff                     illegal
0007d0ca ffe0                     illegal
0007d0cc ffe0                     illegal
0007d0ce 0ffe                     illegal
0007d0d0 2fff                     illegal
0007d0d2 ffff                     illegal
0007d0d4 ffff                     illegal


0007d0d6 ffff                     illegal
0007d0d8 ffff                     illegal
0007d0da ffff                     illegal
0007d0dc ffff                     illegal
0007d0de ffff                     illegal
0007d0e0 ebb9                     rol.l d5,d1
0007d0e2 82d0                     divu.w (a0) [236b],d1
0007d0e4 0000 0000                or.b #$00,d0
0007d0e8 0000 0000                or.b #$00,d0
0007d0ec 0000 0000                or.b #$00,d0
0007d0f0 0000 0f8f                or.b #$8f,d0
0007d0f4 f800 053f                [ illg #$053f ]
0007d0f6 053f                     illegal
0007d0f8 e380                     asl.l #$01,d0
0007d0fa 0000 0000                or.b #$00,d0
0007d0fe 0000 0000                or.b #$00,d0
0007d102 0000 0000                or.b #$00,d0
0007d106 0000 0b41                or.b #$41,d0
0007d10a fad0                     illegal
0007d10c 0000 0000                or.b #$00,d0
0007d110 0000 0000                or.b #$00,d0
0007d114 0000 0000                or.b #$00,d0
0007d118 000f                     illegal
0007d11a f4fc                     [ cpusha bc ]
0007d11c 0000 003c                or.b #$3c,d0
0007d120 797f                     illegal
0007d122 0000 0000                or.b #$00,d0
0007d126 0000 0000                or.b #$00,d0
0007d12a 0000 0000                or.b #$00,d0
0007d12e 0000 0b5f                or.b #$5f,d0
0007d132 d55f                     add.w d2,(a7)+ [00c0]
0007d134 ffff                     illegal
0007d136 ffdf                     illegal
0007d138 e400                     asr.b #$02,d0
0007d13a 0000 00c1                or.b #$c1,d0
0007d13e 0013 fff9                or.b #$f9,(a3) [4e]
0007d142 47c0                     illegal
0007d144 0000 4014                or.b #$14,d0
0007d148 1f38 ffff                move.b $ffff [1f],-(a7) [46]
0007d14c 0008                     illegal




0007d14e 3000                     move.w d0,d0
0007d150 0000 027f                or.b #$7f,d0
0007d154 bfff                     illegal
0007d156 ffff                     illegal
0007d158 faab                     illegal
0007d15a a35f                     illegal
0007d15c ffff                     illegal
0007d15e ffff                     illegal
0007d160 ffff                     illegal
0007d162 ffff                     illegal
0007d164 ffff                     illegal
0007d166 ffff                     illegal
0007d168 fffd                     illegal
0007d16a fe00                     illegal
0007d16c 0004 10b4                or.b #$b4,d4
0007d170 03fd                     illegal
0007d172 ffff                     illegal
0007d174 ffff                     illegal
0007d176 ffff                     illegal
0007d178 ffff                     illegal
0007d17a ffff                     illegal
0007d17c ffff                     illegal
0007d17e ffff                     illegal
0007d180 fac5                     illegal
0007d182 af5f                     illegal
0007d184 ffff                     illegal
0007d186 ffff                     illegal
0007d188 ffff                     illegal
0007d18a ffff                     illegal
0007d18c ffff                     illegal
0007d18e ffff                     illegal
0007d190 ffff                     illegal
0007d192 f000 0002                [ F-LINE (MMU 68030) ]
0007d194 0002 20a0                or.b #$a0,d2
0007d198 007f                     illegal
0007d19a ffff                     illegal
0007d19c ffff                     illegal
0007d19e ffff                     illegal
0007d1a0 ffff                     illegal
0007d1a2 ffff                     illegal




0007d1a4 ffff                     illegal
0007d1a6 ffff                     illegal
0007d1a8 faf5                     illegal
0007d1aa b75f                     eor.w d3,(a7)+ [00c0]
0007d1ac ffff                     illegal
0007d1ae ffe7                     illegal
0007d1b0 cc20                     and.b -(a0) [75],d6
0007d1b2 0000 20c0                or.b #$c0,d0
0007d1b6 0000 0000                or.b #$00,d0
0007d1ba 3000                     move.w d0,d0
0007d1bc 0002 3110                or.b #$10,d2
0007d1c0 0060 0000                or.w #$0000,-(a0) [4e75]
0007d1c4 0000 0000                or.b #$00,d0
0007d1c8 0000 003e                or.b #$3e,d0
0007d1cc 7ff8                     illegal
0007d1ce 003f                     illegal
0007d1d0 faed                     illegal
0007d1d2 b75f                     eor.w d3,(a7)+ [00c0]
0007d1d4 ffff                     illegal
0007d1d6 fff3                     illegal
0007d1d8 d006                     add.b d6,d0
0007d1da 0000 3603                or.b #$03,d0
0007d1de 0000 4bff                or.b #$ff,d0
0007d1e2 d800                     add.b d0,d4
0007d1e4 0016 0098                or.b #$98,(a6) [00]
0007d1e8 00df                     illegal
0007d1ea fea0                     illegal
0007d1ec 0000 0000                or.b #$00,d0
0007d1f0 0000 000c                or.b #$0c,d0
0007d1f4 ffe0                     illegal
0007d1f6 000f                     illegal
0007d1f8 faed                     illegal
0007d1fa bf5e                     eor.w d7,(a6)+ [00c0]
0007d1fc ffff                     illegal
0007d1fe ffff                     illegal
0007d200 81ff                     illegal
0007d202 ffff                     illegal
0007d204 ffff                     illegal
0007d206 ffc0                     illegal
0007d208 7200                     moveq #$00,d1



0007d20a 7000                     moveq #$00,d0
0007d20c 0005 0808                or.b #$08,d5
0007d210 0070 0260 0000           or.w #$0260,(a0,d0.W,$00) == $00fe9716 [236b]
0007d216 0000 0000                or.b #$00,d0
0007d21a 0005 7fc0                or.b #$c0,d5
0007d21e 0007 fafd                or.b #$fd,d7
0007d222 f75e                     illegal
0007d224 7ffa                     illegal
0007d226 efff                     illegal
0007d228 c900                     abcd.b d0,d4
0007d22a 0000 0000                or.b #$00,d0
0007d22e 0041 3e1e                or.w #$3e1e,d1
0007d232 3000                     move.w d0,d0
0007d234 0000 0110                or.b #$10,d0
0007d238 0063 c3c8                or.w #$c3c8,-(a3) [4ed0]
0007d23c 0000 0000                or.b #$00,d0
0007d240 0000 0003                or.b #$03,d0
0007d244 0f80                     bclr.l d7,d0
0007d246 0003 faef                or.b #$ef,d3
0007d24a f75e                     illegal
0007d24c 7ff5                     illegal
0007d24e fffe                     illegal
0007d250 d538 0c38                add.b d2,$0c38 [00]
0007d254 3838 3842                move.w $3842 [aaaa],d4
0007d258 ffff                     illegal
0007d25a f800 0000                [ illg #$0000 ]
0007d25c 0000 0000                or.b #$00,d0
0007d260 00ff                     illegal
0007d262 fff4                     illegal
0007d264 0000 0000                or.b #$00,d0
0007d268 0000 0000                or.b #$00,d0
0007d26c ff00                     illegal
0007d26e 0001 faef                or.b #$ef,d1
0007d272 f75e                     illegal
0007d274 7993                     illegal
0007d276 0ccd                     illegal
0007d278 a36c                     illegal
0007d27a 1c6c                     illegal
0007d27c 6c60                     bge.b #$60 == $0007d2de (T)
0007d27e 6c43                     bge.b #$43 == $0007d2c3 (T)



0007d280 ffff                     illegal
0007d282 f000 0000                [ F-LINE (MMU 68030) ]
0007d284 0000 0308                or.b #$08,d0
0007d288 007f                     illegal
0007d28a fffc                     illegal
0007d28c 7100                     illegal
0007d28e 0000 3c00                or.b #$00,d0
0007d292 0000 bf00                or.b #$00,d0
0007d296 0001 aaef                or.b #$ef,d1
0007d29a f75e                     illegal
0007d29c 7992                     illegal
0007d29e 7cce                     moveq #$ce,d6
0007d2a0 d56c 0c6c                add.w d2,(a4,$0c6c) == $000021c4 [aaaa]
0007d2a4 6c60                     bge.b #$60 == $0007d306 (T)
0007d2a6 0c42 0000                cmp.w #$0000,d2
0007d2aa 4000                     negx.b d0
0007d2ac 0000 4708                or.b #$08,d0
0007d2b0 0010 0004                or.b #$04,(a0) [23]
0007d2b4 5300                     subq.b #$01,d0
0007d2b6 0000 2800                or.b #$00,d0
0007d2ba 0001 af00                or.b #$00,d1
0007d2be 0001 aaef                or.b #$ef,d1
0007d2c2 ff5e                     illegal
0007d2c4 7802                     moveq #$02,d4
0007d2c6 640d                     bcc.b #$0d == $0007d2d5 (T)
0007d2c8 a16c                     illegal
0007d2ca 0c38 3c78 1842           cmp.b #$78,$1842 [00]
0007d2d0 9fdf                     suba.l (a7)+ [00c00276],a7
0007d2d2 c000                     and.b d0,d0
0007d2d4 0000 4004                or.b #$04,d0
0007d2d8 001f dfd4                or.b #$d4,(a7)+ [00]
0007d2dc 6100 0000                bsr.w #$0000 == $0007d2de
0007d2e0 3000                     move.w d0,d0
0007d2e2 0000 b700                or.b #$00,d0
0007d2e6 0001 baff                or.b #$ff,d1
0007d2ea f75e                     illegal
0007d2ec 7992                     illegal
0007d2ee 64cb                     bcc.b #$cb == $0007d2bb (T)
0007d2f0 8d00                     sbcd.b d0,d6
0007d2f2 0400 0000                sub.b #$00,d0




0007d2f6 0040 bc6c                or.w #$bc6c,d0
0007d2fa 0000 0200                or.b #$00,d0
0007d2fe 0844 0001                bchg.l #$0001,d4
0007d302 b1d2                     cmpa.l (a2) [00000000],a0
0007d304 0300                     btst.l d1,d0
0007d306 0000 0100                or.b #$00,d0
0007d30a 0000 8700                or.b #$00,d0
0007d30e 0001 82ef                or.b #$ef,d1
0007d312 d75e                     add.w d3,(a6)+ [00c0]
0007d314 7913                     illegal
0007d316 04cf                     illegal
0007d318 a900                     illegal
0007d31a 0000 0000                or.b #$00,d0
0007d31e 0040 07d6                or.w #$07d6,d0
0007d322 0000 0e00                or.b #$00,d0
0007d326 0484 0003 5f00           sub.l #$00035f00,d4
0007d32c 0080 0000 0000           or.l #$00000000,d0
0007d332 0002 ff80                or.b #$80,d2
0007d336 0003 faeb                or.b #$eb,d3
0007d33a d75e                     add.w d3,(a6)+ [00c0]
0007d33c 7efd                     moveq #$fd,d7
0007d33e ffbd                     illegal
0007d340 8300                     sbcd.b d0,d1
0007d342 0000 0000                or.b #$00,d0
0007d346 0042 ffec                or.w #$ffec,d2
0007d34a 0000 0000                or.b #$00,d0
0007d34e 0384                     bclr.l d1,d4
0007d350 0001 bff4                or.b #$f4,d1
0007d354 0180                     bclr.l d0,d0
0007d356 0000 0380                or.b #$80,d0
0007d35a 0005 ffc0                or.b #$c0,d5
0007d35e 0007 faeb                or.b #$eb,d7
0007d362 df5e                     add.w d7,(a6)+ [00c0]
0007d364 7feb                     illegal
0007d366 ff5b                     illegal
0007d368 c100                     abcd.b d0,d0
0007d36a 0000 0000                or.b #$00,d0
0007d36e 0043 7ffc                or.w #$7ffc,d3
0007d372 0000 0080                or.b #$80,d0
0007d376 010a 0001                movep.w (a2,$0001) == $00000002,d0




0007d37a ffec                     illegal
0007d37c 0180                     bclr.l d0,d0
0007d37e 0000 0100                or.b #$00,d0
0007d382 000f                     illegal
0007d384 7fe0                     illegal
0007d386 000f                     illegal
0007d388 fafb                     illegal
0007d38a df5e                     add.w d7,(a6)+ [00c0]
0007d38c 0000 0000                or.b #$00,d0
0007d390 59ff                     illegal
0007d392 ffff                     illegal
0007d394 ffff                     illegal
0007d396 ffc2                     illegal
0007d398 9fdc                     suba.l (a4)+ [00000000],a7
0007d39a 0000 0200                or.b #$00,d0
0007d39e 0884 0001                bclr.l #$0001,d4
0007d3a2 dfd4                     adda.l (a4) [00000000],a7
0007d3a4 0180                     bclr.l d0,d0
0007d3a6 0000 0140                or.b #$40,d0
0007d3aa 0017 fff8                or.b #$f8,(a7) [00]
0007d3ae 003f                     illegal
0007d3b0 fafb                     illegal
0007d3b2 f75f                     illegal
0007d3b4 ffff                     illegal
0007d3b6 fffd                     illegal
0007d3b8 3804                     move.w d4,d4
0007d3ba 5000                     addq.b #$08,d0
0007d3bc 01a4                     bclr.b d0,-(a4) [00]
0007d3be 0004 b86c                or.b #$6c,d4
0007d3c2 0000 0000                or.b #$00,d0
0007d3c6 0808                     illegal
0007d3c8 0001 b0d2                or.b #$d2,d1
0007d3cc 01ff                     illegal
0007d3ce ffff                     illegal
0007d3d0 ffff                     illegal
0007d3d2 9cbf                     illegal
0007d3d4 ffff                     illegal
0007d3d6 ffff                     illegal
0007d3d8 faef                     illegal
0007d3da ff5f                     illegal


0007d3dc ffff                     illegal
0007d3de ffff                     illegal
0007d3e0 b0c0                     cmpa.w d0,a0
0007d3e2 0800 42a0                btst.l #$42a0,d0
0007d3e6 0004 07d4                or.b #$d4,d4
0007d3ea 0000 0000                or.b #$00,d0
0007d3ee 0c10 0001                cmp.b #$01,(a0) [23]
0007d3f2 5f06                     subq.b #$07,d6
0007d3f4 0100                     btst.l d0,d0
0007d3f6 0000 0000                or.b #$00,d0
0007d3fa 8dff                     illegal
0007d3fc ffff                     illegal
0007d3fe ffff                     illegal
0007d400 faff                     illegal
0007d402 f75f                     illegal
0007d404 ffff                     illegal
0007d406 fffe                     illegal
0007d408 af88                     illegal
0007d40a 3000                     move.w d0,d0
0007d40c 108a                     illegal
0007d40e 0006 ffec                or.b #$ec,d6
0007d412 0000 0000                or.b #$00,d0
0007d416 0420 0001                sub.b #$01,-(a0) [75]
0007d41a bff2 013c                cmpa.l (a2,d0.W,$3c) == $0000003d (68020+) [fc083200],a7
0007d41e 3c3c 3c3c                move.w #$3c3c,d6
0007d422 f5ff                     illegal
0007d424 ffff                     illegal
0007d426 ffff                     illegal
0007d428 faef                     illegal
0007d42a d75f                     add.w d3,(a7)+ [00c0]
0007d42c ffff                     illegal
0007d42e ffff                     illegal
0007d430 c680                     and.l d0,d3
0007d432 2000                     move.l d0,d0
0007d434 10c8                     illegal
0007d436 0003 7ffc                or.b #$fc,d3
0007d43a 0000 0000                or.b #$00,d0
0007d43e 0400 0001                sub.b #$01,d0
0007d442 ffe8                     illegal
0007d444 0142                     bchg.l d0,d2




0007d446 4242                     clr.w d2
0007d448 4242                     clr.w d2
0007d44a e0ff                     illegal
0007d44c ffff                     illegal
0007d44e efbf                     rol.l d7,d7
0007d450 faeb                     illegal
0007d452 d75f                     add.w d3,(a7)+ [00c0]
0007d454 ffff                     illegal
0007d456 ffff                     illegal
0007d458 4be0                     illegal
0007d45a 0000 0992                or.b #$92,d0
0007d45e 0002 9fdc                or.b #$dc,d2
0007d462 0000 0000                or.b #$00,d0
0007d466 06c4                     [ rtm d4 ]
0007d468 0001 dfd4                or.b #$d4,d1
0007d46c 0166                     bchg.b d0,-(a6) [1c]
0007d46e 6666                     bne.b #$66 == $0007d4d6 (F)
0007d470 6666                     bne.b #$66 == $0007d4d8 (F)
0007d472 d0ff                     illegal
0007d474 ffff                     illegal
0007d476 fbb7                     illegal
0007d478 faeb                     illegal
0007d47a d75e                     add.w d3,(a6)+ [00c0]
0007d47c ffff                     illegal
0007d47e ffff                     illegal
0007d480 e5ff                     illegal
0007d482 ffff                     illegal
0007d484 ffff                     illegal
0007d486 ffc4                     illegal
0007d488 bc6c 0000                cmp.w (a4,$0000) == $00001558 [0000],d6
0007d48c 0000 0ac4                or.b #$c4,d0
0007d490 0001 b1d2                or.b #$d2,d1
0007d494 0166                     bchg.b d0,-(a6) [1c]
0007d496 6666                     bne.b #$66 == $0007d4fe (F)
0007d498 6666                     bne.b #$66 == $0007d500 (F)
0007d49a a4fe                     illegal
0007d49c 049c 876f faeb           sub.l #$876ffaeb,(a4)+ [00000000]
0007d4a2 df5e                     add.w d7,(a6)+ [00c0]
0007d4a4 7ffd                     illegal
0007d4a6 f7cf                     illegal




0007d4a8 b100                     eor.b d0,d0
0007d4aa 0000 0000                or.b #$00,d0
0007d4ae 0044 07d6                or.w #$07d6,d4
0007d4b2 0000 08e8                or.b #$e8,d0
0007d4b6 0fc0                     bset.l d7,d0
0007d4b8 0003 5f02                or.b #$02,d3
0007d4bc 0142                     bchg.l d0,d2
0007d4be 4242                     clr.w d2
0007d4c0 4242                     clr.w d2
0007d4c2 8cff                     illegal
0007d4c4 9c88                     sub.l a0,d6
0007d4c6 9d3f                     illegal
0007d4c8 fafb                     illegal
0007d4ca f75e                     illegal
0007d4cc 7ffb                     illegal
0007d4ce efde                     illegal
0007d4d0 fb38                     illegal
0007d4d2 0c38 3838 3842           cmp.b #$38,$3842 [aa]
0007d4d8 ffee                     illegal
0007d4da 0000 07f0                or.b #$f0,d0
0007d4de 4fe8 0003                lea.l (a0,$0003) == $00fe9719,a7
0007d4e2 bff4 013c                cmpa.l (a4,d0.W,$3c) == $00001594 (68020+) [00000000],a7
0007d4e6 3c3c 3c3c                move.w #$3c3c,d6
0007d4ea dcff                     illegal
0007d4ec 9c80                     sub.l d0,d6
0007d4ee 866f faef                or.w (a7,-$0511) == $00c00fa5 [0000],d3
0007d4f2 ff5e                     illegal
0007d4f4 618c                     bsr.b #$8c == $0007d482
0007d4f6 30c3                     move.w d3,(a0)+ [236b]
0007d4f8 c16c 1c6c                and.w d0,(a4,$1c6c) == $000031c4 [aaaa]
0007d4fc 6c60                     bge.b #$60 == $0007d55e (T)
0007d4fe 6c43                     bge.b #$43 == $0007d543 (T)
0007d500 7fff                     illegal
0007d502 c000                     and.b d0,d0
0007d504 05b0 47a8                bclr.b d2,(a0,d4.W[*8],$a8) == $00fe96be (68020+) [01]
0007d508 001f ffec                or.b #$ec,(a7)+ [00]
0007d50c 0142                     bchg.l d0,d2
0007d50e 4242                     clr.w d2
0007d510 4242                     clr.w d2
0007d512 80ff                     illegal


0007d514 9c94                     sub.l (a4) [00000000],d6
0007d516 9f9f                     sub.l d7,(a7)+ [00c00276]
0007d518 faff                     illegal
0007d51a f75e                     illegal
0007d51c 4f39 924f eb6c           [ chk.l $924feb6c,d7 ]
0007d51e 924f                     sub.w a7,d1
0007d520 eb6c                     lsl.w d5,d4
0007d522 0c6c 6c60 0c40           cmp.w #$6c60,(a4,$0c40) == $00002198 [aaaa]
0007d528 0000 3000                or.b #$00,d0
0007d52c 01a1                     bclr.b d0,-(a1) [42]
0007d52e 9fb0 0060                sub.l d7,(a0,d0.W,$60) == $00fe9776 [736b2e72]
0007d532 0000 0166                or.b #$66,d0
0007d536 6666                     bne.b #$66 == $0007d59e (F)
0007d538 6666                     bne.b #$66 == $0007d5a0 (F)
0007d53a d4ff                     illegal
0007d53c 949c                     sub.l (a4)+ [00000000],d2
0007d53e 865f                     or.w (a7)+ [00c0],d3
0007d540 faef                     illegal
0007d542 ff5e                     illegal
0007d544 4131 90c3                [ chk.l (a1,a1.W,$c3) == $00c02987,d0 ]
0007d546 90c3                     suba.w d3,a0
0007d548 d16c 0c38                add.w d0,(a4,$0c38) == $00002190 [aaaa]
0007d54c 3c78 1840                movea.w $1840 [0000],a6
0007d550 5fff                     illegal
0007d552 d800                     add.b d0,d4
0007d554 04c0                     illegal
0007d556 0390                     bclr.b d1,(a0) [23]
0007d558 00df                     illegal
0007d55a ffe0                     illegal
0007d55c 0166                     bchg.b d0,-(a6) [1c]
0007d55e 6666                     bne.b #$66 == $0007d5c6 (F)
0007d560 6666                     bne.b #$66 == $0007d5c8 (F)
0007d562 88ff                     illegal
0007d564 dfff                     illegal
0007d566 fccf                     illegal
0007d568 faff                     illegal
0007d56a ff5e                     illegal
0007d56c 7929                     illegal
0007d56e 824f                     illegal
0007d570 d300                     addx.b d0,d1




0007d572 0400 0000                sub.b #$00,d0
0007d576 0040 5900                or.w #$5900,d0
0007d57a 7400                     moveq #$00,d2
0007d57c 0080 1180 0070           or.l #$11800070,d0
0007d582 04e0                     illegal
0007d584 0142                     bchg.l d0,d2
0007d586 4242                     clr.w d2
0007d588 4242                     clr.w d2
0007d58a c8fe                     illegal
0007d58c fbff                     illega
0007d58e fbff                     illegal
0007d590 faff                     illegal
0007d592 f75e                     illegal
0007d594 438c                     illegal
0007d596 1243                     illegal
0007d598 f100                     illegal
0007d59a 0000 0000                or.b #$00,d0
0007d59e 0041 3e1e                or.w #$3e1e,d1
0007d5a2 3400                     move.w d0,d2
0007d5a4 0080 0880 0063           or.l #$08800063,d
0007d5aa c3c8                     illegal
0007d5ac 013c 3c3c                btst.b d0,#$3c
0007d5b0 3c3c 8c00                move.w #$8c00,d6
0007d5b4 0000 0003                or.b #$03,d0
0007d5b8 faef                     illegal
0007d5ba f75e                     illegal
0007d5bc 7fbf                     illegal
0007d5be bffe                     illegal
0007d5c0 f300                     illegal
0007d5c2 0000 0000                or.b #$00,d0
0007d5c6 0042 ffff                or.w #$ffff,d2
0007d5ca f800 0000                [ illg #$0000 ]
0007d5cc 0000 07a0                or.b #$a0,d0
0007d5d0 00ff                     illegal
0007d5d2 fff4                     illegal
0007d5d4 0100                     btst.l d0,d0
0007d5d6 0000 0000                or.b #$00,d0
0007d5da cee7                     mulu.w -(a7) [8646],d7
0007d5dc ffff                     illegal
0007d5de ffff                     illegal


0007d5e0 faef                     illegal
0007d5e2 f75e                     illegal
0007d5e4 7fff                     illegal
0007d5e6 ffd9                     illegal
0007d5e8 8300                     sbcd.b d0,d1
0007d5ea 0000 0000                or.b #$00,d0
0007d5ee 0043 ffff                or.w #$ffff,d3
0007d5f2 f000 0000                [ F-LINE (MMU 68030) ]
0007d5f4 0000 cf20                or.b #$20,d0
0007d5f8 007f                     illegal
0007d5fa fffc                     illegal
0007d5fc 01ff                     illegal
0007d5fe ffff                     illegal
0007d600 ffff                     illegal
0007d602 c0bf                     illegal
0007d604 ffff                     illegal
0007d606 ffff                     illegal
0007d608 faef                     illegal
0007d60a fd5e                     illegal
0007d60c 0000 0000                or.b #$00,d0
0007d610 61ff                     bsr.l #$ff == $0007d611
0007d612 ffff                     illegal
0007d614 ffff                     illegal
0007d616 ffc1                     illegal
0007d618 0000 4000                or.b #$00,d0
0007d61c 0000 0300                or.b #$00,d0
0007d620 0010 0008                or.b #$08,(a0) [23]
0007d624 0000 0000                or.b #$00,d0
0007d628 0000 06e7                or.b #$e7,d0
0007d62c ffff                     illegal
0007d62e ffff                     illegal
0007d630 fabf                     illegal
0007d632 d55f                     add.w d2,(a7)+ [00c0]
0007d634 ffff                     illegal
0007d636 ffff                     illegal
0007d638 ffff                     illegal
0007d63a ffff                     illegal
0007d63c ffff                     illegal
0007d63e ffff                     illegal
0007d640 ffff                     illegal




0007d642 f000 0008                [ F-LINE (MMU 68030) ]
0007d644 0008                     illegal
0007d646 8e00                     or.b d0,d7
0007d648 007d                     illegal
0007d64a ffff                     illegal
0007d64c ffff                     illegal
0007d64e ffff                     illegal
0007d650 ffff                     illegal
0007d652 ffff                     illegal
0007d654 ffff                     illegal
0007d656 ffff                     illegal
0007d658 faab                     illegal
0007d65a dd5f                     add.w d6,(a7)+ [00c0]
0007d65c ffff                     illegal
0007d65e ffff                     illegal
0007d660 ffff                     illegal
0007d662 ffff                     illegal
0007d664 ffff                     illegal
0007d666 ffff                     illegal
0007d668 ffff                     illegal
0007d66a 1c00                     move.b d0,d6
0007d66c 0009                     illegal
0007d66e 1f00                     move.b d0,-(a7) [46]
0007d670 00c3                     illegal
0007d672 ffff                     illegal
0007d674 ffff                     illegal
0007d676 ffff                     illegal
0007d678 ffff                     illegal
0007d67a ffff                     illegal
0007d67c ffff                     illegal
0007d67e ffff                     illegal
0007d680 fabb                     illegal
0007d682 dddf                     adda.l (a7)+ [00c00276],a6
0007d684 ffff                     illegal
0007d686 fffe                     illegal
0007d688 ff80                     illegal
0007d68a 0000 4492                or.b #$92,d0
0007d68e 0013 ffff                or.b #$ff,(a3) [4e]
0007d692 fdf0                     illegal
0007d694 0001 1d00                or.b #$00,d1



0007d698 1e8f                     illegal
0007d69a ffff                     illegal
0007d69c 0092 4400 0003           or.l #$44000003,(a2) [00000000]
0007d6a2 ff7f                     illegal
0007d6a4 ffff                     illegal
0007d6a6 ffff                     illegal
0007d6a8 fbbb                     illegal
0007d6aa fcf0                     illegal
0007d6ac 0000 0000                or.b #$00,d0
0007d6b0 0000 0000                or.b #$00,d0
0007d6b4 0000 0000                or.b #$00,d0
0007d6b8 000f                     illegal
0007d6ba ffdf                     illegal
0007d6bc 8001                     or.b d1,d0
0007d6be 9201                     sub.b d1,d1
0007d6c0 f8ff                     illegal
0007d6c2 8000                     or.b d0,d0
0007d6c4 0000 0000                or.b #$00,d0
0007d6c8 0000 0000                or.b #$00,d0
0007d6cc 0000 0000                or.b #$00,d0
0007d6d0 0f3f                     illegal
0007d6d2 dd70 0000                add.w d6,(a0,d0.W,$00) == $00fe9716 [236b]
0007d6d6 0000 0000                or.b #$00,d0
0007d6da 0000 0000                or.b #$00,d0
0007d6de 0000 0000                or.b #$00,d0
0007d6e2 0ffd                     illegal
0007d6e4 f800 443f                [ illg #$443f ]
0007d6e6 443f                     illegal
0007d6e8 7780                     illegal
0007d6ea 0000 0000                or.b #$00,d0
0007d6ee 0000 0000                or.b #$00,d0
0007d6f2 0000 0000                or.b #$00,d0
0007d6f6 0000 0ebb                or.b #$bb,d0
0007d6fa df77 ffff                add.w d7,(a7,a7.L[*8],$ff) == $0180296b (68020+)
0007d6fe ffff                     illegal
0007d700 ffff                     illegal
0007d702 ffff                     illegal
0007d704 ffff                     illegal
0007d706 ffff                     illegal
0007d708 ffff                     illegal



0007d70a f1ff                     illegal
0007d70c dfe0                     adda.l -(a0) [40044e75],a7
0007d70e 0ff7 9c7f                bset.b d7,(a7,a1.L[*4],$7f) == $01802a17 (68020+)
0007d712 ffff                     illegal
0007d714 ffff                     illegal
0007d716 ffff                     illegal
0007d718 ffff                     illegal
0007d71a ffff                     illegal
0007d71c ffff                     illegal
0007d71e ffff                     illegal
0007d720 eefb                     illegal
0007d722 ff37                     illegal
0007d724 ffff                     illegal
0007d726 fff8                     illegal
0007d728 def6 0007                adda.w (a6,d0.W,$07) == $00c0027d [f009],a7
0007d72c 7fff                     illegal
0007d72e 0001 ffff                or.b #$ff,d1
0007d732 ff3f                     illegal
0007d734 ff7f                     illegal
0007d736 fff1                     illegal
0007d738 ffff                     illegal
0007d73a fffc                     illegal
0007d73c 0eff                     illegal
0007d73e fe00                     illegal
0007d740 00de                     illegal
0007d742 7b1f                     illegal
0007d744 ffff                     illegal
0007d746 ffff                     illegal
0007d748 ecff                     illegal
0007d74a 7ff7                     illegal
0007d74c ffff                     illegal
0007d74e fffb                     illegal
0007d750 9148                     subx.w -(a0),-(a0)
0007d752 0001 6be0                or.b #$e0,d1
0007d756 0000 ffff                or.b #$ff,d0
0007d75a ffe7                     illegal
0007d75c fffd                     illegal
0007d75e dc1f                     add.b (a7)+ [00],d6
0007d760 cfff                     illegal
0007d762 fffc                     illegal




0007d764 02d7 c000                [ cmp2.w (a7),a4 ]
0007d766 c000                     and.b d0,d0
0007d768 0025 89df                or.b #$df,-(a5) [46]
0007d76c ffff                     illegal
0007d76e ffff                     illegal
0007d770 effe                     illegal
0007d772 3cf7 9478                move.w (a7,a1.W[*4],$78) == $00c02a10 (68020+) [a6a6],(a6)+ [00c0]
0007d776 0800 0020                btst.l #$0020,d0
0007d77a 2000                     move.l d0,d0
0007d77c 9282                     sub.l d2,d1
0007d77e 0000 07c6                or.b #$c6,d0
0007d782 00fe                     illegal
0007d784 7fff                     illegal
0007d786 47fc                     illegal
0007d788 f803                     illegal
0007d78a 0f90                     bclr.b d7,(a0) [23]
0007d78c 0125                     btst.b d0,-(a5) [46]
0007d78e 0400 0808                sub.b #$08,d0
0007d792 0000 0013                or.b #$13,d0
0007d796 3fc4                     illegal
0007d798 6f3c                     ble.b #$3c == $0007d7d6 (T)
0007d79a 0000 0000                or.b #$00,d0
0007d79e 0000 0000                or.b #$00,d0
0007d7a2 0000 0000                or.b #$00,d0
0007d7a6 0000 0000                or.b #$00,d0
0007d7aa 0000 0000                or.b #$00,d0
0007d7ae 0000 0000                or.b #$00,d0
0007d7b2 0000 0000                or.b #$00,d0
0007d7b6 0000 0000                or.b #$00,d0
0007d7ba 0000 0000                or.b #$00,d0
0007d7be 0000 0000                or.b #$00,d0
0007d7c2 37bf                     illegal
0007d7c4 ffff                     illegal
0007d7c6 ffff                     illegal
0007d7c8 ffff                     illegal
0007d7ca ffff                     illegal
0007d7cc ffff                     illegal
0007d7ce ffff                     illegal
0007d7d0 ffff                     illegal
0007d7d2 fffc                     illegal



0007d7d4 71ff                     illegal
0007d7d6 ff9c                     illegal
0007d7d8 7fff                     illegal
0007d7da ffff                     illegal
0007d7dc ffff                     illegal
0007d7de ffff                     illegal
0007d7e0 ffff                     illegal
0007d7e2 ffff                     illegal
0007d7e4 ffff                     illegal
0007d7e6 ffff                     illegal
0007d7e8 fdec                     illegal
0007d7ea 4e1f                     illegal
0007d7ec ffff                     illegal
0007d7ee ffff                     illegal
0007d7f0 ffff                     illegal
0007d7f2 ffff                     illegal
0007d7f4 ffff                     illegal
0007d7f6 ffff                     illegal
0007d7f8 ffff                     illegal
0007d7fa fe83                     illegal
0007d7fc 9e00                     sub.b d0,d7
0007d7fe 007b                     illegal
0007d800 83ff                     illegal
0007d802 ffff                     illegal
0007d804 ffff                     illegal
0007d806 ffff                     illegal
0007d808 ffff                     illegal
0007d80a ffff                     illegal
0007d80c ffff                     illegal
0007d80e ffff                     illegal
0007d810 f872                     illegal
0007d812 9d98                     sub.l d6,(a0)+ [236b0126]
0007d814 0000 0007                or.b #$07,d0
0007d818 2109                     move.l a1,-(a0) [40044e75]
0007d81a ffff                     illegal
0007d81c ffff                     illegal
0007d81e ffff                     illegal
0007d820 ffff                     illegal
0007d822 fe3d                     illegal
0007d824 c01f                     and.b (a7)+ [00],d0



0007d826 f007 fbff                [ f-line (mmu 68030) ]
0007d828 fbff                     illegal
0007d82a ffff                     illegal
0007d82c ffff                     illegal
0007d82e ffff                     illegal
0007d830 fff9                     illegal
0007d832 084e                     illegal
0007d834 0000 0000                or.b #$00,d0
0007d838 19b9 ea18 0000 0000      move.b $ea180000,(a4,d0.W,$00) == $00001558 [00]
0007d840 0000 0000                or.b #$00,d0
0007d844 0000 0000                or.b #$00,d0
0007d848 0000 01df                or.b #$df,d0
0007d84c 07e0                     bset.b d3,-(a0) [75]
0007d84e 4fc1                     illegal
0007d850 f400                     illegal
0007d852 0000 0000                or.b #$00,d0
0007d856 0000 0000                or.b #$00,d0
0007d85a 0000 0000                or.b #$00,d0
0007d85e 0000 1857                or.b #$57,d0
0007d862 fd18                     illegal
0007d864 0000 0000                or.b #$00,d0
0007d868 0000 0000                or.b #$00,d0
0007d86c 0000 0000                or.b #$00,d0
0007d870 0000 0e70                or.b #$70,d0
0007d874 f806                     illegal
0007d876 a7fe                     illegal
0007d878 1f80 0000                move.b d0,(a7,d0.W,$00) == $00c014b6 [00]
0007d87c 0000 0000                or.b #$00,d0
0007d880 0000 0000                or.b #$00,d0
0007d884 0000 0000                or.b #$00,d0
0007d888 18bf                     illegal
0007d88a f558                     illegal
0007d88c 0000 0000                or.b #$00,d0
0007d890 0000 0000                or.b #$00,d0
0007d894 0000 0000                or.b #$00,d0
0007d898 000f                     illegal
0007d89a ff3c                     illegal
0007d89c 0008                     illegal
0007d89e 203c 67ff 0000           move.l #$67ff0000,d0
0007d8a4 0000 0000                or.b #$00,d0



0007d8a8 0000 0000                or.b #$00,d0
0007d8ac 0000 0000                or.b #$00,d0
0007d8b0 1aaf fa78                move.b (a7,-$0588) == $00c00f2e [00],(a5) [00]
0007d8b4 0000 0020                or.b #$20,d0
0007d8b8 1bff                     illegal
0007d8ba ffff                     illegal
0007d8bc ffff                     illegal
0007d8be ffec                     illegal
0007d8c0 001e b9c0                or.b #$c0,(a6)+ [00]
0007d8c4 0004 489c                or.b #$9c,d4
0007d8c8 1cff                     illegal
0007d8ca c000                     and.b d0,d0
0007d8cc ffff                     illegal
0007d8ce ffff                     illegal
0007d8d0 ffff                     illegal
0007d8d2 fd80                     illegal
0007d8d4 4000                     negx.b d0
0007d8d6 0000 1e5f                or.b #$5f,d0
0007d8da fc7f                     illegal
0007d8dc ffff                     illegal
0007d8de ffff                     illegal
0007d8e0 ffff                     illegal
0007d8e2 ffff                     illegal
0007d8e4 ffff                     illegal
0007d8e6 ffff                     illegal
0007d8e8 fff2                     illegal
0007d8ea 0e00                     illegal
0007d8ec 000e                     illegal
0007d8ee 10bc 0382                move.b #$82,(a0) [23]
0007d8f2 7fff                     illegal
0007d8f4 ffff                     illegal
0007d8f6 ffff                     illegal
0007d8f8 ffff                     illegal
0007d8fa ffff                     illegal
0007d8fc ffff                     illegal
0007d8fe ffff                     illegal
0007d900 fe3f                     illegal
0007d902 f170                     illegal
0007d904 0000 0000                or.b #$00,d0
0007d908 0000 0000                or.b #$00,d0




0007d90c 0000 0000                or.b #$00,d0
0007d910 0010 f000                or.b #$00,(a0) [23]
0007d914 0507                     btst.l d2,d7
0007d916 28b0 0070                move.l (a0,d0.W,$70) == $00fe9786 [2e726573],(a4) [00000000]
0007d91a 4000                     negx.b d0
0007d91c 0000 0000                or.b #$00,d0
0007d920 0000 0000                or.b #$00,d0
0007d924 0000 0000                or.b #$00,d0
0007d928 0e8f                     illegal
0007d92a e970                     roxl.w d4,d0
0007d92c 0000 0018                or.b #$18,d0
0007d930 33df ffff ffff           move.w (a7)+ [00c0],$ffffffff [1f11]
0007d936 fffe                     illegal
0007d938 ffff                     illegal
0007d93a f000 00f2                [ F-LINE (MMU 68030) ]
0007d93c 00f2 3138 007f           [ cmp2.b (a2,d0.W,$7f) == $00000080,d3 ]
0007d93e 3138 007f                move.w $007f [8600],-(a0) [4e75]
0007d942 fff7                     illegal
0007d944 ffff                     illegal
0007d946 ffff                     illegal
0007d948 ffff                     illegal
0007d94a ffc1                     illegal
0007d94c 8007                     or.b d7,d0
0007d94e ffc0                     illegal
0007d950 0e97 e970                [ moves.l a6,(a7) [00c00276] ]
0007d952 e970                     roxl.w d4,d0
0007d954 0000 000c                or.b #$0c,d0
0007d958 2ff9                     illegal
0007d95a ffff                     illegal
0007d95c ffff                     illegal
0007d95e fffc                     illegal
0007d960 6000 1800                bra.w #$1800 == $0007f162 (T)
0007d964 0036 8398 00c0           or.b #$98,(a6,d0.W,$c0) == $00c00236 [00]
0007d96a 0023 ffff                or.b #$ff,-(a3) [d0]
0007d96e ffff                     illegal
0007d970 ffff                     illegal
0007d972 fff3                     illegal
0007d974 001f fff0                or.b #$f0,(a7)+ [00]
0007d978 0e97 e170                [ moves.l (a7) [00c00276],a6 ]
0007d97a e170                     roxl.w d0,d0



0007d97c ffff                     illegal
0007d97e ffff                     illegal
0007d980 ffff                     illegal
0007d982 ffff                     illegal
0007d984 ffff                     illegal
0007d986 fffd                     illegal
0007d988 ffff                     illegal
0007d98a 8000                     or.b d0,d0
0007d98c 001d 9818                or.b #$18,(a5)+ [00]
0007d990 000f                     illegal
0007d992 fffb                     illegal
0007d994 fffc                     illegal
0007d996 fe7f                     illegal
0007d998 fffc                     illegal
0007d99a fe7a                     illegal
0007d99c 803c fe78                or.b #$78,d0
0007d9a0 0e87                     illegal
0007d9a2 a970                     illegal
0007d9a4 8005                     or.b d5,d0
0007d9a6 1000                     move.b d0,d0
0007d9a8 b700                     eor.b d3,d0
0007d9aa 0000 0000                or.b #$00,d0
0007d9ae 007c ffff                or.w #$ffff,sr
0007d9b2 c000                     and.b d0,d0
0007d9b4 0001 0110                or.b #$10,d1
0007d9b8 001f fff3                or.b #$f3,(a7)+ [00]
0007d9bc fff1                     illegal
0007d9be d71f                     add.b d3,(a7)+ [00]
0007d9c0 fff1                     illegal
0007d9c2 d71c                     add.b d3,(a4)+ [00]
0007d9c4 f071                     illegal
0007d9c6 d71c                     add.b d3,(a4)+ [00]
0007d9c8 0e95 a970                [ moves.l a2,(a5) [00c00276] ]
0007d9ca a970                     illegal
0007d9cc 800a                     illegal
0007d9ce 0001 ab38                or.b #$38,d1
0007d9d2 0c38 3838 387e           cmp.b #$38,$387e [aa]
0007d9d8 0000 1800                or.b #$00,d0
0007d9dc 0000 0820                or.b #$20,d0
0007d9e0 00c0                     illegal




0007d9e2 0007 ffe1                or.b #$e1,d7
0007d9e6 c70f                     abcd.b -(a7),-(a3)
0007d9e8 ffe1                     illegal
0007d9ea c70f                     abcd.b -(a7),-(a3)
0007d9ec 00e1                     illegal
0007d9ee c70e                     abcd.b -(a6),-(a3)
0007d9f0 0e95 a970                [ moves.l a2,(a5) [00c00276] ]
0007d9f2 a970                     illegal
0007d9f4 8000                     or.b d0,d0
0007d9f6 0002 dd6c                or.b #$6c,d2
0007d9fa 1c6c                     illegal
0007d9fc 6c60                     bge.b #$60 == $0007da5e (T)
0007d9fe 6c7d                     bge.b #$7d == $0007da7d (T)
0007da00 ffff                     illegal
0007da02 f000 0000                [ F-LINE (MMU 68030) ]
0007da04 0000 0228                or.b #$28,d0
0007da08 007f                     illegal
0007da0a fffb                     illegal
0007da0c 7fc1                     illegal
0007da0e 8307                     sbcd.b d7,d1
0007da10 bbc1                     cmpa.l d1,a5
0007da12 8307                     sbcd.b d7,d1
0007da14 38c1                     move.w d1,(a4)+ [0000]
0007da16 8306                     sbcd.b d6,d1
0007da18 3695                     move.w (a5) [00c0],(a3) [4e75]
0007da1a a970                     illegal
0007da1c 8000                     or.b d0,d0
0007da1e 0001 ab6c                or.b #$6c,d1
0007da22 0c6c 6c60 0c7c           cmp.w #$6c60,(a4,$0c7c) == $000021d4 [aaaa]
0007da28 ffff                     illegal
0007da2a 8000                     or.b d0,d0
0007da2c 0000 5948                or.b #$48,d0
0007da30 000f                     illegal
0007da32 fff3                     illegal
0007da34 3fc0                     illegal
0007da36 0007 9fc0                or.b #$c0,d7
0007da3a 0006 18c0                or.b #$c0,d6
0007da3e 0006 1695                or.b #$95,d6
0007da42 a170                     illegal
0007da44 8010                     or.b (a0) [23],d0


0007da46 0002 df6c                or.b #$6c,d2
0007da4a 0c38 3c78 187c           cmp.b #$78,$187c [00]
0007da50 801f                     or.b (a7)+ [00],d0
0007da52 c000                     and.b d0,d0
0007da54 1100                     move.b d0,-(a0) [75]
0007da56 4404                     neg.b d4
0007da58 001f c013                or.b #$13,(a7)+ [00]
0007da5c 1fc0                     illegal
0007da5e 0007 8fc0                or.b #$c0,d7
0007da62 0007 08c0                or.b #$c0,d7
0007da66 0006 0685                or.b #$85,d6
0007da6a a970                     illegal
0007da6c 8000                     or.b d0,d0
0007da6e 0004 f36c                or.b #$6c,d4
0007da72 0c6c 0c6c 0c7d           cmp.w #$0c6c,(a4,$0c7d) == $000021d5 [aaaa]
0007da78 ff8a                     illegal
0007da7a 0000 2ec0                or.b #$c0,d0
0007da7e 0844 0002                bchg.l #$0002,d4
0007da82 8ff9 0fe2 008f           divs.w $0fe2008f [0020],d7
0007da88 86e2                     divu.w -(a2) [1f11],d3
0007da8a 008f                     illegal
0007da8c 00e2                     illegal
0007da8e 008e                     illegal
0007da90 0695 a970 8080           add.l #$a9708080,(a5) [00c00276]
0007da96 0000 d76c                or.b #$6c,d0
0007da9a 0c6c 0c6c 6c7c           cmp.w #$0c6c,(a4,$6c7c) == $000081d4 [0000]
0007daa0 f818                     illegal
0007daa2 0000 1b00                or.b #$00,d0
0007daa6 0484 0000 c0f3           sub.l #$0000c0f3,d4
0007daac fff3                     illegal
0007daae 459f                     chk.w (a7)+,d2
0007dab0 fff3                     illegal
0007dab2 459d                     chk.w (a5)+,d2
0007dab4 0073 459c 0e95           or.w #$459c,(a3,d0.L[*8],$95) == $00fe8683 (68020+) [e848]
0007daba a970                     illegal
0007dabc 8102                     sbcd.b d2,d0
0007dabe 0042 fd38                or.w #$fd38,d2
0007dac2 0c38 3838 387c           cmp.b #$38,$387c [aa]
0007dac8 fff0                     illegal
0007daca 0000 0c40                or.b #$40,d0




0007dace 0384                     bclr.l d1,d4
0007dad0 0000 7ff3                or.b #$f3,d0
0007dad4 ffff                     illegal
0007dad6 efff                     illegal
0007dad8 fc7f                     illegal
0007dada effa                     illegal
0007dadc 003f                     illegal
0007dade eff8 0e95 a170           [ bfins d0,$a170 {d2:21} ]
0007dae0 0e95 a170                [ moves.l (a5) [00c00276],a2 ]
0007dae2 a170                     illegal
0007dae4 8014                     or.b (a4) [00],d0
0007dae6 00a4 bf00 0000           or.l #$bf000000,-(a4) [00000000]
0007daec 0000 007c                or.b #$7c,d0
0007daf0 7fe0                     illegal
0007daf2 0000 01c0                or.b #$c0,d0
0007daf6 010a 0000                movep.w (a2,$0000) == $00000001,d0
0007dafa 3fe3                     illegal
0007dafc ffff                     illegal
0007dafe ffff                     illegal
0007db00 feff                     illegal
0007db02 fff0                     illegal
0007db04 801f                     or.b (a7)+ [00],d0
0007db06 fff0                     illegal
0007db08 0e85                     illegal
0007db0a a170                     illegal
0007db0c ffff                     illegal
0007db0e ffff                     illegal
0007db10 27ff                     illegal
0007db12 ffff                     illegal
0007db14 ffff                     illegal
0007db16 fffc                     illegal
0007db18 8010                     or.b (a0) [23],d0
0007db1a 0000 1e80                or.b #$80,d0
0007db1e 1884                     move.b d4,(a4) [00]
0007db20 0000 4013                or.b #$13,d0
0007db24 ffff                     illegal
0007db26 ffff                     illegal
0007db28 febf                     illegal
0007db2a ffe8                     illegal
0007db2c 0007 ffc0                or.b #$c0,d7



0007db30 0e85                     illegal
0007db32 a970                     illegal
0007db34 0000 0002                or.b #$02,d0
0007db38 c7fb afff                muls.w (pc,a2.L[*8],$ff=$0007db39) == $0007db3a (68020+) [afff],d3
0007db3c ffff                     illegal
0007db3e fff9                     illegal
0007db40 ff88                     illegal
0007db42 0000 0100                or.b #$00,d0
0007db46 0808                     illegal
0007db48 0000 8ff9                or.b #$f9,d0
0007db4c fdff                     illegal
0007db4e ffff                     illegal
0007db50 ffff                     illegal
0007db52 e340                     asl.w #$01,d0
0007db54 0000 0000                or.b #$00,d0
0007db58 0e95 a170                [ moves.l (a5) [00c00276],a2 ]
0007db5a a170                     illegal
0007db5c 0000 0000                or.b #$00,d0
0007db60 4f3f                     illegal
0007db62 f7ff                     illegal
0007db64 ffff                     illegal
0007db66 fff8                     illegal
0007db68 f818                     illegal
0007db6a 0000 0000                or.b #$00,d0
0007db6e 0c14 0000                cmp.b #$00,(a4) [00]
0007db72 c0f5 fd00                mulu.w (a5,a7.L[*4],$00) == $0180296c (68020+),d0
0007db76 0000 0000                or.b #$00,d0
0007db7a f200 0000                [ fmove.x fp0 ]
0007db7c 0000 0000                or.b #$00,d0
0007db80 0e85                     illegal
0007db82 a970                     illegal
0007db84 0000 0001                or.b #$01,d0
0007db88 5077 cfff                addq.w #$08,(a7,a4.L[*8],$ff) == $00c02a0d (68020+) [a6a6]
0007db8c ffff                     illegal
0007db8e fff8                     illegal
0007db90 fff0                     illegal
0007db92 0000 0400                or.b #$00,d0
0007db96 0c24 0000                cmp.b #$00,-(a4) [00]
0007db9a 7ff5                     illegal
0007db9c fd00                     illegal



0007db9e 003c 3c00                or.b #$3c00,ccr
0007dba2 89ff                     illegal
0007dba4 ffff                     illegal
0007dba6 fffc                     illegal
0007dba8 0e95 a970                [ moves.l a2,(a5) [00c00276] ]
0007dbaa a970                     illegal
0007dbac 0000 0000                or.b #$00,d0
0007dbb0 397f                     illegal
0007dbb2 dfff                     illegal
0007dbb4 ffff                     illegal
0007dbb6 fffc                     illegal
0007dbb8 7fe0                     illegal
0007dbba 0000 0000                or.b #$00,d0
0007dbbe 0404 0000                sub.b #$00,d4
0007dbc2 3fe7                     illegal
0007dbc4 fd00                     illegal
0007dbc6 0042 4000                or.w #$4000,d2
0007dbca 9d00                     subx.b d0,d6
0007dbcc 0000 1044                or.b #$44,d0
0007dbd0 0e95 a970                [ moves.l a2,(a5) [00c00276] ]
0007dbd2 a970                     illegal
0007dbd4 0000 0000                or.b #$00,d0
0007dbd8 b41f                     cmp.b (a7)+ [00],d2
0007dbda ffff                     illegal
0007dbdc ffff                     illegal
0007dbde fffc                     illegal
0007dbe0 8010                     or.b (a0) [23],d0
0007dbe2 0000 0000                or.b #$00,d0
0007dbe6 06c4                     [ rtm d4 ]
0007dbe8 0000 4013                or.b #$13,d0
0007dbec fd00                     illegal
0007dbee 0066 6000                or.w #$6000,-(a6) [231c]
0007dbf2 ad00                     illegal
0007dbf4 0000 044c                or.b #$4c,d0
0007dbf8 0e95 a970                [ moves.l a2,(a5) [00c00276] ]
0007dbfa a970                     illegal
0007dbfc ffff                     illegal
0007dbfe ffff                     illegal
0007dc00 9bff                     illegal
0007dc02 ffff                     illegal




0007dc04 ffff                     illegal
0007dc06 fff9                     illegal
0007dc08 ff88                     illegal
0007dc0a 0001 ffb0                or.b #$b0,d1
0007dc0e 3acc                     move.w a4,(a5)+ [00c0]
0007dc10 0000 8ff9                or.b #$f9,d0
0007dc14 fd00                     illegal
0007dc16 0066 6000                or.w #$6000,-(a6) [231c]
0007dc1a d900                     addx.b d0,d4
0007dc1c 0000 0094                or.b #$94,d0
0007dc20 0e95 a170                [ moves.l (a5) [00c00276],a2 ]
0007dc22 a170                     illegal
0007dc24 8002                     or.b d2,d0
0007dc26 0830 cf00 0000           btst.b #$cf00,(a0,d0.W,$00) == $00fe9716 [23]
0007dc2c 0000 0078                or.b #$78,d0
0007dc30 f818                     illegal
0007dc32 0000 bef9                or.b #$f9,d0
0007dc36 4fc8                     illegal
0007dc38 0000 c0f1                or.b #$f1,d0
0007dc3c fd00                     illegal
0007dc3e 0042 4000                or.w #$4000,d2
0007dc42 f100                     illegal
0007dc44 0000 02c4                or.b #$c4,d0
0007dc48 0e85                     illegal
0007dc4a a970                     illegal
0007dc4c 8004                     or.b d4,d0
0007dc4e 1021                     move.b -(a1) [42],d0
0007dc50 8538 0c38                or.b d2,$0c38 [00]
0007dc54 3838 387c                move.w $387c [aaaa],d4
0007dc58 fff0                     illegal
0007dc5a 0000 1ffd                or.b #$fd,d0
0007dc5e 6ffc                     ble.b #$fc == $0007dc5c (T)
0007dc60 0000 7ff3                or.b #$f3,d0
0007dc64 fd3c                     illegal
0007dc66 3c3c 3c00                move.w #$3c00,d6
0007dc6a a100                     illegal
0007dc6c 0000 0194                or.b #$94,d0
0007dc70 0e95 a170                [ moves.l (a5) [00c00276],a2 ]
0007dc72 a170                     illegal
0007dc74 8000                     or.b d0,d0


0007dc76 0000 bf6c                or.b #$6c,d0
0007dc7a 1c6c                     illegal
0007dc7c 6c60                     bge.b #$60 == $0007dcde (T)
0007dc7e 6c7c                     bge.b #$7c == $0007dcfc (T)
0007dc80 7fff                     illegal
0007dc82 c000                     and.b d0,d0
0007dc84 0fbf                     illegal
0007dc86 67b8                     beq.b #$b8 == $0007dc40 (T)
0007dc88 001f ffe3                or.b #$e3,(a7)+ [00]
0007dc8c fd00                     illegal
0007dc8e 0042 4000                or.w #$4000,d2
0007dc92 fd00                     illegal
0007dc94 0000 0064                or.b #$64,d0
0007dc98 0e85                     illegal
0007dc9a a970                     illegal
0007dc9c 8000                     or.b d0,d0
0007dc9e 0000 956c                or.b #$6c,d0
0007dca2 0c6c 6c60 0c7e           cmp.w #$6c60,(a4,$0c7e) == $000021d6 [aaaa]
0007dca8 ffff                     illegal
0007dcaa f000 0fb1                [ F-LINE (MMU 68030) ]
0007dcac 0fb1 9fb0                bclr.b d7,(a1,a1.L[*8],$b0) == $01802974 (68020+)
0007dcb0 007f                     illegal
0007dcb2 fff7                     illegal
0007dcb4 fd00                     illegal
0007dcb6 0066 6000                or.w #$6000,-(a6) [231c]
0007dcba a900                     illegal
0007dcbc 0800 01a4                btst.l #$01a4,d0
0007dcc0 0e95 a170                [ moves.l (a5) [00c00276],a2 ]
0007dcc2 a170                     illegal
0007dcc4 8008                     illegal
0007dcc6 0000 af6c                or.b #$6c,d0
0007dcca 0c38 3c78 187c           cmp.b #$78,$187c [00]
0007dcd0 6000 1800                bra.w #$1800 == $0007f4d2 (T)
0007dcd4 0fc7                     bset.l d7,d7
0007dcd6 c3b8 00c0                and.l d1,$00c0 [00000000]
0007dcda 0023 fd00                or.b #$00,-(a3) [d0]
0007dcde 0066 6000                or.w #$6000,-(a6) [231c]
0007dce2 f500                     [ pflushn (a0) ]
0007dce4 2000                     move.l d0,d0
0007dce6 0334 0e85                btst.b d1,(a4,d0.L[*8],$85) == $000014dd (68020+) [ff]



0007dcea a170                     illegal
0007dcec 8010                     or.b (a0) [23],d0
0007dcee 1000                     move.b d0,d0
0007dcf0 ad6c                     illegal
0007dcf2 0c6c 0c6c 0c7d           cmp.w #$0c6c,(a4,$0c7d) == $000021d5 [aaaa]
0007dcf8 ffff                     illegal
0007dcfa 8400                     or.b d0,d2
0007dcfc 07e8 11a0                bset.b d3,(a0,$11a0) == $00fea8b6 [00]
0007dd00 000f                     illegal
0007dd02 fffb                     illegal
0007dd04 fd00                     illegal
0007dd06 0042 4000                or.w #$4000,d2
0007dd0a b501                     eor.b d2,d1
0007dd0c 0400 0404                sub.b #$04,d0
0007dd10 0e85                     illegal
0007dd12 a970                     illegal
0007dd14 8000                     or.b d0,d0
0007dd16 2000                     move.l d0,d0
0007dd18 8f6c 0c6c                or.w d7,(a4,$0c6c) == $000021c4 [aaaa]
0007dd1c 0c6c 6c7c ffff           cmp.w #$6c7c,(a4,-$0001) == $00001557 [0000]
0007dd22 c400                     and.b d0,d2
0007dd24 01c0                     bset.l d0,d0
0007dd26 48c0                     ext.l d0
0007dd28 001f fff3                or.b #$f3,(a7)+ [00]
0007dd2c fd00                     illegal
0007dd2e 003c 3c00                or.b #$3c00,ccr
0007dd32 f1ff                     illegal
0007dd34 ffff                     illegal
0007dd36 fff8                     illegal
0007dd38 0e95 a970                [ moves.l a2,(a5) [00c00276] ]
0007dd3a a970                     illegal
0007dd3c 8040                     or.w d0,d0
0007dd3e 4001                     negx.b d1
0007dd40 8d38 0c38                or.b d6,$0c38 [00]
0007dd44 3838 387e                move.w $387e [aaaa],d4
0007dd48 0000 1800                or.b #$00,d0
0007dd4c 0141                     bchg.l d0,d1
0007dd4e 87e0                     divs.w -(a0) [4e75],d3
0007dd50 00c0                     illegal
0007dd52 0007 fd00                or.b #$00,d7



0007dd56 0000 0000                or.b #$00,d0
0007dd5a b118                     eor.b d0,(a0)+ [23]
0007dd5c 0000 0000                or.b #$00,d0
0007dd60 0e95 a970                [ moves.l a2,(a5) [00c00276] ]
0007dd62 a970                     illegal
0007dd64 8000                     or.b d0,d0
0007dd66 0026 fd00                or.b #$00,-(a6) [1c]
0007dd6a 0000 0000                or.b #$00,d0
0007dd6e 007d                     illegal
0007dd70 ffff                     illegal
0007dd72 f000 0001                [ F-LINE (MMU 68030) ]
0007dd74 0001 cf60                or.b #$60,d1
0007dd78 007f                     illegal
0007dd7a fffb                     illegal
0007dd7c fdff                     illegal
0007dd7e ffff                     illegal
0007dd80 ffff                     illegal
0007dd82 bf40                     eor.w d7,d0
0007dd84 0000 0000                or.b #$00,d0
0007dd88 0e95 a370                [ moves.l (a5) [00c00276],a2 ]
0007dd8a a370                     illegal
0007dd8c ffff                     illegal
0007dd8e ffff                     illegal
0007dd90 1fff                     illegal
0007dd92 ffff                     illegal
0007dd94 ffff                     illegal
0007dd96 fffe                     illegal
0007dd98 ffff                     illegal
0007dd9a c000                     and.b d0,d0
0007dd9c 0000 0360                or.b #$60,d0
0007dda0 001f fff7                or.b #$f7,(a7)+ [00]
0007dda4 fc00                     illegal
0007dda6 0000 0000                or.b #$00,d0
0007ddaa 7918                     illegal
0007ddac 0000 0000                or.b #$00,d0
0007ddb0 0ec5                     illegal
0007ddb2 ab70                     illegal
0007ddb4 0000 0000                or.b #$00,d0
0007ddb8 0000 0000                or.b #$00,d0
0007ddbc 0000 0000                or.b #$00,d0


0007ddc0 0010 7000                or.b #$00,(a0) [23]
0007ddc4 001d 8ec0                or.b #$c0,(a5)+ [00]
0007ddc8 0072 4000 0000           or.w #$4000,(a2,d0.W,$00) == $00000001 [0000]
0007ddce 0000 0000                or.b #$00,d0
0007ddd2 0000 0000                or.b #$00,d0
0007ddd6 0000 0ed5                or.b #$d5,d0
0007ddda a37f                     illegal
0007dddc ffff                     illegal
0007ddde ffff                     illegal
0007dde0 ffff                     illegal
0007dde2 ffff                     illegal
0007dde4 ffff                     illegal
0007dde6 ffff                     illegal
0007dde8 fff0                     illegal
0007ddea ec00                     asr.b #$06,d0
0007ddec 0019 1f80                or.b #$80,(a1)+ [00]
0007ddf0 00bc                     illegal
0007ddf2 7fff                     illegal
0007ddf4 ffff                     illegal
0007ddf6 ffff                     illegal
0007ddf8 ffff                     illegal
0007ddfa ffff                     illegal
0007ddfc ffff                     illegal
0007ddfe ffff                     illegal
0007de00 fec5                     illegal
0007de02 a2f8                     illegal
0007de04 0000 0001                or.b #$01,d0
0007de08 007f                     illegal
0007de0a ffff                     illegal
0007de0c ffff                     illegal
0007de0e ffec                     illegal
0007de10 0018 02f0                or.b #$f0,(a0)+ [23]
0007de14 0001 1d80                or.b #$80,d1
0007de18 19f0                     illegal
0007de1a c000                     and.b d0,d0
0007de1c ffff                     illegal
0007de1e ffff                     illegal
0007de20 fffc                     illegal
0007de22 0080 0000 0000           or.l #$00000000,d0
0007de28 1f45 8378                move.b d5,(a7,-$7c88) == $00bf982e



0007de2c 0000 0000                or.b #$00,d0
0007de30 0000 0000                or.b #$00,d0
0007de34 0000 0000                or.b #$00,d0
0007de38 000f                     illegal
0007de3a f02f 8003 9301           [ ptestw dfc,(a7,-$6cff) == $00bfa7b7,#0 ]
0007de3c 8003                     or.b d3,d0
0007de3e 9301                     subx.b d1,d1
0007de40 e77f                     rol.w d3,d7
0007de42 8000                     or.b d0,d0
0007de44 0000 0000                or.b #$00,d0
0007de48 0000 0000                or.b #$00,d0
0007de4c 0000 0000                or.b #$00,d0
0007de50 1ec1                     move.b d1,(a7)+ [00]
0007de52 a2f8                     illegal
0007de54 0000 0000                or.b #$00,d0
0007de58 0000 0000                or.b #$00,d0
0007de5c 0000 0000                or.b #$00,d0
0007de60 0000 0e02                or.b #$02,d0
0007de64 f800 c63e                [ illg #$c63e ]
0007de66 c63e                     illegal
0007de68 8b80 0000                [ unpk d0,d5,#$0000 ]
0007de6a 0000 0000                or.b #$00,d0
0007de6e 0000 0000                or.b #$00,d0
0007de72 0000 0000                or.b #$00,d0
0007de76 0000 1f45                or.b #$45,d0
0007de7a a0b8                     illegal
0007de7c 0000 0000                or.b #$00,d0
0007de80 0000 0000                or.b #$00,d0
0007de84 0000 0000                or.b #$00,d0
0007de88 0000 0fc0                or.b #$c0,d0
0007de8c 27e3                     illegal
0007de8e ffc8                     illegal
0007de90 6780                     beq.b #$80 == $0007de12 (T)
0007de92 0000 0000                or.b #$00,d0
0007de96 0000 0000                or.b #$00,d0
0007de9a 0000 0000                or.b #$00,d0
0007de9e 0000 1d05                or.b #$05,d0
0007dea2 80f8 0000                divu.w $0000 [0000],d0
0007dea6 0007 2109                or.b #$09,d7
0007deaa ffff                     illegal


0007deac ffff                     illegal
0007deae fffe                     illegal
0007deb0 0000 00fc                or.b #$fc,d0
0007deb4 009f f00e 7800           or.l #$f00e7800,(a7)+ [00c00276]
0007deba 0003 ffff                or.b #$ff,d3
0007debe ffff                     illegal
0007dec0 ff21                     illegal
0007dec2 84e0                     divu.w -(a0) [4e75],d2
0007dec4 0000 0000                or.b #$00,d0
0007dec8 1f01                     move.b d1,-(a7) [46]
0007deca 4038 0000                negx.b $0000 [00]
0007dece 0004 6eb7                or.b #$b7,d4
0007ded2 ffff                     illegal
0007ded4 ffff                     illegal
0007ded6 ffff                     illegal
0007ded8 0000 001b                or.b #$1b,d0
0007dedc 8002                     or.b d2,d0
0007dede 23e3 b000 0003           move.l -(a3) [3c0c4ed0],$b0000003 [0000c002]
0007dee4 ffff                     illegal
0007dee6 ffff                     illegal
0007dee8 ffda                     illegal
0007deea 7620                     moveq #$20,d3
0007deec 0000 0000                or.b #$00,d0
0007def0 1c02                     move.b d2,d6
0007def2 3378 6b87 f7ff           move.w $6b87 [c0f8],(a1,-$0801) == $00c00ce1 [0000]
0007def8 ffdf                     illegal
0007defa dfff                     illegal
0007defc ffff                     illegal
0007defe ffff                     illegal
0007df00 f839                     illegal
0007df02 ff01                     illegal
0007df04 f000 b81f                [ f-line (mmu 68030) ]
0007df06 b81f                     cmp.b (a7)+ [00],d4
0007df08 07fc                     illegal
0007df0a f06f                     illegal
0007df0c ffff                     illegal
0007df0e ffff                     illegal
0007df10 f7f7                     illegal
0007df12 ffff                     illegal
0007df14 ffec                     illegal



0007df16 c03b 9ecc                and.b (pc,a1.L[*8],$cc=$0007dee4) == $00c7f3c6 (68020+) [00],d0
0007df1a 0000 0000                or.b #$00,d0
0007df1e 0000 0000                or.b #$00,d0
0007df22 0000 0000                or.b #$00,d0
0007df26 0000 0000                or.b #$00,d0
0007df2a 0000 0000                or.b #$00,d0
0007df2e 0000 0000                or.b #$00,d0
0007df32 0000 0000                or.b #$00,d0
0007df36 0000 0000                or.b #$00,d0
0007df3a 0000 0000                or.b #$00,d0
0007df3e 0000 0000                or.b #$00,d0
0007df42 0fc7                     bset.l d7,d7
0007df44 ffff                     illegal
0007df46 ffff                     illegal
0007df48 ffff                     illegal
0007df4a ffff                     illegal
0007df4c ffff                     illegal
0007df4e ffff                     illegal
0007df50 ffff                     illegal
0007df52 ffff                     illegal
0007df54 8fff                     illegal
0007df56 ffe3                     illegal
0007df58 ffff                     illegal
0007df5a ffff                     illegal
0007df5c ffff                     illegal
0007df5e ffff                     illegal
0007df60 ffff                     illegal
0007df62 ffff                     illegal
0007df64 ffff                     illegal
0007df66 ffff                     illegal
0007df68 e3f0 3fe7                lsl.w (a0,d3.L[*8],$e7) == $00fe96fd (68020+) [2b01]
0007df6c ffff                     illegal
0007df6e ffff                     illegal
0007df70 ffff                     illegal
0007df72 ffff                     illegal
0007df74 ffff                     illegal
0007df76 ffff                     illegal
0007df78 ffff                     illegal
0007df7a fffc                     illegal
0007df7c 7fff                     illegal


0007df7e fffc                     illegal
0007df80 7fff                     illegal
0007df82 ffff                     illegal
0007df84 ffff                     illegal
0007df86 ffff                     illegal
0007df88 ffff                     illegal
0007df8a ffff                     illegal
0007df8c ffff                     illegal
0007df8e ffff                     illegal
0007df90 e7fc                     illegal
0007df92 7fe7                     illegal
0007df94 ffff                     illegal
0007df96 ffff                     illegal
0007df98 ffff                     illegal
0007df9a ffff                     illegal
0007df9c ffff                     illegal
0007df9e ffff                     illegal
0007dfa0 ffff                     illegal
0007dfa2 ffc3                     illegal
0007dfa4 ffe0                     illegal
0007dfa6 0fff                     illegal
0007dfa8 87ff                     illegal
0007dfaa ffff                     illegal
0007dfac ffff                     illegal
0007dfae ffff                     illegal
0007dfb0 ffff                     illegal
0007dfb2 ffff                     illegal
0007dfb4 ffff                     illegal
0007dfb6 ffff                     illegal
0007dfb8 e7fe                     illegal
0007dfba 7fe7                     illegal
0007dfbc ffff                     illegal
0007dfbe ffff                     illegal
0007dfc0 ffff                     illegal
0007dfc2 ffff                     illegal
0007dfc4 ffff                     illegal
0007dfc6 ffff                     illegal
0007dfc8 ffff                     illegal
0007dfca fe3f                     illegal
0007dfcc f800 003f                [ illg #$003f ]


0007dfce 003f                     illegal
0007dfd0 fbff                     illegal
0007dfd2 ffff                     illegal
0007dfd4 ffff                     illegal
0007dfd6 ffff                     illegal
0007dfd8 ffff                     illegal
0007dfda ffff                     illegal
0007dfdc ffff                     illegal
0007dfde ffff                     illegal
0007dfe0 e7fe                     illegal
0007dfe2 7fe7                     illegal
0007dfe4 ffff                     illegal
0007dfe6 ffff                     illegal
0007dfe8 ffff                     illegal
0007dfea ffff                     illegal
0007dfec ffff                     illegal
0007dfee ffff                     illegal
0007dff0 ffff                     illegal
0007dff2 f1ff                     illegal
0007dff4 0000 0001                or.b #$01,d0
0007dff8 fc7f                     illegal
0007dffa ffff                     illegal
0007dffc ffff                     illegal
0007dffe ffff                     illegal
0007e000 ffff                     illegal
0007e002 ffff                     illegal
0007e004 ffff                     illegal
0007e006 ffff                     illegal
0007e008 e7fe                     illegal
0007e00a 7fa0                     illegal
0007e00c 0200 1400                and.b #$00,d0
0007e010 4000                     negx.b d0
0007e012 0000 0000                or.b #$00,d0
0007e016 0140                     bchg.l d0,d0
0007e018 0040 0fc0                or.w #$0fc0,d0
0007e01c 0000 4008                or.b #$08,d0
0007e020 1f80 1000                move.b d0,(a7,d1.W,$00) == $00c07678 [00]
0007e024 0000 0000                or.b #$00,d0
0007e028 0000 0020                or.b #$20,d0
0007e02c 0280 0400 05fe           and.l #$040005fe,d0



0007e032 7f87                     illegal
0007e034 ffff                     illegal
0007e036 ffff                     illegal
0007e038 ffff                     illegal
0007e03a ffff                     illegal
0007e03c ffff                     illegal
0007e03e ffff                     illegal
0007e040 ffe7                     illegal
0007e042 fe00                     illegal
0007e044 0000 2070                or.b #$70,d0
0007e048 03ff                     illegal
0007e04a 3fff                     illegal
0007e04c ffff                     illegal
0007e04e ffff                     illegal
0007e050 ffff                     illegal
0007e052 ffff                     illegal
0007e054 ffff                     illegal
0007e056 ffff                     illegal
0007e058 e1fe                     illegal
0007e05a 7f80                     illegal
0007e05c 0000 0000                or.b #$00,d0
0007e060 0000 0000                or.b #$00,d0
0007e064 0000 0000                or.b #$00,d0
0007e068 000f                     illegal
0007e06a f000 0000                [ F-LINE (MMU 68030) ]
0007e06c 0000 2060                or.b #$60,d0
0007e070 007f                     illegal
0007e072 8000                     or.b d0,d0
0007e074 0000 0000                or.b #$00,d0
0007e078 0000 0000                or.b #$00,d0
0007e07c 0000 0000                or.b #$00,d0
0007e080 01fe                     illegal
0007e082 7e8f                     moveq #$8f,d7
0007e084 ffff                     illegal
0007e086 ffff                     illegal
0007e088 ffff                     illegal
0007e08a ffff                     illegal
0007e08c ffff                     illegal
0007e08e ffff                     illegal
0007e090 ffef                     illegal



0007e092 0000 0000                or.b #$00,d0
0007e096 1048                     illegal
0007e098 000f                     illegal
0007e09a bfff                     illegal
0007e09c ffff                     illegal
0007e09e ffff                     illegal
0007e0a0 ffff                     illegal
0007e0a2 ffff                     illegal
0007e0a4 ffff                     illegal
0007e0a6 ffff                     illegal
0007e0a8 f17e                     illegal
0007e0aa 7e8f                     moveq #$8f,d7
0007e0ac ffff                     illegal
0007e0ae ffff                     illegal
0007e0b0 ffff                     illegal
0007e0b2 ffff                     illegal
0007e0b4 ffff                     illegal
0007e0b6 fffe                     illegal
0007e0b8 0000 0000                or.b #$00,d0
0007e0bc 0001 1800                or.b #$00,d1
0007e0c0 0000 0007                or.b #$07,d0
0007e0c4 fff8                     illegal
0007e0c6 003f                     illegal
0007e0c8 fff8                     illegal
0007e0ca 003f                     illegal
0007e0cc fff8                     illegal
0007e0ce 003f                     illegal
0007e0d0 f17e                     illegal
0007e0d2 7e8f                     moveq #$8f,d7
0007e0d4 ffff                     illegal
0007e0d6 ffff                     illegal
0007e0d8 ffff                     illegal
0007e0da ffff                     illegal
0007e0dc ffff                     illegal
0007e0de fffd                     illegal
0007e0e0 ffff                     illegal
0007e0e2 e000                     asr.b #$08,d0
0007e0e4 0009                     illegal
0007e0e6 1800                     move.b d0,d4
0007e0e8 003f                     illegal



0007e0ea fffb                     illegal
0007e0ec ffe0                     illegal
0007e0ee 000f                     illegal
0007e0f0 ffe0                     illegal
0007e0f2 000f                     illegal
0007e0f4 ffe0                     illegal
0007e0f6 000f                     illegal
0007e0f8 f17e                     illegal
0007e0fa 7e8e                     moveq #$8e,d7
0007e0fc ffff                     illegal
0007e0fe ffff                     illegal
0007e100 feff                     illegal
0007e102 ffff                     illegal
0007e104 ffff                     illegal
0007e106 fffb                     illegal
0007e108 ffff                     illegal
0007e10a f800 0003                [ illg #$0003 ]
0007e10c 0003 0000                or.b #$00,d3
0007e110 00ff                     illegal
0007e112 fffd                     illegal
0007e114 ffc0                     illegal
0007e116 0007 ffc0                or.b #$c0,d7
0007e11a 0007 ffc0                or.b #$c0,d7
0007e11e 0007 f17e                or.b #$7e,d7
0007e122 7e8e                     moveq #$8e,d7
0007e124 7fff                     illegal
0007e126 ffff                     illegal
0007e128 fe00                     illegal
0007e12a 0000 0000                or.b #$00,d0
0007e12e 007b                     illegal
0007e130 ffff                     illegal
0007e132 f800 0000                [ illg #$0000 ]
0007e134 0000 0008                or.b #$08,d0
0007e138 00ff                     illegal
0007e13a fffd                     illegal
0007e13c ff80                     illegal
0007e13e 0003 ff80                or.b #$80,d3
0007e142 0003 ff80                or.b #$80,d3
0007e146 0003 f17e                or.b #$7e,d3
0007e14a 7e8e                     moveq #$8e,d7


0007e14c 7fff                     illegal
0007e14e ffff                     illegal
0007e150 fe38                     illegal
0007e152 0c38 3838 387d           cmp.b #$38,$387d [aa]
0007e158 ffff                     illegal
0007e15a e000                     asr.b #$08,d0
0007e15c 0000 001c                or.b #$1c,d0
0007e160 003f                     illegal
0007e162 fffb                     illegal
0007e164 ff00                     illegal
0007e166 0001 ff00                or.b #$00,d1
0007e16a 0001 ff00                or.b #$00,d1
0007e16e 0001 f17e                or.b #$7e,d1
0007e172 7e8e                     moveq #$8e,d7
0007e174 7993                     illegal
0007e176 0ccf                     illegal
0007e178 fe6c                     illegal
0007e17a 1c6c                     illegal
0007e17c 6c60                     bge.b #$60 == $0007e1de (T)
0007e17e 6c7e                     bge.b #$7e == $0007e1fe (T)
0007e180 0000 0000                or.b #$00,d0
0007e184 0000 251c                or.b #$1c,d0
0007e188 0000 0007                or.b #$07,d0
0007e18c 7f00                     illegal
0007e18e 0001 bf00                or.b #$00,d1
0007e192 0001 bf00                or.b #$00,d1
0007e196 0001 b97e                or.b #$7e,d1
0007e19a 7e8e                     moveq #$8e,d7
0007e19c 7992                     illegal
0007e19e 7ccf                     moveq #$cf,d6
0007e1a0 fe6c                     illegal
0007e1a2 0c6c 6c60 0c7e           cmp.w #$6c60,(a4,$0c7e) == $000021d6 [aaaa]
0007e1a8 0000 0000                or.b #$00,d0
0007e1ac 0000 263c                or.b #$3c,d0
0007e1b0 0000 0007                or.b #$07,d0
0007e1b4 7f00                     illegal
0007e1b6 0001 bf00                or.b #$00,d1
0007e1ba 0001 bf00                or.b #$00,d1
0007e1be 0001 b97e                or.b #$7e,d1
0007e1c2 7e8e                     moveq #$8e,d7



0007e1c4 7812                     moveq #$12,d4
0007e1c6 640f                     bcc.b #$0f == $0007e1d7 (T)
0007e1c8 fe6c                     illegal
0007e1ca 0c38 3c78 187f           cmp.b #$78,$187f [00]
0007e1d0 ffe0                     illegal
0007e1d2 0000 0800                or.b #$00,d0
0007e1d6 317e                     illegal
0007e1d8 0000 3fff                or.b #$ff,d0
0007e1dc 7f00                     illegal
0007e1de 0001 bf00                or.b #$00,d1
0007e1e2 0001 bf00                or.b #$00,d1
0007e1e6 0001 b97e                or.b #$7e,d1
0007e1ea 7e8e                     moveq #$8e,d7
0007e1ec 7992                     illegal
0007e1ee 64cf                     bcc.b #$cf == $0007e1bf (T)
0007e1f0 fe6c                     illegal
0007e1f2 0c6c 0c6c 0c7f           cmp.w #$0c6c,(a4,$0c7f) == $000021d7 [aaaa]
0007e1f8 fff7                     illegal
0007e1fa 8000                     or.b d0,d0
0007e1fc 1100                     move.b d0,-(a0) [75]
0007e1fe 3a7e                     illegal
0007e200 000f                     illegal
0007e202 7fff                     illegal
0007e204 0f00                     btst.l d7,d0
0007e206 0001 8700                or.b #$00,d1
0007e20a 0001 8700                or.b #$00,d1
0007e20e 0001 817e                or.b #$7e,d1
0007e212 7e8e                     moveq #$8e,d7
0007e214 7993                     illegal
0007e216 04cf                     illegal
0007e218 fe6c                     illegal
0007e21a 0c6c 0c6c 6c7d           cmp.w #$0c6c,(a4,$6c7d) == $000081d5 [0000]
0007e220 ffe7                     illegal
0007e222 0000 0400                or.b #$00,d0
0007e226 3cfe                     illegal
0007e228 0007 3ffb                or.b #$fb,d7
0007e22c ff80                     illegal
0007e22e 0003 ff80                or.b #$80,d3
0007e232 0003 ff80                or.b #$80,d3
0007e236 0003 f17e                or.b #$7e,d3

0007e23a 7e8e                     moveq #$8e,d7
0007e23c 7fff                     illegal
0007e23e ffff                     illegal
0007e240 fe38                     illegal
0007e242 0c38 3838 387e           cmp.b #$38,$387e [aa]
0007e248 000e                     illegal
0007e24a 0000 0000                or.b #$00,d0
0007e24e 1ffe                     illegal
0007e250 0003 8007                or.b #$07,d3
0007e254 ffc0                     illegal
0007e256 0007 ffc0                or.b #$c0,d7
0007e25a 0007 ffc0                or.b #$c0,d7
0007e25e 0007 f17e                or.b #$7e,d7
0007e262 7e8e                     moveq #$8e,d7
0007e264 7fff                     illegal
0007e266 ffff                     illegal
0007e268 fe00                     illegal
0007e26a 0000 0000                or.b #$00,d0
0007e26e 007f                     illegal
0007e270 001e 0000                or.b #$00,(a6)+ [00]
0007e274 0000 1ffc                or.b #$fc,d0
0007e278 0003 c00f                or.b #$0f,d3
0007e27c ffe0                     illegal
0007e27e 000f                     illegal
0007e280 ffe0                     illegal
0007e282 000f                     illegal
0007e284 ffe0                     illegal
0007e286 000f                     illegal
0007e288 f17e                     illegal
0007e28a 7e8e                     moveq #$8e,d7
0007e28c 0000 0000                or.b #$00,d0
0007e290 7e00                     moveq #$00,d7
0007e292 0000 0000                or.b #$00,d0
0007e296 003f                     illegal
0007e298 ffee                     illegal
0007e29a 0000 0000                or.b #$00,d0
0007e29e 0ff8 0003                bset.b d7,$0003 [00]
0007e2a2 bfff                     illegal
0007e2a4 fff8                     illegal
0007e2a6 003f                     illegal



0007e2a8 fff8                     illegal
0007e2aa 003f                     illegal
0007e2ac fff8                     illegal
0007e2ae 003f                     illegal
0007e2b0 f17e                     illegal
0007e2b2 7e8f                     moveq #$8f,d7
0007e2b4 ffff                     illegal
0007e2b6 ffff                     illegal
0007e2b8 ffff                     illegal
0007e2ba ffff                     illegal
0007e2bc ffff                     illegal
0007e2be ffff                     illegal
0007e2c0 fff6                     illegal
0007e2c2 0000 0000                or.b #$00,d0
0007e2c6 0ff0 0003                bset.b d7,(a0,d0.W,$03) == $00fe9719 [26]
0007e2ca 7fff                     illegal
0007e2cc fcff                     illegal
0007e2ce ffff                     illegal
0007e2d0 ffff                     illegal
0007e2d2 ffff                     illegal
0007e2d4 ffff                     illegal
0007e2d6 ffff                     illegal
0007e2d8 f17e                     illegal
0007e2da 7e8f                     moveq #$8f,d7
0007e2dc ffff                     illegal
0007e2de ffff                     illegal
0007e2e0 ffff                     illegal
0007e2e2 ffff                     illegal
0007e2e4 ffff                     illegal
0007e2e6 fffd                     illegal
0007e2e8 ffe6                     illegal
0007e2ea 0000 0000                or.b #$00,d0
0007e2ee 07e0                     bset.b d3,-(a0) [75]
0007e2f0 0003 3ffb                or.b #$fb,d3
0007e2f4 fc00                     illegal
0007e2f6 0000 0000                or.b #$00,d0
0007e2fa ffff                     illegal
0007e2fc ffff                     illegal
0007e2fe ffff                     illegal
0007e300 f17e                     illegal


0007e302 7e8f                     moveq #$8f,d7
0007e304 ffff                     illegal
0007e306 ffff                     illegal
0007e308 ffff                     illegal
0007e30a ffff                     illegal
0007e30c ffff                     illegal
0007e30e fffe                     illegal
0007e310 000e                     illegal
0007e312 0000 0000                or.b #$00,d0
0007e316 07c0                     bset.l d3,d0
0007e318 0003 8007                or.b #$07,d3
0007e31c fc00                     illegal
0007e31e 0000 0000                or.b #$00,d0
0007e322 fdff                     illegal
0007e324 ffff                     illegal
0007e326 ffff                     illegal
0007e328 f17e                     illegal
0007e32a 7e8f                     moveq #$8f,d7
0007e32c ffff                     illegal
0007e32e ffff                     illegal
0007e330 ffff                     illegal
0007e332 ffff                     illegal
0007e334 ffff                     illegal
0007e336 ffff                     illegal
0007e338 001e 0000                or.b #$00,(a6)+ [00]
0007e33c 0000 03e0                or.b #$e0,d0
0007e340 0003 c00f                or.b #$0f,d3
0007e344 fc00                     illegal
0007e346 0000 0000                or.b #$00,d0
0007e34a fcff                     illegal
0007e34c ffff                     illegal
0007e34e ffff                     illegal
0007e350 f17e                     illegal
0007e352 7e8f                     moveq #$8f,d7
0007e354 ffff                     illegal
0007e356 ffff                     illegal
0007e358 ffff                     illegal
0007e35a ffff                     illegal
0007e35c ffff                     illegal
0007e35e ffff                     illegal


0007e360 ffee                     illegal
0007e362 0000 0000                or.b #$00,d0
0007e366 01e0                     bset.b d0,-(a0) [75]
0007e368 0003 bfff                or.b #$ff,d3
0007e36c fc00                     illegal
0007e36e 0000 0000                or.b #$00,d0
0007e372 fcff                     illegal
0007e374 ffff                     illegal
0007e376 ffff                     illegal
0007e378 f17e                     illega
0007e37a 7e8e                     moveq #$8e,d7
0007e37c ffff                     illegal
0007e37e ffff                     illegal
0007e380 feff                     illegal
0007e382 ffff                     illegal
0007e384 ffff                     illegal
0007e386 ffff                     illegal
0007e388 fff6                     illegal
0007e38a 0000 0000                or.b #$00,d0
0007e38e 07e0                     bset.b d3,-(a0) [75]
0007e390 0003 7fff                or.b #$ff,d3
0007e394 fc00                     illegal
0007e396 0000 0000                or.b #$00,d0
0007e39a fcfe                     illegal
0007e39c 049c 87ff f17e           sub.l #$87fff17e,(a4)+ [00000000]
0007e3a2 7e8e                     moveq #$8e,d7
0007e3a4 7fff                     illegal
0007e3a6 ffff                     illegal
0007e3a8 fe00                     illegal
0007e3aa 0000 0000                or.b #$00,d0
0007e3ae 007d                     illegal
0007e3b0 ffe7                     illegal
0007e3b2 0000 0100                or.b #$00,d0
0007e3b6 bfe4                     cmpa.l -(a4) [00000000],a7
0007e3b8 0007 3ffb                or.b #$fb,d7
0007e3bc fc00                     illegal
0007e3be 0000 0000                or.b #$00,d0
0007e3c2 fcff                     illegal
0007e3c4 9c88                     sub.l a0,d6
0007e3c6 9fff                     illegal


0007e3c8 f17e                     illegal
0007e3ca 7e8e                     moveq #$8e,d7
0007e3cc 7fff                     illegal
0007e3ce ffff                     illegal
0007e3d0 fe38                     illegal
0007e3d2 0c38 3838 387e           cmp.b #$38,$387e [aa]
0007e3d8 000f                     illegal
0007e3da 8000                     or.b d0,d0
0007e3dc 0000 9fc0                or.b #$c0,d0
0007e3e0 000f                     illegal
0007e3e2 8007                     or.b d7,d0
0007e3e4 fc00                     illegal
0007e3e6 0000 0000                or.b #$00,d0
0007e3ea fcff                     illegal
0007e3ec 9c80                     sub.l d0,d6
0007e3ee 87ff                     illegal
0007e3f0 f17e                     illegal
0007e3f2 7e8e                     moveq #$8e,d7
0007e3f4 618c                     bsr.b #$8c == $0007e382
0007e3f6 30c3                     move.w d3,(a0)+ [236b]
0007e3f8 fe6c                     illegal
0007e3fa 1c6c                     illegal
0007e3fc 6c60                     bge.b #$60 == $0007e45e (T)
0007e3fe 6c7f                     bge.b #$7f == $0007e47f (T)
0007e400 0000 0000                or.b #$00,d0
0007e404 0040 9fc0                or.w #$9fc0,d0
0007e408 0000 000f                or.b #$0f,d0
0007e40c fc00                     illegal
0007e40e 0000 0000                or.b #$00,d0
0007e412 fcff                     illegal
0007e414 9c94                     sub.l (a4) [00000000],d6
0007e416 9fff                     illegal
0007e418 f17e                     illegal
0007e41a 7e8e                     moveq #$8e,d7
0007e41c 4f39 924f fe6c           [ chk.l $924ffe6c,d7 ]
0007e41e 924f                     sub.w a7,d1
0007e420 fe6c                     illegal
0007e422 0c6c 6c60 0c7e           cmp.w #$6c60,(a4,$0c7e) == $000021d6 [aaaa]
0007e428 0000 0000                or.b #$00,d0
0007e42c 0040 7fc8                or.w #$7fc8,d0


0007e430 0000 0007                or.b #$07,d0
0007e434 fc00                     illegal
0007e436 0000 0000                or.b #$00,d0
0007e43a fcff                     illegal
0007e43c 9c9c                     sub.l (a4)+ [00000000],d6
0007e43e 87ff                     illegal
0007e440 f17e                     illegal
0007e442 7e8e                     moveq #$8e,d7
0007e444 4139 90c3 fe6c           [ chk.l $90c3fe6c,d0 ]
0007e446 90c3                     suba.w d3,a0
0007e448 fe6c                     illegal
0007e44a 0c38 3c78 187d           cmp.b #$78,$187d [00]
0007e450 ffff                     illegal
0007e452 e000                     asr.b #$08,d0
0007e454 0000 3fc0                or.b #$c0,d0
0007e458 003f                     illegal
0007e45a fffb                     illegal
0007e45c fc00                     illegal
0007e45e 0000 0000                or.b #$00,d0
0007e462 fcff                     illegal
0007e464 ffff                     illegal
0007e466 ffff                     illegal
0007e468 f17e                     illegal
0007e46a 7e8e                     moveq #$8e,d7
0007e46c 7939                     illegal
0007e46e 924f                     sub.w a7,d1
0007e470 fe6c                     illegal
0007e472 0c6c 0c6c 0c7b           cmp.w #$0c6c,(a4,$0c7b) == $000021d3 [aaaa]
0007e478 ffff                     illegal
0007e47a f800 0000                [ illg #$0000 ]
0007e47c 0000 03d0                or.b #$d0,d0
0007e480 00ff                     illegal
0007e482 fffd                     illegal
0007e484 fc00                     illegal
0007e486 0000 0000                or.b #$00,d0
0007e48a fcff                     illegal
0007e48c ffff                     illegal
0007e48e ffff                     illegal
0007e490 f17e                     illegal
0007e492 7e8e                     moveq #$8e,d7


0007e494 438c                     illegal
0007e496 3243                     movea.w d3,a1
0007e498 fe6c                     illegal
0007e49a 0c6c 0c6c 6c7b           cmp.w #$0c6c,(a4,$6c7b) == $000081d3 [0000]
0007e4a0 ffff                     illegal
0007e4a2 f800 0000                [ illg #$0000 ]
0007e4a4 0000 07a0                or.b #$a0,d0
0007e4a8 00ff                     illegal
0007e4aa fffd                     illegal
0007e4ac fc00                     illegal
0007e4ae 0000 0000                or.b #$00,d0
0007e4b2 fc00                     illegal
0007e4b4 0000 0003                or.b #$03,d0
0007e4b8 f17e                     illegal
0007e4ba 7e8e                     moveq #$8e,d7
0007e4bc 7fff                     illegal
0007e4be ffff                     illegal
0007e4c0 fe38                     illegal
0007e4c2 0c38 3838 387d           cmp.b #$38,$387d [aa]
0007e4c8 ffff                     illegal
0007e4ca e000                     asr.b #$08,d0
0007e4cc 0000 7f80                or.b #$80,d0
0007e4d0 003f                     illegal
0007e4d2 fffb                     illegal
0007e4d4 fc00                     illegal
0007e4d6 0000 0000                or.b #$00,d0
0007e4da ffff                     illegal
0007e4dc ffff                     illegal
0007e4de ffff                     illegal
0007e4e0 f17e                     illegal
0007e4e2 7e8e                     moveq #$8e,d7
0007e4e4 7fff                     illegal
0007e4e6 ffff                     illegal
0007e4e8 fe00                     illegal
0007e4ea 0000 0000                or.b #$00,d0
0007e4ee 007e                     illegal
0007e4f0 0000 0000                or.b #$00,d0
0007e4f4 0000 3f80                or.b #$80,d0
0007e4f8 0000 0007                or.b #$07,d0
0007e4fc fc00                     illegal



0007e4fe 0000 0000                or.b #$00,d0
0007e502 7fff                     illegal
0007e504 ffff                     illegal
0007e506 ffff                     illegal
0007e508 f17e                     illegal
0007e50a 7c8e                     moveq #$8e,d6
0007e50c 0000 0000                or.b #$00,d0
0007e510 7e00                     moveq #$00,d7
0007e512 0000 0000                or.b #$00,d0
0007e516 003f                     illegal
0007e518 0000 0000                or.b #$00,d0
0007e51c 0000 0f80                or.b #$80,d0
0007e520 0000 000f                or.b #$0f,d0
0007e524 fc00                     illegal
0007e526 0000 0000                or.b #$00,d0
0007e52a 7fff                     illegal
0007e52c ffff                     illegal
0007e52e ffff                     illegal
0007e530 f13e                     illegal
0007e532 7c8f                     moveq #$8f,d6
0007e534 ffff                     illegal
0007e536 ffff                     illegal
0007e538 ffff                     illegal
0007e53a ffff                     illegal
0007e53c ffff                     illegal
0007e53e ffff                     illegal
0007e540 ffef                     illegal
0007e542 8000                     or.b d0,d0
0007e544 0000 7f00                or.b #$00,d0
0007e548 000f                     illegal
0007e54a bfff                     illegal
0007e54c ffff                     illegal
0007e54e ffff                     illegal
0007e550 ffff                     illegal
0007e552 ffff                     illegal
0007e554 ffff                     illegal
0007e556 ffff                     illegal
0007e558 f13e                     illegal
0007e55a 7c80                     moveq #$80,d6
0007e55c 0000 0000                or.b #$00,d0


0007e560 0000 0000                or.b #$00,d0
0007e564 0000 0000                or.b #$00,d0
0007e568 000f                     illegal
0007e56a f000 0000                [ F-LINE (MMU 68030) ]
0007e56c 0000 fe00                or.b #$00,d0
0007e570 007f                     illegal
0007e572 8000                     or.b d0,d0
0007e574 0000 0000                or.b #$00,d0
0007e578 0000 0000                or.b #$00,d0
0007e57c 0000 0000                or.b #$00,d0
0007e580 013e                     illegal
0007e582 7d07                     illegal
0007e584 ffff                     illegal
0007e586 ffff                     illegal
0007e588 ffff                     illegal
0007e58a ffff                     illegal
0007e58c ffff                     illegal
0007e58e ffff                     illegal
0007e590 ffe7                     illegal
0007e592 ff00                     illegal
0007e594 0000 fe00                or.b #$00,d0
0007e598 07ff                     illegal
0007e59a 3fff                     illegal
0007e59c ffff                     illegal
0007e59e ffff                     illegal
0007e5a0 ffff                     illegal
0007e5a2 ffff                     illegal
0007e5a4 ffff                     illegal
0007e5a6 ffff                     illegal
0007e5a8 e0be                     ror.l d0,d6
0007e5aa 7c80                     moveq #$80,d6
0007e5ac 0000 00a0                or.b #$a0,d0
0007e5b0 0800 0000                btst.l #$0000,d0
0007e5b4 0002 00a0                or.b #$a0,d2
0007e5b8 0000 0ff0                or.b #$f0,d0
0007e5bc 0000 7c00                or.b #$00,d0
0007e5c0 1f80 0000                move.b d0,(a7,d0.W,$00) == $00c014b6 [00]
0007e5c4 0080 0000 0000           or.l #$00000000,d0
0007e5ca 1005                     move.b d5,d0
0007e5cc 0000 0000                or.b #$00,d0



0007e5d0 813e                     illegal
0007e5d2 7d07                     illegal
0007e5d4 ffff                     illegal
0007e5d6 ffff                     illegal
0007e5d8 ffff                     illegal
0007e5da ffff                     illegal
0007e5dc ffff                     illegal
0007e5de ffff                     illegal
0007e5e0 ffff                     illegal
0007e5e2 f1ff                     illegal
0007e5e4 0000 3801                or.b #$01,d0
0007e5e8 fc7f                     illegal
0007e5ea ffff                     illegal
0007e5ec ffff                     illegal
0007e5ee ffff                     illegal
0007e5f0 ffff                     illegal
0007e5f2 ffff                     illegal
0007e5f4 ffff                     illegal
0007e5f6 ffff                     illegal
0007e5f8 e0be                     ror.l d0,d6
0007e5fa 7f47                     illegal
0007e5fc ffff                     illegal
0007e5fe ffff                     illegal
0007e600 ffff                     illegal
0007e602 ffff                     illegal
0007e604 ffff                     illegal
0007e606 ffff                     illegal
0007e608 ffff                     illegal
0007e60a f03f                     illegal
0007e60c f800 003f                [ illg #$003f ]
0007e60e 003f                     illegal
0007e610 f87f                     illegal
0007e612 ffff                     illegal
0007e614 ffff                     illegal
0007e616 ffff                     illegal
0007e618 ffff                     illegal
0007e61a ffff                     illegal
0007e61c ffff                     illegal
0007e61e ffff                     illegal
0007e620 e2fe                     illegal



0007e622 7f07                     illegal
0007e624 ffff                     illegal
0007e626 ffff                     illegal
0007e628 ffff                     illegal
0007e62a ffff                     illegal
0007e62c ffff                     illegal
0007e62e ffff                     illegal
0007e630 ffff                     illegal
0007e632 ff03                     illegal
0007e634 ffe0                     illegal
0007e636 0fff                     illegal
0007e638 87ff                     illegal
0007e63a ffff                     illegal
0007e63c ffff                     illegal
0007e63e ffff                     illegal
0007e640 ffff                     illegal
0007e642 ffff                     illegal
0007e644 ffff                     illegal
0007e646 ffff                     illegal
0007e648 e0fe                     illegal
0007e64a 3fc7                     illegal
0007e64c ffff                     illegal
0007e64e ffff                     illegal
0007e650 ffff                     illegal
0007e652 ffff                     illegal
0007e654 ffff                     illegal
0007e656 ffff                     illegal
0007e658 ffff                     illegal
0007e65a ffe4                     illegal
0007e65c 7fff                     illegal
0007e65e fffc                     illegal
0007e660 4fff                     illegal
0007e662 ffff                     illegal
0007e664 ffff                     illegal
0007e666 ffff                     illegal
0007e668 ffff                     illegal
0007e66a ffff                     illegal
0007e66c ffff                     illegal
0007e66e ffff                     illegal
0007e670 e3fc                     illegal


0007e672 0c87 ffff ffff           cmp.l #$ffffffff,d7
0007e678 ffff                     illegal
0007e67a ffff                     illegal
0007e67c ffff                     illegal
0007e67e ffff                     illegal
0007e680 ffff                     illegal
0007e682 fffe                     illegal
0007e684 0fff                     illegal
0007e686 ffe0                     illegal
0007e688 ffff                     illegal
0007e68a ffff                     illegal
0007e68c ffff                     illegal
0007e68e ffff                     illegal
0007e690 ffff                     illegal
0007e692 ffff                     illegal
0007e694 ffff                     illegal
0007e696 ffff                     illegal
0007e698 e130                     roxl.b d0,d0


batman_energy_gfx                   ; batman image of energy display 64 x 41 pixels in size
L0007E69A   dc.w $0024, $8000, $4002, $7800     ; .... .... ..X. .X.. X... .... .... .... .X.. .... .... ..X. .XXX X... .... ....
            dc.w $0188, $0006, $A7C0, $2800   ; .... ...X X... X... .... .... .... .XX. X.X. .XXX XX.. .... ..X. X... .... .... 
L0007E6AA   dc.w $0200, $0008, $203C, $0200     ; .... ..X. .... .... .... .... .... X... ..X. .... ..XX XX.. .... ..X. .... ....
            dc.w $6000, $0004, $48BC, $0026     ; .XX. .... .... .... .... .... .... .X.. .X.. X... X.XX XX.. .... .... ..X. .XX.
L0007E6BA   dc.w $E000, $000E, $10FC, $003F     ; XXX. .... .... .... .... .... .... XXX. ...X .... XXXX XX.. .... .... ..XX XXXX
            dc.w $0000, $0507, $38B0, $000E     ; .... .... .... .... .... .X.X .... .XXX ..XX X... X.XX .... .... .... .... XXX.
L0007E6CA   dc.w $C000, $00F2, $3938, $001F     ; XX.. .... .... .... .... .... XXXX ..X. ..XX X..X ..XX X... .... .... ...X XXXX  
            dc.w $1800, $0037, $8398, $00C0     ; ...X X... .... .... .... .... ..XX .XXX X... ..XX X..X X... .... .... XX.. ....
L0007E6DA   dc.w $4000, $001D, $9818, $0010     ; .X.. .... .... .... .... .... ...X XX.X X..X X... ...X X... .... .... ...X ....
            dc.w $E000, $0001, $0118, $003C     ; XXX. .... .... .... .... .... .... ...X .... ...X ...X X... .... .... ..XX XX..
L0007E6EA   dc.w $1800, $0000, $0828, $00C0     ; ...X X... .... .... .... .... .... .... .... X... ..X. X... .... .... XX.. ....
            dc.w $0000, $0000, $072C, $0000     ; .... .... .... .... .... .... .... .... .... .XXX ..X. XX.. .... .... .... ....
L0007E6FA   dc.w $8000, $0000, $595C, $000F     ; X... .... .... .... .... .... .... .... .X.X X..X .X.X XX.. .... .... .... XXXX
            dc.w $8000, $1900, $5D2C, $000F     ; X... .... .... .... ...X X..X .... .... .X.X XX.X ..X. XX.. .... .... .... XXXX
L0007E70A   dc.w $0000, $2EC0, $2E5C, $0000     ; .... .... .... .... ..X. XXX. XX.. .... ..X. XXX. .X.X XX.. .... .... .... ....
            dc.w $0000, $1100, $24EC, $0003     ; .... .... .... .... ...X ...X .... .... ..X. .X.. XXX. XX.. .... .... .... ....
L0007E71A   dc.w $0000, $0C40, $17DC, $0001     ; .... .... .... .... .... XX.. .X.. .... ...X .XXX XX.X XX.. .... .... .... ..XX
            dc.w $0000, $01C0, $13FA, $0001     ; .... .... .... .... .... ...X XX.. .... ...X ..XX XXXX X.X. .... .... .... ...X
L0007E72A   dc.w $0000, $1E80, $19F4, $0001     ; .... .... .... .... ...X XXX. X... .... ...X X..X XXXX .X.. .... .... .... ...X
            dc.w $0000, $0100, $0BE8, $0001     ; .... .... .... .... .... ...X .... .... .... X.XX XXX. X... .... .... .... ...X
L0007E73A   dc.w $0000, $0000, $0DD4, $0001     ; .... .... .... .... .... .... .... .... .... XX.X XX.X .X.. .... .... .... ...X
            dc.s $0000, $0400, $0E24, $0001     ; .... .... .... .... .... .X.. .... .... .... XXX. ..X. .X.. .... .... .... ...X
L0007E74A   dc.w $0000, $0000, $0644, $0000     ; .... .... .... .... .... .... .... .... .... .XX. .X.. .X.. .... .... .... ....
            dc.s $0000, $0000, $06E4, $0001     ; .... .... .... .... .... .... .... .... .... .XX. XXX. .X.. .... .... .... ...X
L0007E75A   dc.w $0001, $FFB0, $3BCC, $0000     ; .... .... .... ...X XXXX XXXX X.XX .... ..XX X.XX XX.. XX.. .... .... .... ....
            dc.s $0000, $BEF9, $5FC8, $0001     ; .... .... .... .... X.XX XXX. XXXX X..X .X.X XXXX XX.. X... .... .... .... ...X
L0007E76A   dc.w $0000, $1FFD, $FFFC, $0001     ; .... .... .... .... ...X XXXX XXXX XX.X XXXX XXXX XXXX XX.. .... .... .... ...x
            dc.s $8000, $0FBF, $7FF8, $000F     ; X... .... .... .... .... XXXX X.XX XXXX .XXX XXXX XXXX X... .... .... .... XXXX
L0007E77A   dc.w $C000, $0FB1, $BFF0, $001F     ; XX.. .... .... .... .... XXXX X.XX ...X X.XX XXXX XXXX .... .... .... ...X XXXX
            dc.s $1000, $0FC7, $D7B8, $0040     ; ...X .... .... .... .... XXXX XX.. .XXX XX.X .XXX X.XX X... .... .... .X.. .... 
L0007E78A   dc.w $4000, $07E8, $11A0, $0010   ; .X.. .... .... .... .... .XXX XXX. X... ...X ...X X.X. .... .... .... ...X ....
            dc.s $E000, $01C0, $4BC0, $003C     ; XXX. .... .... .... .... ...X XX.. .... .X.. X.XX XX.. .... .... .... ..XX XX..
L0007E79A   dc.w $1800, $0141, $EFE0, $00C0     ; ...X X... .... .... .... ...X .X.. ...X XXX. XXXX XXX. .... .... .... .... ....
            dc.s $0000, $0001, $FFE0, $0000     ; .... .... .... .... .... .... .... ...X XXXX XXXX XXX. .... .... .... .... ....
L0007E7AA   dc.w $8000, $0000, $0F60, $000F     ; X... .... .... .... .... .... .... .... .... XXXX .XX. .... .... .... .... XXXX
            dc.s $0000, $001D, $BFC0, $0004     ; .... .... .... .... .... .... ...X XX.X X.XX XXXX XX.. .... .... .... .... XXXX
L0007E7BA   dc.w $5000, $0019, $7F80, $005B     ; .X.X .... .... .... .... .... ...X X..X .XXX XXXX X... .... .... .... .X.X X.XX
            dc.s $0D00, $0001, $7F80, $064E     ; .... XX.X .... .... .... .... .... ...X .XXX XXXX X... .... .... .XX. .X.. XXX.
L0007E7CA   dc.w $00D0, $8003, $BB00, $1C80     ; .... .... XX.X .... X... .... .... ..XX X.XX X.XX .... .... ...X XX.. X... ....
            dc.s $002D, $0000, $C601, $6800     ; .... .... ..X. XX.X .... .... .... .... XX.. .XX. .... ...X .XX. X... .... ....
L0007E7DA   dc.w $000A, $D803, $F036, $D000     ; .... .... .... X.X. XX.X X... .... ..XX XXXX .... ..XX .XX. XX.X .... .... ....



            dc.w $FFE0, $FFE0, $0FFE, $2FFF     ; XXXX XXXX XXX. .... XXXX XXXX XXX. .... .... XXXX XXXX XXX. ..X. XXXX XXXX XXXX          
L0007E7EA   dc.w $0F8F, $F800, $053F, $E380     ; .... XXXX X... XXXX XXXX X... .... .... .... .X.X ..XX XXXX XXX. ..XX X... ....
            dc.w $F4FC, $0000, $003C, $797F     ; XXXX .X.. XXXX XX.. .... .... .... .... .... .... ..XX XX.. .XXX X..X .XXX XXXX       
L0007E7FA   dc.w $47C0, $0000, $4014, $1F38     ; .X.. .XXX XX.. .... .... .... .... .... .X.. .... ...X .X.. ...X XXXX ..XX X...
            dc.w $FE00, $0004, $10B4, $03FD     ; XXXX XXX. .... .... .... .... .... .X.. ...X X.XX .X.. .... .... ..XX XXXX XX.X
L0007E80A   dc.w $F000, $0002, $20A0, $007F     ; XXXX .... .... .... .... .... .... ..X. ..X. .... X.X. .... .... .... .XXX XXXX
            dc.w $3000, $0002, $3110, $0060     ; ..XX .... .... .... .... .... .... ..X. ..XX ...X ...X .... .... .... .XX. ....
L0007E81A   dc.w $D800, $0016, $0098, $00DF     ; XX.X X... .... .... .... .... ...X .XX. .... .... X..X X... .... .... XX.X XXXX
            dc.w $7000, $0005, $0808, $0070     ; .XXX .... .... .... .... .... .... .X.X .... X... .... X... .... .... .XXX ....
L0007E82A   dc.w $3000, $0000, $0110, $0063     ; ..XX .... .... .... .... .... .... .... .... ...X ...X .... .... .... .XX. ..XX
            dc.w $F800, $0000, $0000, $00FF     ; XXXX X... .... .... .... .... .... .... .... .... .... .... .... .... XXXX XXXX
L0007E83A   dc.w $F000, $0000, $0308, $007F     ; XXXX .... .... .... .... .... .... .... .... ..XX .... X... .... .... .XXX XXXX
            dc.w $4000, $0000, $4708, $0010     ; .X.. .... .... .... .... .... .... .... .X.. .XXX .... X... .... .... ...X ....
L0007E84A   dc.w $C000, $0000, $4004, $001F     ; XX.. .... .... .... .... .... .... .... .X.. .... .... .X.. .... .... ...X XXXX
            dc.w $0000, $0200, $0844, $0001     ; .... .... .... .... .... ..X. .... .... .... X... .X.. .X.. .... .... .... ...X
L0007E85A   dc.w $0000, $0E00, $0484, $0003     ; .... .... .... .... .... XXX. .... .... .... .X.. X... .X.. .... .... .... ..XX
            dc.w $0000, $0000, $0384, $0001     ; .... .... .... .... .... .... .... .... .... ..XX X... .X.. .... .... .... ...X
L0007E86A   dc.w $0000, $0080, $010A, $0001     ; .... .... .... .... .... .... X... .... .... ...X .... X.X. .... .... .... ...X
            dc.w $0000, $0200, $0884, $0001     ; .... .... .... .... .... ..X. .... .... .... X... X... .X.. .... .... .... ...X
L0007E87A   dc.w $0000, $0000, $0808, $0001     ; .... .... .... .... .... .... .... .... .... x... .... x... .... .... .... ...x
            dc.w $0000, $0000, $0C10, $0001     ; .... .... .... .... .... .... .... .... .... xx.. ...X .... .... .... .... ...X
L0007E88A   dc.w $0000, $0000, $0420, $0001     ; .... .... .... .... .... .... .... .... .... .X.. ..X. .... .... .... .... ...X
            dc.w $0000, $0000, $0400, $0001     ; .... .... .... .... .... .... .... .... .... .X.. .... .... .... .... .... ...X
L0007E89A   dc.w $0000, $0000, $06C4, $0001     ; .... .... .... .... .... .... .... .... .... .XX. XX.. .X.. .... .... .... ...X
            dc.w $0000, $0000, $0AC4, $0001     ; .... .... .... .... .... .... .... .... .... X.X. XX.. .X.. .... .... .... ...X
L0007E8AA   dc.w $0000, $08E8, $0FC0, $0003     ; .... .... .... .... .... X... XXX. X... .... XXXX XX.. .... .... .... .... ..XX
            dc.w $0000, $07F0, $4FE8, $0003     ; .... .... .... .... .... .XXX XXXX .... .X.. XXXX XXX. X... .... .... .... ..XX
L0007E8BA   dc.w $C000, $05B0, $47A8, $001F     ; XX.. .... .... .... .... .X.X X.XX .... .X.. .XXX X.X. X... .... .... ...X XXXX
            dc.w $3000, $01A1, $9FB0, $0060   ; ..XX .... .... .... .... ...X X.X. ...X X..X XXXX X.XX .... .... .... .XX. ....
L0007E8CA   dc.w $D800, $04C0, $0390, $00DF     ; XX.X X... .... .... .... .X.. XX.. .... .... ..XX X..X .... .... .... XX.X XXXX
            dc.w $7400, $0080, $1180, $0070   ; .XXX .X.. .... .... .... .... X... .... ...X ...X X... .... .... .... .XXX ....
L0007E8DA   dc.w $3400, $0080, $0880, $0063     ; ..XX .X.. .... .... .... .... X... .... .... X... X... .... .... .... .XX. ..XX
            dc.w $F800, $0000, $07A0, $00FF     ; XXXX X... .... .... .... .... .... .... .... .XXX X.X. .... .... .... XXXX XXXX
L0007E8EA   dc.w $F000, $0000, $CF20, $007F     ; XXXX .... .... .... .... .... .... .... XX.. XXXX ..X. .... .... .... .XXX XXXX
            dc.w $4000, $0000, $0300, $0010     ; .X.. .... .... .... .... .... .... .... .... ..XX .... .... .... .... ...X ....
L0007E8FA   dc.w $F000, $0008, $8E00, $007D     ; XXXX .... .... .... .... .... .... X... X... XXX. .... .... .... .... .XXX XX.X
            dc.w $1C00, $0009, $1F00, $00C3     ; ...X XX.. .... .... .... .... .... X..X ...X XXXX .... .... .... .... XX.. ..XX
L0007E90A   dc.w $FDF0, $0001, $1D00, $1E8F     ; XXXX XX.X XXXX .... .... .... .... ...X ...X XX.X .... .... ...X XXX. X... XXXX
            dc.w $FFDF, $8001, $9201, $F8FF     ; XXXX XXXX XX.X XXXX X... .... .... ...X X..X ..X. .... ...X XXXX X... XXXX XXXX
L0007E91A   dc.w $0FFD, $F800, $443F, $7780     ; .... XXXX XXXX XX.X XXXX X... .... .... .X.. .X.. ..XX XXXX .XXX .XXX X... ....



            dc.w $F1FF, $DFE0, $0FF7, $9C7F     ; XXXX ...X XXXX XXXX XX.X XXXX XXX. .... .... XXXX XXXX .XXX X..X XX.. .XXX XXXX 
L0007E92A   dc.w $01DF, $07E0, $4FC1, $F400     ; .... ...X XX.X XXXX .... .XXX XXX. .... .X.. XXXX XX.. ...X XXXX .X.. .... ....
            dc.w $0E70, $F806, $A7FE, $1F80     ; .... XXX. .XXX .... XXXX X... .... .XX. X.X. .XXX XXXX XXX. ...X XXXX X... ....
L0007E93A   dc.w $FF3C, $0008, $203C, $67FF     ; XXXX XXXX ..XX XX.. .... .... .... X... ..X. .... ..XX XX.. .XX. .XXX XXXX XXXX
            dc.w $B9C0, $0004, $489C, $1CFF     ; X.XX X..X XX.. .... .... .... .... .X.. .X.. X... X..X XX.. ...X XX.. XXXX XXXX
L0007E94A   dc.w $0E00, $000E, $10BC, $0382     ; .... XXX. .... .... .... .... .... XXX. ...X .... X.XX XX.. .... ..XX X... ..X.
            dc.w $F000, $0507, $28B0, $0070     ; XXXX .... .... .... .... .X.X .... .XXX ..X. X... X.XX .... .... .... .XXX ....
L0007E95A   dc.w $F000, $00F2, $3138, $007F     ; XXXX .... .... .... .... .... XXXX ..X. ..XX ...X ..XX X... .... .... .XXX XXXX
            dc.w $1800, $0036, $8398, $00C0     ; ...X X... .... .... .... .... ..XX .XX. X... ..XX X..X X... .... .... XX.. ....
L0007E96A   dc.w $8000, $001D, $9818, $000F     ; X... .... .... .... .... .... ...X XX.X X..X X... ...X X... .... .... .... XXXX
            dc.w $C000, $0001, $0110, $001F     ; XX.. .... .... .... .... .... .... ...X .... ...X ...X .... .... .... ...X XXXX
L0007E97A   dc.w $1800, $0000, $0820, $00C0     ; ...X X... .... .... .... .... .... .... .... X... ..X. .... .... .... XX.. ....
            dc.w $F000, $0000, $0228, $007F     ; XXXX .... .... .... .... .... .... .... .... ..X. ..X. X... .... .... .XXX XXXX
L0007E98A   dc.w $8000, $0000, $5948, $000F     ; X... .... .... .... .... .... .... .... .X.X X..X .X.. X... .... .... .... XXXX
            dc.w $C000, $1100, $4404, $001F     ; XX.. .... .... .... ...X ...X .... .... .X.. .X.. .... .X.. .... .... ...X XXXX
L0007E99A   dc.w $0000, $2EC0, $0844, $0002     ; .... .... .... .... ..X. XXX. XX.. .... .... X... .X.. .X.. .... .... .... ..X.
            dc.w $0000, $1B00, $0484, $0000     ; .... .... .... .... ...X X.XX .... .... .... .X.. X... .X.. .... .... .... ....
L0007E9AA   dc.w $0000, $0C40, $0384, $0000     ; .... .... .... .... .... XX.. .X.. .... .... ..XX X... .X.. .... .... .... ....
            dc.w $0000, $01C0, $010A, $0000     ; .... .... .... .... .... ...X XX.. .... .... ...X .... X.X. .... .... .... ....
L0007E9BA   dc.w $0000, $1E80, $1884, $0000     ; .... .... .... .... ...X XXX. X... .... ...X X... X... .X.. .... .... .... ....
            dc.w $0000, $0100, $0808, $0000     ; .... .... .... .... .... ...X .... .... .... X... .... X... .... .... .... ....
L0007E9CA   dc.w $0000, $0000, $0C14, $0000     ; .... .... .... .... .... .... .... .... .... XX.. ...X .X.. .... .... .... ....
            dc.w $0000, $0400, $0C24, $0000     ; .... .... .... .... .... .X.. .... .... .... XX.. ..X. .X.. .... .... .... ....
L0007E9DA   dc.w $0000, $0000, $0404, $0000     ; .... .... .... .... .... .... .... .... .... .X.. .... .X.. .... .... .... ....
            dc.w $0000, $0000, $06C4, $0000     ; .... .... .... .... .... .... .... .... .... .XX. XX.. .X.. .... .... .... ....
L0007E9EA   dc.w $0001, $FFB0, $3ACC, $0000     ; .... .... .... ...X XXXX XXXX X.XX .... ..XX X.X. XX.. XX.. .... .... .... ....
            dc.w $0000, $BEF9, $4FC8, $0000     ; .... .... .... .... X.XX XXX. XXXX X..X .X.. XXXX XX.. X... .... .... .... ....
L0007E9FA   dc.w $0000, $1FFD, $6FFC, $0000     ; .... .... .... .... ...X XXXX XXXX XX.X .XX. XXXX XXXX XX.. .... .... .... ....
            dc.w $C000, $0FBF, $67B8, $001F     ; XX.. .... .... .... .... XXXX X.XX XXXX .XX. .XXX X.XX X... .... .... ...X XXXX
L0007EA0A   dc.w $F000, $0FB1, $9FB0, $007F     ; XXXX .... .... .... .... XXXX X.XX ...X X..X XXXX X.XX .... .... .... .XXX XXXX
            dc.w $1800, $0FC7, $C3B8, $00C0     ; ...X X... .... .... .... XXXX XX.. .XXX XX.. ..XX XX.X X... .... .... XX.. ....
L0007EA1A   dc.w $8400, $07E8, $11A0, $000F   ; X... .X.. .... .... .... .XXX XXX. X... ...X ...X X.X. .... .... .... .... XXXX
            dc.w $C400, $01C0, $48C0, $001F     ; XX.. .X.. .... .... .... ...X XX.. .... .X.. X... XX.. .... .... .... ...X XXXX
L0007EA2A   dc.w $1800, $0141, $87E0, $00C0     ; ...X X... .... .... .... ...X .X.. ...X X... .XXX XXX. .... .... .... XX.. ....
            dc.w $F000, $0001, $CF60, $007F     ; XXXX .... .... .... .... .... .... ...X XX.. XXXX .XX. .... .... .... .XXX XXXX
L0007EA3A   dc.w $C000, $0000, $0360, $001F     ; XX.. .... .... .... .... .... .... .... .... ..XX .XX. .... .... .... ...X XXXX
            dc.w $7000, $001D, $8EC0, $0072     ; .XXX .... .... .... .... .... ...X XX.X X... XXX. XX.. .... .... .... .XXX ..X.
L0007EA4A   dc.w $EC00, $0019, $1F80, $00BC     ; XXX. XX.. .... .... .... .... ...X X..X ...X XXXX X... .... .... .... XX.X XX..
            dc.w $02F0, $0001, $1D80, $19F0     ; .... ..X. XXXX .... .... .... .... ...X ...X XX.X X... .... ...X X..X XXXX ....
L0007EA5A   dc.w $F02F, $8003, $9301, $E77F     ; XXXX .... ..X. XXXX X... .... .... ..XX X..X ..XX .... ...X XXX. .XXX .XXX XXXX
            dc.w $0E02, $F800, $C63E, $8B80     ; .... XXX. .... ..X. XXXX X... .... .... XX.. .XX. ..XX XXX. X... X.XX X... ....


L0007EA6A   dc.w $0FC0, $27E3, $FFC8, $6780
            dc.w $FE3F, $F800, $003F, $FBFF
L0007EA7A   dc.w $F1FF, $0000, $0001, $FC7F
            dc.w $0FC0, $0000, $4008, $1F80
L0007EA8A   dc.w $FE00, $0000, $2070, $03FF
            dc.w $F000, $0000, $2060, $007F
L0007EA9A   dc.w $0000, $0000, $1048, $000F
            dc.w $0000, $0001, $1800, $0000
L0007EAAA   dc.w $E000, $0009, $1800, $003F
            dc.w $F800, $0003, $0000, $00FF
L0007EABA   dc.w $F800, $0000, $0008, $00FF
            dc.w $E000, $0000, $001C, $003F
L0007EACA   dc.w $0000, $0000, $251C, $0000
            dc.w $0000, $0000, $263C, $0000
L0007EADA   dc.w $0000, $0800, $317E, $0000
            dc.w $8000, $1100, $3A7E, $000F
L0007EAEA   dc.w $0000, $0400, $3CFE, $0007
            dc.w $0000, $0000, $1FFE, $0003
L0007EAFA   dc.w $0000, $0000, $1FFC, $0003
            dc.w $0000, $0000, $0FF8, $0003
L0007EB0A   dc.w $0000, $0000, $0FF0, $0003
            dc.w $0000, $0000, $07E0, $0003
L0007EB1A   dc.w $0000, $0000, $07C0, $0003
            dc.w $0000, $0000, $03E0, $0003
L0007EB2A   dc.w $0000, $0000, $01E0, $0003
            dc.w $0000, $0000, $07E0, $0003
L0007EB3A   dc.w $0000, $0100, $BFE4, $0007
            dc.w $8000, $0000, $9FC0, $000F
L0007EB4A   dc.w $0000, $0040, $9FC0, $0000
            dc.w $0000, $0040, $7FC8, $0000
L0007EB5A   dc.w $E000, $0000, $3FC0, $003F
            dc.w $F800, $0000, $03D0, $00FF
L0007EB6A   dc.w $F800, $0000, $07A0, $00FF
            dc.w $E000, $0000, $7F80, $003F
L0007EB7A   dc.w $0000, $0000, $3F80, $0000
            dc.w $0000, $0000, $0F80, $0000
L0007EB8A   dc.w $8000, $0000, $7F00, $000F
            dc.w $F000, $0000, $FE00, $007F
L0007EB9A   dc.w $FF00, $0000, $FE00, $07FF
            dc.w $0FF0, $0000, $7C00, $1F80
L0007EBAA   dc.w $F1FF, $0000, $3801, $FC7F



            dc.w $F03F, $F800, $003F, $F87F
L0007EBBA dc.w $0024, $8000, $4002, $7800, $0188, $0406, $A7C0, $2800         ;.$..@.x.......(.
L0007EBCA dc.w $0C00, $3006, $3BFE, $0200, $600F, $5E1F, $30DD, $0026           ;..0.;...`.^.0..&
L0007EBDA dc.w $E0C5, $61AF, $EDEB, $E03F, $01D9, $3CCF, $C7FD, $F00E         ;..a....?..<.....
L0007EBEA dc.w $C1D5, $70EF, $DBF9, $F81F, $1BD3, $7A0B, $F27F, $F0C0           ;..p.......z.....
L0007EBFA dc.w $4792, $03C7, $643D, $F810, $E3AC, $60B9, $A3AE, $F83C           ;G...d=....`....<
L0007EC0A dc.w $1B94, $FC6F, $9BFD, $F8C0, $00DD, $838F, $FC17, $7800           ;...o..........x.
L0007EC1A dc.w $80DD, $0063, $B096, $F00F, $80D8, $3C03, $C11E, $F00F           ;...c......<.....
L0007EC2A dc.w $00D8, $6005, $91BF, $7000, $00D8, $A002, $D0AF, $2803           ;..`...p.......(.
L0007EC3A dc.w $00FC, $4000, $F75F, $6801, $00FC, $B039, $FCFF, $0801           ;..@.._h....9....
L0007EC4A dc.w $00FA, $27EB, $7FDF, $B001, $00B5, $0A1B, $62AF, $B001           ;..'.........b...

L0007EC5A dc.w $007D, $400B, $57FF, $B801, $0037, $D01B, $DBFF, $9001           ;.}@.W....7......
L0007EC6A dc.w $0077, $E13B, $FDFF, $B000, $003A, $E59B, $BEFF, $F001           ;.w.;.....:......
L0007EC7A dc.w $0037, $CC35, $FFEF, $E000, $003F, $6A09, $BCFF, $6001           ;.7.5.....?j...`.
L0007EC8A dc.w $003D, $F800, $BFCD, $E001, $803D, $000C, $035E, $E00F           ;.=.......=...^..
L0007EC9A dc.w $C01F, $0FB0, $23DA, $E01F, $103F, $8400, $01FF, $E040           ;....#....?.....@
L0007ECAA dc.w $402F, $8100, $03FB, $C010, $E03B, $C0AC, $0EFC, $C03C           ;@/.......;.....<
L0007ECBA dc.w $1839, $6047, $BFAF, $C0C0, $001C, $E00F, $3F3B, $4000           ;.9`G........?;@.
L0007ECCA dc.w $801C, $3007, $CF4F, $400F, $0011, $8A07, $5D92, $B004           ;..0..O@.....]...
L0007ECDA dc.w $5002, $C583, $3C6E, $D05B, $0D00, $C987, $3EBB, $064E           ;P...<n.[....>..N
L0007ECEA dc.w $00D0, $89C3, $B93C, $1C80, $002D, $00F0, $C341, $6800           ;.....<...-...Ah.

L0007ECFA dc.w $000A, $D807, $F036, $D000, $FFE0, $FFE0, $0FFE, $2FFF           ;.....6......../.
L0007ED0A dc.w $0F8F, $FC00, $053F, $E380, $FC7F, $0000, $1B11, $F97F           ;.....?..........
L0007ED1A dc.w $47F0, $0804, $0048, $1F38, $FF01, $4088, $616B, $03FD           ;G....H.8..@.ak..
L0007ED2A dc.w $F000, $3045, $8250, $007F, $3001, $4028, $9821, $8060           ;..0E.P..0.@(.!.`
L0007ED3A dc.w $D801, $620B, $F27A, $00DF, $7402, $00C0, $603D, $0070           ;..b..z..t...`=.p
L0007ED4A dc.w $3400, $4009, $0186, $0063, $F800, $A002, $8075, $00FF         ;4.@....c.....u..
L0007ED5A dc.w $F000, $0001, $B012, $007F, $4008, $0003, $2092, $0010           ;........@... ...
L0007ED6A dc.w $C008, $1001, $8006, $001F, $0000, $2001, $8187, $0001         ;.......... .....
L0007ED7A dc.w $0010, $0002, $0007, $0003, $0010, $4000, $210F, $6801           ;..........@.!.h.
L0007ED8A dc.w $0088, $0008, $CCD7, $0801, $0098, $000A, $7F4F, $A001           ;.............O..

L0007ED9A dc.w $0091, $0003, $2203, $3001, $005C, $000B, $0136, $B801           ;....".0..\...6..
L0007EDAA dc.w $0033, $4002, $185F, $9001, $0022, $C032, $DD7F, $8001           ;.3@.._...".2....
L0007EDBA dc.w $0028, $E102, $9A3F, $4001, $0007, $8025, $7C02, $0001           ;.(...?@....%|...
L0007EDCA dc.w $0009, $2209, $A0E1, $0003, $0009, $1000, $1509, $0003           ;..".............
L0007EDDA dc.w $C009, $0006, $2210, $001F, $300B, $0001, $2010, $0060           ;...."...0... ..`
L0007EDEA dc.w $D805, $0000, $0042, $00DF, $7404, $8000, $16A8, $0070           ;.....B..t......p
L0007EDFA dc.w $3402, $4006, $4C18, $0063, $F808, $0001, $B584, $00FF           ;4.@.L..c........
L0007EE0A dc.w $F008, $8006, $0802, $807F, $4000, $2000, $CB08, $0010           ;........@. .....
L0007EE1A dc.w $F000, $0003, $0511, $007D, $1C00, $8003, $0021, $00C3           ;.......}.....!..
L0007EE2A dc.w $FDF0, $8903, $088C, $1E8F, $FFDF, $8141, $9109, $F8FF           ;...........A....

L0007EE3A dc.w $0FFD, $F8A0, $403F, $7780, $F1FF, $DFE4, $0FF7, $9C7F           ;....@?w.........



L0007EE4A dc.w $01DF, $07E0, $4FC1, $F400, $0E70, $FC06, $A7FE, $1F80           ;....O....p......
L0007EE5A dc.w $F38F, $0006, $3B1D, $E7FF, $B8F6, $1E1F, $304C, $1CFF           ;....;.......0L..
L0007EE6A dc.w $0F05, $618F, $E1EB, $E382, $F149, $3CC5, $8651, $5070         ;..a......I<..QPp
L0007EE7A dc.w $F011, $70EF, $D821, $F87F, $1B93, $7A0B, $F27B, $A0C0           ;..p..!....z..{..
L0007EE8A dc.w $8692, $03C0, $643D, $D80F, $C7A4, $60B9, $A3A6, $701F           ;....d=....`...p.
L0007EE9A dc.w $1A14, $FC6F, $9BF5, $98C0, $F01D, $838F, $BC12, $687F           ;...o..........h.
L0007EEAA dc.w $805D, $0063, $3092, $300F, $C098, $3C01, $C106, $E01F           ;.].c0.0...<.....
L0007EEBA dc.w $0098, $6005, $91B7, $1002, $0058, $A002, $D087, $2800         ;..`......X....(.
L0007EECA dc.w $00FC, $4000, $F70F, $6800, $00FC, $B038, $FCF7, $0800           ;..@...h....8....
L0007EEDA dc.w $00FA, $27EA, $7FCF, $B000, $00B5, $0A1B, $2203, $3000           ;..'.........".0.

L0007EEEA dc.w $007D, $400B, $0136, $B800, $0033, $D01A, $185F, $9000           ;.}@..6...3..._..
L0007EEFA dc.w $0072, $E13A, $DD7F, $B000, $0038, $E59A, $9E3F, $7000           ;.r.:.....8...?p.
L0007EF0A dc.w $0037, $CC35, $7FE2, $6000, $003F, $6209, $A0FD, $6000           ;.7.5..`..?b...`.
L0007EF1A dc.w $003D, $F800, $950D, $6000, $C03D, $000E, $52DC, $601F           ;  .=....`..=..R.`.
L0007EF2A dc.w $F01F, $0FB1, $A318, $E07F, $183F, $8400, $0672, $E0C0           ;  .........?...r..
L0007EF3A dc.w $842F, $8100, $0EE8, $C00F, $C43B, $C0AF, $BCD8, $C01F           ;  ./.......;......
L0007EF4A dc.w $1839, $6047, $B58D, $C0C0, $F01C, $E00E, $091B, $C07F           ;  .9`G............
L0007EF5A dc.w $C01C, $3007, $CB0B, $C01F, $7011, $8A07, $0513, $B072           ;  ..0.....p......r
L0007EF6A dc.w $EC02, $C583, $006F, $D0BC, $02F0, $C987, $08BF, $19F0           ;  .....o..........
L0007EF7A dc.w $F02F, $89C3, $913D, $E77F, $0E02, $F8F0, $C37E, $8B80           ;  ./...=.......~..

L0007EF8A dc.w $0FC0, $27E7, $FFC8, $6780, $FE3F, $F800, $003F, $FBFF           ;  ..'...g..?...?..
L0007EF9A dc.w $F1FF, $0000, $0001, $FC7F, $0FF0, $0000, $07C0, $1F80           ;  ................
L0007EFAA dc.w $FF00, $0000, $0FE0, $03FF, $F000, $8070, $1E1C, $007F           ;  ...........p....
L0007EFBA dc.w $0000, $0038, $79EE, $000F, $0000, $8010, $07FE, $0000           ;  ...8y...........
L0007EFCA dc.w $E000, $8004, $0C3C, $003F, $F800, $003F, $901E, $00FF           ;  .....<.?...?....
L0007EFDA dc.w $F800, $0006, $005F, $00FF, $E000, $0000, $006F, $003F           ;  ....._.......o.?
L0007EFEA dc.w $0000, $0000, $400F, $8000, $0000, $0004, $C10F, $0000           ;  ....@...........
L0007EFFA dc.w $0000, $0007, $001F, $0000, $8000, $0002, $028F, $800F           ;  ................
L0007F00A dc.w $0000, $0001, $006F, $D007, $0000, $0003, $00FF, $8003           ;  .....o..........
L0007F01A dc.w $0000, $0003, $030F, $C003, $0004, $0001, $803F, $8803           ;  .............?..

L0007F02A dc.w $0048, $0001, $DDFF, $8803, $0002, $8001, $FFFF, $C003           ;  .H..............
L0007F03A dc.w $004C, $0001, $E7FF, $E003, $000F, $0001, $B3FF, $C003           ;  .L..............
L0007F04A dc.w $0007, $0021, $F1FF, $8003, $0000, $0303, $A01F, $8003           ;  ...!............
L0007F05A dc.w $0000, $9C00, $5F03, $8007, $8002, $0001, $7FF3, $800F           ;  ...._...........
L0007F06A dc.w $0002, $0000, $2723, $8000, $0000, $0000, $0067, $0000           ;  ....'#.......g..
L0007F07A dc.w $E000, $0000, $018D, $003F, $F800, $0000, $130D, $00FF         ;  .......?........
L0007F08A dc.w $F800, $0000, $4F13, $00FF, $E000, $0000, $7E72, $003F           ;  ....O.......~r.?
L0007F09A dc.w $0000, $0001, $FEE4, $0000, $0000, $0000, $3CE4, $0000           ;  ............<...
L0007F0AA dc.w $8002, $0400, $FE80, $000F, $F001, $0200, $FF80, $007F           ;  ................
L0007F0BA dc.w $FF00, $0000, $FF00, $07FF, $0FF0, $0000, $7E00, $1F80           ;  ............~...

L0007F0CA dc.w $F1FF, $0000, $3C01, $FC7F, $F03F, $F800, $003F, $F87F           ;  ....<....?...?..









L0007F0DA dc.w $0C00, $1C00, $0400, $0000, $0C00, $0C00, $0000, $0C00           ;  ................
L0007F0EA dc.w $1C00, $0C00, $0C00, $0400, $0000, $0000, $0C00, $1C00           ;  ................
L0007F0FA dc.w $0C00, $0C00, $0C00, $0C00, $0C00, $0C00, $1C00, $0C00           ;  ................
L0007F10A dc.w $0C00, $0C00, $0C00, $0C00, $3800, $6C00, $0400, $0000           ;  ........8.l.....
L0007F11A dc.w $3000, $6C00, $0000, $3800, $6C00, $0C00, $1800, $1000           ;  0.l...8.l.......
L0007F12A dc.w $0000, $0000, $3800, $6C00, $0C00, $1800, $3000, $6C00           ;  ....8.l.....0.l.
L0007F13A dc.w $7C00, $3800, $6C00, $0C00, $1800, $3000, $6C00, $7C00           ;  |.8.l.....0.l.|.
L0007F14A dc.w $3800, $6C00, $0000, $0800, $0C00, $6C00, $0000, $3800           ;  8.l.......l...8.
L0007F15A dc.w $6C00, $0C00, $1800, $0000, $0000, $0000, $3800, $6C00           ;  l...........8.l.
L0007F16A dc.w $0C00, $1800, $0C00, $6C00, $3800, $3800, $6C00, $0C00           ;  ......l.8.8.l...
L0007F17A dc.w $1800, $0C00, $6C00, $3800, $1800, $3800, $0000, $0800           ;....l.8...8.....
L0007F18A dc.w $FC00, $1800, $0000, $1800, $3800, $5800, $9800, $0000           ;........8.X.....
L0007F19A dc.w $0000, $0000, $1800, $3800, $5800, $9800, $FC00, $1800           ;......8.X.......
L0007F1AA dc.w $1800, $1800, $3800, $5800, $9800, $FC00, $1800, $1800           ;....8.X.........
L0007F1BA dc.w $7C00, $6000, $0000, $0400, $0C00, $6C00, $0000, $7C00           ;|.`.......l...|.
L0007F1CA dc.w $6000, $7800, $0C00, $0000, $0000, $0000, $7C00, $6000           ;`.x.........|.`.
L0007F1DA dc.w $7800, $0C00, $0C00, $6C00, $3800, $7C00, $6000, $7800           ;x.....l.8.|.`.x.
L0007F1EA dc.w $0C00, $0C00, $6C00, $3800, $3800, $6000, $0000, $0800           ;....l.8.8.`.....
L0007F1FA dc.w $6C00, $6C00, $0000, $3800, $6000, $6000, $7800, $0000           ;l.l...8.`.`.x...
L0007F20A dc.w $0000, $0000, $3800, $6000, $6000, $7800, $6C00, $6C00           ;....8.`.`.x.l.l.
L0007F21A dc.w $3800, $3800, $6000, $6000, $7800, $6C00, $6C00, $3800           ;8.8.`.`.x.l.l.8.
L0007F22A dc.w $7C00, $0C00, $0000, $0800, $3000, $3000, $0000, $7C00           ;|.......0.0...|.
L0007F23A dc.w $0C00, $0C00, $1800, $0000, $0000, $0000, $7C00, $0C00           ;............|...
L0007F24A dc.w $0C00, $1800, $3000, $3000, $3000, $7C00, $0C00, $0C00           ;....0.0.0.|.....
L0007F25A dc.w $1800, $3000, $3000, $3000, $3800, $6C00, $0000, $0800           ;..0.0.0.8.l.....
L0007F26A dc.w $6C00, $6C00, $0000, $3800, $6C00, $6C00, $3800, $0000           ;l.l...8.l.l.8...
L0007F27A dc.w $0000, $0000, $3800, $6C00, $6C00, $3800, $6C00, $6C00           ;....8.l.l.8.l.l.
L0007F28A dc.w $3800, $3800, $6C00, $6C00, $3800, $6C00, $6C00, $3800           ;8.8.l.l.8.l.l.8.
L0007F29A dc.w $3800, $6C00, $0000, $0400, $0C00, $0C00, $0000, $3800           ;8.l...........8.
L0007F2AA dc.w $6C00, $6C00, $3C00, $0000, $0000, $0000, $3800, $6C00           ;l.l.<.......8.l.
L0007F2BA dc.w $6C00, $3C00, $0C00, $0C00, $3800, $3800, $6C00, $6C00           ;l.<.....8.8.l.l.
L0007F2CA dc.w $3C00, $0C00, $0C00, $3800, $3800, $6C00, $0000, $0400           ;<.....8.8.l.....
L0007F2DA dc.w $6C00, $6C00, $0000, $3800, $6C00, $6C00, $6C00, $0000           ;l.l...8.l.l.l...
L0007F2EA dc.w $0000, $0000, $3800, $6C00, $6C00, $6C00, $6C00, $6C00           ;....8.l.l.l.l.l.
L0007F2FA dc.w $3800, $3800, $6C00, $6C00, $6C00, $6C00, $6C00, $3800           ;8.8.l.l.l.l.l.8.
L0007F30A dc.w $3C00, $4200, $6600, $6600, $4200, $3C00, $4200, $6600           ;<.B.f.f.B.<.B.f.
L0007F31A dc.w $6600, $4200, $3C00, $3C00, $4200, $6600, $6600, $4200           ;f.B.<.<.B.f.f.B.
L0007F32A dc.w $3C00, $4200, $6600, $6600, $4200, $3C00, $3C00, $4200           ;<.B.f.f.B.<.<.B.
L0007F33A dc.w $6600, $6600, $4200, $3C00, $4200, $6600, $6600, $4200           ;f.f.B.<.B.f.f.B.
L0007F34A dc.w $3C00, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;<...............
L0007F35A dc.w $0000, $0000, $0000, $0000, $3C00, $4000, $6000, $6000           ;........<.@.`.`.
L0007F36A dc.w $4000, $3C00, $4000, $6000, $6000, $4000, $3C00, $3C00           ;@.<.@.`.`.@.<.<.
L0007F37A dc.w $4200, $6600, $6600, $4200, $3C00, $4200, $6600, $6600           ;B.f.f.B.<.B.f.f.
L0007F38A dc.w $4200, $3C00, $3C00, $4000, $6000, $6000, $4000, $3C00           ;B.<.<.@.`.`.@.<.
L0007F39A dc.w $4000, $6000, $6000, $4000, $3C00, $0000, $0000, $0000           ;@.`.`.@.<.......
L0007F3AA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0007F3BA dc.w $0000, $4000, $6000, $6000, $4000, $0000, $0200, $0600           ;..@.`.`.@.......
L0007F3CA dc.w $0600, $0200, $0000, $3C00, $4200, $6600, $6600, $4200           ;......<.B.f.f.B.
L0007F3DA dc.w $3C00, $4200, $6600, $6600, $4200, $3C00, $0000, $4000           ;<.B.f.f.B.<...@.
L0007F3EA dc.w $6000, $6000, $4000, $0000, $0200, $0600, $0600, $0200           ;`.`.@...........
L0007F3FA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0007F40A dc.w $0000, $0000, $0000, $0000, $0000, $4000, $6000, $6000           ;..........@.`.`.
L0007F41A dc.w $4000, $0000, $4000, $6000, $6000, $4000, $0000, $3C00           ;@...@.`.`.@...<.
L0007F42A dc.w $4200, $6600, $6600, $4200, $3C00, $4200, $6600, $6600           ;B.f.f.B.<.B.f.f.
L0007F43A dc.w $4200, $3C00, $0000, $4000, $6000, $6000, $4000, $0000           ;B.<...@.`.`.@...
L0007F44A dc.w $4000, $6000, $6000, $4000, $0000, $0000, $0000, $0000           ;@.`.`.@.........
L0007F45A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0007F46A dc.w $3C00, $0000, $0000, $0000, $0000, $0000, $4000, $6000           ;<...........@.`.
L0007F47A dc.w $6000, $4000, $3C00, $3C00, $4200, $6600, $6600, $4200           ;`.@.<.<.B.f.f.B.
L0007F48A dc.w $3C00, $4200, $6600, $6600, $4200, $3C00, $3C00, $0000           ;<.B.f.f.B.<.<...
L0007F49A dc.w $0000, $0000, $0000, $0000, $4000, $6000, $6000, $4000           ;........@.`.`.@.
L0007F4AA dc.w $3C00, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;<...............
L0007F4BA dc.w $0000, $0000, $0000, $0000, $0000, $0200, $0600, $0600           ;................
L0007F4CA dc.w $0200, $0000, $4000, $6000, $6000, $4000, $0000, $3C00           ;....@.`.`.@...<.
L0007F4DA dc.w $4200, $6600, $6600, $4200, $3C00, $4200, $6600, $6600           ;B.f.f.B.<.B.f.f.
L0007F4EA dc.w $4200, $3C00, $0000, $0200, $0600, $0600, $0200, $0000           ;B.<.............
L0007F4FA dc.w $4000, $6000, $6000, $4000, $0000, $0000, $0000, $0000           ;@.`.`.@.........
L0007F50A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0007F51A dc.w $0000, $0200, $0600, $0600, $0200, $0000, $0000, $0000           ;................
L0007F52A dc.w $0000, $0000, $0000, $3C00, $4200, $6600, $6600, $4200           ;......<.B.f.f.B.
L0007F53A dc.w $3C00, $4200, $6600, $6600, $4200, $3C00, $0000, $0200           ;<.B.f.f.B.<.....
L0007F54A dc.w $0600, $0600, $0200, $0000, $0000, $0000, $0000, $0000           ;................
L0007F55A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0007F56A dc.w $0000, $0000, $0000, $0000, $0000, $4000, $6000, $6000           ;..........@.`.`.
L0007F57A dc.w $4000, $3C00, $4000, $6000, $6000, $4000, $3C00, $3C00           ;@.<.@.`.`.@.<.<.
L0007F58A dc.w $4200, $6600, $6600, $4200, $3C00, $4200, $6600, $6600           ;B.f.f.B.<.B.f.f.
L0007F59A dc.w $4200, $3C00, $0000, $4000, $6000, $6000, $4000, $3C00           ;B.<...@.`.`.@.<.
L0007F5AA dc.w $4000, $6000, $6000, $4000, $3C00, $0000, $0000, $0000           ;@.`.`.@.<.......
L0007F5BA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0007F5CA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0007F5DA dc.w $0000, $0000, $0000, $3C00, $4200, $6600, $6600, $4200           ;......<.B.f.f.B.
L0007F5EA dc.w $3C00, $4200, $6600, $6600, $4200, $3C00, $0000, $0000           ;<.B.f.f.B.<.....
L0007F5FA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0007F60A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0007F61A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0007F62A dc.w $0000, $0000, $4000, $6000, $6000, $4000, $0000, $3C00           ;....@.`.`.@...<.
L0007F63A dc.w $4200, $6600, $6600, $4200, $3C00, $4200, $6600, $6600           ;B.f.f.B.<.B.f.f.
L0007F64A dc.w $4200, $3C00, $0000, $0000, $0000, $0000, $0000, $0000           ;B.<.............
L0007F65A dc.w $4000, $6000, $6000, $4000, $0000, $0000, $0000, $0000           ;@.`.`.@.........
L0007F66A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0007F67A dc.w $0000, $0000, $0000, $0000, $0000, $3C00, $0000, $0000           ;..........<.....
L0007F68A dc.w $0000, $0000, $0000, $3C00, $4200, $6600, $6600, $4200           ;......<.B.f.f.B.
L0007F69A dc.w $3C00, $4200, $6600, $6600, $4200, $3C00, $0000, $0000           ;<.B.f.f.B.<.....
L0007F6AA dc.w $0000, $0000, $0000, $3C00, $0000, $0000, $0000, $0000           ;......<.........
L0007F6BA dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0007F6CA dc.w $0000, $0000, $0000, $0000, $3C00, $4200, $6600, $6600           ;........<.B.f.f.
L0007F6DA dc.w $4200, $3C00, $4200, $6600, $6600, $4200, $3C00, $3C00           ;B.<.B.f.f.B.<.<.
L0007F6EA dc.w $4200, $7600, $7600, $4200, $3C00, $4200, $7600, $7600           ;B.v.v.B.<.B.v.v.
L0007F6FA dc.w $4200, $3C00, $3C00, $4200, $6600, $6600, $4200, $3C00           ;B.<.<.B.f.f.B.<.
L0007F70A dc.w $4200, $6600, $6600, $4200, $3C00, $0000, $0000, $0000           ;B.f.f.B.<.......
L0007F71A dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0007F72A dc.w $0000, $0000, $0000, $7FFC, $0001, $0007, $FFC0, $001F           ;................
L0007F73A dc.w $FFF0, $003C, $FE78, $0071, $D71C, $00E1, $C70E, $00C0           ;...<.x.q........
L0007F74A dc.w $8206, $00C0, $0006, $00C0, $0006, $00E2, $008E, $0073           ;...............s
L0007F75A dc.w $459C, $003F, $EFF8, $001F, $FFF0, $0007, $FFC0, $0007           ;E..?............
L0007F76A dc.w $FFC0, $001F, $34F0, $0034, $3858, $0061, $D70C, $00C0           ;....4..48X.a....
L0007F77A dc.w $0006, $00C0, $8206, $0080, $0002, $00C0, $0006, $00C2           ;................
L0007F78A dc.w $0086, $0070, $001C, $0035, $A958, $001F, $15F0, $0007           ;...p...5.X......
L0007F79A dc.w $FFC0, $0000, $0000, $0002, $DF80, $0000, $4400, $0001           ;............D...
L0007F7AA dc.w $0100, $0020, $8208, $0000, $0000, $0040, $0004, $0000           ;... .......@....
L0007F7BA dc.w $0000, $0000, $0000, $0001, $0100, $0006, $46C0, $0003           ;............F...
L0007F7CA dc.w $AE80, $0000, $0000, $0007, $FFC0, $001D, $FF70, $003C           ;.............p.<
L0007F7DA dc.w $FE78, $0070, $D61C, $00E1, $C70E, $00C0, $8206, $00C0           ;.x.p............
L0007F7EA dc.w $0006, $00C0, $0006, $00E2, $008E, $0073, $459C, $003B           ;...........sE..;
L0007F7FA dc.w $EFB8, $001D, $FF70, $0007, $FFC0, $0000, $0000, $0003           ;.....p..........
L0007F80A dc.w $FF80, $000C, $FE60, $0011, $D710, $0021, $C708, $0040           ;.....`.....!...@
L0007F81A dc.w $8204, $0040, $0004, $0040, $0004, $0022, $0088, $0013           ;...@...@..."....
L0007F82A dc.w $4590, $000F, $EFE0, $0003, $FF80, $0000, $0000, $0007           ;E...............
L0007F83A dc.w $FFC0 





batman_lives_icon_mask
L0007f83c   dc.l    $001ffff0       ; .... .... ...X XXXX XXXX XXXX XXXX ....
L0007f840   dc.l    $003cfe78       ; .... .... ..XX XX.. XXXX XXX. .XXX X...
L0007f844   dc.l    $0071d71c       ; .... .... .XXX ...X XX.X .XXX ...X XX..
L0007f848   dc.l    $00e1c70e       ; .... .... XXX. ...X XX.. .XXX .... XXX.
L0007f84c   dc.l    $00c18306       ; .... .... XX.. ...X X... ..XX .... .XX.
L0007f850   dc.l    $00c00006       ; .... .... XX.. .... .... .... .... .XX.
L0007f854   dc.l    $00c00006       ; .... .... XX.. .... .... .... .... .XX.
L0007f858   dc.l    $00e2008e       ; .... .... XXX. ..X. .... .... X... XXX.
L0007f85c   dc.l    $0073459c       ; .... .... .XXX ..XX .X.. .X.X X..X XX..
L0007f860   dc.l    $003feff8       ; .... .... ..XX XXXX XXX. XXXX XXXX X...
L0007f860   dc.l    $001ffff0       ; .... .... ...X XXXX XXXX XXXX XXXX ....
L0007f864   dc.l    $001ffff0       ; .... .... ...X XXXX XXXX XXXX XXXX ....
L0007f868   dc.l    $0007ffc0       ; .... .... .... .XXX XXXX XXXX XX.. ....


batman_lives_icon                   ; 32 x 13 pixels - 4 bitplanes
L0007f86c   dc.L    $0007ffc0       ; .... .... .... .XXX XXXX XXXX XX.. ....
L0007f870   dc.l    $001c0070       ; .... .... .... XX.. .... .... .XXX ....
L0007f874   dc.l    $00300018       ; .... .... ..XX .... .... .... ...X X...
L0007f878   dc.l    $0060000c       ; .... .... .XX. .... .... .... .... XX..
L0007f87c   dc.l    $00c00006       ; .... .... XX.. .... .... .... .... .XX.
L0007f880   dc.l    $00800002       ; .... .... X... .... .... .... .... ..X.
L0007f884   dc.l    $00800002       ; .... .... X... .... .... .... .... ..X.
L0007f888   dc.l    $00800002       ; .... .... X... .... .... .... .... ..X.
L0007f88c   dc.l    $00c00006       ; .... .... XX.. .... .... .... .... .XX.
L0007f890   dc.l    $0060000c       ; .... .... .XX. .... .... .... .... XX..
L0007f894   dc.l    $00300018       ; .... .... ..XX .... .... .... ...X X...
L0007f898   dc.l    $001c0070       ; .... .... ...X XX.. .... .... .XXX ....
L0007f89c   dc.l    $0007ffc0       ; .... .... .... .XXX XXXX XXXX XX.. ....

L0007f8a0   dc.l    $00000000       ; .... .... .... .... .... .... .... ....
L0007f8a4   dc.l    $00000000       ; .... .... .... .... .... .... .... ....
L0007f8a8   dc.l    $00000000       ; .... .... .... .... .... .... .... ....
L0007f8ac   dc.l    $00000000       ; .... .... .... .... .... .... .... ....
L0007f8b0   dc.l    $00000000       ; .... .... .... .... .... .... .... ....
L0007f8b4   dc.l    $00000000       ; .... .... .... .... .... .... .... ....
L0007f8b8   dc.l    $00000000       ; .... .... .... .... .... .... .... ....
L0007f8bc   dc.l    $00000000       ; .... .... .... .... .... .... .... ....
L0007f8c0   dc.l    $00000000       ; .... .... .... .... .... .... .... ....
L0007f8c4   dc.l    $00000000       ; .... .... .... .... .... .... .... ....
L0007f8c8   dc.l    $00000000       ; .... .... .... .... .... .... .... ....
L0007f8cc   dc.l    $00000000       ; .... .... .... .... .... .... .... ....
L0007f8d0   dc.l    $00000000       ; .... .... .... .... .... .... .... ....

L0007f8d4   dc.l    $0007ffc0       ; .... .... .... .XXX XXXX XXXX XX.. .... 
L0007f8d8   dc.l    $001ffff0       ; .... .... ...X XXXX XXXX XXXX XXXX ....
L0007f8dc   dc.l    $003cfe78       ; .... .... ..XX XX.. XXXX XXX. .XXX X...
L0007f8e0   dc.l    $0071d71c       ; .... .... .XXX ...X XX.X .XXX ...X XX..
L0007f8e4   dc.L    $00e1c70e       ; .... .... XXX. ...X XX.. .XXX .... XXX.
L0007f8e8   dc.l    $00c18306       ; .... .... XX.. ...X X... ..XX .... .XX.
L0007f8ec   dc.l    $00c00006       ; .... .... XX.. .... .... .... .... .XX.
L00077ff0   dc.l    $00c00006       ; .... .... XX.. .... .... .... .... .XX.
L00077ff4   dc.l    $00e2008e       ; .... .... XXX. .... .... .... X... XXX.
L0007f8f8   dc.l    $0073459c       ; .... .... .XXX ..XX .X.. .X.X X..X XX..
L0007f8fc   dc.l    $003feff8       ; .... .... ..XX XXXX XXX. XXXX XXXX X...
L0007f900   dc.l    $001ffff0       ; .... .... ...X XXXX XXXX XXXX XXXX ....
L0007f904   dc.l    $0007ffc0       ; .... .... .... .XXX XXXX XXXX XX.. ....

L0007f908   dc.l    $00000000       ; .... .... .... .... .... .... .... ....
L0007f90c   dc.l    $00000000       ; .... .... .... .... .... .... .... ....
L0007f910   dc.l    $00000000       ; .... .... .... .... .... .... .... ....
L0007f914   dc.l    $00000000       ; .... .... .... .... .... .... .... ....
L0007f918   dc.l    $00000000       ; .... .... .... .... .... .... .... ....
L0007f91c   dc.l    $00000000       ; .... .... .... .... .... .... .... ....
L0007f920   dc.l    $00000000       ; .... .... .... .... .... .... .... ....
L0007f924   dc.l    $00000000       ; .... .... .... .... .... .... .... ....
L0007f928   dc.l    $00000000       ; .... .... .... .... .... .... .... ....
L0007f92c   dc.l    $00000000       ; .... .... .... .... .... .... .... ....
L0007f930   dc.l    $00000000       ; .... .... .... .... .... .... .... ....
L0007f934   dc.l    $00000000       ; .... .... .... .... .... .... .... ....
L0007f938   dc.l    $00000000       ; .... .... .... .... .... .... .... ....

L0007f93c   dc.l    $00000000       ; .... .... .... .... .... .... .... ....
L0007f940   dc.w    $1450



0007f942        movem.l (a7)+,d0-d7/a0-a2
0007f946        rts


0007f948        movem.l d0-d7/a0-a2,-(a7)
0007f94c        bsr.w $0007fcca                                     ; no such address (Check it out)
0007f950        movem.l (a7)+,d0-d7/a0-a2
0007f954        rts



0007f956        movem.l d0-d7/a0-a2,-(a7)

L0007f95a       lea.l $0007f768,a0
0007f960        move.w L0007c876,d0                         ; d0 = possible lives count
0007f966        add.w #$0001,L0007c876                      ; increment value
0007f96e        cmp.w #$0003,d0
0007f972        blt.w display_batman_icon                   ; jmp $0007f9ac
0007f976        rts



L0007f978       move.w #$0002,L0007c876                     ; possible lives count
0007f980        clr.b L0007c874                             ; clear status byte
0007f986        moveq #$00,d0
0007f988        lea.l $0007f768,a0
0007f98e        bsr.w display_batman_icon                   ; calls $0007f9ac
0007f992        moveq #$01,d0
0007f994        lea.l $0007f768,a0
0007f99a        bsr.w display_batman_icon                   ; calls $0007f9ac
0007f99e        moveq #$02,d0
0007f9a0        lea.l batman_lives_icon,a0                  ; original icon address $0007f86c
0007f9a6        bsr.w display_batman_icon                   ; calls $0007f9ac
0007f9aa        rts



                ;------------------------------------------------------------
                ; update player lives display/icon?
                ; IN: d0 = lives image to update (0 - 2) desintation index
                ; IN: a0 = source gfx address  
                ;
                ; panel gfx = 320 x 48 pixels (1920 bytes per bitplane)
                ; batman symbol = 32 x 13 pixels (52 bytes per bitplane)
                ;
display_batman_icon                                     ; orignal routine address $0007f9ac
                asl.w #$02,d0                           ; d0 = d0 * 4 (source image index)
                movea.l a0,a2                           ; a0,a2 = copy source gfx ptr
                suba.l #$00000034,a2                    ; a2 = subtract 52 from ptr = gfx mask start address (52 bytes before gfx data)
                lea.l $0007ca44,a1                      ; a1 = desintaion address = $0007ca44 (1st batman lives icon)
                adda.w d0,a1                            ; a1 = destination address + offset to area to update (lives icon)
                move.w #$000c,d0                        ; d0 = 12 + 1 - loop counter 
.display_loop   move.l (a2),d1                          ; d1 = 32 bit mask value
                not.l d1                                ; d1 = invert bits
                and.l d1,(a1)                           ; mask d1.l with contents of      a1 = $7CA44 (start)
                and.l d1,(a1,$0780)                     ; mask d1.l with contents of a1+1920 = $7D1C4 (start)
                and.l d1,(a1,$0f00)                     ; mask d1.l with contents of a1+3840 = $7D944 (start)
                and.l d1,(a1,$1680)                     ; mask d1.l with contents of a1+5769 = $7E0C4 (start) 
                move.l (a0),d2                          ; d2 = 32 bits source gfx
                or.l d2,(a1)                            ; add source gfx to dest address (bitplane 1)
                move.l (a0,$0034),d2                    ; d2 = 32 bit source gfx (52 byte offset) (52/4 = 13 - 32 pixels wide x 13 pixels high )
                or.l d2,(a1,$0780)                      ; add source gfx to dest address (bitplane 2)
                move.l (a0,$0068),d2                    ; d2 = 32 bit source gfx (104 byte offset)
                or.l d2,(a1,$0f00)                      ; add source gfx to dest address (bitplane 3)
                move.l (a0,$009c),d2                    ; d2 = 32 bit source gfx (156 byte offset)
                or.l d2,(a1,$1680)                      ; add source gfx to dest address (biitplane 4)
                adda.l #$00000028,a1                    ; a1 = add 40 bytes to destination address (next scanline bitplane 1)
                addq.l #$04,a2                          ; a2 = increase mask ptr
                addq.l #$04,a0                          ; a0 = increase source gfx ptr
                dbf.w d0,display_loop                   ; loop next display line
                rts



initialise_player_energy                                ; original address $0007fa00
L0007fa00       move.w #$0028,d0                        ; D0 = 40 + 1 - loop counter (initial energy value)
0007fa04        move.w d0,player_remaining_energy       ; set player remaining energy level as address $0007c88e
0007fa0a        clr.w player_hit_damage                 ; L0007C890
0007fa10        lea.l $0007e69a,a0                      ; source gfx
0007fa16        lea.l $0007c94a,a1                      ; destination bitplanes
0007fa1c        move.l a1,L0007c892
L0007fa22       move.l (a0),(a1)
0007fa24        move.l (a0,$0004),(a1,$0004)
0007fa2a        move.l (a0,$0148),(a1,$0780)
0007fa30        move.l (a0,$014c),(a1,$0784)
0007fa36        move.l (a0,$0290),(a1,$0f00)
0007fa3c        move.l (a0,$0294),(a1,$0f04)
0007fa42        move.l (a0,$03d8),(a1,$1680)
0007fa48        move.l (a0,$03dc),(a1,$1684)
0007fa4e        addq.l #$08,a0
0007fa50        adda.l #$00000028,a1
0007fa56        dbf.w   d0,L0007fa22
0007fa5a        move.l #$0007ebba,L0007c896

Exit
L0007fa64       rts                                 ; L0007fa64


0007fa66        tst.w player_remaining_energy       ; test player remaining energy with 0, as address $0007c88e     - 0007fa66
0007fa6c        bne.b L007fa76                      ; 0007fa6c
0007fa6e        clr.w player_hit_damage             ; clear 16b its as address $0007C890                    - 0007fa6e
0007fa74        rts                                 ;                                                       - 0007fa74


L007fa76        add.w d0,player_hit_damage          ; add to player hit/damage as address $0007C890         - L007fa76
0007fa7c        rts                                 ;                                                       - 0007fa7c





                ;------------------- update hit damage -------------------
                ; called every frame from panel_update L0007fc98
                ; it looks like this routine is updating the player's
                ; energy from a hit/damage value stored in $0007C890 'player_hit_damage'
                ; The damage is decremented from the player's energy
                ; every frame, to give the smooth energy loss appearance
                ; over a number of display frames.
                ; The Player's total remaining life energy is stored in $0007C88E 'player_remaining_energy'
                ;
update_hit_damage                                   ; original routine address $0007fa7e 
                move.w  player_hit_damage,d0        ; d0 = stored word value at address $0007C890           - 0007fa7e
                bpl.w   .check_is_0                 ; if D0 >= 0 jmp L0007fa90,                             - 0007fa84
.clamp_value_to_0
                clr.w   player_hit_damage           ; set player hit/damage to 0 at address $0007C890,      - 0007fa88
                moveq   #$00,d0                     ; d0.l = 0,                                             - 0007fa8e
.check_is_0
                beq.b   L0007fa64                   ; if d0 = 0, then exit (jmp L0007fa64),                 - 0007fa90
.decrement_value
                sub.w   #$0001,player_hit_damage    ; reduce player hit/damage as address $0007C890         - 0007fa92


                ; copy interleaved bitplane (32 pixels wide)
                ; possibly update the batman energy display
0007fa9a        movea.l L0007c896,a0                    ; a0 = source ptr to something (initially $0),  - 0007fa9a
0007faa0        movea.l L0007c892,a1                    ; a1 = dest ptr to something (initially 0$),    - 0007faa0

0007faa6        move.l (a0),(a1)                        ; copy 4 bytes source to dest,                  - 0007faa6
0007faa8        move.l $0004(a0),$0004(a1)              ; copy 4 bytes source+4 to dest + 4             - 0007faa8

0007faae        move.l (a0,$0148),(a1,$0780)            ; copy 4 bytes source+328 to dest+328           - 0007faae
0007fab4        move.l (a0,$014c),(a1,$0784)            ; copy 4 bytes source+332 to desc+332           - 0007fab4

0007faba        move.l (a0,$0290),(a1,$0f00)            ; copy 4 bytes source+656 to desc+656           - 0007faba
0007fac0        move.l (a0,$0294),(a1,$0f04)            ; copy 4 bytes source+660 to dest+660           - 0007fac0

0007fac6        move.l (a0,$03d8),(a1,$1680)            ; copy 4 bytes source+984 to dest+984           - 0007fac6
0007facc        move.l (a0,$03dc),(a1,$1684)            ; copy 4 bytes source+988 to dest+988           - 0007facc

0007fad2        addq.l #$08,a0                          ; increment source by 8 bytes                   - 0007fad2
0007fad4        adda.l #$00000028,a1                    ; increment dest by 40 bytes (320 pixel width)  - 0007fad4

0007fada        move.l a0,$0007c896                     ; store updated source ptr                      - 0007fada
0007fae0        move.l a1,L0007c892                     ; store updated dest ptr                        - 0007fae0

0007fae6        sub.w #$0001,player_remaining_energy    ; subtract 1 from total energy at $0007c88e     - 0007fae6
0007faee        bne.w Exit                              ; not equal to 0 then exit (jmp L0007fa64)      - 0007faee
0007faf2        bra.w lose_a_life                       ; is equal to 0 then jmp L0007fb00              - 0007faf2







                ; player has not lives left
set_no_lives_left
L0007faf6       bset.b #$01,L0007c874               ; set bit 1 of status byte 1,               L0007faf6
                rts                                 ; exit                                      007fafe

                ; do lost life processing
lose_a_life                                         ; original routine address $0007fb00
L0007fb00       clr.w   player_hit_damage           ; clear 'energy hit/damage' counter as address $0007C890        - 0007fb00
0007fb06        tst.w   L0007c876                   ; test possible lives count                                     - 0007fb06
0007fb0c        beq.b   L0007faf6                   ; 0007fb0c 

                ; player lost life
0007fb0e        bset.b  #$0002,L0007c874            ; set bit 2 of status byte 1,               0007fb0e
0007fb16        btst.b  #$0007,L0007c875            ; set bit 7 of status byte 2,               0007fb16
0007fb1e        bne.b   L0007fb3e                   ; 0007fb1e

                ; subtract play lives
0007fb20        subq.w  #$01,L0007c876              ; subtract possible lives count             0007fb20
0007fb26        move.w  L0007c876,d0                ; d0 = possible lives count                 0007fb26

                ; check if > 2 lives left
0007fb2c        cmp.w   #$0002,d0                   ; 0007fb2c
0007fb30        bgt.w   L0007fb3e                   ; if > 2 lives left then jmp L0007fb3e      0007fb30

                ; update lives left display?
0007fb34        lea.l   batman_lives_icon,a0        ; a0 = source gfx orignal address $0007f86c                     0007fb34
0007fb3a        bra.w   display_batman_icon         ; d0 = icon to update, a0 = source gfx, jmp $0007f9ac           0007fb3a

L0007fb3e       rts                                 ; L0007fb3e






L0007fb40       clr.l $0007c87c
0007fb46        move.l #$ffffffff,$0007c88a
0007fb50        moveq #$00,d0
0007fb52        move.b $0007c879,d0
0007fb58        move.w #$080e,d1
0007fb5c        bsr.w L0007fd66
0007fb60        move.b $0007c87a,d0
0007fb66        move.w #$0a0e,d1
0007fb6a        bsr.w L0007fd66
0007fb6e        move.b $0007c87b,d0
0007fb74        move.w #$0c0e,d1
0007fb78        bsr.w L0007fd66
0007fb7c        moveq #$00,d0

L0007fb7e       move.l d0,$0007c886
0007fb84        lea.l $0007c88a,a0
0007fb8a        lea.l frame_tick,a1                         ; a1 = $0007c880
0007fb90        and.l #$000000ff,d0
0007fb96        movem.l d0-d1,-(a7)
0007fb9a        move.b $0007c87d,d0
0007fba0        and.b #$f0,d0
0007fba4        move.b #$00,ccr
0007fba8        abcd.b -(a0),-(a1)
0007fbaa        abcd.b -(a0),-(a1)
0007fbac        abcd.b -(a0),-(a1)
0007fbae        move.b $0007c87d,d1
0007fbb4        and.b #$f0,d1
0007fbb8        cmp.b d0,d1
0007fbba        beq.b L0007fbc0
0007fbbc        bsr.w L0007f95a
L007fbc0        movem.l (a7)+,d0-d1
0007fbc4        move.b $0007c87f,d0
0007fbca        cmp.b $0007c88d,d0
0007fbd0        beq.b L0007fbe0
0007fbd2        move.b d0,$0007c88d
0007fbd8        move.w #$0c1e,d1
0007fbdc        bsr.w L0007fd66
L0007fbe0       move.b $0007c87e,d0
0007fbe6        cmp.b $0007c88c,d0
0007fbec        beq.b L0007fbfc 
0007fbee        move.b d0,$0007c88c

0007fbf4        move.w #$0a1e,d1
0007fbf8        bsr.w L0007fd66
L0007fbfc        move.b $0007c87d,d0
0007fc02        cmp.b $0007c88b,d0
0007fc08        beq.b L0007fc18
0007fc0a        move.b d0,$0007c88b
0007fc10        move.w #$081e,d1
0007fc14        bsr.w L0007fd66
L0007fc18       move.l $0007c878,d0
0007fc1e        cmp.l $0007c87c,d0
0007fc24        bhi.w L0007fc76
0007fc28        moveq #$00,d0
0007fc2a        move.b $0007c87f,d0
0007fc30        cmp.b $0007c87b,d0
0007fc36        beq.b L0007fc40
0007fc38        move.w #$0c0e,d1
0007fc3c        bsr.w L0007fd66
L0007fc40       move.b $0007c87e,d0
0007fc46        cmp.b $0007c87a,d0
0007fc4c        beq.b L0007fc56
0007fc4e        move.w #$0a0e,d1
0007fc52        bsr.w L0007fd66
L0007fc56       move.b $0007c87d,d0
0007fc5c        cmp.b $0007c879,d0
0007fc62        beq.b L0007fc6c
0007fc64        move.w #$080e,d1
0007fc68        bsr.w L0007fd66
L0007fc6c       move.l $0007c87c,$0007c878
L0007fc76       rts



L0007fc78       move.w d0,clock_timer               ; d0 = clock timer value (minutes and seconds) in BCD format $0007c884                 ; L0007fc78
0007fc7e        move.w #$0032,frame_tick            ; set frame_tick to 50, $0007c880       - 0007fc7e
0007fc86        bsr.w L0007fd28                     ; 0007fc86
0007fc8a        clr.w $0007c882                     ; 0007fc8a
0007fc90        clr.b L0007c874                     ; clear status byte 1                   - 0007fc90
0007fc96        rts                                 ; 0007fc96






                ;--------------------- update panel --------------------------
                ; called every frame from $7c800 update_panel
                ;
do_panel_update                                     ; original routine address
                bsr.w update_hit_damage             ; calls L0007fa7e,update energy loss / lives        - 0007fc98

0007fc9c        cmp.w #$9999,$0007c882              ; test value in 0007c882.w                          - 0007fc9c
0007fca4        beq.w L0007fd1a                     ; if = #$9999 then exit, jmp $7fd1a                 - 0007fca4

0007fca8        sub.w #$0001,frame_tick             ; subtract 1 from frame tick $0007c880              `- 0007fca8
0007fcb0        bpl.w L0007fcf6                     ; if (tick > 0) jmp 0007fcb0                        - 0007fcb0

.reset_frame_tick                                   ; else
0007fcb4        move.w #$0032,frame_tick            ; set tick to 50 $0007c880

0007fcbc        tst.w clock_timer                   ; test clock timer = 0 (minutes and seconds) $0007c884
0007fcc2        beq.w clock_timer_expired           ; if clock_timer = 0, jmp $0007fd1c

0007fcc6        lea.l clock_timer_update_value,a0   ; clock timer update value address
0007fccc        lea.l clock_timer_end,a1            ; clock timer end address $0007c886
0007fcd2        move.b #$10,ccr
0007fcd6        sbcd.b -(a0),-(a1)                  ; subtract BCD byte from word before timer from clock seconds
0007fcd8        sbcd.b -(a0),-(a1)                  ; subtract BCD byte from word before time from clock minutes

.check_minutes_decremented
0007fcda        move.b clock_timer_seconds,d0       ; d0 = timer seconds value $0007c885
0007fce0        and.b #$f0,d0                       ; d0 = mask least significant seconds digit
0007fce4        cmp.b #$90,d0                       ; if seconds value starts with '9' then minutes were decremented
0007fce8        bne.b .display_clock_timer_value    ; else continue to display clock_timer value $0007fcf2
.minutes_decremented
0007fcea        move.b #$59,clock_timer_seconds     ; set seconds from '99' to '59' for correct seconds value as BCD $7c885
.display_clock_timer_value
L0007fcf2       bsr.w L0007fd28

L0007fcf6       move.w #$000a,d0
0007fcfa        cmp.w #$0019,frame_tick                     ; compare frame tick to #$19 (25) $0007c880
0007fd02        beq.b   L0007fd12
0007fd04        cmp.w #$0032,frame_tick                     ; compare frame tick to #$32 (50) $0007c880
0007fd0c        bne.b L0007fd1a
0007fd0e        move.w #$000b,d0
L0007fd12       move.w #$1d19,d1
0007fd16        bsr.w L0007fde2
L0007fd1a       rts

clock_timer_expired                                         ; original routine address $0007fd1c
L0007fd1c       bset.b #$00,L0007c874                       ; set bit 0 of status byte 1 (clock timer expired = 00:00)
0007fd24        bra.w L0007fcf6


L0007fd28       moveq #$00,d0
0007fd2a        move.b clock_timer_seconds,d0               ;$0007c885,d0
0007fd30        move.w #$1f19,d1
0007fd34        bsr.w L0007fde2
0007fd38        move.b clock_timer_seconds                  ;$0007c885,d0
0007fd3e        lsr.b #$04,d0
0007fd40        move.w #$1e19,d1
0007fd44        bsr.w L0007fde2
0007fd48        move.b clock_timer_minutes,d0
0007fd4e        move.w #$1c19,d1
0007fd52        bsr.w L0007fde2
0007fd56        move.b clock_timer_minutes,d0
0007fd5c        lsr.b #$04,d0
0007fd5e        move.w #$1b19,d1
0007fd62        bra.w L0007fde2



L0007fd66       bsr.w L0007fd70          ; L0007fd66
0007fd6a        lsr.b #$04,d0
0007fd6c        sub.w #$0100,d1

L0007fd70       movem.l d0-d1,-(a7)
0007fd74        moveq #$00,d2
0007fd76        move.b d1,d2
0007fd78        lsr.w #$08,d1
0007fd7a        mulu.w #$0028,d2
0007fd7e        add.l #$0007c89a,d2
0007fd84        add.b d1,d2
0007fd86        movea.l d2,a0
0007fd88        and.b #$0f,d0
0007fd8c        bne.b L0007fd98
0007fd8e        movea.l #$0007f2d2,a1
0007fd94        bra.w L0007fda4 
L0007fd98       mulu.w #$0038,d0
0007fd9c        add.l #$0007f0a2,d0
0007fda2        movea.l d0,a1
L0007fda4       moveq #$03,d2
L0007fda6       move.b (a1),(a0)
0007fda8        move.b (a1,$0002),(a0,$0028)
0007fdae        move.b (a1,$0004),(a0,$0050)
0007fdb4        move.b (a1,$0006),(a0,$0078)
0007fdba        move.b (a1,$0008),(a0,$00a0)
0007fdc0        move.b (a1,$000a),(a0,$00c8)
0007fdc6        move.b (a1,$000c),(a0,$00f0)
0007fdcc        adda.l #$00000780,a0
0007fdd2        adda.l #$0000000e,a1
0007fdd8        dbf.w d2,L0007fda6
0007fddc        movem.l (a7)+,d0-d1
0007fde0        rts


L0007fde2       and.l #$0000ffff,d0
0007fde8        movem.l d0-d2,-(a7)
0007fdec        moveq #$00,d2
0007fdee        move.b d1,d2
0007fdf0        lsr.w #$08,d1
0007fdf2        mulu.w #$0028,d2
0007fdf6        add.l #$0007c89a,d2
0007fdfc        add.w d1,d2
0007fdfe        movea.l d2,a0
0007fe00        and.w #$000f,d0
0007fe04        add.w d0,d0
0007fe06        lea.l $0007fe6e,a2
0007fe0c        move.w (a2,d0.W,$00),d0
0007fe10        add.l #$0007f30a,d0
0007fe16        movea.l d0,a1
0007fe18        moveq #$03,d2
L0007fe1a       move.b (a1),(a0)
0007fe1c        move.b (a1,$0002),(a0,$0028)
0007fe22        move.b (a1,$0004),(a0,$0050)
0007fe28        move.b (a1,$0006),(a0,$0078)
0007fe2e        move.b (a1,$0008),(a0,$00a0)
0007fe34        move.b (a1,$000a),(a0,$00c8)
0007fe3a        move.b (a1,$000c),(a0,$00f0)
0007fe40        move.b (a1,$000e),(a0,$0118)
0007fe46        move.b (a1,$0010),(a0,$0140)
0007fe4c        move.b (a1,$0012),(a0,$0168)
0007fe52        move.b (a1,$0014),(a0,$0190)
0007fe58        adda.l #$00000780,a0
0007fe5e        adda.l #$00000016,a1
0007fe64        dbf.w d2,L0007fe1a
0007fe68        movem.l (a7)+,d0-d2
0007fe6c        rts 



                ;-------------------- more data ---------------------
0007fe6e 0370 0058                bchg.b d1,(a0,d0.W,$58) == $00fe976e [61]
0007fe72 00b0 0108 0160 01b8      or.l #$01080160,(a0,d0.W,$b8) == $00fe96ce (68020+) [00040040]
0007fe7a 0210 0268                and.b #$68,(a0) [23]
0007fe7e 02c0                     illegal
0007fe80 0318                     btst.b d1,(a0)+ [23]
0007fe82 0000 03c8                or.b #$c8,d0
0007fe86 6000 5581                bra.w #$5581 == $00085409 (T)
0007fe8a 1008                     illegal
0007fe8c 8258                     or.w (a0)+ [236b],d1
0007fe8e e648                     lsr.w #$03,d0
0007fe90 4e60                     move.l a0,usp
0007fe92 c130 9041                and.b d0,(a0,a1.W,$41) == $00feac39 [28]
0007fe96 5004                     addq.b #$08,d4
0007fe98 0008                     illegal
0007fe9a 0408                     illegal
0007fe9c 0801 c000                btst.l #$c000,d1
0007fea0 1000                     move.b d0,d0



0007fea2 0fc7                     bset.l d7,d7
0007fea4 d7b8 0040                add.l d3,$0040 [00fc0834]
0007fea8 0038 7800 0066           or.b #$00,$0066 [0c]
0007feae 6000 09aa                bra.w #$09aa == $0008085a (T)
0007feb2 cb6b fcca                and.w d5,(a3,-$0336) == $00fe83b8 [9b37]
0007feb6 4672 1e60                not.w (a2,d1.L[*8],$60) == $000c6223 (68020+)
0007feba 8929 8007                or.b d4,(a1,-$7ff9) == $00bf94e9
0007febe 526c 0c6c                addq.w #$01,(a4,$0c6c) == $000021c4 [aaaa]
0007fec2 0c6c 0c2e 4000           cmp.w #$0c2e,(a4,$4000) == $00005558 [aaaa]
0007fec8 4000                     negx.b d0
0007feca 07e8 11a0                bset.b d3,(a0,$11a0) == $00fea8b6 [00]
0007fece 0010 0027                or.b #$27,(a0) [23]
0007fed2 2c00                     move.l d0,d6
0007fed4 0042 4000                or.w #$4000,d2
0007fed8 491c                     [ chk.l (a4)+,d4 ]
0007feda f3b3                     illegal
0007fedc bbf9 0678 1462           cmpa.l $06781462,a5
0007fee2 c108                     abcd.b -(a0),-(a0)
0007fee4 1001                     move.b d1,d0
0007fee6 706c                     moveq #$6c,d0
0007fee8 0c6c 0c6c 6c16           cmp.w #$0c6c,(a4,$6c16) == $0000816e [0000]
0007feee c1e1                     muls.w -(a1) [9942],d0
0007fef0 e000                     asr.b #$08,d0
0007fef2 01c0                     bset.l d0,d0
0007fef4 4bc0                     illegal
0007fef6 003c 3c36                or.b #$3c36,ccr
0007fefa 0400 003c                sub.b #$3c,d0
0007fefe 3c00                     move.w d0,d6
0007ff00 0dff                     illegal
0007ff02 ffff                     illegal
0007ff04 fff9                     illegal
0007ff06 e628                     lsr.b d3,d0
0007ff08 5262                     addq.w #$01,-(a2) [1f11]
0007ff0a cd3b                     illegal
0007ff0c befe                     illegal
0007ff0e 7200                     moveq #$00,d1
0007ff10 0000 0000                or.b #$00,d0
0007ff14 0013 0000                or.b #$00,(a3) [4e]
0007ff18 1800                     move.b d0,d4
0007ff1a 0141                     bchg.l d0,d1



0007ff1c efe0                     illegal
0007ff1e 00c0                     illegal
0007ff20 000c                     illegal
0007ff22 6c00 0000                bge.w #$0000 == $0007ff24 (T)
0007ff26 0000 4ee7                or.b #$e7,d0
0007ff2a fdf7                     illegal
0007ff2c efc4 664a                [ bfins d6,d4 {25:10} ]
0007ff2e 664a                     bne.b #$4a == $0007ff7a (F)
0007ff30 5464                     addq.w #$02,-(a4) [0000]
0007ff32 85fb bfd9                divs.w (pc,a3.L[*8],$d9=$0007ff0d) == $010685fb (68020+) [0000],d2
0007ff36 0200 0000                and.b #$00,d0
0007ff3a 0000 0002                or.b #$02,d0
0007ff3e 0000 0000                or.b #$00,d0
0007ff42 0001 ffe0                or.b #$e0,d1
0007ff46 0000 0004                or.b #$04,d0
0007ff4a 3000                     move.w d0,d0
0007ff4c 0000 0000                or.b #$00,d0
0007ff50 40bf                     illegal
0007ff52 feba                     illegal
0007ff54 f7a8                     illegal
0007ff56 662a                     bne.b #$2a == $0007ff82 (F)
0007ff58 1860                     illegal
0007ff5a ffff                     illegal
0007ff5c ffff                     illegal
0007ff5e 6000 0000                bra.w #$0000 == $0007ff60 (T)
0007ff62 0000 0029                or.b #$29,d0
0007ff66 ffff                     illegal
0007ff68 8000                     or.b d0,d0
0007ff6a 0000 0f60                or.b #$60,d0
0007ff6e 000f                     illegal
0007ff70 fff9                     illegal
0007ff72 2000                     move.l d0,d0
0007ff74 0000 0000                or.b #$00,d0
0007ff78 06e7                     illegal
0007ff7a fe7a                     illegal
0007ff7c f386                     illegal
0007ff7e e618                     ror.b #$03,d0
0007ff80 2060                     movea.l -(a0) [40044e75],a0
0007ff82 0000 0000                or.b #$00,d0
0007ff86 0000 0000                or.b #$00,d0


0007ff8a 0000 0000                or.b #$00,d0
0007ff8e 0024 0000                or.b #$00,-(a4) [00]
0007ff92 001d bfc0                or.b #$c0,(a5)+ [00]
0007ff96 0004 2000                or.b #$00,d4
0007ff9a 0000 0000                or.b #$00,d0
0007ff9e 0000 0000                or.b #$00,d0
0007ffa2 0000 0000                or.b #$00,d0
0007ffa6 0604 2860                add.b #$60,d4
0007ffaa 0000 0000                or.b #$00,d0
0007ffae 0000 0000                or.b #$00,d0
0007ffb2 0000 0000                or.b #$00,d0
0007ffb6 0003 5000                or.b #$00,d3
0007ffba 0019 7f80                or.b #$80,(a1)+ [00]
0007ffbe 005b 0000                or.w #$0000,(a3)+ [4e75]
0007ffc2 0000 0000                or.b #$00,d0
0007ffc6 0000 0000                or.b #$00,d0
0007ffca 0000 0000                or.b #$00,d0
0007ffce 0614 2862                add.b #$62,(a4) [00]
0007ffd2 3e7d                     illegal
0007ffd4 fffe                     illegal
0007ffd6 ff80                     illegal
0007ffd8 0020 9200                or.b #$00,-(a0) [75]
0007ffdc 8413                     or.b (a3) [4e],d2
0007ffde fd40                     illegal
0007ffe0 0d00                     btst.l d6,d0
0007ffe2 0001 7f80                or.b #$80,d1
0007ffe6 064e                     illegal
0007ffe8 15ff                     illegal
0007ffea 4200                     clr.b d0
0007ffec 9208                     illegal
0007ffee 0003 ff7f                or.b #$7f,d3
0007fff2 ffbe                     illegal
0007fff4 7c4a                     moveq #$4a,d6
0007fff6 0614 2838                add.b #$38,(a4) [00]
0007fffa 0000 0000                or.b #$00,d0
0007fffe 0000 0000                or.b #$ff,d0
00080002 0000 00c0                or.b #$ff,d0
00080006 0276 00fc 0818           and.w #$ffff,(a6,a7.L[*8],$ff) == $0180172b (68020+)
0008000c 00fc                     illegal
0008000e 081a 00fc                btst.b #$ffff,(a2)+ [00]


