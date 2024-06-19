BuildBrick macro A, B, C
    push ax
    push bx
    mov ax, A
    mov bx, B
    AddBrick C
    pop bx
    pop ax
endm

redrawStriker macro visColor

mov color, visColor
call drawStriker
endm

redrawBall macro visColor
mov color, visColor
call drawball
endm


BrickCollision MACRO X, Y
local copper
    push ax
    push bx
    push cx
    push dx
    mov ax, ballY
    mov bx, ballX
    mov cx, X
    mov dx, Y
    
    cmp dx, ballY
    jl copper
    sub dx, 7
    
    cmp ballY, dx
    jl copper
    
    
    mov dx, X 
    
    cmp ballX, dx
    jl copper
    add dx, 30
    cmp dx, ballX
    jl copper
    
    call switcher
    DestroyBrick X, Y
    mov Y, 300
    cmp scoreCount, 18
    jne copper
     mov al, 0
     mov bh, 0
     mov bh, 0
     mov cx, 0
     mov dh, 80
     mov dl, 80
     mov ah, 06h
     int 10h


     writeWord 10, 15, 'Y', 3
     writeWord 10, 16, 'O', 3
     writeWord 10, 17, 'U', 3
     writeWord 10, 18, ' ', 3
     writeWord 10, 19, 'W', 3
     writeWord 10, 20, 'I', 3
     writeWord 10, 21, 'N', 3
     writeWord 10, 22, '.', 3
     mov ah, 00
     int 16h
     
    
    copper:
   
    
    pop dx
    pop cx
    pop bx
    pop ax                      
    
endm

DestroyBrick macro  A, B
    push ax
    push bx
    mov ax, A
    mov bx, B
    
    call RemoveBrick 
    call beep
    inc scoreCount
    call DrawLivesScores

    pop bx
    pop ax
endm

writeWord macro A, B, C, D                  ;Height - Width - Letter - Color
   push dx 
   push ax 
   push cx
   push bx

MOV DH, A		;Height	;Set cursor position
MOV DL, B		;Width
MOV AH, 02H
INT 10H
MOV AL, C    ;Write at cursor position
MOV BL, 15
MOV CX, 1
MOV AH, 09H
INT 10H
   pop bx 
   pop cx
   pop ax
   pop dx
endm

readWord macro A, B, C, D   ;row - Column - color - character
push dx 
push ax 
push cx
push bx

mov dh, A    
mov dl, B
mov ah, 02h
int 10h

mov ah, C
mov al, D
mov ah, 08h
int 10h

pop bx 
pop cx
pop ax
pop dx
endm


fileOpen macro A, B     ;Filename - Handle Address (DB)
push ax
push cx
push dx

mov ah, 3ch
mov dx,offset A
mov cl, 1
int 21h
mov B, ax

pop dx
pop cx
pop ax
endm

fileClose macro A     ;Handle
pop ax
pop dx

mov ax, 3eh
mov dx, A
int 21h
endm


writingFile macro A, B, C, D  ;(Fname, handle, size of msg, messageName)
push ax
push bx
push cx
push dx


mov ah, 42h
mov al, 2
int 21h
mov ah, 40h
mov bx, B
mov cx, C
mov dx, offset D

pop dx
pop cx
pop bx
pop ax
endm

AddBrick macro A   ;- (color)
    push ax
    push bx    
    mov startx, ax
    mov color, A 
    mov ax, bx
    mov bx, startx
    add bx, 30
    mov endx,bx
    mov starty, ax
    mov bx,starty  
    add bx,2
    mov endy,bx
     
    call draw
    pop bx
    pop ax 
endm


BrickCollision2 MACRO X, Y
local copper
    push ax
    push bx
    push cx
    push dx
    mov ax, ballY
    mov bx, ballX
    mov cx, X
    mov dx, Y
    
    cmp dx, ballY
    jl copper
    sub dx, 7
    
    cmp ballY, dx
    jl copper
    
    
    mov dx, X 
    
    cmp ballX, dx
    jl copper
    add dx, 30
    cmp dx, ballX
    jl copper
    
    call switcher
    
    DestroyBrick X, Y
    mov Y, 300
    cmp scoreCount, 18
    jne copper
     mov al, 0
     mov bh, 0
     mov bh, 0
     mov cx, 0
     mov dh, 80
     mov dl, 80
     mov ah, 06h
     int 10h

     writeWord 10, 15, 'Y', 3
     writeWord 10, 16, 'O', 3
     writeWord 10, 17, 'U', 3
     writeWord 10, 18, ' ', 3
     writeWord 10, 19, 'W', 3
     writeWord 10, 20, 'I', 3
     writeWord 10, 21, 'N', 3
     writeWord 10, 22, '.', 3
     mov ah, 00
     int 16h
     
    
    copper:
   
    pop dx
    pop cx
    pop bx
    pop ax   
    
    
endm