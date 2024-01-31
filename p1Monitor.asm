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

;--------------------------------
;  with this version of wozmon 
;  for stm8 I follow exact model 
;  used by Steve Wozniak only 
;  exception is taking advantage 
;  of extension that STM8 bring 
;  over 6502 cpu. 
;--------------------------------


    .module MONITOR

    .include "config.inc"

    .area CODE

;--------------------------------------------------
; command line interface
; input formats:
;       hex_number  -> display byte at that address 
;       hex_number.hex_number -> display bytes in that range 
;       hex_number: hex_byte [hex_byte]*  -> modify content of RAM or peripheral registers 
;       hex_numberR  -> run machine code a hex_number  address  
;       CTRL_B -> launch pomme BASIC
;----------------------------------------------------
; monitor variables 
YSAV = APP_DATA_ORG 
XAMADR = YSAV+2
STORADR= XAMADR+2
LAST=STORADR+2
MODE=LAST+2 


; operating modes
XAM=0
XAM_BLOK='.
STOR=': 


MON_MAJOR=1 
MON_MINOR=0 
MON_REV=2

; Modeled on Apple I monitor Written by Steve Wozniak 

mon_str: .asciz "pomme I monitor\n"
mon_copyright: .asciz "Copyright, Jacques Deschenes 2023,24\n" 

GO_BASIC: 
    call new_line
    jp P1BASIC 
GO_FORTH:
    jp forth_init 
WOZMON:: 
    ldw x,#mon_str
    ldw y,#mon_copyright 
;push app_info() parameters 
    push #MON_REV 
    push #MON_MINOR 
    push #MON_MAJOR 
    call app_info 
    _drop 3
GETLINE: 
    ld a,#CR 
    call putc 
    ld a,#'# 
    call putc
    clrw y 
    jra NEXTCHAR 
BACKSPACE:
    tnzw y 
    jreq NEXTCHAR 
    call bksp 
    decw y 
NEXTCHAR:
    call getc
    cp a,#BS  
    jreq BACKSPACE 
    cp a,#ESC 
    jreq GETLINE ; rejected characters cancel input, start over  
    cp a,#CTRL_B 
    jreq GO_BASIC 
    cp a,#CTRL_F
    jreq GO_FORTH 
    cp a,#'`
    jrmi UPPER ; already uppercase 
; uppercase character
; all characters from 0x60..0x7f 
; are folded to 0x40..0x5f     
    and a,#0XDF  
UPPER: ; there is no lower case letter in buffer 
    ld (tib,y),a 
    call putc
    cp a,#CR 
    jreq EOL
    incw y 
    jra NEXTCHAR  
EOL: ; end of line, now analyse input 
    ldw y,#-1
    clr a  
SETMODE: 
    _straz MODE  
BLSKIP: ; skip blank  
    incw y 
NEXTITEM:
    ld a,(tib,y)
    cp a,#CR ; 
    jreq GETLINE ; end of input line  
    cp a,#XAM_BLOK
    jrmi BLSKIP 
    jreq SETMODE 
    cp a,#STOR 
    jreq SETMODE 
    cp a,#'R 
    jreq RUN
    _stryz YSAV ; save for comparison
    clrw x 
NEXTHEX:
    ld a,(tib,y)
    xor a,#0x30 
    cp a,#10 
    jrmi DIG 
    cp a,#0x71 
    jrmi NOTHEX 
    sub a,#0x67
DIG: 
    push #4
    swap a 
HEXSHIFT:
    sll a 
    rlcw x  
    dec (1,sp)
    jrne HEXSHIFT
    pop a 
    incw y
    jra NEXTHEX
NOTHEX:
    cpw y,YSAV 
    jrne GOTNUMBER
    jp GETLINE ; no hex number  
GOTNUMBER: 
    _ldaz MODE 
    jrne NOTREAD ; not READ mode  
; set XAM and STOR address 
    _strxz XAMADR 
    _strxz STORADR 
    _strxz LAST 
    clr a 
    jra NXTPRNT 
NOTREAD:  
; which mode then?        
    cp a,#': 
    jrne XAM_BLOCK
    ld a,xl 
    _ldxz STORADR 
    ld (x),a 
    incw x 
    _strxz STORADR 
TONEXTITEM:
    jra NEXTITEM 
RUN:
    _ldxz XAMADR 
    jp (x)
XAM_BLOCK:
    _strxz LAST 
    _ldxz XAMADR
    incw x 
    ld a,xl
NXTPRNT:
    jrne PRDATA 
    ld a,#CR 
    call putc 
    ld a,xh 
    call PRBYTE 
    ld a,xl 
    call PRBYTE 
    ld a,#': 
    call putc 
PRDATA:
    ld a,#SPACE 
    call putc
    ld a,(x)
    call PRBYTE
    incw x
    jreq TONEXTITEM ; rollover 
XAMNEXT:
    cpw x,LAST 
    jrugt TONEXTITEM
MOD8CHK:
    ld a,xl 
    and a,#7 
    jra NXTPRNT
PRBYTE:
    call print_hex
    ret 
ECHO:
    call putc 
    RET 

;----------------------------
; code to test 'R' command 
; blink LED on NUCLEO board 
;----------------------------
.if 0
r_test:
    bset PC_DDR,#5
    bset PC_CR1,#5
1$: bcpl PC_ODR,#5 
; delay 
    ld a,#4
    clrw x
2$:
    decw x 
    jrne 2$
    dec a 
    jrne 2$ 
; if key exit 
    btjf UART_SR,#UART_SR_RXNE,1$
    ld a,UART_DR 
; reset MCU to ensure monitor
; with peripherals in known state
    _swreset

;------------------------------------
; another program to test 'R' command
; print ASCII characters to terminal
; in loop 
;-------------------------------------
ascii:
    ld a,#SPACE
1$:
    call putc 
    inc a 
    cp a,#127 
    jrmi 1$
    ld a,#CR 
    call putc 
; if key exit 
    btjf UART_SR,#UART_SR_RXNE,ascii
    ld a,UART_DR 
; reset MCU to ensure monitor
; with peripherals in known state
    _swreset

.endif 

