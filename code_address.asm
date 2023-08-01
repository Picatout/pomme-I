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

.if SEPARATE 
    .module PROC_TABLE 
    .include "config.inc"

    .area CODE 
.endif 



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  table of code routines 
;; used by virtual machine 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.macro _code_entry proc_address,token_name    
	.word proc_address
	token_name =TOK_IDX 
	TOK_IDX=TOK_IDX+1 
	.endm 

	TOK_IDX=0
code_addr:
; command end marker  
	_code_entry next_line, EOL_IDX  ; $0 
	_code_entry do_nothing, COLON_IDX   ; $1 ':'
    CMD_END = TOK_IDX-1 
; caractères délimiteurs 
    _code_entry syntax_error, COMMA_IDX ; $2  ',' 
	_code_entry syntax_error,SCOL_IDX  ; $3 ';' 
	_code_entry syntax_error, LPAREN_IDX ; $4 '(' 
	_code_entry syntax_error, RPAREN_IDX ; $5 ')' 
	_code_entry syntax_error, QUOTE_IDX  ; $6 '"' 
    DELIM_LAST=TOK_IDX-1 
; literal values 
    _code_entry syntax_error,LITC_IDX ; 8 bit literal 
    _code_entry syntax_error,LITW_IDX  ; 16 bits literal 
    LIT_LAST=TOK_IDX-1 
; variable identifiers  
	_code_entry kword_let2,VAR_IDX    ; $9 integer variable  
	_code_entry let_string2,STR_VAR_IDX  ; string variable 
    SYMB_LAST=TOK_IDX-1 
; arithmetic operators      
	_code_entry syntax_error, ADD_IDX   ; $D 
	_code_entry syntax_error, SUB_IDX   ; $E
	_code_entry syntax_error, DIV_IDX   ; $10 
	_code_entry syntax_error, MOD_IDX   ; $11
	_code_entry syntax_error, MULT_IDX  ; $12 
    OP_ARITHM_LAST=TOK_IDX-1 
; relational operators
	_code_entry syntax_error,REL_LE_IDX  ; 
	_code_entry syntax_error,REL_EQU_IDX ; 
	_code_entry syntax_error,REL_GE_IDX  ;  
	_code_entry syntax_error,REL_LT_IDX  ;  
	_code_entry syntax_error,REL_GT_IDX  ;  
	_code_entry syntax_error,REL_NE_IDX  ; 
    OP_REL_LAST=TOK_IDX-1 
; boolean operators 
    _code_entry syntax_error, NOT_IDX    ; $19
    _code_entry syntax_error, AND_IDX    ; $1A 
    _code_entry syntax_error, OR_IDX     ; $1B 
    BOOL_OP_LAST=TOK_IDX-1 
; keywords 
    _code_entry kword_dim, DIM_IDX       ; $1F 
    _code_entry kword_end, END_IDX       ; $21 
    _code_entry kword_for, FOR_IDX       ; $22
    _code_entry kword_next, NEXT_IDX     ; $27 
    _code_entry kword_gosub, GOSUB_IDX   ; $23 
    _code_entry kword_return, RET_IDX    ; $2A
    _code_entry kword_goto, GOTO_IDX     ; $24 
    _code_entry kword_if, IF_IDX         ; $25 
    _code_entry syntax_error,THEN_IDX 
    _code_entry kword_let, LET_IDX       ; $26 
	_code_entry kword_remark, REM_IDX    ; $29 
    _code_entry syntax_error, STEP_IDX   ; $2B 
    _code_entry kword_stop, STOP_IDX     ; $2C
    _code_entry kword_con, CON_IDX 
    _code_entry syntax_error, TO_IDX     ; $2D
    KWORD_LAST=TOK_IDX-1 
; functions
	_code_entry func_abs, ABS_IDX         ; $41
    _code_entry func_peek, PEEK_IDX         ; $4D 
    _code_entry func_random, RND_IDX        ; $50
    _code_entry func_sign, SGN_IDX 
    _code_entry func_len, LEN_IDX  
    _code_entry func_ticks, TICKS_IDX 
    _code_entry func_char, CHAR_IDX
    _code_entry func_key, KEY_IDX  
    _code_entry func_chat,CHAT_IDX  
    FUNC_LAST=TOK_IDX-1                     
; commands 
    _code_entry cmd_sleep,SLEEP_IDX 
    _code_entry cmd_tone,TONE_IDX 
    _code_entry cmd_tab, TAB_IDX 
    _code_entry cmd_auto, AUTO_IDX 
    _code_entry cmd_himem, HIMEM_IDX 
    _code_entry cmd_lomem, LOMEM_IDX 
    _code_entry cmd_del, DEL_IDX 
    _code_entry cmd_clear, CLR_IDX 
    _code_entry cmd_input, INPUT_IDX    ; $6F
    _code_entry cmd_list, LIST_IDX          ; $72
    _code_entry cmd_new, NEW_IDX            ; $73
    _code_entry cmd_call, CALL_IDX          
    _code_entry cmd_poke, POKE_IDX          ; $76
   	_code_entry cmd_print, PRINT_IDX        ; $77
    _code_entry cmd_run, RUN_IDX            ; $7A
    _code_entry cmd_words, WORDS_IDX        ; $85
    _code_entry cmd_bye, BYE_IDX 
    _code_entry cmd_save, SAVE_IDX 
    _code_entry cmd_load,LOAD_IDX 
    _code_entry cmd_dir, DIR_IDX 
    _code_entry cmd_erase, ERASE_IDX 
    _code_entry cmd_randomize, RNDMIZE_IDX
    _code_entry cmd_cls, CLS_IDX 
    _code_entry cmd_locate,LOCATE_IDX
    CMD_LAST=TOK_IDX-1
