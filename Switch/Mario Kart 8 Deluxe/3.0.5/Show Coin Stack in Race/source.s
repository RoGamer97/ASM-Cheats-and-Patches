//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: Show Coin Stack in Race

//; You can find some documented headers here to learn more about the game
//; and know some offsets: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are written over unused functions (never executed).
//; There is a bit of free space in .text, but for some reason the emulator
//; crashes when executing code in that space. Writing over unused functions
//; doesn't cause a crash.

//; Create and setup Battle coin models anywhere
//; object::KartChassis::KartChassis(object::KartVehicle *, gear::RaceKartInfo const&, bool, bool, bool, bool) + 0xAEC
//; 0x11B8C0 -> MOV W8, #0
//; Override the loaded Battle type with Coin, to enable Coin models


//; Create object::KartBattleCoinEffect anywhere (Part 1)
//; object::KartChassisEffect::KartChassisEffect(object::KartVehicle *,gsys::Model *,gsys::Model *,gsys::ModelUnit *,gear::RaceKartInfo const&,int,repl::Recorder *) + 0xFC
//; 0x124740 -> BL 0x7A26A0

//; Creates object::KartBattleCoinEffect in race for coin collect particle

//; Avoid creating it in the menu because it crashes

//; Done by overriding the kart's isBattle bool with false if in menu, and
//; true otherwise

//; Register reference:
//; W8 = Kart's isBattle bool (Input and output)


.set RACERULE_MENU, 5

STP X29, X30, [SP, #-0x10]!

BL 0x87C244 //; gear::GetRaceInfo(void)
LDR W8, [X0, #8]
CMP W8, #RACERULE_MENU
CSET W8, NE

LDP X29, X30, [SP], #0x10
RET


//; Create object::KartBattleCoinEffect anywhere (Part 2)
//; object::KartChassisEffect::KartChassisEffect(object::KartVehicle *,gsys::Model *,gsys::Model *,gsys::ModelUnit *,gear::RaceKartInfo const&,int,repl::Recorder *) + 0x120
//; 0x124764 -> MOV W8, #0
//; Override the loaded kart's battle type with Coin Runners (0) to create object::KartBattleCoinEffect anywhere