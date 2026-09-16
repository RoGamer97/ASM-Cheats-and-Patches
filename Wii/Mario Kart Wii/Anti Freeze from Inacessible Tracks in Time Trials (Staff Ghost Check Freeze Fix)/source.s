# Game: Mario Kart Wii
# Code: Anti Freeze from Inacessible Tracks in Time Trials (Staff Ghost Check Freeze Fix)

# NTSC-U 80551284 
# PAL 805504E8 
# NTSC-J 8054FE68
# NTSC-K 8053E540

li r0, 0

cmpwi r3, 0
beq end

lbz r0, 0x56 (r3) # Original instruction

end: