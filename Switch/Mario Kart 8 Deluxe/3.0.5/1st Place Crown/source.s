//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: 1st Place Crown

//; You can find some documented headers here to learn more about the game: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are written over unused functions (never executed).
//; There is a bit of free space in .text, but for some reason the emulator
//; crashes when executing code in that space. Writing over unused functions
//; doesn't cause a crash.


//; Create and setup crown model anywhere
//; object::DriverKart::createCrown_(void) + 0x2C (Not a hook)
//; 0xD5684 -> MOV W9, #1
//; Overrides the loaded kart's isBattle bool with true to avoid branching
//; to function's end in race (Skips kart crown calculation)


//; Calculate kart crown in race, but not in Time Trials
//; object::KartDirector::calcCrownVisible_(void) + 0x20 and 0x24 (Not a hook)
//; 0x13DF24 -> CMP W8, #2
//; 0x13DF28 -> BEQ 0x13E08C
//; Replaces the Battle check and branch to function's end if not equal
//; with check for Time Trials and branch to function's end if equal,
//; to make the function run in race but not in Time Trials, to calculate
//; if karts should have crown or not in both races and battles


//; Crown in 1st place
//; object::KartDirector::calcCrownVisible_(void) + 0x160
//; 0x13DF24 -> BL 0x89A0C

//; Makes the kart in first place have a crown

//; At this location, W0 is a returned bool from
//; object::RaceCheckerBase::isCrownedKart(int)

//; Skip the code if kart's isBattle bool is true, for
//; default behavior in Battle

//; The kart's crown flag is set if the bool is true,
//; and cleared if false

//; Load the kart's current rank position from gear::RaceKartChecker* and
//; override the boolean with true if the kart is in 1st place, and false
//; otherwise


//; Register reference:
//; W0 = isCrownedKart bool (Input and output)
//; X20 = gear::RaceCheckerBase*
//; X22 = object::KartVehicle*


.set RANK_1ST_PLACE, 0

LDRB W8, [X22, #0xE3]
CBNZ W8, end //; Battle Mode

LDR X8, [X20, #0x28]
LDR X8, [X8, #0x68]
LDR X8, [X8,X21,LSL#3] //; gear::RaceKartChecker*
LDR W8, [X8, #0x40]
CMP W8, #RANK_1ST_PLACE
CSET W0, EQ

end:
LDR W8, [X22, #0x1CC] //; Original instruction
RET