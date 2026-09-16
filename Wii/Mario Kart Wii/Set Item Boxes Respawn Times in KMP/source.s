# Game: Mario Kart Wii
# Code: Set Item Boxes Respawn Times in KMP
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 80814DA4
# PAL 808288B8
# NTSC-J 80827F24
# NTSC-K 80816C78

lwz r5, 0xB8 (r3) # Original instruction

lwz r12, 0xA0 (r3)
cmpwi r12, 0
beq end

lwz r12, 0 (r12)
lhz r12, 0x32 (r12)
cmpwi r12, 0
beq end

cmplwi r12, 0xFFFF
bne setRespawnTime

li r4, 0

setRespawnTime:
mr r5, r12

end: