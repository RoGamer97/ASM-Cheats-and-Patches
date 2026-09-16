## Play Invalid Sound on Replaced Item Decide

When receiving a replaced item (Item replaced by Mushroom because of item limit being hit or online player denying your request), a "Rejected" sound (The one that plays when trying to start a Wii Wheel Only Tournament with another controller) will play instead of the regular item receive one.

NOTE: The "Mushroom '''BUG''' (Not an actual bug)" is NOT a replaced item!

<details>
<summary>NTSC-U</summary>

```
C278F140 00000002
1FDE0010 388000E3
7C84F214 00000000
```
</details>

<details>
<summary>PAL</summary>
```
C279814C 00000002
1FDE0010 388000E3
7C84F214 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

```
C27977B8 00000002
1FDE0010 388000E3
7C84F214 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

```
C278650C 00000002
1FDE0010 388000E3
7C84F214 00000000
```
</details>

[ASM source](source.s)