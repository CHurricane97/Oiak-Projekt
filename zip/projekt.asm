section .data
    ;Dane funkcji wyswietlajacej komunikat powitalny
    welcome_message         db      "Witaj w programie kolko i krzyzk! "
    welcome_message_len     equ     $-welcome_message

    selection_message       db      "Wybierz czy chcesz: [0] wyjsc, [1] grac z komputerem, [2] czy z drugim uzytkownikiem: "
    selection_message_len   equ     $-selection_message

    ;Dane do funkcji wyswietlajacej komunikat po wybraniu gry z komputerem uzytkownikiem 
    info_pc_message         db      "Wybrales gre z komputerem, wykonaj swoj ruch! Aby wyjsc wybierz [0]"
    info_pc_message_len     equ     $-info_pc_message

    ;Dane do funkcji wyswietlajacej komunikat po wybraniu gry z komputerem uzytkownikiem
    info_user_message       db      "Wybrales gre z drugim uzytkownikiem. Krzyzyki pierwsze wykonuja ruch! Aby wyjsc wybierz [0]"
    info_user_message_len   equ     $-info_user_message

    ;Dane funkcji wyswietlajacej informacje przy wprowadzaniu ruchu przez krzyzyki
    x_selection_message     db      "Ruch krzyzykow[X]: "
    x_selection_message_len equ     $-x_selection_message

    ;Dane funkcji wyswietlajacej informacje przy wprowadzaniu ruchu przez kolka
    o_selection_message     db      "Ruch kolek[O]: "
    o_selection_message_len equ     $-o_selection_message

    ;Dane funkcji przechodzacej do nowej lini
    new_line                db      0xA, 0xD
    new_line_len            equ     $-new_line

    ;Symbole uzywane przez funkcje zapisujaca jaki ruch wykonal uzytkownik
    x_symbol                db     "X"
    o_symbol                db     "O"

    ;Dane powiazane z wyswietlaniem tablicy
    game_board              db     "1","2","3","4","5","6","7","8","9"
    vertical_bar_symbol     db     "|"
    length_one              equ    $-vertical_bar_symbol


SECTION .bss
    ;Przechowuje odczyt wyboru po komunikacie powitalnym
    choice                  resb    256 
    choice_len              resb    4


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
    call Display_Game_game_board
    call Display_X_Selection
    call Get_Choice
    cmp eax, 0
    je Exit

    ;Wstawianie krzyzyka do tablicy
    mov esi, x_symbol
    call Set_Sign_O_X


    ;Obsluga kolek
    call Display_Game_game_board
    call Display_O_Selection
    call Get_Choice
    cmp eax, 0
    je Exit

     ;Wstawianie kolka do tablicy do tablicy
    mov esi, o_symbol
    call Set_Sign_O_X

    jmp User_Menu_Loop

Play_With_PC:
    call Display_Info_PC
    PC_Menu_Loop:

    ;Obsluga uzytkownika
    call Display_Game_game_board
    call Display_X_Selection
    call Get_Choice
    cmp eax, 0
    je Exit
    
    call Check_Result

    ;Obsluga komputera
    call Get_PC_Move
   
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

;Funkcja sprawdzajaca wynik
Check_Result:

    ret



; Funkcja wyswietla plansze do gry z aktualnymi wartosciami
Display_Game_game_board:
    ;Trzy razy przechodzimy do nowej linii
    call Enter_New_Line
    call Enter_New_Line
    call Enter_New_Line

    ;Uzywamy rejestru esi jako licznik liczacy numer elementu na planszy gry, zachowujemy jego wartosc na stosie
    push esi
    mov esi, 0
    ;Ustawienie licznika wierszy (posluzy nam za niego rejestr ecx)
    mov ecx, 3 
    Print_Row_Loop:
        ;Przerzucamy licznik na stos, aby go nie zniszczyć
        push ecx
        
        ;Ustawienie licznika kolumn (posluzy nam za niego rejestr ecx)
        mov ecx, 3
        Print_Column_Loop:
            ;Przerzucamy licznik na stos, aby go nie zniszczyć
            push ecx 

            ;Wyswietlenie pionowego rozdzielacza
            mov ecx,  vertical_bar_symbol
            mov edx, length_one
            call Print

            ;Wyswietlanie symbolu z tablicy
            mov ecx,  game_board
            add ecx, esi ;Przesuniecie tablicy gry o odpowiednia wartosc przechowywana w rejestrze esi (liczniku)
            mov edx, length_one
            call Print

            ;Zwiekszenie licznika tablicy
            inc esi

            ;Wyswietlenie pionowego rozdzielacza
            mov ecx,  vertical_bar_symbol
            mov edx, length_one
            call Print
            
            ;Przyworcenie ze stosu licznika petli dla kolumny i dekrementacja
            pop ecx
            dec ecx
            jnz Print_Column_Loop

        ;Przechodzimy do nowej linii.
        call Enter_New_Line
        
        ;Zdejmujemy licznik petli ze stosu
        pop ecx

        ;Dekrementacja licznika petli dla wierszy
        dec ecx
        jnz Print_Row_Loop

    ;Przywracamy wartosc rejestru esi
    pop esi

    ;Trzy razy przechodzimy do nowej linii
    call Enter_New_Line
    call Enter_New_Line
    call Enter_New_Line
    ret


;Funkcja ustawia kolko lub krzyzyk na odpowiedniej pozycji w tablicy
;W rejestrze eax podajemy miejsce w ktorym chcemy wstawic znak a w rejestrze esi znak ktory chcemy wstawic
Set_Sign_O_X:

    ;Znajdowanie pozycji na tablicy
    mov dl,byte[esi]
    sub eax, 1  
    mov ecx, game_board
    add ecx, eax

    ;Wstawienie wartosci do tablicy
    mov [ecx], dl
    ret

;Funkcja pobierajaca wybor z klawiatury
Get_Choice:
    mov ecx, choice
    mov edx, choice_len
    call Read

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
    call Enter_New_Line
    mov     ecx, selection_message
    mov     edx, selection_message_len 
    call    Print
    ret

;Funkcja wyswietlajaca komunikat powitalny po wybraniu gry z drugim uzytkownikiem
Display_Info_User:
    mov     ecx, info_user_message 
    mov     edx, info_user_message_len 
    call    Print
    call Enter_New_Line
    ret

;Funkcja wyswietlajaca komunikat powitalny po wybraniu gry z z komputerem
Display_Info_PC:
    mov     ecx, info_pc_message 
    mov     edx, info_pc_message_len 
    call    Print
    call Enter_New_Line
    ret

;Funkcja przechodzaca do nowej lini Enter_New_Lin:
Enter_New_Line:
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
    int     80H
    ret 

;Funkcja konwertujaca literę na cyfrę, w esi podajemy literę, a w eax otrzymujemy cyfrę
Convert_Char_To_Int: 
    movzx   eax, byte[esi] 
    sub     al, '0'     
    ret