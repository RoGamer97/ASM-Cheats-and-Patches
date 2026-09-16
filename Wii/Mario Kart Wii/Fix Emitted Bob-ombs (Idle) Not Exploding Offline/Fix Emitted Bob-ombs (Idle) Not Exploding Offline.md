## Fix Emitted Bob-ombs (Idle) Not Exploding Offline

Fixes an issue where emitted Bob-ombs (dropped from Bushes/Woodboxes) stay on sitting animation, slide on slanted surfaces and never explode in offline play.

This issue is fixed on Item Rain, I decided to analyze Bean's code and found out that he fixed it inside of the main Item Rain hook code. I decided to recreate it for regular object emit.

By default, Bob-ombs have forward throw duration until explosion (5 seconds). I thought it would be cool if the user could change the duration, only for emitted Bob-ombs, so I included it in the code.

You can modify the time until explosion to your liking, or you can just use the original value.

<details>
<summary>NTSC-U</summary>

XXXX: Time until explosion (In frames)
Original value: 012C (300 frames -> 5 seconds)
For reference, backward throw duration value is 005A (90 frames -> 1.5 seconds)

```
C279E164 00000004
809E0004 2C040009
40820010 3800XXXX
901E01DC 8005FF04
901E0170 00000000
```
</details>

<details>
<summary>PAL</summary>

XXXX: Time until explosion (In frames)
Original value: 012C (300 frames -> 5 seconds)
For reference, backward throw duration value is 005A (90 frames -> 1.5 seconds)

```
C27A7170 00000004
809E0004 2C040009
40820010 3800XXXX
901E01DC 8005FF04
901E0170 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

XXXX: Time until explosion (In frames)
Original value: 012C (300 frames -> 5 seconds)
For reference, backward throw duration value is 005A (90 frames -> 1.5 seconds)

```
C27A67DC 00000004
809E0004 2C040009
40820010 3800XXXX
901E01DC 8005FF04
901E0170 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

XXXX: Time until explosion (In frames)
Original value: 012C (300 frames -> 5 seconds)
For reference, backward throw duration value is 005A (90 frames -> 1.5 seconds)

```
C2795530 00000004
809E0004 2C040009
40820010 3800XXXX
901E01DC 8005FF04
901E0170 00000000
```
</details>

[ASM source](source.s)