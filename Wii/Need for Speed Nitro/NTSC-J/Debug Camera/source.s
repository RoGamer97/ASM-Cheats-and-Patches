# Game: Need for Speed Nitro (Wii)
# Code: Debug Camera


# CameraAI::Director::SelectAction + 0x410
# 800653E0

# Sets Turbo and Super Turbo mode bools based on C and Z button hold

# Changes camera action to CDActionDebug when Minus is pressed to enable Debug Camera

# Based on Wiimote connected to port 2 (Because Debug Camera is controlled by controller on 2nd port)

# Game handles camera control and camera mode change


.set CameraAI__SetAction, 0x80065C30

.set addr_Wiimote2ButtonHold, 0x806F3D82
.set addr_Wiimote2ButtonTrig, 0x806F3D86
.set addr_CDActionDebug_string, 0x80557838

<<<<<<< HEAD:Wii/Need for Speed Nitro/NTSC-J/Debug Camera/source.s
.set BUTTONBIT_MINUS, 12
.set BUTTONBIT_Z_NUNCHUK, 13
.set BUTTONBIT_C_NUNCHUK, 14

.set BUTTON_MINUS, (1 << BUTTONBIT_MINUS)
.set BUTTON_Z_NUNCHUK, (1 << BUTTONBIT_Z_NUNCHUK)
.set BUTTON_C_NUNCHUK, (1 << BUTTONBIT_C_NUNCHUK)
=======
.set BUTTON_MINUS, 0x1000
.set BUTTON_Z_NUNCHUK, 0x2000
.set BUTTON_C_NUNCHUK, 0x4000
>>>>>>> ba5ad483375f4e5cc4ea3a7d358921b18d444f5a:Wii/Need for Speed Nitro (NTSC-J)/Debug Cameras/source.s

li r3, 0
li r4, 0

lis r12, addr_Wiimote2ButtonHold@h
lhz r11, addr_Wiimote2ButtonHold@l (r12)
andi. r0, r11, BUTTON_C_NUNCHUK | BUTTON_Z_NUNCHUK
beq storeTurbo

andi. r11, r11, BUTTON_Z_NUNCHUK
bne setSuperTurbo

li r3, 1
b storeTurbo

setSuperTurbo:
li r4, 1

storeTurbo:
stw r3, -0x39C0 (r13)
stw r4, -0x39BC (r13)

lhz r12, addr_Wiimote2ButtonTrig@l (r12)
andi. r12, r12, BUTTON_MINUS
beq end

li r3, 1
lis r4, addr_CDActionDebug_string@h
ori r4, r4, addr_CDActionDebug_string@l
lis r12, CameraAI__SetAction@h
ori r12, r12, CameraAI__SetAction@l
mtctr r12
bctrl

end:
lwz r4, 0x18 (r29) # Original instruction