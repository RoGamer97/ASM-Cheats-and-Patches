# Game: Mario Kart Wii
# Code: Fix Tournament/Mission Monty Mole Scoring Bug


# NTSC-U 806B5D6C
# PAL 806BA1F4
# NTSC-J 806B9860
# NTSC-K 806A859C

# Overrides the loaded gamemode with GP in Monty Mole damage function
# if kart is not in Star, Mega, or Bullet.
# It skips adding points if gamemode is not Tournament/Mission

.set RACERULE_GP, 0

lwz r0, 0xB70 (r6) # Original instruction

lwz r12, 0 (r30)
lwz r12, 4 (r12)
lwz r11, 8 (r12)
andis. r11, r11, 0x8000 # Star
bne end

lwz r12, 0xC (r12)
lis r11, 0x800 # Bullet
ori r11, r11, 0x8000 # Mega
and. r12, r12, r11
bne end

li r0, RACERULE_GP

end: