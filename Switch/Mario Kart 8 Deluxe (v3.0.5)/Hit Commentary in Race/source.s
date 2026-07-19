//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: Hit Commentary in Race

//; You can find some documented headers here to learn more about the game: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are placed in free space in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


//; Show hit commentary in damage logic
//; object::KartVehicleReact::reactAccidentCommonRace_(object::KartVehicleReact::ECallType,gear::EItemType,int,object::KartVehicleReact::EAcdType,gear::MtxT const*,sead::Vector3<float> const*,sead::Vector3<float> const*) + 0x150
//; 0x192F88 -> BL 0xB5121C

//; This part of the function where the code is hooked will only execute in race

//; It executes for every damage type, W23 is the player ID who attacked.
//; If it's -1, damage was not dealt by kart or item, skip the code

//; Skip the code if in Multiplayer

//; Don't show hit commentary if player hit their own item or if player who attacked
//; or got attacked isn't local player

//; If attacked by local player Lightning, don't show hit commentary (Because it only
//; shows the commentary for the last player that was shocked), but show it if attacked 
//; by someone's Lightning

//; Set commentary type to "Renegade Roundup catch" because "Battle hit commentary" is not created
//; in race, would need position adjustments and other changes, plus, Renegade one looks better

//; By default, the message shown is "(RED NAME) caught (BLUE NAME)".
//; It's changed to "Hit (NAME OF WHO GOT ATTACKED)" or "(NAME OF WHO ATTACKED) hit you" in another
//; hook

//; ui::CommentaryArg (0 = Commentary type, 4 = Player ID that busted, 8 = Player ID that got caught)

//; The player IDs are used for the character name for the message ("NAME caught NAME")
//; But since message will be changed to "NAME hit you" or "You hit NAME", only the first player ID is needed.
//; So if I'm the attacker, pass the player ID of the attacked kart, and if I get attacked, pass the player
//; ID of the attacker kart.
//; Since 8 is not needed because there is only 1 name in the message, I will use it as a way to identify
//; if I attacked someone or if I got attacked, for the message replacement hook. I'll call it the attack type.

//; Register reference:
//; X22 = object::KartVehicle* of attacked kart
//; W23 = Player ID of attacker kart
//; X24 = gear::EItemType*


.set ITEMTYPE_THUNDER, 6

.set YOU_HIT, 0
.set HIT_YOU, 1

STP X29, X30, [SP, #-0x20]!

CMP W23, #-1
BEQ end //; Damage not dealt by kart or item

BL 0x87C244 //; gear::GetRaceInfo(void)
BL 0x87BC04 //; gear::RaceInfo::getMasterNumForWindow(void)
CMP W0, #1
BNE end

BL 0x7F41FC //; gear::FrameworkUtil::getCurrentGameScene(void)
LDR X8, [X0, #0x1B0]
LDR X8, [X8, #0x238]
LDR X8, [X8,#0xC8]
LDR X8, [X8,X23]
LDR X8, [X8, #8]
LDR X9, [X22, #0x10]

LDR W3, [X9, #0xA8]
CMP W3, W23
BEQ end //; Hit by own item

MOV W4, #YOU_HIT

LDRB W10, [X8, #0xD0]
CBZ W10, isVictimMaster //; Attacker is not local player

LDR W10, [X24]
CMP W10, #ITEMTYPE_THUNDER
BNE showCommentary

isVictimMaster:
LDRB W10, [X9, #0xD0]
CBZ W10, end //; Attacked kart is not local player

MOV W3, W23
MOV W4, #HIT_YOU

showCommentary:
STR WZR, [SP, #0x10]

STR W3, [SP, #0x14]

STR W4, [SP, #0x18]

ADD X0, SP, #0x10
BL 0x41FC74 //; ui::ShowCommentary(ui::CommentaryArg const&)

end:
LDP X29, X30, [SP], #0x20
LDR W8, [X24] //; Original instruction
RET


//; Replace Renegade Roundup commentary message from catch to hit in race
//; ui::Control_RaceCommon::showBtInfo(ui::CommentaryArg const&) + 0x1FC
//; 0x50C798 -> BL 0xB512AC

//; By default, the message shown in race is "(RED NAME) caught (BLUE NAME)". 
//; Change it to "Hit (NAME OF WHO GOT ATTACKED)" or "(NAME OF WHO ATTACKED) hit you"
//; based on the "attack type" in ui::CommentaryArg + 8

//; Skip the code in Battle Mode for normal message in Renegade Roundup

//; If in team mode, get the team of the attacked kart and increment it by 1, that'll get the
//; correct increment value for the message MSBT ID calculation for that team's color 
///; (for "Hit (NAME OF WHO GOT ATTACKED)", but for "(NAME OF WHO ATTACKED) hit you" it needs 
//; to be incremented by 2. Since it was already incremented by 1 previously, increment by 1 again 
//; if attack type is "Hit you" to correct it.
//; The increment value will be 0 if not in team mode.

//; Both "Hit You" and "You Hit" message MSBT IDs were loaded before the team stuff. After the team increment
//; value is calculated, choose what ID to use based on attack type and then increment it by the value that was 
//; incremented (or not) in team mode.

//; Register reference:
//; W0 = Message MSBT ID
//; X20 = ui::CommentaryArg*


.set RACERULE_BATTLE, 3

.set MESSAGEID_BLUE_CAUGHT_RED, 0x251F
.set MESSAGEID_YOU_HIT, 0x2531
.set MESSAGEID_HIT_YOU, 0x2538

.set YOU_HIT, 0
.set HIT_YOU, 1

CINC W0, W8, EQ //; Original instruction

STP X29, X30, [SP, #-0x20]!
STR W0, [SP, #0x10]

BL 0x87C244 //; gear::GetRaceInfo(void)
MOV X8, X0

LDR W0, [SP, #0x10]

LDR W9, [X8, #8]
CMP W9, #RACERULE_BATTLE
BEQ end

MOV W1, MESSAGEID_YOU_HIT
MOV W2, MESSAGEID_HIT_YOU

LDR W3, [X20, #8]

LDRB W8, [X8, #0x27]
CBZ W8, calcMessageId //; Not team mode

LDR W0, [X20, #4]
ADD X8, SP, #0x10
BL 0x41F078 //; ui::GetTeamByKartIdx(int)

LDR W8, [SP, #0x10]
ADD W8, W8, #1

CMP W3, #HIT_YOU
CINC W8, W8, EQ

calcMessageId:
CMP W3, #YOU_HIT
CSEL W1, W1, W2, EQ
ADD W0, W1, W8

end:
LDP X29, X30, [SP], #0x20
RET



//; Prevent Renegade Roundup bust text and sound effect in race
//; ui::Control_RaceCommon::showBtInfo(ui::CommentaryArg const&) + 0x588
//; 0x50CB24 -> BL 0xB51314

//; In team race, when the commentary shows, it plays the catch sound 
//; effect and shows the "5 left" text on the top right of the screen.

//; Prevent it from happening by modifying the switch case value to
//; the case where it doesn't play it if not Battle mode


.set RACERULE_BATTLE, 3

STP X29, X30, [SP, #-0x10]!

BL 0x87C244 //; gear::GetRaceInfo(void)
LDR W8, [X0, #8]
CMP W8, #RACERULE_BATTLE
CSEL W23, WZR, W23, NE

LDP X29, X30, [SP], #0x10
CMP W23, #4 //; Original instruction
RET



