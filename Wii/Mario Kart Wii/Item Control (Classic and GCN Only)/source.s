# Game: Mario Kart Wii
# Code: Item Control (Classic and GCN Only)
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names


# Main code - Freeze and control items
# NTSC-U 80795FE0
# PAL 8079EFEC
# NTSC-J 8079E658
# NTSC-K 8078D3AC

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'E' || region == 'e')
    .set ptr_raceData, 0x809B8F68
    .set ptr_inputBase, 0x809B8F4C
	.set ItemObj__setTeamLight, 0x80795380
	.set addr_itemStateMove, 0x8079A8F0
.elseif (region == 'P' || region == 'p')
    .set ptr_raceData, 0x809BD728
    .set ptr_inputBase , 0x809BD70C
	.set ItemObj__setTeamLight, 0x8079E38C
	.set addr_itemStateMove, 0x807A38FC
.elseif (region == 'J' || region == 'j')
    .set ptr_raceData, 0x809BC788
    .set ptr_inputBase , 0x809BC76C
	.set ItemObj__setTeamLight, 0x8079D9F8
	.set addr_itemStateMove, 0x807A2F68
.elseif (region == 'K' || region == 'k')
    .set ptr_raceData, 0x809ABD68
    .set ptr_inputBase , 0x809ABD4C
	.set ItemObj__setTeamLight, 0x8078C74C
	.set addr_itemStateMove, 0x80791CBC
.else
    .err
.endif

.set ITEMTYPE_RED_SHELL, 1
.set ITEMTYPE_BLUE_SHELL, 5
.set ITEMTYPE_BOBOMB, 9
.set ITEMTYPE_THUNDER_CLOUD, 0xE
.set ITEMTYPE_BULLET_BILL, 0xD

.set BUTTON_DPAD_LEFT, 1
.set BUTTON_DPAD_RIGHT, 2
.set BUTTON_DPAD_UP, 8
.set BUTTON_DPAD_DOWN, 4 
.set BUTTON_Y_GCN, 0x800
.set BUTTON_Y_CLASSIC, 0x20

.set CONTROLLER_CLASSIC, 2


lis r10, ptr_raceData@ha
lwz r12, ptr_raceData@l (r10)
lbz r6, 0xB84 (r12)
lbz r12, 0x6C (r3)
cmpw r6, r12
bne normalBehavior # Item not thrown by you

cmpwi r29, ITEMTYPE_THUNDER_CLOUD
beq normalBehavior

lwz r12, ptr_inputBase@l (r10)
lwz r6, 0xCC (r12)
cmpwi cr1, r6, CONTROLLER_CLASSIC
blt cr1, normalBehavior

lwz r6, 0x60 (r12)
lbz r8, 0x1B (r30)
lbz r9, 0x19 (r30)

li r10, BUTTON_Y_GCN | BUTTON_DPAD_LEFT | BUTTON_DPAD_RIGHT | BUTTON_DPAD_UP | BUTTON_DPAD_DOWN
bne cr1, isToggleOrChangesPressed

li r10, BUTTON_Y_CLASSIC | BUTTON_DPAD_LEFT | BUTTON_DPAD_RIGHT | BUTTON_DPAD_UP | BUTTON_DPAD_DOWN

isToggleOrChangesPressed:
and. r7, r6, r10
beq setNotPressed

lbz r7, 0x18 (r30)
cmpwi r7, 0
bne setTeamLight

li r10, BUTTON_Y_GCN
bne cr1, isToggleStateButton

li r10, BUTTON_Y_CLASSIC

isToggleStateButton:
and. r7, r6, r10
beq isChangeType

xori r8, r8, 1
stb r8, 0x1B (r30)

isChangeType:
andi. r7, r6, BUTTON_DPAD_UP | BUTTON_DPAD_DOWN
beq isSerialChange

changeType:
andi. r7, r6, BUTTON_DPAD_DOWN
bne decrementType

addi r9, r9, 1
cmpwi r9, ITEMTYPE_THUNDER_CLOUD
blt storeItemType
li r9, 0
b storeItemType

decrementType:
subi r9, r9, 1
cmpwi r9, 0
bge storeItemType

li r9, ITEMTYPE_BULLET_BILL

storeItemType:
stb r9, 0x19 (r30)
li r5, 0
stb r5, 0x1A (r30)
b setPressed

isSerialChange:
andi. r7, r6, (BUTTON_DPAD_LEFT | BUTTON_DPAD_RIGHT)
beq setPressed

cmpw r29, r9
bne setTeamLight

lbz r5, 0x1A (r30)
andi. r7, r6, BUTTON_DPAD_LEFT
bne decrementSerial

addi r5, r5, 1
cmpw r5, r22
blt storeSerial
li r5, 0
b storeSerial

decrementSerial:
subi r5, r5, 1
cmpwi r5, 0
bge storeSerial

subi r5, r22, 1

storeSerial:
stb r5, 0x1A (r30)

setPressed:
li r7, 1
b storePress

setNotPressed:
li r7, 0

storePress:
stb r7, 0x18 (r30)

setTeamLight:
mflr r11
stwu sp, -0x80 (sp)
stmw r3, 8 (sp)
lis r12, ItemObj__setTeamLight@h
ori r12, r12, ItemObj__setTeamLight@l
mtctr r12
bctrl
lmw r3, 8 (sp)
addi sp, sp, 0x80
mtlr r11

andi. r8, r8, 1
beq normalBehavior

mulli r5, r9, 0x24
addi r5, r5, 0x5C
lwzx r5, r30, r5
cmpwi r5, 0
beq changeType

li r7, 0
cmpw r29, r9
bne storeBeingControlled

checkItemSerial:
lbz r5, 0x1A (r30)
cmpw r17, r5
bne storeBeingControlled

bl moveSpeed

.float 40

moveSpeed:
mflr r6
lfs f4, 0 (r6)

lwz r6, 0xC (r12)
lfs f5, 0x68 (r6)
fmuls f5, f5, f4

lfs f1, 0x48 (r3)
fadds f1, f1, f5
stfs f1, 0x48 (r3)
lfs f1, 0x90 (r3)
fadds f1, f1, f5
stfs f1, 0x90 (r3)

lwz r12, 0xCC (r12)
cmpwi r12, 3
beq loadMultiplyRightStickXY

addi r6, r6, 0x64

loadMultiplyRightStickXY:
lfs f0, 0xA0 (r6)
lfs f1, 0xA4 (r6)
fmuls f0, f0, f4
fmuls f1, f1, f4

lfs f2, 0x44 (r3)
lfs f3, 0x4C (r3)
fadds f2, f2, f0
fadds f3, f3, f1
stfs f2, 0x44 (r3)
stfs f3, 0x4C (r3)

lfs f2, 0x8C (r3)
lfs f3, 0x94 (r3)
fadds f2, f2, f0
fadds f3, f3, f1
stfs f2, 0x8C (r3)
stfs f3, 0x94 (r3)

lwz r7, 0x78 (r3)
andi. r6, r7, 0x8000 # Dropped flag
bne isBehaviorNull

cmpwi r29, ITEMTYPE_RED_SHELL
ble setBeingControlled

cmpwi r29, ITEMTYPE_BLUE_SHELL
beq setBeingControlled

isBehaviorNull:
lwz r6, 0x170 (r3)
cmpwi r6, 0
beq setBeingControlled

andi. r6, r7, 8 # Landed flag
beq setBeingControlled

rlwinm r7, r7, 0, 29, 27
stw r7, 0x78 (r3)
lis r6, addr_itemStateMove@h
ori r6, r6, addr_itemStateMove@l

cmpwi r29, ITEMTYPE_BOBOMB
bne storeBehavior

li r7, 0
sth r7, 0x1A8 (r3)
addi r6, r6, 4

storeBehavior:
stw r6, 0x170 (r3)

setBeingControlled:
li r7, 1

storeBeingControlled:
stb r7, 0xF (r3)

lwz r7, 0x160 (r3)
cmpwi r7, 3
bge return

li r7, 3

storeTimer:
stw r7, 0x160 (r3)

return:
li r3, 0
mtlr r11
blr

normalBehavior:
li r7, 0
stb r7, 0xF (r3)
stwu sp, -0x30 (sp)



# Force item team light in all modes
# NTSC-U 807AE860
# PAL 807BD2C0
# NTSC-J 807BC92C
# NTSC-K 807AB680
# Replace 'extrwi r0, r0, 1,30' with 'li r0, 1' to force result of to be true and enable item team light anywhere



# Display item team light on item being controlled and disable item light for items that aren't being controlled
# NTSC-U 807953A4
# PAL 8079E3B0
# NTSC-J 8079DA1C
# NTSC-K 8078C770

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling! Lowercase letters can also be used.

.if (region == 'E' || region == 'e')
    .set ptr_raceData, 0x809B8F68
.elseif (region == 'P' || region == 'p')
    .set ptr_raceData, 0x809BD728
.elseif (region == 'J' || region == 'j')
    .set ptr_raceData, 0x809BC788
.elseif (region == 'K' || region == 'k')
    .set ptr_raceData, 0x809ABD68
.else 
    .err
.endif

.set ITEMTYPE_BLUE_SHELL, 5
.set ITEMTYPE_BOBOMB, 9


li r0, 0

lbz r12, 0xF (r3)
cmpwi r12, 0
bne end

lis r12, ptr_raceData@ha
lwz r12, ptr_raceData@l (r12)
lwz r25, 0xB90 (r12)
andi. r25, r25, 2 # Team mode flag
beq removeTeamLight

lwz r25, 4 (r3)
cmpwi r25, ITEMTYPE_BLUE_SHELL
beq removeTeamLight

cmpwi r25, ITEMTYPE_BOBOMB
bne end

removeTeamLight:
lis r0, 1

# The end
end:


# Create item team light for Blue Shell
# NTSC-U 807A139C
# PAL 807AC044
# NTSC-J 807AB6B0
# NTSC-K 8079A404

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling! Lowercase letters can also be used.

.if (region == 'E' || region == 'e') # RMCE
    .set ItemObj__createTeamLight, 0x80797374
.elseif (region == 'P' || region == 'p') # RMCP
    .set ItemObj__createTeamLight, 0x807A0380
.elseif (region == 'J' || region == 'j') # RMCJ
    .set ItemObj__createTeamLight, 0x8079F9EC
.elseif (region == 'K' || region == 'k') # RMCK
    .set ItemObj__createTeamLight, 0x8078E740
.else
    .err
.endif

mr r3, r29
lis r12, ItemObj__createTeamLight@h
ori r12, r12, ItemObj__createTeamLight@l
mtctr r12
bctrl

li r3, 0x4C # Original instruction



# Create item team light for Bob-omb
# NTSC-U 8079C174
# PAL 807A5180
# NTSC-J 807A47EC
# NTSC-K 80793540

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling! Lowercase letters can also be used.

.if (region == 'E' || region == 'e') # RMCE
    .set ItemObj__createTeamLight, 0x80797374
.elseif (region == 'P' || region == 'p') # RMCP
    .set ItemObj__createTeamLight, 0x807A0380
.elseif (region == 'J' || region == 'j') # RMCJ
    .set ItemObj__createTeamLight, 0x8079F9EC
.elseif (region == 'K' || region == 'k') # RMCK
    .set ItemObj__createTeamLight, 0x8078E740
.else
    .err
.endif

mr r3, r29
lis r12, ItemObj__createTeamLight@h
ori r12, r12, ItemObj__createTeamLight@l
mtctr r12
bctrl

lwz r5, 0x9C (r29) # Original instruction



# Change millisecond to selected item type obj ID when code is enabled
# NTSC-U 807ED9F8
# PAL 807F84F8
# NTSC-J 807F7B64
# NTSC-K 807E68B8

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling! Lowercase letters can also be used.

.if (region == 'E' || region == 'e') # RMCE
    .set ptr_itemDirector, 0x809BEE20
.elseif (region == 'P' || region == 'p') # RMCP
    .set ptr_itemDirector, 0x809C3618
.elseif (region == 'J' || region == 'j') # RMCJ
    .set ptr_itemDirector, 0x809C2678
.elseif (region == 'K' || region == 'k') # RMCK
    .set ptr_itemDirector, 0x809B1C58
.else
    .err
.endif

lhz r28, 8(r4) # Original instruction

lis r12, ptr_itemDirector@ha
lwz r12, ptr_itemDirector@l (r12)
lbz r11, 0x1B (r12)
cmpwi r11, 0
beq end

lbz r28, 0x19 (r12)

end:
