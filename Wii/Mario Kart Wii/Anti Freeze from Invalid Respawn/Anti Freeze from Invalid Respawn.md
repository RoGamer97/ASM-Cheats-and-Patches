## Anti Freeze from Invalid Respawn

Makes it so you respawn on the start point if the respawn point is invalid (non existent or wrong link), preventing the game from freezing.

<details>
<summary>NTSC-U</summary>

```
C25144F0 00000003
3C60809C 80638F28
80630008 80630000
80630000 00000000
```
</details>

<details>
<summary>PAL</summary>

```
C2518964 00000003
3C60809C 8063D6E8
80630008 80630000
80630000 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

```
C25182E4 00000003
3C60809C 8063C748
80630008 80630000
80630000 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

```
C2506984 00000003
3C60809C 8063BD28
80630008 80630000
80630000 00000000
```
</details>

[ASM source](source.s)