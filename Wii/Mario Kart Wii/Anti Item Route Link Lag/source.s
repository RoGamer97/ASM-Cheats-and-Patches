# Game: Mario Kart Wii
# Code: Anti Item Route Link Lag
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 8056EFE4
# PAL 80573E34
# NTSC-J 805737B4
# NTSC-K 80561E8C

.set ITEMTYPE_RED_SHELL, 1
.set ITEMTYPE_BLUE_SHELL, 5


lfs f1, 0x48 (r29) # Original instruction

lwz r0, 4 (r29)
cmpwi r0, ITEMTYPE_RED_SHELL
beq isLagShell

cmpwi r0, ITEMTYPE_BLUE_SHELL
bne end

isLagShell:
lfs f2, 0x258 (r29)
lfs f0, 4 (r31)
fcmpo cr0, f2, f0
blt end

fsubs f1, f1, f1
stfs f1, 0x258 (r29)

lfs f1, 0x10 (r31)

end: