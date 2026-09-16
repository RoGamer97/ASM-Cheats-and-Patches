## Show Position in Live View

Makes it so the position tracker is visible in Live View. This is in CTGP-R. I found this on my own (with guidance of FKW's source code).

NOTE: There is a rare bug where when entering a Live View, the position isn't correct (example: Player is in 1st but it says they're in 7th). This happens because of how Live View works, since it doesn't start correctly on the finish line, checkpoints can break.

<details>
<summary>NTSC-U</summary>

```
046026FC 3860021A
```
</details>

<details>
<summary>PAL</summary>

```
046335B0 3860021A
```
</details>

<details>
<summary>NTSC-J</summary>

```
04632CFC 3860021A
```
</details>

<details>
<summary>NTSC-K</summary>

```
046219A8 3860021A
```
</details>