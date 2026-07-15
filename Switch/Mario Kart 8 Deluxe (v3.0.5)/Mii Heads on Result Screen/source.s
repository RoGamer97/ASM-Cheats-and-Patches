//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: Mii Heads on Result Screen

//; You can find some documented headers here to learn more about the game: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are placed in free space in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


//; ui::Control_RaceResultPanel::setDriverID(mush::EDriverID, int, unsigned char, bool) + 0x38
//; 0x51CEC0 -> BL 0xB51590

//; Skip code if offline mode

//; Override the loaded character ID Mii's ID so
//; minimap icon is mii face, but only if player is 
//; not a CPU (For Friend Rooms and Tournament)

.set DRIVER_MII, 0x1D

STP X29, X30, [SP, #-0x20]!
STR W0, [SP, #0x10]

BL 0x87C244 //; gear::GetRaceInfo

LDR W8, [X0]
CBZ W8, original //; Offline mode

MOV W0, W21
BL 0x85F9A0 //; gear::NetworkUtil::isCPU(int)

MOV W8, DRIVER_MII
CBZ W0, end //; Not a CPU

original:
LDR W8, [X23] //; Original instruction

end:
LDR W0, [SP, #0x10]
LDP X29, X30, [SP], #0x20
RET