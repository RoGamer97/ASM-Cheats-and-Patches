# Game: Mario Kart Wii
# Code: Online Pause Menu (Quit Online Races/Battles)
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names


# Allow pausing online
# NTSC-U 80834D3C
# PAL 808567CC
# NTSC-J 80855E38
# NTSC-K 80844B8C
# Replace 'li r3, 1' with 'li r3, 0' to allow pausing online



# Create VS pause menu and Quit confirmation screen pages for online race. 
# All other modes (2P VS, 1-2P Battle, 1-2P Live View etc etc) will jump to here with branch 
# (15 first lines of the Gecko code branch to this address)
# NTSC-U 805FDE10
# PAL 8062ECC4
# NTSC-J 8062E410
# NTSC-K 8061D0BC

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'e' || region == 'E')
    .set createInitPage, 0x805F1E54
.elseif (region == 'p' || region == 'P')
    .set createInitPage, 0x80622D08
.elseif (region == 'j' || region == 'J' )
    .set createInitPage, 0x80622454
.elseif (region == 'k' || region == 'K' )
    .set createInitPage, 0x80611100
.else
    .err
.endif

.set PAGE_VS_RACE_PAUSE_MENU, 0x18
.set PAGE_QUIT_CONFIRMATION, 0x2C

mr r3, r31
li r4, PAGE_VS_RACE_PAUSE_MENU
lis r12, createInitPage@h
ori r12, r12, createInitPage@l
mtctr r12
bctrl

mr r3, r31
li r4, PAGE_QUIT_CONFIRMATION
lis r12, createInitPage@h
ori r12, r12, createInitPage@l
mtctr r12
bctrl

mr r3, r31 # Original instruction



# Replace invalid pause ID with VS pause ID for correct pause menu and avoid returning due to invalid ID 
# Covers all modes in one 
# NTSC-U 80834F54
# PAL 808569E4
# NTSC-J 80856050
# NTSC-K 80844DA4

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling! Lowercase letters can also be used.

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

.set PAGE_VS_RACE_PAUSE_MENU, 0x18

.set GAMEMODE_PRIVATE_VS, 7
.set GAMEMODE_PUBLIC_VS, 8
.set GAMEMODE_PUBLIC_BATTLE, 9
.set GAMEMODE_PRIVATE_BATTLE, 0xA

lis r12, ptr_raceData@ha
lwz r12, ptr_raceData@l (r12)
lwz r12, 0xB70 (r12)
cmpwi r12, GAMEMODE_PRIVATE_VS
blt end

cmpwi r12, GAMEMODE_PRIVATE_BATTLE
bgt end

li r3, PAGE_VS_RACE_PAUSE_MENU

end:
cmpwi r3, -1 # Original instruction



# Avoid closing connection when clicking "Quit" (Both quits from before and after Quit Confirmation). 
# When you click Quit, the game calls a function to close the connection causing you to disconnect and having to reconnect.
# So if you click Quit, you'd go to Quit Confirmation but you were already disconnected, so this has to be avoided.
# This hook makes it so the "Quit" button skips the disconnection. 
# It also skips it when clicking "Quit" on Quit COnfirmation so you don't disconnect and are forced to reconnect
# NTSC-U 80838820
# PAL 8085A2B0
# NTSC-J 8085991C
# NTSC-K 80848670

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling! Lowercase letters can also be used.

.if (region == 'e' || region == 'E')
        .set ptr_raceData, 0x809B8F68
    	.set ptr_RKNetController, 0x809BD918
.elseif (region == 'p' || region == 'P')
        .set ptr_raceData, 0x809BD728
    	.set ptr_RKNetController, 0x809C20D8
.elseif (region == 'j' || region == 'J' )
        .set ptr_raceData, 0x809BC788
   	 .set ptr_RKNetController, 0x809C1138
.elseif (region == 'k' || region == 'K' )
        .set ptr_raceData, 0x809ABD68
    	.set ptr_RKNetController, 0x809B0718
.else
    .err
.endif

.set GAMEMODE_PRIVATE_VS, 7
.set GAMEMODE_PUBLIC_VS, 8
.set GAMEMODE_PUBLIC_BATTLE, 9
.set GAMEMODE_PRIVATE_BATTLE, 0xA

lis r31, ptr_raceData@ha
lwz r31, ptr_raceData@l (r31)
lwz r31, 0xB70 (r31)
cmpwi r31, GAMEMODE_PRIVATE_VS
blt end

cmpwi r31, GAMEMODE_PRIVATE_BATTLE
bgt end

lis r31, ptr_RKNetController@ha
lwz r31, ptr_RKNetController@l (r31)

li r0, 0
stb r0, 0x38E (r3)
stb r0, 0x2755 (r31)

end:
lwz r31, 0xB8 (r3) # Original instruction



# Go to online main menu instead of single player menu and force disconnecting from match
# NTSC-U 808389CC
# PAL 8085A45C
# NTSC-J 80859AC8
# NTSC-K 8084881C

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'e' || region == 'E')
    .set disconnectFromMatch, 0x80652410
    .set ptr_RKNetController, 0x809BD918
	.set ptr_menuData, 0x809BD508
.elseif (region == 'p' || region == 'P')
    .set disconnectFromMatch, 0x80656898
    .set ptr_RKNetController, 0x809C20D8
	.set ptr_menuData, 0x809C1E38
.elseif (region == 'j' || region == 'J' )
    .set disconnectFromMatch, 0x80655F04
    .set ptr_RKNetController, 0x809C1138
	.set ptr_menuData, 0x809C0E98
.elseif (region == 'k' || region == 'K' )
    .set disconnectFromMatch, 0x80644BB0
    .set ptr_RKNetController, 0x809B0718
	.set ptr_menuData, 0x809B0478
.else
    .err
.endif

.set SECTION_MAIN_MENU_FROM_MENU, 0x41
.set SECTION_P1_WIFI, 0x55
.set SECTION_P2_WIFI, 0x5B


li r4, SECTION_MAIN_MENU_FROM_MENU # Original instruction

lis r5, ptr_RKNetController@ha
lwz r5, ptr_RKNetController@l (r5)
lwz r0, 0x28 (r5)
cmpwi r0, 0
beq end

mr r3, r5
lis r12, disconnectFromMatch@h
ori r12, r12, disconnectFromMatch@l
mtctr r12
bctrl

mr r3, r28
lwz r12, 0 (r28)

li r4, SECTION_P1_WIFI

lis r5, ptr_menuData@ha
lwz r5, ptr_menuData@l (r5)
lwz r5, 0x98 (r5)
lwz r5, 0x124 (r5)
cmpwi r5, 2
bne end

li r4, SECTION_P2_WIFI

end:



# Close Pause Menu on Race end
# NTSC-U 80838428
# PAL 80859EB8
# NTSC-J 80859524
# NTSC-K 80848278

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling! Lowercase letters can also be used.

.if (region == 'e' || region == 'E')
        .set ptr_raceData, 0x809B8F68
		.set ptr_raceDirector, 0x809B8F70
		.set RacePause_unpause, 0x80838608
.elseif (region == 'p' || region == 'P')
		.set ptr_raceDirector, 0x809BD730
        .set ptr_raceData, 0x809BD728
		.set RacePause_unpause, 0x80860100
.elseif (region == 'j' || region == 'J')
		.set ptr_raceDirector, 0x809BC790
        .set ptr_raceData, 0x809BC788
		.set RacePause_unpause, 0x8085F76C
.elseif (region == 'k' || region == 'K')
		.set ptr_raceDirector, 0x809ABD70
        .set ptr_raceData, 0x809ABD68
		.set RacePause_unpause, 0x8084E4C0
.else
    .err
.endif

.set GAMEMODE_PRIVATE_VS, 7
.set GAMEMODE_PUBLIC_VS, 8
.set GAMEMODE_PUBLIC_BATTLE, 9
.set GAMEMODE_PRIVATE_BATTLE, 0xA

.set RACESTATE_RACE, 2

lis r3, ptr_raceData@ha
lwz r12, ptr_raceData@l (r3)
lwz r12, 0xB70 (r12)
cmpwi r12, GAMEMODE_PRIVATE_VS
blt end

cmpwi r12, GAMEMODE_PRIVATE_BATTLE
bgt end

lwz r12, ptr_raceDirector@l (r3)
lwz r12, 0x28 (r12)
cmpwi r12, RACESTATE_RACE
ble end

mr r3, r31
lis r12, RacePause_unpause@h 
ori r12, r12, RacePause_unpause@l 
mtctr r12
bctrl

end:
lis r3, ptr_raceData@ha # Original instruction



# Don't allow race inputs in online pause
# NTSC-U 805170EC
# PAL 8051B560
# NTSC-J 8051AEE0
# NTSC-K 80509580

.set SECTION_P1_WIFI_VS, 0x68
.set SECTION_P2_WIFI_FRIEND_COIN, 0x77


lbz r0, 0x38B (r3) # Original instruction

lwz r12, 0 (r3)
cmpwi r12, SECTION_P1_WIFI_VS
blt end

cmpwi r12, SECTION_P2_WIFI_FRIEND_COIN
bgt end

li r0, 0

end:



# Prevent game stop/freeze/pause in online pause
# NTSC-U 8054EE2C
# PAL 80554E4C
# NTSC-J 805547CC
# NTSC-K 80542EA4

.set SECTION_P1_WIFI_VS, 0x68
.set SECTION_P2_WIFI_FRIEND_COIN, 0x77

lwz r12, 0 (r3)

lbz r3, 0x38B (r3) # Original instruction

cmpwi r12, SECTION_P1_WIFI_VS
blt end

cmpwi r12, SECTION_P2_WIFI_FRIEND_COIN
bgt end

li r3, 0

end:



# Sounds and music play in online pause
# NTSC-U 805F15A0
# PAL 80622454
# NTSC-J 80621BA0
# NTSC-K 8061084C

.set SECTION_P1_WIFI_VS, 0x68
.set SECTION_P2_WIFI_FRIEND_COIN, 0x77


lwz r3, 0 (r28) # Original instruction
cmpwi r3, SECTION_P1_WIFI_VS
blt end

cmpwi r3, SECTION_P2_WIFI_FRIEND_COIN
bgt end

li r3, 0

end:



# Allow pause open SFX in online pause (When preventing the game from freezing/stopping in pause, SFX no longer plays, only in Ghost Replay, so patch it to play)
# Has to do checks in weird way to avoid an issue where the pause open SFX plays after offline race/battle result screen
# NTSC-U 80837FD0
# PAL 80859A60
# NTSC-J 808590CC
# NTSC-K 80847E20

.set PAGE_VS_RACE_PAUSE_MENU, 0x18
.set PAGE_GHOST_REPLAY_PAUSE_MENU, 0x1F 


cmpwi r0, PAGE_VS_RACE_PAUSE_MENU
beq skipOriginal

cmpwi r0, PAGE_GHOST_REPLAY_PAUSE_MENU # Original instruction

skipOriginal:

# Allow pause close SFX in online pause (When preventing the game from freezing/stopping in pause, SFX no longer plays, only in Ghost Replay, so patch it to play)
# NTSC-U 808384D8
# PAL 80859F68
# NTSC-J 808595D4
# NTSC-K 80848328

.set PAGE_VS_RACE_PAUSE_MENU, 0x18
.set PAGE_GHOST_REPLAY_PAUSE_MENU, 0x1F 


cmpwi r0, PAGE_VS_RACE_PAUSE_MENU
beq skipOriginal

cmpwi r0, PAGE_GHOST_REPLAY_PAUSE_MENU # Original instruction

skipOriginal:

# Construct and show controller image in online pause part 1 (two parts are needed or else it'll crash)
# NTSC-U 8083739C
# PAL 80858E2C
# NTSC-J 80858498
# NTSC-K 808471EC


.set SECTION_GP, 0x1E
.set SECTION_P1_WIFI_VS, 0x68
.set SECTION_P2_WIFI_FRIEND_COIN, 0x77


lwz r3, 0 (r3) # Original instruction
cmpwi r3, SECTION_P1_WIFI_VS
blt end

cmpwi r3, SECTION_P2_WIFI_FRIEND_COIN
bgt end

li r3, SECTION_GP

end:



# Construct and show controller image in online pause part 2 (two parts are needed or else it'll crash)
# NTSC-U 808375C8
# PAL 80859058
# NTSC-J 808586C4
# NTSC-K 80847418

.set SECTION_GP, 0x1E
.set SECTION_P1_WIFI_VS, 0x68
.set SECTION_P2_WIFI_FRIEND_COIN, 0x77


lwz r0, 0 (r3)  # Original instruction
cmpwi r0, SECTION_P1_WIFI_VS
blt end

cmpwi r0, SECTION_P2_WIFI_FRIEND_COIN
bgt end

li r0, SECTION_GP

end:
