
batman_lives_icon_off_mask          ; 'unlit' lives icon bit mask (batman symbol) - original address $0007f838
.mask       dc.l    $001ffff0       ; .... .... ...X XXXX XXXX XXXX XXXX ....
            dc.l    $003cfe78       ; .... .... ..XX XX.. XXXX XXX. .XXX X...
            dc.l    $0071d71c       ; .... .... .XXX ...X XX.X .XXX ...X XX..
            dc.l    $00e1c70e       ; .... .... XXX. ...X XX.. .XXX .... XXX.
            dc.l    $00c18306       ; .... .... XX.. ...X X... ..XX .... .XX.
            dc.l    $00c00006       ; .... .... XX.. .... .... .... .... .XX.
            dc.l    $00c00006       ; .... .... XX.. .... .... .... .... .XX.
            dc.l    $00e2008e       ; .... .... XXX. ..X. .... .... X... XXX.
            dc.l    $0073459c       ; .... .... .XXX ..XX .X.. .X.X X..X XX..
            dc.l    $003feff8       ; .... .... ..XX XXXX XXX. XXXX XXXX X...
            dc.l    $001ffff0       ; .... .... ...X XXXX XXXX XXXX XXXX ....
            dc.l    $001ffff0       ; .... .... ...X XXXX XXXX XXXX XXXX ....
            dc.l    $0007ffc0       ; .... .... .... .XXX XXXX XXXX XX.. ....


batman_lives_icon_off               ; 'unlit' lives icon (batman symbol)  - 32 x 13 pixels - 4 bitplanes, original address $0007f86c
.bitplane1  dc.l    $0007ffc0       ; .... .... .... .XXX XXXX XXXX XX.. ....
            dc.l    $001c0070       ; .... .... .... XX.. .... .... .XXX ....
            dc.l    $00300018       ; .... .... ..XX .... .... .... ...X X...
            dc.l    $0060000c       ; .... .... .XX. .... .... .... .... XX..
            dc.l    $00c00006       ; .... .... XX.. .... .... .... .... .XX.
            dc.l    $00800002       ; .... .... X... .... .... .... .... ..X.
            dc.l    $00800002       ; .... .... X... .... .... .... .... ..X.
            dc.l    $00800002       ; .... .... X... .... .... .... .... ..X.
            dc.l    $00c00006       ; .... .... XX.. .... .... .... .... .XX.
            dc.l    $0060000c       ; .... .... .XX. .... .... .... .... XX..
            dc.l    $00300018       ; .... .... ..XX .... .... .... ...X X...
            dc.l    $001c0070       ; .... .... ...X XX.. .... .... .XXX ....
            dc.l    $0007ffc0       ; .... .... .... .XXX XXXX XXXX XX.. ....

.bitplane2  dc.l    $00000000       ; .... .... .... .... .... .... .... ....       - original address $0007f8a0
            dc.l    $00000000       ; .... .... .... .... .... .... .... ....
            dc.l    $00000000       ; .... .... .... .... .... .... .... ....
            dc.l    $00000000       ; .... .... .... .... .... .... .... ....
            dc.l    $00000000       ; .... .... .... .... .... .... .... ....
            dc.l    $00000000       ; .... .... .... .... .... .... .... ....
            dc.l    $00000000       ; .... .... .... .... .... .... .... ....
            dc.l    $00000000       ; .... .... .... .... .... .... .... ....
            dc.l    $00000000       ; .... .... .... .... .... .... .... ....
            dc.l    $00000000       ; .... .... .... .... .... .... .... ....
            dc.l    $00000000       ; .... .... .... .... .... .... .... ....
            dc.l    $00000000       ; .... .... .... .... .... .... .... ....
            dc.l    $00000000       ; .... .... .... .... .... .... .... ....

.bitplane3  dc.l    $0007ffc0       ; .... .... .... .XXX XXXX XXXX XX.. ....       - original address $0007f8d4 
            dc.l    $001ffff0       ; .... .... ...X XXXX XXXX XXXX XXXX ....
            dc.l    $003cfe78       ; .... .... ..XX XX.. XXXX XXX. .XXX X...
            dc.l    $0071d71c       ; .... .... .XXX ...X XX.X .XXX ...X XX..
            dc.L    $00e1c70e       ; .... .... XXX. ...X XX.. .XXX .... XXX.
            dc.l    $00c18306       ; .... .... XX.. ...X X... ..XX .... .XX.
            dc.l    $00c00006       ; .... .... XX.. .... .... .... .... .XX.
            dc.l    $00c00006       ; .... .... XX.. .... .... .... .... .XX.
            dc.l    $00e2008e       ; .... .... XXX. .... .... .... X... XXX.
            dc.l    $0073459c       ; .... .... .XXX ..XX .X.. .X.X X..X XX..
            dc.l    $003feff8       ; .... .... ..XX XXXX XXX. XXXX XXXX X...
            dc.l    $001ffff0       ; .... .... ...X XXXX XXXX XXXX XXXX ....
            dc.l    $0007ffc0       ; .... .... .... .XXX XXXX XXXX XX.. ....

.bitplane4  dc.l    $00000000       ; .... .... .... .... .... .... .... ....       - original address $0007f908
            dc.l    $00000000       ; .... .... .... .... .... .... .... ....
            dc.l    $00000000       ; .... .... .... .... .... .... .... ....
            dc.l    $00000000       ; .... .... .... .... .... .... .... ....
            dc.l    $00000000       ; .... .... .... .... .... .... .... ....
            dc.l    $00000000       ; .... .... .... .... .... .... .... ....
            dc.l    $00000000       ; .... .... .... .... .... .... .... ....
            dc.l    $00000000       ; .... .... .... .... .... .... .... ....
            dc.l    $00000000       ; .... .... .... .... .... .... .... ....
            dc.l    $00000000       ; .... .... .... .... .... .... .... ....
            dc.l    $00000000       ; .... .... .... .... .... .... .... ....
            dc.l    $00000000       ; .... .... .... .... .... .... .... ....
            dc.l    $00000000       ; .... .... .... .... .... .... .... ....

