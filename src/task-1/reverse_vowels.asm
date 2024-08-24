section .data
	; declare global vars here

section .text
	global reverse_vowels

;;	void reverse_vowels(char *string)
;	Cauta toate vocalele din string-ul `string` si afiseaza-le
;	in ordine inversa. Consoanele raman nemodificate.
;	Modificare se va face in-place
reverse_vowels:
	push ebp
	push esp
	pop ebp
	pusha

	push dword[ebp+8]
	pop ebx ;ebx are adresa stringului
	xor eax,eax
	;loop pentru a da push la vocale pe stiva
loop1:
	cmp [ebx+eax], byte 0
	je end_loop1

	;vad daca e vocala
	cmp byte[ebx+eax], 'a'
	je vocala
	cmp byte[ebx+eax], 'e'
	je vocala	
	cmp byte[ebx+eax], 'i'
	je vocala
	cmp byte[ebx+eax], 'o'
	je vocala
	cmp byte[ebx+eax], 'u'
	je vocala

	jmp move_on1

vocala:
	xor edx,edx
	add dl, byte[ebx+eax];dau push pe stiva la vocala
	push dx

move_on1:
	inc eax
	jmp loop1

end_loop1:

	xor eax,eax
	;loop pentru modificare vocala
loop2:
	cmp [ebx+eax], byte 0
	je end_loop2

	;vad daca e vocala
	cmp byte[ebx+eax], 'a'
	je vocala2
	cmp byte[ebx+eax], 'e'
	je vocala2
	cmp byte[ebx+eax], 'i'
	je vocala2
	cmp byte[ebx+eax], 'o'
	je vocala2
	cmp byte[ebx+eax], 'u'
	je vocala2
	jmp move_on2

vocala2:
	xor ecx,ecx
	pop cx
	push dword[ebx+eax]
	pop edx
	xor byte[ebx+eax],dl ;sterg vocala curenta
	add byte[ebx+eax],cl ;adaug vocala 	
	

move_on2:
	inc eax
	jmp loop2

end_loop2:

	popa
	pop ebp
	ret
