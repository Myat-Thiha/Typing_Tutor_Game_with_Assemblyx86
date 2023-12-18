.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode: DWORD

;Testing color
;Testing SetTextColor and GetTextColor

INCLUDE Irvine32.inc

.data
	COL = 7  ; calculate the window panel size to fit in the words
	ROW = 50 ; this should be twice the numbers of strings generated
	str_array byte ROW * COL DUP(?),0 ;this is kinda memory insufficient but this kinda declaration is to avoid loosing strings and printing garbages
	pos_array word ROW DUP(?),0
	; define your variables here
	menu_str byte "Choose 1 for floating game or 2 for original game",0
	difficulty Byte "Choose difficulty: Easy(E), Medium(M), Hard(H)",0
	errorMessage Byte "Wrong input: Enter Again!",0
	back Byte 08h
	str1 byte "Hello Lancers! CS066 is fun. Take Professor Barkeshli class. He is a cool guy.",0
	line1 byte "-----------------------------------------------------------------------------------------------------------------------",0
	char Byte ?
	str2 byte "It is equal",0
	temp byte 00h
	_col byte 00h
	_row byte 00h
	maxRow byte ?
	maxCol byte ?
	speed dword 1000
	msec dword ?
	printedStr dword 1
	doneStr DWORD 0
	input_str byte COL dup (?)
	pos dword 0
	error byte 0
	pos_index dword 0
	finish dword 0
	str_index dword 0
	is_win byte 0
	win_message byte "YOU WON!!! Press 1 to play again, Press M for menu, Press any key to end.",0
	lose_message byte "YOU LOSE!! Press 1 to play again, Press M for menu, Press any key to end.",0
.code

comparing PROC uses EAX edx
	mov esi,edx
	call ReadChar
	;call WriteString
	cmp al,[esi]
	mov char,al
	ret
comparing ENDP

rewrite_equal PROC uses EAX edx
;mov ax,green
;mov edx, OFFSET str1
;add edx, dword ptr temp 
;call SetTextColor
;call writeString

mov ax,blue+(green*16)
call SetTextColor
mov al,[esi]
call WriteChar
add temp, 01h
ret
rewrite_equal ENDP

is_back PROC uses EAX
mov al,char
cmp al,back
je back_equal
call rewrite_not_equal
jmp L4
back_equal:
sub temp,01h
call cover
add ecx, 2
L4: 
ret
is_back ENDP


cover PROC uses edx eax
mov dl,temp
mov dh,0
call gotoxy
mov ax, blue+(white*16)
call SetTextColor
dec esi
mov al,[esi]
call WriteChar

ret
cover ENDP

rewrite_not_equal PROC uses eax edx
mov ax, blue+(red*16)
call SetTextColor
mov al,[esi]
call WriteChar
add temp,01h
ret
rewrite_not_equal ENDP


typing PROC
	mov ax, blue+(white*16)
	call SetTextColor 
	mov edx, OFFSET str1
	call WriteString
	mov ecx, 25
	
	L1:
	call crlf
	loop L1
	mov edx,OFFSET line1
	call WriteString
	mov edx,OFFSET line1
	call WriteString
	mov ecx, lengthof str1
	mov temp,0
	L2:
	mov dl,temp
	mov dh,0
	call gotoxy
	mov edx,OFFSET str1
	add edx,dword ptr temp
	call comparing
	je is_equal
	call is_back
	jmp L3
	is_equal:
	call rewrite_equal
	L3:
	;add temp, 01h
	;mov dl, temp
	;mov dh, 0
	;call gotoxy
	;call cover
	loop L2

call dumpRegs
typing ENDP

menu PROC
	begin:
	mov dh,15
	mov dl,33
	call gotoxy
	mov ax, White 
	call SetTextColor
	mov edx, OFFSET menu_str
	call writestring
	call ReadChar
	cmp al,32h
	je is_equal
	L1:
		call Reset
		call clrscr
		mov dh,15
		mov dl,33
	call gotoxy
		mov edx, OFFSET difficulty
	call WriteString
		call ReadChar
	.IF al=='E' || al=='e'
		mov speed,1200
	.ELSEIF al=='M' || al=='m'
		mov speed,1000
	.ELSEIF al=='H' || al=='h'
		mov speed,800
	.ELSE
		call clrscr
		mov edx, OFFSET errorMessage
		call WriteString
		mov eax, 1500
		call delay
		jmp L1
	.ENDIF
	call clrscr
	call FloatingStrings
	jmp L5
	is_equal:
	call clrscr
	mov temp,00h
	call typing
L5:
	call clrscr
	.IF is_win==1
		mov dh,15
		mov dl,33
		call gotoxy
		mov edx, OFFSET win_message
		call WriteString
		call ReadChar
		.IF al=='1'
		call clrscr
		jmp L1
		.ELSEIF al=='M' || al=='m'
		call clrscr
		jmp begin
		.ELSE 
		call clrscr
		jmp F
		.ENDIF
	.ELSE 
		mov dh,15
		mov dl,33
		call gotoxy
		mov edx, OFFSET lose_message
		call WriteString
		call ReadChar
		.IF al=='1'
		call clrscr
		jmp L1
		.ELSEIF al=='M' || al=='m'
		call clrscr
		jmp begin
		.ELSE
		call clrscr
		jmp F
		.ENDIF
	.ENDIF
	F:
ret
menu ENDP

Reset PROC 
	mov ecx, ROW*COL ;size of str_array
	mov esi, OFFSET str_array
	L1:
	mov BYTE PTR[esi], 0
	inc esi
	loop L1
	call Reset_Input
	mov finish, 0
	mov is_win, 0
	mov printedStr, 1
	mov str_index,0
	mov pos_index,0
	mov pos, 0
	mov error, 0
	mov doneStr, 0
	ret
Reset ENDP

floating PROC uses edx

mov dh, 24
movzx ecx,dh
mov eax,70
call RandomRange
mov dword ptr _col, eax

L5:
mov dl, 0
mov dh, 25
call gotoxy     
mov edx, OFFSET line1
call writeString
mov dl,_col
mov dh,_row
call gotoxy
mov edx, OFFSET menu_str
call writeString
mov esi,edx
call ReadKey
    cmp al, [esi]
    jne WRONG_KEY
    call rewrite_equal

    WRONG_KEY:


add _row,01			
mov eax,1000
call Delay
call Clrscr
loop L5
mov edx, OFFSET menu_str
;call comparing
;je is_equal
;jmp L3
;is_equal:
;call writestring
;call rewrite_equal
L3:
ret
floating ENDP


BetterRandomRange PROC 
	sub eax, ebx		;set eax to positive number
	call RandomRange
	add eax, ebx		;add back with original lower bound
	ret
BetterRandomRange ENDP

										;esi should hold the offset of str_array
RandomString PROC uses ecx ebx eax esi		;return random string and stored in str_array
	mov eax, COL -1			;limit string size
	mov ebx, 2
	call BetterRandomRange
	mov ecx, eax
	inc ecx
	L5:
		mov eax, 26
		call RandomRange	;generate within 26 alphabets
		add eax, 'a'		;move eax to first Alpha
		mov [esi],al		;change the string
		inc esi				;increase to next index
		loop L5
		;inc count
	ret
RandomString ENDP

RandomColumn PROC			;generate random column no.
	movzx eax, maxCol		
	sub eax, COL			;fix the margin cases
	call RandomRange
	ret
RandomColumn ENDP

SetMaxXY PROC
	call GetMaxXY			;al=row dl=col
	mov maxRow, al			;save max Y
	mov maxCol, dl			;save max X
	ret
SetMaxXY ENDP

GenerateStrings PROC uses ecx ebx
	mov ecx, 10					;loop counter
	mov edi, OFFSET pos_array
	mov esi, OFFSET str_array
	call Randomize
	L1:
		call RandomString		;create random string in str_array
		call RandomColumn		;store random col in al
		mov dl,al				;mov random col num to dl
		mov dh,0				;initialize location to first row
		mov [edi], dx			;store the location of strings
		add edi, TYPE pos_array	;move next index of location
		add esi, COL			;move next index of str_array
		loop L1
	ret
GenerateStrings ENDP

NextRow PROC						;dx has the row and col num; ax has the index
		inc dh						;move string by 1 row
		mov [pos_array + ax], dx	;save new location
	ret
NextRow ENDP

Reset_Input PROC uses esi
	mov esi, 0						;index counter
	mov ecx, COL					;loop counter
	L1:	
		mov [input_str + esi],0		;set every index to zero
		inc esi
		loop L1
	ret
Reset_Input ENDP


Check PROC uses esi edi ebx edx ecx eax;al has the char of keyboard input
	mov esi, OFFSET	input_str					
	mov edi, OFFSET str_array	
	
	mov eax, 1
	call Delay
	call Readkey					;read key pressed
	jz DONE							;if not pressed, exit
	
	push eax
	mov eax, str_index				;find index of str_array	
	mov edx, COL
	mul edx
	add edi, eax				;move edi to current idex
	pop eax
	mov edx, pos
		
		.IF al == [edi+edx]			;compare al with respective char
			mov error, 0			;if chars are the same, then no error
			add esi,pos					;if not end, store the char to inputArr
			mov [esi],al
			inc pos
			inc edx
			.IF BYTE PTR [edi+edx]==0   ;check if this index is end of the string
				mov BYTE PTR [edi], 0	;clear the string
				inc doneStr				;increment the completed string
				mov finish, 1
				;dec printedStr
				jmp DONE
			.ENDIF	
		.ELSE
			mov al, [edi+edx]			;if not correct, error
			mov error, al
		.ENDIF
	DONE:
		mov ebx, str_index
		mov pos_index, ebx
		mov eax, pos_index
		mov ebx, TYPE pos_array
		mul ebx
		mov dx, [pos_array + eax]		;get the position
		dec dh							;decrement one row since this proc is called after new row is added
		call Gotoxy
		mov edx, OFFSET input_str	
		mov eax, green + (black*16)
		call SetTextColor				;printed typed chars
		call WriteString
		.IF error != 0
			mov eax, red + (black*16)
			call SetTextColor
			mov al, error
			call WriteChar				;if there is errors, print with red color
		.ENDIF
		mov eax, white + (black*16)		;change back to default
		call SetTextColor
		.IF finish == 1			
			call Reset_Input		;clear input string
			mov pos,0				;set input array pos to 0
			mov finish, 0
			add str_index,1
		.ENDIF

	ret
Check ENDP

FloatingStrings PROC uses eax

	call SetMaxXY				;set Max row and col
	call GenerateStrings		;generate 25 strings
	mov ecx, 0				    ;loop counter

	call Getmseconds

	add eax, speed
	mov msec, eax
L1:	
	mov ecx, printedStr			;loop counter
	mov eax, 0					;index of pos_array
	mov edx, OFFSET str_array	;pointer pointing to str_array
	cmp doneStr, 10
	jz DONE1
	L2:
		push eax
		mov esi, edx
		mov al, [edx]
		mov dl, al
		pop eax
		.IF dl!=0
			mov dx, [pos_array + ax]	;get the location of specific string
			cmp dh, maxRow				;If the string reach the button, leave the function
			jz DONE2
			call GotoXY					;go to current location

			push edx
			mov edx, esi

			call WriteString
			
			pop edx
			call NextRow				;store the new location
		.ENDIF
			mov edx, esi				;restore pointer to str_array
			add edx, COL				;next index for new string
			add ax, TYPE pos_array		;next index for location
			
		loop L2
		
L3:
	call Check
	call Getmseconds
	.IF eax >= msec
		call clrscr
			inc printedStr					;increment the number of printed string
			add eax, speed					;delay
			mov msec, eax
			
	.ELSE
		jmp L3
	.ENDIF
	jmp L1
DONE1:
	mov is_win, 1
DONE2:
	ret
FloatingStrings ENDP

main PROC
	; write your assembly code here
	call menu
	INVOKE ExitProcess, 0
main ENDP
END main