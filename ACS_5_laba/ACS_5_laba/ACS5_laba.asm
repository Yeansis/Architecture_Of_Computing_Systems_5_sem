; Новый проект masm32 успешно создан
; Заполнен демо программой «Здравствуй, мир!»
.386
.model flat, stdcall
option casemap :none
include includes\masm32.inc
include includes\kernel32.inc
include includes\macros\macros.asm
includelib includes\masm32.lib
includelib includes\kernel32.lib
.data
	a db 10110101b
	b db 00110111b
	cc db 0
.code
start:
	not a; инвертируем первое число
	shr a,2; делим его на 4
	shl b,1; второе число умножаем на 2
	mov al, a; полученные результаты складываем
	add al, b; для сложения необходим регистр al
	xor al, 00001111b ; меняем первые четыре разряда на противоположные
	mov cc, al; результат сохраняет в cc
	
end start