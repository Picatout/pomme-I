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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  debug support
;;  set DEBUG=1 in config.inc 
;;  to enable it.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SEPARATE=0 

.if SEPARATE 
    .module DBG_SUPPORT  
    .include "config.inc"

    .area CODE 
.endif 


	.macro _dbg_prt_regs
	.if DEBUG 
		call print_registers    
	.endif 
	.endm 

	.macro _dbg_cmd_itf 
	.if DEBUG 
		call cmd_itf 
	.endif 
	.endm 

	.macro _tp char
	.if DEBUG 
	push a 
	ld a,#char  
	call trace_mark
	pop a 
	trap 
	.endif ; DEBUG 
	.endm 


.if DEBUG 

;--------------------
; print content at address in hex.
; input:
;   X 	address to peek 
; output:
;	none 
;--------------------	
prt_peek::
	pushw x 
	mov base,#16 
	call prt_i16  
	ld a,#': 
	call putc 
	ld a,#SPACE 
	call putc 
	popw x 
	ld a,(x)
	clrw x 
	ld xl,a 
	mov base,#10 
	call prt_i16 
	ret 

;----------------------------------------
;   DEBUG support functions
;----------------------------------------

; turn LED on 
ledon:
    bset LED_PORT+GPIO_ODR,#LED_BIT
    ret 

; turn LED off 
ledoff:
    bres LED_PORT+GPIO_ODR,#LED_BIT 
    ret 

; invert LED status 
ledtoggle:
    ld a,#LED_MASK
    xor a,LED_PORT+GPIO_ODR
    ld LED_PORT+GPIO_ODR,a
    ret 

left_paren:
	ld a,#SPACE 
	call putc
	ld a,#'( 
	call putc 	
	ret 

;------------------------------
; print 8 bit register 
; input:
;   X  point to register name 
;   A  register value to print 
; output:
;   none
;------------------------------- 
prt_reg8:
	push a 
	call puts 
	ld a,(1,sp) 
	clrw x 
	ld xl,a 
	mov base,#16
	call prt_i16  
	call left_paren 
	pop a 
	clrw x 
	ld xl,a 
	mov base,#10
	call prt_i16  
	ld a,#') 
	call putc
	ret

;--------------------------------
; print 16 bits register 
; input:
;   X   point register name 
;   Y   register value to print 
; output:
;  none
;--------------------------------
prt_reg16: 
	pushw y 
	call puts 
	ldw x,(1,sp) 
	mov base,#16
	call prt_i16  
	call left_paren 
	popw x 
	mov base,#10
	call prt_i16  
	ld a,#') 
	call putc
	ret 

;------------------------------------
; print registers contents saved on
; stack by trap interrupt.
; *** called by TrapHandler *** 
;------------------------------------
	R_PC=16     ; 1 word 
	R_EPC=15    ; 1 byte 
	R_Y=13      ; 1 word 
	R_X=11       ; 1 word 
	R_A=10       ; 1 byte 
	R_CC=9      ; 1 byte 
	RET_ADDR=7    ; 2 byte 
	SAV_OUT=5   ; 1 word 
	SAV_ACC16=3 ; 1 word 
	SAV_ACC24=2 ; 1 byte 
	SAV_BASE=1  ; 1 byte  
	VSIZE=6  
print_registers::
	_vars VSIZE 
	_ldaz base 
	ld (SAV_BASE,sp), a 
	_ldaz acc24 
	_ldxz acc16 
	ld (SAV_ACC24,sp),a 
	ldw (SAV_ACC16,sp),x 
	_ldxz out 
	ldw (SAV_OUT,sp),x
	ldw x,#uart_putc
	ldw out,x 
	ldw x,#STATES
	call puts
; print EPC 
	ldw x, #REG_EPC
	call puts 
	ld a,(R_EPC,sp)
	ldw x,(R_PC,sp)
	_straz acc24 
	ldw acc16,x 
	clr a 
	mov base,#16 
	call prt_acc24
	ld a,#'(
	call putc 
	ld a,(R_EPC,sp)
	ldw x,(R_PC,sp)
	_straz acc24 
	ldw acc16,x 
	clr a 
	mov base,#10
	call prt_acc24 
	ld a,#') 
	call putc 	
; print x
	ldw x,#REG_X
	ldw y,(R_X,sp)
	call prt_reg16  
; print Y 
	ldw x,#REG_Y
	ldw y, (R_Y,sp)
	call prt_reg16  
; print A 
	ldw x,#REG_A
	ld a, (R_A,sp) 
	call prt_reg8 
; print CC 
	ldw x,#REG_CC
	ld a, (R_CC,sp)
	call prt_reg8  
; print SP 
	ldw x,#REG_SP
	ldw y,sp 
	addw y,#(VSIZE+11)
	pushw y 
	call prt_reg16  
; print return address 
	ldw x,#RET_ADR 
	popw y 
	ldw y,(y)
	call prt_reg16 
	ld a,#CR 
	call putc
	ldw x,(SAV_OUT,sp)
	ldw out,x 
	ld a,(SAV_ACC24,sp)
	ldw x,(SAV_ACC16,sp)
	_straz acc24 
	ldw acc16,x 
	ld a, (SAV_BASE,sp)
	_straz base   	
	_drop VSIZE
	ret

STATES:  .asciz "\nRegisters state at break point.\n--------------------------\n"
REG_EPC: .asciz "EPC:"
REG_Y:   .asciz "\nY:" 
REG_X:   .asciz "\nX:"
REG_A:   .asciz "\nA:" 
REG_CC:  .asciz "\nCC:"
REG_SP:  .asciz "\nSP:"
RET_ADR: .asciz "\nReturn address: "

;----------------------
; input:
;	Y    *input buffer 
; output:
;   acc24  integer 
;----------------------
parse_addr:
	ld a,#SPACE 
	call skip  	 
	addw y,in.w 
	ldw x,#pad+110 
	call strcpy
	ldw x,#pad+110 
	call atoi24 	
	ret 


read_cmd: 
	push #0 
	ldw y,#tib 
	bres UART1_CR2,#UART_CR2_RIEN 
1$:	btjf UART1_SR,#UART_SR_RXNE,1$  
	ld a,UART1_DR 
	cp a,#CR 
	jreq 9$
	cp a,#BS 
	jrne 2$
	tnz (1,sp)
	jreq 1$ 
	decw y 
	dec (1,sp)
	call bksp 
	jra 1$ 
2$: ld (y),a
	incw y 
	inc (1,sp)
	call putc 
	jra 1$ 
9$: clr (y)
	pop a 
	_clrz in.w 
	_clrz in
	bset UART1_CR2,#UART_CR2_RIEN  
	ret 

;----------------------------
; command interface
; only 3 commands:
;  'q' to resume application
;  'p [addr]' to print memory values 
;  's addr' to print string 
;----------------------------
;local variable
	PSIZE=10
	SAV_INW=8 
	SAV_FPTR=5
	SAV_COUNT=4
	SAV_ACC24=1
	SAV_ACC16=2
	VSIZE=11
cmd_itf:
	_vars VSIZE
	_ldaz count 
	ld (SAV_COUNT,sp),a 
	_ldaz acc24 
	_ldxz acc16 
	ld (SAV_ACC24,sp),a 
	ldw (SAV_ACC16,sp),x 
	_ldaz farptr 
	_ldxz ptr16
	ld (SAV_FPTR,sp),a 
	ldw (SAV_FPTR+1,sp),x
	_ldxz in.w 
	ldw (SAV_INW,sp),x 
	_clrz farptr 
	_clrz farptr+1 
	_clrz farptr+2  
repl:
	ld a,#CR 
	call putc 
	ld a,#'? 
	call putc
	call read_cmd 
	ldw y,#tib  
	ld a,(y)
	jreq repl  
	_incz in 
	call to_upper 
	cp a,#'Q 
	jrne test_p
repl_exit:
; restore original context 
	ld a,(SAV_ACC24,sp)
	ldw x,(SAV_ACC16,sp)
	_straz acc24 
	ldw acc16,x
	ld a,(SAV_COUNT,sp)
	_straz count 
	ld a,(SAV_FPTR,sp)
	ldw x,(SAV_FPTR+1,sp)
	_straz farptr 
	ldw ptr16,x 
	ldw x,(SAV_INW,sp)
	ldw in.w,x 
	_drop VSIZE
	ret  
invalid:
	ldw x,#invalid_cmd 
	call puts 
	jra repl 
test_p:	
    cp a,#'P 
	jreq mem_peek
    cp a,#'S 
	jrne invalid 
print_string:
	call parse_addr 	
	_ldxz acc16
	call puts
	jp repl 	
mem_peek:
	mov base,#16
	call parse_addr 
	_ldaz acc24 
	or a,acc16 
	or a,acc8 
	jrne 1$ 
	jra peek_byte  
1$:	_ldxz acc24 
	ldw farptr,x 
	_ldaz acc8 
	_straz farptr+2 
peek_byte:
	call print_farptr 
	ld a,#8 
	ld (PSIZE,sp),a 
	clrw x 
1$:	call fetchc  
	pushw x 
	_straz acc8 
	clrw x 
	ldw acc24,x 
	ld a,#16+128
	call prt_acc24
	popw x 
	dec (PSIZE,sp)
	jrne 1$ 
	ld a,#8 
	add a,farptr+2 
	_straz farptr+2
	clr a 
	adc a,farptr+1 
	_straz farptr+1 
	clr a 
	adc a,farptr 
	_straz farptr 
	jp repl  

invalid_cmd: .asciz "not a command\n" 

;----------------------------
; display farptr address
;----------------------------
print_farptr:
	_ldaz farptr+2 
	_straz acc8 
	_ldxz farptr 
	ldw acc24,x 
	clrw x 
	ld a,#16 
	call prt_acc24
	ld a,#SPACE 
	call putc 
	call putc 
	ret

;------------------------------------
; get byte at address farptr[X]
; input:
;	 farptr   address to peek
;    X		  farptr index 	
; output:
;	 A 		  byte from memory  
;    x		  incremented by 1
;------------------------------------
fetchc: ; @C
	ldf a,([farptr],x)
	incw x
	ret


;----------------------
; called by show_row 
; print character 
; corresponding to hex 
; in row
; characters stored in pad 
; input:
;    A count  
;------------------------
print_chars:
	push a 
	ldw x,#pad 
1$:	ld a,(x)
	cp a,#SPACE 
	jrult 2$
	cp a,#127 
	jruge 2$ 
	jra 3$ 
2$: ld a,#'_ 
3$:	
	call putc 
	incw x 
	dec (1,sp)
	jrne 1$
	pop a 
	ret 


;---------------------
; display n bytes row 
; from memory.
; input:
;   A        bytes to print 
;	farptr   address 
; output:
;   farptr  address after last shown  
;---------------------
	CNT=1
	CNTDWN=2 
	BYTE=3
	VSIZE=3 
show_row:
	tnz a 
	jrne 1$
	ret 
1$:	
	_vars VSIZE 
	ld (CNT,sp),a 
	ld (CNTDWN,sp),a 
	_ldaz farptr 
	_ldxz ptr16 
	_straz acc24 
	ldw acc16,x 
	call itoa 
	ld a,#7 
	call right_align
	call puts 
	ld a,#9 
	call putc 
row_loop:
	ldf a,[farptr]
	ld (BYTE,sp),a
	ld a,(CNT,sp)
	sub a,(CNTDWN,sp)
	clrw x 
	ld xl,a 
	addw x,#pad 
	ld a,(BYTE,sp)
	ld (x),a 
	_clrz acc24 
	_clrz acc16 
	_straz acc8 
	call itoa 
	ld a,#4
	call right_align 
	call puts 
	ldw x,#1 	
	call incr_farptr
	dec (CNTDWN,sp)
	jrne row_loop
	ld a,#SPACE 
	call putc
	ld a,(CNT,sp) 
	call print_chars 
	ld a,#CR 
	call putc 
	_drop VSIZE   
	ret 

;--------------------------
; print memory content 
; in hexadecimal format
;  input:
;    farptr  start address 
;    X       count bytes to print 
;--------------------------
	BCNT=1
	BASE=3
	VSIZE=3   
hex_dump:
	push a 
	_vars VSIZE
	_ldaz base
	ld (BASE,sp),a 
	mov base,#16
	ld a,#CR 
	call putc 
1$: ldw (BCNT,sp),x
	ld a,#16
	cpw x,#16
	jrpl 2$
	ld a,xl
2$: 	
	call show_row 
	ldw x,(BCNT,sp) 
	subw x,#16 
	cpw x,#1
	jrpl 1$
	ld a,(BASE,sp)
	_straz base
	_drop VSIZE
	pop a 
	ret 

dump_prog:
	pushw y 
	_ldaz acc24 
	_ldxz acc16 
	push a 
	pushw x 
	_clrz farptr 
	_ldxz txtend 
	ldw y,txtbgn
	ldw ptr16,y 
	subw x,ptr16 
	call hex_dump
	popw x 
	pop a 
	_straz acc24 
	ldw acc16,x 
	popw y 
	ret 


trace_mark:
	pushw x
	push a 
	ldw x,#trace_point
	call puts 
	pop a 
	call putc
	ld a,#CR 
	call putc 
	popw x 
	ret 

trace_point: .asciz "TP: "

.endif ; DEBUG 

