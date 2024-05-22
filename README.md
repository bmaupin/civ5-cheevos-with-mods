# Enable achievements with mods in Civ 5 or Beyond Earth

💡 [See my other Civ projects here](https://github.com/search?q=user%3Abmaupin+topic%3Acivilization&type=Repositories)

This is a patch to Sid Meier's Civilization V or Sid Meier's Civilization: Beyond Earth that enables achievements while playing with mods.

## Install patch (Civ 5)

#### Linux (native)

Open a terminal and run this command:

```
sed -i 's/SELECT ModID from Mods where Activated = 1/SELECT ModID from Mods where Activated = 2/' "/home/$USER/.steam/steam/steamapps/common/Sid Meier's Civilization V/Civ5XP"
```

#### Linux (Proton)

Open a terminal and run this command:

```
sed -i 's/SELECT ModID from Mods where Activated = 1/SELECT ModID from Mods where Activated = 2/' "/home/$USER/.steam/steam/steamapps/common/Sid Meier's Civilization V/CivilizationV_DX11.exe"
```

#### macOS

⚠️ This is untested

Open a terminal and run this command:

```
sed -i 's/SELECT ModID from Mods where Activated = 1/SELECT ModID from Mods where Activated = 2/' "/Users/$USER/Library/Application Support/Steam/steamapps/common/Sid Meier's Civilization V/Civilization V.app/Contents/MacOS/Civilization V"
```

#### Windows

Run this command in PowerShell:

```
(Get-Content 'C:\Program Files (x86)\Steam\steamapps\common\Sid Meier''s Civilization V\CivilizationV_DX11.exe') | ForEach-Object { $_ -replace 'SELECT ModID from Mods where Activated = 1', 'SELECT ModID from Mods where Activated = 2' } | Set-Content 'C:\Program Files (x86)\Steam\steamapps\common\Sid Meier''s Civilization V\CivilizationV_DX11.exe'
```

## Install patch (Beyond Earth)

#### Linux (native)

⚠️ Mod support for the native Linux version seems to be broken; use Proton instead.

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

## How the patch works

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
