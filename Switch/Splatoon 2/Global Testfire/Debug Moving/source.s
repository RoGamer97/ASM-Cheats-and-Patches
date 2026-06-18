; Game: Splatoon 2
; Game version: Global Testfire
; Code: Debug Moving


; Hooks are placed in unused functions because there is no space left in .text
; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


; Disable player inputs if Minus is held
; Cmn::PlayerCtrl::isHold + 0x10 and Cmn::PlayerCtrl::isTrig + 0x10
; 0x64048 -> BL 0x1180260
; 0x64074 -> BL 0x1180260

; If Minus is held, replace requested input mask with zero.
; Done in the debug build for some reason, so replicating it

LDR W8, [X19, #0x10]
TST W8, #0x200 // ; Minus button hold
CSEL X1, XZR, X1, NE
AND X1, X1, #0x3F // ; Original instruction
RET


; Disable right stick if Minus is held
; Game::PlayerGamePad::getRightStick + 0x20
; 0x758970 -> BL 0x1180274

; If Minus is held, load Vector2 zero address and
; skip getting the controller's right stick address
; (since Vector2 address is loaded instead)

; Probably done to avoid the camera from moving when enabling debug features
; or other reason that I don't know (Similar to player inputs being disabled)

; Skip by modifying hook's return address: LR + 0x10 = 0x758984
; Returns past the getRightStick call, where the stick values are loaded
; from the returned pointer

MOV X29, SP // ; Original instruction
STP X29, X30, [SP,#-0x10]!

MOV W0, WZR
BL 0x10A4808 // ; Lp::Utl::getCtrl

LDP X29, X30, [SP], #0x10

LDR W0, [X0, #0x10]
TBZ W0, #9, end // ; Minus button not held

ADRP X0, #0x2B6D000
LDR X0, [X0, #0x298] // ; _ZN4sead7Vector2IfE4zeroE

ADD X30, X30, #0x10

end:
RET


; The Debug Moving bool is not present in retail.
; Game::Player + 0x37D is a padding byte; use it for the "IsInDebugMove" bool.
; You will see Debug Moving bool checks in every hook


; Debug Moving Toggle, Text Draw and Slow Fall
; Game::Player::calcControl + 0x9A4
; 0x722D00 -> BL 0x11802A0

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

ADRP X26, #0x2968000

MOV W0, WZR
BL 0x10A4808 // ; Lp::Utl::getCtrl

LDR W8, [X0, #0x10]
TBZ W8, #9, isToggleTrig // ; Minus button not held

LDR S0, [X19, #0x730]
LDR S1, velMultiplier
FMUL S0, S0, S1
STR S0, [X19, #0x730]

isToggleTrig:
LDR W0, [X0, #0x94]
TBZ W0, #9, isInDebugMove // ; Minus button not triggered

LDRB W8, [X26, #0x14]
CBNZ W8, isInDebugMove // ; Debug Marching/Leading enabled

LDRB W8, [X19, #0x37D]
EOR W8, W8, #1
STRB W8, [X19, #0x37D]

BL 0x25244 // ; Cmn::SetDbgMenuDirty

isInDebugMove:
LDRB W8, [X19, #0x37D]
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

ADRP X8, #0x2B6D000
LDR X9, [X8, #0x870] // ; _ZN4sead7Color4f6cBlackE
LDR X8, [X8, #0x878] // ; _ZN4sead7Color4f6cWhiteE

CSEL X8, X9, X8, EQ // ; Load black or white color depending on text timer
LDP X0, X1, [X8] 
STR X0, [SP, #0x24]
STR X1, [SP, #0x2C]

MOV W8, #0x400
STR W8, [SP, #0x34]

LDR X8, posXMoving
STR X8, [SP, #0x38]

ADRP X0, #0x2B6D000
LDR X0, [X0, #0x700]
LDR X0, [X0]
MOV X26, X0

MOV W1, #0x1E
ADD X2, SP, #0x38
ADD X3, SP, #0x10
ADR X4, debugMovingString
BL 0xFF9EC8 // ; Lp::Sys::DbgTextWriter::productEntryF

LDR S0, posYCancel
STR S0, [SP, #0x3C]

MOV X0, X26
MOV W1, #0x1E
ADD X2, SP, #0x38
ADD X3, SP, #0x10
ADR X4, cancelString
BL 0xFF9EC8 // ; Lp::Sys::DbgTextWriter::productEntryF

LDR S0, posYFly
STR S0, [SP, #0x3C]

MOV X0, X26
MOV W1, #0x1E
ADD X2, SP, #0x38
ADD X3, SP, #0x10
ADR X4, youCanFlyString
BL 0xFF9EC8 // ; Lp::Sys::DbgTextWriter::productEntryF

// ; Pos text doesnt draw in Spectator in the debug build,
// ; but that's because it is drawn in another function, separated
// ; from Debug Moving draw, and that one doesn't run in Spectator
// ; Plus, in Spectator, the Pos shows as 0.00, 0.00, 0.00

// ; Replicate this by skipping Pos draw if in Spectator
BL 0x912210 // ; Game::Utl::isSpectatorStation
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
BL 0xFF9EC8 // ; Lp::Sys::DbgTextWriter::productEntryF

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


; Return the "IsInDebugMove" bool from padding in Game::Player::isInDebugMove_UpDown
; This leftover function was changed to always return false in retail
; It is checked for something with the camera and the player walk animation fix
; (Allow walk and idle animations in air and slow walk animation)

; In the debug build, for Debug Move checks, the game just loads the offset directly
; instead of calling this function everywhere

; Game::Player::isInDebugMove_UpDown (Not a hook)
; 0x72F488 LDRB W0, [X0, #0x37D]


; Disable Debug Moving, Debug Muteki and Debug Marching/Leading on Player Reset
; Same code used in all three patches
; Game::Player::reset_Impl + 0x3D4
; 0x71B51C -> BL 0x1180470

; Resets Debug Moving, Muteki and Marching/Leading on player reset
; Only used to cancel Debug Moving, Muteki and Marching/Leading on
; scene reload/reset by using Debug Scene Reload & Exit

STRB WZR, [X19, #0x37D] // ; Disable Debug Moving
STRB WZR, [X19, #0x37E] // ; Disable Debug Muteki

ADRP X8, #0x2968000
STRB WZR, [X8, #0x14] // ; Disable Debug Marching/Leading

MOV W8, #0xFFFF // ; Original instruction
RET


; No Damage in Debug Moving and Debug Muteki
; Same code used in both patches
; Game::Player::isInState_NoDamage + 0x2C4
; 0x7371D4 -> BL 0x1180494

; ORR Debug Move and Debug Muteki bools together and ORR them
; with returning W0 bool (invincible if either is true)

LDRB W0, [X19, #0xDE4] // ; Original instruction
LDRB W1, [X19, #0x37D] // ; Debug Moving
LDRB W2, [X19, #0x37E] // ; Debug Muteki
ORR W1, W1, W2
ORR W0, W0, W1
RET


; Cancel Debug Moving on Super Jump (DokanWarp) Prepare
; Game::Player::prepareDokanWarp_Start + 0xF0
; 0x74B80C -> BL 0x1180488

; Set padding byte "IsInDebugMove" bool to false

STRB WZR, [X21, #0x37D]
LDR W8, [X22, #8] // ; Original instruction
RET


; Move velocity
; Game::Player::calcMove + 0x30F4
; 0x7288D4 -> BL 0x11804AC

; If Debug Moving, change move velocity to 
; 3.6 if not in squid, and 12.0 if in squid
; Makes you instantly accelerate to max speed
; and also instantly stop

FMUL S10, S10, S11 // ; Original instruction

LDRB W8, [X19, #0x37D]
CBZ W8, end

FMOV S10, #12.0
LDR S11, walkVel

CMP W25, #0 // ; isInSquid bool used through the function
FCSEL S10, S10, S11, NE

end:
RET
walkVel: .float 3.6


; Move speed
; Game::Player::calcMove + 0x6728
; 0x72BF08 -> BL 0x11804D0

; If Debug Moving, change move speed to 
; 3.6 if not in squid, and 12.0 if in squid
; Makes your move speed faster (Max speed)

; Also skip some speed calculations to avoid modifying
; the speed calculated in the hook

; Skip by modifying hook's return address: LR + 0xD4 = 0x72BFE0
; Returns to the point where the calculated max speed value (S11) is used

LDR S0, [X19, #0x914] // ; Original instruction

LDRB W8, [X19, #0x37D]
CBZ W8, end

STP X29, X30, [SP, #-0x10]!

FMOV S0, #12.0
LDR S1, walkSpeed

// ; W25 isInSquid bool is replaced at this point in the function 
// ; Call function to check if in squid
MOV X0, X19
BL 0x72C614 // ; Game::Player::isInSquid
CMP W0, #0
FCSEL S11, S0, S1, NE

LDP X29, X30, [SP], #0x10

ADD X30, X30, #0xD4

end:
LDR S0, [X19, #0xB20] // ; Original instruction
RET
walkSpeed: .float 3.6


; Disable max velocity clamp
; Game::Player::calcMove + 0x3A14
; 0x7291F4 -> BL 0x1180508

; If Debug Moving, skip velocity clamp call to avoid limiting it
; Skip by modifying hook's return address: LR + 4 = 0x7291FC
; Returns to the instruction after the clampLen call (Skipped)

MOV X0, X20 // ; Original instruction

LDRB W8, [X19, #0x37D]
CBZ W8, end

ADD X30, X30, #4

end:
RET


; Disable air velocity decrease
; Game::Player::calcMove + 0x3470
; 0x728C50 -> BL 0x118051C

; If Debug Moving, skip air velocity decrease calculations
; It slows you down by a bit (Barely noticeable, but makes you
; slower by around ~3.0).

; Skip by modifying hook's return address: LR + 0x154 = 0x728DA8
; Returns past the air velocity decrease calculations

LDRB W8, [X19, #0x37D]
CBZ W8, end

ADD X30, X30, #0x154

end:
LDRB W8, [X19, #0xDDC] // ; Original instruction
RET


; Levitate and move up/down with R-Stick (you can Fly)
; Game::Player::calcMove + 0x391C
; 0x7290FC -> BL 0x1180530

; If Debug Moving, set some velocities to zero,
; it makes you stay in air (resets some horizontal and vertical velocities)
; Then get the right stick Y value, multiply it by 
; the up/down velocity (1.8 if not in squid, 3.6 if in squid)
; and set it as one of the fall velocity to fly up/down

LDRB W8, [X19, #0x37D]
CBZ W8, end

STP X29, X30, [SP, #-0x10]!

STR WZR, [X19, #0x748]
STR WZR, [X19, #0x80C]
STR WZR, [X19, #0x778]
STR WZR, [X19, #0x780]
STR WZR, [X19, #0x788]
STR WZR, [X19, #0x8C0]

LDR S0, upDownVel
LDR S1, upDownVelSquid

CMP W25, #0 // ; isInSquid bool used through the function
FCSEL S8, S1, S0, NE

LDR X0, [X19, #0xC58]
BL 0x758950 // ; Game::PlayerGamePad::getRightStick
FMUL S0, S8, S1
STR S0, [X19, #0x730]

LDP X29, X30, [SP], #0x10

end:
LDR S13, [SP, #0x1C] // ; Original instruction
RET
upDownVel: .float 1.8
upDownVelSquid: .float 3.6


; Pass through collision and no airfall death
; (Airfall death is inside of calcGndCollision in Testfire)
; Game::Player::thirdCalc + 0xCD8
; 0x72DC84 -> BL 0x1180588

; If Debug Moving, pass through stage collision
; Load Debug Moving bool, if it's true, skip original
; instruction; after the hook, it checks if W9 is 2 and 
; skips collision call if it is, so, if Debug Moving,
; W9 is 1: Skip, otherwise, load original instruction
; for normal behavior

LDRB W9, [X19, #0x37D]
CBNZ W9, end

LDR W9, [X19, #0xDD4] // ; Original instruction

end:
RET


; Pass through enemy team spawn/respawn barrier collision
; Game::RespawnPoint::calcPlayerCollision_ + 0x64
; 0x5ECDE0 -> BL 0x1180598

; If Debug Moving, skip spawn barrier collision
; Skip by modifying hook's return address: LR + 0x540 = 0x5ED324
; Returns to the function's end

MOV X19, X0 // ; Original instruction

LDRB W0, [X20, #0x37D]
CBZ W0, end

ADD X30, X30, #0x540

end:
RET


; Pass through mission Super Jump gateway barrier collision
; Game::AreaGateway::calcPlayerCollision_ + 0x38
; 0x6BA728 -> 0x11805AC

; If Debug Moving, set W8 to zero. After the hook,
; it checks if W8 is not 1 and branches to function end if so

LDRB W9, [X20, #0x37D]
CMP W9, #0
CSEL W8, WZR, W8, NE
CMP W8, #1 // ; Original instruction
RET


; Plaza Door ignores player
; Game::PlazaDoor::checkHitPlayer_ + 0x24
; 0x66A09C -> BL 0x11805C0

; If Debug Moving, Plaza doors won't open, and will close
; if enabling Debug Move when one is open. 
; It also prevents you from entering shops

; Replicate nullptr check (For getControlledPerformer call)
; which branches to function end, and also branch to end if 
; Debug Moving

; Skip by modifying hook's return address: LR + 0x50 = 0x66A0F0
; Returns to the function's end

CBZ X0, return // ; Replicating original instruction

LDRB W8, [X0, #0x37D]
CBZ W8, end

MOV W0, WZR

return:
ADD X30, X30, #0x50

end:
RET


; Force grind rail finish
; Game::PlayerGrindRail::firstCalcBindImpl_ + 0xC0
; 0x786218 -> BL 0x11805D8

; If Debug Moving, you are forced out of grind rail move 

; Set eject velocity to zero, set W8 to zero (it is normally
; 1, but it is zero when ended by Debug Move, and then branch
; to the part of the code that stores the values and calls finish, 
; skipping the rest of calculations

; Skip by modifying hook's return address: LR + 0x2E0 = 0x7864FC
; Returns to part of the function that stores values and then
; calls grind rail finish, returns AFTER W8 is set to 1, so it 
; uses the one from the hook instead


LDR X8, [X20, #0x10]
LDRB W8, [X8, #0x37D]
CBZ W8, end

STR XZR, [X29, #-0x60]
STR WZR, [X29, #-0x58]
MOV W8, WZR

ADD X30, X30, #0x2E0

end:
LDR W8, [X20, #0x28] // ; Original instruction
RET


; Force ink rail finish
; Game::PlayerInkRailVersus::calcPlayerPos_stateBind_ + 0x17C
; 0x7B7AAC -> BL 0x11805FC

; If Debug Moving, you are forced out of ink rail move, but you
; actually stay stuck in the ink rail if in squid form, but can't move

; Set eject velocity to zero, set W8 to zero (it is normally
; 1, but it is zero when ended by Debug Move, and then branch
; to the part of the code that stores the values and calls finish, 
; skipping the rest of calculations

; Skip by modifying hook's return address: LR + 0x28 = 0x7B7AD8
; Returns to part of the function that stores values and then
; calls ink rail finish, returns AFTER W8 is set to 1, so it 
; uses the one from the hook instead

LDR X0, [X20, #0x128]
LDRB W8, [X0, #0x37D]
CBZ W8, end

STR XZR, [SP, #0x28]
STR WZR, [SP, #0x30]
MOV W8, WZR

ADD X30, X30, #0x28

end:
LDRB W8, [SP, #0x3C] // ; Original instruction
RET


; Prevent Rainmaker DunkShoot VGoal
; Game::Player::checkVGoal_ToDunkShoot + 0x2C
; 0x7374B4 -> BL 0x1180620

; If Debug Moving, you can't start the rainmaker dunk shoot goal

; Override W8 with 7, after this hook, it checks if W8 is 7 (curMode)
; and branches to function end if it is

LDR W8, [SP, #0x38] // ; Original instruction
 
LDRB W9, [X19, #0x37D]
CBZ W9, end

MOV W8, #7

end:
RET



; Cancel Rainmaker DunkShoot VGoal
; Game::Player::calcPrepare + 0xC94
; 0x721BF4 -> BL 0x1180634 

; If enabling Debug Move while dunking the rainmaker, it will
; cancel the dunk, avoiding the goal.
; In FreeTest, you normally get softlocked after goal, but this unsoftlocks it

; Store zero to some VictoryGoal bool and skip some calculations

; Skip by modifying hook's return address: LR + 0x38 = 0x721C30
; Returns past some calculations and checks related to VictoryGoal

LDRB W10, [X19, #0x37D]
CBZ W10, end

STRB WZR, [X8, #0x50C]

ADD X30, X30, #0x38

end:
LDR S0, [X19, #0x654] // ; Original instruction
RET


; Super Jump (DokanWarp) can start in air
; Game::PlayerDokanWarp::calc + 0x2EC
; 0x7785C4 -> BL 0x118064C

; If Debug Moving, you can start a Super Jump while in the air

; After this hook, it checks if W8 is 2 and branches to call
; DokanWarp start even if in air, so override W8 with 2 if
; Debug Moving

LDR W8, [X19, #0x88] // ; Original instruction

LDR X9, [X19]
LDRB W9, [X9, #0x37D]
CBZ W9, end

MOV W8, #2

end:
RET


; Super Jump (DokanWarp) land animation can start in air

; In retail, it loads zero to W8 and branches, never
; using W8, while in debug build, it's the Debug Moving
; bool load and conditional branch
; Likely an inline of IsInDebugMove_UpDown or weird ifdef

; Replace it with the actual bool load and conditional branch
; Game::PlayerDokanWarp::calc + 0x428 and +0x42C (Not a hook)
; 0x778700 LDRB W8, [X9, #0x37D]
; 0x778704 CBZ W8, 0x778740


; Clear air camera on Super Jump (DokanWarp) land
; Game::PlayerBehindCamera::calcPosAt + 0xBE0
; 0x76224C -> BL 0x1180664

; If Debug Moving, the air camera should be cleared after
; landing from a Super Jump. It doesn't normally because you 
; stay in the air

; Clear by modifying hook's return address: LR + 0x44 = 0x762294
; Returns to the part of the code that clears the air camera

LDRB W8, [X19, #0x370] // ; Original instruction

LDR X9, [X19]
LDRB W9, [X9, #0x37D]
CBZ W9, end

ADD X30, X30, #0x44

end:
RET


; Disable moving camera up/down with R-Stick if Motion Controls are off
; Game::PlayerBehindCamera::calcControl + 0x740
; 0x75F16C -> BL 0x1180B5C

; If Debug Moving, replace S9 with S11 (sero) so camera can't be moved in the Y axis

LDR X9, [X19]
LDRB W8, [X19, #0x37D]
CMP W8, #0
FCSEL S9, S11, S9, NE

FCMP S9, S0 // ; Original instruction
RET