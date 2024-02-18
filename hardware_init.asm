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
file_header: .blkb FILE_HEADER_SIZE 
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
	int NonHandledInterrupt ;int18 UART1 RX full 
	int NonHandledInterrupt ; int19 i2c
	int NonHandledInterrupt ;int20 UART3 TX completed
	int UartRxHandler 		;int21 UART3 RX full
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

;----------------------------
; if fmstr>16Mhz 
; program 1 wait state in OPT7 
;----------------------------
wait_state:
	ld a,#FMSTR 
	cp a,#16 
	jrule no_ws 
set_ws:	; for fmstr>16Mhz 1 wait required 
	tnz FLASH_WS ; OPT7  
	jrne opt_done ; already set  
	ld a,#1 
	jra prog_opt7 	
no_ws: ; fmstr<=16Mhz no wait required 
	tnz FLASH_WS 
	jreq opt_done ; already cleared 
	clr a 
prog_opt7:
	call unlock_eeprom 
	ld FLASH_WS,a 
	cpl a 
	ld FLASH_WS+1,a 
	btjf FLASH_IAPSR,#FLASH_IAPSR_EOP,.
	btjf FLASH_IAPSR,#FLASH_IAPSR_HVOFF,.
	_swreset 
opt_done:
	ret  


unlock_eeprom:
	btjt FLASH_IAPSR,#FLASH_IAPSR_DUL,9$
	mov FLASH_CR2,#0 
	mov FLASH_NCR2,#0xFF 
	mov FLASH_DUKR,#FLASH_DUKR_KEY1
    mov FLASH_DUKR,#FLASH_DUKR_KEY2
	btjf FLASH_IAPSR,#FLASH_IAPSR_DUL,.
9$:	
    bset FLASH_CR2,#FLASH_CR2_OPT
    bres FLASH_NCR2,#FLASH_CR2_OPT 
	ret

;--------------------
; if OPT7 cleared 
; Set OPT7
; and reset MCU  
;--------------------
prog_wait_state:
	mov FLASH_CR2,#0 
	mov FLASH_NCR2,#0xFF 
	mov FLASH_DUKR,#FLASH_DUKR_KEY1
    mov FLASH_DUKR,#FLASH_DUKR_KEY2
	btjf FLASH_IAPSR,#FLASH_IAPSR_DUL,.
	ld a,#1
	ld FLASH_WS,a
	ld a,#0x7E  
	ld NFLASH_WS,a  
	btjf FLASH_IAPSR,#FLASH_IAPSR_EOP,.
	_swreset 

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
	ld a,xh ; clock source CLK_SWR_HSI||CLK_SWR_HSE 
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
	ld a,fmstr  ; Mhz 
; fmstr X = a*250 
; A=2 ; 2^2=4 	
	ldw x,#250
	mul x,a
	ld a,#2  
; divide x/2 until <256
; inc a for each division 
0$:	 
	inc a 
	srlw x 
	cpw x,#256 
	jrpl 0$  
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
	call wait_state
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
; disable schmitt triggers on Arduino CN4 analog inputs
	mov ADC_TDRL,0x3f
; select internal clock no divisor: 16 Mhz 	
	ld a,#FMSTR ; oscillateur frequency in Mhz 
	ldw x,#CLK_SRC<<8   ; CLK_SWR_HSI || CLK_SWR_HSE  
    call clock_init
; UART at 115200 BAUD
; used for user interface 
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
	call clr_screen
	ldw x,#pomme_1 
	ldw y,#p1Copyright
	push #P1_REV 
	push #P1_MINOR 
	push #P1_MAJOR 
	call app_info
	_drop 3 
	call show_cpu_frequency
	jp WOZMON

pomme_1: .asciz "pomme I "
p1Copyright: .asciz "Copyright Jacques Deschenes, (c) 2023,24\n"

show_cpu_frequency:
	ldw x,#cpu_freq
	call puts 
	ld a,#FMSTR 
	call prt_i8 
	ld a,#BS  
	call uart_putc
	ldw x,#scale_factor 
	call puts   
	ret 
cpu_freq: .asciz "Fcpu= " 
scale_factor: .asciz "Mhz\n" 


