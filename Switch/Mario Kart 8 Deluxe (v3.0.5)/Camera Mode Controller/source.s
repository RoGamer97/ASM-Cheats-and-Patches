//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: Camera Mode Controller

//; You can find some documented headers here to learn more about the game: https://github.com/fishguy6564/MK8DX-Headers


//; Hooks are written in unused functions because there is no space left in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


//; Toggle camera mode anywhere
//; ui::Page_Race::onCalc_(void) + 0x2DC
//; 0x531818 -> BL 0xAAF59C

//; !!!!!!!!!!TODO!!!!!!!!!!!!!!!

.set BUTTONBIT_LEFT_STICK_IN, 7
.set BUTTON_LEFT_STICK_IN, (1 << BUTTONBIT_LEFT_STICK_IN)

STP X29, X30, [SP, #-0x10]!

MOV W0, WZR
BL 0x8B94A4 //; gear::GetControllerRace(int)
LDR X8, [X0, #0x158]
LDR W8, [X8, #0x114]
TST W8, #BUTTON_LEFT_STICK_IN
CSET W8, NE

end:
LDP X29, X30, [SP], #0x10
RET


//; Camera mode cycler
//; DemoCameraController::calcReplay(void) + 0x24
//; 0xCC6B0 -> BL 0xAAF5C0

//; !!!!!!!!!!!!!!TODO!!!!!!!!!!!!

//; Register reference:
//; X19 = DemoCameraController*


.set LAST_CAM, 5

.set BUTTONBIT_DPAD_LEFT, 18
.set BUTTONBIT_DPAD_RIGHT, 19

.set BUTTON_DPAD_LEFT, (1 << BUTTONBIT_DPAD_LEFT)
.set BUTTON_DPAD_RIGHT, (1 << BUTTONBIT_DPAD_RIGHT)

UBFX W9, W8, #0x19, #4 //; Original instruction
STP X29, X30, [SP, #-0x20]!
STP X8, X9, [SP, #0x10]

MOV W0, WZR
BL 0x8B94A4 //; gear::GetControllerRace(int)
LDR X0, [X0, #0x158]
LDR W8, [X0, #0x114]
TBZ W8, #6, isModifiedCam //; Right Stick In not pressed

LDR W8, [X0, #8]
TST W8, #(BUTTON_DPAD_LEFT | BUTTON_DPAD_RIGHT)
BEQ isModifiedCam

MOV W9, #1
TST W8, #BUTTON_DPAD_LEFT
CNEG W9, W9, NE

MOV W10, #1
MOV W11, #LAST_CAM
LDRB W8, [X19, #0x16E]
ADD W8, W8, W9
CMP W8, #0
CSEL W8, W11, W8, LE
CMP W8, W11
CSEL W8, W10, W8, GT
STRB W8, [X19, #0x16E]

LDR X8, [X19, #0x118]
STR WZR, [X8, #0x130]
STR WZR, [X8, #0x13C]

isModifiedCam:
LDRB W8, [X19, #0x16E]
CBZ W8, end
SUB W8, W8, #1
STR W8, [SP, #0x18]

end:
LDP X8, X9, [SP, #0x10]
LDP X29, X30, [SP], #0x20
RET


//; Camera zoom, rotation and culling
//; 
//; 0x7DFF00 -> BL 0xAAF648

!!!!!!TODO!!!!!!!!!!

.set BUTTONBIT_X, 3
.set BUTTONBIT_Y, 4
.set BUTTONBIT_DPAD_UP, 16
.set BUTTONBIT_DPAD_DOWN, 17

.set BUTTON_X, (1 << BUTTONBIT_X)
.set BUTTON_Y, (1 << BUTTONBIT_Y)

.set BUTTON_DPAD_UP, (1 << BUTTONBIT_DPAD_UP)
.set BUTTON_DPAD_DOWN, (1 << BUTTONBIT_DPAD_DOWN)

STP X29, X30, [SP, #-0x10]!

MOV W0, WZR
BL 0x8B94A4 //; gear::GetControllerRace(int)
LDR X0, [X0, #0x158]
LDR W8, [X0, #0x114]
TBZ W8, #6, isZoomMode //; Right Stick In not held

LDR W9, [X0, #8]
TBZ W9, #16, isZoomMode //; D-Pad Up not triggered

LDRB W10, [X20, #0x16F]
EOR W10, W10, #1
STRB W10, [X20, #0x16F]

isZoomMode:
LDRB W10, [X20, #0x16F]
CBZ W10, zoomDisabled

LDR S0, [X20, #0x1C8]
LDR S1, [X20, #0x1CC]
LDR S2, minZoomSpeed

FCMP S0, #0.0
BNE isZoomButton

STR S2, [X20, #0x1C8]
STR S12, [X20, #0x1CC]
FMOV S1, S12

isZoomButton:
TST W8, #(BUTTON_X | BUTTON_Y)
BEQ setZoom

LDR S3, [X0, #0x124]
LDR S4, changeBy
FMUL S3, S3, S4
FADD S0, S0, S3

FCMP S0, S2
FCSEL S0, S2, S0, LE

LDR S2, maxZoomSpeed
FCMP S0, S2
FCSEL S0, S2, S0, GE

STR S0, [X20, #0x1C8]

TBZ W8, #3, add

FNEG S0, S0

add:
FADD S1, S1, S0

storeZoom:
FCMP S1, S12
FCSEL S1, S12, S1, LE
STR S1, [X20, #0x1CC]
STR S1, [X20, #0x1D0]

setZoom:
STR S1, [X20, #0x108]
B calcRotate

zoomDisabled:
LDR S1, [X20, #0x108]

FSUB S3, S1, S12

LDR S4, mulLess
FMUL S3, S3, S4
FSUB S1, S1, S3
STR S1, [X20,#0x108]

calcRotate:
LDR S0, [X0, #0x128]
LDR S1, [X0, #0x12C]
LDR S2, rotXsensivity
FMUL S0, S0, S2

BL 0x87C244 //; gear::GetRaceInfo(void)
LDRB W8, [X0, #0x26]
CBZ W8, rotY //; Not mirror mode

FNEG S0, S0 

rotY:
LDR S2, rotYsensivity
FMUL S1, S1, S2

LDR X8, [X20, #0x118]
LDR S3, [X8,#0x130]
LDR S4, [X8, #0x13C]
FADD S3, S3, S1
FADD S4, S4, S0

LDR S2, minRotY
FCMP S3, S2
FCSEL S3, S2, S3, LE

LDR S2, maxRotY
FCMP S3, S2
FCSEL S3, S2, S3, GE

STR S3, [X8, #0x130]
STR S4, [X8, #0x13C]

LDR S0, [X20, #0x108]
LDR S1, diffForNoCul
FADD S1, S1, S12
FCMP S0, S1
BLE end

BL 0x7F41FC //; gear::FrameworkUtil::getCurrentGameScene(void)
LDR X0, [X0, #0x1B0]
LDR X0, [X0, #0x220]
LDR X0, [X0, #0x9B0]
BL 0x110CF8 //; object::FieldManualCulling::forceDontCull_(void) 

end:
LDP X29, X30, [SP], #0x10
LDP D9, D8, [SP, #0x60]
RET
minZoomSpeed: .float 3
maxZoomSpeed: .float 200
changeBy: .float 0.4

rotXsensivity: .float 0.04
rotYsensivity: .float 2

minRotY: .float -30
maxRotY: .float 90

mulLess: .float 0.015

diffForNoCul: .float 100


//; Clear Y button from kart acceleration inputs
//; gear::ControllerRace::init(void) + 0x4C
7D5434 -> BL 0xAAF844

.set BUTTON_Y, 0x10

STRB WZR, [X19, #0x39C]
LDR W8, [X19, #0x240]
BIC W8, W8, #BUTTON_Y
STR W8, [X19, #0x240]
RET 


//; MKTV replay stick only works if ZR is held
//; object::RecorderDirector::updatePlayRate_(void) + 0x80
0x3A8C84 -> BL 0xAAF7E0

STP X29, X30, [SP, #-0x10]!

MOV W0, WZR
BL 0x8B94A4 //; gear::GetControllerRace(int)
LDR X0, [X0, #0x158]
LDR W8, [X0, #0x114]
TBNZ W8, #5, end //; ZR button not held

FMOV S0, #0.0
FMOV S8, #1.0

end:
LDP X29, X30, [SP], #0x10
LDRB W8, [X19, #0x300]
RET



//; MKTV fullscreen button only works if ZR is held
//; ui::Page_TheaterRace::onHandler_(gear::UIEvent const&) + 0x8C
549B04 -> BL 0xAAF81C

.set BUTTON_ZR, 0x20

STP X29, X30, [SP, #-0x10]!

MOV W0, WZR
BL 0x8B94A4 //; gear::GetControllerRace(int)
LDR X0, [X0, #0x158]
LDR W9, [X0, #0x114]
TST W9, #BUTTON_ZR

LDRB W8, [X19, #0x31] //; Original instruction
CSEL W8, WZR, W8, EQ

LDP X29, X30, [SP], #0x10
RET
