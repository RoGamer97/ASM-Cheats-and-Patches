# Game: Mario Kart Wii
# Code: Green Shell Character (Always Koopa Shell Lose Anim)
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names


# Force Koopa Troopa lose animation
# NTSC-U 807BD5D8
# PAL 807CC038
# NTSC-J 807CB6A4
# NTSC-K 807BA3F8

.set CHARACTER_KOOPA_TROOPA, 0xE
.set CHARACTER_ANIMATION_LOSE, 0xA


lwz r31, 0 (r3)
lwz r31, 0x7C (r31)
cmpwi r31, CHARACTER_KOOPA_TROOPA
bne end

li r4, CHARACTER_ANIMATION_LOSE

end:
mr r31, r4 # Original instruction



# Prevent Koopa Troopa throw animation
# NTSC-U 807C3DB0
# PAL 807D2810
# NTSC-J 807D1E7C
# NTSC-K 807C0BD0

.set CHARACTER_KOOPA_TROOPA, 0xE

lwz r0, 4 (r3) # Original instruction

lwz r3, 0x0 (r30)
lwz r3, 0x7C (r3)
cmpwi r3, CHARACTER_KOOPA_TROOPA
bne end

li r0, -1

end:
