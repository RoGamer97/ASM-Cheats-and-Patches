

# NTSC-U 807ED9FC
# PAL 807F84FC
# NTSC-J 807F7B68
# NTSC-K 807E68BC

.set region, 'e'
.if (region == 'E' || region == 'e') # RMCE
    .set ptr_menuPageOrSomething, 0x809BDC10
    .set ptr_inputBase, 0x809B8F4C
	.set OutputSoundToWiimote, 0x8070C1DC
	.set playSound, 0x80701934
.elseif (region == 'P' || region == 'p') # RMCP
    .set ptr_menuPageOrSomething, 0x809C2850
    .set ptr_inputBase , 0x809BD70C
	.set OutputSoundToWiimote, 0x80713C80
.elseif (region == 'J' || region == 'j') # RMCJ
    .set ptr_inputBase , 0x809BC76C
    .set ptr_menuPageOrSomething, 0x809C18B0
	.set OutputSoundToWiimote, 0x807132EC
.elseif (region == 'K' || region == 'k') # RMCK
    .set ptr_inputBase , 0x809ABD4C
    .set ptr_menuPageOrSomething, 0x809B0E90
	.set OutputSoundToWiimote, 0x80702028
.else
.err
.endif

.set BUTTON_DPAD_LEFT, 0x20
.set BUTTON_DPAD_RIGHT, 0x40

stwu sp, -0x80 (sp)
stmw r3, 8 (sp)

lis r12, 0x8000
li r28, 0

lis r11, ptr_inputBase@ha
lwz r11, ptr_inputBase@l (r11)
lwz r10, 0x60 (r11)
andis. r11, r10, BUTTON_DPAD_LEFT | BUTTON_DPAD_RIGHT
beq storeHeldTimer

incrementHeldTimer:
lbz r28, 0x1882 (r12)
addi r28, r28, 1

cmpwi r28, 1
beq sound

# If timer is less than 0x12, jump to store VR/BR change button hold timer (Reset to zero), skipping code. If greater or equal, change VR/BR (Increase/decrease every frame)
cmpwi r28, 0x12
blt storeHeldTimer

sound:
lhz r4, 0x1880 (r12)

andis. r10, r10, BUTTON_DPAD_LEFT
bne decr

addi r4, r4, 1
b store

decr:
subi r4, r4, 1

store:
sth r4, 0x1880 (r12)

lis r3, ptr_menuPageOrSomething@ha
lwz r3, ptr_menuPageOrSomething@l (r3)
lwz r3, 0x44 (r3)
lis r12, playSound@h
ori r12, r12, playSound@l
mtctr r12
bctrl
cmpwi r3, 0
beq end

li r4, 3

lis r12, OutputSoundToWiimote@h
ori r12, r12, OutputSoundToWiimote@l
mtctr r12
bctrl

storeHeldTimer:
lis r12, 0x8000
stb r28, 0x1882 (r12)

end:
lmw r3, 8 (sp)
addi sp, sp, 0x80

lis r12, 0x8000
lhz r28, 0x1880 (r12)

lhz r0, 4 (r4)
cmplwi r0, 0x63