## Statues/Posters Are Always/Never Mii Heads

Makes it so you can force if statues and posters will always have normal head or mii head. Posters and statues are separated, statues affect all tracks and some posters are shared with some tracks and some are individual courses. 
Because of this there are two versions of the code, one that will force all statues and specific posters to be what you want and the other version you can force it on each individual track. You can remove specific lines or modify lines to remove specific tracks, everything will be referenced below.
Before filling the values, read the information below the code.


# add hook, remake hook? update SS


### Code 1 (All statues and course specific posters)

<details>
<summary>NTSC-U</summary>

SS (Statues heads [Luigi Circuit, DK Summit, Daisy Circuit, Dry Dry Ruins, Block Plaza]):
00: Always normal statue heads
01: Always mii heads

LC (Luigi Circuit face signs):
00: Always Luigi head
01: Always mii head

XX (Toad Factory, Wario's Gold Mine, Koopa Cape face signs):
00: Always Toad/Wario/Koopa head
01: Always mii head

MH (Moonview Highway billboard poster):
00: Always Mario/Peach head
01: Always mii head

Remove line of specific track if you want it to have normal behavior (normal head when not mii, mii head when mii)

```
045243D0 38A000SS
0477CA78 380000LC
0477B86C 380000XX
0477BE0C 380000MH
```
</details>

<details>
<summary>PAL</summary>

SS (Statues heads [Luigi Circuit, DK Summit, Daisy Circuit, Dry Dry Ruins, Block Plaza]):
00: Always normal statue heads
01: Always mii heads

LC (Luigi Circuit face signs):
00: Always Luigi head
01: Always mii head

XX (Toad Factory, Wario's Gold Mine, Koopa Cape face signs):
00: Always Toad/Wario/Koopa head
01: Always mii head

MH (Moonview Highway billboard poster):
00: Always Mario/Peach head
01: Always mii head

Remove line of specific track if you want it to have normal behavior (normal head when not mii, mii head when mii)

```
04528844 38A000SS
047739C4 380000LC
047727B8 380000XX
04772D58 380000MH
```
</details>

<details>
<summary>NTSC-J</summary>

SS (Statues heads [Luigi Circuit, DK Summit, Daisy Circuit, Dry Dry Ruins, Block Plaza]):
00: Always normal statue heads
01: Always mii heads

LC (Luigi Circuit face signs):
00: Always Luigi head
01: Always mii head

XX (Toad Factory, Wario's Gold Mine, Koopa Cape face signs):
00: Always Toad/Wario/Koopa head
01: Always mii head

MH (Moonview Highway billboard poster):
00: Always Mario/Peach head
01: Always mii head

Remove line of specific track if you want it to have normal behavior (normal head when not mii, mii head when mii)

```
045281C4 38A000SS
04773030 380000LC
04771E24 380000XX
047723C4 380000MH
```
</details>

<details>
<summary>NTSC-K</summary>

SS (Statues heads [Luigi Circuit, DK Summit, Daisy Circuit, Dry Dry Ruins, Block Plaza]):
00: Always normal statue heads
01: Always mii heads

LC (Luigi Circuit face signs):
00: Always Luigi head
01: Always mii head

XX (Toad Factory, Wario's Gold Mine, Koopa Cape face signs):
00: Always Toad/Wario/Koopa head
01: Always mii head

MH (Moonview Highway billboard poster):
00: Always Mario/Peach head
01: Always mii head

Remove line of specific track if you want it to have normal behavior (normal head when not mii, mii head when mii)

```
04516868 38A000SS
04761D84 380000LC
04760B78 380000XX
04761118 380000MH
```
</details>

### Code 2 (Course specific statues and posters/signs)

<details>
<summary>NTSC-U</summary>

SS (Statues heads [Luigi Circuit, DK Summit, Daisy Circuit, Dry Dry Ruins, Block Plaza]):
00: Always normal statue heads
01: Always mii heads

LC (Luigi Circuit face signs):
00: Always Luigi head
01: Always mii head

TF (Toad Factory face sign):
00: Always Toad head
01: Always mii head

WG (Wario's Gold Mine face sign):
00: Always Wario head
01: Always mii head

KC (Koopa Cape face sign):
00: Always Koopa head
01: Always mii head

MH (Moonview Highway billboard poster):
00: Always Mario/Peach head
01: Always mii head

If you want specific statues/posters to behave normally (normal head when not mii, mii head when mii), replace these lines:
Luigi Circuit statue:  2C0C0008 40820008 to  2C0C0008 48000008
DK Summit statue: 40820008 386000SS to 48000008 386000SS
Daisy Circuit statues: 2C0C0009 40820008 to  2C0C0009 48000008
Dry Dry Ruins sphynx: 40820008 386000RS to 48000008 386000RS
Block Plaza statues:  2C0C0021 40820008 to 2C0C0021 48000008
Luigi Circuit or Moonview Highway posters: Remove line that ends with LC or MH
Toad Factory face sign: 2C0C0004 40820008 to  2C0C0004 48000008
Wario's Gold Mine face sign: 40820008 380000WG to 48000008 380000WG
Koopa Cape face sign: 2C0C000F 40820008 to  2C0C000F 48000008

```
C25243D4 0000000A
8063000C 3D80809C
818C8F68 818C0B68
2C0C0008 40820008
386000LS 2C0C0006
40820008 386000SS
2C0C0009 40820008
386000DS 2C0C000E
40820008 386000RS
2C0C0021 40820008
386000BS 00000000
0477CA78 380000LC
C277B86C 00000007
80030100 3D80809C
818C8F68 818C0B68
2C0C0004 40820008
380000TF 2C0C0007
40820008 380000WG
2C0C000F 40820008
380000KC 00000000
0477BE0C 380000MH
```
</details>

<details>
<summary>PAL</summary>

SS (Statues heads [Luigi Circuit, DK Summit, Daisy Circuit, Dry Dry Ruins, Block Plaza]):
00: Always normal statue heads
01: Always mii heads

LC (Luigi Circuit face signs):
00: Always Luigi head
01: Always mii head

TF (Toad Factory face sign):
00: Always Toad head
01: Always mii head

WG (Wario's Gold Mine face sign):
00: Always Wario head
01: Always mii head

KC (Koopa Cape face sign):
00: Always Koopa head
01: Always mii head

MH (Moonview Highway billboard poster):
00: Always Mario/Peach head
01: Always mii head

If you want specific statues/posters to behave normally (normal head when not mii, mii head when mii), replace these lines:
Luigi Circuit statue:  2C0C0008 40820008 to  2C0C0008 48000008
DK Summit statue: 40820008 386000SS to 48000008 386000SS
Daisy Circuit statues: 2C0C0009 40820008 to  2C0C0009 48000008
Dry Dry Ruins sphynx: 40820008 386000RS to 48000008 386000RS
Block Plaza statues:  2C0C0021 40820008 to 2C0C0021 48000008
Luigi Circuit or Moonview Highway posters: Remove line that ends with LC or MH
Toad Factory face sign: 2C0C0004 40820008 to  2C0C0004 48000008
Wario's Gold Mine face sign: 40820008 380000WG to 48000008 380000WG
Koopa Cape face sign: 2C0C000F 40820008 to  2C0C000F 48000008

```
C2528848 0000000A
8063000C 3D80809C
818CD728 818C0B68
2C0C0008 40820008
386000LS 2C0C0006
40820008 386000SS
2C0C0009 40820008
386000DS 2C0C000E
40820008 386000RS
2C0C0021 40820008
386000BS 00000000
047739C4 380000LC
C27727B8 00000007
80030100 3D80809C
818CD728 818C0B68
2C0C0004 40820008
380000TF 2C0C0007
40820008 380000WG
2C0C000F 40820008
380000KC 00000000
04772D58 380000MH
```
</details>

<details>
<summary>NTSC-J</summary>

SS (Statues heads [Luigi Circuit, DK Summit, Daisy Circuit, Dry Dry Ruins, Block Plaza]):
00: Always normal statue heads
01: Always mii heads

LC (Luigi Circuit face signs):
00: Always Luigi head
01: Always mii head

TF (Toad Factory face sign):
00: Always Toad head
01: Always mii head

WG (Wario's Gold Mine face sign):
00: Always Wario head
01: Always mii head

KC (Koopa Cape face sign):
00: Always Koopa head
01: Always mii head

MH (Moonview Highway billboard poster):
00: Always Mario/Peach head
01: Always mii head

If you want specific statues/posters to behave normally (normal head when not mii, mii head when mii), replace these lines:
Luigi Circuit statue:  2C0C0008 40820008 to  2C0C0008 48000008
DK Summit statue: 40820008 386000SS to 48000008 386000SS
Daisy Circuit statues: 2C0C0009 40820008 to  2C0C0009 48000008
Dry Dry Ruins sphynx: 40820008 386000RS to 48000008 386000RS
Block Plaza statues:  2C0C0021 40820008 to 2C0C0021 48000008
Luigi Circuit or Moonview Highway posters: Remove line that ends with LC or MH
Toad Factory face sign: 2C0C0004 40820008 to  2C0C0004 48000008
Wario's Gold Mine face sign: 40820008 380000WG to 48000008 380000WG
Koopa Cape face sign: 2C0C000F 40820008 to  2C0C000F 48000008

```
C25281C8 0000000A
8063000C 3D80809C
818CC788 818C0B68
2C0C0008 40820008
386000LS 2C0C0006
40820008 386000SS
2C0C0009 40820008
386000DS 2C0C000E
40820008 386000RS
2C0C0021 40820008
386000BS 00000000
04773030 380000LC
C2771E24 00000007
80030100 3D80809C
818CC788 818C0B68
2C0C0004 40820008
380000TF 2C0C0007
40820008 380000WG
2C0C000F 40820008
380000KC 00000000
047723C4 380000MH
```
</details>

<details>
<summary>NTSC-K</summary>

SS (Statues heads [Luigi Circuit, DK Summit, Daisy Circuit, Dry Dry Ruins, Block Plaza]):
00: Always normal statue heads
01: Always mii heads

LC (Luigi Circuit face signs):
00: Always Luigi head
01: Always mii head

TF (Toad Factory face sign):
00: Always Toad head
01: Always mii head

WG (Wario's Gold Mine face sign):
00: Always Wario head
01: Always mii head

KC (Koopa Cape face sign):
00: Always Koopa head
01: Always mii head

MH (Moonview Highway billboard poster):
00: Always Mario/Peach head
01: Always mii head

If you want specific statues/posters to behave normally (normal head when not mii, mii head when mii), replace these lines:
Luigi Circuit statue:  2C0C0008 40820008 to  2C0C0008 48000008
DK Summit statue: 40820008 386000SS to 48000008 386000SS
Daisy Circuit statues: 2C0C0009 40820008 to  2C0C0009 48000008
Dry Dry Ruins sphynx: 40820008 386000RS to 48000008 386000RS
Block Plaza statues:  2C0C0021 40820008 to 2C0C0021 48000008
Luigi Circuit or Moonview Highway posters: Remove line that ends with LC or MH
Toad Factory face sign: 2C0C0004 40820008 to  2C0C0004 48000008
Wario's Gold Mine face sign: 40820008 380000WG to 48000008 380000WG
Koopa Cape face sign: 2C0C000F 40820008 to  2C0C000F 48000008

```
C251686C 0000000A
8063000C 3D80809B
818CBD68 818C0B68
2C0C0008 40820008
386000LS 2C0C0006
40820008 386000SS
2C0C0009 40820008
386000DS 2C0C000E
40820008 386000RS
2C0C0021 40820008
386000BS 00000000
04761D84 380000LC
C2760B78 00000007
80030100 3D80809B
818CBD68 818C0B68
2C0C0004 40820008
380000TF 2C0C0007
40820008 380000WG
2C0C000F 40820008
380000KC 00000000
04761118 380000MH
```
</details>