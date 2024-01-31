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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   compile BASIC source code to byte code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.area CODE 

;-------------------------------------
; search text area for a line#
; input:
;   A           0 search from lomem  
;			    1 search from line.addr 
;	X 			line# to search 
; output:
;   A           0 not found | other found 
;   X 			addr of line | 
;				inssert address if not found  
; use: 
;   Y  
;-------------------------------------
	LL=1 ; line length 
	LB=2 ; line length low byte 
	VSIZE=2 
search_lineno::
	pushw y 
	_vars VSIZE
	clr (LL,sp)
	ldw y,lomem
	tnz a 
	jreq 2$
	ldw y,line.addr  
2$: 
	cpw y,progend 
	jrpl 8$ 
	cpw x,(y)
	jreq 9$
	jrmi 8$ 
	ld a,(2,y)
	ld (LB,sp),a 
	addw y,(LL,sp)
	jra 2$ 
8$: ; not found 
	clr a 
	jra 10$
9$: ; found 
	ld a,#-1 
10$:
	ldw x,y   
	_drop VSIZE
	popw y 
	ret 


;-------------------------------------
; delete line at addr
; input:
;   X 		addr of line i.e DEST for move 
;-------------------------------------
	LLEN=1
	SRC=3
	VSIZE=4
del_line: 
	pushw y 
	_vars VSIZE 
	ld a,(2,x) ; line length
	ld (LLEN+1,sp),a 
	clr (LLEN,sp)
	ldw y,x  
	addw y,(LLEN,sp) ;SRC  
	ldw (SRC,sp),y  ;save source 
	ldw y,progend 
	subw y,(SRC,sp) ; y=count 
	ldw acc16,y 
	ldw y,(SRC,sp)    ; source
	call move
	ldw y,progend  
	subw y,(LLEN,sp)
	ldw progend,y
	ldw dvar_bgn,y 
	ldw dvar_end,y   
	_drop VSIZE     
	popw y 
	ret 

;---------------------------------------------
; open a gap in text area to 
; move new line in this gap
; input:
;    X 			addr gap start 
;    Y 			gap length 
; output:
;    X 			addr gap start 
;--------------------------------------------
	DEST=1
	SRC=3
	LEN=5
	VSIZE=6 
open_gap:
	cpw x,progend 
	jruge 9$
	_vars VSIZE
	ldw (SRC,sp),x 
	ldw (LEN,sp),y 
	ldw acc16,y 
	ldw y,x ; SRC
	addw x,acc16  
	ldw (DEST,sp),x 
;compute size to move 	
	_ldxz progend  
	subw x,(SRC,sp)
	ldw acc16,x ; size to move
	ldw x,(DEST,sp) 
	call move
	_ldxz progend 
	addw x,(LEN,sp)
	ldw progend,x
	ldw dvar_bgn,x 
	ldw dvar_end,x 
	_drop VSIZE
9$:	ret 

;--------------------------------------------
; insert line in pad into program area 
; first search for already existing 
; replace existing 
; if new line empty delete existing one. 
; input:
;   ptr16		pointer to tokenized line  
; output:
;   none
;---------------------------------------------
	DEST=1  ; text area insertion address 
	SRC=3   ; str to insert address 
	LINENO=5 ; line number 
	LLEN=7 ; line length 
	VSIZE=8  
insert_line:
	pushw y 
	_vars VSIZE 
	ldw x,[ptr16]
	ldw (LINENO,sp),x 
	clr (LLEN,sp)
	_ldxz ptr16 
	ld a,(2,x)
	ld (LLEN+1,sp),a 
	clr a 
	ldw x,(LINENO,sp)
	call search_lineno
	ldw (DEST,sp),x 
	tnz a 
	jreq 1$ ; not found 
	call del_line 
1$: ld a,#4 
	cp a,(LLEN+1,sp)
	jreq 9$
; check for space 
	_ldxz progend  
	addw x,(LLEN,sp)
	cpw x,#tib   
	jrult 3$
	ldw x,#err_mem_full 
	jp tb_error 
	jra 9$  
3$: ; create gap to insert line 
	ldw x,(DEST,sp) 
	ldw y,(LLEN,sp)
	call open_gap 
; move new line in gap 
	ldw x,(LLEN,sp)
	ldw acc16,x 
	ldw y,#pad ;SRC 
	ldw x,(DEST,sp) ; dest address 
	call move
	ldw x,(DEST,sp)
	cpw x,progend 
	jrult 9$ 
	ldw x,(LLEN,sp)
	addw x,progend 
	ldw progend,x 
	ldw dvar_bgn,x 
	ldw dvar_end,x 
9$:	
	_drop VSIZE
	popw y 
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; compiler routines        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;------------------------------------
; parse quoted string 
; input:
;   Y 	pointer to tib 
;   X   pointer to output buffer 
; output:
;	buffer   parsed string
;------------------------------------
	PREV = 1
	CURR =2
	VSIZE=2
parse_quote: 
	_vars VSIZE
	_push_op  
	clr a
1$:	ld (PREV,sp),a 
2$:	
	ld a,([in.w],y)
	jreq 6$
	_incz in 
	ld (CURR,sp),a 
	ld a,#'\
	cp a, (PREV,sp)
	jrne 3$
	clr (PREV,sp)
	ld a,(CURR,sp)
	callr convert_escape
	ld (x),a 
	incw x 
	jra 2$
3$:
	ld a,(CURR,sp)
	cp a,#'\'
	jreq 1$
	cp a,#'"
	jreq 5$ 
	ld (x),a 
	incw x 
	jra 2$
5$: _pop_op 	
6$: 
	clr (x)
	incw x 
	ldw y,x 
	clrw x 
	ld a,#QUOTE_IDX  
	_drop VSIZE
	ret 

;---------------------------------------
; called by parse_quote
; subtitute escaped character 
; by their ASCII value .
; input:
;   A  character following '\'
; output:
;   A  substitued char or same if not valid.
;---------------------------------------
convert_escape:
	pushw x 
	ldw x,#escaped 
1$:	cp a,(x)
	jreq 2$
	tnz (x)
	jreq 3$
	incw x 
	jra 1$
2$: subw x,#escaped 
	ld a,xl 
	add a,#7
3$:	popw x 
	ret 

escaped:: .asciz "abtnvfr"

;-------------------------
; integer parser 
; input:
;   X      *output buffer (&pad[n])
;   Y 		point to tib 
;   in.w    offset in tib 
;   A 	    first digit|'$' 
; output:  
;   X 		int16   
;   acc16   int16 
;   in.w    updated 
;   Y       pad[n] 
;-------------------------
parse_integer: ; { -- n }
	pushw x 
	addw y,in.w
	decw y   
	call atoi16 
	subw y,#tib 
	ldw in.w,y
	popw y  
	ret

;-------------------------------------
; input:
;   X  int16  
;   Y    pad[n]
; output:
;    pad   LITW_IDX,word  
;    y     &pad[n+3]
;------------------------------------
compile_integer:
	ld a,#LITW_IDX 
	ld (y),a
	incw y 
	LDW (Y),x 
	addw y,#2
	ret

;---------------------------
;  when lexical unit begin 
;  with a letter a symbol 
;  is expected.
; input:
;   A   first character of symbol 
;	X   point to output buffer 
;   [in.w],Y   point to input text 
; output:
;   A   string length 
;   [in.w],Y   point after lexical unit 
;---------------------------
	FIRST_CHAR=1
	VSIZE=2 
parse_symbol:
	_vars VSIZE 
	addw x,#1 ; keep space for token identifier
	ldw (FIRST_CHAR,sp),x  
symb_loop: 
	call to_upper 
	ld (x), a 
	incw x
	ld a,([in.w],y)
	_incz in 
	cp a,#'$ 
	jreq 2$ ; string variable: LETTER+'$'  
	call is_digit ;
	jrnc 3$ ; integer variable LETTER+DIGIT 
2$:
	ld (x),a 
	incw x 
	jra 4$
3$:
	call is_alpha  
	jrc symb_loop 
	_decz in
4$:
	clr (x)
	subw x,(FIRST_CHAR,sp)
	ld a,xl
	_drop VSIZE 
	ret 

;---------------------------------
; some syntax checking 
; can be done at compile time
; matching '(' and ')' 
; FOR TO STEP must be on same line 
; same for IF THEN 
;--------------------------------
check_syntax:
	cp a,#RPAREN_IDX
	jrne 0$
	_pop_op 
	cp a,#LPAREN_IDX 
	jreq 9$ 
	jp syntax_error 
0$: 
	cp a,#IF_IDX 
	jreq push_it 
	cp a,#FOR_IDX 
	jreq push_it 
	cp a,#THEN_IDX 
	jrne 1$
	_pop_op 
	cp a,#IF_IDX 
	jreq 9$ 
	jp syntax_error 
1$: 
	cp a,#TO_IDX 
	jrne 3$ 
	_pop_op 
	cp a,#FOR_IDX 
	jreq 2$ 
	jp syntax_error 
2$: ld a,#TO_IDX 
	_push_op 
	jra 9$ 
3$: cp a,#STEP_IDX 
	jrne 9$ 
	_pop_op 
	cp a,#TO_IDX 
	jreq 9$ 
	jp syntax_error 
9$:	
	ret 
push_it:
	_push_op 
	ret 

;---------------------------
;  token begin with a letter,
;  is keyword or variable. 	
; input:
;   X 		point to pad 
;   Y 		point to text
;   A 	    first letter  
; output:
;   Y		point in pad after token  
;   A 		token identifier
;   pad 	keyword|var_name  
;--------------------------  
	TOK_POS=1
	NLEN=TOK_POS+2
	VSIZE=NLEN 
parse_keyword:
	_vars VSIZE 
	clr (NLEN,sp)
	ldw (TOK_POS,sp),x  ; where TOK_IDX should be put 
	call parse_symbol
	ld (NLEN,sp),a 
	cp a,#1
	jreq 3$  
 ; check in dictionary, if not found must be variable name.
	_ldx_dict kword_dict ; dictionary entry point
	ldw y,(TOK_POS,sp) ; name to search for
	addw y,#1 ; name first character 
	call search_dict
	cp a,#NONE_IDX 
	jrne 6$
; not in dictionary
; either LETTER+'$' || LETTER+DIGIT 
	ld a,#2 
	cp a,(NLEN,sp)
	jreq 1$ 
    jp syntax_error 	
1$: ; 2 letters variables 
	ldw y,(TOK_POS,sp)
	ldw x,y 
	addw x,#2 
	ld a,(x)
	cp a,#'$ 
	jrne 2$ 
	ld a,#STR_VAR_IDX
	jra 5$
2$:	call is_digit 
	jrc 4$ ; LETTER+DIGIT 
	jp syntax_error 
3$:
; one letter symbol is integer variable name 
; tokenize as: VAR_IDX,LETTER,NUL  
	ldw y,(TOK_POS,sp)
4$:	
	ld a,#VAR_IDX 
5$:
	ld (y),a
	addw y,#3
	jra 9$
6$:	; word in dictionary 
	ldw y,(TOK_POS,sp)
	ld (y),a ; compile token 
	incw y
	call check_syntax  
9$:	_drop VSIZE 
	ret  	

;------------------------------------
; skip character c in text starting from 'in'
; input:
;	 y 		point to text buffer
;    a 		character to skip
; output:  
;	'in' ajusted to new position
;------------------------------------
	C = 1 ; local var
skip:
	push a
1$:	ld a,([in.w],y)
	jreq 2$
	cp a,(C,sp)
	jrne 2$
	_incz in
	jra 1$
2$: _drop 1 
	ret
	

;------------------------------------
; scan text for next lexeme
; compile its TOKEN_IDX and value
; in output buffer.  
; update input and output pointers 
; input: 
;	X 		pointer to buffer where 
;	        token idx and value are compiled 
; use:
;	Y       pointer to text in tib 
;   in.w    offset in tib, i.e. tib[in.w]
; output:
;   A       token index  
;   Y       updated position in output buffer   
;------------------------------------
	; use to check special character 
	.macro _case c t  
	ld a,#c 
	cp a,(TCHAR,sp) 
	jrne t
	.endm 
	
; local variables 
	TCHAR=1 ; parsed character 
	ATTRIB=2 ; token value  
	VSIZE=2
parse_lexeme:
	_vars VSIZE
	ldw y,#tib    	
	ld a,#SPACE
	call skip
	ld a,([in.w],y)
	jrne 1$
	ldw y,x 
	jp token_exit ; end of line 
1$:	_incz in 
	ld (TCHAR,sp),a ; first char of lexeme 
; check for quoted string
str_tst:  	
	_case '"' nbr_tst
	ld a,#QUOTE_IDX
	push a 
	ld (x),a ; compile TOKEN INDEX 
	incw x 
	call parse_quote ; compile quoted string 
	pop a 
	jp token_exit
nbr_tst:
; check for hexadecimal number 
	_case '$' digit_test 
	jra integer 
; check for decimal number 	
digit_test: 
	ld a,(TCHAR,sp)
	call is_digit
	jrnc other_tests
integer: 
	call parse_integer 
	call compile_integer
	jp token_exit 
other_tests: 
	_case '(' bkslsh_tst 
	ld a,#LPAREN_IDX 
	_push_op 
	jp token_char   	
bkslsh_tst: ; character token 
	_case '\',rparnt_tst
	ld a,#LITC_IDX 
	ld (x),a 
	push a 
	incw x 
	ld a,([in.w],y)
	_incz in  
	ld (x),a 
	incw x
	ldw y,x 
	pop a 	 
	jp token_exit
rparnt_tst:		
	_case ')' colon_tst 
	ld a,#RPAREN_IDX  
	call check_syntax 
	ld a,#RPAREN_IDX
	jp token_char
colon_tst:
	_case ':' comma_tst 
	ld a,#COLON_IDX  
	jp token_char  
comma_tst:
	_case COMMA semic_tst 
	ld a,#COMMA_IDX 
	jp token_char
semic_tst:
	_case SEMIC dash_tst
	ld a,#SCOL_IDX  
	jp token_char 	
dash_tst: 	
	_case '-' sharp_tst 
	ld a,#SUB_IDX  
	jp token_char 
sharp_tst:
	_case '#' qmark_tst 
	ld a,#REL_NE_IDX  
	jp token_char
qmark_tst:
	_case '?' tick_tst 
	ld a,#PRINT_IDX   
	ld (x),a 
	incw x 
	ldw y,x 
	jp token_exit
tick_tst: ; comment 
	_case TICK plus_tst 
	ld a,#REM_IDX 
	ld (x),a 
	incw x
copy_comment:
	ldw y,#tib 
	addw y,in.w
	pushw y 
	call strcpy
	subw y,(1,sp)
	incw y ; strlen+1
	pushw y  
	addw x,(1,sp) 
	ldw y,x 
	popw x 
	addw x,(1,sp)
	decw x 
	subw x,#tib 
	ldw in.w,x 
	_drop 2 
	ld a,#REM_IDX
	jp token_exit 
plus_tst:
	_case '+' star_tst 
	ld a,#ADD_IDX  
	jp token_char 
star_tst:
	_case '*' slash_tst 
	ld a,#MULT_IDX  
	jp token_char 
slash_tst: 
	_case '/' prcnt_tst 
	ld a,#DIV_IDX  
	jp token_char 
prcnt_tst:
	_case '%' eql_tst 
	ld a,#MOD_IDX 
	jp token_char  
; 1 or 2 character tokens 	
eql_tst:
	_case '=' gt_tst 		
	ld a,#REL_EQU_IDX 
	jp token_char 
gt_tst:
	_case '>' lt_tst 
	ld a,#REL_GT_IDX 
	ld (ATTRIB,sp),a 
	ld a,([in.w],y)
	_incz in 
	cp a,#'=
	jrne 1$
	ld a,#REL_GE_IDX  
	jra token_char  
1$: cp a,#'<
	jrne 2$
	ld a,#REL_NE_IDX  
	jra token_char 
2$: dec in
	ld a,(ATTRIB,sp)
	jra token_char 	 
lt_tst:
	_case '<' other
	ld a,#REL_LT_IDX  
	ld (ATTRIB,sp),a 
	ld a,([in.w],y)
	_incz in 
	cp a,#'=
	jrne 1$
	ld a,#REL_LE_IDX 
	jra token_char 
1$: cp a,#'>
	jrne 2$
	ld a,#REL_NE_IDX  
	jra token_char 
2$: dec in 
	ld a,(ATTRIB,sp)
	jra token_char 	
other: ; not a special character 	 
	ld a,(TCHAR,sp)
	call is_alpha 
	jrc 30$ 
	jp syntax_error 
30$: 
	call parse_keyword
	cp a,#REM_IDX  
	jrne token_exit   
	ldw x,y 
	jp copy_comment
token_char:
	ld (x),a 
	incw x
	ldw y,x 
token_exit:
	_drop VSIZE 
	ret


;-----------------------------------
; create token list fromm text line 
; save this list in pad buffer 
;  compiled line format: 
;    line_no  2 bytes {0...32767}
;    line length    1 byte  
;    tokens list  variable length 
;   
; input:
;   none
; used variables:
;   in.w  		 3|count, i.e. index in buffer
;   count        length of line | 0  
;   basicptr    
;   pad buffer   compiled BASIC line  
;
; If there is a line number copy pad 
; in program space. 
;-----------------------------------
	XSAVE=1
	VSIZE=2
compile::
	_vars VSIZE 
	mov basicptr,lomem
	bset flags,#FCOMP 
	_rst_pending
	clr a 
	clrw x
	ldw pad,x ; line# in destination buffer 
	ld pad+2,a ; line length  
	_clrz in.w 
	_clrz in  ; offset in input text buffer 
	ld a,tib 
	call is_digit
	jrnc 1$ 
	_incz in 
	ldw x,#pad+3
	ldw y,#tib   
	call parse_integer 
	cpw x,#1
	jrslt 0$
	ldw pad,x 
	jra 1$ 
0$:	ld a,#ERR_SYNTAX 
	jp tb_error
1$:	 
	ldw y,#pad+3 
2$:	cpw y,#stack_full 
	jrult 3$
	ld a,#ERR_MEM_FULL 
	jp tb_error 
3$:	
	ldw x,y 
	call parse_lexeme 
	tnz a 
	jrne 2$ 
; compilation completed  
	_pending_empty 
	jreq 4$
	_pop_op 
	cp a,#TO_IDX 
	jreq 4$ 
	jp syntax_error 
4$:
	clr (y)
	incw y 
	subw y,#pad ; compiled line length 
    ld a,yl
	ldw x,#pad 
	_strxz ptr16 
	ld (2,x),a 
	ldw x,(x)  ; line# 
	jreq 10$
	call insert_line ; in program space 
	_clrz  count
	clr  a ; not immediate command  
	jra  11$ 
10$: ; line# is zero 
; for immediate execution from pad buffer.
	_ldxz ptr16  
	ld a,(2,x)
	_straz count
	_strxz line.addr
	addw x,#LINE_HEADER_SIZE
	_strxz basicptr
	ldw y,x
11$:
	_drop VSIZE 
	bres flags,#FCOMP 
	ret 
