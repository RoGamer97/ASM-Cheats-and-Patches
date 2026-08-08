//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: CPU Combo Modifier

//; You can find some documented headers here to learn more about the game
//; and know some offsets: https://github.com/fishguy6564/MK8DX-Headers

<<<<<<< HEAD:Switch/Mario Kart 8 Deluxe/3.0.5/CPU Combo Modifier/source.s
// Hooks are written over unused functions (never executed).
// There is a bit of free space in .text, but for some reason the emulator
// crashes when executing code in that space. Writing over unused functions
// doesn't cause a crash.
=======
//; Hooks are written in unused functions because there is no space left in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*
>>>>>>> ba5ad483375f4e5cc4ea3a7d358921b18d444f5a:Switch/Mario Kart 8 Deluxe (v3.0.5)/CPU Combo Modifier/source.s


//; Force team mode to use non-team mode characters selection
//; ui::SetRandomCPU(bool,bool,sead::SafeArray<mush::EDriverID,12> *) + 0x2064 (Not a hook)
//; 0x4FC208 -> MOV W8, #0
//; Overrides the loaded W8 value with zero for a check, to always branch, so that team mode 
//; uses the regular character random code (To avoid multiple hooks for CPU Combo hook)


//; CPU Combo Modifier
//; ui::SetRandomCPU(bool,bool,sead::SafeArray<mush::EDriverID,12> *) + 0x2134
//; 0x4FC2D8 -> BL 0x89AC0

//; Makes a list for set kart, tire, glider and character for every individual CPU

//; You can set a part to the "RANDOM" ID to have that part be randomly chosen

//; Register reference:
//; W20 = CPU ID
//; X23 = CPU combo address (0 = Kart, 4 = Tire, 8 = Glider, 0xC = Character)


.set DRIVER_MARIO, 0
.set DRIVER_LUIGI, 1
.set DRIVER_PEACH, 2
.set DRIVER_DAISY, 3
.set DRIVER_YOSHI, 4
.set DRIVER_TOAD, 5
.set DRIVER_TOADETTE, 6
.set DRIVER_KOOPA_TROOPA, 7
.set DRIVER_BOWSER, 8
.set DRIVER_DONKEY_KONG, 9
.set DRIVER_WARIO, 0xA
.set DRIVER_WALUIGI, 0xB
.set DRIVER_ROSALINA, 0xC
.set DRIVER_METAL_MARIO, 0xD
.set DRIVER_PINK_GOLD_PEACH, 0xE
.set DRIVER_LAKITU, 0xF
.set DRIVER_SHY_GUY, 0x10
.set DRIVER_BABY_MARIO, 0x11
.set DRIVER_BABY_LUIGI, 0x12
.set DRIVER_BABY_PEACH, 0x13
.set DRIVER_BABY_DAISY, 0x14
.set DRIVER_BABY_ROSALINA, 0x15
.set DRIVER_LARRY, 0x16
.set DRIVER_LEMMY, 0x17
.set DRIVER_WENDY, 0x18
.set DRIVER_LUDWIG, 0x19
.set DRIVER_IGGY, 0x1A
.set DRIVER_ROY, 0x1B
.set DRIVER_MORTON, 0x1C
.set DRIVER_MII, 0x1D
.set DRIVER_TANOOKI_MARIO, 0x1E
.set DRIVER_LINK, 0x1F
.set DRIVER_VILLAGER, 0x20
.set DRIVER_ISABELLE, 0x21
.set DRIVER_CAT_PEACH, 0x22
.set DRIVER_DRY_BOWSER, 0x23
.set DRIVER_FEMALE_VILLAGER, 0x24
.set DRIVER_GOLDEN_MARIO, 0x25
.set DRIVER_DRY_BONES, 0x26
.set DRIVER_BOWSER_JR, 0x27
.set DRIVER_KING_BOO, 0x28
.set DRIVER_INKLING_GIRL, 0x29
.set DRIVER_INKLING_BOY, 0x2A
.set DRIVER_BOTW_LINK, 0x2B
.set DRIVER_BIRDO, 0x2C
.set DRIVER_KAMEK, 0x2D
.set DRIVER_PETEY_PIRANHA, 0x2E
.set DRIVER_WIGGLER, 0x2F
.set DRIVER_DIDDY_KONG, 0x30
.set DRIVER_FUNKY_KONG, 0x31
.set DRIVER_PEACHETTE, 0x32
.set DRIVER_PAULINE, 0x33
.set DRIVER_MII_BCP, 0x34

.set BODY_STANDARD_KART, 0
.set BODY_PIPE_FRAME, 1
.set BODY_MACH_8, 2
.set BODY_STEEL_DRIVER, 3
.set BODY_CAT_CRUISER, 4
.set BODY_CIRCUIT_SPECIAL, 5
.set BODY_TRI_SPEEDER, 6
.set BODY_BADWAGON, 7
.set BODY_PRANCER, 8
.set BODY_BIDDYBUGGY, 9
.set BODY_LANDSHIP, 0xA
.set BODY_SNEEKER, 0xB
.set BODY_SPORTS_COUPE, 0xC
.set BODY_GOLD_STANDARD, 0xD
.set BODY_STANDARD_BIKE, 0xE
.set BODY_COMET, 0xF
.set BODY_SPORT_BIKE, 0x10
.set BODY_THE_DUKE, 0x11
.set BODY_FLAME_RIDER, 0x12
.set BODY_VARMINT, 0x13
.set BODY_MR_SCOOTY, 0x14
.set BODY_JET_BIKE, 0x15
.set BODY_YOSHI_BIKE, 0x16
.set BODY_STANDARD_ATV, 0x17
.set BODY_WILD_WIGGLER, 0x18
.set BODY_TEDDY_BUGGY, 0x19
.set BODY_GLA, 0x1A
.set BODY_W_25_SILVER_ARROW, 0x1B
.set BODY_300_SL_ROADSTER, 0x1C
.set BODY_BLUE_FALCON, 0x1D
.set BODY_TANOOKI_KART, 0x1E
.set BODY_B_DASHER, 0x1F
.set BODY_MASTER_CYCLE, 0x20
.set BODY_STREETLE, 0x21
.set BODY_P_WING, 0x22
.set BODY_CITY_TRIPPER, 0x23
.set BODY_BONE_RATTLER, 0x24
.set BODY_KOOPA_CLOWN, 0x25
.set BODY_SPLAT_BUGGY, 0x26
.set BODY_INKSTRIKER, 0x27
.set BODY_MASTER_CYCLE_ZERO, 0x28

.set TIRE_STANDARD, 0
.set TIRE_MONSTER, 1
.set TIRE_ROLLER, 2
.set TIRE_SLIM, 3
.set TIRE_SLICK, 4
.set TIRE_METAL, 5
.set TIRE_BUTTON, 6
.set TIRE_OFF_ROAD, 7
.set TIRE_SPONGE, 8
.set TIRE_WOOD, 9
.set TIRE_CUSHION, 0xA
.set TIRE_BLUE_STANDARD, 0xB
.set TIRE_HOT_MONSTER, 0xC
.set TIRE_AZURE_ROLLER, 0xD
.set TIRE_CRIMSON_SLIM, 0xE
.set TIRE_CYBER_SLICK, 0xF
.set TIRE_RETRO_OFF_ROAD, 0x10
.set TIRE_GOLD_TIRES, 0x11
.set TIRE_GLA_TIRES, 0x12
.set TIRE_TRIFORCE_TIRES, 0x13
.set TIRE_LEAF_TIRES, 0x14
.set TIRE_ANCIENT_TIRES, 0x15

.set WING_SUPER_GLIDER, 0
.set WING_CLOUD_GLIDER, 1
.set WING_WARIO_WING, 2
.set WING_WADDLE_WING, 3
.set WING_PEACH_PARASOL, 4
.set WING_PARACHUTE, 5
.set WING_PARAFOIL, 6
.set WING_FLOWER_GLIDER, 7
.set WING_BOWSER_KITE, 8
.set WING_PLANE_GLIDER, 9
.set WING_MKTV_PARASOL, 0xA
.set WING_GOLD_GLIDER, 0xB
.set WING_HYLIAN_KITE, 0xC
.set WING_PAPER_GLIDER, 0xD
.set WING_PARAGLIDER, 0xE

.set RANDOM, 0xFF

SMADDL X23, W20, W21, X22 //; Original instruction

ADR X1, combos
ADD X1, X1, X20, LSL#2
MOV W2, WZR

loopParts:
LDRB W8, [X1,X2]
CMP W8, #RANDOM
BEQ nextPart

STR W8, [X23,X2,LSL#2]

nextPart:
ADD W2, W2, #1
CMP W2, #4
BLT loopParts

end:
RET

combos:                                                                                //  CPU,   Driver, Vehicle, Tire and Glider Examples
.byte BODY_STANDARD_KART,    TIRE_STANDARD,        WING_SUPER_GLIDER,   DRIVER_MARIO   //; CPU 1: Mario, Standard Kart, Standard Tire, Super Glider
.byte BODY_MACH_8,           TIRE_SLIM,            WING_SUPER_GLIDER,   DRIVER_LUIGI   //; CPU 2: Luigi, Mach 8, Roller Tire, Super Glider
.byte BODY_STANDARD_BIKE,    TIRE_STANDARD,        WING_SUPER_GLIDER,   DRIVER_PEACH   //; CPU 3: Peach, Standard Bike, Standard Tire, Super Glider
.byte BODY_CAT_CRUISER,      TIRE_STANDARD,        WING_PEACH_PARASOL,  DRIVER_DAISY   //; CPU 4: Daisy, Cat Cruiser, Standard Tire, Peach Parasol
.byte BODY_WILD_WIGGLER,     TIRE_STANDARD,        WING_FLOWER_GLIDER,  DRIVER_YOSHI   //; CPU 5: Yoshi, Wild Wiggler, Standard Tire, Flower Glider
.byte BODY_CIRCUIT_SPECIAL,  TIRE_SPONGE,          RANDOM,              DRIVER_WIGGLER //; CPU 6: Wiggler, Circuit Special, Sponge Tires, Random Glider
.byte BODY_VARMINT,          TIRE_MONSTER,         WING_SUPER_GLIDER,   RANDOM         //; CPU 7: Random Character, Varmint, Monster Tire, Super Glider
.byte BODY_BIDDYBUGGY,       TIRE_ROLLER,          RANDOM,              RANDOM         //; CPU 8: Random Character, Biggy Buggy, Roller Tire, Random Glider
.byte RANDOM,                TIRE_CUSHION,         WING_WADDLE_WING,    DRIVER_BIRDO   //; CPU 9: Birdo, Random Vehicle, Cushion Tire, Waddle Wing Glider
.byte RANDOM,                RANDOM,               RANDOM,              RANDOM         //; CPU 10: Random Character, Vehicle, Tire and Glider
.byte RANDOM,                RANDOM,               RANDOM,              RANDOM         //; CPU 11: Random Character, Vehicle, Tire and Glider