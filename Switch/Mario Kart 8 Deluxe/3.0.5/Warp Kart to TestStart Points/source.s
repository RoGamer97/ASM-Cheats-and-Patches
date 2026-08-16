//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: Warp Kart to TestStart Points

//; You can find some documented headers here to learn more about the game
//; and know some offsets: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are written over unused functions (never executed).
//; There is a bit of free space in .text, but for some reason the emulator
//; crashes when executing code in that space. Writing over unused functions
//; doesn't cause a crash.


//; object::KartUnit::calcMove(float) + 0x18
//; 0x16B7B0 -> BL 0x7A2820

//; Skip the code if not local player or net send kart

//; Count the number of TestStart objects in the course,
//; skip the code if zero are present

//; Subtract the count by 1 and store it to stack.
//; It will be used for wrapping the current point

//; Hold Minus and push Right Stick Left/Right to warp to
//; the previous/next point. Store a bool to KartVehicle* +
//; 0x349, which is a padding byte, to tell the button and stick
//; is held down. 

//; On first frame of held, it will run the warp code:
//; Decrement/Increment the point ID based on the stick direction.
//; Wrap the poit ID between 0 and the count - 1 from stack.
//; The point ID will be stored to KartVehicle* + 0x34A, which is
//; a padding byte.

//; Search that TestStart object by point ID, it'll
//; return the pointer. Increment the pointer by +0x10 to point 
//; to its gear::MtxT* and store it to stack.

//; Finish Lakitu respawn if it's happening, reset the kart,
//; reset the kart's matrix to the TestStart gear::MtxT stored in stack,
//; to warp there, passing 5.0 as the Y height to be added, reset the AI
//; to correct CPU routes if a CPU, reset character and adapt the current
//; section to correct checkpoints.

//; If Minus and Right Stick Left/Right is still held down next frame,
//; avoid warping because KartVehicle* + 0x349 is still true and
//; will branch to avoidCalc to avoid calculating some kart physics,
//; preventing the kart from falling if it's in air until Minus or
//; the Right Stick is released


.set OBJECT_TESTSTART, 0x1772

.set BUTTONBIT_MINUS, 12

LDR W8, [X8, #8]
STP X29, X30, [SP, #-0x30]!
STR W8, [SP, #0x10]
STR X20, [SP, #0x20]

LDR X20, [X19, #8]

LDRB W10, [X20, #0xD0]
CBZ W10, end //; Not local player kart

LDRB W10, [X20, #0xE6]
CBNZ W10, end //; Net send kart

BL 0x80C804 //; gear::GetMapObjAccessor(void)
MOV W1, #OBJECT_TESTSTART
BL 0x810B08 //; gear::MapUnitMapObjAccessor::countAll(ushort)
CBZ W0, end //; No TestStart present

SUB W0, W0, #1
STR W0, [SP, #0x14]

LDR W0, [X19, #0x40]
BL 0x8B9544 //; gear::GetControllerIndexFromKartIndex(int)
CMP W0, #-1
BEQ end

BL 0x8B94F4 //; gear::GetControllerRaceNonConst(int)
LDR X0, [X0, #0x158]

LDR W9, [X0, #0x114]
TBZ W9, #BUTTONBIT_MINUS, clearFlag //; Not held

LDR S0, [X0, #0x128]

LDR S1, stickMin

MOV W10, #1

FCMP S0, S1
BGE isFlagSet

MOV W10, #-1

FNEG S1, S1
FCMP S0, S1
BGT clearFlag

isFlagSet:
LDRB W9, [X20, #0x349]
CBNZ W9, avoidCalc //; Already set, skip warp

MOV W9, #1
STRB W9, [X20, #0x349]

LDR W11, [SP, #0x14]
LDRB W8, [X20, #0x34A]
ADD W8, W8, W10
CMP W8, #0
CSEL W8, W11, W8, LT
CMP W8, W11
CSEL W8, WZR, W8, GT
STRB W8, [X20, #0x34A]

BL 0x80C804 //; gear::GetMapObjAccessor(void)
MOV W1, #OBJECT_TESTSTART
LDRB W2, [X20, #0x34A]
BL 0x810A24 //; gear::MapUnitMapObjAccessor::search(ushort,ushort)
ADD X0, X0, #0x10
STR X0, [SP, #0x18]

LDR W9, [X20, #0x1CC]
TBZ W9, #22, reset //; Not in Lakitu recover

LDR X0, [X20, #0x90]
LDR X1, [SP, #0x18]
BL 0x144534 //; object::KartJugemRecover::finishRecover(gear::MtxT const&)

reset:
MOV X0, X20
MOV W1, #1
BL 0x171004 //; object::KartVehicle::reset(bool)

MOV X0, X19
LDR X1, [SP, #0x18]
FMOV S0, #5.0
BL 0x16C2F8 //; object::KartUnit::resetMatrix(gear::MtxT const&,float)

LDR X8, [X19, #8]
LDRB W8, [X8, #0xD2]
CBZ W8, resetWarpPre //; Not a CPU

BL 0x7F41FC //; gear::FrameworkUtil::getCurrentGameScene(void)
LDR X8, [X0, #0x1B0]
LDR X8, [X8,#0x238]
LDR X0, [X8, #0xB0]
LDR W1, [X19, #0x40]
LDR X2, [SP, #0x18]
BL 0x59D50 //; object::AIDirector::reset(int,gear::MtxT const&)

resetWarpPre:
LDR X0, [X19, #0x10]
BL 0xE1368 //; object::DriverKart::resetWarpPre(void)

LDR X0, [X19, #0x10]
BL 0xE1378 //; object::DriverKart::resetWarpPost(void)

BL 0x7F41FC //; gear::FrameworkUtil::getCurrentGameScene(void)
LDR X8, [X0, #0x1B0]
LDR X8, [X8,#0x218]
LDR X0, [X8,#0x58]
LDR W1, [X19, #0x40]
MOV W2, #1
BL 0x8802B8 //; gear::LapRankChecker::adaptCurrentSector(int,bool)

avoidCalc:
MOV W8, #2
STR W8, [SP, #0x10]
B end

clearFlag:
STRB WZR, [X20, #0x349]

end:
LDR W8, [SP, #0x10]
LDR X20, [SP, #0x20]
LDP X29, X30, [SP], #0x30
RET
stickMin: .float 0.8


//; Disable game pausing with Minus button
//; 0x5319E0 -> AND W8, W8, #8
//; Removes the Minus button UI bit from pause button check