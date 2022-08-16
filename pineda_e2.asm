;PINEDA, BRIXTER SIEN M
;AB-3L

global _start

section .data
	SYS_EXIT	equ	60

	age		db	25
	days	dd	0
	hours	dq	0

section .text

_start:
	;convert Age to Days
	mov ax, 365			;word -> 365 is 9bits
	mul word[age] 		;ax => age*365
	mov [days], ax  	
	mov [days+2], dx

	;convert Days to Hours
	mov eax, 24
	mul dword[days]		; edx:eax => days*24
	mov [hours], eax	;store product to hours
	mov [hours+4], edx 

exit_here:
	;exit code
	mov rax, SYS_EXIT
	xor rdi, rdi
	syscall