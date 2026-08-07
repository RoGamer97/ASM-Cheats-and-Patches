//; Game: Splatoon 2
//; Game version: 5.5.2
//; Code: Debug Marching & Leading


//; Hooks are written in unused functions because there is no space left in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL **ADDRESS OF HOOK**


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


//; Fix Rival crash

//; Controlling rivals doesn't really work and will crash the game, 
//; even in the debug build, so fix the crash to avoid it just in case.
//; You will still be unable to control them, and may bug them out,
//; making them not move anymore if you try, so don't it.
//; Adding this for safety

//; Game::PlayerGamePad::isHold(ulong) + 0xC
//; 0x107BBD0 -> BL 0x1AA9D70

//; If X0 is nullptr, skip original instruction and return to
//; function's return false and end

//; Return to function end by modifying hook's return address: LR + 0xC = 0x107BBE0

//; Register reference:
//; X0 = Game::PlayerGamePad*


CBNZ X0, original //; Valid pointer

ADD X30, X30, #0xC
RET

original:
LDR X8, [X0]
RET


//; I've ran out of space, so the hook below is 
//; placed in Lp::Sys::TimeStamp::prepare.
//; TimeStamp is some sort of debug print 
//; that prints the product type, revision
//; and stuff like this. The print itself
//; doesn't work in 5.5.2, so it's useless.
//; So, stub its prepare function and then 
//; use it to write Debug Marching/leading
//; hooks.

//; 0x1967564 -> RET


//; Debug Marching & Leading
//; Game::Player::calcControl(void) + 0x33C0
//; 0xFF6D54 -> BL 0x1967568

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

//; Sets custom "dirty" bool when toggled, for Display Dirty (D) Debug Mark patch

//; Disables Debug Moving when toggled

//; Increments text flash timer in R-W if enabled.
//; Can't draw text here, so there is another hook for text drawing
//; but text flash timer must be incremented here because doing it in the 
//; text draw code would make the timer increase differently the function
//; it is hooked at may not run only once every frame

//; It loops through every player to enable/disable the AI,
//; but it will never set the controlled player to an AI

//; Hook location is different than Nintendo's, but works and
//; behaves the same way

//; Modes are stored in R-W area at 0x29E7014 and text flash timer at 0x29E7010
//; 0 -> Disabled, 1 -> Marching, 2 -> Leading


//; Register reference:
//; X19 = Game::Player*


.set BUTTONBIT_MINUS, 9
.set BUTTONBIT_RIGHT_STICK_UP, 24

.set DEBUG_MARCHING, 1
.set DEBUG_LEADING, 2

STP X29, X30, [SP, #-0x40]!

ADRP X25, #0x29E7000

LDR X27, [X19, #0x490]
MOV X0, X27
BL 0x10E6CC8 //; Game::PlayerMgr::getControlledAllKindPlayer(void)
MOV X26, X0 //; X26 is your Game::Player

MOV W0, WZR
BL 0x19EC714 //; Lp::Utl::getCtrl(int)

LDR W8, [X0, #0x10]
TBZ W8, #BUTTONBIT_MINUS, isMarchOrLead //; Minus button not held

LDR W10, [X19, #0x358]
LDRB W8, [X25, #0x14]
CBZ W8, isStickUp //; Debug Marching/Leading disabled

LDR W8, [X0, #0x94]
TBZ W8, #BUTTONBIT_MINUS, isStickUp //; Minus button not triggered

CBNZ W10, isStickUp //; Not controlled player

STRB WZR, [X25, #0x14] //; Disable Debug Marching/Leading

MOV W24, #0

disableAILoop:
MOV X0, X27
MOV W1, W24
BL 0x10E6EE4 //; Game::PlayerMgr::getPerformerAt(uint)
BL 0x10138A8 //; Game::Player::finish_RemoteAI(void)

ADD W24, W24, #1
LDR W25, [X27, #0x624]
CMP W24, W25
BLT disableAILoop
B end

isStickUp:
LDR W8, [X0, #0x94]
TBZ W8, #BUTTONBIT_RIGHT_STICK_UP, isMarchOrLead //; Right Stick Up not triggered

CBNZ W10, changeRemoteAILoop //; Not controlled player

LDRB W8, [X25, #0x14]
ADD W8, W8, #1
CMP W8, #DEBUG_LEADING
CSEL W8, W8, WZR, LE
STRB W8, [X25, #0x14]

MOV W8, #0x10C0
STRB WZR, [X19,X8] //; Disable Debug Moving

MOV W8, #1
STRB W8, [X25, #0x15] //; Custom "dirty" bool

MOV W24, WZR

changeRemoteAILoop:
MOV X0, X27
MOV W1, W24
BL 0x10E6EE4 //; Game::PlayerMgr::getPerformerAt(uint)

LDRB W8, [X25, #0x14]
LDR W9, [X0, #0x358]
CMP W8, #0
CCMP W9, #0, #0, NE
BEQ nextPlayer //; Controlled player

CMP W8, #0
CSET W8, GT
MOV W9, #0x10E0
STRB W8, [X0,X9] //; RemoteAI bool

nextPlayer:
ADD W24, W24, #1
LDR W8, [X27, #0x624]
CMP W24, W8
BLT changeRemoteAILoop

isMarchOrLead:
LDRB W24, [X25, #0x14]
CBZ W24, end //; Debug Marching/Leading disabled

LDR W8, [X19, #0x358]
CBNZ W8, calcMarchAndLead //; Not controlled player

//; Increase text timer in R-W region for text flash
//; Hooked here because text write function may execute
//; multiple times a frame, making the flash timing innacurates
LDR W8, [X25, #0x10]
ADD W8, W8, #1
STR W8, [X25, #0x10]
B end

calcMarchAndLead:
CMP W24, #DEBUG_MARCHING
BEQ marchingCopyStick

//; Calculate controlled player point for AI follow

LDR W8, [X26, #0x328]
LDR W9, [X19, #0x328]

LDR S2, [X26, #0x74C]
LDR S3, [X26, #0x750]
CMP W8, W9

ADRP X8, #0x24BB000
LDR S0, [X8, #0xE4C] //; 35.0
FMOV S1, #20.0

FCSEL S8, S1, S0, EQ

LDR S0, [X19, #0x748]
LDR S1, [X26, #0x748]
FSUB S0, S0, S1
LDR S1, [X19, #0x74C]
FSUB S1, S1, S2
LDR S2, [X19, #0x750]
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
BL 0x1B06E70 //; sqrt

notNaN:
LDR S1, [X8, #0x9F0] //; 0.2
FCMP S0, S8
BLS walkToControlledPlayer

LDR S2, [X8, #0x930] //; 100.0
FCMP S0, S2
BLT cont

FMOV S1, #1.0
B walkToControlledPlayer

cont:
FSUB S2, S2, S8
FCMP S2, #0.0
BEQ walkToControlledPlayer

FSUB S0, S0, S8
LDR S1, [X8, #0xAA0] //; 0.8
FMUL S0, S0, S1
LDR S1, [X8, #0x9F0] //; 0.2
FDIV S0, S0, S2
FADD S1, S0, S1
B walkToControlledPlayer

marchingCopyStick:
LDR X8, [X26, #0x498]
STR X8, [X19, #0x498]

LDR X8, [X26, #0x4A0]
STR X8, [X19, #0x4A0]
LDR X8, [X19, #0xEF8]
B copyActions

walkToControlledPlayer:
LDR X8, [X19, #0xEF8]

LDR X9, [X26, #0x748]
STR X9, [X8, #8]

LDR W9, [X26, #0x750]
STR W9, [X8, #0x10]

STP S8, S1, [X8, #0x14]

copyActions:
LDR X10, [X26, #0x5D8]
STR X10, [X8, #0x1C]

LDR W10, [X26, #0x5E0]
LDR W9, [X26, #0x5F4]
STP W10, W9, [X8, #0x24]

LDRB W9, [X26, #0x4B0]
STRB W9, [X8, #0x2C]

LDR W9, [X26, #0x4DC]
CMP W9, #0
CSET W9, GT
STRB W9, [X8, #0x2D]

LDR W9, [X26, #0x4E0]
CMP W9, #0
CSET W9, GT
STRB W9, [X8, #0x2E]

LDRB W9, [X26, #0x4F1]
STRB W9, [X8, #0x2F]

end:
LDP X29, X30, [SP], #0x40
LDP D9, D8, [SP, #0xA0] //; Original instruction
RET


//; Disable Debug Marching/Leading on Player Reset
//; Same code used in all three patches
//; Game::Player::reset_Impl(bool,Cmn::Def::ResetType) + 0x3AC
//; 0xFE7EC0 -> BL 0x19677A4

//; Disables Debug Marching/Leading on player reset
//; (Loading in a match or resetting it with Debug Scene Reload & Exit)

ADRP X8, #0x29E7000
STRB WZR, [X8, #0x14]

MOV W8, #0xFFFF //; Original instruction
RET



//; DbgTextWriter functions were removed after 3.1.0, but there is TextWriter debug text present in the game.
//; In gsys::SystemTask::invokeDrawTV_(agl::DrawContext *), there is some debug text that prints the TV draw information, such as the 
//; resolution width, scale, color etc. Trying to call TextWriter print is way complicated because it requires creating 
//; and //; calling so many things for it to work, and I wasn't even able to do it because of how it is handled. 
//; So, I decided to make my own system by enabling the debug TV draw info, removing the info draw, and making my own
//; hooks there since everything I need to draw is already present there. Additionally, I even made my own function
//; to print both text and text outline (they're separated) with the blink flash animation to make drawing text easier, 
//; or else I'd have to replicate the draw setup multiple times, enlarging the code size by way too much...

//; Starlight does the same thing to draw text (Enables TV draw, removes info draw etc) so I made some modifications in the
//; function to make my text drawingcompatible with Starlight draws

//; Enable debug TV draw info
//; gsys::SystemTask::invokeDrawTV_(agl::DrawContext *) +0x284
//; 0x185153C -> NOP


//; Change one of the texts to nothing, to avoid printing it (Can't kill the text draw call because Starlight writes to that address)
//; So doing this for compatibility
//; 024AB808 -> 00 (Null terminator on first character)


//; Skip drawing rest of debug text, at this point in the function, Starlight already hooked past all text, adding this if Starlight is 
//; not being used
//; 01851658 -> B 0x185190C


//; My own function to draw the text, text outline and color flash. For Debug Moving, Debug Muteki and Debug Marching/Leading draw. Dirty (D) doesn't use this function
//; 0185165C (Placed inside of the function, the part that is skipped. Other hooks will call this to draw text)

//; Arguments: SP Address, String Address, Text Coords Address, Blink Timer, Address for Coords Vector3 (for Debug Moving Pos draw, pass null for none)

//; Print text outline first, then text after

//; Register reference:
//; X0 = SP address
//; X1 = String address
//; X2 = Text Coords Address
//; W3 = Blink Timer
//; X4 = Player Coords Address


STP X29, X30, [SP, #-0x30]!
STP X19, X20, [SP, #0x10]
STP X21, X22, [SP, #0x20]

MOV X19, X0
MOV X20, X2
MOV X21, X4

ADRP X8, #0x2CFE000
LDR X9, [X8, #0x440] //; _ZN4sead7Color4f6cBlackE
LDR X8, [X8, #0x448] //; _ZN4sead7Color4f6cWhiteE

AND W3, W3, #0x60
CMP W3, #0x60
CSEL X22, X9, X8, EQ //; Load black or white color depending on text timer (Text)
CSEL X8, X9, X8, NE //; Load black or white color depending on text timer (Text Outline, inverted)

LDP X8, X9, [X8]
STR X8, [X19, #0x460]
STR X9, [X19, #0x468]

FMOV S0, #1.0
FMOV S1, #-1.0

//; Offset text outline
LDP S2, S3, [X20]
FADD S2, S2, S0
FADD S3, S3, S1
ADD X0, X19, #0x450
STP S2, S3, [X0]

//; Load coords XYZ for string format if not null
CBZ X21, formatString
LDP S0, S1, [X21]
LDR S2, [X21, #8]
FCVT D0, S0
FCVT D1, S1
FCVT D2, S2

formatString:
ADD X0, X19, #0x10
BL 0x13D030 //; sead::FormatFixedSafeString<1024>::FormatFixedSafeString(char const*,...)

ADD X0, X19, #0x10
LDR X8, [X19, #0x10]
LDR X8, [X8,#0x18]
BLR X8 //; sead::BufferedSafeStringBase<char>::assureTerminationImpl_(void)

//; Print text outline
ADD X0, X19, #0x428
LDR X1, [X19, #0x18]
MOV W2, #0xFFFFFFFF
MOV W3, #1
MOV X4, XZR
BL 0x174A91C //; sead::TextWriter::printImpl_(char const*,int,bool,sead::BoundBox2<float> *)

LDP X0, X1, [X22]
STR X0, [X19, #0x460]
STR X1, [X19, #0x468]

LDR X0, [X20]
STR X0, [X19, #0x450]

//; Print text
ADD X0, X19, #0x428
LDR X1, [X19, #0x18]
MOV W2, #0xFFFFFFFF
MOV W3, #1
MOV X4, XZR
BL 0x174A91C //; sead::TextWriter::printImpl_(char const*,int,bool,sead::BoundBox2<float> *)

LDP X19, X20, [SP, #0x10]
LDP X21, X22, [SP, #0x20]
LDP X29, X30, [SP], #0x30
RET


//; Debug Marching/Leading Text
//; gsys::SystemTask::invokeDrawTV_(agl::DrawContext *) + 0x65C
//; 0x1851914 -> BL 0x19677B4

//; Call my own text draw function for text draw

//; This code is always executing, but it will only
//; draw text if Debug Marching/Leading is enabled

//; Since it always runs, nullptr checks must be
//; done when trying to load PlayerMgr and 
//; get the ControlledPerformer Game::Player

MOV X26, SP

STP X29, X30, [SP, #-0x10]!

ADRP X0, #0x2CFD000
LDR X0, [X0, #0xCF8]
LDR X0, [X0]
CBZ X0, end //; Nullptr
BL 0x10E6D2C //; Game::PlayerMgr::getControlledPerformer(void)
CBZ X0, end //; Nullptr

ADRP X8, #0x29E7000
LDRB W9, [X8, #0x14]
CBZ W9, end //; Debug Marching/Leading disabled

LDR W24, [X8, #0x10] //; Text flash timer

MOV X0, X26
ADR X1, marchingString
ADR X2, leadingString
CMP W9, #1
CSEL X1, X1, X2, EQ //; Choose string based on mode
ADR X2, posX
MOV W3, W24
MOV X4, XZR
BL 0x185165C //; My own text draw function

MOV X0, X26
ADR X1, cancelString
ADR X2, posXCancel
MOV W3, W24
MOV X4, XZR
BL 0x185165C //; My own text draw function

end:
LDP X29, X30, [SP], #0x10
LDR W8, [X19, #0x558] //; W8 is lost, reload it
LDUR X26, [X29, #-0x78] //; Restore X26
LDR W24, [SP, #0xC] //; Original instruction
RET

posX: .float -610
posY: .float -280

posXCancel: .float -610
posYCancel: .float -295

marchingString: .asciz "Debug Marching..."
leadingString: .asciz "Debug Leading..."
cancelString: .asciz "  Push [-] -> Cancel"