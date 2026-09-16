# Game: Mario Kart Wii
# Code: Lightning Only Shocks Players Ahead (Like Mario Kart World)
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 807A91F8
# PAL 807B7C58
# NTSC-J 807B72C4
# NTSC-K 807A6018

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'E' || region == 'e') # RMCE
    .set ptr_raceData, 0x809B8F68
	.set ptr_raceDirector, 0x809B8F70
.elseif (region == 'P' || region == 'p') # RMCP
    .set ptr_raceData, 0x809BD728
    .set ptr_raceDirector, 0x809BD730
.elseif (region == 'J' || region == 'j') # RMCJ
    .set ptr_raceData, 0x809BC788
    .set ptr_raceDirector, 0x809BC790
.elseif (region == 'K' || region == 'k') # RMCK
    .set ptr_raceData, 0x809ABD68
    .set ptr_raceDirector, 0x809ABD70
.else
    .err
.endif

.set GAMEMODE_BATTLE, 3
.set GAMEMODE_PUBLIC_BATTLE, 9

lwz r12, ptr_raceData@l (r31)
lwz r12, 0xB70(r12)
cmpwi r12, GAMEMODE_BATTLE
beq endOriginal

cmpwi r12, GAMEMODE_PUBLIC_BATTLE
blt setThunderCantAttack

endOriginal:
cmpw r27, r25
b end

setThunderCantAttack:
li r0, 0

rlwinm r11, r25,2,22,29
rlwinm r9,r27,2,22,29
lwz r12, ptr_raceDirector@l (r31)
lwz r12, 0xC (r12)
lwzx r10, r12, r11
lwzx r12, r12, r9
lbz r10, 0x20(r10)
lbz r12, 0x20(r12)
cmpw r10, r12
ble canThunderAttack

li r0, 1

canThunderAttack:
cmpwi r0, 0

end:
