# Game: Mario Kart Wii
# Code: Future Fly
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 805AA6FC
# PAL 805B5624
# NTSC-J 805B4FA4
# NTSC-K 805A367C

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'e' || region == 'E')
        .set getPlayerController, 0x80589BD0
        .set mirrorFloat, 0x808B053C
.elseif (region == 'p' || region == 'P')
        .set getPlayerController, 0x805903F4
        .set mirrorFloat, 0x808B4BEC
.elseif (region == 'j' || region == 'J' )
        .set getPlayerController, 0x8058FD74
        .set mirrorFloat, 0x808B3D4C
.elseif (region == 'k' || region == 'K' )
        .set getPlayerController, 0x8057E44C
        .set mirrorFloat, 0x808A3064
.else
    .err
.endif

.set BUTTONBIT_A, 1 << 0 		  # 1
.set BUTTONBIT_B, 1 << 1          # 2
.set BUTTONBIT_DPAD_UP, 1 << 3    # 8
.set BUTTONBIT_DPAD_DOWN, 1 << 4  # 0x10
.set BUTTONBIT_DPAD_LEFT, 1 << 5  # 0x20
.set BUTTONBIT_DPAD_RIGHT, 1 << 6 # 0x40
.set BUTTONBIT_MINUS, 1 << 12     # 0x1000
.set BUTTONBIT_Y_GCN, 1 << 11     # 0x800

.set CONTROLLER_NUNCHUK, 2


fmuls f3, f26, f7 # Original instruction

lwz r12, 0xEC (r3)
lwz r12, 0xC (r12)
lwz r3, 0x10 (r12)
lwz r10, 4 (r3)

lwz r11, 0x14 (r10)
andi. r12, r11, 2
beq end # Not local player kart

bl FlightValues

.float 240 # Forward and left/right strafe speed
.float -120 # Backward speed
.float 192 # Strafe Up/Down speed
.float -0.05078125  # Left/Right turn strength
.float 0.0625 # Up/Down tilt strength
.long 0x800040 # Flags to be cleared (Trick and mushroom pad)

FlightValues:
mflr r5

lwz r8, 0x28 (r3)

addi r3, r3, 0x124
lis r12, getPlayerController@h
ori r12, r12, getPlayerController@l
mtctr r12
bctrl

loadControllerPointer:
lwz r4, 0xC (r3)

mr r6, r4
mr r9, r3

lwz r3, 0xC8 (r9)
li r9, BUTTONBIT_MINUS

cmpwi cr1, r3, CONTROLLER_NUNCHUK
ble cr1, checkKeyInput

li r9, BUTTONBIT_Y_GCN

checkKeyInput:
lwz r0, 0x20 (r4)
lwz r6, 0x60 (r4)
andc r6, r0, r6
and. r6, r6, r9
cmpw r6, r9
bne isEnabled

xoris r11, r11, 0x8000
stw r11, 0x14 (r10)

isEnabled:
andis. r11, r11, 0x8000
beq end

fsubs f15, f15, f15
fmr f16, f15
stfs f16, 0x74 (r30)
stfs f16, 0x78 (r30)
stfs f16, 0x7C (r30)
stfs f16, 0x20 (r8)
stfs f16, 0x1B0 (r8)

lwz r12, 8 (r10)
lwz r11, 0x14 (r5)
andc r12, r12, r11
stw r12, 8 (r10)

lhz r12, 4(r10)
andi. r12, r12, 0xFFF7
sth r12, 4 (r10)

mr r6, r4

bgt cr1, loadRightStick
beq cr1, getClassicRightStick

andis. r12, r0, BUTTONBIT_DPAD_LEFT | BUTTONBIT_DPAD_RIGHT
beq isUpDown

lfs f15, 0 (r5)

andis. r12, r0, BUTTONBIT_DPAD_LEFT # Left
beq isUpDown

fneg f15, f15

isUpDown:
andis. r12, r0, BUTTONBIT_DPAD_UP | BUTTONBIT_DPAD_DOWN
beq loadCoords

lfs f16, 8 (r5)

andis. r12, r0, BUTTONBIT_DPAD_DOWN # Down
beq loadCoords

fneg f16, f16

b loadCoords

getClassicRightStick:
addi r6, r4, 0x64

loadRightStick:
lfs f20, 0xA0 (r6)
lfs f16, 0xA4 (r6)

lfs f15, 0 (r5)
lfs f17, 8 (r5)

fmuls f15, f20, f15
fmuls f16, f16, f17

loadCoords:
lfs f1, 0x0068 (r30)
lfs f25, 0x006C (r30)
lfs f23, 0x0070 (r30)

lis r12, mirrorFloat@h
lfs f19, mirrorFloat@l (r12)

fmuls f15, f15, f19

lfs f19, -0x74 (r30)
fnmsubs f1, f19, f15, f1
lfs f19, -0x54 (r30)
fnmsubs f23, f19, f15, f23
fadds f25, f25, f16

lfs f18, 0xC (r5)
lfs f17, 0 (r5)

andis. r12, r0, (BUTTONBIT_A | BUTTONBIT_B)
beq loadLeftStick

andis. r12, r0, 2
beq moveCalc

lfs f17, 4 (r5)
fneg f18, f18

moveCalc:
lfs f19, -0x6C (r30)
fmadds f1, f19, f17, f1
lfs f19, -0x5C (r30)
fmadds f25, f19, f17, f25
lfs f19, -0x4C (r30)
fmadds f23, f19, f17, f23

loadLeftStick:
lfs f19, 0xC (r4)
lfs f15, 0x10 (r4)

fmuls f18, f19, f18
stfs f18, 0x00E8 (r30)

lfs f17, 0x10 (r5)
fmuls f17, f17, f15
stfs f17, 0x00E4 (r30)

end:



# Disable Boundaries When Flying
# NTSC-U 8056ECB0
# PAL 80573B00
# NTSC-J 80573480
# NTSC-K 80561B58

lwz r11, 4 (r3)
lwz r12, 4 (r11)

lwz r12, 0x14 (r12)
andis. r12, 12, 0x8000
beq end

lwz r11, 0x24 (r11)
lhz r12, 0x334 (r11)
andi. r12, r12, 0xFFE7
sth r12, 0x334 (r11)
blr

end:
stwu sp, -0x20 (sp) # Original instruction