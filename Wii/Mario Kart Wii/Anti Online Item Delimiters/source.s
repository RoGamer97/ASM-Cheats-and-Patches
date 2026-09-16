# Game: Mario Kart Wii
# Code: Anti Online Item Delimiters
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 80788940
# PAL 8079194C
# NTSC-J 80790FB8
# NTSC-K 8077FD0C

.set ITEMSLOT_MUSHROOM, 4
.set ITEMSLOT_TRIPLE_MUSHROOM, 5
.set ITEMSLOT_LIGHTNING, 8
.set ITEMSLOT_BULLET_BILL, 0xF
.set ITEMSLOT_NONE, 0x14

mr r31, r3 # Original instruction

cmpwi r31, ITEMSLOT_MUSHROOM
beq replace

cmpwi r31, ITEMSLOT_TRIPLE_MUSHROOM
beq replace

cmpwi r31, ITEMSLOT_LIGHTNING
blt end

cmpwi r31, ITEMSLOT_BULLET_BILL
bgt end

replace:
li r31, ITEMSLOT_NONE

end:
