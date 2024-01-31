;;
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

; table scancode vers ASCII pour clavier MCSaite
    .include "inc/ascii.inc"
    .include "ps2_codes.inc"
    
    
    .area CODE 
    
;table de correspondance code clavier -> code ASCII    
;  .byte code_clavier,code_ascii 
std_codes:
   .byte 0x1c,'A' 
   .byte 0x32,'B'
   .byte 0x21,'C'
   .byte 0x23,'D'
   .byte 0x24,'E'
   .byte 0x2b,'F'
   .byte 0x34,'G'
   .byte 0x33,'H'
   .byte 0x43,'I'
   .byte 0x3B,'J'
   .byte 0x42,'K'
   .byte 0x4b,'L'
   .byte 0x3a,MU	;'M'
   .byte 0x31,NU	;'N'
   .byte 0x44,OU	;'O'
   .byte 0x4d,PU	;'P'
   .byte 0x15,QU	;'Q'
   .byte 0x2d,RU	;'R'
   .byte 0x1b,SU	;'S'
   .byte 0x2c,TU	;'T'
   .byte 0x3c,UU	;'U'
   .byte 0x2a,VU	;'V'
   .byte 0x1d,WU	;'W'
   .byte 0x22,XU	;'X'
   .byte 0x35,YU	;'Y'
   .byte 0x1a,ZU	;'Z'
   .byte 0x45,ZERO	;'0'
   .byte 0x16,ONE 	;'1'
   .byte 0x1e,TWO 	;'2'
   .byte 0x26,THREE	;'3'
   .byte 0x25,FOUR 	;'4'
   .byte 0x2e,FIVE	;'5'
   .byte 0x36,SIX	;'6'
   .byte 0x3d,SEVEN	;'7'
   .byte 0x3e,EIGHT	;'8'
   .byte 0x46,NINE	;'9'
   .byte 0x0e,ACUT   ;'`'
   .byte 0x4e,DASH   ;'-'
   .byte 0x55,EQUAL  ;'='
   .byte 0x5d,BSLA   ;'\\'
   .byte 0x54,LBRK   ;'['
   .byte 0x5b,RBRK   ;']'
   .byte 0x4c,SEMIC   ;';'
   .byte 0x52,TICK   ;'\''
   .byte 0x41,COMMA   ;','
   .byte 0x49,DOT    ;'.'
   .byte 0x7c,STAR   ;'*'
   .byte 0x79,PLUS   ;'+'
   .byte 0x29,SPACE  ;' '
   .byte SC_ENTER,CR ;'\r'
   .byte SC_BKSP,BS	;back space
   .byte SC_TAB,TAB  ; tabulation 
   .byte SC_ESC,ESC  ; escape 
   .byte SC_NUM,VK_NUM ; num lock
   .byte SC_KP0,ZERO    ;'0'
   .byte SC_KP1,ONE     ;'1'
   .byte SC_KP2,TWO     ;'2'
   .byte SC_KP3,THREE    ;'3'
   .byte SC_KP4,FOUR    ;'4'
   .byte SC_KP5,FIVE   ;'5'
   .byte SC_KP6,SIX     ;'6'
   .byte SC_KP7,SEVEN    ;'7'
   .byte SC_KP8,EIGHT    ;'8'
   .byte SC_KP9,NINE    ;'9'
   .byte SC_KPMUL,STAR	;'*'
   .byte SC_KPDIV,SLASH	;'/'
   .byte SC_KPPLUS,PLUS	;'+'
   .byte SC_KPMINUS,DASH	;'-'
   .byte SC_KPDOT,DOT	;'.'
   .byte SC_KPENTER,CR	;'\r'
   .byte SC_F1,VK_F1
   .byte SC_F2,VK_F2
   .byte SC_F3,VK_F3
   .byte SC_F4,VK_F4
   .byte SC_F5,VK_F5
   .byte SC_F6,VK_F6
   .byte SC_F7,VK_F7
   .byte SC_F8,VK_F8
   .byte SC_F9,VK_F9
   .byte SC_F10,VK_F10
   .byte SC_F11,VK_F11
   .byte SC_F12,VK_F12
   .byte SC_LSHIFT,VK_LSHIFT
   .byte SC_RSHIFT,VK_RSHIFT
   .byte SC_LCTRL,VK_LCTRL
   .byte SC_LALT,VK_LALT
   .byte SC_LSHIFT,VK_LSHIFT
   .byte SC_RSHIFT,VK_RSHIFT
   .byte SC_CAPS,VK_CAPS
   .byte 0

;; extended codes table 
xt_codes:
    .byte SC_RCTRL,VK_RCTRL
    .byte SC_LGUI,VK_LGUI
    .byte SC_RGUI,VK_RGUI 
    .byte SC_RALT,VK_RALT
    .byte SC_APPS,VK_APPS
    .byte SC_UP,VK_UP
    .byte SC_DOWN,VK_DOWN
    .byte SC_LEFT,VK_LEFT
    .byte SC_RIGHT,VK_RIGHT
    .byte SC_INSERT,VK_INSERT
    .byte SC_HOME,VK_HOME
    .byte SC_PGUP,VK_PGUP
    .byte SC_PGDN,VK_PGDN
    .byte SC_DEL,DEL
    .byte SC_END,VK_END
    .byte SC_KPDIV,'/'
    .byte SC_KPENTER,'\r'
    .byte SC_LWINDOW, VK_LWINDOW
    .byte SC_RWINDOW, VK_RWINDOW
    .byte SC_MENU,VK_MENU
    .byte 0x12,VK_PRN
    .byte 0x7c,0
    .byte 0
    
   
;;shifted codes 
shifted_codes:
   .byte '1,EXCLA   ;'!'
   .byte '2,AROB    ;'@'
   .byte '3,SHARP   ;'#'
   .byte '4,DOLLR   ;'$'
   .byte '5,PRCNT   ;'%'
   .byte '6,CIRC    ;'^'
   .byte '7,AMP	    ;'&'
   .byte '8,STAR    ;'*'
   .byte '9,LPAR    ;'('
   .byte '0,RPAR    ;')'
   .byte DASH,UNDR ;'_'
   .byte EQUAL,PLUS	;'+'
   .byte ACUT,TILD ;'~'
   .byte TICK,DQUOT	;'"'
   .byte COMMA,LT   ;'<'
   .byte DOT,GT    ;'>'
   .byte SLASH,QUST	;'?'
   .byte BSLA,PIPE ;'|'
   .byte SEMIC,COLON  ;':'
   .byte LBRK,LBRC ;'[','{'
   .byte RBRK,RBRC ;']','}'
   .byte VK_UP,VK_SUP  ; <SHIFT>-<UP>
   .byte VK_DOWN,VK_SDOWN ; <SHIFT>-<DOWN>
   .byte VK_LEFT,VK_SLEFT ; <SHIFT>-<LEFT>
   .byte VK_RIGHT,VK_SRIGHT ; <SHIFT>-<RIGHT>
   .byte VK_HOME,VK_SHOME ; <SHIFT>-<HOME>
   .byte VK_END,VK_SEND ; <SHIFT>-<END>
   .byte VK_PGUP,VK_SPGUP ; <SHIFT>-<PGUP>
   .byte VK_PGDN,VK_SPGDN ; <SHIFT>-<PGDN>
   .byte VK_DELETE,VK_SDEL ; <SHIFT-<DELETE>
   .byte 0
   
;;altchar codes 
altchar_codes:
   .byte '1,BSLA    ;'\\'
   .byte '2,AROB    ;'2','@'
   .byte '3,SLASH   ;'3','/'
   .byte '6,QUST    ;'6','?'
   .byte '7,PIPE    ;'7','|'
   .byte '9,LBRC    ;'9','{'
   .byte '0,RBRC    ;'0','}'
   .byte 0
   
; CTRL alternate codes     
control_codes: 
    .byte BS,VK_CBACK  ; <CTRL>-<BACKSPACE>
    .byte VK_UP,VK_CUP  ; <CTRL>-<UP>
    .byte VK_DOWN,VK_CDOWN ; <CTRL>-<DOWN>
    .byte VK_LEFT,VK_CLEFT ; <CTRL>-<LEFT>
    .byte VK_RIGHT,VK_CRIGHT ; <CTRL>-<RIGHT>
    .byte VK_HOME,VK_CHOME ; <CTRL>-<HOME>
    .byte VK_END,VK_CEND ; <CTRL>-<END>
    .byte VK_PGUP,VK_CPGUP ; <CTRL>-<PGUP>
    .byte VK_PGDN,VK_CPGDN ; <CTRL>-<PGDN>
    .byte VK_DELETE,VK_CDEL ; <CTRL>-<DEL>
    .byte 0
    



