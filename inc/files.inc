;;
; Copyright Jacques Deschênes 2023,2024  
; This file is part of pomme-I 
;
;     pomme-I is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.
;
;     pomme-I is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.
;
;     You should have received a copy of the GNU General Public License
;     along with pomme-I.  If not, see <http://www.gnu.org/licenses/>.
;;

;---------------------------------
;  files.asm  constants 
;---------------------------------
FNAME_MAX_LEN =16 
FILE_SIGN="PF"  ; file signature sector used by Pomme-I File.
FILE_ERASED="XX" ; erased file, replace USED. 
FILE_SIGN_FIELD = 0 ; signature offset 2 bytes 
FILE_SIZE_FIELD = 2 ; size offset 2 bytes 
FILE_NAME_FIELD = 4 ; file name 16 byte 
FILE_HEADER_SIZE = FILE_NAME_FIELD+FNAME_MAX_LEN ; 20 bytes 
FILE_DATA = FILE_HEADER_SIZE ; data offset 
FSECTOR_SIZE =256 ; file sector size  

; files control block fields 
FCB_DATA_SIZE=0 ; file data size, 2 BYTES 
FCB_NAME=2 ; 16 BYTES 
FCB_BUFFER=FCB_NAME+FNAME_MAX_LEN ; address data buffer, 2 BYTES 
FCB_OPERATION=FCB_BUFFER+2 ; file operation 1 BYTE 
FCB_OP_STATUS=FCB_OPERATION+1 ; operation status 1 BYTE  
FCB_SIZE =FCB_OP_STATUS+1 ; BYTES 

; file operations
FILE_NOP=0 ; no operation  
FILE_SAVE=1 ; save file 
FILE_LOAD=2  ; load file 
FILE_ERASE=3  ; erase file 
FILE_LIST=4 ;  list files stored
FILE_ERASE_ALL=5 ; erase all files 

; file operation status 
FILE_OP_SUCCESS=0 ; 
FILE_OP_SPACE=1 ; not enough space 
FILE_OP_CLASH=2 ; name clash 
FILE_OP_NOT_FOUND=3 ; file not found 

