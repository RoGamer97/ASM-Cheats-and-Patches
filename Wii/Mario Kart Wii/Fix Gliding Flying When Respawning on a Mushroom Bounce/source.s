# Game: Mario Kart Wii
# Code: Fix Gliding/Flying When Respawning on a Mushroom Bounce
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 8057B45C
# PAL 80581CC0
# NTSC-J 80581640
# NTSC-K 8056FD18

.set KARTSTATUSBIT_MUSHROOM_BOUNCE, 1 << 6 # 0x40
.set KARTSTATUSBIT_LAKITU_DROP, 1 << 14	   # 0x4000


andi. r0, r6, (KARTSTATUSBIT_MUSHROOM_BOUNCE | KARTSTATUSBIT_LAKITU_DROP) 
cmpwi r0,  (KARTSTATUSBIT_MUSHROOM_BOUNCE | KARTSTATUSBIT_LAKITU_DROP)
beq end

rlwinm. r0, r6, 0,17,17 # Original instruction

end:
