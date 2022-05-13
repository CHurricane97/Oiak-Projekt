; Places the token on the board in memory
; Input EAX=position to place the marker on
; Input ESI=Marker to place 
; Output EAX=1 if placement successful EAX=0 if it fails
Place_Token:

    ; find the position on the board
    mov dl,byte[esi]
    sub eax, 1  
    mov ecx, board
    add ecx, eax

    ; Check if the place is valid location to place token
    cmp byte[ecx], '9'
    jg Token_Placement_Error

    cmp byte[ecx], '0'
    jl Token_Placement_Error

    ; Perform the placement
    mov [ecx], dl

    mov eax, 1
    Placment_Attempt_Complete:
    ret






; Prints the error message if user tries to place token in a occupied block
; Input: none 
; Output: none
Token_Placement_Error:
    mov ecx, placement_error_txt
    mov edx, placement_error_txt_len
    call Print
    mov eax,0
    ret






; Prints the Tic-Tac-Toe board in memory to the screen
; Input: none 
; Output: none
Print_Board:
    call Print_Empty_Line
    call Print_Empty_Line
    mov ecx, 3 
    row_lo:
        push ecx
        
        mov ecx, 3
        column_lo:
            pop eax 
            push eax

            push ecx 
            cmp eax,1
            je Space_Print_Bef

            mov ecx,  underscore_symbol
            mov edx, 1
            call Print
            
            jmp Symbol_Print

            Space_Print_Bef:

                mov ecx,  space 
                mov edx, 1
                call Print 

            Symbol_Print:
            pop ecx ;col
            mov ebx, 3
            sub ebx, ecx 
 
            pop eax ;row 

            push eax
            push ecx
 
            mov  ecx, 3
            sub  ecx, eax
            imul ecx, 3
            add ecx, ebx
            mov eax, ecx  

            mov ecx,  board
            add ecx, eax
            mov edx, 1
            call Print
            
            ; this fetches row number into eax
            pop ecx
            pop eax
            push eax
            push ecx

            cmp eax, 2
            jl Space_Print_After

            mov ecx,  underscore_symbol
            mov edx, 1
            call Print
            jmp Skip_Space_Afer

            Space_Print_After:

                mov ecx,  space 
                mov edx, 1
                call Print 


            Skip_Space_Afer:
            pop ecx
            cmp ecx,1
            push ecx
            je column_lo_end

            mov ecx,  pipe_symbol
            mov edx, 1
            call Print

            column_lo_end:
            pop ecx
            
            dec ecx
            jnz column_lo
            ;loop column_lo

        mov ecx,  new_line_token
        mov edx, new_line_token_len
        call Print
        pop ecx
        
        dec ecx
        jnz row_lo

    call Print_Empty_Line
    ret