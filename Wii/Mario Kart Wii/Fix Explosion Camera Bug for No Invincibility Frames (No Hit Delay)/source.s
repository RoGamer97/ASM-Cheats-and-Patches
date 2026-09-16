# Game: Mario Kart Wii
# Code: Fix Explosion Camera Bug for No Invincibility Frames (No Hit Delay)
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 8056313C
# PAL 805674BC
# NTSC-J 80566E3C
# NTSC-K 80555514

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling! Lowercase letters can also be used.

.if (region == 'E' || region == 'e')
    .set KartCamera__clearExplosionCam, 0x8058A668
.elseif (region == 'P' || region == 'p')
    .set KartCamera__clearExplosionCam , 0x80590E8C
.elseif (region == 'J' || region == 'j')
    .set KartCamera__clearExplosionCam , 0x8059080C
.elseif (region == 'K' || region == 'k')
    .set KartCamera__clearExplosionCam , 0x8057EEE4
.else
    .err
.endif

mr r3, r31
lis r12, KartCamera__clearExplosionCam@h 
ori r12, r12, KartCamera__clearExplosionCam@l
mtctr r12
bctrl

end:
li r3, -1 # Original instruction