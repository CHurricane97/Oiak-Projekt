section .data
    ;Dane funkcji wyswietlajacej komunikat powitalny
    welcome_message         db      "Witaj w programie kolko i krzyzk! ", 0
    welcome_message_len     equ     $-welcome_message

    selection_message       db      "Wybierz czy chcesz: [0] wyjsc, [1] grac z komputerem, [2] czy z drugim uzytkownikiem: ", 0
    selection_message_len   equ     $-selection_message

    ;Dane do funkcji wyswietlajacej komunikat po wybraniu gry z komputerem uzytkownikiem 
    info_pc_message         db      "Wybrales gre z komputerem, wykonaj swoj ruch! Aby wyjsc wybierz [0]", 0
    info_pc_message_len     equ     $-info_pc_message

    ;Dane do funkcji wyswietlajacej komunikat po wybraniu gry z komputerem uzytkownikiem
    info_user_message       db      "Wybrales gre z drugim uzytkownikiem. Krzyzyki pierwsze wykonuja ruch! Aby wyjsc wybierz [0]", 0
    info_user_message_len   equ     $-info_user_message

    ;Dane funkcji wyswietlajacej informacje przy wprowadzaniu ruchu przez krzyzyki
    x_selection_message     db      "Ruch krzyzykow[X]: ", 0
    x_selection_message_len equ     $-x_selection_message

    ;Dane funkcji wyswietlajacej informacje przy wprowadzaniu ruchu przez kolka
    o_selection_message     db      "Ruch kolek[O]: ", 0
    o_selection_message_len equ     $-o_selection_message

    ;Dane funkcji przechodzacej do nowej lini
    new_line                db      0xA, 0xD
    new_line_len            equ     $-new_line

    ;Symbole uzywane przez funkcje zapisujaca jaki ruch wykonal uzytkownik
    x_symbol                db     "X"
    o_symbol                db     "O"

    ;Tablica do gry
    board                   db      "1","2","3","4","5","6","7","8","9"


SECTION .bss
    ;Przechowuje odczyt wyboru po komunikacie powitalnym
    choice         resb    256 
    choice_len      resb    4

    read_len                resb    10


SECTION .text
global _start
    

_start:

Main_Menu_Loop:
    call Display_Welcome_Message
    call Get_Choice

    ;Odpowiednik wykonania warunkowe skaczacy do odpowiedniego miejsca w zaleznosci od wyboru uzytkownika
    cmp eax, 0
    je Exit
    cmp eax, 1
    je Play_With_PC
    cmp eax, 2
    je Play_With_User
    jmp Main_Menu_Loop

Play_With_User:
    call Display_Info_User
    User_Menu_Loop:

    ;Obsluga krzyzykow
    call Display_Game_Board
    call Display_X_Selection
    call Get_Choice
    cmp eax, 0
    je Exit

    ;Funkcja nad ktora pracujemy
    mov esi, x_symbol
    call Place_Token

    call Set_X_Move
    call Check_Result

    ;Obsluga kolek
    call Display_Game_Board
    call Display_O_Selection
    call Get_Choice
    cmp eax, 0
    je Exit
    call Set_O_Move
    call Check_Result

    jmp User_Menu_Loop

Play_With_PC:
    call Display_Info_PC
    PC_Menu_Loop:

    ;Obsluga uzytkownika
    call Display_Game_Board
    call Display_X_Selection
    call Get_Choice
    cmp eax, 0
    je Exit
    call Set_X_Move
    call Check_Result

    ;Obsluga komputera
    call Get_PC_Move
    call Set_O_Move
    call Check_Result

    jmp PC_Menu_Loop


;Konczenie dzialania programu
Exit:  
    mov     eax, 1          
    xor     ebx, ebx
    int     80H


;Funkcje

;Funkcja losujaca ruch komputera
Get_PC_Move:

    ret

;Funkcja ustawiajaca ruch krzyzykow
Set_X_Move:

    ret

;Funkcja ustawiajaca ruch kolek
Set_O_Move:

    ret

;Funkcja sprawdzajaca wynik
Check_Result:

    ret

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

;Funkcja pobierajaca wybor z klawiatury
Get_Choice:
    mov ecx, choice
    call Read
    mov  eax, [read_len]
    mov  [choice_len], eax  ; restore the length

    ;Tutaj nastepuje konwersja wprowadzonej litery do cyfry
    mov esi,  choice
    call Convert_Char_To_Int
    ret

;Funckaj wyswietlajaca komunikat z wyborem ruchu dla krzyzykow
Display_X_Selection:
    mov     ecx, x_selection_message 
    mov     edx, x_selection_message_len 
    call    Print
    ret

;Funckaj wyswietlajaca komunikat z wyborem ruchu dla kolek
Display_O_Selection:
    mov     ecx, o_selection_message 
    mov     edx, o_selection_message_len 
    call    Print
    ret

;Funkcja wyswietlajaca komunikat powitalny
Display_Welcome_Message:
    mov     ecx, welcome_message 
    mov     edx, welcome_message_len 
    call    Print
    call Print_Empty_Line
    mov     ecx, selection_message
    mov     edx, selection_message_len 
    call    Print
    ret

;Funkcja wyswietlajaca komunikat powitalny po wybraniu gry z drugim uzytkownikiem
Display_Info_User:
    mov     ecx, info_user_message 
    mov     edx, info_user_message_len 
    call    Print
    call Print_Empty_Line
    ret

;Funkcja wyswietlajaca komunikat powitalny po wybraniu gry z z komputerem
Display_Info_PC:
    mov     ecx, info_pc_message 
    mov     edx, info_pc_message_len 
    call    Print
    call Print_Empty_Line
    ret

;Funkcja przechodzaca do nowej lini
Print_Empty_Line:
    mov     ecx, new_line
    mov     edx, new_line_len
    call    Print
    ret

;Funkcja wyswietlajaca tekst podany na wejsciu
Print:
    mov     eax, 4
    mov     ebx, 1
    int     80H 
    ret

;Funkcja wczytujaca ciag tekstowy z klawiatury
Read:
    mov     eax, 3
    mov     ebx, 0
    mov     edx, 50
    int     80H
    mov     [read_len], eax
    ret 

;Funkcja konwertujaca literę na cyfrę, w esi podajemy literę, a w eax otrzymujemy cyfrę
Convert_Char_To_Int: 
    movzx   eax, byte[esi] 
    sub     al, '0'     
    ret

;Funkcja wyswietla tablice gry
Display_Game_Board:

    ret