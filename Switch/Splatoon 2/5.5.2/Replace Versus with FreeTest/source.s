//; Game: Splatoon 2
//; Game version: 5.5.2
//; Code: Replace Versus with FreeTest


//; Hooks are placed in unused functions because there is no space left in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


//; Game::MainMgr::createActors + 0x178
//; 0xA0CDAC -> BL 0x1AA9D84

//; If holding Minus button, Versus switch case ID is replaced with FreeTest's ID
//; Holding Minus on loading screen will make you load in FreeTest instead of Versus

CBNZ W0, end //; Not Versus

STP X29, X30, [SP, #-0x10]!

MOV W0, WZR
BL 0x19EC714 //; Lp::Utl::getCtrl
LDR W8, [X0, #0x10]
TBZ W8, #9, restore //; Minus button hold

MOV W8, #0x16 //; FreeTest case ID
STR W8, [SP, #0x1C] //; 0x1C because SP is shifted by -0x10

restore:
LDP X29, X30, [SP], #0x10

end:
LDR W8, [SP, #0xC] //; Original instruction
RET