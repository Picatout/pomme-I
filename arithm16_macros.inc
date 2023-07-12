;;
; Copyright Jacques Deschênes 2019,2020,2021,2022  
; This file is part of stm8_tbi 
;
;     stm8_tbi is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.
;
;     stm8_tbi is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.
;
;     You should have received a copy of the GNU General Public License
;     along with stm8_tbi.  If not, see <http://www.gnu.org/licenses/>.
;;




	INT_SIZE==2 ; 2's complement 16 bits integers {-32767...32767} 
	CELL_SIZE==INT_SIZE 


    ; store int16 from X to stack 
    .macro _i16_store  i 
    ldw (i,sp),x 
    .endm 

    ; fetch int16 from stack to X 
    .macro _i16_fetch i 
    ldw x,(i,sp)
    .endm 

    ; pop int16 from top of stack 
    .macro _i16_pop 
    popw x 
    .endm 

    ; push int16 on stack 
    .macro _i16_push 
    pushw X
    .endm 

