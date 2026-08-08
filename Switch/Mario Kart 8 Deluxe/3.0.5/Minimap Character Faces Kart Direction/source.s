//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: Minimap Character Faces Kart Direction

//; You can find some documented headers here to learn more about the game
//; and know some offsets: https://github.com/fishguy6564/MK8DX-Headers

// Hooks are written over unused functions (never executed).
// There is a bit of free space in .text, but for some reason the emulator
// crashes when executing code in that space. Writing over unused functions
// doesn't cause a crash.


//; Calculate arrow direction anywhere
//; ui::Control_RaceDRCCharaIcon::onCalc_(void) + 0x1B4 (Not a hook)
//; 0x506F7C -> MOV W8, #1
//; Overrides loaded arrow direction icon pointer with true
//; to calculate direction even if arrow is disabled (nullptr)

//; Store arrow rotation to character icon
//; ui::Control_RaceDRCCharaIcon::onCalc_(void) + 0x1F4
//; 0x507350 -> BL 0x62F91C

//; Loads the calculated arrow rotation and stores it to
//; character icon rotation (Replicate add logic)

//; If arrow icon is nullptr, skip storing rotation to it
//; to avoid crash by skipping part of the code

//; Register reference:
//; X19 = ui::Control_RaceDRCCharaIcon*


LDR X9, [X19, #0xD8]
FADD S1, S0, S2
STR S1, [X9, #0x44]

LDR X8, [X19, #0x100] //; Original instruction
CBNZ X8, end

ADD X30, X30, #0x18

end:
RET


//; Fix wrong direction in Mount Wario and BCP courses
//; ui::Control_RaceMiniMap::loadMap(void) + 0x600
//; 0x504A98 -> BL 0x62F894

//; In Mount Wario and every Booster Course Pass DLC course, the
//; arrow direction is wrong at all times.

//; This is because of a param value found in the course_mapcamera.bin file.
//; The Unk2 setting is 1.0 for every course, -1.0 for Mount Wario, and 0.0 for BCP courses

//; Changing it to 1.0 fixes the issue in BCP, but in Mount Wario, it breaks the minimap and inverts
//; it. Changing this value by code after it has been used for the minimap position avoids breaking the
//; minimap in Mount Wario, but the rotation is still wrong.
//; I was able to fix it by changing Unk1, Unk2 and Unk3 to 1.0

//; So what is being done here is: 
//; If Unk2 is -1.0, change Unk1 and Unk3 to 1.0 (Mount Wario)
//; If Unk1 is less than 1.0, change it to 1.0

//; In Mirror Mode, they're inverted, so fix it by inverting the values

//; Thanks to Max_XD/Varnat for letting me know about the Unk2 value

//; Register reference:
//; X19 = ui::Control_RaceMiniMap*
 
 
STP X29, X30, [SP, #-0x10]!

LDR S0, [X19, #0x388]
LDR S1, [X19, #0x38C]
LDR S2, [X19, #0x390]

FMOV S3, #1.0
FMOV S4, #-1.0

FCMP S1, S4
FCSEL S0, S3, S0, EQ
FCSEL S2, S3, S2, EQ

FCMP S1, S3
FCSEL S1, S3, S1, LT

BL 0x87C244 //; gear::GetRaceInfo(void)
LDRB W8, [X0, #0x26]
CBZ W8, store //; Not mirror mode

FNEG S0, S0
FNEG S1, S1
FNEG S2, S2

store:
STR S0, [X19, #0x388]
STR S1, [X19, #0x38C]
STR S2, [X19, #0x390]

LDP X29, X30, [SP], #0x10
LDP D9, D8, [SP, #0x80] //; Original instruction
RET