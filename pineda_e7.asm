global _start
global get_largest_nonNegative

section .data
    SYS_EXIT        equ     60
    num_arr         dw      -7, 2, -3, -4, -5
    all_negative    db      1
    largest         dw      -1

section .text
_start:
    mov rbx, num_arr
    
    mov dx, word[largest]
    mov al, byte[all_negative]

    call get_largest_nonNegative

    mov word[largest], dx
    mov byte[all_negative], al


exit_here:
    mov rax, SYS_EXIT
    xor rdi, rdi
    syscall

get_largest_nonNegative:
    mov rsi, 0
    mov rcx, 5

    checker_loop:

        cmp word[rbx + rsi*2], 0   
        jl skip_element             ;jump if the element is a negative number

        cmp word[rbx + rsi*2], dx
        jle skip_element            ;jump if the element is smaller than the current Largest

        mov dx, word[rbx + rsi*2]       ;this element is the current largest non-negative number

        mov al, 0           ;a positive/non-negative number is detected

        skip_element:
            inc rsi

    loop checker_loop

    ret

