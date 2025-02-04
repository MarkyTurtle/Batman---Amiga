

                section panel,code_c

                ;--------------------- includes and constants ---------------------------
                INCDIR      "include"
                INCLUDE     "hw.i"

        IFND    TEST_BUILD_LEVEL
                org     $2ffc                                         ; original load address
        ENDC

start
                jmp start     
           
           
   