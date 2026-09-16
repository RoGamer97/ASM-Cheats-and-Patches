# Game: Mario Kart Wii
# Code: Prevent Ghost Bullet Bills Online (End Disconnected Player's Bullet)
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 8057AB6C
# PAL 805813D0
# NTSC-J 80580D50
# NTSC-K 8056F428

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

lwz r3, 0 (r3) # Original instruction

stwu sp, -0x80(sp)
stmw r3, 0x8(sp)

lwz r4, 0xC (r3)
andis. r4, r4, 0x800
beq end

mflr r30
lwz r3, 0x60 (r31)
lis r12, Vehicle__endKiller@h
ori r12, r12, Vehicle__endKiller@l
mtctr r12
bctrl

mtlr r30

end:
lmw r3, 0x8(sp)
addi sp, sp, 0x80