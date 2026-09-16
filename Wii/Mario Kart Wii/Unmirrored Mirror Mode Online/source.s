# Game: Mario Kart Wii
# Code: Unmirrored Mirror Mode Online
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# Invert sent steering in Mirror Mode
# NTSC-U 80586860
# PAL 8058D084
# NTSC-J 8058CA04
# NTSC-K 8057B0DC

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling! Lowercase letters can also be used. 
# E for NTSC-U, P for PAL, J for NTSC-K and K for NTSC-K

.if (region == 'e' || region == 'E')
        .set ptr_menuData, 0x809BD508
.elseif (region == 'p' || region == 'P')
        .set ptr_menuData, 0x809C1E38
.elseif (region == 'j' || region == 'J' )
        .set ptr_menuData, 0x809C0E98
.elseif (region == 'k' || region == 'K' )
.        set ptr_menuData, 0x809B0478
.else
    .err
.endif

.set ROOM_ENGINECLASS_MIRROR, 3


lbz r0, 0x8C (sp) # Original instruction

lis r12, ptr_menuData@ha
lwz r12, ptr_menuData@l (r12)
lwz r12, 0x98 (r12)
lwz r12, 0x2D4 (r12)
cmpwi r12, ROOM_ENGINECLASS_MIRROR
bne end

subfic r0, r0, 0xE

end:


# Invert received steering in Mirror Mode
# NTSC-U 80583EA8
# PAL 8058A6CC
# NTSC-J 8058A04C
# NTSC-K 80578724

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling! Lowercase letters can also be used.

.if (region == 'e' || region == 'E')
        .set ptr_menuData, 0x809BD508
.elseif (region == 'p' || region == 'P')
        .set ptr_menuData, 0x809C1E38
.elseif (region == 'j' || region == 'J' )
        .set ptr_menuData, 0x809C0E98
.elseif (region == 'k' || region == 'K' )
.        set ptr_menuData, 0x809B0478
.else
    .err
.endif

.set ROOM_ENGINECLASS_MIRROR, 3


lbz r0, 0x74 (sp) # Original instruction

lis r12, ptr_menuData@ha
lwz r12, ptr_menuData@l (r12)
lwz r12, 0x98 (r12)
lwz r12, 0x2D4 (r12)
cmpwi r12, ROOM_ENGINECLASS_MIRROR
bne end

subfic r0, r0, 0xE

end:


# Avoid storing Mirror Mode bit in Mirror CC
# NTSC-U 8061DCEC 
# PAL 80651000
# NTSC-J 8065066C 
# NTSC-K 8063F318
# Replace 'beq 0x8061DD20' with 'bge 0x8061DD20' - the compare before this branch is "cmpwi r0, 2", which checks if CC is 150cc and jumps to set 150cc. Modify brach to branch if greater or equal to 2 to also jump if CC is Mirror