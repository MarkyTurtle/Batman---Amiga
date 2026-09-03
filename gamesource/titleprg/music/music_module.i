     IFND MUSIC_MODULE_I
MUSIC_MODULE_I      EQU  1

               ; The Track Commands are listed below,
               ; These are the commands that help sequence patterns of data,
               ; Set Looping Parameters, Repeat Patterns and Transpose the pitch of patterns
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



               ; The Pattern Commands are listed below,
               ; These are the commands to select instruments, start effects etc
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

     ENDC
     
