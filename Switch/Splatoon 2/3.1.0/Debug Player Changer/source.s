//; Game: Splatoon 2
//; Game version: 3.1.0
//; Code: Debug Player Changer


// Hooks are written over unused functions (never executed).
// There is a bit of free space in .text, but for some reason the emulator
// crashes when executing code in that space. Writing over unused functions
// doesn't cause a crash.


//; Disable player inputs if Minus is held
//; Cmn::PlayerCtrl::isHold(ulong) + 0x10 and Cmn::PlayerCtrl::isTrig(ulong) + 0x10
//; 0x8ADB0 -> BL 0x1B61088
//; 0x8ADE0 -> BL 0x1B61088

//; If Minus is held, replace requested input mask with zero.

//; Done in the debug build, so reimplementing this too for accuracy


//; Register reference:
//; X19 = Lp::Sys::Ctrl*


.set BUTTONBIT_MINUS, 9

.set BUTTON_MINUS, (1 << BUTTONBIT_MINUS)

LDR W8, [X19, #0x10]
TST W8, #BUTTON_MINUS
CSEL X1, XZR, X1, NE
AND X1, X1, #0x3F //; Original instruction
RET


//; Disable right stick if Minus is held
//; Game::PlayerGamePad::getRightStick(void) + 0x20
//; 0xEA1974 -> BL 0x1B6109C

//; If Minus is held, load address of Vector2 of zeroes and
//; skip getting the controller's right stick address
//; (Use Vec2 zero address instead)

//; Done in the debug build, so reimplementing this too for accuracy

//; Skip by modifying hook's return address: LR + 0x10 = 0xEA1988
//; Returns past the getRightStick call, where the stick values are loaded
//; from the returned pointer

.set BUTTONBIT_MINUS, 9

MOV X29, SP //; Original instruction
STP X29, X30, [SP,#-0x10]!

MOV W0, WZR
BL 0x1A65E14 //; Lp::Utl::getCtrl(int)

LDP X29, X30, [SP], #0x10

LDR W0, [X0, #0x10]
TBZ W0, #BUTTONBIT_MINUS, end //; Not held

ADRP X0, #0x4156000
LDR X0, [X0, #0x818] //; _ZN4sead7Vector2IfE4zeroE

ADD X30, X30, #0x10

end:
RET


//; Game::PlayerMgr::firstCalc(void) + 0x38
//; 0xF08400 -> BL 0x1B60FE4

//; Changes the controlled player if holding Minus and Right Stick Left/Right,
//; but only if playing offline and at least 2 players are in a match

//; Disables AI if Debug Marching is enabled on change (To allow controlling the 
//; player you just changed to - fix because of how my Marching implementation works)


//; Register reference:
//; X19 = Game::PlayerMgr*


.set BUTTONBIT_MINUS, 9
.set BUTTONBIT_RIGHT_STICK_LEFT, 26
.set BUTTONBIT_RIGHT_STICK_RIGHT, 27

.set BUTTON_RIGHT_STICK_LEFT, (1 << BUTTONBIT_RIGHT_STICK_LEFT)
.set BUTTON_RIGHT_STICK_RIGHT, (1 << BUTTONBIT_RIGHT_STICK_RIGHT)

.set DEBUG_MARCHING, 1

STP X29, X30, [SP, #-0x10]!

BL 0x116F730 //; Game::Utl::isOfflineScene(void)
TBZ W0, #0, end

MOV W0, WZR
BL 0x1A65E14 //; Lp::Utl::getCtrl(int)
LDR W8, [X0, #0x10]
TBZ W8, #BUTTONBIT_MINUS, end //; Not held

LDR W12, [X0, #0x94]
MOV W8, #(BUTTON_RIGHT_STICK_LEFT | BUTTON_RIGHT_STICK_RIGHT)
TST W12, W8
BEQ end//; Not triggered

LDR W9, [X19, #0x624]
CMP W9, #1
BLE end

SUB W9, W9, #1
MOV W10, #1
LDR W8, [X19, #0x5C8]

TST W12, #BUTTON_RIGHT_STICK_LEFT
CNEG W10, W10, NE

ADD W8, W8, W10

CMP W8, #0
CSEL W8, W8, W9, GE

CMP W8, W9
CSEL W8, W8, WZR, LE

STR W8, [X19, #0x5C8]

MOV X0, X19
BL 0xF07928 //; Game::PlayerMgr::onChangeControlledPlayer(void)

ADRP X8, #0x3DFE000
LDRB W8, [X8, #0x14]
CMP W8, #DEBUG_MARCHING
BNE end

MOV X0, X19
BL 0xF07B1C //; Game::PlayerMgr::getControlledPerformer(void)
BL 0xE3FF84 //; Game::Player::finish_RemoteAI(void)

end:
LDP X29, X30, [SP], #0x10
LDRB W8, [X19, #0x628]
RET