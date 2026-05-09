# Enable achievements with mods in Civ 5 or Beyond Earth

📌 [See my other Civ projects here](https://github.com/search?q=user%3Abmaupin+topic%3Acivilization&type=Repositories)

Patches to Sid Meier's Civilization V or Sid Meier's Civilization: Beyond Earth that enable achievements while playing with mods.

## Install patch (Civ 5)

#### Linux (native)

Open a terminal and run this command:

```
sed -i 's/SELECT ModID from Mods where Activated = 1/SELECT ModID from Mods where Activated = 2/' "/home/$USER/.steam/steam/steamapps/common/Sid Meier's Civilization V/Civ5XP"
```

#### Linux (Proton)

See the _Windows_ notes below. The Windows patch tool can be run using Wine, or you can also run this patch script which does the same thing: [scripts/apply-patch.sh](scripts/apply-patch.sh)

#### macOS

⚠️ This is untested

Open a terminal and run this command:

```
sed -i 's/SELECT ModID from Mods where Activated = 1/SELECT ModID from Mods where Activated = 2/' "/Users/$USER/Library/Application Support/Steam/steamapps/common/Sid Meier's Civilization V/Civilization V.app/Contents/MacOS/Civilization V"
```

#### Windows

⚠️ Steam Custom Executable Generation (CEG) will often prevent the patch from working. Here are some options for playing with achievements on Windows:

- Play with [Vox Populi](https://github.com/LoneGazebo/Community-Patch-DLL); to enable achievements edit `MODS\(1) Community Patch\Database Changes\NewCustomModOptions.xml` and set `ENABLE_ACHIEVEMENTS` to `1` ([source](https://github.com/LoneGazebo/Community-Patch-DLL/issues/12965#issuecomment-4410197668))
- You can try the patch below anyway; if it doesn't work, follow the steps to uninstall the patch and then try again as sometimes it seems to work and other times it doesn't

To install the patch:

1. Download the patch tool from [Releases](https://github.com/bmaupin/civ5-cheevos-with-mods/releases)

1. Run the patch tool, e.g.

   ```
   patchciv.exe 'C:\Program Files (x86)\Steam\steamapps\common\Sid Meier''s Civilization V\CivilizationV.exe'
   ```

1. When playing the game, choose DirectX 9 (unfortunately the patch doesn't work for DirectX 11)

## Install patch (Beyond Earth)

#### Linux (native)

Install the patch to fix the crash when playing with mods here: [https://github.com/bmaupin/civ-be-linux-fixes](https://github.com/bmaupin/civ-be-linux-fixes). It will also enable achievements with mods.

#### Linux (Proton)

Open a terminal and run these commands:

```
sed -i 's/SELECT ModID from Mods where Activated = 1/SELECT ModID from Mods where Activated = 2/' "/home/$USER/.steam/steam/steamapps/common/Sid Meier's Civilization Beyond Earth/CivilizationBE_DX11.exe"
sed -i 's/SELECT ModID from Mods where Activated = 1/SELECT ModID from Mods where Activated = 2/' "/home/$USER/.steam/steam/steamapps/common/Sid Meier's Civilization Beyond Earth/CivilizationBE_Mantle.exe"
```

#### Windows

⚠️ This is untested

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
Replace-ContentInFile -FilePath 'C:\Program Files (x86)\Steam\steamapps\common\Sid Meier''s Civilization Beyond Earth\CivilizationBE_DX11.exe'
Replace-ContentInFile -FilePath 'C:\Program Files (x86)\Steam\steamapps\common\Sid Meier''s Civilization Beyond Earth\CivilizationBE_Mantle.exe'
```

## Uninstall patch

To uninstall this patch:

1. Open Steam and go to the game in your library

1. Right-click on the name of the game on the left > _Properties_

1. _Installed Files_ > _Verify integrity of game files_

## How the patch works

See [docs/details.md](docs/details.md)
