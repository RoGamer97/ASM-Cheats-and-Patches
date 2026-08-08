//; Game: Splatoon 2
//; Game version: 5.5.2
//; Code: Debug Scene Reload & Exit


// Hooks are written over unused functions (never executed).
// There is a bit of free space in .text, but for some reason the emulator
// crashes when executing code in that space. Writing over unused functions
// doesn't cause a crash.


//; Lp::Sys::Scene::sceneSysCalc(void) + 0xD8 
//; (Replacing call for Lp::Utl::SceneDbgResetter::calc)
//; which was used in debug build, but stubbed in retail
//; 0x197E1D0 -> BL 0x1AA95B4

//; Resets, reloads or exits a scene depending on the button combination
//; Added match checks to avoid resets and reloads in menus (Avoids crash)

//; Store action hold to padding bytes (0x10A and 0x10B) to avoid spamming the 
//; action or happening on button trigger, and to make it only happen after releasing
//; the buttons


//; Register reference:
//; X19 = Game::CmnScene*


.set BUTTONBIT_L, 13
.set BUTTONBIT_DPAD_UP, 16
.set BUTTONBIT_DPAD_DOWN, 17

.set BUTTON_L, (1 << BUTTONBIT_L)
.set BUTTON_DPAD_UP, (1 << BUTTONBIT_DPAD_UP)
.set BUTTON_DPAD_DOWN, (1 << BUTTONBIT_DPAD_DOWN)

.set PENDING_RESET_SHORT, 1
.set PENDING_EXIT_SHORT, 2

.set HOLD_DURATION, 40

STP X29, X30, [SP, #-0x20]!
STP X27, X28, [SP, #0x10]

LDRB W8, [X0, #0x1A0]
CBZ W8, end

ADRP X0, #0x2CFE000
LDR X0, [X0, #0xEA0]
LDR X0, [X0]
LDR X28, [X0, #0x338]

MOV W0, WZR
BL 0x19EC714 //; Lp::Utl::getCtrl(int)
MOV X27, X0

ADRP X8, #0x2CFD000
LDR X8, [X8, #0x910]
LDR X8, [X8]
CBZ X8, isExitShort //; Not in a match

LDR W8, [X0, #0x10]
LDR W9, buttons_L_Down
AND W0, W8, W9
CMP W0, W9
BNE isPendingResetShort //; L and D-Pad Down not held together

MOV W0, #PENDING_RESET_SHORT
STRB W0, [X28, #0x10A]
B isResetLong

isPendingResetShort:
LDRB W0, [X28, #0x10A]
CMP W0, #PENDING_RESET_SHORT
BNE isResetLong
MOV X0, X19
BL 0xA01C78 //; Game::CmnScene::cbResetShort(void)
B clearPending

isResetLong:
MOV X0, X27
MOV W1, W9
MOV W2, #HOLD_DURATION
BL 0x1962954 //; Lp::Sys::Ctrl::isHoldContinue(uint,int)
CBZ W0, isExitShort

MOV X0, X19
BL 0xB3728 //; Game::CmnScene::cbResetLong(void)
B clearPending

isExitShort:
LDR W8, [X27, #0x10]
LDR W9, buttons_L_Up
AND W0, W8, W9
CMP W0, W9
BNE isHoldDown //; L and D-Pad Up not held together

MOV W0, #PENDING_EXIT_SHORT
STRB W0, [X28, #0x10A]
B end

isHoldDown:
LDRB W0, [X28, #0x10A]
CMP W0, #PENDING_EXIT_SHORT
BNE end

MOV X0, X19
BL 0xB3898 //; Cmn::SceneBase::cbExitShort(void)

clearPending:
STRB WZR, [X28, #0x10A]

end:
LDP X27, X28, [SP, #0x10]
LDP X29, X30, [SP], #0x20
RET

buttons_L_Up: .word BUTTON_L | BUTTON_DPAD_UP
buttons_L_Down: .word BUTTON_L | BUTTON_DPAD_DOWN