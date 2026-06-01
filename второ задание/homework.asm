%include "io64.inc"

%define MAX_COUNT 10

section .data
    msg_neg db "Negative stored numbers (reversed): ", 0
    msg_pos db "Count of positive stored numbers: ", 0
    msg_empty db "No numbers were stored.", 0

section .bss
    array resq MAX_COUNT

section .text
    global main

main:
    mov rbp, rsp
    call ReadAndStore
    mov rdi, rax
    call ProcessAndOutput
    xor rax, rax
    ret

ReadAndStore:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    xor r12, r12
.read_loop:
    cmp r12, MAX_COUNT
    jge .done_reading
    GET_DEC 8, rax
    mov r13, rax
    test rax, 1
    jz .check_store
    cmp rax, 20
    jge .check_store
    cmp rax, 0
    jle .check_store
    jmp .done_reading
.check_store:
    test r13, 1
    jnz .store_number
    mov rax, r13
    cqo
    mov rcx, 3
    idiv rcx
    cmp rdx, 0
    jne .next_iter
.store_number:
    mov qword [array + r12*8], r13
    inc r12
.next_iter:
    jmp .read_loop
.done_reading:
    mov rax, r12
    pop r13
    pop r12
    mov rsp, rbp
    pop rbp
    ret

ProcessAndOutput:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    cmp rdi, 0
    je .no_elements
    PRINT_STRING msg_neg
    xor r12, r12
    mov r13, rdi
    dec r13
.output_loop:
    cmp r13, 0
    jl .print_count
    mov rax, qword [array + r13*8]
    cmp rax, 0
    jge .check_positive
    PRINT_DEC 8, rax
    PRINT_CHAR ' '
    jmp .next
.check_positive:
    je .next
    inc r12
.next:
    dec r13
    jmp .output_loop
.print_count:
    NEWLINE
    PRINT_STRING msg_pos
    PRINT_DEC 8, r12
    NEWLINE
    jmp .end
.no_elements:
    PRINT_STRING msg_empty
    NEWLINE
.end:
    pop r13
    pop r12
    mov rsp, rbp
    pop rbp
    ret