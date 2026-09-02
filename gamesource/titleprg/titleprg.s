             
                ; Title Screen
                ; ------------
                ; Title_Screen_Start            - $0001c000   - First Game Title Screen Start
                ;                               - $0001c004   - End Game Title Screen Start (Game Over/Game Completion)
                ;
                ;
                ; Music Player
                ; ------------
                ; SoundDriver_Initialise        - $00004000
                ; SoundDriver_Stop_All          - $00004004
                ; SoundDriver_Init_Song         - $00004010 - D0.l = Song Number to play (0-3, 0 = stop playing)
                ; SoundDriver_VBlankUpdate      - $00004018 - Call every frame/cycle to play song
                ;
                ;
                ; VSCode Plugins
                ;----------------
                ; Requires the 'amiga assembly' plugin in order to build and run.
                ;
                ;
                ; VSCode Test Build
                ;-------------------
                ; - 1) Ensure that the 'TEST_TITLEPRG' defintion below is defined.
                ;
                ; - 2) Select the 'Run/Start Debugging' or 'Run/Start without debugging' option from the menu.
                ;
                ;
                ; Absolute Build
                ;----------------
                ; - 1) Comment out the 'TEST_TITLEPRG' definition below.
                ;
                ; - 2) Run the Task 'amigaassembly: build-absolute'
                ;       - This will create an absolte file org $3FFC called 'titleprg.o' in the /build folder
                ;
                ; - 3) This binary file can then be crunched with shrinkler or zxo and copied to the rellevent .adf fr testing.
                ; 


                section titleprg_iff,code_c
                ;opt     o-

                incdir  "include"
                include "sounddriver.s"


SOUND_TITLE_TUNE    EQU  $1
SOUND_JOKER_LAUGH   EQU  $2
SOUND_BATMAN_SPEACH EQU  $3
SOUND_MIN_SOUND_ID  EQU  SOUND_TITLE_TUNE
SOUND_MAX_SOUND_ID  EQU  SOUND_BATMAN_SPEACH

                ;--------------------- includes and constants ---------------------------
                INCDIR  "include"
                INCLUDE "hw.i"

TEST_TITLEPRG SET 1             ; run a test build with imported GFX
DEBUG_TYPER   SET 1             ; when set - updated text type on the title screen.
VBLANK_FIX    SET 1             ; Implement VBLANK FIX (remove processor wait from raster wait routine) 
TEST_JOKER    SET 1             ; start with joker screen, comment out to start with batman screen


        IFND TEST_TITLEPRG
                org     $3ffc                                           ; original load address $3FFC
        ENDC


        IFND TEST_TITLEPRG
DISPLAY_BITPLANE_ADDRESS        EQU     $63190                          ; address of display bitplanes in memory
ASSET_CHARSET_BASE              EQU     $3f1ea                          ; address of charset in memory
JOKER_GFX                       EQU     $49C40
BATMAN_GFX                      EQU     $56460
        ELSE
DISPLAY_BITPLANE_ADDRESS        EQU     test_display
ASSET_CHARSET_BASE              EQU     test_bitplanes-$4c                 ; address of charset in memory
JOKER_GFX                       EQU     test_bitplanes+$AA06
BATMAN_GFX                      EQU     test_bitplanes+$1722A
        ENDC



        IFD TEST_TITLEPRG  

kill_system
                lea     $dff000,a6
                move.w  #$7fff,INTENA(a6)
                move.w  #$7fff,DMACON(a6)
                move.w  #$7fff,INTREQ(a6)   
                lea     kill_system,a7                              ; initialise stack 
                bsr     init_system

.start_title_screen
               ;jmp     title_screen_start                      ; Entry point $0001c000
               jmp     end_game_start

                include "initsystem.s"

        ENDC


                ;-------------------------- title prg start -----------------------------
                ; The original binaries of the game start with a long word that provide
                ; the load/address of the file.
titleprg_start
        dc.l    $00004000                                       ; original start address $00003FFC





                ;****************************************************************************************************************
                ;****************************************************************************************************************
                ;****************************************************************************************************************
                ;
                ;
                ;               NEW ENTRY POINT TO TITLE SCREEN 
                ;               Added to have known entry points into the title screen (updated new loader to compensate)
                ;
                ;
                ;****************************************************************************************************************
                ;****************************************************************************************************************
                ;****************************************************************************************************************
                ;------------------------ TITLE SCREEN ENTRY POINT ---------------------------
                ;jmp   title_screen_start                        ; original address jmp $0001c000
                ;-------------------- GAME OVER/COMPLETION ENTRY POINT -----------------------
                ;jmp   end_game_start                            ; original address jmp $0001c006




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
               ;    PRIVATE void _do_sounddriver_initialise(void)
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
                    movea.l   $0002(a4),a3
                    cmpa.w    #$0000,a3
                    bne.b     .process_track_commands_loop
                    move.w    #$0001,$004a(a4)
                    move.w    #$0000,$004c(a4)
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

               even               ; Audio DMA Value
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




                ; ---------------------------- include sound driver data structures -----------------------------
                ; Runtime Audio Channel Data Structures for the Sound Driver.
                ;   - Channel_00_Status - Audio Channel 00 Status Data Structure
                ;   - Channel_01_Status - Audio Channel 01 Status Data Structure
                ;   - Channel_02_Status - Audio Channel 02 Status Data Structure
                ;   - Channel_03_Status - Audio Channel 03 Status Data Structure
                even
                include     sounddriver_datastructures.s


                even
                ; COMMAND TABLE - 
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



MUSIC_MODULE_DATA

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
          ; The data structure is not quite self contained and portable, in order to do this the data would have to be fronted with a table of
          ; offests into the data block, something like:-
          ;
          ;    +-------------------+
          ;    | Table Offsets     |
          ;    +-------------------+
          ;    | SampleTableOffset |
          ;    | SoundTableOffset  |
          ;    | ADSRTableOffset   |
          ;    | ArpTableOffset    |
          ;    | ModTableOffset    |
          ;    +-------------------+
          ;
          ; Would also require a little code and some data pointers to populate with the addresses of these tables when initialisng the 
          ; Sound Driver.
          ;


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
TRKCMD_LOOP_OR_END       EQU $80
TRKCMD_SET_LOOP_START    EQU $81
TRKCMD_PATTERN_TRANSPOSE EQU $82
TRKCMD_PATTERN_REPEAT    EQU $83



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
PTNCMD_END_OR_LOOP            EQU $80        ; (1 byte command) - no parameters
PTNCMD_LOOP_START             EQU $81        ; (1 byte command) - no parameters

PTNCMD_NOP                    EQU $82        ; (1 byte command) - no parameters
PTNCMD_NOP2                   EQU $83        ; (1 byte command) - no parameters

PTNCMD_PAIRED_NOTES_START     EQU $84        ; (2 byte command) - 1 parameter, duration of following pair of notes, followed by a list of 2 notes (pairs)
PTNCMD_PAIRED_NOTES_END       EQU $85        ; (1 byte command) - no parameters

PTNCMD_EXTEND_NOTE_DURATION   EQU $86        ; (1 byte command) - extend note duration by 256 ticks
PTNCMD_PAUSE_TRACK            EQU $87        ; (2 byte command) - 1 parameter, pause duration in ticks
PTNCMD_PORTOMENTO             EQU $88        ; (3 byte command) - 2 parameters, +- Interval, Slide Speed.

PTNCMD_LEADIN_NOTE_START      EQU $89        ; (3 byte command) - 2 parameters, +- Interval, Length Ticks
PTNCMD_LEADIN_NOTE_STOP       EQU $8A        ; (1 byte command) - no parameters

PTNCMD_MODULATION_START       EQU $8B        ; (4 byte command) - 3 parameters, Delay Ticks, Amount of Modulation, Rate of Modulation
PTNCMD_MODULATION_STOP        EQU $8C        ; (1 byte command) - no parameters

PTNCMD_ARPEGGIO_START         EQU $8D        ; (1 byte command) - 1 parameter, index into Arpeggio table
PTNCMD_ARPEGGIO_STOP          EQU $8E        ; (1 byte command) - no parameters

PTNCMD_ADSR_ENVELOPE          EQU $8F        ; (2 byte command) - 1 parameter, index into ADSR envelope table
PTNCMD_SELECT_INSTRUMENT      EQU $90        ; (2 byte command) - 1 parameter, index into instrument table


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




  
                ;------------------------ TITLE SCREEN ENTRY POINT ---------------------------
                ; original address hardcoded to $1c000, 
                ; I may change this so that the jump table is placed at $4000-$0c
                ; to create a jump table that starts at $3FF4 but this will require an update
                ; to the new game loader to change the start jmp addresses of the title screen
                ; and return to title screen loader methods.
                ; I want to keep this file as 'original' as possible and anyy changes wil be
                ; made in separate project.
                ;
title_screen_start                                              ; original routine address $0001c000
                bra.w   do_title_screen_start                   ; jmp $0001c008 



                ;-------------------- GAME OVER/COMPLETION ENTRY POINT -----------------------
end_game_start                                                  ; original routine address $0001c004
                bra.w   do_return_to_title_screen               ; jmp $0001d450




PANEL_INITIALISE_PLAYER_SCORE   EQU     $0007c81c               ; address of Panel.Initialise_Player_Score
PANEL_INITIALISE_PLAYER_LIVES   EQU     $0007c838               ; address of Panel.Initialise_Player_Lives
PANEL_STATUS_1                  EQU     $0007c874               ; address of Panel.Panel_Status_1  
PANEL_STATUS_2                  EQU     $0007c875               ; address of Panel.Panel_Status_2 
PANEL_HIGHSCORE                 EQU     $0007c878               ; address of Panel.High_Score 
PANEL_PLAYERSCORE               EQU     $0007c87c               ; address of Panel.Player_Score
LOADER_LOAD_LEVEL_1             EQU     $824                    ; address of Loader.Load_Level_1()

PANEL_STATUS_2_INFINITE_LIVES   EQU     $7                      ; panel status 2: bit 7 = 1 (infinite lives on)
PANEL_STATUS_2_GAME_COMPLETED   EQU     $6                      ; game completed = 1
PANEL_STATUS_2_GAME_OVER        EQU     $5                      ; game over/completion  - return from game
PANEL_STATUS_2_MUSIC_SFX        EQU     $0                      ; Music/SFX (0 = music, 1 = sfx)



                ;---------------------------- do title screenn start ----------------------------
                ; Routine to set up & run the title screen the first time the game is started.
                ; the routine 'return_to_title_screen' is called after game over/completion. 
                ;
                ; Sets Window start to bottom of screen (probably for scroll up routine)
                ; H/w Ref, standard DIWSRT & DIWSTOP
                ; PAL - $2c81, $2cc1
                ; NTSC- $2c81, $f4c1
                ;
do_title_screen_start                                           ; original routine address $0001c008
                clr.l   PANEL_HIGHSCORE                         ; clear Panel.HighScore
                move.l  highscore_table,PANEL_HIGHSCORE         ; set Panel.HighScore to top high-score
                ; continue as 'return_to_title_screen' below




                ;------------------------- return to title screen ----------------------------
                ; called after game over/compltion to return to the title screen.
                ;
return_to_title_screen                                          ; original address $0001c018
                lea.l   temp_stack_top,a7                       ; set temp stack space - $0001d6de,a7

.init_display_window                                            ; Initialise Window Scroll (start window = bottom of NTSC display)
                move.b  #$f4,copper_diwstrt                     ; reset window start line (usually $2c) - $0001d6e8
                move.b  #$f4,copper_diwstop                     ; reset widndow stop line (usually $2c or $f4 PAL/NTSC ) - $0001d6ec
.wait_frame
                moveq   #$01,d0                                 ; d0 = frames to wait + 1
                bsr.w   raster_wait_161                         ; wait for raster 161 - $0001c2f8
.init_system
                bsr.w   initialise_title_screen                 ; calls $0001c0d8
.init_display
                move.w  #$5000,$00dff100                        ; set 5 bitplane screen - BPLCON0
                lea.l   title_screen_colors,a0                  ; $0001d79a - screen colours
                bsr.w   copper_copy                             ; calls $0001d3a0
.init_game_status
                and.w   #$f89f,PANEL_STATUS_1                   ; clear panel status bits (panel status 1 & 2)
                                                                ; low 3 bits of status 1 (game over, life lost, timer expired)
                                                                ; bits 6 & 5 of status 2 (don't know what these do yet) - Think it's end game flags (success/fail etc)
.init_music
                bsr.w   init_title_music                        ; calls $0001c1a0 ; Play Song 01 (Title Tune)
.init_background
                bsr.w   copy_title_screen_bitplanes             ; calls $0001ca34 - copy title screen bitplanes to display memory (copper list display)


                ;************ TITLE SCREEN WAIT LOOP *****************
                ; Manage hi-score entry and text typer display.
                ; The text typer controls the main title-screen wait
                ; loop, waits for joystick button press to jump
                ; to 'start_game' below.
.title_screen_loop
                bsr.w   hi_score_and_text_typer                 ; calls $0001c586


                ;************* START GAME - LOAD LEVEL 1 *************
                ;text typer jumps out to here when start button pressed
start_game                                                      ; original address $0001c05e
                not.w   start_game_flag                         ; invert bits, value not used anywhere else in the title screen. $0001c09c
.wait_diwstrt
                cmp.b   #$f4,copper_diwstrt                     ; L0001d6e8
                bne.b    .wait_diwstrt                          ; if starting before title screen has openned, then wait 
.wait_frame
                moveq   #$01,d0                                 ; d0 = frames to wait + 1
                bsr.w   raster_wait_161                         ; wait for raster 161 - $0001c2f8
.init_game
                move.l  highscore_table,PANEL_PLAYERSCORE       ; set player score in panel to high score (reset next)
                jsr     PANEL_INITIALISE_PLAYER_SCORE           ; calls Panel.Initialise_Player_Score
                jsr     PANEL_INITIALISE_PLAYER_LIVES           ; calls Panel.Initialise_Player_Lives
                jsr     SoundDriver_StopSound                              ; calls $00004008
.load_level_1
                jmp     LOADER_LOAD_LEVEL_1                     ; jmp $00000824 - Loader.Load_Level_1




                ;---------------------- fatal error --------------------
                ; loop forever increment backgounr colour in tight loop
                ; UNUSED CODE
fatal_error
                jmp     do_fatal_error                          ; jmp $0001d542 



start_game_flag                                                 ; original address $0001c09c
                dc.w $0000                                      ; bits are inverted (not.w) on game_start 





                ;------------------------- do window scroll -------------------------
                ; called from level 3 interrupt handler, manages the title screen
                ; window scroll up (on title screen start) and the scroll down
                ; (on game start).
                ;
                ; The window scrolls in at 1 raster per call.
                ; The window scrolls out at 4 rasters per call.
                ;
do_window_scroll
                tst.w   start_game_flag                         ; test if game has started, $0001c09c
                bne.b  do_scroll_down                           ; jmp L0001c0ba
.do_scroll_up                                                   ; original address $0001c0a6
                cmp.b   #$2c,copper_diwstrt                     ; test window start position byte, $0001d6e8 
                beq.b   .exit                                   ; if window is fully 'open' (scrolled to top), jmp $0001c0b8
                sub.w   #$0100,copper_diwstrt                   ; else, scrol window top up by 1 raster line, $0001d6e8
.exit
                rts  

do_scroll_down                                                 ; original address $0001c0ba
                cmp.b   #$f4,copper_diwstrt                     ; test if window top is at bottom of display, $0001d6e8
                beq.b   .exit                                   ; if yes, then exit
                bcs.b   .scroll_down                            ; if no, then scroll down
.already_down
                move.b  #$f0,copper_diwstrt                     ; if somewhere near, set at the bottom
.scroll_down
                add.w   #$0400,copper_diwstrt                   ; scroll window top down by 4 raster lines, $0001d6e8
.exit
                rts 




                ;--------------------------- initialise title screen ----------------------------
                ; set up the system, interrupts annd display.
                ; NB: Level 6 interrupt enabled, but no handler (set previously in disk loader)
                ;
initialise_title_screen                                         ; original routine address $0001c0d8
                move.l  #$f481f4c1,$00dff08e                    ; DIWSTRT/DIWSTOP - Initialise
                move.w  #$7fff,d0       
                move.w  d0,$00dff096                            ; DMACON - DMA off
                move.w  d0,$00dff09a                            ; INTENA - Interrupts off
                move.w  d0,$00dff09c                            ; INTREQ - Clear Interrupt Requests
                move.l  #level_1_interrupt_handler,$00000064    ; Level 1 Interrupt Vector
                move.l  #level_2_interrupt_handler,$00000068    ; Level 2 Interrupt Vector           
                move.l  #level_3_interrupt_handler,$0000006c    ; Level 3 Interrupt Vector   
                move.l  #level_4_interrupt_handler,$00000070    ; Level 4 Interrupt Vector        
                move.l  #level_5_interrupt_handler,$00000074    ; Level 5 Interrupt Vector
                move.w  #$e028,$00dff09a                        ; PORTS/TIMERS(2),VERTB(3),EXTER(6),INTEN,SET/CLR (no level 1,4,5) !No Level 6 handler
                move.w  #$83c0,$00dff096
                move.l  #copper_list,$dff080                     ;#$0001d6e2,$00dff080
                move.w  d0,$00dff088
                move.b  #$7f,$00bfed01
                move.b  #$7f,$00bfed01

               lea      MUSIC_MODULE_DATA,a0
               jsr      SoundDriver_Initialise                   ; calls $00004000
                
                move.l  #$00001f40,d0                           ; d0 = bitplane size in bytes (8000)
                bra.w   reset_title_screen_display              ; calls $0001d2de

clear_keycode_and_exit                                          ; original address $0001c16a
                clr.w   raw_key_code_store                      ;$L0001c2f0 - clear raw keycode store
global_rts                                                      ; original address $0001c170
                rts                                             ; called from elsewhere.




                ;------------------- Do Title Screen Menu Options --------------------
                ; check for key presses and do menu screen menu options.
                ; called from typer main loop when waiting for start game.
                ;
                ;       F2 = Music/SFX toggle 
                ;       
do_title_screen_menu_options                                            ; original routine address $0001c172
                btst.b  #$0000,raw_keyboard_serial_data_byte            ; is last key code - key up? $0001c2ed
                bne.w   clear_menu_flag_and_exit                        ; no, clear menu flag and exit, $0001c1b8
                tst.w   menu_keypress_flag                              ; $0001c2f2
                bne.w   global_rts                                      ; jmp $0001c170
.check_f2                                                               ; original address $0001c188
                cmp.w   #$005c,raw_keyboard_serial_data_word            ; compare 'F2' key press, $0001c2ec 
                bne.b   clear_menu_flag_and_exit                        ; no, clear menu flag and exit, $0001c1b8
.is_f2               
                not.w   menu_keypress_flag                              ; toggle flag. $0001c2f2
                bchg.b  #PANEL_STATUS_2_MUSIC_SFX,PANEL_STATUS_2        ; $0007c875

                ; fall through to init_title_music (toggle on/off)




                ;------------------- Init Title Music -----------------
init_title_music                                                        ; original routine address $0001c1a0
                btst.b  #PANEL_STATUS_2_MUSIC_SFX,PANEL_STATUS_2        ; music or sfx bit of panel_status_2 
                beq.b   .init_song_01 
                jmp     SoundDriver_Stop_All                            ; calls $00004004 - end music
.init_song_01
                moveq   #SOUND_TITLE_TUNE,d0                                         ; set tune to play? 
                jmp     SoundDriver_Play_Song                                       ; jmp $00004010
                ; uses rts in Init_Song to return to caller.




                ;------------------ clear menu flag and exit ----------------
                ; used by the do_title_screen_menu_options routine above.
                ; clears keypress flag and exit, used to detect single
                ; keypress.
clear_menu_flag_and_exit
                clr.w menu_keypress_flag                        ; L0001c2f2
                rts




                ;----------------------- do infinite lives cheat code ----------------------
                ; This routine handles the cheat code entry, matching and toggling.
                ; It's a bit heavy for an ISR.      
                ;
                ; Called from:
                ;       level_2_interrupt_handler
                ;
do_infinite_live_cheat_code                                             ; original routine address $0001c1c0
                btst.b  #$0000,raw_keyboard_serial_data_byte            ; test lsb of raw keyboard data - $0001c2ed
                bne.w   clear_keycode_and_exit                          ; if lsb = 1 then clear $0001c2f0.w and exit (key up) - jmp $0001c16a

                tst.w   raw_key_code_store                              ; test raw keycode store - $0001c2f0
                bne.b   .exit                                           ; if keycode store is not empty, exit - jmp $0001c24a

                ; check if keycode is an expected code
                ; if so enqueue it
                ; if not then exit
.process_raw_key_code
                move.w  raw_keyboard_serial_data_word,d0                ; d0 = raw keyboard key code - $0001c2ec
                and.b   #$fe,d0                                         ; d0 = mask lsb and high byte
                move.w  d0,raw_key_code_store                           ; $0001c2f0 ; store raw key code
                lea.l   raw_key_code_table,a0                           ; $0001c258 ; raw keycode table (ends with $FFxx)

.match_keycodes_loop                                                    ; original address $0001c1ea
                cmp.b   (a0),d0
                beq.w   .enqueue_key_code                               ; $0001c1fe ; key code is in the list, pop it in the queue

.unmatched_keycode                                                      ; original address $0001c1f0
                cmp.b   #$ff,(a0)                                       ; continue checking until the end of list ($ff value is part of code - dodgy/bug)
                beq.w   .exit                                           ; then exit - jmp $0001c24a

                addq.l  #$02,a0                                         ; match next value with keycode
                bra.w   .match_keycodes_loop                            ; jmp $0001c1ea ; loop


                ; this is a queue of entered valid keycodes
                ; valid key codes are added to the end of the queue
.enqueue_key_code                                                       ; original address $0001c1fe
                move.b  $0001(a0),d1                                    ; d1 = key code table second byte match
                lea.l   keyboard_buffer_start+1,a0                        ; $0001c24d
                moveq   #$05,d0                                         ; d0 = loop counter (6 times)

.shift_chars_loop                                                       ; original address $0001c20a
                move.b  (a0),-$0001(a0)                                 ; shift bytes down in memory by 1 character
                addq.l  #$01,a0                                         
                dbf.w   d0,.shift_chars_loop                            ; $0001c20a ; Loop for all characters
                move.b  d1,keyboard_buffer_start+5                      ; $0001c251 ; d1 = key code table second byte match. add to end of queue


                ; check if cheat code has been entered 
                ; in the queue, compares against
                ; stored values.
.check_cheat_code
                lea.l   keyboard_buffer_start,a0                        ; $0001c24c
                lea.l   cheat_code,a1                                   ; $0001c252
                moveq   #$05,d0                                         ; d0 = 5 + 1 (loop counter)
.compare_loop
                cmpm.b  (a0)+,(a1)+
                bne.b   .exit                                           ; jmp $0001c24a
                dbf.w   d0,.compare_loop                                ; loop 6 times, jmp $0001c228
                ; if we get here then the secret cheat code has been entered.
                ; 'IXLLLL' - 'jammmm' - 6 char code
.toggle_infinite_lives
                bchg.b  #PANEL_STATUS_2_INFINITE_LIVES,PANEL_STATUS_2           ; #$0007,$0007c875 ; Enable CHEAT?
                move.b  #$f4,copper_diwstrt                                     ; reset title screen window (closed) $0001d6e8
                move.l  #$00001f40,d0                                           ; bitplane size in bytes (8000)
                bsr.w   reset_title_screen_display                              ; calls $0001d2de ; reset title screen display
.exit
                rts 




                ;------------------------ keyboard buffer --------------------------
                ; contains values looked up from 'raw_key_code_table' when
                ; matched with raw keycodes.
                ; it is a queue, so new data enters at the end and old data is
                ; shifted towards the front.
                ; FIFO Queue structure.
                ;
keyboard_buffer_start                                   ; original address $0001c24c
                dc.b $20,$20,$20,$20,$20,$20


                ; ------------------------ cheat code----------------------------------
                ; This is an obfuscated cheat code string. 'IXLLLL' which is compared
                ; against the keyboard buffer above when a new acceptable key is
                ; entered into the buffer. 
cheat_code                                              ; original address $0001c252
                dc.b $49,$58,$4c,$4c,$4c,$4c            ; IXLLLL 'JAMMMM'


                ;-------------------- cheat - raw key codes ----------------------
                ; key code table - used to match keys pressed with expected
                ; cheat code values.
                ; - the second byte is 
                ;
                ; - the cheat keycodes are mapped to other characters (i presume to obsuscate)
                ; - J - maps to 'I'
                ; - A - maps to 'X'
                ; - M - maps to 'L'
                ;
                ; - the cheat code matched against is then 'IXLLL'
                ;
                ; - why bother doing this is anyones guess, does anyone really care that much 
                ; - about hiding cheat codes?
                ;
raw_key_code_table
                dc.b $be,$58        ; X
                dc.b $ae,$31        ; 1            
                dc.b $92,$51        ; Q
                dc.b $90,$4C        ; L
                dc.b $D0,$20        ; ' '
                dc.b $B0,$30        ; 0
                dc.b $DA,$4A        ; J
                dc.b $B2,$49        ; I
                dc.b $CE,$46        ; F
                dc.b $94,$56        ; V
                dc.b $ff,$fe            ; inserted my own end of table loop code

;L0001c26c       dc.b $4E,$73                   ; back to code (below)
;L0001c26e       dc.b $48,$E7                   ; back to code (below)
;L0001c270       dc.b $FF,$FE                   ; back to code (below) (ends with $FFxx)













                even
                ;*********************************************************************************************************************
                ;*********************************************************************************************************************
                ;*********************************************************************************************************************
                ;
                ;
                ;       Interrupt Service Routines (ISRs)
                ;
                ;
                ;*********************************************************************************************************************
                ;*********************************************************************************************************************
                ;*********************************************************************************************************************




                ;---------------------- level 1 interrupt handler -------------------
                ; Do nothing. This should probably clear the INTREQ bits for
                ; Level 1 interrupts
                ;
                ; *** This interrupt is not enabled in the title screen ***f
                ;
level_1_interrupt_handler                                       ; original address $0001c26c
                rte




                ;---------------------- level 2 interrupt handler -------------------
                ; PORTS/TIMERS - Level 2 Interrupt Handler
                ; CIA-A Timers & Ports
                ;
                ; The ICR Register is cleared by reading the register, but this
                ; code immediately sets it back to the value it just read.
                ; The implications of this are that if this interrupt was not
                ; raised by the CIAA then bit 7 will = 0, this means that when
                ; that value is written back to the register then it will
                ; mask the interrupts that just occurred, and prevent them
                ; from occurring again.
                ;
                ; Conversly if the interrupt was raised by the CIAA then Bit 7 
                ; will be 1, this will enable the interrupt enable bit for the 
                ; interrupts that were raised. This code looks dodgy/hacky
                ;
                ; later the ICR is then set to #$08 which masks the SP bit
                ; this sets the SP bit to 0, which is the keyboard interrupt
                ; serial register bit. So this interrupt is being disabled here
                ; as far as I can make out.
                ;
                ; Obviously this works for reading the keyboard etc, but...
                ; it doesn't appear correct as per the h/w refs that I've read.
                ;
                ; This interrupt is enabled in 'initialise_title_screen' (PORTS - LVL2)
                ;
level_2_interrupt_handler                                                       ; original routine address $0001c26e
                movem.l d0-d7/a0-a6,-(a7)
                move.b  $00bfec01,raw_keyboard_serial_data_byte                 ; SDR - $0001c2ed ; keyboard serial data
                move.b  $00bfed01,$00bfed01                                     ; ICR - WTF-1!, clear the interrupt control if not a CIAA/Set Interrupts if is CIAA
                move.w  #$0808,$00dff09c                                        ; INTREQ - Clear PORTS(2), 
                                                                                ; WTF-2! - Clear RBF(5) (keyboard serial) - Level 5 Interrupt!
                move.b  #$08,$00bfed01                                          ; ICR - Mask SP bit = 0 (keyboard serial)
                move.b  #$60,$00bfee01                                          ; CRA - Timer A Control - INMODE=1, SPMODE=1
                bsr.w   do_infinite_live_cheat_code                             ; calls $0001c1c0
                movem.l (a7)+,d0-d7/a0-a6
                rte




                ;---------------------- level 3 interrupt handler -------------------
                ; Vertical blank interrupt handler.
                ;   - plays current song
                ;   - scrolls window up/down
                ;   - does hacky stuff with CIAA and keyboard port 
                ;      - reset for serial register input (end of keyboard ACK)
                ;
                ; This interrupt is enabled in 'initialise_title_screen' (VERTB)
                ;
level_3_interrupt_handler
                movem.l d0-d7/a0-a6,-(a7)
                jsr     SoundDriver_VBlankUpdate                ; $00004018 ; play song
                bsr.w   do_window_scroll                        ; calls $0001c09e
                move.b  $00bfed01,$00bfed01                     ; ICR -> ICR (why?) CIAA nothing to do with level 3 interrupts, also just looks like nonsence
                move.b  #$08,$00bfee01                          ; CIAA - CRA - one shot timer A, stop timer A, SPMODE = input (keyboard)
                move.b  #$88,$00bfed01                          ; CIAA - ICR - enable SP interrupt LVL 2 (keyboard())
                move.w  #$0020,$00dff09c                        ; Clear VERTB interrupt
                not.w   vertical_blank_toggle                   ; toggle vertical blank flag, $0001c2e8
                movem.l (a7)+,d0-d7/a0-a6
                rte  




                ;---------------------- level 4 interrupt handler -------------------
                ; Do nothing. This should probably clear the INTREQ bits for
                ; Level 4 interrupts
                ;
                ; *** This interrupt is not enabled in the title screen ***f
                ; 
level_4_interrupt_handler                                       ; original address $0001c2e4
                rte




                ;---------------------- level 5 interrupt handler -------------------
                ; Do nothing. This should probably clear the INTREQ bits for
                ; Level 5 interrupts
                ;
                ; *** This interrupt is not enabled in the title screen ***f
                ;
level_5_interrupt_handler                                       ; original address $0001c2e6
                rte




                ;---------------------- level 6 interrupt handler --------------------
                ; ***** MISSING ALTOGETHER, BUT INTERRUPTS ARE ENABLED FOR THIS *****
                ; TODO: Add a handler once i've got this assembling as is.



                even
vertical_blank_toggle                                   ; original address $0001C2E8
                dc.w $0000                              ; value appears unused by the title screen (toggled every frame)

unused_002                                              ; original address $0001C2EA
                dc.w $0000



raw_keyboard_serial_data_word                                           ; original address $0001C2EC
                dc.b $00                                                ; keyboard raw key code word (high byte always 0)
raw_keyboard_serial_data_byte                                           ; original address $0001c2ed
                dc.b $00                                                ; keyboard raw key code byte

                even
                dc.w $0000 

raw_key_code_store                                                      ; original address $0001c2f0
                dc.w $0000                                              ; keyboard reading data/flags

menu_keypress_flag                                                      ; original address $0001c2f2
                dc.w $0000                                              ; 0 = music, $ffff = sfx

                dc.w $0000, $0000




                ;------------------------- wait raster 161 -------------------------
                ; Waits for raster 161 (#$a1) in a busy loop, it will also
                ; wait for multiple frames for the value set in d0.l
                ;
                ; It has a dodgy processor wait loop which prevents false +ve's
                ; with the vertical check on the same raster line (it's a bit shit) 
                ;
                ; reading and comparing a byte value might not be the best approach
                ; on a custom register.
                ;
                ; IN: D0.l = number of frames to wait + 1
                ;
raster_wait_161                                                 ; original routine address $0001c2f8

        IFND VBLANK_FIX
.vwait 
                cmp.b   #$a1,$00dff006                          ; compare VHPOSR with #$a1 (161)
                bne.b   .vwait
                move.w  #$001e,d1
.processor_wait
                dbf.w  d1,.processor_wait
                dbf.w  d0,raster_wait_161
        ELSE
.vwait1 
                cmp.b   #$a1,$00dff006                          ; compare VHPOSR with #$a1 (161)
                bne.b   .vwait1
.vwait2 
                cmp.b   #$a2,$00dff006                          ; compare VHPOSR with #$a2 (162)
                bne.b   .vwait2
                dbf.w  d0,.vwait1
        ENDC

return_rts      rts





                even
xy_coords
x_coord                                                 ; original address L0001c310
                dc.w    $0000                           ; x co-ord (byte value)
y_coord                                                 ; original address L0001c312
                dc.w    $0000                           ; y co-ord (line value)
current_text_ptr                                        ; original address L0001c314
                dc.l    $00000000                       ; $0001c784 - address of start of text being displayed (used for looping back to start)




unused_background_flash                                 ; original routine address $0001c318
                add.w #$0001,d7
                move.w d7,$00dff180
                rts 




                ;----------------------- text typer ------------------------
                ; type out screen of text, also process control codes for
                ; special chars and inserting hi score table etc.
                ;
                ; IN: a6 - text structure for display
                ;          1 word - display co-ords (x,y bytes)
                ;          x bytes - text & display codes
                ;          1 byte  - #$ff - end text display
                ;
text_typer                                                      ; original routine address $0001c324
                move.l  a6,current_text_ptr                     ; $0001c314 ; store a6 address (used for looping when CODE #$00)
                move.b  (a6)+,x_coord+1                         ; store x coord - $0001c311
                move.b  (a6)+,y_coord+1                         ; store y coord - $0001c313

resume_text_start_line
                moveq   #$00,d0
                move.w  y_coord,d0                              ; $0001c312 ; d0 = y co-ord
                mulu.w  #$0028,d0                               ; d0 = d0 * 40 (bytes per scan line)
                add.w   x_coord,d0                              ; $0001c310 ; d0 = d0 + x co-ord
                add.l   #DISPLAY_BITPLANE_ADDRESS,d0            ; #$00063190,d0 ; add bitplane base address
                exg.l   d0,a2                                   ; a2 = display destination address
                movea.l a2,a3                                   ; a3 = display destination address

resume_text_current_position
                tst.w   typer_extended_command_1                ; $0001c782 - exension command/params (for commands #$02)
                bne.w   continue_wait_or_start_game             ; jmp $0001c50e
                move.b  (a6)+,d0                                ; get display param
                cmp.b   #$ff,d0
                beq.w   return_rts                              ; $0001c30e
                cmp.b   #$0d,d0
                beq.w   crlf                                    ; jmp $0001c4d0 - crlf - carriage return plus line feed
                cmp.b   #$0e,d0
                beq.w   lf                                      ; jmp $0001c4dc - lf, line feed
                cmp.b   #$01,d0
                beq.w   cls                                     ; jmp $0001c4e8 - clear screen
                cmp.b   #$06,d0
                beq.w   _nop                                    ; jmp $0001c580 - no operation
                cmp.b   #$02,d0
                beq.w   wait_or_start_game                      ; jmp $0001c4fe - check fire button/start game?
                cmp.b   #$03,d0
                beq.w   hi_scores                               ; jmp $0001c53e - start displaying hi score table
                cmp.b   #$04,d0
                beq.w   end_hi_scores                           ; jmp $0001c54e - resume typer after hi score table
                cmp.b   #$05,d0
                beq.w   hi_score_and_text_typer                 ; jmp $0001c586 - name up/enter initials
                cmp.b   #$40,d0
                beq.w   .copyright_symbol                       ; jmp $0001c3f6 '@' convert to 2nd character after 'Z' - (c) symbol 
                cmp.b   #$26,d0
                beq.w   .ampersand_symbol                       ; JMP $0001c3e6 '&' convert to 3rd character after 'Z' - '&' symbol
                cmp.b   #$23,d0
                beq.w   maybe_backspace                         ; jmp $0001c558 '#' symbol - unsure, decrements x offset
                cmp.b   #$2e,d0
                beq.w   .fullstop_symbol                        ; jmp $0001c3ee '.' convert to 1st character after 'Z'
                and.w   #$003f,d0
                beq.w   loop_text_typer                      ; jmp $0001c534 - #$00 = ***** Loop Text Typer ***** 
                cmp.b   #$20,d0
                beq.w   .space_symbol                           ; jmp $0001c3fe ' ' - increment x position.       
                cmp.b   #$30,d0
                blt.w   .plot_character                         ; jmp $0001c404 - plot raw char code from offset
                sub.w   #$0014,d0
                bra.w   .plot_character                         ; jmp $0001c404 - subtract ' ' char and plot raw char code

.ampersand_symbol
                move.w  #$002c,d0
                bra.w   .plot_character                         ; jmp $0001c404

.fullstop_symbol
                move.w  #$002a,d0
                bra.w   .plot_character                         ; jmp $0001c404

.copyright_symbol
                move.b  #$002b,d0                               ; d0 = 43 - character offset (plus #$30)
                bra.w   .plot_character                         ; jmp $0001c404 - 

.space_symbol
                addq.l  #$01,a3
                bra.w   resume_text_current_position            ; jmp $0001c352

.plot_character
                mulu.w  #$0050,d0
                add.l   #ASSET_CHARSET_BASE,d0                  ; #$0003f1ea,d0
                exg.l   d0,a1
                moveq   #$04,d7                                 ; d7 = 4 + 1 = 5 bitplanes
                moveq   #$00,d1
                movea.l a3,a2
.copy_loop
                move.b  (a1),(a2)                               ; copy char data - line 1
                move.b  $0002(a1),$0028(a2)                     ; copy char data - line 2
                move.b  $0004(a1),$0050(a2)                     ; copy char data - line 3
                move.b  $0006(a1),$0078(a2)                     ; copy char data - line 4
                move.b  $0008(a1),$00a0(a2)                     ; copy char data - line 5
                move.b  $000a(a1),$00c8(a2)                     ; copy char data - line 6
                move.b  $000c(a1),$00f0(a2)                     ; copy char data - line 7
                move.b  $000e(a1),$0118(a2)                     ; copy char data - line 8

                adda.l  #$00000010,a1                           ; add 16 bytes to source (next bitplane of character)
                adda.l  bitplane_size,a2                        ; increment dest to next bitplane.
                dbf.w   d7,.copy_loop                           ; bitplane loop, jmp $0001c416
                
                addq.l  #$01,a3                                 ; increment x position
                bra.w   resume_text_current_position            ; loop next char, $0001c352
                rts  




                ;--------------------- plot character x & y ----------------------
                ; plot character at x and y co-ords
                ; IN: d0 = character offset to plot starts at character '0'
                ;
char_plot_x_coord                               ; original address $0001c45a
                dc.w $0000                      ; x co-ord (byte value)
char_plot_y_coord                               ; original address $0001c45c
                dc.w $0000                      ; y co-ord (line value)

plot_character
                moveq   #$00,d3
                moveq   #$00,d2
                move.w  char_plot_y_coord,d2            ; L0001c45c,d3 ; y co-ordinate
                move.w  char_plot_x_coord,d2            ; L0001c45a,d2 ; x co-ordinate
                mulu.w  #$0028,d3                       ; d3 = d3 * 40 (raster line)
                add.w   d3,d2                           ; d2 = x & y co-ords byte offset
                add.l   #DISPLAY_BITPLANE_ADDRESS,d2    ; #$00063190 ; add bitplane 1 base address
                exg.l   d2,a2                           ; a2 = dest address, d1 = prev value of a2
                and.l   #$0000003f,d0                   ; clamp d0 to 0-63
                mulu.w  #$0050,d0                       ; 80 bytes per char (16 bytes per bitplane) 8*8
                add.l   #ASSET_CHARSET_BASE,d0           ; #$0003f1ea ; character set gfx base address
                exg.l   d0,a1                           ; a1 = character source address
                moveq   #$04,d7                         ; d7 = 4 + 1 - bitplane loop count
                moveq   #$00,d1                         ; d1 = 0
.copy_loop
                move.b  (a1),(a2)                       ; copy character data line 1
                move.b  $0002(a1),$0028(a2)             ; copy character data line 2
                move.b  $0004(a1),$0050(a2)             ; copy character data line 3
                move.b  $0006(a1),$0078(a2)             ; copy character data line 4
                move.b  $0008(a1),$00a0(a2)             ; copy character data line 5
                move.b  $000a(a1),$00c8(a2)             ; copy character data line 6
                move.b  $000c(a1),$00f0(a2)             ; copy character data line 7
                move.b  $000e(a1),$0118(a2)             ; copy character data line 8
                adda.l  #$00000010,a1                   ; a1 = start next bitplane of char
                adda.l  bitplane_size,a2                ; L0001ca3e,a2
                dbf.w   d7,.copy_loop
                rts



                ;----------------- crlf ---------------------
                ; carriage return plus line feed.
                ; continue typing at the start of the next
                ; line on the screen.
crlf                                                    ; original address $0001c4d0
                add.w   #$0008,y_coord                  ; $0001c312, add 8 scan lines to y coord
                bra.w   resume_text_start_line          ; jmp $0001c336



                ;---------------- line feed -----------------
                ; continue typing one line down without
                ; returning to the start of the line.
lf                                                      ; original address $0001c4dc
                adda.l  #$00000140,a3                   ; add 320 to raster line (next page)
                movea.l a3,a2                           ; update dest display ptrs
                bra.w   resume_text_current_position    ; jmp $0001c352



                ;--------------- clear screen --------------
                ; clear screen bitplanes and reset x,y
                ; coords.
cls
                bsr.w   copy_title_screen_bitplanes     ; calls $0001ca34
                move.w  #$0007,x_coord                  ; $0001c310
                clr.w   y_coord                         ; $0001c312 
                bra.w   resume_text_start_line          ; $0001c336 



                ;-------------- code #$02 -----------------
                ; code: #$02 - 
                ; initialise 'wait_or_start_game'
                ; get the number of frames to wait for
                ; displaying the current page of text.
wait_or_start_game                                      ; original routine address $0001c4fe
                move.b  (a6)+,d0
                move.b  d0,typer_extended_command_1     ; $0001c782
                move.b  (a6)+,d0
                move.b  d0,typer_extended_command_2     ; $0001c783
                ; falls through to 'wait_or_start_game'


                ;------------------ wait or start game ---------------
                ; continuation of the the wait_or_start_game command/
                ; decrements the counter, waits for the required number
                ; of frames.
                ;
                ; if joystick button is pressed (port 2)
                ; then jumps to start game code.
                ;
continue_wait_or_start_game
                moveq   #$00,d0
                bsr.w   raster_wait_161                 ; calls $0001c2f8
                bsr.w   do_title_screen_menu_options    ; calls $0001c172
                btst.b  #$0007,$00bfe001                ; Port 2 Fire Button (Joystick)
                beq.b   .firebutton_pressed             ; $0001c52e ; if button pressed, start game?
                sub.w   #$0001,typer_extended_command_1 ; $0001c782 - decrement fame wait time
                bra.w   resume_text_current_position    ; jmp $0001c352

.firebutton_pressed
                jmp     start_game                      ; jmp $0001c05e



                ;--------------- loop text typer -----------------
                ; CODE #$00 - restart text typer from initial
                ;             saved text prt
loop_text_typer                                                 ; original address $0001c534
                movea.l current_text_ptr,a6                     ; $0001c314 [00000000],a6
                bra.w   text_typer                              ; calls $0001c324 - display text
                ; use text_typer rts to return



                ;--------------------- hi scores -------------------
                ; CODE: #$03 - start displaying Hi Score Table
                ;
hi_scores                                                       ; original routine address $0001c53e
                move.l  a6,temp_typer_text_ptr                  ; $0001c77e ; store current text typer ptr position
                movea.l #high_score_display_text,a6             ; #$0001c974 ; resume text from this location (HI SCORE TABLE)
                bra.w   resume_text_current_position            ; jmp $0001c352



                ;-------------------end hi scores ------------------
                ; CODE: #$04 - resume typing text after hi scores
                ;
end_hi_scores                                                   ; original routine address $0001c54e
                movea.l temp_typer_text_ptr,a6                  ; $0001c77e ; restore text typer source ptr from saved location
                bra.w   resume_text_current_position            ; jmp $0001c352



maybe_backspace                                                 ; original routine address $0001c558
                move.w  x_coord,char_plot_x_coord               ; $0001c45a
                move.w  y_coord,char_plot_y_coord               ; $0001c45c
                move.b  #$20,d0
                bsr.w   plot_character                          ; calls $0001c45e
                sub.w   #$0001,x_coord                          ; $0001c310
                bra.w   resume_text_current_position            ; jmp $0001c352



                ;-------------------- nop -----------------------
                ; do nothing, just resume text typing
_nop                                                            ; original address $0001c580
                bra.w   resume_text_current_position            ; jmp $0001c352



                ;-------- dangling rts instruction --------------
                rts







                ;------------------------ hi score and text typer -------------------------
                ; If Player score is a high score then insert is into the 
                ; highscore table.
                ; enter intials.
                ; start title screen text typer loop.
                ;
hi_score_and_text_typer                                                 ; original routine address $0001c586
                lea.l   highscore_table+16,a5                           ; L0001ca28,a5 ; Lowest Hi Score (5th)
                lea.l   end_highscore_display_text,a4                   ; L0001c9fc,a4 ; end of score table display text
                moveq   #$00,d0
.score_check_loop
                move.l  (a5),d6                                         ; d6 = next lowest high score
                cmp.l   PANEL_HIGHSCORE,d6                              ; High Score/Player Score
                bgt.w   .not_high_score                                 ; jmp $0001c5ec
.is_higher_score
                ; copy score display text down the list one entry
                move.l  (a5),$0004(a5)                                  ; shift lowest high score down the table
                subq.l  #$04,a5                                         ; update pointer to next highest score
                suba.l  #$00000017,a4                                   ; #$17 (23) update pointer to next highest score (display text)
                move.b  $000a(a4),$0021(a4)                             ; copy display test down the table.
                move.b  $000b(a4),$0022(a4)
                move.b  $000c(a4),$0023(a4)
                move.b  $000f(a4),$0026(a4)
                move.b  $0010(a4),$0027(a4)
                move.b  $0011(a4),$0028(a4)
                move.b  $0012(a4),$0029(a4)
                move.b  $0013(a4),$002a(a4)
                move.b  $0014(a4),$002b(a4)
                addq.w  #$01,d0                                         ; increase index counter
                cmp.w   #$0005,d0                                       ; 5 high scores to check against
                bne.w   .score_check_loop

                ; d0 = high score entry counting from bottom of the table 1-5
.not_high_score
                tst.w   d0
                beq.w   display_title_screen_text                       ; if d0 = 0 then not an high score, jmp $0001c760

                ; a4 = text display
                ; a5 = score table
                ; d0 = score index
.is_an_high_score                                                       ; original address $0001c5f2
                move.l  (a5),$0004(a5)
                move.l  PANEL_HIGHSCORE,(a5)                            ; set high score in score table
                move.b  #$20,$000a(a4)                                  ; insert space at text display index 10 - initial 1
                move.b  #$20,$000b(a4)                                  ; insert space at text display index 11 - initial 2
                move.b  #$20,$000c(a4)                                  ; insert space at text display index 12 - initial 3

.add_score_to_table_bcd
.digits_1_and_2                                                         ; original address $0001c60e
                movem.l d0,-(a7)                                        ; save d0 (score entry index)
                move.b  $0003(a5),d0                                    ; d0 = score byte (BCD)
                move.b  d0,d1                                           ; d1 = copy score byte (BCD)
                and.b   #$0f,d0                                         ; d0 = low digit
                add.w   #$0030,d0                                       ; d0 = add Ascii base for '0'
                lsr.b   #$04,d1                                         ; d1 = second score digit
                add.w   #$0030,d1                                       ; d1 = add Ascii base for '0'
                move.b  d0,$0014(a4)                                    ; store score digit 1 - least significant
                move.b  d1,$0013(a4)                                    ; store score digit 2 - second digit

.digits_3_and_4                                                         ; original address $0001c62e
                move.b  $0002(a5),d0                                    ; d0 = score byte (BCD)
                move.b  d0,d1                                           ; d1 = copy score byte (BCD)
                and.b   #$0f,d0                                         ; d0 = low digit
                add.w   #$0030,d0                                       ; d0 = add Ascii base for '0'
                lsr.b   #$04,d1                                         ; d1 = second score digit
                add.w   #$0030,d1                                       ; d1 = add Ascii base for '0'
                move.b  d0,$0012(a4)                                    ; store score digit 1 - least significant
                move.b  d1,$0011(a4)                                    ; store score digit 2 - second digit

.digits_5_and_6                                                         ; original address $0001c64a
                move.b  $0001(a5),d0                                    ; d0 = score byte (BCD)
                move.b  d0,d1                                           ; d1 = copy score byte (BCD)
                and.b   #$0f,d0                                         ; d0 = low digit
                add.w   #$0030,d0                                       ; d0 = add Ascii base for '0'
                lsr.b   #$04,d1                                         ; d1 = second score digit
                add.w   #$0030,d1                                       ; d1 = add Ascii base for '0'
                move.b  d0,$0010(a4)                                    ; store score digit 1 - least significant
                move.b  d1,$000f(a4)                                    ; store score digit 2 - second digit

.init_enter_initials
                adda.l  #$0000000a,a4                                   ; increase text display ptr by 10 chars
                lea.l   score_y_coord_table,a0                          ; L0001c76a,a0
                movem.l (a7)+,d0                                        ; d0 = restored table entry index
                asl.w   #$01,d0                                         ; d0 = d0 * 2 (index to a0 table)
                move.w  $00(a0,d0.w),char_plot_y_coord                  ; L0001c45c - set y co-ord 
                move.w  #$0011,char_plot_x_coord                        ; L0001c45a - set x co-ord first char
                move.w  #$0003,name_initials_count                      ; L0001c776 - number of letters to enter
                move.b  #$04,high_score_6th_entry                       ; $0001C9FC - insert text typer code to not display last entry
                                                                        ; CODE #$04 makes typer End HighScore table
.display_hiscore_table
                lea.l   display_hiscores,a6                             ; L0001c96e ; (a6) = $0c30 - x,y display co-ords
                bsr.w   text_typer                                      ; $0001c324 ; type text

                moveq   #$01,d6                                         ; d6 = initialise the current displayed character(initials entry)
                bsr.w   .draw_current_character                         ; calls $0001c710 
                *** This never returns (looks like it should be a bra?) ***
                *** Enters the .initials_entry_loop ***
                *** Eventually jumps out at .end_intial_entry

.initials_entry_loop                                                    ; original address $0001c6a8
                moveq   #$04,d0
                bsr.w   raster_wait_161                                 ; calls $0001c2f8 - wait 4 frames
                clr.l   joystick_left                                   ; clear both joystick left & right flags - $0001c778
                clr.w   unused_var_flag                                 ; clear the 16 bit word - appears unused else where - $0001c77c
                move.w  $00dff00c,d0                                    ; d0 = JOT1DAT
                btst.l  #$0001,d0                                       ; joystick right (active high)
                sne.b   joystick_right                                  ; $0001c77a
                btst.l  #$0008,d0                                       ; joystick left (active high)
                sne.b   joystick_left                                   ; $0001c778

.test_joystick_button
                btst.b  #$0007,$00bfe001
                beq.w   .wait_joystick_button_released                  ; L0001c71a

                move.w  joystick_left,d0                                ; $0001c778,d0
                or.w    joystick_right,d0                               ; $0001c77a,d0
                beq.b   .initials_entry_loop                            ; no joystick input - loop, L0001c6a8

                tst.w   joystick_left                                   ; $0001c778
                bne.w   .stick_left                                     ; L0001c706

.stick_right
                cmp.w   #$001b,d6                                       ; check last character index
                beq.w   .initials_entry_loop                            ; if at last character then loop
                addq.w  #$01,d6                                         ; increment current character
                bra.w   .draw_current_character                         ; calls $0001c710

.stick_left
                cmp.w   #$0001,d6                                       ; check is at 1st character
                beq.w   .initials_entry_loop                            ; if is first character then don't update, just loop
                subq.w  #$01,d6                                         ; decrement current character

.draw_current_character                                                 ; original address $0001c710
                move.b  d6,d0
                bsr.w   plot_character                                  ; calls $0001c45e
                bra.w   .initials_entry_loop                            ; L0001c6a8

.wait_joystick_button_released
                btst.b  #$0007,$00bfe001
                beq.w   .wait_joystick_button_released                  ; L0001c71a

.increment_next_char
                add.w   #$0001,char_plot_x_coord                        ; L0001c45a - advance to next character entry
                move.b  d6,d0                                           ; d0,d6 = current character
                cmp.b   #$1c,d0                                         ; test current char = #$1c (28)
                bne.w   .not_end
                move.w  #$ffe0,d0                                       ; insert -32 (equals a space char when #$40 is added back to it below)
.not_end
                add.b   #$40,d0
                move.b  d0,(a4)+                                        ; update display text
                sub.w   #$0001,name_initials_count                      ; update next name initial index, L0001c776
                beq.w   .end_intial_entry                               ; L0001c758
                move.b  d6,d0
                bsr.w   plot_character                                  ; calls $0001c45e
                bra.w   .initials_entry_loop                            ; L0001c6a8 

.end_intial_entry                                                       ; original address $0001c758
                move.w  #$0060,typer_extended_command_1                 ; $0001c782
                ; fall through to 'display_title_screen_text' below




                ;--------------------- display title screen text -----------------------------
                ; start the text typer routine that cycles through the text displayyed over
                ; the title screen as a set of text pages. Includes the display of the 
                ; high score table etc. 
                ; strangely the typer routine also waits for the joystick button to be
                ; pressed for the start game.
                ;
display_title_screen_text                                               ; original address $0001c760
                lea.l   title_screen_text,a6                            ; $0001c784 - a6 = title screen text for display
                bra.w   text_typer                                      ; jmp $0001c324 - display text
                ; uses text_typer rts to return?




score_y_coord_table                                             ; original address $0001C76A
                dc.w $0058, $0060, $0050, $0040, $0030, $0020   ; table of y co-ord values for each line of the hi-score table on the screen, bottom to top (not sure if 1st entry is used)

name_initials_count                                             ; original address $0001C776
                dc.w $0000                                      ; count of hi-score initials entered during the entry loop. initialised to 3, exits loop when 0

; used during enter high score initial loop
joystick_left                                                   ; original address $0001C778
                dc.w $0000                                      ; joystick left (SET TRUE)
joystick_right
                dc.w $0000                                      ; joystick right (SET TRUE)

unused_var_flag                                                 ; original address $0001C77C
                dc.w $0000                                      ; cleared when joystick values are read during hi-score initials entry loop - appears unused apart from being cleared in the loop.

temp_typer_text_ptr                                             ; original address $0001c77e
                dc.l $00000000                                  ; store ptr to typer text while command types hi-score table

typer_extended_command_1                                        ; original address $0001C782
                dc.b $00
typer_extended_command_2                                        ; original address $0001C783
                dc.b $00 


title_screen_text       

                IFND DEBUG_TYPER
                                                                ; original address $0001c784
                        dc.b $01,$01                                    ; display co-ords (x,y)
                        dc.b $01                                        ; clear screen command
                        dc.b $0D,$0D,$0D,$0D,$0D,$0D                    ; #$0D = carriage return
                        dc.b '      OCEAN SOFTWARE',$0D,$0D                   
                        dc.b '         PRESENTS   ',$0D                       
                        dc.b $02,$00,$80                                ; #$02 = wait for 2.5 seconds (128 frames)

                ELSE

                        dc.b $01,$01                                    ; display co-ords (x,y)
                        dc.b $01                                        ; clear screen command
                        dc.b $0D,$0D,$0D,$0D,$0D,$0D                    ; #$0D = carriage return
                        dc.b '      OCEAN SOFTWARE',$0D,$0D                   
                        dc.b '    REBUILT FROM SOURCE   ',$0D                       
                        dc.b $02,$00,$80                                ; #$02 = wait for 2.5 seconds (128 frames)

                ENDC

                dc.b $01                                        ; #$01 = clear the screen
                dc.b $06                                        ; #$06 = No Operation (nop)
                dc.b $0D,$0D,$0D,$0D,$0D,$0D
                dc.b '          BATMAN',$0D,$0D
                dc.b '        THE MOVIE'
                dc.b $02,$00,$80                                ; #$02 = wait for 2.5 seconds (128 frames)

                dc.b $01                                        ; #$01 = clear the screen
                dc.b $0D,$0D
                dc.b '   TM & @ DC COMICS INC',$2E,$0D          ; #$2E = full stop symbol
                dc.b '           1989 ',$0D,$0D,$0D
                dc.b '   @ OCEAN SOFTWARE 1989',$0D,$0D
                dc.b '     ESC',$2E,$2E,'ABORT GAME',$0D,$0D    ; #$2E = full stop symbol
                dc.b '      F1',$2E,$2E,'PAUSE GAME',$0D,$0D
                dc.b '      F2',$2E,$2E,'TOGGLE MUSIC',$0D
                dc.b $02,$01,$00                                ; #$02 = wait for 5 (256) seconds

                dc.b $01                                        ; #$01 = clear screen
                dc.b $0D
                dc.b '   CODING BY',$0D
                dc.b '            MIKE LAMB',$0D 
                dc.b '            JOBBEEEE',$0D
                dc.b '            SHORTY',$0D,$0D
                dc.b '   GRAPHICS BY',$0D
                dc.b '            DAWN DRAKE',$0D
                dc.b '            BILL HARBISON',$0D
                dc.b '            JOHN PALMER',$0D,$0D
                dc.b '   MUSIC AND FX BY',$0D
                dc.b '            JON DUNN',$0D
                dc.b '            MATTHEW CANNON' 
                dc.b $02,$01,$00                        ; #$02 = wait for 5 (256) seconds
                
                dc.b $01                                ; #$01 = clear screen
                dc.b $03                                ; #$03 = display hi score table
                dc.b $02,$00,$f0                        ; #$02 = wait for 2.5 seconds

                dc.w $01                                ; #$01 - clear screen
                dc.b $00                                ; #$00 - loop text to start
                dc.b $FF                                ; #$ff - end typer (never reaches here)                                                     




display_hiscores                                        ; original address $0001C96E
                dc.b $0C,$30                            ; x, y               
                dc.b $01                                ; $01 - clear screen
                dc.b $0D                                ; $0D - carriage return
                dc.b $03                                ; $03 - display hi scores
                dc.b $FF                                ; $ff - end typer




                ;------------------------- HIGH SCORE DISPLAY TABLE ----------------------------
                ; The text typer displays this text when encountering CODE #$03, it ends
                ; and resumes where it left off when encountering CODE #$04.
                ; - title     = 21 chars (incl control codes)
                ; - lines 1-6 = 23 chars (incl control codes)
                ; - The 6th line entry is only used to roll the last entry into when inserting
                ;   a new high score into the table.
                ;   The insertion routine stuffs the code #$04 into the start of the 6th 
                ;   entry, preventing the text typer routine from displaying it on screen.
                ;
high_score_display_text                                                                                            ; original address $0001C974
                dc.b $20,$20,$20,$20,$20,$20,$20,$20,$20,$48,$49,$20,$53,$43,$4F,$52,$45,$53,$0D,$0D,$0D           ;         HI SCORES
                dc.b $20,$20,$20,$20,$20,$31,$53,$54,$20,$20,$41,$4A,$53,$20,$20,$31,$32,$35,$30,$30,$30,$0D,$0D   ;     1ST  AJS  125000
                dc.b $20,$20,$20,$20,$20,$32,$4E,$44,$20,$20,$4D,$49,$4B,$20,$20,$31,$30,$30,$30,$30,$30,$0D,$0D   ;     2ND  MIK  100000
                dc.b $20,$20,$20,$20,$20,$33,$52,$44,$20,$20,$4A,$4F,$42,$20,$20,$30,$37,$35,$30,$30,$30,$0D,$0D   ;     3RD  JOB  075000
                dc.b $20,$20,$20,$20,$20,$34,$54,$48,$20,$20,$42,$49,$4C,$20,$20,$30,$35,$30,$30,$30,$30,$0D,$0D   ;     4TH  BIL  050000
                dc.b $20,$20,$20,$20,$20,$35,$54,$48,$20,$20,$4A,$4F,$4E,$20,$20,$30,$32,$35,$30,$30,$30,$0D,$0D   ;     5TH  JON  025000
end_highscore_display_text                                                                                         ; original address $0001C9FC
high_score_6th_entry                                                                                               ; original address $0001C9FC - not displayed, buffer to roll last entry into
                dc.b $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$0D,$0D
                dc.b $04                        ; #$04 - typer code - resume typer after high score table




L0001CA14       dc.b $00, $00, $00, $00 
                even



                ;--------------- High Score Table -------------
                ; High score table where the top 5 scores are
                ; stored in BCD format.
                ; The 6th entry is only used to roll the
                ; last score into when inserting a new
                ; hi-score into the table.
                ;
highscore_table                                         ; original address $0001CA18
                dc.l $00125000
                dc.l $00100000
                dc.l $00075000
                dc.l $00050000
                dc.l $00025000                          ; highscore_table+16 ; original address $0001CA28                              
                dc.l $00000000                          ; highscore_table+20 ; original address $0001CA2c - not displayed, used to roll last entry into




                ; -------------- other data 1 ----------------------
                ; currently unknown/unused data
.other_data1                                            ; original address $0001CA2E
L0001CA2E       dc.w $0000, $0000                       ; **** UNUSED??? ****



                even
                ; --------------- Copy Title Screen Bitplanes ----------------
                ; A0 = Source Address
copy_title_screen_bitplanes
        IFND     TEST_TITLEPRG
                lea.l   $00040000,a0
        ELSE
                lea.l   test_bitplanes+(40*88)+10,a0
        ENDC
                bra.w   copy_bitplanes_to_display                 ; calls $0001d3da
                ; uses routine rts to return to caller




bitplane_size                                   ; original address $0001ca3e
                dc.l $00000000                  ; The size of the current display bitplane in bytes          




                ; -------------- other data 2 ----------------------
                ; currently unknown/unused data
.other_data2
L0001CA42       dc.w $0000, $0000                ;or.b #$00,d0







                ;-------------------------------- UNUSED CODE -----------------------------
                ;-------------------------------- UNUSED CODE -----------------------------
                ;-------------------------------- UNUSED CODE -----------------------------
                ;-------------------------------- UNUSED CODE -----------------------------
                ;-------------------------------- UNUSED CODE -----------------------------
                ;-------------------------------- UNUSED CODE -----------------------------  


                ; l0001cd0e = $7e (126) - reset_title_screen_display
                ; l0001cd12 = $3c (60)  - reset title screen display (L0001cd0e+4)          
L0001ca46       lea.l   L0001CD0E,a0
L0001ca4c       lea.l   L0001CD2E,a2
L0001ca52       lea.l   L0001CD16,a3
L0001ca58       lea.l   L0001CD34,a4
L0001ca5e       lea.l   L0001CD3A,a5
L0001ca64       lea.l   L0001CD40,a6

L0001ca6a       moveq   #$00,d7
L0001ca6c       bsr.w   L0001cb94

L0001ca70       move.w  #$0fca,d1
L0001ca74       or.w    L0001CD8C,d1
L0001ca7a       move.w  d1,$00dff040
L0001ca80       move.w  L0001CD8C,$00dff042
L0001ca8a       move.l  L0001CD86,d0
L0001ca90       beq.w   L0001cb92
L0001ca94       move.l  L0001CD6E,$00dff04c
L0001ca9e       move.l  L0001CD82,$00dff050
L0001caa8       move.l  d0,$00dff048
L0001caae       move.l  d0,$00dff054
L0001cab4       clr.w   $00dff064
L0001caba       clr.w   $00dff062
L0001cac0       move.w  (a4),$00dff060
L0001cac6       move.w  (a4),$00dff066
L0001cacc       move.w  (a2),$00dff058
L0001cad2       add.l   bitplane_size,d0                        ;$0001ca3e,d0
L0001cad8       bsr.w   wait_blitter                            ; calls $0001d442
L0001cadc       move.l  L0001CD72,$00dff04c
L0001cae6       move.l  L0001CD82,$00dff050
L0001caf0       move.l  d0,$00dff048
L0001caf6       move.l  d0,$00dff054
L0001cafc       move.w  (a2),$00dff058
L0001cb02       add.l   bitplane_size,d0                        ;$0001ca3e,d0
L0001cb08       bsr.w   wait_blitter                            ; calls $0001d442
L0001cb0c       move.l  L0001CD76,$00dff04c
L0001cb16       move.l  L0001CD82,$00dff050
L0001cb20       move.l  d0,$00dff048
L0001cb26       move.l  d0,$00dff054
L0001cb2c       move.w  (a2),$00dff058
L0001cb32       add.l   bitplane_size,d0                        ; $0001ca3e,d0
L0001cb38       bsr.w   wait_blitter                            ; calls $0001d442
L0001cb3c       move.l  L0001CD7A,$00dff04c
L0001cb46       move.l  L0001CD82,$00dff050
L0001cb50       move.l  d0,$00dff048
L0001cb56       move.l  d0,$00dff054
L0001cb5c       move.w  (a2),$00dff058
L0001cb62       add.l   bitplane_size,d0                        ; $0001ca3e,d0
L0001cb68       bsr.w   wait_blitter                            ; calls $0001d442
L0001cb6c       move.l  L0001CD7E,$00dff04c
L0001cb76       move.l  L0001CD82,$00dff050
L0001cb80       move.l  d0,$00dff048
L0001cb86       move.l  d0,$00dff054
L0001cb8c       move.w  (a2),$00dff058
L0001cb92       rts


                ; L0001cd0e,a0
                ; L0001cd2e,a2
                ; L0001cd16,a3
                ; L0001cd34,a4
                ; L0001cd3a,a5
                ; L0001cd40,a6                  ; index for source copy
                ; d7 = 0
L0001cb94       moveq   #$00,d0
L0001cb96       move.w  #$0028,(a4)

L0001cb9a       movem.l a0,-(a7)
L0001cb9e       move.w  (a6),d0
L0001cba0       mulu.w  #$001c,d0
L0001cba4       lea.l   L0001CD44,a0
L0001cbaa       move.l  $00(a0,d0.l),L0001CD66
L0001cbb2       move.l  $04(a0,d0.l),L0001CD66+8                ; L0001cd6e
L0001cbba       move.l  $08(a0,d0.l),L0001CD66+12               ; L0001cd72
L0001cbc2       move.l  $0c(a0,d0.l),L0001CD66+16               ; L0001cd76
L0001cbca       move.l  $10(a0,d0.l),L0001CD66+20               ; L0001cd7a
L0001cbd2       move.l  $14(a0,d0.l),L0001CD66+24               ; L0001cd7e
L0001cbda       move.l  $18(a0,d0.l),L0001CD66+28               ; L0001cd82
L0001cbe2       movem.l (a7)+,a0

L0001cbe6       move.w  (a0),d0                 ; d0 = 1st word
L0001cbe8       move.w  d0,d2                   ; d2 = 1st word
L0001cbea       and.w   #$000f,d2               ; mask to 8 bits
L0001cbee       lsr.w   #$03,d0                 ; d0 = d0 * 8
L0001cbf0       move.w  $0004(a0),d1            ; d1 = 2nd word
L0001cbf4       add.w   #$0100,d1               ; d1 = d1 + 256
L0001cbf8       ext.w   d0                      ; sign extend byte to word
L0001cbfa       add.w   #$0100,d0               ; d0 = d0 + 256
L0001cbfe       move.w  L0001CD66+2,d4          ; L0001cd68,d4
L0001cc04       move.w  d1,d3                   ; d3 = d1
L0001cc06       cmp.w   #$01c7,d3       
L0001cc0a       bgt.w   clear_and_exit          ; L0001cc22
L0001cc0e       add.w   d4,d3
L0001cc10       cmp.w   #$01c7,d3
L0001cc14       blt.w   L0001cc2a
L0001cc18       sub.w   #$01c7,d3
L0001cc1c       sub.w   d3,d4
L0001cc1e       beq.b   clear_and_exit          ; L0001cc22
L0001cc20       bpl.b   L0001cc2a
clear_and_exit
L0001cc22       clr.l   L0001CD86
L0001cc28       rts  


L0001cc2a       cmp.w   #$0100,d1
L0001cc2e       bgt.w   L0001cc7a
L0001cc32       move.w  d1,d3
L0001cc34       add.w   d4,d3
L0001cc36       sub.w   #$0100,d3
L0001cc3a       bmi.w   L0001cc22
L0001cc3e       move.w  d3,d4
L0001cc40       beq.w   L0001cc22
L0001cc44       sub.w   L0001CD68,d3
L0001cc4a       neg.w   d3
L0001cc4c       mulu.w  L0001CD66,d3
L0001cc52       add.l   d3,$0001CD6E
L0001cc58       add.l   d3,$0001CD72
L0001cc5e       add.l   d3,$0001CD76
L0001cc64       add.l   d3,$0001CD7A
L0001cc6a       add.l   d3,$0001CD7E
L0001cc70       add.l   d3,$0001CD82
L0001cc76       move.w  #$0100,d1
L0001cc7a       clr.w   (a5)
L0001cc7c       cmp.w   #$0128,d0
L0001cc80       bgt.w   L0001cc22
L0001cc84       cmp.w   #$0100,d0
L0001cc88       bgt.w   L0001cc9c
L0001cc8c       move.w  d0,d3
L0001cc8e       sub.w   #$0100,d3
L0001cc92       bmi.w   L0001cc22
L0001cc96       nop
L0001cc98       move.w  #$0100,d0
L0001cc9c       move.w  d0,d3
L0001cc9e       add.w   L0001CD66,d3
L0001cca4       cmp.w   #$0128,d3
L0001cca8       blt.w   L0001ccb0
L0001ccac       bra.w   L0001cc22
L0001ccb0       move.w  L0001CD66,d6
L0001ccb6       sub.w   d6,(a4)
L0001ccb8       sub.w   #$0100,d0
L0001ccbc       sub.w   #$0100,d1
L0001ccc0       mulu.w  #$0028,d1
L0001ccc4       add.l   d1,d0
L0001ccc6       move.l  L0001CA42,d1
L0001cccc       add.l   d0,d1
L0001ccce       move.l  d1,L0001CD86
L0001ccd4       asl.w   #$08,d2
L0001ccd6       asl.w   #$04,d2
L0001ccd8       move.w  d2,L0001CD8C
L0001ccde       move.w  L0001CD66,d5
L0001cce4       mulu.w  d4,d5
L0001cce6       move.l  d5,L0001CD6A
L0001ccec       move.w  L0001CD66,d5
L0001ccf2       lsr.w   #$01,d5
L0001ccf4       asl.w   #$06,d4
L0001ccf6       or.w    d4,d5
L0001ccf8       move.w  d5,(a2)
L0001ccfa       rts

L0001ccfc       lea.l   L0001CD2E,a0
L0001cd02       move.w  #$0002,d7
L0001cd06       clr.w   (a0)+
L0001cd08       dbf.w   d7,L0001cd06
L0001cd0c       rts



                ;-------------------------------- UNUSED CODE -----------------------------
                ;-------------------------------- UNUSED CODE -----------------------------
                ;-------------------------------- UNUSED CODE -----------------------------
                ;-------------------------------- UNUSED CODE -----------------------------
                ;-------------------------------- UNUSED CODE -----------------------------




                ; l0001cd0e = $7e (126) - reset_title_screen_display
                ; l0001cd12 = $3c (60)  - reset title screen display (L0001cd0e+4)
L0001CD0E       dc.w $0000, $0018, $0000, $0012 
L0001CD16       dc.w $0000, $0000, $0000, $0000
                dc.w $0000, $0000, $0000, $0000
                dc.w $0000, $0000
                
L0001CD2A       dc.w $0000, $0000       ;unused? 

L0001CD2E       dc.w $0000, $0000, $0000
L0001CD34       dc.w $0000, $0000, $0000
L0001CD3A       dc.w $0000, $0000, $0000
L0001CD40       dc.w $0000              ; index for copy above L0001CD0E -> L0001CD66
                dc.w $0000
L0001CD44       dc.w $000C

L0001CD46 dc.w $001C, $0005, $0000, $0005
L0001CD4E dc.w $0150, $0005, $02A0, $0005, $03F0, $0005, $0540, $0001           ;.P...........@..
L0001CD5E dc.w $CD8E, $0000, $0000, $0000

                ; Values from L0001CD0E - is copied to these values here.
L0001CD66       dc.w $0000
L0001CD68       dc.w $0000
L0001CD6A       dc.l $00000000          ; skipped by data copy
L0001CD6E       dc.l $00000000
L0001CD72       dc.l $00000000
L0001CD76       dc.l $00000000
L0001CD7A       dc.l $00000000 
L0001CD7E       dc.l $00000000             
L0001CD82       dc.l $00000000

L0001CD86 dc.w $0000, $0000, $0000
L0001CD8C dc.w $0000           
L0001CD8E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CD9E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CDAE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CDBE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CDCE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CDDE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CDEE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CDFE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CE0E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CE1E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CE2E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CE3E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CE4E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CE5E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CE6E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CE7E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CE8E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CE9E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CEAE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CEBE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CECE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CEDE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CEEE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CEFE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CF0E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CF1E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CF2E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CF3E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CF4E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CF5E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CF6E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CF7E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CF8E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CF9E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CFAE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CFBE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CFCE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CFDE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CFEE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001CFFE dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001D00E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001D01E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF           ;................
L0001D02E dc.w $FFFF, $FFFF, $FFFF, $FFFF, $0000, $0000, $0000, $0000           ;................
L0001D03E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D04E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D05E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D06E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D07E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D08E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D09E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D0AE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D0BE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D0CE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D0DE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D0EE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D0FE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D10E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D11E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D12E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D13E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D14E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D15E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D16E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D17E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D18E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D19E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D1AE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D1BE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D1CE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D1DE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D1EE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D1FE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D20E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D21E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D22E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D23E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D24E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D25E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D26E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D27E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D28E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D29E dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D2AE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D2BE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................
L0001D2CE dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000           ;................




                ;---------------------- reset title screen display ------------------------
                ; 
                ;
                ; 1) resets the display window to closed, set general display parameters
                ; in custom registers.
                ; Checks if cheat is enabled, and if so flips the display.
                ;
                ; Called from:
                ;
                ; IN: D0.l = bitplane size (bytes)
                ;
reset_title_screen_display                                              ; original address $0001d2de
                move.l  d0,bitplane_size                                ; $0001ca3e
                move.b  #$f4,$00dff08e                                  ; DIWSTRT - reset window to closed
                moveq   #$01,d0
                bsr.w   raster_wait_161                                 ; wait for 2 frames ; calls $0001c2f8
                ;move.w  #$1000,$00dff100                                ; BPLCON0 - 5 bitplane screen
                move.w  #$5000,$00dff100                                ; BPLCON0 - 5 bitplane screen
                move.w  #$0040,$00dff104                                ; BPLCON2 - Playfield 2 - priority (dual playfield?)
                move.w  #$0000,$00dff102                                ; BPLCON1 - Clear scroll delay
                move.l  #DISPLAY_BITPLANE_ADDRESS,L0001CA42             ; #$00063190,$0001ca42 [00000000]
                move.w  #$007e,L0001CD0E                                ; #$7e (126)
                move.w  #$003c,L0001CD0E+4                              ; #$3c (60)
                move.l  #$003800d0,$00dff092                            ; DDFSTRT/DDFSTOP - DMA bitplane fetch
                clr.w   $00dff108                                       ; BPL1MOD - CLR not the best on custom regs
                clr.w   $00dff10a                                       ; BPL2MOD
                move.l  #$ffffffff,$00dff044                            ; BLTAFWM/BLTALWM - blitter word masks
                move.l  #DISPLAY_BITPLANE_ADDRESS,d0                    ; #$00063190,d0
                btst.b  #PANEL_STATUS_2_INFINITE_LIVES,PANEL_STATUS_2   ; $0007c875
                beq.b   .set_bitplane_ptrs                              ; $0001d372
.cheat_enabled
                move.w  #$ffb0,$00dff108                                ; BPL1MOD = -80 (flip screen)
                move.w  #$ffb0,$00dff10a                                ; BPL2MOD = -80 (flip screen)
                move.l  bitplane_size,d1                                ; $0001ca3e,d1
                sub.l   #$00000028,d1
                add.l   d1,d0                                           ; d0 last line of title screen bitplane

.set_bitplane_ptrs
                moveq   #$04,d7                                         ; d7 = 4 + 1 (5 bitplanes) set bitplane pointers for title screen
                lea.l   copper_bplh_ptrs,a0                             ; L0001d6ee,a0 - bitplane high 16bit ptrs
                lea.l   copper_bpll_ptrs,a1                             ; L0001d702,a1 - bitplane low  16bit ptrs
.bitplane_loop
                move.w  d0,$0002(a1)
                swap.w  d0
                move.w  d0,$0002(a0)
                swap.w  d0
                addq.l  #$04,a0                                         ; increment to next bitplane ptr in copper list
                addq.l  #$04,a1                                         ; increment to next bitplane ptr in copper list
                add.l   bitplane_size,d0                                ; $0001ca3e,d0 - calc next bitplane start address
                dbf.w   d7,.bitplane_loop                               ; loop 5 times, jmp $0001d380
                rts



                ;------------------- do copy bitplane memory -----------------
                ; copies memory to the display bitplanes from $20000
                ; appears to be unused code.
                ;
do_copy_bitplane_memory
                bra.w   copy_bitplane_memory                            ; jmp $0001d3b4




                ;--------------------- copper copy -------------------
                ; copies colours into the copper for the current
                ; screen display
                ; IN: A0 = ptr to screen colours
                ;
copper_copy                                                     ; original address $0001d3a0
                lea.l   copper_colors,a1                        ; 0001d718,a1
                move.w  #$001f,d0                               ; d0 = 31 + 1 - counter
.copy_loop
                move.w  (a0)+,(a1)
                addq.l  #$04,a1                                 ; update dest ptr to next colour value
                dbf.w   d0,.copy_loop
                rts




                ;------------------- copy bitplane memory -----------------
                ; copies memory to the display bitplanes from $20000
                ; appears to be unused code.
                ;
copy_bitplane_memory                                            ; original routine address
                clr.l   DISPLAY_BITPLANE_ADDRESS                ; $00063190 - clear first 32 bits?
                lea.l   $00020000,a0                            ; a0 = $20000 - source address
                lea.l   DISPLAY_BITPLANE_ADDRESS+4,a1           ; a1 = $63194 - destination address
                movea.l a0,a2                                   ; a2 = copy dest address
                moveq   #$04,d1                                 ; d1 = counter 4 + 1 (5 bitplanes)
.bitplane_copy_loop
                move.w  #$1f40,d0                               ; d0 = bitplane size (8000)
.byte_copy_loop
                move.b  (a0)+,(a1)+                             ; copy byte by byte from source to dest
                dbf.w   d0,.byte_copy_loop
                dbf.w   d1,.bitplane_copy_loop
                rts




                ; ----------------------------- Copy Bitplanes to Display  --------------------------------
                ; copy source gfx to display bitplanes.
                ;
                ; - address $63190 = Bitplane address for display - see copper list
                ;
                ; - 28 x 3 = 84 bytes per loop iteration
                ; - 84 x 477 = 40,068 bytes
                ;  - 320 x 200 screen = 8000 bytes per bitplane 
                ;  - 8000 x5 = 40,0000
                ; - over copies 68 bytes?
                ;
                ; IN: A0 = ptr to src gfx
                ;
copy_bitplanes_to_display                               ; original routine address $0001d3da
                movem.l d0/a0-a1,-(a7)
                lea.l   DISPLAY_BITPLANE_ADDRESS,a1     ; $00063190,a1
                move.w  #$01dc,d0                       ; d0 = $1cd (476) + 1
.copy_loop
                movem.l (a0)+,d1-d7                     ; copy 28 bytes src -> registers
                movem.l d1-d7,(a1)                      ; copy 28 bytes reg -> dest (a1)
                adda.l  #$0000001c,a1                   ; #$1c = 28 (28 bytes to dest ptr)
                movem.l (a0)+,d1-d7                     ; copy 28 bytes src -> registers
                movem.l d1-d7,(a1)                      ; copy 28 bytes reg -> dest
                adda.l  #$0000001c,a1                   ; #$1c = 28 (28 bytes to dest ptr) 
                movem.l (a0)+,d1-d7                     ; copy 28 bytes src > registers
                movem.l d1-d7,(a1)                      ; copy 28 bytes reg -> dest
                adda.l  #$0000001c,a1                   ; #$1c = 28 (28 bytes to dest ptr) 
                dbf.w   d0,.copy_loop                   ; copy loop (477 times x 28 bytes = 40,068)

                movem.l (a7)+,d0/a0-a1
                rts



                ; --------------------- copy gfx to display ---------------------
                ; copies 51,212 bytes from source to dest.
                ; IN: a0 = source gfx ptr
copy_gfx_to_display                                     ; original address $0001d41c
                movem.l d0/a1,-(a7)
                lea.l   DISPLAY_BITPLANE_ADDRESS,a1     ; $00063190,a1
                move.w  #$0724,d0                       ; #$724 + 1 (1829) ; 1829 * 28 = 51,212
.copy_loop
                movem.l (a0)+,d1-d7                     ; get 28 source bytes (d1-d7)
                movem.l d1-d7,(a1)                      ; set 28 dest bytes (d1-d7)
                adda.l  #$0000001c,a1                   ; increment dest ptr by #$1c (28)
                dbf.w   d0,.copy_loop                   ; loop 1829 times
                movem.l (a7)+,d0/a1
                rts 




                ;--------------------- wait blitter ---------------------------
                ; wait for blitter to finish it's current operation.
                ; busy wait loop.
wait_blitter
                btst.b  #$0006,$00dff002                 ; test BBUSY bit of DMACONR
                bne.w   wait_blitter
                rts  



                ;--------------------- do return to title screen ----------------
                ; perform game over/game completion checks, display correct
                ; screens on return from the game back to the title screen.
                ;
do_return_to_title_screen                                                       ; original routine address $0001d450
                lea.l   temp_stack_top,a7                                       ; set temp stack, $0001d6de,a7
                bsr.w   initialise_title_screen                                 ; calls $0001c0d8
                btst.b  #PANEL_STATUS_2_GAME_OVER,PANEL_STATUS_2                ; #$0005,$0007c875 
                beq.b   do_gameover_completion                                  ; calls $0001d46e
                clr.l   PANEL_HIGHSCORE                                         ; $0007c87c
                bra.w   return_to_title_screen                                  ; $0001c018



                ;------------------- do game over/completion -------------------
                ; check panel_status_2 bit to see if the game was completed
                ; or whether it's a game over.
do_gameover_completion                                                          ; original routine address $0001d46e
                btst.b  #PANEL_STATUS_2_GAME_COMPLETED,PANEL_STATUS_2           ; #$0006,$0007c875 
                IFD TEST_JOKER
                beq.w   display_endgame_joker                                   ; jmp $0001d4ec
                ENDC



                ;---------------------- display completion screen -----------------------
                ; displays the game completion screen, plays the batman voice (song 3)
                ; waits for ~15 seconds, returns to title screen.
display_completion_screen                                                       ; original routine address $0001d47a
                move.l  #$00001f40,d0                                           ; d0 = bitplane size (bytes) (8000)
                bsr.w   reset_title_screen_display                              ; calls $0001d2de
                move.w  #$4000,$00dff100                                        ; set 4 bitplane screen
                lea.l   palette_16_colours,a0                                   ; L0001d4cc ; 16 colour palette address
                bsr.w   copper_copy                                             ; calls $0001d3a0
                lea.l   BATMAN_GFX,a0                                            ; a0 = source gfx
                ;lea.l   $00056460,a0                                            ; a0 = source gfx
                bsr.w   copy_bitplanes_to_display                               ; calls $0001d3da
                move.b  #$2c,copper_diwstrt                                     ; $0001d6e8 - set window open
                move.b  #$f4,copper_diwstop                                     ; $0001d6ec 
                move.w  #$0064,d0                                               ; d0 = 100
                bsr.w   raster_wait_161                                         ; wait for 100 frames (2 seconds) - calls $0001c2f8
                moveq   #SOUND_BATMAN_SPEACH,d0                                                 ; d0 = song 3
                jsr     SoundDriver_Play_Song                                               ; init play song 4 - calls $00004010
                move.w  #$0600,d0                                               ; d0 = 1536 
                bsr.w   raster_wait_161                                         ; wait for 1536 frames (15 seconds) - calls $0001c2f8
                bra.w   return_to_title_screen                                  ; jmp $0001c018




                ;------------------- 16 colour palette -----------------------
                ; 16 colour palatte for the above.
palette_16_colours                                                              ; original address $0001d4cc
                dc.w $0000, $0ec2, $0e80, $0a40, $0820, $0e60, $0ea8, $0eca 
                dc.w $0ea0, $0eee, $0222, $0444, $0666, $0888, $0AAA, $0CCC




                ;---------------------- display end game joker -----------------------
                ; displays the game over screen, plays the joker laugh (song 2)
                ; waits for ~10 seconds, returns to title screen.
display_endgame_joker                                                   ; original address $0001d4f0
                move.l  #$2800,d0                                       ; d0,d4 = bitplane size (bytes)
                bsr.w   reset_title_screen_display                      ; calls $0001d2de
        IFND     TEST_TITLEPRG
                lea.l   $00040000,a0
                lea.l   JOKER_GFX,a0                                    ; a0 = display palette colour table
                bsr.w   copper_copy                                     ; calls $0001d3a0
                lea.l   JOKER_GFX+$40,a0                                ; a0 = display palette colour table
        ELSE
                lea.l   test_bitplanes,a0                               ; a0 = display palette colour table
                lea.l   JOKER_GFX+4,a0                                  ; a0 = display palette colour table
                bsr.w   copper_copy                                     ; calls $0001d3a0
                lea.l   JOKER_GFX+$44,a0                                ; a0 = display palette colour table
        ENDC
                bsr.w   copy_gfx_to_display                             ; calls $0001d41c
                move.b  #$2c,copper_diwstrt                             ; $0001d6e8
                move.b  #$2b,copper_diwstop                             ; $0001d6ec
                move.w  #$0014,d0
                bsr.w   raster_wait_161                                 ; calls $0001c2f8
                moveq   #SOUND_JOKER_LAUGH,d0
                jsr     SoundDriver_Play_Song                                       ; calls $00004010
                move.w  #$0200,d0                                       ; d0 = wait 512 frames (10 seconds)
                bsr.w   raster_wait_161                                 ; calls $0001c2f8
                bra.w   return_to_title_screen                          ; jmp $0001c018




                ;--------------------- wait 10 seconds ---------------------
                ; waits for 512 frames to pass.
                ; *** unused code ***
wait_10_seconds
                move.w  #$0200,d0                                       ; d0 = wait 512 frames (10 seconds)
                bsr.w   raster_wait_161                                 ; calls $0001c2f8
                bra.w   return_to_title_screen                          ; jmp $0001c018




                ;-----------------------do  fatal error ------------------
                ; Takes back ground colour and sets it, then increments the value
                ; loops forever.
                ;
do_fatal_error                                                          ; original routine address $0001d542
                move.w  d0,$00dff180
                addq.w  #$01,d0
                bra.w   do_fatal_error



                ;----------------------- title screen stack ------------------
                ; memory area used for the title screen stack memory.
                ; sp/a7 is set to the address 'temp_stack_top' at the end of 
                ; this block of data.
                ;
temp_stack_bottom                                                       ; original address $0001D54E
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000   
                dc.w $0000, $0000, $00C7, $8978, $00C7, $8978, $00C7, $848C   
                dc.w $00C7, $871E, $00C7, $8104, $0000, $0000, $0000, $0000   
temp_stack_top                                                          ; original address $0001D6DE




L0001D6DE dc.w $0000                            ; ***** UNUSED? *****
L0001D6E0 dc.w $0000                            ; ***** UNUSED? *****




                ; ------------------- copper list -------------------
copper_list
                dc.w $00FF
                dc.w $FF00
                dc.w DIWSTRT            ; $008E 
copper_diwstrt                                                  ; original address $0001D6E8
                dc.w $F381
                dc.w DIWSTOP            ; $0090
copper_diwstop                                                  ; original address $0001D6EC
                dc.w $F4C1
copper_bplh_ptrs
                dc.w BPL1PTH            ; $00E0
                dc.W $0006
                dc.w BPL2PTH            ; $00E4
                dc.w $0006
                dc.w BPL3PTH            ; $00E8
                dc.w $0006
                dc.w BPL4PTH            ; $00EC
                dc.w $0006
                dc.w BPL5PTH            ; $00F0
                dc.w $0006
copper_bpll_ptrs
                dc.w BPL1PTL            ; $00E2
                dc.w $3190
                dc.w BPL2PTL            ; $00E6
                dc.w $50D0
                dc.w BPL3PTL            ; $00EA
                dc.w $7010
                dc.w BPL4PTL            ; $00EE
                dc.w $8F50
                dc.w BPL5PTL            ; $00F2
                dc.w $AE90
                dc.w COLOR00
copper_colors                                                   ; original address $0001d718
                dc.w $0000
                dc.w COLOR01, $0000
                dc.w COLOR02, $0000
                dc.w COLOR03, $0000
                dc.w COLOR04, $0000
                dc.w COLOR05, $0000
                dc.w COLOR06, $0B51
                dc.w COLOR07, $0D61
                dc.w COLOR08, $0E70
                dc.w COLOR09, $0F80 
                dc.w COLOR10, $0F90
                dc.w COLOR11, $0FA0
                dc.w COLOR12, $0FB0
                dc.w COLOR13, $0FC0
                dc.w COLOR14, $0FE0
                dc.w COLOR15, $0FF0
                dc.w COLOR16, $0045
                dc.w COLOR17, $0900
                dc.w COLOR18, $0FFF
                dc.w COLOR19, $0033
                dc.w COLOR20, $0067
                dc.w COLOR21, $0222
                dc.w COLOR22, $0333
                dc.w COLOR23, $0444
                dc.w COLOR24, $0F99
                dc.w COLOR25, $0666
                dc.w COLOR26, $0706
                dc.w COLOR27, $0504
                dc.w COLOR28, $099A
                dc.w COLOR29, $0403
                dc.w COLOR30, $0302
                dc.w COLOR31, $0DDE
                dc.w $FFFF, $FFFE




                ;------------------------ title screen colours ---------------------
                ; table of colours copied into the copper list colour registers.
                ; the palette used for the title screen display.
                ;
title_screen_colors                                                     ; original address $0001D79A       
                dc.w $0000, $0521, $0310, $0731, $0831, $0A41, $0B51, $0D61
                dc.w $0E70, $0F80, $0F90, $0FA0, $0FB0, $0FC0, $0FE0, $0FF0
                dc.w $0045, $0900, $0FFF, $0033, $0067, $0222, $0333, $0444
                dc.w $0F99, $0666, $0706, $0504, $099A, $0403, $0302, $0DDE






        IFD TEST_TITLEPRG
                even
test_bitplanes  
                INCDIR './gfx/'
                INCBIN 'titlepic.iff'
                ;dcb.w   40068,$ff00

                even
test_display    
                dcb.w   40000,$f0f0
        ENDC

; 0003f1ea - text font
