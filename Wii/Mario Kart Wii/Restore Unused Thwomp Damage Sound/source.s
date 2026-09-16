# Game: Mario Kart Wii
# Code: Restore Unused Thwomp Damage Sound
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 80753174
# PAL 807600C0
# NTSC-J 8075F72C
# NTSC-K 8074E480

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'e' || region == 'E')
        .set ObjectSound__startSound, 0x8080CA48
.elseif (region == 'p' || region == 'P')
        .set ObjectSound__startSound, 0x8082055C
.elseif (region == 'j' || region == 'J' )
        .set ObjectSound__startSound, 0x8081FBC8
.elseif (region == 'k' || region == 'K' )
        .set ObjectSound__startSound, 0x8080E91c
.else
        .err
.endif


.set SOUND_DOSSUN_DMG, 0x246


mr r3, r31
li r4, SOUND_DOSSUN_DMG
lis r12, ObjectSound__startSound@h
ori r12, r12, ObjectSound__startSound@l
mtctr r12
bctrl

lwz r12, 0 (r31) # Original instruction