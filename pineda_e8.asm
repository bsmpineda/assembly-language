global _start

section .data
	menu db 10, "[1] Add Patient", 10, "[2] Edit Patient", 10, "[3] Print Patients", 10, "[4] Exit", 10, "Enter choice : "
	menuLength equ $-menu

	invalidChoice db 10, "Invalid choice!", 10
	invalidChoiceLength equ $-invalidChoice

	fullPrompt db "Record is already full!", 10
	fullPromptLength equ $-fullPrompt

	addCase db 10, "Enter caseID : "		;Use this prompt for add and edit
	addCaseLength equ $-addCase

	addSex db "Enter sex (F - Female, M - Male) : "
	addSexLength equ $-addSex

	addStatus db "Enter status (0 - deceased, 1 - admitted, 2 - recovered) : " ;Use this prompt for add and edit
	addStatusLength equ $-addStatus

	addDate db "Enter date admitted (mm/dd/yyyy) : "
	addDateLength equ $-addDate

	printCase db 10, "CaseID : "
	printCaseLength equ $-printCase

	printSex db 10, "Sex : "
	printSexLength equ $-printSex

	printStatus db 10, "Status : "
	printStatusLength equ $-printStatus

	printDate db 10, "Date Admitted : "
	printDateLength equ $-printDate

	cannotEdit db "Cannot edit records of a deceased patient.", 10
	cannotEditLength equ $-cannotEdit

	cannotFind db "Patient not found!", 10
	cannotFindPrompt equ $-cannotFind

	newLine db 10
	newLineLength equ $-newLine

	SYS_READ        equ     0
    STDIN           equ     0
    SYS_WRITE       equ     1
    STDOUT          equ     1

	arraySize equ 5
	patient	equ 37

	caseID			equ	0
	caseIDLength 	equ 20
	sex				equ 21
	sexLength 		equ 22
	status			equ 23
	statusLength 	equ 24
	date  			equ 25
	dateLength 		equ 36


	patient_cnt 	db 0
	choice			db 0
	findCaseId		db 0


section .bss
patient_record 	resb 	patient*arraySize

section .text
_start:
	mov bl, 0
	mov byte[patient_cnt], 0
	menu_loop:
		;for indexing
		mov rbx, 0
		mov rax, 0
		mov al, patient
		mul byte[patient_cnt]
		mov bl, al   ;counter/index
		
		;print the menu
		mov rax, SYS_WRITE
		mov rdi, STDOUT
		mov rsi, menu
		mov rdx, menuLength
		syscall

		;get choice input
		mov rax, SYS_READ
		mov rdi, STDIN
		mov rsi, choice
		mov rdx, 2
		syscall

		cmp byte[choice], '4'
		je exit_here
		cmp byte[choice], '1'
		je add_Patient
		cmp byte[choice], '2'
		je edit_Patient
		cmp byte[choice], '3'
		je print_Patient
		jne invalid_choice
		


		add_Patient:
			mov bpl, byte[patient_cnt]
			cmp bpl, arraySize
			jge patient_full

			;write the add case id statement
			mov rax, SYS_WRITE
			mov rdi, STDOUT
			mov rsi, addCase
			mov rdx, addCaseLength
			syscall

			;get input for caseID
			mov rax, SYS_READ
			mov rdi, STDIN
			lea rsi, [patient_record + rbx + caseID]
			mov rdx, caseIDLength
			syscall

			;print the add sex statement
			mov rax, SYS_WRITE
			mov rdi, STDOUT
			mov rsi, addSex
			mov rdx, addSexLength
			syscall

			;get input for sex
			mov rax, SYS_READ
			mov rdi, STDIN
			lea rsi, [patient_record + rbx + sex]
			mov rdx, 2
			syscall

			;print add status statment
			mov rax, SYS_WRITE
			mov rdi, STDOUT
			mov rsi, addStatus
			mov rdx, addStatusLength
			syscall

			;get input for sex
			mov rax, SYS_READ
			mov rdi, STDIN
			lea rsi, [patient_record + rbx + status]
			mov rdx, 2
			syscall

			;print add status statment
			mov rax, SYS_WRITE
			mov rdi, STDOUT
			mov rsi, addDate
			mov rdx, addDateLength
			syscall

			;get input for sex
			mov rax, SYS_READ
			mov rdi, STDIN
			lea rsi, [patient_record + rbx + date]
			mov rdx, 11
			syscall

			inc byte[patient_cnt]
			jmp next_loop

		edit_Patient: 			;not working
		
			;write the add case id statement
			mov rax, SYS_WRITE
			mov rdi, STDOUT
			mov rsi, addCase
			mov rdx, addCaseLength
			syscall

			;get input for caseID
			mov rax, SYS_READ
			mov rdi, STDIN
			mov rsi, findCaseId
			mov rdx, caseIDLength
			syscall

			mov rbp, 0
			mov rsp, 0
			mov rax, 0

			edit_loop:
				cmp spl, byte[patient_cnt]
				jge not_found

				mov bpl, spl
				mov al, patient
				mul bpl
				mov bpl, al

				mov rdi, 0
				mov rsi, 0
				mov rcx, 0

				mov rcx, caseIDLength

				mov rsi, findCaseId	

				lea rdi, [patient_record + rbp + caseID]		
				cld

				inc spl

				loop1:
					cmpsb
					jne edit_loop
					loop loop1


			found:
				lea rcx, [patient_record + rbp + status]
				cld

				cmp rcx, '0'
				jne edit_valid

				mov rax, SYS_WRITE
				mov rdi, STDOUT
				mov rsi, cannotEdit
				mov rdx, cannotEditLength
				syscall
				jmp next_loop

				edit_valid:
					;print add status statment
					mov rax, SYS_WRITE
					mov rdi, STDOUT
					mov rsi, addStatus
					mov rdx, addStatusLength
					syscall

					;get input for sex
					mov rax, SYS_READ
					mov rdi, STDIN
					lea rsi, [patient_record + rbp + status]
					mov rdx, 2
					syscall


			not_found:
				mov rax, SYS_WRITE
				mov rdi, STDOUT
				mov rsi, cannotFind
				mov rdx, cannotFindPrompt
				syscall

				jmp next_loop


		print_Patient:
			mov rbp, 0
			mov rsp, 0
			mov rax, 0
			print_loop:
				;print until spl >= patient_cnt
				cmp spl, byte[patient_cnt]
				jge next_loop
				
				;for indexing
				mov bpl, spl
				mov al, patient
				mul bpl
				mov bpl, al

				;print case label
				mov rax, SYS_WRITE
				mov rdi, STDOUT
				mov rsi, printCase
				mov rdx, printCaseLength
				syscall

				;print case
				mov rax, SYS_WRITE
				mov rdi, STDOUT
				lea rsi, [patient_record + rbp +caseID]
				mov rdx, caseIDLength
				syscall


				mov rax, SYS_WRITE
				mov rdi, STDOUT
				mov rsi, printSex
				mov rdx, printSexLength
				syscall

				mov rax, SYS_WRITE
				mov rdi, STDOUT
				lea rsi, [patient_record + rbp + sex]
				mov rdx, 1
				syscall


				mov rax, SYS_WRITE
				mov rdi, STDOUT
				mov rsi, printStatus
				mov rdx, printStatusLength
				syscall

				mov rax, SYS_WRITE
				mov rdi, STDOUT
				lea rsi, [patient_record + rbp + status]
				mov rdx, 1
				syscall

				mov rax, SYS_WRITE
				mov rdi, STDOUT
				mov rsi, printDate
				mov rdx, printDateLength
				syscall

				mov rax, SYS_WRITE
				mov rdi, STDOUT
				lea rsi, [patient_record + rbp + date]
				mov rdx, 11
				syscall

				mov rax, SYS_WRITE
				mov rdi, STDOUT
				mov rsi, newLine
				mov rdx, newLineLength
				syscall

				inc spl
				jmp print_loop


		patient_full:
			mov rax, SYS_WRITE
			mov rdi, STDOUT
			mov rsi, fullPrompt
			mov rdx, fullPromptLength
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
	mov rax, 60
	xor rdi, rdi
	syscall