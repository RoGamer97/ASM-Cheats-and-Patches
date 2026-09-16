## Set Item Boxes Respawn Times in KMP

Allows you to change specific item boxes respawn time by modifying their setting in the course.kmp file.

In the KMP file, change itembox Setting 5 (Which is unused) to the respawn time in frames (Example: 003C for 1 second). 
If the value is 0000 (Default), then the item box will have the default respawn time, if the value is FFFF, then item box will NEVER respawn.

Will not work on item boxes from other objects (example: Chain Chomps from DS Peach Gardens).

This code is Wingcapman's request: https://mariokartwii.com/showthread.php?tid=2328

<details>
<summary>NTSC-U</summary>

```
C2814DA4 00000007
80A300B8 818300A0
2C0C0000 41820024
818C0000 A18C0032
2C0C0000 41820014
280CFFFF 40820008
38800000 7D856378
60000000 00000000
```
</details>

<details>
<summary>PAL</summary>

```
C28288B8 00000007
80A300B8 818300A0
2C0C0000 41820024
818C0000 A18C0032
2C0C0000 41820014
280CFFFF 40820008
38800000 7D856378
60000000 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

```
C2827F24 00000007
80A300B8 818300A0
2C0C0000 41820024
818C0000 A18C0032
2C0C0000 41820014
280CFFFF 40820008
38800000 7D856378
60000000 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

```
C2816C78 00000007
80A300B8 818300A0
2C0C0000 41820024
818C0000 A18C0032
2C0C0000 41820014
280CFFFF 40820008
38800000 7D856378
60000000 00000000
```
</details>

[ASM source](source.s)