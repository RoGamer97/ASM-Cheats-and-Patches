# Game: Mario Kart Wii
# Code: Show Item Boxes on Minimap
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names


# Show Item Boxes on Minimap
# NTSC-U 80887CF8
# PAL 8088C128
# NTSC-J 8088B794
# NTSC-K 8087A4E8

.set OBJECT_ITEMBOX, 0x65
.set OBJECT_MOVING_SITEMBOX, 0x75
.set OBJECT_MOVING_FITEMBOX, 0xC9
.set OBJECT_MOVING_WITEMBOX, 0xD4
.set OBJECT_MOVING_WITEMBOXLINE, 0xD5
.set OBJECT_MOVING_SINITEMBOX, 0xEE

.set MAP_OBJ_ICON_COLOR_CYAN, 7

lhz r8, 2 (r7) # Original instruction

lbz r11, 0xF (r7)

# Table containing all item boxes objects IDs
bl objectsTable

.hword OBJECT_ITEMBOX
.hword OBJECT_MOVING_SINITEMBOX
.hword OBJECT_MOVING_FITEMBOX
.hword OBJECT_MOVING_WITEMBOX
.hword OBJECT_MOVING_WITEMBOXLINE
.balign 4

objectsTable:
mflr r12

loop:
lbz r0, 0 (r12)
cmpwi r0, 0
beq end

isTargetObjectInTable:
cmpw r5, r0
beq setObjectColor

nextTableObjID:
addi r12, r12, 1
b loop

setObjectColor:
li r11, MAP_OBJ_ICON_COLOR_CYAN

setObjectSame:
mr r5, r8

end:



# Set object icon color
# NTSC- U 80887D70
# PAL 8088C1A0
# NTSC-J 8088B80C
# NTSC-K 8087A560
# Replace 'lwz r5, 0xC (r4) ' with 'mr r5, r11', to move object icon color from r11 (Loaded and modified in the hook above) to r5 instead of loading it again

