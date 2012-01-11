read macro
     mov ah,1
     int 21h
endm

print_num macro char  
    push dx
    push ax
    mov dx,char      
    add dx,30h
    mov ah,2
    int 21h
    pop ax
    pop dx
    
endm

print macro char
    push ax
    push dx
    mov dl,char
    mov ah,02h
    int 21h
    pop dx
    pop ax
endm

print_string macro string
    push ax
    push dx
    mov dx,offset string  ;Assume that string is a variable or constant, NOT an address
    mov ah,09h
    int 21h
    pop dx
    pop ax
endm

data segment
    ; add your data here!      
    prosth db 0
    message db 3dh,"$"
    grammi db 0AH,0DH,"$" 
    plhn db "-$"
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    ; add your code here

    call read_hex     ;1os ->ax, 2os ->dx
     
     push ax
     push dx
     push bx
     print_string grammi
     mov cl,3dh
     print cl 
     ;print_string message 
     pop bx
     pop dx
     pop ax
    
    cmp prosth,1
    je prosthesi
    jmp afairesh 
    
prosthesi:          
    add ax,dx   
    
    jnc ektypwsh  
    push ax
    push dx
    push bx   
    mov cl,31h     ;megisth yperxeilish -> 5o psifio = 1
    mov prosth,02  ; flag gia kratoumeno
    print cl
    pop bx
    pop dx
    pop ax
    
ektypwsh:
    push ax   ;apo8ikeush ari8mou 
    cmp ah,0
    je epomeno
    push ax
    mov al,ah
    call ascii
    print ah
    print al
    pop ax
epomeno:
    call ascii
    print ah
    print al    
    
    push ax
    push dx
    push cx
    mov bl,3dh
    print bl
    ;print_string message 
    pop cx
    pop dx
    pop ax
    
    pop ax
    
    cmp prosth,02
    jne address
    print_string plhn
    
address:
    call print_dec   
    print_string grammi
    
    jmp start 
    
afairesh:
    cmp ax,dx
    jge megalyteros
    jmp mikroteros
    
megalyteros:     
    sub ax,dx
    jmp ektypwsh
  
mikroteros: 
   mov prosth,02  ;flag gia typwsh plhn   
   print_string plhn
   sub dx,ax
   jmp ektypwsh


quit:    
    mov ax, 4c00h ; exit to operating system.
    int 21h  
      
ends

read_hex proc near
    mov bx,0     
    mov cx,0
    mov dx,0
     
ignore:          
    read                 ;diavazei mexri 4 hex psifia
    cmp al,2bh   ;elegxos gia +
    je prosthe
    cmp al,2dh   ;elegxos gia -                 
    je cont2                                     
    cmp al,'Q'
    je quit 
    cmp al,'q'
    je quit
    cmp bx,4        ;agnoei pera twn 4 psifiwn
    je ignore 
    cmp al,30h
    jl ignore
    cmp al,39h
    jle contin
    cmp al,'A'
    jl ignore
    cmp al,'F'
    jle contin
    cmp al,'a'
    jl ignore
    cmp al,'f'
    jle contin
    jmp ignore
    
contin:      
    mov ah,0
    push ax
    inc bl
    jmp ignore

prosthe:
    mov prosth,1      ;san flag gia pros8esh
cont2:   
    cmp bx,00
    jz quit
    cmp bl,1
    je psifio_1
    cmp bl,2
    je psifia_2
    cmp bl,3
    je psifia_3
    cmp bl,4
    je psifia_4
    
psifio_1:
    pop ax
    mov ah,30h
    call number
    jmp synex     ;1 psifio ->ax
    
psifia_2:
    pop ax
    mov cl,al   ;endiamesos kataxwrhths gia to 1o psifio
    pop ax
    mov ah,al
    mov al,cl   
    call number
    jmp synex    ;2 psifia -> ax

psifia_3:
    pop ax           ;3o-2o
    mov bl,al
    pop ax
    mov ah,al
    mov al,bl
    call number      
    mov dx,ax
    
    pop ax
    mov ah,30h    ;1o psifio   
    call number
    mov ah,al
    mov al,dl    ;pol/zoyme epi 256 to 1o-2o psifio
    jmp synex    ;3 psifia ->ax
    
psifia_4:    
    pop ax
    mov cl,al
    pop ax
    mov ah,al   ;2o stoixeio p anasyroyme ap' th stoiva        
    mov al,cl
    call number
    mov dx,ax      ;3o-4o psifio ston dx
    
    pop ax
    mov cl,al
    pop ax  
    mov ah,al
    mov al,cl
    call number
    mov ah,al
    mov al,dl   ;san pol/smos epi 256 ta 2 msb psifia 
                ;4 psifia ->ax  
    
synex:                ;2os ari8mos      
    push ax      ;apo8ikeysh 1ou ari8moy sth stoiva
    
    mov bx,0
ignore1:
    read 
    cmp al,0dh  ;elegxos gia <enter>
    je cont4
    cmp al,'Q'
    je quit 
    cmp al,'q'
    je quit
    cmp bx,4        ;agnoei pera twn 4 psifiwn
    je ignore1
    cmp al,30h
    jl ignore1
    cmp al,39h
    jle cont3
    cmp al,'A'
    jl ignore1
    cmp al,'F'
    jle cont3
    cmp al,'a'
    jl ignore1
    cmp al,'f'
    jle cont3
    jmp ignore1 

cont3:
    push ax
    mov ah,0
    inc bl
    jmp ignore1    
    
cont4:          
    cmp bl,00h
    je quit
    cmp bl,1
    je psifio1_2
    cmp bl,2
    je psifia2_2
    cmp bl,3
    je psifia3_2
    cmp bl,4
    jge psifia4_2

    
psifio1_2:
    pop ax
    mov ah,30h
    call number
    jmp telos    ;1 psifio ->ax
    
psifia2_2:
    pop ax
    mov cl,al    ;endiamesos kataxwrhths gia to 1o psifio
    pop ax
    mov ah,al
    mov al,cl    ;to 1o psifio einai lsb
    call number
    jmp telos    ;2 psifia ->ax

psifia3_2:
    pop ax           ;3o-2o
    mov bl,al
    pop ax
    mov ah,al
    mov al,bl
    call number      
    mov dx,ax
    
    pop ax
    mov ah,30h    ;1o psifio   
    call number
    mov ah,al
    mov al,dl    ;pol/zoyme epi 256 to 1o-2o psifio
    jmp telos    ;3 psifia ->ax
    
psifia4_2:    
    pop ax
    mov cl,al
    pop ax
    mov ah,al        
    mov al,cl
    call number
    mov dx,ax      ;3o-4o psifio ston dx
    
    pop ax
    mov cl,al
    pop ax
    mov ah,al       ;1o-2o
    mov al,cl
    call number
    mov ah,al
    mov al,dl   ;san pol/smos epi 256 ta 2 msb psifia 
                ;4 psifia ->ax  
                
telos: 
    mov dx,ax  ; 2os ari8mos ->dx
    pop ax     ; 1os ari8mos ->ax
ret
read_hex endp

print_hex proc near
    push bx
    push cx
    push dx
    cmp ah,9    ;an o ari8mos einai metaksy 0 k 9 pros8etw 30h
    jg addr
    add ah,30H
    jmp adr2

addr:
    add ah, 37H ; diaforetika pros8etw 37h ('A' = 41h)
adr2:
    print ah
    pop dx
    pop cx
    pop bx
    ret 
print_hex endp

print_dec proc near 
    push dx
    push cx
    push bx
    mov cx,0 
    
addr1:
    mov dx,0
    mov bx,10
    div bx
    push dx
    inc cx
    cmp ax,0
    jnz addr1
    
addr2:
    pop dx
    print_num dx
    loop addr2
    pop bx
    pop cx
    pop dx 
    ret
print_dec endp 

ascii proc near
    push bx                                                   
    mov ah,al   ;metaforoume autousio ton al
    and al,0fh  ;apomonwsh twn 4 lsb bits
    cmp al,09h 
    jg  gramma  ;an einai gramma
    jmp psifio  ;an einai arithmos  
    
gramma:           
    add al,37h
    jmp synexeia
    
psifio:
    add al,30h
    
synexeia:     
    mov bl,al   ;save to apotelesma
    and ah,0f0h  ;apomonwsh twn 4 msb bits
    shr ah,4    ;olis8hsh 4 8eseis dexia
    cmp ah,09h
    jg gramma2
    jmp psifio2
    
gramma2:
    add ah,37h
    jmp synexeia2
    
psifio2:
    add ah,30h
                 
synexeia2:
    mov al,bl
    pop bx
ret
ascii endp  

number proc near 
    push bx
    push cx
    push dx
    sub al,30h    ;an o al einai ascii arithmou
    cmp al,09h
    jle cont
    sub al,07h    ;ascii kefalaiou
    cmp al,09h
    jle cont
    sub al,20h    ;ascii mikrou grammatos
    
cont:
    sub ah,30h    ;antistoixa gia ton ah
    cmp ah,09h
    jle cont1
    sub ah,07h
    cmp ah,09h
    jle cont1
    sub ah,20h
    
cont1:   
    
    shl ah,4      ;pollaplasiasmos twn 4 msb me 16 
    add al,ah
    mov ah,0
    pop dx
    pop cx
    pop bx       
ret          
number endp

end start ; set entry point and stop the assembler.
