## Fix CPU Slipstream Mission Scoring Bug

Fixes a bug where when playing a Slipstream Mission, you'll score when a CPU slipstreams. With this code, it will now only score when you slipstream.

<details>
<summary>NTSC-U</summary>

```
C2580BA0 00000004
80050B70 819B0000
818C0004 818C0014
718C0002 40820008
38000000 00000000
```
</details>

<details>
<summary>PAL</summary>

```
C25873C4 00000004
80050B70 819B0000
818C0004 818C0014
718C0002 40820008
38000000 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

```
C2586D44 00000004
80050B70 819B0000
818C0004 818C0014
718C0002 40820008
38000000 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

```
C257541C 00000004
80050B70 819B0000
818C0004 818C0014
718C0002 40820008
38000000 00000000
```
</details>

[ASM source](source.s)