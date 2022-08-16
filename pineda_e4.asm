global _start

section .data
	SYS_EXIT	equ		60

	num1		db		64
	num2		db		96
	gcf			db		0

	lesserNum	db		0
	loopCnt		db		1
	

section .text

_start:
	;this part get the lesser number between the two input
	mov cl,	[num1]
	mov [lesserNum], cl
	mov dl, [num2]
	cmp  dl, [lesserNum]
	jg retain							;if num2>num1
	mov [lesserNum], dl

	retain:
		mov bl, [loopCnt]				;loop counter

	gcf_loop:
		cmp bl, [lesserNum]  			;while(loopCnt < lesserNum)
		jg exit_here 				
		
		;if(num1%loopCounter == 0)
		mov ax, 0
		mov al, byte[num1]
		div bl 							;num1/loopCounter
		cmp ah, 0 						;compare the Remainder to 0
		jne next

		;if(num2%loopCounter == 0)
		mov ax, 0
		mov al, byte[num2]
		div bl 							;num2/loopCounter
		cmp ah, 0 						;compare the Remainder to 0
		jne next

		;if both are true
		mov [gcf], bl					;gcf = loopCnt

	next:
		add bl, 1						;increment loop counter
		jmp gcf_loop  

exit_here:
	;exit code
	mov rax, SYS_EXIT
	xor rdi, rdi
	syscall