;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Copyright Jacques Deschênes 2024
;; This file is part of p1Forth  
;;
;;     stm8_eforth is free software: you can redistribute it and/or modify
;;     it under the terms of the GNU General Public License as published by
;;     the Free Software Foundation, either version 3 of the License, or
;;     (at your option) any later version.
;;
;;     p1Forth is distributed in the hope that it will be useful,
;;     but WITHOUT ANY WARRANTY;; without even the implied warranty of
;;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;     GNU General Public License for more details.
;;
;;     You should have received a copy of the GNU General Public License
;;     along with p1Forth.  If not, see <http:;;www.gnu.org/licenses/>.
;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;-------------------------------------------------------------
;  eForth for STM8S adapted from C. H. Ting source file to 
;  assemble using sdasstm8
;  implemented on NUCLEO-8S208RB board
;  Adapted by picatout 2019/10/27
;  https://github.com/picatout/stm8_nucleo/eForth
;
;  Adapted to pomme-I computer 2024/01/29
;--------------------------------------------------------------
	.module EFORTH
         .optsdcc -mstm8

        .include "../config.inc"  
        .include "inc/config.inc"
	.include "macros.inc"

	.page


; FORTH Virtual Machine:
; Subroutine threaded model
; SP Return stack pointer
; X Data stack pointer
; A,Y Scratch pad registers
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; original code 
;
;       Copyright (c) 2000
;       Dr. C. H. Ting
;       156 14th Avenue
;       San Mateo, CA 94402
;       (650) 571-7639
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      
;*********************************************************
;	Assembler constants
;*********************************************************
RAMBASE =	APP_DATA_ORG	;ram base
STACK   =	RAM_END 	;system (return) stack empty 
DATSTK  =	0x1680	;data stack  empty
TBUFFBASE =     0x1680  ; flash read/write transaction buffer address  
TIBBASE =       0X1700  ; transaction input buffer addr.

; floatting point state bits in UFPSW 
ZBIT=0 ; zero bit flag
NBIT=1 ; negative flag 
OVBIT=2 ; overflow flag 


;; Memory allocation
UPP     =     RAMBASE          ; systeme variables base address 
SPP     =     DATSTK     ; data stack bottom 
RPP     =     STACK      ;  return stack bottom
ROWBUFF =     TBUFFBASE ; flash write buffer 
TIBB    =     TIBBASE  ; transaction input buffer
VAR_BASE =    RAMBASE+0x80  ; user variables start here .
VAR_TOP =     DATSTK-32*CELLL  ; reserve 32 cells for data stack. 

; user variables constants 
UBASE = UPP       ; numeric base 
UFPSW = UBASE+2  ; floating point state word 
UTMP = UFPSW+2    ; temporary storage
UINN = UTMP+2     ; >IN tib pointer 
UCTIB = UINN+2    ; tib count 
UTIB = UCTIB+2    ; tib address 
UINTER = UTIB+2   ; interpreter vector 
UHLD = UINTER+2   ; hold 
UCNTXT = UHLD+2   ; context, dictionary first link 
ULAST = UCNTXT+2    ; last dictionary pointer 
UVP = ULAST+2     ; *HERE address  

;******  System Variables  ******
XTEMP	=	UVP +2;address called by CREATE
YTEMP	=	XTEMP+2	;address called by CREATE
PROD1 = XTEMP	;space for UM*
PROD2 = PROD1+2
PROD3 = PROD2+2
CARRY = PROD3+2
SP0	= CARRY+2	;initial data stack pointer
RP0	= SP0+2		;initial return stack pointer
FPTR = RP0+2         ; 24 bits farptr 
PTR16 = FPTR+1          ; middle byte of farptr 
PTR8 = FPTR+2           ; least byte of farptr 

;***********************************************
;; Version control

MAJOR     =     5         ;major release version
MINOR     =     1         ;minor extension
REV       =     0         ;revision 

;; Constants

TRUEE   =     0xFFFF      ;true flag

COMPO   =     0x40     ;lexicon compile only bit
IMEDD   =     0x80     ;lexicon immediate bit
MASKK   =     0x1F7F  ;lexicon bit mask

CELLL   =     2       ;size of a cell
DBL_SIZE =    2*CELLL ; size of double integer 
BASEE   =     10      ;default radix
BKSPP   =     8       ;back space
LF      =     10      ;line feed
CRR     =     13      ;carriage return
XON     =     17
XOFF    =     19
CTRL_X  =     24      ; reboot hotkey 
ERR     =     27      ;error escape
CALLL   =     0xCD     ;CALL opcodes
ADDWX   =     0x1C    ; opcode for ADDW X,#word  
JPIMM   =     0xCC    ; JP addr opcode 
RET     =     0x81    ; RET opcode

;---------------------------
        .area CODE 
;---------------------------

;-------------------------
;  CTRL+C abort routine 
;-------------------------
user_abort:
        subw x,#CELLL 
        ldw     y,#-1
        ldw     (x),y 
        call ABORQ 
        .byte 13
        .ascii "\nuser aborted"

;; Main entry points and COLD start data
forth_init::
; clear all RAM
	ldw X,#RAMBASE
clear_ram0:
	clr (X)
	incw X
	cpw X,#RAM_END
	jrule clear_ram0
        ldw x,#RPP
        ldw sp,x
	ldw x,#user_abort 
        _strxz ctrl_c_vector
        jp ORIG

; COLD initialize these variables.
UZERO:
        .word      BASEE   ;BASE
        .word      0       ; floating point state 
        .word      0       ;tmp
        .word      0       ;>IN
        .word      0       ;#TIB
        .word      TIBB    ;TIB
        .word      INTER   ;'EVAL
        .word      0       ;HLD
        .word      LASTN  ;CNTXT pointer
        .word      LASTN   ;LAST
        .word      VAR_BASE ; HERE 
UEND:   .word      0

ORIG:   
; initialize SP
        LDW     X,#STACK  ;initialize return stack
        LDW     SP,X
        LDW     RP0,X
        LDW     X,#DATSTK ;initialize data stack
        LDW     SP0,X

        
        jp  COLD   ;default=MN1


        LINK = 0  ; used by _HEADER macro 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;        
;; place MCU in sleep mode with
;; halt opcode 
;; BYE ( -- )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER BYE,3,"BYE"
        _swreset 
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Reset dictionary pointer before 
;; forgotten word.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER FORGET,6,"FORGET"
        call TOKEN
        call DUPP 
        call QBRAN 
        .word FORGET2 ; invalid parameter
        call NAMEQ ; ( a -- ca na | a F )
        call QDUP 
        call QBRAN 
        .word FORGET2 ; not in dictionary 
; only forget users words 
        call DUPP ; ( -- ca na na )
        call DOLIT 
        .word VAR_TOP 
        call  ULESS 
        call QBRAN 
        .word FORGET6 
; ( ca na -- )        
        call SWAPP ; ( ca na -- na ca )
        _TDROP ; ( na ca -- na )
        _DOLIT 2 
        call SUBB ; link field 
        call AT   ; previous word in dictionary 
        call DUPP ; ( -- na na )
        call CNTXT 
        call STORE
        call LAST  
        JP STORE 
FORGET6: ; tried to forget system word 
; ( ca na -- )
        subw x,#CELLL 
        ldw y,SP0 
        ldw (x),y  
        call ULESS
        call QBRAN 
        .word PROTECTED 
        call ABORQ 
        .byte 25
        .ascii " can't forget system word"
PROTECTED:
        call ABORQ
        .byte 10
        .ascii " Protected"
FORGET2: ; no name or not found in dictionary 
        call ABORQ
        .byte 11
        .ascii " not a word"
FORGET4:
        jp DROP 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    SEED ( u -- )
; Initialize PRNG seed with u
; or if u==0 with ticks counter  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER SEED,4,"SEED"
        ldw y,x 
        addw x,#CELLL
        ldw y,(y)
        pushw x 
        ldw x,y 
        call set_seed 
        popw x 
        ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    RANDOM ( u1 -- u2 )
; Pseudo random number betwen 0 and u1-1
;  XOR32 algorithm 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER RANDOM,6,"RANDOM"
        pushw x 
        call prng 
        pushw x 
        ldw y,(3,sp) 
        ldw y,(y)
        popw x 
        divw x,y 
        popw x 
        ldw (x),y 
        ret 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; get millisecond counter 
;; msec ( -- u )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER MSEC,4,"MSEC"
        subw x,#CELLL 
        _ldyz ticks 
        ldw (x),y 
        ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; suspend execution for u msec 
;  pause ( u -- )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER PAUSE,5,"PAUSE"
        ldw y,x
        addw x,#CELLL 
        ldw y,(y)
        addw y,ticks 
1$:     wfi  
        cpw y,ticks   
        jrne 1$
        ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; initialize count down timer 
;  TIMER ( u -- )  milliseconds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER TIMER,5,"TIMER"
        ldw y,x
        ldw y,(y) 
        _stryz timer 
        addw x,#CELLL 
        ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; check for TIMER exiparition 
;  TIMEOUT? ( -- 0|-1 )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER TIMEOUTQ,8,"TIMEOUT?"
        clr a
        subw x,#CELLL 
        ldw y,timer 
        jrne 1$ 
        cpl a 
1$:     ld (1,x),a 
        ld (x),a 
        ret         

;; Device dependent I/O
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       ?RX     ( -- c T | F )
;         Return input character and true, or only false.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER QKEY,4,"?KEY"
        call uart_qgetc
        jrne INCH 
	SUBW	X,#CELLL
        CLRW    Y 
        LDW (X),Y
        RET 
INCH:         
        call uart_getc 
        SUBW X, #2*CELLL 
        CLR     (CELLL,X)
        LD     (CELLL+1,X),A
	LDW     Y,#-1
        LDw     (X),Y 
        RET 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       TX!     ( c -- )
;       Send character c to  output device.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER EMIT,4,"EMIT"
        LD     A,(1,X)
	ADDW	X,#2
putc:         
OUTPUT: 
        BTJF UART_SR,#UART_SR_TXE,OUTPUT  ;loop until tx empty 
        LD    UART_DR,A   ;send A
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       TX-XON  ( -- )
;       send XON character 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER TX_XON,6,"TX-XON"
        ld a,#XON 
        jra OUTPUT 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       TX-XOFF ( -- )
;       Send XOFF character 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER TX_XOFF,7,"TX-XOFF"
        ld a,#XOFF 
        jra OUTPUT  

;; The kernel

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       doLIT   ( -- w )
;       Push an inline literal.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DOLIT:
	SUBW X,#2
        ldw y,(1,sp)
        ldw y,(y)
        ldw (x),y
        popw y 
        jp (2,y)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       NEXT    ( -- )
;       Code for  single index loop.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DONXT,COMPO+4,"NEXT"
	LDW Y,(3,SP)
	DECW Y
	JRPL NEX1 ; jump if N=0
; exit loop 
	POPW Y
        addw sp,#2
        JP (2,Y)
NEX1:
        LDW (3,SP),Y
        POPW Y
	LDW Y,(Y)
	JP (Y)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       ?branch ( f -- )
;       Branch if flag is zero.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       _HEADER QBRAN,COMPO+7,"?BRANCH"        
QBRAN:	
        LDW Y,X
	ADDW X,#2
	LDW Y,(Y)
        JREQ     BRAN
	POPW Y
	JP (2,Y)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  TBRANCH ( f -- )
;  branch if f==TRUE 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;        _HEADER TBRAN,COMPO+7,"TBRANCH"
TBRAN: 
        LDW Y,X 
        ADDW X,#2 
        LDW Y,(Y)
        JRNE BRAN 
        POPW Y 
        JP (2,Y)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       branch  ( -- )
;       Branch to an inline address.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       _HEADER BRAN,COMPO+6,"BRANCH"
BRAN:
        POPW Y
	LDW Y,(Y)
        JP  (Y)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       EXECUTE ( ca -- )
;       Execute  word at ca.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER EXECU,7,"EXECUTE"
        LDW Y,X
	ADDW X,#CELLL 
	LDW  Y,(Y)
        JP   (Y)

OPTIMIZE = 1
.if OPTIMIZE 
; remplacement de CALL EXIT par 
; le opcode de RET.
; Voir modification au code de ";"
.else 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       EXIT    ( -- )
;       Terminate a colon definition.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       _HEADER EXIT,4,"EXIT"
EXIT:
        POPW Y
        RET
.endif 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       !       ( w a -- )
;       Pop  data stack to memory.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER STORE,1,"!"
        LDW Y,X
        LDW Y,(Y)    ;Y=a
        PUSHW X
        LDW X,(2,X) ; x=w 
        LDW (Y),X 
        POPW X  
        _DDROP 
        RET     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       @       ( a -- w )
;       Push memory location to stack.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER AT,1,"@"
        LDW Y,X     ;Y = a
        LDW Y,(Y)   ; address 
        LDW Y,(Y)   ; value 
        LDW (X),Y ;w = @Y
        RET     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       C!      ( c b -- )
;       Pop  data stack to byte memory.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER CSTOR,2,"C!"
        LDW Y,X
	LDW Y,(Y)    ;Y=b
        LD A,(3,X)    ;D = c
        LD  (Y),A     ;store c at b
	_DDROP 
        RET     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       C@      ( b -- c )
;       Push byte in memory to  stack.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER CAT,2,"C@"
        LDW Y,X     ;Y=b
        LDW Y,(Y)
        LD A,(Y)
        LD (1,X),A
        CLR (X)
        RET     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       RP@     ( -- a )
;       Push current RP to data stack.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER RPAT,3,"RP@"
        LDW Y,SP    ;save return addr
        SUBW X,#2
        LDW (X),Y
        RET     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       RP!     ( a -- )
;       Set  return stack pointer.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER RPSTO,COMPO+3,"RP!"
        SUBW X,#CELLL 
        POPW Y
        LDW (X),Y
        LDW Y,X
        LDW Y,(2,Y)
        LDW SP,Y
        LDW Y,X 
        LDW Y,(Y)
        ADDW X,#2*CELLL 
        JP (Y)

;-------------------------------
; transfert addres on TOS 
; to farptr 
;-------------------------------
xram_adr: ; ( d -- )
        LDW     Y,X 
        LD     A,(1,Y) 
        _straz farptr 
        LDW     Y,(2,Y) 
        _stryz  ptr16 
        ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       XRAM@ ( d -- n )
; read data from spi ram
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER XRAMAT,5,"XRAM@"
        CALL    xram_adr 
        _TDROP 
        PUSHW   X 
        LDW     X,#2 
        LDW     Y,(1,SP)
        CALL    spi_ram_read 
        POPW    X 
        RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       XRAM! ( n d -- )
; write data to spi ram 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER XRAMSTO,5,"XRAM!"
        CALL    xram_adr
        _DDROP 
        LDW     Y,X 
        _TDROP 
        PUSHW   X 
        LDW     X,#2
        call    spi_ram_write 
        POPW    X
        RET 


;--------------------------------
; set transfert count and 
; buffer address 
;--------------------------------
xram_blk_param: ; ( cnt b -- )
;; open a slot on SP to save X
;; will be retreived by caller  
        LDW     Y,(1,SP) 
        SUB     SP,#CELLL 
        LDW     (1,SP),Y 
        LDW     (3,SP),X ; save X 
        LDW     X,(2,X) ; cnt 
        LDW     Y,(3,SP)
        LDW     Y,(Y)  ; b 
        RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       XRAM-BLK@ ( cnt b d -- )
; read cnt bytes from spi ram to b 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER,XRAM_BLK_AT,9,"XRAM-BLK@"
        call xram_adr
        _DDROP 
        CALL    xram_blk_param
        call    spi_ram_read 
        POPW    X 
        _DDROP 
        RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       XRAM-BLK! ( cnt b d -- )
; write cnt bytes to spi ram from b 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER XRAM_BLK_STO,9,"XRAM-BLK!"
        call xram_adr
        _DDROP 
        CALL    xram_blk_param
        call    spi_ram_write  
        POPW    X 
        _DDROP 
        RET 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       R>      ( -- w )
;       Pop return stack to data stack.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER RFROM,2,"R>"
        SUBW X,#CELLL 
        LDW Y,(3,SP)
        LDW (X),Y 
        POPW Y 
        ADDW SP,#2 
        JP (Y)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       R@      ( -- w )
;       Copy top of return stack to stack.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER RAT,2,"R@"
        ldw y,(3,sp)
        subw x,#CELLL 
        ldw (x),y 
        ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       >R      ( w -- )
;       Push data stack to return stack.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER TOR,COMPO+2,">R"
        LDW     Y,(1,sp)
        PUSHW   Y 
        LDW     Y,X
        _TDROP 
        LDW     Y,(Y)  ; W
        LDW     (3,SP),Y 
        RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       SP@     ( -- a )
;       Push current stack pointer.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER SPAT,3,"SP@"
	LDW Y,X
        SUBW X,#2
	LDW (X),Y
        RET     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       SP!     ( a -- )
;       Set  data stack pointer.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER SPSTO,3,"SP!"
        LDW     X,(X)     ;X = a
        RET     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       DROP    ( w -- )
;       Discard top stack item.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DROP,4,"DROP"
        ADDW X,#2     
        RET     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       DUP     ( w -- w w )
;       Duplicate  top stack item.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DUPP,3,"DUP"
	LDW Y,X
        SUBW X,#2
	LDW Y,(Y)
	LDW (X),Y
        RET     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       SWAP    ( w1 w2 -- w2 w1 )
;       Exchange top two stack items.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER SWAPP,4,"SWAP"
        LDW Y,X
        LDW Y,(Y)
        PUSHW Y  
        LDW Y,X
        LDW Y,(2,Y)
        LDW (X),Y
        POPW Y 
        LDW (2,X),Y
        RET     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       OVER    ( w1 w2 -- w1 w2 w1 )
;       Copy second stack item to top.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER OVER,4,"OVER"
        SUBW X,#CELLL
        LDW Y,X
        LDW Y,(2*CELLL,Y)
        LDW (X),Y
        RET     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       0<      ( n -- t )
;       Return true if n is negative.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER ZLESS,2,"0<"
        LD A,#0xFF
        LDW Y,X
        LDW Y,(Y)
        JRMI     ZL1
        CLR A   ;false
ZL1:    LD     (X),A
        LD (1,X),A
	RET     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       0= ( n -- f )
;   n==0?
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER ZEQUAL,2,"0="
        LD A,#0XFF 
        LDW Y,X 
        LDW Y,(Y)
        JREQ ZEQU1 
        LD A,#0 
ZEQU1:  
        LD (X),A 
        LD (1,X),A         
        RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       AND     ( w w -- w )
;       Bitwise AND.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER ANDD,3,"AND"
        LD  A,(X)    ;D=w
        AND A,(2,X)
        LD (2,X),A
        LD A,(1,X)
        AND A,(3,X)
        LD (3,X),A
        ADDW X,#2
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       OR      ( w w -- w )
;       Bitwise inclusive OR.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER ORR,2,"OR"
        LD A,(X)    ;D=w
        OR A,(2,X)
        LD (2,X),A
        LD A,(1,X)
        OR A,(3,X)
        LD (3,X),A
        ADDW X,#2
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       XOR     ( w w -- w )
;       Bitwise exclusive OR.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER XORR,3,"XOR"
        LD A,(X)    ;D=w
        XOR A,(2,X)
        LD (2,X),A
        LD A,(1,X)
        XOR A,(3,X)
        LD (3,X),A
        ADDW X,#2
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       UM+     ( u u -- udsum )
;       Add two unsigned single
;       and return a double sum.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER UPLUS,3,"UM+"
        LD A,#1
        LDW Y,X
        LDW Y,(2,Y)
        PUSHW Y 
        LDW Y,X
        LDW Y,(Y)
        ADDW Y,(1,SP) 
        LDW (2,X),Y
        JRC     UPL1
        CLR A
UPL1:   LD     (1,X),A
        CLR (X)
        _drop   2 
        RET

;; System and user variables

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       doVAR   ( -- a )
;       run time code 
;       for VARIABLE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       HEADER DOVAR,COMPO+5,"DOVAR"
DOVAR:
	SUBW X,#2
        POPW Y    ;get return addr (pfa)
        LDW (X),Y    ;push on stack
        RET     ;go to RET of EXEC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       BASE    ( -- a )
;       Radix base for numeric I/O.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER BASE,4,"BASE"
	LDW Y,#UBASE 
	SUBW X,#2
        LDW (X),Y
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       tmp     ( -- a )
;       A temporary storage.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER TEMP,3,"TMP"
	LDW Y,#UTMP
	SUBW X,#2
        LDW (X),Y
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       >IN     ( -- a )
;        Hold parsing pointer.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER INN,3,">IN"
	LDW Y,#UINN 
	SUBW X,#2
        LDW (X),Y
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       #TIB    ( -- a )
;       Count in terminal input 
;       buffer.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER NTIB,4,"#TIB"
	LDW Y,#UCTIB 
	SUBW X,#2
        LDW (X),Y
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       TBUF ( -- a )
;       address of 128 bytes 
;       transaction buffer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER TBUF,4,"TBUF"
        ldw y,#ROWBUFF
        subw x,#CELLL
        ldw (x),y 
        ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       "EVAL   ( -- a )
;       Execution vector of EVAL.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER TEVAL,5,"'EVAL"
	LDW Y,#UINTER 
	SUBW X,#2
        LDW (X),Y
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       HLD     ( -- a )
;       Hold a pointer of output
;        string.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER HLD,3,"HLD"
	LDW Y,#UHLD 
	SUBW X,#2
        LDW (X),Y
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       CONTEXT ( -- a )
;       Start vocabulary search.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER CNTXT,7,"CONTEXT"
	LDW Y,#UCNTXT
	SUBW X,#2
        LDW (X),Y
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       VP      ( -- a )
;       Point to top of variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER VPP,2,"VP"
	LDW Y,#UVP 
	SUBW X,#2
        LDW (X),Y
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       LAST    ( -- a )
;       Point to last name in 
;       dictionary.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER LAST,4,"LAST"
	LDW Y,#ULAST 
	SUBW X,#2
        LDW (X),Y
        RET

;; Common functions

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       ?DUP    ( w -- w w | 0 )
;       Dup tos if its is not zero.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER QDUP,4,"?DUP"
        LDW Y,X
	LDW Y,(Y)
        JREQ     QDUP1
	SUBW X,#CELLL 
        LDW (X),Y
QDUP1:  RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       ROT     ( w1 w2 w3 -- w2 w3 w1 )
;       Rot 3rd item to top.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER ROT,3,"ROT"
        ldw y,x 
        ldw y,(y)
        pushw y 
        ldw y,x 
        ldw y,(4,y)
        ldw (x),y 
        ldw y,x 
        ldw y,(2,y)
        ldw (4,x),y 
        popw y 
        ldw (2,x),y
        ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    <ROT ( n1 n2 n3 -- n3 n1 n2 )
;    rotate left 3 top elements 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    _HEADER NROT,4,"<ROT"
    LDW Y,X 
    LDW Y,(Y)
    PUSHW Y ; n3 >R 
    LDW Y,X 
    LDW Y,(2,Y) ; Y = n2 
    LDW (X),Y   ; TOS = n2 
    LDW Y,X    
    LDW Y,(4,Y) ; Y = n1 
    LDW (2,X),Y ;   = n1 
    POPW Y  ; R> Y 
    LDW (4,X),Y ; = n3 
    RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       2DROP   ( w w -- )
;       Discard two items on stack.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DDROP,5,"2DROP"
        ADDW X,#4
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       2DUP    ( w1 w2 -- w1 w2 w1 w2 )
;       Duplicate top two items.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DDUP,4,"2DUP"
        SUBW X,#2*CELLL 
        LDW Y,X
        LDW Y,(3*CELLL,Y)
        LDW (CELLL,X),Y
        LDW Y,X
        LDW Y,(2*CELLL,Y)
        LDW (X),Y
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       +       ( w w -- sum )
;       Add top two items.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER PLUS,1,"+"
        LDW Y,X
        LDW Y,(Y)
        PUSHW   Y 
        ADDW X,#2
        LDW Y,X
        LDW Y,(Y)
        ADDW Y,(1,SP)
        LDW (X),Y
        _drop 2 
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       TRUE ( -- -1 )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER TRUE,4,"TRUE"
        LD A,#255 
        SUBW X,#CELLL
        LD (X),A 
        LD (1,X),A 
        RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       FALSE ( -- 0 )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER FALSE,5,"FALSE"
        SUBW X,#CELLL 
        CLR (X) 
        CLR (1,X)
        RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       NOT     ( w -- w )
;       One's complement of tos.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER INVER,3,"NOT"
        LDW Y,X
        LDW Y,(Y)
        CPLW Y
        LDW (X),Y
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       NEGATE  ( n -- -n )
;       Two's complement of tos.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER NEGAT,6,"NEGATE"
        LDW Y,X
        LDW Y,(Y)
        NEGW Y
        LDW (X),Y
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       DNEGATE ( d -- -d )
;       Two's complement of double.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DNEGA,7,"DNEGATE"
        LDW Y,X
	LDW Y,(Y)
        CPLW Y
        PUSHW Y      ; Y >R 
        LDW Y,X
        LDW Y,(2,Y)
        CPLW Y
        ADDW Y,#1
        LDW (2,X),Y
        POPW Y       ; R> Y  
        JRNC DN1 
        INCW Y
DN1:    LDW (X),Y
        RET


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       S>D ( n -- d )
; convert single integer to double 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER STOD,3,"S>D"
        SUBW X,#CELLL 
        CLR (X) 
        CLR (1,X) 
        LDW Y,X 
        LDW Y,(2,Y)
        JRPL 1$
        LDW Y,#-1 
        LDW (X),Y 
1$:     RET 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       -       ( n1 n2 -- n1-n2 )
;       Subtraction.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER SUBB,1,"-"
        LDW Y,X
        LDW Y,(Y) ; n2 
        PUSHW Y 
        ADDW X,#CELLL 
        LDW Y,X
        LDW Y,(Y) ; n1 
        SUBW Y,(1,SP) ; n1-n2 
        LDW (X),Y
        _drop 2 
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       ABS     ( n -- n )
;       Return  absolute value of n.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER ABSS,3,"ABS"
        LDW Y,X
	LDW Y,(Y)
        JRPL     AB1     ;negate:
        NEGW     Y     ;else negate hi byte
        LDW (X),Y
AB1:    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       =       ( w w -- t )
;       Return true if top two are equal.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER EQUAL,1,"="
        LD A,#0xFF  ;true
        LDW Y,X    
        LDW Y,(Y)   ; n2 
        ADDW X,#CELLL 
        CPW Y,(X)   ; n1==n2
        JREQ EQ1 
        CLR A 
EQ1:    LD (X),A
        LD (1,X),A
	RET     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       U<      ( u1 u2 -- f )
;       Unsigned compare of top two items.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER ULESS,2,"U<"
        LD A,#0xFF  ;true
        LDW Y,X    
        LDW Y,(2,Y) ; u1 
        CPW Y,(X)   ; cpw u1  u2 
        JRULT     ULES1
        CLR A
ULES1:  ADDW X,#CELLL 
        LD (X),A
        LD (1,X),A
	RET     


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       <       ( n1 n2 -- t )
;       Signed compare of top two items.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER LESS,1,"<"
        LD A,#0xFF  ;true
        LDW Y,X    
        LDW Y,(2,Y)  ; n1 
        CPW Y,(X)  ; n1 < n2 ? 
        JRSLT     LT1
        CLR A
LT1:    ADDW X,#CELLL 
        LD (X),A
        LD (1,X),A
	RET     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   U> ( u1 u2 -- f )
;   f = true if u1>u2 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER UGREAT,2,"U>"
        LD A,#255  
        LDW Y,X 
        LDW Y,(2,Y)  ; u1 
        CPW Y,(X)  ; u1 > u2 
        JRUGT UGREAT1 
        CLR A   
UGREAT1:
        ADDW X,#CELLL 
        LD (X),A 
        LD (1,X),A 
        RET 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       >   (n1 n2 -- f )
;  signed compare n1 n2 
;  true if n1 > n2 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER GREAT,1,">"
        LD A,#0xFF ;
        LDW Y,X 
        LDW Y,(2,Y)  ; n1 
        CPW Y,(X) ; n1 > n2 ?  
        JRSGT GREAT1 
        CLR  A
GREAT1:
        ADDW X,#CELLL 
        LD (X),A 
        LD (1,X),A 
        RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       MAX     ( n n -- n )
;       Return greater of two top items.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER MAX,3,"MAX"
        LDW Y,X    
        LDW Y,(Y) ; n2 
        CPW Y,(2,X)   
        JRSLT  MAX1
        LDW (2,X),Y
MAX1:   ADDW X,#2
	RET     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       MIN     ( n n -- n )
;       Return smaller of top two items.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER MIN,3,"MIN"
        LDW Y,X    
        LDW Y,(Y)  ; n2 
        CPW Y,(2,X) 
        JRSGT MIN1
        LDW (2,X),Y
MIN1:	ADDW X,#2
	RET     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       WITHIN  ( u ul uh -- t )
;       Return true if u is within
;       range of ul and uh. ( ul <= u < uh )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER WITHI,6,"WITHIN"
        CALL     OVER
        CALL     SUBB
        CALL     TOR
        CALL     SUBB
        CALL     RFROM
        JP     ULESS

;; Divide

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       UM/MOD  ( udl udh un -- ur uq )
;       Unsigned divide of a double by a
;       single. Return mod and quotient.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 2021-02-22
; changed algorithm for Jeeek one 
; ref: https://github.com/TG9541/stm8ef/pull/406        
        _HEADER UMMOD,6,"UM/MOD"
        LDW     Y,X             ; stack pointer to Y
        LDW     X,(X)           ; un
        LDW     acc16,X         ; save un
        LDW     X,Y
        INCW    X               ; drop un
        INCW    X
        PUSHW   X               ; save stack pointer
        LDW     X,(X)           ; X=udh
        JRNE    MMSM0
        LDW    X,(1,SP)
        LDW    X,(2,X)          ; udl 
        LDW     Y,acc16         ;divisor 
        DIVW    X,Y             ; udl/un 
        EXGW    X,Y 
        JRA     MMSMb 
MMSM0:    
        LDW     Y,(4,Y)         ; Y=udl (offset before drop)
        CPW     X,acc16
        JRULT   MMSM1           ; X is still on the R-stack
        POPW    X               ; restore stack pointer
        CLRW    Y
        LDW     (2,X),Y         ; remainder 0
        DECW    Y
        LDW     (X),Y           ; quotient max. 16 bit value
        RET
MMSM1:
        LD      A,#16           ; loop count
        SLLW    Y               ; udl shift udl into udh
MMSM3:
        RLCW    X               ; rotate udl bit into uhdh (= remainder)
        JRC     MMSMa           ; if carry out of rotate
        CPW     X,acc16         ; compare udh to un
        JRULT   MMSM4           ; can't subtract
MMSMa:
        SUBW    X,acc16         ; can subtract
        RCF
MMSM4:
        CCF                     ; quotient bit
        RLCW    Y               ; rotate into quotient, rotate out udl
        DEC     A               ; repeat
        JRNE    MMSM3           ; if A == 0
MMSMb:
        LDW     acc16,X         ; done, save remainder
        POPW    X               ; restore stack pointer
        LDW     (X),Y           ; save quotient
        LDW     Y,acc16         ; remainder onto stack
        LDW     (2,X),Y
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   U/MOD ( u1 u2 -- ur uq )
;   unsigned divide u1/u2 
;   return remainder and quotient 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER USLMOD,5,"U/MOD"
        LDW Y,X 
        LDW Y,(Y)  ; dividend 
        PUSHW X    ; DP >R 
        LDW X,(2,X) ; divisor 
        DIVW X,Y 
        PUSHW X     ; quotient 
        LDW X,(3,SP) ; DP 
        LDW (2,X),Y ; remainder 
        LDW Y,(1,SP) ; quotient 
        LDW (X),Y 
        ADDW SP,#2*CELLL ; drop quotient and DP from rstack 
        RET 



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;       M/MOD   ( d n -- r q )
;       Signed floored divide of double by
;       single. Return mod and quotient.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER MSMOD,5,"M/MOD"
        CALL	DUPP
        CALL	ZLESS
        CALL	DUPP
        CALL	TOR
        CALL	QBRAN
        .word	MMOD1
        CALL	NEGAT
        CALL	TOR
        CALL	DNEGA
        CALL	RFROM
MMOD1:	CALL	TOR
        CALL	DUPP
        CALL	ZLESS
        CALL	QBRAN
        .word	MMOD2
        CALL	RAT
        CALL	PLUS
MMOD2:	CALL	RFROM
        CALL	UMMOD
        CALL	RFROM
        CALL	QBRAN
        .word	MMOD3
        CALL	SWAPP
        CALL	NEGAT
        JP	SWAPP
MMOD3:	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       /MOD    ( n1 n2 -- r q )
;       Signed divide n1/n2. 
;       Return mod and quotient.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER SLMOD,4,"/MOD"
        LD A,(X)
        PUSH A   ; n2 sign 
        LD A,(2,X)
        PUSH A    ; n1 sign 
        CALL ABSS 
        CALL TOR  ; 
        CALL ABSS 
        CALL RAT   
        CALL USLMOD 
        LD A,(3,SP)
        OR A,(4,SP)
        JRPL SLMOD8 ; both positive nothing to change 
        LD A,(3,SP)
        XOR A,(4,SP)
        JRPL SLMOD1
; dividend and divisor are opposite sign          
        CALL NEGAT ; negative quotient
        CALL OVER 
        CALL ZEQUAL 
        _TBRAN SLMOD8 
        CALL ONEM   ; add one to quotient 
        CALL RAT 
        CALL ROT 
        CALL SUBB  ; corrected_remainder=divisor-remainder 
        CALL SWAPP
SLMOD1:
        LD A,(4,SP) ; divisor sign 
        JRPL SLMOD8 
        CALL TOR 
        CALL NEGAT ; if divisor negative negate remainder 
        CALL RFROM 
SLMOD8: 
        ADDW SP,#4 
        RET 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       MOD     ( n n -- r )
;       Signed divide. Return mod only.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER MODD,3,"MOD"
	CALL	SLMOD
	JP	DROP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       /       ( n n -- q )
;       Signed divide. Return quotient only.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER SLASH,1,"/"
        CALL	SLMOD
        CALL	SWAPP
        JP	DROP

;; Multiply

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       UM*     ( u1 u2 -- ud )
;       Unsigned multiply. Return 
;       double product.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER UMSTA,3,"UM*"
; stack have 4 bytes u1=a:b u2=c:d
        ;; bytes offset on data stack 
        u1hi=2 
        u1lo=3 
        u2hi=0 
        u2lo=1 
        ;;;;;; local variables ;;;;;;;;;
        ;; product bytes offset on return stack 
        UD1=1  ; ud bits 31..24
        UD2=2  ; ud bits 23..16
        UD3=3  ; ud bits 15..8 
        UD4=4  ; ud bits 7..0 
        ;; local variable for product set to zero   
        clrw y 
        pushw y  ; bits 15..0
        pushw y  ; bits 31..16 
        ld a,(u1lo,x) ;  
        ld yl,a 
        ld a,(u2lo,x)   ; 
        mul y,a    ; u1lo*u2lo  
        ldw (UD3,sp),y ; lowest weight product 
        ld a,(u1lo,x)
        ld yl,a 
        ld a,(u2hi,x)
        mul y,a  ; u1lo*u2hi 
        ;;; do the partial sum 
        addw y,(UD2,sp)
        clr a 
        rlc a
        ld (UD1,sp),a 
        ldw (UD2,sp),y 
        ld a,(u1hi,x)
        ld yl,a 
        ld a,(u2lo,x)
        mul y,a   ; u1hi*u2lo  
        ;; do partial sum 
        addw y,(UD2,sp)
        clr a 
        adc a,(UD1,sp)
        ld (UD1,sp),a  
        ldw (UD2,sp),y 
        ld a,(u1hi,x)
        ld yl,a 
        ld a,(u2hi,x)
        mul y,a  ;  u1hi*u2hi highest weight product 
        ;;; do partial sum 
        addw y,(UD1,sp)
        ldw (x),y  ; udh 
        ldw y,(UD3,sp)
        ldw (2,x),y  ; udl  
        addw sp,#4 ; drop local variable 
        ret  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       *       ( n n -- n )
;       Signed multiply. Return 
;       single product.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER STAR,1,"*"
	CALL	UMSTA
        _TDROP 
        RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       M*      ( n n -- d )
;       Signed multiply. Return 
;       double product.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER MSTAR,2,"M*"
        CALL	DDUP
        CALL	XORR
        CALL	ZLESS
        CALL	TOR
        CALL	ABSS
        CALL	SWAPP
        CALL	ABSS
        CALL	UMSTA
        CALL	RFROM
        CALL	QBRAN
        .word	MSTA1
        JP	DNEGA
MSTA1:	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       */MOD   ( n1 n2 n3 -- r q )
;       Multiply n1 and n2, then divide
;       by n3. Return mod and quotient.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER SSMOD,5,"*/MOD"
        CALL     TOR
        CALL     MSTAR
        CALL     RFROM
        JP     MSMOD

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       */      ( n1 n2 n3 -- q )
;       Multiply n1 by n2, then divide
;       by n3. Return quotient only.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER STASL,2,"*/"
        CALL	SSMOD
        CALL	SWAPP
        JP	DROP

;; Miscellaneous

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       2+   ( a -- a )
;       Add cell size in byte to address.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER CELLP,2,"2+"
        LDW Y,X
	LDW Y,(Y)
        ADDW Y,#CELLL 
        LDW (X),Y
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       2-   ( a -- a )
;       Subtract 2 from address.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER CELLM,2,"2-"
        LDW Y,X
	LDW Y,(Y)
        SUBW Y,#CELLL
        LDW (X),Y
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       2*   ( n -- n )
;       Multiply tos by 2.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER TWOSTAR,2,"2*"        
        LDW Y,X
	LDW Y,(Y)
        SLAW Y
        LDW (X),Y
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       1+      ( a -- a )
;       Add cell size in byte 
;       to address.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER ONEP,2,"1+"
        LDW Y,X
	LDW Y,(Y)
        INCW Y
        LDW (X),Y
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       1-      ( a -- a )
;       Subtract 2 from address.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER ONEM,2,"1-"
        LDW Y,X
	LDW Y,(Y)
        DECW Y
        LDW (X),Y
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  shift left n times 
; LSHIFT ( n1 n2 -- n1<<n2 )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER LSHIFT,6,"LSHIFT"
        ld a,(1,x)
        addw x,#CELLL 
        ldw y,x 
        ldw y,(y)
LSHIFT1:
        tnz a 
        jreq LSHIFT4 
        sllw y 
        dec a 
        jra LSHIFT1 
LSHIFT4:
        ldw (x),y 
        ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; shift right n times                 
; RSHIFT (n1 n2 -- n1>>n2 )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER RSHIFT,6,"RSHIFT"
        ld a,(1,x)
        addw x,#CELLL 
        ldw y,x 
        ldw y,(y)
RSHIFT1:
        tnz a 
        jreq RSHIFT4 
        srlw y 
        dec a 
        jra RSHIFT1 
RSHIFT4:
        ldw (x),y 
        ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       2/      ( n -- n )
;       divide  tos by 2.
;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER TWOSL,2,"2/"
        LDW Y,X
	LDW Y,(Y)
        SRAW Y
        LDW (X),Y
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       BL      ( -- 32 )
;       Return 32,  blank character.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER BLANK,2,"BL"
        SUBW X,#2
	LDW Y,#32
        LDW (X),Y
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;         0     ( -- 0)
;         Return 0.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER ZERO,1,"0"
        SUBW X,#2
	CLRW Y
        LDW (X),Y
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;         1     ( -- 1)
;         Return 1.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER ONE,1,"1"
        SUBW X,#2
	LDW Y,#1
        LDW (X),Y
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;         -1    ( -- -1)
;   Return -1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER MONE,2,"-1"
        SUBW X,#2
	LDW Y,#0xFFFF
        LDW (X),Y
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       >CHAR   ( c -- c )
;       Filter non-printing characters.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER TCHAR,5,">CHAR"
        ld a,(1,x)
        cp a,#32  
        jrmi 1$ 
        cp a,#127 
        jrpl 1$ 
        ret 
1$:     ld a,#'_ 
        ld (1,x),a 
        ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       DEPTH   ( -- n )
;       Return  depth of  data stack.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DEPTH,5,"DEPTH"
        LDW Y,SP0    ;save data stack ptr
	PUSHW X 
        SUBW Y,(1,sp)     ;#bytes = SP0 - X
        SRAW Y    ;Y = #stack items
	SUBW X,#2
        LDW (X),Y     ; if neg, underflow
        _drop 2 
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       PICK    ( ... +n -- ... w )
;       Copy  nth stack item to tos.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER PICK,4,"PICK"
        LDW Y,X   ;D = n1
        LDW Y,(Y)
; modified for standard compliance          
; 0 PICK must be equivalent to DUP 
        INCW Y 
        SLAW Y
        PUSHW X
        ADDW Y,(1,SP)
        LDW Y,(Y)
        LDW (X),Y
        _drop 2 
        RET

;; Memory access

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       +!      ( n a -- )
;       Add n to  contents at 
;       address a.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER PSTOR,2,"+!"
        PUSHW X   ; R: DP 
        LDW Y,X 
        LDW X,(X) ; a 
        LDW Y,(2,Y)  ; n 
        PUSHW Y      ; R: DP n 
        LDW Y,X 
        LDW Y,(Y)
        ADDW Y,(1,SP) ; *a + n 
        LDW (X),Y 
        LDW X,(3,SP) ; DP
        ADDW X,#2*CELLL  ; ( n a -- )  
        ADDW SP,#2*CELLL ; R: DP n -- 
        RET 
                

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       2!      ( d a -- )
;       Store  double integer 
;       to address a.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DSTOR,2,"2!"
        LDW Y,X 
        PUSHW X 
        LDW X,(X) ; a 
        LDW Y,(2,Y) ; dhi 
        LDW (X),Y 
        LDW Y,(1,SP)  
        LDW Y,(4,Y) ; dlo 
        LDW (2,X),Y  
        POPW X 
        ADDW X,#3*CELLL 
        RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       2@      ( a -- d )
;       Fetch double integer 
;       from address a.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DAT,2,"2@"
        ldw y,x 
        subw x,#CELLL 
        ldw y,(y) ;address 
        pushw y  
        ldw y,(y) ; dhi 
        ldw (x),y 
        popw y 
        ldw y,(2,y) ; dlo 
        ldw (2,x),y 
        ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       COUNT   ( b -- b +n )
;       Return count byte of a string
;       and add 1 to byte address.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER COUNT,5,"COUNT"
        ldw y,x 
        ldw y,(y) ; address 
        ld a,(y)  ; count 
        incw y 
        ldw (x),y 
        subw x,#CELLL 
        ld (1,x),a 
        clr (x)
        ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       HERE    ( -- a )
;       Return  top of  variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER HERE,4,"HERE"
      	ldw y,#UVP 
        ldw y,(y)
        subw x,#CELLL 
        ldw (x),y 
        ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       PAD     ( -- a )
;       Return address of text buffer
;       above  code dictionary.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER PAD,3,"PAD"
        CALL     HERE
        _DOLIT   80
        JP     PLUS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       TIB     ( -- a )
;       Return address of 
;       terminal input buffer.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER TIB,3,"TIB"
        SUBW    X,#CELLL
        LDW     Y,UTIB  
        LDW     (X),Y
        RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       @EXECUTE        ( a -- )
;       Execute vector stored in 
;       address a.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER ATEXE,8,"@EXECUTE"
        CALL     AT
        CALL     QDUP    ;?address or zero
        CALL     QBRAN
        .word      EXE1
        CALL     EXECU   ;execute if non-zero
EXE1:   RET     ;do nothing if zero

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       CMOVE   ( b1 b2 u -- )
;       Copy u bytes from b1 to b2.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER CMOVE,5,"CMOVE"
        ;;;;  local variables ;;;;;;;
        DP = 5
        YTMP = 3 
        CNT  = 1 
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        PUSHW X  ; R: DP  
        SUB SP,#2 ; R: DP YTMP 
        LDW Y,X 
        LDW Y,(Y) ; CNT 
        PUSHW Y  ; R: DP YTMP CNT
        LDW Y,X 
        LDW Y,(2,Y) ; b2, dest 
        LDW X,(4,X) ; b1, src 
        LDW (YTMP,SP),Y 
        CPW X,(YTMP,SP) 
        JRUGT CMOV2  ; src>dest 
; src<dest copy from top to bottom
        ADDW X,(CNT,SP)
        ADDW Y,(CNT,SP)
CMOV1:  
        LDW (YTMP,SP),Y 
        LDW Y,(CNT,SP)
        JREQ CMOV3 
        DECW Y 
        LDW (CNT,SP),Y 
        LDW Y,(YTMP,SP)
        DECW X
        LD A,(X)
        DECW Y 
        LD (Y),A 
        JRA CMOV1
; src>dest copy from bottom to top   
CMOV2: 
        LDW (YTMP,SP),Y 
        LDW Y,(CNT,SP)
        JREQ CMOV3
        DECW Y 
        LDW (CNT,SP),Y 
        LDW Y,(YTMP,SP)
        LD A,(X)
        INCW X 
        LD (Y),A 
        INCW Y 
        JRA CMOV2 
CMOV3:
        LDW X,(DP,SP)
        ADDW X,#3*CELLL 
        ADDW SP,#3*CELLL 
        RET 
        

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       FILL    ( b u c -- )
;       Fill u bytes of character c
;       to area beginning at b.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER FILL,4,"FILL"
        LD A,(1,X)
        LDW Y,X 
        ADDW X,#3*CELLL 
        PUSHW X ; R: DP 
        LDW X,Y 
        LDW X,(4,X) ; b
        LDW Y,(2,Y) ; u
FILL0:
        JREQ FILL1
        LD (X),A 
        INCW X 
        DECW Y 
        JRA FILL0         
FILL1: POPW X 
        RET         
        

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       ERASE   ( b u -- )
;       Erase u bytes beginning at b.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER ERASE,5,"ERASE"
        clrw y 
        subw x,#CELLL 
        ldw (x),y 
        jp FILL 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       PACK0   ( b u a -- a )
;       Build a counted string with
;       u characters from b. Null fill.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER PACKS,5,"PACK0"
        CALL     DUPP
        CALL     TOR     ;strings only on cell boundary
        CALL     DDUP
        CALL     CSTOR
        CALL     ONEP ;save count
        CALL     SWAPP
        CALL     CMOVE
        CALL     RFROM
        RET

;; Numeric output, single precision

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       DIGIT   ( u -- c )
;       Convert digit u to a character.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DIGIT,5,"DIGIT"
        CALL	DOLIT
        .word	9
        CALL	OVER
        CALL	LESS
        CALL	DOLIT
        .word	7
        CALL	ANDD
        CALL	PLUS
        CALL	DOLIT
        .word	48	;'0'
        JP	PLUS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       EXTRACT ( n base -- n c )
;       Extract least significant 
;       digit from n.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER EXTRC,7,"EXTRACT"
        CALL     ZERO
        CALL     SWAPP
        CALL     UMMOD
        CALL     SWAPP
        JP     DIGIT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       <#      ( -- )
;       Initiate  numeric 
;       output process.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER BDIGS,2,"#<"
        CALL     PAD
        CALL     HLD
        JP     STORE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       HOLD    ( c -- )
;       Insert a character 
;       into output string.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER HOLD,4,"HOLD"
        CALL     HLD
        CALL     AT
        CALL     ONEM
        CALL     DUPP
        CALL     HLD
        CALL     STORE
        JP     CSTOR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       #       ( u -- u )
;       Extract one digit from u and
;       append digit to output string.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DIG,1,"#"
        CALL     BASE
        CALL     AT
        CALL     EXTRC
        JP     HOLD

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       #S      ( u -- 0 )
;       Convert u until all digits
;       are added to output string.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DIGS,2,"#S"
DIGS1:  CALL     DIG
        CALL     DUPP
        CALL     QBRAN
        .word      DIGS2
        JRA     DIGS1
DIGS2:  RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       SIGN    ( n -- )
;       Add a minus sign to
;       numeric output string.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER SIGN,4,"SIGN"
        CALL     ZLESS
        CALL     QBRAN
        .word      SIGN1
        CALL     DOLIT
        .word      45	;"-"
        JP     HOLD
SIGN1:  RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       #>      ( w -- b u )
;       Prepare output string.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER EDIGS,2,"#>"
        CALL     DROP
        CALL     HLD
        CALL     AT
        CALL     PAD
        CALL     OVER
        JP     SUBB

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       str     ( w -- b u )
;       Convert a signed integer
;       to a numeric string.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER STR,3,"STR"
        CALL     DUPP
        CALL     TOR
        CALL     ABSS
        CALL     BDIGS
        CALL     DIGS
        CALL     RFROM
        CALL     SIGN
        JP     EDIGS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       HEX     ( -- )
;       Use radix 16 as base for
;       numeric conversions.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER HEX,3,"HEX"
        CALL     DOLIT
        .word      16
        CALL     BASE
        JP     STORE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       DECIMAL ( -- )
;       Use radix 10 as base
;       for numeric conversions.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DECIM,7,"DECIMAL"
        CALL     DOLIT
        .word      10
        CALL     BASE
        JP     STORE

;; Numeric input, single precision

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       DIGIT?  ( c base -- u t )
;       Convert a character to its numeric
;       value. A flag indicates success.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DIGTQ,6,"DIGIT?"
        CALL     TOR
        CALL     DOLIT
        .word     48	; "0"
        CALL     SUBB
        CALL     DOLIT
        .word      9
        CALL     OVER
        CALL     LESS
        CALL     QBRAN
        .word      DGTQ1
        CALL     DOLIT
        .word      7
        CALL     SUBB
        CALL     DUPP
        CALL     DOLIT
        .word      10
        CALL     LESS
        CALL     ORR
DGTQ1:  CALL     DUPP
        CALL     RFROM
        JP     ULESS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; move parse to next char 
; input:
;   a    string pointer 
;   cnt  string length 
; output:
;    a    a+1 
;    cnt  cnt-1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NEXT_CHAR:: ; ( a cnt -- a cnt )
; increment a 
    INC (CELLL+1,X) 
    JRNE 1$
    INC (CELLL,X)
1$: ; decrement cnt 
    LDW Y,X 
    LDW Y,(Y)
    DECW Y 
    LDW (X),Y
    RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; check if first character of string
; is 'c' 
; if true 
;     return  a++ cnt-- -1  
; else 
;   return a cnt 0 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ACCEPT_CHAR:: ; ( a cnt c -- a cnt 0|-1 )
    CALL TOR ; a cnt r: c 
; exit if end of string, cnt==0? 
    LD A,(1,X) ; cnt always < 256 
    JRNE 1$
    JRA 2$ 
1$: LDW Y,X 
    LDW Y,(CELLL,Y) ; a 
    LD A,(Y)
    CP A,(2,SP) ; c 
    JRNE 2$
; accept c
    CALL NEXT_CHAR      
    _DOLIT -1
    JRA 4$  
2$: ; ignore char 
    _DOLIT 0
4$: ADDW SP,#CELLL ; drop c 
    RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;
; check for negative sign 
; ajust pointer and cnt
; input:
;    a        string pointer 
;    cnt      string length
; output:
;    a       adjusted pointer 
;    cnt     adjusted count
;    f       boolean flag, true if '-'  
;;;;;;;;;;;;;;;;;;;;;;;;;;;
NSIGN: ; ( a cnt -- a cnt f ) 
    SUBW X,#CELLL ; a cntr f 
    PUSH #0 
; if count==0 exit 
    LD A,(CELLL+1,X)
    JREQ NO_ADJ 
    LDW Y,X 
    LDW Y,(2*CELLL,Y) ; a 
    LD A,(Y) ; char=*a  
    CP A,#'-' 
    JREQ NEG_SIGN
    CP A,#'+' 
    JREQ ADJ_CSTRING
    JP NO_ADJ  
NEG_SIGN:
    CPL (1,SP)
ADJ_CSTRING: 
; increment a 
    INCW Y ; a++ 
    LDW (2*CELLL,X),Y 
; decrement cnt 
    DEC (CELLL+1,X)    
NO_ADJ: 
    POP A 
    LD (X),A 
    LD (1,X),A 
    RET 

.ifeq  WANT_DOUBLE  
; this code included only if WANT_DOUBLE=0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; skip digits,stop at first non digit.
; count skipped digits 
; input:
;    a     string address 
;    cnt   charaters left in string 
; output:
;    a+         updated a 
;    cnt-       updated cnt
;    skip       digits skipped 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
; local variables
        CNT = 1 ; byte
        SKIP = 2 ; byte 
        VARS_SIZE=2        
SKIP_DIGITS: ; ( a cnt -- a+ cnt- skip )
        _VARS VARS_SIZE ; space on rstack for local vars 
        CLR (SKIP,SP)
        LD A,(1,X); cnt 
        LD (CNT,SP),A 
        _TDROP ; drop cnt from stack 
1$:     TNZ (CNT,SP)
        JREQ 8$
        CALL COUNT  
        CALL BASE 
        CALL AT 
        CALL DIGTQ 
        _QBRAN 6$ ; not a digit
        INC (SKIP,SP)
        DEC (CNT,SP)
        _TDROP ; c 
        JRA 1$ 
6$:     _TDROP ; c 
        CALL ONEM ; a--         
8$:     SUBW X,#2*CELLL ; space for cnt- 
        CLRW Y 
        LD A,(SKIP,SP)
        LD YL,A 
        LDW (X),Y 
        LD A,(CNT,SP)
        LD YL,A 
        LDW (CELLL,X),Y ;  
        _DROP_VARS VARS_SIZE ; discard local vars 
        RET 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; get all digits in row 
; stop at first non-digit or end of string
; ( n a cnt -- n  a+ cnt- digits )
; input:
;   n    initial value of integer 
;   a    string address 
;   cnt  # chars in string 
; output:
;   n    integer value after parse 
;   a+   incremented a 
;   cnt- decremented cnt 
;   f_skip  -1 ->       some digits have been skip  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; local variables 
        SKIP=4 ;byte # digits skipped   
        UINT=2   ;word 
        CNT=1    ; byte 
        VARS_SIZE=4
parse_digits: ; ( n a cnt -- n  a+ cnt- skip )
    SUB SP,#VARS_SIZE
    CLR (SKIP,SP)
    LD A,(1,X) ; count 
    LD (CNT,SP),A 
    _TDROP ; drop cnt from stack 
    LDW Y,X 
    LDW Y,(CELLL,Y) ; n 
    LDW (UINT,SP),Y  
0$:
    TNZ (CNT,SP)
    JREQ 9$ 
1$: CALL COUNT ; n a+ char 
    CALL BASE 
    CALL AT 
    CALL DIGTQ 
    _QBRAN 8$ ; not a digit
    DEC (CNT,SP)
    SUBW X,#CELLL 
    LDW Y,(UINT,SP)
    LDW (X),Y 
    CALL BASE 
    CALL AT 
    CALL UMSTA ; u u -- ud 
; check for overflow 
    LDW Y,X 
    LDW Y,(Y)
    _TDROP ; ud hi word 
    TNZW Y 
    JREQ 4$ ; no overflow yet 
; when overflow count following digits 
; but don't integrate them in UINT 
; round last value of UINT 
    _TDROP  ; ud low word 
    CALL BASE
    CALL AT  
    CALL TWOSL 
    CALL LESS ; last_digit < BASE/2 ? 
    _TBRAN 2$  ; no rounding 
; round up UINT 
    LDW Y,(UINT,SP)
    INCW Y 
    LDW (UINT,SP),Y 
2$: CALL ONEM ; a-- 
    INC (CNT,SP) ; cnt++
    LDW Y,(UINT,SP)
    LDW (CELLL,X),Y 
    SUBW X,#CELLL ; space for count 
    LD A,(CNT,SP)
    CLRW Y 
    LD YL,A 
    LDW (X),Y ; n a+ cnt- 
    CALL SKIP_DIGITS ; n a+ cnt- skip  
    JRA 10$     
4$: 
    CALL PLUS ; udlo+digit  
    LDW Y,X 
    LDW Y,(Y) ; n 
    LDW (UINT,SP),Y 
    _TDROP ; sum from stack 
    JRA 0$ 
8$: ; n a+ char
    _TDROP ; drop char 
    CALL ONEM ; decrement a 
9$: ; no more digits 
    LDW Y,(UINT,SP)
    LDW (CELLL,X),Y ; 
    SUBW X,#2*CELLL ; make space for cnt- digits 
    LD A,(CNT,SP)
    CLRW Y 
    LD YL,A 
    LDW (CELLL,X),Y ; u a+ cnt- 
    LD A,(SKIP,SP)
    LD YL,A 
    LDW (X),Y ; u a+ cnt- digits 
10$:
    _DROP_VARS VARS_SIZE  ; dicard local variables 
    RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       NUMBER? ( a -- n T | a F )
;       Convert a number string to
;       integer. Push a flag on tos.
;  if integer parse fail because of extra 
;  character in string and WANT_FLOAT24=1 
;  in config.inc then jump to FLOAT? in
;  float24.asm
; 
; accepted number format:
;    decimal ::= ['-'|'+']dec_digits+
;    hexadecimal ::= ['-'|'+']'$'hex_digits+
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER NUMBQ,7,"NUMBER?"
; save BASE
        CALL     BASE
        CALL     AT
        CALL     TOR
        CALL     ZERO
        CALL     OVER
        CALL     COUNT ; string length,  a 0 a+ cnt 
; check for negative number 
        CALL    NSIGN 
        CALL    TOR    ; save number sign 
;  check hexadecimal character        
        _DOLIT  '$'
        CALL    ACCEPT_CHAR 
        _QBRAN  1$ 
        CALL    HEX 
1$: ; stack: a 0 a cnt r: base sign 
        CALL     parse_digits ; a 0 a+ cnt- -- a n a+ cnt- skip R: base sign
        CALL    OVER 
        _TBRAN  NUMQ6 
        _DROPN 3   ; a n  R: base sign 
        CALL     RFROM   ; a n sign R: base 
        _QBRAN   NUMQ3
        CALL     NEGAT ; a n R: base 
NUMQ3:  
        CALL    SWAPP ; n a 
        LDW  Y, #-1 
        LDW (X),Y     ; n -1 R: base 
        JRA      NUMQ9
NUMQ6:  
.if WANT_FLOAT24 
; float24 installed try floating point number  
        JP    FLOATQ  ; a n a+ cnt- skip R: base sign   
.else ; error unknown token 
        _RDROP ; remove sign from rstack 
        ADDW  X,#3*CELLL ; drop a+ cnt skip S: a n  R: base  
        CLRW Y  
        LDW (X),Y  ;  a 0 R: base 
.endif 
; restore BASE 
NUMQ9: 
        CALL     RFROM
        CALL     BASE
        JP       STORE
.endif ; WANT_DOUBLE   

;; Basic I/O

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       KEY     ( -- c )
;       Wait for and return an
;       input character.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER KEY,3,"KEY"
        call uart_getc
        SUBW X,#CELLL 
        CLR (X)
        LD (1,X),A 
        RET  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       NUF?    ( -- t )
;       Return false if no input,
;       else pause and if CR return true.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER NUFQ,4,"NUF?"
        CALL     QKEY
        CALL     DUPP
        CALL     QBRAN
        .word    NUFQ1
        CALL     DDROP
        CALL     KEY
        CALL     DOLIT
        .word      CRR
        JP     EQUAL
NUFQ1:  RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       SPACE   ( -- )
;       Send  blank character to
;       output device.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER SPAC,5,"SPACE"
        CALL     BLANK
        JP     EMIT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       SPACES  ( +n -- )
;       Send n spaces to output device.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER SPACS,6,"SPACES"
        CALL     ZERO
        CALL     MAX
        CALL     TOR
        JRA      SPAC2
SPAC1:  CALL     SPAC
SPAC2:  CALL     DONXT
        .word    SPAC1
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       TYPE    ( b u -- )
;       Output u characters from b.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER TYPES,4,"TYPE"
        CALL     TOR
        JRA     TYPE2
TYPE1:  CALL     COUNT 
        CALL     EMIT
TYPE2:  _DONXT  TYPE1
        _TDROP
        RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       CR      ( -- )
;       Output a carriage return
;       and a line feed.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER CRLF,2,"CR"
        _DOLIT  CRR 
        CALL    EMIT
        _DOLIT  LF
        JP      EMIT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       TAB ( -- )
; send a tabulation character to
; terminal.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER TABB,3,"TAB"
        _DOLIT  TAB 
        JP      EMIT 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       CSI ( -- ) 
; Send to ANSI terminal 
; Constrol Sequence Introducer 
; ESC [ 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER CSI,3,"CSI"
        LD      A,#ESC 
        CALL    uart_putc 
        LD      A,#'[
        CALL    uart_putc 
        RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       CLS ( -- )
; send clear screen message to 
; ANSI terminal.  
; ESC c
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER CLS,3,"CLS"
        LD      A,#ESC 
        CALL    uart_putc 
        LD      A,#'c 
        CALL    uart_putc 
        RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       CPOS ( -- n1 n2 )
; send ANSI TERMINAL sequence to get 
; position curseur ESC [6n  
; n1 -> line 
; n2 -> column 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER CPOS,4,"CPOS"
        PUSHW   X 
        CALL    cursor_pos  
        LDW     Y,X 
        POPW    X 
        PUSHW   Y 
        CLRW    Y 
        POP     A ; line 
        LD      YL,A  
        SUBW    X,#CELLL 
        LDW     (X),Y 
        POP     A  ; column 
        LD      YL,A 
        SUBW    X,#CELLL 
        LDW     (X),Y 
        RET 

;--------------------------------
;       LN-COL ( n1 n2 -- )
; remove from stack line,col 
; parameters and put them in Y 
;-------------------------------- 
LN_COL:
        LDW     Y,X 
        _TDROP 
        LDW     Y,(Y)
        LD      A,YL ; line 
        LDw     Y,X 
        _TDROP 
        LDW     Y,(Y) ; YL=column 
        LD      YH,A  ; YH=line 
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       LOCATE ( n1 n2 -- )
; Send ANSI terminal sequence to 
; position cursor 
; CSI n2 ; n1 H 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER LOCATE,6,"LOCATE"
        CALL    LN_COL 
        PUSHW   X 
        LDW     X,Y 
        CALL    set_cursor_pos
        POPW    X 
        RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       SAVE-POS ( -- )
; Send ANSI terminal command to 
; save current cursor postion 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER SAVE_POS,8,"SAVE-POS"
        CALL    save_cursor_pos
        RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       REST-POS ( -- )
; Send ANSI terminal command  to 
; restore cursor postion from 
; previous SAVE-POS 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER REST_POS,8,"REST-POS"
        CALL    restore_cursor_pos
        RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   CHAR-AT ( n1 n2 -- c )
; Ask stm8-terminal which character 
; is at position n1,n2 
; n1 -> line 
; n2 -> column 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER CHAR_AT,7,"CHAR-AT"
        CALL    SAVE_POS 
        CALL    LOCATE  
        CALL    get_char_at
        SUBW    X,#CELLL 
        CLRW    Y 
        LD      YL,A 
        LDW     (X),Y  
        JP      REST_POS   


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       CHAR ( string -- c )
; return first character of string 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER CHAR,4,"CHAR" 
       _DOLIT   SPACE 
        CALL     PARSE
        _QBRAN  CHAR1
        JP      CAT 
CHAR1:  CALL    ABORQ 
        .byte   17 
        .ascii  " missing argument"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       [CHAR] ( string -- c )
; to be used while compiling word 
; return first character of string 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER BRACK_CHAR,6+IMEDD+COMPO,"[CHAR]" 
       _DOLIT   SPACE 
        CALL     PARSE
        _QBRAN  CHAR1 
        JP      CAT 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       do$     ( -- a )
;       Return  address of a compiled
;       string.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       _HEADER DOSTR,COMPO+3,"DO$"
DOSTR:
        CALL     RFROM
        CALL     RAT
        CALL     RFROM
        CALL     COUNT
        CALL     PLUS
        CALL     TOR
        CALL     SWAPP
        CALL     TOR
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       $"|     ( -- a )
;       Run time routine compiled by $".
;       Return address of a compiled string.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       _HEADER STRQP,COMPO+3,"$\"|"
STRQP:
        CALL     DOSTR
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       ."|     ( -- )
;       Run time routine of ." .
;       Output a compiled string.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       _HEADER DOTQP,COMPO+3,".\"|"
DOTQP:
        CALL     DOSTR
        CALL     COUNT
        JP     TYPES

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       .R      ( n +n -- )
;       Display an integer in a field
;       of n columns, right justified.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DOTR,2,".R"
        CALL     TOR
        CALL     STR
        CALL     RFROM
        CALL     OVER
        CALL     SUBB
        CALL     SPACS
        JP     TYPES

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       U.R     ( u +n -- )
;       Display an unsigned integer
;       in n column, right justified.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER UDOTR,3,"U.R"
        CALL     TOR
        CALL     BDIGS
        CALL     DIGS
        CALL     EDIGS
        CALL     RFROM
        CALL     OVER
        CALL     SUBB
        CALL     SPACS
        JP     TYPES

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       U.      ( u -- )
;       Display an unsigned integer
;       in free format.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER UDOT,2,"U."
        CALL     BDIGS
        CALL     DIGS
        CALL     EDIGS
        CALL     SPAC
        JP     TYPES

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   H. ( n -- )
;   display n in hexadecimal 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER HDOT,2,"H."
        CALL BASE 
        CALL AT 
        CALL TOR 
        CALL HEX 
        CALL UDOT 
        CALL RFROM 
        CALL BASE 
        JP STORE 
         

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       .       ( w -- )
;       Display an integer in free
;       format, preceeded by a space.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DOT,1,"."
        CALL     BASE
        CALL     AT
        CALL     DOLIT
        .word      10
        CALL     XORR    ;?decimal
        CALL     QBRAN
        .word      DOT1
        JRA     UDOT
DOT1:   CALL     STR
        CALL     SPAC
        JP     TYPES

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       ?       ( a -- )
;       Display contents in memory cell.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER QUEST,1,"?"
        CALL     AT
        JRA     DOT

;; Parsing

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       parse   ( b u c -- b u delta ; <string> )
;       Scan string delimited by c.
;       Return found string and its offset.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER PARS,5,"PARS$"
        CALL     TEMP
        CALL     STORE
        CALL     OVER
        CALL     TOR
        CALL     DUPP
        CALL     QBRAN
        .word    PARS8
        CALL     ONEM
        CALL     TEMP
        CALL     AT
        CALL     BLANK
        CALL     EQUAL
        CALL     QBRAN
        .word      PARS3
        CALL     TOR
PARS1:  CALL     BLANK
        CALL     OVER
        CALL     CAT     ;skip leading blanks ONLY
        CALL     SUBB
        CALL     ZLESS
        CALL     INVER
        CALL     QBRAN
        .word      PARS2
        CALL     ONEP
        CALL     DONXT
        .word      PARS1
        CALL     RFROM
        CALL     DROP
        CALL     ZERO
        JP     DUPP
PARS2:  CALL     RFROM
PARS3:  CALL     OVER
        CALL     SWAPP
        CALL     TOR
PARS4:  CALL     TEMP
        CALL     AT
        CALL     OVER
        CALL     CAT
        CALL     SUBB    ;scan for delimiter
        CALL     TEMP
        CALL     AT
        CALL     BLANK
        CALL     EQUAL
        CALL     QBRAN
        .word      PARS5
        CALL     ZLESS
PARS5:  CALL     QBRAN
        .word      PARS6
        CALL     ONEP
        CALL     DONXT
        .word      PARS4
        CALL     DUPP
        CALL     TOR
        JRA     PARS7
PARS6:  CALL     RFROM
        CALL     DROP
        CALL     DUPP
        CALL     ONEP
        CALL     TOR
PARS7:  CALL     OVER
        CALL     SUBB
        CALL     RFROM
        CALL     RFROM
        JP     SUBB
PARS8:  CALL     OVER
        CALL     RFROM
        JP     SUBB

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       PARSE   ( c -- b u ; <string> )
;       Scan input stream and return
;       counted string delimited by c.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER PARSE,5,"PARSE"
        CALL     TOR
        CALL     TIB
        CALL     INN
        CALL     AT
        CALL     PLUS    ;current input buffer pointer
        CALL     NTIB
        CALL     AT
        CALL     INN
        CALL     AT
        CALL     SUBB    ;remaining count
        CALL     RFROM
        CALL     PARS
        CALL     INN
        JP       PSTOR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       .(      ( -- )
;       Output following string up to next ) .
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DOTPR,IMEDD+2,".("
        CALL     DOLIT
        .word     41	; ")"
        CALL     PARSE
        JP     TYPES

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       (       ( -- )
;       Ignore following string up to next ).
;       A comment.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER PAREN,IMEDD+1,"("
        CALL     DOLIT
        .word     41	; ")"
        CALL     PARSE
        JP     DDROP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       \       ( -- )
;       Ignore following text till
;       end of line.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER BKSLA,IMEDD+1,'\'

        mov UINN+1,UCTIB+1
        ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       WORD    ( c -- a ; <string> )
;       Parse a word from input stream
;       and copy it to code dictionary.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER WORDD,4,"WORD"
        CALL     PARSE
        CALL     HERE
        CALL     CELLP
.IF CASE_SENSE 
        JP      PACKS 
.ELSE                 
        CALL     PACKS
; uppercase TOKEN 
        CALL    DUPP 
        CALL    COUNT 
        CALL    TOR 
        CALL    BRAN 
        .word   UPPER2  
UPPER:
        CALL    DUPP 
        CALL    CAT
        CALL    DUPP 
        CALL   DOLIT
        .word   'a' 
        CALL    DOLIT
        .word   'z'+1 
        CALL   WITHI 
        CALL   QBRAN
        .word  UPPER1  
        CALL    DOLIT 
        .word   0xDF 
        CALL    ANDD 
UPPER1:
        CALL    OVER 
        CALL    CSTOR          
        CALL    ONEP 
UPPER2: 
        CALL    DONXT
        .word   UPPER  
        CALL    DROP  
        RET 
.ENDIF 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       TOKEN   ( -- a ; <string> )
;       Parse a word from input stream
;       and copy it to name dictionary.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER TOKEN,5,"TOKEN"
        CALL     BLANK
        JP     WORDD

;; Dictionary search

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       NAME>   ( na -- ca )
;       Return a code address given
;       a name address.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER NAMET,5,"NAME>"
        CALL     COUNT
        CALL     DOLIT
        .word      31
        CALL     ANDD
        JP     PLUS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       SAME?   ( a a u -- a a f \ -0+ )
;       Compare u cells in two
;       strings. Return 0 if identical.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER SAMEQ,5,"SAME?"
        CALL     ONEM
        CALL     TOR
        JRA     SAME2
SAME1:  CALL     OVER
        CALL     RAT
        CALL     PLUS
        CALL     CAT
        CALL     OVER
        CALL     RAT
        CALL     PLUS
        CALL     CAT
        CALL     SUBB
        CALL     QDUP
        CALL     QBRAN
        .word      SAME2
        CALL     RFROM
        JP     DROP
SAME2:  CALL     DONXT
        .word      SAME1
        JP     ZERO

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       find    ( a va -- ca na | a F )
;       Search vocabulary for string.
;       Return ca and na if succeeded.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER FIND,4,"FIND"
        CALL     SWAPP
        CALL     DUPP
        CALL     CAT
        CALL     TEMP
        CALL     STORE
        CALL     DUPP
        CALL     AT
        CALL     TOR
        CALL     CELLP
        CALL     SWAPP
FIND1:  CALL     AT
        CALL     DUPP
        CALL     QBRAN
        .word      FIND6
        CALL     DUPP
        CALL     AT
        CALL     DOLIT
        .word      MASKK
        CALL     ANDD
        CALL     RAT
        CALL     XORR
        CALL     QBRAN
        .word      FIND2
        CALL     CELLP
        CALL     DOLIT
        .word     0xFFFF
        JRA     FIND3
FIND2:  CALL     CELLP
        CALL     TEMP
        CALL     AT
        CALL     SAMEQ
FIND3:  CALL     BRAN
        .word      FIND4
FIND6:  CALL     RFROM
        CALL     DROP
        CALL     SWAPP
        CALL     CELLM
        JP     SWAPP
FIND4:  CALL     QBRAN
        .word      FIND5
        CALL     CELLM
        CALL     CELLM
        JRA     FIND1
FIND5:  CALL     RFROM
        CALL     DROP
        CALL     SWAPP
        CALL     DROP
        CALL     CELLM
        CALL     DUPP
        CALL     NAMET
        JP     SWAPP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       NAME?   ( a -- ca na | a F )
;       Search vocabularies for a string.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER NAMEQ,5,"NAME?"
        CALL   CNTXT
        JP     FIND

;; Terminal response

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       ^H      ( bot eot cur -- bot eot cur )
;       Backup cursor by one character.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER BKSP,2,"^H"
        CALL     TOR
        CALL     OVER
        CALL     RFROM
        CALL     SWAPP
        CALL     OVER
        CALL     XORR
        CALL     QBRAN
        .word      BACK1
        CALL    ONEM 
        JP      uart_bksp
BACK1:  RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       TAP    ( bot eot cur c -- bot eot cur )
;       Accept and echo key stroke
;       and bump cursor.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER TAP,3,"TAP"
.if 0
        CALL     DUPP
        CALL     EMIT
.else 
        LD      A,(1,X)
        CALL    uart_putc 
.endif 
        CALL     OVER
        CALL     CSTOR
        JP     ONEP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       kTAP    ( bot eot cur c -- bot eot cur )
;       Process a key stroke,
;       CR,LF or backspace.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER KTAP,4,"KTAP"
        CALL     DUPP
        CALL     DOLIT
.if EOL_CR
        .word   CRR
.else ; EOL_LF 
        .word   LF
.endif 
        CALL     XORR
        CALL     QBRAN
        .word      KTAP2
        CALL     DOLIT
        .word      BKSPP
        CALL     XORR
        CALL     QBRAN
        .word      KTAP1
        CALL     BLANK
        JP     TAP
KTAP1:  JP     BKSP
KTAP2:  CALL     DROP
        CALL     SWAPP
        CALL     DROP
        JP     DUPP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       accept  ( b u -- b u )
;       Accept characters to input
;       buffer. Return with actual count.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER ACCEP,6,"ACCEPT"
        CALL     OVER
        CALL     PLUS
        CALL     OVER
ACCP1:  CALL     DDUP
        CALL     XORR
        CALL     QBRAN
        .word      ACCP4
        CALL     KEY
        CALL     DUPP
        CALL     BLANK
        CALL     DOLIT
        .word      127
        CALL     WITHI
        CALL     QBRAN
        .word      ACCP2
        CALL     TAP
        JRA     ACCP3
ACCP2:  CALL     KTAP
ACCP3:  JRA     ACCP1
ACCP4:  CALL     DROP
        CALL     OVER
        JP     SUBB

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       QUERY   ( -- )
;       Accept input stream to
;       terminal input buffer.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER QUERY,5,"QUERY"
        CALL     TIB
        CALL     DOLIT
        .word      80
        CALL     ACCEP
        CALL     NTIB
        CALL     STORE
        CALL     DROP
        CALL     ZERO
        CALL     INN
        JP     STORE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       ABORT   ( -- )
;       Reset data stack and
;       jump to QUIT.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER ABORT,5,"ABORT"
        CALL     PRESE
        JP     QUIT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       abort"  ( f -- )
;       Run time routine of ABORT".
;       Abort with a message.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER ABORQ,COMPO+6,'ABORT"'
        CALL     QBRAN
        .word      ABOR2   ;text flag
        CALL     DOSTR
ABOR1:  MOV     BASE,#10 ; reset to default 
        CALL     SPAC
        CALL     COUNT
        CALL     TYPES
        CALL     DOLIT
        .word     63 ; "?"
        CALL     EMIT
        CALL     CRLF
        JP     ABORT   ;pass error string
ABOR2:  CALL     DOSTR
        JP     DROP

;; The text interpreter

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       $INTERPRET      ( a -- )
;       Interpret a word. If failed,
;       try to convert it to an integer.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER INTER,10,"$INTERPRET"
        CALL     NAMEQ
        CALL     QDUP    ;?defined
        CALL     QBRAN
        .word      INTE1
        CALL     AT
        CALL     DOLIT
	.word       0x4000	; COMPO*256
        CALL     ANDD    ;?compile only lexicon bits
        CALL     ABORQ
        .byte      13
        .ascii     " compile only"
        JP      EXECU
INTE1:  
        CALL     NUMBQ   ;convert a number
        CALL     QBRAN
        .word    ABOR1
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       [       ( -- )
;       Start  text interpreter.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER LBRAC,IMEDD+1,"["
        CALL   DOLIT
        .word  INTER
        CALL   TEVAL
        JP     STORE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       .OK     ( -- )
;       Display 'ok' while interpreting.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DOTOK,3,".OK"
        CALL     DOLIT
        .word      INTER
        CALL     TEVAL
        CALL     AT
        CALL     EQUAL
        CALL     QBRAN
        .word      DOTO1
        CALL     DOTQP
        .byte      3
        .ascii     " ok"
DOTO1:  JP     CRLF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       ?STACK  ( -- )
;       Abort if stack underflows.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER QSTAC,6,"?STACK"
        CALL     DEPTH
        CALL     ZLESS   ;check only for underflow
        CALL     ABORQ
        .byte      11
        .ascii     " underflow "
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       EVAL    ( -- )
;       Interpret  input stream.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER EVAL,4,"EVAL"
EVAL1:  CALL     TOKEN
        CALL     DUPP
        CALL     CAT     ;?input stream empty
        CALL     QBRAN
        .word    EVAL2
        CALL     TEVAL
        CALL     ATEXE
        CALL     QSTAC   ;evaluate input, check stack
        JRA     EVAL1 
EVAL2:  CALL     DROP
        JP       DOTOK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       PRESET  ( -- )
;       Reset data stack pointer and
;       terminal input buffer.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER PRESE,6,"PRESET"
        CALL     DOLIT
        .word      SPP
        CALL     SPSTO
        CALL     DOLIT
        .word      TIBB
        CALL     NTIB
        CALL     CELLP
        JP     STORE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       QUIT    ( -- )
;       Reset return stack pointer
;       and start text interpreter.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER QUIT,4,"QUIT"
        CALL     DOLIT
        .word      RPP
        CALL     RPSTO   ;reset return stack pointer
QUIT1:  CALL     LBRAC   ;start interpretation
QUIT2:  CALL     QUERY   ;get input
        CALL     EVAL
        JRA     QUIT2   ;continue till error

;; The compiler

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       '       ( -- ca )
;       Search vocabularies for
;       next word in input stream.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER TICKK,1,"'"
        CALL     TOKEN
        CALL     NAMEQ   ;?defined
        CALL     QBRAN
        .word      ABOR1
        RET     ;yes, push code address

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       ALLOT   ( n -- )
;       Allocate n bytes to RAM 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER ALLOT,5,"ALLOT"
        call VPP 
        JP PSTOR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       ,       ( w -- )
;         Compile an integer into
;         variable space.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER COMA,1,^/","/
        CALL     HERE
        CALL     DUPP
        CALL     CELLP   ;cell boundary
        CALL     VPP
        CALL     STORE
        JP       STORE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       C,      ( c -- )
;       Compile a byte into
;       variables space.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER CCOMMA,2,^/"C,"/
        CALL     HERE
        CALL     DUPP
        CALL     ONEP
        CALL     VPP
        CALL     STORE
        JP       CSTOR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       [COMPILE]       ( -- ; <string> )
;       Compile next immediate
;       word into code dictionary.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER BCOMP,COMPO+IMEDD+9,"[COMPILE]"
        CALL     TICKK
        JP     COMPI_CALL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       COMPILE ( -- )
;       Compile next jsr in
;       colon list to code dictionary.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER COMPI,COMPO+7,"COMPILE"
        CALL     RFROM
        CALL     DUPP
        CALL     AT
        CALL     COMPI_CALL    ;compile subroutine
        CALL     CELLP
        ldw y,x 
        ldw y,(y)
        addw x,#CELLL 
        jp (y)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       LITERAL ( w -- )
;       Compile tos to dictionary
;       as an integer literal.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER LITER,COMPO+IMEDD+7,"LITERAL"
        CALL     COMPI
        .word DOLIT 
        JP     COMA

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       $,"     ( -- )
;       Compile a literal string
;       up to next " .
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;        _HEADER STRCQ,3,^/'$,"'/
STRCQ:
        CALL     DOLIT
        .word     34	; "
        CALL     PARSE
        CALL     HERE
        CALL     PACKS   ;string to code dictionary
        CALL     COUNT
        CALL     PLUS    ;calculate aligned end of string
        CALL     VPP
        JP     STORE

;; Structures

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       FOR     ( -- a )
;       Start a FOR-NEXT loop
;       structure in a colon definition.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER FOR,COMPO+IMEDD+3,"FOR"
        CALL     COMPI
        .word TOR 
        JP     HERE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       NEXT    ( a -- )
;       Terminate a FOR-NEXT loop.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER NEXT,COMPO+IMEDD+4,"NEXT"
        CALL     COMPI
        .word DONXT 
        JP     COMA

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       I ( -- n )
;       stack COUNTER
;       of innermost FOR-NEXT  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER IFETCH,1,"I"
        subw x,#CELLL 
        ldw y,(3,sp)
        ldw (x),y 
        ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       J ( -- n )
;   stack COUNTER
;   of outer FOR-NEXT  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER JFETCH,1,"J"
        SUBW X,#CELLL 
        LDW Y,(5,SP)
        LDW (X),Y 
        RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       DO ( n1 n2 -- R: n2 n1 )
;  initiale DO ... LOOP 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DO,2+IMEDD+COMPO,"DO"
        CALL    COMPI 
        .WORD   SWAPP 
        CALL    COMPI 
        .WORD   TOR 
        CALL    COMPI 
        .WORD   TOR 
        CALL    HERE  ; ( -- addr )
        RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       LOOP ( a -- )
; DO ... LOOP control 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER LOOP,4+IMEDD+COMPO,"LOOP"
        CALL    COMPI 
        .word   RT_LOOP
LOOP1:
        CALL    COMPI 
        .WORD   TBRAN 
        CALL    COMA ; compile loop address  
        CALL    COMPI 
        .word   RFROM 
        CALL    COMPI 
        .word   RFROM 
        CALL    COMPI 
        .word   DDROP 
        RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   LOOP run time 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RT_LOOP:
CNTR=3
LIMIT=5 
        LDW     Y,(CNTR,sp)
        INCW    Y 
        LDW     (CNTR,SP),Y 
        SUBW    Y,(LIMIT,sp)
        NEGW    Y  
        SUBW    X,#CELLL 
        LDW     (X),Y  
        RET        

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       +LOOP ( a -- )
; DO ... n +LOOP 
; n increment loop I 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER PLOOP,5+IMEDD+COMPO,"+LOOP"
        CALL    COMPI 
        .WORD   RT_PLOOP         
        JRA     LOOP1


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  +LOOP runtime 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RT_PLOOP:
CNTR=3
LIMIT=5 
        LDW     Y,X 
        LDW     Y,(Y)
        ADDW    Y,(CNTR,sp)        
        LDW     (CNTR,sp),y 
        SUBW    Y,(LIMIT,sp)
        JRSLT   2$ 
        CLRW    Y 
        JRA     4$ 
2$:     LDW     Y,#-1
4$:     LDW     (X),Y 
        RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       CASE ( -- 0 )
; start a select control structure 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER CASE,4+IMEDD+COMPO,"CASE"
        _DOLIT 0 
        RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       OF ( n1 n2 -- n1 |  )
; if n1==n2 execute up to ENDOF 
; push patching address for ENDOF on R:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER OF,2+IMEDD+COMPO,"OF"
        CALL    ONEP 
        _COMPI OVER
        _COMPI  EQUAL 
        CALL  IFF
;       _COMPI  DROP 
        RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       ENDOF ( -- )
; close OF block 
; push ENDCASE patching address on R 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER ENDOF,5+IMEDD+COMPO,"ENDOF"
        CALL ELSEE         
        CALL SWAPP 
        RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       ENDCASE ( n1 -- R: ax )
; discard n1 and patch all ENDOF 
; branch address stored on R: 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER,ENDCASE,7+IMEDD+COMPO,"ENDCASE"
        CALL    DUPP 
        _DOLIT  VAR_BASE 
        CALL    ULESS 
        _TBRAN  0$ 
        CALL    SWAPP 
0$:
        CALL    TOR 
        _BRAN   2$ 
1$:     CALL    THENN 
2$:     _DONXT  1$
        _COMPI  DROP
        RET  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       BEGIN   ( -- a )
;       Start an infinite or
;       indefinite loop structure.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER BEGIN,COMPO+IMEDD+5,"BEGIN"
        JP     HERE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       UNTIL   ( a -- )
;       Terminate a BEGIN-UNTIL
;       indefinite loop structure.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER UNTIL,COMPO+IMEDD+5,"UNTIL"
        CALL     COMPI
        .word    QBRAN 
        JP     COMA

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       AGAIN   ( a -- )
;       Terminate a BEGIN-AGAIN
;       infinite loop structure.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER AGAIN,COMPO+IMEDD+5,"AGAIN"
.if OPTIMIZE 
        _DOLIT JPIMM 
        CALL  CCOMMA
.else 
        CALL     COMPI
        .word BRAN
.endif 
        JP     COMA

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       IF      ( -- A )
;       Begin a conditional branch.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER IFF,COMPO+IMEDD+2,"IF"
        CALL     COMPI
        .word QBRAN
        CALL     HERE
        CALL     ZERO
        JP     COMA

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       THEN        ( A -- )
;       Terminate a conditional 
;       branch structure.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER THENN,COMPO+IMEDD+4,"THEN"
        CALL     HERE
        CALL     SWAPP
        JP     STORE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       ELSE        ( A -- A )
;       Start the false clause in 
;       an IF-ELSE-THEN structure.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER ELSEE,COMPO+IMEDD+4,"ELSE"
.if OPTIMIZE 
        _DOLIT JPIMM 
        CALL CCOMMA 
.else 
         CALL     COMPI
        .word BRAN
.endif 
        CALL     HERE
        CALL     ZERO
        CALL     COMA
        CALL     SWAPP
        CALL     HERE
        CALL     SWAPP
        JP     STORE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       AHEAD       ( -- A )
;       Compile a forward branch
;       instruction.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER AHEAD,COMPO+IMEDD+5,"AHEAD"
.if OPTIMIZE 
        _DOLIT JPIMM 
        CALL CCOMMA
.else 
        CALL     COMPI
        .word BRAN
.endif 
        CALL     HERE
        CALL     ZERO
        JP     COMA

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       WHILE       ( a -- A a )
;       Conditional branch out of a 
;       BEGIN-WHILE-REPEAT loop.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER WHILE,COMPO+IMEDD+5,"WHILE"
        CALL     COMPI
        .word QBRAN
        CALL     HERE
        CALL     ZERO
        CALL     COMA
        JP     SWAPP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       REPEAT      ( A a -- )
;       Terminate a BEGIN-WHILE-REPEAT 
;       indefinite loop.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER REPEA,COMPO+IMEDD+6,"REPEAT"
.if OPTIMIZE 
        _DOLIT JPIMM 
        CALL  CCOMMA
.else 
        CALL     COMPI
        .word BRAN
.endif 
        CALL     COMA
        CALL     HERE
        CALL     SWAPP
        JP     STORE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       AFT         ( a -- a A )
;       Jump to THEN in a FOR-AFT-THEN-NEXT 
;       loop the first time through.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER AFT,COMPO+IMEDD+3,"AFT"
        CALL     DROP
        CALL     AHEAD
        CALL     HERE
        JP     SWAPP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       ABORT"      ( -- ; <string> )
;       Conditional abort with an error message.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER ABRTQ,IMEDD+6,'ABORT"'
        CALL     COMPI
        .word ABORQ
        JP     STRCQ

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       $"     ( -- ; <string> )
;       Compile an inline string literal.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER STRQ,IMEDD+COMPO+2,'$"'
        CALL     COMPI
        .word STRQP 
        JP     STRCQ

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       ."          ( -- ; <string> )
;       Compile an inline string literal 
;       to be typed out at run time.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DOTQ,IMEDD+COMPO+2,'."'
        CALL     COMPI
        .word DOTQP 
        JP     STRCQ

;; Name compiler

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       ?UNIQUE ( a -- a )
;       Display a warning message
;       if word already exists.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER UNIQU,7,"?UNIQUE"
        CALL     DUPP
        CALL     NAMEQ   ;?name exists
        CALL     QBRAN
        .word      UNIQ1
        CALL     DOTQP   ;redef are OK
        .byte       7
        .ascii     " reDef "       
        CALL     OVER
        CALL     COUNT
        CALL     TYPES   ;just in case
UNIQ1:  JP     DROP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       $,n     ( na -- )
;       Build a new dictionary name
;       using string at na.
; compile dans l'espace des variables 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;        _HEADER SNAME,3,^/"$,n"/
SNAME: 
        CALL     DUPP
        CALL     CAT     ;?null input
        CALL     QBRAN
        .word      PNAM1
        CALL     UNIQU   ;?redefinition
        CALL     DUPP
        CALL     COUNT
        CALL     PLUS
        CALL     VPP
        CALL     STORE
        CALL     DUPP
        CALL     LAST
        CALL     STORE   ;save na for vocabulary link
        CALL     CELLM   ;link address
        CALL     CNTXT
        CALL     AT
        CALL     SWAPP
        CALL     STORE
        RET     ;save code pointer
PNAM1:  CALL     STRQP
        .byte      5
        .ascii     " name" ;null input
        JP     ABOR1

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       CELLS ( n1 -- n2 )
; n2 is size of n1 cells 
;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER CELLS,5,"CELLS"
        _DOLIT CELLL 
        JP STAR 

;; FORTH compiler

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       $COMPILE        ( a -- )
;       Compile next word to
;       dictionary as a token or literal.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER SCOMP,8,"$COMPILE"
        CALL     NAMEQ
        CALL     QDUP    ;?defined
        CALL     QBRAN
        .word      SCOM2
        CALL     AT
        CALL     DOLIT
        .word     0x8000	;  IMEDD*256
        CALL     ANDD    ;?immediate
        CALL     QBRAN
        .word      SCOM1
        JP     EXECU
SCOM1:  JP     COMPI_CALL
SCOM2:  CALL     NUMBQ   ;try to convert to number 
        CALL    QDUP  
        CALL     QBRAN
        .word      ABOR1
.if WANT_DOUBLE 
        _DOLIT  -1
        CALL    EQUAL
        _QBRAN DLITER
        JP  LITER 
.endif 
.if WANT_FLOAT24 
        _DOLIT -1 
        CALL EQUAL 
        _QBRAN FLITER
        JP  LITER  
.endif 
        _TDROP 
        JP     LITER


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       OVERT   ( -- )
;       Link a new word into vocabulary.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER OVERT,5,"OVERT"
        CALL     LAST
        CALL     AT
        CALL     CNTXT
        JP     STORE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       ;       ( -- )
;       Terminate a colon definition.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER SEMIS,IMEDD+COMPO+1,^/";"/
.if OPTIMIZE ; more compact and faster
        call DOLIT 
        .word 0x81   ; opcode for RET 
        call CCOMMA 
.else
        CALL     COMPI
        .word EXIT 
.endif 
        CALL     LBRAC
        JP OVERT 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       ]       ( -- )
;       Start compiling words in
;       input stream.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER RBRAC,1,"]"
        CALL   DOLIT
        .word  SCOMP
        CALL   TEVAL
        JP     STORE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       CALL,    ( ca -- )
;       Compile a subroutine call.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER COMPI_CALL,5,^/"CALL,"/
        CALL     DOLIT
        .word     CALLL     ;CALL
        CALL     CCOMMA
        JP     COMA


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       :       ( -- ; <string> )
;       Start a new colon definition
;       using next word as its name.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER COLN,1,":"
        CALL   TOKEN
        CALL   SNAME
        JP     RBRAC


        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       DEFER ( <sgring>)
;       create a defered word 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DEFER,5,"DEFER"
        CALL    TOKEN 
        CALL    SNAME 
        CALL    OVERT        
DEFER1:
        _DOLIT  JPIMM 
        CALL    CCOMMA 
        _DOLIT  do_nothing 
        CALL    COMA 
        RET

;;;;;;;;;;;;;;;;;;;;;
; compiled by DEFER 
;;;;;;;;;;;;;;;;;;;;;
do_nothing:
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       DEFER! (xt1 xt2 -- )
; set defered word ca of xt2 
; to execute xt1 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DEFRSTO,6,"DEFER!"
        CALL ONEP
        JP STORE 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       DEFER@ (xt1 -- xt2 )
; xt2 is xt1 execution token 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DEFRAT,6,"DEFER@"
        CALL ONEP 
        JP AT 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       ACTION-OF ( "name" -- xt )
; "name" beeing a defered word 
; xt is its execution token 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER ACTIONOF,9,"ACTION-OF"
        CALL TOKEN 
        call DUPP 
        call QBRAN 
        .word FORGET2 ; invalid parameter
        call NAMEQ ; ( a -- ca na | a F )
        call QBRAN 
        .word FORGET2  ; not in dictionary 
        JP DEFRAT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       IS ( xt "name" )
;  set defered word "name" 
;  to execute xt 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER IS,2,"IS" 
        call TOKEN
        call DUPP 
        call QBRAN 
        .word FORGET2 ; invalid parameter
        call NAMEQ ; ( a -- ca na | a F )
        call QBRAN 
        .word FORGET2  ; not in dictionary 
        JP DEFRSTO

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       IMMEDIATE       ( -- )
;       Make last compiled word
;       an immediate word.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER IMMED,9,"IMMEDIATE"
        CALL	DOLIT
        .word	(IMEDD<<8)
IMM01:  CALL	LAST
        CALL    AT
        CALL    AT
        CALL    ORR
        CALL    LAST
        CALL    AT
        JP      STORE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;		COMPILE-ONLY  ( -- )
;		Make last compiled word 
;		a compile only word.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER COMPONLY,12,"COMPILE-ONLY"
        CALL     DOLIT
        .word    (COMPO<<8)
        JP       IMM01
		
;; Defining words

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       CREATE  ( -- ; <string> )
;       Compile a new array
;       without allocating space.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER CREAT,6,"CREATE"
        CALL     TOKEN
        CALL     SNAME
        CALL     OVERT        
        CALL     COMPI 
        .word   PUSH_PA  
        JP      DEFER1

;----------------------------
;  compile by CREATE
;  push parameter address 
;----------------------------
PUSH_PA: ; ( -- addr )
        ldw y,(1,sp)
        addw y,#3
        subw x,#CELLL 
        ldw (x),y
        RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       VARIABLE  ( -- ; <string> )
;       Compile a new variable
;       initialized to 0.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER VARIA,8,"VARIABLE"
        CALL ZERO 
        CALL CREAT 
        JP COMA 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       CONSTANT  ( n -- ; <string> )
;       Compile a new constant 
;       n CONSTANT name 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER CONSTANT,8,"CONSTANT"
        CALL TOKEN
        CALL SNAME 
        CALL OVERT 
        CALL COMPI 
        .word DOCONST
        JP COMA 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CONSTANT runtime semantic 
; doCONST  ( -- n )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       _HEADER DOCONST,7,"DOCONST"
DOCONST:
        subw x,#CELLL
        popw y 
        ldw y,(y) 
        ldw (x),y 
        ret 

;----------------------------------
; create double constant 
; 2CONSTANT ( d -- ; <string> )
;----------------------------------
        _HEADER DCONST,9,"2CONSTANT"
        CALL TOKEN
        CALL SNAME 
        CALL OVERT 
        CALL COMPI 
        .word DO_DCONST
        CALL COMA
        JP COMA  

;----------------------------------
; runtime for DCONST 
; stack double constant 
; DO-DCONST ( -- d )
;-----------------------------------
;       _HEADER DO_DCONST,9,"DO-DCONST"
DO_DCONST:
    subw x,#2*CELLL 
    ldw y,(1,sp) 
    ldw y,(y)
    ldw (x),y 
    popw y  
    ldw y,(2,y)
    ldw (2,x),y 
    ret 

;--------------------------------
;  runtime action of DOES>
;-------------------------------
DO_DOES:
        POPW    Y 
        ADDW    Y,#CELLL 
        PUSHW   Y 
        INCW    Y
        SUBW    X,#CELLL 
        LDW     (X),Y 
        CALL    LAST 
        CALL    AT 
        CALL    NAMET ; ( na -- ca )
        _DOLIT  4 
        CALL    PLUS 
        JP      STORE  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       DOES> ( C: colon-sys1 – – colon-sys2 )
; terminate actual definition compilation 
; begin a no-name new one.
; leave the code field address on stack 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DOESGT,5+IMEDD+COMPO,"DOES>"
        CALL    COMPI 
        .word   DO_DOES
        LDW     Y,(1,SP)
        ADDW    Y,#1
        CALL    HERE 
        CALL    COMA  
        _DOLIT  RET 
        CALL    CCOMMA 
        RET 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;          TOOLS 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       _TYPE   ( b u -- )
;       Display a string. Filter
;       non-printing characters.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER UTYPE,5,"_TYPE"
        CALL     TOR     ;start count down loop
        JRA     UTYP2   ;skip first pass
UTYP1:  CALL     DUPP
        CALL     CAT
        CALL     TCHAR
        CALL     EMIT    ;display only printable
        CALL     ONEP    ;increment address
UTYP2:  CALL     DONXT
        .word      UTYP1   ;loop till done
        JP     DROP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       dm+     ( a u -- a )
;       Dump u bytes from ,
;       leaving a+u on  stack.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DUMPP,3,"DM+"
        CALL     OVER
        CALL     DOLIT
        .word      4
        CALL     UDOTR   ;display address
        CALL     SPAC
        CALL     TOR     ;start count down loop
        JRA     PDUM2   ;skip first pass
PDUM1:  CALL     DUPP
        CALL     CAT
        CALL     DOLIT
        .word      3
        CALL     UDOTR   ;display numeric data
        CALL     ONEP    ;increment address
PDUM2:  CALL     DONXT
        .word      PDUM1   ;loop till done
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       DUMP    ( a u -- )
;       Dump u bytes from a,
;       in a formatted manner.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DUMP,4,"DUMP"
        CALL     BASE
        CALL     AT
        CALL     TOR
        CALL     HEX     ;save radix, set hex
        CALL     DOLIT
        .word      16
        CALL     SLASH   ;change count to lines
        CALL     TOR     ;start count down loop
DUMP1:  CALL     CRLF
        CALL     DOLIT
        .word      16
        CALL     DDUP
        CALL     DUMPP   ;display numeric
        CALL     ROT
        CALL     ROT
        CALL     SPAC
        CALL     SPAC
        CALL     UTYPE   ;display printable characters
        CALL     DONXT
        .word      DUMP1   ;loop till done
DUMP3:  CALL     DROP
        CALL     RFROM
        CALL     BASE
        JP     STORE   ;restore radix

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       .S      ( ... -- ... )
;        Display  contents of stack.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DOTS,2,".S"
        CALL     CRLF
        CALL     DEPTH   ;stack depth
        CALL     TOR     ;start count down loop
        JRA     DOTS2   ;skip first pass
DOTS1:  CALL     RAT
	CALL     PICK
        CALL     DOT     ;index stack, display contents
DOTS2:  CALL     DONXT
        .word      DOTS1   ;loop till done
        CALL     DOTQP
        .byte      5
        .ascii     " <sp "
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       >NAME   ( ca -- na | F )
;       Convert code address
;       to a name address.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER TNAME,5,">NAME"
        CALL     CNTXT   ;vocabulary link
TNAM2:  CALL     AT
        CALL     DUPP    ;?last word in a vocabulary
        CALL     QBRAN
        .word      TNAM4
        CALL     DDUP
        CALL     NAMET
        CALL     XORR    ;compare
        CALL     QBRAN
        .word      TNAM3
        CALL     CELLM   ;continue with next word
        JRA     TNAM2
TNAM3:  CALL     SWAPP
        JP     DROP
TNAM4:  CALL     DDROP
        JP     ZERO

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       .NAME ( ca -- )
;  print name associate with 
;  code address ca 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DOT_NAME,5,".NAME"
        CALL    TNAME 
        JRA     DOTID 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       .ID     ( na -- )
;        Display  name at address.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER DOTID,3,".ID"
        CALL     QDUP    ;if zero no name
        CALL     QBRAN
        .word      DOTI1
        CALL     COUNT
        CALL     DOLIT
        .word      0x1F
        CALL     ANDD    ;mask lexicon bits
        JP     UTYPE
DOTI1:  CALL     DOTQP
        .byte      8
        .ascii     " no name"
        CALL    SPAC 
        RET

WANT_SEE=1
.if WANT_SEE 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       SEE     ( -- ; <string> )
;       A simple decompiler.
;       Updated for byte machines.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER SEE,3,"SEE"
        CALL     CRLF
        _DOLIT  ': 
        CALL    EMIT
        CALL    SPAC  
        CALL     TICKK ; ( -- ca )
        CALL    DUPP 
        CALL    DOT_NAME
        CALL    CRLF 
SEE1: ; ( -- ca )
        CALL    TABB 
        CALL    DUPP
        CALL    CAT   ; -- ca c 
        _DOLIT  CALLL 
        CALL    EQUAL 
        _QBRAN  SEE8 
; its a CALL move pointer to target field         
        CALL    ONEP  ; tf  target field  
        CALL    DUPP  ; tf tf   
        CALL    AT    ; tf ta   target address 
        CALL    DUPP  ; tf ta ta      
        _DOLIT  DOLIT ; check for CALL DOLIT 
        CALL    EQUAL ; tf ta f 
        _QBRAN  SEE2 
        _TDROP  ; -- tf  
        CALL    CELLP ; literal field    
        CALL    DUPP  ; 
        CALL    AT    ; literal 
        _BRAN   SEE3  
SEE2:  ; tf ta  
        CALL    DUPP  ;tf ta ta 
        CALL    DOT_NAME ;tf ta 
SEE3: ; tf u 
        CALL    HDOT 
        CALL    CRLF  
        CALL    CELLP           
        JRA     SEE1 
SEE8: ; RET?
        CALL    DUPP 
        CALL    CAT 
        _DOLIT  RET 
        CALL    EQUAL 
        _QBRAN  SEE9 
        LD      A,#'; 
        CALL    uart_putc 
        JP      CRLF  
SEE9: ; machine code 
        CALL    DUPP 
        CALL    CAT 
        CALL    HDOT 
        CALL    ABORQ 
        .byte   13
        .ascii  " machine code"
.endif ; WANT_SEE 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       WORDS   ( -- )
;       Display names in vocabulary.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER WORDS,5,"WORDS"
        CALL     CRLF
        CALL     CNTXT   ;only in context
WORS1:  CALL     AT
        CALL     QDUP    ;?at end of list
        CALL     QBRAN
        .word      WORS2
        CALL     DUPP
        CALL     SPAC
        CALL     DOTID   ;display a name
        CALL     CELLM
        CALL     BRAN
        .word      WORS1
WORS2:  RET

        
;; Hardware reset

forth_name: .asciz "p1Forth "
forth_cpr: .asciz " Jacques Deschenes (c) 2023,24\n"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       hi      ( -- )
;       Display sign-on message.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER HI,2,"HI"
        CALL     CRLF
        pushw x 
        ldw x,#forth_name 
        ldw y,#forth_cpr 
        push #REV 
        push #MINOR  
        push #MAJOR
        call app_info 
        _drop 3
        popw x 
        ret 

.if WANT_DOUBLE 
        CALL DBLVER 
.endif 
.if WANT_FLOAT|WANT_FLOAT24
        CALL FVER 
.endif         
        JP     CRLF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       'BOOT   ( -- a )
;       The application startup vector.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER TBOOT,5,"'BOOT"
        CALL     DOVAR
        .word    HI      ;application to boot

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       COLD    ( -- )
;       The hilevel cold start s=ence.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        _HEADER COLD,4,"COLD"
COLD1:  CALL     DOLIT
        .word      UZERO
	CALL     DOLIT
        .word      UPP
        CALL     DOLIT
	.word      UEND-UZERO
        CALL     CMOVE   ;initialize user area
6$:      
        CALL     PRESE   ;initialize data stack and TIB
        CALL     TBOOT
        CALL     ATEXE   ;application boot
        CALL     OVERT
        JP     QUIT    ;start interpretation

; files support words 
        .include "ForthFiles.asm" 

.if WANT_SCALING_CONST 
        .include "const_ratio.asm"
.endif
.if WANT_CONST_TABLE 
        .include "ctable.asm"
.endif
.if WANT_DOUBLE 
        .include "double.asm"
.endif 
.if WANT_FLOAT 
        .include "float.asm"
.endif 
.if WANT_FLOAT24 
        .include "float24.asm"
.endif 

LASTN =	LINK   ;last name defined




