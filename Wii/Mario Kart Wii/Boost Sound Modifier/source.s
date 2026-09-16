# Game: Mario Kart Wii
# Code: Boost Sound Modifier

# Note:
# Mario Kart Wii has no official symbols.
# Names for functions, global addresses, constants, and other game elements
# are either defined by me (often inspired by official naming in other
# Mario Kart games) or based on names used by other members of the community.

# NTSC-U 80701950
# PAL 807082F4
# NTSC-J 80707960
# NTSC-K 806F669C

# To replace other sounds with other sounds, find their index IDs in the revo_kart.brsar file

# Original sound (To be replaced)
.set SOUND_DASH, 0x19C

# Sound that it is replaced with
.set SOUND_STAR_BARRIER, 0x110

# Branch to end if sound ID is not boost
cmpwi r4, SOUND_DASH
bne end

# Replace ID with another one
li r4, SOUND_STAR_BARRIER

# End (Original instruction)
end:
stw r31, 0x2C (sp)
