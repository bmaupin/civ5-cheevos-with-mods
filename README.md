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

1. Run the patch script:

   ```
   ./scripts/apply-patch.sh "/home/$USER/.steam/steam/steamapps/common/Sid Meier's Civilization V/CivilizationV.exe"
   ```

1. When playing the game, choose DirectX 9 (unfortunately the patch doesn't work for DirectX 11)

#### macOS

⚠️ This is untested; if anyone tests it please [create a new issue](https://github.com/bmaupin/civ5-cheevos-with-mods/issues) and I'll update this

Open a terminal and run this command:

```
sed -i 's/SELECT ModID from Mods where Activated = 1/SELECT ModID from Mods where Activated = 2/' "/Users/$USER/Library/Application Support/Steam/steamapps/common/Sid Meier's Civilization V/Civilization V.app/Contents/MacOS/Civilization V"
```

#### Windows

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

⚠️ This is untested; if anyone tests it please [create a new issue](https://github.com/bmaupin/civ5-cheevos-with-mods/issues) and I'll update this

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
