//; Game: Splatoon 2
//; Game version: 5.5.2
//; Code: Debug Player Changer


//; Hooks are placed in unused functions because there is no space left in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


//; Disable player inputs if Minus is held
//; Cmn::PlayerCtrl::isHold(ulong) + 0x10 and Cmn::PlayerCtrl::isTrig(ulong) + 0x10
//; 0xD5D38 -> BL 0x1AA96AC
//; 0xD5D68 -> BL 0x1AA96AC

//; If Minus is held, replace requested input mask with zero.
//; Done in the debug build for some reason, so replicating it


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
//; 0x107BCE4 -> BL 0x1AA96C0

//; If Minus is held, load Vector2 zero address and
//; skip getting the controller's right stick address
//; (since Vector2 address is loaded instead)

//; Probably done to avoid the camera from moving when enabling debug features
//; or other reason that I don't know (Similar to player inputs being disabled)

//; Skip by modifying hook's return address: LR + 0x10 = 0x107BCF8
//; Returns past the getRightStick call, where the stick values are loaded
//; from the returned pointer


.set BUTTONBIT_MINUS, 9

MOV X29, SP //; Original instruction
STP X29, X30, [SP,#-0x10]!

MOV W0, WZR
BL 0x19EC714 //; Lp::Utl::getCtrl(int)

LDP X29, X30, [SP], #0x10

LDR W0, [X0, #0x10]
TBZ W0, #BUTTONBIT_MINUS, end //; Minus button not held

ADRP X0, #0x2CFD000
LDR X0, [X0, #0x850] //; _ZN4sead7Vector2IfE4zeroE

ADD X30, X30, #0x10

end:
RET


//; Game::PlayerMgr::firstCalc(void) + 0x38
//; 0x10E70C8 -> BL 0x1AA96EC

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

BL 0x1354D1C //; Game::Utl::isOfflineScene
TBZ W0, #0, end

MOV W0, WZR
BL 0x19EC714 //; Lp::Utl::getCtrl(int)
LDR W8, [X0, #0x10]
TBZ W8, #BUTTONBIT_MINUS, end //; Minus button not held

LDR W12, [X0, #0x94]
MOV W8, #(BUTTON_RIGHT_STICK_LEFT | BUTTON_RIGHT_STICK_RIGHT)
TST W12, W8
BEQ end//; Right Stick Left/Right not triggered

LDR W9, [X19, #0x624]
CMP W9, #1
BLE end //; 1 player or less in a match

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
BL 0x10E6AE4 //; Game::PlayerMgr::onChangeControlledPlayer(void)

ADRP X8, #0x29E7000
LDRB W8, [X8, #0x14]
CMP W8, #DEBUG_MARCHING
BNE end

MOV X0, X19
BL 0x10E6D2C //; Game::PlayerMgr::getControlledPerformer(void)
BL 0x10138A8 //; Game::Player::finish_RemoteAI(void)

end:
LDP X29, X30, [SP], #0x10
LDRB W8, [X19, #0x628]
RET