# Game: Mario Kart Wii
# Code: Boost Particle Color Modifier

# NTSC-U 80032414
# PAL 800324B4
# NTSC-J 800323D4
# NTSC-K 80032514

# Modify RGB values for the color you want. Hex is supported - Set to white as placeholder
.set RED_COLOR, 255
.set GREEN_COLOR, 255
.set BLUE_COLOR, 255

.set PARTICLE_BOOST, 8

cmpwi r31, PARTICLE_BOOST
bne end

lis r12, RED_COLOR << 8 | GREEN_COLOR
ori r12, r12, BLUE_COLOR << 8
stw r12, 0 (r4)

end:
mflr r0 # Original instruction