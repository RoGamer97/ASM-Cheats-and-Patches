# NTSC-U 807E4CAC
# PAL 807EEFBC
# NTSC-J 807EE628
# NTSC-K 807DD37C

.set region, ''

.if (region == 'e' || region == 'E')
		.set getPaneByName, 0x805D1C7C
		.set ptr_menuData, 0x809BD508
.elseif (region == 'p' || region == 'P')
		.set getPaneByName, 0x805E8368
		.set ptr_menuData, 0x809C1E38
.elseif (region == 'j' || region == 'J' )
		.set getPaneByName, 0x805E7C44
		.set ptr_menuData, 0x809C0E98
.elseif (region == 'k' || region == 'K' )
		.set getPaneByName, 0x805D6504
		.set ptr_menuData, 0x809B0478
.else
        .err
.endif

.set ITEMSLOT_GOLDEN_MUSHROOM, 0xA


stwu sp, -0x80 (sp)
stmw r3, 8 (sp)

lis r12, ptr_menuData@ha
lwz r12, ptr_menuData@l (r12)
lwz r12, 0 (r12)
lbz r12, 0x389 (r12)
cmpwi r12, 0
bne end

mr r31, r3

addi r3, r28, 0xA8
bl goldenWindowString

.string "golden_window"
.balign 4

goldenWindowString:
mflr r4

lis r12, getPaneByName@h
ori r12, r12, getPaneByName@l 
mtctr r12
bctrl
cmpwi r3, 0
beq end
	
mr r29, r3

bl hilightNextString

.string "hilight_next"
.balign 4

hilightNextString:
mflr r4

addi r3, r28, 0xA8
lis r12, getPaneByName@h
ori r12, r12, getPaneByName@l 
mtctr r12
bctrl

bl goldenWindowBarValues

.float 450 		# Default time bar scale (Normally the bar uses Golden item timer as scale, but timer is zero when golden hasn't been used yet, so set this as default)
.float -18.125 	# Initial height
.float -26.125 	# Final height
.float 1 		# Height move speed

goldenWindowBarValues:
mflr r11
lwz r28, 0xA0 (r28)

lwz r0, 0xD8 (r3)
stw r0, 0xD8 (r29)
stw r0, 0x2BC (r29)

lwz r0, 0xDC (r3)
stw r0, 0xDC (r29)
stw r0, 0x2C0 (r29)

lwz r0, 0xE0 (r3)
stw r0, 0xE0 (r29)
stw r0, 0x2C4 (r29)

lwz r0, 0xE4 (r3)
stw r0, 0xE4 (r29)
stw r0, 0x2C8 (r29)

li r0, 0

lwz r12, 0 (r31)
lwz r12, 4 (r12)
lwz r12, 0x14 (r12)
andi. r12, r12, 8
bne end

lfs f0, 0 (r11)
lfs f1, 4 (r11)

lwz r12, 0x8C (r31)
cmpwi r12, ITEMSLOT_GOLDEN_MUSHROOM
bne storeHeightAndTimer

lfs f2, 8 (r11)
lfs f1, 0x30 (r29)
fcmpo cr0, f1, f2
ble setDefaultBarTimer

lfs f2, 0xC (r11)
fsubs f1, f1, f2

setDefaultBarTimer:
lha r0, 0xAA (r31)
cmpwi r0, 0
beq setVisible

lfd f0, 0x118 (r30)
stfd f0, 0x7C (sp)
stw r0, 0x80 (sp)
lfd f2, 0x7C (sp)
fsub f0, f2, f0
frsp f0, f0

setVisible: 
li r0, 1

storeHeightAndTimer:
stfs f0, 0x230 (r29)
stfs f1, 0x30 (r29)

storeVisibility:
stb r0, 0xBB (r29)
  
end:
lmw r3, 8 (sp)
addi sp, sp, 0x80

lwz r0, 0x58 (r3)