;https://stackoverflow.com/a/19312503
STRING_TERMINATOR equ 0

; Converts and string to an integer 
; Input:
; ESI = pointer to the string to convert
; ECX = number of digits in the string (must be > 0)
; Output:
; EAX = integer value
String_To_Integer:
  xor ebx,ebx    ; clear ebx
.next_digit:
  movzx eax,byte[esi]
  inc esi
  sub al,'0'    ; convert from ASCII to number
  imul ebx,10
  add ebx,eax   ; ebx = ebx*10 + eax
  loop .next_digit  ; while (--ecx)
  mov eax,ebx
  ret

; Converts and integer to a string 
; Input:  EAX = integer value to convert
;         ESI = pointer to buffer to store the string in (must have room for at least 10 bytes)
;
; Output: EAX = pointer to the first character of the generated string
Integer_To_String:
  add esi,9
  mov byte [esi],STRING_TERMINATOR

  mov ebx,10         
.next_digit:
  xor edx,edx         ; Clear edx prior to dividing edx:eax by ebx
  div ebx             ; eax /= 10
  add dl,'0'          ; Convert the remainder to ASCII 
  dec esi             ; store characters in reverse order
  mov [esi],dl
  test eax,eax            
  jnz .next_digit     ; Repeat until eax==0
  mov eax,esi
  ret

; Reads in the first character of string as an integer
; Input:
;   ESI = pointer to string to read
; Output:
;   EAX = integer value
Read_Int_In_First_Char: 
  movzx eax,byte[esi] 
  sub al,'0'     
  ret