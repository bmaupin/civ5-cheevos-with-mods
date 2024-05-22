ⓘ This directory contains patch tools for the DirectX 9 version of the game, which there shouldn't be any need for these days.

#### Linux (Proton)

Use the provided patch script to patch the binaries, e.g.

```
./scripts/apply-patch.sh "/home/$USER/.steam/steam/steamapps/common/Sid Meier's Civilization V/CivilizationV.exe"
```

#### Windows

1. Build the patch tool

   ```
   ./scripts/build.sh
   ```

1. Run the patch tool, e.g.

   ```
   patch-civ5.exe 'C:\Program Files (x86)\Steam\steamapps\common\Sid Meier''s Civilization V\CivilizationV.exe'
   ```

Alternatively, the patch script can be run using WSL (Windows Subsystem for Linux), e.g.

```
./scripts/apply-patch.sh "/mnt/c/Program Files (x86)/Steam/steamapps/common/Sid Meier's Civilization V/CivilizationV.exe"
```

#### How this patch works

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
