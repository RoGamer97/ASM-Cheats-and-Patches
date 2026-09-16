## Force Specific Character Stats

Forces specific character stats, for example, you can play as any medium weight character with Daisy's stats. You can also play with any character stats regardless of weight, for example, Funky Kong stats on small weight characters. The code was designed so you can pick what character stat you want for each weight, also comes with a filter for you to pick who to affect. If you know ASM, you can modify the code to replace a specific character with another character stat, but for this current code, it will force a specific character stat for EVERY CHARACTER, however, you can choose THREE different stats FOR EACH WEIGHT, regardless if that character is from that weight.

# Local Player Only

<details>
<summary>NTSC-U</summary>

```
C258B948 00000009
3D80809C 818C8F68
396C0B84 38800004
7C8903A6 898B0000
7C0CE000 41820010
396B0001 4200FFF0
48000018 48000009
XXYYZZ00 7C8802A6
80030008 7FE400AE
1C9F018C 00000000
```
</details>

<details>
<summary>PAL</summary>

```
C259216C 00000009
3D80809C 818CD728
396C0B84 38800004
7C8903A6 898B0000
7C0CE000 41820010
396B0001 4200FFF0
48000018 48000009
XXYYZZ00 7C8802A6
80030008 7FE400AE
1C9F018C 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

```
C2591AEC 00000009
3D80809C 818CC788
396C0B84 38800004
7C8903A6 898B0000
7C0CE000 41820010
396B0001 4200FFF0
48000018 48000009
XXYYZZ00 7C8802A6
80030008 7FE400AE
1C9F018C 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

```
C25801C4 00000009
3D80809B 818CBD68
396C0B84 38800004
7C8903A6 898B0000
7C0CE000 41820010
396B0001 4200FFF0
48000018 48000009
XXYYZZ00 7C8802A6
80030008 7FE400AE
1C9F018C 00000000
```
</details>

# Everyone

<details>
<summary>NTSC-U</summary>

```
C258B948 00000004
48000009 XXYYZZ00
7C8802A6 80030008
7FE400AE 1C9F018C
60000000 00000000
```
</details>

<details>
<summary>PAL</summary>

```
C259216C 00000004
48000009 XXYYZZ00
7C8802A6 80030008
7FE400AE 1C9F018C
60000000 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

```
C2591AEC 00000004
48000009 XXYYZZ00
7C8802A6 80030008
7FE400AE 1C9F018C
60000000 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

```
C25801C4 00000004
48000009 XXYYZZ00
7C8802A6 80030008
7FE400AE 1C9F018C
60000000 00000000
```
</details>

[ASM source](source.s)