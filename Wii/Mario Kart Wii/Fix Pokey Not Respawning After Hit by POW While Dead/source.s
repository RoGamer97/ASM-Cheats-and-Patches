# Game: Mario Kart Wii
# Code: Fix Pokey Never Respawning After Hit by POW While Destroyed
# Description:
# NOTE: Mario Kart Wii has no official symbols. Function names are either custom names, borrowed from other Mario Kart games, or community names


# NTSC-U 80766180
# PAL 8077AC50
# NTSC-J 8077A2BC
# NTSC-K 80769010

.set SANBOSTATE_DEAD, 1
.set SANBOSTATE_SHAKE, 3

cmpwi r0, SANBOSTATE_DEAD
beq skipOriginal

cmpwi r0, SANBOSTATE_SHAKE # Original instruction

skipOriginal: