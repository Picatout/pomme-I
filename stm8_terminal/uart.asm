;
; Copyright Jacques Deschênes 2023 
; This file is part of stm8_terminal 
;
;     stm8_terminal is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.
;
;     stm8_terminal is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.
;
;     You should have received a copy of the GNU General Public License
;     along with stm8_terminal.  If not, see <http://www.gnu.org/licenses/>.
;;



;-------------------------------
	.area CODE 

;--------------------------
; UART receive character
; in a FIFO buffer 
; CTRL+C (ASCII 3)
; cancel program execution
; and fall back to command line
; CTRL+X reboot system 
; CTLR+Z erase EEPROM autorun 
;        information and reboot
;--------------------------
UartRxHandler: ; console receive char 
	btjf UART_SR,#UART_SR_RXNE,5$ 
	ld a,UART_DR 
	cp a,#CAN ; CTRL_X 
	jrne 1$
	_swreset 	
1$:
	push a 
	ld a,#rx1_queue 
	add a,rx1_tail 
	clrw x 
	ld xl,a 
	pop a 
	ld (x),a 
	ld a,rx1_tail 
	inc a 
	and a,#RX_QUEUE_SIZE-1
	ld rx1_tail,a 
5$:	iret 

;---------------------------------------------
; initialize UART, 115200 8N1
; called from cold_start in hardware_init.asm 
; input:
;	none
; output:
;   none
;---------------------------------------------
BAUD_RATE=115200 
	N1=1
	N2=N1+2 
	VSIZE=N2+2
uart_init:
	_vars VSIZE 
; enable UART clock
	bset CLK_PCKENR1,#UART_PCKEN 	
	bres UART,#UART_CR1_PIEN
; baud rate 115200
	mov UART_BRR2,#0xe
	mov UART_BRR1,#0xa 
    clr UART_DR
	mov UART_CR2,#((1<<UART_CR2_TEN)|(1<<UART_CR2_REN)|(1<<UART_CR2_RIEN));
	bset UART_CR2,#UART_CR2_SBK
    btjf UART_SR,#UART_SR_TC,.
    clr rx1_head 
	clr rx1_tail
	bset UART,#UART_CR1_PIEN
	_drop VSIZE 
	ret


;---------------------------------
; uart_putc
; send a character via UART
; input:
;    A  	character to send
;---------------------------------
uart_putc:: 
	btjf UART_SR,#UART_SR_TXE,.
	ld UART_DR,a 
	ret 

;-------------------------
; delete character left 
;-------------------------
uart_delback:
	ld a,#BS 
	call uart_putc  
	ld a,#SPACE 
	call uart_putc 
	ld a,#BS 
	call uart_putc 
	ret 

;------------------------
; clear VT10x terminal 
; screeen 
;------------------------
uart_cls:
	push a 
	ld a,#ESC 
	call uart_putc 
	ld a,#'c 
	call uart_putc 
	pop a 
	ret 

;--------------------
; send blank character 
; to UART 
;---------------------
uart_space:
	ld a,#SPACE 
	call uart_putc 
	ret 

;---------------------------------
; Query for character in rx1_queue
; input:
;   none 
; output:
;   A     0 no charcter available
;   Z     1 no character available
;---------------------------------
qgetc::
uart_qgetc::
	_ldaz rx1_head 
	sub a,rx1_tail 
	ret 

;---------------------------------
; wait character from UART 
; input:
;   none
; output:
;   A 			char  
;--------------------------------	
getc:: ;console input
uart_getc::
	call uart_qgetc
	jreq uart_getc 
	pushw x 
;; rx1_queue must be in page 0 	
	ld a,#rx1_queue
	add a,rx1_head 
	clrw x  
	ld xl,a 
	ld a,(x)
	push a
	_ldaz rx1_head 
	inc a 
	and a,#RX_QUEUE_SIZE-1
	_straz rx1_head 
	pop a  
	popw x
	ret 


;--------------------------
; manange control character 
; before calling uart_putc 
; input:
;    A    character 
;---------------------------
uart_print_char:
	cp a,#BS 
	jrne 1$
	call uart_delback 
	jra 9$ 
1$:
	call uart_putc
9$:
	ret 


;------------------------------
;  send string to uart 
; input:
;    X    *string 
; output:
;    X    *after string 
;------------------------------
uart_puts:
	push a 
1$: ld a,(x)
	jreq 9$ 
	call uart_print_char  
	incw x 
	jra 1$ 
9$: incw x 
	pop a 
	ret 

;-------------------------------
; print integer in hexadicimal
; input:
;    X 
;------------------------------- 
uart_print_hex:
	pushw x 
	push a 
	ld a,xh 
	call uart_print_hex_byte 
	ld a,xl 
	call uart_print_hex_byte 
	ld a,#SPACE 
	call uart_putc 
	pop a 
	popw x 
	ret 

;----------------------
; print hexadecimal byte 
; input:
;    A    byte to print 
;-----------------------
uart_print_hex_byte:
	push a 
	swap a 
	call hex_digit 
	call uart_putc 
	pop a 
	call hex_digit 
	call uart_putc 
	ret 

;---------------------------
; convert to hexadecimal digit 
; input:
;    A    value to convert 
; output:
;    A    hex digit character 
;-----------------------------
hex_digit:
	and a,#15 
	add a,#'0 
	cp a,#'9+1 
	jrmi 9$ 
	add a,#7 
9$: ret 

