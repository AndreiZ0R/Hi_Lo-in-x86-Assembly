.586                          ; .586 or higher is required for rdtsc function to work
.model flat, stdcall


includelib msvcrt.lib         ; the lib and all the required files are found in the repo
extern exit: proc             ; we're basically exporting the exit, printf and scanf functions from c
extern printf: proc           ; which are implemented in the msvcrt.lib library
extern scanf: proc


public start                  ; start of our program

.data                         ; data section, where we declare variables and other utilities
format db "%d", 0
randomNum dd 0
msg_higher db "Higher!",13, 10, 0
msg_lower db "Lower!",13, 10, 0
msg_input db "Your guess: ", 0
msg_done db 13,10, "Number of tries: %d", 0
msg_init db "--Pick a number from 1 to %d--",13, 10, 0
guess dd 0

limit dw 20                                     ; modify this as you please
.code                                           ; start of our code section, where is the implementation
start:
	rdtsc					; this function loads the computer timestap into to edx:eax registers
	xor edx, edx	                        ; initialising edx with 0, we only need eax
	div limit				; this expands to eax = eax / limit and edx = edx % limit, so edx will be our random number
	inc edx					; i'll add one since our play-range is 1 to limit
	
	mov randomNum, edx			; putting the result into a variable
	xor ebx, ebx				; ebx = 0
	mov bx, limit				; bx = limit. Can't use ebx because limit it's not a double word
	
	push ebx				; this sequence displays the game's play range
	push offset msg_init
	call printf
	add esp, 8                              ; this will clean up the stack to it's initial value: 2*4 bytes (esp -> stack pointer register)
	
	xor esi, esi			        ; esi will be our number of tries
	game:
		push offset msg_input		; the next sequence will display the "Your guess" message and waiting for input
		call printf
		add esp, 4
	
		push offset guess	        ; here we're getting the user input 
		push offset format
		call scanf
		add esp, 8
		
		inc esi			        ; we're counting up the tries
		mov ebx, guess		        ; we place the input in a register so we can compare it with our randomNumber
	
	
		cmp ebx, randomNum			        ; here is the comparation
		je done						; (je - jump if equal) if we guessed the number, we ca go to the end of the program
		jl higher					; (jl - jump if lower) if our number is lower than the randomNumber, we will go to the high section
		jg lower					; (gj - jump if greater) if our number is greater than the randomNumber, we will go to the low section

		higher:
			push offset msg_higher	; we will print to console "Higher!"
			call printf
			add esp, 4
			jmp game				; after the print and stack cleaning, we will jump to our game section to get another user input
		lower:
			push offset msg_lower	; prints "Lower!"
			call printf
			add esp, 4
			jmp game				; same as the higher section
	
	done:
		push esi				
		push offset msg_done		                ; if we are done, we can display the user number of tries
		call printf
		add esp, 8
	
	
	push 0                  ; we're closing the console
	call exit
end start
