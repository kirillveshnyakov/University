MAX_QWORDS:     equ             128

                section         .text

                global          _start
_start:

                sub             rsp, 4 * MAX_QWORDS * 8
                lea             rdi, [rsp + MAX_QWORDS * 8]
                mov             rcx, MAX_QWORDS
                call            read_long
                mov             rdi, rsp
                call            read_long
                lea             rsi, [rsp + MAX_QWORDS * 8]
                lea             r15, [rsp + 2 * MAX_QWORDS * 8]

                mov             r10, r15
                call            mul_long_long

                mov             rdi, r15
                add             rcx, MAX_QWORDS * 2
                call            write_long

                mov             al, 0x0a
                call            write_char

                jmp             exit


; multiplies a long number by a long number
;    rdi -- address of multiplier #1 (long number)
;    rsi -- address of multiplier #2 (long number)
;    r15 -- address of result (long_long number)
;    rcx -- length of long number in qwords
; result:
;    product is written to r15
mul_long_long:
                call            number_set_zero
                push            rdi
                push            rsi
                push            r15
                push            rcx
                push            r12

                mov             r12, rcx

.loop:
                mov             rbx, [rsi]
                call            mul_long_short_2
                add             rsi, 8
                add             r15, 8
                dec             rcx
                jnz             .loop


                pop             r12
                pop             rcx
                pop             r15
                pop             rsi
                pop             rdi
                ret

; multiplies a long number by a short number version 2
;    rdi -- address of multiplier #1 (long number)
;    rbx -- multiplier #2 (64-bit unsigned)
;    r15 -- address of result (long_long number)
;    r12 -- length of long number in qwords
; result:
;    product is written to r15
mul_long_short_2:
                push            rax
                push            rdi
                push            r15
                push            r13
                push            r12

                clc
.loop:
                mov             rax, [rdi]
                mul             rbx
                add             rax, r13
                adc             rdx, 0
                add             [r15], rax
                adc             rdx, 0
                add             rdi, 8
                add             r15, 8
                mov             r13, rdx
                dec             r12
                jnz             .loop

                add             [r15], r13
                pop             r12
                pop             r13
                pop             r15
                pop             rdi
                pop             rax
                ret

; make a long number zero
;    r10 -- address of long number
;    r11 -- length of long numbers in qwords
number_set_zero:
                push            r11
                push            r10

.loop:
                mov             qword [r10], 0
                lea             r10, [r10 + 8]
                dec             r11
                cmp             r11, 0
                jne             .loop

                pop             r10
                pop             r11
                ret

; adds a short number to a long number
;    rdi -- address of summand #1 (long number)
;    rax -- summand #2 (64-bit unsigned)
;    rcx -- length of long number in qwords
; result:
;    sum is written to rdi
add_long_short:
                push            rdi
                push            rcx
                push            rdx

                xor             rdx, rdx
.loop:
                add             [rdi], rax
                adc             rdx, 0
                mov             rax, rdx
                xor             rdx, rdx
                add             rdi, 8
                dec             rcx
                jnz             .loop

                pop             rdx
                pop             rcx
                pop             rdi
                ret

; multiplies a long number by a short number
;    rdi -- address of multiplier #1 (long number)
;    rbx -- multiplier #2 (64-bit unsigned)
;    rcx -- length of long number in qwords
; result:
;    product is written to rdi
mul_long_short:
                push            rax
                push            rdi
                push            rcx

                xor             rsi, rsi
.loop:
                mov             rax, [rdi]
                mul             rbx
                add             rax, rsi
                adc             rdx, 0
                mov             [rdi], rax
                add             rdi, 8
                mov             rsi, rdx
                dec             rcx
                jnz             .loop

                pop             rcx
                pop             rdi
                pop             rax
                ret

; divides a long number by a short number
;    rdi -- address of dividend (long number)
;    rbx -- divisor (64-bit unsigned)
;    rcx -- length of long number in qwords
; result:
;    quotient is written to rdi
;    remainder is written to rdx
div_long_short:
                push            rdi
                push            rax
                push            rcx

                lea             rdi, [rdi + 8 * rcx - 8]
                xor             rdx, rdx

.loop:
                mov             rax, [rdi]
                div             rbx
                mov             [rdi], rax
                sub             rdi, 8
                dec             rcx
                jnz             .loop

                pop             rcx
                pop             rax
                pop             rdi
                ret

; assigns zero to a long number
;    rdi -- argument (long number)
;    rcx -- length of long number in qwords
set_zero:
                push            rax
                push            rdi
                push            rcx

                xor             rax, rax
                rep stosq

                pop             rcx
                pop             rdi
                pop             rax
                ret

; checks if a long number is zero
;    rdi -- argument (long number)
;    rcx -- length of long number in qwords
; result:
;    ZF=1 if zero
is_zero:
                push            rax
                push            rdi
                push            rcx

                xor             rax, rax
                rep scasq

                pop             rcx
                pop             rdi
                pop             rax
                ret

; reads a long number from stdin
;    rdi -- location for output (long number)
;    rcx -- length of long number in qwords
read_long:
                push            rcx
                push            rdi

                call            set_zero
.loop:
                call            read_char
                or              rax, rax
                js              exit
                cmp             rax, 0x0a
                je              .done
                cmp             rax, '0'
                jb              .invalid_char
                cmp             rax, '9'
                ja              .invalid_char

                sub             rax, '0'
                mov             rbx, 10
                call            mul_long_short
                call            add_long_short
                jmp             .loop

.done:
                pop             rdi
                pop             rcx
                ret

.invalid_char:
                mov             rsi, invalid_char_msg
                mov             rdx, invalid_char_msg_size
                call            print_string
                call            write_char
                mov             al, 0x0a
                call            write_char

.skip_loop:
                call            read_char
                or              rax, rax
                js              exit
                cmp             rax, 0x0a
                je              exit
                jmp             .skip_loop

; writes a long number to stdout
;    rdi -- argument (long number)
;    rcx -- length of long number in qwords
write_long:
                push            rax
                push            rcx

                mov             rax, 20
                mul             rcx
                mov             rbp, rsp
                sub             rsp, rax

                mov             rsi, rbp

.loop:
                mov             rbx, 10
                call            div_long_short
                add             rdx, '0'
                dec             rsi
                mov             [rsi], dl
                call            is_zero
                jnz             .loop

                mov             rdx, rbp
                sub             rdx, rsi
                call            print_string

                mov             rsp, rbp
                pop             rcx
                pop             rax
                ret

; reads one char from stdin
; result:
;    rax == -1 if error occurs
;    rax \in [0; 255] if OK
read_char:
                push            rcx
                push            rdi

                sub             rsp, 1
                xor             rax, rax
                xor             rdi, rdi
                mov             rsi, rsp
                mov             rdx, 1
                syscall

                cmp             rax, 1
                jne             .error
                xor             rax, rax
                mov             al, [rsp]
                add             rsp, 1

                pop             rdi
                pop             rcx
                ret
.error:
                mov             rax, -1
                add             rsp, 1
                pop             rdi
                pop             rcx
                ret

; writes one char to stdout, errors are ignored
;    al -- char
write_char:
                sub             rsp, 1
                mov             [rsp], al

                mov             rax, 1
                mov             rdi, 1
                mov             rsi, rsp
                mov             rdx, 1
                syscall
                add             rsp, 1
                ret

exit:
                mov             rax, 60
                xor             rdi, rdi
                syscall

; prints a string to stdout
;    rsi -- string
;    rdx -- size
print_string:
                push            rax

                mov             rax, 1
                mov             rdi, 1
                syscall

                pop             rax
                ret


                section         .rodata
invalid_char_msg:
                db              "Invalid character: "
invalid_char_msg_size: \
                equ             $ - invalid_char_msg
