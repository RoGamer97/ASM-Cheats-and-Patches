//; Game: Splatoon 2
//; Game version: 5.5.2
//; Code: Debug Moving


//; Hooks are placed in unused functions because there is no space left in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


//; Disable player inputs if Minus is held
//; Cmn::PlayerCtrl::isHold(ulong) + 0x10 and Cmn::PlayerCtrl::isTrig(ulong) + 0x10
//; 0xD5D38 -> BL 0x1AA96AC
//; 0xD5D68 -> BL 0x1AA96AC

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
//; 0x107BCE4 -> BL 0x1AA96C0

//; If Minus is held, load Vector2 zero address and
//; skip getting the controller's right stick address
//; (since Vector2 address is loaded instead)

//; Probably done to avoid the camera from moving when enabling debug features
//; or other reason that I don't know (Similar to player inputs being disabled)

//; Skip by modifying hook's return address: LR + 0x10 = 0x107BCF8
//; Returns past the getRightStick call, where the stick values are loaded
//; from the returned pointer


.set BUTTONBIT_MINUS, 9

MOV X29, SP //; Original instruction
STP X29, X30, [SP,#-0x10]!

MOV W0, WZR
BL 0x19EC714 //; Lp::Utl::getCtrl(int)

LDP X29, X30, [SP], #0x10

LDR W0, [X0, #0x10]
TBZ W0, #BUTTONBIT_MINUS, end //; Minus button not held

ADRP X0, #0x2CFD000
LDR X0, [X0, #0x850] //; _ZN4sead7Vector2IfE4zeroE

ADD X30, X30, #0x10

end:
RET


//; The Debug Moving bool member variable exists in retail at Game::Player + 0x10C0
//; It is never read, but it is written to by 2 different functions:

//; Game::Player::reset_Impl(bool,Cmn::Def::ResetType) + 0x3C4 -> Sets it to false
//; Game::Player::calcPrepare(void) + 0x4C -> Sets it to false

//; This reimplementation will use it.
//; You will see checks for it in most hooks and writes to it in some places as well.

//; LDRB/STRB cannot be used with this offset, so it is loaded into a register and Game::Player is indexed from it.



//; Debug Moving Toggle, Slow Fall and Text Timer Increment
//; Game::Player::calcControl(void) + 0xFE4
//; 0xFF4978 -> BL 0x1AA9780

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

//; Sets custom "dirty" bool when toggled, for Display Dirty (D) Debug Mark patch

//; Increments text flash timer in R-W if enabled.
//; Can't draw text here, so there is another hook for text drawing
//; but text flash timer must be incremented here because doing it in the 
//; text draw code would make the timer increase differently the function
//; it is hooked at may not run only once every frame


//; Register reference:
//; X19 = Game::Player*


.set BUTTONBIT_MINUS, 9

LDR W8, [X19, #0x358]
CBNZ W8, end //; Not controlled player

STP X29, X30, [SP, #-0x40]!

MOV W0, WZR
BL 0x19EC714 //; Lp::Utl::getCtrl(int)

ADRP X23, #0x29E7000

MOV W9, #0x10C0

LDR W8, [X0, #0x10]
TBZ W8, #BUTTONBIT_MINUS, isToggleTrig //; Minus button not held

LDR S0, [X19, #0x910]
LDR S1, velMultiplier
FMUL S0, S0, S1
STR S0, [X19, #0x910]

isToggleTrig:
LDR W0, [X0, #0x94]
TBZ W0, #BUTTONBIT_MINUS, isInDebugMove //; Minus button not triggered

LDRB W8, [X23, #0x14]
CBNZ W8, isInDebugMove //; Debug Marching/Leading enabled

LDRB W8, [X19,X9]
EOR W8, W8, #1
STRB W8, [X19,X9]

MOV W8, #1
STRB W8, [X23, #0x15] //; Custom "dirty" bool

isInDebugMove:
LDRB W8, [X19,X9]
CBZ W8, restore

LDR W8, [X23, #8]
ADD W8, W8, #1
STR W8, [X23, #8]

restore:
LDP X29, X30, [SP], #0x40

end:
MOV X0, X19 //; Original instruction
RET

velMultiplier: .float 0.7


//; Return the Debug Moving bool in Game::Player::isInDebugMove_UpDown
//; This leftover function was changed to always return false in retail
//; It is checked for something with the camera and the player walk animation fix
//; (Allow walk and idle animations in air and slow walk animation)

//; In the debug build, for Debug Move checks, the game just loads the offset directly
//; (like how I'm doing in every hook) instead of calling this function everywhere

//; Because I can't load the offset directly in LDRB, a hook is done to load the bool
//; from it, then returns. Using normal branch instead of BL to return immediately
//; (And to avoid overwriting LR)

//; Game::Player::isInDebugMove_UpDown(void)
//; 0x1005EB0 -> B 0x1AA9800 (NORMAL BRANCH)

MOV W8, #0x10C0
LDRB W0, [X0,X8]
RET


//; No Damage in Debug Moving and Debug Muteki
//; Same code used in both patches
//; Game::Player::isInState_NoDamage(void) + 0x334
//; 0x1010E8C -> BL 0x1AA980C

//; ORR Debug Moving bool and Debug Muteki "bool" together and ORR them
//; with returning W0 bool (invincible if either is true)

//; Register reference:
//; X19 = Game::Player*


LDRB W0, [X19, X8] //; Original instruction

MOV W8, #0x10C0
LDRB W1, [X19,X8] //; Debug Moving
LDR W2, [X19, #0x10C4] //; Debug Muteki
ORR W1, W1, W2
ORR W0, W0, W1
RET


//; Disable Debug Moving on Super Jump (DokanWarp) Prepare
//; Game::Player::prepareDokanWarp_Start(sead::Vector3<float> const&,int,sead::Vector3<float> const*,int,int,uint) + 0x114
//; 0x102A7BC -> BL 0x1AA9828

//; When preparing for a Super Jump, Debug Moving is disabled.
//; Set Debug Moving bool to false

//; Register reference:
//; X21 = Game::Player*


MOV W8, #0x10C0
STRB WZR, [X21,X8]
MOV W8, #0x1348 //; Original instruction
RET


//; Move velocity
//; Game::Player::calcMove(bool) + 0x5D1C
//; 0xFFDF00 -> BL 0x1AA9838

//; If Debug Moving, change move velocity to 
//; 3.6 if not in squid, and 12.0 if in squid
//; Makes you instantly accelerate to max speed
//; and also instantly stop

//; Register reference:
//; X19 = Game::Player*


MOV W8, #0x10C0
LDRB W8, [X19,X8]
CBZ W8, end

FMOV S0, #12.0
LDR S10, walkVel

CMP W26, #0 //; isInSquid bool used through the function
FCSEL S10, S0, S10, NE

end:
MOV X2, X22 //; Original instruction
RET
walkVel: .float 3.6


//; Move speed
//; Game::Player::calcMove(bool) + 0x4B2C
//; 0xFFCD10 -> BL 0x1AA9860

//; If Debug Moving, change move speed to 
//; 3.6 if not in squid, and 12.0 if in squid
//; Makes your move speed faster (Max speed)

//; Also skip some speed calculations to avoid modifying
//; the speed calculated in the hook

//; Skip by modifying hook's return address: LR + 0xE0 = 0xFFCDF4
//; Returns to the point where the calculated max speed value (S11) is used

//; Register reference:
//; X19 = Game::Player*


MOV W8, #0x10C0
LDRB W8, [X19,X8]
CBZ W8, end

STP X29, X30, [SP, #-0x10]!

FMOV S0, #12.0
LDR S1, walkSpeed

//; W26 isInSquid bool is replaced at this point in the function 
//; Call function to check if in squid
MOV X0, X19
BL 0x1001960 //; Game::Player::isInSquid
CMP W0, #0
FCSEL S11, S0, S1, NE

LDP X29, X30, [SP], #0x10

ADD X30, X30, #0xE0

end:
LDR S0, [X19, #0xB2C] //; Original instruction
RET
walkSpeed: .float 3.6


//; Disable max velocity clamp
//; Game::Player::calcMove(bool) + 0x6B58
//; 0xFFED3C -> BL 0x1AA989C

//; If Debug Moving, skip velocity clamp call to avoid limiting it
//; Skip by modifying hook's return address: LR + 4 = 0xFFED44
//; Returns to the instruction after the clampLen call (Skipped)

//; Register reference:
//; X19 = Game::Player*


MOV X0, X20 //; Original instruction

MOV W8, #0x10C0
LDRB W8, [X19,X8]
CBZ W8, end

ADD X30, X30, #4

end:
RET


//; Disable air velocity decrease
//; Game::Player::calcMove(bool) + 0x621C
//; 0xFFE400 -> BL 0x1AA98B4

//; If Debug Moving, skip air velocity decrease calculations
//; It slows you down by a bit (Barely noticeable, but makes you
//; slower by around ~3.0).

//; Skip by modifying hook's return address: LR + 0x304 = 0xFFE708
//; Returns past the air velocity decrease calculations

//; Register reference:
//; X19 = Game::Player*


MOV W8, #0x10C0
LDRB W8, [X19,X8]
CBZ W8, end

ADD X30, X30, #0x304

end:
LDR X8, [X19, #0xF60] //; Original instruction
RET


//; Levitate and move up/down with R-Stick (you can Fly)
//; Game::Player::calcMove(bool) + 0x68B0
//; 0xFFEA94 -> BL 0x1AA98CC

//; If Debug Moving, set some velocities to zero,
//; to make you stay in air and also for other unknown things.
//; Get the controller's right stick Y value, multiply it by 
//; the up/down velocity (1.8 if not in squid, 3.6 if in squid)
//; and set it as one of the fall velocity to fly up/down

//; Register reference:
//; X19 = Game::Player*


MOV W8, #0x10C0
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

LDR X0, [X19, #0xEF0]
BL 0x107BCC4 //; Game::PlayerGamePad::getRightStick(void)
FMUL S0, S8, S1
STR S0, [X19, #0x910]

LDP X29, X30, [SP], #0x10

end:
MOV V0.16B, V14.16B //; Original instruction
RET
upDownVel: .float 1.8
upDownVelSquid: .float 3.6


//; Pass through collision
//; Game::Player::thirdCalc(void) + 0x1600
//; 0x1003A10 -> BL 0x1AA992C

//; If Debug Moving, pass through stage collision
//; Load Debug Moving bool, if it's true, skip original
//; instruction//; after the hook, it checks if W8 is 2 and 
//; skips collision call if it is, so, if Debug Moving,
//; W8 is 1: Skip, otherwise, load original instruction
//; for normal behavior

//; Register reference:
//; X19 = Game::Player*


MOV W8, #0x10C0
LDRB W8, [X19,X8]
CBNZ W8, end

LDR W8, [X19, #0x1118] //; Original instruction

end:
RET


//; Disable airfall death
//; Game::Player::thirdCalc(void) + 0x2098
//; 0x1004AFC -> BL 0x1AA9940

//; If Debug Moving, you will not die if staying
//; in the air for too long outside of the stage

//; ORR Debug Move bool with W8, after the hook
//; it checks if W8 is greater than 0 and skips airfall if so,
//; so it will branch if Debug Moving

//; Register reference:
//; X19 = Game::Player*


LDR W8, [X0, #0x4C] //; Original instruction
MOV W9, #0x10C0
LDRB W9, [X19,X9]
ORR W8, W8, W9
RET


//; Pass through enemy team spawn/respawn barrier collision
//; Game::RespawnPoint::calcPlayerCollision_(Game::Player *) + 0x60
//; 0xB76088 -> BL 0x1AA9954

//; If Debug Moving, skip spawn barrier collision
//; Skip by modifying hook's return address: LR + 0x84C = 0xB768D8 
//; Returns to the function's end

//; Register reference:
//; X1 = Game::Player*


MOV X20, X1 //; Original instruction

MOV W1, #0x10C0
LDRB W1, [X20,X1]
CBZ W1, end

ADD X30, X30, #0x84C

end:
RET


//; Pass through mission Super Jump gateway barrier collision
//; Game::AreaGateway::calcPlayerCollision_(Game::Player *) + 0x38
//; 0xEC6CF4 -> 0x1AA996C

//; If Debug Moving, set W8 to zero. After the hook,
//; it checks if W8 is not 1 and branches to function end if so

//; Register reference:
//; X20 = Game::Player*


MOV W9, #0x10C0
LDRB W9, [X20,X9]
CMP W9, #0
CSEL W8, WZR, W8, NE
CMP W8, #1 //; Original instruction
RET


//; Pass through Octa DLC Mission platform barrier collision
//; Octa DLC didn't exist in the debug build, this is my own addition
//; which would definitely be added if the DLC existed at the time

//; Game::StationPlatformOcta::onHitBarrier_(Game::Player *,Lp::Utl::CollisionResult const&,sead::Vector3<float> const&) + 0x4C 
//; 0xD154D0 -> BL 0x1AA9984

//; If Debug Moving, skip collision calculation call
//; Skip by modifying hook's return address: LR + 0x88 = 0xD1555C
//; Returns to the function's end

//; Register reference:
//; X1 = Game::Player*


MOV X19, X1 //; Original instruction

MOV W8, #0x10C0
LDRB W8, [X19,X8]
CBZ W8, end

ADD X30, X30, #0x88

end:
RET


//; No Octa DLC Mission platform death
//; Octa DLC didn't exist in the debug build, this is my own addition
//; which would definitely be added if the DLC existed at the time

//; Game::SeqMgrMissionOcta::calcCheckBreakJail(void) + 0x30
//; 0xF12B4C -> BL 0x1AA999C

//; If Debug Moving, skip death collision call
//; Hooked in the getControlledPerformer call because after it,
//; there is another call, so the pointer is lost

//; Skip by modifying hook's return address: LR + 0x8 = 0xF12B58
//; Returns to part of the function that returns false and branches to end

STP X29, X30, [SP, #-0x10]!

BL 0x10E6D2C //; Game::PlayerMgr::getControlledPerformer(void) (Original instruction)

LDP X29, X30, [SP], #0x10

MOV W8, #0x10C0
LDRB W8, [X0,X8]
CBZ W8, end

ADD X30, X30, #8

end:
RET


//; Plaza door code is different in 5.5.2, so 3 hooks have to be made instead of 1
//; The same thing happens in the March Prototype, it has checks in 3 different PlazaDoor
//; functions, but for the QA debug build, it only has 1 check in Game::PlazaDoor::checkHitPlayer_
//; (which was called in the other Plaza door functions for state change etc, but this isn't 
//; the case in 5.5.2 and March Prototype)

//; Plaza Door won't open
//; Game::PlazaDoor::stateOpen_(void) + 0x40
//; 0xDC7B80 -> BL 0x1AA99BC

//; If Debug Moving, Plaza doors won't open

//; Replicate nullptr check (For getControlledPerformer call)
//; which branches to function end, and also branch to end if 
//; Debug Moving

//; Skip by modifying hook's return address: LR + 0x64 = 0xDC7BE8
//; Returns to part of the function that returns false and ends

//; Register reference:
//; X0 = Game::Player*


CBZ X0, return //; Replicating original instruction

MOV W8, #0x10C0
LDRB W8, [X0,X8]
CBZ W8, end

return:
ADD X30, X30, #0x64

end:
RET


//; Close Plaza Door
//; Game::PlazaDoor::stateClose_(void) + 0x80
//; 0xDC7C78 -> BL 0x1AA99D4

//; If Debug Moving, Plaza doors will close

//; Replicate nullptr check (For getControlledPerformer call)
//; which branches to part of the function that changes 
//; door state to "Close"

//; Skip by modifying hook's return address: LR + 0x50 = 0xDC7CCC
//; Returns to part of the function that changes the door state to "Close"

//; Register reference:
//; X0 = Game::Player*


CBZ X0, return //; Replicating original instruction

MOV W8, #0x10C0
LDRB W8, [X0,X8]
CBZ W8, end

return:
ADD X30, X30, #0x50

end:
RET


//; Avoid entering Plaza shop scene
//; Game::PlazaDoor::checkHitPlayer_(Lp::Utl::ShapeCapsule const&) + 0xCC
//; 0xDC7AAC -> BL 0x1AA99EC

//; If Debug Moving, you can't enter Plaza shops scene

//; Replicate nullptr check (For getControlledPerformer call)
//; which branches to part of the function that changes 
//; door state to "Close"

//; Skip by modifying hook's return address: LR + 0x6C = 0xDC7B1C
//; Returns to the function's end

//; Register reference:
//; X0 = Game::Player*


CBZ X0, return //; Replicating original instruction

MOV W8, #0x10C0
LDRB W8, [X0,X8]
CBZ W8, end

return:
ADD X30, X30, #0x6C

end:
RET


//; Finish grind rail move
//; Game::PlayerGrindRail::firstCalcBindImpl_(void) + 0x88
//; 0x1088118 -> BL 0x1AA9A04

//; If Debug Moving, you are forced out of grind rail move 

//; Set eject velocity to zero, set W8 to zero (it is normally
//; 1, but it is zero when ended by Debug Move, and then branch
//; to the part of the code that stores the values and calls finish, 
//; skipping the rest of calculations

//; Skip by modifying hook's return address: LR + 0x15C = 0x1088278
//; Returns to part of the function that stores values and then
//; calls grind rail finish, returns AFTER W8 is set to 1, so it 
//; uses the one from the hook instead

//; Register reference:
//; X19 = Game::Player*GrindRail


LDR X8, [X19, #0x18]
MOV W9, #0x10C0
LDRB W8, [X8,X9]
CBZ W8, end

STR XZR, [X29, #-0x60]
STR WZR, [X29, #-0x58]
MOV W8, WZR

ADD X30, X30, #0x15C

end:
LDR X8, [X19, #0x18] //; X8 is lost, restore it
LDR W9, [X19, #0x30] //; Original instruction
RET


//; Finish ink rail move
//; Game::PlayerInkRailVersus::calcPlayerPos_stateBind_(void) + 0x150
//; 0x10CD594 -> BL 0x1AA9A30

//; If Debug Moving, you are forced out of ink rail move, but you
//; actually stay stuck in the ink rail if in squid form, but can't move

//; Set eject velocity to zero, set W8 to zero (it is normally
//; 1, but it is zero when ended by Debug Move, and then branch
//; to the part of the code that stores the values and calls finish, 
//; skipping the rest of calculations

//; Skip by modifying hook's return address: LR + 0x28 = 0xEEEE64
//; Returns to part of the function that stores values and then
//; calls ink rail finish, returns AFTER W8 is set to 1, so it 
//; uses the one from the hook instead

//; Register reference:
//; X19 = Game::PlayerInkRailVersus*


LDR X0, [X19, #0x120]
MOV W8, #0x10C0
LDRB W8, [X0,X8]
CBZ W8, end

STR XZR, [SP, #0x28]
STR WZR, [SP, #0x30]
MOV W8, WZR

ADD X30, X30, #0x28

end:
LDRB W8, [SP, #0x34] //; Original instruction
RET


//; Prevent starting Rainmaker DunkShot VictoryGoal (VGoal)
//; Game::Player::checkVGoal_ToDunkShoot(void) + 0x28
//; 0x1011310 -> BL 0x1AA9A58

//; If Debug Moving, you can't start the rainmaker dunk shoot goal

//; Override W0 with 7, after this hook, it checks if W0 is 7 (curMode)
//; and branches to function end if it is

//; Register reference:
//; X19 = Game::Player*


MOV W8, #0x10C0
LDRB W8, [X19,X8]
CBZ W8, end

MOV W0, #7

end:
CMP W0, #7 //; Original instruction
RET



//; Cancel Rainmaker DunkShot VictoryGoal (VGoal)
//; Game::Player::calcPrepare(void) + 0xA40
//; 0xFF3074 -> BL 0x1AA9A70

//; If enabling Debug Move while dunking the rainmaker, it will
//; cancel the dunk, avoiding the goal.
//; In FreeTest, you normally get softlocked after goal, but this unsoftlocks it

//; Store zero to some VictoryGoal bool and skip some calculations

//; Skip by modifying hook's return address: LR + 0x38 = 0xFF30B0
//; Returns past some calculations and checks related to VictoryGoal

//; Register reference:
//; X8 = Game::VictoryGoal*
//; X19 = Game::Player*


MOV W10, #0x10C0
LDRB W10, [X19,X10]
CBZ W10, end

STRB WZR, [X8, #0x580]

ADD X30, X30, #0x38

end:
LDR S0, [X19, #0x74C] //; Original instruction
RET


//; Allow starting Super Jump (DokanWarp) in air
//; Game::PlayerDokanWarp::calc(void) + 0x3C0
//; 0x106BFA8 -> BL 0x1AA9A8C

//; If Debug Moving, you can start a Super Jump while in the air

//; After this hook, it checks if W8 is 2 and branches to call
//; DokanWarp start even if in air, so override W8 with 2 if
//; Debug Moving

//; Register reference:
//; X19 = Game::PlayerDokanWarp*


LDR W8, [X19, #0xA0] //; Original instruction

LDR X9, [X19]
MOV W10, #0x10C0
LDRB W9, [X9,X10]
CBZ W9, end

MOV W8, #2

end:
RET


//; Allow starting Super Jump (DokanWarp) land animation in air
//; Game::PlayerDokanWarp::calc(void) + 0x480 and 0x484
//; 0x106C068 -> BL 0x1AA9AA8 and 0x106C06C CBZ W8, 0x106C0A8
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
//; X9 = Game::Player*


MOV W8, #0x10C0
LDR W8, [X9,X8]
RET


//; Clear air camera on Super Jump (DokanWarp) land
//; Game::PlayerBehindCamera::calcPosAt(void) + 0xF58
//; 0x1042308 -> BL 0x1AA9AB4

//; If Debug Moving, the air camera should be cleared after
//; landing from a Super Jump. It doesn't normally because you 
//; stay in the air

//; Clear by modifying hook's return address: LR + 0x40 = 0x104234C
//; Returns to the part of the code that clears the air camera

//; Register reference:
//; X19 = Game::PlayerBehindCamera*


LDR X8, [X19]
MOV X9, #0x10C0
LDRB W8, [X8,X9]
CBZ W8, end

ADD X30, X30, #0x40

end:
LDRB W8, [X19, #0x398] //; Original instruction
RET


//; Disable moving camera up/down with R-Stick if Motion Controls are off
//; Game::PlayerBehindCamera::calcControl(void) + 0x790
//; 0x103EACC -> BL 0x1AA9AD0

//; If Debug Moving, replace S14 with S11 (sero) so camera can't be moved up/down
//; when Motion Controls are off

//; Register reference:
//; X19 = Game::PlayerBehindCamera*


LDR X9, [X19]
MOV W10, #0x10C0
LDRB W9, [X9,X10]
CMP W9, #0
FCSEL S14, S11, S14, NE

FCMP S14, S0 //; Original instruction
RET


//; DbgTextWriter functions were removed after 3.1.0, but there is TextWriter debug text present in the game.
//; In gsys::SystemTask::invokeDrawTV_(agl::DrawContext *), there is some debug text that prints the TV draw information, such as the 
//; resolution width, scale, color etc. Trying to call TextWriter print is way complicated because it requires creating 
//; and //; calling so many things for it to work, and I wasn't even able to do it because of how it is handled. 
//; So, I decided to make my own system by enabling the debug TV draw info, removing the info draw, and making my own
//; hooks there since everything I need to draw is already present there. Additionally, I even made my own function
//; to print both text and text outline (they're separated) with the blink flash animation to make drawing text easier, 
//; or else I'd have to replicate the draw setup multiple times, enlarging the code size by way too much...

//; Starlight does the same thing to draw text (Enables TV draw, removes info draw etc) so I made some modifications in the
//; function to make my text drawingcompatible with Starlight draws

//; Enable debug TV draw info
//; gsys::SystemTask::invokeDrawTV_(agl::DrawContext *) + 0x284
//; 0x185153C -> NOP


//; Change one of the texts to nothing, to avoid printing it (Can't kill the text draw call because Starlight writes to that address)
//; So doing this for compatibility
//; 024AB808 -> 00 (Null terminator on first character)


//; Skip drawing rest of debug text, at this point in the function, Starlight already hooked past all text, adding this if Starlight is 
//; not being used
//; 01851658 -> B 0x185190C


//; My own function to draw the text, text outline and color flash. For Debug Moving, Debug Muteki and Debug Marching/Leading draw. Dirty (D) doesn't use this function
//; 0185165C (Placed inside of the function, the part that is skipped. Other hooks will call this to draw text)

//; Arguments: SP Address, String Address, Text Coords Address, Blink Timer, Address for Coords Vector3 (for Debug Moving Pos draw, pass null for none)

//; Print text outline first, then text after

//; Register reference:
//; X0 = SP address
//; X1 = String address
//; X2 = Text Coords Address
//; W3 = Blink Timer
//; X4 = Player Coords Address


STP X29, X30, [SP, #-0x30]!
STP X19, X20, [SP, #0x10]
STP X21, X22, [SP, #0x20]

MOV X19, X0
MOV X20, X2
MOV X21, X4

ADRP X8, #0x2CFE000
LDR X9, [X8, #0x440] //; _ZN4sead7Color4f6cBlackE
LDR X8, [X8, #0x448] //; _ZN4sead7Color4f6cWhiteE

AND W3, W3, #0x60
CMP W3, #0x60
CSEL X22, X9, X8, EQ //; Load black or white color depending on text timer (Text)
CSEL X8, X9, X8, NE //; Load black or white color depending on text timer (Text Outline, inverted)

LDP X8, X9, [X8]
STR X8, [X19, #0x460]
STR X9, [X19, #0x468]

FMOV S0, #1.0
FMOV S1, #-1.0

//; Offset text outline
LDP S2, S3, [X20]
FADD S2, S2, S0
FADD S3, S3, S1
ADD X0, X19, #0x450
STP S2, S3, [X0]

//; Load coords XYZ for string format if not null and convert to double
CBZ X21, formatString
LDP S0, S1, [X21]
LDR S2, [X21, #8]
FCVT D0, S0
FCVT D1, S1
FCVT D2, S2

formatString:
ADD X0, X19, #0x10
BL 0x13D030 //; sead::FormatFixedSafeString<1024>::FormatFixedSafeString(char const*,...)

ADD X0, X19, #0x10
LDR X8, [X19, #0x10]
LDR X8, [X8,#0x18]
BLR X8 //; sead::BufferedSafeStringBase<char>::assureTerminationImpl_(void)

//; Print text outline
ADD X0, X19, #0x428
LDR X1, [X19, #0x18]
MOV W2, #0xFFFFFFFF
MOV W3, #1
MOV X4, XZR
BL 0x174A91C //; sead::TextWriter::printImpl_(char const*,int,bool,sead::BoundBox2<float> *)

LDP X0, X1, [X22]
STR X0, [X19, #0x460]
STR X1, [X19, #0x468]

LDR X0, [X20]
STR X0, [X19, #0x450]

//; Print text
ADD X0, X19, #0x428
LDR X1, [X19, #0x18]
MOV W2, #0xFFFFFFFF
MOV W3, #1
MOV X4, XZR
BL 0x174A91C //; sead::TextWriter::printImpl_(char const*,int,bool,sead::BoundBox2<float> *)

LDP X19, X20, [SP, #0x10]
LDP X21, X22, [SP, #0x20]
LDP X29, X30, [SP], #0x30
RET


//; Debug Moving Text
//; gsys::SystemTask::invokeDrawTV_(agl::DrawContext *) + 0x654
//; 0x185190C -> BL 0x1AA9AEC

//; Call my own text draw function for text draw

//; This code is always executing, but it will only
//; draw text if Debug Marching/Leading is enabled

//; Since it always runs, nullptr checks must be
//; done when trying to load PlayerMgr and 
//; get the ControlledPerformer Game::Player

//; Pos text doesnt draw in Spectator in the debug build,
//; but that's because it is drawn in another function, separated
//; from Debug Moving draw, and that one doesn't run in spectator.
//; Since it runs here, the Pos would show in spectator, but with 
//; coords showing as 0.00, 0.00, 0.00
//; To avoid this, skip Pos draw if in spectator mode to match 
//; debug build behavior

MOV X26, SP

STP X29, X30, [SP, #-0x10]!

ADRP X0, #0x2CFD000
LDR X0, [X0, #0xCF8]
LDR X0, [X0]
CBZ X0, end
BL 0x10E6D2C //; Game::PlayerMgr::getControlledPerformer(void)
CBZ X0, end

ADD X29, X0, #0x748 //; Player XYZ Coords Vector3 address
MOV W8, #0x10C0
LDRB W0, [X0,X8]
CBZ W0, end //; Debug Move disabled

ADRP X8, #0x29E7000
LDR W24, [X8, #8] //; Text flash timer

MOV X0, X26
ADR X1, debugMovingString
ADR X2, posXMoving
MOV W3, W24
MOV X4, XZR
BL 0x185165C //; My own text draw function

MOV X0, X26
ADR X1, cancelString
ADR X2, posXCancel
MOV W3, W24
MOV X4, XZR
BL 0x185165C //; My own text draw function

MOV X0, X26
ADR X1, youCanFlyString
ADR X2, posXFly
MOV W3, W24
MOV X4, XZR
BL 0x185165C //; My own text draw function

BL 0x1354BD0 //; Game::Utl::isSpectatorStation
CBNZ X0, end

MOV X0, X26
ADR X1, positionString
ADR X2, posXPos
MOV W3, W24
MOV X4, X29
BL 0x185165C //; My own text draw function

end:
LDP X29, X30, [SP], #0x10
LDR W8, [X19, #0x558] //; Original instruction
RET

posXMoving: .float -610
posYMoving: .float -205

posXCancel: .float -610
posYCancel: .float -220

posXFly: .float -610
posYFly: .float -235

posXPos: .float 380
posYPos: .float -160

debugMovingString: .asciz "Debug Moving..."
cancelString: .asciz "  Push    [-]   -> Cancel"
youCanFlyString: .asciz "  R-Stick [U/D] -> you can Fly"
positionString: .asciz "Pos : %.2f, %.2f, %.2f"