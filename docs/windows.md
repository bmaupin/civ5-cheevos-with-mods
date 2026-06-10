# Windows patch

⚠️ This is preserved for reference but should no longer be needed with NoCEG

#### Build the Windows patch tool

```
./scripts/build.sh
```

#### How the patch works

Unfortunately modifying the database query in the DirectX 9 binary makes the game crash.

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
