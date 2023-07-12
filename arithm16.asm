;;
; Copyright Jacques Deschênes 2019,2020,2021,2022  
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




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Arithmetic operators
;;  16/32 bits integers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;-------------------------------------
	.area DATA
	.org SYS_VARS_ORG+SYS_VARS_SIZE 
;---------------------------------------

acc32: .blkb 1 ; 32 bit accumalator upper-byte 
acc24: .blkb 1 ; 24 bits accumulator upper-byte 
acc16: .blkb 1 ; 16 bits accumulator, acc24 high-byte
acc8:  .blkb 1 ;  8 bits accumulator, acc24 low-byte  
arithm_vars_end:
ARITHM_VARS_SIZE=arithm_vars_end-acc32 

;----------------------------------
	.area CODE
;----------------------------------

;-------------------------------
; acc16 2's complement 
;-------------------------------
neg_acc16:
	cpl acc16 
	cpl acc8 
	_incz acc8
	jrne 1$ 
	_incz acc16 
1$: ret 

;----------------------------------------
;  unsigned multiply uint16*uint8 
;  input:
;     X     uint16 
;     A     uint8
;  output:
;     X     product 
;-----------------------------------------
umul16_8:
	pushw x 
	mul x,a
	pushw x 
	ldw x,(3,SP)
	swapw x 
	mul x,a
	clr a 
	rlwa x ; if a<>0 then overlflow  
	addw x,(1,sp)
	_drop 4 
	ret 

;--------------------------------------
;  multiply 2 uint16_t return uint32_t
;  input:
;     x       uint16_t 
;     y       uint16_t 
;  output:
;     x       product bits 15..0
;     y       product bits 31..16 
;---------------------------------------
		U1=1  ; uint16_t 
		DPROD=U1+INT_SIZE ; uint32_t
		VSIZE=3*INT_SIZE 
umstar:
	_vars VSIZE 
	ldw (U1,sp),x
	clr (DPROD+2,sp)
	clr (DPROD+3,sp) 
; DPROD=u1hi*u2hi
	ld a,yh 
	swapw x 
	mul x,a 
	ldw (DPROD,sp),x
; DPROD+1 +=u1hi*u2lo 
	ld a,(U1,sp)
	ld xl,a 
	ld a,yl 
	mul x,a 
	addw x,(DPROD+1,sp)
	jrnc 1$ 
	inc (DPROD,sp)
1$: ldw (DPROD+1,sp),x 
; DPROD+1 += u1lo*u2hi 
	ld a,(U1+1,sp)
	ld xl,a 
	ld a,yh 
	mul x,a 
	addw x,(DPROD+1,sp)
	jrnc 2$ 
	inc (DPROD,sp)
2$: ldw (DPROD+1,sp),x 
; DPROD+2=u1lo*u2lo 
	ldw x,y  
	ld a,(U1+1,sp)
	mul x,a 
	addw x,(DPROD+2,sp)
	jrnc 3$
	inc (DPROD+1,sp)
	jrne 3$
	inc (DPROD,sp)
3$:
	ldw y,(DPROD,sp)
	_drop VSIZE 
	ret


;-------------------------------------
; multiply 2 integers
; input:
;  	x       n1 
;   y 		n2 
; output:
;	X        product 
;-------------------------------------
	SIGN=1
	VSIZE=1
multiply:
	_vars VSIZE 
	clr (SIGN,sp)
	tnzw x 
	jrpl 1$
	cpl (SIGN,sp)
	negw x 
1$:	
	tnzw y   
	jrpl 2$ 
	cpl (SIGN,sp)
	negw y 
2$:	
	call umstar
	tnzw y 
	jrne 3$
	tnzw x 
	jrpl 4$
3$:
	ld a,#ERR_GT32767
	jp tb_error 
4$:
	ld a,(SIGN,sp)
	jreq 5$
	call dneg 
5$:	
	_drop VSIZE 
	ret


;--------------------------------------
; divide uint32_t/uint16_t
; return:  quotient and remainder 
; quotient expected to be uint16_t 
; input:
;   DBLDIVDND    on stack 
;   X            divisor 
; output:
;   X            quotient 
;   Y            remainder 
;---------------------------------------
	VSIZE=2
	_argofs VSIZE 
	_arg DBLDIVDND 1
	; local variables 
	DIVISOR=1 
udiv32_16:
	_vars VSIZE 
	ldw (DIVISOR,sp),x	; save divisor 
	ldw x,(DBLDIVDND+2,sp)  ; bits 15..0
	ldw y,(DBLDIVDND,sp) ; bits 31..16
	tnzw y
	jrne long_division 
	ldw y,(DIVISOR,sp)
	divw x,y
	_drop VSIZE 
	ret
long_division:
	exgw x,y ; hi in x, lo in y 
	ld a,#17 
1$:
	cpw x,(DIVISOR,sp)
	jrc 2$
	subw x,(DIVISOR,sp)
2$:	ccf 
	rlcw y 
	rlcw x 
	dec a
	jrne 1$
	exgw x,y 
	_drop VSIZE 
	ret

;-----------------------------
; negate double int.
; input:
;   x     bits 15..0
;   y     bits 31..16
; output: 
;   x     bits 15..0
;   y     bits 31..16
;-----------------------------
dneg:
	cplw x 
	cplw y 
	incw x 
	jrne 1$  
	incw y 
1$: ret 


;--------------------------------
; sign extend single to double
; input:
;   x    int16_t
; output:
;   x    int32_t bits 15..0
;   y    int32_t bits 31..16
;--------------------------------
dbl_sign_extend:
	clrw y
	ld a,xh 
	and a,#0x80 
	jreq 1$
	cplw y
1$: ret 	


;----------------------------------
;  euclidian divide dbl/n1 
;  ref: https://en.wikipedia.org/wiki/Euclidean_division
; input:
;    dbl    int32_t on stack 
;    x 		n1   int16_t  divisor  
; output:
;    X      dbl/x  int16_t 
;    Y      remainder int16_t 
;----------------------------------
	VSIZE=8
	_argofs VSIZE 
	_arg DIVDNDHI 1 
	_arg DIVDNDLO 3
	; local variables
	DBLHI=1
	DBLLO=3 
	SREMDR=5 ; sign remainder 
	SQUOT=6 ; sign quotient 
	DIVISR=7 ; divisor 
div32_16:
	_vars VSIZE 
	clr (SREMDR,sp)
	clr (SQUOT,sp)
; copy arguments 
	ldw y,(DIVDNDHI,sp)
	ldw (DBLHI,sp),y
	ldw y,(DIVDNDLO,sp)
	ldw (DBLLO,sp),y 
; check for 0 divisor
.if 0 
	tnzw x 
    jrne 0$
	ld a,#ERR_DIV0 
	jp tb_error
.endif  
; check divisor sign 	
0$:	tnzw x 
	jrpl 1$
	cpl (SQUOT,sp)
	negw x
1$:	ldw (DIVISR,sp),x
; check dividend sign 	 
 	ld a,(DBLHI,sp) 
	and a,#0x80 
	jreq 2$ 
	cpl (SQUOT,sp)
	cpl (SREMDR,sp)
	ldw x,(DBLLO,sp)
	ldw y,(DBLHI,sp)
	call dneg 
	ldw (DBLLO,sp),x 
	ldw (DBLHI,sp),y 
2$:	ldw x,(DIVISR,sp)
	call udiv32_16
	tnzw y 
	jreq 3$ 
; x=quotient 
; y=remainder 
; sign quotient
	tnz (SQUOT,sp)
	jrpl 3$ 
	negw x 
3$: ; sign remainder 
	tnz (SREMDR,sp) 
	jrpl 4$
	negw y 
4$:	
	_drop VSIZE 
	ret 



;----------------------------------
; division x/y 
; input:
;    X       dividend
;    Y       divisor 
; output:
;    X       quotient
;    Y       remainder 
;-----------------------------------
	; local variables 
	DBLHI=1
	DBLLO=3
	DIVISR=5
	VSIZE=6 
divide: 
	_vars VSIZE
	tnzw y 
	jrne 1$
	ld a,#ERR_DIV0 
	jp tb_error
1$: 
	ldw (DIVISR,sp),y
	call dbl_sign_extend
	ldw (DBLLO,sp),x 
	ldw (DBLHI,sp),y 
	ldw x,(DIVISR,sp)
	call div32_16 
	_drop VSIZE 
	ret


;----------------------------------
;  remainder resulting from euclidian 
;  division of x/y 
; input:
;   x   	dividend int16_t 
;   y 		divisor int16_t
; output:
;   X       n1%n2 
;----------------------------------
modulo:
	call divide
	ldw x,y 
	ret 


