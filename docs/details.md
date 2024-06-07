# Details

## DirectX 11

#### How the patch works

The game stores mod information in an SQLite database, which it then queries to see which mods are enabled; achivements are only allowed for mods that come with the game or its DLC.

This is the query that is used to determine which mods are activated:

```
SELECT ModID from Mods where Activated = 1
```

Because SQLite doesn't have a boolean type, the mod activation status is stored as an integer with a value of `0` if the mod is not activated and `1` if the mod is activated.

This patch changes the query to:

```
SELECT ModID from Mods where Activated = 2
```

As a result, the query will never return any results and so the game will always think that there are no mods enabled.

Thankfully the query is only used for this one purpose, so modifying it doesn't break anything else in the game.

#### Install the DirectX 11 patch on Windows

⚠️ This doesn't seem to work, which is why these notes were moved out of the way (https://github.com/bmaupin/civ5-cheevos-with-mods/issues/1)

Paste these commands in PowerShell and then press Enter ([source](https://stackoverflow.com/a/73791858/399105)):

ⓘ It will take a minute or so to run; wait until it says "Patch complete."

```
function Replace-ContentInFile {
    param (
        [string]$FilePath
    )
    $data = Get-Content -Encoding Byte -ReadCount 0 $FilePath
    $dataAsHexString = [BitConverter]::ToString($data)
    $search = 'SELECT ModID from Mods where Activated = 1'
    $replacement = 'SELECT ModID from Mods where Activated = 2'
    $searchAsHexString = [BitConverter]::ToString([Text.Encoding]::UTF8.GetBytes($search))
    $replaceAsHexString = [BitConverter]::ToString([Text.Encoding]::UTF8.GetBytes($replacement))
    $dataAsHexString = $dataAsHexString.Replace($searchAsHexString, $replaceAsHexString)
    $modifiedData = [byte[]] ($dataAsHexString -split '-' -replace '^', '0x')
    Set-Content -Encoding Byte $FilePath -Value $modifiedData
    Write-Host "Patch complete"
}
Replace-ContentInFile -FilePath 'C:\Program Files (x86)\Steam\steamapps\common\Sid Meier''s Civilization V\CivilizationV_DX11.exe'
```

## DirectX 9 patch

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
