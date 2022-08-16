global _start
global get_strlen
global convert_vowel

section .data  
    NULL        equ 0
    SYS_EXIT    equ 60
    string1     db  "computer science", NULL
    strOfVowel  db  "@310U"


section .text

_start:

	mov rsi, strOfVowel		

	mov rdi, string1		;rdi points to the first char of string1
    cld

    call convert_vowel      ;call function that convert vowels into assigned char

exit_here:
	mov rax, SYS_EXIT
	xor rdi, rdi
	syscall


convert_vowel:
    mov rbx, rsi

    
    string1_loop:
        mov rsi, rbx

        mov rax, 0
        mov al, byte[rdi]
        cmp al, NULL
        je return

        check_a:
            lodsb               ;move to @
            mov rbp, 0
            mov bpl, byte[rdi]
            cmp bpl, 'a'
            jne check_e
            stosb               ;change the vowel
            jmp string1_loop

        check_e:
            lodsb               ;move to 3
            mov rbp, 0
            mov bpl, byte[rdi]
            cmp bpl, 'e'
            jne check_i
            stosb               ;change the vowel
            jmp string1_loop

        check_i:
            lodsb               ;move to 1
            mov rbp, 0
            mov bpl, byte[rdi]
            cmp bpl, 'i'
            jne check_o
            stosb               ;change the vowel
            jmp string1_loop
        
        check_o:
            lodsb               ;move to 0
            mov rbp, 0
            mov bpl, byte[rdi]
            cmp bpl, 'o'
            jne check_u
            stosb               ;change the vowel
            jmp string1_loop

        check_u:
            lodsb               ;move to U
            mov rbp, 0
            mov bpl, byte[rdi]
            cmp bpl, 'u'
            jne continueLoop
            stosb              ;change the vowel
            jmp string1_loop

        continueLoop:          ;if the current char is a consonant
            inc rdi
            jmp string1_loop

    return:
        ret