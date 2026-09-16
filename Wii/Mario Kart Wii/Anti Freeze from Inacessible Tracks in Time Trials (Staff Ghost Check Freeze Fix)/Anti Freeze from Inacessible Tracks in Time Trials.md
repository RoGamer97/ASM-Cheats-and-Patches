## Anti Freeze from Inacessible Tracks in Time Trials (Staff Ghost Check Freeze Fix)

Fixes an issue where the game freezes when trying to play inacessible tracks in Time Trials (Like Battle stages, Galaxy Colloseum, Lugi Circuit Ending etc).

<details>
<summary>NTSC-U</summary>

```
C2551284 00000003
38000000 2C030000
41820008 88030056
60000000 00000000
```
</details>

<details>
<summary>PAL</summary>

```
C25504E8 00000003
38000000 2C030000
41820008 88030056
60000000 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

```
C254FE68 00000003
38000000 2C030000
41820008 88030056
60000000 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

```
C253E540 00000003
38000000 2C030000
41820008 88030056
60000000 00000000
```
</details>

[ASM source](source.s)