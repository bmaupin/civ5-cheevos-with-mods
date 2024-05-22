import { promises as fs } from 'fs';
import * as PE from 'pe-library';

const main = async () => {
  if (process.argv.length !== 3) {
    console.log('Error: Please provide the path to the file to patch');
    process.exit(1);
  }

  const fileToPatch = process.argv[2];
  const fileData = await fs.readFile(fileToPatch);

  const stringFileOffset = fileData.indexOf(
    'SELECT ModID from Mods where Activated = 1'
  );

  // Convert the file offset to a memory address
  const exe = PE.NtExecutable.from(fileData, { ignoreCert: true });
  const rdataInfo = exe
    .getAllSections()
    .filter((section) => section.info.name === '.rdata')[0].info;
  const rdataFileOffset = rdataInfo.pointerToRawData;
  const rdataMemoryAddress = rdataInfo.virtualAddress + exe.getImageBase();
  const stringMemoryAddress =
    stringFileOffset - rdataFileOffset + rdataMemoryAddress;

  // Allocate a 4-byte buffer to hold the memory address
  const memoryAddressBuffer = Buffer.alloc(4);
  memoryAddressBuffer.writeUInt32LE(stringMemoryAddress);

  // Find the first instance in the file where the memory address is referenced
  const firstUsageAddress = fileData.indexOf(memoryAddressBuffer);

  // Starting from that address, find the offset of the bytes to patch
  const searchBuffer = new Uint8Array([0x85, 0xc0, 0x74]);
  const searchOffset = fileData.indexOf(searchBuffer, firstUsageAddress);

  if (searchOffset === -1 || searchOffset - firstUsageAddress > 512) {
    console.log('Unable to apply patch; has the file already been patched?');
    process.exit();
  }

  // Apply the patch
  fileData[searchOffset] = 0x3b;
  fs.writeFile(fileToPatch, fileData);
  console.log(
    `Successfully replaced 0x85 at 0x${searchOffset.toString(16)} with 0x3b`
  );
};

main();
