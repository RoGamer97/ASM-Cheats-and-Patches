# Game: Mario Kart Wii
# Code: Normal Turning During Wheelie

# Local Player Only
# NTSC-U 80581918
# PAL 8058813C
# NTSC-J 80587ABC
# NTSC-K 80576194

.set KARTFLAGS_LOCAL_PLAYER, 1 << 1 # 2

lwz r4, 0 (r30)
lwz r4, 4 (r4)
lwz r4, 0x14 (r4)
andi. r4, r4, KARTFLAGS_LOCAL_PLAYER
beq end

li r3, 0

end:
rlwinm. r0, r3, 0, 2, 2 # Original instruction