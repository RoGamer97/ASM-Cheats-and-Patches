# Game: Mario Kart Wii
# Code: Unrestricted Drift Direction

# NTSC-U 8057422C
# PAL 8057AA90
# NTSC-J 8057A410
# NTSC-K 80568AE8

.set KARTFLAGS_LOCAL, 1 << 1 # 2

lwz r12, 0x14 (r3)
lwz r3, 4 (r3)
andi. r12, r12, KARTFLAGS_LOCAL
beq end

li r3, 0

end: