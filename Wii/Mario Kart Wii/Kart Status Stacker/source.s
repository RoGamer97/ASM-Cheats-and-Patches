# Game: Mario Kart Wii
# Code: Kart Status Stacker
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names


# WORK IN PROGRESS!!!!!!!!!!!!!!!!!!!!!!!!


# Star Stacker
# NTSC-U 80579A64
# PAL 805802C8
# NTSC-J 8057FC48
# NTSC-K 8056E320

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'e' || region == 'E')
        .set addr_starDurationTimer, 0x808B11F8
.elseif (region == 'p' || region == 'P')
        .set addr_starDurationTimer, 0x808B5AB8
.elseif (region == 'j' || region == 'J' )
        .set addr_starDurationTimer, 0x808B4C18
.elseif (region == 'k' || region == 'K' )
        .set addr_starDurationTimer, 0x808A3F30
.else
        .err
.endif


lha r0, addr_starDurationTimer@l (r4) # Original instruction

lha r12, 0x18A (r3)
add r0, r12, r0
sth r0, 0x278 (r3)



# Fix Star Offroad
# NTSC-U 80579A70
# PAL 805802D4
# NTSC-J 8057FC54
# NTSC-K 8056E32C
# Replace 'lha r4, 0x11F8 (r4)' with 'lha r4, 0x278 (r3)' (Replaces load of star duration timer with current star timer for offroad invulnerability check 
# Fixes issue where you are vulnerable to offroad after star timer passes original duration)



# Fix Star Offroad
# NTSC-U 80566B38 and 80566B54
# PAL 8056B988 and 8056B9A4
# NTSC-J 8056B308 and 8056B324
# NTSC-K 805599E0 and 805599FC
# Replace 'lha r6, 0xC (r5)' with 'lha r6, 0x0278 (r28)' (Replaces load of different star duration timer, stored to a weird location on course load, 
# with on use stacked star duration from padding)



# Mega Mushroom Stacker
# NTSC-U 8057A2E4
# PAL 80580B48
# NTSC-J 805804C8
# NTSC-K 8056EBA0

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'e' || region == 'E')
        .set addr_megaDurationTimer, 0x808B1104
.elseif (region == 'p' || region == 'P')
        .set addr_megaDurationTimer, 0x808B59C4
.elseif (region == 'j' || region == 'J' )
        .set addr_megaDurationTimer, 0x808B4B24
.elseif (region == 'k' || region == 'K' )
        .set addr_megaDurationTimer, 0x808A3E3C
.else
        .err
.endif


lha r0, addr_megaDurationTimer@l (r4) # Original instruction

lha r12, 0x194 (r3)
add r0, r12, r0



# Stack Bullet Bill Timer on Use
# NTSC-U 805B084C 
# PAL 8059B864
# NTSC-J 8059B1E4
# NTSC-K 805898BC

lwz r4, 0xC (r5) # Original instruction

andis. r12, r4, 0x800
beq end

lha r12, 0x126 (r29)
addi r12, r12, 0x1E0
sth r12, 0x126 (r29)

end:



# Reset Bullet Bill Stacked Timer on End
# NTSC-U 805B1118 
# PAL 8059C130
# NTSC-J 8059BAB0
# NTSC-K 8058A188

# Hooked at Bullet Bill end, which also executes when respawning

li r31, 0
stw r31, 0x124(r3)

mr r31, r3 # Original instruction



# Store Bullet Bill Fast End Bool to Padding
# NTSC-U 805B1D68  
# PAL 
# NTSC-J 
# NTSC-K 

stb r29, 0x125 (r31)
lha r3, 0 (r31) # Original instruction

# Prevent Bullet Bill Timer from Increase If Stacked Timer Left
# NTSC-U 805B0DE8  
# PAL 
# NTSC-J 
# NTSC-K 

lbz r11, 0x125 (r31)
mulli r11, r11, 2
addi r11, r11, 1

decrementStackedTimer:
lha r12, 0x126 (r31)
subc. r12, r12, r11
sth r12, 0x126 (r31)
bne end

storeKillerTimer:
sth r0, 0x12 (r31) # Original instruction

end: