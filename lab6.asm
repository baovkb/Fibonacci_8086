.Model Small
.Stack 100h

.Data   
    str1        DB "Input first number: $"
    str2        DB "Input second number: $"
    input1      DB 3,?,3 dup(' ')
    input2      DB 3,?,3 dup(' ')
    firstNum    DB ?
    secondNum   DB ?
    sum         DB ?
    
    fibo_n1     DB 21 dup(0) 
    fibo_n2     DB 21 dup(0)
    fibo        DB 21 dup(0)  
    
.Code
Main Proc 
    Mov     ax, @Data
    Mov     ds, ax 
    
    ;input first number
    Lea     bx, str1
    Lea     cx, input1
    call    Input
    
    call Endline     
	
	;input second number
	Lea     bx, str2
    Lea     cx, input2
    call    Input
	
	;convert input1 to firstNum
	Lea     si, input1 + 2
    Lea     bx, firstNum
    call    ConvertStrToNum
    
    
    ;convert input2 to secondNum
	Lea     si, input2 + 2
    Lea     bx, secondNum
    call    ConvertStrToNum
    
    ;add two number
    call    Add_ 
    
    ;print endline
    call    Endline
    
    mov     fibo_n1+20, 1
    xor     cx, cx
    mov     cl, sum                     
findFibo: 
    xor     ax, ax
    mov     al, sum
    cmp     ax, cx
    jne     ck_f1
    
    ;print f(0)
    lea     bx, fibo_n2
    call    printFibo
    jmp     cont_Main
    
ck_f1:
    dec     ax
    cmp     ax, cx
    jne      f_n 
    
    ;print f(1)
    lea     bx, fibo_n1
    call    printFibo
    jmp     cont_Main 
    
f_n:   
    call    Add_Array
    lea     ax, fibo_n2
    lea     dx, fibo_n1
    call    copyArray
    
    lea     ax, fibo_n1
    lea     dx, fibo
    call    copyArray
    lea     bx, fibo
    call    printFibo

cont_Main:
    mov     dl, ' '
    mov     ah, 2
    int     21h    
    loop    findFibo
   
    
    jmp End_prog
    
Main Endp   


;address of number is set to bx
printFibo   proc
    mov     si, 0
    mov     ax, bx
    xor     dx, dx     
loop_printFibo: 
    mov     bx, ax
    cmp     si, 20 
    jg      end_loop_printFib
    mov     bx, [bx+si]
    cmp     bl, 0
    je      check_zero

conf_print:    
    ;print fibo number
    mov     dx, 1
    push    dx
    mov     dx, bx
    add     dx, 30h
    push    ax
    mov     ah,02h      
    int     21h
    pop     ax
    pop     dx
    jmp     cont_printFibo
    
check_zero:
    cmp     dx, 0
    jne     conf_print    

cont_printFibo:
    inc     si    
    jmp     loop_printFibo
end_loop_printFib:
    cmp     dx, 0
    jne     end_printFibo 
    add     dx, 30h
    mov     ah,02h      
    int     21h
    
end_printFibo:    
    ret
printFibo Endp 

    
copyArray   proc
    mov     si, 20
    push    ax  
loop_copyArray:
    cmp     si, 0
    jnge    end_loop_copyArray
    
    xor     ax, ax
    mov     bx, dx
    mov     bl, [bx+si]

    mov     al, bl
    pop     bx
    mov     [bx+si], al
    push    bx   
    
    dec     si
    jmp     loop_copyArray
    
end_loop_copyArray:
    pop     ax
    ret
copyArray Endp
     


Add_Array   proc 
    clc           
    mov     si, 20
    mov     dl, 0
loop_add_array:    
    cmp     si, 0
    jnge    end_loop_add_array 
    
    lea     bx, fibo_n1
    mov     al, [bx+si]
    lea     bx, fibo_n2
    mov     bl, [bx+si]
    
    
    add     al, bl
    add     al, dl
    mov     dl, 0
    cmp     al, 10
    jnge    isNGE_10
    sub     al, 10
    mov     dl, 1
isNGE_10:
    lea     bx, fibo
    mov     [bx+si], al 
    
    dec     si
    jmp     loop_add_array 
    
end_loop_add_array:   
    ret
Add_Array Endp 


Add_ proc
    clc     ;clear carry 
    
    mov     al, firstNum
    mov     bl, secondNum
    add     al, bl
    
    
    cmp     al, 99
    jng     nex99
    mov     al, 99
nex99:   
    mov     sum, al 
    
    ret
Add_ Endp    


;address of str is set to bx
;address of input is set to cx
Input proc
    mov     dx, bx
    mov     ah, 9  
    Int     21h 
                                                           
                                                                                                                
    ;input number
    mov     dx, cx
    Mov     ah, 0ah
    Int     21h
    
    ;set $ to the end of string  
    xor     bx, bx
    mov     bx, cx
	mov     bl, [bx+1]
	mov     si, bx
	mov     bx, cx
	mov     [bx+si+2], '$'
	
	ret
	
Input Endp
    

;load address of string to si
;load address of num to bx
ConvertStrToNum proc
    push    bx
    xor     ax, ax
    
	Convert_loop:
	mov     ch, 0
	mov     cl, [si]
	cmp     cl, 24h
	je      end_loop 
	
	
	mov     bx, word ptr 10
	mul     bx
	
	sub     cx, 30h
	add     ax, cx
		
	
	inc     si
	jmp     Convert_loop
	
	         
    end_loop: 
    pop     bx
    mov     [bx], ax
    
    ret

ConvertStrToNum Endp

Endline proc
    mov dx,13
    mov ah,2
    int 21h  
    mov dx,10
    mov ah,2
    int 21h
    ret
Endline Endp 



Print_str proc
    mov     ah, 9
    int     21h
    ret
Print_str   Endp 


End_prog:     

End Main