//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: Course Music Speedup on Final Lap

//; You can find some documented headers here to learn more about the game
//; and know some offsets: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are written over unused functions (never executed).
//; There is a bit of free space in .text, but for some reason the emulator
//; crashes when executing code in that space. Writing over unused functions
//; doesn't cause a crash.


//; Continue playing normal lap music in final lap and store bool for speedup 
//; audio::AudSceneRace::changeRaceStateBgm_(void) + 0x9C and 0xA0 (Not a hook)
//; 0x9E808 -> MOV W8, #1
//; 0x9E80C -> STRB W8, [X19, #0x227]
//; Prevents final lap music from playing by replacing argument and BL call to
//; audio::AudBgmRace::setBgmVolume(float, int) with a bool store to audio::AudBgmRace* + 0x227.
//; AudBgmRace* + 0x227 is a padding byte, so store a bool there to determine if music speedup
//; should happen
 
 
//; Fix music based objects freeze bug
//; audio::AudSceneRace::changeRaceStateBgm_(void) + 0x20 (Not a hook)
//; 0x9E78C -> NOP
//; NOP the audio::AudBgmRace::changeRaceStateBgm(audio::AudSceneRace::ERaceState)
//; call to avoid changing the race BGM state. When preventing the final lap music
//; from playing, objects that move based on music will freeze because of race BGM
//; state, so preventing it from changing fixes this issue 



//; Music speedup on final lap
//; audio::AudBgmRace::calcChangeByLapNum_(void) + 0x14
//; 0x832B4 -> BL 0xAAFE84

//; If the bool stored at audio::AudBgmRace* + 0x227 is true, speedup
//; music by incrementing its speed by 0.0002 until it
//; reaches ~1.1. Once reached, set bool to false to stop speedup

//; Will not apply to GCN Baby Park. For that course, the music
//; will speedup in the final lap like any normal lap does instead

//; Register reference:
//; X19 = audio::AudBgmRace*


MOV X19, X0 //; Original instruction

LDRB W8, [X19, #0x227]
CBZ W8, end //; Not final lap

LDR S0, maxSpeed
LDR S1, incrementSpeed

LDR S2, [X19, #0x220]
FADD S2, S2, S1
FCMP S2, S0
BLT store

STRB WZR, [X19, #0x227]

store:
STR S2, [X19, #0x220]

end:
RET
maxSpeed: .float 1.1
incrementSpeed: .float 0.0002


//; Allow final lap music speedup on GCN Baby Park
//; audio::AudBgmRace::calcChangeByLapNum_(void) + 0x11C (Not a hook)
//; 0x833BC -> NOP
//; NOP the branch that skips GCN Baby Park's music speedup
//; on final lap