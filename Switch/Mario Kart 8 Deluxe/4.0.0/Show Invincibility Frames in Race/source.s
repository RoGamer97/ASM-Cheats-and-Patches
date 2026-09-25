//; Game: Mario Kart 8 Deluxe
//; Game version: 4.0.0
//; Code: Show Invincibility Frames in Race

//; You can find some documented headers here to learn more about the game
//; and know some offsets: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are written over unused functions (never executed).
//; There is a bit of free space in .text, but for some reason the emulator
//; crashes when executing code in that space. Writing over unused functions
//; doesn't cause a crash.


//; Allow battle blinking in race (Visual)
//; object::KartVehicle::calcXluAlpha_(void) + 0x58 and 0x5C (Not a hook)
//; 0x178484 -> LDRB W9, [X19, #0xD4]
//; 0x178488 -> CBNZ W9, 0x17854C
//; Replace kart's "isBattle" check that skips the blinking code if it's
//; not Battle with "isGhost" check to skip blinking code if kart is a
//; Time Trials ghost (Makes blinking code execute in races but not for
//; TT ghost, to avoid an issue where ghost is not transparent)


//; Battle blinking when having invincibility frames (Visual)
//; object::KartVehicle::calcXluAlpha_(void) + 0x70
//; 0x17849C -> BL 0xAB4300

//; ORR Battle blinking frames with invincibility frames to make
//; kart blink in both occasions. The game checks if the timer is
//; < 1 and skips visual blinking if so


//; Register reference:
//; X19 = object::KartVehicle*


LDR W8, [X19, #0x248] //; Original instruction
LDR W9, [X19, #0x298]
ORR W8, W8, W9
RET