.section .text
.globl _start

_start:
    li t1, 0x0f0f0f0f
    li t2, 0xffff0000

and_test:
    li t3, 0x0f0f0000
    and t0, t1, t2
    bne t0, t3, fail

or_test:
    li t3, 0xffff0f0f
    or t0, t1, t2
    bne t0, t3, fail

xor_test:
    li t3, 0xf0f00f0f
    xor t0, t1, t2
    bne t0, t3, fail

pass:
    ebreak

fail:
    ebreak
