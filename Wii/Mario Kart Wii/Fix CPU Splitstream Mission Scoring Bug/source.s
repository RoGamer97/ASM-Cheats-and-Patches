# Game: Mario Kart Wii
# Code: Fix CPU Slipstream Mission Scoring Bug

# NTSC-U 80580BA0
# PAL 805873C4
# NTSC-J 80586D44
# NTSC-K 8057541C

.set KARTFLAGS_LOCAL_PLAYER, 1 << 1 # 2

.set RACERULE_GP, 0

lwz r0, 0xB70 (r5) # Original instruction

lwz r12, 0 (r27)
lwz r12, 4 (r12)
lwz r12, 0x14 (r12)
andi. r12, r12, KARTFLAGS_LOCAL_PLAYER
bne end

li r0, RACERULE_GP

end: