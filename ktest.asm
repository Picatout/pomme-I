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

;----------------------------
;  kernel test program 
;----------------------------


test_info: .asciz "pomme I kernel test program.\n"
echo_test: .asciz "echo test type, <ENTER> to end\n"
readln_test: .asciz "readln test, input line\n"
tone_test: .asciz " 440 hertz, 750 msec\n"
reboot_test: .asciz " any key to reboot\n"
ticks_test: .asciz "msec since reset: " 
prng_test: .asciz "GET_RND test 10 values: "

    .macro _syscall code 
    ld a,#code
    trap 
    .endm 

kernel_test:
    _syscall CLS 
    ldw x,#test_info 
    _syscall PRT_STR
echo:    
    ldw x,#echo_test 
    _syscall PRT_STR 
echo.loop:
    _syscall GETC 
    ld xl,a 
    _syscall PUTC 
    cp a,#CR
    jreq gets_test  
    cp a,#LF 
    jreq gets_test
    jra echo.loop 
gets_test:
    ldw x,#readln_test 
    _syscall PRT_STR
    ldw x,#40 
    ldw y,#tib 
    _syscall GETLN 
    _syscall PRT_STR
    ldw x,#CR 
    _syscall PUTC 
; print ticks 
    ldw x,#ticks_test
    _syscall PRT_STR 
    _syscall SYS_TICKS 
    _syscall PRT_INT
    ldw x,#CR 
    _syscall PUTC      
; 10 random_number:
    ldw x,#prng_test
    _syscall PRT_STR
    clrw x 
    _syscall SEED_PRNG 
    push #10
1$:     
    _syscall GET_RND 
    _syscall PRT_INT 
    dec (1,sp)
    jrne 1$
; tone test 
    ldw x,#750 
    ldw y,#440 
    _syscall START_TONE
; reboot test
    ldw x,#reboot_test 
    _syscall PRT_STR 
2$:
    _syscall QCHAR      
    tnz a 
    jreq 2$ 
    _syscall SYS_RST 
