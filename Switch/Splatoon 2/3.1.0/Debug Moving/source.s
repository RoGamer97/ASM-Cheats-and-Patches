//; Game: Splatoon 2
//; Game version: 3.1.0
//; Code: Debug Moving


// Hooks are written over unused functions (never executed).
// There is a bit of free space in .text, but for some reason the emulator
// crashes when executing code in that space. Writing over unused functions
// doesn't cause a crash.


//; Disable player inputs if Minus is held
//; Cmn::PlayerCtrl::isHold(ulong) + 0x10 and Cmn::PlayerCtrl::isTrig(ulong) + 0x10
//; 0x8ADB0 -> BL 0x1B61088
//; 0x8ADE0 -> BL 0x1B61088

//; If Minus is held, replace requested input mask with zero.
//; Done in the debug build for some reason, so replicating it

//; Register reference:
//; X19 = Lp::Sys::Ctrl*


.set BUTTONBIT_MINUS, 9

.set BUTTON_MINUS, (1 << BUTTONBIT_MINUS)

LDR W8, [X19, #0x10]
TST W8, #BUTTON_MINUS
CSEL X1, XZR, X1, NE
AND X1, X1, #0x3F //; Original instruction
RET


//; Disable right stick if Minus is held
//; Game::PlayerGamePad::getRightStick(void) + 0x20
//; 0xEA1974 -> BL 0x1B6109C

//; If Minus is held, load address of Vector2 of zeroes and
//; skip getting the controller's right stick address
//; (since Vector2 address is loaded instead)

//; Done in the debug build for some reason, so replicating it

//; Skip by modifying hook's return address: LR + 0x10 = 0xEA1988
//; Returns past the getRightStick call, where the stick values are loaded
//; from the returned pointer


.set BUTTONBIT_MINUS, 9

MOV X29, SP //; Original instruction
STP X29, X30, [SP,#-0x10]!

MOV W0, WZR
BL 0x1A65E14 //; Lp::Utl::getCtrl(int)

LDP X29, X30, [SP], #0x10

LDR W0, [X0, #0x10]
TBZ W0, #BUTTONBIT_MINUS, end //; Not held

ADRP X0, #0x4156000
LDR X0, [X0, #0x818] //; _ZN4sead7Vector2IfE4zeroE

ADD X30, X30, #0x10

end:
RET


//; The Debug Moving bool member variable exists in retail at Game::Player + 0x1088
//; It is never read, but it is written to by 3 different functions:

//; Game::Player::reset_Impl(bool,Cmn::Def::ResetType) + 0x3C0 -> Sets it to false
//; Game::Player::debugWarp + 0x48 -> Sets it to true (Debug Warp from the debug menu in debug builds//; not present in 3.1.0)
//; Game::Player::calcPrepare(void) + 0x4C -> Sets it to false

//; This reimplementation will use it.
//; You will see checks for it in most hooks and writes to it in some places as well.

//; LDRB/STRB cannot be used with this offset, so it is loaded into a register and Game::Player is indexed from it.


//; Debug Moving Toggle, Text Draw and Slow Fall
//; Game::Player::calcControl(void) + 0xE0C
//; 0xE23484 -> BL 0x1B610FC

//; Holding Minus outside of Debug Move makes you fall slowly.
//; I'd like to suppose that Nintendo did this because:
//; It makes falling when cancelling Debug Move in air slighty
//; smoother because you hold Minus for a few frames, so the 
//; player won't immediately fall down, but have a smooth transition.
//; Or because other debug features require holding Minus, so if
//; you're in the air Debug Moving and hold Minus for other features,
//; Debug Moving will be disabled and you'll fall slowly to have time to
//; react after the feature has been enabled or something like this

//; Code will only run for controlled player (You)

//; Can't toggle Debug Moving if Debug Marching/Leading is enabled 
//; (Minus should cancel Marching/Leading and not enable Debug Moving at the same time

//; Sets "dirty" bool when toggled, for Display Dirty (D) Debug Mark patch

//; Draws text if enabled

//; Pos text doesnt draw in Spectator in the debug build,
//; but that's because it is drawn in another function, separated
//; from Debug Moving draw, and that one doesn't run in spectator.
//; Since it runs here, the Pos would show in spectator, but with 
//; coords showing as 0.00, 0.00, 0.00
//; To avoid this, skip Pos draw if in spectator mode to match 
//; debug build behavior


//; Register reference:
//; X19 = Game::Player*


.set BUTTONBIT_MINUS, 9

.set TEXT_FLASH_TIMER_MASK, 96

LDR W8, [X19, #0x358]
CBNZ W8, end //; Not controlled player

STP X29, X30, [SP, #-0x40]!

ADRP X26, #0x3DFE000

MOV W0, WZR
BL 0x1A65E14 //; Lp::Utl::getCtrl(int)

MOV W9, #0x1088
LDR W8, [X0, #0x10]
TBZ W8, #BUTTONBIT_MINUS, isToggleTrig //; not held

LDR S0, [X19, #0x910]
LDR S1, velMultiplier
FMUL S0, S0, S1
STR S0, [X19, #0x910]

isToggleTrig:
LDR W0, [X0, #0x94]
TBZ W0, #BUTTONBIT_MINUS, isInDebugMove //; not triggered

LDRB W8, [X26, #0x14]
CBNZ W8, isInDebugMove //; Debug Leading/Marching enabled

LDRB W8, [X19,X9]
EOR W8, W8, #1
STRB W8, [X19,X9]

BL 0x2C364 //; Cmn::SetDbgMenuDirty(void)

isInDebugMove:
LDRB W8, [X19,X9]
CBZ W8, restore

//; Setup stack for text draw call
MOV X8, #0x100000000
STR X8, [SP, #0x10]

MOV X8, #0x3F8000003F800000
STR X8, [SP, #0x18]
STR WZR, [SP, #0x20]

//; Increment timer in R-W region
//; It is used for text flashing
LDR W9, [X26, #8]
ADD W9, W9, #1
STR W9, [X26, #8]
AND W9, W9, #TEXT_FLASH_TIMER_MASK
CMP W9, #TEXT_FLASH_TIMER_MASK

ADRP X8, #0x4156000
LDR X9, [X8, #0xE90] //; _ZN4sead7Color4f6cBlackE
LDR X8, [X8, #0xE98] //; _ZN4sead7Color4f6cWhiteE

CSEL X8, X9, X8, EQ //; Load black or white color depending on text timer
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
BL 0x19BC22C //; Lp::Sys::DbgTextWriter::productEntryF(int, sead::Vector2<float> const&, Lp::Sys::DbgTextWriter::ArgEx const*, char const*, ...)

LDR S0, posYCancel
STR S0, [SP, #0x3C]

MOV X0, X26
MOV W1, #0x1E
ADD X2, SP, #0x38
ADD X3, SP, #0x10
ADR X4, cancelString
BL 0x19BC22C //; Lp::Sys::DbgTextWriter::productEntryF(int, sead::Vector2<float> const&, Lp::Sys::DbgTextWriter::ArgEx const*, char const*, ...)

LDR S0, posYFly
STR S0, [SP, #0x3C]

MOV X0, X26
MOV W1, #0x1E
ADD X2, SP, #0x38
ADD X3, SP, #0x10
ADR X4, youCanFlyString
BL 0x19BC22C //; Lp::Sys::DbgTextWriter::productEntryF(int, sead::Vector2<float> const&, Lp::Sys::DbgTextWriter::ArgEx const*, char const*, ...)

BL 0x116F5F0 //; Game::Utl::isSpectatorStation(void)
CBNZ W0, restore

MOV X0, X26
MOV W1, #0x1E
ADR X2, posXPos
ADD X3, SP, #0x10
ADR X4, positionString

//; Pass XYZ coords as argument
LDR S0, [X19, #0x748]
LDR S1, [X19, #0x74C]
LDR S2, [X19, #0x750]
FCVT D0, S0
FCVT D1, S1
FCVT D2, S2
BL 0x19BC22C //; Lp::Sys::DbgTextWriter::productEntryF(int, sead::Vector2<float> const&, Lp::Sys::DbgTextWriter::ArgEx const*, char const*, ...)

restore:
LDP X29, X30, [SP], #0x40

end:
MOV X0, X19 //; Original instruction
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


//; Return the Debug Moving bool in Game::Player::isInDebugMove_UpDown
//; This leftover function was changed to always return false in retail
//; It is checked for something with the camera and the player walk animation fix
//; (Allow walk and idle animations in air and slow walk animation)

//; In the debug build, for Debug Move checks, the game just loads the offset directly
//; (like how I'm doing in every hook) instead of calling this function everywhere

//; Because I can't load the offset directly in LDRB, a hook is done to load the bool
//; from it, then returns. Using normal branch instead of BL to return immediately
//; (And to avoid overwriting LR)

//; Game::Player::isInDebugMove
//; 0xE32EF0 -> B 0x1B612D0 (NORMAL BRANCH)

//; Register reference:
//; X0 = Game::Player*


MOV W8, #0x1088
LDRB W0, [X0,X8]
RET


//; No Damage in Debug Moving and Debug Muteki
//; Same code used in both patches
//; Game::Player::isInState_NoDamage(void) + 0x324
//; 0xE3D46C -> BL 0x1B612DC

//; ORR Debug Moving bool and Debug Muteki "bool" together and ORR them
//; with returning W0 bool (invincible if either is true)

//; Register reference:
//; X19 = Game::Player*


LDRB W0, [X19, X8] //; Original instruction

MOV W8, #0x1088
LDRB W1, [X19,X8] //; Debug Moving
LDR W2, [X19, #0x108C] //; Debug Muteki
ORR W1, W1, W2
ORR W0, W0, W1
RET


//; Disable Debug Moving on Super Jump (DokanWarp) Prepare
//; Game::Player::prepareDokanWarp_Start(sead::Vector3<float> const&,int,sead::Vector3<float> const*,int,int,uint) + 0x114
//; 0xE57118 -> BL 0x1B612F8

//; When preparing for a Super Jump, Debug Moving is disabled.
//; Set Debug Moving bool to false

//; Register reference:
//; X21 = Game::Player*


MOV W8, #0x1088
STRB WZR, [X21,X8]
MOV W8, #0x12E8 //; Original instruction
RET


//; Move velocity
//; Game::Player::calcMove(bool) + 0x3DF8
//; 0xE2A7B8 -> BL 0x1B61308

//; If Debug Moving, change move velocity to 
//; 3.6 if not in squid, and 12.0 if in squid
//; Makes you instantly accelerate to max speed
//; and also instantly stop

//; Register reference:
//; X19 = Game::Player*


MOV W8, #0x1088
LDRB W8, [X19,X8]
CBZ W8, end

FMOV S10, #12.0
LDR S11, walkVel

CMP W26, #0 //; isInSquid bool used through the function
FCSEL S10, S10, S11, NE

end:
MOV X2, X21 //; Original instruction
RET
walkVel: .float 3.6


//; Move speed
//; Game::Player::calcMove(bool) + 0x8278
//; 0xE2EC38 -> BL 0x1B61330

//; If Debug Moving, change move speed to 
//; 3.6 if not in squid, and 12.0 if in squid
//; Makes your move speed faster (Max speed)

//; Also skip some speed calculations to avoid modifying
//; the speed calculated in the hook

//; Skip by modifying hook's return address: LR + 0xD4 = 0xE2ED10
//; Returns to the point where the calculated max speed value (S11) is used

//; Register reference:
//; X19 = Game::Player*


MOV W8, #0x1088
LDRB W8, [X19,X8]
CBZ W8, end

STP X29, X30, [SP, #-0x10]!

FMOV S0, #12.0
LDR S1, walkSpeed

//; W26 isInSquid bool is replaced at this point in the function 
//; Call function to check if in squid
MOV X0, X19
BL 0xE2F370 //; Game::Player::isInSquid
CMP W0, #0
FCSEL S11, S0, S1, NE

LDP X29, X30, [SP], #0x10

ADD X30, X30, #0xD4

end:
LDR S0, [X19, #0xB20] //; Original instruction
RET
walkSpeed: .float 3.6


//; Disable max velocity clamp 
//; Game::Player::calcMove(bool) + 0x4AD0
//; 0xE2B490 -> BL 0x1B6136C

//; If Debug Moving, skip velocity clamp call to avoid limiting it
//; Skip by modifying hook's return address: LR + 4 = 0xE2B498
//; Returns to the instruction after the clampLen call (Skipped)

//; Register reference:
//; X19 = Game::Player*


MOV X0, X20 //; Original instruction

MOV W8, #0x1088
LDRB W8, [X19,X8]
CBZ W8, end

ADD X30, X30, #4

end:
RET


//; Disable air velocity decrease
//; Game::Player::calcMove(bool) + 0x4220
//; 0xE2ABE0 -> BL 0x1B61384

//; If Debug Moving, skip air velocity decrease calculations
//; It slows you down by a bit (Barely noticeable, but makes you
//; slower by around ~3.0).

//; Skip by modifying hook's return address: LR + 0x2D4 = 0xE2AEB4
//; Returns past the air velocity decrease calculations

//; Register reference:
//; X19 = Game::Player*


MOV W8, #0x1088
LDRB W8, [X19,X8]
CBZ W8, end

ADD X30, X30, #0x2D0

end:
LDR X8, [X19, #0xF40] //; Original instruction
RET


//; Levitate and move up/down with R-Stick (you can Fly)
//; Game::Player::calcMove(bool) + 0x486C
//; 0xE2B22C -> BL 0x1B6139C

//; If Debug Moving, set some velocities to zero,
//; to make you stay in air and also for other unknown things.
//; Get the controller's right stick Y value, multiply it by 
//; the up/down velocity (1.8 if not in squid, 3.6 if in squid)
//; and set it as one of the fall velocity to fly up/down

//; Register reference:
//; X19 = Game::Player*


MOV W8, #0x1088
LDRB W8, [X19,X8]
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

CMP W26, #0 //; isInSquid bool used through the function
FCSEL S8, S1, S0, NE

LDR X0, [X19, #0xED8]
BL 0xEA1954 //; Game::PlayerGamePad::getRightStick(void)
FMUL S0, S8, S1
STR S0, [X19, #0x910]

LDP X29, X30, [SP], #0x10

end:
LDR S13, [SP, #0x1C] //; Original instruction
RET
upDownVel: .float 1.8
upDownVelSquid: .float 3.6


//; Pass through collision
//; Game::Player::thirdCalc(void) + 0x10AC
//; 0xE30D04 -> BL 0x1B613FC

//; If Debug Moving, pass through collision
//; Load Debug Moving bool, if it's true, skip original
//; instruction//; after the hook, it checks if W8 is 2 and 
//; skips collision call if it is, so, if Debug Moving,
//; W8 is 1: Skip, otherwise, load original instruction
//; for normal behavior

//; Register reference:
//; X19 = Game::Player*


MOV W8, #0x1088
LDRB W8, [X19,X8]
CBNZ W8, end

LDR W8, [X19, #0x10E0] //; Original instruction

end:
RET


//; Disable airfall death
//; Game::Player::thirdCalc(void) + 0x2098
//; 0xE31CF0 -> BL 0x1B61410

//; If Debug Moving, you will not die if staying
//; in the air for too long outside of the stage

//; ORR Debug Moving bool with W8, after the hook
//; it checks if W8 is greater than 0 and skips airfall if so,
//; so it will branch if Debug Moving

//; Register reference:
//; X19 = Game::Player*


LDR W8, [X0, #0x4C] //; Original instruction
MOV W9, #0x1088
LDRB W9, [X19,X9]
ORR W8, W8, W9
RET


//; Pass through enemy team spawn/respawn barrier collision
//; Game::RespawnPoint::calcPlayerCollision_(Game::Player *) + 0x60
//; 0xA12E2C -> BL 0x1B61424

//; If Debug Moving, skip spawn barrier collision
//; Skip by modifying hook's return address: LR + 0x82C = 0xA1365C
//; Returns to the function's end

//; Register reference:
//; X1 = Game::Player*


MOV X20, X1 //; Original instruction

MOV W1, #0x1088
LDRB W1, [X20,X1]
CBZ W1, end

ADD X30, X30, #0x82C

end:
RET


//; Pass through mission Super Jump gateway barrier collision
//; Game::AreaGateway::calcPlayerCollision_(Game::Player *) + 0x38
//; 0xD27360 -> BL 0x1B6143C

//; If Debug Moving, set W8 to zero. After the hook,
//; it checks if W8 is not 1 and branches to function end if so

//; Register reference:
//; X20 = Game::Player*


MOV W9, #0x1088
LDRB W9, [X20,X9]
CMP W9, #0
CSEL W8, WZR, W8, NE
CMP W8, #1 //; Original instruction
RET


//; Pass through Octa DLC Mission platform barrier collision
//; Octa DLC didn't exist in the debug build, this is my own addition
//; which would definitely be added if the DLC existed at the time

//; Game::StationPlatformOcta::onHitBarrier_(Game::Player *,Lp::Utl::CollisionResult const&,sead::Vector3<float> const&) + 0x4C 
//; 0xBC4454 -> BL 0x1B61454

//; If Debug Moving, skip collision calculation call
//; Skip by modifying hook's return address: LR + 0x88 = 0xBC44E0
//; Returns to the function's end

//; Register reference:
//; X1 = Game::Player*


MOV X19, X1 //; Original instruction

MOV W8, #0x1088
LDRB W8, [X19,X8]
CBZ W8, end

ADD X30, X30, #0x88

end:
RET


//; No Octa DLC Mission platform death
//; Octa DLC didn't exist in the debug build, this is my own addition
//; which would definitely be added if the DLC existed at the time

//; Game::SeqMgrMissionOcta::calcCheckBreakJail(void) + 0x30
//; 0xD7A650 -> BL 0x1B6146C

//; If Debug Moving, skip death collision call
//; Hooked in the getControlledPerformer call because after it,
//; there is another call, so the pointer is lost

//; Skip by modifying hook's return address: LR + 0x8 = 0xD7A65C
//; Returns to part of the function that returns false and branches to end


STP X29, X30, [SP, #-0x10]!

BL 0xF07B1C //; Game::PlayerMgr::getControlledPerformer(void) (Original instruction)

LDP X29, X30, [SP], #0x10

MOV W8, #0x1088
LDRB W8, [X0,X8]
CBZ W8, end

ADD X30, X30, #8

end:
RET


//; Plaza Door ignores player
//; Game::PlazaDoor::checkHitPlayer_(Lp::Utl::ShapeCapsule const&) + 0x58
//; 0xC387D8 -> BL 0x1B6148C 

//; If Debug Moving, Plaza doors won't open, and will close
//; if enabling Debug Move when one is open. 
//; It also prevents you from entering shops

//; Replicate nullptr check (For getControlledPerformer call)
//; which branches to function end, and also branch to end if 
//; Debug Moving

//; Skip by modifying hook's return address: LR + 0x54 = 0xC38830
//; Returns to part of the function that returns false and ends

//; Register reference:
//; X0 = Game::Player*


CBZ X0, return //; Replicating original instruction

MOV W8, #0x1088
LDRB W8, [X0,X8]
CBZ W8, end

return:
ADD X30, X30, #0x54

end:
RET


//; Finish grind rail move
//; Game::PlayerGrindRail::firstCalcBindImpl_(void) + 0xBC
//; 0xEA8A9C -> BL 0x1B614A4

//; If Debug Moving, you are forced out of grind rail move 

//; Set eject velocity to zero, set W8 to zero (it is normally
//; 1, but it is zero when ended by Debug Moving, and then branch
//; to the part of the code that stores the values and calls finish, 
//; skipping the rest of calculations

//; Skip by modifying hook's return address: LR + 0x1A0 = 0xEA8C40
//; Returns to part of the function that stores values and then
//; calls grind rail finish, returns AFTER W8 is set to 1, so it 
//; uses the one from the hook instead

//; Register reference:
//; X19 = Game::Player*GrindRail


LDR X8, [X19, #0x18]
MOV W9, #0x1088
LDRB W8, [X8,X9]
CBZ W8, end

STR XZR, [SP]
STR WZR, [SP, #8]
MOV W8, WZR

ADD X30, X30, #0x1A0

end:
LDR W8, [X19, #0x30] //; Original instruction
RET


//; Finish ink rail move
//; Game::PlayerInkRailVersus::calcPlayerPos_stateBind_(void) + 0x150
//; 0xEEEE38 -> BL 0x1B614CC

//; If Debug Moving, you are forced out of ink rail move, but you
//; actually stay stuck in the ink rail if in squid form, but can't move

//; Set eject velocity to zero, set W8 to zero (it is normally
//; 1, but it is zero when ended by Debug Moving, and then branch
//; to the part of the code that stores the values and calls finish, 
//; skipping the rest of calculations

//; Skip by modifying hook's return address: LR + 0x28 = 0xEEEE64
//; Returns to part of the function that stores values and then
//; calls ink rail finish, returns AFTER W8 is set to 1, so it 
//; uses the one from the hook instead

//; Register reference:
//; X19 = Game::PlayerInkRailVersus*

LDR X0, [X19, #0x120]
MOV X8, #0x1088
LDRB W8, [X0,X8]
CBZ W8, end

STR XZR, [SP, #0x28]
STR WZR, [SP, #0x30]
MOV W8, WZR

ADD X30, X30, #0x28

end:
LDRB W8, [SP, #0x34] //; Original instruction
RET


//; Prevent starting Rainmaker DunkShoot VictoryGoal (VGoal)
//; Game::Player::checkVGoal_ToDunkShoot(void) + 0x28
//; 0xE3DB70 -> BL 0x1B614F4

//; If Debug Moving, you can't start the rainmaker dunk shoot goal

//; Override W0 with 7, after this hook, it checks if W0 is 7
//; and branches to end if so

//; Register reference:
//; X19 = Game::Player*


MOV W8, #0x1088
LDRB W8, [X19,X8]
CBZ W8, end

MOV W0, #7

end:
CMP W0, #7 //; Original instruction
RET



//; Cancel Rainmaker DunkShot VictoryGoal (VGoal)
//; Game::Player::calcPrepare(void) + 0xA40
//; 0xE21CC4 -> BL 0x1B6150C

//; If enabling Debug Move while dunking the rainmaker, it will
//; cancel the dunk, avoiding the goal.
//; In FreeTest, you normally get softlocked after goal, but this unsoftlocks it

//; Store zero to some VictoryGoal bool and skip some calculations

//; Skip by modifying hook's return address: LR + 0x38 = 0xE21D00
//; Returns past some calculations and checks related to VictoryGoal

//; Register reference:
//; X8 = Game::VictoryGoal*
//; X19 = Game::Player*


MOV W10, #0x1088
LDRB W10, [X19,X10]
CBZ W10, end

STRB WZR, [X8, #0x580]

ADD X30, X30, #0x38

end:
LDR S0, [X19, #0x74C] //; Original instruction
RET


//; Allow starting Super Jump (DokanWarp) in air
//; Game::PlayerDokanWarp::calc(void) + 0x3C0
//; 0xE94D64 -> BL 0x1B61528

//; If Debug Moving, you can start a Super Jump while in the air

//; After this hook, it checks if W8 is 2 and branches to call
//; DokanWarp start even if in air, so override W8 with 2 if
//; Debug Moving

//; Register reference:
//; X19 = Game::PlayerDokanWarp*


LDR W8, [X19, #0x98] //; Original instruction

LDR X9, [X19]
MOV W10, #0x1088
LDRB W9, [X9,X10]
CBZ W9, end

MOV W8, #2

end:
RET


//; Allow starting Super Jump (DokanWarp) land animation in air
//; Game::PlayerDokanWarp::calc(void) + 0x480 and +0x484
//; 0xE94E24 -> BL 0x1B61544 and 0xE94E28 -> CBZ W8, 0xE94E64

//; If Debug Moving, the landing animation from Super Jump can
//; start while in the air

//; In retail, it loads zero to W8 and branches, never
//; using W8, while in debug build, it's the Debug Moving
//; bool load and conditional branch
//; Likely an inline of IsInDebugMove_UpDown or weird ifndef

//; Replace it with the actual bool load and conditional branch
//; on the next instruction

//; Hooking because I can't load offset directly in LDRB

//; Register reference:
//; X9 = Game::PlayerDokanWarp*


MOV W8, #0x1088
LDR W8, [X9,X8]
RET


//; Clear air camera on Super Jump (DokanWarp) land
//; Game::PlayerBehindCamera::calcPosAt(void) + 0xDE8
//; 0xE6F5CC -> BL 0x1B61550

//; If Debug Moving, the air camera will be cleared after
//; landing from a Super Jump. It doesn't normally because you 
//; stay in the air

//; Clear by modifying hook's return address: LR + 0x40 = 0xE6F610
//; Returns to the part of the code that clears the air camera

//; Register reference:
//; X19 = Game::PlayerBehindCamera*


LDR X8, [X19]
MOV X9, #0x1088
LDRB W8, [X8,X9]
CBZ W8, end

ADD X30, X30, #0x40

end:
LDRB W8, [X19, #0x388] //; Original instruction
RET


//; Disable moving camera up/down with R-Stick if Motion Controls are off
//; Game::PlayerBehindCamera::calcControl(void) + 0x73C
//; 0xE6BF64 -> BL 0x1B6156C

//; If Debug Moving, replace S14 with S11 (sero) so camera can't be moved up/down
//; when Motion Controls are off

//; Register reference:
//; X19 = Game::PlayerBehindCamera*


LDR X9, [X19]
MOV W10, #0x1088
LDRB W9, [X9,X10]
CMP W9, #0
FCSEL S14, S11, S14, NE

FCMP S14, S0 //; Original instruction
RET