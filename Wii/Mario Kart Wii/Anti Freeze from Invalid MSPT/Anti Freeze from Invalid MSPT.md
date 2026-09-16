## Anti Freeze from Invalid MSPT

Makes it so you respawn on the start point if the MSPT (Mission Success Point, also used in Battle) point is invalid, preventing the game from freezing.

<details>
<summary>NTSC-U</summary>

```
C25146FC 00000003
3C60809C 80638F28
80630008 80630000
80630000 00000000
```
</details>

<details>
<summary>PAL</summary>

```
C2518B70 00000003
3C60809C 8063D6E8
80630008 80630000
80630000 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

```
C25184F0 00000003
3C60809C 8063C748
80630008 80630000
80630000 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

```
C2506B90 00000003
3C60809C 8063BD28
80630008 80630000
80630000 00000000
```
</details>

[ASM source](source.s)