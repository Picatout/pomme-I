;;
; Copyright Jacques Deschênes 2023,24  
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

;--------------------------------
;  simple embeded assembler 
;  for STM8 core
;  tokens separated by SPACE  
;--------------------------------
    ASM_ADR=1
    TOK_ADR=ASM_ADR+2 
    TOK_LEN=TOK_ADR+2
    TOK_LINK=TOK_LEN+1
    VSIZE=TOK_LINK+2 
stm8asm:
    _vars VSIZE 
    clr a 
    call readln 
    ld a,#SPACE 
    call next_token  
    call search_token 
    jrne 8$ 
    call (y) ; address of token executable 
8$: ; not a valid token 
    ldw x,#BAD_TOKEN
    call uart_puts 
9$:    
    _drop VSIZE 
    ret 
BAD_TOKEN: .asciz "Unkown token, exiting\n"

;----------------------------------
; skip character 
; input:
;    A character to skip 
;    X  text buffer 
; output:
;    X    update after last char 
;--------------------------------
skip:
    cp a,(x)
    jrne 9$
    incw x 
    jra skip 
9$:
    ret 

;------------------------------
; scan up to this character 
; input:
;    A   character 
;    X   text buffer 
; output:
;    A   count 
;    X   not moved 
;-------------------------------
scan:
    pushw x 
    push #0 
1$:
    cp a,(x)
    jreq 9$ 
    incw x 
    inc (1,sp)
    jra 1$
9$: pop a 
    popw x 
    ret 

;----------------------------
; extract next token 
; input:
;     X   *text line 
; output:
;     A    token length 
;     X    *token
;----------------------------
next_token:
    ld a,#SPACE 
    call skip 
    call scan 
    ret 

;--------------------------
; compare counted strings 
; input:
;    A   length 
;    X   str1 
;    Y   str2 
; output:
;    Z    1 == | 0 !=
;    A    not changed 
;    X    not changed 
;    Y    not changed 
;--------------------------
cstrcp: 
    pushw y 
    pushw x 
    push a 
    push a 
1$: ld a,(x)
    cp a,(y)
    jrne 9$ 
    dec (1,sp)
    jrne 1$ 
9$: _drop 1 
    pop a 
    popw x 
    popw y 
    ret 

;----------------------------
;  token dictionary 
;  same structure as p1Forth
;----------------------------
    



;TOK_LAST=LINK 