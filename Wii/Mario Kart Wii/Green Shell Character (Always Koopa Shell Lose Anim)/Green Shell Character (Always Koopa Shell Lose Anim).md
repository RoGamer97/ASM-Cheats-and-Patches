## Green Shell Character (Always Koopa Shell Lose Anim)

Another silly and useless code. This code forces Koopa to do the losing animation, which is him going inside of his shell and never appearing again, thus, it looks like you're driving a green shell character. I had this idea after I had a memory of me recording that animation as a kid and pretending it was a custom character. 

<details>
<summary>NTSC-U</summary>

```
C27BD5D8 00000004
83E30000 83FF007C
2C1F000E 40820008
3880000A 7C9F2378
60000000 00000000
C27C3DB0 00000004
80030004 807E0000
8063007C 2C03000E
40820008 3800FFFF
60000000 00000000
```
</details>

<details>
<summary>PAL</summary>

```
C27CC038 00000004
83E30000 83FF007C
2C1F000E 40820008
3880000A 7C9F2378
60000000 00000000
C27D2810 00000004
80030004 807E0000
8063007C 2C03000E
40820008 3800FFFF
60000000 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

```
C27CB6A4 00000004
83E30000 83FF007C
2C1F000E 40820008
3880000A 7C9F2378
60000000 00000000
C27D1E7C 00000004
80030004 807E0000
8063007C 2C03000E
40820008 3800FFFF
60000000 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

```
C27BA3F8 00000004
83E30000 83FF007C
2C1F000E 40820008
3880000A 7C9F2378
60000000 00000000
C27C0BD0 00000004
80030004 807E0000
8063007C 2C03000E
40820008 3800FFFF
60000000 00000000
```
</details>

[ASM source](source.s)