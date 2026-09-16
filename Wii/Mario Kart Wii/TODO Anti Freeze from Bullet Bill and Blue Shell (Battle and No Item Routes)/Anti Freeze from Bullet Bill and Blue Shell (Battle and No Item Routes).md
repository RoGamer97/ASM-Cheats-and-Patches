## Anti Freeze from Bullet Bill/Blue Shell (Battle/No Item Routes) 

This code will prevent the game from freezing if a Bullet Bill is used in a course that has no item routes (example: Battle stages).
I remade this code because the one found in Wiimmfi payload (made by Leseratte) has two problematic issues: Respawning too much (you and CPUs) offline (in Battle/course with no item routes) cause the game to lag very badly, dropping FPS down to around 10FPS. And also another problem which I must explain first, apparently Blue Shells crash the game in VS if the course has no item routes, but only when it's flying around the course and not flying to target - Leseratte's code fixes the crash but causes the game to lag VERY badly, dropping FPS down to 1 FPS. This can be exploited on Wiimmfi (and NewWFC for hackers that use Leseratte's code) by sending Blue Shells with invalid route IDs, causing the game to even lower than 1 FPS depending on how many blues are in play.
.
My version of the code prevents the game from freezing from Bullets and Blues if item routes aren't present and does not cause any of the issues mentioned above.

<details>
<summary>NTSC-U</summary>

```powerpc
C25108C8 00000002
2C0400FF 4D820020
80630018 00000000
047AAA84 60000000
```
</details>

<details>
<summary>PAL</summary>

```powerpc
C2514D3C 00000002
2C0400FF 4D820020
80630018 00000000
047B94E4 60000000
```
</details>

<details>
<summary>NTSC-J</summary>

```powerpc
C25146BC 00000002
2C0400FF 4D820020
80630018 00000000
047B8B50 60000000
```
</details>

<details>
<summary>NTSC-K</summary>

```powerpc
C2502D5C 00000002
2C0400FF 4D820020
80630018 00000000
047A78A4 60000000
```
</details>