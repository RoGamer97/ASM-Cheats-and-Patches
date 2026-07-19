//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: 'NO COM' CPU Option in Singleplayer

//; You can find some documented headers here to learn more about the game: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are placed in free space in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


//; Enable 'NO COM' CPU Option in Singleplayer
//; ui::Control_RuleList::updateList(ui::Control_RuleList::EType) + 0x1D40 (Not a hook)
//; 0x46340C -> MOV W1, #0
//; Overrides returned bool from ui::IsMenuSingle(void) to false. It is passed as argument for 
//; ui::Rule_COM::setSingle(bool) to enable or disable the 'NO COM' option


//; Prevent Battle finishing at start when alone
//; object::RaceBattleChecker::isRaceFinished_(void) + 0x328
//; 0x39A794 -> BL 0xB519D8

//; When being alone in a Battle, it finishes instantly after starting.

//; Prevent this if racer amount is 1 by overriding the value it checks
//; with 2 (It sets the end bool to true if less than 2)

// Register reference:
//; X19 = object::RaceBattleChecker*


STP X29, X30, [SP, #-0x10]!

BL 0x87C244 //; gear::GetRaceInfo(void)

LDR W8, [X19, #0x100] //; Original instruction
MOV W10, #2

LDR W9, [X0, #0x180]
CMP W9, #1
CSEL W8, W10, W8, EQ

end:
LDP X29, X30, [SP], #0x10
RET