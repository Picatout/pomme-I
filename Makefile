#############################
# pomme-I make file
#############################
#############################
# Make file for NUCLEO-8S207K8 board
#############################
BOARD=stm8s207k8
PROGRAMMER=stlinkv21
FLASH_SIZE=65536
BOARD_INC=../inc/stm8s207.inc ../inc/nucleo_8s207.inc

NAME=pomme_1
SDAS=sdasstm8
SDCC=sdcc
SDAR=sdar
OBJCPY=objcpy 
CFLAGS=-mstm8 -lstm8
INC=../inc/
INCLUDES=$(BOARD_INC) $(INC)ascii.inc $(INC)gen_macros.inc cmd_idx.inc\
         app_macros.inc arithm16_macros.inc 
BUILD=build/
KERNEL=hardware_init.asm p1Kernel.asm arithm16.asm terminal.asm std_func.asm spi.asm files.asm 
MONITOR=p1Monitor.asm  
MONA=mona/mona.asm mona/mona_glbls.asm mona/mona_dasm.asm
BASIC=p1Basic/code_address.asm p1Basic/compiler.asm p1Basic/decompiler.asm p1Basic/error.asm p1Basic/p1Basic.asm 
FORTH=p1Forth/p1Forth.asm
OBJ=$(BUILD)$(BOARD)/p1Kernel.rel $(BUILD)p1Monitor.rel $(BUILD)p1Basic.rel $(BUILD)p1Forth.rel 
FLASH=stm8flash
EMBEDDED=p1Monitor p1Basic p1Forth

.PHONY: pomme 

pomme: clean kernel $(EMBEDDED)
	#
	# "*************************************"
	# "compiling $(NAME)  for $(BOARD)      "
	# "*************************************"
	$(SDCC) $(CFLAGS) -Wl-u -o $(BUILD)$(BOARD)/$(NAME).ihx $(OBJ) 
	objcopy -Iihex -Obinary  $(BUILD)$(BOARD)/$(NAME).ihx $(BUILD)$(BOARD)/$(NAME).bin 
	# 
	@ls -l  $(BUILD)$(BOARD)/$(NAME).bin 
	# 

hse24m: pomme # cristal externe 24Mhz 
	cp $(BUILD)$(BOARD)/$(NAME).bin dist/pomme_1_hse24m.bin 

hsi16m: pomme # oscillateur interne 16Mhz 
	cp $(BUILD)$(BOARD)/$(NAME).bin dist/pomme_1_hsi16m.bin 


.PHONY: clean 
clean:
	#
	# "***************"
	# "cleaning files"
	# "***************"
	rm -f $(BUILD)$(BOARD)/*


kernel:
	# "***********************"
	# "compiling kernel"
	# "***********************"
	$(SDAS) -g -l -o $(BUILD)$(BOARD)/p1Kernel.rel $(KERNEL)  


# kernel test 
ktest: clean $(KERNEL) ktest.asm 
	$(SDAS) -g -l -o $(BUILD)$(BOARD)/ktest.rel $(KERNEL)  ktest.asm 
	$(SDCC) $(CFLAGS) -Wl-u -o $(BUILD)$(BOARD)/ktest.ihx $(BUILD)$(BOARD)/ktest.rel 
	$(FLASH) -c $(PROGRAMMER) -p $(BOARD) -s flash -w $(BUILD)$(BOARD)/ktest.ihx

############################
##  embedded applications ##
############################

p1Monitor: $(MONITOR)
	# "*****************"
	# "compiling monitor"
	# "*****************"
	$(SDAS) -g -l -o $(BUILD)p1Monitor.rel $(MONITOR) 

mona: $(MONA)
	#"*********************"
	#" compiling mona"
	#"*********************"
	$(SDAS) -g -l -s -o $(BUILD)mona.rel $(MONA)

p1Basic: $(BASIC)
	# "*****************"
	# "compiling BASIC  "
	# "*****************"
	$(SDAS) -g -l -o $(BUILD)p1Basic.rel $(BASIC)

p1Forth:  $(FORTH)
	# "*****************"
	# "compiling Forth"
	# "*****************"
	$(SDAS) -g -l -o $(BUILD)p1Forth.rel $(FORTH)


usr_test:
	$(SDAS) -g -l -o $(BUILD)$(BOARD)/square.rel square.asm  


flash_hse24m: 
	$(FLASH) -c $(PROGRAMMER) -p $(BOARD) -s flash -w dist/pomme_1_hse24m.bin 

flash_hsi16m:
	$(FLASH) -c $(PROGRAMMER) -p $(BOARD) -s flash -w dist/pomme_1_hsi16m.bin 	 


# read flash memory 
read: 
	$(FLASH) -c $(PROGRAMMER) -p $(BOARD) -s flash -b 32768 -r flash.dat 

# erase flash memory from 0x8000-0xffff 
erase:
	dd if=/dev/zero bs=1 count=32768 of=zero.bin
	$(FLASH) -c $(PROGRAMMER) -p$(BOARD) -s flash -b 32768 -w zero.bin 
	rm -f zero.bin 

.PHONY: ee_clear 
# erase eeprom first 16 bytes 
ee_clear: 
	dd if=/dev/zero bs=1 count=16 of=zero.bin
	$(FLASH) -c $(PROGRAMMER) -p$(BOARD) -s eeprom -b 16 -w zero.bin 
	rm -f zero.bin 
 
