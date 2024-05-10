# Notes

#### Patch details

The Civ 5 binary contains a function that checks whether UUIDs of activated mods in the game database match a list of UUIDs hard-coded into the binary in order to determine if achievements should be enabled. The hard-coded UUIDs seem to correspond to UUIDs of mods that the game and its DLC come with, since achievements should be enabled for those mods but not other mods.

1. Search the binary for `SELECT ModID from Mods where Activated = 1`
1. There should be a line calling strnicmp comparing the UUIDs hard-coded into the executable (UUIDs of mods that are allowed to have achievements) with the UUIDs of mods in the database
1. The next line compares the result of the previous line by testing whether the value in the EAX register is 0 (strnicmp returns 0 if there's a match) and sets the zero flag (ZF)

   - `85 c0`: TEST EAX, EAX

1. The next line breaks the loop if ZF is set by jumping back to the start of the loop

   - `74 b6`: JZ

1. Change the TEST instruction to CMP instead to set ZF so that the break will always happen, e.g.

   - `3b C0`: CMP EAX, EAX
