# Hello World Assembly Code Breakdown

## Table of Contents
  - [db](#db)
    - [db Breakdown](#db-breakdown)
    - [db Summary](#db-summary)
  - [Registers](#registers)
  - [System Call](#system-call)
    - [System Call Inputs by Register](#system-call-inputs-by-register)
    - [System Call List](#system-call-list)
    - [sys\_write](#sys_write)
    - [sys\_exit](#sys_exit)
  - [Sections](#sections)
  - [Labels](#labels)
  - [The "Start" Label](#the-"start"-label)
  - [Global](#global)

## db
Example:
  ```assembly
  text db "Hello, World!",10
  ```
### db Breakdown
"**db**" stands for "define bytes".
It essentially means that we are going to _define_ some raw _bytes_ of data
to insert into our code.

**"Hello, World",10**
These are the bytes of data we are defining.
Each character in the string of text is a single byte.
(e.g., "H" is a byte, "e" is a byte, "l" is a byte, and so on ...)

The "10" is a newline character, which I often denote as "\n".
"10" is the value of the newline character.

**text**
This is a name assigned to the address in memory that this data is located in.
Whenever we use "text" later in the code, when the code is compiled,
the compiler will determine the actual location in memory of this data and
replace all future instances of "text" with that memory address.

### db Summary
**text**: Name of the memory address.
**db**: "define bytes".
**"Hello, World!",10**: Defined bytes.

## Registers
Registers are part of the processor that temporarily holds memory.

In the x86\_64 architecture, registers hold 64 bits.

This means each register can hold values:
  Unsigned: 0 				-- 18,446,744,073,709,551,616
  Signed:   -9,223,372,036,854,775,808	-- 9,223,372,036,854,775,807

| 8-bit | 16-bit | 32-bit | 64-bit |
|-------|--------|--------|--------|
| al    | ax     | eax    | rax    |
| bl    | bx     | ebx    | rbx    |
| cl    | cx     | ecx    | rcx    |
| dl    | dx     | edx    | rdx    |
| sil   | si     | esi    | rsi    |
| dil   | di     | edi    | rdi    |
| bpl   | bp     | ebp    | rbp    |
| spl   | sp     | esp    | rsp    |
| r8b   | r8w    | r8d    | r8     |
| r9b   | r9w    | r9d    | r9     |
| r10b  | r10w   | r10d   | r10    |
| r11b  | r11w   | r11d   | r11    |
| r12b  | r12w   | r12d   | r12    |
| r13b  | r13w   | r13d   | r13    |
| r14b  | r14w   | r14d   | r14    |
| r15b  | r15w   | r15d   | r15    |

## System Call
A **system call**, or a **syscall**, is when a program requests a service
from the **kernel**.

System calls will differ by operating system, because different operating
systems use different kernels.

All syscalls have an ID associated with them (a number).

Syscalls also take **arguments**, meaning, a list of inputs. 

### System Call Inputs by Register
| Argument | Registers |
|----------|-----------|
| ID       | rax       |
| 1        | rdi       |
| 2        | rsi       |
| 3        | rdx       |
| 4        | r10       |
| 5        | r8        |
| 6        | r9        |

If you want to use a syscall, you would load the **ID** in the **rax** register
and it loads your arguments from 1 to 6, then you would use your _syscall_.

### System Call List
| syscall    | ID  | ARG1            | ARG2    | ARG3   | ARG4 | ARG5 | ARG6 |
|------------|-----|-----------------|---------|--------|------|------|------|
| sys\_read  | 0   | #filedescriptor | $buffer | #count | ...  | ...  | ...  |
| sys\_write | 1   | #filedescriptor | $buffer | #count | ...  | ...  | ...  |
| sys\_open  | 2   | $filename       | #flags  | #mode  | ...  | ...  | ...  |
| sys\_close | 3   | #filedescriptor | ...     | ...    | ...  | ...  | ...  |
| ...        | ... | ...             | ...     | ...    | ...  | ...  | ...  |
| pwritev2   | 328 | ...             | ...     | ...    | ...  | ...  | ...  |

**#**: Means that the argument is a number, which means it's coming directly from a register.
**$**: Means it's coming from a register, but it's not the actual value. It's the memory address to the data.

### sys\_write
Suppose we want to write "Hello, World!\n" to the screen...

| Argument Type   | Argument Description                                               |
|-----------------|--------------------------------------------------------------------|
| File Descriptor | 0 (Standard Input),<br>1 (Standard Output),<br>2 (Standard Error)  |
| Buffer          | Location of string to write                                        |
| Count           | Length of string                                                   |

If you want to write text into the screen, you're going to need to use _Standard Output_.
Your _Buffer_ is your memory address of the string of data you want to write into the screen.
_Count_ is the length of the string, or in another words: "How many bytes in your string".

| Argument | Registers |
|----------|-----------|
| ID       | rax       |
| 1        | rdi       |
| 2        | rsi       |
| 3        | rdx       |
| 4        | r10       |
| 5        | r8        |
| 6        | r9        |

  ```assembly
  _start:
  	mov rax, 1
	mov rdi, 1
	mov rsi, text
	mov rdx, 14
	syscall
  ```

| syscall     | rax  | rdi | rsi  | rdx | r10  | r8   | r9   |
|-------------|------|-----|------|-----|------|------|------|
| sys\_write  | 1    | 1   | ADDR | 14  | ...  | ...  | ...  |

The _rax_ register should hold the value 1 (the sys\_write ID).
The _rdi_ register should hold our file descriptor (1 if Standard Output).
The _rsi_ register should hold the value of the location of our string of data. -- text here is going
to be converted into the memory address after the assmebly code is compiled.
The _rdx_ register should hold the length of the string of data.

_mov_ in assembly means to move the data around to the register.
Once you're done with moving values to the registers, then you use _syscall_.

### sys\_exit
  ```assembly
 	mov rax, 60
	mov rdi, 0
	syscall
  ```

| syscall   | rax  | rdi | rsi  | rdx | r10  | r8   | r9   |
|-----------|------|-----|------|-----|------|------|------|
| sys\_exit | 60   | 0   | ADDR | 14  | ...  | ...  | ...  |

The _rax_ gets the ID of the _sys\_exit_ syscall, which is 60.
The _rdi_ here takes the #errorcode, which is 0 in our case because there is no error. (it could be any value)
Then we're done with moving the values to the register, so we're going to use _syscall_.


## Sections
All x86\_64 assembly files have three sections,
  - The "**.data**" section.
  - The "**.bss**" section.
  - The "**.text**" section.

The _data section_ is where all data is defined before compilation.
  ```assembly
  section .data
  	text db "Hello, World!\n",10
  ```

The _bss section_ is where data is allocated for future use.

The _text section_ is where the actual code goes.
  ```assembly
  section .text
  	  global _start
  ```

## Labels

A "label" is used to _label_ a part of code.

Upon compilation, the compiler will calculate the location in which the label will sit in memory.

Any time the name of the label is used afterwards, that name is replaced by the location in memory
by compiler.

## The "Start" Label

The "\_start" label is essential for all programs.

  ```assembly
  _start:
  	mov rax, 1
	mov rdi, 1
	mov rsi, text
	mov rdx, 14
	syscall

 	mov rax, 60
	mov rdi, 0
	syscall
  ```

When your program is compiled and later executed, it is executed first at the location of "\_start".

If the linker cannot find "\_start", it will throw an error.

## Global

The word "global" is used when you want the linker to be able to know the
address of some label.

  ```assembly
  section .text
  	  global _start
  ```

The object file generated will contain a link to every label declared "global".

In this case, we have to declare "\_start" as global since it is required for the
code to be properly linked.
