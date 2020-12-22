.386
.model flat, stdcall
option casemap :none
	include includes\windows.inc
	include includes\user32.inc
	includelib includes\user32.lib
	include includes\kernel32.inc
	includelib includes\kernel32.lib

.data
	buffer 				byte 128 dup (0)
	printForm 			db '%d',0
	msg1310 			db 13, 10
	inputA 				db 13, 10, 'Input a: '
	inputB 				db 13, 10, 'Input b: '
	inputC 				db 13, 10, 'Input c: '
	inputD 				db 13, 10, 'Input d: '
	inputE 				db 13, 10, 'Input e: '
	inputF 				db 13, 10, 'Input f: '
	inputG 				db 13, 10, 'Input g: '
	inputH 				db 13, 10, 'Input h: '
	inputK 				db 13, 10, 'Input k: '
	inputM 				db 13, 10, 'Input m: '
	resText 			db 13, 10, 'Result: '
	currentResText 		db 13, 10, 'Current result: '
	var 				db ?
	sum					dd ?
	mult 				dd ?
	mult1 				db ?
	mult2		 		db ?
	dividend 			db ?
	divider 			db ?
	res					dd ?
	currentRes 			dd ?
	lsd 				db ?
	hsd 				db ?
	i 					db ?
	temp				db ?
	stdout 				dd ?
	stdin 				dd ?
	cRead 				dd ?
	
.code
	clearBuf proc
		invoke ReadConsoleInput, stdin, addr buffer, 2, addr cRead
	ret
	clearBuf endp

	inputNumb proc
		mov i, 0
		mov var, 0
		mov ax, 0
		mov lsd, 0
		mov hsd, 0

		startInput: ;из 5 лабы
			invoke ReadConsoleInputA, stdin, addr buffer, 128, addr cRead
			cmp [buffer + 14], 0
				je startInput
			cmp [buffer + 10], 13
				je endInputNumb
			cmp [buffer + 14], 30h
				jl startInput
			cmp [buffer + 14], 39h
				jg startInput
			cmp [buffer + 4], 1
				jne startInput
			invoke WriteConsole, stdout, addr [buffer + 14d], 1, 0, 0
			
			cmp i, 0
				jne SecondNumb
			mov al, [buffer + 14]
			sub al, 30h
			mov hsd, al
			jmp goOn
			
			SecondNumb:
				mov ah, [buffer + 14]
				sub ah, 30h
				mov lsd, ah
				
			goOn:
				inc i
				cmp i, 2
					jne startInput
		
		endInputNumb:
			mov ah, lsd
			mov al, hsd
			cmp i, 1
				je lessThan10
			mov temp, ah
			mov bl, 10
			mul bl
			add al, temp
			mov var, al
			ret
			
		lessThan10:
			mov var, al
		invoke clearBuf
	ret
	inputNumb endp

	printRes proc
		invoke WriteConsole, stdout, addr resText, sizeof resText, 0, 0
		
		mov eax, res
		mov bl, 10
		div bl
		
		mov lsd, ah
		add lsd, 30h
		mov hsd, 0
		
		; проверка на кол-во символов
		cmp res, 10
			jl onlyOneDigit
		
		mov hsd, al
		add hsd, 30h
		
		onlyOneDigit:
			invoke WriteConsole, stdout, addr hsd, sizeof hsd, 0, 0
			invoke WriteConsole, stdout, addr lsd, sizeof lsd, 0, 0
			invoke WriteConsole, stdout, addr msg1310, 2, 0, 0
	ret
	printRes endp

	printCurrentRes proc
		invoke WriteConsole, stdout, addr currentResText, sizeof currentResText, 0, 0
		
		mov eax, currentRes
		mov bl, 10
		div bl
		
		mov lsd, ah
		add lsd, 30h
		mov hsd, 0
		
		; проверка на кол-во символов
		cmp currentRes, 10
			jl onlyOneDigit
		
		mov hsd, al
		add hsd, 30h
		
		onlyOneDigit:
			invoke WriteConsole, stdout, addr hsd, sizeof hsd, 0, 0
			invoke WriteConsole, stdout, addr lsd, sizeof lsd, 0, 0
			invoke WriteConsole, stdout, addr msg1310, 2, 0, 0
	ret
	printCurrentRes endp

	start:
		invoke GetStdHandle, STD_OUTPUT_HANDLE
		mov stdout, eax
		invoke GetStdHandle, STD_INPUT_HANDLE
		mov stdin, eax
		
		
		invoke WriteConsole, stdout, addr inputA, sizeof inputA, 0, 0
		invoke inputNumb
		mov al, var
		add sum, eax
		
		invoke WriteConsole, stdout, addr inputB, sizeof inputB, 0, 0
		invoke inputNumb
		mov al, var
		add sum, eax
		
		mov eax, sum
		mov currentRes, eax
		invoke printCurrentRes
		
		
		invoke WriteConsole, stdout, addr inputC, sizeof inputF, 0, 0
		invoke inputNumb
		mov al, var
		mov mult2, al
		
		invoke WriteConsole, stdout, addr inputD, sizeof inputG, 0, 0
		invoke inputNumb
		mov al, var
		mov mult1, al
		
		mov al, mult2
		mov bl, mult1
		mul bl
		
		add mult, eax
		
		mov currentRes, eax
		invoke printCurrentRes
		
		
		mov eax, sum
		mov ebx, mult
		div ebx
		
		add res, eax
		
		mov eax, res
		mov currentRes, eax
		invoke printCurrentRes
		
		
		invoke WriteConsole, stdout, addr inputE, sizeof inputD, 0, 0
		invoke inputNumb
		mov al, var
		mov dividend, al
		
		invoke WriteConsole, stdout, addr inputF, sizeof inputE, 0, 0
		invoke inputNumb
		mov al, var
		mov divider, al
		
		mov al, dividend
		mov bl, divider
		div bl
		
		add res, eax
		
		mov eax, res
		mov currentRes, eax
		invoke printCurrentRes
		
		
		invoke WriteConsole, stdout, addr inputG, sizeof inputD, 0, 0
		invoke inputNumb
		mov al, var
		mov dividend, al
		
		invoke WriteConsole, stdout, addr inputH, sizeof inputE, 0, 0
		invoke inputNumb
		mov al, var
		mov divider, al
		
		mov al, dividend
		mov bl, divider
		div bl
		
		add res, eax
		
		mov eax, res
		mov currentRes, eax
		invoke printCurrentRes
		
		
		invoke WriteConsole, stdout, addr inputK, sizeof inputD, 0, 0
		invoke inputNumb
		mov al, var
		mov dividend, al
		
		invoke WriteConsole, stdout, addr inputM, sizeof inputE, 0, 0
		invoke inputNumb
		mov al, var
		mov divider, al
		
		mov al, dividend
		mov bl, divider
		div bl
		
		add res, eax
		mov eax, res
		mov currentRes, eax
		invoke printCurrentRes
		
		invoke printRes
	end start