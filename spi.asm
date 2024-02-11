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

;-------------------------------
;  SPI peripheral support
;  low level driver 
;--------------------------------

	.module SPI 


    .module SPI    
;    .include "config.inc"

    .area CODE 

; SPI channel select pins 
SPI_CS_RAM==0     ; PB0 
SPI_CS_EEPROM==1   ; PB1 

; IC PARAMETERS 
ADR_SIZE=3 ; address size in byte 2>23LC512 or 3>23LC1024 


; SPI RAM commands 
;----------------------------
; 23LCxxxx  
; mode set 
;  bit7:6 | mode 
;  -------|------
;    00   |  byte 
;    01   |  sequential 
;    10   |  page 
;    11   | reserved 
;-------------------------------
RAM_PG_SIZE=32 ; bytes 
SPI_RAM_WRITE=2 
SPI_RAM_READ=3
SPI_RAM_WRMOD=1 ; write mode register
SPI_RAM_RDMOD=5 ; read mode register   
RW_MODE_BYTE=0 
RW_MODE_SEQ=(1<<6) 
RW_MODE_PAG=(2<<6) 

;-----------------------------------------------
; 25LC1024 programming
; 1) set /CS TO 0  
; 2) enable FLASH WRITE with WR_EN cmd 
; 3) set /CS TO 1 
; 4) set /CS to 0 
; 5) send SPI_EEPROM_WRITE followed by 24 bits address
; 6) send up to 256 data bytes 
; 7) rise /CS to 1  
;-----------------------------------------------
SECTOR_SIZE=4096 ; bytes 
SPI_EEPROM_READ=3 
SPI_EEPROM_WRITE=2 ; 256 bytes page 
WR_STATUS=1  ; write status register 
RD_STATUS=5  ; read status register 
WR_EN=6      ; set WEL bit 
SECT_ERASE=0xD8   ; 32KB 
PAGE_ERASE=0x42 ; 256 bytes  
CHIP_ERASE=0xC7   ; whole memory  
; SR 1 status bits 
SR_WIP_BIT=0
SR_WEL_BIT=1 


;---------------------------------
; enable SPI peripheral to maximum 
; frequency = Fspi=Fmstr/2 
; input:
;    none  
; output:
;    none 
;--------------------------------- 
spi_enable::
	bset CLK_PCKENR1,#CLK_PCKENR1_SPI ; enable clock signal 
; configure ~CS on PB1 and BP0 (CN4:11 and CN4:12) as output. 
	bres PB_CR1,#SPI_CS_RAM ; 10K external pull up  
	bset PB_DDR,#SPI_CS_RAM 
	bset PB_ODR,#SPI_CS_RAM   ; deselet channel 
	bres PB_CR1,#SPI_CS_EEPROM ; 10K external pull up  
	bset PB_DDR,#SPI_CS_EEPROM  
	bset PB_ODR,#SPI_CS_EEPROM  ; deselect channel 
; ~CS line controlled by sofware 	
	bset SPI_CR2,#SPI_CR2_SSM 
    bset SPI_CR2,#SPI_CR2_SSI 
; configure SPI as master mode 0.	
	bset SPI_CR1,#SPI_CR1_MSTR
; enable SPI
	clr SPI_ICR 
	bset SPI_CR1,#SPI_CR1_SPE 	
	btjf SPI_SR,#SPI_SR_RXNE,9$ 
	ld a,SPI_DR 
9$: ld a,#RW_MODE_SEQ
	call spi_ram_set_mode 
	call spi_ram_read_mode 
	cp a,#RW_MODE_SEQ
	jreq 10$  
	ldw x,#spi_mode_failed 
	call puts 
	jra . 
10$:
	ret 
spi_mode_failed: .asciz "failes to set SPI RAM mode\n"

;----------------------------
; disable SPI peripheral 
;----------------------------
spi_disable::
; wait spi idle 
	btjf SPI_SR,#SPI_SR_TXE,. 
	btjf SPI_SR,#SPI_SR_RXNE,. 
	btjt SPI_SR,#SPI_SR_BSY,.
	bres SPI_CR1,#SPI_CR1_SPE
	bres CLK_PCKENR1,#CLK_PCKENR1_SPI 
	bres PB_DDR,#SPI_CS_RAM 
	bres PB_DDR,#SPI_CS_EEPROM  
	ret 

;------------------------
; clear SPI error 
;-----------------------
spi_clear_error::
	ld a,#0x78 
	bcp a,SPI_SR 
	jreq 1$
	clr SPI_SR 
1$: ret 

;----------------------
; send byte 
; input:
;   A     byte to send 
; output:
;   A     byte received 
;----------------------
spi_send_byte::
	push a 
	call spi_clear_error
	pop a 
	btjf SPI_SR,#SPI_SR_TXE,.
	ld SPI_DR,a
	btjf SPI_SR,#SPI_SR_RXNE,.  
	ld a,SPI_DR 
	ret 

;------------------------------
;  receive SPI byte 
; output:
;    A 
;------------------------------
spi_rcv_byte::
	ld a,#255
	btjf SPI_SR,#SPI_SR_RXNE,spi_send_byte 
	ld a,SPI_DR 
	ret

;----------------------------
;  create bit mask
;  input:
;     A     bit 
;  output:
;     A     2^bit 
;-----------------------------
create_bit_mask::
	push a 
	ld a,#1 
	tnz (1,sp)
	jreq 9$
1$:
	sll a 
	dec (1,sp)
	jrne 1$
9$: _drop 1
	ret 

;-------------------------------
; SPI select channel 
; input:
;   A    channel SPI_CS_RAM || 
;                SPI_CS_EEPROM 
;--------------------------------
spi_select_channel::
	call create_bit_mask 
	cpl a  
	push a 
	ld a,PB_ODR 
	and a,(1,sp)
	ld PB_ODR,a 
	_drop 1 
	ret 

;------------------------------
; SPI deselect channel 
; input:
;   A    channel SPI_CS_RAM ||
; 				 SPI_CS_EEPROM 
;-------------------------------
spi_deselect_channel::
	btjt SPI_SR,#SPI_SR_BSY,.
	call create_bit_mask 
	push a 
	ld a,PB_ODR 
	or a,(1,sp)
	ld PB_ODR,a 
	_drop 1 
	ret 

;----------------------------
; set spi RAM operating mode 
; input:
;   A     mode byte 
;----------------------------
spi_ram_set_mode:: 
	push a 
	ld a,#SPI_CS_RAM 
	call spi_select_channel
	ld a,#SPI_RAM_WRMOD
	call spi_send_byte 
	pop a 
	call spi_send_byte 
	ld a,#SPI_CS_RAM 
	call spi_deselect_channel
	ret 

;----------------------------
; read spi RAM mode register 
; output:
;   A       mode byte 
;----------------------------
spi_ram_read_mode::
	ld a,#SPI_CS_RAM 
	call spi_select_channel
	ld a,#SPI_RAM_RDMOD 
	call spi_send_byte 
	call spi_rcv_byte
	push a 
	ld a,#SPI_CS_RAM 
	call spi_deselect_channel
	pop a 
	ret 


;-----------------------------
; send 24 bits address to 
; SPI device, RAM || FLASH 
; input:
;   farptr   address 
;------------------------------
spi_send_addr::
	ld a,#ADR_SIZE
	cp a,#2
	jreq 1$
	_ldaz farptr 
	call spi_send_byte 
1$:	_ldaz ptr16 
	call spi_send_byte 
	_ldaz ptr8 
	call spi_send_byte 
	ret 

;--------------------------
; write data to spi RAM 
; input:
;   farptr  address 
;   x       count 0=65536
;   y       buffer 
;----------------------------
spi_ram_write::
	push a 
	ld a,#SPI_CS_RAM 
	call spi_select_channel
	ld a,#SPI_RAM_WRITE
	call spi_send_byte
	call spi_send_addr 
1$:	ld a,(y)
	incw y 
	call spi_send_byte
	decw x 
	jrne 1$ 
	ld a,#SPI_CS_RAM 
	call spi_deselect_channel
	pop a 
	ret 

;-------------------------------
; read bytes from SPI RAM 
; input:
;   farptr   address 
;   X        count 
;   Y        buffer 
;-------------------------------
spi_ram_read::
	push a 
	ld a,#SPI_CS_RAM 
	call spi_select_channel
	ld a,#SPI_RAM_READ
	call spi_send_byte
	call spi_send_addr 
1$:	call spi_rcv_byte 
	ld (y),a 
	incw y 
	decw x 
	jrne 1$ 
	ld a,#SPI_CS_RAM 
	call spi_deselect_channel
	pop a 
	ret 

;---------------------
; enable write to eeprom 
;----------------------
eeprom_enable_write:
	ld a,#SPI_CS_EEPROM 
	call spi_select_channel 
	ld a,#WR_EN 
	call spi_send_byte 
	ld a,#SPI_CS_EEPROM 
	call spi_deselect_channel 
	ret 

;----------------------------
;  read eeprom status register 
;----------------------------
eeprom_read_status:
	ld a,#SPI_CS_EEPROM 	
	call spi_select_channel 
	ld a,#RD_STATUS 
	call spi_send_byte
	call spi_rcv_byte 
	push a  
	ld a,#SPI_CS_EEPROM 
	call spi_deselect_channel
	pop a		
	ret

;----------------------------
; write data to 25LC1024
; page 
; input:
;   farptr  address 
;   A       byte count, 0 == 256 
;   X       buffer address 
; output:
;   none 
;----------------------------
	BUF_ADR=1 
	COUNT=BUF_ADR+2
	VSIZE=COUNT 
eeprom_write::
	push a 
	pushw x 
	call eeprom_enable_write
	ld a,#SPI_CS_EEPROM 
	call spi_select_channel 
	ld a,#SPI_EEPROM_WRITE 
	call spi_send_byte 
	call spi_send_addr 
	ldw x,(BUF_ADR,sp)
1$:
	ld a,(x)
	call spi_send_byte
	incw x
	dec (COUNT,sp) 
	jrne 1$ 
6$: ld a,#SPI_CS_EEPROM 
	call spi_deselect_channel
7$:	call eeprom_read_status 
	bcp a,#(1<<SR_WIP_BIT)
	jrne 7$
	_drop VSIZE
	ret 


;-------------------------- 
; read bytes from flash 
; memory in buffer 
; input:
;   farptr addr in flash 
;   x     count, 0=65536
;   y     buffer addr 
;---------------------------
eeprom_read::
	pushw x 
	ld a,#SPI_CS_EEPROM
	call spi_select_channel
	ld a,#SPI_EEPROM_READ
	call spi_send_byte
	call spi_send_addr  
1$: call spi_rcv_byte 
	ld (y),a 
	incw y 
	ldw x,(1,sp)
	decw x
	ldw (1,sp),x 
	jrne 1$ 
9$:	ld a,#SPI_CS_EEPROM 
	call spi_deselect_channel
	_drop 2 
	ret 

;--------------------
; return true if 
; page empty 
; input:
;    X   page# 
; output:
;    A   -1 true||0 false 
;    X   not changed 
;-------------------------
eeprom_page_empty:
	pushw x 
	call page_addr 
	_straz farptr 
	_strxz ptr16 
	ld a,#SPI_CS_EEPROM 
	call spi_select_channel
	ld a,#SPI_EEPROM_READ 
	call spi_send_byte 
	call spi_send_addr
	push #0 
1$:	call spi_rcv_byte 
	cp a,#0xff 
	jrne 8$ 
	dec (1,sp)
	jrne 1$ 
	cpl (1,sp) 
	jra 9$
8$: clr (1,sp) 
9$: ld a,#SPI_CS_EEPROM 
	call spi_deselect_channel
	pop a 
	popw x 
	ret 

;----------------------
; erase 32KB sector 
; input:
;   A    sector number {0..3} 
; output:
;   none 
;----------------------
eeprom_erase_sector:
	call page_addr 
	_straz farptr 
	_strxz ptr16 
	call eeprom_enable_write
	ld a,#SPI_CS_EEPROM 
	call spi_select_channel
	ld a,#SECT_ERASE
	call spi_send_byte 
	call spi_send_addr 
	ld a,#SPI_CS_EEPROM 
	call spi_deselect_channel
1$:	call eeprom_read_status
	bcp a,#(1<<SR_WIP_BIT)
	jrne 1$
	ret 

;-----------------------------
; erase whole eeprom 
;-----------------------------
eeprom_erase_chip::
	call eeprom_enable_write 
	ld a,#SPI_CS_EEPROM 
	call spi_select_channel
	ld a,#CHIP_ERASE
	call spi_send_byte 
	ld a,#SPI_CS_EEPROM 
	call spi_deselect_channel
1$:	call eeprom_read_status
	bcp a,#(1<<SR_WIP_BIT)
	jrne 1$
	ret 

;---------------------------
; convert page number 
; to address addr=256*page#
; input:
;   X     page {0..511}
; ouput:
;   A:X    address 
;---------------------------
page_addr:
	clr a 
	rlwa x 
	ret 

;----------------------------
; convert address to sector#
; expect 256 bytes SECTOR_SIZE 
; input:
;   farptr   address 
; output:
;   X       page  {0..511}
;----------------------------
addr_to_page::
	_ldaz farptr 
	_ldxz ptr16 
	rrwa x  
	ret 

;---- test code -----

; ----- spi FLASH test ---------
.if 0
eeprom_test_msg: .byte 27,'c 
.asciz "spi EEPROM test\n"
no_empty_msg: .asciz " no empty page "
writing_msg: .asciz "\nwriting 128 bytes in page " 
reading_msg: .asciz "\nreading back\n" 
repeat_msg: .asciz "\nkey to repeat"
eeprom_test:
	call spi_enable
3$:
	ldw x,#eeprom_test_msg 
	call puts 
	ldw x,#writing_msg   
	call puts 
; search empty page 
	clrw x
7$:	call save_cursor_pos
	pushw x 
	call print_int 
	call restore_cursor_pos 
	popw x 
	call eeprom_page_empty
	tnz a 
	jrmi 5$
	incw x 
	cpw x,#512
	jrmi 7$
	clr a 
	call eeprom_erase_sector
	ldw x,#no_empty_msg 
	call puts 
	call prng
	rlwa x 
	and a,#1 
	rrwa x 
5$: pushw x  
	call print_int 
	call new_line 
	popw x 
	call page_addr 
	_straz farptr 
	_strxz ptr16 
; fill tib with 128 random byte 
0$:
	push #64
	ldw y,#tib 
1$:
	call prng 
	ldw (y),x
	ld a,xh 
	call print_hex
	call space  
	ld a,xl 
	call print_hex 
	call space 
	addw y,#2 
	pop a 
	dec a 
	jreq 4$
	push a 
	and a,#7 
	jrne 1$ 
	call new_line 
	jra 1$ 
4$:
	ld a,#128 
	ldw x,#tib 
	call eeprom_write
; clear tib
	ldw x,#tib 
	ld a,#128 
6$:	clr (x)
	incw x 
	dec a 
	jrne 6$
;read back written data 
	ldw x,#reading_msg 
	call puts 
	ldw y,#tib 
	ldw x,#128 
	call eeprom_read 
	push #128 
	ldw y,#tib 
2$: ld a,(y)
	call print_hex 
	call space 
	incw y
	pop a 
	dec a
	jreq 9$  
	push a  
	and a,#15 
	jrne 2$
	call new_line
	jra 2$  
9$:	
	ldw x,#repeat_msg
	call puts 
	call getc
	jp 3$
.endif 



;----- spi RAM test 
.if 0
spi_ram_msg: .byte 27,'c  
 .asciz "SPI RAM test\n"
spi_ram_write_msg: .asciz "Writing 128 bytes at "
spi_ram_read_msg: .asciz "\nreading data back\n"
spi_ram_test:
	call spi_enable 
	ldw x,#spi_ram_msg 
	call puts
	ldw x,#spi_ram_write_msg 
	call puts  
	call prng 
	_clrz farptr 
	_strxz ptr16 
	call print_int
	call new_line
; fill tib with random bytes 
	push #64
	ldw y,#tib 
1$:	call prng 
	ldw (y),x 
	addw y,#2
	pushw x 
	pop a 
	call print_hex 
	call space 
	pop a 
	call print_hex 
	call space  
	pop a 
	dec a 
	jreq 4$
	push a 
	and a,#7 
	jrne 1$ 
	call new_line 
	jra 1$ 
4$:
	ldw x,#128 
	ldw y,#tib 
	call spi_ram_write 
	ldw x,#spi_ram_read_msg 
	call puts
; clear tib 
	ldw x,#128
	ldw y,#tib 
2$: clr (y)
	incw y 
	decw x 
	jrne 2$
	ldw y,#tib 
	ldw x,#128 
	call spi_ram_read 
	push #128 
	ldw y,#tib
; print read values 
3$:	ld a,(y)
	incw y 
	call print_hex 
	call space 
	pop a 
	dec a 
	jreq 5$
	push a 
	and a,#15
	jrne 3$ 
	call new_line
	jra 3$ 
5$:
	ldw x,#repeat_msg
	call puts 
	call getc 
	jp spi_ram_test
.endif 
