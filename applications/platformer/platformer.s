
;---------- Includes ----------
              INCDIR      "include"
              INCLUDE     "hw.i"
;---------- Const ----------

               section main,code_c 
STACK_PTR
start
               lea       CUSTOM,a6
               move.w    #$7fff,INTENA(a6)
               move.w    #$7fff,DMACON(a6)
               move.w    #$7fff,INTREQ(a6)


            ; enter supervisor mode
               lea     STACK_PTR,a7
               lea     supervisor,a0
               move.l  a0,$80.w
               trap    #0
supervisor
            ; initialise the stack ptr
               lea     STACK_PTR,a7

            ; set default exception handlers $08.w - $60.w
               lea     default_exception_handler,a0
               lea     $08.w,a1
               move.w  #22,d7                  ; 23 entries
.set_loop      move.l  a0,(a1)+
               dbra    d7,.set_loop


            ; set interrupt handlers
               lea     level1_interrupt_handler,a0
               move.l  a0,$64.w
               lea     level2_interrupt_handler,a0
               move.l  a0,$68.w
               lea     level3_interrupt_handler,a0
               move.l  a0,$6c.w
               lea     level4_interrupt_handler,a0
               move.l  a0,$70.w
               lea     level5_interrupt_handler,a0
               move.l  a0,$74.w
               lea     level6_interrupt_handler,a0
               move.l  a0,$78.w

            ; set trap vectors
               lea     default_trap_handler,a0
               move.l  a0,$80.w
               move.l  a0,$84.w
               move.l  a0,$88.w
               move.l  a0,$8c.w
               move.l  a0,$90.w
               move.l  a0,$94.w
               move.l  a0,$98.w
               move.l  a0,$9c.w
               move.l  a0,$a0.w
               move.l  a0,$a4.w
               move.l  a0,$a8.w
               move.l  a0,$ac.w
               move.l  a0,$b0.w
               move.l  a0,$b4.w
               move.l  a0,$b8.w
               move.l  a0,$bc.w


               lea       copperlist(pc),a0
               move.l    a0,COP1LC(a6)

               ; set display bitplanes
               move.l    #bitplanes,d0            ; address of display buffer
               move.l    #0,d1                    ; +- offset in even bytes
               jsr       set_bitplane_ptrs

               ; enable DMA
               lea       CUSTOM,a6
               move.w    #$83c0,DMACON(a6)        ; bpl, copper, blitter


               ; display 1 screen of tilemap
               moveq.l   #0,d0
               moveq.l   #0,d1
               moveq.l   #0,d2
               moveq.l   #0,d3
               lea       tilemap,a0
               move.w    (a0)+,d2                 ; tilemap width
               move.w    (a0)+,d3                 ; tilemap height
               bsr       display_screen


            ; enable interrupts
               lea       CUSTOM,a6
               move.w    #$C020,INTENA(a6)       ; enable vertb 
loop:
               jmp       loop






display_all_tiles
               moveq.l   #0,d0                    ; tile index
               moveq.l   #0,d1                    ; dest x position
               moveq.l   #0,d2                    ; dest y position

               move.w    #20-1,d7
.outer_tile_loop
               move.w    #20-1,d6
.inner_tile_loop
               lea       bitplanes,a0             ; display buffer
               lea       tilegfx,a1               ; source gfx
               jsr       blit_tile

               addq.l    #1,d0
               addq.l    #1,d1
               dbf       d6,.inner_tile_loop

               moveq.l   #0,d1
               addq.l    #1,d2
               dbf       d7,.outer_tile_loop

               rts

               ; IN:
               ;    d0.l = tilemap-x (left)
               ;    d1.l = tillemap-y (top)
               ;    d2.l = tilemap-width (bytes/tiles)
               ;    d3.l = tilemap-height (bytes/tiles)
               ;    a0.l = tilemap-data-ptr (end of data ptr)
DISPLAY_TILES_PER_ROW        EQU   21             ; 42 bytes wide display

display_screen
               ; calc tilemap top-left start ptr
               mulu      d2,d1
               add.l     d0,d1
               lea       (a0,d1.l),a2                  ; a2 = start top left of tile map
               
               sub.w     #DISPLAY_TILES_PER_ROW,d2     ; calc tilemap modulo to next data row.
               move.l    d2,d3
               
               ; draw 16 rows of 20 tiles
               move.w    #16-1,d7                      ; 16 tiles high (256 pixels high)
               moveq.l   #0,d2                         ; display tile-y
.outer_loop
               moveq.l   #0,d1                         ; display tile-x
               move.w    #DISPLAY_TILES_PER_ROW-1,d6   ; display tiles wide (320 pixels wide)
.inner_loop
               moveq.l   #0,d0
               move.b    (a2)+,d0                      ; get tile index
               lea       bitplanes,a0                  ; display buffer
               lea       tilegfx,a1                    ; source gfx
               jsr       blit_tile
               addq.l    #1,d1
               dbf       d6,.inner_loop

               addq.l    #1,d2                         ; increment display tile-y
               lea       (a2,d3.w),a2                  ; add tilemap modulo to tilemap ptr
               dbf       d7,.outer_loop

               rts


               ; blit a source 16x16 tile (4bpl interleaved)
               ; to a dest 320x256 display buffer (4bpl interleaved)
               ; IN:
               ;    a0.l = desination address
               ;    a1.l = tile gfx address
               ;    d0.l = tile index 
               ;    d1.l = dest x tile count
               ;    d2.l = dest y tile count
blit_tile
               movem.l   a0-a1/d0-d3,-(a7)

               ; calc source tile gfx ptr
               lsl.w     #7,d0               ; multiply tile index by 128 (tile gfx size)
               lea       (a1,d0.w),a1        ; source gfx ptr

               lsl.w     #1,d1               ; multiply x by 2  (16 pixels wide)
               lsl.w     #4,d2               ; mulitply y by 16 (16 pixels high)
               
               ; multiply d2 by 168 (interleaved screen display width)
               mulu      #168,d2
               add.l     d1,d2               ; add x offset

               lea       (a0,d2.l),a0        ; dest display ptr

               bsr.w     blit_16x16
               
               movem.l   (a7)+,a0-a1/d0-d3
               rts


               ; blit a source 16x16 tile (4bpl interleaved)
               ; to a dest 320x256 display buffer (4bpl interleaved)
               ; IN:
               ;    a0.l = desination address
               ;    a1.l = tile gfx address
blit_16x16
 
.bltwait1
               btst.b    #14-8,DMACONR(a6)
               bne.s     .bltwait1
               
               move.l    #$ffffffff,BLTAFWM(a6)
               move.w    #$09f0,BLTCON0(a6)
               move.w    #$0000,BLTCON1(a6)

               move.l    a0,BLTDPT(a6)
               move.l    a1,BLTAPT(a6)
               move.w    #BITPLANE_WIDTH_BYTES-2,BLTDMOD(a6)
               move.w    #0,BLTAMOD(a6)
               move.w    #(64<<6)+1,BLTSIZE(a6)

               rts


               ; set display bitplane pointers
               ; display is interleaved
               ; IN:
               ;    d0.l - display buffer
               ;    d1.l - byte offset (+- even number of bytes)
set_bitplane_ptrs
               add.l     d1,d0               ; add bitplane offset to display buffer address
               lea       copper_bpl_ptrs,a0
               move.w    #BPL1PTH,d1
               move.w    #4,d7
               bra.s     .next_loop          ; jump to end of loop to decrement loop counter

.loop          move.w    d1,(a0)+
               swap      d0
               move.w    d0,(a0)+            ; set bpl(x)pth
               add.w     #2,d1
               move.w    d1,(a0)+
               swap      d0
               move.w    d0,(a0)+            ; set bpl(x)ptl
               add.w     #2,d1
               add.l     #BITPLANE_WIDTH_BYTES,d0
.next_loop
               dbf       d7,.loop
               rts


;-----------------------------------------------------------------------------------------
; LEVEL SCROLLER
;-----------------------------------------------------------------------------------------
world_window_last_x dc.w      $0000
world_window_last_y dc.w      $0000
world_window_x      dc.w      $0000
world_window_y      dc.w      $0000

soft_scroll_x       dc.w      $0000
hard_scroll_x       dc.w      $0000

scroller_calc_x_scroll
                    move.w    world_window_x,d0
                    move.w    d0,d1
                    
                    ; calc hard scroll (bpl ptr offset)
                    lsr.w     #3,d0               ; get bytes for hard scroll
                    add.w     #2,d0
                    move.w    d0,hard_scroll_x    ; store bpl offset for horizontal scroll (x-axis)

                    ; calc soft scroll (h/w delay)
                    and.w     #$000f,d1           ; mask off soft scroll value.
                    move.w    #$0f,d0
                    sub.w     d1,d0
                    ; combine delay for odd & even bpls
                    move.w    d0,d1
                    lsl.w     #4,d1
                    or.w      d1,d0    
                    move.w    d0,soft_scroll_x    ; store soft scroll value

                    ; test update display buffer
                    move.l    #bitplanes,d0
                    move.w    hard_scroll_x,d1
                    ext.l     d1 
                    bsr       set_bitplane_ptrs

                    move.w    soft_scroll_x,d0
                    move.w    d0,copper_scroll+2
                    rts

;-----------------------------------------------------------------------------------------
; END OF LEVEL SCROLLER
;-----------------------------------------------------------------------------------------


               even
copperlist     dc.w      FMODE,$0000

               dc.w      $2b01,$fffe
               dc.w      DDFSTRT,$0030                      ; DDFSTART (extra word)
               dc.w      DDFSTOP,$00d0
               dc.w      DIWSTRT,$2c81
               dc.w      DIWSTOP,$2cc1
               
               dc.w      BPL1MOD,(BITPLANE_WIDTH_BYTES*3)
               dc.w      BPL2MOD,(BITPLANE_WIDTH_BYTES*3)

               dc.w      BPLCON0,$4200
copper_scroll  dc.w      BPLCON1,$0000
               dc.w      BPLCON2,$0000
               dc.w      BPLCON3,$0000
               dc.w      BPLCON4,$0000       
  
               
copper_bpl_ptrs
               dc.w      $0,$0,$0,$0
               dc.w      $0,$0,$0,$0
               dc.w      $0,$0,$0,$0
               dc.w      $0,$0,$0,$0
               

               dc.w      $2c01,$fffe

copper_palette
               dc.w      COLOR00,$0000
               dc.w      COLOR01,$0446
               dc.w      COLOR02,$088a                      
               dc.w      COLOR03,$0cce                      
               dc.w      COLOR04,$0048             
               dc.w      COLOR05,$028c
               dc.w      COLOR06,$0c64
               dc.w      COLOR07,$0a22
               dc.w      COLOR08,$06a6
               dc.w      COLOR09,$0c4a
               dc.w      COLOR10,$0ec6
               dc.w      COLOR11,$0e88
               dc.w      COLOR12,$0600
               dc.w      COLOR13,$0262
               dc.w      COLOR14,$0668
               dc.w      COLOR15,$06ae

               dc.w      $ffff,$fffe
               dc.w      $ffff,$fffe



               incdir    "libs/"
               ;controller_port1_state.w
               ;controller_port2_state.w
               ;controller_ports_read()
               include   "controller_ports.s"



                ; default processor exception handler
default_exception_handler
                move.w  #$0000,d0
.loop           move.w  d0,$dff180
                add.w   #$0001,d0
                jmp     .loop



                ; default trap instruction handler
default_trap_handler
                rte



                ; serial transmit buffer empty (intreq bit 00)
                ; disk block finished (intreq bit 01)
                ; software interrupt (intreq bit 02)
level1_interrupt_handler
                movem.l d0-d7/a0-a6,-(a7)
                lea     $dff000,a6

                ; clear the interrupt (level 1 only)
                move.w  INTREQ(a6),d0
                and.w   #%0000000000000111,d0
                move.w  d0,INTREQR(a6)

                movem.l (a7)+,d0-d7/a0-a6
                rte



                ; io ports and timers (intreq bit 03) 
level2_interrupt_handler
                movem.l d0-d7/a0-a6,-(a7)
                lea     $dff000,a6

                ; clear the interrupt (level 2 only)
                move.w  INTREQ(a6),d0
                and.w   #%0000000000001000,d0
                move.w  d0,INTREQR(a6)

                movem.l (a7)+,d0-d7/a0-a6
                rte


                ; copper (intreq bit 04)
                ; vertical blank (intreq bit 05)
                ; blitter (intreq bit 06)
level3_interrupt_handler
               movem.l   d0-d7/a0-a6,-(a7)
               lea       CUSTOM,a6

               move.w    #$0f0,COLOR00(a6)

               add.w     #1,world_window_x
               jsr       scroller_calc_x_scroll
               ;add.w     #1,copper_palette+2
               jsr       controller_ports_read

               move.w    #$000,COLOR00(a6)

               ; clear the interrupt (level 3 only)
               move.w    INTREQR(a6),d0
               and.w     #%0000000001110000,d0
               move.w    d0,INTREQ(a6)

               movem.l   (a7)+,d0-d7/a0-a6
               rte


                ; audio 0-3 (intreq bits 07-10)
level4_interrupt_handler
                movem.l d0-d7/a0-a6,-(a7)
                lea     $dff000,a6

                ; clear the interrupt (level 1 only)
                move.w  INTREQ(a6),d0
                and.w   #%0000011110000000,d0
                move.w  d0,INTREQR(a6)

                movem.l (a7)+,d0-d7/a0-a6
                rte



                ; serial receive buffer (intreq bit 11)
                ; disk sync (intreq bit 12)
level5_interrupt_handler
                movem.l d0-d7/a0-a6,-(a7)
                lea     $dff000,a6

                ; clear the interrupt (level 1 only)
                move.w  INTREQ(a6),d0
                and.w   #%0001100000000000,d0
                move.w  d0,INTREQR(a6)

                movem.l (a7)+,d0-d7/a0-a6
                rte



                ; external ciab B flag (disk index) (intreq bit 13)
level6_interrupt_handler
                movem.l d0-d7/a0-a6,-(a7)
                lea     $dff000,a6

                ; clear the interrupt (level 1 only)
                move.w  INTREQ(a6),d0
                and.w   #%0010000000000000,d0
                move.w  d0,INTREQR(a6)

                movem.l (a7)+,d0-d7/a0-a6
                rte




               ; display buffer is interleaved
               even
bitplanes      dcb.b     42*256*4,$00            ; 4 bitplanes 336x256

BITPLANE_WIDTH_BYTES     equ       42             ; 42 wide (16 pixels offscreen)
BITPLANE_SIZE_BYTES      equ       42*256


               incdir    "gfx/"
tilegfx
               incbin    "TileGFX.raw"


               ; 192 x 42 bytes grid of tile indexes (upside-down in the y-axis)
               even
tilemap
               ;incbin    "TileMap192x42.raw"
               incbin    "TileMap192x42.raw.flipped"
tilemapend