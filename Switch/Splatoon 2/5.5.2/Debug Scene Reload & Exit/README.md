## Debug Scene Reload & Exit

Reimplements the Debug Scene Reload & Exit feature from the debug build in retail.

Allows you to reload or exit a scene.

`L and D-Pad Up`: Short Reload; Resets the scene actors like objects, ink and a few other elements, but not players and timer.

`L and D-Pad Down`: Short Full Reload; Immediately resets the entire scene and everything else, as if you just loaded in.
 
`Hold L and D-Pad Down`: Long Full Reload; Exits the scene and reenters it.

If you experience issues building from .pchtxt on console, use .ips instead.

The ASM source code can be found [here](source.s).