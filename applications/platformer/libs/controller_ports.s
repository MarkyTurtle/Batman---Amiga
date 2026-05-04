
;/-------------------------------------------------------------------
; CONTROLLER_PORTS.s
;--------------------------------------------------------------------
; Reads joystick controller ports and button status.
;


; define digital stick on/off bit flags for controller_port(x) words
JOYSTICK_LEFT       EQU     $0
JOYSTICK_RIGHT      EQU     $1
JOYSTICK_UP         EQU     $2
JOYSTICK_DOWN       EQU     $3
JOYSTICK_BUTTON1    EQU     $4
JOYSTICK_BUTTON2    EQU     $5
JOYSTICK_BUTTON3    EQU     $6

; define a controller state structure definition to apply to controller_port(x) memory locations
;- only contains stick state at the moment, in future will expand to include mouse/analogue data also. 

                rsreset
controller_stick_state        rs.w    1                   ; joysick state bits.


; hold current port(x) controller state, in future will also hold mouse and analogue states.
controller_port1_state
                dc.w    $0                  ; stick state.

controller_port2_state
                dc.w    $0                  ; stick state.



          ;--------------------------------------------------
          ; CONTOLLER_PORTS_READ
          ;---------------------------------------------------
          ;
          ; IN:
          ;    a6.l = CUSTOM BASE $dff000
          ; 
controller_ports_read
               lea       controller_port1_state,a0
               move.w    JOY0DAT(a6),d0
               bsr.s     _decode_joystick_directions
               lea       controller_port2_state,a0
               move.w    JOY1DAT(a6),d0
               bsr.s     _decode_joystick_directions
               bsr.s     _decode_joystick_port1_buttons
               bsr.s     _decode_joystick_port2_buttons
               rts


            ; IN:
            ;   d0.w - JOY0DAT, or JOY1DAT value
            ;   a0.l - controller_struct
_decode_joystick_directions   ; IN: d0.w - JOY0DAT/JOY1DAT, a0.l - controller_struct
                movem.l d1-d2,-(a7)
                moveq.l #0,d1
.chk_left       
                btst.l  #9,d0
                bne.s   .is_left
.chk_right      
                btst.l  #1,d0
                beq.s   .chk_up
                bset.l  #JOYSTICK_RIGHT,d1
                bra.s   .chk_up
.is_left
                bset.l  #JOYSTICK_LEFT,d1
.chk_up
                move.w  d0,d2
                rol.w   #1,d2
                eor.w   d2,d0
                btst.l  #9,d0
                bne.s   .is_up
.chk_down
                btst.l  #1,d0
                beq.s   .store_result
                bset.l  #JOYSTICK_DOWN,d1
                bra.s   .store_result
.is_up
                bset.l  #JOYSTICK_UP,d1
.store_result
                move.w  d1,controller_stick_state(a0)
                movem.l (a7)+,d1-d2
                rts



            ; -------------------- decode joystick port 1 buttons -------------------
            ; IN:
            ;   a6.l - custom base
_decode_joystick_port1_buttons
                lea     controller_port1_state,a0
                moveq.l #0,d1

.chk_button1    btst.b  #6,$bfe001
                bne.s   .chk_button2
.is_button1     bset.l  #JOYSTICK_BUTTON1,d1

.chk_button2    move.w  POTGOR(a6),d0
                btst.l  #10,d0
                bne.s  .chk_button3
.is_button2     bset.l  #JOYSTICK_BUTTON2,d1

.chk_button3    btst.l  #8,d0
                bne.s   .set_state
.is_button3     bset.l  #JOYSTICK_BUTTON3,d1

.set_state      or.w    d1,controller_stick_state(a0)
                rts



            ; -------------------- decode joystick port 2 buttons -------------------
            ; IN:
            ;   a6.l - custom base
_decode_joystick_port2_buttons
                lea     controller_port2_state,a0
                moveq.l #0,d1

.chk_button1    btst.b  #7,$bfe001
                bne.s   .chk_button2
.is_button1     bset.l  #JOYSTICK_BUTTON1,d1

.chk_button2    move.w  POTGOR(a6),d0
                btst.l  #14,d0
                bne.s  .chk_button3
.is_button2     bset.l  #JOYSTICK_BUTTON2,d1

.chk_button3    btst.l  #12,d0
                bne.s   .set_state
.is_button3     bset.l  #JOYSTICK_BUTTON3,d1

.set_state      or.w    d1,controller_stick_state(a0)
                rts

