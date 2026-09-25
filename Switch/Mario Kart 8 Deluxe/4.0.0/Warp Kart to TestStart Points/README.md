## Warp Kart to TestStart Points

Reimplements the non-functional Warp Kart to TestStart Point debug feature from the debug build in retail.

TestStart points are objects placed across many tracks that developers used to warp karts for testing purposes.

Hold `Minus` and push `Right Stick Left/Right` to warp to TestStart points, if the course has at least one. 

Keeping the buttons held after warping causes the kart to float at the TestStart point.

Does not work online by design.

[ASM source](source.s)