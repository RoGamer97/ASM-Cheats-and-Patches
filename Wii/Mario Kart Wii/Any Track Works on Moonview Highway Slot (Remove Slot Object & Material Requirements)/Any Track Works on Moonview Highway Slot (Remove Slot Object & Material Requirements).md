## Any Track Works on Moonview Highway Slot (Remove Slot Object & Material Requirements)

By default, tracks can only run on Moonview Highway slot if they have at least one instance of the objects kart_truck and car_body, and have materials with specific names in the course model. See the appropriate section for information about these names.

This code removes those requirements, allowing any custom track to run on Moonview Highway slot (Anti Freeze).

NOTE: This code may make the game use more memory!

<details>
<summary>NTSC-U</summary>

```powerpc
04785258 60000000
C26C41F0 00000005
3B20FFFF 82DF00C8
2C160000 40820014
7EC802A6 3AD60238
7EC803A6 4E800020
60000000 00000000
C26C5AA0 00000003
801B00B0 807B00C8
2C030000 40820008
7C1C0378 00000000
```
</details>

<details>
<summary>PAL</summary>

```powerpc
0478E264 60000000
C26D2DC0 00000005
3B20FFFF 82DF00C8
2C160000 40820014
7EC802A6 3AD60238
7EC803A6 4E800020
60000000 00000000
C26D4670 00000003
801B00B0 807B00C8
2C030000 40820008
7C1C0378 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

```powerpc
0478D8D0 60000000
C26D242C 00000005
3B20FFFF 82DF00C8
2C160000 40820014
7EC802A6 3AD60238
7EC803A6 4E800020
60000000 00000000
C26D3CDC 00000003
801B00B0 807B00C8
2C030000 40820008
7C1C0378 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

```powerpc
0477C624 60000000
C26C1168 00000005
3B20FFFF 82DF00C8
2C160000 40820014
7EC802A6 3AD60238
7EC803A6 4E800020
60000000 00000000
C26C2A18 00000003
801B00B0 807B00C8
2C030000 40820008
7C1C0378 00000000

```
</details>

[ASM source](source.s)