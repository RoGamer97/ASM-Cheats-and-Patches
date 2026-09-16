# Game: Mario Kart Wii
# Code: Moving Road Doesn't Move Kart

# Waterfall
# NTSC-U 80591614
# PAL 80597E38
# NTSC-J 805977B8
# NTSC-K 80585E90

lwz r0, 8 (r3) # Original instruction

lwz r3, 0x14 (r3)
andi. r3, r3, 2
beq end # Not local player kart

lis r0, 0x8000 # Star flag

end:



# Conveyer Belt and Escalator
# NTSC-U 80591344
# PAL 80597B68
# NTSC-J 805974E8
# NTSC-K 80585BC0

lwz r0, 8 (r4) # Original instruction

lwz r3, 0x14 (r4)
andi. r3, r3, 2
beq end # Not local player kart

lis r0, 0x8000 # Star flag

end: