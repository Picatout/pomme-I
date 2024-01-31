;
; Copyright Jacques Deschênes 2023 
; This file is part of stm8_terminal 
;
;     stm8_terminal is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.
;
;     stm8_terminal is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.
;
;     You should have received a copy of the GNU General Public License
;     along with stm8_terminal.  If not, see <http://www.gnu.org/licenses/>.
;;



CHAR_PER_LINE==40
LINE_PER_SCREEN==25 
VISIBLE_SCAN_LINES=200 

; values based on 20 Mhz crystal

FR_HORZ=15734
HLINE=(FMSTR*1000/FR_HORZ-1); horizontal line duration 
HALF_LINE=HLINE/2 ; half-line during sync. 
EPULSE=47 ; pulse width during pre and post equalization
VPULSE=546 ; pulse width during vertical sync. 
HPULSE=94 ; 4.7µSec horizontal line sync pulse width. 
LINE_DELAY=(160) 

; ntsc synchro phases 
PH_VSYNC=0 
PH_PRE_VIDEO=1
PH_VIDEO=2 
PH_POST_VIDEO=3 

FIRST_VIDEO_LINE=50 
VIDEO_LINES=200 

;ntsc flags 
F_EVEN=0 ; odd/even field flag 
F_CURSOR=1 ; tv cursor active 
F_CUR_VISI=2 ; tv cursor state, 1 visible 
F_LECHO=3 ; local echo 

;-------------------------------
    .area CODE 
;------------------------------

;------------------------------
; initialize TIMER1 for 
; NTSC synchronisation 
; signal 
;------------------------------
ntsc_init:
    _clrz ntsc_flags 
    _clrz ntsc_phase 
; set MOSI pin as output high-speed push-pull 
    bset PC_DDR,#6 
    bres PC_ODR,#6
    bset PC_CR1,#6
    bset PC_CR2,#6
; initialize timer1 for pwm 
    mov TIM1_IER,#1 ; UIE set 
    bset TIM1_CR1,#TIM1_CR1_ARPE ; auto preload enabled 
    mov TIM1_CCMR1,#(7<<TIM1_CCMR1_OCMODE)  |(1<<TIM1_CCMR1_OC1PE)
    bset TIM1_CCER1,#0
    bset TIM1_BKR,#7
; use channel to for video stream trigger 
; set pixel out delay   
    mov TIM1_CCMR2,#(6<<TIM1_CCMR2_OCMODE) 
    mov TIM1_CCR2H,#LINE_DELAY>>8 
    mov TIM1_CCR2L,#LINE_DELAY&0xFF
    bset TIM1_CCER2,#0      
; begin with PH_PRE_EQU odd field 
    _clrz ntsc_phase 
    mov TIM1_ARRH,#HLINE>>8 
    mov TIM1_ARRL,#HLINE&0XFF
    mov TIM1_CCR1H,#HPULSE>>8 
    mov TIM1_CCR1L,#HPULSE&0XFF
    bset TIM1_CR1,#TIM1_CR1_CEN
    bset TIM1_EGR,#TIM1_EGR_UG      
    ldw x,#font_6x8
    _strxz font_addr 
    call tv_cls 
    call tv_enable_cursor
    ret 

;-------------------------------
; TIMER1 update interrupt handler 
; interrupt happend at end 
; of each phase and and pwm 
; is set for next phase 
;-------------------------------
ntsc_sync_interrupt:
    clr TIM1_SR1 
    _ldxz scan_line 
    incw x 
    _strxz scan_line 
    _ldaz ntsc_phase 
    cp a,#PH_VSYNC  
    jrne test_pre_video 
    cpw x,#1 
    jrne  1$ 
    mov TIM1_ARRH,#HALF_LINE>>8 
    mov TIM1_ARRL,#HALF_LINE & 0xff 
    mov TIM1_CCR1H,#EPULSE>>8 
    mov TIM1_CCR1L,#EPULSE&0xff 
    jp sync_exit 
1$: cpw x,#7 
    jrne 2$ 
    mov TIM1_CCR1H,#VPULSE>>8 
    mov TIM1_CCR1L,#VPULSE&0xff 
    jp sync_exit 
2$:
    cpw x,#13 
    jrne 3$ 
    mov TIM1_CCR1H,#EPULSE>>8 
    mov TIM1_CCR1L,#EPULSE&0xff 
    jp sync_exit 
3$: 
    cpw x,#18 
    jrne 5$ 
    btjt ntsc_flags,#F_EVEN,sync_exit 
4$:
    mov TIM1_ARRH,#HLINE>>8 
    mov TIM1_ARRL,#HLINE & 0xff 
    mov TIM1_CCR1H,#HPULSE>>8 
    mov TIM1_CCR1L,#HPULSE&0xff 
    inc a 
    jp sync_exit 
5$: 
    cpw x,#19 
    jreq 4$ 
    jra sync_exit 
test_pre_video:
    cp a,#PH_PRE_VIDEO 
    jrne post_video  
    cpw x,#FIRST_VIDEO_LINE
    jrne sync_exit 
    inc a 
    bres TIM1_IER,#TIM1_IER_UIE 
    bset TIM1_IER,#TIM1_IER_CC2IE
    jra sync_exit
post_video:
    cpw x,#271
    jrne 2$ 
    btjf ntsc_flags,#F_EVEN,#3$  
    jra sync_exit  
2$: 
    cpw x,#272 
    jrne sync_exit 
    mov TIM1_ARRH,#HALF_LINE>>8
    mov TIM1_ARRL,#HALF_LINE & 0xff 
3$: ;field end     
    clr a 
    clrw x 
    _strxz scan_line
    bcpl ntsc_flags,#F_EVEN
sync_exit:
    _straz ntsc_phase
    iret 



;----------------------------------
; TIMER1 compare interrupt handler
;----------------------------------
; shift out character bits 
    .macro _shift_out_char  
        .rept 6
            rlc a ; 1 CY 
            bccm PC_ODR,#6 ; 1 cy  
        .endm ; 12 cy 
        nop ; 1 cy 
        bres PC_ODR,#6 ; 1 cy 
   .endm ; 14 cy 

    .macro _shift_out_scan_line
        n=0
        .rept CHAR_PER_LINE
            ldw y,x  ; 1cy 
            ldw y,(n,y)  ; 2 cy 
            addw y,(FONT_ROW,sp) ; 2 cy 
            ld a,(y) ; 1 cy 
            _shift_out_char ; 14 cy  
            n=n+2 
        .endm ; 
    .endm  20 cy

    FONT_ROW=1 ; font_char_row  
    VSIZE=2   
ntsc_video_interrupt:
    _vars VSIZE
    clr (FONT_ROW,sp) 
    clr TIM1_SR1    
; compute postion in buffer 
; X=scan_line/16*CHAR_PER_LINE+video_buffer  
; FONT_ROW=scan_line%8     
    _ldxz scan_line 
    subw x,#FIRST_VIDEO_LINE
    ld a,#8 
    div x,a
    ld (FONT_ROW+1,sp),a    
    ld a,#2*CHAR_PER_LINE  
    mul x,a  ; video_buffer line  
    addw x,#video_buffer
    _shift_out_scan_line 
    _ldxz scan_line 
    incw x 
    _strxz scan_line 
    cpw x,#FIRST_VIDEO_LINE+VIDEO_LINES
    jrmi 3$ 
    bres TIM1_IER,#TIM1_IER_CC2IE
    bset TIM1_IER,#TIM1_IER_UIE
3$:  
    _drop VSIZE 
    iret 

