## Anti Late/Lag Start Online

Avoids late lag starts in online races by starting the countdown as soon as all players are ready (When everyone sends the READY event).

Normally, the countdown can only start once the starting camera is finished. So, if you load in late, you'll send the "READY" event before the camera is done. The countdown will start for everyone else, but yours will be delayed until the camera finishes, causing you to start later than everyone else.

This code lets the countdown start as soon as everyone is ready, even if the camera isn’t done yet.

It’s a remake of MrBean's (I believe) code from CTGP-R, and it works exactly the same. The code is safe for legit gameplay and doesn't cause any issues.

<details>
<summary>NTSC-U</summary>

```
C252E8E8 00000005
819E8F68 818C0B70
2C0C0007 41800010
2C0C000A 41810008
38600001 2C030000
60000000 00000000
```
</details>

<details>
<summary>PAL</summary>

```
C2533430 00000005
819ED728 818C0B70
2C0C0007 41800010
2C0C000A 41810008
38600001 2C030000
60000000 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

```
C2532DB0 00000005
819EC788 818C0B70
2C0C0007 41800010
2C0C000A 41810008
38600001 2C030000
60000000 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

```
C2521488 00000005
819EBD68 818C0B70
2C0C0007 41800010
2C0C000A 41810008
38600001 2C030000
60000000 00000000
```
</details>

[ASM source](source.s)