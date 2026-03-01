#include "textflag.h"

#define ZERO(r) \
    XORQ r, r

//func Sum(x []int32) int64
TEXT ·Sum(SB),  NOSPLIT, $0
    MOVQ x_base+0(FP), AX // ptr
    MOVQ x_len+8(FP), DX // len
    ZERO(R8)

loop:
    CMPQ DX, $0
    JE end
    MOVLQSX (AX), R9
    ADDQ R9, R8
    ADDQ $4, AX
    SUBQ $1, DX
    JMP loop

end:
    MOVQ R8, ret+24(FP)
    RET
