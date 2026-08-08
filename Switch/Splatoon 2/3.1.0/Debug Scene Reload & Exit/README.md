## Debug Scene Reload & Exit

Reimplements the Debug Scene Reload & Exit feature from the debug build in retail.

Allows you to reload or exit a scene.

`L and D-Pad Up`: Short Reload; Resets the scene actors like objects, ink and a few other elements, but not players and timer.

`L and D-Pad Down`: Short Full Reload; Immediately resets the entire scene and everything else, as if you just loaded in.
 
`Hold L and D-Pad Up`: Full Exit; Exits the scene and goes to DbgSetting (Debug Menu) - Must use [Oatmeal's Debug Menu patches](https://github.com/OatmealDome/Splatoon-2-Debug-Patches/tree/master/src).
 
`Hold L and D-Pad Down`: Long Full Reload; Exits the scene and reenters it.

If you experience issues building from .pchtxt on console, use .ips instead.

[ASM source](source.s)