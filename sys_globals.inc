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

;-----------------------------------------
;   system global definitions 
;-----------------------------------------

    STACK_SIZE==256 ; mcu stack size  
    TIB_SIZE==128 ; input buffer size 
    PAD_SIZE==128 ; working buffer 

    INT_SIZE=2 ; int16 size in bytes
    CELL_SIZE=INT_SIZE 

;------------------
; 'bool.flags' bits 
;------------------
F_AUTO=0 ; BASIC automatic line number 
F_RUN=1  ; BASIC program running 
F_IF=2   ; BASIC if statement condition 
F_CR=3   ; BASIC print CR at end of line  
F_UPALPHA=4 ; termios getchar uppercase letter 


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
        clr a  
    .endm ; 6 cy 

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
