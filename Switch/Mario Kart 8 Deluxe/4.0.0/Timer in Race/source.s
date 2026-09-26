//; Game: Mario Kart 8 Deluxe
//; Game version: 4.0.0
//; Code: Timer in Race

//; You can find some documented headers here to learn more about the game
//; and know some offsets: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are written over unused functions (never executed).
//; There is a bit of free space in .text, but for some reason the emulator
//; crashes when executing code in that space. Writing over unused functions
//; doesn't cause a crash.


//; Create timer in race
//; ui::Page_Race::onCreate_(void) + 0x408
//; 0x531C0C -> BL 0x7A6068

//; Skip the code if in Multiplayer

//; Create timer in race


.set RACERULE_TIME_TRIALS, 2

STP X29, X30, [SP, #-0x20]!
STR W8, [SP, #0x10]

BL 0x87FCD0 //; gear::GetRaceInfo(void)
BL 0x87F668 //; gear::RaceInfo::getMasterNumForWindow(void)

LDR W8, [SP, #0x10]

CMP W0, #1
BNE end

MOV W8, #RACERULE_TIME_TRIALS

end:
LDP X29, X30, [SP], #0x20
CMP W8, #RACERULE_TIME_TRIALS //; Original instruction
RET


//; Change timer player ID to yours
//; ui::Control::RaceTimer::onIn_(void) + 0x78
//; 0x5151E8 -> BL 0x7A6094

//; Timer player ID is always 0 by default, so
//; when playing online, lap timer and animation
//; is based on the host of the room.
//; Change it to your ID instead.

//; getMyKartIndex returns -1 offline. Change it to
//; 0 if this is the case since your ID is always
//; 0 offline.


STP X29, X30, [SP, #-0x20]!
STR X8, [SP, #0x10]

BL 0x862820 //; gear::NetworkUtil::getMyKartIndex(void)
CMP W0, #-1
CSEL W9, WZR, W0, EQ

LDR X8, [SP, #0x10]
LDP X29, X30, [SP], #0x20
RET