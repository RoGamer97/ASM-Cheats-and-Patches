# Game: Mario Kart Wii
# Code: Fix CPU Slipstream Mission Scoring "Bug"

# NTSC-U 80580BC4
# PAL 805873E8
# NTSC-J 80586D68
# NTSC-K 80575440

lwz r12, 0 (r27)
lwz r12, 4 (r12)
lwz r12, 0x14 (r12)
andi. r12, r12, 2
bne skip # Not local player kart

stw r0, 8 (r4) # Original instruction

skip: