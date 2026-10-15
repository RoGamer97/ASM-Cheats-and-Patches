## Enhanced VS Pause Menu

Makes offline singleplayer VS use the Time Trials pause menu, allowing you to restart, change course, and change characters.

Note that changing characters will also reselect CPU characters, teams, and mode settings, but points and current race count will not be affected.

This patch disables the course intro, as it crashes the game when trying to restart.

Note that there is a bug where, when setting Courses option to "In Order" or "Random" in VS settings menu, the 2nd course will be the same one as the 1st. Side effect of disable course intro.

[ASM source](source.s)