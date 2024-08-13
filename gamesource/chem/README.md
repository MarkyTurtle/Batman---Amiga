# Level 1 - Axis Chemical - Music & SFX

This project contains the disassembled code for the Music & SFX player for the Level 1 - Axis Chemicals level.

I have added a test program that will initialise and play the level music from VSCode.

Just load the project into VSCode and build and run the project to hear the Level 1 music.

Future development will include more reverse engineering of the music/sfx data format and also a better test program to select the tunes/sfx from a menu.

                ; set song number below 'SOUND_TO_PLAY' for different songs/sfx
                ;   #$01 = Level 1 Music
                ;   #$02 = Level 1 Completed
                ;   #$03 = Player Live Lost
                ;   #$04 = Unknown/Unused Music
                ;   #$05 = Drip SFX
                ;   #$06 = Gas Leak
                ;   #$07 = Batarang
                ;   #$08 = Batrope
                ;   #$09 = Grenade
                ;   #$0a = Bad Guy Hit
                ;   #$0b = Splash (jack in the vat)
                ;   #$0c = Ricochet
                ;   #$0d = Explosion (grenade)

                
