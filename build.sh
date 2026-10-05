#!/bin/bash

# 1. Compile the 512-byte bootloader
nasm -f bin stellboot.asm -o boot.bin

# 2. Compile the assembly wrapper into a 32-bit ELF object
nasm -f elf32 kernel_entry.asm -o kernel_entry.o

# 3. Compile your C kernel into a 32-bit freestanding object
x86_64-elf-gcc -m32 -ffreestanding -c kernel.c -o kernel.o
#!/bin/bash
# Build and run Stellboot
set -euo pipefail

cd "$(dirname "$0")"

# Clean old build output
rm -f *.o *.bin os.img

# 1. Bootloader (raw 512-byte boot sector)
nasm stellboot.asm -f bin -o stellboot.bin

# 2. Kernel entry stub
nasm kernel_entry.asm -f elf32 -o kernel_entry.o

# 3. Kernel C code
i686-elf-gcc -ffreestanding -fno-pie -fno-stack-protector \
    -fno-asynchronous-unwind-tables -c kernel.c -o kernel.o

# 4. Link at 0x10000, entry stub first, flat binary output
i686-elf-ld -Ttext 0x10000 --oformat binary \
    -o kernel.bin kernel_entry.o kernel.o

# 5. Disk image: bootloader + kernel, padded so the BIOS read succeeds
cat stellboot.bin kernel.bin > os.img
dd if=/dev/zero bs=512 count=16 >> os.img 2>/dev/null

# 6. Run (resizable window)
qemu-system-i386 -display cocoa,zoom-to-fit=on -drive format=raw,file=os.img

# 4. Link them together so they sit exactly at RAM address 0x10000
# (We put kernel_entry.o FIRST so the CPU lands on it immediately!)
x86_64-elf-ld -m elf_i386 -o kernel.bin -Ttext 0x10000 kernel_entry.o kernel.o --oformat binary

# 5. Glue them together! boot.bin is Sector 1, kernel.bin is Sector 2+
cat boot.bin kernel.bin > stellboot.bin

# 6. Launch QEMU with M4 optimizations
qemu-system-i386 -display cocoa,zoom-to-fit=on -full-screen -drive format=raw,file=os.img
