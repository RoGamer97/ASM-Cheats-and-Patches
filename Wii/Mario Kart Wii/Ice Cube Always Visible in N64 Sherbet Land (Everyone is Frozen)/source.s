# Game: Mario Kart Wii
# Code: Ice Cube Always Visible in N64 Sherbet Land/Everyone is Frozen
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names


# Local Player Only
# NTSC-U 80691158
# PAL 806955E0
# NTSC-J 80694C4C
# NTSC-K 80683988

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

.set COURSE_N64_SHERBET_LAND, 0x1B


li r0, 0 # Original instruction

lis r12, ptr_raceData@ha
lwz r12, ptr_raceData@l (r12)
lwz r12, 0xB68 (r12)
cmpwi r12, COURSE_N64_SHERBET_LAND
bne end

lwz r12, 0x118 (r31)
lwz r12, 0 (r12)
lwz r12, 4 (r12)
lwz r12, 0x14 (r12)
andi. r12, r12, 2
beq end

stb r0, 0x794 (r31)

li r0, 1
stb r0, 0x7B (r31)

end:



# Everyone
# NTSC-U 80691158
# PAL 806955E0
# NTSC-J 80694C4C
# NTSC-K 80683988

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

.set COURSE_N64_SHERBET_LAND, 0x1B


li r0, 0 # Original instruction

lis r12, ptr_raceData@ha
lwz r12, ptr_raceData@l (r12)
lwz r12, 0xB68 (r12)
cmpwi r12, COURSE_N64_SHERBET_LAND
bne end

stb r0, 0x794 (r31)

li r0, 1
stb r0, 0x7B (r31)

end:



# Prevent ice from breaking when landing from Lakitu drop
# NTSC-U 8057B69C
# PAL 80581F00
# NTSC-J 80581880
# NTSC-K 8056FF58

# Replace 'bl 0x806AE4DC' (NTSC-U) with 'nop' to skip ice break function call