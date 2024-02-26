;;
; Copyright Jacques Deschênes 2019 
; This file is part of MONA 
;
;     MONA is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.
;
;     MONA is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.
;
;     You should have received a copy of the GNU General Public License
;     along with MONA.  If not, see <http://www.gnu.org/licenses/>.
;;
;--------------------------------------
;   globals sub-routines and variables
;   module 
;--------------------------------------
    .module GLOBALS 


	
    .area CODE 

;--------------------------------
; <format> is a simplifide version
; of 'C' <printf>
; input:
;   Y       pointer to template string 
;   stack   all others paramaters are on 
;           stack. First argument is at (3,sp)
; output:
;   none
; use:
;   X       used as frame pointer  
; Detail:
;   template is a .asciz string with embedded <%c>
;   to indicate parameters positision. First <%c> 
;   from left correspond to first parameter.
;   'c' is one of these: 
;      'a' print a count of SPACE for alignement purpose     
;      'b' byte parameter  (int8_t)
;      'c' ASCII character
;      'e' 24 bits integer (int24_t) parameter
;      'p' position curseur at column 
;      's' string (.asciz) parameter as long pointer (16 bits)
;      'w' word paramter (int16_t) 
;      others values of 'c' are printed as is.
;  These are sufficient for the requirement of
;  mona_dasm
;--------------------------------
    LOCAL_OFS=8 ; offset on stack of arguments frame 
format::
; preserve X
    pushw x 
; preserve farptr
    ld a, farptr+2
    push a 
    ld a, farptr+1 
    push a 
    ld a, farptr
    push a
; X used as frame pointer     
    ldw x,sp 
    addw x,#LOCAL_OFS
format_loop:    
    ld a,(y)
    jrne 1$
    jp format_exit
1$: incw y 
    cp a,#'%
    jreq 2$
    call uart_putc
    jra format_loop  
2$:
    ld a,(y)
    jreq format_exit 
    incw y
    cp a,#'a' 
    jrne 24$
    ld a,(x)
    incw x 
    pushw x 
    clrw x 
    ld xl,a 
    call spaces 
    popw x 
    jra format_loop 
24$:
    cp a,#'b'
    jrne 3$
; byte type paramEter     
    ld a,(x)
    incw x 
    call print_hex
    ld a,#SPACE 
    call uart_putc  
    jra format_loop
3$: cp a,#'c 
    jrne 4$
; ASCII character 
    ld a,(x)
    incw x 
    call uart_putc 
    jra format_loop         
4$: cp a,#'e 
    jrne 6$
; int24_t parameter     
    pushw y 
    ld a,(x)
    ld yh,a 
    incw x
    ld a,(x)
    ld yl,a 
    incw x 
    ld a,(x)
    incw x 
    call print_extd
    popw y  
    jra format_loop
6$: cp a,#'p 
    jrne 7$
    ld a,(x)
    incw x 
    call cursor_column
    jra format_loop 
7$: cp a,#'s 
    jrne 8$
; string type parameter     
    pushw x
    ldw x,(x) 
    call puts  
    popw x 
    addw x,#2
    jra format_loop 
8$: cp a,#'w 
    jrne 9$
; word type parameter     
    ld a,(x)
    call print_hex 
    ld a,(1,x)
    call print_code  
    addw x,#2 
    jp format_loop 
9$: call uart_putc         
    jp format_loop 
format_exit:
; restore farptr 
    pop a 
    ld farptr,a 
    pop a 
    ld farptr+1,a 
    pop a 
    ld farptr+2,a 
    popw x 
    ret 

;------------------------------------
;  serial port communication routines
;------------------------------------

;------------------------------------
; send string via UART2
; y is pointer to str
;------------------------------------
uart_print::
; check for null pointer  
	cpw y,#0
    jreq 1$ 
0$: ld a,(y)
	jreq 1$
	call uart_putc
	incw y
	jra 0$
1$: ret

;-----------------------------------
; print a string (.asciz) pointed
; by a far pointer 
; input:
;   farptr    pointer to string 
; output:
;   none
;----------------------------------- 
uart_prints::
    pushw y 
    clrw y
1$:
    ldf a,([farptr],y)
    jreq 2$
    call uart_putc 
    incw y 
    jra 1$
2$:
    popw y 
    ret 

.if 0
;------------------------------------
; print integer in ACC24 
; input:
;	ACC24 		integer to print 
;	A 			numerical base for conversion 
;   XL 			field width, 0 -> no fill.
;  output:
;    none 
;------------------------------------
	BASE = 2
	WIDTH = 1
	LOCAL_SIZE = 2
fprint_int::
	pushw y 
	sub sp,#LOCAL_SIZE 
	ld (BASE,sp),a 
	ld a,xl
	ld (WIDTH,sp),a 
	ld a, (BASE,sp)  
    call itoa  ; conversion entier en  .asciz
	ld ACC8,a ; string length 
	ld a,#16
	cp a,(BASE,sp)
	jrne 1$
	decw y 
	ld a,#'$
	ld (y),a
	inc ACC8 
1$: ld a,(WIDTH,sp) 
	jreq 4$
	sub a,ACC8
	jrule 4$
	ld (WIDTH,sp),a 
	ld  a,#SPACE
3$: tnz (WIDTH,sp)
	jreq 4$
	jrmi 4$
	decw y 
	ld (y),a 
	dec (WIDTH,sp) 
	jra 3$
4$: call uart_print
	ld a,#SPACE 
	call uart_putc 
    addw sp,#LOCAL_SIZE 
	popw y 
    ret	
.endif 

;----------------------------
; print 24 bits integer in Y:A 
; in hexadecimal format 
; input:
;   Y	bits 23:16 
;   A   bits 7:0
;----------------------------
print_extd:
    push a 
    ld a,yh
    tnz a 
    jreq 1$ 
    call print_hex
1$:
    ld a,yl
    tnz a 
    jreq 2$ 
    call print_hex 
2$: 
    pop a 
    call print_hex
    ld a,#SPACE 
    call uart_putc 
    ret 

.if 0
;------------------------------------
; print *farptr
; input:
;    *farptr 
; use:
;	ACC24	itoa conversion 
;   A 		conversion base
;   XL		field width 
;------------------------------------
print_addr::
	pushw x
	push a 
	ldw x, farptr 
	ldw ACC24,x 
	ld a,farptr+2 
	ld ACC8,a 
	ld a,#6  
	ld xl, a  ; field width 
	ld a,#16 ; convert in hexadecimal 
	call fprint_int 
	pop a 
	popw x 
	ret 
.endif 

;------------------------------------
; convert integer to string
; input:
;   A	  	base
;	ACC24	integer to convert
; output:
;   y  		pointer to string
;   A 		string length 
;------------------------------------
	SIGN=1  ; integer sign 
	BASE=2  ; numeric base 
	LOCAL_SIZE=2  ;locals size
itoa:
	sub sp,#LOCAL_SIZE
	ld (BASE,sp), a  ; base
	clr (SIGN,sp)    ; sign
	cp a,#10
	jrne 1$
	; base 10 string display with negative sign if bit 23==1
	btjf ACC24,#7,1$
	cpl (SIGN,sp)
	call neg_acc24
1$:
; initialize string pointer 
	ldw y,#pad+PAD_SIZE-1
	clr (y)
itoa_loop:
    ld a,(BASE,sp)
    call divu24_8 ; ACC24/A 
    add a,#'0  ; remainder of division
    cp a,#'9+1
    jrmi 2$
    add a,#7 
2$: decw y
    ld (y),a
	; if ACC24==0 conversion done
	ld a,ACC24
	or a,ACC16
	or a,ACC8
    jrne itoa_loop
	;conversion done, next add '$' or '-' as required
	ld a,(BASE,sp)
	cp a,#16
	jreq 10$
    ld a,(SIGN,sp)
    jreq 10$
    decw y
    ld a,#'-
    ld (y),a
10$:
	addw sp,#LOCAL_SIZE
	call strlen
	ret

