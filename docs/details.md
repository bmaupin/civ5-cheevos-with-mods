# Details

#### Background

The game queries its local mod database to see which mods are enabled and only allows achievements for mods that come with the game or its DLC.

#### How the Linux patch works

The game stores mod information in an SQLite database. Because SQLite doesn't have a boolean type, the mod activation status is stored as an integer with a value of `0` if the mod is not activated and `1` if the mod is activated.

When the game is looking for activated mods, it searches for a value of `1`. The patch changes the query to instead search for a value of `2`, it will never return any results and so the game will always think that there are no mods enabled.

Thankfully the query is only used for this one purpose, so modifying it doesn't break anything else in the game.

#### How the Windows patch works

Unfortunately modifying the database query in the Windows binaries prevents the game from launching. Perhaps there is some kind of checksum in the binaries to prevent them from being modified.

Instead of modifying the query, the game logic itself is modified in a way so that achievements are always enabled even if mods are installed.

These are the steps used by the patch; see the patch file for more information:

1. Search the binary for the database query (`SELECT ModID from Mods where Activated = 1`) and get its memory address
1. Search the binary for the memory address of the query find where it's used in the game's logic
1. Not far after this, strnicmp is used to compare the UUIDs hard-coded into the executable (UUIDs of mods that are allowed to have achievements) with the UUIDs of mods in the database
1. Next, the zero flag is set if the value in the EAX register is 0 (which strnicmp will do if there's a match)

   - `85 c0`: TEST EAX, EAX

1. If the zero flag is set then a jump is made

   - `74 ...`: JZ ...

1. The patch changes the TEST instruction to CMP instead so that the zero flag will always be set and the break will always happen, e.g.

   - `3b C0`: CMP EAX, EAX
