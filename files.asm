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

.if SEPARATE 
    .module FILES
    .include "config.inc"

	.area CODE 
.endif 


;---------------------------------
;  files.asm macros 
;---------------------------------


SIGNATURE="PB" 
ERASED="XX" ; erased file, replace signature. 
FILE_SIGN_FIELD = 0 ; signature offset 2 bytes 
FILE_SIZE_FIELD = 2 ; size offset 2 bytes 
FILE_NAME_FIELD = 4 ; file name 12 byte 
FILE_HEADER_SIZE = 16 ; bytes 
FILE_DATA= FILE_HEADER_SIZE ; data offset 
FSECTOR_SIZE=256 ; file sector size  
FNAME_MAX_LEN=12 


;-------------------------------
; search a BASIC file in spi eeprom  
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
search_file:
	_vars VSIZE
	ldw (YSAVE,sp),y  
	ldw (FNAME,sp),x
	call first_file  
1$: jreq 7$  
    ldw x,#file_header+FILE_NAME_FIELD
	ldw y,(FNAME,sp)
	call strcmp 
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
erase_file:
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
load_file:
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
;    farptr     address in eeprom 
;    X          file name 
;--------------------------------------
	TO_WRITE=1
	DONE=TO_WRITE+2
	FNAME=DONE+2 
	XSAVE=FNAME
	YSAVE=XSAVE+2 
	VSIZE=YSAVE+1
save_file:
	_vars VSIZE 
	ldw (YSAVE,sp),y 
	ldw (FNAME,sp),x 
	ldw x,#file_header
	ld a,#'P 
	ld (x),a 
	ld a,#'B 
	ld (1,x),a
	ldw y,progend 
	subw y,lomem
	ldw (FILE_SIZE_FIELD,X),y
	ldw (TO_WRITE,sp),y 
	addw x,#FILE_NAME_FIELD 
	ldw y,(FNAME,sp)
	call strcpy 
	ld a,#FILE_HEADER_SIZE
	ldw x,#file_header
	clr (FILE_HEADER_SIZE-1,x) ; in case name is longer that FNAME_MAX_LEN
	call eeprom_write 
	ldw x,#FILE_HEADER_SIZE 
	call incr_farptr
	ldw x,lomem 
	ldw (XSAVE,sp),x 
	ldw x,#FSECTOR_SIZE-FILE_HEADER_SIZE 
1$: 
	cpw x,(TO_WRITE,sp)
	jrule 2$ 
	ldw x,(TO_WRITE,sp)
2$: ldw (DONE,sp),x
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
	jra 1$ 
9$:
	ldw y,(YSAVE,sp)
	_drop VSIZE 
	ret 

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
	ldw x,#SIGNATURE
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
first_file:
	_clrz farptr 
	clrw x 
	_strxz ptr16 
; search next file 
next_file: 
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
	ldw x,#SIGNATURE  
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
skip_to_next:
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

