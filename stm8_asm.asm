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

;------------------------------
; variables used by assembler 
;------------------------------
TOKEN= dasm_flags+1 ; *token  
TOK_LEN=TOKEN+2 ; lenght of token 

;--------------------------------
;  simple embeded assembler 
;  for STM8 core
;  tokens separated by SPACE and ,  
;--------------------------------
    ASM_ADR=1
    TOK_ADR=ASM_ADR+2 
    TOK_LEN=TOK_ADR+2
    TOK_LINK=TOK_LEN+1
    VSIZE=TOK_LINK+2 
stm8asm:
    _vars VSIZE 
1$:
    clr a 
    call readln 
    call mnemonic
    tnz a    
    jreq 1$ 
    call search_mnemonic  
    tnz a 
    jreq 8$ 
    call (y) ; coder function  
8$: ; not a valid token 
    ldw x,#BAD_TOKEN
    call puts 
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
    _strxz TOKEN 
    ret 

skip_space:
    ld a,#SPACE 
    jra skip 

;------------------------------
; scan up to this character 
; input:
;    A   character 
;    X   text buffer 
; output:
;    A   count 
;    X   *first token char  
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
    _straz TOK_LEN 
    popw x 
    ret 

;----------------------------
; extract mnemonic 
; input:
;     X   *input_line  
; output:
;     A    token length 
;     X    *token
;----------------------------
mnemonic:
    call skip_space 
    call scan
    ret 

;------------------------
; search mnemonic in 
; scanning mnemo_index 
; array and comparing string 
; input:
;    A    token length 
;    X    *token 
; output:
;    
;-----------------------------
PTOK=1
PIDX=PTOK+2
CNTR=PIDX+1
TLEN=CNTR+1
VSIZE=TLEN 
search_mnemonic:
    _vars VSIZE 
    ldw (PTOK,SP),x 
    ld (TLEN,SP),A
    ld a,#1
    ld (CNTR,SP),a  
    ldw x,#mnemo_index+2
    ldw (PIDX,SP),X 
1$: ld a,(TLEN,SP)
    ldw x,(PTOK,SP)
    ldw y,(PIDX,sp)
    ldw y,(y)
    jreq 7$
    call cstrcp 
    jreq 8$
    inc (CNTR,sp)
    ldw x,(PIDX,SP)
    addw x,#2 
    ldw (PIDX,sp),x
    jra 1$ 
7$: clr a 
    jra 9$     
8$: ; found 
    ld a,(CNTR,SP)
9$:
    _drop VSIZE 
    ret 

syn_error: .asciz " syntax error\n"
syntax_error:
    ldw x,#syn_error 
    call puts 
    ldw x,#RAM_SIZE-1 
    ldw sp,x 
    jp GETLINE 
    

;-----------------------
; next token must be a 
; followed by ',' 
;-----------------------
expect_A:
    call skip_space  
    _strxz TOKEN 
    ld a,(X)
    and a,#0xDF 
    cp a,#'A 
    jreq 9$
    jra syntax_error 
9$: incw x 
    _strxz TOKEN 
    ret 
;-----------------------
; next token must be 
; ',' 
;------------------------
expect_comma:
    call skip_space
    ld a,(x)
    cp a,#', 
    jrne syntax_error 
    incw x 
    _strxz TOKEN 
    ret 

;---------------------
; skip over last token 
; output:
;    X   *tib[n]
;----------------------
skip_over:
    _ldxz TOKEN 
    push TOK_LEN 
    push #0 
    addw x,(1,sp)
    _strxz TOKEN 
    _clrz TOK_LEN 
    _drop 2 
    ret 

;---------------------
; parse hexadecimal 
; number 
; output:
;    X    value 
;---------------------
HDIGIT=1
VSIZE=2 
parse_number:
    _vars VSIZE 
    call skip_space 
    ld a,(x)
    cp a,#'$ 
    jrne syntax_error 
    incw x 
    clrw y     
1$: ld a,(X)
    cp a,#'a 
    jrmi 2$ 
    cp a,#'z+1 
    jrpl 2$
    and a,#0XDF 
2$:
    cp a,#'A 
    jrmi 3$ 
    sub a,#7 
3$:
    cp a,#'0 
    jrmi 9$ 
    sub a,#'0 
    cp a,#16 
    jrpl 9$ 
    sllw y 
    sllw y 
    sllw y 
    sllw y 
    push a 
    push #0 
    addw y,(1,sp)

9$: _strxz TOKEN 
    ldw x,y 
    _drop VSIZE 
    ret 


;---------------------
; code arithmetic 
; and logic operation 
; on A 
; OP  A,....
;---------------------
IDX_OP=1 ; operation index 
PRE=IDX_OP+1 ; precode
CODE=PRE+1 ; machine code 
ADR=CODE+1 ; address 
VSIZE=ADR+1  
alu8_func:
    _vars VSIZE 
    ld (IDX_OP,SP),a  
    clr (PRE,sp)
    call skip_over ; last token 
    call expect_A 
    call expect_comma 
    call skip_space
    ld a,(x)
    incw x 
    _strxz TOKEN 
    cp a,#'# ; immediate 
    jreq 2$ 
    cp a,#'$  ; direct 
    jreq 4$ 
    cp a,#'(  ; indexed 
    jreq 6$ 
    cp a,#'[  ; pointer 
    jreq 8$
2$: immediate value     
    call parse_number 

    _drop VSIZE 
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
;  coder functions 
;  table 
;----------------------------
coder_funcs:
    .word 0 ; 
    .word alu8_func ; ADC  
    .word alu8_func ; ADD  
    .word alu16_func ; ADDW 
    .word alu8_func ; AND  
    .word bccm_func ; BCCM  
    .word alu8_func ; BCP   
    .word bit_func ; BCPL   
    .word break_func ; BREAK  
    .word bit_func ; BRES  
    .word bit_func ; BSET  
    .word bit_func ; BTJF 
    .word bit_func ; BTJT  
    .word call_func ; CALL  
    .word callf_func ; CALLF  
    .word callr_func ; CALLR 
    .word flags_func ; CCF 
    .word al8am_func ; CLR 
    .word clrw_func ; CLRW 
    .word al8am_func ; CP 
    .word alu16_func ; CPW 
    .word alu8_func ; CPL 
    .word alu16_func ; CPLW  
    .word al8am_func ; DEC  
    .word alu16_func ; DECW  
    .word div_func ; DIV  
    .word divw_func ; DIVW  
    .word reg8_func ; EXG  
    .word reg16_func ; EXGW 
    .word halt_func ; HALT 
    .word al8am_func ; INC 
    .word alu16_func ; INCW 
    .word int_func ; INT  
    .word iret_func ; IRET  
    .word jp_func ; JP  
    .word jpf_func ; JPF  
    .word jr_func ; JRA  
    .word jr_func ; JRC 
    .word jr_func ; JREQ 
    .word jr_func ; JRF  
    .word jr_func ; JRH  
    .word jr_func ; JRIH  
    .word jr_func ; JRIL  
    .word jr_func ; JRM  
    .word jr_func ; JRMI  
    .word jr_func ; JRNC  
    .word jr_func ; JRNE  
    .word jr_func ; JRNH  
    .word jr_func ; JRNM  
    .word jr_func ; JRNV  
    .word jr_func ; JRPL  
    .word jr_func ; JRSGE  
    .word jr_func ; JRSGT  
    .word jr_func ; JRSLE  
    .word jr_func ; JRSLT  
    .word jr_func ; JRT  
    .word jr_func ; JRUGE  
    .word jr_func ; JRUGT  
    .word jr_func ; JRULE  
    .word jr_func ; JRULT  
    .word jr_func ; JRV  
    .word ld_func ; LD  
    .word ldf_func ; LDF  
    .word ldw_func ; LDW  
    .word mov_func ; MOV  
    .word mul_func ; MUL  
    .word al8am_func ; NEG  
    .word alu16_func ; NEGW
    .word nop_func ; NOP  
    .word alu8_func ; OR  
    .word stack_func ; POP
    .word stack_func ; POPW
    .word stack_func ; PUSH
    .word stack_func ; PUSHW
    .word flags_func ; RCF  
    .word ret_func ; RET  
    .word retf_func ; RETF 
    .word flags_func ; RIM 
    .word al8am_func ; RLC  
    .word alu16_func ; RLCW
    .word alu16_func ; RLWA
    .word al8am_func ; RRC  
    .word alu16_func ; RRCW 
    .word alu16_func ; RRWA
    .word flags_func ; RVF 
    .word alu8_func ; SBC  
    .word flags_func ; SCF 
    .word flags_func ; SIM 
    .word al8am_func ; SLA  
    .word al8am_func ; SLL  
    .word alu16_func ; SLAW
    .word alu16_func ; SLLW
    .word al8am_func ; SRA  
    .word alu16_func ; SRAW
    .word al8am_func ; SRL  
    .word alu16_func ; SRLW
    .word alu8_func ; SUB  
    .word alu16_func ; SUBW
    .word al8am_func ; SWAP 
    .word alu16_func ; SWAPW
    .word al8am_func ; TNZ  
    .word alu16_func ; TNZW
    .word trap_func ; TRAP 
    .word wfe_func ; WFE  
    .word wfi_func ; WFI  
    .word alu8_func ; XOR 
    .word 0 

