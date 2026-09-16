## Laser Rapid Fire Items

Makes it so you can laser rapid fire spam items by holding the item use button.

There are two versions of the code:

* Code 1: When using item hack, status items are used every frame and throwable items are used every other frame (Use, don't use, use, don't use) - Stable version
* Code 2: When using item hack, both status and throwable items are used every frame. Because of this, throwable items tend to brake on each other (Unless if using Impervious). Game may freeze when using triple items. Has a side effect where you can use items during the countdown - Less stable version

# Every Other frame

<details>
<summary>NTSC-U</summary>

```
04789E6C 38000001
0478ED10 540004E7
```
</details>

<details>
<summary>PAL</summary>

```
04792E78 38000001
04797D1C 540004E7
```
</details>

<details>
<summary>NTSC-J</summary>

```
047924E4 38000001
04797388 540004E7
```
</details>

<details>
<summary>NTSC-K</summary>

```
04781238 38000001
047860DC 540004E7
```
</details>

# Every Frame

<details>
<summary>NTSC-U</summary>

```
04789E6C 38000001
0478EF60 70001200
0478EF64 28001200
```
</details>

<details>
<summary>PAL</summary>

```
04792E78 38000001
04797F6C 70001200
04797F70 28001200
```
</details>

<details>
<summary>NTSC-J</summary>

```
047924E4 38000001
047975D8 70001200
047975DC 28001200
```
</details>

<details>
<summary>NTSC-K</summary>

```
04781238 38000001
0478632C 70001200
04786330 28001200
```
</details>