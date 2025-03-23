; A simple text editor in assembly for COFF format
.386
.MODEL flat, stdcall
.STACK 100h
option casemap:none

.DATA
    buffer DB 1024 DUP('$')   ; Buffer to store the input text
    prompt DB "Simple Text Editor", 0Dh, 0Ah, "Type your text (Press ENTER to quit): $"
    output DB 0Dh, 0Ah, "You typed:", 0Dh, 0Ah, "$"

.CODE
_START:
    ; Display the prompt
    LEA EDX, prompt
    MOV AH, 09h
    INT 21h

    ; Get user input
    LEA EDX, buffer
    MOV AH, 0Ah
    INT 21h

    ; Display the output
    LEA EDX, output
    MOV AH, 09h
    INT 21h

    ; Display the typed text
    LEA EDX, buffer + 2  ; Skip first 2 bytes (length and carriage return)
    MOV AH, 09h
    INT 21h

    ; Exit program
    MOV AH, 4Ch
    INT 21h

END _START
