
;---------- Includes ----------
              INCDIR      "include"
              INCLUDE     "hw.i"
;---------- Const ----------

               section main,code_c 

start
               lea       CUSTOM,a6
               move.w    #$7fff,INTENA(a6)
               move.w    #$7fff,DMACON(a6)
               move.w    #$7fff,INTREQ(a6)

               lea       copperlist(pc),a0
               move.l    a0,COP1LC(a6)

               jsr       set_bitplane_ptrs

               lea       CUSTOM,a6
               move.w    #$83c0,DMACON(a6)        ; bpl, copper, blitter


               ;bsr      display_all_tiles

               moveq.l   #0,d0
               moveq.l   #0,d1
               moveq.l   #0,d2
               moveq.l   #0,d3
               lea       tilemap,a0
               move.w    (a0)+,d2                 ; tilemap width
               move.w    (a0)+,d3                 ; tilemap height
               bsr       display_screen

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

display_screen
               ; calc tilemap top-left start ptr
               mulu      d2,d1
               add.l     d0,d1
               lea       (a0,d1.l),a2        ; a2 = start top left of tile map
               
               sub.w     #20,d2              ; tilemap modulo to next data row.
               move.l    d2,d3
               
               ; draw 16 rows of 20 tiles
               move.w    #16-1,d7            ; 16 tiles high (256 pixels high)
               moveq.l   #0,d2               ; display tile-y
.outer_loop
               moveq.l   #0,d1               ; display tile-x
               move.w    #20-1,d6            ; display tiles wide (320 pixels wide)
.inner_loop
               moveq.l   #0,d0
               move.b    (a2)+,d0            ; get tile index
               lea       bitplanes,a0             ; display buffer
               lea       tilegfx,a1               ; source gfx
               jsr       blit_tile
               addq.l    #1,d1
               dbf       d6,.inner_loop

               addq.l    #1,d2               ; increment display tile-y
               lea       (a2,d3.w),a2        ; add tilemap modulo to tilemap ptr
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
               
               ; multiply d2 by 160 (interleaved screen display width)
               move.l    d2,d3
               lsl.l     #7,d2               ; multiply d2 by 128
               lsl.l     #5,d3               ; multiply d3 by 32
               add.l     d3,d2               ; add back together
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
               move.w    #38,BLTDMOD(a6)
               move.w    #0,BLTAMOD(a6)
               move.w    #(64<<6)+1,BLTSIZE(a6)

               rts


               ; set display bitplanes
               ; display is interleaved
set_bitplane_ptrs
               lea       copper_bpl_ptrs,a0
               move.l    #bitplanes,d0
               move.w    #BPL1PTH,d1
               move.w    #4,d7
               bra.s     .next_loop     ; jump to end of loop to decrement loop counter

.loop          move.w    d1,(a0)+
               swap      d0
               move.w    d0,(a0)+        ; set bpl(x)pth
               add.w     #2,d1
               move.w    d1,(a0)+
               swap      d0
               move.w    d0,(a0)+        ; set bpl(x)ptl
               add.w     #2,d1
               add.l     #BITPLANE_WIDTH_BYTES,d0
.next_loop
               dbf       d7,.loop
               rts


               even
copperlist     dc.w      FMODE,$0000

               dc.w      $2b01,$fffe
               dc.w      DDFSTRT,$0038
               dc.w      DDFSTOP,$00d0
               dc.w      DIWSTRT,$2c81
               dc.w      DIWSTOP,$2cc1
               
               dc.w      BPL1MOD,(BITPLANE_WIDTH_BYTES*3)
               dc.w      BPL2MOD,(BITPLANE_WIDTH_BYTES*3)

               dc.w      BPLCON0,$4200
               dc.w      BPLCON1,$0000
               dc.w      BPLCON2,$0000
               dc.w      BPLCON3,$0000
               dc.w      BPLCON4,$0000       
  
               
copper_bpl_ptrs
               dc.w      $0,$0,$0,$0
               dc.w      $0,$0,$0,$0
               dc.w      $0,$0,$0,$0
               dc.w      $0,$0,$0,$0
               

               dc.w      $2c01,$fffe


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



               ; display buffer is interleaved
               even
bitplanes      dcb.b     40*256*4,$00            ; 4 bitplanes 320x256

BITPLANE_WIDTH_BYTES     equ       40
BITPLANE_SIZE_BYTES      equ       40*256


               incdir    "gfx/"
tilegfx
               incbin    "TileGFX.raw"


               ; 192 x 42 bytes grid of tile indexes (upside-down in the y-axis)
               even
tilemap
               ;incbin    "TileMap192x42.raw"
               incbin    "TileMap192x42.raw.flipped"
tilemapend