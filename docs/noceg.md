# NoCEG

## Notes

### noceg.json

- `BreakpointType`
  - Type of breakpoint to set
  - 1 is software, 2 is hardware
- `ConstantOrStolen`: CEG protected functions

  > // CEG_ProtectFunction()
  > //
  > // The function which contains this macro will be modified, so that it's address must be computed
  > // by every caller of the function. The address computation will involve machine specific data,
  > // as well as checksum computations which verify that the executable has not been modified.

  (https://github.com/blackletum/csgo_test/blob/4cf3d205632fbafce3a210e38b71907065c8e2a6/src/common/CegClient.h)

- `Init`: CEG init function
- `Integrity` offsets point to functions that are all the same
  - Not referenced by steam_api.dll
- `RegisterThread`
  - Location of the CEG RegisterThread fucntion
    ```
    //	In the event that the CEG library is initialized through Steamworks_InitCEGLibrary(), then the
    //	following functions must also be called, on each thread on which CEG code may execute, before any
    //	other CEG code code executes on the thread
    ```
- `RegisterThreads`
  - Not referenced by steam_api.dll
- `ShouldRestart`
  - Some games need to restart after processing every entry in `ConstantOrStolen`; doesn't apply to Civ 5
- `Terminate`: CEG termination function
  - Not referenced by steam_api.dll
- `TestSecret`
  - locations of `Steamworks_TestSecret` functions
  - We don't care about this: "Steamworks_TestSecret() and Steamworks_TestSecretAlways() are focused on evaluating the current computer to determine whether it is the machine the binary was produced for." (https://github.com/blackletum/csgo_test/blob/4cf3d205632fbafce3a210e38b71907065c8e2a6/src/common/CegClient.h#L197)
  - Not referenced by steam_api.dll

#### `ConstantOrStolen

- `BP`
  - Created by noceg_signatures.exe
  - steam_api.dll will set a breakpoint here (of type `BreakpointType`)
    - When the breakpoint is reached, it will update IsAddress and Value in noceg.json
- `EIP`
  - Created by noceg_signatures.exe
  - steam_api.dll uses this to write EIP at the breakpoint
    - EIP is the Windows register (Extended Instruction Pointer) which indicates the address of the next instruction that should be executed
    - This is used to intentionally direct the program flow into CEG
- `IsAddress`
  - Created by steam_api.dll
  - Determines whether Value looks like an address (versus a constant)
- `Prologue`
  - Created by noceg_signatures.exe
  - Not referenced by steam_api.dll
- `Type`
  - Created by noceg_signatures.exe
  - CEG function types
    - 1: CEG constant functions
    - 2: Older CEG stolen/masked functions
    - 3/4: CEG stolen/masked functions
  - The different functions need to be processed differently by steam_api.dll and patched differently by noceg_patcher.exe
- `Value`
  - Set by steam_api.dll
  - When the breakpoint in `BP` is hit, steam_api.dll gets the value of the EAX register and sets value depending on the function type
    - It may be the raw value of EAX or a calculated value based on EAX

### steam_api.dll

#### Sequence

1. The custom steam_api.dll reads noceg.json and starts going through each entry
1. At the first entry, it reads the first address and throws an exception to interrupt the normal program flow
1. That exception is caught in noceg/include/handler.h
   1. EIP is overwritten to redirect the program execution into the desired CEG function
   1. A trap flag is set to run the next instruction and throw EXCEPTION_SINGLE_STEP
1. EXCEPTION_SINGLE_STEP is caught
   1. It verified that the function at EIP is reached
   1. If a hardware breakpoint is set, noceg.json is updated and hardware breakpoint is removed
   1. execution is continued
1. If a software breakpoint is set, handler.h catches EXCEPTION_BREAKPOINT
   1. EAX is read, `Value` is derived from EAX based on function type and set in noceg.json
   1. `IsAddress` is set in noceg.json
   1. Remove software breakpoint
1. Continue to the next entry

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
