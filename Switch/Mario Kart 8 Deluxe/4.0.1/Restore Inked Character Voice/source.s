//; Game: Mario Kart 8 Deluxe
//; Game version: 4.0.1
//; Code: Restore Inked Character Voices

//; You can find some documented headers here to learn more about the game: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are written over unused functions (never executed).
//; There is a bit of free space in .text, but for some reason the emulator
//; crashes when executing code in that space. Writing over unused functions
//; doesn't cause a crash.


//; gear::ItemObjGesso::stateAttack(void) + 0x68
//; 0x281F8 -> BL 0xAB4EEC  

//; Requests the inked character voice when kart
//; is inked by Blooper. Hooked right before
//; object::KartInfoProxy::startGesso(void) call

//; Unlike Mario Kart 8 Wii U, the game doesn't
//; request the voice when inked, but code for
//; reading the request and playing the voice
//; is still present

//; Register reference:
//; X19 = gear::ItemObjGesso*
//; W20 = Attacked kart player ID

.set TRGKARTSE_DRIVER_INKED, 0x21

STP X29, X30, [SP, #-0x10]!

MOV X0, X19
MOV W1, W20
BL 0x1120C //; gear::ItemObjBase::getKartInfo(int)
BL 0x142764 //; object::KartInfoProxy::getSoundActor(void)
MOV W1, #TRGKARTSE_DRIVER_INKED
MOV W2, WZR
MOV W3, WZR
BL 0xB0E80 //; audio::AudSoundObjKart::requestTrgKartSE(audio::AudSoundObjKart::ETrgKartSE,int,int)

LDP X29, X30, [SP], #0x10
MOV X0, X19 //; Original instruction
RET