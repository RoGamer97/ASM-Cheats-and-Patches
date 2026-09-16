## Fix Gliding/Flying When Respawning on a Mushroom Bounce

Fixes a glitch that happens when respawning directly on top of a bouncy mushroom: It causes you to bounce as Lakitu releases you and you start gliding/flying. You can only get out of this glitch if you touch the ground. Video of the glitch here: https://www.youtube.com/watch?si=8XsQco-...tfq-kBs7pU

When Lakitu releases you after it drags you back to the track, a flag is set. Let's call it JUGEM HANG. This flag is set the moment it releases you and cleared the moment you touch the ground.
When JUGEM HANG is set, the game doesn't execute the driving physics code, instead if executes different physics code especifically for Lakitu drop.
The different physics code constantly check if the player has landed (ON THE GROUND flag), if the player did land, the game will then execute code to clear respawn stuff and finally clear JUGEM DROP.

The problem happens here: Bouncing on a mushroom does NOT set the ON THE GROUND flag, causing JUGEM DROP to never be cleared, thus, driving physics won't execute, making your kart glide/fly.
The check for the ON THE GROUND flag is done at 8057B48C NTSC-U. It is possible to modify the check to make it check for both ON THE GROUND and MUSHROOM BOUNCE with a single line, however, it will still cause the glide glitch for a frame (Your kart will glide and move a few units for a frame, then get out of the glitch). 

Because of this, I decided to prevent Lakitu drop physics code entirely if both JUGEM DROP and MUSHROOM BOUNCE flags are set at the same time, that way the glitch will not happen at all.


<details>
<summary>NTSC-U</summary>

```
C257B45C 00000003
70C04040 2C004040
41820008 54C00463
60000000 00000000
```
</details>

<details>
<summary>PAL</summary>

```
C2581CC0 00000003
70C04040 2C004040
41820008 54C00463
60000000 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

```
C2581640 00000003
70C04040 2C004040
41820008 54C00463
60000000 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

```
C256FD18 00000003
70C04040 2C004040
41820008 54C00463
60000000 00000000
```
</details>

[ASM source](source.s)