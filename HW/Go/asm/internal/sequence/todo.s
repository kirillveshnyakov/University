#include "textflag.h"

#define ZERO(r) \
    XORQ r, r

//func Fibonacci(n uint64) uint64
TEXT ·Fibonacci(SB), NOSPLIT, $0
     MOVQ number+0(FP), DX // n
     ZERO(R8)
     MOVQ $1, R9

loop:
    CMPQ DX, $0
    JE end

    MOVQ R9, R10
    ADDQ R8, R9
    MOVQ R10, R8

    SUBQ $1, DX

    JMP loop

end:
    MOVQ R8, ret+8(FP)
    RET
