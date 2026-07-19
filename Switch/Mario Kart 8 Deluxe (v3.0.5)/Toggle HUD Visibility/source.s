//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: Toggle HUD Visibility

//; You can find some documented headers here to learn more about the game: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are written in unused functions because there is no space left in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


//; gear::UIEngine::onCalc_(void) + 0xE0 (Unsure if this is actually the function!)
//; 0x3FDD50 -> BL 0x7A27E4

//; Toggles the HUD visible bool by holding Y and pressing D-Pad Up

STP X29, X30, [SP, #-0x10]!

MOV W0, WZR
BL 0x8B94A4 //; gear::GetControllerRace(int)
LDR X0, [X0, #0x158]

LDR W8, [X0, #0x114]
TBZ W8, #4, end //; Y button not held

LDR W8, [X0, #8]
TBZ W8, #16, end //; D-Pad Up not triggered

LDRB W8, [X19, #0xAA]
EOR W8, W8, #1
STRB W8, [X19, #0xAA]

end:
LDP X29, X30, [SP], #0x10
LDR X0, [X19, #0xC0]
RET