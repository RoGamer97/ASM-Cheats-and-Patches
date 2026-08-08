//; Game: Splatoon 2
//; Game version: 5.5.2
//; Code: Debug Muteki


// Hooks are written over unused functions (never executed).
// There is a bit of free space in .text, but for some reason the emulator
// crashes when executing code in that space. Writing over unused functions
// doesn't cause a crash.


//; Disable player inputs if Minus is held
//; Cmn::PlayerCtrl::isHold(ulong) + 0x10 and Cmn::PlayerCtrl::isTrig(ulong) + 0x10
//; 0xD5D38 -> BL 0x1AA96AC
//; 0xD5D68 -> BL 0x1AA96AC

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


//; The Debug Muteki "bool" member variable exists in retail at Game::Player + 0x10C4
//; It is never read, but it is written to by 2 different functions:

//; Game::Player::reset_Impl(bool,Cmn::Def::ResetType) + 0x3D0 -> Sets it to "false"
//; Game::Player::calcPrepare(void) + 0x50 -> Sets it to "false"

//; In reality, it's not a "bool", it is actually an enum. The debug build shows that there were
//; supposed to be 5 types of Muteki (Normal, Shot, Player, MapObj and Bullet), thanks to the 
//; text draw strings leftover and also the fact that when checking for Debug Muteki, the game checks if the
//; value is less or equal to 5. But, in the debug build, only the Normal mode is used and every check is the same,
//; so it behaves the same for all. So, the type is not a bool for this one, but behaves as one.

//; This reimplementation will use it.
//; You will see checks for it in most hooks and writes to it in some places as well.


//; Debug Muteki Toggle and Text Timer Increment
//; Game::Player::calcControl(void) + 0xFE8
//; 0xFF497C -> BL 0x1AA9C18

//; Code will only run for controlled player (You)

//; Sets custom "dirty" bool when toggled, for Display Dirty (D) Debug Mark patch

//; Increments text flash timer in R-W if enabled.
//; Can't draw text here, so there is another hook for text drawing
//; but text flash timer must be incremented here because doing it in the 
//; text draw code would make the timer increase differently the function
//; it is hooked at may not run only once every frame

//; Disables Debug Moving when toggled


//; Register reference:
//; X19 = Game::Player*


.set BUTTONBIT_MINUS, 9
.set BUTTONBIT_L, 13

LDR W8, [X19, #0x358]
CBNZ W8, end //; Not controlled player

STP X29, X30, [SP, #-0x40]!

MOV W0, WZR
BL 0x19EC714 //; Lp::Utl::getCtrl(int)

ADRP X9, #0x29E7000

LDR W8, [X0, #0x10]
TBZ W8, #BUTTONBIT_MINUS, isInDebugMuteki //; Not held

LDR W0, [X0, #0x94]
TBZ W0, #BUTTONBIT_L, isInDebugMuteki //; Not triggered

LDR W8, [X19, #0x10C4]
EOR W8, W8, #1
STR W8, [X19, #0x10C4]

MOV W8, #0x10C0
STRB WZR, [X19,X8] //; Disable Debug Moving
 
MOV W8, #1
STRB W8, [X9, #0x15] //; Custom "dirty" bool

isInDebugMuteki:
LDR W8, [X19, #0x10C4]
CBZ W8, restore

//; Increase text timer in R-W region for text blink
//; Hooked here because text write function may execute
//; multiple times a frame, making the blink timing innacurates
LDR W8, [X9, #0xC]
ADD W8, W8, #1
STR W8, [X9, #0xC]

restore:
LDP X29, X30, [SP], #0x40

end:
MOV X0, X19 //; X0 is lost, so restore it
MOV W1, WZR //; Original instruction
RET


//; No Damage in Debug Moving and Debug Muteki
//; Same code used in both patches
//; Game::Player::isInState_NoDamage(void) + 0x334
//; 0x1010E8C -> BL 0x1AA980C

//; ORR Debug Moving bool and Debug Muteki "bool" together and ORR them
//; with returning W0 bool (invincible if either is true)

//; Register reference:
//; X19 = Game::Player*


LDRB W0, [X19, X8] //; Original instruction

MOV W8, #0x10C0
LDRB W1, [X19,X8] //; Debug Moving
LDR W2, [X19, #0x10C4] //; Debug Muteki
ORR W1, W1, W2
ORR W0, W0, W1
RET


//; Special Always Fully Charged
//; Game::Player::calcPaintGauge + 0x440
//; 0x100C6A8 -> BL 0x1AA9C80

//; If in Debug Muteki, make special always fully charged

//; Register reference:
//; X19 = Game::Player*


LDR W8, [X19, #0x10C4]
CBZ W8, end

STP X29, X30, [SP, #-0x10]!

MOV W1, W0
MOV W8, #0x11A0
ADD X0, X19, X8
BL 0xC0008 //; New function, name unknown

MOV W8, #0x11A4
ADD X0, X19, X8
FMOV S0, #0.0
BL 0xC031C //; New function, name unknown

LDP X29, X30, [SP], #0x10

end:
CMP W21, #1 //; Original instruction
RET


//; No damage voice and rumble (?)
//; Game::Player::informDamage_WithVoiceAndRumble(int,Cmn::Def::DMG,Game::DamageReason const&,bool,bool,bool) + 0x30
//; 0x1010448 -> BL 0x1AA9CB8

//; If in Debug Muteki, skips damage voice and rumble
//; Don't really know what this is for
//; You shouldn't be able to get damaged
//; Unless there are specific scenarios

//; Skip by modifying hook's return address: LR + 0x18C = 0x10105D8
//; Returns to the function's end

//; Register reference:
//; X0 = Game::Player*


MOV X22, X0 //; Original instruction

LDR W8, [X22, #0x10C4]
CBZ W8, end

ADD X30, X30, #0x18C

end:
RET


//; No water fall drown death
//; Game::Player::calcGndCol_WaterFall(void) + 0x64
//; 0x10164A4 -> BL 0x1AA9CCC

//; If in Debug Muteki, override player coordinate (S9)
//; in the function with water fall Y (S0),
//; after this hook, it branches to water fall death
//; if S9 is less than S0

//; Register reference:
//; X19 = Game::Player*


LDR W8, [X19, #0x10C4]
CMP W8, #0
FCSEL S9, S0, S9, NE
FCMP S9, S0 //; Original instruction
RET


//; No ink consume
//; Game::PlayerInkAction::consumeInk(float,bool,bool,bool) + 0x44
//; 0x108A91C -> BL 0x1AA9CE0

//; ORR Debug Muteki bool with W8, ink is not
//; consumed if W8 is 1

//; Register reference:
//; X0 = Game::Player*


LDR W9, [X0, #0x10C4]
ORR W8, W8, W9
CMP W8, #0 //; Original instruction
RET


//; Unaffected by enemy ink on the ground
//; Game::PlayerStepPaint::extractPaintTextureResult_Impl(float *,float *,int *,sead::Vector3<float> *,float *,sead::Vector3<float> const*,bool) + 0xEB4
//; 0x1129350 -> BL 0x1AA9CF0

//; If in Debug Muteki, store zero to some step paint related member variable
//; to be unaffected by it

//; Register reference:
//; X20 = Game::Player*StepPaint


LDR X8, [X20] //; Original instruction

LDR W9, [X8, #0x10C4]
CBZ W9, end

STR WZR, [X19]

end:
RET

//; Process for Die (?)
//; Game::PlayerTrouble::commonProcess_ForDie_Tmp(int,sead::Vector3<float> const&,int,uint) + 0x50
//; 0x1136CE4 -> BL 0x1AA9D04

//; No idea what this is either. Something with death
//; You can still die in Debug Muteki by falling off
//; or maybe other things, but I don't know if it's
//; related to this

//; ORR Debug Muteki bool with W8, after the hook it 
//; checks if W8 is not 0

//; Register reference:
//; X0 = Game::Player*


LDR W8, [X0, #0x350] //; Original instruction
LDR W9, [X0, #0x10C4]
ORR W8, W8, W9
RET


//; Restore Umbrella Canopy
//; Game::PlayerInkActionUmbrella::calc(void) + 0x390
//; 0x10C89E0 -> BL 0x1AA9D14

//; If in Debug Muteki, you can restore a canopy 
//; by pressing D-Pad Up after shooting one, allowing
//; you to shoot another one

//; Replaces canopy restore timer (W8) with current timer (W21)
//; for timer equality check so it restores it, only if 
//; D-Pad Up is triggered

//; Register reference:
//; X19 = Game::PlayerInkActionUmbrella*

.set BUTTONBIT_DPAD_UP, 16

LDR W8, [X8, #0x454] //; Original instruction

LDR X9, [X19]
LDR W9, [X9, #0x10C4]
CBZ W9, end

STP X29, X30, [SP, #-0x20]!
STR X8, [SP, #0x10]

MOV W0, WZR
BL 0x19EC714 //; Lp::Utl::getCtrl(int)

LDR X8, [SP, #0x10]
LDP X29, X30, [SP], #0x20

LDR W0, [X0, #0x94]
TBZ W0, #BUTTONBIT_DPAD_UP, end //; D-Pad Up not triggered

MOV W8, W21

end:
RET


//; Disable Debug Muteki on Octa 8-Ball Fall for Explosion Death
//; Game::PlayerMissionOctaSeqPinch::stateExplosion(void) + 0x50
//; 0x10EAD1C -> 0x1AA9D4C


//; Octa didn't exist when debug build got leaked, but I added this
//; because if your tank explodes due to 8-Ball falling on Octa 
//; mission, you will get softlocked because you didn't die

//; Set padding byte "IsInDebugMuteki" bool to false

LDR X0, [X19] //; Original instruction
STR WZR, [X0, #0x10C4]
RET


//; DbgTextWriter functions were removed after 3.1.0, but there is TextWriter debug text present in the game.
//; In gsys::SystemTask::invokeDrawTV_, there is some debug text that prints the TV draw information, such as the 
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

.set TEXT_FLASH_TIMER_MASK, 96

STP X29, X30, [SP, #-0x30]!
STP X19, X20, [SP, #0x10]
STP X21, X22, [SP, #0x20]

MOV X19, X0
MOV X20, X2
MOV X21, X4

ADRP X8, #0x2CFE000
LDR X9, [X8, #0x440] //; _ZN4sead7Color4f6cBlackE
LDR X8, [X8, #0x448] //; _ZN4sead7Color4f6cWhiteE

AND W3, W3, #TEXT_FLASH_TIMER_MASK
CMP W3, #TEXT_FLASH_TIMER_MASK
CSEL X22, X9, X8, EQ (Text)
CSEL X8, X9, X8, NE (Text Outline, inverted)

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


//; Debug Muteki Text
//; gsys::SystemTask::invokeDrawTV_(agl::DrawContext *) + 0x658
//; 0x1851910 -> BL 0x1AA9DB0

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

LDR W8, [X0, #0x10C4]
CBZ W8, end //; Debug Muteki disabled

ADRP X8, #0x29E7000
LDR W24, [X8, #0xC] //; Text flash timer

MOV X0, X26
ADR X1, string
ADR X2, posX
MOV W3, W24
MOV X4, XZR
BL 0x185165C //; My own text draw function

end:
LDP X29, X30, [SP], #0x10
LDR W8, [X19, #0x558] //; W8 is lost, restore it
LDUR X26, [X29, #-0x78] //; Original instruction
RET

posX: .float -610
posY: .float -175

string: .asciz "Debug @ Muteki"