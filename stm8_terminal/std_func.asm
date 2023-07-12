;;
; Copyright Jacques Deschênes 2019,2022,2023  
; This file is part of stm8_tbi 
;
;     stm8_tbi is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.
;
;     stm8_tbi is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.
;
;     You should have received a copy of the GNU General Public License
;     along with stm8_tbi.  If not, see <http://www.gnu.org/licenses/>.
;;

;--------------------------
; standards functions
;--------------------------


;--------------------------
	.area CODE
;--------------------------

;--------------------------------------
; retrun string length
; input:
;   X         .asciz  pointer 
; output:
;   X         not affected 
;   A         length 
;-------------------------------------
strlen::
	pushw x 
	clr a
1$:	tnz (x) 
	jreq 9$ 
	inc a 
	incw x 
	jra 1$ 
9$:	popw x 
	ret 

;------------------------------------
; compare 2 strings
; input:
;   X 		char* first string 
;   Y       char* second string 
; output:
;   Z flag 	0 != | 1 ==  
;-------------------------------------
strcmp::
	ld a,(x)
	jreq 5$ 
	cp a,(y) 
	jrne 9$ 
	incw x 
	incw y 
	jra strcmp 
5$: ; end of first string 
	cp a,(y)
9$:	ret 

;---------------------------------------
;  copy src string to dest 
; input:
;   X 		dest 
;   Y 		src 
; output: 
;   X 		dest 
;----------------------------------
strcpy::
	push a 
	pushw x 
1$: ld a,(y)
	jreq 9$ 
	ld (x),a 
	incw x 
	incw y 
	jra 1$ 
9$:	clr (x)
	popw x 
	pop a 
	ret 

;---------------------------------------
; move memory block 
; input:
;   X 		destination 
;   Y 	    source 
;   acc16	bytes count 
; output:
;   X       destination 
;--------------------------------------
	INCR=1 ; incrament high byte 
	LB=2 ; increment low byte 
	VSIZE=2
move::
	push a 
	pushw x 
	_vars VSIZE 
	clr (INCR,sp)
	clr (LB,sp)
	pushw y 
	cpw x,(1,sp) ; compare DEST to SRC 
	popw y 
	jreq move_exit ; x==y 
	jrmi move_down
move_up: ; start from top address with incr=-1
	addw x,acc16
	addw y,acc16
	cpl (INCR,sp)
	cpl (LB,sp)   ; increment = -1 
	jra move_loop  
move_down: ; start from bottom address with incr=1 
    decw x 
	decw y
	inc (LB,sp) ; incr=1 
move_loop:	
    _ldaz acc16 
	or a, acc8
	jreq move_exit 
	addw x,(INCR,sp)
	addw y,(INCR,sp) 
	ld a,(y)
	ld (x),a 
	pushw x 
	_ldxz acc16 
	decw x 
	ldw acc16,x 
	popw x 
	jra move_loop
move_exit:
	_drop VSIZE
	popw x 
	pop a 
	ret 	

;-------------------------
;  upper case letter 
; input:
;   A    letter 
; output:
;   A    
;--------------------------
to_upper:
    cp a,#'a 
    jrmi 9$ 
    cp a,#'z+1 
    jrpl 9$ 
    and a,#0xDF 
9$: ret 

;-------------------------------------
; check if A is a letter 
; input:
;   A 			character to test 
; output:
;   C flag      1 true, 0 false 
;-------------------------------------
is_alpha::
	cp a,#'A 
	ccf 
	jrnc 9$ 
	cp a,#'Z+1 
	jrc 9$ 
	cp a,#'a 
	ccf 
	jrnc 9$
	cp a,#'z+1
9$: ret 	

;------------------------------------
; check if character in {'0'..'9'}
; input:
;    A  character to test
; output:
;    Carry  0 not digit | 1 digit
;------------------------------------
is_digit::
	cp a,#'0
	jrc 1$
    cp a,#'9+1
	ccf 
1$:	ccf 
    ret

;------------------------------------
; check if character in {'0'..'9','A'..'F'}
; input:
;    A  character to test
; output:
;    Carry  0 not hex_digit | 1 hex_digit
;------------------------------------
is_hex_digit::
	call is_digit 
	jrc 9$
	cp a,#'A 
	jrc 1$
	cp a,#'G 
	ccf 
1$: ccf 
9$: ret 


;-------------------------------------
; return true if character in  A 
; is letter or digit.
; input:
;   A     ASCII character 
; output:
;   A     no change 
;   Carry    0 false| 1 true 
;--------------------------------------
is_alnum::
	call is_digit
	jrc 1$ 
	call is_alpha
1$:	ret 

