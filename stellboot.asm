org 0x7c00; Starting memory location

jmp _start 

_data:
msg db "Hello from Stellboot", 0
boot_drive db 0

_start:
;runs in real mode: everything is 16 bit for BIOS
;segment registers
xor ax, ax; setup 16bit general-purpose register (16 lower bits of EAX)
mov ds, ax
mov es, ax
mov [boot_drive], dl ; boot drive number for loading kernel later
jmp _setup_stack

;print hello from the BIOS!
_print_hello:
mov ah, 0x0E; 
mov al, 0x48; move 'h' into register
int 0x10; display interrupt
mov al, 0x69; move 'i' into register
int 0x10; display interrupt
jmp _load_kernel

_setup_stack:
mov ss, ax; move 0 into the stack segment register, beginning
mov sp, 0x7c00; start the stack pointer after bootloader (512 bytes)
jmp _print_hello

_load_kernel:
;memory target
mov ax, 0x1000 ;4096
mov es, ax
xor bx, bx

mov ah, 0x02 ; read from disk interrupt
mov al, 1; 1 x 512 space for kernel
mov ch, 0 ; disk location...
mov dh, 0
mov cl, 2
mov dl, [boot_drive]

int 0x13; bios interrupt: load the kernel file into memory
jc _final_step



;START OF 32 BIT PROTECTED MODE

;altering CPU state
;coolest part imo :D
cli            ; shut down 16 bit registers
lgdt [gdt_descriptor]    ; load descriptor into lgdt
mov eax, cr0   ; enable protected mode
or al, 1       ; set PE (Protection Enable) bit in CR0 (Control Register 0)
mov cr0, eax

jmp 08h:_32bitmain ; point to 8yte long descriptor in global descriptor table

[bits 32]
_32bitmain:
;https://wiki.osdev.org/GDT_Tutorial

    mov ax, 0x10
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000 ; setup base pointer and stack pointer
    mov esp, ebp
    jmp 0x10000 ; jump to kernel file

_final_step:
jmp $;infinite loop ($ is infinite). Will stop cpu from reading instructions

_gdt_start:
;null descriptor
gdt_null:
dd 0x0, 0x0
;code segment descriptor
gdt_code:
    dw 0xffff, 0x0
    db 0x0, 10011010b, 11001111b, 0x0

;data segment descriptor
gdt_data:
    dw 0xffff, 0x0
    db 0x0, 10010010b, 11001111b, 0x0
_gdt_end:

gdt_descriptor:
    dw _gdt_end - _gdt_start - 1 
    dd _gdt_start


times 510-($-$$) db 0 ;fill rest of file with zeroes.
;boot signature goated number: loads file into boot sector.
;see https://wiki.osdev.org/Boot_Sequence
dw 0xAA55 










