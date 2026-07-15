//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: CPU Bot (Auto Drive)

//; You can find some documented headers here to learn more about the game: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are placed in free space in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


//; object::KartVehicle::calcXluAlpha_(void) + 0x14
//; 0x177104 -> BL 0xB513E8

//; Changes local players' kart to CPU

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