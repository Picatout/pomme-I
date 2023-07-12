;;
; Copyright Jacques Deschênes 2019 
; This file is part of STM8_NUCLEO 
;
;     STM8_NUCLEO is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.
;
;     STM8_NUCLEO is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.
;
;     You should have received a copy of the GNU General Public License
;     along with STM8_NUCLEO.  If not, see <http://www.gnu.org/licenses/>.
;;
;--------------------------------------
        TAB_WIDTH=4 ; default tabulation width 
        EOF=0xff ; end of file marker 
        NLEN_MASK=0xf  ; mask to extract name len 


	STACK_EMPTY=RAM_SIZE-1  


    ; boolean bit in 'flags' variable 
    FRUN=0 ; program running 
	FOPT=1 ; run time optimization flag  
	FSLEEP=3 ; halt resulting from  SLEEP 
	FSTOP=4 ; STOP command flag 
	FCOMP=5  ; compiling flags 
    FAUTO=6 ; auto line numbering . 
    FTRACE=7 ; trace flag 

    LINE_HEADER_SIZE=3 ; line number 2 bytes and line length 1 byte 
    FIRST_DATA_ITEM=LINE_HEADER_SIZE+1 ; skip over DATA_IDX token.

	MAX_LINENO=0x7fff; BASIC maximum line number 

	RX_QUEUE_SIZE=8 

    TIM2_CLK_FREQ=62500

    ADR_SIZE=2  ; bytes 
    NAME_SIZE=2 ; bytes 
    

    STDOUT=1 ; output to uart
    BUFOUT=3 ; buffered output  

    TOS=1 ; offset of top of stack parameter on stack 

    TYPE_MASK=0xf0 ; mask to extract data type, i.e. DIM variable symbol  or CONST symbol 
    TYPE_DVAR=(1<<4); DIM variable type 
    TYPE_CONST=(2<<4); CONST data 
    NLEN_MASK=0xf  ; mask to extract name len 
    NONE_IDX = 255 ; not a token 

    
;--------------------------------------
;   assembler flags 
;-------------------------------------
;    MATH_OVF=0 ; if 1 the stop on math overflow 

    ; assume 16 Mhz Fcpu 
     .macro _usec_dly n 
    ldw x,#(16*n-2)/4 ; 2 cy 
    decw x  ; 1 cy 
    nop     ; 1 cy 
    jrne .-2 ; 2 cy 
    .endm 
    
    ; load X register with 
    ; entry point of dictionary
    ; before calling 'search_dict'
    .macro _ldx_dict dict_name
        ldw x,#dict_name+2
    .endm 

    ; reset BASIC pointer
    ; to beginning of last token
    ; extracted except if it was end of line 
    .macro _unget_token
        decw y
    .endm

    ; extract 16 bits address from BASIC code  
    .macro _get_addr
        ldw x,y     ; 1 cy 
        ldw x,(x)   ; 2 cy 
        addw y,#2   ; 2 cy 
    .endm           ; 5 cy 

    ; alias for _get_addr 
    .macro _get_word 
        _get_addr
    .endm ; 5 cy 

    ; extract character from BASIC code 
    .macro _get_char 
        ld a,(y)    ; 1 cy 
        incw y      ; 1 cy 
    .endm           ; 2 cy 
    
    ; extract next token 
    .macro _next_token 
        _get_char 
    .endm  ; 2 cy 

    ; extract next command token id 
    .macro _next_cmd     
        _get_char       ; 2 cy 
    .endm               ; 2 cy 

    ; get code address in x
    .macro _code_addr 
        clrw x   ; 1 cy 
        ld xl,a  ; 1 cy 
        sllw x   ; 2 cy 
        ldw x,(code_addr,x) ; 2 cy 
    .endm        ; 6 cy 

    ; call subroutine from index in a 
    .macro _call_code
        _code_addr  ; 6 cy  
        call (x)    ; 4 cy 
    .endm  ; 10 cy 

    ; jump to bytecode routine 
    ; routine must jump back to 
    ; interp_loop 
    .macro _jp_code 
        _code_addr 
        jp (x)
    .endm  ; 8 cycles 

    ; jump back to interp_loop 
    .macro _next 
        jp interp_loop 
    .endm ; 2 cycles 
    
;------------------------------------
;  board user LED control macros 
;------------------------------------

    .macro _led_on 
        bset LED_PORT,#LED_BIT 
    .endm 

    .macro _led_off 
        bres LED_PORT,#LED_BIT 
    .endm 

    .macro _led_toggle 
        bcpl LED_PORT,#LED_BIT 
    .endm 


;------------------------------------
;   BASIC pending_stack macros 
;-------------------------------------
    ; reset pending stack 
    .macro _rst_pending 
    ldw x,#pending_stack+PENDING_STACK_SIZE
    _strxz psp 
    .endm 

    ; fetch TOS 
    .macro _last_pending 
    ld a,[psp]
    .endm 

    ; push operation token
    ; input:
    ;    A   token  
    .macro _push_op  
    _decz psp+1
    ld [psp],a 
    .endm 

    ; pop pending operation
    ; output:
    ;    A   token  
    .macro _pop_op 
    ld a,[psp]
    _incz psp+1 
    .endm 

    ; check for stack full 
    ; output:
    ;   A    ==0 -> stack full 
    .macro _pending_full 
    ld a,#pending_stack 
    sub a,psp+1 
    .endm 

    ; check for stack_empty
    ; output:
    ;   A   == 0 -> stack empty     
    .macro _pending_empty 
    _ldaz psp+1 
    sub a,#pending_stack+PENDING_STACK_SIZE
    .endm 

