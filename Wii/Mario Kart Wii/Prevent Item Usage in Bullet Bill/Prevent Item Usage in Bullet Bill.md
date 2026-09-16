## Prevent Item Usage in Bullet Bill

Prevents using items in Bullet Bill. It's useful because in most packs, "No Bullet Icon" is present, allowing you to get items in Bullet, however, there are two problems with this:
* It may be unfair at times and out of place. By preventing the usage, you can get items, but you cannot use them until the Bullet ends.
* Using status items will just waste them, for example: Using a Star or a Mushroom will just do nothing and you'll lose your item. This is the main reason why I made this code

There are two versions of this code:
* Every Item
* Use/Non Throw Items Only (Mushroom, Triple Mushroom, Lightning, Star, Golden Mushroom, Mega Mushroom, Blooper, POW and Bullet Bill)

Source code can be modified to add/remove items.

# Every Item

<details>
<summary>NTSC-U</summary>

```
0478EC38 3C600A0C
```
</details>

<details>
<summary>PAL</summary>

```
04797C44 3C600A0C
```
</details>

<details>
<summary>NTSC-J</summary>

```
047972B0 3C600A0C
```
</details>

<details>
<summary>NTSC-K</summary>

```
04786004 3C600A0C
```
</details>

# Use/Non Throw Items Only

<details>
<summary>NTSC-U</summary>

```
C278EC38 00000008
3C60020C 4800000D
0405090A 0F0BFF00
7D6802A6 809D008C
898B0000 2C0C00FF
41820018 7C046000
4182000C 396B0001
4BFFFFE4 64630800
60000000 00000000
```
</details>

<details>
<summary>PAL</summary>

```
C2797C44 00000008
3C60020C 4800000D
0405090A 0F0BFF00
7D6802A6 809D008C
898B0000 2C0C00FF
41820018 7C046000
4182000C 396B0001
4BFFFFE4 64630800
60000000 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

```
C27972B0 00000008
3C60020C 4800000D
0405090A 0F0BFF00
7D6802A6 809D008C
898B0000 2C0C00FF
41820018 7C046000
4182000C 396B0001
4BFFFFE4 64630800
60000000 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

```
C2786004 00000008
3C60020C 4800000D
0405090A 0F0BFF00
7D6802A6 809D008C
898B0000 2C0C00FF
41820018 7C046000
4182000C 396B0001
4BFFFFE4 64630800
60000000 00000000

```
</details>

[ASM source](source.s)