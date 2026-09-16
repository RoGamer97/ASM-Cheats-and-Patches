## Fix Explosion Camera Bug for No Invincibility Frames (No Hit Delay)

Fixes an issue where the explosion camera is stuck even after the explosion damage ends, caused by getting hit by a damage type different than explosion while in explosion damage when using No Invincibility Frames code (aka No Hit Delay).

This happens because the game only clears the explosion camera after the explosion damage ends, however, if getting hit by another damage type replaces the damage, so the explosion damage end never gets to happen, causing the camera to not be cleared.

The fix simply clears the explosion camera after any damage type is cleared. 

<details>
<summary>NTSC-U</summary>

```
C256313C 00000004
7FE3FB78 3D808058
618CA668 7D8903A6
4E800421 3860FFFF
60000000 00000000
```
</details>

<details>
<summary>PAL</summary>

```
C25674BC 00000004
7FE3FB78 3D808059
618C0E8C 7D8903A6
4E800421 3860FFFF
60000000 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

```
C2566E3C 00000004
7FE3FB78 3D808059
618C080C 7D8903A6
4E800421 3860FFFF
60000000 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

```
C2555514 00000004
7FE3FB78 3D808057
618CEEE4 7D8903A6
4E800421 3860FFFF
60000000 00000000
```
</details>

[ASM source](source.s)