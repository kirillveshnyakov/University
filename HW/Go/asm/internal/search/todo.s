#include "textflag.h"

#define ZERO(r) \
    XORQ r, r

//func LowerBound(slice []int64, value int64) int64
TEXT ·LowerBound(SB), NOSPLIT, $0
    MOVQ slice_base+0(FP), AX // ptr
    MOVQ slice_len+8(FP), DX // len
    MOVQ value+24(FP), R15 // value
    MOVQ $-1, R8 // left
    MOVQ DX, R9 // right

loop:
    LEAQ 1(R8), R10
    CMPQ R10, R9
    JGE end

    MOVQ R9, R10
    SUBQ R8, R10
    SARQ $1, R10
    ADDQ R8, R10

    CMPQ R15, (AX)(R10*8)
    CMOVQLE R10, R9
    CMOVQGT R10, R8
    JMP loop

end:
    MOVQ R9, ret+32(FP)
    RET
