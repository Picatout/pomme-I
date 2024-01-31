ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 1.
Hexadecimal [24-Bits]



                                      1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                      2 ;; Copyright Jacques Deschênes 2024
                                      3 ;; This file is part of p1Forth  
                                      4 ;;
                                      5 ;;     stm8_eforth is free software: you can redistribute it and/or modify
                                      6 ;;     it under the terms of the GNU General Public License as published by
                                      7 ;;     the Free Software Foundation, either version 3 of the License, or
                                      8 ;;     (at your option) any later version.
                                      9 ;;
                                     10 ;;     p1Forth is distributed in the hope that it will be useful,
                                     11 ;;     but WITHOUT ANY WARRANTY;; without even the implied warranty of
                                     12 ;;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                                     13 ;;     GNU General Public License for more details.
                                     14 ;;
                                     15 ;;     You should have received a copy of the GNU General Public License
                                     16 ;;     along with p1Forth.  If not, see <http:;;www.gnu.org/licenses/>.
                                     17 ;;;;
                                     18 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     19 
                                     20 ;-------------------------------------------------------------
                                     21 ;  eForth for STM8S adapted from C. H. Ting source file to 
                                     22 ;  assemble using sdasstm8
                                     23 ;  implemented on NUCLEO-8S208RB board
                                     24 ;  Adapted by picatout 2019/10/27
                                     25 ;  https://github.com/picatout/stm8_nucleo/eForth
                                     26 ;
                                     27 ;  Adapted to pomme-I computer 2024/01/29
                                     28 ;--------------------------------------------------------------
                                     29 	.module EFORTH
                                     30          .optsdcc -mstm8
                                     31 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 2.
Hexadecimal [24-Bits]



                                     32         .include "../config.inc"  
                                      1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                      2 ;;  system configuration parameters 
                                      3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                      4 
                           000000     5 DEBUG=0 ; set to 1 to embed debug support code.
                                      6 
                           000080     7 STACK_SIZE==128 ; at end of RAM 
                           000080     8 PAD_SIZE==BLOCK_SIZE ; 128 bytes below stack 
                           000080     9 TIB_SIZE==128 ; below pad 
                           000100    10 PAGE0_SIZE==256 ; reserved for system variables 
                           001580    11 FREE_RAM==RAM_SIZE-STACK_SIZE-PAD_SIZE-TIB_SIZE-PAGE0_SIZE ; 5504
                           004000    12 SYS_SIZE=0x4000 ; flash reserved for system 16KB 
                                     13 ; file system in flash memory to save BASIC programs 
                           00C000    14 FS_BASE==0xC000 ; file system base address 49152 
                           00C000    15 FS_SIZE==0xC000 ; file system size 49152 bytes  48KB 
                                     16 
                           000030    17 APP_DATA_ORG=0x30
                                     18 
                           000001    19 HSI=1 ; set this to 1 if using internal high speed oscillator  
                           000001    20 .if HSI 
                           000000    21 HSE=0
                           000000    22 .else
                                     23 HSE=1  
                                     24 .endif 
                                     25 
                           000010    26 FMSTR=16 ; master clock frequency in Mhz 
                                     27 
                                     28 ; boards list
                                     29 ; set selected board to 1  
                           000000    30 NUCLEO_8S208RB=0
                                     31 ; use this to ensure 
                                     32 ; only one is selected 
                           000000    33 .if NUCLEO_8S208RB 
                                     34 NUCLEO_8S207K8=0
                           000001    35 .else 
                           000001    36 NUCLEO_8S207K8=1
                                     37 .endif 
                                     38 
                                     39 ; NUCLEO-8S208RB config.
                           000000    40 .if NUCLEO_8S208RB 
                                     41     .include "inc/stm8s208.inc" 
                                     42     .include "inc/nucleo_8s208.inc"
                                     43 .endif  
                                     44 
                                     45 ; NUCLEO-8S207K8 config. 
                           000001    46 .if NUCLEO_8S207K8 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 3.
Hexadecimal [24-Bits]



                                     47     .include "inc/stm8s207.inc" 
                                      1 ;;
                                      2 ; Copyright Jacques Deschênes 2019,2022 
                                      3 ; This file is part of MONA 
                                      4 ;
                                      5 ;     MONA is free software: you can redistribute it and/or modify
                                      6 ;     it under the terms of the GNU General Public License as published by
                                      7 ;     the Free Software Foundation, either version 3 of the License, or
                                      8 ;     (at your option) any later version.
                                      9 ;
                                     10 ;     MONA is distributed in the hope that it will be useful,
                                     11 ;     but WITHOUT ANY WARRANTY; without even the implied warranty of
                                     12 ;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                                     13 ;     GNU General Public License for more details.
                                     14 ;
                                     15 ;     You should have received a copy of the GNU General Public License
                                     16 ;     along with MONA.  If not, see <http://www.gnu.org/licenses/>.
                                     17 ;;
                                     18 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     19 ; 2022/11/14
                                     20 ; STM8S207K8 µC registers map
                                     21 ; sdas source file
                                     22 ; author: Jacques Deschênes, copyright 2018,2019,2022
                                     23 ; licence: GPLv3
                                     24 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     25 
                                     26 ;;;;;;;;;;;
                                     27 ; bits
                                     28 ;;;;;;;;;;;;
                           000000    29  BIT0 = 0
                           000001    30  BIT1 = 1
                           000002    31  BIT2 = 2
                           000003    32  BIT3 = 3
                           000004    33  BIT4 = 4
                           000005    34  BIT5 = 5
                           000006    35  BIT6 = 6
                           000007    36  BIT7 = 7
                                     37  	
                                     38 ;;;;;;;;;;;;
                                     39 ; bits masks
                                     40 ;;;;;;;;;;;;
                           000001    41  B0_MASK = (1<<0)
                           000002    42  B1_MASK = (1<<1)
                           000004    43  B2_MASK = (1<<2)
                           000008    44  B3_MASK = (1<<3)
                           000010    45  B4_MASK = (1<<4)
                           000020    46  B5_MASK = (1<<5)
                           000040    47  B6_MASK = (1<<6)
                           000080    48  B7_MASK = (1<<7)
                                     49 
                                     50 ; HSI oscillator frequency 16Mhz
                           F42400    51  FHSI = 16000000
                                     52 ; LSI oscillator frequency 128Khz
                           01F400    53  FLSI = 128000 
                                     54 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 4.
Hexadecimal [24-Bits]



                                     55 ; controller memory regions
                           001800    56  RAM_SIZE = (0x1800) ; 6KB 
                           000400    57  EEPROM_SIZE = (0x400) ; 1KB
                                     58 ; STM8S207K8 have 64K flash
                           010000    59  FLASH_SIZE = (0x10000)
                                     60 ; erase block size 
                           000080    61 BLOCK_SIZE=128 ; bytes 
                                     62 
                           000000    63  RAM_BASE = (0)
                           0017FF    64  RAM_END = (RAM_BASE+RAM_SIZE-1)
                           004000    65  EEPROM_BASE = (0x4000)
                           0043FF    66  EEPROM_END = (EEPROM_BASE+EEPROM_SIZE-1)
                           005000    67  SFR_BASE = (0x5000)
                           0057FF    68  SFR_END = (0x57FF)
                           006000    69  BOOT_ROM_BASE = (0x6000)
                           007FFF    70  BOOT_ROM_END = (0x7fff)
                           008000    71  FLASH_BASE = (0x8000)
                           017FFF    72  FLASH_END = (FLASH_BASE+FLASH_SIZE-1)
                           004800    73  OPTION_BASE = (0x4800)
                           000080    74  OPTION_SIZE = (0x80)
                           00487F    75  OPTION_END = (OPTION_BASE+OPTION_SIZE-1)
                           0048CD    76  DEVID_BASE = (0x48CD)
                           0048D8    77  DEVID_END = (0x48D8)
                           007F00    78  DEBUG_BASE = (0X7F00)
                           007FFF    79  DEBUG_END = (0X7FFF)
                                     80 
                                     81 ; options bytes
                                     82 ; this one can be programmed only from SWIM  (ICP)
                           004800    83  OPT0  = (0x4800)
                                     84 ; these can be programmed at runtime (IAP)
                           004801    85  OPT1  = (0x4801)
                           004802    86  NOPT1  = (0x4802)
                           004803    87  OPT2  = (0x4803)
                           004804    88  NOPT2  = (0x4804)
                           004805    89  OPT3  = (0x4805)
                           004806    90  NOPT3  = (0x4806)
                           004807    91  OPT4  = (0x4807)
                           004808    92  NOPT4  = (0x4808)
                           004809    93  OPT5  = (0x4809)
                           00480A    94  NOPT5  = (0x480A)
                           00480B    95  OPT6  = (0x480B)
                           00480C    96  NOPT6 = (0x480C)
                           00480D    97  OPT7 = (0x480D)
                           00480E    98  NOPT7 = (0x480E)
                           00487E    99  OPTBL  = (0x487E)
                           00487F   100  NOPTBL  = (0x487F)
                                    101 ; option registers usage
                                    102 ; read out protection, value 0xAA enable ROP
                           004800   103  ROP = OPT0  
                                    104 ; user boot code, {0..0x3e} 512 bytes row
                           004801   105  UBC = OPT1
                           004802   106  NUBC = NOPT1
                                    107 ; alternate function register
                           004803   108  AFR = OPT2
                           004804   109  NAFR = NOPT2
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 5.
Hexadecimal [24-Bits]



                                    110 ; miscelinous options
                           004805   111  WDGOPT = OPT3
                           004806   112  NWDGOPT = NOPT3
                                    113 ; clock options
                           004807   114  CLKOPT = OPT4
                           004808   115  NCLKOPT = NOPT4
                                    116 ; HSE clock startup delay
                           004809   117  HSECNT = OPT5
                           00480A   118  NHSECNT = NOPT5
                                    119 ; flash wait state
                           00480D   120 FLASH_WS = OPT7
                           00480E   121 NFLASH_WS = NOPT7
                                    122 
                                    123 ; watchdog options bits
                           000003   124   WDGOPT_LSIEN   =  BIT3
                           000002   125   WDGOPT_IWDG_HW =  BIT2
                           000001   126   WDGOPT_WWDG_HW =  BIT1
                           000000   127   WDGOPT_WWDG_HALT = BIT0
                                    128 ; NWDGOPT bits
                           FFFFFFFC   129   NWDGOPT_LSIEN    = ~BIT3
                           FFFFFFFD   130   NWDGOPT_IWDG_HW  = ~BIT2
                           FFFFFFFE   131   NWDGOPT_WWDG_HW  = ~BIT1
                           FFFFFFFF   132   NWDGOPT_WWDG_HALT = ~BIT0
                                    133 
                                    134 ; CLKOPT bits
                           000003   135  CLKOPT_EXT_CLK  = BIT3
                           000002   136  CLKOPT_CKAWUSEL = BIT2
                           000001   137  CLKOPT_PRS_C1   = BIT1
                           000000   138  CLKOPT_PRS_C0   = BIT0
                                    139 
                                    140 ; AFR option, remapable functions
                           000007   141  AFR7_BEEP    = BIT7
                           000006   142  AFR6_I2C     = BIT6
                           000005   143  AFR5_TIM1    = BIT5
                           000004   144  AFR4_TIM1    = BIT4
                           000003   145  AFR3_TIM1    = BIT3
                           000002   146  AFR2_CCO     = BIT2
                           000001   147  AFR1_TIM2    = BIT1
                           000000   148  AFR0_ADC     = BIT0
                                    149 
                                    150 ; device ID = (read only)
                           0048CD   151  DEVID_XL  = (0x48CD)
                           0048CE   152  DEVID_XH  = (0x48CE)
                           0048CF   153  DEVID_YL  = (0x48CF)
                           0048D0   154  DEVID_YH  = (0x48D0)
                           0048D1   155  DEVID_WAF  = (0x48D1)
                           0048D2   156  DEVID_LOT0  = (0x48D2)
                           0048D3   157  DEVID_LOT1  = (0x48D3)
                           0048D4   158  DEVID_LOT2  = (0x48D4)
                           0048D5   159  DEVID_LOT3  = (0x48D5)
                           0048D6   160  DEVID_LOT4  = (0x48D6)
                           0048D7   161  DEVID_LOT5  = (0x48D7)
                           0048D8   162  DEVID_LOT6  = (0x48D8)
                                    163 
                                    164 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 6.
Hexadecimal [24-Bits]



                           005000   165 GPIO_BASE = (0x5000)
                           000005   166 GPIO_SIZE = (5)
                                    167 ; PORTS SFR OFFSET
                           000000   168 PA = 0
                           000005   169 PB = 5
                           00000A   170 PC = 10
                           00000F   171 PD = 15
                           000014   172 PE = 20
                           000019   173 PF = 25
                           00001E   174 PG = 30
                           000023   175 PH = 35 
                           000028   176 PI = 40 
                                    177 
                                    178 ; GPIO
                                    179 ; gpio register offset to base
                           000000   180  GPIO_ODR = 0
                           000001   181  GPIO_IDR = 1
                           000002   182  GPIO_DDR = 2
                           000003   183  GPIO_CR1 = 3
                           000004   184  GPIO_CR2 = 4
                           005000   185  GPIO_BASE=(0X5000)
                                    186  
                                    187 ; port A
                           005000   188  PA_BASE = (0X5000)
                           005000   189  PA_ODR  = (0x5000)
                           005001   190  PA_IDR  = (0x5001)
                           005002   191  PA_DDR  = (0x5002)
                           005003   192  PA_CR1  = (0x5003)
                           005004   193  PA_CR2  = (0x5004)
                                    194 ; port B
                           005005   195  PB_BASE = (0X5005)
                           005005   196  PB_ODR  = (0x5005)
                           005006   197  PB_IDR  = (0x5006)
                           005007   198  PB_DDR  = (0x5007)
                           005008   199  PB_CR1  = (0x5008)
                           005009   200  PB_CR2  = (0x5009)
                                    201 ; port C
                           00500A   202  PC_BASE = (0X500A)
                           00500A   203  PC_ODR  = (0x500A)
                           00500B   204  PC_IDR  = (0x500B)
                           00500C   205  PC_DDR  = (0x500C)
                           00500D   206  PC_CR1  = (0x500D)
                           00500E   207  PC_CR2  = (0x500E)
                                    208 ; port D
                           00500F   209  PD_BASE = (0X500F)
                           00500F   210  PD_ODR  = (0x500F)
                           005010   211  PD_IDR  = (0x5010)
                           005011   212  PD_DDR  = (0x5011)
                           005012   213  PD_CR1  = (0x5012)
                           005013   214  PD_CR2  = (0x5013)
                                    215 ; port E
                           005014   216  PE_BASE = (0X5014)
                           005014   217  PE_ODR  = (0x5014)
                           005015   218  PE_IDR  = (0x5015)
                           005016   219  PE_DDR  = (0x5016)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 7.
Hexadecimal [24-Bits]



                           005017   220  PE_CR1  = (0x5017)
                           005018   221  PE_CR2  = (0x5018)
                                    222 ; port F
                           005019   223  PF_BASE = (0X5019)
                           005019   224  PF_ODR  = (0x5019)
                           00501A   225  PF_IDR  = (0x501A)
                           00501B   226  PF_DDR  = (0x501B)
                           00501C   227  PF_CR1  = (0x501C)
                           00501D   228  PF_CR2  = (0x501D)
                                    229 ; port G
                           00501E   230  PG_BASE = (0X501E)
                           00501E   231  PG_ODR  = (0x501E)
                           00501F   232  PG_IDR  = (0x501F)
                           005020   233  PG_DDR  = (0x5020)
                           005021   234  PG_CR1  = (0x5021)
                           005022   235  PG_CR2  = (0x5022)
                                    236 ; port H not present on LQFP48/LQFP64 package
                           005023   237  PH_BASE = (0X5023)
                           005023   238  PH_ODR  = (0x5023)
                           005024   239  PH_IDR  = (0x5024)
                           005025   240  PH_DDR  = (0x5025)
                           005026   241  PH_CR1  = (0x5026)
                           005027   242  PH_CR2  = (0x5027)
                                    243 ; port I ; only bit 0 on LQFP64 package, not present on LQFP48
                           005028   244  PI_BASE = (0X5028)
                           005028   245  PI_ODR  = (0x5028)
                           005029   246  PI_IDR  = (0x5029)
                           00502A   247  PI_DDR  = (0x502a)
                           00502B   248  PI_CR1  = (0x502b)
                           00502C   249  PI_CR2  = (0x502c)
                                    250 
                                    251 ; input modes CR1
                           000000   252  INPUT_FLOAT = (0) ; no pullup resistor
                           000001   253  INPUT_PULLUP = (1)
                                    254 ; output mode CR1
                           000000   255  OUTPUT_OD = (0) ; open drain
                           000001   256  OUTPUT_PP = (1) ; push pull
                                    257 ; input modes CR2
                           000000   258  INPUT_DI = (0)
                           000001   259  INPUT_EI = (1)
                                    260 ; output speed CR2
                           000000   261  OUTPUT_SLOW = (0)
                           000001   262  OUTPUT_FAST = (1)
                                    263 
                                    264 
                                    265 ; Flash memory
                           000080   266  BLOCK_SIZE=128 
                           00505A   267  FLASH_CR1  = (0x505A)
                           00505B   268  FLASH_CR2  = (0x505B)
                           00505C   269  FLASH_NCR2  = (0x505C)
                           00505D   270  FLASH_FPR  = (0x505D)
                           00505E   271  FLASH_NFPR  = (0x505E)
                           00505F   272  FLASH_IAPSR  = (0x505F)
                           005062   273  FLASH_PUKR  = (0x5062)
                           005064   274  FLASH_DUKR  = (0x5064)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 8.
Hexadecimal [24-Bits]



                                    275 ; data memory unlock keys
                           0000AE   276  FLASH_DUKR_KEY1 = (0xae)
                           000056   277  FLASH_DUKR_KEY2 = (0x56)
                                    278 ; flash memory unlock keys
                           000056   279  FLASH_PUKR_KEY1 = (0x56)
                           0000AE   280  FLASH_PUKR_KEY2 = (0xae)
                                    281 ; FLASH_CR1 bits
                           000003   282  FLASH_CR1_HALT = BIT3
                           000002   283  FLASH_CR1_AHALT = BIT2
                           000001   284  FLASH_CR1_IE = BIT1
                           000000   285  FLASH_CR1_FIX = BIT0
                                    286 ; FLASH_CR2 bits
                           000007   287  FLASH_CR2_OPT = BIT7
                           000006   288  FLASH_CR2_WPRG = BIT6
                           000005   289  FLASH_CR2_ERASE = BIT5
                           000004   290  FLASH_CR2_FPRG = BIT4
                           000000   291  FLASH_CR2_PRG = BIT0
                                    292 ; FLASH_FPR bits
                           000005   293  FLASH_FPR_WPB5 = BIT5
                           000004   294  FLASH_FPR_WPB4 = BIT4
                           000003   295  FLASH_FPR_WPB3 = BIT3
                           000002   296  FLASH_FPR_WPB2 = BIT2
                           000001   297  FLASH_FPR_WPB1 = BIT1
                           000000   298  FLASH_FPR_WPB0 = BIT0
                                    299 ; FLASH_NFPR bits
                           000005   300  FLASH_NFPR_NWPB5 = BIT5
                           000004   301  FLASH_NFPR_NWPB4 = BIT4
                           000003   302  FLASH_NFPR_NWPB3 = BIT3
                           000002   303  FLASH_NFPR_NWPB2 = BIT2
                           000001   304  FLASH_NFPR_NWPB1 = BIT1
                           000000   305  FLASH_NFPR_NWPB0 = BIT0
                                    306 ; FLASH_IAPSR bits
                           000006   307  FLASH_IAPSR_HVOFF = BIT6
                           000003   308  FLASH_IAPSR_DUL = BIT3
                           000002   309  FLASH_IAPSR_EOP = BIT2
                           000001   310  FLASH_IAPSR_PUL = BIT1
                           000000   311  FLASH_IAPSR_WR_PG_DIS = BIT0
                                    312 
                                    313 ; Interrupt control
                           0050A0   314  EXTI_CR1  = (0x50A0)
                           0050A1   315  EXTI_CR2  = (0x50A1)
                                    316 
                                    317 ; Reset Status
                           0050B3   318  RST_SR  = (0x50B3)
                                    319 
                                    320 ; Clock Registers
                           0050C0   321  CLK_ICKR  = (0x50c0)
                           0050C1   322  CLK_ECKR  = (0x50c1)
                           0050C3   323  CLK_CMSR  = (0x50C3)
                           0050C4   324  CLK_SWR  = (0x50C4)
                           0050C5   325  CLK_SWCR  = (0x50C5)
                           0050C6   326  CLK_CKDIVR  = (0x50C6)
                           0050C7   327  CLK_PCKENR1  = (0x50C7)
                           0050C8   328  CLK_CSSR  = (0x50C8)
                           0050C9   329  CLK_CCOR  = (0x50C9)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 9.
Hexadecimal [24-Bits]



                           0050CA   330  CLK_PCKENR2  = (0x50CA)
                           0050CC   331  CLK_HSITRIMR  = (0x50CC)
                           0050CD   332  CLK_SWIMCCR  = (0x50CD)
                                    333 
                                    334 ; Peripherals clock gating
                                    335 ; CLK_PCKENR1 
                           000007   336  CLK_PCKENR1_TIM1 = (7)
                           000006   337  CLK_PCKENR1_TIM3 = (6)
                           000005   338  CLK_PCKENR1_TIM2 = (5)
                           000004   339  CLK_PCKENR1_TIM4 = (4)
                           000003   340  CLK_PCKENR1_UART3 = (3)
                           000002   341  CLK_PCKENR1_UART1 = (2)
                           000001   342  CLK_PCKENR1_SPI = (1)
                           000000   343  CLK_PCKENR1_I2C = (0)
                                    344 ; CLK_PCKENR2
                           000007   345  CLK_PCKENR2_CAN = (7)
                           000003   346  CLK_PCKENR2_ADC = (3)
                           000002   347  CLK_PCKENR2_AWU = (2)
                                    348 
                                    349 ; Clock bits
                           000005   350  CLK_ICKR_REGAH = (5)
                           000004   351  CLK_ICKR_LSIRDY = (4)
                           000003   352  CLK_ICKR_LSIEN = (3)
                           000002   353  CLK_ICKR_FHW = (2)
                           000001   354  CLK_ICKR_HSIRDY = (1)
                           000000   355  CLK_ICKR_HSIEN = (0)
                                    356 
                           000001   357  CLK_ECKR_HSERDY = (1)
                           000000   358  CLK_ECKR_HSEEN = (0)
                                    359 ; clock source
                           0000E1   360  CLK_SWR_HSI = 0xE1
                           0000D2   361  CLK_SWR_LSI = 0xD2
                           0000B4   362  CLK_SWR_HSE = 0xB4
                                    363 
                           000003   364  CLK_SWCR_SWIF = (3)
                           000002   365  CLK_SWCR_SWIEN = (2)
                           000001   366  CLK_SWCR_SWEN = (1)
                           000000   367  CLK_SWCR_SWBSY = (0)
                                    368 
                           000004   369  CLK_CKDIVR_HSIDIV1 = (4)
                           000003   370  CLK_CKDIVR_HSIDIV0 = (3)
                           000002   371  CLK_CKDIVR_CPUDIV2 = (2)
                           000001   372  CLK_CKDIVR_CPUDIV1 = (1)
                           000000   373  CLK_CKDIVR_CPUDIV0 = (0)
                                    374 
                                    375 ; Watchdog
                           0050D1   376  WWDG_CR  = (0x50D1)
                           0050D2   377  WWDG_WR  = (0x50D2)
                           0050E0   378  IWDG_KR  = (0x50E0)
                           0050E1   379  IWDG_PR  = (0x50E1)
                           0050E2   380  IWDG_RLR  = (0x50E2)
                           0000CC   381  IWDG_KEY_ENABLE = 0xCC  ; enable IWDG key 
                           0000AA   382  IWDG_KEY_REFRESH = 0xAA ; refresh counter key 
                           000055   383  IWDG_KEY_ACCESS = 0x55 ; write register key 
                                    384  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 10.
Hexadecimal [24-Bits]



                           0050F0   385  AWU_CSR  = (0x50F0)
                           0050F1   386  AWU_APR  = (0x50F1)
                           0050F2   387  AWU_TBR  = (0x50F2)
                           000004   388  AWU_CSR_AWUEN = 4
                                    389 
                                    390 
                                    391 
                                    392 ; Beeper
                                    393 ; beeper output is alternate function AFR7 on PD4
                                    394 ; connected to CN9-6
                           0050F3   395  BEEP_CSR  = (0x50F3)
                           00000F   396  BEEP_PORT = PD
                           000004   397  BEEP_BIT = 4
                           000010   398  BEEP_MASK = B4_MASK
                                    399 
                                    400 ; SPI
                           005200   401  SPI_CR1  = (0x5200)
                           005201   402  SPI_CR2  = (0x5201)
                           005202   403  SPI_ICR  = (0x5202)
                           005203   404  SPI_SR  = (0x5203)
                           005204   405  SPI_DR  = (0x5204)
                           005205   406  SPI_CRCPR  = (0x5205)
                           005206   407  SPI_RXCRCR  = (0x5206)
                           005207   408  SPI_TXCRCR  = (0x5207)
                                    409 
                                    410 ; SPI_CR1 bit fields 
                           000000   411   SPI_CR1_CPHA=0
                           000001   412   SPI_CR1_CPOL=1
                           000002   413   SPI_CR1_MSTR=2
                           000003   414   SPI_CR1_BR=3
                           000006   415   SPI_CR1_SPE=6
                           000007   416   SPI_CR1_LSBFIRST=7
                                    417   
                                    418 ; SPI_CR2 bit fields 
                           000000   419   SPI_CR2_SSI=0
                           000001   420   SPI_CR2_SSM=1
                           000002   421   SPI_CR2_RXONLY=2
                           000004   422   SPI_CR2_CRCNEXT=4
                           000005   423   SPI_CR2_CRCEN=5
                           000006   424   SPI_CR2_BDOE=6
                           000007   425   SPI_CR2_BDM=7  
                                    426 
                                    427 ; SPI_SR bit fields 
                           000000   428   SPI_SR_RXNE=0
                           000001   429   SPI_SR_TXE=1
                           000003   430   SPI_SR_WKUP=3
                           000004   431   SPI_SR_CRCERR=4
                           000005   432   SPI_SR_MODF=5
                           000006   433   SPI_SR_OVR=6
                           000007   434   SPI_SR_BSY=7
                                    435 
                                    436 ; I2C
                           005210   437  I2C_BASE_ADDR = 0x5210 
                           005210   438  I2C_CR1  = (0x5210)
                           005211   439  I2C_CR2  = (0x5211)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 11.
Hexadecimal [24-Bits]



                           005212   440  I2C_FREQR  = (0x5212)
                           005213   441  I2C_OARL  = (0x5213)
                           005214   442  I2C_OARH  = (0x5214)
                           005216   443  I2C_DR  = (0x5216)
                           005217   444  I2C_SR1  = (0x5217)
                           005218   445  I2C_SR2  = (0x5218)
                           005219   446  I2C_SR3  = (0x5219)
                           00521A   447  I2C_ITR  = (0x521A)
                           00521B   448  I2C_CCRL  = (0x521B)
                           00521C   449  I2C_CCRH  = (0x521C)
                           00521D   450  I2C_TRISER  = (0x521D)
                           00521E   451  I2C_PECR  = (0x521E)
                                    452 
                           000007   453  I2C_CR1_NOSTRETCH = (7)
                           000006   454  I2C_CR1_ENGC = (6)
                           000000   455  I2C_CR1_PE = (0)
                                    456 
                           000007   457  I2C_CR2_SWRST = (7)
                           000003   458  I2C_CR2_POS = (3)
                           000002   459  I2C_CR2_ACK = (2)
                           000001   460  I2C_CR2_STOP = (1)
                           000000   461  I2C_CR2_START = (0)
                                    462 
                           000000   463  I2C_OARL_ADD0 = (0)
                                    464 
                           000009   465  I2C_OAR_ADDR_7BIT = ((I2C_OARL & 0xFE) >> 1)
                           000813   466  I2C_OAR_ADDR_10BIT = (((I2C_OARH & 0x06) << 9) | (I2C_OARL & 0xFF))
                                    467 
                           000007   468  I2C_OARH_ADDMODE = (7)
                           000006   469  I2C_OARH_ADDCONF = (6)
                           000002   470  I2C_OARH_ADD9 = (2)
                           000001   471  I2C_OARH_ADD8 = (1)
                                    472 
                           000007   473  I2C_SR1_TXE = (7)
                           000006   474  I2C_SR1_RXNE = (6)
                           000004   475  I2C_SR1_STOPF = (4)
                           000003   476  I2C_SR1_ADD10 = (3)
                           000002   477  I2C_SR1_BTF = (2)
                           000001   478  I2C_SR1_ADDR = (1)
                           000000   479  I2C_SR1_SB = (0)
                                    480 
                           000005   481  I2C_SR2_WUFH = (5)
                           000003   482  I2C_SR2_OVR = (3)
                           000002   483  I2C_SR2_AF = (2)
                           000001   484  I2C_SR2_ARLO = (1)
                           000000   485  I2C_SR2_BERR = (0)
                                    486 
                           000007   487  I2C_SR3_DUALF = (7)
                           000004   488  I2C_SR3_GENCALL = (4)
                           000002   489  I2C_SR3_TRA = (2)
                           000001   490  I2C_SR3_BUSY = (1)
                           000000   491  I2C_SR3_MSL = (0)
                                    492 
                           000002   493  I2C_ITR_ITBUFEN = (2)
                           000001   494  I2C_ITR_ITEVTEN = (1)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 12.
Hexadecimal [24-Bits]



                           000000   495  I2C_ITR_ITERREN = (0)
                                    496 
                           000007   497  I2C_CCRH_FAST = 7 
                           000006   498  I2C_CCRH_DUTY = 6 
                                    499  
                                    500 ; Precalculated values, all in KHz
                           000080   501  I2C_CCRH_16MHZ_FAST_400 = 0x80
                           00000D   502  I2C_CCRL_16MHZ_FAST_400 = 0x0D
                                    503 ;
                                    504 ; Fast I2C mode max rise time = 300ns
                                    505 ; I2C_FREQR = 16 = (MHz) => tMASTER = 1/16 = 62.5 ns
                                    506 ; TRISER = = (300/62.5) + 1 = floor(4.8) + 1 = 5.
                                    507 
                           000005   508  I2C_TRISER_16MHZ_FAST_400 = 0x05
                                    509 
                           0000C0   510  I2C_CCRH_16MHZ_FAST_320 = 0xC0
                           000002   511  I2C_CCRL_16MHZ_FAST_320 = 0x02
                           000005   512  I2C_TRISER_16MHZ_FAST_320 = 0x05
                                    513 
                           000080   514  I2C_CCRH_16MHZ_FAST_200 = 0x80
                           00001A   515  I2C_CCRL_16MHZ_FAST_200 = 0x1A
                           000005   516  I2C_TRISER_16MHZ_FAST_200 = 0x05
                                    517 
                           000000   518  I2C_CCRH_16MHZ_STD_100 = 0x00
                           000050   519  I2C_CCRL_16MHZ_STD_100 = 0x50
                                    520 ;
                                    521 ; Standard I2C mode max rise time = 1000ns
                                    522 ; I2C_FREQR = 16 = (MHz) => tMASTER = 1/16 = 62.5 ns
                                    523 ; TRISER = = (1000/62.5) + 1 = floor(16) + 1 = 17.
                                    524 
                           000011   525  I2C_TRISER_16MHZ_STD_100 = 0x11
                                    526 
                           000000   527  I2C_CCRH_16MHZ_STD_50 = 0x00
                           0000A0   528  I2C_CCRL_16MHZ_STD_50 = 0xA0
                           000011   529  I2C_TRISER_16MHZ_STD_50 = 0x11
                                    530 
                           000001   531  I2C_CCRH_16MHZ_STD_20 = 0x01
                           000090   532  I2C_CCRL_16MHZ_STD_20 = 0x90
                           000011   533  I2C_TRISER_16MHZ_STD_20 = 0x11;
                                    534 
                           000001   535  I2C_READ = 1
                           000000   536  I2C_WRITE = 0
                                    537 
                                    538 ; baudrate constant for brr_value table access
                                    539 ; to be used by uart_init 
                           000000   540 B2400=0
                           000001   541 B4800=1
                           000002   542 B9600=2
                           000003   543 B19200=3
                           000004   544 B38400=4
                           000005   545 B57600=5
                           000006   546 B115200=6
                           000007   547 B230400=7
                           000008   548 B460800=8
                           000009   549 B921600=9
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 13.
Hexadecimal [24-Bits]



                                    550 
                                    551 ; UART registers offset from
                                    552 ; base address 
                           000000   553 OFS_UART_SR=0
                           000001   554 OFS_UART_DR=1
                           000002   555 OFS_UART_BRR1=2
                           000003   556 OFS_UART_BRR2=3
                           000004   557 OFS_UART_CR1=4
                           000005   558 OFS_UART_CR2=5
                           000006   559 OFS_UART_CR3=6
                           000007   560 OFS_UART_CR4=7
                           000008   561 OFS_UART_CR5=8
                           000009   562 OFS_UART_CR6=9
                           000009   563 OFS_UART_GTR=9
                           00000A   564 OFS_UART_PSCR=10
                                    565 
                                    566 ; uart identifier
                           000000   567  UART1 = 0 
                           000001   568  UART2 = 1
                           000002   569  UART3 = 2
                                    570 
                                    571 ; pins used by uart 
                           000005   572 UART1_TX_PIN=BIT5
                           000004   573 UART1_RX_PIN=BIT4
                           000005   574 UART3_TX_PIN=BIT5
                           000006   575 UART3_RX_PIN=BIT6
                                    576 ; uart port base address 
                           000000   577 UART1_PORT=PA 
                           00000F   578 UART3_PORT=PD
                                    579 
                                    580 ; UART1 
                           005230   581  UART1_BASE  = (0x5230)
                           005230   582  UART1_SR    = (0x5230)
                           005231   583  UART1_DR    = (0x5231)
                           005232   584  UART1_BRR1  = (0x5232)
                           005233   585  UART1_BRR2  = (0x5233)
                           005234   586  UART1_CR1   = (0x5234)
                           005235   587  UART1_CR2   = (0x5235)
                           005236   588  UART1_CR3   = (0x5236)
                           005237   589  UART1_CR4   = (0x5237)
                           005238   590  UART1_CR5   = (0x5238)
                           005239   591  UART1_GTR   = (0x5239)
                           00523A   592  UART1_PSCR  = (0x523A)
                                    593 
                                    594 ; UART3
                           005240   595  UART3_BASE  = (0x5240)
                           005240   596  UART3_SR    = (0x5240)
                           005241   597  UART3_DR    = (0x5241)
                           005242   598  UART3_BRR1  = (0x5242)
                           005243   599  UART3_BRR2  = (0x5243)
                           005244   600  UART3_CR1   = (0x5244)
                           005245   601  UART3_CR2   = (0x5245)
                           005246   602  UART3_CR3   = (0x5246)
                           005247   603  UART3_CR4   = (0x5247)
                           005249   604  UART3_CR6   = (0x5249)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 14.
Hexadecimal [24-Bits]



                                    605 
                                    606 ; UART Status Register bits
                           000007   607  UART_SR_TXE = (7)
                           000006   608  UART_SR_TC = (6)
                           000005   609  UART_SR_RXNE = (5)
                           000004   610  UART_SR_IDLE = (4)
                           000003   611  UART_SR_OR = (3)
                           000002   612  UART_SR_NF = (2)
                           000001   613  UART_SR_FE = (1)
                           000000   614  UART_SR_PE = (0)
                                    615 
                                    616 ; Uart Control Register bits
                           000007   617  UART_CR1_R8 = (7)
                           000006   618  UART_CR1_T8 = (6)
                           000005   619  UART_CR1_UARTD = (5)
                           000004   620  UART_CR1_M = (4)
                           000003   621  UART_CR1_WAKE = (3)
                           000002   622  UART_CR1_PCEN = (2)
                           000001   623  UART_CR1_PS = (1)
                           000000   624  UART_CR1_PIEN = (0)
                                    625 
                           000007   626  UART_CR2_TIEN = (7)
                           000006   627  UART_CR2_TCIEN = (6)
                           000005   628  UART_CR2_RIEN = (5)
                           000004   629  UART_CR2_ILIEN = (4)
                           000003   630  UART_CR2_TEN = (3)
                           000002   631  UART_CR2_REN = (2)
                           000001   632  UART_CR2_RWU = (1)
                           000000   633  UART_CR2_SBK = (0)
                                    634 
                           000006   635  UART_CR3_LINEN = (6)
                           000005   636  UART_CR3_STOP1 = (5)
                           000004   637  UART_CR3_STOP0 = (4)
                           000003   638  UART_CR3_CLKEN = (3)
                           000002   639  UART_CR3_CPOL = (2)
                           000001   640  UART_CR3_CPHA = (1)
                           000000   641  UART_CR3_LBCL = (0)
                                    642 
                           000006   643  UART_CR4_LBDIEN = (6)
                           000005   644  UART_CR4_LBDL = (5)
                           000004   645  UART_CR4_LBDF = (4)
                           000003   646  UART_CR4_ADD3 = (3)
                           000002   647  UART_CR4_ADD2 = (2)
                           000001   648  UART_CR4_ADD1 = (1)
                           000000   649  UART_CR4_ADD0 = (0)
                                    650 
                           000005   651  UART_CR5_SCEN = (5)
                           000004   652  UART_CR5_NACK = (4)
                           000003   653  UART_CR5_HDSEL = (3)
                           000002   654  UART_CR5_IRLP = (2)
                           000001   655  UART_CR5_IREN = (1)
                                    656 ; LIN mode config register
                           000007   657  UART_CR6_LDUM = (7)
                           000005   658  UART_CR6_LSLV = (5)
                           000004   659  UART_CR6_LASE = (4)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 15.
Hexadecimal [24-Bits]



                           000002   660  UART_CR6_LHDIEN = (2) 
                           000001   661  UART_CR6_LHDF = (1)
                           000000   662  UART_CR6_LSF = (0)
                                    663 
                                    664 ; TIMERS
                                    665 ; Timer 1 - 16-bit timer with complementary PWM outputs
                           005250   666  TIM1_CR1  = (0x5250)
                           005251   667  TIM1_CR2  = (0x5251)
                           005252   668  TIM1_SMCR  = (0x5252)
                           005253   669  TIM1_ETR  = (0x5253)
                           005254   670  TIM1_IER  = (0x5254)
                           005255   671  TIM1_SR1  = (0x5255)
                           005256   672  TIM1_SR2  = (0x5256)
                           005257   673  TIM1_EGR  = (0x5257)
                           005258   674  TIM1_CCMR1  = (0x5258)
                           005259   675  TIM1_CCMR2  = (0x5259)
                           00525A   676  TIM1_CCMR3  = (0x525A)
                           00525B   677  TIM1_CCMR4  = (0x525B)
                           00525C   678  TIM1_CCER1  = (0x525C)
                           00525D   679  TIM1_CCER2  = (0x525D)
                           00525E   680  TIM1_CNTRH  = (0x525E)
                           00525F   681  TIM1_CNTRL  = (0x525F)
                           005260   682  TIM1_PSCRH  = (0x5260)
                           005261   683  TIM1_PSCRL  = (0x5261)
                           005262   684  TIM1_ARRH  = (0x5262)
                           005263   685  TIM1_ARRL  = (0x5263)
                           005264   686  TIM1_RCR  = (0x5264)
                           005265   687  TIM1_CCR1H  = (0x5265)
                           005266   688  TIM1_CCR1L  = (0x5266)
                           005267   689  TIM1_CCR2H  = (0x5267)
                           005268   690  TIM1_CCR2L  = (0x5268)
                           005269   691  TIM1_CCR3H  = (0x5269)
                           00526A   692  TIM1_CCR3L  = (0x526A)
                           00526B   693  TIM1_CCR4H  = (0x526B)
                           00526C   694  TIM1_CCR4L  = (0x526C)
                           00526D   695  TIM1_BKR  = (0x526D)
                           00526E   696  TIM1_DTR  = (0x526E)
                           00526F   697  TIM1_OISR  = (0x526F)
                                    698 
                                    699 ; Timer Control Register bits
                           000007   700  TIM_CR1_ARPE = (7)
                           000006   701  TIM_CR1_CMSH = (6)
                           000005   702  TIM_CR1_CMSL = (5)
                           000004   703  TIM_CR1_DIR = (4)
                           000003   704  TIM_CR1_OPM = (3)
                           000002   705  TIM_CR1_URS = (2)
                           000001   706  TIM_CR1_UDIS = (1)
                           000000   707  TIM_CR1_CEN = (0)
                                    708 
                           000006   709  TIM1_CR2_MMS2 = (6)
                           000005   710  TIM1_CR2_MMS1 = (5)
                           000004   711  TIM1_CR2_MMS0 = (4)
                           000002   712  TIM1_CR2_COMS = (2)
                           000000   713  TIM1_CR2_CCPC = (0)
                                    714 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 16.
Hexadecimal [24-Bits]



                                    715 ; Timer Slave Mode Control bits
                           000007   716  TIM1_SMCR_MSM = (7)
                           000006   717  TIM1_SMCR_TS2 = (6)
                           000005   718  TIM1_SMCR_TS1 = (5)
                           000004   719  TIM1_SMCR_TS0 = (4)
                           000002   720  TIM1_SMCR_SMS2 = (2)
                           000001   721  TIM1_SMCR_SMS1 = (1)
                           000000   722  TIM1_SMCR_SMS0 = (0)
                                    723 
                                    724 ; Timer External Trigger Enable bits
                           000007   725  TIM1_ETR_ETP = (7)
                           000006   726  TIM1_ETR_ECE = (6)
                           000005   727  TIM1_ETR_ETPS1 = (5)
                           000004   728  TIM1_ETR_ETPS0 = (4)
                           000003   729  TIM1_ETR_ETF3 = (3)
                           000002   730  TIM1_ETR_ETF2 = (2)
                           000001   731  TIM1_ETR_ETF1 = (1)
                           000000   732  TIM1_ETR_ETF0 = (0)
                                    733 
                                    734 ; Timer Interrupt Enable bits
                           000007   735  TIM1_IER_BIE = (7)
                           000006   736  TIM1_IER_TIE = (6)
                           000005   737  TIM1_IER_COMIE = (5)
                           000004   738  TIM1_IER_CC4IE = (4)
                           000003   739  TIM1_IER_CC3IE = (3)
                           000002   740  TIM1_IER_CC2IE = (2)
                           000001   741  TIM1_IER_CC1IE = (1)
                           000000   742  TIM1_IER_UIE = (0)
                                    743 
                                    744 ; Timer Status Register bits
                           000007   745  TIM1_SR1_BIF = (7)
                           000006   746  TIM1_SR1_TIF = (6)
                           000005   747  TIM1_SR1_COMIF = (5)
                           000004   748  TIM1_SR1_CC4IF = (4)
                           000003   749  TIM1_SR1_CC3IF = (3)
                           000002   750  TIM1_SR1_CC2IF = (2)
                           000001   751  TIM1_SR1_CC1IF = (1)
                           000000   752  TIM1_SR1_UIF = (0)
                                    753 
                           000004   754  TIM1_SR2_CC4OF = (4)
                           000003   755  TIM1_SR2_CC3OF = (3)
                           000002   756  TIM1_SR2_CC2OF = (2)
                           000001   757  TIM1_SR2_CC1OF = (1)
                                    758 
                                    759 ; Timer Event Generation Register bits
                           000007   760  TIM1_EGR_BG = (7)
                           000006   761  TIM1_EGR_TG = (6)
                           000005   762  TIM1_EGR_COMG = (5)
                           000004   763  TIM1_EGR_CC4G = (4)
                           000003   764  TIM1_EGR_CC3G = (3)
                           000002   765  TIM1_EGR_CC2G = (2)
                           000001   766  TIM1_EGR_CC1G = (1)
                           000000   767  TIM1_EGR_UG = (0)
                                    768 
                                    769 ; Capture/Compare Mode Register 1 - channel configured in output
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 17.
Hexadecimal [24-Bits]



                           000007   770  TIM1_CCMR1_OC1CE = (7)
                           000006   771  TIM1_CCMR1_OC1M2 = (6)
                           000005   772  TIM1_CCMR1_OC1M1 = (5)
                           000004   773  TIM1_CCMR1_OC1M0 = (4)
                           000003   774  TIM1_CCMR1_OC1PE = (3)
                           000002   775  TIM1_CCMR1_OC1FE = (2)
                           000001   776  TIM1_CCMR1_CC1S1 = (1)
                           000000   777  TIM1_CCMR1_CC1S0 = (0)
                                    778 
                                    779 ; Capture/Compare Mode Register 1 - channel configured in input
                           000007   780  TIM1_CCMR1_IC1F3 = (7)
                           000006   781  TIM1_CCMR1_IC1F2 = (6)
                           000005   782  TIM1_CCMR1_IC1F1 = (5)
                           000004   783  TIM1_CCMR1_IC1F0 = (4)
                           000003   784  TIM1_CCMR1_IC1PSC1 = (3)
                           000002   785  TIM1_CCMR1_IC1PSC0 = (2)
                                    786 ;  TIM1_CCMR1_CC1S1 = (1)
                           000000   787  TIM1_CCMR1_CC1S0 = (0)
                                    788 
                                    789 ; Capture/Compare Mode Register 2 - channel configured in output
                           000007   790  TIM1_CCMR2_OC2CE = (7)
                           000006   791  TIM1_CCMR2_OC2M2 = (6)
                           000005   792  TIM1_CCMR2_OC2M1 = (5)
                           000004   793  TIM1_CCMR2_OC2M0 = (4)
                           000003   794  TIM1_CCMR2_OC2PE = (3)
                           000002   795  TIM1_CCMR2_OC2FE = (2)
                           000001   796  TIM1_CCMR2_CC2S1 = (1)
                           000000   797  TIM1_CCMR2_CC2S0 = (0)
                                    798 
                                    799 ; Capture/Compare Mode Register 2 - channel configured in input
                           000007   800  TIM1_CCMR2_IC2F3 = (7)
                           000006   801  TIM1_CCMR2_IC2F2 = (6)
                           000005   802  TIM1_CCMR2_IC2F1 = (5)
                           000004   803  TIM1_CCMR2_IC2F0 = (4)
                           000003   804  TIM1_CCMR2_IC2PSC1 = (3)
                           000002   805  TIM1_CCMR2_IC2PSC0 = (2)
                                    806 ;  TIM1_CCMR2_CC2S1 = (1)
                           000000   807  TIM1_CCMR2_CC2S0 = (0)
                                    808 
                                    809 ; Capture/Compare Mode Register 3 - channel configured in output
                           000007   810  TIM1_CCMR3_OC3CE = (7)
                           000006   811  TIM1_CCMR3_OC3M2 = (6)
                           000005   812  TIM1_CCMR3_OC3M1 = (5)
                           000004   813  TIM1_CCMR3_OC3M0 = (4)
                           000003   814  TIM1_CCMR3_OC3PE = (3)
                           000002   815  TIM1_CCMR3_OC3FE = (2)
                           000001   816  TIM1_CCMR3_CC3S1 = (1)
                           000000   817  TIM1_CCMR3_CC3S0 = (0)
                                    818 
                                    819 ; Capture/Compare Mode Register 3 - channel configured in input
                           000007   820  TIM1_CCMR3_IC3F3 = (7)
                           000006   821  TIM1_CCMR3_IC3F2 = (6)
                           000005   822  TIM1_CCMR3_IC3F1 = (5)
                           000004   823  TIM1_CCMR3_IC3F0 = (4)
                           000003   824  TIM1_CCMR3_IC3PSC1 = (3)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 18.
Hexadecimal [24-Bits]



                           000002   825  TIM1_CCMR3_IC3PSC0 = (2)
                                    826 ;  TIM1_CCMR3_CC3S1 = (1)
                           000000   827  TIM1_CCMR3_CC3S0 = (0)
                                    828 
                                    829 ; Capture/Compare Mode Register 4 - channel configured in output
                           000007   830  TIM1_CCMR4_OC4CE = (7)
                           000006   831  TIM1_CCMR4_OC4M2 = (6)
                           000005   832  TIM1_CCMR4_OC4M1 = (5)
                           000004   833  TIM1_CCMR4_OC4M0 = (4)
                           000003   834  TIM1_CCMR4_OC4PE = (3)
                           000002   835  TIM1_CCMR4_OC4FE = (2)
                           000001   836  TIM1_CCMR4_CC4S1 = (1)
                           000000   837  TIM1_CCMR4_CC4S0 = (0)
                                    838 
                                    839 ; Capture/Compare Mode Register 4 - channel configured in input
                           000007   840  TIM1_CCMR4_IC4F3 = (7)
                           000006   841  TIM1_CCMR4_IC4F2 = (6)
                           000005   842  TIM1_CCMR4_IC4F1 = (5)
                           000004   843  TIM1_CCMR4_IC4F0 = (4)
                           000003   844  TIM1_CCMR4_IC4PSC1 = (3)
                           000002   845  TIM1_CCMR4_IC4PSC0 = (2)
                                    846 ;  TIM1_CCMR4_CC4S1 = (1)
                           000000   847  TIM1_CCMR4_CC4S0 = (0)
                                    848 
                                    849 ; Timer 2 - 16-bit timer
                           005300   850  TIM2_CR1  = (0x5300)
                           005301   851  TIM2_IER  = (0x5301)
                           005302   852  TIM2_SR1  = (0x5302)
                           005303   853  TIM2_SR2  = (0x5303)
                           005304   854  TIM2_EGR  = (0x5304)
                           005305   855  TIM2_CCMR1  = (0x5305)
                           005306   856  TIM2_CCMR2  = (0x5306)
                           005307   857  TIM2_CCMR3  = (0x5307)
                           005308   858  TIM2_CCER1  = (0x5308)
                           005309   859  TIM2_CCER2  = (0x5309)
                           00530A   860  TIM2_CNTRH  = (0x530A)
                           00530B   861  TIM2_CNTRL  = (0x530B)
                           00530C   862  TIM2_PSCR  = (0x530C)
                           00530D   863  TIM2_ARRH  = (0x530D)
                           00530E   864  TIM2_ARRL  = (0x530E)
                           00530F   865  TIM2_CCR1H  = (0x530F)
                           005310   866  TIM2_CCR1L  = (0x5310)
                           005311   867  TIM2_CCR2H  = (0x5311)
                           005312   868  TIM2_CCR2L  = (0x5312)
                           005313   869  TIM2_CCR3H  = (0x5313)
                           005314   870  TIM2_CCR3L  = (0x5314)
                                    871 
                                    872 ; TIM2_CR1 bitfields
                           000000   873  TIM2_CR1_CEN=(0) ; Counter enable
                           000001   874  TIM2_CR1_UDIS=(1) ; Update disable
                           000002   875  TIM2_CR1_URS=(2) ; Update request source
                           000003   876  TIM2_CR1_OPM=(3) ; One-pulse mode
                           000007   877  TIM2_CR1_ARPE=(7) ; Auto-reload preload enable
                                    878 
                                    879 ; TIMER2_CCMR bitfields 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 19.
Hexadecimal [24-Bits]



                           000000   880  TIM2_CCMR_CCS=(0) ; input/output select
                           000003   881  TIM2_CCMR_OCPE=(3) ; preload enable
                           000004   882  TIM2_CCMR_OCM=(4)  ; output compare mode 
                                    883 
                                    884 ; TIMER2_CCER1 bitfields
                           000000   885  TIM2_CCER1_CC1E=(0)
                           000001   886  TIM2_CCER1_CC1P=(1)
                           000004   887  TIM2_CCER1_CC2E=(4)
                           000005   888  TIM2_CCER1_CC2P=(5)
                                    889 
                                    890 ; TIMER2_EGR bitfields
                           000000   891  TIM2_EGR_UG=(0) ; update generation
                           000001   892  TIM2_EGR_CC1G=(1) ; Capture/compare 1 generation
                           000002   893  TIM2_EGR_CC2G=(2) ; Capture/compare 2 generation
                           000003   894  TIM2_EGR_CC3G=(3) ; Capture/compare 3 generation
                           000006   895  TIM2_EGR_TG=(6); Trigger generation
                                    896 
                                    897 ; Timer 3
                           005320   898  TIM3_CR1  = (0x5320)
                           005321   899  TIM3_IER  = (0x5321)
                           005322   900  TIM3_SR1  = (0x5322)
                           005323   901  TIM3_SR2  = (0x5323)
                           005324   902  TIM3_EGR  = (0x5324)
                           005325   903  TIM3_CCMR1  = (0x5325)
                           005326   904  TIM3_CCMR2  = (0x5326)
                           005327   905  TIM3_CCER1  = (0x5327)
                           005328   906  TIM3_CNTRH  = (0x5328)
                           005329   907  TIM3_CNTRL  = (0x5329)
                           00532A   908  TIM3_PSCR  = (0x532A)
                           00532B   909  TIM3_ARRH  = (0x532B)
                           00532C   910  TIM3_ARRL  = (0x532C)
                           00532D   911  TIM3_CCR1H  = (0x532D)
                           00532E   912  TIM3_CCR1L  = (0x532E)
                           00532F   913  TIM3_CCR2H  = (0x532F)
                           005330   914  TIM3_CCR2L  = (0x5330)
                                    915 
                                    916 ; TIM3_CR1  fields
                           000000   917  TIM3_CR1_CEN = (0)
                           000001   918  TIM3_CR1_UDIS = (1)
                           000002   919  TIM3_CR1_URS = (2)
                           000003   920  TIM3_CR1_OPM = (3)
                           000007   921  TIM3_CR1_ARPE = (7)
                                    922 ; TIM3_CCR2  fields
                           000000   923  TIM3_CCMR2_CC2S_POS = (0)
                           000003   924  TIM3_CCMR2_OC2PE_POS = (3)
                           000004   925  TIM3_CCMR2_OC2M_POS = (4)  
                                    926 ; TIM3_CCER1 fields
                           000000   927  TIM3_CCER1_CC1E = (0)
                           000001   928  TIM3_CCER1_CC1P = (1)
                           000004   929  TIM3_CCER1_CC2E = (4)
                           000005   930  TIM3_CCER1_CC2P = (5)
                                    931 ; TIM3_CCER2 fields
                           000000   932  TIM3_CCER2_CC3E = (0)
                           000001   933  TIM3_CCER2_CC3P = (1)
                                    934 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 20.
Hexadecimal [24-Bits]



                                    935 ; Timer 4
                           005340   936  TIM4_CR1  = (0x5340)
                           005341   937  TIM4_IER  = (0x5341)
                           005342   938  TIM4_SR  = (0x5342)
                           005343   939  TIM4_EGR  = (0x5343)
                           005344   940  TIM4_CNTR  = (0x5344)
                           005345   941  TIM4_PSCR  = (0x5345)
                           005346   942  TIM4_ARR  = (0x5346)
                                    943 
                                    944 ; Timer 4 bitmasks
                                    945 
                           000007   946  TIM4_CR1_ARPE = (7)
                           000003   947  TIM4_CR1_OPM = (3)
                           000002   948  TIM4_CR1_URS = (2)
                           000001   949  TIM4_CR1_UDIS = (1)
                           000000   950  TIM4_CR1_CEN = (0)
                                    951 
                           000000   952  TIM4_IER_UIE = (0)
                                    953 
                           000000   954  TIM4_SR_UIF = (0)
                                    955 
                           000000   956  TIM4_EGR_UG = (0)
                                    957 
                           000002   958  TIM4_PSCR_PSC2 = (2)
                           000001   959  TIM4_PSCR_PSC1 = (1)
                           000000   960  TIM4_PSCR_PSC0 = (0)
                                    961 
                           000000   962  TIM4_PSCR_1 = 0
                           000001   963  TIM4_PSCR_2 = 1
                           000002   964  TIM4_PSCR_4 = 2
                           000003   965  TIM4_PSCR_8 = 3
                           000004   966  TIM4_PSCR_16 = 4
                           000005   967  TIM4_PSCR_32 = 5
                           000006   968  TIM4_PSCR_64 = 6
                           000007   969  TIM4_PSCR_128 = 7
                                    970 
                                    971 ; ADC2
                           005400   972  ADC_CSR  = (0x5400)
                           005401   973  ADC_CR1  = (0x5401)
                           005402   974  ADC_CR2  = (0x5402)
                           005403   975  ADC_CR3  = (0x5403)
                           005404   976  ADC_DRH  = (0x5404)
                           005405   977  ADC_DRL  = (0x5405)
                           005406   978  ADC_TDRH  = (0x5406)
                           005407   979  ADC_TDRL  = (0x5407)
                                    980  
                                    981 ; ADC bitmasks
                                    982 
                           000007   983  ADC_CSR_EOC = (7)
                           000006   984  ADC_CSR_AWD = (6)
                           000005   985  ADC_CSR_EOCIE = (5)
                           000004   986  ADC_CSR_AWDIE = (4)
                           000003   987  ADC_CSR_CH3 = (3)
                           000002   988  ADC_CSR_CH2 = (2)
                           000001   989  ADC_CSR_CH1 = (1)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 21.
Hexadecimal [24-Bits]



                           000000   990  ADC_CSR_CH0 = (0)
                                    991 
                           000006   992  ADC_CR1_SPSEL2 = (6)
                           000005   993  ADC_CR1_SPSEL1 = (5)
                           000004   994  ADC_CR1_SPSEL0 = (4)
                           000001   995  ADC_CR1_CONT = (1)
                           000000   996  ADC_CR1_ADON = (0)
                                    997 
                           000006   998  ADC_CR2_EXTTRIG = (6)
                           000005   999  ADC_CR2_EXTSEL1 = (5)
                           000004  1000  ADC_CR2_EXTSEL0 = (4)
                           000003  1001  ADC_CR2_ALIGN = (3)
                           000001  1002  ADC_CR2_SCAN = (1)
                                   1003 
                           000007  1004  ADC_CR3_DBUF = (7)
                           000006  1005  ADC_CR3_DRH = (6)
                                   1006 
                                   1007 ; beCAN
                           005420  1008  CAN_MCR = (0x5420)
                           005421  1009  CAN_MSR = (0x5421)
                           005422  1010  CAN_TSR = (0x5422)
                           005423  1011  CAN_TPR = (0x5423)
                           005424  1012  CAN_RFR = (0x5424)
                           005425  1013  CAN_IER = (0x5425)
                           005426  1014  CAN_DGR = (0x5426)
                           005427  1015  CAN_FPSR = (0x5427)
                           005428  1016  CAN_P0 = (0x5428)
                           005429  1017  CAN_P1 = (0x5429)
                           00542A  1018  CAN_P2 = (0x542A)
                           00542B  1019  CAN_P3 = (0x542B)
                           00542C  1020  CAN_P4 = (0x542C)
                           00542D  1021  CAN_P5 = (0x542D)
                           00542E  1022  CAN_P6 = (0x542E)
                           00542F  1023  CAN_P7 = (0x542F)
                           005430  1024  CAN_P8 = (0x5430)
                           005431  1025  CAN_P9 = (0x5431)
                           005432  1026  CAN_PA = (0x5432)
                           005433  1027  CAN_PB = (0x5433)
                           005434  1028  CAN_PC = (0x5434)
                           005435  1029  CAN_PD = (0x5435)
                           005436  1030  CAN_PE = (0x5436)
                           005437  1031  CAN_PF = (0x5437)
                                   1032 
                                   1033 
                                   1034 ; CPU
                           007F00  1035  CPU_A  = (0x7F00)
                           007F01  1036  CPU_PCE  = (0x7F01)
                           007F02  1037  CPU_PCH  = (0x7F02)
                           007F03  1038  CPU_PCL  = (0x7F03)
                           007F04  1039  CPU_XH  = (0x7F04)
                           007F05  1040  CPU_XL  = (0x7F05)
                           007F06  1041  CPU_YH  = (0x7F06)
                           007F07  1042  CPU_YL  = (0x7F07)
                           007F08  1043  CPU_SPH  = (0x7F08)
                           007F09  1044  CPU_SPL   = (0x7F09)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 22.
Hexadecimal [24-Bits]



                           007F0A  1045  CPU_CCR   = (0x7F0A)
                                   1046 
                                   1047 ; global configuration register
                           007F60  1048  CFG_GCR   = (0x7F60)
                           000001  1049  CFG_GCR_AL = 1
                           000000  1050  CFG_GCR_SWIM = 0
                                   1051 
                                   1052 ; interrupt software priority 
                           007F70  1053  ITC_SPR1   = (0x7F70) ; (0..3) 0->resreved,AWU..EXT0 
                           007F71  1054  ITC_SPR2   = (0x7F71) ; (4..7) EXT1..EXT4 RX 
                           007F72  1055  ITC_SPR3   = (0x7F72) ; (8..11) beCAN RX..TIM1 UPDT/OVR  
                           007F73  1056  ITC_SPR4   = (0x7F73) ; (12..15) TIM1 CAP/CMP .. TIM3 UPDT/OVR 
                           007F74  1057  ITC_SPR5   = (0x7F74) ; (16..19) TIM3 CAP/CMP..I2C  
                           007F75  1058  ITC_SPR6   = (0x7F75) ; (20..23) UART3 TX..TIM4 CAP/OVR 
                           007F76  1059  ITC_SPR7   = (0x7F76) ; (24..29) FLASH WR..
                           007F77  1060  ITC_SPR8   = (0x7F77) ; (30..32) ..
                                   1061 
                           000001  1062 ITC_SPR_LEVEL1=1 
                           000000  1063 ITC_SPR_LEVEL2=0
                           000003  1064 ITC_SPR_LEVEL3=3 
                                   1065 
                                   1066 ; SWIM, control and status register
                           007F80  1067  SWIM_CSR   = (0x7F80)
                                   1068 ; debug registers
                           007F90  1069  DM_BK1RE   = (0x7F90)
                           007F91  1070  DM_BK1RH   = (0x7F91)
                           007F92  1071  DM_BK1RL   = (0x7F92)
                           007F93  1072  DM_BK2RE   = (0x7F93)
                           007F94  1073  DM_BK2RH   = (0x7F94)
                           007F95  1074  DM_BK2RL   = (0x7F95)
                           007F96  1075  DM_CR1   = (0x7F96)
                           007F97  1076  DM_CR2   = (0x7F97)
                           007F98  1077  DM_CSR1   = (0x7F98)
                           007F99  1078  DM_CSR2   = (0x7F99)
                           007F9A  1079  DM_ENFCTR   = (0x7F9A)
                                   1080 
                                   1081 ; Interrupt Numbers
                           000000  1082  INT_TLI = 0
                           000001  1083  INT_AWU = 1
                           000002  1084  INT_CLK = 2
                           000003  1085  INT_EXTI0 = 3
                           000004  1086  INT_EXTI1 = 4
                           000005  1087  INT_EXTI2 = 5
                           000006  1088  INT_EXTI3 = 6
                           000007  1089  INT_EXTI4 = 7
                           000008  1090  INT_CAN_RX = 8
                           000009  1091  INT_CAN_TX = 9
                           00000A  1092  INT_SPI = 10
                           00000B  1093  INT_TIM1_OVF = 11
                           00000C  1094  INT_TIM1_CCM = 12
                           00000D  1095  INT_TIM2_OVF = 13
                           00000E  1096  INT_TIM2_CCM = 14
                           00000F  1097  INT_TIM3_OVF = 15
                           000010  1098  INT_TIM3_CCM = 16
                           000011  1099  INT_UART1_TX_COMPLETED = 17
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 23.
Hexadecimal [24-Bits]



                           000012  1100  INT_AUART1_RX_FULL = 18
                           000013  1101  INT_I2C = 19
                           000014  1102  INT_UART3_TX_COMPLETED = 20
                           000015  1103  INT_UART3_RX_FULL = 21
                           000016  1104  INT_ADC2 = 22
                           000017  1105  INT_TIM4_OVF = 23
                           000018  1106  INT_FLASH = 24
                                   1107 
                                   1108 ; Interrupt Vectors
                           008000  1109  INT_VECTOR_RESET = 0x8000
                           008004  1110  INT_VECTOR_TRAP = 0x8004
                           008008  1111  INT_VECTOR_TLI = 0x8008
                           00800C  1112  INT_VECTOR_AWU = 0x800C
                           008010  1113  INT_VECTOR_CLK = 0x8010
                           008014  1114  INT_VECTOR_EXTI0 = 0x8014
                           008018  1115  INT_VECTOR_EXTI1 = 0x8018
                           00801C  1116  INT_VECTOR_EXTI2 = 0x801C
                           008020  1117  INT_VECTOR_EXTI3 = 0x8020
                           008024  1118  INT_VECTOR_EXTI4 = 0x8024
                           008028  1119  INT_VECTOR_CAN_RX = 0x8028
                           00802C  1120  INT_VECTOR_CAN_TX = 0x802c
                           008030  1121  INT_VECTOR_SPI = 0x8030
                           008034  1122  INT_VECTOR_TIM1_OVF = 0x8034
                           008038  1123  INT_VECTOR_TIM1_CCM = 0x8038
                           00803C  1124  INT_VECTOR_TIM2_OVF = 0x803C
                           008040  1125  INT_VECTOR_TIM2_CCM = 0x8040
                           008044  1126  INT_VECTOR_TIM3_OVF = 0x8044
                           008048  1127  INT_VECTOR_TIM3_CCM = 0x8048
                           00804C  1128  INT_VECTOR_UART1_TX_COMPLETED = 0x804c
                           008050  1129  INT_VECTOR_UART1_RX_FULL = 0x8050
                           008054  1130  INT_VECTOR_I2C = 0x8054
                           008058  1131  INT_VECTOR_UART3_TX_COMPLETED = 0x8058
                           00805C  1132  INT_VECTOR_UART3_RX_FULL = 0x805C
                           008060  1133  INT_VECTOR_ADC2 = 0x8060
                           008064  1134  INT_VECTOR_TIM4_OVF = 0x8064
                           008068  1135  INT_VECTOR_FLASH = 0x8068
                                   1136 
                                   1137 ; Condition code register bits
                           000007  1138 CC_V = 7  ; overflow flag 
                           000005  1139 CC_I1= 5  ; interrupt bit 1
                           000004  1140 CC_H = 4  ; half carry 
                           000003  1141 CC_I0 = 3 ; interrupt bit 0
                           000002  1142 CC_N = 2 ;  negative flag 
                           000001  1143 CC_Z = 1 ;  zero flag  
                           000000  1144 CC_C = 0 ; carry bit 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 24.
Hexadecimal [24-Bits]



                                     48     .include "inc/nucleo_8s207.inc"
                                      1 ;;
                                      2 ; Copyright Jacques Deschênes 2019 
                                      3 ; This file is part of MONA 
                                      4 ;
                                      5 ;     MONA is free software: you can redistribute it and/or modify
                                      6 ;     it under the terms of the GNU General Public License as published by
                                      7 ;     the Free Software Foundation, either version 3 of the License, or
                                      8 ;     (at your option) any later version.
                                      9 ;
                                     10 ;     MONA is distributed in the hope that it will be useful,
                                     11 ;     but WITHOUT ANY WARRANTY; without even the implied warranty of
                                     12 ;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                                     13 ;     GNU General Public License for more details.
                                     14 ;
                                     15 ;     You should have received a copy of the GNU General Public License
                                     16 ;     along with MONA.  If not, see <http://www.gnu.org/licenses/>.
                                     17 ;;
                                     18 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     19 ; NUCLEO-8S208RB board specific definitions
                                     20 ; Date: 2019/10/29
                                     21 ; author: Jacques Deschênes, copyright 2018,2019
                                     22 ; licence: GPLv3
                                     23 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     24 
                                     25 ; mcu on board is stm8s207k8
                                     26 
                                     27 ; crystal on board is 8Mhz
                                     28 ; st-link crystal 
                           7A1200    29 FHSE = 8000000
                                     30 
                                     31 ; LD3 is user LED
                                     32 ; connected to PC5 via Q2
                           00500A    33 LED_PORT = PC_BASE ;port C
                           000005    34 LED_BIT = 5
                           000020    35 LED_MASK = (1<<LED_BIT) ;bit 5 mask
                                     36 
                                     37 ; user interface UART via STLINK (T_VCP)
                                     38 
                           000002    39 UART=UART3 
                                     40 ; port used by  UART3 
                           00500A    41 UART_PORT_ODR=PC_ODR 
                           00500C    42 UART_PORT_DDR=PC_DDR 
                           00500B    43 UART_PORT_IDR=PC_IDR 
                           00500D    44 UART_PORT_CR1=PC_CR1 
                           00500E    45 UART_PORT_CR2=PC_CR2 
                                     46 
                                     47 ; clock enable bit 
                           000003    48 UART_PCKEN=CLK_PCKENR1_UART3 
                                     49 
                                     50 ; uart3 registers 
                           005240    51 UART_SR=UART3_SR
                           005241    52 UART_DR=UART3_DR
                           005242    53 UART_BRR1=UART3_BRR1
                           005243    54 UART_BRR2=UART3_BRR2
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 25.
Hexadecimal [24-Bits]



                           005244    55 UART_CR1=UART3_CR1
                           005245    56 UART_CR2=UART3_CR2
                                     57 
                                     58 ; TX, RX pin
                           000005    59 UART_TX_PIN=UART3_TX_PIN 
                           000006    60 UART_RX_PIN=UART3_RX_PIN 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 26.
Hexadecimal [24-Bits]



                                     49 .endif 
                                     50 
                                     51 ; all boards includes 
                                     52 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 27.
Hexadecimal [24-Bits]



                                     53 	.include "inc/ascii.inc"
                                      1 ;;
                                      2 ; Copyright Jacques Deschênes 2019 
                                      3 ; This file is part of MONA 
                                      4 ;
                                      5 ;     MONA is free software: you can redistribute it and/or modify
                                      6 ;     it under the terms of the GNU General Public License as published by
                                      7 ;     the Free Software Foundation, either version 3 of the License, or
                                      8 ;     (at your option) any later version.
                                      9 ;
                                     10 ;     MONA is distributed in the hope that it will be useful,
                                     11 ;     but WITHOUT ANY WARRANTY; without even the implied warranty of
                                     12 ;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                                     13 ;     GNU General Public License for more details.
                                     14 ;
                                     15 ;     You should have received a copy of the GNU General Public License
                                     16 ;     along with MONA.  If not, see <http://www.gnu.org/licenses/>.
                                     17 ;;
                                     18 
                                     19 ;-------------------------------------------------------
                                     20 ;     ASCII control  values
                                     21 ;     CTRL_x   are VT100 keyboard values  
                                     22 ; REF: https://en.wikipedia.org/wiki/ASCII    
                                     23 ;-------------------------------------------------------
                           000001    24 		CTRL_A = 1
                           000001    25 		SOH=CTRL_A  ; start of heading 
                           000002    26 		CTRL_B = 2
                           000002    27 		STX=CTRL_B  ; start of text 
                           000003    28 		CTRL_C = 3
                           000003    29 		ETX=CTRL_C  ; end of text 
                           000004    30 		CTRL_D = 4
                           000004    31 		EOT=CTRL_D  ; end of transmission 
                           000005    32 		CTRL_E = 5
                           000005    33 		ENQ=CTRL_E  ; enquery 
                           000006    34 		CTRL_F = 6
                           000006    35 		ACK=CTRL_F  ; acknowledge
                           000007    36 		CTRL_G = 7
                           000007    37         BELL = 7    ; vt100 terminal generate a sound.
                           000008    38 		CTRL_H = 8  
                           000008    39 		BS = 8     ; back space 
                           000009    40         CTRL_I = 9
                           000009    41     	TAB = 9     ; horizontal tabulation
                           00000A    42         CTRL_J = 10 
                           00000A    43 		LF = 10     ; line feed
                           00000B    44 		CTRL_K = 11
                           00000B    45         VT = 11     ; vertical tabulation 
                           00000C    46 		CTRL_L = 12
                           00000C    47         FF = 12      ; new page
                           00000D    48 		CTRL_M = 13
                           00000D    49 		CR = 13      ; carriage return 
                           00000E    50 		CTRL_N = 14
                           00000E    51 		SO=CTRL_N    ; shift out 
                           00000F    52 		CTRL_O = 15
                           00000F    53 		SI=CTRL_O    ; shift in 
                           000010    54 		CTRL_P = 16
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 28.
Hexadecimal [24-Bits]



                           000010    55 		DLE=CTRL_P   ; data link escape 
                           000011    56 		CTRL_Q = 17
                           000011    57 		DC1=CTRL_Q   ; device control 1 
                           000011    58 		XON=DC1 
                           000012    59 		CTRL_R = 18
                           000012    60 		DC2=CTRL_R   ; device control 2 
                           000013    61 		CTRL_S = 19
                           000013    62 		DC3=CTRL_S   ; device control 3
                           000013    63 		XOFF=DC3 
                           000014    64 		CTRL_T = 20
                           000014    65 		DC4=CTRL_T   ; device control 4 
                           000015    66 		CTRL_U = 21
                           000015    67 		NAK=CTRL_U   ; negative acknowledge
                           000016    68 		CTRL_V = 22
                           000016    69 		SYN=CTRL_V   ; synchronous idle 
                           000017    70 		CTRL_W = 23
                           000017    71 		ETB=CTRL_W   ; end of transmission block
                           000018    72 		CTRL_X = 24
                           000018    73 		CAN=CTRL_X   ; cancel 
                           000019    74 		CTRL_Y = 25
                           000019    75 		EM=CTRL_Y    ; end of medium
                           00001A    76 		CTRL_Z = 26
                           00001A    77 		SUB=CTRL_Z   ; substitute 
                           00001A    78 		EOF=SUB      ; end of text file in MSDOS 
                           00001B    79 		ESC = 27     ; escape 
                           00001C    80 		FS=28        ; file separator 
                           00001D    81 		GS=29        ; group separator 
                           00001E    82 		RS=30		 ; record separator 
                           00001F    83 		US=31 		 ; unit separator 
                           000020    84 		SPACE = 32
                           00002C    85 		COMMA = 44
                           00003A    86 		COLON = 58 
                           00003B    87 		SEMIC = 59  
                           000023    88 		SHARP = 35
                           000027    89 		TICK = 39
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 29.
Hexadecimal [24-Bits]



                                     54 	.include "inc/gen_macros.inc" 
                                      1 ;;
                                      2 ; Copyright Jacques Deschênes 2019 
                                      3 ; This file is part of STM8_NUCLEO 
                                      4 ;
                                      5 ;     STM8_NUCLEO is free software: you can redistribute it and/or modify
                                      6 ;     it under the terms of the GNU General Public License as published by
                                      7 ;     the Free Software Foundation, either version 3 of the License, or
                                      8 ;     (at your option) any later version.
                                      9 ;
                                     10 ;     STM8_NUCLEO is distributed in the hope that it will be useful,
                                     11 ;     but WITHOUT ANY WARRANTY; without even the implied warranty of
                                     12 ;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                                     13 ;     GNU General Public License for more details.
                                     14 ;
                                     15 ;     You should have received a copy of the GNU General Public License
                                     16 ;     along with STM8_NUCLEO.  If not, see <http://www.gnu.org/licenses/>.
                                     17 ;;
                                     18 ;--------------------------------------
                                     19 ;   console Input/Output module
                                     20 ;   DATE: 2019-12-11
                                     21 ;    
                                     22 ;   General usage macros.   
                                     23 ;
                                     24 ;--------------------------------------
                                     25 
                                     26     ; reserve space on stack
                                     27     ; for local variables
                                     28     .macro _vars n 
                                     29     sub sp,#n 
                                     30     .endm 
                                     31     
                                     32     ; free space on stack
                                     33     .macro _drop n 
                                     34     addw sp,#n 
                                     35     .endm
                                     36 
                                     37     ; declare ARG_OFS for arguments 
                                     38     ; displacement on stack. This 
                                     39     ; value depend on local variables 
                                     40     ; size.
                                     41     .macro _argofs n 
                                     42     ARG_OFS=2+n 
                                     43     .endm 
                                     44 
                                     45     ; declare a function argument 
                                     46     ; position relative to stack pointer 
                                     47     ; _argofs must be called before it.
                                     48     .macro _arg name ofs 
                                     49     name=ARG_OFS+ofs 
                                     50     .endm 
                                     51 
                                     52     ; software reset 
                                     53     .macro _swreset
                                     54     mov WWDG_CR,#0X80
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 30.
Hexadecimal [24-Bits]



                                     55     .endm 
                                     56 
                                     57     ; increment zero page variable 
                                     58     .macro _incz v 
                                     59     .byte 0x3c, v 
                                     60     .endm 
                                     61 
                                     62     ; decrement zero page variable 
                                     63     .macro _decz v 
                                     64     .byte 0x3a,v 
                                     65     .endm 
                                     66 
                                     67     ; clear zero page variable 
                                     68     .macro _clrz v 
                                     69     .byte 0x3f, v 
                                     70     .endm 
                                     71 
                                     72     ; load A zero page variable 
                                     73     .macro _ldaz v 
                                     74     .byte 0xb6,v 
                                     75     .endm 
                                     76 
                                     77     ; store A zero page variable 
                                     78     .macro _straz v 
                                     79     .byte 0xb7,v 
                                     80     .endm 
                                     81 
                                     82     ; tnz zero page variable 
                                     83     .macro _tnz v 
                                     84     .byte 0x3d,v 
                                     85     .endm 
                                     86 
                                     87     ; load x from variable in zero page 
                                     88     .macro _ldxz v 
                                     89     .byte 0xbe,v 
                                     90     .endm 
                                     91 
                                     92     ; load y from variable in zero page 
                                     93     .macro _ldyz v 
                                     94     .byte 0x90,0xbe,v 
                                     95     .endm 
                                     96 
                                     97     ; store x in zero page variable 
                                     98     .macro _strxz v 
                                     99     .byte 0xbf,v 
                                    100     .endm 
                                    101 
                                    102     ; store y in zero page variable 
                                    103     .macro _stryz v 
                                    104     .byte 0x90,0xbf,v 
                                    105     .endm 
                                    106 
                                    107     ;  increment 16 bits variable
                                    108     ;  use 10 bytes  
                                    109     .macro _incwz  v 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 31.
Hexadecimal [24-Bits]



                                    110         _incz v+1   ; 1 cy, 2 bytes 
                                    111         jrne .+4  ; 1|2 cy, 2 bytes 
                                    112         _incz v     ; 1 cy, 2 bytes  
                                    113     .endm ; 3 cy 
                                    114 
                                    115     ; xor op with zero page variable 
                                    116     .macro _xorz v 
                                    117     .byte 0xb8,v 
                                    118     .endm 
                                    119     
                                    120     ; move memory to memory in 0 page 
                                    121     .macro _movzz a1, a2 
                                    122     .byte 0x45,a2,a1 
                                    123     .endm 
                                    124 
                                    125     ; check point 
                                    126     ; for debugging help 
                                    127     ; display a character 
                                    128     .macro _cp ch 
                                    129     ld a,#ch 
                                    130     call uart_putc 
                                    131     .endm 
                                    132     
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 32.
Hexadecimal [24-Bits]



                                     55 	.include "app_macros.inc" 
                                      1 ;;
                                      2 ; Copyright Jacques Deschênes 2019 
                                      3 ; This file is part of STM8_NUCLEO 
                                      4 ;
                                      5 ;     STM8_NUCLEO is free software: you can redistribute it and/or modify
                                      6 ;     it under the terms of the GNU General Public License as published by
                                      7 ;     the Free Software Foundation, either version 3 of the License, or
                                      8 ;     (at your option) any later version.
                                      9 ;
                                     10 ;     STM8_NUCLEO is distributed in the hope that it will be useful,
                                     11 ;     but WITHOUT ANY WARRANTY; without even the implied warranty of
                                     12 ;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                                     13 ;     GNU General Public License for more details.
                                     14 ;
                                     15 ;     You should have received a copy of the GNU General Public License
                                     16 ;     along with STM8_NUCLEO.  If not, see <http://www.gnu.org/licenses/>.
                                     17 ;;
                                     18 ;--------------------------------------
                           000004    19         TAB_WIDTH=4 ; default tabulation width 
                           0000FF    20         EOF=0xff ; end of file marker 
                           00000F    21         NLEN_MASK=0xf  ; mask to extract name len 
                                     22 
                                     23 
                           0017FF    24 	STACK_EMPTY=RAM_SIZE-1  
                                     25 
                                     26 
                                     27     ; boolean bit in 'flags' variable 
                           000000    28     FRUN=0 ; program running 
                           000001    29 	FOPT=1 ; run time optimization flag  
                           000003    30 	FSLEEP=3 ; halt resulting from  SLEEP 
                           000004    31 	FSTOP=4 ; STOP command flag 
                           000005    32 	FCOMP=5  ; compiling flags 
                           000006    33     FAUTO=6 ; auto line numbering . 
                           000007    34     FTRACE=7 ; trace flag 
                                     35 
                           000003    36     LINE_HEADER_SIZE=3 ; line number 2 bytes and line length 1 byte 
                           000004    37     FIRST_DATA_ITEM=LINE_HEADER_SIZE+1 ; skip over DATA_IDX token.
                                     38 
                           007FFF    39 	MAX_LINENO=0x7fff; BASIC maximum line number 
                                     40 
                           000008    41 	RX_QUEUE_SIZE=8 
                                     42 
                           00F424    43     TIM2_CLK_FREQ=62500
                                     44 
                           000002    45     ADR_SIZE=2  ; bytes 
                           000002    46     NAME_SIZE=2 ; bytes 
                                     47     
                                     48 
                           000001    49     STDOUT=1 ; output to uart
                           000003    50     BUFOUT=3 ; buffered output  
                                     51 
                           000001    52     TOS=1 ; offset of top of stack parameter on stack 
                                     53 
                           0000F0    54     TYPE_MASK=0xf0 ; mask to extract data type, i.e. DIM variable symbol  or CONST symbol 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 33.
Hexadecimal [24-Bits]



                           000010    55     TYPE_DVAR=(1<<4); DIM variable type 
                           000020    56     TYPE_CONST=(2<<4); CONST data 
                           00000F    57     NLEN_MASK=0xf  ; mask to extract name len 
                           0000FF    58     NONE_IDX = 255 ; not a token 
                                     59 
                                     60     
                                     61 ;--------------------------------------
                                     62 ;   assembler flags 
                                     63 ;-------------------------------------
                                     64 ;    MATH_OVF=0 ; if 1 the stop on math overflow 
                                     65 
                                     66     ; assume 16 Mhz Fcpu 
                                     67      .macro _usec_dly n 
                                     68     ldw x,#(16*n-2)/4 ; 2 cy 
                                     69     decw x  ; 1 cy 
                                     70     nop     ; 1 cy 
                                     71     jrne .-2 ; 2 cy 
                                     72     .endm 
                                     73     
                                     74     ; load X register with 
                                     75     ; entry point of dictionary
                                     76     ; before calling 'search_dict'
                                     77     .macro _ldx_dict dict_name
                                     78         ldw x,#dict_name+2
                                     79     .endm 
                                     80 
                                     81     ; reset BASIC pointer
                                     82     ; to beginning of last token
                                     83     ; extracted except if it was end of line 
                                     84     .macro _unget_token
                                     85         decw y
                                     86     .endm
                                     87 
                                     88     ; extract 16 bits address from BASIC code  
                                     89     .macro _get_addr
                                     90         ldw x,y     ; 1 cy 
                                     91         ldw x,(x)   ; 2 cy 
                                     92         addw y,#2   ; 2 cy 
                                     93     .endm           ; 5 cy 
                                     94 
                                     95     ; alias for _get_addr 
                                     96     .macro _get_word 
                                     97         _get_addr
                                     98     .endm ; 5 cy 
                                     99 
                                    100     ; extract character from BASIC code 
                                    101     .macro _get_char 
                                    102         ld a,(y)    ; 1 cy 
                                    103         incw y      ; 1 cy 
                                    104     .endm           ; 2 cy 
                                    105     
                                    106     ; extract next token 
                                    107     .macro _next_token 
                                    108         _get_char 
                                    109     .endm  ; 2 cy 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 34.
Hexadecimal [24-Bits]



                                    110 
                                    111     ; extract next command token id 
                                    112     .macro _next_cmd     
                                    113         _get_char       ; 2 cy 
                                    114     .endm               ; 2 cy 
                                    115 
                                    116     ; get code address in x
                                    117     .macro _code_addr 
                                    118         clrw x   ; 1 cy 
                                    119         ld xl,a  ; 1 cy 
                                    120         sllw x   ; 2 cy 
                                    121         ldw x,(code_addr,x) ; 2 cy 
                                    122     .endm        ; 6 cy 
                                    123 
                                    124     ; call subroutine from index in a 
                                    125     .macro _call_code
                                    126         _code_addr  ; 6 cy  
                                    127         call (x)    ; 4 cy 
                                    128     .endm  ; 10 cy 
                                    129 
                                    130     ; jump to bytecode routine 
                                    131     ; routine must jump back to 
                                    132     ; interp_loop 
                                    133     .macro _jp_code 
                                    134         _code_addr 
                                    135         jp (x)
                                    136     .endm  ; 8 cycles 
                                    137 
                                    138     ; jump back to interp_loop 
                                    139     .macro _next 
                                    140         jp interp_loop 
                                    141     .endm ; 2 cycles 
                                    142     
                                    143 ;------------------------------------
                                    144 ;  board user LED control macros 
                                    145 ;------------------------------------
                                    146 
                                    147     .macro _led_on 
                                    148         bset LED_PORT,#LED_BIT 
                                    149     .endm 
                                    150 
                                    151     .macro _led_off 
                                    152         bres LED_PORT,#LED_BIT 
                                    153     .endm 
                                    154 
                                    155     .macro _led_toggle 
                                    156         bcpl LED_PORT,#LED_BIT 
                                    157     .endm 
                                    158 
                                    159 
                                    160 ;------------------------------------
                                    161 ;   BASIC pending_stack macros 
                                    162 ;-------------------------------------
                                    163     ; reset pending stack 
                                    164     .macro _rst_pending 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 35.
Hexadecimal [24-Bits]



                                    165     ldw x,#pending_stack+PENDING_STACK_SIZE
                                    166     _strxz psp 
                                    167     .endm 
                                    168 
                                    169     ; fetch TOS 
                                    170     .macro _last_pending 
                                    171     ld a,[psp]
                                    172     .endm 
                                    173 
                                    174     ; push operation token
                                    175     ; input:
                                    176     ;    A   token  
                                    177     .macro _push_op  
                                    178     _decz psp+1
                                    179     ld [psp],a 
                                    180     .endm 
                                    181 
                                    182     ; pop pending operation
                                    183     ; output:
                                    184     ;    A   token  
                                    185     .macro _pop_op 
                                    186     ld a,[psp]
                                    187     _incz psp+1 
                                    188     .endm 
                                    189 
                                    190     ; check for stack full 
                                    191     ; output:
                                    192     ;   A    ==0 -> stack full 
                                    193     .macro _pending_full 
                                    194     ld a,#pending_stack 
                                    195     sub a,psp+1 
                                    196     .endm 
                                    197 
                                    198     ; check for stack_empty
                                    199     ; output:
                                    200     ;   A   == 0 -> stack empty     
                                    201     .macro _pending_empty 
                                    202     _ldaz psp+1 
                                    203     sub a,#pending_stack+PENDING_STACK_SIZE
                                    204     .endm 
                                    205 
                                    206     ; compare a with last pushed op 
                                    207     .macro _cp_op 
                                    208     cp a,[psp]
                                    209     .endm 
                                    210 
                                    211     ; drop last pushed op  
                                    212     .macro _drop_op 
                                    213     _incz psp+1 
                                    214     .endm 
                                    215     
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 36.
Hexadecimal [24-Bits]



                                     56     .include "arithm16_macros.inc" 
                                      1 ;;
                                      2 ; Copyright Jacques Deschênes 2019,2020,2021,2022  
                                      3 ; This file is part of stm8_tbi 
                                      4 ;
                                      5 ;     stm8_tbi is free software: you can redistribute it and/or modify
                                      6 ;     it under the terms of the GNU General Public License as published by
                                      7 ;     the Free Software Foundation, either version 3 of the License, or
                                      8 ;     (at your option) any later version.
                                      9 ;
                                     10 ;     stm8_tbi is distributed in the hope that it will be useful,
                                     11 ;     but WITHOUT ANY WARRANTY; without even the implied warranty of
                                     12 ;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                                     13 ;     GNU General Public License for more details.
                                     14 ;
                                     15 ;     You should have received a copy of the GNU General Public License
                                     16 ;     along with stm8_tbi.  If not, see <http://www.gnu.org/licenses/>.
                                     17 ;;
                                     18 
                                     19 
                                     20 
                                     21 
                           000002    22 	INT_SIZE==2 ; 2's complement 16 bits integers {-32767...32767} 
                           000002    23 	CELL_SIZE==INT_SIZE 
                                     24 
                                     25 
                                     26     ; store int16 from X to stack 
                                     27     .macro _i16_store  i 
                                     28     ldw (i,sp),x 
                                     29     .endm 
                                     30 
                                     31     ; fetch int16 from stack to X 
                                     32     .macro _i16_fetch i 
                                     33     ldw x,(i,sp)
                                     34     .endm 
                                     35 
                                     36     ; pop int16 from top of stack 
                                     37     .macro _i16_pop 
                                     38     popw x 
                                     39     .endm 
                                     40 
                                     41     ; push int16 on stack 
                                     42     .macro _i16_push 
                                     43     pushw X
                                     44     .endm 
                                     45 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 37.
Hexadecimal [24-Bits]



                                     57 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 38.
Hexadecimal [24-Bits]



                                     33         .include "inc/config.inc"
                                      1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                      2 ;; Copyright Jacques Deschênes 2019,2020,2021 
                                      3 ;; This file is part of stm32_eforth  
                                      4 ;;
                                      5 ;;     stm8_eforth is free software: you can redistribute it and/or modify
                                      6 ;;     it under the terms of the GNU General Public License as published by
                                      7 ;;     the Free Software Foundation, either version 3 of the License, or
                                      8 ;;     (at your option) any later version.
                                      9 ;;
                                     10 ;;     stm32_eforth is distributed in the hope that it will be useful,
                                     11 ;;     but WITHOUT ANY WARRANTY;; without even the implied warranty of
                                     12 ;;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                                     13 ;;     GNU General Public License for more details.
                                     14 ;;
                                     15 ;;     You should have received a copy of the GNU General Public License
                                     16 ;;     along with stm32_eforth.  If not, see <http:;;www.gnu.org/licenses/>.
                                     17 ;;;;
                                     18 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     19 
                                     20 ; to enable _TP macro 
                                     21 ; set to 1 
                           000000    22 DEBUG=0
                                     23 
                                     24 ; constants to select board
                                     25 ; to assemble for a specific 
                                     26 ; board or MCU set it to 1 and the other
                                     27 ; to 0. 
                           000001    28 NUCLEO_8S207K8=1
                           000000    29 NUCLEO_8S208RB=0
                                     30 
                           000001    31 .if NUCLEO_8S207K8 
                           000000    32 NUCLEO_8S208RB=0
                                     33 .endif 
                                     34 
                                     35 ; select end of line character
                           000001    36 EOL_CR=1
                           000000    37 EOL_LF=0 
                                     38 
                                     39 ; set to 1 to include 
                                     40 ; scaling constants vocabulary
                                     41 ; file: const_ratio.asm 
                           000000    42 WANT_SCALING_CONST = 0
                                     43 
                                     44 ; set to 1 to include 
                                     45 ; constants tables vocabulary 
                                     46 ; file: ctable.asm 
                           000000    47 WANT_CONST_TABLE=0
                                     48 
                                     49 ; include double library 
                           000000    50 WANT_DOUBLE = 0
                                     51 
                                     52 ; to include 32 bits  
                                     53 ; floating point library
                                     54 ; file: float.asm   
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 39.
Hexadecimal [24-Bits]



                           000000    55 WANT_FLOAT = 0
                           000000    56 .if WANT_FLOAT 
                                     57 	WANT_DOUBLE=1 ; required by float32 
                                     58 .endif 
                                     59 
                                     60 ; to include 24 bits 
                                     61 ; floating point library
                                     62 ; file: float24.asm 
                           000000    63 WANT_FLOAT24 = 0
                           000000    64 .if WANT_FLOAT24
                                     65 	WANT_FLOAT= 0 
                                     66 	WANT_DOUBLE=0 ; not compatible with float24 
                                     67 .endif
                                     68 
                                     69 ; set to 1 to make vocabulary 
                                     70 ; case sensitive 
                           000000    71 CASE_SENSE = 0 
                                     72 
                                     73 
                                     74 	
                                     75  
                                     76 
                                     77 
                                     78 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 40.
Hexadecimal [24-Bits]



                                     34 	.include "macros.inc"
                                      1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                      2 ;; Copyright Jacques Deschênes 2019,2020,2021 
                                      3 ;; This file is part of stm32_eforth  
                                      4 ;;
                                      5 ;;     stm8_eforth is free software: you can redistribute it and/or modify
                                      6 ;;     it under the terms of the GNU General Public License as published by
                                      7 ;;     the Free Software Foundation, either version 3 of the License, or
                                      8 ;;     (at your option) any later version.
                                      9 ;;
                                     10 ;;     stm32_eforth is distributed in the hope that it will be useful,
                                     11 ;;     but WITHOUT ANY WARRANTY;; without even the implied warranty of
                                     12 ;;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                                     13 ;;     GNU General Public License for more details.
                                     14 ;;
                                     15 ;;     You should have received a copy of the GNU General Public License
                                     16 ;;     along with stm32_eforth.  If not, see <http:;;www.gnu.org/licenses/>.
                                     17 ;;;;
                                     18 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     19 
                                     20 ;--------------------------------------
                                     21 ;   console Input/Output module
                                     22 ;   DATE: 2019-12-11
                                     23 ;    
                                     24 ;   General usage macros.   
                                     25 ;
                                     26 ;--------------------------------------
                                     27     
                                     28   
                                     29     ; discard space reserved 
                                     30     ; for local vars on rstack 
                                     31     .macro _DROP_VARS n 
                                     32     addw sp,#n
                                     33     .endm 
                                     34 
                                     35     ; macro to create dictionary header record
                                     36     .macro _HEADER label,len,name 
                                     37         .word LINK 
                                     38         LINK=.
                                     39         .byte len  
                                     40         .ascii name
                                     41         label:
                                     42     .endm 
                                     43 
                                     44     ; runtime literal 
                                     45     .macro _DOLIT value 
                                     46     CALL DOLIT 
                                     47     .word value 
                                     48     .endm 
                                     49 
                                     50     ; branch if TOS<>0
                                     51     ; TBRANCH 
                                     52     .macro _TBRAN target 
                                     53     CALL TBRAN 
                                     54     .word target 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 41.
Hexadecimal [24-Bits]



                                     55     .endm 
                                     56     
                                     57     ; branch if TOS==0 
                                     58     ; 0BRANCH 
                                     59     .macro _QBRAN target 
                                     60     CALL QBRAN
                                     61     .word target
                                     62     .endm 
                                     63 
                                     64     ; uncondittionnal BRANCH 
                                     65     .macro _BRAN target 
                                     66     JRA target  
                                     67     .endm 
                                     68 
                                     69     ; run time NEXT 
                                     70     .macro _DONXT target 
                                     71     CALL DONXT 
                                     72     .word target 
                                     73     .endm 
                                     74 
                                     75     ; drop TOS 
                                     76     .macro _TDROP 
                                     77     ADDW X,#CELLL  
                                     78     .endm 
                                     79   
                                     80    ; drop a double 
                                     81    .macro _DDROP 
                                     82    ADDW X,#2*CELLL 
                                     83    .endm 
                                     84 
                                     85     ; drop n CELLS
                                     86     .macro _DROPN n 
                                     87     ADDW X,#n*CELLL 
                                     88     .endm 
                                     89 
                                     90    ; drop from rstack 
                                     91    .macro _RDROP 
                                     92    ADDW SP,#CELLL
                                     93    .endm 
                                     94 
                                     95    ; drop double from rstack
                                     96    .macro _DRDROP
                                     97    ADDW SP,#2*CELLL 
                                     98    .endm 
                                     99 
                                    100    ; test point, print character 
                                    101    ; and stack contain
                                    102    .macro _TP c 
                                    103    .if DEBUG 
                                    104    LD A,#c 
                                    105    CALL putc
                                    106    CALL DOTS 
                                    107    .endif  
                                    108    .endm 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 42.
Hexadecimal [24-Bits]



                                     35 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 43.
Hexadecimal [24-Bits]



                                     37 
                                     38 
                                     39 ; FORTH Virtual Machine:
                                     40 ; Subroutine threaded model
                                     41 ; SP Return stack pointer
                                     42 ; X Data stack pointer
                                     43 ; A,Y Scratch pad registers
                                     44 ;
                                     45 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     46 ; original code 
                                     47 ;
                                     48 ;       Copyright (c) 2000
                                     49 ;       Dr. C. H. Ting
                                     50 ;       156 14th Avenue
                                     51 ;       San Mateo, CA 94402
                                     52 ;       (650) 571-7639
                                     53 ;
                                     54 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     55       
                                     56 ;*********************************************************
                                     57 ;	Assembler constants
                                     58 ;*********************************************************
                           000030    59 RAMBASE =	APP_DATA_ORG	;ram base
                           0017FF    60 STACK   =	RAM_END 	;system (return) stack empty 
                           001680    61 DATSTK  =	0x1680	;data stack  empty
                           001680    62 TBUFFBASE =     0x1680  ; flash read/write transaction buffer address  
                           001700    63 TIBBASE =       0X1700  ; transaction input buffer addr.
                                     64 
                                     65 ; floatting point state bits in UFPSW 
                           000000    66 ZBIT=0 ; zero bit flag
                           000001    67 NBIT=1 ; negative flag 
                           000002    68 OVBIT=2 ; overflow flag 
                                     69 
                                     70 
                                     71 ;; Memory allocation
                           000030    72 UPP     =     RAMBASE          ; systeme variables base address 
                           001680    73 SPP     =     DATSTK     ; data stack bottom 
                           0017FF    74 RPP     =     STACK      ;  return stack bottom
                           001680    75 ROWBUFF =     TBUFFBASE ; flash write buffer 
                           001700    76 TIBB    =     TIBBASE  ; transaction input buffer
                           0000B0    77 VAR_BASE =    RAMBASE+0x80  ; user variables start here .
                           001640    78 VAR_TOP =     DATSTK-32*CELLL  ; reserve 32 cells for data stack. 
                                     79 
                                     80 ; user variables constants 
                           000030    81 UBASE = UPP       ; numeric base 
                           000032    82 UFPSW = UBASE+2  ; floating point state word 
                           000034    83 UTMP = UFPSW+2    ; temporary storage
                           000036    84 UINN = UTMP+2     ; >IN tib pointer 
                           000038    85 UCTIB = UINN+2    ; tib count 
                           00003A    86 UTIB = UCTIB+2    ; tib address 
                           00003C    87 UINTER = UTIB+2   ; interpreter vector 
                           00003E    88 UHLD = UINTER+2   ; hold 
                           000040    89 UCNTXT = UHLD+2   ; context, dictionary first link 
                           000042    90 ULAST = UCNTXT+2    ; last dictionary pointer 
                           000044    91 UVP = ULAST+2     ; *HERE address  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 44.
Hexadecimal [24-Bits]



                                     92 
                                     93 ;******  System Variables  ******
                           000046    94 XTEMP	=	UVP +2;address called by CREATE
                           000048    95 YTEMP	=	XTEMP+2	;address called by CREATE
                           000046    96 PROD1 = XTEMP	;space for UM*
                           000048    97 PROD2 = PROD1+2
                           00004A    98 PROD3 = PROD2+2
                           00004C    99 CARRY = PROD3+2
                           00004E   100 SP0	= CARRY+2	;initial data stack pointer
                           000050   101 RP0	= SP0+2		;initial return stack pointer
                           000052   102 FPTR = RP0+2         ; 24 bits farptr 
                           000053   103 PTR16 = FPTR+1          ; middle byte of farptr 
                           000054   104 PTR8 = FPTR+2           ; least byte of farptr 
                                    105 
                                    106 ;***********************************************
                                    107 ;; Version control
                                    108 
                           000005   109 MAJOR     =     5         ;major release version
                           000000   110 MINOR     =     0         ;minor extension
                           000000   111 REV       =     0         ;revision 
                                    112 
                                    113 ;; Constants
                                    114 
                           00FFFF   115 TRUEE   =     0xFFFF      ;true flag
                                    116 
                           000040   117 COMPO   =     0x40     ;lexicon compile only bit
                           000080   118 IMEDD   =     0x80     ;lexicon immediate bit
                           001F7F   119 MASKK   =     0x1F7F  ;lexicon bit mask
                                    120 
                           000002   121 CELLL   =     2       ;size of a cell
                           000004   122 DBL_SIZE =    2*CELLL ; size of double integer 
                           00000A   123 BASEE   =     10      ;default radix
                           000008   124 BKSPP   =     8       ;back space
                           00000A   125 LF      =     10      ;line feed
                           00000D   126 CRR     =     13      ;carriage return
                           000011   127 XON     =     17
                           000013   128 XOFF    =     19
                           000018   129 CTRL_X  =     24      ; reboot hotkey 
                           00001B   130 ERR     =     27      ;error escape
                           0000CD   131 CALLL   =     0xCD     ;CALL opcodes
                           000080   132 IRET_CODE =   0x80    ; IRET opcode 
                           00001C   133 ADDWX   =     0x1C    ; opcode for ADDW X,#word  
                           0000CC   134 JPIMM   =     0xCC    ; JP addr opcode 
                                    135 
                                    136 ;---------------------------
                                    137         .area CODE 
                                    138 ;---------------------------
                                    139 
                                    140 ;; Main entry points and COLD start data
      00AC72                        141 forth_init::
                                    142 ; clear all RAM
      00AC72 AE 00 30         [ 2]  143 	ldw X,#RAMBASE
      00AC75                        144 clear_ram0:
      00AC75 7F               [ 1]  145 	clr (X)
      00AC76 5C               [ 1]  146 	incw X
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 45.
Hexadecimal [24-Bits]



      00AC77 A3 17 FF         [ 2]  147 	cpw X,#RAM_END
      00AC7A 23 F9            [ 2]  148 	jrule clear_ram0
      00AC7C AE 17 FF         [ 2]  149         ldw x,#RPP
      00AC7F 94               [ 1]  150         ldw sp,x
      00AC80 CC AC 9B         [ 2]  151 	jp ORIG
                                    152 
                                    153 ; COLD initialize these variables.
      00AC83                        154 UZERO:
      00AC83 00 0A                  155         .word      BASEE   ;BASE
      00AC85 00 00                  156         .word      0       ; floating point state 
      00AC87 00 00                  157         .word      0       ;tmp
      00AC89 00 00                  158         .word      0       ;>IN
      00AC8B 00 00                  159         .word      0       ;#TIB
      00AC8D 17 00                  160         .word      TIBB    ;TIB
      00AC8F BF 36                  161         .word      INTER   ;'EVAL
      00AC91 00 00                  162         .word      0       ;HLD
      00AC93 C5 AD                  163         .word      LASTN  ;CNTXT pointer
      00AC95 C5 AD                  164         .word      LASTN   ;LAST
      00AC97 00 B0                  165         .word      VAR_BASE ; HERE 
      00AC99 00 00                  166 UEND:   .word      0
                                    167 
      00AC9B                        168 ORIG:   
                                    169 ; initialize SP
      00AC9B AE 17 FF         [ 2]  170         LDW     X,#STACK  ;initialize return stack
      00AC9E 94               [ 1]  171         LDW     SP,X
      00AC9F BF 50            [ 2]  172         LDW     RP0,X
      00ACA1 AE 16 80         [ 2]  173         LDW     X,#DATSTK ;initialize data stack
      00ACA4 BF 4E            [ 2]  174         LDW     SP0,X
                                    175 
                                    176         
      00ACA6 CC C5 B2         [ 2]  177         jp  COLD   ;default=MN1
                                    178 
                                    179 
                           000000   180         LINK = 0  ; used by _HEADER macro 
                                    181 
                                    182 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;        
                                    183 ;; place MCU in sleep mode with
                                    184 ;; halt opcode 
                                    185 ;; BYE ( -- )
                                    186 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000037                        187         _HEADER BYE,3,"BYE"
      00ACA9 00 00                    1         .word LINK 
                           000039     2         LINK=.
      00ACAB 03                       3         .byte 3  
      00ACAC 42 59 45                 4         .ascii "BYE"
      00ACAF                          5         BYE:
      00003D                        188         _swreset 
      00ACAF 35 80 50 D1      [ 1]    1     mov WWDG_CR,#0X80
                                    189         
                                    190 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    191 ;; Reset dictionary pointer before 
                                    192 ;; forgotten word.
                                    193 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000041                        194         _HEADER FORGET,6,"FORGET"
      00ACB3 AC AB                    1         .word LINK 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 46.
Hexadecimal [24-Bits]



                           000043     2         LINK=.
      00ACB5 06                       3         .byte 6  
      00ACB6 46 4F 52 47 45 54        4         .ascii "FORGET"
      00ACBC                          5         FORGET:
      00ACBC CD BC F7         [ 4]  195         call TOKEN
      00ACBF CD AF DE         [ 4]  196         call DUPP 
      00ACC2 CD AE 5D         [ 4]  197         call QBRAN 
      00ACC5 AD 3C                  198         .word FORGET2 ; invalid parameter
      00ACC7 CD BD F4         [ 4]  199         call NAMEQ ; ( a -- ca na | a F )
      00ACCA CD B1 41         [ 4]  200         call QDUP 
      00ACCD CD AE 5D         [ 4]  201         call QBRAN 
      00ACD0 AD 3C                  202         .word FORGET2 ; not in dictionary 
                                    203 ; only forget users words 
      00ACD2 CD AF DE         [ 4]  204         call DUPP ; ( -- ca na na )
      00ACD5 CD AE 34         [ 4]  205         call DOLIT 
      00ACD8 16 40                  206         .word VAR_TOP 
      00ACDA CD B2 85         [ 4]  207         call  ULESS 
      00ACDD CD AE 5D         [ 4]  208         call QBRAN 
      00ACE0 AD 02                  209         .word FORGET6 
                                    210 ; ( ca na -- )        
      00ACE2 CD AF EE         [ 4]  211         call SWAPP ; ( ca na -- na ca )
      000073                        212         _TDROP ; ( na ca -- na )
      00ACE5 1C 00 02         [ 2]    1     ADDW X,#CELLL  
      000076                        213         _DOLIT 2 
      00ACE8 CD AE 34         [ 4]    1     CALL DOLIT 
      00ACEB 00 02                    2     .word 2 
      00ACED CD B2 47         [ 4]  214         call SUBB ; link field 
      00ACF0 CD AE A8         [ 4]  215         call AT   ; previous word in dictionary 
      00ACF3 CD AF DE         [ 4]  216         call DUPP ; ( -- na na )
      00ACF6 CD B1 13         [ 4]  217         call CNTXT 
      00ACF9 CD AE 96         [ 4]  218         call STORE
      00ACFC CD B1 31         [ 4]  219         call LAST  
      00ACFF CC AE 96         [ 2]  220         JP STORE 
      00AD02                        221 FORGET6: ; tried to forget system word 
                                    222 ; ( ca na -- )
      00AD02 1D 00 02         [ 2]  223         subw x,#CELLL 
      00AD05 90 BE 4E         [ 2]  224         ldw y,SP0 
      00AD08 FF               [ 2]  225         ldw (x),y  
      00AD09 CD B2 85         [ 4]  226         call ULESS
      00AD0C CD AE 5D         [ 4]  227         call QBRAN 
      00AD0F AD 2E                  228         .word PROTECTED 
      00AD11 CD BF 00         [ 4]  229         call ABORQ 
      00AD14 19                     230         .byte 25
      00AD15 20 63 61 6E 27 74 20   231         .ascii " can't forget system word"
             66 6F 72 67 65 74 20
             73 79 73 74 65 6D 20
             77 6F 72 64
      00AD2E                        232 PROTECTED:
      00AD2E CD BF 00         [ 4]  233         call ABORQ
      00AD31 0A                     234         .byte 10
      00AD32 20 50 72 6F 74 65 63   235         .ascii " Protected"
             74 65 64
      00AD3C                        236 FORGET2: ; no name or not found in dictionary 
      00AD3C CD BF 00         [ 4]  237         call ABORQ
      00AD3F 0B                     238         .byte 11
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 47.
Hexadecimal [24-Bits]



      00AD40 20 6E 6F 74 20 61 20   239         .ascii " not a word"
             77 6F 72 64
      00AD4B                        240 FORGET4:
      00AD4B CC AF D4         [ 2]  241         jp DROP 
                                    242 
                                    243 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    244 ;    SEED ( n -- )
                                    245 ; Initialize PRNG seed with n 
                                    246 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0000DC                        247         _HEADER SEED,4,"SEED"
      00AD4E AC B5                    1         .word LINK 
                           0000DE     2         LINK=.
      00AD50 04                       3         .byte 4  
      00AD51 53 45 45 44              4         .ascii "SEED"
      00AD55                          5         SEED:
      00AD55 90 93            [ 1]  248         ldw y,x 
      00AD57 1C 00 02         [ 2]  249         addw x,#CELLL
      00AD5A 90 FE            [ 2]  250         ldw y,(y)
      00AD5C 89               [ 2]  251         pushw x 
      00AD5D 93               [ 1]  252         ldw x,y 
      00AD5E CD 83 91         [ 4]  253         call set_seed 
      00AD61 85               [ 2]  254         popw x 
      00AD62 81               [ 4]  255         ret 
                                    256 
                                    257 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    258 ;    RANDOM ( u1 -- u2 )
                                    259 ; Pseudo random number betwen 0 and u1-1
                                    260 ;  XOR32 algorithm 
                                    261 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0000F1                        262         _HEADER RANDOM,6,"RANDOM"
      00AD63 AD 50                    1         .word LINK 
                           0000F3     2         LINK=.
      00AD65 06                       3         .byte 6  
      00AD66 52 41 4E 44 4F 4D        4         .ascii "RANDOM"
      00AD6C                          5         RANDOM:
      00AD6C 89               [ 2]  263         pushw x 
      00AD6D CD 83 6F         [ 4]  264         call prng 
      00AD70 89               [ 2]  265         pushw x 
      00AD71 16 03            [ 2]  266         ldw y,(3,sp) 
      00AD73 90 FE            [ 2]  267         ldw y,(y)
      00AD75 85               [ 2]  268         popw x 
      00AD76 65               [ 2]  269         divw x,y 
      00AD77 85               [ 2]  270         popw x 
      00AD78 FF               [ 2]  271         ldw (x),y 
      00AD79 81               [ 4]  272         ret 
                                    273 
                                    274 
                                    275 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    276 ;; get millisecond counter 
                                    277 ;; msec ( -- u )
                                    278 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000108                        279         _HEADER MSEC,4,"MSEC"
      00AD7A AD 65                    1         .word LINK 
                           00010A     2         LINK=.
      00AD7C 04                       3         .byte 4  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 48.
Hexadecimal [24-Bits]



      00AD7D 4D 53 45 43              4         .ascii "MSEC"
      00AD81                          5         MSEC:
      00AD81 1D 00 02         [ 2]  280         subw x,#CELLL 
      000112                        281         _ldyz ticks 
      00AD84 90 BE 01                 1     .byte 0x90,0xbe,ticks 
      00AD87 FF               [ 2]  282         ldw (x),y 
      00AD88 81               [ 4]  283         ret 
                                    284 
                                    285 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    286 ; suspend execution for u msec 
                                    287 ;  pause ( u -- )
                                    288 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000117                        289         _HEADER PAUSE,5,"PAUSE"
      00AD89 AD 7C                    1         .word LINK 
                           000119     2         LINK=.
      00AD8B 05                       3         .byte 5  
      00AD8C 50 41 55 53 45           4         .ascii "PAUSE"
      00AD91                          5         PAUSE:
      00AD91 90 93            [ 1]  290         ldw y,x
      00AD93 1C 00 02         [ 2]  291         addw x,#CELLL 
      00AD96 90 FE            [ 2]  292         ldw y,(y)
      00AD98 72 B9 00 01      [ 2]  293         addw y,ticks 
      00AD9C 8F               [10]  294 1$:     wfi  
      00AD9D 90 C3 00 01      [ 2]  295         cpw y,ticks   
      00ADA1 26 F9            [ 1]  296         jrne 1$
      00ADA3 81               [ 4]  297         ret 
                                    298 
                                    299 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    300 ; initialize count down timer 
                                    301 ;  TIMER ( u -- )  milliseconds
                                    302 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000132                        303         _HEADER TIMER,5,"TIMER"
      00ADA4 AD 8B                    1         .word LINK 
                           000134     2         LINK=.
      00ADA6 05                       3         .byte 5  
      00ADA7 54 49 4D 45 52           4         .ascii "TIMER"
      00ADAC                          5         TIMER:
      00ADAC 90 93            [ 1]  304         ldw y,x
      00ADAE 90 FE            [ 2]  305         ldw y,(y) 
      00013E                        306         _stryz timer 
      00ADB0 90 BF 03                 1     .byte 0x90,0xbf,timer 
      00ADB3 1C 00 02         [ 2]  307         addw x,#CELLL 
      00ADB6 81               [ 4]  308         ret 
                                    309 
                                    310 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    311 ; check for TIMER exiparition 
                                    312 ;  TIMEOUT? ( -- 0|-1 )
                                    313 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000145                        314         _HEADER TIMEOUTQ,8,"TIMEOUT?"
      00ADB7 AD A6                    1         .word LINK 
                           000147     2         LINK=.
      00ADB9 08                       3         .byte 8  
      00ADBA 54 49 4D 45 4F 55 54     4         .ascii "TIMEOUT?"
             3F
      00ADC2                          5         TIMEOUTQ:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 49.
Hexadecimal [24-Bits]



      00ADC2 4F               [ 1]  315         clr a
      00ADC3 1D 00 02         [ 2]  316         subw x,#CELLL 
      00ADC6 90 CE 00 03      [ 2]  317         ldw y,timer 
      00ADCA 26 01            [ 1]  318         jrne 1$ 
      00ADCC 43               [ 1]  319         cpl a 
      00ADCD E7 01            [ 1]  320 1$:     ld (1,x),a 
      00ADCF F7               [ 1]  321         ld (x),a 
      00ADD0 81               [ 4]  322         ret         
                                    323 
                                    324 ;; Device dependent I/O
                                    325 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    326 ;       ?RX     ( -- c T | F )
                                    327 ;         Return input character and true, or only false.
                                    328 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00015F                        329         _HEADER QKEY,4,"?KEY"
      00ADD1 AD B9                    1         .word LINK 
                           000161     2         LINK=.
      00ADD3 04                       3         .byte 4  
      00ADD4 3F 4B 45 59              4         .ascii "?KEY"
      00ADD8                          5         QKEY:
      00ADD8 CD 85 A6         [ 4]  330         call uart_qgetc
      00ADDB 26 07            [ 1]  331         jrne INCH 
      00ADDD 1D 00 02         [ 2]  332 	SUBW	X,#CELLL
      00ADE0 90 5F            [ 1]  333         CLRW    Y 
      00ADE2 FF               [ 2]  334         LDW (X),Y
      00ADE3 81               [ 4]  335         RET 
      00ADE4                        336 INCH:         
      00ADE4 CD 85 AC         [ 4]  337         call uart_getc 
      00ADE7 1D 00 04         [ 2]  338         SUBW X, #2*CELLL 
      00ADEA 6F 02            [ 1]  339         CLR     (CELLL,X)
      00ADEC E7 03            [ 1]  340         LD     (CELLL+1,X),A
      00ADEE 90 AE FF FF      [ 2]  341 	LDW     Y,#-1
      00ADF2 FF               [ 2]  342         LDw     (X),Y 
      00ADF3 81               [ 4]  343         RET 
                                    344 
                                    345 
                                    346 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    347 ;       TX!     ( c -- )
                                    348 ;       Send character c to  output device.
                                    349 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000182                        350         _HEADER EMIT,4,"EMIT"
      00ADF4 AD D3                    1         .word LINK 
                           000184     2         LINK=.
      00ADF6 04                       3         .byte 4  
      00ADF7 45 4D 49 54              4         .ascii "EMIT"
      00ADFB                          5         EMIT:
      00ADFB E6 01            [ 1]  351         LD     A,(1,X)
      00ADFD 1C 00 02         [ 2]  352 	ADDW	X,#2
      00AE00                        353 putc:         
      00AE00 72 0F 52 40 FB   [ 2]  354 OUTPUT: BTJF UART_SR,#UART_SR_TXE,OUTPUT  ;loop until tx empty 
      00AE05 C7 52 41         [ 1]  355         LD    UART_DR,A   ;send A
      00AE08 81               [ 4]  356         RET
                                    357 
                                    358 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    359 ;       FC-XON  ( -- )
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 50.
Hexadecimal [24-Bits]



                                    360 ;       send XON character 
                                    361 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000197                        362         _HEADER FC_XON,6,"FC-XON"
      00AE09 AD F6                    1         .word LINK 
                           000199     2         LINK=.
      00AE0B 06                       3         .byte 6  
      00AE0C 46 43 2D 58 4F 4E        4         .ascii "FC-XON"
      00AE12                          5         FC_XON:
      00AE12 1D 00 02         [ 2]  363         subw x,#CELLL 
      00AE15 7F               [ 1]  364         clr (x)
      00AE16 A6 11            [ 1]  365         ld a,#XON 
      00AE18 E7 01            [ 1]  366         ld (1,x),a 
      00AE1A CD AD FB         [ 4]  367         call EMIT 
      00AE1D 81               [ 4]  368         ret 
                                    369 
                                    370 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    371 ;       FC-XOFF ( -- )
                                    372 ;       Send XOFF character 
                                    373 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0001AC                        374         _HEADER FC_XOFF,7,"FC-XOFF"
      00AE1E AE 0B                    1         .word LINK 
                           0001AE     2         LINK=.
      00AE20 07                       3         .byte 7  
      00AE21 46 43 2D 58 4F 46 46     4         .ascii "FC-XOFF"
      00AE28                          5         FC_XOFF:
      00AE28 1D 00 02         [ 2]  375         subw x,#CELLL 
      00AE2B 7F               [ 1]  376         clr (x)
      00AE2C A6 13            [ 1]  377         ld a,#XOFF 
      00AE2E E7 01            [ 1]  378         ld (1,x),a 
      00AE30 CD AD FB         [ 4]  379         call EMIT 
      00AE33 81               [ 4]  380         ret
                                    381 
                                    382 ;; The kernel
                                    383 
                                    384 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    385 ;       doLIT   ( -- w )
                                    386 ;       Push an inline literal.
                                    387 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00AE34                        388 DOLIT:
      00AE34 1D 00 02         [ 2]  389 	SUBW X,#2
      00AE37 16 01            [ 2]  390         ldw y,(1,sp)
      00AE39 90 FE            [ 2]  391         ldw y,(y)
      00AE3B FF               [ 2]  392         ldw (x),y
      00AE3C 90 85            [ 2]  393         popw y 
      00AE3E 90 EC 02         [ 2]  394         jp (2,y)
                                    395 
                                    396 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    397 ;       NEXT    ( -- )
                                    398 ;       Code for  single index loop.
                                    399 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0001CF                        400         _HEADER DONXT,COMPO+4,"NEXT"
      00AE41 AE 20                    1         .word LINK 
                           0001D1     2         LINK=.
      00AE43 44                       3         .byte COMPO+4  
      00AE44 4E 45 58 54              4         .ascii "NEXT"
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 51.
Hexadecimal [24-Bits]



      00AE48                          5         DONXT:
      00AE48 16 03            [ 2]  401 	LDW Y,(3,SP)
      00AE4A 90 5A            [ 2]  402 	DECW Y
      00AE4C 2A 07            [ 1]  403 	JRPL NEX1 ; jump if N=0
      00AE4E 90 85            [ 2]  404 	POPW Y
      00AE50 5B 02            [ 2]  405         addw sp,#2
      00AE52 90 EC 02         [ 2]  406         JP (2,Y)
      00AE55                        407 NEX1:
      00AE55 17 03            [ 2]  408         LDW (3,SP),Y
      00AE57 90 85            [ 2]  409         POPW Y
      00AE59 90 FE            [ 2]  410 	LDW Y,(Y)
      00AE5B 90 FC            [ 2]  411 	JP (Y)
                                    412 
                                    413 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    414 ;       ?branch ( f -- )
                                    415 ;       Branch if flag is zero.
                                    416 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    417 ;       _HEADER QBRAN,COMPO+7,"?BRANCH"        
      00AE5D                        418 QBRAN:	
      00AE5D 90 93            [ 1]  419         LDW Y,X
      00AE5F 1C 00 02         [ 2]  420 	ADDW X,#2
      00AE62 90 FE            [ 2]  421 	LDW Y,(Y)
      00AE64 27 13            [ 1]  422         JREQ     BRAN
      00AE66 90 85            [ 2]  423 	POPW Y
      00AE68 90 EC 02         [ 2]  424 	JP (2,Y)
                                    425 
                                    426 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    427 ;  TBRANCH ( f -- )
                                    428 ;  branch if f==TRUE 
                                    429 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    430 ;        _HEADER TBRAN,COMPO+7,"TBRANCH"
      00AE6B                        431 TBRAN: 
      00AE6B 90 93            [ 1]  432         LDW Y,X 
      00AE6D 1C 00 02         [ 2]  433         ADDW X,#2 
      00AE70 90 FE            [ 2]  434         LDW Y,(Y)
      00AE72 26 05            [ 1]  435         JRNE BRAN 
      00AE74 90 85            [ 2]  436         POPW Y 
      00AE76 90 EC 02         [ 2]  437         JP (2,Y)
                                    438 
                                    439 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    440 ;       branch  ( -- )
                                    441 ;       Branch to an inline address.
                                    442 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    443 ;       _HEADER BRAN,COMPO+6,"BRANCH"
      00AE79                        444 BRAN:
      00AE79 90 85            [ 2]  445         POPW Y
      00AE7B 90 FE            [ 2]  446 	LDW Y,(Y)
      00AE7D 90 FC            [ 2]  447         JP  (Y)
                                    448 
                                    449 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    450 ;       EXECUTE ( ca -- )
                                    451 ;       Execute  word at ca.
                                    452 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00020D                        453         _HEADER EXECU,7,"EXECUTE"
      00AE7F AE 43                    1         .word LINK 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 52.
Hexadecimal [24-Bits]



                           00020F     2         LINK=.
      00AE81 07                       3         .byte 7  
      00AE82 45 58 45 43 55 54 45     4         .ascii "EXECUTE"
      00AE89                          5         EXECU:
      00AE89 90 93            [ 1]  454         LDW Y,X
      00AE8B 1C 00 02         [ 2]  455 	ADDW X,#CELLL 
      00AE8E 90 FE            [ 2]  456 	LDW  Y,(Y)
      00AE90 90 FC            [ 2]  457         JP   (Y)
                                    458 
                           000001   459 OPTIMIZE = 1
                           000001   460 .if OPTIMIZE 
                                    461 ; remplacement de CALL EXIT par 
                                    462 ; le opcode de RET.
                                    463 ; Voir modification au code de ";"
                           000000   464 .else 
                                    465 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    466 ;       EXIT    ( -- )
                                    467 ;       Terminate a colon definition.
                                    468 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    469 ;       _HEADER EXIT,4,"EXIT"
                                    470 EXIT:
                                    471         POPW Y
                                    472         RET
                                    473 .endif 
                                    474 
                                    475 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    476 ;       !       ( w a -- )
                                    477 ;       Pop  data stack to memory.
                                    478 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000220                        479         _HEADER STORE,1,"!"
      00AE92 AE 81                    1         .word LINK 
                           000222     2         LINK=.
      00AE94 01                       3         .byte 1  
      00AE95 21                       4         .ascii "!"
      00AE96                          5         STORE:
      00AE96 90 93            [ 1]  480         LDW Y,X
      00AE98 90 FE            [ 2]  481         LDW Y,(Y)    ;Y=a
      00AE9A 89               [ 2]  482         PUSHW X
      00AE9B EE 02            [ 2]  483         LDW X,(2,X) ; x=w 
      00AE9D 90 FF            [ 2]  484         LDW (Y),X 
      00AE9F 85               [ 2]  485         POPW X  
      00022E                        486         _DDROP 
      00AEA0 1C 00 04         [ 2]    1    ADDW X,#2*CELLL 
      00AEA3 81               [ 4]  487         RET     
                                    488 
                                    489 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    490 ;       @       ( a -- w )
                                    491 ;       Push memory location to stack.
                                    492 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000232                        493         _HEADER AT,1,"@"
      00AEA4 AE 94                    1         .word LINK 
                           000234     2         LINK=.
      00AEA6 01                       3         .byte 1  
      00AEA7 40                       4         .ascii "@"
      00AEA8                          5         AT:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 53.
Hexadecimal [24-Bits]



      00AEA8 90 93            [ 1]  494         LDW Y,X     ;Y = a
      00AEAA 90 FE            [ 2]  495         LDW Y,(Y)   ; address 
      00AEAC 90 FE            [ 2]  496         LDW Y,(Y)   ; value 
      00AEAE FF               [ 2]  497         LDW (X),Y ;w = @Y
      00AEAF 81               [ 4]  498         RET     
                                    499 
                                    500 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    501 ;       C!      ( c b -- )
                                    502 ;       Pop  data stack to byte memory.
                                    503 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00023E                        504         _HEADER CSTOR,2,"C!"
      00AEB0 AE A6                    1         .word LINK 
                           000240     2         LINK=.
      00AEB2 02                       3         .byte 2  
      00AEB3 43 21                    4         .ascii "C!"
      00AEB5                          5         CSTOR:
      00AEB5 90 93            [ 1]  505         LDW Y,X
      00AEB7 90 FE            [ 2]  506 	LDW Y,(Y)    ;Y=b
      00AEB9 E6 03            [ 1]  507         LD A,(3,X)    ;D = c
      00AEBB 90 F7            [ 1]  508         LD  (Y),A     ;store c at b
      00AEBD 1C 00 04         [ 2]  509 	ADDW X,#4 ; DDROP 
      00AEC0 81               [ 4]  510         RET     
                                    511 
                                    512 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    513 ;       C@      ( b -- c )
                                    514 ;       Push byte in memory to  stack.
                                    515 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00024F                        516         _HEADER CAT,2,"C@"
      00AEC1 AE B2                    1         .word LINK 
                           000251     2         LINK=.
      00AEC3 02                       3         .byte 2  
      00AEC4 43 40                    4         .ascii "C@"
      00AEC6                          5         CAT:
      00AEC6 90 93            [ 1]  517         LDW Y,X     ;Y=b
      00AEC8 90 FE            [ 2]  518         LDW Y,(Y)
      00AECA 90 F6            [ 1]  519         LD A,(Y)
      00AECC E7 01            [ 1]  520         LD (1,X),A
      00AECE 7F               [ 1]  521         CLR (X)
      00AECF 81               [ 4]  522         RET     
                                    523 
                                    524 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    525 ;       RP@     ( -- a )
                                    526 ;       Push current RP to data stack.
                                    527 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00025E                        528         _HEADER RPAT,3,"RP@"
      00AED0 AE C3                    1         .word LINK 
                           000260     2         LINK=.
      00AED2 03                       3         .byte 3  
      00AED3 52 50 40                 4         .ascii "RP@"
      00AED6                          5         RPAT:
      00AED6 90 96            [ 1]  529         LDW Y,SP    ;save return addr
      00AED8 1D 00 02         [ 2]  530         SUBW X,#2
      00AEDB FF               [ 2]  531         LDW (X),Y
      00AEDC 81               [ 4]  532         RET     
                                    533 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 54.
Hexadecimal [24-Bits]



                                    534 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    535 ;       RP!     ( a -- )
                                    536 ;       Set  return stack pointer.
                                    537 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00026B                        538         _HEADER RPSTO,COMPO+3,"RP!"
      00AEDD AE D2                    1         .word LINK 
                           00026D     2         LINK=.
      00AEDF 43                       3         .byte COMPO+3  
      00AEE0 52 50 21                 4         .ascii "RP!"
      00AEE3                          5         RPSTO:
      00AEE3 90 85            [ 2]  539         POPW Y
      00AEE5 90 BF 48         [ 2]  540         LDW YTEMP,Y
      00AEE8 90 93            [ 1]  541         LDW Y,X
      00AEEA 90 FE            [ 2]  542         LDW Y,(Y)
      00AEEC 90 94            [ 1]  543         LDW SP,Y
      00AEEE 1C 00 02         [ 2]  544         ADDW X,#CELLL ; a was not dropped, Picatout 2020-05-24
      00AEF1 92 CC 48         [ 5]  545         JP [YTEMP]
                                    546 
                                    547 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    548 ;       R>      ( -- w )
                                    549 ;       Pop return stack to data stack.
                                    550 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000282                        551         _HEADER RFROM,2,"R>"
      00AEF4 AE DF                    1         .word LINK 
                           000284     2         LINK=.
      00AEF6 02                       3         .byte 2  
      00AEF7 52 3E                    4         .ascii "R>"
      00AEF9                          5         RFROM:
      00AEF9 1D 00 02         [ 2]  552         SUBW X,#CELLL 
      00AEFC 16 03            [ 2]  553         LDW Y,(3,SP)
      00AEFE FF               [ 2]  554         LDW (X),Y 
      00AEFF 90 85            [ 2]  555         POPW Y 
      00AF01 5B 02            [ 2]  556         ADDW SP,#2 
      00AF03 90 FC            [ 2]  557         JP (Y)
                                    558 
                                    559 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    560 ;       R@      ( -- w )
                                    561 ;       Copy top of return stack to stack.
                                    562 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000293                        563         _HEADER RAT,2,"R@"
      00AF05 AE F6                    1         .word LINK 
                           000295     2         LINK=.
      00AF07 02                       3         .byte 2  
      00AF08 52 40                    4         .ascii "R@"
      00AF0A                          5         RAT:
      00AF0A 16 03            [ 2]  564         ldw y,(3,sp)
      00AF0C 1D 00 02         [ 2]  565         subw x,#CELLL 
      00AF0F FF               [ 2]  566         ldw (x),y 
      00AF10 81               [ 4]  567         ret 
                                    568 
                                    569 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    570 ;       LOCAL ( n -- )
                                    571 ;       reserve n slots on return stack
                                    572 ;       for local variables 
                                    573 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 55.
Hexadecimal [24-Bits]



      00029F                        574         _HEADER LOCAL,5,"LOCAL"
      00AF11 AF 07                    1         .word LINK 
                           0002A1     2         LINK=.
      00AF13 05                       3         .byte 5  
      00AF14 4C 4F 43 41 4C           4         .ascii "LOCAL"
      00AF19                          5         LOCAL:
      00AF19 90 85            [ 2]  575         POPW Y  
      00AF1B 90 BF 48         [ 2]  576         LDW YTEMP,Y ; RETURN ADDRESS 
      00AF1E E6 01            [ 1]  577         LD A,(1,X)
      00AF20 90 97            [ 1]  578         LD YL,A 
      00AF22 A6 02            [ 1]  579         LD A,#CELLL 
      00AF24 90 42            [ 4]  580         MUL Y,A 
      00AF26 90 BF 46         [ 2]  581         LDw XTEMP,Y
      00AF29 90 96            [ 1]  582         LDW Y,SP 
      00AF2B 72 B2 00 46      [ 2]  583         SUBW Y,XTEMP
      00AF2F 90 94            [ 1]  584         LDW SP,Y 
      00AF31 1C 00 02         [ 2]  585         ADDW X,#CELLL 
      00AF34 92 CC 48         [ 5]  586         JP [YTEMP]
                                    587 
                                    588 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    589 ;       NRDROP ( n -- )
                                    590 ;       drop n elements from rstack
                                    591 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0002C5                        592         _HEADER NRDROP,6,"NRDROP" 
      00AF37 AF 13                    1         .word LINK 
                           0002C7     2         LINK=.
      00AF39 06                       3         .byte 6  
      00AF3A 4E 52 44 52 4F 50        4         .ascii "NRDROP"
      00AF40                          5         NRDROP:
      00AF40 90 85            [ 2]  593         POPW Y 
      00AF42 90 BF 48         [ 2]  594         LDW YTEMP,Y ; RETURN ADDRESS 
      00AF45 E6 01            [ 1]  595         LD A,(1,X)
      00AF47 90 97            [ 1]  596         LD YL,A  
      00AF49 A6 02            [ 1]  597         LD A,#CELLL 
      00AF4B 90 42            [ 4]  598         MUL Y,A 
      00AF4D 90 BF 46         [ 2]  599         LDW XTEMP,Y 
      00AF50 90 96            [ 1]  600         LDW Y,SP 
      00AF52 72 B9 00 46      [ 2]  601         ADDW Y,XTEMP 
      00AF56 90 94            [ 1]  602         LDW SP,Y  
      00AF58 1C 00 02         [ 2]  603         ADDW X,#CELLL 
      00AF5B 92 CC 48         [ 5]  604         JP [YTEMP]
                                    605 
                                    606 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    607 ;        ( n -- w)
                                    608 ;      fetch nth element ofr return stack 
                                    609 ;      n==0 is same as R@ 
                                    610 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0002EC                        611         _HEADER NRAT,3,"NR@"
      00AF5E AF 39                    1         .word LINK 
                           0002EE     2         LINK=.
      00AF60 03                       3         .byte 3  
      00AF61 4E 52 40                 4         .ascii "NR@"
      00AF64                          5         NRAT:
      00AF64 E6 01            [ 1]  612         LD A,(1,X)
      00AF66 90 97            [ 1]  613         LD YL,A 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 56.
Hexadecimal [24-Bits]



      00AF68 A6 02            [ 1]  614         LD A,#CELLL 
      00AF6A 90 42            [ 4]  615         MUL Y,A 
      00AF6C 90 BF 48         [ 2]  616         LDW YTEMP,Y 
      00AF6F 90 96            [ 1]  617         LDW Y,SP 
      00AF71 72 A9 00 03      [ 2]  618         ADDW Y,#3 
      00AF75 72 B9 00 48      [ 2]  619         ADDW Y,YTEMP 
      00AF79 90 FE            [ 2]  620         LDW Y,(Y)
      00AF7B FF               [ 2]  621         LDW (X),Y 
      00AF7C 81               [ 4]  622         RET 
                                    623 
                                    624 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    625 ;       NR! ( w n --  )
                                    626 ;       store w on nth position of 
                                    627 ;       return stack 
                                    628 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00030B                        629         _HEADER NRSTO,3,"NR!"
      00AF7D AF 60                    1         .word LINK 
                           00030D     2         LINK=.
      00AF7F 03                       3         .byte 3  
      00AF80 4E 52 21                 4         .ascii "NR!"
      00AF83                          5         NRSTO:
      00AF83 90 96            [ 1]  630         LDW Y,SP
      00AF85 72 A9 00 03      [ 2]  631         ADDW Y,#3 
      00AF89 90 BF 48         [ 2]  632         LDW YTEMP,Y 
      00AF8C E6 01            [ 1]  633         LD A,(1,X)
      00AF8E 90 97            [ 1]  634         LD YL,A 
      00AF90 A6 02            [ 1]  635         LD A,#CELLL 
      00AF92 90 42            [ 4]  636         MUL Y,A 
      00AF94 72 B9 00 48      [ 2]  637         ADDW Y,YTEMP
      00AF98 89               [ 2]  638         PUSHW X 
      00AF99 EE 02            [ 2]  639         LDW X,(CELLL,X)
      00AF9B 90 FF            [ 2]  640         LDW (Y),X
      00AF9D 85               [ 2]  641         POPW X 
      00032C                        642         _DROPN DBL_SIZE  
      00AF9E 1C 00 08         [ 2]    1     ADDW X,#DBL_SIZE*CELLL 
      00AFA1 81               [ 4]  643         RET 
                                    644 
                                    645 
                                    646 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    647 ;       >R      ( w -- )
                                    648 ;       Push data stack to return stack.
                                    649 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000330                        650         _HEADER TOR,COMPO+2,">R"
      00AFA2 AF 7F                    1         .word LINK 
                           000332     2         LINK=.
      00AFA4 42                       3         .byte COMPO+2  
      00AFA5 3E 52                    4         .ascii ">R"
      00AFA7                          5         TOR:
      00AFA7 90 85            [ 2]  651         POPW Y    ;save return addr
      00AFA9 90 BF 48         [ 2]  652         LDW YTEMP,Y
      00AFAC 90 93            [ 1]  653         LDW Y,X
      00AFAE 90 FE            [ 2]  654         LDW Y,(Y)  ; W
      00AFB0 90 89            [ 2]  655         PUSHW Y    ;W >R 
      00AFB2 1C 00 02         [ 2]  656         ADDW X,#2
      00AFB5 92 CC 48         [ 5]  657         JP [YTEMP]
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 57.
Hexadecimal [24-Bits]



                                    658 
                                    659 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    660 ;       SP@     ( -- a )
                                    661 ;       Push current stack pointer.
                                    662 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000346                        663         _HEADER SPAT,3,"SP@"
      00AFB8 AF A4                    1         .word LINK 
                           000348     2         LINK=.
      00AFBA 03                       3         .byte 3  
      00AFBB 53 50 40                 4         .ascii "SP@"
      00AFBE                          5         SPAT:
      00AFBE 90 93            [ 1]  664 	LDW Y,X
      00AFC0 1D 00 02         [ 2]  665         SUBW X,#2
      00AFC3 FF               [ 2]  666 	LDW (X),Y
      00AFC4 81               [ 4]  667         RET     
                                    668 
                                    669 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    670 ;       SP!     ( a -- )
                                    671 ;       Set  data stack pointer.
                                    672 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000353                        673         _HEADER SPSTO,3,"SP!"
      00AFC5 AF BA                    1         .word LINK 
                           000355     2         LINK=.
      00AFC7 03                       3         .byte 3  
      00AFC8 53 50 21                 4         .ascii "SP!"
      00AFCB                          5         SPSTO:
      00AFCB FE               [ 2]  674         LDW     X,(X)     ;X = a
      00AFCC 81               [ 4]  675         RET     
                                    676 
                                    677 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    678 ;       DROP    ( w -- )
                                    679 ;       Discard top stack item.
                                    680 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00035B                        681         _HEADER DROP,4,"DROP"
      00AFCD AF C7                    1         .word LINK 
                           00035D     2         LINK=.
      00AFCF 04                       3         .byte 4  
      00AFD0 44 52 4F 50              4         .ascii "DROP"
      00AFD4                          5         DROP:
      00AFD4 1C 00 02         [ 2]  682         ADDW X,#2     
      00AFD7 81               [ 4]  683         RET     
                                    684 
                                    685 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    686 ;       DUP     ( w -- w w )
                                    687 ;       Duplicate  top stack item.
                                    688 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000366                        689         _HEADER DUPP,3,"DUP"
      00AFD8 AF CF                    1         .word LINK 
                           000368     2         LINK=.
      00AFDA 03                       3         .byte 3  
      00AFDB 44 55 50                 4         .ascii "DUP"
      00AFDE                          5         DUPP:
      00AFDE 90 93            [ 1]  690 	LDW Y,X
      00AFE0 1D 00 02         [ 2]  691         SUBW X,#2
      00AFE3 90 FE            [ 2]  692 	LDW Y,(Y)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 58.
Hexadecimal [24-Bits]



      00AFE5 FF               [ 2]  693 	LDW (X),Y
      00AFE6 81               [ 4]  694         RET     
                                    695 
                                    696 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    697 ;       SWAP    ( w1 w2 -- w2 w1 )
                                    698 ;       Exchange top two stack items.
                                    699 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000375                        700         _HEADER SWAPP,4,"SWAP"
      00AFE7 AF DA                    1         .word LINK 
                           000377     2         LINK=.
      00AFE9 04                       3         .byte 4  
      00AFEA 53 57 41 50              4         .ascii "SWAP"
      00AFEE                          5         SWAPP:
      00AFEE 90 93            [ 1]  701         LDW Y,X
      00AFF0 90 FE            [ 2]  702         LDW Y,(Y)
      00AFF2 90 89            [ 2]  703         PUSHW Y  
      00AFF4 90 93            [ 1]  704         LDW Y,X
      00AFF6 90 EE 02         [ 2]  705         LDW Y,(2,Y)
      00AFF9 FF               [ 2]  706         LDW (X),Y
      00AFFA 90 85            [ 2]  707         POPW Y 
      00AFFC EF 02            [ 2]  708         LDW (2,X),Y
      00AFFE 81               [ 4]  709         RET     
                                    710 
                                    711 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    712 ;       OVER    ( w1 w2 -- w1 w2 w1 )
                                    713 ;       Copy second stack item to top.
                                    714 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00038D                        715         _HEADER OVER,4,"OVER"
      00AFFF AF E9                    1         .word LINK 
                           00038F     2         LINK=.
      00B001 04                       3         .byte 4  
      00B002 4F 56 45 52              4         .ascii "OVER"
      00B006                          5         OVER:
      00B006 1D 00 02         [ 2]  716         SUBW X,#2
      00B009 90 93            [ 1]  717         LDW Y,X
      00B00B 90 EE 04         [ 2]  718         LDW Y,(4,Y)
      00B00E FF               [ 2]  719         LDW (X),Y
      00B00F 81               [ 4]  720         RET     
                                    721 
                                    722 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    723 ;       0<      ( n -- t )
                                    724 ;       Return true if n is negative.
                                    725 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00039E                        726         _HEADER ZLESS,2,"0<"
      00B010 B0 01                    1         .word LINK 
                           0003A0     2         LINK=.
      00B012 02                       3         .byte 2  
      00B013 30 3C                    4         .ascii "0<"
      00B015                          5         ZLESS:
      00B015 A6 FF            [ 1]  727         LD A,#0xFF
      00B017 90 93            [ 1]  728         LDW Y,X
      00B019 90 FE            [ 2]  729         LDW Y,(Y)
      00B01B 2B 01            [ 1]  730         JRMI     ZL1
      00B01D 4F               [ 1]  731         CLR A   ;false
      00B01E F7               [ 1]  732 ZL1:    LD     (X),A
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 59.
Hexadecimal [24-Bits]



      00B01F E7 01            [ 1]  733         LD (1,X),A
      00B021 81               [ 4]  734 	RET     
                                    735 
                                    736 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    737 ;       0= ( n -- f )
                                    738 ;   n==0?
                                    739 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0003B0                        740         _HEADER ZEQUAL,2,"0="
      00B022 B0 12                    1         .word LINK 
                           0003B2     2         LINK=.
      00B024 02                       3         .byte 2  
      00B025 30 3D                    4         .ascii "0="
      00B027                          5         ZEQUAL:
      00B027 A6 FF            [ 1]  741         LD A,#0XFF 
      00B029 90 93            [ 1]  742         LDW Y,X 
      00B02B 90 FE            [ 2]  743         LDW Y,(Y)
      00B02D 27 02            [ 1]  744         JREQ ZEQU1 
      00B02F A6 00            [ 1]  745         LD A,#0 
      00B031                        746 ZEQU1:  
      00B031 F7               [ 1]  747         LD (X),A 
      00B032 E7 01            [ 1]  748         LD (1,X),A         
      00B034 81               [ 4]  749         RET 
                                    750 
                                    751 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    752 ;       AND     ( w w -- w )
                                    753 ;       Bitwise AND.
                                    754 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0003C3                        755         _HEADER ANDD,3,"AND"
      00B035 B0 24                    1         .word LINK 
                           0003C5     2         LINK=.
      00B037 03                       3         .byte 3  
      00B038 41 4E 44                 4         .ascii "AND"
      00B03B                          5         ANDD:
      00B03B F6               [ 1]  756         LD  A,(X)    ;D=w
      00B03C E4 02            [ 1]  757         AND A,(2,X)
      00B03E E7 02            [ 1]  758         LD (2,X),A
      00B040 E6 01            [ 1]  759         LD A,(1,X)
      00B042 E4 03            [ 1]  760         AND A,(3,X)
      00B044 E7 03            [ 1]  761         LD (3,X),A
      00B046 1C 00 02         [ 2]  762         ADDW X,#2
      00B049 81               [ 4]  763         RET
                                    764 
                                    765 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    766 ;       OR      ( w w -- w )
                                    767 ;       Bitwise inclusive OR.
                                    768 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0003D8                        769         _HEADER ORR,2,"OR"
      00B04A B0 37                    1         .word LINK 
                           0003DA     2         LINK=.
      00B04C 02                       3         .byte 2  
      00B04D 4F 52                    4         .ascii "OR"
      00B04F                          5         ORR:
      00B04F F6               [ 1]  770         LD A,(X)    ;D=w
      00B050 EA 02            [ 1]  771         OR A,(2,X)
      00B052 E7 02            [ 1]  772         LD (2,X),A
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 60.
Hexadecimal [24-Bits]



      00B054 E6 01            [ 1]  773         LD A,(1,X)
      00B056 EA 03            [ 1]  774         OR A,(3,X)
      00B058 E7 03            [ 1]  775         LD (3,X),A
      00B05A 1C 00 02         [ 2]  776         ADDW X,#2
      00B05D 81               [ 4]  777         RET
                                    778 
                                    779 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    780 ;       XOR     ( w w -- w )
                                    781 ;       Bitwise exclusive OR.
                                    782 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0003EC                        783         _HEADER XORR,3,"XOR"
      00B05E B0 4C                    1         .word LINK 
                           0003EE     2         LINK=.
      00B060 03                       3         .byte 3  
      00B061 58 4F 52                 4         .ascii "XOR"
      00B064                          5         XORR:
      00B064 F6               [ 1]  784         LD A,(X)    ;D=w
      00B065 E8 02            [ 1]  785         XOR A,(2,X)
      00B067 E7 02            [ 1]  786         LD (2,X),A
      00B069 E6 01            [ 1]  787         LD A,(1,X)
      00B06B E8 03            [ 1]  788         XOR A,(3,X)
      00B06D E7 03            [ 1]  789         LD (3,X),A
      00B06F 1C 00 02         [ 2]  790         ADDW X,#2
      00B072 81               [ 4]  791         RET
                                    792 
                                    793 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    794 ;       UM+     ( u u -- udsum )
                                    795 ;       Add two unsigned single
                                    796 ;       and return a double sum.
                                    797 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000401                        798         _HEADER UPLUS,3,"UM+"
      00B073 B0 60                    1         .word LINK 
                           000403     2         LINK=.
      00B075 03                       3         .byte 3  
      00B076 55 4D 2B                 4         .ascii "UM+"
      00B079                          5         UPLUS:
      00B079 A6 01            [ 1]  799         LD A,#1
      00B07B 90 93            [ 1]  800         LDW Y,X
      00B07D 90 EE 02         [ 2]  801         LDW Y,(2,Y)
      00B080 90 BF 48         [ 2]  802         LDW YTEMP,Y
      00B083 90 93            [ 1]  803         LDW Y,X
      00B085 90 FE            [ 2]  804         LDW Y,(Y)
      00B087 72 B9 00 48      [ 2]  805         ADDW Y,YTEMP
      00B08B EF 02            [ 2]  806         LDW (2,X),Y
      00B08D 25 01            [ 1]  807         JRC     UPL1
      00B08F 4F               [ 1]  808         CLR A
      00B090 E7 01            [ 1]  809 UPL1:   LD     (1,X),A
      00B092 7F               [ 1]  810         CLR (X)
      00B093 81               [ 4]  811         RET
                                    812 
                                    813 ;; System and user variables
                                    814 
                                    815 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    816 ;       doVAR   ( -- a )
                                    817 ;       run time code 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 61.
Hexadecimal [24-Bits]



                                    818 ;       for VARIABLE and CREATE.
                                    819 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    820 ;       HEADER DOVAR,COMPO+5,"DOVAR"
      00B094                        821 DOVAR:
      00B094 1D 00 02         [ 2]  822 	SUBW X,#2
      00B097 90 85            [ 2]  823         POPW Y    ;get return addr (pfa)
                                    824 ;        LDW Y,(Y) ; indirect address 
      00B099 FF               [ 2]  825         LDW (X),Y    ;push on stack
      00B09A 81               [ 4]  826         RET     ;go to RET of EXEC
                                    827 
                                    828 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    829 ;       BASE    ( -- a )
                                    830 ;       Radix base for numeric I/O.
                                    831 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000429                        832         _HEADER BASE,4,"BASE"
      00B09B B0 75                    1         .word LINK 
                           00042B     2         LINK=.
      00B09D 04                       3         .byte 4  
      00B09E 42 41 53 45              4         .ascii "BASE"
      00B0A2                          5         BASE:
      00B0A2 90 AE 00 30      [ 2]  833 	LDW Y,#UBASE 
      00B0A6 1D 00 02         [ 2]  834 	SUBW X,#2
      00B0A9 FF               [ 2]  835         LDW (X),Y
      00B0AA 81               [ 4]  836         RET
                                    837 
                                    838 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    839 ;       tmp     ( -- a )
                                    840 ;       A temporary storage.
                                    841 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000439                        842         _HEADER TEMP,3,"TMP"
      00B0AB B0 9D                    1         .word LINK 
                           00043B     2         LINK=.
      00B0AD 03                       3         .byte 3  
      00B0AE 54 4D 50                 4         .ascii "TMP"
      00B0B1                          5         TEMP:
      00B0B1 90 AE 00 34      [ 2]  843 	LDW Y,#UTMP
      00B0B5 1D 00 02         [ 2]  844 	SUBW X,#2
      00B0B8 FF               [ 2]  845         LDW (X),Y
      00B0B9 81               [ 4]  846         RET
                                    847 
                                    848 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    849 ;       >IN     ( -- a )
                                    850 ;        Hold parsing pointer.
                                    851 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000448                        852         _HEADER INN,3,">IN"
      00B0BA B0 AD                    1         .word LINK 
                           00044A     2         LINK=.
      00B0BC 03                       3         .byte 3  
      00B0BD 3E 49 4E                 4         .ascii ">IN"
      00B0C0                          5         INN:
      00B0C0 90 AE 00 36      [ 2]  853 	LDW Y,#UINN 
      00B0C4 1D 00 02         [ 2]  854 	SUBW X,#2
      00B0C7 FF               [ 2]  855         LDW (X),Y
      00B0C8 81               [ 4]  856         RET
                                    857 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 62.
Hexadecimal [24-Bits]



                                    858 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    859 ;       #TIB    ( -- a )
                                    860 ;       Count in terminal input 
                                    861 ;       buffer.
                                    862 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000457                        863         _HEADER NTIB,4,"#TIB"
      00B0C9 B0 BC                    1         .word LINK 
                           000459     2         LINK=.
      00B0CB 04                       3         .byte 4  
      00B0CC 23 54 49 42              4         .ascii "#TIB"
      00B0D0                          5         NTIB:
      00B0D0 90 AE 00 38      [ 2]  864 	LDW Y,#UCTIB 
      00B0D4 1D 00 02         [ 2]  865 	SUBW X,#2
      00B0D7 FF               [ 2]  866         LDW (X),Y
      00B0D8 81               [ 4]  867         RET
                                    868 
                                    869 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    870 ;       TBUF ( -- a )
                                    871 ;       address of 128 bytes 
                                    872 ;       transaction buffer
                                    873 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000467                        874         _HEADER TBUF,4,"TBUF"
      00B0D9 B0 CB                    1         .word LINK 
                           000469     2         LINK=.
      00B0DB 04                       3         .byte 4  
      00B0DC 54 42 55 46              4         .ascii "TBUF"
      00B0E0                          5         TBUF:
      00B0E0 90 AE 16 80      [ 2]  875         ldw y,#ROWBUFF
      00B0E4 1D 00 02         [ 2]  876         subw x,#CELLL
      00B0E7 FF               [ 2]  877         ldw (x),y 
      00B0E8 81               [ 4]  878         ret 
                                    879 
                                    880 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    881 ;       "EVAL   ( -- a )
                                    882 ;       Execution vector of EVAL.
                                    883 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000477                        884         _HEADER TEVAL,5,"'EVAL"
      00B0E9 B0 DB                    1         .word LINK 
                           000479     2         LINK=.
      00B0EB 05                       3         .byte 5  
      00B0EC 27 45 56 41 4C           4         .ascii "'EVAL"
      00B0F1                          5         TEVAL:
      00B0F1 90 AE 00 3C      [ 2]  885 	LDW Y,#UINTER 
      00B0F5 1D 00 02         [ 2]  886 	SUBW X,#2
      00B0F8 FF               [ 2]  887         LDW (X),Y
      00B0F9 81               [ 4]  888         RET
                                    889 
                                    890 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    891 ;       HLD     ( -- a )
                                    892 ;       Hold a pointer of output
                                    893 ;        string.
                                    894 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000488                        895         _HEADER HLD,3,"HLD"
      00B0FA B0 EB                    1         .word LINK 
                           00048A     2         LINK=.
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 63.
Hexadecimal [24-Bits]



      00B0FC 03                       3         .byte 3  
      00B0FD 48 4C 44                 4         .ascii "HLD"
      00B100                          5         HLD:
      00B100 90 AE 00 3E      [ 2]  896 	LDW Y,#UHLD 
      00B104 1D 00 02         [ 2]  897 	SUBW X,#2
      00B107 FF               [ 2]  898         LDW (X),Y
      00B108 81               [ 4]  899         RET
                                    900 
                                    901 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    902 ;       CONTEXT ( -- a )
                                    903 ;       Start vocabulary search.
                                    904 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000497                        905         _HEADER CNTXT,7,"CONTEXT"
      00B109 B0 FC                    1         .word LINK 
                           000499     2         LINK=.
      00B10B 07                       3         .byte 7  
      00B10C 43 4F 4E 54 45 58 54     4         .ascii "CONTEXT"
      00B113                          5         CNTXT:
      00B113 90 AE 00 40      [ 2]  906 	LDW Y,#UCNTXT
      00B117 1D 00 02         [ 2]  907 	SUBW X,#2
      00B11A FF               [ 2]  908         LDW (X),Y
      00B11B 81               [ 4]  909         RET
                                    910 
                                    911 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    912 ;       VP      ( -- a )
                                    913 ;       Point to top of variables
                                    914 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0004AA                        915         _HEADER VPP,2,"VP"
      00B11C B1 0B                    1         .word LINK 
                           0004AC     2         LINK=.
      00B11E 02                       3         .byte 2  
      00B11F 56 50                    4         .ascii "VP"
      00B121                          5         VPP:
      00B121 90 AE 00 44      [ 2]  916 	LDW Y,#UVP 
      00B125 1D 00 02         [ 2]  917 	SUBW X,#2
      00B128 FF               [ 2]  918         LDW (X),Y
      00B129 81               [ 4]  919         RET
                                    920 
                                    921 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    922 ;       LAST    ( -- a )
                                    923 ;       Point to last name in 
                                    924 ;       dictionary.
                                    925 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0004B8                        926         _HEADER LAST,4,"LAST"
      00B12A B1 1E                    1         .word LINK 
                           0004BA     2         LINK=.
      00B12C 04                       3         .byte 4  
      00B12D 4C 41 53 54              4         .ascii "LAST"
      00B131                          5         LAST:
      00B131 90 AE 00 42      [ 2]  927 	LDW Y,#ULAST 
      00B135 1D 00 02         [ 2]  928 	SUBW X,#2
      00B138 FF               [ 2]  929         LDW (X),Y
      00B139 81               [ 4]  930         RET
                                    931 
                                    932 ;; Common functions
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 64.
Hexadecimal [24-Bits]



                                    933 
                                    934 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    935 ;       ?DUP    ( w -- w w | 0 )
                                    936 ;       Dup tos if its is not zero.
                                    937 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0004C8                        938         _HEADER QDUP,4,"?DUP"
      00B13A B1 2C                    1         .word LINK 
                           0004CA     2         LINK=.
      00B13C 04                       3         .byte 4  
      00B13D 3F 44 55 50              4         .ascii "?DUP"
      00B141                          5         QDUP:
      00B141 90 93            [ 1]  939         LDW Y,X
      00B143 90 FE            [ 2]  940 	LDW Y,(Y)
      00B145 27 04            [ 1]  941         JREQ     QDUP1
      00B147 1D 00 02         [ 2]  942 	SUBW X,#CELLL 
      00B14A FF               [ 2]  943         LDW (X),Y
      00B14B 81               [ 4]  944 QDUP1:  RET
                                    945 
                                    946 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    947 ;       ROT     ( w1 w2 w3 -- w2 w3 w1 )
                                    948 ;       Rot 3rd item to top.
                                    949 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0004DA                        950         _HEADER ROT,3,"ROT"
      00B14C B1 3C                    1         .word LINK 
                           0004DC     2         LINK=.
      00B14E 03                       3         .byte 3  
      00B14F 52 4F 54                 4         .ascii "ROT"
      00B152                          5         ROT:
      00B152 90 93            [ 1]  951         ldw y,x 
      00B154 90 FE            [ 2]  952         ldw y,(y)
      00B156 90 89            [ 2]  953         pushw y 
      00B158 90 93            [ 1]  954         ldw y,x 
      00B15A 90 EE 04         [ 2]  955         ldw y,(4,y)
      00B15D FF               [ 2]  956         ldw (x),y 
      00B15E 90 93            [ 1]  957         ldw y,x 
      00B160 90 EE 02         [ 2]  958         ldw y,(2,y)
      00B163 EF 04            [ 2]  959         ldw (4,x),y 
      00B165 90 85            [ 2]  960         popw y 
      00B167 EF 02            [ 2]  961         ldw (2,x),y
      00B169 81               [ 4]  962         ret 
                                    963 
                                    964 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    965 ;    <ROT ( n1 n2 n3 -- n3 n1 n2 )
                                    966 ;    rotate left 3 top elements 
                                    967 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0004F8                        968     _HEADER NROT,4,"<ROT"
      00B16A B1 4E                    1         .word LINK 
                           0004FA     2         LINK=.
      00B16C 04                       3         .byte 4  
      00B16D 3C 52 4F 54              4         .ascii "<ROT"
      00B171                          5         NROT:
      00B171 90 93            [ 1]  969     LDW Y,X 
      00B173 90 FE            [ 2]  970     LDW Y,(Y)
      00B175 90 89            [ 2]  971     PUSHW Y ; n3 >R 
      00B177 90 93            [ 1]  972     LDW Y,X 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 65.
Hexadecimal [24-Bits]



      00B179 90 EE 02         [ 2]  973     LDW Y,(2,Y) ; Y = n2 
      00B17C FF               [ 2]  974     LDW (X),Y   ; TOS = n2 
      00B17D 90 93            [ 1]  975     LDW Y,X    
      00B17F 90 EE 04         [ 2]  976     LDW Y,(4,Y) ; Y = n1 
      00B182 EF 02            [ 2]  977     LDW (2,X),Y ;   = n1 
      00B184 90 85            [ 2]  978     POPW Y  ; R> Y 
      00B186 EF 04            [ 2]  979     LDW (4,X),Y ; = n3 
      00B188 81               [ 4]  980     RET 
                                    981 
                                    982 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    983 ;       2DROP   ( w w -- )
                                    984 ;       Discard two items on stack.
                                    985 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000517                        986         _HEADER DDROP,5,"2DROP"
      00B189 B1 6C                    1         .word LINK 
                           000519     2         LINK=.
      00B18B 05                       3         .byte 5  
      00B18C 32 44 52 4F 50           4         .ascii "2DROP"
      00B191                          5         DDROP:
      00B191 1C 00 04         [ 2]  987         ADDW X,#4
      00B194 81               [ 4]  988         RET
                                    989 
                                    990 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    991 ;       2DUP    ( w1 w2 -- w1 w2 w1 w2 )
                                    992 ;       Duplicate top two items.
                                    993 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000523                        994         _HEADER DDUP,4,"2DUP"
      00B195 B1 8B                    1         .word LINK 
                           000525     2         LINK=.
      00B197 04                       3         .byte 4  
      00B198 32 44 55 50              4         .ascii "2DUP"
      00B19C                          5         DDUP:
      00B19C 1D 00 04         [ 2]  995         SUBW X,#2*CELLL 
      00B19F 90 93            [ 1]  996         LDW Y,X
      00B1A1 90 EE 06         [ 2]  997         LDW Y,(3*CELLL,Y)
      00B1A4 EF 02            [ 2]  998         LDW (CELLL,X),Y
      00B1A6 90 93            [ 1]  999         LDW Y,X
      00B1A8 90 EE 04         [ 2] 1000         LDW Y,(2*CELLL,Y)
      00B1AB FF               [ 2] 1001         LDW (X),Y
      00B1AC 81               [ 4] 1002         RET
                                   1003 
                                   1004 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1005 ;       +       ( w w -- sum )
                                   1006 ;       Add top two items.
                                   1007 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00053B                       1008         _HEADER PLUS,1,"+"
      00B1AD B1 97                    1         .word LINK 
                           00053D     2         LINK=.
      00B1AF 01                       3         .byte 1  
      00B1B0 2B                       4         .ascii "+"
      00B1B1                          5         PLUS:
      00B1B1 90 93            [ 1] 1009         LDW Y,X
      00B1B3 90 FE            [ 2] 1010         LDW Y,(Y)
      00B1B5 90 BF 48         [ 2] 1011         LDW YTEMP,Y
      00B1B8 1C 00 02         [ 2] 1012         ADDW X,#2
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 66.
Hexadecimal [24-Bits]



      00B1BB 90 93            [ 1] 1013         LDW Y,X
      00B1BD 90 FE            [ 2] 1014         LDW Y,(Y)
      00B1BF 72 B9 00 48      [ 2] 1015         ADDW Y,YTEMP
      00B1C3 FF               [ 2] 1016         LDW (X),Y
      00B1C4 81               [ 4] 1017         RET
                                   1018 
                                   1019 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1020 ;       TRUE ( -- -1 )
                                   1021 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000553                       1022         _HEADER TRUE,4,"TRUE"
      00B1C5 B1 AF                    1         .word LINK 
                           000555     2         LINK=.
      00B1C7 04                       3         .byte 4  
      00B1C8 54 52 55 45              4         .ascii "TRUE"
      00B1CC                          5         TRUE:
      00B1CC A6 FF            [ 1] 1023         LD A,#255 
      00B1CE 1D 00 02         [ 2] 1024         SUBW X,#CELLL
      00B1D1 F7               [ 1] 1025         LD (X),A 
      00B1D2 E7 01            [ 1] 1026         LD (1,X),A 
      00B1D4 81               [ 4] 1027         RET 
                                   1028 
                                   1029 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1030 ;       FALSE ( -- 0 )
                                   1031 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000563                       1032         _HEADER FALSE,5,"FALSE"
      00B1D5 B1 C7                    1         .word LINK 
                           000565     2         LINK=.
      00B1D7 05                       3         .byte 5  
      00B1D8 46 41 4C 53 45           4         .ascii "FALSE"
      00B1DD                          5         FALSE:
      00B1DD 1D 00 02         [ 2] 1033         SUBW X,#CELLL 
      00B1E0 7F               [ 1] 1034         CLR (X) 
      00B1E1 6F 01            [ 1] 1035         CLR (1,X)
      00B1E3 81               [ 4] 1036         RET 
                                   1037 
                                   1038 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1039 ;       NOT     ( w -- w )
                                   1040 ;       One's complement of tos.
                                   1041 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000572                       1042         _HEADER INVER,3,"NOT"
      00B1E4 B1 D7                    1         .word LINK 
                           000574     2         LINK=.
      00B1E6 03                       3         .byte 3  
      00B1E7 4E 4F 54                 4         .ascii "NOT"
      00B1EA                          5         INVER:
      00B1EA 90 93            [ 1] 1043         LDW Y,X
      00B1EC 90 FE            [ 2] 1044         LDW Y,(Y)
      00B1EE 90 53            [ 2] 1045         CPLW Y
      00B1F0 FF               [ 2] 1046         LDW (X),Y
      00B1F1 81               [ 4] 1047         RET
                                   1048 
                                   1049 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1050 ;       NEGATE  ( n -- -n )
                                   1051 ;       Two's complement of tos.
                                   1052 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 67.
Hexadecimal [24-Bits]



      000580                       1053         _HEADER NEGAT,6,"NEGATE"
      00B1F2 B1 E6                    1         .word LINK 
                           000582     2         LINK=.
      00B1F4 06                       3         .byte 6  
      00B1F5 4E 45 47 41 54 45        4         .ascii "NEGATE"
      00B1FB                          5         NEGAT:
      00B1FB 90 93            [ 1] 1054         LDW Y,X
      00B1FD 90 FE            [ 2] 1055         LDW Y,(Y)
      00B1FF 90 50            [ 2] 1056         NEGW Y
      00B201 FF               [ 2] 1057         LDW (X),Y
      00B202 81               [ 4] 1058         RET
                                   1059 
                                   1060 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1061 ;       DNEGATE ( d -- -d )
                                   1062 ;       Two's complement of double.
                                   1063 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000591                       1064         _HEADER DNEGA,7,"DNEGATE"
      00B203 B1 F4                    1         .word LINK 
                           000593     2         LINK=.
      00B205 07                       3         .byte 7  
      00B206 44 4E 45 47 41 54 45     4         .ascii "DNEGATE"
      00B20D                          5         DNEGA:
      00B20D 90 93            [ 1] 1065         LDW Y,X
      00B20F 90 FE            [ 2] 1066 	LDW Y,(Y)
      00B211 90 53            [ 2] 1067         CPLW Y
      00B213 90 89            [ 2] 1068         PUSHW Y      ; Y >R 
      00B215 90 93            [ 1] 1069         LDW Y,X
      00B217 90 EE 02         [ 2] 1070         LDW Y,(2,Y)
      00B21A 90 53            [ 2] 1071         CPLW Y
      00B21C 72 A9 00 01      [ 2] 1072         ADDW Y,#1
      00B220 EF 02            [ 2] 1073         LDW (2,X),Y
      00B222 90 85            [ 2] 1074         POPW Y       ; R> Y  
      00B224 24 02            [ 1] 1075         JRNC DN1 
      00B226 90 5C            [ 1] 1076         INCW Y
      00B228 FF               [ 2] 1077 DN1:    LDW (X),Y
      00B229 81               [ 4] 1078         RET
                                   1079 
                                   1080 
                                   1081 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1082 ;       S>D ( n -- d )
                                   1083 ; convert single integer to double 
                                   1084 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0005B8                       1085         _HEADER STOD,3,"S>D"
      00B22A B2 05                    1         .word LINK 
                           0005BA     2         LINK=.
      00B22C 03                       3         .byte 3  
      00B22D 53 3E 44                 4         .ascii "S>D"
      00B230                          5         STOD:
      00B230 1D 00 02         [ 2] 1086         SUBW X,#CELLL 
      00B233 7F               [ 1] 1087         CLR (X) 
      00B234 6F 01            [ 1] 1088         CLR (1,X) 
      00B236 90 93            [ 1] 1089         LDW Y,X 
      00B238 90 EE 02         [ 2] 1090         LDW Y,(2,Y)
      00B23B 2A 05            [ 1] 1091         JRPL 1$
      00B23D 90 AE FF FF      [ 2] 1092         LDW Y,#-1 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 68.
Hexadecimal [24-Bits]



      00B241 FF               [ 2] 1093         LDW (X),Y 
      00B242 81               [ 4] 1094 1$:     RET 
                                   1095 
                                   1096 
                                   1097 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1098 ;       -       ( n1 n2 -- n1-n2 )
                                   1099 ;       Subtraction.
                                   1100 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0005D1                       1101         _HEADER SUBB,1,"-"
      00B243 B2 2C                    1         .word LINK 
                           0005D3     2         LINK=.
      00B245 01                       3         .byte 1  
      00B246 2D                       4         .ascii "-"
      00B247                          5         SUBB:
      00B247 90 93            [ 1] 1102         LDW Y,X
      00B249 90 FE            [ 2] 1103         LDW Y,(Y) ; n2 
      00B24B 90 BF 48         [ 2] 1104         LDW YTEMP,Y 
      00B24E 1C 00 02         [ 2] 1105         ADDW X,#CELLL 
      00B251 90 93            [ 1] 1106         LDW Y,X
      00B253 90 FE            [ 2] 1107         LDW Y,(Y) ; n1 
      00B255 72 B2 00 48      [ 2] 1108         SUBW Y,YTEMP ; n1-n2 
      00B259 FF               [ 2] 1109         LDW (X),Y
      00B25A 81               [ 4] 1110         RET
                                   1111 
                                   1112 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1113 ;       ABS     ( n -- n )
                                   1114 ;       Return  absolute value of n.
                                   1115 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0005E9                       1116         _HEADER ABSS,3,"ABS"
      00B25B B2 45                    1         .word LINK 
                           0005EB     2         LINK=.
      00B25D 03                       3         .byte 3  
      00B25E 41 42 53                 4         .ascii "ABS"
      00B261                          5         ABSS:
      00B261 90 93            [ 1] 1117         LDW Y,X
      00B263 90 FE            [ 2] 1118 	LDW Y,(Y)
      00B265 2A 03            [ 1] 1119         JRPL     AB1     ;negate:
      00B267 90 50            [ 2] 1120         NEGW     Y     ;else negate hi byte
      00B269 FF               [ 2] 1121         LDW (X),Y
      00B26A 81               [ 4] 1122 AB1:    RET
                                   1123 
                                   1124 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1125 ;       =       ( w w -- t )
                                   1126 ;       Return true if top two are equal.
                                   1127 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0005F9                       1128         _HEADER EQUAL,1,"="
      00B26B B2 5D                    1         .word LINK 
                           0005FB     2         LINK=.
      00B26D 01                       3         .byte 1  
      00B26E 3D                       4         .ascii "="
      00B26F                          5         EQUAL:
      00B26F A6 FF            [ 1] 1129         LD A,#0xFF  ;true
      00B271 90 93            [ 1] 1130         LDW Y,X    
      00B273 90 FE            [ 2] 1131         LDW Y,(Y)   ; n2 
      00B275 1C 00 02         [ 2] 1132         ADDW X,#CELLL 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 69.
Hexadecimal [24-Bits]



      00B278 F3               [ 2] 1133         CPW Y,(X)   ; n1==n2
      00B279 27 01            [ 1] 1134         JREQ EQ1 
      00B27B 4F               [ 1] 1135         CLR A 
      00B27C F7               [ 1] 1136 EQ1:    LD (X),A
      00B27D E7 01            [ 1] 1137         LD (1,X),A
      00B27F 81               [ 4] 1138 	RET     
                                   1139 
                                   1140 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1141 ;       U<      ( u1 u2 -- f )
                                   1142 ;       Unsigned compare of top two items.
                                   1143 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00060E                       1144         _HEADER ULESS,2,"U<"
      00B280 B2 6D                    1         .word LINK 
                           000610     2         LINK=.
      00B282 02                       3         .byte 2  
      00B283 55 3C                    4         .ascii "U<"
      00B285                          5         ULESS:
      00B285 A6 FF            [ 1] 1145         LD A,#0xFF  ;true
      00B287 90 93            [ 1] 1146         LDW Y,X    
      00B289 90 EE 02         [ 2] 1147         LDW Y,(2,Y) ; u1 
      00B28C F3               [ 2] 1148         CPW Y,(X)   ; cpw u1  u2 
      00B28D 25 01            [ 1] 1149         JRULT     ULES1
      00B28F 4F               [ 1] 1150         CLR A
      00B290 1C 00 02         [ 2] 1151 ULES1:  ADDW X,#CELLL 
      00B293 F7               [ 1] 1152         LD (X),A
      00B294 E7 01            [ 1] 1153         LD (1,X),A
      00B296 81               [ 4] 1154 	RET     
                                   1155 
                                   1156 
                                   1157 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1158 ;       <       ( n1 n2 -- t )
                                   1159 ;       Signed compare of top two items.
                                   1160 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000625                       1161         _HEADER LESS,1,"<"
      00B297 B2 82                    1         .word LINK 
                           000627     2         LINK=.
      00B299 01                       3         .byte 1  
      00B29A 3C                       4         .ascii "<"
      00B29B                          5         LESS:
      00B29B A6 FF            [ 1] 1162         LD A,#0xFF  ;true
      00B29D 90 93            [ 1] 1163         LDW Y,X    
      00B29F 90 EE 02         [ 2] 1164         LDW Y,(2,Y)  ; n1 
      00B2A2 F3               [ 2] 1165         CPW Y,(X)  ; n1 < n2 ? 
      00B2A3 2F 01            [ 1] 1166         JRSLT     LT1
      00B2A5 4F               [ 1] 1167         CLR A
      00B2A6 1C 00 02         [ 2] 1168 LT1:    ADDW X,#CELLL 
      00B2A9 F7               [ 1] 1169         LD (X),A
      00B2AA E7 01            [ 1] 1170         LD (1,X),A
      00B2AC 81               [ 4] 1171 	RET     
                                   1172 
                                   1173 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1174 ;   U> ( u1 u2 -- f )
                                   1175 ;   f = true if u1>u2 
                                   1176 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00063B                       1177         _HEADER UGREAT,2,"U>"
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 70.
Hexadecimal [24-Bits]



      00B2AD B2 99                    1         .word LINK 
                           00063D     2         LINK=.
      00B2AF 02                       3         .byte 2  
      00B2B0 55 3E                    4         .ascii "U>"
      00B2B2                          5         UGREAT:
      00B2B2 A6 FF            [ 1] 1178         LD A,#255  
      00B2B4 90 93            [ 1] 1179         LDW Y,X 
      00B2B6 90 EE 02         [ 2] 1180         LDW Y,(2,Y)  ; u1 
      00B2B9 F3               [ 2] 1181         CPW Y,(X)  ; u1 > u2 
      00B2BA 22 01            [ 1] 1182         JRUGT UGREAT1 
      00B2BC 4F               [ 1] 1183         CLR A   
      00B2BD                       1184 UGREAT1:
      00B2BD 1C 00 02         [ 2] 1185         ADDW X,#CELLL 
      00B2C0 F7               [ 1] 1186         LD (X),A 
      00B2C1 E7 01            [ 1] 1187         LD (1,X),A 
      00B2C3 81               [ 4] 1188         RET 
                                   1189 
                                   1190 
                                   1191 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1192 ;       >   (n1 n2 -- f )
                                   1193 ;  signed compare n1 n2 
                                   1194 ;  true if n1 > n2 
                                   1195 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000652                       1196         _HEADER GREAT,1,">"
      00B2C4 B2 AF                    1         .word LINK 
                           000654     2         LINK=.
      00B2C6 01                       3         .byte 1  
      00B2C7 3E                       4         .ascii ">"
      00B2C8                          5         GREAT:
      00B2C8 A6 FF            [ 1] 1197         LD A,#0xFF ;
      00B2CA 90 93            [ 1] 1198         LDW Y,X 
      00B2CC 90 EE 02         [ 2] 1199         LDW Y,(2,Y)  ; n1 
      00B2CF F3               [ 2] 1200         CPW Y,(X) ; n1 > n2 ?  
      00B2D0 2C 01            [ 1] 1201         JRSGT GREAT1 
      00B2D2 4F               [ 1] 1202         CLR  A
      00B2D3                       1203 GREAT1:
      00B2D3 1C 00 02         [ 2] 1204         ADDW X,#CELLL 
      00B2D6 F7               [ 1] 1205         LD (X),A 
      00B2D7 E7 01            [ 1] 1206         LD (1,X),A 
      00B2D9 81               [ 4] 1207         RET 
                                   1208 
                                   1209 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1210 ;       MAX     ( n n -- n )
                                   1211 ;       Return greater of two top items.
                                   1212 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000668                       1213         _HEADER MAX,3,"MAX"
      00B2DA B2 C6                    1         .word LINK 
                           00066A     2         LINK=.
      00B2DC 03                       3         .byte 3  
      00B2DD 4D 41 58                 4         .ascii "MAX"
      00B2E0                          5         MAX:
      00B2E0 90 93            [ 1] 1214         LDW Y,X    
      00B2E2 90 FE            [ 2] 1215         LDW Y,(Y) ; n2 
      00B2E4 E3 02            [ 2] 1216         CPW Y,(2,X)   
      00B2E6 2F 02            [ 1] 1217         JRSLT  MAX1
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 71.
Hexadecimal [24-Bits]



      00B2E8 EF 02            [ 2] 1218         LDW (2,X),Y
      00B2EA 1C 00 02         [ 2] 1219 MAX1:   ADDW X,#2
      00B2ED 81               [ 4] 1220 	RET     
                                   1221 
                                   1222 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1223 ;       MIN     ( n n -- n )
                                   1224 ;       Return smaller of top two items.
                                   1225 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00067C                       1226         _HEADER MIN,3,"MIN"
      00B2EE B2 DC                    1         .word LINK 
                           00067E     2         LINK=.
      00B2F0 03                       3         .byte 3  
      00B2F1 4D 49 4E                 4         .ascii "MIN"
      00B2F4                          5         MIN:
      00B2F4 90 93            [ 1] 1227         LDW Y,X    
      00B2F6 90 FE            [ 2] 1228         LDW Y,(Y)  ; n2 
      00B2F8 E3 02            [ 2] 1229         CPW Y,(2,X) 
      00B2FA 2C 02            [ 1] 1230         JRSGT MIN1
      00B2FC EF 02            [ 2] 1231         LDW (2,X),Y
      00B2FE 1C 00 02         [ 2] 1232 MIN1:	ADDW X,#2
      00B301 81               [ 4] 1233 	RET     
                                   1234 
                                   1235 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1236 ;       WITHIN  ( u ul uh -- t )
                                   1237 ;       Return true if u is within
                                   1238 ;       range of ul and uh. ( ul <= u < uh )
                                   1239 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000690                       1240         _HEADER WITHI,6,"WITHIN"
      00B302 B2 F0                    1         .word LINK 
                           000692     2         LINK=.
      00B304 06                       3         .byte 6  
      00B305 57 49 54 48 49 4E        4         .ascii "WITHIN"
      00B30B                          5         WITHI:
      00B30B CD B0 06         [ 4] 1241         CALL     OVER
      00B30E CD B2 47         [ 4] 1242         CALL     SUBB
      00B311 CD AF A7         [ 4] 1243         CALL     TOR
      00B314 CD B2 47         [ 4] 1244         CALL     SUBB
      00B317 CD AE F9         [ 4] 1245         CALL     RFROM
      00B31A CC B2 85         [ 2] 1246         JP     ULESS
                                   1247 
                                   1248 ;; Divide
                                   1249 
                                   1250 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1251 ;       UM/MOD  ( udl udh un -- ur uq )
                                   1252 ;       Unsigned divide of a double by a
                                   1253 ;       single. Return mod and quotient.
                                   1254 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1255 ; 2021-02-22
                                   1256 ; changed algorithm for Jeeek one 
                                   1257 ; ref: https://github.com/TG9541/stm8ef/pull/406        
      0006AB                       1258         _HEADER UMMOD,6,"UM/MOD"
      00B31D B3 04                    1         .word LINK 
                           0006AD     2         LINK=.
      00B31F 06                       3         .byte 6  
      00B320 55 4D 2F 4D 4F 44        4         .ascii "UM/MOD"
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 72.
Hexadecimal [24-Bits]



      00B326                          5         UMMOD:
      00B326 90 93            [ 1] 1259         LDW     Y,X             ; stack pointer to Y
      00B328 FE               [ 2] 1260         LDW     X,(X)           ; un
      00B329 BF 48            [ 2] 1261         LDW     YTEMP,X         ; save un
      00B32B 93               [ 1] 1262         LDW     X,Y
      00B32C 5C               [ 1] 1263         INCW    X               ; drop un
      00B32D 5C               [ 1] 1264         INCW    X
      00B32E 89               [ 2] 1265         PUSHW   X               ; save stack pointer
      00B32F FE               [ 2] 1266         LDW     X,(X)           ; X=udh
      00B330 26 0B            [ 1] 1267         JRNE    MMSM0
      00B332 1E 01            [ 2] 1268         LDW    X,(1,SP)
      00B334 EE 02            [ 2] 1269         LDW    X,(2,X)          ; udl 
      00B336 90 BE 48         [ 2] 1270         LDW     Y,YTEMP         ;divisor 
      00B339 65               [ 2] 1271         DIVW    X,Y             ; udl/un 
      00B33A 51               [ 1] 1272         EXGW    X,Y 
      00B33B 20 26            [ 2] 1273         JRA     MMSMb 
      00B33D                       1274 MMSM0:    
      00B33D 90 EE 04         [ 2] 1275         LDW     Y,(4,Y)         ; Y=udl (offset before drop)
      00B340 B3 48            [ 2] 1276         CPW     X,YTEMP
      00B342 25 09            [ 1] 1277         JRULT   MMSM1           ; X is still on the R-stack
      00B344 85               [ 2] 1278         POPW    X               ; restore stack pointer
      00B345 90 5F            [ 1] 1279         CLRW    Y
      00B347 EF 02            [ 2] 1280         LDW     (2,X),Y         ; remainder 0
      00B349 90 5A            [ 2] 1281         DECW    Y
      00B34B FF               [ 2] 1282         LDW     (X),Y           ; quotient max. 16 bit value
      00B34C 81               [ 4] 1283         RET
      00B34D                       1284 MMSM1:
      00B34D A6 10            [ 1] 1285         LD      A,#16           ; loop count
      00B34F 90 58            [ 2] 1286         SLLW    Y               ; udl shift udl into udh
      00B351                       1287 MMSM3:
      00B351 59               [ 2] 1288         RLCW    X               ; rotate udl bit into uhdh (= remainder)
      00B352 25 04            [ 1] 1289         JRC     MMSMa           ; if carry out of rotate
      00B354 B3 48            [ 2] 1290         CPW     X,YTEMP         ; compare udh to un
      00B356 25 05            [ 1] 1291         JRULT   MMSM4           ; can't subtract
      00B358                       1292 MMSMa:
      00B358 72 B0 00 48      [ 2] 1293         SUBW    X,YTEMP         ; can subtract
      00B35C 98               [ 1] 1294         RCF
      00B35D                       1295 MMSM4:
      00B35D 8C               [ 1] 1296         CCF                     ; quotient bit
      00B35E 90 59            [ 2] 1297         RLCW    Y               ; rotate into quotient, rotate out udl
      00B360 4A               [ 1] 1298         DEC     A               ; repeat
      00B361 26 EE            [ 1] 1299         JRNE    MMSM3           ; if A == 0
      00B363                       1300 MMSMb:
      00B363 BF 48            [ 2] 1301         LDW     YTEMP,X         ; done, save remainder
      00B365 85               [ 2] 1302         POPW    X               ; restore stack pointer
      00B366 FF               [ 2] 1303         LDW     (X),Y           ; save quotient
      00B367 90 BE 48         [ 2] 1304         LDW     Y,YTEMP         ; remainder onto stack
      00B36A EF 02            [ 2] 1305         LDW     (2,X),Y
      00B36C 81               [ 4] 1306         RET
                                   1307 
                                   1308 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1309 ;   U/MOD ( u1 u2 -- ur uq )
                                   1310 ;   unsigned divide u1/u2 
                                   1311 ;   return remainder and quotient 
                                   1312 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 73.
Hexadecimal [24-Bits]



      0006FB                       1313         _HEADER USLMOD,5,"U/MOD"
      00B36D B3 1F                    1         .word LINK 
                           0006FD     2         LINK=.
      00B36F 05                       3         .byte 5  
      00B370 55 2F 4D 4F 44           4         .ascii "U/MOD"
      00B375                          5         USLMOD:
      00B375 90 93            [ 1] 1314         LDW Y,X 
      00B377 90 FE            [ 2] 1315         LDW Y,(Y)  ; dividend 
      00B379 89               [ 2] 1316         PUSHW X    ; DP >R 
      00B37A EE 02            [ 2] 1317         LDW X,(2,X) ; divisor 
      00B37C 65               [ 2] 1318         DIVW X,Y 
      00B37D 89               [ 2] 1319         PUSHW X     ; quotient 
      00B37E 1E 03            [ 2] 1320         LDW X,(3,SP) ; DP 
      00B380 EF 02            [ 2] 1321         LDW (2,X),Y ; remainder 
      00B382 16 01            [ 2] 1322         LDW Y,(1,SP) ; quotient 
      00B384 FF               [ 2] 1323         LDW (X),Y 
      00B385 5B 04            [ 2] 1324         ADDW SP,#2*CELLL ; drop quotient and DP from rstack 
      00B387 81               [ 4] 1325         RET 
                                   1326 
                                   1327 
                                   1328 
                                   1329 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
                                   1330 ;       M/MOD   ( d n -- r q )
                                   1331 ;       Signed floored divide of double by
                                   1332 ;       single. Return mod and quotient.
                                   1333 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000716                       1334         _HEADER MSMOD,5,"M/MOD"
      00B388 B3 6F                    1         .word LINK 
                           000718     2         LINK=.
      00B38A 05                       3         .byte 5  
      00B38B 4D 2F 4D 4F 44           4         .ascii "M/MOD"
      00B390                          5         MSMOD:
      00B390 CD AF DE         [ 4] 1335         CALL	DUPP
      00B393 CD B0 15         [ 4] 1336         CALL	ZLESS
      00B396 CD AF DE         [ 4] 1337         CALL	DUPP
      00B399 CD AF A7         [ 4] 1338         CALL	TOR
      00B39C CD AE 5D         [ 4] 1339         CALL	QBRAN
      00B39F B3 AD                 1340         .word	MMOD1
      00B3A1 CD B1 FB         [ 4] 1341         CALL	NEGAT
      00B3A4 CD AF A7         [ 4] 1342         CALL	TOR
      00B3A7 CD B2 0D         [ 4] 1343         CALL	DNEGA
      00B3AA CD AE F9         [ 4] 1344         CALL	RFROM
      00B3AD CD AF A7         [ 4] 1345 MMOD1:	CALL	TOR
      00B3B0 CD AF DE         [ 4] 1346         CALL	DUPP
      00B3B3 CD B0 15         [ 4] 1347         CALL	ZLESS
      00B3B6 CD AE 5D         [ 4] 1348         CALL	QBRAN
      00B3B9 B3 C1                 1349         .word	MMOD2
      00B3BB CD AF 0A         [ 4] 1350         CALL	RAT
      00B3BE CD B1 B1         [ 4] 1351         CALL	PLUS
      00B3C1 CD AE F9         [ 4] 1352 MMOD2:	CALL	RFROM
      00B3C4 CD B3 26         [ 4] 1353         CALL	UMMOD
      00B3C7 CD AE F9         [ 4] 1354         CALL	RFROM
      00B3CA CD AE 5D         [ 4] 1355         CALL	QBRAN
      00B3CD B3 D8                 1356         .word	MMOD3
      00B3CF CD AF EE         [ 4] 1357         CALL	SWAPP
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 74.
Hexadecimal [24-Bits]



      00B3D2 CD B1 FB         [ 4] 1358         CALL	NEGAT
      00B3D5 CC AF EE         [ 2] 1359         JP	SWAPP
      00B3D8 81               [ 4] 1360 MMOD3:	RET
                                   1361 
                                   1362 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1363 ;       /MOD    ( n1 n2 -- r q )
                                   1364 ;       Signed divide n1/n2. 
                                   1365 ;       Return mod and quotient.
                                   1366 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000767                       1367         _HEADER SLMOD,4,"/MOD"
      00B3D9 B3 8A                    1         .word LINK 
                           000769     2         LINK=.
      00B3DB 04                       3         .byte 4  
      00B3DC 2F 4D 4F 44              4         .ascii "/MOD"
      00B3E0                          5         SLMOD:
      00B3E0 F6               [ 1] 1368         LD A,(X)
      00B3E1 88               [ 1] 1369         PUSH A   ; n2 sign 
      00B3E2 E6 02            [ 1] 1370         LD A,(2,X)
      00B3E4 88               [ 1] 1371         PUSH A    ; n1 sign 
      00B3E5 CD B2 61         [ 4] 1372         CALL ABSS 
      00B3E8 CD AF A7         [ 4] 1373         CALL TOR  ; 
      00B3EB CD B2 61         [ 4] 1374         CALL ABSS 
      00B3EE CD AF 0A         [ 4] 1375         CALL RAT   
      00B3F1 CD B3 75         [ 4] 1376         CALL USLMOD 
      00B3F4 7B 03            [ 1] 1377         LD A,(3,SP)
      00B3F6 1A 04            [ 1] 1378         OR A,(4,SP)
      00B3F8 2A 30            [ 1] 1379         JRPL SLMOD8 ; both positive nothing to change 
      00B3FA 7B 03            [ 1] 1380         LD A,(3,SP)
      00B3FC 18 04            [ 1] 1381         XOR A,(4,SP)
      00B3FE 2A 1D            [ 1] 1382         JRPL SLMOD1
                                   1383 ; dividend and divisor are opposite sign          
      00B400 CD B1 FB         [ 4] 1384         CALL NEGAT ; negative quotient
      00B403 CD B0 06         [ 4] 1385         CALL OVER 
      00B406 CD B0 27         [ 4] 1386         CALL ZEQUAL 
      000797                       1387         _TBRAN SLMOD8 
      00B409 CD AE 6B         [ 4]    1     CALL TBRAN 
      00B40C B4 2A                    2     .word SLMOD8 
      00B40E CD B5 25         [ 4] 1388         CALL ONEM   ; add one to quotient 
      00B411 CD AF 0A         [ 4] 1389         CALL RAT 
      00B414 CD B1 52         [ 4] 1390         CALL ROT 
      00B417 CD B2 47         [ 4] 1391         CALL SUBB  ; corrected_remainder=divisor-remainder 
      00B41A CD AF EE         [ 4] 1392         CALL SWAPP
      00B41D                       1393 SLMOD1:
      00B41D 7B 04            [ 1] 1394         LD A,(4,SP) ; divisor sign 
      00B41F 2A 09            [ 1] 1395         JRPL SLMOD8 
      00B421 CD AF A7         [ 4] 1396         CALL TOR 
      00B424 CD B1 FB         [ 4] 1397         CALL NEGAT ; if divisor negative negate remainder 
      00B427 CD AE F9         [ 4] 1398         CALL RFROM 
      00B42A                       1399 SLMOD8: 
      00B42A 5B 04            [ 2] 1400         ADDW SP,#4 
      00B42C 81               [ 4] 1401         RET 
                                   1402 
                                   1403 
                                   1404 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1405 ;       MOD     ( n n -- r )
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 75.
Hexadecimal [24-Bits]



                                   1406 ;       Signed divide. Return mod only.
                                   1407 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0007BB                       1408         _HEADER MODD,3,"MOD"
      00B42D B3 DB                    1         .word LINK 
                           0007BD     2         LINK=.
      00B42F 03                       3         .byte 3  
      00B430 4D 4F 44                 4         .ascii "MOD"
      00B433                          5         MODD:
      00B433 CD B3 E0         [ 4] 1409 	CALL	SLMOD
      00B436 CC AF D4         [ 2] 1410 	JP	DROP
                                   1411 
                                   1412 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1413 ;       /       ( n n -- q )
                                   1414 ;       Signed divide. Return quotient only.
                                   1415 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0007C7                       1416         _HEADER SLASH,1,"/"
      00B439 B4 2F                    1         .word LINK 
                           0007C9     2         LINK=.
      00B43B 01                       3         .byte 1  
      00B43C 2F                       4         .ascii "/"
      00B43D                          5         SLASH:
      00B43D CD B3 E0         [ 4] 1417         CALL	SLMOD
      00B440 CD AF EE         [ 4] 1418         CALL	SWAPP
      00B443 CC AF D4         [ 2] 1419         JP	DROP
                                   1420 
                                   1421 ;; Multiply
                                   1422 
                                   1423 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1424 ;       UM*     ( u1 u2 -- ud )
                                   1425 ;       Unsigned multiply. Return 
                                   1426 ;       double product.
                                   1427 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0007D4                       1428         _HEADER UMSTA,3,"UM*"
      00B446 B4 3B                    1         .word LINK 
                           0007D6     2         LINK=.
      00B448 03                       3         .byte 3  
      00B449 55 4D 2A                 4         .ascii "UM*"
      00B44C                          5         UMSTA:
                                   1429 ; stack have 4 bytes u1=a:b u2=c:d
                                   1430         ;; bytes offset on data stack 
                           000002  1431         u1hi=2 
                           000003  1432         u1lo=3 
                           000000  1433         u2hi=0 
                           000001  1434         u2lo=1 
                                   1435         ;;;;;; local variables ;;;;;;;;;
                                   1436         ;; product bytes offset on return stack 
                           000001  1437         UD1=1  ; ud bits 31..24
                           000002  1438         UD2=2  ; ud bits 23..16
                           000003  1439         UD3=3  ; ud bits 15..8 
                           000004  1440         UD4=4  ; ud bits 7..0 
                                   1441         ;; local variable for product set to zero   
      00B44C 90 5F            [ 1] 1442         clrw y 
      00B44E 90 89            [ 2] 1443         pushw y  ; bits 15..0
      00B450 90 89            [ 2] 1444         pushw y  ; bits 31..16 
      00B452 E6 03            [ 1] 1445         ld a,(u1lo,x) ;  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 76.
Hexadecimal [24-Bits]



      00B454 90 97            [ 1] 1446         ld yl,a 
      00B456 E6 01            [ 1] 1447         ld a,(u2lo,x)   ; 
      00B458 90 42            [ 4] 1448         mul y,a    ; u1lo*u2lo  
      00B45A 17 03            [ 2] 1449         ldw (UD3,sp),y ; lowest weight product 
      00B45C E6 03            [ 1] 1450         ld a,(u1lo,x)
      00B45E 90 97            [ 1] 1451         ld yl,a 
      00B460 E6 00            [ 1] 1452         ld a,(u2hi,x)
      00B462 90 42            [ 4] 1453         mul y,a  ; u1lo*u2hi 
                                   1454         ;;; do the partial sum 
      00B464 72 F9 02         [ 2] 1455         addw y,(UD2,sp)
      00B467 4F               [ 1] 1456         clr a 
      00B468 49               [ 1] 1457         rlc a
      00B469 6B 01            [ 1] 1458         ld (UD1,sp),a 
      00B46B 17 02            [ 2] 1459         ldw (UD2,sp),y 
      00B46D E6 02            [ 1] 1460         ld a,(u1hi,x)
      00B46F 90 97            [ 1] 1461         ld yl,a 
      00B471 E6 01            [ 1] 1462         ld a,(u2lo,x)
      00B473 90 42            [ 4] 1463         mul y,a   ; u1hi*u2lo  
                                   1464         ;; do partial sum 
      00B475 72 F9 02         [ 2] 1465         addw y,(UD2,sp)
      00B478 4F               [ 1] 1466         clr a 
      00B479 19 01            [ 1] 1467         adc a,(UD1,sp)
      00B47B 6B 01            [ 1] 1468         ld (UD1,sp),a  
      00B47D 17 02            [ 2] 1469         ldw (UD2,sp),y 
      00B47F E6 02            [ 1] 1470         ld a,(u1hi,x)
      00B481 90 97            [ 1] 1471         ld yl,a 
      00B483 E6 00            [ 1] 1472         ld a,(u2hi,x)
      00B485 90 42            [ 4] 1473         mul y,a  ;  u1hi*u2hi highest weight product 
                                   1474         ;;; do partial sum 
      00B487 72 F9 01         [ 2] 1475         addw y,(UD1,sp)
      00B48A FF               [ 2] 1476         ldw (x),y  ; udh 
      00B48B 16 03            [ 2] 1477         ldw y,(UD3,sp)
      00B48D EF 02            [ 2] 1478         ldw (2,x),y  ; udl  
      00B48F 5B 04            [ 2] 1479         addw sp,#4 ; drop local variable 
      00B491 81               [ 4] 1480         ret  
                                   1481 
                                   1482 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1483 ;       *       ( n n -- n )
                                   1484 ;       Signed multiply. Return 
                                   1485 ;       single product.
                                   1486 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000820                       1487         _HEADER STAR,1,"*"
      00B492 B4 48                    1         .word LINK 
                           000822     2         LINK=.
      00B494 01                       3         .byte 1  
      00B495 2A                       4         .ascii "*"
      00B496                          5         STAR:
      00B496 CD B4 4C         [ 4] 1488 	CALL	UMSTA
      000827                       1489         _TDROP 
      00B499 1C 00 02         [ 2]    1     ADDW X,#CELLL  
      00B49C 81               [ 4] 1490         RET 
                                   1491 
                                   1492 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1493 ;       M*      ( n n -- d )
                                   1494 ;       Signed multiply. Return 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 77.
Hexadecimal [24-Bits]



                                   1495 ;       double product.
                                   1496 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00082B                       1497         _HEADER MSTAR,2,"M*"
      00B49D B4 94                    1         .word LINK 
                           00082D     2         LINK=.
      00B49F 02                       3         .byte 2  
      00B4A0 4D 2A                    4         .ascii "M*"
      00B4A2                          5         MSTAR:
      00B4A2 CD B1 9C         [ 4] 1498         CALL	DDUP
      00B4A5 CD B0 64         [ 4] 1499         CALL	XORR
      00B4A8 CD B0 15         [ 4] 1500         CALL	ZLESS
      00B4AB CD AF A7         [ 4] 1501         CALL	TOR
      00B4AE CD B2 61         [ 4] 1502         CALL	ABSS
      00B4B1 CD AF EE         [ 4] 1503         CALL	SWAPP
      00B4B4 CD B2 61         [ 4] 1504         CALL	ABSS
      00B4B7 CD B4 4C         [ 4] 1505         CALL	UMSTA
      00B4BA CD AE F9         [ 4] 1506         CALL	RFROM
      00B4BD CD AE 5D         [ 4] 1507         CALL	QBRAN
      00B4C0 B4 C5                 1508         .word	MSTA1
      00B4C2 CC B2 0D         [ 2] 1509         JP	DNEGA
      00B4C5 81               [ 4] 1510 MSTA1:	RET
                                   1511 
                                   1512 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1513 ;       */MOD   ( n1 n2 n3 -- r q )
                                   1514 ;       Multiply n1 and n2, then divide
                                   1515 ;       by n3. Return mod and quotient.
                                   1516 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000854                       1517         _HEADER SSMOD,5,"*/MOD"
      00B4C6 B4 9F                    1         .word LINK 
                           000856     2         LINK=.
      00B4C8 05                       3         .byte 5  
      00B4C9 2A 2F 4D 4F 44           4         .ascii "*/MOD"
      00B4CE                          5         SSMOD:
      00B4CE CD AF A7         [ 4] 1518         CALL     TOR
      00B4D1 CD B4 A2         [ 4] 1519         CALL     MSTAR
      00B4D4 CD AE F9         [ 4] 1520         CALL     RFROM
      00B4D7 CC B3 90         [ 2] 1521         JP     MSMOD
                                   1522 
                                   1523 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1524 ;       */      ( n1 n2 n3 -- q )
                                   1525 ;       Multiply n1 by n2, then divide
                                   1526 ;       by n3. Return quotient only.
                                   1527 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000868                       1528         _HEADER STASL,2,"*/"
      00B4DA B4 C8                    1         .word LINK 
                           00086A     2         LINK=.
      00B4DC 02                       3         .byte 2  
      00B4DD 2A 2F                    4         .ascii "*/"
      00B4DF                          5         STASL:
      00B4DF CD B4 CE         [ 4] 1529         CALL	SSMOD
      00B4E2 CD AF EE         [ 4] 1530         CALL	SWAPP
      00B4E5 CC AF D4         [ 2] 1531         JP	DROP
                                   1532 
                                   1533 ;; Miscellaneous
                                   1534 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 78.
Hexadecimal [24-Bits]



                                   1535 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1536 ;       2+   ( a -- a )
                                   1537 ;       Add cell size in byte to address.
                                   1538 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000876                       1539         _HEADER CELLP,2,"2+"
      00B4E8 B4 DC                    1         .word LINK 
                           000878     2         LINK=.
      00B4EA 02                       3         .byte 2  
      00B4EB 32 2B                    4         .ascii "2+"
      00B4ED                          5         CELLP:
      00B4ED 90 93            [ 1] 1540         LDW Y,X
      00B4EF 90 FE            [ 2] 1541 	LDW Y,(Y)
      00B4F1 72 A9 00 02      [ 2] 1542         ADDW Y,#CELLL 
      00B4F5 FF               [ 2] 1543         LDW (X),Y
      00B4F6 81               [ 4] 1544         RET
                                   1545 
                                   1546 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1547 ;       2-   ( a -- a )
                                   1548 ;       Subtract 2 from address.
                                   1549 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000885                       1550         _HEADER CELLM,2,"2-"
      00B4F7 B4 EA                    1         .word LINK 
                           000887     2         LINK=.
      00B4F9 02                       3         .byte 2  
      00B4FA 32 2D                    4         .ascii "2-"
      00B4FC                          5         CELLM:
      00B4FC 90 93            [ 1] 1551         LDW Y,X
      00B4FE 90 FE            [ 2] 1552 	LDW Y,(Y)
      00B500 72 A2 00 02      [ 2] 1553         SUBW Y,#CELLL
      00B504 FF               [ 2] 1554         LDW (X),Y
      00B505 81               [ 4] 1555         RET
                                   1556 
                                   1557 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1558 ;       2*   ( n -- n )
                                   1559 ;       Multiply tos by 2.
                                   1560 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000894                       1561         _HEADER CELLS,2,"2*"
      00B506 B4 F9                    1         .word LINK 
                           000896     2         LINK=.
      00B508 02                       3         .byte 2  
      00B509 32 2A                    4         .ascii "2*"
      00B50B                          5         CELLS:
      00B50B                       1562 TWOSTAR:        
      00B50B 90 93            [ 1] 1563         LDW Y,X
      00B50D 90 FE            [ 2] 1564 	LDW Y,(Y)
      00B50F 90 58            [ 2] 1565         SLAW Y
      00B511 FF               [ 2] 1566         LDW (X),Y
      00B512 81               [ 4] 1567         RET
                                   1568 
                                   1569 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1570 ;       1+      ( a -- a )
                                   1571 ;       Add cell size in byte 
                                   1572 ;       to address.
                                   1573 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0008A1                       1574         _HEADER ONEP,2,"1+"
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 79.
Hexadecimal [24-Bits]



      00B513 B5 08                    1         .word LINK 
                           0008A3     2         LINK=.
      00B515 02                       3         .byte 2  
      00B516 31 2B                    4         .ascii "1+"
      00B518                          5         ONEP:
      00B518 90 93            [ 1] 1575         LDW Y,X
      00B51A 90 FE            [ 2] 1576 	LDW Y,(Y)
      00B51C 90 5C            [ 1] 1577         INCW Y
      00B51E FF               [ 2] 1578         LDW (X),Y
      00B51F 81               [ 4] 1579         RET
                                   1580 
                                   1581 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1582 ;       1-      ( a -- a )
                                   1583 ;       Subtract 2 from address.
                                   1584 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0008AE                       1585         _HEADER ONEM,2,"1-"
      00B520 B5 15                    1         .word LINK 
                           0008B0     2         LINK=.
      00B522 02                       3         .byte 2  
      00B523 31 2D                    4         .ascii "1-"
      00B525                          5         ONEM:
      00B525 90 93            [ 1] 1586         LDW Y,X
      00B527 90 FE            [ 2] 1587 	LDW Y,(Y)
      00B529 90 5A            [ 2] 1588         DECW Y
      00B52B FF               [ 2] 1589         LDW (X),Y
      00B52C 81               [ 4] 1590         RET
                                   1591 
                                   1592 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1593 ;  shift left n times 
                                   1594 ; LSHIFT ( n1 n2 -- n1<<n2 )
                                   1595 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0008BB                       1596         _HEADER LSHIFT,6,"LSHIFT"
      00B52D B5 22                    1         .word LINK 
                           0008BD     2         LINK=.
      00B52F 06                       3         .byte 6  
      00B530 4C 53 48 49 46 54        4         .ascii "LSHIFT"
      00B536                          5         LSHIFT:
      00B536 E6 01            [ 1] 1597         ld a,(1,x)
      00B538 1C 00 02         [ 2] 1598         addw x,#CELLL 
      00B53B 90 93            [ 1] 1599         ldw y,x 
      00B53D 90 FE            [ 2] 1600         ldw y,(y)
      00B53F                       1601 LSHIFT1:
      00B53F 4D               [ 1] 1602         tnz a 
      00B540 27 05            [ 1] 1603         jreq LSHIFT4 
      00B542 90 58            [ 2] 1604         sllw y 
      00B544 4A               [ 1] 1605         dec a 
      00B545 20 F8            [ 2] 1606         jra LSHIFT1 
      00B547                       1607 LSHIFT4:
      00B547 FF               [ 2] 1608         ldw (x),y 
      00B548 81               [ 4] 1609         ret 
                                   1610 
                                   1611 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1612 ; shift right n times                 
                                   1613 ; RSHIFT (n1 n2 -- n1>>n2 )
                                   1614 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 80.
Hexadecimal [24-Bits]



      0008D7                       1615         _HEADER RSHIFT,6,"RSHIFT"
      00B549 B5 2F                    1         .word LINK 
                           0008D9     2         LINK=.
      00B54B 06                       3         .byte 6  
      00B54C 52 53 48 49 46 54        4         .ascii "RSHIFT"
      00B552                          5         RSHIFT:
      00B552 E6 01            [ 1] 1616         ld a,(1,x)
      00B554 1C 00 02         [ 2] 1617         addw x,#CELLL 
      00B557 90 93            [ 1] 1618         ldw y,x 
      00B559 90 FE            [ 2] 1619         ldw y,(y)
      00B55B                       1620 RSHIFT1:
      00B55B 4D               [ 1] 1621         tnz a 
      00B55C 27 05            [ 1] 1622         jreq RSHIFT4 
      00B55E 90 54            [ 2] 1623         srlw y 
      00B560 4A               [ 1] 1624         dec a 
      00B561 20 F8            [ 2] 1625         jra RSHIFT1 
      00B563                       1626 RSHIFT4:
      00B563 FF               [ 2] 1627         ldw (x),y 
      00B564 81               [ 4] 1628         ret 
                                   1629 
                                   1630 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1631 ;       2/      ( n -- n )
                                   1632 ;       divide  tos by 2.
                                   1633 ;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0008F3                       1634         _HEADER TWOSL,2,"2/"
      00B565 B5 4B                    1         .word LINK 
                           0008F5     2         LINK=.
      00B567 02                       3         .byte 2  
      00B568 32 2F                    4         .ascii "2/"
      00B56A                          5         TWOSL:
      00B56A 90 93            [ 1] 1635         LDW Y,X
      00B56C 90 FE            [ 2] 1636 	LDW Y,(Y)
      00B56E 90 57            [ 2] 1637         SRAW Y
      00B570 FF               [ 2] 1638         LDW (X),Y
      00B571 81               [ 4] 1639         RET
                                   1640 
                                   1641 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1642 ;       BL      ( -- 32 )
                                   1643 ;       Return 32,  blank character.
                                   1644 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000900                       1645         _HEADER BLANK,2,"BL"
      00B572 B5 67                    1         .word LINK 
                           000902     2         LINK=.
      00B574 02                       3         .byte 2  
      00B575 42 4C                    4         .ascii "BL"
      00B577                          5         BLANK:
      00B577 1D 00 02         [ 2] 1646         SUBW X,#2
      00B57A 90 AE 00 20      [ 2] 1647 	LDW Y,#32
      00B57E FF               [ 2] 1648         LDW (X),Y
      00B57F 81               [ 4] 1649         RET
                                   1650 
                                   1651 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1652 ;         0     ( -- 0)
                                   1653 ;         Return 0.
                                   1654 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 81.
Hexadecimal [24-Bits]



      00090E                       1655         _HEADER ZERO,1,"0"
      00B580 B5 74                    1         .word LINK 
                           000910     2         LINK=.
      00B582 01                       3         .byte 1  
      00B583 30                       4         .ascii "0"
      00B584                          5         ZERO:
      00B584 1D 00 02         [ 2] 1656         SUBW X,#2
      00B587 90 5F            [ 1] 1657 	CLRW Y
      00B589 FF               [ 2] 1658         LDW (X),Y
      00B58A 81               [ 4] 1659         RET
                                   1660 
                                   1661 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1662 ;         1     ( -- 1)
                                   1663 ;         Return 1.
                                   1664 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000919                       1665         _HEADER ONE,1,"1"
      00B58B B5 82                    1         .word LINK 
                           00091B     2         LINK=.
      00B58D 01                       3         .byte 1  
      00B58E 31                       4         .ascii "1"
      00B58F                          5         ONE:
      00B58F 1D 00 02         [ 2] 1666         SUBW X,#2
      00B592 90 AE 00 01      [ 2] 1667 	LDW Y,#1
      00B596 FF               [ 2] 1668         LDW (X),Y
      00B597 81               [ 4] 1669         RET
                                   1670 
                                   1671 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1672 ;         -1    ( -- -1)
                                   1673 ;   Return -1
                                   1674 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000926                       1675         _HEADER MONE,2,"-1"
      00B598 B5 8D                    1         .word LINK 
                           000928     2         LINK=.
      00B59A 02                       3         .byte 2  
      00B59B 2D 31                    4         .ascii "-1"
      00B59D                          5         MONE:
      00B59D 1D 00 02         [ 2] 1676         SUBW X,#2
      00B5A0 90 AE FF FF      [ 2] 1677 	LDW Y,#0xFFFF
      00B5A4 FF               [ 2] 1678         LDW (X),Y
      00B5A5 81               [ 4] 1679         RET
                                   1680 
                                   1681 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1682 ;       >CHAR   ( c -- c )
                                   1683 ;       Filter non-printing characters.
                                   1684 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000934                       1685         _HEADER TCHAR,5,">CHAR"
      00B5A6 B5 9A                    1         .word LINK 
                           000936     2         LINK=.
      00B5A8 05                       3         .byte 5  
      00B5A9 3E 43 48 41 52           4         .ascii ">CHAR"
      00B5AE                          5         TCHAR:
      00B5AE E6 01            [ 1] 1686         ld a,(1,x)
      00B5B0 A1 20            [ 1] 1687         cp a,#32  
      00B5B2 2B 05            [ 1] 1688         jrmi 1$ 
      00B5B4 A1 7F            [ 1] 1689         cp a,#127 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 82.
Hexadecimal [24-Bits]



      00B5B6 2A 01            [ 1] 1690         jrpl 1$ 
      00B5B8 81               [ 4] 1691         ret 
      00B5B9 A6 5F            [ 1] 1692 1$:     ld a,#'_ 
      00B5BB E7 01            [ 1] 1693         ld (1,x),a 
      00B5BD 81               [ 4] 1694         ret 
                                   1695 
                                   1696 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1697 ;       DEPTH   ( -- n )
                                   1698 ;       Return  depth of  data stack.
                                   1699 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00094C                       1700         _HEADER DEPTH,5,"DEPTH"
      00B5BE B5 A8                    1         .word LINK 
                           00094E     2         LINK=.
      00B5C0 05                       3         .byte 5  
      00B5C1 44 45 50 54 48           4         .ascii "DEPTH"
      00B5C6                          5         DEPTH:
      00B5C6 90 BE 4E         [ 2] 1701         LDW Y,SP0    ;save data stack ptr
      00B5C9 BF 46            [ 2] 1702 	LDW XTEMP,X
      00B5CB 72 B2 00 46      [ 2] 1703         SUBW Y,XTEMP     ;#bytes = SP0 - X
      00B5CF 90 57            [ 2] 1704         SRAW Y    ;Y = #stack items
      00B5D1 1D 00 02         [ 2] 1705 	SUBW X,#2
      00B5D4 FF               [ 2] 1706         LDW (X),Y     ; if neg, underflow
      00B5D5 81               [ 4] 1707         RET
                                   1708 
                                   1709 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1710 ;       PICK    ( ... +n -- ... w )
                                   1711 ;       Copy  nth stack item to tos.
                                   1712 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000964                       1713         _HEADER PICK,4,"PICK"
      00B5D6 B5 C0                    1         .word LINK 
                           000966     2         LINK=.
      00B5D8 04                       3         .byte 4  
      00B5D9 50 49 43 4B              4         .ascii "PICK"
      00B5DD                          5         PICK:
      00B5DD 90 93            [ 1] 1714         LDW Y,X   ;D = n1
      00B5DF 90 FE            [ 2] 1715         LDW Y,(Y)
                                   1716 ; modified for standard compliance          
                                   1717 ; 0 PICK must be equivalent to DUP 
      00B5E1 90 5C            [ 1] 1718         INCW Y 
      00B5E3 90 58            [ 2] 1719         SLAW Y
      00B5E5 BF 46            [ 2] 1720         LDW XTEMP,X
      00B5E7 72 B9 00 46      [ 2] 1721         ADDW Y,XTEMP
      00B5EB 90 FE            [ 2] 1722         LDW Y,(Y)
      00B5ED FF               [ 2] 1723         LDW (X),Y
      00B5EE 81               [ 4] 1724         RET
                                   1725 
                                   1726 ;; Memory access
                                   1727 
                                   1728 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1729 ;       +!      ( n a -- )
                                   1730 ;       Add n to  contents at 
                                   1731 ;       address a.
                                   1732 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00097D                       1733         _HEADER PSTOR,2,"+!"
      00B5EF B5 D8                    1         .word LINK 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 83.
Hexadecimal [24-Bits]



                           00097F     2         LINK=.
      00B5F1 02                       3         .byte 2  
      00B5F2 2B 21                    4         .ascii "+!"
      00B5F4                          5         PSTOR:
      00B5F4 89               [ 2] 1734         PUSHW X   ; R: DP 
      00B5F5 90 93            [ 1] 1735         LDW Y,X 
      00B5F7 FE               [ 2] 1736         LDW X,(X) ; a 
      00B5F8 90 EE 02         [ 2] 1737         LDW Y,(2,Y)  ; n 
      00B5FB 90 89            [ 2] 1738         PUSHW Y      ; R: DP n 
      00B5FD 90 93            [ 1] 1739         LDW Y,X 
      00B5FF 90 FE            [ 2] 1740         LDW Y,(Y)
      00B601 72 F9 01         [ 2] 1741         ADDW Y,(1,SP) ; *a + n 
      00B604 FF               [ 2] 1742         LDW (X),Y 
      00B605 1E 03            [ 2] 1743         LDW X,(3,SP) ; DP
      00B607 1C 00 04         [ 2] 1744         ADDW X,#2*CELLL  ; ( n a -- )  
      00B60A 5B 04            [ 2] 1745         ADDW SP,#2*CELLL ; R: DP n -- 
      00B60C 81               [ 4] 1746         RET 
                                   1747                 
                                   1748 
                                   1749 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1750 ;       2!      ( d a -- )
                                   1751 ;       Store  double integer 
                                   1752 ;       to address a.
                                   1753 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00099B                       1754         _HEADER DSTOR,2,"2!"
      00B60D B5 F1                    1         .word LINK 
                           00099D     2         LINK=.
      00B60F 02                       3         .byte 2  
      00B610 32 21                    4         .ascii "2!"
      00B612                          5         DSTOR:
      00B612 90 93            [ 1] 1755         LDW Y,X 
      00B614 89               [ 2] 1756         PUSHW X 
      00B615 FE               [ 2] 1757         LDW X,(X) ; a 
      00B616 90 EE 02         [ 2] 1758         LDW Y,(2,Y) ; dhi 
      00B619 FF               [ 2] 1759         LDW (X),Y 
      00B61A 16 01            [ 2] 1760         LDW Y,(1,SP)  
      00B61C 90 EE 04         [ 2] 1761         LDW Y,(4,Y) ; dlo 
      00B61F EF 02            [ 2] 1762         LDW (2,X),Y  
      00B621 85               [ 2] 1763         POPW X 
      00B622 1C 00 06         [ 2] 1764         ADDW X,#3*CELLL 
      00B625 81               [ 4] 1765         RET 
                                   1766 
                                   1767 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1768 ;       2@      ( a -- d )
                                   1769 ;       Fetch double integer 
                                   1770 ;       from address a.
                                   1771 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0009B4                       1772         _HEADER DAT,2,"2@"
      00B626 B6 0F                    1         .word LINK 
                           0009B6     2         LINK=.
      00B628 02                       3         .byte 2  
      00B629 32 40                    4         .ascii "2@"
      00B62B                          5         DAT:
      00B62B 90 93            [ 1] 1773         ldw y,x 
      00B62D 1D 00 02         [ 2] 1774         subw x,#CELLL 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 84.
Hexadecimal [24-Bits]



      00B630 90 FE            [ 2] 1775         ldw y,(y) ;address 
      00B632 90 89            [ 2] 1776         pushw y  
      00B634 90 FE            [ 2] 1777         ldw y,(y) ; dhi 
      00B636 FF               [ 2] 1778         ldw (x),y 
      00B637 90 85            [ 2] 1779         popw y 
      00B639 90 EE 02         [ 2] 1780         ldw y,(2,y) ; dlo 
      00B63C EF 02            [ 2] 1781         ldw (2,x),y 
      00B63E 81               [ 4] 1782         ret 
                                   1783 
                                   1784 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1785 ;       COUNT   ( b -- b +n )
                                   1786 ;       Return count byte of a string
                                   1787 ;       and add 1 to byte address.
                                   1788 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0009CD                       1789         _HEADER COUNT,5,"COUNT"
      00B63F B6 28                    1         .word LINK 
                           0009CF     2         LINK=.
      00B641 05                       3         .byte 5  
      00B642 43 4F 55 4E 54           4         .ascii "COUNT"
      00B647                          5         COUNT:
      00B647 90 93            [ 1] 1790         ldw y,x 
      00B649 90 FE            [ 2] 1791         ldw y,(y) ; address 
      00B64B 90 F6            [ 1] 1792         ld a,(y)  ; count 
      00B64D 90 5C            [ 1] 1793         incw y 
      00B64F FF               [ 2] 1794         ldw (x),y 
      00B650 1D 00 02         [ 2] 1795         subw x,#CELLL 
      00B653 E7 01            [ 1] 1796         ld (1,x),a 
      00B655 7F               [ 1] 1797         clr (x)
      00B656 81               [ 4] 1798         ret 
                                   1799 
                                   1800 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1801 ;       HERE    ( -- a )
                                   1802 ;       Return  top of  variables
                                   1803 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0009E5                       1804         _HEADER HERE,4,"HERE"
      00B657 B6 41                    1         .word LINK 
                           0009E7     2         LINK=.
      00B659 04                       3         .byte 4  
      00B65A 48 45 52 45              4         .ascii "HERE"
      00B65E                          5         HERE:
      00B65E 90 AE 00 44      [ 2] 1805       	ldw y,#UVP 
      00B662 90 FE            [ 2] 1806         ldw y,(y)
      00B664 1D 00 02         [ 2] 1807         subw x,#CELLL 
      00B667 FF               [ 2] 1808         ldw (x),y 
      00B668 81               [ 4] 1809         ret 
                                   1810 
                                   1811 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1812 ;       PAD     ( -- a )
                                   1813 ;       Return address of text buffer
                                   1814 ;       above  code dictionary.
                                   1815 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0009F7                       1816         _HEADER PAD,3,"PAD"
      00B669 B6 59                    1         .word LINK 
                           0009F9     2         LINK=.
      00B66B 03                       3         .byte 3  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 85.
Hexadecimal [24-Bits]



      00B66C 50 41 44                 4         .ascii "PAD"
      00B66F                          5         PAD:
      00B66F CD B6 5E         [ 4] 1817         CALL     HERE
      000A00                       1818         _DOLIT   80
      00B672 CD AE 34         [ 4]    1     CALL DOLIT 
      00B675 00 50                    2     .word 80 
      00B677 CC B1 B1         [ 2] 1819         JP     PLUS
                                   1820 
                                   1821 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1822 ;       TIB     ( -- a )
                                   1823 ;       Return address of 
                                   1824 ;       terminal input buffer.
                                   1825 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000A08                       1826         _HEADER TIB,3,"TIB"
      00B67A B6 6B                    1         .word LINK 
                           000A0A     2         LINK=.
      00B67C 03                       3         .byte 3  
      00B67D 54 49 42                 4         .ascii "TIB"
      00B680                          5         TIB:
      00B680 CD B0 D0         [ 4] 1827         CALL     NTIB
      00B683 CD B4 ED         [ 4] 1828         CALL     CELLP
      00B686 CC AE A8         [ 2] 1829         JP     AT
                                   1830 
                                   1831 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1832 ;       @EXECUTE        ( a -- )
                                   1833 ;       Execute vector stored in 
                                   1834 ;       address a.
                                   1835 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000A17                       1836         _HEADER ATEXE,8,"@EXECUTE"
      00B689 B6 7C                    1         .word LINK 
                           000A19     2         LINK=.
      00B68B 08                       3         .byte 8  
      00B68C 40 45 58 45 43 55 54     4         .ascii "@EXECUTE"
             45
      00B694                          5         ATEXE:
      00B694 CD AE A8         [ 4] 1837         CALL     AT
      00B697 CD B1 41         [ 4] 1838         CALL     QDUP    ;?address or zero
      00B69A CD AE 5D         [ 4] 1839         CALL     QBRAN
      00B69D B6 A2                 1840         .word      EXE1
      00B69F CD AE 89         [ 4] 1841         CALL     EXECU   ;execute if non-zero
      00B6A2 81               [ 4] 1842 EXE1:   RET     ;do nothing if zero
                                   1843 
                                   1844 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1845 ;       CMOVE   ( b1 b2 u -- )
                                   1846 ;       Copy u bytes from b1 to b2.
                                   1847 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000A31                       1848         _HEADER CMOVE,5,"CMOVE"
      00B6A3 B6 8B                    1         .word LINK 
                           000A33     2         LINK=.
      00B6A5 05                       3         .byte 5  
      00B6A6 43 4D 4F 56 45           4         .ascii "CMOVE"
      00B6AB                          5         CMOVE:
                                   1849         ;;;;  local variables ;;;;;;;
                           000005  1850         DP = 5
                           000003  1851         YTMP = 3 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 86.
Hexadecimal [24-Bits]



                           000001  1852         CNT  = 1 
                                   1853         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00B6AB 89               [ 2] 1854         PUSHW X  ; R: DP  
      00B6AC 52 02            [ 2] 1855         SUB SP,#2 ; R: DP YTMP 
      00B6AE 90 93            [ 1] 1856         LDW Y,X 
      00B6B0 90 FE            [ 2] 1857         LDW Y,(Y) ; CNT 
      00B6B2 90 89            [ 2] 1858         PUSHW Y  ; R: DP YTMP CNT
      00B6B4 90 93            [ 1] 1859         LDW Y,X 
      00B6B6 90 EE 02         [ 2] 1860         LDW Y,(2,Y) ; b2, dest 
      00B6B9 EE 04            [ 2] 1861         LDW X,(4,X) ; b1, src 
      00B6BB 17 03            [ 2] 1862         LDW (YTMP,SP),Y 
      00B6BD 13 03            [ 2] 1863         CPW X,(YTMP,SP) 
      00B6BF 22 1A            [ 1] 1864         JRUGT CMOV2  ; src>dest 
                                   1865 ; src<dest copy from top to bottom
      00B6C1 72 FB 01         [ 2] 1866         ADDW X,(CNT,SP)
      00B6C4 72 F9 01         [ 2] 1867         ADDW Y,(CNT,SP)
      00B6C7                       1868 CMOV1:  
      00B6C7 17 03            [ 2] 1869         LDW (YTMP,SP),Y 
      00B6C9 16 01            [ 2] 1870         LDW Y,(CNT,SP)
      00B6CB 27 22            [ 1] 1871         JREQ CMOV3 
      00B6CD 90 5A            [ 2] 1872         DECW Y 
      00B6CF 17 01            [ 2] 1873         LDW (CNT,SP),Y 
      00B6D1 16 03            [ 2] 1874         LDW Y,(YTMP,SP)
      00B6D3 5A               [ 2] 1875         DECW X
      00B6D4 F6               [ 1] 1876         LD A,(X)
      00B6D5 90 5A            [ 2] 1877         DECW Y 
      00B6D7 90 F7            [ 1] 1878         LD (Y),A 
      00B6D9 20 EC            [ 2] 1879         JRA CMOV1
                                   1880 ; src>dest copy from bottom to top   
      00B6DB                       1881 CMOV2: 
      00B6DB 17 03            [ 2] 1882         LDW (YTMP,SP),Y 
      00B6DD 16 01            [ 2] 1883         LDW Y,(CNT,SP)
      00B6DF 27 0E            [ 1] 1884         JREQ CMOV3
      00B6E1 90 5A            [ 2] 1885         DECW Y 
      00B6E3 17 01            [ 2] 1886         LDW (CNT,SP),Y 
      00B6E5 16 03            [ 2] 1887         LDW Y,(YTMP,SP)
      00B6E7 F6               [ 1] 1888         LD A,(X)
      00B6E8 5C               [ 1] 1889         INCW X 
      00B6E9 90 F7            [ 1] 1890         LD (Y),A 
      00B6EB 90 5C            [ 1] 1891         INCW Y 
      00B6ED 20 EC            [ 2] 1892         JRA CMOV2 
      00B6EF                       1893 CMOV3:
      00B6EF 1E 05            [ 2] 1894         LDW X,(DP,SP)
      00B6F1 1C 00 06         [ 2] 1895         ADDW X,#3*CELLL 
      00B6F4 5B 06            [ 2] 1896         ADDW SP,#3*CELLL 
      00B6F6 81               [ 4] 1897         RET 
                                   1898         
                                   1899 
                                   1900 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1901 ;       FILL    ( b u c -- )
                                   1902 ;       Fill u bytes of character c
                                   1903 ;       to area beginning at b.
                                   1904 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000A85                       1905         _HEADER FILL,4,"FILL"
      00B6F7 B6 A5                    1         .word LINK 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 87.
Hexadecimal [24-Bits]



                           000A87     2         LINK=.
      00B6F9 04                       3         .byte 4  
      00B6FA 46 49 4C 4C              4         .ascii "FILL"
      00B6FE                          5         FILL:
      00B6FE E6 01            [ 1] 1906         LD A,(1,X)
      00B700 90 93            [ 1] 1907         LDW Y,X 
      00B702 1C 00 06         [ 2] 1908         ADDW X,#3*CELLL 
      00B705 89               [ 2] 1909         PUSHW X ; R: DP 
      00B706 93               [ 1] 1910         LDW X,Y 
      00B707 EE 04            [ 2] 1911         LDW X,(4,X) ; b
      00B709 90 EE 02         [ 2] 1912         LDW Y,(2,Y) ; u
      00B70C                       1913 FILL0:
      00B70C 27 06            [ 1] 1914         JREQ FILL1
      00B70E F7               [ 1] 1915         LD (X),A 
      00B70F 5C               [ 1] 1916         INCW X 
      00B710 90 5A            [ 2] 1917         DECW Y 
      00B712 20 F8            [ 2] 1918         JRA FILL0         
      00B714 85               [ 2] 1919 FILL1: POPW X 
      00B715 81               [ 4] 1920         RET         
                                   1921         
                                   1922 
                                   1923 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1924 ;       ERASE   ( b u -- )
                                   1925 ;       Erase u bytes beginning at b.
                                   1926 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000AA4                       1927         _HEADER ERASE,5,"ERASE"
      00B716 B6 F9                    1         .word LINK 
                           000AA6     2         LINK=.
      00B718 05                       3         .byte 5  
      00B719 45 52 41 53 45           4         .ascii "ERASE"
      00B71E                          5         ERASE:
      00B71E 90 5F            [ 1] 1928         clrw y 
      00B720 1D 00 02         [ 2] 1929         subw x,#CELLL 
      00B723 FF               [ 2] 1930         ldw (x),y 
      00B724 CC B6 FE         [ 2] 1931         jp FILL 
                                   1932 
                                   1933 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1934 ;       PACK0   ( b u a -- a )
                                   1935 ;       Build a counted string with
                                   1936 ;       u characters from b. Null fill.
                                   1937 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000AB5                       1938         _HEADER PACKS,5,"PACK0"
      00B727 B7 18                    1         .word LINK 
                           000AB7     2         LINK=.
      00B729 05                       3         .byte 5  
      00B72A 50 41 43 4B 30           4         .ascii "PACK0"
      00B72F                          5         PACKS:
      00B72F CD AF DE         [ 4] 1939         CALL     DUPP
      00B732 CD AF A7         [ 4] 1940         CALL     TOR     ;strings only on cell boundary
      00B735 CD B1 9C         [ 4] 1941         CALL     DDUP
      00B738 CD AE B5         [ 4] 1942         CALL     CSTOR
      00B73B CD B5 18         [ 4] 1943         CALL     ONEP ;save count
      00B73E CD AF EE         [ 4] 1944         CALL     SWAPP
      00B741 CD B6 AB         [ 4] 1945         CALL     CMOVE
      00B744 CD AE F9         [ 4] 1946         CALL     RFROM
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 88.
Hexadecimal [24-Bits]



      00B747 81               [ 4] 1947         RET
                                   1948 
                                   1949 ;; Numeric output, single precision
                                   1950 
                                   1951 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1952 ;       DIGIT   ( u -- c )
                                   1953 ;       Convert digit u to a character.
                                   1954 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000AD6                       1955         _HEADER DIGIT,5,"DIGIT"
      00B748 B7 29                    1         .word LINK 
                           000AD8     2         LINK=.
      00B74A 05                       3         .byte 5  
      00B74B 44 49 47 49 54           4         .ascii "DIGIT"
      00B750                          5         DIGIT:
      00B750 CD AE 34         [ 4] 1956         CALL	DOLIT
      00B753 00 09                 1957         .word	9
      00B755 CD B0 06         [ 4] 1958         CALL	OVER
      00B758 CD B2 9B         [ 4] 1959         CALL	LESS
      00B75B CD AE 34         [ 4] 1960         CALL	DOLIT
      00B75E 00 07                 1961         .word	7
      00B760 CD B0 3B         [ 4] 1962         CALL	ANDD
      00B763 CD B1 B1         [ 4] 1963         CALL	PLUS
      00B766 CD AE 34         [ 4] 1964         CALL	DOLIT
      00B769 00 30                 1965         .word	48	;'0'
      00B76B CC B1 B1         [ 2] 1966         JP	PLUS
                                   1967 
                                   1968 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1969 ;       EXTRACT ( n base -- n c )
                                   1970 ;       Extract least significant 
                                   1971 ;       digit from n.
                                   1972 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000AFC                       1973         _HEADER EXTRC,7,"EXTRACT"
      00B76E B7 4A                    1         .word LINK 
                           000AFE     2         LINK=.
      00B770 07                       3         .byte 7  
      00B771 45 58 54 52 41 43 54     4         .ascii "EXTRACT"
      00B778                          5         EXTRC:
      00B778 CD B5 84         [ 4] 1974         CALL     ZERO
      00B77B CD AF EE         [ 4] 1975         CALL     SWAPP
      00B77E CD B3 26         [ 4] 1976         CALL     UMMOD
      00B781 CD AF EE         [ 4] 1977         CALL     SWAPP
      00B784 CC B7 50         [ 2] 1978         JP     DIGIT
                                   1979 
                                   1980 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1981 ;       <#      ( -- )
                                   1982 ;       Initiate  numeric 
                                   1983 ;       output process.
                                   1984 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000B15                       1985         _HEADER BDIGS,2,"#<"
      00B787 B7 70                    1         .word LINK 
                           000B17     2         LINK=.
      00B789 02                       3         .byte 2  
      00B78A 23 3C                    4         .ascii "#<"
      00B78C                          5         BDIGS:
      00B78C CD B6 6F         [ 4] 1986         CALL     PAD
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 89.
Hexadecimal [24-Bits]



      00B78F CD B1 00         [ 4] 1987         CALL     HLD
      00B792 CC AE 96         [ 2] 1988         JP     STORE
                                   1989 
                                   1990 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1991 ;       HOLD    ( c -- )
                                   1992 ;       Insert a character 
                                   1993 ;       into output string.
                                   1994 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000B23                       1995         _HEADER HOLD,4,"HOLD"
      00B795 B7 89                    1         .word LINK 
                           000B25     2         LINK=.
      00B797 04                       3         .byte 4  
      00B798 48 4F 4C 44              4         .ascii "HOLD"
      00B79C                          5         HOLD:
      00B79C CD B1 00         [ 4] 1996         CALL     HLD
      00B79F CD AE A8         [ 4] 1997         CALL     AT
      00B7A2 CD B5 25         [ 4] 1998         CALL     ONEM
      00B7A5 CD AF DE         [ 4] 1999         CALL     DUPP
      00B7A8 CD B1 00         [ 4] 2000         CALL     HLD
      00B7AB CD AE 96         [ 4] 2001         CALL     STORE
      00B7AE CC AE B5         [ 2] 2002         JP     CSTOR
                                   2003 
                                   2004 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2005 ;       #       ( u -- u )
                                   2006 ;       Extract one digit from u and
                                   2007 ;       append digit to output string.
                                   2008 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000B3F                       2009         _HEADER DIG,1,"#"
      00B7B1 B7 97                    1         .word LINK 
                           000B41     2         LINK=.
      00B7B3 01                       3         .byte 1  
      00B7B4 23                       4         .ascii "#"
      00B7B5                          5         DIG:
      00B7B5 CD B0 A2         [ 4] 2010         CALL     BASE
      00B7B8 CD AE A8         [ 4] 2011         CALL     AT
      00B7BB CD B7 78         [ 4] 2012         CALL     EXTRC
      00B7BE CC B7 9C         [ 2] 2013         JP     HOLD
                                   2014 
                                   2015 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2016 ;       #S      ( u -- 0 )
                                   2017 ;       Convert u until all digits
                                   2018 ;       are added to output string.
                                   2019 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000B4F                       2020         _HEADER DIGS,2,"#S"
      00B7C1 B7 B3                    1         .word LINK 
                           000B51     2         LINK=.
      00B7C3 02                       3         .byte 2  
      00B7C4 23 53                    4         .ascii "#S"
      00B7C6                          5         DIGS:
      00B7C6 CD B7 B5         [ 4] 2021 DIGS1:  CALL     DIG
      00B7C9 CD AF DE         [ 4] 2022         CALL     DUPP
      00B7CC CD AE 5D         [ 4] 2023         CALL     QBRAN
      00B7CF B7 D3                 2024         .word      DIGS2
      00B7D1 20 F3            [ 2] 2025         JRA     DIGS1
      00B7D3 81               [ 4] 2026 DIGS2:  RET
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 90.
Hexadecimal [24-Bits]



                                   2027 
                                   2028 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2029 ;       SIGN    ( n -- )
                                   2030 ;       Add a minus sign to
                                   2031 ;       numeric output string.
                                   2032 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000B62                       2033         _HEADER SIGN,4,"SIGN"
      00B7D4 B7 C3                    1         .word LINK 
                           000B64     2         LINK=.
      00B7D6 04                       3         .byte 4  
      00B7D7 53 49 47 4E              4         .ascii "SIGN"
      00B7DB                          5         SIGN:
      00B7DB CD B0 15         [ 4] 2034         CALL     ZLESS
      00B7DE CD AE 5D         [ 4] 2035         CALL     QBRAN
      00B7E1 B7 EB                 2036         .word      SIGN1
      00B7E3 CD AE 34         [ 4] 2037         CALL     DOLIT
      00B7E6 00 2D                 2038         .word      45	;"-"
      00B7E8 CC B7 9C         [ 2] 2039         JP     HOLD
      00B7EB 81               [ 4] 2040 SIGN1:  RET
                                   2041 
                                   2042 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2043 ;       #>      ( w -- b u )
                                   2044 ;       Prepare output string.
                                   2045 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000B7A                       2046         _HEADER EDIGS,2,"#>"
      00B7EC B7 D6                    1         .word LINK 
                           000B7C     2         LINK=.
      00B7EE 02                       3         .byte 2  
      00B7EF 23 3E                    4         .ascii "#>"
      00B7F1                          5         EDIGS:
      00B7F1 CD AF D4         [ 4] 2047         CALL     DROP
      00B7F4 CD B1 00         [ 4] 2048         CALL     HLD
      00B7F7 CD AE A8         [ 4] 2049         CALL     AT
      00B7FA CD B6 6F         [ 4] 2050         CALL     PAD
      00B7FD CD B0 06         [ 4] 2051         CALL     OVER
      00B800 CC B2 47         [ 2] 2052         JP     SUBB
                                   2053 
                                   2054 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2055 ;       str     ( w -- b u )
                                   2056 ;       Convert a signed integer
                                   2057 ;       to a numeric string.
                                   2058 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000B91                       2059         _HEADER STR,3,"STR"
      00B803 B7 EE                    1         .word LINK 
                           000B93     2         LINK=.
      00B805 03                       3         .byte 3  
      00B806 53 54 52                 4         .ascii "STR"
      00B809                          5         STR:
      00B809 CD AF DE         [ 4] 2060         CALL     DUPP
      00B80C CD AF A7         [ 4] 2061         CALL     TOR
      00B80F CD B2 61         [ 4] 2062         CALL     ABSS
      00B812 CD B7 8C         [ 4] 2063         CALL     BDIGS
      00B815 CD B7 C6         [ 4] 2064         CALL     DIGS
      00B818 CD AE F9         [ 4] 2065         CALL     RFROM
      00B81B CD B7 DB         [ 4] 2066         CALL     SIGN
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 91.
Hexadecimal [24-Bits]



      00B81E CC B7 F1         [ 2] 2067         JP     EDIGS
                                   2068 
                                   2069 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2070 ;       HEX     ( -- )
                                   2071 ;       Use radix 16 as base for
                                   2072 ;       numeric conversions.
                                   2073 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000BAF                       2074         _HEADER HEX,3,"HEX"
      00B821 B8 05                    1         .word LINK 
                           000BB1     2         LINK=.
      00B823 03                       3         .byte 3  
      00B824 48 45 58                 4         .ascii "HEX"
      00B827                          5         HEX:
      00B827 CD AE 34         [ 4] 2075         CALL     DOLIT
      00B82A 00 10                 2076         .word      16
      00B82C CD B0 A2         [ 4] 2077         CALL     BASE
      00B82F CC AE 96         [ 2] 2078         JP     STORE
                                   2079 
                                   2080 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2081 ;       DECIMAL ( -- )
                                   2082 ;       Use radix 10 as base
                                   2083 ;       for numeric conversions.
                                   2084 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000BC0                       2085         _HEADER DECIM,7,"DECIMAL"
      00B832 B8 23                    1         .word LINK 
                           000BC2     2         LINK=.
      00B834 07                       3         .byte 7  
      00B835 44 45 43 49 4D 41 4C     4         .ascii "DECIMAL"
      00B83C                          5         DECIM:
      00B83C CD AE 34         [ 4] 2086         CALL     DOLIT
      00B83F 00 0A                 2087         .word      10
      00B841 CD B0 A2         [ 4] 2088         CALL     BASE
      00B844 CC AE 96         [ 2] 2089         JP     STORE
                                   2090 
                                   2091 ;; Numeric input, single precision
                                   2092 
                                   2093 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2094 ;       DIGIT?  ( c base -- u t )
                                   2095 ;       Convert a character to its numeric
                                   2096 ;       value. A flag indicates success.
                                   2097 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000BD5                       2098         _HEADER DIGTQ,6,"DIGIT?"
      00B847 B8 34                    1         .word LINK 
                           000BD7     2         LINK=.
      00B849 06                       3         .byte 6  
      00B84A 44 49 47 49 54 3F        4         .ascii "DIGIT?"
      00B850                          5         DIGTQ:
      00B850 CD AF A7         [ 4] 2099         CALL     TOR
      00B853 CD AE 34         [ 4] 2100         CALL     DOLIT
      00B856 00 30                 2101         .word     48	; "0"
      00B858 CD B2 47         [ 4] 2102         CALL     SUBB
      00B85B CD AE 34         [ 4] 2103         CALL     DOLIT
      00B85E 00 09                 2104         .word      9
      00B860 CD B0 06         [ 4] 2105         CALL     OVER
      00B863 CD B2 9B         [ 4] 2106         CALL     LESS
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 92.
Hexadecimal [24-Bits]



      00B866 CD AE 5D         [ 4] 2107         CALL     QBRAN
      00B869 B8 81                 2108         .word      DGTQ1
      00B86B CD AE 34         [ 4] 2109         CALL     DOLIT
      00B86E 00 07                 2110         .word      7
      00B870 CD B2 47         [ 4] 2111         CALL     SUBB
      00B873 CD AF DE         [ 4] 2112         CALL     DUPP
      00B876 CD AE 34         [ 4] 2113         CALL     DOLIT
      00B879 00 0A                 2114         .word      10
      00B87B CD B2 9B         [ 4] 2115         CALL     LESS
      00B87E CD B0 4F         [ 4] 2116         CALL     ORR
      00B881 CD AF DE         [ 4] 2117 DGTQ1:  CALL     DUPP
      00B884 CD AE F9         [ 4] 2118         CALL     RFROM
      00B887 CC B2 85         [ 2] 2119         JP     ULESS
                                   2120 
                                   2121 
                                   2122 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2123 ; move parse to next char 
                                   2124 ; input:
                                   2125 ;   a    string pointer 
                                   2126 ;   cnt  string length 
                                   2127 ; output:
                                   2128 ;    a    a+1 
                                   2129 ;    cnt  cnt-1
                                   2130 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00B88A                       2131 NEXT_CHAR:: ; ( a cnt -- a cnt )
                                   2132 ; increment a 
      00B88A 6C 03            [ 1] 2133     INC (CELLL+1,X) 
      00B88C 26 02            [ 1] 2134     JRNE 1$
      00B88E 6C 02            [ 1] 2135     INC (CELLL,X)
      00B890                       2136 1$: ; decrement cnt 
      00B890 90 93            [ 1] 2137     LDW Y,X 
      00B892 90 FE            [ 2] 2138     LDW Y,(Y)
      00B894 90 5A            [ 2] 2139     DECW Y 
      00B896 FF               [ 2] 2140     LDW (X),Y
      00B897 81               [ 4] 2141     RET 
                                   2142 
                                   2143 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2144 ; check if first character of string
                                   2145 ; is 'c' 
                                   2146 ; if true 
                                   2147 ;     return  a++ cnt-- -1  
                                   2148 ; else 
                                   2149 ;   return a cnt 0 
                                   2150 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00B898                       2151 ACCEPT_CHAR:: ; ( a cnt c -- a cnt 0|-1 )
      00B898 CD AF A7         [ 4] 2152     CALL TOR ; a cnt r: c 
                                   2153 ; exit if end of string, cnt==0? 
      00B89B E6 01            [ 1] 2154     LD A,(1,X) ; cnt always < 256 
      00B89D 26 02            [ 1] 2155     JRNE 1$
      00B89F 20 15            [ 2] 2156     JRA 2$ 
      00B8A1 90 93            [ 1] 2157 1$: LDW Y,X 
      00B8A3 90 EE 02         [ 2] 2158     LDW Y,(CELLL,Y) ; a 
      00B8A6 90 F6            [ 1] 2159     LD A,(Y)
      00B8A8 11 02            [ 1] 2160     CP A,(2,SP) ; c 
      00B8AA 26 0A            [ 1] 2161     JRNE 2$
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 93.
Hexadecimal [24-Bits]



                                   2162 ; accept c
      00B8AC CD B8 8A         [ 4] 2163     CALL NEXT_CHAR      
      000C3D                       2164     _DOLIT -1
      00B8AF CD AE 34         [ 4]    1     CALL DOLIT 
      00B8B2 FF FF                    2     .word -1 
      00B8B4 20 05            [ 2] 2165     JRA 4$  
      00B8B6                       2166 2$: ; ignore char 
      000C44                       2167     _DOLIT 0
      00B8B6 CD AE 34         [ 4]    1     CALL DOLIT 
      00B8B9 00 00                    2     .word 0 
      00B8BB 5B 02            [ 2] 2168 4$: ADDW SP,#CELLL ; drop c 
      00B8BD 81               [ 4] 2169     RET 
                                   2170 
                                   2171 ;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2172 ; check for negative sign 
                                   2173 ; ajust pointer and cnt
                                   2174 ; input:
                                   2175 ;    a        string pointer 
                                   2176 ;    cnt      string length
                                   2177 ; output:
                                   2178 ;    a       adjusted pointer 
                                   2179 ;    cnt     adjusted count
                                   2180 ;    f       boolean flag, true if '-'  
                                   2181 ;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00B8BE                       2182 NSIGN: ; ( a cnt -- a cnt f ) 
      00B8BE 1D 00 02         [ 2] 2183     SUBW X,#CELLL ; a cntr f 
      00B8C1 4B 00            [ 1] 2184     PUSH #0 
                                   2185 ; if count==0 exit 
      00B8C3 E6 03            [ 1] 2186     LD A,(CELLL+1,X)
      00B8C5 27 1A            [ 1] 2187     JREQ NO_ADJ 
      00B8C7 90 93            [ 1] 2188     LDW Y,X 
      00B8C9 90 EE 04         [ 2] 2189     LDW Y,(2*CELLL,Y) ; a 
      00B8CC 90 F6            [ 1] 2190     LD A,(Y) ; char=*a  
      00B8CE A1 2D            [ 1] 2191     CP A,#'-' 
      00B8D0 27 07            [ 1] 2192     JREQ NEG_SIGN
      00B8D2 A1 2B            [ 1] 2193     CP A,#'+' 
      00B8D4 27 05            [ 1] 2194     JREQ ADJ_CSTRING
      00B8D6 CC B8 E1         [ 2] 2195     JP NO_ADJ  
      00B8D9                       2196 NEG_SIGN:
      00B8D9 03 01            [ 1] 2197     CPL (1,SP)
      00B8DB                       2198 ADJ_CSTRING: 
                                   2199 ; increment a 
      00B8DB 90 5C            [ 1] 2200     INCW Y ; a++ 
      00B8DD EF 04            [ 2] 2201     LDW (2*CELLL,X),Y 
                                   2202 ; decrement cnt 
      00B8DF 6A 03            [ 1] 2203     DEC (CELLL+1,X)    
      00B8E1                       2204 NO_ADJ: 
      00B8E1 84               [ 1] 2205     POP A 
      00B8E2 F7               [ 1] 2206     LD (X),A 
      00B8E3 E7 01            [ 1] 2207     LD (1,X),A 
      00B8E5 81               [ 4] 2208     RET 
                                   2209 
                           000001  2210 .ifeq  WANT_DOUBLE  
                                   2211 ; this code included only if WANT_DOUBLE=0
                                   2212 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 94.
Hexadecimal [24-Bits]



                                   2213 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2214 ; skip digits,stop at first non digit.
                                   2215 ; count skipped digits 
                                   2216 ; input:
                                   2217 ;    a     string address 
                                   2218 ;    cnt   charaters left in string 
                                   2219 ; output:
                                   2220 ;    a+         updated a 
                                   2221 ;    cnt-       updated cnt
                                   2222 ;    skip       digits skipped 
                                   2223 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
                                   2224 ; local variables
                           000001  2225         CNT = 1 ; byte
                           000002  2226         SKIP = 2 ; byte 
                           000002  2227         VARS_SIZE=2        
      00B8E6                       2228 SKIP_DIGITS: ; ( a cnt -- a+ cnt- skip )
      000C74                       2229         _VARS VARS_SIZE ; space on rstack for local vars 
      00B8E6 52 02            [ 2]    1     sub sp,#VARS_SIZE 
      00B8E8 0F 02            [ 1] 2230         CLR (SKIP,SP)
      00B8EA E6 01            [ 1] 2231         LD A,(1,X); cnt 
      00B8EC 6B 01            [ 1] 2232         LD (CNT,SP),A 
      000C7C                       2233         _TDROP ; drop cnt from stack 
      00B8EE 1C 00 02         [ 2]    1     ADDW X,#CELLL  
      00B8F1 0D 01            [ 1] 2234 1$:     TNZ (CNT,SP)
      00B8F3 27 20            [ 1] 2235         JREQ 8$
      00B8F5 CD B6 47         [ 4] 2236         CALL COUNT  
      00B8F8 CD B0 A2         [ 4] 2237         CALL BASE 
      00B8FB CD AE A8         [ 4] 2238         CALL AT 
      00B8FE CD B8 50         [ 4] 2239         CALL DIGTQ 
      000C8F                       2240         _QBRAN 6$ ; not a digit
      00B901 CD AE 5D         [ 4]    1     CALL QBRAN
      00B904 B9 0F                    2     .word 6$
      00B906 0C 02            [ 1] 2241         INC (SKIP,SP)
      00B908 0A 01            [ 1] 2242         DEC (CNT,SP)
      000C98                       2243         _TDROP ; c 
      00B90A 1C 00 02         [ 2]    1     ADDW X,#CELLL  
      00B90D 20 E2            [ 2] 2244         JRA 1$ 
      000C9D                       2245 6$:     _TDROP ; c 
      00B90F 1C 00 02         [ 2]    1     ADDW X,#CELLL  
      00B912 CD B5 25         [ 4] 2246         CALL ONEM ; a--         
      00B915 1D 00 04         [ 2] 2247 8$:     SUBW X,#2*CELLL ; space for cnt- 
      00B918 90 5F            [ 1] 2248         CLRW Y 
      00B91A 7B 02            [ 1] 2249         LD A,(SKIP,SP)
      00B91C 90 97            [ 1] 2250         LD YL,A 
      00B91E FF               [ 2] 2251         LDW (X),Y 
      00B91F 7B 01            [ 1] 2252         LD A,(CNT,SP)
      00B921 90 97            [ 1] 2253         LD YL,A 
      00B923 EF 02            [ 2] 2254         LDW (CELLL,X),Y ;  
      000CB3                       2255         _DROP_VARS VARS_SIZE ; discard local vars 
      00B925 5B 02            [ 2]    1     addw sp,#VARS_SIZE
      00B927 81               [ 4] 2256         RET 
                                   2257 
                                   2258 
                                   2259 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2260 ; get all digits in row 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 95.
Hexadecimal [24-Bits]



                                   2261 ; stop at first non-digit or end of string
                                   2262 ; ( n a cnt -- n  a+ cnt- digits )
                                   2263 ; input:
                                   2264 ;   n    initial value of integer 
                                   2265 ;   a    string address 
                                   2266 ;   cnt  # chars in string 
                                   2267 ; output:
                                   2268 ;   n    integer value after parse 
                                   2269 ;   a+   incremented a 
                                   2270 ;   cnt- decremented cnt 
                                   2271 ;   f_skip  -1 ->       some digits have been skip  
                                   2272 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2273 ; local variables 
                           000004  2274         SKIP=4 ;byte # digits skipped   
                           000002  2275         UINT=2   ;word 
                           000001  2276         CNT=1    ; byte 
                           000004  2277         VARS_SIZE=4
      00B928                       2278 parse_digits: ; ( n a cnt -- n  a+ cnt- skip )
      00B928 52 04            [ 2] 2279     SUB SP,#VARS_SIZE
      00B92A 0F 04            [ 1] 2280     CLR (SKIP,SP)
      00B92C E6 01            [ 1] 2281     LD A,(1,X) ; count 
      00B92E 6B 01            [ 1] 2282     LD (CNT,SP),A 
      000CBE                       2283     _TDROP ; drop cnt from stack 
      00B930 1C 00 02         [ 2]    1     ADDW X,#CELLL  
      00B933 90 93            [ 1] 2284     LDW Y,X 
      00B935 90 EE 02         [ 2] 2285     LDW Y,(CELLL,Y) ; n 
      00B938 17 02            [ 2] 2286     LDW (UINT,SP),Y  
      00B93A                       2287 0$:
      00B93A 0D 01            [ 1] 2288     TNZ (CNT,SP)
      00B93C 27 73            [ 1] 2289     JREQ 9$ 
      00B93E CD B6 47         [ 4] 2290 1$: CALL COUNT ; n a+ char 
      00B941 CD B0 A2         [ 4] 2291     CALL BASE 
      00B944 CD AE A8         [ 4] 2292     CALL AT 
      00B947 CD B8 50         [ 4] 2293     CALL DIGTQ 
      000CD8                       2294     _QBRAN 8$ ; not a digit
      00B94A CD AE 5D         [ 4]    1     CALL QBRAN
      00B94D B9 AB                    2     .word 8$
      00B94F 0A 01            [ 1] 2295     DEC (CNT,SP)
      00B951 1D 00 02         [ 2] 2296     SUBW X,#CELLL 
      00B954 16 02            [ 2] 2297     LDW Y,(UINT,SP)
      00B956 FF               [ 2] 2298     LDW (X),Y 
      00B957 CD B0 A2         [ 4] 2299     CALL BASE 
      00B95A CD AE A8         [ 4] 2300     CALL AT 
      00B95D CD B4 4C         [ 4] 2301     CALL UMSTA ; u u -- ud 
                                   2302 ; check for overflow 
      00B960 90 93            [ 1] 2303     LDW Y,X 
      00B962 90 FE            [ 2] 2304     LDW Y,(Y)
      000CF2                       2305     _TDROP ; ud hi word 
      00B964 1C 00 02         [ 2]    1     ADDW X,#CELLL  
      00B967 90 5D            [ 2] 2306     TNZW Y 
      00B969 27 32            [ 1] 2307     JREQ 4$ ; no overflow yet 
                                   2308 ; when overflow count following digits 
                                   2309 ; but don't integrate them in UINT 
                                   2310 ; round last value of UINT 
      000CF9                       2311     _TDROP  ; ud low word 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 96.
Hexadecimal [24-Bits]



      00B96B 1C 00 02         [ 2]    1     ADDW X,#CELLL  
      00B96E CD B0 A2         [ 4] 2312     CALL BASE
      00B971 CD AE A8         [ 4] 2313     CALL AT  
      00B974 CD B5 6A         [ 4] 2314     CALL TWOSL 
      00B977 CD B2 9B         [ 4] 2315     CALL LESS ; last_digit < BASE/2 ? 
      000D08                       2316     _TBRAN 2$  ; no rounding 
      00B97A CD AE 6B         [ 4]    1     CALL TBRAN 
      00B97D B9 85                    2     .word 2$ 
                                   2317 ; round up UINT 
      00B97F 16 02            [ 2] 2318     LDW Y,(UINT,SP)
      00B981 90 5C            [ 1] 2319     INCW Y 
      00B983 17 02            [ 2] 2320     LDW (UINT,SP),Y 
      00B985 CD B5 25         [ 4] 2321 2$: CALL ONEM ; a-- 
      00B988 0C 01            [ 1] 2322     INC (CNT,SP) ; cnt++
      00B98A 16 02            [ 2] 2323     LDW Y,(UINT,SP)
      00B98C EF 02            [ 2] 2324     LDW (CELLL,X),Y 
      00B98E 1D 00 02         [ 2] 2325     SUBW X,#CELLL ; space for count 
      00B991 7B 01            [ 1] 2326     LD A,(CNT,SP)
      00B993 90 5F            [ 1] 2327     CLRW Y 
      00B995 90 97            [ 1] 2328     LD YL,A 
      00B997 FF               [ 2] 2329     LDW (X),Y ; n a+ cnt- 
      00B998 CD B8 E6         [ 4] 2330     CALL SKIP_DIGITS ; n a+ cnt- skip  
      00B99B 20 28            [ 2] 2331     JRA 10$     
      00B99D                       2332 4$: 
      00B99D CD B1 B1         [ 4] 2333     CALL PLUS ; udlo+digit  
      00B9A0 90 93            [ 1] 2334     LDW Y,X 
      00B9A2 90 FE            [ 2] 2335     LDW Y,(Y) ; n 
      00B9A4 17 02            [ 2] 2336     LDW (UINT,SP),Y 
      000D34                       2337     _TDROP ; sum from stack 
      00B9A6 1C 00 02         [ 2]    1     ADDW X,#CELLL  
      00B9A9 20 8F            [ 2] 2338     JRA 0$ 
      00B9AB                       2339 8$: ; n a+ char
      000D39                       2340     _TDROP ; drop char 
      00B9AB 1C 00 02         [ 2]    1     ADDW X,#CELLL  
      00B9AE CD B5 25         [ 4] 2341     CALL ONEM ; decrement a 
      00B9B1                       2342 9$: ; no more digits 
      00B9B1 16 02            [ 2] 2343     LDW Y,(UINT,SP)
      00B9B3 EF 02            [ 2] 2344     LDW (CELLL,X),Y ; 
      00B9B5 1D 00 04         [ 2] 2345     SUBW X,#2*CELLL ; make space for cnt- digits 
      00B9B8 7B 01            [ 1] 2346     LD A,(CNT,SP)
      00B9BA 90 5F            [ 1] 2347     CLRW Y 
      00B9BC 90 97            [ 1] 2348     LD YL,A 
      00B9BE EF 02            [ 2] 2349     LDW (CELLL,X),Y ; u a+ cnt- 
      00B9C0 7B 04            [ 1] 2350     LD A,(SKIP,SP)
      00B9C2 90 97            [ 1] 2351     LD YL,A 
      00B9C4 FF               [ 2] 2352     LDW (X),Y ; u a+ cnt- digits 
      00B9C5                       2353 10$:
      000D53                       2354     _DROP_VARS VARS_SIZE  ; dicard local variables 
      00B9C5 5B 04            [ 2]    1     addw sp,#VARS_SIZE
      00B9C7 81               [ 4] 2355     RET 
                                   2356 
                                   2357 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2358 ;       NUMBER? ( a -- n T | a F )
                                   2359 ;       Convert a number string to
                                   2360 ;       integer. Push a flag on tos.
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 97.
Hexadecimal [24-Bits]



                                   2361 ;  if integer parse fail because of extra 
                                   2362 ;  character in string and WANT_FLOAT24=1 
                                   2363 ;  in config.inc then jump to FLOAT? in
                                   2364 ;  float24.asm
                                   2365 ; 
                                   2366 ; accepted number format:
                                   2367 ;    decimal ::= ['-'|'+']dec_digits+
                                   2368 ;    hexadecimal ::= ['-'|'+']'$'hex_digits+
                                   2369 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000D56                       2370         _HEADER NUMBQ,7,"NUMBER?"
      00B9C8 B8 49                    1         .word LINK 
                           000D58     2         LINK=.
      00B9CA 07                       3         .byte 7  
      00B9CB 4E 55 4D 42 45 52 3F     4         .ascii "NUMBER?"
      00B9D2                          5         NUMBQ:
                                   2371 ; save BASE
      00B9D2 CD B0 A2         [ 4] 2372         CALL     BASE
      00B9D5 CD AE A8         [ 4] 2373         CALL     AT
      00B9D8 CD AF A7         [ 4] 2374         CALL     TOR
      00B9DB CD B5 84         [ 4] 2375         CALL     ZERO
      00B9DE CD B0 06         [ 4] 2376         CALL     OVER
      00B9E1 CD B6 47         [ 4] 2377         CALL     COUNT ; string length,  a 0 a+ cnt 
                                   2378 ; check for negative number 
      00B9E4 CD B8 BE         [ 4] 2379         CALL    NSIGN 
      00B9E7 CD AF A7         [ 4] 2380         CALL    TOR    ; save number sign 
                                   2381 ;  check hexadecimal character        
      000D78                       2382         _DOLIT  '$'
      00B9EA CD AE 34         [ 4]    1     CALL DOLIT 
      00B9ED 00 24                    2     .word '$' 
      00B9EF CD B8 98         [ 4] 2383         CALL    ACCEPT_CHAR 
      000D80                       2384         _QBRAN  1$ 
      00B9F2 CD AE 5D         [ 4]    1     CALL QBRAN
      00B9F5 B9 FA                    2     .word 1$
      00B9F7 CD B8 27         [ 4] 2385         CALL    HEX 
      00B9FA                       2386 1$: ; stack: a 0 a cnt r: base sign 
      00B9FA CD B9 28         [ 4] 2387         CALL     parse_digits ; a 0 a+ cnt- -- a n a+ cnt- skip R: base sign
      00B9FD CD B0 06         [ 4] 2388         CALL    OVER 
      000D8E                       2389         _TBRAN  NUMQ6 
      00BA00 CD AE 6B         [ 4]    1     CALL TBRAN 
      00BA03 BA 1D                    2     .word NUMQ6 
      000D93                       2390         _DROPN 3   ; a n  R: base sign 
      00BA05 1C 00 06         [ 2]    1     ADDW X,#3*CELLL 
      00BA08 CD AE F9         [ 4] 2391         CALL     RFROM   ; a n sign R: base 
      000D99                       2392         _QBRAN   NUMQ3
      00BA0B CD AE 5D         [ 4]    1     CALL QBRAN
      00BA0E BA 13                    2     .word NUMQ3
      00BA10 CD B1 FB         [ 4] 2393         CALL     NEGAT ; a n R: base 
      00BA13                       2394 NUMQ3:  
      00BA13 CD AF EE         [ 4] 2395         CALL    SWAPP ; n a 
      00BA16 90 AE FF FF      [ 2] 2396         LDW  Y, #-1 
      00BA1A FF               [ 2] 2397         LDW (X),Y     ; n -1 R: base 
      00BA1B 20 08            [ 2] 2398         JRA      NUMQ9
      00BA1D                       2399 NUMQ6:  
                           000000  2400 .if WANT_FLOAT24 
                                   2401 ; float24 installed try floating point number  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 98.
Hexadecimal [24-Bits]



                                   2402         JP    FLOATQ  ; a n a+ cnt- skip R: base sign   
                           000001  2403 .else ; error unknown token 
      000DAB                       2404         _RDROP ; remove sign from rstack 
      00BA1D 5B 02            [ 2]    1    ADDW SP,#CELLL
      00BA1F 1C 00 06         [ 2] 2405         ADDW  X,#3*CELLL ; drop a+ cnt skip S: a n  R: base  
      00BA22 90 5F            [ 1] 2406         CLRW Y  
      00BA24 FF               [ 2] 2407         LDW (X),Y  ;  a 0 R: base 
                                   2408 .endif 
                                   2409 ; restore BASE 
      00BA25                       2410 NUMQ9: 
      00BA25 CD AE F9         [ 4] 2411         CALL     RFROM
      00BA28 CD B0 A2         [ 4] 2412         CALL     BASE
      00BA2B CC AE 96         [ 2] 2413         JP       STORE
                                   2414 .endif ; WANT_DOUBLE   
                                   2415 
                                   2416 ;; Basic I/O
                                   2417 
                                   2418 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2419 ;       KEY     ( -- c )
                                   2420 ;       Wait for and return an
                                   2421 ;       input character.
                                   2422 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000DBC                       2423         _HEADER KEY,3,"KEY"
      00BA2E B9 CA                    1         .word LINK 
                           000DBE     2         LINK=.
      00BA30 03                       3         .byte 3  
      00BA31 4B 45 59                 4         .ascii "KEY"
      00BA34                          5         KEY:
      00BA34 CD 85 AC         [ 4] 2424         call uart_getc
      00BA37 1D 00 02         [ 2] 2425         SUBW X,#CELLL 
      00BA3A 7F               [ 1] 2426         CLR (X)
      00BA3B E7 01            [ 1] 2427         LD (1,X),A 
      00BA3D 81               [ 4] 2428         RET  
                                   2429 
                                   2430 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2431 ;       NUF?    ( -- t )
                                   2432 ;       Return false if no input,
                                   2433 ;       else pause and if CR return true.
                                   2434 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000DCC                       2435         _HEADER NUFQ,4,"NUF?"
      00BA3E BA 30                    1         .word LINK 
                           000DCE     2         LINK=.
      00BA40 04                       3         .byte 4  
      00BA41 4E 55 46 3F              4         .ascii "NUF?"
      00BA45                          5         NUFQ:
      00BA45 CD AD D8         [ 4] 2436         CALL     QKEY
      00BA48 CD AF DE         [ 4] 2437         CALL     DUPP
      00BA4B CD AE 5D         [ 4] 2438         CALL     QBRAN
      00BA4E BA 5E                 2439         .word    NUFQ1
      00BA50 CD B1 91         [ 4] 2440         CALL     DDROP
      00BA53 CD BA 34         [ 4] 2441         CALL     KEY
      00BA56 CD AE 34         [ 4] 2442         CALL     DOLIT
      00BA59 00 0D                 2443         .word      CRR
      00BA5B CC B2 6F         [ 2] 2444         JP     EQUAL
      00BA5E 81               [ 4] 2445 NUFQ1:  RET
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 99.
Hexadecimal [24-Bits]



                                   2446 
                                   2447 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2448 ;       SPACE   ( -- )
                                   2449 ;       Send  blank character to
                                   2450 ;       output device.
                                   2451 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000DED                       2452         _HEADER SPAC,5,"SPACE"
      00BA5F BA 40                    1         .word LINK 
                           000DEF     2         LINK=.
      00BA61 05                       3         .byte 5  
      00BA62 53 50 41 43 45           4         .ascii "SPACE"
      00BA67                          5         SPAC:
      00BA67 CD B5 77         [ 4] 2453         CALL     BLANK
      00BA6A CC AD FB         [ 2] 2454         JP     EMIT
                                   2455 
                                   2456 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2457 ;       SPACES  ( +n -- )
                                   2458 ;       Send n spaces to output device.
                                   2459 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000DFB                       2460         _HEADER SPACS,6,"SPACES"
      00BA6D BA 61                    1         .word LINK 
                           000DFD     2         LINK=.
      00BA6F 06                       3         .byte 6  
      00BA70 53 50 41 43 45 53        4         .ascii "SPACES"
      00BA76                          5         SPACS:
      00BA76 CD B5 84         [ 4] 2461         CALL     ZERO
      00BA79 CD B2 E0         [ 4] 2462         CALL     MAX
      00BA7C CD AF A7         [ 4] 2463         CALL     TOR
      00BA7F 20 03            [ 2] 2464         JRA      CHAR2
      00BA81 CD BA 67         [ 4] 2465 CHAR1:  CALL     SPAC
      00BA84 CD AE 48         [ 4] 2466 CHAR2:  CALL     DONXT
      00BA87 BA 81                 2467         .word    CHAR1
      00BA89 81               [ 4] 2468         RET
                                   2469 
                                   2470 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2471 ;       TYPE    ( b u -- )
                                   2472 ;       Output u characters from b.
                                   2473 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000E18                       2474         _HEADER TYPES,4,"TYPE"
      00BA8A BA 6F                    1         .word LINK 
                           000E1A     2         LINK=.
      00BA8C 04                       3         .byte 4  
      00BA8D 54 59 50 45              4         .ascii "TYPE"
      00BA91                          5         TYPES:
      00BA91 CD AF A7         [ 4] 2475         CALL     TOR
      00BA94 20 06            [ 2] 2476         JRA     TYPE2
      00BA96 CD B6 47         [ 4] 2477 TYPE1:  CALL     COUNT 
      00BA99 CD AD FB         [ 4] 2478         CALL     EMIT
      000E2A                       2479 TYPE2:  _DONXT  TYPE1
      00BA9C CD AE 48         [ 4]    1     CALL DONXT 
      00BA9F BA 96                    2     .word TYPE1 
      000E2F                       2480         _TDROP
      00BAA1 1C 00 02         [ 2]    1     ADDW X,#CELLL  
      00BAA4 81               [ 4] 2481         RET 
                                   2482 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 100.
Hexadecimal [24-Bits]



                                   2483 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2484 ;       CR      ( -- )
                                   2485 ;       Output a carriage return
                                   2486 ;       and a line feed.
                                   2487 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000E33                       2488         _HEADER CRLF,2,"CR"
      00BAA5 BA 8C                    1         .word LINK 
                           000E35     2         LINK=.
      00BAA7 02                       3         .byte 2  
      00BAA8 43 52                    4         .ascii "CR"
      00BAAA                          5         CRLF:
      000E38                       2489         _DOLIT  CRR 
      00BAAA CD AE 34         [ 4]    1     CALL DOLIT 
      00BAAD 00 0D                    2     .word CRR 
      00BAAF CD AD FB         [ 4] 2490         CALL    EMIT
      000E40                       2491         _DOLIT  LF
      00BAB2 CD AE 34         [ 4]    1     CALL DOLIT 
      00BAB5 00 0A                    2     .word LF 
      00BAB7 CC AD FB         [ 2] 2492         JP      EMIT
                                   2493 
                                   2494 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2495 ;       do$     ( -- a )
                                   2496 ;       Return  address of a compiled
                                   2497 ;       string.
                                   2498 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2499 ;       _HEADER DOSTR,COMPO+3,"DO$"
      00BABA                       2500 DOSTR:
      00BABA CD AE F9         [ 4] 2501         CALL     RFROM
      00BABD CD AF 0A         [ 4] 2502         CALL     RAT
      00BAC0 CD AE F9         [ 4] 2503         CALL     RFROM
      00BAC3 CD B6 47         [ 4] 2504         CALL     COUNT
      00BAC6 CD B1 B1         [ 4] 2505         CALL     PLUS
      00BAC9 CD AF A7         [ 4] 2506         CALL     TOR
      00BACC CD AF EE         [ 4] 2507         CALL     SWAPP
      00BACF CD AF A7         [ 4] 2508         CALL     TOR
      00BAD2 81               [ 4] 2509         RET
                                   2510 
                                   2511 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2512 ;       $"|     ( -- a )
                                   2513 ;       Run time routine compiled by $".
                                   2514 ;       Return address of a compiled string.
                                   2515 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2516 ;       _HEADER STRQP,COMPO+3,"$\"|"
      00BAD3                       2517 STRQP:
      00BAD3 CD BA BA         [ 4] 2518         CALL     DOSTR
      00BAD6 81               [ 4] 2519         RET
                                   2520 
                                   2521 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2522 ;       ."|     ( -- )
                                   2523 ;       Run time routine of ." .
                                   2524 ;       Output a compiled string.
                                   2525 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2526 ;       _HEADER DOTQP,COMPO+3,".\"|"
      00BAD7                       2527 DOTQP:
      00BAD7 CD BA BA         [ 4] 2528         CALL     DOSTR
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 101.
Hexadecimal [24-Bits]



      00BADA CD B6 47         [ 4] 2529         CALL     COUNT
      00BADD CC BA 91         [ 2] 2530         JP     TYPES
                                   2531 
                                   2532 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2533 ;       .R      ( n +n -- )
                                   2534 ;       Display an integer in a field
                                   2535 ;       of n columns, right justified.
                                   2536 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000E6E                       2537         _HEADER DOTR,2,".R"
      00BAE0 BA A7                    1         .word LINK 
                           000E70     2         LINK=.
      00BAE2 02                       3         .byte 2  
      00BAE3 2E 52                    4         .ascii ".R"
      00BAE5                          5         DOTR:
      00BAE5 CD AF A7         [ 4] 2538         CALL     TOR
      00BAE8 CD B8 09         [ 4] 2539         CALL     STR
      00BAEB CD AE F9         [ 4] 2540         CALL     RFROM
      00BAEE CD B0 06         [ 4] 2541         CALL     OVER
      00BAF1 CD B2 47         [ 4] 2542         CALL     SUBB
      00BAF4 CD BA 76         [ 4] 2543         CALL     SPACS
      00BAF7 CC BA 91         [ 2] 2544         JP     TYPES
                                   2545 
                                   2546 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2547 ;       U.R     ( u +n -- )
                                   2548 ;       Display an unsigned integer
                                   2549 ;       in n column, right justified.
                                   2550 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000E88                       2551         _HEADER UDOTR,3,"U.R"
      00BAFA BA E2                    1         .word LINK 
                           000E8A     2         LINK=.
      00BAFC 03                       3         .byte 3  
      00BAFD 55 2E 52                 4         .ascii "U.R"
      00BB00                          5         UDOTR:
      00BB00 CD AF A7         [ 4] 2552         CALL     TOR
      00BB03 CD B7 8C         [ 4] 2553         CALL     BDIGS
      00BB06 CD B7 C6         [ 4] 2554         CALL     DIGS
      00BB09 CD B7 F1         [ 4] 2555         CALL     EDIGS
      00BB0C CD AE F9         [ 4] 2556         CALL     RFROM
      00BB0F CD B0 06         [ 4] 2557         CALL     OVER
      00BB12 CD B2 47         [ 4] 2558         CALL     SUBB
      00BB15 CD BA 76         [ 4] 2559         CALL     SPACS
      00BB18 CC BA 91         [ 2] 2560         JP     TYPES
                                   2561 
                                   2562 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2563 ;       U.      ( u -- )
                                   2564 ;       Display an unsigned integer
                                   2565 ;       in free format.
                                   2566 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000EA9                       2567         _HEADER UDOT,2,"U."
      00BB1B BA FC                    1         .word LINK 
                           000EAB     2         LINK=.
      00BB1D 02                       3         .byte 2  
      00BB1E 55 2E                    4         .ascii "U."
      00BB20                          5         UDOT:
      00BB20 CD B7 8C         [ 4] 2568         CALL     BDIGS
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 102.
Hexadecimal [24-Bits]



      00BB23 CD B7 C6         [ 4] 2569         CALL     DIGS
      00BB26 CD B7 F1         [ 4] 2570         CALL     EDIGS
      00BB29 CD BA 67         [ 4] 2571         CALL     SPAC
      00BB2C CC BA 91         [ 2] 2572         JP     TYPES
                                   2573 
                                   2574 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2575 ;   H. ( n -- )
                                   2576 ;   display n in hexadecimal 
                                   2577 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000EBD                       2578         _HEADER HDOT,2,"H."
      00BB2F BB 1D                    1         .word LINK 
                           000EBF     2         LINK=.
      00BB31 02                       3         .byte 2  
      00BB32 48 2E                    4         .ascii "H."
      00BB34                          5         HDOT:
      00BB34 CD B0 A2         [ 4] 2579         CALL BASE 
      00BB37 CD AE A8         [ 4] 2580         CALL AT 
      00BB3A CD AF A7         [ 4] 2581         CALL TOR 
      00BB3D CD B8 27         [ 4] 2582         CALL HEX 
      00BB40 CD BB 20         [ 4] 2583         CALL UDOT 
      00BB43 CD AE F9         [ 4] 2584         CALL RFROM 
      00BB46 CD B0 A2         [ 4] 2585         CALL BASE 
      00BB49 CC AE 96         [ 2] 2586         JP STORE 
                                   2587          
                                   2588 
                                   2589 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2590 ;       .       ( w -- )
                                   2591 ;       Display an integer in free
                                   2592 ;       format, preceeded by a space.
                                   2593 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000EDA                       2594         _HEADER DOT,1,"."
      00BB4C BB 31                    1         .word LINK 
                           000EDC     2         LINK=.
      00BB4E 01                       3         .byte 1  
      00BB4F 2E                       4         .ascii "."
      00BB50                          5         DOT:
      00BB50 CD B0 A2         [ 4] 2595         CALL     BASE
      00BB53 CD AE A8         [ 4] 2596         CALL     AT
      00BB56 CD AE 34         [ 4] 2597         CALL     DOLIT
      00BB59 00 0A                 2598         .word      10
      00BB5B CD B0 64         [ 4] 2599         CALL     XORR    ;?decimal
      00BB5E CD AE 5D         [ 4] 2600         CALL     QBRAN
      00BB61 BB 65                 2601         .word      DOT1
      00BB63 20 BB            [ 2] 2602         JRA     UDOT
      00BB65 CD B8 09         [ 4] 2603 DOT1:   CALL     STR
      00BB68 CD BA 67         [ 4] 2604         CALL     SPAC
      00BB6B CC BA 91         [ 2] 2605         JP     TYPES
                                   2606 
                                   2607 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2608 ;       ?       ( a -- )
                                   2609 ;       Display contents in memory cell.
                                   2610 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000EFC                       2611         _HEADER QUEST,1,"?"
      00BB6E BB 4E                    1         .word LINK 
                           000EFE     2         LINK=.
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 103.
Hexadecimal [24-Bits]



      00BB70 01                       3         .byte 1  
      00BB71 3F                       4         .ascii "?"
      00BB72                          5         QUEST:
      00BB72 CD AE A8         [ 4] 2612         CALL     AT
      00BB75 20 D9            [ 2] 2613         JRA     DOT
                                   2614 
                                   2615 ;; Parsing
                                   2616 
                                   2617 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2618 ;       parse   ( b u c -- b u delta ; <string> )
                                   2619 ;       Scan string delimited by c.
                                   2620 ;       Return found string and its offset.
                                   2621 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000F05                       2622         _HEADER PARS,5,"PARS$"
      00BB77 BB 70                    1         .word LINK 
                           000F07     2         LINK=.
      00BB79 05                       3         .byte 5  
      00BB7A 50 41 52 53 24           4         .ascii "PARS$"
      00BB7F                          5         PARS:
      00BB7F CD B0 B1         [ 4] 2623         CALL     TEMP
      00BB82 CD AE 96         [ 4] 2624         CALL     STORE
      00BB85 CD B0 06         [ 4] 2625         CALL     OVER
      00BB88 CD AF A7         [ 4] 2626         CALL     TOR
      00BB8B CD AF DE         [ 4] 2627         CALL     DUPP
      00BB8E CD AE 5D         [ 4] 2628         CALL     QBRAN
      00BB91 BC 37                 2629         .word    PARS8
      00BB93 CD B5 25         [ 4] 2630         CALL     ONEM
      00BB96 CD B0 B1         [ 4] 2631         CALL     TEMP
      00BB99 CD AE A8         [ 4] 2632         CALL     AT
      00BB9C CD B5 77         [ 4] 2633         CALL     BLANK
      00BB9F CD B2 6F         [ 4] 2634         CALL     EQUAL
      00BBA2 CD AE 5D         [ 4] 2635         CALL     QBRAN
      00BBA5 BB D8                 2636         .word      PARS3
      00BBA7 CD AF A7         [ 4] 2637         CALL     TOR
      00BBAA CD B5 77         [ 4] 2638 PARS1:  CALL     BLANK
      00BBAD CD B0 06         [ 4] 2639         CALL     OVER
      00BBB0 CD AE C6         [ 4] 2640         CALL     CAT     ;skip leading blanks ONLY
      00BBB3 CD B2 47         [ 4] 2641         CALL     SUBB
      00BBB6 CD B0 15         [ 4] 2642         CALL     ZLESS
      00BBB9 CD B1 EA         [ 4] 2643         CALL     INVER
      00BBBC CD AE 5D         [ 4] 2644         CALL     QBRAN
      00BBBF BB D5                 2645         .word      PARS2
      00BBC1 CD B5 18         [ 4] 2646         CALL     ONEP
      00BBC4 CD AE 48         [ 4] 2647         CALL     DONXT
      00BBC7 BB AA                 2648         .word      PARS1
      00BBC9 CD AE F9         [ 4] 2649         CALL     RFROM
      00BBCC CD AF D4         [ 4] 2650         CALL     DROP
      00BBCF CD B5 84         [ 4] 2651         CALL     ZERO
      00BBD2 CC AF DE         [ 2] 2652         JP     DUPP
      00BBD5 CD AE F9         [ 4] 2653 PARS2:  CALL     RFROM
      00BBD8 CD B0 06         [ 4] 2654 PARS3:  CALL     OVER
      00BBDB CD AF EE         [ 4] 2655         CALL     SWAPP
      00BBDE CD AF A7         [ 4] 2656         CALL     TOR
      00BBE1 CD B0 B1         [ 4] 2657 PARS4:  CALL     TEMP
      00BBE4 CD AE A8         [ 4] 2658         CALL     AT
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 104.
Hexadecimal [24-Bits]



      00BBE7 CD B0 06         [ 4] 2659         CALL     OVER
      00BBEA CD AE C6         [ 4] 2660         CALL     CAT
      00BBED CD B2 47         [ 4] 2661         CALL     SUBB    ;scan for delimiter
      00BBF0 CD B0 B1         [ 4] 2662         CALL     TEMP
      00BBF3 CD AE A8         [ 4] 2663         CALL     AT
      00BBF6 CD B5 77         [ 4] 2664         CALL     BLANK
      00BBF9 CD B2 6F         [ 4] 2665         CALL     EQUAL
      00BBFC CD AE 5D         [ 4] 2666         CALL     QBRAN
      00BBFF BC 04                 2667         .word      PARS5
      00BC01 CD B0 15         [ 4] 2668         CALL     ZLESS
      00BC04 CD AE 5D         [ 4] 2669 PARS5:  CALL     QBRAN
      00BC07 BC 19                 2670         .word      PARS6
      00BC09 CD B5 18         [ 4] 2671         CALL     ONEP
      00BC0C CD AE 48         [ 4] 2672         CALL     DONXT
      00BC0F BB E1                 2673         .word      PARS4
      00BC11 CD AF DE         [ 4] 2674         CALL     DUPP
      00BC14 CD AF A7         [ 4] 2675         CALL     TOR
      00BC17 20 0F            [ 2] 2676         JRA     PARS7
      00BC19 CD AE F9         [ 4] 2677 PARS6:  CALL     RFROM
      00BC1C CD AF D4         [ 4] 2678         CALL     DROP
      00BC1F CD AF DE         [ 4] 2679         CALL     DUPP
      00BC22 CD B5 18         [ 4] 2680         CALL     ONEP
      00BC25 CD AF A7         [ 4] 2681         CALL     TOR
      00BC28 CD B0 06         [ 4] 2682 PARS7:  CALL     OVER
      00BC2B CD B2 47         [ 4] 2683         CALL     SUBB
      00BC2E CD AE F9         [ 4] 2684         CALL     RFROM
      00BC31 CD AE F9         [ 4] 2685         CALL     RFROM
      00BC34 CC B2 47         [ 2] 2686         JP     SUBB
      00BC37 CD B0 06         [ 4] 2687 PARS8:  CALL     OVER
      00BC3A CD AE F9         [ 4] 2688         CALL     RFROM
      00BC3D CC B2 47         [ 2] 2689         JP     SUBB
                                   2690 
                                   2691 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2692 ;       PARSE   ( c -- b u ; <string> )
                                   2693 ;       Scan input stream and return
                                   2694 ;       counted string delimited by c.
                                   2695 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000FCE                       2696         _HEADER PARSE,5,"PARSE"
      00BC40 BB 79                    1         .word LINK 
                           000FD0     2         LINK=.
      00BC42 05                       3         .byte 5  
      00BC43 50 41 52 53 45           4         .ascii "PARSE"
      00BC48                          5         PARSE:
      00BC48 CD AF A7         [ 4] 2697         CALL     TOR
      00BC4B CD B6 80         [ 4] 2698         CALL     TIB
      00BC4E CD B0 C0         [ 4] 2699         CALL     INN
      00BC51 CD AE A8         [ 4] 2700         CALL     AT
      00BC54 CD B1 B1         [ 4] 2701         CALL     PLUS    ;current input buffer pointer
      00BC57 CD B0 D0         [ 4] 2702         CALL     NTIB
      00BC5A CD AE A8         [ 4] 2703         CALL     AT
      00BC5D CD B0 C0         [ 4] 2704         CALL     INN
      00BC60 CD AE A8         [ 4] 2705         CALL     AT
      00BC63 CD B2 47         [ 4] 2706         CALL     SUBB    ;remaining count
      00BC66 CD AE F9         [ 4] 2707         CALL     RFROM
      00BC69 CD BB 7F         [ 4] 2708         CALL     PARS
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 105.
Hexadecimal [24-Bits]



      00BC6C CD B0 C0         [ 4] 2709         CALL     INN
      00BC6F CC B5 F4         [ 2] 2710         JP     PSTOR
                                   2711 
                                   2712 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2713 ;       .(      ( -- )
                                   2714 ;       Output following string up to next ) .
                                   2715 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001000                       2716         _HEADER DOTPR,IMEDD+2,".("
      00BC72 BC 42                    1         .word LINK 
                           001002     2         LINK=.
      00BC74 82                       3         .byte IMEDD+2  
      00BC75 2E 28                    4         .ascii ".("
      00BC77                          5         DOTPR:
      00BC77 CD AE 34         [ 4] 2717         CALL     DOLIT
      00BC7A 00 29                 2718         .word     41	; ")"
      00BC7C CD BC 48         [ 4] 2719         CALL     PARSE
      00BC7F CC BA 91         [ 2] 2720         JP     TYPES
                                   2721 
                                   2722 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2723 ;       (       ( -- )
                                   2724 ;       Ignore following string up to next ).
                                   2725 ;       A comment.
                                   2726 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001010                       2727         _HEADER PAREN,IMEDD+1,"("
      00BC82 BC 74                    1         .word LINK 
                           001012     2         LINK=.
      00BC84 81                       3         .byte IMEDD+1  
      00BC85 28                       4         .ascii "("
      00BC86                          5         PAREN:
      00BC86 CD AE 34         [ 4] 2728         CALL     DOLIT
      00BC89 00 29                 2729         .word     41	; ")"
      00BC8B CD BC 48         [ 4] 2730         CALL     PARSE
      00BC8E CC B1 91         [ 2] 2731         JP     DDROP
                                   2732 
                                   2733 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2734 ;       \       ( -- )
                                   2735 ;       Ignore following text till
                                   2736 ;       end of line.
                                   2737 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00101F                       2738         _HEADER BKSLA,IMEDD+1,'\'
      00BC91 BC 84                    1         .word LINK 
                           001021     2         LINK=.
      00BC93 81                       3         .byte IMEDD+1  
      00BC94 5C                       4         .ascii '\'
      00BC95                          5         BKSLA:
                                   2739 
      00BC95 45 39 37         [ 1] 2740         mov UINN+1,UCTIB+1
      00BC98 81               [ 4] 2741         ret 
                                   2742 
                                   2743 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2744 ;       WORD    ( c -- a ; <string> )
                                   2745 ;       Parse a word from input stream
                                   2746 ;       and copy it to code dictionary.
                                   2747 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001027                       2748         _HEADER WORDD,4,"WORD"
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 106.
Hexadecimal [24-Bits]



      00BC99 BC 93                    1         .word LINK 
                           001029     2         LINK=.
      00BC9B 04                       3         .byte 4  
      00BC9C 57 4F 52 44              4         .ascii "WORD"
      00BCA0                          5         WORDD:
      00BCA0 CD BC 48         [ 4] 2749         CALL     PARSE
      00BCA3 CD B6 5E         [ 4] 2750         CALL     HERE
      00BCA6 CD B4 ED         [ 4] 2751         CALL     CELLP
                           000000  2752 .IF CASE_SENSE 
                                   2753         JP      PACKS 
                           000001  2754 .ELSE                 
      00BCA9 CD B7 2F         [ 4] 2755         CALL     PACKS
                                   2756 ; uppercase TOKEN 
      00BCAC CD AF DE         [ 4] 2757         CALL    DUPP 
      00BCAF CD B6 47         [ 4] 2758         CALL    COUNT 
      00BCB2 CD AF A7         [ 4] 2759         CALL    TOR 
      00BCB5 CD AE 79         [ 4] 2760         CALL    BRAN 
      00BCB8 BC E6                 2761         .word   UPPER2  
      00BCBA                       2762 UPPER:
      00BCBA CD AF DE         [ 4] 2763         CALL    DUPP 
      00BCBD CD AE C6         [ 4] 2764         CALL    CAT
      00BCC0 CD AF DE         [ 4] 2765         CALL    DUPP 
      00BCC3 CD AE 34         [ 4] 2766         CALL   DOLIT
      00BCC6 00 61                 2767         .word   'a' 
      00BCC8 CD AE 34         [ 4] 2768         CALL    DOLIT
      00BCCB 00 7B                 2769         .word   'z'+1 
      00BCCD CD B3 0B         [ 4] 2770         CALL   WITHI 
      00BCD0 CD AE 5D         [ 4] 2771         CALL   QBRAN
      00BCD3 BC DD                 2772         .word  UPPER1  
      00BCD5 CD AE 34         [ 4] 2773         CALL    DOLIT 
      00BCD8 00 DF                 2774         .word   0xDF 
      00BCDA CD B0 3B         [ 4] 2775         CALL    ANDD 
      00BCDD                       2776 UPPER1:
      00BCDD CD B0 06         [ 4] 2777         CALL    OVER 
      00BCE0 CD AE B5         [ 4] 2778         CALL    CSTOR          
      00BCE3 CD B5 18         [ 4] 2779         CALL    ONEP 
      00BCE6                       2780 UPPER2: 
      00BCE6 CD AE 48         [ 4] 2781         CALL    DONXT
      00BCE9 BC BA                 2782         .word   UPPER  
      00BCEB CD AF D4         [ 4] 2783         CALL    DROP  
      00BCEE 81               [ 4] 2784         RET 
                                   2785 .ENDIF 
                                   2786 
                                   2787 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2788 ;       TOKEN   ( -- a ; <string> )
                                   2789 ;       Parse a word from input stream
                                   2790 ;       and copy it to name dictionary.
                                   2791 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00107D                       2792         _HEADER TOKEN,5,"TOKEN"
      00BCEF BC 9B                    1         .word LINK 
                           00107F     2         LINK=.
      00BCF1 05                       3         .byte 5  
      00BCF2 54 4F 4B 45 4E           4         .ascii "TOKEN"
      00BCF7                          5         TOKEN:
      00BCF7 CD B5 77         [ 4] 2793         CALL     BLANK
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 107.
Hexadecimal [24-Bits]



      00BCFA CC BC A0         [ 2] 2794         JP     WORDD
                                   2795 
                                   2796 ;; Dictionary search
                                   2797 
                                   2798 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2799 ;       NAME>   ( na -- ca )
                                   2800 ;       Return a code address given
                                   2801 ;       a name address.
                                   2802 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00108B                       2803         _HEADER NAMET,5,"NAME>"
      00BCFD BC F1                    1         .word LINK 
                           00108D     2         LINK=.
      00BCFF 05                       3         .byte 5  
      00BD00 4E 41 4D 45 3E           4         .ascii "NAME>"
      00BD05                          5         NAMET:
      00BD05 CD B6 47         [ 4] 2804         CALL     COUNT
      00BD08 CD AE 34         [ 4] 2805         CALL     DOLIT
      00BD0B 00 1F                 2806         .word      31
      00BD0D CD B0 3B         [ 4] 2807         CALL     ANDD
      00BD10 CC B1 B1         [ 2] 2808         JP     PLUS
                                   2809 
                                   2810 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2811 ;       SAME?   ( a a u -- a a f \ -0+ )
                                   2812 ;       Compare u cells in two
                                   2813 ;       strings. Return 0 if identical.
                                   2814 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0010A1                       2815         _HEADER SAMEQ,5,"SAME?"
      00BD13 BC FF                    1         .word LINK 
                           0010A3     2         LINK=.
      00BD15 05                       3         .byte 5  
      00BD16 53 41 4D 45 3F           4         .ascii "SAME?"
      00BD1B                          5         SAMEQ:
      00BD1B CD B5 25         [ 4] 2816         CALL     ONEM
      00BD1E CD AF A7         [ 4] 2817         CALL     TOR
      00BD21 20 29            [ 2] 2818         JRA     SAME2
      00BD23 CD B0 06         [ 4] 2819 SAME1:  CALL     OVER
      00BD26 CD AF 0A         [ 4] 2820         CALL     RAT
      00BD29 CD B1 B1         [ 4] 2821         CALL     PLUS
      00BD2C CD AE C6         [ 4] 2822         CALL     CAT
      00BD2F CD B0 06         [ 4] 2823         CALL     OVER
      00BD32 CD AF 0A         [ 4] 2824         CALL     RAT
      00BD35 CD B1 B1         [ 4] 2825         CALL     PLUS
      00BD38 CD AE C6         [ 4] 2826         CALL     CAT
      00BD3B CD B2 47         [ 4] 2827         CALL     SUBB
      00BD3E CD B1 41         [ 4] 2828         CALL     QDUP
      00BD41 CD AE 5D         [ 4] 2829         CALL     QBRAN
      00BD44 BD 4C                 2830         .word      SAME2
      00BD46 CD AE F9         [ 4] 2831         CALL     RFROM
      00BD49 CC AF D4         [ 2] 2832         JP     DROP
      00BD4C CD AE 48         [ 4] 2833 SAME2:  CALL     DONXT
      00BD4F BD 23                 2834         .word      SAME1
      00BD51 CC B5 84         [ 2] 2835         JP     ZERO
                                   2836 
                                   2837 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2838 ;       find    ( a va -- ca na | a F )
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 108.
Hexadecimal [24-Bits]



                                   2839 ;       Search vocabulary for string.
                                   2840 ;       Return ca and na if succeeded.
                                   2841 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0010E2                       2842         _HEADER FIND,4,"FIND"
      00BD54 BD 15                    1         .word LINK 
                           0010E4     2         LINK=.
      00BD56 04                       3         .byte 4  
      00BD57 46 49 4E 44              4         .ascii "FIND"
      00BD5B                          5         FIND:
      00BD5B CD AF EE         [ 4] 2843         CALL     SWAPP
      00BD5E CD AF DE         [ 4] 2844         CALL     DUPP
      00BD61 CD AE C6         [ 4] 2845         CALL     CAT
      00BD64 CD B0 B1         [ 4] 2846         CALL     TEMP
      00BD67 CD AE 96         [ 4] 2847         CALL     STORE
      00BD6A CD AF DE         [ 4] 2848         CALL     DUPP
      00BD6D CD AE A8         [ 4] 2849         CALL     AT
      00BD70 CD AF A7         [ 4] 2850         CALL     TOR
      00BD73 CD B4 ED         [ 4] 2851         CALL     CELLP
      00BD76 CD AF EE         [ 4] 2852         CALL     SWAPP
      00BD79 CD AE A8         [ 4] 2853 FIND1:  CALL     AT
      00BD7C CD AF DE         [ 4] 2854         CALL     DUPP
      00BD7F CD AE 5D         [ 4] 2855         CALL     QBRAN
      00BD82 BD B8                 2856         .word      FIND6
      00BD84 CD AF DE         [ 4] 2857         CALL     DUPP
      00BD87 CD AE A8         [ 4] 2858         CALL     AT
      00BD8A CD AE 34         [ 4] 2859         CALL     DOLIT
      00BD8D 1F 7F                 2860         .word      MASKK
      00BD8F CD B0 3B         [ 4] 2861         CALL     ANDD
      00BD92 CD AF 0A         [ 4] 2862         CALL     RAT
      00BD95 CD B0 64         [ 4] 2863         CALL     XORR
      00BD98 CD AE 5D         [ 4] 2864         CALL     QBRAN
      00BD9B BD A7                 2865         .word      FIND2
      00BD9D CD B4 ED         [ 4] 2866         CALL     CELLP
      00BDA0 CD AE 34         [ 4] 2867         CALL     DOLIT
      00BDA3 FF FF                 2868         .word     0xFFFF
      00BDA5 20 0C            [ 2] 2869         JRA     FIND3
      00BDA7 CD B4 ED         [ 4] 2870 FIND2:  CALL     CELLP
      00BDAA CD B0 B1         [ 4] 2871         CALL     TEMP
      00BDAD CD AE A8         [ 4] 2872         CALL     AT
      00BDB0 CD BD 1B         [ 4] 2873         CALL     SAMEQ
      00BDB3 CD AE 79         [ 4] 2874 FIND3:  CALL     BRAN
      00BDB6 BD C7                 2875         .word      FIND4
      00BDB8 CD AE F9         [ 4] 2876 FIND6:  CALL     RFROM
      00BDBB CD AF D4         [ 4] 2877         CALL     DROP
      00BDBE CD AF EE         [ 4] 2878         CALL     SWAPP
      00BDC1 CD B4 FC         [ 4] 2879         CALL     CELLM
      00BDC4 CC AF EE         [ 2] 2880         JP     SWAPP
      00BDC7 CD AE 5D         [ 4] 2881 FIND4:  CALL     QBRAN
      00BDCA BD D4                 2882         .word      FIND5
      00BDCC CD B4 FC         [ 4] 2883         CALL     CELLM
      00BDCF CD B4 FC         [ 4] 2884         CALL     CELLM
      00BDD2 20 A5            [ 2] 2885         JRA     FIND1
      00BDD4 CD AE F9         [ 4] 2886 FIND5:  CALL     RFROM
      00BDD7 CD AF D4         [ 4] 2887         CALL     DROP
      00BDDA CD AF EE         [ 4] 2888         CALL     SWAPP
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 109.
Hexadecimal [24-Bits]



      00BDDD CD AF D4         [ 4] 2889         CALL     DROP
      00BDE0 CD B4 FC         [ 4] 2890         CALL     CELLM
      00BDE3 CD AF DE         [ 4] 2891         CALL     DUPP
      00BDE6 CD BD 05         [ 4] 2892         CALL     NAMET
      00BDE9 CC AF EE         [ 2] 2893         JP     SWAPP
                                   2894 
                                   2895 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2896 ;       NAME?   ( a -- ca na | a F )
                                   2897 ;       Search vocabularies for a string.
                                   2898 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00117A                       2899         _HEADER NAMEQ,5,"NAME?"
      00BDEC BD 56                    1         .word LINK 
                           00117C     2         LINK=.
      00BDEE 05                       3         .byte 5  
      00BDEF 4E 41 4D 45 3F           4         .ascii "NAME?"
      00BDF4                          5         NAMEQ:
      00BDF4 CD B1 13         [ 4] 2900         CALL   CNTXT
      00BDF7 CC BD 5B         [ 2] 2901         JP     FIND
                                   2902 
                                   2903 ;; Terminal response
                                   2904 
                                   2905 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2906 ;       ^H      ( bot eot cur -- bot eot cur )
                                   2907 ;       Backup cursor by one character.
                                   2908 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001188                       2909         _HEADER BKSP,2,"^H"
      00BDFA BD EE                    1         .word LINK 
                           00118A     2         LINK=.
      00BDFC 02                       3         .byte 2  
      00BDFD 5E 48                    4         .ascii "^H"
      00BDFF                          5         BKSP:
      00BDFF CD AF A7         [ 4] 2910         CALL     TOR
      00BE02 CD B0 06         [ 4] 2911         CALL     OVER
      00BE05 CD AE F9         [ 4] 2912         CALL     RFROM
      00BE08 CD AF EE         [ 4] 2913         CALL     SWAPP
      00BE0B CD B0 06         [ 4] 2914         CALL     OVER
      00BE0E CD B0 64         [ 4] 2915         CALL     XORR
      00BE11 CD AE 5D         [ 4] 2916         CALL     QBRAN
      00BE14 BE 2F                 2917         .word      BACK1
      00BE16 CD AE 34         [ 4] 2918         CALL     DOLIT
      00BE19 00 08                 2919         .word      BKSPP
      00BE1B CD AD FB         [ 4] 2920         CALL     EMIT
      00BE1E CD B5 25         [ 4] 2921         CALL     ONEM
      00BE21 CD B5 77         [ 4] 2922         CALL     BLANK
      00BE24 CD AD FB         [ 4] 2923         CALL     EMIT
      00BE27 CD AE 34         [ 4] 2924         CALL     DOLIT
      00BE2A 00 08                 2925         .word      BKSPP
      00BE2C CC AD FB         [ 2] 2926         JP     EMIT
      00BE2F 81               [ 4] 2927 BACK1:  RET
                                   2928 
                                   2929 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2930 ;       TAP    ( bot eot cur c -- bot eot cur )
                                   2931 ;       Accept and echo key stroke
                                   2932 ;       and bump cursor.
                                   2933 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 110.
Hexadecimal [24-Bits]



      0011BE                       2934         _HEADER TAP,3,"TAP"
      00BE30 BD FC                    1         .word LINK 
                           0011C0     2         LINK=.
      00BE32 03                       3         .byte 3  
      00BE33 54 41 50                 4         .ascii "TAP"
      00BE36                          5         TAP:
      00BE36 CD AF DE         [ 4] 2935         CALL     DUPP
      00BE39 CD AD FB         [ 4] 2936         CALL     EMIT
      00BE3C CD B0 06         [ 4] 2937         CALL     OVER
      00BE3F CD AE B5         [ 4] 2938         CALL     CSTOR
      00BE42 CC B5 18         [ 2] 2939         JP     ONEP
                                   2940 
                                   2941 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2942 ;       kTAP    ( bot eot cur c -- bot eot cur )
                                   2943 ;       Process a key stroke,
                                   2944 ;       CR,LF or backspace.
                                   2945 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0011D3                       2946         _HEADER KTAP,4,"KTAP"
      00BE45 BE 32                    1         .word LINK 
                           0011D5     2         LINK=.
      00BE47 04                       3         .byte 4  
      00BE48 4B 54 41 50              4         .ascii "KTAP"
      00BE4C                          5         KTAP:
      00BE4C CD AF DE         [ 4] 2947         CALL     DUPP
      00BE4F CD AE 34         [ 4] 2948         CALL     DOLIT
                           000001  2949 .if EOL_CR
      00BE52 00 0D                 2950         .word   CRR
                           000000  2951 .else ; EOL_LF 
                                   2952         .word   LF
                                   2953 .endif 
      00BE54 CD B0 64         [ 4] 2954         CALL     XORR
      00BE57 CD AE 5D         [ 4] 2955         CALL     QBRAN
      00BE5A BE 72                 2956         .word      KTAP2
      00BE5C CD AE 34         [ 4] 2957         CALL     DOLIT
      00BE5F 00 08                 2958         .word      BKSPP
      00BE61 CD B0 64         [ 4] 2959         CALL     XORR
      00BE64 CD AE 5D         [ 4] 2960         CALL     QBRAN
      00BE67 BE 6F                 2961         .word      KTAP1
      00BE69 CD B5 77         [ 4] 2962         CALL     BLANK
      00BE6C CC BE 36         [ 2] 2963         JP     TAP
      00BE6F CC BD FF         [ 2] 2964 KTAP1:  JP     BKSP
      00BE72 CD AF D4         [ 4] 2965 KTAP2:  CALL     DROP
      00BE75 CD AF EE         [ 4] 2966         CALL     SWAPP
      00BE78 CD AF D4         [ 4] 2967         CALL     DROP
      00BE7B CC AF DE         [ 2] 2968         JP     DUPP
                                   2969 
                                   2970 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2971 ;       accept  ( b u -- b u )
                                   2972 ;       Accept characters to input
                                   2973 ;       buffer. Return with actual count.
                                   2974 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00120C                       2975         _HEADER ACCEP,6,"ACCEPT"
      00BE7E BE 47                    1         .word LINK 
                           00120E     2         LINK=.
      00BE80 06                       3         .byte 6  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 111.
Hexadecimal [24-Bits]



      00BE81 41 43 43 45 50 54        4         .ascii "ACCEPT"
      00BE87                          5         ACCEP:
      00BE87 CD B0 06         [ 4] 2976         CALL     OVER
      00BE8A CD B1 B1         [ 4] 2977         CALL     PLUS
      00BE8D CD B0 06         [ 4] 2978         CALL     OVER
      00BE90 CD B1 9C         [ 4] 2979 ACCP1:  CALL     DDUP
      00BE93 CD B0 64         [ 4] 2980         CALL     XORR
      00BE96 CD AE 5D         [ 4] 2981         CALL     QBRAN
      00BE99 BE BB                 2982         .word      ACCP4
      00BE9B CD BA 34         [ 4] 2983         CALL     KEY
      00BE9E CD AF DE         [ 4] 2984         CALL     DUPP
      00BEA1 CD B5 77         [ 4] 2985         CALL     BLANK
      00BEA4 CD AE 34         [ 4] 2986         CALL     DOLIT
      00BEA7 00 7F                 2987         .word      127
      00BEA9 CD B3 0B         [ 4] 2988         CALL     WITHI
      00BEAC CD AE 5D         [ 4] 2989         CALL     QBRAN
      00BEAF BE B6                 2990         .word      ACCP2
      00BEB1 CD BE 36         [ 4] 2991         CALL     TAP
      00BEB4 20 03            [ 2] 2992         JRA     ACCP3
      00BEB6 CD BE 4C         [ 4] 2993 ACCP2:  CALL     KTAP
      00BEB9 20 D5            [ 2] 2994 ACCP3:  JRA     ACCP1
      00BEBB CD AF D4         [ 4] 2995 ACCP4:  CALL     DROP
      00BEBE CD B0 06         [ 4] 2996         CALL     OVER
      00BEC1 CC B2 47         [ 2] 2997         JP     SUBB
                                   2998 
                                   2999 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3000 ;       QUERY   ( -- )
                                   3001 ;       Accept input stream to
                                   3002 ;       terminal input buffer.
                                   3003 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001252                       3004         _HEADER QUERY,5,"QUERY"
      00BEC4 BE 80                    1         .word LINK 
                           001254     2         LINK=.
      00BEC6 05                       3         .byte 5  
      00BEC7 51 55 45 52 59           4         .ascii "QUERY"
      00BECC                          5         QUERY:
      00BECC CD B6 80         [ 4] 3005         CALL     TIB
      00BECF CD AE 34         [ 4] 3006         CALL     DOLIT
      00BED2 00 50                 3007         .word      80
      00BED4 CD BE 87         [ 4] 3008         CALL     ACCEP
      00BED7 CD B0 D0         [ 4] 3009         CALL     NTIB
      00BEDA CD AE 96         [ 4] 3010         CALL     STORE
      00BEDD CD AF D4         [ 4] 3011         CALL     DROP
      00BEE0 CD B5 84         [ 4] 3012         CALL     ZERO
      00BEE3 CD B0 C0         [ 4] 3013         CALL     INN
      00BEE6 CC AE 96         [ 2] 3014         JP     STORE
                                   3015 
                                   3016 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3017 ;       ABORT   ( -- )
                                   3018 ;       Reset data stack and
                                   3019 ;       jump to QUIT.
                                   3020 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001277                       3021         _HEADER ABORT,5,"ABORT"
      00BEE9 BE C6                    1         .word LINK 
                           001279     2         LINK=.
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 112.
Hexadecimal [24-Bits]



      00BEEB 05                       3         .byte 5  
      00BEEC 41 42 4F 52 54           4         .ascii "ABORT"
      00BEF1                          5         ABORT:
      00BEF1 CD BF E9         [ 4] 3022         CALL     PRESE
      00BEF4 CC C0 06         [ 2] 3023         JP     QUIT
                                   3024 
                                   3025 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3026 ;       abort"  ( f -- )
                                   3027 ;       Run time routine of ABORT".
                                   3028 ;       Abort with a message.
                                   3029 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001285                       3030         _HEADER ABORQ,COMPO+6,'ABORT"'
      00BEF7 BE EB                    1         .word LINK 
                           001287     2         LINK=.
      00BEF9 46                       3         .byte COMPO+6  
      00BEFA 41 42 4F 52 54 22        4         .ascii 'ABORT"'
      00BF00                          5         ABORQ:
      00BF00 CD AE 5D         [ 4] 3031         CALL     QBRAN
      00BF03 BF 23                 3032         .word      ABOR2   ;text flag
      00BF05 CD BA BA         [ 4] 3033         CALL     DOSTR
      00BF08 35 0A B0 A2      [ 1] 3034 ABOR1:  MOV     BASE,#10 ; reset to default 
      00BF0C CD BA 67         [ 4] 3035         CALL     SPAC
      00BF0F CD B6 47         [ 4] 3036         CALL     COUNT
      00BF12 CD BA 91         [ 4] 3037         CALL     TYPES
      00BF15 CD AE 34         [ 4] 3038         CALL     DOLIT
      00BF18 00 3F                 3039         .word     63 ; "?"
      00BF1A CD AD FB         [ 4] 3040         CALL     EMIT
      00BF1D CD BA AA         [ 4] 3041         CALL     CRLF
      00BF20 CC BE F1         [ 2] 3042         JP     ABORT   ;pass error string
      00BF23 CD BA BA         [ 4] 3043 ABOR2:  CALL     DOSTR
      00BF26 CC AF D4         [ 2] 3044         JP     DROP
                                   3045 
                                   3046 ;; The text interpreter
                                   3047 
                                   3048 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3049 ;       $INTERPRET      ( a -- )
                                   3050 ;       Interpret a word. If failed,
                                   3051 ;       try to convert it to an integer.
                                   3052 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0012B7                       3053         _HEADER INTER,10,"$INTERPRET"
      00BF29 BE F9                    1         .word LINK 
                           0012B9     2         LINK=.
      00BF2B 0A                       3         .byte 10  
      00BF2C 24 49 4E 54 45 52 50     4         .ascii "$INTERPRET"
             52 45 54
      00BF36                          5         INTER:
      00BF36 CD BD F4         [ 4] 3054         CALL     NAMEQ
      00BF39 CD B1 41         [ 4] 3055         CALL     QDUP    ;?defined
      00BF3C CD AE 5D         [ 4] 3056         CALL     QBRAN
      00BF3F BF 60                 3057         .word      INTE1
      00BF41 CD AE A8         [ 4] 3058         CALL     AT
      00BF44 CD AE 34         [ 4] 3059         CALL     DOLIT
      00BF47 40 00                 3060 	.word       0x4000	; COMPO*256
      00BF49 CD B0 3B         [ 4] 3061         CALL     ANDD    ;?compile only lexicon bits
      00BF4C CD BF 00         [ 4] 3062         CALL     ABORQ
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 113.
Hexadecimal [24-Bits]



      00BF4F 0D                    3063         .byte      13
      00BF50 20 63 6F 6D 70 69 6C  3064         .ascii     " compile only"
             65 20 6F 6E 6C 79
      00BF5D CC AE 89         [ 2] 3065         JP      EXECU
      00BF60                       3066 INTE1:  
      00BF60 CD B9 D2         [ 4] 3067         CALL     NUMBQ   ;convert a number
      00BF63 CD AE 5D         [ 4] 3068         CALL     QBRAN
      00BF66 BF 08                 3069         .word    ABOR1
      00BF68 81               [ 4] 3070         RET
                                   3071 
                                   3072 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3073 ;       [       ( -- )
                                   3074 ;       Start  text interpreter.
                                   3075 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0012F7                       3076         _HEADER LBRAC,IMEDD+1,"["
      00BF69 BF 2B                    1         .word LINK 
                           0012F9     2         LINK=.
      00BF6B 81                       3         .byte IMEDD+1  
      00BF6C 5B                       4         .ascii "["
      00BF6D                          5         LBRAC:
      00BF6D CD AE 34         [ 4] 3077         CALL   DOLIT
      00BF70 BF 36                 3078         .word  INTER
      00BF72 CD B0 F1         [ 4] 3079         CALL   TEVAL
      00BF75 CC AE 96         [ 2] 3080         JP     STORE
                                   3081 
                                   3082 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3083 ;       .OK     ( -- )
                                   3084 ;       Display 'ok' while interpreting.
                                   3085 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001306                       3086         _HEADER DOTOK,3,".OK"
      00BF78 BF 6B                    1         .word LINK 
                           001308     2         LINK=.
      00BF7A 03                       3         .byte 3  
      00BF7B 2E 4F 4B                 4         .ascii ".OK"
      00BF7E                          5         DOTOK:
      00BF7E CD AE 34         [ 4] 3087         CALL     DOLIT
      00BF81 BF 36                 3088         .word      INTER
      00BF83 CD B0 F1         [ 4] 3089         CALL     TEVAL
      00BF86 CD AE A8         [ 4] 3090         CALL     AT
      00BF89 CD B2 6F         [ 4] 3091         CALL     EQUAL
      00BF8C CD AE 5D         [ 4] 3092         CALL     QBRAN
      00BF8F BF 98                 3093         .word      DOTO1
      00BF91 CD BA D7         [ 4] 3094         CALL     DOTQP
      00BF94 03                    3095         .byte      3
      00BF95 20 6F 6B              3096         .ascii     " ok"
      00BF98 CC BA AA         [ 2] 3097 DOTO1:  JP     CRLF
                                   3098 
                                   3099 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3100 ;       ?STACK  ( -- )
                                   3101 ;       Abort if stack underflows.
                                   3102 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001329                       3103         _HEADER QSTAC,6,"?STACK"
      00BF9B BF 7A                    1         .word LINK 
                           00132B     2         LINK=.
      00BF9D 06                       3         .byte 6  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 114.
Hexadecimal [24-Bits]



      00BF9E 3F 53 54 41 43 4B        4         .ascii "?STACK"
      00BFA4                          5         QSTAC:
      00BFA4 CD B5 C6         [ 4] 3104         CALL     DEPTH
      00BFA7 CD B0 15         [ 4] 3105         CALL     ZLESS   ;check only for underflow
      00BFAA CD BF 00         [ 4] 3106         CALL     ABORQ
      00BFAD 0B                    3107         .byte      11
      00BFAE 20 75 6E 64 65 72 66  3108         .ascii     " underflow "
             6C 6F 77 20
      00BFB9 81               [ 4] 3109         RET
                                   3110 
                                   3111 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3112 ;       EVAL    ( -- )
                                   3113 ;       Interpret  input stream.
                                   3114 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001348                       3115         _HEADER EVAL,4,"EVAL"
      00BFBA BF 9D                    1         .word LINK 
                           00134A     2         LINK=.
      00BFBC 04                       3         .byte 4  
      00BFBD 45 56 41 4C              4         .ascii "EVAL"
      00BFC1                          5         EVAL:
      00BFC1 CD BC F7         [ 4] 3116 EVAL1:  CALL     TOKEN
      00BFC4 CD AF DE         [ 4] 3117         CALL     DUPP
      00BFC7 CD AE C6         [ 4] 3118         CALL     CAT     ;?input stream empty
      00BFCA CD AE 5D         [ 4] 3119         CALL     QBRAN
      00BFCD BF DA                 3120         .word    EVAL2
      00BFCF CD B0 F1         [ 4] 3121         CALL     TEVAL
      00BFD2 CD B6 94         [ 4] 3122         CALL     ATEXE
      00BFD5 CD BF A4         [ 4] 3123         CALL     QSTAC   ;evaluate input, check stack
      00BFD8 20 E7            [ 2] 3124         JRA     EVAL1 
      00BFDA CD AF D4         [ 4] 3125 EVAL2:  CALL     DROP
      00BFDD CC BF 7E         [ 2] 3126         JP       DOTOK
                                   3127 
                                   3128 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3129 ;       PRESET  ( -- )
                                   3130 ;       Reset data stack pointer and
                                   3131 ;       terminal input buffer.
                                   3132 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00136E                       3133         _HEADER PRESE,6,"PRESET"
      00BFE0 BF BC                    1         .word LINK 
                           001370     2         LINK=.
      00BFE2 06                       3         .byte 6  
      00BFE3 50 52 45 53 45 54        4         .ascii "PRESET"
      00BFE9                          5         PRESE:
      00BFE9 CD AE 34         [ 4] 3134         CALL     DOLIT
      00BFEC 16 80                 3135         .word      SPP
      00BFEE CD AF CB         [ 4] 3136         CALL     SPSTO
      00BFF1 CD AE 34         [ 4] 3137         CALL     DOLIT
      00BFF4 17 00                 3138         .word      TIBB
      00BFF6 CD B0 D0         [ 4] 3139         CALL     NTIB
      00BFF9 CD B4 ED         [ 4] 3140         CALL     CELLP
      00BFFC CC AE 96         [ 2] 3141         JP     STORE
                                   3142 
                                   3143 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3144 ;       QUIT    ( -- )
                                   3145 ;       Reset return stack pointer
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 115.
Hexadecimal [24-Bits]



                                   3146 ;       and start text interpreter.
                                   3147 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00138D                       3148         _HEADER QUIT,4,"QUIT"
      00BFFF BF E2                    1         .word LINK 
                           00138F     2         LINK=.
      00C001 04                       3         .byte 4  
      00C002 51 55 49 54              4         .ascii "QUIT"
      00C006                          5         QUIT:
      00C006 CD AE 34         [ 4] 3149         CALL     DOLIT
      00C009 17 FF                 3150         .word      RPP
      00C00B CD AE E3         [ 4] 3151         CALL     RPSTO   ;reset return stack pointer
      00C00E CD BF 6D         [ 4] 3152 QUIT1:  CALL     LBRAC   ;start interpretation
      00C011 CD BE CC         [ 4] 3153 QUIT2:  CALL     QUERY   ;get input
      00C014 CD BF C1         [ 4] 3154         CALL     EVAL
      00C017 20 F8            [ 2] 3155         JRA     QUIT2   ;continue till error
                                   3156 
                                   3157 ;; The compiler
                                   3158 
                                   3159 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3160 ;       '       ( -- ca )
                                   3161 ;       Search vocabularies for
                                   3162 ;       next word in input stream.
                                   3163 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0013A7                       3164         _HEADER TICKK,1,"'"
      00C019 C0 01                    1         .word LINK 
                           0013A9     2         LINK=.
      00C01B 01                       3         .byte 1  
      00C01C 27                       4         .ascii "'"
      00C01D                          5         TICKK:
      00C01D CD BC F7         [ 4] 3165         CALL     TOKEN
      00C020 CD BD F4         [ 4] 3166         CALL     NAMEQ   ;?defined
      00C023 CD AE 5D         [ 4] 3167         CALL     QBRAN
      00C026 BF 08                 3168         .word      ABOR1
      00C028 81               [ 4] 3169         RET     ;yes, push code address
                                   3170 
                                   3171 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3172 ;       ALLOT   ( n -- )
                                   3173 ;       Allocate n bytes to RAM 
                                   3174 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0013B7                       3175         _HEADER ALLOT,5,"ALLOT"
      00C029 C0 1B                    1         .word LINK 
                           0013B9     2         LINK=.
      00C02B 05                       3         .byte 5  
      00C02C 41 4C 4C 4F 54           4         .ascii "ALLOT"
      00C031                          5         ALLOT:
      00C031 CD B1 21         [ 4] 3176         call VPP 
      00C034 CC B5 F4         [ 2] 3177         JP PSTOR
                                   3178 
                                   3179 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3180 ;       ,       ( w -- )
                                   3181 ;         Compile an integer into
                                   3182 ;         variable space.
                                   3183 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0013C5                       3184         _HEADER COMA,1,^/","/
      00C037 C0 2B                    1         .word LINK 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 116.
Hexadecimal [24-Bits]



                           0013C7     2         LINK=.
      00C039 01                       3         .byte 1  
      00C03A 2C                       4         .ascii ","
      00C03B                          5         COMA:
      00C03B CD B6 5E         [ 4] 3185         CALL     HERE
      00C03E CD AF DE         [ 4] 3186         CALL     DUPP
      00C041 CD B4 ED         [ 4] 3187         CALL     CELLP   ;cell boundary
      00C044 CD B1 21         [ 4] 3188         CALL     VPP
      00C047 CD AE 96         [ 4] 3189         CALL     STORE
      00C04A CC AE 96         [ 2] 3190         JP       STORE
                                   3191 
                                   3192 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3193 ;       C,      ( c -- )
                                   3194 ;       Compile a byte into
                                   3195 ;       variables space.
                                   3196 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0013DB                       3197         _HEADER CCOMMA,2,^/"C,"/
      00C04D C0 39                    1         .word LINK 
                           0013DD     2         LINK=.
      00C04F 02                       3         .byte 2  
      00C050 43 2C                    4         .ascii "C,"
      00C052                          5         CCOMMA:
      00C052 CD B6 5E         [ 4] 3198         CALL     HERE
      00C055 CD AF DE         [ 4] 3199         CALL     DUPP
      00C058 CD B5 18         [ 4] 3200         CALL     ONEP
      00C05B CD B1 21         [ 4] 3201         CALL     VPP
      00C05E CD AE 96         [ 4] 3202         CALL     STORE
      00C061 CC AE B5         [ 2] 3203         JP       CSTOR
                                   3204 
                                   3205 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3206 ;       [COMPILE]       ( -- ; <string> )
                                   3207 ;       Compile next immediate
                                   3208 ;       word into code dictionary.
                                   3209 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0013F2                       3210         _HEADER BCOMP,COMPO+IMEDD+9,"[COMPILE]"
      00C064 C0 4F                    1         .word LINK 
                           0013F4     2         LINK=.
      00C066 C9                       3         .byte COMPO+IMEDD+9  
      00C067 5B 43 4F 4D 50 49 4C     4         .ascii "[COMPILE]"
             45 5D
      00C070                          5         BCOMP:
      00C070 CD C0 1D         [ 4] 3211         CALL     TICKK
      00C073 CC C2 E0         [ 2] 3212         JP     JSRC
                                   3213 
                                   3214 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3215 ;       COMPILE ( -- )
                                   3216 ;       Compile next jsr in
                                   3217 ;       colon list to code dictionary.
                                   3218 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001404                       3219         _HEADER COMPI,COMPO+7,"COMPILE"
      00C076 C0 66                    1         .word LINK 
                           001406     2         LINK=.
      00C078 47                       3         .byte COMPO+7  
      00C079 43 4F 4D 50 49 4C 45     4         .ascii "COMPILE"
      00C080                          5         COMPI:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 117.
Hexadecimal [24-Bits]



      00C080 CD AE F9         [ 4] 3220         CALL     RFROM
      00C083 CD AF DE         [ 4] 3221         CALL     DUPP
      00C086 CD AE A8         [ 4] 3222         CALL     AT
      00C089 CD C2 E0         [ 4] 3223         CALL     JSRC    ;compile subroutine
      00C08C CD B4 ED         [ 4] 3224         CALL     CELLP
      00C08F 90 93            [ 1] 3225         ldw y,x 
      00C091 90 FE            [ 2] 3226         ldw y,(y)
      00C093 1C 00 02         [ 2] 3227         addw x,#CELLL 
      00C096 90 FC            [ 2] 3228         jp (y)
                                   3229 
                                   3230 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3231 ;       LITERAL ( w -- )
                                   3232 ;       Compile tos to dictionary
                                   3233 ;       as an integer literal.
                                   3234 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001426                       3235         _HEADER LITER,COMPO+IMEDD+7,"LITERAL"
      00C098 C0 78                    1         .word LINK 
                           001428     2         LINK=.
      00C09A C7                       3         .byte COMPO+IMEDD+7  
      00C09B 4C 49 54 45 52 41 4C     4         .ascii "LITERAL"
      00C0A2                          5         LITER:
      00C0A2 CD C0 80         [ 4] 3236         CALL     COMPI
      00C0A5 AE 34                 3237         .word DOLIT 
      00C0A7 CC C0 3B         [ 2] 3238         JP     COMA
                                   3239 
                                   3240 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3241 ;       $,"     ( -- )
                                   3242 ;       Compile a literal string
                                   3243 ;       up to next " .
                                   3244 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3245 ;        _HEADER STRCQ,3,^/'$,"'/
      00C0AA                       3246 STRCQ:
      00C0AA CD AE 34         [ 4] 3247         CALL     DOLIT
      00C0AD 00 22                 3248         .word     34	; "
      00C0AF CD BC 48         [ 4] 3249         CALL     PARSE
      00C0B2 CD B6 5E         [ 4] 3250         CALL     HERE
      00C0B5 CD B7 2F         [ 4] 3251         CALL     PACKS   ;string to code dictionary
      00C0B8 CD B6 47         [ 4] 3252         CALL     COUNT
      00C0BB CD B1 B1         [ 4] 3253         CALL     PLUS    ;calculate aligned end of string
      00C0BE CD B1 21         [ 4] 3254         CALL     VPP
      00C0C1 CC AE 96         [ 2] 3255         JP     STORE
                                   3256 
                                   3257 ;; Structures
                                   3258 
                                   3259 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3260 ;       FOR     ( -- a )
                                   3261 ;       Start a FOR-NEXT loop
                                   3262 ;       structure in a colon definition.
                                   3263 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001452                       3264         _HEADER FOR,COMPO+IMEDD+3,"FOR"
      00C0C4 C0 9A                    1         .word LINK 
                           001454     2         LINK=.
      00C0C6 C3                       3         .byte COMPO+IMEDD+3  
      00C0C7 46 4F 52                 4         .ascii "FOR"
      00C0CA                          5         FOR:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 118.
Hexadecimal [24-Bits]



      00C0CA CD C0 80         [ 4] 3265         CALL     COMPI
      00C0CD AF A7                 3266         .word TOR 
      00C0CF CC B6 5E         [ 2] 3267         JP     HERE
                                   3268 
                                   3269 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3270 ;       NEXT    ( a -- )
                                   3271 ;       Terminate a FOR-NEXT loop.
                                   3272 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001460                       3273         _HEADER NEXT,COMPO+IMEDD+4,"NEXT"
      00C0D2 C0 C6                    1         .word LINK 
                           001462     2         LINK=.
      00C0D4 C4                       3         .byte COMPO+IMEDD+4  
      00C0D5 4E 45 58 54              4         .ascii "NEXT"
      00C0D9                          5         NEXT:
      00C0D9 CD C0 80         [ 4] 3274         CALL     COMPI
      00C0DC AE 48                 3275         .word DONXT 
      00C0DE CC C0 3B         [ 2] 3276         JP     COMA
                                   3277 
                                   3278 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3279 ;       I ( -- n )
                                   3280 ;       stack COUNTER
                                   3281 ;       of innermost FOR-NEXT  
                                   3282 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00146F                       3283         _HEADER IFETCH,1,"I"
      00C0E1 C0 D4                    1         .word LINK 
                           001471     2         LINK=.
      00C0E3 01                       3         .byte 1  
      00C0E4 49                       4         .ascii "I"
      00C0E5                          5         IFETCH:
      00C0E5 1D 00 02         [ 2] 3284         subw x,#CELLL 
      00C0E8 16 03            [ 2] 3285         ldw y,(3,sp)
      00C0EA FF               [ 2] 3286         ldw (x),y 
      00C0EB 81               [ 4] 3287         ret 
                                   3288 
                                   3289 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3290 ;       J ( -- n )
                                   3291 ;   stack COUNTER
                                   3292 ;   of outer FOR-NEXT  
                                   3293 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00147A                       3294         _HEADER JFETCH,1,"J"
      00C0EC C0 E3                    1         .word LINK 
                           00147C     2         LINK=.
      00C0EE 01                       3         .byte 1  
      00C0EF 4A                       4         .ascii "J"
      00C0F0                          5         JFETCH:
      00C0F0 1D 00 02         [ 2] 3295         SUBW X,#CELLL 
      00C0F3 16 05            [ 2] 3296         LDW Y,(5,SP)
      00C0F5 FF               [ 2] 3297         LDW (X),Y 
      00C0F6 81               [ 4] 3298         RET 
                                   3299 
                                   3300 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3301 ;       BEGIN   ( -- a )
                                   3302 ;       Start an infinite or
                                   3303 ;       indefinite loop structure.
                                   3304 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 119.
Hexadecimal [24-Bits]



      001485                       3305         _HEADER BEGIN,COMPO+IMEDD+5,"BEGIN"
      00C0F7 C0 EE                    1         .word LINK 
                           001487     2         LINK=.
      00C0F9 C5                       3         .byte COMPO+IMEDD+5  
      00C0FA 42 45 47 49 4E           4         .ascii "BEGIN"
      00C0FF                          5         BEGIN:
      00C0FF CC B6 5E         [ 2] 3306         JP     HERE
                                   3307 
                                   3308 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3309 ;       UNTIL   ( a -- )
                                   3310 ;       Terminate a BEGIN-UNTIL
                                   3311 ;       indefinite loop structure.
                                   3312 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001490                       3313         _HEADER UNTIL,COMPO+IMEDD+5,"UNTIL"
      00C102 C0 F9                    1         .word LINK 
                           001492     2         LINK=.
      00C104 C5                       3         .byte COMPO+IMEDD+5  
      00C105 55 4E 54 49 4C           4         .ascii "UNTIL"
      00C10A                          5         UNTIL:
      00C10A CD C0 80         [ 4] 3314         CALL     COMPI
      00C10D AE 5D                 3315         .word    QBRAN 
      00C10F CC C0 3B         [ 2] 3316         JP     COMA
                                   3317 
                                   3318 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3319 ;       AGAIN   ( a -- )
                                   3320 ;       Terminate a BEGIN-AGAIN
                                   3321 ;       infinite loop structure.
                                   3322 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0014A0                       3323         _HEADER AGAIN,COMPO+IMEDD+5,"AGAIN"
      00C112 C1 04                    1         .word LINK 
                           0014A2     2         LINK=.
      00C114 C5                       3         .byte COMPO+IMEDD+5  
      00C115 41 47 41 49 4E           4         .ascii "AGAIN"
      00C11A                          5         AGAIN:
                           000001  3324 .if OPTIMIZE 
      0014A8                       3325         _DOLIT JPIMM 
      00C11A CD AE 34         [ 4]    1     CALL DOLIT 
      00C11D 00 CC                    2     .word JPIMM 
      00C11F CD C0 52         [ 4] 3326         CALL  CCOMMA
                           000000  3327 .else 
                                   3328         CALL     COMPI
                                   3329         .word BRAN
                                   3330 .endif 
      00C122 CC C0 3B         [ 2] 3331         JP     COMA
                                   3332 
                                   3333 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3334 ;       IF      ( -- A )
                                   3335 ;       Begin a conditional branch.
                                   3336 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0014B3                       3337         _HEADER IFF,COMPO+IMEDD+2,"IF"
      00C125 C1 14                    1         .word LINK 
                           0014B5     2         LINK=.
      00C127 C2                       3         .byte COMPO+IMEDD+2  
      00C128 49 46                    4         .ascii "IF"
      00C12A                          5         IFF:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 120.
Hexadecimal [24-Bits]



      00C12A CD C0 80         [ 4] 3338         CALL     COMPI
      00C12D AE 5D                 3339         .word QBRAN
      00C12F CD B6 5E         [ 4] 3340         CALL     HERE
      00C132 CD B5 84         [ 4] 3341         CALL     ZERO
      00C135 CC C0 3B         [ 2] 3342         JP     COMA
                                   3343 
                                   3344 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3345 ;       THEN        ( A -- )
                                   3346 ;       Terminate a conditional 
                                   3347 ;       branch structure.
                                   3348 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0014C6                       3349         _HEADER THENN,COMPO+IMEDD+4,"THEN"
      00C138 C1 27                    1         .word LINK 
                           0014C8     2         LINK=.
      00C13A C4                       3         .byte COMPO+IMEDD+4  
      00C13B 54 48 45 4E              4         .ascii "THEN"
      00C13F                          5         THENN:
      00C13F CD B6 5E         [ 4] 3350         CALL     HERE
      00C142 CD AF EE         [ 4] 3351         CALL     SWAPP
      00C145 CC AE 96         [ 2] 3352         JP     STORE
                                   3353 
                                   3354 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3355 ;       ELSE        ( A -- A )
                                   3356 ;       Start the false clause in 
                                   3357 ;       an IF-ELSE-THEN structure.
                                   3358 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0014D6                       3359         _HEADER ELSEE,COMPO+IMEDD+4,"ELSE"
      00C148 C1 3A                    1         .word LINK 
                           0014D8     2         LINK=.
      00C14A C4                       3         .byte COMPO+IMEDD+4  
      00C14B 45 4C 53 45              4         .ascii "ELSE"
      00C14F                          5         ELSEE:
                           000001  3360 .if OPTIMIZE 
      0014DD                       3361         _DOLIT JPIMM 
      00C14F CD AE 34         [ 4]    1     CALL DOLIT 
      00C152 00 CC                    2     .word JPIMM 
      00C154 CD C0 52         [ 4] 3362         CALL CCOMMA 
                           000000  3363 .else 
                                   3364          CALL     COMPI
                                   3365         .word BRAN
                                   3366 .endif 
      00C157 CD B6 5E         [ 4] 3367         CALL     HERE
      00C15A CD B5 84         [ 4] 3368         CALL     ZERO
      00C15D CD C0 3B         [ 4] 3369         CALL     COMA
      00C160 CD AF EE         [ 4] 3370         CALL     SWAPP
      00C163 CD B6 5E         [ 4] 3371         CALL     HERE
      00C166 CD AF EE         [ 4] 3372         CALL     SWAPP
      00C169 CC AE 96         [ 2] 3373         JP     STORE
                                   3374 
                                   3375 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3376 ;       AHEAD       ( -- A )
                                   3377 ;       Compile a forward branch
                                   3378 ;       instruction.
                                   3379 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0014FA                       3380         _HEADER AHEAD,COMPO+IMEDD+5,"AHEAD"
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 121.
Hexadecimal [24-Bits]



      00C16C C1 4A                    1         .word LINK 
                           0014FC     2         LINK=.
      00C16E C5                       3         .byte COMPO+IMEDD+5  
      00C16F 41 48 45 41 44           4         .ascii "AHEAD"
      00C174                          5         AHEAD:
                           000001  3381 .if OPTIMIZE 
      001502                       3382         _DOLIT JPIMM 
      00C174 CD AE 34         [ 4]    1     CALL DOLIT 
      00C177 00 CC                    2     .word JPIMM 
      00C179 CD C0 52         [ 4] 3383         CALL CCOMMA
                           000000  3384 .else 
                                   3385         CALL     COMPI
                                   3386         .word BRAN
                                   3387 .endif 
      00C17C CD B6 5E         [ 4] 3388         CALL     HERE
      00C17F CD B5 84         [ 4] 3389         CALL     ZERO
      00C182 CC C0 3B         [ 2] 3390         JP     COMA
                                   3391 
                                   3392 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3393 ;       WHILE       ( a -- A a )
                                   3394 ;       Conditional branch out of a 
                                   3395 ;       BEGIN-WHILE-REPEAT loop.
                                   3396 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001513                       3397         _HEADER WHILE,COMPO+IMEDD+5,"WHILE"
      00C185 C1 6E                    1         .word LINK 
                           001515     2         LINK=.
      00C187 C5                       3         .byte COMPO+IMEDD+5  
      00C188 57 48 49 4C 45           4         .ascii "WHILE"
      00C18D                          5         WHILE:
      00C18D CD C0 80         [ 4] 3398         CALL     COMPI
      00C190 AE 5D                 3399         .word QBRAN
      00C192 CD B6 5E         [ 4] 3400         CALL     HERE
      00C195 CD B5 84         [ 4] 3401         CALL     ZERO
      00C198 CD C0 3B         [ 4] 3402         CALL     COMA
      00C19B CC AF EE         [ 2] 3403         JP     SWAPP
                                   3404 
                                   3405 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3406 ;       REPEAT      ( A a -- )
                                   3407 ;       Terminate a BEGIN-WHILE-REPEAT 
                                   3408 ;       indefinite loop.
                                   3409 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00152C                       3410         _HEADER REPEA,COMPO+IMEDD+6,"REPEAT"
      00C19E C1 87                    1         .word LINK 
                           00152E     2         LINK=.
      00C1A0 C6                       3         .byte COMPO+IMEDD+6  
      00C1A1 52 45 50 45 41 54        4         .ascii "REPEAT"
      00C1A7                          5         REPEA:
                           000001  3411 .if OPTIMIZE 
      001535                       3412         _DOLIT JPIMM 
      00C1A7 CD AE 34         [ 4]    1     CALL DOLIT 
      00C1AA 00 CC                    2     .word JPIMM 
      00C1AC CD C0 52         [ 4] 3413         CALL  CCOMMA
                           000000  3414 .else 
                                   3415         CALL     COMPI
                                   3416         .word BRAN
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 122.
Hexadecimal [24-Bits]



                                   3417 .endif 
      00C1AF CD C0 3B         [ 4] 3418         CALL     COMA
      00C1B2 CD B6 5E         [ 4] 3419         CALL     HERE
      00C1B5 CD AF EE         [ 4] 3420         CALL     SWAPP
      00C1B8 CC AE 96         [ 2] 3421         JP     STORE
                                   3422 
                                   3423 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3424 ;       AFT         ( a -- a A )
                                   3425 ;       Jump to THEN in a FOR-AFT-THEN-NEXT 
                                   3426 ;       loop the first time through.
                                   3427 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001549                       3428         _HEADER AFT,COMPO+IMEDD+3,"AFT"
      00C1BB C1 A0                    1         .word LINK 
                           00154B     2         LINK=.
      00C1BD C3                       3         .byte COMPO+IMEDD+3  
      00C1BE 41 46 54                 4         .ascii "AFT"
      00C1C1                          5         AFT:
      00C1C1 CD AF D4         [ 4] 3429         CALL     DROP
      00C1C4 CD C1 74         [ 4] 3430         CALL     AHEAD
      00C1C7 CD B6 5E         [ 4] 3431         CALL     HERE
      00C1CA CC AF EE         [ 2] 3432         JP     SWAPP
                                   3433 
                                   3434 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3435 ;       ABORT"      ( -- ; <string> )
                                   3436 ;       Conditional abort with an error message.
                                   3437 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00155B                       3438         _HEADER ABRTQ,IMEDD+6,'ABORT"'
      00C1CD C1 BD                    1         .word LINK 
                           00155D     2         LINK=.
      00C1CF 86                       3         .byte IMEDD+6  
      00C1D0 41 42 4F 52 54 22        4         .ascii 'ABORT"'
      00C1D6                          5         ABRTQ:
      00C1D6 CD C0 80         [ 4] 3439         CALL     COMPI
      00C1D9 BF 00                 3440         .word ABORQ
      00C1DB CC C0 AA         [ 2] 3441         JP     STRCQ
                                   3442 
                                   3443 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3444 ;       $"     ( -- ; <string> )
                                   3445 ;       Compile an inline string literal.
                                   3446 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00156C                       3447         _HEADER STRQ,IMEDD+COMPO+2,'$"'
      00C1DE C1 CF                    1         .word LINK 
                           00156E     2         LINK=.
      00C1E0 C2                       3         .byte IMEDD+COMPO+2  
      00C1E1 24 22                    4         .ascii '$"'
      00C1E3                          5         STRQ:
      00C1E3 CD C0 80         [ 4] 3448         CALL     COMPI
      00C1E6 BA D3                 3449         .word STRQP 
      00C1E8 CC C0 AA         [ 2] 3450         JP     STRCQ
                                   3451 
                                   3452 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3453 ;       ."          ( -- ; <string> )
                                   3454 ;       Compile an inline string literal 
                                   3455 ;       to be typed out at run time.
                                   3456 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 123.
Hexadecimal [24-Bits]



      001579                       3457         _HEADER DOTQ,IMEDD+COMPO+2,'."'
      00C1EB C1 E0                    1         .word LINK 
                           00157B     2         LINK=.
      00C1ED C2                       3         .byte IMEDD+COMPO+2  
      00C1EE 2E 22                    4         .ascii '."'
      00C1F0                          5         DOTQ:
      00C1F0 CD C0 80         [ 4] 3458         CALL     COMPI
      00C1F3 BA D7                 3459         .word DOTQP 
      00C1F5 CC C0 AA         [ 2] 3460         JP     STRCQ
                                   3461 
                                   3462 ;; Name compiler
                                   3463 
                                   3464 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3465 ;       ?UNIQUE ( a -- a )
                                   3466 ;       Display a warning message
                                   3467 ;       if word already exists.
                                   3468 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001586                       3469         _HEADER UNIQU,7,"?UNIQUE"
      00C1F8 C1 ED                    1         .word LINK 
                           001588     2         LINK=.
      00C1FA 07                       3         .byte 7  
      00C1FB 3F 55 4E 49 51 55 45     4         .ascii "?UNIQUE"
      00C202                          5         UNIQU:
      00C202 CD AF DE         [ 4] 3470         CALL     DUPP
      00C205 CD BD F4         [ 4] 3471         CALL     NAMEQ   ;?name exists
      00C208 CD AE 5D         [ 4] 3472         CALL     QBRAN
      00C20B C2 21                 3473         .word      UNIQ1
      00C20D CD BA D7         [ 4] 3474         CALL     DOTQP   ;redef are OK
      00C210 07                    3475         .byte       7
      00C211 20 72 65 44 65 66 20  3476         .ascii     " reDef "       
      00C218 CD B0 06         [ 4] 3477         CALL     OVER
      00C21B CD B6 47         [ 4] 3478         CALL     COUNT
      00C21E CD BA 91         [ 4] 3479         CALL     TYPES   ;just in case
      00C221 CC AF D4         [ 2] 3480 UNIQ1:  JP     DROP
                                   3481 
                                   3482 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3483 ;       $,n     ( na -- )
                                   3484 ;       Build a new dictionary name
                                   3485 ;       using string at na.
                                   3486 ; compile dans l'espace des variables 
                                   3487 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3488 ;        _HEADER SNAME,3,^/"$,n"/
      00C224                       3489 SNAME: 
      00C224 CD AF DE         [ 4] 3490         CALL     DUPP
      00C227 CD AE C6         [ 4] 3491         CALL     CAT     ;?null input
      00C22A CD AE 5D         [ 4] 3492         CALL     QBRAN
      00C22D C2 5A                 3493         .word      PNAM1
      00C22F CD C2 02         [ 4] 3494         CALL     UNIQU   ;?redefinition
      00C232 CD AF DE         [ 4] 3495         CALL     DUPP
      00C235 CD B6 47         [ 4] 3496         CALL     COUNT
      00C238 CD B1 B1         [ 4] 3497         CALL     PLUS
      00C23B CD B1 21         [ 4] 3498         CALL     VPP
      00C23E CD AE 96         [ 4] 3499         CALL     STORE
      00C241 CD AF DE         [ 4] 3500         CALL     DUPP
      00C244 CD B1 31         [ 4] 3501         CALL     LAST
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 124.
Hexadecimal [24-Bits]



      00C247 CD AE 96         [ 4] 3502         CALL     STORE   ;save na for vocabulary link
      00C24A CD B4 FC         [ 4] 3503         CALL     CELLM   ;link address
      00C24D CD B1 13         [ 4] 3504         CALL     CNTXT
      00C250 CD AE A8         [ 4] 3505         CALL     AT
      00C253 CD AF EE         [ 4] 3506         CALL     SWAPP
      00C256 CD AE 96         [ 4] 3507         CALL     STORE
      00C259 81               [ 4] 3508         RET     ;save code pointer
      00C25A CD BA D3         [ 4] 3509 PNAM1:  CALL     STRQP
      00C25D 05                    3510         .byte      5
      00C25E 20 6E 61 6D 65        3511         .ascii     " name" ;null input
      00C263 CC BF 08         [ 2] 3512         JP     ABOR1
                                   3513 
                                   3514 ;; FORTH compiler
                                   3515 
                                   3516 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3517 ;       $COMPILE        ( a -- )
                                   3518 ;       Compile next word to
                                   3519 ;       dictionary as a token or literal.
                                   3520 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0015F4                       3521         _HEADER SCOMP,8,"$COMPILE"
      00C266 C1 FA                    1         .word LINK 
                           0015F6     2         LINK=.
      00C268 08                       3         .byte 8  
      00C269 24 43 4F 4D 50 49 4C     4         .ascii "$COMPILE"
             45
      00C271                          5         SCOMP:
      00C271 CD BD F4         [ 4] 3522         CALL     NAMEQ
      00C274 CD B1 41         [ 4] 3523         CALL     QDUP    ;?defined
      00C277 CD AE 5D         [ 4] 3524         CALL     QBRAN
      00C27A C2 92                 3525         .word      SCOM2
      00C27C CD AE A8         [ 4] 3526         CALL     AT
      00C27F CD AE 34         [ 4] 3527         CALL     DOLIT
      00C282 80 00                 3528         .word     0x8000	;  IMEDD*256
      00C284 CD B0 3B         [ 4] 3529         CALL     ANDD    ;?immediate
      00C287 CD AE 5D         [ 4] 3530         CALL     QBRAN
      00C28A C2 8F                 3531         .word      SCOM1
      00C28C CC AE 89         [ 2] 3532         JP     EXECU
      00C28F CC C2 E0         [ 2] 3533 SCOM1:  JP     JSRC
      00C292 CD B9 D2         [ 4] 3534 SCOM2:  CALL     NUMBQ   ;try to convert to number 
      00C295 CD B1 41         [ 4] 3535         CALL    QDUP  
      00C298 CD AE 5D         [ 4] 3536         CALL     QBRAN
      00C29B BF 08                 3537         .word      ABOR1
                           000000  3538 .if WANT_DOUBLE 
                                   3539         _DOLIT  -1
                                   3540         CALL    EQUAL
                                   3541         _QBRAN DLITER
                                   3542         JP  LITER 
                                   3543 .endif 
                           000000  3544 .if WANT_FLOAT24 
                                   3545         _DOLIT -1 
                                   3546         CALL EQUAL 
                                   3547         _QBRAN FLITER
                                   3548         JP  LITER  
                                   3549 .endif 
      00162B                       3550         _TDROP 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 125.
Hexadecimal [24-Bits]



      00C29D 1C 00 02         [ 2]    1     ADDW X,#CELLL  
      00C2A0 CC C0 A2         [ 2] 3551         JP     LITER
                                   3552 
                                   3553 
                                   3554 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3555 ;       OVERT   ( -- )
                                   3556 ;       Link a new word into vocabulary.
                                   3557 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001631                       3558         _HEADER OVERT,5,"OVERT"
      00C2A3 C2 68                    1         .word LINK 
                           001633     2         LINK=.
      00C2A5 05                       3         .byte 5  
      00C2A6 4F 56 45 52 54           4         .ascii "OVERT"
      00C2AB                          5         OVERT:
      00C2AB CD B1 31         [ 4] 3559         CALL     LAST
      00C2AE CD AE A8         [ 4] 3560         CALL     AT
      00C2B1 CD B1 13         [ 4] 3561         CALL     CNTXT
      00C2B4 CC AE 96         [ 2] 3562         JP     STORE
                                   3563 
                                   3564 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3565 ;       ;       ( -- )
                                   3566 ;       Terminate a colon definition.
                                   3567 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001645                       3568         _HEADER SEMIS,IMEDD+COMPO+1,^/";"/
      00C2B7 C2 A5                    1         .word LINK 
                           001647     2         LINK=.
      00C2B9 C1                       3         .byte IMEDD+COMPO+1  
      00C2BA 3B                       4         .ascii ";"
      00C2BB                          5         SEMIS:
                           000001  3569 .if OPTIMIZE ; more compact and faster
      00C2BB CD AE 34         [ 4] 3570         call DOLIT 
      00C2BE 00 81                 3571         .word 0x81   ; opcode for RET 
      00C2C0 CD C0 52         [ 4] 3572         call CCOMMA 
                           000000  3573 .else
                                   3574         CALL     COMPI
                                   3575         .word EXIT 
                                   3576 .endif 
      00C2C3 CD BF 6D         [ 4] 3577         CALL     LBRAC
      00C2C6 CC C2 AB         [ 2] 3578         JP OVERT 
                                   3579 
                                   3580 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3581 ;       ]       ( -- )
                                   3582 ;       Start compiling words in
                                   3583 ;       input stream.
                                   3584 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001657                       3585         _HEADER RBRAC,1,"]"
      00C2C9 C2 B9                    1         .word LINK 
                           001659     2         LINK=.
      00C2CB 01                       3         .byte 1  
      00C2CC 5D                       4         .ascii "]"
      00C2CD                          5         RBRAC:
      00C2CD CD AE 34         [ 4] 3586         CALL   DOLIT
      00C2D0 C2 71                 3587         .word  SCOMP
      00C2D2 CD B0 F1         [ 4] 3588         CALL   TEVAL
      00C2D5 CC AE 96         [ 2] 3589         JP     STORE
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 126.
Hexadecimal [24-Bits]



                                   3590 
                                   3591 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3592 ;       CALL,    ( ca -- )
                                   3593 ;       Compile a subroutine call.
                                   3594 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001666                       3595         _HEADER JSRC,5,^/"CALL,"/
      00C2D8 C2 CB                    1         .word LINK 
                           001668     2         LINK=.
      00C2DA 05                       3         .byte 5  
      00C2DB 43 41 4C 4C 2C           4         .ascii "CALL,"
      00C2E0                          5         JSRC:
                           000001  3596 .if OPTIMIZE 
                                   3597 ;;;;; optimization code ;;;;;;;;;;;;;;;
      00C2E0 90 AE AF D4      [ 2] 3598         LDW Y,#DROP 
      00C2E4 90 BF 48         [ 2] 3599         LDW YTEMP,Y 
      00C2E7 90 93            [ 1] 3600         LDW Y,X 
      00C2E9 90 FE            [ 2] 3601         LDW Y,(Y)
      00C2EB 90 B3 48         [ 2] 3602         CPW Y,YTEMP 
      00C2EE 26 13            [ 1] 3603         JRNE JSRC1         
                                   3604 ; replace CALL DROP BY  ADDW X,#CELLL 
      00C2F0 1C 00 02         [ 2] 3605         ADDW X,#CELLL 
      001681                       3606         _DOLIT ADDWX ; opcode 
      00C2F3 CD AE 34         [ 4]    1     CALL DOLIT 
      00C2F6 00 1C                    2     .word ADDWX 
      00C2F8 CD C0 52         [ 4] 3607         CALL   CCOMMA 
      001689                       3608         _DOLIT CELLL 
      00C2FB CD AE 34         [ 4]    1     CALL DOLIT 
      00C2FE 00 02                    2     .word CELLL 
      00C300 CC C0 3B         [ 2] 3609         JP      COMA 
      00C303                       3610 JSRC1: ; check for DDROP 
      00C303 90 AE B1 91      [ 2] 3611         LDW Y,#DDROP 
      00C307 90 BF 48         [ 2] 3612         LDW YTEMP,Y 
      00C30A 90 93            [ 1] 3613         LDW Y,X 
      00C30C 90 FE            [ 2] 3614         LDW Y,(Y)
      00C30E 90 B3 48         [ 2] 3615         CPW Y,YTEMP 
      00C311 26 13            [ 1] 3616         JRNE JSRC2 
                                   3617 ; replace CALL DDROP BY ADDW X,#2*CELLL 
      00C313 1C 00 02         [ 2] 3618         ADDW X,#CELLL 
      0016A4                       3619         _DOLIT ADDWX 
      00C316 CD AE 34         [ 4]    1     CALL DOLIT 
      00C319 00 1C                    2     .word ADDWX 
      00C31B CD C0 52         [ 4] 3620         CALL  CCOMMA 
      0016AC                       3621         _DOLIT 2*CELLL 
      00C31E CD AE 34         [ 4]    1     CALL DOLIT 
      00C321 00 04                    2     .word 2*CELLL 
      00C323 CC C0 3B         [ 2] 3622         JP  COMA 
      00C326                       3623 JSRC2: 
                                   3624 ;;;;;;;; end optimization code ;;;;;;;;;;        
                                   3625 .endif        
      00C326 CD AE 34         [ 4] 3626         CALL     DOLIT
      00C329 00 CD                 3627         .word     CALLL     ;CALL
      00C32B CD C0 52         [ 4] 3628         CALL     CCOMMA
      00C32E CC C0 3B         [ 2] 3629         JP     COMA
                                   3630 
                                   3631 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 127.
Hexadecimal [24-Bits]



                                   3632 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3633 ;       :       ( -- ; <string> )
                                   3634 ;       Start a new colon definition
                                   3635 ;       using next word as its name.
                                   3636 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0016BF                       3637         _HEADER COLN,1,":"
      00C331 C2 DA                    1         .word LINK 
                           0016C1     2         LINK=.
      00C333 01                       3         .byte 1  
      00C334 3A                       4         .ascii ":"
      00C335                          5         COLN:
      00C335 CD BC F7         [ 4] 3638         CALL   TOKEN
      00C338 CD C2 24         [ 4] 3639         CALL   SNAME
      00C33B CC C2 CD         [ 2] 3640         JP     RBRAC
                                   3641 
                                   3642 
                                   3643 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3644 ;       IMMEDIATE       ( -- )
                                   3645 ;       Make last compiled word
                                   3646 ;       an immediate word.
                                   3647 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0016CC                       3648         _HEADER IMMED,9,"IMMEDIATE"
      00C33E C3 33                    1         .word LINK 
                           0016CE     2         LINK=.
      00C340 09                       3         .byte 9  
      00C341 49 4D 4D 45 44 49 41     4         .ascii "IMMEDIATE"
             54 45
      00C34A                          5         IMMED:
      00C34A CD AE 34         [ 4] 3649         CALL	DOLIT
      00C34D 80 00                 3650         .word	(IMEDD<<8)
      00C34F CD B1 31         [ 4] 3651 IMM01:  CALL	LAST
      00C352 CD AE A8         [ 4] 3652         CALL    AT
      00C355 CD AE A8         [ 4] 3653         CALL    AT
      00C358 CD B0 4F         [ 4] 3654         CALL    ORR
      00C35B CD B1 31         [ 4] 3655         CALL    LAST
      00C35E CD AE A8         [ 4] 3656         CALL    AT
      00C361 CC AE 96         [ 2] 3657         JP      STORE
                                   3658 
                                   3659 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3660 ;		COMPILE-ONLY  ( -- )
                                   3661 ;		Make last compiled word 
                                   3662 ;		a compile only word.
                                   3663 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0016F2                       3664         _HEADER COMPONLY,12,"COMPILE-ONLY"
      00C364 C3 40                    1         .word LINK 
                           0016F4     2         LINK=.
      00C366 0C                       3         .byte 12  
      00C367 43 4F 4D 50 49 4C 45     4         .ascii "COMPILE-ONLY"
             2D 4F 4E 4C 59
      00C373                          5         COMPONLY:
      00C373 CD AE 34         [ 4] 3665         CALL     DOLIT
      00C376 40 00                 3666         .word    (COMPO<<8)
      00C378 CC C3 4F         [ 2] 3667         JP       IMM01
                                   3668 		
                                   3669 ;; Defining words
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 128.
Hexadecimal [24-Bits]



                                   3670 
                                   3671 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3672 ;       CREATE  ( -- ; <string> )
                                   3673 ;       Compile a new array
                                   3674 ;       without allocating space.
                                   3675 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001709                       3676         _HEADER CREAT,6,"CREATE"
      00C37B C3 66                    1         .word LINK 
                           00170B     2         LINK=.
      00C37D 06                       3         .byte 6  
      00C37E 43 52 45 41 54 45        4         .ascii "CREATE"
      00C384                          5         CREAT:
      00C384 CD BC F7         [ 4] 3677         CALL     TOKEN
      00C387 CD C2 24         [ 4] 3678         CALL     SNAME
      00C38A CD C2 AB         [ 4] 3679         CALL     OVERT        
      00C38D CD C0 80         [ 4] 3680         CALL     COMPI 
      00C390 B0 94                 3681         .word DOVAR 
      00C392 81               [ 4] 3682         RET
                                   3683 
                                   3684 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3685 ;       VARIABLE  ( -- ; <string> )
                                   3686 ;       Compile a new variable
                                   3687 ;       initialized to 0.
                                   3688 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001721                       3689         _HEADER VARIA,8,"VARIABLE"
      00C393 C3 7D                    1         .word LINK 
                           001723     2         LINK=.
      00C395 08                       3         .byte 8  
      00C396 56 41 52 49 41 42 4C     4         .ascii "VARIABLE"
             45
      00C39E                          5         VARIA:
      00C39E CD B5 84         [ 4] 3690         CALL ZERO 
      00C3A1 CD C3 84         [ 4] 3691         CALL CREAT 
      00C3A4 CC C0 3B         [ 2] 3692         JP COMA 
                                   3693 
                                   3694 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3695 ;       CONSTANT  ( n -- ; <string> )
                                   3696 ;       Compile a new constant 
                                   3697 ;       n CONSTANT name 
                                   3698 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001735                       3699         _HEADER CONSTANT,8,"CONSTANT"
      00C3A7 C3 95                    1         .word LINK 
                           001737     2         LINK=.
      00C3A9 08                       3         .byte 8  
      00C3AA 43 4F 4E 53 54 41 4E     4         .ascii "CONSTANT"
             54
      00C3B2                          5         CONSTANT:
      00C3B2 CD BC F7         [ 4] 3700         CALL TOKEN
      00C3B5 CD C2 24         [ 4] 3701         CALL SNAME 
      00C3B8 CD C2 AB         [ 4] 3702         CALL OVERT 
      00C3BB CD C0 80         [ 4] 3703         CALL COMPI 
      00C3BE C3 C3                 3704         .word DOCONST
      00C3C0 CC C0 3B         [ 2] 3705         JP COMA 
                                   3706 
                                   3707 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 129.
Hexadecimal [24-Bits]



                                   3708 ; CONSTANT runtime semantic 
                                   3709 ; doCONST  ( -- n )
                                   3710 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3711 ;       _HEADER DOCONST,7,"DOCONST"
      00C3C3                       3712 DOCONST:
      00C3C3 1D 00 02         [ 2] 3713         subw x,#CELLL
      00C3C6 90 85            [ 2] 3714         popw y 
      00C3C8 90 FE            [ 2] 3715         ldw y,(y) 
      00C3CA FF               [ 2] 3716         ldw (x),y 
      00C3CB 81               [ 4] 3717         ret 
                                   3718 
                                   3719 ;----------------------------------
                                   3720 ; create double constant 
                                   3721 ; 2CONSTANT ( d -- ; <string> )
                                   3722 ;----------------------------------
      00175A                       3723         _HEADER DCONST,9,"2CONSTANT"
      00C3CC C3 A9                    1         .word LINK 
                           00175C     2         LINK=.
      00C3CE 09                       3         .byte 9  
      00C3CF 32 43 4F 4E 53 54 41     4         .ascii "2CONSTANT"
             4E 54
      00C3D8                          5         DCONST:
      00C3D8 CD BC F7         [ 4] 3724         CALL TOKEN
      00C3DB CD C2 24         [ 4] 3725         CALL SNAME 
      00C3DE CD C2 AB         [ 4] 3726         CALL OVERT 
      00C3E1 CD C0 80         [ 4] 3727         CALL COMPI 
      00C3E4 C3 EC                 3728         .word DO_DCONST
      00C3E6 CD C0 3B         [ 4] 3729         CALL COMA
      00C3E9 CC C0 3B         [ 2] 3730         JP COMA  
                                   3731 
                                   3732 ;----------------------------------
                                   3733 ; runtime for DCONST 
                                   3734 ; stack double constant 
                                   3735 ; DO-DCONST ( -- d )
                                   3736 ;-----------------------------------
                                   3737 ;       _HEADER DO_DCONST,9,"DO-DCONST"
      00C3EC                       3738 DO_DCONST:
      00C3EC 90 85            [ 2] 3739     popw y 
      00C3EE 90 BF 48         [ 2] 3740     ldw YTEMP,y 
      00C3F1 1D 00 04         [ 2] 3741     subw x,#2*CELLL 
      00C3F4 90 FE            [ 2] 3742     ldw y,(y)
      00C3F6 FF               [ 2] 3743     ldw (x),y 
      00C3F7 90 BE 48         [ 2] 3744     ldw y,YTEMP 
      00C3FA 90 EE 02         [ 2] 3745     ldw y,(2,y)
      00C3FD EF 02            [ 2] 3746     ldw (2,x),y 
      00C3FF 81               [ 4] 3747     ret 
                                   3748 
                                   3749 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3750 ;;          TOOLS 
                                   3751 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3752 
                                   3753 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3754 ;       _TYPE   ( b u -- )
                                   3755 ;       Display a string. Filter
                                   3756 ;       non-printing characters.
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 130.
Hexadecimal [24-Bits]



                                   3757 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00178E                       3758         _HEADER UTYPE,5,"_TYPE"
      00C400 C3 CE                    1         .word LINK 
                           001790     2         LINK=.
      00C402 05                       3         .byte 5  
      00C403 5F 54 59 50 45           4         .ascii "_TYPE"
      00C408                          5         UTYPE:
      00C408 CD AF A7         [ 4] 3759         CALL     TOR     ;start count down loop
      00C40B 20 0F            [ 2] 3760         JRA     UTYP2   ;skip first pass
      00C40D CD AF DE         [ 4] 3761 UTYP1:  CALL     DUPP
      00C410 CD AE C6         [ 4] 3762         CALL     CAT
      00C413 CD B5 AE         [ 4] 3763         CALL     TCHAR
      00C416 CD AD FB         [ 4] 3764         CALL     EMIT    ;display only printable
      00C419 CD B5 18         [ 4] 3765         CALL     ONEP    ;increment address
      00C41C CD AE 48         [ 4] 3766 UTYP2:  CALL     DONXT
      00C41F C4 0D                 3767         .word      UTYP1   ;loop till done
      00C421 CC AF D4         [ 2] 3768         JP     DROP
                                   3769 
                                   3770 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3771 ;       dm+     ( a u -- a )
                                   3772 ;       Dump u bytes from ,
                                   3773 ;       leaving a+u on  stack.
                                   3774 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0017B2                       3775         _HEADER DUMPP,3,"DM+"
      00C424 C4 02                    1         .word LINK 
                           0017B4     2         LINK=.
      00C426 03                       3         .byte 3  
      00C427 44 4D 2B                 4         .ascii "DM+"
      00C42A                          5         DUMPP:
      00C42A CD B0 06         [ 4] 3776         CALL     OVER
      00C42D CD AE 34         [ 4] 3777         CALL     DOLIT
      00C430 00 04                 3778         .word      4
      00C432 CD BB 00         [ 4] 3779         CALL     UDOTR   ;display address
      00C435 CD BA 67         [ 4] 3780         CALL     SPAC
      00C438 CD AF A7         [ 4] 3781         CALL     TOR     ;start count down loop
      00C43B 20 11            [ 2] 3782         JRA     PDUM2   ;skip first pass
      00C43D CD AF DE         [ 4] 3783 PDUM1:  CALL     DUPP
      00C440 CD AE C6         [ 4] 3784         CALL     CAT
      00C443 CD AE 34         [ 4] 3785         CALL     DOLIT
      00C446 00 03                 3786         .word      3
      00C448 CD BB 00         [ 4] 3787         CALL     UDOTR   ;display numeric data
      00C44B CD B5 18         [ 4] 3788         CALL     ONEP    ;increment address
      00C44E CD AE 48         [ 4] 3789 PDUM2:  CALL     DONXT
      00C451 C4 3D                 3790         .word      PDUM1   ;loop till done
      00C453 81               [ 4] 3791         RET
                                   3792 
                                   3793 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3794 ;       DUMP    ( a u -- )
                                   3795 ;       Dump u bytes from a,
                                   3796 ;       in a formatted manner.
                                   3797 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0017E2                       3798         _HEADER DUMP,4,"DUMP"
      00C454 C4 26                    1         .word LINK 
                           0017E4     2         LINK=.
      00C456 04                       3         .byte 4  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 131.
Hexadecimal [24-Bits]



      00C457 44 55 4D 50              4         .ascii "DUMP"
      00C45B                          5         DUMP:
      00C45B CD B0 A2         [ 4] 3799         CALL     BASE
      00C45E CD AE A8         [ 4] 3800         CALL     AT
      00C461 CD AF A7         [ 4] 3801         CALL     TOR
      00C464 CD B8 27         [ 4] 3802         CALL     HEX     ;save radix, set hex
      00C467 CD AE 34         [ 4] 3803         CALL     DOLIT
      00C46A 00 10                 3804         .word      16
      00C46C CD B4 3D         [ 4] 3805         CALL     SLASH   ;change count to lines
      00C46F CD AF A7         [ 4] 3806         CALL     TOR     ;start count down loop
      00C472 CD BA AA         [ 4] 3807 DUMP1:  CALL     CRLF
      00C475 CD AE 34         [ 4] 3808         CALL     DOLIT
      00C478 00 10                 3809         .word      16
      00C47A CD B1 9C         [ 4] 3810         CALL     DDUP
      00C47D CD C4 2A         [ 4] 3811         CALL     DUMPP   ;display numeric
      00C480 CD B1 52         [ 4] 3812         CALL     ROT
      00C483 CD B1 52         [ 4] 3813         CALL     ROT
      00C486 CD BA 67         [ 4] 3814         CALL     SPAC
      00C489 CD BA 67         [ 4] 3815         CALL     SPAC
      00C48C CD C4 08         [ 4] 3816         CALL     UTYPE   ;display printable characters
      00C48F CD AE 48         [ 4] 3817         CALL     DONXT
      00C492 C4 72                 3818         .word      DUMP1   ;loop till done
      00C494 CD AF D4         [ 4] 3819 DUMP3:  CALL     DROP
      00C497 CD AE F9         [ 4] 3820         CALL     RFROM
      00C49A CD B0 A2         [ 4] 3821         CALL     BASE
      00C49D CC AE 96         [ 2] 3822         JP     STORE   ;restore radix
                                   3823 
                                   3824 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3825 ;       .S      ( ... -- ... )
                                   3826 ;        Display  contents of stack.
                                   3827 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00182E                       3828         _HEADER DOTS,2,".S"
      00C4A0 C4 56                    1         .word LINK 
                           001830     2         LINK=.
      00C4A2 02                       3         .byte 2  
      00C4A3 2E 53                    4         .ascii ".S"
      00C4A5                          5         DOTS:
      00C4A5 CD BA AA         [ 4] 3829         CALL     CRLF
      00C4A8 CD B5 C6         [ 4] 3830         CALL     DEPTH   ;stack depth
      00C4AB CD AF A7         [ 4] 3831         CALL     TOR     ;start count down loop
      00C4AE 20 09            [ 2] 3832         JRA     DOTS2   ;skip first pass
      00C4B0 CD AF 0A         [ 4] 3833 DOTS1:  CALL     RAT
      00C4B3 CD B5 DD         [ 4] 3834 	CALL     PICK
      00C4B6 CD BB 50         [ 4] 3835         CALL     DOT     ;index stack, display contents
      00C4B9 CD AE 48         [ 4] 3836 DOTS2:  CALL     DONXT
      00C4BC C4 B0                 3837         .word      DOTS1   ;loop till done
      00C4BE CD BA D7         [ 4] 3838         CALL     DOTQP
      00C4C1 05                    3839         .byte      5
      00C4C2 20 3C 73 70 20        3840         .ascii     " <sp "
      00C4C7 81               [ 4] 3841         RET
                                   3842 
                                   3843 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3844 ;       >NAME   ( ca -- na | F )
                                   3845 ;       Convert code address
                                   3846 ;       to a name address.
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 132.
Hexadecimal [24-Bits]



                                   3847 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      001856                       3848         _HEADER TNAME,5,">NAME"
      00C4C8 C4 A2                    1         .word LINK 
                           001858     2         LINK=.
      00C4CA 05                       3         .byte 5  
      00C4CB 3E 4E 41 4D 45           4         .ascii ">NAME"
      00C4D0                          5         TNAME:
      00C4D0 CD B1 13         [ 4] 3849         CALL     CNTXT   ;vocabulary link
      00C4D3 CD AE A8         [ 4] 3850 TNAM2:  CALL     AT
      00C4D6 CD AF DE         [ 4] 3851         CALL     DUPP    ;?last word in a vocabulary
      00C4D9 CD AE 5D         [ 4] 3852         CALL     QBRAN
      00C4DC C4 F7                 3853         .word      TNAM4
      00C4DE CD B1 9C         [ 4] 3854         CALL     DDUP
      00C4E1 CD BD 05         [ 4] 3855         CALL     NAMET
      00C4E4 CD B0 64         [ 4] 3856         CALL     XORR    ;compare
      00C4E7 CD AE 5D         [ 4] 3857         CALL     QBRAN
      00C4EA C4 F1                 3858         .word      TNAM3
      00C4EC CD B4 FC         [ 4] 3859         CALL     CELLM   ;continue with next word
      00C4EF 20 E2            [ 2] 3860         JRA     TNAM2
      00C4F1 CD AF EE         [ 4] 3861 TNAM3:  CALL     SWAPP
      00C4F4 CC AF D4         [ 2] 3862         JP     DROP
      00C4F7 CD B1 91         [ 4] 3863 TNAM4:  CALL     DDROP
      00C4FA CC B5 84         [ 2] 3864         JP     ZERO
                                   3865 
                                   3866 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3867 ;       .ID     ( na -- )
                                   3868 ;        Display  name at address.
                                   3869 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00188B                       3870         _HEADER DOTID,3,".ID"
      00C4FD C4 CA                    1         .word LINK 
                           00188D     2         LINK=.
      00C4FF 03                       3         .byte 3  
      00C500 2E 49 44                 4         .ascii ".ID"
      00C503                          5         DOTID:
      00C503 CD B1 41         [ 4] 3871         CALL     QDUP    ;if zero no name
      00C506 CD AE 5D         [ 4] 3872         CALL     QBRAN
      00C509 C5 19                 3873         .word      DOTI1
      00C50B CD B6 47         [ 4] 3874         CALL     COUNT
      00C50E CD AE 34         [ 4] 3875         CALL     DOLIT
      00C511 00 1F                 3876         .word      0x1F
      00C513 CD B0 3B         [ 4] 3877         CALL     ANDD    ;mask lexicon bits
      00C516 CC C4 08         [ 2] 3878         JP     UTYPE
      00C519 CD BA D7         [ 4] 3879 DOTI1:  CALL     DOTQP
      00C51C 09                    3880         .byte      9
      00C51D 20 6E 6F 4E 61 6D 65  3881         .ascii     " noName"
      00C524 81               [ 4] 3882         RET
                                   3883 
                           000000  3884 WANT_SEE=0
                           000000  3885 .if WANT_SEE 
                                   3886 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3887 ;       SEE     ( -- ; <string> )
                                   3888 ;       A simple decompiler.
                                   3889 ;       Updated for byte machines.
                                   3890 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3891         _HEADER SEE,3,"SEE"
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 133.
Hexadecimal [24-Bits]



                                   3892         CALL     TICKK    ;starting address
                                   3893         CALL     CRLF
                                   3894         CALL     ONEM
                                   3895 SEE1:   CALL     ONEP
                                   3896         CALL     DUPP
                                   3897         CALL     AT
                                   3898         CALL     DUPP
                                   3899         CALL     QBRAN
                                   3900         .word    SEE2
                                   3901         CALL     TNAME   ;?is it a name
                                   3902 SEE2:   CALL     QDUP    ;name address or zero
                                   3903         CALL     QBRAN
                                   3904         .word    SEE3
                                   3905         CALL     SPAC
                                   3906         CALL     DOTID   ;display name
                                   3907         CALL     ONEP
                                   3908         JRA      SEE4
                                   3909 SEE3:   CALL     DUPP
                                   3910         CALL     CAT
                                   3911         CALL     UDOT    ;display number
                                   3912 SEE4:   CALL     NUFQ    ;user control
                                   3913         CALL     QBRAN
                                   3914         .word    SEE1
                                   3915         JP     DROP
                                   3916 .endif ; WANT_SEE 
                                   3917 
                                   3918 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3919 ;       WORDS   ( -- )
                                   3920 ;       Display names in vocabulary.
                                   3921 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0018B3                       3922         _HEADER WORDS,5,"WORDS"
      00C525 C4 FF                    1         .word LINK 
                           0018B5     2         LINK=.
      00C527 05                       3         .byte 5  
      00C528 57 4F 52 44 53           4         .ascii "WORDS"
      00C52D                          5         WORDS:
      00C52D CD BA AA         [ 4] 3923         CALL     CRLF
      00C530 CD B1 13         [ 4] 3924         CALL     CNTXT   ;only in context
      00C533 CD AE A8         [ 4] 3925 WORS1:  CALL     AT
      00C536 CD B1 41         [ 4] 3926         CALL     QDUP    ;?at end of list
      00C539 CD AE 5D         [ 4] 3927         CALL     QBRAN
      00C53C C5 4F                 3928         .word      WORS2
      00C53E CD AF DE         [ 4] 3929         CALL     DUPP
      00C541 CD BA 67         [ 4] 3930         CALL     SPAC
      00C544 CD C5 03         [ 4] 3931         CALL     DOTID   ;display a name
      00C547 CD B4 FC         [ 4] 3932         CALL     CELLM
      00C54A CD AE 79         [ 4] 3933         CALL     BRAN
      00C54D C5 33                 3934         .word      WORS1
      00C54F 81               [ 4] 3935 WORS2:  RET
                                   3936 
                                   3937         
                                   3938 ;; Hardware reset
                                   3939 
      00C550 70 31 46 6F 72 74 68  3940 forth_name: .asciz "p1Forth\n"
             0A 00
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 134.
Hexadecimal [24-Bits]



      00C559 43 6F 70 79 72 69 67  3941 forth_cpr: .asciz "Copyright Jacques Deschenes 2023,24\n"
             68 74 20 4A 61 63 71
             75 65 73 20 44 65 73
             63 68 65 6E 65 73 20
             32 30 32 33 2C 32 34
             0A 00
                                   3942 
                                   3943 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3944 ;       hi      ( -- )
                                   3945 ;       Display sign-on message.
                                   3946 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00190C                       3947         _HEADER HI,2,"HI"
      00C57E C5 27                    1         .word LINK 
                           00190E     2         LINK=.
      00C580 02                       3         .byte 2  
      00C581 48 49                    4         .ascii "HI"
      00C583                          5         HI:
      00C583 CD BA AA         [ 4] 3948         CALL     CRLF
      00C586 89               [ 2] 3949         pushw x 
      00C587 AE C5 50         [ 2] 3950         ldw x,#forth_name 
      00C58A 90 AE C5 59      [ 2] 3951         ldw y,#forth_cpr 
      00C58E 4B 00            [ 1] 3952         push #REV 
      00C590 4B 00            [ 1] 3953         push #MINOR  
      00C592 4B 05            [ 1] 3954         push #MAJOR
      00C594 CD 89 47         [ 4] 3955         call app_info 
      001925                       3956         _drop 3
      00C597 5B 03            [ 2]    1     addw sp,#3 
      00C599 85               [ 2] 3957         popw x 
      00C59A 81               [ 4] 3958         ret 
                                   3959 
                           000000  3960 .if WANT_DOUBLE 
                                   3961         CALL DBLVER 
                                   3962 .endif 
                           000000  3963 .if WANT_FLOAT|WANT_FLOAT24
                                   3964         CALL FVER 
                                   3965 .endif         
      00C59B CC BA AA         [ 2] 3966         JP     CRLF
                                   3967 
                                   3968 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3969 ;       'BOOT   ( -- a )
                                   3970 ;       The application startup vector.
                                   3971 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00192C                       3972         _HEADER TBOOT,5,"'BOOT"
      00C59E C5 80                    1         .word LINK 
                           00192E     2         LINK=.
      00C5A0 05                       3         .byte 5  
      00C5A1 27 42 4F 4F 54           4         .ascii "'BOOT"
      00C5A6                          5         TBOOT:
      00C5A6 CD B0 94         [ 4] 3973         CALL     DOVAR
      00C5A9 C5 83                 3974         .word    HI      ;application to boot
                                   3975 
                                   3976 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   3977 ;       COLD    ( -- )
                                   3978 ;       The hilevel cold start s=ence.
                                   3979 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 135.
Hexadecimal [24-Bits]



      001939                       3980         _HEADER COLD,4,"COLD"
      00C5AB C5 A0                    1         .word LINK 
                           00193B     2         LINK=.
      00C5AD 04                       3         .byte 4  
      00C5AE 43 4F 4C 44              4         .ascii "COLD"
      00C5B2                          5         COLD:
      00C5B2 CD AE 34         [ 4] 3981 COLD1:  CALL     DOLIT
      00C5B5 AC 83                 3982         .word      UZERO
      00C5B7 CD AE 34         [ 4] 3983 	CALL     DOLIT
      00C5BA 00 30                 3984         .word      UPP
      00C5BC CD AE 34         [ 4] 3985         CALL     DOLIT
      00C5BF 00 16                 3986 	.word      UEND-UZERO
      00C5C1 CD B6 AB         [ 4] 3987         CALL     CMOVE   ;initialize user area
      00C5C4                       3988 6$:      
      00C5C4 CD BF E9         [ 4] 3989         CALL     PRESE   ;initialize data stack and TIB
      00C5C7 CD C5 A6         [ 4] 3990         CALL     TBOOT
      00C5CA CD B6 94         [ 4] 3991         CALL     ATEXE   ;application boot
      00C5CD CD C2 AB         [ 4] 3992         CALL     OVERT
      00C5D0 CC C0 06         [ 2] 3993         JP     QUIT    ;start interpretation
                                   3994 
                           000000  3995 .if WANT_SCALING_CONST 
                                   3996         .include "const_ratio.asm"
                                   3997 .endif
                           000000  3998 .if WANT_CONST_TABLE 
                                   3999         .include "ctable.asm"
                                   4000 .endif
                           000000  4001 .if WANT_DOUBLE 
                                   4002         .include "double.asm"
                                   4003 .endif 
                           000000  4004 .if WANT_FLOAT 
                                   4005         .include "float.asm"
                                   4006 .endif 
                           000000  4007 .if WANT_FLOAT24 
                                   4008         .include "float24.asm"
                                   4009 .endif 
                                   4010 
                           00193B  4011 LASTN =	LINK   ;last name defined
                                   4012 
                                   4013 
                                   4014 
                                   4015 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 136.
Hexadecimal [24-Bits]

Symbol Table

    .__.$$$.=  002710 L   |     .__.ABS.=  000000 G   |     .__.CPU.=  000000 L
    .__.H$L.=  000001 L   |   1 AB1        0005F8 R   |   1 ABOR1      001296 R
  1 ABOR2      0012B1 R   |   1 ABORQ      00128E R   |   1 ABORT      00127F R
  1 ABRTQ      001564 R   |   1 ABSS       0005EF R   |   1 ACCEP      001215 R
  1 ACCEPT_C   000C26 GR  |   1 ACCP1      00121E R   |   1 ACCP2      001244 R
  1 ACCP3      001247 R   |   1 ACCP4      001249 R   |     ACK     =  000006 
    ADC_CR1 =  005401     |     ADC_CR1_=  000000     |     ADC_CR1_=  000001 
    ADC_CR1_=  000004     |     ADC_CR1_=  000005     |     ADC_CR1_=  000006 
    ADC_CR2 =  005402     |     ADC_CR2_=  000003     |     ADC_CR2_=  000004 
    ADC_CR2_=  000005     |     ADC_CR2_=  000006     |     ADC_CR2_=  000001 
    ADC_CR3 =  005403     |     ADC_CR3_=  000007     |     ADC_CR3_=  000006 
    ADC_CSR =  005400     |     ADC_CSR_=  000006     |     ADC_CSR_=  000004 
    ADC_CSR_=  000000     |     ADC_CSR_=  000001     |     ADC_CSR_=  000002 
    ADC_CSR_=  000003     |     ADC_CSR_=  000007     |     ADC_CSR_=  000005 
    ADC_DRH =  005404     |     ADC_DRL =  005405     |     ADC_TDRH=  005406 
    ADC_TDRL=  005407     |     ADDWX   =  00001C     |   1 ADJ_CSTR   000C69 R
    ADR_SIZE=  000002     |     AFR     =  004803     |     AFR0_ADC=  000000 
    AFR1_TIM=  000001     |     AFR2_CCO=  000002     |     AFR3_TIM=  000003 
    AFR4_TIM=  000004     |     AFR5_TIM=  000005     |     AFR6_I2C=  000006 
    AFR7_BEE=  000007     |   1 AFT        00154F R   |   1 AGAIN      0014A8 R
  1 AHEAD      001502 R   |   1 ALLOT      0013BF R   |   1 ANDD       0003C9 R
    APP_DATA=  000030     |   1 AT         000236 R   |   1 ATEXE      000A22 R
    AWU_APR =  0050F1     |     AWU_CSR =  0050F0     |     AWU_CSR_=  000004 
    AWU_TBR =  0050F2     |     B0_MASK =  000001     |     B115200 =  000006 
    B19200  =  000003     |     B1_MASK =  000002     |     B230400 =  000007 
    B2400   =  000000     |     B2_MASK =  000004     |     B38400  =  000004 
    B3_MASK =  000008     |     B460800 =  000008     |     B4800   =  000001 
    B4_MASK =  000010     |     B57600  =  000005     |     B5_MASK =  000020 
    B6_MASK =  000040     |     B7_MASK =  000080     |     B921600 =  000009 
    B9600   =  000002     |   1 BACK1      0011BD R   |   1 BASE       000430 R
    BASEE   =  00000A     |   1 BCOMP      0013FE R   |   1 BDIGS      000B1A R
    BEEP_BIT=  000004     |     BEEP_CSR=  0050F3     |     BEEP_MAS=  000010 
    BEEP_POR=  00000F     |   1 BEGIN      00148D R   |     BELL    =  000007 
    BIT0    =  000000     |     BIT1    =  000001     |     BIT2    =  000002 
    BIT3    =  000003     |     BIT4    =  000004     |     BIT5    =  000005 
    BIT6    =  000006     |     BIT7    =  000007     |   1 BKSLA      001023 R
  1 BKSP       00118D R   |     BKSPP   =  000008     |   1 BLANK      000905 R
    BLOCK_SI=  000080     |     BOOT_ROM=  006000     |     BOOT_ROM=  007FFF 
  1 BRAN       000207 R   |     BS      =  000008     |     BUFOUT  =  000003 
  1 BYE        00003D R   |     CALLL   =  0000CD     |     CAN     =  000018 
    CAN_DGR =  005426     |     CAN_FPSR=  005427     |     CAN_IER =  005425 
    CAN_MCR =  005420     |     CAN_MSR =  005421     |     CAN_P0  =  005428 
    CAN_P1  =  005429     |     CAN_P2  =  00542A     |     CAN_P3  =  00542B 
    CAN_P4  =  00542C     |     CAN_P5  =  00542D     |     CAN_P6  =  00542E 
    CAN_P7  =  00542F     |     CAN_P8  =  005430     |     CAN_P9  =  005431 
    CAN_PA  =  005432     |     CAN_PB  =  005433     |     CAN_PC  =  005434 
    CAN_PD  =  005435     |     CAN_PE  =  005436     |     CAN_PF  =  005437 
    CAN_RFR =  005424     |     CAN_TPR =  005423     |     CAN_TSR =  005422 
    CARRY   =  00004C     |     CASE_SEN=  000000     |   1 CAT        000254 R
  1 CCOMMA     0013E0 R   |     CC_C    =  000000     |     CC_H    =  000004 
    CC_I0   =  000003     |     CC_I1   =  000005     |     CC_N    =  000002 
    CC_V    =  000007     |     CC_Z    =  000001     |     CELLL   =  000002 
  1 CELLM      00088A R   |   1 CELLP      00087B R   |   1 CELLS      000899 R
    CELL_SIZ=  000002 G   |     CFG_GCR =  007F60     |     CFG_GCR_=  000001 
    CFG_GCR_=  000000     |   1 CHAR1      000E0F R   |   1 CHAR2      000E12 R
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 137.
Hexadecimal [24-Bits]

Symbol Table

    CLKOPT  =  004807     |     CLKOPT_C=  000002     |     CLKOPT_E=  000003 
    CLKOPT_P=  000000     |     CLKOPT_P=  000001     |     CLK_CCOR=  0050C9 
    CLK_CKDI=  0050C6     |     CLK_CKDI=  000000     |     CLK_CKDI=  000001 
    CLK_CKDI=  000002     |     CLK_CKDI=  000003     |     CLK_CKDI=  000004 
    CLK_CMSR=  0050C3     |     CLK_CSSR=  0050C8     |     CLK_ECKR=  0050C1 
    CLK_ECKR=  000000     |     CLK_ECKR=  000001     |     CLK_HSIT=  0050CC 
    CLK_ICKR=  0050C0     |     CLK_ICKR=  000002     |     CLK_ICKR=  000000 
    CLK_ICKR=  000001     |     CLK_ICKR=  000003     |     CLK_ICKR=  000004 
    CLK_ICKR=  000005     |     CLK_PCKE=  0050C7     |     CLK_PCKE=  000000 
    CLK_PCKE=  000001     |     CLK_PCKE=  000007     |     CLK_PCKE=  000005 
    CLK_PCKE=  000006     |     CLK_PCKE=  000004     |     CLK_PCKE=  000002 
    CLK_PCKE=  000003     |     CLK_PCKE=  0050CA     |     CLK_PCKE=  000003 
    CLK_PCKE=  000002     |     CLK_PCKE=  000007     |     CLK_SWCR=  0050C5 
    CLK_SWCR=  000000     |     CLK_SWCR=  000001     |     CLK_SWCR=  000002 
    CLK_SWCR=  000003     |     CLK_SWIM=  0050CD     |     CLK_SWR =  0050C4 
    CLK_SWR_=  0000B4     |     CLK_SWR_=  0000E1     |     CLK_SWR_=  0000D2 
  1 CMOV1      000A55 R   |   1 CMOV2      000A69 R   |   1 CMOV3      000A7D R
  1 CMOVE      000A39 R   |     CNT     =  000001     |   1 CNTXT      0004A1 R
  1 COLD       001940 R   |   1 COLD1      001940 R   |   1 COLN       0016C3 R
    COLON   =  00003A     |   1 COMA       0013C9 R   |     COMMA   =  00002C 
  1 COMPI      00140E R   |     COMPO   =  000040     |   1 COMPONLY   001701 R
  1 CONSTANT   001740 R   |   1 COUNT      0009D5 R   |     CPU_A   =  007F00 
    CPU_CCR =  007F0A     |     CPU_PCE =  007F01     |     CPU_PCH =  007F02 
    CPU_PCL =  007F03     |     CPU_SPH =  007F08     |     CPU_SPL =  007F09 
    CPU_XH  =  007F04     |     CPU_XL  =  007F05     |     CPU_YH  =  007F06 
    CPU_YL  =  007F07     |     CR      =  00000D     |   1 CREAT      001712 R
  1 CRLF       000E38 R   |     CRR     =  00000D     |   1 CSTOR      000243 R
    CTRL_A  =  000001     |     CTRL_B  =  000002     |     CTRL_C  =  000003 
    CTRL_D  =  000004     |     CTRL_E  =  000005     |     CTRL_F  =  000006 
    CTRL_G  =  000007     |     CTRL_H  =  000008     |     CTRL_I  =  000009 
    CTRL_J  =  00000A     |     CTRL_K  =  00000B     |     CTRL_L  =  00000C 
    CTRL_M  =  00000D     |     CTRL_N  =  00000E     |     CTRL_O  =  00000F 
    CTRL_P  =  000010     |     CTRL_Q  =  000011     |     CTRL_R  =  000012 
    CTRL_S  =  000013     |     CTRL_T  =  000014     |     CTRL_U  =  000015 
    CTRL_V  =  000016     |     CTRL_W  =  000017     |     CTRL_X  =  000018 
    CTRL_Y  =  000019     |     CTRL_Z  =  00001A     |   1 DAT        0009B9 R
    DATSTK  =  001680     |     DBL_SIZE=  000004     |     DC1     =  000011 
    DC2     =  000012     |     DC3     =  000013     |     DC4     =  000014 
  1 DCONST     001766 R   |   1 DDROP      00051F R   |   1 DDUP       00052A R
    DEBUG   =  000000     |     DEBUG_BA=  007F00     |     DEBUG_EN=  007FFF 
  1 DECIM      000BCA R   |   1 DEPTH      000954 R   |     DEVID_BA=  0048CD 
    DEVID_EN=  0048D8     |     DEVID_LO=  0048D2     |     DEVID_LO=  0048D3 
    DEVID_LO=  0048D4     |     DEVID_LO=  0048D5     |     DEVID_LO=  0048D6 
    DEVID_LO=  0048D7     |     DEVID_LO=  0048D8     |     DEVID_WA=  0048D1 
    DEVID_XH=  0048CE     |     DEVID_XL=  0048CD     |     DEVID_YH=  0048D0 
    DEVID_YL=  0048CF     |   1 DGTQ1      000C0F R   |   1 DIG        000B43 R
  1 DIGIT      000ADE R   |   1 DIGS       000B54 R   |   1 DIGS1      000B54 R
  1 DIGS2      000B61 R   |   1 DIGTQ      000BDE R   |     DLE     =  000010 
    DM_BK1RE=  007F90     |     DM_BK1RH=  007F91     |     DM_BK1RL=  007F92 
    DM_BK2RE=  007F93     |     DM_BK2RH=  007F94     |     DM_BK2RL=  007F95 
    DM_CR1  =  007F96     |     DM_CR2  =  007F97     |     DM_CSR1 =  007F98 
    DM_CSR2 =  007F99     |     DM_ENFCT=  007F9A     |   1 DN1        0005B6 R
  1 DNEGA      00059B R   |   1 DOCONST    001751 R   |   1 DOLIT      0001C2 R
  1 DONXT      0001D6 R   |   1 DOSTR      000E48 R   |   1 DOT        000EDE R
  1 DOT1       000EF3 R   |   1 DOTI1      0018A7 R   |   1 DOTID      001891 R
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 138.
Hexadecimal [24-Bits]

Symbol Table

  1 DOTO1      001326 R   |   1 DOTOK      00130C R   |   1 DOTPR      001005 R
  1 DOTQ       00157E R   |   1 DOTQP      000E65 R   |   1 DOTR       000E73 R
  1 DOTS       001833 R   |   1 DOTS1      00183E R   |   1 DOTS2      001847 R
  1 DOVAR      000422 R   |   1 DO_DCONS   00177A R   |     DP      =  000005 
  1 DROP       000362 R   |   1 DSTOR      0009A0 R   |   1 DUMP       0017E9 R
  1 DUMP1      001800 R   |   1 DUMP3      001822 R   |   1 DUMPP      0017B8 R
  1 DUPP       00036C R   |   1 EDIGS      000B7F R   |     EEPROM_B=  004000 
    EEPROM_E=  0043FF     |     EEPROM_S=  000400     |   1 ELSEE      0014DD R
    EM      =  000019     |   1 EMIT       000189 R   |     ENQ     =  000005 
    EOF     =  0000FF     |     EOL_CR  =  000001     |     EOL_LF  =  000000 
    EOT     =  000004     |   1 EQ1        00060A R   |   1 EQUAL      0005FD R
  1 ERASE      000AAC R   |     ERR     =  00001B     |     ESC     =  00001B 
    ETB     =  000017     |     ETX     =  000003     |   1 EVAL       00134F R
  1 EVAL1      00134F R   |   1 EVAL2      001368 R   |   1 EXE1       000A30 R
  1 EXECU      000217 R   |     EXTI_CR1=  0050A0     |     EXTI_CR2=  0050A1 
  1 EXTRC      000B06 R   |   1 FALSE      00056B R   |     FAUTO   =  000006 
    FCOMP   =  000005     |   1 FC_XOFF    0001B6 R   |   1 FC_XON     0001A0 R
    FF      =  00000C     |     FHSE    =  7A1200     |     FHSI    =  F42400 
  1 FILL       000A8C R   |   1 FILL0      000A9A R   |   1 FILL1      000AA2 R
  1 FIND       0010E9 R   |   1 FIND1      001107 R   |   1 FIND2      001135 R
  1 FIND3      001141 R   |   1 FIND4      001155 R   |   1 FIND5      001162 R
  1 FIND6      001146 R   |     FIRST_DA=  000004     |     FLASH_BA=  008000 
    FLASH_CR=  00505A     |     FLASH_CR=  000002     |     FLASH_CR=  000000 
    FLASH_CR=  000003     |     FLASH_CR=  000001     |     FLASH_CR=  00505B 
    FLASH_CR=  000005     |     FLASH_CR=  000004     |     FLASH_CR=  000007 
    FLASH_CR=  000000     |     FLASH_CR=  000006     |     FLASH_DU=  005064 
    FLASH_DU=  0000AE     |     FLASH_DU=  000056     |     FLASH_EN=  017FFF 
    FLASH_FP=  00505D     |     FLASH_FP=  000000     |     FLASH_FP=  000001 
    FLASH_FP=  000002     |     FLASH_FP=  000003     |     FLASH_FP=  000004 
    FLASH_FP=  000005     |     FLASH_IA=  00505F     |     FLASH_IA=  000003 
    FLASH_IA=  000002     |     FLASH_IA=  000006     |     FLASH_IA=  000001 
    FLASH_IA=  000000     |     FLASH_NC=  00505C     |     FLASH_NF=  00505E 
    FLASH_NF=  000000     |     FLASH_NF=  000001     |     FLASH_NF=  000002 
    FLASH_NF=  000003     |     FLASH_NF=  000004     |     FLASH_NF=  000005 
    FLASH_PU=  005062     |     FLASH_PU=  000056     |     FLASH_PU=  0000AE 
    FLASH_SI=  010000     |     FLASH_WS=  00480D     |     FLSI    =  01F400 
    FMSTR   =  000010     |     FOPT    =  000001     |   1 FOR        001458 R
  1 FORGET     00004A R   |   1 FORGET2    0000CA R   |   1 FORGET4    0000D9 R
  1 FORGET6    000090 R   |     FPTR    =  000052     |     FREE_RAM=  001580 G
    FRUN    =  000000     |     FS      =  00001C     |     FSLEEP  =  000003 
    FSTOP   =  000004     |     FS_BASE =  00C000 G   |     FS_SIZE =  00C000 G
    FTRACE  =  000007     |     GPIO_BAS=  005000     |     GPIO_CR1=  000003 
    GPIO_CR2=  000004     |     GPIO_DDR=  000002     |     GPIO_IDR=  000001 
    GPIO_ODR=  000000     |     GPIO_SIZ=  000005     |   1 GREAT      000656 R
  1 GREAT1     000661 R   |     GS      =  00001D     |   1 HDOT       000EC2 R
  1 HERE       0009EC R   |   1 HEX        000BB5 R   |   1 HI         001911 R
  1 HLD        00048E R   |   1 HOLD       000B2A R   |     HSE     =  000000 
    HSECNT  =  004809     |     HSI     =  000001     |     I2C_BASE=  005210 
    I2C_CCRH=  00521C     |     I2C_CCRH=  000080     |     I2C_CCRH=  0000C0 
    I2C_CCRH=  000080     |     I2C_CCRH=  000000     |     I2C_CCRH=  000001 
    I2C_CCRH=  000000     |     I2C_CCRH=  000006     |     I2C_CCRH=  000007 
    I2C_CCRL=  00521B     |     I2C_CCRL=  00001A     |     I2C_CCRL=  000002 
    I2C_CCRL=  00000D     |     I2C_CCRL=  000050     |     I2C_CCRL=  000090 
    I2C_CCRL=  0000A0     |     I2C_CR1 =  005210     |     I2C_CR1_=  000006 
    I2C_CR1_=  000007     |     I2C_CR1_=  000000     |     I2C_CR2 =  005211 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 139.
Hexadecimal [24-Bits]

Symbol Table

    I2C_CR2_=  000002     |     I2C_CR2_=  000003     |     I2C_CR2_=  000000 
    I2C_CR2_=  000001     |     I2C_CR2_=  000007     |     I2C_DR  =  005216 
    I2C_FREQ=  005212     |     I2C_ITR =  00521A     |     I2C_ITR_=  000002 
    I2C_ITR_=  000000     |     I2C_ITR_=  000001     |     I2C_OARH=  005214 
    I2C_OARH=  000001     |     I2C_OARH=  000002     |     I2C_OARH=  000006 
    I2C_OARH=  000007     |     I2C_OARL=  005213     |     I2C_OARL=  000000 
    I2C_OAR_=  000813     |     I2C_OAR_=  000009     |     I2C_PECR=  00521E 
    I2C_READ=  000001     |     I2C_SR1 =  005217     |     I2C_SR1_=  000003 
    I2C_SR1_=  000001     |     I2C_SR1_=  000002     |     I2C_SR1_=  000006 
    I2C_SR1_=  000000     |     I2C_SR1_=  000004     |     I2C_SR1_=  000007 
    I2C_SR2 =  005218     |     I2C_SR2_=  000002     |     I2C_SR2_=  000001 
    I2C_SR2_=  000000     |     I2C_SR2_=  000003     |     I2C_SR2_=  000005 
    I2C_SR3 =  005219     |     I2C_SR3_=  000001     |     I2C_SR3_=  000007 
    I2C_SR3_=  000004     |     I2C_SR3_=  000000     |     I2C_SR3_=  000002 
    I2C_TRIS=  00521D     |     I2C_TRIS=  000005     |     I2C_TRIS=  000005 
    I2C_TRIS=  000005     |     I2C_TRIS=  000011     |     I2C_TRIS=  000011 
    I2C_TRIS=  000011     |     I2C_WRIT=  000000     |   1 IFETCH     001473 R
  1 IFF        0014B8 R   |     IMEDD   =  000080     |   1 IMM01      0016DD R
  1 IMMED      0016D8 R   |   1 INCH       000172 R   |   1 INN        00044E R
    INPUT_DI=  000000     |     INPUT_EI=  000001     |     INPUT_FL=  000000 
    INPUT_PU=  000001     |   1 INTE1      0012EE R   |   1 INTER      0012C4 R
    INT_ADC2=  000016     |     INT_AUAR=  000012     |     INT_AWU =  000001 
    INT_CAN_=  000008     |     INT_CAN_=  000009     |     INT_CLK =  000002 
    INT_EXTI=  000003     |     INT_EXTI=  000004     |     INT_EXTI=  000005 
    INT_EXTI=  000006     |     INT_EXTI=  000007     |     INT_FLAS=  000018 
    INT_I2C =  000013     |     INT_SIZE=  000002 G   |     INT_SPI =  00000A 
    INT_TIM1=  00000C     |     INT_TIM1=  00000B     |     INT_TIM2=  00000E 
    INT_TIM2=  00000D     |     INT_TIM3=  000010     |     INT_TIM3=  00000F 
    INT_TIM4=  000017     |     INT_TLI =  000000     |     INT_UART=  000011 
    INT_UART=  000015     |     INT_UART=  000014     |     INT_VECT=  008060 
    INT_VECT=  00800C     |     INT_VECT=  008028     |     INT_VECT=  00802C 
    INT_VECT=  008010     |     INT_VECT=  008014     |     INT_VECT=  008018 
    INT_VECT=  00801C     |     INT_VECT=  008020     |     INT_VECT=  008024 
    INT_VECT=  008068     |     INT_VECT=  008054     |     INT_VECT=  008000 
    INT_VECT=  008030     |     INT_VECT=  008038     |     INT_VECT=  008034 
    INT_VECT=  008040     |     INT_VECT=  00803C     |     INT_VECT=  008048 
    INT_VECT=  008044     |     INT_VECT=  008064     |     INT_VECT=  008008 
    INT_VECT=  008004     |     INT_VECT=  008050     |     INT_VECT=  00804C 
    INT_VECT=  00805C     |     INT_VECT=  008058     |   1 INVER      000578 R
    IRET_COD=  000080     |     ITC_SPR1=  007F70     |     ITC_SPR2=  007F71 
    ITC_SPR3=  007F72     |     ITC_SPR4=  007F73     |     ITC_SPR5=  007F74 
    ITC_SPR6=  007F75     |     ITC_SPR7=  007F76     |     ITC_SPR8=  007F77 
    ITC_SPR_=  000001     |     ITC_SPR_=  000000     |     ITC_SPR_=  000003 
    IWDG_KEY=  000055     |     IWDG_KEY=  0000CC     |     IWDG_KEY=  0000AA 
    IWDG_KR =  0050E0     |     IWDG_PR =  0050E1     |     IWDG_RLR=  0050E2 
  1 JFETCH     00147E R   |     JPIMM   =  0000CC     |   1 JSRC       00166E R
  1 JSRC1      001691 R   |   1 JSRC2      0016B4 R   |   1 KEY        000DC2 R
  1 KTAP       0011DA R   |   1 KTAP1      0011FD R   |   1 KTAP2      001200 R
  1 LAST       0004BF R   |   1 LASTN   =  00193B R   |   1 LBRAC      0012FB R
    LED_BIT =  000005     |     LED_MASK=  000020     |     LED_PORT=  00500A 
  1 LESS       000629 R   |     LF      =  00000A     |     LINE_HEA=  000003 
  1 LINK    =  00193B R   |   1 LITER      001430 R   |   1 LOCAL      0002A7 R
  1 LSHIFT     0008C4 R   |   1 LSHIFT1    0008CD R   |   1 LSHIFT4    0008D5 R
  1 LT1        000634 R   |     MAJOR   =  000005     |     MASKK   =  001F7F 
  1 MAX        00066E R   |   1 MAX1       000678 R   |     MAX_LINE=  007FFF 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 140.
Hexadecimal [24-Bits]

Symbol Table

  1 MIN        000682 R   |   1 MIN1       00068C R   |     MINOR   =  000000 
  1 MMOD1      00073B R   |   1 MMOD2      00074F R   |   1 MMOD3      000766 R
  1 MMSM0      0006CB R   |   1 MMSM1      0006DB R   |   1 MMSM3      0006DF R
  1 MMSM4      0006EB R   |   1 MMSMa      0006E6 R   |   1 MMSMb      0006F1 R
  1 MODD       0007C1 R   |   1 MONE       00092B R   |   1 MSEC       00010F R
  1 MSMOD      00071E R   |   1 MSTA1      000853 R   |   1 MSTAR      000830 R
    NAFR    =  004804     |     NAK     =  000015     |   1 NAMEQ      001182 R
  1 NAMET      001093 R   |     NAME_SIZ=  000002     |     NBIT    =  000001 
    NCLKOPT =  004808     |   1 NEGAT      000589 R   |   1 NEG_SIGN   000C67 R
  1 NEX1       0001E3 R   |   1 NEXT       001467 R   |   1 NEXT_CHA   000C18 GR
    NFLASH_W=  00480E     |     NHSECNT =  00480A     |     NLEN_MAS=  00000F 
    NONE_IDX=  0000FF     |     NOPT1   =  004802     |     NOPT2   =  004804 
    NOPT3   =  004806     |     NOPT4   =  004808     |     NOPT5   =  00480A 
    NOPT6   =  00480C     |     NOPT7   =  00480E     |     NOPTBL  =  00487F 
  1 NO_ADJ     000C6F R   |   1 NRAT       0002F2 R   |   1 NRDROP     0002CE R
  1 NROT       0004FF R   |   1 NRSTO      000311 R   |   1 NSIGN      000C4C R
  1 NTIB       00045E R   |     NUBC    =  004802     |     NUCLEO_8=  000001 
    NUCLEO_8=  000000     |   1 NUFQ       000DD3 R   |   1 NUFQ1      000DEC R
  1 NUMBQ      000D60 R   |   1 NUMQ3      000DA1 R   |   1 NUMQ6      000DAB R
  1 NUMQ9      000DB3 R   |     NWDGOPT =  004806     |     NWDGOPT_=  FFFFFFFD 
    NWDGOPT_=  FFFFFFFC     |     NWDGOPT_=  FFFFFFFF     |     NWDGOPT_=  FFFFFFFE 
    OFS_UART=  000002     |     OFS_UART=  000003     |     OFS_UART=  000004 
    OFS_UART=  000005     |     OFS_UART=  000006     |     OFS_UART=  000007 
    OFS_UART=  000008     |     OFS_UART=  000009     |     OFS_UART=  000001 
    OFS_UART=  000009     |     OFS_UART=  00000A     |     OFS_UART=  000000 
  1 ONE        00091D R   |   1 ONEM       0008B3 R   |   1 ONEP       0008A6 R
    OPT0    =  004800     |     OPT1    =  004801     |     OPT2    =  004803 
    OPT3    =  004805     |     OPT4    =  004807     |     OPT5    =  004809 
    OPT6    =  00480B     |     OPT7    =  00480D     |     OPTBL   =  00487E 
    OPTIMIZE=  000001     |     OPTION_B=  004800     |     OPTION_E=  00487F 
    OPTION_S=  000080     |   1 ORIG       000029 R   |   1 ORR        0003DD R
  1 OUTPUT     00018E R   |     OUTPUT_F=  000001     |     OUTPUT_O=  000000 
    OUTPUT_P=  000001     |     OUTPUT_S=  000000     |     OVBIT   =  000002 
  1 OVER       000394 R   |   1 OVERT      001639 R   |     PA      =  000000 
  1 PACKS      000ABD R   |   1 PAD        0009FD R   |     PAD_SIZE=  000080 G
    PAGE0_SI=  000100 G   |   1 PAREN      001014 R   |   1 PARS       000F0D R
  1 PARS1      000F38 R   |   1 PARS2      000F63 R   |   1 PARS3      000F66 R
  1 PARS4      000F6F R   |   1 PARS5      000F92 R   |   1 PARS6      000FA7 R
  1 PARS7      000FB6 R   |   1 PARS8      000FC5 R   |   1 PARSE      000FD6 R
  1 PAUSE      00011F R   |     PA_BASE =  005000     |     PA_CR1  =  005003 
    PA_CR2  =  005004     |     PA_DDR  =  005002     |     PA_IDR  =  005001 
    PA_ODR  =  005000     |     PB      =  000005     |     PB_BASE =  005005 
    PB_CR1  =  005008     |     PB_CR2  =  005009     |     PB_DDR  =  005007 
    PB_IDR  =  005006     |     PB_ODR  =  005005     |     PC      =  00000A 
    PC_BASE =  00500A     |     PC_CR1  =  00500D     |     PC_CR2  =  00500E 
    PC_DDR  =  00500C     |     PC_IDR  =  00500B     |     PC_ODR  =  00500A 
    PD      =  00000F     |   1 PDUM1      0017CB R   |   1 PDUM2      0017DC R
    PD_BASE =  00500F     |     PD_CR1  =  005012     |     PD_CR2  =  005013 
    PD_DDR  =  005011     |     PD_IDR  =  005010     |     PD_ODR  =  00500F 
    PE      =  000014     |     PE_BASE =  005014     |     PE_CR1  =  005017 
    PE_CR2  =  005018     |     PE_DDR  =  005016     |     PE_IDR  =  005015 
    PE_ODR  =  005014     |     PF      =  000019     |     PF_BASE =  005019 
    PF_CR1  =  00501C     |     PF_CR2  =  00501D     |     PF_DDR  =  00501B 
    PF_IDR  =  00501A     |     PF_ODR  =  005019     |     PG      =  00001E 
    PG_BASE =  00501E     |     PG_CR1  =  005021     |     PG_CR2  =  005022 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 141.
Hexadecimal [24-Bits]

Symbol Table

    PG_DDR  =  005020     |     PG_IDR  =  00501F     |     PG_ODR  =  00501E 
    PH      =  000023     |     PH_BASE =  005023     |     PH_CR1  =  005026 
    PH_CR2  =  005027     |     PH_DDR  =  005025     |     PH_IDR  =  005024 
    PH_ODR  =  005023     |     PI      =  000028     |   1 PICK       00096B R
    PI_BASE =  005028     |     PI_CR1  =  00502B     |     PI_CR2  =  00502C 
    PI_DDR  =  00502A     |     PI_IDR  =  005029     |     PI_ODR  =  005028 
  1 PLUS       00053F R   |   1 PNAM1      0015E8 R   |   1 PRESE      001377 R
    PROD1   =  000046     |     PROD2   =  000048     |     PROD3   =  00004A 
  1 PROTECTE   0000BC R   |   1 PSTOR      000982 R   |     PTR16   =  000053 
    PTR8    =  000054     |   1 QBRAN      0001EB R   |   1 QDUP       0004CF R
  1 QDUP1      0004D9 R   |   1 QKEY       000166 R   |   1 QSTAC      001332 R
  1 QUERY      00125A R   |   1 QUEST      000F00 R   |   1 QUIT       001394 R
  1 QUIT1      00139C R   |   1 QUIT2      00139F R   |     RAMBASE =  000030 
    RAM_BASE=  000000     |     RAM_END =  0017FF     |     RAM_SIZE=  001800 
  1 RANDOM     0000FA R   |   1 RAT        000298 R   |   1 RBRAC      00165B R
  1 REPEA      001535 R   |     REV     =  000000     |   1 RFROM      000287 R
    ROP     =  004800     |   1 ROT        0004E0 R   |     ROWBUFF =  001680 
    RP0     =  000050     |   1 RPAT       000264 R   |     RPP     =  0017FF 
  1 RPSTO      000271 R   |     RS      =  00001E     |   1 RSHIFT     0008E0 R
  1 RSHIFT1    0008E9 R   |   1 RSHIFT4    0008F1 R   |     RST_SR  =  0050B3 
    RX_QUEUE=  000008     |   1 SAME1      0010B1 R   |   1 SAME2      0010DA R
  1 SAMEQ      0010A9 R   |   1 SCOM1      00161D R   |   1 SCOM2      001620 R
  1 SCOMP      0015FF R   |   1 SEED       0000E3 R   |     SEMIC   =  00003B 
  1 SEMIS      001649 R   |     SFR_BASE=  005000     |     SFR_END =  0057FF 
    SHARP   =  000023     |     SI      =  00000F     |   1 SIGN       000B69 R
  1 SIGN1      000B79 R   |     SKIP    =  000004     |   1 SKIP_DIG   000C74 R
  1 SLASH      0007CB R   |   1 SLMOD      00076E R   |   1 SLMOD1     0007AB R
  1 SLMOD8     0007B8 R   |   1 SNAME      0015B2 R   |     SO      =  00000E 
    SOH     =  000001     |     SP0     =  00004E     |   1 SPAC       000DF5 R
    SPACE   =  000020     |   1 SPACS      000E04 R   |   1 SPAT       00034C R
    SPI_CR1 =  005200     |     SPI_CR1_=  000003     |     SPI_CR1_=  000000 
    SPI_CR1_=  000001     |     SPI_CR1_=  000007     |     SPI_CR1_=  000002 
    SPI_CR1_=  000006     |     SPI_CR2 =  005201     |     SPI_CR2_=  000007 
    SPI_CR2_=  000006     |     SPI_CR2_=  000005     |     SPI_CR2_=  000004 
    SPI_CR2_=  000002     |     SPI_CR2_=  000000     |     SPI_CR2_=  000001 
    SPI_CRCP=  005205     |     SPI_DR  =  005204     |     SPI_ICR =  005202 
    SPI_RXCR=  005206     |     SPI_SR  =  005203     |     SPI_SR_B=  000007 
    SPI_SR_C=  000004     |     SPI_SR_M=  000005     |     SPI_SR_O=  000006 
    SPI_SR_R=  000000     |     SPI_SR_T=  000001     |     SPI_SR_W=  000003 
    SPI_TXCR=  005207     |     SPP     =  001680     |   1 SPSTO      000359 R
  1 SSMOD      00085C R   |     STACK   =  0017FF     |     STACK_EM=  0017FF 
    STACK_SI=  000080 G   |   1 STAR       000824 R   |   1 STASL      00086D R
    STDOUT  =  000001     |   1 STOD       0005BE R   |   1 STORE      000224 R
  1 STR        000B97 R   |   1 STRCQ      001438 R   |   1 STRQ       001571 R
  1 STRQP      000E61 R   |     STX     =  000002     |     SUB     =  00001A 
  1 SUBB       0005D5 R   |   1 SWAPP      00037C R   |     SWIM_CSR=  007F80 
    SYN     =  000016     |     SYS_SIZE=  004000     |     TAB     =  000009 
    TAB_WIDT=  000004     |   1 TAP        0011C4 R   |   1 TBOOT      001934 R
  1 TBRAN      0001F9 R   |   1 TBUF       00046E R   |     TBUFFBAS=  001680 
  1 TCHAR      00093C R   |   1 TEMP       00043F R   |   1 TEVAL      00047F R
  1 THENN      0014CD R   |   1 TIB        000A0E R   |     TIBB    =  001700 
    TIBBASE =  001700     |     TIB_SIZE=  000080 G   |     TICK    =  000027 
  1 TICKK      0013AB R   |     TIM1_ARR=  005262     |     TIM1_ARR=  005263 
    TIM1_BKR=  00526D     |     TIM1_CCE=  00525C     |     TIM1_CCE=  00525D 
    TIM1_CCM=  005258     |     TIM1_CCM=  000000     |     TIM1_CCM=  000001 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 142.
Hexadecimal [24-Bits]

Symbol Table

    TIM1_CCM=  000004     |     TIM1_CCM=  000005     |     TIM1_CCM=  000006 
    TIM1_CCM=  000007     |     TIM1_CCM=  000002     |     TIM1_CCM=  000003 
    TIM1_CCM=  000007     |     TIM1_CCM=  000002     |     TIM1_CCM=  000004 
    TIM1_CCM=  000005     |     TIM1_CCM=  000006     |     TIM1_CCM=  000003 
    TIM1_CCM=  005259     |     TIM1_CCM=  000000     |     TIM1_CCM=  000001 
    TIM1_CCM=  000004     |     TIM1_CCM=  000005     |     TIM1_CCM=  000006 
    TIM1_CCM=  000007     |     TIM1_CCM=  000002     |     TIM1_CCM=  000003 
    TIM1_CCM=  000007     |     TIM1_CCM=  000002     |     TIM1_CCM=  000004 
    TIM1_CCM=  000005     |     TIM1_CCM=  000006     |     TIM1_CCM=  000003 
    TIM1_CCM=  00525A     |     TIM1_CCM=  000000     |     TIM1_CCM=  000001 
    TIM1_CCM=  000004     |     TIM1_CCM=  000005     |     TIM1_CCM=  000006 
    TIM1_CCM=  000007     |     TIM1_CCM=  000002     |     TIM1_CCM=  000003 
    TIM1_CCM=  000007     |     TIM1_CCM=  000002     |     TIM1_CCM=  000004 
    TIM1_CCM=  000005     |     TIM1_CCM=  000006     |     TIM1_CCM=  000003 
    TIM1_CCM=  00525B     |     TIM1_CCM=  000000     |     TIM1_CCM=  000001 
    TIM1_CCM=  000004     |     TIM1_CCM=  000005     |     TIM1_CCM=  000006 
    TIM1_CCM=  000007     |     TIM1_CCM=  000002     |     TIM1_CCM=  000003 
    TIM1_CCM=  000007     |     TIM1_CCM=  000002     |     TIM1_CCM=  000004 
    TIM1_CCM=  000005     |     TIM1_CCM=  000006     |     TIM1_CCM=  000003 
    TIM1_CCR=  005265     |     TIM1_CCR=  005266     |     TIM1_CCR=  005267 
    TIM1_CCR=  005268     |     TIM1_CCR=  005269     |     TIM1_CCR=  00526A 
    TIM1_CCR=  00526B     |     TIM1_CCR=  00526C     |     TIM1_CNT=  00525E 
    TIM1_CNT=  00525F     |     TIM1_CR1=  005250     |     TIM1_CR2=  005251 
    TIM1_CR2=  000000     |     TIM1_CR2=  000002     |     TIM1_CR2=  000004 
    TIM1_CR2=  000005     |     TIM1_CR2=  000006     |     TIM1_DTR=  00526E 
    TIM1_EGR=  005257     |     TIM1_EGR=  000007     |     TIM1_EGR=  000001 
    TIM1_EGR=  000002     |     TIM1_EGR=  000003     |     TIM1_EGR=  000004 
    TIM1_EGR=  000005     |     TIM1_EGR=  000006     |     TIM1_EGR=  000000 
    TIM1_ETR=  005253     |     TIM1_ETR=  000006     |     TIM1_ETR=  000000 
    TIM1_ETR=  000001     |     TIM1_ETR=  000002     |     TIM1_ETR=  000003 
    TIM1_ETR=  000007     |     TIM1_ETR=  000004     |     TIM1_ETR=  000005 
    TIM1_IER=  005254     |     TIM1_IER=  000007     |     TIM1_IER=  000001 
    TIM1_IER=  000002     |     TIM1_IER=  000003     |     TIM1_IER=  000004 
    TIM1_IER=  000005     |     TIM1_IER=  000006     |     TIM1_IER=  000000 
    TIM1_OIS=  00526F     |     TIM1_PSC=  005260     |     TIM1_PSC=  005261 
    TIM1_RCR=  005264     |     TIM1_SMC=  005252     |     TIM1_SMC=  000007 
    TIM1_SMC=  000000     |     TIM1_SMC=  000001     |     TIM1_SMC=  000002 
    TIM1_SMC=  000004     |     TIM1_SMC=  000005     |     TIM1_SMC=  000006 
    TIM1_SR1=  005255     |     TIM1_SR1=  000007     |     TIM1_SR1=  000001 
    TIM1_SR1=  000002     |     TIM1_SR1=  000003     |     TIM1_SR1=  000004 
    TIM1_SR1=  000005     |     TIM1_SR1=  000006     |     TIM1_SR1=  000000 
    TIM1_SR2=  005256     |     TIM1_SR2=  000001     |     TIM1_SR2=  000002 
    TIM1_SR2=  000003     |     TIM1_SR2=  000004     |     TIM2_ARR=  00530D 
    TIM2_ARR=  00530E     |     TIM2_CCE=  005308     |     TIM2_CCE=  000000 
    TIM2_CCE=  000001     |     TIM2_CCE=  000004     |     TIM2_CCE=  000005 
    TIM2_CCE=  005309     |     TIM2_CCM=  005305     |     TIM2_CCM=  005306 
    TIM2_CCM=  005307     |     TIM2_CCM=  000000     |     TIM2_CCM=  000004 
    TIM2_CCM=  000003     |     TIM2_CCR=  00530F     |     TIM2_CCR=  005310 
    TIM2_CCR=  005311     |     TIM2_CCR=  005312     |     TIM2_CCR=  005313 
    TIM2_CCR=  005314     |     TIM2_CLK=  00F424     |     TIM2_CNT=  00530A 
    TIM2_CNT=  00530B     |     TIM2_CR1=  005300     |     TIM2_CR1=  000007 
    TIM2_CR1=  000000     |     TIM2_CR1=  000003     |     TIM2_CR1=  000001 
    TIM2_CR1=  000002     |     TIM2_EGR=  005304     |     TIM2_EGR=  000001 
    TIM2_EGR=  000002     |     TIM2_EGR=  000003     |     TIM2_EGR=  000006 
    TIM2_EGR=  000000     |     TIM2_IER=  005301     |     TIM2_PSC=  00530C 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 143.
Hexadecimal [24-Bits]

Symbol Table

    TIM2_SR1=  005302     |     TIM2_SR2=  005303     |     TIM3_ARR=  00532B 
    TIM3_ARR=  00532C     |     TIM3_CCE=  005327     |     TIM3_CCE=  000000 
    TIM3_CCE=  000001     |     TIM3_CCE=  000004     |     TIM3_CCE=  000005 
    TIM3_CCE=  000000     |     TIM3_CCE=  000001     |     TIM3_CCM=  005325 
    TIM3_CCM=  005326     |     TIM3_CCM=  000000     |     TIM3_CCM=  000004 
    TIM3_CCM=  000003     |     TIM3_CCR=  00532D     |     TIM3_CCR=  00532E 
    TIM3_CCR=  00532F     |     TIM3_CCR=  005330     |     TIM3_CNT=  005328 
    TIM3_CNT=  005329     |     TIM3_CR1=  005320     |     TIM3_CR1=  000007 
    TIM3_CR1=  000000     |     TIM3_CR1=  000003     |     TIM3_CR1=  000001 
    TIM3_CR1=  000002     |     TIM3_EGR=  005324     |     TIM3_IER=  005321 
    TIM3_PSC=  00532A     |     TIM3_SR1=  005322     |     TIM3_SR2=  005323 
    TIM4_ARR=  005346     |     TIM4_CNT=  005344     |     TIM4_CR1=  005340 
    TIM4_CR1=  000007     |     TIM4_CR1=  000000     |     TIM4_CR1=  000003 
    TIM4_CR1=  000001     |     TIM4_CR1=  000002     |     TIM4_EGR=  005343 
    TIM4_EGR=  000000     |     TIM4_IER=  005341     |     TIM4_IER=  000000 
    TIM4_PSC=  005345     |     TIM4_PSC=  000000     |     TIM4_PSC=  000007 
    TIM4_PSC=  000004     |     TIM4_PSC=  000001     |     TIM4_PSC=  000005 
    TIM4_PSC=  000002     |     TIM4_PSC=  000006     |     TIM4_PSC=  000003 
    TIM4_PSC=  000000     |     TIM4_PSC=  000001     |     TIM4_PSC=  000002 
    TIM4_SR =  005342     |     TIM4_SR_=  000000     |   1 TIMEOUTQ   000150 R
  1 TIMER      00013A R   |     TIM_CR1_=  000007     |     TIM_CR1_=  000000 
    TIM_CR1_=  000006     |     TIM_CR1_=  000005     |     TIM_CR1_=  000004 
    TIM_CR1_=  000003     |     TIM_CR1_=  000001     |     TIM_CR1_=  000002 
  1 TNAM2      001861 R   |   1 TNAM3      00187F R   |   1 TNAM4      001885 R
  1 TNAME      00185E R   |   1 TOKEN      001085 R   |   1 TOR        000335 R
    TOS     =  000001     |   1 TRUE       00055A R   |     TRUEE   =  00FFFF 
  1 TWOSL      0008F8 R   |   1 TWOSTAR    000899 R   |   1 TYPE1      000E24 R
  1 TYPE2      000E2A R   |   1 TYPES      000E1F R   |     TYPE_CON=  000020 
    TYPE_DVA=  000010     |     TYPE_MAS=  0000F0     |     UART    =  000002 
    UART1   =  000000     |     UART1_BA=  005230     |     UART1_BR=  005232 
    UART1_BR=  005233     |     UART1_CR=  005234     |     UART1_CR=  005235 
    UART1_CR=  005236     |     UART1_CR=  005237     |     UART1_CR=  005238 
    UART1_DR=  005231     |     UART1_GT=  005239     |     UART1_PO=  000000 
    UART1_PS=  00523A     |     UART1_RX=  000004     |     UART1_SR=  005230 
    UART1_TX=  000005     |     UART2   =  000001     |     UART3   =  000002 
    UART3_BA=  005240     |     UART3_BR=  005242     |     UART3_BR=  005243 
    UART3_CR=  005244     |     UART3_CR=  005245     |     UART3_CR=  005246 
    UART3_CR=  005247     |     UART3_CR=  005249     |     UART3_DR=  005241 
    UART3_PO=  00000F     |     UART3_RX=  000006     |     UART3_SR=  005240 
    UART3_TX=  000005     |     UART_BRR=  005242     |     UART_BRR=  005243 
    UART_CR1=  005244     |     UART_CR1=  000004     |     UART_CR1=  000002 
    UART_CR1=  000000     |     UART_CR1=  000001     |     UART_CR1=  000007 
    UART_CR1=  000006     |     UART_CR1=  000005     |     UART_CR1=  000003 
    UART_CR2=  005245     |     UART_CR2=  000004     |     UART_CR2=  000002 
    UART_CR2=  000005     |     UART_CR2=  000001     |     UART_CR2=  000000 
    UART_CR2=  000006     |     UART_CR2=  000003     |     UART_CR2=  000007 
    UART_CR3=  000003     |     UART_CR3=  000001     |     UART_CR3=  000002 
    UART_CR3=  000000     |     UART_CR3=  000006     |     UART_CR3=  000004 
    UART_CR3=  000005     |     UART_CR4=  000000     |     UART_CR4=  000001 
    UART_CR4=  000002     |     UART_CR4=  000003     |     UART_CR4=  000004 
    UART_CR4=  000006     |     UART_CR4=  000005     |     UART_CR5=  000003 
    UART_CR5=  000001     |     UART_CR5=  000002     |     UART_CR5=  000004 
    UART_CR5=  000005     |     UART_CR6=  000004     |     UART_CR6=  000007 
    UART_CR6=  000001     |     UART_CR6=  000002     |     UART_CR6=  000000 
    UART_CR6=  000005     |     UART_DR =  005241     |     UART_PCK=  000003 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 144.
Hexadecimal [24-Bits]

Symbol Table

    UART_POR=  00500D     |     UART_POR=  00500E     |     UART_POR=  00500C 
    UART_POR=  00500B     |     UART_POR=  00500A     |     UART_RX_=  000006 
    UART_SR =  005240     |     UART_SR_=  000001     |     UART_SR_=  000004 
    UART_SR_=  000002     |     UART_SR_=  000003     |     UART_SR_=  000000 
    UART_SR_=  000005     |     UART_SR_=  000006     |     UART_SR_=  000007 
    UART_TX_=  000005     |     UBASE   =  000030     |     UBC     =  004801 
    UCNTXT  =  000040     |     UCTIB   =  000038     |     UD1     =  000001 
    UD2     =  000002     |     UD3     =  000003     |     UD4     =  000004 
  1 UDOT       000EAE R   |   1 UDOTR      000E8E R   |   1 UEND       000027 R
    UFPSW   =  000032     |   1 UGREAT     000640 R   |   1 UGREAT1    00064B R
    UHLD    =  00003E     |     UINN    =  000036     |     UINT    =  000002 
    UINTER  =  00003C     |     ULAST   =  000042     |   1 ULES1      00061E R
  1 ULESS      000613 R   |   1 UMMOD      0006B4 R   |   1 UMSTA      0007DA R
  1 UNIQ1      0015AF R   |   1 UNIQU      001590 R   |   1 UNTIL      001498 R
  1 UPL1       00041E R   |   1 UPLUS      000407 R   |     UPP     =  000030 
  1 UPPER      001048 R   |   1 UPPER1     00106B R   |   1 UPPER2     001074 R
    US      =  00001F     |   1 USLMOD     000703 R   |     UTIB    =  00003A 
    UTMP    =  000034     |   1 UTYP1      00179B R   |   1 UTYP2      0017AA R
  1 UTYPE      001796 R   |     UVP     =  000044     |   1 UZERO      000011 R
  1 VARIA      00172C R   |     VARS_SIZ=  000004     |     VAR_BASE=  0000B0 
    VAR_TOP =  001640     |   1 VPP        0004AF R   |     VT      =  00000B 
    WANT_CON=  000000     |     WANT_DOU=  000000     |     WANT_FLO=  000000 
    WANT_FLO=  000000     |     WANT_SCA=  000000     |     WANT_SEE=  000000 
    WDGOPT  =  004805     |     WDGOPT_I=  000002     |     WDGOPT_L=  000003 
    WDGOPT_W=  000000     |     WDGOPT_W=  000001     |   1 WHILE      00151B R
  1 WITHI      000699 R   |   1 WORDD      00102E R   |   1 WORDS      0018BB R
  1 WORS1      0018C1 R   |   1 WORS2      0018DD R   |     WWDG_CR =  0050D1 
    WWDG_WR =  0050D2     |     XOFF    =  000013     |     XON     =  000011 
  1 XORR       0003F2 R   |     XTEMP   =  000046     |     YTEMP   =  000048 
    YTMP    =  000003     |     ZBIT    =  000000     |   1 ZEQU1      0003BF R
  1 ZEQUAL     0003B5 R   |   1 ZERO       000912 R   |   1 ZL1        0003AC R
  1 ZLESS      0003A3 R   |     app_info   ****** GX  |   1 clear_ra   000003 R
  1 forth_cp   0018E7 R   |   1 forth_in   000000 GR  |   1 forth_na   0018DE R
  1 parse_di   000CB6 R   |     prng       ****** GX  |   1 putc       00018E R
    set_seed   ****** GX  |     ticks      ****** GX  |     timer      ****** GX
    u1hi    =  000002     |     u1lo    =  000003     |     u2hi    =  000000 
    u2lo    =  000001     |     uart_get   ****** GX  |     uart_qge   ****** GX

ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 145.
Hexadecimal [24-Bits]

Area Table

   0 _CODE      size      0   flags    0
   1 CODE       size   1961   flags    0

