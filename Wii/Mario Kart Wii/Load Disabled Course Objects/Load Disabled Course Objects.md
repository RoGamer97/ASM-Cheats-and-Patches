## Load Disabled Course Objects

Loads "disabled" course objects.

The course.kmp file (which stores many of the course's specific parameters, such as object placement) has a presence value defined for every object to determine in which instances it should load (for example, should it load in every mode, only on single player and not multiplayer, etc). Certain objects have this value set to 0x00 which disables the object, preventing it to appear in-game and thus going unused. This code makes it so these objects are loaded.

For reference, here's a list of disabled objects: https://tcrf.net/Mario_Kart_Wii/Unused_Course_Elements

<details>
<summary>NTSC-U</summary>

```
0481340C 38000001
```
</details>

<details>
<summary>PAL</summary>

```
04826F20 38000001
```
</details>

<details>
<summary>NTSC-J</summary>

```
0482658C 38000001
```
</details>

<details>
<summary>NTSC-K</summary>

```
048152E0 38000001
```
</details>