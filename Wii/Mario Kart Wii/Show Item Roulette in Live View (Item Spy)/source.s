# Game: Mario Kart Wii
# Code: Show Item Roulette in Live View (Item Spy)
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names


# Remove "LIVE" text by replacing BMG message ID. 
# Removing the "LIVE message" HUD element from Live View Layout also removes the # "You'll join the next race. Please wait a moment..." text, 
# so replace "LIVE" BMG ID with empty BMG ID to only remove that part
# Not a hook!
# NTSC-U 80842620
# PAL 807EFA44
# NTSC-J 807EF0B0
# NTSC-K 807DDE04
# Replace li r4, 0x539 with li r4, 0


# Add Item Window HUD element to VS Live View Layout - Hooking instead of modifying the load directly to 
# make it compatible with Show Position in Live View code on the go
# NTSC-U 80602700
# PAL 806335B4
# NTSC-J 80632D00
# NTSC-K 806219AC

ori r3, r3, 0x40 # OR Item Window HUD bitflag to Live View HUD bitflags
blr


# Add Item Window HUD element to Battle Live View Layout - Hooking instead of modifying the load directly to 
# make it compatible with Show Battle Score in Live View code on the go
# NTSC-U 80602670
# PAL 80633524
# NTSC-J 80632C70
# NTSC-K 8062191C

ori r3, r3, 0x40 # OR Item Window HUD bitflag to Live View HUD bitflags
blr



# Prevent/Fix Squished and Frozen Rotating Item Window HUD 
# NTSC-U 807E4E44
# PAL 807EF154
# NTSC-J 807EE7C0
# NTSC-K 807DD514

# There are bugs with the item window HUD
# One causes the roulette to be "squised" when it ends prematurely/too early because when the roulette starts spinning, it's squished and slowly expands. This can be seen by using item roulette related hacks like Instant Item Receive.
# The other one causes the roulette to be completely "frozen" when spinning, as if the game froze

# The first issue is caused when the player you're watching has an item rotating and you switch the camera to a player who has a decided item
# The second issue is caused by the same reason as the first, but a bit differently. This issue is new to me, I've never ever seen this one before and don't understand exactly why this happens

# The part of the function this code is hooked at only runs if the player has an item in the slot. 
# No Live View check as these issues will never happen outside of Live View, unless if using item roulette hacks. This code can be used as a fix for these issues since it has no side effects.


lwz r0, 0x19C (r28) # Original instruction

lwz r4, 0xA0 (r28)
lhz r3, 0x208 (r4)
cmpwi r3, 0x4160
blt isSecondItemWindowVisible

li r3, 0
stw r3, 0x200 (r4)
stw r3, 0x208 (r4)

isSecondItemWindowVisible:
lwz r4, 0x1B0 (r28)
lbz r4, 0xBB (r4)
cmpwi r4, 0
beq end

li r0, 0

end:




# Main code - Calculate network player item slot
# NTSC-U 8065EC1C
# PAL 8065DF94
# NTSC-J 8065D600
# NTSC-K 8064C2AC

# TODO - EXPLANATIVE MENTION ABOUT REPLACEMENT ITEM (NUM AND REQUEST FAIL)

.set region, '' #Fill in E, P, J, or K within the quotes for your region when compiling! Lowercase letters can also be used.

.if (region == 'E' || region == 'e')
    .set ItemSlot__startSlot, 0x807AB550
    .set ItemSlot__setFakeStockItem, 0x807ABB70
	.set ItemSlot__clearSlot, 0x807AB8F0 # change to mkwii one. look atp ulsar
    .set ItemStock__setItemWithCount, 0x807ADEA8
	.set ItemStock__clearItem, 0x807ADF60
    .set ptr_playerBase, 0x809BD110
    .set ptr_raceData, 0x809B8F68
    .set ptr_raceDirector, 0x809B8F70
    .set ptr_itemDirector, 0x809BEE20
.elseif (region == 'P' || region == 'p')
    .set ItemSlot__startSlot, 0x807B9FB0
    .set ItemSlot__setFakeStockItem, 0x807BA5D0
	.set ItemSlot__clearSlot, 0x807BA350
    .set ItemStock__setItemWithCount, 0x807BC908
	.set ItemStock__clearItem, 0x807BC9C0
    .set ptr_playerBase, 0x809C18F8
    .set ptr_raceData, 0x809BD728
    .set ptr_raceDirector, 0x809BD730
    .set ptr_itemDirector, 0x809C3618
.elseif (region == 'J' || region == 'j')
    .set ItemSlot__startSlot, 0x807B961C
    .set ItemSlot__setFakeStockItem, 0x807B9C3C
	.set ItemSlot__clearSlot, 0x807B99BC
    .set ItemStock__setItemWithCount, 0x807BBF74
	.set ItemStock__clearItem, 0x807BC02C
    .set ptr_playerBase, 0x809C0958
    .set ptr_raceData, 0x809BC788
    .set ptr_raceDirector, 0x809BC790
    .set ptr_itemDirector, 0x809C2678
.elseif (region == 'K' || region == 'k')
    .set ItemSlot__startSlot, 0x807A8370
    .set ItemSlot__setFakeStockItem, 0x807A8990
	.set ItemSlot__clearSlot, 0x807A8710
    .set ItemStock__setItemWithCount, 0x807AACC8
	.set ItemStock__clearItem, 0x807AAD80
    .set ptr_playerBase, 0x809AFF38
    .set ptr_raceData, 0x809ABD68
    .set ptr_raceDirector, 0x809ABD70
    .set ptr_itemDirector, 0x809B1C58
.else
    .err
.endif

.set GAMETYPE_LIVE_VIEW, 6

.set ITEMSLOT_NET_STATE_EMPTY, 0
.set ITEMSLOT_NET_STATE_REQUEST, 1
.set ITEMSLOT_NET_STATE_REQUEST_DONE, 2
.set ITEMSLOT_NET_STATE_STOPPED, 3
.set ITEMSLOT_NET_STATE_STOCK_3, 4
.set ITEMSLOT_NET_STATE_STOCK_2, 5
.set ITEMSLOT_NET_STATE_STOCK_1, 6
.set ITEMSLOT_NET_STATE_REQUEST_FAIL, 7

.set ITEMSLOT_MUSHROOM, 4
.set ITEMSLOT_TRIPLE_MUSHROOM, 5
.set ITEMSLOT_THUNDER_CLOUD, 0xE
.set ITEMSLOT_BULLET_BILL, 0xF
.set ITEMSLOT_NONE, 0x14

.set ITEMSLOT_STATE_STOPPED, 0
.set ITEMSLOT_STATE_LAST_SPIN, 2



stwu sp, -0x80 (sp)
stmw r3, 8 (sp)

lis r12, ptr_raceData@ha
lwz r11, ptr_raceData@l (r12)
lwz r11, 0xB74 (r11)
cmpwi r11, GAMETYPE_LIVE_VIEW
bne end

lbz r28, 0x11 (r3)
lbz r31, 0x13 (r3)

cmpwi r28, ITEMSLOT_NONE
blt getItemPtr

li r28, ITEMSLOT_MUSHROOM


getItemPtr:
lwz r30, ptr_itemDirector@l (r12)
lwz r30, 0x14 (r30)
mulli r11, r26, 0x248
add r30, r30, r11
lwz r3, 0x58 (r30)

isNetworkItemSlotEmpty:
cmpwi r31, ITEMSLOT_NET_STATE_EMPTY
beq clearSlotAndItem

cmpwi r31, ITEMSLOT_NET_STATE_REQUEST_DONE
bgt updateSlotAndStock

cmpwi r3, ITEMSLOT_STATE_STOPPED
bne calcFakeKillerItem

addi r3, r30, 0x54
li r4, 0
lwz r5, ptr_raceDirector@l (r12)
lwz r5, 0xC (r5)
mulli r6, r26, 4
lwzx r5, r5, r6
lbz r5, 0x20 (r5)
li r6, 0
li r7, 0
lis r12, ItemSlot__startSlot@h
ori r12, r12, ItemSlot__startSlot@l
mtctr r12
bctrl

stw r28, 0x74 (r30)

lis r3, 0x8000
stw r3, 0x5C (r30)

li r3, -1
stw r3, 0x234 (r30)

li r4, ITEMSLOT_NONE
b isSameFakeStockItem


clearSlotAndItem:
cmpwi r3, ITEMSLOT_STATE_STOPPED
beq isSlotEmpty

clearSlot:
addi r3, r30, 0x54
lis r12, ItemSlot__clearSlot@h
ori r12, r12, ItemSlot__clearSlot@l
mtctr r12
bctrl

isSlotEmpty:
lwz r3, 0x8C (r30)
cmpwi r3, ITEMSLOT_NONE
beq calcFakeKillerItem

addi r3, r30, 0x88
lis r12, ItemStock__clearItem@h
ori r12, r12, ItemStock__clearItem@l
mtctr r12
bctrl
b calcFakeKillerItem


updateSlotAndStock:
cmpwi r3, ITEMSLOT_STATE_STOPPED
beq updateStock

cmpwi r3, ITEMSLOT_STATE_LAST_SPIN
beq calcFakeKillerItem

lwz r3, 0x74 (r30)
cmpwi r3, ITEMSLOT_THUNDER_CLOUD
beq clearSlot

li r3, ITEMSLOT_STATE_LAST_SPIN
stw r3, 0x58 (r30)
b calcFakeKillerItem

updateStock:
lwz r3, 0x8C (r30)
mr r4, r28
subfic r5, r31, 7
li r6, 0

cmpwi r31, ITEMSLOT_NET_STATE_REQUEST_FAIL
bne isSameStockAsNetwork

cmpwi r3, ITEMSLOT_TRIPLE_MUSHROOM
beq calcFakeKillerItem

li r5, 1
li r6, 1

isSameStockAsNetwork:
cmpw r3, r4
bne setStockItemWithCount

lwz r3, 0x90 (r30)
cmpw r3, r5
beq calcFakeKillerItem

setStockItemWithCount:
addi r3, r30, 0x88
lis r12, ItemStock__setItemWithCount@h
ori r12, r12, ItemStock__setItemWithCount@l
mtctr r12
bctrl

calcFakeKillerItem:
li r4, ITEMSLOT_NONE

lwz r3, 0 (r30)
lwz r3, 4 (r3)
lwz r3, 0xC (r3)
andis. r3, r3, 0x800
beq isSameFakeStockItem

setEmptyDisplayItem:
li r4, ITEMSLOT_BULLET_BILL

isSameFakeStockItem:
lwz r3, 0x78 (r30)
cmpw r3, r4
beq end

addi r3, r30, 0x54
lis r12, ItemSlot__setFakeStockItem@h
ori r12, r12, ItemSlot__setFakeStockItem@l
mtctr r12
bctrl

end:
lmw r3, 8 (sp)
addi sp, sp, 0x80

lbz r0, 0x13 (r3) # Original instruction