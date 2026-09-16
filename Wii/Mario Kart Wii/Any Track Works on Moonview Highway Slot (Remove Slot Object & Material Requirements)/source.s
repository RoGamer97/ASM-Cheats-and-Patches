# Game: Mario Kart Wii
# Code: Any Track Works on Moonview Highway Slot (Remove Slot Object & Material Requirements)
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names


# Material crash avoid 1
# NTSC-U 806C41F0
# PAL 806D2DC0
# NTSC-J 806D242C 
# NTSC-K 806C1168

li r25, -1 # Original instruction

lwz r22, 0xC8 (r31)
cmpwi r22, 0
bne end

mflr r22
addi r22, r22, 0x238
mtlr r22
blr       

end:



# Material crash avoid 2
# NTSC-U 806C5AA0
# PAL 806D4670
# NTSC-J 806D3CDC  
# NTSC-K 806C2A18

lwz r0, 0xB0 (r27) # Original instruction

lwz r3, 0xC8 (r27)
cmpwi r3, 0
bne end
mr r28, r0

end:



# Always allocate some material related thing
# NTSC-U 80785258
# PAL 8078E264
# NTSC-J 8078D8D0
# NTSC-K 8077C624
# Replace 'b 0x8078527C' (NTSC-U address for example) with 'nop' to avoid skipping over some material allocation