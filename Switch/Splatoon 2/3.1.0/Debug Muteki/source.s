; Game: Splatoon 2
; Game version: 3.1.0
; Code: Debug Muteki


; Hooks are placed in unused functions because there is no space left in .text
; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


; Disable player inputs if Minus is held
; Cmn::PlayerCtrl::isHold + 0x10 and Cmn::PlayerCtrl::isTrig + 0x10
; 0x8ADB0 -> BL 0x1B61088
; 0x8ADE0 -> BL 0x1B61088

; If Minus is held, replace requested input mask with zero.
; Done in the debug build for some reason, so replicating it

LDR W8, [X19, #0x10]
TST W8, #0x200 // ; Minus button hold
CSEL X1, XZR, X1, NE
AND X1, X1, #0x3F // ; Original instruction
RET


; The Debug Muteki bool is not present in retail.
; Game::Player + 0x432 is a padding byte; use it for the "IsInDebugMuteki" bool
; You will see Debug Muteki bool checks in every hook


; Debug Muteki Toggle and Text
; Game::Player::calcControl + 0xE0C
; 00E23488 -> BL 0x1B614FC

; Code will only run for controlled player (You)
; Sets "dirty" bool when toggled, for Display Dirty (D) Debug Mark patch
; Draws text if enabled
; Disables Debug Moving when toggled

LDR W8, [X19, #0x358]
CBNZ W8, end // ; Not controlled player

STP X29, X30, [SP, #-0x40]!

MOV W0, WZR
BL 0x1A65E14 // ; Lp::Utl::getCtrl
LDR W8, [X0, #0x10]
TBZ W8, #9, isInDebugMuteki // ; Minus button not held

LDR W0, [X0, #0x94]
TBZ W0, #13, isInDebugMuteki // ; L button not triggered

LDRB W8, [X19, #0x432]
EOR W8, W8, #1
STRB W8, [X19, #0x432]

STRB WZR, [X19, #0x431] // ; Disable Debug Moving
 
BL 0x2C364 // ; Cmn::SetDbgMenuDirty

isInDebugMuteki:
LDRB W8, [X19, #0x432]
CBZ W8, restore

// ; Setup stack pointer params for text draw call

MOV X8, #0x100000000
STR X8, [SP, #0x10]

MOV X8, #0x3F8000003F800000
STR X8, [SP, #0x18]
STR WZR, [SP, #0x20]

// ; Increment timer in R-W region
// ; It is used for text flashing
ADRP X8, #0x3DFE000
LDR W9, [X8, #0xC]
ADD W9, W9, #1
STR W9, [X8, #0xC]
AND W9, W9, #0x60
CMP W9, #0x60

ADRP X8, #0x4156000
LDR X9, [X8, #0xE90] // ; _ZN4sead7Color4f6cBlackE
LDR X8, [X8, #0xE98] // ; _ZN4sead7Color4f6cWhiteE

CSEL X8, X9, X8, EQ // ; Load black or white color depending on text timer
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
BL 0x19BC22C // ; Lp::Sys::DbgTextWriter::productEntryF

restore:
LDP X29, X30, [SP], #0x40

end:
MOV X0, X19 // ; X0 is lost, so restore it
MOV W1, WZR // ; Original instruction
RET

posX: .float -610
posY: .float -175

string: .asciz "Debug @ Muteki"


; Disable Debug Moving, Debug Muteki and Debug Marching/Leading on Player Reset
; Same code used in all three patches
; Game::Player::reset_Impl + 0x3AC
; 0xE17288 -> BL 0x1B612CC

; Resets Debug Moving, Muteki and Marching/Leading on player reset
; Only used to cancel Debug Moving, Muteki and Marching/Leading on
; scene reload/reset by using Debug Scene Reload & Exit

STRB WZR, [X19, #0x431] // ; Disable Debug Moving
STRB WZR, [X19, #0x432] // ; Disable Debug Muteki

ADRP X8, #0x3DFE000
STRB WZR, [X8, #0x14] // ; Disable Debug Marching/Leading

MOV W8, #0xFFFF // ; Original instruction
RET


; No Damage in Debug Moving and Debug Muteki
; Same code used in both patches
; Game::Player::isInState_NoDamage + 0x324
; 0xE3D46C -> BL 0x1B612F0

; ORR Debug Move and Debug Muteki bools together and ORR them
; with returning W0 bool (invincible if either is true)

LDRB W0, [X19, X8] // ; Original instruction
LDRB W1, [X19, #0x431] // ; Debug Moving
LDRB W2, [X19, #0x432] // ; Debug Muteki
ORR W1, W1, W2
ORR W0, W0, W1
RET


; Special Always Fully Charged
; Game::Player::calcPaintGauge + 0x2C8
; 0xE39004 -> BL 0x1B615DC

; If in Debug Muteki, make special always fully charged

LDRB W8, [X19, #0x432]
CBZ W8, end

STR W0, [X19, #0x1144]
STR WZR, [X19, #0x1148]

end:
CMP W0, #1 // ; Original instruction
RET


; No damage voice and rumble (?)
; Game::Player::informDamage_WithVoiceAndRumble + 0x30
; 0xE3C928 -> BL 0x1B615F4

; If in Debug Muteki, skips damage voice and rumble
; Don't really know what this is for
; You shouldn't be able to get damaged
; Unless there are specific scenarios

; Skip by modifying hook's return address: LR + 0x16C = 0xE3CA98
; Returns to the function's end

MOV X22, X0 // ; Original instruction

LDRB W8, [X22, #0x432]
CBZ W8, end

ADD X30, X30, #0x16C

end:
RET


; No water fall drown death
; Game::Player::calcGndCol_WaterFall + 0x7C
; 00E42964 -> BL 0x1B61608

; If in Debug Muteki, override player coordinate (S9)
; in the function with water fall Y (S0),
; after this hook, it branches to water fall death
; if S9 is less than S0

LDRB W8, [X19, #0x432]
CMP W8, #0
FCSEL S9, S0, S9, NE
FCMP S9, S0 // ; Original instruction
RET


; No ink consume
; Game::PlayerInkAction::consumeInk + 0x74
; 0xEB0E7C -> BL 0x1B6161C

; ORR Debug Muteki bool with W8, ink is not
; consumed if W8 is 1

LDRB W9, [X0, #0x432]
ORR W8, W8, W9
TST W8, #1 // ; Original instruction
RET


; Unaffected by enemy ink on the ground
; Game::PlayerStepPaint::extractPaintTextureResult_Impl + 0xE8C
; 0xF43868 -> BL 0x1B6162C

; If in Debug Muteki, store zero to some step paint related member variable
; to be unaffected by it

LDR X8, [X20] // ; Original instruction

LDRB W9, [X8, #0x432]
CBZ W9, end

STR WZR, [X19]

end:
RET

; Process for Die (?)
; Game::PlayerTrouble::commonProcess_ForDie_Tmp + 0x50
; 0xF4C8CC -> BL 0x1B61640

; No idea what this is either. Something with death
; You can still die in Debug Muteki by falling off
; or maybe other things, but I don't know if it's
; related to this

; ORR Debug Muteki bool with W8, after the hook it 
; checks if W8 is not 0

LDR W8, [X0, #0x350] // ; Original instruction
LDRB W9, [X0, #0x432]
ORR W8, W8, W9
RET


; Restore Umbrella Canopy
; Game::PlayerInkActionUmbrella::calc + 0x278
; 0xEE9810 -> BL 0x01B61650

; If in Debug Muteki, you can restore a canopy 
; by pressing D-Pad Up after shooting one, allowing
; you to shoot another one

; Replaces canopy restore timer (W8) with current timer (W20)
; for timer equality check so it restores it, only if 
; D-Pad Up is triggered

LDR W8, [X8, #0x454] // ; Original instruction

LDR X9, [X19]
LDRB W9, [X9, #0x432]
CBZ W9, end

STP X29, X30, [SP, #-0x20]!
STR X8, [SP, #0x10]

MOV W0, WZR
BL 0x1A65E14 // ; Lp::Utl::getCtrl

LDR X8, [SP, #0x10]
LDP X29, X30, [SP], #0x20

LDR W0, [X0, #0x94]
TBZ W0, #16, end // ; D-Pad Up not triggered

MOV W8, W20

end:
RET


; Disable Debug Muteki on Octa 8-Ball Fall for Explosion Death
; Game::PlayerMissionOctaSeqPinch::stateExplosion + 0x50
; 0xF0B858 -> 0x1B619F0

; Octa didn't exist when debug build got leaked, but I added this
; because if your tank explodes due to 8-Ball falling on Octa 
; mission, you will get softlocked because you didn't die

; Set padding byte "IsInDebugMuteki" bool to false

LDR X0, [X19] // ; Original instruction
STRB WZR, [X0, #0x432]
RET