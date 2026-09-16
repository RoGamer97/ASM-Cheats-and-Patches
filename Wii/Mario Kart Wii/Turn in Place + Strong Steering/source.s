# Game: Mario Kart Wii
# Code: Turn in Place

# NTSC-U 80575F38
# PAL 8057C79C
# NTSC-J 8057C11C 
# NTSC-K 8056A7F4

lwz r8, 8 (r4)

lwz r0, 0x14 (r4)
andi. r0, r0, 2
beq end

oris r8, r8, 0x200

end:
