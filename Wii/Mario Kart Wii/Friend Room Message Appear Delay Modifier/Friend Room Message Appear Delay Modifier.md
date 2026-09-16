## Friend Room Message Appear Delay Modifier

Allows you to modify the message appear delay in Friend Rooms.

It is possible to remove the delay, so new messages will always appear even if a message just appeared. Note that this is CLIENTSIDED, meaning others will still have the delay, and you will see other people's messages with modified delay on your end.

<details>
<summary>NTSC-U</summary>

XX: Seconds in Frames (Original is 0xB4 -> 180 frames -> 3 seconds)

```
0462AE4C 2C0000XX
```
</details>

<details>
<summary>PAL</summary>

XX: Seconds in Frames (Original is 0xB4 -> 180 frames -> 3 seconds)

```
045DA8D8 2C0000XX
```
</details>

<details>
<summary>NTSC-J</summary>

XX: Seconds in Frames (Original is 0xB4 -> 180 frames -> 3 seconds)

```
045DA1B4 2C0000XX
```
</details>

<details>
<summary>NTSC-K</summary>

XX: Seconds in Frames (Original is 0xB4 -> 180 frames -> 3 seconds)

```
045C8A74 2C0000XX
```
</details>
