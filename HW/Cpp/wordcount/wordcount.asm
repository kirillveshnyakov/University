section .text
global _start

buffer_size: equ 65536
SYS_READ: equ 0
SYS_WRITE: equ 1
STDIN: equ 0
STDOUT: equ 1
STDERR: equ 2
SYS_EXIT: equ 60
ERROR_RETURN: equ 1

_start:
    sub rsp, buffer_size
    xor ebx, ebx
    mov rsi, rsp
    mov r15, 1
    mov rdi, 0
    mov rdx, buffer_size
.read_loop:
    xor eax, eax
    syscall
    cmp rax, 0
    jl .error
    je .exit
    xor ecx, ecx
.check_9_13:
    mov bpl, byte [rsp+rcx]
    cmp bpl, 9
    jl .is_not_space
    cmp bpl, 13
    jg .check_32
    mov r15, 1
    jmp .after_count
.check_32:
    cmp bpl, 32
    jne .is_not_space
    mov r15, 1
    jmp .after_count
.is_not_space:
    add rbx, r15
    xor r15, r15
.after_count:
    inc rcx
    cmp rcx, rax
    jb .check_9_13
    jmp .read_loop
.exit:
    mov rax, rbx
    lea rcx, [write_buffer + write_buffer_size - 1]
    mov byte [rcx], 0x0a
    mov rbx, 10
.print_num:
    xor edx, edx
    div rbx
    add dl, '0'
    dec rcx
    mov byte [rcx], dl
    test rax, rax
    jnz .print_num
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, rcx
    lea rdx, [write_buffer + write_buffer_size]
    sub rdx, rcx
    syscall
    mov rax, SYS_EXIT
    xor edi, edi
    syscall
.error:
    mov rax, SYS_WRITE
    mov rdi, STDERR
    mov rsi, error_msg
    mov rdx, error_msg_len
    syscall
    mov rax, SYS_EXIT
    mov rdi, ERROR_RETURN
    syscall

section .rodata
    error_msg: db "error", 0x0a
    error_msg_len: equ $ - error_msg

section .bss
    write_buffer_size: equ 21
    write_buffer: resb write_buffer_size
