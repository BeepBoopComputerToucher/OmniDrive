.include "mmio.asm"

.org FreeSpaceStart
.region (FreeSpaceEnd - FreeSpaceStart)
CommandTableCustom:
    ; READ DISC RAW (C0h)
    .d8 0xC0
    .d8 0x02
    .d16 0x00
    .d32 CmdOmniDriveReadDiscRaw+1
    ; End Table
    .d8 0x00
    .d8 0x03
    .d16 0x00
    .d32 0x00

    .importobj "../build/libOmniDrive.a"
.endregion

.org InquiryDataPatch
    .ascii "OmniDrive"
    .d8 1 ; major
    .d8 0 ; minor
    .d8 0 ; patch

.org CommandTableEnd
    ; Set next table to custom
    .d8 0x00
    .d8 0x04
    .d16 0x00
    .d32 CommandTableCustom

.org CommandTableDVDRead1
    .d32 DVDReadCmdHook+1
.org CommandTableDVDRead2
    .d32 DVDReadCmdHook+1
.org CommandTableDVDRead3
    .d32 DVDReadCmdHook+1

.arm ; otherwise values are offset by 1
    TocOffset:
        .d32 TocOffsetValue
    DVDCharacteristicsPatchPtr:
        .d32 DVDCharacteristicsPatchAddr
.thumb

.org CommandTableBDRead1
    .d32 BDReadCmdHook+1
.org CommandTableBDRead2
    .d32 BDReadCmdHook+1

.org DVDLeadOutPatchAddr0
    .d8 0xe0 ; bls -> b
.org DVDLeadOutPatchAddr1
    nop
.org DVDLeadOutPatchAddr2
    nop
.org DVDLeadOutPatchAddr3
    nop
.org DVDLeadOutPatchAddr4
    nop
.org DVDLeadOutPatchAddr5
    nop
.org DVDLeadOutPatchAddr6
    nop

.org CDLeadOutPatchAddr1
    mov r0,#0x20
.org CDLeadOutPatchAddr2
    mov r0,#0x20

.org ScrambleHookAddr
    bl ChangeDiscRWModeHook

.org BDScramblePatchAddr
    nop
.org BDScrambleHookAddr
    bl ChangeDiscRWModeHook

.org DVDScramblePatchAddr
    nop

.org DVDScrambleHookAddr
    bl ChangeDiscRWModeHook

.org ReadDVDTOCHookAddr
    bl ReadDVDTOCHook

.org DVDEDCHookAddr
    bl SetErrorModeHook

.org BDEDCHookAddr
    bl SetErrorModeHook

.org BDIdentifierPatchAddr1
    nop
.org BDIdentifierPatchAddr2
    .d8 0xE0 ; beq -> b
.org BDIdentifierPatchAddr3
    nop
.org BDIdentifierPatchAddr4
    nop

.org SetBDCharacteristicsHookAddr
    bl SetBDCharacteristicsHook

; F1 01 01 F9 6D AA 79 58 D1 19