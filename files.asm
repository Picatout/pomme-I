;;
; Copyright Jacques Deschênes 2023,2024  
; This file is part of pomme-I 
;
;     pomme-I is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.
;
;     pomme-I is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.
;
;     You should have received a copy of the GNU General Public License
;     along with pomme-I.  If not, see <http://www.gnu.org/licenses/>.
;;


;----------------------------------
;    file system 
; file header:
;   sign field:  2 bytes .ascii "PB" 
;   program size: 1 word 
;   file name: 12 bytes 
;      name is 11 charaters maximum to be zero terminated  
;   data: n bytes 
;  
;   file sector is 256 bytes, this is 
;   minimum allocation unit.   
;----------------------------------

    .module FILES

	.area CODE 

;-------------------------------
;  file operation entry function 
; input:
;    X    pointer to FCB 
;-------------------------------
file_op::
	pushw y 
	ld a,(FCB_OPERATION,x)
	cp a,#FILE_SAVE 
	jrne 1$ 
	call  save_file 
	jra 9$ 
1$: cp a,#FILE_LOAD 
	jrne 2$ 
	call load_file
	jra 9$ 
2$: cp a,#FILE_ERASE 
	jrne 3$ 
	call erase_file 
	jra 9$ 
3$: cp a,#FILE_LIST 
	jrne 8$ 
	call list_files 
	jra 9$ 
8$: 
	pushw x 
	ldw x,#file_bad_op 
	call puts
	popw x  
9$:	
	popw y 
	ret 
file_bad_op: .asciz "bad file operation code\r"

;----------------------
; copy .asciz name 
; to fcb->FILE_NAME_FIELD
; input:
;     X   *.asciz name 
;-------------------------
name_to_fcb::
	pushw y 
	push #FNAME_MAX_LEN 
	_ldyz #fcb+FILE_NAME_FIELD
1$:	ld a,(x)
	jreq 2$
	ld (y),a 
	incw y 
	incw x 
	dec (1,sp)
	jrne 1$ 
; pad with SPACE 	
2$: ld a,#SPACE 
	tnz (1,sp)
	jreq 4$ 
3$: ld (y),a 
	incw y 
	dec (1,sp)
	jrne 3$
4$:
	_drop 1 
	popw y 
	ret 

;----------------------------
; compare name at *X 
; with name at *Y 
; FNAME_MAX_LEN 
; input:
;   X    *name1 
;   Y    *name2
;---------------------------
cmp_fname:
	push #FNAME_MAX_LEN
1$: ld a,(x)
	cp a,(y)
	jrne 9$ 
	incw x 
	incw y 
	dec (1,sp)
	jrne 1$
9$: _drop 1 
	ret 

;------------------------------
; copy file name 
; input:
;   X      destination 
;   Y      source  
;------------------------------
fname_cpy:
	push #FNAME_MAX_LEN 
1$: ld a,(y)
	ld (x),a 
	incw x 
	incw y 
	dec (1,sp)
	jrne 1$ 
	_drop 1 
	ret 

;-------------------------------
; search a file in spi eeprom  
; 
; The file name is identified 
; input:
;    x      *fname 
;    farptr   start address in file system 
; output: 
;    A        0 not found | 1 found
;    farptr   file address in eeprom   
;-------------------------------
	FNAME=1 
	YSAVE=FNAME+2 
	VSIZE=YSAVE+1 
search_file::
	_vars VSIZE
	ldw (YSAVE,sp),y  
	ldw (FNAME,sp),x
	call first_file  
1$: jreq 7$  
    ldw x,#file_header+FILE_NAME_FIELD
	ldw y,(FNAME,sp)
	call cmp_fname 
	jreq 4$ 
	ldw x,#file_header 
	call skip_to_next
	call next_file 
	jreq 7$
	jra 1$   
4$: ; file found  
	ld a,#1 
	jra 8$  
7$: ; not found 
	clr a 
8$:	
	ldw y,(YSAVE,sp)
	_drop VSIZE 
	ret 

;-----------------------------------
; erase program file
; replace signature by "XX. 
; input:
;   farptr    file address in eeprom  
;-----------------------------------
erase_file::
	ld a,#'X 
	ldw x,#file_header
	ld (x),a 
	ld (1,x),a
	ld a,#2 
	call eeprom_write 
	ret 

;--------------------------------------
; reclaim erased file space that 
; fit size 
; input:
;    X     minimum size to reclaim 
; output:
;    A     0 no fit | 1 fit found 
;    farptr   fit address 
;--------------------------------------
	NEED=1
	SMALL_FIT=NEED+2
	YSAVE=SMALL_FIT+2 
	VSIZE=YSAVE+1
reclaim_space:
	_vars VSIZE 
	ldw (YSAVE,sp),y 
	ldw (NEED,sp),x 
	ldw x,#-1 
	ldw (SMALL_FIT,sp),x 
	_clrz farptr  
	clrw x
	_strxz ptr16 
1$:	
	call addr_to_page
	cpw x,#512 
	jrpl 7$ ; to end  
	ldw x,#FILE_HEADER_SIZE
	ldw y,#file_header
	call eeprom_read 
	ldw x,#file_header  
	ldw x,(x)
	cpw x,#ERASED 
	jreq 4$ 
3$:	call skip_to_next
	jra 1$ 
4$: ; check size 
	ldw x,#file_header  
	ldw x,(FILE_SIZE_FIELD,x)
	cpw x,(NEED,sp)
	jrult 3$ 
	cpw x,(SMALL_FIT,sp)
	jrugt 3$ 
	ldw (SMALL_FIT,sp),x  
	jra 3$ 
7$: ; to end of file system 
	clr a 
	ldw x,(SMALL_FIT,sp)
	cpw x,#-1
	jreq 9$ 
	ld a,#1
9$:	
	ldw y,(YSAVE,sp)
	_drop VSIZE  
	ret 

;--------------------------
; load file in RAM 
; input:
;   farptr   file address 
;   file_header   file header data 
;--------------------------
	FSIZE=1
	YSAVE=FSIZE+2
	VSIZE=YSAVE+1
load_file::
	_vars VSIZE 
	ldw (YSAVE,sp),y
	ldw x,#FILE_HEADER_SIZE 
	call incr_farptr 	
	ldw x,#file_header  
	ldw x,(FILE_SIZE_FIELD,x)
	ldw (FSIZE,sp),x 
	ldw y,lomem 
	call eeprom_read 
	ldw x,lomem 
	addw x,(FSIZE,sp)
	_strxz progend 
	_strxz dvar_bgn
	_strxz dvar_end 
9$:
	ldw y,(YSAVE,sp)
	_drop VSIZE 
	ret 

;--------------------------------------
; save program file 
; input:
;    X          FCB  
;--------------------------------------
	TO_WRITE=1
	DONE=TO_WRITE+2
	FNAME=DONE+2 
	XSAVE=FNAME+2
	YSAVE=XSAVE+2 
	VSIZE=YSAVE+1
save_file:
	_vars VSIZE 
	ldw (YSAVE,sp),y 
; check if file exist 
	ldw x,#fcb+FCB_NAME 
	_clrz farptr 
	_clrz ptr16 
	_clrz ptr8 
	call search_file 
	jreq 1$
	ld a,#FILE_OP_CLASH 
	_straz fcb+FCB_OP_STATUS 
	ldw x,#file_exist 
	jra 9$ 
1$:	
	ldw x,#file_header
	ld a,#'P 
	ld (x),a 
	ld a,#'I  
	ld (1,x),a
	ldw y,fcb+FCB_DATA_SIZE
	ldw (FILE_SIZE_FIELD,X),y
	ldw (TO_WRITE,sp),y 
	addw x,#FILE_NAME_FIELD 
	ldw y,(FNAME,sp)
	call fname_cpy  
	ld a,#FILE_HEADER_SIZE
	ldw x,#file_header
	clr (FILE_HEADER_SIZE-1,x) ; in case name is longer that FNAME_MAX_LEN
	call eeprom_write 
	ldw x,#FILE_HEADER_SIZE 
	call incr_farptr
	ldw x,lomem 
	ldw (XSAVE,sp),x 
	ldw x,#FSECTOR_SIZE-FILE_HEADER_SIZE 
2$: 
	cpw x,(TO_WRITE,sp)
	jrule 3$ 
	ldw x,(TO_WRITE,sp)
3$: ldw (DONE,sp),x
	ld a,xl 
	ldw x,(XSAVE,sp)
	call eeprom_write 
	ldw x,(DONE,sp)
	call incr_farptr
	ldw x,(TO_WRITE,sp)
	subw x,(DONE,sp)
	ldw (TO_WRITE,sp),x 
	jreq 9$ 
	ldw x,(XSAVE,sp)
	addw x,(DONE,sp)
	ldw (XSAVE,sp),x 
	ldw x,#FSECTOR_SIZE
	jra 2$ 
9$:
	call puts 
	ldw y,(YSAVE,sp)
	_drop VSIZE 
	ret 

save_success: .asciz "File saved\n"
file_exist: .asciz "Duplicate name.\n"
no_space: .asciz "File system full.\n" 
save_failed: .asciz "Save failed, unknown cause.\n" 

;------------------------
; diplay list of files 
; in files system 
;------------------------
	FCNT=1 
list_files::
	push #0
	push #0 
	call first_file 
1$:	 
	tnz a 
	jreq 9$ 
	ldw x,(FCNT,sp)
	incw x 
	ldw (FCNT,sp),x
	ldw x,#file_header+FILE_NAME_FIELD
	pushw x 
	call puts
	popw x 
	call strlen
	push a 
	push #0
	ldw x,#FNAME_MAX_LEN 
	subw x,(1,sp) 
	call spaces 
	_drop 2  
	ldw x,#file_header+FILE_SIZE_FIELD
	ldw x,(x)
	call print_int
	ldw x,#file_size 
	call puts 
	ldw x,#file_header 
	call skip_to_next 
	call next_file 
	jra 1$  
9$:
	call new_line
	popw x 	
	call print_int
	ldw x,#files_count 
	call puts 
;	clr (y)
	ret 

file_size: .asciz "bytes\n"
files_count: .asciz "files"


;---------------------------
; search free page in eeprom 
; output:
;    A     0 no free | 1 free 
;    farptr  address free 
;---------------------------
search_free:
	_clrz farptr 
	clrw x 
	_strxz ptr16 
1$:	ldw y,#file_header 
	ldw x,#FILE_HEADER_SIZE 
	call eeprom_read 
	ldw x,#file_header
	ldw x,(x)
	_strxz acc16
	ldw x,#-1 
	cpw x,acc16 
	jreq 6$   ; erased page, take it 
	ldw x,#USED
	cpw x,acc16 
	jreq 4$ 
	ldw x,#ERASED
	cpw x,acc16  
	jrne 6$ ; no "PB" or "XX" take it 
4$: ; try next 
	ldw x,#file_header 
	call skip_to_next 
	call addr_to_page 
	cpw x,#512 
	jrmi 1$
	clr a  
	jra 9$ 
6$: ; found free 
	ld a,#1
9$:	
	ret 


;---------------------------------------
;  search first file 
;  input: 
;    none 
;  output:
;     A     0 none | 1 found 
;  farptr   file address 
;   pad     file header 
;-----------------------------------------
first_file::
	_clrz farptr 
	clrw x 
	_strxz ptr16 
; search next file 
next_file::  
	pushw y 
1$:	
	call addr_to_page
	cpw x,#512
	jrpl 4$ 
	ldw x,#FILE_HEADER_SIZE 
	ldw y,#file_header  
	call eeprom_read 
	ldw x,#file_header
	ldw x,(x) ; signature 
	_strxz acc16 
	ldw x,#USED  
	cpw x,acc16 
	jreq 8$  
	ldw x,#-1 
	cpw x,acc16 
	jreq 4$ ; end of files 	
	ldw x,#ERASED 
	cpw x,acc16 
	jrne 4$ 
2$:
	ldw x,#file_header 
	call skip_to_next 
	jra 1$ 
4$: ; no more file 
	clr a
	jra 9$  
8$: ld a,#1 
9$: 	
	popw y 
	ret 

;----------------------------
;  skip to next program
;  in file system  
; input:
;     X       address of buffer containing file HEADER data 
;    farptr   actual program address in eeprom 
; output:
;    farptr   updated to next sector after program   
;----------------------------
skip_to_next::
	ldw x,(FILE_SIZE_FIELD,x)
	addw x,#FILE_HEADER_SIZE 
	addw x,#FSECTOR_SIZE-1 
	clr a 
	ld xl,a 

;----------------------
; input: 
;    X     increment 
; output:
;   farptr += X 
;---------------------
incr_farptr:
	addw x,ptr16 
	_strxz ptr16  
	clr a 
	adc a,farptr 
	_straz farptr 
	ret 

