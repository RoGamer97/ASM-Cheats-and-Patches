# Game: Mario Kart Wii
# Code: Turn in Air

# Turn in Air Part 1
# NTSC-U 8057418C
# PAL 8057A9F0
# NTSC-J 8057A370
# NTSC-K 80568A48

lwz r0, 4 (r4)

lwz r5, 0x14 (r4)
andi. r5, r5, 2
beq end

li r0, 0

end:


# Turn in Air Part 2
# NTSC-U 80576160
# PAL 8057C9C4
# NTSC-J 8057C344
# NTSC-K 8056AA1C

lwz r5, 0x14 (r4)
andi. r5, r5, 2
beq end

ori r8, r8, 0x8000

end:
rlwinm. r0, r8, 0, 16, 16

# Turn in Air Hop Fix
# NTSC-U 8057411C
# PAL 8057A980
# NTSC-J 8057A300
# NTSC-K 805689D8

lwz r0, 0x14 (r10)
andi. r0, r0, 2
beq end

li r11, 0

end:
rlwinm. r0, r11, 0, 12, 12


# Change Direction
# NTSC-U 80573A24
# PAL 8057A288
# NTSC-J 80579C08
# NTSC-K 805682E0

lwz r3, 0xC (r5)

lwz r0, 0x14 (r5)
andi. r0, r0, 2
beq end

oris r3, r3, 0x800

end: