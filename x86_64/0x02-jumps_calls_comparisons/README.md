# Jumps, Calls, and Comparisons

## Table of Contents
  - [Flags](#flags)
  - [Pointers](#pointers)
  - [Control Flow](#control-flow)
  - [Jumps](#jumps)
  - [Comparisons](#comparisons)
   - [Comparisons with Flags](#comparisons-with-flags)
  - [Conditional Jumps](#conditional-jumps)
    - [Conditional Jump Examples](#conditional-jump-examples)
  - [Registers as Pointers](#registers-as-pointers)
  - [Calls](#calls)

## Flags
Flags, like registers, hold data.

Flags only hold 1 bit each. They are either *true* or *false*.

Individual flags are part of a larger register.

| Flag Symbol | Description       |
|-------------|-------------------|
| CF          | Carry             |
| PF          | Parity            |
| ZF          | Zero              |
| SF          | Sign              |
| OF          | Overflow          |
| AF          | Adjust            |
| IF          | Interrupt Enabled |

## Pointers
Pointers are also registers that hold data.

They "point to" data, meaning, they hold its memory address.

| Pointer Name  | Meaning            | Description                                                |
|---------------|--------------------|------------------------------------------------------------|
| rip (eip, ip) | Index pointer      | Points to next address to be executed in the control flow. |
| rsp (esp, sp) | Stack pointer      | Points to the top address of the stack.                    |
| rbp (ebp, bp) | Stack base pointer | Points to the bottom of the stack.                         |
| ...           | ...                | ...                                                        |

The **rip** pointer (64 bit version), the _eip_ (32 bit version) and _ip_ (16 bit version).

## Control Flow
All code runs from top to bottom by default. The direction a program flows is called the control flow.

The **rip** register holds the address of the next instruction to be executed.
After each instruction, it is incremented by 1, making the control flow naturally
flow top to bottom.

## Jumps
Jumps can be used to _jump_ to different parts of code based on labels.
They are used to divert program flow.

The general format of the jump is: `jmp label`
> Loads the value "label" into the **rip** register.

Example:
  ```assembly
  _start:
  	  jmp _start
  ```
> Loads the memory address of \_start into the **rip** register.

The previous code will make the control flow change from a straight line (top-to-bottom)
into a circle (stuck in an infinite loop).


## Comparisons
Comparisons allow programs to be able to take different paths based on certain conditions.

Comparisons are done on _registers_.

The general format of a comparison is `cmp register, register/value`.

Example:
  ```assembly
  cmp rax, 23
  cmp rax, rbx
  ```

### Comparisons with Flags
After a comparison is made, certain flags are set.

|        | cmp a, b      | Notes                                                                         |
|--------|---------------|-------------------------------------------------------------------------------|
| a = b  | ZF = 1        | Zero Flag is set (set to 1)                                                   |
| a != b | ZF = 0        | Zero Flag is reset (set to 0)                                                 |
| -      | SF = msb(a-b) | The comparison is going to set the Sign Flag to most significant bit of (a-b) |
| ...    | ...           | ...                                                                           |

## Conditional Jumps
After a comparison is made, a _conditional jump_ can be made.

Conditional jumps are based on the status of the flags.

Conditional jumps in code are written just like unconditional jumps, however
**"jmp"** is replaced by the symbol for the conditional jump.

| Jump symbol (signed) | Jump symbol (unsigned) | Results of cmp a, b    |
|----------------------|------------------------|------------------------|
| je                   | -                      | a = b                  |
| jne                  | -                      | a != b                 |
| jg                   | ja                     | a > b                  |
| jge                  | jae                    | a >= b                 |
| jl                   | jb                     | a < b                  |
| jle                  | jbe                    | a <= b                 |
| jz                   | -                      | a = 0                  |
| jnz                  | -                      | a != 0                 |
| jo                   | -                      | Overflow occurred      |
| jno                  | -                      | Overflow did not occur |
| js                   | -                      | Jump if signed         |
| jns                  | -                      | Jump if not signed     |

Unsigned Jump Symbols treat _a_, and _b_ as if they are **unsigned bytes**.

### Conditional Jump Examples
  ```assembly
  cmp rax, 23
  je _doThis
  ```
This code will jump to the address of label "\_doThis" _if and only if_ the
value in the **rax** register equals (je) 23.

  ```assembly
  cmp rax, rbx
  jg _doThis
  ```
This code will jump to the address of label "\_doThis" _if and only if_ the
value in the **rax** register is greater than (jg) the value in the **rbx** register.

## Registers as Pointers
The default registers can be treated as pointers.

To treat a register as a pointer, surround the register name with square brackets,
such as, "rax" becomes "**[rax]**".

  ```assembly
  mov rax, rbx
  ```
Loads the value of the **rbx** register into the **rax** register. (Copies the value)

  ```assembly
  mov rax, [rbx]
  ```
Loads the value the **rbx** register _is pointing to_, into the **rax** register.
(It derefrences the address the **rbx** register is pointing to and retrieves the value
at this memory address, then it's assigned to the **rax** register)

## Calls
Calls and jumps are essentially the same.

However, when "call" is used, the original position when the call was made can be returned
to using "ret".

  ```assembly
  section .data
  	  text db "Hello, World!",10

  section .text
  	  global _start

  _start:

  	  call _printHello

	  mov rax, 60
	  mov rdi, 0
	  syscall

  _printHello:
  	  mov rax, 1
	  mov rdi, 1
	  mov rsi, text
	  mov rdx, 14
	  syscall
	  ret
  ```
In this modification of the "Hello, World!" code, the part of code that prints
"Hello, World!" was moved into its own section, and that section was _called_.

 ```
  _printHello:
  	  mov rax, 1
	  mov rdi, 1
	  mov rsi, text
	  mov rdx, 14
	  syscall
	  ret
 ```
This is called a _subroutine_.
