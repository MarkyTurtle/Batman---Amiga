

                section panel,code_c
                ;org     $0                                          ; original load address


                ;--------------------- includes and constants ---------------------------
                INCDIR      "include"
                INCLUDE     "hw.i"

        IFND    TEST_BUILD_LEVEL
                org     $10ffc                                         ; original load address
        ENDC


        IFD    TEST_BUILD_LEVEL
start
                jmp start     
         ENDC          
           
           
   