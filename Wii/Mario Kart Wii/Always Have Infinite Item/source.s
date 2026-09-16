# Game: Mario Kart Wii
# Code: Always Have Item
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# Local Player Only
# NTSC-U 8078E958
# PAL 80797964
# NTSC-J 80796FD0
# NTSC-K 80785D24

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'E' || region == 'e')
	.set ItemStock__setItem, 0x807ADEE0
	.set ItemSlot__clearSlot, 0x807ABB78
.elseif (region == 'P' || region == 'p')
	.set ItemStock__setItem, 0x807BC940
	.set ItemSlot__clearSlot, 0x807BA5D8
.elseif (region == 'J' || region == 'j')
	.set ItemStock__setItem, 0x807BBFAC
	.set ItemSlot__clearSlot, 0x807B9C44
.elseif (region == 'K' || region == 'k')
	.set ItemStock__setItem, 0x807AAD00
	.set ItemSlot__clearSlot, 0x807A8998
.else
    .err
.endif

.set ITEMSLOT_GREEN_SHELL, 0
.set ITEMSLOT_RED_SHELL, 1
.set ITEMSLOT_BANANA, 2
.set ITEMSLOT_FAKE_ITEM_BOX, 3
.set ITEMSLOT_MUSHROOM, 4
.set ITEMSLOT_TRIPLE_MUSHROOM, 5
.set ITEMSLOT_BOBOMB, 6
.set ITEMSLOT_BLUE_SHELL, 7
.set ITEMSLOT_LIGHTNING, 8
.set ITEMSLOT_STAR, 9
.set ITEMSLOT_GOLDEN_MUSHROOM, 0xA
.set ITEMSLOT_MEGA_MUSHROOM, 0xB
.set ITEMSLOT_BLOOPER, 0xC
.set ITEMSLOT_POW, 0xD
.set ITEMSLOT_THUNDER_CLOUD, 0xE
.set ITEMSLOT_BULLET_BILL, 0xF
.set ITEMSLOT_TRIPLE_GREEN_SHELL, 0x10
.set ITEMSLOT_TRIPLE_RED_SHELL, 0x11
.set ITEMSLOT_TRIPLE_BANANA, 0x12
.set ITEMSLOT_NONE, 0x14

.set ITEMSLOT_STATE_STOPPED, 0

.set DESIRED_ITEM, ITEMSLOT_STAR # Change to the item you want (Star as placeholder)

mr r28, r3

lwz r4, 0 (r29)
lwz r4, 4 (r4)
lwz r4, 0x14 (r4)
andi. r4, r4, 2
beq end # Not local player kart


lwz r3, 0x8C (r29)
cmpwi r3, ITEMSLOT_NONE
bne end

lwz r3, 0x58 (r29)
cmpwi r3, ITEMSLOT_STATE_STOPPED
beq setItem

addi r3, r29, 0x54
lis r12, ItemSlot__clearSlot@h
ori r12, r12, ItemSlot__clearSlot@l
mtctr r12
bctrl

setItem:
addi r3, r29, 0x88
li r4, DESIRED_ITEM
li r5, 0
lis r12, ItemStock__setItem@h
ori r12, r12, ItemStock__setItem@l
mtctr r12
bctrl

end:
lhz r5, 0x2C (r28) # Original instruction



# Everyone
# NTSC-U 8078E958
# PAL 80797964
# NTSC-J 80796FD0
# NTSC-K 80785D24

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'E' || region == 'e')
	.set ItemStock__setItem, 0x807ADEE0
	.set ItemSlot__clearSlot, 0x807ABB78
.elseif (region == 'P' || region == 'p')
	.set ItemStock__setItem, 0x807BC940
	.set ItemSlot__clearSlot, 0x807BA5D8
.elseif (region == 'J' || region == 'j')
	.set ItemStock__setItem, 0x807BBFAC
	.set ItemSlot__clearSlot, 0x807B9C44
.elseif (region == 'K' || region == 'k')
	.set ItemStock__setItem, 0x807AAD00
	.set ItemSlot__clearSlot, 0x807A8998
.else
    .err
.endif

.set ITEMSLOT_GREEN_SHELL, 0
.set ITEMSLOT_RED_SHELL, 1
.set ITEMSLOT_BANANA, 2
.set ITEMSLOT_FAKE_ITEM_BOX, 3
.set ITEMSLOT_MUSHROOM, 4
.set ITEMSLOT_TRIPLE_MUSHROOM, 5
.set ITEMSLOT_BOBOMB, 6
.set ITEMSLOT_BLUE_SHELL, 7
.set ITEMSLOT_LIGHTNING, 8
.set ITEMSLOT_STAR, 9
.set ITEMSLOT_GOLDEN_MUSHROOM, 0xA
.set ITEMSLOT_MEGA_MUSHROOM, 0xB
.set ITEMSLOT_BLOOPER, 0xC
.set ITEMSLOT_POW, 0xD
.set ITEMSLOT_THUNDER_CLOUD, 0xE
.set ITEMSLOT_BULLET_BILL, 0xF
.set ITEMSLOT_TRIPLE_GREEN_SHELL, 0x10
.set ITEMSLOT_TRIPLE_RED_SHELL, 0x11
.set ITEMSLOT_TRIPLE_BANANA, 0x12
.set ITEMSLOT_NONE, 0x14

.set ITEMSLOT_STATE_STOPPED, 0

mr r28, r3

bl playerItemList

# Modify items from the list for each player. None = Not affected by the code

.byte ITEMSLOT_NONE # Player 1 (You offline)
.byte ITEMSLOT_NONE # Player 2/CPU 1
.byte ITEMSLOT_NONE # Player 3/CPU 2
.byte ITEMSLOT_NONE # Player 4/CPU 3
.byte ITEMSLOT_NONE # CPU 4
.byte ITEMSLOT_NONE # CPU 5
.byte ITEMSLOT_NONE # CPU 6
.byte ITEMSLOT_NONE # CPU 7
.byte ITEMSLOT_NONE # CPU 8
.byte ITEMSLOT_NONE # CPU 9
.byte ITEMSLOT_NONE # CPU 10
.byte ITEMSLOT_NONE # CPU 11

playerItemList:
mflr r4

lbzx r4, r4, r27
cmpwi r4, ITEMSLOT_NONE
beq end

lwz r3, 0x8C (r29)
cmpwi r3, ITEMSLOT_NONE
bne end

addi r3, r29, 0x88
li r5, 0
lis r12, ItemStock__setItem@h
ori r12, r12, ItemStock__setItem@l
mtctr r12
bctrl

lwz r3, 0x58 (r29)
cmpwi r3, ITEMSLOT_STATE_STOPPED
beq end

addi r3, r29, 0x54
lis r12, ItemSlot__clearSlot@h
ori r12, r12, ItemSlot__clearSlot@l
mtctr r12
bctrl

end:
lhz r5, 0x2C (r28) # Original instruction