## Anti Online Item Delimiters

Prevents you from seeing hacked delimited Lightnings, POWs and Bloopers online. You will only see these items every ~26 seconds. Additionally, Stars, Megas, Bullets and Mushrooms delimiters prevention is also included (Read below for explanation).

Online, items like Lightning, POW, and Blooper usually have about a 26-second delay before they can appear/be seen again. Even if someone tries to spam them with hacks, other players won’t see them until that delay has passed.

Hackers discovered a way around this by changing these items behaviors from "USE" (Activate item, can't throw or drag) to "THROW" (Throw item, can drag). When status items behaviors are set to THROW, they can be thrown (item will stay frozen where it was thrown) and dragged, but will also activate. When throwing items, the game sends this item as “DRAGGED” item. Because of this, other players will receive these items as DRAGGED and will process the activation, just how they are also activated when thrown by changing the behavior.

This exploit affects other status items too. Stars, Bullet Bills, Megas, and Mushrooms activation is sent as a kart bit online instead of "USE" event. So, sending those as DRAGGED will cause the game to activate these, allowing things that are normally not possible, like making other players see you activate a Star during countdown, or activate a Bullet in Battle and other players will be able to see it (and crash from it - Normally, the game prevents starting other players Bullets in Battle if the kart bit is received).

This code prevents these items from being delimited by checking if the received dragged item is one of these mentioned above, if it is, it will be replaced with no item.

<details>
<summary>NTSC-U</summary>

```
C2788940 00000006
7C7F1B78 2C1F0004
4182001C 2C1F0005
41820014 2C1F0008
41800010 2C1F000F
41810008 3BE00014
60000000 00000000
```
</details>

<details>
<summary>PAL</summary>

```
C279194C 00000006
7C7F1B78 2C1F0004
4182001C 2C1F0005
41820014 2C1F0008
41800010 2C1F000F
41810008 3BE00014
60000000 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

```
C2790FB8 00000006
7C7F1B78 2C1F0004
4182001C 2C1F0005
41820014 2C1F0008
41800010 2C1F000F
41810008 3BE00014
60000000 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

```
C277FD0C 00000006
7C7F1B78 2C1F0004
4182001C 2C1F0005
41820014 2C1F0008
41800010 2C1F000F
41810008 3BE00014
60000000 00000000
```
</details>

[ASM source](source.s)