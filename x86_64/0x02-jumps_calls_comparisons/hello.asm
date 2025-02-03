section .data
	text db "Hello, World!",10

section .text
	global _start

_start:
	mov rax, 1	;rip = x
	mov rdi, 1	;rip = x + 1
	mov rsi, text	;rip = x + 2
	mov rdx, 14	;rip = x + 3
	syscall

	mov rax, 60	;rip = x + 4
	mov rdi, 0	;rip = x + 5
	syscall
