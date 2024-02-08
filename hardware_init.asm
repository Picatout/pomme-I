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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; hardware initialisation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

;------------------------
; if unified compilation 
; must be first in list 
;-----------------------

    .module HW_INIT 

    .include "config.inc"

SYS_VARS_ORG=4 

;;-----------------------------------
    .area SSEG (ABS)
;; working buffers and stack at end of RAM. 	
;;-----------------------------------
    .org RAM_SIZE-STACK_SIZE-TIB_SIZE-PAD_SIZE 
tib:: .ds TIB_SIZE             ; terminal input buffer
block_buffer::                 ; use to write FLASH block (alias for pad )
pad:: .ds PAD_SIZE             ; working buffer
stack_full:: .ds STACK_SIZE   ; control stack 
stack_unf:: ; stack underflow ; control_stack underflow 


;--------------------------------
	.area DATA (REL,CON) 
;	.org SYS_VARS_ORG  
;---------------------------------

; kernel variables 
ticks:: .blkw 1 ; millisecond system ticks 
timer:: .blkw 1 ; msec count down timer 
tone_ms:: .blkw 1 ; tone duration msec 
sys_flags:: .blkb 1; system boolean flags 
seedx:: .blkw 1  ; bits 31...15 used by 'prng' function
seedy:: .blkw 1  ; bits 15...0 used by 'prng' function 
base:: .blkb 1 ;  numeric base used by 'print_int' 
fmstr:: .blkb 1 ; Fmaster frequency in Mhz
farptr:: .blkb 1 ; 24 bits pointer used by file system, upper-byte
ptr16::  .blkb 1 ; 16 bits pointer , farptr high-byte 
ptr8::   .blkb 1 ; 8 bits pointer, farptr low-byte  
trap_ret:: .blkw 1 ; trap return address 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; keep these 2 variables in this order 
; file_header share first 3 fields of fcb
; see inc/files.inc 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
file_header::   
file_sign:: .blkw 1 ; file signature 
fcb:: .blkb FCB_SIZE  ; file control block structure 
kvars_end:: 
SYS_VARS_SIZE==kvars_end-ticks   

; system boolean flags 
FSYS_TIMER==0 
FSYS_TONE==1 
FSYS_UPPER==2 ; getc uppercase all letters 
  
;;--------------------------------------
    .area HOME
;; interrupt vector table at 0x8000
;;--------------------------------------

    int cold_start			; RESET vector 
	int TrapHandler         ; trap instruction 
	int NonHandledInterrupt ;int0 TLI   external top level interrupt
	int NonHandledInterrupt ;int1 AWU   auto wake up from halt
	int NonHandledInterrupt ;int2 CLK   clock controller
	int NonHandledInterrupt ;int3 EXTI0 gpio A external interrupts
	int NonHandledInterrupt ;int4 EXTI1 gpio B external interrupts
	int NonHandledInterrupt ;int5 EXTI2 gpio C external interrupts
	int NonHandledInterrupt ;int6 EXTI3 gpio D external interrupts
	int NonHandledInterrupt ;int7 EXTI4 gpio E external interrupt 
	int NonHandledInterrupt ;int8 beCAN RX interrupt
	int NonHandledInterrupt ;int9 beCAN TX/ER/SC interrupt
	int NonHandledInterrupt ;int10 SPI End of transfer
	int NonHandledInterrupt ;int11 TIM1 update/overflow/underflow/trigger/break
	int NonHandledInterrupt ;int12 TIM1 ; TIM1 capture/compare
	int NonHandledInterrupt ;int13 TIM2 update /overflow
	int NonHandledInterrupt ;int14 TIM2 capture/compare
	int NonHandledInterrupt ;int15 TIM3 Update/overflow
	int NonHandledInterrupt ;int16 TIM3 Capture/compare
	int NonHandledInterrupt ;int17 UART1 TX completed
.if NUCLEO_8S208RB  
	int UartRxHandler		;int18 UART1 RX full 
.else 
	int NonHandledInterrupt ;int18 UART1 RX full 
.endif 
	int NonHandledInterrupt ; int19 i2c
	int NonHandledInterrupt ;int20 UART3 TX completed
.if NUCLEO_8S207K8  
	int UartRxHandler 		;int21 UART3 RX full
.else 
	int NonHandledInterrupt ;int21 UART3 RX full
.endif 
	int NonHandledInterrupt ;int22 ADC2 end of conversion
	int Timer4UpdateHandler	;int23 TIM4 update/overflow ; used as msec ticks counter
	int NonHandledInterrupt ;int24 flash writing EOP/WR_PG_DIS
	int NonHandledInterrupt ;int25  not used
	int NonHandledInterrupt ;int26  not used
	int NonHandledInterrupt ;int27  not used
	int NonHandledInterrupt ;int28  not used
	int NonHandledInterrupt ;int29  not used


	.area CODE 
;	.org 0x8080 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; non handled interrupt 
;;;;;;;;;;;;;;;;;;;;;;;;;;;
NonHandledInterrupt::
	iret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    peripherals initialization
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;----------------------------------------
; inialize MCU clock 
; input:
;   A       fmstr Mhz 
;   XL      CLK_CKDIVR , clock divisor
;   XH     HSI|HSE   
; output:
;   none 
;----------------------------------------
clock_init:	
	_straz fmstr
	ld a,xh ; clock source HSI|HSE 
	bres CLK_SWCR,#CLK_SWCR_SWIF 
	cp a,CLK_CMSR 
	jreq 2$ ; no switching required 
; select clock source 
	ld CLK_SWR,a
	btjf CLK_SWCR,#CLK_SWCR_SWIF,. 
	bset CLK_SWCR,#CLK_SWCR_SWEN
2$: 	
; cpu clock divisor 
	ld a,xl 
	ld CLK_CKDIVR,a  
	clr CLK_CKDIVR 
	ret

;----------------------------------
; TIMER2 used as audio tone output 
; on port D:5. CN9-6
; channel 1 configured as PWM mode 1 
;-----------------------------------  
timer2_init:
	bset CLK_PCKENR1,#CLK_PCKENR1_TIM2 ; enable TIMER2 clock 
 	mov TIM2_CCMR1,#(6<<TIM2_CCMR_OCM) ; PWM mode 1 
	mov TIM2_PSCR,#6 ; fmstr/64
	ret 

;---------------------------------
; TIM4 is configured to generate an 
; interrupt every millisecond 
;----------------------------------
timer4_init:
	bset CLK_PCKENR1,#CLK_PCKENR1_TIM4
	bres TIM4_CR1,#TIM4_CR1_CEN 
	ld a,fmstr 
	ldw x,#0xe8 
	mul x,a
	pushw x 
	ldw x,#3 
	mul x,a 
	swapw x 
	addw x,(1,sp) 
	_drop 2  
	clr a 
0$:	 
	cpw x,#256 
	jrmi 1$ 
	inc a 
	srlw x 
	jra 0$ 
1$:
	ld TIM4_PSCR,a 
	ld a,xl 
	ld TIM4_ARR,a
	mov TIM4_CR1,#((1<<TIM4_CR1_CEN)|(1<<TIM4_CR1_URS))
	bset TIM4_IER,#TIM4_IER_UIE
; set int level to 1 
	ld a,#ITC_SPR_LEVEL1 
	ldw x,#INT_TIM4_OVF 
	call set_int_priority
	ret


;--------------------------
; set software interrupt 
; priority 
; input:
;   A    priority 1,2,3 
;   X    vector 
;---------------------------
	SPR_ADDR=1 
	PRIORITY=3
	SLOT=4
	MASKED=5  
	VSIZE=5
set_int_priority::
	_vars VSIZE
	and a,#3  
	ld (PRIORITY,sp),a 
	ld a,#4 
	div x,a 
	sll a  ; slot*2 
	ld (SLOT,sp),a
	addw x,#ITC_SPR1 
	ldw (SPR_ADDR,sp),x 
; build mask
	ldw x,#0xfffc 	
	ld a,(SLOT,sp)
	jreq 2$ 
	scf 
1$:	rlcw x 
	dec a 
	jrne 1$
2$:	ld a,xl 
; apply mask to slot 
	ldw x,(SPR_ADDR,sp)
	and a,(x)
	ld (MASKED,sp),a 
; shift priority to slot 
	ld a,(PRIORITY,sp)
	ld xl,a 
	ld a,(SLOT,sp)
	jreq 4$
3$:	sllw x 
	dec a 
	jrne 3$
4$:	ld a,xl 
	or a,(MASKED,sp)
	ldw x,(SPR_ADDR,sp)
	ld (x),a 
	_drop VSIZE 
	ret 

;-------------------------------------
;  initialization entry point 
;-------------------------------------
cold_start:
;empty stack
	ldw x,#RAM_SIZE-1 
	ldw sp,x 
	ld a,RST_SR 
	and a,#(1<<RST_SR_ILLOPF)|(1<<RST_SR_WWDGF)
	jrne 1$
0$: ; clear all ram
	clr (x)
	decw x 
	jrne 0$
1$: 
	clr RST_SR 
; activate pull up on all inputs 
	ld a,#255 
	ld PA_CR1,a 
	ld PB_CR1,a 
	ld PC_CR1,a 
	ld PD_CR1,a 
	ld PE_CR1,a 
	ld PF_CR1,a 
	ld PG_CR1,a 
	ld PI_CR1,a
; set user LED pin as output 
    bset LED_PORT+GPIO_CR1,#LED_BIT
    bset LED_PORT+GPIO_CR2,#LED_BIT
    bset LED_PORT+ GPIO_DDR,#LED_BIT
	bres LED_PORT+GPIO_ODR,#LED_BIT ; turn on user LED  
; disable schmitt triggers on Arduino CN4 analog inputs
	mov ADC_TDRL,0x3f
; select internal clock no divisor: 16 Mhz 	
	ld a,#16 ; Mhz 
	ldw x,#CLK_SWR_HSI<<8   ; high speed internal oscillator 
    call clock_init 
; UART at 115200 BAUD
; used for user interface 
	ldw x,#uart_putc 
	ldw out,x 
	call uart_init
	call timer4_init ; msec ticks timer 
	call timer2_init ; tone generator 	
	call spi_enable  ; enable spi for external RAM and EEPROM  
	rim ; enable interrupts 
	mov base,#10
	_clrz sys_flags 
	call beep_1khz  ;
	ldw x,#-1
	call set_seed 

;jp spi_ram_test 
;jp eeprom_test 

    call kernel_show_version  	
	jp WOZMON

.if 0
	bset sys_flags,#FSYS_UPPER 
call new_line 	
test: ; test compiler 
	ld a,#'> 
	call putc 
	call readln 
	call compile 
	call dump_code 
	jra test 

dump_code: 
	ldw y,#pad 
	push #16  
	ld a,(2,y)
	push a
	ld a,yh 
	call print_hex 
	ld a,yl  
	call print_hex
	ldw x,#2 
	call spaces 
1$: 
	ld a,(y)
	call print_hex 
	call space 
	incw y
	dec (2,sp)
	jrne 2$ 
	call new_line 
	ld a,yh 
	call print_hex 
	ld a,yl  
	call print_hex
	ldw x,#2 
	call spaces 
	ld a,#16
	ld (2,sp),a 
2$:
	dec (1,sp) 
	jrne 1$ 
9$: _drop 2 
	call new_line 
	ldw x,#pad   
	ld a,(2,x)
	call prt_basic_line 
	ret 	
.endif 
