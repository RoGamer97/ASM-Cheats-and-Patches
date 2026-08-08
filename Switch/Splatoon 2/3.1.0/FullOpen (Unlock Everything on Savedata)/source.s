//; Game: Splatoon 2
//; Game version: 3.1.0
//; Code: FullOpen


// Hooks are written over unused functions (never executed).
// There is a bit of free space in .text, but for some reason the emulator
// crashes when executing code in that space. Writing over unused functions
// doesn't cause a crash.


//; Boot::Scene::loadSaveData + 0x2D8
//; 01230E34 -> BL 0x1B610C8

//; Calls savedata function that unlocks everything, sets everything to max etc


//; Register reference:
//; X21 = Cmn::SaveData*


STP X29, X30, [SP, #-0x10]!

MOV X0, X21
BL 0x18F0FC //; Cmn::SaveData::fullOpen(void)

LDP X29, X30, [SP], #0x10
LDR X19, [X21, #0x18] //; Original instruction
RET