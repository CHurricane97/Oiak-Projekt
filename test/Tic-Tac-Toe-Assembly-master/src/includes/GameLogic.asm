; Basically handles the turns of each player until game reaches a conclusion
; Also Checks if game has reached a conclusion
; Input: None
; Output: None
Game_Loop:

    ; prompt X for position where to place the token
    Call_Placement_Prompt_For_X:
        call Placement_Prompt_For_X
    
    ; If token placement fails reprompt else continue
    cmp eax, 1
    jne Call_Placement_Prompt_For_X

    ; increment number of tokens placed in memory
    mov eax, [tokens_placed]
    inc eax
    mov [tokens_placed], eax


    ; Print the state of the board after X places its token
    call Print_Board
    ; check if game has reached a conclusion
    call Check_Board_For_Win_Or_Draw

    
    ; prompt O for position where to place the token
    Call_Placement_Prompt_For_O:
        call Placement_Prompt_For_O

    
    ; If token placement fails reprompt else continue
    cmp eax, 1 
    jne Call_Placement_Prompt_For_O


    ; increment number of tokens placed in memory
    mov eax, [tokens_placed]
    inc eax
    mov [tokens_placed], eax

    call Print_Board
    
    ; check if game has reached a conclusion
    call Check_Board_For_Win_Or_Draw


    ; go to start of loop
    jmp Game_Loop

Game_Loop_Exit:
ret







; Checks if game has reached a conclustion i.e. X/O wins or there is a draw
; If conclusion is reached it is printed on the screen and game terminates
; Input: None
; Output: None

Check_Board_For_Win_Or_Draw:
    call Check_All_Rows_For_Win             ;check all rows
    call Check_All_Cols_For_Win             ;check all columns
    call Check_Both_Diagonals_For_Win       ;check both diagonals
    call Check_Draw
    ret






; Checks if game has reached a drawn state
; If game is drawn result is printed on screen and game terminates
; Input: None
; Output: None
Check_Draw: 
    movzx eax, byte[tokens_placed]      ;get number of tokens placed on board so far
    cmp eax, 9                          ;check if number of tokens placed on board so far = 9 
    je Declare_Draw_And_Exit            ;if yes its a draw so print result and exit
    ret







; Inspects all rows to see if some player has won i.e. if there are 3 same symbols in a row
; If any player wins result is printed on screen and game terminates
; Input: None
; Output: None
Check_All_Rows_For_Win:
    mov ecx, 3              ;intialize the counter

    ; loop through each row
    Board_Row_Loop:
        ; check row number ecx if it contains all x
        push ecx            
        mov edx,ecx         
        sub edx, 1          ;set the edx(row no.) paramter for Row_Check (sub 1 because Row_Check row no start at 0)
        mov esi, x_symbol   ;set the esi(symbol to check) paramter for Row_Check    
        call Row_Check

        pop ecx
        push ecx

        ; check row number ecx if it contains all O
        mov edx,ecx
        sub edx, 1          ;set the edx(row no.) paramter for Row_Check
        mov esi, o_symbol   ;set the esi(symbol to check) paramter for Row_Check    
        call Row_Check
        pop ecx
    loop Board_Row_Loop
    ret






; Checks each column in a row if all of them contains the symbol contained in ESI
; If they do then the player with given symbol (passed in ESI) is declared the winner and game ends
; Input: EDX=number of row to check (starting at 0)
;        ESI=Character to check for
; Output: None
Row_Check:
    ;loads the characeter into memory
    mov bl,byte[esi]
    mov ecx, 3
    imul edx, 3
    
    ; loop over each column in the row
    Row_Col_Check_Lo:
        push ecx

        ;sets ecx = next box address in memory to check
        sub ecx,1
        add ecx, edx
        add ecx, board

        ; if current column being looped over doesnt contain the symbol
        ; no further scanning required as game would still be in progress
        ; so jump out of loop in that case
        cmp byte[ecx], bl
        pop ecx
        jne Not_Match_Row


    loop Row_Col_Check_Lo
    
    ; if loop finishes in entirety that means all columns of a row matched
    ; so declare the winner and terminate
    cmp byte[x_symbol], bl
    je Declare_Win_Player_X_And_Exit
    jne Declare_Win_Player_Y_And_Exit
        

    Not_Match_Row:
    ret 




; Inspects all Columns to see if some player has won i.e. if there are 3 same symbols in a row
; If any player wins result is printed on screen and game terminates
; Input: None
; Output: None
Check_All_Cols_For_Win:
    mov ecx, 3
    ; loop over each column and check for win
    Board_Col_Loop:
        push ecx
        
        mov edx,ecx
        sub edx, 1          ;set the edx(row no.) paramter for Column_Check (sub 1 because Column_Check row no start at 0)
        mov esi, x_symbol   ;set the esi(symbol to check) paramter for Column_Check    
        call Column_Check   ;check given column for all X

        pop ecx
        push ecx

        ;check given column for all O in a similar way
        mov edx,ecx
        sub edx, 1
        mov esi, o_symbol
        call Column_Check


        pop ecx
    loop Board_Col_Loop
    ret




; Checks given column in all rows if all of them contains the symbol contained in ESI
; If they do then the player with given symbol (passed in ESI) is declared the winner and game ends
; Input: EDX=number of column to check starting 0 
;       ESI=Character to check for win
; Output: None
Column_Check:
    ;loads the characeter into memory
    mov bl,byte[esi]
    mov ecx, 3 
    
    ; loop over the given column in all rows
    Col_Row_Check_Lo:
        push ecx

        ;sets ecx = next box address in memory to check
        sub ecx,1
        imul ecx, 3
        add ecx, edx
        add ecx, board


        ; if current row being looped over doesnt contain the symbol
        ; no further scanning required as game would still be in progress
        ; so jump out of loop in that case
        cmp byte[ecx], bl
        pop ecx
        jne Not_Match_Col


    loop Col_Row_Check_Lo

    cmp byte[x_symbol], bl
    je Declare_Win_Player_X_And_Exit
    jne Declare_Win_Player_Y_And_Exit


    Not_Match_Col:
    ret 





; Inspects both diagonals to see if some player has won i.e. if there are 3 same symbols in a diagonal
; If any player wins result is printed on screen and game terminates
; Input: None
; Output: None
Check_Both_Diagonals_For_Win:
    mov esi, x_symbol
    call Check_Diagonal_1
    mov esi, o_symbol
    call Check_Diagonal_1

    mov esi, x_symbol
    call Check_Diagonal_2
    mov esi, o_symbol
    call Check_Diagonal_2
    ret






; Checks if all boxes in diagonal \ contains same symbol as contained in ESI
; If they do then the player with given symbol (passed in ESI) is declared the winner and game ends
; Diagonal 1 check \
; Input: ESI=Symbol to Check for in the diagonal
; Output: none
Check_Diagonal_1:
    ;loads the characeter into memory
    mov bl,byte[esi]

    mov ecx, 3

    Diag_1_Check_Lo:
        push ecx
        ;sets ecx = next box address in memory to check
        sub ecx, 1
        imul ecx, 4
        add ecx, board

        ; if current diagonal being looped over doesnt contain the symbol
        ; no further scanning required as game would still be in progress
        ; so jump out of loop in that case
        cmp byte[ecx], bl
        pop ecx
        jne No_Match_Diag_1
 

    loop Diag_1_Check_Lo
 
    ; if loop finishes in entirety that means the given diagonal all symbols matched
    ; so declare the winner and terminate
    cmp byte[x_symbol], bl
    je Declare_Win_Player_X_And_Exit
    jne Declare_Win_Player_Y_And_Exit

    No_Match_Diag_1:
    ret







; Checks if all boxes in diagonal / contains same symbol as contained in ESI
; If they do then the player with given symbol (passed in ESI) is declared the winner and game ends
; Input: ESI=Symbol to Check for in the diagonal
; Output: none
Check_Diagonal_2:    
;loads the characeter into memory
; 3 2 1     6 4 2
    mov bl,byte[esi]
    mov ecx, 3
    Diag_2_Check_Lo:
        push ecx
         
        ;sets ecx = next box address in memory to check
        imul ecx, 2 
        add ecx, board

        ; if current diagonal being looped over doesnt contain the symbol
        ; no further scanning required as game would still be in progress
        ; so jump out of loop in that case
        cmp byte[ecx], bl
        pop ecx
        jne No_Match_Diag_2
 
    loop Diag_2_Check_Lo

    ; if loop finishes in entirety that means the given diagonal all symbols matched
    ; so declare the winner and terminate
    cmp byte[x_symbol], bl
    je Declare_Win_Player_X_And_Exit
    jne Declare_Win_Player_Y_And_Exit

    No_Match_Diag_2:
    ret