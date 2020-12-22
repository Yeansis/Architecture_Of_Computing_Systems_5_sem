.386
.model flat, stdcall
	option casemap :none
	include 	includes\user32.inc
	includelib 	includes\user32.lib
	include 	includes\kernel32.inc
	includelib 	includes\kernel32.lib
	include 	includes\msvcrt.inc
	includelib 	includes\msvcrt.lib
	include 	includes\windows.inc
BSIZE equ 128
.data
	printForm 		db "%d",0
	buf byte BSIZE 	dup(0)
	newline 		db 13, 10
	input 			db 13, 10, 'Input value: 						'
	newNumber		db 13, 10, 'New number:                                   		'
	logMult 		db 13, 10, 'The result of the logical multiplication:               '
	changPls 		db 13, 10, 'The result of changing the digits to the opposite ones: '
	result 			db 13, 10, 'Result: 												'
	one 			db '1'
	zero 			db '0'
	i 				db 0
	LvL 			db 0
	numb_one 		db 1
	numb_zero 		db 0
	srav1			db 01000000b
	srav0			db 10111111b
	lvl				db 0
	
.data?
	val1 			db ?
	val2 			db ?
	val				db ?
	copyVal 		db ?
	rezVal			db ?
	res 			db ?
	temp 			db ?
	stdout 			dd ?
	stdin			dd ?
	cRead 			dd ?
	viv 			db ?
.code
	start:
		invoke GetStdHandle, STD_OUTPUT_HANDLE
		mov stdout, eax
		invoke GetStdHandle, STD_INPUT_HANDLE
		mov stdin, eax
		
		InputFirstNumb:
			;буфер консоли для ввода, буфер данных(указатель на него), число записываемых символов, число записанных символов
			invoke WriteConsole, stdout, addr input, sizeof input, 0, 0
			mov i, 0
			mov val1, 00000000b
			mov al, 0000000b
			FirstInput:
				;буфер консоли для чтения, буфер данных(указатель на него), число считываемых символов, число считанных символов
				invoke ReadConsoleInput, stdin, addr buf, 128, addr cRead
				;если ничего не вводится
				cmp [buf+14], 0
					je FirstInput
				;если зажимается Enter
				cmp [buf+10], 13
					je InputSecondNumb
				;если вводится не 0 и не 1
				cmp [buf+14], 30h
					jl FirstInput
				cmp [buf+14], 31h
					jg FirstInput
				;4 байт - клавиша нажата "1", клавиша отпущена "0"
				cmp [buf+4], 1
					jne FirstInput
				;вывод введенного символа(1 или 0)
				invoke WriteConsole, stdout, addr [buf+14], 1, 0, 0
				mov al, val1
				cmp [buf+14], 30h
					je FirstZero
				inc al
			FirstZero:
				cmp i, 7
					je FirstLast
				shl al, 1
			FirstLast:
				mov val1, al
				inc i
				cmp i, 8
					jl FirstInput
				jmp InputSecondNumb
		InputSecondNumb:
			invoke WriteConsole, stdout, addr input, sizeof input, 0, 0
			mov i, 0
			mov val2, 00000000b
			mov al, 0000000b
			
			
			SecondInput:
				invoke ReadConsoleInput, stdin, addr buf, 128, addr cRead
				cmp [buf+14], 0
					je SecondInput
				cmp [buf+10], 0dh
					je ComputingHalf
				cmp [buf+14], 30h
					jl SecondInput
				cmp [buf+14], 31h
					jg SecondInput
				cmp [buf+4], 1
					jne SecondInput
				invoke WriteConsole, stdout, addr [buf+14], 1, 0, 0
				mov al, val2
				cmp [buf+14], 30h
					je SecondZero
				inc al
			SecondZero:
				cmp i, 7
					je SecondLast
				shl al, 1
			SecondLast:
				mov val2, al
				inc i
				cmp i, 8
					jl SecondInput
				jmp ComputingHalf
		
		ComputingHalf: ;part1
			mov i, 0
			inc lvl
			cmp lvl, 1
				je cyclForVal1
			cmp lvl, 2
				je cyclForVal2
			cmp lvl, 3
				je endCycl
			cyclForVal1:
				mov al, val1
				mov copyVal, al
				mov al, val2
				mov val, al
				jmp cycl
			cyclForVal2:
				mov al, val
				mov rezVal, al
				mov al, val2
				mov copyVal, al
				mov al, val1
				mov val, al
				rol copyVal, 1
				rol val, 1
				jmp cycl
			endCycl:
				mov al, rezVal
				mov val2, al
				mov al, val
				mov val1, al
				jmp logMultiplication
			cycl:
				shl copyVal, 1
					jc yes 	;если цель 1 (в CF)
				mov al, val ;если цель 0 (в CF)
				and al, srav0  ;на цель подается 0
				mov val, al
				jmp noyes
				yes:
					mov al, val
					or al, srav1 ;01000000
					mov val, al
				noyes:
					shl copyVal, 1
					ror srav0, 2 ;01111111
					ror srav1, 2 ;10000000
					inc i
					cmp i, 4
						je endPart1
					jmp cycl
			endPart1:
				invoke WriteConsole, stdout, ADDR newNumber, sizeof newNumber, 0, 0
				inc LvL
				mov al, val
				mov viv, al
				jmp writeNumb
		
		logMultiplication:
			mov bl, val2
			mov i, 0
			cycl3:
				xor al, al
				mov al, res
				add al, val1
				mov res, al
				add i, 1
				cmp i, bl
					je go3
				jmp cycl3
			go3:		
				invoke WriteConsole, stdout, ADDR logMult, sizeof logMult, 0, 0
				inc LvL
				mov al, res
				mov viv, al
				jmp writeNumb
			
		;смена разрядов на противоположные
		changPlace:
			xor al, al
			mov al, res
			xor al, 11111111b
			mov res, al
			invoke WriteConsole, stdout, ADDR changPls, sizeof changPls, 0, 0
			inc LvL
			mov al, res
			mov viv, al
			jmp writeNumb
		
		;вывод результатов в 2 форме
		writeNumb:
			mov i, 0
			startWriteNumb:
				inc i
				cmp i, 8
					jg whatLvL
				rol viv, 1
					jc printOneNumb
				jmp printZeroNumb
				printOneNumb:
					invoke WriteConsole, stdout, addr one, 1, 0, 0
					jmp startWriteNumb
				printZeroNumb:
					invoke WriteConsole, stdout, addr zero, 1, 0, 0
					jmp startWriteNumb
		
		;лифт на нужный уровень после вывода результата вычислений в том или ином блоке	
		whatLvL:
			cmp LvL, 1
				je ComputingHalf
			cmp LvL, 2
				je ComputingHalf
			cmp LvL, 3
				je changPlace
			cmp LvL, 4
				invoke WriteConsole, stdout, ADDR newline, sizeof newline, 0, 0
	end start