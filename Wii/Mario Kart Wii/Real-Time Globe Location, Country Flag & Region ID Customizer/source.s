# Game: Mario Kart Wii
# Code: Real-Time Globe Location, Country Flag & Region ID Customizer
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names


# This line is made by Vega. It forces the flag to appear even if flag setting is set to "Not Display"
# Original description by Vega: Jump from 2nd instruction of SetCountry Func to first instruction of Func
# that only executes for Countries that have their Location within enabled. This forces flag image (if applicable) 
# no matter what. Needed for rare troublesome SYSCONFs
# NTSC-U 8000AEDC
# PAL 8000AF7C
# NTSC-J 8000AEA0
# NTSC-K 8000B028
# b 0x5C

# This line is made by Vega. It makes the game use the globe latitude from the static globe location address 
# rather than the default one from that region ID
# Original description by Vega: Jump from 2nd instruction of SetLatitude Func to first instruction of Func that 
# will always load Latitude from Anarion's packet. Needed for rare troublesome SYSCONFs
# NTSC-U 8000AF4C
# PAL 8000AFEC
# NTSC-J 8000AF10
# NTSC-K 8000B098
# b 0x9C

# This line is made by Vega. It makes the game use the globe latitude from the static globe location address rather 
# than the default one from that region ID
# Original description by Vega: Jump from 2nd instruction of SetLongitude Func to first instruction of Func that will
# always load Longitude from Anarion's packet. Needed for rare troublesome SYSCONFs
# NTSC-U 8000B000
# PAL 8000B0A0
# NTSC-J 8000AFC4
# NTSC-K 8000B14C
# b 0x9C


# Main control code
# NTSC-U 8062AE6C
# PAL 805DA8F8
# NTSC-J 805DA1D4
# NTSC-K 805C8A94

# 0x93700544 and 0x93700548 = Original pane color of country text layout (user_id, used for country name and Friend Code). The color of this pane is modified to the region ID line color, so the original pane color has to be stored to EVA to be restored outside of FRoom
# 0x9370054C = Globe zoom type
# 0x9370054D = Flag change button timer (Held frames)
# 0x9370054E = Action 

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.
   
.if (region == 'e' || region == 'E')
    .set addr_globeLatidude, 0x8042785C
    .set addr_globeLongitude, 0x8042785E
    .set addr_countryFlag, 0x80426858
    .set addr_regionID, 0x804267E7
    .set ptr_NetUSER, 0x809BD958
    .set ptr_RKNetController, 0x809BD918
    .set ptr_inputBase, 0x809B8F4C
	.set ptr_menuPageOrSomething, 0x809BDC10
.elseif (region == 'p' || region == 'P')
    .set addr_globeLatidude, 0x8042BBDC
    .set addr_globeLongitude, 0x8042BBDE
    .set addr_countryFlag, 0x8042ABD8
    .set addr_regionID, 0x8042AB67
    .set ptr_NetUSER, 0x809C2108
    .set ptr_RKNetController, 0x809C20D8
    .set ptr_inputBase , 0x809BD70C
	.set ptr_menuPageOrSomething, 0x809C2850
.elseif (region == 'j' || region == 'J' )
    .set addr_globeLatidude, 0x8042B55C
    .set addr_globeLongitude, 0x8042B55E
    .set addr_countryFlag, 0x8042A558
    .set addr_regionID, 0x8042A4E7
    .set ptr_NetUSER, 0x809C1168
    .set ptr_RKNetController, 0x809C1138
    .set ptr_inputBase , 0x809BC76C
    .set ptr_menuPageOrSomething, 0x809C18B0
.elseif (region == 'k' || region == 'K' )
    .set addr_globeLatidude, 0x80419BFC
    .set addr_globeLongitude, 0x80419BFE
    .set addr_countryFlag, 0x80418BF8
    .set addr_regionID, 0x80418B87
    .set ptr_NetUSER, 0x809B0748
    .set ptr_RKNetController, 0x809B0718
    .set ptr_inputBase , 0x809ABD4C
	.set ptr_menuPageOrSomething, 0x809B0E90
.else
    .err
.endif

.set ACTION_NONE, 0
.set ACTION_MOVE, 1
.set ACTION_FLAG_CHANGE, 2
.set ACTION_OVERRIDE_PLAYER_MESSAGE, 4
.set ACTION_REGION_ID_CHANGE, 8
.set ACTION_ZOOM_TYPE_CHANGE, 0x10

.set ZOOM_FAR, 0
.set ZOOM_CLOSE, 1
.set ZOOM_MEDIUM, 2

.set BUTTON_START_GCN, 4
.set BUTTON_Y_Z_GCN, 0x100
.set BUTTON_MINUS_C, 0x100
.set BUTTON_HOME, 0x80
.set BUTTON_DPAD_UP, 8
.set BUTTON_DPAD_DOWN, 0x10
.set BUTTON_DPAD_LEFT, 0x20
.set BUTTON_DPAD_RIGHT, 0x40

.set CONTROLLER_GAMECUBE, 3

.set REGION_JAPAN, 0
.set REGION_KOREA, 5

.set GLOBE_LATIDUDE_MIN_FULL, 0xFFFFC001
.set GLOBE_LATIDUDE_MIN_UPHALF, 0xC001
.set GLOBE_LATIDUDE_MAX_UPHALF, 0x3FFF

.set SOUND_MENU_NAVIGATE, 7

lwz r3, 0x358 (r30)
lbz r3, 0x140 (r3)
cmpwi r3, 0
bne end

mflr r0
stw r0, 0x1C (sp)

lis r21, 0x9370

li r7, ACTION_NONE
stb r7, 0x54E  (r21)

lis r11, addr_globeLatidude@ha
lbz r3, 0x54C (r21)
lha r4, addr_globeLatidude@l (r11)
lha r5, addr_globeLongitude@l (r11)
lwz r6, ptr_NetUSER@l (r27)
lwz r10, ptr_inputBase@l (r27)


bl speeds

.float 400 # Far zoom speed
.float 50 # Close zoom speed
.float 200 # Medium zoom speed

speeds:

mflr r22
mulli r12, r3, 4
lfsx f1, r22, r12

lhz r12, 0x3C (r10)
cmpwi r12, 0x0707
beq loadControllerInputs

lfs f0, 0x38 (r10)
fmuls f0, f0, f1
fctiwz f0, f0
stfd f0, 0x10 (sp)
lwz r12, 0x14 (sp)

add r4, r4, r12

cmpwi r4, GLOBE_LATIDUDE_MIN_FULL
bgt isMaxUp

ori r4, r7, GLOBE_LATIDUDE_MIN_UPHALF
b calcLongitudeMove

isMaxUp:
cmpwi r4, GLOBE_LATIDUDE_MAX_UPHALF
blt calcLongitudeMove

li r4, GLOBE_LATIDUDE_MAX_UPHALF

calcLongitudeMove:
lfs f0, 0x34 (r10)
fmuls f0, f0, f1
fctiwz f0, f0
stfd f0, 0x10 (sp)
lwz r12, 0x14 (sp)

add r5, r5, r12

sth r4, addr_globeLatidude@l (r11)
sth r5, addr_globeLongitude@l (r11)
sth r4, 0xBC (r6)
sth r5, 0xBE (r6)

ori r7, r7, ACTION_MOVE

loadControllerInputs:
lwz r12, 0x60 (r10)
lwz r22, 0x94 (r10)

andc r22, r12, r22

andis. r5, r22, (BUTTON_DPAD_LEFT | BUTTON_DPAD_RIGHT)
beq zoomButtonWiimote

lbz r5, addr_regionID@l (r11)

andis. r4, r22, BUTTON_DPAD_RIGHT
beq prevRegion

addi r5, r5, 1
b isValidRegID

prevRegion:
subi r5, r5, 1

isValidRegID:
cmpwi r5, REGION_JAPAN
bge isAboveMax

li r5, REGION_KOREA

isAboveMax:
cmpwi r5, REGION_KOREA
ble storeRegID

li r5, REGION_JAPAN

storeRegID:
stb r5, addr_regionID@l (r11)
stb r5, 0xC5 (r6)

ori r7, r7, ACTION_REGION_ID_CHANGE


zoomButtonWiimote:
lis r4, (BUTTON_MINUS_C | BUTTON_HOME)

lwz r5, 0xCC (r10)
cmpwi r5, CONTROLLER_GAMECUBE
bne isZoomButtonPressed

lis r4, (BUTTON_START_GCN | BUTTON_Y_Z_GCN)

isZoomButtonPressed:
and. r5, r22, r4
beq calcFlagChange

subi r3, r3, 1

cmpwi r3, ZOOM_FAR
bge storeZoom

li r3, ZOOM_MEDIUM

storeZoom:
stb r3, 0x54C (r21)

ori r7, r7, ACTION_FLAG_CHANGE

calcFlagChange:
li r4, 0

andis. r3, r12, (BUTTON_DPAD_UP | BUTTON_DPAD_DOWN)
beq storeFlagChangeBtnTimer

lbz r3, addr_countryFlag@l (r11)
lbz r4, 0x54D (r21)
addi r4, r4, 1

cmpwi r4, 1
beq isPrevFlag

cmpwi r4, 0x12
beq isPrevFlag

cmpwi r4, 0x17
blt storeFlagChangeBtnTimer

li r4, 0x12

isPrevFlag:
andis. r22, r12, BUTTON_DPAD_UP
beq decFlag

addi r3, r3, 1
b storeFlag

decFlag:
subi r3, r3, 1

storeFlag:
stb r3, addr_countryFlag@l (r11)
stb r3, 0xB8 (r6)

ori r7, r7, ACTION_FLAG_CHANGE

storeFlagChangeBtnTimer:
stb r4, 0x54D (r21)

cmpwi r7, ACTION_NONE
beq end

andi. r0, r7, (ACTION_FLAG_CHANGE | ACTION_REGION_ID_CHANGE)
beq isMyPromptedMessage

stwu sp, -0x80 (sp)
stmw r3, 8 (sp)
lis r3, ptr_menuPageOrSomething@ha
lwz r3, ptr_menuPageOrSomething@l (r3)
li r4, SOUND_MENU_NAVIGATE
lwz r12, 0 (r3)
lwz r12, 0x20 (r12)
mtctr r12
bctrl
lmw r3, 8 (sp)
addi sp, sp, 0x80 

isMyPromptedMessage:
lbz r31, 0x2B0C (r29)
lwz r30, ptr_RKNetController@l (r27)
lbz r30, 0x59 (r30)
cmpw r31, r30
beq storeActionState

stb r30, 0x2B0C (r29)
mr r31, r30

ori r7, r7, ACTION_OVERRIDE_PLAYER_MESSAGE

# Store action state flags
storeActionState:
stb r7, 0x54E  (r21)

li r21, 0
lwz r12, 0x1C (sp)
addi r12, r12, 0x2A0 
mtlr r12
blr

end:
cmpwi r17, 0 # Original instruction


# Avoid resetting message timer if actions are being performed (so actions don't interfer with message sending afterward) and set zoom type to Close
# NTSC-U 8062B150
# PAL 805DABDC
# NTSC-J 805DA4B8
# NTSC-K 805C8D78

.set ACTION_NONE, 0

lis r3, 0x9370
lbz r4, 0x54E  (r3)
cmpwi cr1, r4, ACTION_NONE
bne cr1, skip

stw r0, 0x2AEC (r29) # Original instruction

li r0, 1
stb r0, 0x54C (r3)

skip:


# Avoid myself from sending messages if actions are being performed (since message player ID is forced to be me, 
# if others send messages while I'm performing actions, my mii will send a message after I stop the action)
# NTSC-U 8062B4AC
# PAL 805DAF38
# NTSC-J 805DA814
# NTSC-K 805C90D4

.set ACTION_NONE, 0


lis r25, 0x9370
lbz r25, 0x54E  (r25)
cmpwi r25, ACTION_NONE
bnelr

stwu sp, -0x30(sp) # Original instruction


# Change country name text pane color (which is also Friend Code) to region ID color in Friend Rooms and reset it to original outside of Friend Rooms
# NTSC-U 805CE918
# PAL 805E46F4
# NTSC-J 805E3FD0
# NTSC-K 805D2890

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'E' || region == 'e') # RMCE
    .set getPaneByName, 0x805D1C7C
    .set addr_user_id_paneString, 0x8088FADC
    .set addr_lineColors, 0x808A44D4
    .set addr_regionID, 0x804267E7
    .set ptr_RKNetController, 0x809BD918
.elseif (region == 'P' || region == 'p') # RMCP
    .set getPaneByName, 0x805E8368
    .set addr_user_id_paneString, 0x808953D4
    .set addr_lineColors, 0x808A9DFC
    .set addr_regionID, 0x8042AB67
    .set ptr_RKNetController, 0x809C20D8
.elseif (region == 'J' || region == 'j') # RMCJ
    .set getPaneByName, 0x805E7C44
    .set addr_user_id_paneString, 0x80894A24
    .set addr_lineColors, 0x808A8F5C  
    .set addr_regionID, 0x8042A4E7
    .set ptr_RKNetController, 0x809C1138
.elseif (region == 'K' || region == 'k') # RMCK
    .set getPaneByName, 0x805D6504
    .set addr_user_id_paneString, 0x808837E4
    .set addr_lineColors, 0x8089825C
    .set addr_regionID, 0x80418B87
    .set ptr_RKNetController, 0x809B0718
.else
    .err
.endif

.set REGION_TAIWAN, 4

.set ACTION_NONE, 0

.set WIFIMENU_OWN_FRIEND_ROOM, 5
.set WIFIMENU_OTHER_FRIEND_ROOM, 6


mr r29, r3

addi r3, r31, 0x270
lis r4, addr_user_id_paneString@h
ori r4, r4, addr_user_id_paneString@l
lis r12, getPaneByName@h
ori r12, r12, getPaneByName@l
mtctr r12
bctrl

lwz r3, 0x28 (r3)

lis r28, 0x9370

lwz r5, 0x544 (r28)
cmpwi r5, 0
bne isFRoom

lwz r5, 0x18 (r3)
stw r5, 0x544 (r28)
lwz r5, 0x1C (r3)
stw r5, 0x548 (r28)

isFRoom:
lis r5, ptr_RKNetController@ha
lwz r12, ptr_RKNetController@l (r5)
lwz r12, 0xE8 (r12)
cmpwi r12, WIFIMENU_OWN_FRIEND_ROOM
beq setPaneColor

cmpwi r12, WIFIMENU_OTHER_FRIEND_ROOM
beq setPaneColor

lwz r5, 0x544 (r28)
stw r5, 0x18 (r3)
lwz r5, 0x548 (r28)
stw r5, 0x1C (r3)

li r5, ACTION_NONE
stw r5, 0x54E  (r28)
b end

setPaneColor:
lis r5, addr_regionID@h
lbz r5, addr_regionID@l (r5)
lis r4, addr_lineColors@h
ori r4, r4, addr_lineColors@l

cmpwi cr1, r5, REGION_TAIWAN
bne cr1, isPink

addi r4, r4, 8

isPink:
ble cr1, storePaneColor

subi r4, r4, 4


storePaneColor:
mulli r5, r5, 4
add r4, r4, r5
lbz r5, 0 (r4)
stb r5, 0x19 (r3)
lbz r5, 1 (r4)
stb r5, 0x1B (r3)
lbz r5, 2 (r4)
stb r5, 0x1D (r3)

end:
lwz r0, 0x33C (r29) # Original instruction
mr r3, r29


# Avoid hiding mii, mii name and flag if specific actions are being performed
# NTSC-U 805CFEE8
# PAL 805E5CC4
# NTSC-J 805E55A0
# NTSC-K 805D3E60

.set ACTION_NONE, 0
.set ACTION_MOVE, 1
.set ACTION_FLAG_CHANGE, 2
.set ACTION_OVERRIDE_PLAYER_MESSAGE, 4
.set ACTION_REGION_ID_CHANGE, 8
.set ACTION_ZOOM_TYPE_CHANGE, 0x10

mflr r11
mr r22, r3

lis r27, 0x9370
lbz r12, 0x54E  (r27)

andi. r0, r12, ACTION_FLAG_CHANGE
bne jump

cmpwi r12, ACTION_NONE
beq end

addi r11, r11, 0x18

jump:
lis r27, 0x809C # Change to 0x809B if Korea - TODO - ADD IT TO .IF FOR KOREA

addi r11, r11, 0x88
mtlr r11
blr

end:
lwz r0, 0x38 (r3) # Original instruction


# Set globe zoom type and prevent earth from spinning if any action is being performed
# NTSC-U 805CFFC0
# PAL 805E5D9C
# NTSC-J 805E5678
# NTSC-K 805D3F38

.set ACTION_NONE, 0

stw r0, 0x14 (sp) # Original instruction

lis r5, 0x9370
lbz r0, 0x54E  (r5)
cmpwi r0, ACTION_NONE
beq end

stb r4, 0x3C (r3)

lbz r4, 0x54C (r5)
addi r4, r4, 1

end:


# Change mii state, force mii visible, hide prompted message and avoid mii reset in specific action states
# NTSC-U 805CFFDC
# PAL 805E5DB8
# NTSC-J 805E5694
# NTSC-K 805D3F54

.set ACTION_NONE, 0
.set ACTION_MOVE, 1
.set ACTION_FLAG_CHANGE, 2
.set ACTION_OVERRIDE_PLAYER_MESSAGE, 4
.set ACTION_REGION_ID_CHANGE, 8
.set ACTION_ZOOM_TYPE_CHANGE, 0x10

.set MIISTATE_WORLDWIDE_OPPONENT_REVEAL, 2
.set MIISTATE_MESSAGE_SEND, 0xA


li r30, MIISTATE_MESSAGE_SEND

lis r5, 0x9370
lbz r12, 0x54E  (r5)
cmpwi r12, ACTION_NONE
beq end

li r30, MIISTATE_WORLDWIDE_OPPONENT_REVEAL

andi. r0, r12, (ACTION_FLAG_CHANGE | ACTION_OVERRIDE_PLAYER_MESSAGE | ACTION_REGION_ID_CHANGE | ACTION_ZOOM_TYPE_CHANGE)
bne forceMiiVisible

lwz r0, 0x33C (r28)
cmpwi r0, MIISTATE_MESSAGE_SEND
blt jump

forceMiiVisible:
li r4, 1
lwz r11, 0x14 (r3)
stb r4, 0xF9 (r11)

li r4, 3
stw r4, 0x38 (r22)

isOverridePlayer:
andi. r12, r12, ACTION_OVERRIDE_PLAYER_MESSAGE
bne end

jump:
mflr r11
addi r11, r11, 0x10
mtlr r11
blr

end: 
addi r4, r28, 0x340 # Original instruction


# Replace mii state store register (Not a hook)
# NTSC-U 805CFFE8
# PAL 805E5DC4
# NTSC-J 805E56A0
# NTSC-K 805D3F60
# Replace stw r0, 0x33C(r28) with stw r30, 0x33C(r28). It cannot be r0 because of how the previous hook is designed and how a function skip happens



# Instantly update mii name, flag and country name if actions are being performed
# NTSC-U 805CEB58
# PAL 805E4934
# NTSC-J 805E4210
# NTSC-K 805D2AD0

.set ACTION_NONE, 0


lwz r0, 0x38 (r3) # Original instruction

lis r3, 0x9370
lbz r3, 0x54E  (r3)
cmpwi r3, ACTION_NONE
beq end

li r0, 0

end:


# Set globe zoom timer if actions are being performed (Instant zoom type change zoom and avoid slippery mii movement)
# NTSC-U 80749C88
# PAL 8074F1C8
# NTSC-J 8074E834
# NTSC-K 8073D588

.set ACTION_NONE, 0


lis r31, 0x9370
lbz r31, 0x54E  (r31)
cmpwi r31, ACTION_NONE
beq end

li r31, 0x56
stw r31, 0xD4 (r29)
stw r31, 0x8C (r29)

end:
lwz r31, 0x8C (sp) # Original instruction