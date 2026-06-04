; Game: Splatoon 2
; Game version: 3.1.0
; Code: Debug Scene Reload & Exit


; Hooks are placed in unused functions because there is no space left in .text
; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


; Lp::Sys::Scene::sceneSysCalc + 0xD8 
; (Replacing call for Lp::Utl::SceneDbgResetter::calc)
; which was used in debug build, but stubbed in retail
; 0x19DF77C -> BL 0x1B60EBC

; Resets, reloads or exits a scene depending on the button combination
; Added match checks to avoid resets and reloads in menus (Avoids crash)

; Store an action hold to padding byte (0x10A) to avoid spamming the 
; action or happening on trig, and to make it only happen if releasing
; the button

STP X29, X30, [SP, #-0x20]!
STP X27, X28, [SP, #0x10]

LDRB W8, [X0, #0x1A0]
CBZ W8, end

ADRP X0, #0x4157000
LDR X0, [X0, #0x8E8]
LDR X0, [X0]
LDR X28, [X0, #0x338]

MOV W0, WZR
BL 0x1A65E14 // ; Lp::Utl::getCtrl
MOV X27, X0

ADRP X8, #0x4156000
LDR X8, [X8, #0x8C0]
LDR X8, [X8]
CBZ X8, isExitShort // ; Not in a match

LDR W8, [X0, #0x10]
LDR W9, buttons_L_Down
AND W0, W8, W9
CMP W0, W9
BNE isPendingResetShort // ; L and D-Pad Down not held together

MOV W0, #1
STRB W0, [X28, #0x10A]
B isResetLong

isPendingResetShort:
LDRB W0, [X28, #0x10A]
CMP W0, #1
BNE isResetLong
MOV X0, X19
BL 0x89A80C // ; Game::CmnScene::cbResetShort
B clearPending

isResetLong:
MOV X0, X27
MOV W1, W9
MOV W2, #0x28 // ; 40 frames (0.66 seconds of hold)
BL 0x19B344C // ; Lp::Sys::Ctrl::isHoldContinue
CBZ W0, isExitShort

MOV X0, X19
BL 0x89A870 // ; Game::CmnScene::cbResetLong
B clearPending

isExitShort:
LDR W8, [X27, #0x10]
LDR W9, buttons_L_Up
AND W0, W8, W9
CMP W0, W9
BNE clearHold // ; L and D-Pad Up not held together

MOV W0, #2
STRB W0, [X28, #0x10A]
B isExitLong

clearHold:
STRB WZR, [X28, #0x10B]

LDRB W0, [X28, #0x10A]
CMP W0, #2
BNE isExitLong

MOV X0, X19
BL 0x69288 // ; Cmn::SceneBase::cbExitShort
B clearPending

isExitLong:
LDRB W8, [X28, #0x10B]
CBNZ W8, end

MOV X0, X27
MOV W1, W9
MOV W2, #0x28 // ; 40 frames (0.66 seconds of hold)
BL 0x19B344C // ; Lp::Sys::Ctrl::isHoldContinue
CBZ W0, end

MOV X0, X19
BL 0x69400 // ; Cmn::SceneBase::cbExitLong

MOV W8, #1
STRB W8, [X28, #0x10B]

clearPending:
STRB WZR, [X28, #0x10A]

end:
LDP X27, X28, [SP, #0x10]
LDP X29, X30, [SP], #0x20
RET

buttons_L_Up: .word 0x12000
buttons_L_Down: .word 0x22000