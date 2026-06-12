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

Read the _Windows_ notes below first, with these adjustments:

- Wine can be used to run the NoCEG tool, e.g.

  ```
  cd ~/.local/share/Steam/steamapps/common/Sid\ Meier\'s\ Civilization\ V/

  cp CivilizationV_DX11.exe CivilizationV_DX11.exe.bak

  wine noceg_signatures.exe CivilizationV_DX11.exe

  # 👉 Use the same Proton version as configured in Steam or just run the game from Steam
  STEAM_COMPAT_DATA_PATH="/home/$USER/.local/share/Steam/steamapps/compatdata/8930/" STEAM_COMPAT_CLIENT_INSTALL_PATH="/home/$USER/.local/share/Steam" "/home/$USER/.local/share/Steam/steamapps/common/Proton 9.0 (Beta)/proton" waitforexitandrun CivilizationV_DX11.exe

  wine noceg_patcher.exe CivilizationV_DX11.exe

  cp CivilizationV_DX11_noceg.exe CivilizationV_DX11.exe
  ```

- Once the binary is patched with NoCEG, you can apply the cheevos patch like this:

  ```
  sed -i 's/SELECT ModID from Mods where Activated = 1/SELECT ModID from Mods where Activated = 2/' "/home/$USER/.steam/steam/steamapps/common/Sid Meier's Civilization V/CivilizationV_DX11.exe"
  ```

#### macOS

⚠️ This is unconfirmed; please [report](https://github.com/bmaupin/civ5-cheevos-with-mods/issues/) if it's working for you

Open a terminal and run this command:

```
sed -i 's/SELECT ModID from Mods where Activated = 1/SELECT ModID from Mods where Activated = 2/' "/Users/$USER/Library/Application Support/Steam/steamapps/common/Sid Meier's Civilization V/Civilization V.app/Contents/MacOS/Civilization V"
```

#### Windows

⚠️ This is unconfirmed; please [report](https://github.com/bmaupin/civ5-cheevos-with-mods/issues/) if it's working for you

👉 If you're using [Vox Populi](https://github.com/LoneGazebo/Community-Patch-DLL) you shouldn't need this patch; instead to enable achievements edit `MODS\(1) Community Patch\Database Changes\NewCustomModOptions.xml` and set `ENABLE_ACHIEVEMENTS` to `1` ([source](https://github.com/LoneGazebo/Community-Patch-DLL/issues/12965#issuecomment-4410197668))

To install the patch:

1. Follow the steps here to remove Steam Custom Executable Generation (CEG): [https://github.com/iArtorias/noceg](https://github.com/iArtorias/noceg)
   - Run it on `CivilizationV.exe` for the DirectX 9 version of the game
   - Run it on `CivilizationV_DX11.exe` for the DirectX 10/11 version of the game

1. Paste these commands in PowerShell and then press Enter ([source](https://stackoverflow.com/a/73791858/399105)):

   ⓘ It will take a minute or so to run; wait until it says "Patch complete"

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

   (Replace `CivilizationV_DX11.exe` with `CivilizationV.exe` for the DirectX 9 version of the game)

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

⚠️ This is unconfirmed; please [report](https://github.com/bmaupin/civ5-cheevos-with-mods/issues/) if it's working for you

1. Follow the steps here to remove Steam Custom Executable Generation (CEG): [https://github.com/iArtorias/noceg](https://github.com/iArtorias/noceg)
   - Run it on `CivilizationBE_DX11.exe` for the DirectX 11 version of the game
   - Run it on `CivilizationBE_Mantle.exe` for the Mantle version of the game

1. Paste these commands in PowerShell and then press Enter ([source](https://stackoverflow.com/a/73791858/399105)):

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
   ```

   (Replace `CivilizationBE_DX11.exe` with `CivilizationBE_Mantle.exe` for the Mantle version of the game)

## Uninstall patch

To uninstall this patch:

1. Open Steam and go to the game in your library

1. Right-click on the name of the game on the left > _Properties_

1. _Installed Files_ > _Verify integrity of game files_

## How the patch works

See [docs/details.md](docs/details.md)
