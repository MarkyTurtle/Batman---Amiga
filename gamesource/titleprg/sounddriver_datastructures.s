

    IFND SOUND_DRIVER_DATASTRUCTURES_S
SOUND_DRIVER_DATASTRUCTURES_S  EQU 1

 
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
                dc.w    $0001      ; The only value not initialised by the Driver                          



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
                dc.w    $0002      ; The only value not initialised by the Driver                          


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
                dc.w    $0004      ; The only value not initialised by the Driver                          



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
                dc.w    $0008      ; The only value not initialised by the Driver                          



    ENDC

