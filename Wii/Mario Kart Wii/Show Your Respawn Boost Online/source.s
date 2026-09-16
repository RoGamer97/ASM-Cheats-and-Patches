# Game: Mario Kart Wii
# Code: Show Your Respawn Boost Online
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 8057B5DC and 8057B84C
# PAL 80581E40 and 805820B0
# NTSC-J 805817C0 and 80581A30
# NTSC-K 8056FE98 and 80570108

lwz r4, 0 (r3)
lwz r4, 0x3C (r4)
cmpwi r4, 0
beq end

lwz r4, 0x10 (r4)
lwz r5, 0x10 (r4)
xoris r5, r5, 0x4000
stw r5, 0x10 (r4)

end:
li r4, 3 # Original instruction

