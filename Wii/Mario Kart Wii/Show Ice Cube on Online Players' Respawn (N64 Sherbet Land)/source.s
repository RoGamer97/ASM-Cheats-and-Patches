# Game: Mario Kart Wii
# Code: Show Ice Cube on Online Players' Respawn (N64 Sherbet Land)
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 8069115C
# PAL 806955E4
# NTSC-J 80694C50
# NTSC-K 8068398C

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'e' || region == 'E')
        .set ptr_raceData, 0x809B8F68
		.set ptr_playerBase, 0x809BD110
		.set KartIce__break, 0x806AE4DC
.elseif (region == 'p' || region == 'P')
        .set ptr_raceData, 0x809BD728
		.set ptr_playerBase, 0x809C18F8
		.set KartIce__break, 0x806B2964
.elseif (region == 'j' || region == 'J' )
        .set ptr_raceData, 0x809BC788
		.set ptr_playerBase, 0x809C0958
		.set KartIce__break, 0x806B1FD0
.elseif (region == 'k' || region == 'K' )
        .set ptr_raceData, 0x809ABD68
		.set ptr_playerBase, 0x809AFF38
		.set KartIce__break, 0x806A0D0C
.else
    .err
.endif

.set COURSE_N64_SHERBET_LAND, 0x1B

# Note: Ice breaks when player touches the ground or sends the "landed from Lakitu" flag


lis r12, ptr_raceData@ha
lwz r11, ptr_raceData@l (r12)
lwz r11, 0xB68 (r11)
cmpwi r11, COURSE_N64_SHERBET_LAND
bne end

lwz r12, 0x118 (r31)
lwz r11, 0 (r12)
lwz r11, 4 (r11)
lwz r11, 0x14 (r11)
andi. r10, r11, 8
beq end # Not net receive kart

andi. r11, r11, 0x1000
beq isJugemHang

lbz r0, 0x7B (r31)
cmpwi r0, 0
beq end

mr r3, r31
lis r12, KartIce__break@h
ori r12, r12, KartIce__break@l
mtctr r12
bctrl
b end

isJugemHang:
lwz r12, 0x50 (r12)
lwz r12, 0xC4 (r12)
andi. r12, r12, 0x400
beq end

li r0, 1
stb r0, 0x7B (r31)

end:
stb r0, 0x69 (r31) # Original instruction