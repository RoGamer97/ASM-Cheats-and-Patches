# Game: Mario Kart Wii
# Code: Show Kart Status Effects on Minimap
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names


# Don't hide character icon when someone disconnects or ghost finishes Time Trials (Both versions)
# NTSC-U 807E19EC
# PAL 807EB298
# NTSC-J 807EA904
# NTSC-K 807D9658
b +0x34 -> skip DC and TT ghost checks


# Force everyone to use local player's minimap code (Fancy version only)
# NTSC-U 807E1CA4
# PAL 807EB550
# NTSC-J 807EABBC
# NTSC-K 807D9910
# li r0, 0 -> Force everyone to use local player's minimap code


# Force other players' to use their correct minimap code instead of local player (Fancy version only)
# NTSC-U 807E1E34
# PAL 807EB6E0
# NTSC-J 807EAD4C
# NTSC-K 807D9AA0

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

stfs f0, 0x48 (r3) # Original instruction

lis r5, ptr_raceData@ha
lbz r12, 0x1B4 (r28)
lwz r11, ptr_raceData@l (r5)
mulli r12, r12, 0xF0
add r11, r11, r12

lwz r11, 0x38 (r11)
cmpwi r11, 0
beq end

isWatchedPlayer:
cmpwi r29, 0
mflr r12
addi r12, r12, 0xA4
mtlr r12

gotoOtherPlayerFunc:
beqlr

end:



# Play character icon damage animation when burning out (Both versions)
# NTSC-U 807E1AE0
# PAL 807EB38C
# NTSC-J 807EA9F8
# NTSC-K 807D974C

lwz r0, 8 (r3) # Original instruction

andis. r12, r0, 4
beq end

ori r0, r0, 1

end:



# Lower star icon height if character icon is a mii (Fancy version only)
# NTSC-U 807E1904
# PAL 807EB1B0
# NTSC-J 807EA81C
# NTSC-K 807D9570

# Store to star icon Y translate

lwz r3, 0x1B8 (r30)
lis r4, 0xC020
stw r4, 0x614 (r3)

lis r4, 0x809C # Original instruction -> 0x809B for NTSC-K



# Kart Status Effects on Minimap (Fancy version) - Note that it stores to the custom pane's offsets directly
# NTSC-U 807E2120
# PAL 807EB9CC
# NTSC-J 807EB038
# NTSC-K 807D9D8C

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling! Lowercase letters can also be used.

.if (region == 'e' || region == 'E')
        .set ptr_raceData, 0x809B8F68
		.set ptr_playerBase, 0x809BD110
		.set ptr_menuData, 0x809BD508
.elseif (region == 'p' || region == 'P')
        .set ptr_raceData, 0x809BD728
		.set ptr_playerBase, 0x809C18F8
		.set ptr_menuData, 0x809C1E38
.elseif (region == 'j' || region == 'J' )
        .set ptr_raceData, 0x809BC788
		.set ptr_playerBase, 0x809C0958
		.set ptr_menuData, 0x809C0E98
.elseif (region == 'k' || region == 'K' )
        .set ptr_raceData, 0x809ABD68
        .set ptr_playerBase, 0x809AFF38
		.set ptr_menuData, 0x809B0478
.else
        .err
.endif


.set TEAM_RED, 0
.set TEAM_BLUE, 1
.set TEAM_NONE, 2

stwu sp, -0x80 (sp)
stmw r3, 8 (sp)

lis r3, ptr_menuData@ha
lwz r3, ptr_menuData@l (r3)
lwz r3, 0 (r3)
lbz r3, 0x389 (r3)
cmpwi r3, 0
bne end

addi r3, r28, 0xA8
bl starString

.string "star"
.balign 4

starString:
mflr r4

lis r12, getPaneByName@h
ori r12, r12, getPaneByName@l 
mtctr r12
bctrl
cmpwi r3, 0
beq end

mr r24, r3

addi r3, r28, 0xA8
bl killerString

.string "killer"
.balign 4

killerString:
mflr r4

lis r12, getPaneByName@h
ori r12, r12, getPaneByName@l 
mtctr r12
bctrl
cmpwi r3, 0
beq end

mr r25, r3

lis r12, ptr_raceData@ha
lwz r10, ptr_raceData@l (r12)
lwz r12, ptr_playerBase@l (r12)
lwz r12, 0x20 (r12)
lbz r11, 0x1B4 (r28)
mulli r27, r11, 0xF0
mulli r11, r11, 4
add r27, r10, r27
lwzx r12, r12, r11
lwz r6, 0 (r12)


bl iconValues

.float 0.8 	# Minumum kart X/Y size
.float 1.25 # Maximum kart X/Y size
.float 0.05 # To increase with kart Y size for squished icon
.float 3.5  # Star icon rotation speed
.float -360 # Maximum star icon rotation

iconValues:
mflr r8

lwz r10, 0x1B8 (r28)
lwz r29, 0x1BC (r28)
lwz r9, 0x1C0 (r28)
lwz r4, 0x1C4 (r28)

lfs f0, 0x44 (r10)
lfs f2, 0x44 (r9)
lfs f6, 0x48 (r9)
lfs f7, 0x48 (r10)

lwz r12, 0x28 (r6)
lfs f3, 0x164 (r12)
lfs f5, 0x168 (r12)

lfs f4, 4 (r8)
fcmpo cr0, f3, f4
ble isKartMaxYSize

fmr f3, f4

isKartMaxYSize:
fcmpo cr0, f5, f4
ble isVanish

fmr f5, f4

isVanish:
lwz r5, 4 (r6)
lwz r7, 0xC (r5)
andis. r0, r7, 0xC
bne isGesso

lfs f4, 0 (r8)
fcmpo cr0, f3, f4
bge isKartMinYSize

fmr f3, f4

isKartMinYSize:
fcmpo cr0, f5, f4
bge isGesso

andis. r0, r7, 1
bne squishKartMinYSize

lbz r12, -0x24 (r5)
cmpwi r12, 0
beq setKartMinYSize

lhz r12, -0x20 (r5)
cmpwi r12, 0x4200
bge setKartMinYSize

squishKartMinYSize:
lfs f1, 8 (r8)
fadds f4, f5, f1

setKartMinYSize:
fmr f5, f4

isGesso:
andis. r0, r7, 0x1000
li r0, 0xFFFFFFFF
beq storeColor

setColorBlack:
li r0, 0

storeColor:
stw r0, 0x149 (r10)
stb r0, 0x14D (r10)

lwz r12, 0x58 (r6)
lbz r12, 0x12 (r12)
cmpwi r12, 0
bne isKiller

li r0, 1
stb r0, 0x80 (r28)

isKiller:
andis. r0, r7, 0x800
li r0, 0
beq storeKillerVisibility

stb r0, 0xB8 (r9)
stb r0, 0xB8 (r29)

li r0, 1

lfs f3, 8 (r30)
fmr f5, f3

lfs f4, 0x40 (r4)
stfs f4, 0x254 (r10)

fsubs f4, f4, f4
stfs f4, 0x40 (r10)

storeKillerVisibility:
stb r0, 0xBB (r25)

xori r0, r0, 1
mulli r12, r0, 0xFF
stb r12, 0x14F (r10)

lha r12, 0xB8 (r10)
stb r12, 0xB8 (r24)
stb r12, 0xB8 (r25)
stb r12, 0x2A0 (r10) 

fmuls f2, f2, f3
fmuls f0, f0, f3
fmuls f6, f6, f5
fmuls f7, f7, f5

stfs f0, 0x44 (r10)
stfs f2, 0x44 (r29)
stfs f2, 0x44 (r9)
stfs f2, 0x44 (r4)

stfs f7, 0x48 (r10)
stfs f7, 0x48 (r29)
stfs f6, 0x48 (r9)
stfs f6, 0x48 (r4)

disableBlackOutlineAnimation:
lwz r11, 0x98 (r28)
lwz r11, 0x44 (r11)
lwz r11, 0 (r11)
lwz r11, 0xC (r11)
li r12, 0
stb r12, 0x30 (r11)
stb r12, 0xFC (r11)

lwz r12, 0x54 (r6)
lbz r9, 0x14 (r12)
lbz r7, 0x15 (r12)
lbz r11, 0x16 (r12)

stb r9, 0x149 (r29)
stb r9, 0x34D (r29)
stb r7, 0x14B (r29)
stb r7, 0x34F (r29)
stb r11, 0x14D (r29)
stb r11, 0x351 (r29)

isStar:
lwz r11, 0x8 (r5)
andis. r0, r11, 0x8000
li r0, 0
li r6, 0
beq resetStarIconRotation

isLocalPlayer:
lbz r11, 0xBB (r4)
cmpwi r11, 0
bne loadStarIconBlueColor

lfs f0, 0x18 (r12)
lfs f1, 0x88 (r30)
fmuls f0, f0, f1
fctiwz f0, f0
stfd f0, -8 (sp)
lwz r9, -4 (sp)

isStarFadeout:
lbz r11, 0x1E (r12)
cmpwi r11, 0
beq storeOutlineTransparency

lbz r9, 0x14 (r12)

storeOutlineTransparency:
stb r9, 0xB8 (r29)
stb r9, 0x2BC (r29)

loadStarIconBlueColor:
lbz r6, 0x14D (r24)

li r7, 0 # Color limit
li r9, -0xF # Decrease speed

lbz r11, 0x14E (r24)
cmpwi r11, 0
bne isColorLimit

li r7, 0xFF # Color limit
li r9, 0xF # Increase speed

isColorLimit:
cmpw r6, r7
beq flipFadeState

add r6, r6, r9
b storeFadeState

flipFadeState:
xori r11, r11, 1

storeFadeState:
stb r11, 0x14E (r24)

li r0, 1

stb r0, 0xBB (r29)
lwz r9, 0x1C0 (r28)
stb r0, 0xBB (r9)

li r31, 0

lfs f0, 0x40 (r24)
lfs f1, 0x10 (r8)
lfs f2, 0xC (r8)

fsubs f0, f0, f2

fcmpo cr0, f0, f1
bge storeStarIconRotation

resetStarIconRotation:
fsubs f0, f0, f0

storeStarIconRotation:
stfs f0, 0x40 (r24)

stb r0, 0xBB (r24)
stb r6, 0x14D (r24)


lis r12, ptr_raceData@ha
lwz r12, ptr_raceData@l (r12)
lwz r12, 0xB90 (r12)
andi. r12, r12, TEAM_NONE
beq end

li r4, 0xFF

lwz r0, 0xF4 (r27)
cmpwi r0, TEAM_BLUE
beq blueTeam
bgt end

stb r4, 0x141 (r24)
stb r4, 0x329 (r25)
stb r4, 0x331 (r25)
b storeKillerShadowVisibility

blueTeam:
stb r4, 0x145 (r24)
stb r4, 0x32D (r25)
stb r4, 0x335 (r25)

storeKillerShadowVisibility:
stb r4, 0x337 (r25)

li r4, 0x8C
stb r4, 0x1D6 (r25)

end:
mr r0, r31
lmw r3, 8 (sp)
addi sp, sp, 0x80
mr r31, r0

lfs f1, 0 (r30) # Original instruction


# Kart Status Effect on Minimap (Light version)
# NTSC-U 807E2120
# PAL 807EB9CC
# NTSC-J 807EB038
# NTSC-K 807D9D8C

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling! Lowercase letters can also be used.

.if (region == 'e' || region == 'E')
        .set ptr_raceData, 0x809B8F68
    .set ptr_playerBase, 0x809BD110
.elseif (region == 'p' || region == 'P')
        .set ptr_raceData, 0x809BD728
    .set ptr_playerBase, 0x809C18F8
.elseif (region == 'j' || region == 'J' )
        .set ptr_raceData, 0x809BC788
    .set ptr_playerBase, 0x809C0958
.elseif (region == 'k' || region == 'K' )
        .set ptr_raceData, 0x809ABD68
        .set ptr_raceData, 0x809AFF38
.else
        .err
.endif

lis r12, ptr_raceData@ha
lwz r10, ptr_raceData@l (r12)
lwz r12, ptr_playerBase@l (r12)
lwz r12, 0x20 (r12)
lbz r11, 0x1B4 (r28)
mulli r11, r11, 4
lwzx r12, r12, r11
lwz r6, 0 (r12)


bl iconValues

.float 0.8 	# Minumum kart X/Y size
.float 1.25 # Maximum kart X/Y size
.float 0.05 # To increase with kart Y size for squished icon

iconValues:
mflr r8

lwz r10, 0x1B8 (r28)
lwz r29, 0x1BC (r28)
lwz r9, 0x1C0 (r28)
lwz r4, 0x1C4 (r28)

lfs f0, 0x44 (r10)
lfs f2, 0x44 (r9)
lfs f6, 0x48 (r9)
lfs f7, 0x48 (r10)

lwz r12, 0x28 (r6)
lfs f3, 0x164 (r12)
lfs f5, 0x168 (r12)

lfs f4, 4 (r8)
fcmpo cr0, f3, f4
ble isKartMaxYSize

fmr f3, f4

isKartMaxYSize:
fcmpo cr0, f5, f4
ble isVanish

fmr f5, f4

isVanish:
lwz r5, 4 (r6)
lwz r7, 0xC (r5)
andis. r0, r7, 0xC
bne isGesso

lfs f4, 0 (r8)
fcmpo cr0, f3, f4
bge isKartMinYSize

fmr f3, f4

isKartMinYSize:
fcmpo cr0, f5, f4
bge isGesso

andis. r0, r7, 1
bne squishKartMinYSize

lbz r12, -0x24 (r5)
cmpwi r12, 0
beq setKartMinYSize

lhz r12, -0x20 (r5)
cmpwi r12, 0x4200
bge setKartMinYSize

squishKartMinYSize:
lfs f1, 8 (r8)
fadds f4, f5, f1

setKartMinYSize:
fmr f5, f4

isGesso:
andis. r0, r7, 0x1000
li r0, 0xFFFFFFFF
beq storeColor

setColorBlack:
li r0, 0

storeColor:
stw r0, 0x149 (r10)
stb r0, 0x14D (r10)

lwz r12, 0x58 (r6)
lbz r12, 0x12 (r12)
cmpwi r12, 0
bne scaleKartToIconSize

li r0, 1
stb r0, 0x80 (r28)

scaleKartToIconSize:
fmuls f2, f2, f3
fmuls f0, f0, f3
fmuls f6, f6, f5
fmuls f7, f7, f5

stfs f0, 0x44 (r10)
stfs f2, 0x44 (r29)
stfs f2, 0x44 (r9)
stfs f2, 0x44 (r4)

stfs f7, 0x48 (r10)
stfs f7, 0x48 (r29)
stfs f6, 0x48 (r9)
stfs f6, 0x48 (r4)

disableBlackOutlineAnimation:
lwz r11, 0x98 (r28)
lwz r11, 0x44 (r11)
lwz r11, 0 (r11)
lwz r11, 0xC (r11)
li r12, 0
stb r12, 0x30 (r11)
stb r12, 0xFC (r11)

lwz r12, 0x54 (r6)
lbz r9, 0x14 (r12)
lbz r10, 0x15 (r12)
lbz r11, 0x16 (r12)

stb r9, 0x149 (r29)
stb r9, 0x34D (r29)
stb r10, 0x14B (r29)
stb r10, 0x34F (r29)
stb r11, 0x14D (r29)
stb r11, 0x351 (r29)

isOutlineState:
lwz r11, 0x8 (r5)
andis. r0, r7, 0x800
bne setOutlineVisible
andis. r0, r11, 0x8000
beq end

isLocalPlayer:
lbz r11, 0xBB (r4)
cmpwi r11, 0
bne setOutlineVisible

lfs f0, 0x18 (r12)
lfs f1, 0x88 (r30)
fmuls f0, f0, f1
fctiwz f0, f0
stfd f0, -8 (sp)
lwz r9, -4 (sp)

isStarFadeout:
lbz r11, 0x1E (r12)
cmpwi r11, 0
beq storeOutlineTransparency

lbz r9, 0x14 (r12)

storeOutlineTransparency:
stb r9, 0xB8 (r29)
stb r9, 0x2BC (r29)

setOutlineVisible:
li r0, 1

stb r0, 0xBB (r29)
lwz r9, 0x1C0 (r28)
stb r0, 0xBB (r9)

li r31, 0

end:
lmw r3, 8 (sp)
addi sp, sp, 0x80 

lfs f1, 0 (r30) # Original instruction