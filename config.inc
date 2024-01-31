;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  system configuration parameters 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DEBUG=0 ; set to 1 to embed debug support code.

STACK_SIZE==128 ; at end of RAM 
PAD_SIZE==BLOCK_SIZE ; 128 bytes below stack 
TIB_SIZE==128 ; below pad 
PAGE0_SIZE==256 ; reserved for system variables 
FREE_RAM==RAM_SIZE-STACK_SIZE-PAD_SIZE-TIB_SIZE-PAGE0_SIZE ; 5504
SYS_SIZE=0x4000 ; flash reserved for system 16KB 
; file system in flash memory to save BASIC programs 
FS_BASE==0xC000 ; file system base address 49152 
FS_SIZE==0xC000 ; file system size 49152 bytes  48KB 

APP_DATA_ORG=0x30

HSI=1 ; set this to 1 if using internal high speed oscillator  
.if HSI 
HSE=0
.else
HSE=1  
.endif 

FMSTR=16 ; master clock frequency in Mhz 

; boards list
; set selected board to 1  
NUCLEO_8S208RB=0
; use this to ensure 
; only one is selected 
.if NUCLEO_8S208RB 
NUCLEO_8S207K8=0
.else 
NUCLEO_8S207K8=1
.endif 

; NUCLEO-8S208RB config.
.if NUCLEO_8S208RB 
    .include "inc/stm8s208.inc" 
    .include "inc/nucleo_8s208.inc"
.endif  

; NUCLEO-8S207K8 config. 
.if NUCLEO_8S207K8 
    .include "inc/stm8s207.inc" 
    .include "inc/nucleo_8s207.inc"
.endif 

; all boards includes 

	.include "inc/ascii.inc"
	.include "inc/gen_macros.inc" 
	.include "app_macros.inc" 
    .include "arithm16_macros.inc" 

