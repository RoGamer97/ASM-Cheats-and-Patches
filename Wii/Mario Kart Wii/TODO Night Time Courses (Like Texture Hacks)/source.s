


remove skybox and set night time bool
# NTSC-U 807852B8
# PAL 8078E2C4
# NTSC-J 8078D930
# NTSC-K 8077C684

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

.set COURSE_MOONVIEW_HIGHWAY, 0xA
.set COURSE_RAINBOW_ROAD, 0xD
.set COURSE_SNES_GHOST_VALLEY_2, 0x19
.set COURSE_CHAIN_CHOMP_WHEEL, 0x22
.set COURSE_FUNKY_STADIUM, 0x23
.set COURSE_DS_TWILIGHT_HOUSE, 0x26
.set COURSE_N64_SKYSCRAPER, 0x29
.set COURSE_GALAXY_COLOSSEUM, 0x36

lfs f0, 0x220 (r4)

lhz r12, 0(r27)
cmpwi r12, 0x7672
bne end

bl unaffectedCourses

.byte COURSE_MOONVIEW_HIGHWAY
.byte COURSE_RAINBOW_ROAD
.byte COURSE_SNES_GHOST_VALLEY_2
.byte COURSE_CHAIN_CHOMP_WHEEL
.byte COURSE_FUNKY_STADIUM
.byte COURSE_DS_TWILIGHT_HOUSE
.byte COURSE_N64_SKYSCRAPER
.byte COURSE_GALAXY_COLOSSEUM
.byte 0xFF

.balign 4

unaffectedCourses:
mflr r4

li r0, 0

loop:
lbz r12, 0 (r4)
cmpwi r12, 0xFF
beq setNightBool

lis r11, ptr_raceData@ha
lwz r11, ptr_raceData@l (r11)
lwz r11, 0xB68 (r11)
cmpw r11, r12
beq storeNightBool

addi r4, r4, 1
b loop

setNightBool:
li r0, 1

fsubs f0, f0, f0

storeNightBool:
lis r11, 0x8000
stb r0, 0x1630 (r11)

end:



force dark screen
# NTSC-U 8054A298
# PAL 8054F7D4
# NTSC-J 8054F154
# NTSC-K 8053D82C

lfs f1, 0x24 (r3)

lis r12, 0x8000
lbz r12, 0x1630 (r12)
cmpwi r12, 0
beq end

bl darkness

.float 130

darkness:
mflr r12

lfs f1, 0 (r12)
stfs f1, 0x24 (r3)

end:


no darken shock
# NTSC-U 80549C74
# PAL 8054F1B0
# NTSC-J 8054EB30
# NTSC-K 8053D208

lis r12, 0x8000
lbz r12, 0x1630 (r12)
cmpwi r12, 0
bnelr

stwu sp, -0x30 (sp)


change void color 
# NTSC-U 80240074
# PAL 80240F30
# NTSC-J 80240E50
# NTSC-K 802412A4

.set COLOR_BLUE, 0x45

lbz r5, 0x16 (r3)

lis r12, 0x8000
lbz r12, 0x1630 (r12)
cmpwi r12, 0
beq end

li r5, COLOR_BLUE

end:



set shadow kcl
# NTSC-U 807AF078
# PAL 807BDAD8
# NTSC-J 807BD144
# NTSC-K 807ABE98

lis r12, 0x8000
lbz r12, 0x1630 (r12)
cmpwi r12, 0
beq end

andis. r4, r4, 1
bne end
 
ori r5, r5, 0x100

end:
sth r5, 4 (r3)


prevent kcl shadow change
# NTSC-U 8055C9C0
# PAL 80560D40
# NTSC-J 805606C0
# NTSC-K 8054ED98

lfs f2, 0x28 (r3)

lis r12, 0x8000
lbz r12, 0x1630 (r12)
cmpwi r12, 0
beq end

fsubs f1, f1, f1

end:




remove specific objects

# NTSC-U 80813480
# PAL 80826F94
# NTSC-J 80826600
# NTSC-K 80815354

.set OBJECT_SOUND_AUDIENCE, 0xD
.set OBJECT_SUN, 0x6F  
.set OBJECT_SKYSHIP, 0xD2
.set OBJECT_SEAGULL, 0xE3   
.set OBJECT_BIRD, 0xED
.set OBJECT_HEYHO2, 0x149    
.set OBJECT_TRUCKCHIMSMK, 0x14C
.set OBJECT_MIIOBJ01, 0x14D    
.set OBJECT_MIIOBJ02, 0x14E
.set OBJECT_MIIOBJ03, 0x14F
.set OBJECT_MONTE_A, 0x165
.set OBJECT_SHMII_OBJ01, 0x167
.set OBJECT_SHMII_OBJ02, 0x168
.set OBJECT_SHMII_OBJ03, 0x169
.set OBJECT_DK_MIIOBJ00, 0x16C
.set OBJECT_BLACKHOLE, 0x179
.set OBJECT_CARB, 0x181
.set OBJECT_GROUP_MONTE_A, 0x185
.set OBJECT_GROUP_ENEMY_B, 0x2BD
.set OBJECT_GROUP_ENEMY_C, 0x2BE
.set OBJECT_TRUCKCHIMSMK_W, 0x2C0
.set OBJECT_GROUP_ENEMY_A, 0x2C3
.set OBJECT_GROUP_ENEMY_E, 0x2C8
.set OBJECT_GROUP_MONTE_L, 0x2C9
.set OBJECT_GROUP_ENEMY_F, 0x2CA
.set OBJECT_FLASH_L, 0x2D0
.set OBJECT_FLASH_B, 0x2D1     
.set OBJECT_FLASH_W, 0x2D2
.set OBJECT_FLASH_M, 0x2D3 
.set OBJECT_MIIOBJD01, 0x2E8
.set OBJECT_MIIOBJD02, 0x2E9
.set OBJECT_MIIOBJD03, 0x2EA   
.set OBJECT_MARE_A, 0x2EB
.set OBJECT_MARE_B, 0x2EC            

lhz r5, 0 (r3)
lis r12, 0x8000
lbz r12, 0x1630 (r12)
cmpwi r12, 0
beq end


bl objectsToRemove

.hword OBJECT_SOUND_AUDIENCE
.hword OBJECT_SUN
.hword OBJECT_SKYSHIP
.hword OBJECT_SEAGULL
.hword OBJECT_BIRD
.hword OBJECT_HEYHO2
.hword OBJECT_TRUCKCHIMSMK
.hword OBJECT_MIIOBJ01
.hword OBJECT_MIIOBJ02
.hword OBJECT_MIIOBJ03
.hword OBJECT_MONTE_A
.hword OBJECT_SHMII_OBJ01
.hword OBJECT_SHMII_OBJ02
.hword OBJECT_SHMII_OBJ03
.hword OBJECT_DK_MIIOBJ00
.hword OBJECT_CARB
.hword OBJECT_GROUP_MONTE_A
.hword OBJECT_GROUP_ENEMY_B
.hword OBJECT_GROUP_ENEMY_C
.hword OBJECT_TRUCKCHIMSMK_W
.hword OBJECT_GROUP_ENEMY_A
.hword OBJECT_GROUP_ENEMY_E
.hword OBJECT_GROUP_MONTE_L
.hword OBJECT_GROUP_ENEMY_F
.hword OBJECT_FLASH_L
.hword OBJECT_FLASH_B 
.hword OBJECT_FLASH_W
.hword OBJECT_FLASH_M
.hword OBJECT_MIIOBJD01
.hword OBJECT_MIIOBJD02
.hword OBJECT_MIIOBJD03 
.hword OBJECT_MARE_A
.hword OBJECT_MARE_B
.hword 0xFFFF

.balign 4

objectsToRemove:
mflr r12

loop:
lhz r11, 0 (r12)
cmplwi r11, 0xFFFF
beq end

cmpw r5, r11
beq removeObject

addi r12, r12, 2
b loop

removeObject:
li r5, OBJECT_BLACKHOLE
sth r5, 0 (r3)

end: