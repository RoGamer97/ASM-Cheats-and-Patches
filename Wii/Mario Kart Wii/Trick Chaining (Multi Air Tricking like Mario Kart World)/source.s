# Game: Mario Kart Wii
# Code: Trick Chaining (Multi Air Tricking like Mario Kart World)
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# Allow tricking in halfpipes and while in a trick
# NTSC-U 8056F2FC
# PAL 80575B60
# NTSC-J 805754E0
# NTSC-K 80563BB8
# Replace andi. r0, r0, 0x461 with andi. r0, r0, 0x1 (Can trick in halfpipe and while in a trick but not in damage)



# Force trick
# NTSC-U address
# 8056F370 Replace bne 0x8056F3A8 with b 0x8056F37C # Skip second halfpipe, while in a trick and air timer checks and forces trick to happen - this will only run based if you can trick chain, look hook below



# NTSC-U 8056F2F0
# PAL 80575B54
# NTSC-J 805754D4
# NTSC-K 80563BAC

# lbz r5, 0x3A (r3) # Original instruction (Is trick button pressed)
# mr r6, r5 # Move value to r6, we need to use it later in the other hook and r5 is overwritten

# NTSC-U 8056F330
# PAL 80575B94
# NTSC-J 80575514
# NTSC-K 80563BEC

lwz r5, 0x1C (r4) # Original instruction

lwz r11, 4(r3)
lwz r11, 8(r11)
andi. r0, r11, 0x8040
beq resetTrickDelay

lbz r12, 0xDB (r31)
addi r12, r12, 1
cmpwi r12, 0x1E
bge calcTrickChain

stb r12, 0xDB (r31)

calcTrickChain:
mr r5, r6
cmpwi r12, 20
bge isTrickButton

cantTrick:
li r5, 0

isTrickButton:
cmpwi r5, 0
beq end

li r12, 1
stw r12, 0x74 (r4)

lwz r12, 4 (r3)
lwz r12, 8 (r12)
andi. r12, r12, 0x400
bne resetTrickDelay

li r12, 5 # Reset kart air timer to a specific one, the lower the value, more time to turn/change direction in air after trick - Max seems to be around 0x11
stw r12, 0x1C (r4)

resetTrickDelay:
li r12, 0
stb r12, 0xDB (r31)

end: