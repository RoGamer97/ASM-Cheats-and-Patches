# Game: Mario Kart Wii
# Code: Damage Objects on Command
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 80816F8C
# PAL 8082AAA0
# NTSC-J 8082A10C
# NTSC-K 80818E60

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'e' || region == 'E')
		.set ptr_inputBase, 0x809B8F4C
        .set ObjectDirector__damage, 0x80817780
.elseif (region == 'p' || region == 'P')
   		.set ptr_inputBase , 0x809BD70C
        .set ObjectDirector__damage, 0x8082B294
.elseif (region == 'j' || region == 'J' )
    	.set ptr_inputBase , 0x809BC76C
        .set ObjectDirector__damage, 0x8082A900
.elseif (region == 'k' || region == 'K' )
    	.set ptr_inputBase , 0x809ABD4C
        .set ObjectDirector__damage, 0x80819654
.else
        .err
.endif

.set BUTTONBIT_B_WIIMOTE, 1 << 10 		 #0x400
.set BUTTONBIT_MINUS_WIIMOTE, 1 << 12 	 # 0x1000
.set BUTTONBIT_DPAD_DOWN_NUNCHUK, 1 << 3 # 4
.set BUTTONBIT_Y_CLASSIC, 1 << 5		 # 0x20
.set BUTTONBIT_ZL_CLASSIC, 1 << 7 		 # 0x80
.set BUTTONBIT_Z_GCN, 1 << 4 			 # 0x10
.set BUTTONBIT_Y_GCN, 1 << 11 			 # 0x800

bl buttonHold

.hword BUTTONBIT_B_WIIMOTE | BUTTONBIT_MINUS_WIIMOTE
.hword BUTTONBIT_B_WIIMOTE | BUTTONBIT_MINUS_WIIMOTE
.hword BUTTONBIT_ZL_CLASSIC | BUTTONBIT_Y_CLASSIC
.hword BUTTONBIT_Y_GCN | BUTTONBIT_Z_GCN

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

mr r3, r27
li r4, 5 # Damage type
lis r12, ObjectDirector__damage@h
ori r12, r12, ObjectDirector__damage@l
mtctr r12
bctrl

end:
psq_l f27,0x38 (sp),0,0 # Original instruction