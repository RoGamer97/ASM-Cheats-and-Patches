# Game: Mario Kart Wii
# Code: 

# Note:
# Mario Kart Wii has no official symbols.
# Names for functions, global addresses, constants, and other game elements
# are either defined by me (often inspired by official naming in other
# Mario Kart games) or based on names used by other members of the community.

# NTSC-U 807889B4
# PAL 
# NTSC-J 
# NTSC-K 



.set region, 'E' #Fill in E, P, J, or K within the quotes for your region when compiling! Lowercase letters can also be used.

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

.set ITEMSLOT_BULLET_BILL, 0xF

cmpwi r31, ITEMSLOT_BULLET_BILL
bne end

lwz r3, 0xC (r27)
lwz r3, 0 (r3)
lwz r4, 4 (r3)
lwz r4, 0xC (r4)
andis. r4, r4, 0x800
beq end

lwz r3, 0x28 (r3)
lis r12, Vehicle__endKiller@h
ori r12, r12, Vehicle__endKiller@l
mtctr r12
bctrl

li r29, 0

end:
cmpwi r29, 0