
;---------- Includes ----------
              INCDIR      "include"
              INCLUDE     "hw.i"
              INCLUDE     "funcdef.i"
              INCLUDE     "exec/exec_lib.i"
              INCLUDE     "graphics/graphics_lib.i"
              INCLUDE     "hardware/cia.i"
;---------- Const ----------

batman_start:
L00000800     BRA.B  L0000081C                                               ; Entry point from end of bootblock.s $800

L00000802     dc.w   $0000, $22BA, $0000, $0000, $0000, $0000, $0000, $0000
L00000812     dc.w   $0000, $0000, $0000, $0000, $0000

stack:
L0000081C     BRA.W  L00000838                                               ; Do Loading Screen
L00000820     BRA.W  L00000948
L00000824     BRA.W  L000009C8
L00000828     BRA.W  L00000A78
L0000082C     BRA.W  L00000B28
L00000830     BRA.W  L00000B90
L00000834     BRA.W  L00000C40

L00000838     LEA.L  stack,A7                                                       ; Address $0000081C
L0000083C     BSR.W  L00001F26
L00000840     BSR.W  L00001B4A
L00000844     MOVE.L #$0007c7fc,L00000CF4
L0000084E     MOVE.L #$00002ad6,L00000CF0
L00000858     LEA.L  L000008C8(PC),A0
L0000085C     BSR.W  L00000CFC
L00000860     LEA.L  CUSTOM,A6
L00000866     LEA.L  COLOR00(A6),A0
L0000086A     MOVE.L #$0000001f,D0
L0000086C     CLR.W (A0)+
L0000086E     DBF.W D0,L0000086C

L00000872     MOVE.W #$0000,$0108(A6)
L00000878     MOVE.W #$0000,$010a(A6)
L0000087E     MOVE.W #$0038,$0092(A6)
L00000884     MOVE.W #$00d0,$0094(A6)
L0000088A     MOVE.W #$2c81,$008e(A6)
L00000890     MOVE.W #$2cc1,$0090(A6)
L00000896     MOVE.W #$5200,$0100(A6)
L0000089C     LEA.L  L00001490(PC),A0
L000008A0     MOVE.L A0,$0080(A6)
L000008A4     LEA.L  L00001538(PC),A0
L000008A8     MOVE.L A0,$0084(A6)
L000008AC     MOVE.W A0,$008a(A6)
L000008B0     MOVE.W #$8180,$0096(A6)
L000008B6     CLR.W  L0000223A
L000008BC     CMP.W  #$00fa,L0000223A
L000008C4     BCS.B  L000008BC
L000008C6     BRA.B  L0000090E

L000008C8     dc.w $0020, $002E, $0000, $0000, $0000, $0000, $0000, $0000           ;. ..............
L000008D8     dc.w $002B, $0007, $C7FC, $0000, $0000, $0000, $0000, $0000           ;.+..............
L000008E8     dc.w $4241, $544D, $414E, $204D, $4F56, $4945, $2020, $2030           ;BATMAN MOVIE   0
L000008F8     dc.w $4C4F, $4144, $494E, $4720, $4946, $4650, $414E, $454C           ;LOADING IFFPANEL
L00000908     dc.w $2020, $2049, $4646                                              ;   IFF

L0000090E     LEA.L  stack,A7                                                       ; Address $0000081C
L00000912     BSR.W  L00001F26
L00000916     MOVE.L #$0007c7fc,L00000CF4
L00000920     MOVE.L #$00002ad6,L00000CF0
L0000092A     LEA.L  L00000982(PC),A0
L0000092E     BSR.W  L00000CFC
L00000932     MOVE.W #$7fff,$009a(A6)
L00000938     MOVE.W #$1fff,$0096(A6)
L0000093E     MOVE.W #$2000,SR                                                      ; *** CHECK THIS ****
L00000942     JMP    $0001c000                                                      ; Title Screen Start (on load)

L00000948     LEA.L  stack,A7                                                       ; Address $0000081C
L0000094C     BSR.W  L00001F26
L00000950     MOVE.L #$0007c7fc,L00000CF4
L0000095A     MOVE.L #$00002ad6,L00000CF0
L00000964     LEA.L  L00000982(PC),A0
L00000968     BSR.W  L00000CFC
L0000096C     MOVE.W #$7fff,$009a(A6)
L00000972     MOVE.W #$1fff,$0096(A6)
L00000978     MOVE.W #$2000,SR
L0000097C     JMP    $0001c004                                                      ; Title Screen Start (on end game)

L00000982     dc.w   $0020, $002E, $0000, $3FFC, $0000, $0000, $0000, $0000         ;. ....?.........
L00000992     dc.w   $002B, $0003, $F236, $0000, $0000, $0000, $0000, $0000         ;.+...6..........
L000009A2     dc.w   $4241, $544D, $414E, $204D, $4F56, $4945, $2020, $2030         ;BATMAN MOVIE   0
L000009B2     dc.w   $5449, $544C, $4550, $5247, $4946, $4654, $4954, $4C45         ;TITLEPRGIFFTITLE
L000009C2     dc.w   $5049, $4349, $4646                                            ;PICIFF

L000009C8     LEA.L  stack,A7                                                       ; Address $0000081C
L000009CC     BSR.W  L00001F26
L000009D0     MOVE.L #$0007c7fc,L00000CF4
L000009DA     MOVE.L #$00002ad6,L00000CF0
L000009E4     LEA.L  L00000A00(PC),A0
L000009E8     BSR.W  L00000CFC
L000009EC     MOVE.W #$7fff,$009a(A6)
L000009F2     MOVE.W #$1fff,$0096(A6)
L000009F8     MOVE.W #$2000,SR
L000009FC     JMP $00003000

L00000A00     dc.w   $003C, $004A, $0000, $2FFC, $0000, $0000, $0000, $0000         ;.<.J../.........
L00000A10     dc.w   $0047, $0000, $7FFC, $0000, $0000, $0000, $0000, $0044         ;.G.............D
L00000A20     dc.w   $0001, $0FFC, $0000, $0000, $0000, $0000, $0041, $0004         ;.............A..
L00000A30     dc.w   $7FE4, $0000, $0000, $0000, $0000, $0000, $4241, $544D         ;............BATM
L00000A40     dc.w   $414E, $204D, $4F56, $4945, $2020, $2030, $434F, $4445         ;AN MOVIE   0CODE
L00000A50     dc.w   $3120, $2020, $4946, $464D, $4150, $4752, $2020, $2049         ;1   IFFMAPGR   I
L00000A60     dc.w   $4646, $4241, $5453, $5052, $3120, $4946, $4643, $4845         ;FFBATSPR1 IFFCHE
L00000A70     dc.w   $4D20, $2020, $2049, $4646                                     ;M    IFF

L00000A78     LEA.L  stack,A7                                                       ; Address $0000081C
L00000A7C     BSR.W  L00001F26
L00000A80     MOVE.L #$0007c7fc,L00000CF4
L00000A8A     MOVE.L #$00002ad6,L00000CF0
L00000A94     LEA.L  L00000AB0(PC),A0
L00000A98     BSR.W  L00000CFC
L00000A9C     MOVE.W #$7fff,$009a(A6)
L00000AA2     MOVE.W #$1fff,$0096(A6)
L00000AA8     MOVE.W #$2000,SR
L00000AAC     JMP $00003000

L00000AB0     dc.w   $003C, $004A, $0000, $2FFC, $0000, $0000, $0000, $0000         ;.<.J../.........
L00000AC0     dc.w   $0047, $0001, $FFFC, $0000, $0000, $0000, $0000, $0044         ;.G.............D
L00000AD0     dc.w   $0002, $A416, $0000, $0000, $0000, $0000, $0041, $0006         ;.............A..
L00000AE0     dc.w   $8F7C, $0000, $0000, $0000, $0000, $0000, $4241, $544D         ;.|..........BATM
L00000AF0     dc.w   $414E, $204D, $4F56, $4945, $2020, $2031, $434F, $4445         ;AN MOVIE   1CODE
L00000B00     dc.w   $2020, $2020, $4946, $4644, $4154, $4120, $2020, $2049         ;    IFFDATA    I
L00000B10     dc.w   $4646, $4441, $5441, $3220, $2020, $4946, $464D, $5553         ;FFDATA2   IFFMUS
L00000B20     dc.w   $4943, $2020, $2049, $4646                                     ;IC   IFFO

L00000B28     LEA.L  stack,A7                                                       ; Address $0000081C
L00000B2C     BSR.W  L00001F26
L00000B30     MOVE.L #$0007c7fc,L00000CF4
L00000B3A     MOVE.L #$00002ad6,L00000CF0
L00000B44     LEA.L  L00000B62(PC),A0
L00000B48     BSR.W  L00000CFC
L00000B4C     MOVE.W #$7fff,$009a(A6)
L00000B52     MOVE.W #$1fff,$0096(A6)
L00000B58     MOVE.W #$2000,SR
L00000B5C     JMP $0000d000

L00000B62     dc.w   $0012, $0020, $0000, $3FFC, $0000, $0000, $0000, $0000         ;... ..?.........
L00000B72     dc.w   $0000, $4241, $544D, $414E, $204D, $4F56, $4945, $2020         ;..BATMAN MOVIE  
L00000B82     dc.w   $2031, $4241, $5443, $4156, $4520, $4946, $4600                ; 1BATCAVE IFF.

L00000B90     LEA.L  stack,A7                                                       ; Address $0000081C
L00000B94     BSR.W  L00001F26
L00000B98     MOVE.L #$0007c7fc,L00000CF4
L00000BA2     MOVE.L #$00002ad6,L00000CF0
L00000BAC     LEA.L  L00000BC8(PC),A0
L00000BB0     BSR.W  L00000CFC
L00000BB4     MOVE.W #$7fff,$009a(A6)
L00000BBA     MOVE.W #$1fff,$0096(A6)
L00000BC0     MOVE.W #$2000,SR
L00000BC4     JMP $00003002

L00000BC8     dc.w   $003C, $004A, $0000, $2FFC, $0000, $0000, $0000, $0000         ;.<.J../.........
L00000BD8     dc.w   $0047, $0001, $FFFC, $0000, $0000, $0000, $0000, $0044         ;.G.............D
L00000BE8     dc.w   $0002, $A416, $0000, $0000, $0000, $0000, $0041, $0006         ;.............A..
L00000BF8     dc.w   $8F7C, $0000, $0000, $0000, $0000, $0000, $4241, $544D         ;.|..........BATM
L00000C08     dc.w   $414E, $204D, $4F56, $4945, $2020, $2031, $434F, $4445         ;AN MOVIE   1CODE
L00000C18     dc.w   $2020, $2020, $4946, $4644, $4154, $4120, $2020, $2049         ;    IFFDATA    I
L00000C28     dc.w   $4646, $4441, $5441, $3420, $2020, $4946, $464D, $5553         ;FFDATA4   IFFMUS
L00000C38     dc.w   $4943, $2020, $2049, $4646                                     ;IC   IFFO...a...

L00000C40     LEA.L  stack,A7                                                       ; Address $0000081C
L00000C44     BSR.W  L00001F26
L00000C48     MOVE.L #$0007c7fc,L00000CF4
L00000C52     MOVE.L #$00002ad6,L00000CF0
L00000C5C     LEA.L  L00000C78(PC),A0
L00000C60     BSR.W  L00000CFC
L00000C64     MOVE.W #$7fff,$009a(A6)
L00000C6A     MOVE.W #$1fff,$0096(A6)
L00000C70     MOVE.W #$2000,SR
L00000C74     JMP $00003000

L00000C78     dc.w   $003C, $004A, $0000, $2FFC, $0000, $0000, $0000, $0000         ;.<.J../.........
L00000C88     dc.w   $0047, $0000, $7FFC, $0000, $0000, $0000, $0000, $0044         ;.G.............D
L00000C98     dc.w   $0001, $0FFC, $0000, $0000, $0000, $0000, $0041, $0004         ;.............A..
L00000CA8     dc.w   $7FE4, $0000, $0000, $0000, $0000, $0000, $4241, $544D         ;............BATM
L00000CB8     dc.w   $414E, $204D, $4F56, $4945, $2020, $2030, $434F, $4445         ;AN MOVIE   0CODE
L00000CC8     dc.w   $3520, $2020, $4946, $464D, $4150, $4752, $3220, $2049         ;5   IFFMAPGR2  I
L00000CD8     dc.w   $4646, $4241, $5453, $5052, $3120, $4946, $4643, $4855         ;FFBATSPR1 IFFCHU
L00000CE8     dc.w   $5243, $4820, $2049, $4646                                     ;RCH  IFF 
L00000CF0     dc.w   $0000 
L00000CF2     dc.w   $0000
L00000CF4     dc.w   $0000
L00000CF6     dc.w   $0000 
L00000CF8     dc.W   $0000, $0000

loader
L00000CFC       MOVEM.L D0-D7/A0-A6,-(A7)
L00000D00       CLR.W   L00001B08
L00000D06       MOVE.L  #$00002ad6,L00000CF8
L00000D0E       MOVE.L  #$00002cd6,L00001AF2
L00000D18       MOVE.L  #$000042d6,L00001AF6
L00000D22       TST.W   (A0)
L00000D24       BEQ.W   L00000D6E
L00000D28       MOVEA.L A0,A1
L00000D2A       ADDA.W  (A1)+,A0
L00000D2C       MOVE.L  A1,-(A7)
L00000D2E       BSR.W   L000015DE
L00000D32       BEQ.B   L00000D38
L00000D34       BSR.W   L000013B2
L00000D38       MOVEA.L (A7),A0
L00000D3A       LEA.L   $0007c7fc,A6
L00000D40       CLR.W   L00001B08
L00000D46       BSR.W   L00001652
L00000D4A       MOVEA.L (A7)+,A0
L00000D4C       BNE.B   L00000D6E
L00000D4E       TST.W   (A0)
L00000D50       BEQ.B   L00000D6E
L00000D52       MOVE.L  A0,-(A7)
L00000D54       MOVE.L  $0002(A0),L00000CF0
L00000D5A       MOVE.L  $0006(A0),D0
L00000D5E       MOVEA.L $000a(A0),A0
L00000D62       BSR.W   L000016E0
L00000D66       MOVEA.L (A7)+,A0
L00000D68       LEA.L   $000e(A0),A0
L00000D6C       BRA.B   L00000D4E
L00000D6E       MOVE.W  L00001AFC,D0
L00000D74       BSR.W   L00001B7A
L00000D78       LEA.L   $00bfd100,A0
L00000D7E       CLR.W   L00002144
L00000D84       TST.W   L00002144
L00000D8A       BEQ.B   L00000D84
L00000D8C       MOVE.B  #$00,$0900(A0)                                  ;0001972
L00000D92       MOVE.B  #$00,$0800(A0)                                  ;0001872
L00000D98       MOVE.B  #$00,$0700(A0)                                  ;0001772
L00000D9E       CLR.W   L00002144
L00000DA4       TST.W   L00002144
L00000DAA       BEQ.B   L00000DA4
L00000DAC       MOVE.L  #$00000000,D0
L00000DAE       MOVE.B  $0900(A0),D0                                    ;00001972
L00000DB2       ASL.L   #$00000008,D0
L00000DB4       MOVE.B  $0800(A0),D0                                    ;00001872
L00000DB8       ASL.L   #$00000008,D0
L00000DBA       MOVE.B  $0700(A0),D0                                    ;00001772
L00000DBE       CMP.L   #$00000115,D0
L00000DC4       BCS.B   L00000DC4
L00000DC6       BRA.W   copy_protection_init1                           ;00000E82                   


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
L00001382       LEA.L   L0000139C(PC),A0
L00001386       MOVE.L  A0,$0002(A7)
L0000138A       ILLEGAL 
L0000138C       MOVEM.L D0-D7,$00000008
L00001394       MOVEM.L L00000E10(PC),D0-D7/A0-A6
L0000139A       RTE                                                 ; Return to the Game Loader


L0000139C       MOVE.L  #$00000000,D0
L0000139E       MOVE.W  #$0001,$00001b08
L000013A6       MOVEM.L (A7)+,D0-D7/A0-A6
L000013AA       TST.W   $00001b08
L000013B0       RTS 

                ;----------------- end of copy protection routines ----------------------





                ;---------------------- wrong disk in the drive -------------------------
L000013B2       MOVE.L  A0,-(A7)
L000013B4       LEA.L   L00002334(PC),A0
L000013B8       LEA.L   $00007700,A1
L000013BE       LEA.L   L000014B8(PC),A2
L000013C2       BSR.W   L0000153C
L000013C6       LEA.L   L00002254(PC),A0
L000013CA       MOVEA.L (A7),A1
L000013CC       CMP.B   #$30,$000f(A1)
L000013D2       BEQ.B   L000013D8
L000013D4       LEA.L   $0070(A0),A0
L000013D8       LEA.L   $00007700,A1
L000013DE       ADDA.W  #$1643,A1
L000013E2       MOVE.L  #$0000000d,D0
L000013E4       MOVE.B  (A0)+,$0000(A1)
L000013E8       MOVE.B  (A0)+,$0001(A1)
L000013EC       MOVE.B  (A0)+,$2800(A1)
L000013F0       MOVE.B  (A0)+,$2801(A1)
L000013F4       MOVE.B  (A0)+,$5000(A1)
L000013F8       MOVE.B  (A0)+,$5001(A1)
L000013FC       MOVE.B  (A0)+,$7800(A1)
L00001400       MOVE.B  (A0)+,$7801(A1)
L00001404       SUBA.W  #$0028,A1
L00001408       DBF.W   D0,L000013E4
L0000140C       LEA.L   $00dff000,A6
L00001412       LEA.L   $0180(A6),A0
L00001416       MOVE.L  #$0000001f,D0
L00001418       CLR.W   (A0)+
L0000141A       DBF.W   D0,L00001418
L0000141E       MOVE.W  #$0000,$0108(A6)
L00001424       MOVE.W  #$0000,$010a(A6)
L0000142A       MOVE.W  #$0038,$0092(A6)
L00001430       MOVE.W  #$00d0,$0094(A6)
L00001436       MOVE.W  #$4481,$008e(A6)
L0000143C       MOVE.W  #$0cc1,$0090(A6)
L00001442       MOVE.W  #$4200,$0100(A6)
L00001448       LEA.L   L00001490(PC),A0
L0000144C       MOVE.L  A0,$0080(A6)
L00001450       LEA.L   L00001538(PC),A0
L00001454       MOVE.L  A0,$0084(A6)
L00001458       MOVE.W  A0,$008a(A6)
L0000145C       MOVE.W  #$8180,$0096(A6)
L00001462       CLR.W   L0000223A
L00001468       CMP.W   #$0032,L0000223A
L00001470       BCS.B   L00001468
L00001472       MOVEA.L (A7),A0
L00001474       BSR.W   L000015DE
L00001478       BNE.B   L00001462
L0000147A       LEA.L   $00dff000,A6
L00001480       MOVE.W  #$0200,$0100(A6)
L00001486       MOVE.W  #$0180,$0096(A6)
L0000148C       MOVEA.L (A7)+,A0
L0000148E       RTS 


L00001490       dc.w    $00E0, $0000, $00E2, $7700, $00E4, $0000, $00E6, $9F00                  ;......w.........
L000014A0       dc.w    $00E8, $0000, $00EA, $C700, $00EC, $0000, $00EE, $EF00                  ;................
L000014B0       dc.w    $00F0, $0001, $00F2, $1700
L000014B8       dc.w    $0180, $0000, $0182, $0000              ;................
L000014C0       dc.w    $0184, $0000, $0186, $0000, $0188, $0000, $018A, $0000          ;................
L000014D0       dc.w    $018C, $0000, $018E, $0000, $0190, $0000, $0192, $0000          ;................
L000014E0       dc.w    $0194, $0000, $0196, $0000, $0198, $0000, $019A, $0000          ;................
L000014F0       dc.w    $019C, $0000, $019E, $0000, $01A0, $0000, $01A2, $0000          ;................
L00001500       dc.w    $01A4, $0000, $01A6, $0000, $01A8, $0000, $01AA, $0000          ;................
L00001510       dc.w    $01AC, $0000, $01AE, $0000, $01B0, $0000, $01B2, $0000          ;................
L00001520       dc.w    $01B4, $0000, $01B6, $0000, $01B8, $0000, $01BA, $0000          ;................
L00001530       dc.w    $01BC, $0000, $01BE, $0000
L00001538       dc.w    $FFFF, $FFFE                            


L0000153C       MOVEM.L D0-D1/D7/A0-A3,-(A7)
L00001540       MOVE.B  (A0)+,D0
L00001542       CMP.B   #$03,D0
L00001546       BCS.B   L0000154A
L00001548       ADDA.L  #$00000004,A0
L0000154A       MOVE.L  #$0000000f,D0
L0000154C       ADDA.W  #$00000002,A2
L0000154E       MOVE.B  (A0)+,(A2)+
L00001550       MOVE.B  (A0)+,(A2)+
L00001552       LSL.W   -$0002(A2)
L00001556       DBF.W   D0,L0000154C
L0000155A       MOVE.B  (A0)+,D7
L0000155C       ASL.W   #$00000008,D7
L0000155E       MOVE.B  (A0)+,D7
L00001560       ADDA.L  #$00000002,A0
L00001562       LEA.L   $00(A0,D7.W),A2
L00001566       SUB.W   #$00000001,D7
L00001568       BMI.B   L000015B6
L0000156A       LEA.L   $1f40(A1),A3
L0000156E       MOVE.B  (A0)+,D0
L00001570       BMI.B   L00001584
L00001572       BEQ.B   L00001596
L00001574       CMP.B   #$01,D0
L00001578       BNE.B   L000015A0
L0000157A       MOVE.B  (A0)+,D0
L0000157C       ASL.W   #$00000008,D0
L0000157E       MOVE.B  (A0)+,D0
L00001580       SUB.W   #$00000002,D7
L00001582       BRA.B   L00001588
L00001584       NEG.B   D0
L00001586       EXT.W   D0
L00001588       SUB.W   #$00000001,D0
L0000158A       MOVE.B  (A2)+,(A1)+
L0000158C       MOVE.B  (A2)+,(A1)+
L0000158E       BSR.B   L000015BC
L00001590       DBF.W   D0,L0000158A
L00001594       BRA.B   L000015B2
L00001596       MOVE.B  (A0)+,D0
L00001598       ASL.W   #$00000008,D0
L0000159A       MOVE.B  (A0)+,D0
L0000159C       SUB.W   #$00000002,D7
L0000159E       BRA.B   L000015A2
L000015A0       EXT.W   D0
L000015A2       SUB.W   #$00000001,D0
L000015A4       MOVE.B  (A2)+,D1
L000015A6       ASL.W   #$00000008,D1
L000015A8       MOVE.B  (A2)+,D1
L000015AA       MOVE.W  D1,(A1)+
L000015AC       BSR.B   L000015BC
L000015AE       DBF.W   D0,L000015AA
L000015B2       DBF.W   D7,L0000156E
L000015B6       MOVEM.L (A7)+,D0-D1/D7/A0-A3
L000015BA       RTS 


L000015BC       MOVE.L  D0,-(A7)
L000015BE       LEA.L   $0026(A1),A1
L000015C2       MOVE.L  A1,D0
L000015C4       SUB.L   A3,D0
L000015C6       BCS.B   L000015DA
L000015C8       SUBA.W  #$1f3e,A1
L000015CC       CMP.W   #$0026,D0
L000015D0       BCS.B   L000015DA
L000015D2       SUBA.W  #$d828,A1
L000015D6       LEA.L   $1f40(A1),A3
L000015DA       MOVE.L  (A7)+,D0
L000015DC       RTS 


L000015DE       MOVE.L  A0,-(A7)
L000015E0       MOVE.W  #$0004,L00001AFC
L000015E8       MOVE.W  #$0005,L00001B08
L000015F0       MOVE.W  L00001AFC,D0
L000015F6       SUB.W   #$00000001,D0
L000015F8       BMI.W   L00001648
L000015FC       BTST.B  D0,$00001afb
L00001602       BEQ.B   L000015F6
L00001604       MOVE.W  D0,$00001AFC
L0000160A       BSR.W   L00001B68
L0000160E       BSR.W   L00001BAE
L00001612       BNE.B   L0000163C
L00001614       SF.B    $00001AF0
L0000161A       MOVE.L  #$00000002,D0
L0000161C       BSR.W   L00001B0A
L00001620       BNE.B   L0000163C
L00001622       MOVEA.L (A7),A1
L00001624       MOVE.L  #$0000000f,D0
L00001626       CMPM.B  (A0)+,(A1)+
L00001628       DBNE.W  D0,L00001626
L0000162C       BNE.B   L0000163C
L0000162E       MOVEA.L L00000CF8,A1
L00001632       MOVE.L  #$0000007b,D0
L00001634       MOVE.L  (A0)+,(A1)+
L00001636       DBF.W   D0,L00001634
L0000163A       BRA.B   L00001648
L0000163C       MOVE.W  $00001AFC,D0
L00001642       BSR.W   L00001B7A
L00001646       BRA.B   L000015E8 (T)
L00001648       MOVEA.L (A7)+,A0
L0000164A       TST.W   $00001B08
L00001650       RTS 


L00001652       MOVE.L  A0,-(A7)
L00001654       TST.W   (A0)
L00001656       BEQ.B   L000016D6
L00001658       LEA.L   $000e(A0),A0
L0000165C       BSR.B   L00001652
L0000165E       BNE.B   L000016D6
L00001660       MOVEA.L (A7),A0
L00001662       ADDA.W  (A0),A0
L00001664       MOVEA.L L00000CF8,A1
L00001668       MOVE.L  #$0000001e,D0
L0000166A       MOVEA.L A0,A2
L0000166C       MOVEA.L A1,A3
L0000166E       MOVE.L  #$0000000a,D1
L00001670       CMPM.B  (A2)+,(A3)+
L00001672       DBNE.W  D1,L00001670
L00001676       BEQ.B   L0000168A
L00001678       LEA.L   $0010(A1),A1
L0000167C       DBF.W   D0,L0000166A
L00001680       MOVE.W  #$0005,L00001B08
L00001688       BRA.B   L000016D6
L0000168A       MOVEA.L (A7),A0
L0000168C       MOVE.L  $000a(A1),D2
L00001690       AND.L   #$00ffffff,D2
L00001696       MOVE.L  D2,$0006(A0)
L0000169A       BEQ.B   L000016D6
L0000169C       MOVE.W  $000e(A1),D1
L000016A0       MOVE.L  D2,D0
L000016A2       BTST.L  #$0000,D0
L000016A6       BEQ.B   L000016AA
L000016A8       ADD.L   #$00000001,D0
L000016AA       SUBA.L  D0,A6
L000016AC       MOVEA.L A6,A1
L000016AE       MOVE.L  A6,$000a(A0)
L000016B2       MOVE.W  D1,D0
L000016B4       BSR.W   L00001B0A
L000016B8       BNE.B   L000016D6
L000016BA       MOVE.L  #$00000200,D0
L000016C0       CMP.L   D0,D2
L000016C2       BCC.B   L000016C6
L000016C4       MOVE.L  D2,D0
L000016C6       SUB.L   D0,D2
L000016C8       SUB.W   #$00000001,D0
L000016CA       MOVE.B  (A0)+,(A1)+
L000016CC       DBF.W   D0,L000016CA
L000016D0       ADD.W   #$00000001,D1
L000016D2       TST.L   D2
L000016D4       BNE.B   L000016B2
L000016D6       MOVEA.L (A7)+,A0
L000016D8       TST.W   $00001B08
L000016DE       RTS 


L000016E0       MOVEM.L D0/A0,-(A7)
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


L0000170A       MOVEA.L L00000CF0,A1
L0000170E       ASR.L   #$00000001,D0
L00001710       MOVE.W  (A0)+,(A1)+
L00001712       SUB.L   #$00000001,D0
L00001714       BNE.B   L00001710
L00001716       MOVE.L  A1,L00000CF0
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


L0000190C       MOVEA.L $00000cf0,A2
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
L0000193A       BRA.W   L000016E0
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
L000019D8       LEA.L   L000014B8(PC),A1
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
L00001A24       MOVE.L  A0,$00001A08
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
L00001A50       MOVEA.L $00001a08,A2
L00001A54       TST.B   $0009(A2)
L00001A58       BNE.B   L00001A82
L00001A5A       CMP.B   #$02,$000a(A2)
L00001A60       BCC.B   L00001A82
L00001A62       MOVE.L  #$00000000,D0
L00001A64       MOVE.B  $0008(A2),D0
L00001A68       SUB.W   #$00000001,D0
L00001A6A       MOVE.W  D0,$00001A88
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

L00001AF0       dc.w    $0000 
L00001AF2       dc.w    $0000                                   ;OR.B #$00,D0
L00001AF4       dc.w    $0000 
L00001AF6       dc.w    $0000                                   ;OR.B #$00,D0
L00001AF8       dc.w    $0000, $0000                            ;OR.B #$00,D0
L00001AFC       dc.w    $0000, $0000                            ;OR.B #$00,D0
L00001B00       dc.b    $00
L00001B01       dc.b    $00
L00001B02       dc.w    $0001                            ;OR.B #$01,D0
L00001B04       dc.w    $0000 
L00001B06       dc.w    $0000                           ;OR.B #$00,D0
L00001B08       dc.w    $0000

L00001B0A       MOVEM.L D0-D1,-(A7)
L00001B0E       EXT.L   D0
L00001B10       DIVU.W  #$000b,D0
L00001B14       MOVE.L  D0,D1
L00001B16       SWAP.W  D1
L00001B18       TST.B   L00001AF0
L00001B1C       BEQ.B   L00001B24
L00001B1E       CMP.W   $00001b00,D0
L00001B22       BEQ.B   L00001B32
L00001B24       MOVEA.L $00001af2,A0
L00001B28       BSR.W   L00001CBC
L00001B2C       BNE.B   L00001B40
L00001B2E       ST.B    L00001AF0
L00001B32       MOVEA.L L00001AF2,A0
L00001B36       MULU.W  #$0200,D1
L00001B3A       ADDA.L  D1,A0
L00001B3C       CLR.W   L00001B08
L00001B40       TST.W   L00001B08
L00001B44       MOVEM.L (A7)+,D0-D1
L00001B48       RTS 







L00001B4A       MOVE.L  #$00000003,D0
L00001B4C       MOVE.L  #$00000000,D1
L00001B4E       MOVEM.L D0-D1,-(A7)
L00001B52       BSR.B   L00001B96
L00001B54       BSR.B   L00001BAE
L00001B56       MOVEM.L (A7)+,D0-D1
L00001B5A       BNE.B   L00001B5E
L00001B5C       BSET.L  D0,D1
L00001B5E       SUB.W   #$00000001,D0
L00001B60       BPL.B   L00001B4E
L00001B62       MOVE.W  D1,$00001afa
L00001B66       BRA.B   L00001B8C
L00001B68       BCLR.B  #$0007,$00bfd100
L00001B70       BCLR.B  #$0007,$00bfd100
L00001B78       BRA.B   L00001B96
L00001B7A       BSET.B  #$0007,$00bfd100
L00001B82       BSET.B  #$0007,$00bfd100
L00001B8A       BSR.B   L00001B96
L00001B8C       OR.B    #$78,$00bfd100
L00001B94       RTS 

L00001B96       MOVE.L  D1,-(A7)
L00001B98       OR.B    #$78,$00bfd100
L00001BA0       MOVE.B  D0,D1
L00001BA2       ADD.B   #$00000003,D1
L00001BA4       BCLR.B  D1,$00bfd100
L00001BAA       MOVE.L  (A7)+,D1
L00001BAC       RTS 

L00001BAE       MOVE.W  #$0004,L00001B08
L00001BB4       MOVEM.L D0,-(A7)
L00001BB8       MOVE.W  #$00a6,L00001B00
L00001BBE       CLR.W   D0
L00001BC0       BSR.B   L00001BC8
L00001BC2       MOVEM.L (A7)+,D0
L00001BC6       RTS 

L00001BC8       BSET.B  #$0002,$00bfd100
L00001BD0       BCLR.B  #$0000,L00001B01
L00001BD6       BTST.L  #$0000,D0
L00001BDA       BEQ.B   L00001BEA
L00001BDC       BCLR.B  #$0002,$00bfd100
L00001BE4       BSET.B  #$0000,L00001B01
L00001BEA       CMP.W   $00001B00,D0
L00001BEE       BEQ.B   L00001C5E
L00001BF0       BPL.B   L00001C18
L00001BF2       BSET.B  #$0001,$00bfd100
L00001BFA       BTST.B  #$0004,$00bfe001
L00001C02       BEQ.B   L00001C12
L00001C04       BSR.B   L00001C68
L00001C06       SUB.W   #$00000002,L00001B00
L00001C0A       CMP.W   L00001B00,D0
L00001C0E       BNE.B   L00001BFA
L00001C10       BRA.B   L00001C2C
L00001C12       CLR.W   $00001b00
L00001C16       BRA.B   L00001C2C
L00001C18       BCLR.B  #$0001,$00bfd100
L00001C20       BSR.B   L00001C68
L00001C22       ADD.W   #$00000002,L00001B00
L00001C26       CMP.W   L00001B00,D0
L00001C2A       BNE.B   L00001C20
L00001C2C       MOVE.B  #$00,$00bfde00
L00001C34       MOVE.B  #$f4,$00bfd400
L00001C3C       MOVE.B  #$29,$00bfd500
L00001C44       BCLR.B  #$0002,L0000209A
L00001C4C       MOVE.B  #$19,$00bfde00
L00001C54       BTST.B  #$0002,L0000209A
L00001C5C       BEQ.B   L00001C54
L00001C5E       BTST.B  #$0004,$00bfe001
L00001C66       RTS 

L00001C68       MOVE.B  #$00,$00bfde00
L00001C70       MOVE.B  #$c8,$00bfd400
L00001C78       MOVE.B  #$10,$00bfd500
L00001C80       BCLR.B  #$0000,$00bfd100
L00001C88       BCLR.B  #$0000,$00bfd100
L00001C90       BCLR.B  #$0000,$00bfd100
L00001C98       BSET.B  #$0000,$00bfd100
L00001CA0       BCLR.B  #$0002,$0000209a
L00001CA8       MOVE.B  #$19,$00bfde00
L00001CB0       BTST.B  #$0002,L0000209A
L00001CB8       BEQ.B   L00001CB0
L00001CBA       RTS 

L00001CBC       MOVEM.L D1/A0-A1,-(A7)
L00001CC0       MOVE.W  #$0020,L00001B06
L00001CC6       MOVE.W  #$0001,L00001B08
L00001CCC       MOVE.W  #$0032,L00001B04
L00001CD2       TST.W   L00001B04
L00001CD6       BEQ.B   L00001D0E
L00001CD8       BTST.B  #$0005,$00bfe001
L00001CE0       BNE.B   L00001CD2
L00001CE2       BSR.W   L00001BC8
L00001CE6       MOVE.W  #$0001,L00001B08
L00001CEC       MOVEA.L L00001AF6,A0
L00001CF0       BSR.W   L00001D36
L00001CF4       BEQ.B   L00001D1C
L00001CF6       MOVE.W  #$0002,L00001B08
L00001CFC       MOVEA.L $00001AF6,A0
L00001D00       MOVEA.L $0004(A7),A1
L00001D04       BSR.W   L00001DD0
L00001D08       BNE.B   L00001D1C
L00001D0A       CLR.W   L00001B08
L00001D0E       MOVEM.L (A7)+,D1/A0-A1
L00001D12       LEA.L   $1600(A0),A0
L00001D16       TST.W   L00001B08
L00001D1A       RTS 

L00001D1C       MOVE.W  L00001B06,D1
L00001D20       SUB.W   #$00000001,D1
L00001D22       MOVE.W  D1,L00001B06
L00001D26       BEQ.B   L00001D0E
L00001D28       AND.W   #$0007,D1
L00001D2C       BNE.B   L00001CE6
L00001D2E       BSR.W   L00001BAE
L00001D32       BEQ.B   L00001CE2
L00001D34       BRA.B   L00001D0E
L00001D36       MOVEM.L D0/A0,-(A7)
L00001D3A       MOVE.W  #$0005,L00001B04
L00001D40       TST.W   L00001B04
L00001D44       BEQ.W   L00001DCA
L00001D48       BTST.B  #$0005,$00bfe001
L00001D50       BNE.B   L00001D40
L00001D52       MOVE.W  #$4000,$00dff024
L00001D5A       MOVE.W  #$8010,$00dff096
L00001D62       MOVE.W  #$7f00,$00dff09e
L00001D6A       MOVE.W  #$9500,$00dff09e
L00001D72       MOVE.W  #$4489,$00dff07e
L00001D7A       MOVEA.L $0004(A7),A0
L00001D7E       MOVE.W  #$4489,(A0)+
L00001D82       MOVE.L  A0,$00dff020
L00001D88       MOVE.W  #$0002,$00dff09c
L00001D90       MOVE.W  #$99ff,D0
L00001D94       MOVE.W  D0,$00dff024
L00001D9A       MOVE.W  D0,$00dff024
L00001DA0       MOVE.W  #$0032,L00001B04
L00001DA6       TST.W   L00001B04
L00001DAA       BEQ.B   L00001DB6
L00001DAC       MOVE.L  #$00000002,D0
L00001DAE       AND.W   $00dff01e,D0
L00001DB4       BEQ.B   L00001DA6
L00001DB6       MOVE.W  #$0010,$00dff096
L00001DBE       MOVE.W  #$4000,$00dff024
L00001DC6       TST.W   L00001B04
L00001DCA       MOVEM.L (A7)+,D0/A0
L00001DCE       RTS

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
L00001FF2       MOVE.L  D0,$0026(A0)
L00001FF6       MOVE.L  A0,$00000004
L00001FFA       LEA.L   L0000209C(PC),A0
L00001FFE       MOVE.L  A0,$00000064
L00002002       LEA.L   L000020DA(PC),A0
L00002006       MOVE.L  A0,$00000068
L0000200A       LEA.L   L00002100(PC),A0
L0000200E       MOVE.L  A0,$0000006c
L00002012       LEA.L   L00002146(PC),A0
L00002016       MOVE.L  A0,$00000070
L0000201A       LEA.L   L0000215C(PC),A0
L0000201E       MOVE.L  A0,$00000074
L00002022       LEA.L   L00002182(PC),A0
L00002026       MOVE.L  A0,$00000078
L0000202A       MOVE.W  #$ff00,$0034(A6)
L00002030       MOVE.W  D0,$0036(A6)
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
L00002068       MOVE.B  #$1f,L0000209A
L00002070       MOVE.W  #$7fff,$009c(A6)
L00002076       TST.B   $0c00(A4)
L0000207A       MOVE.B  #$8a,$0c00(A4)
L00002080       TST.B   $0c00(A5)
L00002084       MOVE.B  #$93,$0c00(A5)
L0000208A       MOVE.W  #$e078,$009a(A6)
;L00002090       MV2SR.W #$2000
L00002090       MOVE.W  #$2000,SR
L00002094       RTS 


L0002096        dc.w    $0000, $0000                            ;OR.B #$00,D0

L0000209A       MOVE.B  D0,-(A7)
L0000209C       MOVE.L  D0,-(A7)
L0000209E       MOVE.W  $00dff01e,D0
L000020A4       BTST.L  #$0002,D0
L000020A8       BNE.B   L000020CE
L000020AA       BTST.L  #$0001,D0
L000020AE       BNE.B   L000020BC
L000020B0       MOVE.W  #$0001,$00dff09c
L000020B8       MOVE.L  (A7)+,D0
L000020BA       RTE 

L000020BC       BSET.B  #$0000,L0000209A
L000020C2       MOVE.W  #$0002,$00dff09C
L000020CA       MOVE.L  (A7)+,D0
L000020CC       RTE 

L000020CE       MOVE.W  #$0004,$00dff09c
L000020D6       MOVE.L  (A7)+,D0
L000020D8       RTE 

L000020DA       MOVE.L  D0,-(A7)
L000020DC       MOVE.B  $00bfed01,D0
L000020E2       BPL.B   L000020F4
L000020E4       BSR.W   L000021C0
L000020E8       MOVE.W  #$0008,$00dff09c
L000020F0       MOVE.L  (A7)+,D0
L000020F2       RTE 

L000020F4       MOVE.W  #$0008,$00dff09c
L000020FC       MOVE.L  (A7)+,D0
L000020FE       RTE 

L00002100       MOVE.L  D0,-(A7)
L00002102       MOVE.W  $00dff01e,D0
L00002108       BTST.L  #$0004,D0
L0000210C       BNE.B   L00002138
L0000210E       BTST.L  #$0005,D0
L00002112       BNE.B   L00002126
L00002114       BSET.B  #$0001,L0000209A
L0000211A       MOVE.W  #$0040,$00dff09c
L00002122       MOVE.L  (A7)+,D0
L00002124       RTE 

L00002126       ADD.W   #$00000001,L00002144
L0000212C       MOVE.W  #$0020,$00dff09c
L00002134       MOVE.L  (A7)+,D0
L00002136       RTE 

L00002138       MOVE.W  #$0010,$00dff09c
L00002140       MOVE.L  (A7)+,D0
L00002142       RTE 

L00002144       dc.w    $0000                                   ;OR.B #$00,D0

L00002146       MOVE.L  D0,-(A7)
L00002148       MOVE.W  $00dff01e,D0
L0000214E       AND.W   #$0780,D0
L00002152       MOVE.W  D0,$00dff09a
L00002158       MOVE.L  (A7)+,D0
L0000215A       RTE 

L0000215C       MOVE.L  D0,-(A7)
L0000215E       MOVE.W  $00dff01e,D0
L00002164       BTST.L  #$000c,D0
L00002168       BNE.B   L00002176
L0000216A       MOVE.W  #$0800,$00dff09c
L00002172       MOVE.L  (A7)+,D0
L00002174       RTE 

L00002176       MOVE.W  #$1000,$00dff09c
L0000217E       MOVE.L  (A7)+,D0
L00002180       RTE 

L00002182       MOVE.L  D0,-(A7)
L00002184       MOVE.W  $00dff01e,D0
L0000218A       BTST.L  #$000e,D0
L0000218E       BNE.B   L000021B4
L00002190       MOVE.B  $00bfdd00,D0
L00002196       BPL.B   L000021A8
L00002198       BSR.W   L000021EC
L0000219C       MOVE.W  #$2000,$00dff09c
L000021A4       MOVE.L  (A7)+,D0
L000021A6       RTE 

L000021A8       MOVE.W  #$2000,$00dff09c
L000021B0       MOVE.L  (A7)+,D0
L000021B2       RTE 

L000021B4       MOVE.W  #$4000,$00dff09c
L000021BC       MOVE.L  (A7)+,D0
L000021BE       RTE 

L000021C0       LSR.B   #$00000002,D0
L000021C2       BCC.B   L000021C8
L000021C4       BSR.W   L00002228
L000021C8       LSR.B   #$00000002,D0
L000021CA       BCC.B   L000021EA
L000021CC       MOVEM.L D1-D2/A0,-(A7)
L000021D0       MOVE.B  $00bfec01,D1
L000021D6       MOVE.B  #$40,$00bfee01
L000021DE       MOVE.B  #$19,$00bfdf00
L000021E6       MOVEM.L (A7)+,D1-D2/A0
L000021EA       RTS 

L000021EC       LSR.B   #$00000001,D0
L000021EE       BCC.B   L000021F6
L000021F0       BSET.B  #$0002,L0000209A
L000021F6       LSR.B   #$00000001,D0
L000021F8       BCC.B   L00002202
L000021FA       MOVE.B  #$00,$00bfee01
L00002202       LSR.B   #$00000003,D0
L00002204       BCC.B   L00002226
L00002206       BSET.B  #$0003,$0000209a
L0000220C       BNE.B   L00002226
L0000220E       BSET.B  #$0004,$0000209A
L00002214       BNE.B   L00002226
L00002216       MOVE.W  #$da00,D0
L0000221A       MOVE.W  D0,$00dff024
L00002220       MOVE.W  D0,$00dff024
L00002226       RTS 

L00002228       TST.W   L00001B04
L0000222C       BEQ.B   L00002232
L0000222E       SUB.W   #$00000001,L00001B04
L00002232       ADD.W   #$00000001,L0000223A
L00002238       RTS 


L0000223A       dc.w $0000, $3033, $0000
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
L00002334       dc.w $0000, $0000, $0200, $1301, $2402, $3503             ;............$.5.

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



