//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: Show More Kart Status Effects on Minimap

//; You can find some documented headers here to learn more about the game
//; and know some offsets: https://github.com/fishguy6564/MK8DX-Headers

// Hooks are written over unused functions (never executed).
// There is a bit of free space in .text, but for some reason the emulator
// crashes when executing code in that space. Writing over unused functions
// doesn't cause a crash.


//; ui::Control_RaceDRCCharaIcon::onCalc_(void) + 0x14
//; 0x507170 -> BL 0x7A26F0

//; Load the kart's X and Y scales and cap ther minimum
//; and maximum scale, and store it to the minimap character
//; icons to make the icon match the kart scale. Capping it
//; to prevent a very small icon if shocked or squished, and
//; maximum one is just for safety

//; Copy the kart's alpha the minimap icon too, but kart's one
//; is float and minimap is int, so convert float to int. Don't
//; do it if kart is a ghost from Time Trials to avoid transparent
//; ghost icon

//; Change character icon material color icon to black if inked

//; Register reference:
//; X19 = ui::Control_RaceDRCCharaIcon*


//; Little endian, bytes are inverted
.set WHITE_RGBA, 0xFFFFFFFF
.set BLACK_RGBA, 0xFF000000

MOV X19, X0 //; Original instruction

LDR X8, [X19, #0xB8]
LDR X8, [X8, #0x48]
LDR X9, [X19, #0xD8] //; Character icon

LDR S0, [X8, #0x110]
LDR S1, [X8, #0x114]

LDR S2, minScale

FCMP S0, S2
FCSEL S0, S2, S0, LE

FCMP S1, S2
FCSEL S1, S2, S1, LE

LDR S2, maxScale

FCMP S0, S2
FCSEL S0, S2, S0, GE 

FCMP S1, S2
FCSEL S1, S2, S1, GE

STP S0, S1, [X9, #0x48] //; Character icon size

LDR X0, [X19, #0xE0]
STP S0, S1, [X0, #0x48] //; Character icon round size

LDR X0, [X19, #0xF0]
STP S0, S1, [X0, #0x48] //; Crown size

LDR X0, [X19, #0x100]
CBZ X0, isGhost
STP S0, S1, [X0, #0x48] //; Searchlight size

isGhost:
LDRB W0, [X8, #0xD4]
CBNZ W0, gessoColor //; Time Trials Ghost

LDR S0, [X8, #0x278]
LDR S1, alphaScaleFactor
FMUL S0, S0, S1
FCVTZS W0, S0
STRB W0, [X9, #0x59]

gessoColor:
MOV W12, #WHITE_RGBA
MOV W13, #BLACK_RGBA

LDR W0, [X8, #0x1E8]
CMP W0, #0
CSEL W12, W13, W12, NE
STR W12, [X9, #0x13C]

end:
RET
minScale: .float 0.4
maxScale: .float 1.2
alphaScaleFactor: .float 255