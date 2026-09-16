# Game: Mario Kart Wii
# Code: Play Invalid Sound on Replaced Item Decide
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 8078F140
# PAL 8079814C
# NTSC-J 807977B8
# NTSC-K 8078650C

.set SOUND_ITEM_DECIDE, 0xE3

li r4, SOUND_ITEM_DECIDE
mulli r30, r30, 0x10
add r4, r4, r30
