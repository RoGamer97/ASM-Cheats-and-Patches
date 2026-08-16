//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: Position in Battle

//; You can find some documented headers here to learn more about the game
//; and know some offsets: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are written over unused functions (never executed).
//; There is a bit of free space in .text, but for some reason the emulator
//; crashes when executing code in that space. Writing over unused functions
//; doesn't cause a crash.


//; Create position in Battle
//; ui::Page_RaceView::bindWindowLayout_(ui::Control_RaceView *,ui::RaceWindow *) + 0xD4 (Not a hook)
//; 0x544820 -> NOP
//; NOP the AND operation on the loaded gamemode.
//; The game ANDs the loaded gamemode with ~1 (NOT of 1, 0xFFFFFFFE) and then 
//; checks if the result is 2, skipping position creation if so. 
//; This is a compiler optimization causing both Time Trials (2) and Battle (3) 
//; to use the same value for the compare (3 becomes 2 because 1 was cleared).
//; By NOPing the AND, the Battle value is unaffected, so it will then only branch
//; to skip creation in Time Trials, and not in Battle.


//; Move minimap up in Battle
//; ui::Page_Race::createMap_(void) + 0xB4
//; 0x52F394 -> BL 0xAAFC90

//; Moves the minimap up in Battle by adding
//; 90.0 to the Y position


//; Register reference:
//; X19 = ui::Page_Race*


.SET RACERULE_BATTLE, 3

STP X29, X30, [SP, #-0x10]!

BL 0x87C244 //; gear::GetRaceInfo(void)
LDR W8, [X0, #8]
CMP W8, #RACERULE_BATTLE
BNE end

LDR S0, [X19, #0x340]
LDR S1, height
FADD S0, S0, S1
STR S0, [X19, #0x340]

end:
LDP X29, X30, [SP], #0x10
LDR X8, [X19, #0x328] //; Original instruction
RET
height: .float 90