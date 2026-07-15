//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: Mii Heads on Minimap

//; You can find some documented headers here to learn more about the game: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are placed in free space in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


//; ui::Control_RaceDRCCharaIcon::setDriverID(mush::EDriverID,int,uchar,bool) + 0x150
//; 0x507778 -> BL 0xB51564

//; Skip code if offline mode

//; Override the loaded character ID Mii's ID so
//; minimap icon is mii face, but only if player is 
//; not a CPU (For Friend Rooms and Tournament)

.set DRIVER_MII, 0x1D

STP X29, X30, [SP, #-0x10]!

BL 0x87C244 //; gear::GetRaceInfo

LDR W8, [X0]
CBZ W8, original //; Offline mode

LDR W0, [X19, #0xB4]
BL 0x85F9A0 //; gear::NetworkUtil::isCPU(int)

MOV W8, DRIVER_MII
CBZ W0, end //; Not a CPU

original:
LDR W8, [X23] //; Original instruction

end:
LDP X29, X30, [SP], #0x10
RET