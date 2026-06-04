# Game: Mario Kart: Double Dash!! (July 5th, 2004 Debug Build)
# Code: Item Cycler


# This code has two versions: Debug and Infinite


# Debug version
# DoTandemItemRelease__8KartItemFv + 0x34
# 802FE950

# Current item in the cycle is stored in padding byte
# Cycling items in Bob-omb Blast will give Bob-ombs instead
# Can't cycle during driver swap in Bob-omb Blast to avoid a bug
# where it can give Bomb-ombs past the max limit
# Cycling while in an active Chain Chomp item will separate you from
# it (Avoids a crash, and to be able to get out of it at will)
# When giving item, some race2D item window value is set to force the 
# item to appear and update on the slot HUD

# Globals
.set addr_buttons, 0x803FA794
.set addr_race2D_itemSlotWindow, 0x803CA270

# Functions
.set isPlayerKart__8KartInfoCFv, 0x801B0B44
.set setChildStateForceDisappear__7ItemObjFv, 0x8024BF44
.set doDeleteList__7ItemObjFv, 0x8024A958
.set separate__13ItemWanWanObjFv, 0x8025B094
.set getRobberyItemNum__10ItemObjMgrFiUc, 0x80241928
.set startItemShuffleSingle__10ItemObjMgrFib, 0x80241534
.set getKartEquipItem__10ItemObjMgrFiUc, 0x8023ED84
.set IsRollingSlot__10ItemObjMgrFiUc, 0x8024131C
.set equipItemToKart__10ItemObjMgrFiiUcbUc, 0x8023E3D0

# Defines
.set ITEM_GREEN_SHELL, 0
.set ITEM_BOWSER_SHELL, 1
.set ITEM_RED_SHELL, 2
.set ITEM_BANANA, 3
.set ITEM_GIANT_BANANA, 4
.set ITEM_MUSHROOM, 5
.set ITEM_STAR, 6
.set ITEM_CHAIN_CHOMP, 7
.set ITEM_BOBOMB, 8
.set ITEM_FIREBALL, 9
.set ITEM_LIGHTNING, 0xA
.set ITEM_YOSHI_EGG, 0xB
.set ITEM_GOLDEN_MUSHROOM, 0xC
.set ITEM_BLUE_SHELL, 0xD
.set ITEM_HEART, 0xE
.set ITEM_FAKE_ITEM_BOX, 0xF
.set ITEM_EMPTY, 0x10

.set ITEMOBJ_STATE_RELEASE, 2
.set ITEMOBJ_STATE_DISAPPEAR, 0xA

.set BUTTON_X, 0x400
.set BUTTON_Y, 0x800
.set BUTTON_R, 0x20
.set BUTTON_DPAD_LEFT, 1
.set BUTTON_DPAD_RIGHT, 2

.set GAMEMODE_BATTLE_BOBOMB_BLAST, 6

.SET RACE2D_ITEMWINDOW_FORCE_APPEAR, 9


stwu sp, -0x80 (sp)
stmw r3, 8 (sp)

mr r28, r3 # ItemObj of hand item

lwz r3, 0 (r31)
lwz r3, 4 (r3)
mr r24, r3
mr r4, r30
lis r12, isPlayerKart__8KartInfoCFv@h
ori r12, r12, isPlayerKart__8KartInfoCFv@l
mtctr r12
bctrl
cmpwi r3, 0
beq end

lwz r11, -0x5430 (r13) # ItemObjMgr
subi r16, r11, 0x30 # Address of index of current item in cycle
lbzx r24, r16, r30 # Index of current item in cycle for that player (Not item ID! Table index)
lbz r27, 0x5B2 (r31)
xori r27, r27, 1 # Slot ID, but inverted

mr r3, r11
mr r4, r30
mr r5, r27
lis r12, IsRollingSlot__10ItemObjMgrFiUc@h
ori r12, r12, IsRollingSlot__10ItemObjMgrFiUc@l
mtctr r12
bctrl
cmpwi r3, 0
bne end

lis r12, addr_buttons@h
ori r12, r12, addr_buttons@l
mulli r4, r30, 0x30
add r12, r12, r4 # Controller address

lwz r5, 4 (r12)
lwz r12, 0 (r12)

li r6, 0 # Is in Bob-omb Blast bool (False by default)

lwz r4, -0x5BD8 (r13)
lwz r4, 0x38 (r4)
lwz r4, 8 (r4)
cmpwi r4, GAMEMODE_BATTLE_BOBOMB_BLAST
bne isUseButton

li r6, 1 # Set Bob-omb Blast bool
b isCycle

isUseButton:
andi. r9, r5, BUTTON_X | BUTTON_Y
bne isKartEquipItem

isCycle:
andi. r12, r12, BUTTON_R
beq end

andi. r9, r5, BUTTON_DPAD_LEFT | BUTTON_DPAD_RIGHT
beq end

cmpwi r6, 0
beq isCycleLeft

lwz r3, 0x574 (r31)
andi. r3, r3, 0x80
bne end

mr r3, r11
mr r4, r30
mr r5, r27
lis r12, getRobberyItemNum__10ItemObjMgrFiUc@h
ori r12, r12, getRobberyItemNum__10ItemObjMgrFiUc@l
mtctr r12
bctrl

lbz r4, -0x75E0 (r13)
cmpw r3, r4
bge end # Max Bob-omb count on hand/item slot

mr r3, r11
mr r4, r30
li r5, 0
lis r12, startItemShuffleSingle__10ItemObjMgrFib@h
ori r12, r12, startItemShuffleSingle__10ItemObjMgrFib@l
mtctr r12
bctrl 
b end

isCycleLeft:
andi. r5, r5, BUTTON_DPAD_LEFT
bne decrementIndex # Max Bob-omb count on hand/item slot

addi r24, r24, 1
b isBelowFirstIndex

decrementIndex:
subi r24, r24, 1

isBelowFirstIndex:
cmpwi r24, 0
bge isAboveLastIndex

li r24, ITEM_LIST_LAST_INDEX

isAboveLastIndex:
cmpwi r24, ITEM_LIST_LAST_INDEX
ble store

li r24, 0

store:
stbx r24, r16, r30

cmpwi r28, 0
beq isKartEquipItem # Hand ItemObj is nullptr, no item on hand

lwz r4, 0x7C (r28)
cmpwi r4, ITEM_CHAIN_CHOMP
bne setStateForceDisappear

lwz r4, 0x118 (r28)
cmpwi r4, ITEMOBJ_STATE_RELEASE
bne setStateForceDisappear

mr r3, r28
lis r12, separate__13ItemWanWanObjFv@h
ori r12, r12, separate__13ItemWanWanObjFv@l
mtctr r12
bctrl
li r24, ITEM_CHAIN_CHOMP_INDEX
stbx r24, r16, r30
b end

setStateForceDisappear:
mr r3, r28
lis r12, setChildStateForceDisappear__7ItemObjFv@h
ori r12, r12, setChildStateForceDisappear__7ItemObjFv@l
mtctr r12
bctrl

mr r3, r28
lis r12, doDeleteList__7ItemObjFv@h
ori r12, r12, doDeleteList__7ItemObjFv@l
mtctr r12
bctrl

isKartEquipItem:
mr r3, r11
mr r4, r30
mr r5, r27
lis r12, getKartEquipItem__10ItemObjMgrFiUc@h
ori r12, r12, getKartEquipItem__10ItemObjMgrFiUc@l
mtctr r12
bctrl
cmpwi r3, 0
bne end

bl getTableItemByIndex

itemList:
.byte ITEM_EMPTY
.byte ITEM_GREEN_SHELL
.byte ITEM_BOWSER_SHELL
.byte ITEM_RED_SHELL
.byte ITEM_BANANA
.byte ITEM_GIANT_BANANA
.byte ITEM_MUSHROOM
.byte ITEM_STAR
itemChainChomp: .byte ITEM_CHAIN_CHOMP # Label used for Chain Chomp separate part of code
.byte ITEM_BOBOMB
.byte ITEM_FIREBALL
.byte ITEM_LIGHTNING
.byte ITEM_YOSHI_EGG
.byte ITEM_GOLDEN_MUSHROOM
.byte ITEM_BLUE_SHELL
.byte ITEM_HEART
.byte ITEM_FAKE_ITEM_BOX
itemListEnd:

.balign 4

# Labels used for index bounds
.set ITEM_LIST_COUNT, itemListEnd - itemList
.set ITEM_LIST_LAST_INDEX, ITEM_LIST_COUNT - 1
.set ITEM_CHAIN_CHOMP_INDEX, itemChainChomp - itemList

getTableItemByIndex:
mflr r4
lbzx r4, r4, r24
cmpwi r4, ITEM_EMPTY
beq end

mr r3, r11
mr r5, r30
mr r6, r27
li r7, 0
li r8, 0
lis r12, equipItemToKart__10ItemObjMgrFiiUcbUc@h
ori r12, r12, equipItemToKart__10ItemObjMgrFiiUcbUc@l
mtctr r12
bctrl

lis r3, addr_race2D_itemSlotWindow@h
ori r3, r3, addr_race2D_itemSlotWindow@l 
mulli r5, r30, 8
add r3, r3, r5

# If state is not 0 (Empty), end the code
mulli r4, r27, 4
lwzx r5, r3, r4
cmpwi r5, 0
bne end

li r5, RACE2D_ITEMWINDOW_FORCE_APPEAR
stwx r5, r3, r4

end:
lmw r3, 8 (sp)
addi sp, sp, 0x80
mr. r28, r3 # Original instruction


# Infinite version
# DoTandemItemRelease__8KartItemFv + 0x34
# 802FE950

# Current item in the cycle is stored in padding byte
# Cycling items in Bob-omb Blast will toggle infinite Bob-ombs
# Can't cycle during driver swap in Bob-omb Blast to avoid a bug
# where it can give Bomb-ombs past the max limit
# Cycling while in an active Chain Chomp item will separate you from
# it (Avoids a crash, and to be able to get out of it at will)
# When giving item, some race2D item window value is set to force the 
# item to appear and update on the slot HUD

# Globals
.set addr_buttons, 0x803FA794
.set addr_race2D_itemSlotWindow, 0x803CA270

# Functions
.set isPlayerKart__8KartInfoCFv, 0x801B0B44
.set setChildStateForceDisappear__7ItemObjFv, 0x8024BF44
.set doDeleteList__7ItemObjFv, 0x8024A958
.set separate__13ItemWanWanObjFv, 0x8025B094
.set getRobberyItemNum__10ItemObjMgrFiUc, 0x80241928
.set startItemShuffleSingle__10ItemObjMgrFib, 0x80241534
.set getKartEquipItem__10ItemObjMgrFiUc, 0x8023ED84
.set IsRollingSlot__10ItemObjMgrFiUc, 0x8024131C
.set equipItemToKart__10ItemObjMgrFiiUcbUc, 0x8023E3D0

# Defines
.set ITEM_GREEN_SHELL, 0
.set ITEM_BOWSER_SHELL, 1
.set ITEM_RED_SHELL, 2
.set ITEM_BANANA, 3
.set ITEM_GIANT_BANANA, 4
.set ITEM_MUSHROOM, 5
.set ITEM_STAR, 6
.set ITEM_CHAIN_CHOMP, 7
.set ITEM_BOBOMB, 8
.set ITEM_FIREBALL, 9
.set ITEM_LIGHTNING, 0xA
.set ITEM_YOSHI_EGG, 0xB
.set ITEM_GOLDEN_MUSHROOM, 0xC
.set ITEM_BLUE_SHELL, 0xD
.set ITEM_HEART, 0xE
.set ITEM_FAKE_ITEM_BOX, 0xF
.set ITEM_EMPTY, 0x10

.set ITEMOBJ_STATE_RELEASE, 2
.set ITEMOBJ_STATE_DISAPPEAR, 0xA

.set BUTTON_X, 0x400
.set BUTTON_Y, 0x800
.set BUTTON_R, 0x20
.set BUTTON_DPAD_LEFT, 1
.set BUTTON_DPAD_RIGHT, 2

.set GAMEMODE_BATTLE_BOBOMB_BLAST, 6

.SET RACE2D_ITEMWINDOW_FORCE_APPEAR, 9

stwu sp, -0x80 (sp)
stmw r3, 8 (sp)

mr r28, r3 # ItemObj of hand item

lwz r3, 0 (r31)
lwz r3, 4 (r3)
mr r24, r3
mr r4, r30
lis r12, isPlayerKart__8KartInfoCFv@h
ori r12, r12, isPlayerKart__8KartInfoCFv@l
mtctr r12
bctrl
cmpwi r3, 0
beq end

lwz r11, -0x5430 (r13) # ItemObjMgr
subi r16, r11, 0x30 # Address of index of current item in cycle
lbzx r24, r16, r30 # Index of current item in cycle for that player (Not item ID! Table index)
lbz r27, 0x5B2 (r31)
xori r27, r27, 1 # Slot ID, but inverted

mr r3, r11
mr r4, r30
mr r5, r27
lis r12, IsRollingSlot__10ItemObjMgrFiUc@h
ori r12, r12, IsRollingSlot__10ItemObjMgrFiUc@l
mtctr r12
bctrl
cmpwi r3, 0
bne end

lis r12, addr_buttons@h
ori r12, r12, addr_buttons@l
mulli r4, r30, 0x30
add r12, r12, r4 # Controller address

lwz r5, 4 (r12)
lwz r12, 0 (r12)

li r6, 0 # Is in Bob-omb Blast bool (False by default)

lwz r4, -0x5BD8 (r13)
lwz r4, 0x38 (r4)
lwz r4, 8 (r4)
cmpwi r4, GAMEMODE_BATTLE_BOBOMB_BLAST
bne isCycle

li r6, 1 # Set Bob-omb Blast bool

isCycle:
andi. r12, r12, BUTTON_R
beq isBombhei

andi. r9, r5, BUTTON_DPAD_LEFT | BUTTON_DPAD_RIGHT
beq isBombhei

cmpwi r6, 0
beq isCycleLeft

xori r24, r24, 1
stbx r24, r16, r30
b isSetBomb

isBombhei:
cmpwi r6, 0
beq isKartEquipItem

isSetBomb:
cmpwi r24, 0
beq end 

lwz r3, 0x574 (r31)
andi. r3, r3, 0x80
bne end

mr r3, r11
mr r4, r30
mr r5, r27
lis r12, getRobberyItemNum__10ItemObjMgrFiUc@h
ori r12, r12, getRobberyItemNum__10ItemObjMgrFiUc@l
mtctr r12
bctrl

lbz r4, -0x75E0 (r13)
cmpw r3, r4
bge end # Max amount of Bob-ombs on hand/in the slot

mr r3, r11
mr r4, r30
lis r12, startItemShuffleSingle__10ItemObjMgrFib@h
ori r12, r12, startItemShuffleSingle__10ItemObjMgrFib@l
mtctr r12
bctrl 
b end

isCycleLeft:
andi. r5, r5, BUTTON_DPAD_LEFT
bne decrementIndex

addi r24, r24, 1
b isBelowFirstIndex

decrementIndex:
subi r24, r24, 1

isBelowFirstIndex:
cmpwi r24, 0
bge isAboveLastIndex

li r24, ITEM_LIST_LAST_INDEX

isAboveLastIndex:
cmpwi r24, ITEM_LIST_LAST_INDEX
ble store

li r24, 0

store:
stbx r24, r16, r30

cmpwi r28, 0
beq isKartEquipItem # Hand ItemObj is nullptr, no item on hand

lwz r4, 0x7C (r28)
cmpwi r4, ITEM_CHAIN_CHOMP
bne setStateForceDisappear

lwz r4, 0x118 (r28)
cmpwi r4, ITEMOBJ_STATE_RELEASE
bne setStateForceDisappear

mr r3, r28
lis r12, separate__13ItemWanWanObjFv@h
ori r12, r12, separate__13ItemWanWanObjFv@l
mtctr r12
bctrl
li r24, ITEM_CHAIN_CHOMP_INDEX
stbx r24, r16, r30
b end

setStateForceDisappear:
mr r3, r28
lis r12, setChildStateForceDisappear__7ItemObjFv@h
ori r12, r12, setChildStateForceDisappear__7ItemObjFv@l
mtctr r12
bctrl

mr r3, r28
lis r12, doDeleteList__7ItemObjFv@h
ori r12, r12, doDeleteList__7ItemObjFv@l
mtctr r12
bctrl

isKartEquipItem:
mr r3, r11
mr r4, r30
mr r5, r27
lis r12, getKartEquipItem__10ItemObjMgrFiUc@h
ori r12, r12, getKartEquipItem__10ItemObjMgrFiUc@l
mtctr r12
bctrl
cmpwi r3, 0
bne end

bl getTableItemByIndex

itemList:
.byte ITEM_EMPTY
.byte ITEM_GREEN_SHELL
.byte ITEM_BOWSER_SHELL
.byte ITEM_RED_SHELL
.byte ITEM_BANANA
.byte ITEM_GIANT_BANANA
.byte ITEM_MUSHROOM
.byte ITEM_STAR
itemChainChomp: .byte ITEM_CHAIN_CHOMP # Label used for Chain Chomp separate part of code
.byte ITEM_BOBOMB
.byte ITEM_FIREBALL
.byte ITEM_LIGHTNING
.byte ITEM_YOSHI_EGG
.byte ITEM_GOLDEN_MUSHROOM
.byte ITEM_BLUE_SHELL
.byte ITEM_HEART
.byte ITEM_FAKE_ITEM_BOX
itemListEnd:

.balign 4

# Labels used for index bounds
.set ITEM_LIST_COUNT, itemListEnd - itemList
.set ITEM_LIST_LAST_INDEX, ITEM_LIST_COUNT - 1
.set ITEM_CHAIN_CHOMP_INDEX, itemChainChomp - itemList

getTableItemByIndex:
mflr r4
lbzx r4, r4, r24
cmpwi r4, ITEM_EMPTY
beq end

mr r3, r11
mr r5, r30
mr r6, r27
li r7, 0
li r8, 0
lis r12, equipItemToKart__10ItemObjMgrFiiUcbUc@h
ori r12, r12, equipItemToKart__10ItemObjMgrFiiUcbUc@l
mtctr r12
bctrl

lis r3, addr_race2D_itemSlotWindow@h
ori r3, r3, addr_race2D_itemSlotWindow@l 
mulli r5, r30, 8
add r3, r3, r5

mulli r4, r27, 4
lwzx r5, r3, r4
cmpwi r5, 0
bne end

li r5, RACE2D_ITEMWINDOW_FORCE_APPEAR
stwx r5, r3, r4

end:
lmw r3, 8 (sp)
addi sp, sp, 0x80
mr. r28, r3 # Original instruction