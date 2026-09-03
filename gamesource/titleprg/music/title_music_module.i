
     IFND TITLE_MUSIC_MODULE_I
TITLE_MUSIC_MODULE_I     EQU  1     


          include   "music_module.i"


          ; ********************************************************************************************************************************************
          ; ********************************************************************************************************************************************
          ; **                                                                                                                                        **
          ; **                                                   LEVEL MUSIC DATA                                                                     **
          ; **                                                                                                                                        **          
          ; ********************************************************************************************************************************************
          ; ********************************************************************************************************************************************
          ; This is the closest block of data that could be called a music module, containing the:-
          ;    - Sample Table
          ;    - Raw Instrument Samples
          ;    - Sound Data Definitions
          ;         - Audio Track Data (pattern sequences and pattern data)
          ;    - Effect Data Tables
          ;         - ADSR Table (can be applied to any instrument)
          ;         - Arpeggio Table (can be applied to any instrument)
          ;         - Vibrato Table (can be applied to any instrument)
          ;
          ; Notes
          ; I've added a 'module_offset_table' at the start of the musuic data.
          ; This table is used to allow the removal of hardcoded address references
          ; from the SoundDriver code.
          ;
          ; The SoundDriver_Initialise(a0.l = MODULE_PTR) method examines this
          ; table a preps an address table in the sound driver code.
          ;

          even

          ; In an attempt to modularise the music data, 
          ; I have created the following table which can be used to 
          ; hold the offsets to the various data tables,
          ; and modified the initialisation code to populate the table with the correct offsets.
module_offset_table
.sample_offset      dc.l iff_sample_data_table-.sample_offset    ; IFF Sample Data Table Offset
.sound_offset       dc.l sound_table-.sound_offset               ; Sound Table Offset
.pattern_offset     dc.l sound_pattern_table-.pattern_offset     ; Pattern Table Offset
.arpeggio_offset    dc.l arpeggio_table-.arpeggio_offset         ; Arpeggio Table Offset
.adsr_offset        dc.l adsr_envelope_table-.adsr_offset        ; ADSR Envelope Table Offset
.max_soundId        dc.w $0003                                   ; Maximum Sound ID (1 to 3) - 3 sounds in this module



                ; ------ music sample data table (12 sample offsets & 2 word params) ------
                ; 12 sound samples in IFF 8SVX format.
                ; Table of address offsets below.
                ;
                ; Format:
                ;   0x00 - Long Word (32 bits) - Byte Offset to IFF Sample Data
                ;   0x04 - Word (16 bits)      - Instrument Volume
                ;   0x06 - Word (16 bits)      - No Transpose Flag (0 = can transpose pitch, !0 = cannot transpose pitch)
                ;                              - Used for Drum Instruments, other samples that cannot be transposed in pitch
                ;
                ; Original Address $00004D52                      ; Offset Calc   | Start       | Name           | End
iff_sample_data_table                                             ;---------------+-------------+----------------+----------
.data_01        dc.l  sample_01-.data_01 
                dc.w  $0018, $0000                                ; $4D52 + $0064 = $00004DB6   - WHATRU         - $000086D6
.data_02        dc.l  sample_02-.data_02
                dc.w  $0018, $0000                                ; $4D5A + $3972 = $000086D6   - IMBATMAN       - $0000B544 
.data_03        dc.l  sample_03-.data_03
                dc.w  $000C, $FFFF                                ; $4D62 + $67E2 = $0000B544   - HITBASS-C1     - $0000C9B0
.data_04        dc.l  sample_04-.data_04 
                dc.w  $0018, $FFFF                                ; $4D6A + $7C46 = $0000C9B0   - HITSNARE-C2    - $0000DE68 
.data_05        dc.l  sample_05-.data_05
                dc.w  $0030, $FFFF                                ; $4D72 + $90F6 = $0000DE68   - KIT-HIHAT-C4   - $0000E126
.data_06        dc.l  sample_06-.data_06
                dc.w  $0032, $FFFF                                ; $4D7A + $93AC = $0000E126   - KIT-OPENHAT-D4 - $0000ED2C
.data_07        dc.l  sample_07-.data_07
                dc.w  $0011, $0000                                ; $4D82 + $9FAA = $0000ED2C   - BASS2-F        - $0000FB04
.data_08        dc.l  sample_08-.data_08 
                dc.w  $0038, $0000                                ; $4D8A + $AD7A = $0000FB04   - TIMELESS-GS    - $00010838
.data_09        dc.l  sample_09-.data_09
                dc.w  $0014, $0000                                ; $4D92 + $BAA6 = $00010838   - TIMEBASS-GS    - $00011462
.data_10        dc.l  sample_10-.data_10 
                dc.w  $003E, $0000                                ; $4D9A + $C6C8 = $00011462   - CRUNCHGUITAR-C4- $00013876
.data_11        dc.l  sample_11-.data_11
                dc.w  $0018, $0000                                ; $4DA2 + $EAD4 = $00013876   - LAUGH          - $00017F52
.data_12        dc.l  sample_12-.data_12
                dc.w  $0018, $0000                                ; $4DAA + $131A8 = $00017F52  - IWANNA         - $0001B986
.data_end       dc.w  $0000, $0000                                              ; 0 marks the end of sample table data



                ; --------------------- Sound Sample 1 -------------------
                ; Start Address: $00004DB6
                ; End Address:   $000086D5
                ; Name:          WHATRU 
                ; sample_01:     original address $00004DB6
                include "./music/sample_01.s"


                ; --------------------- Sound Sample 2 -------------------
                ; Start Address: $000086D6
                ; End Address:   $0000B543
                ; Name:          IMBATMAN 
                ; sample_02:     ; original address $000086D6
                include "./music/sample_02.s"


                ; --------------------- Sound Sample 3 -------------------
                ; Start Address: $0000B544
                ; End Address:   $0000C9AF
                ; Name:          HITBASS-C1
                ; sample_03      ; original address $0000B544
                include "./music/sample_03.s"


                ; --------------------- Sound Sample 4 -------------------
                ; Start Address: $0000C9B0
                ; End Address:   $0000DE67
                ; Name:          HITSNARE-C2
                ; sample_04     ; original address $0000C9B0
                include "./music/sample_04.s"


                ; --------------------- Sound Sample 5 -------------------
                ; Start Address: $0000DE68
                ; End Address:   $0000E125
                ; Name:          KIT-HIHAT-C4 
                ; sample_05      ; original address $0000DE68
                include "./music/sample_05.s"
                
                
                ; --------------------- Sound Sample 6 -------------------
                ; Start Address: $0000E126
                ; End Address:   $0000ED2B
                ; Name:          KIT-OPENHAT-D4
                ; sample_06      ; original address $0000E126
                include "./music/sample_06.s"

                
                ; --------------------- Sound Sample 7 -------------------
                ; Start Address: $0000ED2C
                ; End Address:   $0000FB04
                ; Name:          BASS2-F
                ; sample_07      ; original address $0000ED2C
                include "./music/sample_07.s"

                
                ; --------------------- Sound Sample 8 -------------------
                ; Start Address: $0000FB04
                ; End Address:   $00010837
                ; Name:          TIMELESS-GS
                ; sample_08      ; original address $0000FB04
                include "./music/sample_08.s"


                ; --------------------- Sound Sample 9 -------------------
                ; Start Address: $00010838
                ; End Address:   $00011461
                ; Name:          TIMEBASS-GS
                ; sample_09      ; original address $00010838
                include "./music/sample_09.s"
                
                
                ; --------------------- Sound Sample 10 -------------------
                ; Start Address: $00011462
                ; End Address:   $00013875
                ; Name:          CRUNCHGUITAR-C4
                ; sample_10      ; original address $00011462
                include "./music/sample_10.s"


                ; --------------------- Sound Sample 11 -------------------
                ; Start Address: $00013876
                ; End Address:   $00017F51
                ; Name:          LAUGH
                ; sample_11      ; original address $00013876
                include "./music/sample_11.s"


                ; --------------------- Sound Sample 12 -------------------
                ; Start Address: $00017F52
                ; End Address:   $0001B985
                ; Name:          IWANNA
                ; sample_12      ; original address $00017F52
                include "./music/sample_12.s"

                ; ------------- end of sample data ---------------




               ; ARPEGGIO Table Offsets
               ; Each table entry is a word offset to the Aprpeggio sequence of commands
               ; arpeggio commands start with 2 parameters followed by a sequence of note pitch interval indexes
               ; parameter 1 = arpeggio speed in ticks
               ; parameter 2 = arpeggio table size(i.e. the number of following pitch index intervals)
arpeggio_table
.arpeggioId_00      dc.w .arpeggio_effect_00-.arpeggioId_00         ; L0001B986 - $0002

.arpeggio_effect_00
                    dc.b $02       ; speed
                    dc.b $02       ; length (number of following interval index bytes)                                            
                    dc.b $00,$0C   ; arpeggio interval indexes


                ; ADSR Table Offsets
                ; Each entry is a word Offset to the ADSR sequence of commands and values for the envelopeID
                ; Original Address $0001B98C
adsr_envelope_table
.envelopeId_00      dc.w .adsr_envelope_00-.envelopeId_00               ; L0001B98C - $0014 - .adsr_envelope_00
.envelopeId_01      dc.w .adsr_envelope_01-.envelopeId_01               ; L0001B98E - $0018 - .adsr_envelope_01
.envelopeId_02      dc.w .adsr_envelope_02-.envelopeId_02               ; L0001B990 - $001C - .adsr_envelope_02
.envelopeId_03      dc.w .adsr_envelope_03-.envelopeId_03               ; L0001B992 - $001E - .adsr_envelope_03
.envelopeId_04      dc.w .adsr_envelope_04-.envelopeId_04               ; L0001B994 - $0020 - .adsr_envelope_04
.envelopeId_05      dc.w .adsr_envelope_05-.envelopeId_05               ; L0001B996 - $0025 - .adsr_envelope_05
.envelopeId_06      dc.w .adsr_envelope_06-.envelopeId_06               ; L0001B998 - $002B - .adsr_envelope_06
.envelopeId_07      dc.w .adsr_envelope_07-.envelopeId_07               ; L0001B99A - $0031 - .adsr_envelope_07
.envelopeId_08      dc.w .adsr_envelope_08-.envelopeId_08               ; L0001B99C - $0037 - .adsr_envelope_08
.envelopeId_09      dc.w .adsr_envelope_09-.envelopeId_09               ; L0001B99E - $0039 - .adsr_envelope_09

               ; ADSR Envelope data - reference by adsr_envelope_table above
.adsr_envelope_00   dc.b $01,$3C,$1E,$FE,$00,$00 

.adsr_envelope_01   dc.b $01,$19,$08,$FD,$00,$00

.adsr_envelope_02   dc.b $01,$1E,$00,$00

.adsr_envelope_03   dc.b $01,$3E,$00,$00

                    ; this envelope looks bad (ADSR lists should be an even number of bytes)
                    ; It is used for the guitar sound and bass (who knows)
.adsr_envelope_04   dc.b $02,$0F,$07,$FF,$00,$0A,$FF

.adsr_envelope_05   dc.b $01,$19,$02,$F6,$05,$FF,$00,$00

.adsr_envelope_06   dc.b $01,$19,$0B,$FE,$01,$FE,$00,$00

.adsr_envelope_07   dc.b $01,$2A,$14,$FE,$01,$FE,$00,$00

.adsr_envelope_08   dc.b $01,$3E,$00,$00

.adsr_envelope_09   dc.b $01,$32,$00,$00

               ; pad byte
               dc.b $00






               ; -------------------------- Sound Table ----------------------------
               ; 4 values per song entry (channel settings)
               ;   - Each 2 byte value is an offset to the channel data for the song
               ;
                    even
sound_table    ; original address $0001b9dc

                    ; Sound ID 01 - Title Screen - Music 
soundId_01          ; original address $0001b9dc
.track_00_offset    dc.w sound_01_track_00_data-.track_00_offset      ; sound 01 - byte offset to audio channel 0 pattern data
.track_01_offset    dc.w sound_01_track_01_data-.track_01_offset      ; sound 01 - byte offset to audio channel 1 pattern data   
.track_02_offset    dc.w sound_01_track_02_data-.track_02_offset      ; sound 01 - byte offset to audio channel 2 pattern data     
.track_03_offset    dc.w sound_01_track_03_data-.track_03_offset      ; sound 01 - byte offset to audio channel 3 pattern data

                    ; Sound ID 02 - Game Over - Joker Laugh 
soundId_02          ; original address $0001b9e4
.track_00_offset    dc.w $0000                                        ; sound 02 - channel not used
.track_01_offset    dc.w $0000                                        ; sound 02 - channel not used
.track_02_offset    dc.w $0000                                        ; sound 02 - channel not used
.track_03_offset    dc.w sound_02_track_03_data-.track_03_offset      ; sound 02 - byte offset to audio channel 3 pattern data

                    ; Sound ID 03 - Game Complete - Batman IWanna 
soundId_03          ; original address $0001b9ec
.track_00_offset    dc.w $0000                                        ; sound 03 - channel not used
.track_01_offset    dc.w $0000                                        ; sound 03 - channel not used
.track_02_offset    dc.w $0000                                        ; sound 03 - channel not used
.track_03_offset    dc.w sound_03_track_03_data-.track_03_offset      ; sound 03 - byte offset to audio channel 3 pattern data




               ;------------------------------- sound pattern master table ---------------------------------
               ; This is a table of offsets to the sound pattern data for each pattern used in the game.
               ; Each entry is a 2 byte offset to the pattern data for that pattern.
               ; The table is indexed by the pattern ID's used in the track data for each channel.sound_pattern_table
               ;
               ; original address $0001BA06
                  even
sound_pattern_table
.pattern_00_offset  dc.w (sound_pattern_00-.pattern_00_offset)        ; Pattern 00 - Sound ID 00 - Title Music
.pattern_01_offset  dc.w (sound_pattern_01-.pattern_01_offset)        ; Pattern 01 - Sound ID 00 - Title Music
.pattern_02_offset  dc.w (sound_pattern_02-.pattern_02_offset)        ; Pattern 02 - Sound ID 00 - Title Music
.pattern_03_offset  dc.w (sound_pattern_03-.pattern_03_offset)        ; Pattern 03 - Sound ID 00 - Title Music 
.pattern_04_offset  dc.w (sound_pattern_04-.pattern_04_offset)        ; Pattern 04 - Sound ID 00 - Title Music
.pattern_05_offset  dc.w (sound_pattern_05-.pattern_05_offset)        ; Pattern 05 - Sound ID 00 - Title Music             
.pattern_06_offset  dc.w (sound_pattern_06-.pattern_06_offset)        ; Pattern 06 - Sound ID 00 - Title Music              
.pattern_07_offset  dc.w (sound_pattern_07-.pattern_07_offset)        ; Pattern 07 - Sound ID 02 - Joker Laugh    
.pattern_08_offset  dc.w (sound_pattern_08-.pattern_08_offset)        ; Pattern 08 - Sound ID 03 - Batman IWanna
.pattern_09_offset  dc.w (sound_pattern_09-.pattern_09_offset)        ; Pattern 09 - Unused Pattern Data                    




               ; ------------------------------------ Sound Track Data -------------------------------------
               ; Each sound has track data for each channel addressed via the byte offset
               ; stored in the 'sound_table' above. 
               ;
               ; Each track contains a mixture of commands and pattern Id's that are used
               ; to describe the music for that channel. 
               ;
               ;    - Commands are 1 byte values that are greater than $80, 
               ;    - Pattern Id's are 1 byte values less than $80.
               ;
               ; The Pattern Id's are an index into the 'sound_pattern_table'
               ;
               ; The Pattern Commands are:
               ;
               ;   - TRKCMD_SET_LOOP_START    - Set the loop back position for the track
               ;   - TRKCMD_LOOP_OR_END       - Loop back to the start of the track or end the track
               ;   - TRKCMD_PATTERN_TRANSPOSE - Transpose the pitch of the next pattern by a value (signed byte)
               ;   - TRKCMD_PATTERN_REPEAT    - Repeat the next pattern ID bya specified number of times
               ;




               ; Sound ID 01 - Title Music - Channel 0 Track Data
               ;    - Original address $0001BA1A
sound_01_track_00_data                                 
               dc.b TRKCMD_SET_LOOP_START                   ; Set Track Loop Back Position                               
               dc.b TRKCMD_PATTERN_REPEAT,$08,$00           ; Repeat Pattern 0 (8 times)                               
               dc.b TRKCMD_PATTERN_REPEAT,$04,$01           ; Repeat Pattern 1 (4 times)
               dc.b TRKCMD_PATTERN_REPEAT,$08,$00           ; Repeat Pattern 0 (8 times)
               dc.b TRKCMD_LOOP_OR_END                      ; Loop back to start   


               ; Sound ID 01 - Title Music - Channel 1 Track Data 
               ;    - Original address $0001BA26
sound_01_track_01_data                                 
               dc.b TRKCMD_SET_LOOP_START                   ; Set Track Loop Back Position                                
               dc.b $02                                     ; Play pattern index $02
               dc.b TRKCMD_LOOP_OR_END                      ; Loop back to start                                 


               ; Sound ID 01 - Title Music - Channel 2 Track Data
               ;    - Original address $0001BA29
sound_01_track_02_data                            
               dc.b TRKCMD_SET_LOOP_START                   ; Set Track Loop Back Position                               
               dc.b TRKCMD_PATTERN_REPEAT,$06,$03           ; Repeat Pattern 3 (6 times)                     
               dc.b $06                                     ; Play pattern index $06
               dc.b $06                                     ; Play pattern index $06
               dc.b TRKCMD_LOOP_OR_END                      ; Loop back to start  


               ; Sound ID 01 - Title Music - Channel 3 Track Data
               ;    - Original address $0001BA33
sound_01_track_03_data
               dc.b TRKCMD_SET_LOOP_START                   ; Set Track Loop Back Position                                
               dc.b TRKCMD_PATTERN_REPEAT,$08,$00           ; Repeat Pattern 0 (8 times)                                           
               dc.b $04                                     ; Play pattern index $04
               dc.b $05                                     ; Play pattern index $05
               dc.b $05                                     ; Play pattern index $05
               dc.b TRKCMD_PATTERN_REPEAT,$08,$00           ; Repeat Pattern 0 (8 times)
               dc.b TRKCMD_LOOP_OR_END                      ; Loop back to start        


               ; Sound ID 02 - Game Over - Joker Laugh - Channel 3 Track Data 
               ;    - Original address $0001B9F4
sound_02_track_03_data                            
                dc.b $07                                    ; Play pattern index $07                            
                dc.b TRKCMD_LOOP_OR_END                     ; End the track (no loop)   


                ;Sound ID 03 - Game Complete - Batman IWanna - Channel 3 Track Data  
                ;   - Original address $0001B9F6
sound_03_track_03_data                                 
                dc.b $08                                    ; Play pattern index $08
                dc.b TRKCMD_LOOP_OR_END                     ; End the track (no loop)





               ; --------------------------------- Sound Pattern Data -------------------------------------
               ;
               ;


               ; Pattern 00 - used by channel 0 & 3 (wait/rest pattern) 
               ; Original address $0001BA3E 
sound_pattern_00                                  
               dc.b PTNCMD_PAIRED_NOTES_END                 ; Switch off Paired notes effect
               dc.b PTNCMD_PAUSE_TRACK,$60                  ; Pause Track, Duration = $60
               dc.b PTNCMD_END_OR_LOOP                      ; end pattern (no loop)


               ; Pattern 01 - soundId 01 - track 0
               ; Original address $0001BA42
sound_pattern_01                                  
               dc.b PTNCMD_ADSR_ENVELOPE,$01                ; ADSR Envelope $01
               dc.b PTNCMD_SELECT_INSTRUMENT,$08            ; Insrutument $08 - TIMELESS-GS
               dc.b PTNCMD_ARPEGGIO_STOP                    ; Stop Arpeggio
               dc.b PTNCMD_MODULATION_STOP                  ; Stop Vibrato
               dc.b PTNCMD_PAIRED_NOTES_START,$06           ; Paired Notes, Duration 
               dc.b $38,$3A                                 ; list of paired notes - whole pattern
               dc.b $3F,$38
               dc.b $3A,$3F
               dc.b $38,$3A
               dc.b $3F,$38
               dc.b $3A,$3F
               dc.b $38,$3A
               dc.b $3F,$38
               dc.b $3A,$3F
               dc.b $38,$3A
               dc.b $3F,$38
               dc.b $3A,$3F
               dc.b $38,$3A
               dc.b $3F,$38
               dc.b $3A,$3F
               dc.b $38,$3A
               dc.b $3F,$38
               dc.b $3A,$3F
               dc.b $38,$3A
               dc.b $3F,$38
               dc.b $3A,$3F
               dc.b $38,$3A
               dc.b $3F,$38
               dc.b $3A,$3F
               dc.b $38,$3A
               dc.b $3F,$38
               dc.b $3A,$3F
               dc.b $38,$3A
               dc.b $3F,$38
               dc.b $3A,$3F
               dc.b $38,$3A
               dc.b $3F,$3A
               dc.b PTNCMD_END_OR_LOOP                      ; end pattern (no loop)


               ; Pattern 02 - used by channel 1 (Drums) 
               ; Original address $0001BA8B 
sound_pattern_02                                  
               dc.b PTNCMD_ADSR_ENVELOPE,$02                ; ADSR Envelope $02
               dc.b PTNCMD_SELECT_INSTRUMENT,$03            ; Select Instrument $03 - HIT-BASS-C1
               dc.b $0C,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$05            ; Select Instrument $05 - KIT HI-HAT-C4
               dc.b $40,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$06            ; Select Instrument $06 - KIT OPENHAT-D4
               dc.b $41,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$05            ; Select Instrument $05 - KIT HI-HAT-C4 
               dc.b $40,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$04            ; Select Instrument $04 - HIT SNARE-C2
               dc.b $18,$0C
               dc.b PTNCMD_SELECT_INSTRUMENT,$06            ; Select Instrument $06 - KIT OPENHAT-D4
               dc.b $41,$0C
               dc.b PTNCMD_SELECT_INSTRUMENT,$03            ; Select Instrument $03 - HIT-BASS-C1
               dc.b $0C,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$05            ; Select Instrument $05 - KIT HI-HAT-C4
               dc.b $40,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$06            ; Select Instrument $06 - KIT OPENHAT-D4
               dc.b $41,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$05            ; Select Instrument $05 - KIT HI-HAT-C4
               dc.b $40,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$04            ; Select Instrument $04 - HIT SNARE-C2
               dc.b $18,$0C
               dc.b PTNCMD_SELECT_INSTRUMENT,$06            ; Select Instrument $06 - KIT OPENHAT-D4
               dc.b $41,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$05            ; Select Instrument $05 - KIT HI-HAT-C4
               dc.b $40,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$03            ; Select Instrument $03 - HIT-BASS-C1
               dc.b $0C,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$05            ; Select Instrument $05 - KIT HI-HAT-C4
               dc.b $40,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$06            ; Select Instrument $06 - KIT OPENHAT-D4
               dc.b $41,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$05            ; Select Instrument $05 - KIT HI-HAT-C4
               dc.b $40,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$04            ; Select Instrument $04 - HIT SNARE-C2
               dc.b $18,$0C
               dc.b PTNCMD_SELECT_INSTRUMENT,$06            ; Select Instrument $06 - KIT OPENHAT-D4
               dc.b $41,$0C
               dc.b PTNCMD_SELECT_INSTRUMENT,$03            ; Select Instrument $03 - HIT-BASS-C1
               dc.b $0C,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$05            ; Select Instrument $05 - KIT HI-HAT-C4
               dc.b $40,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$06            ; Select Instrument $06 - KIT OPENHAT-D4
               dc.b $41,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$05            ; Select Instrument $05 - KIT HI-HAT-C4
               dc.b $40,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$04            ; Select Instrument $04 - HIT SNARE-C2
               dc.b $18,$0C
               dc.b PTNCMD_SELECT_INSTRUMENT,$06            ; Select Instrument $06 - KIT OPENHAT-D4
               dc.b $41,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$04            ; Select Instrument $04 - HIT SNARE-C2
               dc.b $18,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$03            ; Select Instrument $03 - HIT-BASS-C1
               dc.b $0C,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$05            ; Select Instrument $05 - KIT HI-HAT-C4
               dc.b $40,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$06            ; Select Instrument $06 - KIT OPENHAT-D4
               dc.b $41,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$05            ; Select Instrument $05 - KIT HI-HAT-C4
               dc.b $40,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$04            ; Select Instrument $04 - HIT SNARE-C2
               dc.b $18,$0C
               dc.b PTNCMD_SELECT_INSTRUMENT,$06            ; Select Instrument $06 - KIT OPENHAT-D4
               dc.b $41,$0C
               dc.b PTNCMD_SELECT_INSTRUMENT,$03            ; Select Instrument $03 - HIT-BASS-C1
               dc.b $0C,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$05            ; Select Instrument $05 - KIT HI-HAT-C4
               dc.b $40,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$06            ; Select Instrument $06 - KIT OPENHAT-D4
               dc.b $41,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$05            ; Select Instrument $05 - KIT HI-HAT-C4
               dc.b $40,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$04            ; Select Instrument $04 - HIT SNARE-C2
               dc.b $18,$0C
               dc.b PTNCMD_SELECT_INSTRUMENT,$06            ; Select Instrument $06 - KIT OPENHAT-D4
               dc.b $41,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$05            ; Select Instrument $05 - KIT HI-HAT-C4
               dc.b $40,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$03            ; Select Instrument $03 - HIT-BASS-C1
               dc.b $0C,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$05            ; Select Instrument $05 - KIT HI-HAT-C4
               dc.b $40,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$06            ; Select Instrument $06 - KIT OPENHAT-D4
               dc.b $41,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$05            ; Select Instrument $05 - KIT HI-HAT-C4
               dc.b $40,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$04            ; Select Instrument $04 - HIT SNARE-C2
               dc.b $18,$0C
               dc.b PTNCMD_SELECT_INSTRUMENT,$06            ; Select Instrument $06 - KIT OPENHAT-D4
               dc.b $41,$0C
               dc.b PTNCMD_SELECT_INSTRUMENT,$03            ; Select Instrument $03 - HIT-BASS-C1
               dc.b $0C,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$05            ; Select Instrument $05 - KIT HI-HAT-C4
               dc.b $40,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$06            ; Select Instrument $06 - KIT OPENHAT-D4
               dc.b $41,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$05            ; Select Instrument $05 - KIT HI-HAT-C4
               dc.b $40,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$04            ; Select Instrument $04 - HIT SNARE-C2
               dc.b $18,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$04            ; Select Instrument $04 - HIT SNARE-C2
               dc.b $18,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$04            ; Select Instrument $04 - HIT SNARE-C2
               dc.b $18,$06
               dc.b PTNCMD_SELECT_INSTRUMENT,$04            ; Select Instrument $04 - HIT SNARE-C2
               dc.b $18,$06
               dc.b PTNCMD_END_OR_LOOP 


               ; Pattern 03 - used by channel 2 (bass)
               ; Original address $0001BB62  
sound_pattern_03                                      
               dc.b PTNCMD_SELECT_INSTRUMENT,$07            ; Select Instrument $07 - BASS2-F
               dc.b PTNCMD_ADSR_ENVELOPE,$02                ; ADSR Envelope $02
               dc.b PTNCMD_ARPEGGIO_STOP                    ; Arpeggio Stop 
               dc.b PTNCMD_MODULATION_STOP                  ; Vibrato Stop
               dc.b $14,$0C                                 ; list of note, dutation
               dc.b $20,$0C                                 ; ...
               dc.b $20,$0C
               dc.b $14,$06
               dc.b $1E,$0C
               dc.b $14,$06
               dc.b $20,$0C
               dc.b $1E,$0C
               dc.b $20,$0C
               dc.b $0F,$0C
               dc.b $1B,$0C
               dc.b $1B,$0C
               dc.b $0F,$06
               dc.b $19,$0C
               dc.b $0F,$06
               dc.b $1B,$0C
               dc.b $19,$0C
               dc.b $1B,$0C
               dc.b $12,$0C
               dc.b $1E,$0C
               dc.b $1E,$0C
               dc.b $12,$06
               dc.b $1E,$0C
               dc.b $12,$06
               dc.b $1E,$0C
               dc.b $20,$0C
               dc.b $22,$0C
               dc.b $0D,$0C
               dc.b $19,$0C
               dc.b $19,$0C
               dc.b $0D,$06
               dc.b $19,$0C
               dc.b $0D,$06
               dc.b $19,$0C
               dc.b $1E,$0C
               dc.b $20,$0C
               dc.b PTNCMD_END_OR_LOOP                      ; end pattern (no loop)


               ; Pattern 04 - used by channel  3 ( Voice & Guitar ) 
               ; Original address $0001BBB1
sound_pattern_04                                      
               dc.b PTNCMD_ADSR_ENVELOPE,$03                ; ADSR Envelope $03
               dc.b PTNCMD_SELECT_INSTRUMENT,$01            ; Select Instrument $01 - WHAT-RU
               dc.b PTNCMD_PAUSE_TRACK,$54                  ; Pause Track Duration = $54
               dc.b $23,$90
               dc.b PTNCMD_SELECT_INSTRUMENT,$02            ; Select Instrument $02 - IM-BATMAN
               dc.b $23,$06
               dc.b $23,$96
               dc.b PTNCMD_SELECT_INSTRUMENT,$01            ; Select Instrument $01 - WHAT-RU
               dc.b PTNCMD_PAUSE_TRACK,$54                  ; Pause Track Duration = $54
               dc.b $23,$06
               dc.b $23,$8A
               dc.b PTNCMD_SELECT_INSTRUMENT,$02            ; Select Instrument $02 - IM-BATMAN
               dc.b $23,$9C
               dc.b PTNCMD_END_OR_LOOP                      ; end pattern (no loop)


               ; Pattern 05 - used by channel 3 ( Voice & Guitar )
               ; Original address $0001BBCC
sound_pattern_05   
               dc.b PTNCMD_SELECT_INSTRUMENT,$0a            ; Select Instrument $0A - CRUNCHGUITAR-C4
               dc.b PTNCMD_ADSR_ENVELOPE,$04                ; ADSR Envelope $04
               dc.b PTNCMD_MODULATION_START,$14,$01,$03     ; Start Vibrato $14,$01,$03
               dc.b $3D,$48                                 ; list of note, duration
               dc.b $3F,$18                                 ; ...
               dc.b $3A,$60
               dc.b $3A,$48
               dc.b $3D,$18
               dc.b $38,$60
               dc.b PTNCMD_END_OR_LOOP                      ; end pattern (no loop)


               ; Pattern 06 - used by channel 2 (bass) 
               ; Original address $0001BBE1
sound_pattern_06 
               dc.b PTNCMD_SELECT_INSTRUMENT,$09            ; Select Instrument $09 - TIMEBASS-GS
               dc.b PTNCMD_ADSR_ENVELOPE,$04                ; ADSR Envelope $04
               dc.b $14,$0C                                 ; List of Note, Duration
               dc.b $20,$0C                                 ; ...
               dc.b $20,$0C
               dc.b $14,$06
               dc.b $1E,$0C
               dc.b $14,$06
               dc.b $20,$0C
               dc.b $1E,$0C
               dc.b $20,$0C
               dc.b $14,$0C
               dc.b $20,$0C
               dc.b $20,$0C
               dc.b $14,$06
               dc.b $1E,$0C
               dc.b $14,$06
               dc.b $20,$06
               dc.b $14,$06
               dc.b $1E,$06
               dc.b $14,$06
               dc.b $20,$06
               dc.b $14,$06
               dc.b $0F,$0C
               dc.b $1B,$0C
               dc.b $1B,$0C
               dc.b $0F,$06
               dc.b $19,$0C
               dc.b $0F,$06
               dc.b $1B,$0C
               dc.b $19,$0C
               dc.b $1B,$0C
               dc.b $0F,$0C
               dc.b $1B,$0C
               dc.b $1B,$0C
               dc.b $0F,$06
               dc.b $19,$0C
               dc.b $0F,$06
               dc.b $1B,$06
               dc.b $0F,$06
               dc.b $19,$06
               dc.b $0F,$06
               dc.b $1B,$06
               dc.b $0F,$06
               dc.b PTNCMD_END_OR_LOOP                      ; end pattern (no loop)


               ; Pattern 07 - used by channel 3 ( Joker Laugh )
               ; Original address $0001B9F8
sound_pattern_07
               dc.b PTNCMD_SELECT_INSTRUMENT,$0b            ; Select Instrument $0B - LAUGH (Joker)
               dc.b PTNCMD_ADSR_ENVELOPE,$03                ; ADSR Envelope $03
               dc.b $18,$96                                 ; note, duration
               dc.b PTNCMD_END_OR_LOOP                      ; end pattern (no loop)


               ; Pattern 08 - used by channel 3 ( Batman IWanna )
               ; Original address $0001B9FF
sound_pattern_08                                 
               dc.b PTNCMD_SELECT_INSTRUMENT,$0c            ; Select Instrument $0C - IWANNNA (Batman)
               dc.b PTNCMD_ADSR_ENVELOPE,$03                ; ADSR Envelope $03
               dc.b $18,$96                                 ; note, duration
               dc.b PTNCMD_END_OR_LOOP                      ; end pattern (no loop)

               ; Pattern 09 - unused pattern data
               ; Original address $0001BC3A
sound_pattern_09 
L0001BC3A       dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00


     ENDC
