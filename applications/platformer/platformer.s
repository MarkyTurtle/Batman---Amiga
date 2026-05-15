
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
               lea       copper_bpl_ptrs,a0
               jsr       set_bitplane_ptrs

               ; set vertical wrap bitplane ptrs
               move.l    #bitplanes,d0            ; address of display buffer
               move.l    #0,d1                    ; +- offset in even bytes
               lea       copper_bpl_wrap_ptrs,a0
               jsr       set_bitplane_ptrs

               ; enable DMA
               lea       CUSTOM,a6
               move.w    #$83c0,DMACON(a6)        ; bpl, copper, blitter

               ; initialise tile scroller
               jsr       scroll_initialise

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
DISPLAY_TILES_PER_ROW         EQU  21                  ; 42 bytes wide display
DISPLAY_TILES_PER_COLUMN      EQU  17                  ; 272 lines high display
display_screen
               ; calc tilemap top-left start ptr
               mulu      d2,d1
               add.l     d0,d1
               lea       (a0,d1.l),a2                       ; a2 = start top left of tile map
               
               sub.w     #DISPLAY_TILES_PER_ROW,d2          ; calc tilemap modulo to next data row.
               move.l    d2,d3
               
               ; draw 17 rows of 21 tiles
               move.w    #DISPLAY_TILES_PER_COLUMN-1,d7     ; 17 tiles high (256 pixels high)
               moveq.l   #0,d2                              ; display tile-y
.outer_loop
               moveq.l   #0,d1                              ; display tile-x
               move.w    #DISPLAY_TILES_PER_ROW-1,d6        ; display tiles wide (320 pixels wide)
.inner_loop
               moveq.l   #0,d0
               move.b    (a2)+,d0                           ; get tile index
               lea       bitplanes,a0                       ; display buffer
               lea       tilegfx,a1                         ; source gfx
               jsr       blit_tile
               addq.l    #1,d1
               dbf       d6,.inner_loop

               addq.l    #1,d2                              ; increment display tile-y
               lea       (a2,d3.w),a2                       ; add tilemap modulo to tilemap ptr
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
               ;    a0.l - address of copper list BPL(X)PT instructions
set_bitplane_ptrs
               add.l     d1,d0               ; add bitplane offset to display buffer address
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
; TODO: separate out global and buffer dependent values into a data structure that
;       can be passed into the scroll routines to allow for double buffering in future.
;------------------------------------------------------------------------------------------
world_window_last_x dc.w      $0000
world_window_last_y dc.w      $0000
world_window_x      dc.w      $0000
world_window_y      dc.w      $0000

soft_scroll_x       dc.w      $0000                    ; h/w scroll delay (bplcon1)
hard_scroll_x       dc.w      $0000                    ; byte offset for display left
hard_scroll_last_x  dc.w      $0000                    ; copy of the last hard_scroll_x value

line_scroll_y       dc.w      $0000                    ; raster line offset top of display buffer
split_scroll_y      dc.w      $0000                    ; vertical raster for y buffer wrap
hard_scroll_y       dc.l      $0000                    ; byte offset for display top
tile_scroll_y       dc.w      $0000                    ; current tile scroll index (top line)

tilemap_ptr         dc.l      $00000000                ; pointer of tile map file
tilemap_width       dc.w      $0000                    ; tile map width in tiles (bytes)
tilemap_height      dc.w      $0000                    ; tile map heightin tiles (bytes)
tilemap_tile_ptr    dc.l      $00000000                ; pointer of tile map data
tilemap_current_ptr dc.l      $00000000                ; potiner of current top left tile map ptr



                  rsreset
SCRBUF_PTR              rs.l     1                 ; base pointer to scroll display buffer
; horizontal scroll deals with byte offsets and hardware scroll delay values, 
; these are stored in the following variables for use by the scroller and copper list setup routines.
SCRBUF_SOFTSCR_X        rs.w     1                 ; soft scroll x value - h/w delay for scroll (bplcon1)
SCRBUF_HARDSCR_X        rs.w     1                 ; hard scroll x value - horizontal byte offset into display buffer 
SCRBUF_HARDSCR_LAST_X   rs.w     1                 ; previous hard scroll x value - used to detect scroll direction (left/right)
SCRBUF_HARDSCR_DIR_X    rs.w     1                 ; hard scroll direction x value - 0 = no scroll, 1 = scroll right, -1 = scroll left
SCRBUF_TILESCR_X        rs.w     1                 ; tile scroll x value - tile index offset for tilemap (left of window)

; vertical scroll is more complex.
; it records the vertical line scroll value which is used to set where the first vertical raster line of the display.
; it records the split line for when the display buffer wraps (resets to the top of the buffer) 
;  - which is used to set the copper wait for the buffer wrap.
; the vertical byte offset to the display buffer is stored for use in setting the copper list bitplane pointers.
SCRBUF_LINESCROLL_Y     rs.w     1                 ; line scroll y value - raster line offset for top of display buffer
SCRBUF_SPLITSCROLL_Y    rs.w     1                 ; split scroll y value - raster line for buffer wrap
SCRBUF_HARDSCR_Y        rs.l     1                 ; hard scroll y value - vertical byte offset into display buffer
SCRBUF_HARDSCR_LAST_Y   rs.l     1                 ; previous hard scroll y value - used to detect scroll direction (up/down)
SCRBUF_HARDSCR_DIR_Y    rs.w     1                 ; hard scroll direction y value - 0 = no scroll, 1 = scroll down, -1 = scroll up
SCRBUF_TILESCR_Y        rs.w     1                 ; tile scroll y value - tile index offset for tilemap (top of window)


scrollerStructure
.tilemapfile_ptr        dc.l    $00000000                   ; pointer of tile map file
.tilemapdata_ptr        dc.l    $00000000                   ; pointer of tile map data
.tilemapwidth           dc.w    $0000                       ; tile map width in tiles (bytes)  
.tilemapheight          dc.w    $0000                       ; tile map height in tiles (bytes)
.tilemapgfx_ptr         dc.l    $00000000                   ; pointer of tile gfx data
.scrollbackbufferptr    dc.l    scrollBuffer1               ; pointer to scroll back buffer structure (see scrollBuffer1 structure)
.scrolldisplaybufferptr dc.l    scrollBuffer2               ; pointer to scroll display buffer structure (see scrollBuffer2 structure)

scrollBuffer1
.bitplane_ptr           dc.l     $00000000                ; base bitplane ptr for current scroll buffer
.softscr_x              dc.w     $0000                    ; soft scroll x value - h/w delay for scroll (bplcon1)
.hardscr_x              dc.w     $0000                    ; hard scroll x value - horizontal byte offset into display buffer
.hardscr_last_x         dc.w     $0000                    ; previous hard scroll x value - used to detect scroll direction (left/right)
.hardscr_dir_x          dc.w     $0000                    ; hard scroll direction x value - 0 = no scroll, 1 = scroll right, -1 = scroll left
.tilescr_x              dc.w     $0000                    ; tile scroll x value - tile index offset for tilemap (left of window)
.linescroll_y           dc.w     $0000                    ; line scroll y value - raster line offset for top of display buffer
.splitscroll_y          dc.w     $0000                    ; split scroll y value - raster line for buffer wrap
.hardscr_y              dc.l     $0000                    ; hard scroll y value - vertical byte offset into display buffer
.hardscr_last_y         dc.l     $0000                    ; previous hard scroll y value - used to detect scroll direction (up/down)
.hardscr_dir_y          dc.w     $0000                    ; hard scroll direction y value - 0 = no scroll, 1 = scroll down, -1 = scroll up
.tilescr_y              dc.w     $0000                    ; tile scroll y value - tile index offset for tilemap (top of window)

scrollBuffer2
.bitplane_ptr           dc.l     $00000000                ; base bitplane ptr for current scroll buffer
.softscr_x              dc.w     $0000                    ; soft scroll x value - h/w delay for scroll (bplcon1)
.hardscr_x              dc.w     $0000                    ; hard scroll x value - horizontal byte offset into display buffer
.hardscr_last_x         dc.w     $0000                    ; previous hard scroll x value - used to detect scroll direction (left/right)
.hardscr_dir_x          dc.w     $0000                    ; hard scroll direction x value - 0 = no scroll, 1 = scroll right, -1 = scroll left
.tilescr_x              dc.w     $0000                    ; tile scroll x value - tile index offset for tilemap (left of window)
.linescroll_y           dc.w     $0000                    ; line scroll y value - raster line offset for top of display buffer
.splitscroll_y          dc.w     $0000                    ; split scroll y value - raster line for buffer wrap
.hardscr_y              dc.l     $0000                    ; hard scroll y value - vertical byte offset into display buffer
.hardscr_last_y         dc.l     $0000                    ; previous hard scroll y value - used to detect scroll direction (up/down)
.hardscr_dir_y          dc.w     $0000                    ; hard scroll direction y value - 0 = no scroll, 1 = scroll down, -1 = scroll up
.tilescr_y              dc.w     $0000                    ; tile scroll y value - tile index offset for tilemap (top of window)



                        ; IN:
                        ;   a0.l - empty scrollbuffer structure ptr
                        ;   a1.l - display buffer ptr (must be large enough for 4 bitplane 336x272 interleaved display, plus horizontal scroll)
                        ;   d0.l - initial world window x value
                        ;   d1.l - initial world window y value
initialise_scroll_buffer
            ; store bitplane ptr
                        move.l    a1,SCRBUF_PTR(a0)             ; bitplane ptr

            ; calculate and store horizontal scroll values
                        move.w    d0,d7
                        lsr.w     #3,d0                         ; convert world x to byte offset for hard scroll
                        move.w    d0,SCRBUF_HARDSCR_X(a0)       ; hard scroll x value - byte offset for horizontal scroll
                        move.w    d0,SCRBUF_HARDSCR_LAST_X(a0)  ; previous hard scroll x value - used to detect scroll direction (left/right)

                ; calculate delay value for horizontal scroll (bplcon1)
                        and.w     #$000f,d7                     ; mask off pixel scroll 0-15
                        move.w    #$0f,d0                       ; calculate pixel delay
                        sub.w     d7,d0

                ; combine horizontal delay for odd & even bpls
                        move.w    d0,d7
                        lsl.w     #4,d7
                        or.w      d7,d0  
                        move.w    d0,SCRBUF_SOFTSCR_X(a0)       ; soft scroll x value - h/w delay for scroll (bplcon1)

            ; calculate and store vertical scroll values


                        rts


                    ;-----------------------------------------------
                    ; Initialise the tile map scroller
                    ; IN
                    ;    a0.l - tilemap address
                    ;    a1.l - display buffer1 addres ptr
                    ;    a2.l - display buffer2 address ptr
                    ;    a3.l - scroll buffer structure address ptr (see scrollBuffer1 structure)
                    ;
scroll_initialise
                    move.l    a0,tilemap_ptr
                    move.w    (a0)+,tilemap_width
                    move.w    (a0)+,tilemap_height
                    move.w    a0,tilemap_tile_ptr
                    move.w    a0,tilemap_current_ptr
                    
                    moveq.l   #0,d0
                    move.w    d0,world_window_last_x
                    move.w    d0,world_window_last_y
                    move.w    d0,world_window_x
                    move.w    d0,world_window_y
                    move.w    d0,soft_scroll_x
                    move.w    d0,hard_scroll_x
                    move.w    d0,hard_scroll_last_x
                    move.w    d0,line_scroll_y
                    move.w    d0,split_scroll_y
                    move.w    d0,hard_scroll_y

                    rts


                    ; IN
                    ;    d0.l - world-x delta position change
                    ;    d1.l - world-y delta position change
scroll_window
                    move.w   #$fff,$dff180
                    bsr.s     _add_world_window_x
                    bsr.s     _add_world_window_y
                    move.w  #$0ff,$dff180
                    bsr       _set_world_window_x_display_offsets
                    bsr       _set_world_window_y_display_offsets
                    move.w   #$0f00,$dff180
                    bsr       _set_copper_display_values
                    move.w   #$000,$dff180
                    rts


                    ; IN:
                    ;    d1.l - world-y delta position
_add_world_window_y 
                    movem.l   d0-d1,-(a7)

                    move.w    world_window_y,world_window_last_y
                    add.w     d1,world_window_y
                    tst.w     world_window_y
.check_lower_bound
                    bpl.s     .check_upper_bound
.clamp_lower
                    move.w    #0,world_window_y

.check_upper_bound
                    move.w    tilemap+2,d0
                    move.w    #DISPLAY_TILES_PER_COLUMN,d1
                    sub.w     d1,d0
                    lsl.w     #4,d0
                    cmp.w     world_window_y,d0
                    bcc.s     .continue
.clamp_higher_bound
                    move.w    d0,world_window_y
.continue
                    movem.l   (a7)+,d0-d1
                    rts


                    ; IN:
                    ;    d0.l - world-x delta position
_add_world_window_x
                    movem.l   d0-d1,-(a7)

                    move.w    world_window_x,world_window_last_x
                    add.w     d0,world_window_x
                    tst.w     world_window_x
.check_lower_bound
                    bpl.s    .check_upper_bound
.clamp_lower
                    move.w    #0,world_window_x

.check_upper_bound
                    move.w    tilemap,d0                    ; tilemap width
                    move.w    #DISPLAY_TILES_PER_ROW,d1
                    sub.w     d1,d0
                    lsl.w     #4,d0                         ; d0  = max world window x
                    cmp.w     world_window_x,d0
                    bcc.s     .continue
.clamp_higher_bound
                    move.w    d0,world_window_x

.continue
                    movem.l   (a7)+,d0-d1
                    rts


_set_world_window_x_display_offsets
                    move.w    world_window_x,d0
                    move.w    d0,d1
                    
                    ; calc hard scroll (bpl ptr offset)
                    lsr.w     #3,d0                                   ; get hard scroll byte offset
                    move.w    d0,hard_scroll_x                        ; store bpl offset for horizontal scroll (x-axis)

                    ; calc soft scroll (h/w delay)
                    and.w     #$000f,d1           ; mask off soft scroll value.
                    move.w    #$0f,d0
                    sub.w     d1,d0

                    ; combine delay for odd & even bpls
                    move.w    d0,d1
                    lsl.w     #4,d1
                    or.w      d1,d0    
                    move.w    d0,soft_scroll_x    ; store soft scroll value

                    ; do hard scroll column blits
                    move.w    hard_scroll_last_x,d1
                    and.w     #$fffe,d1
                    move.w    hard_scroll_x,d0
                    and.w     #$fffe,d0
                    sub.w     d1,d0
                    beq.s     .no_hard_scroll_x

.do_hard_scroll_x
                    move.w    hard_scroll_x,hard_scroll_last_x        ; store previous value of hard scroll x
                    bsr       _scroll_blit_column
                    rts
.no_hard_scroll_x
                    ;move.w    #$000,copper_debug_colour+2
                    rts


                    ; IN:
                    ;    d0.w - x byte offset +-
_scroll_blit_column
                    ; calc destination column (left side)
                    lea       bitplanes,a0
                    move.w    hard_scroll_x,d1
                    ext.l     d1
                    lea       (a0,d1.l),a0        

                    lsr.w     #1,d1
                    lea       tilemap+4,a5
                    lea       (a5,d1.l),a5

                    tst.w     d0
                    bmi.s     .scroll_left
.scroll_right
                    ;move.w    #$0f0,copper_debug_colour+2
                    moveq.l   #20,d1
                    lea       20(a5),a5
                    bra.s     .do_blit
.scroll_left
                    ;move.w    #$00f,copper_debug_colour+2
                    moveq.l   #0,d1
.do_blit
                    lea       tilegfx,a1


                    ; calc start y - tile index
                    moveq.l   #0,d2
                    move.w    line_scroll_y,d2
                    lsr.w     #4,d2                    ; d2 = tile y index (starting)

                    ; calc start y - window offset
                    moveq.l   #0,d6
                    move.w    world_window_y,d6
                    lsr.w     #4,d6

                    moveq.l   #0,d0
                    moveq.l   #DISPLAY_TILES_PER_COLUMN-1,d7
.blit_loop
                    move.l    d6,d5
                    mulu      #192,d5
                    move.b    (a5,d5.l),d0
                    bsr       blit_tile

                    add.w     #1,d2
                    add.w     #1,d6
                    cmp.w     #DISPLAY_TILES_PER_COLUMN,d2
                    bcs.s     .cont_loop
.reset_y
                    moveq.l   #0,d2
.cont_loop
                    dbf       d7,.blit_loop

                    rts







_set_world_window_y_display_offsets
                    move.w    world_window_y,d0
                    ext.l     d0
                    move.l    d0,d1
                    
                    tst.l     d0
                    beq       .continue

                    ; calc y-scroll valuse
                    divu      #BITPLANE_HEIGHT_LINES,d0          ; hi = remainder, lo = quotient
.continue
                    ; set y-line count (soft scroll value)
                    swap.w    d0
                    move.w    d0,line_scroll_y

                    ; calc buffer wrap split y-line number to restart top of buffer
                    move.w    d0,d1
                    sub.w     #BITPLANE_HEIGHT_LINES,d1
                    neg.w     d1
                    add.w     #$2c,d1                            ; add the window vertical start line
                    move.w    d1,split_scroll_y                  ; the raster wait value for the buffer wrap
                    
                    ; calc byte offset to top of display buffer
                    mulu      #BITPLANE_WIDTH_BYTES*4,d0         ; get byte offset to top of scroll
                    move.l    d0,hard_scroll_y

                    ; calc tile scroll value
                    moveq.l   #0,d0
                    move.w    world_window_y,d0
                    lsr.w     #4,d0                              ; d0 = tile count y
                    move.w    d0,tile_scroll_y                  ; tilemap y offset (top of window) 

                    moveq.l   #0,d1
                    move.w    world_window_last_y,d1
                    lsr.w     #4,d1                              ; d1 = last tile count y

                    sub.w     d1,d0
                    beq.s     .no_hard_scroll_y
.do_hard_scroll_y
                    bsr.s     _scroll_blit_row
                    ;bra.s     .exit
.no_hard_scroll_y
                    ;move.w    #$000,copper_debug_colour+2
.exit
                    rts


                    ; IN:
                    ;    d0.w - y tile offset +-
_scroll_blit_row
                    lea       bitplanes,a0
                    move.w    hard_scroll_x,d1
                    ext.l     d1
                    lea       (a0,d1.l),a0

                     lsr.w    #1,d1
                     lea      tilemap+4,a5
                     lea      (a5,d1.l),a5            ; tilemap x offset

                     moveq.l  #0,d1
                     move.w   world_window_y,d1
                     lsr.w    #4,d1                    ; tilemap y offset
                     mulu    #192,d1
                     lea      (a5,d1.l),a5            ; tilemap y offset

                     moveq.l   #0,d2
                     moveq.l   #0,d6
                     
                     tst.w     d0
                     bmi.s     .scroll_up

.scroll_down
                    ;move.w    #$0f0,copper_debug_colour+2
                     move.l    #(DISPLAY_TILES_PER_COLUMN-1)*192,d3

                     move.w    line_scroll_y,d2
                     lsr.w     #4,d2                    ; d2 = tile y index (starting 
                     tst.w    d2
                     bne.s   .continue_down
                     move.w   #DISPLAY_TILES_PER_COLUMN,d2

.continue_down
                     sub.w     #1,d2                    ; adjust for scroll direction (down = next tile row) 
                     bra.s     .do_blit


.scroll_up
                    ;move.w    #$00f,copper_debug_colour+2
                     move.w   line_scroll_y,d2
                     lsr.w     #4,d2                    ; d2 = tile y index (starting)

                     moveq.l   #0,d3                     ; tile map offset
.do_blit
                    lea  tilegfx,a1
                    moveq.l   #10,d0
                    moveq.l   #0,d1                      ; tile x pos 

.continue

                    moveq.l   #DISPLAY_TILES_PER_ROW-1,d7
.blit_loop
                  move.b   (a5,d3.l),d0
                    bsr       blit_tile
                    add.l     #1,d1
                    add.l     #1,d3
                    dbf       d7,.blit_loop

                    rts


                     ; TODO: store these values in a data structure to be used by
                     ;       double buffering routin in future.
_set_copper_display_values
                    ; set copper display buffer ptrs (top of screen)
                    move.l    #bitplanes,d0
                    move.w    hard_scroll_x,d1
                    ext.l     d1 
                    move.l    hard_scroll_y,d2
                    add.l     d2,d1
                    lea       copper_bpl_ptrs,a0
                    bsr       set_bitplane_ptrs

                    ; set copper display buffer ptrs (wrap)
                    move.l    #bitplanes,d0
                    move.w    hard_scroll_x,d1
                    ext.l     d1 
                    lea       copper_bpl_wrap_ptrs,a0
                    bsr       set_bitplane_ptrs

                    ; set copper vertical wait (wrap)
                    move.w    split_scroll_y,d0
                    cmp.w     #255,d0
                    bgt.s     .palwait
.notpalwait
                    move.w    #$01fe,copper_bpl_wrap_wait
                    move.b    d0,copper_bpl_wrap_wait+4
                    bra.s     .do_hw_scroll
.palwait
                    and.w     #$00ff,d0
                    move.w    #$ffdf,copper_bpl_wrap_wait
                    move.b    d0,copper_bpl_wrap_wait+4
.do_hw_scroll
                    ; set h/w scroll registers (soft scroll)
                    move.w    soft_scroll_x,d0
                    move.w    d0,copper_scroll+2

                    rts

;-----------------------------------------------------------------------------------------
; END OF LEVEL SCROLLER
;-----------------------------------------------------------------------------------------


               even
copperlist     dc.w      FMODE,$0000
copper_debug_colour2
               dc.w      COLOR00,$0000
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

copper_bpl_wrap_wait
               dc.w      $ffdf,$fffe                   ; $01fe - (copper NOP) - (updated by scroller)
               dc.w      $0001,$fffe                   ; wrap buffer copper wait (updated by scroller)

copper_debug_colour
               dc.w      COLOR00,$000               ; debug - show buffer wrap split 


copper_bpl_wrap_ptrs
               dc.w      $0,$0,$0,$0
               dc.w      $0,$0,$0,$0
               dc.w      $0,$0,$0,$0
               dc.w      $0,$0,$0,$0

copper_end
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

               jsr       controller_ports_read

               ; update scroll position based on joystick input
               moveq.l   #0,d0
               moveq.l   #0,d1
               move.w    controller_port2_state,d2
.chk_left
               btst.l    #JOYSTICK_LEFT,d2
               beq       .chk_right
               moveq.l   #-2,d0
.chk_right
               btst.l    #JOYSTICK_RIGHT,d2
               beq       .chk_up
               moveq.l   #2,d0
.chk_up
               btst.l    #JOYSTICK_UP,d2
               beq       .chk_down
               moveq.l   #-2,d1
.chk_down
               btst.l    #JOYSTICK_DOWN,d2
               beq.s     .do_scroll
               moveq.l   #2,d1

.do_scroll
               jsr       scroll_window
               
                           
               ;add.w     #1,copper_debug_colour+2


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
bitplanes      dcb.b     BITPLANE_SIZE_BYTES*4,$00               ; 4 bitplanes 336x2272
               dcb.b     (192*2)*4                               ; extra buffer fo scrolling into (tilemap_width * 2) * number of bitplanes


BITPLANE_WIDTH_BYTES     equ       42                            ; 21 tiles wide (16 pixels offscreen)
BITPLANE_HEIGHT_LINES    equ       272                           ; 17 tiles high (16 pixels offscreen)
BITPLANE_SIZE_BYTES      equ       BITPLANE_WIDTH_BYTES*BITPLANE_HEIGHT_LINES


               incdir    "gfx/"
tilegfx
               incbin    "TileGFX.raw"


               ; 192 x 42 bytes grid of tile indexes (upside-down in the y-axis)
               even
tilemap
               ;incbin    "TileMap192x42.raw"
               incbin    "TileMap192x42.raw.flipped"
