# Enable achievements with mods in Civ 5 or Beyond Earth

💡 [See my other Civ projects here](https://github.com/search?q=user%3Abmaupin+topic%3Acivilization&type=Repositories)

This is a patch to Sid Meier's Civilization V or Sid Meier's Civilization: Beyond Earth that enables achievements while playing with mods.

For more information about the patch and how it works, see [docs/details.md](docs/details.md)

## Install patch (Civ 5)

#### Linux (native)

Open a terminal and run this command:

```
sed -i 's/SELECT ModID from Mods where Activated = 1/SELECT ModID from Mods where Activated = 2/' "/home/$USER/.steam/steam/steamapps/common/Sid Meier's Civilization V/Civ5XP"
```

#### Linux (Proton)

Use the provided patch script to patch the binaries, e.g.

```
./scripts/apply-patch.sh "/home/$USER/.steam/steam/steamapps/common/Sid Meier's Civilization V/CivilizationV.exe"
./scripts/apply-patch.sh "/home/$USER/.steam/steam/steamapps/common/Sid Meier's Civilization V/CivilizationV_DX11.exe"
./scripts/apply-patch.sh "/home/$USER/.steam/steam/steamapps/common/Sid Meier's Civilization V/CivilizationV_Tablet.exe"
```

#### macOS

⚠️ This is untested

Open a terminal and run this command:

```
sed -i 's/SELECT ModID from Mods where Activated = 1/SELECT ModID from Mods where Activated = 2/' "/Users/$USER/Library/Application Support/Steam/steamapps/common/Sid Meier's Civilization V/Civilization V.app/Contents/MacOS/Civilization V"
```

#### Windows

Run the provided patch script using WSL (Windows Subsystem for Linux), e.g.

```
./scripts/apply-patch.sh "/mnt/c/Program Files (x86)/Steam/steamapps/common/Sid Meier's Civilization V/CivilizationV.exe"
./scripts/apply-patch.sh "/mnt/c/Program Files (x86)/Steam/steamapps/common/Sid Meier's Civilization V/CivilizationV_DX11.exe"
./scripts/apply-patch.sh "/mnt/c/Program Files (x86)/Steam/steamapps/common/Sid Meier's Civilization V/CivilizationV_Tablet.exe"
```

## Install patch (Beyond Earth)

#### Linux (native)

Open a terminal and run this command:

```
sed -i 's/SELECT ModID from Mods where Activated = 1/SELECT ModID from Mods where Activated = 2/' "/home/$USER/.steam/steam/steamapps/common/Sid Meier's Civilization Beyond Earth/CivBE"
```

#### Linux (Proton)

Open a terminal and run these commands:

```
sed -i 's/SELECT ModID from Mods where Activated = 1/SELECT ModID from Mods where Activated = 2/' "/home/$USER/.steam/steam/steamapps/common/Sid Meier's Civilization Beyond Earth/CivilizationBE_DX11.exe"
sed -i 's/SELECT ModID from Mods where Activated = 1/SELECT ModID from Mods where Activated = 2/' "/home/$USER/.steam/steam/steamapps/common/Sid Meier's Civilization Beyond Earth/CivilizationBE_Mantle.exe"
```

#### Windows

Run these commands in PowerShell:

```
(Get-Content 'C:\Program Files (x86)\Steam\steamapps\common\Sid Meier''s Civilization Beyond Earth\CivilizationBE_DX11.exe') | ForEach-Object { $_ -replace 'SELECT ModID from Mods where Activated = 1', 'SELECT ModID from Mods where Activated = 2' } | Set-Content 'C:\Program Files (x86)\Steam\steamapps\common\Sid Meier''s Civilization Beyond Earth\CivilizationBE_DX11.exe'
(Get-Content 'C:\Program Files (x86)\Steam\steamapps\common\Sid Meier''s Civilization Beyond Earth\CivilizationBE_Mantle.exe') | ForEach-Object { $_ -replace 'SELECT ModID from Mods where Activated = 1', 'SELECT ModID from Mods where Activated = 2' } | Set-Content 'C:\Program Files (x86)\Steam\steamapps\common\Sid Meier''s Civilization Beyond Earth\CivilizationBE_Mantle.exe'
```

## Uninstall patch

To uninstall this patch:

1. Open Steam and go to the game in your library

1. Right-click on the name of the game on the left > _Properties_

1. _Installed Files_ > _Verify integrity of game files_
