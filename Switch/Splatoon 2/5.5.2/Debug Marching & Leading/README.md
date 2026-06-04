## Debug Marching & Leading

Reimplements the Debug Marching and Debug Leading features from the debug build in retail.

### Debug Marching 
Every player will copy your movements and actions, making you control everyone.

### Debug Leading
Every player walks to follow you and stops when they're close enough. They will also copy your actions.

---

Hold `Minus` and push `Right Stick Up` to change the mode (`Debug Marching -> Debug Leading -> Cancel`). You can cancel it by pressing `Minus` as well.

When enabled, a debug print is shown on-screen. You can disable it using the `Disable Debug Text Draw` patch.

If having issues with .pchtxt on console, please use .ips instead!

The ASM source code can be found [here](source.s).