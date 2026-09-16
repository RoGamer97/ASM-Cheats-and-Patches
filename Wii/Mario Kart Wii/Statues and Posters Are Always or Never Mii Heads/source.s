# Game: Mario Kart Wii
# Code: Small Items If Shocked
# Description: Makes items smalls if thrown or dropped by players who are shocked by setting the "small items" flag (used when first throwing items)
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 8079678C
# PAL 8079F798
# NTSC-J 8079EE04
# NTSC-K 8078DB58

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'e' || region == 'E')
		.set ptr_playerBase, 0x809BD110
.elseif (region == 'p' || region == 'P')
		.set ptr_playerBase, 0x809C18F8
.elseif (region == 'j' || region == 'J' )
		.set ptr_playerBase, 0x809C0958
.elseif (region == 'k' || region == 'K' )
		.set ptr_playerBase, 0x809AFF38
.else
    .err
.endif

.set ITEMSLOT_THUNDER_CLOUD, 0xE

# If item is a Thunder Cloud, skip rest of the code and jump to end (Don't affect TCs)
lwz r12, 4 (r29)
cmpwi r12, ITEMSLOT_THUNDER_CLOUD
beq end

# Get kart status for player who threw item
lis r12, ptr_playerBase@ha
lwz r12, ptr_playerBase@l (r12)
lwz r12, 0x20 (r12)
lbz r11, 0x6C (r29)
mulli r11, r11, 4
lwzx r12, r12, r11
lwz r12, 0 (r12)
lwz r12, 4 (r12)

# If kart is not shocked, skip setting small items flag and jump to end
lwz r12, 0xC (r12)
andi. r12, r12, 0x80
beq end

# Kart is shocked, set small items flag
ori r0, r0, 0x400

# End of code (Original instruction)
end:
fcmpo cr0, f1, f0