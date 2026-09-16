# Game: Mario Kart Wii
# Code: Invalid Respawn Anti Freeze
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 805144F0
# PAL 80518964
# NTSC-J 805182E4
# NTSC-K 80506984

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


lis r3, ptr_KMPinfo@ha
lwz r3, ptr_KMPinfo@l (r3)
lwz r3, 8 (r3)
lwz r3, 0 (r3)
lwz r3, 0 (r3)