# Details

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
