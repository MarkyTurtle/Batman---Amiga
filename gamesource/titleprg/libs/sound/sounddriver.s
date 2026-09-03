
     IFND      SOUND_DRIVER_S
SOUND_DRIVER_S      EQU 1

     include "sounddriver.i"


               ;****************************************************************************************************************
               ;****************************************************************************************************************
               ;****************************************************************************************************************
               ;
               ;
               ;               MUSIC/SOUND Player Routines
               ;
               ;
               ;  GENERAL-INFO
               ;   - Songs/Tunes - Sounds that use the 3 Audio Channels 00,01,02
               ;   - Sound Numbers 1,2,3
               ;   - ID 01 = Title Music
               ;   - ID 02 = Joker Laugh
               ;   - ID 03 = Batman Game Completion
               ;
               ; SOUND/SONG TYPES
               ;   There are two main distinctions made between the types of sounds played by
               ;   this driver:
               ;         1) Songs/Tunes
               ;         2) Sound Effects/SFX
               ;
               ;    1) Songs/Tunes
               ;         These are typcially restricted to the use of the first 3 audio channels,
               ;         Audio Channels 00, 01 and 02
               ;
               ;    2) Sound Effects/SFX
               ;         These are typically assigned to the 4th Audio Channel (Channel 03)     
               ;         SFX have priority, so high soundIds have a higher sound playing priority.
               ;              i.e. a higher sound id will interrupt a currently playing lower sound id.
               ;
               ; SOUND DRIVER SOUND/SONG STATUS DATA STRUCTURES
               ;    Each sound channel's current status is held in it's own comprehensive data structure
               ;         1) channel_00_status - Audio Channel 00 Song status
               ;         2) channel_01_status - Audio Channel 01 Song Status
               ;         3) channel_02_status - Audio Channel 02 Song Status
               ;         4) channel_03_status - Audio Chhanel 03 SFX Status
               ;    
               ;
               ; INSTRUMENT DATA STRUCTURES
               ;
               ; --------------------------------
               ;  SOUND/SONG DATA STRUCURE INFO
               ; --------------------------------
               ;    Each Sound/Song is defined using a number of data tables.
               ;    The data tables contain lots of relative byte offsets to refer to further data structures.
               ;    The relative byte offsets can be signed byte offests:
               ;         I.E. the related table can exist before of after the current table in memory.
               ;
               ;    sound_table
               ;    ------------------
               ;    This table contains a record of 4 words for each sound/song. 
               ;    Each word is a signed byte offset to the initialisation data for each of the 4 audio channels.
               ;    A Value $0000 indicates that the audio channel is not used by the sound/song.
               ;
               ;    sound_table
               ;         Sound01:
               ;              dc.w $0000     ; h/w audio channel 00, byte offset to track pattern list 
               ;              dc.w $0000     ; h/w audio channel 01, byte offset to track pattern list
               ;              dc.w $0000     ; h/w audio channel 02, byte offset to track pattern list
               ;              dc.w $0000     ; h/w audio channel 03, byte offset to track parrern list
               ;         Sound02:
               ;              dc.w $0000     ; h/w audio channel 00, byte offset to track pattern list
               ;              dc.w $0000     ; h/w audio channel 01, byte offset to track pattern list
               ;              dc.w $0000     ; h/w audio channel 02, byte offset to track pattern list
               ;              dc.w $0000     ; h/w audio channel 03, byte offset to track pattern list
               ;
               ;    track pattern list
               ;    ------------------
               ;    The byte offsets in the 'sound_table' point to the start of a track pattern list.
               ;    The track pattern list is a list of 'pattern index bytes' to play in sequence for the audio track.
               ;    It can also contain command bytes ($80+) as follows:
               ;         - track commands:
               ;              - 0x80 = End or Loop Current Pattern List (per audio channel) 	
               ;              - 0x81 = Set Pattrtern List Loop Back Location (to current position)
               ;              - 0x82 = Transpose the next pattern by the following signed byte value.
               ;              - 0x83 = Repeat the next pattern by the count in the following byte value.
               ;
               ;    Every track sequence of bytes ends with $80 to 'end or loop the track'
               ;    If there is no loop then the track ends in silence.
               ;
               ;
               ;    pattern data
               ;    ------------
               ;    Pattern data typically consists of a list of note and duration bytes.
               ;    They also conatin command bytes which are bytes in the range ($80-$90)
               ;    Command Bytes take between 0 and 3 parameters.
               ;    So, Pattern commands can range in lenght between 0 and 4 bytes.
               ;
               ;    The 'sound_pattern_table' contains a list of byte offsets to the start of each pattern.
               ;    The pattern indexes from the audio track are used with this table to find the offset for the
               ;    pattern data to play.
               ;
               ;
               ;    sound_pattern_table
               ;    --------------------------
               ;    The table contains a 16bit byte offset to each pattern sequence.
               ;    An example of how the entry offset values are calculated are shown below:
               ;
               ;    sound_pattern_table
               ;    .pattern_00_offset  dc.w (sound_pattern_00-.pattern_00_offset)        ; Pattern 00 - Sound ID 00 - Title Music
               ;    .pattern_01_offset  dc.w (sound_pattern_01-.pattern_01_offset)        ; Pattern 01 - Sound ID 00 - Title Music
               ;    .pattern_02_offset  dc.w (sound_pattern_02-.pattern_02_offset)        ; Pattern 02 - Sound ID 00 - Title Music
               ;
               ;
               ;****************************************************************************************************************
               ;****************************************************************************************************************
               ;****************************************************************************************************************




               ;----------------------------- Music Player Jump Table ------------------------------
               ; Public interface into the Sound Driver system.
               ; Here follows a table of jumps for usding the sound driver code. 


               ;----------------------------------------------------------------
               ;    PUBLIC void SoundDriver_Initialise(a0.l = MUSIC_MODULE_DATA)
               ; 
               ;         IN: A0.l = MUSIC_MODULE_DATA - Address of the music module.
               ;
               ;    Original Address $00004000
               ;
               ;  - Set up the Sound Player for use with the Sound Data.
               ; 
SoundDriver_Initialise
               bra.w     _do_sounddriver_initialise


               ;----------------------------------------------------------------
               ;    PUBLIC void SoundDriver_Stop_All(void)
               ;
               ;    Original Address $00004004
               ;
               ;     - Initialise All Audio Channels
               ;     - Set Audio Volume to 0
               ;
SoundDriver_Stop_All                
               bra.w   _do_sounddriver_stop_all


               ;----------------------------------------------------------------
               ; Sound Driver - Stop a Sound from playing
               ;
               ;    PUBLIC void SoundDriver_StopSound(d0.w = soundId)
               ;
               ;         IN: D0.w = soundId - Sound ID Number (1 - 3)
               ;
               ;    Original Address $00004008
               ;
               ; Stop Playing a Tune or SFX
               ;  - Silences Audio Channels used by the Sound ID Number
               ; 
SoundDriver_StopSound            
               bra.w   _do_sounddriver_stop_sound
               ; duplicate of above (unused)
               ; original address $0000400c
SoundDriver_StopSound_2                         
               bra.w   _do_sounddriver_stop_sound 


               ;-----------------------------------------------------------------
               ; Sound Driver - Initialise SONG/TUNE (a sound using 3 channels)
               ;
               ;    PUBLIC void SoundDriver_Play_Song(d0.w = soundId)
               ;         IN:- D0.b - soundId = The SONG/TUNE id to initialise for playing.
               ;  
               ;    Original Address $00004010
               ; Initialises a SONG/TUNE for playing diring the VBlank Update
               ; 
SoundDriver_Play_Song            
               bra.w   _do_sounddriver_play_song   


               ;-----------------------------------------------------------------
               ; Sound Driver - Initialise SFX (a sound using 1 channel 03)
               ;
               ;    PUBLIC void SoundDriver_PlaySFX(d0.w = soundId)
               ;         IN: D0.b = soundId - SFX ID Number
               ; 
               ;    Original Address $00004014
               ;
               ; Initialise a SFX identified by the SFX ID number for playing.
               ;  - If another SFX is already playing and is a higher ID number 
               ;    then the current SFX is not interrupted.
               ; 
SoundDriver_PlaySFX       
               bra.w   _do_sounddriver_play_sfx


               ;-----------------------------------------------------------------
               ; Sound Driver - Vertical Blank Update
               ;
               ;    PUBLIC void SoundDriver_VBlankUpdate(void)
               ;
               ;    Original Address $00004018
               ;
               ; Call at regular time interval e.g during Vertical Blank to Play 
               ; the current SFX/Music
               ; 
SoundDriver_VBlankUpdate   
               bra.w   _do_sounddriver_vblank_update 




               ;---------------------------------------------------------------------
               ; Initialise Sound Driver
               ;
               ;    PRIVATE void _do_sounddriver_initialise(a0.l = MUSIC_MODULE_DATA)
               ; 
               ;         IN: A0.l = MUSIC_MODULE_DATA - Address of the music module.
               ;
               ;  - Original Address $00004180
               ;  - No Parameters Required
               ;  - Processes IFF Samples and populates the Instrument Table with 
               ;    Sample Addresses, Repeat Addresses and associated lengths
               ;  - Also sets the Instrument Volumes.
               ;
               ; Notes
               ; Can be modified to remove hardcoded reference to 'iff_sample_data_table'
               ;
               ; IN a0.l = MUSIC_MODULE_DATA ptr
_do_sounddriver_initialise

               ; added code for mudularisation of music data
               lea       module_table,a1
               ; calc iff sample data table offset
               move.l    (a0)+,d0
               lea       -4(a0,d0.l),a3
               move.l    a3,(a1)+
               ; calc sound table offset
               move.l    (a0)+,d0
               lea       -4(a0,d0.l),a3
               move.l    a3,(a1)+
               ; calc sound pattern table offset
               move.l    (a0)+,d0
               lea       -4(a0,d0.l),a3
               move.l    a3,(a1)+
               ; calc arpeggio table offset
               move.l    (a0)+,d0
               lea       -4(a0,d0.l),a3
               move.l    a3,(a1)+
               ; calc adsr envelope table offset
               move.l    (a0)+,d0
               lea       -4(a0,d0.l),a3
               move.l    a3,(a1)+
               ; set max number of sounds
               move.w    (a0),(a1)

               lea       module_table,a0
               move.l    mod_iff_samples(a0),a0                                                                          
               ;lea.l   iff_sample_data_table,a0     

               lea.l     instrument_data_table+$10,a1        ; skip instrument 0          
               bsr.w     _initialise_instrument_data_table    
               bra.w     _do_sounddriver_stop_all             


               ;---------------------------------------------------------------------
               ; Sound Driver - Stop All
               ;
               ;    PRIVATE void _do_sounddriver_stop_all(void)
               ;
               ;    - Original Address $00004194 
               ;    - No Parameters or return values.
               ;    - Resets the TUNE and SFX ID numbers to 0.
               ;    - Initialised all 4 Audio Channels
               ;    - Sets the Volume of all 4 Audio Channels to 0.
               ;
_do_sounddriver_stop_all          
               ; save registers used                  
               movem.l d0/a0-a1,-(a7)

               ; Clear soundIds
               move.b  #$00,sounddriver_song_number  
               move.b  #$00,sounddriver_sfx_number   

               ; reset volume and control bits
               lea.l   channel_00_status,a0      
               lea.l   CUSTOM+AUD0VOL,a1         
               bsr.b   _initialise_audio_channel    
               bsr.b   _initialise_audio_channel    
               bsr.b   _initialise_audio_channel    
               bsr.b   _initialise_audio_channel    
               move.w  #$0000,sounddriver_ctrl_bits

               ; restore used registers
               movem.l (a7)+,d0/a0-a1
               rts    


               ;------------------------ initialise audio channel --------------------
               ; Silence Audio Channel and update Channel_xx_Status
               ;
               ;    PRIVATE void _initialise_audio_channel(
               ;              a0.l = channelStatusPtr,
               ;              a1.l = hwRegAudioXVol)
               ;
               ;    IN: A0 = channelStatusPtr - Address of 'Channel_xx_Status' data structure.
               ;    IN: A1 = hwRegAudioXVol   - Address of AUDxVOL custom register
               ;
_initialise_audio_channel
               move.w  #$0000,chan_ActiveCommandBits(a0)  
               move.w  #$0001,chan_notePeriodValue(a0)    
               move.w  #$0000,chan_noteVolume(a0)         
               move.w  #$0000,(a1)                          ; Volume hardware custom reg = 0
               
               ; update ptrs for next audio channel
               adda.w  #CHANNEL_XX_STATUS_SIZE,a0
               adda.w  #$0010,a1                            ; next aud channel hardware reg
               rts


               ;----------------------------- do stop audio -----------------------------
               ; Stop a TUNE or SFX from Playing
               ;  
               ;    PRIVATE void _do_sounddriver_stop_sound(d0.w = soundId)
               ;
               ;    - IN: D0.w = soundId - Requested Sound number 
               ;
               ;    - Original Address $000041e0
               ;    - Check the requested Sound in the range 1 - 3
               ;    - The routine initialises any in-use audio channels used by the 
               ;         Sound by switching them off.
               ;
               ; Notes:
               ;    Removed hardcoded reference to 'sound_table'
               ;
_do_sounddriver_stop_sound               
               ; Save used processor registers
               movem.l d0/d7/a0-a2,-(a7)

               ; Check soundId in allowed range,
               ; If out of range then silence all audio chanels
               ; If in range then only silence channels used by the soundId
               subq.w  #SOUND_MIN_SOUND_ID,d0
               bmi.b   .silence_all_audio  
               
               lea       module_table,a0
               cmp.w     mod_number_sounds(a0),d0   
               ;cmp.w   #SOUND_MAX_SOUND_ID,d0
               bcs.b   .silence_inuse_channels
.silence_all_audio
               bsr.b   _do_sounddriver_stop_all
               bra.b   .exit                   

               ; silence only channels in use by the
               ; sound identified by soundId
.silence_inuse_channels
               ; get sound by soundId in a0
               lea       module_table,a2
               move.l    mod_sound_table(a2),a2
               ;lea.l   sound_table,a2                       **** REFACTOR OUT HARDCODED REFERENCE TO SOUND_TABLE ****         
               
               asl.w   #$03,d0
               adda.w  d0,a2
               lea.l   channel_00_status,a0  

               ; store audio channel 00 hardware volume register in a1
               lea.l   CUSTOM+AUD0VOL,a1 

               ; loop an reset channels in use
               moveq   #HW_AUDIO_CHANNELS-1,d7
.audio_channel_loop
                    ; test if sound channel in use
                    tst.w   (a2)+                         
                    bne.b   .silence_audio_channel        
                    ; update ptrs for next audio channel
                    adda.w  #CHANNEL_XX_STATUS_SIZE,a0
                    adda.w  #$0010,a1                        ; increment to next AUDxVOL register
                    bra.b   .continue              
.silence_audio_channel
                    bsr.b   _initialise_audio_channel
.continue
               dbf.w   d7,.audio_channel_loop    
.exit          
               ; restore used processor registers
               movem.l (a7)+,d0/d7/a0-a2
               rts


               ;-------------------------------------------------------------------------
               ; Play SFX identified by the SFX ID number
               ; Sound Effects are played on audio channel 03
               ; Sound Effects are played based on priority
               ;
               ;    PRIVATE void _do_sounddriver_play_sfx(d0.w = soundId)
               ;
               ;         IN: D0.b = soundId - SFX ID Number
               ;
               ;    - Original Address $00004222
               ;    - If another SFX is already playing and is a higher ID number then
               ;      the current SFX is not interrupted.
               ;
_do_sounddriver_play_sfx        
               ; test if SFX audio channel 03 already in use
               tst.w   channel_03_status              
               beq.b   .start_sfx             

               ; SFX channel is in use.
               ; check sound priority (exit if current sound is higher priority)
               cmp.b   sounddriver_sfx_number,d0    
               bcs.b   .exit                        

.start_sfx     ; start playing SFX (uses)
               movem.l   d0/d7/a0-a2,-(a7)
               move.w    #$4000,d1                     ; set sfx active bit            
               move.b    d0,sounddriver_sfx_number
               bra.b     _do_init_current_sound    
               ; do_init_current_sound - pops values back from the stack
               ; used by both song//tunes and sfx for initialising the audio

.exit          ; exit without starting new sfx                                             
               rts



                ;----------------------------------------------------------------------
                ; Play a song/tune identified by soundId passed in d0.w
                ;
                ;   PRIVATE void _do_sounddriver_play_song(d0.w = soundId)
                ;
                ;        IN: D0.l = soundId - song/tune to play
                ;                            - 0 = play nothing/stop
                ;
                ;   - Original Address $0000423e
                ;
_do_sounddriver_play_song        
                movem.l d0/d7/a0-a2,-(a7)
                move.w  #$8000,d1                      ; set song/tune flag
                move.b  d0,sounddriver_song_number   
                ; falls through to '_do_init_current_sound'
                ; used by both song//tunes and sfx for initialising the audio


               ;--------------------------------------------------------------------
               ; Initialise the audio of a new Song/Tune or SFX
               ;
               ;    PRIVATE void _do_init_current_sound(void)
               ;
               ;    Original Address $0000424a
               ;
               ; Notes:
               ; Initialisation routine could probably be modified to ignore
               ; processing the end_or_loop command, so that it just disabes the audio channel
               ; Also modified to remove hardcoded reference to 'sound_pattern_table' and 'sound_table'
               ;
_do_init_current_sound
               clr.w   play_tick_counter 

               ; check soundId is in acceptable range
               ; if not, then stop all sound 
.validate_song_number
               subq.w  #SOUND_MIN_SOUND_ID,d0
               bmi.b   .stop_playing 

               lea       module_table,a0
               cmp.w     mod_number_sounds(a0),d0
               ;cmp.w   #SOUND_MAX_SOUND_ID,d0 
               bcs.b   .initialise_sound

               ; stop all sound and exit
.stop_playing  bsr.w   _do_sounddriver_stop_all 
               bra.w   .exit

               ; soundId is ok, continue to initialise
               ; get 'sound_table' entry address
.initialise_sound  
               lea       module_table,a0
               move.l    mod_sound_table(a0),a0
               ;lea.l   sound_table,a0                       *** REFATOR OUT HARDCODED REFERENCE TO SOUND_TABLE ***
               
               asl.w   #$03,d0
               adda.w  d0,a0 

               ; initialise each audio channel.
               ; set up track data pointers for each h/w channel
               ; execute track commands
               ; initialise first pattern to play
.init_audio_channels
               lea.l   channel_00_status,a1   
               moveq   #HW_AUDIO_CHANNELS-1,d7                


               ; Outer loop initialising each audio channel
.init_audio_channel_loop                   
                    ; get track data byte offset - d0.w
                    move.w  (a0)+,d0 
     
                    ; test if channel is in use for this sound
                    beq.b   .skip_to_next_channel     

                    ; track is used, initialise it.
                    ; get audio track data address pointer - a2
                    lea.l   -2(a0,d0.w),a2 

                    ; init 'channel_xx_status'
                    moveq   #$00,d0
                    move.w  d0,chan_noteVolume(a1)    
                    move.l  d0,chan_ptrTrackSequenceLoopStart(a1) 
                    move.l  d0,chan_ptrPatternDataLoop(a1)
                    move.b  d0,chan_patternTransposeValue(a1)
                    move.b  #$01,chan_patternLoopCount(a1)
                    move.w  d1,chan_ActiveCommandBits(a1)

                         ; Inner Loop: process track data bytes
                         ; process any track commands in a loop
                         ; set up initial pattern to play and exit.
.track_command_loop
                         ; get track data byte
                         move.b  (a2)+,d0   

                         ; test for pattern id, configure and exit
                         bpl.b   .set_initial_pattern

                         ; test for command 0x80 - end or loop pattern
.chk_cmd_end_or_loop     sub.b   #$80,d0
                         bne.b   .chk_cmd_set_loop_start

                              ; byte is 0x80 - end or loop pattern
                              ; command is ignored or channel is diabled
.cmd_loop_or_end              movea.l chan_ptrTrackSequenceLoopStart(a1),a2

                              ; check if loop ptr is set (ignore command)
                              cmpa.w  #$0000,a2
                              bne.b   .track_command_loop        ; ignore and continue processing track bytes

                              ; disable audio channel
                              clr.w   chan_ActiveCommandBits(a1)
                              bra.b   .skip_to_next_channel      ; continue to initialise next channel
                              ; ---------------------------------

                         ; test for command 0x81 - set track loop start ptr
.chk_cmd_set_loop_start  subq.b  #$01,d0
                         bne.b   .chk_cmd_transpose_pattern

                              ; byte is 0x81 - set track loop start position
                              ; continue processing track command loop
.cmd_set_loop_start           move.l  a2,chan_ptrTrackSequenceLoopStart(a1)
                              bra.b   .track_command_loop
                              ; ---------------------------------

                         ; test for command 0x82 - transpose pattern pitch
.chk_cmd_transpose_pattern
                         subq.b  #$01,d0
                         bne.b   .chk_cmd_repeat_pattern
                              ; byte is 0x82 - set pattern transpose pitch value
                              move.b  (a2)+,chan_patternTransposeValue(a1)
                              bra.b   .track_command_loop  
                              ; -----------------------------------

                         ; test for command 0x83 - repeat pattern
.chk_cmd_repeat_pattern  subq.b  #$01,d0
                         bne.b   .track_command_loop
                              ; byte is 0x83 - repeat next pattern 
                              move.b  (a2)+,chan_patternLoopCount(a1)
                              bra.b   .track_command_loop
                              ; -------------------------------------

                    ; set channel initial pattern values and move on to next channel initialisation
                    ; d0.b = initial track pattern index
                    ; a1.l = channel_xx_status
                    ; a2.l = track sequence ptr
.set_initial_pattern
                    ; store current track data position ptr
                     move.l  a2,chan_ptrNextTrackSequencePosition(a1)

                    ; get pattern data using patternIndex (d0.b) and sound_pattern_table
                    lea.l     module_table,a2
                    move.l    mod_pattern_table(a2),a2
                    ;lea.l   sound_pattern_table,a2                         *** REFATOR OUT HARDCODED REFERENCE TO SOUND_PATTERN_TABLE ***
                    ext.w   d0
                    add.w   d0,d0
                    adda.w  d0,a2

                    ; get and store pattern data address
                    adda.w  (a2),a2
                    move.l  a2,chan_ptrNextPatternDataPosition(a1)

                    ; set initial note played duration to 1 tick
                    move.w  #$0001,chan_currentNoteTicks(a1)

                    ; set up pointers for initialising next audio channel
.skip_to_next_channel
               lea.l   CHANNEL_XX_STATUS_SIZE(a1),a1
               dbf.w   d7,.init_audio_channel_loop

               ; set song/tune or sfx active bit
               or.w    d1,sounddriver_ctrl_bits 

               ; restore save registers and exit
.exit          movem.l (a7)+,d0/d7/a0-a2
               rts





               ;---------------------------------------------------------------------
               ; Sound Player - VBlank Update
               ;
               ;    PRIVATE void _do_sounddriver_vblank_update(void)
               ;
               ;    Original Address $000042f6
               ;
               ;   - This routine should be called during the VBlank to play the
               ;     currently active Song/Tunes and SFX.
               ;
_do_sounddriver_vblank_update 
               lea.l   CUSTOM,a6
                
               ; mid note frequency table (-48 to + 44)
               lea.l   note_period_table+48,a5 

               ; clear audio_dma 
               ; This function accumlates which channels are active
               clr.w   audio_dma 

               ; test if a sound is being played
               ; if not, then jump directly to setting audio h/w registers
               tst.w   sounddriver_ctrl_bits
               beq.b   .update_audio_hardware

.do_sound_processing
               ; else, advance the sound tick counter
               ; and process each channel/track
               addq.w  #$01,play_tick_counter
               clr.w   sounddriver_ctrl_bits  

               ; process channel 00
.process_audio_channel_00             
               lea.l   channel_00_status,a4
               move.w  chan_ActiveCommandBits(a4),d7
               beq.b   .process_audio_channel_01

               ; process pattern commands/effects/notes
               bsr.b   _do_pattern_processing
               move.w  d7,chan_ActiveCommandBits(a4)
               or.w    d7,sounddriver_ctrl_bits

               ; process channel 01
.process_audio_channel_01
               lea.l   channel_01_status,a4            
               move.w  chan_ActiveCommandBits(a4),d7
               beq.b   .process_audio_channel_02

               ; process pattern commands/effects/notes
               bsr.b   _do_pattern_processing         
               move.w  d7,chan_ActiveCommandBits(a4)
               or.w    d7,sounddriver_ctrl_bits

               ; proocess channel 02
.process_audio_channel_02                
               lea.l   channel_02_status,a4
               move.w  chan_ActiveCommandBits(a4),d7
               beq.b   .process_audio_channel_03

               ; process pattern commands/effects/notes
               bsr.b   _do_pattern_processing
               move.w  d7,chan_ActiveCommandBits(a4)
               or.w    d7,sounddriver_ctrl_bits

               ; process channel 03
.process_audio_channel_03  
               lea.l   channel_03_status,a4
               move.w  chan_ActiveCommandBits(a4),d7
               beq.b   .update_audio_hardware

               ; process pattern commands/effects/notes
               bsr.b   _do_pattern_processing
               move.w  d7,chan_ActiveCommandBits(a4)
               or.w    d7,sounddriver_ctrl_bits

.update_audio_hardware 
               ; clear DMA in use bits, preserve song/sfx active bits
               and.w   #$c000,sounddriver_ctrl_bits
               ; update h/w audio registers
               bsr.w   update_audio_custom_registers
               rts



               ;-------------------------------------------------------------------
               ; Do Pattern Processing
               ;
               ;    PRIVATE void _do_pattern_processing(
               ;                   a4.l = channel_xx_status
               ;                   a5.l = note_period_table
               ;                   a6.l = CUSTOM
               ;                   d7.w = ActiveCommandBits
               ;                        )
               ;
               ;    Original Address $00004360
               ;
               ;    This routine processes the current Pattern Data for the Audio Channel.
               ;       - It decrements a tick value (tempo) and if not 0 then continues to process
               ;         existing, active sound commands.
               ;       - When the 'tick' value = 0, it reads a new byte from the pattern data.
               ; 	- If the pattern byte is a new command byte, then it handles it.
               ; 	- else, it treats the byte as a new note trigger (i think).
               ; 
               ;    Do Active Audio Channel Commannds
               ;         - a6.l = CUSTOMBASE $dff000
               ;         - a5.l = Note Period Table - Mid Point
               ;         - a4.l = Channel (xx) Status - Structure
               ;         - d7.w = Active Command Bits
               ; 
               ; Pattern Commands are values 0x80 and above.
_do_pattern_processing
               tst.w   chan_currentNoteTicks(a4)                       ; test 82(a4) - command 8 in progress?
               beq.w   _do_process_active_pattern_commands                ; if 82(82) == 0 then jmp L000046b2

               subq.w  #$01,chan_currentNoteTicks(a4)                  ; decrement 82(a4)
               bne.w   _do_process_active_pattern_commands                ; if > 0 then  jmp L000046b2

               ; channel ticks have just decremented to 0
               ; so, process pattern data (next command, notes to play)
               ; a4 = pattern data position 
.process_pattern_data
               ; a3 = get current pattern data pointer
               movea.l chan_ptrNextPatternDataPosition(a4),a3                   
               
               ; clear channel disabled bit
               bclr.l  #PTNCMDBITS_CHANNEL_DISABLED,d7

pattern_command_loop
                    ; get next pattern data byte
                    move.b  (a3)+,d0

                    ; if byte is not a command then it's a new note to play
                    bpl.w   _trigger_playing_new_note

                    ; else, process command byte
                    ; clear any previous portomento effect
                    bclr.l  #PTNCMDBITS_PORTOMENTO,d7

                    ; test command in range $80-$a0 (0-31)
                    cmp.b   #$a0,d0

                    ; if invald command then ignore it
                    bcc.b   pattern_command_loop

                    ; else, use command as index to command jmp table
                    lea.l   pattern_cmd_jump_table(pc),a0

                    ; clamp command to range (0-31)
                    sub.b   #$80,d0

                    ; get jump table entry
                    ext.w   d0
                    add.w   d0,d0 
                    adda.w  d0,a0

                    ; get command jmp address
                    move.w  (a0),d0
                    beq.b   pattern_command_loop

                    ; exeute command address
                    jmp     $00(a0,d0.w)
                    ; NB: the majority of commands return to 'pattern_command_loop'
                    ;    - _pattern_cmd_87_Pause jmps '_initialise_note_duration' 
                    ;

                ;---------------- music command jump table (max 32 commands) ------------------
pattern_cmd_jump_table                                    ; original address $0000439e
               ; command 0x80 - End Pattern or Loop inside Pattern
               dc.w _pattern_cmd_80_EndOrLoop-(pattern_cmd_jump_table+0)        ; offset - $0040 ; 439E + 40 = 43DE
               dc.w _pattern_cmd_81_SetInPatternLoop-(pattern_cmd_jump_table+2)      ; offset - $00ba ; 43A0 + BA = 445A 
               dc.w _pattern_cmd_82_NOP-(pattern_cmd_jump_table+4)      ; offset - $00c0 ; 43A2 + C0 = 4462      
               dc.w _pattern_cmd_83_NOP-(pattern_cmd_jump_table+6)      ; offset - $00c2 ; 43A4 + C2 = 4466
               dc.w _pattern_cmd_84_Paired_Notes-(pattern_cmd_jump_table+8)      ; offset - $00c4 ; 43A6 + C4 = 446A     
               dc.w _pattern_cmd_85_Paired_Notes_Stop-(pattern_cmd_jump_table+10)     ; offset - $00ce ; 43a8 + CE = 4476       
               dc.w _pattern_cmd_86_Extend_Note_Ticks-(pattern_cmd_jump_table+12)     ; offset - $00d4 ; 43aa + D4 = 447E
               dc.w _pattern_cmd_87_Pause-(pattern_cmd_jump_table+14)     ; offset - $00dc ; 43ac + DC = 4488        
               dc.w _pattern_cmd_88_Portomento-(pattern_cmd_jump_table+16)     ; offset - $00ea ; 43ae + ea = 4498
               dc.w _pattern_cmd_89_LeadIn_Notes-(pattern_cmd_jump_table+18)     ; offset - $00f8 ; 43b0 + f8 = 44A8
               dc.w _pattern_cmd_8a_LeadIn_Notes_Stop-(pattern_cmd_jump_table+20)     ; offset - $010a ; 43b2 + 10a = 44BC
               dc.w _pattern_cmd_8b_Modulation-(pattern_cmd_jump_table+22)     ; offset - $0140 ; 43b4 + 140 = 44F4
               dc.w _pattern_cmd_8c_Modulation_Stop-(pattern_cmd_jump_table+24)     ; offset - $0156 ; 43b6 + 156 = 450C
               dc.w _pattern_cmd_8d_Arpeggio-(pattern_cmd_jump_table+26)     ; offset - $010c ; 43b8 + 10c = 44C4
               dc.w _pattern_cmd_8e_Arpeggio_Stop-(pattern_cmd_jump_table+28)     ; offset - $0132 ; 43ba + 132 = 44EC
               dc.w _pattern_cmd_8f_Select_ADSR-(pattern_cmd_jump_table+30)     ; offset - $0158 ; 43bc + 158 = 4514
               dc.w _pattern_cmd_90_Select_Instrument-(pattern_cmd_jump_table+32)     ; offset - $016e ; 43be + 16e = 452c
               dc.w $0000
               dc.w $0000
               dc.w $0000
               dc.w $0000
               dc.w $0000
               dc.w $0000
               dc.w $0000
               dc.w $0000
               dc.w $0000
               dc.w $0000
               dc.w $0000
               dc.w $0000
               dc.w $0000
               dc.w $0000
               dc.w $0000


               ;----------------------------------------------------------------------------
               ; Pattern Command 0x80 - End or Loop Pattern
               ;
               ;    IN: d7.w = ActiveChannelBits
               ;    IN: a3.l = Pattern Data Pointer
               ;    IN: a4.l = Channel_xx_Status
               ;    IN: a5.l = Note Period Table
               ;    IN: a6.l = CUSTOM
               ;
               ;    Original Address $000043de
               ;
               ; Quite a complicated command.
               ;    1) First it checks if there is a loop with in the current pattern
               ;         If so, then it restored the pattern position to loop.
               ;
               ;    2) If there is no loop with the pattern then the pattern has ended
               ;         if so, then the command enters a track data command processing loop.
               ;         It runs through the track data from the current position,
               ;         executes any track data comands.
               ;         Finally sets the next pattern up for playing and,
               ;         Resumes exeution of the pattern_command_loop
               ;
               ; Notes
               ;    Refactored to remove hardcoded reference 'sound_pattern_table'
               ;
_pattern_cmd_80_EndOrLoop    
               ; do in-pattern loop processing
               ; update pattern data point with loop back address 
               movea.l   chan_ptrPatternDataLoop(a4),a3           
               ; if loop address is set, then return to pattern cmd loop
               cmpa.w    #$0000,a3 
               bne.b     pattern_command_loop  
               
               ; No in-pattern loop set
               ; get a3 = track data address
               ; get d0.b = current pattern id
               movea.l   chan_ptrNextTrackSequencePosition(a4),a3
               move.b    -$0001(a3),d0
               
               ; check if the pattern has a loop on it.
               ; subtract 1 from current pattern loop count
               ; if loop > 0 then select current pattern id again (d0.b)
               subq.b    #$01,chan_patternLoopCount(a4)
               bne.b     .init_next_pattern

               ; else, select next pattern to play from audio track data
.select_next_pattern
               ; loop count is 0 - select next pattern
               ; (re)set default loop count and clear transpose values
               move.b    #$01,chan_patternLoopCount(a4)
               move.b    #$00,chan_patternTransposeValue(a4)

               ; since it's a new pattern we need
               ; to process the current position in the track data
               ; and any track commands
               ; a3 = current track data position
.process_track_commands_loop                
               ; get next track data byte
               move.b    (a3)+,d0
               bpl.b     .init_next_pattern

               sub.b     #$80,d0
               bne.b     .chk_set_loop_start
                    ; command 0x80 - end or loop track
                    movea.l   chan_ptrTrackSequenceLoopStart(a4),a3
                    cmp.l     #$00000000,a3
                    bne.b     .process_track_commands_loop
                    move.w    #$0001,chan_notePeriodValue(a4)
                    move.w    #$0000,chan_noteVolume(a4)
                    moveq     #$00,d7
                    rts  

               ; check if command 0x81 - set track loop start
.chk_set_loop_start
               subq.b    #$01,d0
               bne.b     .chk_transpose_pattern
                    ; command 0x81 - set track loop start
                    move.l    a3,chan_ptrTrackSequenceLoopStart(a4)
                    bra.b     .process_track_commands_loop

               ; check if command 0x82 - transpose pattern
.chk_transpose_pattern
               subq.b    #$01,d0 
               bne.b     .chk_repeat_next_pattern
                    ; command 0x82 - transpose pattern
                    ; store transposition +- interval value
                    move.b    (a3)+,chan_patternTransposeValue(a4)
                    bra.b     .process_track_commands_loop

               ; check if command 0x83 - repeat next pattern
.chk_repeat_next_pattern
               subq.b    #$01,d0
               bne.b     .process_track_commands_loop
                    ; command 0x83 - repeat next pattern
                    move.b    (a3)+,chan_patternLoopCount(a4)
                    bra.b     .process_track_commands_loop


               ; set next pattern ptr and return to pattern cmd loop
               ; a3.l = track data current position
               ; d0.b = next patternId
.init_next_pattern
               ;store track data pointer
               move.l    a3,chan_ptrNextTrackSequencePosition(a4)
               
               ; get pattern data address from pattern table
               lea.l     module_table,a3
               move.l    mod_pattern_table(a3),a3
               ;lea.l   sound_pattern_table,a3                         *** REFATOR OUT HARDCODED REFERENCE TO SOUND_PATTERN_TABLE ***
               
               ext.w     d0
               add.w     d0,d0
               adda.w    d0,a3
               
               ; update a3 with new pattern data ptr
               adda.w    (a3),a3

               ; return to pattern processing loop
               bra.w     pattern_command_loop


               ;-----------------------------------------------------------------
               ; Pattern Command 0x81
               ; Set Loop Start Position within this pattern
               ;
               ;    IN: d0.b = Command Byte
               ;    IN: d7.w = ActiveChannelBits
               ;    IN: a3.l = Pattern Data Pointer
               ;    IN: a4.l = Channel_xx_Status
               ;    IN: a5.l = Note Period Table
               ;    IN: a6.l = CUSTOM
               ;
               ; Original Address $0000445a
               ;
_pattern_cmd_81_SetInPatternLoop
               move.l    a3,chan_ptrPatternDataLoop(a4)
               bra.w     pattern_command_loop


               ;-----------------------------------------------------------------
               ; Pattern Command 0x82
               ; No Operation
               ;
               ;    IN: d0.b = Command Byte
               ;    IN: d7.w = ActiveChannelBits
               ;    IN: a3.l = Pattern Data Pointer
               ;    IN: a4.l = Channel_xx_Status
               ;    IN: a5.l = Note Period Table
               ;    IN: a6.l = CUSTOM
               ;
               ; Original Address $00004462
               ;
_pattern_cmd_82_NOP
               bra.w     pattern_command_loop


               ;-----------------------------------------------------------------
               ; Pattern Command 0x83
               ; No Operation
               ;
               ;    IN: d0.b = Command Byte
               ;    IN: d7.w = ActiveChannelBits
               ;    IN: a3.l = Pattern Data Pointer
               ;    IN: a4.l = Channel_xx_Status
               ;    IN: a5.l = Note Period Table
               ;    IN: a6.l = CUSTOM
               ;
               ; Original Address $00004466
               ;
_pattern_cmd_83_NOP
               bra.w     pattern_command_loop


               ;-----------------------------------------------------------------
               ; Pattern Command 0x84
               ; Paired Notes
               ;
               ;    IN: d0.b = Command Byte
               ;    IN: d7.w = ActiveChannelBits
               ;    IN: a3.l = Pattern Data Pointer
               ;    IN: a4.l = Channel_xx_Status
               ;    IN: a5.l = Note Period Table
               ;    IN: a6.l = CUSTOM
               ;
               ; Original Address $0000446a
               ;
_pattern_cmd_84_Paired_Notes
               bset.l    #PTNCMDBITS_PAIRED_NOTES,d7
               ; store command parameter
               move.b    (a3)+,chan_paramPairedNoteDurationTicks(a4)
               bra.w     pattern_command_loop 


               ;-----------------------------------------------------------------
               ; Pattern Command 0x85
               ; Paired Notes Stop
               ;
               ;    IN: d0.b = Command Byte
               ;    IN: d7.w = ActiveChannelBits
               ;    IN: a3.l = Pattern Data Pointer
               ;    IN: a4.l = Channel_xx_Status
               ;    IN: a5.l = Note Period Table
               ;    IN: a6.l = CUSTOM
               ;
               ; Original Address $00004476
               ;
_pattern_cmd_85_Paired_Notes_Stop
               bclr.l    #PTNCMDBITS_PAIRED_NOTES,d7
               bra.w     pattern_command_loop


               ;-----------------------------------------------------------------
               ; Pattern Command 0x86
               ; Extend Note Ticks
               ;
               ;    IN: d0.b = Command Byte
               ;    IN: d7.w = ActiveChannelBits
               ;    IN: a3.l = Pattern Data Pointer
               ;    IN: a4.l = Channel_xx_Status
               ;    IN: a5.l = Note Period Table
               ;    IN: a6.l = CUSTOM
               ;
               ; Original Address $0000447e
               ;
_pattern_cmd_86_Extend_Note_Ticks
               add.w     #$0100,chan_currentNoteTicks(a4)
               bra.w     pattern_command_loop


               ;-----------------------------------------------------------------
               ; Pattern Command 0x87
               ; Pause 
               ;
               ;    IN: d0.b = Command Byte
               ;    IN: d7.w = ActiveChannelBits
               ;    IN: a3.l = Pattern Data Pointer
               ;    IN: a4.l = Channel_xx_Status
               ;    IN: a5.l = Note Period Table
               ;    IN: a6.l = CUSTOM
               ;
               ; Desc: Increases the Length of the Current Note Playing by the 
               ; Byte Parameter Value. Then stop the audio for that period of time.
               ; Format: 0x87
               ; Param:  Byte Value of Ticks to Add to Note Length
               ; Original Address $00004488
               ;
_pattern_cmd_87_Pause
               bclr.l    #PTNCMDBITS_ADSR_ACTIVE,d7
               bset.l    #PTNCMDBITS_CHANNEL_DISABLED,d7
               clr.w     chan_noteVolume(a4)
               bra.w     _initialise_note_duration


               ;-----------------------------------------------------------------
               ; Pattern Command 0x88
               ; Portomento/slide note
               ;
               ;    IN: d0.b = Command Byte
               ;    IN: d7.w = ActiveChannelBits
               ;    IN: a3.l = Pattern Data Pointer
               ;    IN: a4.l = Channel_xx_Status
               ;    IN: a5.l = Note Period Table
               ;    IN: a6.l = CUSTOM
               ;
               ;    Desc: Slides to the Next Note in the Patten (From the Specified +- offset and speed) 
               ;    Format: 0x88
               ;    Param1: Byte Value Specifying the Start of the PORTO/BEND Offset to the next note. 
               ;    Param2: Byte Value of the PORTO/BEND Speed.
               ; original address $00004498
_pattern_cmd_88_Portomento                       
               bset.l    #PTNCMDBITS_PORTOMENTO,d7
               move.b    (a3)+,chan_paramPortomentoStartOffset(a4)
               move.b    (a3)+,chan_paramPortomentoLengthTicks(a4)
               bra.w     pattern_command_loop


               ;-----------------------------------------------------------------
               ; Pattern Command 0x89
               ; Start LeadIn Notes
               ;
               ;    IN: d0.b = Command Byte
               ;    IN: d7.w = ActiveChannelBits
               ;    IN: a3.l = Pattern Data Pointer
               ;    IN: a4.l = Channel_xx_Status
               ;    IN: a5.l = Note Period Table
               ;    IN: a6.l = CUSTOM
               ;
               ; Desc: Starts adding a lead-in note to the notes played
               ; Format: 0x89
               ; Param1: Byte Value Specifying the signed (+-) interval of the leadin note 
               ; Param2: Byte Value for the length of the lead-in note
               ; original address $000044a8
_pattern_cmd_89_LeadIn_Notes                       
               and.w     #$fff8,d7                       ; Preserve bits 0, 1 & 2 of ActiveChannel Bits, switch all other effects off
               bset.l    #PTNCMDBITS_LEADIN_NOTES,d7
               move.b    (a3)+,chan_paramLeadInNoteOfffset(a4) 
               move.b    (a3)+,chan_paramLeadInNoteDurationTicks(a4)
               bra.w     pattern_command_loop


               ;-----------------------------------------------------------------
               ; Pattern Command 0x8a
               ; Start LeadIn Notes Stop Effect
               ;
               ;    IN: d0.b = Command Byte
               ;    IN: d7.w = ActiveChannelBits
               ;    IN: a3.l = Pattern Data Pointer
               ;    IN: a4.l = Channel_xx_Status
               ;    IN: a5.l = Note Period Table
               ;    IN: a6.l = CUSTOM
               ;
               ; Original Address $000044b
               ;
_pattern_cmd_8a_LeadIn_Notes_Stop
               bclr.l    #PTNCMDBITS_LEADIN_NOTES,d7
               bra.w     pattern_command_loop


               ;-----------------------------------------------------------------
               ; Pattern Command 0x8b
               ; Start Vibrato Modulation Effect
               ;
               ;    IN: d0.b = Command Byte
               ;    IN: d7.w = ActiveChannelBits
               ;    IN: a3.l = Pattern Data Pointer
               ;    IN: a4.l = Channel_xx_Status
               ;    IN: a5.l = Note Period Table
               ;    IN: a6.l = CUSTOM
               ;
               ; Desc: Starts a Pitch Modulation Effect on this channel.
               ;       Sets BIT #2 of the Pattern CMD BITS.
               ; 
               ; Format: 0x8e = Command
               ;         Byte = Parameter - Effect Start Delay
               ;         Byte = Parameter - Amount of Modulation/Level
               ; 	Byte = Parameter - Speed/Rate of Modulation
               ;
               ; Original Address $000044f4
               ;
_pattern_cmd_8b_Modulation
               and.w     #$fff8,d7                      ; Preserve bits 0, 1 & 2
               bset.l    #PTNCMDBITS_MODULATION,d7
               move.b    (a3)+,chan_paramModulationDelayStart(a4)
               move.b    (a3)+,chan_paramModulationLevel(a4)
               move.b    (a3)+,chan_paramModulationSpeed(a4)
               bra.w     pattern_command_loop


               ;-----------------------------------------------------------------
               ; Pattern Command 0x8b
               ; Start Vibrato Modulation Effect
               ;
               ;    IN: d0.b = Command Byte
               ;    IN: d7.w = ActiveChannelBits
               ;    IN: a3.l = Pattern Data Pointer
               ;    IN: a4.l = Channel_xx_Status
               ;    IN: a5.l = Note Period Table
               ;    IN: a6.l = CUSTOM
               ;
               ; Original Address $0000450c
               ;
_pattern_cmd_8c_Modulation_Stop
               bclr.l    #PTNCMDBITS_MODULATION,d7
               bra.w     pattern_command_loop


               ;-----------------------------------------------------------------
               ; Pattern Command 0x8d
               ; Start Arpeggio Effect
               ;
               ;    IN: d0.b = Command Byte
               ;    IN: d7.w = ActiveChannelBits
               ;    IN: a3.l = Pattern Data Pointer
               ;    IN: a4.l = Channel_xx_Status
               ;    IN: a5.l = Note Period Table
               ;    IN: a6.l = CUSTOM
               ;
               ; Desc: Starts an Arpeggio effect on the channel using an entry from the Arpeggion Table.
               ;       Sets BIT #1 of the Pattern CMD BITS.
               ; 
               ; Format: 0x8d = Command
               ;         Byte = Parameter - Index into Arpeggio Offset Table (table of word offsets)
               ; Original Address $000044c4
               ;
               ;    Additional Notes:
               ;         Refactored to remove hardcoded reference to 'arpeggio_table'
               ;
_pattern_cmd_8d_Arpeggio
               and.w     #$fff8,d7                      ; preserve bits 0, 1 & 2
               bset.l    #PTNCMDBITS_ARPEGGIO,d7

               lea       module_table,a0
               move.l    mod_arpeggio_table(a0),a0
               ;lea.l    arpeggio_table,a0
                
               moveq     #$00,d0
               move.b    (a3)+,d0
               add.w     d0,d0
               adda.w    d0,a0
               adda.w    (a0),a0
               move.b    (a0)+,chan_paramArpeggioSpeedTicks(a4)  
               move.b    (a0)+,chan_paramArpeggioTableLength(a4) 
               move.l    a0,chan_ptrArpeggioTable(a4)
               bra.w     pattern_command_loop  


               ;-----------------------------------------------------------------
               ; Pattern Command 0x8e
               ; Stop Arpeggio Effect
               ;
               ;    IN: d0.b = Command Byte
               ;    IN: d7.w = ActiveChannelBits
               ;    IN: a3.l = Pattern Data Pointer
               ;    IN: a4.l = Channel_xx_Status
               ;    IN: a5.l = Note Period Table
               ;    IN: a6.l = CUSTOM
               ;
               ; Original Address $000044ec
               ;
_pattern_cmd_8e_Arpeggio_Stop
               bclr.l    #PTNCMDBITS_ARPEGGIO,d7
               bra.w     pattern_command_loop


               ;-----------------------------------------------------------------
               ; Pattern Command 0x8f
               ; Select ADSR Envelope
               ;
               ;    IN: d0.b = Command Byte
               ;    IN: d7.w = ActiveChannelBits
               ;    IN: a3.l = Pattern Data Pointer
               ;    IN: a4.l = Channel_xx_Status
               ;    IN: a5.l = Note Period Table
               ;    IN: a6.l = CUSTOM
               ;
               ; Desc: Sets the Current Instrument's ADSR Envelope.
               ;
               ; Format: 0x8f = Command
               ;    Byte = Parameter - Index into ADSREnvelopeOffsetTable
               ;
               ; Original Address $00004514
               ;
               ;    Additional Notes:
               ;         Refactored to remove hardcoded reference to 'adsr_envelope_table'
               ;
_pattern_cmd_8f_Select_ADSR

               lea.l     module_table,a0
               move.l    mod_adsr_table(a0),a0
               ;lea.l    adsr_envelope_table,a0              *** REFACTOR OUT HARDCODED REFERENCE TO ADSR_ENVELOPE_TABLE ***
                
               moveq     #$00,d0
               move.b    (a3)+,d0
               add.w     d0,d0
               adda.w    d0,a0
               adda.w    (a0),a0
               move.l    a0,chan_ptrADSREnvelope(a4) 
               bra.w     pattern_command_loop  


               ;-----------------------------------------------------------------
               ; Pattern Command 0x90
               ; Select Instrument
               ;
               ;    IN: d0.b = Command Byte
               ;    IN: d7.w = ActiveChannelBits
               ;    IN: a3.l = Pattern Data Pointer
               ;    IN: a4.l = Channel_xx_Status
               ;    IN: a5.l = Note Period Table
               ;    IN: a6.l = CUSTOM
               ;
               ;    Desc: Sets the Current Channel's Sample Data to Play.
               ;          - Runs the Next Pattern Command (Maybe twice)
               ;          - Perhaps to allow the set up the Sound's ADSR/Effects as the next command or similar?
               ;    
               ;    Format: 0x09 = Command
               ;            Byte = Parameter - Inntrument Id 01 - 0x0d
               ;    
               ;    Notes:
               ;        1) Copies the instrument data into the Temporary Instrument Parameters Area of Memory.
               ;        2) Cleas BIT 6 of the ACTIVE Commands Bits.
               ;        3) If the Instrument's UNKNOWN Flag word is 0, 
               ;           - then it runs the next Pattern Command (Bit 6 = 0)
               ;        4) Sets BIT 6 of the ACTIVE Commands Bits.
               ;        5) Runs the next Pattern Command (BIT 6 = 1)
               ;
               ;    Original Address $0000452c
               ;  
               ;
_pattern_cmd_90_Select_Instrument
               lea.l     instrument_data_table,a0
               moveq     #$00,d0
               move.b    (a3)+,d0
               asl.w     #$04,d0
               adda.w    d0,a0
               move.w    (a0)+,chan_instrumentTuningAmount(a4)  
               move.l    (a0)+,chan_ptrInstrumentSampleStart(a4)
               move.w    (a0)+,chan_instrumentSampleLength(a4)  
               move.l    (a0)+,chan_ptrInstrumentSampleRepeat(a4)
               move.w    (a0)+,chan_instrumentRepeatLength(a4)
               ; check if the instrument can be transposed in pitch
               ; some instruments (drums etc) might not want to transposed 
               ; when a pattern is transposed in pitch.   
               bclr.l    #PTNCMDBITS_TRANSPOSE_NOTE,d7
               tst.w     (a0)
               beq.w     pattern_command_loop
               bset.l    #PTNCMDBITS_TRANSPOSE_NOTE,d7
               bra.w     pattern_command_loop


               ;-------------------------------------------------------------------------
               ; Start Playing a new note 
               ; i.e. (re)trigger the current instrument at the specified pitch for the
               ; specified duration.
               ;
               ; Called from the pattern_command_loop after all command processing
               ; has completed,
               ;
               ;    IN: d0.b = Note Pitch
               ;    IN: d7.w = ActiveChannelBits
               ;    IN: a3.l = Pattern Data Pointer
               ;    IN: a4.l = Channel_xx_Status
               ;    IN: a5.l = Note Period Table
               ;    IN: a6.l = CUSTOM
               ;
               ; Original Address $00004560
               ;
_trigger_playing_new_note 
               ; do transpose pattern processing
               btst.l    #PTNCMDBITS_TRANSPOSE_NOTE,d7  
               bne.b     .store_note_pitch_index   
.add_transpose_pitch_index
               add.b     chan_patternTransposeValue(a4),d0
.store_note_pitch_index
               move.b    d0,chan_transposedNoteIndex(a4)  


               ; do leadin notes processing
               ; if no leading notes, then store the same pitch index for leadin note
               ; d0 = note pitch index
               btst.l    #PTNCMDBITS_LEADIN_NOTES,d7
               beq.b     .store_leadin_note_pitch_index

               ; if active, set up leading note pitch index and leadin note duration
.add_leadin_pitch_index
               add.b     chan_paramLeadInNoteOfffset(a4),d0
               move.b    chan_paramLeadInNoteDurationTicks(a4),chan_leadInNoteCurrentTicks(a4)

               ; store leadin note pitch index (can be same as note pitch index if not active)
.store_leadin_note_pitch_index
               move.b    d0,chan_transposedLeadInNoteIndex(a4)

               ; get note period value from pitch index
               ext.w     d0
               sub.w     chan_instrumentTuningAmount(a4),d0   
               add.w     d0,d0                      
               ; d0 = index into mid point of Note_Period_Table held in a5
               
               ; validate index in table range -48 to +44
               ; if not then throw 'illegal exception'
.validate_pitch_index
                cmp.w    #$ffd0,d0                       ; compare -48
                blt.b    .debug_assert_fail        
                cmp.w    #$002c,d0                       ; compare +44
                ble.b    .store_note_period_value  

.debug_assert_fail 
                move.b   chan_transposedNoteIndex(a4),d1 
                move.b   chan_transposedLeadInNoteIndex(a4),d2
                move.w   chan_instrumentTuningAmount(a4),d3
                move.w   chan_ChannelDMA(a4),d4
                movea.l  chan_ptrNextTrackSequencePosition(a4),a2
                illegal  ; ******* DEBUG/ASSERT BAD PITCH INDEX VALUE

               ; d0.w = valid index into a5 (Note_Period_Table)
               ; lookup note period value
.store_note_period_value
               move.w    $00(a5,d0.w),chan_notePeriodValue(a4)


               ;-------------------------------------------------
               ; initialise note modulation/vibrato if active
_initialise_modulation
               btst.l    #PTNCMDBITS_MODULATION,d7
               ; if no modulation, initialise portomento
               beq.b     _initialise_portomento  

               ; calculate modulation pitch limit
               move.b    chan_transposedLeadInNoteIndex(a4),d0
               add.b     chan_paramModulationLevel(a4),d0     ; modulation pitch interval index
               ext.w     d0
               sub.w     chan_instrumentTuningAmount(a4),d0   ; tuning pitch interval index
               add.w     d0,d0

               ; validate pitch limit index in table range -48 to +44
               ; if not then throw 'illegal exception'
.validate_pitch_index
                cmp.w    #$ffd0,d0                       ; compare -48
                blt.b    .debug_assert_fail
                cmp.w    #$002c,d0                       ; compare +44
                ble.b    .continue_init_modulation

.debug_assert_fail
                move.b   chan_transposedNoteIndex(a4),d1
                move.b   chan_transposedLeadInNoteIndex(a4),d2
                move.w   chan_instrumentTuningAmount(a4),d3
                move.w   chan_ChannelDMA(a4),d4
                movea.l  chan_ptrNextTrackSequencePosition(a4),a2
                illegal  ; ******* DEBUG/ASSERT BAD PITCH INDEX VALUE

.continue_init_modulation 
               ; get initial modulated pitch/period
               move.w    $00(a5,d0.w),d0
               ; d0.w = max modulation pitch/period

               ; get max +- modulated pitch/period offset
               sub.w     chan_notePeriodValue(a4),d0 
               asr.w     #$01,d0                         
               ext.l     d0
               ; d0.w = max modulation amount(+-) for current note

               ; calculate the amount of modulation to apply per tick
               ; mod per tick = max modulation amount/modulation speed
               move.b    chan_paramModulationSpeed(a4),d1                  
               ext.w     d1
               divs.w    d1,d0 
               move.w    d0,chan_modulationAmountPerTick(a4)

               ; store modulation speed ticks and speed ticks x 2
               move.b    d1,chan_modulationSpeedTicks(a4)  
               add.b     d1,d1        
               move.b    d1,chan_modulationSpeedTicks_x2(a4) 

               ; initialise modulation start delay from parameter value
               move.b    chan_paramModulationDelayStart(a4),chan_modulationDelayStartTicks(a4) 

               ;---------------------------------------------
               ; initialise portomento if active
_initialise_portomento
               btst.l    #PTNCMDBITS_PORTOMENTO,d7
               ; if not active, initialise arpeggio
               beq.b     _initialise_arpeggio

               ; initialise portomento
               ; calculate initial portomento pitch index value
               move.b    chan_transposedLeadInNoteIndex(a4),d0     ; current note pitch index
               add.b     chan_paramPortomentoStartOffset(a4),d0    ; add porto start index
               ext.w     d0 
               sub.w     chan_instrumentTuningAmount(a4),d0        ; adjust by fine tune index
               add.w     d0,d0
.validate_pitch_index 
               cmp.w     #$ffd0,d0                       ; validate -48
               blt.b     .debug_assert_fail
               cmp.w     #$002c,d0                       ; validate +44
               ble.b     .continue_init_portomento

.debug_assert_fail
                move.b   chan_transposedNoteIndex(a4),d1
                move.b   chan_transposedLeadInNoteIndex(a4),d2
                move.w   chan_instrumentTuningAmount(a4),d3
                move.w   chan_ChannelDMA(a4),d4
                movea.l  chan_ptrNextTrackSequencePosition(a4),a2
                illegal  ; ******* DEBUG/ASSERT BAD PITCH INDEX VALUE

.continue_init_portomento
               ; get initial portomento pitch/period
               move.w    $00(a5,d0.w),d0
               ; d0.w = initial portomento pitch/period

               ; calculate initial porto amount
               sub.w     chan_notePeriodValue(a4),d0
               ext.l     d0

               ; calculate the porto amount per tick
               moveq     #$00,d1
               move.b    chan_paramPortomentoLengthTicks(a4),d1  
               divs.w    d1,d0 
               move.w    d0,chan_portomentoAmountPerTick(a4) 
               
               ; set the initial note period (modified by initial amount)
               neg.w     d0
               muls.w    d1,d0
               sub.w     d0,chan_notePeriodValue(a4) 


               ;--------------------------------------------------
               ; initialise arpeggio if active
_initialise_arpeggio
               btst.l    #PTNCMDBITS_ARPEGGIO,d7 
               ; if not arpeggio, then initialise ADSR Envelops
               beq.b     _initialise_adsr_envelope

               ; initialise arpeggio
               move.b    #$01,chan_arpeggioRateTicks(a4)
               move.l    chan_ptrArpeggioTable(a4),chan_ptrArpeggioCurrentTable(a4)
               move.b    chan_paramArpeggioTableLength(a4),chan_arpeggioTableLenCount(a4)

               ;---------------------------------------------------
               ; initialise ADSR if active
_initialise_adsr_envelope
               bset.l    #PTNCMDBITS_ADSR_ACTIVE,d7
               move.l    chan_ptrADSREnvelope(a4),chan_ptrCurrentADSREnvelope(a4)
               move.w    #$0001,chan_adsrEnvelopePhaseTicks(a4)
               clr.w     chan_noteVolume(a4)       
               
               ; set channel dma usage (dma bit for channel)
               move.w    chan_ChannelDMA(a4),d0            
               or.w      d0,audio_dma
               ; fall through to '_initialise_note_duration'
               ; below


               ;--------------------------------------------------------------
               ; Process Note Duration? (I think...) 
               ; also called by 'pause command'
               ;
               ;    IN: d0.b = Command Byte
               ;    IN: d7.w = ActiveChannelBits
               ;    IN: a3.l = Pattern Data Pointer
               ;    IN: a4.l = Channel_xx_Status
               ;    IN: a5.l = Note Period Table
               ;    IN: a6.l = CUSTOM
               ;
               ; Original Address $0000469c
               ;
_initialise_note_duration                              
               ; clear paired note duration ticks
               moveq     #$00,d0
               move.b    chan_paramPairedNoteDurationTicks(a4),d0
       
               ; test if PAIRED_NOTES is active
                btst.l    #PTNCMDBITS_PAIRED_NOTES,d7
                bne.b     .is_paired_note
.not_paired_note 
               ; get note duration from pattern data
                move.b   (a3)+,d0                   
.is_paired_note
                add.w    d0,chan_currentNoteTicks(a4)       
                move.l   a3,chan_ptrNextPatternDataPosition(a4)
               ; fall through to '_do_process_active_pattern_commands'
               ; below



               ;--------------------------------------------------------------
               ; Process Active Pattern Comands 
               ; i.e. process long running note effects
               ;    - adsr, arpeggios, portomento, vibrato/modulation etc
               ;
               ;    IN: d0.b = Command Byte (changes to note period value)
               ;    IN: d7.w = ActiveChannelBits
               ;    IN: a3.l = Pattern Data Pointer
               ;    IN: a4.l = Channel_xx_Status
               ;    IN: a5.l = Note Period Table
               ;    IN: a6.l = CUSTOM
               ;
               ; Original Address $000046b2
               ;
_do_process_active_pattern_commands 
               ; if channel is disabled then skip processing
               btst.l    #PTNCMDBITS_CHANNEL_DISABLED,d7
               bne.w     exit_command_processing

               ; process running effects
               ; d0.w = note period value
               move.w    chan_notePeriodValue(a4),d0

               ; ------------------------------------------
               ; process portomento effect
               ;
               btst.l    #PTNCMDBITS_PORTOMENTO,d7
               ; if portomento not active, skip to next
               beq.b     _process_leadin_notes_effect

               ; update portomento ticks
               subq.b    #$01,chan_paramPortomentoLengthTicks(a4)
               bne.b     .porto_update_note_period

               ; end portomento effect (last update)
               bclr.l    #PTNCMDBITS_PORTOMENTO,d7
.porto_update_note_period
               sub.w     chan_portomentoAmountPerTick(a4),d0
               ; when porto is active then skip
               ; leading notes, arpeggio & modulation/vibrato
               bra.w     store_sample_period 




               ;---------------------------------------------------
               ; process lead-in notes effect
               ; NB: is skipped/paused when portomento is playing
               ;    also, no leadin notes effect used by title prg music
_process_leadin_notes_effect
               btst.l    #PTNCMDBITS_LEADIN_NOTES,d7
               beq.b     _process_arpeggio_effect


               ; update lead-in pitch index
               subq.b    #$01,chan_leadInNoteCurrentTicks(a4)
               bcc.w     store_sample_period

               ; update lead-in pitch index (swap notes)
               ; move.b  chan_transposedLeadInNoteIndex(a4),d1     ; unused d1 (overwritten below)
               move.b    chan_transposedNoteIndex(a4),d0
               move.b    d0,chan_transposedLeadInNoteIndex(a4)
               ext.w     d0
               sub.w     chan_instrumentTuningAmount(a4),d0
               add.w     d0,d0

.validate_pitch_index
               cmp.w     #$ffd0,d0                       ; validate -48
               blt.b     .debug_assert_fail                       
               cmp.w     #$002c,d0                       ; valdate +44
               ble.b     .continue_leadin_effect

.debug_assert_fail
               move.b    chan_transposedNoteIndex(a4),d1   
               move.b    chan_transposedLeadInNoteIndex(a4),d2
               move.w    chan_instrumentTuningAmount(a4),d3
               move.w    chan_ChannelDMA(a4),d4
               movea.l   chan_ptrNextTrackSequencePosition(a4),a2
               illegal   ; ******* DEBUG/ASSERT BAD PITCH INDEX VALUE

.continue_leadin_effect
               ; get note period value           
               move.w    $00(a5,d0.w),d0
               bra.w     store_sample_period 
               ;--------------------------------------------------


               ;-----------------------------------------------------------
               ; process arpeggio efffect
               ; NB: is skipped/paused when portomento or lead-in notes 
               ;     effect is active.
               ; Also, there are no arpeggio effects used in titleprg.
               ;
_process_arpeggio_effect
               btst.l    #PTNCMDBITS_ARPEGGIO,d7
               ; if not active, do modulation/vibrato
               beq.b     _process_modulation_effect


               ; update arpeggio effect
               subq.b    #$01,chan_arpeggioRateTicks(a4)
               bne.b     store_sample_period

               ; get next arpeggio entry from table
               movea.l   chan_ptrArpeggioCurrentTable(a4),a0
               move.b    (a0)+,d0
               subq.b    #$01,chan_arpeggioTableLenCount(a4)
               bne.b     .store_arp_table_ptr
               movea.l   chan_ptrArpeggioTable(a4),a0
               ; end of table, reset ptr to start
               move.b    chan_paramArpeggioTableLength(a4),chan_arpeggioTableLenCount(a4)

               ; store arpeggion table ptr 
.store_arp_table_ptr     
               move.l    a0,chan_ptrArpeggioCurrentTable(a4)

               ; set arpeggio note duration
               move.b    chan_paramArpeggioSpeedTicks(a4),chan_arpeggioRateTicks(a4)
               
               ; get areggio note pitch/period index
               add.b     chan_transposedLeadInNoteIndex(a4),d0
               ext.w     d0
               sub.w     chan_instrumentTuningAmount(a4),d0
               add.w     d0,d0

.validate_pitch_index
               cmp.w     #$ffd0,d0                       ; validate -48
               blt.b     .debug_assert_fail
               cmp.w     #$002c,d0                       ; valdate +44
               ble.b     .continue_arpeggio_effect

.debug_assert_fail
               move.b    chan_transposedNoteIndex(a4),d1
               move.b    chan_transposedLeadInNoteIndex(a4),d2
               move.w    chan_instrumentTuningAmount(a4),d3
               move.w    chan_ChannelDMA(a4),d4
               movea.l   chan_ptrNextTrackSequencePosition(a4),a2
               illegal   ; ******* DEBUG/ASSERT BAD PITCH INDEX VALUE

.continue_arpeggio_effect
               ; get arpeggio note pitch/period value
               move.w    $00(a5,d0.w),d0
               bra.w     store_sample_period
               ;----------------------------------------------------------




               ;---------------------------------------------------------------
               ; play modulation/vibrato effect
               ; NB: is skipped when portomento, leadin, or arpeggio is playing
               ;
_process_modulation_effect
               btst.l    #PTNCMDBITS_MODULATION,d7
               ; if not active, no further effect processing
               beq.b     store_sample_period

               
               ; do modulation delay ticks value
               subq.b    #$01,chan_modulationDelayStartTicks(a4)
               bcc.b     store_sample_period
               
               ; do initial modulation wave processing
               addq.b    #$01,chan_modulationDelayStartTicks(a4)
               subq.b    #$01,chan_modulationSpeedTicks(a4)
               bne.b     .add_modulation_value

               ; do tail of modulation wave processing (flip +- addition for half the time)
               neg.w     chan_modulationAmountPerTick(a4)
               move.b    chan_modulationSpeedTicks_x2(a4),chan_modulationSpeedTicks(a4)

.add_modulation_value     
               ; d0.w = note pitch/period value (set at top of process effects)
               ;move.w    chan_notePeriodValue(a4),d0          ; could do this instead
               add.w     chan_modulationAmountPerTick(a4),d0
               ; fall through to 'store_sample_period' below
               ;


               ;------------------------------------------------
               ; store updated sample period from modulation
               ; effect updated above
               ; i.e. portomento, leadin notes, arpeggio, modulation/vibrato
               ;
               ; Original Address $000047a8
               ;
store_sample_period                                     
               move.w    d0,chan_notePeriodValue(a4)
               ; end of pitch modulation effects



               ;----------------------------------------------------------
               ; Process ADSR (maybe just ADR) Volume Envelope
               ; ADSR in pairs of bytes?
               ;  byte 1 = command byte (+ve, -ve or 0)
               ;  byte 2 = duration
               ;
               ;    +ve command
               ;         - command is the duration of adsr phase
               ;         - parameter is the volume change per tick.
               ;    0 command
               ;         - parameter = 0 = and ADSR
               ;         - parameter value = sustain volume duration
               ;
               ;    -ve command (over complicated)
               ;         - command is the duration of adsr phase
               ;         - parameter sign indicates whether to flip attack/decay
               ;         - parameter value change rate of volume change
               ;
               ;
               ; Original Address $000047ac
               ;
_process_ADSR_Envelope
               btst.l    #PTNCMDBITS_ADSR_ACTIVE,d7
               ; if not active then end effect processing
               beq.w     exit_command_processing  


               ; decrement current ADSR phase timespan ticks
               subq.w    #$01,chan_adsrEnvelopePhaseTicks(a4)
               ; if ticks > 0 then process volume for current ADSR phase
               bne.w     .process_current_ADSR_phase
               
               ; else initialise next ADSR phase parameter values
               ; get next ADSR parameter
               movea.l   chan_ptrCurrentADSREnvelope(a4),a0
               moveq     #$00,d0
               move.b    (a0)+,d0
               ; if value == 0 then enter final ADSR phase
               beq.b     .ADSR_zero_cmd
               bmi.b     .ADSR_negative_cmd

               ; +ve command = delay ticks
               ; every tick add rate of change to the volume
               ; change volume up by rate of change for duration of time
               ;    command value = duration in ticks
               ;    parameter from table = volume rate of change
.ADSR_positive_cmd
               move.w    d0,chan_adsrEnvelopePhaseTicks(a4)
               move.b    #$01,chan_adsrRateOfChangeTicks(a4)
               move.b    #$01,chan_adsrCurrentRateOfChangeTicks(a4)
               move.b    (a0)+,chan_adsrVolumeRateOfChange(a4)
               move.l    a0,chan_ptrCurrentADSREnvelope(a4)
               bra.b     .process_current_ADSR_phase
               ; -ve command
               ; This command is a bit over complicated, it enables the ADSR phase to
               ; be reversed (if parameter is negative, so attack becomes decay)
               ; the parameter is used to set the rate of the Attack/Decay.
               ;
               ;    command value = duration in ticks
               ;    parameter value = 
               ;                        if (-ve then reverse volume increase direction)
               ;                        if (+ve then keep volume increase direction)
               ;                        parameter becomes new rate of change (faster/slower volume increase)
.ADSR_negative_cmd
               neg.b     d0
               move.w    d0,chan_adsrEnvelopePhaseTicks(a4)
               move.b    #$01,chan_adsrVolumeRateOfChange(a4)
               move.b    (a0)+,d0
               bpl.b     .L000047f8
               neg.b     d0
               neg.b     chan_adsrVolumeRateOfChange(a4)
.L000047f8     move.b    d0,chan_adsrRateOfChangeTicks(a4)
               move.b    #$01,chan_adsrCurrentRateOfChangeTicks(a4)
               move.l    a0,chan_ptrCurrentADSREnvelope(a4)
               bra.b     .process_current_ADSR_phase


               ; ADSR zero command (sustain processing)
               ; If the parameter is 0, then end ADSR processing
               ; If not 0 then the absolute value of the parameter becomes the sustain time of the note
               ; the note is held at the same volume for the period of time.
               ; If the note ends before end of sustain then the note finishes.
               ; else, another phase can begin (i.e. release phase)
.ADSR_zero_cmd
               ; a0 = ADSR table
               move.b    (a0),d0
               beq.b     .end_ADSR            ; if ADSR ends with $00,$00
               ; so sustain period
               bpl.b     .calc_sustain_length
               ; make -ve value a +ve lenght of time
               neg.b     d0

.calc_sustain_length
               sub.w     chan_currentNoteTicks(a4),d0
               bmi.b     .set_sustain_parameters

               ; if note duration expired then end ASDR
.end_ADSR      bclr.l    #PTNCMDBITS_ADSR_ACTIVE,d7
               bra.b     exit_command_processing 

               ; set note sustain parameters 
.set_sustain_parameters
               neg.w     d0
               move.w    d0,chan_adsrEnvelopePhaseTicks(a4)
               move.b    #$00,chan_adsrRateOfChangeTicks(a4)
               move.b    #$00,chan_adsrCurrentRateOfChangeTicks(a4)
               move.b    #$00,chan_adsrVolumeRateOfChange(a4)
               move.l    a0,chan_ptrCurrentADSREnvelope(a4)
               bra.b     exit_command_processing


               ; current ADSR phase ticks
               ; process volume change at specified rate for the
               ; current phase of ADSR
.process_current_ADSR_phase
               subq.b    #$01,chan_adsrCurrentRateOfChangeTicks(a4)    
               bne.b     exit_command_processing         ; L00004850
                
               ; update audio volume (+-) for current ADSR phase
               move.b    chan_adsrRateOfChangeTicks(a4),chan_adsrCurrentRateOfChangeTicks(a4)
               move.b    chan_adsrVolumeRateOfChange(a4),d0
               ext.w     d0
               add.w     d0,chan_noteVolume(a4)

exit_command_processing 
               rts  





                ; ----------------------- set custom register values -------------------
                ; IN: a6 - Custom Base
                ; IN: 
update_audio_custom_registers                                   ; original routine address $00004852
                move.w  audio_dma,d0                            ; L0000417c ; Audio DMA?  #$0054 of channel_data
                beq.b   set_channel_volume                      ; L000048c6

                ; init channel dma and interrupts if $417c != 0
set_channel_dma                                                 ; original asddress $00004858
                move.w  d0,DMACON(a6)                           ; enable audio channel(s) DMA - $0096(a6)
                move.w  d0,d1
                lsl.w   #$07,d1
                move.w  d1,INTREQ(a6)                           ; clear audio interrupt flags - $009c(a6)
                moveq   #$00,d2
                moveq   #$01,d3

.chk_aud0_dma                                                   ; original address L00004868
                btst.l  #$0000,d0
                beq.b   .chk_aud1_dma                           ; aud 0 dma is off - $00004876

.is_aud0_dma                                                    ; original address L0000486e
                move.w  d3,AUD0PER(a6)                          ; AUD0PER - set to #$0001 - audio 0 frequency period value - ; $00a6(a6)
                move.w  d2,AUD0DAT(a6)                          ; AUD0DAT - set to #$0000 - audio 0 data value - ; $00aa(a6)

.chk_aud1_dma                                                   ; original address L00004876
                btst.l  #$0001,d0
                beq.b   .chk_aud2_dma                           ; L00004884

.is_aud1_dma                                                    ; original address L0000487c
                move.w  d3,AUD1PER(a6)                          ; $00b6(a6)
                move.w  d2,AUD1DAT(a6)                          ; $00ba(a6)

.chk_aud2_dma                                                   ; original address L00004884
                btst.l  #$0002,d0
                beq.b   .chk_aud3_dma                           ; L00004892

.is_aud2_dma                                                    ; original address L0000488a
                move.w  d3,AUD2PER(a6)                          ; $00c6(a6)
                move.w  d2,AUD2DAT(a6)                          ; $00ca(a6)

.chk_aud3_dma                                                   ; original address L00004892
                btst.l  #$0003,d0
                beq.b   .audio_interrupt_wait                   ; L000048a0
.is_aud3_dma                                                    ; original address L00004898
                move.w  d3,AUD3PER(a6)                          ; $00d6(a6)
                move.w  d2,AUD3DAT(a6)                          ; $00da(a6)

.audio_interrupt_wait                                           ; original address L000048a0
                move.w  INTREQR(a6),d2                          ; INTREQR - Interrupt flag bits
                and.w   d1,d2                                   ; mask disabled audio interrupts
                cmp.w   d1,d2                                   ; wait for interrupts to occur on all enabled audio channels
                bne.b   .audio_interrupt_wait                   ; L000048a0

.raster_wait                                                    ; original address L000048aa
                moveq   #$02,d2                                 ; loop counter 2 + 1
                move.w  VHPOSR(a6),d3                           ; $0006(a6),d3
                and.w   #$ff00,d3                               ; mask horizontal position
.loop                                                           ; original address L000048b4
                move.w  VHPOSR(a6),d4                           ; $0006(a6),d4
                and.w   #$ff00,d4                               ; mask horizontal position
                cmp.w   d4,d3
                beq.b   .loop                                   ; wait for next raster line, L000048b4
                move.w  d4,d3
                dbf.w   d2,.loop                                ; L000048b4 ; wait for approx 3.5 raster lines


set_channel_volume                                              ; original address L000048c6
                move.w  master_music_volume_mask_1,d1           ; L0000401c - master audio volume mask 1 (#$ffff = on)
                move.w  master_sfx_volume_mask_2,d2             ; L0000401e - master audio volume mask 2 (#$ffff = on)
 


                ; IN: D0 = DMA/interrupt bits (channel enabled)
                ; IN: D1 = master volume mask 1
do_channel_1
                lea.l   channel_00_status,a0                     ; $4024,a0
                move.w  d1,d3
.chk_volume_mask
                btst.b  #$0006,chan_ActiveCommandBits(a0)                             ; test which volume mask to use (allows volume off/reduced volume by setting a channel bit) 
                beq.b   .use_volume_mask_1                      ; $000048dc
.use_volume_mask_2                                              ; original address L000048da
                move.w  d2,d3                                   ; d2,d3 = master volume mask
.use_volume_mask_1                                              ; original address L000048dc
                and.w   chan_noteVolume(a0),d3                   ; d3 = channnel volume
.set_volume                                                     ; original address L000048e0
                move.w  d3,AUD0VOL(a6)                          ; $00a8(a6) - set audio volume
.set_pitch                                                      ; original address L000048e4
                move.w  chan_notePeriodValue(a0),AUD0PER(a6)   ; $00a6(a6) - set sample pitch
.chk_new_sample                                                 ; original address L000048ea
                btst.l  #$0000,d0                               ; d0 = still contains channel interrupt/DMA status bits
                beq.b   .set_sample_2                           ; L000048fe
                ; set sample start/repeat
.set_sample_1                                                   ; original address L000048f0
                move.w  chan_instrumentSampleLength(a0),AUD0LEN(a6)    ; set DMA Sample Audio Length $00a4(a6)
                move.l  chan_ptrInstrumentSampleStart(a0),AUD0LC(a6)     ; set DMA Sample Data Ptr $00a0(a6)
                bra.b   do_channel_2                            ; jmp $0000490a
                ; set sample start/repeat
.set_sample_2                                                   ; original address L000048fe
                move.w  chan_instrumentRepeatLength(a0),AUD0LEN(a6)    ; $00a4(a6)
                move.l  chan_ptrInstrumentSampleRepeat(a0),AUD0LC(a6)     ; $00a0(a6)



                ; IN: D0 = DMA/interrupt bits (channel enabled)
                ; IN: D1 = master volume mask 1
do_channel_2                                                    ; original address L0000490a
                lea.l   channel_01_status,a0                     ; L0000407a,a0
                move.w  d1,d3
.chk_volume_mask
                btst.b  #$0006,chan_ActiveCommandBits(a0)                             ; original address L00004910
                beq.b   .use_volume_mask_1                      ; L00004918
.use_volume_mask_2                                              ; original address L00004916
                move.w  d2,d3
.use_volume_mask_1                                              ; original address L00004918
                and.w   chan_noteVolume(a0),d3
.set_volume                                                     ; original address L0000491c 
                move.w  d3,AUD1VOL(a6)                          ; $00b8(a6)
.set_pitch                                                      ; original address L00004920
                move.w  chan_notePeriodValue(a0),AUD1PER(a6)   ; $00b6(a6)
.chk_new_sample                                                 ; original address L00004926
                btst.l  #$0001,d0
                beq.b   .set_sample_2                           ; L0000493a
.set_sample_1                                                   ; original address L0000492c
                move.w  chan_instrumentSampleLength(a0),AUD1LEN(a6)    ; $00b4(a6)
                move.l  chan_ptrInstrumentSampleStart(a0),AUD1LC(a6)     ; $00b0(a6)
                bra.b   do_channel_3                            ; L00004946
.set_sample_2                                                   ; original address L0000493a
                move.w  chan_instrumentRepeatLength(a0),AUD1LEN(a6)    ; $00b4(a6)
                move.l  chan_ptrInstrumentSampleRepeat(a0),AUD1LC(a6)     ; $00b0(a6)



                ; IN: D0 = DMA/interrupt bits (channel enabled)
                ; IN: D1 = master volume mask 1
do_channel_3                                                    ; original address  L00004946
                lea.l   channel_02_status,a0                     ;$40d0,a0
                move.w  d1,d3
.chk_volume_mask                                                ; original address  L0000494c
                btst.b  #$0006,chan_ActiveCommandBits(a0)
                beq.b   .set_volume                             ; L00004954
.use_volume_mask_2                                              ; original address  L00004952
                move.w  d2,d3
.use_volume_mask_1                                              ; original address  L00004954
                and.w   chan_noteVolume(a0),d3
.set_volume                                                     ; original address  L00004958
                move.w  d3,AUD2VOL(a6)                          ; $00c8(a6)
.set_pitch                                                      ; original address  L0000495c
                move.w  chan_notePeriodValue(a0),AUD2PER(a6)   ; $00c6(a6)
.chk_new_sample                                                 ; original address  L00004962
                btst.l  #$0002,d0
                beq.b   .set_sample_2                           ; L00004976
.set_sample_1                                                   ; original address  L00004968
                move.w  chan_instrumentSampleLength(a0),AUD2LEN(a6)    ; $00c4(a6)
                move.l  chan_ptrInstrumentSampleStart(a0),AUD2LC(a6)    ; $00c0(a6)
                bra.b   do_channel_4                            ; jmp L00004982
.set_sample_2                                                   ; original address  L00004976
                move.w  chan_instrumentRepeatLength(a0),AUD2LEN(a6)    ; $00c4(a6)
                move.l  chan_ptrInstrumentSampleRepeat(a0),AUD2LC(a6)     ; $00c0(a6)



                ; IN: D0 = DMA/interrupt bits (channel enabled)
                ; IN: D1 = master volume mask 1
do_channel_4
                lea.l   channel_03_status,a0                     ;$4126,a0
                move.w  d1,d3
.chk_volume_mask 
                btst.b  #$0006,chan_ActiveCommandBits(a0)
                beq.b   .use_volume_mask_1                      ; L00004990
.use_volume_mask_2 
                move.w  d2,d3
.use_volume_mask_1
                and.w   chan_noteVolume(a0),d3
.set_volume
                move.w  d3,AUD3VOL(a6)                          ; $00d8(a6)
.set_pitch
                move.w  chan_notePeriodValue(a0),AUD3PER(a6)   ; $00d6(a6)
.chk_new_sample 
                btst.l  #$0003,d0
                beq.b   .set_sample_2                           ; L000049b2
.set_sample_1 
                move.w  chan_instrumentSampleLength(a0),AUD3LEN(a6)    ; $00d4(a6)
                move.l  chan_ptrInstrumentSampleStart(a0),AUD3LC(a6)     ; $00d0(a6)
                bra.b   do_enable_dma                           ; L000049be
.set_sample_2 
                move.w  chan_instrumentRepeatLength(a0),AUD3LEN(a6)    ; $00d4(a6)
                move.l  chan_ptrInstrumentSampleRepeat(a0),AUD3LC(a6)     ; $00d0(a6)


                ; Enable channel DMA
do_enable_dma
                or.w    #$8000,d0                               ; d0 = add SET flag to Audio DMA
                move.w  d0,DMACON(a6)                           ; $0096(a6) ; enable Audio DMA

                clr.w   audio_dma                               ; L0000417c ; Clear Audio DMA Changes - for next processing loop
                rts




                ;------------------- initislise music samples --------------------
                ; extract sample data ptrs and lengths from the IFF sample
                ; data.
                ;
                ; IN: a0    - music sample table address $4D52 - iff_sample_data_table
                ; IN: a1    - music/song instrument data $4BFA - instrument_data_table
                ;
_initialise_instrument_data_table                                        ; original routine address L000049cc
                move.l  (a0)+,d0                        ; d0 = sound sample byte offset
                beq.b   .exit                           ; if d0 == 0 then exit
                move.w  (a0)+,instrument_volume(a1)          ; copy sample volume
                move.w  (a0)+,instrument_disable_transpose(a1)  ; copy param value2 (unknown, 0 or -1)
                move.l  a0,-(a7)                        ; save a0 - incremented ptr to stack
                                                        ; d0 is offset to data within the structure
                lea.l   -8(a0,d0.l),a0                  ; a0 = ptr to start of iff sample 'FORM' structure. #$f8 = -8
                move.l  $0004(a0),d0                    ; d0 = Length of 'FORM' data structure (sample data)
                addq.l  #$08,d0                         ; d0 = alter length to include 'FORM' and length header value, d0 = total file len from A0.
                bsr.w   process_instrument              ; calls L000049ec
                movea.l (a7)+,a0                        ; a0 = next sample table entry
                bra.b   _initialise_instrument_data_table                ; jmp L000049cc ; loop for next sample data.
.exit
                rts     



                ; ------------------ process instrument  ----------------
                ; IN: A0 = ptr to start of 'FORM' block of sample data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of sample including headers.
                ;
process_instrument                                      ; original routine address L000049ec
                move.l  a1,-(a7)                        ; Save ptr to Instrument Details
                bsr.w   process_sample_data             ; calls L00004a30
                movea.l (a7)+,a1                        ; Restore ptr to Instrument Details
                addq.l  #$02,a1                         ; a1 = skip first param value (volume) offset 0-1
                movea.l sample_vhdl_ptr,a0              ; L00004b3e,a0
                move.l  (a0)+,d0                        ; d0 = sample length length
                bclr.l  #$0000,d0                       ; d0 = make length even
                move.l  (a0)+,d1                        ; d1 = sample repeat length 
                bclr.l  #$0000,d1                       ; d1 = make repeat length even
                movea.l sample_body_ptr,a0              ; a0 = start of sample data, $00004b64,a0
                move.l  a0,(a1)+                        ; store sample start address in instrument table offset 2-5
                adda.l  d0,a0                           ; a0 = start of repeat section of sample
                add.l   d1,d0                           ; d0 = total length of sample + repeat
                lsr.l   #$01,d0                         ; d0 = count of word length
                move.w  d0,(a1)+                        ; store sample length (words) in table offset 6-7
                tst.l   d1                              ; test repeat length
                bne.b   .set_repeat
.no_repeat
                lea.l   silient_repeat,a0               ; $00004d3a,a0 ; set default 0 value for silent repeat
                moveq   #$02,d1                         ; set single word length for silent repeat.
.set_repeat
                move.l  a0,(a1)+                        ; set repeat start address in table offset 8 - 11
                lsr.l   #$01,d1                         ; d1 = repeat length (words)
                move.w  d1,(a1)+                        ; set repeat length (words) in table offset 12-13
                addq.l  #$02,a1                         ; update instrument table ptr (skip param 2 - unknown 0 or -1 value) - 14-15
                rts  



                ;------------------ process sample data --------------------------
                ; Walks through the IFF 8SVX file format, storing the pointers to
                ; the BODY and VHDL chunks in the variables.
                ;
                ; Also, sets the error/status 'sample_status' - 0 = success
                ;
                ; IN: A0 = ptr to start of 'FORM' or 'CAT ' block of sample data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of sample including headers.
                ;
sample_status                                   ; original variable address L00004a2e
                dc.w    $0000                   ; error/status flag
                                                ; 1 = missing FORM/CAT chunk
                                                ; 2 = missing 8SVX chunk

process_sample_data                             ; original routine address L00004a30
                clr.w   sample_status           ; L00004a2e 
                movem.l d0/a0,-(a7)
                bra.w   process_inner_chunk
process_inner_chunk
                tst.l   d0                      ; test sample length
                beq.b   .exit
                move.l  (a0)+,d1                ; d1 = Chunk Name
                subq.l  #$04,d0                 ; d0 = remaining bytes
                bsr.w   process_sample_chunk    ; calls L00004a50 ; process iff chunks
                bra.b   process_inner_chunk     ; jmp L00004a3c ; loop while data remaining
.exit                                           ; original address $00004a4a
                movem.l (a7)+,d0/a0
                rts



                ;------------------ process sample chunk ------------------
                ; process IFF sample data, top level of file structure.
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of sample including headers.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
process_sample_chunk                            ; original routine address L00004a50
                cmp.l   #'FORM',d1               ; #$464f524d,d1
                beq.w   process_form_chunk      ; jmp L00004aac ; process FORM chunk
                cmp.l   #'CAT ',d1               ; #$43415420,d1
                beq.w   process_cat_chunk       ; jmp L00004a6e ; process CAT chunk
                move.w  #$0001,sample_status    ; L00004a2e ; error status flag?
                clr.l   d0                      ; clear remaining byte length
                rts



                ;--------------------- process CAT chunk --------------------------
                ; skips header and continues processing inner chunk data.
                ;
                ; IN: A0 = ptr to length of chunk data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of outer chunk.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
process_cat_chunk                               ; original routine address L00004a6e
                movem.l d0/a0,-(a7)
                move.l  (a0)+,d0                ; d0 = chunk length
                move.l  d0,d1                   ; d1 = chunk length
                btst.l  #$0000,d1               ; test odd/even length
                beq.b   .no_pad_byte            ; is even, no pad byte
.add_pad_byte                                   ; addr $4a7c
                addq.l  #$01,d1                 ; is odd, add pad byte
.no_pad_byte                                    ; addr $4a7e
                addq.l  #$04,d1                 ; add length field to chunk len
                add.l   d1,$0004(a7)            ; update address ptr on stack (end of chunk)
                sub.l   d1,(a7)                 ; subtract chunk length from remaining bytes on stack
                addq.l  #$04,(a0)
                subq.l  #$04,d0                 ; subtract remaining bytes
                bra.b   process_inner_chunk     ; jmp L00004a3c



                ;------------------- process LIST chunk -----------------
                ; skip the list chunk, and continue processing
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of remaining data.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
process_list_chunk                              ; original addr $00004a8c
                movem.l d0/a0,-(a7)
                move.l  (a0)+,d0
                move.l  d0,d1
                btst.l  #$0000,d1
                beq.b   .no_pad_byte
.add_pad_byte                                   ; addr $4a9a
                addq.l  #$01,d1
.no_pad_byte                                    ; addr $4a9c
                addq.l  #$04,d1
                add.l   d1,$0004(a7)
                sub.l   d1,(a7)
                nop
                movem.l (a7)+,d0/a0
                rts



                ;---------------- process FORM chunk ------------------
                ; Expects to find an '8SVX' inner chunk of data.
                ; If not, then sets error/status flag = $0002
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of sample including headers.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;

process_form_chunk                           ; original routine address L00004aac
                movem.l d0/a0,-(a7)
                move.l  (a0)+,d0                ; d0 = length of FORM data
                move.l  d0,d1                   ; d1 = length of FORM data
                btst.l  #$0000,d1               ; check of length is odd
                beq.b   .no_pad_byte            ; even length (no pad byte required)
.add_pad_byte                                   ; addr $4aba
                addq.l  #$01,d1                 ; odd length (add pad byte)
.no_pad_byte                                    ; addr $4abc
                addq.l  #$04,d1                 ; add length field to chunk len
                add.l   d1,$0004(a7)            ; update address ptr on stack (end of chunk)
                sub.l   d1,(a7)                 ; subtract chunk length from remaining bytes on stack
                move.l  (a0)+,d1                ; d1 = inner chunk identifer
                subq.l  #$04,d0                 ; d0 = updated remaining bytes
                cmp.l   #'8SVX',d1               ; #$38535658,d1
                beq.w   process_8svx_chunk      ; jmp L00004ade ; process 8SVX chunk
                move.w  #$0002,sample_status    ; L00004a2e ; error/status flag
                movem.l (a7)+,d0/a0
                rts



                ;------------------ process 8SVX chunk ---------------------
                ; loops through sample data until no bytes remaining.
                ; processes inner chunks of 8SVX chunk, including:-
                ;  - VHDL, BODY, NAME, ANNO
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of remaining data.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
process_8svx_chunk                                      ; original address $00004ade
                tst.l   d0                              ; test end of sample data
                beq.b   .exit                           ; if so, then exit
                move.l  (a0)+,d1                        ; d1 = inner chunk identifier
                subq.l  #$04,d0                         ; d0 = updated remaining bytes
                bsr.w   process_inner_8svx_chunk        ; calls $00004af2
                bra.b   process_8svx_chunk              ; jmp L00004ade ; loop until no bytes remaining.
.exit                                                   ; addr $4aec
                movem.l (a7)+,d0/a0                     ; exit
                rts



                ;---------------- process inner 8SVX chunk --------------
                ; process data held inside the 8SVX chunk, this is only
                ; concerned with the VHDL and BODY chunks. it skips
                ; other chunks such as the NAME, ANNO meta data chunks.
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of remaining data.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
process_inner_8svx_chunk                                ; original routine address L00004af2
                cmp.l   #'FORM',d1                       ;#$464f524d,d1
                beq     process_form_chunk              ; jmp L00004aac
                cmp.l   #'LIST',d1                       ;#$4c495354,d1
                beq.b   process_list_chunk              ; jmp L00004a8c
                cmp.l   #'CAT ',d1                       ;#$43415420,d1
                beq.w   process_cat_chunk               ; jmp L00004a6e
                cmp.l   #'VHDR',d1                       ;#$56484452,d1
                beq.w   process_vhdl_chunk              ; jmp L00004b42
                cmp.l   #'BODY',d1                       ;#$424f4459,d1
                beq.w   process_body_chunk              ; L00004b68
.skip_unused_chunks                                     ; addr $4b20
                movem.l d0/a0,-(a7)
                move.l  (a0)+,d0
                move.l  d0,d1
                btst.l  #$0000,d1
                beq.b   .no_pad_byte
.add_pad_byte                                           ; addr $4b2e
                addq.l  #$01,d1
.no_pad_byte                                            ; addr $4b30
                addq.l  #$04,d1
                add.l   d1,$0004(a7)
                sub.l   d1,(a7)
                movem.l (a7)+,d0/a0
                rts



                ;-------------------- process VHDL chunk ----------------------
                ; stores address of VHDL chunk in variable 'sample_vhdl_ptr'
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of remaining data.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
sample_vhdl_ptr                                 ; original var address L00004b3e
                dc.l    $00017F66               ; original address L00004b3e

process_vhdl_chunk                              ; original address L00004b42
                movem.l d0/a0,-(a7)
                move.l  (a0)+,d0                ; d0 = length of chunk
                move.l  d0,d1                   ; d1 = length of chunk
                btst.l  #$0000,d1               ; is pad byte required (odd length)
                beq.b   .no_pad_byte            ; no pad byte (length is even)
.add_pad_byte                                   ; addr $4b50
                addq.l  #$01,d1                 ; add pad byte (make length even)
.no_pad_byte                                    ; addr $4b52
                addq.l  #$04,d1                 ; update chunk length (include length field)
                add.l   d1,$0004(a7)            ; update A0 data ptr on stack (end of chunk)
                sub.l   d1,(a7)                 ; update d0 remaining data on stack
                move.l  a0,sample_vhdl_ptr      ; L00004b3e ; store address of VHDL chunk
                movem.l (a7)+,d0/a0
                rts



                ;------------------------- process body chunk ------------------------
                ; store address of the raw sample data in variable 'sample_body_ptr'
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of remaining data.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
sample_body_ptr                                 ; original var address L0004b64
                dc.l    $00017FBA               ; body data ptr (raw sample data)

process_body_chunk                              ; original routine address L0004b68
                movem.l d0/a0,-(a7)
                move.l  (a0)+,d0                ; d0 = body length
                move.l  d0,d1                   ; d1 = body length
                btst.l  #$0000,d1               ; check for odd length
                beq.b   .no_pad_byte            ; even length (no pad byte)
.add_pad_byte                                   ; addr $4b76
                addq.l  #$01,d1
.no_pad_byte                                    ; addr $4b78
                addq.l  #$04,d1                 ; update chunk length (include length field)
                add.l   d1,$0004(a7)            ; update A0 data ptr on stack (end of chunk)
                sub.l   d1,(a7)                 ; update d0 remaining data on stack
                move.l  a0,sample_body_ptr      ; L0004b64 ; store address of raw sample data
                movem.l (a7)+,d0/a0
                rts


                ; ---------------------------- include sound driver data structures -----------------------------
                ; Runtime Audio Channel Data Structures for the Sound Driver.
                ;   - Various Runtime State Variables
                ;   - Note Pitch/Period Table
                ;   - Instrument Table (i.e. sound samples, volume & repeat values etc)
                ;   - Module Table (The populated Addresses of ther Current Sound Module)
                ;   - Channel_00_Status - Audio Channel 00 Status Data Structure
                ;   - Channel_01_Status - Audio Channel 01 Status Data Structure
                ;   - Channel_02_Status - Audio Channel 02 Status Data Structure
                ;   - Channel_03_Status - Audio Channel 03 Status Data Structure
                ;
                include     sounddriver_datastructures.i


     ENDC

     