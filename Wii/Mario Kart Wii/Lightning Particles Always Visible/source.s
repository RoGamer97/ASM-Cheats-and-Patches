# Game: Mario Kart Wii
# Code: Lightning Particles Always Visible

# Lightning Bolt (Local Player Only)
# NTSC-U 80699794
# PAL 8069DC1C
# NTSC-J 8069D288
# NTSC-K 8068BFC4

li r6, 0

lwz r12, 0x118 (r3)
lwz r12, 0 (r12)
lwz r12, 4 (r12)
lwz r12, 0x14 (r12)
andi. r12, r12, 2
beq end # Not local player kart

li r6, 1

end:


# Lightning Sparkles (Local Player Only)
# NTSC-U 80699A84
# PAL 8069DF0C
# NTSC-J 8069D578
# NTSC-K 8068C2B4

li r5, 0

lwz r12, 0x118 (r28)
lwz r12, 0 (r12)
lwz r12, 4 (r12)
lwz r12, 0x14 (r12)
andi. r12, r12, 2
beq end # Not local player kart

li r4, 1
li r5, 1

end: