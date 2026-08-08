## Debug Camera

Restores the Debug Camera enable toggle and assigns buttons for Turbo and Super Turbo movement speeds.

There are two Debug Camera modes left in the game:

### Debug World Camera

Free fly camera that allows you to move the camera freely anywhere. Pressing `Plus` drops the car to the camera's location.

Normally, there are buttons for Turbo and Super Turbo movement speeds, which make the camera move faster. However, these buttons are not assigned in the Wii version.

### Debug Car Camera
Also known as Orbit Camera. Camera stays locked on the car, allowing you to rotate around the car and zoom.

---

The game still contains both camera modes in retail, but the button handler to enable them is removed.

This code restores the toggle, allowing `Minus` to enter Debug Camera mode, and assigns buttons for the Debug World Camera's Turbo and Super Turbo movement speeds.

Note that you must be using a Wiimote and Nunchuk on port 2 (Wiimote 2).

#### Controls:
`Minus`: Cycle camera mode

`D-Pad`: Move camera (Debug World Camera)

`Plus`: Drop car (Debug World Camera)

`A`: Move camera up (Debug World Camera)

`B`: Move camera down (Debug World Camera)

`C`: Move camera faster (Debug World Camera Turbo mode)

`Z`: Move camera way faster (Debug World Camera Super Turbo mode)

`Stick`: Rotate camera (both modes)

<details>
<summary>Show code</summary>

```
C20653E0 0000000D
38600000 38800000
3D80806F A16C3D82
71606000 41820018
716B2000 4082000C
38600001 48000008
38800001 906DC640
908DC644 A18C3D86
718C1000 41820020
38600001 3C808055
60847838 3D808006
618C5C30 7D8903A6
4E800421 809D0018
60000000 00000000
```
</details>

[ASM source](source.s)