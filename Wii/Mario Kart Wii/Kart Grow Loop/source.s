# Game: Mario Kart Wii
# Code: Kart Grow Loop
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# Does float calculations with ints which usually is bad, but works for this

lwz r0, 8 (r4) # Original instruction

lwz r12, 0x14 (r4)
andi. r12, r12, 2
beq end # Not local player kart
 
lhz r12, 0x160 (r3)
addi r12, r12, 8
cmpwi r12, 0x4040
blt end

li r12, 0x3F00

end:
sth r12, 0x160 (r3)
