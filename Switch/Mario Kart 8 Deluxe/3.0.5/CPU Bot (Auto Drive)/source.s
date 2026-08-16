//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: CPU Bot (Auto Drive)

//; You can find some documented headers here to learn more about the game
//; and know some offsets: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are written over unused functions (never executed).
//; There is a bit of free space in .text, but for some reason the emulator
//; crashes when executing code in that space. Writing over unused functions
//; doesn't cause a crash.


//; object::KartVehicle::calcXluAlpha_(void) + 0x14
//; 0x177104 -> BL 0x89A94

//; Changes local players karts to CPU

//; Register reference:
//; X19 = object::KartVehicle*

MOV X19, X0 //; Original instruction

STP X29, X30, [SP, #-0x10]!

LDRB W8, [X19, #0xD0]
CBZ W8, end //; Not local player kart

LDRB W8, [X19, #0xD2]
CBNZ W8, end //; Already a CPU

LDR X0, [X19, #8]
MOV W1, WZR
BL 0x16C478 //; object::KartUnit::changeToCpu(bool)

end:
LDP X29, X30, [SP], #0x10
RET