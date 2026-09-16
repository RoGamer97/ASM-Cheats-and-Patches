# Game: Mario Kart Wii
# Code: Toyota Moving Forward
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# Local Player Only

# Prevent storing damage bit
# NTSC-U 805635E0
# PAL 80567960
# NTSC-J 805672E0
# NTSC-K 805559B8

lwz r6, 0x14 (r5)
andi. r6, r6, 2
bne end

stw r4, 8 (r5)

end:



# Prevent speed loss
# NTSC-U 80563664
# PAL 805679E4
# NTSC-J 80567364
# NTSC-K 80555A3C

lwz r4, 0 (r21)
lwz r4, 4 (r4)
lwz r4, 0x14 (r4)
andi. r4, r4, 2
bne end

stfs f31, 0x20 (r3)

end:


# Prevent many statuses cancel (like boost, standstill miniturbo etc)
# NTSC-U 8056361C
# PAL 8056799C
# NTSC-J 8056731C
# NTSC-K 805559F4

lwz r4, 0 (r3)
lwz r4, 4 (r4)
lwz r4, 0x14 (r4)
andi. r4, r4, 2
beqctrl

# Read damage type ID instead of damage bit for character damage anim
# NTSC-U 807BCCC4
# PAL 807CB724
# NTSC-J 807CAD90
# NTSC-K 807B9AE4

lwz r0, 8 (r4)

lwz r5, 0x14 (r4)
andi. r5, r5, 2
beq end

lwz r5, 0 (r30)
lwz r5, 0x2C (r5)
lwz r5, 0x1C (r5)
cmpwi r5, -1
beq end

ori r0, r0, 1

end:



# Read damage type ID instead of damage bit for minimap character damage animation
# NTSC-U 807E1AE0
# PAL 807EB38C
# NTSC-J 807EA9F8
# NTSC-K 807D974C

lwz r0, 8 (r3)

lwz r3, 0x14 (r3)
andi. r3, r3, 2
beq end

lwz r3, 0x1C8 (r31)
lwz r3, 0 (r3)
lwz r3, 0x2C (r3)
lwz r3, 0x1C (r3)
cmpwi r3, -1
beq end

ori r0, r0, 1

end:
























# Everyone version

# Prevent storing damage bit
# NTSC-U 805635E0
# PAL 
# NTSC-J 
# NTSC-K 
# Replace 'stw r4, 8(r5)' with 'nop' to avoid storing kart status with damage bit orr'd

# Prevent speed loss
# NTSC-U 80563664
# PAL 
# NTSC-J 
# NTSC-K 
# Replace 'stfs f31, 0x20(r3)' with 'nop' to avoid storing kart speed

# Prevent many statuses cancel (like boost)
# NTSC-U 8056361C
# PAL
# NTSC-J
# NTSC-K
# Replace 'bctrl' with 'nop' to avoid calling boost reset function

# Read damage type ID instead of damage bit for character damage anim
# NTSC-U 807BCCC4
# PAL 
# NTSC-J 
# NTSC-K 

lwz r0, 8 (r4)

lwz r5, 0 (r30)
lwz r5, 0x2C (r5)
lwz r5, 0x1C (r5)
cmpwi r5, -1
beq end

ori r0, r0, 1

end:



# Read damage type ID instead of damage bit for minimap character damage animation
# NTSC-U 7E1AE0
# PAL 
# NTSC-J 
# NTSC-K 

lwz r0, 8 (r3)