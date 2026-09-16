## Anti Item Route Link Lag

There's an issue in the game where if an item route links to itself on a Custom Track, it causes red and blue shells to corrupt and rotate around that route point at extremely high speed and velocity, causing the game to lag down to 1FPS.
It is similar to the blue shell causing the game to lag down to 1FPS if no item routes are found, however, that issue happens because of Anti Freeze from Bullet in Battle code (without it, it freezes). The route link issue here is not related to that code and happens in the game without code on trash Custom Tracks.

Capping the speed/velocity will fix the issue but causes the shell to be rotating around that route infinitely, there is another way to fix it without cauing lag but it causes the shell to fly away out of the track at light speed.

The fix here is to make the shell vanish (poof) if it the speed is extremely fast, avoiding the lag and eliminating the infinite rotating shell.

<details>
<summary>NTSC-U</summary>

```
C2796734 00000007
C03D0048 801D0004
2C000001 4182000C
2C000005 40820020
C05D0258 C01F0004
FC020040 41800010
EC210828 D03D0258
C03F0010 00000000
```
</details>

<details>
<summary>PAL</summary>

```
C279F740 00000007
C03D0048 801D0004
2C000001 4182000C
2C000005 40820020
C05D0258 C01F0004
FC020040 41800010
EC210828 D03D0258
C03F0010 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

```
C279EDAC 00000007
C03D0048 801D0004
2C000001 4182000C
2C000005 40820020
C05D0258 C01F0004
FC020040 41800010
EC210828 D03D0258
C03F0010 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

```
C278DB00 00000007
C03D0048 801D0004
2C000001 4182000C
2C000005 40820020
C05D0258 C01F0004
FC020040 41800010
EC210828 D03D0258
C03F0010 00000000
```
</details>

[ASM source](source.s)