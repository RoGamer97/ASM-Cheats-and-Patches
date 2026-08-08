## Free Camera Toolkit

A toolkit including Free Camera and related features.

Free Camera is the game's built-in debug camera provided by Nintendo's AGL library. This patch enables it and extends it with additional features.

---

### Free Camera

Hold `ZR` and press `D-Pad Up` to toggle Free Camera.

When enabled, you can freely move the camera anywhere. The HUD is hidden and game inputs are disabled.

#### Controls
`Left Stick`: Rotate Camera

`Right Stick`: Move Camera
`A`: Move Camera Up

`B`: Move Camera Down

`X`: Zoom In / Decrease Movement Speed

`Y`: Zoom Out / Increase Movement Speed

`L`: Twist Camera Left

`R`: Twist Camera Right

`L and R`: Reset Camera Twist

The features below can only be performed when in Free Camera.

#### Freeze Camera
Hold `ZR` and press `D-Pad Down` to freeze the camera in place. While enabled, game inputs are re-enabled.

#### Warp Camera to Kart

Hold `ZR` and press `Left Stick In` to warp the camera to the kart's location.

#### Warp Kart to Camera

Hold `ZR` and press `Right Stick In` to warp the kart to the camera's location.

After warping, the kart ignores checkpoint boundaries until it lands.

---

### Freeze Game with Frame Advance

Hold `ZR` and press `D-Pad Right` to toggle Freeze Game.

While the game is frozen, Free Camera and its features remain functional.

Press `D-Pad Right` to advance one frame.


The ASM source code can be found [here](source.s).