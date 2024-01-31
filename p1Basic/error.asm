;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   pomme BASIC error messages 
;;   addresses indexed table 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	; macro to create err_msg table 
	.macro _err_entry msg_addr, error_code 
	.word msg_addr  
	error_code==ERR_IDX 
	ERR_IDX=ERR_IDX+1
	.endm 

	ERR_IDX=0

; array of pointers to 
; error_messages strings table.	
err_msg_idx:  

	_err_entry 0,ERR_NONE 
	_err_entry err_syntax,ERR_SYNTAX 
	_err_entry err_gt32767,ERR_GT32767 
	_err_entry err_gt255,ERR_GT255 
	_err_entry err_bad_branch,ERR_BAD_BRANCH 
	_err_entry err_bad_return,ERR_BAD_RETURN 
	_err_entry err_bad_next,ERR_BAD_NEXT 
	_err_entry err_gt8_gosub,ERR_GOSUBS 
	_err_entry err_gt8_fors, ERR_FORS 
	_err_entry err_end, ERR_END 
	_err_entry err_mem_full, ERR_MEM_FULL
	_err_entry err_too_long, ERR_TOO_LONG 
	_err_entry err_dim, ERR_DIM 
	_err_entry err_range, ERR_RANGE 
	_err_entry err_str_ovfl, ERR_STR_OVFL 
	_err_entry err_string, ERR_STRING 
	_err_entry err_retype, ERR_RETYPE 
	_err_entry err_prog_only, ERR_PROG_ONLY  
	_err_entry err_div0, ERR_DIV0 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; error messages strings table 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
error_messages: 

err_syntax: .asciz "SYNTAX"
err_gt32767: .asciz ">32767" 
err_gt255: .asciz ">255" 
err_bad_branch: .asciz "BAD BRANCH" 
err_bad_return: .asciz "BAD RETURN" 
err_bad_next: .asciz "BAD NEXT" 
err_gt8_gosub: .asciz ">8 GOSUBS"  
err_gt8_fors: .asciz ">8 FORS" 
err_end: .asciz "END" 
err_mem_full: .asciz "MEM FULL" 
err_too_long: .asciz "TOO LONG" 
err_dim: .asciz "DIM" 
err_range: .asciz "RANGE"
err_str_ovfl: .asciz "STR OVFL" 
err_string: .asciz "STRING" 
err_retype: .asciz "RETYPE LINE" 
err_prog_only: .asciz "PROGRAM ONLY" 
err_div0: .asciz "DIV BY 0" 

;-------------------------------------
rt_msg: .asciz "\nrun time error, "
comp_msg: .asciz "\ncompile error, "
err_stars: .asciz "*** " 
err_err: .asciz " ERROR \n" 

syntax_error::
	ld a,#ERR_SYNTAX 
tb_error::
	btjt flags,#FCOMP,1$
	push a 
	ldw x, #rt_msg 
	call puts
0$:	pop a 
	callr print_err_msg
	subw y, line.addr 
	ld a,yl 
	sub a,#LINE_HEADER_SIZE 
	_ldxz line.addr 
	call prt_basic_line
	jra 6$
1$:	
	push a 
	ldw x,#comp_msg
	call puts 
	pop a 
	callr print_err_msg
	ldw x,#tib
	call puts 
	ld a,#CR 
	call putc
	_ldxz in.w
	call spaces
	ld a,#'^
	call putc 
6$:
	ldw x,#STACK_EMPTY 
    ldw sp,x
	jp warm_start 
	
;------------------------
; print error message 
; input:
;    A   error code 
; output:
;	 none 
;------------------------
print_err_msg:
	push a 
	ldw x,#err_stars 
	call puts
	pop a 
	clrw x 
	ld xl,a 
	sllw x 
	addw x,#err_msg_idx 
	ldw x,(x)
	call puts 
	ldw x,#err_err 
	call puts 
	ret 
