# Game: Mario Kart Wii
# Code: Play Character Icon Damage Anim When Burned Out
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 807E1AE0
# PAL 807EB38C
# NTSC-J 807EA9F8
# NTSC-K 807D974C


lwz r0, 8 (r3) # Original instruction

andis. r12, r0, 4
beq end

ori r0, r0, 1

end:
