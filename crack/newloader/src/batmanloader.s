;-----------------------------------------------------------------------------------------------------------------------------
; A replacement loader for the game.
;-----------------------------------------------------------------------------------------------------------------------------



;---------- Includes ----------
              INCDIR        "include"
              INCLUDE       "hw.i"

              section       loader,code_c

kill_system
                lea     $dff000,a6
                move.w  #$7fff,INTENA(a6)
                move.w  #$7fff,DMACON(a6)
                move.w  #$7fff,INTREQ(a6)   

realloc_loader
                lea     loaderstart,a0
                lea     loaderend,a1
                lea     $800,a2
realloc_loop
                move.w  (a0)+,(a2)+
                move.w  d0,COLOR00(a6)
                add.w   #1,d0
                cmp.l   a0,a1
                bne     realloc_loop
                jmp     $800


            ;-------------------- loader start -------------------
            ; entry point of relocated loader at address $800.l
            ; contains jump table as expected by the game to 
            ; load each game seciton

loaderstart:
                bra.b jump_table                                    ; Calls $0000081C - jmp_load_screen (addr: $00000800)
                                                                    ; This will get overwritten by the stack during loading

unused_globals_1
                dc.w    $0000, $22BA, $0000, $0000                  ; Unused memory, the stack will grown down over this.
                dc.w    $0000, $0000, $0000, $0000                  ; 
                dc.w    $0000, $0000, $0000, $0000                  ;
                dc.w    $0000                                       ;

stack                                                               ; Top of Loader Stack, (re)set each time a game section is loaded. (addr:$0000081C) 
jump_table                                                          ; Start of jump table for loading and executing the game sections. (original addr:$0000081C)
                bra.w  load_loading_screen                          ; Calls $00000838 - Load Loading Screen (instruction addr:$0000081C)
                bra.w  load_title_screen2                           ; Calls $00000948 - Load Title Screen2  (instruction addr:$00000820)
                bra.w  load_level_1                                 ; Calls $000009C8 - Load Level 1 - Axis Chemicals (instruction addr:$00000824)
;                bra.w  load_level_2                                 ; Calls $00000A78 - Load Level 2 - Bat Mobile (instruction addr:$00000829)
;                bra.w  load_level_3                                 ; Calls $00000B28 - Load Level 3 - Bat Cave Puzzle (instruction addr:$0000082C)
;                bra.w  load_level_4                                 ; Calls $00000B90 - Load Level 4 - Batwing Parade (instruction addr:$00000830)
;                bra.w  load_level_5                                 ; Calls $00000C40 - Load Level 5 - Cathedral (instruction addr:$00000834)



                ;----------- load title screen & loading screen ------------
load_loading_screen
                lea     stack(pc),a7
                bsr     init_system
                lea     $dff000,a6    
                move.w  #$8370,DMACON(a6)
.retryload
                move.w  #$fff,COLOR00(a6)  
                lea     dosio(pc),a5
                
                ; panel.iff
                lea     $3f000,a7                         ; set stack
                moveq.l #$00,d0                           ; load file
                lea     .filename1,a0
                lea     $5d000,a1                         ; load address
                lea     $20000,a2                         ; track buffers
                jsr     (a5)                              ; load file into memory
                tst.l   d0
                bne     .load_error

                ; decompress file
                lea     $5d000,a0                         ; compressed data
                lea     $7c7fc,a1                         ; decompressed buffer
                lea     $0,a2
                lea     $0,a3
                moveq.l #$00,d2
                moveq.l #$01,d7
                bsr     ShrinklerDecompress

                move.w  #$0f0,COLOR00(a6)

                ; titleprg.iff
                lea     $3f000,a7                         ; set stack
                moveq.l #$00,d0                           ; load file
                lea    .filename2,a0
                lea    $5d000,a1                          ; load address
                lea    $20000,a2                          ; track buffers
                jsr    (a5)                               ; load file into memory
                tst.l   d0
                bne     .load_error

                ; decompress file
                lea     $5d000,a0                         ; compressed data
                lea     $3FFC,a1                          ; decompressed buffer
                lea     $0,a2
                lea     $0,a3
                moveq.l #$00,d2
                moveq.l #$01,d7
                bsr     ShrinklerDecompress

                move.w  #$00f,COLOR00(a6)

                ; titlepic.iff
                lea     $3f000,a7                         ; set stack                
                moveq.l #$00,d0                           ; load file
                lea     .filename3,a0
                lea     $5d000,a1                         ; load address
                lea     $20000,a2                         ; track buffers
                jsr     (a5)                              ; load file into memory

                tst.l   d0
                bne     .load_error

                ; decompress file
                lea     $5d000,a0                         ; compressed data
                lea     $3F236,a1                         ; decompressed buffer
                lea     $0,a2
                lea     $0,a3
                moveq.l #$00,d2
                moveq.l #$01,d7
                bsr     ShrinklerDecompress

                lea     stack(pc),a7
                move.w  #$83ff,DMACON(a6)
                jmp     $1c000
              
.load_error
                move.w  #$ffff,d7
.error_loop
                move.w  #$f00,COLOR00(a6)
                dbra    d7,.error_loop
                jmp     .retryload                        ; retry

.filename1      dc.b   "panel.iff",0
.filename2      dc.b   "titleprg.iff",0
.filename3      dc.b   "titlepic.iff",0
                even




                ;----------- load title screen after game end ------------
load_title_screen2:
                lea     stack(pc),a7
                bsr     init_system
                lea     $dff000,a6    
                move.w  #$8370,DMACON(a6)
.retryload
                move.w  #$fff,COLOR00(a6)  
                lea     dosio(pc),a5
                
                ; panel.iff
                move.l  #0,d0                              ; load file
                lea     .filename1,a0
                lea     $7C7FC,a1
                lea     $60000,a2
                jsr     (a5)                               ; load file into memory
                tst.l   d0
                bne     .load_error

                move.w  #$0f0,COLOR00(a6)

                ; titleprg.iff
                move.l #0,d0                              ; load file
                lea    .filename2,a0
                lea    $3FFC,a1
                lea    $60000,a2
                jsr    (a5)                               ; load file into memory
                tst.l   d0
                bne     .load_error

                move.w  #$00f,COLOR00(a6)

                ; titlepic.iff
                move.l  #0,d0                              ; load file
                lea     .filename3,a0
                lea     $3F236,a1
                lea     $60000,a2
                jsr     (a5)                               ; load file into memory

                tst.l   d0
                bne     .load_error

                lea     stack(pc),a7
                move.w  #$83ff,DMACON(a6)
                jmp     $1c004
              
.load_error
                move.w  #$ffff,d7
.error_loop
                move.w  #$f00,COLOR00(a6)
                dbra    d7,.error_loop
                jmp     .retryload                        ; retry

.filename1      dc.b   "panel.iff",0
.filename2      dc.b   "titleprg.iff",0
.filename3      dc.b   "titlepic.iff",0
                even








                ;----------- load level 1 ------------
load_level_1
                lea     stack(pc),a7
                bsr     init_system
                lea     $dff000,a6    
                move.w  #$8370,DMACON(a6)
.retryload
                move.w  #$fff,COLOR00(a6)  
                lea     dosio(pc),a5
                
                ; code1.iff
                move.l  #0,d0                              ; load file
                lea     .filename1,a0
                lea     $2FFC,a1
                lea     $60000,a2
                jsr     (a5)                               ; load file into memory
                tst.l   d0
                bne     .load_error

                move.w  #$0f0,COLOR00(a6)

                ; mapgr.iff
                move.l  #0,d0                              ; load file
                lea     .filename2,a0
                lea     $7FFC,a1
                lea     $60000,a2
                jsr     (a5)                               ; load file into memory
                tst.l   d0
                bne     .load_error

                move.w  #$00f,COLOR00(a6)

                ; batspr1.iff
                move.l  #0,d0                              ; load file
                lea     .filename3,a0
                lea     $10FFC,a1
                lea     $60000,a2
                jsr     (a5)                               ; load file into memory
                tst.l   d0
                bne     .load_error

                move.w  #$0ff,COLOR00(a6)

                ; chem.iff
                move.l  #0,d0                              ; load file
                lea     .filename4,a0
                lea     $47FE4,a1
                lea     $60000,a2
                jsr     (a5)                               ; load file into memory
                tst.l   d0
                bne     .load_error

                move.w  #$fff,COLOR00(a6)

                lea     stack(pc),a7
                move.w  #$83ff,DMACON(a6)
                jmp     $3000
              
.load_error
                move.w  #$ffff,d7
.error_loop
                move.w  #$f00,COLOR00(a6)
                dbra    d7,.error_loop
                jmp     .retryload                        ; retry


.filename1      dc.b    "code1.iff",0                             ; CODE1   IFF       - $43,$4F,$44,$45,$31,$20,$20,$20,$49,$46,$46
.filename2      dc.b    "mapgr.iff",0                             ; MAPGR   IFF       - $4D,$41,$50,$47,$52,$20,$20,$20,$49,$46,$46
.filename3      dc.b    "batspr1.iff",0                           ; BATSPR1 IFF       - $42,$41,$54,$53,$50,$52,$31,$20,$49,$46,$46
.filename4      dc.B    "chem.iff",0                              ; CHEM    IFF       - $43,$48,$45,$4D,$20,$20,$20,$20,$49,$46,$46                                     ;M    IFF
                even




                ;------------------ init system -------------------------
                ; kill system taken from the original loader with a
                ; few modifications (i.e. no CIA timers set up and a
                ; generic interrupt handler installed)
init_system                                                         ; original routine address $00001F26
                lea     $00dff000,A6                                ; A6 = custom chip base address
                lea     $00bfd100,A5                                ; A5 = CIAB PRB - used as base address to CIAB
                lea     $00bfe101,A4                                ; A4 = CIAA PRB - used as base address to CIAA

                moveq.l #$00,D0

                move.w  #$7fff,INTENA(A6)                           ; disable interrupts
                move.w  #$1fff,DMACON(A6)                           ; disable DMA
                move.w  #$7fff,INTENA(A6)                           ; disable interrupts again?

                ; enter supervisor mode
                lea.l   .supervisor_trap(PC),A0                     ; A0 = address of supervisor trap $00001F58
                move.l  A0,$00000080                                ; Set TRAP 0 vector
                movea.l A7,A0                                       ; store stack pointer
                trap    #$00                                        ; do the trap (jmp to next instruction in supervisor mode)
                                                                    ; this trap never returns.

                ; enter supervisor mode
                ; D0.l = $00000000
.supervisor_trap                                                    ; original address $00001F58
                movea.l A0,A7                                       ; restore the stack (i.e. rts return address etc)
                move.w  #$0200,BPLCON0(A6)                          ; 0 bitplanes, COLOR_ON=1, low res
                move.w  D0,BPLCON1(A6)                              ; clear delay/scroll registers
                move.w  D0,BPLCON2(A6)                              ; reset sprite/bitplane priorities, genlock etc.
                move.w  D0,COLOR00(A6)                              ; background colour = black
                move.w  #$4000,DSKLEN(A6)                           ; disable disk DMA (as per h/w ref)
                move.l  D0,BLTCON0(A6)                              ; clear BLTCON0 & BLTCON1
                move.w  #$0041,BLTSIZE(A6)                          ; Perform 1 x 1 word blit (DMA off) bit odd.

                move.w  #$8340,DMACON(A6)                           ; enable MASTER,BITPLANE,BLITTER DMA
                move.w  #$7fff,ADKCON(A6)                           ; clear disk controller bits

                ; reset sprites positions
.reset_sprites
                moveq.l #$07,D1                                     ; D1 = counter 7 + 1 (8 sprites)
                lea.l   SPR0POS(A6),A0                              ; A0 = first sprite position
.reset_sprite_loop
                move.w  D0,(A0)
                addq.l #$08,A0                                      ; next sprite pointer
                dbf.w  D1,.reset_sprite_loop                       ; reset next sprite position, $00001F8E

                ; silence audio
.reset_audio
                moveq.l  #$03,D1                                    ; D1 = counter 3 + 1 (4 audio channels)
                lea.l    AUD0VOL(A6),A0                              ; A0 = channel 1 audio volume register.
.reset_audio_loop
                move.w  D0,(A0)                                     ; set audio channel volume to 0
                lea.l   $0010(A0),A0                                ; A0 = next channel audio volume address
                dbf.w   D1,.reset_audio_loop                        ; reset next audio channel volume, $00001F9C

                ; reset CIAA
                ; A4 = CIAA PRB - used as base address to CIAA
.reset_ciaa
                move.b  #$7f,$0c00(A4)                              ; ICR = clear interrupts
                move.b  D0,$0d00(A4)                                ; CRA = clear timer A control bits
                move.b  D0,$0e00(A4)                                ; CRB = clear timer B control bits
                move.b  D0,-$0100(A4)                               ; PRA = clear /LED /OVL (/OVL shouldn't be played with - ROM overlay in memory flag)
                move.b  #$03,$0100(A4)                              ; DDRA = set /LED /OVL as output, set disk status as inputs (as the system intends)
                move.b  D0,(A4)                                     ; PRB = set parallel data lines to 0
                move.b  #$ff,$0200(A4)                              ; DDRB = set direction line to output

                ; reset CIAB
                ; A5 = CIAB PRB - used as base address to CIAB
.reset_ciab
                move.b  #$7f,$0c00(A5)                              ; ICR = clear interrupts
                move.b  D0,$0d00(A5)                                ; CRA = clear Timer A control bits
                move.b  D0,$0e00(A5)                                ; CRB = clear Timer B control bits
                move.b  #$c0,-$0100(A5)                             ; PRA = set keyboard serial /DTR /RTS lines
                move.b  #$c0,$0100(A5)                              ; DDRA = set /DTR /RTS lines to output
                move.b  #$ff,(A5)                                   ; PRB = deselect all drives & motor, /SIDE = Bottom, /DIR = outwards, 
                move.b  #$ff,$0200(A5)                              ; DDRB = set drive control bits to output
.set_exceptions
                lea     interrupt_handler(pc),a0
                move.l  a0,$64
                move.l  a0,$68
                move.l  a0,$6C
                move.l  a0,$70
                move.l  a0,$74
                move.l  a0,$78
 
.joy_test
                move.w  #$ff00,POTGO(A6)                            ; Enable output for Paula Pins on Port 2 (9,5), Port 1 (9,5), set pins high
                move.w  D0,JOYTEST(A6)                             ; D0.W = $DF90 (maybe a bug? D0.l is set above) write to all 4 joystick-mouse counters at once. (JOY0DAT, JOY1DAT)

.reset_drive_motors                
                ; switch drives off
                ; A5 = CIAB PRB - used as base address to CIAB
                or.b    #$ff,(A5)                                   ; deselect disk drives 
                and.b   #$87,(A5)                                   ; latch motors off on drives 0-3
                and.b   #$87,(A5)                                   ; latch motors off on drivee 0-3
                or.b    #$ff,(A5)                                   ; deselect disk drived

.enable_interrupts
                move.w  #$7fff,INTREQ(A6)                           ; Clear Interrupt Request bits
.enable_ciaa_interrupts
                tst.b   $0c00(A4)                                   ; CIAA ICR - clear interrupt flags
.enable_ciab_interrupts
                tst.b   $0c00(A5)                                   ; CIAB ICR - clear interrupt flags
.exit_init_system
                move.w  #$e078,INTENA(a6)
                move.w  #$2000,sr
                rts


                ;------------- interrupt handler ------------------
                ; just clear any raised interrupt flags and exit
interrupt_handler
                movem.l d0-d7/a0-a6,-(a7)
                lea     $dff000,a6
                move.w  #$7fff,INTREQ(a6)
                movem.l (a7)+,d0-d7/a0-a6
                rte



              *	a0.l = full pathname of file, terminated with 0
              *	a1.l = file buffer (even word boundary)
              *		if d0.l=3 a1.l = ptr to file name buffer
              *	a2.l = workspace buffer ($4d00 bytes of CHIPmem required)
              INCDIR        "rnc/dosio"
              INCLUDE       "dosio.s"


; Decompress Shrinkler-compressed data produced with the --data option.
;
; A0 = Compressed data
; A1 = Decompressed data destination
; A2 = Progress callback, can be zero if no callback is desired.
;      Callback will be called continuously with
;      D0 = Number of bytes decompressed so far
;      A0 = Callback argument
;      D1 = Second callback argument
; A3 = Callback argument
; D2 = Second callback argument
; D7 = 0 to disable parity context (Shrinkler --bytes / -b option)
;      1 to enable parity context (default Shrinkler compression)
;
; Uses 3 kilobytes of space on the stack.
; Preserves D2-D7/A2-A6 and assumes callback does the same.
;
; Decompression code may read one byte beyond compressed data.
; The contents of this byte does not matter.

;ShrinklerDecompress:
            INCDIR        "shrinkler"
            INCLUDE       "ShrinklerDecompress.S"

loaderend: