//; Game: Splatoon 2
//; Game version: Global Testfire
//; Code: Debug Muteki


//; Hooks are placed in unused functions because there is no space left in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


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


//; The Debug Muteki "bool" member variable exists in retail at Game::Player + 0xD94
//; It is never read, but it is written to by 2 different functions:

//; Game::Player::reset_Impl(bool,Cmn::Def::ResetType) + 0x3EC -> Sets it to "false"
//; Game::Player::calcPrepare(void) + 0x50 -> Sets it to "false"

//; In reality, it's not a "bool", it is actually an enum. The debug build shows that there were
//; supposed to be 5 types of Muteki (Normal, Shot, Player, MapObj and Bullet), thanks to the 
//; text draw strings leftover and also the fact that when checking for Debug Muteki, the game checks if the
//; value is less or equal to 5. But, in the debug build, only the Normal mode is used and every check is the same,
//; so it behaves the same for all. So, the type is not a bool for this one, but behaves as one.

//; This reimplementation will use it.
//; You will see checks for it in most hooks and writes to it in some places as well.


//; Debug Muteki Toggle and Text
//; Game::Player::calcControl(void) + 0x9A8
//; 0x722D04 -> BL 0x1180690

//; Code will only run for controlled player (You)

//; Sets "dirty" bool when toggled, for Display Dirty (D) Debug Mark patch

//; Draws text if enabled

//; Disables Debug Moving when toggled

//; Register reference:
//; X19 = Game::Player*


LDR W8, [X19, #0x358]
CBNZ W8, end //; Not controlled player

STP X29, X30, [SP, #-0x40]!

MOV W0, WZR
BL 0x10A4808 //; Lp::Utl::getCtrl(int)
LDR W8, [X0, #0x10]
TBZ W8, #9, isInDebugMuteki //; Minus button not held

LDR W0, [X0, #0x94]
TBZ W0, #13, isInDebugMuteki //; L button not triggered

LDR W8, [X19, #0xD94]
EOR W8, W8, #1
STR W8, [X19, #0xD94]

STRB WZR, [X19, #0xD90] //; Disable Debug Moving
 
BL 0x2C364 //; Cmn::SetDbgMenuDirty(void)

isInDebugMuteki:
LDRB W8, [X19, #0xD94]
CBZ W8, restore

//; Setup stack for text draw call

MOV X8, #0x100000000
STR X8, [SP, #0x10]

MOV X8, #0x3F8000003F800000
STR X8, [SP, #0x18]
STR WZR, [SP, #0x20]

//; Increment timer in R-W region
//; It is used for text flashing
ADRP X8, #0x2968000
LDR W9, [X8, #0xC]
ADD W9, W9, #1
STR W9, [X8, #0xC]
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
MOV W1, #0x1E
ADD X2, SP, #0x38
ADD X3, SP, #0x10
ADR X4, string 
BL 0xFF9EC8 //; Lp::Sys::DbgTextWriter::productEntryF(int, sead::Vector2<float> const&, Lp::Sys::DbgTextWriter::ArgEx const*, char const*, ...)

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
//; Game::Player::isInState_NoDamage(void) + 0x2C4
//; 0x7371D4 -> BL 0x1180494

//; ORR Debug Moving bool and Debug Muteki "bool" together and ORR them
//; with returning W0 bool (invincible if either is true)

//; Register reference:
//; X19 = Game::Player*


LDRB W0, [X19, #0xDE4] //; Original instruction

LDRB W1, [X19, #0xD90] //; Debug Moving
LDR W2, [X19, #0xD94] //; Debug Muteki
ORR W1, W1, W2
ORR W0, W0, W1
RET


//; Special Always Fully Charged
//; Game::Player::calcPaintGauge + 0x2B0
//; 0x73417C -> BL 0x1180774

//; If in Debug Muteki, make special always fully charged

//; Register reference:
//; X19 = Game::Player*


LDR W8, [X19, #0xD94]
CBZ W8, end

STR W0, [X19, #0xE0C]
STR WZR, [X19, #0xE10]

end:
CMP W0, #1 //; Original instruction
RET


//; No damage voice and rumble (?)
//; Game::Player::informDamage_WithVoiceAndRumble(int,Cmn::Def::DMG,Game::DamageReason const&,bool,bool,bool) + 0x34
//; 0x736BE4 -> BL 0x118078C

//; If in Debug Muteki, skips damage voice and rumble
//; Don't really know what this is for
//; You shouldn't be able to get damaged
//; Unless there are specific scenarios

//; Skip by modifying hook's return address: LR + 0x1A8 = 0x736D90
//; Returns back to function end

//; Register reference:
//; X0 = Game::Player*


MOV X22, X0 //; Original instruction

LDR W8, [X22, #0xD94]
CBZ W8, end

ADD X30, X30, #0x1A8

end:
RET


//; No water fall drown death
//; Game::Player::calcGndCollision + 0x3264
//; 0x7326F4 -> BL 0x11807A0

//; If in Debug Muteki, override player coordinate (S11)
//; in the function with water fall Y (S0),
//; after this hook, it branches to water fall death
//; if S11 is less than S0

//; Register reference:
//; X19 = Game::Player*


LDR W8, [X19, #0xD94]
CMP W8, #0
FCSEL S11, S0, S11, NE
FCMP S11, S0 //; Original instruction
RET


//; No ink consume
//; Game::PlayerInkAction::consumeInk(float,bool,bool,bool) + 0x74
//; 0x787C30 -> BL 0x11807B4

//; ORR Debug Muteki bool with W8, ink is not
//; consumed if W8 is 1

//; Register reference:
//; X0 = Game::Player*


LDR W9, [X0, #0xD94]
ORR W8, W8, W9
TST W8, #1 //; Original instruction
RET


//; Unaffected by enemy ink on the ground
//; Game::PlayerStepPaint::extractPaintTextureResult_Impl(float *,float *,int *,sead::Vector3<float> *,float *,sead::Vector3<float> const*,bool) + 0xB30
//; 0x7F5AEC -> BL 0x11807C4

//; If in Debug Muteki, store zero to some step paint related member variable
//; to be unaffected by it

//; Register reference:
//; X20 = Game::Player*StepPaint


LDR X0, [X20] //; Original instruction

LDR W8, [X0, #0xD94]
CBZ W8, end

STR WZR, [X19]

end:
RET

//; Process for Die (?)
//; Game::PlayerTrouble::commonProcess_ForDie_Tmp(int,sead::Vector3<float> const&,int,uint) + 0x4C
//; 0x7FB9AC -> BL 0x11807D8

//; No idea what this is either. Something with death
//; You can still die in Debug Muteki by falling off
//; or maybe other things, but I don't know if it's
//; related to this

//; ORR Debug Muteki bool with W8, after the hook it 
//; checks if W8 is not 0

//; Register reference:
//; X0 = Game::Player*


LDR W8, [X0, #0x350] //; Original instruction
LDR W9, [X0, #0xD94]
ORR W8, W8, W9
RET


//; Restore Umbrella Canopy
//; Game::PlayerInkActionUmbrella::calc(void) + 0xE8
//; 0x7B33BC -> BL 0x11807E8

//; If in Debug Muteki, you can restore a canopy 
//; by pressing D-Pad Up after shooting one, allowing
//; you to shoot another one

//; Replaces canopy restore timer (W9) with current timer (W8)
//; for timer equality check so it restores it, only if 
//; D-Pad Up is triggered

//; Register reference:
//; X19 = Game::PlayerInkActionUmbrella*


LDR W9, [X8, #0x44C] //; Original instruction

LDR X11, [X19]
LDR W11, [X11, #0xD94]
CBZ W11, end

STP X29, X30, [SP, #-0x20]!
STP X8, X9, [SP, #0x10]

MOV W0, WZR
BL 0x10A4808 //; Lp::Utl::getCtrl(int)

LDP X8, X9, [SP, #0x10]
LDP X29, X30, [SP], #0x20

LDR W0, [X0, #0x94]
TBZ W0, #16, end //; D-Pad Up not triggered

MOV W9, W8

end:
RET