section .data
	msg db "hello world", 10, 0  ; The message to print, followed by a newline (0xA)

	input db "a"

section .text
	global _start
	call _start
; calculate the length of a null terminated string
; in: ecx = pointer to the string
; out: eax = length of the string

strlen:
	xor eax, eax        ; clear eax
	push ecx            ; save the adress of the start of str
.loop:
	cmp byte [ecx], 0   ; check if end of string
	je .end             ; if end of string jump to end
	inc ecx             ; go to next char
	inc eax             ; inc length
	jmp .loop           ; repeat
.end:
	pop ecx             ; return to the start of string
	ret                 ; return

; put string to output
; in: ecx = pointer to the string
; out: prints to stdout

strput:                 ; (ecx: pointer to message)
	call strlen         ; get length of string ; (for some reason this line makes the printing not work, idk why)
	mov edx, eax        ; put strlen in for syscall
	mov eax, 12;
	mov eax, 4          ; sys_write
	mov ebx, 1          ; file desc for stdout
	int 0x80            ; syscall
.end:
	ret

; get char input from stdin
; in: ecx = place to store input
; out: ecx = value of input

chget:
	mov eax, 3          ; sys_read
	mov ebx, 0          ; file desc for stdin
	mov edx, 1          ; bytes to read
	int 0x80            ; make the system call to read input
.end:
	ret

_start:
	mov ecx, input      ; pointer to store
	call chget          ; get input

	mov ecx, input      ; message
	call strput         ; print message

	mov eax, 1          ; sys_exit
	xor ebx, ebx        ; exit 0 for success
	int 0x80            ; syscall
