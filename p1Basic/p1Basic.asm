;;
; Copyright Jacques Deschênes 2019,2022,2023  
; This file is part of p1Basic 
;
;     p1Basic is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.
;
;     p1Basic is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.
;
;     You should have received a copy of the GNU General Public License
;     along with p1Basic.  If not, see <http://www.gnu.org/licenses/>.
;;

;--------------------------------------
;   Implementation of Tiny BASIC
;   REF: https://en.wikipedia.org/wiki/Li-Chen_Wang#Palo_Alto_Tiny_BASIC
;   Palo Alto BASIC is 4th version of TinyBasic
;   DATE: 2019-12-17
;
;--------------------------------------------------
;     implementation information
;
; *  integer are 16 bits two's complement  
;
; *  register Y is used as basicptr    
; 
;    IMPORTANT: when a routine use Y it must preserve 
;               its content and restore it at exit.
;               This hold only when BASIC is running  
;               
; *  BASIC function return their value registers 
;    A character 
;	 X integer || address 
; 
;  * variables return their value in X 
;
;--------------------------------------------------- 


    .module P1_BASIC 

	.area CODE 



;---------------------------------------
;   BASIC configuration parameters
;---------------------------------------
MAX_CODE_SIZE=5376 ; 42*BLOCK_SIZE multiple of BLOCK_SIZE=128 bytes  
MIN_VAR_SIZE=BLOCK_SIZE ; FREE_RAM-MAX_CODE_SIZE 128 bytes 
PENDING_STACK_SIZE= 16 ; pending operation stack 

;--------------------------------------
    .area APP_DATA (ABS)
	.org APP_DATA_ORG 
;--------------------------------------	

; keep the following 3 variables in this order 
in.w::  .blkb 1 ; used by compiler 
in::    .blkb 1 ; low byte of in.w 
count:: .blkb 1 ; current BASIC line length and tib text length  
line.addr:: .blkw 1 ; BASIC line start at this address. 
basicptr::  .blkw 1  ; BASIC interperter program pointer.
;data_line:: .blkw 1  ; data line address 
;data_ptr:  .blkw 1  ; point to DATA in line 
lomem:: .blkw 1 ; tokenized BASIC area beginning address 
himem:: .blkw 1 ; tokenized BASIC area end before this address 
progend:: .blkw 1 ; address end of BASIC program 
dvar_bgn:: .blkw 1 ; DIM variables start address 
dvar_end:: .blkw 1 ; DIM variables end address 
heap_free:: .blkw 1 ; free RAM growing down from tib 
flags:: .blkb 1 ; various boolean flags
auto_line: .blkw 1 ; automatic line number  
auto_step: .blkw 1 ; automatic lein number increment 
; chain_level: .blkb 1 ; increment for each CHAIN command 
for_nest: .blkb 1 ; nesting level of FOR...NEXT , maximum 8 
gosub_nest: .blkb 1 ; nesting level of GOSUB, maximum 8 
; pending stack is used by compiler to check syntax, like matching pair 
psp: .blkw 1 ; pending_stack pointer 
pending_stack: .blkb PENDING_STACK_SIZE ; pending operations stack 
file_header: .blkb FILE_HEADER_SIZE ; buffer to hold file header structure 

;------------------------------
	.area APP_DATA
	.org 0x100 
;-------------------------------
; BASIC programs compiled here
free_ram: 


	.area CODE 

;-----------------------
;  display POMME BASIC  
;  information 
;-----------------------
	PB_MAJOR=1
	PB_MINOR=0
	PB_REV=15
		
app_name: .asciz "pomme BASIC "
pb_copyright: .asciz " Jacques Deschenes (c)2023,24\n"

print_app_info:
	push base 
	mov base, #10 
; push app_info()
; parameters on stack 
	push #PB_REV 
	push #PB_MINOR 
	push #PB_MAJOR  
	ldw x,#app_name  
	ldw y,#pb_copyright 
	call app_info
	_drop 3
	pop base 
	ret

;------------------------------
;  les variables ne sont pas 
;  réinitialisées.
;-----------------------------
warm_init:
	ldw x,#uart_putc 
	ldw out,x ; standard output   
	_clrz flags 
	mov base,#10 
	_rst_pending 
	ret 

;---------------------------
; reset BASIC system variables 
; and clear BASIC program 
; variables  
;---------------------------
reset_basic:
	pushw x 
	ldw x,#free_ram 
	_strxz lomem
	_strxz progend  
	_strxz dvar_bgn 
	_strxz dvar_end
	ldw x,#tib 
	_strxz himem 
	_strxz heap_free 
	_clrz flags
	clrw x 
	_strxz for_nest 
	_strxz psp 
	ld a,#10 
	_straz auto_line 
	_straz auto_step  
	popw x
	ret 

P1BASIC:: 
; reset hardware stack 
    ldw x,#STACK_EMPTY 
    ldw sp,x 
	call reset_basic
; initialize operation pending stack 	
	_rst_pending 
	call print_app_info ; display BASIC information
	call free 
; set ctrl_c_vector
	ldw x,#ctrl_c_stop 
	_strxz ctrl_c_vector 
; RND function seed 
; must be initialized 
; to value other than 0.
; take values from ROM space 
	ldw x,0x6000
	ldw x,(x)
	ldw seedy,x  
	ldw x,0x6006 
	ldw x,(x)
	ldw seedx,x  
	jra warm_start 

ctrl_c_msg: .asciz "\nSTOPPED AT " 	
;-------------------------------
; while a program is running 
; CTRL+C end program
;--------------------------- 
ctrl_c_stop: 
	ldw x,#ctrl_c_msg 
	call puts 
	ldw x,line.addr 
	ldw x,(x)
	call print_int
	call new_line 
	ldw x,#STACK_EMPTY 
	ldw sp,x
	bres flags,#FRUN
	jra cmd_line 
warm_start:
	call warm_init
;----------------------------
;   BASIC interpreter
;----------------------------
cmd_line: ; user interface 
	ld a,#CR 
	call putc 
	ld a,#'> 
	call putc
	push #0 
	btjf flags,#FAUTO,1$ 
	_ldxz auto_line 
	call itoa
	ld (1,sp),a  
	ldw y,x 
	ldw x,#tib 
	call strcpy 
	_ldxz auto_line 
	addw x,auto_step 
	_strxz auto_line
1$: pop a 
	call readln
	tnz a 
	jreq cmd_line
	call compile
	tnz a 
	jreq cmd_line ; not direct command

;; direct command 
;; interpret 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This is the interpreter loop
;; for each BASIC code line.
;; 10 cycles  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
do_nothing: 
interp_loop:   
    _next_cmd ; command bytecode, 2 cy  
	_jp_code ; 8 cy + 2 cy for jump back to interp_loop  

;---------------------
; BASIC: REM | ' 
; skip comment to end of line 
;---------------------- 
kword_remark::
	ldw y,line.addr 
	ld a,(2,y) ; line length 
	_straz in  
	addw y,in.w   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; move basicptr to first token 
; of next line 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
next_line:
	btjf flags,#FRUN,cmd_line
	cpw y,progend
	jrmi 1$
0$:
	ld a,#ERR_END 
	jp tb_error 
;	jp kword_end 
1$:	
	_stryz line.addr 
	addw y,#LINE_HEADER_SIZE
	btjf flags,#FTRACE,2$
	call prt_line_no 
2$:	
  _next 



;------------------------
; when TRACE is active 
; print line number to 
; be executed by VM
;------------------------
prt_line_no:
	ldw x,[line.addr] 
	call print_int 
	ld a,#CR 
	call putc 
	ret 


;-------------------------
;  skip .asciz in BASIC line 
;  name 
;  input:
;     x		* string 
;  output:
;     none 
;-------------------------
skip_string:
	ld a,(y)
	jreq 8$
1$:	incw y
	ld a,(y)
	jrne 1$  
8$: incw y
	ret 

;-------------------------------
; called when an intger token 
; is expected. can be LIT_IDX 
; or LITW_IDX 
; program fail if not integer 
;------------------------------
expect_integer:
	_next_token 
	cp a,#LITW_IDX 
	jreq 0$
	jp syntax_error
0$:	_get_word 
	ret 


;--------------------------
; input:
;   A      character 
; output:
;   A      digit 
;   Cflag   1 ok, 0 failed 
; use:
;   base
;------------------------------   
char_to_digit:
	sub a,#'0
	jrmi 9$ 
	cp a,#10
	jrmi 5$
	cp a,#17 
	jrmi 9$   
	sub a,#7 
	cp a,base 
	jrpl 9$	 
5$: scf ; ok 
	ret 
9$: rcf ; failed 
	ret 

;------------------------------------
; convert pad content in integer
; input:
;    Y		* .asciz to convert
; output:
;    X        int16_t
;    Y        * .asciz after integer  
;    acc16    int16_t 
; use:
;   base 
;------------------------------------
	; local variables
	N=1 ; INT_SIZE  
	DIGIT=N+INT_SIZE 
	SIGN=DIGIT+INT_SIZE ; 1 byte, 
	VSIZE=SIGN   
atoi16::
	_vars VSIZE
; conversion made on stack 
	mov base, #10 ; defaul conversion base 
	clr (DIGIT,sp)
	clrw x 
	_i16_store N   
	clr (SIGN,sp)
	ld a,(y)
	jreq 9$  ; completed if 0
	cp a,#'-
	jrne 1$ 
	cpl (SIGN,sp)
	jra 2$
1$:  
	cp a,#'$ 
	jrne 3$ 
	mov base,#16 ; hexadecimal base 
2$:	incw y
	ld a,(y)
	jreq 9$ 
3$:	; char to digit 
	call char_to_digit
	jrnc 9$
	ld (DIGIT+1,sp),a 
	_i16_fetch N  ; X=N 
	_ldaz base   
	call umul16_8      
	addw x,(DIGIT,sp)
	_i16_store N  
	jra 2$
9$:	_i16_fetch N
	tnz (SIGN,sp)
    jreq 10$
    negw x
10$:
	_strxz acc16  
	_drop VSIZE
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   pomme BASIC  operators,
;;   commands and functions 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;---------------------------------
; dictionary search 
; input:
;	X 		dictionary entry point, name field  
;   y		.asciz name to search 
; output:
;  A		TOKEN_IDX  
;---------------------------------
	NLEN=1 ; cmd length 
	XSAVE=NLEN+2
	YSAVE=XSAVE+2
	VSIZE=YSAVE+1
search_dict::
	_vars VSIZE 
	clr (NLEN,sp)
	ldw (YSAVE,sp),y 
search_next:
	ldw (XSAVE,sp),x 
; get name length in dictionary	
	ld a,(x)
	ld (NLEN+1,sp),a  
	ldw y,(YSAVE,sp) ; name pointer 
	incw x 
	call strcmp 
	jreq str_match 
no_match:
	ldw x,(XSAVE,sp) 
	subw x,#2 ; move X to link field
	ld a,#NONE_IDX   
	ldw x,(x) ; next word link 
	jreq search_exit  ; not found  
;try next 
	jra search_next
str_match:
	ldw x,(XSAVE,sp)
	addw x,(NLEN,sp)
; move x to token field 	
	addw x,#2 ; to skip length byte and 0 at end  
	ld a,(x) ; token index
search_exit: 
	_drop VSIZE 
	ret 


;---------------------
; check if next token
;  is of expected type 
; input:
;   A 		 expected token attribute
;  ouput:
;   none     if fail call syntax_error 
;--------------------
expect:
	push a 
	_next_token 
	cp a,(1,sp)
	jreq 1$
	jp syntax_error
1$: pop a 
	ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;
; parse arguments list 
; between ()
;;;;;;;;;;;;;;;;;;;;;;;;;;
func_args:
	_next_token 
	cp a,#LPAREN_IDX 
	jreq arg_list 
	jp syntax_error 

; expected to continue in arg_list 
; caller must check for RPAREN_IDX 

;-------------------------------
; parse embedded BASIC routines 
; arguments list.
; arg_list::=  expr[','expr]*
; all arguments are of int24_t type
; and pushed on stack 
; input:
;   none
; output:
;   stack{n}   arguments pushed on stack
;   A  	number of arguments pushed on stack  
;--------------------------------
	ARGN=4 
	ARG_SIZE=INT_SIZE 
arg_list:
	push #0 ; arguments counter
	tnz (y)
	jreq 7$ 
1$:	 
	pop a 
	popw x 
	sub sp, #ARG_SIZE
	pushw x 
	inc a 
	push a
	call expression 
	_i16_store ARGN   
	_next_token 
	cp a,#COMMA_IDX 
	jreq 1$ 
	cp a,#RPAREN_IDX 
	jreq 7$ 
	_unget_token 
7$:	
	pop a
	ret  

;--------------------------------
;   BASIC commnands 
;--------------------------------

;----------------------------------
; BASIC: MULDIV(expr1,expr2,expr3)
; return expr1*expr2/expr3 
; product result is int32_t and 
; divisiont is int32_t/int16_t
;----------------------------------
	ARG3=1
	ARG2=ARG3+2
	ARG1=ARG2+2
	YSAVE=ARG1+2
	VSIZE=YSAVE+1  
func_muldiv:
	pushw y 
	call func_args 
	ldw (YSAVE,sp),y 
	cp a,#3 
	jreq 1$
	jp syntax_error
1$: 
	ldw x,(ARG1,sp) ; expr1
	ldw y,(ARG2,sp) ; expr2
	call multiply 
	ldw (ARG2,sp),x  ;int32_t 15..0
	ldw x,(ARG3,sp)  ; divisor 
	ldw (ARG3,sp),y  ;int32_t 31..16
	call div32_16 ; int32_t/expr3 
	ldw y,(YSAVE,sp)
	_drop VSIZE
	ret 

;--------------------------------
;  arithmetic and relational 
;  routines
;  operators precedence
;  highest to lowest
;  operators on same row have 
;  same precedence and are executed
;  from left to right.
;	'*','/','%'
;   '-','+'
;   '=','>','<','>=','<=','<>','><'
;   '<>' and '><' are equivalent for not equal.
;--------------------------------



;***********************************
;   expression parse,execute 
;***********************************

;-----------------------------------
; factor ::= ['+'|'-'|e]  var | @ |
;			 integer | function |
;			 '('expression')' 
; output:
;     X     factor value 
; ---------------------------------
	NEG=1
	VSIZE=1
factor:
	_vars VSIZE 
	clr (NEG,sp)
	_next_token
	cp a,#CMD_END
	jrugt 1$ 
	jp syntax_error
1$:
	cp a,#ADD_IDX 
	jreq 2$
	cp a,#SUB_IDX 
	jrne 4$ 
	cpl (NEG,sp)
2$:	
	_next_token
4$:
	cp a,#LITW_IDX 
	jrne 5$
	_get_word 
	jra 18$
5$: 
	cp a,#LITC_IDX 
	jrne 6$
	_get_char 
	clrw x 
	ld xl,a
	jra 18$  	
6$:
	cp a,#VAR_IDX 
	jrne 8$
	call get_var_adr 
	call get_array_adr 
	ldw x,(x)
	jra 18$ 	
8$:
	cp a,#LPAREN_IDX
	jrne 10$
	call expression
	_i16_push
	ld a,#RPAREN_IDX 
	call expect
	_i16_pop 
	jra 18$ 
10$: ; must be a function 
	_call_code
18$: 
	tnz (NEG,sp)
	jreq 20$
	negw x   
20$:
	_drop VSIZE
	ret


;-----------------------------------
; term ::= factor ['*'|'/'|'%' factor]* 
; output:
;   X    	term  value 
;-----------------------------------
	N1=1 ; left operand   
	YSAVE=N1+INT_SIZE   
	MULOP=YSAVE+ADR_SIZE
	VSIZE=INT_SIZE+ADR_SIZE+1    
term:
	_vars VSIZE
; first factor 	
	call factor
	_i16_store N1 ; left operand 
term01:	 ; check for  operator '*'|'/'|'%' 
	_next_token
	ld (MULOP,sp),a
	cp a,#DIV_IDX 
	jrmi 0$ 
	cp a,#MULT_IDX
	jrule 1$ 
0$:	_unget_token
	jra term_exit 
1$:	; got *|/|%
;second factor
	call factor
	ldw (YSAVE,sp),y ; save y 
	ldw y,(N1,sp)
; select operation 	
	ld a,(MULOP,sp) 
	cp a,#MULT_IDX 
	jrne 3$
; '*' operator
	call multiply
	tnz a  
	jreq 5$
	jp tb_error 
3$: cp a,#DIV_IDX 
	jrne 4$ 
; '/' operator	
	exgw x,y 
	call divide 
	jra 5$ 
4$: ; '%' operator
	exgw x,y 
	call divide  
	exgw x,y 
5$: 
	_i16_store N1
	ldw y,(YSAVE,sp) 
	jra term01 
term_exit:
	_i16_fetch N1
	_drop VSIZE 
	ret 

;-------------------------------
;  expr ::= term [['+'|'-'] term]*
;  result range {-16777215..16777215}
;  output:
;     X   expression value     
;-------------------------------
	N1=1 ;left operand 
	YSAVE=N1+INT_SIZE ;   
	OP=YSAVE+ADR_SIZE ; 1
	VSIZE=INT_SIZE+ADR_SIZE+1
expression:
	_vars VSIZE 
; first term 	
	call term
	_i16_store N1 
1$:	; operator '+'|'-'
	_next_token
	ld (OP,sp),a 
	cp a,#ADD_IDX 
	jreq 2$
	cp a,#SUB_IDX 
	jreq 2$ 
	_unget_token 
	jra 9$ 
2$: ; second term 
	call term
	ldw (YSAVE,sp),y 
	exgw x,y 
	_i16_fetch N1
	ldw (N1,sp),y ; right operand   
	ld a,(OP,sp)
	cp a,#ADD_IDX 
	jrne 4$
; '+' operator
	ADDW X,(N1,SP)
	jra 5$ 
4$:	; '-' operator 
	SUBW X,(N1,SP)
5$:
	_i16_store N1
	ldw y,(YSAVE,sp)
	jra 1$
9$:
	_i16_fetch N1 
	_drop VSIZE 
	ret 

;---------------------------------------------
; rel ::= expr [rel_op expr]
; rel_op ::=  '=','<','>','>=','<=','<>','><'
;  relation return  integer , zero is false 
;  output:
;	 X		relation result   
;---------------------------------------------
  ; local variables
	N1=1 ; left expression 
	YSAVE=N1+INT_SIZE   
	REL_OP=YSAVE+ADR_SIZE  ;  
	VSIZE=INT_SIZE+ADR_SIZE+1 ; bytes  
relation: 
	_vars VSIZE
	call expression
	_i16_store N1 
; expect rel_op or leave 
	_next_token 
	ld (REL_OP,sp),a 
	cp a,#REL_LE_IDX
	jrmi 1$
	cp a,#OP_REL_LAST 
	jrule 2$ 
1$:	_unget_token 
	jra 9$ 
2$:	; expect another expression
	call expression
	ldw (YSAVE,sp),y 
	exgw x,y 
	_i16_fetch N1
	ldw (N1,sp),y ; right expression  
	cpw x,(N1,sp)
	jrslt 4$
	jrne 5$
; i1==i2 
	ld a,(REL_OP,sp)
	cp a,#REL_LT_IDX 
	jrpl 7$ ; relation false 
	jra 6$  ; relation true 
4$: ; i1<i2
	ld a,(REL_OP,sp)
	cp a,#REL_LT_IDX 
	jreq 6$ ; relation true 
	cp a,#REL_LE_IDX 
	jreq 6$  ; relation true
	jra 54$
5$: ; i1>i2
	ld a,(REL_OP,sp)
	cp a,#REL_GT_IDX 
	jreq 6$ ; relation true 
	cp a,#REL_GE_IDX 
	jreq 6$ ; relation true 
54$:
	cp a,#REL_NE_IDX 
	jrne 7$ ; relation false 
6$: ; TRUE  ; relation true 
	LDW X,#-1
	jra 8$ 
7$:	; FALSE 
	clrw x
8$: 
	ldw y,(YSAVE,sp) 
	jra 10$ 
9$:	
	_i16_fetch N1
10$:
	_drop VSIZE
	ret 


;-------------------------------------------
;  AND factor:  [NOT] relation 
;  output:
;     X      boolean value 
;-------------------------------------------
	NOT_OP=1
and_factor:
	push #0 
0$:	_next_token  
	cp a,#CMD_END 
	jrugt 1$
	jp syntax_error
1$:	cp a,#NOT_IDX  
	jrne 2$ 
	cpl (NOT_OP,sp)
	jra 4$
2$:
	_unget_token 
4$:
	call relation
5$:	
	tnz (NOT_OP,sp)
	jreq 8$
	cplw x  
8$:
	_drop 1  
    ret 


;--------------------------------------------
;  AND operator as priority over OR||XOR 
;  format: and_factor [AND and_factor]*
;          
;  output:
;    X      boolean value  
;--------------------------------------------
	B1=1 
	VSIZE=INT_SIZE 
and_cond:
	_vars VSIZE 
	call and_factor
	_i16_store B1 
1$: _next_token 
	cp a,#AND_IDX  
	jreq 3$  
	_unget_token 
	jra 9$ 
3$:	call and_factor  
	rlwa x 
	and a,(B1,sp)
	rlwa x 
	and a, (B1+1,sp)
	rlwa x 
	_i16_store B1 
	jra 1$  
9$:	
	_i16_fetch B1 
	_drop VSIZE 
	ret 	 

;--------------------------------------------
; condition for IF and UNTIL 
; operators: OR
; format:  and_cond [ OP and_cond ]* 
; output:
;    stack   value 
;--------------------------------------------
	B1=1 ; left bool 
	OP=B1+INT_SIZE ; 1 bytes 
	VSIZE=INT_SIZE+1
condition:
	_vars VSIZE 
	call and_cond
	_i16_store B1
1$:	_next_token 
	cp a,#OR_IDX  
	jreq 2$
	_unget_token 
	jra 9$ 
2$:	ld (OP,sp),a ; boolean operator  
	call and_cond
	ld a,(OP,sp)
4$: ; B1 = B1 OR X   
	rlwa x 
	or a,(B1,SP)
	rlwa x 
	or a,(B1+1,SP) 
	rlwa x 
	jra 6$  
5$: ; B1 = B1 XOR X 
	RLWA X 
	XOR A,(B1,SP)
	RLWA X 
	XOR A,(B1+1,SP)
	RLWA X 
6$: 
	_i16_store B1 
	jra 1$ 
9$:	 
	_i16_fetch B1 ; result in X 
	_drop VSIZE
	ret 

;-----------------------------
; BASIC: LET var=expr 
; variable assignement 
; output:
;-----------------------------
	VAR_ADR=1  ; 2 bytes 
	VALUE=VAR_ADR+2 ;INT_SIZE 
	VSIZE=2*INT_SIZE 
kword_let::
	_vars VSIZE 
	_next_token ; VAR_IDX || STR_VAR_IDX 
	cp a,#VAR_IDX
	jreq let_int_var
	cp a,#STR_VAR_IDX 
	jreq let_string
	jp syntax_error
kword_let2: 	
	_vars VSIZE 
let_int_var:
	call get_var_adr  
	call get_array_adr
	ldw (VAR_ADR,sp),x 
	ld a,#REL_EQU_IDX 
	call expect 
; var assignment 
	call condition
	_i16_store VALUE
	ldw x,(VAR_ADR,sp) 
	ld a,(VALUE,sp)
	ld (x),a 
	ld a,(VALUE+1,sp)
	ld (1,x),a 
9$: _drop VSIZE 	
	_next  


;-----------------------
; BASIC: LET l$="string" 
;        ||  l$="string"
;------------------------
	TEMP=1 ; temporary storage 
	DEST_SIZE=TEMP+2 
	DEST_ADR=DEST_SIZE+2  
	DEST_LEN=DEST_ADR+2 
	SRC_ADR=DEST_LEN+2 
	SIZE=SRC_ADR+2 
	VSIZE2=SIZE+1
let_string:
	_drop VSIZE
let_string2:	 
	_vars VSIZE2 
	clr (SIZE,sp)
	clr (DEST_SIZE,sp)
	clr (DEST_LEN,sp)
	call get_var_adr 
	ldw (TEMP,sp),x 
	ldw x,(2,x)
	ld a,(x) ; DIM size 
	incw x 
	ldw (DEST_ADR,sp),x 
	ld (DEST_SIZE+1,sp),a 
	call strlen
	inc a  
	ld (DEST_LEN+1,sp),a 
	ld a,(y)
	cp a,#LPAREN_IDX 
	jrne 3$ 
	call expression 
	cpw x,(DEST_LEN,sp)
	jrule 2$
	ld a,#ERR_STR_OVFL
	jp tb_error 
2$:  
	decw x 
	ldw (TEMP,sp),x 
	addw x,(DEST_ADR,sp)
	ldw (DEST_ADR,sp),x
3$: ; space left in string space 
	ldw x,(DEST_SIZE,sp)
	subw x,(TEMP,sp)
	ldw (DEST_SIZE,sp),x 
; left side of '=' evaluated 
; expect '=' 
	ld a,#REL_EQU_IDX 
	call expect 
; evaluate right side 
; it may be:
;    string expression 
;    CHR$(expr) 
	_next_token 
	cp a,#QUOTE_IDX
	jrne 4$
	ldw x,y
	ldw (SRC_ADR,sp),x  
	call strlen  ; copy count 
	ld (SIZE+1,sp),a
	addw y,(SIZE,sp)
	incw y 
	ldw x,(DEST_SIZE,sp)
	cpw x,(SIZE,sp) 
	jruge 1$ 
0$:	ld a,#ERR_STR_OVFL 
	jp tb_error 
1$: 
	ldw x,(SIZE,sp) 
	_strxz acc16 
	jra 5$ 
4$: 
	; VAR$ expression 
	cp a,#STR_VAR_IDX
	jrne 42$  
	call get_var_adr 
	call get_string_slice
	ldw (SRC_ADR,sp),x   
	_clrz acc16 
	_straz acc8 
	ld (SIZE+1,sp),a 
	cp a,(DEST_SIZE+1,sp)
	jrugt 0$
	jra 5$ 
42$: cp a,#CHAR_IDX 
	jreq 44$ 
	jp syntax_error 
44$: _call_code 
	ld a,xl 
	and a,#127 
	ldw x,(DEST_ADR,sp)
	tnz (x)
	jrne 46$ 
	clr (1,x)
46$:	
	ld (x),a 
	jra 9$  
5$:
	ldw x,(DEST_ADR,sp) 
	ldw (TEMP,sp),y ; save basic pc   
	ldw y,(SRC_ADR,sp)
	call move 
	addw x,(SIZE,sp)
	clr (x)
6$: 
	ldw y,(TEMP,sp) ; restore basic pc 
9$:	_drop VSIZE2 
	_next 

;----------------------
; extract a slice 
; from string variable
; str(val1[,val2]) 
; or complete string 
; if no indices 
; input:
;   X     var_adr
;   Y     point to (expr,expr)
;   ptr16 destination
; ouput:
;   A    slice length 
;   X    slice address   
;----------------------
	VAL2=1 
	VAL1=VAL2+INT_SIZE 
	CHAR_ARRAY=VAL1+INT_SIZE 
	RES_LEN=CHAR_ARRAY+INT_SIZE  
	YTEMP=RES_LEN+INT_SIZE 
	VSIZE=4*INT_SIZE 
get_string_slice:
	_vars VSIZE
	clr (RES_LEN,sp)
	ldw x,(2,x) ; char array 
	ldw (CHAR_ARRAY,sp),x 
	ld a,(x)
	ld (RES_LEN+1,sp),a ; reserved space  
; default slice to entire string 
	clr (VAL1,sp)
	ld a,#1 
	ld (VAL1+1,sp),a
	clr (VAL2,sp)
	incw x 
	call strlen
	ld (VAL2+1,sp),a 
	ld a,(y)
	cp a,#LPAREN_IDX 
	jreq 1$
	jra 4$  
1$:  
	incw y 
	call expression
	cpw x,#1 
	jrpl 2$ 
0$:	ld a,#ERR_STR_OVFL 
	jp tb_error 
2$:	cpw x,(VAL2,sp)
	jrugt 0$
	ldw (VAL1,sp),x 
	ld a,(y)
	cp a,#RPAREN_IDX 
	jrne 3$
	incw y 
	jra 4$
3$: 
	ld a,#COMMA_IDX 
	call expect 
	call expression 
	cpw x,(VAL2,sp)
	jrugt 0$ 
	ldw (VAL2,sp),x
	ld a,#RPAREN_IDX 
	call expect 
4$: ; length and slice address 
	ldw x,(VAL2,sp)
	subw x,(VAL1,sp)
	incw x 
	ld a,xl ; slice length 
	ldw x,(CHAR_ARRAY,sp)
	addw x,(VAL1,sp)
	_drop VSIZE 
	ret 


;-----------------------
; allocate data space 
; on heap 
; reserve to more bytes 
; than required 
; input: 
;    X     size 
; output:
;    X     addr 
;------------------------
heap_alloc:
	addw x,#2 
	pushw x 
	ldw x,heap_free 
	subw x,dvar_end 
	cpw x,(1,sp)
	jruge 1$
	ld a,#ERR_MEM_FULL 
	jp tb_error 
1$: ldw x,heap_free 
	subw x,(1,sp)
	_strxz heap_free 
	_drop 2 
	ret 

;---------------------------
; create scalar variable 
; and initialize to 0.
; abort program if mem full 
; input:
;   x    var_name 
; output:
;   x    var_addr 
;-----------------------------
	VNAME=1 
	VSIZE=2 
create_var:
	_vars VSIZE 
	ldw (VNAME,sp),x 
	ldw x,heap_free 
	subw x,dvar_end 
	cpw x,#4 
	jruge 1$ 
	ld a,#ERR_MEM_FULL
	jp tb_error 
1$: 
	ldw x,dvar_end 
	ld a,(VNAME,sp)
	ld (x),a 
	ld a,(VNAME+1,sp)
	ld (1,x),a 
	clr (2,x)
	clr (3,x)
	pushw x 
	addw x,#4 
	_strxz dvar_end 
	popw x ; var address 
	_drop VSIZE  
	ret 

;------------------------
; last token was VAR_IDX 
; next is VAR_NAME 
; extract name
; search var 
; return data field address 
; input:
;   Y      *var_name 
; output:
;   y       Y+2 
;   X       var address
; ------------------------
	F_ARRAY=1
	VNAME=2 
	VSIZE=3 
get_var_adr:
	_vars VSIZE
	clr (F_ARRAY,sp)
	_get_word 
	ldw (VNAME,sp),x 
	ld a,(y) 
	cp a,#LPAREN_IDX 
	jrne 1$ 
	cpl (F_ARRAY,sp)
	ld  a,xh 
	or a,#128 
	ld xh,a 
	ld (VNAME,sp),a 
1$: 
	call search_var
	tnzw x 
	jrne 9$ ; found 
; not found, if scalar create it 
	tnz (F_ARRAY,sp)
	jreq 2$ 
; this array doesn't exist
; check for var(1) form 
	call check_for_idx_1
2$:	 	
	ld a,(VNAME+1,sp)
	cp a,#'$ 
	jrne 8$
	ld a,#ERR_DIM 
	jp tb_error
8$:	
	ldw x,(VNAME,sp)
; it's not an array 
	ld a,xh 
	and a,#127 
	ld xh,a 
	call create_var	
9$:
	_drop VSIZE 
	ret 

;-------------------------
; a scalar variable can be 
; addressed as var(1)
; check for it 
; fail if not that form 
; input: 
;   X     var address 
;   Y     *next token after varname
;-------------------------
check_for_idx_1: 
	addw x,#2 ; 
	pushw x ; save value  
	ld a,(y)
	cp a,#LPAREN_IDX 
	jrne 3$ 
	call func_args 
	cp a,#1 
	jreq 2$
1$:	jp syntax_error  
2$:
	_i16_pop 
	cpw x,#1 
	jreq 3$
	ld a,#ERR_RANGE  
	call tb_error  
3$:
	popw x 
    ret 


;--------------------------
; get array element address
; input:
;   X     var addr  
; output:
;    X     element address 
;---------------------------
	IDX=1 
	SIZE_FIELD=IDX+INT_SIZE 
	VSIZE=2*INT_SIZE 
get_array_adr:
	_vars VSIZE
	tnz (x)
	jrmi 10$ 
; scalar data field follow name
; check for 'var(1)' format 	
	call check_for_idx_1
	jra 9$ 
10$:	 
	ldw x,(2,x) ; array data address 
	ldw (SIZE_FIELD,sp),x ; array size field 
	ld a,(y)
	cp a,#LPAREN_IDX  
	jreq 0$ 
	addw x,#2 
	jra 9$ 
0$:
	call func_args 
	cp a,#1 
	jreq 1$ 
	jp syntax_error 
1$: _i16_pop 
	tnzw x 
	jreq 2$ 
	ldw (IDX,sp),x 
	ldw x,(SIZE_FIELD,sp)
	ldw x,(x) ; array size 
	cpw x,(IDX,sp)
	jrpl 3$ 
2$: 
	ld a,#ERR_RANGE 
	jp tb_error 
3$: 
	ldw x,(IDX,sp) 
	sllw x ; 2*IDX  
	addw x,(SIZE_FIELD,sp)
9$:
	_drop VSIZE 
	ret 

;-----------------------
; get string reserved 
; space 
; input:
;   X     string data pointer 
; output:
;   X      space 
;-----------------------------
get_string_space:
	ldw x,(x) ; data address 
	ld a,(x) ; space size 
	clrw x
	ld xl,a 
	ret 

;--------------------------
; search dim var_name 
; format of record 
;  field | size 
;------------------- 
;  name | {2} byte, for array bit 15 of name is set
;  data:  
;  	integer | INT_SIZE 
;  	str   | len(str)+1, counted string 
;  	array | size=2 byte, data=size*INT_SIZE   
;  
; input:
;    X     name
; output:
;    X     address|0
; use:
;   A,Y, acc16 
;-------------------------
	VAR_NAME=1 ; target name pointer 
;	WLKPTR=VAR_NAME+2   ; walking pointer in RAM 
	SKIP=VAR_NAME+2
	VSIZE=SKIP+1  
search_var:
	pushw y 
	_vars VSIZE
; reset bit 7 
	ld a,xh 
	and a,#127
    ld xh,a 
	ldw (VAR_NAME,sp),x
	ldw y,dvar_bgn
1$:	
	cpw y, dvar_end
	jrpl 7$ ; no match found 
	ldw x,y 
	ldw x,(x)
; reset bit 7 
	ld a,xh 
	and a,#127
    ld xh,a 
	cpw x,(VAR_NAME,sp)
	jreq 8$ ; match  
; skip this one 	
	addw y,#4 
	jra 1$ 
	ld a,(y)
7$: ; no match found 
	clrw y 
8$: ; match found 
	ldw x,y  ; variable address 
9$:	_DROP VSIZE
	popw y 
	ret 

;---------------------------------
; BASIC: DIM var_name(expr) [,var_name(expr)]* 
; create named variables at end 
; of BASIC program. 
; value are not initialized 
; bit 7 of first character of name 
; is set for string and array variables 
;---------------------------------
	HEAP_ADR=1 
	DIM_SIZE=HEAP_ADR+ADR_SIZE 
	VAR_NAME=DIM_SIZE+INT_SIZE
	VAR_ADR=VAR_NAME+NAME_SIZE  
	VAR_TYPE=VAR_ADR+ADR_SIZE 
	VSIZE=4*INT_SIZE+1 
kword_dim:
	_vars VSIZE
dim_next: 
	_next_token
	ld (VAR_TYPE,sp),a 
	ldw x,y 
	addw y,#2 
	ldw x,(x) ; var name 
; set bit 7 for string or array 
	ld a,xh 
	or a,#128 
	ld xh,a 
	ldw (VAR_NAME,sp),x 
	call search_var  
	tnzw x 
	jreq 1$ ; doesn't exist 
; if string or integer array 
; abort with error 
	ldw (VAR_ADR,sp),x
	tnz (x)
	jrpl 0$  ; it is a scalar will be transformed in array 
	ld a,#ERR_DIM ; string or array already exist 
	jp tb_error
0$: or a,#128 ; make it array  
	ld (x),a 
	jra 2$ 	
1$:
	ldw x,(VAR_NAME,sp)
	call create_var
	ldw (VAR_ADR,sp),x  
2$: 
	call func_args 
	cp a,#1
	jreq 21$
	jp syntax_error 
21$: _i16_pop 
	ldw (DIM_SIZE,sp),x 
	cpw x,#1 
	jrpl 4$ 
3$:
	ld a,#ERR_RANGE ; array or string must be 1 or more  
	jp tb_error 
4$: ld a,(VAR_TYPE,sp)
	cp a,#VAR_IDX 
	jreq 5$ 
	cpw x,#256 
	jrmi 42$ ; string too big
; remove created var 
	_ldxz dvar_end 
	subw x,#4 
	_strxz dvar_end 
	ld a,#ERR_GT255
	jp tb_error
42$:
	call heap_alloc 
	ldw (HEAP_ADR,sp),x 
; put size in high byte 
; 0 in low byte  
	ld a,(DIM_SIZE+1,sp)
	ld (DIM_SIZE,sp),a  
	clr (DIM_SIZE+1,sp)
	jra 7$ 
5$: ; integer array 
	sllw x  
	call heap_alloc 
	ldw (HEAP_ADR,sp),x 
7$: 	
; initialize size field 
	ld a,(DIM_SIZE,sp)
	ld (x),a
	ld a,(DIM_SIZE+1,sp) 
	ld (1,x),a 
8$: ; initialize pointer in variable 
	ldw x,(VAR_ADR,sp)
	ld a,(HEAP_ADR,sp)
	ld (2,x),a 
	ld a,(HEAP_ADR+1,sp)
	ld (3,x),a 
	_next_token 
	cp a,#COMMA_IDX 
	jrne 9$
	jp dim_next 
9$: 
	_unget_token 	
	_drop VSIZE 
	_next 


;;;;;;;;;;;;;;;;;;;;;;;;;;
; return program size 
;;;;;;;;;;;;;;;;;;;;;;;;;;
prog_size:
	_ldxz progend
	subw x,lomem 
	ret 

;----------------------------
; print program information 
;---------------------------
program_info: 
	push base 
	ldw x,#PROG_ADDR 
	call puts 
	_ldxz lomem 
	mov base,#16 
	call print_int
	mov base,#10  
	ldw x,#PROG_SIZE
	call puts 
	call prog_size 
	call print_int 
	ldw x,#STR_BYTES 
	call puts
	_ldxz lomem
	cpw x,#app 
	jrult 2$
	ldw x,#FLASH_MEM 
	jra 3$
2$: ldw x,#RAM_MEM 	 
3$:	call puts 
	ld a,#CR 
	call putc
	pop base 
	ret 

PROG_ADDR: .asciz "program address: "
PROG_SIZE: .asciz ", program size: "
STR_BYTES: .asciz " bytes" 
FLASH_MEM: .asciz " in FLASH memory" 
RAM_MEM:   .asciz " in RAM memory" 


;----------------------------
; BASIC: LIST [[start][-end]]
; list program lines 
; form start to end 
; if empty argument list then 
; list all.
;----------------------------
	FIRST=1
	LAST=3 
	LN_PTR=5
	VSIZE=6
cmd_list:
	call prog_size 
	jrugt 1$
	jp cmd_line 
1$:
	 _vars VSIZE
	_ldxz lomem 
	ldw (LN_PTR,sp),x 
	ldw x,(x) 
	ldw (FIRST,sp),x ; list from first line 
	ldw x,#MAX_LINENO ; biggest line number 
	ldw (LAST,sp),x 
	_next_token
	tnz a 
	jreq print_listing 
	cp a,#SUB_IDX 
	jreq list_to
	decw y    
	call expect_integer 
	ldw (FIRST,sp),x	
	_next_token
	tnz a 
	jrne 2$ 
	ldw (LAST,sp),x  
	jra  print_listing 
2$: 
	cp a,#SUB_IDX  
	jreq 3$ 
	jp syntax_error
3$: _next_token 
	tnz a 
	jreq print_listing
	decw y	 
list_to: ; listing will stop at this line
    call expect_integer 
	ldw (LAST,sp),x
print_listing:
; skip lines smaller than FIRST 
	ldw y,(LN_PTR,sp)
	 _clrz acc16 
1$:	ldw x,y 
	ldw x,(x)
	cpw x,(FIRST,sp)
	jrpl 2$
	ld a,(2,y)
	_straz acc8
	addw y,acc16
	cpw y,progend 
	jrpl list_exit 
	jra 1$
2$: ldw (LN_PTR,sp),y 	
list_loop:
	ldw x,(LN_PTR,sp)
	ldw line.addr,x 
	ld a,(2,x) 
	sub a,#LINE_HEADER_SIZE
	call prt_basic_line
	ldw x,(LN_PTR,sp)
	ld a,(2,x)
	_straz acc8
	_clrz acc16 
	addw x,acc16
	cpw x,progend 
	jrpl list_exit
	ldw (LN_PTR,sp),x
	ldw x,(x)
	cpw x,(LAST,sp)  
	jrsle list_loop
list_exit:
	_drop VSIZE 
	call program_info
	jp cmd_line 

;---------------------------------
; decompile line from token list
; and print it. 
; input:
;   A       stop at this position 
;   X 		pointer at line
; output:
;   none 
;----------------------------------	
prt_basic_line::
	_straz count 
	addw x,#LINE_HEADER_SIZE  
	ldw basicptr,x
    ldw y,x 
	call decompile
;call new_line 
	ret 

;---------------------------------
; BASIC: PRINT|? arg_list 
; print values from argument list
;----------------------------------
	SEMICOL=1
	VSIZE=1
cmd_print:
	_vars VSIZE 
reset_semicol:
	clr (SEMICOL,sp)
prt_loop:
	_next_token	
	cp a,#CMD_END 
	jrugt 0$
	_unget_token
	jra 8$
0$:	
	cp a,#QUOTE_IDX
	jreq 1$
	cp a,#STR_VAR_IDX 
	jreq 2$ 
	cp a,#SCOL_IDX  
	jreq 4$
	cp a,#COMMA_IDX
	jreq 5$	
	cp a,#CHAR_IDX 
	jreq 6$
	jra 7$ 
1$:	; print string 
	ldw x,y 
	call puts
	ldw y,x  
	jra reset_semicol
2$:	; print string variable  
	call get_var_adr 
	call get_string_slice 
	tnz a 
	jreq 22$   
	push a
21$: 
	ld a,(x)
	incw x 
	call putc
	dec (1,sp)
	jrne 21$ 
	pop a  
22$:
	jra reset_semicol 
4$: ; set semi-colon  state 
	cpl (SEMICOL,sp)
	jra prt_loop 
5$: ; skip to next terminal tabulation
     ; terminal TAB are 8 colons 
     ld a,#9 
	 call putc 
	 jra reset_semicol
6$: ; appelle la foncton CHAR()
	_call_code 
	rrwa x 
	call putc 
	jra reset_semicol	 	    
7$:	
	_unget_token 
	call condition
	call print_int
	jp reset_semicol 
8$:
	tnz (SEMICOL,sp)
	jrne 9$
	ld a,#CR 
    call putc 
9$:	
	_drop VSIZE 
	_next

;----------------------
; 'save_context' and
; 'rest_context' must be 
; called at the same 
; call stack depth 
; i.e. SP must have the 
; same value at  
; entry point of both 
; routine. 
;---------------------
	CTXT_SIZE=4 ; size of saved data 
;--------------------
; save current BASIC
; interpreter context 
; on stack 
;--------------------
	_argofs 0 
	_arg LNADR 1 
	_arg BPTR 3
save_context:
	ldw (BPTR,sp),y 
	_ldxz line.addr
	ldw (LNADR,sp),x 
	ret

;-----------------------
; restore previously saved 
; BASIC interpreter context 
; from stack 
;-------------------------
rest_context:
	ldw x,(LNADR,sp)
	ldw line.addr,x 
	ldw y,(BPTR,sp)
	ret


;-----------------------
; ask user to retype 
; input value 
;----------------------
retype:
	call new_line
	ldw x,#err_retype 
	call puts 
	call new_line 
	ret 

;--------------------------
; readline from terminal 
; and parse it in pad 
;-------------------------
input_prompt:
	ld a,#'? 
	call putc 
	ret 

;-----------------------
; print variable name 
; input:
;    X    var name 
; use:
;   A 
;-----------------------
print_var_name:
	ld a,xh 
	and a,#127 
	call uart_putc 
	ld a,xl 
	and a,#127 
	call uart_putc 
	ret  

;--------------------------
; input integer to variable 
; input:
;   X     var name 
; output:
;   X      value 
;----------------------------
	N=1
	DIGIT=N+INT_SIZE 
	SIGN=DIGIT+INT_SIZE
	COUNT=SIGN+1 
 	VSIZE=COUNT  
input_integer:
	_vars VSIZE 
	clr (DIGIT,sp)
	call print_var_name 
	call input_prompt  
	clrw x 
	ldw (N,sp),x 
	ldw (SIGN,sp),x
	mov base,#10
	call getc 
	cp a,#'- 
	jrne 1$ 
	cpl (SIGN,sp)
	jra 2$ 
1$: cp a,#'$ 
	jrne 3$ 
	mov base,#16  
2$: call getc
3$: cp a,#BS 
	jrne 4$ 
	tnz (COUNT,sp)
	jreq 2$ 
	call bksp 
	ldw x,(N,sp)
	_ldaz base 
	div x,a 
	ldw (N,sp),x
	dec (COUNT,sp)
	jra 2$  
4$:	
	call uart_putc 
	cp a,#CR 
	jreq 7$ 
	call char_to_digit 
	jrnc 9$
	inc (COUNT,sp)
	ld (DIGIT+1,sp),a 
	ldw x,(N,sp)
	_ldaz base 
	call umul16_8
	addw x,(DIGIT,sp)
	ldw (N,sp),x
	jra 2$  	
7$: ldw x,(N,sp)
	tnz (SIGN,sp)
	jreq 8$ 
	negw x 
8$: 
	scf ; success 	
9$:	
	_drop VSIZE 
	ret 

;---------------------------------------
; input value for string variable 
; accumulate all character up to CR 
; input:
;   X     var name  
; output:
;   X     *tib 
;-------------------------------------- 
input_string:
	call print_var_name 
	call input_prompt 
	clr a 
	call readln 
	ldw x,#tib 
	ret 

;------------------------------------------
; BASIC: INPUT [string],var[,var]
; input value in variables 
; [string] optionally can be used as prompt 
;-----------------------------------------
	BPTR=1
	VAR_VALUE=BPTR+2
	VAR_ADR =VAR_VALUE+2
	VSIZE=3*INT_SIZE  
cmd_input:
	btjt flags,#FRUN,1$ 
	ld a,#ERR_PROG_ONLY
	jp tb_error 
1$: 
	_vars VSIZE 
	ld a,(y) 
	cp a,#QUOTE_IDX 
	jrne 2$ 
	incw y 
	ldw x,y  
	call puts 
	ldw y,x 
	call new_line
	_next_token 
	cp a,#COMMA_IDX 
	jreq 2$  
	jp syntax_error 
2$:
	_next_token
	cp a,#CMD_END+1  
	jrmi input_exit  
    cp a,#VAR_IDX
	jreq 4$
	cp a,#STR_VAR_IDX 
	jreq 8$ 
	jp syntax_error 
4$: 
	ldw x,y 
	ldw x,(x)
	ldw (VAR_ADR,sp),x ; var name 
5$:	ldw x,(VAR_ADR,sp) 
	call input_integer 
	jrc 6$ 
	call retype 
	jra 5$ 	  
6$: 
	ldw (VAR_VALUE,sp),x 
	call get_var_adr 
	call get_array_adr 
	ld a,(VAR_VALUE,sp)
	ld (x),a 
	ld a,(VAR_VALUE+1,sp)
	ld (1,x),a 
7$: 
	_next_token 
	cp a,#COMMA_IDX 
	jreq 2$
	_unget_token   
	jra input_exit ; all variables done
8$: ;input string 
	ldw x,y
	ldw x,(x)
	ldw (VAR_ADR,sp),x ; save var name 
	call input_string  
	call get_var_adr 
	ldw (VAR_ADR,sp),x ; needed later 
	call get_string_slice 
	ldw (BPTR,sp),y  
	ldw y,#tib
	call strcpy 
	ldw x,#tib 
	call strlen 
	ldw x,(VAR_ADR,sp)
	ldw x,(x)
	ld (x),a 
	ldw y,(BPTR,sp)
	jra 7$   	 
input_exit:
	_drop VSIZE 
	_next  

;---------------------
;BASIC: KEY
; wait for a character 
; received from STDIN 
; input:
;	none 
; output:
;	x  character 
;---------------------
func_key:
	clrw x 
	call qgetc 
	jreq 9$ 
	call getc 
	rlwa x  
9$:
	ret 

;--------------------
; BASIC: POKE addr,byte
; put a byte at addr 
;--------------------
	VALUE=1
	POK_ADR=VALUE+INT_SIZE 
cmd_poke:
	call arg_list 
	cp a,#2
	jreq 1$
	jp syntax_error
1$:	
	_i16_fetch POK_ADR ; address   
	ld a,(VALUE+1,sp) 
	ld (x),a 
	_drop 2*INT_SIZE 
	_next 

;-----------------------
; BASIC: PEEK(addr)
; get the byte at addr 
; input:
;	none 
; output:
;	X 		value 
;-----------------------
func_peek:
	call func_args
	cp a,#1 
	jreq 1$
	jp syntax_error
1$: _i16_pop ; address  
	ld a,(x)
	clrw x 
	ld xl,a 
	ret 

;---------------------------
; BASIC IF expr : instructions
; evaluate expr and if true 
; execute instructions on same line. 
;----------------------------
kword_if: 
	ld a,(y)
	cp a,#STR_VAR_IDX 
	jreq if_string 
	cp a,#QUOTE_IDX
	jreq if_string 
	call condition
	tnzw x 
	jrne 1$ 
	jp kword_remark 
1$: ld a,#THEN_IDX 
	call expect 
cond_accepted: 
	ld a,(y)
	cp a,#LITW_IDX 
	jrne 2$ 
	jp kword_goto
2$:	_next  
;-------------------------
; if string condition 
;--------------------------
	STR1=1 
	STR1_LEN=STR1+2
	STR2=STR1_LEN+2
	STR2_LEN=STR2+2 
	OP_REL=STR2_LEN+2 
	YSAVE=OP_REL+1
	VSIZE=YSAVE+1
if_string: 
	_vars VSIZE
	clr (STR1_LEN,sp)
	clr (STR2_LEN,sp)
	incw y
	cp a,#QUOTE_IDX
	jrne 1$ 
	ldw (STR1,sp),y 
	ldw x,y 
	call strlen 
	ld (STR1_LEN+1,sp),a
	addw x,(STR1_LEN,sp)
	incw x 
	ldw y,x  
	jra 2$ 
1$:	  
	call get_var_adr 
	call get_string_slice 	
	ldw (STR1,sp),x 
	ld (STR1_LEN+1,sp),a 
2$: ld a,(y)
	cp a,#REL_LE_IDX 
	jrmi 3$ 
	cp a,#OP_REL_LAST 
	jrule 4$
3$:	
	jp syntax_error 
4$: 
	ld (OP_REL,sp),a 
	incw y 
;expect second string 	
	_next_token 
	cp a,#QUOTE_IDX
	jrne 5$ 
	ldw (STR2,sp),y 
	ldw x,y 
	call strlen 
	ld (STR2_LEN+1,sp),a 
	addw x,(STR2_LEN,sp)
	incw x 
	ldw y,x 
	jra 54$
5$: cp a,#STR_VAR_IDX
	jrne 3$
	call get_var_adr 
	call get_string_slice 
	ldw (STR2,sp),x 
	ld (STR2_LEN+1,sp),a
54$:
	ld a,#THEN_IDX 
	call expect
; compare strings 
	ldw (YSAVE,sp),y 
	ldw x,(STR1,sp)
	ldw y,(STR2,sp)
6$:
	tnz (STR1_LEN+1,sp) 
	jreq 7$ 
	tnz (STR2_LEN+1,sp)
	jreq 7$ 
	ld a,(x)
	cp a,(y)
	jrne 8$ 
	incw x 
	incw y 
	dec (STR1_LEN+1,sp)
	dec (STR2_LEN+1,sp)
	jra 6$ 
7$: ; string end  
	ld a,(STR1_LEN+1,sp)
	cp a,(STR2_LEN+1,sp)
8$: ; no match  
	jrmi 9$ 
	jrne 10$ 
; STR1 == STR2  
	ld a,(OP_REL,sp)
	cp a,#REL_EQU_IDX 
	jreq 11$ 
	jrmi 11$ 
	jra 13$ 
9$: ; STR1 < STR2 
	ld a,(OP_REL,sp)
	cp a,#REL_LT_IDX 
	jreq 11$
	cp a,#REL_LE_IDX  
	jreq 11$
	jra 13$  
10$: ; STR1 > STR2 
	ld a,(OP_REL,sp)
	cp a,#REL_GT_IDX 
	jreq 11$ 
	cp a,#REL_GE_IDX 
	jrne 13$ 
11$: ; accepted
	ldw y,(YSAVE,sp)
	_drop VSIZE 
	ld a,(y)
	cp a,#LITW_IDX 
	jrne 12$
	jp kword_goto 
12$: _next 
13$: ; rejected 
	ldw y,(YSAVE,sp)
	_drop VSIZE
	jp kword_remark  
	_next 


;------------------------
; BASIC: FOR var=expr 
; set variable to expression 
; leave variable address 
; on stack and set
; FLOOP bit in 'flags'
;-----------------
	FSTEP=1  ; variable increment int16
	LIMIT=FSTEP+INT_SIZE ; loop limit, int16  
	CVAR=LIMIT+INT_SIZE   ; control variable data field 
	LN_ADDR=CVAR+2   ;  line.addr saved
	BPTR=LN_ADDR+2 ; basicptr saved
	VSIZE=BPTR+1  
kword_for: ; { -- var_addr }
	_vars VSIZE
	_ldaz for_nest 
	cp a,#8 
	jrmi 1$ 
	ld a,#ERR_FORS
	jp tb_error 
1$: inc a 
	_straz for_nest 
	ldw x,#1 
	ldw (FSTEP,sp),x  
	ld a,#VAR_IDX 
	call expect 
	call get_var_adr
	addw x,#2 
	ldw (CVAR,sp),x  ; control variable 
	_strxz ptr16 
	ld a,#REL_EQU_IDX 
	call expect 
	call expression
	ldw [ptr16],x
	ld a,#TO_IDX 
	call expect 
;-----------------------------------
; BASIC: TO expr 
; second part of FOR loop initilization
; leave limit on stack and set 
; FTO bit in 'flags'
;-----------------------------------
kword_to: ; { var_addr -- var_addr limit step }
    call expression   
2$:
	ldw (LIMIT,sp),x
	_next_token 
	cp a,#STEP_IDX 
	jreq kword_step
	_unget_token
	jra store_loop_addr 

;----------------------------------
; BASIC: STEP expr 
; optional third par of FOR loop
; initialization. 	
;------------------------------------
kword_step: ; {var limit -- var limit step}
    call expression 
2$:	
	ldw (FSTEP,sp),x ; step
; leave loop back entry point on stack 
store_loop_addr:
	ldw (BPTR,sp),y 
	_ldxz line.addr 
	ldw (LN_ADDR,sp),x   
	_next 

;--------------------------------
; BASIC: NEXT var 
; FOR loop control 
; increment variable with step 
; and compare with limit 
; loop if threshold not crossed.
; else stack. 
;--------------------------------
	OFS=2 ; offset added by pushw y 
kword_next: ; {var limit step retl1 -- [var limit step ] }
; skip over variable name 
	_tnz for_nest 
	jrne 1$ 
	ld a,#ERR_BAD_NEXT 
	jp tb_error
1$:
	addw y,#3 ; ignore variable token 
	ldw x,(CVAR,sp)
	_strxz ptr16 
	; increment variable 
	ldw x,(x)  ; get var value 
	addw x,(FSTEP,sp) ; var+step 
	ldw [ptr16],x 
	subw x,(LIMIT,sp) 
	_strxz acc16 
	jreq loop_back
	_ldaz acc16 
	xor a,(FSTEP,sp)
	jrpl loop_done 
loop_back:
	ldw y,(BPTR,sp)
	ldw x,(LN_ADDR,sp)
	ldw line.addr,x 
1$:	_next 
loop_done:
	_decz for_nest 
	; remove loop data from stack  
	_drop VSIZE 
	_next 

;----------------------------
; called by goto/gosub
; to get target line number 
; output:
;    x    line address 
;---------------------------
get_target_line:
	call expression 
target01: 
	clr a 
	btjf flags,#FRUN,2$ 
0$:	cpw x,[line.addr] 
	jrult 2$ ; search from lomem 
	jrugt 1$
	ldw x,line.addr
1$:	cpl a  ; search from this line#
2$: 	
	call search_lineno 
	tnz a ; 0 if not found  
	jrne 3$ 
	ld a,#ERR_BAD_BRANCH  
	jp tb_error 
3$:
	ret 

;------------------------
; BASIC: GOTO line# 
; jump to line# 
; here cstack is 2 call deep from interpreter 
;------------------------
kword_goto:
kword_goto_1:
	call get_target_line
	btjt flags,#FRUN,1$
; goto line# from command line 
	bset flags,#FRUN 
1$:
jp_to_target:
	ldw line.addr,x 
	addw x,#LINE_HEADER_SIZE
	ldw y,x   
	btjf flags,#FTRACE,9$ 
	call prt_line_no 
9$:	_next


;--------------------
; BASIC: GOSUB line#
; basic subroutine call
; actual line# and basicptr 
; are saved on stack
;--------------------
	RET_BPTR=1 ; basicptr return point 
	RET_LN_ADDR=3  ; line.addr return point 
	VSIZE=4 
kword_gosub:
kword_gosub_1:
	_ldaz gosub_nest 
	cp a,#8 
	jrmi 1$
	ld a,#ERR_GOSUBS
	jp tb_error 
1$: inc a
	_straz gosub_nest 
	call get_target_line 
	ldw ptr16,x ; target line address 
kword_gosub_2: 
	_vars VSIZE  
; save BASIC subroutine return point.   
	ldw (RET_BPTR,sp),y 
	_ldxz line.addr 
	ldw (RET_LN_ADDR,sp),x
	_ldxz ptr16  
	jra jp_to_target

;------------------------
; BASIC: RETURN 
; exit from BASIC subroutine 
;------------------------
kword_return:
	tnz gosub_nest 
	jrne 1$ 
	ld a,#ERR_BAD_RETURN 
	jp tb_error 
1$:
	_decz gosub_nest
	ldw y,(RET_BPTR,sp) 
	ldw x,(RET_LN_ADDR,sp)
	ldw line.addr,x 
	_drop VSIZE 
	_next 

;----------------------------------
; BASIC: RUN [line#]
; run BASIC program in RAM
;----------------------------------- 
cmd_run: 
	btjf flags,#FRUN,1$  
	_next ; already running 
1$: 
	ld a,(y)
	cp a,#QUOTE_IDX
	jreq 10$
	ldw x,progend 
	cpw x,lomem 
	jreq 9$
	call clear_state 
	ldw x,#STACK_EMPTY
	ldw sp,x 
	call arg_list 
	tnz  a 
	jreq 2$
	_i16_pop
	clr a  
	call search_lineno 
	tnz a
	jrne 3$ 
	ld a,#ERR_RANGE 
	jp tb_error 
2$:
	ldw x,lomem 
3$:
	_strxz line.addr 
	addw x,#LINE_HEADER_SIZE
	ldw y,x 
	bset flags,#FRUN 
9$:
	_next 
;------------------------
; load and run file
;------------------------
10$:
	incw y 
	call basic_load_file
	ldw x,progend 
	cpw x,lomem 
	jrugt 2$ 
	_next 

;----------------------
; BASIC: END
; end running program
;---------------------- 
	CHAIN_LN=1 
	CHAIN_BP=3
	CHAIN_TXTBGN=5
	CHAIN_TXTEND=7
	CHAIN_CNTX_SIZE=8  
kword_end: 
8$: ; clean stack 
	ldw x,#STACK_EMPTY
	ldw sp,x 
	_rst_pending 
	jp warm_start

;-----------------------
; BASIC: TONE expr1,expr2
; use TIMER2 channel 1
; to produce a tone 
; arguments:
;    expr1   frequency 
;    expr2   duration msec.
;---------------------------
	DURATION=1 
	FREQ=DURATION+INT_SIZE
	YSAVE=FREQ+INT_SIZE 
	VSIZE=2*INT_SIZE+2    
cmd_tone:
	pushw y
	call arg_list 
	cp a,#2 
	jreq 0$ 
	jp syntax_error
0$:  
	ldw (YSAVE,sp),y 
	_i16_fetch  FREQ 
	ldw y,x 
	_i16_fetch  DURATION 
	call tone  
	ldw y,(YSAVE,sp)
	_drop VSIZE 
	_next 


;-----------------------
; BASIC: STOP
; stop progam execution  
; without resetting pointers 
; the program is resumed
; with RUN 
;-------------------------
kword_stop:
	btjt flags,#FRUN,2$
	_next 
2$:	 
; create space on cstack to save context 
	ldw x,#stop_msg 
	call puts 
	_ldxz line.addr
	ldw x,(x)
	call print_int 
	ldw x,#con_msg 
	call puts 
	_vars CTXT_SIZE ; context size 
	call save_context 
	bres flags,#FRUN 
	bset flags,#FSTOP
	jp cmd_line  

stop_msg: .asciz "\nSTOP at line "
con_msg: .asciz ", CON to resume.\n"

;--------------------------------------
; BASIC: CON 
; continue execution after a STOP 
;--------------------------------------
kword_con:
	btjt flags,#FSTOP,1$ 
	_next 
1$:
	call rest_context 
	_drop CTXT_SIZE
	bres flags,#FSTOP 
	bset flags,#FRUN 
	jp interp_loop

;-----------------------
; BASIC: SCR (NEW)
; from command line only 
; free program memory
; and clear variables 
;------------------------
cmd_scr: 
cmd_new: 
0$:	btjt flags,#FRUN,9$
	call reset_basic 
9$:	_next 

;-----------------------------------
; BASIC: ERASE "name" || \F  
;  options:
;   "name"    erase that program only  
;     \F    erase all spi eeprom  
;-----------------------------------
	LIMIT=1  ; 24 bits address 
	VSIZE = 3 
cmd_erase:
	btjf flags,#FRUN,0$
	_next 
0$:
	_clrz farptr
	clrw x 
	_strxz ptr16  
	_next_token
	cp a,#QUOTE_IDX 
	jrne not_file
erase_program: 
	ldw x,y
	call skip_string  
	call search_file
	tnz a 
	jreq 9$  ; not found 
8$:	
	call erase_file  
9$:	
	clr (y)
	_next 
not_file: 
	cp a,#LITC_IDX 
	jreq 0$ 
	jp syntax_error	
0$: _get_char 
	and a,#0XDF 
1$: cp a,#'F 
	jreq 2$
	jp syntax_error 
2$: 
	call eeprom_erase_chip 
	_next 
	
;---------------------------------------
; BASIC: SAVE "name" 
; save program to spi eeprom 
; if file already exist, replace it.
;--------------------------------------
cmd_save:
	btjf flags,#FRUN,0$
	_next 
0$:
	ldw x,progend  
	subw x,lomem 
	jreq 1$ 
	_next_token 
	cp a,#QUOTE_IDX
	jreq 2$ 
	jp syntax_error 
1$:
    ld a,#ERR_NO_PROG
	jp syntax_error
2$: 
	ldw x,y
	call name_to_fcb
	ldw x,lomem 
	_strxz fcb+FCB_BUFFER 
	ldw x,progend 
	subw x,lomem
	_strxz fcb+FCB_DATA_SIZE 
	ld a,#FILE_SAVE 
	_straz fcb+FCB_OPERATION
	call file_op 
9$: popw y 
	_next 

;-----------------------
;BASIC: LOAD "fname"
; load file in RAM 
;-----------------------
cmd_load: 
	btjf flags,#FRUN,0$
	_next 
0$:
	_next_token 
	cp a,#QUOTE_IDX
	jreq 1$ 
	jp syntax_error
1$:
	call basic_load_file 
	_next  

not_a_file: .asciz "file not found\n"

;--------------------------
; common factor 
; for LOAD and RUN "file"
;-------------------------
basic_load_file:
	ldw x,y 
	call skip_string 
	call search_file
	tnz a 
	jrne 2$ ; file found   
	ldw x,#not_a_file 
	call puts 
	jra 9$ 
2$: 
	call reset_basic 
	call load_file
9$: 
	clr (y)
	ret 



;---------------------
; BASIC: DIR 
; list programs saved 
; in 25LC1024  
;--------------------
	FCNT=1
cmd_dir:
	btjf flags,#FRUN,0$
	_next 
0$:
	call list_files 
	_next 



;------------------------------
; BASIC: BYE 
; exit BASIC and back to monitor  
;------------------------------
cmd_bye:
	btjt flags,#FRUN,9$ 
	btjf UART_SR,#UART_SR_TC,.
	_swreset
9$: _next 

;-------------------------------
; BASIC: SLEEP expr 
; suspend execution for n msec.
; input:
;	none
; output:
;	none 
;------------------------------
cmd_sleep:
	call expression
	bres sys_flags,#FSYS_TIMER 
	ldw timer,x
1$:	wfi 
	ldw x,timer 
	jrne 1$
	_next 

;------------------------------
; BASIC: TICKS
; return msec ticks counter value 
; input:
; 	none 
; output:
;	X 	msec since reset 
;-------------------------------
func_ticks:
	_ldxz ticks 
	ret

;---------------------------------
; BASIC: CHR$(expr)
; return ascci character 
;---------------------------------
func_char:
	ld a,#LPAREN_IDX 
	call expect 
	call expression 
	ld a,xl 
	clrw x  
	ld xl,a 
	ld a,#RPAREN_IDX 
	call expect 
	ret 


;------------------------------
; BASIC: ABS(expr)
; return absolute value of expr.
; input:
;   none
; output:
;   X   positive int16 
;-------------------------------
func_abs:
	call func_args 
	cp a,#1 
	jreq 0$ 
	jp syntax_error
0$: 
	_i16_pop
	tnzw x 
	jrpl 1$  
	negw x 
1$:	ret 

;---------------------------------
; BASIC: RND(n)
; return integer [0..n-1] 
; ref: https://en.wikipedia.org/wiki/Xorshift
;
; 	x ^= x << 13;
;	x ^= x >> 17;
;	x ^= x << 5;
;
;---------------------------------
func_random:
	call func_args 
	cp a,#1
	jreq 1$
	jp syntax_error
1$:
	call prng 
	pushw y 
	ldw y,(3,sp)
	divw x,y 
	exgw x,y 
	popw y 
	_drop 2 
	ret 

;---------------------------------
; BASIC: RANDOMIZE expr 
; intialize PRGN seed with expr 
; or with ticks variable value 
; if expr==0
;---------------------------------
cmd_randomize:
	call expression 
	call set_seed 
	_next 

;------------------------------
; BASIC: SGN(expr)
;    return -1 < 0 
;    return 0 == 0
;    return 1 > 0 
;-------------------------------
func_sign:
	call func_args 
	cp a,#1 
	jreq 0$ 
	jp syntax_error
0$:
	_i16_pop  
	tnzw x 
	jreq 9$
	jrmi 4$
	ldw x,#1
	ret
4$: ldw x,#-1    
9$:	ret 

;-----------------------------
; BASIC: LEN(var$||quoted string)
;  return length of string 
;----------------------------
func_len:
	ld a,#LPAREN_IDX 
	call expect 
	_next_token 
	cp a,#QUOTE_IDX
	jrne 2$ 
	ldw x,y 
	call strlen
	push a 
	push #0 
	addw y,(1,sp)
	incw y 
	_drop 2 
	jra 9$ 
2$:
	cp a,#STR_VAR_IDX 
	jreq 3$ 
	jp syntax_error
3$:
	call get_var_adr  
	ldw x,(2,x) 
	incw x 
	call strlen
9$:
	clrw x 
	ld xl,a 
	ld a,#RPAREN_IDX
	call expect 
	ret 

.if 1
;---------------------------------
; BASIC: WORDS [\C]
; affiche la listes des mots 
; réservés ainsi que le nombre
; de mots.
; si l'option \C est présente 
; affiche la valeur tokenizé des 
; mots réservés 
;---------------------------------
	COL_CNT=1 ; column counter 
	WCNT=COL_CNT+1 ; count words printed 
	SHOW_CODE=WCNT+1 ; display token code
	YSAVE=SHOW_CODE+1
	XSAVE=YSAVE+2 
	VSIZE=XSAVE+1  	
cmd_words:
	_vars VSIZE 
	clr (COL_CNT,sp) 
	clr (WCNT,sp)
	clr (SHOW_CODE,sp)
	_clrz acc16 
	ldw (YSAVE,sp),y 
	ld a,(y)
	cp a,#LITC_IDX 
	jrne 1$ 
	incw y 
	_get_char 
	cp a,#'C 
	jreq 0$ 
	jp syntax_error 
0$: 
	ldw (YSAVE,sp),y 
	cpl (SHOW_CODE,sp)
	ldw y,#all_words+2 ; special char. bytecode 
	jra 2$
1$: 
	ldw y,#kword_dict+2 ; show only reserved words 
2$:
	ldw x,y
	ld a,(x) ; word length 
	incw x ; *word   	
	tnz (SHOW_CODE,sp)
	jreq 3$
	ldw (XSAVE,sp),x 
	inc a 
	_straz acc8 	 	
	addw x,acc16 
	ld a,#'$
	call uart_putc 
	ld a,(x)
	call print_hex
	call space
	ldw x,(XSAVE,sp)   
3$:
	call puts
	inc (WCNT,sp)
	inc (COL_CNT,sp)
	ld a,(COL_CNT,sp)
	cp a,#4 
	jreq 5$ 
	swap a 
	inc a 
	call cursor_column
	jra  6$  
5$: 
	call new_line   
	clr (COL_CNT,sp) 
6$:	
	subw y,#2 
	ldw y,(y)
	jrne 2$ 
	ld a,#CR 
	call uart_putc  
	clrw x 
	ld a,(WCNT,sp)
	ld xl,a 
	call print_int 
	ldw x,#words_count_msg
	call puts 
	ldw y,(YSAVE,sp)
	_drop VSIZE 
	_next 
words_count_msg: .asciz " words in dictionary\n"
.endif 

;-----------------------------
; BASIC: TIMER expr 
; initialize count down timer 
;-----------------------------
cmd_set_timer:
	call arg_list
	cp a,#1 
	jreq 1$
	jp syntax_error
1$: 
	_i16_pop  
	bres sys_flags,#FSYS_TIMER  
	ldw timer,x
	_next 

;------------------------------
; BASIC: TIMEOUT 
; return state of timer 
; output:
;   A:X     0 not timeout 
;   A:X     -1 timeout 
;------------------------------
func_timeout:
	clr a 
	clrw x 
	btjf sys_flags,#FSYS_TIMER,1$ 
	cpl a 
	cplw x 
1$:	ret 
 	
.if 0
;---------------------------
; BASIC: DATA 
; when the interpreter find 
; a DATA line it skip over 
;---------------------------
kword_data:
	jp kword_remark

;------------------------------
; check if line is data line 
; if so set data_pointers 
; and return true 
; else move X to next line 
; and return false 
; input:
;    X     line addr 
; outpu:
;    A     0 not data 
;          1 data pointers set 
;    X     updated to next line addr 
;          if not data line 
;--------------------------------
is_data_line:
	ld a,(LINE_HEADER_SIZE,x)
	cp a,#DATA_IDX 
	jrne 1$
	_strxz data_line 
	addw x,#FIRST_DATA_ITEM
	_strxz data_ptr  
	ld a,#1 
	ret 
1$: clr acc16 
	ld a,(2,x)
	ld acc8,a 
	addw x,acc16
	clr a 
	ret  

;---------------------------------
; BASIC: RESTORE [line#]
; set data_ptr to first data line
; if no DATA found pointer set to
; zero.
; if a line# is given as argument 
; a data line with that number 
; is searched and the data pointer 
; is set to it. If there is no 
; data line with that number 
; the program is interrupted. 
;---------------------------------
cmd_restore:
	clrw x 
	ldw data_line,x 
	ldw data_ptr,x 
	_next_token 
	cp a,#CMD_END 
	jrugt 0$ 
	_unget_token 
	_ldxz lomem 
	jra 4$ 
0$:	cp a,#LITW_IDX
	jreq 2$
1$: jp syntax_error 	 
2$:	_get_word 
	call search_lineno  
	tnz a  
	jreq data_error 
	call is_data_line
	tnz a 
	jrne 9$ 
	jreq data_error
4$:
; search first DATA line 	
5$:	
	cpw x,himem
	jruge data_error 
	call is_data_line 
	tnz a 
	jreq 5$ 
9$:	_next  

data_error:	
    ld a,#ERR_NO_DATA 
	jp tb_error 


;---------------------------------
; BASIC: READ 
; return next data item | data error
; output:
;    A:X int24  
;---------------------------------
func_read_data:
read01:	
	ldw x,data_ptr
	ld a,(x)
	incw x 
	tnz a 
	jreq 4$ ; end of line
	cp a,#REM_IDX
	jreq 4$  
	cp a,#COMMA_IDX 
	jrne 1$ 
	ld a,(x)
	incw x 
1$:
.if 0
	cp a,#LIT_IDX 
	jreq 2$
.endif
	cp a,#LITW_IDX 
	jreq 14$
	jra data_error 
14$: ; word 
	clr a 
	_strxz data_ptr 	
	ldw x,(x)
.if 0	
	jra 24$
2$:	; int24  
	ld a,(x)
	incw x 
	_strxz data_ptr 
	ldw x,(x)
24$:
.endif 
	pushw x 
	_ldxz data_ptr 
	addw x,#2 
	_strxz data_ptr
	popw x 
3$:
	ret 
4$: ; check if next line is DATA  
	_ldxz data_line
	ld a,(2,x)
	ld acc8,a
	clr acc16  
	addw x,acc16 
	call is_data_line 
	tnz a 
	jrne read01  
	jra data_error 

;-------------------------------
; BASIC: CHAIN label
; Execute another program like it 
; is a sub-routine. When the 
; called program terminate 
; execution continue at caller 
; after CHAIN command. 
; if a line# is given, the 
; chained program start execution 
; at this line#.
;---------------------------------
	CHAIN_ADDR=1 
	CHAIN_LNADR=3
	CHAIN_BP=5
	CHAIN_TXTBGN=7 
	CHAIN_TXTEND=9 
	VSIZE=10
	DISCARD=2
cmd_chain:
	_vars VSIZE 
	clr (CHAIN_LN,sp) 
	clr (CHAIN_LN+1,sp)  
	ld a,#LABEL_IDX 
	call expect 
	pushw y 
	call skip_label
	popw x 
	incw x
	call search_file 
	tnzw x  
	jrne 1$ 
0$:	ld a,#ERR_BAD_VALUE
	jp tb_error 
1$: addw x,#FILE_HEADER_SIZE 
	ldw (CHAIN_ADDR,sp), x ; program addr 
; save chain context 
	_ldxz line.addr 
	ldw (CHAIN_LNADR,sp),x 
	ldw (CHAIN_BP,sp),y
	_ldxz lomem 
	ldw (CHAIN_TXTBGN,sp),x
	_ldxz himem 
	ldw (CHAIN_TXTEND,sp),x  
; set chained program context 	
	ldw x,(CHAIN_ADDR,sp)
	ldw line.addr,x 
	ldw lomem,x 
	subw x,#2
	ldw x,(x)
	addw x,(CHAIN_ADDR,sp)
	ldw himem,x  
	ldw y,(CHAIN_ADDR,sp)
	addw y,#LINE_HEADER_SIZE 
    _incz chain_level
	_drop DISCARD
	_next 


;-----------------------------
; BASIC TRACE 0|1 
; disable|enable line# trace 
;-----------------------------
cmd_trace:
	_next_token
	cp a,#LITW_IDX
	jreq 1$ 
	jp syntax_error 
1$: _get_word 
    tnzw x 
	jrne 2$ 
	bres flags,#FTRACE 
	_next 
2$: bset flags,#FTRACE 
	_next 

.endif 

;-------------------------
; BASIC: TAB expr 
;  print spaces 
;------------------------
cmd_tab:
	call expression  
	clr a 
	ld xh,a
	call spaces 
	_next 

;---------------------
; BASIC: CALL expr1 [,func_arg] 
; execute a function written 
; in binary code.
; input:
;   expr1	routine address
;   expr2   optional argument passed in X  
; output:
;    none 
;---------------------
	FN_ARG=1
	FN_ADR=3
cmd_call::
	call arg_list 
	cp a,#1
	jreq 1$
	cp a,#2
	jreq 0$ 
	jp syntax_error 
0$: 
	_i16_fetch FN_ADR  
	_strxz ptr16 
	_i16_pop 
	_drop 2 
	call [ptr16]
	_next 
1$: _i16_pop 	
	call (x)
	_next 

;------------------------
; BASIC:AUTO expr1, expr2 
; enable auto line numbering
;  expr1   start line number 
;  expr2   line# increment 
;-----------------------------
cmd_auto:
	btjt flags,#FRUN,9$ 
	ldw x,#10 
	_strxz auto_step 
	_strxz auto_line 
	call arg_list 
	tnz a 
	jreq 8$ 
	cp a,#1
	jreq 1$
	cp a,#2
	jreq 0$ 
	jp syntax_error 
0$: 
	_i16_pop 
	_strxz auto_step 
1$:	
	 _i16_pop 
	_strxz auto_line
8$:
	bset flags,#FAUTO
9$: 
	_next 


clear_state:
	_ldxz dvar_bgn
	_strxz dvar_end 
	ldw x,himem  
	_strxz heap_free  
	_rst_pending 
	_clrz gosub_nest 
	_clrz for_nest
	ret 

;---------------------------
; BASIC: CLR 
; reset stacks 
; clear all variables
;----------------------------
cmd_clear:
	btjt flags,#FRUN,9$
	ldw x,#STACK_EMPTY
	ldw sp,x 
	call clear_state  
9$: 
	_next 

;----------------------------
; BASIC: DEL val1,val2 	
;  delete all programs lines 
;  from val1 to val2 
;----------------------------
	START_ADR=1
	END_ADR=START_ADR+ADR_SIZE 
	DEL_SIZE=END_ADR+ADR_SIZE 
	YSAVE=DEL_SIZE+INT_SIZE 
	VSIZE=4*INT_SIZE  
cmd_del:
	btjf flags,#FRUN,0$
	_next 
0$:
	_vars VSIZE
	clrw x  
	ldw (END_ADR,sp),x  
	call arg_list 
	cp a,#2 
	jreq 1$ 
	cp a,#1
	jreq 2$ 
	jp syntax_error 
1$:	; range delete 
	_i16_pop ; val2   
	clr a 
	call search_lineno 
	tnz a ; 0 not found 
	jreq not_a_line 
; this last line to be deleted 
; skip at end of it 
	_strxz acc16 	
	ld a,(2,x) ; line length 
	clrw x 
	ld xl,a 
	addw x,acc16 
	ldw (END_ADR+INT_SIZE,sp),x
2$: 
	_i16_pop ; val1 
	clr a 
	call search_lineno 
	tnz a 
	jreq not_a_line 
	ldw (START_ADR,sp),x 
	ldw x,(END_ADR,sp)
	jrne 4$ 
; END_ADR not set there was no val2 
; skip end of this line for END_ADR 
	ldw x,(START_ADR,sp)
	ld a,(2,x)
	clrw x 
	ld xl,a 
	addw x,(START_ADR,sp)
	ldw (END_ADR,sp),x 
4$: 
	subw x,(START_ADR,sp)
	ldw (DEL_SIZE,sp),x 
	ldw x,progend 
	subw x,(END_ADR,sp)
	_strxz acc16 
	ldw x,(START_ADR,sp)
	ldw (YSAVE,sp),y 
	ldw y,(END_ADR,sp)
	call move 
	_ldxz progend 
	subw x,(DEL_SIZE,sp)
	_strxz progend 
	ldw y,(YSAVE,sp)
	_drop VSIZE
	_next 
not_a_line:
	ld a,#ERR_RANGE 
	jp tb_error 


;-----------------------------
; BASIC: HIMEM = expr 
; set end memory address of
; BASIC program space.
;------------------------------
cmd_himem:
	btjf flags,#FRUN,1$
	_next 
1$: ld a,#REL_EQU_IDX 
	call expect 
	call expression 
	cpw x,lomem  
	jrule bad_value 
	cpw x,#tib  
	jruge bad_value  
	_strxz himem
	jra clear_prog_space  
	_next 
;--------------------------------
; BASIC: LOWMEM = expr 
; set start memory address of 
; BASIC program space. 	
;---------------------------------
cmd_lomem:
	btjf flags,#FRUN,1$
	_next
1$: ld a,#REL_EQU_IDX 
	call expect 
	call expression 
	cpw x,#free_ram 
	jrult bad_value 
	cpw x,himem  
	jruge bad_value 
	_strxz lomem
clear_prog_space: 
	call clear_state 
	_ldxz lomem 
	_strxz progend 
	call free 
	_next 
bad_value:
	ld a,#ERR_RANGE 
	jp tb_error 

free: 
	ldw x,himem 
	subw x,lomem 
	call print_int  
	ldw x,#bytes_free   
	call puts 
	ret 
bytes_free: .asciz "bytes free" 

;-----------------------------
; BASIC: CLS 
; send clear screen command 
; to terminal 
;-----------------------------
cmd_cls:
	call clr_screen
	bres sys_flags,#FSYS_TIMER 
	ldw x,#4 ; give time to terminal
	_strxz timer  
	btjf sys_flags,#FSYS_TIMER,.
	_next 

;-----------------------------
; BASIC: LOCATE line, column 
; set terminal cursor position
;------------------------------
	COL=1 
	LN=COL+INT_SIZE 
cmd_locate:
	call arg_list 
	cp a,#2 
	jreq 1$ 
	jp syntax_error 
1$: 
	_i16_fetch LN
	ld a,xl 
	_i16_fetch COL 
	ld xh,a 
	call set_cursor_pos
	_drop 2*INT_SIZE 
	_next  

;-----------------------------
; BASIC CHAT(line,column) 
; get CHaracter AT line,column 
; from stm8_terminal 
; output:
;   X     character 
;------------------------------
	COL=1 
	LN=COL+INT_SIZE 
func_chat:
	call func_args 
	cp a,#2 
	jreq 1$ 
	jp syntax_error 
1$:
	call save_cursor_pos 
	_i16_fetch LN 
	ld a,xl 
	_i16_fetch COL 
	ld xh,a 
	call set_cursor_pos 
	call get_char_at 
	clrw x 
	ld xl,a 
	_i16_store COL 
	call restore_cursor_pos
	_i16_fetch COL 
	_drop 2*INT_SIZE 
	ret 

;----------------------------
; BASIC: CPOS 
; get terminal cursor position 
;  line=CPOS/256 
;  column=CPOS AND 255 
;-----------------------------
func_cpos:
	call cursor_pos  
	ret 

;------------------------------
; BASIC: RENUM [expr1, epxr2]  
; renumber program lines 
; starting at expr1 step expr2 
;------------------------------
	STEP=1
	START=STEP+2 
	VSIZE=START+1
cmd_renum:
	btjt flags,#FRUN,9$
	call arg_list 
	tnz a 
	jrne 1$
	ldw x,#10 
	pushw x 
	pushw x 
	jra 4$
1$: cp a,#1 
	jrne 2$ 
	ldw x,#10 
	pushw x 
	jra 4$ 
2$:	cp a,#2 
	jreq 4$
	jp syntax_error 
4$:
	call line_to_addr
	popw y
	popw x 
	call renumber ; x=START,Y=STEP 
	call addr_to_line  
9$:	clr (y)
	_next 

;--------------------------
; replace GOTO|GOSUB|THEN 
; line#
; by line address|0x8000
;--------------------------
line_to_addr:
	ldw y,lomem 
0$:	_stryz line.addr 
	addw y,#LINE_HEADER_SIZE
1$:	call scan_for_branch 
	tnzw x 
	jreq 4$ 
	ldw x,(x) ; line # 
	call line_by_addr
	addw y,#2 
	jra 1$ 
4$: ; at end of line 
	incw y 
	cpw y,progend 
	jrmi 0$ 
9$:
	ret 

;-------------------------
; replace line number 
; by line address|0x8000
; input:
;   X    line number 
;   Y    plug address 
;--------------------------
line_by_addr:
	clr a 
	call search_lineno
	tnz a 
	jrne 2$ 
	ld a,#ERR_BAD_BRANCH
	jp tb_error 
2$: ld a,xh 
	or a,#0x80 
	ld xh,a 
	ldw (y),x 
	ret 


;---------------------------
; replace target line address 
; by line number 
;---------------------------
addr_to_line:
	ldw y,lomem 
0$: _stryz line.addr 
	addw y,#LINE_HEADER_SIZE
1$: call scan_for_branch
	tnzw x 
	jreq 4$ 
	ldw x,(x) ; ln_addr|0x8000
	ld a,xh 
	and a,#0x7f 
	ld xh,a ; x=line addr 
	ld a,(x)
	ld (y),a 
	ld a,(1,x)
	ld (1,y),a 
	addw y,#2 
	jra 1$ 
4$: ; at end of line 
	incw y 
	cpw y,progend 
	jrmi 0$ 
9$:	ret 

;------------------------
; renumber program lines 
; input:
;   x   start line 
;   y   step 
;-------------------------
	LN_LEN=1
	STEP=LN_LEN+2
	VSIZE=STEP+1  
renumber:
	_vars VSIZE 
	clr (LN_LEN,sp)
	ldw (STEP,sp),y
	ldw y,lomem 
1$:	ldw (y),x ; first line 
	addw x,(STEP,sp)
	ld a,(2,y)
	ld (LN_LEN+1,sp),a 
	addw y,(LN_LEN,sp)
	cpw y,progend 
	jrmi 1$ 
9$:	_drop VSIZE 
	ret 

;-------------------------
; scan line for 
; GOTO|GOSUB|THEN ln# 
; input:
;    Y   basic pointer 
; output:
;    X   0 | addr GO...
;-------------------------
scan_for_branch:
	clrw x 
0$:	ld a,(y)
	cp a,#EOL_IDX 
	jreq 9$ 
	cp a,#GOTO_IDX
	jreq 8$ 
	cp a,#GOSUB_IDX 
	jreq 8$ 
	cp a,#THEN_IDX
	jrne 1$ 
	ld a,(1,y)
	cp a,#LITW_IDX
	jreq 8$ 
	incw y 
	jra 0$ 
1$: cp a,#DELIM_LAST+1
	jrpl 2$ 
	incw y 
	jra 0$ 
2$: cp a,#LITC_IDX 
	jrne 3$ 
	addw y,#2 
	jra 0$ 
3$: cp a,#SYMB_LAST+1
	jrpl 4$ 
	addw y,#3 
	jra 0$ 
4$: cp a,#BOOL_OP_LAST+1 
	jrpl 5$ 
	incw y 
	jra 0$ 
5$: cp a,#QUOTE_IDX 
	jrne 6$
	call skip_string 
	jra 0$ 
6$: cp a,#REM_IDX 
	jrne 7$ 
	ldw x, line.addr  
	ld a,(2,x)
	clrw x 
	ld xl,a 
	addw x,line.addr 
	decw x 
	ldw y,x 
	clrw x 
	jra 9$ 
7$:	incw y 
	jra 0$ 
8$: addw y,#2 
	ldw x,y ; skip 2 op_codes 
9$:	ret 

;----------------------------
; BASIC: DO 
; introtude DO...UNTIL condition 
; loop 
;------------------------------
	LN_ADR=1
	BPTR=LN_ADR+2 
kword_do:
	pushw y 
	_ldxz line.addr 
	pushw x 
	_next 

;----------------------------------
; BASIC: UNTIL condition 
; control loop of DO..UNTIL 
;----------------------------------
kword_until:
	call condition 
	tnzw x 
	jrne 8$ 
	ldw x,(LN_ADR,sp)
	_strxz line.addr 
	ldw y,(BPTR,sp)
	_next 
8$:	_drop 4 
	_next 

;------------------------------
;      dictionary 
; format:
;   link:   2 bytes 
;   name_length+flags:  1 byte, bits 0:3 lenght,4:8 kw type   
;   cmd_name: 16 byte max 
;   code_addr: 2 bytes 
;------------------------------
	.macro _dict_entry len,name,token_id 
	.word LINK  ; point to next name field 
	LINK=.  ; name field 
	.byte len  ; name length 
	.asciz name  ; name 
	.byte token_id   ; TOK_IDX 
	.endm 

	LINK=0
; respect alphabetic order for BASIC names from Z-A
; this sort order is for a cleaner WORDS cmd output. 	
dict_end:
	_dict_entry,5,"WORDS",WORDS_IDX 
	_dict_entry,5,"UNTIL",UNTIL_IDX 
	_dict_entry,4,"TONE",TONE_IDX 
	_dict_entry,2,"TO",TO_IDX
	_dict_entry,5,"TICKS",TICKS_IDX 
	_dict_entry,4,"THEN",THEN_IDX 
	_dict_entry,3,"TAB",TAB_IDX 
	_dict_entry,4,"STOP",STOP_IDX
	_dict_entry,4,"STEP",STEP_IDX
	_dict_entry,5,"SLEEP",SLEEP_IDX 
	_dict_entry,3,"SGN",SGN_IDX
	_dict_entry,3,"SCR",NEW_IDX
	_dict_entry,4,"SAVE",SAVE_IDX 
	_dict_entry 3,"RUN",RUN_IDX
	_dict_entry,3,"RND",RND_IDX
	_dict_entry,9,"RANDOMIZE",RNDMIZE_IDX 
	_dict_entry,6,"RETURN",RET_IDX
	_dict_entry,5,"RENUM",RENUM_IDX 
	_dict_entry 3,"REM",REM_IDX
	_dict_entry 5,"PRINT",PRINT_IDX 
	_dict_entry,4,"POKE",POKE_IDX 
	_dict_entry,4,"PEEK",PEEK_IDX 
	_dict_entry,2,"OR",OR_IDX  
	_dict_entry,3,"NOT",NOT_IDX
	_dict_entry,3,"NEW",NEW_IDX
	_dict_entry,4,"NEXT",NEXT_IDX 
	_dict_entry,6,"MULDIV",MULDIV_IDX 
	_dict_entry,3,"MOD",MOD_IDX 
	_dict_entry,5,"LOMEM",LOMEM_IDX 
	_dict_entry,6,"LOCATE",LOCATE_IDX 
	_dict_entry,4,"LOAD",LOAD_IDX 
	_dict_entry 4,"LIST",LIST_IDX
	_dict_entry 3,"LET",LET_IDX
	_dict_entry 3,"LEN",LEN_IDX  
	_dict_entry,3,"KEY",KEY_IDX 
	_dict_entry,5,"INPUT",INPUT_IDX 
	_dict_entry,2,"IF",IF_IDX 
	_dict_entry,5,"HIMEM",HIMEM_IDX 
	_dict_entry,4,"GOTO",GOTO_IDX  
	_dict_entry,5,"GOSUB",GOSUB_IDX 
	_dict_entry,5,"ERASE",ERASE_IDX 
	_dict_entry,3,"FOR",FOR_IDX 
	_dict_entry,3,"END",END_IDX
	_dict_entry,2,"DO",DO_IDX 
	_dict_entry,3,"DIR",DIR_IDX  
	_dict_entry,3,"DIM",DIM_IDX 
	_dict_entry,3,"DEL",DEL_IDX 
	_dict_entry,4,"CPOS",CPOS_IDX 
	_dict_entry,3,"CON",CON_IDX 
	_dict_entry,3,"CLS",CLS_IDX 
	_dict_entry,3,"CLR",CLR_IDX 
	_dict_entry,4,"CHR$",CHAR_IDX  
	_dict_entry,4,"CHAT",CHAT_IDX 
	_dict_entry,4,"CALL",CALL_IDX
	_dict_entry,3,"BYE",BYE_IDX
	_dict_entry,4,"AUTO",AUTO_IDX 
	_dict_entry,3,"AND",AND_IDX  
kword_dict::
	_dict_entry,3,"ABS",ABS_IDX 
; the following are not searched
; by compiler
	_dict_entry,1,"'",REM_IDX 
	_dict_entry,1,"?",PRINT_IDX 
	_dict_entry,1,"#",REL_NE_IDX 
	_dict_entry,2,"<>",REL_NE_IDX
	_dict_entry,1,">",REL_GT_IDX
	_dict_entry,1,"<",REL_LT_IDX
	_dict_entry,2,">=",REL_GE_IDX
	_dict_entry,1,"=",REL_EQU_IDX 
	_dict_entry,2,"<=",REL_LE_IDX 
	_dict_entry,1,"*",MULT_IDX 
	_dict_entry,1,"%",MOD_IDX 
	_dict_entry,1,"/",DIV_IDX 
	_dict_entry,1,"-",SUB_IDX 
	_dict_entry,1,"+",ADD_IDX
	_dict_entry,1,'"',QUOTE_IDX
	_dict_entry,1,")",RPAREN_IDX 
	_dict_entry,1,"(",LPAREN_IDX 
	_dict_entry,1,^/";"/,SCOL_IDX
	_dict_entry,1,^/","/,COMMA_IDX 
all_words:
	_dict_entry,1,":",COLON_IDX 

	.bndry 128 
app: 
app_space:
.if 0
; program to test CALL command 
blink:
	_led_toggle 
	ldw x,#250 
	_strxz timer 
	bres sys_flags,#FSYS_TIMER 
1$:	
	wfi 
	btjf sys_flags,#FSYS_TIMER,1$
	call qgetc 
	jreq blink 
	call getc 
	ret 
.endif 
