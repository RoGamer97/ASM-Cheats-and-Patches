# Game: Mario Kart Wii
# Code: Infinite Shock/Crush Status Cycler
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 8058DF38
# PAL 8059475C
# NTSC-J 805940DC
# NTSC-K 805827B4

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'E' || region == 'e')
    .set getControllerHolder, 0x80589BD0
    .set KartScale__startThunder, 0x805AE530
    .set KartScale__startPress, 0x805AE5DC
.elseif (region == 'P' || region == 'p')
    .set getControllerHolder, 0x805903F4
    .set KartScale__startThunder, 0x8056AFB4
.set KartScale__startPress, 0x8056B060
.elseif (region == 'J' || region == 'j')
    .set getControllerHolder, 0x8058FD74
    .set KartScale__startThunder, 0x8056A934
.set KartScale__startPress, 0x8056A9E0
.elseif (region == 'K' || region == 'k')
    .set getControllerHolder, 0x8057E44C
    .set KartScale__startThunder, 0x8055900C
.set KartScale__startPress, 0x805590B8
.else
    .err
.endif

.set BUTTON_B_WIIMOTE, 0x400
.set BUTTON_ZL_CLASSIC, 0x80
.set BUTTON_Y_GCN, 0x800
.set BUTTON_R_GCN, 0x20
.set BUTTON_MINUS, 0x1000
.set KARTSTATUS_THUNDER, 0x80
.set KARTSTATUS_PRESS, 0x10000


mr r31, r3 # Original instruction

lwz r12, 0x14 (r3)
andi. r12, r12, 2
beq end # Not local player kart

mr r3, r29
lis r12, getControllerHolder@h
ori r12, r12, getControllerHolder@l
mtctr r12
bctrl

bl controllerButtons

.hword BUTTON_B_WIIMOTE | BUTTON_MINUS
.hword BUTTON_B_WIIMOTE | BUTTON_MINUS
.hword BUTTON_ZL_CLASSIC | BUTTON_MINUS
.hword BUTTON_Y_GCN | BUTTON_R_GCN

controllerButtons:
mflr r4

lwz r12, 0xC8 (r3)
mulli r12, r12, 2
lhzx r4, r4, r12

lwz r12, 0x2C (r3)
and r5, r12, r4
cmpw r4, r5
bne end

lwz r11, 0x44 (r3)
andc r5, r12, r11
and. r12, r4, r5
beq end

lwz r4, 0 (r29)
lwz r4, 0x28 (r4)

lbz r12, 0xBF (r31)
addi r12, r12, 1
cmpwi r12, 3
blt storeMode

li r12, 0

storeMode:
stb r12, 0xBF (r31)

li r0, 0
sth r0, 0x18C (r4)
sth r0, 0x192 (r4)

cmpwi r12, 0
beq end

bl offsetsBitsFuncs

.hword 0x018C
.hword 0x0192
.long KARTSTATUS_THUNDER
.long KARTSTATUS_PRESS
.long KartScale__startThunder
.long KartScale__startPress

offsetsBitsFuncs:
mflr r5

subi r12, r12, 1

mulli r6, r12, 2
lhax r6, r5, r6

mulli r12, r12, 4

li r0, 0x7FFF
sthx r0, r4, r6

addi r6, r5, 4
lwzx r6, r6, r12
lwz r0, 0xC (r31)
or r0, r0, r6
stw r0, 0xC (r31)

lwz r3, 0x260 (r4)
li r4, 0
addi r5, r5, 0xC
lwzx r12, r5, r12
mtctr r12
bctrl

end:
mr r3, r31