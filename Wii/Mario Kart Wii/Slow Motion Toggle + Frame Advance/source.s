# Game: Mario Kart Wii
# Code: Slow Motion Toggle + Frame Advance
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 8054EE2C
# PAL 80554E4C
# NTSC-J 805547CC
# NTSC-K 80542EA4

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling! Lowercase letters can also be used.

.if (region == 'e' || region == 'E')
        .set ptr_inputBase, 0x809B8F4C
.elseif (region == 'p' || region == 'P')
      .set ptr_inputBase , 0x809BD70C
.elseif (region == 'j' || region == 'J' )
        .set ptr_inputBase, 0x809BC76C
.elseif (region == 'k' || region == 'K' )
        .set ptr_inputBase, 0x809ABD4C
.else
    .err
.endif

.set A_WII_WHEEL, 0x800
.set MINUS_WII_WHEEL, 0x1000
.set C_NUNCHUK, 0x4000
.set DPAD_DOWN_NUNCHUK, 4
.set X_CLASSIC, 8
.set ZR_CLASSIC, 4
.set Z_GCN, 0x10
.set Y_GCN, 0x800

mr r4, r3

lbz r3, 0x38B (r3) # Original instruction
cmpwi r3, 0
bne end

lbz r0, 4 (r4)
lis r12, ptr_inputBase@ha
lwz r12, ptr_inputBase@l (r12)

bl buttons

.hword A_WII_WHEEL
.hword C_NUNCHUK
.hword X_CLASSIC
.hword Z_GCN

.hword MINUS_WII_WHEEL
.hword DPAD_DOWN_NUNCHUK
.hword ZR_CLASSIC
.hword Y_GCN

buttons:
mflr r5

lwz r6, 0xCC (r12)
mulli r6, r6, 2
lhzx r7, r5, r6

addi r5, r5, 8
lhzx r5, r5, r6

lwz r11, 0x60 (r12)
lwz r12, 0x94 (r12)
andc r10, r11, r12
and. r8, r11, r7
beq isEnabled

and. r8, r10, r5
beq isEnabled

xori r0, r0, 1
stb r0, 4 (r4)
li r12, 0
stb r12, 6 (r4)

isEnabled:
andi. r0, r0, 1
beq end

and. r3, r10, r5
beq loadMode

li r3, 0
stb r3, 5 (r4)
b end

loadMode:
lbz r5, 5 (r4)
and. r3, r10, r7
beq checkMode

addi r5, r5, 1
cmpwi r5, 3
blt storeMode

li r5, 1

storeMode:
stb r5, 5 (r4)

checkMode:
li r3, 1
cmpwi r5, 0
beq end

calcTimer:
lbz r6, 6 (r4)
addi r6, r6, 1
cmpwi r6, 0x1E
blt storeTimer

li r6, 0

storeTimer:
stb r6, 6 (r4)

andi. r3, r6, 1
cmpwi r5, 1
beq end

cntlzw r3, r6
srwi r3, r3, 5
xori r3, r3, 1

end:
