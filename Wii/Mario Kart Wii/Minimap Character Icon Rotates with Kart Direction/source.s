# Game: Mario Kart Wii
# Code: Minimap Character Icon Rotates with Kart Direction v2
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names


# Everyone: Force local player icon to every player
# NTSC-U 807E1CA4
# PAL 807EB550
# NTSC-J 807EABBC
# NTSC-K 807D9910
# Replace 'lwz r0, 0x38 (r3)' with 'li r0, 0' (Force other players to use the local player's minimap icon so searchlight is calculated for everyone's icons)



# Everyone
# NTSC-U 807E1E30
# PAL 807EB6DC
# NTSC-J 807EAD48
# NTSC-K 807D9A9C

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.
.if (region == 'e' || region == 'E')
        .set ptr_raceData, 0x809B8F68
.elseif (region == 'p' || region == 'P')
        .set ptr_raceData, 0x809BD728
.elseif (region == 'j' || region == 'J' )
        .set ptr_raceData, 0x809bc788
.elseif (region == 'k' || region == 'K' )
        .set ptr_raceData, 0x809ABD68
.else
        .err
.endif


stfs f0, 0x34 (sp) # Original instruction

lis r5, ptr_raceData@ha

lwz r12, 0x1C4 (r28)
lfs f1, 0x40 (r12)

lwz r12, 0x1B8 (r28)
stfs f1, 0x40 (r12)
lwz r12, 0x1BC (r28)
stfs f1, 0x40 (r12)
lwz r12, 0x1C0 (r28)
stfs f1, 0x40 (r12)

lbz r12, 0x1B4 (r28)
lwz r11, ptr_raceData@l (r5)
mulli r12, r12, 0xF0
add r11, r11, r12

lwz r11, 0x38 (r11)
cmpwi r11, 0
beq end

cmpwi r29, 0
mflr r12
addi r12, r12, 0xA4
mtlr r12
beqlr

end:



# Local players only
# NTSC-U 807E2010
# PAL 807EB8BC
# NTSC-J 807EAF28
# NTSC-K 807D9C7C

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'e' || region == 'E')
        .set ptr_raceData, 0x809B8F68
.elseif (region == 'p' || region == 'P')
        .set ptr_raceData, 0x809BD728
.elseif (region == 'j' || region == 'J' )
        .set ptr_raceData, 0x809bc788
.elseif (region == 'k' || region == 'K' )
        .set ptr_raceData, 0x809ABD68
.else
        .err
.endif

fsubs f0, f0, f0

lwz r31, 0x1C4 (r28)
lbz r0, 0xBB (r31)
cmpwi r0, 0
beq storeCharacterRotation

lfs f0, 0x40 (r31)

storeCharacterRotation:
lwz r31, 0x1B8 (r28)
stfs f0, 0x40 (r31)
lwz r31, 0x1BC (r28)
stfs f0, 0x40 (r31)
lwz r31, 0x1C0 (r28)
stfs f0, 0x40 (r31)

li r31, 0 # Original instruction