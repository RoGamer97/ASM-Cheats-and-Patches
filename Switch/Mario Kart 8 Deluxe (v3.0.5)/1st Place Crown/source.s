//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: 1st Place Crown

//; You can find some documented headers here to learn more about the game: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are placed in free space in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


//; Create crown model in race
//; object::DriverKart::createCrown_(void) + 0x2C (Not a hook)
//; 0xD5684 -> MOV W9, #1
//; Overrides the loaded kart's isBattle bool to true avoid branching to function's
//; end, to create the crown model in race


//; Calculate crown visibility in races but not in Time Trials
//; object::KartDirector::calcCrownVisible_(void) + 0x20 and 0x24 (Not a hook)
//; 0x13DF24 -> CMP W8, #2
//; 0x13DF28 -> BEQ 0x13E08C
//; Replace Battle check and branch to function's end if so
//; with check for Time Trials and branch to function's end if so,
//; to make function run in race but not Time Trials, to calculate
//; if kart should have crown or not


//; Crown in 1st place
//; object::KartDirector::calcCrownVisible_(void) + 0x160
//; 0x13DF24 -> BL 0xB51120

//; Makes kart in first place have a crown

//; Skip code if the kart's isBattle bool is true

//; At this location, W0 is a returned bool from
//; object::RaceCheckerBase::isCrownedKart(int)

//; Load kart's rank position from RaceKartChecker and
//; override the bool result based if kart is in 1st or not


LDRB W8, [X22, #0xE3]
CBNZ W8, end //; Battle Mode

LDR X8, [X20, #0x28]
LDR X8, [X8, #0x68]
LDR X8, [X8,X21,LSL#3]
LDR W8, [X8, #0x40]
CMP W8, #0 //; 1st
CSET W0, EQ

end:
LDR W8, [X22, #0x1CC] //; Original instruction
RET