# Game: Mario Kart Wii
# Code: Clear Exhaust Pipe Boost Particle After Damage
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 80563138
# PAL 805674B8
# NTSC-J 80566E38
# NTSC-K 80555510

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'e' || region == 'E')
        .set ptr_effectData, 0x809BDA10
.elseif (region == 'p' || region == 'P')
        .set ptr_effectData, 0x809C21D0
.elseif (region == 'j' || region == 'J' )
        .set ptr_effectData, 0x809C1230
.elseif (region == 'k' || region == 'K' )
        .set ptr_effectData, 0x809B0810
.else
        .err
.endif

# This code only executes on damage clear

lis r3, ptr_effectData@ha
lwz r3, ptr_effectData@l (r3)
lwz r3, 0x68 (r3)
lwz r4, 0 (r31)
lwz r5, 0x28 (r4)
lwz r4, 0 (r4)
lbz r4, 0x10 (r4)
mulli r4, r4, 4
lwzx r3, r3, r4

li r0, 0 # Original instruction
stw r0, 0x18 (r3)
