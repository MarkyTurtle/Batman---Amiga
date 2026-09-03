
    IFND SOUND_DRIVER_I
SOUND_DRIVER_I  EQU 1

CHANNEL_XX_STATUS_SIZE        EQU  $56            ; 86 bytes
HW_AUDIO_CHANNELS             EQU  $4             ; the number of hardware audio channels

SOUND_MIN_SOUND_ID            EQU  $1             ; the lowest valid soundId

; Pattern Command Bits
; Stored in 'chan_ActiveCommandBits' word 
PTNCMDBITS_LEADIN_NOTES       EQU  $0000
PTNCMDBITS_ARPEGGIO           EQU  $0001
PTNCMDBITS_MODULATION         EQU  $0002
PTNCMDBITS_PORTOMENTO         EQU  $0003
PTNCMDBITS_ADSR_ACTIVE        EQU  $0004
PTNCMDBITS_PAIRED_NOTES       EQU  $0005
PTNCMDBITS_TRANSPOSE_NOTE     EQU  $0006
PTNCMDBITS_CHANNEL_DISABLED   EQU  $0007



    ENDC