; Input: none
; Output: none
; Prints the game header
Print_Game_Header:
    call Print_Name_Player_X

    mov ecx, vs_text
    mov edx, vs_text_len
    call Print

    call Print_Name_Player_O

    mov ecx, new_line_token
    mov edx, new_line_token_len
    call Print
    ret




; Input: none
; Output: none
; Prints the name of Player X
Print_Name_Player_X:
    mov ecx, name_player_x
    mov edx, [name_player_x_len]
    sub edx, 1                  ; to remove newline
    call Print

    mov ecx, x_symbol_braced 
    mov edx, x_symbol_braced_len
    call Print

    ret


; Input: none
; Output: none
; Prints the name of Player O
Print_Name_Player_O:
    mov ecx, name_player_o
    mov edx, [name_player_o_len]
    sub edx, 1                  ; to remove newline
    call Print
    
    mov ecx, o_symbol_braced 
    mov edx, o_symbol_braced_len
    call Print

    ret



; Input: none
; Output: none
; Prints message stating that Player X won and exits the game

Declare_Win_Player_X_And_Exit:
    call Print_Empty_Line
    
    call Print_Name_Player_X

    mov ecx, winner_dec_text
    mov edx, winner_dec_text_len
    call Print
    jmp Exit



; Input: none
; Output: none
; Prints message stating that Player Y won and exits the game
Declare_Win_Player_Y_And_Exit:
    call Print_Empty_Line

    call Print_Name_Player_O
    
    mov ecx, winner_dec_text
    mov edx, winner_dec_text_len
    call Print
    jmp Exit



; Input: none
; Output: none
; Prints message stating that draw occured and exits the game
Declare_Draw_And_Exit:
    mov ecx, draw_text
    mov edx, draw_text_len
    call Print
    jmp Exit



; Input: none
; Output: none
; Prints an empty line

Print_Empty_Line:
    mov ecx, new_line_token
    mov edx, new_line_token_len
    call Print 
    ret