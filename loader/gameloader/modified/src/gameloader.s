
;---------- Includes ----------
              INCDIR      "include"
              INCLUDE     "hw.i"
              ;INCLUDE     "funcdef.i"
              ;INCLUDE     "exec/exec_lib.i"
              ;INCLUDE     "graphics/graphics_lib.i"
              ;INCLUDE     "hardware/cia.i"
;---------- Const ----------


;Interrupt status flags for variable $0000209A.B
DSKBLK_FINISHED equ $0                                  ; set by level 1 interrupt handler but unused.
BLIT_FINISHED   equ $1                                  ; set by level 3 interrupt handler but unused.
TIMERA_FINISHED equ $2
DISK_INDEX1     equ $3                                  ; set by level 6 interrupt handler (disk write trigger - both must be set to 0 & CIAB FLG interrupt)
DISK_INDEX2     equ $4                                  ; set by level 6 interrupt handler (disk write trigger - both must be set to 0 & CIAB FLG interrupt)



                    section BATMAN,code_c


                    org $800

                ;------------------------- BATMAN entry point --------------------------
                ;-- Main Game Loader, entry point from the 'RTS' in the bool block code.
                ;-- immediately calls the 'load_loading_screen' jump table entry.
                ;--
                ;-- $2AD6   - The disk file table, held on 3rd sector of track 0, loaded in to this address.
                ;--         - See documentation on the File Table structure: 
                ;--
                ;-- $7C7FC  - The top/end address of the load buffer,
                ;--           The loader loads files into memory in blocks below this address.
                ;--           e.g. the titlepic.iff raw file is loaded into $6FB06 and ends at $7C7FC - Length $CCF6
                ;--                the titleprg.iff raw file is loaded into $59766 and ends at $6FB05 - Length 163A0
                ;--           Once the files are loaded, the loader then processes the iff files and relocates
                ;--           them in memory etc.
                ;--
                ;--         
batman_start
                bra.b jump_table                                ; Calls $0000081C - jmp_load_screen (addr: $00000800)
                                                                ; This will get overwritten by the stack during loading

                dc.w    $0000, $22BA, $0000, $0000              ; scrap memory (i think)
                dc.w    $0000, $0000, $0000, $0000  
                dc.w    $0000, $0000, $0000, $0000  
                dc.w    $0000   

stack                                                           ; Top of Loader Stack, (re)set each time a game section is loaded. (addr:$0000081C) 
jump_table                                                      ; Start of jump table for loading and executing the game sections. (addr:$0000081C)
L0000081C       bra.w  load_loading_screen                      ; Calls $00000838 - Load Loading Screen (instruction addr:$0000081C)
L00000820       bra.w  load_title_screen2                       ; Calls $00000948 - Load Title Screen2  (instruction addr:$00000820)
L00000824       bra.w  load_level1                              ; Calls $000009C8 - Load Level 1 - Axis Chemicals (instruction addr:$00000824)
L00000828       bra.w  load_level_2                             ; Calls $00000A78 - Load Level 2 - Bat Mobile (instruction addr:$00000829)
L0000082C       bra.w  load_level_3                             ; Calls $00000B28 - Load Level 3 - Bat Cave Puzzle (instruction addr:$0000082C)
L00000830       bra.w  load_level_4                             ; Calls $00000B90 - Load Level 4 - Batwing Parade (instruction addr:$00000830)
L00000834       bra.w  load_level_5                             ; Calls $00000C40 - Load Level 5 - Cathedral (instruction addr:$00000834)




                

                ;---------------------- load loading screen ------------------------
                ;-- load the batman loading.iff and display it for 5 seconds.
                ;-- then, jump to load the title screen.
load_loading_screen                                             ; relocated address: $00000838
                LEA.L  stack,A7                                 ; stack address $0000081C
                BSR.W  init_system                              ; calls $00001F26 - init_system
                BSR.W  detect_available_drives                  ; calls $00001B4A - detect which disk drives are connected
                MOVE.L #$0007C7FC,ld_loadbuffer_top             ; store loader parameter: addr $7C7FC - the Top of the Load Buffer
                MOVE.L #$00002AD6,ld_relocate_addr              ; $00000CF0 (** SET BUT UNUSED **) ; addr $02AD6 - address of disk file table
                LEA.L  lp_loading_screen(PC),A0                 ; addr $008C8 - address of the load parameter block (files to load for the loading screen section)
                BSR.W  loader                                   ; calls $00000CFC - Load/Process files & Copy Protection

                ; clear out color palette
                LEA.L  CUSTOM,A6
                LEA.L  COLOR00(A6),A0
                MOVE.L #$0000001f,D0                            ; loop counter = 31 + 1
.clearloop      CLR.W (A0)+                                     ; Clear Colour Pallete Registers (instruction addr $0000086C)
                DBF.W D0,.clearloop

                ; display loading screen (5 seconds)
                MOVE.W #$0000,BPL1MOD(A6)                       ; clear bit-plane modulos
                MOVE.W #$0000,BPL2MOD(A6)                       ; clear bit-plane modulos
                MOVE.W #$0038,DDFSTRT(A6)                       ; standard data fetch start for low-res 320 wide screen
                MOVE.W #$00d0,DDFSTOP(A6)                       ; startard data fetch stop for low-res 320 wide screen
                MOVE.W #$2c81,DIWSTRT(A6)                       ; standard window start position for 320x256 pal screen
                MOVE.W #$2cc1,DIWSTOP(A6)                       ; standard window end position for 320x256 pal screen
                MOVE.W #$5200,BPLCON0(A6)                       ; 5 bit-planes, COLOR_ON = 1
                LEA.L  copper_list(PC),A0                       ; Get Copper List 1 address. addr: $00001490
                MOVE.L A0,COP1LC(A6)                            ; Set Copper 1 Pointer
                LEA.L  copper_endwait(PC),A0                    ; Get Copper List 2 address. addr: $00001538
                MOVE.L A0,COP2LC(A6)                            ; Set copper 2 Pointer
                MOVE.W A0,COPJMP2(A6)                           ; Strobe COPJMP2 to run empty list, will revert to copper 1 on next frame.
                MOVE.W #$8180,DMACON(A6)                        ; Enable DMA - BPLEN, COPEN
 
                                                                ; display loading screen for 5 seconds.
                CLR.W  ciab_tb_20ms_tick                        ; reset CIAB Timer B, ticker count
.timerwait      CMP.W  #$00fa,ciab_tb_20ms_tick                 ; wait for 250 x 20 ms = 5,000ms - $0000223A
                BCS.B  .timerwait
                BRA.B  load_title_screen1                       ; addr: $0000090E


lp_loading_screen                                               ; loading screen load parameters - addr: $000008C8
                ; Disk Name (offset from here)
.diskname_offset    dc.w    $0020
                ; File Entry to load
                ;       0 - 2 Bytes - File Name Offset (from here)
                ;       2 - 4 bytes - File reloacation address
                ;       6 - 4 bytes - File Length Stored below from file table
                ;       a - 4 bytes - File Load Address stored below
.file1_name_offset  dc.w    $002E
.file1_reloc_addr   dc.l    $00000000
.file1_byte_length  dc.l    $00000000
.file1_loadbuf_addr dc.l    $00000000 
                ; File Entry to load
                ;       0 - 2 Bytes - File Name Offset (from here)
                ;       2 - 4 bytes - File reloacation address
                ;       6 - 4 bytes - File Length Stored below from file table
                ;       a - 4 bytes - File Load Address stored below
.file2_name_offset  dc.w    $002B
.file2_reloc_addr   dc.l    $0007C7FC
.file2_byte_length  dc.l    $00000000
.file2_loadbuf_addr dc.l    $00000000
.filename3_offset   dc.w    $0000          
.diskname           dc.b    "BATMAN MOVIE   0"
.filename1          dc.b    "LOADING IFF"
.filename2          dc.b    "PANEL   IFF"







                ;---------------------- load title screen 1 & 2------------------------
                ;-- called on first load, after the loading screen.
                ;-- 1) starts the title screen (without the end game joker laugh etc)
                ;-- 2) starts the title screen (with joket laugh)
load_title_screen1                                              ; relocated address: $0000090E
                LEA.L  stack,A7                                 ; stack address $0000081C
                BSR.W  init_system                              ; L00001F26
                MOVE.L #$0007C7FC,ld_loadbuffer_top             ; store loader parameter: addr $7C7FC - the Top of the Load Buffer
                MOVE.L #$00002AD6,ld_relocate_addr              ; $00000CF0 (** SET BUT UNUSED **) ; addr $02AD6 - address of disk file table
                LEA.L  lp_title_screen(PC),A0                   ; get title screen load parameters address
                BSR.W  loader                                   ; calls $00000CFC - Load/Process files & Copy Protection
                MOVE.W #$7fff,INTENA(A6)                        ; disable interrupts
                MOVE.W #$1fff,DMACON(A6)                        ; disable all dma
                MOVE.W #$2000,SR                                ; set supervisor mode bit 
                JMP    $0001c000                                ; title screen start (on load)


load_title_screen2                                              ; relocated address: $00000948
                LEA.L  stack,A7                                 ; Stack Address $0000081C
                BSR.W  init_system                              ; L00001F26
                MOVE.L #$0007C7FC,ld_loadbuffer_top             ; store loader parameter: addr $7C7FC - the Top of the Load Buffer
                MOVE.L #$00002AD6,ld_relocate_addr              ; $00000CF0 (** SET BUT UNUSED **) ; addr $02AD6 - address of disk file table
                LEA.L  lp_title_screen(PC),A0                   ; get title screen load parameters address
                BSR.W  loader                                   ; calls $00000CFC - Load/Process files & Copy Protection
                MOVE.W #$7fff,INTENA(A6)                        ; disable interrupts
                MOVE.W #$1fff,DMACON(A6)                        ; disable all dma
                MOVE.W #$2000,SR                                ; set supervisor mode bit
                JMP    $0001c004                                ; title screen start (on end of a game)



lp_title_screen:                                                                    ; title screen loader parameters. addr: $00000982
                dc.w   $0020, $002E, $0000, $3FFC, $0000, $0000, $0000, $0000       ;. ....?.........
                dc.w   $002B, $0003, $F236, $0000, $0000, $0000, $0000, $0000       ;.+...6..........
                dc.w   $4241, $544D, $414E, $204D, $4F56, $4945, $2020, $2030       ;BATMAN MOVIE   0
                dc.w   $5449, $544C, $4550, $5247, $4946, $4654, $4954, $4C45       ;TITLEPRGIFFTITLE
                dc.w   $5049, $4349, $4646                                          ;PICIFF







                ;---------------------- load level1 - axis chemicals ------------------------
load_level1                                                         ; relocated address: $000009C8
                LEA.L  stack,A7                                     ; stack address $0000081C
                BSR.W  init_system                                  ; L00001F26
                MOVE.L #$0007C7FC,ld_loadbuffer_top                 ; store loader parameter: addr $7C7FC - the Top of the Load Buffer
                MOVE.L #$00002AD6,ld_relocate_addr                  ; $00000CF0 (** SET BUT UNUSED **) ; addr $02AD6 - address of disk file table
                LEA.L  lp_level_1(PC),A0                            ; get level 1 load parameters address
                BSR.W  loader                                       ; calls $00000CFC - Load/Process files & Copy Protection
                MOVE.W #$7fff,INTENA(A6)                            ; disable all interrupts
                MOVE.W #$1fff,DMACON(A6)                            ; disable all dma
                MOVE.W #$2000,SR                                    ; set supervisor mode bit
                JMP $00003000                                       ; level 1 start

lp_level_1                                                      ; level 1 loader parameters. addr: $00000A00
                dc.w   $003C, $004A, $0000, $2FFC, $0000, $0000, $0000, $0000         ;.<.J../.........
                dc.w   $0047, $0000, $7FFC, $0000, $0000, $0000, $0000, $0044         ;.G.............D
                dc.w   $0001, $0FFC, $0000, $0000, $0000, $0000, $0041, $0004         ;.............A..
                dc.w   $7FE4, $0000, $0000, $0000, $0000, $0000, $4241, $544D         ;............BATM
                dc.w   $414E, $204D, $4F56, $4945, $2020, $2030, $434F, $4445         ;AN MOVIE   0CODE
                dc.w   $3120, $2020, $4946, $464D, $4150, $4752, $2020, $2049         ;1   IFFMAPGR   I
                dc.w   $4646, $4241, $5453, $5052, $3120, $4946, $4643, $4845         ;FFBATSPR1 IFFCHE
                dc.w   $4D20, $2020, $2049, $4646                                     ;M    IFF







                ;---------------------- load level 2 - bat mobile ------------------------
load_level_2                                                    ; relocated address: $00000A78
                LEA.L  stack,A7                                     ; stack address $0000081C
                BSR.W  init_system                                  ; L00001F26
                MOVE.L #$0007C7FC,ld_loadbuffer_top                 ; store loader parameter: addr $7C7FC - the Top of the Load Buffer
                MOVE.L #$00002AD6,ld_relocate_addr                  ; $00000CF0 (** SET BUT UNUSED **) ; addr $02AD6 - address of disk file table
                LEA.L  lp_level_2(PC),A0                            ; get level 2 load parameters address
                BSR.W  loader                                       ; calls $00000CFC - Load/Process files & Copy Protection
                MOVE.W #$7fff,INTENA(A6)                            ; disable all interrupts
                MOVE.W #$1fff,DMACON(A6)                            ; disable all dma
                MOVE.W #$2000,SR                                    ; set supervisor mode bit
                JMP $00003000                                       ; level 2 start

lp_level_2                                                      ; level 2 loader parameters. addr: $00000AB0
                dc.w   $003C, $004A, $0000, $2FFC, $0000, $0000, $0000, $0000         ;.<.J../.........
                dc.w   $0047, $0001, $FFFC, $0000, $0000, $0000, $0000, $0044         ;.G.............D
                dc.w   $0002, $A416, $0000, $0000, $0000, $0000, $0041, $0006         ;.............A..
                dc.w   $8F7C, $0000, $0000, $0000, $0000, $0000, $4241, $544D         ;.|..........BATM
                dc.w   $414E, $204D, $4F56, $4945, $2020, $2031, $434F, $4445         ;AN MOVIE   1CODE
                dc.w   $2020, $2020, $4946, $4644, $4154, $4120, $2020, $2049         ;    IFFDATA    I
                dc.w   $4646, $4441, $5441, $3220, $2020, $4946, $464D, $5553         ;FFDATA2   IFFMUS
                dc.w   $4943, $2020, $2049, $4646                                     ;IC   IFFO






                ;---------------------- load level 3 - bat cave puzzle ------------------------
load_level_3                                                    ; relocated address: $00000B28
                LEA.L  stack,A7                                     ; stack address $0000081C
                BSR.W  init_system                                  ; L00001F26
                MOVE.L #$0007C7FC,ld_loadbuffer_top                 ; store loader parameter: addr $7C7FC - the Top of the Load Buffer
                MOVE.L #$00002AD6,ld_relocate_addr                  ; $00000CF0 (** SET BUT UNUSED **) ; addr $02AD6 - address of disk file table
                LEA.L  lp_level_3(PC),A0                            ; get level 3 load parameters address
                BSR.W  loader                                       ; calls $00000CFC - Load/Process files & Copy Protection
                MOVE.W #$7fff,INTENA(A6)                            ; disable all interrupts
                MOVE.W #$1fff,DMACON(A6)                            ; disable all dma
                MOVE.W #$2000,SR                                    ; set supervisor mode bit
                JMP $0000d000                                       ; level 3 start

lp_level_3                                                      ; level 3 loader parameters. addr: $00000B62
                dc.w   $0012, $0020, $0000, $3FFC, $0000, $0000, $0000, $0000         ;... ..?.........
                dc.w   $0000, $4241, $544D, $414E, $204D, $4F56, $4945, $2020         ;..BATMAN MOVIE  
                dc.w   $2031, $4241, $5443, $4156, $4520, $4946, $4600                ; 1BATCAVE IFF.






                ;---------------------- load level 4 - batwing parade ------------------------
load_level_4                                                    ; relocated address: $00000B90
                LEA.L  stack,A7                                     ; stack address $0000081C
                BSR.W  init_system                                  ; L00001F26
                MOVE.L #$0007C7FC,ld_loadbuffer_top                 ; store loader parameter: addr $7C7FC - the Top of the Load Buffer
                MOVE.L #$00002AD6,ld_relocate_addr                  ; $00000CF0 (** SET BUT UNUSED **) ; addr $02AD6 - address of disk file table
                LEA.L  lp_level_4(PC),A0                            ; get level 4 load parameters address
                BSR.W  loader                                       ; calls $00000CFC - Load/Process files & Copy Protection
                MOVE.W #$7fff,INTENA(A6)                            ; disable all interrupts
                MOVE.W #$1fff,DMACON(A6)                            ; disable all dma
                MOVE.W #$2000,SR                                    ; set supervisor mode bit
                JMP $00003002                                       ; level 4 start

lp_level_4                                                      ; level 4 loader parameters. addr: $00000BC8
                dc.w   $003C, $004A, $0000, $2FFC, $0000, $0000, $0000, $0000         ;.<.J../.........
                dc.w   $0047, $0001, $FFFC, $0000, $0000, $0000, $0000, $0044         ;.G.............D
                dc.w   $0002, $A416, $0000, $0000, $0000, $0000, $0041, $0006         ;.............A..
                dc.w   $8F7C, $0000, $0000, $0000, $0000, $0000, $4241, $544D         ;.|..........BATM
                dc.w   $414E, $204D, $4F56, $4945, $2020, $2031, $434F, $4445         ;AN MOVIE   1CODE
                dc.w   $2020, $2020, $4946, $4644, $4154, $4120, $2020, $2049         ;    IFFDATA    I
                dc.w   $4646, $4441, $5441, $3420, $2020, $4946, $464D, $5553         ;FFDATA4   IFFMUS
                dc.w   $4943, $2020, $2049, $4646                                     ;IC   IFFO...a...







                ;---------------------- load level 5 - cathedral  ------------------------
load_level_5                                                    ; relocated address: $00000C40
                LEA.L  stack,A7                                     ; stack address $0000081C
                BSR.W  init_system                                  ; L00001F26
                MOVE.L #$0007C7FC,ld_loadbuffer_top                 ; store loader parameter: addr $7C7FC - the Top of the Load Buffer
                MOVE.L #$00002AD6,ld_relocate_addr                  ; $00000CF0 (** SET BUT UNUSED **) ; addr $02AD6 - address of disk file table
                LEA.L  lp_level_5(PC),A0                            ; level 5 load parameters address
                BSR.W  loader                                       ; calls $00000CFC - Load/Process files & Copy Protection
                MOVE.W #$7fff,INTENA(A6)                            ; disable all interrupts
                MOVE.W #$1fff,DMACON(A6)                            ; disable all dma
                MOVE.W #$2000,SR                                    ; set supervisor mode bit
                JMP $00003000                                       ; level 5 start

lp_level_5                                                      ; level 5 loader parameters. addr: $00000C78
                dc.w   $003C, $004A, $0000, $2FFC, $0000, $0000, $0000, $0000         ;.<.J../.........
                dc.w   $0047, $0000, $7FFC, $0000, $0000, $0000, $0000, $0044         ;.G.............D
                dc.w   $0001, $0FFC, $0000, $0000, $0000, $0000, $0041, $0004         ;.............A..
                dc.w   $7FE4, $0000, $0000, $0000, $0000, $0000, $4241, $544D         ;............BATM
                dc.w   $414E, $204D, $4F56, $4945, $2020, $2030, $434F, $4445         ;AN MOVIE   0CODE
                dc.w   $3520, $2020, $4946, $464D, $4150, $4752, $3220, $2049         ;5   IFFMAPGR2  I
                dc.w   $4646, $4241, $5453, $5052, $3120, $4946, $4643, $4855         ;FFBATSPR1 IFFCHU
                dc.w   $5243, $4820, $2049, $4646                                     ;RCH  IFF 








                ;----------------------------------------------------------------------------------------------------
                ;----------------------------------------------------------------------------------------------------
                ; GAME LOADER & FILE PROCESSOR/RELOCATOR
                ;----------------------------------------------------------------------------------------------------
                ;----------------------------------------------------------------------------------------------------







                ;------------------------------ loader data/parameters ------------------------------
                ;-- loader parameters and data store
                ;-- starts at relocated address $00000CF0
                ;-- $CF0 - File Relocation Address
                ;-- $CF4 - Top/End of Loaded Files Buffer 
                ;--        files are loaded below this address, kinda like a file stack
                ;--        when all files are loaded they are then processed and relocated
                ;--        also by the loader.
                ;-- $CF8 - Holds the File Table Memory Address Pointer (set in loader)
ld_relocate_addr                                ; addr $00000CF0 - file relocation address (misused by code external to the loader)
                dc.l   $00000000
ld_loadbuffer_top                               ; addr $00000CF4
                dc.l   $00000000                ; ptr to load buffer end/top of memory (file are loaded below this address sequentially)
ld_filetable                                    ; addr $00000CF8
                dc.l   $00000000                ; ptr to disk file table addess (disk directory, file names, length & start sectors)




                ;---------------------------------- loader ---------------------------------------
                ;-- the main call made to load a game section into memory.
                ;-- loads and decodes files into memory buffer, then processes the files and
                ;-- relocates them, finally hands off to the copy protection.
                ;-- the copy protection man-handles the stack to return to the called of loader()
                ;--
                ; IN: A0            - load parameter block base address.
                ; IN: 00000CF4.l    - Top/end of Load buffer in memory ($7C7FC)
                ; IN: 00000CF0.l    - (** SET BUT UNUSED **) Disk File Table Contents ($2AD6) for all loading sections.
                ;
loader                                                          ; relocated routine start Addr $00000CFC 
                MOVEM.L D0-D7/A0-A6,-(A7)
                CLR.W   ld_load_status                          ; $00001B08 ; clear 'load status' word
                MOVE.L  #$00002AD6,ld_filetable                 ; store file table address
                MOVE.L  #$00002CD6,ld_decoded_track_ptr         ; decoded track buffer address
                MOVE.L  #$000042D6,ld_mfmencoded_track_ptr      ; mfm encoded track buffer address
                TST.W   (A0)                                    ; test first load parameter value
                BEQ.W   .end_load_files                         ; end load if = 0 - just check copy protection? ; jmp $00000D6E 

.check_disk
                MOVEA.L A0,A1                                   ; copy file parameter block base address
                ADDA.W  (A1)+,A0                                ; A0 = ptr to disk name string e.g. "BATMAN MOVIE   0"
                MOVE.L  A1,-(A7)                                ; A1 = ptr to first filename structure.
                BSR.W   load_filetable                          ; $000015DE ; Load File Table $2AD6 & Check Disk Name
                BEQ.B   .correct_disk                           ; $00000D38 ; Z = 1 - correct disk in the drive
                BSR.W   L000013B2                               ;       - else wait for correct disk to be inserted

.correct_disk
                MOVEA.L (A7),A0                                 ; A0 = ptr to first filename structure. (CCR not affected)
                LEA.L   $0007c7fc,A6                            ; Top/End of loaded files buffer
                CLR.W   ld_load_status                          ; $00001B08 ; clear 'load status' word
                BSR.W   load_file_entries                       ; call $00001652 - load files (A0 = first file entry)
                MOVEA.L (A7)+,A0                                ; A0 = ptr to first filename structure. (CCR not affected)
                BNE.B   .end_load_files                         ; Z=0 - error, jmp $00000D6E

.process_files_loop
                TST.W   (A0)                                    ; A0 = ptr to 1st file entry loaded. Test for file to process
                BEQ.B   .end_load_files                          ; Test First File Entry data value, if null jmp $00000D6E
                MOVE.L  A0,-(A7)
                MOVE.L  $0002(A0),ld_relocate_addr              ; $00000CF0 = file relocation address (from file entry table)
                MOVE.L  $0006(A0),D0
                MOVEA.L $000a(A0),A0
                BSR.W   process_file                            ; call $000016E0
                MOVEA.L (A7)+,A0
                LEA.L   $000e(A0),A0
                BRA.B   .process_files_loop                     ; jmp $00000D4E ; process next file

.end_load_files                                                  ; relocated address: $00000D6E
                MOVE.W  ld_drive_number,D0                      ; $00001AFC
                BSR.W   drive_motor_off                         ; calls $00001B7A
                LEA.L   $00bfd100,A0                            ; CIAB PRB - as a base register

.vbwait1                                                        ; Vertical Blank Wait 1                                           
                CLR.W   frame_counter                           ; Clear frame counter
.wait_frame1
                TST.W   frame_counter                           ; Compare Frame Counter with 0
                BEQ.B   .wait_frame1                            ; loop until next VERTB interrupt

                MOVE.B  #$00,$0900(A0)                          ; CIAB - Clear TODHI 
                MOVE.B  #$00,$0800(A0)                          ; CIAB - Clear TODMID
                MOVE.B  #$00,$0700(A0)                          ; CIAB - Clear TODLOW

.vbwait2                                                        ; Vertical Blank Wait 2
                CLR.W   frame_counter                           ; $00002144
.wait_frame2
                TST.W   frame_counter                       
                BEQ.B   .wait_frame2                            ; loop until next VERTB interrupt

                MOVE.L  #$00000000,D0                           ; CIAB - Read TOD value
                MOVE.B  $0900(A0),D0                            ; CIAB - Read TODHI
                ASL.L   #$00000008,D0                           ; CIAB - shift bits
                MOVE.B  $0800(A0),D0                            ; CIAB - Read TODMID
                ASL.L   #$00000008,D0                           ; CIAB - shift bits
                MOVE.B  $0700(A0),D0                            ; CIAB - Read TODLOW
 
                CMP.L   #$00000115,D0                           ; Compare value in TOD with #$115 (277 scan lines, TOD tick is synced to Horizontal Sync)
.infinite_loop
                BCS.B   .infinite_loop                          ; A check for execution speed between .vbwait1 & .vbwait2
                                                                ; or the number of scan lines (maybe fail for NTSC?)
                                                                ; infinite loop if D0 < 277 
                                                                ;    - PAL 312.5 scanlines
                                                                ;    - NTSC 262.5 scan lines

                BRA.W   copy_protection_init1                   ; instruction addr: $00000DC6 - jump to copy protection $00000E82                   







                ;----------------------------------------------------------------------------------------------------
                ;----------------------------------------------------------------------------------------------------
                ; COPY PROTECTION (Rob Northen)
                ;----------------------------------------------------------------------------------------------------
                ;----------------------------------------------------------------------------------------------------






                ;------------- copy protection - mfm and decode buffer ---------------
                ;-- data is read in from the protected track 'manually' and stored
                ;-- here mfm encoded. It is later decoded in place (half size)
cp_mfm_buffer
L00000DCA       dc.W    $0000, $0000, $0000, $0000, $0000, $0000, $0000                 ;............
L00000DD8       dc.W    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00000DE8       dc.W    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00000DF8       dc.W    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00000E08       dc.W    $0000, $0000, $0000, $0000


                ;------------ copy protection variables/data ------------------------
                ;-- various data registers and storage value start at $E10 
cp_data
L00000E10       dc.w    $0000, $0000, $0000, $0000 
L00000E18       dc.W    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00000E28       dc.W    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00000E38       dc.W    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00000E48       dc.W    $0000, $0000, $0000, $0000

L00000E50       dc.w    $0000, $0000, $0000, $0000                                      ;................
L00000E58       dc.W    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00000E68       dc.W    $0000, $0000 
L00000E6C       dc.w    $0000, $0000 
L00000E70       dc.w    $FFFF, $FFFF 
L00000E74       dc.w    $0000 
L00000E76       dc.w    $0001                                                    ;................
L00000E78       dc.W    $0000
L00000E7A       dc.W    $0000, $0000, $0000, $0000                               


copy_protection_init1
L00000E82       MOVE.L  A6,-(A7)
L00000E84       LEA.L   L00000E10(pc),A6
L00000E88       MOVEM.L D0-D7/A0-A7,(A6)
L00000E8C       LEA.L   $0040(A6),A6
L00000E90       MOVE.L  (A7)+,-$0008(A6)
L00000E94       MOVE.L  $00000010,D0
L00000E9A       PEA.L   cp_supervisor(PC)                                                     
L00000E9E       MOVE.L  (A7)+,$00000010
L00000EA4       ILLEGAL  

                ;------------ enter supervisor (if not already) ------------------
                ;-- This exception never returns to this point in the code.
                ;-- Later the stack is return address is modified to return to
                ;-- the address L0000139C

cp_supervisor                               
L00000EA6       MOVE.L  D0,$00000010
L00000EAC       MOVEM.L $00000008,D0-D7
L00000EB4       MOVEM.L D0-D7,(A6)

L00000EB8       LEA.L cp_toggle_tvd(PC),A0
L00000EBC       MOVE.L A0,$00000010                             ; Set ILLEGAL Exception vector to 'cp_toggle_tvd'
L00000EC2       ILLEGAL                                         ; Toggle on trace vector decoder (TVD)
                ; Execution continues here with TVD on
                ; normally the code would be encoded.

                ;---------------- jump around table nonsense --------------------
                ;-- Normally this code would be encoded by the TVD, this table
                ;-- of jumps is no doubt intended to cause confusion and
                ;-- cause would-be crackers problems tracing the code.
cp_confusion
L00000EC4       BRA.W L00000ED4
L00000EC8       BRA.W L00000F04
L00000ECC       BRA.W L00000F30
L00000ED0       BRA.W L00000EDC
L00000ED4       BRA.W L00000EE0                                            
L00000ED8       BRA.W L00000EF4
L00000EDC       BRA.W L00000F00
L00000EE0       BRA.W L00000F34
L00000EE4       BRA.W L00000EC8
L00000EE8       BRA.W L00000EF0
L00000EEC       BRA.W L00000EFC
L00000EF0       BRA.W L00000F0C
L00000EF4       BRA.W L00000F2C
L00000EF8       BRA.W L00000F28
L00000EFC       BRA.W L00000F10
L00000F00       BRA.W L00000EE4
L00000F04       BRA.W L00000EE8
L00000F08       BRA.W cp_set_vectors                                        ;L00000f9e Exit point from the jumps
L00000F0C       BRA.W L00000F14
L00000F10       BRA.W L00000ED0
L00000F14       BRA.W L00000F1C
L00000F18       BRA.W L00000ECC
L00000F1C       BRA.W L00000ED8
L00000F20       BRA.W L00000EEC
L00000F24       BRA.W L00000EF8
L00000F28       BRA.W L00000F18
L00000F2C       BRA.W L00000F24
L00000F30       BRA.W L00000F08
L00000F34       BRA.W L00000F20


                ;------------ copy protection - toggle trace vector decoder -------------
                ;-- ILLEGAL intruction exception handler, this routine would normally
                ;-- toggle on/off the TVD and also decode/encode the first/last
                ;-- instruction that was being executed by the copy protection.
                ;-- It's been patched so it doesn't encode/decode any instructions,
                ;-- The 68000 trace bit is still toggled in 
cp_toggle_tvd
L00000F38       MOVEM.L D0/A0-A1,-(A7)
L00000F3C       LEA.L   cp_tvd(PC),A0                                           ;  
L00000F40       MOVE.L  A0,$00000024                                            ; Set TVD Address in Trace Exception Vector
L00000F46       LEA.L   L0000139C(PC),A0                                        ; 
L00000F4A       MOVE.L  A0,$00000020                                            ; Set cp_finish in Privilege Violation Exception Vector 
                                                                                ; unused, maybe a protection mechanism to prevent tampering.
L00000F50       ADD.L   #$00000002,$000e(A7)                                    ; Increment the return address on stack 2 bytes
L00000F58       OR.B    #$07,$000c(A7)                                          ; Enable Interrupts
L00000F5E       BCHG.B  #$07,$000c(A7)                                          ; Toggle the 68000 trace bit on/off
L00000F64       LEA.L   L00000E7A(PC),A1                                        ; unused (locatopn previously used for encode/decode)
L00000F68       MOVEM.L (A7)+,D0/A0-A1
L00000F6C       RTE 
L00000F6E       NOP 
L00000F70       NOP 


                ;----------- copy protection - trace vector decoder (TVD) -------------
                ;-- This code would normaly decode the next instruction and encode
                ;-- the previous copy protection instruction while the 68000 is
                ;-- in trace mode.
                ;-- Patched to do nothing but flash the screen when each instruction
                ;-- executes while the 68000 trace bit is enabled.
cp_tvd
L00000F72       AND.W #$f8ff,SR
L00000F76       MOVEM.L D0/A0-A1,-(A7)
L00000F7A       NOP 
L00000F7C       NOP 
L00000F7E       MOVE.W #$0fff,D0
L00000F82       MOVE.W D0,$00dff180
L00000F88       SUB.W #$0111,D0
L00000F8C       BNE.B L00000F82
L00000F8E       NOP 
L00000F90       NOP 
L00000F92       NOP 
L00000F94       NOP 
L00000F96       NOP 
L00000F98       MOVEM.L (A7)+,D0/A0-A1
L00000F9C       RTE 


                ;------------ copy protection - set vectors -------------------
cp_set_vectors
L00000F9E       LEA.L exception_vector_offsets(PC),A0
L00000FA2       LEA.L $00000008,A1
L00000FA8       LEA.L L00000E82(PC),A2
L00000FAC       MOVE.L #$00000007,D0
L00000FAE       MOVE.L #$00000000,D1
L00000FB0       MOVE.W (A0)+,D1
L00000FB2       ADD.L A2,D1
L00000FB4       MOVE.L D1,(A1)+
L00000FB6       DBF.W D0,L00000FAE
L00000FBA       BRA.W L00000FCE

exception_vector_offsets
L00000FBE       dc.w    $059A, $051A, $00B6, $05DA, $061A ,$069A ,$051A, $00F0              ;................

L00000FCE       LEA.L  L00000E50(PC),A1
L00000FD2       CLR.L  $001c(A1)
L00000FD6       BSR.W  L00001070
L00000FDA       BEQ.W  L0000136E
L00000FDE       MOVE.L #$00000006,D2
L00000FE0       SUB.L  #$00000001,D2
L00000FE2       BEQ.B  L00001044
L00000FE4       LEA.L  L00000DCA(PC),A0
L00000FE8       MOVE.L #$00000005,D0
L00000FEA       BSR.W  L000010B4
L00000FEE       MOVE.L D0,D3
L00000FF0       MOVE.L #$00000004,D0
L00000FF2       BSR.W  L000010B4
L00000FF6       MOVE.L D0,D1
L00000FF8       MOVE.L D3,D0
L00000FFA       BSR.B  L00001058
L00000FFC       BMI.B  L00000FE0
L00000FFE       MOVE.L #$00000006,D0
L00001000       BSR.W  L000010B4
L00001004       MOVE.L D3,D1
L00001006       BSR.B  L00001058
L00001008       BMI.B  L00000FE0
L0000100A       CMP.L  #$526f6220,(A0)
L00001010       BNE.B  L00000FE0
L00001012       CMP.L  #$4e6f7274,$0004(A0)
L0000101A       BNE.B  L00000FE0
L0000101C       CMP.L  #$68656e20,$0008(A0)
L00001024       BNE.B  L00000FE0
L00001026       CMP.L  #$436f6d70,$000c(A0)
L0000102E       BNE.B  L00000FE0
L00001030       MOVE.L #$00000005,D1
L00001032       MOVEA.L A0,A1
L00001034       ADD.L  (A1)+,D0
L00001036       ROL.L  #$00000001,D0
L00001038       DBF.W  D1,L00001034
L0000103C       LEA.L  L00000E50(PC),A1
L00001040       ADD.L  D0,$001c(A1)
L00001044       MOVE.W L00000E78(PC),D2
L00001048       BSR.W  L0000124C
L0000104C       BSR.W  L0000121A
L00001050       MOVE.L L00000E6C(PC),D0
L00001054       BRA.W  L0000136E
L00001058       SUB.L  D1,D0
L0000105A       BMI.B  L0000106C
L0000105C       MULU.W #$0064,D0
L00001060       DIVU.W D1,D0
L00001062       CMP.B  #$03,D0
L00001066       BLT.B  L0000106C
L00001068       MOVE.L #$00000000,D0
L0000106A       RTS 

L0000106C       MOVE.L #$ffffffff,D0
L0000106E       RTS 

L00001070       MOVE.L  #$00000003,D0
L00001072       BSR.W   L00001206
L00001076       BNE.B   L0000109C
L00001078       MOVE.L  #$00000000,D2
L0000107A       BSR.W   L0000124C
L0000107E       BNE.B   L0000109C
L00001080       LEA.L   L00000DCA(PC),A0
L00001084       MOVE.L  #$00000002,D2
L00001086       MOVE.W  L000011EA(PC),D0
L0000108A       BSR.W   L00001134
L0000108E       BNE.B   L000010B2
L00001090       DBF.W   D2,L00001086
L00001094       MOVE.W  L00000E78(PC),D2
L00001098       BSR.W   L0000124C
L0000109C       BSR.W   L0000121C
L000010A0       LEA.L   L00000E74(PC),A0
L000010A4       ADD.W   #$0001,(A0)
L000010A8       AND.W   #$0003,(A0)
L000010AC       DBF.W   D3,L00001072
L000010B0       MOVE.L  #$00000000,D0
L000010B2       RTS 

L000010B4       MOVEM.L D0-D2/A0-A1,-(A7)
L000010B8       BSR.B   L0000110A
L000010BA       MOVE.L  D0,D2
L000010BC       MOVE.L  (A7),D0
L000010BE       LEA.L   L000011EA(PC),A1
L000010C2       LSL.L   #$00000001,D0
L000010C4       MOVE.W  $00(A1,D0.L),D0
L000010C8       MOVE.L  D0,D1
L000010CA       MOVE.L  D1,D0
L000010CC       BSR.B   L00001134
L000010CE       BEQ.B   L000010CA
L000010D0       MOVE.L  D0,(A7)
L000010D2       MOVE.W  (A0),D0
L000010D4       EOR.W   D2,D0
L000010D6       AND.W   #$5555,D0
L000010DA       BNE.B   L000010CA
L000010DC       MOVEA.L A0,A1
L000010DE       TST.W   (A0)+
L000010E0       MOVE.L  #$0000000b,D1
L000010E2       MOVE.L  (A0)+,D0
L000010E4       BSR.W   L000010F4
L000010E8       MOVE.W  D0,(A1)+
L000010EA       DBF.W   D1,L000010E2
L000010EE       MOVEM.L (A7)+,D0-D2/A0-A1
L000010F2       RTS 


L000010F4       MOVEM.L D1-D2,-(A7)
L000010F8       MOVE.L  D0,D1
L000010FA       MOVE.L  #$0000000f,D2
L000010FC       ROXL.L  #$00000002,D1
L000010FE       ROXL.L  #$00000001,D0
L00001100       DBF.W   D2,L000010FC
L00001104       MOVEM.L (A7)+,D1-D2
L00001108       RTS 


L0000110A       MOVEM.L D1-D2,-(A7)
L0000110E       SWAP.W  D0
L00001110       MOVE.L  D0,D2
L00001112       MOVE.L  #$0000000f,D1
L00001114       LSL.L   #$00000002,D0
L00001116       ROXL.L  #$00000001,D2
L00001118       BCS.B   L00001126
L0000111A       BTST.L  #$0002,D0
L0000111E       BNE.B   L0000112A
L00001120       BSET.L  #$0001,D0
L00001124       BRA.B   L0000112A
L00001126       BSET.L  #$0000,D0
L0000112A       DBF.W   D1,L00001114
L0000112E       MOVEM.L (A7)+,D1-D2
L00001132       RTS 


L00001134       MOVEM.L D1-D4/A0-A1,-(A7)
L00001138       MOVEA.L A0,A1
L0000113A       LEA.L   $00dff000,A0
L00001140       MOVE.W  D0,$007e(A0)
L00001144       BSR.W   L00001332
L00001148       MOVE.W  #$4000,$0024(A0)
L0000114E       MOVE.L  A1,$0020(A0)
L00001152       MOVE.W  #$6600,$009e(A0)
L00001158       MOVE.W  #$9500,$009e(A0)
L0000115E       MOVE.W  #$8010,$0096(A0)
L00001164       MOVE.W  #$0002,$009c(A0)
L0000116A       BSR.W   L0000117C
L0000116E       MOVE.W  #$0400,$009e(A0)
L00001174       TST.L   D0
L00001176       MOVEM.L (A7)+,D1-D4/A0-A1
L0000117A       RTS 




L0000117C       ILLEGAL 
L0000117E       TST.B   $00bfdd00
L00001184       BTST.B  #$0004,$00bfdd00
L0000118C       BEQ.B   L00001184
L0000118E       MOVE.W  #$8000,$0024(A0)
L00001194       MOVE.W  #$8000,$0024(A0)
L0000119A       MOVE.L  #$00000000,D1
L0000119C       MOVE.L  #$00061a80,D2
L000011A2       SUB.L   #$00000001,D2
L000011A4       BEQ.B   L000011D0
L000011A6       MOVE.B  $001a(A0),D0
L000011AA       BTST.L  #$0004,D0
L000011AE       BEQ.B   L000011A2
L000011B0       MOVE.L  #$00000031,D2
L000011B2       ADD.L   #$00000001,D1
L000011B4       MOVE.W  $001a(A0),D0
L000011B8       BPL.B   L000011B2
L000011BA       MOVE.B  D0,(A1)+
L000011BC       DBF.W   D2,L000011B2
L000011C0       MOVE.W  #$03cd,D2
L000011C4       ADD.L   #$00000001,D1
L000011C6       MOVE.W  $001a(A0),D0
L000011CA       BPL.B   L000011C4
L000011CC       DBF.W   D2,L000011C4
L000011D0       MOVE.W  $001e(A0),D0
L000011D4       MOVE.W  #$0002,$009c(A0)
L000011DA       MOVE.W  #$4000,$0024(A0)
L000011E0       BTST.L  #$0001,D0
L000011E4       BNE.B   L00001200
L000011E6       MOVE.L  #$00000000,D1
L000011E8       BRA.B   L00001200

L000011EA       dc.w    $8A91, $8A44, $8A45, $8A51, $8912, $8911, $8914, $8915      ;...D.E.Q........
L000011FA       dc.w    $8944, $8945, $8951                                         ;.D.E.Q

L00001200       MOVE.L D1,D0
L00001202       ILLEGAL 
L00001204       RTS 






L00001206       MOVE.L  #$ffffffff,D1
L00001208       BCLR.L  #$0007,D1
L0000120C       BSR.B   L0000121C
L0000120E       MOVE.L  #$000927c0,D0
L00001214       BSR.W   L00001366
L00001218       BRA.B   L00001230
L0000121A       MOVE.L  #$ffffffff,D1
L0000121C       LEA.L   $00bfd100,A0
L00001222       MOVE.B  D1,(A0)
L00001224       MOVE.W  L00000E74(PC),D0
L00001228       ADD.L   #$00000003,D0
L0000122A       BCLR.L  D0,D1
L0000122C       MOVE.B  D1,(A0)
L0000122E       RTS 

L00001230       LEA.L   $00bfe001,A0
L00001236       MOVE.L  #$0000061a,D0
L0000123C       BTST.B  #$0005,(A0)
L00001240       BEQ.B   L00001248
L00001242       SUB.L   #$00000001,D0
L00001244       BPL.B   L0000123C
L00001246       RTS 

L00001248       MOVE.L #$00000000,D0
L0000124A       RTS 

L0000124C       MOVEM.L D1-D5,-(A7)
L00001250       MOVE.W  D2,D5
L00001252       BSR.W   L00001332
L00001256       AND.W   #$007f,D5
L0000125A       BEQ.B   L00001268
L0000125C       MOVE.W  L00000E74(PC),D0
L00001260       BSR.W   L0000129C
L00001264       MOVE.W  D1,D4
L00001266       BPL.B   L00001270
L00001268       BSR.W   L000012A8
L0000126C       BNE.B   L00001296
L0000126E       MOVE.L  #$00000000,D4
L00001270       CMP.W   D4,D5
L00001272       BEQ.B   L00001282
L00001274       BLT.B   L0000127C
L00001276       BSR.B   L000012E8
L00001278       ADD.L   #$00000001,D4
L0000127A       BRA.B   L00001270
L0000127C       BSR.B   L000012E4
L0000127E       SUB.L   #$00000001,D4
L00001280       BRA.B   L00001270
L00001282       BSR.W   L00001332
L00001286       MOVE.W  L00000E74(PC),D0
L0000128A       LSL.W   #$00000001,D0
L0000128C       LEA.L   L00000E70(PC),A0
L00001290       MOVE.W  D4,$00(A0,D0.W)
L00001294       MOVE.L  #$00000000,D0
L00001296       MOVEM.L (A7)+,D1-D5
L0000129A       RTS 


L0000129C       LSL.W   #$00000001,D0
L0000129E       LEA.L   L00000E70(PC),A0
L000012A2       MOVE.W  $00(A0,D0.W),D1
L000012A6       RTS 


L000012A8       MOVEM.L D1-D4,-(A7)
L000012AC       MOVE.L  #$00000055,D4
L000012AE       BTST.B  #$0004,$00bfe001
L000012B6       BEQ.B   L000012C4
L000012B8       BSR.W   L000012E4
L000012BC       DBF.W   D4,L000012AE
L000012C0       MOVE.L  #$ffffffff,D0
L000012C2       BRA.B   L000012DE
L000012C4       MOVE.W  L00000E74(PC),D0
L000012C8       LSL.W   #$00000001,D0
L000012CA       LEA.L   L00000E70(PC),A0
L000012CE       CLR.W   $00(A0,D0.W)
L000012D2       MOVE.L  #$00000055,D0
L000012D4       SUB.L   D4,D0
L000012D6       LEA.L   L00000E78(PC),A0
L000012DA       MOVE.W  D0,(A0)
L000012DC       MOVE.L  #$00000000,D0
L000012DE       MOVEM.L (A7)+,D1-D4
L000012E2       RTS 


L000012E4       MOVE.L  #$00000001,D2
L000012E6       BRA.B   L000012EA
L000012E8       MOVE.L  #$00000000,D2
L000012EA       MOVE.W  L00000E74(PC),D0
L000012EE       MOVE.W  L00000E76(PC),D1
L000012F2       MOVE.B  $00bfd100,D3
L000012F8       OR.B    #$7f,D3
L000012FC       ADD.B   #$03,D0
L00001300       BCLR.L  D0,D3
L00001302       SUB.B   #$03,D0
L00001306       TST.B   D1
L00001308       BEQ.B   L0000130E
L0000130A       BCLR.L  #$0002,D3
L0000130E       TST.B   D2
L00001310       BNE.B   L00001316
L00001312       BCLR.L  #$0001,D3
L00001316       BCLR.L  #$0000,D3
L0000131A       MOVE.B  D3,$00bfd100
L00001320       BSET.L  #$0000,D3
L00001324       MOVE.B  D3,$00bfd100
L0000132A       MOVE.L  #$00000bb8,D0
L00001330       BRA.B   L00001366
L00001332       MOVE.W  L00000E74(PC),D0
L00001336       MOVE.W  L00000E76(PC),D1
L0000133A       MOVE.W  D2,-(A7)
L0000133C       MOVE.B  $00bfd100,D2
L00001342       OR.B    #$7f,D2
L00001346       ADD.B   #$03,D0
L0000134A       BCLR.L  D0,D2
L0000134C       SUB.B   #$03,D0
L00001350       TST.B   D1
L00001352       BEQ.B   L00001358
L00001354       BCLR.L  #$0002,D2
L00001358       MOVE.B  D2,$00bfd100
L0000135E       MOVE.L  #$000005dc,D0
L00001364       MOVE.W  (A7)+,D2
L00001366       LSR.L   #$00000005,D0
L00001368       SUB.L   #$00000001,D0
L0000136A       BNE.B   L00001368
L0000136C       RTS 


L0000136E       LEA.L   L00000E10(PC),A0
L00001372       MOVE.L  D0,(A0)
L00001374       MOVEM.L L00000E50(PC),D0-D7
L0000137A       MOVE.L  $00000004,D0
L00001380       MOVE.L  D0,D1
L00001382       LEA.L   L0000139C(PC),A0                            ; New copy protection return address.
L00001386       MOVE.L  A0,$0002(A7)
L0000138A       ILLEGAL 
L0000138C       MOVEM.L D0-D7,$00000008
L00001394       MOVEM.L L00000E10(PC),D0-D7/A0-A6
L0000139A       RTE                                                 ; Return from copy protection exception to $0000139C below.


                ;------------------- end of copy protection ----------------------------
L0000139C       MOVE.L  #$00000000,D0
L0000139E       MOVE.W  #$0001,ld_load_status                       ; $00001b08 ; set load status
L000013A6       MOVEM.L (A7)+,D0-D7/A0-A6
L000013AA       TST.W   ld_load_status                              ; $00001b08 ; test load status
L000013B0       RTS                                                 ; return from initial call to 'loader'



                ;----------------- end of copy protection routines ----------------------









                ;---------------------- wrong disk in the drive -------------------------
                ;-- IN: A0.l - ptr to disk name
                ;--
wait_for_correct_disk                                               ; relocated address $000013B2
L000013B2       MOVE.L  A0,-(A7)
                LEA.L   L00002334(PC),A0                            ; Disk logo?
                LEA.L   $00007700,A1
                LEA.L   copper_colours(PC),A2                       ; Get copper bitplane display colours. addr $000014B8

.set_background_disk_image
                BSR.W   unpack_disk_logo                            ; calls $0000153C
                
.set_disk1_or_2
                LEA.L   L00002254(PC),A0                            ; A0 = Image Data ptr for the number '1'
                MOVEA.L (A7),A1                                     ; A1 = Get Disk Name string ptr
                CMP.B   #$30,$000f(A1)                              ; #$30 = '0' - Check if disk number at end of disk name is '0' 
                BEQ.B   .copy_disk_number                           ; if '0' continue to copy number to disk  image, jmp $000013D8
.disk_2
                LEA.L   $0070(A0),A0                                ; A0 = Updated Image Data ptr for the number 2

.copy_disk_number
                LEA.L   $00007700,A1                                ; A1 = 
                ADDA.W  #$1643,A1
                MOVE.L  #$0000000d,D0                               ; 13 + 1 - loop counter (14 scan lines high x 16 pixels wide)
.disk_number_loop
                MOVE.B  (A0)+,$0000(A1)                             ; Bitplane 1
                MOVE.B  (A0)+,$0001(A1)
                MOVE.B  (A0)+,$2800(A1)                             ; Bitplane 2
                MOVE.B  (A0)+,$2801(A1)
                MOVE.B  (A0)+,$5000(A1)                             ; Bitplane 3
                MOVE.B  (A0)+,$5001(A1)
                MOVE.B  (A0)+,$7800(A1)                             ; Bitplane 4
                MOVE.B  (A0)+,$7801(A1)
                SUBA.W  #$0028,A1                                   ; Increase base bitplane ptr offset by 40 bytes (320 pixels = one scan line)
                DBF.W   D0,.disk_number_loop

.display_insert_disk
                LEA.L   $00dff000,A6                                ; A6 = custom base
                LEA.L   COLOR00(A6),A0                              ; A0 = colour 00 register
                MOVE.L  #$0000001f,D0                               ; 31 + 1 - loop counter
.clear_loop
                CLR.W   (A0)+                                       ; Clear Colopur Register (CLR not good to use on Write only Custom Chip Register)
                DBF.W   D0,.clear_loop                              ; clear pallete loop, $00001418 (no need as copper will refresh colours at top of each frame)

.set_up_display
                MOVE.W  #$0000,BPL1MOD(A6)                          ; Bitplane Modulo 0 
                MOVE.W  #$0000,BPL2MOD(A6)                          ; Bitplane Modulo 1
                MOVE.W  #$0038,DDFSTRT(A6)                          ; Bitplane Data DMA Fetch Start
                MOVE.W  #$00d0,DDFSTOP(A6)                          ; Bitplane Data DMA Fetch Stop
                MOVE.W  #$4481,DIWSTRT(A6)                          ; Display Window Start
                MOVE.W  #$0cc1,DIWSTOP(A6)                          ; Display Window Stop
                MOVE.W  #$4200,$0100(A6)                            ; 4 bitplane display, Color On, (16 colour display)
                LEA.L   copper_list(PC),A0                          ; A0 = Copper List 1 Address
                MOVE.L  A0,$0080(A6)                                ; Set Copper List 1 
                LEA.L   copper_endwait(PC),A0                       ; A0 = Copper List 2 Address (End Wait) addr: $00001538
                MOVE.L  A0,$0084(A6)                                ; Set Copper List 2
                MOVE.W  A0,$008a(A6)                                ; Strobe Copper Jump 2 - Force Copper to execute copper 2 (will revert to copper 1 on next frame)
                MOVE.W  #$8180,$0096(A6)                          ; Enable Copper & Bitplane DMA
.disk_wait_loop
                CLR.W   ciab_tb_20ms_tick                           ; reset 20ms timer tick counter
.timer_wait_loop
                CMP.W   #$0032,ciab_tb_20ms_tick                    ; #$ = 50 (50 x 20 = 1000ms) 1 second wait loop
                BCS.B   .timer_wait_loop                            ; busy wait for 1 second

                MOVEA.L (A7),A0                                     ; Disk Name String Ptr
                BSR.W   load_filetable                              ; Load the Disk File Table, calls $000015DE
                BNE.B   .disk_wait_loop                             ; Z = 0, then not correct disk in the drive
.clear_display
                LEA.L   $00dff000,A6
                MOVE.W  #$0200,$0100(A6)                            ; BPLCON = 0 bitplanes display (switch off all bitplane DMA channels)
                MOVE.W  #$0180,$0096(A6)                          ; disbale copper & bitplane DMA
.exit                
                MOVEA.L (A7)+,A0                                    ; restore A0 = disk name string ptr
                RTS 





                    ;------------------- loader copper list -------------------------
                    ; used to display change disk screen & loading picture

copper_list     ; copper-list - set bitplane pointers -  relocated address $00001490
                dc.w    BPL1PTH, $0000                      ; bit-plane 1 ptr
                dc.w    BPL1PTL, $7700              
                dc.w    BPL2PTH, $0000                      ; bit-plane 2 ptr
                dc.w    BPL2PTL, $9F00
                dc.w    BPL3PTH, $0000                      ; bit-plane 3 ptr
                dc.w    BPL3PTL, $C700
                dc.w    BPL4PTH, $0000                      ; bit-plane 4 ptr
                dc.w    BPL4PTL, $EF00
                dc.w    BPL5PTH, $0001                      ; bit-plane 5 ptr
                dc.w    BPL5PTL, $1700        
copper_colours  ; copper-list - set bitplane colour pallette - relocated address: $000014B8
                dc.w    COLOR00, $0000, COLOR01, $0000, COLOR02, $0000, COLOR03, $0000
                dc.w    COLOR04, $0000, COLOR05, $0000, COLOR06, $0000, COLOR07, $0000
                dc.w    COLOR08, $0000, COLOR09, $0000, COLOR10, $0000, COLOR11, $0000
                dc.w    COLOR12, $0000, COLOR13, $0000, COLOR14, $0000, COLOR15, $0000
                dc.w    COLOR16, $0000, COLOR17, $0000, COLOR18, $0000, COLOR19, $0000
                dc.w    COLOR20, $0000, COLOR21, $0000, COLOR22, $0000, COLOR23, $0000
                dc.w    COLOR24, $0000, COLOR25, $0000, COLOR26, $0000, COLOR27, $0000
                dc.w    COLOR28, $0000, COLOR29, $0000, COLOR30, $0000, COLOR31, $0000       
copper_endwait  ; copper-list - copper end - relocated address: $00001538
                ; also used to set second copper list address to an empty copper list.
                dc.w    $FFFF, $FFFE                            




                ;----------------------- unpack disk logo -------------------------
                ;-- unpack the insert disk image into memory buffer for later use
                ;-- appears to implement a basic compression supporting the
                ;-- insertion of repeating word values to reconstruct the image.
                ;-- *** needs more work to understand fully ***
                ;-- IN: A0 = Compressed Logo
                ;-- IN: A1 = $7700 - Uncompressed logo buffer
                ;-- IN: A2 = Copper List Colours
                ;--
unpack_disk_logo:
                MOVEM.L D0-D1/D7/A0-A3,-(A7)
                MOVE.B  (A0)+,D0                        ; get first data byte
                CMP.B   #$03,D0                         ; compare the first data byte with the value #3                  
                BCS.B   .skip_add_addr                  ; if D0.b < #03 then skip add instruction (what's the significance of #$03??)
.add_addr       ADDA.L  #$00000004,A0                   ; else, add 4 bytes to the address pointer
.skip_add_addr
                MOVE.L  #$0000000f,D0                   ; 15 + 1 loop counter (16 colours)
.set_colour_loop
                ADDA.W  #$00000002,A2
                MOVE.B  (A0)+,(A2)+
                MOVE.B  (A0)+,(A2)+
                LSL.W   -$0002(A2)                      ; correct colours by multiplying them by 2
                DBF.W   D0,.set_colour_loop             ; $0000154C - set first 16 of 32 copper colour registers.

                ; get next word from logo data into d7 
                MOVE.B  (A0)+,D7                        ; set d7 with low byte value
                ASL.W   #$00000008,D7                   ; shift d7 into high byte
                MOVE.B  (A0)+,D7                        ; set d7 with high byte value

                ADDA.L  #$00000002,A0                   ; skip next word in data structure

                LEA.L   $00(A0,D7.W),A2                 ; D7 is an index into the logo data, A2 = new data pointer
                SUB.W   #$0001,D7                       ; decrement index.
                BMI.B   .exit                           ; if index is negative then exit, jmp $000015B6

                LEA.L   $1f40(A1),A3                    ; A3 = $7700 + $1f40 = $9640 - ($1f40 - 8000) (8000/40 = 200 - could be bitplane size) 

  
                ; basic unpacker replacing repeating values
                ; d7 = outer loop counter
                ; a0/a2 = source logo data
                ; a1/a3 = dest logo data
.outer_loop
                MOVE.B  (A0)+,D0                        ; get command byte
                BMI.B   .copy_multiple_words            ; if byte < 0,  jmp $001584  (copy x words from source -> dest) 
                BEQ.B   .copy_repeating_word            ; if byte == 0, jmp $0001596 (insert x repeating words -> dest)                                                      
                CMP.B   #$01,D0                             
                BNE.B   .copy_one_word                  ; if byte == 1, jmp $00015A0 (copy 1 word from source -> dest)
.copy_multiple_words2
                MOVE.B  (A0)+,D0                        ; else (copy large number of words from source -> dest)
                ASL.W   #$00000008,D0
                MOVE.B  (A0)+,D0
                SUB.W   #$00000002,D7                   ; subtract 2 from outer loop counter
                BRA.B   .copy_bytes                     
.copy_multiple_words                                    ; copy multiple words from source to destination
                NEG.B   D0                              ; make counter positive.
                EXT.W   D0                              ; make counter positive word.

.copy_bytes     ; d0 = .loop1 counter, d7 = .outer_loop counter
                SUB.W   #$0001,D0                      ; subtract 1 from the counter
.loop1
                MOVE.B  (A2)+,(A1)+                     ; copy source byte data (gfx?) to dest a1 ($7700 first interation)
                MOVE.B  (A2)+,(A1)+                     ; copy source byte data (gfx?) to dest a1 ($7700 first interation)
                BSR.B   update_dest_bitplane_ptr        ; call $000015BC
                DBF.W   D0,.loop1                                ; $0000158A

                BRA.B   .next_outer_loop


.copy_repeating_word
                MOVE.B  (A0)+,D0
                ASL.W   #$00000008,D0
                MOVE.B  (A0)+,D0                        ; d0 = repeat count
                SUB.W   #$00000002,D7                   ; d7 = outer loop count
                BRA.B   .get_repeating_value        
.copy_one_word
                EXT.W   D0                              ; d0 = 1, extend to word 

.get_repeating_value
                SUB.W   #$0001,D0                       ; decrement loop counter
                MOVE.B  (A2)+,D1
                ASL.W   #$00000008,D1
                MOVE.B  (A2)+,D1                        ; D1 = repeating word value

.repeating_word_loop
                MOVE.W  D1,(A1)+                        ; copy repeating word to destination address
                BSR.B   update_dest_bitplane_ptr        ; $000015BC
                DBF.W   D0,.repeating_word_loop         ; $000015AA

.next_outer_loop
                DBF.W   D7,.outer_loop                          ; $0000156E

.exit
                MOVEM.L (A7)+,D0-D1/D7/A0-A3
                RTS 


                ; ------------------------ update destination bitplane pointers -------------------------
                ; Best I can make out is that the source data might bbe arranged in columns and not
                ; scanlines, this routine appears to be increasing the destination pointer by one
                ; scanline on each loop. This implies that the disk image is being reconstructed
                ; one column at a time, from  left to right and top to bottom of the screen.
                ; (maybe some Atari ST bullshit format? who knows, maybe i'm just wrong.)
                ;
                ; Data seems to be unpacked one bitplane at a time. When the destination address reached the
                ; bottom of a column, then the ptr is updated to the top of the next column by subtracting
                ; the size of the bitplane-2 from the current address #$1f3e.
                ;
                ; When the end of the last column is reached then a large ptr adjustment is made, by subtracting
                ; 55336 bytes from the destination ptr (this leads me to believe that i'm missing something here
                ; because thats a bit number (almost 64K))
                ;
                ; d0 = loop counter
                ; A1 = destinaiton address buffer e.g. $7700
                ; A3 = another address buffer e.g.     $9640 ($7700 + $1F40)
                ;
update_dest_bitplane_ptr                                    ; relocated routine address: $000015BC
                MOVE.L  D0,-(A7)
                LEA.L   $0026(A1),A1        ; add 38 to destination address (40 + previously copied word) - scanline 320 wide screen
                MOVE.L  A1,D0               ; copy destination address to D0.L
                SUB.L   A3,D0               ; subtract start of next bitplane address from lower address
                BCS.B   .exit               ; if not at end of current bitplane yet then exit

.reset_dest_column                          ; jump to top of next bitplane column
                SUBA.W  #$1f3e,A1           ; update pointer back to 2nd word of source data
                CMP.W   #$0026,D0           ; #$26 = 38, test which column of data was just completed.
                BCS.B   .exit               ; If not last column of bitplane image data then exit. $000015DA
.next_bitplane
                SUBA.W  #$d828,A1           ; else (reset destination ptr 55336 bytes (thats a lot))
                LEA.L   $1f40(A1),A3        ; Increase boundary limit to start of next highest bitplane.
.exit
                MOVE.L  (A7)+,D0
                RTS 






                ;--------------------------- load file table --------------------------
                ;-- Checks the disk name and loads the file table for the disk name
                ;-- passed in here.
                ;-- IN: A0 - ptr to diskname string
                ;-- OUT: Z=1 - success
                ;--
                ;-- State:
                ;-- #$00002CD6,ld_decoded_track_ptr
                ;-- #$000042D6,ld_mfmencoded_track_ptr
                ;-- #$00002AD6,ld_filetable 
                ;--
load_filetable                                                  ; relocated address $000015DE
                MOVE.L  A0,-(A7)                                ; A0 = ptr to disk name string
                MOVE.W  #$0004,ld_drive_number                  ; $00001AFC ; $1AFC - drive number?
.select_next_drive
                MOVE.W  #$0005,ld_load_status                   ; $00001B08 ; set loader status
                MOVE.W  ld_drive_number,D0                      ; $00001AFC,D0 ; D0.w - drive number (initial value = 4)
.select_loop    SUB.W   #$00000001,D0                           ; decrement by 1 (initial value = 3)
                BMI.W   .exit                                   ; no drives left available, jmp $00001648 
                BTST.B  D0,ld_drive_bits_byte                   ; $00001AFB ; Bit field of available disk drives (initial check bit 3)
                BEQ.B   .select_loop                            ; $000015F6 ; If Drive is not available then loop next drive. (count from 3 to 0)

.select_drive   MOVE.W  D0,ld_drive_number                      ; $00001AFC ; store available drive number.

.init_drive
                BSR.W   drive_motor_on                          ; Drive Motor On: routine addr: $00001B68
                BSR.W   seek_track0                             ; calls $00001BAE
                BNE.B   .error                                  ; z = 0, error so jmp $0000163C
.load_filetable
                SF.B    ld_track_status                         ; $00001AF0
                MOVE.L  #$00000002,D0                           ; Sector Number of File Table
                BSR.W   load_decode_track                       ; calls $00001B0A
                BNE.B   .error                                  ; Z = 0, error so jmp $0000163C
.chk_diskname
                MOVEA.L (A7),A1                                 ; A1 = diskname pointer; A0 = loaded data address
                MOVE.L  #$0000000f,D0                           ; DiskName = 16 bytes
.diskname_loop
                CMPM.B  (A0)+,(A1)+                             ; compare disk name characters
                DBNE.W  D0,.diskname_loop                       ; disk name check loop $L00001626
                BNE.B   .error                                  ; final CCR check, if not equal, jmp $0000163C
.filetable_copy
                MOVEA.L ld_filetable,A1                         ; get file table address
                MOVE.L  #$0000007b,D0                           ; loop counter 123 + 1 (124 x 4 = 496). 496/16 = 31 (Max number of file table entries?)
.copy_loop
                MOVE.L  (A0)+,(A1)+                             ; copy file table data 
                DBF.W   D0,.copy_loop                           ; $00001634 ; loop for 124 long words
                BRA.B   .exit                                   ; bra $00001648
.error
                MOVE.W  ld_drive_number,D0                      ; $00001AFC
                BSR.W   drive_motor_off                         ; L00001B7A
                BRA.B   .select_next_drive                      ; try again with the next available disk drive, jmp $000015E8
.exit
                MOVEA.L (A7)+,A0                                ; relocated address $00001648
                TST.W   ld_load_status                          ; $00001B08 ; test load status ( z = 1 - success )
                RTS 


                ;------------------------ load file entries ------------------------
                ;-- loads files in to memory, starting at top of memory $7C7FC
                ;-- loads files from load parameter block, starting with the
                ;-- last file in the structure.
                ;--
                ;-- so, the last file is loaded at $7C7FC - filelen,
                ;--   , the next file is loaded at $7C7FC - filelen - filelen,
                ;--   , and so on, until all files are loaded in from disk.
                ;--
                ;-- parameters:
                ;-- IN: A0 = Entry to first file to load in the file list.
                ;-- IN: A6 = Top of load file buffer - (initially 0007C7FC) -grows downwards with each file loaded
                ;
load_file_entries                                       ; this routine's relocated address: $00001652
                MOVE.L  A0,-(A7)                        ; store address to file entry
                TST.W   (A0)                            ; if end of file entries?
                BEQ.B   .exit                           ;  - then exit - $000016D6
                LEA.L   $000e(A0),A0                    ;  - else calc address of next file entry in list
                BSR.B   load_file_entries               ;     & recursive call to self. addr $00001652 
                BNE.B   .exit                           ; if 'load status' is not equal 0 then exit. addr $000016D6

.prep_table_search
                MOVEA.L (A7),A0                         ; A0 = ptr for file entry
                ADDA.W  (A0),A0                         ; A0 = ptr to file name string to find in disk file table (disk directory)
                MOVEA.L ld_filetable,A1                 ; A1 = file table (disk directory)
                MOVE.L  #$0000001e,D0                   ; D0 = loop counter 30 + 1

.file_table_loop   
                MOVEA.L A0,A2                           ; A2 = copy ptr to to file name - $0000166A 
                MOVEA.L A1,A3                           ; A3 = copy ptr to file table

.compare_filename                                       ; relocated address: $0000166E
                MOVE.L  #$0000000a,D1                   ; D1 = loop counter 10 + 1 (filenames are 11 characters long)
.file_loop      CMPM.B  (A2)+,(A3)+                     ; compare file name character with file table entry. addr $00001670
                DBNE.W  D1,.file_loop                   ; loop next file name character
                BEQ.B   .filefound                      ; file table entry found....

                LEA.L   $0010(A1),A1                    ; increment to start of next file table entry
                DBF.W   D0,.file_table_loop             ; decrement file table search loop

                MOVE.W  #$0005,ld_load_status           ; $00001B08 ; set 'load status' = 5 - file not found
                BRA.B   .exit                           ; $000016D6


                ; file table entry has been found
                ; A0 = File Entry to load
                ;       0 - 2 Bytes - File Name Offset
                ;       2 - 4 bytes - File reloacation address
                ;       6 - 4 bytes - File Length Stored below from file table
                ;       a - 4 bytes - File Load Address stored below
                ; A3 = File Table Entry
                ;       - 11 characters = filename
                ;       - 3 bytes = 24 bit file length
                ;       - 2 bytes = start sector number
.filefound                                              ; relocated address: $0000168A 
.L0000168A       MOVEA.L (A7),A0                        ; File Entry to load
.L0000168C       MOVE.L  $000a(A1),D2                   ; Get File Length (and last character of filename) from file table (disk directory)
.L00001690       AND.L   #$00ffffff,D2                  ; D2 = 24 bit file length mask
.L00001696       MOVE.L  D2,$0006(A0)                   ; Save File length into Level Load Parameters current file entry (2nd long word)
.L0000169A       BEQ.B   .exit                          ; If file length is 0 then exit.

.L0000169C       MOVE.W  $000e(A1),D1                   ; D1 = start sector of file on disk
.L000016A0       MOVE.L  D2,D0                          ; D2,D0 = File Length in Bytes

.L000016A2       BTST.L  #$0000,D0                      ; Is file odd byte length?
.L000016A6       BEQ.B   .L000016AA                     ; no... no padding required
.L000016A8       ADD.L   #$00000001,D0                  ; yes.. add extra byte to make file length even

.L000016AA       SUBA.L  D0,A6                          ; Subtract File Length from current top of file buffer memory (file load address into buffer)
.L000016AC       MOVEA.L A6,A1                          ; A1, A6 = file load address in to memory buffer
.L000016AE       MOVE.L  A6,$000a(A0)                   ; store file load address into level load file entry table.

.load_loop
.L000016B2       MOVE.W  D1,D0                          ; D0, D1 = start sector on disk
.L000016B4       BSR.W   load_decode_track              ; calls $00001B0A ; track/part track from disk (a6,a1 = load address, d1,d0 = start sector, a0 = file entry) routine address: $00001B0A

.L000016B8       BNE.B   .L000016D6                     ; Z = 0 = error

.L000016BA       MOVE.L  #$00000200,D0                  ; d0 = 512
.L000016C0       CMP.L   D0,D2                          ; compare d2 with file length (d2 = number of bytes remaining?)
.L000016C2       BCC.B   .L000016C6

.L000016C4       MOVE.L  D2,D0                          ; copy bytes remaining into d0
.L000016C6       SUB.L   D0,D2                          ; clear d2
.L000016C8       SUB.W   #$00000001,D0                  ; decrement bytes remaining by 1
.L000016CA       MOVE.B  (A0)+,(A1)+
.L000016CC       DBF.W   D0,.L000016CA

.L000016D0       ADD.W   #$0001,D1                      ; Add 1 to track number
.L000016D2       TST.L   D2                             ; If bytes remaining
.L000016D4       BNE.B   .L000016B2                     ; yes... load next track/part track
                                                        ; no.... exit
.exit
.L000016D6       MOVEA.L (A7)+,A0                       ; A0 = entry to first file entry to load (restored from stack)
.L000016D8       TST.W   ld_load_status                 ; $00001B08 ; test 'load status' and exit.
.L000016DE       RTS 







                ;--------------------- processs files ----------------------
                ; process/relocate loaded files into memory
process_file                                        ; relocated address: $000016E0
                MOVEM.L D0/A0,-(A7)
L000016E4       TST.L   D0
L000016E6       BEQ.B   L00001704
L000016E8       CMP.L   #$0000000c,D0
L000016EE       BCS.B   L00001702
L000016F0       MOVE.L  (A0),D1
L000016F2       CMP.L   #$464f524d,D1
L000016F8       BEQ.B   L0000171C
L000016FA       CMP.L   #$43415420,D1
L00001700       BEQ.B   L0000171C
L00001702       BSR.B   L0000170A
L00001704       MOVEM.L (A7)+,D0/A0
L00001708       RTS 


L0000170A       MOVEA.L ld_relocate_addr,A1                     ; $00000CF0
L0000170E       ASR.L   #$00000001,D0
L00001710       MOVE.W  (A0)+,(A1)+
L00001712       SUB.L   #$00000001,D0
L00001714       BNE.B   L00001710
L00001716       MOVE.L  A1,ld_relocate_addr                     ; $00000CF0
L0000171A       RTS


L0000171C       TST.L   D0
L0000171E       BEQ.B   L0000172A
L00001720       MOVE.L  (A0)+,D1
L00001722       SUB.L   #$00000004,D0
L00001724       BSR.W   L00001730
L00001728       BRA.B   L0000171C
L0000172A       MOVEM.L (A7)+,D0/A0
L0000172E       RTS


L00001730       CMP.L   #$464f524d,D1
L00001736       BEQ.W   L00001766
L0000173A       CMP.L   #$43415420,D1
L00001740       BEQ.W   L00001748
L00001744       CLR.L   D0
L00001746       RTS 


L00001748       MOVEM.L D0/A0,-(A7)
L0000174C       MOVE.L  (A0)+,D0
L0000174E       MOVE.L  D0,D1
L00001750       BTST.L  #$0000,D1
L00001754       BEQ.B   L00001758
L00001756       ADD.L   #$00000001,D1
L00001758       ADD.L   #$00000004,D1
L0000175A       ADD.L   D1,$0004(A7)
L0000175E       SUB.L   D1,(A7)
L00001760       ADDA.L  #$00000004,A0
L00001762       SUB.L   #$00000004,D0
L00001764       BRA.B   L0000171C
L00001766       MOVEM.L D0/A0,-(A7)
L0000176A       MOVE.L  (A0)+,D0
L0000176C       MOVE.L  D0,D1
L0000176E       BTST.L  #$0000,D1
L00001772       BEQ.B   L00001776
L00001774       ADD.L   #$00000001,D1
L00001776       ADD.L   #$00000004,D1
L00001778       ADD.L   D1,$0004(A7)
L0000177C       SUB.L   D1,(A7)
L0000177E       MOVE.L  (A0)+,D1
L00001780       SUB.L   #$00000004,D0
L00001782       CMP.L   #$20202020,D1
L00001788       BEQ.W   L000017A6
L0000178C       CMP.L   #$48554646,D1
L00001792       BEQ.W   L00001816
L00001796       CMP.L   #$494c424d,D1
L0000179C       BEQ.W   L0000193E
L000017A0       MOVEM.L (A7)+,D0/A0
L000017A4       RTS 


L000017A6       TST.L   D0
L000017A8       BEQ.B   L000017B4
L000017AA       MOVE.L  (A0)+,D1
L000017AC       SUB.L   #$00000004,D0
L000017AE       BSR.W   L000017BA
L000017B2       BRA.B   L000017A6
L000017B4       MOVEM.L (A7)+,D0/A0
L000017B8       RTS 


L000017BA       CMP.L   #$464f524d,D1
L000017C0       BEQ.B   L00001766
L000017C2       CMP.L   #$43415420,D1
L000017C8       BEQ.W   L00001748
L000017CC       CMP.L   #$424f4459,D1
L000017D2       BEQ.W   L000017F4
L000017D6       MOVEM.L D0/A0,-(A7)
L000017DA       MOVE.L  (A0)+,D0
L000017DC       MOVE.L  D0,D1
L000017DE       BTST.L  #$0000,D1
L000017E2       BEQ.B   L000017E6
L000017E4       ADD.L   #$00000001,D1
L000017E6       ADD.L   #$00000004,D1
L000017E8       ADD.L   D1,$0004(A7)
L000017EC       SUB.L   D1,(A7)
L000017EE       MOVEM.L (A7)+,D0/A0
L000017F2       RTS 


L000017F4       MOVEM.L D0/A0,-(A7)
L000017F8       MOVE.L  (A0)+,D0
L000017FA       MOVE.L  D0,D1
L000017FC       BTST.L  #$0000,D1
L00001800       BEQ.B   L00001804
L00001802       ADD.L   #$00000001,D1
L00001804       ADD.L   #$00000004,D1
L00001806       ADD.L   D1,$0004(A7)
L0000180A       SUB.L   D1,(A7)
L0000180C       BSR.W   L0000170A
L00001810       MOVEM.L (A7)+,D0/A0
L00001814       RTS 


L00001816       CLR.L   -(A7)
L00001818       CLR.L   -(A7)
L0000181A       CLR.L   -(A7)
L0000181C       MOVE.L  A6,-(A7)
L0000181E       MOVEA.L A7,A6
L00001820       TST.L   D0
L00001822       BEQ.B   L0000182E
L00001824       MOVE.L  (A0)+,D1
L00001826       SUB.L   #$00000004,D0
L00001828       BSR.W   L00001856
L0000182C       BRA.B   L00001820
L0000182E       TST.L   $0004(A6)
L00001832       BEQ.B   L0000184A
L00001834       TST.L   $0008(A6)
L00001838       BEQ.B   L0000184A
L0000183A       TST.L   $000c(A6)
L0000183E       BEQ.B   L0000184A
L00001840       MOVEM.L $0004(A6),D0/A0-A1
L00001846       BSR.W   L0000190C
L0000184A       MOVEA.L (A7)+,A6
L0000184C       LEA.L   $000c(A7),A7
L00001850       MOVEM.L (A7)+,D0/A0
L00001854       RTS 


L00001856       CMP.L   #$464f524d,D1
L0000185C       BEQ.W   L00001766
L00001860       CMP.L   #$43415420,D1
L00001866       BEQ.W   L00001748
L0000186A       CMP.L   #$53495a45,D1
L00001870       BEQ.W   L000018A6
L00001874       CMP.L   #$434f4445,D1
L0000187A       BEQ.W   L000018C8
L0000187E       CMP.L   #$54524545,D1
L00001884       BEQ.W   L000018EA
L00001888       MOVEM.L D0/A0,-(A7)
L0000188C       MOVE.L  (A0)+,D0
L0000188E       MOVE.L  D0,D1
L00001890       BTST.L  #$0000,D1
L00001894       BEQ.B   L00001898
L00001896       ADD.L   #$00000001,D1
L00001898       ADD.L   #$00000004,D1
L0000189A       ADD.L   D1,$0004(A7)
L0000189E       SUB.L   D1,(A7)
L000018A0       MOVEM.L (A7)+,D0/A0
L000018A4       RTS 


L000018A6       MOVEM.L D0/A0,-(A7)
L000018AA       MOVE.L  (A0)+,D0
L000018AC       MOVE.L  D0,D1
L000018AE       BTST.L  #$0000,D1
L000018B2       BEQ.B   L000018B6
L000018B4       ADD.L   #$00000001,D1
L000018B6       ADD.L   #$00000004,D1
L000018B8       ADD.L   D1,$0004(A7)
L000018BC       SUB.L   D1,(A7)
L000018BE       MOVE.L  (A0)+,$0004(A6)
L000018C2       MOVEM.L (A7)+,D0/A0
L000018C6       RTS 


L000018C8       MOVEM.L D0/A0,-(A7)
L000018CC       MOVE.L  (A0)+,D0
L000018CE       MOVE.L  D0,D1
L000018D0       BTST.L  #$0000,D1
L000018D4       BEQ.B   L000018D8
L000018D6       ADD.L   #$00000001,D1
L000018D8       ADD.L   #$00000004,D1
L000018DA       ADD.L   D1,$0004(A7)
L000018DE       SUB.L   D1,(A7)
L000018E0       MOVE.L  A0,$0008(A6)
L000018E4       MOVEM.L (A7)+,D0/A0
L000018E8       RTS 


L000018EA       MOVEM.L D0/A0,-(A7)
L000018EE       MOVE.L  (A0)+,D0
L000018F0       MOVE.L  D0,D1
L000018F2       BTST.L  #$0000,D1
L000018F6       BEQ.B   L000018FA
L000018F8       ADD.L   #$00000001,D1
L000018FA       ADD.L   #$00000004,D1
L000018FC       ADD.L   D1,$0004(A7)
L00001900       SUB.L   D1,(A7)
L00001902       MOVE.L  A0,$000c(A6)
L00001906       MOVEM.L (A7)+,D0/A0
L0000190A       RTS 


L0000190C       MOVEA.L ld_relocate_addr,A2                 ; $00000CF0
L00001910       MOVEM.L D0/A2,-(A7)
L00001914       MOVE.L  #$0000000f,D1
L00001916       MOVE.W  (A0)+,D2
L00001918       MOVEA.L A1,A3
L0000191A       ADD.W   D2,D2
L0000191C       BCC.B   L00001920
L0000191E       ADDA.W  #$00000002,A3
L00001920       DBF.W   D1,L00001928
L00001924       MOVE.L  #$0000000f,D1
L00001926       MOVE.W  (A0)+,D2
L00001928       MOVE.W  (A3),D3
L0000192A       BMI.B   L00001930
L0000192C       ADDA.W  D3,A3
L0000192E       BRA.B   L0000191A
L00001930       MOVE.B  D3,(A2)+
L00001932       SUB.L   #$00000001,D0
L00001934       BNE.B   L00001918
L00001936       MOVEM.L (A7)+,D0/A0
L0000193A       BRA.W   process_file                    ; recursively calls $000016E0
L0000193E       TST.L   D0
L00001940       BEQ.B   L0000194C
L00001942       MOVE.L  (A0)+,D1
L00001944       SUB.L   #$00000004,D0
L00001946       BSR.W   L00001952
L0000194A       BRA.B   L0000193E
L0000194C       MOVEM.L (A7)+,D0/A0
L00001950       RTS


L00001952       CMP.L   #$464f524d,D1
L00001958       BEQ.W   L00001766
L0000195C       CMP.L   #$43415420,D1
L00001962       BEQ.W   L00001748
L00001966       CMP.L   #$434d4150,D1
L0000196C       BEQ.W   L000019B8
L00001970       CMP.L   #$424d4844,D1
L00001976       BEQ.W   L00001A0C
L0000197A       CMP.L   #$424f4459,D1
L00001980       BEQ.W   L00001A32
L00001984       CMP.L   #$47524142,D1
L0000198A       BEQ.B   L0000199A
L0000198C       CMP.L   #$44455354,D1
L00001992       BEQ.B   L0000199A
L00001994       CMP.L   #$43414d47,D1
L0000199A       MOVEM.L D0/A0,-(A7)
L0000199E       MOVE.L  (A0)+,D0
L000019A0       MOVE.L  D0,D1
L000019A2       BTST.L  #$0000,D1
L000019A6       BEQ.B   L000019AA
L000019A8       ADD.L   #$00000001,D1
L000019AA       ADD.L   #$00000004,D1
L000019AC       ADD.L   D1,$0004(A7)
L000019B0       SUB.L   D1,(A7)
L000019B2       MOVEM.L (A7)+,D0/A0
L000019B6       RTS 


L000019B8       MOVEM.L D0/A0,-(A7)
L000019BC       MOVE.L  (A0)+,D0
L000019BE       MOVE.L  D0,D1
L000019C0       BTST.L  #$0000,D1
L000019C4       BEQ.B   L000019C8
L000019C6       ADD.L   #$00000001,D1
L000019C8       ADD.L   #$00000004,D1
L000019CA       ADD.L   D1,$0004(A7)
L000019CE       SUB.L   D1,(A7)
L000019D0       DIVU.W  #$0003,D0
L000019D4       BEQ.B   L00001A02
L000019D6       SUB.W   #$00000001,D0
L000019D8       LEA.L   copper_colours(PC),A1                            ; get bit-place display colours. addr $000014B8
L000019DC       MOVE.L  #$00000000,D1
L000019DE       MOVE.L  #$00000000,D2
L000019E0       MOVE.B  (A0)+,D2
L000019E2       LSR.W   #$00000004,D2
L000019E4       OR.W    D2,D1
L000019E6       ROL.W   #$00000004,D1
L000019E8       MOVE.L  #$00000000,D2
L000019EA       MOVE.B  (A0)+,D2
L000019EC       LSR.W   #$00000004,D2
L000019EE       OR.W    D2,D1
L000019F0       ROL.W   #$00000004,D1
L000019F2       MOVE.L  #$00000000,D2
L000019F4       MOVE.B  (A0)+,D2
L000019F6       LSR.W   #$00000004,D2
L000019F8       OR.W    D2,D1
L000019FA       ADDA.L  #$00000002,A1
L000019FC       MOVE.W  D1,(A1)+
L000019FE       DBF.W   D0,L000019DC
L00001A02       MOVEM.L (A7)+,D0/A0
L00001A06       RTS 

L00001A08       dc.w    $0000, $0000

L00001A0C       MOVEM.L D0/A0,-(A7)
L00001A10       MOVE.L  (A0)+,D0
L00001A12       MOVE.L  D0,D1
L00001A14       BTST.L  #$0000,D1
L00001A18       BEQ.B   L00001A1C
L00001A1A       ADD.L   #$00000001,D1
L00001A1C       ADD.L   #$00000004,D1
L00001A1E       ADD.L   D1,$0004(A7)
L00001A22       SUB.L   D1,(A7)
L00001A24       MOVE.L  A0,L00001A08
L00001A28       MOVEM.L (A7)+,D0/A0
L00001A2C       RTS 

L00001A2E       dc.w    $0000, $0000

L00001A32       MOVEM.L D0/A0,-(A7)
L00001A36       MOVE.L  (A0)+,D0
L00001A38       MOVE.L  D0,D1
L00001A3A       BTST.L  #$0000,D1
L00001A3E       BEQ.B   L00001A42
L00001A40       ADD.L   #$00000001,D1
L00001A42       ADD.L   #$00000004,D1
L00001A44       ADD.L   D1,$0004(A7)
L00001A48       SUB.L   D1,(A7)
L00001A4A       LEA.L   $00007700,A1
L00001A50       MOVEA.L L00001A08,A2
L00001A54       TST.B   $0009(A2)
L00001A58       BNE.B   L00001A82
L00001A5A       CMP.B   #$02,$000a(A2)
L00001A60       BCC.B   L00001A82
L00001A62       MOVE.L  #$00000000,D0
L00001A64       MOVE.B  $0008(A2),D0
L00001A68       SUB.W   #$00000001,D0
L00001A6A       MOVE.W  D0,L00001A88
L00001A70       MOVEM.W (A2),D6-D7
L00001A74       MOVE.B  $000a(A2),D5
L00001A78       ASR.W   #$00000004,D6
L00001A7A       ADD.W   D6,D6
L00001A7C       SUB.W   #$00000001,D7
L00001A7E       BSR.W   L00001A8A
L00001A82       MOVEM.L (A7)+,D0/A0
L00001A86       RTS 

L00001A88       dc.w    $0000

L00001A8A       SUBA.W  D6,A7
L00001A8C       MOVE.W  D6,D4
L00001A8E       CMP.W   #$0028,D4
L00001A92       BLE.B   L00001A96
L00001A94       MOVE.L  #$00000028,D4
L00001A96       ASR.W   #$00000001,D4
L00001A98       SUB.W   #$00000001,D4
L00001A9A       MOVEA.L A1,A2
L00001A9C       MOVE.W  L00001A88,D3
L00001AA0       MOVEA.L A7,A3
L00001AA2       MOVE.W  D6,D2
L00001AA4       TST.B   D5
L00001AA6       BNE.B   L00001AAE
L00001AA8       MOVE.W  D2,D0
L00001AAA       SUB.W   #$00000001,D0
L00001AAC       BRA.B   L00001AC6
L00001AAE       CLR.W   D0
L00001AB0       MOVE.B  (A0)+,D0
L00001AB2       BPL.B   L00001AC6
L00001AB4       NEG.B   D0
L00001AB6       BVS.B   L00001AAE
L00001AB8       MOVE.B  (A0)+,D1
L00001ABA       MOVE.B  D1,(A3)+
L00001ABC       SUB.W   #$00000001,D2
L00001ABE       DBF.W   D0,L00001ABA
L00001AC2       BNE.B   L00001AAE
L00001AC4       BRA.B   L00001AD0
L00001AC6       MOVE.B  (A0)+,(A3)+
L00001AC8       SUB.W   #$00000001,D2
L00001ACA       DBF.W   D0,L00001AC6
L00001ACE       BNE.B   L00001AAE
L00001AD0       MOVEA.L A7,A3
L00001AD2       MOVEA.L A2,A4
L00001AD4       MOVE.W  D4,D2
L00001AD6       MOVE.W  (A3)+,(A4)+
L00001AD8       DBF.W   D2,L00001AD6
L00001ADC       ADDA.W #$2800,A2
L00001AE0       DBF.W   D3,L00001AA0
L00001AE4       ADDA.W  #$0028,A1
L00001AE8       DBF.W   D7,L00001A9A
L00001AEC       ADDA.W  D6,A7
L00001AEE       RTS 






                ;---------------------------------------------------------------------------------------------------
                ;---------------------------------------------------------------------------------------------------
                ; LOW LEVEL DISK ROUTINES
                ;---------------------------------------------------------------------------------------------------
                ;---------------------------------------------------------------------------------------------------





                ;----------------------- loader variables/state ----------------------
                ;-- relocated address: $00001AF0
                even
ld_track_status                                             
                dc.b    $00                                 ; set to true when track loaded into buffer. $00001AF0

ld_unused_byte
                dc.b    $00

ld_decoded_track_ptr
                dc.l    $00000000                           ; relocated address: $00001AF2
   
ld_mfmencoded_track_ptr                             
                dc.l    $00000000                           ; relocated address: $00001AF6

ld_drive_bits_word                                          
                dc.b    $00                                 ; Available drives bit field as a word: $00001AFA
ld_drive_bits_byte                                          
                dc.b    $00                                 ; Available drives bit field as a byte: $00001AFB

ld_drive_number                         
                dc.w    $0000                               ; relocated address: $00001AFC 

ld_unused_word1 
                dc.w    $0000                               ; relocated address: $00001AFE 

ld_track_number_word                                        ; The current track number as a word. $00001B00                       
                dc.b    $00                             
ld_track_number_byte                                        ; The current track number as a byte. $00001B01
                dc.b    $00 

ld_unused_word2         
                dc.w    $0001                               ; relocated address: $00001B02 

ld_ciab_20ms_countdown                         
                dc.w    $0000                               ; relocated address: $00001B04 - CIAB Timer B - 20 millisecond count down timer tick

L00001B06       dc.w    $0000

ld_load_status
                dc.w    $0000                               ; relocated address: $00001B08




                ; ----------------------------- load track/file from disk --------------------------------
                ; load file from disk (a6,a1 = load address, d1,d0 = start sector, a0 = file entry)
                ; -- IN: D0.w - Start Sector of File
                ; -- 
                ; -- OUT: A0.L = Start of data in track buffer
                ; - used state:
                ; -- $1B00.W        - Current Selected Drive's track number
                ; -- $1AF2.L        -
load_decode_track                                   ; relocated routine address $00001B0A
                MOVEM.L D0-D1,-(A7)
L00001B0E       EXT.L   D0                          ; sign extend sector number to 32 bits (clear high word crap) 
L00001B10       DIVU.W  #$000b,D0                   ; d0 = start track number, divide start sector by 11 sectors per track.
L00001B14       MOVE.L  D0,D1                       ; copy result 
L00001B16       SWAP.W  D1                          ; D1.w = remining sectors (if first track is not all sectors)
L00001B18       TST.B   ld_track_status             ; $00001AF0 ; test file/track loaded status flag (set to true when track is loaded into memory)
L00001B1C       BEQ.B   L00001B24

L00001B1E       CMP.W   ld_track_number_word,D0     ; $00001B00 - D0 = start track, test current drive track number with required start track
L00001B22       BEQ.B   L00001B32                   ; if equal, track already loaded and decocded?

L00001B24       MOVEA.L ld_decoded_track_ptr,A0     ; Track Decoded Buffer Address. addr: $00001AF2
L00001B28       BSR.W   load_mfm_track              ; calls $00001CBC ; Load Track into Buffer (d0 = track number, d1 = remaining sectors if not whole track)
L00001B2C       BNE.B   L00001B40                   ; Z = 0 - error occurred
L00001B2E       ST.B    ld_track_status             ; $00001AF0 ; set file/track loaded status byte to $FF (true)

L00001B32       MOVEA.L ld_decoded_track_ptr,A0     ; decoded track buffer address.
L00001B36       MULU.W  #$0200,D1                   ; D1 = 512 x remaining sectors (bytes per sector)
L00001B3A       ADDA.L  D1,A0                       ; Increment A0 by remaining sectors from whole tracks
L00001B3C       CLR.W   ld_load_status              ; $00001B08 ; Clear Load Status = succcess

L00001B40       TST.W   ld_load_status              ; $00001B08 ; Test Load Status Z = 1 - success
L00001B44       MOVEM.L (A7)+,D0-D1
L00001B48       RTS 




                ;--------------------------- detect available drives -----------------------------
                ; creates a bit field of available drives at relocated address $00001afa.W
                ; each bit in the field 0-3 represent whether a drive exists (1 = drive detected)
                ;
detect_available_drives                                     ; relocated address: $00001B4A 
                MOVE.L  #$00000003,D0
                MOVE.L  #$00000000,D1
.detect_loop                                                ; relocated address: $00001B4E
                MOVEM.L D0-D1,-(A7)
                BSR.B   select_drive                        ; $00001B96
                BSR.B   seek_track0                         ; $00001BAE
                MOVEM.L (A7)+,D0-D1
                BNE.B   .check_next_drive                   ; if drive not available then skip to check next drive: bne $00001B5E

                BSET.L  D0,D1                               ; Set Available Drive Flag (bits 0-3)
.check_next_drive
                SUB.W   #$0001,D0                           ; decrement drive number:  relocated addr: $00001B5E
                BPL.B   .detect_loop 

                MOVE.W  D1,ld_drive_bits_word               ; store detected drives bit field: $00001afa
                BRA.B   deselect_all_drives                 ; end and clean up: jmp to $00001B8C




                ;---------------- drive motor on -------------------------
                ; -- selects and latches on the current drive
                ; -- IN: D0 = current drive number (0-3)
drive_motor_on                                              ; relocated address: $00001B68
                BCLR.B  #$0007,$00bfd100                    ; CIAB PRB  - clear /MTR bit (active low)
                BCLR.B  #$0007,$00bfd100                    ; CIAB PRB  - clear /MTR bit (active low)
                BRA.B   select_drive                        ; routine addr: $00001B96




                ;---------------- drive motor off -------------------------
                ; -- selects and latches off the current drive
                ; -- ends by deselecting all drives.
                ; -- IN: D0 = current drive number (0-3)
drive_motor_off                                             ; relocated address: $00001B7A
                BSET.B  #$0007,$00bfd100
                BSET.B  #$0007,$00bfd100
                BSR.B   select_drive                        ; routine addr: $00001B96




                ;---------------- deselect all drives ---------------------
deselect_all_drives                                         ; routine addr: $00001B8C
                OR.B    #$78,$00bfd100                      ; Deselect all drives (active low)
                RTS 




                ;------------------ select drive ----------------------------
                ; -- selects the current drive, used to latch motor on/off
                ; -- called from: drive_motor_on
                ; -- IN: D0 = current drive number (0-3)
select_drive                                                ; relocated address: $00001B96
                MOVE.L  D1,-(A7)                            ; store D1.L
                OR.B    #$78,$00bfd100                      ; Deselect all drives (active low)
                MOVE.B  D0,D1                               ; D0,D1 = current drive number
                ADD.B   #$03,D1                             ; Shift drive number bits
                BCLR.B  D1,$00bfd100                        ; Clear current drive select bit - active low (latch motor on/off state)
                MOVE.L  (A7)+,D1                            ; restore D1.L
                RTS 




                ;-------------------- seek track 0 ---------------------------
                ;-- reset drive heads to track 0 of currently selected drive
                ;
seek_track0                                                 ; relocated address: $00001BAE
                MOVE.W  #$0004,ld_load_status               ; $00001B08 ; set loader status (4 = step heads)
                MOVEM.L D0,-(A7)                            ; save D0.L
                MOVE.W  #$00a6,ld_track_number_word         ; $00001B00 ; Current Track = 168 (cylinder 84)
                CLR.W   D0                                  ; clear target track D0.W
                BSR.B   seek_to_track                       ; calls $00001BC8
                MOVEM.L (A7)+,D0                            ; restore D0.l
                RTS 




                ;------------------- seek to track----------------------------
                ;-- seek heads of the current drive to the required track
                ;-- sets heads to the correct cylinder and selects top/bottom
                ;-- head as required for odd/even track number
                ;-- even number (0,2,4,6...) uses bottom of the disk
                ;--
                ;-- IN: D0.W - required track number
                ;--
                ;-- OUT: CCR Z = 0 - track 0
                ;
seek_to_track                                                   ; relocated address: $00001BC8
.even_track_no  BSET.B  #$02,$00bfd100                          ; CIA PRB - SIDE = 1 (select bottom side)
                BCLR.B  #$00,ld_track_number_byte               ; make current track counter even (bottom head)                
                BTST.L  #$0000,D0                               ; is desired track even or odd?
                BEQ.B   .step_heads                              ; if desired track is even then continue, jmp $00001BEA
.odd_track_no
                BCLR.B  #$02,$00bfd100                          ; else, track is odd, so set CIAB PRA - SIDE = 0 (top head) and...
                BSET.B  #$00,ld_track_number_byte               ; make current track counter odd
.step_heads
                CMP.W   ld_track_number_word,D0                 ; is current track equal to the desired track?
                BEQ.B   .end_step                               ; calls $00001C5E
                BPL.B   .step_inwards                           ; calls $00001C18 ; current track less than than desired
.step_ouwards
                BSET.B  #$01,$00bfd100                          ; CIAB PRB - DIR = 1 (step outwards)
.step_out_loop
                BTST.B  #$04,$00bfe001                          ; are heads at track 0
                BEQ.B   .at_track0                              ;   yes.. $00001C12
                BSR.B   step_heads                              ; call $00001C68
                SUB.W   #$0002,ld_track_number_word             ; decrement track number by 2 (top & bottom)
                CMP.W   ld_track_number_word,D0                 ; test if at desired track number 
                BNE.B   .step_out_loop                          ; if not at desired track then step again, jmp $00001BFA
                BRA.B   .step_completed                         ; jmp $00001C2C
.at_track0
                CLR.W   ld_track_number_word                    ; clear current track number $00001b00
                BRA.B   .step_completed
.step_inwards
                BCLR.B  #$01,$00bfd100                          ; CIAB PRB - DIR = 0 (step inwards)
.step_in_loop
                BSR.B   step_heads                              ; calls $00001C68
                ADD.W   #$0002,ld_track_number_word             ; increment track number by 2 (top & bottom)
                CMP.W   ld_track_number_word,D0                 ; test if at desired track number
                BNE.B   .step_in_loop                           ; if not at desired track then step again, jmp $00001C20
.step_completed
                MOVE.B  #$00,$00bfde00                          ; CIAB CRA (stop timers)
                MOVE.B  #$f4,$00bfd400                          ; timer A low  = #$f4 
                MOVE.B  #$29,$00bfd500                          ; timer A high = #$29 (10740) - 15ms? not sure of timer freq (pal = 0.709379mhz)
                BCLR.B  #TIMERA_FINISHED,interrupt_flags_byte   ; clear timerA interrupt flag: $0000209A
                MOVE.B  #$19,$00bfde00                          ; CIAB CRA (start timer), LOAD = 1, RUNMODE = 1 (oneshot), START = 1
.timer_wait     BTST.B  #TIMERA_FINISHED,interrupt_flags_byte   ; test timerA interrupt flag: $0000209A
                BEQ.B   .timer_wait                             ; wait for timer $00001C54
.end_step
                BTST.B  #$0004,$00bfe001                        ; Test if Track 0, Z = 0
                RTS 




                ;----------------------- step heads ----------------------------
                ;-- step the disk heads of the currently selected drive, using
                ;-- the currently selected heads direction.
                ;-- heads are stepped by setting the STEP bit low then high (pulse)
                ;
step_heads                                                      ; relocated address: $00001C68
                MOVE.B  #$00,$00bfde00                          ; CIAB CRA (control reg A)
                MOVE.B  #$c8,$00bfd400                          ; TimerA low =  #$C8
                MOVE.B  #$10,$00bfd500                          ; TimerA High = #$10
                BCLR.B  #$00,$00bfd100                          ; clear STEP bit CIAB PRB   
                BCLR.B  #$00,$00bfd100                          ; clear STEP bit CIAB PRB 
                BCLR.B  #$00,$00bfd100                          ; clear STEP bit CIAB PRB 
                BSET.B  #$00,$00bfd100                          ; set STEP bit CIAB PRB 
                BCLR.B  #TIMERA_FINISHED,interrupt_flags_byte   ; clear timer A flag: $0000209A
                MOVE.B  #$19,$00bfde00                          ; CIAB CRA (start timer), LOAD = 1, RUNMODE = 1 (oneshot), START = 1
.timer_wait
                BTST.B  #TIMERA_FINISHED,interrupt_flags_byte   ; test timerA interrupt flag: $0000209A
                BEQ.B   .timer_wait                             ; wait for timer $00001CB0
                RTS 




                ; -------------------------- load mfm track -------------------------
                ; -- IN: D0.W - start track
                ; -- IN: D1.w - number of sectors (if not full track,  i.e. first read might start half way though track)
                ; -- IN: A0.L - decoded data buffer
                ; -- used state:
                ; --  $1AF6.L - Raw mfm buffer address
                ; --  $1B04.W - CIAB TimeB 20ms Timer Tick Counter
                ; --  $1B06.W - retry count
                ; --  $1B08.W - Load Status 
load_mfm_track
                MOVEM.L D1/A0-A1,-(A7)
                MOVE.W  #$0020,L00001B06                            ; #$20 = 32
                MOVE.W  #$0001,ld_load_status                       ; $00001B08 ; set load status

                MOVE.W  #$0032,ld_ciab_20ms_countdown               ; $00001B04 ; init timer ticks for wait = 50 x 20 = 1000 milliseconds (Disk RDY timeout)
.drv_rdy_loop   TST.W   ld_ciab_20ms_countdown                      ; $00001B04 ; addr: $00001CD2
                BEQ.B   .exit                                       ; if the counter is somehow hit 0 then exit. $00001D0E
                BTST.B  #$0005,$00bfe001                            ; test RDY bit (active low) of CIAA PRA (disk status byte)
                BNE.B   .drv_rdy_loop                               ; drive not ready yet. $00001CD2

.retrystep      BSR.W   seek_to_track                               ; calls $00001BC8 ; step heads to track addr: $00001CE2
.retryread      MOVE.W  #$0001,ld_load_status                       ; $00001B08 ; set load status value   addr: $00001CE6

                MOVEA.L ld_mfmencoded_track_ptr,A0                  ; mfm encoded track buffer
                BSR.W   dma_read_track                              ; $00001D36 ; read track using harware DMA 
                BEQ.B   .load_error                                 ; Z = 1 then error (timeout) jump addr: $00001D1C

                MOVE.W  #$0002,ld_load_status                       ; $00001B08 ; update load status
                MOVEA.L ld_mfmencoded_track_ptr,A0                  ; $00001AF6 ; A0 = raw mfm buffer address
                MOVEA.L $0004(A7),A1                                ; A1 = decoded buffer address
                BSR.W   decode_mfm_buffer                           ; calls $00001DD0 ; decode track to address
                BNE.B   .load_error                                 ; Z = 0 then error? jump addr: $00001D1C
                CLR.W   ld_load_status                              ; $00001B08 ; clear load status
.exit
                MOVEM.L (A7)+,D1/A0-A1
                LEA.L   $1600(A0),A0                                ; increment decoded data buffer pointer
                TST.W   ld_load_status                              ; $00001B08 ; test load status z = 1 = success
                RTS 

.load_error
                SUB.W   #$0001,D1                                   ; decrement retry count                               
                MOVE.W  D1,L00001B06                                ; update retry count
                BEQ.B   .exit                                       ; retry count = 0, then exit $00001D0E
                MOVE.W  L00001B06,D1                                ; D1 = retry count
                AND.W   #$0007,D1                                   ; clamp retry to 7
                BNE.B   .retryread                                  ; if retry  +ve then retry, addr: $00001CE6
                BSR.W   seek_track0                                 ; calls $00001BAE ; step heads to track 0, every 8 retries
                BEQ.B   .retrystep                                  ; retry with step to track L00001CE2
                BRA.B   .exit                                       ; jump to exit $00001D0E




                ;-------------------------- dma read track --------------------------
                ;-- IN: A0.L - MFM Track Buffer
                ;-- OUT: Z=0 - success, Z=1 - timeout
dma_read_track                                                          ; relocated address: $00001D36
                MOVEM.L D0/A0,-(A7)
                MOVE.W  #$0005,ld_ciab_20ms_countdown               ; $00001B04 ; CIAB Timer B 20ms timer ticks = 5 * 20 = 100ms (drive ready timeout value)
.drive_ready_loop
                TST.W   ld_ciab_20ms_countdown                      ; $00001B04
                BEQ.W   .exit_read_track                            ; if timeout jmp $00001DCA
                BTST.B  #$0005,$00bfe001                            ; Test Drive RDY bit
                BNE.B   .drive_ready_loop                           ; $00001D40 ; drive not ready then wait

                MOVE.W  #$4000,$00dff024                            ; DSKLEN - Disk DMA OFF
                MOVE.W  #$8010,$00dff096                            ; DMACON - Disk DMA ON
                MOVE.W  #$7f00,$00dff09e                            ; ADKCON - Clear MFM Disk Settings
                MOVE.W  #$9500,$00dff09e                            ; ADKCON - Set MFM Disk Settings (MFMPREC, FAST, WORDSYNC)
                MOVE.W  #$4489,$00dff07e                            ; DSKSYNC - Set Track Sync Mark (standard DOS Sync)
                MOVEA.L $0004(A7),A0                                ; MFM Track Buffer
                MOVE.W  #$4489,(A0)+                                ; Seed MFM Buffer with initial sync mark (decode bug fix bodge)
                MOVE.L  A0,$00dff020                                ; Set MFM Buffer for track read
                MOVE.W  #$0002,$00dff09c                            ; Clear DSKBLK interrupt flag
                MOVE.W  #$99ff,D0                                   ;
                MOVE.W  D0,$00dff024                                ; DSKLEN - Write value twice to start disk DMA
                MOVE.W  D0,$00dff024                                ; DSKLEN - Write value twice to start disk DMA

                MOVE.W  #$0032,ld_ciab_20ms_countdown               ; #$32 = 50, 50 x 20 = 1000 milliseconds: $00001B04
.wait_dskblk
                TST.W   ld_ciab_20ms_countdown                      ; test timeout
                BEQ.B   .end_dskblk_wait                            ; $00001DB6 ; if timeout then exit, jmp $00001D86

                MOVE.L  #$00000002,D0                               ; DSKBLK interrupt flag mask
                AND.W   $00dff01e,D0                                ; test for DSKBLK completed
                BEQ.B   .wait_dskblk                                ; $00001DA6 ; wait for DSKBLK completed
.end_dskblk_wait
                MOVE.W  #$0010,$00dff096                            ; Disable Disk DMA
                MOVE.W  #$4000,$00dff024                            ; Disable Disk DMA
         
                TST.W   ld_ciab_20ms_countdown                      ; Test Timeout Value
.exit_read_track
                MOVEM.L (A7)+,D0/A0
                RTS



                ;--------------------- decode mfm track buffer ----------------------
                ; IN: A0.L - mfm track buffer
                ; IN: A1.L - decoded track buffer address
decode_mfm_buffer
L00001DD0       MOVEM.L D0-D1/D5-D7/A0,-(A7)
L00001DD4       MOVE.B  D0,D7
L00001DD6       CLR.W   D6
L00001DD8       MOVE.W  #$33ff,D5
L00001DDC       SUBA.W  #$001c,A7
L00001DE0       CMP.W   #$4489,(A0)+
L00001DE4       DBEQ.W  D5,L00001DE0
L00001DE8       BNE.W   L00001E6C
L00001DEC       CMP.W   #$4489,(A0)+
L00001DF0       DBNE.W  D5,L00001DEC
L00001DF4       BEQ.W   L00001E6C
L00001DF8       SUBA.L  #$00000002,A0
L00001DFA       SUB.W   #$00000001,D5
L00001DFC       MOVEM.L A0-A1,-(A7)
L00001E00       LEA.L   $0008(A7),A1
L00001E04       MOVE.L  #$0000001c,D0
L00001E06       BSR.W   L00001E72
L00001E0A       MOVEM.L (A7)+,A0-A1
L00001E0E       MOVE.L  #$00000028,D0
L00001E10       BSR.W   L00001F06
L00001E14       CMP.L   $0014(A7),D0
L00001E18       BNE.B   L00001DE0
L00001E1A       CMP.B   $0001(A7),D7
L00001E1E       BNE.B   L00001E6C
L00001E20       LEA.L   $0038(A0),A0
L00001E24       MOVE.W  #$0400,D0
L00001E28       BSR.W   L00001F06
L00001E2C       CMP.L   $0018(A7),D0
L00001E30       BNE.B   L00001DE0
L00001E32       MOVE.B  $0002(A7),D0
L00001E36       BSET.L  D0,D6
L00001E38       MOVE.L  A1,-(A7)
L00001E3A       EXT.W   D0
L00001E3C       MULU.W  #$0200,D0
L00001E40       ADDA.W  D0,A1
L00001E42       MOVE.W  #$0200,D0
L00001E46       BSR.W   L00001E98
L00001E4A       MOVEA.L (A7)+,A1
L00001E4C       CMP.W   #$07ff,D6
L00001E50       BEQ.B   L00001E62
L00001E52       SUB.W   #$021c,D5
L00001E56       SUB.B   #$00000001,$0003(A7)
L00001E5A       BEQ.B   L00001DE0
L00001E5C       ADDA.L  #$00000008,A0
L00001E5E       SUB.W   #$00000004,D5
L00001E60       BRA.B   L00001DFC
L00001E62       ADDA.W  #$001c,A7
L00001E66       MOVEM.L (A7)+,D0-D1/D5-D7/A0
L00001E6A       RTS 

;L00001E6C       ANDSR.B #$00fb
L00001E6C       AND.B   #$fb,CCR
L00001E70       BRA.B   L00001E62
L00001E72       MOVEM.L D1-D3,-(A7)
L00001E76       LSR.W   #$00000002,D0
L00001E78       SUB.W   #$00000001,D0
L00001E7A       MOVE.L  #$55555555,D1
L00001E80       MOVE.L  (A0)+,D2
L00001E82       MOVE.L  (A0)+,D3
L00001E84       AND.L   D1,D2
L00001E86       AND.L   D1,D3
L00001E88       ADD.L   D2,D2
L00001E8A       ADD.L   D3,D2
L00001E8C       MOVE.L  D2,(A1)+
L00001E8E       DBF.W   D0,L00001E80
L00001E92       MOVEM.L (A7)+,D1-D3
L00001E96       RTS 

L00001E98       MOVE.L  D1,-(A7)
L00001E9A       BTST.B  #$0006,$00dff002
L00001EA2       BNE.B   L00001E9A
L00001EA4       MOVE.L  #$00000000,D1
L00001EA6       MOVE.L  D1,$00dff064
L00001EAC       MOVE.L  D1,$00dff060
L00001EB2       MOVE.L  #$ffffffff,$00dff044
L00001EBC       MOVE.W  #$5555,$00dff070
L00001EC4       ADDA.W  D0,A0
L00001EC6       SUBA.L  #$00000002,A0
L00001EC8       MOVE.L  A0,$00dff050
L00001ECE       ADDA.W  D0,A0
L00001ED0       MOVE.L  A0,$00dff04c
L00001ED6       ADDA.L  #$00000002,A0
L00001ED8       ADDA.W  D0,A1
L00001EDA       SUBA.W  #$00000002,A1
L00001EDC       MOVE.L  A1,$00dff054
L00001EE2       ADDA.W  #$00000002,A1
L00001EE4       MOVE.L  #$1dd80002,$00dff040
L00001EEE       LSL.W   #$00000005,D0
L00001EF0       ADD.W   #$00000001,D0
L00001EF2       MOVE.W  D0,$00dff058
L00001EF8       BTST.B  #$0006,$00dff002
L00001F00       BNE.B   L00001EF8
L00001F02       MOVE.L  (A7)+,D1
L00001F04       RTS 

L00001F06       MOVEM.L D1-D2/A0,-(A7)
L00001F0A       LSR.W   #$00000002,D0
L00001F0C       SUB.W   #$00000001,D0
L00001F0E       MOVE.L  #$00000000,D1
L00001F10       MOVE.L  (A0)+,D2
L00001F12       EOR.L   D2,D1
L00001F14       DBF.W   D0,L00001F10
L00001F18       AND.L   #$55555555,D1
L00001F1E       MOVE.L  D1,D0
L00001F20       MOVEM.L (A7)+,D1-D2/A0
L00001F24       RTS 



                ;---------------------------------------------------------------------------------------------------
                ;---------------------------------------------------------------------------------------------------
                ; END OF -- LOW LEVEL DISK ROUTINES
                ;---------------------------------------------------------------------------------------------------
                ;---------------------------------------------------------------------------------------------------









                ;--------------------------- init system --------------------------------
                ;-- 
init_system                                                             ;L00001F26
L00001F26       LEA.L   $00dff000,A6
L00001F2C       LEA.L   $00bfd100,A5
L00001F32       LEA.L   $00bfe101,A4

L00001F38       MOVE.L  #$00000000,D0

L00001F3A       MOVE.W  #$7fff,$009a(A6)
L00001F40       MOVE.W  #$1fff,$0096(A6)
L00001F46       MOVE.W  #$7fff,$009a(A6)

L00001F4C       LEA.L   L00001F58(PC),A0
L00001F50       MOVE.L  A0,$00000080
L00001F54       MOVEA.L A7,A0

L00001F56       TRAP    #$00000000

L00001F58       MOVEA.L A0,A7
L00001F5A       MOVE.W  #$0200,$0100(A6)
L00001F60       MOVE.W  D0,$0102(A6)
L00001F64       MOVE.W  D0,$0104(A6)
L00001F68       MOVE.W  D0,$0180(A6)
L00001F6C       MOVE.W  #$4000,$0024(A6)
L00001F72       MOVE.L  D0,$0040(A6)
L00001F76       MOVE.W  #$0041,$0058(A6)
L00001F7C       MOVE.W  #$8340,$0096(A6)
L00001F82       MOVE.W  #$7fff,$009e(A6)

L00001F88       MOVE.L  #$00000007,D1
L00001F8A       LEA.L   $0140(A6),A0

L00001F8E       MOVE.W  D0,(A0)
L00001F90       ADDA.L  #$00000008,A0
L00001F92       DBF.W   D1,L00001F8E

L00001F96       MOVE.L  #$00000003,D1
L00001F98       LEA.L   $00a8(A6),A0

L00001F9C       MOVE.W  D0,(A0)
L00001F9E       LEA.L   $0010(A0),A0
L00001FA2       DBF.W   D1,L00001F9C

L00001FA6       MOVE.B  #$7f,$0c00(A4)
L00001FAC       MOVE.B  D0,$0d00(A4)
L00001FB0       MOVE.B  D0,$0e00(A4)
L00001FB4       MOVE.B  D0,-$0100(A4)
L00001FB8       MOVE.B  #$03,$0100(A4)
L00001FBE       MOVE.B  D0,(A4)
L00001FC0       MOVE.B  #$ff,$0200(A4)
L00001FC6       MOVE.B  #$7f,$0c00(A5)
L00001FCC       MOVE.B  D0,$0d00(A5)
L00001FD0       MOVE.B  D0,$0e00(A5)
L00001FD4       MOVE.B  #$c0,-$0100(A5)
L00001FDA       MOVE.B  #$c0,$0100(A5)
L00001FE0       MOVE.B  #$ff,(A5)
L00001FE4       MOVE.B  #$ff,$0200(A5)

L00001FEA       LEA.L   L00002070(PC),A0
L00001FEE       MOVE.L  #$00000000,D0
L00001FF0       SUB.L   A0,D0
L00001FF2       MOVE.L  D0,$0026(A0)                                    ; set value of addr $00002096 to $FFFFDF90 below this routine.
L00001FF6       MOVE.L  A0,$00000004                                    ; A0 = $2070 ;This is an odd one($4.w is the reset PC counter)

L00001FFA       LEA.L   level1_interrupt_handler(PC),A0                 ; relocated addr: $0000209C
L00001FFE       MOVE.L  A0,$00000064                                    ; Level 1 Interrupt Vector

L00002002       LEA.L   level2_interrupt_handler(PC),A0                 ; relocated addr: $000020DA
L00002006       MOVE.L  A0,$00000068                                    ; Level 2 Interrupt Vector

L0000200A       LEA.L   level3_interrupt_handler(PC),A0                 ; relocated addr: $00002100
L0000200E       MOVE.L  A0,$0000006c                                    ; Level 3 Interrupt Vector

L00002012       LEA.L   level4_interrupt_handler(PC),A0                 ; relocated addr: $00002146
L00002016       MOVE.L  A0,$00000070                                    ; Level 4 Interrupt Vector

L0000201A       LEA.L   level5_interrupt_handler(PC),A0                 ; relocated addr: $0000215C
L0000201E       MOVE.L  A0,$00000074                                    ; Level 5 Interrupt Vector

L00002022       LEA.L   level6_interrupt_handler(PC),A0                 ; relocated addr: $00002182
L00002026       MOVE.L  A0,$00000078                                    ; Level 6 Interrupt Vector

L0000202A       MOVE.W  #$ff00,$0034(A6)
L00002030       MOVE.W  D0,$0036(A6)                                    ; D0.L = $FFFFDF90
L00002034       OR.B    #$ff,(A5)
L00002038       AND.B   #$87,(A5)
L0000203C       AND.B   #$87,(A5)
L00002040       OR.B    #$ff,(A5)
L00002044       MOVE.B  #$f0,$0500(A4)
L0000204A       MOVE.B  #$37,$0600(A4)
L00002050       MOVE.B  #$11,$0e00(A4)
L00002056       MOVE.B  #$91,$0500(A5)
L0000205C       MOVE.B  #$00,$0600(A5)
L00002062       MOVE.B  #$00,$0e00(A5)
L00002068       MOVE.B  #$1f,interrupt_flags_byte                       ; $0000209A  ; %00011111 - set 5 flags
L00002070       MOVE.W  #$7fff,$009c(A6)
L00002076       TST.B   $0c00(A4)
L0000207A       MOVE.B  #$8a,$0c00(A4)
L00002080       TST.B   $0c00(A5)
L00002084       MOVE.B  #$93,$0c00(A5)
L0000208A       MOVE.W  #$e078,$009a(A6)
;L00002090       MV2SR.W #$2000
L00002090       MOVE.W  #$2000,SR
L00002094       RTS 


L00002096       dc.w    $0000, $0000                            ; Set to the value $FFFFDF90 by init_system above







                ;---------------------------------------------------------------------------------------------------
                ;---------------------------------------------------------------------------------------------------
                ; INTERRUPT HANDLERS
                ;---------------------------------------------------------------------------------------------------
                ;---------------------------------------------------------------------------------------------------





interrupt_flags_byte                                            ; relocated addr: $0000209A
                dc.b    $1F
L0000209B       dc.b    $00

                ;-------------------------- level 1 interrupt handler --------------------------
                ;-- handler for level 1 interrupts as follows:-
                ;-- if SOFT (software) then clear SOFT bit in INTREQ.
                ;-- if TBE (serial) then clear TBE bit in INTREQ.
                ;-- if DSKBLK (diskblock) then set DSKBLK_FINISHED bit in Interrupt_flags_Byte
                ;-- 
level1_interrupt_handler                                        ; relocated addr: $0000209C
                MOVE.L  D0,-(A7)
                MOVE.W  $00dff01e,D0                            ; Read INTREQR

                BTST.L  #$0002,D0                               ; SOFT - Software Interrupt
                BNE.B   .level1_soft                            ; if SOFT = 1 then jmp $000020CE

                BTST.L  #$0001,D0                               ; DSKBLK - Disk Block Finished
                BNE.B   .level_dskblk                           ; if DSKBLK = 1 then jmp $000020BC
.level1_tbe
                MOVE.W  #$0001,$00dff09c                        ; Clear TBE serial port interrupt
                MOVE.L  (A7)+,D0
                RTE 
.level_dskblk
                BSET.B  #DSKBLK_FINISHED,interrupt_flags_byte   ; var addr: $0000209A
                MOVE.W  #$0002,$00dff09C                        ; Clear DSKBLK interrupt
                MOVE.L  (A7)+,D0
                RTE 
.level1_soft
                MOVE.W  #$0004,$00dff09c                        ; Clear SOFT Interrupt
                MOVE.L  (A7)+,D0
                RTE 




                ;-------------------------- level 2 interrupt handler --------------------------
                ;-- handler for level 2 interrupts as follows:-
                ;-- pretty much handles the 20ms timer ticks counters,
                ;-- ignores and clears off other level 2 interrupts
level2_interrupt_handler                                        ; relocated address: $000020DA
                MOVE.L  D0,-(A7)
                MOVE.B  $00bfed01,D0                            ; CIAA ICR, clears on read
                BPL.B   .not_ciaa_int                           ; MSB = 0 then not a CIAA interrupt, jmp $000020F4
.is_ciaa_int
                BSR.W   ciaa_interrupt_handler                  ; routine addr: $000021C0
                MOVE.W  #$0008,$00dff09c                        ; Clear PORTS bit of INTREQ
                MOVE.L  (A7)+,D0
                RTE 
.not_ciaa_int
                MOVE.W  #$0008,$00dff09c                        ; Clear PORTS bit of INTREQ
                MOVE.L  (A7)+,D0
                RTE 




                ;----------------------- level 3 interrupt handler -------------------------
                ;-- level 3 interrupt handler, operates as follows:-
                ;-- if COPER (copper) interrupt then clear COPER bit in INTREQ
                ;-- if VERTB (vertical blank) then increment frame_counter variable
                ;-- if BLIT (blit finished) then set BLIT_FINISHED bit of interrupt_flags_byte
                ;--
level3_interrupt_handler                                        ; relocated address: $00002100
                MOVE.L  D0,-(A7)
                MOVE.W  $00dff01e,D0                            ; Read INTREQR
                BTST.L  #$0004,D0                               ; COPER - Copper Interrupt
                BNE.B   .is_coper                               ; if COPER bit = 1 then jmp $00002138
.chk_vertb      
                BTST.L  #$0005,D0                               ; VERTB - Vertical Blank Interrupt
                BNE.B   .is_vertb                               ; if VERTB bit = 1 then jmp $00002126
.blt_finished
                BSET.B  #BLIT_FINISHED,interrupt_flags_byte     ; Set Bitter Finished Flag in $0000209A
                MOVE.W  #$0040,$00dff09c                        ; Clear Blitter Interrupt bit
                MOVE.L  (A7)+,D0
                RTE 
.is_vertb                                                       ; relocated address: $00002126
                ADD.W   #$0001,frame_counter                    ; increase frame counter variable - $00002144
                MOVE.W  #$0020,$00dff09c                        ; clear VERTB interrupt bit
                MOVE.L  (A7)+,D0
                RTE 
.is_coper                                                       ; relocated address: $00002138
                MOVE.W  #$0010,$00dff09c                        ; clear COPER interrupt bit
                MOVE.L  (A7)+,D0                            
                RTE                                             ; exit level 3 interrupt handler

frame_counter
                dc.w    $0000                                   ; relocated address: $00002144                                 




                ;----------------------- level 4 interrupt handler -----------------------
                ;-- handles level 4 interrupts as follows:-
                ;-- if audio interrupt occurs on any channel then clear the interrupt bit
                ;--
level4_interrupt_handler                                        ; relocated address: $00002146
                MOVE.L  D0,-(A7)
                MOVE.W  $00dff01e,D0                            ; Read INTREQR
                AND.W   #$0780,D0                               ; mask out interrupt bits, leaving aud0-aud3
                MOVE.W  D0,$00dff09a                            ; clear aud0-aud3 interrupt in INTREQ
                MOVE.L  (A7)+,D0
                RTE 




                ;----------------------- level 5 interrupt handler -----------------------
                ; handle level 5 interrupts by just clearing their bits in INTREQ
level5_interrupt_handler
                MOVE.L  D0,-(A7)
                MOVE.W  $00dff01e,D0
                BTST.L  #$000c,D0                                   
                BNE.B   .is_dsksyn                          ; if DSKSYN then jmp $00002176
.is_rbf
                MOVE.W  #$0800,$00dff09c                    ; clear RBF - Serial port buffer receive in INREQ
                MOVE.L  (A7)+,D0
                RTE 
.is_dsksyn
                MOVE.W  #$1000,$00dff09c                    ; clear DSKSYN bit in INTREQ
                MOVE.L  (A7)+,D0
                RTE 




                ;------------------- level 6 interrupt handler -----------------
                ;-- handle level 6 interrupts,
                ;-- If not a CIAB (EXTER) Interrupt then just clear the INTREQ bits
                ;-- else call 'level6_ciab' sub routine to handle Timer/FLG interrupts
                ;
level6_interrupt_handler                                        ; relocated address $00002182
                MOVE.L  D0,-(A7)
                MOVE.W  $00dff01e,D0                            ; read INTREQR
                BTST.L  #$000e,D0                               ; bit 14 INTEN - Master Interrupt (enable only)
                BNE.B   .inten_int                              ; if INTEN then jmp $000021B4
.chk_ciab_int
                MOVE.B  $00bfdd00,D0                            ; CIAB ICR - Interrupt Control Register (reading clears it also)                            
                BPL.B   .not_ciab_int                           ; if MSB = 0 then not a CIAB interrupt, jmp $000021A8
.is_ciab_int
                BSR.W   level6_ciab                             ; routine addr: $000021EC
                MOVE.W  #$2000,$00dff09c                        ; clear EXTERN - external interrupt (CIAB FLG)
                MOVE.L  (A7)+,D0
                RTE 
.not_ciab_int
                MOVE.W  #$2000,$00dff09c                        ; clear EXTERN - external interrupt (CIAB FLG)
                MOVE.L  (A7)+,D0
                RTE 
.inten_int
                MOVE.W  #$4000,$00dff09c                        ; Clear INTEN Bit 14 of INTREQ (strange as not an interrupt request bit)
                MOVE.L  (A7)+,D0
                RTE 




                ;--------------------- ciaa interrupt handler ----------------------
                ; called from level 2 interrupt handler when the interrupt was
                ; generated by the CIAA chip.
                ; IN: D0.b = CIAA ICR value (interrupt bits)
ciaa_interrupt_handler                                          ; relocated address $000021C0
                LSR.B   #$02,D0                                 ; shift out Timer B bit 2
                BCC.B   .chk_sp_int                             ; if not TimerB interrupt, jmp $000021C8
.is_timerA
                BSR.W   level2_ciaa_timerA                      ; relocated address: $00002228
.chk_sp_int
                LSR.B   #$02,D0                                 ; shift out SP bit bit 4 (kbd serial port full/empty)
                BCC.B   .exit                                   ; not SP interrupt, jmp $000021EA               
.is_sp_int
                MOVEM.L D1-D2/A0,-(A7)                          ; keyboard shenanigans????, maybe an ack signal back to keyboard, old code, D1 read then later restored
                MOVE.B  $00bfec01,D1                            ; D1 = serial data register (keyboard)
                MOVE.B  #$40,$00bfee01                          ; CIAA CRA (control reg), SSPMODE = 1 - Serial Port CNT is shift source
                MOVE.B  #$19,$00bfdf00                          ; CIAB CRB (control reg), RUNMODE = 1 (oneshot), START = 1 (Timer B), LOAD = 1 (force load)
                MOVEM.L (A7)+,D1-D2/A0
.exit
                RTS 




                ;------------------------------- level 6 CIAB -----------------------------
                ;-- Handles CIAB Level 6 Interrupt, called from Level 6 Interrupt Handler
                ;--
                ;-- If TimerA interrupt then set Timer A Interupt Flag
                ;-- If TimerB interrupt then set CIAA CRA (Control Register A) (Keyboard Ack?)
                ;-- If FLG Interrupt and Interrupt_flags_Byte Bits 3 & 4 are 0 then 
                ;--        -- Initiate a 6.5K DMA disk write
                ;--        -- Sets Interrupt_flags_Byte Bits 3 & 4 to 1
level6_ciab                                                 ; relocated address: $000021EC
                LSR.B   #$01,D0                             ; shift out Timer A interrupt bit
                BCC.B   .chk_timerB_int                     ; Not a Timer A interrupt, jmp $000021F6 
.timerA_int
                BSET.B  #$02,interrupt_flags_byte           ; Set Timer A Interrupt Flag
.chk_timerB_int
                LSR.B   #$01,D0                             ; shift out Timer B interrupt bit
                BCC.B   .chk_flg_int                        ; Not a Timer B interrupt, jmp $00002202
.timerB_int
                MOVE.B  #$00,$00bfee01                      ; CIAA CRA; SPMODE = 0 (input), INMODE = 0, RUNMODE = 0 (continuous), OUTMODE = 0 (pulse), PBON = 0, START = 0 (Timer A stop) 
.chk_flg_int
                LSR.B   #$03,D0                             ; shift out FLG interrupt bit
                BCC.B   .exit                               ; Not a FLG interrupt (DSKINDEX) then jmp $00002226 (exit)
.dskindex1_int
                BSET.B  #DISK_INDEX1,interrupt_flags_byte   ; Set DSKINDEX1 Interrupt Flag1, var addr: $0000209A
                BNE.B   .exit                               ; if DSKINDEX1 was 1, then jmp $00002226 (exit)
.dskindex2_int
                BSET.B  #DISK_INDEX2,interrupt_flags_byte   ; set DSKINDEX2 Interrupt Flag2 (if dskindex1 was 0), var addr: $0000209A
                BNE.B   .exit                               ; if DSKINDEX2 was 1, then jmp $00002226 (exit)
.dsk_write
                MOVE.W  #$da00,D0                           ; $DA00 - DMAEN = 1, WRITE = 1, LENGTH = $1A00 (6656 bytes - 6.5K) 
                MOVE.W  D0,$00dff024                        ; Set value twice to enable disk DMA
                MOVE.W  D0,$00dff024                        ; 
.exit
                RTS 




               ;--------------------------------- level 2 CIAA Timer A -----------------------------
               ;-- called from ciaa_interrupt_handler to handle CIAA TimerA interrupts as follows:-
               ;-- decrement then ld_ciab_20ms_countdown counter, clamping it at 0
               ;-- increment the ciab_tb_20ms_tick, no clamping so will eventually overflow
               ;--
level2_ciaa_timerA                                                      ; relocated address: $00002228
                TST.W   ld_ciab_20ms_countdown                          ; $00001B04
                BEQ.B   .increment_counter                              ; if countdown is 0 then skip decrement, jmp $00002232
.decrement_counter
                SUB.W   #$0001,ld_ciab_20ms_countdown                   ; $00001B04
.increment_counter
                ADD.W   #$0001,ciab_tb_20ms_tick                        ; $0000223A
                RTS 

ciab_tb_20ms_tick                                                       ; $0000223A ; CIAB - TIMER B - Underflow counter, increments every 20ms                
                dc.w $0000 






                ;---------------------------------------------------------------------------------------------------
                ;---------------------------------------------------------------------------------------------------
                ; END OF - INTERRUPT HANDLERS
                ;---------------------------------------------------------------------------------------------------
                ;---------------------------------------------------------------------------------------------------












L0000223C       dc.w $3033, $0000
L00002240       dc.w $00F0, $0002, $000F, $0F0D, $0000, $0000, $000F, $0F0D             ;................
L00002250       dc.w $0000, $0070 
L00002254       dc.w $F007, $0FF8, $0FF8, $F007, $F0F7, $08F8             ;...p............

L00002260       dc.w $0F08, $F7F7, $F717, $0818, $0FE8, $F7F7, $F047, $0FB8             ;.............G..
L00002270       dc.w $0FF8, $F1C7, $FD9F, $0260, $03E0, $FDDF, $FC5F, $0220             ;.......`....._. 
L00002280       dc.w $03E0, $FDDF, $FD1F, $0320, $02E0, $FDDF, $FDDF, $03E0             ;....... ........
L00002290       dc.w $0220, $FDDF, $F05F, $0E60, $0FA0, $F1DF, $F19F, $0820             ;. ..._.`....... 
L000022A0       dc.w $0FE0, $F7DF, $F65F, $0E20, $09E0, $F7DF, $FB9F, $07A0             ;....._. ........
L000022B0       dc.w $0460, $FBDF, $FDDF, $03E0, $0220, $FDDF, $FE1F, $01E0             ;.`....... ......
L000022C0       dc.w $01E0, $FE1F, $E003, $1FFC, $1FFC, $E003, $EE3B, $1E04             ;.............;..
L000022D0       dc.w $11FC, $EFFB, $EFC3, $1FC4, $103C, $EFFB, $E203, $13FC             ;.........<......
L000022E0       dc.w $1DFC, $EE03, $F47F, $0980, $0F80, $F67F, $F33F, $08C0             ;.............?..
L000022F0       dc.w $0FC0, $F73F, $F80F, $0430, $07F0, $FBCF, $FCC7, $03C8             ;...?...0........
L00002300       dc.w $0338, $FCF7, $FF3B, $00FC, $00C4, $FF3B, $E1CB, $1E2C             ;.8...;.....;...,
L00002310       dc.w $1E34, $E1DB, $E013, $11C4, $1FFC, $EE3B, $EC0B, $1C04             ;.4.........;....
L00002320       dc.w $13FC, $EFFB, $F7F7, $0FF8, $0808, $F7F7, $F80F, $07F0             ;................
L00002330       dc.w $07F0, $F80F


disk_logo
L00002334       dc.w $0000, $0000, $0200, $1301, $2402, $3503                           ;........$.5.
L00002340       dc.w $4602, $2203, $3304, $4405, $5505, $2006, $3007, $4007             ;F.".3.D.U. .0.@.
L00002350       dc.w $5007, $6106, $6601, $6B03, $0900, $04D4, $FC02, $0702             ;P.a.f.k.........
L00002360       dc.w $0202, $FF02, $FF0D, $FD0B, $FF04, $2B05, $0702, $59FD             ;..........+...Y.
L00002370       dc.w $021F, $FE09, $FB3A, $FF58, $FC1F, $02FE, $11F3, $02FF             ;.....:.X........
L00002380       dc.w $02F3, $185A, $FF25, $0EF2, $09F2, $155A, $FF05, $FF1B             ;...Z.%.....Z....
L00002390       dc.w $040E, $F209, $F215, $5AFF, $05FF, $1AFF, $0411, $F302             ;......Z.........
L000023A0       dc.w $FF02, $F318, $59FB, $1EFC, $09FB, $3A59, $F326, $FE38             ;....Y.....:Y.&.8
L000023B0       dc.w $FD00, $09B8, $FE02, $FE09, $0202, $FF02, $FF0D, $02FF             ;................
L000023C0       dc.w $0BFF, $2F04, $FF07, $FF5A, $FE02, $FF1F, $FE09, $FC3A             ;../....Z.......:
L000023D0       dc.w $FF59, $FD20, $02FE, $09FE, $06F3, $0302, $FD02, $F817             ;.Y. ............
L000023E0       dc.w $FF00, $0080, $09FE, $03FB, $02F9, $09FC, $02F8, $14FF             ;................
L000023F0       dc.w $601C, $0409, $FE03, $FB02, $F909, $FC02, $F814, $FF60             ;`..............`
L00002400       dc.w $1C04, $09FE, $06F3, $0302, $FD02, $F817, $FF59, $FB1F             ;.............Y..
L00002410       dc.w $FD09, $FC3A, $FF59, $F628, $FF02, $38FE, $0009, $B9FE             ;...:.Y.(..8.....
L00002420       dc.w $03FF, $0902, $02FF, $02FF, $0D02, $FF0B, $FF2F, $0508             ;............./..
L00002430       dc.w $5BFF, $02FF, $1FFE, $47FF, $59FD, $20FC, $11F3, $0302             ;[.....G.Y. .....
L00002440       dc.w $FF02, $02F8, $17FF, $7FFF, $0EF9, $03FC, $09FC, $0203             ;................
L00002450       dc.w $02FD, $14FF, $60FF, $1AFF, $03FF, $0EF9, $03FC, $09FC             ;....`...........
L00002460       dc.w $0203, $02FD, $14FF, $60FF, $1AFF, $03FF, $11F3, $0302             ;......`.........
L00002470       dc.w $FF02, $02F8, $17FF, $59FB, $1FFD, $47FF, $59F6, $6300             ;......Y...G.Y.c.
L00002480       dc.w $0AB5, $FE3A, $5AFD, $2002, $FF0C, $06F3, $05FD, $02F8             ;...:Z. .........
L00002490       dc.w $175A, $260C, $03F9, $02FB, $09FC, $0203, $FB14, $5A07             ;.Z&...........Z.
L000024A0       dc.w $1C03, $0C03, $F902, $FB09, $FC02, $03FB, $145A, $071C             ;.............Z..
L000024B0       dc.w $030C, $06F3, $05FD, $02F8, $175A, $FF23, $FE0C, $FE3A             ;.........Z.#...:

L000024C0       dc.w $0005, $AEFF, $0000, $0555, $0551, $7FFD, $FFFE, $7FFE             ;.......U.Q......
L000024D0       dc.w $7FFF, $7F7F, $7DBF, $7BDF, $73CF, $7FBF, $7C7F, $7FFF             ;....}.{.s...|...
L000024E0       dc.w $7FFE, $7FFD, $7FFE, $7FFF, $7FFE, $7FFD, $7FFF, $701F             ;..............p.
L000024F0       dc.w $7FFF, $3FFF, $0000, $81FF, $FC00, $07FF, $0FFF, $FFFF             ;..?.............
L00002500       dc.w $7FFF, $FD00, $FFFF, $9FFF, $7FFF, $DFFF, $FFFF, $7FFF             ;................
L00002510       dc.w $FFFF, $8000, $0000, $103C, $BF17, $4178, $80FC, $8000             ;.......<..Ax....
L00002520       dc.w $A000, $D800, $0000, $FFFF, $FFF8, $FFE7, $FF9F, $FF60             ;...............`
L00002530       dc.w $FCE0, $F900, $F600, $EC00, $CC00, $D800, $B800, $9000             ;................
L00002540       dc.w $7000, $6000, $2000, $6000, $5000, $B800, $B807, $D800             ;p.`. .`.P.......
L00002550       dc.w $C806, $EE03, $F704, $FB87, $FC83, $FF79, $FF9C, $FFE3             ;...........y....
L00002560       dc.w $FFFC, $FFFF, $0000, $FFFF, $0000, $FFFF, $FFC0, $F03F             ;...............?
L00002570       dc.w $0FC0, $F03F, $E077, $03F7, $0FF3, $1F10, $3810, $2390             ;...?.w......8.#.
L00002580       dc.w $0E20, $3860, $1BC0, $0780, $0000, $C180, $E860, $3010           ;. 8`.........`0.
L00002590       dc.w $9018, $C00C, $000C, $F006, $BF0E, $C7FE, $E01F, $7C01             ;..............|.
L000025A0       dc.w $8FF0, $F03F, $FFC0, $FFFF, $0000, $FFFF, $0000, $0038             ;...?...........8
L000025B0       dc.w $003F, $0000, $FFFF, $03FF, $FC0F, $03F0, $FC0F, $EE07             ;.?..............
L000025C0       dc.w $EFC0, $CFF0, $08F8, $081C, $09C4, $0470, $061C, $03D8             ;...........p....
L000025D0       dc.w $01E0, $0000, $0183, $0617, $080C, $1809, $3003, $3000           ;............0.0.
L000025E0       dc.w $600F, $70FD, $7FE3, $F807, $803E, $0FF1, $FC0F, $03FF             ;`.p......>......
L000025F0       dc.w $FFFF, $0000, $FFFF, $0000, $0020, $FFC0, $FFA0, $0000             ;......... ......
L00002600       dc.w $FFFF, $1FFF, $E7FF, $F9FF, $06FF, $073F, $009F, $006F             ;...........?...o
L00002610       dc.w $0037, $0033, $001B, $001D, $0009, $000E, $0006, $0004             ;.7.3............
L00002620       dc.w $0006, $000A, $001D, $E01D, $001B, $6013, $C077, $20EF             ;..........`..w .
L00002630       dc.w $E1DF, $C13F, $9EFF, $39FF, $C7FF, $3FFF, $FFFF, $0000             ;...?..9...?.....
L00002640       dc.w $2000, $F03F, $10C0, $17FF, $19FF, $17FF, $07FF, $17FF             ; ..?............
L00002650       dc.w $2FFF, $7FFF, $FFFF, $FFF9, $FFFD, $FFFA, $FFFF, $FFFE             ;/...............
L00002660       dc.w $FFFF, $0000, $3E00, $A100, $1E00, $FF00, $FFA0, $FFD0             ;....>...........
L00002670       dc.w $FFE8, $FFF4, $FFFA, $FFFC, $FFFF, $FFFE, $FFFF, $FFFE             ;................
L00002680       dc.w $3FFE, $BFFE, $FFFE, $FFFF, $FFFE, $7FFE, $0000, $1FFF             ;?...............
L00002690       dc.w $3551, $7FFD, $FFFD, $FFFC, $FFFD, $FDFD, $FBFD, $F1CD             ;5Q..............
L000026A0       dc.w $FDFD, $FC7D, $FFFD, $FFFC, $FFFE, $FFFF, $FFFE, $FFFD             ;...}............
L000026B0       dc.w $F01D, $F7FD, $FFFD, $7FFC, $0000, $FFFF, $FC00, $FFFF             ;................
L000026C0       dc.w $0FFF, $FFFF, $7FFF, $0000, $FFFF, $E000, $FFFF, $C000             ;................
L000026D0       dc.w $8000, $0000, $FFFF, $0000, $307E, $C1F4, $40DC, $C000             ;........0~..@...
L000026E0       dc.w $E000, $F800, $0000, $FFFF, $0000, $FFFF, $0000, $0007             ;................
L000026F0       dc.w $001F, $007B, $00E0, $03E0, $0500, $0A00, $1400, $2C00             ;...{..........,.
L00002700       dc.w $3800, $7800, $5000, $9000, $A000, $E000, $9000, $5800             ;8.x.P.........X.
L00002710       dc.w $5807, $280F, $1C0F, $0F03, $0500, $0380, $00F8, $007C             ;X.(............|
L00002720       dc.w $001C, $0003, $0000, $FFFF, $0000, $FFFF, $0000, $FFFF             ;................
L00002730       dc.w $0000, $003F, $0FFF, $FFC0, $F000, $C000, $0010, $00F0             ;...?............

L00002740       dc.w $07F0, $1FF0, $3FE0, $1FE0, $0F80, $0780, $0000, $4180             ;....?.........A.
L00002750       dc.w $E3E0, $FFF0, $FFE8, $FFF4, $0FFA, $00F2, $0002, $0001             ;................
L00002760       dc.w $8001, $7000, $0FC0, $003F, $0000, $FFFF, $0000, $001F             ;..p....?........
L00002770       dc.w $0000, $FFFF, $0000, $FFFF, $0000, $FC00, $FFF0, $03FF             ;................
L00002780       dc.w $000F, $0003, $0800, $0F00, $0FE0, $0FF8, $07FC, $07F8             ;................
L00002790       dc.w $01F0, $01E0, $0000, $0182, $07C7, $0FFF, $17FF, $2FFF           ;............../.
L000027A0       dc.w $5FF0, $4F00, $4000, $8000, $8001, $000E, $03F0, $FC00             ;_.O.@...........
L000027B0       dc.w $0000, $FFFF, $0000, $FFE0, $0000, $FFFF, $0000, $FFFF             ;................
L000027C0       dc.w $0000, $E000, $F800, $DE00, $0700, $07C0, $00A0, $0050             ;...............P
L000027D0       dc.w $0028, $0034, $001C, $001E, $000A, $0009, $0005, $0007             ;.(.4............
L000027E0       dc.w $0009, $001A, $E01A, $F014, $F038, $C0F0, $00A0, $01C0             ;.........8......
L000027F0       dc.w $1F00, $3E00, $3800, $C000, $0000, $FFFF, $0000, $3000             ;..>.8.........0.
L00002800       dc.w $107F, $0000, $0E7F, $08FF, $0FFF, $1FFF, $3FFF, $7FFF             ;............?...
L00002810       dc.w $FFFF, $0007, $FFFE, $0003, $0001, $0000, $FFFF, $0000             ;................
L00002820       dc.w $7F00, $A180, $1E40, $FF20, $FF90, $FFC8, $FFE4, $FFF2           ;.....@. ........
L00002830       dc.w $FFF9, $FFFC, $FFFE, $7FFE, $FFFE, $BFFE, $BFFF, $3FFF             ;..............?.
L00002840       dc.w $0000, $1AAA, $3FFE, $0002, $0003, $0002, $0202, $0402             ;....?...........
L00002850       dc.w $0E32, $0202, $0382, $0002, $0003, $0001, $0000, $0001             ;.2..............
L00002860       dc.w $0002, $0802, $0002, $0000, $03FF, $0000, $F000, $0000             ;................
L00002870       dc.w $8000, $FFFF, $0000, $FFFF, $0000, $307E, $01F4, $80DC             ;..........0~....
L00002880       dc.w $0000, $2000, $0000, $0800, $FFFF, $0000, $0007, $0018             ;.. .............
L00002890       dc.w $0063, $0080, $0360, $0600, $0C00, $1800, $3000, $2000             ;.c...`......0. .
L000028A0       dc.w $4000, $6000, $E000, $C000, $8000, $E000, $6800, $300F             ;@.`.........h.0.
L000028B0       dc.w $100F, $0907, $0607, $0303, $0099, $0060, $001F, $0003             ;...........`....
L000028C0       dc.w $0000, $FFFF, $0000, $FFFF, $0000, $003F, $0FC0, $F03F             ;...........?...?
L000028D0       dc.w $0FFF, $C3F7, $0FE7, $1FE3, $3FE0, $3FC0, $1F80, $0C00             ;........?.?.....
L000028E0       dc.w $0780, $0000, $4000, $2380, $DFE0, $EFF0, $FFF8, $FFFC             ;....@.#.........
L000028F0       dc.w $FFFE, $7FFF, $0FFF, $003F, $0000, $FFFF, $0000, $0010             ;.......?........
L00002900       dc.w $0000, $0010, $0000, $FFFF, $0000, $FC00, $03F0, $FC0F             ;................
L00002910       dc.w $FFF0, $EFC3, $E7F0, $C7F8, $07FC, $03FC, $01F8, $0030             ;...............0
L00002920       dc.w $01E0, $0000, $0002, $01C4, $07FB, $0FF7, $1FFF, $3FFF             ;..............?.
L00002930       dc.w $7FFF, $FFFE, $FFF0, $FC00, $0000, $FFFF, $0000, $0020             ;............... 
L00002940       dc.w $0000, $0020, $0000, $FFFF, $0000, $E000, $1800, $C600             ;... ............
L00002950       dc.w $0100, $06C0, $0060, $0030, $0018, $000C, $0004, $0002             ;.....`.0........
L00002960       dc.w $0006, $0007, $0003, $0001, $0007, $0016, $F00C, $F008             ;................
L00002970       dc.w $E090, $E060, $C0C0, $9900, $0600, $F800, $C000, $0000             ;...`............
L00002980       dc.w $FFFF, $0000, $3000, $1040, $00FF, $0180, $0700, $0000           ;....0..@........
L00002990       dc.w $1000, $2000, $8000, $0000, $FFFF, $0000, $4000, $7E00             ;.. .........@.~.
L000029A0       dc.w $E180, $00C0, $0060, $0030, $0018, $000C, $0006, $0003           ;.....`.0........
L000029B0       dc.w $0001, $0000, $3FFF, $7FFF, $FFFF, $0000, $0F81, $3F0B             ;....?.........?.

L000029C0       dc.w $3F3B, $3FFF, $1FFF, $07FF, $0000, $FFFF, $FFF8, $FFE7             ;?;?.............
L000029D0       dc.w $FF9F, $FF78, $FC80, $FB00, $F600, $EC00, $DC00, $D800             ;...x............
L000029E0       dc.w $B800, $B000, $7000, $6000, $7000, $B000, $B007, $DC0F             ;....p.`.p.......
L000029F0       dc.w $EE0F, $F707, $FB87, $FCE3, $FF61, $FF9C, $FFE3, $FFFC             ;.........a......
L00002A00       dc.w $FFFF, $0000, $FFFF, $0000, $FFFF, $FFC0, $F03F, $0FFF             ;.............?..
L00002A10       dc.w $FFFF, $FFF7, $0FF7, $1FF3, $3FF0, $7FF0, $7FE0, $3FF0             ;........?.....?.
L00002A20       dc.w $1FE0, $0780, $0000, $C180, $EBE0, $F7F0, $F7F8, $FFFC           ;................
L00002A30       dc.w $FFFE, $FFFF, $7FFF, $8FFF, $F03F, $FFC0, $FFFF, $0000             ;.........?......
L00002A40       dc.w $FFFF, $FFE0, $FFFF, $0000, $FFFF, $03FF, $FC0F, $FFF0             ;................
L00002A50       dc.w $FFFF, $EFFF, $EFF0, $CFF8, $0FFC, $0FFE, $07FE, $0FFC             ;................
L00002A60       dc.w $07F8, $01E0, $0000, $0183, $07D7, $0FEF, $1FEF, $3FFF           ;..............?.
L00002A70       dc.w $7FFF, $FFFF, $FFFE, $FFF1, $FC0F, $03FF, $FFFF, $0000             ;................
L00002A80       dc.w $FFFF, $001F, $FFFF, $0000, $FFFF, $1FFF, $E7FF, $F9FF             ;................
L00002A90       dc.w $1EFF, $013F, $00DF, $006F, $0037, $003B, $001B, $001D             ;...?...o.7.;....
L00002AA0       dc.w $000D, $000E, $0006, $000E, $000D, $E00D, $F03B, $F077             ;.............;.w
L00002AB0       dc.w $E0EF, $E1DF, $C73F, $86FF, $39FF, $C7FF, $3FFF, $FFFF             ;.....?..9...?...
L00002AC0       dc.w $0000, $C000, $F000, $E000, $C000, $0000, $FFFC, $FFFE             ;................
L00002AD0       dc.w $FFFF, $0000, $0000, $0000, $0000, $0000, $0000, $0000             ;................
L00002AE0       dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000             ;................
L00002AF0       dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000             ;................
L00002B00       dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000             ;................
L00002B10       dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000             ;................
L00002B20       dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000             ;................
L00002B30       dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000             ;................
L00002B40       dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000             ;................
L00002B50       dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000             ;................
L00002B60       dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000             ;................
L00002B70       dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000             ;................
L00002B80       dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000             ;................
L00002B90       dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000             ;................
L00002BA0       dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000             ;................
L00002BB0       dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000             ;................
L00002BC0       dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000             ;................
L00002BD0       dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000             ;................
L00002BE0       dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000             ;................
L00002BF0       dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000             ;................
L00002C00       dc.w $464F, $524D, $0000, $A0CE, $494C, $424D, $424D, $4844             ;FORM....ILBMBMHD
L00002C10       dc.w $0000, $0014, $0140, $0100, $0000, $0000, $0500, $0100             ;.....@..........
L00002C20       dc.w $0000, $0101, $0140, $0100, $434D, $4150, $0000, $0060             ;.....@..CMAP...`
L00002C30       dc.w $0000, $0050, $2010, $3010, $0070, $3010, $8030, $10A0             ;...P .0..p0..0..

L00002C40       dc.w $4010, $B050, $10D0, $6010, $E070, $00F0, $8000, $F090             ;@..P..`..p......
L00002C50       dc.w $00F0, $A000, $F0B0, $00F0, $C000, $F0E0, $00F0, $F000             ;................
L00002C60       dc.w $8020, $0070, $2000, $6020, $0000, $0000, $1010, $1020             ;. .p .` ....... 
L00002C70       dc.w $2020, $3030, $3040, $4040, $5050, $5060, $6070, $7070             ;  000@@@PPP``ppp
L00002C80       dc.w $8080, $8090, $9090, $A0A0, $A0B0, $B0B0, $C0D0, $D0E0             ;................
L00002C90       dc.w $4450, $5053, $0000, $006E, $0002, $0005, $4111, $0000             ;DPPS...n....A...
L00002CA0       dc.w $0000, $0000, $0000, $0168, $0000, $0140, $00C8, $0002             ;.......h...@....
L00002CB0       dc.w $005A, $0002, $0000, $0002, $0000, $0002, $0000, $0000             ;.Z..............
L00002CC0       dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000             ;................
L00002CD0       dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0004, $0069             ;...............i
L00002CE0       dc.w $F494, $0001, $0000, $0000, $0000, $0000, $0000, $0000             ;................
L00002CF0       dc.w $0000, $0000, $8402, $0000, $DB56, $0000, $0000, $FFFF             ;.........V......
L00002D00       dc.w $24AA, $0000, $8402, $4352, $4E47, $0000, $0008, $1376             ;$.....CRNG.....v
L00002D10       dc.w $0A00, $0001, $0000, $4352, $4E47, $0000, $0008, $12F2             ;......CRNG......
L00002D20       dc.w $0AAA, $0001, $0000, $4352, $4E47, $0000, $0008, $0000             ;......CRNG......
L00002D30       dc.w $0AAA, $0001, $0000, $4352, $4E47, $0000, $0008, $0000             ;......CRNG......
L00002D40       dc.w $0AAA, $0001, $0000, $4352, $4E47, $0000, $0008, $0000             ;......CRNG......
L00002D50       dc.w $0000, $0001, $0000, $4352, $4E47, $0000, $0008, $0000             ;......CRNG......
L00002D60       dc.w $0000, $0001, $0000, $4341, $4D47, $0000, $0004, $0000             ;......CAMG......
L00002D70       dc.w $4000, $424F, $4459, $0000, $9F5C, $FB00, $0201, $C380             ;@.BODY...\......
L00002D80       dc.w $FD00, $0018, $EF00, $0101, $40FB, $00FB, $0002, $0181             ;........@.......
L00002D90       dc.w $80FD, $0000, $88EF, $0001, $0140, $FB00, $FB00, $0201             ;.........@......
L00002DA0       dc.w $8580, $FE00, $0102, $E8EF, $0001, $01C0, $FB00, $FA00             ;................
L00002DB0       dc.w $0046, $FD00, $0102, $70EF, $0001, $01C0, $FB00, $FB00             ;.F....p.........
L00002DC0       dc.w $0201, $C780, $FE00, $0102, $F8EF, $0001, $01C0, $FB00             ;................
L00002DD0       dc.w $FA00, $1BC3, $70CB, $5800, $01D6, $6A81, $CCCE, $408F             ;....p.X...j...@.
L00002DE0       dc.w $F57E, $001A, $BE00, $0559, $AA00, $0FCF, $C1FD, $5CFC             ;.~.....Y......\.
L00002DF0       dc.w $00FA, $001B, $187F, $0890, $0001, $C819, $81F0, $F07F             ;................
L00002E00       dc.w $8079, $8000, $1CC3, $0006, $6066, $000F, $C601, $8338             ;.y......`f.....8
L00002E10       dc.w $FC00, $FA00, $1B3C, $8008, $E000, $01E0, $0701, $FF00             ;.....<..........
L00002E20       dc.w $7F80, $7E00, $003F, $0000, $0780, $1C00, $0FF6, $2080             ;..~..?........ .
L00002E30       dc.w $FCFC, $00FA, $00FF, $FF19, $F700, $0001, $FFFF, $01FF             ;................
L00002E40       dc.w $FF80, $7F7F, $FC00, $1FFE, $0007, $FFFC, $000F, $F9C0             ;................
L00002E50       dc.w $FFF8, $FC00, $FA00, $00E7, $FD00, $0301, $F000, $01FD             ;................
L00002E60       dc.w $0006, $6000, $0010, $0000, $04FE, $0004, $07FE, $0080             ;..`.............
L00002E70       dc.w $04FC, $00FA, $001B, $1931, $96DA, $0005, $EBD5, $81E6             ;.......1........
L00002E80       dc.w $6721, $1FFA, $BE00, $2D5D, $0002, $AF56, $000F, $E7C0             ;g!....-]...V....
L00002E90       dc.w $FAB4, $FC00, $FA00, $1B18, $3E11, $1400, $05EC, $3380             ;........>.....3.
L00002EA0       dc.w $F878, $3F00, $3CC2, $000E, $6600, $0730, $CE00, $0FE3             ;.x?.<...f..0....
L00002EB0       dc.w $00C6, $78FC, $00FA, $001B, $7FC0, $11E0, $0007, $F00E             ;..x.............

L00002EC0       dc.w $00FF, $803F, $003F, $0000, $3F80, $0007, $C038, $000F             ;...?.?..?....8..
L00002ED0       dc.w $FB61, $41F0, $FC00, $FA00, $1B7F, $FFEE, $0000, $03FF             ;.aA.............
L00002EE0       dc.w $FE01, $FFFF, $C0FE, $7FF8, $000F, $FC00, $07FF, $F800             ;................
L00002EF0       dc.w $0FFC, $817F, $F0FC, $00FA, $0000, $7EFD, $0004, $07E0             ;..........~.....
L00002F00       dc.w $0000, $80FE, $0006, $3000, $0008, $0000, $02FE, $0003             ;......0.........
L00002F10       dc.w $0FFF, $0140, $FB00, $FA00, $093D, $9B2D, $9B00, $07ED             ;...@.....=.-....
L00002F20       dc.w $FF81, $DFFE, $FF0E, $BFFC, $003F, $FF00, $056F, $FE00             ;.........?...o..
L00002F30       dc.w $0FFF, $C35F, $FCFC, $00FA, $001B, $3E1C, $2215, $0003             ;..._......>."...
L00002F40       dc.w $E6FF, $805F, $FFFF, $FE7F, $FC00, $0FFC, $0007, $3FFE             ;..._..........?.
L00002F50       dc.w $000F, $FF80, $5FF0, $FC00, $FA00, $093F, $E023, $E000             ;...._......?.#..
L00002F60       dc.w $07F7, $0000, $60FE, $000D, $7802, $0030, $0000, $03B0             ;....`...x..0....
L00002F70       dc.w $0000, $0F80, $61A0, $FB00, $FA00, $093F, $FFDC, $0000           ;....a......?....
L00002F80       dc.w $01F8, $0001, $E0FE, $0000, $78FC, $0007, $03C0, $0000             ;........x.......
L00002F90       dc.w $0F80, $0220, $FB00, $FA00, $003C, $FD00, $1607, $FFFC             ;... .....<......
L00002FA0       dc.w $007F, $FFFF, $FE3F, $F800, $0FFC, $0001, $FFF0, $0007             ;.....?..........
L00002FB0       dc.w $FF82, $7FF0, $FC00, $FA00, $093F, $FFFF, $F600, $00DF             ;.........?......
L00002FC0       dc.w $FF81, $DFFE, $FF0E, $93FC, $001F, $FF00, $06FF, $FE00             ;................
L00002FD0       dc.w $07BF, $C4FF, $FCFC, $00FA, $001B, $3FFF, $FFEA, $0000             ;..........?.....
L00002FE0       dc.w $DFFF, $804F, $FFFF, $FE13, $FC00, $2FFD, $0006, $FFFE             ;...O....../.....
L00002FF0       dc.w $000F, $BF85, $6FF0, $FC00, $FA00, $093C, $0000, $0180             ;....o......<....
L00003000       dc.w $03E0, $0000, $20FE, $000D, $6C02, $0030, $0000, $0180             ;.... ...l..0....
L00003010       dc.w $0000, $0DC0, $6580, $FB00, $FA00, $003C, $FD00, $0403             ;....e......<....
L00003020       dc.w $E000, $01B0, $FE00, $00EC, $FC00, $0701, $8000, $000D           ;................
L00003030       dc.w $C000, $10FB, $00FA, $001B, $3FFF, $FFE0, $0003, $FFFE             ;........?.......
L00003040       dc.w $007F, $FFFF, $FE7F, $F800, $0FFC, $0001, $FFF8, $0003             ;................
L00003050       dc.w $FF84, $7FF0, $FC00, $FA00, $0819, $FFFF, $FE00, $06DF             ;................
L00003060       dc.w $FF81, $FDFF, $0E7F, $FD00, $7FFF, $0004, $FFFE, $0003             ;................
L00003070       dc.w $3FF1, $7FFC, $FC00, $FA00, $1B19, $FFFF, $FE00, $00CF             ;?...............
L00003080       dc.w $FF00, $6FFF, $FFFE, $19F9, $002F, $FF00, $01BF, $FC00             ;..o....../......
L00003090       dc.w $0F1F, $99FF, $F0FC, $00FA, $0009, $7E00, $0001, $C005             ;..........~.....
L000030A0       dc.w $2000, $C008, $FE00, $0D80, $0200, $6000, $000F, $0003             ; .........`.....
L000030B0       dc.w $000C, $C029, $88FB, $00FA, $0000, $7EFD, $0008, $0330             ;...)......~....0
L000030C0       dc.w $0001, $9000, $0001, $E6FB, $0004, $4000, $000C, $E0F9             ;..........@.....
L000030D0       dc.w $00FA, $001B, $7FFF, $FFF8, $0007, $FFFF, $007F, $FFFF             ;................
L000030E0       dc.w $FEDF, $F800, $0FFC, $0001, $FFFC, $0003, $FF88, $7FF0             ;................
L000030F0       dc.w $FC00, $FA00, $09CB, $FFFF, $FC00, $07FF, $FF81, $FBFC             ;................
L00003100       dc.w $FF0C, $005F, $FF00, $05FF, $FE00, $0BDF, $F0FB, $FCFC             ;..._............
L00003110       dc.w $00FA, $001B, $18FF, $FFFC, $0004, $EFFF, $007F, $FFFF             ;................
L00003120       dc.w $FE1F, $FC00, $1FFF, $0001, $FFFC, $0007, $9FC0, $FFF0             ;................
L00003130       dc.w $FC00, $FA00, $0934, $0000, $03C0, $0508, $00C0, $0CFE             ;.....4..........

L00003140       dc.w $00FF, $03FD, $0007, $0E20, $0300, $0C30, $3084, $FB00             ;....... ...00...
L00003150       dc.w $FA00, $00F7, $FD00, $0B02, $1000, $0180, $0000, $01E0           ;................
L00003160       dc.w $0000, $60FB, $0002, $0C60, $01FA, $00FA, $0009, $EFFF             ;..`....`........
L00003170       dc.w $FFFC, $0006, $FFFF, $007F, $FEFF, $0E9F, $FC00, $1FFC             ;................
L00003180       dc.w $0001, $FFFC, $0003, $FFD0, $7FF0, $FC00, $FB00, $0001             ;................
L00003190       dc.w $FDFF, $1700, $06FB, $FF41, $FBFF, $FFFE, $7E7F, $005F             ;.......A....~.._
L000031A0       dc.w $FE00, $0BEF, $FD00, $0FF7, $F07F, $FCFC, $00FB, $001C             ;................
L000031B0       dc.w $018D, $FFFF, $FE00, $0DFF, $FF80, $7DFF, $FFFC, $1FFC           ;..........}.....
L000031C0       dc.w $001F, $FE00, $07FF, $FE00, $03EF, $D17D, $F0FC, $00FB             ;...........}....
L000031D0       dc.w $000A, $01B1, $8000, $01E0, $0F0C, $00C0, $06FE, $000D           ;................
L000031E0       dc.w $0183, $0000, $0100, $0C10, $0300, $0C28, $2002, $FB00           ;...........( ...
L000031F0       dc.w $FA00, $0072, $FA00, $0801, $8000, $0003, $E000, $0060             ;...r...........`
L00003200       dc.w $FB00, $030C, $1001, $80FB, $00FB, $001C, $01CF, $FFFF             ;................
L00003210       dc.w $FE00, $0CFF, $FF00, $7FFF, $FFFE, $1FFC, $001F, $FC00             ;................
L00003220       dc.w $03FF, $FC00, $03FF, $C07F, $F0FC, $00FA, $0008, $9F3F             ;...............?
L00003230       dc.w $FFFF, $8016, $FBFF, $41FD, $FF0E, $7FFE, $005F, $FC00             ;......A......_..
L00003240       dc.w $0BFF, $FD00, $07EF, $F07F, $FCFC, $00FB, $000A, $038F             ;................
L00003250       dc.w $FFFF, $FE00, $0DFD, $FF80, $7DFE, $FF0E, $1F3D, $001F             ;........}....=..
L00003260       dc.w $FC00, $07FF, $FE00, $03FB, $D1FF, $F0FC, $00FB, $001A             ;................
L00003270       dc.w $03B1, $C000, $01E0, $1F06, $00C0, $0200, $0001, $00C3             ;................
L00003280       dc.w $0000, $0300, $0C00, $0300, $0C1C, $20FA, $00FA, $0000             ;.......... .....
L00003290       dc.w $30FA, $0001, $0180, $FE00, $03E0, $0000, $60FB, $0003           ;0...........`...
L000032A0       dc.w $0C00, $0180, $FB00, $FB00, $1C03, $8FFF, $FFFE, $001C           ;................
L000032B0       dc.w $FFFF, $007F, $FFFF, $FE1F, $FC00, $1FFC, $0003, $FFFC             ;................
L000032C0       dc.w $0003, $FFC0, $7FF0, $FC00, $0200, $4020, $FD00, $200F             ;..........@ .. .
L000032D0       dc.w $3FFF, $FF40, $95FF, $FF81, $7FFF, $FFFE, $FFFE, $84FF             ;?..@............
L000032E0       dc.w $FC00, $47FF, $FE08, $03FB, $E97F, $FC00, $0020, $0484             ;..G.......... ..
L000032F0       dc.w $07CA, $271B, $1C4D, $630B, $0FFE, $FF05, $800F, $FDFF             ;..'..Mc.........
L00003300       dc.w $CC7F, $FEFF, $139F, $FD90, $1FFC, $308F, $FFFF, $0843             ;..........0....C
L00003310       dc.w $F7C3, $FFF1, $E435, $1988, $22FE, $000C, $8000, $0423             ;.....5.."......#
L00003320       dc.w $B0C0, $0000, $E017, $0200, $C0FE, $000D, $0180, $0108           ;................
L00003330       dc.w $A003, $000C, $0003, $030C, $0C10, $FE00, $0382, $2010             ;.............. .
L00003340       dc.w $00FA, $0000, $30FA, $0001, $0180, $FE00, $0360, $0000           ;....0........`..
L00003350       dc.w $40FB, $0003, $0C00, $0180, $FB00, $FE00, $0480, $0004           ;@...............
L00003360       dc.w $238F, $FEFF, $1C00, $14FF, $FF00, $7FFF, $FFFE, $1FFC             ;#...............
L00003370       dc.w $081F, $FC00, $03FF, $FC03, $03FF, $C07F, $F000, $8220             ;............... 
L00003380       dc.w $1000, $FB00, $0903, $2FDF, $FFFF, $E001, $FFFF, $80FD             ;....../.........
L00003390       dc.w $FF13, $7FFF, $807F, $FC00, $07FF, $FE00, $0BFF, $E9FF             ;................
L000033A0       dc.w $FC00, $0040, $0000, $0700, $1004, $0300, $8120, $0FFE             ;...@......... ..
L000033B0       dc.w $FF1C, $8006, $FFFF, $607F, $FFFF, $FE9F, $FF88, $9FFC             ;......`.........

L000033C0       dc.w $005B, $FFFD, $8283, $FDE1, $FFF0, $8180, $0010, $0AFD             ;.[..............
L000033D0       dc.w $000B, $0400, $0310, $2000, $00E8, $4700, $00E0, $FE00             ;...... ...G.....
L000033E0       dc.w $0D01, $8001, $8000, $0340, $1C00, $0380, $0402, $10FB             ;.......@........
L000033F0       dc.w $0000, $04FA, $0000, $30FA, $0001, $0180, $FE00, $0360             ;......0........`


batman_end:                                                                             ; end of 'BATMAN' file


