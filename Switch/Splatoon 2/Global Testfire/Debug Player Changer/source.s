//; Game: Splatoon 2
//; Game version: Global Testfire
//; Code: Debug Player Changer


//; Hooks are placed in unused functions because there is no space left in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*

//; Disable player inputs if Minus is held
//; Cmn::PlayerCtrl::isHold + 0x10 and Cmn::PlayerCtrl::isTrig + 0x10
//; 0x64048 -> BL 0x1180260
//; 0x64074 -> BL 0x1180260

//; If Minus is held, replace requested input mask with zero.
//; Done in the debug build for some reason, so replicating it

LDR W8, [X19, #0x10]
TST W8, #0x200 //; Minus button hold
CSEL X1, XZR, X1, NE
AND X1, X1, #0x3F //; Original instruction
RET


//; Disable right stick if Minus is held
//; Game::PlayerGamePad::getRightStick + 0x20
//; 0x758970 -> BL 0x1180274

//; If Minus is held, load Vector2 zero address and
//; skip getting the controller's right stick address
//; (since Vector2 address is loaded instead)

//; Probably done to avoid the camera from moving when enabling debug features
//; or other reason that I don't know (Similar to player inputs being disabled)

//; Skip by modifying hook's return address: LR + 0x10 = 0x758984
//; Returns past the getRightStick call, where the stick values are loaded
//; from the returned pointer

MOV X29, SP //; Original instruction
STP X29, X30, [SP,#-0x10]!

MOV W0, WZR
BL 0x10A4808 //; Lp::Utl::getCtrl

LDP X29, X30, [SP], #0x10

LDR W0, [X0, #0x10]
TBZ W0, #9, end //; Minus button not held

ADRP X0, #0x2B6D000
LDR X0, [X0, #0x298] //; _ZN4sead7Vector2IfE4zeroE

ADD X30, X30, #0x10

end:
RET


//; Game::PlayerMgr::firstCalc + 0x2C
//; 0x7CC34C -> BL 0x11801BC

//; Changes the controlled player if holding Minus and Right Stick Left/Right,
//; but only if playing offline and at least 2 players are in a match

//; Disables AI if Debug Marching is enabled on change (To allow controlling the 
//; player you just changed to - fix because of how my Marching implementation works)

STP X29, X30, [SP, #-0x10]!

BL 0x9122D8 //; Game::Utl::isOfflineScene
TBZ W0, #0, end

MOV W0, WZR
BL 0x10A4808 //; Lp::Utl::getCtrl
LDR W8, [X0, #0x10]
TBZ W8, #9, end //; Minus button not held

LDR W12, [X0, #0x94]
MOV W8, #0xC000000
TST W12, W8
BEQ end//; Right Stick Left/Right not triggered

LDR W9, [X19, #0x52C]
CMP W9, #1
BLE end //; 1 player or less in a match

SUB W9, W9, #1
MOV W10, #1
LDR W8, [X19, #0x4D0]

TST W12, #0x4000000 //; Right Stick Left
CNEG W10, W10, NE

ADD W8, W8, W10

CMP W8, #0
CSEL W8, W8, W9, GE

CMP W8, W9
CSEL W8, W8, WZR, LE

STR W8, [X19, #0x4D0]

MOV X0, X19
BL 0x7CB8D8 //; Game::PlayerMgr::onChangeControlledPlayer

ADRP X8, #0x2968000
LDRB W8, [X8, #0x14]
CMP W8, #1 // Debug Marching
BNE end

MOV X0, X19
BL 0x7CBACC //; Game::PlayerMgr::getControlledPerformer
BL 0x73929C //; Game::Player::finish_RemoteAI

end:
LDP X29, X30, [SP], #0x10
LDRB W8, [X19, #0x530] //; Original instruction
RET