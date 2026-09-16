## Kart Grow Loop

Increases your kart size quickly then once it's big, it resets to a smaller size and regrows, repeately. It's a silly code but it's a cool effect. Code has filter to pick who to affect.

<details>
<summary>NTSC-U</summary>

XXXXXXXX (Who to affect):
4182001C Affect only you
4082001C Affect only others
600000000 Affect everyone

```
C257AFE0 00000006
80040008 81840014
718C0002 XXXXXXXX
A1830160 398C0008
2C0C4040 41800008
39803F00 B1830160
60000000 00000000
```
</details>

<details>
<summary>PAL</summary>

XXXXXXXX (Who to affect):
4182001C Affect only you
4082001C Affect only others
600000000 Affect everyone

```
C2581844 00000006
80040008 81840014
718C0002 XXXXXXXX
A1830160 398C0008
2C0C4040 41800008
39803F00 B1830160
60000000 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

XXXXXXXX (Who to affect):
4182001C Affect only you
4082001C Affect only others
600000000 Affect everyone

```
C25811C4 00000006
80040008 81840014
718C0002 XXXXXXXX
A1830160 398C0008
2C0C4040 41800008
39803F00 B1830160
60000000 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

XXXXXXXX (Who to affect):
4182001C Affect only you
4082001C Affect only others
600000000 Affect everyone

```
C256F89C 00000006
80040008 81840014
718C0002 XXXXXXXX
A1830160 398C0008
2C0C4040 41800008
39803F00 B1830160
60000000 00000000
```
</details>

[ASM source](source.s)