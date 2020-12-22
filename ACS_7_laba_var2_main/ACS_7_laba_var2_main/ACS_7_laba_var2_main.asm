.386
.model flat, stdcall
	option casemap :none
	include includes\windows.inc
	include includes\masm32.inc
	include includes\kernel32.inc
	include includes\macros\macros.asm
	includelib includes\masm32.lib
	includelib includes\kernel32.lib
	include includes\msvcrt.inc
	includelib includes\msvcrt.lib
.data
	printform 					db "%d", 0
	iter 						db 0
	whatNumbOrder				db 0
	forDvoich 					db 10d
	msg1310 					db 13, 10
	qwerty 						db 'Numb: ', 0
	resText 					db 13, 10, 'Result'
	currentResText1				db 13, 10, '1) Result (a+b): '
	currentResText2				db 13, 10, '2) Result c*d: '
	currentResText3				db 13, 10, '3) Result 1/2: '
	currentResText4				db 13, 10, '4) Result 1/2+e/f: '
	currentResText5				db 13, 10, '5) Result 4+g/h: '
	currentResText6				db 13, 10, '6) Result 4+k/m: '
	buf 						db 128 dup (?)
	var 						db ?
	sum							dd ?
	mult 						dd ?
	mult1 						db ?
	mult2		 				db ?
	dividend 					db ?
	divider 					db ?
	res							dd ?
	currentRes 					dd ?
	part1 						db ?
	part2						db ?
	temp						db ?
	cRead 						dd ?
	stdout 						DWORD ?
	stdin 						DWORD ?
	cWritten 					DWORD ?
	a_numb						db ?
	b_numb						db ?
	c_numb						db ?
	d_numb						db ?
	e_numb						db ?
	f_numb						db ?
	g_numb						db ?
	h_numb						db ?
	k_numb						db ?
	m_numb						db ?
	
.code
	printCurrentRes proc		
		mov eax, currentRes
		mov bl, 10
		div bl
		
		mov part1, ah
		add part1, 30h
		mov part2, 0
		
		; проверка на кол-во символов
		cmp currentRes, 10
			jl onlyOneDigit
		
		mov part2, al
		add part2, 30h
		
		onlyOneDigit:
			invoke WriteConsole, stdout, addr part2, sizeof part2, 0, 0
			invoke WriteConsole, stdout, addr part1, sizeof part1, 0, 0
			invoke WriteConsole, stdout, addr msg1310, 2, 0, 0
	ret
	printCurrentRes endp


	printRes proc
		invoke WriteConsole, stdout, addr resText, sizeof resText, 0, 0
		
		mov eax, res
		mov bl, 10
		div bl
		
		mov part1, ah
		add part1, 30h
		mov part2, 0
		
		; проверка на кол-во символов
		cmp res, 10
			jl onlyOneDigit
		
		mov part2, al
		add part2, 30h
		
		onlyOneDigit:
			invoke WriteConsole, stdout, addr part2, sizeof part2, 0, 0
			invoke WriteConsole, stdout, addr part1, sizeof part1, 0, 0
			invoke WriteConsole, stdout, addr msg1310, 2, 0, 0
	ret
printRes endp

	;cycl1:
	;	cmp whatNumbOrder, 0
	;				je for_a_numb
	;	for_a_numb:
	;				add al, [buf+14d]
	;				sub al, 31h
	;				cmp iter, 1
	;					je for_number_a
	;				mov a_numb, al
	;				inc iter
	;				jmp cycl1
	;	for_number_a:
	;				movsx eax, a_numb
	;				mul forDvoich
	;				add al, [buf+14d]
	;				sub eax, 30h
	;				mov a_numb, al
	;				jmp cycl2
	;cycl2:	
	;		cmp whatNumbOrder, 9d
	;			je endi
	;		inc whatNumbOrder
	;		invoke ReadConsoleInput, stdin, ADDR buf, sizeof buf, ADDR cWritten
	;		xor eax, eax
	;		mov iter, 0
	;		invoke WriteConsole, stdout, addr msg1310, 2, 0, 0
	;		invoke WriteConsole, stdout, ADDR [qwerty], sizeof qwerty, 0, 0
	;		jmp cycl1
	
	readingNumb proc
		invoke AllocConsole
		invoke WriteConsole, stdout, ADDR [qwerty], sizeof qwerty, 0, 0
		xor eax, eax
		cycl1:	
			invoke ReadConsoleInput, stdin, ADDR buf, sizeof buf, ADDR cWritten
			cmp [buf+10d], 0dh
				je cycl2
			cmp [buf+14d], 0
				je cycl1
			cmp [buf+14d], 30h
				jl cycl1
			cmp [buf+14d], 40h
				jnc cycl1
			cmp [buf+04d], 1h
				jne cycl1
			invoke WriteConsole, stdout, ADDR [buf+14d], 1, 0, 0
			cmp whatNumbOrder, 0
				je for_a_numb
			cmp whatNumbOrder, 1
				je for_b_numb
			cmp whatNumbOrder, 2
				je for_c_numb
			cmp whatNumbOrder, 3
				je for_d_numb
			cmp whatNumbOrder, 4
				je for_e_numb
			cmp whatNumbOrder, 5
				je for_f_numb
			cmp whatNumbOrder, 6
				je for_g_numb
			cmp whatNumbOrder, 7
				je for_h_numb
			cmp whatNumbOrder, 8
				je for_k_numb
			cmp whatNumbOrder, 9
				je for_m_numb
			for_a_numb:
				add al, [buf+14d]
				sub al, 31h
				cmp iter, 1
					je for_number_a
				mov a_numb, al
				inc iter
				jmp cycl1
			for_b_numb:
				add al, [buf+14d]
				sub al, 31h
				cmp iter, 1
					je for_number_b
				mov b_numb, al
				inc iter
				jmp cycl1
			for_c_numb:
				add al, [buf+14d]
				sub al, 31h
				cmp iter, 1
					je for_number_c
				mov c_numb, al
				inc iter
				jmp cycl1
			for_d_numb:
				add al, [buf+14d]
				sub al, 31h
				cmp iter, 1
					je for_number_d
				mov d_numb, al
				inc iter
				jmp cycl1
			for_e_numb:
				add al, [buf+14d]
				sub al, 31h
				cmp iter, 1
					je for_number_e
				mov e_numb, al
				inc iter
				jmp cycl1
			for_f_numb:
				add al, [buf+14d]
				sub al, 31h
				cmp iter, 1
					je for_number_f
				mov f_numb, al
				inc iter
				jmp cycl1
			for_g_numb:
				add al, [buf+14d]
				sub al, 31h
				cmp iter, 1
					je for_number_g
				mov g_numb, al
				inc iter
				jmp cycl1
			for_h_numb:
				add al, [buf+14d]
				sub al, 31h
				cmp iter, 1
					je for_number_h
				mov h_numb, al
				inc iter
				jmp cycl1
			for_k_numb:
				add al, [buf+14d]
				sub al, 31h
				cmp iter, 1
					je for_number_k
				mov k_numb, al
				inc iter
				jmp cycl1
			for_m_numb:
				add al, [buf+14d]
				sub al, 31h
				cmp iter, 1
					je for_number_m
				mov m_numb, al
				inc iter
				jmp cycl1
			
			for_number_a:
				movsx eax, a_numb
				mul forDvoich
				add al, [buf+14d]
				sub eax, 30h
				mov a_numb, al
				jmp cycl2
			for_number_b:
				movsx eax, b_numb
				mul forDvoich
				add al, [buf+14d]
				sub eax, 30h
				mov b_numb, al
				jmp cycl2
			for_number_c:
				movsx eax, c_numb
				mul forDvoich
				add al, [buf+14d]
				sub eax, 30h
				mov c_numb, al
				jmp cycl2
			for_number_d:
				movsx eax, d_numb
				mul forDvoich
				add al, [buf+14d]
				sub eax, 30h
				mov d_numb, al
				jmp cycl2
			for_number_e:
				movsx eax, e_numb
				mul forDvoich
				add al, [buf+14d]
				sub eax, 30h
				mov e_numb, al
				jmp cycl2
			for_number_f:
				movsx eax, f_numb
				mul forDvoich
				add al, [buf+14d]
				sub eax, 30h
				mov f_numb, al
				jmp cycl2
			for_number_g:
				movsx eax, g_numb
				mul forDvoich
				add al, [buf+14d]
				sub eax, 30h
				mov g_numb, al
				jmp cycl2
			for_number_h:
				movsx eax, h_numb
				mul forDvoich
				add al, [buf+14d]
				sub eax, 30h
				mov h_numb, al
				jmp cycl2
			for_number_k:
				movsx eax, k_numb
				mul forDvoich
				add al, [buf+14d]
				sub eax, 30h
				mov k_numb, al
				jmp cycl2
			for_number_m:
				movsx eax, m_numb
				mul forDvoich
				add al, [buf+14d]
				sub eax, 30h
				mov m_numb, al
				jmp cycl2
		cycl2:	
			cmp whatNumbOrder, 9
				je endi
			inc whatNumbOrder
			invoke ReadConsoleInput, stdin, ADDR buf, sizeof buf, ADDR cWritten
			xor eax, eax
			mov iter, 0
			invoke WriteConsole, stdout, addr msg1310, 2, 0, 0
			invoke WriteConsole, stdout, ADDR [qwerty], sizeof qwerty, 0, 0
			jmp cycl1
		endi:
	ret
	readingNumb endp


	start:
		invoke GetStdHandle, STD_INPUT_HANDLE 
		mov stdin, eax
		invoke GetStdHandle, STD_OUTPUT_HANDLE 
		mov stdout, eax
		
		invoke readingNumb
		
		mov al, a_numb
		add sum, eax
		mov al, b_numb
		add sum, eax
		mov eax, sum
		mov currentRes, eax
		invoke WriteConsole, stdout, addr currentResText1, sizeof currentResText1, 0, 0
		invoke printCurrentRes
		
		
		mov al, c_numb
		mov mult2, al
		mov al, d_numb
		mov mult1, al
		mov al, mult2
		mov bl, mult1
		mul bl
		add mult, eax
		mov currentRes, eax
		invoke WriteConsole, stdout, addr currentResText2, sizeof currentResText2, 0, 0
		invoke printCurrentRes
		
		
		mov eax, sum
		mov ebx, mult
		div ebx
		add res, eax
		mov eax, res
		mov currentRes, eax
		invoke WriteConsole, stdout, addr currentResText3, sizeof currentResText3, 0, 0
		invoke printCurrentRes
		
		
		mov al, e_numb
		mov dividend, al
		mov al, f_numb
		mov divider, al
		mov al, dividend
		mov bl, divider
		div bl
		add res, eax
		mov eax, res
		mov currentRes, eax
		invoke WriteConsole, stdout, addr currentResText4, sizeof currentResText4, 0, 0
		invoke printCurrentRes
		
		
		mov al, g_numb
		mov dividend, al
		mov al, h_numb
		mov divider, al
		mov al, dividend
		mov bl, divider
		div bl
		add res, eax
		mov eax, res
		mov currentRes, eax
		invoke WriteConsole, stdout, addr currentResText5, sizeof currentResText5, 0, 0
		invoke printCurrentRes
		
		
		mov al, k_numb
		mov dividend, al
		mov al, m_numb
		mov divider, al
		mov al, dividend
		mov bl, divider
		div bl
		add res, eax
		mov eax, res
		mov currentRes, eax
		invoke WriteConsole, stdout, addr currentResText6, sizeof currentResText6, 0, 0
		invoke printCurrentRes
		
		invoke printRes
	end start