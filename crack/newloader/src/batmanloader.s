;-----------------------------------------------------------------------------------------------------------------------------
; A replacement loader for the game.
;-----------------------------------------------------------------------------------------------------------------------------



;---------- Includes ----------
              INCDIR        "include"
              INCLUDE       "hw.i"

              section       loader,code_c

kill_system
              lea    $dff000,a6
              move.w #$7fff,INTENA(a6)
              move.w #$7fff,DMACON(a6)
              move.w #$7fff,INTREQ(a6)

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

loaderstart:
              move.w #$8210,DMACON(a6)
              lea    dosio(pc),a5
              ; panel.iff
              move.l #0,d0                              ; load file
              lea    filename1,a0
              lea    $7C7FC,a1
              lea    $3400,a2
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