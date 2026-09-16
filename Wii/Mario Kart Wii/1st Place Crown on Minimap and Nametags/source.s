# Game: Mario Kart Wii
# Code: 1st Place Crown on Minimap and Nametags
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names


# 1st Place Crown on Minimap
# NTSC-U 807E2130
# PAL 807EB9DC 
# NTSC-J 807EB048
# NTSC-K 807D9D9C

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'e' || region == 'E')
		.set getPaneByName, 0x805D1C7C
        .set ptr_raceData, 0x809B8F68
		.set ptr_raceDirector, 0x809B8F70
.elseif (region == 'p' || region == 'P')
		.set getPaneByName, 0x805E8368
        .set ptr_raceData, 0x809BD728
		.set ptr_raceDirector, 0x809BC790
.elseif (region == 'j' || region == 'J' )
		.set getPaneByName, 0x805E7C44
        .set ptr_raceData, 0x809BC788
		.set ptr_raceDirector, 0x809BC790
.elseif (region == 'k' || region == 'K' )
		.set getPaneByName, 0x805D6504
        .set ptr_raceData, 0x809ABD68
		.set ptr_raceDirector, 0x809ABD70
.else
        .err
.endif

.set GAMEMODE_TIME_TRIAL, 2
.set GAMEMODE_BATTLE, 3
.set GAMEMODE_PRIVATE_VS, 7
.set GAMEMODE_PUBLIC_BATTLE, 9
.set GAMEMODE_PRIVATE_BATTLE, 0xA


addi r3, r28, 0xA8
bl crownString

.string "crown"
.balign 4

crownString:
mflr r4

lis r12, getPaneByName@h
ori r12, r12, getPaneByName@l 
mtctr r12
bctrl
cmpwi r3, 0
beq end

lis r12, ptr_raceData@ha
lwz r11, ptr_raceData@l (r12)

lwz r12, ptr_raceDirector@l (r12)
lwz r12, 0xC (r12)
lbz r10, 0x1B4 (r28)
mulli r10, r10, 4
lwzx r12, r12, r10

li r0, 0

lbz r10, 0x20 (r12)
cmpwi r10, 1
bne storeVisibility

lwz r11, 0xB70 (r11)
cmpwi r11, GAMEMODE_TIME_TRIAL
blt setVisible

cmpwi r11, GAMEMODE_BATTLE
beq hasEnoughPoints

cmpwi r11, GAMEMODE_PRIVATE_VS
blt end

cmpwi r11, GAMEMODE_PUBLIC_BATTLE
blt setVisible

hasEnoughPoints:
lhz r12, 0x22 (r12)
cmpwi r12, 3
blt storeVisibility

setVisible:
li r0, 1

storeVisibility:
stb r0, 0xBB (r3)

lwz r12, 0x1B8 (r28)
lbz r12, 0xB8 (r12)
stb r12, 0xB8 (r3)

end:
addi r11, sp, 0xB0 # Original instruction



# 1st Place Crown on Nametags
# NTSC-U 807E66E8
# PAL 807F0D10
# NTSC-J 807F037C
# NTSC-K 807DF0D0

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'e' || region == 'E')
		.set getPaneByName, 0x805D1C7C
        .set ptr_raceData, 0x809B8F68
		.set ptr_raceDirector, 0x809B8F70
.elseif (region == 'p' || region == 'P')
		.set getPaneByName, 0x805E8368
        .set ptr_raceData, 0x809BD728
		.set ptr_raceDirector, 0x809BC790
.elseif (region == 'j' || region == 'J' )
		.set getPaneByName, 0x805E7C44
        .set ptr_raceData, 0x809BC788
		.set ptr_raceDirector, 0x809BC790
.elseif (region == 'k' || region == 'K' )
		.set getPaneByName, 0x805D6504
        .set ptr_raceData, 0x809ABD68
		.set ptr_raceDirector, 0x809ABD70
.else
        .err
.endif

.set GAMEMODE_TIME_TRIAL, 2
.set GAMEMODE_BATTLE, 3
.set GAMEMODE_PRIVATE_VS, 7
.set GAMEMODE_PUBLIC_BATTLE, 9
.set GAMEMODE_PRIVATE_BATTLE, 0xA

addi r3, r31, 0xA8
bl crownString

.string "crown"
.balign 4

crownString:
mflr r4

lis r12, getPaneByName@h
ori r12, r12, getPaneByName@l 
mtctr r12
bctrl
cmpwi r3, 0
beq end

lis r12, ptr_raceData@ha
lwz r11, ptr_raceData@l (r12)

lwz r12, ptr_raceDirector@l (r12)
lwz r12, 0xC (r12)
lwz r10, 0x178 (r31)
mulli r10, r10, 4
lwzx r12, r12, r10

li r0, 0

lbz r10, 0x20 (r12)
cmpwi r10, 1
bne storeVisibility

lwz r11, 0xB70 (r11)
cmpwi r11, GAMEMODE_TIME_TRIAL
blt setVisible

cmpwi r11, GAMEMODE_BATTLE
beq hasEnoughPoints

cmpwi r11, GAMEMODE_PRIVATE_VS
blt end

cmpwi r11, GAMEMODE_PUBLIC_BATTLE
blt setVisible

hasEnoughPoints:
lhz r12, 0x22 (r12)
cmpwi r12, 3
blt storeVisibility

setVisible:
li r0, 1

storeVisibility:
stb r0, 0xBB (r3)

# End
end:
lwz r0, 0x44 (sp) # Original instruction