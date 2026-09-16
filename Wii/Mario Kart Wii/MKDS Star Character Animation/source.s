# Game: Mario Kart Wii
# Code: MKDS Star Character Animation
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 807BE87C
# PAL 807CD2DC
# NTSC-J 807CC948
# NTSC-K 807BB69C

.set CHARACTER_ANIMATION_WIN_1ST, 8


lhz r0, 0xF6 (r31) # Original instruction

lwz r12, 0 (r31)
lwz r12, 4 (r12)
lwz r12, 8 (r12)
andis. r12, r12, 0x8000
beq end

li r0, CHARACTER_ANIMATION_WIN_1ST
sth r0, 0xF6 (r31)

end: