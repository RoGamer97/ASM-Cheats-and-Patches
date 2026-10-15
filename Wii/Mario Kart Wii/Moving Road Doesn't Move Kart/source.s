# Game: Mario Kart Wii
# Code: Moving Road Doesn't Move Kart

# Waterfall
# NTSC-U 80591614
# PAL 80597E38
# NTSC-J 805977B8
# NTSC-K 80585E90

.set KARTFLAGS_LOCAL_PLAYER, 1 << 1 # 2

lwz r0, 8 (r3) # Original instruction

lwz r3, 0x14 (r3)
andi. r3, r3, KARTFLAGS_LOCAL_PLAYER
beq end

lis r0, 0x8000 # Star flag

end:



# Conveyer Belt and Escalator
# NTSC-U 80591344
# PAL 80597B68
# NTSC-J 805974E8
# NTSC-K 80585BC0

.set KARTFLAGS_LOCAL_PLAYER, 1 << 1 # 2

lwz r0, 8 (r4) # Original instruction

lwz r3, 0x14 (r4)
andi. r3, r3, KARTFLAGS_LOCAL_PLAYER
beq end

lis r0, 0x8000 # Star flag

end: