## Boost Sound Modifier

Changes the boost sound. Depending on the sound, it will not obey the limit and it will play multiple sounds at once according to how many boosts are happening (boost pannel, spamming mushrooms) etc.

Most kart sound effects can be replaced with this code. 

<details>
<summary>NTSC-U</summary>

XXXX: Revo Sound Index ID (in Hex. Look in revo_kart.brsar with BrawlBox/Crate). Example: 0110 is Star Hit Barrier

```
C2701950 00000003
2C04019C 40820008
3880XXXX 93E1002C
60000000 00000000
```
</details>

<details>
<summary>PAL</summary>

XXXX: Revo Sound Index ID (in Hex. Look in revo_kart.brsar with BrawlBox/Crate). Example: 0110 is Star Hit Barrier

```
C27082F4 00000003
2C04019C 40820008
3880XXXX 93E1002C
60000000 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

XXXX: Revo Sound Index ID (in Hex. Look in revo_kart.brsar with BrawlBox/Crate). Example: 0110 is Star Hit Barrier

```
C2707960 00000003
2C04019C 40820008
3880XXXX 93E1002C
60000000 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

XXXX: Revo Sound Index ID (in Hex. Look in revo_kart.brsar with BrawlBox/Crate). Example: 0110 is Star Hit Barrier

```
C26F669C 00000003
2C04019C 40820008
3880XXXX 93E1002C
60000000 00000000
```
</details>

[ASM source](source.s)