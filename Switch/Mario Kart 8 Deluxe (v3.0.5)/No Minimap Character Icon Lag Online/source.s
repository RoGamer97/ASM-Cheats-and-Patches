//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: No Minimap Character Icon Lag Online

//; You can find some documented headers here to learn more about the game: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are written in unused functions because there is no space left in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


//; ui::Control_RaceDRCCharaIcon::onCalc_(void) + 0x30
//; 0x50718C -> BL 0x62F95C

//; Other players' icons freeze on the minimap for ~3 seconds when
//; Lakitu grabs them or they warp by lag (position correction).
//; The game sets the "isAfterOnResetPosition" member variable bool to 
//; true (KartVehicle), and unsets it after 3 seconds.

//; If removing the freeze entirely, when someone goes OOB, their icon will
//; teleport to the point they'll respawn, which isn't really correct, so the fix here
//; is to make the icon only frozen if they're being grabbed by Lakitu, and not bool
//; (timer) based. Icon will not freeze when player warps, and will unfreeze when they
//; finally respawn.

//; Only check for Lakitu respawn for net receive kart, to avoid freezing icon for local
//; players and CPUs (Bool will be false because of isNetRecv call result)

//; Register reference:
//; X19 = ui::Control_RaceDRCCharaIcon*


STP X29, X30, [SP, #-0x10]!

BL 0x140A4C //; object::KartInfoProxy::isNetRecv(void)
CBZ W0, end //; Not net receive kart

LDR X0, [X19, #0xB8]
BL 0x140A30 //; object::KartInfoProxy::isJugemHang(void)

end:
LDP X29, X30, [SP], #0x10
RET