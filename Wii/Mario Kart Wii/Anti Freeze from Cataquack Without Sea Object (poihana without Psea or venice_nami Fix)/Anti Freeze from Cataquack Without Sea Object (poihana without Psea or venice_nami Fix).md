## Anti Freeze from Cataquack Without Sea Object (poihana without Psea or venice_nami Fix)

Cataquacks (poihana) objects need either GCN Peach Beach sea object (Psea) or Delfino Pier (venice_nami) for splash SFX when it walks, else the game freezes. 

This code fixes the freeze, removing the requirement of these objects.

<details>
<summary>NTSC-U</summary>

```
C28178CC 00000003
EC000028 2C030000
4D820020 C0030034
60000000 00000000
```
</details>

<details>
<summary>PAL</summary>

```
C282B3E0 00000003
EC000028 2C030000
4D820020 C0030034
60000000 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

```
C282AA4C 00000003
EC000028 2C030000
4D820020 C0030034
60000000 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

```
C28197A0 00000003
EC000028 2C030000
4D820020 C0030034
60000000 00000000
```
</details>

[ASM source](source.s)