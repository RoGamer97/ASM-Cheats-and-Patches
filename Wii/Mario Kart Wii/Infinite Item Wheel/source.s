# Game: Mario Kart Wii
# Code: Infinite Item Wheel
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 8078E95C
# PAL 80797968
# NTSC-J 80796FD4
# NTSC-K 80785D28


.set CONTROLLER_WII_WHEEL, 0
.set CONTROLLER_NUNCHUK, 1
.set CONTROLLER_CLASSIC, 2
.set CONTROLLER_GCN, 3

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.set controller, CONTROLLER_GCN # Set to GCN as placeholder, change it to your desired controller

.if (region == 'E' || region == 'e')
	.set ItemStock__clearItemAndDestroyDropItems, 0x807ADF94
    .set ItemStock__setItem, 0x807ADEE0
	.set ItemSlot__clearSlot, 0x807ABB78
.elseif (region == 'P' || region == 'p')
	.set ItemStock__clearItemAndDestroyDropItems, 0x807BC9F4
    .set ItemStock__setItem, 0x807BC940
	.set ItemSlot__clearSlot, 0x807BA5D8
.elseif (region == 'J' || region == 'j')
	.set ItemStock__clearItemAndDestroyDropItems, 0x807BC060
    .set ItemStock__setItem, 0x807BBFAC
	.set ItemSlot__clearSlot, 0x807B9C44
.elseif (region == 'K' || region == 'k')
	.set ItemStock__clearItemAndDestroyDropItems, 0x807AADB4
    .set ItemStock__setItem, 0x807AAD00
	.set ItemSlot__clearSlot, 0x807A8998
.else
    .err
.endif

.if (controller == CONTROLLER_WII_WHEEL)
    .set BUTTON_DPAD_LEFT, 8
    .set BUTTON_DPAD_RIGHT, 4
    .set BUTTON_DPAD_DOWN, 1
    .set BUTTON_DPAD_UP, 2
    .set BUTTON_PLUS, 0x10
    .set BUTTON_TWO, 0x100
    .set BUTTON_ONE, 0x200
    .set BUTTON_B, 0x400
    .set BUTTON_A, 0x800
    .set BUTTON_MINUS, 0x1000
    .set BUTTON_HOME, 0x8000
.elseif (controller == CONTROLLER_NUNCHUK)
    .set BUTTON_DPAD_LEFT, 1
    .set BUTTON_DPAD_RIGHT, 2
    .set BUTTON_DPAD_DOWN, 4
    .set BUTTON_DPAD_UP, 8
    .set BUTTON_PLUS, 0x10
    .set BUTTON_TWO, 0x100
    .set BUTTON_ONE, 0x200
    .set BUTTON_B, 0x400
    .set BUTTON_A, 0x800
    .set BUTTON_MINUS, 0x1000
    .set BUTTON_Z, 0x2000
    .set BUTTON_C, 0x4000
    .set BUTTON_HOME, 0x8000
.elseif (controller == CONTROLLER_CLASSIC)
    .set BUTTON_DPAD_LEFT, 1
    .set BUTTON_DPAD_RIGHT, 2
    .set BUTTON_ZR, 4
    .set BUTTON_X, 8
    .set BUTTON_A, 0x10
    .set BUTTON_Y, 0x20
    .set BUTTON_B, 0x40
    .set BUTTON_ZL, 0x80
    .set BUTTON_R, 0x200
    .set BUTTON_PLUS, 0x400
    .set BUTTON_HOME, 0x800
    .set BUTTON_MINUS, 0x1000
    .set BUTTON_L, 0x2000
    .set BUTTON_DPAD_DOWN, 0x4000
    .set BUTTON_DPAD_RIGHT, 0x8000
.elseif (controller == CONTROLLER_GCN)
    .set BUTTON_DPAD_LEFT, 1
    .set BUTTON_DPAD_RIGHT, 2
    .set BUTTON_DPAD_DOWN, 4
    .set BUTTON_DPAD_UP, 8
    .set BUTTON_Z, 0x10
    .set BUTTON_R, 0x20
    .set BUTTON_L, 0x40
    .set BUTTON_A, 0x100
    .set BUTTON_B, 0x200
    .set BUTTON_X, 0x400
    .set BUTTON_Y, 0x800
    .set BUTTON_START, 0x1000
.else
    .err # Invalid Controller
.endif

.set NO_BUTTON, 0
.set CHOSEN_CONTROLLER, controller

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

mr r28, r5

lwz r4, 0xC8 (r3)
cmpwi r4, CHOSEN_CONTROLLER
bne end

lwz r4, 0 (r29)
lwz r4, 4 (r4)
lwz r4, 0x14 (r4)
andi. r4, r4, 2
beq end # Not local player kart


# Items with multiple buttons that have one button for a single item MUST be placed on top
# For example, if D-Pad Right comes before B and D-Pad Right, the code will see that D-Pad was pressed and will give you the item assigned, and will never get to B and D-Pad Right
# But if B and D-Pad Right comes first, and if only one D-Pad is pressed, it will not give the assigned item since B wasn't pressed, and will give it for D-Pad
# Please look below how the code should be structured

# If you don't want to assign all buttons/items, set them to NO_BUTTON/EMPTY

bl buttonsItemsTable

buttonTable:
.hword  BUTTON_B + BUTTON_DPAD_RIGHT          # Red Shell
.hword  BUTTON_B + BUTTON_DPAD_LEFT             # Bullet Bill
.hword  BUTTON_B + BUTTON_DPAD_UP                # Banana
.hword  BUTTON_B + BUTTON_DPAD_DOWN         # Fake Item Box
.hword  BUTTON_Y + BUTTON_DPAD_LEFT         # Blue Shell
.hword  BUTTON_Y + BUTTON_DPAD_UP           # Blooper
.hword  BUTTON_Y + BUTTON_DPAD_DOWN         # POW
.hword  BUTTON_Y + BUTTON_DPAD_RIGHT        # Thunder Cloud
.hword  BUTTON_X + BUTTON_DPAD_DOWN        # Triple Banana
.hword  BUTTON_X + BUTTON_DPAD_LEFT         # Triple Red Shell
.hword  BUTTON_X + BUTTON_DPAD_RIGHT        # Triple Green Shell
.hword  BUTTON_X + BUTTON_Y + BUTTON_Z             # Empty (Clear item slot, can get items from item box)
.hword  BUTTON_X                         # Star
.hword  BUTTON_Z                         # Triple Mushroom
.hword  BUTTON_DPAD_DOWN             # Bob-omb
.hword  BUTTON_DPAD_RIGHT            # Green Shell
.hword  BUTTON_DPAD_LEFT             # Lightning
.hword  BUTTON_Y                         # Mega Mushroom
.hword  BUTTON_DPAD_UP        # Golden Mushroom
.hword  BUTTON_R + BUTTON_L                   # Mushroom
.long 0             # End of the table (DO NOT REMOVE)
buttonTableEnd:

.set BUTTON_TABLE_SIZE, (buttonTableEnd - buttonTable)

.byte ITEMSLOT_RED_SHELL        # B and D-Pad Right
.byte ITEMSLOT_BULLET_BILL         # B and D-Pad Left
.byte ITEMSLOT_BANANA         # B and D-Pad Up
.byte ITEMSLOT_FAKE_ITEM_BOX     # B and D-Pad Down
.byte ITEMSLOT_BLUE_SHELL         # Y and D-Pad Left
.byte ITEMSLOT_BLOOPER         # Y and D-Pad Up
.byte ITEMSLOT_POW         # Y and D-Pad Down
.byte ITEMSLOT_THUNDER_CLOUD     # Y and D-Pad Right
.byte ITEMSLOT_TRIPLE_BANANA     # X and D-Pad Down
.byte ITEMSLOT_TRIPLE_RED_SHELL     # X and D-Pad Left
.byte ITEMSLOT_TRIPLE_GREEN_SHELL     # X and D-Pad Right
.byte ITEMSLOT_NONE         # X, Y and Z
.byte ITEMSLOT_STAR         # X
.byte ITEMSLOT_TRIPLE_MUSHROOM     # Z
.byte ITEMSLOT_BOBOMB         # D-Pad Down
.byte ITEMSLOT_GREEN_SHELL        # D-Pad Right
.byte ITEMSLOT_LIGHTNING         # D-Pad Left
.byte ITEMSLOT_MEGA_MUSHROOM     # Y
.byte ITEMSLOT_GOLDEN_MUSHROOM    # D-Pad Up
.byte ITEMSLOT_MUSHROOM        # R + L

.balign 4

buttonsItemsTable:
mflr r4
addi r5, r4, BUTTON_TABLE_SIZE

li r6, 0

loop:
lhz r0, 0 (r4)
cmpwi r0, 0
beq hasEverSelectedItem

lwz r7, 0x2C (r3)
and r12, r7, r0
cmpw r0, r12
bne incLoop

lwz r11, 0x44 (r3)
andc r11, r7, r11
and. r0, r0, r11
bne loadItem

incLoop:
addi r4, r4, 2
addi r6, r6, 1
b loop

loadItem:
lwz r3, 0x58 (r29)
cmpwi r3, ITEMSLOT_STATE_STOPPED
bne end

lbzx r4, r5, r6
stb r4, 0xB3 (r29)

li r3, 1
stb r3, 0xB2 (r29)

lwz r3, 0x8C (r29)
cmpw r3, r4
beq end

cmpwi r3, ITEMSLOT_NONE
beq setItem

addi r3, r29, 0x88
lis r12, ItemStock__clearItemAndDestroyDropItems@h 
ori r12, r12, ItemStock__clearItemAndDestroyDropItems@l 
mtctr r12
bctrl
b setItem

hasEverSelectedItem:
lbz r3, 0xB2 (r29)
cmpwi r3, 0
beq end

lwz r3, 0x8C (r29)
cmpwi r3, ITEMSLOT_NONE
bne end

setItem:
lbz r4, 0xB3 (r29)
cmpwi r4, ITEMSLOT_NONE
beq end

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
mr r5, r28
lis r3, -1 # Original instruction