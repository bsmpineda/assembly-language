global _start
global countFunction

section .data
	SYS_EXIT	equ	60
	input		dq	555
	cnt			db	0

section .text
_start:
	mov rdx, 0
	mov rax, [input]		;rax = input
	mov rcx, 10
	mov bl, [cnt]			;bl = 0

	call countFunction
	mov byte[cnt], bl

	
exit_here:
	;exit code
	mov rax, SYS_EXIT
	xor rdi, rdi
	syscall

countFunction:
	cnt_loop:
		mov rdx, 0 			;rdx = 0

		cmp rax, 0 			
		je _return			;check if rax = 0
		
		push(rdx)
		add bl, 1
		pop(rdx)

		div rcx				;rax = rax/10 , rdx = rem
		jmp cnt_loop

	_return:
		ret