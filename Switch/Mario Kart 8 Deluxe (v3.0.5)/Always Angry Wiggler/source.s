//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: Always Angry Wiggler

//; You can find some documented headers here to learn more about the game: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are placed in free space in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


// Force Wiggler's facial animation to damage (Angry)
//; object::DriverKart::calcMaterialAnim_(void) + 0x1C
//; 0xDBB24 -> BL 0xB5116C

//; If character is Wiggler, set facial animation to 
//; damage to make Wiggler angry, and change W8 to zero
//; to avoid some branches from skipping the set facial anim
//; frame call


//; Register reference:
//; X19 = object::DriverKart*

.set DRIVER_WIGGLER, 0x2F

.set FACIAL_ANIM_DAMAGE, 4


LDR W1, [X19, #0x324] //; Original instruction

LDR W9, [X19, #0xC0]
CMP W9, #DRIVER_WIGGLER //; Wiggler
BNE end

MOV W1, #FACIAL_ANIM_DAMAGE
MOV W8, WZR

end:
RET


// Fix Menu Crash
//; object::DriverKart::calcELink(void) + 0xD6C
//; 0xDDB30 -> BL 0xB5115C

//; Angry Wiggler crashes on the menu when trying to
//; play the angry smoke SFX because kart audio
//; is not created in menus.

//; Fix the crash by skipping audio::AudSoundObjKart::requestHoldKartSE(audio::AudSoundObjKart::EHoldKartSE,int,int)
//; call if audio::AudSoundObjKart* is nullptr

//; Skip by modifying hook's return address: LR + 4 = 0xDDB38
//; Returns after the requestHoldKartSE call

//; Register reference:
//; X0 = audio::AudSoundObjKart*

CBNZ X0, end

ADD X30, X30, #4

end:
MOV W3, WZR //; Original instruction
RET