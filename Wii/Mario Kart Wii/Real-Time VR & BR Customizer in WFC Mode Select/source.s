# Game: Mario Kart Wii
# Code: Real-Time VR/BR Customizer in WFC Mode Select 
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names

# NTSC-U 8060C6F4
# PAL 8063DB14
# NTSC-J 8063D180
# NTSC-K 8062BE2C

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling (E for NTSC-U, P for PAL, J for NTSC-J, K for NTSC-K). Lowercase letters can also be used.

.if (region == 'E' || region == 'e') # RMCE
    .set ptr_menuPageOrSomething, 0x809BDC10
    .set ptr_inputBase, 0x809B8F4C
    .set ptr_licenseSave, 0x809B8F88
    .set setMessage, 0x8060C89C
    .set addr_goString, 0x8089225D
.elseif (region == 'P' || region == 'p') # RMCP
    .set ptr_menuPageOrSomething, 0x809C2850
    .set ptr_inputBase , 0x809BD70C
    .set ptr_licenseSave, 0x809BD748
    .set setMessage , 0x8063DCBC
    .set addr_goString, 0x80899AED
.elseif (region == 'J' || region == 'j') # RMCJ
    .set ptr_inputBase , 0x809BC76C
    .set ptr_menuPageOrSomething, 0x809C18B0
    .set ptr_licenseSave, 0x809BC7A8
    .set setMessage , 0x8063D328
    .set addr_goString, 0x80898C4D
.elseif (region == 'K' || region == 'k') # RMCK
    .set ptr_inputBase , 0x809ABD4C
    .set ptr_menuPageOrSomething, 0x809B0E90
    .set ptr_licenseSave, 0x809ABD88
    .set setMessage , 0x8062BFD4
    .set addr_goString, 0x80887F25
.else
.err
.endif

.set BUTTON_DPAD_LEFT, 0x20
.set BUTTON_DPAD_RIGHT, 0x40
.set BUTTON_MULTI_MINUS_C_X_Z_ZR, 0x100

.set PAGE_WFC_SELECT, 0x8C

.set BMG_VR, 0x106A
.set BMG_BR, 0x106B

.set SOUND_SHEET_LEFT, 0x14
.set SOUND_SHEET_RIGHT, 0x15

.set MIN_VR, 1
.set MAX_VR, 9999


stwu sp, -0x80 (sp)
stmw r3, 8 (sp)

lis r27, ptr_menuPageOrSomething@ha
lwz r12, ptr_menuPageOrSomething@l (r27)
lwz r12, 4 (r12)
cmpwi r12, PAGE_WFC_SELECT
bne restore

lhz r12, 0xD9 (r3)
cmpwi r12, 0x3234 # Check specific part of string (24 from w1"24") - No other panes have this
bne restore

lwz r6, ptr_licenseSave@l (r27)
lha r0, 0x36 (r6)
lis r5, 1
clrlwi r4, r0, 24
addi r0, r5, -0x6C10
mullw r0, r0, r4
add r4, r6, r0
addi r4, r4, 0x38
addis r6, r4, 1

lwz r4, 0x98 (r3)
lbz r4, 0x35 (r4)
cmpwi r4, 0
beq restore

li r5, BMG_VR

cmpwi r30, 1
beq isRateChange

li r5, BMG_BR
addi r6, r6, 8

isRateChange:
lhz r7, -0x6FE8 (r6)
li r28, 0
lwz r12, ptr_inputBase@l (r27)
lwz r10, 0x60 (r12)
andis. r11, r10, BUTTON_DPAD_LEFT | BUTTON_DPAD_RIGHT
beq storeRateChangeBtnTimer

lbz r28, 4 (r31)
addi r28, r28, 1
cmpwi r28, 1
beq incDecDefault

cmpwi r28, 0x12
blt storeRateChangeBtnTimer

incDecDefault:
li r4, 1

andi. r11, r10, BUTTON_MULTI_MINUS_C_X_Z_ZR
beq isRateDec

li r4, 0x64

isRateDec:
andi. r11, r10, BUTTON_DPAD_RIGHT
beq decRate

add r7, r7, r4
li r29, SOUND_SHEET_RIGHT
b isMinRate

decRate:
sub r7, r7, r4
li r29, SOUND_SHEET_LEFT

isMinRate:
cmpwi r7, MIN_VR
blt restore

cmpwi r7, MAX_VR
bgt restore

sth r7, -0x6FE8 (r6)
stw r7, 0x10 (sp)
addi r6, sp, 0x10

lis r4, addr_goString@h
ori r4, r4, addr_goString@l
lis r12, setMessage@h
ori r12, r12, setMessage@l
mtctr r12
bctrl

lwz r3, ptr_menuPageOrSomething@l (r27)
mr r4, r29
lwz r12, 0 (r3)
lwz r12, 0x20 (r12)
mtctr r12
bctrl

storeRateChangeBtnTimer:
stb r28, 4 (r31)

restore:
lmw r3, 8 (sp)
addi sp, sp, 0x80

lwz r12, 0 (r3) # Original instruction 