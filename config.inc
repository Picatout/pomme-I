;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  system configuration parameters 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; version du projet pomme-I
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
P1_MAJOR=1 
P1_MINOR=1
P1_REV=0 


DEBUG=0 ; set to 1 to embed debug support code.

STACK_SIZE==128 ; at end of RAM 
PAD_SIZE==BLOCK_SIZE ; 128 bytes below stack 
TIB_SIZE==128 ; below pad 
PAGE0_SIZE==256 ; reserved for system variables 
FREE_RAM==RAM_SIZE-STACK_SIZE-PAD_SIZE-TIB_SIZE-PAGE0_SIZE ; 5504

;SYS_SIZE=0x4000 ; flash reserved for system 16KB 
; file system in flash memory to save BASIC programs 
;FS_BASE==0xC000 ; file system base address 49152 
;FS_SIZE==0xC000 ; file system size 49152 bytes  48KB 

APP_DATA_ORG=0x60

HSI=1 ; set this to 1 if using internal high speed oscillator  
.if HSI 
FMSTR=16
CLK_SRC=CLK_SWR_HSI 
HSE=0
.else
HSE=1
FMSTR=24 
CLK_SRC=CLK_SWR_HSE   
.endif 


    .include "inc/stm8s207.inc" 
    .include "inc/nucleo_8s207.inc"
	.include "inc/ascii.inc"
	.include "inc/gen_macros.inc" 
	.include "app_macros.inc" 
    .include "arithm16_macros.inc" 
    .include "inc/files.inc"

