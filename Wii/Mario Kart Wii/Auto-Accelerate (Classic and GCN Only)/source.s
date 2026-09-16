# Game: Mario Kart Wii
# Code: Auto-Accelerate (Classic and GCN Only)
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names


# GCN Controller
# NTSC-U 8051BE14
# PAL 80520288
# NTSC-J 8051FC08
# NTSC-K 8050E2AC

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'E' || region == 'e')
    .set ptr_raceDirector, 0x809B8F70
.elseif (region == 'P' || region == 'p')
    .set ptr_raceDirector, 0x809BD730
.elseif (region == 'J' || region == 'j')
    .set ptr_raceDirector, 0x809BC790
.elseif (region == 'K' || region == 'k')
    .set ptr_raceDirector, 0x809ABD70
.else
    .err
.endif

.set RACESTATE_RACE, 2

.set BUTTONBIT_A_GCN, 1 << 8 # 0x100
.set BUTTONBIT_B_GCN, 1 << 9 # 0x200


lhz r4, 0xA8 (r28) # Original instruction

lis r12, ptr_raceDirector@ha
lwz r12, ptr_raceDirector@l (r12)
cmpwi r12, 0
beq end

lwz r12, 0x28 (r12)
cmpwi r12, RACESTATE_RACE
bne end

andi. r6, r5, BUTTONBIT_B_GCN
bne end

ori r5, r5, BUTTONBIT_A_GCN

end:



# Classic Controller
# NTSC-U 8051B16C
# PAL 8051F5E0
# NTSC-J 8051EF60
# NTSC-K 8050D604

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling! Lowercase letters can also be used.

.if (region == 'E' || region == 'e')
    .set ptr_raceDirector, 0x809B8F70
    .set ptr_menuData, 0x809BD508
.elseif (region == 'P' || region == 'p')
    .set ptr_raceDirector, 0x809BD730
    .set ptr_menuData, 0x809C1E38
.elseif (region == 'J' || region == 'j')
    .set ptr_raceDirector, 0x809BC790
    .set ptr_menuData, 0x809C0E98
.elseif (region == 'K' || region == 'k')
    .set ptr_raceDirector, 0x809ABD70
    .set ptr_menuData, 0x809B0478
.else
    .err # Invalid Region
.endif

.set RACESTATE_RACE, 2

.set BUTTONBIT_A_CLASSIC, 1 << 4 # 0x10
.set BUTTONBIT_B_CLASSIC, 1 << 6 # 0x40


lhz r4, 0x8F8 (r28) # Original instruction

lis r11, ptr_raceDirector@ha
lwz r12, ptr_raceDirector@l (r11)
cmpwi r12, 0
beq end

lwz r12, 0x28 (r12)
cmpwi r12, RACESTATE_RACE
bne end

lwz r12, ptr_menuData@l (r11)
lwz r12, 0 (r12)
lbz r12, 0x389 (r12)
cmpwi r12, 0
bne end

andi. r7, r3, BUTTONBIT_B_CLASSIC
bne end

ori r3, r3, BUTTONBIT_A_CLASSIC

end:
