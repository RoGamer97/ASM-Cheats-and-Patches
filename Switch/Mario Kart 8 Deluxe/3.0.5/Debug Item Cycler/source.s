//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: Debug Item Cycler

//; You can find some documented headers here to learn more about the game
//; and know some offsets: https://github.com/fishguy6564/MK8DX-Headers


// Hooks are written over unused functions (never executed).
// There is a bit of free space in .text, but for some reason the emulator
// crashes when executing code in that space. Writing over unused functions
// doesn't cause a crash.


//; gear::ItemOwner::calcKeyInput_(void) + 0x324
//; 0x3F46C -> BL 0x62F528

//; Skip the code if not local player or online kart, or if in Time Trials or
//; Bob-omb Blast

//; Cycles items if R is held and D-Pad Left/Right is pressed
//; D-Pad Left goes to the previous item, D-Pad Right goes to the next item

//; Pressing the item use button will give you the last cycled item if
//; the slot is empty and not rotating, but only if the last item is not
//; "NONE"

//; W23 is a bool that determines if the item was given by cycling or by
//; pressing the item use button. It will be checked for deciding if the
//; item slot UI should settle or not

//; Make a list of items. The first item is "NONE", which is no item. 
//; It is the initial item so that pressing the item use button will give you no
//; item until you cycle to another item. You can cycle back to "NONE" to
//; clear your slot and prevent getting items if pressing the item use button.

//; When cycling items, it'll increment/decrement an index for the item in the
//; list. Reset it to 0 if going past the last index of the list, or reset it to
//; the last index of the list if going below 0.
//; Store an index to ItemOwner* + 0x39, which is a padding byte.

//; Then, clear the slot (doesn't clear the hand item), then loop through the hand item
//; and all 8 possible equipped items (dragged or rotating the kart), and clear
//; the ones that exists (object is not null pointer). Then, try to give item:

//; For giving item (After cycling or pressing item use button), it'll get the
//; index from ItemOwner* + 0x39 to get the item from the list indexed by it.
//; If the item is "NONE", don't give any item, otherwise store the item ID
//; to stack, then update gear::ItemNumManager for items in play count, and
//; then call gear::ItemNumManager::checkCreateNum(gear::EItemSlot) to check
//; if that item's limit has been reached or not.
//; If it has been reached, replace the item with a Coin.
//; Finally, call gear::ItemOwner::startSlot(int,gear::EItemSlot,bool), which
//; starts rotating the slot, but passing the bool as true will immediately
//; decide the item (bool is internally called "isDebug" or "isSlotDebug")

//; After starting the slot, if W23 bool is false, item was given by item use
//; button, skip ui::SettleItem(int,signed char,int,bool) call

//; ui::SettleItem(int,signed char,int,bool) forces the slot to settle and updates
//; the item image. Needed for updating the item image on the item slot.
//; Only call it if cycling to be accurate with the debug build behavior

//; Register reference:
//; W19 = Player ID
//; X20 = gear::ItemOwner*
//; W21 = Item slot index
//; W24 = Item use button pressed bool


.set RACERULE_TIME_TRIALS, 2
.set RACERULE_BATTLE, 3
.set BATTLETYPE_BOMB, 3

.set BUTTONBIT_R, 14
.set BUTTONBIT_DPAD_LEFT, 18
.set BUTTONBIT_DPAD_RIGHT, 19

.set BUTTON_DPAD_LEFT, (1 << BUTTONBIT_DPAD_LEFT)
.set BUTTON_DPAD_RIGHT, (1 << BUTTONBIT_DPAD_RIGHT)

.set ITEMOBJSTATE_KEEP, 1

.set ITEMSLOT_NONE, -1
.set ITEMSLOT_BANANA, 0
.set ITEMSLOT_GREEN_SHELL, 1
.set ITEMSLOT_RED_SHELL, 2
.set ITEMSLOT_MUSHROOM, 3
.set ITEMSLOT_BOBOMB, 4
.set ITEMSLOT_BLOOPER, 5
.set ITEMSLOT_BLUE_SHELL, 6
.set ITEMSLOT_TRIPLE_MUSHROOM, 7
.set ITEMSLOT_STAR, 8
.set ITEMSLOT_BULLET_BILL, 9
.set ITEMSLOT_LIGHTNING, 0xA
.set ITEMSLOT_GOLDEN_MUSHROOM, 0xB
.set ITEMSLOT_FIRE_FLOWER, 0xC
.set ITEMSLOT_PIRANHA_PLANT, 0xD
.set ITEMSLOT_BOOMERANG, 0xE
.set ITEMSLOT_COIN, 0xF
.set ITEMSLOT_SUPER_HORN, 0x10
.set ITEMSLOT_TRIPLE_BANANA, 0x11
.set ITEMSLOT_TRIPLE_GREEN_SHELL, 0x12
.set ITEMSLOT_TRIPLE_RED_SHELL, 0x13
.set ITEMSLOT_CRAZY_EIGHT, 0x14
.set ITEMSLOT_FEATHER, 0x15
.set ITEMSLOT_BOO, 0x16
.set ITEMSLOT_MAX, 0x17

STP X29, X30, [SP, #-0x20]!

LDR X8, [X20, #0x48]
LDR X8, [X8, #0x48]
LDRB W9, [X8, #0xD0]
CBZ W9, end //; Not local player kart

LDRB W9, [X8, #0xE6]
CBNZ W9, end //; Net send kart

BL 0x87C244 //; gear::GetRaceInfo

LDR W8, [X0, #8]
CMP W8, #RACERULE_TIME_TRIALS
BEQ end

CMP W8, #RACERULE_BATTLE
BNE isSlotRotate

LDR W8, [X0, #0xC]
CMP W8, #BATTLETYPE_BOMB
BEQ end

isSlotRotate:
MOV X0, X20
MOV W1, W21
BL 0x40494 //; gear::ItemOwner::isSlotRotate(int)
CBZ W0, isCycleItem

MOV W23, WZR
CBNZ W24, getListItemByIdx //; Item use button pressed

isCycleItem:
LDR W0, [X20, #0x40]
BL 0x8B9544 //; gear::GetControllerIndexFromKartIndex(int)
BL 0x8B94F4 //; gear::GetControllerRaceNonConst(int)
LDR X0, [X0, #0x158]
LDR W8, [X0, #0x114]
TBZ W8, #BUTTONBIT_R, end //; R button not held

LDR W8, [X0, #8]
MOV W9, #(BUTTON_DPAD_LEFT | BUTTON_DPAD_RIGHT)
TST W8, W9
BEQ end

MOV W23, #1

MOV W10, #1
TST W8, #BUTTON_DPAD_LEFT
CNEG W10, W10, NE

MOV W9, #ITEMSLOT_MAX
LDRB W8, [X20, #0x39]
ADD W8, W8, W10
CMP W8, #0
CSEL W8, W8, W9, GE
CMP W8, W9
CSEL W8, W8, WZR, LE
STRB W8, [X20, #0x39]

MOV X0, X20
MOV W1, W21
MOV W2, #1
BL 0x4078C //; gear::ItemOwner::clearSlot(int,bool)

MOV W27, WZR

vanishLoop:
ADD X8, X20, X27, LSL#3
LDR X0, [X8, #0x78]
CBZ X0, nextEquip

CBNZ W27, vanish //; Not hand keep item

LDRB W8, [X0, #0x71]
CMP W8, #ITEMOBJSTATE_KEEP
BNE nextEquip

MOV W8, #1
STRB W8, [X0,#0x22A]

vanish:
LDR X1, [X0]
LDR X1, [X1, #0xE8]
BLR X1

nextEquip:
ADD W27, W27, #1
CMP W27, #8
BLE vanishLoop

getListItemByIdx:
ADR X8, itemList
LDRB W9, [X20, #0x39]
LDRB W9, [X8,X9]
SXTB W9, W9
CMP W9, #ITEMSLOT_NONE
BEQ end

STR W9, [SP, #0x10]

BL 0x7F41FC //; gear::FrameworkUtil::getCurrentGameScene(void)
LDR X0, [X0,#0x1B0]
LDR X0, [X0,#0x240]
LDR X0, [X0,#0x108]
MOV X27, X0
BL 0xE290 //; gear::ItemNumManager::update(void)

MOV X0, X27
ADD X1, SP, #0x10
MOV W2, WZR
BL 0xE8B4 //; gear::ItemNumManager::checkCreateNum(gear::EItemSlot,int)
CBNZ W0, slotRotate //; Limit not reached

MOV W8, #ITEMSLOT_COIN
STR W8, [SP, #0x10]

slotRotate:
MOV X0, X20
MOV W1, W21
ADD X2, SP, #0x10
MOV W3, #1
MOV W4, #1
BL 0x42780 //; gear::ItemOwner::startSlot(int,gear::EItemSlot,bool,bool)

CBZ W23, end //; Item given by use button

MOV W0, W21
LDR W1, [SP, #0x10]
MOV W2, W19
MOV W3, WZR
BL 0x41F2D0 //; ui::SettleItem(int,signed char,int,bool)

end:
LDP X29, X30, [SP], #0x20
LDR W8, [X20, #0xC0]
RET

itemList:
.byte ITEMSLOT_NONE
.byte ITEMSLOT_BANANA
.byte ITEMSLOT_GREEN_SHELL
.byte ITEMSLOT_RED_SHELL
.byte ITEMSLOT_MUSHROOM
.byte ITEMSLOT_BOBOMB
.byte ITEMSLOT_BLOOPER
.byte ITEMSLOT_BLUE_SHELL
.byte ITEMSLOT_TRIPLE_MUSHROOM
.byte ITEMSLOT_STAR
.byte ITEMSLOT_BULLET_BILL
.byte ITEMSLOT_LIGHTNING
.byte ITEMSLOT_GOLDEN_MUSHROOM
.byte ITEMSLOT_FIRE_FLOWER
.byte ITEMSLOT_PIRANHA_PLANT
.byte ITEMSLOT_BOOMERANG
.byte ITEMSLOT_COIN
.byte ITEMSLOT_SUPER_HORN
.byte ITEMSLOT_TRIPLE_BANANA
.byte ITEMSLOT_TRIPLE_GREEN_SHELL
.byte ITEMSLOT_TRIPLE_RED_SHELL
.byte ITEMSLOT_CRAZY_EIGHT
.byte ITEMSLOT_FEATHER
.byte ITEMSLOT_BOO