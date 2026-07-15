//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: Show Coin Stack in Race

//; You can find some documented headers here to learn more about the game: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are placed in free space in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*

//; Construct and setup Battle coin models and stuff anywhere
//; object::KartChassis::KartChassis(object::KartVehicle *, gear::RaceKartInfo const&, bool, bool, bool, bool) + 0xAEC
//; 0x11B8C0 -> MOV W8, #0
//; Override the loaded Battle type with Coin, to enable Coin models


//; Fix race crash
//; object::KartBattleCoinEffect::emitBattleCoinGet(sead::Vector3<float> const&) + 0x1C
//; 0x131974 -> BL 0xB51148

//; Coin stack crashes in race, likely because it lacks the coin emit particle

//; If X21 is null pointer, 

CBNZ X21, end

ADD X30, X30, #0x50
RET

end:
LDR X8, [X21, #0x80]!
RET