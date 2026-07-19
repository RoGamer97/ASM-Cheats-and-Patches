//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: Replace "FINISH!" with "YOU WIN!" or "YOU LOSE" Based on Result

//; You can find some documented headers here to learn more about the game: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are written in unused functions because there is no space left in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


//; Add "YOU WIN!" and "YOU LOSE" textures to race (Automatically replaces FINISH! with YOU LOSE)
//; ui::Page_RaceViewFront::bindWindowLayout_(gear::UIControlT<eui::ControlBase> *,ui::RaceWindow *) + 0x114
//; 0x5457E0 -> BL 0x7A25EC

//; Overrides W25 with 2 to add textures, only if mode ID is less than Time Trials (Grand Prix and Versus)

.set RACERULE_TIME_TRIALS, 2

STP X29, X30, [SP, #-0x10]!

BL 0x87C244 //; gear::GetRaceInfo
LDR W8, [X0, #8]
CMP W8, #RACERULE_TIME_TRIALS
BGE end

MOV W25, #2

end:
LDP X29, X30, [SP], #0x10
ADD X8, X27, #0x14 //; Original instruction
RET


//; Change "FINISH" particle (yellow) to "YOU WIN!" particle (pink)
//; ui::RaceWindow::RaceWindow(int,gear::FrameworkWindow const*,ui::Page_Race *) + 0x21C
//; 0x54C4B8 -> BL 0x7A2610

//; Override loaded W0 value with 0 if mode ID is less than Time Trials (Grand Prix and Versus)
//; W0 is the ghost's index in the race. -1 if no ghost (Normal FINISH! particle), 0 if there's
//; a ghost (Pink FINISH! particle for YOU WIN!) - "YOU LOSE" has no particle by default

.set RACERULE_TIME_TRIALS, 2

STP X29, X30, [SP, #-0x20]!
STP X8, X9, [SP, #0x10]

MOV W1, W0

BL 0x87C244 //; gear::GetRaceInfo
LDR W8, [X0, #8]
CMP W8, #RACERULE_TIME_TRIALS
CSEL W1, W1, WZR, GE

MOV W0, W1

LDP X8, X9, [SP, #0x10]
LDP X29, X30, [SP], #0x20
CMP W0, #0 //; Original instruction
RET


//; Use "YOU WIN!" or "YOU LOSE" Based on Result
//; ui::RaceWindow::onFakeGoal(void) + 0xD8
//; 0x54C9A0 -> BL 0x7A2640

//; Set W20 bool (true for YOU WIN!, false for YOU LOSE) based on
//; goal result type (returning it from gear::RaceKartChecker::getGoalReactionByRank(int),
//; if mode ID is less than Time Trials (Grand Prix and Versus)

//; getGoalReactionByRank takes player ID as argument. There is no reliable way to get 
//; the player ID of the kart who got the FINISH! message (For Multiplayer and online play). I tried
//; using game functions that supposely convert the window ID to player ID, but that didn't
//; work, so another trick is done: Get my player ID (kart index), which is always the first
//; local player, and increment it by the window ID to get the proper player ID for the other
//; local players in Multiplayer (Local player IDs are always sequencial)

//; getMyKartIndex returns -1 offline. Change it to
//; 0 if this is the case since your ID is always
//; 0 offline.

//; Register reference:
//; X19 = ui::RaceWindow*


.set RACERULE_TIME_TRIALS, 2

.set GOALREACTION_LOSE, 2

STP X29, X30, [SP, #-0x20]!

MOV W20, WZR //; Original instruction

BL 0x87C244 //; gear::GetRaceInfo
LDR W8, [X0, #8]
CMP W8, #RACERULE_TIME_TRIALS
BGE end

BL 0x85EEB8 //; gear::NetworkUtil::getMyKartIndex(void)
CMP W0, #-1
CSEL W0, WZR, W0, EQ
LDR W8, [X19]
ADD W1, W0, W8

BL 0x7F41FC //; gear::FrameworkUtil::getCurrentGameScene(void)
LDR X8, [X0, #0x1B0]
LDR X8, [X8, #0x218]
LDR X8, [X8, #0x68]
LDR X8, [X8,X1,LSL#3] //; gear::RaceKartChecker*
LDR W0, [X8, #0x40]
ADD X8, SP, #0x10
BL 0x87CDB8 //; gear::RaceKartChecker::getGoalReactionByRank(int)
LDR W8, [SP, #0x10]
CMP W8, #GOALREACTION_LOSE
CSET W20, NE

end:
LDP X29, X30, [SP], #0x20
RET

//; Disable "YOU LOSE" finish particle in race
//; ui::RaceWindow::onFakeGoal(void) + 0x1FC (Not a hook)
//; 0x54CAC4 -> BLE 0x54CBCC 
//; Replace BEQ with BLE to branch in GP and VS too. It checks for Time Trials and
//; branches if so skip emitter particle when result is "YOU LOSE". Changing it to BLE
//; makes it hide it on GP and VS too because the IDs are lower than TTs ID
