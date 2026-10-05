#!/bin/bash
set -e
cd "$(dirname "$0")"

nasm stellboot.asm -f bin -o stellboot.bin
nasm kernel_entry.asm -f elf32 -o kernel_entry.o
i686-elf-gcc -ffreestanding -fno-pie -fno-stack-protector -c kernel.c -o kernel.o
i686-elf-ld -Ttext 0x10000 --oformat binary -o kernel.bin kernel_entry.o kernel.o

cat stellboot.bin kernel.bin > os.img
dd if=/dev/zero bs=512 count=16 >> os.img 2>/dev/null

qemu-system-i386 -drive format=raw,file=os.img