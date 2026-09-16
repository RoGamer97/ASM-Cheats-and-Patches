# Game: Mario Kart Wii
# Code: Anti Late/Lag Start
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 8052E8E8
# PAL 80533430
# NTSC-J 80532DB0
# NTSC-K 80521488

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'e' || region == 'E')
        .set ptr_raceData, 0x809B8F68
.elseif (region == 'p' || region == 'P')
        .set ptr_raceData, 0x809BD728
.elseif (region == 'j' || region == 'J' )
        .set ptr_raceData, 0x809BC788
.elseif (region == 'k' || region == 'K' )
        .set ptr_raceData, 0x809ABD68
.else
    .err
.endif

.set GAMEMODE_PRIVATE_VS, 7
.set GAMEMODE_PUBLIC_VS, 8
.set GAMEMODE_PUBLIC_BATTLE, 9
.set GAMEMODE_PRIVATE_BATTLE, 0xA

# This code only executes when everyone has sent the "READY" event

lwz r12, ptr_raceData@l (r30)
lwz r12, 0xB70 (r12)
cmpwi r12, GAMEMODE_PRIVATE_VS
blt end

cmpwi r12, GAMEMODE_PRIVATE_BATTLE
bgt end

li r3, 1

end:
cmpwi r3, 0 # Original instruction
