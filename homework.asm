%include "io64.inc"

; Строго положителна константа за максимален брой числа в паметта
%define MAX_COUNT 10 

section .data
    msg_neg db "Negative stored numbers (reversed): ", 0
    msg_pos db "Count of positive stored numbers: ", 0
    msg_empty db "No numbers were stored.", 0

section .bss
    ; Резервираме масив от MAX_COUNT елемента, по 8 байта (64-битови цели числа)
    array resq MAX_COUNT 

section .text
    global CMAIN

CMAIN:
    mov rbp, rsp ; За правилна работа на дебъгера в SASM

    ; 1. Извикваме подпрограмата за четене и съхраняване
    call ReadAndStore
    
    ; Подпрограмата връща броя съхранени числа в регистър RAX.
    ; Предаваме го като аргумент (в RDI) на втората подпрограма.
    mov rdi, rax 
    
    ; 2. Извикваме подпрограмата за извеждане
    call ProcessAndOutput

    xor rax, rax ; Връщаме 0 (успешен край на програмата)
    ret

; =====================================================================
; ПОДПРОГРАМА 1: Въвеждане и съхраняване
; Връща: RAX = брой реално съхранени числа в масива
; =====================================================================
ReadAndStore:
    push rbp
    mov rbp, rsp
    push r12 
    push r13

    xor r12, r12 ; R12 ще бъде нашият брояч за съхранени числа (от 0 до MAX_COUNT)

.read_loop:
    cmp r12, MAX_COUNT
    jge .done_reading ; Спираме, ако сме съхранили MAX_COUNT на брой числа

    GET_DEC 8, rax    ; Четем 64-битово цяло число в RAX
    
    ; Запазваме оригиналното число в R13, защото RAX ще се променя
    mov r13, rax   
    
    ; --- ПРОВЕРКА ЗА ПРЕКРАТЯВАНЕ НА ЧЕТЕНЕТО ---
    ; Условие: Нечетно число И по-малко от 20
    test rax, 1
    jz .check_store_conditions ; Ако е четно, прескачаме проверката за спиране
    
    cmp rax, 20
    jl .done_reading ; Ако е нечетно и е < 20, прекратяваме четенето ВЕДНАГА

.check_store_conditions:
    ; --- ПРОВЕРКА ЗА СЪХРАНЕНИЕ ---
    ; Условие: Нечетно ИЛИ се дели на 3
    
    ; Проверка дали е нечетно
    test r13, 1
    jnz .store_number ; Ако е нечетно, веднага отиваме към съхранение

    ; Проверка дали се дели на 3 (вече знаем, че е четно)
    mov rax, r13
    cqo             ; Разширява знака на RAX в RDX:RAX (задължително при 64-битово деление)
    mov rcx, 3
    idiv rcx        ; RDX:RAX / 3 -> RAX (частно), RDX (остатък)
    
    cmp rdx, 0
    jne .next_iter  ; Ако остатъкът не е 0, числото не се запазва, продължаваме

.store_number:
    ; Съхраняваме числото в паметта (масива)
    mov qword [array + r12*8], r13
    inc r12

.next_iter:
    jmp .read_loop

.done_reading:
    mov rax, r12 ; Връщаме броя съхранени елементи чрез RAX
    
    pop r13
    pop r12
    mov rsp, rbp
    pop rbp
    ret

; =====================================================================
; ПОДПРОГРАМА 2: Обработка и изход
; Приема: RDI = брой съхранени числа
; =====================================================================
ProcessAndOutput:
    push rbp
    mov rbp, rsp
    push r12
    push r13

    cmp rdi, 0
    je .no_elements ; Ако няма съхранени числа, извеждаме съобщение

    PRINT_STRING msg_neg
    
    mov r12, 0       ; R12 ще брои строго положителните числа (> 0)
    
    mov r13, rdi
    dec r13          ; R13 е индексът за масива. Започваме отзад напред (RDI - 1)

.output_loop:
    cmp r13, 0
    jl .print_positives_count ; Ако индексът стане < 0, сме обходили масива

    mov rax, qword [array + r13*8] ; Взимаме текущото число

    cmp rax, 0
    jge .check_if_positive ; Ако числото е >= 0, не е отрицателно, проверяваме дали е > 0

    ; Извеждане на ОТРИЦАТЕЛНОТО число
    PRINT_DEC 8, rax
    PRINT_CHAR ' '
    jmp .next_element

.check_if_positive:
    je .next_element  ; Ако е точно 0, прескачаме (0 не е нито положително, нито отрицателно)
    inc r12           ; Увеличаваме брояча за положителни числа

.next_element:
    dec r13
    jmp .output_loop

.print_positives_count:
    NEWLINE
    PRINT_STRING msg_pos
    PRINT_DEC 8, r12
    NEWLINE
    jmp .end_output

.no_elements:
    PRINT_STRING msg_empty
    NEWLINE

.end_output:
    pop r13
    pop r12
    mov rsp, rbp
    pop rbp
    ret