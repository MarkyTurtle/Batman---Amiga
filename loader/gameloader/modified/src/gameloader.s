
;---------- Includes ----------
              INCDIR      "include"
              INCLUDE     "hw.i"
              INCLUDE     "funcdef.i"
              INCLUDE     "exec/exec_lib.i"
              INCLUDE     "graphics/graphics_lib.i"
              INCLUDE     "hardware/cia.i"
;---------- Const ----------

batman_start:
L00000800     BRA.B  L0000081c                                               ; Entry point from end of bootblock.s $800

L00000802     dc.w   $0000, $22BA, $0000, $0000, $0000, $0000, $0000, $0000
L00000812     dc.w   $0000, $0000, $0000, $0000, $0000

stack:
L0000081C     BRA.W  L00000838                                               ; Do Loading Screen
L00000820     BRA.W  L00000948
L00000824     BRA.W  L000009c8
L00000828     BRA.W  L00000a78
L0000082C     BRA.W  L00000b28
L00000830     BRA.W  L00000b90
L00000834     BRA.W  L00000c40

L00000838     LEA.L  stack,A7                                                       ; Address $0000081C
L0000083C     BSR.W  L00001F26
L00000840     BSR.W  L00001B4A
L00000844     MOVE.L #$0007c7fc,$00000cf4
L0000084E     MOVE.L #$00002ad6,$00000cf0
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
L000009E4     LEA.L  L00000a00(PC),A0
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
L00000CF0     dc.w    $0000, $0000, $0000, $0000 
L00000CF8     dc.W    $0000, $0000

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
L00000E48       dc.W    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00000E58       dc.W    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000          ;................
L00000E68       dc.W    $0000, $0000, $0000, $0000, $FFFF, $FFFF, $0000, $0001          ;................
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
L00000EC4       BRA.W L00000ed4
L00000EC8       BRA.W L00000f04
L00000ECC       BRA.W L00000f30
L00000ED0       BRA.W L00000edc
L00000ED4       BRA.W L00000ee0                                            
L00000ED8       BRA.W L00000ef4
L00000EDC       BRA.W L00000f00
L00000EE0       BRA.W L00000f34
L00000EE4       BRA.W L00000ec8
L00000EE8       BRA.W L00000ef0
L00000EEC       BRA.W L00000efc
L00000EF0       BRA.W L00000f0c
L00000EF4       BRA.W L00000f2c
L00000EF8       BRA.W L00000f28
L00000EFC       BRA.W L00000f10
L00000F00       BRA.W L00000ee4
L00000F04       BRA.W L00000ee8
L00000F08       BRA.W cp_set_vectors                                        ;L00000f9e Exit point from the jumps
L00000F0C       BRA.W L00000f14
L00000F10       BRA.W L00000ed0
L00000F14       BRA.W L00000f1c
L00000F18       BRA.W L00000ecc
L00000F1C       BRA.W L00000ed8
L00000F20       BRA.W L00000eec
L00000F24       BRA.W L00000ef8
L00000F28       BRA.W L00000f18
L00000F2C       BRA.W L00000f24
L00000F30       BRA.W L00000f08
L00000F34       BRA.W L00000f20


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
L00000FB6       DBF.W D0,L00000fAE
L00000FBA       BRA.W L00000FCE

exception_vector_offsets
L00000FBE       dc.w    $059A, $051A, $00B6, $05DA, $061A ,$069A ,$051A, $00F0              ;................

00000FCE 43fa fe80                LEA.L (PC,$fe80) == $00000e50,A1
00000FD2 42a9 001c                CLR.L (A1, $001c) == $00c014fe
00000FD6 6100 0098                BSR.W #$0098 == $00001070
00000FDA 6700 0392                BEQ.W #$0392 == $0000136e (F)
00000FDE 7406                     MOVE.L #$00000006,D2
00000FE0 5382                     SUB.L #$00000001,D2
00000FE2 6760                     BEQ.B #$00000060 == $00001044 (F)
00000FE4 41fa fde4                LEA.L (PC,$fde4) == $00000dca,A0
00000FE8 7005                     MOVE.L #$00000005,D0
00000FEA 6100 00c8                BSR.W #$00c8 == $000010b4
00000FEE 2600                     MOVE.L D0,D3
00000FF0 7004                     MOVE.L #$00000004,D0
00000FF2 6100 00c0                BSR.W #$00c0 == $000010b4
00000FF6 2200                     MOVE.L D0,D1
00000FF8 2003                     MOVE.L D3,D0
00000FFA 615c                     BSR.B #$0000005c == $00001058
00000FFC 6be2                     BMI.B #$ffffffe2 == $00000fe0 (F)
00000FFE 7006                     MOVE.L #$00000006,D0
00001000 6100 00b2                BSR.W #$00b2 == $000010b4
00001004 2203                     MOVE.L D3,D1
00001006 6150                     BSR.B #$00000050 == $00001058
00001008 6bd6                     BMI.B #$ffffffd6 == $00000fe0 (F)
0000100A 0c90 526f 6220           CMP.L #$526f6220,(A0)
00001010 66ce                     BNE.B #$ffffffce == $00000fe0 (T)
00001012 0ca8 4e6f 7274 0004      CMP.L #$4e6f7274,(A0, $0004) == $00fe971a
0000101A 66c4                     BNE.B #$ffffffc4 == $00000fe0 (T)
0000101C 0ca8 6865 6e20 0008      CMP.L #$68656e20,(A0, $0008) == $00fe971e
00001024 66ba                     BNE.B #$ffffffba == $00000fe0 (T)
00001026 0ca8 436f 6d70 000c      CMP.L #$436f6d70,(A0, $000c) == $00fe9722
0000102E 66b0                     BNE.B #$ffffffb0 == $00000fe0 (T)
00001030 7205                     MOVE.L #$00000005,D1
00001032 2248                     MOVEA.L A0,A1
00001034 d099                     ADD.L (A1)+,D0
00001036 e398                     ROL.L #$00000001,D0
00001038 51c9 fffa                DBF .W D1,#$fffa == $00001034 (F)
0000103C 43fa fe12                LEA.L (PC,$fe12) == $00000e50,A1
00001040 d1a9 001c                ADD.L D0,(A1, $001c) == $00c014fe
00001044 343a fe32                MOVE.W (PC,$fe32) == $00000e78,D2
00001048 6100 0202                BSR.W #$0202 == $0000124c
0000104C 6100 01cc                BSR.W #$01cc == $0000121a
00001050 203a fe1a                MOVE.L (PC,$fe1a) == $00000e6c,D0
00001054 6000 0318                BT .W #$0318 == $0000136e (T)
00001058 9081                     SUB.L D1,D0
0000105A 6b10                     BMI.B #$00000010 == $0000106c (F)
0000105C c0fc 0064                MULU.W #$0064,D0
00001060 80c1                     DIVU.W D1,D0
00001062 b03c 0003                CMP.B #$03,D0
00001066 6d04                     BLT.B #$00000004 == $0000106c (F)
00001068 7000                     MOVE.L #$00000000,D0
0000106A 4e75                     RTS 

0000106C 70ff                     MOVE.L #$ffffffff,D0
0000106E 4e75                     RTS 

00001070 7003                     MOVE.L #$00000003,D0
00001072 6100 0192                BSR.W #$0192 == $00001206
00001076 6624                     BNE.B #$00000024 == $0000109c (T)
00001078 7400                     MOVE.L #$00000000,D2
0000107A 6100 01d0                BSR.W #$01d0 == $0000124c
0000107E 661c                     BNE.B #$0000001c == $0000109c (T)
00001080 41fa fd48                LEA.L (PC,$fd48) == $00000dca,A0
00001084 7402                     MOVE.L #$00000002,D2
00001086 303a 0162                MOVE.W (PC,$0162) == $000011ea,D0
0000108A 6100 00a8                BSR.W #$00a8 == $00001134
0000108E 6622                     BNE.B #$00000022 == $000010b2 (T)
00001090 51ca fff4                DBF .W D2,#$fff4 == $00001086 (F)
00001094 343a fde2                MOVE.W (PC,$fde2) == $00000e78,D2
00001098 6100 01b2                BSR.W #$01b2 == $0000124c
0000109C 6100 017c                BSR.W #$017c == $0000121a
000010A0 41fa fdd2                LEA.L (PC,$fdd2) == $00000e74,A0
000010A4 0650 0001                ADD.W #$0001,(A0)
000010A8 0250 0003                AND.W #$0003,(A0)
000010AC 51cb ffc4                DBF .W D3,#$ffc4 == $00001072 (F)
000010B0 7000                     MOVE.L #$00000000,D0
000010B2 4e75                     RTS 

000010B4 48e7 e0c0                MOVEM.L D0-D2/A0-A1,-(A7)
000010B8 6150                     BSR.B #$00000050 == $0000110a
000010BA 2400                     MOVE.L D0,D2
000010BC 2017                     MOVE.L (A7),D0
000010BE 43fa 012a                LEA.L (PC,$012a) == $000011ea,A1
000010C2 e388                     LSL.L #$00000001,D0
000010C4 3031 0800                MOVE.W (A1, D0.L*1, $00) == $00c014e2,D0
000010C8 2200                     MOVE.L D0,D1
000010CA 2001                     MOVE.L D1,D0
000010CC 6166                     BSR.B #$00000066 == $00001134
000010CE 67fa                     BEQ.B #$fffffffa == $000010ca (F)
000010D0 2e80                     MOVE.L D0,(A7)
000010D2 3010                     MOVE.W (A0),D0
000010D4 b540                     EOR.W D2,D0
000010D6 0240 5555                AND.W #$5555,D0
000010DA 66ee                     BNE.B #$ffffffee == $000010ca (T)
000010DC 2248                     MOVEA.L A0,A1
000010DE 4a58                     TST.W (A0)+
000010E0 720b                     MOVE.L #$0000000b,D1
000010E2 2018                     MOVE.L (A0)+,D0
000010E4 6100 000e                BSR.W #$000e == $000010f4
000010E8 32c0                     MOVE.W D0,(A1)+
000010EA 51c9 fff6                DBF .W D1,#$fff6 == $000010e2 (F)
000010EE 4cdf 0307                MOVEM.L (A7)+,D0-D2/A0-A1
000010F2 4e75                     RTS 


000010F4 48e7 6000                MOVEM.L D1-D2,-(A7)
000010F8 2200                     MOVE.L D0,D1
000010FA 740f                     MOVE.L #$0000000f,D2
000010FC e591                     ROXL.L #$00000002,D1
000010FE e390                     ROXL.L #$00000001,D0
00001100 51ca fffa                DBF .W D2,#$fffa == $000010fc (F)
00001104 4cdf 0006                MOVEM.L (A7)+,D1-D2
00001108 4e75                     RTS 


0000110A 48e7 6000                MOVEM.L D1-D2,-(A7)
0000110E 4840                     SWAP.W D0
00001110 2400                     MOVE.L D0,D2
00001112 720f                     MOVE.L #$0000000f,D1
00001114 e588                     LSL.L #$00000002,D0
00001116 e392                     ROXL.L #$00000001,D2
00001118 650c                     BCS.B #$0000000c == $00001126 (F)
0000111A 0800 0002                BTST.L #$0002,D0
0000111E 660a                     BNE.B #$0000000a == $0000112a (T)
00001120 08c0 0001                BSET.L #$0001,D0
00001124 6004                     BT .B #$00000004 == $0000112a (T)
00001126 08c0 0000                BSET.L #$0000,D0
0000112A 51c9 ffe8                DBF .W D1,#$ffe8 == $00001114 (F)
0000112E 4cdf 0006                MOVEM.L (A7)+,D1-D2
00001132 4e75                     RTS 

00001134 48e7 78c0                MOVEM.L D1-D4/A0-A1,-(A7)
00001138 2248                     MOVEA.L A0,A1
0000113A 41f9 00df f000           LEA.L $00dff000,A0
00001140 3140 007e                MOVE.W D0,(A0, $007e) == $00fe9794
00001144 6100 01ec                BSR.W #$01ec == $00001332
00001148 317c 4000 0024           MOVE.W #$4000,(A0, $0024) == $00fe973a
0000114E 2149 0020                MOVE.L A1,(A0, $0020) == $00fe9736
00001152 317c 6600 009e           MOVE.W #$6600,(A0, $009e) == $00fe97b4
00001158 317c 9500 009e           MOVE.W #$9500,(A0, $009e) == $00fe97b4
0000115E 317c 8010 0096           MOVE.W #$8010,(A0, $0096) == $00fe97ac
00001164 317c 0002 009c           MOVE.W #$0002,(A0, $009c) == $00fe97b2
0000116A 6100 0010                BSR.W #$0010 == $0000117c
0000116E 317c 0400 009e           MOVE.W #$0400,(A0, $009e) == $00fe97b4
00001174 4a80                     TST.L D0
00001176 4cdf 031e                MOVEM.L (A7)+,D1-D4/A0-A1
0000117A 4e75                     RTS 

0000117C 4afc                     ILLEGAL 
0000117E 4a39 00bf dd00           TST.B $00bfdd00
00001184 0839 0004 00bf dd00      BTST.B #$0004,$00bfdd00
0000118C 67f6                     BEQ.B #$fffffff6 == $00001184 (F)
0000118E 317c 8000 0024           MOVE.W #$8000,(A0, $0024) == $00fe973a
00001194 317c 8000 0024           MOVE.W #$8000,(A0, $0024) == $00fe973a
0000119A 7200                     MOVE.L #$00000000,D1
0000119C 243c 0006 1a80           MOVE.L #$00061a80,D2
000011A2 5382                     SUB.L #$00000001,D2
000011A4 672a                     BEQ.B #$0000002a == $000011d0 (F)
000011A6 1028 001a                MOVE.B (A0, $001a) == $00fe9730,D0
000011AA 0800 0004                BTST.L #$0004,D0
000011AE 67f2                     BEQ.B #$fffffff2 == $000011a2 (F)
000011B0 7431                     MOVE.L #$00000031,D2
000011B2 5281                     ADD.L #$00000001,D1
000011B4 3028 001a                MOVE.W (A0, $001a) == $00fe9730,D0
000011B8 6af8                     BPL.B #$fffffff8 == $000011b2 (T)
000011BA 12c0                     MOVE.B D0,(A1)+
000011BC 51ca fff4                DBF .W D2,#$fff4 == $000011b2 (F)
000011C0 343c 03cd                MOVE.W #$03cd,D2
000011C4 5281                     ADD.L #$00000001,D1
000011C6 3028 001a                MOVE.W (A0, $001a) == $00fe9730,D0
000011CA 6af8                     BPL.B #$fffffff8 == $000011c4 (T)
000011CC 51ca fff6                DBF .W D2,#$fff6 == $000011c4 (F)
000011D0 3028 001e                MOVE.W (A0, $001e) == $00fe9734,D0
000011D4 317c 0002 009c           MOVE.W #$0002,(A0, $009c) == $00fe97b2
000011DA 317c 4000 0024           MOVE.W #$4000,(A0, $0024) == $00fe973a
000011E0 0800 0001                BTST.L #$0001,D0
000011E4 661a                     BNE.B #$0000001a == $00001200 (T)
000011E6 7200                     MOVE.L #$00000000,D1
000011E8 6016                     BT .B #$00000016 == $00001200 (T)

L000011EA       dc.w    $8A91, $8A44, $8A45, $8A51, $8912, $8911, $8914, $8915      ;...D.E.Q........
L000011FA       dc.w    $8944, $8945, $8951,                                        ;.D.E.Q

00001200 2001                     MOVE.L D1,D0
00001202 4afc                     ILLEGAL 
00001204 4e75                     RTS 

00001206 72ff                     MOVE.L #$ffffffff,D1
00001208 0881 0007                BCLR.L #$0007,D1
0000120C 610e                     BSR.B #$0000000e == $0000121c
0000120E 203c 0009 27c0           MOVE.L #$000927c0,D0
00001214 6100 0150                BSR.W #$0150 == $00001366
00001218 6016                     BT .B #$00000016 == $00001230 (T)
0000121A 72ff                     MOVE.L #$ffffffff,D1
0000121C 41f9 00bf d100           LEA.L $00bfd100,A0
00001222 1081                     MOVE.B D1,(A0)
00001224 303a fc4e                MOVE.W (PC,$fc4e) == $00000e74,D0
00001228 5680                     ADD.L #$00000003,D0
0000122A 0181                     BCLR.L D0,D1
0000122C 1081                     MOVE.B D1,(A0)
0000122E 4e75                     RTS 

00001230 41f9 00bf e001           LEA.L $00bfe001,A0
00001236 203c 0000 061a           MOVE.L #$0000061a,D0
0000123C 0810 0005                BTST.B #$0005,(A0)
00001240 6706                     BEQ.B #$00000006 == $00001248 (F)
00001242 5380                     SUB.L #$00000001,D0
00001244 6af6                     BPL.B #$fffffff6 == $0000123c (T)
00001246 4e75                     RTS 

00001248 7000                     MOVE.L #$00000000,D0
0000124A 4e75                     RTS 

0000124C 48e7 7c00                MOVEM.L D1-D5,-(A7)
00001250 3a02                     MOVE.W D2,D5
00001252 6100 00de                BSR.W #$00de == $00001332
00001256 0245 007f                AND.W #$007f,D5
0000125A 670c                     BEQ.B #$0000000c == $00001268 (F)
0000125C 303a fc16                MOVE.W (PC,$fc16) == $00000e74,D0
00001260 6100 003a                BSR.W #$003a == $0000129c
00001264 3801                     MOVE.W D1,D4
00001266 6a08                     BPL.B #$00000008 == $00001270 (T)
00001268 6100 003e                BSR.W #$003e == $000012a8
0000126C 6628                     BNE.B #$00000028 == $00001296 (T)
0000126E 7800                     MOVE.L #$00000000,D4
00001270 ba44                     CMP.W D4,D5
00001272 670e                     BEQ.B #$0000000e == $00001282 (F)
00001274 6d06                     BLT.B #$00000006 == $0000127c (F)
00001276 6170                     BSR.B #$00000070 == $000012e8
00001278 5284                     ADD.L #$00000001,D4
0000127A 60f4                     BT .B #$fffffff4 == $00001270 (T)
0000127C 6166                     BSR.B #$00000066 == $000012e4
0000127E 5384                     SUB.L #$00000001,D4
00001280 60ee                     BT .B #$ffffffee == $00001270 (T)
00001282 6100 00ae                BSR.W #$00ae == $00001332
00001286 303a fbec                MOVE.W (PC,$fbec) == $00000e74,D0
0000128A e348                     LSL.W #$00000001,D0
0000128C 41fa fbe2                LEA.L (PC,$fbe2) == $00000e70,A0
00001290 3184 0000                MOVE.W D4,(A0, D0.W*1, $00) == $00fe9716
00001294 7000                     MOVE.L #$00000000,D0
00001296 4cdf 003e                MOVEM.L (A7)+,D1-D5
0000129A 4e75                     RTS 

0000129C e348                     LSL.W #$00000001,D0
0000129E 41fa fbd0                LEA.L (PC,$fbd0) == $00000e70,A0
000012A2 3230 0000                MOVE.W (A0, D0.W*1, $00) == $00fe9716,D1
000012A6 4e75                     RTS 

000012A8 48e7 7800                MOVEM.L D1-D4,-(A7)
000012AC 7855                     MOVE.L #$00000055,D4
000012AE 0839 0004 00bf e001      BTST.B #$0004,$00bfe001
000012B6 670c                     BEQ.B #$0000000c == $000012c4 (F)
000012B8 6100 002a                BSR.W #$002a == $000012e4
000012BC 51cc fff0                DBF .W D4,#$fff0 == $000012ae (F)
000012C0 70ff                     MOVE.L #$ffffffff,D0
000012C2 601a                     BT .B #$0000001a == $000012de (T)
000012C4 303a fbae                MOVE.W (PC,$fbae) == $00000e74,D0
000012C8 e348                     LSL.W #$00000001,D0
000012CA 41fa fba4                LEA.L (PC,$fba4) == $00000e70,A0
000012CE 4270 0000                CLR.W (A0, D0.W*1, $00) == $00fe9716
000012D2 7055                     MOVE.L #$00000055,D0
000012D4 9084                     SUB.L D4,D0
000012D6 41fa fba0                LEA.L (PC,$fba0) == $00000e78,A0
000012DA 3080                     MOVE.W D0,(A0)
000012DC 7000                     MOVE.L #$00000000,D0
000012DE 4cdf 001e                MOVEM.L (A7)+,D1-D4
000012E2 4e75                     RTS 

000012E4 7401                     MOVE.L #$00000001,D2
000012E6 6002                     BT .B #$00000002 == $000012ea (T)
000012E8 7400                     MOVE.L #$00000000,D2
000012EA 303a fb88                MOVE.W (PC,$fb88) == $00000e74,D0
000012EE 323a fb86                MOVE.W (PC,$fb86) == $00000e76,D1
000012F2 1639 00bf d100           MOVE.B $00bfd100,D3
000012F8 0003 007f                OR.B #$7f,D3
000012FC 0600 0003                ADD.B #$03,D0
00001300 0183                     BCLR.L D0,D3
00001302 0400 0003                SUB.B #$03,D0
00001306 4a01                     TST.B D1
00001308 6704                     BEQ.B #$00000004 == $0000130e (F)
0000130A 0883 0002                BCLR.L #$0002,D3
0000130E 4a02                     TST.B D2
00001310 6604                     BNE.B #$00000004 == $00001316 (T)
00001312 0883 0001                BCLR.L #$0001,D3
00001316 0883 0000                BCLR.L #$0000,D3
0000131A 13c3 00bf d100           MOVE.B D3,$00bfd100
00001320 08c3 0000                BSET.L #$0000,D3
00001324 13c3 00bf d100           MOVE.B D3,$00bfd100
0000132A 203c 0000 0bb8           MOVE.L #$00000bb8,D0
00001330 6034                     BT .B #$00000034 == $00001366 (T)
00001332 303a fb40                MOVE.W (PC,$fb40) == $00000e74,D0
00001336 323a fb3e                MOVE.W (PC,$fb3e) == $00000e76,D1
0000133A 3f02                     MOVE.W D2,-(A7)
0000133C 1439 00bf d100           MOVE.B $00bfd100,D2
00001342 0002 007f                OR.B #$7f,D2
00001346 0600 0003                ADD.B #$03,D0
0000134A 0182                     BCLR.L D0,D2
0000134C 0400 0003                SUB.B #$03,D0
00001350 4a01                     TST.B D1
00001352 6704                     BEQ.B #$00000004 == $00001358 (F)
00001354 0882 0002                BCLR.L #$0002,D2
00001358 13c2 00bf d100           MOVE.B D2,$00bfd100
0000135E 203c 0000 05dc           MOVE.L #$000005dc,D0
00001364 341f                     MOVE.W (A7)+,D2
00001366 ea88                     LSR.L #$00000005,D0
00001368 5380                     SUB.L #$00000001,D0
0000136A 66fc                     BNE.B #$fffffffc == $00001368 (T)
0000136C 4e75                     RTS 

0000136E 41fa faa0                LEA.L (PC,$faa0) == $00000e10,A0
00001372 2080                     MOVE.L D0,(A0)
00001374 4cfa 00ff fad8           MOVEM.L (PC,$fad8) == $00000e50,D0-D7
0000137A 2039 0000 0004           MOVE.L $00000004,D0
00001380 2200                     MOVE.L D0,D1
00001382 41fa 0018                LEA.L (PC,$0018) == $0000139c,A0
00001386 2f48 0002                MOVE.L A0,(A7, $0002) == $00c014a8
0000138A 4afc                     ILLEGAL 
0000138C 48f9 00ff 0000 0008      MOVEM.L D0-D7,$00000008
00001394 4cfa 7fff fa78           MOVEM.L (PC,$fa78) == $00000e10,D0-D7/A0-A6
0000139A 4e73                     RTE 

0000139C 7000                     MOVE.L #$00000000,D0
0000139E 33fc 0001 0000 1b08      MOVE.W #$0001,$00001b08
000013A6 4cdf 7fff                MOVEM.L (A7)+,D0-D7/A0-A6
000013AA 4a79 0000 1b08           TST.W $00001b08
000013B0 4e75                     RTS 

                ;----------------- end of copy protection routines ----------------------





                ;---------------------- wrong disk in the drive -------------------------
000013B2 2f08                     MOVE.L A0,-(A7)
000013B4 41fa 0f7e                LEA.L (PC,$0f7e) == $00002334,A0
000013B8 43f9 0000 7700           LEA.L $00007700,A1
000013BE 45fa 00f8                LEA.L (PC,$00f8) == $000014b8,A2
000013C2 6100 0178                BSR.W #$0178 == $0000153c
000013C6 41fa 0e8c                LEA.L (PC,$0e8c) == $00002254,A0
000013CA 2257                     MOVEA.L (A7),A1
000013CC 0c29 0030 000f           CMP.B #$30,(A1, $000f) == $00c014f1
000013D2 6704                     BEQ.B #$00000004 == $000013d8 (F)
000013D4 41e8 0070                LEA.L (A0, $0070) == $00fe9786,A0
000013D8 43f9 0000 7700           LEA.L $00007700,A1
000013DE d2fc 1643                ADDA.W #$1643,A1
000013E2 700d                     MOVE.L #$0000000d,D0
000013E4 1358 0000                MOVE.B (A0)+,(A1, $0000) == $00c014e2
000013E8 1358 0001                MOVE.B (A0)+,(A1, $0001) == $00c014e3
000013EC 1358 2800                MOVE.B (A0)+,(A1, $2800) == $00c03ce2
000013F0 1358 2801                MOVE.B (A0)+,(A1, $2801) == $00c03ce3
000013F4 1358 5000                MOVE.B (A0)+,(A1, $5000) == $00c064e2
000013F8 1358 5001                MOVE.B (A0)+,(A1, $5001) == $00c064e3
000013FC 1358 7800                MOVE.B (A0)+,(A1, $7800) == $00c08ce2
00001400 1358 7801                MOVE.B (A0)+,(A1, $7801) == $00c08ce3
00001404 92fc 0028                SUBA.W #$0028,A1
00001408 51c8 ffda                DBF .W D0,#$ffda == $000013e4 (F)
0000140C 4df9 00df f000           LEA.L $00dff000,A6
00001412 41ee 0180                LEA.L (A6, $0180) == $00c03c24,A0
00001416 701f                     MOVE.L #$0000001f,D0
00001418 4258                     CLR.W (A0)+
0000141A 51c8 fffc                DBF .W D0,#$fffc == $00001418 (F)
0000141E 3d7c 0000 0108           MOVE.W #$0000,(A6, $0108) == $00c03bac
00001424 3d7c 0000 010a           MOVE.W #$0000,(A6, $010a) == $00c03bae
0000142A 3d7c 0038 0092           MOVE.W #$0038,(A6, $0092) == $00c03b36
00001430 3d7c 00d0 0094           MOVE.W #$00d0,(A6, $0094) == $00c03b38
00001436 3d7c 4481 008e           MOVE.W #$4481,(A6, $008e) == $00c03b32
0000143C 3d7c 0cc1 0090           MOVE.W #$0cc1,(A6, $0090) == $00c03b34
00001442 3d7c 4200 0100           MOVE.W #$4200,(A6, $0100) == $00c03ba4
00001448 41fa 0046                LEA.L (PC,$0046) == $00001490,A0
0000144C 2d48 0080                MOVE.L A0,(A6, $0080) == $00c03b24
00001450 41fa 00e6                LEA.L (PC,$00e6) == $00001538,A0
00001454 2d48 0084                MOVE.L A0,(A6, $0084) == $00c03b28
00001458 3d48 008a                MOVE.W A0,(A6, $008a) == $00c03b2e
0000145C 3d7c 8180 0096           MOVE.W #$8180,(A6, $0096) == $00c03b3a
00001462 4279 0000 223a           CLR.W $0000223a
00001468 0c79 0032 0000 223a      CMP.W #$0032,$0000223a
00001470 65f6                     BCS.B #$fffffff6 == $00001468 (F)
00001472 2057                     MOVEA.L (A7),A0
00001474 6100 0168                BSR.W #$0168 == $000015de
00001478 66e8                     BNE.B #$ffffffe8 == $00001462 (T)
0000147A 4df9 00df f000           LEA.L $00dff000,A6
00001480 3d7c 0200 0100           MOVE.W #$0200,(A6, $0100) == $00c03ba4
00001486 3d7c 0180 0096           MOVE.W #$0180,(A6, $0096) == $00c03b3a
0000148C 205f                     MOVEA.L (A7)+,A0
0000148E 4e75                     RTS 


00001490 00E0 0000 00E2 7700 00E4 0000 00E6 9F00  ......w.........
000014A0 00E8 0000 00EA C700 00EC 0000 00EE EF00  ................
000014B0 00F0 0001 00F2 1700 0180 0000 0182 0000  ................
000014C0 0184 0000 0186 0000 0188 0000 018A 0000  ................
000014D0 018C 0000 018E 0000 0190 0000 0192 0000  ................
000014E0 0194 0000 0196 0000 0198 0000 019A 0000  ................
000014F0 019C 0000 019E 0000 01A0 0000 01A2 0000  ................
00001500 01A4 0000 01A6 0000 01A8 0000 01AA 0000  ................
00001510 01AC 0000 01AE 0000 01B0 0000 01B2 0000  ................
00001520 01B4 0000 01B6 0000 01B8 0000 01BA 0000  ................
00001530 01BC 0000 01BE 0000 FFFF FFFE            ............

0000153C 48e7 c1f0                MOVEM.L D0-D1/D7/A0-A3,-(A7)
00001540 1018                     MOVE.B (A0)+,D0
00001542 b03c 0003                CMP.B #$03,D0
00001546 6502                     BCS.B #$00000002 == $0000154a (F)
00001548 5888                     ADDA.L #$00000004,A0
0000154A 700f                     MOVE.L #$0000000f,D0
0000154C 544a                     ADDA.W #$00000002,A2
0000154E 14d8                     MOVE.B (A0)+,(A2)+
00001550 14d8                     MOVE.B (A0)+,(A2)+
00001552 e3ea fffe                LSLW.W (A2, -$0002) == $00c014e0
00001556 51c8 fff4                DBF .W D0,#$fff4 == $0000154c (F)
0000155A 1e18                     MOVE.B (A0)+,D7
0000155C e147                     ASL.W #$00000008,D7
0000155E 1e18                     MOVE.B (A0)+,D7
00001560 5488                     ADDA.L #$00000002,A0
00001562 45f0 7000                LEA.L (A0, D7.W*1, $00) == $00fe9716,A2
00001566 5347                     SUB.W #$00000001,D7
00001568 6b4c                     BMI.B #$0000004c == $000015b6 (F)
0000156A 47e9 1f40                LEA.L (A1, $1f40) == $00c03422,A3
0000156E 1018                     MOVE.B (A0)+,D0
00001570 6b12                     BMI.B #$00000012 == $00001584 (F)
00001572 6722                     BEQ.B #$00000022 == $00001596 (F)
00001574 b03c 0001                CMP.B #$01,D0
00001578 6626                     BNE.B #$00000026 == $000015a0 (T)
0000157A 1018                     MOVE.B (A0)+,D0
0000157C e140                     ASL.W #$00000008,D0
0000157E 1018                     MOVE.B (A0)+,D0
00001580 5547                     SUB.W #$00000002,D7
00001582 6004                     BT .B #$00000004 == $00001588 (T)
00001584 4400                     NEG.B D0
00001586 4880                     EXT.W D0
00001588 5340                     SUB.W #$00000001,D0
0000158A 12da                     MOVE.B (A2)+,(A1)+
0000158C 12da                     MOVE.B (A2)+,(A1)+
0000158E 612c                     BSR.B #$0000002c == $000015bc
00001590 51c8 fff8                DBF .W D0,#$fff8 == $0000158a (F)
00001594 601c                     BT .B #$0000001c == $000015b2 (T)
00001596 1018                     MOVE.B (A0)+,D0
00001598 e140                     ASL.W #$00000008,D0
0000159A 1018                     MOVE.B (A0)+,D0
0000159C 5547                     SUB.W #$00000002,D7
0000159E 6002                     BT .B #$00000002 == $000015a2 (T)
000015A0 4880                     EXT.W D0
000015A2 5340                     SUB.W #$00000001,D0
000015A4 121a                     MOVE.B (A2)+,D1
000015A6 e141                     ASL.W #$00000008,D1
000015A8 121a                     MOVE.B (A2)+,D1
000015AA 32c1                     MOVE.W D1,(A1)+
000015AC 610e                     BSR.B #$0000000e == $000015bc
000015AE 51c8 fffa                DBF .W D0,#$fffa == $000015aa (F)
000015B2 51cf ffba                DBF .W D7,#$ffba == $0000156e (F)
000015B6 4cdf 0f83                MOVEM.L (A7)+,D0-D1/D7/A0-A3
000015BA 4e75                     RTS 

000015BC 2f00                     MOVE.L D0,-(A7)
000015BE 43e9 0026                LEA.L (A1, $0026) == $00c01508,A1
000015C2 2009                     MOVE.L A1,D0
000015C4 908b                     SUB.L A3,D0
000015C6 6512                     BCS.B #$00000012 == $000015da (F)
000015C8 92fc 1f3e                SUBA.W #$1f3e,A1
000015CC b07c 0026                CMP.W #$0026,D0
000015D0 6508                     BCS.B #$00000008 == $000015da (F)
000015D2 92fc d828                SUBA.W #$d828,A1
000015D6 47e9 1f40                LEA.L (A1, $1f40) == $00c03422,A3
000015DA 201f                     MOVE.L (A7)+,D0
000015DC 4e75                     RTS 

000015DE 2f08                     MOVE.L A0,-(A7)
000015E0 33fc 0004 0000 1afc      MOVE.W #$0004,$00001afc
000015E8 33fc 0005 0000 1b08      MOVE.W #$0005,$00001b08
000015F0 3039 0000 1afc           MOVE.W $00001afc,D0
000015F6 5340                     SUB.W #$00000001,D0
000015F8 6b00 004e                BMI.W #$004e == $00001648 (F)
000015FC 0139 0000 1afb           BTST.B D0,$00001afb
00001602 67f2                     BEQ.B #$fffffff2 == $000015f6 (F)
00001604 33c0 0000 1afc           MOVE.W D0,$00001afc
0000160A 6100 055c                BSR.W #$055c == $00001b68
0000160E 6100 059e                BSR.W #$059e == $00001bae
00001612 6628                     BNE.B #$00000028 == $0000163c (T)
00001614 51f9 0000 1af0           SF .B $00001af0 == $00001af0 (F)
0000161A 7002                     MOVE.L #$00000002,D0
0000161C 6100 04ec                BSR.W #$04ec == $00001b0a
00001620 661a                     BNE.B #$0000001a == $0000163c (T)
00001622 2257                     MOVEA.L (A7),A1
00001624 700f                     MOVE.L #$0000000f,D0
00001626 b308                     CMPM.B (A0)+,(A1)+
00001628 56c8 fffc                DBNE.W D0,#$fffc == $00001626 (T)
0000162C 660e                     BNE.B #$0000000e == $0000163c (T)
0000162E 2278 0cf8                MOVEA.L $00000cf8,A1
00001632 707b                     MOVE.L #$0000007b,D0
00001634 22d8                     MOVE.L (A0)+,(A1)+
00001636 51c8 fffc                DBF .W D0,#$fffc == $00001634 (F)
0000163A 600c                     BT .B #$0000000c == $00001648 (T)
0000163C 3039 0000 1afc           MOVE.W $00001afc,D0
00001642 6100 0536                BSR.W #$0536 == $00001b7a
00001646 60a0                     BT .B #$ffffffa0 == $000015e8 (T)
00001648 205f                     MOVEA.L (A7)+,A0
0000164A 4a79 0000 1b08           TST.W $00001b08
00001650 4e75                     RTS 

00001652 2f08                     MOVE.L A0,-(A7)
00001654 4a50                     TST.W (A0)
00001656 677e                     BEQ.B #$0000007e == $000016d6 (F)
00001658 41e8 000e                LEA.L (A0, $000e) == $00fe9724,A0
0000165C 61f4                     BSR.B #$fffffff4 == $00001652
0000165E 6676                     BNE.B #$00000076 == $000016d6 (T)
00001660 2057                     MOVEA.L (A7),A0
00001662 d0d0                     ADDA.W (A0),A0
00001664 2278 0cf8                MOVEA.L $00000cf8,A1
00001668 701e                     MOVE.L #$0000001e,D0
0000166A 2448                     MOVEA.L A0,A2
0000166C 2649                     MOVEA.L A1,A3
0000166E 720a                     MOVE.L #$0000000a,D1
00001670 b70a                     CMPM.B (A2)+,(A3)+
00001672 56c9 fffc                DBNE.W D1,#$fffc == $00001670 (T)
00001676 6712                     BEQ.B #$00000012 == $0000168a (F)
00001678 43e9 0010                LEA.L (A1, $0010) == $00c014f2,A1
0000167C 51c8 ffec                DBF .W D0,#$ffec == $0000166a (F)
00001680 33fc 0005 0000 1b08      MOVE.W #$0005,$00001b08
00001688 604c                     BT .B #$0000004c == $000016d6 (T)
0000168A 2057                     MOVEA.L (A7),A0
0000168C 2429 000a                MOVE.L (A1, $000a) == $00c014ec,D2
00001690 0282 00ff ffff           AND.L #$00ffffff,D2

00001696 2142 0006                MOVE.L D2,(A0, $0006) == $00fe971c
0000169A 673a                     BEQ.B #$0000003a == $000016d6 (F)
0000169C 3229 000e                MOVE.W (A1, $000e) == $00c014f0,D1
000016A0 2002                     MOVE.L D2,D0
000016A2 0800 0000                BTST.L #$0000,D0
000016A6 6702                     BEQ.B #$00000002 == $000016aa (F)
000016A8 5280                     ADD.L #$00000001,D0
000016AA 9dc0                     SUBA.L D0,A6
000016AC 224e                     MOVEA.L A6,A1
000016AE 214e 000a                MOVE.L A6,(A0, $000a) == $00fe9720
000016B2 3001                     MOVE.W D1,D0
000016B4 6100 0454                BSR.W #$0454 == $00001b0a
000016B8 661c                     BNE.B #$0000001c == $000016d6 (T)
000016BA 203c 0000 0200           MOVE.L #$00000200,D0
000016C0 b480                     CMP.L D0,D2
000016C2 6402                     BCC.B #$00000002 == $000016c6 (T)
000016C4 2002                     MOVE.L D2,D0
000016C6 9480                     SUB.L D0,D2
000016C8 5340                     SUB.W #$00000001,D0
000016CA 12d8                     MOVE.B (A0)+,(A1)+
000016CC 51c8 fffc                DBF .W D0,#$fffc == $000016ca (F)
000016D0 5241                     ADD.W #$00000001,D1
000016D2 4a82                     TST.L D2
000016D4 66dc                     BNE.B #$ffffffdc == $000016b2 (T)
000016D6 205f                     MOVEA.L (A7)+,A0
000016D8 4a79 0000 1b08           TST.W $00001b08
000016DE 4e75                     RTS 

000016E0 48e7 8080                MOVEM.L D0/A0,-(A7)
000016E4 4a80                     TST.L D0
000016E6 671c                     BEQ.B #$0000001c == $00001704 (F)
000016E8 b0bc 0000 000c           CMP.L #$0000000c,D0
000016EE 6512                     BCS.B #$00000012 == $00001702 (F)
000016F0 2210                     MOVE.L (A0),D1
000016F2 b2bc 464f 524d           CMP.L #$464f524d,D1
000016F8 6722                     BEQ.B #$00000022 == $0000171c (F)
000016FA b2bc 4341 5420           CMP.L #$43415420,D1
00001700 671a                     BEQ.B #$0000001a == $0000171c (F)
00001702 6106                     BSR.B #$00000006 == $0000170a
00001704 4cdf 0101                MOVEM.L (A7)+,D0/A0
00001708 4e75                     RTS 

0000170A 2278 0cf0                MOVEA.L $00000cf0,A1
0000170E e280                     ASR.L #$00000001,D0
00001710 32d8                     MOVE.W (A0)+,(A1)+
00001712 5380                     SUB.L #$00000001,D0
00001714 66fa                     BNE.B #$fffffffa == $00001710 (T)
00001716 21c9 0cf0                MOVE.L A1,$00000cf0
0000171A 4e75                     RTS

0000171C 4a80                     TST.L D0
0000171E 670a                     BEQ.B #$0000000a == $0000172a (F)
00001720 2218                     MOVE.L (A0)+,D1
00001722 5980                     SUB.L #$00000004,D0
00001724 6100 000a                BSR.W #$000a == $00001730
00001728 60f2                     BT .B #$fffffff2 == $0000171c (T)
0000172A 4cdf 0101                MOVEM.L (A7)+,D0/A0
0000172E 4e75                     RTS

00001730 b2bc 464f 524d           CMP.L #$464f524d,D1
00001736 6700 002e                BEQ.W #$002e == $00001766 (F)
0000173A b2bc 4341 5420           CMP.L #$43415420,D1
00001740 6700 0006                BEQ.W #$0006 == $00001748 (F)
00001744 4280                     CLR.L D0
00001746 4e75                     RTS 

00001748 48e7 8080                MOVEM.L D0/A0,-(A7)
0000174C 2018                     MOVE.L (A0)+,D0
0000174E 2200                     MOVE.L D0,D1
00001750 0801 0000                BTST.L #$0000,D1
00001754 6702                     BEQ.B #$00000002 == $00001758 (F)
00001756 5281                     ADD.L #$00000001,D1
00001758 5881                     ADD.L #$00000004,D1
0000175A d3af 0004                ADD.L D1,(A7, $0004) == $00c01496
0000175E 9397                     SUB.L D1,(A7)
00001760 5888                     ADDA.L #$00000004,A0
00001762 5980                     SUB.L #$00000004,D0
00001764 60b6                     BT .B #$ffffffb6 == $0000171c (T)
00001766 48e7 8080                MOVEM.L D0/A0,-(A7)
0000176A 2018                     MOVE.L (A0)+,D0
0000176C 2200                     MOVE.L D0,D1
0000176E 0801 0000                BTST.L #$0000,D1
00001772 6702                     BEQ.B #$00000002 == $00001776 (F)
00001774 5281                     ADD.L #$00000001,D1
00001776 5881                     ADD.L #$00000004,D1
00001778 d3af 0004                ADD.L D1,(A7, $0004) == $00c01496
0000177C 9397                     SUB.L D1,(A7)
0000177E 2218                     MOVE.L (A0)+,D1
00001780 5980                     SUB.L #$00000004,D0
00001782 b2bc 2020 2020           CMP.L #$20202020,D1
00001788 6700 001c                BEQ.W #$001c == $000017a6 (F)
0000178C b2bc 4855 4646           CMP.L #$48554646,D1
00001792 6700 0082                BEQ.W #$0082 == $00001816 (F)
00001796 b2bc 494c 424d           CMP.L #$494c424d,D1
0000179C 6700 01a0                BEQ.W #$01a0 == $0000193e (F)
000017A0 4cdf 0101                MOVEM.L (A7)+,D0/A0
000017A4 4e75                     RTS 

000017A6 4a80                     TST.L D0
000017A8 670a                     BEQ.B #$0000000a == $000017b4 (F)
000017AA 2218                     MOVE.L (A0)+,D1
000017AC 5980                     SUB.L #$00000004,D0
000017AE 6100 000a                BSR.W #$000a == $000017ba
000017B2 60f2                     BT .B #$fffffff2 == $000017a6 (T)
000017B4 4cdf 0101                MOVEM.L (A7)+,D0/A0
000017B8 4e75                     RTS 

000017BA b2bc 464f 524d           CMP.L #$464f524d,D1
000017C0 67a4                     BEQ.B #$ffffffa4 == $00001766 (F)
000017C2 b2bc 4341 5420           CMP.L #$43415420,D1
000017C8 6700 ff7e                BEQ.W #$ff7e == $00001748 (F)
000017CC b2bc 424f 4459           CMP.L #$424f4459,D1
000017D2 6700 0020                BEQ.W #$0020 == $000017f4 (F)
000017D6 48e7 8080                MOVEM.L D0/A0,-(A7)
000017DA 2018                     MOVE.L (A0)+,D0
000017DC 2200                     MOVE.L D0,D1
000017DE 0801 0000                BTST.L #$0000,D1
000017E2 6702                     BEQ.B #$00000002 == $000017e6 (F)
000017E4 5281                     ADD.L #$00000001,D1
000017E6 5881                     ADD.L #$00000004,D1
000017E8 d3af 0004                ADD.L D1,(A7, $0004) == $00c01496
000017EC 9397                     SUB.L D1,(A7)
000017EE 4cdf 0101                MOVEM.L (A7)+,D0/A0
000017F2 4e75                     RTS 

000017F4 48e7 8080                MOVEM.L D0/A0,-(A7)
000017F8 2018                     MOVE.L (A0)+,D0
000017FA 2200                     MOVE.L D0,D1
000017FC 0801 0000                BTST.L #$0000,D1
00001800 6702                     BEQ.B #$00000002 == $00001804 (F)
00001802 5281                     ADD.L #$00000001,D1
00001804 5881                     ADD.L #$00000004,D1
00001806 d3af 0004                ADD.L D1,(A7, $0004) == $00c01496
0000180A 9397                     SUB.L D1,(A7)
0000180C 6100 fefc                BSR.W #$fefc == $0000170a
00001810 4cdf 0101                MOVEM.L (A7)+,D0/A0
00001814 4e75                     RTS 

00001816 42a7                     CLR.L -(A7)
00001818 42a7                     CLR.L -(A7)
0000181A 42a7                     CLR.L -(A7)
0000181C 2f0e                     MOVE.L A6,-(A7)
0000181E 2c4f                     MOVEA.L A7,A6
00001820 4a80                     TST.L D0
00001822 670a                     BEQ.B #$0000000a == $0000182e (F)
00001824 2218                     MOVE.L (A0)+,D1
00001826 5980                     SUB.L #$00000004,D0
00001828 6100 002c                BSR.W #$002c == $00001856
0000182C 60f2                     BT .B #$fffffff2 == $00001820 (T)
0000182E 4aae 0004                TST.L (A6, $0004) == $00c03aa8
00001832 6716                     BEQ.B #$00000016 == $0000184a (F)
00001834 4aae 0008                TST.L (A6, $0008) == $00c03aac
00001838 6710                     BEQ.B #$00000010 == $0000184a (F)
0000183A 4aae 000c                TST.L (A6, $000c) == $00c03ab0
0000183E 670a                     BEQ.B #$0000000a == $0000184a (F)
00001840 4cee 0301 0004           MOVEM.L (A6, $0004) == $00c03aa8,D0/A0-A1
00001846 6100 00c4                BSR.W #$00c4 == $0000190c
0000184A 2c5f                     MOVEA.L (A7)+,A6
0000184C 4fef 000c                LEA.L (A7, $000c) == $00c0149e,A7
00001850 4cdf 0101                MOVEM.L (A7)+,D0/A0
00001854 4e75                     RTS 

00001856 b2bc 464f 524d           CMP.L #$464f524d,D1
0000185C 6700 ff08                BEQ.W #$ff08 == $00001766 (F)
00001860 b2bc 4341 5420           CMP.L #$43415420,D1
00001866 6700 fee0                BEQ.W #$fee0 == $00001748 (F)
0000186A b2bc 5349 5a45           CMP.L #$53495a45,D1
00001870 6700 0034                BEQ.W #$0034 == $000018a6 (F)
00001874 b2bc 434f 4445           CMP.L #$434f4445,D1
0000187A 6700 004c                BEQ.W #$004c == $000018c8 (F)
0000187E b2bc 5452 4545           CMP.L #$54524545,D1
00001884 6700 0064                BEQ.W #$0064 == $000018ea (F)
00001888 48e7 8080                MOVEM.L D0/A0,-(A7)
0000188C 2018                     MOVE.L (A0)+,D0
0000188E 2200                     MOVE.L D0,D1
00001890 0801 0000                BTST.L #$0000,D1
00001894 6702                     BEQ.B #$00000002 == $00001898 (F)
00001896 5281                     ADD.L #$00000001,D1
00001898 5881                     ADD.L #$00000004,D1
0000189A d3af 0004                ADD.L D1,(A7, $0004) == $00c01496
0000189E 9397                     SUB.L D1,(A7)
000018A0 4cdf 0101                MOVEM.L (A7)+,D0/A0
000018A4 4e75                     RTS 

000018A6 48e7 8080                MOVEM.L D0/A0,-(A7)
000018AA 2018                     MOVE.L (A0)+,D0
000018AC 2200                     MOVE.L D0,D1
000018AE 0801 0000                BTST.L #$0000,D1
000018B2 6702                     BEQ.B #$00000002 == $000018b6 (F)
000018B4 5281                     ADD.L #$00000001,D1
000018B6 5881                     ADD.L #$00000004,D1
000018B8 d3af 0004                ADD.L D1,(A7, $0004) == $00c01496
000018BC 9397                     SUB.L D1,(A7)
000018BE 2d58 0004                MOVE.L (A0)+,(A6, $0004) == $00c03aa8
000018C2 4cdf 0101                MOVEM.L (A7)+,D0/A0
000018C6 4e75                     RTS 

000018C8 48e7 8080                MOVEM.L D0/A0,-(A7)
000018CC 2018                     MOVE.L (A0)+,D0
000018CE 2200                     MOVE.L D0,D1
000018D0 0801 0000                BTST.L #$0000,D1
000018D4 6702                     BEQ.B #$00000002 == $000018d8 (F)
000018D6 5281                     ADD.L #$00000001,D1
000018D8 5881                     ADD.L #$00000004,D1
000018DA d3af 0004                ADD.L D1,(A7, $0004) == $00c01496
000018DE 9397                     SUB.L D1,(A7)
000018E0 2d48 0008                MOVE.L A0,(A6, $0008) == $00c03aac
000018E4 4cdf 0101                MOVEM.L (A7)+,D0/A0
000018E8 4e75                     RTS 

000018EA 48e7 8080                MOVEM.L D0/A0,-(A7)
000018EE 2018                     MOVE.L (A0)+,D0
000018F0 2200                     MOVE.L D0,D1
000018F2 0801 0000                BTST.L #$0000,D1
000018F6 6702                     BEQ.B #$00000002 == $000018fa (F)
000018F8 5281                     ADD.L #$00000001,D1
000018FA 5881                     ADD.L #$00000004,D1
000018FC d3af 0004                ADD.L D1,(A7, $0004) == $00c01496
00001900 9397                     SUB.L D1,(A7)
00001902 2d48 000c                MOVE.L A0,(A6, $000c) == $00c03ab0
00001906 4cdf 0101                MOVEM.L (A7)+,D0/A0
0000190A 4e75                     RTS 

0000190C 2478 0cf0                MOVEA.L $00000cf0,A2
00001910 48e7 8020                MOVEM.L D0/A2,-(A7)
00001914 720f                     MOVE.L #$0000000f,D1
00001916 3418                     MOVE.W (A0)+,D2
00001918 2649                     MOVEA.L A1,A3
0000191A d442                     ADD.W D2,D2
0000191C 6402                     BCC.B #$00000002 == $00001920 (T)
0000191E 544b                     ADDA.W #$00000002,A3
00001920 51c9 0006                DBF .W D1,#$0006 == $00001928 (F)
00001924 720f                     MOVE.L #$0000000f,D1
00001926 3418                     MOVE.W (A0)+,D2
00001928 3613                     MOVE.W (A3),D3
0000192A 6b04                     BMI.B #$00000004 == $00001930 (F)
0000192C d6c3                     ADDA.W D3,A3
0000192E 60ea                     BT .B #$ffffffea == $0000191a (T)
00001930 14c3                     MOVE.B D3,(A2)+
00001932 5380                     SUB.L #$00000001,D0
00001934 66e2                     BNE.B #$ffffffe2 == $00001918 (T)
00001936 4cdf 0101                MOVEM.L (A7)+,D0/A0
0000193A 6000 fda4                BT .W #$fda4 == $000016e0 (T)
0000193E 4a80                     TST.L D0
00001940 670a                     BEQ.B #$0000000a == $0000194c (F)
00001942 2218                     MOVE.L (A0)+,D1
00001944 5980                     SUB.L #$00000004,D0
00001946 6100 000a                BSR.W #$000a == $00001952
0000194A 60f2                     BT .B #$fffffff2 == $0000193e (T)
0000194C 4cdf 0101                MOVEM.L (A7)+,D0/A0
00001950 4e75                     RTS 

00001952 b2bc 464f 524d           CMP.L #$464f524d,D1
00001958 6700 fe0c                BEQ.W #$fe0c == $00001766 (F)
0000195C b2bc 4341 5420           CMP.L #$43415420,D1
00001962 6700 fde4                BEQ.W #$fde4 == $00001748 (F)
00001966 b2bc 434d 4150           CMP.L #$434d4150,D1
0000196C 6700 004a                BEQ.W #$004a == $000019b8 (F)
00001970 b2bc 424d 4844           CMP.L #$424d4844,D1
00001976 6700 0094                BEQ.W #$0094 == $00001a0c (F)
0000197A b2bc 424f 4459           CMP.L #$424f4459,D1
00001980 6700 00b0                BEQ.W #$00b0 == $00001a32 (F)
00001984 b2bc 4752 4142           CMP.L #$47524142,D1
0000198A 670e                     BEQ.B #$0000000e == $0000199a (F)
0000198C b2bc 4445 5354           CMP.L #$44455354,D1
00001992 6706                     BEQ.B #$00000006 == $0000199a (F)
00001994 b2bc 4341 4d47           CMP.L #$43414d47,D1
0000199A 48e7 8080                MOVEM.L D0/A0,-(A7)
0000199E 2018                     MOVE.L (A0)+,D0
000019A0 2200                     MOVE.L D0,D1
000019A2 0801 0000                BTST.L #$0000,D1
000019A6 6702                     BEQ.B #$00000002 == $000019aa (F)
000019A8 5281                     ADD.L #$00000001,D1
000019AA 5881                     ADD.L #$00000004,D1
000019AC d3af 0004                ADD.L D1,(A7, $0004) == $00c01496
000019B0 9397                     SUB.L D1,(A7)
000019B2 4cdf 0101                MOVEM.L (A7)+,D0/A0
000019B6 4e75                     RTS 

000019B8 48e7 8080                MOVEM.L D0/A0,-(A7)
000019BC 2018                     MOVE.L (A0)+,D0
000019BE 2200                     MOVE.L D0,D1
000019C0 0801 0000                BTST.L #$0000,D1
000019C4 6702                     BEQ.B #$00000002 == $000019c8 (F)
000019C6 5281                     ADD.L #$00000001,D1
000019C8 5881                     ADD.L #$00000004,D1
000019CA d3af 0004                ADD.L D1,(A7, $0004) == $00c01496
000019CE 9397                     SUB.L D1,(A7)
000019D0 80fc 0003                DIVU.W #$0003,D0
000019D4 672c                     BEQ.B #$0000002c == $00001a02 (F)
000019D6 5340                     SUB.W #$00000001,D0
000019D8 43fa fade                LEA.L (PC,$fade) == $000014b8,A1
000019DC 7200                     MOVE.L #$00000000,D1
000019DE 7400                     MOVE.L #$00000000,D2
000019E0 1418                     MOVE.B (A0)+,D2
000019E2 e84a                     LSR.W #$00000004,D2
000019E4 8242                     OR.W D2,D1
000019E6 e959                     ROL.W #$00000004,D1
000019E8 7400                     MOVE.L #$00000000,D2
000019EA 1418                     MOVE.B (A0)+,D2
000019EC e84a                     LSR.W #$00000004,D2
000019EE 8242                     OR.W D2,D1
000019F0 e959                     ROL.W #$00000004,D1
000019F2 7400                     MOVE.L #$00000000,D2
000019F4 1418                     MOVE.B (A0)+,D2
000019F6 e84a                     LSR.W #$00000004,D2
000019F8 8242                     OR.W D2,D1
000019FA 5489                     ADDA.L #$00000002,A1
000019FC 32c1                     MOVE.W D1,(A1)+
000019FE 51c8 ffdc                DBF .W D0,#$ffdc == $000019dc (F)
00001A02 4cdf 0101                MOVEM.L (A7)+,D0/A0
00001A06 4e75                     RTS 

00001A08 0000 0000                OR.B #$00,D0

00001A0C 48e7 8080                MOVEM.L D0/A0,-(A7)
00001A10 2018                     MOVE.L (A0)+,D0
00001A12 2200                     MOVE.L D0,D1
00001A14 0801 0000                BTST.L #$0000,D1
00001A18 6702                     BEQ.B #$00000002 == $00001a1c (F)
00001A1A 5281                     ADD.L #$00000001,D1
00001A1C 5881                     ADD.L #$00000004,D1
00001A1E d3af 0004                ADD.L D1,(A7, $0004) == $00c01496
00001A22 9397                     SUB.L D1,(A7)
00001A24 21c8 1a08                MOVE.L A0,$00001a08
00001A28 4cdf 0101                MOVEM.L (A7)+,D0/A0
00001A2C 4e75                     RTS 

00001A2E 0000 0000                OR.B #$00,D0

00001A32 48e7 8080                MOVEM.L D0/A0,-(A7)
00001A36 2018                     MOVE.L (A0)+,D0
00001A38 2200                     MOVE.L D0,D1
00001A3A 0801 0000                BTST.L #$0000,D1
00001A3E 6702                     BEQ.B #$00000002 == $00001a42 (F)
00001A40 5281                     ADD.L #$00000001,D1
00001A42 5881                     ADD.L #$00000004,D1
00001A44 d3af 0004                ADD.L D1,(A7, $0004) == $00c01496
00001A48 9397                     SUB.L D1,(A7)
00001A4A 43f9 0000 7700           LEA.L $00007700,A1
00001A50 2478 1a08                MOVEA.L $00001a08,A2
00001A54 4a2a 0009                TST.B (A2, $0009) == $00c014eb
00001A58 6628                     BNE.B #$00000028 == $00001a82 (T)
00001A5A 0c2a 0002 000a           CMP.B #$02,(A2, $000a) == $00c014ec
00001A60 6420                     BCC.B #$00000020 == $00001a82 (T)
00001A62 7000                     MOVE.L #$00000000,D0
00001A64 102a 0008                MOVE.B (A2, $0008) == $00c014ea,D0
00001A68 5340                     SUB.W #$00000001,D0
00001A6A 33c0 0000 1a88           MOVE.W D0,$00001a88
00001A70 4c92 00c0                MOVEM.W (A2),D6-D7
00001A74 1a2a 000a                MOVE.B (A2, $000a) == $00c014ec,D5
00001A78 e846                     ASR.W #$00000004,D6
00001A7A dc46                     ADD.W D6,D6
00001A7C 5347                     SUB.W #$00000001,D7
00001A7E 6100 000a                BSR.W #$000a == $00001a8a
00001A82 4cdf 0101                MOVEM.L (A7)+,D0/A0
00001A86 4e75                     RTS 

00001A88    dc.w    $0000

00001A8A 9ec6                     SUBA.W D6,A7
00001A8C 3806                     MOVE.W D6,D4
00001A8E b87c 0028                CMP.W #$0028,D4
00001A92 6f02                     BLE.B #$00000002 == $00001a96 (F)
00001A94 7828                     MOVE.L #$00000028,D4
00001A96 e244                     ASR.W #$00000001,D4
00001A98 5344                     SUB.W #$00000001,D4
00001A9A 2449                     MOVEA.L A1,A2
00001A9C 3638 1a88                MOVE.W $00001a88,D3
00001AA0 264f                     MOVEA.L A7,A3
00001AA2 3406                     MOVE.W D6,D2
00001AA4 4a05                     TST.B D5
00001AA6 6606                     BNE.B #$00000006 == $00001aae (T)
00001AA8 3002                     MOVE.W D2,D0
00001AAA 5340                     SUB.W #$00000001,D0
00001AAC 6018                     BT .B #$00000018 == $00001ac6 (T)
00001AAE 4240                     CLR.W D0
00001AB0 1018                     MOVE.B (A0)+,D0
00001AB2 6a12                     BPL.B #$00000012 == $00001ac6 (T)
00001AB4 4400                     NEG.B D0
00001AB6 69f6                     BVS.B #$fffffff6 == $00001aae (F)
00001AB8 1218                     MOVE.B (A0)+,D1
00001ABA 16c1                     MOVE.B D1,(A3)+
00001ABC 5342                     SUB.W #$00000001,D2
00001ABE 51c8 fffa                DBF .W D0,#$fffa == $00001aba (F)
00001AC2 66ea                     BNE.B #$ffffffea == $00001aae (T)
00001AC4 600a                     BT .B #$0000000a == $00001ad0 (T)
00001AC6 16d8                     MOVE.B (A0)+,(A3)+
00001AC8 5342                     SUB.W #$00000001,D2
00001ACA 51c8 fffa                DBF .W D0,#$fffa == $00001ac6 (F)
00001ACE 66de                     BNE.B #$ffffffde == $00001aae (T)
00001AD0 264f                     MOVEA.L A7,A3
00001AD2 284a                     MOVEA.L A2,A4
00001AD4 3404                     MOVE.W D4,D2
00001AD6 38db                     MOVE.W (A3)+,(A4)+
00001AD8 51ca fffc                DBF .W D2,#$fffc == $00001ad6 (F)
00001ADC d4fc 2800                ADDA.W #$2800,A2
00001AE0 51cb ffbe                DBF .W D3,#$ffbe == $00001aa0 (F)
00001AE4 d2fc 0028                ADDA.W #$0028,A1
00001AE8 51cf ffb0                DBF .W D7,#$ffb0 == $00001a9a (F)
00001AEC dec6                     ADDA.W D6,A7
00001AEE 4e75                     RTS 

              rts


