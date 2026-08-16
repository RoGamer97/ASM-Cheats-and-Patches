//; Game: Mario Kart 8 Deluxe
//; Game version: 3.0.5
//; Code: Free Camera Toolkit

//; You can find some documented headers here to learn more about the game
//; and know some offsets: https://github.com/fishguy6564/MK8DX-Headers

//; Hooks are written over unused functions (never executed).
//; There is a bit of free space in .text, but for some reason the emulator
//; crashes when executing code in that space. Writing over unused functions
//; doesn't cause a crash.


//; Free Camera is part of Nintendo's AGL library and is present in many games.
//; A toggle for it doesn't exist in the retail game, but controls do, except that some things
//; need to be patched for it to work.
//; Thanks to Shadów (shadowninja108) for teaching me how to enable it!
//; You can find his Splatoon 2 Free Camera repo for more information: https://github.com/shadowninja108/s2-freecam/tree/main

//; Other than that, other additional features are added to make it into a more complete toolkit

//; Initialize agl::lyr::Layer::DebugInfo* and some other agl::lyr::Layer thing (?)
//; agl::lyr::Layer::initialize_(sead::Heap *) + 0x100, 0x110 and 0x134 (Not a hook)
//; 0x6714F0 -> NOP (Remove null HEAP pointer check)
//; 0x671500 -> BL 0x58F708 malloc (Call malloc instead of operator new)
//; 0x671524 -> BL 0x58F708 malloc (Call malloc instead of operator new)

//; Now, Debug Camera has been initialized and agl::lyr::Layer can be calculated


//; Enable controller
//; agl::lyr::Renderer::calc(bool) + 0x148 (Not a hook)
//; 0x673D58 -> MOV W8, #1
//; Overrides the loaded W8 value (Some agl::lyr::Renderer* member variable) 
//; with 1 to enable camera control (sead::Controller const* pointer for the 
//; agl::lyr::Layer::calc_(sead::Controller const*, int, bool) call.
//; It loads nullptr if W8 is not 1


//; Enable camera twist
//; agl::lyr::Renderer::calc(bool) + 0x1A4 (Not a hook)
//; 0x673DB4 -> MOV W3, #1
//; Overrides W3 argument for agl::lyr::Layer::calc_(sead::Controller const*, int, bool)
//; call with true to enable camera twist with L and R


//; Toggle Free Camera and Freeze Camera
//; agl::lyr::Layer::calc_(sead::Controller const*, int, bool) + 0x11C
//; 0x672130 -> BL 0xAAFAE4

//; Unsure what the "FREECAM_UNK" bit is, but it must be set

//; Holding ZR and pressing D-Pad Up toggles Free Camera bit

//; Holding ZR and pressing D-Pad Down toggles Freeze Cam bit (Custom)

//; Store bits in free address in R-W to easily load them in other
//; hooks for checks. Also store agl::lyr::Layer* to have access to
//; camera coordinates in another hook

//; After the hook, the function checks if Free Camera bit is set and
//; skips camera control if it isn't.
//; At the end of the hook, override the loaded bits with zero if
//; Freeze Cam bit is set, to skip camera control


//; Register reference:
//; X19 = agl::lyr::Layer*
//; X20 = sead::Controller const*


.set BUTTONBIT_ZR, 5
.set BUTTONBIT_DPAD_UP, 16
.set BUTTONBIT_DPAD_DOWN, 17

.set FREECAM_BIT, 0
.set FREECAM_UNK_BIT, 1
.set FREEZECAM_BIT, 2

.set FREECAM, (1 << FREECAM_BIT)
.set FREECAM_UNK, (1 << FREECAM_UNK_BIT)
.set FREEZECAM, (1 << FREEZECAM_BIT)

LDRH W8, [X19, #0x7A]
ORR W8, W8, #FREECAM_UNK

LDR W0, [X20, #0x114]
TBZ W0, #BUTTONBIT_ZR, isFreeCamFrozen //; Not held

LDR W0, [X20, #8]
TBZ W0, #BUTTONBIT_DPAD_UP, isFreeCamEnabled //; Not triggered

EOR W8, W8, #FREECAM

isFreeCamEnabled:
TBZ W8, #FREECAM_BIT, storeCamFlags

isFreezeCamToggle:
LDR W0, [X20, #8]
TBZ W0, #BUTTONBIT_DPAD_DOWN, storeCamFlags

EOR W8, W8, #FREEZECAM

storeCamFlags:
STRH W8, [X19, #0x7A]

ADRP X9, #0x11A7000
STRH W8, [X9, #8]
STR X19, [X9, #0x10]

isFreeCamFrozen:
TST W8, #FREEZECAM
CSEL W8, WZR, W8, NE

end:
RET



//; Fix Free Camera sideways rotation and movement in Mirror Mode
//; agl::utl::DevTools::controlCamera(sead::LookAtCamera *,sead::Vector2<float> const&,sead::Vector2<float> const&,float,float,float,bool,agl::utl::DevTools::CameraControlType) + 0x84
//; 0x654AAC -> BL 00AAFB30

//; Fix Mirror Mode camera sideways rotation and movement
//; by inverting both Left and Right stick X values in Mirror Mode

//; Stick values are loaded from controller and stored in
//; stack for later use in the function.
//; Invert them in Mirror Mode


STP X29, X30, [SP, #-0x10]!

BL 0x87C244 //; gear::GetRaceInfo(void)
LDRB W8, [X0, #0x26]
CBZ W8, end //; Not Mirror Mode

LDR S0, [SP, #0x3C]
FNEG S0, S0
STR S0, [SP, #0x3C]

LDR S0, [SP, #0x58]
FNEG S0, S0
STR S0, [SP, #0x58]

end:
LDP X29, X30, [SP], #0x10
ADD X1, SP, #0x70 //; Original instruction
RET


//; Disable game inputs in Free Camera
//; gear::ControllerWrapper::calc(uint,bool) + 0x84
//; 0x7DC710 -> BL 0xAAFB64

//; Disables game inputs if Free Cam bit is set
//; and Freeze Cam bit is unset

//; Overrides the loaded W8 with zero to skip input
//; calculation


.set FREECAM_BIT, 0
.set FREEZECAM_BIT, 2

.set FREEZECAM, (1 << FREEZECAM_BIT)

LDRB W8, [X19, #0x160] //; Original instruction

ADRP X9, #0x11A7000
LDRH W9, [X9, #8]
TBZ W9, #FREECAM_BIT, end

TST W9, #FREEZECAM
CSEL W8, W8, WZR, NE

end:
RET


//; Hide HUD in Free Camera
//; ui::UIEngineEx::onDraw_(const agl::lyr::RenderInfo *) + 0x18
//; 0x3FDDB8 -> BL 00AAFB80

//; Overrides some loaded visibility bool with false
//; if Free Cam bit is set


.set FREECAM_BIT, 0

.set FREEZECAM, (1 << FREEZECAM_BIT)

LDRB W8, [X20, #0xA9] //; Original instruction

ADRP X9, #0x11A7000
LDRH W9, [X9, #8]
TST W9, #FREECAM
CSEL W8, WZR, W8, NE
RET


//; Disable Culling in Free Camera
//; object::FieldManualCulling::calc(void) + 0x24
//; 0x110FA4 -> BL 0xAAFB98

//; Calls a function that force culling to not cull
//; and overrides the loaded W8 value with zero
//; to skip calculating culling if Free Cam bit 
//; is set


.set FREECAM_BIT, 0

LDRB W8, [X19, #8] //; Original instruction

STP X29, X30, [SP, #-0x10]!

ADRP X9, #0x11A7000
LDRH W9, [X9, #8]
TBZ W9, #FREECAM_BIT, end

BL 0x110CF8 //; object::FieldManualCulling::forceDontCull_(void) 

MOV W8, WZR

end:
LDP X29, X30, [SP], #0x10
RET


//; Warp Camera to Kart
//; agl::utl::DevTools::controlCamera(sead::LookAtCamera *,sead::Vector2<float> const&,sead::Vector2<float> const&,float,float,float,bool,agl::utl::DevTools::CameraControlType) + 0xAE0
//; 0x655508 -> BL 0xAAFBBC

//; Holding ZR and pressing Left Stick In warps the camera to your kart

//; Skip the code if in Title Race or menus

//; Automatically warps camera to the kart when enabling Free Cam for the first time.
//; Done by checking if camera's XYZ coordinate shift offset are zero and warping cam to
//; kart if so. This shift offset is never stored to when controlling the camera, it moves
//; differently, so controlling the camera in menu then going to a race for the first time
//; is not a problem

//; To warp the camera, load the first kart (index 0, always you offline) object::KartVehicleMove*,
//; reset camera's XYZ coordinates to 0,0,0, load kart's XYZ rotation and store to camera's XYZ rotation,
//; multiply X and Z rotation by 50 (distance), load kart's XYZ coordinates, add the multiplied X and Z 
//; rotations to X and Z coordinates to move camera back to the kart, and subtract Y coordinate by 18 (height)
//; to move camera slightly down. That way, the camera is positioned exactly at the back of the kart, 
//; and store it to the camera's XYZ coordinate shift offset.
//
//; The shift offset is similar to coordinates, but coordinates don't work exactly the same, so when
//; trying to set the kart's coordinates to the camera, the camera would not be at the right location,
//; and the speed becomes super fast. Resetting the coords to 0,0,0 and setting the shift offset works
//; without any problems and changes the speed to slow.


//; Register reference:
//; X19 = agl::utl::DevTools*


.set RACERULE_TITLERACE, 4

.set BUTTONBIT_ZR, 5
.set BUTTONBIT_LEFT_STICK_IN, 7

STP X29, X30, [SP, #-0x10]!

BL 0x87C244 //; gear::GetRaceInfo
LDR W8, [X0, #8]
CMP W8, #RACERULE_TITLERACE
BGE end

MOV W0, WZR
BL 0x8B94A4 //; gear::GetControllerRace(int)
LDR X8, [X0, #0x158]
LDR W9, [X8, #0x114]
TBZ W9, #BUTTONBIT_ZR, hasEverMovedCam //; Not held

LDR W9, [X8, #8]
TBNZ W9, #BUTTONBIT_LEFT_STICK_IN, warpCam //; Not pressed

hasEverMovedCam:
LDR X8, [X19, #0x68]
LDR W9, [X19, #0x70]
ORR X8, X8, X9
CBNZ X8, end //; Has already moved

warpCam:
BL 0x7F41FC //; gear::FrameworkUtil::getCurrentGameScene(void)
LDR X8, [X0, #0x1B0]
CBZ X8, end
LDR X8, [X8, #0x238]
LDR X8, [X8,#0xC8]
LDR X9, [X8]
LDR X9, [X9, #8]
LDR X9, [X9, #0x28] //; object::KartVehicleMove*

STR XZR, [X19, #0x38]
STR WZR, [X19, #0x40]

ADD X8, X9, #0x20
LDP S0, S1, [X8]
LDR S2, [X8, #8]

ADD X10, X19, #0x44
STP S0, S1, [X10]
STR S2, [X10, #8]

LDR S3, distance
FMUL S4, S0, S3
FMUL S6, S2, S3

LDR S3, height
FMOV S5, S3

LDP S0, S1, [X9, #0x2C]
LDR S2, [X9, #0x34]

FSUB S0, S0, S4
FADD S1, S1, S5
FSUB S2, S2, S6

STP S0, S1, [X19, #0x68]
STR S2, [X19, #0x70]

end:
LDP X29, X30, [SP], #0x10
LDP D9, D8, [SP, #0xC0]
RET
distance: .float 50
height: .float 18


//; Warp Kart to Camera
//; object::KartVehicleMove::calcApply(void) + 0x18
//; 0x183FDC -> BL 00AAFECC

//; Holding ZR and pressing Right Stick In warps your kart to the camera
//
//; Skip the code if not local player kart or net send kart
//
//; When warping, load agl::lyr::Layer* object pointer stored in R-W and
//; load agl::utl::DevTools* from it to access the camera's coords and rotation.
//; SP + 0x10 (0x30 bytes) will hold the kart's gear::MtxT for resetMatrix call,
//; kart position and rotation will be stored there. Mentions of storing to
//; the kart's coords and rotation below means storing to the stack

//; Set some angles to zero and set some Y rotation to 1.0

//; Load camera's XYZ right vector, invert X rotation and store to kart's
//; Z rotation, store Z rotation to kart's X rotation and Y rotation to
//; kart's Y rotation. That converts it to forward vector so kart faces
//; the camera's direction

//; Load camera's XYZ coordinates and XYZ shift offset, then add coordinates
//; with shift offset. That makes the XYZ coords be exactly where the camera
//; is, regardless of zoom or anything else, and store it to kart's XYZ coords

//; Finally, reset the kart to reset speed and many other things, then reset
//; matrix with the one stored at the stack and pass the gear::MtxT from stack
//; and -10.0 as the Y height shift to warp the kart to camera's location but 
//; slightly under it
//
//; Finish Lakitu respawn, reset AI if a CPU to correct CPU route, reset character, 
//; and store a bool to object::KartVehicleMove* + 0x3EE, which is a padding byte.
//; This bool will be used as a way to determine if the kart is landing from 
//; warp to camera. It'll be checked in this hook to constantly correct
//; checkpoints if it's true (even if not warping to cam this frame), 
//; and in another hook to ignore checkpoint
//; boundaries when true. It is set to false when the kart touches the
//; ground (no air frames).


//; Register reference:
//; X19 = object::KartVehicleMove*


.set BUTTONBIT_ZR, 5
.set BUTTONBIT_RIGHT_STICK_IN, 6

.set FREECAM_BIT, 0

//; Register reference:
//; X19 = object::KartVehicleMove*


.set BUTTONBIT_ZR, 5
.set BUTTONBIT_RIGHT_STICK_IN, 6

.set FREECAM_BIT, 0

STP X29, X30, [SP, #-0x40]!

LDR X20, [X19, #0xF8] //; object::KartVehicle*
LDRB W9, [X20, #0xD0]
CBZ W9, end //; Not local player kart

LDRB W8, [X20, #0xE6]
CBNZ W8, end //; Net send kart

MOV W0, WZR
BL 0x8B94A4 //; gear::GetControllerRace(int)
LDR X8, [X0, #0x158]
LDR W9, [X8, #0x114]
TBZ W9, #BUTTONBIT_ZR, isLandFromDrop //; Not held

LDR W9, [X8, #8]
TBZ W9, #BUTTONBIT_RIGHT_STICK_IN, isLandFromDrop //; Not pressed

ADRP X8, #0x11A7000
LDRH W9, [X8, #8]
TBZ W9, #FREECAM_BIT, end

ADRP X8, #0x11A7000
LDR X8, [X8, #0x10] 
LDR X8, [X8, #0x1E8]
ADD X8, X8, #0x68 //; agl::utl::DevTools*

STR XZR, [SP, #0x10]
STR XZR, [SP, #0x18]

MOV X9, #0x000000003F800000
STR X9, [SP, #0x20]

LDP S0, S1, [X8, #8]
LDR S2, [X8, #0x10]

FNEG S0, S0

STP S2, S1, [SP, #0x28]
STR S0, [SP, #0x30]

LDP S0, S1, [X8, #0x38]
LDR S2, [X8, #0x40]

LDP S3, S4, [X8, #0x68]
LDR S5, [X8, #0x70]

FADD S0, S0, S3
FADD S1, S1, S4
FADD S2, S2, S5

STP S0, S1, [SP, #0x34]
STR S2, [SP, #0x3C]

MOV X0, X20
MOV W1, #1
BL 0x171004 //; object::KartVehicle::reset(bool)

LDR X0, [X20, #8]
ADD X1, SP, #0x10
FMOV S0, #-10.0
BL 0x16C2F8 //; object::KartUnit::resetMatrix(gear::MtxT const&,float)

LDR X0, [X20, #0x90]
ADD X1, X19, #8
BL 0x144534 //; object::KartJugemRecover::finishRecover(gear::MtxT const&)

LDRB W8, [X20, #0xD2]
CBZ W8, resetWarpPre //; Not a CPU

BL 0x7F41FC //; gear::FrameworkUtil::getCurrentGameScene(void)
LDR X8, [X0, #0x1B0]
LDR X8, [X8,#0x238]
LDR X0, [X8, #0xB0]
LDR X8, [X19, #0xF8]
LDR W1, [X19, #0xA8]
ADD X2, X19, #8
BL 0x59D50 //; object::AIDirector::reset(int,gear::MtxT const&)

resetWarpPre:
LDR X8, [X20, #8]
LDR X0, [X8, #0x10]
MOV X9, X0
BL 0xE1368 //; object::DriverKart::resetWarpPre(void)

MOV X0, X9
BL 0xE1378 //; object::DriverKart::resetWarpPost(void)

MOV W0, #1
STRB W0, [X19, #0x3EE]
B adaptCurrentSector

isLandFromDrop:
LDRB W0, [X19, #0x3EE]
CBZ W0, end

LDR W0, [X19, #0x26C]
CBNZ W0, adaptCurrentSector

STRB WZR, [X19, #0x3EE]

adaptCurrentSector:
BL 0x7F41FC //; gear::FrameworkUtil::getCurrentGameScene(void)
LDR X8, [X0, #0x1B0]
LDR X8, [X8, #0x218]
LDR X0, [X8, #0x58]
LDR W1, [X20, #0xA8]
MOV W2, #1
BL 0x8802B8 //; gear::LapRankChecker::adaptCurrentSector(int,bool)

end:
LDP X29, X30, [SP], #0x40
LDR X0, [X19, #0x110]
RET


//; Disable Checkpoint Boundaries When Landing from Kart to Cam Warp
//; object::KartJugemRecover::stateCheckRoad(void) + 0xC
//; 0x141E10 -> BL 0xAAFD9C

/; If object::KartVehicleMove* padding byte + 0x3EE is true, skip
//; starting Lakitu respawn

//; Skip by modifying hook's return address: LR + 0x94 = 0x141EA8
//; Returns to the function's end


MOV X19, X0 //; Original instruction

LDR X8, [X19, #0x50]
LDR X8, [X8, #0x28]
LDRB W8, [X8, #0x3EE]
CBZ W8, end

ADD X30, X30, #0x94

end:
RET


//; Freeze Game Toggle with Frame Advance
//; gear::FrameworkGameScene::calc(void) + 0x150
//; 0x7F212C -> BL 0xAAFDB8

//; Set a pause bool value to 2 (instead of 1),
//; and if it's 2, set pause state to 2 (Full pause)

//; Setting the pause state is enough, but since I 
//; want the ability to frame advance, pause state
//; must be unpaused (0) for a frame, then paused
//; again on the next frame, so reading off of the
//; pause bool and setting pause state allows it
//; to be unpaused for a frame and set the next frame


//; Register reference:
//; X19 = gear::FrameworkGameScene*


.set BUTTONBIT_ZR, 5
.set BUTTONBIT_DPAD_RIGHT, 19

.set PAUSE_FULL, 2

STR W8, [X19, #0x23C] //; Original instruction

STP X29, X30, [SP, #-0x10]!

BL 0x87C244 //; gear::GetRaceInfo(void)
LDR W8, [X0]
CBNZ W8, end //; Online mode

MOV W0, WZR
BL 0x8B94A4 //; gear::GetControllerRace(int)
LDR X0, [X0, #0x158]

LDR W8, [X0, #8]
TBZ W8, #BUTTONBIT_DPAD_RIGHT, isPaused //; D-Pad Right not triggered

LDR W9, [X0, #0x114]
TBNZ W9, #BUTTONBIT_ZR, togglePause //; ZR button held

setUnpaused:
STR WZR, [X19, #0x238]
B end

togglePause:
LDRB W8, [X19, #0x230]
EOR W8, W8, #PAUSE_FULL
STRB W8, [X19, #0x230]
CBZ W8, setUnpaused

isPaused:
LDRB W8, [X19, #0x230]
CMP W8, #PAUSE_FULL
BNE end

STR W8, [X19, #0x238]

end:
LDP X29, X30, [SP], #0x10
RET


//; Force default kart camera FOV in Free Camera
//; object::KartCamera::calcNormalCamera_(gear::LookAtParam *) + 0x16C
//; 0x118484 -> BL 0xAAFE18

//; Kart camera FOV affects Free Camera,
//; force it to always be the default (1.0)
//; if Free Cam bit is set


.set FREECAM_BIT, 0

ADRP X8, #0x11A7000
LDR X8, [X8, #8]
TBZ W8, #FREECAM_BIT, end

FMOV S0, #1.0

end:
STR S0, [X19, #0x30] //; Original instruction
RET


//; Force specific camera mode for replay camera in Free Camera
//; DemoCameraController::calcReplay(void) + 0x30
//; 0xCC6BC -> BL 0xAAFE30

//; Replay camera FOV and blur affects Free Camera,
//; force a specific camera type that doesn't 
//; change FOV and blur if Free Cam bit is set


.set FREECAM_BIT, 0

.set CAMMODE_SIDE_KART, 4

LDUR W9, [X29, #-0x3C] //; Original instruction

ADRP X8, #0x11A7000
LDR X8, [X8, #8]
TBZ W8, #FREECAM_BIT, end

MOV W9, #CAMMODE_SIDE_KART

end:
RET


//; Stick doesn't affect replay in Free Camera
//; object::RecorderDirector::updatePlayRate_(void) + 0x84
//; 0x3A8C88 -> BL 0xAAFE48

//; MKTV stick is functional even if game inputs
//; are disabled.

//; Overrides the loaded stick values and some replay rate with default
//; neutral and default values if Free Cam bit is set and Freeze Camera
//; bit is unset


.set FREECAM_BIT, 0
.set FREEZECAM_BIT, 2

ADRP X9, #0x11A7000
LDR W9, [X9, #8]
TBZ W9, #FREECAM_BIT, end
TBNZ W9, #FREEZECAM_BIT, end

FMOV S0, #0.0
FMOV S8, #1.0

end:
FMUL S1, S0, S1 //; Original instruction
RET