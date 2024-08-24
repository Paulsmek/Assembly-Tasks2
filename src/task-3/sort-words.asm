global get_words
global compare_func
global sort

extern strtok
extern printf
extern qsort
extern strlen
extern strcmp

section .text
    extern strtok
    extern printf
    delimeters db " ,.",0xA, 0
    format db "%s", 10, 0

;; compare_func(const void *a, const void *b)
;  Compare function for qsort
;  Compares two strings based on their lengths and lexicographic order
compare_func:
  enter 0, 0
  push ebx
  ; adresele lui a si b
  mov eax, [ebp + 8]
  mov edx, [ebp + 12]

  ; deferentierea 
  mov eax, [eax]
  mov edx, [edx]

  ; compar lungile
  push edx
  push ecx
  push eax
  call strlen
  add esp, 4
  pop ecx
  pop edx
  mov ebx, eax

  push ecx
  push edx
  call strlen
  add esp, 4
  pop ecx
  mov edx, eax

  cmp ebx, edx
  jl pozitiv
  jg negativ
  je egal

  ;cazul in care len a > len b
pozitiv:
  mov eax, -1
  pop ebx
  leave
  ret

  ;cazul in care len a < len b
negativ:
  mov eax, 1
  pop ebx
  leave
  ret

  ;caz egalitate
egal:
  mov eax, [ebp + 8]
  mov edx, [ebp + 12]
  mov eax, [eax]
  mov edx, [edx]

  push edx
  push eax
  call strcmp ;compar stringurile
  add esp, 8

  ;ajustez valoarea pentru qsort
  cmp eax, 0
  jl negative
  jg positive
  xor eax, eax  ;in caz de egalitate 0
  jmp end_compare

negative:
  mov eax, -1
  jmp end_compare

positive:
  mov eax, 1

end_compare:
  pop ebx
  leave
  ret


;; sort(char **words, int number_of_words, int size)
;  Sort the words using qsort
;  Sorts the words first by length and then lexicographically
sort:
  enter 0, 0
  pusha

  ;argumentele
  mov edi, [ebp+8]        ; words
  mov ecx, [ebp+12]       ; number_of_words
  mov edx, [ebp+16]       ; size

  ; apelez qsort
  push compare_func       ; compare_func
  push edx                ; size
  push ecx                ; number_of_words
  push edi                ; words
  call qsort
  add esp, 16

  popa
  leave
  ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0
    pusha

    ;argumentele
    mov ecx, [ebp+8]
    mov ebx, [ebp+12]
    mov esi, [ebp+16]

    ;apelez strtok
    push delimeters
    push ecx
    call strtok
    add esp,8

  ;loop pentru cuvintele din strtok
next_word:
    cmp eax, 0
    je end_loop

    mov [ebx], eax
    add ebx, 4

    ;apelez strtok 
    push delimeters
    push dword 0
    call strtok
    add esp,8
    jmp next_word

end_loop:
    popa
    leave
    ret
