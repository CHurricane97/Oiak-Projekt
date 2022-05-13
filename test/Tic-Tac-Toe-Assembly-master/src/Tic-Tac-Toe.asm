; Author:   Arsh Sekhon
; Date:     March 6, 2019


; data section
section .data
    ; user prompt
    player_name_prompt             db      "Enter name of player ", 0
    player_name_prompt_len              equ     $-player_name_prompt

    ; some symbols to be used
    colon                   db      ": "
    underscore_symbol       db     "_"
    pipe_symbol             db     "|"

    x_symbol                db     "X"
    o_symbol                db     "O"

    space                   db     " "

    x_symbol_braced         db     " (X)"
    x_symbol_braced_len     equ    $-x_symbol_braced

    o_symbol_braced         db     " (O)"
    o_symbol_braced_len     equ    $-o_symbol_braced

    
    turn_prompt_text       db     "'s turn: Please enter the position to place your sign (1-9): "
    turn_prompt_text_len   equ    $-turn_prompt_text

    winner_dec_text       db     ", Congratulations! You are the WINNER !!! ",0xA, 0xD,0xA, 0xD
    winner_dec_text_len   equ    $-winner_dec_text
   
    draw_text             db     "You both are amazing!! It was a draw.",0xA, 0xD,0xA, 0xD
    draw_text_len   equ    $-draw_text


    vs_text                 db     " v/s "
    vs_text_len             equ     $-vs_text
    
    new_line_token          db      0xA, 0xD
    new_line_token_len      equ     $-new_line_token


    placement_error_txt         db      "Cannot Place a marker at this position, Try Again!",0xA, 0xD
    placement_error_txt_len     equ     $-placement_error_txt

    ;o_board_sign            db      1
    tokens_placed            db      0

    ; pointer to the Tic-Tac-Toe Board
    board                   db      "1","2","3",\
                                    "4","5","6",\
                                    "7","8","9"
 

; bss section
SECTION .bss    
    ; used to store names of players
    name_player_x              resb    256 
    name_player_x_len          resb    4
    name_player_o              resb    256
    name_player_o_len          resb    4 

    ; used to temporarily store the user input for the position of placement of the token
    placement_input            resb     10
    placement_input_len        resb     4
    
    ;i cant remember where i used this one lol 
    read_len                resb    10

SECTION .text
global      _start
    

_start:
    ; Prompts the names of each player
    call Prompt_Name_Player_X
    call Prompt_Name_Player_O

    ; Print the board Initially
    call Print_Board
    ; Game Loop
    call Game_Loop
    
    jmp Exit


%include './includes/GameLogic.asm'         ; Contains Logic regarding how game proceeds and implements the rules of the game
%include './includes/Board.asm'             ; Contains Tic-Tac-Toe Board related functions e.g. print board, place a token on board etc.
%include './includes/Prompts.asm'           ; Contains functionality for prompts has logic for printing prompt to screen and getting user input
%include './includes/Prints.asm'            ; Contains common Print related function for e.g. to Print name of players, print game status etc.
%include './includes/BasicIO.asm'           ; Basic I/O related code i.e. code for print and read operations
%include './includes/Utils.asm'             ; Additional utility code

Exit:  
    mov     eax, 1          ;sysexit
    xor     ebx, ebx
    int     80H
