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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  In application Programming of 
;;;  FLASH, EEPROM and OPTION memory 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SEPARATE=0 

.if SEPARATE 
    .module FLASH_PROG 
    .include "config.inc"

	.area CODE 
.endif 

;----------------------------------
; unlock EEPROM/OPT for writing/erasing
; wait endlessly for FLASH_IAPSR_DUL bit.
; input:
;  none
; output:
;  none 
;----------------------------------
unlock_eeprom:
	btjt FLASH_IAPSR,#FLASH_IAPSR_DUL,9$
	mov FLASH_CR2,#0 
	mov FLASH_NCR2,#0xFF 
	mov FLASH_DUKR,#FLASH_DUKR_KEY1
    mov FLASH_DUKR,#FLASH_DUKR_KEY2
	btjf FLASH_IAPSR,#FLASH_IAPSR_DUL,.
9$:	ret

;----------------------------------
; unlock FLASH for writing/erasing
; wait endlessly for FLASH_IAPSR_PUL bit.
; input:
;  none
; output:
;  none
;----------------------------------
unlock_flash:
	btjt FLASH_IAPSR,#FLASH_IAPSR_PUL,9$
	mov FLASH_CR2,#0 
	mov FLASH_NCR2,#0xFF 
	mov FLASH_PUKR,#FLASH_PUKR_KEY1
	mov FLASH_PUKR,#FLASH_PUKR_KEY2
	btjf FLASH_IAPSR,#FLASH_IAPSR_PUL,.
9$:	ret

;----------------------------
; erase block code must be 
; executed from RAM
; input:
;-----------------------------
row_erase:
	push a 
	pushw y 
	mov FLASH_CR2,#(1<<FLASH_CR2_ERASE) 
	mov FLASH_NCR2,#~(1<<FLASH_CR2_ERASE)
	clr a 
	clrw y 
	ldf ([farptr],y),a
    incw y
	ldf ([farptr],y),a
    incw y
	ldf ([farptr],y),a
    incw y
	ldf ([farptr],y),a
	btjf FLASH_IAPSR,#FLASH_IAPSR_EOP,. ; wait end of operation 
	popw y 
	pop a 
	ret
row_erase_end:

; copy erase_start in RAM 
move_erase_to_ram:
	pushw x 
	pushw y 
	ldw x,#row_erase_end 
	subw x,#row_erase
	ldw acc16,x 
	ldw x,#tib 
	ldw y,#row_erase 
	call move
	popw y
	popw x
	ret 

;-----------------------------------
; block programming must be 
; executed from RAM 
; initial contidions: 
; 	memory unlocked
;   bit PRG set in 
; input:
;   x        data source 
;   farptr   row address destination 
; output:
;   none 
;----------------------------------
	BCNT=1 
program_row:
	push a 
	pushw y 
	push #BLOCK_SIZE  
;enable block programming 
	bset FLASH_CR2,#FLASH_CR2_PRG 
	bres FLASH_NCR2,#FLASH_CR2_PRG
	clrw y 
1$:	ld a,(x)
	ldf ([farptr],y),a
	incw x 
	incw y 
	dec (BCNT,sp)
	jrne 1$
; wait EOP bit 
	btjf FLASH_IAPSR,#FLASH_IAPSR_EOP,. ; wait end of operation 
	_drop 1 
	popw y 
	pop a 
	ret 
program_row_end:

;-------------------------
; move program_row to RAM 
; at txtubound address 
;------------------------
move_prg_to_ram:
	pushw x 
	pushw y 
	ldw x,#program_row_end 
	subw x,#program_row 
	ldw acc16,x ; bytes to move 
	ldw x,#tib ; destination address 
	ldw y,#program_row ; source address 
	call move
	popw y 
	popw x  
	ret 


;-----------------------------
; write a buffer in FLASH/EEPROM 
; input:
;    farptr   destination address 
;    x        buffer address 
;-----------------------------
write_buffer:
	pushw x 
	tnz farptr 
	jrne to_flash 
	_ldxz farptr+1 
	cpw x,#app_space  
	jruge to_flash 
to_eeprom:
	call unlock_eeprom
	jra do_programming
to_flash:
	call unlock_flash
do_programming:
	popw x 
	call tib
	bres FLASH_IAPSR,#FLASH_IAPSR_PUL 
	bres FLASH_IAPSR,#FLASH_IAPSR_DUL  
	ret 


;-----------------------------------
; erase flash or EEPROM block
; a block is 128 bytes 
; input:
;   farptr  address row begin
; output:
;   none
;--------------------------------------
block_erase:
	pushw x 
	_ldaz farptr 
	jrne erase_flash
	_ldxz farptr+1
	cpw x,#app_space 
	jruge erase_flash 
; erase eeprom block
	call unlock_eeprom 
	call tib 
	bres FLASH_IAPSR,#FLASH_IAPSR_DUL
	jra erase_exit  
; erase flash block:
erase_flash:
	call unlock_flash 
	call tib 
    bres FLASH_IAPSR,#FLASH_IAPSR_PUL
erase_exit: 
	popw x 
	ret 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
; write a byte to FLASH or EEPROM/OPTION  
; input:
;    a  		byte to write
;    farptr  	address
;    x          farptr[x]
; output:
;    none
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; variables locales
	BTW = 1   ; byte to write offset on stack
	OPT = 2   ; OPTION flag offset on stack
	VSIZE = 2
write_byte:
	pushw y
	_vars VSIZE
	ld (BTW,sp),a ; byte to write 
	clr (OPT,sp)  ; OPTION flag
; put addr[15:0] in Y, for bounds check.
	ldw y,farptr+1   ; Y=addr15:0
; check addr[23:16], if <> 0 then it is extened flash memory
	tnz farptr 
	jrne write_flash
    cpw y,#app_space 	 
    jruge write_flash
	cpw y,#EEPROM_BASE  
    jrult write_exit
	cpw y,#OPTION_END 
	jrugt write_exit
	jra write_eeprom 
; write program memory
write_flash:
	call unlock_flash 
1$:	sim 
	ld a,(BTW,sp)
	ldf ([farptr],x),a ; farptr[x]=A
	btjf FLASH_IAPSR,#FLASH_IAPSR_EOP,.
    rim 
    bres FLASH_IAPSR,#FLASH_IAPSR_PUL
    jra write_exit
; write eeprom and option
write_eeprom:
	call unlock_eeprom
	; check for data eeprom or option eeprom
	cpw y,#OPTION_BASE
	jrmi 1$
	cpw y,#OPTION_END+1
	jrpl 1$
	cpl (OPT,sp)
1$: 
    tnz (OPT,sp)
    jreq 2$
	; pour modifier une option il faut modifier ces 2 bits
    bset FLASH_CR2,#FLASH_CR2_OPT
    bres FLASH_NCR2,#FLASH_CR2_OPT 
2$: 
    ld a,(BTW,sp)
    ldf ([farptr],x),a
    tnz (OPT,sp)
    jreq 3$
    incw x
    ld a,(BTW,sp)
    cpl a
    ldf ([farptr],x),a
3$: btjf FLASH_IAPSR,#FLASH_IAPSR_EOP,.
	btjf FLASH_IAPSR,#FLASH_IAPSR_HVOFF,.
write_exit:
	incw x 
	call incr_farptr
	clrw x 
	_drop VSIZE 
	popw y
    ret

;--------------------------------------------
; write a data block to eeprom or flash 
; the block must be erased before 
; using this routine.
; input:
;   Y        source address   
;   X        array index  destination  farptr[x]
;   BSIZE    block size bytes 
;   farptr   write address , byte* 
; output:
;	X 		after last byte written 
;   Y 		after last byte read 
;  farptr   point after block
;---------------------------------------------
	_argofs 3 
	_arg BSIZE 1  ; block size
	; local var 
	XSAVE=1 
	VSIZE=2 
write_block::
	push a 
	_vars VSIZE
	ldw (XSAVE,sp),x 
	ldw x,(BSIZE,sp) 
	jreq 9$
1$:	ldw x,(XSAVE,sp)
	ld a,(y)
	call write_byte 
	incw x 
	incw y 
	ldw (XSAVE,sp),x
	ldw x,(BSIZE,sp)
	decw x
	ldw (BSIZE,sp),x 
	jrne 1$
9$:
	ldw x,(XSAVE,sp)
	call incr_farptr
	_drop VSIZE
	pop a 
	ret 


;------------------------------------
; write n bytes to flash | eeprom 
; if the number of bytes is 
; >=128 it is faster to 
; use write_block
; the bytes are written one by 
; one and auto erased if required. 
; input:
;    farptr    dest address 
;    X         src address 
;    A         count 
; output:
;    none   
;----------------------------------
write_nbytes:
	pushw y
	push a 
	ldw y,x
	clrw x 
1$:  
	ld a,(y)
	incw y
	call write_byte 
	incw x 
	dec (1,sp)  
	jrne 1$ 
9$: pop a 
	popw y 
	ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  flash memory operations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;--------------------------
; align farptr to BLOCK_SIZE 
;---------------------------
row_align:
	ld a,#0x7f 
	and a,farptr+2 
	jreq 1$ 
	_ldxz farptr+1 
	addw x,#BLOCK_SIZE 
	jrnc 0$
	_incz farptr 
0$: ld a,xl 
	and a,#0x80
	ld xl,a
	ldw farptr+1,x  	
1$:	ret

;--------------------
; input:
;   X     increment 
; output:
;   farptr  incremented 
;---------------------
incr_farptr:
	addw x,farptr+1 
	jrnc 1$
	_incz farptr 
1$:	ldw farptr+1,x  
	ret 

;-----------------------------------
; scan block for non zero byte 
; block are 128 bytes 
; input:
;    farptr     address block  
; output:
;     A     0 cleared, other not cleared  
;-----------------------------------
scan_block:
	clrw x 
1$: ldf a,([farptr],x) 
	jrne 2$
	incw x 
	cpw x,#BLOCK_SIZE 
	jrult 1$ 
2$:	ret 



