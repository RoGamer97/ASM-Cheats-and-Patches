# Game: Mario Kart Wii
# Code: Respawn If Stuck on Top of Wall Collision
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 8056F0B8
# PAL 80573F08
# NTSC-J 80573888
# NTSC-K 80561F60

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'e' || region == 'E')
        .set addr_value30f: 0x8088BEB0
        .set addr_valueNegative: .word 0x808901AC
.elseif (region == 'p' || region == 'P')
        .set addr_value30f: 0x80890428
        .set addr_valueNegative: .word 0x80896824
.elseif (region == 'j' || region == 'J' )
        .set addr_value30f: 0x8088FA78
        .set addr_valueNegative: .word 0x80895E74
.elseif (region == 'k' || region == 'K' )
        .set addr_value30f: 0x8087E828
        .set addr_valueNegative: .word 0x8088514C
.else
    .err
.endif

lfs f1, 4 (r3) # Original instruction

lwz r3, 4 (r31)
lwz r5, 8 (r3)
lwz r6, 4 (r3)
lwz r6, 4 (r6)
andi. r7, r6, 0x8000
beq end

andi. r6, r6, 0x60
beq end

lwz r5, 0x90 (r5)
lwz r5, 4 (r5)
lfs f2, 0xE0 (r5)
lwz r6, 0 (r3)
lbz r5, 0x11 (r6)
lfs f3, addr_value30f@l (r4)
fcmpo cr0, f2, f3
bge resetTimer

addi r5, r5, 1
cmpwi r5, 0xF0
blt storeTimer

lfs f1, addr_valueNegative@l (r4)

resetTimer:
li r5, 0

storeTimer:
stb r5, 0x11 (r6)

end: