# Calculates the 40-th Fibonacci number.

.section .text
.globl _start

_start:
    li t0, 40           # max n
    li t1, 0            # n
    li t2, 0            # F(n)
    li t3, 1            # F(n+1)
loop:
    add t4, t2, t3      # F(n+2) = F(n) + F(n+1)
    mv t2, t3           # F(n) = F(n+1)
    mv t3, t4           # F(n+1) = F(n+2)
    addi t1, t1, 1      # n = n + 1
    bne t0, t1, loop    # n != max n
    ebreak
