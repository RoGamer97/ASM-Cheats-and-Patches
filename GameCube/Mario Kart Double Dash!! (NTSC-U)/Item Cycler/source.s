# Game: Mario Kart: Double Dash!!
# Code: Item Cycler


# This code has two versions: Debug and Infinite


# Debug version
# DoTandemItemRelease__8KartItemFv + 0x34
# 802BCA08

# Current item in the cycle is stored in padding byte
# Cycling items in Bob-omb Blast will give Bob-ombs instead
# Can't cycle during driver swap in Bob-omb Blast to avoid a bug
# where it can give Bomb-ombs past the max limit
# Cycling while in an active Chain Chomp item will separate you from
# it (Avoids a crash, and to be able to get out of it at will)
# When giving item, some race2D item window value is set to force the 
# item to appear and update on the slot HUD

# Register reference:
# r3 = ItemObj* of hand item
# r27 = Player ID
# r30 = KartBody*



.set addr_buttons, 0x803A4D9C
.set addr_race2D_itemSlotWindow, 0x8037FF70

.set setChildStateForceDisappear__7ItemObjFv, 0x8021522C
.set doDeleteList__7ItemObjFv, 0x80213C40
.set separate__13ItemWanWanObjFv, 0x80222CE4
.set getRobberyItemNum__10ItemObjMgrFiUc, 0x8020BA04
.set startItemShuffleSingle__10ItemObjMgrFib, 0x8020B800
.set IsRollingSlot__10ItemObjMgrFiUc, 0x8020B5E8
.set getKartEquipITEMSLOT__10ItemObjMgrFiUc, 0x80209A18
.set equipItemToKart__10ItemObjMgrFiiUcbUc, 0x80209120

.set ITEMSLOT_GREEN_SHELL, 0
.set ITEMSLOT_BOWSER_SHELL, 1
.set ITEMSLOT_RED_SHELL, 2
.set ITEMSLOT_BANANA, 3
.set ITEMSLOT_GIANT_BANANA, 4
.set ITEMSLOT_MUSHROOM, 5
.set ITEMSLOT_STAR, 6
.set ITEMSLOT_CHAIN_CHOMP, 7
.set ITEMSLOT_BOBOMB, 8
.set ITEMSLOT_FIREBALL, 9
.set ITEMSLOT_LIGHTNING, 0xA
.set ITEMSLOT_YOSHI_EGG, 0xB
.set ITEMSLOT_GOLDEN_MUSHROOM, 0xC
.set ITEMSLOT_BLUE_SHELL, 0xD
.set ITEMSLOT_HEART, 0xE
.set ITEMSLOT_FAKE_ITEMSLOT_BOX, 0xF
.set ITEMSLOT_EMPTY, 0x10

.set ITEMOBJ_STATE_RELEASE, 2
.set ITEMOBJ_STATE_DISAPPEAR, 0xA

.set BUTTONBIT_X, 10
.set BUTTONBIT_Y, 11
.set BUTTONBIT_R, 5
.set BUTTONBIT_DPAD_LEFT, 0
.set BUTTONBIT_DPAD_RIGHT, 1

.set BUTTON_X, (1 << BUTTONBIT_X)
.set BUTTON_Y, (1 << BUTTONBIT_Y)
.set BUTTON_R, (1 << BUTTONBIT_R)
.set BUTTON_DPAD_LEFT, (1 << BUTTONBIT_DPAD_LEFT)
.set BUTTON_DPAD_RIGHT, (1 << BUTTONBIT_DPAD_RIGHT)

.set GAMEMODE_BATTLE_BOBOMB_BLAST, 6

.SET RACE2D_ITEMWINDOWSTATE_FORCE_APPEAR, 9


stwu sp, -0x80 (sp)
stmw r3, 8 (sp)

mr r29, r3 # ItemObj of hand item

lwz r3, -0x5C38 (r13)
lwz r0, 0x38 (r3)
mulli r3, r27, 0x18
addi r3, r3, 0x30
add r3, r0, r3
lwz r3, 4 (r3)
cmplwi r3, 0
beq end

lwz r31, -0x54E0 (r13) # ItemObjMgr
subi r16, r31, 0x30 # Address of index of current item in cycle
lbzx r24, r16, r27 # Index of current item in cycle for that player (Not item ID! Table index)
lbz r26, 0x5B2 (r30)
xori r26, r26, 1 # Slot ID, but inverted

mr r3, r31
mr r4, r27
mr r5, r26
lis r12, IsRollingSlot__10ItemObjMgrFiUc@h
ori r12, r12, IsRollingSlot__10ItemObjMgrFiUc@l
mtctr r12
bctrl
cmpwi r3, 0
bne end

lis r12, addr_buttons@h
ori r12, r12, addr_buttons@l
mulli r4, r27, 0x30
add r12, r12, r4 # Controller address

lwz r5, 4 (r12)
lwz r12, 0 (r12)

li r6, 0 # Is in Bob-omb Blast bool (False by default)

lwz r4, -0x5C38 (r13)
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
andi. r9, r5, BUTTON_DPAD_LEFT | BUTTON_DPAD_RIGHT
beq end

andi. r12, r12, BUTTON_R
beq end

cmpwi r6, 0
beq isCycleLeft

lwz r3, 0x574 (r30)
andi. r3, r3, 0x80 # Swapping drivers
bne end

mr r3, r31
mr r4, r27
mr r5, r26
lis r12, getRobberyItemNum__10ItemObjMgrFiUc@h
ori r12, r12, getRobberyItemNum__10ItemObjMgrFiUc@l
mtctr r12
bctrl

lbz r4, -0x7610 (r13)
cmpw r3, r4
bge end # Max Bob-omb count on hand/item slot

mr r3, r31
mr r4, r27
li r5, 0
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

li r24, ITEMSLOT_LIST_LAST_INDEX

isAboveLastIndex:
cmpwi r24, ITEMSLOT_LIST_LAST_INDEX
ble store

li r24, 0

store:
stbx r24, r16, r27

cmpwi r29, 0
beq isKartEquipItem # Hand ItemObj is nullptr, no item on hand

lwz r4, 0x7C (r29)
cmpwi r4, ITEMSLOT_CHAIN_CHOMP
bne setStateForceDisappear

lwz r4, 0x118 (r29)
cmpwi r4, ITEMOBJ_STATE_RELEASE
bne setStateForceDisappear

mr r3, r29
lis r12, separate__13ItemWanWanObjFv@h
ori r12, r12, separate__13ItemWanWanObjFv@l
mtctr r12
bctrl
li r24, ITEMSLOT_CHAIN_CHOMP_INDEX
stbx r24, r16, r27
b end

setStateForceDisappear:
mr r3, r29
lis r12, setChildStateForceDisappear__7ItemObjFv@h
ori r12, r12, setChildStateForceDisappear__7ItemObjFv@l
mtctr r12
bctrl

mr r3, r29
lis r12, doDeleteList__7ItemObjFv@h
ori r12, r12, doDeleteList__7ItemObjFv@l
mtctr r12
bctrl

isKartEquipItem:
mr r3, r31
mr r4, r27
mr r5, r26
lis r12, getKartEquipITEMSLOT__10ItemObjMgrFiUc@h
ori r12, r12, getKartEquipITEMSLOT__10ItemObjMgrFiUc@l
mtctr r12
bctrl
cmpwi r3, 0
bne end

bl getTableItemByIndex

itemList:
.byte ITEMSLOT_EMPTY
.byte ITEMSLOT_GREEN_SHELL
.byte ITEMSLOT_BOWSER_SHELL
.byte ITEMSLOT_RED_SHELL
.byte ITEMSLOT_BANANA
.byte ITEMSLOT_GIANT_BANANA
.byte ITEMSLOT_MUSHROOM
.byte ITEMSLOT_STAR
itemChainChomp: .byte ITEMSLOT_CHAIN_CHOMP # Label used for Chain Chomp separate part of code
.byte ITEMSLOT_BOBOMB
.byte ITEMSLOT_FIREBALL
.byte ITEMSLOT_LIGHTNING
.byte ITEMSLOT_YOSHI_EGG
.byte ITEMSLOT_GOLDEN_MUSHROOM
.byte ITEMSLOT_BLUE_SHELL
.byte ITEMSLOT_HEART
.byte ITEMSLOT_FAKE_ITEMSLOT_BOX
itemListEnd:

.balign 4

# Labels used for index bounds
.set ITEMSLOT_LIST_COUNT, itemListEnd - itemList
.set ITEMSLOT_LIST_LAST_INDEX, ITEMSLOT_LIST_COUNT - 1
.set ITEMSLOT_CHAIN_CHOMP_INDEX, itemChainChomp - itemList

getTableItemByIndex:
mflr r4
lbzx r4, r4, r24
cmpwi r4, ITEMSLOT_EMPTY
beq end

mr r3, r31
mr r5, r27
mr r6, r26
li r7, 0
li r8, 0
lis r12, equipItemToKart__10ItemObjMgrFiiUcbUc@h
ori r12, r12, equipItemToKart__10ItemObjMgrFiiUcbUc@l
mtctr r12
bctrl

lis r3, addr_race2D_itemSlotWindow@h
ori r3, r3, addr_race2D_itemSlotWindow@l 
mulli r5, r27, 8
add r3, r3, r5

mulli r4, r26, 4
lwzx r5, r3, r4
cmpwi r5, 0
bne end

li r5, RACE2D_ITEMWINDOWSTATE_FORCE_APPEAR
stwx r5, r3, r4

end:
lmw r3, 8 (sp)
addi sp, sp, 0x80
mr. r29, r3 # Original instruction




# Infinite version
# DoTandemItemRelease__8KartItemFv + 0x34
# 802BCA08

# Current item in the cycle is stored in padding byte
# Cycling items in Bob-omb Blast will toggle infinite Bob-ombs
# Can't cycle during driver swap in Bob-omb Blast to avoid a bug
# where it can give Bomb-ombs past the max limit
# Cycling while in an active Chain Chomp item will separate you from
# it (Avoids a crash, and to be able to get out of it at will)
# When giving item, some race2D item window value is set to force the 
# item to appear and update on the slot HUD

# Globals
.set addr_buttons, 0x803A4D9C
.set addr_race2D_itemSlotWindow, 0x8037FF70

# Functions
.set setChildStateForceDisappear__7ItemObjFv, 0x8021522C
.set doDeleteList__7ItemObjFv, 0x80213C40
.set separate__13ItemWanWanObjFv, 0x80222CE4
.set getRobberyItemNum__10ItemObjMgrFiUc, 0x8020BA04
.set startItemShuffleSingle__10ItemObjMgrFib, 0x8020B800
.set IsRollingSlot__10ItemObjMgrFiUc, 0x8020B5E8
.set getKartEquipITEMSLOT__10ItemObjMgrFiUc, 0x80209A18
.set equipItemToKart__10ItemObjMgrFiiUcbUc, 0x80209120

# Defines
.set ITEMSLOT_GREEN_SHELL, 0
.set ITEMSLOT_BOWSER_SHELL, 1
.set ITEMSLOT_RED_SHELL, 2
.set ITEMSLOT_BANANA, 3
.set ITEMSLOT_GIANT_BANANA, 4
.set ITEMSLOT_MUSHROOM, 5
.set ITEMSLOT_STAR, 6
.set ITEMSLOT_CHAIN_CHOMP, 7
.set ITEMSLOT_BOBOMB, 8
.set ITEMSLOT_FIREBALL, 9
.set ITEMSLOT_LIGHTNING, 0xA
.set ITEMSLOT_YOSHI_EGG, 0xB
.set ITEMSLOT_GOLDEN_MUSHROOM, 0xC
.set ITEMSLOT_BLUE_SHELL, 0xD
.set ITEMSLOT_HEART, 0xE
.set ITEMSLOT_FAKE_ITEMSLOT_BOX, 0xF
.set ITEMSLOT_EMPTY, 0x10

.set ITEMOBJ_STATE_RELEASE, 2
.set ITEMOBJ_STATE_DISAPPEAR, 0xA

.set BUTTONBIT_X, 10
.set BUTTONBIT_Y, 11
.set BUTTONBIT_R, 5
.set BUTTONBIT_DPAD_LEFT, 0
.set BUTTONBIT_DPAD_RIGHT, 1

.set BUTTON_X, (1 << BUTTONBIT_X)
.set BUTTON_Y, (1 << BUTTONBIT_Y)
.set BUTTON_R, (1 << BUTTONBIT_R)
.set BUTTON_DPAD_LEFT, (1 << BUTTONBIT_DPAD_LEFT)
.set BUTTON_DPAD_RIGHT, (1 << BUTTONBIT_DPAD_RIGHT)

.set GAMEMODE_BATTLE_BOBOMB_BLAST, 6

.SET RACE2D_ITEMWINDOWSTATE_FORCE_APPEAR, 9

stwu sp, -0x80 (sp)
stmw r3, 8 (sp)

mr r29, r3 # ItemObj of hand item

lwz r3, -0x5C38 (r13)
lwz r0, 0x38 (r3)
mulli r3, r27, 0x18
addi r3, r3, 0x30
add r3, r0, r3
lwz r3, 4 (r3)
cmplwi r3, 0
beq end

lwz r31, -0x54E0 (r13) # ItemObjMgr
subi r16, r31, 0x30 # Address of index of current item in cycle
lbzx r24, r16, r27 # Index of current item in cycle for that player (Not item ID! Table index)
lbz r26, 0x5B2 (r30)
xori r26, r26, 1 # Slot ID, but inverted

mr r3, r31
mr r4, r27
mr r5, r26
lis r12, IsRollingSlot__10ItemObjMgrFiUc@h
ori r12, r12, IsRollingSlot__10ItemObjMgrFiUc@l
mtctr r12
bctrl
cmpwi r3, 0
bne end

lis r12, addr_buttons@h
ori r12, r12, addr_buttons@l
mulli r4, r27, 0x30
add r12, r12, r4 # Controller address

lwz r5, 4 (r12)
lwz r12, 0 (r12)

li r6, 0 # Is in Bob-omb Blast bool (False by default)

lwz r4, -0x5C38 (r13)
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
stbx r24, r16, r27
b isSetBomb

isBombhei:
cmpwi r6, 0
beq isKartEquipItem

isSetBomb:
cmpwi r24, 0
beq end 

lwz r3, 0x574 (r31)
andi. r3, r3, 0x80 # Swapping drivers
bne end

mr r3, r31
mr r4, r27
mr r5, r26
lis r12, getRobberyItemNum__10ItemObjMgrFiUc@h
ori r12, r12, getRobberyItemNum__10ItemObjMgrFiUc@l
mtctr r12
bctrl

lbz r4, -0x7610 (r13)
cmpw r3, r4
bge end # Max Bob-omb count on hand/item slot

mr r3, r31
mr r4, r27
li r5, 0
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

li r24, ITEMSLOT_LIST_LAST_INDEX

isAboveLastIndex:
cmpwi r24, ITEMSLOT_LIST_LAST_INDEX
ble store

li r24, 0

store:
stbx r24, r16, r27

cmpwi r29, 0
beq isKartEquipItem # Hand ItemObj is nullptr, no item on hand

lwz r4, 0x7C (r29)
cmpwi r4, ITEMSLOT_CHAIN_CHOMP
bne setStateForceDisappear

lwz r4, 0x118 (r29)
cmpwi r4, ITEMOBJ_STATE_RELEASE
bne setStateForceDisappear

mr r3, r29
lis r12, separate__13ItemWanWanObjFv@h
ori r12, r12, separate__13ItemWanWanObjFv@l
mtctr r12
bctrl
li r24, ITEMSLOT_CHAIN_CHOMP_INDEX
stbx r24, r16, r27
b end

setStateForceDisappear:
mr r3, r29
lis r12, setChildStateForceDisappear__7ItemObjFv@h
ori r12, r12, setChildStateForceDisappear__7ItemObjFv@l
mtctr r12
bctrl

mr r3, r29
lis r12, doDeleteList__7ItemObjFv@h
ori r12, r12, doDeleteList__7ItemObjFv@l
mtctr r12
bctrl

isKartEquipItem:
mr r3, r31
mr r4, r27
mr r5, r26
lis r12, getKartEquipITEMSLOT__10ItemObjMgrFiUc@h
ori r12, r12, getKartEquipITEMSLOT__10ItemObjMgrFiUc@l
mtctr r12
bctrl
cmpwi r3, 0
bne end

bl getTableItemByIndex

itemList:
.byte ITEMSLOT_EMPTY
.byte ITEMSLOT_GREEN_SHELL
.byte ITEMSLOT_BOWSER_SHELL
.byte ITEMSLOT_RED_SHELL
.byte ITEMSLOT_BANANA
.byte ITEMSLOT_GIANT_BANANA
.byte ITEMSLOT_MUSHROOM
.byte ITEMSLOT_STAR
itemChainChomp: .byte ITEMSLOT_CHAIN_CHOMP # Label used for Chain Chomp separate part of code
.byte ITEMSLOT_BOBOMB
.byte ITEMSLOT_FIREBALL
.byte ITEMSLOT_LIGHTNING
.byte ITEMSLOT_YOSHI_EGG
.byte ITEMSLOT_GOLDEN_MUSHROOM
.byte ITEMSLOT_BLUE_SHELL
.byte ITEMSLOT_HEART
.byte ITEMSLOT_FAKE_ITEMSLOT_BOX
itemListEnd:

.balign 4

# Labels used for index bounds
.set ITEMSLOT_LIST_COUNT, itemListEnd - itemList
.set ITEMSLOT_LIST_LAST_INDEX, ITEMSLOT_LIST_COUNT - 1
.set ITEMSLOT_CHAIN_CHOMP_INDEX, itemChainChomp - itemList

getTableItemByIndex:
mflr r4
lbzx r4, r4, r24
cmpwi r4, ITEMSLOT_EMPTY
beq end

mr r3, r31
mr r5, r27
mr r6, r26
li r7, 0
li r8, 0
lis r12, equipItemToKart__10ItemObjMgrFiiUcbUc@h
ori r12, r12, equipItemToKart__10ItemObjMgrFiiUcbUc@l
mtctr r12
bctrl

lis r3, addr_race2D_itemSlotWindow@h
ori r3, r3, addr_race2D_itemSlotWindow@l 
mulli r5, r27, 8
add r3, r3, r5

mulli r4, r26, 4
lwzx r5, r3, r4
cmpwi r5, 0
bne end

li r5, RACE2D_ITEMWINDOWSTATE_FORCE_APPEAR
stwx r5, r3, r4

end:
lmw r3, 8 (sp)
addi sp, sp, 0x80
mr. r29, r3 # Original instruction
