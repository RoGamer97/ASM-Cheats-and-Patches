## Debug Item Cycler

Reimplements the Debug Item Cycler feature from the debug build in retail.

Allows cycling through every item.

Hold `R` and press `D-Pad Left/Right` to cycle to the previous or next item. Cycling to "No Item" clears your current item.

Press the item use button to give yourself the last item cycled to. No item will be given if you've never cycled or if the last item cycled to is "No Item".

Does not work in Time Trials, Bob-omb Blast, or online by design.

The ASM source code can be found [here](source.s).