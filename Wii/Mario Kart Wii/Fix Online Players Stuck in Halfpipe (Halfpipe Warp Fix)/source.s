# Game: Mario Kart Wii
# Code: Fix Online Players Stuck in Halfpipe (Halfpipe Warp Fix)

# NTSC-U 80585734
# PAL 8058BF58
# NTSC-J 8058B8D8
# NTSC-K 80579FB0

.set OOB_TIMER_FOR_CLEAR, 86

lwz r11, 8 (r4) # Replicate original instruction (but r11 instead of r4)
rlwinm. r12, r11, 0, 21, 21
beq end # Not in a halfpipe

lha r0, 0x56 (r31)
cmpwi r0, OOB_TIMER_FOR_CLEAR
blt end

rlwinm r11, r11, 0, 22, 20
stw r11, 8 (r4)

end:
mr r4, r11
