# Game: Mario Kart Wii
# Code: Bullet Bill Won't Activate If No Item Routes Exist
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# Prevent Bullet Bill Activation
# NTSC-U 8057F088
# PAL 805858AC
# NTSC-J 8058522C
# NTSC-K 80573904

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'E' || region == 'e') # RMCE
    .set ptr_KMPinfo, 0x809B8F28
.elseif (region == 'P' || region == 'p') # RMCP
    .set ptr_KMPinfo, 0x809BD6E8
.elseif (region == 'J' || region == 'j') # RMCJ
    .set ptr_KMPinfo, 0x809BC748
.elseif (region == 'K' || region == 'k') # RMCK
    .set ptr_KMPinfo, 0x809BBD28
.else
    .abort
.endif

lis r12, ptr_KMPinfo@ha
lwz r12, ptr_KMPinfo@l (r12)
lwz r12, 0x18 (r12)

lhz r12, 4 (r12)
cmpwi r12, 0
beqlr

stwu sp, -0x10 (sp) # Original instruction


# Prevent setting Bullet Bill display item on slot on use
# NTSC-U 807D68E4
# PAL 807A9B24
# NTSC-J 807A9190
# NTSC-K 80797EE4

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'E' || region == 'e') # RMCE
    .set ptr_KMPinfo, 0x809B8F28
.elseif (region == 'P' || region == 'p') # RMCP
    .set ptr_KMPinfo, 0x809BD6E8
.elseif (region == 'J' || region == 'j') # RMCJ
    .set ptr_KMPinfo, 0x809BC748
.elseif (region == 'K' || region == 'k') # RMCK
    .set ptr_KMPinfo, 0x809BBD28
.else
    .abort
.endif

.set ITEMSLOT_BULLET_BILL, 0xF
.set ITEMSLOT_NONE, 0x14

li r4, ITEMSLOT_BULLET_BILL # Original instruction

lis r12, ptr_KMPinfo@ha
lwz r12, ptr_KMPinfo@l (r12)
lwz r12, 0x18 (r12)

lhz r12, 4 (r12)
cmpwi r12, 0
bne end

li r4, ITEMSLOT_NONE

end: