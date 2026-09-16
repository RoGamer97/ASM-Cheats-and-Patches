## Fix Online Players Stuck in Halfpipe (Halfpipe Warp Fix)

Fixes an issue where online players get stuck in halfpipe state on your screen for a very long time or for the rest of the race when falling ion the void, usually on Rainbow Road.

This happens because the game prevents the player from warping if in halfpipe state. Removing this condition isn't recommended as it can change gameplay aspect, such as players warping and lagging in regular halfpipes.

I've thought a lot about this problems and I came to the conclusion that it only happen when the player is stuck in the void because I don't see a scenario where the player is stuck in air for so long (even in problematic Custom Tracks) - if the player touches the ground, they warp, so for me that's the only scenario where it happens.
So, I decided to fix it based on out of bounds timer and not in air timer while in halfpipe. So, the halfpipe state will be cleared 130 frames after touching out of bounds (2:10 seconds, which is actually the time lakitu takes to put you back on the track).


<details>
<summary>NTSC-U</summary>

```
C2585734 00000005
81640008 556C056B
41820018 A81F0056
2C000052 4180000C
556B05A8 91640008
7D645B78 00000000
```
</details>

<details>
<summary>PAL</summary>

```
C258BF58 00000005
81640008 556C056B
41820018 A81F0056
2C000052 4180000C
556B05A8 91640008
7D645B78 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

```
C258B8D8 00000005
81640008 556C056B
41820018 A81F0056
2C000052 4180000C
556B05A8 91640008
7D645B78 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

```
C2579FB0 00000005
81640008 556C056B
41820018 A81F0056
2C000052 4180000C
556B05A8 91640008
7D645B78 00000000
```
</details>

[ASM source](source.s)