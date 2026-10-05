[bits 32]
[extern kernel_main] ; tells that the assembler kernel_main is inside kernel.c

global _start
_start:
    call kernel_main ;
    jmp $            ;

