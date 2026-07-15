//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: Show HUD Before Countdown

//; You can find some documented headers here to learn more about the game: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are placed in free space in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


//; Invoke window layout on load
//; ui::Page_Race::onIn_(void) + 0x6C8
//; 0x530630 -> BL 0xB51414

//; Replicates the game's invoke window layout call but somewhere else that runs
//; on race load, to immediately show the HUD

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