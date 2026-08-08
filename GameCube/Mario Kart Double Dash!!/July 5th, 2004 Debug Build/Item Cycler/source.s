# Game: Mario Kart: Double Dash!! (July 5th, 2004 Debug Build)
# Code: Item Cycler


# This code has two versions: Debug and Infinite


# Debug version
# DoTandemItemRelease__8KartItemFv + 0x34
# 802FE950

# Holding R and D-Pad Left/Right cycles through items

# Pressing X or Y gives the last cycled item as long as
# it's not the "No Item", no item is on hand/slot and slot
# is not spinning

# Only allow cycling for local player's kart
# Don't allow cycling if slot is spinning

# If in Bob-omb Blast, give Bob-ombs on cycle instead
# Item use button does not give items

# Don't give Bob-ombs if changing drivers or having
# maximum amount of Bob-ombs on the hand
# Don't allow it while changing drivers because of a bug
# where it incorrectly reads the Bob-omb amount, allowing
# to give more than the maximum amount

# When cycling:
# Increment/decrement the current cycled item index
# and store it in a padding byte
# Wrap it between 0 and the last index of the list

# If having an item on the hand, clear it and delete it
# from the item list

# If using a Chain Chomp, separate it from the kart instead
# (avoid crash, plus you can't change items in Chain Chomp),
# and set the cycled item index to Chain Chomp's to avoid desync
# (item isn't given at that moment but index changes, so "undo"
# the change)

# When pressing item use button:
# If no item is on the hand and slot is not spinning, give item

# Giving item (cycle or item use button):
# Get item from list by index; if item is "No Item", don't give item
# Give item and set the item window HUD state to make the item appear
# (same state used when stealing item by punch or getting a
# dropped item with a Heart)


# Register reference:
# r3 = ItemObj* of hand item
# r30 = Player ID
# r31 = KartBody*


.set addr_buttons, 0x803FA794
.set addr_race2D_itemSlotWindow, 0x803CA270

.set isPlayerKart__8KartInfoCFv, 0x801B0B44
.set setChildStateForceDisappear__7ItemObjFv, 0x8024BF44
.set doDeleteList__7ItemObjFv, 0x8024A958
.set separate__13ItemWanWanObjFv, 0x8025B094
.set getRobberyItemNum__10ItemObjMgrFiUc, 0x80241928
.set startItemShuffleSingle__10ItemObjMgrFib, 0x80241534
.set getKartEquipItem__10ItemObjMgrFiUc, 0x8023ED84
.set IsRollingSlot__10ItemObjMgrFiUc, 0x8024131C
.set equipItemToKart__10ItemObjMgrFiiUcbUc, 0x8023E3D0

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

.set KARTSTATUSBIT_CHANGING_DRIVER, 7

.set KARTSTATUS_CHANGING_DRIVER, (1 << KARTSTATUSBIT_CHANGING_DRIVER)

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

.set BATTLETYPE_BOBOMB_BLAST, 6

.SET ITEMWINDOWSTATE_APPEAR, 9

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
subi r16, r11, 0x30
lbzx r24, r16, r30
lbz r27, 0x5B2 (r31)
xori r27, r27, 1 # Slot index, but inverted

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
cmpwi r4, BATTLETYPE_BOBOMB_BLAST
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
andi. r3, r3, KARTSTATUS_CHANGING_DRIVER
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
bge end

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
stbx r24, r16, r30

cmpwi r28, 0
beq isKartEquipItem

lwz r4, 0x7C (r28)
cmpwi r4, ITEMSLOT_CHAIN_CHOMP
bne setStateForceDisappear

lwz r4, 0x118 (r28)
cmpwi r4, ITEMOBJ_STATE_RELEASE
bne setStateForceDisappear

mr r3, r28
lis r12, separate__13ItemWanWanObjFv@h
ori r12, r12, separate__13ItemWanWanObjFv@l
mtctr r12
bctrl
li r24, ITEMSLOT_CHAIN_CHOMP_INDEX
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

bl getListItemByIdx

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

# Labels used for index wrap
.set ITEMSLOT_LIST_COUNT, itemListEnd - itemList
.set ITEMSLOT_LIST_LAST_INDEX, ITEMSLOT_LIST_COUNT - 1
.set ITEMSLOT_CHAIN_CHOMP_INDEX, itemChainChomp - itemList

getListItemByIdx:
mflr r4
lbzx r4, r4, r24
cmpwi r4, ITEMSLOT_EMPTY
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

li r5, ITEMWINDOWSTATE_APPEAR
stwx r5, r3, r4

end:
lmw r3, 8 (sp)
addi sp, sp, 0x80
mr. r28, r3 # Original instruction


# Infinite version
# DoTandemItemRelease__8KartItemFv + 0x34
# 802FE950

# Holding R and D-Pad Left/Right cycles through items

# Only allow cycling for local player's kart
# Don't allow cycling if slot is spinning

# If in Bob-omb Blast, toggle infinite Bob-ombs on cycle
# instead. It'll always give Bob-ombs when enabled,
# except if the maximum amount of Bob-ombs on the hand
# has been hit
# Don't allow it while changing drivers because of a bug
# where it incorrectly reads the Bob-omb amount, allowing
# to give more than the maximum amount

# When cycling:
# Increment/decrement the current cycled item index
# and store it in a padding byte
# Wrap it between 0 and the last index of the list

# If having an item on the hand, clear it and delete it
# from the item list

# If using a Chain Chomp, separate it from the kart instead
# (avoid crash, plus you can't change items in Chain Chomp),
# and set the cycled item index to Chain Chomp's to avoid desync
# (item isn't given at that moment but index changes, so "undo"
# the change)

# When using the cycled item, it'll automatically be given again,
# making it "infinite"

# Giving item (cycle or automatically give):
# Get item from list by index; if item is "No Item", don't give item
# Give item and set the item window HUD state to make the item appear
# (same state used when stealing item by punch or getting a
# dropped item with a Heart)


.set addr_buttons, 0x803FA794
.set addr_race2D_itemSlotWindow, 0x803CA270

.set isPlayerKart__8KartInfoCFv, 0x801B0B44
.set setChildStateForceDisappear__7ItemObjFv, 0x8024BF44
.set doDeleteList__7ItemObjFv, 0x8024A958
.set separate__13ItemWanWanObjFv, 0x8025B094
.set getRobberyItemNum__10ItemObjMgrFiUc, 0x80241928
.set startItemShuffleSingle__10ItemObjMgrFib, 0x80241534
.set getKartEquipItem__10ItemObjMgrFiUc, 0x8023ED84
.set IsRollingSlot__10ItemObjMgrFiUc, 0x8024131C
.set equipItemToKart__10ItemObjMgrFiiUcbUc, 0x8023E3D0

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

.set KARTSTATUSBIT_CHANGING_DRIVER, 7

.set KARTSTATUS_CHANGING_DRIVER, (1 << KARTSTATUSBIT_CHANGING_DRIVER)

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

.set BATTLETYPE_BOBOMB_BLAST, 6

.SET ITEMWINDOWSTATE_APPEAR, 9

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
subi r16, r11, 0x30
lbzx r24, r16, r30
lbz r27, 0x5B2 (r31)
xori r27, r27, 1 # Slot index, but inverted

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
add r12, r12, r4

lwz r5, 4 (r12)
lwz r12, 0 (r12)

li r6, 0

lwz r4, -0x5BD8 (r13)
lwz r4, 0x38 (r4)
lwz r4, 8 (r4)
cmpwi r4, BATTLETYPE_BOBOMB_BLAST
bne isCycle

li r6, 1

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
andi. r3, r3, KARTSTATUS_CHANGING_DRIVER
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
bge end

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

li r24, ITEMSLOT_LIST_LAST_INDEX

isAboveLastIndex:
cmpwi r24, ITEMSLOT_LIST_LAST_INDEX
ble store

li r24, 0

store:
stbx r24, r16, r30

cmpwi r28, 0
beq isKartEquipItem

lwz r4, 0x7C (r28)
cmpwi r4, ITEMSLOT_CHAIN_CHOMP
bne setStateForceDisappear

lwz r4, 0x118 (r28)
cmpwi r4, ITEMOBJ_STATE_RELEASE
bne setStateForceDisappear

mr r3, r28
lis r12, separate__13ItemWanWanObjFv@h
ori r12, r12, separate__13ItemWanWanObjFv@l
mtctr r12
bctrl
li r24, ITEMSLOT_CHAIN_CHOMP_INDEX
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

bl getListItemByIdx

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

# Labels used for index wrap
.set ITEMSLOT_LIST_COUNT, itemListEnd - itemList
.set ITEMSLOT_LIST_LAST_INDEX, ITEMSLOT_LIST_COUNT - 1
.set ITEMSLOT_CHAIN_CHOMP_INDEX, itemChainChomp - itemList

getListItemByIdx:
mflr r4
lbzx r4, r4, r24
cmpwi r4, ITEMSLOT_EMPTY
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

li r5, ITEMWINDOWSTATE_APPEAR
stwx r5, r3, r4

end:
lmw r3, 8 (sp)
addi sp, sp, 0x80
mr. r28, r3 # Original instruction