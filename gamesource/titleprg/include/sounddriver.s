
    IFND SOUND_DRIVER_S
SOUND_DRIVER_S  EQU 1


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
chan_adsrEnvelopeDelayTicks             rs.w      1         ; 0x1e
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

CHANNEL_XX_STATUS_SIZE          EQU  $56          ; 86 bytes
HW_AUDIO_CHANNELS               EQU  $4           ; the number of hardware autio channels


    ENDC