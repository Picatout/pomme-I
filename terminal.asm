;;
; Copyright Jacques Deschênes 2019,2022 
; This file is part of PABasic 
;
;     PABasic is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.
;
;     PABasic is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.
;
;     You should have received a copy of the GNU General Public License
;     along with PABasic.  If not, see <http://www.gnu.org/licenses/>.
;;
;------------------------------
; This file is for functions 
; interfacing with VT100 terminal
; emulator.
; defined functions:
;   getc   wait for a character 
;   qgetc  check if char available 
;   putc   send a char to terminal
;   puts   print a string to terminal
;   readln  read text line from terminal 
;   spaces  print n spaces on terminal 
;   print_hex  print hex value from A 
;------------------------------

ANSI=0

    .module TERMINAL  

;    .include "config.inc"

    .area CODE 

	.include "inc/ps2_codes.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   UART subroutines
;;   used for user interface 
;;   communication channel.
;;   settings: 
;;		115200 8N1 no flow control
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RX_QUEUE_SIZE==16 ; UART receive queue size 

DTR=0 ; pin D2 received DTR signal from terminaal 

	.area DATA 
; TERMIO variables 
out:: .blkw 1 ; output char routine address 
ctrl_c_vector:: .blkw 1 ; application can set a routine address here to be executed when CTTRL+C is pressed.
rx1_head::  .blkb 1 ; rx1_queue head pointer
rx1_tail::   .blkb 1 ; rx1_queue tail pointer  
rx1_queue:: .ds RX_QUEUE_SIZE ; UART receive circular queue 
term_vars_end::
TERMIOS_VARS_SIZE==term_vars_end-out 


	.area CODE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Uart1 intterrupt handler 
;;; on receive character 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;--------------------------
; UART receive character
; in a FIFO buffer 
; CTRL+C (ASCII 3)
; cancel program execution
; and fall back to command line
; CTRL+X reboot system 
; CTLR+Z erase EEPROM autorun 
;        information and reboot
;--------------------------
UartRxHandler: ; console receive char 
	btjf UART_SR,#UART_SR_RXNE,5$ 
	ld a,UART_DR 
	cp a,#CTRL_C 
	jrne 2$
	ldw x,ctrl_c_vector 
	jreq 5$ 
	ldw (8,sp),x 
	jra 5$ 
2$:
	cp a,#CAN ; CTRL_X 
	jrne 3$
	_swreset 	
3$:	
	push a 
	ld a,#rx1_queue 
	add a,rx1_tail 
	clrw x 
	ld xl,a 
	pop a 
	ld (x),a 
	ld a,rx1_tail 
	inc a 
	and a,#RX_QUEUE_SIZE-1
	ld rx1_tail,a 
5$:	
	iret 


;---------------------------------------------
; initialize UART, 115200 8N1
; called from cold_start in hardware_init.asm 
; input:
;	none
; output:
;   none
;---------------------------------------------
BAUD_RATE=115200
; BRR value = Fmaster/115200 
.if HSI 
BRR1_VAL=8 
BRR2_VAL=0xB
.else 
BRR1_VAL=0xD 
BRR2_VAL=0 
.endif 
uart_init:
	ld a,#BRR2_VAL
	ld UART_BRR2,a 
	ld a,#BRR1_VAL  
	ld UART_BRR1,a
    clr UART_DR
	mov UART_CR2,#((1<<UART_CR2_TEN)|(1<<UART_CR2_REN)|(1<<UART_CR2_RIEN));
	bset UART_CR2,#UART_CR2_SBK
;    btjf UART_SR,#UART_SR_TC,.
    clr rx1_head 
	clr rx1_tail
	ldw x,#ctrl_c_do_nothing 
	_strxz ctrl_c_vector
	ldw x,#uart_putc 
	_strxz out 
	bset UART,#UART_CR1_PIEN
	ret

;-----------------------
; default CTRL+C 
; response 
;-----------------------
ctrl_c_do_nothing:
	ret 

;---------------------------
;  clear rx1_queue 
;---------------------------
clear_queue:
    _clrz rx1_head 
	_clrz rx1_tail 
	ret 

;---------------------------------
;  set output vector 
;  input:
;     A     STDOUT -> uart 
;           BUFOUT -> [ptr16]
;     X     buffer address 
;---------------------------------
set_output:
	ldw ptr16,x 
	ldw x,#uart_putc 
	cp a,#STDOUT 
	jreq 1$
	cp a,#BUFOUT 
	jrne 9$  
	ldw x,#buf_putc 
1$: _strxz out  
9$:	ret 


;---------------------------------
;  vectorized character output 
;  input:
;     A   character to send 
;---------------------------------
putc::
	pushw x 
	_ldxz out 
	call (x)
	popw x 
	ret 

;---------------------------------
; output character to a buffer 
; pointed by ptr16
; input:
;    A     character to save 
;---------------------------------
buf_putc:
	pushw x 
	_ldxz ptr16 
	cp a,#BS 
	jrne 1$
	decw x 
	jra 9$ 
1$:
	ld (x),a
	incw x  
9$:	clr (x)
	_strxz ptr16 
	popw x
	ret 


;---------------------------------
; uart_putc
; send a character via UART
; input:
;    A  	character to send
;---------------------------------
uart_putc:: 
	btjt PD_IDR,#DTR,. ; wait for DTR==0
uart_putc_nfc:: ; no flow control 
	btjf UART_SR,#UART_SR_TXE,.
	ld UART_DR,a 
	ret 


;---------------------------------
; Query for character in rx1_queue
; input:
;   none 
; output:
;   A     0 no charcter available
;   Z     1 no character available
;---------------------------------
qgetc::
uart_qgetc::
	_ldaz rx1_head 
	sub a,rx1_tail 
	ret 

;---------------------------------
; wait character from UART 
; input:
;   none
; output:
;   A 			char  
;--------------------------------	
getc:: ;console input
uart_getc::
	call uart_qgetc
	jreq uart_getc 
	pushw x 
;; rx1_queue must be in page 0 	
	ld a,#rx1_queue
	add a,rx1_head 
	clrw x  
	ld xl,a 
	ld a,(x)
	push a
	_ldaz rx1_head 
	inc a 
	and a,#RX_QUEUE_SIZE-1
	_straz rx1_head 
	pop a 
	btjf sys_flags,#FSYS_UPPER,1$
	call to_upper 
1$: 
	popw x
	ret 

.if ANSI 
;-----------------------------
;  constants replacing 
;  ANSI sequence received 
;  from terminal.
;  These are the ANSI sequences
;  accepted by readln function
;------------------------------
    ARROW_LEFT=128
    ARROW_RIGHT=129
    HOME=130
    KEY_END=131
    SUP=132 

convert_table: .byte 'C',ARROW_RIGHT,'D',ARROW_LEFT,'H',HOME,'F',KEY_END,'3',SUP,0,0

;--------------------------------
; receive ANSI ESC 
; sequence and convert it
; to a single character code 
; in range {128..255}
; This is called after receiving 
; ESC character. 
; ignored sequence return 0 
; output:
;   A    converted character 
;-------------------------------
get_escape:
    call getc 
    cp a,#'[ ; this character is expected after ESC 
    jreq 1$
    clr a
    ret
1$: call getc 
    ldw x,#convert_table
2$:
    cp a,(x)
    jreq 4$
    addw x,#2
    tnz (x)
    jrne 2$
    clr a
    ret 
4$: incw x 
    ld a,(x)
    cp a,#SUP
    jrne 5$
    push a 
    call getc
    pop a 
5$:
    ret 
.endif 

;-----------------------------
; send an ASCIZ string to UART 
; input: 
;   x 		char * 
; output:
;   none 
;-------------------------------
puts::
    ld a,(x)
	jreq 1$
	call putc 
	incw x 
	jra puts 
1$:	incw x 
	ret 

.if ANSI 
;---------------------------------------------------------------
; send ANSI Control Sequence Introducer (CSI) 
; ANSI: CSI 
; note: ESC is ASCII 27
;       [   is ASCII 91
; ref: https://en.wikipedia.org/wiki/ANSI_escape_code#CSIsection  
;----------------------------------------------------------------- 
send_csi:
	push a 
	ld a,#ESC 
	call putc 
	ld a,#'[
	call putc
	pop a  
	ret 

.endif 

;---------------------------
; delete character at left 
; of cursor on terminal 
; input:
;   none 
; output:
;	none 
;---------------------------
uart_bksp::
bksp::
	push a 
	ld a,#BS 
	call putc  
	ld a,#SPACE 
	call putc 
	ld a,#BS 
	call putc 
	pop a 
	ret 
 

;---------------------------
; send LF character 
; terminal interpret it 
; as CRLF 
;---------------------------
new_line:: 
	ld a,#LF 
	call putc 
	ret 

;--------------------------
; erase terminal screen 
;--------------------------
clr_screen::
	ld a,#ESC 
	call putc 
	ld a,#'c 
	call putc 
	ret 

;--------------------------
; output a single space
;--------------------------
space::
	ld a,#SPACE 
	call putc 
	ret 

;--------------------------
; print n spaces on terminal
; input:
;  X 		number of spaces 
; output:
;	none 
;---------------------------
spaces::
	ld a,#SPACE 
1$:	tnzw x
	jreq 9$
	call putc 
	decw x
	jra 1$
9$: 
	ret 

.if ANSI
;-----------------------------
; send ANSI sequence to delete
; whole display line. 
; cursor set left screen.
; ANSI: CSI K
; input:
;   none
; output:
;   none 
;-----------------------------
erase_line:
; move to screen left 
	call restore_cursor_pos  
; delete from cursor to end of line 
    call send_csi
	ld a,#'K 
	call putc 
	ret 

;---------------------------------
; move cursor to CPOS 
; input:
;   A     CPOS 
;---------------------------------
move_to_cpos:
	call restore_cursor_pos
	tnz a 
	jreq 9$ 
	call send_csi 
	call send_parameter
	ld a,#'C 
	call putc 
9$:	ret 

;----------------------------------
; change cursor shape according 
; to editing mode 
; input:
;   A      -1 block shape (overwrite) 
;           0 vertical line (insert)
; output:
;   none 
;-----------------------------------
cursor_style:
	tnz a 
	jrne 1$ 
	ld a,#'5 
	jra 2$
1$: ld a,#'1
2$:	
	call send_csi
	call putc 
	call space
	ld a,#'q 
	call putc 
	ret 

;--------------------------
; insert character in text 
; line 
; input:
;   A       character to insert 
;   XL      insert position  
;   XH     line length    
; output:
;   tib     updated
;-------------------------
 ; local variables 
	ICHAR=1 ; character to insert 
	LLEN=2  ; line length
	IPOS=3  ; insert position 
	VSIZE=3  ; local variables size 
insert_char: 
	_vars VSIZE 
    ld (ICHAR,sp),a 
	ldw (LLEN,sp),x 
	clr a 
	rrwa x ; A=IPOS , XL=LLEN, XH=0 
	ld a,xl  
	sub a,(IPOS,sp) 
	addw x,#tib 
	call move_string_right 
	ld a,(ICHAR,sp)
	ld (x),a
	_drop VSIZE  
	ret 
.endif 

.if ANSI 
;------------------------------------
; read a line of text from terminal
;  control keys:
;    BS   efface caractère à gauche 
;    CTRL_R  edit previous line.
;    CTRL_D  delete line  
;    HOME  go to start of line  
;    KEY_END  go to end of line 
;    ARROW_LEFT  move cursor left 
;    ARROW_RIGHT  move cursor right 
;    CTRL_L accept lower case letter 
;    CTRL_U accept upper case only 
;    CTRL_O  toggle between insert/overwrite
; input:
;	A    length of string already in buffer 
; local variable on stack:
;	LL  line length
;   RXCHAR last received character
; use:
;   Y point end of line  
; output:
;   A  line length 
;   text in tib  buffer
;------------------------------------
	; local variables
	RXCHAR = 1 ; last char received
	LL_HB=1  ; line length high byte 
	LL = 2  ; actual line length
	CPOS=3  ; cursor position 
	OVRWR=4 ; overwrite flag 
	VSIZE=4 
	
readln::
	pushw y 
	_vars VSIZE 
	clrw x 
	ldw (LL_HB,sp),x 
	ldw (CPOS,sp),x 
	ld (LL,sp),a
	ld (CPOS,sp),a  
	cpl (OVRWR,sp) ; default to overwrite mode
	call save_cursor_pos
	tnz (LL,sp)
	jreq skip_display
	ldw x,#tib 
	call puts 
	jra skip_display 
readln_loop:
	call display_line
update_cursor:
	ld a,(CPOS,sp)
	call move_to_cpos   
skip_display: 
	call getc
	ld (RXCHAR,sp),a
    cp a,#ESC 
    jrne 0$
    call get_escape 
    ld (RXCHAR,sp),a 
0$:	cp a,#CR
	jrne 1$
	jp readln_quit
1$:	cp a,#LF 
	jrne 2$ 
	jp readln_quit
2$:
	cp a,#BS
	jrne 3$
	ld a,(CPOS,sp)
	call delete_left
	cp a,(CPOS,sp)
	jreq 21$ 
	ld (CPOS,SP),a 
	dec (LL,sp)
21$:
    jp readln_loop 
3$:
	cp a,#CTRL_D
	jrne 4$
;delete line 
	clr a 
	ldw x,#tib 
	clr(x)
	clr (CPOS,sp)
	clr (LL,sp)
	jra readln_loop
4$:
	cp a,#CTRL_R 
	jrne 5$
;repeat line 
	tnz (LL,sp)
	jrne readln_loop
	ldw x,#tib 
	call strlen
	tnz a  
	jreq readln_loop
	ld (LL,sp),a 
    ld (CPOS,sp),a
	jra readln_loop 
5$:
	cp a,#ARROW_RIGHT
   	jrne 7$ 
; right arrow
	ld a,(CPOS,sp)
    cp a,(LL,sp)
    jrmi 61$
    jp skip_display 
61$:
	inc (CPOS,sp)
    jp update_cursor  
7$: cp a,#ARROW_LEFT  
	jrne 8$
; left arrow 
	tnz (CPOS,sp)
	jrne 71$
	jp skip_display
71$:
	dec (CPOS,sp)
	jp update_cursor 
8$: cp a,#HOME  
	jrne 9$
; HOME 
	clr (CPOS,sp)
	call restore_cursor_pos
	jp skip_display  
9$: cp a,#KEY_END  
	jrne 10$
; KEY_END 
	ld a,(LL,sp)
	ld (CPOS,sp),a 
	jp update_cursor
10$:
	cp a,#CTRL_O
	jrne 13$ 
; toggle between insert/overwrite
	cpl (OVRWR,sp)
 	ld a,(OVRWR,sp)
	call cursor_style
	call beep_1khz
	jp skip_display
13$: cp a,#SUP 
    jrne final_test 
; del character under cursor 
    ld a,(CPOS,sp)
	cp a,(LL,sp)
	jrne 14$ 
	jp skip_display
14$:
	call delete_under
	dec (LL,sp)
    jp readln_loop 
final_test:
	cp a,#SPACE
	jrpl accept_char
	jp skip_display
accept_char:
	ld a,#TIB_SIZE-1
	cp a, (LL,sp)
	jrpl 1$
	jp skip_display ; max length reached 
1$:	tnz (OVRWR,sp)
	jrne overwrite
; insert mode 
    ld a,(CPOS,sp)
	cp a,(LL,sp)
	jreq overwrite
	clrw x 
    ld xl,a ; xl=cpos 
	ld a,(LL,sp)
	ld xh,a  ; xh=ll 
    ld a,(RXCHAR,sp)
    call insert_char 
    inc (LL,sp)
    inc (CPOS,sp)	
    jp readln_loop 
overwrite:
	clrw x 
	ld a,(CPOS,sp)
	ld xl,a 
	addw x,#tib 
	ld a,(RXCHAR,sp)
	ld (x),a
	call putc 
	ld a,(CPOS,sp)
	cp a,(LL,sp)
	jrmi 1$
	inc (LL,sp)
	clr (1,x) 
1$:	
	inc (CPOS,sp)
	jp skip_display 
readln_quit:
	ldw x,#tib
    clr (LL_HB,sp) 
    addw x,(LL_HB,sp)
    clr (x)
	ld a,#CR
	call putc
 	ld a,#-1 
	call cursor_style
	ld a,(LL,sp)
	_drop VSIZE 
	popw y 
	ret

;--------------------------
; delete character under cursor
; and update display 
; input:
;   A      cursor position
;   Y      end of line pointer 
; output:
;   A      not change 
;   Y      updated 
;-------------------------
	CPOS=1
	VSIZE=1
delete_under:
	push A ; CPOS 
	clrw x 
	ld xl,a 
	addw x,#tib 
	ld a,(x)
	jreq 2$ ; at end of line  
	call move_string_left
2$: pop a
	ret 


;------------------------------
; delete character left of cursor
; and update display  
; input:
;    A    CPOS 
;    Y    end of line pointer 
; output:
;    A    updated CPOS 
;-------------------------------
delete_left:
	tnz a 
	jreq 9$ 
	push a 
	clrw x 
	ld xl,a  
	addw x,#tib
	decw x
	call move_string_left   
	pop a 
	dec a  
9$:	ret 

;-----------------------------
; move_string_left 
; move .asciz 1 character left 
; input: 
;    X    destination 
; output:
;    x    end of moved string 
;-----------------------------
move_string_left: 
1$:	ld a,(1,x)
	ld (x),a
	jreq 2$  
	incw x 
	jra 1$ 
2$: ret 

;-----------------------------
; move_string_right 
; move .asciz 1 character right 
; to give space for character 
; insertion 
; input:
;   A     string length 
;   X     *str_end 
; output:
;   X     *slot  
;------------------------------
move_string_right: 
	tnz a 
	jreq 9$
	inc a  
	push a
1$: ld a,(x)
	ld (1,x),a
	decw x  
	dec (1,sp)
	jrne 1$
	_drop 1
	incw x  
9$: ret 

;------------------------------
; display '>' on terminal 
; followed by edited line
;------------------------------
display_line:
	call erase_line  
; write edited line 	
	ldw x,#tib 
	call puts 
	ret 

.else 
 
;--------------------------
; this version of readln 
; if to be used with 
; non ANSI terminal 
; like STM8_terminal 
; 
; CTRL+R  repeat last input line 
; BS      delete last character 
; input:
;   A     initial line length
;   X     initial string  
; output:
;   A     line length 
;   X     tib address 
;--------------------------
MAX_LEN=60
	LN_LEN=1
	CPOS=2
	CHAR=3 
	VSIZE=CHAR  
readln::
	_vars VSIZE 
	ld (LN_LEN,sp),a 
	ld (CPOS,sp),a  
	ldw x,#tib 
	tnz a  
	jreq 1$ 
	call puts 
	decw x  
1$:
	call uart_getc
	ld (CHAR,sp),a 
	cp a,#SPACE 
	jruge 8$
	cp a,#CR 
	jrne 12$
	jp 9$ 
12$:
	cp a,#BS 
	jrne 2$ 
	tnz (LN_LEN,sp)
	jreq 1$ 
	ld a,(CPOS,sp)
	cp a,(LN_LEN,sp)
	jrmi 1$ 
	call bksp 
;	ld a,#BS 
;	call uart_putc 
	decw x 
	clr (x)
	dec (LN_LEN,sp)
	dec (CPOS,sp)
	jra 1$ 
2$: 
	cp a,#CTRL_R 
	jrne 3$
	tnz (LN_LEN,sp)
	jrne 1$  
	ldw x,#tib 
	call strlen 
	ld (LN_LEN,sp),a
	ld (CPOS,sp),a 
	call puts  
	decw x
	jra 1$ 
3$:
	cp a,#CTRL_D 
	jrne 4$
	bres flags,#FAUTO 
	ld a,#CR 
	clr tib 
	clr (LN_LEN,sp)
	jra 9$
4$:	
	cp a,#ESC 
	jrne 1$ 
	call process_esc 
	clr (LN_LEN,sp)
	jra 10$ 
8$: 
	cp a,#128 
	jrmi 88$  
; virtual keys 
	cp a,#VK_LEFT ; left arrow 
	jrne 82$ 
	tnz (CPOS,sp)
	jreq 81$ 
	call cursor_left 
81$: 
	jp 1$ 
82$: 
	cp a,#VK_RIGHT ; right arrow  
	jreq 84$
	jp 1$ 
84$:
	ld a,(CPOS,sp)
	cp a,(LN_LEN,sp)
	jrmi 86$
	jp 1$ 
86$:
	call cursor_right
	jp 1$ 
88$: 
	ld a,(CPOS,sp)
	cp a,(LN_LEN,sp)
	jreq 89$ 
; replace charater in middle of line 
	ld a,(CHAR,sp)
	ld (x),a 
	call uart_putc 
	inc (CPOS,sp) 
	incw x 
	jp 1$
89$: ; append character to end of line 
	ld a,(LN_LEN,sp)
	cp a,#MAX_LEN 
	jrmi 892$
    jp 1$ 
892$:
	ld a,(CHAR,sp)
	call uart_putc 
	ld (x),a 
	incw x 
	clr (x)
	inc (LN_LEN,sp)
	inc (CPOS,sp)
	jp 1$ 
9$:	call uart_putc  
10$: 
	ldw x,#tib 
	ld a,(LN_LEN,sp)
	_drop VSIZE 
	ret 

;----------------------
; received an ESC 
; process ANSI command 
;----------------------
	P1=1 
	P2=P1+1 
	VSIZE=P2+1 
process_esc:
	_vars VSIZE 
	bres sys_flags,#FSYS_TIMER 
	ldw x,#10 
	_strxz timer 
	call get_parameter 
	cp a,#'c  
	jrne 1$ 
	call clr_screen
	jra 9$
1$:
	cp a,#'; 
	jrne 9$ 
	ldw (P1,sp),x 
	call get_parameter 
	cp a,#'R 
	jrne 9$ 
	ldw (P2,sp),x 
	ld a,(P1+1,sp)
	ld xh,a 
	ld a,(P2+1,sp)
	ld xl,a 
9$:
	_drop VSIZE 
	ret 


;----------------------
; move cursor 1 space 
; left 
;----------------------
cursor_left:
	decw x 
	dec (CPOS+2,sp)
	call send_csi 
	ld a,#'D 
	call uart_putc 
	ret 

;-------------------------
; move cursor 1 space 
; right 
;-------------------------
cursor_right:
	incw x 
	inc (CPOS+2,sp)
	call send_csi 
	ld a,#'C 
	call uart_putc 
	ret 

;-------------------------------
; save current cursor postion 
; this value persist to next 
; call to this procedure.
; ANSI: CSI s
;--------------------------------
save_cursor_pos:: 
	push a 
	call send_csi 
	ld a,#'s 
	call putc 
	pop a 
	ret 

;--------------------------------
; restore cursor position from 
; saved value 
; ANSI: CSI u	
;---------------------------------
restore_cursor_pos::
	push a 
	call send_csi 
	ld a,#'u 
	call putc 
	pop a 
	ret 

;----------------------------
; set cursor at line,column 
; input:
;    XH    line 
;    XL    column 
;-----------------------------
set_cursor_pos::
	pushw x 
	call send_csi 
	ld a,(1,sp); line 
	call send_parameter
    ld a,#';
	call uart_putc 
	ld a,(2,sp) ; column 
	call send_parameter
3$: ld a,#'H 
	call uart_putc
	_drop 2 
	ret 

;---------------------------
; move cursor at column  
; input:
;    A    column  
;---------------------------
cursor_column::
	call send_csi 
	call send_parameter 
	ld a,#'G 
	call uart_putc 
	ret 

;-----------------------
; STM8_terminal specific
; ask terminal to 
; send charater at 
; current cursor 
; position 
; output:
;    A    character 
;------------------------
get_char_at::
	ld a,#ESC 
	call uart_putc 
	ld a,#'_ 
	call uart_putc 
	ld a,#'C 
	call uart_putc 
    push  sys_flags  
	bres sys_flags,#FSYS_UPPER 
	call uart_getc
	pop sys_flags  
	ret 

;--------------------------
; ask terminal for 
; cursor position  
;  ESC[6n
;  terminal return:
;     ESC[line;columnR 
;  output:
;      XH   line 
;      XL   column 
;      X=0  if no report 
;--------------------------
	LINE=1 
	COL=LINE+2 
	VSIZE=COL+1
cursor_pos::
	_vars VSIZE
	clrw x 
	ldw (LINE,sp),x 
	ldw (COL,sp),x  
	call clear_queue 
	bres sys_flags,#FSYS_TIMER 
	ldw x,#20 
	_strxz timer  
	call send_csi 
	ld a,#'6 
	call uart_putc 
	ld a,#'n 
	call uart_putc 
0$:
	btjt sys_flags,#FSYS_TIMER,9$ 
	call uart_qgetc 
	jreq 0$ 
	call uart_getc 
	cp a,#ESC 
	jrne 0$ 
	call uart_getc 
	cp a,#'[ 
    jrne 9$ 
1$:
	call get_parameter 
	cp a,#'; 
	jrne 9$ 
	ldw (LINE,sp),x 
	call get_parameter 
	cp a,#'R 
	jreq 8$ 
	clrw x 
	ldw (LINE,sp),x 
	jra 9$ 
8$:	
	ldw (COL,sp),x 
9$: ld a,(LINE+1,sp)
	ld xh,a 
	ld a,(COL+1,sp)
	ld xl,a 	
	_drop VSIZE 
	ret 

;--------------------
; send ESC[
;--------------------
send_csi:
	push a 
	ld a,#27 
	call uart_putc 
	ld a,#'[
	call uart_putc 	
	pop a 
	ret 

;------------------------
; receive parameter from 
; terminal 
; output:
;     X     value 
;------------------------
	DIGIT=1
	VSIZE=DIGIT+1
get_parameter:
	clrw x
	pushw x  
1$:	btjt sys_flags,#FSYS_TIMER,2$  
	call uart_qgetc 
	jreq 1$ 
	call uart_getc
	call is_digit 
	jrnc 2$  
	sub a,#'0 
	ld (DIGIT+1,sp),a  
	ld a,#10 
	mul x,a 
	addw x,(DIGIT,sp)
	jra 1$ 
2$: 
	_drop  VSIZE 
	ret

;---------------------
;send ANSI parameter value
; ANSI parameter values are 
; sent as ASCII charater 
; not as binary number.
; this routine 
; convert binary number to 
; ASCII string and send it.
; expected range {0..99}
; input: 
; 	A {0..99} 
; output:
;   none 
;---------------------
send_parameter:
	pushw x 
	clrw x 
	ld xl,a 
	ld a,#10 
	div x,a 
	add a,#'0 
	ld xh,a ; least digit 
	ld a,xl ; most digit 
    tnz a 
    jreq 2$
	cp a,#10 
	jrmi 1$
	ld a,#9
1$:
	add a,#'0 
	call uart_putc
2$:	ld a,xh 
	call uart_putc 
	popw x 
	ret 

.endif 


;----------------------------------
; convert to hexadecimal digit 
; input:
;   A       digit to convert 
; output:
;   A       hexdecimal character 
;----------------------------------
to_hex_char::
	and a,#15 
	cp a,#10 
	jrmi 1$ 
	add a,#7
1$: add a,#'0 
	ret 

;------------------------------
; print byte  in hexadecimal 
; on console
; no space separator 
; input:
;    A		byte to print
;------------------------------
print_hex::
	push a 
	swap a 
	call to_hex_char 
	call putc 
    pop a  
	call to_hex_char
	call putc   
	ret 

;------------------------
; print int8 
; input:
;    A    int8 
; output:
;    none 
;-----------------------
prt_i8:
	clrw x 
	ld xl,a  


;------------------------------------
; print integer  
; input:
;	X  		    integer to print 
;	'base' 		numerical base for conversion 
;    A 			signed||unsigned conversion
;  output:
;    A          string length
;------------------------------------
print_int::
	ld a,#255  ; signed conversion  
    call itoa  ; conversion entier en  .asciz
	push a 
	call puts
	pop a 
    ret	

;------------------------------------
; convert integer in x to string
; input:
;   'base'	conversion base 
;	X   	integer to convert
;   A       0=unsigned, else signed 
; output:
;   X  		pointer to first char of string
;   A       string length
; use:
;   pad     to build string 
;------------------------------------
	SIGN=1  ; 1 byte, integer sign 
	LEN=SIGN+1   ; 1 byte, string length 
	VSIZE=2 ;locals size
itoa::
	pushw y 
	_vars VSIZE
	clr (LEN,sp) ; string length  
	clr (SIGN,sp)    ; sign
	tnz a
	jreq 1$ ; unsigned conversion  
	tnzw x 
	jrpl 1$ 
	cpl (SIGN,sp)
	negw x 
1$:
; initialize string pointer 
; build string at end of pad  
	ldw y,#pad 
	addw y,#PAD_SIZE 
	decw y 
	clr (y)
	ld a,#SPACE
	decw y
	ld (y),a 
	inc (LEN,sp)
itoa_loop:
    ld a,#10 
    div x,a 
    add a,#'0  ; remainder of division
    cp a,#'9+1
    jrmi 2$
    add a,#7 
2$:	
	decw y
    ld (y),a
	inc (LEN,sp)
; if x==0 conversion done
	tnzw x 
    jrne itoa_loop
	ld a,(SIGN,sp)
    jreq 10$
    ld a,#'-
    decw y
    ld (y),a
	inc (LEN,sp)
10$:
	ld a,(LEN,sp)
	ldw x,y 
	_drop VSIZE
	popw y 
	ret
