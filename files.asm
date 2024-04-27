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
	jrne 4$ 
	call list_files 
	jra 9$
4$: cp a,#FILE_ERASE_ALL
	jrne 8$
	call erase_all
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
;     X  *FCB
;     Y  *.asciz name 
; output:
;     X  *FCB    
;-------------------------
name_to_fcb::
	pushw x 
	push #FNAME_MAX_LEN 
	addw x, #FCB_NAME
1$:	ld a,(y)
	jreq 2$
	ld (X),a 
	incw y 
	incw x 
	dec (1,sp)
	jrne 1$
	jra 4$  
; pad with SPACE 	
2$: ld a,#SPACE 
3$: ld (x),a 
	incw x
	dec (1,sp)
	jrne 3$
4$:
	_drop 1 
	popw x 
	ret 

;----------------------------
; compare 2 spaces padded 
; file name 
; FNAME_MAX_LEN 
; input:
;   X    *fname1 
;   Y    *fname2
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

.if 1
;------------------------------
; copy space padded file name 
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
.endif 

;--------------------------
; write file header to eeprom 
; input:
;    farptr   file address 
;    file_heder  data 
;------------------------------
write_header:
	ld a,#FILE_HEADER_SIZE 
	ldw x,#file_header 
	call eeprom_write 
	ldw x,#FILE_HEADER_SIZE 
	call incr_farptr
	ret 

;-----------------------------
; print file name 
; input:
;    X    *FNAME 
;-----------------------------
print_fname::
	push #FNAME_MAX_LEN
1$: ld a,(x)
	call putc 
	incw x 
	dec (1,sp)
	jrne 1$ 	
	ld a,#SPACE 
	call putc 
	_drop 1
	ret 

;-------------------------------
; search a file in spi eeprom  
; 
; input:
;    x      *FCB 
; output: 
;    A        0 not found | 1 found file
;    X        *FCB  
;    farptr   file address in eeprom   
;-------------------------------
	FNAME=1 
	YSAVE=FNAME+2 
	FCB_REC=YSAVE+2
	VSIZE=FCB_REC+1 
search_file::
	_vars VSIZE
	ldw (YSAVE,sp),y  
	ldw (FCB_REC,sp),x
	call first_file  
    jreq 7$  
1$:
    ldw x,#file_header+FILE_NAME_FIELD  
	ldw y,(FCB_REC,sp)
	addw y,#FCB_NAME
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
	ldw x,(FCB_REC,sp)
	tnz a 
	_drop VSIZE 
	ret 

;-----------------------------------
; erase file
; replace signature by "XX. 
; input:
;   X    *FCB
; output:
;   X    *FCB    
;-----------------------------------
erase_file:: 
	call search_file 
	jrne 1$ 
	ld a,#FILE_OP_NOT_FOUND
	jra 9$
1$:	 
	pushw x 
	ldw x,#FILE_ERASED 
	_strxz file_header+FILE_SIGN_FIELD 
	ldw x,#file_header  
	ld a,#2 
	call eeprom_write 
	ld a,#FILE_OP_SUCCESS
	popw x 
9$: call file_op_report 
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
	ldw y,#fcb
	call eeprom_read 
	ldw x,#fcb  
	ldw x,(x)
	cpw x,#FILE_ERASED 
	jreq 4$ 
3$:	call skip_to_next
	jra 1$ 
4$: ; check size 
	ldw x,#fcb  
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
; file already searched 
; input:
;    X   *FCB 
; output:
;    X   *FCB 
;--------------------------
	FSIZE=1
	YSAVE=FSIZE+2
	FCB_REC=YSAVE+2
	VSIZE=FCB_REC+1
load_file::
	_vars VSIZE 
	ldw (YSAVE,sp),y
	ldw (FCB_REC,sp),x 
	call search_file 
	jrne 1$ 
	ld a,#FILE_OP_NOT_FOUND
	ldw x,(FCB_REC,sp)
	jra 9$ 
1$:	
	ldw x,#FILE_HEADER_SIZE 
	call incr_farptr 	
	ldw x,file_header+FILE_SIZE_FIELD 
	ldw (FSIZE,sp),x 
	ldw y,(FCB_REC,sp)
	ldw y,(FCB_BUFFER,y)   
	call eeprom_read 
	ldw y,(FSIZE,sp)
	ldw x,(FCB_REC,sp)
	ldw (FCB_DATA_SIZE,x),y 
	ld a,#FILE_OP_SUCCESS
9$:
	call file_op_report 
	ldw y,(YSAVE,sp)
	ldw x,(FCB_REC,sp)
	_drop VSIZE 
	ret 

;--------------------------------------
; save program file 
; input:
;    X          *FCB  
;--------------------------------------
	TO_WRITE=1
	DONE=TO_WRITE+2
	FNAME=DONE+2 
	FCB_REC=FNAME+2
	BUF_ADR=FCB_REC+2 
	YSAVE=BUF_ADR+2
	VSIZE=YSAVE+1
save_file::
	_vars VSIZE 
	ldw (YSAVE,sp),y
	ldw (FCB_REC,sp),x  
; check if file exist 
	call search_file 
	jreq 1$
	ld a,#FILE_OP_CLASH 
	ldw x,(FCB_REC,sp) 
	jra 9$ 
1$:	
	call search_free 
	jrne 11$
	ld a,#FILE_OP_SPACE
	ldw x,(FCB_REC,sp)
	jra 9$
11$:	
	ldw x,#FILE_SIGN 
	_strxz file_header+FILE_SIGN_FIELD 
	ldw x,(FCB_REC,sp)
	ldw y,x
	ldw y,(FCB_DATA_SIZE,y)
	_stryz file_header+FILE_SIZE_FIELD 
	ldw (TO_WRITE,sp),y 
	addw x,#FCB_NAME
	ldw y,x 
	ldw x,#file_header+FILE_NAME_FIELD
	call fname_cpy  
	call write_header 
	ldw x,(FCB_REC,sp)
	ldw x,(FCB_BUFFER,x)
	ldw (BUF_ADR,sp),x 
	ldw x,#FSECTOR_SIZE-FILE_HEADER_SIZE 
2$: 
	cpw x,(TO_WRITE,sp)
	jrule 3$ 
	ldw x,(TO_WRITE,sp)
3$: ldw (DONE,sp),x
	ld a,xl 
	ldw x,(BUF_ADR,sp)
	call eeprom_write 
	ldw x,(DONE,sp)
	call incr_farptr
	ldw x,(TO_WRITE,sp)
	subw x,(DONE,sp)
	ldw (TO_WRITE,sp),x 
	jreq 8$ 
	ldw x,(BUF_ADR,sp)
	addw x,(DONE,sp)
	ldw (BUF_ADR,sp),x 
	ldw x,#FSECTOR_SIZE
	jra 2$
8$:	 
	ld a,#FILE_OP_SUCCESS
	ldw x,(FCB_REC,sp)
9$:
	call file_op_report  
	ldw y,(YSAVE,sp)
	_drop VSIZE 
	ret 

;--------------------------------
; report file operation status 
; input:
;    A     op_code 
;    X     *FCB 
; output:
;    X     *FCB 
;-------------------------------
file_op_report:
	pushw x 
	ld (FCB_OP_STATUS,x),a 
	sll a 
	clrw x 
    ld xl,a  
	ldw x,(status_msg,x) 
	call puts
	popw x  
	ret 

status_msg: .word op_success,no_space,file_exist,not_found

op_success: .asciz "operation completed\n"
no_space: .asciz "File system full.\n" 
file_exist: .asciz "Duplicate name.\n"
not_found: .asciz "File not found.\n" 


;------------------------
; diplay list of files 
; in files system 
;------------------------
	FCNT=1 
	SCTR_CNT=FCNT+2
	VSIZE=SCTR_CNT+1
list_files::
	_vars VSIZE 
	clrw x 
	ldw (FCNT,sp),x 
	ldw (SCTR_CNT,sp),x 
	call first_file 
	jreq 9$ 
1$:
	ldw x,(FCNT,sp)
	incw x 
	ldw (FCNT,sp),x
	ldw x,file_header+FILE_SIZE_FIELD
	addw x,#FILE_HEADER_SIZE
	call sector_align
	call size_to_sector 
	addw x,(SCTR_CNT,sp)
	ldw (SCTR_CNT,sp),x 
	ldw x,#file_header+FILE_NAME_FIELD 
	call print_fname
	ldw x,file_header+FILE_SIZE_FIELD
	call print_int
	ldw x,#file_size 
	call puts 
	ldw x,#file_header 
	call skip_to_next 
	call next_file 
	jrne 1$  
9$:
	call new_line
	ldw x,(FCNT,sp) 	
	call print_int
	ldw x,#files_count 
	call puts 
	ldw x,(SCTR_CNT,sp)
	call print_int
	ldw x,#sectors_used 
	call puts  
	_drop VSIZE 
	ret 

file_size: .asciz "bytes\n"
files_count: .asciz "files\n"
sectors_used: .asciz "sectors used\n" 

;---------------------------
; search free page in eeprom 
; output:
;    A     0 no free | 1 free 
;    farptr  address free 
;---------------------------
search_free:
	pushw x 
	pushw y 
	_clrz farptr 
	clrw x 
	_strxz ptr16 
1$:	
	ldw y,#file_header 
	ldw x,#FILE_HEADER_SIZE 
	call eeprom_read 
	ldw x,#-1 
	cpw x,file_header+FILE_SIGN_FIELD
	jreq 6$   ; empty page, take it 
.if 0
	ldw x,#FILE_SIGN
	cpw x,file_header+FILE_SIGN_FIELD 
	jreq 4$
.endif 	 
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
	popw y 
	popw x 
	ret 


;---------------------------------------
;  search first file 
;  input: 
;    none 
;  output:
;     A     0 none | 1 found file 
; farptr	file address 
;     X     file read buffer
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
	ldw x,#FILE_HEADER_SIZE ; bytes to read 
	ldw y,#file_header  ; epprom read buffer 
	call eeprom_read 
	_ldxz file_header+FILE_SIGN_FIELD   
	_strxz acc16 
	ldw x,#FILE_SIGN  
	cpw x,acc16 
	jreq 8$  
	ldw x,#-1 
	cpw x,acc16 
	jreq 4$ ; end of files 	
2$:
	ldw x,#file_header  
	call skip_to_next 
	jra 1$ 
4$: ; no more file 
	clr a
	jra 9$  
8$: ld a,#1
9$:
	ldw x,#file_header 
    tnz a 	
	popw y 
	ret 

;--------------------------
; erase all files by 
; by bulk_erasing 25LC1024
;-----------------------------
erase_all::
	ldw x,#confirm_msg 
	call puts 
	call getc 
	and a,#0XDF
	cp a,#'Y 
	jrne 9$ 
	jp eeprom_erase_chip
9$: ret 	
confirm_msg: .asciz "\nDo you really want to erase all files? (N/Y)"



;-----------------------------
;  compute sector used 
;  size/SECTOR_SIZE
;  expect FSECTOR_SIZE=256  
; input:
;    X   data size  
; ouput:
;    X    sector count 
;------------------------------
size_to_sector:
	clr a 
	rrwa x 
	ret 

;-------------------------------
;  round up size to n*sector 
;  expect FSECTOR_SIZE=256 
; input:
;     X   size 
; output:
;     X   rounded up to n*sector 
;-------------------------------
sector_align:
	addw x,#FSECTOR_SIZE-1 
	clr a 
	ld xl,a 
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
	call sector_align  

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

