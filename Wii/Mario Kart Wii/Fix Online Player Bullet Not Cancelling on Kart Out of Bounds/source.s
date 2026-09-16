# Game: Mario Kart Wii
# Code: Fix Online Player Bullet Not Ending on Kart Out of Bounds
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 80585848
# PAL 8058C06C
# NTSC-J 8058B9EC
# NTSC-K 8057A0C4

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'E' || region == 'e')
    .set Vehicle__endKiller, 0x805B1100
.elseif (region == 'P' || region == 'p')
    .set Vehicle__endKiller , 0x8059C118
.elseif (region == 'J' || region == 'j')
    .set Vehicle__endKiller , 0x8059BA98
.elseif (region == 'K' || region == 'k')
    .set Vehicle__endKiller , 0x8058A170
.else
    .err
.endif

.set KARTSTATUSBIT_OUT_OF_BOUNDS, 1 << 4 	 # 0x10
.set KARTSTATUSBIT_UPPERHALF_BULLET, 1 << 11 # 0x800

lwz r3, 0 (r31)
lwz r4, 0x74 (r3)
cmpwi r4, 0
bne end # Bike

lwz r4, 4 (r3)
lwz r5, 4 (r4)
andi. r5, r5, KARTSTATUSBIT_OUT_OF_BOUNDS
beq end

lwz r4, 0xC (r4)
andis. r4, r4, KARTSTATUSBIT_UPPERHALF_BULLET
beq end

lwz r3, 0x60 (r3)
lis r12, Vehicle__endKiller@h
ori r12, r12, Vehicle__endKiller@l
mtctr r12
bctrl

end:
lwz r0, 0x34 (sp) # Original instruction