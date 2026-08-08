//; Game: Splatoon 2
//; Game version: 3.1.0
//; Code: Debug Muteki


// Hooks are written over unused functions (never executed).
// There is a bit of free space in .text, but for some reason the emulator
// crashes when executing code in that space. Writing over unused functions
// doesn't cause a crash.


//; Disable player inputs if Minus is held
//; Cmn::PlayerCtrl::isHold(ulong) + 0x10 and Cmn::PlayerCtrl::isTrig(ulong) + 0x10
//; 0x8ADB0 -> BL 0x1B61088
//; 0x8ADE0 -> BL 0x1B61088

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


//; The Debug Muteki "bool" member variable exists in retail at Game::Player + 0x108C
//; It is never read, but it is written to by 2 different functions:

//; Game::Player::reset_Impl(bool,Cmn::Def::ResetType) + 0x3C0 -> Sets it to "false"
//; Game::Player::calcPrepare(void) + 0x4C -> Sets it to "false"

//; In reality, it's not a "bool", it is actually an enum. The debug build shows that there were
//; supposed to be 5 types of Muteki (Normal, Shot, Player, MapObj and Bullet), thanks to the 
//; text draw strings leftover and also the fact that when checking for Debug Muteki, the game checks if the
//; value is less or equal to 5. But, in the debug build, only the Normal mode is used and every check is the same,
//; so it behaves the same for all. So, the type is not a bool for this one, but behaves as one.

//; This reimplementation will use it.
//; You will see checks for it in most hooks and writes to it in some places as well.


//; Debug Muteki Toggle and Text
//; Game::Player::calcControl(void) + 0xE0C
//; 00E23488 -> BL 0x1B61588

//; Code will only run for controlled player (You)

//; Sets "dirty" bool when toggled, for Display Dirty (D) Debug Mark patch

//; Draws text if enabled

//; Disables Debug Moving when toggled


//; Register reference:
//; X19 = Game::Player*


.set BUTTONBIT_MINUS, 9
.set BUTTONBIT_L, 13

.set TEXT_FLASH_TIMER_MASK, 96

LDR W8, [X19, #0x358]
CBNZ W8, end //; Not controlled player

STP X29, X30, [SP, #-0x40]!

MOV W0, WZR
BL 0x1A65E14 //; Lp::Utl::getCtrl(int)
LDR W8, [X0, #0x10]
TBZ W8, #BUTTONBIT_MINUS, isInDebugMuteki //; Not held

LDR W0, [X0, #0x94]
TBZ W0, #BUTTONBIT_L, isInDebugMuteki //; Not triggered

LDR W8, [X19, #0x108C]
EOR W8, W8, #1
STR W8, [X19, #0x108C]

MOV W8, #0x1088
STRB WZR, [X19,X8] //; Disable Debug Moving
 
BL 0x2C364 //; Cmn::SetDbgMenuDirty(void)

isInDebugMuteki:
LDR W8, [X19, #0x108C]
CBZ W8, restore

//; Setup stack for text draw call
MOV X8, #0x100000000
STR X8, [SP, #0x10]

MOV X8, #0x3F8000003F800000
STR X8, [SP, #0x18]
STR WZR, [SP, #0x20]

//; Increment timer in R-W region
//; It is used for text flashing
ADRP X8, #0x3DFE000
LDR W9, [X8, #0xC]
ADD W9, W9, #1
STR W9, [X8, #0xC]
AND W9, W9, #TEXT_FLASH_TIMER_MASK
CMP W9, #TEXT_FLASH_TIMER_MASK

ADRP X8, #0x4156000
LDR X9, [X8, #0xE90] //; _ZN4sead7Color4f6cBlackE
LDR X8, [X8, #0xE98] //; _ZN4sead7Color4f6cWhiteE

CSEL X8, X9, X8, EQ //; Load black or white color depending on text timer
LDP X0, X1, [X8] 
STR X0, [SP, #0x24]
STR X1, [SP, #0x2C]

MOV W8, #0x400
STR W8, [SP, #0x34]

LDR X8, posX
STR X8, [SP, #0x38]

ADRP X0, #0x4156000
LDR X0, [X0, #0xBD0]
LDR X0, [X0]
MOV W1, #0x1E
ADD X2, SP, #0x38
ADD X3, SP, #0x10
ADR X4, string 
BL 0x19BC22C //; Lp::Sys::DbgTextWriter::productEntryF(int, sead::Vector2<float> const&, Lp::Sys::DbgTextWriter::ArgEx const*, char const*, ...)

restore:
LDP X29, X30, [SP], #0x40

end:
MOV X0, X19 //; X0 is lost, so restore it
MOV W1, WZR //; Original instruction
RET

posX: .float -610
posY: .float -175

string: .asciz "Debug @ Muteki"


//; No Damage in Debug Moving and Debug Muteki
//; Same code used in both patches
//; Game::Player::isInState_NoDamage(void) + 0x324
//; 0xE3D46C -> BL 0x1B612DC

//; ORR Debug Moving bool and Debug Muteki "bool" together and ORR them
//; with returning W0 bool (invincible if either is true)

//; Register reference:
//; X19 = Game::Player*


LDRB W0, [X19, X8] //; Original instruction

MOV W8, #0x1088
LDRB W1, [X19,X8] //; Debug Moving
LDR W2, [X19, #0x108C] //; Debug Muteki
ORR W1, W1, W2
ORR W0, W0, W1
RET


//; Special Always Fully Charged
//; Game::Player::calcPaintGauge + 0x2C8
//; 0xE39004 -> BL 0x1B6166C

//; If in Debug Muteki, make special always fully charged

//; Register reference:
//; X19 = Game::Player*


LDR W8, [X19, #0x108C]
CBZ W8, end

STR W0, [X19, #0x1144]
STR WZR, [X19, #0x1148]

end:
CMP W0, #1 //; Original instruction
RET


//; No damage voice and rumble (?)
//; Game::Player::informDamage_WithVoiceAndRumble(int,Cmn::Def::DMG,Game::DamageReason const&,bool,bool,bool) + 0x30
//; 0xE3C928 -> BL 0x1B61684

//; If in Debug Muteki, skips damage voice and rumble
//; Don't really know what this is for
//; You shouldn't be able to get damaged
//; Unless there are specific scenarios

//; Skip by modifying hook's return address: LR + 0x16C = 0xE3CA98
//; Returns to the function's end

//; Register reference:
//; X0 = Game::Player*


MOV X22, X0 //; Original instruction

LDR W8, [X22, #0x108C]
CBZ W8, end

ADD X30, X30, #0x16C

end:
RET


//; No water fall drown death
//; Game::Player::calcGndCol_WaterFall(void) + 0x7C
//; 0xE42964 -> BL 0x1B61698

//; If in Debug Muteki, override player coordinate (S9)
//; in the function with water fall Y (S0),
//; after this hook, it branches to water fall death
//; if S9 is less than S0

//; Register reference:
//; X19 = Game::Player*


LDR W8, [X19, #0x108C]
CMP W8, #0
FCSEL S9, S0, S9, NE
FCMP S9, S0 //; Original instruction
RET


//; No ink consume
//; Game::PlayerInkAction::consumeInk(float,bool,bool,bool) + 0x74
//; 0xEB0E7C -> BL 0x1B616AC

//; ORR Debug Muteki bool with W8, ink is not
//; consumed if W8 is 1

//; Register reference:
//; X0 = Game::Player*


LDR W9, [X0, #0x108C]
ORR W8, W8, W9
TST W8, #1 //; Original instruction
RET


//; Unaffected by enemy ink on the ground
//; Game::PlayerStepPaint::extractPaintTextureResult_Impl(float *,float *,int *,sead::Vector3<float> *,float *,sead::Vector3<float> const*,bool) + 0xE8C
//; 0xF43868 -> BL 0x1B616BC

//; If in Debug Muteki, store zero to some step paint related member variable
//; to be unaffected by it

//; Register reference:
//; X20 = Game::Player*StepPaint


LDR X8, [X20] //; Original instruction

LDR W9, [X8, #0x108C]
CBZ W9, end

STR WZR, [X19]

end:
RET


//; Process for Die (?)
//; Game::PlayerTrouble::commonProcess_ForDie_Tmp(int,sead::Vector3<float> const&,int,uint) + 0x50
//; 0xF4C8CC -> BL 0x1B616D0

//; No idea what this is either. Something with death
//; You can still die in Debug Muteki by falling off
//; or maybe other things, but I don't know if it's
//; related to this

//; ORR Debug Muteki bool with W8, after the hook it 
//; checks if W8 is not 0

//; Register reference:
//; X0 = Game::Player*


LDR W8, [X0, #0x350] //; Original instruction
LDR W9, [X0, #0x108C]
ORR W8, W8, W9
RET


//; Restore Umbrella Canopy
//; Game::PlayerInkActionUmbrella::calc(void) + 0x278
//; 0xEE9810 -> BL 0x1B616E0

//; If in Debug Muteki, you can restore a canopy 
//; by pressing D-Pad Up after shooting one, allowing
//; you to shoot another one

//; Replaces canopy restore timer (W8) with current timer (W20)
//; for timer equality check so it restores it, only if 
//; D-Pad Up is triggered

//; Register reference:
//; X19 = Game::PlayerInkActionUmbrella*


LDR W8, [X8, #0x454] //; Original instruction

LDR X9, [X19]
LDR W9, [X9, #0x108C]
CBZ W9, end

STP X29, X30, [SP, #-0x20]!
STR X8, [SP, #0x10]

MOV W0, WZR
BL 0x1A65E14 //; Lp::Utl::getCtrl(int)

LDR X8, [SP, #0x10]
LDP X29, X30, [SP], #0x20

LDR W0, [X0, #0x94]
TBZ W0, #16, end //; D-Pad Up not triggered

MOV W8, W20

end:
RET


//; Disable Debug Muteki on Octa 8-Ball Fall for Explosion Death
//; Game::PlayerMissionOctaSeqPinch::stateExplosion(void) + 0x50
//; 0xF0B858 -> 0x1B61718

//; Octa didn't exist when debug build got leaked, but I added this
//; because if your tank explodes due to 8-Ball falling on Octa 
//; mission, you will get softlocked because you didn't die

//; Set Debug Muteki "bool" to false

//; Register reference:
//; X19 = Game::Player*MissionOctaSeqPinch*


LDR X0, [X19] //; Original instruction
STR WZR, [X0, #0x108C]
RET