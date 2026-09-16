# Game: Mario Kart Wii
# Code: Enhanced Pause Menu (Time Trials Pause in VS & Battle)
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names


# Redirect pause option sections
# NTSC-U 805DDBF8
# PAL 806024D8
# NTSC-J 80601C4C
# NTSC-K 805F08F8

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'e' || region == 'E')
        .set ptr_raceData, 0x809B8F68
        .set ptr_menuData, 0x809BD508
.elseif (region == 'p' || region == 'P')
        .set ptr_raceData, 0x809BD728
        .set ptr_menuData, 0x809C1E38
.elseif (region == 'j' || region == 'J' )
        .set ptr_raceData, 0x809BC788
        .set ptr_menuData, 0x809C0E98
.elseif (region == 'k' || region == 'K' )
        .set ptr_raceData, 0x809ABD68
        .set ptr_menuData, 0x809B0478
.else
    .err
.endif

.set GAMEMODE_OFFLINE_VS, 1
.set GAMEMODE_TIME_TRIALS, 2

.set GAMETYPE_CPU_RACE, 5

.set SECTION_SINGLE_TT_CHANGE_CHARA, 0x49
.set SECTION_SINGLE_TT_CHANGE_COURSE, 0x4A
.set SECTION_SINGLE_VS_NEXT_RACE, 0x4B
.set SECTION_SINGLE_BT_NEXT_BATTLE, 0x4C


lwz r3, ptr_menuData@l (r6)
lwz r12, ptr_raceData@l (r6)
lwz r0, 0x1760 (r12)
cmpwi r0, GAMEMODE_TIME_TRIALS
beq end

cmpwi r4, SECTION_SINGLE_TT_CHANGE_CHARA
beq decreaseRaceNum

cmpwi r4, SECTION_SINGLE_TT_CHANGE_COURSE
bne end

li r4, SECTION_SINGLE_VS_NEXT_RACE

cmpwi r0, GAMEMODE_OFFLINE_VS
beq decreaseRaceNum

li r4, SECTION_SINGLE_BT_NEXT_BATTLE

decreaseRaceNum:
lwz r6, 0x98 (r3)
lwz r31, 0x60 (r6)
subi r31, r31, 1
stw r31, 0x60 (r6)

li r31, GAMETYPE_CPU_RACE
stw r31, 0x1764 (r12)

end:
mr r31, r5 # Original instruction


# Fix BackModel being Stop Watch when coming to character selection from VS/Battle pause
# NTSC-U 808304B0
# PAL 8084FAC4
# NTSC-J 8084F130
# NTSC-K 8083DE84

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

.set GAMEMODE_OFFLINE_VS, 1
.set GAMEMODE_TIME_TRIALS, 2

.set BACKMODEL_STOP_WATCH, 0
.set BACKMODEL_FLAG, 2
.set BACKMODEL_BALLOON, 3


li r4, BACKMODEL_STOP_WATCH # Original instruction

lis r5, ptr_raceData@ha
lwz r5, ptr_raceData@l (r5)
lwz r0, 0x1760 (r5)
cmpwi r0, GAMEMODE_TIME_TRIALS
beq end

lbz r5, 0x34 (r3)
cmpwi r5, 0
bne end

li r4, BACKMODEL_FLAG

cmpwi r0, GAMEMODE_OFFLINE_VS
beq end

li r4, BACKMODEL_BALLOON

end:


# Create Time Trials Pause Menu instead of VS/Battle Pause Menu
# NTSC-U 805FB7A4 805FB8E8 805FBA2C 
# PAL 8062C658 8062C79C 8062C8E0
# NTSC-J 8062BDA4 8062BEE8 8062C02C
# NTSC-K 8061AA50 8061AB94 8061ACD8
# Replace 'li r4, 0x18' and 'li r4, 0x19' with 'li r4, 0x19' (0x18 is VS pause, 0x1A is Battle pause, 0x19 is Time Trials pause)



# Replace VS/Battle Pause Menu with Time Trials Pause Menu instead
# NTSC-U 80602BE4 80602ABC
# PAL 80633A98 80633970
# NTSC-J 806331E4 806330BC
# NTSC-K 80621E90 80621D68
# Replace 'li r3, 0x18' with 'li r3, 0x19'



# Avoid storing Time Trials to mode when Changing Character - Does not interfer anything in actual Time Trials
# NTSC-U 80822BB8
# PAL 8083D618
# NTSC-J 8083CC84
# NTSC-K 8082B9D8
# Replace 'stw r4, 0x1760 (r3)' with 'nop' to prevent storing Time Trials to current mode



# Disable pause controller image 1
# NTSC-U 808375D8 
# PAL 80859068
# NTSC-J 808586D4
# NTSC-K 80847428
# Replace 'beq 0x808375EC' to 'b 0x80837DE0' (NTSC-U addresses for example) to skip creating controller images for VS/Battle images but keep other modes unaffected



# Disable pause controller image 2
# NTSC-U 808373A8 
# PAL 80858E38
# NTSC-J 808584A4
# NTSC-K 808471F8
# Replace 'cmpwi r3, 0x20' to 'b 0x808373E8' - Same scenario as previous code