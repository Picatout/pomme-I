;;
; Copyright Jacques Deschênes 2023  
; This file is part of pomme-1 
;
;     pomme-1 is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.
;
;     pomme-1 is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.
;
;     You should have received a copy of the GNU General Public License
;     along with pomme-1.  If not, see <http://www.gnu.org/licenses/>.
;;

    .module KERNEL 

;-----------------------
; a little kernel 
; to access TERMIOS 
; functions using 
; STM8 TRAP instruction
;------------------------
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


;---------------------------------------------
;  kernel functions table 
;  functions code is passed in A 
;  parameters are passed in X,Y
;  output returned in A,X,Y,CC  
;
;  code |  function      | input    |  output
;  -----|----------------|----------|---------
;    0  | reset system   | none     | none 
;    1  | ticks          | none     | X=msec ticker 
;    2  | putchar        | X=char   | none 
;    3  | getchar        | none     | A=char
;    4  | querychar      | none     | A=0,-1
;    5  | clr_screen     | none     | none 
;    6  | delback        | none     | none 
;    7  | getline        | xl=buflen | A= line length
;       |                | xh=lnlen  |  
;       |                | y=bufadr | 
;    8  | puts           | X=*str   | none 
;    9  | print_int      | X=int16  | none 
;       |                | A=unsigned| A=string length 
;    10 | set timer      | X=value  | none 
;   11  | check time out | none     | A=0|-1 
;   12  | génère une     | X=msec   | 
;       | tonalité audio | Y=Freq   | none
;   13  | stop tone      |  none    | none
;   14  | get random #   | none     | X = random value 
;   15  | seed prgn      | X=param  | none  
;----------------------------------------------
; syscall codes  
; global constants 
    SYS_RST==0
    SYS_TICKS=1 
    PUTC==2
    GETC==3 
    QCHAR==4
    CLS==5
    DELBK==6
    GETLN==7 
    PRT_STR==8
    PRT_INT==9 
    SET_TIMER==10
    CHK_TIMOUT==11 
    START_TONE==12 
    GET_RND==13
    SEED_PRNG==14 

;;-------------------------------
    .area CODE

;;--------------------------------


;-------------------------
;  software interrupt handler 
;-------------------------
TrapHandler::
    ldw x,(8,sp) ; get trap return address 
    _strxz trap_ret 
    ldw x,#syscall_handler 
    ldw (8,sp),x 
    iret 



    .macro _syscode n, t 
    cp a,#n 
    jrne t   
    .endm 

;---------------------------------
;  must be handled outside 
;  of TrapHandler to enable 
;  interrupts 
;---------------------------------
syscall_handler:      
    _syscode SYS_RST, 0$ 
    _swreset
0$:
    _syscode SYS_TICKS,1$
    _ldxz ticks 
    jp syscall_exit      
1$:
    _syscode PUTC, 2$  
    ld a,xl 
    call uart_putc
    jp syscall_exit 
2$:
    _syscode GETC,3$ 
    call uart_getc 
    jp syscall_exit
3$:
    _syscode QCHAR,4$ 
    call qgetc  
    jra syscall_exit
4$:
    _syscode CLS,5$ 
    call clr_screen
    jra syscall_exit 
5$: 
    _syscode DELBK,6$ 
    call bksp  
    jra syscall_exit 
6$: 
    _syscode GETLN , 7$
    call readln  
    jra syscall_exit 
7$: 
    _syscode PRT_STR , 8$
    call puts 
    jra syscall_exit
8$: 
    _syscode PRT_INT , 9$
    call print_int
    jra syscall_exit      
9$: 
    _syscode SET_TIMER , 10$
    bres sys_flags,#FSYS_TIMER 
    _strxz timer 
    jra syscall_exit 
10$:
    _syscode CHK_TIMOUT, 11$
    clr a 
    btjf sys_flags,#FSYS_TIMER,syscall_exit  
    cpl a 
    jra syscall_exit
11$: 
    _syscode START_TONE , 12$    
    call tone 
    jra syscall_exit 
12$: 
    _syscode GET_RND , 13$
    call prng 
    jra syscall_exit 
13$: 
    _syscode SEED_PRNG , 14$
    call set_seed 
    jra syscall_exit 
14$: 

; bad codes ignored 
syscall_exit:
    jp [trap_ret] 


;------------------------------
; TIMER 4 is used to maintain 
; a milliseconds 'ticks' counter
; and decrement 'timer' varaiable
; and 'tone_ms' variable .
; these 3 variables are unsigned  
; ticks range {0..65535}
; timer range {0..65535}
; tone_ms range {0..65535}
;--------------------------------
Timer4UpdateHandler:
	clr TIM4_SR 
	_incz ticks+1 
	jrne 0$ 
	_incz ticks
0$:
	_ldxz timer
	jreq 1$
	decw x 
	_strxz timer 
	jrne 1$ 
	bset sys_flags,#FSYS_TIMER  
1$:
    _ldxz tone_ms 
    jreq 2$ 
    decw x 
    _strxz tone_ms 
    jrne 2$ 
    bres sys_flags,#FSYS_TONE   
2$: 
	iret 


;-----------------
; 1 Khz beep 
;-----------------
beep_1khz::
	pushw y 
	ldw x,#100
	ldw y,#1000
	call tone
	popw y
	ret 

;---------------------
; input:
;   Y   frequency 
;   x   duration 
;---------------------
	DIVDHI=1   ; dividend 31..16 
	DIVDLO=DIVDHI+INT_SIZE ; dividend 15..0 
	DIVR=DIVDLO+INT_SIZE  ; divisor 
	VSIZE=3*INT_SIZE  
tone:: 
	_vars VSIZE 
	_strxz tone_ms 
	bset sys_flags,#FSYS_TONE    
	ldw (DIVR,sp),y  ; divisor  
	ldw y,#fmstr 
	ldw x,#15625 ; ftimer=fmstr*1e6/64
	call umstar    ; x product 15..0 , y=product 31..16 
	_i16_store DIVDLO  
	ldw (DIVDHI,sp),y 
	_i16_fetch DIVR ; DIVR=freq audio   
	call udiv32_16 
	ld a,xh 
	ld TIM2_ARRH,a 
	ld a,xl 
	ld TIM2_ARRL,a 
; 50% duty cycle 
	srlw x  
	ld a,xh 
	ld TIM2_CCR1H,a 
	ld a,xl
	ld TIM2_CCR1L,a
	bset TIM2_CCER1,#TIM2_CCER1_CC1E
	bset TIM2_CR1,#TIM2_CR1_CEN
	bset TIM2_EGR,#TIM2_EGR_UG 	
0$: ; wait end of tone 
    wfi 
    btjt sys_flags,#FSYS_TONE ,0$    
tone_off: 
	bres TIM2_CCER1,#TIM2_CCER1_CC1E
	bres TIM2_CR1,#TIM2_CR1_CEN 
     _drop VSIZE 
	ret 


;---------------------------------
; Pseudo Random Number Generator 
; XORShift algorithm.
;---------------------------------

;---------------------------------
;  seedx:seedy= x:y ^ seedx:seedy
; output:
;  X:Y   seedx:seedy new value   
;---------------------------------
xor_seed32:
    ld a,xh 
    _xorz seedx 
    _straz seedx
    ld a,xl 
    _xorz seedx+1 
    _straz seedx+1 
    ld a,yh 
    _xorz seedy
    _straz seedy 
    ld a,yl 
    _xorz seedy+1 
    _straz seedy+1 
    _ldxz seedx  
    _ldyz seedy 
    ret 

;-----------------------------------
;   x:y= x:y << a 
;  input:
;    A     shift count 
;    X:Y   uint32 value 
;  output:
;    X:Y   uint32 shifted value   
;-----------------------------------
sll_xy_32: 
    sllw y 
    rlcw x
    dec a 
    jrne sll_xy_32 
    ret 

;-----------------------------------
;   x:y= x:y >> a 
;  input:
;    A     shift count 
;    X:Y   uint32 value 
;  output:
;    X:Y   uint32 shifted value   
;-----------------------------------
srl_xy_32: 
    srlw x 
    rrcw y 
    dec a 
    jrne srl_xy_32 
    ret 

;-------------------------------------
;  PRNG generator proper 
; input:
;   none 
; ouput:
;   X     bits 31...16  PRNG seed  
;  use: 
;   seedx:seedy   system variables   
;--------------------------------------
prng::
	pushw y   
    _ldxz seedx
	_ldyz seedy  
	ld a,#13
    call sll_xy_32 
    call xor_seed32
    ld a,#17 
    call srl_xy_32
    call xor_seed32 
    ld a,#5 
    call sll_xy_32
    call xor_seed32
    popw y 
    ret 


;---------------------------------
; initialize seedx:seedy 
; input:
;    X    0 -> seedx=ticks, seedy=tib[0..1] 
;    X    !0 -> seedx=X, seedy=[0x6000]
;-------------------------------------------
set_seed:
    tnzw x 
    jrne 1$ 
    ldw x,ticks 
    _strxz seedx
    ldw x,tib 
    _strxz seedy  
    ret 
1$: ldw x,ticks 
    _strxz seedx
    ldw x,0x6000
    _strxz seedy  
    ret 

 
     