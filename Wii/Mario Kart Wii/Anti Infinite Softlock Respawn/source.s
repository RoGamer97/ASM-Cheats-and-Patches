# Game: Mario Kart Wii
# Code: Anti Infinite Softlock Respawn
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 8056EFE4
# PAL 80573E34
# NTSC-J 805737B4
# NTSC-K 80561E8C

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

.set KARTSTATUSBIT_LAKITU_HANG, 1 << 13 # 0x2000
.set KARTSTATUSBIT_LAKITU_DROP, 1 << 14 # 0x4000

lwz r4, 4 (r27)
lwz r5, 0 (r4)

lbz r5, 0x10 (r5)

lwz r4, 4 (r4)
lwz r4, 0xC (r4)
andi. r4, r4, (KARTSTATUSBIT_LAKITU_HANG | KARTSTATUSBIT_LAKITU_DROP)
beq end

lwz r4, ptr_raceDirector@l (r3)
lwz r4, 0x10 (r4)
lwz r4, 4 (r4)
lwz r4, 0xC (r4)
mulli r5, r5, 4
lwzx r4, r4, r5
lbz r5, 0x21(r4)
subi r5, r5, 1

andi. r5, r5, 0x7F
stb r5, 0x21 (r4)

end:
li r4, 0 # Original instruction
