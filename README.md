## StellBoot
 StellBoot is a A 2-stage bootloader written in x86 NASM and virtualized with QEMU. It is named after my cat Stella for convenience.

 This repository contains the building instructions in case you would like to run it yourself or fork it.
 Note: although this is x86 NASM and uses ELF, it is virtualized in QEMU using an ARM64 M4 chip, on MacOS Sequoia Version 15.2 (24C2101). Although this should not matter much, as QEMU virtualizes in x86. I am still including it for documentation purposes. It is easy enough to change any QEMU settings in the `build.sh` file included. 

Simple snapshot of the bootloader and kernel booting:
<img width="1470" height="956" alt="Screenshot 2026-10-05 at 4 36 27 PM" src="https://github.com/user-attachments/assets/3aa24c8c-5a54-4938-baf3-27116044e16b" />

## How the program Works 
1. The BIOS loads the 512 boot sector, it does this by checking for '0x7C00' and '0xAA55' signatures.
2. The bootloader sets up the [segments]([url](https://wiki.osdev.org/Segmentation)) first, then the stack/stack pointer, and saves the identifier number that will inform later which drive it is booting from.
3. The program reads the kernel file and loads it at address '0x10000'.
4. Loads a simple global descriptor table
5. Changes from real mode into 32-bit protected mode.
6. Sets up 32 bit registers and stack.
7. Jumps to kernel initializer file `kernel_entry.asm`.

After that, `kernel_entry.asm` calls `kernel.c`

`kernel.c` prints "Hello from Kernel" directly into video memory to display the message!

## Limitations
1. The Bootloader only reads a single 512 byte sector, meaning that it is constrained to a size of 512 bytes. 
In this case, 512 bytes were not used, and the rest of the file was padded with 0's (see `times 510-($-$$) db 0`) for it to be exactly 12 bytes.
If the kernel was bigger, more boot sectors can be added by editing the `mov al, 1; `instruction into register `al` in line 37. The decimal number loaded into `al` is the amount of boot sectors.

2. Since there is no I/O drivers implemented in the kernel, this is limited to only displaying hardcoded chars. I have left it at this due to the objective of the program being personal learning, and focusing on pre-kernel development.

## Resources

- [OSDev Wiki: Boot Sequence](https://wiki.osdev.org/Boot_Sequence)
- [OSDev Wiki: GDT Tutorial](https://wiki.osdev.org/GDT_Tutorial)
- [OSDEV Wiki: Segmentation](https://wiki.osdev.org/Segmentation)
- Claude AI was used for debugging stack and boot logic.





