# Game: Mario Kart Wii
# Code: Angry Wigglers
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 806BEF50
# PAL 806C9B44
# NTSC-J 806C91B0
# NTSC-K 806B7EEC

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'e' || region == 'E')
        .set ObjectSound__startSoundLimited, 0x8080CA28
.elseif (region == 'p' || region == 'P')
        .set ObjectSound__startSoundLimited, 0x8082053C
.elseif (region == 'j' || region == 'J' )
        .set ObjectSound__startSoundLimited, 0x8081FBA8
.elseif (region == 'k' || region == 'K' )
        .set ObjectSound__startSoundLimited, 0x8080E8FC
.else
        .err
.endif

.set SOUND_HANACHAN_ANGRY, 0x274

mr r31, r3

lwz r12, 0 (r3)
lwz r12, 0xEC (r12)
mtctr r12
bctrl

addi r3, r29, 0x284
li r4, SOUND_HANACHAN_ANGRY
lis r12, ObjectSound__startSoundLimited@h
ori r12, r12, ObjectSound__startSoundLimited@l
mtctr r12
bctrl

mr r3, r31

end:
lwz r12, 0 (r3) # Original instruction