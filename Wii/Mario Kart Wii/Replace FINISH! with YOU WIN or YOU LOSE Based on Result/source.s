# Game: Mario Kart Wii
# Code: Replace FINISH! with YOU WIN or YOU LOSE Based on Result
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 8083549C
# PAL 80856F2C
# NTSC-J 80856598
# NTSC-K 808452EC

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'E' || region == 'e')
        .set ptr_raceData, 0x809B8F68
        .set getPlayerResultType, 0x80783F98
.elseif (region == 'P' || region == 'p')
        .set ptr_raceData, 0x809BD728
        .set getPlayerResultType, 0x8078CFA4
.elseif (region == 'J' || region == 'j' )
        .set ptr_raceData, 0x809BC788
        .set getPlayerResultType, 0x8078C610
.elseif (region == 'K' || region == 'k' )
        .set ptr_raceData, 0x809ABD68
        .set getPlayerResultType, 0x8077B364
.else
        .err
.endif

.set BMG_FINISH, 0x4B5
.set BMG_YOU_WIN, 0x4B6
.set BMG_YOU_LOSE, 0x4B7

.set GAMEMODE_TIME_TRIAL, 2
.set GAMEMODE_BATTLE, 3
.set GAMEMODE_PRIVATE_VS, 7
.set GAMEMODE_PUBLIC_BATTLE, 9

.set RESULTTYPE_LOSE, 2


li r18, BMG_FINISH # Original instruction

lis r17, ptr_raceData@ha
lwz r17, ptr_raceData@l (r17)
lwz r12, 0xB70 (r17)

cmpwi r12, GAMEMODE_TIME_TRIAL
blt getPlayerResultType

cmpwi r12, GAMEMODE_PRIVATE_VS
beq getPlayerResultType

cmpwi r12, GAMEMODE_PUBLIC_VS
bne end

getPlayerResultType:
mr r16, r3
add r3, r17, r19
lbz r3, 0xB84 (r3)
lis r12, getPlayerResultType@ha
ori r12, r12, getPlayerResultType@l
mtctr r12
bctrl

li r18, BMG_YOU_WIN

cmpwi r3, RESULTTYPE_LOSE
bne restore

li r18, BMG_YOU_LOSE

restore:
mr r3, r16
clrlwi r4, r19, 0x18

end: