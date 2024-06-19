;Abdullah Chaudhary   -   0844
;Zainab Ali khan  -  0492
;CS - Y
include Macro.inc
.model small
.stack 100h
.data


ballLeft db 0
NAMEx db 20 dup('$')			;User name
score db 'Score: $'			;Score Printout
scoreCount dw 0				;Score		
F1 db 'Name.txt', 0			;File object
Fileinfo dw ?				;File handling
EXTERNDELAY db 1
color db ?					;Color variable
scoreM1 db '1'				;When highest score
scoreM2 db '8'
levelName db ?
skip db 10					;Next line in file handling
space db 32					;Space in file handling
startx dw ?
lives db 'Lives: $'
level db ?					;Which level you have chosen
lengthval dw ?				;Length of name

innerDelay db 0
begin db 0					;Starting of the ball
livesCount db 3				;Maximum lives
starty dw ?
endx dw ?
endy dw ?
strikerX dw 140				;Starting of the plate
strikerY dw 170
ballY dw 163
ballX dw 158
ballUp db 1
boundaryEnd dw 250
boundaryStart dw 30


brick1x dw 45			;Brick 1 x-component
brick1y dw 25			;Brick 1 y-component
check21 db ?
brick2x dw 85			;Brick 2 x-component
brick2y dw 25			;Brick 2 y-component
check22 db ?
brick3x dw 125			;Brick 3 x-component
brick3y dw 25			;Brick 3 y-component
check23 db ?
brick4x dw 165			;Brick 4 x-component
brick4y dw 25			;Brick 4 y-component
check24 db ?
brick5x dw 205			;Brick 5 x-component
brick5y dw 25			;Brick 5 y-component
check25 db ?
brick6x dw 245			;Brick 6 x-component
brick6y dw 25			;Brick 6 y-component
check26 db ?
			

brick7x dw 45			;Brick 7 x-component
brick7y dw 40			;Brick 7 y-component
check27 db ?
brick8x dw 85			;Brick 8 x-component
brick8y dw 40			;Brick 8 y-component
check28 db ?
brick9x dw 125			;Brick 9 x-component
brick9y dw 40			;Brick 9 y-component
check29 db ?
brick10x dw 165			;Brick 10 x-component
brick10y dw 40			;Brick 10 y-component
check210 db ?
brick11x dw 205			;Brick 11 x-component
brick11y dw 40			;Brick 11 y-component
check211 db ?
brick12x dw 245			;Brick 12 x-component
brick12y dw 40 			;Brick 12 y-component
check212 db ?

specialBx dw 145						
specialBy dw 13

brick13x dw 45			;Brick 13 x-component
brick13y dw 55			;Brick 13 y-component
check213 db ?
brick14x dw 85			;Brick 14 x-component
brick14y dw 55			;Brick 14 y-component
check214 db ?
brick15x dw 125			;Brick 15 x-component
brick15y dw 55			;Brick 15 y-component
check215 db ?
brick16x dw 165			;Brick 16 x-component
brick16y dw 55			;Brick 16 y-component
check216 db ?
brick17x dw 205			;Brick 17 x-component
brick17y dw 55			;Brick 17 y-component
check217 db ?
brick18x dw 245			;Brick 18 x-component
brick18y dw 55			;Brick 18 y-component
check218 db ?

.code
jmp main

setVideo proc
mov ax,0
mov al,00h
mov al,13h
int 10h
ret
setVideo endp

RemoveBrick proc 			;Removing the brick function
    
    push ax
    push bx
    push cx
    push dx
       
    mov startx, ax
    mov color, 0  
    mov ax, bx
    mov bx, startx
    
    add bx, 30
    
    mov endx,bx
    
    mov starty, ax 
    
    mov bx,starty
    
    add bx,7
    mov endy,bx
     
    call draw 
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
    RemoveBrick endp

makeBorder proc				;Making games border
 mov color,6    
    ;------TOP------------
    mov startx,20
    mov endx,300
    mov starty,5
    mov endy,8
    call draw
    ;------RIGHT------------
    mov startx,297
    mov endx,300
    mov starty,7
    mov endy,180
    call draw
    ;------LEFT------------
    mov startx,20
    mov endx,23
    mov starty,7
    mov endy,180
    call draw
    ;------BOTTOM------------
    mov startx,20
    mov endx,300
    mov starty,177
    mov endy,180
    call draw 
    ret
makeBorder endp

switcher proc				;Collision switcher for the ball
    cmp ballUp, 1
    je DownT
    jne UpT
    UpT:
    inc ballUp
    ret
    DownT:
    dec ballUp
    ret
switcher endp

draw proc				;Drawing pixels through given coordinates
push ax
    push cx
    push dx
     
    mov dx,starty
    mov cx,startx
    mov ah,0ch
    mov al,color
    dr:
    inc cx
    int 10h
    cmp cx,endx
    jne dr

    mov cx,startx
    inc dx
    cmp dx,endy
    jne dr
    
    pop dx
    pop cx
    pop ax
    ret
draw endp

drawStriker proc				;Drawing the strikerrrr
    push bx
    push cx
        
    mov bx, strikerX
    mov cx, strikerY   
    mov startx,bx
    .if (level == 1)
    add bx, 40

    .elseif (level == 2)
    add bx, 37

    .elseif (level == 3)
    add bx, 35
    .endif
    mov endx,bx
    mov starty,cx
    mov endy,175
    call draw
    
    pop cx
    pop bx
    ret
    drawStriker endp


    drawball proc				;Drawing the ball
    push bx
    mov bx, ballX
    mov startx, bx
    add bx, 4 
    mov endx,   bx
    mov bx, ballY
    mov starty, bx
    add bx, 4
    mov endy,   bx
    
    pop bx
    
    call draw
ret
drawball endp

DrawLivesScores proc			;Drawing the score and the lives
    push dx
    push ax
                 
    mov dh, 23 ;row
    mov dl, 5 ;col
    mov ah, 2 
    int 10h
    
    lea dx, score
    mov ah, 9
    int 21h
    
    call printScore  


    mov dh, 23
    mov dl, 17
    mov ah, 2
    int 10h
    lea dx,lives
    mov ah,9
    int 21h 

    mov dl, livesCount
    add dl, '0'
    mov ah, 2h
    int 21h

    mov dl, 3
    mov ah, 2h
    int 21h

    pop ax
    pop dx
    ret
    DrawLivesScores endp

printScore proc			;Printing the scores
    push ax
    push bx
    push cx
    push dx
    
    mov cx,0
    
    mov ax,scoreCount
    ll:
    mov bx,10
    mov dx,0
    div bx
    push dx
    inc cx
    cmp ax,0
    jne ll
    
    l2:
    pop dx
    mov ah,2
    add dl,'0'
    int 21h
    loop l2
    
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret
    printScore endp

   gameLoop proc				;Game Loop

   gameLoop1:        
   CALL    checkKeyboard		;Checking the input
   cmp begin,1
   jne gameLoop1

   cmp scoreCount, 18
   je bsok

   cmp livesCount, 0
   je lose
   
   call Collisionwall				;Checking the collisions with the wall
   call CollisionStriker 				;Checking the ball collision with the striker
   BrickCollision2 Brick1x, Brick1y
   BrickCollision2 Brick2x, Brick2y
   BrickCollision2 Brick3x, Brick3y
   BrickCollision2 Brick4x, Brick4y
   BrickCollision2 Brick5x, Brick5y
   BrickCollision2 Brick6x, Brick6y 
   BrickCollision2 Brick7x, Brick7y
   BrickCollision2 Brick8x, Brick8y
   BrickCollision2 Brick9x, Brick9y
   BrickCollision2 Brick10x, Brick10y
   BrickCollision2 Brick11x, Brick11y
   BrickCollision2 Brick12x, Brick12y 
   BrickCollision2 Brick13x, Brick13y
   BrickCollision2 Brick14x, Brick14y
   BrickCollision2 Brick15x, Brick15y
   BrickCollision2 Brick16x, Brick16y
   BrickCollision2 Brick17x, Brick17y
   BrickCollision2 Brick18x, Brick18y
   
   
   CALL baller  
   CALL sleep
   JMP     gameLoop1

   lose:
MOV AH, 3DH
MOV AL, 2
LEA DX, OFFSET F1
INT 21H
MOV FILEINFO, AX
MOV BX, FILEINFO
MOV CX, 0
MOV DX, 0
MOV AH, 42H
MOV AL, 2
INT 21H
add scoreCount, 48
MOV AH, 40H
MOV BX, FILEINFO
MOV CX, 1
MOV DX, OFFSET scoreCount
INT 21H

MOV AH, 40H
MOV BX, FILEINFO
MOV CX, 1
MOV DX, OFFSET skip
INT 21H

MOV AH, 3EH
MOV BX, FILEINFO
INT 21H
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
     writeWord 10, 19, 'L', 3
     writeWord 10, 20, 'O', 3
     writeWord 10, 21, 'S', 3
     writeWord 10, 22, 'E', 3
     mov ah, 00
     int 16h
     jmp wkw

   bsok:
MOV AH, 3DH
MOV AL, 2
LEA DX, OFFSET F1
INT 21H
MOV FILEINFO, AX
MOV BX, FILEINFO
MOV CX, 0
MOV DX, 0
MOV AH, 42H
MOV AL, 2
INT 21H

MOV AH, 40H
MOV BX, FILEINFO
MOV CX, 1
MOV DX, OFFSET scoreM1
INT 21H

MOV AH, 40H
MOV BX, FILEINFO
MOV CX, 1
MOV DX, OFFSET scoreM2
INT 21H

MOV AH, 40H
MOV BX, FILEINFO
MOV CX, 1
MOV DX, OFFSET skip
INT 21H

MOV AH, 3EH
MOV BX, FILEINFO
INT 21H
   wkw:
   ret
   gameLoop endp

   Collisionwall proc     			;Checking for the ball collisions with the wall
    
    mov bx, ballX
    mov cx, ballY
    
    checkLeftRight:
    cmp bx, 25; max left
    jl goRight
    cmp bx, 290; Max Right
    jg goLeft
    jmp checkUpDown
    goRight:
    mov ballLeft, 0 
    jmp checkUpDown
    goLeft:
    mov ballLeft, 1
    checkUpDown:
    
    cmp cx, 13;max top
    jl goDown
    cmp cx, 184;max bottom
    jg goUp
    
    
    jmp noInput
    goUp:                                            
    mov ballUp,1
    jmp noInput
    goDown: 
    mov ballUp, 0
    noInput:
    ret
    

    ret
    Collisionwall endp
    
exit:
    mov ah, 4ch
    int 21h


    checkKeyboard proc				;Check for the key press throughtout the game
    mov     ah,     1h
    int     16h         ; check keypress
    jz      noInput     ; no keypress
    
    mov     ah,     0h
    int     16h
    cmp     ax,     4D00h
    je      rightKey
    cmp     ax,     4B00h
    je      leftKey
    cmp     al,     27D
    je      exit
    cmp     ax,     3920h;space to begin
    je      beg
    jne     noInput 
    
    beg:
    mov begin,1
    
    noInput:
    ret  

    rightKey:     		;Right key function
    mov bx, boundaryEnd
    cmp     strikerX, bx ;max right limit
    jg      noInput
    redrawStriker 0
    add     strikerX, 5
    redrawStriker 7
    cmp begin,0
    jz moveBallRight
    jmp     noInput
    
    
    leftKey:   			;Left key function
    mov bx, boundaryStart                            
    cmp     strikerX, bx ;max left limit
    jl      noInput
    redrawStriker 0
    sub     strikerX, 5
    redrawStriker 7
    cmp begin,0
    jz moveBallLeft
    jmp     noInput
    
   		

   
    moveBallLeft:
    redrawBall 0
    sub     ballX, 5
    redrawBall 4
    jmp     noInput
    
    
    moveBallRight:
    redrawBall 0
    add     ballX, 5
    redrawBall 4
    jmp     noInput

checkKeyboard endp

CollisionStriker proc    	;Checking the collision of the plate with the ball and the border
    push ax
    push bx
    push cx
    push dx
    
    mov dx, ballY
    cmp dx, 165 ; striker surface check
    jl bhaag
    cmp dx, 170 ; striker missed
    jg fail 
    
    
    
    mov cx,strikerX   
    mov ax, ballX   
    cmp ax, cx  
    jl bhaag
    add cx , 40 
    cmp ax, cx
    jg bhaag
    
    mov ballUp, 1
    jmp bhaag
    
    
    fail:
    mov begin,0 
    dec livesCount 
    ;dec scoreCount   
    cmp livesCount, 0h
    je khatam
    call DrawLivesScores
    push ax
    push bx
    push cx
    push dx
    
    
    redrawBall 0
    
    mov ax, strikerX
    mov ballX,ax
    add ballX,18
    
    mov ballY,  163
    
    redrawBall 4
    mov ballUp, 1   
    mov ballLeft,0
    
    
    
    pop dx
    pop cx
    pop bx
    pop ax
    

    jmp bhaag
    
    
    
    khatam:             
    call DrawLivesScores
    
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
     writeWord 10, 19, 'L', 3
     writeWord 10, 20, 'O', 3
     writeWord 10, 21, 'S', 3
     writeWord 10, 22, 'E', 3
     mov ah, 00
     int 16h
    jmp bhaag
     
    
                  
    bhaag:  
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
    CollisionStriker endp

menu proc			;Creating the menu
push ax
push bx
push cx
push dx
push si




mov bl, 26			;Taking the name of the user
mov si, offset NAMEx
writeWord 10, 14, 'E', 3
writeWord 10, 15, 'n', 3
writeWord 10, 16, 't', 3
writeWord 10, 17, 'e', 3
writeWord 10, 18, 'r', 3
writeWord 10, 19, ' ', 3
writeWord 10, 20, 'n', 3
writeWord 10, 21, 'a', 3
writeWord 10, 22, 'm', 3
writeWord 10, 23, 'e', 3
writeWord 10, 24, ':', 3
writeWord 10, 25, ' ', 3
takename:

mov ah, 0
int 16h

cmp ah, 01Ch 
je rko

mov [si], al
writeWord 10, bl, al, 3
inc bl
inc si

jmp takename
rko:
mov si, offset NAMEx
sizex:
mov al, [si]
cmp al, '$'
je okkk
inc lengthVal
inc si
jmp sizex
okkk:

MOV AH, 3DH			;File handling the name
MOV AL, 2
LEA DX, OFFSET F1
INT 21H
MOV FILEINFO, AX
MOV BX, FILEINFO
MOV CX, 0
MOV DX, 0
MOV AH, 42H
MOV AL, 2
INT 21H

MOV AH, 40H
MOV BX, FILEINFO
MOV CX, lengthval
MOV DX, OFFSET NAMEx
INT 21H

MOV AH, 40H
MOV BX, FILEINFO
MOV CX, 1
MOV DX, OFFSET space
INT 21H

MOV AH, 3EH
MOV BX, FILEINFO
INT 21H

jmp menuj

menuj:

mov al, 0
mov bh, 0
mov bh, 0
mov cx, 0
mov dh, 80
mov dl, 80
mov ah, 06h
int 10h

writeWord 5, 7, 'B', 3                   ;Height - Width - Letter - Color
writeWord 5, 9, 'R', 3
writeWord 5, 11, 'I', 3
writeWord 5, 13, 'C', 3
writeWord 5, 15, 'K', 3

writeWord 5, 22, 'B', 3
writeWord 5, 24, 'R', 3
writeWord 5, 26, 'E', 3
writeWord 5, 28, 'A', 3
writeWord 5, 30, 'K', 3
writeWord 5, 32, 'E', 3
writeWord 5, 34, 'R', 3

mov startx, 35
mov endx, 295
mov starty, 30
mov endy, 35
mov color, 6
call draw

mov starty, 50
mov endy, 55
mov color, 6
call draw

mov startx, 35
mov endx, 40
mov starty, 30
mov endy, 55
mov color, 6
call draw

mov startx, 290
mov endx, 295
mov color, 6
call draw

writeWord 9, 14, '1', 3
writeWord 9, 15, ')', 3
writeWord 9, 16, 'N', 3
writeWord 9, 17, 'e', 3
writeWord 9, 18, 'w', 3
writeWord 9, 19, ' ', 3
writeWord 9, 20, 'G', 3
writeWord 9, 21, 'a', 3
writeWord 9, 22, 'm', 3
writeWord 9, 23, 'e', 3


writeWord 11, 14, '2', 3
writeWord 11, 15, ')', 3
writeWord 11, 16, 'I', 3
writeWord 11, 17, 'n', 3
writeWord 11, 18, 's', 3
writeWord 11, 19, 't', 3
writeWord 11, 20, 'r', 3
writeWord 11, 21, 'u', 3
writeWord 11, 22, 'c', 3
writeWord 11, 23, 't', 3
writeWord 11, 24, 'i', 3
writeWord 11, 25, 'o', 3
writeWord 11, 26, 'n', 3
writeWord 11, 27, 's', 3


writeWord 13, 14, '3', 3
writeWord 13, 15, ')', 3
writeWord 13, 16, 'H', 3
writeWord 13, 17, 'i', 3
writeWord 13, 18, 'g', 3
writeWord 13, 19, 'h', 3
writeWord 13, 20, ' ', 3
writeWord 13, 21, 'S', 3
writeWord 13, 22, 'c', 3
writeWord 13, 23, 'o', 3
writeWord 13, 24, 'r', 3
writeWord 13, 25, 'e', 3
writeWord 13, 26, 's', 3



mov ah, 0
int 16h

cmp ah, 4			;3 for High score screen
je highsc

cmp ah, 5			;4 for easy level
je game

cmp ah, 6			;5 for medium difficulty
je game2

cmp ah, 7			;6 for hard level difficulty
je game3

cmp ah, 3			;2 for instructions
je Inst

jmp menuj


highsc:
mov al, 0
mov bh, 0
mov bh, 0
mov cx, 0
mov dh, 80
mov dl, 80
mov ah, 06h
int 10h



writeWord 21, 5, 'E' ,3
writeWord 21, 6, 's' ,3
writeWord 21, 7, 'c' ,3

writeWord 2, 5, 'N', 3
writeWord 2, 6, 'a', 3
writeWord 2, 7, 'm', 3
writeWord 2, 8, 'e', 3
writeWord 2, 9, ' ', 3
writeWord 2, 16, 'H', 3
writeWord 2, 17, 'i', 3
writeWord 2, 18, 'g', 3
writeWord 2, 19, 'h', 3
writeWord 2, 20, ' ', 3
writeWord 2, 21, 's', 3
writeWord 2, 22, 'c', 3
writeWord 2, 23, 'o', 3
writeWord 2, 24, 'r', 3
writeWord 2, 25, 'e', 3

writeWord 4, 5, 'A', 3
writeWord 4, 6, 'b', 3
writeWord 4, 7, 'd', 3
writeWord 4, 8, 'u', 3
writeWord 4, 9, 'l', 3
writeWord 4, 10, 'l', 3
writeWord 4, 11, 'a', 3
writeWord 4, 12, 'h', 3

writeWord 4, 16, '1', 3
writeWord 4, 17, '8', 3



mov ah, 0
int 16h
cmp ah, 01
je menuj
jmp highsc

Inst:
mov al, 0
mov bh, 0
mov bh, 0
mov cx, 0
mov dh, 80
mov dl, 80
mov ah, 06h
int 10h


writeWord 2, 5, 26, 3
writeWord 2, 6, 'I', 3
writeWord 2, 7, 'n', 3
writeWord 2, 8, 's', 3
writeWord 2, 9, 't', 3
writeWord 2, 10, 'r', 3
writeWord 2, 11, 'u', 3
writeWord 2, 12, 'c', 3
writeWord 2, 13, 't', 3
writeWord 2, 14, 'i', 3
writeWord 2, 15, 'o', 3
writeWord 2, 16, 'n', 3
writeWord 2, 17, 's', 3

writeWord 5, 5, '-', 3
writeWord 5, 6, 'P', 3
writeWord 5, 7, 'r', 3
writeWord 5, 8, 'e', 3
writeWord 5, 9, 's', 3
writeWord 5, 10, 's', 3
writeWord 5, 11, ' ', 3
writeWord 5, 12, 27 , 3
writeWord 5, 13, ' ', 3
writeWord 5, 14, 26 , 3
writeWord 5, 15, ' ', 3
writeWord 5, 16, 't' ,3
writeWord 5, 17, 'o' ,3
writeWord 5, 18, ' ' ,3
writeWord 5, 19, 'm' ,3
writeWord 5, 20, 'o' ,3
writeWord 5, 21, 'v' ,3
writeWord 5, 22, 'e' ,3
writeWord 5, 23, '.' ,3

writeWord 8, 5, '-' ,3
writeWord 8, 6, 'B' ,3
writeWord 8, 7, 'r' ,3
writeWord 8, 8, 'e' ,3
writeWord 8, 9, 'a' ,3
writeWord 8, 10, 'k' ,3
writeWord 8, 11, ' ' ,3
writeWord 8, 12, 'a' ,3
writeWord 8, 13, 'l' ,3
writeWord 8, 14, 'l' ,3
writeWord 8, 15, ' ' ,3
writeWord 8, 16, 'b' ,3
writeWord 8, 17, 'r' ,3
writeWord 8, 18, 'i' ,3
writeWord 8, 19, 'c' ,3
writeWord 8, 20, 'k' ,3
writeWord 8, 21, 's' ,3
writeWord 8, 22, ' ' ,3
writeWord 8, 23, 't' ,3
writeWord 8, 24, 'o' ,3
writeWord 8, 25, ' ' ,3
writeWord 8, 26, 'w' ,3
writeWord 8, 27, 'i' ,3
writeWord 8, 28, 'n' ,3

writeWord 11, 5, '-' ,3
writeWord 11, 6, 'Y' ,3
writeWord 11, 7, 'o' ,3
writeWord 11, 8, 'u' ,3
writeWord 11, 9, ' ' ,3
writeWord 11, 10, 'l' ,3
writeWord 11, 11, 'o' ,3
writeWord 11, 12, 's' ,3
writeWord 11, 13, 'e' ,3
writeWord 11, 14, ' ' ,3
writeWord 11, 15, 'i' ,3
writeWord 11, 16, 'f' ,3
writeWord 11, 17, ' ' ,3
writeWord 11, 18, 'y' ,3
writeWord 11, 19, 'o' ,3
writeWord 11, 20, 'u' ,3
writeWord 11, 21, ' ' ,3
writeWord 11, 22, 'd' ,3
writeWord 11, 23, 'r' ,3
writeWord 11, 24, 'o' ,3
writeWord 11, 25, 'p' ,3
writeWord 11, 26, ' ' ,3
writeWord 11, 27, 't' ,3
writeWord 11, 28, 'h' ,3
writeWord 11, 29, 'r' ,3
writeWord 11, 30, 'i' ,3
writeWord 11, 31, 'c' ,3
writeWord 11, 32, 'e' ,3

writeWord 14, 5, '-' ,3
writeWord 14, 6, 'P' ,3
writeWord 14, 7, 'r' ,3
writeWord 14, 8, 'e' ,3
writeWord 14, 9, 's' ,3
writeWord 14, 10,'s' ,3
writeWord 14, 11, ' ' ,3
writeWord 14, 12, '4' ,3
writeWord 14, 13, '-' ,3
writeWord 14, 14, '5' ,3
writeWord 14, 15, '-' ,3
writeWord 14, 16, '6' ,3
writeWord 14, 17, ' ' ,3
writeWord 14, 18, 'f' ,3
writeWord 14, 19, 'o' ,3
writeWord 14, 20, 'r' ,3
writeWord 14, 21, ' ' ,3
writeWord 14, 22, 'd' ,3
writeWord 14, 23, 'i' ,3
writeWord 14, 24, 'f' ,3
writeWord 14, 25, 'f' ,3
writeWord 14, 26, 'e' ,3
writeWord 14, 27,'r' ,3
writeWord 14, 28, 'e' ,3
writeWord 14, 29, 'n' ,3
writeWord 14, 30, 't' ,3
writeWord 14, 31, ' ' ,3
writeWord 14, 32, 'l' ,3
writeWord 14, 33, 'e' ,3
writeWord 14, 34, 'v' ,3
writeWord 14, 35, 'e' ,3
writeWord 14, 36, 'l' ,3
writeWord 14, 37, 's' ,3
writeWord 14, 38, '.' ,3


writeWord 17, 5, '-' ,3
writeWord 17, 6, 'P' ,3
writeWord 17, 7, 'r' ,3
writeWord 17, 8, 'e' ,3
writeWord 17, 9, 's' ,3
writeWord 17, 10, 's' ,3
writeWord 17, 11, ' ' ,3
writeWord 17, 12, 's' ,3
writeWord 17, 13, 'p' ,3
writeWord 17, 14, 'a' ,3
writeWord 17, 15, 'c' ,3
writeWord 17, 16, 'e' ,3
writeWord 17, 17, ' ' ,3
writeWord 17, 18, 't' ,3
writeWord 17, 19, 'o' ,3
writeWord 17, 20, ' ' ,3
writeWord 17, 21, 's' ,3
writeWord 17, 22, 't' ,3
writeWord 17, 23, 'a' ,3
writeWord 17, 24, 'r' ,3
writeWord 17, 25, 't' ,3


writeWord 21, 5, 'E' ,3
writeWord 21, 6, 's' ,3
writeWord 21, 7, 'c' ,3

mov ah, 0
int 16h
cmp ah, 01
je menuj
jmp Inst


game:
mov al, 0
mov bh, 0
mov bh, 0
mov cx, 0
mov dh, 80
mov dl, 80
mov ah, 06h
int 10h
mov level, 1
jmp okgo

game2:
mov al, 0
mov bh, 0
mov bh, 0
mov cx, 0
mov dh, 80
mov dl, 80
mov ah, 06h
int 10h
mov level, 2
jmp okgo

game3:
mov al, 0
mov bh, 0
mov bh, 0
mov cx, 0
mov dh, 80
mov dl, 80
mov ah, 06h
int 10h
mov level, 3
jmp okgo

okgo:
MOV AH, 3DH
MOV AL, 2
LEA DX, OFFSET F1
INT 21H
MOV FILEINFO, AX
MOV BX, FILEINFO
MOV CX, 0
MOV DX, 0
MOV AH, 42H
MOV AL, 2
INT 21H

mov al, level
mov levelName, al
add levelName, 48

MOV AH, 40H
MOV BX, FILEINFO
MOV CX, 1
MOV DX, OFFSET levelName		;File handling the name of the level
INT 21H


MOV AH, 40H
MOV BX, FILEINFO
MOV CX, 1
MOV DX, OFFSET space
INT 21H

MOV AH, 3EH
MOV BX, FILEINFO
INT 21H

pop si
pop dx
pop cx
pop bx
pop ax
ret
menu endp

baller proc  			;Function for the movement of the ball
      run:
      mov dl, innerDelay
	cmp dl, EXTERNDELAY
      inc innerDelay
	jne run 
	mov innerDelay, 0
      redrawBall 0  
      
	mov bx,ballX 
	cmp ballLeft, 1
	je Left
	jne Right
	
	Left:   
	sub bx, 1 
	jmp P2;  
	Right:   
	add bx, 1
	
	P2:
	mov ballX,  bx
	mov bx, ballY
	cmp ballUp, 1   
	je Up
	jne Down
	Up:
    sub bx, 1
	jmp P3
	Down:
    add bx, 1
	P3:
    mov ballY,  bx

    redrawBall 04
    
ret
baller endp   

sleep proc
.if (level == 1)
mov cx,111111111111111b 
.endif

.if (level == 2)
mov cx, 111111111111000b
.endif 

.if (level == 3)
mov cx, 110000000000000b
.endif 


l:
loop l
ret
sleep endp


sound proc
        push ax
        push bx
        push cx
        push dx
        mov     al, 182         ; Prepare the speaker.
        out     43h, al         
        mov     ax, 200        ; Frequency number (in decimal)
                                ;  for middle C.
        out     42h, al         ; Output low byte.
        mov     al, ah          ; Output high byte.
        out     42h, al 
        in      al, 61h         ; Turn on note (get value from
                                ;  port 61h).
        or      al, 00000011b   ; Set bits 1 and 0.
        out     61h, al         ; Send new value.
        mov     bx, 2          ; Pause for duration of note.
pause1:
        mov     cx, 65535
pause2:
        dec     cx
        jne     pause2
        dec     bx
        jne     pause1
        in      al, 61h         ; Turn off note (get value from
                                ;  port 61h).
        and     al, 11111100b   ; Reset bits 1 and 0.
        out     61h, al         ; Send new value.

        pop dx
        pop cx
        pop bx
        pop ax

ret
sound endp

main:
mov ax, @data
mov ds, ax


call setVideo
call menu
.if (level == 1)
mov strikerX, 140
mov strikery, 170
.endif
.if (level == 2)
mov strikerX, 143
mov strikery, 170
.endif
.if (level == 3)
mov strikerX, 145
mov strikery, 170
.endif

call makeBorder
    BuildBrick brick1x, brick1y, 4
    BuildBrick brick2x, brick2y, 4
    BuildBrick brick3x, brick3y, 4
    BuildBrick brick4x, brick4y, 4
    BuildBrick brick5x, brick5y,1
    BuildBrick brick6x, brick6y,1
    BuildBrick brick7x, brick7y,1
    BuildBrick brick8x, brick8y,1
    BuildBrick brick9x, brick9y,2
    BuildBrick brick10x, brick10y,2
    BuildBrick brick11x, brick11y,2
    BuildBrick brick12x, brick12y,2
    BuildBrick brick13x, brick13y,14
    BuildBrick brick14x, brick14y,14
    BuildBrick brick15x, brick15y,14
    BuildBrick brick16x, brick16y,14
    BuildBrick brick17x, brick17y,9
    BuildBrick brick18x, brick18y,9
    ;BuildBrick specialBx, specialBy
    .if (level == 1)
    redrawStriker 7
    redrawBall 4 
    call sleep
    call DrawLivesScores
    call gameLoop
    .endif
    .if (level == 2)
    redrawStriker 7
    redrawBall 4 
    call sleep
    call DrawLivesScores
    call gameLoop
    .endif
     .if (level == 3)
    redrawStriker 7
    redrawBall 4 
    call sleep
    call DrawLivesScores
    call gameLoop
    .endif


mov ah, 4ch
int 21h
end