## Boost Particle Color Modifier

Changes the boost particle color to any of your preference. The code can be modified to affect other particles, all you need to do is experiment with the compare IDs.

<details>
<summary>NTSC-U</summary>

RRGGBB (Color to select):
RR is Red
GG is Green
BB is Blue
Example of pink: FF00FF (255, 0, 255)

```
C2032414 00000004
2C1F0008 40820010
3D80RRGG 618BB000
91840000 7C0802A6
60000000 00000000
```
</details>

<details>
<summary>PAL</summary>

RRGGBB (Color to select):
RR is Red
GG is Green
BB is Blue
Example of pink: FF00FF (255, 0, 255)

```
C20324B4 00000004
2C1F0008 40820010
3D80RRGG 618BB000
91840000 7C0802A6
60000000 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

RRGGBB (Color to select):
RR is Red
GG is Green
BB is Blue
Example of pink: FF00FF (255, 0, 255)

```
C20323D4 00000004
2C1F0008 40820010
3D80RRGG 618BB000
91840000 7C0802A6
60000000 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

RRGGBB (Color to select):
RR is Red
GG is Green
BB is Blue
Example of pink: FF00FF (255, 0, 255)

```
C2032514 00000004
2C1F0008 40820010
3D80RRGG 618BB000
91840000 7C0802A6
60000000 00000000
```
</details>

[ASM source](source.s)