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

;---------------------------------------------
;  kernel functions table 
;  functions code is passed in A 
;  parameters are passed in X,Y
;  output returned in A,X,Y,CC  
;
;  code |  function      | input    |  output
;  -----|----------------|----------|---------
;    0  | reset system   | none     | none 
;    1  | ticks          | none     | X=msec ticker 
;    2  | putchar        | X=char   | none 
;    3  | getchar        | none     | A=char
;    4  | querychar      | none     | A=0,-1
;    5  | clr_screen     | none     | none 
;    6  | delback        | none     | none 
;    7  | getline        | X=ln_len | A= line length
;       |                |          | X=buffer
;    8  | puts           | X=*str   | none 
;    9  | print_int      | X=int16  | none 
;       |                | A=unsigned| A=string length 
;    10 | set timer      | X=value  | none 
;   11  | check time out | none     | A=0|-1 
;   12  | génère une     | X=msec   | 
;       | tonalité audio | Y=Freq   | none
;   13  | file operation | X=*FCB   | X=*FCB 
;   14  | get random #   | none     | X = random value 
;   15  | seed prng      | X=param  | none  
;----------------------------------------------
; syscall codes  
; global constants 

    SYS_RST==0
    SYS_TICKS=1 
    PUTC==2
    GETC==3 
    QCHAR==4
    CLS==5
    DELBK==6
    GETLN==7 
    PRT_STR==8
    PRT_INT==9 
    SET_TIMER==10
    CHK_TIMOUT==11 
    TONE==12
    FILE_OP=13  
    GET_RND==14
    SEED_PRNG==15 

