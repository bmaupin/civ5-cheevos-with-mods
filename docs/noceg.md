# NoCEG

## noceg_signatures.exe

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

## noceg_patcher.exe

Seems to work identical in Windows and Proton **if** the input noceg.json is the same

## steam_api.dll

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
