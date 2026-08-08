## Test Tracks

To load the Test Tracks, you need both the patch and the track files added to the game. The tracks will be available in the Debug Menu under the "Test" course list.

- **For emulator**: Paste the "Course" folder into the `romfs mods` directory.
- **For console**: Since adding these files directly crashes Atmosphere, you’ll need to modify the game NSP to include the track files. Note that I will not distribute my modified NSP.

---

### test_Customizer

This track is used in the Customizer scene. While we never had the files for this track, the game has a skybox for it. Based on the skybox and the fact that the Customizer scene spawns at 0,0,0, it's likely this track has no model and is just the "Gu_Menu" with the "VRCustomizer" skybox. This is a recreation of the track, and this is **VERY LIKELY** how it looks.

To load this track:
1. Load the track in VS mode.
2. Then, load the Customizer scene.

The "No Customizer Crash" patch I made is already included in the Test Tracks patches.

---

### test_DanceFloor

A track found in the Prototype and early versions of *Deluxe*, which only includes a lighting environment file. I decided to include it, even though it has no collision, model, or mapping file. It will load the Mario Circuit track, but with the *test_DanceFloor* lighting environment.

---

### test_WiFiTest1

This track was found in the Kiosk Demo version of *Mario Kart 8* on Wii U. The *MK8DX* port of this track was made by CallyHam, with crash and particle fixes by me. The original version had 2 laps (since all Kiosk Demo tracks were 2 laps), but this version is set to 3 laps.

By default, this course is loaded online if the room has an unknown variable set to true (likely part of a Debug Menu script or something set via Squirrel). You can use the patch I made to remove this variable check so it will always load the track online (everyone in the room must use the patch to play this track).

Code to remove the variable check:

005FD364 00000000

You can create an IPS patch or use this as an EdiZon code by adding `04000000` before the code.

---

The tracks can be played in both Race and Battle modes.

---

For more information about test tracks, visit https://tcrf.net/Proto:Mario_Kart_8_Deluxe#Test_Tracks

For additional patches, read https://tcrf.net/Proto:Mario_Kart_8_Deluxe/Patches

---