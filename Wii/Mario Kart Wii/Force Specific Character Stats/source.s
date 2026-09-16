# Game: Mario Kart Wii
# Code:  Force Specific Character Stats
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names


# Local Player Only
# NTSC-U 8058B948 
# PAL 8059216C
# NTSC-J 80591AEC
# NTSC-K 805801C4 

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'e' || region == 'E')
        .set ptr_raceData, 0x809B8F68
.elseif (region == 'p' || region == 'P')
        .set ptr_raceData, 0x809BD728
.elseif (region == 'j' || region == 'J' )
        .set ptr_raceData, 0x809BC788
.elseif (region == 'k' || region == 'K' )
        .set ptr_raceData, 0x809ABD68
.else
        .err
.endif

.set CHARACTER_MARIO, 0
.set CHARACTER_BABY_PEACH, 1
.set CHARACTER_WALUIGI, 2
.set CHARACTER_BOWSER, 3
.set CHARACTER_BABY_DAISY, 4
.set CHARACTER_DRY_BONES, 5
.set CHARACTER_BABY_MARIO, 6
.set CHARACTER_LUIGI, 7
.set CHARACTER_TOAD, 8
.set CHARACTER_DONKEY_KONG, 9
.set CHARACTER_YOSHI, 0xA
.set CHARACTER_WARIO, 0xB
.set CHARACTER_BABY_LUIGI, 0xC
.set CHARACTER_TOADETTE, 0xD
.set CHARACTER_KOOPA, 0xE
.set CHARACTER_DAISY, 0xF
.set CHARACTER_PEACH, 0x10
.set CHARACTER_BIRDO, 0x11
.set CHARACTER_DIDDY_KONG, 0x12
.set CHARACTER_KING_BOO, 0x13
.set CHARACTER_BOWSER_JR, 0x14
.set CHARACTER_DRY_BOWSER, 0x15
.set CHARACTER_FUNKY_KONG, 0x16
.set CHARACTER_ROSALINA, 0x17
.set CHARACTER_SMALL_MII_A_MALE, 0x18
.set CHARACTER_SMALL_MII_A_FEMALE, 0x19
.set CHARACTER_SMALL_MII_B_MALE, 0x1A
.set CHARACTER_SMALL_MII_B_FEMALE, 0x1B
.set CHARACTER_SMALL_MII_C_MALE, 0x1C
.set CHARACTER_SMALL_MII_C_FEMALE, 0x1D
.set CHARACTER_MEDIUM_MII_A_MALE, 0x1E
.set CHARACTER_MEDIUM_MII_A_FEMALE, 0x1F
.set CHARACTER_MEDIUM_MII_B_MALE, 0x20
.set CHARACTER_MEDIUM_MII_B_FEMALE, 0x21
.set CHARACTER_MEDIUM_MII_C_MALE, 0x22
.set CHARACTER_MEDIUM_MII_C_FEMALE, 0x23
.set CHARACTER_LARGE_MII_A_MALE, 0x24
.set CHARACTER_LARGE_MII_A_FEMALE, 0x25
.set CHARACTER_LARGE_MII_B_MALE, 0x26
.set CHARACTER_LARGE_MII_B_FEMALE, 0x27
.set CHARACTER_LARGE_MII_C_MALE, 0x28
.set CHARACTER_LARGE_MII_C_FEMALE, 0x29


lis r12, ptr_raceData@ha
lwz r12, ptr_raceData@l (r12)
addi r11, r12, 0xB84

li r4, 4
mtctr r4

loop:
lbz r12, 0 (r11)
cmpw r12, r28
beq overrideStats

addi r11, r11, 1

bdnz loop
b end

overrideStats:

bl characterTable

.byte CHARACTER_MARIO
.byte CHARACTER_MARIO
.byte CHARACTER_MARIO
.balign 4

characterTable:

mflr r4
lwz r0, 8 (r3)
lbzx r31, r4, r0

end:
mulli r4, r31, 0x18C # Original instruction



# Everyone
# NTSC-U 8058B948 
# PAL 8059216C
# NTSC-J 80591AEC
# NTSC-K 805801C4 

.set CHARACTER_MARIO, 0
.set CHARACTER_BABY_PEACH, 1
.set CHARACTER_WALUIGI, 2
.set CHARACTER_BOWSER, 3
.set CHARACTER_BABY_DAISY, 4
.set CHARACTER_DRY_BONES, 5
.set CHARACTER_BABY_MARIO, 6
.set CHARACTER_LUIGI, 7
.set CHARACTER_TOAD, 8
.set CHARACTER_DONKEY_KONG, 9
.set CHARACTER_YOSHI, 0xA
.set CHARACTER_WARIO, 0xB
.set CHARACTER_BABY_LUIGI, 0xC
.set CHARACTER_TOADETTE, 0xD
.set CHARACTER_KOOPA, 0xE
.set CHARACTER_DAISY, 0xF
.set CHARACTER_PEACH, 0x10
.set CHARACTER_BIRDO, 0x11
.set CHARACTER_DIDDY_KONG, 0x12
.set CHARACTER_KING_BOO, 0x13
.set CHARACTER_BOWSER_JR, 0x14
.set CHARACTER_DRY_BOWSER, 0x15
.set CHARACTER_FUNKY_KONG, 0x16
.set CHARACTER_ROSALINA, 0x17
.set CHARACTER_SMALL_MII_A_MALE, 0x18
.set CHARACTER_SMALL_MII_A_FEMALE, 0x19
.set CHARACTER_SMALL_MII_B_MALE, 0x1A
.set CHARACTER_SMALL_MII_B_FEMALE, 0x1B
.set CHARACTER_SMALL_MII_C_MALE, 0x1C
.set CHARACTER_SMALL_MII_C_FEMALE, 0x1D
.set CHARACTER_MEDIUM_MII_A_MALE, 0x1E
.set CHARACTER_MEDIUM_MII_A_FEMALE, 0x1F
.set CHARACTER_MEDIUM_MII_B_MALE, 0x20
.set CHARACTER_MEDIUM_MII_B_FEMALE, 0x21
.set CHARACTER_MEDIUM_MII_C_MALE, 0x22
.set CHARACTER_MEDIUM_MII_C_FEMALE, 0x23
.set CHARACTER_LARGE_MII_A_MALE, 0x24
.set CHARACTER_LARGE_MII_A_FEMALE, 0x25
.set CHARACTER_LARGE_MII_B_MALE, 0x26
.set CHARACTER_LARGE_MII_B_FEMALE, 0x27
.set CHARACTER_LARGE_MII_C_MALE, 0x28
.set CHARACTER_LARGE_MII_C_FEMALE, 0x29

bl characterTable

.byte CHARACTER_MARIO
.byte CHARACTER_MARIO
.byte CHARACTER_MARIO
.balign 4

characterTable:

mflr r4
lwz r0, 8 (r3)
lbzx r31, r4, r0

mulli r4, r31, 0x18C # Original instruction