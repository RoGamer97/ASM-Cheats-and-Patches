//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: Show HUD Before Countdown

//; You can find some documented headers here to learn more about the game
//; and know some offsets: https://github.com/fishguy6564/MK8DX-Headers

<<<<<<< HEAD:Switch/Mario Kart 8 Deluxe/3.0.5/Show HUD Before Countdown/source.s
// Hooks are written over unused functions (never executed).
// There is a bit of free space in .text, but for some reason the emulator
// crashes when executing code in that space. Writing over unused functions
// doesn't cause a crash.
=======
//; Hooks are written in unused functions because there is no space left in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*
>>>>>>> ba5ad483375f4e5cc4ea3a7d358921b18d444f5a:Switch/Mario Kart 8 Deluxe (v3.0.5)/Show HUD Before Countdown/source.s


//; Invoke window layout on load
//; ui::Page_Race::onIn_(void) + 0x6C8
//; 0x530630 -> BL 0x7A26BC

//; Replicates the game's invoke window layout call but somewhere else that runs
//; on race load, to immediately show the HUD

//; Register reference:
//; X19 = ui::Page_Race*
//; X21 = Window ID


STP X29, X30, [SP, #-0x10]!

LDR W20, [X19, #0x350]
SUB W20, W20, #1

MOV W21, WZR

invokeLoop:
LDR X8, [X19, #0x358]
LDR X0, [X8,X21,LSL#3]
BL 0x54D738 //; ui::Page_Race::invokeWindowLayout_(void)

CMP W20, W21
CINC W21, W21, NE
BNE invokeLoop

end:
LDP X29, X30, [SP], #0x10
MOV W0, WZR //; Original instruction
RET


//; ui::Page_Race::onUpdateRun_(void) + 0x100 (Not a hook)
//; 0x530B64 -> MOV W8, #0
//; Override the loaded player count with zero. It branches to skip
//; calling ui::Page_Race::invokeWindowLayout_(void) if it's less
//; than 1. Done to avoid invoking the layout again (It plays 
//; the In animation again)


//; Instantly show HUD
//; ui::RaceWindow::invokeLayout(void) + 0x14 (Not a hook)
//; 0x54D74C -> MOV W8, #1
//; Change HUD appear delay from 360 frames (6 seconds) to one
//; frame (0 breaks) to make HUD elements like Lap, Coin, Timer
//; to appear instantly