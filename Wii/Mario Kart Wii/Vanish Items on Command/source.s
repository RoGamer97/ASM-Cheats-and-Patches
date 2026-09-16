# Game: Mario Kart Wii
# Code: Vanish Items on Command
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 8079688C
# PAL 8079F898
# NTSC-J 8079EF04
# NTSC-K 8078DC58

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling! Lowercase letters can also be used. 
# E for NTSC-U, P for PAL, J for NTSC-K and K for NTSC-K

.if (region == 'e' || region == 'E')
        .set ptr_inputBase, 0x809B8F4C
		.set ItemObj__exit_Vanish, 0x8079DC08
.elseif (region == 'p' || region == 'P')
      .set ptr_inputBase , 0x809BD70C
	  .set ItemObj__exit_Vanish, 0x807A6C14
.elseif (region == 'j' || region == 'J' )
        .set ptr_inputBase, 0x809BC76C
		.set ItemObj__exit_Vanish, 0x807A6280
.elseif (region == 'k' || region == 'K' )
        .set ptr_inputBase, 0x809ABD4C
		.set ItemObj__exit_Vanish, 0x80794FD4
.else
    .err
.endif

.set CONTROLLER_NUNCHUK, 1
.set CONTROLLER_CLASSIC, 2
.set CONTROLLER_GCN, 3

.set BUTTON_A_WIIMOTE, 0x800
.set BUTTON_MINUS_WIIMOTE, 0x1000
.set BUTTON_C_NUNCHUK, 0x4000
.set BUTTON_DPAD_DOWN_NUNCHUK, 4
.set BUTTON_Y_CLASSIC, 0x20
.set BUTTON_ZL_CLASSIC, 0x80
.set BUTTON_Z_GCN, 0x10
.set BUTTON_Y_GCN, 0x800

.set ITEMTYPE_THUNDER_CLOUD, 0xE

bl buttonHold

.hword BUTTON_A_WIIMOTE | BUTTON_MINUS_WIIMOTE
.hword BUTTON_C_NUNCHUK | BUTTON_DPAD_DOWN_NUNCHUK
.hword BUTTON_ZL_CLASSIC | BUTTON_Y_CLASSIC
.hword BUTTON_Y_GCN | BUTTON_Z_GCN

buttonHold:
mflr r5

lis r4, ptr_inputBase@ha
lwz r4, ptr_inputBase@l (r4)

lwz r0, 0xCC (r4)
mulli r0, r0, 2
lhzx r6, r5, r0

lwz r5, 0x60 (r4)

and r0, r5, r6
cmpw r6, r0
bne end

lwz r4, 0x94 (r4)
andc r4, r5, r4
and. r0, r6, r4
beq end

lwz r4, 4 (r29)
cmpwi r4, ITEMTYPE_THUNDER_CLOUD
beq end

mr r31, r3

mr r3, r29
li r4, 1
lis r12, ItemObj__exit_Vanish@h 
ori r12, r12, ItemObj__exit_Vanish@l 
mtctr r12
bctrl

mr r3, r31

end:
lwz r0, 0x34 (sp)