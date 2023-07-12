;;
; Copyright Jacques Deschênes 2019,2022  
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;    24 bits arithmetic
;;  arguments are on stack  
;;  format in registers: A:X 
;;      A  bits 23..16 
;;      X  bits 15..0 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SEPARATE=0 

.if SEPARATE 
    .module ARITHM24  
    .include "config.inc"

    .area CODE 
.endif 


	INT_SIZE==3 ; 2's complement 24 bits integers {-8388607...8388607} 
	CELL_SIZE==INT_SIZE 


    ; store int24 from A:AX to stack 
    .macro _i24_store  i 
    ld (i,sp),a 
    ldw (i+1,sp),x 
    .endm 

    ; fetch int24 from stack to A:X 
    .macro _i24_fetch i 
    ld a,(i,sp)
    ldw x,(i+1,sp)
    .endm 

    ; pop int24 from top of stack 
    .macro _i24_pop 
    pop a 
    popw x 
    .endm 

    ; push int24 on stack 
    .macro _i24_push 
    pushw X
    push a 
    .endm 
    

;------------------------------
; cp24  
;  N1-N2 
;  IF N1<N2 THEN 0xFF0000
;  IF N1=N2 THEN 0x000000 
;  IF N1>N2 THEN 0X010000
; input:
;    N1 
;    N2 
; output:
;    A:X  0xFF0000|0|0x010000
;------------------------------
    N1=3 
    N2=N1+INT_SIZE
cp24:
    _i24_fetch N1 
    SUBW X,(N2+1,SP)
    SBC A,(N2,SP)
    jrslt 1$
    jrne 2$
    tnzw x 
    jrne 2$
    clr a 
    jra 9$ 
1$: ; i1 < i2 
    ld a,#0xFF
    jra 9$ 
2$: ; i1 > i2 
    ld a,#1 
9$: clrw x
    ret 

;----------------------------    
; two'2 complement of N 
; input: 
;   N    on stack 
;---------------------------
    N=3 ; argument passed from caller 
neg24: ; (i -- -i )
    _i24_fetch N 
    cpl  a  
    cplw x 
    addw x,#1
    adc a,#0
    _i24_store N 
    ret 

;-------------------------------
; cp24_ax 
; compare acc24 with A:X 
;-------------------------------
cp24_ax:
    push a 
    cpw x,acc16 
    sbc a,acc24
    pop a 
    ret 

;-----------------------------
; negate integer in A:X 
;----------------------------
neg_ax:
    cpl  a  
    cplw x 
    addw x,#1
    adc a,#0
    ret 

;------------------------------------
;  two's complement of acc24 
;-------------------------------------
neg_acc24: ; 
    cpl acc24 
    cpl acc16 
    cpl acc8
    _incz acc8 
    jrne 9$
    _incz acc16 
    jrne 9$
    _incz acc24 
9$: ret 

;--------------------------------------
; unsigned multiply uint24_t by uint8_t
; input:
;	N1	    uint24_t
;   A 	    uint8_t
; output:
;   A:X     product 
;   N1      not changed 
;-------------------------------------
; local variables offset  on sp
	U8   = 1     ; 1 byte 
    PROD = U8+1  ; 3 bytes
    VSIZE=4 ; bytes 
    N1=3+VSIZE ; argument passed from caller 
mulu24_8:
    _vars VSIZE 
    LD (U8,SP),A 
    clr  a
    clrw x 
    _i24_store PROD     
;  multiply bits 7:0 * U8   	
    ld a,(U8,SP)
    ldw x,(N1+1,SP)
    mul x,a 
    ldw (PROD+1,SP),X  
; multiply bits 15:8 * U8     
    ldw x,(N1,SP)
    mul x,a 
    addw x,(PROD,SP)
    ldw (PROD,SP),X  
; multiply bits 23:16 * 8 
    ldw x,(N1-1,SP)
    mul x,a 
    clr a 
    rrwa x 
    add a,(PROD,SP)
    jrnc 8$
    ld a,#ERR_MATH_OVF
    jp tb_error 
8$:   
    ld (PROD,SP),a   
    _i24_fetch PROD 
    _drop VSIZE 
    ret

;-------------------------------
; mul24 
; multiply 24 bits integers 
; if product overflow it 
; generate a fatal error.
; input:
;   N1 (SP+VSIZE+3) 
;   N2 (SP+VSIZE+3+INT_SIZE)
; output:
;   A:X  PRODUCT 
;------------------------------
    N0=1  ; 3 
    PROD=N0+INT_SIZE ; 3   
    PROD_SIGN=PROD+INT_SIZE ; 1 
    VSIZE=7 
    N1=VSIZE+3
    N2=N1+INT_SIZE   
mul24:
    _vars VSIZE
; clear local vars 
    clr (PROD_SIGN,sp)
    clr a 
    clrw x 
    _i24_store PROD 
    _i24_fetch N1 
    tnz a 
    jrpl 0$
    cpl (PROD_SIGN,sp)
    call neg_ax     
    _i24_store N1   
0$: _i24_fetch N2 
    tnz a
    jrpl 2$ 
    cpl (PROD_SIGN,sp) 
    call neg_ax 
    _i24_store N2 
2$: _i24_store N0 
    ld a,(N1+2,sp); least byte     
    jreq 4$
    call mulu24_8
    tnz a 
    jrmi 8$ ; overflow  
    ld (PROD,sp),a
    ldw (PROD+1,sp),x 
4$:
    ld a,(N1+1,sp); middle byte     
    jreq 5$
    call mulu24_8
    tnz a 
    jrne 8$  ; overflow 
    addw x,(PROD,sp)
    jrv 8$ ; overflow
    ldw (PROD,sp),x 
5$:
    ld a,(N1,sp) ; high byte 
    jreq 6$
    call mulu24_8
    rrwa x 
    tnzw x 
    jrne 8$ ; overflow 
    tnz a 
    jrmi 8$ ; overflow 
    add a,(PROD,sp)
    ld (PROD,sp),a 
    jrv 8$ ; overflow 
6$:
    ld a,(PROD,sp)
    ldw x,(PROD+1,sp)
    tnz (PROD_SIGN,sp)
    jreq 9$
    call neg_ax 
9$:
    _drop VSIZE 
    ret 
8$: ; overflow
    ld a,#ERR_MATH_OVF
    jp tb_error 

;-------------------------------------
; divide uint24_t by uint8_t
; input:
;	acc24	dividend
;   A 		divisor
; output:
;   acc24	quotient
;   A		remainder
;------------------------------------- 
; offset  on sp of arguments and locals
	U8   = 1   ; divisor on stack
	VSIZE =1
divu24_8:
	pushw x ; save x
	push a 
	; ld dividend UU:MM bytes in X
	_ldxz acc24
	ld a,(U8,SP) ; divisor
	div x,a ; UU:MM/U8
	push a  ;save remainder
    ldw acc24,x ; quotient 
	pop a
	ld xh,a
	_ldaz acc8
	ld xl,a
	ld a,(U8,sp) ; divisor
	div x,a  ; R:LL/U8
	ld (U8,sp),a ; save remainder
	ld a,xl
	_straz acc8
	pop a
	popw x
	ret



;-------------------------------
; div24 N1/N2  
; divide 24 bits integers
;  input:
;     N1    dividend 
;     N2    divisor 
;  output:
;    A:X   quotient
;    N2    remainder  
;------------------------------
    CNTR=1    ; 1 BYTE
    QSIGN=2   ; 1 BYTE 
    RSIGN=3   ; 1 BYTE 
    YSAVE=4   ; 2 BYTES 
    VSIZE=5   ; 5 BYTES 
    N1=3+VSIZE 
    N2=N1+INT_SIZE
    DIVIDEND=N1
    QUOTIENT=N1  
    DIVISOR=N2  
    REMAINDER=N2 
div24:
    _vars VSIZE 
    clr (RSIGN,sp)
    clr (QSIGN,sp)
    LD A,(N2,SP)
    LDW X,(N2+1,SP) 
    tnz a 
    jrpl 0$ 
    cpl (QSIGN,sp)
    call neg_ax
0$:
    ld  (DIVISOR,sp),a
    ldw (DIVISOR+1,sp),x
    or a,(DIVISOR+1,sp)
    or a,(DIVISOR+2,sp)
    jrne 1$ 
    ld a,#ERR_DIV0 
    jp tb_error 
1$: ; dividend  
    LD A,(N1,SP)
    LDW X,(N1+1,SP)
    tnz a 
    jrpl 2$
    call neg_ax
    cpl (QSIGN,sp)
    cpl (RSIGN,sp)
2$: 
    LD (DIVIDEND,SP),A 
    LD acc24,A 
    LDW (DIVIDEND+1,SP),X 
    LDW acc16,X
    ld a,#24 
    ld (CNTR,sp),a
    ld a,(DIVISOR,sp)
    ldw x,(DIVISOR+1,sp)
; dividend >= divisor ? 
    call cp24_ax ; A:X-acc24 ?
    jrule 22$ 
; quotient=0, remainder=dividend       
    LD A,(DIVIDEND,SP)
    LDW X,(DIVIDEND+1,SP) ; A:X remainder 
    CLR (QUOTIENT,SP)
    CLR (QUOTIENT+1,SP)
    CLR (QUOTIENT+2,SP) ; N2 quotient 
    jra 6$
22$:
; if dividend and divisor fit in 16 bits 
; use faster DIVW instruction 
    TNZ (DIVIDEND,SP)
    JRNE 24$
    TNZ (DIVISOR,SP)
    JREQ udiv16_16
24$:    
    clr a 
    clrw x 
    rcf  
3$: ; shift carry in acc24 bit 0 
    rlc (DIVIDEND+2,SP) 
    rlc (DIVIDEND+1,SP)
    rlc (DIVIDEND,SP) 
    rlcw x  
    rlc a
4$: subw x,(DIVISOR+1,sp) 
    sbc a,(DIVISOR,sp)
    jrnc 5$
; A:X<DIVISOR, restore A:X      
    addw x,(DIVISOR+1,sp)
    adc a,(DIVISOR,sp)
5$: ; shift carry in QUOTIENT 
    ccf
    dec (CNTR,sp)
    jrne 3$ 
; shift quotient last bit     
    rlc (DIVIDEND+2,SP) 
    rlc (DIVIDEND+1,SP)
    rlc (DIVIDEND,SP)  ; quotient > DIVIDEND 
6$: ; A:X is remainder    
    tnz (RSIGN,sp)
    jreq 8$
    call neg_ax
8$: 
    LD (N2,SP),A 
    LDW (N2+1,SP),X ; remainder > N2 
81$:
    LD A,(DIVIDEND,SP)
    LDW X,(DIVIDEND+1,SP)
    tnz (QSIGN,sp)
    jreq 9$
    call neg_ax       
9$: _drop VSIZE 
    ret 

udiv16_16:
    LDW (YSAVE,SP),Y 
    LDW X,(DIVIDEND+1,SP)
    LDW Y,(DIVISOR+1,SP)
    DIVW X,Y ; X=QUOTIENT, Y=REMAINDER  
    CLR A 
    TNZ (QSIGN,SP) 
    JREQ 1$ 
    CPL A 
    CPLW X 
    ADDW X,#1 
    ADC A,#0  
1$: 
    LD (N1,SP),A 
    CLR A 
    TNZ (RSIGN,SP)  
    JREQ 2$ 
    CPL A 
    CPLW Y
    ADDW Y,#1 
    ADC A,#0 
2$:     
    LD (N2,SP),A 
    ldw (N2+1,SP),Y  ; remainder > N2  
    ld a,(N1,SP) ; quotient > A:X 
    ldw y,(YSAVE,SP)
    _drop VSIZE 
    ret 
