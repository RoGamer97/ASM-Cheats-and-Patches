# Game: Mario Kart Wii
# Code: Display Unknown Country Flag for Regions Without Flag


# NTSC-U 805CEAC8
# PAL 805E48A4 
# NTSC-J 805E4180
# NTSC-K 805D2A40 

bne end

bl blankFlagString

.string "flag_b"
.balign 4

blankFlagString:
mflr r3
lwz r4, 0 (r3)
stw r4, 0x28 (sp)
lwz r4, 4 (r3)
stw r4, 0x2C (sp)

end:


# NTSC-U 805CF084
# PAL 805E4E60
# NTSC-J 805E473C
# NTSC-K 805D2FFC

bne end

bl blankFlagString

.string "flag_b"
.balign 4

blankFlagString:
mflr r3
lwz r4, 0 (r3)
stw r4, 0x10 (sp)
lwz r4, 4 (r3)
stw r4, 0x14 (sp)

end:


# NTSC-U 805CEC20
# PAL 805E49FC 
# NTSC-J 805E42D8
# NTSC-K 805D2B98

bne end

bl blankFlagString

.string "flag_b"
.balign 4

blankFlagString:
mflr r3
lwz r4, 0 (r3)
stw r4, 0x20 (sp)
lwz r4, 4 (r3)
stw r4, 0x24 (sp)

end:

# NTSC-U 805CEDF0
# PAL 805E4BCC 
# NTSC-J 805E44A8
# NTSC-K 805D2D68

bne end

bl blankFlagString

.string "flag_b"
.balign 4

blankFlagString:
mflr r3
lwz r4, 0 (r3)
stw r4, 0x18 (sp)
lwz r4, 4 (r3)
stw r4, 0x1C (sp)

end: