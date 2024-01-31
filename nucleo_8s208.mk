#############################
# Make file for NUCLEO board
#############################
BOARD=stm8s208rb
PROGRAMMER=stlinkv21
FLASH_SIZE=131072
BOARD_INC=../inc/stm8s208.inc ../inc/nucleo_8s208.inc
include Makefile
