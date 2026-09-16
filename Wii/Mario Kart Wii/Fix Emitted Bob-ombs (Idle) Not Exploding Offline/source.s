# Game: Mario Kart Wii
# Code: Fix Emitted Bob-ombs (Idle) Not Exploding Offline
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 8079E164
# PAL 807A7170
# NTSC-J 807A67DC
# NTSC-K 80795530

.set ITEMTYPE_BOB_OMB, 9

lwz r4, 4 (r30)
cmpwi r4, ITEMTYPE_BOB_OMB
bne end

li r0, 0x12C # Original time (5 seconds)
stw r0, 0x1DC (r30)

lwz r0, -0xFC (r5)

end:
stw r0, 0x170 (r30) # Original instruction