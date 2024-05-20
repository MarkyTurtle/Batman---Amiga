;-----------------------------------------------------------------------------------------------------------------------------
; A replacement loader for the game.
;-----------------------------------------------------------------------------------------------------------------------------



;---------- Includes ----------
              INCDIR        "include"
              INCLUDE       "hw.i"

              section       loader,code_c

kill_system
                bsr     init_system


realloc_loader
                lea    loaderstart,a0
                lea    loaderend,a1
                lea    $800,a2
realloc_loop
                move.w (a0)+,(a2)+
                move.w d0,COLOR00(a6)
                add.w  #1,d0
                cmp.l  a0,a1
                bne    realloc_loop
                jmp    $800

init_system                                                         ; original routine address $00001F26
                LEA.L   $00dff000,A6                                ; A6 = custom chip base address
                LEA.L   $00bfd100,A5                                ; A5 = CIAB PRB - used as base address to CIAB
                LEA.L   $00bfe101,A4                                ; A4 = CIAA PRB - used as base address to CIAA

                MOVE.L  #$00000000,D0

                MOVE.W  #$7fff,INTENA(A6)                           ; disable interrupts
                MOVE.W  #$1fff,DMACON(A6)                           ; disable DMA
                MOVE.W  #$7fff,INTENA(A6)                           ; disable interrupts again?

                ; enter supervisor mode
                LEA.L   .supervisor_trap(PC),A0                     ; A0 = address of supervisor trap $00001F58
                MOVE.L  A0,$00000080                                ; Set TRAP 0 vector
                MOVEA.L A7,A0                                       ; store stack pointer
                TRAP    #$00000000                                  ; do the trap (jmp to next instruction in supervisor mode)
                                                                    ; this trap never returns.

                ; enter supervisor mode
                ; D0.l = $00000000
.supervisor_trap                                                    ; original address $00001F58
                MOVEA.L A0,A7                                       ; restore the stack (i.e. rts return address etc)
                MOVE.W  #$0200,BPLCON0(A6)                          ; 0 bitplanes, COLOR_ON=1, low res
                MOVE.W  D0,BPLCON1(A6)                              ; clear delay/scroll registers
                MOVE.W  D0,BPLCON2(A6)                              ; reset sprite/bitplane priorities, genlock etc.
                MOVE.W  D0,COLOR00(A6)                              ; background colour = black
                MOVE.W  #$4000,DSKLEN(A6)                           ; disable disk DMA (as per h/w ref)
                MOVE.L  D0,BLTCON0(A6)                              ; clear BLTCON0 & BLTCON1
                MOVE.W  #$0041,BLTSIZE(A6)                          ; Perform 1 x 1 word blit (DMA off) bit odd.

                MOVE.W  #$8340,DMACON(A6)                           ; enable MASTER,BITPLANE,BLITTER DMA
                MOVE.W  #$7fff,ADKCON(A6)                           ; clear disk controller bits

                ; reset sprites positions
.reset_sprites
                MOVE.L  #$00000007,D1                               ; D1 = counter 7 + 1 (8 sprites)
                LEA.L   SPR0POS(A6),A0                              ; A0 = first sprite position
.reset_sprite_loop
                MOVE.W  D0,(A0)
                ADDA.L  #$00000008,A0                               ; next sprite pointer
                DBF.W   D1,.reset_sprite_loop                       ; reset next sprite position, $00001F8E

                ; silence audio
.reset_audio
                MOVE.L  #$00000003,D1                               ; D1 = counter 3 + 1 (4 audio channels)
                LEA.L   AUD0VOL(A6),A0                              ; A0 = channel 1 audio volume register.
.reset_audio_loop
                MOVE.W  D0,(A0)                                     ; set audio channel volume to 0
                LEA.L   $0010(A0),A0                                ; A0 = next channel audio volume address
                DBF.W   D1,.reset_audio_loop                        ; reset next audio channel volume, $00001F9C

                ; reset CIAA
                ; A4 = CIAA PRB - used as base address to CIAA
.reset_ciaa
                MOVE.B  #$7f,$0c00(A4)                              ; ICR = clear interrupts
                MOVE.B  D0,$0d00(A4)                                ; CRA = clear timer A control bits
                MOVE.B  D0,$0e00(A4)                                ; CRB = clear timer B control bits
                MOVE.B  D0,-$0100(A4)                               ; PRA = clear /LED /OVL (/OVL shouldn't be played with - ROM overlay in memory flag)
                MOVE.B  #$03,$0100(A4)                              ; DDRA = set /LED /OVL as output, set disk status as inputs (as the system intends)
                MOVE.B  D0,(A4)                                     ; PRB = set parallel data lines to 0
                MOVE.B  #$ff,$0200(A4)                              ; DDRB = set direction line to output

                ; reset CIAB
                ; A5 = CIAB PRB - used as base address to CIAB
.reset_ciab
                MOVE.B  #$7f,$0c00(A5)                              ; ICR = clear interrupts
                MOVE.B  D0,$0d00(A5)                                ; CRA = clear Timer A control bits
                MOVE.B  D0,$0e00(A5)                                ; CRB = clear Timer B control bits
                MOVE.B  #$c0,-$0100(A5)                             ; PRA = set keyboard serial /DTR /RTS lines
                MOVE.B  #$c0,$0100(A5)                              ; DDRA = set /DTR /RTS lines to output
                MOVE.B  #$ff,(A5)                                   ; PRB = deselect all drives & motor, /SIDE = Bottom, /DIR = outwards, 
                MOVE.B  #$ff,$0200(A5)                              ; DDRB = set drive control bits to output

                MOVE.W  #$ff00,POTGO(A6)                            ; Enable output for Paula Pins on Port 2 (9,5), Port 1 (9,5), set pins high
                MOVE.W  D0,JOYTEST(A6)                             ; D0.W = $DF90 (maybe a bug? D0.l is set above) write to all 4 joystick-mouse counters at once. (JOY0DAT, JOY1DAT)

.reset_drive_motors                
                ; switch drives off
                ; A5 = CIAB PRB - used as base address to CIAB
                OR.B    #$ff,(A5)                                   ; deselect disk drives 
                AND.B   #$87,(A5)                                   ; latch motors off on drives 0-3
                AND.B   #$87,(A5)                                   ; latch motors off on drivee 0-3
                OR.B    #$ff,(A5)                                   ; deselect disk drived

.reset_ciaa_timer_b
                ; A4 = CIAA PRB - used as base address to CIAA
                MOVE.B  #$f0,$0500(A4)                              ; Timer B Low Byte
                MOVE.B  #$37,$0600(A4)                              ; Timer B High Byte - 14320 clock ticks = approx 20ms 
                MOVE.B  #$11,$0e00(A4)                              ; Load, Start Timer B continuous mode.

.reset_ciab_timer_b
                ; A5 = CIAB PRB - used as base address to CIAB
                MOVE.B  #$91,$0500(A5)                              ; Timer B Low Byte
                MOVE.B  #$00,$0600(A5)                              ; Timer B High Byte - 145 clock ticks = approx 200us
                MOVE.B  #$00,$0e00(A5)                              ; CRB - clear control reg (Timer B) - not started. (think it's used to trigger a keyboard ack)

.enable_interrupts
                MOVE.W  #$7fff,INTREQ(A6)                           ; Clear Interrupt Request bits
.enable_ciaa_interrupts
                TST.B   $0c00(A4)                                   ; CIAA ICR - clear interrupt flags
                MOVE.B  #$8a,$0c00(A4)                              ; CIAA ICR - Enable SP (Keyboard), ALRM (TOD)
.enable_ciab_interrupts
                TST.B   $0c00(A5)                                   ; CIAB ICR - clear interrupt flags
                MOVE.B  #$93,$0c00(A5)                              ; CIAB ICR - Enable FLG (DSKINDEX), TB (TimerA), TA (TimerB)

.exit_init_system
                RTS 

  

loaderstart:
              lea   $800,a7
              move.w #$8210,DMACON(a6)
              lea    dosio(pc),a5
              ; panel.iff
              move.l #0,d0                              ; load file
              lea    filename1,a0
              lea    $7C7FC,a1
              lea    $60000,a2
              jsr    (a5)                               ; load file into memory

              tst.l  d0
              bne    load_error

              ; titleprg.iff
              move.l #0,d0                              ; load file
              lea    filename2,a0
              lea    $3FFC,a1
              lea    $60000,a2
              jsr    (a5)                               ; load file into memory

              tst.l  d0
              bne    load_error

              ; titlepic.iff
              move.l #0,d0                              ; load file
              lea    filename3,a0
              lea    $3F236,a1
              lea    $60000,a2
              jsr    (a5)                               ; load file into memory

              tst.l  d0
              bne    load_error

              move.w #$83ff,DMACON(a6)
              jmp    $1c000
              
load_success
              move.w #$0f0,COLOR00(a6)
              jmp    load_success

load_error
              move.w #$ffff,d7
error_loop
              move.w #$f00,COLOR00(a6)
              dbra   d7,error_loop
              jmp    loaderstart                        ; retry

              *	a0.l = full pathname of file, terminated with 0
              *	a1.l = file buffer (even word boundary)
              *		if d0.l=3 a1.l = ptr to file name buffer
              *	a2.l = workspace buffer ($4d00 bytes of CHIPmem required)


              even
filename1     dc.b   "panel.iff",0
              even
filename2     dc.b   "titleprg.iff",0
              even
filename3     dc.b   "titlepic.iff",0
              even


              INCDIR        "rnc/DosIO"
              INCLUDE       "DosIO.S"

loaderend: