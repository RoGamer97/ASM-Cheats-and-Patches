//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: Enhanced VS Pause Menu

//; You can find some documented headers here to learn more about the game
//; and know some offsets: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are written over unused functions (never executed).
//; There is a bit of free space in .text, but for some reason the emulator
//; crashes when executing code in that space. Writing over unused functions
//; doesn't cause a crash.


//; Use Time Trials Pause Menu Layout in Offline Singleplayer VS
//; ui::Page_RacePause::getLayoutName_(void) + 0x14
//; 0x539000 -> BL 0xAB03F0

//; Overrides the loaded gamemode ID with Time Trials if in offline
//; singleplayer VS

//; After the hook, it checks for Time Trials gamemode ID and returns
//; the Time Trials pause layout string if so, otherwise returns the regular
//; pause one


//; Register reference:
//; X0 = gear::RaceInfo*


.set RACERULE_VS, 1
.set RACERULE_TIME_TRIALS, 2

LDR W9, [X0, #8] //; Original instruction
CMP W9, #RACERULE_VS
BNE end

LDR W8, [X0]
CBNZ W8, end //; Online mode

STP X29, X30, [SP, #-0x10]!
BL 0x87BC04 //; gear::RaceInfo::getMasterNumForWindow(void)
LDP X29, X30, [SP], #0x10

CMP W0, #1
BNE end

MOV W9, #RACERULE_TIME_TRIALS

end:
RET


//; Use Time Trials Pause Menu in Offline VS and Battle
//; ui::Page_RacePause::onCreate_(void) + 0x490
//; 0x539650 -> BL 0xAB0420

//; Overrides the loaded gamemode ID with Time Trials if in offline
//; singleplayer VS

//; After the hook, it checks if gamemode ID is Time Trials and creates
//; Time Trials pause if so, otherwise it creates the regular one


//; Register reference:
//; X26 = gear::RaceInfo* (Input and output)


.set RACERULE_VS, 1
.set RACERULE_TIME_TRIALS, 2

LDR W8, [X26, #8] //; Original instruction
CMP W8, #RACERULE_VS
BNE end

LDR W9, [X26]
CBNZ W9, end //; Online mode

STP X29, X30, [SP, #-0x10]!
MOV X0, X26
BL 0x87BC04 //; gear::RaceInfo::getMasterNumForWindow(void)
LDP X29, X30, [SP], #0x10

MOV W8, #RACERULE_VS

CMP W0, #1
CINC W8, W8, EQ

end:
RET


//; Remove course intro
//; ui::Page_RaceStart::onIn_ + 0xB0 (Not a hook)
//; 0x496130 -> MOV W8, #1
//; Overrides some UI page mode value with 1. If it's 1, the game 
//; skips the course intro by loading the race page ID, otherwise
//; it loads the race intro page ID (or something like this). 1 is used
//; in Time Trials.
//; Needed because race intro causes the game to crash when restarting


//; Don't reset current race count when going to menu
//; ui::MenuPrepare(void) + 0xA4
//; 0x4F68BC -> NOP
//; NOPs the store zero to race count. When coming to menu from
//; "Change Course" and "Change Character", race count is reset,
//; avoid resetting it to keep the race count you're in


//; Reset current race count when going to character selection from menu
//; ??? (Unknown + 0xAC)
//; 0x4B41A4 -> BL 0xAB0458

//; The function this hook is placed at only runs when going to character
//; selection screen

//; Since the race count reset is disabled when going to menus, it must
//; be manually reset

//; Reset it when going to character selection screen, except if 
//; previous page ID is kart select (Coming from vehicle parts screen)
//; or race (Coming from "Change Course" or "Change Character", from pause)


//; Register reference:
//; W8 = Previous page ID (Input and output)


.set PAGEID_VEHICLE_PARTS_SELECT_1P, 0x2F
.set PAGEID_RACE, 0x6E

LDUR W8, [X29, #-0x68] //; Original instruction
STP X29, X30, [SP, #-0x20]!
STR W8, [SP, #0x10]

CMP W8, #PAGEID_VEHICLE_PARTS_SELECT_1P
BEQ end

CMP W8, #PAGEID_RACE
BEQ end

MOV W8, #3
STR W8, [SP, #0x18]
ADD X0, SP, #0x18
BL 0x8CB5EC //; gear::GetUIHeap(gear::EUIHeapID)

LDR X8, [X0, #0x30]
STR WZR, [X8, #0x1744]

end:
LDR W8, [SP, #0x10]
LDP X29, X30, [SP], #0x20
RET