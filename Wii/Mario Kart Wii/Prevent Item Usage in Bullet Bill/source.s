# Game: Mario Kart Wii
# Code: Prevent Item Usage in Bullet Bill
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# Prevent specific items from being used in Bullet
# NTSC-U 8078EC38
# PAL 80797C44
# NTSC-J 807972B0
# NTSC-K 807860043

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

lis r3, 0x20C # Original instruction

# Table of items that should not be usable in Bullet
bl itemList

.byte ITEMSLOT_MUSHROOM
.byte ITEMSLOT_TRIPLE_MUSHROOM
.byte ITEMSLOT_LIGHTNING
.byte ITEMSLOT_STAR
.byte ITEMSLOT_GOLDEN_MUSHROOM
.byte ITEMSLOT_MEGA_MUSHROOM
.byte ITEMSLOT_BLOOPER
.byte ITEMSLOT_POW_BLOCK
.byte ITEMSLOT_BULLET_BILL
.byte 0xFF # End of list

itemList:
mflr r11

loop:
lwz r4, 0x8C (r29)
lbz r12, 0 (r11)
cmpwi r12, 0xFF
beq end

cmpw r4, r12
beq found

addi r11, r11, 1
b loop

found:
oris r3, r3, 0x800

end: