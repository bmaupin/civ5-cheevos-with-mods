# Steam Custom Executable Generation (CEG)

## Info

Steam Custom Executable Generation (CEG) is a DRM used by Civ 5 and Beyond Earth as evidenced by the `cegpublickey` in their configurations:

- https://steamdb.info/app/8930/config/
- https://steamdb.info/app/65980/config/

This prevents the achievement patch from working.

Read more about CEG here: https://en.wikipedia.org/wiki/Steam_(service)#Software_delivery_and_maintenance

## Testing

#### Test without patch

1. Remove CivilizationV.exe
1. In Steam, go to Civilization V > Properties > Installed Files > Verify integrity of game files
1. Wait for CivilizationV.exe to be re-created
1. Notice the file size is 10596352
1. Do a checksum of the file
   - Checksum is `8e12c50692c18e2e828d18e9ba71fa66926ed5d4`
   - This matches the hash from https://steamdb.info/depot/8932/?show_hashes
1. Wait a few minutes, Steam will update the file
1. Notice the file size is 10602040
1. Notice the checksum has changed
   - The checksum will be different every time
   - Is this change due to CEG?
1. In Steam, click Play
1. Notice that Steam says "Updating executable"
1. While the game is playing, notice that the checksum has not changed
1. Exit the game and notice that the checksum has not changed
   - So maybe the previous change was CEG?

#### Test with patch

1. Repeat steps above
1. After the file is first downloaded (when filesize is still 10596352), apply one of the patches
1. Wait for the file to be updated
1. Note that the patch is no longer applied

## More details on CEG

#### Resources

- https://github.com/iArtorias/noceg
- https://github.com/Rattpak/CEG-Anti-Tamper-Analysis
- https://github.com/blackletum/csgo_test/blob/4cf3d205632fbafce3a210e38b71907065c8e2a6/src/common/CegClient.h

#### Process

1. Look for `AD DE 00 80` in binary (`0x8000DEAD`)
   - `0x160516`
   - Used in `UndefinedFunction_00561110`

## Proton

These commits were added to Proton 6.3.8 to fix CEG support:

- https://github.com/ValveSoftware/Proton/commit/fdc3651992b38ed2b316f92ccf7406f2ac88c005
- https://github.com/ValveSoftware/Proton/commit/7d37e79328434ba6de27dcbf35bb671e281d9627
- https://github.com/ValveSoftware/Proton/commit/f2ff463c085b022215141cf393df9d08e35a9247
- https://github.com/ValveSoftware/Proton/commit/5b7de85bdf76bf6dd894528f8046d624a2a5d6c0

## SQL query

- Query is at `00a70210`
- used at `0x0053ef52`
- Seems to be outside the code and addresses in noceg.json (therefor the parts of the code immediately protected by CEG), but my guess is that CEG is checksumming the entire binary
