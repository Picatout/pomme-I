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

;;;;;;;;;;;;;;;;;;;;;;;;;
;;  p1Forth files words"
;;;;;;;;;;;;;;;;;;;;;;;;

    .include "../inc/files.inc"

;------------------------------
;  ASCIZ ( a sting -- a )
;  copy string to a  
;  and zero terminate it.
;------------------------------
    _HEADER ASCIZ,5,"ASCIZ" 
    CALL TOR   ; ( -- R: a )
    CALL TOKEN 
    CALL COUNT ; ( -- b cnt R: a)
    CALL DUPP 
    CALL ZEQUAL 
    call ABORQ 
    .byte 15
    .ascii "\nstring missing"
1$:  
    CALL DUPP  
    CALL NROT  ; ( -- cnt b cnt )
    CALL RAT   
    CALL SWAPP ; ( -- cnt b a cnt )
    CALL CMOVE ; ( -- cnt R: a )
    CALL ZERO 
    CALL SWAPP ; ( -- 0 cnt )
    CALL RAT 
    CALL PLUS 
    CALL CSTOR 
    CALL RFROM 
    RET  

;-------------------------
; set file name in FCB 
;-------------------------
set_file_name: ; string ( - ) 
    CALL TIB
    CALL ASCIZ ; ( -- a )  
; file name is now in tib     
; a==tib address      
    ldw y,x
    _TDROP  
    pushw x 
    ldw y,(y) ; tib address 
    ldw x,#fcb
    call name_to_fcb 
    popw x ; ( -- )
    RET 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   SAVE file_name ( -- )
; save user image in file 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    _HEADER SAVE,4,"SAVE"
    call set_file_name 
    pushw x
    ldw x,#fcb     
    ldw y,#UBASE
    ldw (FCB_BUFFER,x),y  
    ldw y,UVP
    subw y,#UBASE 
    ldw (FCB_DATA_SIZE,X),Y 
    ld a,#FILE_SAVE 
    jra set_file_op 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   LOAD file_name ( -- )
; load user image file 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    _HEADER LOAD,4,"LOAD"
    call set_file_name 
    pushw X 
    ldw X,#fcb 
    ldw y,#UBASE 
    ldw (FCB_BUFFER,x),y 
    ld a,#FILE_LOAD 
    jra set_file_op 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   DIR  ( -- )
; list available files 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    _HEADER DIR,3,"DIR"    
    pushw x 
    call CRLF 
    ldw x,#fcb 
    ld a,#FILE_LIST 
    jra set_file_op 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   DELETE file_name ( -- )
;   delete file 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    _HEADER DELETE,6,"DELETE"
    call set_file_name 
    pushw x 
    ldw x,#fcb 
    ld a,#FILE_ERASE 

set_file_op:
    push a 
    call CRLF
    pop a 
    ld (FCB_OPERATION,x),a 
    call file_op 
    popw x  
    ret 
