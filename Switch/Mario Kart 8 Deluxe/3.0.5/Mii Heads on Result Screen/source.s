//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: Mii Heads on Result Screen

//; You can find some documented headers here to learn more about the game
//; and know some offsets: https://github.com/fishguy6564/MK8DX-Headers

<<<<<<< HEAD:Switch/Mario Kart 8 Deluxe/3.0.5/Mii Heads on Result Screen/source.s
// Hooks are written over unused functions (never executed).
// There is a bit of free space in .text, but for some reason the emulator
// crashes when executing code in that space. Writing over unused functions
// doesn't cause a crash.
=======
//; Hooks are written in unused functions because there is no space left in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*
>>>>>>> ba5ad483375f4e5cc4ea3a7d358921b18d444f5a:Switch/Mario Kart 8 Deluxe (v3.0.5)/Mii Heads on Result Screen/source.s


//; ui::Control_RaceResultPanel::setDriverID(mush::EDriverID, int, unsigned char, bool) + 0x38
//; 0x51CEC0 -> BL 0x62F85C

//; Skip the code if offline mode

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

MOV W8, #DRIVER_MII
CBZ W0, end //; Not a CPU

original:
LDR W8, [X23] //; Original instruction

end:
LDR W0, [SP, #0x10]
LDP X29, X30, [SP], #0x20
RET