## Invincibility Period Against Cars/Trucks Objects in All Slots

By default, getting hit by anything grants the player invincibility to the objects kart_truck and car_body for a short duration of time on Moonview Highway slot only. 

This code makes it this happens in all slots, so players will have the invincibility period against cars and trucks on custom tracks that are not on Moonview Highway slot.

This code MUST be used with two other codes: Slot Specific Objects Work in All Slots (pylon01, sunDS, FireSnake and begoman_spike) and Any Track Works on Moonview Highway Slot (Remove Slot Object & Material Requirements) - The second code is NOT necessary if using Pulsar as it has a fix for this issue.


<details>
<summary>NTSC-U</summary>

```
046C7A2C 3800000A
04813E54 38000000
```
</details>

<details>
<summary>PAL</summary>

```
046D686C 3800000A
04827968 38000000
```
</details>

<details>
<summary>NTSC-J</summary>

```
046D5ED8 3800000A
04826FD4 38000000
```
</details>

<details>
<summary>NTSC-K</summary>

```
046C4C14 3800000A
04815D28 38000000
```
</details>