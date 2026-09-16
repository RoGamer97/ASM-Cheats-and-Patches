## Prevent Ghost Bullet Bills Online (End Disconnected Player's Bullet)

Prevents an issue where when someone disconnects while in a Bullet, their Bullet will remain in play, following the course like normal, except that it's unsolid and it has no nametag or minimap icon (Ghost Bullet). When the Bullet ends, the disconnect player will shrink and vanish.

Here's an occurence of an infinite Ghost Bullet, caused by a bad Custom Track item route that made the Bullet spin in place and never end because of "can't drop" setting: https://www.youtube.com/watch?v=dDSfkmfXgQk (The player disconnects at 00:20, but their Bullet remain in play for the rest of the race)

<details>
<summary>NTSC-U</summary>

```
C257AB6C 00000008
80630000 9421FF80
BC610008 8083000C
74840800 41820020
7FC802A6 807F0060
3D80805B 618C1100
7D8903A6 4E800421
7FC803A6 B8610008
38210080 00000000
```
</details>

<details>
<summary>PAL</summary>

```
C25813D0 00000008
80630000 9421FF80
BC610008 8083000C
74840800 41820020
7FC802A6 807F0060
3D808059 618CC118
7D8903A6 4E800421
7FC803A6 B8610008
38210080 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

```
C2580D50 00000008
80630000 9421FF80
BC610008 8083000C
74840800 41820020
7FC802A6 807F0060
3D808059 618CBA98
7D8903A6 4E800421
7FC803A6 B8610008
38210080 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

```
C256F428 00000008
80630000 9421FF80
BC610008 8083000C
74840800 41820020
7FC802A6 807F0060
3D808058 618CA170
7D8903A6 4E800421
7FC803A6 B8610008
38210080 00000000
```
</details>


[ASM source](source.s)