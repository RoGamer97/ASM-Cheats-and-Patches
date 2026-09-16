## Clear Exhaust Pipe Boost Particle After Damage

Clears the exhaust pipe boost particle after damage. When you boost, the exhaust pipe boost particle duration is the same as the boost, however, when the boost is cleared by damage, the boost particle isn't cleared, but this is not a problem because boost doesn't last long enough for the particle to stay after damage.

However, when using codes that enlarge the boost time (for example: Kart Status Stacker or Ultra Miniturbo), this is a problem because the boost particle will stay even after damage until the time runs out. This code fixes it by clearing the boost particle entirely after damage.

This is Wingcapman's request: https://mariokartwii.com/showthread.php?tid=2394

<details>
<summary>NTSC-U</summary>

```
C2563138 00000006
3C60809C 8063DA10
80630068 809F0000
80A40028 80840000
88840010 1C840004
7C63202E 38000000
90030018 00000000
```
</details>

<details>
<summary>PAL</summary>

```
C25674B8 00000006
3C60809C 806321D0
80630068 809F0000
80A40028 80840000
88840010 1C840004
7C63202E 38000000
90030018 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

```
C2566E38 00000006
3C60809C 80631230
80630068 809F0000
80A40028 80840000
88840010 1C840004
7C63202E 38000000
90030018 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

```
C2555510 00000006
3C60809B 80630810
80630068 809F0000
80A40028 80840000
88840010 1C840004
7C63202E 38000000
90030018 00000000
```
</details>

[ASM source](source.s)