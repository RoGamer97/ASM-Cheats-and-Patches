//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: Timer in Race

//; You can find some documented headers here to learn more about the game: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are placed in free space in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


//; Create timer in race
//; ui::Page_Race::onCreate_(void) + 0x3D0
//; 0x52E560 -> BL 0xB51448

//; Create timer in race, except if it's Multiplayer

.set RACERULE_TIME_TRIALS, 2

STP X29, X30, [SP, #-0x20]!
STR W8, [SP, #0x10]

BL 0x87C244 //; gear::GetRaceInfo(void)
BL 0x87BC04 //; gear::RaceInfo::getMasterNumForWindow(void)

LDR W8, [SP, #0x10]

CMP W0, #1
BNE end

MOV W8, #RACERULE_TIME_TRIALS

end:
LDP X29, X30, [SP], #0x20
CMP W8, #RACERULE_TIME_TRIALS //; Original instruction
RET


//; Change timer player ID to yours
//; ui::Control::RaceTimer::onIn_(void)
//; 0x511C74 -> BL 0xB51474

//; Timer player ID is always 0 by default, so
//; when playing online, lap timer and animation
//; is based on the host of the room.
//; Change it to your ID instead.

//; getMyKartIndex returns -1 offline. Change it to
//; 0 if this is the case since your ID is always
//; 0 offline.

STP X29, X30, [SP, #-0x20]!
STR X8, [SP, #0x10]

BL 0x85EEB8 //; gear::NetworkUtil::getMyKartIndex(void)
CMP W0, #-1
CSEL W9, WZR, W0, EQ

LDR X8, [SP, #0x10]
LDP X29, X30, [SP], #0x20
RET