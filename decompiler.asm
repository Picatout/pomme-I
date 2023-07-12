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

;---------------------------------------
;  decompiler
;  decompile bytecode to text source
;  used by command LIST
;---------------------------------------

.if SEPARATE 
    .module DECOMPILER 
    .include "config.inc"

    .area CODE 
.endif 

;--------------------------
;  align text in buffer 
;  by  padding left  
;  with  SPACE 
; input:
;   X      str*
;   A      width  
; output:
;   A      strlen
;   X      ajusted
;--------------------------
	WIDTH=1 ; column width 
	SLEN=2  ; string length 
	VSIZE=2 
right_align::
	_vars VSIZE 
	ld (WIDTH,sp),a 
	call strlen 
0$:	ld (SLEN,sp),a  
	cp a,(WIDTH,sp) 
	jrpl 1$
	decw x
	ld a,#SPACE 
	ld (x),a  
	ld a,(SLEN,sp)
	inc a 
	jra 0$ 
1$: ld a,(SLEN,sp)	
	_drop VSIZE 
	ret 

;--------------------------
; print quoted string 
; converting control character
; to backslash sequence
; input:
;   X        char *
;-----------------------------
prt_quote:
	ld a,#'"
	call putc 
	pushw y 
	call skip_string 
	popw x  
1$:	ld a,(x)
	incw x 
	dec count 
	tnz a 
	jreq 9$ 
	cp a,#SPACE 
	jrult 3$
	call putc 
	cp a,#'\ 
	jrne 1$ 
2$:
	call putc 
	jra 1$
3$: push a 
	ld a,#'\
	call putc  
	pop a 
	sub a,#7
	_straz acc8 
	clr acc16
	pushw x
	ldw x,#escaped 
	addw x,acc16 
	ld a,(x)
	call putc 
	popw x
	jra 1$
9$:
	ld a,#'"
	call putc  
	ret

;--------------------------
; print variable name  
; input:
;   X    variable name
; output:
;   none 
;--------------------------
prt_var_name:
	ld a,xh 
	and a,#0x7f 
	call putc 
	ld a,xl 
	call putc 
	ret 

;----------------------------------
; search name in dictionary
; from its token index  
; input:
;   a       	token index   
; output:
;   A           token index | 0 
;   X 			*name  | 0 
;--------------------------------
	TOKEN=1  ; TOK_IDX 
	NFIELD=TOKEN+1 ; NAME FIELD 
	SKIP=NFIELD+2 
	VSIZE=SKIP+1 
tok_to_name:
	_vars VSIZE 
	clr (SKIP,sp) 
	ld (TOKEN,sp),a 
	ldw x, #all_words+2 ; name field 	
1$:	ldw (NFIELD,sp),x
	ld a,(x)
	add a,#2 
	ld (SKIP+1,sp),a 
	addw x,(SKIP,sp)
	ld a,(x) ; TOK_IDX     
	cp a,(TOKEN,sp)
	jreq 2$
	ldw x,(NFIELD,sp) ; name field 
	subw x,#2 ; link field 
	ldw x,(x) 
	jrne 1$
	clr a 
	jra 9$
2$: ldw x,(NFIELD,sp)
	incw x 
9$:	_drop VSIZE
	ret

;-------------------------------------
; decompile tokens list 
; to original text line 
; input:
;   A      0 don't align line number 
;          !0 align it. 
;   line.addr start of line 
;   Y,basicptr  at first token 
;   count     stop position.
;------------------------------------
	PSTR=1     ;  1 word 
	ALIGN=3
	LAST_BC=4
	VSIZE=4
decompile::
	push base 
	mov base,#10
	_vars VSIZE
	ld (ALIGN,sp),a 
	_ldxz line.addr
	ldw x,(x)
	clr a ; unsigned conversion  
	call itoa
	tnz (ALIGN,sp)
	jreq 1$  
	ld a,#5 
	call right_align 
1$:	call puts 
	call space
	_ldyz basicptr
decomp_loop:
	_ldaz count 
	jrne 0$
	jp decomp_exit 
0$:	
	dec count 
	_next_token
	tnz a 
	jrne 1$
	jp decomp_exit   
1$:	cp a,#QUOTE_IDX 
	jrne 2$
	jp quoted_string 
2$:	cp a,#VAR_IDX 
	jrne 3$
	jp variable 
3$:	cp a,#REM_IDX 
	jrne 4$
	jp comment 
4$:	
	cp a,#STR_VAR_IDX 
	jrne 5$
	jp variable 
5$:	cp a,#LITC_IDX 
	jrne 6$ 
	ld a,#'\ 
	call putc 
	_get_char 
	_decz count 
	call putc 
	jra prt_space 
6$:	cp a,#LITW_IDX 
	jrne 7$
	jra lit_word
7$:	
; print command,funcion or operator 	 
	ld (LAST_BC,sp),a
	call tok_to_name 
	tnz a 
	jrne 9$
	jp decomp_exit
9$:	
	call strlen 
	cp a,#2 
	jrpl 10$
	ld a,(x)
	call putc 
	jra decomp_loop 
10$:
	call puts
prt_space:
	call space 
	jra decomp_loop
; print variable name 	
variable: ; VAR_IDX 
	ld a,(y)
	and a,#127 
	call putc 
	ld a,(1,y) 
	call putc 
	dec count 
	dec count   
	addw y,#2
	jra prt_space
; print literal integer  
lit_word: ; LITW_IDX 
	_get_word
	tnzw x 
	jrpl 1$
	ld a,(LAST_BC,sp)
	cp a,#GOSUB_IDX 
	jrmi 1$ 
	cp a,#GOTO_IDX 
	jrugt 1$ 
	subw x,#0x8000
	addw x,lomem
	pushw y 
	ldw x,(x)
	ldw y,x ; line #
	ldw x,(1,sp) ; basicptr
	subw x,#2 ; 
	ldw (x),y
	ldw x,y   
	popw y 
1$:	 
	call print_int 
	jra prt_space 	
; print comment	
comment: ; REM_IDX 
	ld a,#''
	call putc
	ldw x,y
	call puts 
	jp decomp_exit 
; print quoted string 	
quoted_string:	
	call prt_quote  
	jp prt_space
; print \letter 	
.if 0
letter: 
	ld a,#'\ 
	call putc 
	_get_char 
	dec count   
	call putc  
	jp prt_space 
.endif 
decomp_exit: 
	call new_line 
	_drop VSIZE 
	pop base 
	ret 

