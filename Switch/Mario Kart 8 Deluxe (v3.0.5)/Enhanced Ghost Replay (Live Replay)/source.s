//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: Enhanced Ghost Replay (Live Replay)

//; You can find some documented headers here to learn more about the game: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are placed in free space in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


//; Disable replay ghost transparency
//; object::KartVehicle::KartVehicle(int, object::KartUnit *, gear::ResourceKartBase const&, float) + 0x798
//; 0x16ECBC -> BL 0xB51188

//; Override the loaded "isGhost" bool to false for replay ghost only
//; (Ghost player ID is 0 when being watched, and 1 when being raced against)

//; Register reference:
//; X19 = object::KartVehicle*


LDRB W8, [X19, #0xD4] //; Original instruction

LDR W9, [X19, #0xA8]
CMP W9, #0
CSEL W8, WZR, W8, EQ
RET


//; Fix start transparency fade
//; object::KartVehicle::calcXluAlpha_(void) + 0x1C
//; 0x17710C -> BL 0xB5119C

//; Fixes an issue where the ghost is still transparent and fades
//; to opaque at the start of the replay by forcing opaque alpha.
//; Same logic as the code above to only affect replay ghost

//; Register reference:
//; X19 = object::KartVehicle*


LDR S0, [X19, #0x278] //; Original instruction

LDRB W9, [X19, #0xD4]
CBZ W9, end //; Not a ghost

LDR W9, [X19, #0xA8]
CBNZ W9, end //; Not player ID 0

FMOV S0, #1.0

end:
RET


//; Replay ghost has player minimap round
//; ui::Control_RaceDRCCharaIcon::setupVisible + 0x30
//; 0x506F78 -> BL 0xB511B8

//; Replay ghost will have player minimap icon round.

//; Overrides the loaded player type to player for
//; ghost if racer amount is 1 (Only ghost present = Replay)

//; Register reference:
//; X8 = gear::RaceKartInfo*
//; X0 = gear::RaceInfo*


.set PLAYERTYPE_GHOST, 3

LDR W22, [X8, #0x44] //; Original instruction
CMP W22, PLAYERTYPE_GHOST
BNE end

LDR W8, [X0, #0x180]
CMP W8, #1
CSEL W22, WZR, W22, EQ

end:
RET