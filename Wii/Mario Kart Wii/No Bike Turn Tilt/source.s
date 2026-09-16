# Game: Mario Kart Wii
# Code: No Bike Turn Tilt

# Local Player Only
# NTSC-U 805818FC
# PAL 80588120
# NTSC-J 80587AA0 
# NTSC-K 80576177

lwz r3, 4 (r3) # Original instruction

lwz r0, 0x14 (r3)
andi. r0, r0, 2
beq end # Not local player kart

lbz r0, 0xFD (r28)
cmpwi r0, 0
bne end

fsubs f2, f2, f2

end:


# Everyone
# NTSC-U 805818FC
# PAL 80588120
# NTSC-J 80587AA0 
# NTSC-K 80576177

lwz r3, 4 (r3) # Original instruction

lbz r0, 0xFD (r28)
cmpwi r0, 0
bne end

fsubs f2, f2, f2

end: