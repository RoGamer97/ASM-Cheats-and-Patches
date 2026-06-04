; Game: Splatoon 2
; Game version: 3.1.0
; Code: Debug Moving


; Hooks are placed in unused functions because there is no space left in .text
; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


; Disable player inputs if Minus is held
; Cmn::PlayerCtrl::isHold + 0x10 and Cmn::PlayerCtrl::isTrig + 0x10
; 0x8ADB0 -> BL 0x1B61088
; 0x8ADE0 -> BL 0x1B61088

; If Minus is held, replace requested input mask with zero

LDR W8, [X19, #0x10]
TST W8, #0x200 // ; Minus button hold
CSEL X1, XZR, X1, NE
AND X1, X1, #0x3F // ; Original instruction
RET


; Disable right stick if Minus is held
; Game::PlayerGamePad::getRightStick + 0x20
; 0xEA1974 -> BL 0x1B6109C

; If Minus is held, load Vector2 zero address and
; skip getting the controller's right stick address
; (since Vector2 address is loaded instead)

; Skip by modifying hook's return address: LR + 0x10 = 0xEA1988
; Returns past getRightStick call, where it loads the stick's values
; from the pointer

MOV X29, SP // ; Original instruction
STP X29, X30, [SP,#-0x10]!

MOV W0, WZR
BL 0x1A65E14 // ; Lp::Utl::getCtrl

LDP X29, X30, [SP], #0x10

LDR W0, [X0, #0x10]
TBZ W0, #9, end // ; Minus button not held

ADRP X0, #0x4156000
LDR X0, [X0, #0x818] // ; _ZN4sead7Vector2IfE4zeroE

ADD X30, X30, #0x10

end:
RET


; Game::Player + 0x431 is a padding byte; use it for the "IsInDebugMove" bool
; You will see Debug Moving bool checks in every hook


; Debug Moving Toggle, Text Draw and Slow Fall
; Game::Player::calcControl + 0xE0C
; 0xE23484 -> BL 0x1B610FC

; Holding Minus outside of Debug Move makes you fall slowly.
; I'd like to suppose that Nintendo did this because:
; It makes falling when cancelling Debug Move in air slighty
; smoother because you hold Minus for a few frames, so the 
; player won't straight fall down, but have a smooth transition
; Or because other debug features require holding Minus, so if
; you're in the air Debug Moving and hold Minus for other features,
; Debug Moving will be disabled and you'll fall slowly to have time to
; react after the feature has been enabled or something like this

; Code will only run for controlled player (You)
; Sets "dirty" bool when toggled, for Display Dirty (D) Debug Mark patch
; Draws text if enabled

; If in Debug Marching/Leading, you can't toggle Debug Move (Minus
; should cancel those, and not enable Debug Move at the same time)


LDR W8, [X19, #0x358]
CBNZ W8, end // ; Not controlled player

STP X29, X30, [SP, #-0x40]!

ADRP X26, #0x3DFE000

MOV W0, WZR
BL 0x1A65E14 // ; Lp::Utl::getCtrl

LDR W8, [X0, #0x10]
TBZ W8, #9, isToggleTrig // ; Minus button not held

LDR S0, [X19, #0x910]
LDR S1, velMultiplier
FMUL S0, S0, S1
STR S0, [X19, #0x910]

isToggleTrig:
LDR W0, [X0, #0x94]
TBZ W0, #9, isInDebugMove // ; Minus button not triggered

LDRB W8, [X26, #0x14]
CBNZ W8, isInDebugMove // ; Debug Leading/Marching enabled

LDRB W8, [X19, #0x431]
EOR W8, W8, #1
STRB W8, [X19, #0x431]

BL 0x2C364 // ; Cmn::SetDbgMenuDirty

isInDebugMove:
LDRB W8, [X19, #0x431]
CBZ W8, restore

// ; Setup stack pointer params for text draw call

MOV X8, #0x100000000
STR X8, [SP, #0x10]

MOV X8, #0x3F8000003F800000
STR X8, [SP, #0x18]
STR WZR, [SP, #0x20]

// ; Increment timer in R-W region
// ; It is used for text flashing
LDR W9, [X26, #8]
ADD W9, W9, #1
STR W9, [X26, #8]
AND W9, W9, #0x60
CMP W9, #0x60

ADRP X8, #0x4156000
LDR X9, [X8, #0xE90] // ; _ZN4sead7Color4f6cBlackE
LDR X8, [X8, #0xE98] // ; _ZN4sead7Color4f6cWhiteE

CSEL X8, X9, X8, EQ // ; Load black or white color depending on text timer
LDP X0, X1, [X8] 
STR X0, [SP, #0x24]
STR X1, [SP, #0x2C]

MOV W8, #0x400
STR W8, [SP, #0x34]

LDR X8, posXMoving
STR X8, [SP, #0x38]

ADRP X0, #0x4156000
LDR X0, [X0, #0xBD0]
LDR X0, [X0]
MOV X26, X0

MOV W1, #0x1E
ADD X2, SP, #0x38
ADD X3, SP, #0x10
ADR X4, debugMovingString
BL 0x19BC22C // ; Lp::Sys::DbgTextWriter::productEntryF

LDR S0, posYCancel
STR S0, [SP, #0x3C]

MOV X0, X26
MOV W1, #0x1E
ADD X2, SP, #0x38
ADD X3, SP, #0x10
ADR X4, cancelString
BL 0x19BC22C // ; Lp::Sys::DbgTextWriter::productEntryF

LDR S0, posYFly
STR S0, [SP, #0x3C]

MOV X0, X26
MOV W1, #0x1E
ADD X2, SP, #0x38
ADD X3, SP, #0x10
ADR X4, youCanFlyString
BL 0x19BC22C // ; Lp::Sys::DbgTextWriter::productEntryF

// ; Pos text doesnt draw in Spectator in the debug build,
// ; but that's because it is drawn in another function, separated
// ; from Debug Moving draw, and that one doesn't run in Spectator
// ; Plus, in Spectator, the Pos shows as 0.00, 0.00, 0.00

// ; Replicate this by skipping Pos draw if in Spectator
BL 0x116F5F0 // ; Game::Utl::isSpectatorStation
CBNZ W0, restore

MOV X0, X26
MOV W1, #0x1E
ADR X2, posXPos
ADD X3, SP, #0x10
ADR X4, positionString

// ; Pass XYZ coords as argument
LDR S0, [X19, #0x748]
LDR S1, [X19, #0x74C]
LDR S2, [X19, #0x750]
FCVT D0, S0
FCVT D1, S1
FCVT D2, S2
BL 0x19BC22C // ; Lp::Sys::DbgTextWriter::productEntryF

restore:
LDP X29, X30, [SP], #0x40

end:
MOV X0, X19 // ; Original instruction
RET

velMultiplier: .float 0.7

posXMoving: .float -610
posYMoving: .float -205

posYCancel: .float -220

posYFly: .float -235

posXPos: .float 380
posYPos: .float -160

debugMovingString: .asciz "Debug Moving..."
cancelString: .asciz "  Push    [-]   -> Cancel"
youCanFlyString: .asciz "  R-Stick [U/D] -> you can Fly"
positionString: .asciz "Pos : %.2f, %.2f, %.2f"


; Return the IsInDebugMove bool from padding in Game::Player::isInDebugMove_UpDown
; This leftover function was changed to always return zero in retail
; It is called to check for Debug Move for something with the 
; camera and the player walk animation fix

; In the debug build, for Debug Move checks, the game just loads the offset directly
; instead of calling this function everywhere

; Game::Player::isInDebugMove_UpDown (Not a hook)
; 0xE32EF0 LDRB W0, [X0, #0x431]


; Disable Debug Moving, Debug Muteki and Debug Marching/Leading on Player Reset
; Same code used in all three patches
; Game::Player::reset_Impl + 0x3AC
; 0xE17288 -> BL 0x1B612CC

; Resets Debug Moving, Muteki and Marching/Leading on player RESET,
; so, when players are loaded in or reset by using Debug Scene Reload

; Respawn does NOT reset players, and the features stay enabled after respawn

STRB WZR, [X19, #0x431] // ; Disable Debug Moving
STRB WZR, [X19, #0x432] // ; Disable Debug Muteki

ADRP X8, #0x3DFE000
STRB WZR, [X8, #0x14] // ; Disable Debug Marching/Leading

MOV W8, #0xFFFF // ; Original instruction
RET


; No Damage in Debug Moving and Debug Muteki
; Same code used in both patches
; Game::Player::isInState_NoDamage + 0x324
; 0xE3D46C -> BL 0x1B612F0

; ORR Debug Move and Debug Muteki bools together and ORR them
; with returning W0 bool

LDRB W0, [X19, X8] // ; Original instruction
LDRB W1, [X19, #0x431] // ; Debug Moving
LDRB W2, [X19, #0x432] // ; Debug Muteki
ORR W1, W1, W2
ORR W0, W0, W1
RET


; Cancel Debug Moving on Super Jump (DokanWarp) Prepare
; Game::Player::prepareDokanWarp_Start + 0x114
; 0xE57118 -> BL 0x1B612E4

; Set padding byte "IsInDebugMove" bool to false

STRB WZR, [X21, #0x431]
MOV W8, #0x12E8 // ; Original instruction
RET


; Move velocity
; Game::Player::calcMove + 0x3DF8
; 0xE2A7B8 -> BL 0x1B61308

; If Debug Moving, change move velocity to 
; 3.6 if not in squid, and 12.0 if in squid
; Makes you instantly accelerate to max speed
; and also instantly stop

LDRB W8, [X19, #0x431]
CBZ W8, end

FMOV S10, #12.0
LDR S11, walkVel

CMP W26, #0 // ; isInSquid bool used through the function
FCSEL S10, S10, S11, NE

end:
MOV X2, X21 // ; Original instruction
RET
walkVel: .float 3.6


; Move speed
; Game::Player::calcMove + 0x8278
; 0xE2EC38 -> BL 0x1B6132C

; If Debug Moving, change move speed to 
; 3.6 if not in squid, and 12.0 if in squid
; Makes your move speed faster (Max speed)

; Also skip some speed calculations to avoid modifying
; the speed calculated in the hook

; Skip by modifying hook's return address: LR + 0xD4 = 0xE2ED10
; Returns back to max speed calculation after other speed calcs

LDRB W8, [X19, #0x431]
CBZ W8, end

STP X29, X30, [SP, #-0x10]!

FMOV S0, #12.0
LDR S1, walkSpeed

// ; W26 isInSquid bool is replaced at this point in the function 
// ; Call function to check if in squid
MOV X0, X19
BL 0xE2F370 // ; Game::Player::isInSquid
CMP W0, #0
FCSEL S11, S0, S1, NE

LDP X29, X30, [SP], #0x10

ADD X30, X30, #0xD4

end:
LDR S0, [X19, #0xB20] // ; Original instruction
RET
walkSpeed: .float 3.6


; Disable max velocity clamp
; Game::Player::calcMove + 0x4AD0
; 0xE2B490 -> BL 0x1B61364

; If Debug Moving, skip velocity clamp call
; Skip by modifying hook's return address: LR + 4 = 0xE2B498

MOV X0, X20 // ; Original instruction

LDRB W8, [X19, #0x431]
CBZ W8, end

ADD X30, X30, #4

end:
RET


; Disable air velocity decrease
; Game::Player::calcMove + 0x4220
; 0xE2ABE0 -> BL 0x1B61378

; If Debug Moving, skip air velocity decrease calculations
; it slows you down by a bit (Barely noticeable, but makes you
; slower by around 3.0).

; Skip by modifying hook's return address: LR + 0x2D4 = 0xE2AEB4

LDRB W8, [X19, #0x431]
CBZ W8, end

ADD X30, X30, #0x2D0

end:
LDR X8, [X19, #0xF40] // ; Original instruction
RET


; Levitate and move up/down with R-Stick (you can Fly)
; Game::Player::calcMove + 0x486C
; 0xE2B22C -> BL 0x1B6138C

; If Debug Moving, set some velocities to zero, 
; get the right stick Y value, multiply it by 
; the up/down velocity (1.8 if not in squid, 3.6 if in squid)
; and set it as one of the fall velocity to move up/down

LDRB W8, [X19, #0x431]
CBZ W8, end

STP X29, X30, [SP, #-0x10]!

STR WZR, [X19, #0x92C]
STR WZR, [X19, #0x9FC]
STR WZR, [X19, #0x95C]
STR WZR, [X19, #0x964]
STR WZR, [X19, #0x96C]
STR WZR, [X19, #0xACC]

LDR S0, upDownVel
LDR S1, upDownVelSquid

CMP W26, #0 // ; isInSquid bool used through the function
FCSEL S8, S1, S0, NE

LDR X0, [X19, #0xED8]
BL 0xEA1954 // ; Game::PlayerGamePad::getRightStick
FMUL S0, S8, S1
STR S0, [X19, #0x910]

LDP X29, X30, [SP], #0x10

end:
LDR S13, [SP, #0x1C] // ; Original instruction
RET
upDownVel: .float 1.8
upDownVelSquid: .float 3.6


; Pass through collision
; Game::Player::thirdCalc + 0x10AC
; 0xE30D04 -> BL 0x1B613E4

; If Debug Moving, skip original instruction,
; after the hook, it checks if W8 is 2 and skips 
; collision call if it is
; So, load Debug Move bool in W8 and skip original
; instruction if it is true, so it checks 1 and branches,
; else, load original instruction for default behavior

LDRB W8, [X19, #0x431]
CBNZ W8, end

LDR W8, [X19, #0x10E0] // ; Original instruction

end:
RET


; No airfall death
; Game::Player::thirdCalc + 0x2098
; 0xE31CF0 -> BL 0x1B613F4

; If Debug Moving, you will not die if staying
; in the air for too long outside of the stage

; ORR Debug Move bool with W8, after the hook
; it checks if W8 is greater than 0, so it will
; branch if Debug Moving is true

LDR W8, [X0, #0x4C] // ; Original instruction
LDRB W9, [X19, #0x431]
ORR W8, W8, W9
RET


; Pass through enemy team spawn/respawn barrier collision
; Game::RespawnPoint::calcPlayerCollision_ + 0x60
; 0xA12E2C -> BL 0x1B61404

; If Debug Moving, skip spawn barrier collision
; Skip by modifying hook's return address: LR + 0x82C = 0xA1365C 

MOV X20, X1 // ; Original instruction

LDRB W1, [X20, #0x431]
CBZ W1, end

ADD X30, X30, #0x82C

end:
RET


; Pass through mission Super Jump gateway barrier collision
; Game::AreaGateway::calcPlayerCollision_ + 0x38
; 0xD27360 -> 0x1B61418 

; If Debug Moving, set W8 to zero. After the hook,
; it checks if W8 is not one and branches to function end

LDRB W9, [X20, #0x431]
CMP W9, #0
CSEL W8, WZR, W8, NE
CMP W8, #1 // ; Original instruction
RET


; Pass through Octa DLC Mission platform barrier collision
; Octa DLC didn't exist in the debug build, this is my own addition
; which would definitely be added if the DLC existed at the time

; Game::StationPlatformOcta::onHitBarrier + 0x4C 
; 0xBC4454 -> BL 0x1B619C0 

; If Debug Moving, skip collision calculation call
; Skip by modifying hook's return address: LR + 0x88 = 0xBC44E0

MOV X19, X1 // ; Original instruction

LDRB W8, [X19, #0x431]
CBZ W8, end

ADD X30, X30, #0x88

end:
RET


; No Octa DLC Mission platform death
; Octa DLC didn't exist in the debug build, this is my own addition
; which would definitely be added if the DLC existed at the time

; Game::SeqMgrMissionOcta::calcCheckBreakJail + 0x30
; 00D7A650 -> BL 0x1B619D4

; If Debug Moving, skip death collision call
; Hooked in the getControlledPerformer call because after it,
; there is another call, so the pointer is lost

; Skip by modifying hook's return address: LR + 0x8 = 0xD7A65C
; Returns to part of the function that returns 0 and branches to end

STP X29, X30, [SP, #-0x10]!

BL 0xF07B1C // ; Game::PlayerMgr::getControlledPerformer (Original instruction)

LDP X29, X30, [SP], #0x10

LDRB W8, [X0, #0x431]
CBZ W8, end

ADD X30, X30, #8

end:
RET


; Plaza Door ignores player
; Game::PlazaDoor::checkHitPlayer_ + 0x58
; 0xC387D8 -> BL 0x1B6142C 

; If Debug Moving, Plaza doors won't open, and will close
; if enabling Debug Move when one is open. 
; It also prevents you from entering shops

; Replicate nullptr check (For getControlledPerformer call)
; which branches to function end, and also branch to end if 
; Debug Moving

; Skip by modifying hook's return address: LR + 0x54 = 0xC38830
; Returns to part of the function that returns 0 and ends

CBZ X0, return // ; Replicating original instruction

LDRB W8, [X0, #0x431]
CBZ W8, end

return:
ADD X30, X30, #0x54

end:
RET


; Force grind rail finish
; Game::PlayerGrindRail::firstCalcBindImpl_ + 0xBC
; 0xEA8A9C -> BL 0x1B61440

; If Debug Moving, you are forced out of grind rail move 

; Set eject velocity to zero, set W8 to zero (it is normally
; 1, but it is zero when ended by Debug Move, and then branch
; to the part of the code that stores the values and calls finish, 
; skipping the rest of calculations

; Skip by modifying hook's return address: LR + 0x1A0 = 0xEA8C40
; Returns to part of the function that stores values and then
; calls grind rail finish, returns AFTER W8 is set to 1, so it 
; uses the one from the hook instead


LDR X8, [X19, #0x18]
LDRB W8, [X8, #0x431]
CBZ W8, end

STR XZR, [SP]
STR WZR, [SP, #8]
MOV W8, WZR

ADD X30, X30, #0x1A0

end:
LDR W8, [X19, #0x30] // ; Original instruction
RET


; Force ink rail finish
; Game::PlayerInkRailVersus::calcPlayerPos_stateBind_ + 0x150
; 0xEEEE38 -> BL 0x1B61464 

; If Debug Moving, you are forced out of ink rail move, but you
; actually stay stuck in the ink rail if in squid form, but can't move

; Set eject velocity to zero, set W8 to zero (it is normally
; 1, but it is zero when ended by Debug Move, and then branch
; to the part of the code that stores the values and calls finish, 
; skipping the rest of calculations

; Skip by modifying hook's return address: LR + 0x28 = 0xEEEE64
; Returns to part of the function that stores values and then
; calls ink rail finish, returns AFTER W8 is set to 1, so it 
; uses the one from the hook instead

LDR X0, [X19, #0x120]
LDRB W8, [X0, #0x431]
CBZ W8, end

STR XZR, [SP, #0x28]
STR WZR, [SP, #0x30]
MOV W8, WZR

ADD X30, X30, #0x28

end:
LDRB W8, [SP, #0x34] // ; Original instruction
RET


; Prevent Rainmaker DunkShoot VGoal
; Game::Player::checkVGoal_ToDunkShoot + 0x28
; 0xE3DB70 -> BL 0x1B61488

; If Debug Moving, you can't start the rainmaker dunk shoot goal

; Override W0 with 7, after this hook, it checks if W0 is 7 (curMode)
; and branches to function end if it is

LDRB W8, [X19, #0x431]
CBZ W8, end

MOV W0, #7

end:
CMP W0, #7 // ; Original instruction
RET



; Cancel Rainmaker DunkShoot VGoal
; Game::Player::calcPrepare + 0xA40
; 0xE21CC4 -> BL 0x1B6149C 

; If enabling Debug Move while dunking the rainmaker, it will
; cancel the dunk, avoiding the goal.
; In FreeTest, you normally softlocks after goal, but this unsoftlocks it

; Store zero to some VictoryGoal bool and skip some calculations

; Skip by modifying hook's return address: LR + 0x38 = 0xE21D00
; Returns past some calculations and checks related to VictoryGoal

LDRB W10, [X19, #0x431]
CBZ W10, end

STRB WZR, [X8, #0x580]

ADD X30, X30, #0x38

end:
LDR S0, [X19, #0x74C] // ; Original instruction
RET


; Super Jump (DokanWarp) can start in air
; Game::PlayerDokanWarp::calc + 0x3C0
; 0xE94D64 -> BL 0x1B614B4 

; If Debug Moving, you can start a Super Jump while in the air

; After this hook, it checks if W8 is 2 and branches to call
; DokanWarp start even if in air, so override W8 with 2

LDR W8, [X19, #0x98] // ; Original instruction

LDR X9, [X19]
LDRB W9, [X9, #0x431]
CBZ W9, end

MOV W8, #2

end:
RET


; Super Jump (DokanWarp) land animation can start in air

; In retail, it loads zero to W8 and branches, never
; using W8, while in debug build, it's the Debug Move 
; bool and cnditional Branch

; Likely an inline of IsInDebugMove_UpDown or weird ifdef

; Replace it with the actual bool load and conditional branch
; Game::PlayerDokanWarp::calc + 0x480 and +0x484 (Not a hook)
; 0xE94E24 LDRB W8, [X9, #0x431]
; 0xE94E28 CBZ W8, 0xE94E64


; Clear air camera on Super Jump (DokanWarp) land
; Game::PlayerBehindCamera::calcPosAt + 0xDE8
; 0xE6F5CC -> BL 0x1B614CC 

; If Debug Moving, the air camera should be cleared after
; landing from a Super Jump. It doesn't normally because you 
; stay in the air

; Clear by modifying hook's return address: LR + 0x40 = 0xE6F610
; Returns to the part of the code that clears the air camera

LDRB W8, [X19, #0x388] // ; Original instruction

LDR X9, [X19]
LDRB W9, [X9, #0x431]
CBZ W9, end

ADD X30, X30, #0x40

end:
RET


; Disable moving camera up/down with R-Stick if Motion Controls are off
; Game::PlayerBehindCamera::calcControl + 0x73C
; 0xE6BF64 -> BL 0x1B614E4 

; If Debug Moving, replace S14 with S11 (sero) so camera can't be moved in the Y axis

LDR X8, [X19]
LDRB W8, [X8, #0x431]
CMP W8, #0
FCSEL S14, S11, S14, NE

FCMP S14, S0 // ; Original instruction
RET