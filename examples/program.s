.section .text
.globl _start

_start:
    addi x1, x0, 5
    addi x2, x0, 3
    add x1, x1, x2
    ebreak
