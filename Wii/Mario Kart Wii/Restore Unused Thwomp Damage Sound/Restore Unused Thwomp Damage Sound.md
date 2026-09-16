## Restore Unused Thwomp Damage Sound

Restores an unused sound that would when damaging Thwomps.

Someone by the name of "DBlaze" found out that there's an unused sound referred to as "SE_CC_DOSSUN_V_DMG" internally (ID 0x246) that would SUPPOSELY play when a thwomp was hit (star, bomb or anything that hurts them). This code restores this behaviour.

<details>
<summary>NTSC-U</summary>

```
C2753174 00000004
7FE3FB78 38800246
3D808080 618CCA48
7D8903A6 4E800421
819F0000 00000000
```
</details>

<details>
<summary>PAL</summary>

```
C27600C0 00000004
7FE3FB78 38800246
3D808082 618C055C
7D8903A6 4E800421
819F0000 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

```
C275F72C 00000004
7FE3FB78 38800246
3D808081 618CFBC8
7D8903A6 4E800421
819F0000 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

```
C274E480 00000004
7FE3FB78 38800246
3D808080 618CE91C
7D8903A6 4E800421
819F0000 00000000
```
</details>

[ASM source](source.s)