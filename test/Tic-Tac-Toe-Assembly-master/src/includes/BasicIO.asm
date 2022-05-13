; Prints the text to the screen
; Input:
;   ecx=memory reference to the text
;   edx=length of the text to Print
; Output:
;   none
Print:
    mov     eax, 4          ;syswrite
    mov     ebx, 1          ;stdout 1 | stderr 3
    int     80H 
    ret


; Reads the keyboard input into a buffer
; Input
;   ecx = input buffer
; Output:
;   buffer = string read into the buffer referenced by ecx
;   eax = length of the string read
Read_Input:
    mov     eax, 3          ;sysread
    mov     ebx, 0          ;stdin
    mov     edx, 50
    int     80H
    mov     [read_len], eax
    ret 
