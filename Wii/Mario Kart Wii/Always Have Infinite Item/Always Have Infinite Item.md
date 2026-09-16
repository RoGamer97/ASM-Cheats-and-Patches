## Always Have Infinite Item

Allows choosing an item to always have (infinite).

There are two versions of the code:

# Local Player Only

Only affects you and other local players in Multiplayer.

<details>
<summary>NTSC-U</summary>

Replace XX with desired item:

Green Shell = 00  
Red Shell = 01  
Banana = 02  
Fake Item Box = 03  
Mushroom = 04  
Triple Mushroom = 05  
Bob-omb = 06  
Blue Shell = 07  
Lightning = 08  
Star = 09  
Golden Mushroom = 0A  
Mega Mushroom = 0B  
Blooper = 0C  
POW Block = 0D  
Cloud = 0E  
Bullet Bill = 0F  
Triple Green Shell = 10  
Triple Red Shell = 11  
Triple Banana = 12  

```
C278E958 0000000D
7C7C1B78 809D0000
80840004 80840014
70840002 4182004C
807D008C 2C030014
40820040 807D0058
2C030000 41820018
387D0054 3D80807A
618CBB78 7D8903A6
4E800421 387D0088
388000XX 38A00000
3D80807A 618CDEE0
7D8903A6 4E800421
A0BC002C 00000000
```
</details>

<details>
<summary>PAL</summary>

Replace XX with desired item:

Green Shell = 00  
Red Shell = 01  
Banana = 02  
Fake Item Box = 03  
Mushroom = 04  
Triple Mushroom = 05  
Bob-omb = 06  
Blue Shell = 07  
Lightning = 08  
Star = 09  
Golden Mushroom = 0A  
Mega Mushroom = 0B  
Blooper = 0C  
POW Block = 0D  
Cloud = 0E  
Bullet Bill = 0F  
Triple Green Shell = 10  
Triple Red Shell = 11  
Triple Banana = 12  

```
C2797964 0000000D
7C7C1B78 809D0000
80840004 80840014
70840002 4182004C
807D008C 2C030014
40820040 807D0058
2C030000 41820018
387D0054 3D80807B
618CA5D8 7D8903A6
4E800421 387D0088
388000XX 38A00000
3D80807B 618CC940
7D8903A6 4E800421
A0BC002C 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

Replace XX with desired item:

Green Shell = 00  
Red Shell = 01  
Banana = 02  
Fake Item Box = 03  
Mushroom = 04  
Triple Mushroom = 05  
Bob-omb = 06  
Blue Shell = 07  
Lightning = 08  
Star = 09  
Golden Mushroom = 0A  
Mega Mushroom = 0B  
Blooper = 0C  
POW Block = 0D  
Cloud = 0E  
Bullet Bill = 0F  
Triple Green Shell = 10  
Triple Red Shell = 11  
Triple Banana = 12  

```
C2796FD0 0000000D
7C7C1B78 809D0000
80840004 80840014
70840002 4182004C
807D008C 2C030014
40820040 807D0058
2C030000 41820018
387D0054 3D80807B
618C9C44 7D8903A6
4E800421 387D0088
388000XX 38A00000
3D80807B 618CBFAC
7D8903A6 4E800421
A0BC002C 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

Replace XX with desired item:

Green Shell = 00  
Red Shell = 01  
Banana = 02  
Fake Item Box = 03  
Mushroom = 04  
Triple Mushroom = 05  
Bob-omb = 06  
Blue Shell = 07  
Lightning = 08  
Star = 09  
Golden Mushroom = 0A  
Mega Mushroom = 0B  
Blooper = 0C  
POW Block = 0D  
Cloud = 0E  
Bullet Bill = 0F  
Triple Green Shell = 10  
Triple Red Shell = 11  
Triple Banana = 12  

```
C2785D24 0000000D
7C7C1B78 809D0000
80840004 80840014
70840002 4182004C
807D008C 2C030014
40820040 807D0058
2C030000 41820018
387D0054 3D80807A
618C8998 7D8903A6
4E800421 387D0088
388000XX 38A00000
3D80807A 618CAD00
7D8903A6 4E800421
A0BC002C 00000000
```
</details>

# Everyone

Affects everyone (local players and CPUs). You can choose what item each player/CPU has, and even choose for that player/CPU to not be affected by the code.

<details>
<summary>NTSC-U</summary>

Replace values with desired item for that player/CPU:

LL: Player 1 (You)  
NN: Player 2/CPU 1  
PP: Player 3/CPU 2  
QQ: Player 4/CPU 3  
RR: CPU 4  
SS: CPU 5  
TT: CPU 6  
UU: CPU 7  
VV: CPU 8  
XX: CPU 9  
YY: CPU 10  
ZZ: CPU 11  

Green Shell = 00  
Red Shell = 01  
Banana = 02  
Fake Item Box = 03  
Mushroom = 04  
Triple Mushroom = 05  
Bob-omb = 06  
Blue Shell = 07  
Lightning = 08  
Star = 09  
Golden Mushroom = 0A  
Mega Mushroom = 0B  
Blooper = 0C  
POW Block = 0D  
Cloud = 0E  
Bullet Bill = 0F  
Triple Green Shell = 10  
Triple Red Shell = 11  
Triple Banana = 12  
Not affected by the code = 14  

```
C278E958 0000000E
7C7C1B78 48000011
LLNNPPQQ RRSSTTUU
VVXXYYZZ 7C8802A6
7C84D8AE 2C040014
41820048 807D008C
2C030014 4082003C
387D0088 38A00000
3D80807A 618CDEE0
7D8903A6 4E800421
807D0058 2C030000
41820018 387D0054
3D80807A 618CBB78
7D8903A6 4E800421
A0BC002C 00000000
```
</details>

<details>
<summary>PAL</summary>

Replace values with desired item for that player/CPU:

LL: Player 1 (You)  
NN: Player 2/CPU 1  
PP: Player 3/CPU 2  
QQ: Player 4/CPU 3  
RR: CPU 4  
SS: CPU 5  
TT: CPU 6  
UU: CPU 7  
VV: CPU 8  
XX: CPU 9  
YY: CPU 10  
ZZ: CPU 11  

Green Shell = 00  
Red Shell = 01  
Banana = 02  
Fake Item Box = 03  
Mushroom = 04  
Triple Mushroom = 05  
Bob-omb = 06  
Blue Shell = 07  
Lightning = 08  
Star = 09  
Golden Mushroom = 0A  
Mega Mushroom = 0B  
Blooper = 0C  
POW Block = 0D  
Cloud = 0E  
Bullet Bill = 0F  
Triple Green Shell = 10  
Triple Red Shell = 11  
Triple Banana = 12  
Not affected by the code = 14  

```
C2797964 0000000E
7C7C1B78 48000011
LLNNPPQQ RRSSTTUU
VVXXYYZZ 7C8802A6
7C84D8AE 2C040014
41820048 807D008C
2C030014 4082003C
387D0088 38A00000
3D80807B 618CC940
7D8903A6 4E800421
807D0058 2C030000
41820018 387D0054
3D80807B 618CA5D8
7D8903A6 4E800421
A0BC002C 00000000
```
</details>

<details>
<summary>NTSC-J</summary>

Replace values with desired item for that player/CPU:

LL: Player 1 (You)  
NN: Player 2/CPU 1  
PP: Player 3/CPU 2  
QQ: Player 4/CPU 3  
RR: CPU 4  
SS: CPU 5  
TT: CPU 6  
UU: CPU 7  
VV: CPU 8  
XX: CPU 9  
YY: CPU 10  
ZZ: CPU 11  

Green Shell = 00  
Red Shell = 01  
Banana = 02  
Fake Item Box = 03  
Mushroom = 04  
Triple Mushroom = 05  
Bob-omb = 06  
Blue Shell = 07  
Lightning = 08  
Star = 09  
Golden Mushroom = 0A  
Mega Mushroom = 0B  
Blooper = 0C  
POW Block = 0D  
Cloud = 0E  
Bullet Bill = 0F  
Triple Green Shell = 10  
Triple Red Shell = 11  
Triple Banana = 12  
Not affected by the code = 14  

```
C2796FD0 0000000E
7C7C1B78 48000011
LLNNPPQQ RRSSTTUU
VVXXYYZZ 7C8802A6
7C84D8AE 2C040014
41820048 807D008C
2C030014 4082003C
387D0088 38A00000
3D80807B 618CBFAC
7D8903A6 4E800421
807D0058 2C030000
41820018 387D0054
3D80807B 618C9C44
7D8903A6 4E800421
A0BC002C 00000000
```
</details>

<details>
<summary>NTSC-K</summary>

Replace values with desired item for that player/CPU:

LL: Player 1 (You)  
NN: Player 2/CPU 1  
PP: Player 3/CPU 2  
QQ: Player 4/CPU 3  
RR: CPU 4  
SS: CPU 5  
TT: CPU 6  
UU: CPU 7  
VV: CPU 8  
XX: CPU 9  
YY: CPU 10  
ZZ: CPU 11  

Green Shell = 00  
Red Shell = 01  
Banana = 02  
Fake Item Box = 03  
Mushroom = 04  
Triple Mushroom = 05  
Bob-omb = 06  
Blue Shell = 07  
Lightning = 08  
Star = 09  
Golden Mushroom = 0A  
Mega Mushroom = 0B  
Blooper = 0C  
POW Block = 0D  
Cloud = 0E  
Bullet Bill = 0F  
Triple Green Shell = 10  
Triple Red Shell = 11  
Triple Banana = 12  
Not affected by the code = 14  

```
C2785D24 0000000E
7C7C1B78 48000011
LLNNPPQQ RRSSTTUU
VVXXYYZZ 7C8802A6
7C84D8AE 2C040014
41820048 807D008C
2C030014 4082003C
387D0088 38A00000
3D80807A 618CAD00
7D8903A6 4E800421
807D0058 2C030000
41820018 387D0054
3D80807A 618C8998
7D8903A6 4E800421
A0BC002C 00000000
```
</details>

[ASM source](source.s)