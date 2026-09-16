# Game: Mario Kart Wii
# Code: Mii Heads on Minimap
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 807E18B4
# PAL  807EB160
# NTSC-J 807EA7CC
# NTSC-K 807D9520

.set PLAYERTYPE_CPU, 1

.set CHARACTER_MII_S_A_MALE, 0x18

lwz r4, 0x38 (r3)

lwz r3, 0x34 (r3) # Original instruction

cmpwi r4, PLAYERTYPE_CPU
beq end

li r3, CHARACTER_MII_S_A_MALE

end: