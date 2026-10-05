[bits 32]
[extern kernel_main] ; Tells the assembler kernel_main is inside kernel.c

global _start
_start:
    call kernel_main ; Jump to your C code
    jmp $            ; Infinite loop safety trap if C ever exits

