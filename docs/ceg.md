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

#### Notes

- noceg.json
  - `ConstantOrStolen`: I think this contains CEG protected functions, i.e. the ones we're looking for

    > // CEG_ProtectFunction()
    > //
    > // The function which contains this macro will be modified, so that it's address must be computed
    > // by every caller of the function. The address computation will involve machine specific data,
    > // as well as checksum computations which verify that the executable has not been modified.

    (https://github.com/blackletum/csgo_test/blob/4cf3d205632fbafce3a210e38b71907065c8e2a6/src/common/CegClient.h)

  - `Init`: CEG init function
  - `Integrity` offsets point to functions that are all the same
  - `Terminate`: CEG termination function
  - `TestSecret`: "test secret functions, seem to do registry checks?
    - We don't care about this: "Steamworks_TestSecret() and Steamworks_TestSecretAlways() are focused on evaluating the current computer to determine whether it is the machine the binary was produced for." (https://github.com/blackletum/csgo_test/blob/4cf3d205632fbafce3a210e38b71907065c8e2a6/src/common/CegClient.h#L197)

#### Process

1. Look for `AD DE 00 80` in binary (`0x8000DEAD`)
   - `0x160516`
   - Used in `UndefinedFunction_00561110`
