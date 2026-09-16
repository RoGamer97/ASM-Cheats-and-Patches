## Fix Pokey Not Respawning After Hit by POW While Dead

Fixes a bug where if a Pokey is hit by a POW while dead, it will never respawn.

The Pokey dies when hit by an item, Lightning or kart in Star/Mega/Bullet. When hit by a kart by a non-invincible kart or POW, it shakes.

There's a bug in the game where if a dead/dying Pokey gets hit by a POW, it will never respawn. Actually, if a Lightning is used when they're bugged, they'll die again and then can respawn.

The game has a check that prevents Pokeys from shaking if they're already shaking. This code fixes this bug by also checking if they're dead, so they can't shake while dead.

Video of the bug: https://www.youtube.com/shorts/y1RfdScQFME

<details>
<summary>NTSC-U</summary>

```
C2766180 00000002
2C000001 41820008
2C000003 00000000
```
</details>

<details>
<summary>PAL</summary>

```
C277AC50 00000002
2C000001 41820008
2C000003 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

```
C277A2BC 00000002
2C000001 41820008
2C000003 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

```
C2769010 00000002
2C000001 41820008
2C000003 00000000
```
</details>

[ASM source](source.s)