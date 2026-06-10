# NoCEG

## Notes

#### noceg.json

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

## Comparing Windows and Proton functionality

### noceg_signatures.exe

Seems to work identical in Windows and Proton

- noceg.log contents are the same
- noceg.json contents are the same

#### noceg.log

```
CEG signatures finder by iArtorias (https://github.com/iArtorias).

[WARNING] Older CEG version found.
[SUCCESS] Found CEG init function: '0x0054b550'.
[SUCCESS] Found CEG terminate function: '0x006945d0'.
[SUCCESS] Found CEG protected (stolen) (v1) functions: '70'.
[SUCCESS] Found CEG protected (stolen) (v2) functions: '72'.
[SUCCESS] Found CEG integrity functions: '9'.
[SUCCESS] Found CEG test secret functions: '185'.
```

### noceg_patcher.exe

Seems to work identical in Windows and Proton **if** the input noceg.json is the same

### steam_api.dll

👉 This is the issue. The process exits prematurely in Proton/Wine and does not modify noceg.json, whereas in Windows it modifies noceg.json

#### Windows

- Message "Successfully finished the task!"
- Lots more in noceg.log, e.g.
  ```
  2026-06-03 17:58:27.3052668 [I] Custom exception reached '0xCEADDEAD'.
  2026-06-03 17:58:27.3053618 [I] Changing EIP to '0x00CE19B0'.
  2026-06-03 17:58:27.3102087 [I] Removing the software breakpoint at '0x00BFA928'.
  2026-06-03 17:58:27.3102899 [I] Breakpoint just being hit, EAX value is '0x00BD3DF0'.
  ```
- New `IsAddress` boolean properties added to entries in `ConstantOrStolen`
- `Value` properties in `ConstantOrStolen` get populated
