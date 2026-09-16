## Show Every Object on Minimap

Makes every object visible on the minimap as a dot, similar to how it looks like in KMP editors. You can also change the color of the dots.

You can change the color and size of the dots. I
I already released a code to force a specific object to be visible on the minimap (Show Item Boxes on Minimap https://mariokartwii.com/showthread.php?tid=2065&highlight=item+boxes) but not all of them. 
You MUST use the "Show Battle Map Icons" code by CLF78 (I did not include it in my code to not take any credits and to make sure people are aware of his code. "Show Battle Map Icons" code by CLF78: https://mariokartwii.com/showthread.php?tid=1840)


<details>
<summary>NTSC-U</summary>

X: Color
1: Yellow
2: Blue
3: Red
4: Black
5: Grey
6: Dark Blue
7: Cyan
8: Pink

Y: Size
0: Very small
1: Normal size
2: Bigger
3: Very big

```
04887D00 60000000
04887D70 38A0000X
04887D68 38C0000Y
```
</details>

<details>
<summary>PAL</summary>

X: Color
1: Yellow
2: Blue
3: Red
4: Black
5: Grey
6: Dark Blue
7: Cyan
8: Pink

Y: Size
0: Very small
1: Normal size
2: Bigger
3: Very big

```
0488C130 60000000
0488C1A0 38A0000X
0488C198 38C0000Y
```
</details>

<details>
<summary>NTSC-J</summary>

X: Color
1: Yellow
2: Blue
3: Red
4: Black
5: Grey
6: Dark Blue
7: Cyan
8: Pink

Y: Size
0: Very small
1: Normal size
2: Bigger
3: Very big

```
0488B79C 60000000
0488B80C 38A0000X
0488B804 38C0000Y
```
</details>

<details>
<summary>NTSC-K</summary>

X: Color
1: Yellow
2: Blue
3: Red
4: Black
5: Grey
6: Dark Blue
7: Cyan
8: Pink

Y: Size
0: Very small
1: Normal size
2: Bigger
3: Very big

```
0487A4F0 60000000
0487A560 38A0000X
0487A558 38C0000Y
```
</details>