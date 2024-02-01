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

; to enable _TP macro 
; set to 1 
DEBUG=0

; constants to select board
; to assemble for a specific 
; board or MCU set it to 1 and the other
; to 0. 
NUCLEO_8S207K8=1
NUCLEO_8S208RB=0

.if NUCLEO_8S207K8 
NUCLEO_8S208RB=0
.endif 

; select end of line character
EOL_CR=1
EOL_LF=0 

; set to 1 to include 
; scaling constants vocabulary
; file: const_ratio.asm 
WANT_SCALING_CONST = 0

; set to 1 to include 
; constants tables vocabulary 
; file: ctable.asm 
WANT_CONST_TABLE=0

; include double library 
WANT_DOUBLE = 0

; to include 32 bits  
; floating point library
; file: float.asm   
WANT_FLOAT = 0
.if WANT_FLOAT 
	WANT_DOUBLE=1 ; required by float32 
.endif 

; to include 24 bits 
; floating point library
; file: float24.asm 
WANT_FLOAT24 = 0
.if WANT_FLOAT24
	WANT_FLOAT= 0 
	WANT_DOUBLE=0 ; not compatible with float24 
.endif

; set to 1 to make vocabulary 
; case sensitive 
CASE_SENSE = 0 


	
 


