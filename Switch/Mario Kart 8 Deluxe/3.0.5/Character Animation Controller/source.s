//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: Character Animation Controller


//; Hooks are written over unused functions (never executed).
//; There is a bit of free space in .text, but for some reason the emulator
//; crashes when executing code in that space. Writing over unused functions
//; doesn't cause a crash.

//; Character animation controller
//; object::DriverKart::calcSkeletalAnim_(void) + 0x1C
//; 0xDB1EC -> BL 0xAAF934

//; Toggles play repeat animation mode by holding Right Stick In and pressing Left Stick In
//; In that mode, holding Right Stick In and pushing Left Stick Left/Right cycles through animations
//; Also in that mode, pressing Right Stick In changes the mode to control animation mode

//; In control animation mode, holding Left Stick In and pushing it Left/Right moves through the
//; animation keyframes. Holding X and pressing D-Pad Left/Right cycles through facial animations.

//; object::DriverKart* + 0x336 and 0x337 are padding bytes.
//; Use them for the code:
//; 0x336 = Animation modes (0 for None, 1 for Play Repeat Anim and 2 for Control Anim)
//; 0x337 = Selected animation ID

//; W9 is checked, if it's < 1, it branches to the function end, skipping animation
//; calculation. Override it with 0 in Control Animation Mode to freeze character Animation


//; Register reference:
//; W9 = Some member variable that branches to function end if < 1 (Input and output)
//; X19 = object::DriverKart*


.set RACERULE_TITLERACE, 4

.set BUTTONBIT_X, 3
.set BUTTONBIT_RIGHT_STICK_IN, 6
.set BUTTONBIT_LEFT_STICK_IN, 7
.set BUTTONBIT_DPAD_LEFT, 18
.set BUTTONBIT_DPAD_RIGHT, 19
.set BUTTONBIT_LEFT_STICK_LEFT, 22
.set BUTTONBIT_LEFT_STICK_RIGHT, 23

.set BUTTON_LEFT_STICK_LEFT, (1 << BUTTONBIT_LEFT_STICK_LEFT)
.set BUTTON_LEFT_STICK_RIGHT, (1 << BUTTONBIT_LEFT_STICK_RIGHT)
.set BUTTON_DPAD_LEFT, (1 << BUTTONBIT_DPAD_LEFT)
.set BUTTON_DPAD_RIGHT, (1 << BUTTONBIT_DPAD_RIGHT)

.set ANIM_MAX, 7
.set FACE_ANIM_MAX, 6

.set MODE_PLAY_REPEAT_ANIM, 1
.set MODE_CONTROL_ANIM, 2

LDR W9, [X8, #0x58] //; Original instruction
STP X29, X30, [SP, #-0x20]!
STR W9, [SP, #0x10]

BL 0x87C244 //; gear::GetRaceInfo(void)
LDR W8, [X0, #8]
CMP W8, #RACERULE_TITLERACE
BGE end

LDR X8, [X19, #0x18]
LDR X9, [X8, #8]
LDRB W0, [X9, #0xD0]
CBZ W0, end //; Not local player kart

LDR W0, [X9, #0xA8]
BL 0x8B9544 //; gear::GetControllerIndexFromKartIndex(int)
BL 0x8B94F4 //; gear::GetControllerRaceNonConst(int)
LDR X0, [X0, #0x158]
LDR W8, [X0, #0x114]
LDR W9, [X0, #8]
TBZ W8, #BUTTONBIT_RIGHT_STICK_IN, isEnabled //; Not held

LDRB W8, [X19, #0x336]
CBZ W8, isLeftStickTrig

MOV W8, #(BUTTON_LEFT_STICK_LEFT | BUTTON_LEFT_STICK_RIGHT)
TST W9, W8
BNE changeAnim //; Not triggered

isLeftStickTrig:
TBZ W9, #BUTTONBIT_LEFT_STICK_IN, isEnabled //; Not triggered

LDRB W8, [X19, #0x336]
CMP W8, #0
CSET W8, EQ
STRB W8, [X19, #0x336]

isEnabled:
LDRB W8, [X19, #0x336]
CBZ W8, end

TBZ W9, #BUTTONBIT_RIGHT_STICK_IN, checkMode //; Not triggered

MOV W8, #MODE_CONTROL_ANIM
STRB W8, [X19, #0x336]

checkMode:
CMP W8, #MODE_PLAY_REPEAT_ANIM
BEQ animPlay

LDR W8, [X0, #0x114]
TBZ W8, #BUTTONBIT_LEFT_STICK_IN, changeFaceAnim //; Not held

//; Replicate the game's way of loading this
//; X20 + 0 is current anim keyframe and X20 + 8 is total anim keyframes
LDR X8, [X19, #0x38]
LDR W9, [X8, #0x38]
LDR X8, [X8, #0x40]
ADD X10, X8, #0x150
LDR X20, [X8, #0x20]
CMP W9, #2
CSEL X8, X10, X8, HI
LDR X20, [X8, #0x20]

LDR S0, [X0, #0x120]
LDR S1, [X20]
LDR S2, [X20, #8]
LDR S3, speed

FMUL S0, S0, S3

FMOV S3, #0.0

FADD S1, S1, S0
FCMP S1, #0.0
FCSEL S1, S3, S1, LT

FCMP S1, S2
FCSEL S1, S2, S1, GT

STR S1, [X20]

changeFaceAnim:
LDR W8, [X0, #0x114]
TBZ W8, #BUTTONBIT_X, freezeCalc //; Not held

MOV W8, #(BUTTON_DPAD_LEFT | BUTTON_DPAD_RIGHT)
LDR W9, [X0, #8]
TST W9, W8
BEQ freezeCalc //; Not triggered

TST W9, #BUTTON_DPAD_LEFT
MOV W9, #1
CNEG W9, W9, NE

MOV W10, #FACE_ANIM_MAX
LDR W1, [X19, #0x324]
ADD W1, W1, W9
CMP W1, #0
CSEL W1, W10, W1, LT
CMP W1, W10
CSEL W1, WZR, W1, GT

MOV X0, X19
MOV W2, #1
BL 0xE3C78 //; object::DriverKart::setFaceAnim_(int,bool)

freezeCalc:
STR WZR, [SP, #0x10]
B end

animPlay:
LDR W8, [X19, #0x1AC]
TBNZ W8, #31, startActionAnim //; Animation has ended/not playing
B end

changeAnim:
MOV W8, #MODE_PLAY_REPEAT_ANIM
STRB W8, [X19, #0x336]

MOV W10, #1
TST W9, #BUTTON_LEFT_STICK_LEFT
CNEG W10, W10, NE

MOV W9, #ANIM_MAX
LDRB W8, [X19, #0x337]
ADD W8, W8, W10
CMP W8, W9
CSEL W8, WZR, W8, GT
CMP W8, #0
CSEL W8, W9, W8, LT
STRB W8, [X19, #0x337]

startActionAnim:
MOV X0, X19
LDRB W1, [X19, #0x337]
BL 0xDFBA0 //; object::DriverKart::startActionAnim_(int)

end:
LDR W9, [SP, #0x10]
LDP X29, X30, [SP], #0x20
LDR X8, [X19, #0x38] //; X8 is lost, reload it
RET
speed: .float 0.5


//; Freeze bone motion in animation control mode
//; object::DriverKart::calcBoneMotion_(void) + 0x1C
//; 0xDED1C -> BL 0xAAFACC

//; Bone motion causes character head to move even
//; in animation control mode, so skip it entirely in
//; that mode

//; Skip by modifying hook's return address: LR + 0xB38 = 0xDF858
//; Returns to the function's end

//; Register reference:
//; X19 = object::DriverKart*


.set MODE_CONTROL_ANIM, 2

MOV X19, X0 //; Original instruction

LDRB W8, [X19, #0x336]
CMP W8, #MODE_CONTROL_ANIM
BNE end

ADD X30, X30, #0xB38

end:
RET