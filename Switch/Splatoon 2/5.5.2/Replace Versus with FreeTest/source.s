//; Game: Splatoon 2
//; Game version: 5.5.2
//; Code: Replace Versus with FreeTest


//; Hooks are written over unused functions (never executed).
//; There is a bit of free space in .text, but for some reason the emulator
//; crashes when executing code in that space. Writing over unused functions
//; doesn't cause a crash.


//; Game::MainMgr::createActors(void) + 0x178
//; 0xA0CDAC -> BL 0x1AA9D84

//; If holding Minus button, Versus switch case ID is replaced with FreeTest's ID
//; Holding Minus on loading screen will make you load in FreeTest instead of Versus


.set BUTTONBIT_MINUS, 9

.set SCENE_FREETEST, 0x16

CBNZ W0, end //; Not Versus

STP X29, X30, [SP, #-0x10]!

MOV W0, WZR
BL 0x19EC714 //; Lp::Utl::getCtrl(int)
LDR W8, [X0, #0x10]
TBZ W8, #BUTTONBIT_MINUS, restore //; Not held

MOV W8, #SCENE_FREETEST
STR W8, [SP, #0x1C]

restore:
LDP X29, X30, [SP], #0x10

end:
LDR W8, [SP, #0xC] //; Original instruction
RET