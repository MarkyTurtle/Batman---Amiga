

    IFND SOUND_DRIVER_DATASTRUCTURES_S
SOUND_DRIVER_DATASTRUCTURES_S  EQU 1


               even               
               ; Audio DMA Value
               ;    - Changes to DMACON (Active DMA Channels)
               ;    - Accumulation of Channel_xx_Status offset 0x54 (channel DMA bit)
               ;    - Original Address $0000417c
audio_dma      dc.w    $0000                           


               ; Current Sound Play/Tick Counter
               ; Is Cleared when a Song or SFX is started,
               ; Measures the number of ticks played for the latest started sound
               ; No good for measuring a background tune when SFX played over the top.
               ; because it's a shared value for songs and SFX.
               ; Not used by the player, may be used by external programs?
               ; - Original Address $0000417e
play_tick_counter   
               dc.w    $0000
               even

               ; Global Music Volume Mask - Allows external progam to mute the music
               ; Original Address $0000401c
master_music_volume_mask_1   
               dc.w    $ffff 


               ; Global SFX Volume Mask - Allows external program tomute the SFX
               ; Original Address $0000401e
master_sfx_volume_mask_2   
               dc.w    $ffff 


               ; Global Sound Control Bits
               ; Original Address $00004020
               ; Accumulated Audio Channel Control Bits/Flags
               ;    BIT 15 - 1 = Music is Playing
               ;    BIT 14 - 1 = SFX is PLaying
               ;    BIT 03 - 1 = Channel 03 is Active (SFX Channel)
               ;    BIT 02 - 1 = Channel 02 is Active (Music Channel)
               ;    BIT 01 - 1 = Channel 01 is Active (Music Channel)
               ;    BIT 00 - 1 = Channel 00 is Active (Music Channel)
sounddriver_ctrl_bits 
               dc.w    $0000                                   ; cleared when audio is silenced


               ; The currently playing song/tune id number
               ; Original Address $00004022
sounddriver_song_number         
               dc.b    $00


               ; The currently playing SFX id number
               ; Original Address $00004023
sounddriver_sfx_number
               dc.b    $00    
               even


                even
                ; NOTE PITCH/PERIOD TABLE 
                ;       - audio channel period values - note frequenies
                ;       - indexes to $00004bba clamped to -48 bytes or +44 bytes to remain in table range
                ;       - I've got the table running B to B (may be I'm a semi-tone out C to C - most likely)
note_period_table                                               ; original address L00004B8A
                dc.w    $06FE           ; B     (1790)
                dc.w    $0699           ; C     (1689)
                dc.w    $063B           ; C#    (1595)
                dc.w    $05E1           ; D     (1505)
                dc.w    $058D           ; D#    (1421)
                dc.w    $053D           ; E     (1341)          ; note_period_table+10
                dc.w    $04F2           ; F     (1266)
                dc.W    $04AB           ; F#    (1195)
                dc.w    $0467           ; G     (1127)
                dc.W    $0428           ; G#    (1064)
                dc.W    $03EC           ; A     (1004)          ; note_period_table+20
                dc.W    $03B4           ; A#    (948)
                dc.W    $037F           ; B     (895)
                dc.w    $034D           ; C     (845)
                dc.W    $031D           ; C#    (797)
                dc.w    $02F1           ; D     (753)           ; note_period_table+30
                dc.w    $02C6           ; D#    (710)
                dc.w    $029E           ; E     (670)
                dc.w    $0279           ; F     (633)
                dc.w    $0255           ; F#    (633)
                dc.w    $0234           ; G     (564)           ; note_period_table+40
                dc.w    $0214           ; G#    (532)
                dc.w    $01F6           ; A     (502)
                dc.w    $01DA           ; A#    (474)
; used in frame play routine - Centre point of Table
L00004BBA       dc.w    $01BF           ; B     (447)           ; note_period_table+48
                dc.w    $01A6           ; C     (422)
                dc.w    $018F           ; C#    (399)
                dc.w    $0178           ; D     (376)
                dc.w    $0163           ; D#    (355)
                dc.W    $014F           ; E     (335)
                dc.w    $013C           ; F     (316)
                dc.w    $012B           ; F#    (299)
                dc.w    $011A           ; G     (282)
                dc.w    $010A           ; G#    (266)
                dc.W    $00FB           ; A     (251)
                dc.w    $00ED           ; A#    (237)
                dc.w    $00E0           ; B     (224)
                dc.w    $00D3           ; C     (211)
                dc.w    $00C7           ; C#    (199)
                dc.w    $00BC           ; D     (188)
                dc.w    $00B2           ; D#    (178)
                dc.w    $00A8           ; E     (168)
                dc.W    $009E           ; F     (158)
                dc.W    $0095           ; F#    (149)
                dc.W    $008D           ; G     (141)
                dc.w    $0085           ; G#    (133)
                dc.W    $007E           ; A     (126)
                dc.w    $0077           ; A#    (119)





                ;---------------------------- instrument data table -----------------------------
                ; I think each 16 bytes represents data describing a sound/instrument.
                ; There are 12 samples in the Sample Data and 12 entries below.
                ; THe table below could have room for 20 or 21 entries (only 12 in use)
                ; the parameters from the SampleTable below @ $00004D52 'iff_sample_data_table' 
                ; are copied into this table.
                ;
                ;       - The 16bit value offset 4 of each sample is copied to offset 0 of this table.
                ;       - The 16bit value offset 6 of each sample is copied to offset $e (14) of this table.
                ;
                ; I guess that this may be reseting values for the insrument volume (param 1)
                ; and a second param (unsure, values either 0, or -1). could be a repeat value 
                ; or something similar.
                ;
                ; I think the following table is used during the playing of the song(s),
                ; and keeps track of the instrument settings for each sample 
                ; (which may change during the playing of the song?)
                ;
                ; I think the following format.
                ;
                ; Offset        | Size          | Description
                ;---------------+---------------+-----------------------------------------
                ; 0             | 2             | I think default sample volume
                ; 2             | 4             | Sample Data Start Address
                ; 6             | 2             | Sample Length in Words
                ; 8             | 4             | Sample Repeat Start Address
                ; 12            | 2             | Sample Repeat Length in Words
                ; 14            | 2             | Unknown Parameter, values either 0 or -1
                ;

; 16 byte data structure for holding instrument data.
; NB: Instrument 0 is hardcoded to a built in 22 byte wave
                    rsreset
instrument_volume             rs.w      1
instrument_sample_ptr         rs.l      1
instrument_sample_len         rs.w      1
instrument_repeat_ptr         rs.l      1
instrument_repeat_len         rs.w      1
instrument_disable_transpose  rs.w      1


instrument_data_table

instrument_00       ; Instrument 0 (Built in wave)
.volume             dc.w $0021
.samplestart        dc.l builtin_waveform
.samplelen          dc.w $000b
.repeatstart        dc.l builtin_waveform
.repeatlen          dc.w $000B 
.disabletranspose   dc.w $0000

instrument_01       ;  Instrument 1 (Built in wave)
.volume             dc.w  $0000
.samplestart        dc.l  $00000000
.samplelen          dc.w  $0000
.repeatstart        dc.l  $00000000
.repeatlen          dc.w  $0000
.disabletranspose   dc.w  $0000    

instrument_02       ;  Instrument 2 (Built in wave)
.volume             dc.w  $0000
.samplestart        dc.l  $00000000
.samplelen          dc.w  $0000
.repeatstart        dc.l  $00000000
.repeatlen          dc.w  $0000
.disabletranspose   dc.w  $0000    

instrument_03       ;  Instrument 3 (Built in wave)
.volume             dc.w  $0000
.samplestart        dc.l  $00000000
.samplelen          dc.w  $0000
.repeatstart        dc.l  $00000000
.repeatlen          dc.w  $0000
.disabletranspose   dc.w  $0000    

instrument_04       ;  Instrument 4 (Built in wave)
.volume             dc.w  $0000
.samplestart        dc.l  $00000000
.samplelen          dc.w  $0000
.repeatstart        dc.l  $00000000
.repeatlen          dc.w  $0000
.disabletranspose   dc.w  $0000

instrument_05       ;  Instrument 5 (Built in wave)
.volume             dc.w  $0000
.samplestart        dc.l  $00000000
.samplelen          dc.w  $0000
.repeatstart        dc.l  $00000000
.repeatlen          dc.w  $0000
.disabletranspose   dc.w  $0000

instrument_06       ;  Instrument 6 (Built in wave)
.volume             dc.w  $0000
.samplestart        dc.l  $00000000
.samplelen          dc.w  $0000
.repeatstart        dc.l  $00000000
.repeatlen          dc.w  $0000
.disabletranspose   dc.w  $0000  

instrument_07       ;  Instrument 7 (Built in wave)
.volume             dc.w  $0000
.samplestart        dc.l  $00000000
.samplelen          dc.w  $0000
.repeatstart        dc.l  $00000000
.repeatlen          dc.w  $0000
.disabletranspose   dc.w  $0000    

instrument_08       ;  Instrument 8 (Built in wave)
.volume             dc.w  $0000
.samplestart        dc.l  $00000000
.samplelen          dc.w  $0000
.repeatstart        dc.l  $00000000
.repeatlen          dc.w  $0000
.disabletranspose   dc.w  $0000    

instrument_09       ;  Instrument 9 (Built in wave)
.volume             dc.w  $0000
.samplestart        dc.l  $00000000
.samplelen          dc.w  $0000
.repeatstart        dc.l  $00000000
.repeatlen          dc.w  $0000
.disabletranspose   dc.w  $0000    

instrument_10       ;  Instrument 10 (Built in wave)
.volume             dc.w  $0000
.samplestart        dc.l  $00000000
.samplelen          dc.w  $0000
.repeatstart        dc.l  $00000000
.repeatlen          dc.w  $0000
.disabletranspose   dc.w  $0000

instrument_11       ;  Instrument 11 (Built in wave)
.volume             dc.w  $0000
.samplestart        dc.l  $00000000
.samplelen          dc.w  $0000
.repeatstart        dc.l  $00000000
.repeatlen          dc.w  $0000
.disabletranspose   dc.w  $0000    

instrument_12       ;  Instrument 12 (Built in wave)
.volume             dc.w  $0000
.samplestart        dc.l  $00000000
.samplelen          dc.w  $0000
.repeatstart        dc.l  $00000000
.repeatlen          dc.w  $0000
.disabletranspose   dc.w  $0000

instrument_13       ;  Instrument 13 (Built in wave)
.volume             dc.w  $0000
.samplestart        dc.l  $00000000
.samplelen          dc.w  $0000
.repeatstart        dc.l  $00000000
.repeatlen          dc.w  $0000
.disabletranspose   dc.w  $0000    

instrument_14       ;  Instrument 14 (Built in wave)
.volume             dc.w  $0000
.samplestart        dc.l  $00000000
.samplelen          dc.w  $0000
.repeatstart        dc.l  $00000000
.repeatlen          dc.w  $0000
.disabletranspose   dc.w  $0000    

instrument_15       ;  Instrument 15 (Built in wave)
.volume             dc.w  $0000
.samplestart        dc.l  $00000000
.samplelen          dc.w  $0000
.repeatstart        dc.l  $00000000
.repeatlen          dc.w  $0000
.disabletranspose   dc.w  $0000    

instrument_16       ;  Instrument 16 (Built in wave)
.volume             dc.w  $0000
.samplestart        dc.l  $00000000
.samplelen          dc.w  $0000
.repeatstart        dc.l  $00000000
.repeatlen          dc.w  $0000
.disabletranspose   dc.w  $0000    

instrument_17       ;  Instrument 17 (Built in wave)
.volume             dc.w  $0000
.samplestart        dc.l  $00000000
.samplelen          dc.w  $0000
.repeatstart        dc.l  $00000000
.repeatlen          dc.w  $0000
.disabletranspose   dc.w  $0000    

instrument_18       ;  Instrument 18 (Built in wave)
.volume             dc.w  $0000
.samplestart        dc.l  $00000000
.samplelen          dc.w  $0000
.repeatstart        dc.l  $00000000
.repeatlen          dc.w  $0000
.disabletranspose   dc.w  $0000    

instrument_19       ;  Instrument 19 (Built in wave)
.volume             dc.w  $0000
.samplestart        dc.l  $00000000
.samplelen          dc.w  $0000
.repeatstart        dc.l  $00000000
.repeatlen          dc.w  $0000
.disabletranspose   dc.w  $0000    

instrument_20       ;  Instrument 20 (Built in wave)
.volume             dc.w  $0000
.samplestart        dc.l  $00000000
.samplelen          dc.w  $0000
.repeatstart        dc.l  $00000000
.repeatlen          dc.w  $0000
.disabletranspose   dc.w  $0000    


                    ; Silent Repeat Sample Data
                    ; Used for repeating samples where there is no repeat,
                    ; to play a quiet sound
                    ; Original Address $00004D3A
silient_repeat      dc.w  $0000       


                    ;------------------------------------------------------------
                    ; Instrument 0 - Sample Data
                    ; Built in waveform (11 words/22 bytes)
                    ; Instrument 0 is a built in shart waveform,
                    ; maybe something left over from testing the Sound Driver
                    ; Original Address $00004D3C
builtin_waveform    
                    dc.w  $0074,$60DC,$82BB,$457E,$24A0,$8C00,$7460
                    dc.w  $DC82,$BB45,$7E24,$A08C



 
               ; ----------------------------- MODULE TABLE -----------------------------
               ; The 'module_table' is an additional data structure added to the
               ; Sound Driver to enable the music data to be made modular.
               ; This is so the same SoundDriver code can be used to play sound files
               ; from each level. Hardcoded/baked-in address references have been
               ; removed from the SoundDriver code and placed in the following table
               ; during the method:
               ;
               ;    - void SoundDriver_Initialise(a0.l = MODULE PTR_ method)
               ;
               rsreset
mod_iff_samples     rs.l      1
mod_sound_table     rs.l      1
mod_pattern_table   rs.l      1
mod_arpeggio_table  rs.l      1
mod_adsr_table      rs.l      1
mod_number_sounds   rs.w      1


module_table:
               dc.l $00000000               
               dc.l $00000000
               dc.l $00000000
               dc.l $00000000
               dc.l $00000000
               dc.w $0000





          rsreset
chan_ActiveCommandBits                  rs.w      1         ; 0x00
chan_ptrTrackSequenceLoopStart          rs.l      1         ; 0x02
chan_ptrNextTrackSequencePosition       rs.l      1         ; 0x06
chan_ptrPatternDataLoop                 rs.l      1         ; 0x0a
chan_ptrNextPatternDataPosition         rs.l      1         ; 0x0e
chan_patternLoopCount                   rs.b      1         ; 0x12
chan_patternTransposeValue              rs.b      1         ; 0x13
chan_ptrADSREnvelope                    rs.l      1         ; 0x14
chan_ptrCurrentADSREnvelope             rs.l      1         ; 0x18
chan_adsrRateOfChangeTicks              rs.b      1         ; 0x1c
chan_adsrCurrentRateOfChangeTicks       rs.b      1         ; 0x1d
; current ADSR phase timespan in ticks
chan_adsrEnvelopePhaseTicks             rs.w      1         ; 0x1e
chan_adsrVolumeRateOfChange             rs.b      1         ; 0x20
chan_paramLeadInNoteOfffset             rs.b      1         ; 0x21
chan_paramLeadInNoteDurationTicks       rs.b      1         ; 0x22
chan_leadInNoteCurrentTicks             rs.b      1         ; 0x23
chan_paramPortomentoStartOffset         rs.b      1         ; 0x24
chan_paramPortomentoLengthTicks         rs.b      1         ; 0x25
chan_portomentoAmountPerTick            rs.b      1         ; 0x26
chan_unreferenced_01                    rs.b      1         ; 0x27    unused pad byte
chan_ptrArpeggioTable                   rs.l      1         ; 0x28
chan_ptrArpeggioCurrentTable            rs.l      1         ; 0x2c
chan_paramArpeggioTableLength           rs.b      1         ; 0x30
chan_arpeggioTableLenCount              rs.b      1         ; 0x31
chan_paramArpeggioSpeedTicks            rs.b      1         ; 0x32
chan_arpeggioRateTicks                  rs.b      1         ; 0x33
chan_paramModulationLevel               rs.b      1         ; 0x34
chan_paramModulationSpeed               rs.b      1         ; 0x35
chan_paramModulationDelayStart          rs.b      1         ; 0x36
chan_modulationDelayStartTicks          rs.b      1         ; 0x37
chan_modulationSpeedTicks_x2            rs.b      1         ; 0x38
chan_modulationSpeedTicks               rs.b      1         ; 0x39
chan_modulationAmountPerTick            rs.w      1         ; 0x3a
chan_instrumentTuningAmount             rs.w      1         ; 0x3c
chan_ptrInstrumentSampleStart           rs.l      1         ; 0x3e
chan_instrumentSampleLength             rs.w      1         ; 0x42
chan_ptrInstrumentSampleRepeat          rs.l      1         ; 0x44
chan_instrumentRepeatLength             rs.w      1         ; 0x48
chan_notePeriodValue                    rs.w      1         ; 0x4a
chan_noteVolume                         rs.w      1         ; 0x4c
chan_unreferenced_02                    rs.b      1         ; 0x4e    unused pad bye
chan_transposedNoteIndex                rs.b      1         ; 0x4f
chan_transposedLeadInNoteIndex          rs.b      1         ; 0x50
chan_paramPairedNoteDurationTicks       rs.b      1         ; 0x51
chan_currentNoteTicks                   rs.w      1         ; 0x52
chan_ChannelDMA                         rs.w      1         ; 0x54



               ; ----------------------- CHANEL 00 - STATUS -----------------------
               ; This data structure manages the Audio Channel 00 status values.
               ; - It tracks the current sound/song position,
               ; - It holds repeat and looping pointers of the sound/song
               ; - It holds repeat and looping details of the current track/pattern
               ; - It holds transposition values of the current track/pattern
               ; - It holds status of the current sample ADSR volume envelope
               ; - It holes status of the current sample Effect parameters and working values.
               ;    - Lead In Notes (needs more investigation)
               ;    - Portomento Effect (Pitch Slide)
               ;    - Arpeggio Effect (Warbly Chords, Pitch Step Effect)
               ;    - Vibrato Effect (Pitch Modulation)
               ; - It holds the status of the current sample.
               ;    - Repeat/Loop positions
               ;    - Fine pitch tuning (retuning of sample)
               ; - It holds the status of the current note played
               ;    - Note Length
               ;    - DMA Channel Active bits
               ;
channel_00_status                        ; original address L00004024
               ; Channel Control Word 
               ; High Byte (0x8000 = music channel, 0x4000 = SFX channel) 
               ; Low Byte contains Active Effects 
                dc.w    $0000    
                
                ; Name: ptrPatternSequenceLoopStart    - Offset 0x02 - Address Pointer
                ; Pattern Sequences/song restart loop pattern ptr              
                dc.l    $00000000                      
                
                ; Name: ptrNextPatternSequencePosition - Offset 0x06 - Address Pointer
                ; Next Pattern to play after the current one
                dc.l    $00000000                       
                
                ; Name: ptrPatternDataLoop             - Offset 0x0a  - Address Pointer
                ; Loop within the current Pattern
                dc.l    $00000000 
                
                ; Name: ptrNextPatternDataPosition     - Offset 0xe   - Address Pointer
                ; Playing Pattern/Track data position
                dc.l    $00000000   
                
                ; Name: patternLoopCount               - Offset 0x12  - byte value
                ; Number of times to loop the current Pattern - 1 = Play Once (default)           
                dc.b    $00
                
                ; Name: patternTransposeValue          - Offset 0x13  - signed byte value
                ; Signed byte for key change value (+- index into the note period table)
                dc.b    $00 
                
                ; ------------------ 'ADSR' Parameter Values -------------------
                ; values to keep track of the ADSR sound envelope values.
                ;---------------------------------------------------------------
                ; Name: ptrADSREnvelope                - Offset 0x14  - Address Pointer
                ; Pointer to the current sound's ADSR Envelope data
                dc.l    $00000000
                
                ; Name: ptrCurrentADSREnvelope         - Offset 0x18  - Address Pointer
                ; Working Value: Current Pointer into the sound's ADSR Envelope
                dc.l    $00000000
                
                ; Name: adsrRateOfChangeTicks          - Offset 0x1c  - byte value
                ; Parameter - Rate of Change Ticks for the current 'ADSR' phase
                dc.b    $00
                
                ; Name: adsrCurrentRateOfChangeTicks   - Offset 0x1d  - byte value
                ; Working Value - Rate of change for the current ADSR 'phase'
                dc.b    $00
                
                ; Name: adsrEnvelopeDelayTicks         - Offset 0x1e  -  word value
                ; Ticks to Delay ADSR Envelope Processing
                dc.w    $0000
                
                ; Name: adsrVolumeRateOfChange         - Offset 0x20  - signed byte value
                ; The amount the Volume Changes per Rate of Change
                dc.b    $00
                ; -------- END OF SOUND ADSR VALUES --------

                ; --------------- SOUND 'LEAD-IN' Effect Values -----------------
                ; This effect doubles the current note played, 
                ; not happy with my description of this - need to review further
                ; ---------------------------------------------------------------
                ; Name: paramLeadInNoteOfffset         - Offset 0x21  - signed byte
                ; Parameter - Signed Byte for lead-in note Pitch Offest
                dc.b    $00
                
                ; Name: paramLeadInNoteDurationTicks   - Offset 0x22  - byte value
                ; Parameter - Duration of the lead-in note in Ticks
                dc.b    $00
                
                ; Name: leadInNoteCurrentTicks         - Offset 0x23  - byte value
                ; Working Value: Leadin Note Ticks Value
                dc.b    $00           
                ; -------- End of 'LEAD-IN' Effect Values

                ; ---------------- 'PORTOMENTO' Effect Values -----------------
                ; This effect enables a note's pitch to slide into the next
                ;--------------------------------------------------------------
                ; Name: paramPortomentoStartOffset     - Offset 0x24
                ; Parameter - Signed Pitch Offset of the Next Pattern Note. (Start pitch of the Portomento)
                dc.b    $00                             
                ; Name: paramPortomentoLengthTicks     - Offest 0x25
                ; Parameter - The length of the Portomento Slide in Ticks
                dc.b    $00                             
                ; Name: portomentoAmountPerTick        - Offset 0x26
                ; The rate of portomento per tick
                dc.b    $00                             
                ; --------- End of 'PORTOMENTO' Effect Values ---------

                ; Unreferenced byte value (maybe a pad byte for next ptr)
                dc.b    $00                            ; Offset 0x27
                
                ; ------------------'ARPEGGIO' Effect Values ---------------------
                ; This effect is used to give a single channel the warbly chords
                ; effect, or when slowed down, plays the individual notes of
                ; a chord at fixed intervals repeated in sequence.
                ;-----------------------------------------------------------------
                ; Name: ptrArpeggioTable               Offset 0x28
                ; Data Start - Pointer into Arpeggio Table
                dc.l    $00000000 
                
                ; Name: ptrArpeggioCurrentTable        Offset 0x2c
                ; Working ptr into Arpeggio Table
                dc.l    $00000000                    
                
                ; Name: paramArpeggioTableLength       Offset 0x30
                ; Byte[1] of Arpeggio Table - Size of data in the Table (after initial 2 bytes)
                dc.b    $00                         
                
                ; Name: arpeggioTableLenCount          Offset 0x31
                ; The size of the Arpeggio Table in Bytes/Entries
                dc.b    $00                         
                
                ; Name: paramArpeggioSpeedTicks        Offset 0x32
                ; Byte[0] of Arpeggio Table - Arpeggion Speed/Rate in Ticks
                dc.b    $00                         
                
                ; Name: arpeggioRateTicks              Offset 0x33
                ; Woring Value: Arpeggio Rate in Ticks
                dc.b    $00                         
                

               ;-------------------------- 'VIBRATO' Effect Values -----------------------
               ; The vibrato is a pitch modulation effect.
               ;--------------------------------------------------------------------------
                ; Name: paramModulationLevel           Offset 0x34
                ; Parameter - The amount of modulation applied by the effect
                dc.b    $00                     
                
                ; Name: paramModulationSpeed           Offset 0x35
                ; Parameter - The speed/rate of the modulation effect
                dc.b    $00                        
                
                ; Name: paramModulationDelayStart      Offset 0x36
                ; Parameter - Delay the start of the modulation effect in ticks
                dc.b    $00                     
                
                ; Name: modulationDelayStartTicks      Offset 0x37
                ; Working Value: initialised as a copy of modulatioDelayStart
                dc.b    $00                     
                
                ; Name: modulationSpeedTicks_x2        Offset 0x38
                ; Working Value: initialised as modulationSpeed x 2 
                dc.b    $00                          
                
                ; Name: modulationSpeedTicks           Offset 0x39
                ; Working Value: Initialised as modulationSpeed
                dc.b    $00                          
                
                ; Name: modulationAmountPerTick        Offset 0x3a
                ; Working Value: Initialised as modulationLevel / modulationSpeed
                dc.w    $0000                        
                

               ;------------------------ 'INSTRUMENT' Values ------------------------
               ; Details of the current Instrument/Sample being played
               ;---------------------------------------------------------------------
                ; Name: instrumentTuningAmount         Offset 0x3c
                ; Current Sample's signed tuning value. Number if Intervals to retune the sample by.
                dc.w    $0000                                
                
                ; Name: ptrInstrumentSampleStart       Offset 0x3e
                ; Pointer to the start of the Instrument's Sample Data
                dc.l    $00000000                    
                
                ; Name: instrumentSampleLength         Offset 0x42
                ; Length of the Sample to play (before repeat if any)
                dc.w    $0000                                    
                
                ; Name: ptrInstrumentSampleRepeat      Offset 0x44
                ; Pointer to the instrument's Repeat Sample Data
                dc.l    $00000000                       
                
                ; Name: instrumentRepeatLength         Offset 0x48
                ; Length of the Instrument's Repeat Sample Data
                dc.w    $0000                                    
                
               ;------------------ CURRENT PLAYING NOTE VALUES ----------------------
               ; Here are the working values for the currently playing note.
               ;---------------------------------------------------------------------
                ; Name: notePeriodValue                Offset 0x42
                ; Actual Current Note Period Value
                dc.w    $0000                              

                ; Name: noteVolume                     Offset 0x4c
                ; Current Note Volume
                dc.w    $0000                         
                
                ; Name: unreferenced_02                Offset 0x4e
                ; Unused Unreferenced Value
                dc.b    $00                          
                
                ; Name: transposedNoteIndex            Offset 0x4f
                ; Transposed Note Value as an index into the note period table.
                dc.b    $00                                      
                
                ; Name: transposedLeadInNoteIndex      Offset 0x50
                ; Transposed Note Value as an index into the note period table. (with Leadin modification if any)
                dc.b    $00                                        
                
                ; Name: paramPairedNoteDurationTicks   Offset 0x51
                ; Parameter - Paired Notes Effect 0x84 - Additional Note Duration
                dc.b    $00                                         
                
                ; Name: currentNoteTicks               Offset 0x52
                ; The current 'tick' count (VBlank Count) of the Current Playing Note.
                dc.w    $0000                                    
                
                ; Name: ChannelDMA
                ; Channel DMA bit - Power of 2 Value (1,2,4,8 for each channel)
                dc.w    $0001           ; Value not initialised by the Driver                          



               ; ----------------------- CHANEL 01 - STATUS -----------------------
               ; This data structure manages the Audio Channel 01 status values.
               ; - It tracks the current sound/song position,
               ; - It holds repeat and looping pointers of the sound/song
               ; - It holds repeat and looping details of the current track/pattern
               ; - It holds transposition values of the current track/pattern
               ; - It holds status of the current sample ADSR volume envelope
               ; - It holes status of the current sample Effect parameters and working values.
               ;    - Lead In Notes (needs more investigation)
               ;    - Portomento Effect (Pitch Slide)
               ;    - Arpeggio Effect (Warbly Chords, Pitch Step Effect)
               ;    - Vibrato Effect (Pitch Modulation)
               ; - It holds the status of the current sample.
               ;    - Repeat/Loop positions
               ;    - Fine pitch tuning (retuning of sample)
               ; - It holds the status of the current note played
               ;    - Note Length
               ;    - DMA Channel Active bits
               ;
channel_01_status                                        ; original address L0000407a
               ; Channel Control Word 
               ; High Byte (0x8000 = music channel, 0x4000 = SFX channel) 
               ; Low Byte contains Active Effects 
                dc.w    $0000    
                
                ; Name: ptrPatternSequenceLoopStart    - Offset 0x02 - Address Pointer
                ; Pattern Sequences/song restart loop pattern ptr              
                dc.l    $00000000                      
                
                ; Name: ptrNextPatternSequencePosition - Offset 0x06 - Address Pointer
                ; Next Pattern to play after the current one
                dc.l    $00000000                       
                
                ; Name: ptrPatternDataLoop             - Offset 0x0a  - Address Pointer
                ; Loop within the current Pattern
                dc.l    $00000000 
                
                ; Name: ptrNextPatternDataPosition     - Offset 0xe   - Address Pointer
                ; Playing Pattern/Track data position
                dc.l    $00000000   
                
                ; Name: patternLoopCount               - Offset 0x12  - byte value
                ; Number of times to loop the current Pattern - 1 = Play Once (default)           
                dc.b    $00
                
                ; Name: patternTransposeValue          - Offset 0x13  - signed byte value
                ; Signed byte for key change value (+- index into the note period table)
                dc.b    $00 
                
                ; ------------------ 'ADSR' Parameter Values -------------------
                ; values to keep track of the ADSR sound envelope values.
                ;---------------------------------------------------------------
                ; Name: ptrADSREnvelope                - Offset 0x14  - Address Pointer
                ; Pointer to the current sound's ADSR Envelope data
                dc.l    $00000000
                
                ; Name: ptrCurrentADSREnvelope         - Offset 0x18  - Address Pointer
                ; Working Value: Current Pointer into the sound's ADSR Envelope
                dc.l    $00000000
                
                ; Name: adsrRateOfChangeTicks          - Offset 0x1c  - byte value
                ; Parameter - Rate of Change Ticks for the current 'ADSR' phase
                dc.b    $00
                
                ; Name: adsrCurrentRateOfChangeTicks   - Offset 0x1d  - byte value
                ; Working Value - Rate of change for the current ADSR 'phase'
                dc.b    $00
                
                ; Name: adsrEnvelopeDelayTicks         - Offset 0x1e  -  word value
                ; Ticks to Delay ADSR Envelope Processing
                dc.w    $0000
                
                ; Name: adsrVolumeRateOfChange         - Offset 0x20  - signed byte value
                ; The amount the Volume Changes per Rate of Change
                dc.b    $00
                ; -------- END OF SOUND ADSR VALUES --------

                ; --------------- SOUND 'LEAD-IN' Effect Values -----------------
                ; This effect doubles the current note played, 
                ; not happy with my description of this - need to review further
                ; ---------------------------------------------------------------
                ; Name: paramLeadInNoteOfffset         - Offset 0x21  - signed byte
                ; Parameter - Signed Byte for lead-in note Pitch Offest
                dc.b    $00
                
                ; Name: paramLeadInNoteDurationTicks   - Offset 0x22  - byte value
                ; Parameter - Duration of the lead-in note in Ticks
                dc.b    $00
                
                ; Name: leadInNoteCurrentTicks         - Offset 0x23  - byte value
                ; Working Value: Leadin Note Ticks Value
                dc.b    $00           
                ; -------- End of 'LEAD-IN' Effect Values

                ; ---------------- 'PORTOMENTO' Effect Values -----------------
                ; This effect enables a note's pitch to slide into the next
                ;--------------------------------------------------------------
                ; Name: paramPortomentoStartOffset     - Offset 0x24
                ; Parameter - Signed Pitch Offset of the Next Pattern Note. (Start pitch of the Portomento)
                dc.b    $00                             
                ; Name: paramPortomentoLengthTicks     - Offest 0x25
                ; Parameter - The length of the Portomento Slide in Ticks
                dc.b    $00                             
                ; Name: portomentoAmountPerTick        - Offset 0x26
                ; The rate of portomento per tick
                dc.b    $00                             
                ; --------- End of 'PORTOMENTO' Effect Values ---------

                ; Unreferenced byte value (maybe a pad byte for next ptr)
                dc.b    $00                            ; Offset 0x27
                
                ; ------------------'ARPEGGIO' Effect Values ---------------------
                ; This effect is used to give a single channel the warbly chords
                ; effect, or when slowed down, plays the individual notes of
                ; a chord at fixed intervals repeated in sequence.
                ;-----------------------------------------------------------------
                ; Name: ptrArpeggioTable               Offset 0x28
                ; Data Start - Pointer into Arpeggio Table
                dc.l    $00000000 
                
                ; Name: ptrArpeggioCurrentTable        Offset 0x2c
                ; Working ptr into Arpeggio Table
                dc.l    $00000000                    
                
                ; Name: paramArpeggioTableLength       Offset 0x30
                ; Byte[1] of Arpeggio Table - Size of data in the Table (after initial 2 bytes)
                dc.b    $00                         
                
                ; Name: arpeggioTableLenCount          Offset 0x31
                ; The size of the Arpeggio Table in Bytes/Entries
                dc.b    $00                         
                
                ; Name: paramArpeggioSpeedTicks        Offset 0x32
                ; Byte[0] of Arpeggio Table - Arpeggion Speed/Rate in Ticks
                dc.b    $00                         
                
                ; Name: arpeggioRateTicks              Offset 0x33
                ; Woring Value: Arpeggio Rate in Ticks
                dc.b    $00                         
                

               ;-------------------------- 'VIBRATO' Effect Values -----------------------
               ; The vibrato is a pitch modulation effect.
               ;--------------------------------------------------------------------------
                ; Name: paramModulationLevel           Offset 0x34
                ; Parameter - The amount of modulation applied by the effect
                dc.b    $00                     
                
                ; Name: paramModulationSpeed           Offset 0x35
                ; Parameter - The speed/rate of the modulation effect
                dc.b    $00                        
                
                ; Name: paramModulationDelayStart      Offset 0x36
                ; Parameter - Delay the start of the modulation effect in ticks
                dc.b    $00                     
                
                ; Name: modulationDelayStartTicks      Offset 0x37
                ; Working Value: initialised as a copy of modulatioDelayStart
                dc.b    $00                     
                
                ; Name: modulationSpeedTicks_x2        Offset 0x38
                ; Working Value: initialised as modulationSpeed x 2 
                dc.b    $00                          
                
                ; Name: modulationSpeedTicks           Offset 0x39
                ; Working Value: Initialised as modulationSpeed
                dc.b    $00                          
                
                ; Name: modulationAmountPerTick        Offset 0x3a
                ; Working Value: Initialised as modulationLevel / modulationSpeed
                dc.w    $0000                        
                

               ;------------------------ 'INSTRUMENT' Values ------------------------
               ; Details of the current Instrument/Sample being played
               ;---------------------------------------------------------------------
                ; Name: instrumentTuningAmount         Offset 0x3c
                ; Current Sample's signed tuning value. Number if Intervals to retune the sample by.
                dc.w    $0000                                
                
                ; Name: ptrInstrumentSampleStart       Offset 0x3e
                ; Pointer to the start of the Instrument's Sample Data
                dc.l    $00000000                    
                
                ; Name: instrumentSampleLength         Offset 0x42
                ; Length of the Sample to play (before repeat if any)
                dc.w    $0000                                    
                
                ; Name: ptrInstrumentSampleRepeat      Offset 0x44
                ; Pointer to the instrument's Repeat Sample Data
                dc.l    $00000000                       
                
                ; Name: instrumentRepeatLength         Offset 0x48
                ; Length of the Instrument's Repeat Sample Data
                dc.w    $0000                                    
                
               ;------------------ CURRENT PLAYING NOTE VALUES ----------------------
               ; Here are the working values for the currently playing note.
               ;---------------------------------------------------------------------
                ; Name: notePeriodValue                Offset 0x42
                ; Actual Current Note Period Value
                dc.w    $0000                              

                ; Name: noteVolume                     Offset 0x4c
                ; Current Note Volume
                dc.w    $0000                         
                
                ; Name: unreferenced_02                Offset 0x4e
                ; Unused Unreferenced Value
                dc.b    $00                          
                
                ; Name: transposedNoteIndex            Offset 0x4f
                ; Transposed Note Value as an index into the note period table.
                dc.b    $00                                      
                
                ; Name: transposedLeadInNoteIndex      Offset 0x50
                ; Transposed Note Value as an index into the note period table. (with Leadin modification if any)
                dc.b    $00                                        
                
                ; Name: paramPairedNoteDurationTicks   Offset 0x51
                ; Parameter - Paired Notes Effect 0x84 - Additional Note Duration
                dc.b    $00                                         
                
                ; Name: currentNoteTicks               Offset 0x52
                ; The current 'tick' count (VBlank Count) of the Current Playing Note.
                dc.w    $0000                                    
                
                ; Name: ChannelDMA
                ; Channel DMA bit - Power of 2 Value (1,2,4,8 for each channel)
                dc.w    $0002           ; Value not initialised by the Driver                          


               ; ----------------------- CHANEL 02 - STATUS -----------------------
               ; This data structure manages the Audio Channel 02 status values.
               ; - It tracks the current sound/song position,
               ; - It holds repeat and looping pointers of the sound/song
               ; - It holds repeat and looping details of the current track/pattern
               ; - It holds transposition values of the current track/pattern
               ; - It holds status of the current sample ADSR volume envelope
               ; - It holes status of the current sample Effect parameters and working values.
               ;    - Lead In Notes (needs more investigation)
               ;    - Portomento Effect (Pitch Slide)
               ;    - Arpeggio Effect (Warbly Chords, Pitch Step Effect)
               ;    - Vibrato Effect (Pitch Modulation)
               ; - It holds the status of the current sample.
               ;    - Repeat/Loop positions
               ;    - Fine pitch tuning (retuning of sample)
               ; - It holds the status of the current note played
               ;    - Note Length
               ;    - DMA Channel Active bits
               ;
channel_02_status                                        ; original address L000040d0
               ; Channel Control Word 
               ; High Byte (0x8000 = music channel, 0x4000 = SFX channel) 
               ; Low Byte contains Active Effects 
                dc.w    $0000    
                
                ; Name: ptrPatternSequenceLoopStart    - Offset 0x02 - Address Pointer
                ; Pattern Sequences/song restart loop pattern ptr              
                dc.l    $00000000                      
                
                ; Name: ptrNextPatternSequencePosition - Offset 0x06 - Address Pointer
                ; Next Pattern to play after the current one
                dc.l    $00000000                       
                
                ; Name: ptrPatternDataLoop             - Offset 0x0a  - Address Pointer
                ; Loop within the current Pattern
                dc.l    $00000000 
                
                ; Name: ptrNextPatternDataPosition     - Offset 0xe   - Address Pointer
                ; Playing Pattern/Track data position
                dc.l    $00000000   
                
                ; Name: patternLoopCount               - Offset 0x12  - byte value
                ; Number of times to loop the current Pattern - 1 = Play Once (default)           
                dc.b    $00
                
                ; Name: patternTransposeValue          - Offset 0x13  - signed byte value
                ; Signed byte for key change value (+- index into the note period table)
                dc.b    $00 
                
                ; ------------------ 'ADSR' Parameter Values -------------------
                ; values to keep track of the ADSR sound envelope values.
                ;---------------------------------------------------------------
                ; Name: ptrADSREnvelope                - Offset 0x14  - Address Pointer
                ; Pointer to the current sound's ADSR Envelope data
                dc.l    $00000000
                
                ; Name: ptrCurrentADSREnvelope         - Offset 0x18  - Address Pointer
                ; Working Value: Current Pointer into the sound's ADSR Envelope
                dc.l    $00000000
                
                ; Name: adsrRateOfChangeTicks          - Offset 0x1c  - byte value
                ; Parameter - Rate of Change Ticks for the current 'ADSR' phase
                dc.b    $00
                
                ; Name: adsrCurrentRateOfChangeTicks   - Offset 0x1d  - byte value
                ; Working Value - Rate of change for the current ADSR 'phase'
                dc.b    $00
                
                ; Name: adsrEnvelopeDelayTicks         - Offset 0x1e  -  word value
                ; Ticks to Delay ADSR Envelope Processing
                dc.w    $0000
                
                ; Name: adsrVolumeRateOfChange         - Offset 0x20  - signed byte value
                ; The amount the Volume Changes per Rate of Change
                dc.b    $00
                ; -------- END OF SOUND ADSR VALUES --------

                ; --------------- SOUND 'LEAD-IN' Effect Values -----------------
                ; This effect doubles the current note played, 
                ; not happy with my description of this - need to review further
                ; ---------------------------------------------------------------
                ; Name: paramLeadInNoteOfffset         - Offset 0x21  - signed byte
                ; Parameter - Signed Byte for lead-in note Pitch Offest
                dc.b    $00
                
                ; Name: paramLeadInNoteDurationTicks   - Offset 0x22  - byte value
                ; Parameter - Duration of the lead-in note in Ticks
                dc.b    $00
                
                ; Name: leadInNoteCurrentTicks         - Offset 0x23  - byte value
                ; Working Value: Leadin Note Ticks Value
                dc.b    $00           
                ; -------- End of 'LEAD-IN' Effect Values

                ; ---------------- 'PORTOMENTO' Effect Values -----------------
                ; This effect enables a note's pitch to slide into the next
                ;--------------------------------------------------------------
                ; Name: paramPortomentoStartOffset     - Offset 0x24
                ; Parameter - Signed Pitch Offset of the Next Pattern Note. (Start pitch of the Portomento)
                dc.b    $00                             
                ; Name: paramPortomentoLengthTicks     - Offest 0x25
                ; Parameter - The length of the Portomento Slide in Ticks
                dc.b    $00                             
                ; Name: portomentoAmountPerTick        - Offset 0x26
                ; The rate of portomento per tick
                dc.b    $00                             
                ; --------- End of 'PORTOMENTO' Effect Values ---------

                ; Unreferenced byte value (maybe a pad byte for next ptr)
                dc.b    $00                            ; Offset 0x27
                
                ; ------------------'ARPEGGIO' Effect Values ---------------------
                ; This effect is used to give a single channel the warbly chords
                ; effect, or when slowed down, plays the individual notes of
                ; a chord at fixed intervals repeated in sequence.
                ;-----------------------------------------------------------------
                ; Name: ptrArpeggioTable               Offset 0x28
                ; Data Start - Pointer into Arpeggio Table
                dc.l    $00000000 
                
                ; Name: ptrArpeggioCurrentTable        Offset 0x2c
                ; Working ptr into Arpeggio Table
                dc.l    $00000000                    
                
                ; Name: paramArpeggioTableLength       Offset 0x30
                ; Byte[1] of Arpeggio Table - Size of data in the Table (after initial 2 bytes)
                dc.b    $00                         
                
                ; Name: arpeggioTableLenCount          Offset 0x31
                ; The size of the Arpeggio Table in Bytes/Entries
                dc.b    $00                         
                
                ; Name: paramArpeggioSpeedTicks        Offset 0x32
                ; Byte[0] of Arpeggio Table - Arpeggion Speed/Rate in Ticks
                dc.b    $00                         
                
                ; Name: arpeggioRateTicks              Offset 0x33
                ; Woring Value: Arpeggio Rate in Ticks
                dc.b    $00                         
                

               ;-------------------------- 'VIBRATO' Effect Values -----------------------
               ; The vibrato is a pitch modulation effect.
               ;--------------------------------------------------------------------------
                ; Name: paramModulationLevel           Offset 0x34
                ; Parameter - The amount of modulation applied by the effect
                dc.b    $00                     
                
                ; Name: paramModulationSpeed           Offset 0x35
                ; Parameter - The speed/rate of the modulation effect
                dc.b    $00                        
                
                ; Name: paramModulationDelayStart      Offset 0x36
                ; Parameter - Delay the start of the modulation effect in ticks
                dc.b    $00                     
                
                ; Name: modulationDelayStartTicks      Offset 0x37
                ; Working Value: initialised as a copy of modulatioDelayStart
                dc.b    $00                     
                
                ; Name: modulationSpeedTicks_x2        Offset 0x38
                ; Working Value: initialised as modulationSpeed x 2 
                dc.b    $00                          
                
                ; Name: modulationSpeedTicks           Offset 0x39
                ; Working Value: Initialised as modulationSpeed
                dc.b    $00                          
                
                ; Name: modulationAmountPerTick        Offset 0x3a
                ; Working Value: Initialised as modulationLevel / modulationSpeed
                dc.w    $0000                        
                

               ;------------------------ 'INSTRUMENT' Values ------------------------
               ; Details of the current Instrument/Sample being played
               ;---------------------------------------------------------------------
                ; Name: instrumentTuningAmount         Offset 0x3c
                ; Current Sample's signed tuning value. Number if Intervals to retune the sample by.
                dc.w    $0000                                
                
                ; Name: ptrInstrumentSampleStart       Offset 0x3e
                ; Pointer to the start of the Instrument's Sample Data
                dc.l    $00000000                    
                
                ; Name: instrumentSampleLength         Offset 0x42
                ; Length of the Sample to play (before repeat if any)
                dc.w    $0000                                    
                
                ; Name: ptrInstrumentSampleRepeat      Offset 0x44
                ; Pointer to the instrument's Repeat Sample Data
                dc.l    $00000000                       
                
                ; Name: instrumentRepeatLength         Offset 0x48
                ; Length of the Instrument's Repeat Sample Data
                dc.w    $0000                                    
                
               ;------------------ CURRENT PLAYING NOTE VALUES ----------------------
               ; Here are the working values for the currently playing note.
               ;---------------------------------------------------------------------
                ; Name: notePeriodValue                Offset 0x42
                ; Actual Current Note Period Value
                dc.w    $0000                              

                ; Name: noteVolume                     Offset 0x4c
                ; Current Note Volume
                dc.w    $0000                         
                
                ; Name: unreferenced_02                Offset 0x4e
                ; Unused Unreferenced Value
                dc.b    $00                          
                
                ; Name: transposedNoteIndex            Offset 0x4f
                ; Transposed Note Value as an index into the note period table.
                dc.b    $00                                      
                
                ; Name: transposedLeadInNoteIndex      Offset 0x50
                ; Transposed Note Value as an index into the note period table. (with Leadin modification if any)
                dc.b    $00                                        
                
                ; Name: paramPairedNoteDurationTicks   Offset 0x51
                ; Parameter - Paired Notes Effect 0x84 - Additional Note Duration
                dc.b    $00                                         
                
                ; Name: currentNoteTicks               Offset 0x52
                ; The current 'tick' count (VBlank Count) of the Current Playing Note.
                dc.w    $0000                                    
                
                ; Name: ChannelDMA
                ; Channel DMA bit - Power of 2 Value (1,2,4,8 for each channel)
                dc.w    $0004           ; Value not initialised by the Driver                          



               ; ----------------------- CHANEL 03 - STATUS -----------------------
               ; This data structure manages the Audio Channel 03 status values.
               ; - It tracks the current sound/song position,
               ; - It holds repeat and looping pointers of the sound/song
               ; - It holds repeat and looping details of the current track/pattern
               ; - It holds transposition values of the current track/pattern
               ; - It holds status of the current sample ADSR volume envelope
               ; - It holes status of the current sample Effect parameters and working values.
               ;    - Lead In Notes (needs more investigation)
               ;    - Portomento Effect (Pitch Slide)
               ;    - Arpeggio Effect (Warbly Chords, Pitch Step Effect)
               ;    - Vibrato Effect (Pitch Modulation)
               ; - It holds the status of the current sample.
               ;    - Repeat/Loop positions
               ;    - Fine pitch tuning (retuning of sample)
               ; - It holds the status of the current note played
               ;    - Note Length
               ;    - DMA Channel Active bits
               ;
channel_03_status                                        ; original address L00004126
                ;dc.w    $8084
               ; Channel Control Word 
               ; High Byte (0x8000 = music channel, 0x4000 = SFX channel) 
               ; Low Byte contains Active Effects 
                dc.w    $0000    
                
                ; Name: ptrPatternSequenceLoopStart    - Offset 0x02 - Address Pointer
                ; Pattern Sequences/song restart loop pattern ptr              
                dc.l    $00000000                      
                
                ; Name: ptrNextPatternSequencePosition - Offset 0x06 - Address Pointer
                ; Next Pattern to play after the current one
                dc.l    $00000000                       
                
                ; Name: ptrPatternDataLoop             - Offset 0x0a  - Address Pointer
                ; Loop within the current Pattern
                dc.l    $00000000 
                
                ; Name: ptrNextPatternDataPosition     - Offset 0xe   - Address Pointer
                ; Playing Pattern/Track data position
                dc.l    $00000000   
                
                ; Name: patternLoopCount               - Offset 0x12  - byte value
                ; Number of times to loop the current Pattern - 1 = Play Once (default)           
                dc.b    $00
                
                ; Name: patternTransposeValue          - Offset 0x13  - signed byte value
                ; Signed byte for key change value (+- index into the note period table)
                dc.b    $00 
                
                ; ------------------ 'ADSR' Parameter Values -------------------
                ; values to keep track of the ADSR sound envelope values.
                ;---------------------------------------------------------------
                ; Name: ptrADSREnvelope                - Offset 0x14  - Address Pointer
                ; Pointer to the current sound's ADSR Envelope data
                dc.l    $00000000
                
                ; Name: ptrCurrentADSREnvelope         - Offset 0x18  - Address Pointer
                ; Working Value: Current Pointer into the sound's ADSR Envelope
                dc.l    $00000000
                
                ; Name: adsrRateOfChangeTicks          - Offset 0x1c  - byte value
                ; Parameter - Rate of Change Ticks for the current 'ADSR' phase
                dc.b    $00
                
                ; Name: adsrCurrentRateOfChangeTicks   - Offset 0x1d  - byte value
                ; Working Value - Rate of change for the current ADSR 'phase'
                dc.b    $00
                
                ; Name: adsrEnvelopeDelayTicks         - Offset 0x1e  -  word value
                ; Ticks to Delay ADSR Envelope Processing
                dc.w    $0000
                
                ; Name: adsrVolumeRateOfChange         - Offset 0x20  - signed byte value
                ; The amount the Volume Changes per Rate of Change
                dc.b    $00
                ; -------- END OF SOUND ADSR VALUES --------

                ; --------------- SOUND 'LEAD-IN' Effect Values -----------------
                ; This effect doubles the current note played, 
                ; not happy with my description of this - need to review further
                ; ---------------------------------------------------------------
                ; Name: paramLeadInNoteOfffset         - Offset 0x21  - signed byte
                ; Parameter - Signed Byte for lead-in note Pitch Offest
                dc.b    $00
                
                ; Name: paramLeadInNoteDurationTicks   - Offset 0x22  - byte value
                ; Parameter - Duration of the lead-in note in Ticks
                dc.b    $00
                
                ; Name: leadInNoteCurrentTicks         - Offset 0x23  - byte value
                ; Working Value: Leadin Note Ticks Value
                dc.b    $00           
                ; -------- End of 'LEAD-IN' Effect Values

                ; ---------------- 'PORTOMENTO' Effect Values -----------------
                ; This effect enables a note's pitch to slide into the next
                ;--------------------------------------------------------------
                ; Name: paramPortomentoStartOffset     - Offset 0x24
                ; Parameter - Signed Pitch Offset of the Next Pattern Note. (Start pitch of the Portomento)
                dc.b    $00                             
                ; Name: paramPortomentoLengthTicks     - Offest 0x25
                ; Parameter - The length of the Portomento Slide in Ticks
                dc.b    $00                             
                ; Name: portomentoAmountPerTick        - Offset 0x26
                ; The rate of portomento per tick
                dc.b    $00                             
                ; --------- End of 'PORTOMENTO' Effect Values ---------

                ; Unreferenced byte value (maybe a pad byte for next ptr)
                dc.b    $00                            ; Offset 0x27
                
                ; ------------------'ARPEGGIO' Effect Values ---------------------
                ; This effect is used to give a single channel the warbly chords
                ; effect, or when slowed down, plays the individual notes of
                ; a chord at fixed intervals repeated in sequence.
                ;-----------------------------------------------------------------
                ; Name: ptrArpeggioTable               Offset 0x28
                ; Data Start - Pointer into Arpeggio Table
                dc.l    $00000000 
                
                ; Name: ptrArpeggioCurrentTable        Offset 0x2c
                ; Working ptr into Arpeggio Table
                dc.l    $00000000                    
                
                ; Name: paramArpeggioTableLength       Offset 0x30
                ; Byte[1] of Arpeggio Table - Size of data in the Table (after initial 2 bytes)
                dc.b    $00                         
                
                ; Name: arpeggioTableLenCount          Offset 0x31
                ; The size of the Arpeggio Table in Bytes/Entries
                dc.b    $00                         
                
                ; Name: paramArpeggioSpeedTicks        Offset 0x32
                ; Byte[0] of Arpeggio Table - Arpeggion Speed/Rate in Ticks
                dc.b    $00                         
                
                ; Name: arpeggioRateTicks              Offset 0x33
                ; Woring Value: Arpeggio Rate in Ticks
                dc.b    $00                         
                

               ;-------------------------- 'VIBRATO' Effect Values -----------------------
               ; The vibrato is a pitch modulation effect.
               ;--------------------------------------------------------------------------
                ; Name: paramModulationLevel           Offset 0x34
                ; Parameter - The amount of modulation applied by the effect
                dc.b    $00                     
                
                ; Name: paramModulationSpeed           Offset 0x35
                ; Parameter - The speed/rate of the modulation effect
                dc.b    $00                        
                
                ; Name: paramModulationDelayStart      Offset 0x36
                ; Parameter - Delay the start of the modulation effect in ticks
                dc.b    $00                     
                
                ; Name: modulationDelayStartTicks      Offset 0x37
                ; Working Value: initialised as a copy of modulatioDelayStart
                dc.b    $00                     
                
                ; Name: modulationSpeedTicks_x2        Offset 0x38
                ; Working Value: initialised as modulationSpeed x 2 
                dc.b    $00                          
                
                ; Name: modulationSpeedTicks           Offset 0x39
                ; Working Value: Initialised as modulationSpeed
                dc.b    $00                          
                
                ; Name: modulationAmountPerTick        Offset 0x3a
                ; Working Value: Initialised as modulationLevel / modulationSpeed
                dc.w    $0000                        
                

               ;------------------------ 'INSTRUMENT' Values ------------------------
               ; Details of the current Instrument/Sample being played
               ;---------------------------------------------------------------------
                ; Name: instrumentTuningAmount         Offset 0x3c
                ; Current Sample's signed tuning value. Number if Intervals to retune the sample by.
                dc.w    $0000                                
                
                ; Name: ptrInstrumentSampleStart       Offset 0x3e
                ; Pointer to the start of the Instrument's Sample Data
                dc.l    $00000000                    
                
                ; Name: instrumentSampleLength         Offset 0x42
                ; Length of the Sample to play (before repeat if any)
                dc.w    $0000                                    
                
                ; Name: ptrInstrumentSampleRepeat      Offset 0x44
                ; Pointer to the instrument's Repeat Sample Data
                dc.l    $00000000                       
                
                ; Name: instrumentRepeatLength         Offset 0x48
                ; Length of the Instrument's Repeat Sample Data
                dc.w    $0000                                    
                
               ;------------------ CURRENT PLAYING NOTE VALUES ----------------------
               ; Here are the working values for the currently playing note.
               ;---------------------------------------------------------------------
                ; Name: notePeriodValue                Offset 0x42
                ; Actual Current Note Period Value
                dc.w    $0000                              

                ; Name: noteVolume                     Offset 0x4c
                ; Current Note Volume
                dc.w    $0000                         
                
                ; Name: unreferenced_02                Offset 0x4e
                ; Unused Unreferenced Value
                dc.b    $00                          
                
                ; Name: transposedNoteIndex            Offset 0x4f
                ; Transposed Note Value as an index into the note period table.
                dc.b    $00                                      
                
                ; Name: transposedLeadInNoteIndex      Offset 0x50
                ; Transposed Note Value as an index into the note period table. (with Leadin modification if any)
                dc.b    $00                                        
                
                ; Name: paramPairedNoteDurationTicks   Offset 0x51
                ; Parameter - Paired Notes Effect 0x84 - Additional Note Duration
                dc.b    $00                                         
                
                ; Name: currentNoteTicks               Offset 0x52
                ; The current 'tick' count (VBlank Count) of the Current Playing Note.
                dc.w    $0000                                    
                
                ; Name: ChannelDMA
                ; Channel DMA bit - Power of 2 Value (1,2,4,8 for each channel)
                dc.w    $0008           ; Value not initialised by the Driver                          



    ENDC

