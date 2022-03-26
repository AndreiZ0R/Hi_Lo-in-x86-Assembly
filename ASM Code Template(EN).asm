.386
.model flat, stdcall


; including libraries and external procedures
includelib msvcrt.lib
extern exit: proc



; symbol start: from here the code will get executed
public start

; data section(variables)
.data
; here we declare everything we need to use in our program


.code
start:
	; here we write the code
	
	
	; ending of our code and program
	push 0
	call exit
end start
