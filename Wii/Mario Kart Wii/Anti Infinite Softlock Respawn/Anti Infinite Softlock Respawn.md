## Anti Infinite/Softlock Respawn

Makes it so if you respawn in a point that makes you fall out of bounds before touching the ground, it will respawn you at the previous respawn point.

This is only useful on Custom Tracks that make you respawn on a point that makes you immediately fall to your death without having the chance to touch the ground. Note that this code is only for this scenario: Falling in air boundary or solid boundary that is not ground (such as water and lava) during or after lakitu releases you but you have not touched the ground yet.

MUST USE with Invalid Respawn Anti Freeze since I made it so if you are stuck on the first respawn point, you respawn on invalid point (freeze), so use the code so you respawn on the start point instead, since there are no valid respawns behind.

<details>
<summary>NTSC-U</summary>

```
C256EFE4 00000009
809B0004 80A40000
88A50010 80840004
8084000C 70846000
41820028 80838F70
80840010 80840004
8084000C 7C84282E
88A40021 38A5FFFF
70A5007F 98A40021
38800000 00000000
```
</details>

<details>
<summary>PAL</summary>

```
C2573E34 00000009
809B0004 80A40000
88A50010 80840004
8084000C 70846000
41820028 8083D3A0
80840010 80840004
8084000C 7C84282E
88A40021 38A5FFFF
70A5007F 98A40021
38800000 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

```
C25737B4 00000009
809B0004 80A40000
88A50010 80840004
8084000C 70846000
41820028 8083CA0C
80840010 80840004
8084000C 7C84282E
88A40021 38A5FFFF
70A5007F 98A40021
38800000 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

```
C2561E8C 00000009
809B0004 80A40000
88A50010 80840004
8084000C 70846000
41820028 8083BD70
80840010 80840004
8084000C 7C84282E
88A40021 38A5FFFF
70A5007F 98A40021
38800000 00000000
```
</details>

[ASM source](source.s)