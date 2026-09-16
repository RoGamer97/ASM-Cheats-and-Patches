# Game: Mario Kart Wii
# Code: Anti Freeze from Cataquack Without Sea Object (poihana without Psea or venice_nami Fix)

# NTSC-U 808178CC
# PAL 8082B3E0
# NTSC-J 8082AA4C
# NTSC-K 808197A0 


fsubs f0, f0, f0

cmpwi r3, 0
beqlr

lfs f0, 0x34 (r3) # Original instruction