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
	input 			db 13, 10, 'Input value: '
	firstNewNumb 	db 13, 10, 'The first new number:                                   '
	secondNewNumb 	db 13, 10, 'The second new number:                                  '
	logMult 		db 13, 10, 'The result of the logical multiplication:               '
	changPls 		db 13, 10, 'The result of changing the digits to the opposite ones: '
	result 			db 13, 10, 'Result: '
	buf1 			db BSIZE dup(?)
	buf2 			db BSIZE dup(?)
	one 			db '1'
	zero 			db '0'
	i 				db 0
	LvL 			db 0
	
.data?
	val1 	db ?
	val2 	db ?
	val12 	db ?
	val13 	db ?
	val21 	db ?
	val22 	db ?
	res 	db ?
	res1 	db ?
	res2 	db ?
	temp 	db ?
	stdout 	dd ?
	stdin	dd ?
	cRead 	dd ?
	viv 	db ?
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
		
		ComputingHalf:
			mov ebx, offset buf1
			mov i, 0
			cycl1:
				mov al, val1
				mov val12, al
				mov al, val1
				mov val13, al
				
				shr val12, 1
				shl val12, 1
				
				mov al, val12
				xor val13, al
				mov al, val13
				mov [ebx], al
				inc ebx
				
				cmp i, 7
					je go1
				
				add i, 1
				shr val1, 1
				jmp cycl1
			go1:
			mov ebx, offset buf2
			mov i, 0
			cycl2:
				mov al, val2
				mov val21, al
				mov al, val2
				mov val22, al
				
				shr val21, 1
				shl val21, 1
				
				mov al, val21
				xor val22, al
				mov al, val22
				mov [ebx], al
				inc ebx
				
				cmp i, 7
					je go2
				
				add i, 1
				shr val2, 1
				jmp cycl2
			go2:
			
			;формирование 1-го нового числа
			firstNewNumber:
				xor eax, eax
				mov al, buf1+7
				shl al, 1
				add al, buf2+6
				shl al, 1
				add al, buf1+5
				shl al, 1
				add al, buf2+4
				shl al, 1
				add al, buf1+3
				shl al, 1
				add al, buf2+2
				shl al, 1
				add al, buf1+1
				shl al, 1
				add al, buf2
				mov res1, al
				invoke WriteConsole, stdout, ADDR firstNewNumb, sizeof firstNewNumb, 0, 0
				inc LvL
				mov al, res1
				mov viv, al
				jmp writeNumb
			
			;формирование 2-го нового числа
			secondNewNumber:
				xor eax, eax
				mov al, buf2+7
				shl al, 1
				add al, buf1+6
				shl al, 1
				add al, buf2+5
				shl al, 1
				add al, buf1+4
				shl al, 1
				add al, buf2+3
				shl al, 1
				add al, buf1+2
				shl al, 1
				add al, buf2+1
				shl al, 1
				add al, buf1
				mov res2, al
				invoke WriteConsole, stdout, ADDR secondNewNumb, sizeof secondNewNumb, 0, 0
				inc LvL
				mov al, res2
				mov viv, al
				jmp writeNumb
			
			;логическое умножение
			logMultiplication:
				mov bl,res2
				mov i, 0
				cycl3:
					xor al, al
					mov al, res
					add al, res1
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
			startWriteBinary:
				inc i
				cmp i, 8
					jg whatLvL
				rol viv, 1
					jc printOne
				jmp printZero
				printOne:
					invoke WriteConsole, stdout, addr one, 1, 0, 0
					jmp startWriteBinary
				printZero:
					invoke WriteConsole, stdout, addr zero, 1, 0, 0
					jmp startWriteBinary
		
		;лифт на нужный уровень после вывода результата вычислений в том или ином блоке	
		whatLvL:
			cmp LvL, 1
				je secondNewNumber
			cmp LvL, 2
				je logMultiplication
			cmp LvL, 3
				je changPlace
			cmp LvL, 4
				invoke WriteConsole, stdout, ADDR newline, sizeof newline, 0, 0
	end start