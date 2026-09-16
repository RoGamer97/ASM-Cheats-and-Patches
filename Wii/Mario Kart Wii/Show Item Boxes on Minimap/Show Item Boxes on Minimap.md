## Show Item Boxes on Minimap

Shows item boxes on minimap as cyan dots. Icon is accurate, it moves if item box is moving and disappears if item box has been broken.

This code includes CLF78's "Show Battle Map Icons" code in order to work: https://mariokartwii.com/showthread.php?tid=1840

<details>
<summary>NTSC-U</summary>

You can modify the icon color (Cyan by default) by modifying the source or replacing 39600007 with 3960000X (where X is the color):

Icon Color (X Value):
1: Yellow
2: Blue
3: Red
4: Black
5: Grey
6: Dark Blue
7: Cyan (Current color used)
8: Pink

```
00887BC7 00000001
C2887CF8 00000008
A1070002 8967000F
4800000D 6576C9D4
D5EE0000 7D8802A6
880C0000 2C000000
4182001C 7C050000
4182000C 398C0001
4BFFFFE8 39600007
7D054378 00000000
04887D70 7D655B78
```
</details>

<details>
<summary>PAL</summary>

You can modify the icon color (Cyan by default) by modifying the source or replacing 39600007 with 3960000X (where X is the color):

Icon Color (X Value):
1: Yellow
2: Blue
3: Red
4: Black
5: Grey
6: Dark Blue
7: Cyan (Current color used)
8: Pink

```
0088BFF7 00000001
C288C128 00000008
A1070002 8967000F
4800000D 6576C9D4
D5EE0000 7D8802A6
880C0000 2C000000
4182001C 7C050000
4182000C 398C0001
4BFFFFE8 39600007
7D054378 00000000
0488C1A0 7D655B78
```
</details>

<details>
<summary>NTSC-J</summary>

You can modify the icon color (Cyan by default) by modifying the source or replacing 39600007 with 3960000X (where X is the color):

Icon Color (X Value):
1: Yellow
2: Blue
3: Red
4: Black
5: Grey
6: Dark Blue
7: Cyan (Current color used)
8: Pink

```
0088B663 00000001
C288B794 00000008
A1070002 8967000F
4800000D 6576C9D4
D5EE0000 7D8802A6
880C0000 2C000000
4182001C 7C050000
4182000C 398C0001
4BFFFFE8 39600007
7D054378 00000000
0488B80C 7D655B78
```
</details>

<details>
<summary>NTSC-K</summary>

You can modify the icon color (Cyan by default) by modifying the source or replacing 39600007 with 3960000X (where X is the color):

Icon Color (X Value):
1: Yellow
2: Blue
3: Red
4: Black
5: Grey
6: Dark Blue
7: Cyan (Current color used)
8: Pink

```
0087A3B7 00000001
C287A4E8 00000008
A1070002 8967000F
4800000D 6576C9D4
D5EE0000 7D8802A6
880C0000 2C000000
4182001C 7C050000
4182000C 398C0001
4BFFFFE8 39600007
7D054378 00000000
0487A560 7D655B78
```
</details>

[ASM source](source.s)