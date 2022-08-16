global _start

section .data
	SYS_EXIT		equ		60
	numA			db		15
	numB			db		21
	numC			db		7
	largestNum		db		0
	largestInput	db		''

section .text

_start:
	mov al, byte[numA]
	mov [largestNum], al 		;largestNum = numA

	mov cl, 'A'
	mov [largestInput], cl		;largestInput = "A"

;If numB > largestNum
	mov bl, byte[numB]
	cmp bl, byte[largestNum]
	jg	newMaxB				
	jmp retainMaxA

	newMaxB:						;if true
		mov byte[largestNum], bl 		;largestNum = numB

		mov cl, 'B'
		mov [largestInput], cl		;largestInput = "B"

	retainMaxA:						;if false

;If numC > largestNum
	mov bl, byte[numC]
	cmp bl, byte[largestNum]
	jg	newMaxC				
	jmp retainMax

	newMaxC:
		mov [largestNum], bl 		;largestNum = numC

		mov cl, 'C'
		mov [largestInput], cl		;largestInput = "C"

	retainMax:


exit_here:
	;exit code
	mov rax, SYS_EXIT
	xor rdi, rdi
	syscall