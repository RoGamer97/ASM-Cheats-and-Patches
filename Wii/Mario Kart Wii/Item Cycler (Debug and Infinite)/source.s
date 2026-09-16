# Game: Mario Kart Wii
# Code: Item Cycler (Debug and Infinite)
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names


# Debug version
# NTSC-U 8078EDCC
# PAL 80797DD8
# NTSC-J 80797444
# NTSC-K 80786198

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'E' || region == 'e')
    .set ControllerHolder__getKPad, 0x80589BD0
	.set ItemStock__clearItemAndDestroyDropItems, 0x807ADF94
	.set ItemStock__setItem, 0x807ADEE0
.elseif (region == 'P' || region == 'p')
    .set ControllerHolder__getKPad, 0x805903F4
	.set ItemStock__clearItemAndDestroyDropItems, 0x807BC9F4
	.set ItemStock__setItem, 0x807BC940
.elseif (region == 'J' || region == 'j')
    .set ControllerHolder__getKPad, 0x8058FD74
	.set ItemStock__clearItemAndDestroyDropItems, 0x807BC060
	.set ItemStock__setItem, 0x807BBFAC
.elseif (region == 'K' || region == 'k')
    .set ControllerHolder__getKPad, 0x8057E44C
	.set ItemStock__clearItemAndDestroyDropItems, 0x807AADB4
	.set ItemStock__setItem, 0x807AAD00
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
.set ITEMSLOT_POW_BLOCK, 0xD
.set ITEMSLOT_THUNDER_CLOUD, 0xE
.set ITEMSLOT_BULLET_BILL, 0xF
.set ITEMSLOT_TRIPLE_GREEN_SHELL, 0x10
.set ITEMSLOT_TRIPLE_RED_SHELL, 0x11
.set ITEMSLOT_TRIPLE_BANANA, 0x12
.set ITEMSLOT_NONE, 0x14

.set ITEMTYPE_NONE, 0x10

.set BUTTON_UPPERHALF_DPAD_LEFT, 0x20
.set BUTTON_UPPERHALF_DPAD_RIGHT, 0x40

.set BUTTON_Y_GCN, 0x800
.set BUTTON_Y_CLASSIC, 0x20

.set CONTROLLER_WIIWHEEL, 0
.set CONTROLLER_CLASSIC, 2

.set ITEMSLOT_STATE_STOPPED, 0
.set ITEMSLOT_STATE_SPIN, 1
.set ITEMSLOT_STATE_LAST_SPIN, 2


lwz r3, 0 (r29)
lwz r3, 4 (r3)
lwz r3, 0x14 (r3)
andi. r3, r3, 2
beq end #  Not local player kart

mr r3, r29
lis r12, ControllerHolder__getKPad@h
ori r12, r12, ControllerHolder__getKPad@l
mtctr r12
bctrl

lwz r5, 0xC8 (r3)
cmpwi r5, CONTROLLER_WIIWHEEL
beq end

lwz r0, 0x58 (r29)
cmpwi r0, ITEMSLOT_STATE_STOPPED
bne end

lbz r4, 0xB3 (r29)

lhz r0, 0xC (r29)
andi. r0, r0, 0x40
beq isCycleItem

lwz r0, 0x8C (r29)
cmpwi r0, ITEMSLOT_NONE
bne isCycleItem

lwz r0, 0xC8 (r29)
cmpwi r0, ITEMTYPE_NONE
beq getTableItemByIndex

isCycleItem:
lwz r0, 0x5C (r3)
lwz r3, 0x90 (r3)
cmpwi r5, CONTROLLER_CLASSIC
blt isCycleBtnTrig 

li r5, BUTTON_Y_CLASSIC
beq isYHold

li r5, BUTTON_Y_GCN

isYHold:
and. r5, r0, r5
beq end

isCycleBtnTrig:
andc. r0, r0, r3
andis. r3, r0, (BUTTON_UPPERHALF_DPAD_LEFT | BUTTON_UPPERHALF_DPAD_RIGHT)
beq end

andis. r3, r0, BUTTON_UPPERHALF_DPAD_LEFT
bne subtractIndex

addi r4, r4, 1
b isBelowFirstIndex

subtractIndex:
subi r4, r4, 1

isBelowFirstIndex:
cmpwi r4, 0
bge isIndexMax

li r4, ITEM_LIST_LAST_INDEX

isIndexMax:
cmpwi r4, ITEM_LIST_LAST_INDEX
ble storeIndex

li r4, 0

storeIndex:
stb r4, 0xB3 (r29)

addi r3, r29, 0x88
lis r12, ItemStock__clearItemAndDestroyDropItems@h 
ori r12, r12, ItemStock__clearItemAndDestroyDropItems@l 
mtctr r12
bctrl

getTableItemByIndex:
bl getIndexItem

itemList:
.byte ITEMSLOT_NONE
.byte ITEMSLOT_GREEN_SHELL
.byte ITEMSLOT_RED_SHELL
.byte ITEMSLOT_BANANA
.byte ITEMSLOT_FAKE_ITEM_BOX
.byte ITEMSLOT_MUSHROOM
.byte ITEMSLOT_TRIPLE_MUSHROOM
.byte ITEMSLOT_BOBOMB
.byte ITEMSLOT_BLUE_SHELL
.byte ITEMSLOT_LIGHTNING
.byte ITEMSLOT_STAR
.byte ITEMSLOT_GOLDEN_MUSHROOM
.byte ITEMSLOT_MEGA_MUSHROOM
.byte ITEMSLOT_BLOOPER
.byte ITEMSLOT_POW_BLOCK
.byte ITEMSLOT_THUNDER_CLOUD
.byte ITEMSLOT_BULLET_BILL
.byte ITEMSLOT_TRIPLE_GREEN_SHELL
.byte ITEMSLOT_TRIPLE_RED_SHELL
.byte ITEMSLOT_TRIPLE_BANANA
itemListEnd:

.balign 4

.set ITEM_LIST_LAST_INDEX, (itemListEnd - itemList) - 1

getIndexItem:
mflr r3
lbz r4, 0xB3 (r29)
lbzx r4, r3, r4
cmpwi r4, ITEMSLOT_NONE
beq end

addi r3, r29, 0x88
li r5, 0
lis r12, ItemStock__setItem@h
ori r12, r12, ItemStock__setItem@l
mtctr r12
bctrl

end:
lhz r0, 0xC (r29)



# Infinite version
# NTSC-U 8078EDCC
# PAL 80797DD8
# NTSC-J 80797444
# NTSC-K 80786198

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'E' || region == 'e')
    .set ControllerHolder__getKPad, 0x80589BD0
	.set ItemStock__clearItemAndDestroyDropItems, 0x807ADF94
	.set ItemStock__setItem, 0x807ADEE0
.elseif (region == 'P' || region == 'p')
    .set ControllerHolder__getKPad, 0x805903F4
	.set ItemStock__clearItemAndDestroyDropItems, 0x807BC9F4
	.set ItemStock__setItem, 0x807BC940
.elseif (region == 'J' || region == 'j')
    .set ControllerHolder__getKPad, 0x8058FD74
	.set ItemStock__clearItemAndDestroyDropItems, 0x807BC060
	.set ItemStock__setItem, 0x807BBFAC
.elseif (region == 'K' || region == 'k')
    .set ControllerHolder__getKPad, 0x8057E44C
	.set ItemStock__clearItemAndDestroyDropItems, 0x807AADB4
	.set ItemStock__setItem, 0x807AAD00
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
.set ITEMSLOT_POW_BLOCK, 0xD
.set ITEMSLOT_THUNDER_CLOUD, 0xE
.set ITEMSLOT_BULLET_BILL, 0xF
.set ITEMSLOT_TRIPLE_GREEN_SHELL, 0x10
.set ITEMSLOT_TRIPLE_RED_SHELL, 0x11
.set ITEMSLOT_TRIPLE_BANANA, 0x12
.set ITEMSLOT_NONE, 0x14

.set ITEMTYPE_NONE, 0x10

.set BUTTON_UPPERHALF_DPAD_LEFT, 0x20
.set BUTTON_UPPERHALF_DPAD_RIGHT, 0x40

.set BUTTON_Y_GCN, 0x800
.set BUTTON_Y_CLASSIC, 0x20

.set CONTROLLER_WIIWHEEL, 0
.set CONTROLLER_CLASSIC, 2

.set ITEMSLOT_STATE_STOPPED, 0
.set ITEMSLOT_STATE_SPIN, 1
.set ITEMSLOT_STATE_LAST_SPIN, 2

lwz r3, 0 (r29)
lwz r3, 4 (r3)
lwz r3, 0x14 (r3)
andi. r3, r3, 2
beq end # Not local player kart

mr r3, r29
lis r12, ControllerHolder__getKPad@h
ori r12, r12, ControllerHolder__getKPad@l
mtctr r12
bctrl

lwz r5, 0xC8 (r3)
cmpwi r5, CONTROLLER_WIIWHEEL
beq end

lwz r0, 0x58 (r29)
cmpwi r0, ITEMSLOT_STATE_STOPPED
bne end

lbz r4, 0xB3 (r29)

lwz r0, 0x5C (r3)
lwz r3, 0x90 (r3)
cmpwi r5, CONTROLLER_CLASSIC
blt isCycleBtnTrig 

li r5, BUTTON_Y_CLASSIC
beq isYHold

li r5, BUTTON_Y_GCN

isYHold:
and. r5, r0, r5
beq isStockEmpty

isCycleBtnTrig:
andc. r0, r0, r3
andis. r3, r0, (BUTTON_UPPERHALF_DPAD_LEFT | BUTTON_UPPERHALF_DPAD_RIGHT)
beq isStockEmpty

andis. r3, r0, BUTTON_UPPERHALF_DPAD_LEFT
bne subtractIndex

addi r4, r4, 1
b isBelowFirstIndex

subtractIndex:
subi r4, r4, 1

isBelowFirstIndex:
cmpwi r4, 0
bge isIndexMax

li r4, ITEM_LIST_LAST_INDEX

isIndexMax:
cmpwi r4, ITEM_LIST_LAST_INDEX
ble storeIndex

li r4, 0

storeIndex:
stb r4, 0xB3 (r29)

addi r3, r29, 0x88
lis r12, ItemStock__clearItemAndDestroyDropItems@h 
ori r12, r12, ItemStock__clearItemAndDestroyDropItems@l 
mtctr r12
bctrl

isStockEmpty:
lwz r0, 0x8C (r29)
cmpwi r0, ITEMSLOT_NONE
bne end

getTableItemByIndex:
bl getIndexItem

itemList:
.byte ITEMSLOT_NONE
.byte ITEMSLOT_GREEN_SHELL
.byte ITEMSLOT_RED_SHELL
.byte ITEMSLOT_BANANA
.byte ITEMSLOT_FAKE_ITEM_BOX
.byte ITEMSLOT_MUSHROOM
.byte ITEMSLOT_TRIPLE_MUSHROOM
.byte ITEMSLOT_BOBOMB
.byte ITEMSLOT_BLUE_SHELL
.byte ITEMSLOT_LIGHTNING
.byte ITEMSLOT_STAR
.byte ITEMSLOT_GOLDEN_MUSHROOM
.byte ITEMSLOT_MEGA_MUSHROOM
.byte ITEMSLOT_BLOOPER
.byte ITEMSLOT_POW_BLOCK
.byte ITEMSLOT_THUNDER_CLOUD
.byte ITEMSLOT_BULLET_BILL
.byte ITEMSLOT_TRIPLE_GREEN_SHELL
.byte ITEMSLOT_TRIPLE_RED_SHELL
.byte ITEMSLOT_TRIPLE_BANANA
itemListEnd:

.balign 4

.set ITEM_LIST_LAST_INDEX, (itemListEnd - itemList) - 1

getIndexItem:
mflr r3
lbz r4, 0xB3 (r29)
lbzx r4, r3, r4
cmpwi r4, ITEMSLOT_NONE
beq end

addi r3, r29, 0x88
li r5, 0
lis r12, ItemStock__setItem@h
ori r12, r12, ItemStock__setItem@l
mtctr r12
bctrl

end:
lhz r0, 0xC (r29)