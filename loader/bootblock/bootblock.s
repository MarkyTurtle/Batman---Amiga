              
; Overview:
;
;       1) Initialises the System, and Resets Disk Registers
;
;       2) Relocates itself to address $400
;  
;       3) Loads track 0 into memory at $800 to get file table
;               a) The Filetable is located at $c00
;                    - Entry 1 = 16 bytes Disk Name
;                    - Entry 2 - 13 = File Entries (11 char name, 3 byte length, 2 byte start sector)
;                       00000C00 4241 544D 414E 204D 4F56 4945 2020 2030  BATMAN MOVIE   0
;                       00000C10 4241 544D 414E 2020 2020 2000 22DA 0016  BATMAN     ."...
;                       00000C20 4C4F 4144 494E 4720 4946 4600 A0D6 0028  LOADING IFF....(
;                       00000C30 5041 4E45 4C20 2020 4946 4600 289E 0079  PANEL   IFF.(..y
;                       00000C40 5449 544C 4550 5247 4946 4601 63A0 008E  TITLEPRGIFF.c...
;                       00000C50 5449 544C 4550 4943 4946 4600 CCF6 0140  TITLEPICIFF....@
;                       00000C60 434F 4445 3120 2020 4946 4600 37BE 01A7  CODE1   IFF.7...
;                       00000C70 4D41 5047 5220 2020 4946 4600 5620 01C3  MAPGR   IFF.V ..
;                       00000C80 434F 4445 3520 2020 4946 4600 3A86 01EF  CODE5   IFF.:...
;                       00000C90 4D41 5047 5232 2020 4946 4600 530C 020D  MAPGR2  IFF.S...
;                       00000CA0 4241 5453 5052 3120 4946 4600 C4B6 0237  BATSPR1 IFF....7
;                       00000CB0 4348 454D 2020 2020 4946 4600 F6C6 029A  CHEM    IFF.....
;                       00000CC0 4348 5552 4348 2020 4946 4600 D904 0316  CHURCH  IFF.....
;
;       4) The main game loader 'BATMAN' is then located from the table and loaded to $800
;
;       5) The file start address is pushed to the stack so RTS continues execution of 'BATMAN' game loader
;



                section bootblock,code



                ;--------------------- includes and constants ---------------------------
                INCDIR      "include"
                INCLUDE     "hw.i"
                

CIABPRB  EQU $BFD100           ;CIAB - PRB Register used as a base address - DISK CONTROL & TIMERS
CIAAPRB  EQU $BFE101           ;CIAA - PRB Register used as a base address - DISK STATUS & TIMERS 





                ; -------------------- test bootblock code -------------------------------
                ; allow the bootblock to be executed/debugged from vscode.
                ; conditional code to kill the system and wait for mouse press before
                ; executing the original boot block code.

TESTBOOT SET 1                                          ; Comment this to remove 'testboot'

        IFD TESTBOOT  

testboot:       lea.l   CUSTOM,A6
                move.w  #$7fff,INTENA(a6)
                move.w  #$7fff,DMACON(a6)
                move.w  #$7fff,INTREQ(a6)
                moveq   #$0,d0

.mousewait      addq    #$1,d0
                move.w  d0,COLOR00(a6)                  ; flashy screen while waiting
                btst    #$6,$bfe001
                bne.s   .mousewait                      ; wait for left mouse, time to insert Batman Disk 1
                jmp bootcode
        
        ENDC
        






                ;-------------------- bootblock header structure ------------------------- 
bootblockheader:
                dc.l      "DOS"<<8                      ; DiskType
                dc.l      0                             ; original checksum = $D1E6DA12 
                dc.l      $370                          ; Rootblock = 880 (on a standard dos disk)




                ;-------------------- bootblock code entry point  ------------------------            
bootcode:       bra.b initboot




                ;----------------------- copy memory routine ------------------------------
                ; relocate the boot loader and continue execution from 'relocatedboot:' 
copymemory:     move.w  (A0)+,(A1)+
                sub.l   #$00000001,D0
                bne.b   copymemory
                jmp     $000004ba                       ; Execute relocated code @relocatedboot:  




                ;-------------- Initialise the System & Relocate Boot Loader --------------
initboot:
                lea.l   CUSTOM,A6                       ; Custom chips base
                lea.l   CIABPRB,A5                      ; CIAB Base Address, referenced from the PRB register
                lea.l   CIAAPRB,A4                      ; CIAA Base Address, referenced from the PRB register

                move.l  #$00000000,D0
                move.l  #$ffffffff,D1

                move.w  #$7fff,INTENA(a6)               ; Disable Interrupts
                move.w  #$1fff,DMACON(A6)               ; Disable DMA 
                move.w  #$4000,DSKLEN(A6)               ; Disable Disk DMA (as per H/W Ref)

                move.w  #$0200,BPLCON0(A6)              ; Disable Bitplanes, COLOR_ON = 1
                move.w  D0,COLOR00(A6)                  ; Black Background

                move.l  D0,BLTCON0(A6)                  ; BLTCON0 - clear minterms, BLTCON1 - Clear all bits
                move.w  #$0041,BLTSIZE(A6)              ; Blit size - 1 word

                move.w  #$8240,DMACON(A6)               ; Enable MASTER|BLITTER DMA

                move.b  #$7f,$0C00(A4)                  ; CIAA ICR - Clear Interrupts 
                move.b  #$7f,$0C00(A5)                  ; CIAB ICR - Clear Interrupts

                MOVE.B  D0,$0D00(A4)                    ; CIAA CRA - Clear Control Register A
                MOVE.B  D0,$0E00(A4)                    ; CIAA CRB - Clear Control Register B
                MOVE.B  D0,$0D00(A5)                    ; CIAB CRA - Clear Control Register A
                MOVE.B  D0,$0E00(A5)                    ; CIAB CRB - Clear Control Register B
                MOVE.B  D0,-$0100(A4)                   ; CIAA PRA - Clear Port A Data (LED & OVL) 
                MOVE.B  #$03,$0100(A4)                  ; CIAA DDRA - Set Data Direction Port A (#$03 = OS Default - LED & OVL output, disk status bits and buttons inputs)
                MOVE.B  D0,(A4)                         ; CIAA PRB - Clear Parallel port data (#$ff = all parallel pins output)
                MOVE.B  D1,$0200(A4)                    ; CIAA DDRB - Set Data Direction Port B ()

                MOVE.B  #$c0,-$0100(A5)                 ; CIAB PRA - Set Port A Data (DTR & RTS) - Keyboard Serial Port
                MOVE.B  #$c0,$0100(A5)                  ; CIAB DDRA - Set Data Direction Port A (DTR & RTS = output)
                MOVE.B  D1,(A5)                         ; CIAB PRB - Set Port B Data (Disk Control - Active Low)
                MOVE.B  D1,$0200(A5)                    ; CIAB DDRB - Set Port B Data (#$ff = all output)

                ; Relocate the 'copymemory' routine (above) to $40E in memory
                LEA.L   copymemory(PC),A0
                LEA.L   $0000040e,A1
                MOVE.L  #$00000004,D0
.copyloop       MOVE.W (A0)+,(A1)+
                DBF.W   D0,.copyloop

                ; Set up parameters for the relocated copy memory routine.
                ; which will relocate the 'initboot' to $418 in memory
                ; The address $418 in memory is directly after the relocated 'copymemory' routine
                ; The jmp to $4ba after the copy will continue execution at the 'relocatedboot' code below.
                LEA.L initboot(PC),A0                   ; Mem Copy Source
                LEA.L $00000418,A1                      ; Mem Copy Destination
                MOVE.L #$000001f4,D0                    ; Memcopy Length + 1 (Words) = 1002 bytes
                JMP $0000040e                           ; jump to relocated copy routine to relocate bootblock code,
                                                        ; continues execution at 'relocatedboot' code below after copy $4ba

                ;------------- end of - Kill System & Relocate Boot Loader --------------






                ;----------------------- relocated boot loader --------------------------     
                ; code relocated by the 'copymemory' routine
                ; jmp to 000004ba continues execution here.
relocatedboot:
                LEA.L $0007c000,A7                      ;Set Stack 16K from top of memory

                LEA.L level6Handler(PC),A0              ; Address of Level 6 Interruipt Handler
                MOVE.L A0,$00000078                     ; Level 6 Interrupt Vector - CIAB Level 6 (DiskIndex & Timers)
                MOVE.W #$7fff,INTREQ(A6)                ; Clear Interrupt Request Bits
                TST.B $0C00(A5)                         ; CIAB ICR - Clear Interrupt Flags by reading

                MOVE.B #$83,$0C00(A5)                   ; CIAB ICR - Enable Timer A & Timer B Interrupts
                MOVE.W #$e000,INTENA(A6)                ; Enable Interrupts - EXTER - CIAB Level 6 Interrupts        
                OR.B #$ff,(A5)                          ; CIAB - Deselect Drive - Motor, Drives, Select Lower Head, Direction Ouutwards 
                AND.B #$7f,(A5)                         ; CIAB - Motor On (active low)
                AND.B #$f7,(A5)                         ; CIAB - Motor On (latched when drive selected), Drive 0 Select (active low)
                                                        ; h/w ref specifies a 500ms wait, or DSKRDY signal, not happening though.

                BSR.W headstotrack0                     ; Step Drive Heads to Track 0

                MOVE.L #$00000000,D0                    ; Target Track
                LEA.L $00000800,A0                      ; Decoded Read Buffer
                BSR.B readdisk

                ; Read Game Loader details from File Table
                ; Filetable address = $C00
                ; Loader File Entry = $C10 (11 chars filename, 3 bytes file len, 2 byte start sector)
                MOVE.W $041E(A0),D0                     ; D0 = start sector (address = $C1E, Value = #$16 (sector 22 = track 3)
                MOVE.L #$00ffffff,D1                    ; 24 bit mask
                AND.L $041A(A0),D1                      ; D1 = 24 bit file length (address = $C1A, Value = #$22DA)
                DIVU.W #$0200,D1                        ; D1 = Divide Length by Sector Size (512)

                ADD.W D0,D1                             ; D1 = Add Start Sector to find last sector number to read in D1
                EXT.L D0                                ; D0 = Sign extend start sector to clear crap out of high word
                DIVU.W #$000b,D0                        ; D0 = Divide start sector number by 11 sectors per track to find start track
                MOVE.L D0,D2                            ; D2 = Start Track to Read
                SWAP.W D2                               ; Get Remainder Value (start sector in track) 
                MULU.W #$0200,D2                        ; Multiply remainder by Sector Size (512)

                PEA.L $0000(A0,D2)                      ; Push Start of file address Offset onto the stack 
                                                        ;   - RTS Return Address below

                EXT.L D1                                ; D1 = Sign Extend Last Sector Number to clear crap out of high word
                DIVU.W #$000b,D1                        ; D1 = Divide Last Sector Number by 11 Sectors per track
                SUB.W D0,D1                             ; D1 = Last Track - First Track = Number of Tracks to Read

                ; D2 = Start Track
                ; D1 = Number of Tracks + 1
                ; (A7) = RTS return address
.loadloop       
                BSR.B readdisk 
                ADDA.W #$1600,A0                        ; Increment Decoded Load Address Buffer (5K per track read)
                ADD.W #$00000001,D0                     ; Increment Current Track Number
                DBF.W D1,.loadloop

                OR.B #$ff,(A5)                          ; CIAB PRB - Deselect Motor, Deselect Drives
                AND.B #$f7,(A5)                         ; CIAB PRB - Select Drive 0 (latch motor off)
                OR.B #$ff,(A5)                          ; CIAB PRB - Deselect Motor, Deselect Drives

                MOVE.W #$0f00,COLOR00(A6)               ; Set Background colour to RED
                MOVE.W #$7fff,INTENA(A6)                ; Disable Interrupts

                RTS                                     ; Return to address at top of stack (start of file loaded from disk)
                                                        ; Continue Execution at $800 - loaded game loader file 'BATMAN'





                ;----------------------------- read disk -------------------------------
                ; -- IN: D0.l - Target Track
                ; -- IN: A0.l - Decoded Data Buffer
readdisk:
                MOVEM.L D1/A0-A1,-(A7)
.restart        MOVE.L #$00000007,D6                    ; Loop Counter (8 times)

.waitdskrdy     BTST.B #$0005,-$0100(A4)                ; CIAA PRA - Test DSKRDY (disk ready) bit
                BNE.B .waitdskrdy                       ; Active Low DSKRDY signal

                BSR.B stepheadstotrack                  ; Step Heads to Track (D7.w = Current Track, D0.w = Target Track)

.retry          LEA.L $0007c000,A0                      ; MFM Track Buffer
                BSR.W readtrack

                LEA.L $0007c000,A0                      ; MFM Track Buffer
                MOVEA.L $0004(A7),A1                    ; Decoded Buffer Address (from saved A0 on stack)
                BSR.W decodemfmbuffer                   ; A0 = MFM Track Buffer, A1 = Decoded Destination Buffer

                BEQ.B L003017C
                DBF.W D6,.retry

                BSR.B headstotrack0                     ; Step Heads to Track 0
                BRA.B .restart

L003017C        MOVEM.L (A7)+,D1/A0-A1
                RTS 




                ;------------- heads to track 0 ----------------
                ;-- step the drive heads to track 0           --
headstotrack0:
                MOVE.L D0,-(A7)
                MOVE.W #$00a6,D7                        ; Set high current track number
                CLR.W D0                                ; Clear Target Track Number
                BSR.B stepheadstotrack                  ; Step the drive heads to Target Track                              
                MOVE.L (A7)+,D0
                RTS 




                ; ----------- step heads to track ----------------
                ; --- IN: D7.w = current track
                ; --- IN: D0.w = target track
                ; --- OUT: Z = 1 if success.
stepheadstotrack:
                BSET.B #$0002,(A5)                      ; CIAB PRA - Set Disk Side Bit, 1 = lower head 
                BCLR.L #$0000,D7                        ; set current track to even number 
                BTST.L #$0000,D0                        ; Is the target track an odd number?
                BEQ.B .isalreadythere                   ; No.. 
.targettrackisodd                                       ; yes..
                BCLR.B #$0002,(A5)                      ; CIAB PRA - Set Disk Side Bit. 0 = upper head
                BSET.L #$0000,D7                        ; set current track to an odd number
.isalreadythere
                CMP.W D7,D0                             ; Test if 'Current Track' == 'Target Track'
                BEQ.B .exit                             ; 'current track' - 'target track' == 0 then exit
                BPL.B .stepinwards                      ; 'current track' - 'target track'  > 0 then step inwards
                                                        ; 'current track' - 'target track'  < 0 then step outwards
.stepoutwards
                BSET.B #$0001,(A5)                      ; CIAB PRB - Set DIR = 1 (step outwards)
.stepoutloop                       
                BTST.B #$0004,-$0100(A4)                ; CIAA PRA - Test TK0 (track 0)
                BEQ.B .attrack0
                BSR.B stepheads
                SUB.W #$00000002,D7                     ; 1 cylinder = 2 tracks per step (top & bottom)
                CMP.W D7,D0                             ; does 'current track' == 'target track'
                BNE.B .stepoutloop                      ; No.. step again.
                BRA.B .endsteptotrack                   ; yes.. end step loop

.stepinwards      
                BCLR.B #$0001,(A5)                      ; CIAB PRB - Set DIR = 0 (step inward)
.stepinloop     BSR.B stepheads
                ADD.W #$00000002,D7                     ; 1 cylinder = 2 tracks per step (top & bottom)
                CMP.W D7,D0                             ; does 'current track' == 'target track'
                BNE.B .stepinloop                       ; No.. step again
                BRA.B .endsteptotrack                   ; Yes.. end step loop

.attrack0       CLR.W D7                                ; at track 0 - Set Current Track to 0

.endsteptotrack     
                MOVE.B #$f4,$0300(A5)                   ; Set Timer A Low Byte = #$F4
                MOVE.B #$29,$0400(A5)                   ; Set Timer A High Byte = #$29
                SF.B D5                                 ; Set D5.b = #$00 (Timer Interrupt sets to True) 
                MOVE.B #$19,$0d00(A5)                   ; CIAB CRA - Control Register A - One Shot, Start Timer A, Force Load
.waittimer      TST.B D5
                BEQ.B .waittimer                        ; Busy Wait Loop for Level 6 Interrupt handler to set D5.b to #$FF
.exit           RTS



                ; ----------- step heads to track ----------------
                ; send a pulse to STEP bit of CIAB PRB
stepheads:      MOVE.B #$c8,$0300(A5)           ; CIAB TALO - Set Timer A low byte
                MOVE.B #$10,$0400(A5)           ; CIAB TAHI - Set Timer A high byte
                BCLR.B #$0000,(A5)              ; CIAB PRB - Set STEP bit = 0 (starts = 1)
                BCLR.B #$0000,(A5)              ; CIAB PRB - Set STEP bit = 0
                BCLR.B #$0000,(A5)              ; CIAB PRB - Set STEP bit = 0
                BSET.B #$0000,(A5)              ; CIAB PRB - Set STEP bit = 1

                SF.B D5                         ; Set D5.b = #$00 (Timer Interrupt sets to True) 

                MOVE.B #$19,$0d00(A5)           ; CIAB CRA - Control Register A - One Shot, Start Timer A, Force Load

.waittimer      TST.B D5
                BEQ.B .waittimer                ; Busy Wait Loop for Level 6 Interrupt handler to set D5.b to #$FF
                RTS 





                ;---------------- read track --------------------
                ;-- IN: A0 = MFM Buffer
readtrack:      
                MOVEM.L D0/A0,-(A7)

.waitdskrdy     BTST.B #$0005,-$0100(A4)                ; CIAA PRA - Test DSKRDY (Disk Ready) active low
                BNE.B .waitdskrdy

                MOVE.W #$4000,DSKLEN(A6)                ; Switch off Disk DMA (as per h/w ref)
                MOVE.W #$8010,DMACON(A6)                ; Enable Disk DMA
                MOVE.W #$7f00,ADKCON(A6)                ; Clear MFM Settings, PRECOMP, MFMPREC, UARTBRK, WORDSYNC, MSBSYNC, FAST
                MOVE.W #$9500,ADKCON(A6)                ; Set MFM Settings, MFMPREC, WORDSYNC, FAST         
                MOVE.W #$4489,DSKSYNC(A6)               ; Set standard DOS SYNC Mark $4489          
                MOVEA.L $0004(A7),A0                    ; Raw MFM Buffer from A0 stored on stack
                MOVE.W #$4489,(A0)+                     ; Insert Sync Mark into raw MFM Buffer (strange, maybe bug fix hack for decode routine?)
                MOVE.L A0,DSKPT(A6)                     ; Set MFM BUffer for DMA
                MOVE.W #$0002,INTREQ(A6)                ; Clear DSKBLK (Disk Block Finished) Interrupt Flag 
                MOVE.W #$99ff,D0                        ; Disk DMA read settings (DMAEN, 13 bit read length)
                                                        ; read in 6655 words (maybe one less than requested)
                                                        ; read in 13310 bytes (maybe two less than requested)
                                                        ; read in 12Kb, DOS Track Size = ((1024 + header) * 11) + gap
                MOVE.W D0,DSKLEN(A6)                    ; Initiate Disk DMA (h/w ref - has to be written twice)
                MOVE.W D0,DSKLEN(A6)                    ; Initiate Disk DMA

.waitdskblk     MOVE.L #$00000002,D0
                AND.W INTREQR(A6),D0
                BEQ.B .waitdskblk                       ; Wait for DSKBLK interrupt by polling INTREQR

                MOVE.W #$0010,DMACON(A6)                ; Disable Disk DMA, DSKEN
                MOVE.W #$4000,DSKLEN(A6)                ; Switch off Disk DMA (as per h/w ref)

                MOVEM.L (A7)+,D0/A0
                RTS 



        ;---------------- decode mfm buffer -----------------
        ;-- IN: A0.l = MFM Disk Buffer
        ;-- IN: A1.l = Decode Disk Buffer

decodemfmbuffer:
;L00030278 
                MOVEM.L D0-D2/A0,-(A7)
          CLR.W D1
          MOVE.W #$19ff,D2
          SUBA.W #$001c,A7
L00030286 CMP.W #$4489,(A0)+
          DBEQ.W D2,L00030286
          BNE.W L0003030C
L00030292 CMP.W #$4489,(A0)+
          DBNE.W D2,L00030292
          BEQ.B L0003030C
          SUBA.L #$00000002,A0
          SUB.W #$00000001,D2
L000302A0 MOVEM.L A0-A1,-(A7)
          LEA.L $0008(A7),A1
          MOVE.L #$0000001c,D0
          BSR.W L00030332
          MOVEM.L (A7)+,A0-A1
          MOVE.L #$00000028,D0
          BSR.B L00030312
          CMP.L $0014(A7),D0
          BNE.B L00030286
          MOVE.B D7,D0
          CMP.B $0001(A7),D0
          BNE.B L0003030C
          LEA.L $0038(A0),A0
          MOVE.W #$0400,D0
          BSR.B L00030312
          CMP.L $0018(A7),D0
          BNE.B L00030286
          MOVE.B $0002(A7),D0
          BSET.L D0,D1
          MOVE.L A1,-(A7)
          EXT.W D0
          MULU.W #$0200,D0
          ADDA.W D0,A1
          MOVE.W #$0200,D0
          BSR.B L00030358
          MOVEA.L (A7)+,A1
          CMP.W #$07ff,D1
          BEQ.B L00030302
          SUB.W #$021c,D2
          SUB.B #$00000001,$0003(A7)        ;== $0044ffd3
          BEQ.B L00030286 (T)
          ADDA.L #$00000008,A0
          SUB.W #$00000004,D2
          BRA.B L000302A0 (T)
L00030302 ADDA.W #$001c,A7
          MOVEM.L (A7)+,D0-D2/A0
          RTS 

;L0003030C ANDSR.B #$00fb,SR
L0003030C AND.B #$fb,CCR                ; Clear Z Flag
          BRA.B L00030302 (T)

L00030312 MOVEM.L D1-D2/A0,-(A7)
          LSR.W #$00000002,D0
          SUB.W #$00000001,D0
          MOVE.L #$00000000,D1
L0003031C MOVE.L (A0)+,D2
          EOR.L D2,D1
          DBF.W D0,L0003031C
          AND.L #$55555555,D1
          MOVE.L D1,D0
          MOVEM.L (A7)+,D1-D2/A0
          RTS 

L00030332 MOVEM.L D1-D3,-(A7)
          LSR.W #$00000002,D0
          SUB.W #$00000001,D0
          MOVE.L #$55555555,D1
L00030340 MOVE.L (A0)+,D2
          MOVE.L (A0)+,D3
          AND.L D1,D2
          AND.L D1,D3
          ADD.L D2,D2
          ADD.L D3,D2
          MOVE.L D2,(A1)+
          DBF.W D0,L00030340 (F)
          MOVEM.L (A7)+,D1-D3
          RTS 


L00030358 MOVE.L D1,-(A7)
L0003035A BTST.B #$000e,$0002(A6) ;== $0044f002
          BNE.B L0003035A
          MOVE.L #$00000000,D1
          MOVE.L D1,$0064(A6) ;== $0044f064
          MOVE.L D1,$0060(A6) ;== $0044f060
          MOVE.L #$ffffffff,$0044(A6) ;== $0044f044
          MOVE.W #$5555,$0070(A6) ;== $0044f070
          ADDA.W D0,A0
          SUBA.L #$00000002,A0
          MOVE.L A0,$0050(A6) ;== $0044f050
          ADDA.W D0,A0
          MOVE.L A0,$004C(A6)       ;== $0044f04c
          ADDA.L #$00000002,A0
          ADDA.W D0,A1
          SUBA.W #$00000002,A1
          MOVE.L A1,$0054(A6) ;== $0044f054
          ADDA.W #$00000002,A1
          MOVE.L #$1dd80002,$0040(A6) ;== $0044f040
          LSL.W #$00000005,D0
          ADD.W #$00000001,D0
          MOVE.W D0,$0058(A6) ;== $0044f058
L000303A4 BTST.B #$000e,$0002(A6) ;== $0044f002
          BNE.B L000303A4 (F)
          MOVE.L (A7)+,D1
          RTS 


        ;------------- Level 6 Interrupt Handler -------------------
        ;-- If a Timer A interrupt Occurs then Set D5.b = #$ff    --
        ;-- Loader code uses D5 as flag to wait for CIAB timer A  --
        ;-- wait for Disk Operations                              --
level6Handler:
                MOVE.L D0,-(A7)
                MOVE.W INTREQR(A6),D0                           ;Interrupt Request Bits
                BTST.L #$000e,D0                                ;Test INTEN Master/Enable Bit
                BNE.B disableInterrupts                         ;Doubt that this is ever true - h/w ref states 'enable only/no request'

                MOVE.B $0C00(A5),D0                             ;Read CIAB ICR - Interrupt Flags
                BPL.B notourinterrupt                           ;MSB = 0 Then No Interrupt on CIAB

                LSR.B #$00000001,D0                             ;Shift out Timer A Flag
                BCC.B notourinterrupt                           ;Not Timer A Interrupt
                ST.B D5                                         ;Is Timer A Interrupt

notourinterrupt:
                MOVE.W #$2000,$009C(A6) 
                MOVE.L (A7)+,D0
                RTE 

disableInterrupts:
                MOVE.W #$4000,INTREQ(A6)                        ; Clear INTEN Master/Enable Bit
                MOVE.L (A7)+,D0
                RTE 


