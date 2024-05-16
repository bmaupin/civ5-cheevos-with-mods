#!/usr/bin/env bash

# Patch the Civilization V executable to allow achievements with any mod

if [ -z "${1}" ]; then
    echo 'Error: please provide path to the Civ 5 binary to patch'
    echo "Usage: $0 BINARY_PATH"
    exit 1
fi

bin_path="${1}"

# Get the file offset of the search string
file_offset=$(strings -t x "${bin_path}" | grep "SELECT ModID from Mods where Activated = 1" | awk '{ print $1}')

# Get the memory offset corresponding to the file offset of the search string
rdata_file_offset=$(objdump -h "${bin_path}" | grep .rdata | awk '{ print $6 }')
rdata_memory_offset=$(objdump -h "${bin_path}" | grep .rdata | awk '{ print $4 }')
memory_offset=$(printf "0x%X\n" $((0x$file_offset - 0x$rdata_file_offset + 0x$rdata_memory_offset)))

# Drop the 0x prefix
memory_offset=$(echo "${memory_offset}" | cut -c 3-)

# Convert the memory offset to little endian
le_memory_offset=$(echo "${memory_offset}" | tac -rs .. | echo "$(tr -d '\n')")

# Prepend every other character with "\x" (needed for the next command)
formatted_memory_offset=""
for ((i = 0; i < ${#le_memory_offset}; i += 2)); do
    formatted_memory_offset+="\\x${le_memory_offset:i:2}"  # Extract 2 characters at a time and append \x
done

# Get address of where the memory offset is first used
first_usage_address=$(LANG=C grep -obUaP "${formatted_memory_offset}" "${bin_path}" | cut -d : -f 1)

# Extract a certain number of bytes from the binary file starting at that address
bytes=$(xxd -p -l 512 --seek "${first_usage_address}" "${bin_path}" | tr -d '\n')

# Apply the patch to the extracted bytes
patched_bytes=$(echo "${bytes}" | sed 's/85c074/3bc074/')

# Write the patched bytes back to the binary file
echo "${patched_bytes}" | xxd -p -r | dd of="${bin_path}" bs=1 conv=notrunc seek="${first_usage_address}"
