# Game: Mario Kart Wii
# Code: Anti Freeze from VS Vehicles in Battle 

# NTSC-U 8054DFA4
# PAL 80553FC4
# NTSC-J 80553944
# NTSC-K 8054201C

.set VEHICLE_STANDARD_KART_L, 2
.set VEHICLE_STANDARD_BIKE_S, 0x12
.set VEHICLE_STANDARD_BIKE_L, 0x14


lwz r19, 0x30 (r4)
cmpwi r19, VEHICLE_STANDARD_KART_L
ble original

cmpwi r19, VEHICLE_STANDARD_BIKE_S
blt end

cmpwi r19, VEHICLE_STANDARD_BIKE_L
bgt end

original:
lwz r20, 0xF4 (r4) # Original instruction

end:
