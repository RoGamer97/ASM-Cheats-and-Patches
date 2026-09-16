# Game: Mario Kart Wii
# Code: Cancel Friend Room Joining by Pressing B
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 8062DD78
# PAL 805DD85C
# NTSC-J 805DD138
# NTSC-K 805CB9F8

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'E' || region == 'e') # RMCE
    .set ptr_inputBase, 0x809B8F4C
.elseif (region == 'P' || region == 'p') # RMCP
    .set ptr_inputBase , 0x809BD70C
.elseif (region == 'J' || region == 'j') # RMCJ
    .set ptr_inputBase , 0x809BC76C
.elseif (region == 'K' || region == 'k') # RMCK
    .set ptr_inputBase , 0x809ABD4C
.else
    .err
.endif

.set BUTTONBIT_B, 1 << 1 # 2

.set ERROR_COULDNT_MEET_UP, 3

lis r31, ptr_inputBase@ha
lwz r31, ptr_inputBase@l (r31)
lhz r31, 0x60 (r31)
andi. r31, r31, BUTTONBIT_B
beq end

li r3, ERROR_COULDNT_MEET_UP

end:
cmpwi r3, ERROR_COULDNT_MEET_UP # Original instruction