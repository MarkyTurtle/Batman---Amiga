                ; This file is all data for the level 1 map graphics


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
   