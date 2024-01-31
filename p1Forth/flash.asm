;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Copyright Jacques Deschênes 2019,2020,2021 
;; This file is part of stm32_eforth  
;;
;;     stm8_eforth is free software: you can redistribute it and/or modify
;;     it under the terms of the GNU General Public License as published by
;;     the Free Software Foundation, either version 3 of the License, or
;;     (at your option) any later version.
;;
;;     stm32_eforth is distributed in the hope that it will be useful,
;;     but WITHOUT ANY WARRANTY;; without even the implied warranty of
;;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;     GNU General Public License for more details.
;;
;;     You should have received a copy of the GNU General Public License
;;     along with stm32_eforth.  If not, see <http:;;www.gnu.org/licenses/>.
;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  routines to write to FLASH, EEPROM 
;  and OPTION 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;--------------------------------
; initialize FPTR 
; FP!  ( ud -- )
;---------------------------------
    .word LINK 
    LINK=.
    .byte 3 
    .ascii "FP!"
FPSTOR:
    ldw y,x
    ldw y,(y)
    ld a,yl 
    ld FPTR,a 
    addw x,#CELLL 
    ldw y,x 
    ldw y,(y)
    ldw PTR16,y
    addw x,#CELLL 
    ret 

;-----------------------------------
; return EEPROM base address 
; as a double 
;  EEPROM  ( -- ud )
;-----------------------------------
    .word LINK 
LINK=.
    .byte 6 
    .ascii "EEPROM"
EEPROM: 
    ldw y,#EEPROM_BASE
    subw x,#2*CELLL 
    ldw (2,x),y 
    clrw y 
    ldw (x),y 
    ret


;----------------------------------
; fetch integer at address over 65535
;  FAR@   ( ud -- n )
;----------------------------------
    .word LINK 
LINK=.
    .byte 4
    .ascii "FAR@"
FARAT:
    call FPSTOR
	jp EE_READ 


;-------------------------------------
; fetch C at address over 65535 
; FARC@ ( ud -- c)
;-------------------------------------
    .word LINK
    LINK=.
    .byte 5 
    .ascii "FARC@" 
FARCAT:
    call FPSTOR
	jp EE_CREAD  

;----------------------------------
; UNLOCK EEPROM/OPT for writing/erasing
; wait endlessly for FLASH_IAPSR_DUL bit.
;  UNLKEE   ( -- )
;----------------------------------
    .word LINK 
LINK=.
    .byte 6 
    .ascii "UNLKEE"
UNLKEE:
	mov FLASH_CR2,#0 
	mov FLASH_NCR2,#0xFF 
	mov FLASH_DUKR,#FLASH_DUKR_KEY1
    mov FLASH_DUKR,#FLASH_DUKR_KEY2
	btjf FLASH_IAPSR,#FLASH_IAPSR_DUL,.
	ret

;----------------------------------
; UNLOCK FLASH for writing/erasing
; wait endlessly for FLASH_IAPSR_PUL bit.
; UNLKFL  ( -- )
;----------------------------------
    .word LINK 
LINK=. 
    .byte 6 
    .ascii "UNLKFL"    
UNLKFL:
	mov FLASH_CR2,#0 
	mov FLASH_NCR2,#0xFF 
	mov FLASH_PUKR,#FLASH_PUKR_KEY1
	mov FLASH_PUKR,#FLASH_PUKR_KEY2
	btjf FLASH_IAPSR,#FLASH_IAPSR_PUL,.
	ret

;-----------------------------
; UNLOCK FLASH or EEPROM 
; according to FPTR address 
;  UNLOCK ( -- )
;-----------------------------
	.word LINK 
	LINK=.
	.byte 6
	.ascii "UNLOCK"
UNLOCK:
; put addr[15:0] in Y, for bounds check.
	ldw y,PTR16   ; Y=addr15:0
; check addr[23:16], if <> 0 then it is extened flash memory
	tnz FPTR 
	jrne 4$
    cpw y,#FLASH_BASE
    jruge 4$
	cpw y,#EEPROM_BASE  
    jrult 9$
	cpw y,#OPTION_END 
	jrugt 9$
	call UNLKEE
	ret 
4$: call UNLKFL
9$: ret 

;-------------------------
; LOCK write access to 
; FLASH and EEPROM 
; LOCK ( -- )
;-------------------------
	.word LINK 
	LINK=.
	.byte 4 
	.ascii "LOCK" 
LOCK: 
	bres FLASH_IAPSR,#FLASH_IAPSR_PUL
	bres FLASH_IAPSR,#FLASH_IAPSR_DUL
	ret 

;-------------------------
; increment FPTR 
; INC-FPTR ( -- )
;-------------------------
	.word LINK 
	LINK=. 
	.byte 8 
	.ascii "INC-FPTR" 
INC_FPTR:
	inc PTR8 
	jrne 1$
	pushw y 
	ldw y,FPTR 
	incw y 
	ldw FPTR,y
	popw y  
1$: ret 

;------------------------------
; add u to FPTR 
; PTR+ ( u -- )
;------------------------------
	.word LINK 
	LINK=.
	.byte 4 
	.ascii "PTR+"
PTRPLUS:
	ldw y,x 
	addw x,#CELLL 
	addw y,PTR16 
	ldw PTR16,y  
	jrnc 1$
	inc FPTR 
1$: ret 

;---------------------------------
; read word at address pointed FPTR
; increment FPTR 
; EE-READ ( -- w )
;------------------------------------
	.word LINK 
	LINK=.
	.byte 7 
	.ascii "EE-READ"
EE_READ:
	subw x,#CELLL 
	ldf a,[FPTR]
	ld yh,a 
	call INC_FPTR 
	ldf a,[FPTR]
	call INC_FPTR 
	ld yl,a 
	ldw (x),y 
	ret 

;---------------------------------------
; Read byte at address pointed by FPTR 
; EE-CREAD ( -- c )
;---------------------------------------
	.word LINK 
	LINK=.
	.byte 8
	.ascii "EE-CREAD" 
EE_CREAD:
	subw x,#CELLL 
	ldf a,[FPTR]	
	call INC_FPTR
	clrw y 
	ld yl,a 
	ldw (x),y 
	ret 

;----------------------------
; write a byte at address pointed 
; by FPTR and increment FPTR.
; Expect pointer already initialized 
; and memory unlocked 
; WR-BYTE ( c -- )
;----------------------------
	.word LINK 
	LINK=. 
	.byte 7 
	.ascii "WR-BYTE" 

WR_BYTE:
	call FC_XOFF
	ldw y,x 
	ldw y,(y)
	addw x,#CELLL 
	ld a,yl
	ldf [FPTR],a
	btjf FLASH_IAPSR,#FLASH_IAPSR_EOP,.
	call FC_XON
	jp INC_FPTR 

;---------------------------------------
; write a word at address pointed 
; by FPTR and increment FPTR 
; Expect pointer already initialzed 
; and memory unlocked 
; WR-WORD ( w -- )
;---------------------------------------
	.word LINK 
	LINK=.
	.byte 7 
	.ascii "WR-WORD" 
WR_WORD:
	call FC_XOFF
	ldw y,x
	ldw y,(y)
	addw x,#CELLL 
	ld a,yh 
	ldf [FPTR],a
	btjf FLASH_IAPSR,#FLASH_IAPSR_EOP,.
	call INC_FPTR 
	ld a,yl 
	ldf [FPTR],a
	btjf FLASH_IAPSR,#FLASH_IAPSR_EOP,.
	call FC_XON
	jp INC_FPTR 


;---------------------------------------
; write a byte to FLASH or EEPROM/OPTION  
; EEC!  (c ud -- )
;---------------------------------------
    .word LINK 
	LINK=.
    .byte 4 
    .ascii "EEC!"
	; local variables 
	BTW = 1   ; byte to write offset on stack
    OPT = 2 
	VSIZE = 2
EECSTORE:
	sub sp,#VSIZE
    call FPSTOR
	ld a,(1,x)
	cpl a 
	ld (BTW,sp),a ; byte to write 
	clr (OPT,sp)  ; OPTION flag
	call UNLOCK 
	; check if option
	tnz FPTR 
	jrne 2$
	ldw y,PTR16 
	cpw y,#OPTION_BASE
	jrmi 2$
	cpw y,#OPTION_END+1
	jrpl 2$
	cpl (OPT,sp)
	; OPTION WRITE require this UNLOCK 
    bset FLASH_CR2,#FLASH_CR2_OPT
    bres FLASH_NCR2,#FLASH_CR2_OPT 
2$: 
	call WR_BYTE 	
	tnz (OPT,sp)
	jreq 3$ 
    ld a,(BTW,sp)
    clrw y
	ld yl,a 
	subw x,#CELLL 
	ldw (x),y 
	call WR_BYTE
3$: 
	call LOCK 
	addw sp,#VSIZE 
    ret

;------------------------------
; write integer in FLASH|EEPROM
; EE! ( n ud -- )
;------------------------------
	.word LINK 
	LINK=.
	.byte 3 
	.ascii "EE!"
EESTORE:
	call FPSTOR 
	call UNLOCK 
	ldw y,x 
	ldw y,(y)
	pushw y 
	swapw y 
	ldw (x),y 
	call WR_BYTE 
	popw y 
	subw x,#CELLL
	ldw (x),y 
	call WR_BYTE
	jp LOCK 


;----------------------------
; Erase flash memory row 
; stm8s208 as 128 bytes rows
; ROW-ERASE ( ud -- )
;----------------------------
	.word LINK 
	LINK=. 
	.byte 9 
	.ascii "ROW-ERASE" 
row_erase:
	call FC_XOFF
	call FPSTOR
;code must be execute from RAM 
;copy routine to PAD 
	subw x,#CELLL 
	ldw y,#row_erase_proc
	ldw (x),y 
	call PAD 
	ldw y,#row_erase_proc_end 
	subw y,#row_erase_proc
	subw x,#CELLL 
	ldw (x),y 
	call CMOVE 
block_erase:
	ldw y,FPTR+1
	cpw y,#app_space 
	jrpl erase_flash 
; erase EEPROM block
	cpw y,#EEPROM_BASE 
	jruge 1$
	call FC_XON
	ret ; bad address 
1$: cpw y,#EEPROM_END 
	jrule 2$ 
	call FC_XON
	ret ; bad address 
2$:	
	call UNLKEE 
	jra proceed_erase
; erase flash block:
erase_flash:
	call UNLKFL 
proceed_erase:
	call PAD 
	ldw y,x
	ldw y,(y)
	addw x,#CELLL  
	call (y) 
	bres FLASH_IAPSR,#FLASH_IAPSR_DUL
	call FC_XON
	ret 

; this routine is to be copied to PAD 
row_erase_proc:
	mov FLASH_CR2,#(1<<FLASH_CR2_ERASE) 
	mov FLASH_NCR2,#~(1<<FLASH_CR2_ERASE)
	clr a 
	clrw y 
	ldf ([FPTR],y),a
    incw y
	ldf ([FPTR],y),a
    incw y
	ldf ([FPTR],y),a
    incw y
	ldf ([FPTR],y),a
	btjf FLASH_IAPSR,#FLASH_IAPSR_EOP,.
	ret
row_erase_proc_end:


;-----------------------------------
; block programming must be 
; executed from RAM 
; initial contidions: 
; 		memory unlocked
;       FPTR initialized 
; input: 
;    x   buffer address 
;-----------------------------------
	BCNT=1 
copy_buffer:
	push #BLOCK_SIZE  
;enable block programming 
	bset FLASH_CR2,#FLASH_CR2_PRG 
	bres FLASH_NCR2,#FLASH_CR2_PRG
	clrw y
1$:	ld a,(x)
	ldf ([FPTR],y),a
	incw x 
	incw y 
	dec (BCNT,sp)
	jrne 1$
; wait EOP bit 
	btjf FLASH_IAPSR,#FLASH_IAPSR_EOP,. 
	pop a ; remove BCNT from stack 
	ret 
copy_buffer_end:

;-------------------------
; move program_row to RAM 
; in TIB 
;------------------------
copy_prog_to_ram:
	subw x,#6
	ldw y,#copy_buffer 
	ldw (4,x),y 
	ldw y,#TIBBASE
	ldw (2,x),y 
	ldw y,#copy_buffer_end 
	subw y,#copy_buffer  
	ldw (x),y 
	call CMOVE 
	ret 


;-----------------------------
; write a row in FLASH/EEPROM 
; WR-ROW ( a ud -- )
; a -> address 128 byte buffer to write 
; ud ->  row address in FLASH|EEPROM 
;-----------------------------
	.word LINK 
	LINK=.
	.byte 6 
	.ascii "WR-ROW"
write_row:
	call FC_XOFF
	call FPSTOR
; align to FLASH block 
	ld a,#0x80 
	and a,PTR8 
	ld PTR8,a  
	call copy_prog_to_ram
	call UNLOCK
	ldw y,x 
	ldw y,(y)
	addw x,#CELLL 
	pushw x 
	ldw x,y ; buffer address in x 
	call TIBBASE
	call LOCK
	popw x 
	call FC_XON 
	ret 

;-------------------------------------
; change value of OPTION register 
; SET-OPT (c n -- ) 
; c new value.
; n OPT  number {1..7}
;--------------------------------------
		.word LINK 
		LINK=.
		.byte 7 
		.ascii "SET-OPT" 
set_option: 
		ldw y,x 
		ldw y,(y)
		jreq 1$
		cpw y,#7 
		jrule 2$ 
; invalid OPTION number 		
1$:		addw x,#2*CELLL
		ret
2$:		sllw y 
		addw y,#OPTION_BASE-1
		ldw (x),y 
		subw x,#CELLL 
		clrw y 
		ldw (x),y 
		call EECSTORE
		ret 

;------------------------
; Compile word to flash
; EE, (w -- )
;-----------------------
	.word LINK
	LINK=.
	.byte 3
	.ascii "EE,"
EE_COMMA:
	subw x,#2*CELLL 
	ldw y,UCP
	pushw y 
	ldw (2,x),y 
	clrw y 
	ldw (x),y
	call EESTORE
	popw y 
	addw y,#2
	ldw UCP,y
	ret 


;-------------------------
; Compile byte to flash 
; EEC, ( c -- )	
;-------------------------
	.word LINK 
	LINK=.
	.byte 4 
	.ascii "EEC,"
EE_CCOMMA:
	subw x,#2*CELLL 
	ldw y,UCP
	pushw y 
	ldw (2,x),y 
	clrw y 
	ldw (x),y
	call EECSTORE
	popw y 
	incw y 
	ldw UCP,y
	ret 


;--------------------------
; copy FLASH block to ROWBUF
; ROW>BUF ( ud -- )
;--------------------------
	.word LINK 
	LINK=.
	.byte 7 
	.ascii "ROW>BUF"
ROW2BUF: 
	call FPSTOR 
	ld a,#BLOCK_SIZE
	push a 
	and a,PTR8 ; block align 
	ld PTR8,a
	ldw y,#ROWBUFF 
1$: ldf a,[FPTR]
	ld (y),a
	call INC_FPTR
	incw y 
	dec (1,sp)
	jrne 1$ 
	pop a 
	ret 


;---------------------------
; copy ROWBUFF to flash 
; BUF>ROW ( ud -- )
; ud is row address as double 
;---------------------------
	.word LINK 
	LINK=.
	.byte 7 
	.ascii "BUF>ROW" 
BUF2ROW:
	call TBUF ; ( ud rb -- )
	call ROT 
	call ROT  ; ( rb ud -- )
	call write_row 
	ret 

;---------------------------------
; how many byte free in that row 
; RFREE ( a -- n )
; a is least byte of target address
;----------------------------------
	.word LINK 
	LINK=.
	.byte 5 
	.ascii "RFREE"
RFREE:
	ld a,(1,x)
	and a,#BLOCK_SIZE-1 
	ld YTEMP,a 
	ld a,#BLOCK_SIZE 
	sub a,YTEMP 
	clrw y 
	ld yl,a
	ldw (x),y 
	ret 

;---------------------------------
; write u bytes to flash/EEPROM 
; constraint to row limit 
; RAM>EE ( ud a u -- u2 )
; ud flash address 
; a ram address 
; u bytes count
; return u2 bytes written  
;-------------------------------
	.word LINK 
	LINK=. 
	.byte 6
	.ascii "RAM>EE"
	
RAM2EE:
; copy ud on top 
	ldw y,x 
	ldw y,(6,y) ; LSW of ud  
	ldw YTEMP,y 
	ldw y,x 
	ldw y,(4,y)  ; MSW of ud 
	subw x,#2*CELLL 
	ldw (x),y 
	ldw y,YTEMP 
	ldw (2,x),y 
	call ROW2BUF 
	ldw y,x 
	ldw y,(6,y)
	pushw y ; udl 
	ld a,yl
	and a,#BLOCK_SIZE-1 
	clrw y 
	ld yl,a 
	addw y,#ROWBUFF 
	subw x,#CELLL 
	ldw (x),y  
	call SWAPP ;  ( ud a ra u -- )
	call RFROM  
	call RFREE 
	call MIN
	call DUPP 
	call TOR  
	call CMOVE
	call BUF2ROW 
	call RFROM 
	ret 


;--------------------------
; expand 16 bit address 
; to 32 bit address 
; FADDR ( a -- ud )
;--------------------------
	.word LINK 
	LINK=. 
	.byte 5 
	.ascii "FADDR"
FADDR:
	jp ZERO 

