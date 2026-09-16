## Moving Road Doesn't Move Kart

When standing in a moving road, it won't move the kart. Moving roads are Toad's Factory conveyor belts, Coconut Mall escalators and both Koopa Cape and DS Yoshi Falls and waterfalls. Be aware that they will still behave as normal (You will gain speed from them). This is actually in the game; when in a star (and mega I suppose), these objects won't move you. Code has a filter to pick who to affect.

# Local Player Only

<details>
<summary>NTSC-U</summary>

```
C2591614 00000003
80030008 80630014
70630002 41820008
3C008000 00000000
C2591344 00000003
80040008 80640014
70630002 41820008
3C008000 00000000
```
</details>

<details>
<summary>PAL</summary>


```
C2597E38 00000003
80030008 80630014
70630002 41820008
3C008000 00000000
C2597B68 00000003
80040008 80640014
70630002 41820008
3C008000 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

```
C25977B8 00000003
80030008 80630014
70630002 41820008
3C008000 00000000
C25974E8 00000003
80040008 80640014
70630002 41820008
3C008000 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

```
C2585E90 00000003
80030008 80630014
70630002 41820008
3C008000 00000000
C2585BC0 00000003
80040008 80640014
70630002 41820008
3C008000 00000000
```
</details>

# Everyone

<details>
<summary>NTSC-U</summary>

```
04591614 3C008000
04591344 3C008000
```
</details>

<details>
<summary>PAL</summary>


```
04597E38 3C008000
04597B68 3C008000
```
</details>

<details>
<summary>NTSC-J</summary>

```
045977B8 3C008000
045974E8 3C008000
```
</details>

<details>
<summary>NTSC-K</summary>

```
04585E90 3C008000
04585BC0 3C008000
```
</details>

[ASM source](source.s)