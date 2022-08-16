global _start

section .data
    SYS_EXIT        equ     60

    SYS_READ        equ     0
    STDIN           equ     0
    SYS_WRITE       equ     1
    STDOUT          equ     1
    NULL            equ     0
    LF equ 10

    newLine         db      LF, NULL
    newLineLen      equ     $-newLine

    menuMsg         db      10, " ************MENU*********** ", 10, "[1] Addition", 10, "[2] Subtraction", 10, "[3] Integer Division", 10, "[0] Exit", 10, "**************************", 10, "Choice : ", NULL
    menuMsgLength   equ     $-menuMsg

    enterMsg        db      "Enter a two-digit number : ", NULL
    enterMsgLength  equ     $-enterMsg

    invalidChoice db 10, "Invalid choice!", 10, NULL
    invalidChoiceLength equ $-invalidChoice

    num1        dw  0
    num2        dw  0
    hundredVar  db  0
    tensVar     db  0
    onesVar     db  0
    ans         db  0
    choice      db  0

section .text
_start:
    menu_loop:
        ;print menu
        mov rax, SYS_WRITE
        mov rdi, STDOUT
        mov rsi, menuMsg
        mov rdx, menuMsgLength
        syscall

        ;ask for input
        mov rax, SYS_READ
        mov rdi, STDIN
        mov rsi, choice
        mov rdx, 2
        syscall

        sub byte[choice],  30h

        cmp byte[choice], 0     ;compare choice to 0
        je exit_here            ;if choice == 0, then exit
        cmp byte[choice], 3     ;if the input is not on the choices
        jg invalid_choice       ;print invalid choice

        ;else, ask for 2 two-digit number
        ;print number message
            mov rax, SYS_WRITE
            mov rdi, STDOUT
            mov rsi, enterMsg
            mov rdx, enterMsgLength
            syscall

            ;ask for num1 input
            mov rax, SYS_READ
            mov rdi, STDIN
            mov rsi, num1
            mov rdx, 3
            syscall

            ;print number message
            mov rax, SYS_WRITE
            mov rdi, STDOUT
            mov rsi, enterMsg
            mov rdx, enterMsgLength
            syscall

            ;ask for num2 input
            mov rax, SYS_READ
            mov rdi, STDIN
            mov rsi, num2
            mov rdx, 3
            syscall

        ;get the tens on the input num1
            mov bl, [num1]
            mov byte[tensVar], bl
            
            ;get the ones on the input num1
            mov bl, [num1+1]
            mov byte[onesVar], bl

            ;convert into decimal
            sub byte[tensVar], 30h  ;convert tens
            sub byte[onesVar], 30h  ;convert ones

            mov cl, 10
            mov al, byte[tensVar]
            mul cl                  ;multiply to ten
            mov byte[num1], 0
            mov word[num1], ax

            mov bl, byte[onesVar]
            add byte[num1], bl          ;the num1 is now converted

            ;get the tens on the input num2
            mov rbx, 0
            mov bl, [num2]
            mov byte[tensVar], bl
            
            ;get the ones on the input num2
            mov rbx, 0
            mov bl, [num2+1]
            mov byte[onesVar], bl

            ;convert into decimal
            sub byte[tensVar], 30h  ;convert tens
            sub byte[onesVar], 30h  ;convert ones

            mov cl, 10
            mov al, byte[tensVar]
            mul cl                  ;multiply to ten
            mov byte[num2], 0
            mov byte[num2], al

            mov bl, byte[onesVar]   
            add byte[num2], bl      ;num2 is now in decimal

        ;compare choice value to determine on what operation to use
        cmp byte[choice], 3
        je division
        cmp byte[choice], 2
        je subtraction

        ;else add
        addition:
            mov rsp, 0
            mov spl, byte[num1]
            mov byte[ans], spl

            mov rsp, 0
            mov spl, byte[num2]
            add byte[ans], spl
            jmp convert_ans     ;convert ans to string

        subtraction:
            mov rsp, 0
            mov spl, byte[num1]
            mov byte[ans], spl

            mov rsp, 0
            mov spl, byte[num2]
            sub byte[ans], spl
            jmp convert_ans

        division: 
            mov rax, 0
            mov al, byte[num1]
            div byte[num2]          ;al = num1/num2
            mov byte[ans], al


        convert_ans:
            ;convert ans to string
            mov cl, 10
            mov al, byte[ans]
            div cl
            mov byte[onesVar], ah       ;get the remainder as the ones value
            mov ah, 0                   ;set the remainder to 0 so that ax is only equal to the quotient

            div cl          ; ax = al / cl
            mov byte[tensVar], ah   
            mov ah, 0

            div cl
            mov byte[hundredVar], ah

            add byte[hundredVar], 30h           ;convert to string
            add byte[tensVar], 30h
            add byte[onesVar], 30h

            ;print the answer
            mov rax, SYS_WRITE
            mov rdi, STDOUT
            mov rsi, hundredVar
            mov rdx, 1
            syscall

            mov rax, SYS_WRITE
            mov rdi, STDOUT
            mov rsi, tensVar
            mov rdx, 1
            syscall

            mov rax, SYS_WRITE
            mov rdi, STDOUT
            mov rsi, onesVar
            mov rdx, 1
            syscall

            ;print new line
            mov rax, SYS_WRITE
            mov rdi, STDOUT
            mov rsi, newLine
            mov rdx, newLineLen
            syscall
            
        jmp next_loop
        

        invalid_choice:
			mov rax, SYS_WRITE
			mov rdi, STDOUT
			mov rsi, invalidChoice
			mov rdx, invalidChoiceLength
			syscall

    next_loop:
        jmp menu_loop


exit_here:
    mov rax, SYS_EXIT
    xor rdi, rdi
    syscall