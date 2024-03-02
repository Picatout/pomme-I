;;
; Copyright Jacques Deschênes 2023,24  
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

MON_MAJOR=1 
MON_MINOR=3 
MON_REV=0


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
QUOTE='" 


; Modeled on Apple I monitor Written by Steve Wozniak 

mon_str: .asciz "\npomme I monitor "
mon_copyright: .asciz " Jacques Deschenes (c) 2023,24\n" 

GO_BASIC: 
    call new_line
    jp P1BASIC 
GO_FORTH:
    jp forth_init 
FORMAT:
    call erase_all
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
    call uart_putc 
    ld a,#'# 
    call uart_putc
    clrw y 
    jra NEXTCHAR 
BACKSPACE:
    tnzw y 
    jreq NEXTCHAR 
    call bksp 
    decw y 
NEXTCHAR:
    call uart_getc
    cp a,#BS  
    jreq BACKSPACE 
    cp a,#ESC 
    jreq GETLINE ; rejected characters cancel input, start over  
    cp a,#CTRL_B 
    jreq GO_BASIC 
    cp a,#CTRL_E 
    jreq FORMAT 
    cp a,#CTRL_F
    jreq GO_FORTH 
    cp a,#'? 
    jrne 1$
    call print_help
    jra GETLINE 
1$:
    cp a,#QUOTE
    jreq UPPER
    cp a,#'`
    jrmi UPPER ; already uppercase 
; uppercase character
; all characters from 0x60..0x7f 
; are folded to 0x40..0x5f     
    and a,#0XDF  
UPPER: ; there is no lower case letter in buffer 
    ld (tib,y),a 
    call uart_putc
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
    cp a,#QUOTE 
    jreq STOR_QUOTE 
    cp a,#XAM_BLOK
    jrmi BLSKIP 
    jreq SETMODE 
    cp a,#STOR 
    jreq SETMODE
    cp a,#'R 
    jreq RUN
    cp a,#'S 
    jrne 1$
    call asm_syscall ; assemble syscall 
    jra NEXTITEM 
1$:
    cp a,#']
    jrne 2$ 
    _ldxz STORADR
    ld a,#0x81 ; RET machine code 
    ld (x),a 
    incw x 
    _strxz STORADR
    call PRINT_ADDR
    incw y 
    jra NEXTITEM
2$:
    cp a,#'@ 
    jrne 3$ 
    call stm8_dasm 
    jp GETLINE  
3$:
    _stryz YSAV ; save for comparison
    call get_hex
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
    ld a,#CR 
    call uart_putc
    _ldxz XAMADR 
    call (x)
    jp WOZMON
STOR_QUOTE:
    _ldxz XAMADR  
1$:
    incw y 
    ld a,(tib,y)
    cp a,#CR
    jreq 2$
    ld (x),a 
    incw x 
    jra 1$
2$: clr (x)
    jp GETLINE 
XAM_BLOCK:
    _strxz LAST 
    _ldxz XAMADR
    incw x 
    ld a,xl
NXTPRNT:
    jrne PRDATA 
    ld a,#CR 
    call uart_putc 
    call PRINT_ADDR 
    ld a,#': 
    call uart_putc 
PRDATA:
    ld a,#SPACE 
    call uart_putc
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
    call uart_putc 
    RET 
PRINT_ADDR:
    ld a,xh 
    call print_hex 
    ld a,xl 
    jp print_hex 


;---------------------------------
; parse line and assemble 
; a syscall at XAMADR 
; format: 
;   xxxxF code [X val] [Y val]
;--------------------------------
asm_syscall:
    ld a,#CR 
    call uart_putc 
    incw y 
; get service call code     
    call get_hex 
    cpw y,YSAV
    jreq 9$ ; no code bad format 
    _stryz YSAV 
    _ldyz STORADR  
    ld a,#0xA6  ; LD A,#imm  machine code 
    ld (y),a 
    incw y 
    ld a,xl ; syscall code  
    ld (y),a
    incw y 
    _stryz STORADR
    cp a,#FILE_OP 
    jreq asm_file_op
; check if X parameter     
    _ldyz YSAV 
    call get_hex 
    cpw Y,YSAV 
    jreq 8$ ; no X parameter 
    _stryz YSAV 
    _ldyz STORADR  
    ld a,#0xAE ; LDW X,#imm  machine code 
    ld (y),a 
    incw y 
    ld a,xh  ; high  byte imm  
    ld (y),a 
    incw y 
    ld a,xl ; low byte imm 
    ld (y),a 
    incw y 
    _stryz STORADR 
; check for Y parameter 
    _ldyz YSAV
    call get_hex 
    cpw y,YSAV 
    jreq 8$ ; no Y PARAMETER 
    _stryz YSAV 
    _ldyz STORADR  
    ld a,#0x90  ; LDW Y,#imm  machine code prefix  
    ld (y),a 
    incw y 
    ld a,#0xAE  ; LDW Y,#imm machine code 
    ld (y),a 
    incw y 
    ld a,xh ; high byte imm 
    ld (y),a 
    incw y 
    ld a,xl  ; low byte imm 
    ld (y),a 
    incw y 
    _stryz STORADR 
8$: ld a,#0x83 ; TRAP machine code 
    _ldxz STORADR
    ld (x),a
    incw x  
    _strxz STORADR 
;    ld a,#CR 
;    call uart_putc
    call PRINT_ADDR
    ld a,#CR 
    call uart_putc  
    _ldyz YSAV 
9$: 
    ret  

;----------------------------------
; fill fcb structure and 
; assemble file operation 
; formats:
;    op  {D,E,L,S}
;    D   list files 
;    E   file_name erase file 
;    L   file_name load_addr 
;    S   file_name buff_addr size 
;---------------------------------
asm_file_op:
    _ldxz STORADR
    pushw x  
;code fcb address in X 
    ld a,#0xAE ; LDW X,#imm machine code 
    ld (x),a 
    incw x 
    ldw y,#fcb
    ldw (x),y 
    addw x,#2
    ld a,#0x83 ; TRAP  machine code 
    ld (x),a 
    incw x 
    _strxz STORADR
    _ldyz YSAV   
    call skip_spaces 
    incw y 
    _stryz YSAV 
    cp a,#'D 
    jrne 1$ 
    jp code_dir_op 
1$: cp a,#'E 
    jrne 2$ 
    jp code_erase_op 
2$: cp a,#'L 
    jrne 3$
    jp code_load_op 
3$: cp a,#'S 
    jrne 9$
    jp  code_save_op 
9$:  
cancel_op: 
    popw x
    _strxz STORADR
    ld a,#CR 
    ld (tib,y),a
    _stryz YSAV  
    ret 


;--------------------
; parse file name 
; from tib and 
; copy it to 
; fcb 
;--------------------
parse_file_name:
    call skip_spaces 
    ldw x,#fcb+FCB_NAME      
1$:
    ld a,(tib,y) 
    cp a,#SPACE 
    jreq 2$ 
    cp a,#CR 
    jreq 2$
    incw y 
    cpw x,#fcb+FCB_BUFFER
    jrpl 1$
    ld (x),a   
    incw x 
    jra 1$ 
2$:  
    cpw x,#fcb+FCB_BUFFER 
    jrpl 4$ 
    ld (x),a 
    incw x 
    jra 2$ 
4$: 
    ret 

;-------------------
; parameter order 
;  xxxxF D 
;-------------------    
code_dir_op:
    ld a,#FILE_LIST 
    _straz fcb+FCB_OPERATION      
    jra save_y 

;--------------------
; parameters order 
; xxxxF E file_name 
;--------------------    
code_erase_op:
    ld a,#FILE_ERASE
    _straz fcb+FCB_OPERATION 
    call parse_file_name 
    tnz fcb+FCB_NAME 
    jreq cancel_op 
    jra save_y

;----------------------------
; parameters order 
; xxxxF L file_name load_addr  
;-----------------------------    
code_load_op:
    ld a,#FILE_LOAD 
    _straz fcb+FCB_OPERATION 
    call parse_file_name
    tnz fcb+FCB_NAME 
    jreq cancel_op 
    call get_hex 
    cpw y,YSAV
    jreq cancel_op 
    _strxz fcb+FCB_BUFFER 
    jra save_y 

;----------------------------
; parameters order 
; xxxxF S file_name buff_addr size   
;-----------------------------    
code_save_op:
    ld a,#FILE_SAVE 
    _straz fcb+FCB_OPERATION 
    call parse_file_name 
    tnz fcb+FCB_NAME 
    jreq cancel_op 
    call get_hex 
    cpw y,YSAV 
    jreq cancel_op 
    _strxz fcb+FCB_BUFFER 
    call get_hex 
    cpw y,YSAV 
    jrne 1$
    jp cancel_op  
1$:
    _strxz fcb+FCB_DATA_SIZE 
save_y:
    _stryz YSAV 
    _ldxz STORADR 
    call PRINT_ADDR
    ld a,#CR 
    call uart_putc
    _drop 2 
    ret 



;-------------------------
; parse line for 
; hexadecimal number 
; input;
;   Y   offset in tib 
; output:
;   A     0 not a number  
;   X     value 
;   Y     updated if hex 
;-------------------------
get_hex:
    call skip_spaces 
    clrw x
    decw y  
NEXTHEX:
    incw y 
    ld a,(tib,y)
    cp a,#CR 
    jreq NOTHEX 
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
    jra NEXTHEX
NOTHEX:
    ret 


skip_spaces:
1$:
    ld a,(tib,y)
    cp a,#SPACE 
    jrne 2$
    incw y 
    jra 1$
2$: _stryz YSAV 
    ret 

;---------------------------
;  command '?' 
; display kernel functions
;---------------------------
    PREV=1 
print_help::
    PUSH #255 
    ld a,#1 
    _straz farptr 
    ldw x,#p1Kernel_help
1$:
    _strxz ptr16 
    ldf a,[farptr]
    jrne 2$
    tnz (PREV,sp)
    jreq 9$
2$:
    ld (PREV,sp),a 
    call uart_putc
    _ldxz ptr16 
    incw x 
    jra 1$ 
9$: _drop 1     
    ret 

    .include "kernel.hlp" 

