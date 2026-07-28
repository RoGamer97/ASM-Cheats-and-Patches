## Warp Kart to TestStart Points

Reimplements the non-functional debug Warp Kart to TestStart Point feature from the debug build in the retail version.

TestStart points are objects placed across many tracks that developers used to warp karts for testing purposes.

Hold `Minus` and push `Right Stick Left/Right` to warp to the previous/next TestStart point, if the course has at least one. Keeping these buttons held down will cause the kart to stay floating on the TestStart point until released.

Does not work online.

The ASM source code can be found [here](source.s).