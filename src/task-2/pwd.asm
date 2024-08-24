section .data
    back db "..", 0
    curr db ".", 0
    slash db "/", 0

section .text
    global pwd
    extern strcat

;;	void pwd(char **directories, int n, char *output)
;	Adauga in parametrul output path-ul rezultat din
;	parcurgerea celor n foldere din directories
pwd:
    enter 0, 0
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov ebx, [ebp + 8]     ; Load the address of directories
    mov ecx, [ebp + 12]    ; Load the value of n
    mov edx, [ebp + 16]    ; Load the address of output

    xor eax, eax           ; Clear EAX register
    mov byte [edx], '/'    ; Start the output string with '/'
    xor edi, edi
    inc edi
iterate_directories:
    cmp ecx, 0             ; Check if n is 0
    je end_iteration

    dec ecx                ; Decrement n
    add ebx, 4             ; Move to the next directory in the array (assuming 32-bit system)
    mov esi, [ebx]         ; Load the address of the current directory

    push ebx               ; Preserve the value of EBX

    copy_directory:
        mov al, [esi]       ; Load the current character of the directory
        mov byte[edx + edi], al       ; Copy the character to the output string
        inc edi             ; Move to the next character
        inc esi             ; Move to the next character

        cmp al, 0           ; Check if the end of the directory is reached
        jne copy_directory

    mov byte [edx + edi], '/'    ; Append '/' to the output string

    pop ebx                ; Restore the value of EBX

    jmp iterate_directories

end_iteration:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    leave
    ret