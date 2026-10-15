# Game: Mario Kart Wii
# Code: No Speed Decrease When Shocked or Squished
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 80575570
# PAL 8057BDD4
# NTSC-J 8057B754
# NTSC-K 80569E2C

.set KARTFLAGS_LOCAL, 1 << 1 # 2

lwz r12, 0x14 (r4)
andi. r12, r12, KARTFLAGS_LOCAL
beq end

lfs f27, 0x90 (r30)

end:
lwz r12, 0xC (r29) # Original instruction