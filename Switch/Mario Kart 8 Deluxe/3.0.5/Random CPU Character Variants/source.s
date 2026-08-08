//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: Random CPU Character Variants

//; You can find some documented headers here to learn more about the game
//; and know some offsets: https://github.com/fishguy6564/MK8DX-Headers

<<<<<<< HEAD:Switch/Mario Kart 8 Deluxe/3.0.5/Random CPU Character Variants/source.s
// Hooks are written over unused functions (never executed).
// There is a bit of free space in .text, but for some reason the emulator
// crashes when executing code in that space. Writing over unused functions
// doesn't cause a crash.
=======
//; Hooks are written in unused functions because there is no space left in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*
>>>>>>> ba5ad483375f4e5cc4ea3a7d358921b18d444f5a:Switch/Mario Kart 8 Deluxe (v3.0.5)/Random CPU Character Variants/source.s


//; ui::SetRandomCPU(bool,bool,sead::SafeArray<mush::EDriverID,12> *) + 0x1FAC, 0x20AC and 0x2148
//; 0x4FC150, 0x4FC250 and 0x4FC2EC -> BL 0x62F978

//; Make a list of characters who have variants, and how many variants they have.
//; If the character the CPU is using is in the list, load the variant count
//; for that character and use it for the modulo of the random U32 value to
//; limit the variant ID from 0 to count - 1
//; The result will be moved to W2, overwriting the character variant ID

//; Register reference:
//; W2 = Character variant ID (Input and output)
//; W8 = Character ID


.set DRIVER_YOSHI, 4
.set DRIVER_SHY_GUY, 0x10
.set DRIVER_INKLING_GIRL, 0x29
.set DRIVER_INKLING_BOY, 0x2A
.set DRIVER_BIRDO, 0x2C

.set END_OF_LIST, 0xFF

.set YOSHI_COLORS_COUNT, 9
.set SHY_GUY_COLORS_COUNT, 9
.set INKLINGS_SKINS_COUNT, 3
.set BIRDO_COLORS_COUNT, 9

STP X29, X30, [SP, #-0x30]!
STP X0, X1, [SP, #0x10]
STR X8, [SP, #0x20]

ADR X1, drivers

loop:
LDRB W4, [X1]
CMP W4, #END_OF_LIST
BEQ end

CMP W4, W8
CINC X1, X1, NE
CINC X1, X1, NE
BNE loop

ADRP X0, #0x1301000
LDR X0, [X0, #0xE70]
LDR X0, [X0]
ADD X0, X0, #0x88
BL 0x62B5FC //; sead::Random::getU32(void)

LDRB W1, [X1, #1]
UDIV W2, W0, W1
MSUB W2, W2, W1, W0

end:
LDP X0, X1, [SP, #0x10]
LDR X8, [SP, #0x20]
LDP X29, X30, [SP], #0x30
MOV W3, WZR //; Original instruction
RET

drivers:
.byte DRIVER_YOSHI,	        YOSHI_COLORS_COUNT
.byte DRIVER_SHY_GUY,       SHY_GUY_COLORS_COUNT
.byte DRIVER_INKLING_GIRL,  INKLINGS_SKINS_COUNT
.byte DRIVER_INKLING_BOY,   INKLINGS_SKINS_COUNT
.byte DRIVER_BIRDO,         BIRDO_COLORS_COUNT
.byte END_OF_LIST