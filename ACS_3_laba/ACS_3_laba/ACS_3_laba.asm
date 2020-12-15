.386
.model flat,stdcall
	option casemap:none
	include includes/kernel32.inc
	include includes/user32.inc
	includelib includes/kernel32.lib
	includelib includes/user32.lib 
BSIZE equ 15

.data
	ifmt db "%d", 0
	buf db BSIZE dup(?)
	stdout dd ?
	cWritten dd ?
	res dd ?
	
	a dd 1
	b dd 2
	cc dd 3
	d dd 4
	e dd 5
	f dd 6
	g dd 7
	h dd 8
	k dd 9
	m dd 10

.code
	start:
		mov eax, a
		add eax, b
		mov a, eax
		
		mov eax, cc
		sub eax, d
		mov cc, eax
		
		mov eax, e
		add eax, f
		mov e, eax
		
		mov eax, g
		add eax, h
		mov g, eax
		
		mov eax, k
		add eax, m
		mov k, eax
		
		mov eax, a
		add eax, cc
		add eax, e
		add eax, g
		add eax, k
		mov res, eax
		
		invoke GetStdHandle, -11
		mov stdout, eax
		invoke wsprintf, ADDR buf, ADDR ifmt, res
		invoke WriteConsoleA, stdout, ADDR buf, BSIZE, ADDR cWritten, 0
		invoke ExitProcess, 0
end start