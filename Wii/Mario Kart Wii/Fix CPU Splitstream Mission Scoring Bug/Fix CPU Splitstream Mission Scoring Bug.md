## Fix CPU Slipstream Mission Scoring "Bug"

Fixes a "bug" where when playing a Slipstream Mission, you'll score when a CPU slipstreams. With this code, it will now only score when you slipstream.

<details>
<summary>NTSC-U</summary>

```
C2580BC4 00000004
819B0000 818C0004
818C0014 718C0002
40820008 90040008
60000000 00000000
```
</details>

<details>
<summary>PAL</summary>

```
C25873E8 00000004
819B0000 818C0004
818C0014 718C0002
40820008 90040008
60000000 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

```
C2586D68 00000004
819B0000 818C0004
818C0014 718C0002
40820008 90040008
60000000 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

```
C2575440 00000004
819B0000 818C0004
818C0014 718C0002
40820008 90040008
60000000 00000000
```
</details>

[ASM source](source.s)