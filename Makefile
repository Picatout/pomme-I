#############################
# TinyBasic make file
#############################
NAME=pomme_1
SDAS=sdasstm8
SDCC=sdcc
SDAR=sdar
OBJCPY=objcpy 
CFLAGS=-mstm8 -lstm8 -L$(LIB_PATH) -I../inc
INC=../inc/
INCLUDES=$(BOARD_INC) $(INC)ascii.inc $(INC)gen_macros.inc cmd_idx.inc\
         app_macros.inc arithm16_macros.inc dbg_macros.inc 
BUILD=build/
KERNEL=hardware_init.asm p1Kernel.asm arithm16.asm terminal.asm std_func.asm spi.asm 
MONITOR=p1Monitor.asm
BASIC=code_address.asm compiler.asm decompiler.asm files.asm error.asm p1Basic.asm 
SRC=$(KERNEL) $(MONITOR) $(BASIC) 
OBJECT=$(BUILD)$(BOARD)/$(NAME).rel
OBJECTS=$(BUILD)$(BOARD)/$(SRC:.asm=.rel)
LIST=$(BUILD)$(BOARD)/$(NAME).lst
FLASH=stm8flash


.PHONY: all

all: clean 
	#
	# "*************************************"
	# "compiling $(NAME)  for $(BOARD)      "
	# "*************************************"
	$(SDAS) -g -l -o $(BUILD)$(BOARD)/$(NAME).rel $(SRC) 
	$(SDCC) $(CFLAGS) -Wl-u -o $(BUILD)$(BOARD)/$(NAME).ihx $(OBJECT) 
	objcopy -Iihex -Obinary  $(BUILD)$(BOARD)/$(NAME).ihx $(BUILD)$(BOARD)/$(NAME).bin 
	# 
	@ls -l  $(BUILD)$(BOARD)/$(NAME).bin 
	# 


.PHONY: clean 
clean:
	#
	# "***************"
	# "cleaning files"
	# "***************"
	rm -f $(BUILD)$(BOARD)/*


asm_all: clean $(KERNEL) $(MONITOR) $(BASIC)
	$(SDAS) -g -l -o $(BUILD)$(BOARD)/hardware_init.rel hardware_init.asm  
	$(SDAS) -g -l -o $(BUILD)$(BOARD)/p1Kernel.rel p1Kernel.asm  
	$(SDAS) -g -l -o $(BUILD)$(BOARD)/std_func.rel std_func.asm  
	$(SDAS) -g -l -o $(BUILD)$(BOARD)/terminal.rel terminal.asm  
	$(SDAS) -g -l -o $(BUILD)$(BOARD)/arithm16.rel arithm16.asm
	$(SDAS) -g -l -o $(BUILD)$(BOARD)/monitor.rel monitor.asm
	$(SDAS) -g -l -o $(BUILD)$(BOARD)/compiler.rel compiler.asm  
	$(SDAS) -g -l -o $(BUILD)$(BOARD)/decompiler.rel decompiler.asm  
	$(SDAS) -g -l -o $(BUILD)$(BOARD)/code_address.rel code_address.asm  
	$(SDAS) -g -l -o $(BUILD)$(BOARD)/error.rel error.asm 
	$(SDAS) -g -l -o $(BUILD)$(BOARD)/p1Basic.rel p1Basic.asm  
	$(SDAS) -g -l -o $(BUILD)$(BOARD)/flash_prog.rel flash_prog.asm  
	$(SDAS) -g -l -o $(BUILD)$(BOARD)/files.rel files.asm  
	$(SDAS) -g -l -o $(BUILD)$(BOARD)/debug_support.rel debug_support.asm  

# kernel test 
ktest: clean $(KERNEL) ktest.asm 
	$(SDAS) -g -l -o $(BUILD)$(BOARD)/ktest.rel $(KERNEL)  ktest.asm 
	$(SDCC) $(CFLAGS) -Wl-u -o $(BUILD)$(BOARD)/ktest.ihx $(BUILD)$(BOARD)/ktest.rel 
	$(FLASH) -c $(PROGRAMMER) -p $(BOARD) -s flash -w $(BUILD)$(BOARD)/ktest.ihx

monitor: clean $(KERNEL) $(MONITOR)
	$(SDAS) -g -l -o $(BUILD)$(BOARD)/monitor.rel $(KERNEL) $(MONITOR) 
	$(SDCC) $(CFLAGS) -Wl-u -o $(BUILD)$(BOARD)/monitor.ihx $(BUILD)$(BOARD)/monitor.rel 
	$(FLASH) -c $(PROGRAMMER) -p $(BOARD) -s flash -w $(BUILD)$(BOARD)/monitor.ihx


usr_test:
	$(SDAS) -g -l -o $(BUILD)$(BOARD)/square.rel square.asm  

flash: $(LIB)
	#
	# "******************"
	# "flashing $(BOARD) "
	# "******************"
	$(FLASH) -c $(PROGRAMMER) -p $(BOARD) -s flash -w $(BUILD)$(BOARD)/$(NAME).ihx 

# read flash memory 
read: 
	$(FLASH) -c $(PROGRAMMER) -p $(BOARD) -s flash -b 16384 -r flash.dat 

# erase flash memory from 0x8000-0xffff 
erase:
	dd if=/dev/zero bs=1 count=32768 of=zero.bin
	$(FLASH) -c $(PROGRAMMER) -p$(BOARD) -s flash -b 32768 -w zero.bin 
	rm -f zero.bin 

.PHONY: ee_clear 
# erase eeprom 
ee_clear: 
	dd if=/dev/zero bs=1 count=16 of=zero.bin
	$(FLASH) -c $(PROGRAMMER) -p$(BOARD) -s eeprom 16 -w zero.bin 
	rm -f zero.bin 
 
