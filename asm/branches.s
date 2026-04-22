.section .text
.globl _start

_start:
    li t0, 0x7fffffff
    li t1, -1
    blt t0, t1, error
    li t0, -1
    li t1, 1
    bltu t0, t1, error
pass:
    ebreak
error:
    ebreak
