.386
.model flat, stdcall
option casemap :none
include includes\windows.inc
include includes\masm32.inc
include includes\kernel32.inc
include includes\macros\macros.asm
include includes\msvcrt.inc
includelib includes\masm32.lib
includelib includes\kernel32.lib
includelib includes\msvcrt.lib


.data
	i 							dd 0
	str_number 					db 1
	symbols_read 				dd 0
	symbols_writ	 			dd 0
	inp_buf 					db 256 dup (?)
	out_buf 					db 256 dup (?)
	outBufWithEnStr 			db 256 dup (?)
	wordBuf 					db 31 dup (?)
	in_txt 						db 'in.txt', 0
	out_txt 					db 'out.txt', 0
	error 						db 'Error', 13, 10, 0
	wordLen 					db ?
	spaceOr1310 				db ?
	FileIn 						dd ?
	FileOut 					dd ?
	fileSize					dd ?
	stdOut 						dd ?
	firstNumb 					db ?
	secondNumb 					db ?
	FileSize 					dd ?

.code
WriteWordLength proc
		mov edi, offset out_buf
		add edi, symbols_writ
		mov al, wordLen					; сколько цифр нужно написать
		cmp al, 9
			jg wordDvyznachnoe
		add al, 30h				
		stosb							; число однозначное - записываем
		inc symbols_writ
		jmp writeSpace	
	wordDvyznachnoe:
		xor eax, eax
		mov al, wordLen
		mov bl, 10			
		div bl	; деление на 10
		mov firstNumb , al
		mov secondNumb , ah	
		add firstNumb , 30h
		add secondNumb, 30h
		mov al, firstNumb
		stosb
		mov al, secondNumb 
		stosb
		add symbols_writ, 2
	writeSpace:
		cmp spaceOr1310, ' '
			jne itWas1310
		
		mov al, ' '
		stosb
		inc symbols_writ
		jmp pointer
	itWas1310:
		mov al, 13
		stosb
		lodsb
		stosb
		add symbols_writ, 2
		inc symbols_read 
		dec FileSize
	pointer:
		mov edi, offset wordBuf
		mov wordLen, 0
	ret
WriteWordLength endp



WriteWholeWord proc
		mov esi, offset wordBuf 		
		mov edi, offset out_buf
		add edi, symbols_writ			
		movsb
		movsb
		movsb
		movsb
		movsb	
		add symbols_writ, 5
	writeSpace:
		cmp spaceOr1310, ' '
			jne itWas1310
		mov al, ' '
		stosb
		inc symbols_writ
		jmp pointer
	itWas1310:
		mov al, 13
		stosb
		mov al, 10
		stosb
		add symbols_writ, 2
		inc symbols_read 
		dec FileSize
	pointer:
		mov esi, offset inp_buf
		add esi, symbols_read 
		mov edi, offset wordBuf
		mov wordLen, 0	
	ret
WriteWholeWord endp



CountUpChars proc	
		mov esi, offset inp_buf 		; входной буффера
		mov edi, offset wordBuf			; выходной буффера
		mov wordLen, 0					; длина слова
		mov symbols_read , 0			; сколько считали символов
		mov symbols_writ, 0				; сколько написали символов
		
		cycl1:	
			lodsb
			mov spaceOr1310, al
			inc symbols_read 
			cmp al, 13
				je itsEndOfTheString
			cmp al, ' '
				jne itsNotSpace
		itsEndOfTheString:		
			cmp wordLen, 5
				je writeWholeWord
			invoke WriteWordLength
			jmp metka
		writeWholeWord:
			invoke	WriteWholeWord
			jmp metka		
		itsNotSpace:		
			stosb
			inc wordLen
		metka:											
			dec FileSize
			cmp FileSize, 0
				jne cycl1	
			cmp wordLen, 5
				je writeWholeWord2
			invoke WriteWordLength
			jmp back
			writeWholeWord2:
				invoke WriteWholeWord
	back:			
		ret
CountUpChars endp


GiveNumbersToStrings proc
		mov eax, symbols_writ
		mov FileSize, eax		
		mov esi, offset out_buf
		mov edi, offset outBufWithEnStr
		mov str_number, 1
		mov al, str_number
		inc str_number
		add al, 30h
		stosb
		mov al, ')'
		stosb
		mov al, ' '
		stosb
		add symbols_writ, 3
	cycl2:
		lodsb
		cmp al, 10
			jne go	
		stosb
		mov al, str_number
		inc str_number
		add al, 30h
		stosb
		mov al, ')'
		stosb
		mov al, ' '
		stosb
		add symbols_writ, 3	
		jmp goOnWithoutStosb
	go:	
		stosb
	goOnWithoutStosb:
		dec FileSize
		cmp FileSize, 0
			jne cycl2
		ret
GiveNumbersToStrings endp	
		
start:
	invoke CreateFileA, addr in_txt , GENERIC_READ, 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	mov FileIn, eax
	cmp FileIn, INVALID_HANDLE_VALUE
		je errorOpen
	invoke GetFileSize, eax, 0
	mov fileSize, eax ;основная
	mov FileSize, eax ;изменяемая
	invoke ReadFile, FileIn, offset inp_buf, fileSize, 0, 0
	; заполняем выходной буфер outBuf
	invoke CountUpChars
	invoke GiveNumbersToStrings
	invoke CreateFileA, addr out_txt, GENERIC_WRITE, 0, 0, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
	mov FileOut, eax
	; записываем буфер в файл и закрываем
	invoke WriteFile, FileOut, offset outBufWithEnStr, symbols_writ, 0, 0
	invoke CloseHandle, FileOut
	jmp Endd	
errorOpen:
	invoke crt_printf, offset error 	
Endd:	
	exit
end start
