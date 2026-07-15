//; Game: Splatoon 2
//; Game version: Global Testfire
//; Code: Debug Marching & Leading


//; Hooks are written in unused functions because there is no space left in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL **ADDRESS OF HOOK**


//; Disable player inputs if Minus is held
//; Cmn::PlayerCtrl::isHold(ulong) + 0x10 and Cmn::PlayerCtrl::isTrig(ulong) + 0x10
//; 0x64048 -> BL 0x1180260
//; 0x64074 -> BL 0x1180260

//; If Minus is held, replace requested input mask with zero.
//; Done in the debug build for some reason, so replicating it

//; Register reference:
//; X19 = Lp::Sys::Ctrl*


.set BUTTON_MINUS, 0x200

LDR W8, [X19, #0x10]
TST W8, #BUTTON_MINUS
CSEL X1, XZR, X1, NE
AND X1, X1, #0x3F //; Original instruction
RET


//; Disable right stick if Minus is held
//; Game::PlayerGamePad::getRightStick(void) + 0x20
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
BL 0x10A4808 //; Lp::Utl::getCtrl(int)

LDP X29, X30, [SP], #0x10

LDR W0, [X0, #0x10]
TBZ W0, #9, end //; Minus button not held

ADRP X0, #0x2B6D000
LDR X0, [X0, #0x298] //; _ZN4sead7Vector2IfE4zeroE

ADD X30, X30, #0x10

end:
RET


//; Fix Rival crash

//; Controlling rivals doesn't really work and will crash the game, 
//; even in the debug build, so fix the crash to avoid it just in case.
//; You will still be unable to control them, and may bug them out,
//; making them not move anymore if you try, so don't it.
//; Adding this for safety

//; Game::PlayerGamePad::isHold(ulong) + 0xC
//; 0x75885C -> BL 0x118083C

//; If X0 is nullptr, skip original instruction and return to
//; function's return false and end

//; Return to function end by modifying hook's return address: LR + 0xC = 0X75886C

//; Register reference:
//; X0 = Game::PlayerGamePad*


CBNZ X0, original //; Valid pointer

ADD X30, X30, #0xC
RET

original:
LDR X8, [X0]
RET


//; Debug Marching & Leading

//; Nintendo coded Debug Marching differently, 
//; it doesn't transform the player into an AI and
//; it checks for Marching mode in 189 different
//; functions, likely patching each thing for 
//; every marching player

//; Debug Leading doesn't do this, it transforms the
//; players into AI (to follow a point, which is the player)
//; and the input action copy is just directly copying the
//; controlled player's inputs to the AI's inputs

//; For my reimplementation, Debug Leading is 
//; the exact same as the debug build, copying Nintendo's code
//; (but changing offsets etc because of version difference ofc),
//; with minor changes but Marching is different, it does transform 
//; the player into an AI and copies the controlled player's inputs and
//; stick to the AI. Works perfectly, I don't know why Nintendo didn't do this

//; For changing players to AI and changing mode, it
//; only does it when iterated player is controlled player,
//; because else it would happen multiple times a frame instead 
//; of once, and to avoid desync with Debug Moving toggle

//; Sets "dirty" bool when toggled, for Display Dirty (D) Debug Mark patch

//; Disables Debug Moving when toggled

//; Draws text if enabled

//; It loops through every player to enable/disable the AI,
//; but it will never set the controlled player to an AI

//; Hook location is different than Nintendo's, but works and
//; behaves the same way

//; Modes are stored in R-W area at 0x2968014 and text flash timer at 0x2968010
//; 0 -> Disabled, 1 -> Marching, 2 -> Leading

//; Register reference:
//; X19 = Game::Player*


.set DEBUG_MARCHING, 1
.set DEBUG_LEADING, 2

STP X29, X30, [SP, #-0x40]!

ADRP X25, #0x2968000

LDR X27, [X19, #0x3C8]
MOV X0, X27
BL 0x7CBA68 //; Game::PlayerMgr::getControlledAllKindPlayer(void)
MOV X26, X0 //; X26 is your Game::Player

MOV W0, WZR
BL 0x10A4808 //; Lp::Utl::getCtrl(int)

LDR W8, [X0, #0x10]
TBZ W8, #9, isMarchOrLead //; Minus button not held

LDR W10, [X19, #0x358]
LDRB W8, [X25, #0x14]
CBZ W8, isStickUp //; Debug Marching/Leading disabled

LDR W8, [X0, #0x94]
TBZ W8, #9, isStickUp //; Minus button not triggered

CBNZ W10, isStickUp //; Not controlled player

STRB WZR, [X25, #0x14] //; Disable Debug Marching/Leading

MOV W24, #0

disableAILoop:
MOV X0, X27
MOV W1, W24
BL 0x7CBC1C //; Game::PlayerMgr::getPerformerAt(uint)
BL 0x73929C //; Game::Player::finish_RemoteAI(void)

ADD W24, W24, #1
LDR W25, [X27, #0x52C]
CMP W24, W25
BLT disableAILoop
B end

isStickUp:
LDR W8, [X0, #0x94]
TBZ W8, #24, isMarchOrLead //; Right Stick Up not triggered

CBNZ W10, changeRemoteAILoop //; Not controlled player

LDRB W8, [X25, #0x14]
ADD W8, W8, #1
CMP W8, #DEBUG_LEADING
CSEL W8, W8, WZR, LE
STRB W8, [X25, #0x14]

STRB WZR, [X19, #0xD90] //; Disable Debug Moving

BL 0x25244 //; Cmn::SetDbgMenuDirty(void)

MOV W24, WZR

changeRemoteAILoop:
MOV X0, X27
MOV W1, W24
BL 0x7CBC1C //; Game::PlayerMgr::getPerformerAt(uint)

LDRB W8, [X25, #0x14]
LDR W9, [X0, #0x358]
CMP W8, #0
CCMP W9, #0, #0, NE
BEQ nextPlayer //; Controlled player

CMP W8, #0
CSET W8, GT
STRB W8, [X0, #0xDB0] //; RemoteAI bool

nextPlayer:
ADD W24, W24, #1
LDR W8, [X27, #0x52C]
CMP W24, W8
BLT changeRemoteAILoop

isMarchOrLead:
LDRB W24, [X25, #0x14]
CBZ W24, end //; Debug Marching/Leading disabled

LDR W8, [X19, #0x358]
CBNZ W8, calcMarchAndLead //; Not controlled player

//; Setup stack for text draw call

MOV X8, #0x100000000
STR X8, [SP, #0x10]

MOV X8, #0x3F8000003F800000
STR X8, [SP, #0x18]
STR WZR, [SP, #0x20]

//; Increment timer in R-W region
//; It is used for text flashing
LDR W9, [X25, #0x10]
ADD W9, W9, #1
STR W9, [X25, #0x10]
AND W9, W9, #0x60
CMP W9, #0x60

ADRP X8, #0x2B6D000
LDR X9, [X8, #0x870] //; _ZN4sead7Color4f6cBlackE
LDR X8, [X8, #0x878] //; _ZN4sead7Color4f6cWhiteE

CSEL X8, X9, X8, EQ //; Load black or white color depending on text timer
LDP X0, X1, [X8] 
STR X0, [SP, #0x24]
STR X1, [SP, #0x2C]

MOV W8, #0x400
STR W8, [SP, #0x34]

LDR X8, posX
STR X8, [SP, #0x38]

ADRP X0, #0x2B6D000
LDR X0, [X0, #0x700]
LDR X0, [X0]
MOV X26, X0
MOV W1, #0x1E
ADD X2, SP, #0x38
ADD X3, SP, #0x10
CMP W24, #1
ADR X4, marchingString
ADR X5, leadingString
CSEL X4, X4, X5, EQ //; Choose string based on mode
BL 0xFF9EC8 //; Lp::Sys::DbgTextWriter::productEntryF(int, sead::Vector2<float> const&, Lp::Sys::DbgTextWriter::ArgEx const*, char const*, ...)

LDR S0, posYCancel
STR S0, [SP, #0x3C]

MOV X0, X26
MOV W1, #0x1E
ADD X2, SP, #0x38
ADD X3, SP, #0x10
ADR X4, cancelString
BL 0xFF9EC8 //; Lp::Sys::DbgTextWriter::productEntryF(int, sead::Vector2<float> const&, Lp::Sys::DbgTextWriter::ArgEx const*, char const*, ...)
B end

calcMarchAndLead:
CMP W24, #DEBUG_MARCHING //; Debug Marching
BEQ marchingCopyStick

//; Calculate controlled player point for AI follow

LDR W8, [X26, #0x328]
LDR W9, [X19, #0x328]

LDR S2, [X26, #0x654]
LDR S3, [X26, #0x658]
CMP W8, W9

ADRP X8, #0x2502000
LDR S0, [X8, #0xB54] //; 35.0
FMOV S1, #20.0

FCSEL S8, S1, S0, EQ

LDR S0, [X19, #0x650]
LDR S1, [X26, #0x650]
FSUB S0, S0, S1
LDR S1, [X19, #0x654]
FSUB S1, S1, S2
LDR S2, [X19, #0x658]
FSUB S2, S2, S3
FMUL S0, S0, S0
FMUL S1, S1, S1
FADD S0, S0, S1
FMUL S1, S2, S2
FMUL S1, S2, S2
FADD S1, S0, S1
FSQRT S0, S1
FCMP S0, S0
BVC notNaN

MOV V0.16B, V1.16B
BL 0x1249C58

notNaN:
LDR S1, [X8, #0x6FC] //; 0.2
FCMP S0, S8
BLS walkToControlledPlayer

LDR S2, [X8, #0x704] //; 100.0
FCMP S0, S2
BLT cont

FMOV S1, #1.0
B walkToControlledPlayer

cont:
FSUB S2, S2, S8
FCMP S2, #0.0
BEQ walkToControlledPlayer

FSUB S0, S0, S8
LDR S1, [X8, #0x6F8] //; 0.8
FMUL S0, S0, S1
LDR S1, [X8, #0x828] //; 0.2
FDIV S0, S0, S2
FADD S1, S0, S1
B walkToControlledPlayer

marchingCopyStick:
LDR X8, [X26, #0x3D0]
STR X8, [X19, #0x3D0]

LDR X8, [X26, #0x3D8]
STR X8, [X19, #0x3D8]
LDR X8, [X19, #0xC60]
B copyActions

walkToControlledPlayer:
LDR X8, [X19, #0xC60]

LDR X9, [X26, #0x650]
STR X9, [X8, #8]

LDR W9, [X26, #0x658]
STR W9, [X8, #0x10]

STP S8, S1, [X8, #0x14]

copyActions:
LDR X10, [X26, #0x4F0]
STR X10, [X8, #0x1C]

LDR W10, [X26, #0x4F8]
LDR W9, [X26, #0x50C]
STP W10, W9, [X8, #0x24]

LDRB W9, [X26, #0x3E8]
STRB W9, [X8, #0x2C]

LDR W9, [X26, #0x410]
CMP W9, #0
CSET W9, GT
STRB W9, [X8, #0x2D]

LDR W9, [X26, #0x414]
CMP W9, #0
CSET W9, GT
STRB W9, [X8, #0x2E]

LDRB W9, [X26, #0x425]
STRB W9, [X8, #0x2F]

end:
LDP X29, X30, [SP], #0x40
LDP D9, D8, [SP, #0x80] //; Original instruction
RET

posX: .float -610
posY: .float -280

posYCancel: .float -295

marchingString: .asciz "Debug Marching..."
leadingString: .asciz "Debug Leading..."
cancelString: .asciz "  Push [-] -> Cancel"


//; Disable Debug Marching/Leading on Player Reset
//; Same code used in all three patches
//; Game::Player::reset_Impl(bool,Cmn::Def::ResetType) + 0x3AC
//; 0x71B51C -> BL 0x1180470

//; Disables Debug Marching/Leading on player reset
//; (Loading in a match or resetting it with Debug Scene Reload & Exit)

ADRP X8, #0x2968000
STRB WZR, [X8, #0x14]

MOV W8, #0xFFFF //; Original instruction
RET