//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: Trick Chaining (Mario Kart World)

//; You can find some documented headers here to learn more about the game
//; and know some offsets: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are written over unused functions (never executed).
//; There is a bit of free space in .text, but for some reason the emulator
//; crashes when executing code in that space. Writing over unused functions
//; doesn't cause a crash.


//; Trick chaining
//; object::KartVehicleDrift::calcJumpAction_(object::KartVehicleDrift::DriftInfo &, int, bool) + 0x90
//; 0x17C828 -> BL 0xAAFCC4

//; Skip the code if net send or receive kart

//; Allows tricking if:
//; * In trick timing for one second (Went off a trick collision and didn't land yet)
//; * Is/was in a trick and didn't land yet (With trick delay of 18 frames)
//; * In a glider/cannon (But only if not in trick animation)

//; Call object::KartVehicleMove::isJumpActionTiming(void) to know if in trick timing,
//; return value will be used later

//; If in glider or cannon, allow tricking but only if not in a trick animation

//; For normal tricks, allow tricking for one second if in trick timing, otherwise
//; trick is only allowed if trick animation timer is > 18
//; (Can only trick each 18 frames)

//; Override W9 and W21 with zero to allow trick (They're checked after the hook
//; returns, if it's true, trick isn't allowed)
//; But after overriding W9, ORR it with W22 (Trick button not pressed bool) to avoid 
//; automatically tricking


//; Register reference:
//; X8 = object::KartVehicle* (Input)
//; W9 = Force trick bool (Input and output)
//; W21 = In trick animation bool (Input and output)
//; W22 = Trick button not triggered bool (Input)
//; X19 = object::KartVehicleDrift*


.set TRICK_TIMING_WINDOW, 60
.set TRICK_CHAIN_DELAY, 18

.set KARTSTATUSBIT_WING, 4
.set KARTSTATUSBIT_DURINGJUMPACTION, 18

STP X29, X30, [SP, #-0x20]!

LDRH W10, [X8, #0xE6]
CBNZ W10, end //; Net send or receive kart

STR W9, [SP, #0x10]

LDR X0, [X8, #0x28]
BL 0x1858C4 //; object::KartVehicleMove::isJumpActionTiming(void)

LDR X8, [X19, #8]

LDR W9, [SP, #0x10]

LDR W10, [X8, #0x1CC]
TBZ W10, #KARTSTATUSBIT_WING, calcNormalTrick

TBNZ W10, #KARTSTATUSBIT_DURINGJUMPACTION, end
B allowTrick

calcNormalTrick:
LDR X10, [X8, #0x28]
LDR W10, [X10, #0x26C]
CMP W10, #TRICK_TIMING_WINDOW
CSEL W11, WZR, W0, GT

LDR W10, [X8, #0x204]
CMP W10, #TRICK_CHAIN_DELAY
CSEL W11, W10, W11, GT
CBZ W11, end //; Can't trick

allowTrick:
MOV W9, WZR
MOV W21, WZR

end:
ORR W9, W22, W9 //; Original instruction
LDP X29, X30, [SP], #0x20
RET



//; Set glider trick types based on stick and fix trick direction
//; object::KartVehicleDrift::calcJumpAction_(object::KartVehicleDrift::DriftInfo &, int, bool) + 0xE4
//; 0x17C87C -> BL 0xAAFD28

//; Skip the code if net send or receive kart

//; Overrides the loaded trick type with roll or pitch trick type in glider based on stick and also loads the correct stick values for
//; the direction

//; Skip code if not in glider/cannon

//; Overrides the loaded trick stick direction (S0 and S1) with the real kart stick X and Y

//; Set pitch trick type if stick X is >= 0.3 or <= -0.3
//; Set roll trick type if stick Y is >= 0.3 or <= -0.3


//; Register reference:
//; W1 = Trick type (Input and output)
//; X8 = object::KartVehicle*
//; X19 = object::KartVehicleDrift*


.set TRICKTYPE_PITCH, 3
.set TRICKTYPE_ROLL, 4

.set KARTSTATUSBIT_WING, 4

LDR X8, [X19, #8]
LDRH W9, [X8, #0xE6]
CBNZ W9, end //; Net send or receive kart

LDR W9, [X8, #0x1CC]
TBZ W9, #KARTSTATUSBIT_WING, end

LDR S0, [X8, #0x17C]
LDR S1, [X8, #0x180]
LDR S2, stick
FNEG S3, S2

FCMP S0, S2
BGE pitchJA

FCMP S0, S3
BGT checkY

pitchJA:
MOV W1, #TRICKTYPE_ROLL
B end

checkY:
FCMP S1, S2
BGE rollJA

FCMP S1, S3
BGT end

rollJA:
MOV W1, #TRICKTYPE_PITCH

end:
FNEG S0, S0 //; Original instruction
RET
stick: .float 0.3


//; Allow steering in air
//; object::KartVehicleMove::calcSteerVolForDrive_(float, float, bool) + 0xA0
//; 0x18B2BC -> BL 0xAAFD84

//; Skip the code if net send or receive kart

//; Allows steering in the air on the first 18 frames of the trick

//; ORRs the underwater "screw" flag to the loaded kart status flags,
//; after the hook, the game checks if either the moon gravity or underwater
//; screw flags are set and allows the kart to steer in air if so


//; Register reference:
//; X8 = object::KartVehicle*


.set TRICK_ALLOWED_STEER_FRAMES, 18

.set KARTSTATUSBIT_DURINGJUMPACTION, 18
.set KARTSTATUSBIT_SCREW, 7

.set KARTSTATUS_SCREW, (1 << KARTSTATUSBIT_SCREW)

MOV X9, X8
LDR W8, [X8, #0x1CC] //; Original instruction
TBZ W8, #KARTSTATUSBIT_DURINGJUMPACTION, end //; Not in trick animation

LDRH W8, [X9, #0xE6]
CBNZ W8, end //; Net send or receive kart

LDR W9, [X9, #0x204]
CMP W9, #TRICK_ALLOWED_STEER_FRAMES
BGT end

ORR W8, W8, #KARTSTATUS_SCREW

end:
RET
