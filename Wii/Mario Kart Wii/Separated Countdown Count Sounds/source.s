# Game: Mario Kart Wii
# Code: Plays different SFXs for each individual countdown number
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 80835D50
# PAL 808577E0
# NTSC-J 80856E4C
# NTSC-K 80845BA0

.set SOUND_POW_1, 0x11D
.set SOUND_POW_2, 0x11E
.set SOUND_POW_3, 0x11F

# Using POW SFX for source example

li r4, SOUND_POW_1 # 3

cmpwi r6, 1
blt end

li r4, SOUND_POW_2 # 2
beq end

li r4, SOUND_POW_3 # 1

end: