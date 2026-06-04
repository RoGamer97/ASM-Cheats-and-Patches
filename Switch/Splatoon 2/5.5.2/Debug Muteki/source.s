; Game: Splatoon 2
; Game version: 5.5.2
; Code: Debug Muteki


; Hooks are placed in unused functions because there is no space left in .text
; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


; Disable player inputs if Minus is held
; Cmn::PlayerCtrl::isHold + 0x10 and Cmn::PlayerCtrl::isTrig + 0x10
; 0xD5D38 -> BL 0x1AA96AC
; 0xD5D68 -> BL 0x1AA96AC

; If Minus is held, replace requested input mask with zero

LDR W8, [X19, #0x10]
TST W8, #0x200 // ; Minus button hold
CSEL X1, XZR, X1, NE
AND X1, X1, #0x3F // ; Original instruction
RET


; Game::Player + 0x432 is a padding byte; use it for the "IsInDebugMuteki" bool
; You will see Debug Muteki bool checks in every hook


; Debug Muteki Toggle and Text Timer Increment
; Game::Player::calcControl + 0xFE8
; 0xFF497C -> BL 0x1AA9BC4

; Code will only run for controlled player (You)
; Sets custom "dirty" bool when toggled, for Display Dirty (D) Debug Mark patch
; Draws text if enabled
; Disables Debug Moving when toggled

LDR W8, [X19, #0x358]
CBNZ W8, end // ; Not controlled player

STP X29, X30, [SP, #-0x40]!

MOV W0, WZR
BL 0x19EC714 // ; Lp::Utl::getCtrl
LDR W8, [X0, #0x10]
TBZ W8, #9, isInDebugMuteki // ; Minus button not held

LDR W0, [X0, #0x94]
TBZ W0, #13, isInDebugMuteki // ; L button not triggered

LDRB W8, [X19, #0x432]
EOR W8, W8, #1
STRB W8, [X19, #0x432]

STRB WZR, [X19, #0x431] // ; Disable Debug Moving
 
MOV W8, #1
STRB W8, [X9, #0x15] // ; Set custom "dirty" bool

isInDebugMuteki:
LDRB W8, [X19, #0x432]
CBZ W8, restore

// ; Increase text timer in R-W region for text blink
// ; Hooked here because text write function may execute
// ; multiple times a frame, making the blink timing innacurates
LDR W8, [X9, #0xC]
ADD W8, W8, #1
STR W8, [X9, #0xC]

restore:
LDP X29, X30, [SP], #0x40

end:
MOV X0, X19 // ; X0 is lost, so restore it
MOV W1, WZR // ; Original instruction
RET


; Disable Debug Moving, Debug Muteki and Debug Marching/Leading on Player Reset
; Same code used in all three patches
; Game::Player::reset_Impl + 0x3AC
; 0xFE7EC0 -> BL 0x1AA9808

; Resets Debug Moving, Muteki and Marching/Leading on player RESET,
; so, when players are loaded in or reset by using Debug Scene Reload

; Respawn does NOT reset players, and the features stay enabled after respawn

STRB WZR, [X19, #0x431] // ; Disable Debug Moving
STRB WZR, [X19, #0x432] // ; Disable Debug Muteki

ADRP X8, #0x29E7000
STRB WZR, [X8, #0x14] // ; Disable Debug Marching/Leading

MOV W8, #0xFFFF // ; Original instruction
RET


; No Damage in Debug Moving and Debug Muteki
; Same code used in both patches
; Game::Player::isInState_NoDamage + 0x334
; 0x1010E8C -> BL 0x1AA982C

; ORR Debug Move and Debug Muteki bools together and ORR them
; with returning W0 bool

LDRB W0, [X19, X8] // ; Original instruction
LDRB W1, [X19, #0x431] // ; Debug Moving
LDRB W2, [X19, #0x432] // ; Debug Muteki
ORR W1, W1, W2
ORR W0, W0, W1
RET


; Special Always Charged
; Game::Player::calcPaintGauge + 0x440
; 0x100C6A8 -> BL 0x1AA9C2C

; If in Debug Muteki, charge special

LDRB W8, [X19, #0x432]
CBZ W8, end

STP X29, X30, [SP, #-0x10]!

MOV W1, W0
MOV W8, #0x11A0
ADD X0, X19, X8
BL 0xC0008 // ; New function, name unknown

MOV W8, #0x11A4
ADD X0, X19, X8
FMOV S0, #0.0
BL 0xC031C // ; New function, name unknown

LDP X29, X30, [SP], #0x10

end:
CMP W21, #1 // ; Original instruction
RET


; No damage voice and rumble (?)
; Game::Player::informDamage_WithVoiceAndRumble + 0x30
; 0x1010448 -> BL 0x1AA9C68

; If in Debug Muteki, skips damage voice and rumble
; Don't really know what this is for
; You shouldn't be able to get damaged
; Unless there are specific scenarios

; Skip by modifying hook's return address: LR + 0x18C = 0x10105D8
; Returns back to function end

MOV X22, X0 // ; Original instruction

LDRB W8, [X22, #0x432]
CBZ W8, end

ADD X30, X30, #0x18C

end:
RET


; No water fall drown death
; Game::Player::calcGndCol_WaterFall + 0x64
; 0x10164A4 -> BL 0x1AA9C7C

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
; Game::PlayerInkAction::consumeInk + 0x44
; 0x108A91C -> BL 0x1AA9C90

; ORR Debug Muteki bool with W8, ink is not
; consumed if W8 is 1

LDRB W9, [X0, #0x432]
ORR W8, W8, W9
CMP W8, #0 // ; Original instruction
RET


; Unaffected by enemy ink on the ground
; Game::PlayerStepPaint::extractPaintTextureResult_Impl + 0xEB4
; 0x1129350 -> BL 0x1AA9CA0

; If in Debug Muteki, store zero to some step paint related member variable

LDR X8, [X20] // ; Original instruction

LDRB W9, [X8, #0x432]
CBZ W9, end

STR WZR, [X19]

end:
RET

; Process for Die (?)
; Game::PlayerTrouble::commonProcess_ForDie_Tmp + 0x50
; 0x1136CE4 -> BL 0x1AA9CB4

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
; Game::PlayerInkActionUmbrella::calc + 0x390
; 0x10C89E0 -> BL 0x1AA9CC4

; If in Debug Muteki, you can restore a canopy 
; by pressing D-Pad Up after shooting one, allowing
; you to shoot another one

; Replaces canopy restore timer (W8) with current timer (W21)
; for timer equality check so it restores it, only if 
; D-Pad Up is triggered

LDR W8, [X8, #0x454] // ; Original instruction

LDR X9, [X19]
LDRB W9, [X9, #0x432]
CBZ W9, end

STP X29, X30, [SP, #-0x20]!
STR X8, [SP, #0x10]

MOV W0, WZR
BL 0x19EC714 // ; Lp::Utl::getCtrl

LDR X8, [SP, #0x10]
LDP X29, X30, [SP], #0x20

LDR W0, [X0, #0x94]
TBZ W0, #16, end // ; D-Pad Up not triggered

MOV W8, W21

end:
RET


; Disable Debug Muteki on Octa 8-Ball Fall for Explosion Death
; Game::PlayerMissionOctaSeqPinch::stateExplosion + 0x50
; 0x10EAD1C -> 0x1AA9DCC


; Octa didn't exist when debug build got leaked, but I added this
; because if your tank explodes due to 8-Ball falling on Octa 
; mission, you will get softlocked because you didn't die

; Set padding byte "IsInDebugMuteki" bool to false

LDR X0, [X19] // ; Original instruction
STRB WZR, [X0, #0x432]
RET


; DbgTextWriter functions were removed after 3.1.0, but there is TextWriter debug text present in the game.
; In gsys::SystemTask::invokeDrawTV_, there is some debug text that prints the TV draw information, such as the 
; resolution width, scale, color etc. Trying to call TextWriter print is way complicated because it requires creating 
; and ; calling so many things for it to work, and I wasn't even able to do it because of how it is handled. 
; So, I decided to make my own system by enabling the debug TV draw info, removing the info draw, and making my own
; hooks there since everything I need to draw is already present there. Additionally, I even made my own function
; to print both text and text outline (they're separated) with the blink flash animation to make drawing text easier, 
; or else I'd have to replicate the draw setup multiple times, enlarging the code size by way too much...

; Starlight does the same thing to draw text (Enables TV draw, removes info draw etc) so I made some modifications in the
; function to make my text drawingcompatible with Starlight draws

; Enable debug TV draw info
; gsys::SystemTask::invokeDrawTV_ +0x284
; 0x185153C -> NOP


; Change one of the texts to nothing, to avoid printing it (Can't kill the text draw call because Starlight writes to that address)
; So doing this for compatibility
; 024AB808 -> 00 (Null terminator on first character)


; Skip drawing rest of debug text, at this point in the function, Starlight already hooked past all text, adding this if Starlight is 
; not being used
; 01851658 -> B 0x185190C


; My own function to draw the text, text outline and color flash. For Debug Moving, Debug Muteki and Debug Marching/Leading draw. Dirty (D) doesn't use this function
; 0185165C (Placed inside of the function, the part that is skipped. Other hooks will call this to draw text)

; Arguments: SP Address, String Address, Text Coords Address, Blink Timer, Address for Coords Vector3 (for Debug Moving Pos draw, pass null for none)

; Print text outline first, then text after

STP X29, X30, [SP, #-0x30]!
STP X19, X20, [SP, #0x10]
STP X21, X22, [SP, #0x20]

MOV X19, X0
MOV X20, X2
MOV X21, X4

ADRP X8, #0x2CFE000
LDR X9, [X8, #0x440] // ; _ZN4sead7Color4f6cBlackE
LDR X8, [X8, #0x448] // ; _ZN4sead7Color4f6cWhiteE

AND W3, W3, #0x60
CMP W3, #0x60
CSEL X22, X9, X8, EQ // ; Load black or white color depending on text timer (Text)
CSEL X8, X9, X8, NE // ; Load black or white color depending on text timer (Text Outline, inverted)

LDP X8, X9, [X8]
STR X8, [X19, #0x460]
STR X9, [X19, #0x468]

FMOV S0, #1.0
FMOV S1, #-1.0

// ; Offset text outline
LDP S2, S3, [X20]
FADD S2, S2, S0
FADD S3, S3, S1
ADD X0, X19, #0x450
STP S2, S3, [X0]

// ; Load coords XYZ for string format if not null
CBZ X21, formatString
LDP S0, S1, [X21]
LDR S2, [X21, #8]
FCVT D0, S0
FCVT D1, S1
FCVT D2, S2

formatString:
ADD X0, X19, #0x10
BL 0x13D030 // ; sead::FormatFixedSafeString<1024>::FormatFixedSafeString

ADD X0, X19, #0x10
LDR X8, [X19, #0x10]
LDR X8, [X8,#0x18]
BLR X8 // ; sead::BufferedSafeStringBase<char>::assureTerminationImpl_

// ; Print text outline
ADD X0, X19, #0x428
LDR X1, [X19, #0x18]
MOV W2, #0xFFFFFFFF
MOV W3, #1
MOV X4, XZR
BL 0x174A91C // ; sead::TextWriter::printImpl_

LDP X0, X1, [X22]
STR X0, [X19, #0x460]
STR X1, [X19, #0x468]

LDR X0, [X20]
STR X0, [X19, #0x450]

// ; Print text
ADD X0, X19, #0x428
LDR X1, [X19, #0x18]
MOV W2, #0xFFFFFFFF
MOV W3, #1
MOV X4, XZR
BL 0x174A91C // ; sead::TextWriter::printImpl_

LDP X19, X20, [SP, #0x10]
LDP X21, X22, [SP, #0x20]
LDP X29, X30, [SP], #0x30
RET


; Debug Muteki Text
; gsys::SystemTask::invokeDrawTV_ + 0x658
; 0x1851910 -> BL 0x1AA9D00

; Call my own text draw function for text draw

; This code is always executing, but it will only
; draw text if Debug Marching/Leading is enabled

; Since it always runs, nullptr checks must be
; done when trying to load PlayerMgr and 
; get the ControlledPerformer Game::Player

MOV X26, SP

STP X29, X30, [SP, #-0x10]!

ADRP X0, #0x2CFD000
LDR X0, [X0, #0xCF8]
LDR X0, [X0]
CBZ X0, end // ; Nullptr
BL 0x10E6D2C // ; Game::PlayerMgr::getControlledPerformer
CBZ X0, end // ; Nullptr

LDRB W8, [X0, #0x432]
CBZ W8, end // ; Debug Muteki disabled

ADRP X8, #0x29E7000
LDR W24, [X8, #0xC] // ; Text flash timer

MOV X0, X26
ADR X1, string
ADR X2, posX
MOV W3, W24
MOV X4, XZR
BL 0x185165C // ; My own text draw function

end:
LDP X29, X30, [SP], #0x10
LDR W8, [X19, #0x558] // ; W8 is lost, restore it
LDUR X26, [X29,#-0x78] // ; Original instruction
RET

posX: .float -610
posY: .float -175

string: .asciz "Debug @ Muteki"