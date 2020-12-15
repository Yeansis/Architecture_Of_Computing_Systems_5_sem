.386
.model flat,stdcall
option casemap:none
	include includes\kernel32.inc
	include includes\user32.inc
	includelib includes\kernel32.lib
	includelib includes\user32.lib
	include includes\windows.inc
	include includes\msvcrt.inc
	includelib includes\msvcrt.lib
CONST_VAR equ 1 ; a

.data
    printForm db "%d",0
    var dd 10 ; x
    y1 dd ?
    y2 dd ?
    i dd ?
    
	hConsoleOutput DWORD ?
	NumberOfCharsWritten DWORD ?
	msg1 byte "Answer:"
	msg1310 byte 13, 10
    
.code
	start:
		cmp var, 12
			jl ElsePart_jl
		cmp var, 12
			jge ElsePart_jge
		jmp EndOfIf_1
		ElsePart_jl:
			mov y1, 12
			jmp EndOfIf_1
		ElsePart_jge:
			mov eax, var
			add eax, 1
			mov y1, eax
		EndOfIf_1:
			
		cmp var, 2
			jg ElsePart_jg
		cmp var, 2
			jle ElsePart_jle
		jmp EndOfIf_2
		ElsePart_jg:
			mov y2, 2
			jmp EndOfIf_2
		ElsePart_jle:
			mov eax, var
			add eax, CONST_VAR
			mov y1, eax
		EndOfIf_2:

		mov i, 0
		cycl:
			mov eax, y1
			sub eax, y2
			mov y1, eax
			add i, 1
			cmp y1,0
			jge cycl
		sub i, 1
		
		
		invoke AllocConsole
		invoke GetStdHandle, STD_OUTPUT_HANDLE
		mov hConsoleOutput, eax
		invoke WriteConsoleA,
			hConsoleOutput,
			ADDR msg1,
			SIZEOF msg1,
			ADDR NumberOfCharsWritten,
			0
		invoke WriteConsoleA,
			hConsoleOutput,
			ADDR msg1310,
			SIZEOF msg1310,
			ADDR NumberOfCharsWritten,
			0
		invoke crt_printf, addr printForm, i
		invoke WriteConsoleA,
			hConsoleOutput,
			ADDR msg1310,
			SIZEOF msg1310,
			ADDR NumberOfCharsWritten,
			0
			
		invoke ExitProcess, 0
	end start